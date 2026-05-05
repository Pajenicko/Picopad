"""
This example is tribute to the Pajenicko Owl soldering kit for beginners.
https://pajenicko.cz/sova-nocni-led-svetlo

It requires the following libraries placed in /lib directory:
- adafruit_display_shapes.circle - to display the owl's eyes
- colorsys - to convert hue, saturation and lightness to RGB color
- simpleio - we will use map_range function to convert light sensor value to corresponding saturation and lightness values for eyes

You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).

"""

import board

import displayio
from adafruit_display_shapes.circle import Circle
import colorsys
import analogio
import simpleio

sensor = analogio.AnalogIn(board.A0)

display = board.DISPLAY
group = displayio.Group()
image = displayio.OnDiskBitmap('/owl.bmp')
tile_grid = displayio.TileGrid(image, pixel_shader=image.pixel_shader)


eye_left = Circle(134, 35, 13, fill=0xFF0000)
eye_right = Circle(180, 35, 13, fill=0xFF0000)

group.append(tile_grid)
group.append(eye_left)
group.append(eye_right)

display.root_group = group

while True:
    light = sensor.value
    sat = simpleio.map_range(light, 40000, 1000, 0.01, 1.0)
    lum = simpleio.map_range(light, 40000, 1000, 0.01, 0.5)
    eye_left.fill = colorsys.hls_to_rgb(1,lum,sat)
    eye_right.fill = colorsys.hls_to_rgb(1,lum,sat)
    