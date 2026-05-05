# Picopad GameBoy Emulator

This is a GameBoy emulator for the Picopad, based on the Peanut-GB project. The result of the build is a `.UF2` file
that can be uploaded to Picopad via original loader.

Experimental "FULL" GameBoy Color support is available. To enable this, change ```PEANUT_FULL_GBC_SUPPORT 0``` to
```PEANUT_FULL_GBC_SUPPORT 1``` in the main.cpp file.

## Prerequisites

Ensure you have `xxd` installed on your machine. This utility is used for hex dumps and is typically available in
Unix-like operating systems.


## Building the ROM

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

In each directory with a program, there is a build.sh file that performs the application build by running a Docker
image. In order for this script to work for you, you first need to create a docker image with the PlatformIO framework.
You can do this by running the script in the tools/docker-build/ directory called build-docker-image.sh. This script
will create an image in your local docker repository for building Arduino PlatformIO applications.

1. Copy your ROM to the roms directory.
2. Run the build.sh script.
3. In the rom_builds directory, you will then find UF2 builds of all ROMs from the roms directory.

## Keys

| Gameboy | Picopad |
|---------|---------|
| RIGHT   | RIGHT   |
| UP      | UP      |
| LEFT    | LEFT    |
| DOWN    | DOWN    |
| A       | A       |
| B       | B       |
| START   | X       |
| SELECT  | Y       |
| QUIT    | X + Y   |

## Credits

This project is based on the following works:

- [RP2040-GB](https://github.com/deltabeard/RP2040-GB)
- [Pico-GB](https://github.com/YouMakeTech/Pico-GB/tree/master)
