
// ****************************************************************************
//
//                   Drawing to TFT display 16-bit 565 buffer
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)

#include "../../_font/_include.h"
#include "../../_display/st7789/st7789.h"
#include "../inc/lib_mat2d.h"
#include "../inc/lib_drawtft.h"
#include "../inc/lib_color.h"
#include "../../_sdk/inc/sdk_interp.h"

const u8* pDrawFont = FONT; // font 8x16
int DrawFontHeight = FONTH; // font height
int DrawFontWidth = FONTW; // font width (5 to 8)

// select font 8x8
void SelFont8x8()
{
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;
	DrawFontWidth = 8;
}

// select font 8x14
void SelFont8x14()
{
	pDrawFont = FontBold8x14;
	DrawFontHeight = 14;
	DrawFontWidth = 8;
}

// select font 8x16
void SelFont8x16()
{
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;
}

// select font 6x8
void SelFont6x8()
{
	pDrawFont = FontCond6x8;
	DrawFontHeight = 8;
	DrawFontWidth = 6;
}

// select font 5x8
void SelFont5x8()
{
	pDrawFont = FontTiny5x8;
	DrawFontHeight = 8;
	DrawFontWidth = 5;
}

// draw rectangle
void DrawRect(int x, int y, int w, int h, u16 col)
{
	// limit x
	if (x < 0)
	{
		w += x;
		x = 0;
	}

	// limit w
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	if (y < 0)
	{
		h += y;
		y = 0;
	}

	// limit h
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// draw
	u16* d = &FrameBuf[x + y*DispWidth];
	int wb = DispWidth - w;
	int i;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--) *d++ = col;
		d += wb;
	}
}

// Draw frame
void DrawFrame(int x, int y, int w, int h, u16 col)
{
	if ((w <= 0) || (h <= 0)) return;
	DrawRect(x, y, w-1, 1, col);
	DrawRect(x+w-1, y, 1, h-1, col);
	DrawRect(x+1, y+h-1, w-1, 1, col);
	DrawRect(x, y+1, 1, h-1, col);
}

// clear canvas with color
void DrawClear(u16 col)
{
	int i;
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = col;
	DispDirtyAll();
}

// Draw point
void DrawPoint(int x, int y, u16 col)
{
	// check coordinates
	if (((u32)x >= (u32)DispWidth) || ((u32)y >= (u32)DispHeight)) return;

	// draw pixel
	FrameBuf[x + y*DispWidth] = col;

	// update dirty are by rectangle (must be in valid limits)
	DispDirtyPoint(x, y);
}

// Draw line
void DrawLine(int x1, int y1, int x2, int y2, u16 col)
{
	// difference of coordinates
	int dx = x2 - x1;
	int dy = y2 - y1;

	// increment X
	int sx = 1;
	if (dx < 0)
	{
		sx = -1;
		dx = -dx;
	}

	// increment Y
	int sy = 1;
	int ddy = DispWidth;
	if (dy < 0)
	{
		sy = -1;
		ddy = -ddy;
		dy = -dy;
	}

	// destination address
	u16* d = &FrameBuf[x1 + y1*DispWidth];

	// steeply in X direction, X is prefered as base
	if (dx > dy)
	{
		int m = 2*dy;
		int p = m - dx;
		dx = 2*dx;
		x2 += sx;
		for (; x1 != x2; x1 += sx)
		{
			if (((u32)x1 < (u32)DispWidth) && ((u32)y1 < (u32)DispHeight))
			{
				*d = col;
				DispDirtyPoint(x1, y1);
			}

			if (p > 0)
			{
				d += ddy;
				y1 += sy;;
				p -= dx;
			}
			p += m;
			d += sx;
		}
	}

	// steeply in Y direction, Y is prefered as base
	else
	{
		int m = 2*dx;
		int p = m - dy;
		dy = 2*dy;
		y2 += sy;
		for (; y1 != y2; y1 += sy)
		{
			if (((u32)x1 < (u32)DispWidth) && ((u32)y1 < (u32)DispHeight))
			{
				*d = col;
				DispDirtyPoint(x1, y1);
			}
			if (p > 0)
			{
				d += sx;
				x1 += sx;
				p -= dy;
			}
			p += m;
			d += ddy;
		}
	}
}

// Draw filled circle
void DrawFillCircle(int x0, int y0, int r, u16 col)
{
	int x, y;
	if (r <= 0) return;
	int r2 = r*(r-1);
	r--;

	// full circle
	for (y = -r; y <= r; y++)
	{
		for (x = -r; x <= r; x++)
		{
			if ((x*x + y*y) <= r2) DrawPoint(x+x0, y+y0, col);
		}
	}
}

// Draw circle
void DrawCircle(int x0, int y0, int r, u16 col)
{
	int x, y;
	if (r <= 0) return;
	r--;

	x = 0;
	y = r;
	int p = 1 - r;

	while (x <= y)
	{
		DrawPoint(x0+y, y0-x, col);
		DrawPoint(x0+x, y0-y, col);
		DrawPoint(x0-x, y0-y, col);
		DrawPoint(x0-y, y0-x, col);
		DrawPoint(x0-y, y0+x, col);
		DrawPoint(x0-x, y0+y, col);
		DrawPoint(x0+x, y0+y, col);
		DrawPoint(x0+y, y0+x, col);

		x++;
		if (p > 0)
		{
			y--;
			p -= 2*y;
		}
		p += 2*x + 1;
	}
}

// Draw text (transparent background)
void DrawText(const char* text, int x, int y, u16 col)
{
	// prepare
	int x0 = x;
	int y0 = y;
	u8 ch;
	int i, j;
	const u8* s;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// prepare pointer to font sample
		s = &pDrawFont[ch];

		// loop through lines of one character
		y = y0;
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				if ((ch & 0x80) != 0) DrawPoint(x, y, col);
				x++;
				ch <<= 1;
			}
			y++;
		}

		// shift to next character position
		x0 += DrawFontWidth;
	}
}

