
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define FLAGW	180	// flag width
#define FLAGH	120	// flag height
#define FLAGX	9	// flag X coordinate relative to mast
#define FLAGY	45	// flag Y base coordinate

#define MASTW	12	// mast width
#define MASTH	210	// mast height
#define MASTX	55	// mast X coordinate

// format: 4-bit paletted pixel graphics
// image width: 320 pixels
// image height: 240 lines
// image pitch: 160 bytes
extern const u16 CloudsImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 CloudsImg[38400] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 180 pixels
// image height: 120 lines
// image pitch: 90 bytes
extern const u16 FlagImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 FlagImg[10800] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 12 pixels
// image height: 210 lines
// image pitch: 6 bytes
extern const u16 MastImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 MastImg[1260] __attribute__ ((aligned(4)));

#endif // _MAIN_H
