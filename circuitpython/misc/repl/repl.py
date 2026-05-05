import board
import os
import gc
import sys
import time
import supervisor
import microcontroller

display = None
requests = None
buttons =  {}
leds = {}
audio_outputs= {}


menu_states = {
    'wifi_connected': False,
    'requests_loaded': False,
    'io_libs_loaded': False,
    'all_libs_loaded': False,
    'peripherals_initialized': False
}


def timeit(func):
    def wrapper(*args, **kwargs):
        t = supervisor.ticks_ms
        t0 = t()
        result = func(*args, **kwargs)
        t1 = t()
        dt = t1 - t0
        print(f'Stopwatch: {dt * 1e-6:.4f} s \033[1;30;49m\n')
        return result
    return wrapper

def load_module(module_name):
    try:
        exec(f"import {module_name}")
        print(f"Loaded {module_name} library.")
    except ImportError as e:
        print(f"Failed to load {module_name} library: {e}")


def load_io_libs():
    print("Loading *io libraries...")
    for module_name in ["digitalio", "analogio", "busio", "displayio"]:
        load_module(module_name)
    return True
    
  
def connect_to_wifi():
    load_module("wifi")
    print("Connecting to WiFi...")
    try:
        wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))
        print(f"Connected to WiFi {os.getenv('CIRCUITPY_WIFI_SSID')}")
        return True
    except Exception as e:
        print(f"Failed to connect to WiFi: {e}")
        return False


def load_all_libs():
    print("Loading all libraries in 'lib' directory...")
    libs_dir = "/lib"
    try:
        files_and_dirs = os.listdir(libs_dir)
    except OSError:
        print(f"Directory {libs_dir} does not exist.")
        return

    for filename in files_and_dirs:
        filepath = f"{libs_dir}/{filename}"
        if filename.endswith(".py"):
            module_name = filename[:-3] 
        elif filename.endswith(".mpy"):
            module_name = filename[:-4] 
        else:
            try:
                os.listdir(filepath)
                module_name = filename
            except OSError:
                continue
        
        load_module(module_name)
    
    return True


def load_requests():
    global requests
    print("Loading requests library...")
    try:
        for module_name in ["adafruit_requests", "socketpool", "ssl"]:
            load_module(module_name)
        pool = socketpool.SocketPool(wifi.radio)
        requests = adafruit_requests.Session(pool, ssl.create_default_context())
        print("'requests' object created")
    except ImportError as e:
        print(f"Failed to load requests library: {e}")


def i2c_scanner():
    print("Scanning I2C bus for devices...")
    import busio
    use_device_db = True
    try:
        import i2c_devices
    except ImportError:
        use_device_db = False

    try:
        i2c = busio.I2C(board.SCL, board.SDA)
        while not i2c.try_lock():
            pass
        try:
            devices = i2c.scan()
            if devices:
                print("I2C devices found:")
                for device in devices:
                    print(f"\n - I2C address: {hex(device)}")
                    if use_device_db:
                        device_name = i2c_devices.i2c_devices.get(device, "Unknown device")
                        print(f" - possible devices: {device_name}")
            else:
                print("No I2C devices found")
        finally:
            i2c.unlock()
        i2c.deinit()
        if use_device_db:
            del sys.modules['i2c_devices']
    except RuntimeError as e:
        print(f"Error: {e}")


