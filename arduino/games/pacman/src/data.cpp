
// ****************************************************************************
//
//                                 Data and tables
//
// ****************************************************************************

#include "data.h"

// game board
u8 Board[MAPSIZE];

// animation phase 0..3
u8 Phase;

// pacman next direction
u8 NextDir;

// current and max score
u32 Score;
u32 MaxScore = 0;
int Level; // current level 0...
s8 Lives; // remaining lives
int FrightenCnt; // frighten counter
int Eaten; // next eaten points
int ScatterCnt; // scatter counter
int ChaseCnt; // chase counter
u8 ScatterTabNext; // next entry in scatter-chasse table
int DotCnt; // eaten dot counter
int FruitCnt; // fruit counter
u32 DispNextTime; // display next time

// bonus fruit sprite
int FruitSpriteImg; // -1 = not visible
int FruitSpriteX;
int FruitSpriteY;

// pellet blink counter
u8 Blink;

// level fruit table
const u8 FruitTab[FRUITTABMAX] = { 0, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7, 7 };

// bonus table
const u16 BonusTab[8] = { 100, 300, 500, 700, 1000, 2000, 3000, 5000 };

// level frighten time table (number of seconds)
const u8 FrightenTab[FRIGHTENTABMAX] = { 9, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 0 };

// level scatter-chasse time table: 5 levels x 4 pairs of 2 entries (scatter and chasse in number of seconds, 0=permanently)
// - every row must end with 0 = infinite
const u8 ScatterTab[5*4*2] = {
	7, 20, 7, 20, 5, 20, 5, 0,	// level 1
	7, 20, 7, 20, 5,  0, 0, 0,	// level 2
	7, 20, 7, 20, 5,  0, 0, 0,	// level 3
	7, 20, 7, 20, 5,  0, 0, 0,	// level 4
	5, 20, 5, 20, 5,  0, 0, 0,	// level 5
};

// game board template (to edit, view tiles_num.bmp with tile indices)
const u8 BoardTemp[MAPSIZE] = {
//	0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27
	1,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  9, 10,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  3,	// 0
	7, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,  7,	// 1
	7, 31, 19, 20, 20, 21, 30, 19, 20, 20, 20, 21, 30, 24, 24, 30, 19, 20, 20, 20, 21, 30, 19, 20, 20, 21, 31,  7,	// 2
	7, 30, 22, 20, 20, 23, 30, 22, 20, 20, 20, 23, 30, 22, 23, 30, 22, 20, 20, 20, 23, 30, 22, 20, 20, 23, 30,  7,	// 3
	7, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,  7,	// 4
	7, 30,  5,  2,  2,  8, 30, 19, 21, 30,  5,  2,  2,  9, 10,  2,  2,  8, 30, 19, 21, 30,  5,  2,  2,  8, 30,  7,	// 5
	7, 30, 30, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 30, 30,  7,	// 6
	4,  2,  2,  2,  2,  3, 30, 24, 17,  2,  2,  8,  0, 22, 23,  0,  5,  2,  2, 18, 24, 30,  1,  2,  2,  2,  2,  6,	// 7
	0,  0,  0,  0,  0,  7, 30, 24, 24,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 24, 24, 30,  7,  0,  0,  0,  0,  0,	// 8
	2,  2,  2,  2,  2,  6, 30, 22, 23,  0, 25,  2, 32, 29, 42, 33,  2, 26,  0, 22, 23, 30,  4,  2,  2,  2,  2,  2,	// 9
	0,  0,  0,  0,  0,  0, 30,  0,  0,  0,  7,  0,  0,  0,  0,  0,  0,  7,  0,  0,  0, 30,  0,  0,  0,  0,  0,  0,	// 10
	2,  2,  2,  2,  2,  3, 30, 19, 21,  0,  7,  0,  0,  0,  0,  0,  0,  7,  0, 19, 21, 30,  1,  2,  2,  2,  2,  2,	// 11
	0,  0,  0,  0,  0,  7, 30, 24, 24,  0, 27,  2,  2,  2,  2,  2,  2, 28,  0, 24, 24, 30,  7,  0,  0,  0,  0,  0,	// 12
	0,  0,  0,  0,  0,  7, 30, 24, 24,  0,  0, 35, 36, 37, 38, 39, 40,  0,  0, 24, 24, 30,  7,  0,  0,  0,  0,  0,	// 13
	1,  2,  2,  2,  2,  6, 30, 22, 23,  0,  5,  2,  2,  9, 10,  2,  2,  8,  0, 22, 23, 30,  4,  2,  2,  2,  2,  3,	// 14
	7, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,  7,	// 15
	7, 30,  5,  2,  9, 12, 30,  5,  2,  2,  2,  8, 30, 22, 23, 30,  5,  2,  2,  2,  8, 30, 14, 10,  2,  8, 30,  7,	// 16
	7, 31, 30, 30, 24, 24, 30, 30, 30, 30, 30, 30, 30,  0,  0, 30, 30, 30, 30, 30, 30, 30, 24, 24, 30, 30, 31,  7,	// 17
	11, 2,  8, 30, 22, 23, 30, 19, 21, 30,  5,  2,  2,  9, 10,  2,  2,  8, 30, 19, 21, 30, 22, 23, 30,  5,  2, 13,	// 18
	7, 30, 30, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 24, 24, 30, 30, 30, 30, 30, 30,  7,	// 19
	7, 30,  5,  2,  2,  2,  2, 15, 16,  2,  2,  8, 30, 22, 23, 30,  5,  2,  2, 15, 16,  2,  2,  2,  2,  8, 30,  7,	// 20
	7, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30,  7,	// 21
	4,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  6,	// 22
};

