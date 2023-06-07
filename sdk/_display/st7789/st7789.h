
// ****************************************************************************
//
//                          Display controller ST7789
//
// ****************************************************************************

#if USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)

#ifndef _ST7789_H
#define _ST7789_H

#ifdef __cplusplus
extern "C" {
#endif

// 16-bit color definitions
#define COL_BLACK	0x0000
#define COL_BLUE	0x001F
#define COL_RED		0xF800
#define COL_GREEN	0x07E0
#define COL_CYAN	0x07FF
#define COL_MAGENTA	0xF81F
#define COL_YELLOW	0xFFE0
#define COL_GRAY	RGBTO16(128, 128, 128)
#define COL_WHITE	0xFFFF
#define COL_LTBLUE	RGBTO16(0, 128, 255)
#define COL_ORANGE	RGBTO16(255, 128, 0)

// DISP_SPI_BAUD	24000000
// send data: 320x240x2 = 153600 B = 1 228 800 bits
// transfer time: 51 ms, real time: 70 ms
#define DISP_FRAME_MS (320*240*2*9*1000/DISP_SPI_BAUD)	// transfer time of whole frame in [ms]

// frame buffer in RGB 5-6-5 pixel format
extern ALIGNED u16 FrameBuf[FRAMESIZE];

extern u8 DispRot;	// current display rotation
extern u16 DispWidth, DispHeight; // current display size

// dirty window to update
extern int DispDirtyX1, DispDirtyX2, DispDirtyY1, DispDirtyY2;

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

// initialize display
//  rot ... rotation mode
//		0 Portrait
//		1 Landscape
//		2 Inverted Portrait
//		3 Inverted Landscape
void DispInit(u8 rot);

// terminate display
void DispTerm();

#ifdef __cplusplus
}
#endif

#endif // _ST7789_H

#endif // USE_ST7789		// use ST7789 TFT display (st7789.c, st7789.h)
