"""
In this example, you'll get hands-on experience with Picopad peripherals,
learning how to make it react to your commands.

You'll press buttons, light up LEDs, display texts and images on screen and even play music!

You'll use the following CircuitPython libraries:
- displayio - to display text and images on the screen
- adafruit_display_text - to create text labels on screen
- digitalio - to interact with buttons and LEDs
- adafruit_debouncer - to solve the button bouncing problem
- simpleio - to generate tones

You can find the required librarie in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

# board provides access to the built-in display, pins and other hardware
import board
# displayio handles graphics rendering
import displayio
# terminalio contains default font we will use for displaying text
import terminalio
# adafruit_display_text has Label class for display text on screen
from adafruit_display_text import label
# digitalio allows us to set pin mode and value
from digitalio import DigitalInOut, Direction, Pull
# adafruit_debouncer is used to filter out false button presses caused by noise or mechanical switch press "bounce"
from adafruit_debouncer import Debouncer
# simpleio contains various utility functions, including tone generation
import simpleio
# time allows us to wait defined amount of time
import time


# Setup buttons and debouncers
# The default pin mode is input, so we don't need to change it.
# Debouncing is a technique used to filter out false button presses caused by noise or mechanical switch press "bounce".
# https://learn.adafruit.com/debouncer-library-python-circuitpython-buttons-sensors/overview

pin = DigitalInOut(board.SW_DOWN)
pin.pull = Pull.UP
btn_down = Debouncer(pin)

pin = DigitalInOut(board.SW_UP)
pin.pull = Pull.UP
btn_up = Debouncer(pin)

pin = DigitalInOut(board.SW_LEFT)
pin.pull = Pull.UP
btn_left = Debouncer(pin)

pin = DigitalInOut(board.SW_RIGHT)
pin.pull = Pull.UP
btn_right = Debouncer(pin)


# notes frequencies

C4 = 261.63
Db4 = 277.18
D4 = 293.66
Eb4 = 311.13
E4 = 329.63
F4 = 349.23
Gb4 = 369.99
G4 = 392.00
Ab4 = 415.30
A4 = 440.00
Bb4 = 466.16
B4 = 493.88

C5 = 523.25
Db5 = 554.37
D5 = 587.33
Eb5 = 622.25
E5 = 659.25
F5 = 698.46
Gb5 = 739.99
G5 = 783.99
Ab5 = 830.61
A5 = 880.00
Bb5 = 932.33
B5 = 987.77

# basic note duration
T = 0.15

# initialize the LED
led = DigitalInOut(board.LED)
led.direction = Direction.OUTPUT

# initialize the display
display = board.DISPLAY

# Create a display group
# Group is a special type of displayio object that can hold other displayio objects indepently
# https://learn.adafruit.com/circuitpython-display-support-using-displayio/group
group = displayio.Group()

# Set the default font for the text
font = terminalio.FONT

# Create a text label
text = "Hello World!"
text_label = label.Label(font, text=text, color=0xFFFFFF, scale=2)

# Position the text label
text_label.x = 100
text_label.y = 110

# Add the text label to the display group
group.append(text_label)

# Create a bitmap object directly from the bitmap file stored on the disk - it saves some memory
# The bitmap is in 4bpp format.
# https://learn.adafruit.com/circuitpython-display-support-using-displayio/display-a-bitmap
image = displayio.OnDiskBitmap('picopad.bmp')
image_area = displayio.TileGrid(image, pixel_shader=image.pixel_shader)

# Position the bitmap
image_area.x = 70
image_area.y = 20

# Add the bitmap to the display group
group.append(image_area)

# Show the whole display group
# It will display the text and the bitmap as well
# You can move every item in the group independently later
display.root_group = group

melody = [
    (E4, 1*T),
    (F4, 1*T),
    (G4, 2*T),
    (C5, 4*T),
    
    (D4, 1*T),
    (E4, 1*T),
    (F4, 6*T),

    (G4, 1*T),
    (A4, 1*T),
    (B4, 2*T),
    (F5, 4*T),
    
    (A4, 1*T),
    (B4, 1*T),
    (C5, 2*T),
    (D5, 2*T),
    (E5, 2*T),
]

# Play the melody and blink the LED in the rhythm :-)
for note in melody:
    frequency, duration = note
    simpleio.tone(board.AUDIO, frequency, duration)
    led.value = not led.value
    time.sleep(0.05)


# Move the Picopad logo when the buttons are pressed (the debouncer detects the button down/fell event)

while True:
    # Update button debouncer status
    btn_down.update()
    btn_up.update()
    btn_left.update()
    btn_right.update()

    if (btn_down.fell):
        image_area.y += 5
        simpleio.tone(board.AUDIO, D4, T)

    
    if (btn_up.fell):
        image_area.y -= 5
        simpleio.tone(board.AUDIO, E4, T)


    if (btn_left.fell):
        image_area.x -= 5
        simpleio.tone(board.AUDIO, D5, T)


    if (btn_right.fell):
        image_area.x += 5
        simpleio.tone(board.AUDIO, E5, T)



