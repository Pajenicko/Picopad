
// ****************************************************************************
//
//                   Print to attribute text buffer (format GF_ATEXT)
//
// ****************************************************************************

#include "../../global.h"	// globals

#if USE_TPRINT			// use Text Print (lib_tprint.c, lib_tprint.h)

#include "../inc/lib_tprint.h"

// current print buffer
u8* TPrintBuf;

// size of print buffer
int TPrintBufW, TPrintBufH, TPrintBufWB;

// print position
int TPrintX, TPrintY;

// print color
u8 TPrintCol;

// use mono mode
Bool TPrintMonoMode;

// setup print service (if bufwb < 2*bufw, use mono text)
void TPrintSetup(u8* buf, int bufw, int bufh, int bufwb)
{
	TPrintBuf = buf;
	TPrintBufW = bufw;
	TPrintBufH = bufh;
	TPrintBufWB = bufwb;
	TPrintX = 0;
	TPrintY = 0;
	TPrintMonoMode = (bufwb < 2*bufw);
	TPrintCol = PC_COLOR(PC_BLACK, PC_WHITE);
}

// get buffer address
u8* TPrintAddr(int x, int y)
{
	return &TPrintBuf[(TPrintMonoMode ? x : (x*2)) + y*TPrintBufWB];
}

// clear text screen, using current color
void TPrintClear()
{
	int i, y;
	u8* d;
	u8 col = TPrintCol;
	for (y = 0; y < TPrintBufH; y++)
	{
		d = &TPrintBuf[y*TPrintBufWB];
		for (i = TPrintBufW; i > 0; i--)
		{
			*d++ = ' ';
			if (!TPrintMonoMode) *d++ = col;
		}
	}
	TPrintX = 0;
	TPrintY = 0;
}

// print home
void TPrintHome()
{
	TPrintX = 0;
	TPrintY = 0;
}

// set absolute print position
void TPrintSetPos(int x, int y)
{
	TPrintX = x;
	TPrintY = y;
}

// shift relative print position
void TPrintAddPos(int x, int y)
{
	TPrintX += x;
	TPrintY += y;
}

// set print color (2x4 bits of colors, use PC_COLOR macro)
void TPrintSetCol(u8 col)
{
	TPrintCol = col;
}

// print character, not using control characters
void TPrintChar0(char ch)
{
	if (((u32)TPrintX < (u32)TPrintBufW) && ((u32)TPrintY < (u32)TPrintBufH))
	{
		if (TPrintMonoMode)
		{
			u8* d = &TPrintBuf[TPrintX + TPrintY*TPrintBufWB];
			*d = ch;
		}
		else
		{
			u8* d = &TPrintBuf[TPrintX*2 + TPrintY*TPrintBufWB];
			*d++ = ch;
			*d = TPrintCol;
		}
	}
	TPrintX++;
}

// print shadow
void TPrintShadow()
{
	if (((u32)TPrintX < (u32)TPrintBufW) && ((u32)TPrintY < (u32)TPrintBufH))
	{
		if (!TPrintMonoMode)
		{
			u8* d = &TPrintBuf[TPrintX*2 + TPrintY*TPrintBufWB + 1];
			if ((*d & 0x0f) < (*d >> 4))
				*d = PC_COLOR(PC_GRAY, PC_BLACK);
			else
				*d = PC_COLOR(PC_BLACK, PC_GRAY);
		}
	}
	TPrintX++;
}

// print character, using control characters CR, LF, TAB
void TPrintChar(char ch)
{
	// CR
	if (ch == CHAR_CR)
	{
		TPrintX = 0;
	}

	// LF
	else if (ch == CHAR_LF)
	{
		TPrintX = 0;
		TPrintY++;
		if (TPrintY >= TPrintBufH) TPrintScroll();
	}

	// Tab
	else if (ch == CHAR_TAB)
	{
		TPrintX = (TPrintX + 7) & ~7;
	}

	// character
	else
		TPrintChar0(ch);
}

