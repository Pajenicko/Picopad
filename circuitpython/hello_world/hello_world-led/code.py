"""
In this simple example, you will learn how to interact with peripherals on your Picopad.
Will access the USR LED (yellow) and blink it.

We need to initialize the LED pin as an output, and then we can set the value to True or False to turn it on or off.
"""
# board provides access to the built-in display, pins and other hardware
import board

# digitalio allows us to set pin mode and value
import digitalio

# time allows us to wait defined amount of time
import time

# use the USR LED (yellow)
led = digitalio.DigitalInOut(board.LED)

# default pin mode is input, so we need to change it to output
led.direction = digitalio.Direction.OUTPUT

# blink the LED
while True:
  led.value = True
  time.sleep(0.5)
  led.value = False
  time.sleep(0.5)