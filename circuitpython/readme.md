
# Picopad CircuitPython Tutorial

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

![cp_examples](https://github.com/MakerClassCZ/Picopad/assets/3875093/f0160824-a54e-4ffd-984b-d4e50aa664f1)

## Quick Start

**Prerequisites:**
- A device that supports CircuitPython, such as the PicoPad or Raspberry Pi Pico.
- A USB cable for connecting your device to a computer.
- The latest CircuitPython UF2 firmware image.

![cp_org](https://github.com/MakerClassCZ/Picopad/assets/3875093/0a4c45df-8d69-4a6e-8e6a-49c0504980a7)


**Setting up CircuitPython:**
1. Download the most recent CircuitPython UF2 file for your device from [CircuitPython's official site](https://circuitpython.org/board/pajenicko_picopad/).
2. With the BOOTSEL button pressed (found at the bottom), connect your PicoPad to a power source using the USB cable.
3. Once connected, release the BOOTSEL button. Your PicoPad will now be in bootloader mode.
4. Drag and drop (or copy-paste) the UF2 file you downloaded into the RPI-RP2 drive. The exact filename isn't crucial.
5. After the file transfer, your board will restart. You should then notice the CircuitPython console displayed on the PicoPad's screen.
6. Access the CIRCUITPY drive on your computer and start editing the `code.py` file. Have fun experimenting!

To run the provided tutorial examples, copy both the `code.py` file and the `/lib` directory from the example folder to your device.

Each example directory contains an accompanying README file. This file offers insights into what each example teaches.

The recommended way is to start with hello_world examples, continue to sensors/intro and then explore more complex stuff.


### Where to find modules and libraries

CircuitPython has a bunch of built-in modules. If you need more, [download bundle](https://circuitpython.org/libraries) for your version of CircuitPython. To use a module in your project, copy its `.mpy` file (or directory with its `.mpy` files, if there are more) into `/lib` directory of your project. After that, you may use `import module_name` like with any other module.

There is also [CircuitPyhon community bundle](https://circuitpython.org/libraries) with more modules created by CircuitPython community, but they are not officially supported.


## External Connector Overview

The external connector on the PicoPad provides multiple connection points:

- **Digital Pins**: D0 to D5, which serve as digital input/output (GPIO) pins.
- **Analog Pins**: A0 to A2, used for analog inputs.
- **I2C Pins**: SDA (data line) and SCL (clock line).
- **UART Pins**: RX (receive) and TX (transmit).
- Power and ground connections for your circuits.

You can directly reference these pins in CircuitPython by their respective names, such as `board.D1`.

![cp_picopad_external_connector](https://github.com/MakerClassCZ/Picopad/assets/3875093/e639f8b5-4055-4ee7-8759-27813cc37943)


Happy coding!
