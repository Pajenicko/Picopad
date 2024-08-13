// ****************************************************************************
//
//                          Drawing to frame buffer
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

#if USE_DRAW		// use drawing to frame buffer (lib_draw.c, lib_draw.h)

#ifndef _LIB_DRAW_H
#define _LIB_DRAW_H

//#include "lib_mat2d.h"

#ifdef __cplusplus
extern "C" {
#endif

#define COLOR(r,g,b)	((u16)( (((r)&0xf8)<<8) | (((g)&0xfc)<<3) | (((b)&0xf8)>>3) ))

#define COL_BLACK	COLOR(  0,  0,  0)
#define COL_BLUE	COLOR(  0,  0,255)
#define COL_GREEN	COLOR(  0,255,  0)
#define COL_CYAN	COLOR(  0,255,255)
#define COL_RED		COLOR(255,  0,  0)
#define COL_MAGENTA	COLOR(255,  0,255)
#define COL_YELLOW	COLOR(255,255,  0)
#define COL_WHITE	COLOR(255,255,255)
#define COL_GRAY	COLOR(128,128,128)
// - dark colors
#define COL_DKBLUE	COLOR(  0,  0,127)
#define COL_DKGREEN	COLOR(  0,127,  0)
#define COL_DKCYAN	COLOR(  0,127,127)
#define COL_DKRED	COLOR(127,  0,  0)
#define COL_DKMAGENTA	COLOR(127,  0,127)
#define COL_DKYELLOW	COLOR(127,127,  0)
#define COL_DKWHITE	COLOR(127,127,127)
#define COL_DKGRAY	COLOR( 64, 64, 64)
// - light colors
#define COL_LTBLUE	COLOR(127,127,255)
#define COL_LTGREEN	COLOR(127,255,127)
#define COL_LTCYAN	COLOR(127,255,255)
#define COL_LTRED	COLOR(255,127,127)
#define COL_LTMAGENTA	COLOR(255,127,255)
#define COL_LTYELLOW	COLOR(255,255,127)
#define COL_LTGRAY	COLOR(192,192,192)

#define COL_AZURE	COLOR(  0,127,255)
#define COL_ORANGE	COLOR(255,127,  0)

#define COL_PRINT_DEF	COL_GRAY

#define TEXTWIDTH	(WIDTH/FONTW)	// width of text buffer in number of characters
#define TEXTHEIGHT	(HEIGHT/FONTH)	// height of text buffer in number of characters
#define TEXTSIZE	(TEXTWIDTH*TEXTHEIGHT) // size of mono text buffer in number of bytes
#define FTEXTSIZE	(TEXTWIDTH*TEXTHEIGHT*(1+sizeof(COLTYPE))) // size of text buffer with foreground color

// set even 4-bit pixel
#define SETPIXEL4_EVEN(ddd,ccc) { *(ddd) = (*(ddd) & 0x0f) | ((ccc) << 4); }
#define INVPIXEL4_EVEN(ddd) { *(ddd) ^= 0xf0; }

// set odd 4-bit pixel
#define SETPIXEL4_ODD(ddd,ccc) { *(ddd) = (*(ddd) & 0xf0) | (ccc); }
#define INVPIXEL4_ODD(ddd) { *(ddd) ^= 0x0f; }

// set 4-bit pixel by x coordinate
#define SETPIXEL4(ddd,xxx,ccc) {				\
	if (((xxx) & 1) == 0)					\
		SETPIXEL4_EVEN(ddd,ccc)				\
	else							\
		SETPIXEL4_ODD(ddd,ccc); }

#define INVPIXEL4(ddd,xxx) {					\
	if (((xxx) & 1) == 0)					\
		INVPIXEL4_EVEN(ddd)				\
	else							\
		INVPIXEL4_ODD(ddd); }

// get even 4-bit pixel
#define GETPIXEL4_EVEN(sss) (*(sss) >> 4)

// get odd 4-bit pixel
#define GETPIXEL4_ODD(sss) (*(sss) & 0x0f)

// get 4-bit pixel by x coordinate
#define GETPIXEL4(sss,xxx) ((((xxx) & 1) == 0) ? GETPIXEL4_EVEN(sss) : GETPIXEL4_ODD(sss))

