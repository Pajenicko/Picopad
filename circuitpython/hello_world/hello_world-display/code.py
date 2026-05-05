"""
In this example, you will learn how to use the display on your Picopad with displayio library.

We will use the adafruit_display_text library to display text anywhere on the screen.

It requires the adafruit_display_text library placed in /lib directory.
You can find the library in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
# board provides access to the built-in display, pins and other hardware
import board

# terminalio contains default font we will use for displaying text
import terminalio

# adafruit_display_text has Label class for display text on screen
# https://docs.circuitpython.org/projects/display_text/en/latest/
from adafruit_display_text import label

# Initialize the display
display = board.DISPLAY

# Set the default font for the text
font = terminalio.FONT

# Create a text label, set font, color and scale
text = "Hello World!"
text_label = label.Label(font, text=text, color=0xFFFFFF, scale=2)

# Position the text label
text_label.x = 100
text_label.y = 110

# Show the text label
display.root_group = text_label

# Do nothing, just leave the text on the screen
while True:
    pass