def draw_test_pattern():
    import displayio
    display = board.DISPLAY
    print("Drawing test pattern on display...")
    test_pattern = displayio.Group()
    display.root_group = test_pattern

    bitmap = displayio.Bitmap(display.width, display.height, 9)

    # basic color paletter
    palette = displayio.Palette(9)
    palette[0] = 0x000000  # Black
    palette[1] = 0xFFFFFF  # White
    palette[2] = 0xFF0000  # Red
    palette[3] = 0x00FF00  # Green
    palette[4] = 0x0000FF  # Blue
    palette[5] = 0xFFFF00  # Yellow
    palette[6] = 0xFF00FF  # Magenta
    palette[7] = 0x00FFFF  # Cyan
    palette[8] = 0x888888  # Gray

    tile_grid = displayio.TileGrid(bitmap, pixel_shader=palette)
    test_pattern.append(tile_grid)

    segment_width = display.width // 3
    segment_height = display.height // 3

    # color blocks
    for y in range(display.height):
        for x in range(display.width):
            if y < segment_height:
                if x < segment_width:
                    bitmap[x, y] = 2 
                elif x < 2 * segment_width:
                    bitmap[x, y] = 3
                else:
                    bitmap[x, y] = 4
            elif y < 2 * segment_height:
                if x < segment_width:
                    bitmap[x, y] = 5
                elif x < 2 * segment_width:
                    bitmap[x, y] = 6
                else:
                    bitmap[x, y] = 7
            else:
                if x < segment_width:
                    bitmap[x, y] = 1
                elif x < 2 * segment_width:
                    bitmap[x, y] = 8
                else:
                    bitmap[x, y] = 0
    # black cross top left
    for i in range(7):
            bitmap[3, i] = 0
            bitmap[i, 3] = 0

    # white cross bottom right
    for i in range(7):
            bitmap[display.width - 4, display.height - 7 + i] = 1
            bitmap[display.width - 7 + i, display.height - 4] = 1

    x = display.width // 6 - 2
    y = display.height // 6 - 3
    # R 4x7
    bitmap[x,y] = 1
    bitmap[x+1,y] = 1
    bitmap[x+2,y] = 1
    
    bitmap[x,y+1] = 1
    bitmap[x+3,y+1] = 1
    
    bitmap[x,y+2] = 1
    bitmap[x+3,y+2] = 1
    
    bitmap[x,y+3] = 1
    bitmap[x+1,y+3] = 1
    bitmap[x+2,y+3] = 1
    bitmap[x+3,y+3] = 1
    
    bitmap[x,y+4] = 1
    bitmap[x+1,y+4] = 1

    bitmap[x,y+5] = 1
    bitmap[x+2,y+5] = 1

    bitmap[x,y+6] = 1
    bitmap[x+3,y+6] = 1

    x = display.width // 6 * 3 - 2
    # G 4x7
    bitmap[x+1,y] = 0
    bitmap[x+2,y] = 0
    bitmap[x+3,y] = 0

    bitmap[x,y+1] = 0
    bitmap[x+3,y+1] = 0

    bitmap[x,y+2] = 0

    bitmap[x,y+3] = 0

    bitmap[x,y+4] = 0
    bitmap[x+2,y+4] = 0
    bitmap[x+3,y+4] = 0

    bitmap[x,y+5] = 0
    bitmap[x+3,y+5] = 0

    bitmap[x+1,y+6] = 0
    bitmap[x+2,y+6] = 0
    bitmap[x+3,y+6] = 0

    x = display.width // 6 * 5 - 2
    # B 4x7
    bitmap[x,y] = 1
    bitmap[x+1,y] = 1
    bitmap[x+2,y] = 1

    bitmap[x,y+1] = 1
    bitmap[x+3,y+1] = 1

    bitmap[x,y+2] = 1
    bitmap[x+2,y+2] = 1

    bitmap[x,y+3] = 1
    bitmap[x+1,y+3] = 1
    bitmap[x+2,y+3] = 1

    bitmap[x,y+4] = 1
    bitmap[x+3,y+4] = 1

    bitmap[x,y+5] = 1
    bitmap[x+3,y+5] = 1

    bitmap[x,y+6] = 1
    bitmap[x+1,y+6] = 1
    bitmap[x+2,y+6] = 1

    display.refresh()




def initialize_peripherals():
    import pwmio
    import digitalio
    global buttons, leds, audio_outputs
        
    for attribute in dir(board):
        if attribute.startswith('SW') or attribute.startswith('BTN'):
            pin = getattr(board, attribute)
            button = digitalio.DigitalInOut(pin)
            button.direction = digitalio.Direction.INPUT
            button.pull = digitalio.Pull.UP
            buttons[attribute] = button
            print(f"Initialized button: {attribute}")
        
        elif 'LED' in attribute:
            pin = getattr(board, attribute)
            led = digitalio.DigitalInOut(pin)
            led.direction = digitalio.Direction.OUTPUT
            leds[attribute] = led
            print(f"Initialized LED: {attribute}")
        
        elif any(keyword in attribute for keyword in ['AUDIO', 'SOUND', 'SND', 'BUZZ']):
            pin = getattr(board, attribute)
            try:
                audio = pwmio.PWMOut(pin, duty_cycle=0, frequency=440, variable_frequency=True)
                audio_outputs[attribute] = audio
                print(f"Initialized audio output: {attribute}")
            except AttributeError:
                print(f"Failed to initialize PWM: {attribute}")
    return True


def test_buttons(buttons):
    print("Press buttons to see their state. Press Ctrl+C to exit.")
    try:
        while True:
            for name, button in buttons.items():
                if not button.value:
                    print(f"Button {name} pressed")
            time.sleep(0.1)
    except KeyboardInterrupt:
        print("Exiting button test mode.")




