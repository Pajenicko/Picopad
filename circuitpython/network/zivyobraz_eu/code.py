
import displayio
import wifi
import socketpool
import adafruit_requests
import os
import time
import alarm
import board
import gc

# Init display
display = board.DISPLAY
display.auto_refresh = False

# Connect to WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))
pool = socketpool.SocketPool(wifi.radio)
requests = adafruit_requests.Session(pool)

mac_addr = ":".join([f"{i:02x}" for i in wifi.radio.mac_address])

bitmap = None
palette = None

def process_zivyobraz(url):

    # We use global palette and bitmap. 
    # It is slower, but prevents memory fragmentation - they have same size for all pages
    global bitmap
    global palette

    with requests.get(url, stream=True) as resp:

        # Get headers
        try:
            sleep_time = int(resp.headers['sleep'])*60
        except:
            sleep_time = 60*60

        # Read BMP header and first 4 bytes from DIB header - they contains size of DIB header (14 + 4 bytes)
        chunk_size = 18
        data = b''
        # We use while loop to read the whole chunk, becouse resp.iter_content() can return less bytes than requested
        while len(data) < chunk_size:
            data += resp.iter_content(chunk_size=chunk_size-len(data)).__next__()

        # Read the rest of DIB header (usually 40 bytes - 4 already read)
        # data[14:18] from previous chunk contains size of DIB header
        chunk_size = int.from_bytes(data[14:18], "little") - 4            
        data = b''
        while len(data) < chunk_size:
            data += resp.iter_content(chunk_size=chunk_size-len(data)).__next__()

        # Extract image size and bit depth from DIB header
        width = int.from_bytes(data[0:4], "little")
        height = int.from_bytes(data[4:8], "little")
        bit_depth = int.from_bytes(data[10:12], "little")
        color_count = 2**bit_depth
        
        # BMP row size in bytes must be multiple of 4, so we need to pad it
        line_width_pad = ((width + width % 4) // 8 * bit_depth)

        # Read and process the color palette (64 bytes for 16 colors, 4BPP)
        chunk_size = color_count * bit_depth
        data = b''
        while len(data) < chunk_size:
            data += resp.iter_content(chunk_size=chunk_size-len(data)).__next__()
            
        #print(width, height, bit_depth, color_count)

        if palette is None:
            palette = displayio.Palette(color_count)

        # Extract colors from the palette and convert them from BGR to RGB
        for i in range(0, len(data), 4):
            blue, green, red, _ = data[i:i+4]
            palette[i//4] = (red << 16) + (green << 8) + blue

        if bitmap is None:
            bitmap = displayio.Bitmap(width, height, color_count)

        # Process the image data row by row from bottom to top

        # Row counter
        row = 1
        # We try to load whole row + padding at once
        chunk_size = line_width_pad

        for data in resp.iter_content(chunk_size=chunk_size):
            # pixel position in the row
            index = 0

            while len(data) < chunk_size:
                data += resp.iter_content(chunk_size=chunk_size-len(data)).__next__()

            # Calculate the current row from bottom
            row_offset = (height - row) * width

            # Process every byte returned
            for byte in data:
                # BMP is 4BPP, so every byte contains 2 pixels - we extract them
                pixel1 = byte >> 4
                pixel2 = byte & 0x0F
                
                # Set the pixels in the bitmap
                bitmap[row_offset + index] = pixel1
                index += 1

                bitmap[row_offset + index] = pixel2
                index += 1

            row += 1
    
    gc.collect()            
    return sleep_time


URL = f"http://cdn.zivyobraz.eu/index.php?mac={mac_addr}&x={display.width}&y={display.height}&c=7C&fw=1"

group = displayio.Group()
group.append(displayio.Group())
display.root_group = group

while True:
    sleep_time = process_zivyobraz(URL)
    group[0] = displayio.TileGrid(bitmap, pixel_shader=palette)
    display.refresh()
    time_alarm = alarm.time.TimeAlarm(monotonic_time=time.monotonic() + sleep_time)
    alarm.light_sleep_until_alarms(time_alarm)
    