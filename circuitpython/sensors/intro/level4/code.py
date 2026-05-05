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
import displayio
from adafruit_display_text import label
import adafruit_imageload
import asyncio
import digitalio
from extra_font import ExtraFont

from sensor_scd4x import Sensor
# if you don't have SCD4x, you can try use internal temperature sensor of rp2040 as a demo
# from sensor_internal import Sensor

# initialize the display
display = board.DISPLAY

# The built-in missing some useful glyphs (characters) e.g. degree (°), so I made a small workaround.
# ExtraFont class from extra_font.py extends the terminalio.FONT and adds the missing character from extra.bdf bitmap font contains only that glyph. 
font = ExtraFont()

group = displayio.Group(scale=2)

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

display.root_group = group


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
            text_areas[measurement.tag].text = f"{measurement.value:.1f} {measurement.unit}"
        display.refresh()

        await asyncio.sleep(5)  # Sleep for 5 seconds


# Prepare the event loop
loop = asyncio.get_event_loop()

# Schedule both tasks to run concurrently
loop.run_until_complete(asyncio.gather(
    blink_led(led),
    measure_and_display(sensor, text_areas, display)
))