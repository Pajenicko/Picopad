# Importing Required Modules
from PIL import Image  # Importing the Python Imaging Library (PIL) module for image processing
import argparse  # Importing the argparse module for command-line argument parsing
import os
import sys

# Variable Initialization
raw_num = 0
raw_start = 0
run_len = 0
run_val = 0
rle_pix = 0
rle_encoded = []  # List to store the RLE-encoded pixel data
pixels = []  # List to store the pixel data
width = 0
height = 0

# Image mode details
modes = {
    '1': '1-bit pixels, black and white',
    'L': '8-bit pixels, black and white',
    'P': '8-bit pixels, using a color lookup table (palette)',
    'RGB': '3x8-bit pixels, true color',
    'RGBA': '4x8-bit pixels, true color with transparency mask',
    'CMYK': '4x8-bit pixels, color separation',
    'YCbCr': '3x8-bit pixels, color video format',
    'LAB': '3x8-bit pixels, the L*a*b color space',
    'HSV': '3x8-bit pixels, Hue, Saturation, Value color space',
    'I': '32-bit signed integer pixels',
    'F': '32-bit floating point pixels'
}


def flush_raw():
    """
    Flushes raw data during RLE compression.
    """
    global raw_num, raw_start, rle_encoded, pixels
    while raw_num > 0:
        rawnum = min(raw_num, 128)
        raw_num -= rawnum

        rle_encoded.append(rawnum - 1)
        for k in range(rawnum, 0, -1):
            rle_encoded.append(pixels[raw_start])
            raw_start += 1


def flush_rle():
    """
    Flushes RLE data during RLE compression.
    """
    global raw_num, raw_start, run_len, rle_pix, rle_encoded

    while run_len > 0:
        rlenum = min(run_len, 130)
        run_len -= rlenum

        if rlenum < 3:
            raw_num += rlenum
        else:
            flush_raw()
            rle_encoded.append((rlenum - 3) + 128)
            rle_encoded.append(rle_pix)
            raw_start += rlenum


def rle_encode():
    """
    Performs RLE compression on the pixel data.
    """
    global raw_num, raw_start, run_len, run_val, rle_pix, rle_encoded, pixels, width, height
    run_val = pixels[0]
    rle_pix = pixels[0]
    s = 0

    for i in range(height):
        raw_start = s
        for j in range(width):
            run_val = pixels[s + j]
            if run_len > 0 and run_val != rle_pix:
                flush_rle()

            rle_pix = run_val
            run_len += 1

        flush_rle()
        flush_raw()
        s += width

    return rle_encoded

def main(input_file, output_file, perform_rle):
    """
    Main function for image processing and code generation.
    """
    global raw_num, raw_start, run_len, run_val, rle_pix, rle_encoded, pixels, width, height

    if not os.path.isfile(input_file):
        print(f"File '{input_file}' does not exist!!!")
        sys.exit()

    filename = os.path.basename(input_file).lower()
    filename = filename.split('.')[0] if '.' in filename else filename
    words = filename.split('_')
    name = ''.join(word.title() for word in words)

    # Open image
    image = Image.open(input_file)

    # Print image information
    print("Format: ", image.format)
    print("Format Description: ", Image.MIME[image.format])
    print("Size: ", image.size)
    print("Mode: ", image.mode)
    print("Image mode details: ", modes.get(image.mode, 'Unknown mode'))

    # Additional info
    print("Image compression: ", image.info.get('compression', 'None'))
    print("DPI: ", image.info.get('dpi', 'Not available'))
    print("Number of bands (Layers): ", len(image.getbands()))

    # Convert the image to indexed mode (paletted)
    image = image.convert("P", colors=256)

    # Get the pixel data as a flat list
    pixels = list(image.getdata())

    # Get the color palette
    palette = image.getpalette()

    # Set the width and height of the image
    width, height = image.size

    # Apply RLE compression
    compressed_pixels = rle_encode()

    file_header = "#include \"picopad.h\"\n\n"
    file_header += "// format: compressed 8-bit paletted pixel graphics\n"
    file_header += f"// image width: {width} pixels\n"
    file_header += f"// image height: {height} lines\n"
    file_header += f"// image pitch: {width} bytes\n"

    # Generate the C code for the palette array
    palette_code = f"const u16 {name}Img_Pal[256] __attribute__((aligned(4))) = {{\n\t"
    for i in range(0, round(len(palette) / 3) - 2):
        r, g, b = palette[i * 3], palette[i * 3 + 1], palette[i * 3 + 2]
        color = (r >> 3) << 11 | (g >> 2) << 5 | (b >> 3)
        palette_code += f"0x{color:04X}, "
        if i % 16 == 15 and i < 256 - 1:
            palette_code += "\n\t"
    palette_code += "\n};\n"

    if perform_rle:
        # Generate the C code for the compressed pixel array
        pixels_code = "// C code for the RLE compressed pixel array\n"
        pixels_code += f"const u8 {name}Img_RLE[{len(compressed_pixels)}] __attribute__((aligned(4))) = {{\n\t"
        for i, pixel in enumerate(compressed_pixels):
            pixels_code += f"0x{pixel:02X}, "
            if i % 16 == 15 and i < len(compressed_pixels) - 1:
                pixels_code += "\n\t"
        pixels_code += "\n};\n"
    else:
        # Generate the C code for the uncompressed pixel array
        pixels_code = "// C code for the uncompressed pixel array\n"
        pixels_code += f"const u8 {name}Img[{width * height}] __attribute__((aligned(4))) = {{\n\t"
        for i, pixel in enumerate(pixels):
            pixels_code += f"0x{pixel:02X}, "
            if i % 16 == 15 and i < len(pixels) - 1:
                pixels_code += "\n\t"
        pixels_code += "\n};\n"

    # Write the C code to a file
    with open(output_file, "w+") as file:
        file.write(file_header)
        file.write("\n")
        file.write(palette_code)
        file.write("\n")
        file.write(pixels_code)


if __name__ == "__main__":
    # Command-line Argument Parsing
    parser = argparse.ArgumentParser(description='PyPicoPadImg generator.')
    parser.add_argument('-i', '--input', help='Input image file', required=True)
    parser.add_argument('-o', '--output', help='Output file', required=True)
    parser.add_argument('-r', '--rle', help='Perform RLE compression (default: True)', action='store_true')
    args = parser.parse_args()

    # Invoke the main function with the provided arguments
    main(args.input, args.output, args.rle)
