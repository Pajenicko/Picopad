
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

#include "picopad.h"

#if USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)

const u8* pDrawFont = FONT; // font 8x16
int DrawFontHeight = FONTH; // font height
int DrawFontWidth = FONTW; // font width (5 to 8)
u8 DrawPrintPosNum = TEXTWIDTH; // number of text positions per row (= WIDTH/DrawFontWidth)
u8 DrawPrintRowNum = TEXTHEIGHT; // number of text rows (= HEIGHT/DrawFontHeight)
u8 DrawPrintPos = 0;  // console print character position
u8 DrawPrintRow = 0;  // console print character row
u8 DrawPrintInv = 0; // offset added to character (128 = print inverted characters, 0 = normal character)
u8 DrawPrintSize = 0; // font size: 0=normal, 1=double-height, 2=double-width, 3=double-size
u16 DrawPrintCol = COL_PRINT_DEF; // console print color

// update size of text screen after changing font size
void SelFontUpdate()
{
	DrawPrintPosNum = WIDTH/DrawFontWidth;
	DrawPrintRowNum = HEIGHT/DrawFontHeight;
}

// select font 8x8
void SelFont8x8()
{
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;
	DrawFontWidth = 8;
	SelFontUpdate(); // update size of text screen
}

// select font 8x14
void SelFont8x14()
{
	pDrawFont = FontBold8x14;
	DrawFontHeight = 14;
	DrawFontWidth = 8;
	SelFontUpdate(); // update size of text screen
}

// select font 8x16
void SelFont8x16()
{
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;
	SelFontUpdate(); // update size of text screen
}

// select font 6x8
void SelFont6x8()
{
	pDrawFont = FontCond6x8;
	DrawFontHeight = 8;
	DrawFontWidth = 6;
	SelFontUpdate(); // update size of text screen
}

// select font 5x8
void SelFont5x8()
{
	pDrawFont = FontTiny5x8;
	DrawFontHeight = 8;
	DrawFontWidth = 5;
	SelFontUpdate(); // update size of text screen
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
void DrawClearCol(u16 col)
{
	int i;
	for (i = 0; i < FRAMESIZE; i++) FrameBuf[i] = col;
	DispDirtyAll();
}

// clear canvas with black color
void DrawClear()
{
	DrawClearCol(COL_BLACK);
}

// Draw point
void DrawPoint(int x, int y, u16 col)
{
	// check coordinates
	if (((u32)x >= (u32)DispWidth) || ((u32)y >= (u32)DispHeight)) return;

	// draw pixel
	FrameBuf[x + y*DispWidth] = col;

	// update dirty area by rectangle (must be in valid limits)
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

// Draw character (transparent background)
void DrawChar(char ch, int x, int y, u16 col)
{
	int x0 = x;
	int i, j;
	u16* d;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + DrawFontWidth <= DispWidth) && (y + DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, DrawFontWidth, DrawFontHeight);

		// destination address
		d = &FrameBuf[y*DispWidth + x];

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
				if ((ch & 0x80) != 0) *d = col;
				d++;
				ch <<= 1;
			}
			d += DispWidth - DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
	}
}

// Draw character double height (transparent background)
void DrawCharH(char ch, int x, int y, u16 col)
{
	int x0 = x;
	int i, j;
	u16* d;
	int w = DispWidth;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + DrawFontWidth <= w) && (y + 2*DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, DrawFontWidth, 2*DrawFontHeight);

		// destination address
		d = &FrameBuf[y*w + x];

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
				if ((ch & 0x80) != 0)
				{
					*d = col;
					d[w] = col;
				}
				d++;
				ch <<= 1;
			}
			d += 2*w - DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
					DrawPoint(x, y+1, col);
				}
				x++;
				ch <<= 1;
			}
			y += 2;
		}
	}
}

// Draw character double width (transparent background)
void DrawCharW(char ch, int x, int y, u16 col)
{
	int x0 = x;
	int i, j;
	u16* d;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + 2*DrawFontWidth <= DispWidth) && (y + DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, 2*DrawFontWidth, DrawFontHeight);

		// destination address
		d = &FrameBuf[y*DispWidth + x];

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
				if ((ch & 0x80) != 0)
				{
					*d = col;
					d[1] = col;
				}
				d += 2;
				ch <<= 1;
			}
			d += DispWidth - 2*DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
				}
				x += 2;
				ch <<= 1;
			}
			y++;
		}
	}
}

