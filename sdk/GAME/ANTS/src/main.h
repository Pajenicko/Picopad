
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// === images

// format: 4-bit paletted pixel graphics
// image width: 320 pixels
// image height: 240 lines
// image pitch: 160 bytes
extern const u16 BackgroundImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 BackgroundImg[38400] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 128 pixels
// image height: 64 lines
// image pitch: 64 bytes
extern const u16 BlacksRedsImg_Pal[9] __attribute__ ((aligned(4)));
extern const u8 BlacksRedsImg[4096] __attribute__ ((aligned(4)));
#define BLACKSREDSWALL 128
#define BLACKSREDSW 64
#define BLACKSREDSH 32

// format: 8-bit paletted pixel graphics
// image width: 1320 pixels
// image height: 60 lines
// image pitch: 1320 bytes
extern const u16 CardsImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 CardsImg[79200] __attribute__ ((aligned(4)));
#define CARDSALLW	1320
#define CARDW		40			// card width
#define CARDH		60			// card height

// format: 8-bit paletted pixel graphics
// image width: 128 pixels
// image height: 116 lines
// image pitch: 128 bytes
extern const u16 CastleImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 CastleImg[14848] __attribute__ ((aligned(4)));
#define CASTLEALLW	128
#define CASTLEW		64
#define CASTLEH		116

// format: 4-bit paletted pixel graphics
// image width: 32 pixels
// image height: 21 lines
// image pitch: 16 bytes
extern const u16 CloudImg_Pal[4] __attribute__ ((aligned(4)));
extern const u8 CloudImg[336] __attribute__ ((aligned(4)));
#define CLOUDW	32
#define CLOUDH	21

// format: 4-bit paletted pixel graphics
// image width: 16 pixels
// image height: 30 lines
// image pitch: 8 bytes
extern const u16 CursorImg_Pal[3] __attribute__ ((aligned(4)));
extern const u8 CursorImg[240] __attribute__ ((aligned(4)));
#define CURSORW 16
#define CURSORH 30

// format: 4-bit paletted pixel graphics
// image width: 8 pixels
// image height: 108 lines
// image pitch: 4 bytes
extern const u16 FenceImg_Pal[10] __attribute__ ((aligned(4)));
extern const u8 FenceImg[432] __attribute__ ((aligned(4)));
#define FENCEW	8
#define FENCEH	108

// format: 4-bit paletted pixel graphics
// image width: 192 pixels
// image height: 20 lines
// image pitch: 96 bytes
extern const u16 FlagsImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 FlagsImg[1920] __attribute__ ((aligned(4)));
#define FLAGSALLW	192
#define FLAGSW		24
#define FLAGSH		20

// format: 4-bit paletted pixel graphics
// image width: 80 pixels
// image height: 16 lines
// image pitch: 40 bytes
extern const u16 GrassImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 GrassImg[640] __attribute__ ((aligned(4)));
#define GRASSW 80
#define GRASSH 16
#define GRASSY (HEIGHT-CARDH-GRASSH)

// format: 4-bit paletted pixel graphics
// image width: 240 pixels
// image height: 120 lines
// image pitch: 120 bytes
extern const u16 OpenImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 OpenImg[14400] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 320 pixels
// image height: 40 lines
// image pitch: 160 bytes
extern const u16 OpenSelImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 OpenSelImg[6400] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 80 pixels
// image height: 40 lines
// image pitch: 40 bytes
extern const u16 OpenSel2Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 OpenSel2Img[1600] __attribute__ ((aligned(4)));

// format: 1-bit pixel graphics
// image width: 40 pixels
// image height: 60 lines
// image pitch: 5 bytes
extern const u8 ShadowImg[300] __attribute__ ((aligned(4)));

// format: 8-bit paletted pixel graphics
// image width: 41 pixels
// image height: 144 lines
// image pitch: 41 bytes
extern const u16 StateImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 StateImg[5904] __attribute__ ((aligned(4)));
#define STATEW	41
#define STATEH	144
#define STATEY (36-2)
#define STATEDY (STATEH/8)	// 18

// format: 4-bit paletted pixel graphics
// image width: 140 pixels
// image height: 53 lines
// image pitch: 70 bytes
extern const u16 TitleImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 TitleImg[3710] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 60 pixels
// image height: 50 lines
// image pitch: 30 bytes
extern const u16 Title2Img_Pal[16] __attribute__ ((aligned(4)));
extern const u8 Title2Img[1500] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 38 pixels
// image height: 32 lines
// image pitch: 19 bytes
extern const u16 TrumpetImg_Pal[12] __attribute__ ((aligned(4)));
extern const u8 TrumpetImg[608] __attribute__ ((aligned(4)));
#define TRUMPETALLW	38
#define TRUMPETW	19
#define TRUMPETH	32

// format: 4-bit paletted pixel graphics
// image width: 1024 pixels
// image height: 32 lines
// image pitch: 512 bytes
extern const u16 WinImg_Pal[11] __attribute__ ((aligned(4)));
extern const u8 WinImg[16384] __attribute__ ((aligned(4)));
#define WINALLW	1024
#define WINW	128
#define WINH	32

// === sounds
extern const u8 ApplauseSnd[29168];
extern const u8 BirdsSnd[192184];
extern const u8 BuildCastleSnd[19444];
extern const u8 BuildFenceSnd[10618];
extern const u8 CardSnd[2388];
extern const u8 CurseSnd[35080];
extern const u8 DecreaseStocksSnd[12210];
extern const u8 FanfaresSnd[59678];
extern const u8 IncreasePowerSnd[24338];
extern const u8 IncreaseStocksSnd[16588];
extern const u8 RuinCastleSnd[23724];
extern const u8 RuinFenceSnd[9134];

#endif // _MAIN_H
