"""
Now, we will enhance the previous example and visualize the measured data on the display.

It requires the adafruit_scd4x, adafruit_display_text and adafruit_imageload libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import time
import displayio
import terminalio
from adafruit_display_text import label
import adafruit_imageload

from sensor_internal import Sensor

# initialize the display
display = board.DISPLAY
group = displayio.Group(scale=2)

# we will use a sprite sheet to display the icons, color on index 6 will be transparent
sprite_sheet, palette = adafruit_imageload.load("/assets.bmp")
palette.make_transparent(6)

# prepare the text areas for the measured values
top = 20
increment = 40

text_areas = {}

types_to_sprites = {
    "temperature": 0,
    "humidity": 1,
    "co2": 2
}

for reading, data in Sensor().readings.items():
    text_areas[reading] = label.Label(terminalio.FONT, text='', color=0xFFFFFF, x=45, y=top)

    group.append(text_areas[reading])

    sprite = displayio.TileGrid(sprite_sheet, pixel_shader=palette,
                            width = 1,
                            height = 1,
                            tile_width = 16,
                            tile_height = 32,
                            default_tile = types_to_sprites[data["type"]]
                            )
    sprite.x = 20
    sprite.y = top - 15
    group.append(sprite)
    top += increment


display.show(group)

# initialize the sensor
sensor = Sensor()

# read and show measured values every 5 seconds
while True:

    # measure the sensor data
    measurements = sensor.measure()

    # print the measured values
    for measurement in measurements:
            text_areas[measurement.tag].text = "%.1f %s" %(measurement.value, measurement.unit)
    display.refresh()

    time.sleep(5)