// Draw character double sized (transparent background)
void DrawChar2(char ch, int x, int y, u16 col)
{
	int x0 = x;
	int i, j;
	u16* d;
	int w = DispWidth;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + 2*DrawFontWidth <= w) && (y + 2*DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, 2*DrawFontWidth, 2*DrawFontHeight);

		// destination address
		d = &FrameBuf[y*w + x];

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
				if ((ch & 0x80) != 0)
				{
					*d = col;
					d[1] = col;
					d[w] = col;
					d[w+1] = col;
				}
				d += 2;
				ch <<= 1;
			}
			d += 2*w - 2*DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
	}
}

// Draw character with background
void DrawCharBg(char ch, int x, int y, u16 col, u16 bgcol)
{
	int x0 = x;
	int i, j;
	u16 c;
	u16* d;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + DrawFontWidth <= DispWidth) && (y + DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, DrawFontWidth, DrawFontHeight);

		// destination address
		d = &FrameBuf[y*DispWidth + x];

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
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
	}
}

// Draw character double height with background
void DrawCharBgH(char ch, int x, int y, u16 col, u16 bgcol)
{
	int x0 = x;
	int i, j;
	u16 c;
	u16* d;
	int w = DispWidth;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + DrawFontWidth <= w) && (y + 2*DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, DrawFontWidth, 2*DrawFontHeight);

		// destination address
		d = &FrameBuf[y*w + x];

		// loop through lines of one character
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				c = ((ch & 0x80) != 0) ? col : bgcol;

				// draw pixel
				*d = c;
				d[w] = c;

				d++;
				ch <<= 1;
			}
			d += 2*w - DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
				DrawPoint(x, y+1, c);

				x++;
				ch <<= 1;
			}
			y += 2;
		}
	}
}

// Draw character double width with background
void DrawCharBgW(char ch, int x, int y, u16 col, u16 bgcol)
{
	int x0 = x;
	int i, j;
	u16 c;
	u16* d;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + 2*DrawFontWidth <= DispWidth) && (y + DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, 2*DrawFontWidth, DrawFontHeight);

		// destination address
		d = &FrameBuf[y*DispWidth + x];

		// loop through lines of one character
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				c = ((ch & 0x80) != 0) ? col : bgcol;

				// draw pixel
				*d++ = c;
				*d++ = c;
				ch <<= 1;
			}
			d += DispWidth - 2*DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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

				x += 2;
				ch <<= 1;
			}
			y++;
		}
	}
}

// Draw character double sized with background
void DrawCharBg2(char ch, int x, int y, u16 col, u16 bgcol)
{
	int x0 = x;
	int i, j;
	u16 c;
	u16* d;
	int w = DispWidth;

	// prepare pointer to font sample
	const u8* s = &pDrawFont[ch];

	// check if drawing is safe to use fast drawing
	if ((x >= 0) && (y >= 0) && (x + 2*DrawFontWidth <= w) && (y + 2*DrawFontHeight <= DispHeight))
	{
		// update dirty rectangle
		DispDirtyRect(x, y, 2*DrawFontWidth, 2*DrawFontHeight);

		// destination address
		d = &FrameBuf[y*w + x];

		// loop through lines of one character
		for (i = DrawFontHeight; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			for (j = DrawFontWidth; j > 0; j--)
			{
				// pixel is set
				c = ((ch & 0x80) != 0) ? col : bgcol;

				// draw pixel
				*d = c;
				d[1] = c;
				d[w] = c;
				d[w+1] = c;

				d += 2;
				ch <<= 1;
			}
			d += 2*w - 2*DrawFontWidth;
		}
	}

	// use slow safe drawing
	else
	{
		// loop through lines of one character
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
	}
}

// Draw text (transparent background)
void DrawText(const char* text, int x, int y, u16 col)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawChar(ch, x, y, col);

		// shift to next character position
		x += DrawFontWidth;
	}
}

