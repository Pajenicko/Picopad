
// ****************************************************************************
//
//                                 Game Map
//
// ****************************************************************************

#ifndef _GAMEMAP_H
#define _GAMEMAP_H

// game map
#define STEP		8		// base step size, in number of pixels
#define HEADH		3		// head height
#define MAPW		40		// game map width
#define MAPH		22		// game map height
#define MAPSIZE		(MAPW*MAPH)	// game map size (= 880)

#define BOARDW		(MAPW*STEP) // board total width (= 320)
#define BOARDX		((WIDTH-BOARDW)/2) // board X coordinate (= 0)
#define BOARDH 		((MAPH+HEADH)*STEP) // board total height (= 200)
#define BOARDY 		((HEIGHT-BOARDH)/2) // board Y coordinate (= 20)

#define MAPX		BOARDX		// base X coordinate of game map
#define MAPY		(BOARDY+HEADH*STEP) // base Y coordinate of game map

// object signature in game map, some signatures contain index in lower 5 bits
#define SPACE		0x00	// empty tile
#define MUSHROOM	0x20	// mushroom + index
#define CHICKEN		0x40	// chicken
#define BLUEENEMY	0x60	// blue enemy + index
#define REDENEMY	0x80	// red enemy + index
#define REDBALL		0xA0	// red ball + index
#define BLUEBALL	0xC0	// blue ball
#define WALL		0xE0	// red wall
#define BLUEWALL	0xE1	// blue wall

#define OBJTYPE_MASK	0xE0	// object type mask
#define OBJINX_MASK	0x1F	// object index mask

#define ISMUSHROOM(t)	(((t)&OBJTYPE_MASK)==MUSHROOM) // is mushroom
#define ISSPACE(t)	((t)==SPACE) // is empty tile
#define ISEMPTY(t)	((t)<CHICKEN) // is empty of mushroom
#define ISCHICKEN(t)	((t)==CHICKEN) // is chicken
#define ISENEMY(t)	(((t)>=BLUEENEMY)&&((t)<REDBALL)) // blue or red enemy
#define ISBLUEENEMY(t)	(((t)&OBJTYPE_MASK)==BLUEENEMY) // is blue enemy
#define ISREDENEMY(t)	(((t)&OBJTYPE_MASK)==REDENEMY) // is red enemy
#define ISBALL(t)	(((t)>=REDBALL)&&((t)<WALL)) // is ball (red or blue)
#define ISREDBALL(t)	(((t)&OBJTYPE_MASK)==REDBALL) // is full red ball
#define ISBLUEBALL(t)	((t)==BLUEBALL) // is blue ball
#define ISWALL(t)	((t)>=WALL) // is wall (red or blue)
#define ISBLUEWALL(t)	((t)==BLUEWALL) // is blue wall

// game map - contains object signature + object index
extern u8 Map[MAPSIZE];

// set signature of tile to game map
void SetSign(u8 tile, u8 x, u8 y, u8 sign);

// get signature from game map
u8 GetSign(u8 x, u8 y);

// display tile and store signature (only valid area of game map)
void DispTileSign(u8 tile, u8 x, u8 y, u8 sign);

// clear tile and store signature (only valid area of game map)
void ClearTileSign(u8 tile, u8 x, u8 y);

#endif // _GAMEMAP_H