// Draw text double sized (transparent background)
void DrawText2(const char* text, int x, int y, u16 col)
{
	// prepare
	int x0 = x;
	int y0 = y;
	u8 ch;
	int i, j;
	const u8* s;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// prepare pointer to font sample
		s = &pDrawFont[ch];

		// loop through lines of one character
		y = y0;
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				if ((ch & 0x80) != 0)
				{
					DrawPoint(x, y, col);
					DrawPoint(x+1, y, col);
					DrawPoint(x, y+1, col);
					DrawPoint(x+1, y+1, col);
				}
				x += 2;
				ch <<= 1;
			}
			y += 2;
		}

		// shift to next character position
		x0 += DrawFontWidth*2;
	}
}

// Draw text with background
void DrawTextBg(const char* text, int x, int y, u16 col, u16 bgcol)
{
	// prepre
	int x0 = x;
	int y0 = y;
	u8 ch;
	u16 c;
	int i, j;
	const u8* s;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// prepare pointer to font sample
		s = &pDrawFont[ch];

		// loop through lines of one character
		y = y0;
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				c = ((ch & 0x80) != 0) ? col : bgcol;

				// draw pixel
				DrawPoint(x, y, c);
				x++;
				ch <<= 1;
			}
			y++;
		}

		// shift to next character position
		x0 += DrawFontWidth;
	}
}

// Draw text double sized with background
void DrawTextBg2(const char* text, int x, int y, u16 col, u16 bgcol)
{
	// prepare
	int x0 = x;
	int y0 = y;
	u8 ch;
	u16 c;
	int i, j;
	const u8* s;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// prepare pointer to font sample
		s = &pDrawFont[ch];

		// loop through lines of one character
		y = y0;
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				c = ((ch & 0x80) != 0) ? col : bgcol;

				// draw pixel
				DrawPoint(x, y, c);
				DrawPoint(x+1, y, c);
				DrawPoint(x, y+1, c);
				DrawPoint(x+1, y+1, c);

				x += 2;
				ch <<= 1;
			}
			y += 2;
		}

		// shift to next character position
		x0 += DrawFontWidth*2;
	}
}

// Draw text buffer (size TEXTSIZE)
void DrawTextBuf(const char* textbuf, u16 col, u16 bgcol)
{
	// prepre
	u8 ch;
	int num, i, j;
	const u8* s;
	int y0, x0;
	u16* d;

	// loop through characters of text
	for (y0 = 0; y0 <= DispHeight - DrawFontHeight; y0 += DrawFontHeight)
	{
		d = &FrameBuf[y0*DispWidth];

		for (x0 = 0; x0 <= DispWidth - DrawFontWidth; x0 += DrawFontWidth)
		{
			// get next character of the text
			ch = (u8)*textbuf++;

			// prepare pointer to font sample
			s = &pDrawFont[ch];

			// loop through lines of one character
			for (i = DrawFontHeight; i > 0; i--)
			{
				// get one font sample
				ch = *s;
				s += 256;

				// loop through pixels of one character line
				for (j = DrawFontWidth; j > 0; j--)
				{
					// draw pixel
					*d++ = ((ch & 0x80) != 0) ? col : bgcol;
					ch <<= 1;
				}
				d += DispWidth - DrawFontWidth;
			}
			d += DrawFontWidth - DrawFontHeight*DispWidth;
		}
	}

	DispDirtyAll();
}

// Draw text buffer with foreground color (1 byte character, 2 bytes color)
void DrawFTextBuf(const char* textbuf, u16 bgcol)
{
	// prepre
	u8 ch;
	u16 col;
	int num, i, j;
	const u8* s;
	int y0, x0;
	u16* d;

	// loop through characters of text
	for (y0 = 0; y0 <= DispHeight - DrawFontHeight; y0 += DrawFontHeight)
	{
		d = &FrameBuf[y0*DispWidth];

		for (x0 = 0; x0 <= DispWidth - DrawFontWidth; x0 += DrawFontWidth)
		{
			// get next character of the text
			ch = (u8)*textbuf++;

			// get foreground color
			col = textbuf[0] + ((u16)textbuf[1]<<8);
			textbuf += 2;

			// prepare pointer to font sample
			s = &pDrawFont[ch];

			// loop through lines of one character
			for (i = DrawFontHeight; i > 0; i--)
			{
				// get one font sample
				ch = *s;
				s += 256;

				// loop through pixels of one character line
				for (j = DrawFontWidth; j > 0; j--)
				{
					// draw pixel
					*d++ = ((ch & 0x80) != 0) ? col : bgcol;
					ch <<= 1;
				}
				d += DispWidth - DrawFontWidth;
			}
			d += DrawFontWidth - DrawFontHeight*DispWidth;
		}
	}

	DispDirtyAll();
}

// Draw image
void DrawImg(const u16* src, int xd, int yd, int w, int h, int ws)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	for (; h > 0; h--)
	{
		memcpy(d, src, w*2);
		d += DispWidth;
		src += ws;
	}
}

// Draw paletted image
void DrawImgPal(const u8* src, const u16* pal, int xd, int yd, int w, int h, int ws)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	int i;
	ws -= w;
	int wd = DispWidth - w;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--) *d++ = pal[*src++];
		d += wd;
		src += ws;
	}
}