// Draw text double width (transparent background)
void DrawTextW(const char* text, int x, int y, u16 col)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawCharW(ch, x, y, col);

		// shift to next character position
		x += DrawFontWidth*2;
	}
}

// Draw text double height (transparent background)
void DrawTextH(const char* text, int x, int y, u16 col)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawCharH(ch, x, y, col);

		// shift to next character position
		x += DrawFontWidth;
	}
}

// Draw text double sized (transparent background)
void DrawText2(const char* text, int x, int y, u16 col)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawChar2(ch, x, y, col);

		// shift to next character position
		x += DrawFontWidth*2;
	}
}

// Draw text with background
void DrawTextBg(const char* text, int x, int y, u16 col, u16 bgcol)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawCharBg(ch, x, y, col, bgcol);

		// shift to next character position
		x += DrawFontWidth;
	}
}

// Draw text double width with background
void DrawTextBgW(const char* text, int x, int y, u16 col, u16 bgcol)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawCharBgW(ch, x, y, col, bgcol);

		// shift to next character position
		x += DrawFontWidth*2;
	}
}

// Draw text double height with background
void DrawTextBgH(const char* text, int x, int y, u16 col, u16 bgcol)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawCharBgH(ch, x, y, col, bgcol);

		// shift to next character position
		x += DrawFontWidth;
	}
}

