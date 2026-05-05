# Picopad arduino-pico applications

Picopad applications based on arduino-pico and PlatformIO. To run the applications with the original Picopad Loader, a
workaround is used. After building, the application's binary is taken and copied into a UF2 file with the original
Loader. A Python script is run after every build - [Link](./tools/PyCombineLoader).

To be able to run the Arduino applications with the original loader, it was necessary to modify the memmap_default.ld
file and add a section with a header and CRC16 to the crt0.S file (part of the libpico.a file in arduino-pico).

Before each build, these files are automatically copied to the original arduino-pico directory in
```~/.platformio/packages/framework-arduinopico/lib.```

## Directories:

### demos

Contains samples of various programs, usage of PWM Audio, Adafruit GTX library.

### games

Contains samples of two games, e.g., Pacman ported from the original SDK.

### picopad-gb

Gameboy emulator for Picopad.

### sdcard

Builds of individual programs that can be saved to an SD card.

### template

Template for creating programs in arduino-pico in PlatformIO.

### sensors

Sample programs for various sensors, including the NE3 camera.

### tools

A set of various helper Python programs to facilitate the development of applications for Picopad. For example, a
program for converting images, sounds for Picopad, etc.

---

## Build

The application build can be performed in two ways:

### Manually

Manually through the PlatformIO plugin in Visual Studio Code, CLion, etc. In Visual Studio Code:

1. Save your code.
2. Click on the PlatformIO (UFO icon) in the left menu, expand picopad/General, and click on Build. This will execute
   the build for picopad.
3. In the build directory, you will find the UF2 file for uploading to picopad or an SD card.

### Via the build.sh script

In each directory with a program, there is a build.sh file that performs the application build by running a Docker
image. In order for this script to work for you, you first need to create a docker image with the PlatformIO framework.
You can do this by running the script in the tools/docker-build/ directory called build-docker-image.sh. This script
will create an image in your local docker repository for building Arduino PlatformIO applications.

## Build Picopad GameBoy games

---

The rom build can be performed in two ways:

### Manually

1. First, a GameBoy (GB or GBC) ROM is required. The GB ROM should be contained in the file `./src/rom.c`. This is
   necessary for the compilation.

2. To generate this file, use `xxd` utility as follows:
    ```bash
    xxd -i rom.gb > rom.c
    ```
   This command will convert the binary contents of `rom.gb` into a C array and output it to `rom.c`.

3. The content of the C array must then be copied to the `__in_flash("rom") gameRom[]` array.

### Via the build.sh script

1. Copy your ROM to the roms directory.
2. Run the build.sh script.
3. In the rom_builds directory, you will then find UF2 builds of all ROMs from the roms directory.

## Tools

### docker-build

Docker image with the PlatformIO framework. To create docker image for build applications, run script in the
tools/docker-build/ directory called build-docker-image.sh. This script will create an image in your local docker
repository for building Arduino PlatformIO applications.

[Link](./tools/docker-build)

### PyPicoPadImg Generator

This Python program is designed to generate image arrays compatible with Picopad SDK. It takes an image file as input
and
creates a C array of pixel values, ready to be used in your Picopad SDK software. The program utilizes the
Run-Length Encoding (RLE) compression technique to reduce the memory footprint of the images.

Please note that this software currently only tested on 8-bit PNG images using a color lookup table (palette).

The code of this generator is based on the original Picopad SDK source code.

[Link](./tools/PyPicoPadImg)

### PyConvertLoaderImg

PyConvertLoaderImg is a Python-based tool that is capable of converting images into 16-bit BMP images. This tool
specifically generates images that are compatible with the Picopad loader application.

The tool reads image files, provides some basic information about them, downsamples the images by reducing the bit depth
of each color channel, and saves the resulting image as a 16-bit BMP file.

[Link](./tools/PyConvertLoaderImg)

### PyRaspPicoSnd

PyRaspPicoSnd is a Python utility designed to convert audio files into a C++ array format suitable for the Picopad
SDK. The audio is processed to match a specific format: PCM, mono, 8-bit unsigned, with a sample rate of 22050Hz. This
ensures compatibility and optimal playback on the Picopad handheld devices. The tool requires `ffmpeg` for audio format
decoding.

The generated `.c` output contains the audio data in a compact C++ array format, ready for direct integration into
your Picopad SDK software projects.

[Link](./tools/PyRaspPicoSnd)

### PyCombineLoader

A simple Python script that appends an application in a binary file to the Picopad LOADER in the LOADER.UF2 file. In
addition to copying the data after the loader, the script modifies the headers of the individual UF2 file blocks, aligns
the blocks to meet the UF2 specification, and reflects the added binary data.

In addition to modifying and aligning the UF2 blocks, the script calculates and inserts a new CRC16 checksum into the
file. The original loader checks this checksum during startup and program upload.

The script takes advantage of the fact that the original loader launches the application stored at address
```0x10008000```.

[Link](./tools/PyCombineLoader)

---

## Setting Up and Running an Arduino Project with PlatformIO

PlatformIO is a cross-platform IoT development environment that simplifies building projects for a variety of boards,
including Arduino. Here's how to set it up and get your Arduino project running.

### Install Visual Studio Code (VSCode)

PlatformIO works as an extension inside VSCode. First, you need to install VSCode:

1. Visit [VSCode's official website](https://code.visualstudio.com/)
2. Download and install VSCode for your OS.

### Install PlatformIO Extension

1. Open VSCode.
2. Go to Extensions (icon on the sidebar that looks like squares).
3. Search for `PlatformIO IDE`.
4. Click `Install` on the PlatformIO IDE result.

### Create a New Arduino Project

1. Copy the contents of the template directory.
2. Rename the project name in the platformio.io file, replace the name TEMPLATE with the name of your application.
3. Open the application, the directory, via the Visual Studio Code PlatformIO plugin.

### Write Your Code

1. In the Explorer sidebar, navigate to `src` -> `main.cpp`.
2. This is where you'll write your Arduino code. The default file contains a basic template for a blink sketch.

### Build

1. Save your code.
2. Click on the PlatformIO (UFO icon) in the left menu, expand picopad/General, and click on Build. This will execute
   the build for picopad.
3. In the build directory, you will find the UF2 file for uploading to picopad or an SD card.
