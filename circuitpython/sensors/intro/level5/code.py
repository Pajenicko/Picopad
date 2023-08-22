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
import displayio
from adafruit_display_text import label
import adafruit_imageload
import asyncio
import digitalio
from extra_font import ExtraFont

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


from sensor_scd4x import Sensor
# if you don't have SCD4x, you can try use internal temperature sensor of rp2040 as a demo
# from sensor_internal import Sensor

# global variable to store the measured values
measurements = None


# initialize the display
display = board.DISPLAY
group = displayio.Group(scale=2)

# The built-in missing some useful glyphs (characters) e.g. degree (°), so I made a small workaround.
# ExtraFont class from extra_font.py extends the terminalio.FONT and adds the missing character from extra.bdf bitmap font contains only that glyph. 
font = ExtraFont()

# initialize the sensor
sensor = Sensor()

# initialize the LED
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT


# we will use a sprite sheet to display the icons, color on index 3 will be transparent
sprite_sheet, palette = adafruit_imageload.load("/assets.bmp")
palette.make_transparent(3)

# prepare the text areas for the measured values
top = 20
increment = 40

text_areas = {}

types_to_icons = {
    "temperature": 0,
    "humidity": 1,
    "co2": 2,
    "pressure": 3,
}

for reading, data in sensor.readings.items():
    text_areas[reading] = label.Label(font, text='', color=0xFFFFFF, x=45, y=top)

    group.append(text_areas[reading])

    sprite = displayio.TileGrid(sprite_sheet, pixel_shader=palette,
                            width = 1,
                            height = 1,
                            tile_width = 16,
                            tile_height = 32,
                            default_tile = types_to_icons[data["type"]]
                            )
    sprite.x = 20
    sprite.y = top - 15
    group.append(sprite)
    top += increment

display.show(group)



# Setup SD card and mount it to /sd directory
spi = busio.SPI(board.SD_SCK, MOSI=board.SD_MOSI, MISO=board.SD_MISO)
cs = board.SD_CS
sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")


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