// Draw text double sized with background
void DrawTextBg2(const char* text, int x, int y, u16 col, u16 bgcol)
{
	u8 ch;

	// loop through characters of text
	for (;;)
	{
		// get next character of the text
		ch = (u8)*text++;
		if (ch == 0) break;

		// draw character
		DrawCharBg2(ch, x, y, col, bgcol);

		// shift to next character position
		x += DrawFontWidth*2;
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
//  m ... transformation matrix (should be prepared using PrepDrawImg function)
//  mode ... draw mode DRAWIMG_*
//  color ... key or border color (DRAWIMG_PERSP mode: horizon offset)
// Note to wrap and perspective mode: Width and height of source image should be power of 2, or it will render slower.
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
	int m11 = TOFRACT(m->m11);
	int m12 = TOFRACT(m->m12);
	int m13 = TOFRACT(m->m13);
	int m21 = TOFRACT(m->m21);
	int m22 = TOFRACT(m->m22);
	int m23 = TOFRACT(m->m23);

	// check invalid zero matrix
	Bool zero = (m11 | m12 | m13 | m21 | m22 | m23) == 0;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width words
	int i, x2, y2;

	// 0: wrap image
	if (mode == DRAWIMG_WRAP)
	{
		// image dimension is power of 2
		if (IsPow2(ws) && IsPow2(hs))
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

		// image dimension is not power of 2
		else
		{
			for (; h > 0; h--)
			{
				xy0m = x0*m11 + y0*m12 + m13;
				yy0m = x0*m21 + y0*m22 + m23;

				for (i = w; i > 0; i--)
				{
					x2 = (xy0m>>FRACT) % ws;
					if (x2 < 0) x2 += ws;
					y2 = (yy0m>>FRACT) % hs;
					if (y2 < 0) y2 += hs;
					*d++ = src[x2 + y2*ws];
					xy0m += m11; // x0*m11
					yy0m += m21; // x0*m21
				}

				y0++;
				d += wbd;
			}
		}
	}

	// 1: no border
	else if (mode == DRAWIMG_NOBORDER)
	{
		// if matrix is valid
		if (!zero)
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
	}

	// 2: clamp image
	else if (mode == DRAWIMG_CLAMP)
	{
		// invalid matrix
		if (zero)
		{
			u16 col = *src;
			for (; h > 0; h--)
			{
				for (i = w; i > 0; i--)
				{
					*d++ = col;
				}
				d += wbd;
			}
		}
		else
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
	}

	// 3: color border
	else if (mode == DRAWIMG_COLOR)
	{
		// invalid matrix
		if (zero)
		{
			for (; h > 0; h--)
			{
				for (i = w; i > 0; i--)
				{
					*d++ = color;
				}
				d += wbd;
			}
		}
		else
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
	}

	// 4: transparency
	else if (mode == DRAWIMG_TRANSP)
	{
		// if matrix is valid
		if (!zero)
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
	}

	// 5: perspective
	else if (mode == DRAWIMG_PERSP)
	{
		// image dimension is power of 2
		if (IsPow2(ws) && IsPow2(hs))
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

		// image dimension is not power of 2
		else
		{
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
					x2 = (xy0m>>FRACT) % ws;
					if (x2 < 0) x2 += ws;
					xy0m += m11b; // x0*m11

					y2 = (yy0m>>FRACT) % hs;
					if (y2 < 0) y2 += hs;
					yy0m += m21b; // x0*m21

					*d++ = src[x2 + y2*ws];
				}
				y0++;
				d += wbd;
			}
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
	int m11 = TOFRACT(m->m11);
	int m12 = TOFRACT(m->m12);
	int m13 = TOFRACT(m->m13);
	int m21 = TOFRACT(m->m21);
	int m22 = TOFRACT(m->m22);
	int m23 = TOFRACT(m->m23);

	// check invalid zero matrix
	Bool zero = (m11 | m12 | m13 | m21 | m22 | m23) == 0;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width words
	int i, x2, y2;

	// wrap image
	if (mode == DRAWIMG_WRAP)
	{
		// image dimension is power of 2
		if (IsPow2(ws) && IsPow2(hs))
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

		// image dimension is not power of 2
		else
		{
			for (; h > 0; h--)
			{
				xy0m = x0*m11 + y0*m12 + m13;
				yy0m = x0*m21 + y0*m22 + m23;

				for (i = w; i > 0; i--)
				{
					x2 = (xy0m>>FRACT) % ws;
					if (x2 < 0) x2 += ws;
					y2 = (yy0m>>FRACT) % hs;
					if (y2 < 0) y2 += hs;
					*d++ = pal[src[x2 + y2*ws]];
					xy0m += m11; // x0*m11
					yy0m += m21; // x0*m21
				}

				y0++;
				d += wbd;
			}
		}
	}

	// no border
	else if (mode == DRAWIMG_NOBORDER)
	{
		// if matrix is valid
		if (!zero)
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
	}

	// clamp image
	else if (mode == DRAWIMG_CLAMP)
	{
		// invalid matrix
		if (zero)
		{
			u16 col = pal[*src];
			for (; h > 0; h--)
			{
				for (i = w; i > 0; i--)
				{
					*d++ = col;
				}
				d += wbd;
			}
		}
		else
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
	}

	// color border
	else if (mode == DRAWIMG_COLOR)
	{
		// invalid matrix
		if (zero)
		{
			for (; h > 0; h--)
			{
				for (i = w; i > 0; i--)
				{
					*d++ = color;
				}
				d += wbd;
			}
		}
		else
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
	}

	// transparency
	else if (mode == DRAWIMG_TRANSP)
	{
		// if matrix is valid
		if (!zero)
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
	}

	// perspective
	else if (mode == DRAWIMG_PERSP)
	{
		// image dimension is power of 2
		if (IsPow2(ws) && IsPow2(hs))
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


		// image dimension is not power of 2
		else
		{
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
					x2 = (xy0m>>FRACT) % ws;
					if (x2 < 0) x2 += ws;
					xy0m += m11b; // x0*m11

					y2 = (yy0m>>FRACT) % hs;
					if (y2 < 0) y2 += hs;
					yy0m += m21b; // x0*m21

					*d++ = pal[src[x2 + y2*ws]];
				}
				y0++;
				d += wbd;
			}
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
	int m11 = TOFRACT(m->m11);
	int m12 = TOFRACT(m->m12);
	int m13 = TOFRACT(m->m13);
	int m21 = TOFRACT(m->m21);
	int m22 = TOFRACT(m->m22);
	int m23 = TOFRACT(m->m23);

	// check invalid zero matrix
	Bool zero = (m11 | m12 | m13 | m21 | m22 | m23) == 0;

	// prepare variables
	int xy0m, yy0m; // temporary Y members
	u16* d = &FrameBuf[DispWidth*y + x]; // destination image
	int wbd = DispWidth - w; // destination width words
	int i, x2, y2;

	// wrap image
	if (mode == DRAWIMG_WRAP)
	{
		// image dimension is power of 2
		if (IsPow2(ws) && IsPow2(hs))
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

		// image dimension is not power of 2
		else
		{
			for (; h > 0; h--)
			{
				xy0m = x0*m11 + y0*m12 + m13;
				yy0m = x0*m21 + y0*m22 + m23;

				for (i = w; i > 0; i--)
				{
					x2 = (xy0m>>FRACT) % ws;
					if (x2 < 0) x2 += ws;
					y2 = (yy0m>>FRACT) % hs;
					if (y2 < 0) y2 += hs;

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
	}

	// no border
	else if (mode == DRAWIMG_NOBORDER)
	{
		// if matrix is valid
		if (!zero)
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
	}

	// clamp image
	else if (mode == DRAWIMG_CLAMP)
	{
		// invalid matrix
		if (zero)
		{
			u16 col = pal[*src >> 4];
			for (; h > 0; h--)
			{
				for (i = w; i > 0; i--)
				{
					*d++ = col;
				}
				d += wbd;
			}
		}
		else
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
	}

	// color border
	else if (mode == DRAWIMG_COLOR)
	{
		// invalid matrix
		if (zero)
		{
			for (; h > 0; h--)
			{
				for (i = w; i > 0; i--)
				{
					*d++ = color;
				}
				d += wbd;
			}
		}
		else
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
	}

	// transparency
	else if (mode == DRAWIMG_TRANSP)
	{
		// if matrix is valid
		if (!zero)
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
	}

	// perspective
	else if (mode == DRAWIMG_PERSP)
	{
		// image dimension is power of 2
		if (IsPow2(ws) && IsPow2(hs))
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

		// image dimension is not power of 2
		else
		{
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
					x2 = (xy0m>>FRACT) % ws;
					if (x2 < 0) x2 += ws;
					xy0m += m11b; // x0*m11

					y2 = (yy0m>>FRACT) % hs;
					if (y2 < 0) y2 += hs;
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
//  mat ... transformation matrix (should be prepared using PrepDrawImg function)
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
	int m11 = TOFRACT(mat->m11);
	int m12 = TOFRACT(mat->m12);
	int m13 = TOFRACT(mat->m13);
	int m21 = TOFRACT(mat->m21);
	int m22 = TOFRACT(mat->m22);
	int m23 = TOFRACT(mat->m23);
	int m11b = m11;
	int m21b = m21;
	int m12b = m12;
	int m22b = m22;

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
	int m11 = TOFRACT(mat->m11);
	int m12 = TOFRACT(mat->m12);
	int m13 = TOFRACT(mat->m13);
	int m21 = TOFRACT(mat->m21);
	int m22 = TOFRACT(mat->m22);
	int m23 = TOFRACT(mat->m23);
	int m11b = m11;
	int m21b = m21;
	int m12b = m12;
	int m22b = m22;

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
	int m11 = TOFRACT(mat->m11);
	int m12 = TOFRACT(mat->m12);
	int m13 = TOFRACT(mat->m13);
	int m21 = TOFRACT(mat->m21);
	int m22 = TOFRACT(mat->m22);
	int m23 = TOFRACT(mat->m23);
	int m11b = m11;
	int m21b = m21;
	int m12b = m12;
	int m22b = m22;

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
//  @TODO: Fast, but not precise (may be darker with missing lowest bit)
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

// scroll screen one row up
void DrawScroll()
{
	// size of one row (in number of pixels)
	int rowsize = WIDTH*DrawFontHeight;

	// move 1 row up
	memmove(FrameBuf, &FrameBuf[rowsize], (FRAMESIZE - rowsize)*sizeof(u16));

	// clear last row
	u16* d = &FrameBuf[FRAMESIZE - rowsize];
	for (; rowsize > 0; rowsize--) *d++ = COL_BLACK;

	// update screen
	DispDirtyAll();
}

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
void DrawPrintChar(char ch)
{
	switch ((u8)ch)
	{
	// printable characters
	default:
		if ((u8)ch < 32) break; // not printable character

		// double-width or double-sized font
		if (DrawPrintSize >= 2)
		{
			if (DrawPrintSize == 3)
				// double-sized font
				DrawCharBg2((char)(ch + DrawPrintInv), (int)DrawPrintPos*DrawFontWidth,
					(int)DrawPrintRow*DrawFontHeight, DrawPrintCol, COL_BLACK);
			else
				// double-width font
				DrawCharBgW((char)(ch + DrawPrintInv), (int)DrawPrintPos*DrawFontWidth,
					(int)DrawPrintRow*DrawFontHeight, DrawPrintCol, COL_BLACK);

			// move cursor 1 position right
			DrawPrintPos++;
		}
		else
		{
			if (DrawPrintSize == 1)
				// double-height font
				DrawCharBgH((char)(ch + DrawPrintInv), (int)DrawPrintPos*DrawFontWidth,
					(int)DrawPrintRow*DrawFontHeight, DrawPrintCol, COL_BLACK);
			else
				// normal font size
				DrawCharBg((char)(ch + DrawPrintInv), (int)DrawPrintPos*DrawFontWidth,
					(int)DrawPrintRow*DrawFontHeight, DrawPrintCol, COL_BLACK);
		}

  // ! continue case 0x07 (move right)

	// '\a' ... (bell) move cursor 1 position right (no print)
	case 0x07:
		DrawPrintPos++;
		if (DrawPrintPos < DrawPrintPosNum) break;

  // ! continue case 0x0A (new line)

	// '\n' ... (new line) move cursor to start of next row
	case 0x0A:
		DrawPrintPos = 0;
		DrawPrintRow++; // increase row
		if (DrawPrintRow >= DrawPrintRowNum)
		{
			DrawScroll(); // scroll screen one row up
			DrawPrintRow = DrawPrintRowNum-1;
		}
		break;

	// 'x01' ... set not-inverted text
	case 0x01:
		DrawPrintInv = 0;
		break;

	// 'x02' ... set inverted text (shift character code by 0x80)
	case 0x02:
		DrawPrintInv = 128;
		break;

	// 'x03' ... use normal-sized font (default)
	case 0x03:
		DrawPrintSize = 0; // fonf size: 0=normal, 1=double-height, 2=double-width, 3=double-size
		break;

	// 'x04' ... use double-height font
	case 0x04:
		DrawPrintSize = 1; // fonf size: 0=normal, 1=double-height, 2=double-width, 3=double-size
		break;

	// 'x05' ... use double-width font
	case 0x05:
		DrawPrintSize = 2; // fonf size: 0=normal, 1=double-height, 2=double-width, 3=double-size
		break;

	// 'x06' ... use double-sized font
	case 0x06:
		DrawPrintSize = 3; // fonf size: 0=normal, 1=double-height, 2=double-width, 3=double-size
		break;

	// '\b' ... (back space) move cursor 1 position left (no print)
	case 0x08:
		if (DrawPrintPos > 0) DrawPrintPos--;
		break;

	// '\t' ... (tabulator) move cursor to next 8-character position, print spaces
	case 0x09:
		{
			u8 oldsize = DrawPrintSize; // save current font size
			DrawPrintSize = oldsize & 1; // change double-width or double-size to normal or double-height
			do DrawPrintChar(' '); while ((DrawPrintPos & 7) != 0); // print spaces
			DrawPrintSize = oldsize; // restore font size
		}
		break;

	// '\v' ... (vertical tabulator) move cursor to start of previous row
	case 0x0B:
		if (DrawPrintRow > 0) DrawPrintRow--; // decrease row
		DrawPrintPos = 0;
		break;

	// '\f' ... (form feed) clear screen, reset cursor position and set default color
	case 0x0C:
		DrawClear(); // clear screen
		DrawPrintPos = 0;  // console print character position
		DrawPrintRow = 0;  // console print character row
		DrawPrintInv = 0; // offset added to character (128 = print inverted characters)
		DrawPrintSize = 0; // fonf size: 0=normal, 1=double-width, 2=double-size
		DrawPrintCol = COL_PRINT_DEF; // console print color
		break;

	// '\r' ... (carriage return) move cursor to start of current row
	case 0x0D:
		DrawPrintPos = 0;
		break;

	// 'x10' ... set gray text color (COL_GRAY, normal color)
	case 0x10:
		DrawPrintCol = COL_PRINT_DEF;
		break;

	// 'x11' ... set blue text color (COL_AZURE)
	case 0x11:
		DrawPrintCol = COL_AZURE;
		break;

	// 'x12' ... set green text color (COL_GREEN)
	case 0x12:
		DrawPrintCol = COL_GREEN;
		break;

	// 'x13' ... set cyan text color (COL_CYAN)
	case 0x13:
		DrawPrintCol = COL_CYAN;
		break;

	// 'x14' ... set red text color (COL_RED)
	case 0x14:
		DrawPrintCol = COL_RED;
		break;

	// 'x15' ... set magenta text color (COL_MAGENTA)
	case 0x15:
		DrawPrintCol = COL_MAGENTA;
		break;

	// 'x16' ... set yellow text color (COL_YELLOW)
	case 0x16:
		DrawPrintCol = COL_YELLOW;
		break;

	// 'x17' ... set white text color (COL_WHITE)
	case 0x17:
		DrawPrintCol = COL_WHITE;
		break;
	}
}
#ifdef DRAW_PRINT
// console print text (Control characters - see DrawPrintChar)
//  If text contains digit after hex numeric code of control character,
//  split text to more parts: use "\4" "1" instead of "\41".
void DrawPrintText(const char* txt)
{
	char ch;
	while ((ch = *txt++) != 0) DrawPrintChar(ch);
	DispUpdate();
}

// callback - write data to drawing console
u32 StreamWriteDrawPrint(sStream* str, const void* buf, u32 num)
{
	u32 n = num;
	const char* txt = (const char*)buf;
	for (; n > 0; n--) DrawPrintChar(*txt++);
	return num;
}

// formatted print string to drawing console, with argument list (returns number of characters, without terminating 0)
u32 DrawPrintArg(const char* fmt, va_list args)
{
	// write and read stream
	sStream wstr, rstr;

	// initialize stream to read from
	StreamReadBufInit(&rstr, fmt, StrLen(fmt));

	// initialize stream to write to
	Stream0Init(&wstr); // initialize nul stream
	wstr.write = StreamWriteDrawPrint; // write callback

	// print string
	u32 num = StreamPrintArg(&wstr, &rstr, args);

	// display update
	if (num > 0) DispUpdate();
	return num;
}

// formatted print string to drawing console, with variadic arguments (returns number of characters, without terminating 0)
NOINLINE u32 DrawPrint(const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = DrawPrintArg(fmt, args);
	va_end(args);
	return n;
}


/*
DrawPrint test sample:

	SelFont8x16(); // select font 8x16
	DrawPrint(
		"\f"					// clear screen (resolution: 40 characters x 15 rows)

		"- invisible row scrolls up -\n"	// 0: this row will be scrolled-up

		"Hello world?\b!\n"			// 1: first visible print, overprint "?" -> "!"

		"First! row\r" "Second\n"		// 2: overprint "First! row" -> "Second row"

		"\3normal \4height \5width \6sized\n"	// 3: double-height row with font of all 4 sizes
		"\3font   \a\a\a\a\a\a\a\5font\3\n"	// 4: second half of previous double-height row

		"non-invert \2invert\1 non-invert\n"	// 5: inverted text

		"0123456701234567012345670123456701234567" // 6: print ruler 40 characters and move to next row (row is 40 columns width)
		"\t123\t1234567\t12345678\tnext row\n"	// 7, 8: move to tab positions and move to next row after all

		"\20 normal \21 blue \22 green \23 cyan \n" // 9: print colors
		"\24 red \25 magenta \26 yellow \27 white \n" // 10:

		"\2"
		"\20 normal \21 blue \22 green \23 cyan \n" // 11: print colors inverted
		"\24 red \25 magenta \26 yellow \27 white \n" // 12:

		"\1\20"					// back to default state
		"%d 0x%08x ALL OK\n"			// 13: print numbers 12345678, 0x12345678

		"\nscrolling up",			// 14: this command scrolls screen up

		12345678, 0x12345678
	);
*/
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
void DrawVLine(int x, int y, int h, u16 color) {
	DrawLine(x, y, x, y + h - 1, color);
}

void DrawHLine(int x, int y, int w, u16 color) {
	DrawLine(x, y, x + w - 1, y, color);
}

void DrawFillCircleHelper(int x0, int y0, int r, int corners, int delta, u16 color) {

	int f = 1 - r;
	int ddF_x = 1;
	int ddF_y = -2 * r;
	int x = 0;
	int y = r;
	int px = x;
	int py = y;

	delta++; // Avoid some +1's in the loop

	while (x < y) {
		if (f >= 0) {
			y--;
			ddF_y += 2;
			f += ddF_y;
		}
		x++;
		ddF_x += 2;
		f += ddF_x;
		// These checks avoid double-drawing certain lines, important
		// for the SSD1306 library which has an INVERT drawing mode.
		if (x < (y + 1)) {
			if (corners & 1)
				DrawVLine(x0 + x, y0 - y, 2 * y + delta, color);
			if (corners & 2)
				DrawVLine(x0 - x, y0 - y, 2 * y + delta, color);
		}
		if (y != py) {
			if (corners & 1)
				DrawVLine(x0 + py, y0 - px, 2 * px + delta, color);
			if (corners & 2)
				DrawVLine(x0 - py, y0 - px, 2 * px + delta, color);
			py = y;
		}
		px = x;
	}
}

void DrawCircleHelper(int x0, int y0, int r, int cornername, int color) {
	int f = 1 - r;
	int ddF_x = 1;
	int ddF_y = -2 * r;
	int x = 0;
	int y = r;

	while (x < y) {
		if (f >= 0) {
			y--;
			ddF_y += 2;
			f += ddF_y;
		}
		x++;
		ddF_x += 2;
		f += ddF_x;
		if (cornername & 0x4) {
			DrawPoint(x0 + x, y0 + y, color);
			DrawPoint(x0 + y, y0 + x, color);
		}
		if (cornername & 0x2) {
			DrawPoint(x0 + x, y0 - y, color);
			DrawPoint(x0 + y, y0 - x, color);
		}
		if (cornername & 0x8) {
			DrawPoint(x0 - y, y0 + x, color);
			DrawPoint(x0 - x, y0 + y, color);
		}
		if (cornername & 0x1) {
			DrawPoint(x0 - y, y0 - x, color);
			DrawPoint(x0 - x, y0 - y, color);
		}
	}
}

void DrawFillRect(int x, int y, int w, int h, u16 color) {
	for (int i = x; i < x + w; i++) {
		DrawVLine(i, y, h, color);
	}
}

void DrawRoundRect(int x, int y, int w, int h, int r, u16 color) {
	int max_radius = ((w < h) ? w : h) / 2; // 1/2 minor axis
	if (r > max_radius)
		r = max_radius;
	// smarter version
	DrawHLine(x + r, y, w - 2 * r, color);         // Top
	DrawHLine(x + r, y + h - 1, w - 2 * r, color); // Bottom
	DrawVLine(x, y + r, h - 2 * r, color);         // Left
	DrawVLine(x + w - 1, y + r, h - 2 * r, color); // Right
	// draw four corners
	DrawCircleHelper(x + r, y + r, r, 1, color);
	DrawCircleHelper(x + w - r - 1, y + r, r, 2, color);
	DrawCircleHelper(x + w - r - 1, y + h - r - 1, r, 4, color);
	DrawCircleHelper(x + r, y + h - r - 1, r, 8, color);
}

void DrawFillRoundRect(int x, int y, int w, int h, int r, int color) {
	int max_radius = ((w < h) ? w : h) / 2; // 1/2 minor axis
	if (r > max_radius)
		r = max_radius;
	// smarter version
	DrawFillRect(x + r, y, w - 2 * r, h, color);
	// draw four corners
	DrawFillCircleHelper(x + w - r - 1, y + r, r, 1, h - 2 * r - 1, color);
	DrawFillCircleHelper(x + r, y + r, r, 2, h - 2 * r - 1, color);
}

#endif // USE_DRAWTFT		// use TFT drawing (lib_drawtft.c, lib_drawtft.h)
