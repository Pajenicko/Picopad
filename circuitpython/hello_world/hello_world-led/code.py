import time
import board
import digitalio

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