
// ****************************************************************************
//
//                                 Game Map
//
// ****************************************************************************

#include "../include.h"

// game map - contains object signature + object index
u8 Map[MAPSIZE];

// set signature of tile to game map
void SetSign(u8 tile, u8 x, u8 y, u8 sign)
{
	const sTile* t = &Tiles[tile];
	u8 dx, dy;
	u8* m;
	for (dy = 0; dy < t->h; dy++)
	{
		m = &Map[x + (y + dy)*MAPW];
		for (dx = t->w; dx > 0; dx--) *m++ = sign;
	}
}

// get signature from game map
u8 GetSign(u8 x, u8 y)
{
	return Map[x + y*MAPW];
}

// display tile and store signature (only valid area of game map)
void DispTileSign(u8 tile, u8 x, u8 y, u8 sign)
{
	DispTile(tile, x, y);
	SetSign(tile, x, y, sign);
}

// clear tile and store signature (only valid area of game map)
void ClearTileSign(u8 tile, u8 x, u8 y)
{
	ClearTile(tile, x, y);
	SetSign(tile, x, y, SPACE);
}
