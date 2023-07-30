import board
import displayio
import terminalio
from adafruit_display_text import label
from digitalio import DigitalInOut, Direction, Pull
from adafruit_debouncer import Debouncer
import simpleio
import time


# Setup buttons and debouncers
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
T = 0.16


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

# Create a bitmap object
image = displayio.OnDiskBitmap('picopad.bmp')
image_area = displayio.TileGrid(image, pixel_shader=image.pixel_shader)

# Position the bitmap
image_area.x = 70
image_area.y = 20

# Add the bitmap to the display group
group.append(image_area)

# Show the display group
display.show(group)

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

for note in melody:
    frequency, duration = note
    simpleio.tone(board.AUDIO, frequency, duration)
    time.sleep(0.05)


# Move the Picopad logo when the buttons are pressed

while True:
    # Update button debouncer status
    btn_down.update()
    btn_up.update()
    btn_left.update()
    btn_right.update()

    if (btn_down.fell):
        image_area.y += 5
        simpleio.tone(board.AUDIO, D4, T)
        board.DISPLAY.show(group)
    
    if (btn_up.fell):
        image_area.y -= 5
        simpleio.tone(board.AUDIO, E4, T)
        board.DISPLAY.show(group)

    if (btn_left.fell):
        image_area.x -= 5
        simpleio.tone(board.AUDIO, D5, T)
        board.DISPLAY.show(group)

    if (btn_right.fell):
        image_area.x += 5
        simpleio.tone(board.AUDIO, E5, T)
        board.DISPLAY.show(group)


