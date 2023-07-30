"""
Let's take the previous example and add some exciting new features to make it even more enjoyable! We'll leverage asynchronous programming to store the measured data on the TMEP.cz service and also save it to an SD card.

To get started, let's set up a TMEP.cz account and create a new device. Once done, you'll receive a unique domain name for your device. Don't forget to set the domain name as an environment variable named TMEP_DOMAIN in the settings.toml file.

Next, ensure you've set the WiFi SSID and password as environment variables CIRCUITPY_WIFI_SSID and CIRCUITPY_WIFI_PASSWORD in the settings.toml file.

Now, let's enhance the data recording capability by utilizing a microSD card. Insert the microSD card into the Picopad. Alongside the data, we'd also like to store the measurement date and time accurately.
To achieve this, we'll use NTP and RTC (Real-Time Clock) to get the current date and time.

We will define three asynchonous tasks:
- measure_and_display task: to measure the sensor data and display them on the screen every 5 seconds
- send_to_tmep task: to send the measured data to TMEP.cz service every 5 minutes
- save_to_sdcard task: to save the measured data to SD card every 2 minutes

You can find the required libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import busio
import time
import adafruit_scd4x
import displayio
import terminalio
from adafruit_display_text import label
import adafruit_imageload
import asyncio

import wifi
import ssl
import socketpool
import os

import adafruit_requests
import adafruit_ntp
import rtc

import busio
import sdcardio
import storage



# Measurement class to store the sensor data in a structured way
class Measurement:
    def __init__(self, name, tag, type, value, unit):
        # name: human-readable name of the measured value - e.g. Temperature
        self.name = name
        # tag: identifier of the measured value, usefull for data processing - e.g. temp1
        self.tag = tag
        # type: type of the measured value, useful for visualization - e.g. temperature
        self.type = type
        # value: the measured value itself - e.g. 25.6
        self.value = value
        # unit: unit of the measured value - e.g. °C
        self.unit = unit

    # basic string representation of the Measurement object
    def __str__(self):
        return "%s: %.1f %s" % (self.name, self.value, self.unit)

# Sensor class to handle the sensor inicialization and data collection
class Sensor:
    def __init__(self):
        # store the measured values in a list of Measurement objects
        self.measurements = []
        # initialize i2c bus and SCD4x sensor
        i2c = busio.I2C(board.SCL, board.SDA)
        self.sensor = adafruit_scd4x.SCD4X(i2c)
        self.sensor.start_periodic_measurement()

    # measure the sensor data and return a list of Measurement objects
    def measure(self):
        self.measurements = []
        # wait for data to be ready
        while not self.sensor.data_ready:
            time.sleep(1)

        # Read data from sensor and save them into the list of Measurement objects
        # SCD4x sensor measures temperature, relative humidity and CO2, so we will add three measurements
        
        measurement = Measurement(
            "Temperature", "temp", "temperature", self.sensor.temperature, "°C")
        self.measurements.append(measurement)

        measurement = Measurement(
            "Humidity", "humi", "humidity", self.sensor.relative_humidity, "%")
        self.measurements.append(measurement)
        
        measurement = Measurement(
            "CO2", "CO2", "co2", self.sensor.CO2, "ppm")
        self.measurements.append(measurement)

        return self.measurements
    # return the list of Measurement objects
    def get_measurements(self):
        return self.measurements
    
    # return onyl one Measurement object with the specified tag
    def get_measurement(self, tag):
        for measurement in self.measurements:
            if measurement.tag == tag:
                return measurement
        return None




# Setup SD card and mount it to /sd directory
spi = busio.SPI(board.SD_SCK, MOSI=board.SD_MOSI, MISO=board.SD_MISO)
cs = board.SD_CS
sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")


# initialize the display
display = board.DISPLAY
group = displayio.Group(scale=2)

# prepare the text areas for the measured values
text_areas = {
    'temp': label.Label(terminalio.FONT, text='', color=0xFFFFFF, x=45, y=25),
    'humi': label.Label(terminalio.FONT, text='', color=0xFFFFFF, x=45, y=65),
    'CO2': label.Label(terminalio.FONT, text='', color=0xFFFFFF, x=45, y=95)
}

group.append(text_areas['temp'])
group.append(text_areas['humi'])
group.append(text_areas['CO2'])

# we will use a sprite sheet to display the icons, color on index 6 will be transparent
sprite_sheet, palette = adafruit_imageload.load("/assets.bmp")
palette.make_transparent(6)

sprite_temp = displayio.TileGrid(sprite_sheet, pixel_shader=palette,
                            width = 1,
                            height = 1,
                            tile_width = 16,
                            tile_height = 32,
                            default_tile = 0
                            )

sprite_humi = displayio.TileGrid(sprite_sheet, pixel_shader=palette,
                            width = 1,
                            height = 1,
                            tile_width = 16,
                            tile_height = 32,
                            default_tile = 1
                            )

sprite_CO2 = displayio.TileGrid(sprite_sheet, pixel_shader=palette,
                            width = 1,
                            height = 1,
                            tile_width = 16,
                            tile_height = 32,
                            default_tile = 2
                            )

sprite_temp.x = 20
sprite_temp.y = 10

sprite_humi.x = 20
sprite_humi.y = 50

sprite_CO2.x = 20
sprite_CO2.y = 80

group.append(sprite_temp)
group.append(sprite_humi)
group.append(sprite_CO2)

display.show(group)

# initialize the sensor
sensor = Sensor()

# global variable to store the measured values
measurements = None

# Initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

pool = socketpool.SocketPool(wifi.radio)
requests = adafruit_requests.Session(pool, ssl.create_default_context()) 

# Set up NTP
ntp = adafruit_ntp.NTP(pool, tz_offset=2)
# Set up RTC
rtc.RTC().datetime = ntp.datetime
print("Time synced from NTP")


# Asynchronous function to send the data to TMEP.cz - every 5 minutes
async def send_to_tmep():
    global measurements
    global requests
    while True:
        if measurements:
            # generate TMEP URL
            query_string = "?"
            for measurement in measurements:
                query_string += measurement.tag + "=" + str(measurement.value) + "&"
            url = "http://%s/%s" % (os.getenv('TMEP_DOMAIN'), query_string)
            # print(url)
            
            requests.get(url)
            print("Data send to TMEP")                    

        await asyncio.sleep(5*60)  # Sleep for 5 minutes


# Asynchronous function to save the data to SD card - every 2 minutes
async def save_to_sdcard():
    global measurements
    global requests
    while True:
        if measurements:
            with open("/sd/data.csv", "a") as f:
                temp = sensor.get_measurement("temp")
                humi = sensor.get_measurement("humi")
                co2 = sensor.get_measurement("CO2")
                # prepare the date and time string
                dt = rtc.RTC().datetime
                date = "%04d-%02d-%02d %02d:%02d:%02d" %(dt.tm_year, dt.tm_mon, dt.tm_mday, dt.tm_hour, dt.tm_min, dt.tm_sec)

                f.write("%s;%s;%s;%s\n" % (date, temp.value, humi.value, co2.value))

            print("Data saved to SD card")

        await asyncio.sleep(2*60)  # Sleep for 2 minutes


# Asynchronous function to measure and update the display
async def measure_and_display(sensor, text_areas, display):
    global measurements
    while True:
        # measure the sensor data
        measurements = sensor.measure()

        # update the display
        for measurement in measurements:
            text_areas[measurement.tag].text = "%.1f %s" %(measurement.value, measurement.unit)
        display.refresh()

        await asyncio.sleep(5)  # Sleep for 5 seconds


# Prepare the event loop
loop = asyncio.get_event_loop()

# Schedule both tasks to run concurrently
loop.run_until_complete(asyncio.gather(
    send_to_tmep(),
    save_to_sdcard(),
    measure_and_display(sensor, text_areas, display)
))