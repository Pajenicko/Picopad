from machine import Pin, SPI, PWM
from fonts import fonts_vga1_16x32
from fonts import fonts_vga2_8x8
from time import sleep
import st7789

# SPI(1) - pins for the display
st7789_res = Pin(20, mode=Pin.OUT)  # Reset pin for the display
st7789_dc = Pin(17, mode=Pin.OUT)  # Data/command pin for the display
st7789_cs = Pin(21, mode=Pin.OUT)  # Chip select pin for the display
st7789_blk = Pin(16, mode=Pin.OUT)  # Backlight pin for the display

# Initialize the display
spi = SPI(0, 62500000, sck=Pin(18), mosi=Pin(19), polarity=1, phase=1)  # SPI bus for communication
display = st7789.ST7789(spi, 320, 240, reset=st7789_res, dc=st7789_dc, cs=st7789_cs, backlight=st7789_blk, rotation=1)
# Create an instance of the ST7789 class for the display
# with the specified parameters

display.fill(0)  # Clear the display
display.text(fonts_vga1_16x32, "Picopad", 20, 40, 0xF800, 0)  # Display "Picopad" using a specific font
display.text(fonts_vga2_8x8, "DEMO", 20, 75, 0x0FFF, 0)  # Display "DEMO" using a different font

# Define buttons
left_button = Pin(3, Pin.IN, Pin.PULL_UP)  # Define the left button
right_button = Pin(2, Pin.IN, Pin.PULL_UP)  # Define the right button
up_button = Pin(4, Pin.IN, Pin.PULL_UP)  # Define the up button
down_button = Pin(5, Pin.IN, Pin.PULL_UP)  # Define the down button

a_button = Pin(7, Pin.IN, Pin.PULL_UP)  # Define the A button
b_button = Pin(6, Pin.IN, Pin.PULL_UP)  # Define the B button
x_button = Pin(9, Pin.IN, Pin.PULL_UP)  # Define the X button
y_button = Pin(8, Pin.IN, Pin.PULL_UP)  # Define the Y button

pin_led_usr = Pin(22, mode=Pin.OUT)  # Define the user LED pin
pin_led_usr.high()  # Turn off the user LED initially

# Buzzer
buzzerPIN = 15  # Define the pin for the buzzer
BuzzerObj = PWM(Pin(buzzerPIN))  # Create a PWM object for the buzzer

# Read voltage
Pin(29, Pin.IN)  # Configure pin for voltage reading
vsysChannel = machine.ADC(3)  # Create an ADC object for voltage measurement

def toggle_pin(pin):
    pin.value(not pin.value())  # Toggle the state of the specified pin

def buzzer(buzzerPinObject, frequency, sound_duration, silence_duration):
    # Play a sound using the buzzer
    buzzerPinObject.duty_u16(int(65536 * 0.05))  # Set the duty cycle to produce sound
    buzzerPinObject.freq(frequency)  # Set the frequency of the sound
    sleep(sound_duration)  # Play the sound for the specified duration
    buzzerPinObject.duty_u16(int(65536 * 0))  # Stop the sound by setting the duty cycle to 0
    sleep(silence_duration)  # Pause after playing the sound

while True:
    try:
        if left_button.value() == 0:
            display.text(fonts_vga1_16x32, "LEFT      ", 20, 100, 0xffff, 0)
        elif right_button.value() == 0:
            display.text(fonts_vga1_16x32, "RIGHT     ", 20, 100, 0xffff, 0)
        elif up_button.value() == 0:
            display.text(fonts_vga1_16x32, "UP        ", 20, 100, 0xffff, 0)
        elif down_button.value() == 0:
            display.text(fonts_vga1_16x32, "DOWN      ", 20, 100, 0xffff, 0)
        elif a_button.value() == 0:
            display.text(fonts_vga1_16x32, "A         ", 20, 100, 0xffff, 0)
        elif b_button.value() == 0:
            display.text(fonts_vga1_16x32, "B         ", 20, 100, 0xffff, 0)
        elif x_button.value() == 0:
            display.text(fonts_vga1_16x32, "X         ", 20, 100, 0xffff, 0)
            toggle_pin(pin_led_usr)  # Toggle the user LED state
        elif y_button.value() == 0:
            display.text(fonts_vga1_16x32, "Y         ", 20, 100, 0xffff, 0)
            # Play a melody using the buzzer
            buzzer(BuzzerObj, 659, 0.5, 0.1)
            buzzer(BuzzerObj, 587, 0.1, 0.1)
            buzzer(BuzzerObj, 784, 0.5, 0.2)
            BuzzerObj.deinit()  # Deinitialize the buzzer after playing the sound

        # Read voltage and draw on display
        adcReading = vsysChannel.read_u16()  # Read the ADC value
        adcVoltage = (adcReading * 3.3) / 65535  # Convert the ADC value to voltage
        vsysVoltage = adcVoltage * 3  # Multiply by a factor to get the actual voltage
        display.text(fonts_vga1_16x32, f'{vsysVoltage:.2f}V ', 230, 200, 0xff0f, 0)
        # Display the voltage value on the screen
    
    except KeyboardInterrupt:
        break
