
// ****************************************************************************
//
//                                 Blue Enemies
//
// ****************************************************************************

#include "../include.h"

sObj BlueEnemies[BLUEENEMIES_MAX]; // blue enemies
int BlueEnemiesNum; // initial number of blue enemies (including dead)

// display blue enemy
void DispBlueEnemy(int inx, u8 tile)
{
	DispTileSign(tile, BlueEnemies[inx].x, BlueEnemies[inx].y, BLUEENEMY+inx);
}

// clear blue enemy
void ClearBlueEnemy(int inx)
{
	sObj* o = &BlueEnemies[inx];
	ClearTileSign(BLUEENEMYLEFT1, o->x, o->y);
}

// crush blue enemy by ball
void CrushBlueEnemy(int inx)
{
	if ((BlueEnemies[inx].state != CRASHED) &&
		(BlueEnemies[inx].state != INVALID))
	{
		ClearBlueEnemy(inx);
		BlueEnemies[inx].y += 1;
		DispBlueEnemy(inx, BLUEENEMYCRASH);
		BlueEnemies[inx].state = CRASHED;
		BlueEnemies[inx].phase = 0;
		Score += 30;
		DispScore();
	}
}

// try blue enemy move left
void BlueEnemyTryLeft(int inx, sObj* o)
{
	// get object on left
	u8 t = TestMove(LEFT, o->x, o->y);

	// eat chicken
	if (ISCHICKEN(t)) EatChicken();

	// passable
	if (t == SPACE)
	{
		ClearBlueEnemy(inx);
		o->x--;
		o->state = LEFTMOVE; // moving left
		DispBlueEnemy(inx, BLUEENEMYLEFT2);
	}
	// not passable, try move in other direction next time
	else
	{
		o->state = RIGHT;
		DispBlueEnemy(inx, BLUEENEMYRIGHT1);
	}
}

// try blue enemy move right
void BlueEnemyTryRight(int inx, sObj* o)
{
	// get object on right
	u8 t = TestMove(RIGHT, o->x, o->y);

	// eat chicken
	if (ISCHICKEN(t)) EatChicken();

	// passable
	if (t == SPACE)
	{
		ClearBlueEnemy(inx);
		o->x++;
		o->state = RIGHTMOVE; // moving right
		DispBlueEnemy(inx, BLUEENEMYRIGHT2);
	}
	// not passable, try move in other direction next time
	else
	{
		o->state = LEFT;
		DispBlueEnemy(inx, BLUEENEMYLEFT1);
	}
}

// blue enemy sleeping
void BlueEnemyDoSleep(int inx, sObj* o)
{
	o->phase++;
	if (o->phase < 5)		
		DispBlueEnemy(inx, BLUEENEMYSLEEP1 + o->phase); // phase 0, 1, 2, 3, 4
	else
	{
		int i = (o->phase >> 4) & 0x0f;
		if (i < 1)
			DispBlueEnemy(inx, BLUEENEMYLEFT1);
		else if (i <= 10)
			DispBlueEnemy(inx, BLUEENEMYSLEEP5 + ((i >> 1) & 1));
		else if (o->phase < 174)
			DispBlueEnemy(inx, BLUEENEMYSLEEP5);
		else if (o->phase < 200)
			DispBlueEnemy(inx, BLUEENEMYLEFT1);
		else
			o->state = LEFT;
	}
}

// blue enemy move, phase 1
void BlueEnemyMove1()
{
	int inx, i, dif;
	sObj* o;

	for (inx = 0; inx < BlueEnemiesNum; inx++)
	{
		o = &BlueEnemies[inx];
		switch (o->state)
		{
		case CRASHED:
			o->phase++;
			if (o->phase >= 4)
			{
				ClearTileSign(BLUEENEMYCRASH, o->x, o->y);
				o->state = INVALID;
			}
			break;

		case INVALID:
			break;

		case SLEEPING:
			BlueEnemyDoSleep(inx, o);
			break;

		default:

			// difference to chicken
			dif = Chicken.x - o->x;

			// chicken is near
			if ((o->y == Chicken.y) && (dif > -11) && (dif < 11) && (Chicken.state >= LIVE))
			{
				// chicken is on right
				if (dif >= 0)
				{
					// follow chicken
					if ((dif < 6) || (RandomByte() <= 208))
						BlueEnemyTryRight(inx, o);
					else // or sometimes lost track
						BlueEnemyTryLeft(inx, o);
				}

				// chicken is on left
				else
				{
					// follow chicken
					if ((dif > -6) || (RandomByte() <= 208))
						BlueEnemyTryLeft(inx, o);
					else // or sometimes lost track
						BlueEnemyTryRight(inx, o);
				}
			}

			// or random move, preffer to stay in old direction
			else
			{
				if ((o->state == LEFT) || (o->state == LEFTMOVE))
				{
					if (RandomByte() <= 170)
						BlueEnemyTryLeft(inx, o);
					else
						BlueEnemyTryRight(inx, o);
				}
				else
				{
					if (RandomByte() <= 85)
						BlueEnemyTryLeft(inx, o);
					else
						BlueEnemyTryRight(inx, o);
				}
			}
			break;
		}
	}
}

// blue enemy move, phase 2
void BlueEnemyMove2()
{
	int inx, dif;
	sObj* o;

	for (inx = 0; inx < BlueEnemiesNum; inx++)
	{
		o = &BlueEnemies[inx];
		switch (o->state)
		{
		case CRASHED:
			break;

		case INVALID:
			break;

		case SLEEPING:
			BlueEnemyDoSleep(inx, o);
			break;

		// move left
		case LEFTMOVE:
			o->state = LEFT; // standing left
			DispBlueEnemy(inx, BLUEENEMYLEFT1); // display
			break;

		// move right
		case RIGHTMOVE:
			o->state = RIGHTMOVE; // moving right
			DispBlueEnemy(inx, BLUEENEMYRIGHT1); // display
			break;

		default:
			break;
		}
	}
}

// hit blue enemy (returns True if hit)
Bool BlueEnemyHit(sObj* o)
{
	if (o->state < LIVE) return False;

	u8 t = GetSign(o->x, o->y);
	if (ISBLUEENEMY(t))
	{
		sObj* o2 = &BlueEnemies[t & OBJINX_MASK];
		if (o2->state >= LIVE)
		{
			o2->state = SLEEPING;
			o2->phase = -1;
			o->state = INVALID; // destroy mushroom
			return True;
		}
	}
	return False;
}
