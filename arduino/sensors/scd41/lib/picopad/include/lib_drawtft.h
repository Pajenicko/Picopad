
// ****************************************************************************
//
//                   Drawing to TFT display 16-bit 565 buffer
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

#if USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)

#ifndef _DRAW_H
#define _DRAW_H

#ifdef __cplusplus
extern "C" {
#endif

#define TEXTWIDTH	(WIDTH/FONTW)	// width of text buffer (=40)
#define TEXTHEIGHT	(HEIGHT/FONTH)	// height of text buffer (=15)
#define TEXTSIZE	(TEXTWIDTH*TEXTHEIGHT) // size of mono text buffer (=600)
#define FTEXTSIZE	(TEXTWIDTH*3*TEXTHEIGHT) // size of text buffer with u16 foreground color (=1800)

// 16-bit color definitions
// - base colors
#define COL_BLACK	RGBTO16(0,0,0)		// 0x0000
#define COL_BLUE	RGBTO16(0,0,255)	// 0x001F
#define COL_GREEN	RGBTO16(0,255,0)	// 0x07E0
#define COL_CYAN	RGBTO16(0,255,255)	// 0x07FF
#define COL_RED		RGBTO16(255,0,0)	// 0xF800
#define COL_MAGENTA	RGBTO16(255,0,255)	// 0xF81F
#define COL_YELLOW	RGBTO16(255,255,0)	// 0xFFE0
#define COL_WHITE	RGBTO16(255,255,255)	// 0xFFFF
#define COL_GRAY	RGBTO16(127,127,127)	// 0x7BEF

// - dark colors
#define COL_DKBLUE	RGBTO16(0,0,127)	// 0x000F
#define COL_DKGREEN	RGBTO16(0,127,0)	// 0x03E0
#define COL_DKCYAN	RGBTO16(0,127,127)	// 0x03EF
#define COL_DKRED	RGBTO16(127,0,0)	// 0x7800
#define COL_DKMAGENTA	RGBTO16(127,0,127)	// 0x780F
#define COL_DKYELLOW	RGBTO16(127,127,0)	// 0x7BE0
#define COL_DKWHITE	RGBTO16(127,127,127)	// 0x7BEF
#define COL_DKGRAY	RGBTO16(63, 63, 63)	// 0x39E7
// - light colors
#define COL_LTBLUE	RGBTO16(127,127,255)	// 0x001F
#define COL_LTGREEN	RGBTO16(127,255,127)	// 0x07E0
#define COL_LTCYAN	RGBTO16(127,255,255)	// 0x07FF
#define COL_LTRED	RGBTO16(255,127,127)	// 0xF800
#define COL_LTMAGENTA	RGBTO16(255,127,255)	// 0xF81F
#define COL_LTYELLOW	RGBTO16(255,255,127)	// 0xFFE0
#define COL_LTGRAY	RGBTO16(191,191,191)	// 0xBDF7

#define COL_AZURE	RGBTO16(0, 127, 255)	// 0x03FF
#define COL_ORANGE	RGBTO16(255, 127, 0)	// 0xFCE0

#define COL_LTORANGE RGBTO16(254, 193, 6)
#define COL_MDKGRAY RGBTO16(54, 54, 54)
#define COL_MDKRED RGBTO16(208, 0, 33)

#define COL_PRINT_DEF	COL_GRAY		// default console print color

extern const u8* pDrawFont; // font
extern int DrawFontHeight; // font height
extern int DrawFontWidth; // font width (5 to 8)
extern u8 DrawPrintPosNum; // number of text positions per row (= WIDTH/DrawFontWidth)
extern u8 DrawPrintRowNum; // number of text rows (= HEIGHT/DrawFontHeight)
extern u8 DrawPrintPos;  // console print character position
extern u8 DrawPrintRow;  // console print character row
extern u8 DrawPrintInv; // offset added to character (128 = print inverted characters, 0 = normal character)
extern u8 DrawPrintSize; // font size: 0=normal, 1=double-height, 2=double-width, 3=double-size
extern u16 DrawPrintCol; // console print color

// select font
void SelFontUpdate(); // update size of text screen after changing font size
void SelFont5x8();
void SelFont6x8();
void SelFont8x8();
void SelFont8x14();
void SelFont8x16();

// draw rectangle
void DrawRect(int x, int y, int w, int h, u16 col);

// Draw frame
void DrawFrame(int x, int y, int w, int h, u16 col);

// clear canvas with color
void DrawClearCol(u16 col);

// clear canvas with black color
void DrawClear();

// Draw point
void DrawPoint(int x, int y, u16 col);

// Draw line
void DrawLine(int x1, int y1, int x2, int y2, u16 col);

// Draw filled circle
void DrawFillCircle(int x0, int y0, int r, u16 col);

// Draw circle
void DrawCircle(int x0, int y0, int r, u16 col);

// Draw character normal/double-height/double-width/double-size, transparent background
void DrawChar(char ch, int x, int y, u16 col);
void DrawCharH(char ch, int x, int y, u16 col);
void DrawCharW(char ch, int x, int y, u16 col);
void DrawChar2(char ch, int x, int y, u16 col);

// Draw character normal/double-height/double-width/double-size, with background
void DrawCharBg(char ch, int x, int y, u16 col, u16 bgcol);
void DrawCharBgH(char ch, int x, int y, u16 col, u16 bgcol);
void DrawCharBgW(char ch, int x, int y, u16 col, u16 bgcol);
void DrawCharBg2(char ch, int x, int y, u16 col, u16 bgcol);

// Draw text normal/double-height/double-width/double-size, transparent background
void DrawText(const char* text, int x, int y, u16 col);
void DrawTextH(const char* text, int x, int y, u16 col);
void DrawTextW(const char* text, int x, int y, u16 col);
void DrawText2(const char* text, int x, int y, u16 col);

// Draw text normal/double-height/double-width/double-size, with background
void DrawTextBg(const char* text, int x, int y, u16 col, u16 bgcol);
void DrawTextBgH(const char* text, int x, int y, u16 col, u16 bgcol);
void DrawTextBgW(const char* text, int x, int y, u16 col, u16 bgcol);
void DrawTextBg2(const char* text, int x, int y, u16 col, u16 bgcol);

// Draw text buffer (size TEXTSIZE)
void DrawTextBuf(const char* textbuf, u16 col, u16 bgcol);

// Draw text buffer with foreground color (size FTEXTSIZE)
void DrawFTextBuf(const char* textbuf, u16 bgcol);

// Draw image
void DrawImg(const u16* src, int xd, int yd, int w, int h, int ws);

// Draw paletted image
void DrawImgPal(const u8* src, const u16* pal, int xd, int yd, int w, int h, int ws);

// Draw 4-bit paletted image
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
void DrawImg4Pal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws);

