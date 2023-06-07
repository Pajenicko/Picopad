
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

// info row
#define INFOY	0		// Y coordinate of info row
#define INFOH	16		// height of info row (1 character is 8x16 pixels)

// skyline
#define SKYLINEY INFOH		// skyline Y coordinate
#define SKYLINEW 320		// skyline width
#define SKYLINEH 29		// skyline height
#define HORIZONH SKYLINEH	// horizon height

// tiles
#define TILEBITS 7		// number of bits of tile width and height
#define TILESIZE (1<<TILEBITS)	// tile width and height in pixels (= 128, must be power of 2)
#define TILENUM	23		// number of tiles

// game map
#define MAPY	(SKYLINEY+SKYLINEH) // terrain Y coordinate
#define MAPWBITS 5
#define MAPW	(1<<MAPWBITS)	// tile map width (= 32, must be power of 2)
#define MAPHBITS 5
#define MAPH	(1<<MAPHBITS)	// tile map height (= 32, must be power of 2)
#define MAPSIZE	(MAPW*MAPH)	// tile map size (= 1024)
#define TERRAINH (HEIGHT-INFOH-SKYLINEH) // height of terrain
#define HORIZ 30			// terrain horizon offset/4

// car image
#define CARIMGW		160	// car image width
#define CARIMGH		96	// car image height
#define CARIMGX		((WIDTH-CARIMGW)/2) // car image X coordinate
#define CARIMGY		(100+SKYLINEY+SKYLINEH)	// car image Y coordinate
#define CARIMGNUM	17	// number of car images
#define CARIMGMID	8	// index of middle car image
#define CARTRANS	0x630C	// car transparent color

// ghost
#define GHOSTWBITS 7		// number of bits of ghost image width
#define GHOSTHBITS 6		// number of bits of ghost image height
#define GHOSTW (1<<GHOSTWBITS)	// ghost image width (= 128)
#define GHOSTH (1<<GHOSTHBITS)	// ghost image height (= 64)

// game
#define GRASS		0	// index of grass tile
#define START		1	// index of start tile
#define CHECKA		2	// index of 1st checkpoint tile
#define CHECKB		3	// index of 2nd checkpoint tile
#define CHECKC		4	// index of 3rd checkpoint tile

#define CHECKNUM	3	// number of checkpoints

// car control
#define SPEEDCOEF	((float)TILESIZE/15) // speed coefficient
#define ACCEL		(SPEEDCOEF*5) // acceleration per second
#define ACCELSLOW	(ACCEL*0.2f) // auto slow down
#define GRASSSLOW	(ACCEL*0.01f) // grass slow down
#define TURNACCEL	0.02f	// turn acceleration
#define AUTOTURN	0.01f	// auto turn
#define TURNMAX		0.02f	// max. turn
#define SPEEDMAX	200	// max. speed

#define RECORDMAX	1000	// record max. length


// format: 8-bit paletted pixel graphics
// image width: 320 pixels
// image height: 29 lines
// image pitch: 320 bytes
extern const u16 SkylineImg_Pal[256] __attribute__ ((aligned(4)));
extern const u8 SkylineImg[9280] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 128 pixels
// image height: 2944 lines
// image pitch: 64 bytes
extern const u16 TilesPalImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 TilesPalImg[188416] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 160 pixels
// image height: 96 lines
// image pitch: 80 bytes
extern const u16 Car0Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car1Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car2Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car3Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car4Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car5Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car6Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car7Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car8Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car9Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car10Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car11Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car12Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car13Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car14Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car15Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Car16Img_Pal[16] __attribute__ ((aligned(4)));

extern const u8 Car0Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car1Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car2Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car3Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car4Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car5Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car6Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car7Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car8Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car9Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car10Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car11Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car12Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car13Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car14Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car15Img[7680] __attribute__ ((aligned(4)));
extern const u8 Car16Img[7680] __attribute__ ((aligned(4)));

// format: 4-bit paletted pixel graphics
// image width: 128 pixels
// image height: 64 lines
// image pitch: 64 bytes
extern const u16 Ghost0Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost1Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost2Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost3Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost4Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost5Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost6Img_Pal[16] __attribute__ ((aligned(4)));
extern const u16 Ghost7Img_Pal[16] __attribute__ ((aligned(4)));

extern const u8 Ghost0Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost1Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost2Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost3Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost4Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost5Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost6Img[4096] __attribute__ ((aligned(4)));
extern const u8 Ghost7Img[4096] __attribute__ ((aligned(4)));

// sound format: PCM mono 8-bit 22050Hz
extern const u8 EngineSnd[6062];

#endif // _MAIN_H
