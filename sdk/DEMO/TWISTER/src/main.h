
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define IMGWIDTH 128		// image width
#define IMGHEIGHT 128		// image height
#define IMGWIDTHB ((IMGWIDTH+1)/2) // bytes per line of image

#define TWISTW	100		// twister width

// format: 4-bit paletted pixel graphics
// image width: 128 pixels
// image height: 128 lines
// image pitch: 64 bytes
extern const u16 CobbleStoneImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 CobbleStoneImg[8192] __attribute__ ((aligned(4)));
extern const u16 FabricImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 FabricImg[8192] __attribute__ ((aligned(4)));
extern const u16 SoilImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 SoilImg[8192] __attribute__ ((aligned(4)));
extern const u16 WoodImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 WoodImg[8192] __attribute__ ((aligned(4)));

#endif // _MAIN_H
