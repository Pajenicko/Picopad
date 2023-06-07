
// ****************************************************************************
//
//                           Draw to QVGA 8-bit buffer
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_QDRAW		// use QVGA drawing (lib_qdraw.c, lib_qdraw.h)

#include "../inc/lib_mat2d.h"
#include "../inc/lib_qdraw.h"

// pointer to draw frame buffer
u8* pDrawBuf; // current draw buffer
int QDrawWidth = 320;
int QDrawHeight = 240; // draw buffer dimension
const u8* pDrawFont = FontBold8x8; // font 8x8

// Draw rectangle
void QDrawRect(int x, int y, int w, int h, u8 col)
{
	// limit x
	if (x < 0)
	{
		w += x;
		x = 0;
	}

	// limit w
	if (x + w > QDrawWidth) w = QDrawWidth - x;
	if (w <= 0) return;

	// limit y
	if (y < 0)
	{
		h += y;
		y = 0;
	}

	// limit h
	if (y + h > QDrawHeight) h = QDrawHeight - y;
	if (h <= 0) return;

	// draw
	u8* d = &pDrawBuf[x + y*QDrawWidth];
	int wb = QDrawWidth - w;
	int i;
	for (; h > 0; h--)
	{
		for (i = w; i > 0; i--) *d++ = col;
		d += wb;
	}
}

// Draw frame
void QDrawFrame(int x, int y, int w, int h, u8 col)
{
	if ((w <= 0) || (h <= 0)) return;
	QDrawRect(x, y, w-1, 1, col);
	QDrawRect(x+w-1, y, 1, h-1, col);
	QDrawRect(x+1, y+h-1, w-1, 1, col);
	QDrawRect(x, y+1, 1, h-1, col);
}

// clear canvas (fill with black color)
void QDrawClear()
{
	memset(pDrawBuf, 0, QDrawWidth*QDrawHeight);
}

// Draw point
void QDrawPoint(int x, int y, u8 col)
{
	// check coordinates
	if (((u32)x >= (u32)QDrawWidth) || ((u32)y >= (u32)QDrawHeight)) return;

	// draw pixel
	pDrawBuf[x + y*QDrawWidth] = col;
}

// Draw line
void QDrawLine(int x1, int y1, int x2, int y2, u8 col)
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
	int ddy = QDrawWidth;
	if (dy < 0)
	{
		sy = -1;
		ddy = -ddy;
		dy = -dy;
	}

	// destination address
	u8* d = &pDrawBuf[x1 + y1*QDrawWidth];

	// steeply in X direction, X is prefered as base
	if (dx > dy)
	{
		int m = 2*dy;
		int p = m - dx;
		dx = 2*dx;

		// slow mode, check coordinates
		if (((u32)x1 >= (u32)QDrawWidth) || ((u32)x2 >= (u32)QDrawWidth) ||
			((u32)y1 >= (u32)QDrawHeight) || ((u32)y2 >= (u32)QDrawHeight))
		{
			x2 += sx;
			for (; x1 != x2; x1 += sx)
			{
				if (((u32)x1 < (u32)QDrawWidth) && ((u32)y1 < (u32)QDrawHeight)) *d = col;
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

		// fast mode, do not check coordinates
		else
		{
			x2 += sx;
			for (; x1 != x2; x1 += sx)
			{
				*d = col;
				if (p > 0)
				{
					d += ddy;
					p -= dx;
				}
				p += m;
				d += sx;
			}
		}
	}

	// steeply in Y direction, Y is prefered as base
	else
	{
		int m = 2*dx;
		int p = m - dy;
		dy = 2*dy;

		// slow mode, check coordinates
		if (((u32)x1 >= (u32)QDrawWidth) || ((u32)x2 >= (u32)QDrawWidth) ||
			((u32)y1 >= (u32)QDrawHeight) || ((u32)y2 >= (u32)QDrawHeight))
		{
			y2 += sy;
			for (; y1 != y2; y1 += sy)
			{
				if (((u32)x1 < (u32)QDrawWidth) && ((u32)y1 < (u32)QDrawHeight)) *d = col;
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

		// fast mode, do not check coordinates
		else
		{
			y2 += sy;
			for (; y1 != y2; y1 += sy)
			{
				*d = col;
				if (p > 0)
				{
					d += sx;
					p -= dy;
				}
				p += m;
				d += ddy;
			}
		}
	}
}

// Draw filled circle
void QDrawFillCircle(int x0, int y0, int r, u8 col)
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
			if ((x*x + y*y) <= r2) QDrawPoint(x+x0, y+y0, col);
		}
	}
}