// length of line of the BMP image in bytes (w is width in bytes)
#define IMGWB(w) (((w)+3)&~3)
extern const u8* pDrawFont; // font
extern int DrawFontHeight; // font height
extern int DrawFontWidth; // font width (5 to 8)
extern u8 DrawPrintPosNum; // number of text positions per row (= WIDTH/DrawFontWidth)
extern u8 DrawPrintRowNum; // number of text rows (= HEIGHT/DrawFontHeight)
extern u8 DrawPrintPos;  // console print character position
extern u8 DrawPrintRow;  // console print character row
extern u8 DrawPrintInv; // offset added to character (128 = print inverted characters, 0 = normal character)
extern u8 DrawPrintSize; // font size: 0=normal, 1=double-height, 2=double-width, 3=double-size
extern COLTYPE DrawPrintCol; // console print color

// select font
void SelFontUpdate(); // update size of text screen after changing font size
void SelFont5x8();
void SelFont6x8();
void SelFont8x8();
void SelFont8x14();
void SelFont8x16();

// draw rectangle
void DrawRect(int x, int y, int w, int h, COLTYPE col);

// draw rectangle inverted
void DrawRectInv(int x, int y, int w, int h);

// Draw frame
void DrawFrame(int x, int y, int w, int h, COLTYPE col);

// Draw frame with width
void DrawFrameW(int x, int y, int w, int h, COLTYPE col, int width);

// Draw frame inverted
void DrawFrameInv(int x, int y, int w, int h);

// Draw frame inverted with width
void DrawFrameInvW(int x, int y, int w, int h, int width);

// clear canvas with color
void DrawClearCol(COLTYPE col);

// clear canvas with black color
void DrawClear();

// Draw point
void DrawPoint(int x, int y, COLTYPE col);

// Draw point inverted
void DrawPointInv(int x, int y);

// only for 8, 15 or 16-bit color bits
#if COLBITS >= 8

// get point from frame buffer (returns black color if out on range)
COLTYPE DrawGetPoint(int x, int y);

#endif // COLBITS >= 8

// Draw line with clipping
void DrawLineClip(int x1, int y1, int x2, int y2, COLTYPE col, int xmin, int xmax, int ymin, int ymax);

// Draw line
void DrawLine(int x1, int y1, int x2, int y2, COLTYPE col);

// Draw line with width
// w ... width of line in pixels
// round ... draw round ends
void DrawLineW(int x1, int y1, int x2, int y2, COLTYPE col, int w, Bool round);

// Draw line inverted with clipping
void DrawLineInvClip(int x1, int y1, int x2, int y2, int xmin, int xmax, int ymin, int ymax);

// Draw line inverted
void DrawLineInv(int x1, int y1, int x2, int y2);

// Draw line inverted with width
// w ... width of line in pixels
// round ... draw round ends
void DrawLineInvW(int x1, int y1, int x2, int y2, int w, Bool round);

// Draw filled circle
void DrawFillCircle(int x0, int y0, int r, COLTYPE col);

// Draw filled circle inverted
void DrawFillCircleInv(int x0, int y0, int r);

// Draw circle
void DrawCircle(int x0, int y0, int r, COLTYPE col);

// Draw circle inverted
void DrawCircleInv(int x0, int y0, int r);

// Draw ring
void DrawRing(int x0, int y0, int rin, int rout, COLTYPE col);

// Draw ring inverted
void DrawRingInv(int x0, int y0, int rin, int rout);

// only for 8, 15 or 16-bit color bits
#if COLBITS >= 8

// Fill area in FrameBuf with color
//  x ... X coordinate
//  y ... Y coordinate
//  col ... color to fill
void DrawFill(int x, int y, COLTYPE col);

#endif // COLBITS >= 8

// Draw character normal (transparent background)
void DrawChar(char ch, int x, int y, COLTYPE col);

// Draw character double height (transparent background)
void DrawCharH(char ch, int x, int y, COLTYPE col);

// Draw character double width (transparent background)
void DrawCharW(char ch, int x, int y, COLTYPE col);

// Draw character double sized (transparent background)
void DrawChar2(char ch, int x, int y, COLTYPE col);

