# Picopad
Picopad - open source gaming console based on Raspberry Pi Pico (RP2040)  

![Picopad](hardware/images/picopad.jpg)

## Ready-to-flash binaries

The full SD-card image, the UF2 tree and individual UF2 files for each
game / demo are published as **GitHub Release assets** rather than
committed to this repository. Grab them from the [latest release](https://github.com/Pajenicko/Picopad/releases/latest).

The binaries are produced from [`Panda381/PicoLibSDK/!PicoPad10/`](https://github.com/Panda381/PicoLibSDK/tree/main/!PicoPad10)
and synced via a GitHub Actions workflow (Actions tab → "Sync binaries
from upstream PicoLibSDK"). See [`PicoLibSDK/binaries/README.MD`](PicoLibSDK/binaries/README.MD)
for stable URLs and details.

## Folder descriptions

### `hardware`
The `hardware` folder contains schematics and photos of the Picopad.

### `circuitpython`
The `circuitpython` folder contains libraries and examples for CircuitPython.

### `micropython`
The `micropython` folder contains libraries and examples for MicroPython.

### `arduino`
The `arduino` folder contains PlatformIO projects (sensors, demos, games,
project template) targeting the Arduino-Pico framework.

### `PicoLibSDK`
The `PicoLibSDK` folder contains an alternative extended C/C++ SDK library
for the Raspberry Pico, plus a thin pointer to the binaries Release.

### `scripts`
Helper scripts. `scripts/sync-binaries.sh` is the one used by the binaries
workflow.

## External connector
The console also features an external connector that provides battery power, 3.3V, and GND. It supports communication through UART, has two I2C interfaces, three analog inputs, and six GPIO pins.

![Picopad connector](hardware/images/picopad-connector-schema.jpg)
<img src="hardware/images/picopad-connector.jpg" alt="Picopad connector picture" height="350">


## License
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Permissions:
- You are free to use, modify, and distribute this software.
- You can run the program for any purpose.
- You can study how the program works and make changes to it.
- You can distribute copies of the software to others.
- You can distribute modified versions of the software.

Conditions:
- You must include the original copyright notice and license text with every copy of the software.
- If you modify the software and distribute it, you must provide access to the modified source code under the same license.

Limitations:
- The license does not provide any warranty or guarantee for the software.
- The licensor is not liable for any damages or legal issues caused by the use or distribution of the software.
- Some additional terms and conditions may apply, depending on the specific software.

For a full and legally binding version of the GNU GENERAL PUBLIC LICENSE Version 3, please refer to the license text provided in the LICENSE file.