// Draw circle
void QDrawCircle(int x0, int y0, int r, u8 col)
{
	int x, y;
	if (r <= 0) return;
	r--;

	x = 0;
	y = r;
	int p = 1 - r;

	while (x <= y)
	{
		QDrawPoint(x0+y, y0-x, col);
		QDrawPoint(x0+x, y0-y, col);
		QDrawPoint(x0-x, y0-y, col);
		QDrawPoint(x0-y, y0-x, col);
		QDrawPoint(x0-y, y0+x, col);
		QDrawPoint(x0-x, y0+y, col);
		QDrawPoint(x0+x, y0+y, col);
		QDrawPoint(x0+y, y0+x, col);

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
void QDrawText(const char* text, int x, int y, u8 col)
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
		for (i = 8; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = 8; j > 0; j--)
			{
				// pixel is set
				if ((ch & 0x80) != 0) QDrawPoint(x, y, col);
				x++;
				ch <<= 1;
			}
			y++;
		}

		// shift to next character position
		x0 += 8;
	}
}

// Draw text double sized (transparent background)
void QDrawText2(const char* text, int x, int y, u8 col)
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
		for (i = 8; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = 8; j > 0; j--)
			{
				// pixel is set
				if ((ch & 0x80) != 0)
				{
					QDrawPoint(x, y, col);
					QDrawPoint(x+1, y, col);
					QDrawPoint(x, y+1, col);
					QDrawPoint(x+1, y+1, col);
				}
				x += 2;
				ch <<= 1;
			}
			y += 2;
		}

		// shift to next character position
		x0 += 16;
	}
}

// Draw text with background
void QDrawTextBg(const char* text, int x, int y, u8 col, u8 bgcol)
{
	// prepre
	int x0 = x;
	int y0 = y;
	u8 ch, c;
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
		for (i = 8; i > 0; i--)
		{
			// get one font sample
			ch = *s;
			s += 256;

			// loop through pixels of one character line
			x = x0;
			for (j = 8; j > 0; j--)
			{
				// pixel is set
				c = ((ch & 0x80) != 0) ? col : bgcol;

				// draw pixel
				QDrawPoint(x, y, c);
				x++;
				ch <<= 1;
			}
			y++;
		}

		// shift to next character position
		x0 += 8;
	}
}

// Draw text buffer (size TEXTSIZE)
void QDrawTextBuf(const char* textbuf, u8 col, u8 bgcol)
{
	// prepre
	u8 ch, c;
	int num, i, j;
	const u8* s;
	int y0, x0;
	u8* d;

	// loop through characters of text
	for (y0 = 0; y0 < QDrawHeight; y0 += 8)
	{
		d = &pDrawBuf[y0*QDrawWidth];

		for (x0 = 0; x0 < QDrawWidth; x0 += 8)
		{
			// get next character of the text
			ch = (u8)*textbuf++;

			// prepare pointer to font sample
			s = &pDrawFont[ch];

			// loop through lines of one character
			for (i = 8; i > 0; i--)
			{
				// get one font sample
				ch = *s;
				s += 256;

				// loop through pixels of one character line
				for (j = 8; j > 0; j--)
				{
					// draw pixel
					*d++ = ((ch & 0x80) != 0) ? col : bgcol;
					ch <<= 1;
				}
				d += QDrawWidth - 8;
			}
			d += 8 - 8*QDrawWidth;
		}
	}
}