def draw_menu(menu_items, title):

    def pad_to_length(text, length):
        return text + ' ' * (length - len(text))

    def center_title(title, width):
        title = f' {title} '
        total_padding = width - len(title)
        left_padding = total_padding // 2
        right_padding = total_padding - left_padding
        return '=' * left_padding + title + '=' * right_padding

    max_width = max(len(item) for item in menu_items)
    title_length = len(title)
    max_width = max(max_width, title_length)

    # Box drawing characters
    top_left = '┌'
    top_right = '┐'
    bottom_left = '└'
    bottom_right = '┘'
    horizontal = '─'
    vertical = '│'

    # Create the top and bottom borders
    border_top = top_left + horizontal * (max_width + 2) + top_right
    border_bottom = bottom_left + horizontal * (max_width + 2) + bottom_right

    # Print the boxed menu with title
    print(border_top)
    # Print centered title
    centered_title = f"{vertical} {center_title(title, max_width)} {vertical}"
    print(centered_title)
    for item in menu_items:
        # Pad the line to the max width
        if item == "---":
            print(vertical + ' ' + horizontal * max_width + ' ' + vertical)
            continue
        padded_line = f"{vertical} {pad_to_length(item, max_width)} {vertical}"
        print(padded_line)
    print(border_bottom)



def boot_to_uf2():
    microcontroller.on_next_reset(microcontroller.RunMode.UF2)
    microcontroller.reset()

def boot_to_file():
    file = input("Reboot to file [default code.py]: ")
    if not file:
        file = 'code.py'
    supervisor.set_next_code_file(file)
    supervisor.reload()


def show_pin_map():
    # Source: https://gist.github.com/anecdata/1c345cb2d137776d76b97a5d5678dc97
    try:
        import cyw43  # Pico W
    except ImportError:
        cyw43 = None

    for pin in dir(microcontroller.pin):
        if isinstance(getattr(microcontroller.pin, pin), microcontroller.Pin) or \
        (cyw43 and isinstance(getattr(microcontroller.pin, pin), cyw43.CywPin)):
            print("".join(("microcontroller.pin.", pin, "\t")), end=" ")
            for alias in dir(board):
                if (getattr(board, alias) is getattr(microcontroller.pin, pin)):
                    print("".join(("", "board.", alias)), end=" ")
        print()

def menu():

    global menu_states, requests, buttons, leds, audio_outputs

   
    while True:
        menu_items = []
        menu_items.append("---")
        if not menu_states['io_libs_loaded']:
            menu_items.append("i - load common io libs")
        if not menu_states['all_libs_loaded']:
            menu_items.append("l - import all libs in '/lib'")
        if not menu_states['wifi_connected']:
            menu_items.append("w - connect to wifi")
        if menu_states['wifi_connected']:
            menu_items.append("r - load requests library")

        if not menu_states['peripherals_initialized']:
            menu_items.append("p - initialize peripherals")
        
        menu_items.append("s - scan I2C bus for devices")
        menu_items.append("d - draw test pattern on display")     
        menu_items.append("m - show pin map") 
        menu_items.append("u - boot to UF2 mode")
        menu_items.append("b - boot to file")      
        menu_items.append("q - quit menu and enter REPL")
        if requests or buttons or leds or audio_outputs:
            menu_items.append("---")
            if requests:
                menu_items.append("* requests")
            if buttons:
                menu_items.append("* buttons")
            if leds:
                menu_items.append("* leds")
            if audio_outputs:
                menu_items.append("* audio_outputs")
        

        draw_menu(menu_items, "Quick Menu:")
        
        choice = input("Choose an option: ")

        if choice == "i":
            menu_states['io_libs_loaded'] = load_io_libs()
        elif choice == "w":
            menu_states['wifi_connected'] = connect_to_wifi()
        elif choice == "r":
            load_requests()
        elif choice == "l":
            menu_states['all_libs_loaded'] = load_all_libs()
        elif choice == "s":
            i2c_scanner()
        elif choice == "d":
            draw_test_pattern()
        elif choice == "u":
            boot_to_uf2()
        elif choice == "m":
            show_pin_map()
        elif choice == "b":
            boot_to_file()
        elif choice == "p":
            menu_states['peripherals_initialized'] = initialize_peripherals()
        elif choice == "q":
            print("Open menu again with menu()")
            print()
            gc.collect()
            break
        else:
            print("Invalid choice. Please try again.")
        time.sleep(1)



menu()