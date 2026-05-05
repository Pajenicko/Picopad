"""
In this simple example, you will learn how to interface with Picopad DS18B20 module.
It measures temperature and you can read the digital value via OneWire bus.

It requires the adafruit_onewire.bus and adafruit_ds18x20 libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).

"""

import time
import board
from adafruit_onewire.bus import OneWireBus
from adafruit_ds18x20 import DS18X20

# Init One-Wire bus
bus = OneWireBus(board.D0)

# Scan for devices and select the first one found
devices = bus.scan()
sensor = DS18X20(bus, devices[0])

# print temperature every 2 
while True:
    print(f"Temperature: {sensor.temperature:.1f} °C")
    time.sleep(2)