// Draw paletted image with RLE compression (image must be whole displayed, cannot be clipped)
void DrawImgRle(const u8* src, const u16* pal, int xd, int yd, int w, int h);

// Draw 4-bit paletted image with RLE compression (image must be whole displayed, cannot be clipped)
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
void DrawImg4Rle(const u8* src, const u16* pal, int xd, int yd, int w, int h);

// Draw image with transparency (col = transparency key color)
void DrawBlit(const u16* src, int xd, int yd, int w, int h, int ws, u16 col);

// Draw paletted image with transparency (col = transparency key color)
void DrawBlitPal(const u8* src, const u16* pal, int xd, int yd, int w, int h, int ws, u16 col);

// Draw 4-bit paletted image with transparency
//  xs .... source X
//  ys .... source Y
//  xd .... destination X
//  yd .... destination Y
//  w ..... width
//  h ..... height
//  ws .... source total width (in pixels)
//  col ... transparency key color
void DrawBlit4Pal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws, u16 col);

// Draw rectangle shadow (shad = shadow intenzity 0:black to 15:light shadow)
void DrawRectShadow(int x, int y, int w, int h, u8 shad);

// Draw image with transparency as shadow (col = transparency key color, shad = shadow intenzity 0:black to 15:light shadow)
void DrawBlitShadow(const u16* src, int xd, int yd, int w, int h, int ws, u16 col, u8 shad);

