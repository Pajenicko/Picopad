from machine import Pin,SPI,PWM  # Import necessary interfaces and modules
import sys
import st7789  # Module for ST7789 display
from fonts import fonts_vga1_16x32  # Import necessary fonts
from fonts import fonts_vga2_8x8
from time import sleep  # Import sleep for delays
import onewire  # Module for OneWire bus
import ds18x20  # Module for DS18B20 sensor

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
display.text(fonts_vga2_8x8, "DS18B20 DEMO", 20, 75, 0x0FFF, 0)  # Text with font size 8x8

# Initialize OneWire bus on pin 26
ow = onewire.OneWire(machine.Pin(26))
# Initialize DS18B20 sensor
sensor = ds18x20.DS18X20(ow)

# Main program loop
while True:
    
    # Get DS18B20 sensor address
    roms = sensor.scan()
    if len(roms) > 0:  # If a sensor is found
        # Read temperature from sensor
        sensor.convert_temp()  
        sleep(0.750)  # Delay for conversion
        temperature = sensor.read_temp(roms[0])
        # Display temperature on the screen
        display.text(fonts_vga1_16x32, "temperature: {:.2f}C".format(temperature), 20, 150, 0xffff, 0)
    # Delay for smoother display refresh
    sleep(0.750)
