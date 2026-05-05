"""
In this example, you will use your body temperature to control the movement of an air balloon, making it go up and down, creating an enjoyable experience! :-)
You will need Picopad DS18B20 temperature sensor module.
Touch the sensor with your finger to heat it up and use cold breath to cool it down ;-)

It requires the following libraries placed in /lib directory:
- adafruit_onewire
- adafruit_ds18x20

You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).

"""


import board
import displayio
import asyncio
import random

from adafruit_onewire.bus import OneWireBus
from adafruit_ds18x20 import DS18X20


# Init One-Wire bus
bus = OneWireBus(board.D0)

# Scan for devices and select the first one found
devices = bus.scan()
sensor = DS18X20(bus, devices[0])

# Init display
display = board.DISPLAY

# Create a display group
group = displayio.Group()

# Sky background
bg_bmp = displayio.Bitmap(display.width, display.height, 1)
palette = displayio.Palette(1)
palette[0] = 0xDFF6F5
background = displayio.TileGrid(bg_bmp, pixel_shader=palette)
group.append(background)

# Clouds bitmap
cloud_bmp = displayio.OnDiskBitmap(open("cloud.bmp", "rb"))
clouds = []
for i in range(3):
    cloud = displayio.TileGrid(cloud_bmp, pixel_shader=cloud_bmp.pixel_shader)
    clouds.append(cloud)
    cloud.x = random.randint(50, 270)
    cloud.y = random.randint(0, 150)
    group.append(cloud)
                       

# Balloon bitmap
image = displayio.OnDiskBitmap('balloon.bmp')
image.pixel_shader.make_transparent(4)
image_area = displayio.TileGrid(image, pixel_shader=image.pixel_shader)
image_area.x = 70
image_area.y = 170
group.append(image_area)

# Show the display group
display.root_group = group

# We will handle refresh ourselves
display.auto_refresh = False

# Global variables
move_x = 1
move_y = 0
temperature = 0

async def measure():
    global temperature
    global sensor
    global move_y
    while True:
        # read temperature on background - the value will be availabe in the next iteration
        sensor.start_temperature_read()
        new_temperature = sensor.read_temperature()

        diff = int((new_temperature - temperature)*-10)
        # filter out big changes (e.g. first read)
        if diff < 10 and diff > -10:
            move_y = diff 

        # update temperature only if it changed
        if diff:
            temperature = new_temperature

        await asyncio.sleep(1)

async def move_balloon():
    global image_area
    global move_x
    global move_y
    global display

    while True:
        # bounce balloon from the edges
        if(image_area.x > 295):
            move_x = -1
        if(image_area.x < -5):
            move_x = 1
        # stop balloon at the top and bottom
        if(image_area.y > 210):
            move_y = -1
        if(image_area.y < 0):
            move_y = 1

        # move balloon
        image_area.x += move_x
        image_area.y += move_y 

        # refresh display manually
        display.refresh()
        
        await asyncio.sleep(0.1)


async def move_clouds():
    global clouds

    while True:
        
        for cloud in clouds:
            rand_x = random.randint(-1, 1)
            rand_y = random.randint(-1, 1)
            cloud.x += rand_x
            cloud.y += rand_y
        
        await asyncio.sleep(random.randint(0, 10)/4)
        
        



# Prepare the event loop    
loop = asyncio.get_event_loop()

# Schedule both tasks to run concurrently
loop.run_until_complete(asyncio.gather(
    move_balloon(),
    move_clouds(),
    measure()
))