// Draw 1-bit image with transparency as shadow (shad = shadow intenzity 0:black to 15:light shadow)
void DrawBlit1Shadow(const u8* src, int xs, int ys, int xd, int yd, int w, int h, int ws, u8 shad);

// DrawImgMat mode
enum {
	DRAWIMG_WRAP,		// wrap image
	DRAWIMG_NOBORDER,	// no border (transparent border)
	DRAWIMG_CLAMP,		// clamp image (use last pixel as border)
	DRAWIMG_COLOR,		// color border
	DRAWIMG_TRANSP,		// transparent image with key color
	DRAWIMG_PERSP,		// perspective floor
};

#if USE_MAT2D

#include "lib_mat2d.h"

// draw 16-bit image with 2D transformation matrix
//  src ... source image
//  ws ... source image width
//  hs ... source image height
//  x ... destination coordinate X
//  y ... destination coordinate Y
//  w ... destination width
//  h ... destination height
//  m ... transformation matrix (should be prepared using PrepDrawImg function)
//  mode ... draw mode DRAWIMG_*
//  color ... key or border color (DRAWIMG_PERSP mode: horizon offset)
// Note to wrap and perspective mode: Width and height of source image should be power of 2, or it will render slower.
void DrawImgMat(const u16* src, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u16 color);

// draw 8-bit image with 2D transformation matrix
void DrawImgPalMat(const u8* src, const u16* pal, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u16 color);

// draw 4-bit image with 2D transformation matrix
void DrawImg4PalMat(const u8* src, const u16* pal, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u16 color);

// draw tile map using perspective projection
//  src ... source image with column of 16-bit square tiles (width = tile size, must be power of 2)
//  map ... byte map of tile indices
//  mapwbits ... number of bits of map width (number of tiles; width must be power of 2)
//  maphbits ... number of bits of map height (number of tiles; height must be power of 2)
//  tilebits ... number of bits of tile size (e.g. 5 = tile 32x32 pixel)
//  x ... destination coordinate X
//  y ... destination coordinate Y
//  w ... destination width
//  h ... destination height
//  mat ... transformation matrix (should be prepared using PrepDrawImg function)
//  horizon ... horizon offset (0=do not use perspective projection)
void DrawTileMap(const u16* src, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon);

// draw tile map using perspective projection with 8-bit paletted image
//  src ... source image with column of 8-bit square tiles (width = tile size, must be power of 2)
//  pal ... palettes
//  map ... byte map of tile indices
//  mapwbits ... number of bits of map width (number of tiles; width must be power of 2)
//  maphbits ... number of bits of map height (number of tiles; height must be power of 2)
//  tilebits ... number of bits of tile size in pixels (e.g. 5 = tile 32x32 pixel)
//  x ... destination coordinate X
//  y ... destination coordinate Y
//  w ... destination width
//  h ... destination height
//  mat ... transformation matrix (should be prepared using PrepDrawImg function)
//  horizon ... horizon offset (0=do not use perspective projection)
void DrawTilePalMap(const u8* src, const u16* pal, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon);

// draw tile map using perspective projection with 4-bit paletted image
//  src ... source image with column of 4-bit square tiles (width = tile size, must be power of 2)
//  pal ... palettes
//  map ... byte map of tile indices
//  mapwbits ... number of bits of map width (number of tiles; width must be power of 2)
//  maphbits ... number of bits of map height (number of tiles; height must be power of 2)
//  tilebits ... number of bits of tile size in pixels (e.g. 5 = tile 32x32 pixel)
//  x ... destination coordinate X
//  y ... destination coordinate Y
//  w ... destination width
//  h ... destination height
//  mat ... transformation matrix (should be prepared using PrepDrawImg function)
//  horizon ... horizon offset (0=do not use perspective projection)
void DrawTile4PalMap(const u8* src, const u16* pal, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon);

#endif // USE_MAT2D

// draw image line interpolated
//  src = source image
//  xd,yd = destination coordinates
//  wd = destination width
//  ws = source width
//  wbs = source line pitch in bytes
void DrawImgLine(const u16* src, int xd, int yd, int wd, int ws, int wbs);

