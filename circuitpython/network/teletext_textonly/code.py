"""
In this example, you'll connect Picopad to real world.

We will use the adafruit_requests library to download teletext page from the https://teletext.ceskatelevize.cz/ and display it on the screen.

We use our own API to convert teletext data to convinient JSON format.

Use buttons to scroll the page up and down and to change the teletext page number.

You can find the required librarie in the CircuitPython library bundle (https://circuitpython.org/libraries).
"""
import board

import displayio
import adafruit_requests
from adafruit_bitmap_font import bitmap_font
from adafruit_display_text import bitmap_label


import wifi
import ssl
import socketpool
import os

import gc

from digitalio import DigitalInOut, Direction, Pull


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


# Default teletext page
page = 110
next_page = 0
prev_page = 0

# we will use teletext.lynt.cz API to access to content of teletext pages
def teletext(page):
        print(page)   
        global text_areas
        global next_page
        global prev_page
        
        if page < 100:
            page = 100
        if page > 899:
            page = 899

        with requests.get("http://teletext.lynt.cz/text?page=%s" % (page)) as resp:
            data = resp.json()
            lines = data["text"].splitlines()
            
            if(data["next"]):
                next_page = data["next"]
            if(data["prev"]):
                prev_page = data["prev"] 
        
        del data    
        gc.collect()

        index = 0

        for line in lines:
            text_areas[index].text = line
            index+=1
        
        del lines
        gc.collect()
        
# initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

pool = socketpool.SocketPool(wifi.radio)
requests = adafruit_requests.Session(pool, ssl.create_default_context())

# initialize display
display = board.DISPLAY

# Set text, font, and color
group = displayio.Group()

# load our custom font with czech punctuation support
font = bitmap_font.load_font("/font.bdf")
color = 0xFFFF00

#top offset = 0
top = 4

# teletext page has 23 lines
# 
# label supports multiline text, but 23 lines generated bitmap is too big
# so we will use 23 smaller text areas instead to save memory
text_areas = []
for i in range(0,23):
    text_area = bitmap_label.Label(font, text=" "*20, color=color, save_text=False)

    # Set the location
    text_area.x = 0
    text_area.y = top
    top += 15
    text_areas.append(text_area)
    group.append(text_area)
 

display.show(group)
    

teletext(page)
# it is good practice to call gc.collect() after every big memory allocation to prevent fragmentation
gc.collect()

while True:
    # Teletext page has resolution 320x276 - we need to scroll down to see the whole page
    if (btn_down.value == False):
        group.y = -120
        board.DISPLAY.show(group)

    if (btn_up.value == False):
        group.y = 4
        board.DISPLAY.show(group)

    # Change teletext page
    if (btn_right.value == False):
        page = next_page
        teletext(page)
        gc.collect()

    
    if (btn_left.value == False):
        page = prev_page
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
        

