import board
import struct
import time
import busio
import sdcardio
import storage
import os

display = board.DISPLAY
display.auto_refresh = False

# Setup SD card and mount it to /sd directory

spi = busio.SPI(board.SD_SCK, MOSI=board.SD_MOSI, MISO=board.SD_MISO)
cs = board.SD_CS
sdcard = sdcardio.SDCard(spi, cs, baudrate=31_250_000)
vfs = storage.VfsFat(sdcard)
storage.mount(vfs, "/sd")

def send_chunks_to_display(file_path, width=320, rows = 24):
    
    chunk_size= 2 * width * rows # 2bytes per pixel - every chunk = row * number of rows to display at once
    chunk = bytearray(chunk_size)
    row_start = 0

    send = display.bus.send
    pack = struct.pack
    mw = memoryview

    send(42, pack(">hh", 0, width-1))
    
    with open(file_path, "rb") as f:
        read = f.readinto
        
        while True:
            n = read(chunk)
            if n == 0:
                break
            send(43, pack(">hh", row_start, row_start + rows))
            send(44, mw(chunk)[:n])
            row_start += rows

while True:
    # Bitmaps are in RGB 565 Swapped format (expects .bmp.bin extension)
    # converter: https://lvgl.io/tools/imageconverter
    
    # Get the list of all files in the directory
    image_files = os.listdir("/sd")

    # Filter out non image (.bmp.bin) files
    image_files = [file for file in image_files if file.endswith('.bmp.bin')]

    # Loop through each file and display it
    for file in image_files:
        image_path = "/sd/" + file
        send_chunks_to_display(image_path)
        time.sleep(5)  # Sleep for some time before displaying the next image