// draw paletted image line interpolated
void DrawImgPalLine(const u8* src, const u16* pal, int xd, int yd, int wd, int ws, int wbs);

// draw 4-bit paletted image line interpolated
void DrawImg4PalLine(const u8* src, const u16* pal, int xd, int yd, int wd, int ws, int wbs);

// generate gradient
void GenGrad(u16* dst, int w);

// blend 16-bit colors (level is 0=col1 to 16=col2)
//  @TODO: Fast, but not precise (may be darker with missing lowest bit)
u16 BlendCol16(u16 col1, u16 col2, u8 level);

// scroll screen one row up
void DrawScroll();

#ifdef DRAW_PRINT
// console print character (without display update)
//   Control characters:
//     0x01 '\1' ^A ... set not-inverted text
//     0x02 '\2' ^B ... set inverted text (shift character code by 0x80)
//     0x03 '\3' ^C ... use normal-sized font (default)
//     0x04 '\4' ^D ... use double-height font
//     0x05 '\5' ^E ... use double-width font
//     0x06 '\6' ^F ... use double-sized font
//     0x07 '\a' ^G ... (bell) move cursor 1 position right (no print; uses width of normal-sized font)
//     0x08 '\b' ^H ... (back space) move cursor 1 position left (no print; uses width of normal-sized font)
//     0x09 '\t' ^I ... (tabulator) move cursor to next 8-character position, print spaces (uses width of normal-sized font)
//     0x0A '\n' ^J ... (new line) move cursor to start of next row
//     0x0B '\v' ^K ... (vertical tabulator) move cursor to start of previous row
//     0x0C '\f' ^L ... (form feed) clear screen, reset cursor position and set default color
//     0x0D '\r' ^M ... (carriage return) move cursor to start of current row
//     0x10 '\20' ^P ... set gray text color (COL_GRAY, default)
//     0x11 '\21' ^Q ... set blue text color (COL_AZURE)
//     0x12 '\22' ^R ... set green text color (COL_GREEN)
//     0x13 '\23' ^S ... set cyan text color (COL_CYAN)
//     0x14 '\24' ^T ... set red text color (COL_RED)
//     0x15 '\25' ^U ... set magenta text color (COL_MAGENTA)
//     0x16 '\26' ^V ... set yellow text color (COL_YELLOW)
//     0x17 '\27' ^W ... set white text color (COL_WHITE)
void DrawPrintChar(char ch);

// console print text (Control characters - see DrawPrintChar)
//  If text contains digit after hex numeric code of control character,
//  split text to more parts: use "\4" "1" instead of "\41".
void DrawPrintText(const char* txt);

// formatted print string to drawing console, with argument list (returns number of characters, without terminating 0)
u32 DrawPrintArg(const char* fmt, va_list args);

// formatted print string to drawing console, with variadic arguments (returns number of characters, without terminating 0)
NOINLINE u32 DrawPrint(const char* fmt, ...);

#endif

/*
 * -----------------------------------------------------------------------------
 *  Code adapted from Adafruit GFX Library
 *
 *  Original Library Author: Adafruit Industries
 *  Copyright (c) 2013 Adafruit Industries.  All rights reserved.
 *
 *  The original library is available at: https://github.com/adafruit/Adafruit-GFX-Library
 *
 *  Adafruit GFX library is used under [the license the library is released under, e.g., MIT License].
 *  Please ensure that you comply with licensing terms when using or distributing this adapted code.
 * -----------------------------------------------------------------------------
 */
void DrawVLine(int x, int y, int h, u16 color);

void DrawHLine(int x, int y, int w, u16 color);

void DrawFillCircleHelper(int x0, int y0, int r, int corners, int delta, u16 color);

void DrawCircleHelper(int x0, int y0, int r, int cornername, int color);

void DrawFillRect(int x, int y, int w, int h, u16 color);

void DrawRoundRect(int x, int y, int w, int h, int r, u16 color);

void DrawFillRoundRect(int x, int y, int w, int h, int r, int color);

#ifdef __cplusplus
}
#endif

#endif // _DRAW_H

#endif // USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)
