"""
In this example, you'll connect Picopad to real world. SD card required!!!

We will use the adafruit_requests library to download teletext page from the https://teletext.ceskatelevize.cz/ and display it on the screen.

The teletext page is png image 320x276 pixels. To display it on the screen, we need to convert it to 4bpp bmp image.
Becouse of limited memory, we will offload the conversion to the teletext.lynt.cz proxy server that convert the image and send it back to us.
For futher memory saving, we will save the image to SD card and display it from there.

We will use buttons to scroll the page up and down and to change the teletext page number.

You can find the required librarie in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import board

import displayio
import adafruit_requests

import wifi
import ssl
import socketpool
import os

import gc

from digitalio import DigitalInOut, Direction, Pull

import busio
import sdcardio
import storage


# Setup buttons
btn_down = DigitalInOut(board.SW_DOWN)
# btn_down.direction = Direction.INPUT # - not needed, default is input
btn_down.pull = Pull.UP

btn_up = DigitalInOut(board.SW_UP)
btn_up.pull = Pull.UP

btn_left = DigitalInOut(board.SW_LEFT)
btn_left.pull = Pull.UP

btn_right = DigitalInOut(board.SW_RIGHT)
btn_right.pull = Pull.UP

btn_x = DigitalInOut(board.SW_X)
btn_x.pull = Pull.UP

btn_y = DigitalInOut(board.SW_Y)
btn_y.pull = Pull.UP

btn_a = DigitalInOut(board.SW_A)
btn_a.pull = Pull.UP

btn_b = DigitalInOut(board.SW_B)
btn_b.pull = Pull.UP

# Setup SD card and mount it to /sd directory
spi = busio.SPI(board.SD_SCK, MOSI=board.SD_MOSI, MISO=board.SD_MISO)
cs = board.SD_CS
sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")

# Default teletext page
page = 100

# Download teletext page and save it to SD card
# teletext.lynt.cz is a proxy server that converts teletext page from PNG to 4bpp bmp
def teletext(page):
        
        if page < 100:
            page = 100
        if page > 899:
            page = 899

        response = requests.get("https://teletext.lynt.cz/?page=%s" % (page))
        
        with open("/sd/picture.bmp", "wb") as f:
            for chunk in response.iter_content(chunk_size=512):
                f.write(chunk)       
        response.close()
        display_page()
        
# Display teletext page from SD card image
def display_page():
    global group
    display = board.DISPLAY
    image = displayio.OnDiskBitmap('/sd/picture.bmp')
    tile_grid = displayio.TileGrid(image, pixel_shader=image.pixel_shader)
    
    group.append(tile_grid)
    display.show(group)

# Initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

pool = socketpool.SocketPool(wifi.radio)
requests = adafruit_requests.Session(pool, ssl.create_default_context())
group = displayio.Group()

# Download and display first page
teletext(page)

# Call garbage collector to free memory
gc.collect()

while True:
    # Teletext page has resolution 320x276 - we need to scroll down to see the whole page
    if (btn_down.value == False):
        group.y = -40
        board.DISPLAY.show(group)

    if (btn_up.value == False):
        group.y = 0
        board.DISPLAY.show(group)

    # Change teletext page
    if (btn_right.value == False):
        page += 1
        teletext(page)
        gc.collect()
    
    if (btn_left.value == False):
        page -= 1
        teletext(page)
        gc.collect()

    if (btn_y.value == False):
        # this is nice alternative to math.ceil()
        # it rounds page to next 10 (eg. from 113 to 120)
        page = int((page + 10)/10)*10
        teletext(page)
        gc.collect()

    if (btn_x.value == False):
        page = int((page)/10)*10
        teletext(page)
        gc.collect()

    if (btn_b.value == False):
        page = int((page + 100)/100)*100
        teletext(page)
        gc.collect()

    if (btn_a.value == False):
        page = int((page)/100)*100
        teletext(page)
        gc.collect()

