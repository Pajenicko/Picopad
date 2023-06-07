
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define TILEW	48	// tile width
#define TILEH	48	// tile height
#define TILESX	4	// game tiles in X direction (192 pixels)
#define TILESY	4	// game tiles in Y direction (192 pixels)
#define TILESNUM (TILESX*TILESY) // number of tiles (= 16)
#define TILE_EMPTY	15	// empty tile
#define TILE_WAIT	16	// wait tile
#define TILE_WAIT2	17	// wait tile 2

#define BOARDW	(TILESX*TILEW)	// board width
#define BOARDH	(TILESY*TILEH)	// board height
#define BOARDX	((WIDTH-BOARDW)/2) // board X coordinate
#define BOARDY	((HEIGHT-BOARDH)/2) // board Y coordinate

// format: 4-bit paletted pixel graphics
// image width: 48 pixels
// image height: 864 lines
// image pitch: 24 bytes
extern const u16 TilesImg_Pal[16] __attribute__ ((aligned(4)));
extern const u8 TilesImg[20736] __attribute__ ((aligned(4)));

extern const u8 MoveSnd[2354];
extern const u8 BumpSnd[1012];
extern const u8 ShufflingSnd[5620];
extern const u8 FanfareSnd[74871];

#endif // _MAIN_H
