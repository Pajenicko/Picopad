"""
In this simple example, you will learn how to interface with Picopad photoresistor module.
It measures light intensity in the surroundings and you can read the value from the analog pin A0.
"""

import board
import analogio
import time

sensor = analogio.AnalogIn(board.A0)

# read and show measured values every second
while True:
    print(f"Light intensity: {sensor.value}")
    time.sleep(1)
