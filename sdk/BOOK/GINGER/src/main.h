
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// screen resolution

#define IMGWIDTH 320	// image width
#define IMGHEIGHT 208	// image height
//#define IMGWIDTHBYTE WIDTH // image width in bytes
#define BARWIDTH 12	// bar width
#define ROWLEN	38	// text row length
#define TXTHEIGHT (HEIGHT - IMGHEIGHT) // height of text field
#define TEXTROWS 4	// number of text rows

#define PAGES 22	// number of pages

// format: 8-bit paletted pixel graphics
// image width: 320 pixels
// image height: 208 lines
// image pitch: 320 bytes
extern const u16 Img01_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img02_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img03_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img04_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img05_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img06_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img07_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img08_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img09_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img10_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img11_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img12_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img13_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img14_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img15_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img16_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img17_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img18_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img19_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img20_Pal[256] __attribute__ ((aligned(4)));
extern const u16 Img22_Pal[256] __attribute__ ((aligned(4)));

extern const u8 Img01[28635] __attribute__ ((aligned(4)));
extern const u8 Img02[26785] __attribute__ ((aligned(4)));
extern const u8 Img03[29363] __attribute__ ((aligned(4)));
extern const u8 Img04[32701] __attribute__ ((aligned(4)));
extern const u8 Img05[24645] __attribute__ ((aligned(4)));
extern const u8 Img06[27392] __attribute__ ((aligned(4)));
extern const u8 Img07[30104] __attribute__ ((aligned(4)));
extern const u8 Img08[28011] __attribute__ ((aligned(4)));
extern const u8 Img09[23698] __attribute__ ((aligned(4)));
extern const u8 Img10[27281] __attribute__ ((aligned(4)));
extern const u8 Img11[29991] __attribute__ ((aligned(4)));
extern const u8 Img12[29799] __attribute__ ((aligned(4)));
extern const u8 Img13[28354] __attribute__ ((aligned(4)));
extern const u8 Img14[30799] __attribute__ ((aligned(4)));
extern const u8 Img15[27489] __attribute__ ((aligned(4)));
extern const u8 Img16[24266] __attribute__ ((aligned(4)));
extern const u8 Img17[24739] __attribute__ ((aligned(4)));
extern const u8 Img18[31939] __attribute__ ((aligned(4)));
extern const u8 Img19[32451] __attribute__ ((aligned(4)));
extern const u8 Img20[27524] __attribute__ ((aligned(4)));
extern const u8 Img22[17912] __attribute__ ((aligned(4)));

#endif // _MAIN_H
