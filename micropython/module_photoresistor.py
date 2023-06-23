from machine import Pin,SPI,PWM  # Import necessary interfaces and modules
import st7789  # Module for ST7789 display
from fonts import fonts_vga1_16x32  # Import necessary fonts
from fonts import fonts_vga2_8x8  
from time import sleep  # Import sleep function for delays

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
display.text(fonts_vga2_8x8, "PHOTORESISTOR DEMO", 20, 75, 0x0FFF, 0)  # Text with font size 8x8

# Initialize ADC (Analog-to-Digital Converter) on pin 26
adc = machine.ADC(26)

# Main program loop
while True:
    # Read the ADC value from the photoresistor
    adc_value = adc.read_u16()
    # Display the value on the screen
    display.text(fonts_vga1_16x32, "Light intensity", 20, 120, 0xffff, 0)
    display.text(fonts_vga1_16x32, str(adc_value), 20, 150, 0xffff, 0)
    if (adc_value<10000):  # If the ADC value is less than 10000
        # Clear the old value from the display
        display.text(fonts_vga1_16x32, " ", 84, 150, 0xffff, 0)
    # Delay for smoother display updates
    sleep(0.1)  # 100ms delay
