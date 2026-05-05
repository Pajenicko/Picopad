"""
Now, we will enhance the previous example and visualize the measured data on the display.

We also moved the sensor code to a separate files, which enables us to use the same code for different sensors.

If you don't have SCD4x sensor, just comment out import sensor_sd4x and uncomment import sensor_internal - this will use internal temperature sensor of RP2040 as a demo.

It requires the adafruit_scd4x, adafruit_display_text and adafruit_imageload libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import time
import displayio
from adafruit_display_text import label
import adafruit_imageload
from extra_font import ExtraFont

from sensor_scd4x import Sensor
# if you don't have SCD4x, you can try use internal temperature sensor of rp2040 as a demo
#from sensor_internal import Sensor

# initialize the display
display = board.DISPLAY
group = displayio.Group(scale=2)

# initialize the sensor
sensor = Sensor()

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


display = board.DISPLAY

# The built-in missing some useful glyphs (characters) e.g. degree (°), so I made a small workaround.
# ExtraFont class from extra_font.py extends the terminalio.FONT and adds the missing character from extra.bdf bitmap font contains only that glyph. 
font = ExtraFont()

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


# read and show measured values every 5 seconds
while True:

    # measure the sensor data
    measurements = sensor.measure()

    # print the measured values
    for measurement in measurements:
            text_areas[measurement.tag].text = f"{measurement.value:.1f} {measurement.unit}"
    display.refresh()

    time.sleep(5)