// print space character
void TPrintSpc()
{
	TPrintChar0(' ');
}

// print space to position
void TPrintSpcTo(int pos)
{
	while (TPrintX < pos) TPrintSpc();
}

// print repeated character
void TPrintCharRep(char ch, int num)
{
	for (; num > 0; num--) TPrintChar(ch);
}

// print repeated shadow
void TPrintShadowRep(int num)
{
	for (; num > 0; num--) TPrintShadow();
}

// print repeated space
void TPrintSpcRep(int num)
{
	for (; num > 0; num--) TPrintSpc();
}

// print text (len = text length, -1=auto)
void TPrintText(const char* text, int len /* = -1 */)
{
	char ch;
	for (; len != 0; len--)
	{
		ch = *text++;
		if (ch == 0) break;
		TPrintChar(ch);
	}
}

// print horizontal line into screen, using current color (must not stretch out of valid range)
void TPrintHLine(int x, int y, int w)
{
	u8 col = TPrintCol;
	u8* d = &TPrintBuf[((TPrintMonoMode) ? x : (x*2)) + y*TPrintBufWB];
	u8 ch;

	// start of line
	ch = *d;
	if ((ch < CHAR_FRAME_FIRST) || (ch > CHAR_FRAME_LAST)) ch = CHAR_FRAME;
	ch |= FRAME_R;
	*d++ = ch;
	if (!TPrintMonoMode) *d++ = col;

	// inside line
	for (w -= 2; w > 0; w--)
	{
		ch = *d;
		if ((ch < CHAR_FRAME_FIRST) || (ch > CHAR_FRAME_LAST)) ch = CHAR_FRAME;
		ch |= FRAME_L | FRAME_R;
		*d++ = ch;
		if (!TPrintMonoMode) *d++ = col;
	}

	// end of line
	ch = *d;
	if ((ch < CHAR_FRAME_FIRST) || (ch > CHAR_FRAME_LAST)) ch = CHAR_FRAME;
	ch |= FRAME_L;
	*d++ = ch;
	if (!TPrintMonoMode) *d = col;
}

// print horizontal double line into screen, using current color (must not stretch out of valid range)
void TPrintDHLine(int x, int y, int w)
{
	u8 col = (u8)((TPrintCol << 4) | (TPrintCol >> 4));
	u8* d = &TPrintBuf[((TPrintMonoMode) ? x : (x*2)) + y*TPrintBufWB];
	u8 ch;

	// start of line
	ch = *d;
	if ((ch < CHAR_DFRAME_FIRST) || (ch > CHAR_DFRAME_LAST)) ch = CHAR_DFRAME;
	ch |= FRAME_R;
	*d++ = ch;
	if (!TPrintMonoMode) *d++ = col;

	// inside line
	for (w -= 2; w > 0; w--)
	{
		ch = *d;
		if ((ch < CHAR_DFRAME_FIRST) || (ch > CHAR_DFRAME_LAST)) ch = CHAR_DFRAME;
		ch |= FRAME_L | FRAME_R;
		*d++ = ch;
		if (!TPrintMonoMode) *d++ = col;
	}

	// end of line
	ch = *d;
	if ((ch < CHAR_DFRAME_FIRST) || (ch > CHAR_DFRAME_LAST)) ch = CHAR_DFRAME;
	ch |= FRAME_L;
	*d++ = ch;
	if (!TPrintMonoMode) *d = col;
}

