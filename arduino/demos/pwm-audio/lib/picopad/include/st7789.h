
// ****************************************************************************
//
//                          Display controller ST7789
//
// ****************************************************************************
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/
// License:
//	This source code is freely available for any purpose, including commercial.
//	It is possible to take and modify the code or parts of it, without restriction.

// Example how to configure fast output to LCD display and extern VGA-DVI display:
//#define DISP_SPI_BAUD		50000000	// SPI baudrate (max. CLK_PERI/2 = 24 MHz, absolute max. 62.5 MHz)
//#define PLL_KHZ		200000		// PLL system frequency in kHz (default 125000 kHz)
//#define USE_FAST_PERI		1		// use fast perifery - use system clock instead of USB clock
//#define USE_DISP_DMA		1		// use DMA output do LCD display
//#define DISP_ROT		1		// display rotation of LCD: 0 Portrait, 1 Landscape, 2 Inverted Portrait, 3 Inverted Landscape

#if USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)

#ifndef _ST7789_H
#define _ST7789_H

#ifdef __cplusplus
extern "C" {
#endif

#ifndef WIDTH
#define WIDTH		320		// display width
#endif

#ifndef HEIGHT
#define HEIGHT		240		// display height
#endif

#ifndef COLBITS
#define COLBITS		16		// number of output color bits
#endif

#define COLTYPE		u16		// type of color: u8, u16 or u32
#define FRAMETYPE	u16		// type of frame entry: u8 or u16
#define WIDTHLEN	WIDTH		// length of one line of one plane, in number of frame elements
#define FRAMESIZE 	(WIDTHLEN*HEIGHT) // frame size in number of colors
#define	DISP_STRIP_NUM	1		// number of back strips

#define COLOR_B_BITS	5			// blue color bits
#define COLOR_G_BITS	6			// greem color bits
#define COLOR_R_BITS	5			// red color bits
#define COLOR_B_MASK	0x001F			// blue color mask
#define COLOR_G_MASK	0x07E0			// green color mask
#define COLOR_R_MASK	0xF800			// red color mask
#define COLOR(r,g,b)	((u16)( (((r)&0xf8)<<8) | (((g)&0xfc)<<3) | (((b)&0xf8)>>3) ))

// backlight control
#define BACKLIGHT_SLICE	PWM_GPIOTOSLICE(DISP_BLK_PIN) // backlight slice index
#define BACKLIGHT_CHAN	PWM_GPIOTOCHAN(DISP_BLK_PIN) // backlight channel index
#define BACKLIGHT_RATE	22050		// backlight rate [Hz] (use the same frequency as the audio output,
//	to reduce interference to the audio output)
#define BACKLIGHT_CLOCK	(BACKLIGHT_RATE*256) // PWM clock (= 22050*256 = 5644800)

// DISP_SPI_BAUD	24000000
// send data: 320x240x2 = 153600 B = 1 228 800 bits
// transfer time: 51 ms, real time: 70 ms
#define DISP_FRAME_MS (320*240*2*9*1000/DISP_SPI_BAUD)	// transfer time of whole frame in [ms]

#if USE_FRAMEBUF
// frame buffer in RGB 5-6-5 pixel format
extern ALIGNED FRAMETYPE FrameBuf[];

//extern u16 /*DispWidth,*/ DispHeight; // current display size

#if USE_EMUSCREENSHOT		// use emulator screen shots
extern volatile Bool DoEmuScreenShot;	// request to do emulator screenshot
#endif

// dirty window to update
extern int DispDirtyX1, DispDirtyX2, DispDirtyY1, DispDirtyY2;

// strip of back buffer
/*
extern u16* pDrawBuf; 		// current draw buffer
extern int DispStripInx;	// current index of back buffer strip
extern int DispMinY;		// minimal Y; base of back buffer strip
extern int DispMaxY;		// maximal Y + 1; end of back buffer strip
*/
#define pDrawBuf FrameBuf	// current draw buffer
#define DispStripInx  0		// current index of back buffer strip
#define DispMinY  0		// minimal Y; base of back buffer strip
#define DispMaxY HEIGHT		// maximal Y + 1; end of back buffer strip

// set display rotation
//  0 Portrait
//  1 Landscape
//  2 Inverted Portrait
//  3 Inverted Landscape
void DispRotation(u8 rot);

// set BGR color order instead of RGB
void DispSetModeBGR(Bool bgr);

// flip image horizontal
void DispSetModeFlipX(Bool flipx);

// flip image vertical
void DispSetModeFlipY(Bool flipy);

// set strip of back buffer (-1 = use full FrameBuffer)
INLINE void DispSetStrip(int inx) {}
INLINE void DispSetStripNext() {}

// switch off the back buffer, use only frame buffer to output
INLINE void DispSetStripOff() {}

// load back buffer from frame buffer
INLINE void DispLoad() {}

// set dirty all frame buffer
void DispDirtyAll();

// set dirty none (clear after update)
void DispDirtyNone();

// update dirty area by rectangle (check valid range)
void DispDirtyRect(int x, int y, int w, int h);

// update dirty area by pixel (check valid range)
void DispDirtyPoint(int x, int y);

// update - send dirty window to display
void DispUpdate();

// auto update after delta time in [ms] of running program
void DispAutoUpdate(u32 ms);

// refresh update all display
void DispUpdateAll();

// display backlight control
void DispBacklight(u8 backlight);

#else

void DispClear();

#endif

// initialize display
//  rot ... rotation mode
//		0 Portrait
//		1 Landscape
//		2 Inverted Portrait
//		3 Inverted Landscape
void DispInit(u8 rot);

// terminate display
void DispTerm();

void DispWindow(u16 x1, u16 x2, u16 y1, u16 y2);

void DispWriteData(const void *data, int len);

// display backlight control config update
void DispBacklightUpdate();

// wait for VSync scanline
INLINE void VgaWaitVSync() {}

#ifdef __cplusplus
}
#endif

#endif // _ST7789_H

#endif // USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)