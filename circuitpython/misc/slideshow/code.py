"""
Simple Slideshow for PicoPad

Displays BMP images from the SD card in a slideshow.
Uses the adafruit_slideshow library for easy image handling.

Images should be 320x240 BMP files placed in the /sd/images/ folder.
You can use indexed (4bpp/8bpp) BMPs to save space, or 24-bit BMPs.

Controls:
  Right - next image
  Left  - previous image
  A     - pause/resume auto-advance
  B     - toggle between alphabetical and random order

SD card is required!

Required libraries in /lib:
  adafruit_slideshow
"""

import board
import busio
import sdcardio
import storage
import keypad
import time
from adafruit_slideshow import SlideShow, PlayBackOrder, PlayBackDirection

# Setup SD card and mount it to /sd directory
spi = busio.SPI(board.SD_SCK, MOSI=board.SD_MOSI, MISO=board.SD_MISO)
cs = board.SD_CS
sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")
print("SD card mounted")

# Setup buttons
KEY_A = 0
KEY_B = 1
KEY_LEFT = 2
KEY_RIGHT = 3

keys = keypad.Keys(
    (board.SW_A, board.SW_B, board.SW_LEFT, board.SW_RIGHT),
    value_when_pressed=False,
    pull=True,
)

# Create the slideshow from BMP files on the SD card
# dwell = seconds to show each image before advancing
slideshow = SlideShow(
    board.DISPLAY,
    None,
    folder="/sd/images/",
    loop=True,
    order=PlayBackOrder.ALPHABETICAL,
    dwell=5,
)

auto_advance = True
print("Slideshow started - press Right/Left to navigate, A to pause, B for random order")

while True:
    # Process button events
    event = keys.events.get()
    while event:
        if event.pressed:
            if event.key_number == KEY_RIGHT:
                slideshow.direction = PlayBackDirection.FORWARD
                slideshow.advance()

            elif event.key_number == KEY_LEFT:
                slideshow.direction = PlayBackDirection.BACKWARD
                slideshow.advance()

            elif event.key_number == KEY_A:
                # Toggle auto-advance on/off
                auto_advance = not auto_advance
                slideshow.auto_advance = auto_advance
                print("Auto-advance:", "on" if auto_advance else "off")

            elif event.key_number == KEY_B:
                # Toggle between alphabetical and random order
                if slideshow.order == PlayBackOrder.ALPHABETICAL:
                    slideshow.order = PlayBackOrder.RANDOM
                    print("Order: random")
                else:
                    slideshow.order = PlayBackOrder.ALPHABETICAL
                    print("Order: alphabetical")

        event = keys.events.get()

    # Let the slideshow handle auto-advance timing
    slideshow.update()
