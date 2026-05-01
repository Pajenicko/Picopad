"""
In this example, you'll connect Picopad to real world.

We download teletext page image from api.makerclass.cz as 4-bit BMP and display it on screen.
The API converts the original CT teletext PNG to a format suitable for our MCU.

We use raw sockets with recv_into for zero-allocation streaming - adafruit_requests
cannot handle repeated 44KB downloads without memory fragmentation on RP2040.

Use buttons to scroll the page and change the teletext page number.
"""
import wifi
import socketpool
import displayio
import board
import os
import gc
from digitalio import DigitalInOut, Pull

# Setup buttons
btn_down = DigitalInOut(board.SW_DOWN)
# btn_down.direction = Direction.INPUT # - not needed, default is input
btn_down.pull = Pull.UP

btn_up = DigitalInOut(board.SW_UP)
btn_up.pull = Pull.UP

btn_left = DigitalInOut(board.SW_LEFT)
btn_left.pull = Pull.UP

btn_right = DigitalInOut(board.SW_RIGHT)
btn_right.pull = Pull.UP

btn_x = DigitalInOut(board.SW_X)
btn_x.pull = Pull.UP

btn_y = DigitalInOut(board.SW_Y)
btn_y.pull = Pull.UP

btn_a = DigitalInOut(board.SW_A)
btn_a.pull = Pull.UP

btn_b = DigitalInOut(board.SW_B)
btn_b.pull = Pull.UP


# Default teletext page
page = 100

# Initialize WiFi
wifi.radio.connect(os.getenv('CIRCUITPY_WIFI_SSID'), os.getenv('CIRCUITPY_WIFI_PASSWORD'))

display = board.DISPLAY
display.auto_refresh = False
group = displayio.Group()
group.append(displayio.Group())
display.root_group = group

bitmap = None
palette = None

# Pre-allocate small reusable buffer for header + one row
_hdr_buf = bytearray(118)  # 14 BMP + 40 DIB + 64 palette
_row_buf = bytearray(160)  # 320px * 4bpp / 8

def _recv_into(sock, buf, length):
    """Read exactly length bytes from socket into buf, no new allocations."""
    mv = memoryview(buf)
    pos = 0
    while pos < length:
        n = sock.recv_into(mv[pos:length])
        if n == 0:
            break
        pos += n

def teletext(page):

    # We use global palette and bitmap.
    # It is slower, but prevents memory fragmentation - they have same size for all pages
    global bitmap
    global palette

    gc.collect()

    # Manual HTTP request to get raw socket for recv_into
    import socketpool
    pool = socketpool.SocketPool(wifi.radio)
    addr_info = pool.getaddrinfo("api.makerclass.cz", 80)[0]
    sock = pool.socket(addr_info[0], addr_info[1])
    sock.settimeout(10)
    sock.connect(addr_info[4])

    request = f"GET /teletext/getBmp?page={page} HTTP/1.0\r\nHost: api.makerclass.cz\r\n\r\n"
    sock.send(request.encode())

    # Read HTTP response headers line by line
    prev = page
    next_p = page
    header_line = bytearray(128)
    pos = 0
    headers_done = False
    while not headers_done:
        one = bytearray(1)
        sock.recv_into(one)
        if one[0] == 0x0A:  # \n
            line = str(header_line[:pos], "utf-8").strip()
            if line == "":
                headers_done = True
            elif line.lower().startswith("prev:"):
                try:
                    prev = int(line.split(":")[1].strip())
                except:
                    pass
            elif line.lower().startswith("next:"):
                try:
                    next_p = int(line.split(":")[1].strip())
                except:
                    pass
            pos = 0
        elif one[0] != 0x0D:  # skip \r
            if pos < 128:
                header_line[pos] = one[0]
                pos += 1

    # Read BMP header + DIB header + palette (118 bytes)
    _recv_into(sock, _hdr_buf, 118)

    width = int.from_bytes(_hdr_buf[18:22], "little")
    height = int.from_bytes(_hdr_buf[22:26], "little")

    if palette is None:
        palette = displayio.Palette(16)

    # Extract colors from palette (offset 54, each 4 bytes BGRA)
    for i in range(16):
        off = 54 + i * 4
        blue, green, red = _hdr_buf[off], _hdr_buf[off + 1], _hdr_buf[off + 2]
        palette[i] = (red << 16) + (green << 8) + blue

    if bitmap is None:
        bitmap = displayio.Bitmap(width, height, 16)

    # Read and process pixel data row by row (bottom-up BMP)
    for row in range(1, height + 1):
        _recv_into(sock, _row_buf, 160)

        y = height - row
        x = 0
        for i in range(160):
            byte = _row_buf[i]
            bitmap[x, y] = byte >> 4
            x += 1
            bitmap[x, y] = byte & 0x0F
            x += 1

    sock.close()
    del sock
    gc.collect()

    return prev, next_p

# Download and display first page
prev, next = teletext(page)
group[0] = displayio.TileGrid(bitmap, pixel_shader=palette)
display.refresh()
gc.collect()

while True:
    # Teletext page has resolution 320x276 - we need to scroll down to see the whole page
    if (btn_down.value == False):
        group.y = -40
        display.root_group = group
        display.refresh()

    if (btn_up.value == False):
        group.y = 0
        display.root_group = group
        display.refresh()

    # Change teletext page
    if (btn_right.value == False):
        prev, next = teletext(next)
        #group[0] = displayio.TileGrid(bitmap, pixel_shader=palette)
        display.refresh()
        gc.collect()
    
    if (btn_left.value == False):
        prev, next = teletext(prev)
        #group[0] = displayio.TileGrid(bitmap, pixel_shader=palette)
        display.refresh()
        gc.collect()


    if (btn_y.value == False):
        # this is nice alternative to math.ceil()
        # it rounds page to next 10 (eg. from 113 to 120)
        page = int((page + 10)/10)*10
        prev, next = teletext(page)

        display.refresh()
        gc.collect()

    if (btn_x.value == False):
        page = int((page)/10)*10
        prev, next = teletext(page)

        display.refresh()
        gc.collect()

    if (btn_b.value == False):
        page = int((page + 100)/100)*100
        prev, next = teletext(page)

        display.refresh()
        gc.collect()

    if (btn_a.value == False):
        page = int((page)/100)*100
        prev, next = teletext(page)

        gc.collect()

