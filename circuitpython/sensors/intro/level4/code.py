"""
In this advanced example, we will build upon our previous work with the Sensirion SCD4x sensor, custom classes and display.
We will now enhance the project with asynchronous programming to manage concurrent tasks efficiently.

We will define two asynchonous tasks:
- measure_and_display task: to measure the sensor data and display them on the screen
- blink_led task: to blink the LED every second - just for fun

It requires the adafruit_scd4x, adafruit_display_text, adafruit_imageload and asyncio libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
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
import digitalio

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

led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT


# Asynchronous function to blink the LED
async def blink_led(led):
    while True:
        led.value = not led.value  # Toggle LED
        await asyncio.sleep(0.5)  # Sleep for 0.5 second

# Asynchronous function to measure and update the display
async def measure_and_display(sensor, text_areas, display):
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
    blink_led(led),
    measure_and_display(sensor, text_areas, display)
))