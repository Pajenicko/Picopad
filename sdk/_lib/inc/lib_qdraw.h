
// ****************************************************************************
//
//                           Draw to QVGA 8-bit buffer
//
// ****************************************************************************

#if USE_QDRAW		// use QVGA drawing (lib_qdraw.c, lib_qdraw.h)

#ifndef _QDRAW_H
#define _QDRAW_H

#ifdef __cplusplus
extern "C" {
#endif

#define TEXTWIDTH	(WIDTH/8)	// width of text buffer (=40)
#define TEXTHEIGHT	(HEIGHT/8)	// height of text buffer (=30)
#define TEXTSIZE	(TEXTWIDTH*TEXTHEIGHT) // size of mono text buffer (=1200)
#define FTEXTSIZE	(TEXTWIDTH*2*TEXTHEIGHT) // size of text buffer with foreground color (=2400)

// pointer to draw frame buffer
extern u8* pDrawBuf; // current draw buffer
extern int QDrawWidth, QDrawHeight; // draw buffer dimension
extern const u8* pDrawFont; // font 8x8

// Draw rectangle
void QDrawRect(int x, int y, int w, int h, u8 col);

// Draw frame
void QDrawFrame(int x, int y, int w, int h, u8 col);

// clear canvas (fill with black color)
void QDrawClear();

// Draw point
void QDrawPoint(int x, int y, u8 col);

// Draw line
void QDrawLine(int x1, int y1, int x2, int y2, u8 col);

// Draw filled circle
void QDrawFillCircle(int x0, int y0, int r, u8 col);

// Draw circle
void QDrawCircle(int x0, int y0, int r, u8 col);

// Draw text (transparent background)
void QDrawText(const char* text, int x, int y, u8 col);

// Draw text double sized (transparent background)
void QDrawText2(const char* text, int x, int y, u8 col);

// Draw text with background
void QDrawTextBg(const char* text, int x, int y, u8 col, u8 bgcol);

// Draw text buffer (size TEXTSIZE)
void QDrawTextBuf(const char* textbuf, u8 col, u8 bgcol);

// Draw text buffer with foreground color (size FTEXTSIZE)
void QDrawFTextBuf(const char* textbuf, u8 bgcol);

// Draw image
void QDrawImg(const u8* src, int xd, int yd, int w, int h, int ws);

// Draw image with transparency (col = transparency key color)
void QDrawBlit(const u8* src, int xd, int yd, int w, int h, int ws, u8 col);

// DrawImgMat mode
enum {
	QDRAWIMG_WRAP,		// wrap image
	QDRAWIMG_NOBORDER,	// no border (transparent border)
	QDRAWIMG_CLAMP,		// clamp image (use last pixel as border)
	QDRAWIMG_COLOR,		// color border
	QDRAWIMG_TRANSP,	// transparent image with key color
	QDRAWIMG_PERSP,		// perspective floor
};

// draw 8-bit image with 2D transformation matrix
//  src ... source image
//  ws ... source image width
//  hs ... source image height
//  x ... destination coordinate X
//  y ... destination coordinate Y
//  w ... destination width
//  h ... destination height
//  m ... transformation matrix (should be prepared using PrepDrawImg or PrepDrawPersp function)
//  mode ... draw mode QDRAWIMG_*
//  color ... key or border color (QDRAWIMG_PERSP mode: horizon offset)
// Note to wrap and perspective mode: Width and height of source image must be power of 2!
void QDrawImgMat(const u8* src, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u8 color);

// draw image line interpolated
//  src = source image
//  xd,yd = destination coordinates
//  wd = destination width
//  ws = source width
//  wbs = source line pitch in bytes
void QDrawImgLine(const u8* src, int xd, int yd, int wd, int ws, int wbs);

// generate gradient
void QGenGrad(u8* dst, int w);

/*
// decode unsigned number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecUNum(char* buf, u32 num, char sep = 0);

// decode signed number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecNum(char* buf, s32 num, char sep = 0);

// decode hex number (dig = number of digits)
void DecHexNum(char* buf, u32 num, u8 dig);

// decode 2 digits of number
void Dec2Dig(char* buf, u8 num);

// decode 2 digits of number with space character
void Dec2DigSpc(char* buf, u8 num);

// get ascii text length
int TextLen(const char* txt);
*/

#ifdef __cplusplus
}
#endif

#endif // _QDRAW_H

#endif // USE_QDRAW		// use QVGA drawing (lib_qdraw.c, lib_qdraw.h)
