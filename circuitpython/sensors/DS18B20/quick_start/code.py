"""
In this simple example, you will learn how to interface with the Sensirion SCD4x sensor,
which enables us to measure temperature, humidity, and CO2 levels in the surroundings.
This example demonstrates the step-by-step process of setting up the necessary components,
initializing the I2C bus, and accessing sensor data.

It requires the ### libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).

"""

import time
import board
from adafruit_onewire.bus import OneWireBus
from adafruit_ds18x20 import DS18X20

# Init One-Wire bus
bus = OneWireBus(board.D0)

# Scan for devices and select the first one found
sensor = DS18X20(bus, bus.scan()[0])

# print temperature every 2 
while True:
    print("Temperature: %.1f °C" % (sensor.temperature))
    time.sleep(2.0)