
# CircuitPython Tutorial for Beginners

## Introduction

Welcome to the CircuitPython beginner's guide! This tutorial is designed to introduce you to the world of microcontrollers using CircuitPython. By the end of this guide, you'll have a solid understanding of how to use CircuitPython to program devices like the Raspberry Pi Pico found in PicoPad, interface with various hardware components, and create interactive projects.

CircuitPython is a user-friendly version of Python tailored for microcontrollers. It offers a straightforward way to start with physical computing, allowing you to interact with components such as sensors, displays, and motors.

**What you will learn:**
- Fundamentals of programming.
- Interfacing with sensors, displays, buttons, and LEDs.
- Techniques for gathering data, managing hardware, and presenting outputs.
- Physical computing basics and circuit interfacing.
- Crafting projects that incorporate lights, sounds, and graphics.
- Developing simple games.
- Linking devices to the internet and cloud services.

The guide is organized into lessons that progress in complexity. Each lesson includes annotated code samples, which you can try out on your PicoPad or any other CircuitPython-compatible device.

Dive in, practice, and before you know it, you'll be designing your own innovative projects using CircuitPython!

## Quick Start

**Prerequisites:**
- A device that supports CircuitPython, such as the PicoPad or Raspberry Pi Pico.
- A USB cable for connecting your device to a computer.
- The latest CircuitPython UF2 firmware image.

**Setting up CircuitPython:**
1. Download the most recent CircuitPython UF2 file for your device from [CircuitPython's official site](https://circuitpython.org/board/pajenicko_picopad/).
2. With the BOOTSEL button pressed (found at the bottom), connect your PicoPad to a power source using the USB cable.
3. Once connected, release the BOOTSEL button. Your PicoPad will now be in bootloader mode.
4. Drag and drop (or copy-paste) the UF2 file you downloaded into the RPI-RP2 drive. The exact filename isn't crucial.
5. After the file transfer, your board will restart. You should then notice the CircuitPython console displayed on the PicoPad's screen.
6. Access the CIRCUITPY drive on your computer and start editing the `code.py` file. Have fun experimenting!

To run the provided tutorial examples, copy both the `code.py` file and the `/lib` directory from the example folder to your device.

Each example directory contains an accompanying README file. This file offers insights into what each example teaches.

## External Connector Overview

The external connector on the PicoPad provides multiple connection points:

- **Digital Pins**: D0 to D5, which serve as digital input/output (GPIO) pins.
- **Analog Pins**: A0 to A2, used for analog inputs.
- **I2C Pins**: SDA (data line) and SCL (clock line).
- **UART Pins**: RX (receive) and TX (transmit).
- Power and ground connections for your circuits.

You can directly reference these pins in CircuitPython by their respective names, such as `board.D1`.

Happy coding!
