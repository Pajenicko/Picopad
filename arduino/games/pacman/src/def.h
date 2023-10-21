
// ****************************************************************************
//
//                              Definitions
//
// ****************************************************************************

#ifndef _DEF_H
#define _DEF_H

#include "include.h"

//#define DEBUG_DDQD	// flag - debug immortality

// game board
#define MAPW	28	// width of game board (tiles)
#define MAPH	23	// height of game board (tiles)
#define MAPSIZE	(MAPW*MAPH) // board size (= 644)
#define TILESIZE 10	// tile size in number of pixels
#define MAPWIDTH (MAPW*TILEW) // width of game board in pixels (= 280)
#define MAPHEIGHT (MAPH*TILEH) // height of game board in pixels (= 230)
#define MAPY	0		// map Y coordinate
#define MAPX	((WIDTH-MAPWIDTH)/2) // map X coordinate

// tiles
#define TILE_EMPTY	0	// empty
#define TILE_GATE	29	// passable gate
#define TILE_DOT	30	// pac-dot
#define	TILE_PELLET	31	// power pellet
#define TILE_GATEL	32	// gate left
#define TILE_GATER	33	// gate rigth
#define	TILE_PELLETOFF	34	// power pellet OFF
#define TILE_READY1	35	// Ready!
#define TILE_READY2	36	// Ready!
#define TILE_READY3	37	// Ready!
#define TILE_READY4	38	// Ready!
#define TILE_READY5	39	// Ready!
#define TILE_READY6	40	// Ready!
#define TILE_DISABLE	41	// hidden disabled tile (at home)
#define TILE_GATE2	42	// impassable gate

#define TILE_NUM	43	// number of tiles

// sprites
#define SPRITE_BLACK	0	// black sprite
#define SPRITE_PACFULL	1	// pacman full
#define SPRITE_PACL	2	// pacman left
#define SPRITE_PACL2	3	// pacman left 2
#define SPRITE_PACD	4	// pacman down
#define SPRITE_PACD2	5	// pacman down 2
#define SPRITE_PACR	6	// pacman right
#define SPRITE_PACR2	7	// pacman right 2
#define SPRITE_PACU	8	// pacman up
#define SPRITE_PACU2	9	// pacman up 2
#define SPRITE_DIE	8	// pacman die 1st sprite
#define SPRITE_DIENUM	8	// pacman die number of sprites
#define SPRITE_BLINKY	16	// Blinky 1st sprite
#define SPRITE_PINKY	24	// Pinky 1st sprite
#define SPRITE_INKY	32	// Inky 1st sprite
#define SPRITE_CLYDE	40	// Clyde 1st sprite
#define SPRITE_EYE	48	// eye 1st sprite
#define SPRITE_FRIGH	52	// frightened 1st sprite
#define SPRITE_FROZEN	54	// frozen 1st sprite (slowed down)
#define SPRITE_FRUIT	56	// fruit sprites start (8 sprites)
#define SPRITE_200	64	// 200
#define SPRITE_400	65	// 400
#define SPRITE_800	66	// 800
#define SPRITE_1600	67	// 1600

#define SPRITE_NUM	68	// number of sprites

#define PHASENUM	4	// number of animation phases

// direction
enum {
	DIR_L = 0,	// left
	DIR_D,		// down
	DIR_R,		// right
	DIR_U,		// up

	DIR_NUM
};

// sprite characters
enum {
	CH_PACMAN = 0,

	CH_BLINKY,
	CH_PINKY,
	CH_INKY,
	CH_CLYDE,

	CH_FROZEN,
	CH_FRIGHTEN,
	CH_EYES,

	CH_DIE,
	
	CHAR_NUM
};

// character colors
#define COL_PACMAN	COL_YELLOW
#define COL_BLINKY	COL_RED
#define COL_PINKY	RGBTO16(255,166,195)
#define COL_INKY	RGBTO16(0,230,255)
#define COL_CLYDE	RGBTO16(255,166,0)

#define COL_SCORE	RGBTO16(0,0,195)	// score color of eaten ghost

// ghost state
enum {
	S_SCATTER = 0,
	S_CHASE,
	S_FRIGHTEN,
	S_EATEN,

	S_NUM
};

// convert map coordinates to sprite pixel coordinates
#define MAPTOX(x) (MAPX+(x)*TILEW+TILEW/2-SPRITEW/2)
#define MAPTOY(y) (MAPY+(y)*TILEH+TILEH/2-SPRITEH/2)

// convert sprite pixel coordinates to map coordinates
#define XTOMAP(x) (((x)-MAPX+SPRITEW/2)/TILEW)
#define YTOMAP(y) (((y)-MAPY+SPRITEH/2)/TILEH)

// ghost home
#define HOMEXMIN 11	// home X min
#define HOMEXMAX 16	// home X max
#define HOMEYMIN 10	// home Y min
#define HOMEYMAX 11	// home Y max
#define HOMEXMID 13	// middle home X (gate)

#define FRUITTABMAX 19	// size of level fruit table
#define FRIGHTENTABMAX 19 // size of frighten table

// character descriptor
typedef struct {
	s16	x, y;	// graphics coordinates on the screen - current coordinates during animation
	s16	sleeptimer; // sleep timer
	s16	dx, dy;	// move vector (0=not moving)
	s8	steps;	// step counter to next tile
	u8	dir;	// current direction DIR_*
	u8	state;	// ghost state (S_SCATTER,...), pacman state 0=normal or SPRITE_DIE
	u8	anim;	// sprite current character animation base index (without direction and animation phase)
} sChar;

// pacman character speed
#define SPEED 100	// delay of 1 animation phase in [ms]
#define CHARSTEPS 2	// character steps - number of animation phases per 1 tile
#define CHARSPEED (TILESIZE/CHARSTEPS)	// character speed - number of pixels per 1 animation phase
#define FRIGHSPEED (TILESIZE*3/4/CHARSTEPS) // frightened speed - number of pixels per 1 animation phase

#define DOT_NUM 210 //244	// total number of dots (including 4 pellets)
#define DOT_FRUIT1 (DOT_NUM-60) //(DOT_NUM-70) // fruit 1 (= 174)
#define DOT_FRUIT2 (DOT_NUM-150) //(DOT_NUM-170) // fruit 2 (= 74)
/*
// Reached score:
// - dots can give 240*10 + 4*50 = 2600 points
// - Ghosts eaten: 200, 400, 800, 1600 (increase every ghost eaten after eaten 1 pellet)
//    for ghosts total can give (200+400+800+1600)*4 = 12000 points (not for level 19 and more)
// - bonus apears after eating 70 dots and 170 dots, point 100 to 5000 points
// Absolute maximum score: 3,333,360 points (reached by Billy Mitchell)
*/

#endif // _DEF_H
