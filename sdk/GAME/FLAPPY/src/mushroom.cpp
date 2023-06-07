
// ****************************************************************************
//
//                                 Mushrooms
//
// ****************************************************************************

#include "../include.h"

sObj Mushrooms[MUSHROOMS_MAX]; // mushrooms
int MushroomsNum; // initial number of mushrooms
int MushroomsStock;	// mushrooms in stock

// display mushrooms in stock
void DispMushrooms()
{
	int i;
	int n = MushroomsStock;
	if (n > 12) n = 12;
	for (i = 0; i < n; i++) DispTile(MUSHROOMTILE, 13+i, -1);
	for (; i < 12; i++) ClearTile(MUSHROOMTILE, 13+i, -1);
}

// move mushrooms
void MoveMushrooms()
{
	int i;
	sObj* o;
	u8 *m, t, t2;
	for (i = 0; i < MushroomsNum; i++)
	{
		o = &Mushrooms[i];

		// live mushroom
		if (o->state >= LIVE)
		{
			// flying
			switch (o->state)
			{
			case UPMOVE:
				if (!EnemyHit(o))
				{
					if (GetSign(o->x, o->y) == MUSHROOM+i) ClearTileSign(MUSHROOMTILE, o->x, o->y);
					t2 = GetSign(o->x, o->y-1);
					if (ISEMPTY(t2) || ISENEMY(t2))
					{
						o->y--;
						o->phase--;
					}
					else
						o->phase = 0;
					if (!EnemyHit(o) && (o->phase <= 0)) o->state = LIVE;
				}
				break;

			case DOWNMOVE:
				if (!EnemyHit(o))
				{
					if (GetSign(o->x, o->y) == MUSHROOM+i) ClearTileSign(MUSHROOMTILE, o->x, o->y);
					t2 = GetSign(o->x, o->y+1);
					if (ISEMPTY(t2) || ISENEMY(t2))
					{
						o->y++;
						o->phase--;
					}
					else
						o->phase = 0;
					if (!EnemyHit(o) && (o->phase <= 0)) o->state = LIVE;
				}
				break;

			case LEFTMOVE:
				if (!EnemyHit(o))
				{
					if (GetSign(o->x, o->y) == MUSHROOM+i) ClearTileSign(MUSHROOMTILE, o->x, o->y);
					t2 = GetSign(o->x-1, o->y);
					if (ISEMPTY(t2) || ISENEMY(t2))
					{
						o->x--;
						o->phase--;
					}
					else
						o->phase = 0;
					if (!EnemyHit(o) && (o->phase <= 0)) o->state = LIVE;
				}
				break;

			case RIGHTMOVE:
				if (!EnemyHit(o))
				{
					if (GetSign(o->x, o->y) == MUSHROOM+i) ClearTileSign(MUSHROOMTILE, o->x, o->y);
					t2 = GetSign(o->x+1, o->y);
					if (ISEMPTY(t2) || ISENEMY(t2))
					{
						o->x++;
						o->phase--;
					}
					else
						o->phase = 0;
					if (!EnemyHit(o) && (o->phase <= 0)) o->state = LIVE;
				}
				break;
			}

			// falling
			if (o->state == LIVE)
			{
				if (ISEMPTY(GetSign(o->x, o->y)))
				{
					t2 = GetSign(o->x, o->y+1);
					if (ISEMPTY(t2) || ISCHICKEN(t2) || ISENEMY(t2))
					{
						if (!EnemyHit(o))
						{
							if (GetSign(o->x, o->y) == MUSHROOM+i) ClearTileSign(MUSHROOMTILE, o->x, o->y);
							o->y++;
							EnemyHit(o);
						}
					}
				}
			}			

			if (o->state >= LIVE)
			{
				// get object on this place
				m = &Map[o->x + o->y*MAPW];
				t = *m;

				// chicken, collect mushroom
				if (ISCHICKEN(t))
				{
					o->state = INVALID; // destroy mushroom
					MushroomsStock++;
					DispMushrooms();
				}

				// ball, destroy mushroom
				else if (ISBALL(t))
				{
					o->state = INVALID; // destroy mushroom
				}

				// refresh
				else if (ISSPACE(t))
				{
					DispTileSign(MUSHROOMTILE, o->x, o->y, MUSHROOM + i);
				}
			}
		}
	}
}

