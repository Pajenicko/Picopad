
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// program version and copyright
#define VERSION	"1.0"
#define COPYRIGHT "(c) 2023 Miroslav Nemecek"

// text screen
#define FONTW	8		// font width
#define FONTH	16		// font height
#define TEXTW	(WIDTH/8)	// width of text screen (=40)
#define TEXTH	(HEIGHT/FONTH)	// height of text screen (=15)

// format: 4-bit paletted pixel graphics
// image width: 92 pixels
// image height: 4 lines
// image pitch: 46 bytes
extern const u16 Tiles4Img_Pal[15] __attribute__ ((aligned(4)));
extern const u8 Tiles4Img[184] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 184 pixels
// image height: 8 lines
// image pitch: 92 bytes
extern const u16 Tiles8Img_Pal[15] __attribute__ ((aligned(4)));
extern const u8 Tiles8Img[736] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 276 pixels
// image height: 12 lines
// image pitch: 138 bytes
extern const u16 Tiles12Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Tiles12Img[1656] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 368 pixels
// image height: 16 lines
// image pitch: 184 bytes
extern const u16 Tiles16Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Tiles16Img[2944] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 460 pixels
// image height: 20 lines
// image pitch: 230 bytes
extern const u16 Tiles20Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Tiles20Img[4600] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 552 pixels
// image height: 24 lines
// image pitch: 276 bytes
extern const u16 Tiles24Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Tiles24Img[6624] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 644 pixels
// image height: 28 lines
// image pitch: 322 bytes
extern const u16 Tiles28Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Tiles28Img[9016] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 736 pixels
// image height: 32 lines
// image pitch: 368 bytes
extern const u16 Tiles32Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Tiles32Img[11776] __attribute__ ((aligned(4)));

// sound format: PCM mono 8-bit 22050Hz
extern const u8 YippeeSnd[17902];

// wait for a character
char WaitChar();

#endif // _MAIN_H
