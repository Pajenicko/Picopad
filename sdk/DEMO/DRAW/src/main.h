
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// format: 16-bit pixel graphics
// image width: 32 pixels
// image height: 32 lines
// image pitch: 64 bytes
extern const u16 PeterImg[1024] __attribute__ ((aligned(4)));

// format: 16-bit pixel graphics
// image width: 32 pixels
// image height: 40 lines
// image pitch: 64 bytes
extern const u16 RPiImg[1280] __attribute__ ((aligned(4)));

#endif // _MAIN_H
