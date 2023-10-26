# Import Required Modules
from PIL import Image  # Python Imaging Library (PIL) for image processing
import argparse  # argparse for parsing command-line arguments
import struct  # struct for working with C-style data types
import numpy as np  # numpy for numerical operations
import os  # os for handling file and directory paths
import sys  # sys to access some variables used or maintained by the Python interpreter


def print_bmp_header(filename):
    """
    Function to print the header information of a BMP file.
    """
    print("Result:")
    print("----------------------------------------------------")
    with open(filename, 'rb') as bmp:  # Open the BMP file in read binary mode
        # Read and print the details from the BMP header
        print('Type:', bmp.read(2).decode())  # Print the BMP identifier
        print('Size: %s' % struct.unpack('I', bmp.read(4)))  # Print the file size
        print('Reserved 1: %s' % struct.unpack('H', bmp.read(2)))  # Print the reserved1 field
        print('Reserved 2: %s' % struct.unpack('H', bmp.read(2)))  # Print the reserved2 field
        print('Offset: %s' % struct.unpack('I', bmp.read(4)))  # Print the offset to the pixel data

        # Read and print the details from the DIB header
        print('DIB Header Size: %s' % struct.unpack('I', bmp.read(4)))  # Print the DIB header size
        print('Width: %s' % struct.unpack('I', bmp.read(4)))  # Print the image width
        print('Height: %s' % struct.unpack('i', bmp.read(4)))  # Print the image height
        print('Colour Planes: %s' % struct.unpack('H', bmp.read(2)))  # Print the number of color planes
        print('Bits per Pixel: %s' % struct.unpack('H', bmp.read(2)))  # Print the bits per pixel
        print('Compression Method: %s' % struct.unpack('I', bmp.read(4)))  # Print the compression method
        print('Raw Image Size: %s' % struct.unpack('I', bmp.read(4)))  # Print the raw bitmap data size
        print('Horizontal Resolution: %s' % struct.unpack('I', bmp.read(4)))  # Print the horizontal resolution
        print('Vertical Resolution: %s' % struct.unpack('I', bmp.read(4)))  # Print the vertical resolution
        print('Number of Colours: %s' % struct.unpack('I', bmp.read(4)))  # Print the number of colors in the color palette
        print('Important Colours: %s' % struct.unpack('I', bmp.read(4)))  # Print the number of important colors


def save_bitmap(filename, image_array):
    """
    Function to save the given image array as a BMP file with specified filename.
    """
    rows, cols = image_array.shape  # Get the number of rows and columns in the image array
    padding_size = (4 - (cols * 2) % 4) % 4  # Calculate the size of padding
    row_size = cols * 2 + padding_size  # Calculate the size of one row including padding

    with open(filename, 'wb') as f:  # Open the output file in write binary mode
        # Write the BMP header
        f.write(b'BM')  # Write the BMP identifier
        f.write(struct.pack('<L', 14 + 40 + rows * row_size))  # Write the file size
        f.write(struct.pack('<HH', 0, 0))  # Write the reserved fields
        f.write(struct.pack('<L', 56 + 14))  # Write the offset to the pixel data

        # Write the DIB header
        f.write(struct.pack('<L', 56))  # Write the DIB header size
        f.write(struct.pack('<Li', cols, -rows))  # Write the bitmap width and height
        f.write(struct.pack('<H', 1))  # Write the number of color planes
        f.write(struct.pack('<H', 16))  # Write the bits per pixel
        f.write(struct.pack('<L', 3))  # Write the compression method
        f.write(struct.pack('<L', rows * row_size))  # Write the size of bitmap data
        f.write(struct.pack('<LL', 2835, 2835))  # Write the horizontal and vertical resolution
        f.write(struct.pack('<LL', 0, 0))  # Write the number of colors in the palette and important colors

        # Write the color masks for BI_BITFIELDS
        f.write(struct.pack('<HH', 0xF800, 0))  # Write the mask for red color
        f.write(struct.pack('<HH', 0x07E0, 0))  # Write the mask for green color
        f.write(struct.pack('<HH', 0x001F, 0))  # Write the mask for blue color
        f.write(struct.pack('<HH', 0x0000, 0))  # Write the mask for alpha color

        for y in range(rows):  # For each scan line in the bitmap
            for x in range(cols):  # For each pixel in the scan line
                value = image_array[y, x]  # Get the pixel value
                f.write(struct.pack('<H', value))  # Write the pixel value
            # Write the padding bytes
            for _ in range(padding_size):
                f.write(b'\x00')  # Write the padding byte


def main(input_file, output_file):
    """
    Main function for image processing.
    """
    if not os.path.isfile(input_file):  # If the input file does not exist
        print(f"File '{input_file}' does not exist!!!")  # Print an error message
        sys.exit()  # Exit the program

    filename = os.path.basename(input_file).upper()  # Get the base name of the input file
    filename = filename.split('.')[0] if '.' in filename else filename  # Remove the file extension from the filename

    # Open the image
    image = Image.open(input_file)  # Open the input file as an image

    # Print the image information
    print("Format: ", image.format)  # Print the image format
    print("Format Description: ", Image.MIME[image.format])  # Print the image format description
    print("Size: ", image.size)  # Print the image size
    print("Mode: ", image.mode)  # Print the color mode

    # Print additional information
    print("Image compression: ", image.info.get('compression', 'None'))  # Print the image compression method
    print("DPI: ", image.info.get('dpi', 'Not available'))  # Print the image DPI
    print("Number of bands (Layers): ", len(image.getbands()))  # Print the number of bands (layers) in the image

    # Check if the image is grayscale
    if len(np.array(image).shape) < 3:  # If the image is grayscale
        img_rgb = image.convert('RGB')  # Convert the image to RGB
    else:  # If the image is not grayscale
        img_rgb = image  # Use the original image

    # Convert the image to a numpy array
    data = np.array(img_rgb)  # Convert the image to a numpy array

    # Downsample the image
    r = (data[:, :, 0] >> 3).astype('<u2')  # Downsample the red channel
    g = (data[:, :, 1] >> 2).astype('<u2')  # Downsample the green channel
    b = (data[:, :, 2] >> 3).astype('<u2')  # Downsample the blue channel

    # Combine the downsamples channels
    combined = ((r << 11) | (g << 5) | b).astype('<u2')  # Combine the downsampled channels into one array

    # Save the combined array as a BMP file
    save_bitmap(output_file, combined)  # Save the combined array as a BMP file

    print_bmp_header(output_file)  # Print the header of the output BMP file


if __name__ == "__main__":
    # Command-line Argument Parsing
    parser = argparse.ArgumentParser(description='PyConvertLoaderImg.py')  # Create a new argument parser
    parser.add_argument('-i', '--input', help='Input image file', required=True)  # Add an argument for the input file
    parser.add_argument('-o', '--output', help='Output file', required=True)  # Add an argument for the output file
    args = parser.parse_args()  # Parse the command-line arguments

    # Invoke the main function with the provided arguments
    main(args.input, args.output)  # Invoke the main function with the input and output files from the arguments
