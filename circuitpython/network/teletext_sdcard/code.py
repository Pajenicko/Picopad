import displayio
import adafruit_requests as requests
import os
import board
import wifi
import ssl
import socketpool
import gc
from digitalio import DigitalInOut, Direction, Pull

import busio
import sdcardio
import storage

# Setup buttons
btn_down = DigitalInOut(board.SW_DOWN)
btn_down.direction = Direction.INPUT
btn_down.pull = Pull.UP

btn_up = DigitalInOut(board.SW_UP)
btn_up.direction = Direction.INPUT
btn_up.pull = Pull.UP

btn_left = DigitalInOut(board.SW_LEFT)
btn_left.direction = Direction.INPUT
btn_left.pull = Pull.UP

btn_right = DigitalInOut(board.SW_RIGHT)
btn_right.direction = Direction.INPUT
btn_right.pull = Pull.UP

btn_x = DigitalInOut(board.SW_X)
btn_x.direction = Direction.INPUT
btn_x.pull = Pull.UP

btn_y = DigitalInOut(board.SW_Y)
btn_y.direction = Direction.INPUT
btn_y.pull = Pull.UP

btn_a = DigitalInOut(board.SW_A)
btn_a.direction = Direction.INPUT
btn_a.pull = Pull.UP

btn_b = DigitalInOut(board.SW_B)
btn_b.direction = Direction.INPUT
btn_b.pull = Pull.UP

# Setup SD card
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
    gc.collect()
    image = displayio.OnDiskBitmap('/sd/picture.bmp')
    tile_grid = displayio.TileGrid(image, pixel_shader=image.pixel_shader)
    
    group.append(tile_grid)
    display.show(group)
         
# Initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

pool = socketpool.SocketPool(wifi.radio)
requests = requests.Session(pool, ssl.create_default_context())
group = displayio.Group()

# Download and display first page
teletext(page)


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
    
    if (btn_left.value == False):
        page -= 1
        teletext(page)

    if (btn_y.value == False):
        page += 10
        teletext(page)

    if (btn_x.value == False):
        page -= 10
        teletext(page)

    if (btn_b.value == False):
        page += 100
        teletext(page)

    if (btn_a.value == False):
        page -= 100
        teletext(page)

