"""
In this simple example, you will learn how to interface with Picopad HS-SR04 module.
It is ultrasound sensor measuring distance. To calculate distance you use 2 pins - trigger and echo.
Trigger pin is used to send the signal and echo pin is used to receive the signal. The time between
sending and receiving the signal is used to calculate the distance.

You can use adafuit_hcsr04 library to handle all the calculations.

It requires the adafruit_hcsr04 libraries placed in /lib directory.
You can find the libraries in the CircuitPython library bundle (https://circuitpython.org/libraries).

"""
import board
import time
import adafruit_hcsr04
sensor = adafruit_hcsr04.HCSR04(trigger_pin=board.D3, echo_pin=board.D2)

while True:
    try:
        print(f"{sensor.distance} cm")
    except RuntimeError:
        print("Measuring error!")
    time.sleep(2)