from machine import Pin,SPI,PWM  # Import necessary interfaces and modules
import st7789  # Module for ST7789 display
from fonts import fonts_vga1_16x32  # Import necessary fonts
from fonts import fonts_vga2_8x8
from time import sleep
import utime  # MicroPython's time-related functions

# SPI(1) - setting up the display pins
st7789_res = Pin(20, mode=Pin.OUT)  # Reset pin
st7789_dc = Pin(17, mode=Pin.OUT)   # Data/Command pin
st7789_cs = Pin(21, mode=Pin.OUT)   # Chip Select pin
st7789_blk = Pin(16, mode=Pin.OUT)  # Backlight control pin

# Display initialization
spi = SPI(0,62500000,sck=Pin(18),mosi=Pin(19),polarity=1,phase=1)  # Configure SPI interface
display=st7789.ST7789(spi,320,240,reset=st7789_res,dc=st7789_dc,cs=st7789_cs,backlight=st7789_blk,rotation=1)  
display.fill(0)  # Fill the screen with black color
# Display text on the screen
display.text(fonts_vga1_16x32, "Picopad", 20, 40, 0xF800, 0)  # Text with font size 16x32
display.text(fonts_vga2_8x8, "HC-SR04 DEMO", 20, 75, 0x0FFF, 0)  # Text with font size 8x8

# Initialize ultrasonic sensor HC-SR04
trigger = Pin(0, machine.Pin.OUT)
echo = Pin(1, machine.Pin.IN)

# Function to measure distance
def measure_distance():
    # Send trigger signal
    trigger.value(0)
    utime.sleep_us(2)  # Microsecond delay
    trigger.value(1)
    utime.sleep_us(10)  # Microsecond delay
    trigger.value(0)

    # Wait for incoming echo signal
    while echo.value() == 0:
        pass  # do nothing until a signal is received
    start_time = utime.ticks_us()  # mark the start time

    while echo.value() == 1:
        pass  # keep waiting while the signal is still received
    end_time = utime.ticks_us()  # mark the end time

    # Calculate distance in centimeters
    duration = utime.ticks_diff(end_time, start_time)  # find the duration of the echo
    distance = duration / 58  # divide by 58 to convert to distance in cm

    return distance  # return the calculated distance

# Main program loop
while True:
    # Measure distance
    distance = measure_distance()
    if(distance>1200):  # If the distance is more than the maximum detection range of HC-SR04
        utime.sleep(1)  # Wait for 1 second
        continue  # Skip to next iteration
    # Display distance on the screen
    display.text(fonts_vga1_16x32, "Distance:", 10, 120, 0xffff, 0)
    display.text(fonts_vga1_16x32, "{:.1f} cm".format(distance), 10, 150, 0xffff, 0)
    # Clear the old distance values before the new ones are displayed
    if(distance<100):
       display.text(fonts_vga1_16x32, "   ", 122, 150, 0xffff, 0)  # Clear if less than 100cm
    elif(distance<1000):
       display.text(fonts_vga1_16x32, "  ", 138, 150, 0xffff, 0)  # Clear if less than 1000cm

    # Delay between measurements
    utime.sleep(1)  # Wait for 1 second
