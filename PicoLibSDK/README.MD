# PicoLibSDK

## Folder descriptions:

### `binaries`
The `binaries` folder contains UF2 images used for flashing the device and the contents of the SD card for flashing from the card.

### `community-examples`
The `community-examples` folder contains the examples of programs written for Picopad by the community users

### `sdk`
The `sdk` folder contains the PicoLibSDK

## About

PicoLibSDK is an alternative extended C/C++ SDK library for the Raspberry Pico module with the RP2040 processor, but it can also be used for other modules that use this processor. Compared to the original SDK library, officially provided with the Raspberry Pico, the PicoLibSDK library tries to extend the functionality of the original library and especially to make the SDK library easier to use. What you can find in the PicoLibSDK library:

- Boot Loader: Boot loader allowing selecting and running UF2 programs from the SD card.
- SDK hardware control: ADC, boot ROM, clocks control, CPU control, hardware divider, DMA, double and float arithmetics, FIFO mailboxes, flash programming, GPIO, I2C, hardware interpolator, IRQ, multicore, PIO, PLL, PWM, QSPI, reset and power control, ROSC, RTC, SPI, spinlocks, SysTick, alarm timer, watchdog, XOSC.
- Tool library: alarm, 32-bit Unix calendar, long 64-bit astronomic calendar, canvas drawing, RGBA color vector, CRC check with DMA support, decode numbers, TFT drawing, escape packet protocol, event ring buffer, FAT file system, doubly linked list, memory allocator, 2D transformation matrix, mini-ring buffer, formatted print, PWM sound output, QVGA drawing, random generator, rectangle, ring buffer, DMA ring buffer, SD card, streams, text strings, text list, text print, tree list.
- USB library: multiplayer mini-port, CDC device and host - serial communication, HID device and host - including external keyboard and mouse.
- Big integers: calculations with large integers, calculation of Bernoulli numbers.
- Real numbers: calculations with floating-point numbers with optional precision up to 3690 digits and 30-bit exponent. Scientific functions with optional calculation method - Ln, Exp, Sqrt, Sin, Cos, Tan, arcus, hyperbolic functions, and many more. Linear factorials with accurate and fast calculation.
- Display drivers: Prepared support of TFT display 320x240/16bits and QVGA display 320x240/8 bits.
- Devices: Support of Picoino with 8-bit QVGA display and PicoPad with 16-bit TFT display.
- Samples: Prepared 47 sample programs and games.

For more information, visit the [PicoLibSDK GitHub repository](https://github.com/Panda381/PicoLibSDK).

## License

The library source code is, with a few exceptions, completely free to use for any purpose, including commercial use. It is possible to use and modify all or parts of the library source code without restriction. The only exceptions are the single- and double-floating-point mathematics libraries, which are mostly the copyrighted work of Raspberry Pi and Mark Owen and are, therefore, subject to the licensing terms of the original authors.
