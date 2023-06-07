
// ****************************************************************************
//
//                                    Tiles
//
// ****************************************************************************

#include "../include.h"

// Tiles (y, x, w, h)
const sTile Tiles[TILES_NUM] = {
	{ 19, 15, 1, 1 },	// 0: empty tile
	{ 20, 14, 1, 1 },	// 1: red wall
	{ 20, 15, 1, 1 },	// 2: blue wall
	{ 0, 0, 2, 2 },		// 3: chicken down 1
	{ 0, 2, 2, 2 },		// 4: chicken down 2
	{ 0, 4, 2, 2 },		// 5: chicken down 3
	{ 0, 6, 2, 2 },		// 6: chicken down fire 1
	{ 0, 8, 2, 2 },		// 7: chicken down fire 2
	{ 2, 0, 2, 2 },		// 8: chicken up 1
	{ 2, 2, 2, 2 },		// 9: chicken up 2
	{ 2, 4, 2, 2 },		// 10: chicken up 3
	{ 2, 6, 2, 2 },		// 11: chicken up fire 1
	{ 2, 8, 2, 2 },		// 12: chicken up fire 2
	{ 4, 0, 2, 2 },		// 13: chicken left 1
	{ 4, 2, 2, 2 },		// 14: chicken left 2
	{ 4, 4, 2, 2 },		// 15: chicken left fire 1
	{ 4, 6, 2, 2 },		// 16: chicken left fire 2
	{ 6, 0, 2, 2 },		// 17: chicken right 1
	{ 6, 2, 2, 2 },		// 18: chicken right 2
	{ 6, 4, 2, 2 },		// 19: chicken right fire 1
	{ 6, 6, 2, 2 },		// 20: chicken right fire 2
	{ 6, 8, 2, 1 },		// 21: chicken crash
	{ 4, 8, 2, 1 },		// 22: chicken eaten 1
	{ 5, 8, 2, 1 },		// 23: chicken eaten 2
	{ 0, 10, 2, 2 },	// 24: chicken jumping 1 (high)
	{ 2, 10, 2, 2 },	// 25: chicken jumping 2 (low)
	{ 7, 8, 1, 1 },		// 26: chicken go home
	{ 7, 9, 1, 1 },		// 27: mushroom
	{ 8, 0, 2, 2 },		// 28: blue enemy left 1
	{ 8, 2, 2, 2 },		// 29: blue enemy left 2
	{ 10, 0, 2, 2 },	// 30: blue enemy right 1
	{ 10, 2, 2, 2 },	// 31: blue enemy right 2
	{ 20, 10, 2, 1 },	// 32: blue enemy crash
	{ 8, 4, 2, 2 },		// 33: blue enemy sleep 1
	{ 8, 6, 2, 2 },		// 34: blue enemy sleep 2
	{ 8, 8, 2, 2 },		// 35: blue enemy sleep 3
	{ 10, 4, 2, 2 },	// 36: blue enemy sleep 4
	{ 10, 6, 2, 2 },	// 37: blue enemy sleep 5
	{ 10, 8, 2, 2 },	// 38: blue enemy sleep 6
	{ 12, 0, 2, 2 },	// 39: red enemy down 1
	{ 0, 12, 2, 3 },	// 40: red enemy down 2
	{ 3, 12, 2, 3 },	// 41: red enemy down 3
	{ 6, 10, 2, 2 },	// 42: red enemy up 1
	{ 6, 12, 2, 3 },	// 43: red enemy up 2
	{ 9, 12, 2, 3 },	// 44: red enemy up 3
	{ 20, 12, 2, 1 },	// 45: red enemy crash
	{ 12, 2, 2, 2 },	// 46: red enemy left 1
	{ 12, 4, 2, 2 },	// 47: red enemy right 1
	{ 12, 6, 3, 2 },	// 48: red enemy left 2
	{ 12, 9, 3, 2 },	// 49: red enemy right 2
	{ 0, 14, 2, 2 },	// 50: red enemy sleep 1
	{ 2, 14, 2, 2 },	// 51: red enemy sleep 2
	{ 4, 14, 2, 2 },	// 52: red enemy sleep 3
	{ 6, 14, 2, 2 },	// 53: red enemy sleep 4
	{ 8, 14, 2, 2 },	// 54: red enemy sleep 5
	{ 10, 14, 2, 2 },	// 55: red enemy sleep 6
	{ 8, 10, 2, 2 },	// 56: no enemy sleep 1
	{ 10, 10, 2, 2 },	// 57: no enemy sleep 2
	{ 12, 12, 2, 2 },	// 58: no enemy sleep 3
	{ 12, 14, 2, 2 },	// 59: no enemy sleep 4
	{ 14, 0, 2, 2 },	// 60: arrow up
	{ 14, 2, 2, 2 },	// 61: arrow right
	{ 14, 4, 2, 2 },	// 62: arrow down
	{ 14, 6, 2, 2 },	// 63: arrow left
	{ 4, 10, 2, 2 },	// 64: blue ball
	{ 14, 8, 2, 2 },	// 65: red ball
	{ 14, 10, 2, 2 },	// 66: red ball crash 1
	{ 14, 12, 2, 2 },	// 67: red ball crash 2
	{ 14, 14, 2, 1 },	// 68: red ball crash 3
	{ 15, 14, 2, 1 },	// 69: red ball crash 4
	{ 16, 0, 8, 2 },	// 70: text GAME
	{ 16, 8, 8, 2 },	// 71: text OVER
	{ 18, 0, 6, 2 },	// 72: text SPACE
	{ 18, 6, 5, 1 },	// 73: red text SCENE
	{ 18, 11, 5, 1 },	// 74: yellow text SCENE
	{ 19, 6, 4, 1 },	// 75: text TIME
	{ 19, 10, 5, 1 },	// 76: text SCORE
	{ 20, 0, 1, 1 },	// 77: digit 0
	{ 20, 1, 1, 1 },	// 78: digit 1
	{ 20, 2, 1, 1 },	// 79: digit 2
	{ 20, 3, 1, 1 },	// 80: digit 3
	{ 20, 4, 1, 1 },	// 81: digit 4
	{ 20, 5, 1, 1 },	// 82: digit 5
	{ 20, 6, 1, 1 },	// 83: digit 6
	{ 20, 7, 1, 1 },	// 84: digit 7
	{ 20, 8, 1, 1 },	// 85: digit 8
	{ 20, 9, 1, 1 },	// 86: digit 9
	{ 21, 0, 8, 1 },	// 87: text dB-SOFT
	{ 21, 8, 6, 1 },	// 88: text by-SSKO
};

// display tile, including header
void DispTile(u8 tile, int x, int y)
{
	const sTile* t = &Tiles[tile];
	DrawImg4Pal(TilesImg, TilesImg_Pal, t->x*STEP, t->y*STEP, x*STEP+MAPX,
		y*STEP+MAPY, t->w*STEP, t->h*STEP, TILESALLW);
}

// clear tile, including header
void ClearTile(u8 tile, int x, int y)
{
	const sTile* t = &Tiles[tile];
	DrawRect(x*STEP+MAPX, y*STEP+MAPY, t->w*STEP, t->h*STEP, COL_BLACK);
}
