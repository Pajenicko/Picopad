"""
In this example, you will learn how to use the display on your Picopad with displayio library.

We will use the adafruit_display_text library to display text anywhere on the screen.

It requires the adafruit_display_text library placed in /lib directory.
You can find the library in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""

import board
import displayio
from adafruit_display_text import label
from adafruit_bitmap_font import bitmap_font
import adafruit_imageload
import wifi
import adafruit_ntp
import rtc
import socketpool
import time
import os
import asyncio
import math



import random
import busio
import sdcardio
import storage
import digitalio
from adafruit_bitmapsaver import save_pixels

spi = busio.SPI(board.SD_SCK, MOSI=board.SD_MOSI, MISO=board.SD_MISO)
cs = board.SD_CS
sdcard = sdcardio.SDCard(spi, cs)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")
btn_y = digitalio.DigitalInOut(board.SW_Y)
btn_y.pull = digitalio.Pull.UP

def sc():
    save_pixels('/sd/screenshot%s.bmp'% random.randint(100,999))
    print("screenshot saved")




# Initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

pool = socketpool.SocketPool(wifi.radio)

# Set up NTP
ntp = adafruit_ntp.NTP(pool, tz_offset=2)
# Set up RTC
rtc.RTC().datetime = ntp.datetime


display = board.DISPLAY

# Create a display group
group = displayio.Group()

bitmap_bg, palette_sky = adafruit_imageload.load("/sky.bmp",
                                          bitmap=displayio.Bitmap,
                                          palette=displayio.Palette)

tile_grid_bg = displayio.TileGrid(bitmap_bg, pixel_shader=palette_sky)

group.append(tile_grid_bg)


bitmap_sun, palette_sun = adafruit_imageload.load("/sun.bmp",
                                          bitmap=displayio.Bitmap,
                                          palette=displayio.Palette)

sun = displayio.TileGrid(bitmap_sun, pixel_shader=palette_sun)



sun.x = 150
sun.y = 20

palette_sun.make_transparent(1)
group.append(sun)

bitmap, palette = adafruit_imageload.load("/fg.bmp",
                                          bitmap=displayio.Bitmap,
                                          palette=displayio.Palette)

palette.make_transparent(7)

# Create a TileGrid to hold the bitmap
tile_grid = displayio.TileGrid(bitmap, pixel_shader=palette)
tile_grid.y = 82
group.append(tile_grid)

# Set the default font for the text
font = bitmap_font.load_font("/Digital-Display-80.bdf")

# Create a text label
text = "00:00:00"
text_area = label.Label(font, text=text, color=0xFFFFFF, scale=1)

# Position the text label
text_area.x = 20
text_area.y = 170

# Add the text label to the display group
group.append(text_area)

# Show the display group
display.show(group)

async def move_sun():
    while True:
        for x in range(20, 280):
            y = 0.005*x**2 - 1.5*x + 140
            sun.x = int(x)
            sun.y = int(y)
            if x < 30:
                #noc
                palette_sky[1] = 0xFFFFEE
                palette_sky[0] = 0x2c3fad
            
            elif x < 75:
                #rano
                palette_sun[0] = 0xfcffcf
                palette_sky[0] = 0x89daea
                palette_sky[1] = 0x89daea
            
            elif x < 210:
                #den
                palette_sun[0] = 0xfbf236
                palette_sky[0] = 0x46d3fc
                palette_sky[1] = 0x46d3fc
                
            elif x < 260:
                #vecer
                palette_sun[0] = 0xfbbf36
                palette_sky[0] = 0xfff038 
                palette_sky[1] = 0xfff038         


            else:
                #vecer
                palette_sky[1] = 0xFFFFEE
                palette_sky[0] = 0x141f5c


            print(x, y)

            await asyncio.sleep(1)

async def update_time():
    while True:
        if (btn_y.value == False):
            sc()


        start_time = time.monotonic()
        dt = rtc.RTC().datetime
        date = "%02d:%02d:%02d" %(dt.tm_hour, dt.tm_min, dt.tm_sec)
        text_area.text = date
        end_time = time.monotonic()
        elapsed_time = end_time - start_time

        

        await asyncio.sleep(1 - elapsed_time)


start_time = time.monotonic()
i = 0
   


loop = asyncio.get_event_loop()

# Schedule both tasks to run concurrently
loop.run_until_complete(asyncio.gather(
    update_time(),
    move_sun(),
   
))