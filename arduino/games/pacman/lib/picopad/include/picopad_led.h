/**
* MIT License
*
* Copyright (c) 2023 Tomas Vecera, tomas@vecera.dev
*
* Portions of this software are derived from the PicoLibSDK:
*   Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
*   Repository: https://github.com/Panda381/PicoLibSDK
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
* documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
* persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
* Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef _PICOPAD_LED_H
#define _PICOPAD_LED_H

#if USE_PICOPAD_LED

#ifdef __cplusplus
extern "C" {
#endif

// LED indices
#define LED1		0	// LED1 index (yellow USR, on the left)
#define LED2		1	// LED internal index (green, on Pico board)

#define LED_NUM		2	// number of LEDs

// set LED ON (inx = LED index LED?_INX)
void led_on(uint8_t inx);

// set LED OFF (inx = LED index LED?_INX)
void led_off(uint8_t inx);

// flip LED (inx = LED index LED?_INX)
void led_flip(uint8_t inx);

// initialize LEDs
void led_init();

// terminate LEDs
void led_terminate();

#ifdef __cplusplus
}
#endif

#endif

#endif // _PICOPAD_LED_H