// Draw 4-bit paletted image
//  xs ... source X
//  ys ... source Y
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
//  ws ... source total width (in pixels)
void DrawImg4Pal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws)
{
	// limit coordinate X
	if (xs < 0)
	{
		w += xs;
		xd += -xs;
		xs = 0;
	}

	if (xd < 0)
	{
		w += xd;
		xs += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (xs + w > ws) w = ws - xs;
	if (w <= 0) return;

	// limit coordinate Y
	if (ys < 0)
	{
		h += ys;
		yd += -ys;
		ys = 0;
	}

	if (yd < 0)
	{
		h += yd;
		ys += -yd;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d;
	const u8* s;
	int i;
	int x;
	ws = (ws+1)/2;
	for (; h > 0; h--)
	{
		d = &FrameBuf[xd + yd*DispWidth];
		s = &src[xs/2 + ys*ws];
		x = xs;

		for (i = w; i > 0; i--)
		{
			if ((x & 1) == 0)
				*d++ = pal[*s >> 4];
			else
				*d++ = pal[*s++ & 0x0f];
			x++;
		}

		ys++;
		yd++;
	}
}

// Draw paletted image with RLE compression (image must be whole displayed, cannot be clipped)
void DrawImgRle(const u8* src, const u16* pal, int xd, int yd, int w, int h)
{
	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	int i;
	int wd = DispWidth - w;
	int rlenum = 0;
	int rawnum = 0;
	u8 b;
	u16 rlepix;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--)
		{
			// load new flag
			if ((rlenum == 0) && (rawnum == 0))
			{
				b = *src++;

				// RLE string
				if (b >= 128)
				{
					rlenum = b - 128 + 3;
					rlepix = pal[*src++];
				}

				// RAW string
				else
				{
					rawnum = b + 1;
				}
			}

			// write pixel
			if (rlenum != 0)
			{
				*d++ = rlepix;
				rlenum--;
			}
			else
			{
				*d++ = pal[*src++];
				rawnum--;
			}
		}
		d += wd;
	}
}

// Draw 4-bit paletted image with RLE compression (image must be whole displayed, cannot be clipped)
//  xd ... destination X
//  yd ... destination Y
//  w .... width
//  h .... height
void DrawImg4Rle(const u8* src, const u16* pal, int xd, int yd, int w, int h)
{
	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	const u8* s = src;
	int i;
	int wd = DispWidth - w;
	int rlenum = 0;
	int rawnum = 0;
	int x = 0;
	u8 b;
	u16 rlepix;

	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--)
		{
			// load new flag
			if ((rlenum == 0) && (rawnum == 0))
			{
				if ((x & 1) == 0)
					b = *s >> 4;
				else
					b = *s++ & 0x0f;
				x++;

				// RLE string
				if (b >= 8)
				{
					rlenum = b - 8 + 3;

					if ((x & 1) == 0)
						b = *s >> 4;
					else
						b = *s++ & 0x0f;
					x++;

					rlepix = pal[b];
				}

				// RAW string
				else
				{
					rawnum = b + 1;
				}
			}

			// write pixel
			if (rlenum != 0)
			{
				*d++ = rlepix;
				rlenum--;
			}
			else
			{
				if ((x & 1) == 0)
					b = *s >> 4;
				else
					b = *s++ & 0x0f;
				x++;

				*d++ = pal[b];
				rawnum--;
			}
		}
		d += wd;
	}
}

// Draw image with transparency (col = transparency key color)
void DrawBlit(const u16* src, int xd, int yd, int w, int h, int ws, u16 col)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	int i;
	u16 c;
	int wbd = DispWidth - w;
	int wbs = ws - w;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--)
		{
			c = *src++;
			if (c != col) *d = c;
			d++;
		}
		d += wbd;
		src += wbs;
	}
}

// Draw paletted image with transparency (col = transparency key color)
void DrawBlitPal(const u8* src, const u16* pal, int xd, int yd, int w, int h, int ws, u16 col)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	int i;
	u16 c;
	int wbd = DispWidth - w;
	int wbs = ws - w;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--)
		{
			c = pal[*src++];
			if (c != col) *d = c;
			d++;
		}
		d += wbd;
		src += wbs;
	}
}

// Draw 4-bit paletted image with transparency
//  xs .... source X
//  ys .... source Y
//  xd .... destination X
//  yd .... destination Y
//  w ..... width
//  h ..... height
//  ws .... source total width (in pixels)
//  col ... transparency key color
void DrawBlit4Pal(const u8* src, const u16* pal, int xs, int ys, int xd, int yd, int w, int h, int ws, u16 col)
{
	// limit coordinate X
	if (xs < 0)
	{
		w += xs;
		xd += -xs;
		xs = 0;
	}

	if (xd < 0)
	{
		w += xd;
		xs += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (xs + w > ws) w = ws - xs;
	if (w <= 0) return;

	// limit coordinate Y
	if (ys < 0)
	{
		h += ys;
		yd += -ys;
		ys = 0;
	}

	if (yd < 0)
	{
		h += yd;
		ys += -yd;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d;
	const u8* s;
	int i;
	u16 c;
	int x;
	ws = (ws+1)/2;
	for (; h > 0; h--)
	{
		d = &FrameBuf[xd + yd*DispWidth];
		s = &src[xs/2 + ys*ws];
		x = xs;

		for (i = w; i > 0; i--)
		{
			if ((x & 1) == 0)
				c = pal[*s >> 4];
			else
				c = pal[*s++ & 0x0f];
			x++;

			if (c != col) *d = c;
			d++;
		}

		ys++;
		yd++;
	}
}

// Draw rectangle shadow (shad = shadow intenzity 0:black to 15:light shadow)
void DrawRectShadow(int x, int y, int w, int h, u8 shad)
{
	// limit coordinate X
	if (x < 0)
	{
		w += x;
		x = 0;
	}

	// limit w
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit coordinate Y
	if (y < 0)
	{
		h += y;
		y = 0;
	}

	// limit h
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// draw shadow
	u16* d = &FrameBuf[x + y*DispWidth];
	int i;
	u16 c, c2;
	int wb = DispWidth - w;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--)
		{
			c = *d;
			c2 = 0;
			if (shad & B0) c2 = (c >> 4) & ~(B1|B2|B3|B4 | B7|B8|B9|B10 | B12|B13|B14|B15);
			if (shad & B1) c2 += (c >> 3) & ~(B2|B3|B4 | B8|B9|B10 | B13|B14|B15);
			if (shad & B2) c2 += (c >> 2) & ~(B3|B4 | B9|B10 | B14|B15);
			if (shad & B3) c2 += (c >> 1) & ~(B4 | B10 | B15);
			*d = c2;
			d++;
		}
		d += wb;
	}
}

