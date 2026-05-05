import time
import board
import keypad
import usb_hid
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode
# default US keyboard layout
# from adafruit_hid.keyboard_layout_us import KeyboardLayoutUS as KeyboardLayout
# you can get your keyboard layouts here: https://github.com/Neradoc/Circuitpython_Keyboard_Layouts
from keyboard_layout_win_cz import KeyboardLayout

# keyboard and layout setup
kbd = Keyboard(usb_hid.devices)
layout = KeyboardLayout(kbd)

# define the buttons
buttons = keypad.Keys(
    pins=[board.SW_UP, board.SW_DOWN, board.SW_LEFT, board.SW_RIGHT, board.SW_A, board.SW_B, board.SW_X, board.SW_Y],
    value_when_pressed = False
)

# global event variable - this will store which button was pressed
event = keypad.Event()

while True:
    if buttons.events.get_into(event):
        if event.pressed:
            # you can find predefined keycodes here: https://github.com/adafruit/Adafruit_CircuitPython_HID/blob/main/adafruit_hid/keycode.py    
            # or in the official paper - chapter 10 https://usb.org/sites/default/files/hut1_21.pdf        
            if event.key_number == 0:
                kbd.send(Keycode.UP_ARROW)
                print("UP")
            elif event.key_number == 1:
                kbd.send(Keycode.DOWN_ARROW)
                print("DOWN")
            elif event.key_number == 2:
                kbd.send(Keycode.LEFT_ARROW)
                print("LEFT")
            elif event.key_number == 3:
                kbd.send(Keycode.RIGHT_ARROW)
                print("RIGHT")
            elif event.key_number == 4: # Enter key but send by numeric code 0x28 (just for example)
                kbd.send(0x28)
                print("ENTER")
            elif event.key_number == 5:  # Mute mike in zoom, tea or google meet, select which one do you use
                # Zoom & Teams: Ctrl+Shift+M
                # kbd.send(Keycode.CONTROL, Keycode.SHIFT, Keycode.M)
                # Google Meet: Ctrl+D
                kbd.send(Keycode.CONTROL, Keycode.D)
                print("MUTE mike")
            elif event.key_number == 6:  # Complex macro example
                kbd.send(Keycode.GUI, Keycode.R)
                time.sleep(0.2)
                layout.write("notepad") # converts string to keycodes and sends them, you have to use the right keyboard layout
                time.sleep(0.2)
                kbd.send(Keycode.ENTER)
                time.sleep(0.2)
                layout.write("Hello from the Picopad!")
                print("Macro")
            elif event.key_number == 7:  # Next window - example of pressing, holding and releasing key
                kbd.press(Keycode.ALT, Keycode.TAB)  # ALT+TAB
                time.sleep(0.2)
                kbd.release(Keycode.TAB) # release TAB but still holding ALT
                time.sleep(0.2)
                kbd.send(Keycode.TAB)  # Press the TAB again while still holding ALT
                time.sleep(0.2)
                kbd.release_all()  # Release all keys