// Draw character normal with background
void DrawCharBg(char ch, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw character double height with background
void DrawCharBgH(char ch, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw character double width with background
void DrawCharBgW(char ch, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw character double sized with background
void DrawCharBg2(char ch, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw character quadruple sized with background
void DrawCharBg4(char ch, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw text normal (transparent background)
void DrawText(const char* text, int x, int y, COLTYPE col);

// Draw text double height (transparent background)
void DrawTextH(const char* text, int x, int y, COLTYPE col);

// Draw text double width (transparent background)
void DrawTextW(const char* text, int x, int y, COLTYPE col);

// Draw text double sized (transparent background)
void DrawText2(const char* text, int x, int y, COLTYPE col);

// Draw text normal with background
void DrawTextBg(const char* text, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw text double height with background
void DrawTextBgH(const char* text, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw text double width with background
void DrawTextBgW(const char* text, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw text double sized with background
void DrawTextBg2(const char* text, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw text quadruple sized with background
void DrawTextBg4(const char* text, int x, int y, COLTYPE col, COLTYPE bgcol);

// Draw text buffer (size TEXTSIZE), draw all screen with update
void DrawTextBuf(const char* textbuf, COLTYPE col, COLTYPE bgcol);

// Draw text buffer with foreground color (character + color, size FTEXTSIZE), draw all screen with update
void DrawFTextBuf(const char* textbuf, COLTYPE bgcol);

// Draw image
//  src ... image data
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
void DrawImg(const COLTYPE* src, int xs, int ys, int xd, int yd, int w, int h, int ws);

// only for 8, 15 or 16-bit color bits
#if COLBITS >= 8

// get image content from frame buffer (remaining area fills black)
void DrawGetImg(COLTYPE* dst, int x, int y, int w, int h);

#endif

// only for 15 or 16-bit color bits
#if COLBITS >= 15

// Draw 8-bit paletted image (only for 15 or 16-bit color bits)
//  src ... image data
//  pal ... palettes
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
void DrawImgPal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws);

// Draw 4-bit paletted image (only for 15 or 16-bit color bits)
//  src ... image data
//  pal ... palettes
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
void DrawImg4Pal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws);

// Draw paletted image with RLE compression (image must be whole displayed, cannot be clipped) (only for 15 or 16-bit color bits)
void DrawImgRle(const u8* src, const u16* pal, int xd, int yd, int w, int h);

// Draw 4-bit paletted image with RLE compression (image must be whole displayed, cannot be clipped) (only for 15 or 16-bit color bits)
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
void DrawImg4Rle(const u8* src, const u16* pal, int xd, int yd, int w, int h);

#else // COLBITS >= 15

// Draw 4 or 8-bit image with RLE compression (image must be whole displayed, cannot be clipped) (only for 4 or 8-bit color bits)
void DrawImgRle(const u8* src, int xd, int yd, int w, int h);

#endif // COLBITS >= 15

// Draw image with transparency
//  src ... image data
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
//  col ... transparency key color
void DrawBlit(const COLTYPE* src, int xs, int ys, int xd, int yd, int w, int h, int ws, COLTYPE col);

// only for 8, 15 or 16-bit color bits
#if COLBITS >= 8

// Draw image with transparency and color substitution
//  src ... image data
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
//  col ... transparency key color
//  fnd ... color to find
//  subst ... replaced color
void DrawBlitSubst(const COLTYPE* src, int xs, int ys, int xd, int yd, int w, int h, int ws, COLTYPE col, COLTYPE fnd, COLTYPE subst);

#endif // COLBITS >= 8

// only for 15 or 16-bit color bits
#if COLBITS >= 15

// Draw paletted image with transparency
//  src ... image data
//  pal ... palettes
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
//  col ... transparency key color
void DrawBlitPal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws, COLTYPE col);

// Draw 4-bit paletted image with transparency
//  xs .... source X
//  ys .... source Y
//  xd .... destination X
//  yd .... destination Y
//  w ..... width
//  h ..... height
//  ws .... source total width (in pixels)
//  col ... transparency key color
void DrawBlit4Pal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws, COLTYPE col);

// Draw rectangle shadow (shad = shadow intenzity 0:black to 15:light shadow)
void DrawRectShadow(int x, int y, int w, int h, u8 shad);

// Draw image with transparency as shadow (col = transparency key color, shad = shadow intenzity 0:black to 15:light shadow)
void DrawBlitShadow(const u16* src, int xd, int yd, int w, int h, int ws, u16 col, u8 shad);

// Draw 1-bit image with transparency as shadow (shad = shadow intenzity 0:black to 15:light shadow)
void DrawBlit1Shadow(const u8* src, int xs, int ys, int xd, int yd, int w, int h, int ws, u8 shad);

#endif // COLBITS >= 15

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

// not for 4-bit mode
#if COLBITS != 4

// draw image with 2D transformation matrix
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
void DrawImgMat(const COLTYPE* src, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, COLTYPE color);

#endif // COLBITS != 4

// only for 15 or 16-bit color bits
#if COLBITS >= 15

// draw 8-bit image with 2D transformation matrix
void DrawImgPalMat(const u8* src, const u16* pal, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, COLTYPE color);

// draw 4-bit image with 2D transformation matrix
void DrawImg4PalMat(const u8* src, const u16* pal, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, COLTYPE color);

#endif // COLBITS >= 15

// not for 4-bit mode
#if COLBITS != 4

// draw tile map using perspective projection
//  src ... source image with column of square tiles (width = tile size, must be power of 2)
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
void DrawTileMap(const COLTYPE* src, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon);

#endif // COLBITS != 4

// only for 15 or 16-bit color bits
#if COLBITS >= 15

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

#endif // COLBITS >= 15

#endif // USE_MAT2D

// not for 4-bit mode
#if COLBITS != 4

// draw image line interpolated
//  src = source image
//  xd,yd = destination coordinates
//  wd = destination width
//  ws = source width
//  wbs = source line pitch in bytes
void DrawImgLine(const COLTYPE* src, int xd, int yd, int wd, int ws, int wbs);

#endif // COLBITS != 4

// only for 15 or 16-bit color bits
#if COLBITS >= 15

// draw paletted image line interpolated
void DrawImgPalLine(const u8* src, const u16* pal, int xd, int yd, int wd, int ws, int wbs);

// draw 4-bit paletted image line interpolated
void DrawImg4PalLine(const u8* src, const u16* pal, int xd, int yd, int wd, int ws, int wbs);

#endif // COLBITS >= 15

// not for 4-bit mode
#if COLBITS != 4

// generate gradient
void GenGrad(COLTYPE* dst, int w);

#endif // COLBITS != 4

// only for 16-bit color bits
#if COLBITS == 16

// blend 16-bit colors (level is 0=col1 to 16=col2)
//  @TODO: Fast, but not precise (may be darker with missing lowest bit)
COLTYPE BlendCol16(COLTYPE col1, COLTYPE col2, u8 level);

#endif // COLBITS == 16

// scroll screen one row up
void DrawScroll();

#if COLBITS != 4

// scroll rectangle up (in frame buffer, updates screen) ... not in 4-bit mode
//   x ... X coordinate of rectangle
//   y ... Y coordinate of rectangle
//   w ... width of rectangle
//   h ... height of rectangle
//   dy ... number of lines to scroll up
//   col ... color to clear new space
void DrawScrollRect(int x, int y, int w, int h, int dy, COLTYPE col);

#endif // COLBITS != 4

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
void DrawPrintCharRaw(char ch);

// console print character (with display update; Control characters - see DrawPrintCharRaw)
void DrawPrintChar(char ch);

// console print text (Control characters - see DrawPrintCharRaw)
//  If text contains digit after hex numeric code of control character,
//  split text to more parts: use "\4" "1" instead of "\41".
void DrawPrintText(const char* txt);

#if USE_STREAM	// use Data stream (lib_stream.c, lib_stream.h)

// formatted print string to drawing console, with argument list (returns number of characters, without terminating 0)
u32 DrawPrintArg(const char* fmt, va_list args);

// formatted print string to drawing console, with variadic arguments (returns number of characters, without terminating 0)
NOINLINE u32 DrawPrint(const char* fmt, ...);

#endif // USE_STREAM

#ifdef __cplusplus
}
#endif

#endif // _LIB_DRAW_H

#endif // USE_DRAW		// use drawing to frame buffer (lib_draw.c, lib_draw.h)

// blend two 16-bit colors with ratio 50%+50%
u16 FASTCODE NOFLASH(RGB16Blend50)(u16 col1, u16 col2);

// blend two 16-bit colors with ratio 25%+75%
u16 FASTCODE NOFLASH(RGB16Blend25)(u16 col1, u16 col2);

// blend two 16-bit colors with ratio 12%+87%
u16 FASTCODE NOFLASH(RGB16Blend12)(u16 col1, u16 col2);

// blend four 16-bit colors together
u16 FASTCODE NOFLASH(RGB16Blend4)(u16 col1, u16 col2, u16 col3, u16 col4);