// Draw image with transparency as shadow (col = transparency key color, shad = shadow intenzity 0:black to 15:light shadow)
void DrawBlitShadow(const u16* src, int xd, int yd, int w, int h, int ws, u16 col, u8 shad)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d = &FrameBuf[xd + yd*DispWidth];
	int i;
	u16 c, c2;
	int wbd = DispWidth - w;
	int wbs = ws - w;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--)
		{
			c = *src++;
			if (c != col)
			{
				c = *d;
				c2 = 0;
				if (shad & B0) c2 = (c >> 4) & ~(B1|B2|B3|B4 | B7|B8|B9|B10 | B12|B13|B14|B15);
				if (shad & B1) c2 += (c >> 3) & ~(B2|B3|B4 | B8|B9|B10 | B13|B14|B15);
				if (shad & B2) c2 += (c >> 2) & ~(B3|B4 | B9|B10 | B14|B15);
				if (shad & B3) c2 += (c >> 1) & ~(B4 | B10 | B15);
				*d = c2;
			}
			d++;
		}
		d += wbd;
		src += wbs;
	}
}

// Draw 1-bit image with transparency as shadow (shad = shadow intenzity 0:black to 15:light shadow)
void DrawBlit1Shadow(const u8* src, int xs, int ys, int xd, int yd, int w, int h, int ws, u8 shad)
{
	// limit coordinate X
	if (xs < 0)
	{
		w += xs;
		xd += -xs;
		xs = 0;
	}

	if (xd < 0)
	{
		w += xd;
		xs += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > DispWidth) w = DispWidth - xd;
	if (xs + w > ws) w = ws - xs;
	if (w <= 0) return;

	// limit coordinate Y
	if (ys < 0)
	{
		h += ys;
		yd += -ys;
		ys = 0;
	}

	if (yd < 0)
	{
		h += yd;
		ys += -yd;
		yd = 0;
	}

	// limit h
	if (yd + h > DispHeight) h = DispHeight - yd;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(xd, yd, w, h);

	// draw image
	u16* d;
	const u8* s;
	int i;
	u16 c, c2;
	ws = (ws + 7)/8;
	int x;
	for (; h > 0; h--)
	{
		x = xs;
		d = &FrameBuf[xd + yd*DispWidth];
		s = &src[xs/8 + ws*ys];

		for (i = w; i > 0; i--)
		{
			if (((*s << (x & 7)) & 0x80) != 0)
			{
				c = *d;
				c2 = 0;
				if (shad & B0) c2 = (c >> 4) & ~(B1|B2|B3|B4 | B7|B8|B9|B10 | B12|B13|B14|B15);
				if (shad & B1) c2 += (c >> 3) & ~(B2|B3|B4 | B8|B9|B10 | B13|B14|B15);
				if (shad & B2) c2 += (c >> 2) & ~(B3|B4 | B9|B10 | B14|B15);
				if (shad & B3) c2 += (c >> 1) & ~(B4 | B10 | B15);
				*d = c2;
			}
			d++;
			x++;
			if ((x & 7) == 0) s++;
		}
		yd++;
		ys++;
	}
}

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
//  mode ... draw mode DRAWIMG_*
//  color ... key or border color (DRAWIMG_PERSP mode: horizon offset)
// Note to wrap and perspective mode: Width and height of source image must be power of 2!
void DrawImgMat(const u16* src, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u16 color)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (mode == DRAWIMG_PERSP) ? (-h) : (-h/2); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// load transformation matrix and convert to integer fractional number
	int m11 = (int)(m->m11*FRACTMUL+0.5f);
	int m12 = (int)(m->m12*FRACTMUL+0.5f);
	int m13 = (int)(m->m13*FRACTMUL+0.5f);
	int m21 = (int)(m->m21*FRACTMUL+0.5f);
	int m22 = (int)(m->m22*FRACTMUL+0.5f);
	int m23 = (int)(m->m23*FRACTMUL+0.5f);

	// zero size image
	if ((m11 == 0) || (m22 == 0)) return;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width words
	int i, x2, y2;

	// wrap image
	if (mode == DRAWIMG_WRAP)
	{
		// coordinate mask
		int xmask = ws - 1;
		int ymask = hs - 1;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = (xy0m>>FRACT) & xmask;
				y2 = (yy0m>>FRACT) & ymask;
				*d++ = src[x2 + y2*ws];
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}

			y0++;
			d += wbd;
		}
	}

	// no border
	else if (mode == DRAWIMG_NOBORDER)
	{
		// source image dimension
		u32 ww = ws;
		u32 hh = hs;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;

			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh)) *d = src[x2 + y2*ws];
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// clamp image
	else if (mode == DRAWIMG_CLAMP)
	{
		// source image dimension
		u32 ww = ws - 1;
		u32 hh = hs - 1;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (x2 < 0) x2 = 0;
				if (x2 > ww) x2 = ww;
				if (y2 < 0) y2 = 0;
				if (y2 > hh) y2 = hh;
				*d++ = src[x2 + y2*ws];
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// color border
	else if (mode == DRAWIMG_COLOR)
	{
		// source image dimension
		u32 ww = ws;
		u32 hh = hs;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
					*d = src[x2 + y2*ws];
				else
					*d = color;
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// transparency
	else if (mode == DRAWIMG_TRANSP)
	{
		u32 ww = ws;
		u32 hh = hs;
		u16 c;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
				{
					c = src[x2 + y2*ws];
					if (c != color) *d = c;
				}
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// perspective
	else if (mode == DRAWIMG_PERSP)
	{
		// coordinate mask
		int xmask = ws - 1;
		int ymask = hs - 1;

		for (; h > 0; h--)
		{
			int dist = FRACTMUL*h0/(h0 + y0 + color + 1);
			int m11b = (m11*dist)>>FRACT;
			int m21b = (m21*dist)>>FRACT;
			int m12b = (m12*dist)>>FRACT;
			int m22b = (m22*dist)>>FRACT;

			xy0m = x0*m11b + y0*m12b + m13;
			yy0m = x0*m21b + y0*m22b + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = (xy0m>>FRACT) & xmask;
				xy0m += m11b; // x0*m11

				y2 = (yy0m>>FRACT) & ymask;
				yy0m += m21b; // x0*m21

				*d++ = src[x2 + y2*ws];
			}
			y0++;
			d += wbd;
		}
	}
}

// draw 8-bit image with 2D transformation matrix
void DrawImgPalMat(const u8* src, const u16* pal, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u16 color)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (mode == DRAWIMG_PERSP) ? (-h) : (-h/2); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// load transformation matrix and convert to integer fractional number
	int m11 = (int)(m->m11*FRACTMUL+0.5f);
	int m12 = (int)(m->m12*FRACTMUL+0.5f);
	int m13 = (int)(m->m13*FRACTMUL+0.5f);
	int m21 = (int)(m->m21*FRACTMUL+0.5f);
	int m22 = (int)(m->m22*FRACTMUL+0.5f);
	int m23 = (int)(m->m23*FRACTMUL+0.5f);

	// zero size image
	if ((m11 == 0) || (m22 == 0)) return;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width words
	int i, x2, y2;

	// wrap image
	if (mode == DRAWIMG_WRAP)
	{
		// coordinate mask
		int xmask = ws - 1;
		int ymask = hs - 1;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = (xy0m>>FRACT) & xmask;
				y2 = (yy0m>>FRACT) & ymask;
				*d++ = pal[src[x2 + y2*ws]];
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}

			y0++;
			d += wbd;
		}
	}

	// no border
	else if (mode == DRAWIMG_NOBORDER)
	{
		// source image dimension
		u32 ww = ws;
		u32 hh = hs;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;

			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh)) *d = pal[src[x2 + y2*ws]];
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// clamp image
	else if (mode == DRAWIMG_CLAMP)
	{
		// source image dimension
		u32 ww = ws - 1;
		u32 hh = hs - 1;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (x2 < 0) x2 = 0;
				if (x2 > ww) x2 = ww;
				if (y2 < 0) y2 = 0;
				if (y2 > hh) y2 = hh;
				*d++ = pal[src[x2 + y2*ws]];
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// color border
	else if (mode == DRAWIMG_COLOR)
	{
		// source image dimension
		u32 ww = ws;
		u32 hh = hs;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
					*d = pal[src[x2 + y2*ws]];
				else
					*d = color;
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// transparency
	else if (mode == DRAWIMG_TRANSP)
	{
		u32 ww = ws;
		u32 hh = hs;
		u16 c;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
				{
					c = pal[src[x2 + y2*ws]];
					if (c != color) *d = c;
				}
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// perspective
	else if (mode == DRAWIMG_PERSP)
	{
		// coordinate mask
		int xmask = ws - 1;
		int ymask = hs - 1;

		for (; h > 0; h--)
		{
			int dist = FRACTMUL*h0/(h0 + y0 + color + 1);
			int m11b = (m11*dist)>>FRACT;
			int m21b = (m21*dist)>>FRACT;
			int m12b = (m12*dist)>>FRACT;
			int m22b = (m22*dist)>>FRACT;

			xy0m = x0*m11b + y0*m12b + m13;
			yy0m = x0*m21b + y0*m22b + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = (xy0m>>FRACT) & xmask;
				xy0m += m11b; // x0*m11

				y2 = (yy0m>>FRACT) & ymask;
				yy0m += m21b; // x0*m21

				*d++ = pal[src[x2 + y2*ws]];
			}
			y0++;
			d += wbd;
		}
	}
}

// draw 4-bit image with 2D transformation matrix
void DrawImg4PalMat(const u8* src, const u16* pal, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u16 color)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (mode == DRAWIMG_PERSP) ? (-h) : (-h/2); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// load transformation matrix and convert to integer fractional number
	int m11 = (int)(m->m11*FRACTMUL+0.5f);
	int m12 = (int)(m->m12*FRACTMUL+0.5f);
	int m13 = (int)(m->m13*FRACTMUL+0.5f);
	int m21 = (int)(m->m21*FRACTMUL+0.5f);
	int m22 = (int)(m->m22*FRACTMUL+0.5f);
	int m23 = (int)(m->m23*FRACTMUL+0.5f);

	// zero size image
	if ((m11 == 0) || (m22 == 0)) return;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width words
	int i, x2, y2;

	// wrap image
	if (mode == DRAWIMG_WRAP)
	{
		// coordinate mask
		int xmask = ws - 1;
		int ymask = hs - 1;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = (xy0m>>FRACT) & xmask;
				y2 = (yy0m>>FRACT) & ymask;

				u8 b = src[x2/2 + y2*(ws/2)];
				if ((x2 & 1) == 0) b >>= 4; else b &= 0x0f;
				*d++ = pal[b];

				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}

			y0++;
			d += wbd;
		}
	}

	// no border
	else if (mode == DRAWIMG_NOBORDER)
	{
		// source image dimension
		u32 ww = ws;
		u32 hh = hs;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;

			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
				{
					u8 b = src[x2/2 + y2*(ws/2)];
					if ((x2 & 1) == 0) b >>= 4; else b &= 0x0f;
					*d = pal[b];
				}
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// clamp image
	else if (mode == DRAWIMG_CLAMP)
	{
		// source image dimension
		u32 ww = ws - 1;
		u32 hh = hs - 1;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (x2 < 0) x2 = 0;
				if (x2 > ww) x2 = ww;
				if (y2 < 0) y2 = 0;
				if (y2 > hh) y2 = hh;

				u8 b = src[x2/2 + y2*(ws/2)];
				if ((x2 & 1) == 0) b >>= 4; else b &= 0x0f;
				*d++ = pal[b];

				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// color border
	else if (mode == DRAWIMG_COLOR)
	{
		// source image dimension
		u32 ww = ws;
		u32 hh = hs;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
				{
					u8 b = src[x2/2 + y2*(ws/2)];
					if ((x2 & 1) == 0) b >>= 4; else b &= 0x0f;
					*d = pal[b];
				}
				else
					*d = color;
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// transparency
	else if (mode == DRAWIMG_TRANSP)
	{
		u32 ww = ws;
		u32 hh = hs;
		u16 c;

		for (; h > 0; h--)
		{
			xy0m = x0*m11 + y0*m12 + m13;
			yy0m = x0*m21 + y0*m22 + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = xy0m>>FRACT;
				y2 = yy0m>>FRACT;
				if (((u32)x2 < ww) && ((u32)y2 < hh))
				{
					u8 b = src[x2/2 + y2*(ws/2)];
					if ((x2 & 1) == 0) b >>= 4; else b &= 0x0f;
					c = pal[b];
					if (c != color) *d = c;
				}
				d++;
				xy0m += m11; // x0*m11
				yy0m += m21; // x0*m21
			}
			y0++;
			d += wbd;
		}
	}

	// perspective
	else if (mode == DRAWIMG_PERSP)
	{
		// coordinate mask
		int xmask = ws - 1;
		int ymask = hs - 1;

		for (; h > 0; h--)
		{
			int dist = FRACTMUL*h0/(h0 + y0 + color + 1);
			int m11b = (m11*dist)>>FRACT;
			int m21b = (m21*dist)>>FRACT;
			int m12b = (m12*dist)>>FRACT;
			int m22b = (m22*dist)>>FRACT;

			xy0m = x0*m11b + y0*m12b + m13;
			yy0m = x0*m21b + y0*m22b + m23;
		
			for (i = w; i > 0; i--)
			{
				x2 = (xy0m>>FRACT) & xmask;
				xy0m += m11b; // x0*m11

				y2 = (yy0m>>FRACT) & ymask;
				yy0m += m21b; // x0*m21

				u8 b = src[x2/2 + y2*(ws/2)];
				if ((x2 & 1) == 0) b >>= 4; else b &= 0x0f;
				*d++ = pal[b];
			}
			y0++;
			d += wbd;
		}
	}
}

// draw tile map using perspective projection
//  src ... source image with column of 16-bit square tiles (width = tile size, must be power of 2)
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
void DrawTileMap(const u16* src, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (horizon == 0) ? (-h/2) : (-h); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// load transformation matrix and convert to integer fractional number
	int m11 = (int)(mat->m11*FRACTMUL+0.5f);
	int m12 = (int)(mat->m12*FRACTMUL+0.5f);
	int m13 = (int)(mat->m13*FRACTMUL+0.5f);
	int m21 = (int)(mat->m21*FRACTMUL+0.5f);
	int m22 = (int)(mat->m22*FRACTMUL+0.5f);
	int m23 = (int)(mat->m23*FRACTMUL+0.5f);
	int m11b = m11;
	int m21b = m21;
	int m12b = m12;
	int m22b = m22;

	// zero size image
	if ((m11 == 0) || (m22 == 0)) return;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width in pixels
	int i, x2, y2;

	int tilesize = 1 << tilebits; // tile size in pixels
	int tilemask = tilesize - 1; // tile mask in pixels
	int tileinx; // tile index
	int mapw = 1<<mapwbits; // map width in tiles
	int maph = 1<<maphbits; // map height in tiles
	int mapmaskx = (mapw * tilesize) - 1; // mask of map width in pixels
	int mapmasky = (maph * tilesize) - 1; // mask of map height in pixels

	for (; h > 0; h--)
	{
	
		if (horizon != 0)
		{
			int dist = FRACTMUL*h0/(h0 + y0 + horizon);
			m11b = (m11*dist)>>FRACT;
			m12b = (m12*dist)>>FRACT;
			m21b = (m21*dist)>>FRACT;
			m22b = (m22*dist)>>FRACT;
		}

		xy0m = x0*m11b + y0*m12b + m13;
		yy0m = x0*m21b + y0*m22b + m23;

		for (i = w; i > 0; i--)
		{
			// pixel X coordinate on the map
			x2 = (xy0m>>FRACT) & mapmaskx;
			xy0m += m11b;

			// pixel Y coordinate on the map
			y2 = (yy0m>>FRACT) & mapmasky;
			yy0m += m21b;

			// tile index
			tileinx = map[(x2 >> tilebits) + (y2 >> tilebits)*mapw];

			// tile pixel
			*d++ = src[(tileinx<<(2*tilebits)) + (x2 & tilemask) + ((y2 & tilemask)<<tilebits)];
		}
		y0++;
		d += wbd;
	}
}

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
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (horizon == 0) ? (-h/2) : (-h); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// load transformation matrix and convert to integer fractional number
	int m11 = (int)(mat->m11*FRACTMUL+0.5f);
	int m12 = (int)(mat->m12*FRACTMUL+0.5f);
	int m13 = (int)(mat->m13*FRACTMUL+0.5f);
	int m21 = (int)(mat->m21*FRACTMUL+0.5f);
	int m22 = (int)(mat->m22*FRACTMUL+0.5f);
	int m23 = (int)(mat->m23*FRACTMUL+0.5f);
	int m11b = m11;
	int m21b = m21;
	int m12b = m12;
	int m22b = m22;

	// zero size image
	if ((m11 == 0) || (m22 == 0)) return;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width in pixels
	int i, x2, y2;

	int tilesize = 1 << tilebits; // tile size in pixels
	int tilemask = tilesize - 1; // tile mask in pixels
	int tileinx; // tile index
	int mapw = 1<<mapwbits; // map width in tiles
	int maph = 1<<maphbits; // map height in tiles
	int mapmaskx = (mapw * tilesize) - 1; // mask of map width in pixels
	int mapmasky = (maph * tilesize) - 1; // mask of map height in pixels

	for (; h > 0; h--)
	{
	
		if (horizon != 0)
		{
			int dist = FRACTMUL*h0/(h0 + y0 + horizon);
			m11b = (m11*dist)>>FRACT;
			m12b = (m12*dist)>>FRACT;
			m21b = (m21*dist)>>FRACT;
			m22b = (m22*dist)>>FRACT;
		}

		xy0m = x0*m11b + y0*m12b + m13;
		yy0m = x0*m21b + y0*m22b + m23;

		for (i = w; i > 0; i--)
		{
			// pixel X coordinate on the map
			x2 = (xy0m>>FRACT) & mapmaskx;
			xy0m += m11b;

			// pixel Y coordinate on the map
			y2 = (yy0m>>FRACT) & mapmasky;
			yy0m += m21b;

			// tile index
			tileinx = map[(x2 >> tilebits) + (y2 >> tilebits)*mapw];

			// tile pixel
			*d++ = pal[src[(tileinx<<(2*tilebits)) + (x2 & tilemask) + ((y2 & tilemask)<<tilebits)]];
		}
		y0++;
		d += wbd;
	}
}

