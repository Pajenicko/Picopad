
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#ifndef _MAIN_H
#define _MAIN_H

#define TILESIZE 12	// tile size in number of pixels
#define MAPW	((WIDTH+TILESIZE-1)/TILESIZE) // board width (=27)
#define MAPH	((HEIGHT+TILESIZE-1)/TILESIZE) // board height (=20)
#define MAPSIZE	(MAPW*MAPH) // board size (=1200)

#define GAMEW	10	// width of game field
#define GAMEX	8	// start index X of game field
#define GAMEH	18	// height of game field
#define GAMEY	1	// start index Y of game field

#define TILE_BLACK	0	// black tile
#define TILE_BRICK1	1	// brick 1
#define TILE_BRICK2	2	// brick 2
#define TILE_BRICK3	3	// brick 3
#define TILE_BRICK4	4	// brick 4
#define TILE_BRICK5	5	// brick 5
#define TILE_BRICK6	6	// brick 6
#define TILE_BRICK7	7	// brick 7
#define TILE_EMPTY	8	// empty game tile
#define TILE_WALL	9	// wall
#define TILE_FRAMELU	10	// frame left up
#define TILE_FRAMEU	11	// frame up
#define TILE_FRAMERU	12	// frame right up
#define	TILE_FRAMEL	13	// frame left
#define TILE_FRAMER	14	// frame right
#define TILE_FRAMELD	15	// frame left down
#define TILE_FRAMED	16	// frame down
#define TILE_FRAMERD	17	// frame right down
#define TILE_FRAME	18	// frame middle

#define TILE_NUM	19	// number of  tiles

// format: 8-bit paletted pixel graphics
// image width: 228 pixels
// image height: 12 lines
// image pitch: 228 bytes
extern const u16 TilesImg_Pal[172] __attribute__ ((aligned(4)));
extern const u8 TilesImg[2736] __attribute__ ((aligned(4)));
#define TILESIMGW	228

// sounds
extern const u8 BrickSnd[2354];
extern const u8 GameOverSnd[14648];
extern const u8 LevelUpSnd[43971];
extern const u8 LineSnd[7330];

#endif // _MAIN_H