// Draw text buffer with foreground color (size FTEXTSIZE)
void QDrawFTextBuf(const char* textbuf, u8 bgcol)
{
	// prepre
	u8 ch, c, col;
	int num, i, j;
	const u8* s;
	int y0, x0;
	u8* d;

	// loop through characters of text
	for (y0 = 0; y0 < QDrawHeight; y0 += 8)
	{
		d = &pDrawBuf[y0*QDrawWidth];

		for (x0 = 0; x0 < QDrawWidth; x0 += 8)
		{
			// get next character of the text
			ch = (u8)*textbuf++;

			// get foreground color
			col = (u8)*textbuf++;

			// prepare pointer to font sample
			s = &pDrawFont[ch];

			// loop through lines of one character
			for (i = 8; i > 0; i--)
			{
				// get one font sample
				ch = *s;
				s += 256;

				// loop through pixels of one character line
				for (j = 8; j > 0; j--)
				{
					// draw pixel
					*d++ = ((ch & 0x80) != 0) ? col : bgcol;
					ch <<= 1;
				}
				d += QDrawWidth - 8;
			}
			d += 8 - 8*QDrawWidth;
		}
	}
}

// Draw image
void QDrawImg(const u8* src, int xd, int yd, int w, int h, int ws)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > QDrawWidth) w = QDrawWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > QDrawHeight) h = QDrawHeight - yd;
	if (h <= 0) return;

	// draw image
	u8* d = &pDrawBuf[xd + yd*QDrawWidth];
	for (; h > 0; h--)
	{
		memcpy(d, src, w);
		d += QDrawWidth;
		src += ws;
	}
}