// print vertical line into screen, using current color (must not stretch out of valid range)
void TPrintVLine(int x, int y, int h)
{
	u8 col = TPrintCol;
	int wb = TPrintBufWB;
	u8* d = &TPrintBuf[((TPrintMonoMode) ? x : (x*2)) + y*wb];
	u8 ch;

	// start of line
	ch = *d;
	if ((ch < CHAR_FRAME_FIRST) || (ch > CHAR_FRAME_LAST)) ch = CHAR_FRAME;
	ch |= FRAME_D;
	*d = ch;
	if (!TPrintMonoMode) d[1] = col;
	d += wb;

	// inside line
	for (h -= 2; h > 0; h--)
	{
		ch = *d;
		if ((ch < CHAR_FRAME_FIRST) || (ch > CHAR_FRAME_LAST)) ch = CHAR_FRAME;
		ch |= FRAME_D | FRAME_U;
		*d = ch;
		if (!TPrintMonoMode) d[1] = col;
		d += wb;
	}

	// end of line
	ch = *d;
	if ((ch < CHAR_FRAME_FIRST) || (ch > CHAR_FRAME_LAST)) ch = CHAR_FRAME;
	ch |= FRAME_U;
	*d = ch;
	if (!TPrintMonoMode) d[1] = col;
}

// print vertical double line into screen, using current color (must not stretch out of valid range)
void TPrintDVLine(int x, int y, int h)
{
	u8 col = (u8)((TPrintCol << 4) | (TPrintCol >> 4));
	int wb = TPrintBufWB;
	u8* d = &TPrintBuf[((TPrintMonoMode) ? x : (x*2)) + y*wb];
	u8 ch;

	// start of line
	ch = *d;
	if ((ch < CHAR_DFRAME_FIRST) || (ch > CHAR_DFRAME_LAST)) ch = CHAR_DFRAME;
	ch |= FRAME_D;
	*d = ch;
	if (!TPrintMonoMode) d[1] = col;
	d += wb;

	// inside line
	for (h -= 2; h > 0; h--)
	{
		ch = *d;
		if ((ch < CHAR_DFRAME_FIRST) || (ch > CHAR_DFRAME_LAST)) ch = CHAR_DFRAME;
		ch |= FRAME_D | FRAME_U;
		*d = ch;
		if (!TPrintMonoMode) d[1] = col;
		d += wb;
	}

	// end of line
	ch = *d;
	if ((ch < CHAR_DFRAME_FIRST) || (ch > CHAR_DFRAME_LAST)) ch = CHAR_DFRAME;
	ch |= FRAME_U;
	*d = ch;
	if (!TPrintMonoMode) d[1] = col;
}

// print frame, using current color
void TPrintFrame(int x, int y, int w, int h)
{
	TPrintHLine(x, y, w);
	TPrintVLine(x, y, h);
	TPrintVLine(x + w - 1, y, h);
	TPrintHLine(x, y + h - 1, w);
}

// print double frame, using current color
void TPrintDFrame(int x, int y, int w, int h)
{
	TPrintDHLine(x, y, w);
	TPrintDVLine(x, y, h);
	TPrintDVLine(x + w - 1, y, h);
	TPrintDHLine(x, y + h - 1, w);
}

// print filled box, using current color
void TPrintFill(int x, int y, int w, int h)
{
	for (; h > 0; h--)
	{
		TPrintSetPos(x, y);
		TPrintSpcRep(w);
		y++;
	}
}

// scroll print buffer
void TPrintScroll()
{
	int ww = TPrintBufW;
	if (!TPrintMonoMode) ww *= 2;
	u8* d = TPrintBuf;
	int wb = TPrintBufWB;
	u8* s = &TPrintBuf[wb];

	// scroll rows
	int i;
	for (i = TPrintBufH-1; i > 0; i--)
	{
		memcpy(d, s, ww);
		d += wb;
		s += wb;
	}

	// clear last row
	if (TPrintMonoMode)
		memset(d, ' ', ww);
	else
	{
		u8 col = TPrintCol;
		for (i = TPrintBufW; i > 0; i--)
		{
			*d++ = ' ';
			*d++ = col;
		}
	}

	// shift Y coordinate
	TPrintY--;
}

// get ascii text length
/*int TextLen(const char* txt)
{
	const char* t = txt;
	while (*t != 0) t++;
	return t - txt;
}*/

#endif // USE_TPRINT			// use Text Print (lib_tprint.c, lib_tprint.h)
