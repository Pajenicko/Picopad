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

#ifndef PICOPAD_HEADER_H
#define PICOPAD_HEADER_H

#ifdef __cplusplus
extern "C" {
#endif

#include "pico/time.h"
#include "hardware/gpio.h"
#include "hardware/spi.h"
#include "hardware/adc.h"
#include "pico/bootrom.h"
#include "hardware/watchdog.h"
#include "hardware/pwm.h"
#include "hardware/irq.h"
#include "hardware/flash.h"
#include "hardware/dma.h"
#include "pico/sync.h"
#include <math.h>
#include <string.h>
#include "user_config.h"

#ifndef DEFAULT_BRIGHTNESS
#define DEFAULT_BRIGHTNESS 5
#endif

#ifndef DEFAULT_VOLUME
#define DEFAULT_VOLUME 5
#endif

#ifndef DEFAULT_SCREEN_SLEEP
#define DEFAULT_SCREEN_SLEEP 1
#endif

#ifndef DEFAULT_REFRESH_BATTERY
#define DEFAULT_REFRESH_BATTERY 1
#endif

#ifndef DEFAULT_BATTERY_ALARM
#define DEFAULT_BATTERY_ALARM 1
#endif

// Battery alarm threshold to play alarm battery low sound. Can be 0..12
#ifndef BATTERY_ALARM_THRESHOLD
#define BATTERY_ALARM_THRESHOLD 1
#endif

// Duration (in seconds) for which the battery alarm will play an annoying sound :)
#ifndef BATTERY_ALARM_DURATION
#define BATTERY_ALARM_DURATION 0.5
#endif

// Use ST7789 driver. Set to 0 to disable.
#ifndef USE_ST7789
#define USE_ST7789    1
#endif

// Use DRAWTFT driver. Set to 0 to disable.s
#ifndef USE_DRAWTFT
#define USE_DRAWTFT  1
#endif

// PWM sound
#ifndef USE_PWMSND
#define USE_PWMSND  4  // 4 - use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)
#endif

#ifndef USE_SD
#define USE_SD 1
#endif

#ifndef USE_CRC
#define USE_CRC 1
#endif

#ifndef USE_CONFIG
#define USE_CONFIG 1
#endif

#ifndef SYSTICK_KEYSCAN
#define SYSTICK_KEYSCAN    1  // call KeyScan() function from SysTick system timer
#endif

#ifndef USE_PICOPAD_LED
#define USE_PICOPAD_LED  1
#endif

#ifndef PWMSND_GPIO
#define PWMSND_GPIO  15    // PWM output GPIO pin (0..29)
#endif

#ifndef WIDTH
#define WIDTH  320      // display width
#endif

#ifndef HEIGHT
#define HEIGHT  240      // display height
#endif

#ifndef FRAMESIZE
#define FRAMESIZE (WIDTH*HEIGHT)  // frame size in number of colors
#endif

#ifndef DISP_SPI
#define DISP_SPI  spi0    // SPI used for display
#endif

#ifndef DISP_SPI_BAUD
#define DISP_SPI_BAUD  24000000  // SPI baudrate (max. CLK_PERI/2 = 24 MHz, absolute max. 62.5 MHz)
#endif

#ifndef DISP_BLK_PIN
#define DISP_BLK_PIN  16    // backlight pin
#endif

#ifndef DISP_DC_PIN
#define DISP_DC_PIN  17    // data/command pin
#endif

#ifndef DISP_SCK_PIN
#define DISP_SCK_PIN  18    // serial clock pin
#endif

#ifndef DIDP_MOSI_PIN
#define DIDP_MOSI_PIN  19    // master out TX MOSI pin
#endif

#ifndef DISP_RES_PIN
#define DISP_RES_PIN  20    // reset pin
#endif

#ifndef DISP_CS_PIN
#define DISP_CS_PIN  21    // chip selection pin
#endif

#ifndef DISP_ROTATION
#define DISP_ROTATION  1    // display rotations
#endif


#ifndef FONT
#define FONT    FontBold8x16  // default system font
#endif

#ifndef FONTW
#define FONTW    8    // width of system font
#endif

#ifndef FONTH
#define FONTH    16    // height of system font
#endif

// SD card
#ifndef SD_SPI
#define SD_SPI    spi1    // SD card SPI interface
#endif

#ifndef SD_RX
#define SD_RX    12    // SD card RX (MISO input), to DATA_OUT pin 7
#endif

#ifndef SD_CS
#define SD_CS    13    // SD card CS, to CS pin 1
#endif

#ifndef SD_SCK
#define SD_SCK    10  // SD card SCK, to SCLK pin 5
#endif

#ifndef SD_TX
#define SD_TX    11  // SD card TX (MOSI output), to DATA_IN pin 2
#endif

#ifndef SD_BAUDLOW
#define SD_BAUDLOW  250000  // SD card low baud speed (to initialize connection)
#endif

#ifndef SD_BAUD
#define SD_BAUD    2000000 //7000000 // SD card baud speed (should be max. 7-12 Mbit/s; default standard bus speed
//   is 12.5 MB/s, suggested max. bitrate 15 Mbit/s, min. writting speed 2 MB/s)
#endif

// LEDs
#ifndef LED1_PIN
#define LED1_PIN  22  // LED1 inverted, blue, on right
#endif

#ifndef LED2_PIN
#define LED2_PIN  25  // default internal LED pin, on Pico board
#endif

#ifndef LED_PIN
#define LED_PIN 25   // default LED pin on Raspberry Pico
#endif

// Battery
#ifndef BAT_PIN
#define BAT_PIN    29    // input from battery
#endif

#ifndef BAT_ADC
#define BAT_ADC    ADC_MUX_GPIO29  // ADC input
#endif

#ifndef BAT_MUL
#define BAT_MUL    3    // voltage multiplier
#endif

#ifndef BAT_DIODE_FV_INT
#define BAT_DIODE_FV_INT  311    // voltage drop in mV on diode
#endif

#ifndef BAT_DIODE_FV
#define BAT_DIODE_FV    0.311f    // voltage drop in mV on diode
#endif

#ifndef ADC_MUX_GPIO29
#define ADC_MUX_GPIO29  3  // pin GPIO 29
#endif

#ifndef BATTERY_FULL
#define BATTERY_FULL  4.2f    // voltage of full battery
#endif

#ifndef BATTERY_FULL_INT
#define BATTERY_FULL_INT 4200    // voltage of full battery
#endif

#ifndef BATTERY_EMPTY
#define BATTERY_EMPTY  3.1f    // voltage of empty battery
#endif

#ifndef BATTERY_EMPTY_INT
#define BATTERY_EMPTY_INT 3100    // voltage of empty battery
#endif

// Gamepad / Buttons GPIO
#ifndef BTN_UP_PIN
#define BTN_UP_PIN  4  // up
#endif
#ifndef BTN_LEFT_PIN
#define BTN_LEFT_PIN  3  // left
#endif
#ifndef BTN_RIGHT_PIN
#define BTN_RIGHT_PIN  2  // right
#endif
#ifndef BTN_DOWN_PIN
#define BTN_DOWN_PIN  5  // down
#endif
#ifndef BTN_X_PIN
#define BTN_X_PIN  9  // X
#endif
#ifndef BTN_Y_PIN
#define BTN_Y_PIN  8  // Y
#endif
#ifndef BTN_A_PIN
#define BTN_A_PIN  7  // A
#endif
#ifndef BTN_B_PIN
#define BTN_B_PIN  6  // B
#endif

#ifndef KEY_REP_TIME1
#define KEY_REP_TIME1  400  // delta time of first press in [ms] (max 500)
#endif

#ifndef KEY_REP_TIME2
#define KEY_REP_TIME2  100  // delta time of repeat press in [ms] (max 500)
#endif

#ifndef NO_PICO_LED
#define NO_PICO_LED 1
#endif

#define WATCHDOG_MAGIC_VALUE 0xDEADBEEF
#define BOOTLOADER_SIZE  0x30000    // size of boot loader 196608
#define BOOTLOADER_DATA  32    // boot loader resident data

extern const __attribute__((aligned(4))) uint8_t FontBold8x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontBold8x14[3584];
extern const __attribute__((aligned(4))) uint8_t FontBold8x16[4096];
extern const __attribute__((aligned(4))) uint8_t FontBoldB8x14[3584];
extern const __attribute__((aligned(4))) uint8_t FontBoldB8x16[4096];
extern const __attribute__((aligned(4))) uint8_t FontCond6x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontGame8x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontIbm8x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontIbm8x14[3584];
extern const __attribute__((aligned(4))) uint8_t FontIbm8x16[4096];
extern const __attribute__((aligned(4))) uint8_t FontIbmTiny8x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontItalic8x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontThin8x8[2048];
extern const __attribute__((aligned(4))) uint8_t FontTiny5x8[2048];

#include "lib_crc.h"
#if USE_SD
#include "ff.h"
#endif
#include "picopad_sd.h"
#include "picopad_conf.h"
#include "picopad_led.h"
#include "screensaver.h"

#include "picopad_sdk.h"
#include "lib_drawtft.h"
#include "lib_pwmsnd.h"
#include "st7789.h"
#include "picopad_bat.h"
#include "picopad_key.h"
#include "picopad_init.h"


#ifdef __cplusplus
}
#endif

#endif  // PICOPAD_HEADER_H