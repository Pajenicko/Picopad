# PyConvertLoaderImg

PyConvertLoaderImg is a Python-based tool that is capable of converting images into 16-bit BMP images. This tool
specifically generates images that are compatible with the Picopad loader application.

The tool reads image files, provides some basic information about them, downsamples the images by reducing the bit depth
of each color channel, and saves the resulting image as a 16-bit BMP file.

## Features

- Supports conversion of various image formats to BMP
- Compatible with the Picopad loader application
- Provides detailed information about the output image file
- Efficiently handles color depth and downsampling

## Dependencies

- Python 3.7+
- Python Imaging Library (PIL)
- numpy
- argparse
- struct
- os, sys

To install dependencies, use the following command:

```
pip install pillow numpy
```

## Usage

The tool is a command-line program that accepts an input file and an output file as arguments.

```shell
python PyConvertLoaderImg.py -i <input_file> -o <output_file>
```

Here, replace `<input_file>` with the path to your input image file, and replace `<output_file>` with the path to your
desired output BMP file.

For example:

```shell
python PyConvertLoaderImg.py -i example.png -o output.bmp
```

This will convert `example.png` into a 16-bit BMP image `output.bmp`, and it will print detailed information
about `example.bmp` in the terminal.

## Limitations

- Currently, only supports 16-bit BMP output
- Might face issues with extremely large images

## Contribution

Feel free to fork this repository and contribute. Pull requests are welcome.

## Links

- Picopad from Pajenicko e-shop
- Picopad SDK (https://github.com/Pajenicko/Picopad)