// draw tile map using perspective projection with 4-bit paletted image
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
void DrawTile4PalMap(const u8* src, const u16* pal, const u8* map, int mapwbits, int maphbits,
	int tilebits, int x, int y, int w, int h, const sMat2D* mat, u8 horizon)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > DispWidth) w = DispWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (horizon == 0) ? (-h/2) : (-h); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > DispHeight) h = DispHeight - y;
	if (h <= 0) return;

	// update dirty rectangle
	DispDirtyRect(x, y, w, h);

	// load transformation matrix and convert to integer fractional number
	int m11 = (int)(mat->m11*FRACTMUL+0.5f);
	int m12 = (int)(mat->m12*FRACTMUL+0.5f);
	int m13 = (int)(mat->m13*FRACTMUL+0.5f);
	int m21 = (int)(mat->m21*FRACTMUL+0.5f);
	int m22 = (int)(mat->m22*FRACTMUL+0.5f);
	int m23 = (int)(mat->m23*FRACTMUL+0.5f);
	int m11b = m11;
	int m21b = m21;
	int m12b = m12;
	int m22b = m22;

	// zero size image
	if ((m11 == 0) || (m22 == 0)) return;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width in pixels
	int i, x2, y2;

	int tilesize = 1 << tilebits; // tile size in pixels
	int tilemask = tilesize - 1; // tile mask in pixels
	int tileinx; // tile index
	int mapw = 1<<mapwbits; // map width in tiles
	int maph = 1<<maphbits; // map height in tiles
	int mapmaskx = (mapw * tilesize) - 1; // mask of map width in pixels
	int mapmasky = (maph * tilesize) - 1; // mask of map height in pixels

	for (; h > 0; h--)
	{
	
		if (horizon != 0)
		{
			int dist = FRACTMUL*h0/(h0 + y0 + horizon);
			m11b = (m11*dist)>>FRACT;
			m12b = (m12*dist)>>FRACT;
			m21b = (m21*dist)>>FRACT;
			m22b = (m22*dist)>>FRACT;
		}

		xy0m = x0*m11b + y0*m12b + m13;
		yy0m = x0*m21b + y0*m22b + m23;

		for (i = w; i > 0; i--)
		{
			// pixel X coordinate on the map
			x2 = (xy0m>>FRACT) & mapmaskx;
			xy0m += m11b;

			// pixel Y coordinate on the map
			y2 = (yy0m>>FRACT) & mapmasky;
			yy0m += m21b;

			// tile index
			tileinx = map[(x2 >> tilebits) + (y2 >> tilebits)*mapw];

			// tile pixel
			int tilebase = tileinx << (tilebits + tilebits - 1); // offset of the tile
			int tilex = x2 & tilemask; // X coordinate of the pixel
			int tiley = (y2 & tilemask) << (tilebits-1); // offset of the line
			u8 bb = src[tilebase + tilex/2 + tiley]; // byte with 2 pixels
			if ((x2 & 1) == 0) bb >>= 4; else bb &= 0x0f;
			*d++ = pal[bb];
		}
		y0++;
		d += wbd;
	}
}