// character descriptor
sChar Chars[5];

// direction vector
//		L	D	R	U
const s8 DirX[4] = { 	-1,	0,	+1,	0 };
const s8 DirY[4] = {	0,	+1,	0,	-1 };

// sprite characters indices: 9 characters * 4 directions * 4 animation phase
const u8 SpriteInx[CHAR_NUM * DIR_NUM * PHASENUM] = {

// Pacman
	// left
	SPRITE_PACFULL, SPRITE_PACL, SPRITE_PACL2, SPRITE_PACL,
	// down
	SPRITE_PACFULL, SPRITE_PACD, SPRITE_PACD2, SPRITE_PACD,
	// right
	SPRITE_PACFULL, SPRITE_PACR, SPRITE_PACR2, SPRITE_PACR,
	// up
	SPRITE_PACFULL, SPRITE_PACU, SPRITE_PACU2, SPRITE_PACU,

// Blinky
	// left
	SPRITE_BLINKY, SPRITE_BLINKY, SPRITE_BLINKY+1, SPRITE_BLINKY+1,
	// down
	SPRITE_BLINKY+2, SPRITE_BLINKY+2, SPRITE_BLINKY+3, SPRITE_BLINKY+3,
	// right
	SPRITE_BLINKY+4, SPRITE_BLINKY+4, SPRITE_BLINKY+5, SPRITE_BLINKY+5,
	// up
	SPRITE_BLINKY+6, SPRITE_BLINKY+6, SPRITE_BLINKY+7, SPRITE_BLINKY+7,

// Pinky
	// left
	SPRITE_PINKY, SPRITE_PINKY, SPRITE_PINKY+1, SPRITE_PINKY+1,
	// down
	SPRITE_PINKY+2, SPRITE_PINKY+2, SPRITE_PINKY+3, SPRITE_PINKY+3,
	// right
	SPRITE_PINKY+4, SPRITE_PINKY+4, SPRITE_PINKY+5, SPRITE_PINKY+5,
	// up
	SPRITE_PINKY+6, SPRITE_PINKY+6, SPRITE_PINKY+7, SPRITE_PINKY+7,

// Inky
	// left
	SPRITE_INKY, SPRITE_INKY, SPRITE_INKY+1, SPRITE_INKY+1,
	// down
	SPRITE_INKY+2, SPRITE_INKY+2, SPRITE_INKY+3, SPRITE_INKY+3,
	// right
	SPRITE_INKY+4, SPRITE_INKY+4, SPRITE_INKY+5, SPRITE_INKY+5,
	// up
	SPRITE_INKY+6, SPRITE_INKY+6, SPRITE_INKY+7, SPRITE_INKY+7,

// Clyde
	// left
	SPRITE_CLYDE, SPRITE_CLYDE, SPRITE_CLYDE+1, SPRITE_CLYDE+1,
	// down
	SPRITE_CLYDE+2, SPRITE_CLYDE+2, SPRITE_CLYDE+3, SPRITE_CLYDE+3,
	// right
	SPRITE_CLYDE+4, SPRITE_CLYDE+4, SPRITE_CLYDE+5, SPRITE_CLYDE+5,
	// up
	SPRITE_CLYDE+6, SPRITE_CLYDE+6, SPRITE_CLYDE+7, SPRITE_CLYDE+7,

// frozen
	// left
	SPRITE_FROZEN, SPRITE_FROZEN, SPRITE_FROZEN+1, SPRITE_FROZEN+1,
	// down
	SPRITE_FROZEN, SPRITE_FROZEN, SPRITE_FROZEN+1, SPRITE_FROZEN+1,
	// right
	SPRITE_FROZEN, SPRITE_FROZEN, SPRITE_FROZEN+1, SPRITE_FROZEN+1,
	// up
	SPRITE_FROZEN, SPRITE_FROZEN, SPRITE_FROZEN+1, SPRITE_FROZEN+1,

// frightened
	// left
	SPRITE_FRIGH, SPRITE_FRIGH, SPRITE_FRIGH+1, SPRITE_FRIGH+1,
	// down
	SPRITE_FRIGH, SPRITE_FRIGH, SPRITE_FRIGH+1, SPRITE_FRIGH+1,
	// right
	SPRITE_FRIGH, SPRITE_FRIGH, SPRITE_FRIGH+1, SPRITE_FRIGH+1,
	// up
	SPRITE_FRIGH, SPRITE_FRIGH, SPRITE_FRIGH+1, SPRITE_FRIGH+1,

// eyes
	// left
	SPRITE_EYE, SPRITE_EYE, SPRITE_EYE, SPRITE_EYE,
	// down
	SPRITE_EYE+1, SPRITE_EYE+1, SPRITE_EYE+1, SPRITE_EYE+1,
	// right
	SPRITE_EYE+2, SPRITE_EYE+2, SPRITE_EYE+2, SPRITE_EYE+2,
	// up
	SPRITE_EYE+3, SPRITE_EYE+3, SPRITE_EYE+3, SPRITE_EYE+3,

// die (8 phases)
	SPRITE_DIE, SPRITE_DIE+1, SPRITE_DIE+2, SPRITE_DIE+3,
	SPRITE_DIE+4, SPRITE_DIE+5, SPRITE_DIE+6, SPRITE_DIE+7,
	0, 0, 0, 0, 0, 0, 0, 0
};

// decode number buffer
char NumBuf[15];

