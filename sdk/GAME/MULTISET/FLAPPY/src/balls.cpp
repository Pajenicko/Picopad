
// ****************************************************************************
//
//                                   Balls
//
// ****************************************************************************

#include "../include.h"

sObj RedBalls[REDBALLS_MAX]; // red balls
int RedBallsNum; // initial number of red balls (including destroyed)

sObj BlueBall; // blue ball

// crash ball (index will be masked)
void CrashBall(u8 inx)
{
	inx &= OBJINX_MASK;
	sObj* o = &RedBalls[inx];
	if (o->state >= LIVE)
	{
		o->state = CRASHED;
		o->phase = 0;
	}
}

// move (or crash) balls
void MoveBalls()
{
	// browsing the list of objects from the bottom
	u8* m = &Map[MAPSIZE - MAPW];
	int x, y;
	u8 t, t1, t2;
	sObj* o;
	for (y = MAPH-2; y > 0; y--) // top and bottom rows are frame
	{
		for (x = MAPW-1; x >= 0; x--)
		{
			// get tile
			m--;
			t = *m;

			// must be ball, width of 2
			if (!ISBALL(t) || (m[1] != t)) continue;

			// prepare pointer to object
			o = (ISBLUEBALL(t)) ? &BlueBall : &RedBalls[t & OBJINX_MASK];

			// check coordinates (or it is not left upper corner otherwise)
			if ((o->x != x) || (o->y != y)) continue;

			// live ball
			if (o->state >= LIVE)
			{
				// check objects below
				t1 = GetSign(x, y+2);
				t2 = GetSign(x+1, y+2);

				// stable wall
				if (ISWALL(t1) || ISWALL(t2)) continue;

				// stable balls
				if (ISBALL(t1) || ISBALL(t2)) continue;

				// crush creature
				if (ISCHICKEN(t1) || ISCHICKEN(t2)) CrushChicken();
				if (ISBLUEENEMY(t1)) CrushBlueEnemy(t1 & OBJINX_MASK);
				if (ISBLUEENEMY(t2)) CrushBlueEnemy(t2 & OBJINX_MASK);
				if (ISREDENEMY(t1)) CrushRedEnemy(t1 & OBJINX_MASK);
				if (ISREDENEMY(t2)) CrushRedEnemy(t2 & OBJINX_MASK);

				// check objects again
				t1 = GetSign(x, y+2);
				t2 = GetSign(x+1, y+2);

				// empty or mushroom, falling down
				if (ISEMPTY(t1) && ISEMPTY(t2))
				{
					// move ball
					ClearTileSign(REDBALLTILE, x, y);

					// display ball on new position
					o->y++;
					if (ISREDBALL(t))
						DispTileSign(REDBALLTILE, x, y+1, t);
					else
						DispTileSign(BLUEBALLTILE, x, y+1, t);
				}
				continue;
			}

			// crashed ball
			if (ISREDBALL(t) && (o->state == CRASHED))
			{
				o->phase++;
				if (o->phase > 4)
				{
					ClearTileSign(BALLCRASH4, x, y);
					o->state = INVALID;
				}
				else
				{
					if (o->phase == 3)
					{
						ClearTileSign(BALLCRASH2, x, y);
						o->y++;
						DispTileSign(BALLCRASH3, x, y+1, t);
					}
					else
						DispTileSign(BALLCRASH1 + o->phase - 1, x, y, t);
				}
			}
		}
	}
}

