"""
In this simple example, you will learn how to read temperature from RP2040 internal sensor.
"""
import time
import microcontroller

# read and show measured values every 5 seconds
while True:
    print(f"Internal Temperature: {microcontroller.cpu.temperature:0.2f} °C")
    time.sleep(5)

