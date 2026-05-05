# PyPicoPadImg Generator

This Python program is designed to generate image arrays compatible with Picopad SDK. It takes a image
files as input and creates a C array of pixel values, ready to be used in your Picopad SDK software. The program
utilizes the Run-Length Encoding (RLE) compression technique to reduce the memory footprint of the images.

Please note that this software currently only tested on 8-bit PNG images using a color lookup table (palette).

Code of this generator is based on the original Picopad SDK source code.

## Dependencies

This program uses the following Python libraries:

- Pillow (PIL)
- argparse

You can install them using pip:

```
pip install pillow argparse
```

## Usage

The program takes an input image file and an output file name as command-line arguments. Optionally, it can also apply
RLE compression to the pixel data.

To run the program, use the following command:

```
python PyPicoPadImg.py -i <input_file> -o <output_file> -r
```

Here, `-i` or `--input` is used to specify the input image file, `-o` or `--output` is used to specify the output file
name, and `-r` or `--rle` is used to indicate that RLE compression should be performed. If `-r` is omitted, the pixel
data will not be compressed.

## Output

The output of the program is a C file with two arrays: a palette array, which holds the color information, and a pixel
data array, which holds the pixel values. If the `-r` option was used, the pixel data will be RLE compressed.

## Links

- Picopad from Pajenicko e-shop
- Picopad SDK (https://github.com/Pajenicko/Picopad)