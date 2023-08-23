"""
In this simple example, you will learn how to read temperature from RP2040 internal sensor.
"""
import board
import time
import microcontroller

# read and show measured values every 5 seconds
while True:
    print("Internal Temperature: %0.2f °C" % microcontroller.cpu.temperature)
    time.sleep(5)

