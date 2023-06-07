
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// Original game created by dB-SOFT in 1984 for SHARP MZ-800 computer.
// All coordinates are in multiply of 8 pixels (= STEP).

#ifndef _MAIN_H
#define _MAIN_H

// text screen
#define FONTW	8		// font width
#define FONTH	16		// font height
#define TEXTW	(WIDTH/8)	// width of text screen (=40)
#define TEXTH	(HEIGHT/FONTH)	// height of text screen (=15)

// format: compressed 8-bit paletted pixel graphics
// image width: 320 pixels
// image height: 240 lines
// image pitch: 320 bytes
extern const u16 IntroImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 IntroImg[52518] __attribute__ ((aligned(4)));

// sound format: PCM mono 8-bit 22050Hz
extern const u8 MusicSnd[527631];

#endif // _MAIN_H