#endif // USE_MAT2D

// draw image line interpolated
//  src = source image
//  xd,yd = destination coordinates
//  wd = destination width
//  ws = source width
//  wbs = source line pitch in bytes
void DrawImgLine(const u16* src, int xd, int yd, int wd, int ws, int wbs)
{
	// some base checks
	if ((wd <= 0) || (ws <= 0) || (yd < 0) || (yd >= DispHeight)) return;

	// pixel increment
	int dinc = FRACTMUL*ws/wd;

	// update dirty rectangle
	DispDirtyRect(xd, yd, wd, 1);

	// prepare buffers
	u16* d = &FrameBuf[xd + yd*DispWidth]; // destination address
	int i, j;

	int dadd = 0;
	for (i = 0; i < wd; i++)
	{
		*d++ = *src;
		dadd += dinc;
		src += dadd >> FRACT;
		dadd &= (FRACTMUL-1);
	}
}

// draw paletted image line interpolated
void DrawImgPalLine(const u8* src, const u16* pal, int xd, int yd, int wd, int ws, int wbs)
{
	// some base checks
	if ((wd <= 0) || (ws <= 0) || (yd < 0) || (yd >= DispHeight)) return;

	// pixel increment
	int dinc = FRACTMUL*ws/wd;

	// update dirty rectangle
	DispDirtyRect(xd, yd, wd, 1);

	// prepare buffers
	u16* d = &FrameBuf[xd + yd*DispWidth]; // destination address
	int i, j;

	int dadd = 0;
	for (i = 0; i < wd; i++)
	{
		*d++ = pal[*src];
		dadd += dinc;
		src += dadd >> FRACT;
		dadd &= (FRACTMUL-1);
	}
}

