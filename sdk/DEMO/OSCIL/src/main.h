
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define GRIDX	33
#define GRIDY	53
#define GRIDW	131
#define GRIDH	90

// format: compressed 8-bit paletted pixel graphics
// image width: 320 pixels
// image height: 240 lines
// image pitch: 320 bytes
extern const u16 OscilImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 OscilImg[31183] __attribute__ ((aligned(4)));

// format: compressed 4-bit paletted pixel graphics
// image width: 131 pixels
// image height: 90 lines
// image pitch: 66 bytes
extern const u16 GridImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 GridImg[2988] __attribute__ ((aligned(4)));

#endif // _MAIN_H
