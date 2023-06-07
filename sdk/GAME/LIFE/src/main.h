
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

//#define DRV	VideoVGA // timings
#define TILESIZE 16	// tile size in number of pixels
#define MAPW0	50	// hidden width
#define MAPH0	50	// hidden height
#define MAPW	(WIDTH/TILESIZE) // real board width (=20)
#define MAPH	(HEIGHT/TILESIZE) // real board height (=15)
#define MAPSIZE	(MAPW0*MAPH0) // board size
#define SLOTNUM	10	// number of slots
#define MAPX	((MAPW0-MAPW)/2) // start X
#define MAPY	((MAPH0-MAPH)/2) // start X

#define SPEED	200	// speed, sleep in [ms]

#define TILE_EMPTY	0	// empty tile
#define	TILE_FULL	1	// full tile
#define TILE_SELEMPTY 	2	// selected empty tile
#define TILE_SELFULL	3	// selected full tile

#define TILE_NUM	4	// number of  tiles

// format: 4-bit paletted pixel graphics
// image width: 16 pixels
// image height: 64 lines
// image pitch: 8 bytes
extern const u16 Tiles16Img_Pal[13] __attribute__ ((aligned(4)));
extern const u8 Tiles16Img[512] __attribute__ ((aligned(4)));

#endif // _MAIN_H
