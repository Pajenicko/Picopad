
// ****************************************************************************
//
//                   Drawing to TFT display 16-bit 565 buffer
//
// ****************************************************************************

#if USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)

#ifndef _DRAW_H
#define _DRAW_H

#ifdef __cplusplus
extern "C" {
#endif

#include "lib_mat2d.h"

#define TEXTWIDTH	(WIDTH/FONTW)	// width of text buffer (=40)
#define TEXTHEIGHT	(HEIGHT/FONTH)	// height of text buffer (=30)
#define TEXTSIZE	(TEXTWIDTH*TEXTHEIGHT) // size of mono text buffer (=1200)
#define FTEXTSIZE	(TEXTWIDTH*3*TEXTHEIGHT) // size of text buffer with u16 foreground color (=3600)

extern const u8* pDrawFont; // font
extern int DrawFontHeight; // font height
extern int DrawFontWidth; // font width (5 to 8)

// select font
void SelFont5x8();
void SelFont6x8();
void SelFont8x8(); // default
void SelFont8x14();
void SelFont8x16();

// draw rectangle
void DrawRect(int x, int y, int w, int h, u16 col);

// Draw frame
void DrawFrame(int x, int y, int w, int h, u16 col);

// clear canvas with color
void DrawClear(u16 col);

// Draw point
void DrawPoint(int x, int y, u16 col);

// Draw line
void DrawLine(int x1, int y1, int x2, int y2, u16 col);

// Draw filled circle
void DrawFillCircle(int x0, int y0, int r, u16 col);

// Draw circle
void DrawCircle(int x0, int y0, int r, u16 col);

// Draw text (transparent background)
void DrawText(const char* text, int x, int y, u16 col);

// Draw text double sized (transparent background)
void DrawText2(const char* text, int x, int y, u16 col);

// Draw text with background
void DrawTextBg(const char* text, int x, int y, u16 col, u16 bgcol);

// Draw text double sized with background
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

// draw 16-bit image with 2D transformation matrix
//  src ... source image
//  ws ... source image width
//  hs ... source image height
//  x ... destination coordinate X
//  y ... destination coordinate Y
//  w ... destination width
//  h ... destination height
//  m ... transformation matrix (should be prepared using PrepDrawImg or PrepDrawPersp function)
//  mode ... draw mode QDRAWIMG_*
//  color ... key or border color (DRAWIMG_PERSP mode: horizon offset)
// Note to wrap and perspective mode: Width and height of source image must be power of 2!
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
//  mat ... transformation matrix (should be prepared using PrepDrawPersp function)
//  horizon ... horizon offset (0=do not use perspective projection)
void DrawTileMap(const u16* src, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon);

// draw tile map using perspective projection with paletted image
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
//  mat ... transformation matrix (should be prepared using PrepDrawPersp function)
//  horizon ... horizon offset (0=do not use perspective projection)
void DrawTilePalMap(const u8* src, const u16* pal, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon);

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
u16 BlendCol16(u16 col1, u16 col2, u8 level);

#ifdef __cplusplus
}
#endif

#endif // _DRAW_H

#endif // USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)
