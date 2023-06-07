
// ****************************************************************************
//
//         Print to attribute text buffer (format GF_ATEXT and GF_MTEXT)
//
// ****************************************************************************

#if USE_TPRINT			// use Text Print (lib_tprint.c, lib_tprint.h)

#ifndef _TPRINT_H
#define _TPRINT_H

#ifdef __cplusplus
extern "C" {
#endif

// text colors (if using PC CGA colors)
#define PC_BLACK	0
#define PC_BLUE		1
#define PC_GREEN	2
#define PC_CYAN		3
#define PC_RED		4
#define PC_MAGENTA	5
#define PC_BROWN	6
#define PC_LTGRAY	7
#define PC_GRAY		8
#define PC_LTBLUE	9
#define PC_LTGREEN	10
#define PC_LTCYAN	11
#define PC_LTRED	12
#define PC_LTMAGENTA	13
#define PC_YELLOW	14
#define PC_WHITE	15

// compose PC color
#define PC_COLOR(bg,fg) (((bg)<<4)|(fg))

// ASCII characters
#define CHAR_CR	'\r'
#define CHAR_LF	'\n'
#define CHAR_TAB '\t'
#define CHAR_FRAME 16	// single frame base
#define CHAR_DFRAME (16+128) // double frame base
#define FRAME_L	B0	// frame left flag
#define FRAME_U	B1	// frame up flag
#define FRAME_R B2	// frame right flag
#define FRAME_D B3	// frame down flag

#define CHAR_FRAME_FIRST 17 // first frame character
#define CHAR_FRAME_LAST 31 // last frame character
#define CHAR_VLINE (CHAR_FRAME|FRAME_U|FRAME_D) // vertical line
#define CHAR_HLINE (CHAR_FRAME|FRAME_L|FRAME_R) // horizontal line

#define CHAR_DFRAME_FIRST (17+128) // first double frame character
#define CHAR_DFRAME_LAST (31+128) // last double frame character
#define CHAR_DVLINE (CHAR_DFRAME|FRAME_U|FRAME_D) // vertical double line
#define CHAR_DHLINE (CHAR_DFRAME|FRAME_L|FRAME_R) // horizontal double line

#define CHAR_RASTER	1	// raster character
#define CHAR_CIRCLE	2	// circle character
#define CHAR_FULLCIRCLE	3	// full circle character
#define CHAR_HEART	4	// heart character
#define CHAR_DIAMOND	5	// diamond character
#define CHAR_CLUB	6	// club character
#define CHAR_SPADE	7	// spade character
#define CHAR_FACE	8	// face character
#define CHAR_IFACE	9	// inverted face character
#define CHAR_NOTE	10	// note character
#define CHAR_FIGURE	11	// figure character
#define CHAR_RARROW	12	// right arrow
#define CHAR_UARROW	13	// up arrow
#define CHAR_LARROW	14	// left arrow
#define CHAR_DARROW	15	// down arrow
#define CHAR_SMALLCIRCLE 16	// small circle character

#define TEXT_RARROW	"\x0C"	// right arrow
#define TEXT_UARROW	"\x0D"	// up arrow
#define TEXT_LARROW	"\x0E"	// left arrow
#define TEXT_DARROW	"\x0F"	// down arrow

// current print buffer
extern u8* TPrintBuf;

// size of print buffer
extern int TPrintBufW, TPrintBufH, TPrintBufWB;

// print position
extern int TPrintX, TPrintY;

// print color
extern u8 TPrintCol;

// setup print service (if bufwb < 2*bufw, use mono text)
void TPrintSetup(u8* buf, int bufw, int bufh, int bufwb);

// get buffer address
u8* TPrintAddr(int x, int y);

// clear text screen, using current color
void TPrintClear();

// print home
void TPrintHome();

// set print position
void TPrintSetPos(int x, int y);

// shift relative print position
void TPrintAddPos(int x, int y);

// set print color (2x4 bits of colors, use PC_COLOR macro)
void TPrintSetCol(u8 col);

// print character, not using control characters
void TPrintChar0(char ch);

// print shadow
void TPrintShadow();

// print character, using control characters CR, LF, TAB
void TPrintChar(char ch);

// print space character
void TPrintSpc();

// print space to position
void TPrintSpcTo(int pos);

// print repeated character
void TPrintCharRep(char ch, int num);

// print repeated shadow
void TPrintShadowRep(int num);

// print repeated space
void TPrintSpcRep(int num);

// print text (len = text length, -1=auto)
void TPrintText(const char* text, int len);

// print horizontal line into screen, using current color (must not stretch outside valid range!)
void TPrintHLine(int x, int y, int w);

// print horizontal double line into screen, using current color (must not stretch out of valid range)
void TPrintDHLine(int x, int y, int w);

// print vertical line into screen, using current color (must not stretch outside valid range!)
void TPrintVLine(int x, int y, int h);

// print vertical double line into screen, using current color (must not stretch out of valid range)
void TPrintDVLine(int x, int y, int h);

// print frame, using current color
void TPrintFrame(int x, int y, int w, int h);

// print double frame, using current color
void TPrintDFrame(int x, int y, int w, int h);

// print filled box, using current color
void TPrintFill(int x, int y, int w, int h);

// scroll print buffer
void TPrintScroll();

// get ascii text length
//int StrLen(const char* txt);

#ifdef __cplusplus
}
#endif

#endif // _TPRINT_H

#endif // USE_TPRINT			// use Text Print (lib_tprint.c, lib_tprint.h)
