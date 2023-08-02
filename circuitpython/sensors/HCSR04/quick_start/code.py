"""
In this simple example, you will learn how to interface with the Sensirion SCD4x sensor,
which enables us to measure temperature, humidity, and CO2 levels in the surroundings.
This example demonstrates the step-by-step process of setting up the necessary components,
initializing the I2C bus, and accessing sensor data.

It requires the ### libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).

"""
import board
import time
import adafruit_hcsr04
sensor = adafruit_hcsr04.HCSR04(trigger_pin=board.D3, echo_pin=board.D2)

while True:
    try:
        print(sensor.distance)
    except RuntimeError:
        print("Measuring error!")
    time.sleep(2)