// Draw image with transparency (col = transparency key color)
void QDrawBlit(const u8* src, int xd, int yd, int w, int h, int ws, u8 col)
{
	// limit coordinate X
	if (xd < 0)
	{
		w += xd;
		src += -xd;
		xd = 0;
	}

	// limit w
	if (xd + w > QDrawWidth) w = QDrawWidth - xd;
	if (w <= 0) return;

	// limit coordinate Y
	if (yd < 0)
	{
		h += yd;
		src += -yd*ws;
		yd = 0;
	}

	// limit h
	if (yd + h > QDrawHeight) h = QDrawHeight - yd;
	if (h <= 0) return;

	// draw image
	u8* d = &pDrawBuf[xd + yd*QDrawWidth];
	int i;
	u8 c;
	int wbd = QDrawWidth - w;
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
void QDrawImgMat(const u8* src, int ws, int hs, int x, int y, int w, int h, const sMat2D* m, u8 mode, u8 color)
{
	// limit x
	int x0 = -w/2; // start X coordinate
	if (x < 0)
	{
		w += x;
		x0 -= x;
		x = 0;
	}
	if (x + w > QDrawWidth) w = QDrawWidth - x;
	if (w <= 0) return;

	// limit y
	int h0 = h;
	int y0 = (mode == QDRAWIMG_PERSP) ? (-h) : (-h/2); // start Y coordinate
	if (y < 0)
	{
		h += y;
		y0 -= y;
		y = 0;
	}
	if (y + h > QDrawHeight) h = QDrawHeight - y;
	if (h <= 0) return;

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
	u8* d = &pDrawBuf[QDrawWidth*y + x]; // destination image
	int wbd = QDrawWidth - w; // destination width bytes
	int i, x2, y2;

	// wrap image
	if (mode == QDRAWIMG_WRAP)
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
	else if (mode == QDRAWIMG_NOBORDER)
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
	else if (mode == QDRAWIMG_CLAMP)
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
	else if (mode == QDRAWIMG_COLOR)
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
	else if (mode == QDRAWIMG_TRANSP)
	{
		u32 ww = ws;
		u32 hh = hs;
		u8 c;

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
	else if (mode == QDRAWIMG_PERSP)
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

// draw image line interpolated
//  src = source image
//  xd,yd = destination coordinates
//  wd = destination width
//  ws = source width
//  wbs = source line pitch in bytes
void QDrawImgLine(const u8* src, int xd, int yd, int wd, int ws, int wbs)
{
	// some base checks
	if ((wd <= 0) || (ws <= 0) || (yd < 0) || (yd >= QDrawHeight)) return;

	// pixel increment
	int dinc = FRACTMUL*ws/wd;

	// prepare buffers
	u8* d = &pDrawBuf[xd + yd*QDrawWidth]; // destination address
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

// rainbow gradient table
//	GP0 ... B0 ... VGA B0 blue
//	GP1 ... B1 ... VGA B1
//	GP2 ... B2 ... VGA G0 green
//	GP3 ... B3 ... VGA G1
//	GP4 ... B4 ... VGA G2
//	GP5 ... B5 ... VGA R0 red
//	GP6 ... B6 ... VGA R1
//	GP7 ... B7 ... VGA R2
const u8 QRainbowGrad[] = {
	B7,			// dark red
	B5+B6+B7,		// red
	B4+B6+B7,		// orange
	B2+B3+B4+B5+B6+B7,	// yellow
	B2+B3+B4+B7,		// yellow-green
	B2+B3+B4,		// green
	B0+B3+B4,		// green-cyan
	B0+B1+B2+B3+B4,		// cyan
	B0+B1+B4,		// cyan-blue
	B0+B1,			// blue
	B0+B1+B7,		// blue-magenta
	B0+B1+B5+B6+B7,		// magenta
	B1+B7,			// dark magenta
};

#define RAINBOW_NUM count_of(QRainbowGrad)

// generate gradient
void QGenGrad(u8* dst, int w)
{
	// sample - rainbow pattern
	int i;
	for (i = 0; i < w; i++)
	{
		*dst++ = QRainbowGrad[i*RAINBOW_NUM/w];
	}
}


/*
// decode unsigned number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int QDecUNum(char* buf, u32 num, char sep)
{
	// temporary buffer (max. 10 digits + 3 separators + 1 NUL)
	char b[14];

	// decode number
	char* d = &b[13];
	*d = 0;
	int n = 0;
	u32 k;
	int sepn = 0;
	do {
		// thousand separator
		if ((sepn == 3) && (sep != 0))
		{
			sepn = 0;
			d--;
			*d = sep;
			n++;
		}

		k = num / 10;
		num -= k*10;
		d--;
		*d = (char)(num + '0');
		num = k;
		n++;
		sepn++;
	} while (num != 0);

	// copy number to destination buffer
	memcpy(buf, d, n+1);
	return n;
}

// decode signed number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int QDecNum(char* buf, s32 num, char sep)
{
	if (num >= 0) return QDecUNum(buf, num, sep);

	num = -num;
	*buf++ = '-';
	return DecUNum(buf, num, sep) + 1;
}

// decode hex number (dig = number of digits)
void QDecHexNum(char* buf, u32 num, u8 dig)
{
	buf += dig;
	*buf = 0;
	u8 ch;

	for (; dig > 0; dig--)
	{
		buf--;
		ch = (num & 0x0f) + '0';
		if (ch > '9') ch += 'A' - ('9'+1);
		*buf = ch;
		num >>= 4;
	}
}

// decode 2 digits of number
void QDec2Dig(char* buf, u8 num)
{
	u8 n = num/10;
	*buf++ = (char)(n + '0');
	num -= n*10;
	*buf++ = (char)(num + '0');
	*buf = 0;
}

// decode 2 digits of number with space character
void QDec2DigSpc(char* buf, u8 num)
{
	u8 n = num/10;
	if (n == 0)
		*buf++ = ' ';
	else
		*buf++ = (char)(n + '0');
	num -= n*10;
	*buf++ = (char)(num + '0');
	*buf = 0;
}

// get ascii text length
int TextLen(const char* txt)
{
	const char* t = txt;
	while (*t != 0) t++;
	return t - txt;
}
*/

#endif // USE_QDRAW		// use QVGA drawing (lib_qdraw.c, lib_qdraw.h)
