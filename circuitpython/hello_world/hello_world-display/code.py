"""
In this example, you will learn how to use the display on your Picopad with displayio library.

We will use the adafruit_display_text library to display text anywhere on the screen.

It requires the adafruit_display_text library placed in /lib directory.
You can find the library in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import displayio
import terminalio
from adafruit_display_text import label


display = board.DISPLAY

# Create a display group
group = displayio.Group()

# Set the default font for the text
font = terminalio.FONT

# Create a text label
text = "Hello World!"
text_area = label.Label(font, text=text, color=0xFFFFFF, scale=2)

# Position the text label
text_area.x = 100
text_area.y = 110

# Add the text label to the display group
group.append(text_area)

# Show the display group
display.show(group)

while True:
    pass