// draw 4-bit paletted image line interpolated
void DrawImg4PalLine(const u8* src, const u16* pal, int xd, int yd, int wd, int ws, int wbs)
{
	// some base checks
	if ((wd <= 0) || (ws <= 0) || (yd < 0) || (yd >= DispHeight)) return;

	// pixel increment
	int dinc = FRACTMUL*ws/wd;

	// update dirty rectangle
	DispDirtyRect(xd, yd, wd, 1);

	// prepare buffers
	u16* d = &FrameBuf[xd + yd*DispWidth]; // destination address
	int i, j, x;

	int dadd = 0;
	x = 0;
	for (i = 0; i < wd; i++)
	{
		if ((x & 1) == 0)
			*d++ = pal[src[x>>1] >> 4];
		else
			*d++ = pal[src[x>>1] & 0x0f];
		dadd += dinc;
		x += dadd >> FRACT;
		dadd &= (FRACTMUL-1);
	}
}

// rainbow gradient table (r, g, b)
const u8 RainbowGrad[] = {
	220, 0, 0,		// dark red
	255, 0, 0,		// red
	255, 127, 0, 		// orange
	255, 220, 0,		// yellow
	255, 255, 0,		// yellow
	220, 255, 0,		// yellow
	127, 255, 0, 		// yellow-green
	0, 255, 0, 		// green
	0, 255, 127, 		// green-cyan
	0, 255, 220, 		// cyan
	0, 255, 255, 		// cyan
	0, 220, 255, 		// cyan
	0, 127, 255, 		// cyan-blue
	0, 0, 255, 		// blue
	127, 0, 255,		// blue-magenta
	220, 0, 255,		// magenta
	255, 0, 255,		// magenta
	220, 0, 220,		// dark magenta
};

