
// ****************************************************************************
//
//                                 VGA utilities
//
// ****************************************************************************

#include "../../global.h"	// globals
#include "vga_util.h"

#if USE_VGA		// use VGA display (vga.c, vga.h)

#include "vga_pal.h"
#include "lib_tprint.h"

// convert image from 16-color to 8x8 attribute format
void Attr8Conv(u8* dst, u8* attr, const u8* src, int w, int h, const u8* pal)
{
	int x, y, i, j, bestnum, best2num;
	int hist[16];
	u8 b, b2, b3, best, best2, bestcol, best2col;
	const u8 *s;
	u8 *d;
	int ws = w/2;
	int wd = w/8;

	for (y = 0; y < h; y += 8)
	{
		for (x = 0; x < w; x += 8)
		{
			// clear histogram
			memset(hist, 0, 16*sizeof(int));

			// get histogram of this segment
			s = src;
			for (i = 0; i < 8; i++)
			{
				b = s[0]; hist[b >> 4]++; hist[b & 0x0f]++;
				b = s[1]; hist[b >> 4]++; hist[b & 0x0f]++;
				b = s[2]; hist[b >> 4]++; hist[b & 0x0f]++;
				b = s[3]; hist[b >> 4]++; hist[b & 0x0f]++;
				s += ws;
			}

			// find 1st best pixel
			best2 = 0;
			best2num = 0;
			for (i = 0; i < 16; i++)
			{
				if (hist[i] > best2num)
				{
					best2 = (u8)i;
					best2num = hist[i];
				}
			}

			// find 2nd best pixel
			best = best2;
			bestnum = 0;
			for (i = 0; i < 16; i++)
			{
				if ((hist[i] > bestnum) && (i != best2))
				{
					best = (u8)i;
					bestnum = hist[i];
				}
			}

			// sort pixels, 'best' will be brighter (foreground) than 'best2' (background)
			if (ColDist(best, 0) < ColDist(best2, 0))
			{
				i = best;
				best = best2;
				best2 = i;
			}

			// write attributes (best = foreground, best2 = background)
			*attr++ = (best2 << 4) | best;
			bestcol = pal[best];
			best2col = pal[best2];

			// write pixels
			s = src;
			d = dst;
			for (i = 0; i < 8; i++)
			{
				b3 = 0;

				b = s[0];
				b2 = pal[b >> 4];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B7 : 0;
				b2 = pal[b & 0x0f];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B6 : 0;

				b = s[1];
				b2 = pal[b >> 4];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B5 : 0;
				b2 = pal[b & 0x0f];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B4 : 0;

				b = s[2];
				b2 = pal[b >> 4];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B3 : 0;
				b2 = pal[b & 0x0f];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B2 : 0;

				b = s[3];
				b2 = pal[b >> 4];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B1 : 0;
				b2 = pal[b & 0x0f];
				b3 |= (ColDist(b2, bestcol) < ColDist(b2, best2col)) ? B0 : 0;

				*d = b3;

				s += ws;
				d += wd;
			}

			// next segment on the row
			src += 4;
			dst++;
		}

		// next row
		src += ws*7;
		dst += wd*7;
	}
}

// convert image from 4-color to 2-plane format (width must be multiply of 8)
void Plane2Conv(u8* plane0, u8* plane1, const u8* src, int w, int h)
{
	int i;
	u8 b1, b2;
	for (i = w/8*h; i > 0; i--)
	{
		b2 = *src++;
		b1 = *src++;
		*plane0++ = ((b2 & B6)<<1) | ((b2 & B4)<<2) | ((b2 & B2)<<3) | ((b2 & B0)<<4) |
				((b1 & B6)>>3) | ((b1 & B4)>>2) | ((b1 & B2)>>1) | (b1 & B0);
		*plane1++ = (b2 & B7) | ((b2 & B5)<<1) | ((b2 & B3)<<2) | ((b2 & B1)<<3) |
				((b1 & B7)>>4) | ((b1 & B5)>>3) | ((b1 & B3)>>2) | ((b1 & B1)>>1);
	}
}

// invert image
void ImgInvert(u8* dst, int num)
{
	for (; num > 0; num--)
	{
		*dst = ~*dst;
		dst++;
	}
}

// prepare image with white key transparency (copy and increment pixels)
void CopyWhiteImg(u8* dst, const u8* src, int num)
{
	for (; num > 0; num--) *dst++ = *src++ + 1;
}

#endif // USE_VGA		// use VGA display (vga.c, vga.h)

/*
// decode unsigned number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecUNum(char* buf, u32 num, char sep)
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
int DecNum(char* buf, s32 num, char sep)
{
	if (num >= 0) return DecUNum(buf, num, sep);

	num = -num;
	*buf++ = '-';
	return DecUNum(buf, num, sep) + 1;
}

// decode hex number (dig = number of digits)
void DecHexNum(char* buf, u32 num, u8 dig)
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
void Dec2Dig(char* buf, u8 num)
{
	u8 n = num/10;
	*buf++ = (char)(n + '0');
	num -= n*10;
	*buf++ = (char)(num + '0');
	*buf = 0;
}

// decode 2 digits of number with space character
void Dec2DigSpc(char* buf, u8 num)
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
*/
