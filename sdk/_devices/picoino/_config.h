
// === VGA display
#ifndef USE_VGA
#define USE_VGA		1		// use VGA display (vga.c, vga.h)
#endif

#ifndef USE_CANVAS
#define USE_CANVAS	1		// use Canvas (lib_canvas.c, lib_canvas.h)
#endif

#ifndef USE_TPRINT
#define USE_TPRINT	1		// use Text Print (lib_tprint.c, lib_tprint.h)
#endif

#ifndef VGA_GPIO_FIRST
#define VGA_GPIO_FIRST	2		// first VGA GPIO
#endif

#ifndef VGA_GPIO_NUM
#define VGA_GPIO_NUM	8		// number of VGA color GPIOs, without HSYNC and VSYNC
#endif

#infdef VGA_GPIO_LAST
#define VGA_GPIO_LAST	(VGA_GPIO_FIRST+VGA_GPIO_NUM-1) // last VGA GPIO
#endif

#ifndef VGA_GPIO_SYNC
#define VGA_GPIO_SYNC	10		// VGA HSYNC/CSYNC GPIO
#endif

#ifndef VGA_GPIO_VSYNC
#define VGA_GPIO_VSYNC	11		// VGA VSYNC GPIO
#endif

#ifndef VGA_PIO
#define VGA_PIO		0		// VGA PIO
#endif

#ifndef VGA_SM0
#define VGA_SM0		0		// VGA state machine of base layer 0
#endif

#ifndef VGA_SM1
#define VGA_SM1		1		// VGA state machine of overlapped layer 1
#endif

#ifndef VGA_SM2
#define VGA_SM2		2		// VGA state machine of overlapped layer 2
#endif

#ifndef VGA_SM3
#define VGA_SM3		3		// VGA state machine of overlapped layer 3
#endif

#ifndef VGA_DMA
#define VGA_DMA		2		// VGA DMA base channel (VGA requires 8 channels)
#endif

#ifndef LAYERS
#define LAYERS		4		// total layers 1..4 (1 base layer + 3 overlapped layers)
#endif

#ifndef SEGMAX
#define SEGMAX		8		// max. number of video segment per video strip (size of 1 sSegm = 28 bytes)
#endif

#ifndef STRIPMAX
#define STRIPMAX	8		// max. number of video strips
#endif

#ifndef MAXX
#define MAXX		720		// max. resolution in X direction (must be power of 4)
#endif

#ifndef MAXY
#define MAXY		480		// max. resolution in Y direction
#endif

#ifndef MAXLINE
#define MAXLINE		700		// max. number of scanlines (including sync and dark lines)
#endif

// === keyboard
#ifndef USE_KEY56
#define USE_KEY56	1		// use keyboard 56 keys serial (key56.c, key56.h)
#endif

//	GP16 ... keyboard serial data input/output
//	GP17 ... keyboard clock 1, L->H shift SIPO output register to COL1..COL8,
//			LOW load PISO input register, inverted LED3 (SHIFT)
//	GP18 ... keyboard clock 2, L->H shift PISO input register from ROW1..ROW7..DIP1..DIP2, inverted LED4

#ifndef KEY_DATA_GPIO
#define KEY_DATA_GPIO	16		// serial data input/output
#endif

#ifndef KEY_CLK1_GPIO
#define KEY_CLK1_GPIO	17		// keyboard clock 1, output COL1..COL8
#endif

#ifndef KEY_CLK2_GPIO
#define KEY_CLK2_GPIO	18		// keyboard clock 2, input ROW1..ROW7..DIP1..DIP2
#endif

// === SD card
#ifndef USE_SD
#define USE_SD		1		// use SD card (lib_sd.c, lib_sd.h)
#endif

#ifndef USE_FAT
#define USE_FAT		1		// use FAT file system (lib_fat.c, lib_fat.h)
#endif

#ifndef SD_SPI
#define SD_SPI		1		// SD card SPI interface
#endif

#ifndef SD_RX
#define SD_RX		12		// SD card RX (MISO input), to DATA_OUT pin 7
#endif

#ifndef SD_CS
#define SD_CS		13		// SD card CS, to CS pin 1
#endif

#ifndef SD_SCK
#define SD_SCK		14	// SD card SCK, to SCLK pin 5
#endif

#ifndef SD_TX
#define SD_TX		15	// SD card TX (MOSI output), to DATA_IN pin 2
#endif

#ifndef SD_BAUDLOW
#define SD_BAUDLOW	250000	// SD card low baud speed (to initialize connection)
#endif

#ifndef SD_BAUD
#define SD_BAUD		7000000 // SD card baud speed (should be max. 7-12 Mbit/s; default standard bus speed
				//   is 12.5 MB/s, suggested max. bitrate 15 Mbit/s, min. writting speed 2 MB/s)
#endif

// === PWM sound
#ifndef USE_PWMSND
#define USE_PWMSND	4		// use PWM sound output; set 1.. = number of channels (lib_pwmsnd.c, lib_pwmsnd.h)
#endif

#ifndef PWMSND_GPIO
#define PWMSND_GPIO	0		// PWM output GPIO pin (0..29)
#endif