#define RAINBOW_NUM (count_of(RainbowGrad)/3)

// generate gradient
void GenGrad(u16* dst, int w)
{
	int i;
	const u8 *s1, *s2;
	int k1, k2;
	int dif;
	for (i = 0; i < w; i++)
	{
		dif = 256*(RAINBOW_NUM-1)*i/w;
		k1 = dif>>8;
		dif -= k1*256;
		if (k1 >= RAINBOW_NUM-1) k1 = RAINBOW_NUM-2;
		k1 *= 3;
		k2 = k1 + 3;
		if (k2 >= count_of(RainbowGrad)) k2 = count_of(RainbowGrad)-3;
		s1 = &RainbowGrad[k1];
		s2 = &RainbowGrad[k2];
		int red = (s2[0]*dif + s1[0]*(255-dif))>>8;
		if (red > 255) red = 255;
		int green = (s2[1]*dif + s1[1]*(255-dif))>>8;
		if (green > 255) green = 255;
		int blue = (s2[2]*dif + s1[2]*(255-dif))>>8;
		if (blue > 255) blue = 255;
		*dst++ = RGBTO16(red, green, blue);
	}
}

/*
// generate gradient by HSL (much slower than previous method)
void GenGrad(u16* dst, int w)
{
	int i;
	sColor col;
	for (i = 0; i < w; i++)
	{
		col.r = (float)i/w; // hue 0..1
		col.g = 1; // sat
		col.b = 0.5; // LUM
		ColorHSLToRGB(&col);
		*dst++ = ColorRGB16(&col);
	}
}

*/

// blend 16-bit colors (level is 0=col1 to 16=col2)
u16 BlendCol16(u16 col1, u16 col2, u8 level)
{
#define VAL6(a) (((a) >> 4) & ~(B1|B2|B3|B4 |B7|B8|B9|B10 |B12|B13|B14|B15))
#define VAL12(a) (((a) >> 3) & ~(B2|B3|B4 |B8|B9|B10 |B13|B14|B15))
#define VAL25(a) (((a) >> 2) & ~(B3|B4 |B9|B10 |B14|B15))
#define VAL50(a) (((a) >> 1) & ~(B4 |B10 |B15))

	switch (level)
	{
	// 0%
	case 0: return col1;

	// 6%
	case 1: return VAL50(col1)+VAL25(col1)+VAL12(col1)+VAL6(col1) + VAL6(col2);

	// 12%
	case 2: return VAL50(col1)+VAL25(col1)+VAL12(col1) + VAL12(col2);

	// 18%
	case 3: return VAL50(col1)+VAL25(col1)+VAL6(col1) + VAL12(col2)+VAL6(col2);

	// 25%
	case 4: return VAL50(col1)+VAL25(col1) + VAL25(col2);

	// 31%
	case 5: return VAL50(col1)+VAL12(col1)+VAL6(col1) + VAL25(col2)+VAL6(col2);

	// 37%
	case 6: return VAL50(col1)+VAL12(col1) + VAL25(col2)+VAL12(col2);

	// 44%
	case 7: return VAL50(col1)+VAL6(col1) + VAL25(col2)+VAL12(col2)+VAL6(col2);

	// 50%
	case 8: return VAL50(col1) + VAL50(col2);

	// 56%
	case 9: return VAL25(col1)+VAL12(col1)+VAL6(col1) + VAL50(col2)+VAL6(col2);

	// 62%
	case 10: return VAL25(col1)+VAL12(col1) + VAL50(col2)+VAL12(col2);

	// 69%
	case 11: return VAL25(col1)+VAL6(col1) + VAL50(col2)+VAL12(col2)+VAL6(col2);

	// 75%
	case 12: return VAL25(col1) + VAL50(col2)+VAL25(col2);

	// 81%
	case 13: return VAL12(col1)+VAL6(col1) + VAL50(col2)+VAL25(col2)+VAL6(col2);

	// 87%
	case 14: return VAL12(col1) + VAL50(col2)+VAL25(col2)+VAL12(col2);

	// 94%
	case 15: return VAL6(col1) + VAL50(col2)+VAL25(col2)+VAL12(col2)+VAL6(col2);

	// 100%
	default: return col2;
	}
}

#endif // USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)
