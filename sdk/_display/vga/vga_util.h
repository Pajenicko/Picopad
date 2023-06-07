
// ****************************************************************************
//
//                                 VGA utilities
//
// ****************************************************************************

#ifndef _VGA_UTIL_H
#define _VGA_UTIL_H

#include "vga_config.h"		// common definitions of C and ASM

#ifdef __cplusplus
extern "C" {
#endif

#if USE_VGA		// use VGA display (vga.c, vga.h)

// convert image from 16-color to 8x8 attribute format
void Attr8Conv(u8* dst, u8* attr, const u8* src, int w, int h, const u8* pal);

// convert image from 4-color to 2-plane format (width must be multiply of 8)
void Plane2Conv(u8* plane0, u8* plane1, const u8* src, int w, int h);

// invert image
void ImgInvert(u8* dst, int num);

// prepare image with white key transparency (copy and increment pixels)
void CopyWhiteImg(u8* dst, const u8* src, int num);

#endif // USE_VGA		// use VGA display (vga.c, vga.h)

/*
// decode unsigned number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecUNum(char* buf, u32 num, char sep);

// decode signed number into ASCIIZ text buffer (returns number of digits)
//  sep = thousand separator, 0=none
int DecNum(char* buf, s32 num, char sep);

// decode hex number (dig = number of digits)
void DecHexNum(char* buf, u32 num, u8 dig);

// decode 2 digits of number
void Dec2Dig(char* buf, u8 num);

// decode 2 digits of number with space character
void Dec2DigSpc(char* buf, u8 num);
*/

#ifdef __cplusplus
}
#endif

#endif // _VGA_UTIL_H
