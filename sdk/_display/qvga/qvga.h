
// ****************************************************************************
//
//                                  QVGA
//
// ****************************************************************************

#if USE_QVGA		// use QVGA display (qvga.c, qvga.h)

#ifndef _QVGA_H
#define _QVGA_H

#include "qvga_config.h"

#ifdef __cplusplus
extern "C" {
#endif

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

/*
// output device
enum {
	DEV_VGA = 0,	// VGA monitor
	DEV_PAL,	// PAL TV
	DEV_NTSC,	// NTSC TV
	DEV_OLDVGA,	// old VGA monitor with separate HSYNC+VSYNC

	DEV_AUTO,	// auto device by DIP switches

	DEV_MAX
};
*/

// QVGA Colors
//	B0 ... VGA B0 blue
//	B1 ... VGA B1
//	B2 ... VGA G0 green
//	B3 ... VGA G1
//	B4 ... VGA G2
//	B5 ... VGA R0 red
//	B6 ... VGA R1
//	B7 ... VGA R2

#define COL_BLACK	0

#define COL_DARKBLUE	B0
#define COL_SEMIBLUE	B1
#define COL_BLUE	(B0+B1)
#define COL_MOREBLUE	(COL_BLUE+B3+B6)
#define COL_LIGHTBLUE	(COL_BLUE+B4+B7)

#define COL_DARKGREEN	B3
#define COL_SEMIGREEN	B4
#define COL_GREEN	(B2+B3+B4)
#define COL_MOREGREEN	(COL_GREEN+B0+B6)
#define COL_LIGHTGREEN	(COL_GREEN+B1+B7)

#define COL_DARKRED	B6
#define COL_SEMIRED	B7
#define COL_RED		(B5+B6+B7)
#define COL_MORERED	(COL_RED+B0+B3)
#define COL_LIGHTRED	(COL_RED+B1+B4)

#define COL_DARKCYAN	(B0+B3)
#define COL_SEMICYAN	(B1+B4)
#define COL_CYAN	(B0+B1+B2+B3+B4)

#define COL_DARKMAGENTA (B0+B6)
#define COL_SEMIMAGENTA (B1+B7)
#define COL_MAGENTA	(B0+B1+B5+B6+B7)

#define COL_DARKYELLOW	(B3+B6)
#define COL_SEMIYELLOW	(B4+B7)
#define COL_YELLOW	(B2+B3+B4+B5+B6+B7)

#define COL_GRAY0	0
#define COL_GRAY1	(B2+B5)
#define COL_GRAY2	(B0+B3+B6)
#define COL_GRAY3	(B0+B2+B3+B5+B6)
#define COL_GRAY4	(B1+B4+B7)
#define COL_GRAY5	(B1+B2+B4+B5+B7)
#define COL_GRAY6	(B0+B1+B3+B4+B6+B7)
#define COL_GRAY7	(B0+B1+B2+B3+B4+B5+B6+B7)

#define COL_WHITE	COL_GRAY7

// compose color from RGB
#define COLRGB(r,g,b) ((u8)(((r)&0xe0)|(((g)&0xe0)>>3)|((b)>>6)))

// pointer to current frame buffer
extern u8* pFrameBuf;

// initialize QVGA (changes system clock)
void QVgaInit();

// execute core 1 remote function
void QCore1Exec(void (*fnc)());

// check if core 1 is busy (executing remote function)
Bool QCore1Busy();

// wait if core 1 is busy (executing remote function)
void QCore1Wait();

// check VSYNC
Bool QIsVSync();

// wait for VSync scanline
void QWaitVSync();

// start QVGA (must be paired with QVgaStop)
void QVgaStart();

// terminate QVGA (must be paired with QVgaStop)
void QVgaStop();

#ifdef __cplusplus
}
#endif

#endif // _QVGA_H

#endif // USE_QVGA		// use QVGA display (qvga.c, qvga.h)
