
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// earth image
#define EARTHW	512	// image width (must be power of 2)
#define EARTHH	256	// image height

// globe
#define GLOBER	(HEIGHT/2 - 1) // globe radius
#define GLOBEX	(WIDTH/2) // globe X center
#define GLOBEY	(HEIGHT/2) // globe Y center

// format: 8-bit paletted pixel graphics
// image width: 512 pixels
// image height: 256 lines
// image pitch: 512 bytes
extern const u16 Earth1Img_Pal[256] __attribute__ ((aligned(4)));
extern const u8 Earth1Img[131072] __attribute__ ((aligned(4)));
extern const u16 Earth2Img_Pal[256] __attribute__ ((aligned(4)));
extern const u8 Earth2Img[131072] __attribute__ ((aligned(4)));

#endif // _MAIN_H
