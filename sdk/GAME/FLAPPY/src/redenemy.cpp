
// ****************************************************************************
//
//                                 Red Enemies
//
// ****************************************************************************

#include "../include.h"

sObj RedEnemies[REDENEMIES_MAX]; // red enemies
int RedEnemiesNum; // initial number of red enemies (including dead)

// display red enemy
void DispRedEnemy(int inx, u8 tile)
{
	DispTileSign(tile, RedEnemies[inx].x, RedEnemies[inx].y, REDENEMY+inx);
}

// clear red enemy
void ClearRedEnemy(int inx, u8 tile)
{
	ClearTileSign(tile, RedEnemies[inx].x, RedEnemies[inx].y);
}

// crush red enemy by ball
void CrushRedEnemy(int inx)
{
	sObj* o = &RedEnemies[inx];
	if ((o->state != CRASHED) &&
		(o->state != INVALID))
	{
		if (o->state == UPMOVE)
			ClearRedEnemy(inx, REDENEMYUP2); // clear
		else if (o->state == DOWNMOVE)
			ClearRedEnemy(inx, REDENEMYDOWN2); // clear
		else if (o->state == LEFTMOVE)
			ClearRedEnemy(inx, REDENEMYLEFT2); // clear
		else if (o->state == RIGHTMOVE)
			ClearRedEnemy(inx, REDENEMYRIGHT2); // clear
		else
			ClearRedEnemy(inx, REDENEMYDOWN1);

		o->y += 1;
		DispRedEnemy(inx, REDENEMYCRASH);
		o->state = CRASHED;
		o->phase = 0;
		Score += 50;
		DispScore();
	}
}

// red enemy start move (rnd = randomize direction)
void RedEnemyDoMove(int inx, sObj* o, Bool rnd)
{
	// randomize direction
	if (rnd || (RandomByte() < 10) || (o->state < UP) || (o->state > RIGHT) || (Chicken.state < LIVE))
		o->state = UP + (RandomByte() & 3);

	// test move
	u8 t = TestMove(o->state, o->x, o->y);

	// eat chicken
	if (ISCHICKEN(t)) EatChicken();

	// can pass
	if (t == SPACE)
	{
		if (o->state == UP)
		{
			ClearRedEnemy(inx, REDENEMYUP1); // clear
			o->y--;
			o->state = UPMOVE; // standing up
			if ((o->y & 2) == 0)
				DispRedEnemy(inx, REDENEMYUP2); // display
			else
				DispRedEnemy(inx, REDENEMYUP3); // display
		}

		else if (o->state == DOWN)
		{
			ClearRedEnemy(inx, REDENEMYDOWN1); // clear
			o->state = DOWNMOVE; // standing down
			if ((o->y & 2) == 0)
				DispRedEnemy(inx, REDENEMYDOWN2); // display
			else
				DispRedEnemy(inx, REDENEMYDOWN3); // display
		}

		else if (o->state == LEFT)
		{
			ClearRedEnemy(inx, REDENEMYLEFT1); // clear
			o->x--;
			o->state = LEFTMOVE; // standing left
			DispRedEnemy(inx, REDENEMYLEFT2); // display
		}

		else // RIGHT
		{
			ClearRedEnemy(inx, REDENEMYRIGHT1); // clear
			o->state = RIGHTMOVE; // standing right
			DispRedEnemy(inx, REDENEMYRIGHT2); // display
		}
	}

	// cannot pass, stop
	else
		o->state = LIVE;
}

// continue left or right
void RedEnemyLeftRight(int inx, sObj* o)
{
	u8 t;

	// go left
	if (Chicken.x < o->x)
	{
		t = TestMove(LEFT, o->x, o->y);
		if ((ISCHICKEN(t) && (Chicken.state >= LIVE)) || (t == SPACE)) o->state = LEFT;
	}

	// go right
	if (Chicken.x >= o->x)
	{
		t = TestMove(RIGHT, o->x, o->y);
		if ((ISCHICKEN(t) && (Chicken.state >= LIVE)) || (t == SPACE)) o->state = RIGHT;
	}

	// do move
	RedEnemyDoMove(inx, o, False);
}

// continue up or down
void RedEnemyUpDown(int inx, sObj* o)
{
	u8 t;

	// go up
	if (Chicken.y < o->y)
	{
		t = TestMove(UP, o->x, o->y);
		if ((ISCHICKEN(t) && (Chicken.state >= LIVE)) || (t == SPACE)) o->state = UP;
	}

	// go down
	if (Chicken.y >= o->y)
	{
		t = TestMove(DOWN, o->x, o->y);
		if ((ISCHICKEN(t) && (Chicken.state >= LIVE)) || (t == SPACE)) o->state = DOWN;
	}

	// do move
	RedEnemyDoMove(inx, o, False);
}

// red enemy sleeping
void RedEnemyDoSleep(int inx, sObj* o)
{
	o->phase++;
	if (o->phase < 5)		
		DispRedEnemy(inx, REDENEMYSLEEP1 + o->phase); // phase 0, 1, 2, 3, 4
	else
	{
		int i = (o->phase >> 4) & 0x0f;
		if (i <= 10)
			DispRedEnemy(inx, REDENEMYSLEEP5 + ((i >> 1) & 1));
		else if (o->phase < 200)
			DispRedEnemy(inx, REDENEMYDOWN1);
		else
			o->state = DOWN;
	}
}

// red enemy move, phase 1
void RedEnemyMove1()
{
	int inx, dif;
	sObj* o;

	for (inx = 0; inx < RedEnemiesNum; inx++)
	{
		o = &RedEnemies[inx];
		switch (o->state)
		{
		case CRASHED:
			o->phase++;
			if (o->phase >= 4)
			{
				ClearTileSign(REDENEMYCRASH, o->x, o->y);
				o->state = INVALID;
			}
			break;

		case INVALID:
			break;

		case SLEEPING:
			RedEnemyDoSleep(inx, o);
			break;

		default:

			// random new direction
			if ((o->state < UP) || (o->state > RIGHT) || (Chicken.state < LIVE)) // unknown last direction
				o->state = UP + (RandomByte() & 3);

			// current direction is left or right
			if ((o->state == LEFT) || (o->state == RIGHT))
			{
				// same Y as chicken, bypass the chicken
				if (o->y == Chicken.y)
				{
					dif = Chicken.x - o->x; // difference X
					if (dif < 0) dif = -dif;
					u8 lim = (dif >= 6) ? 16 : 8;
					if (RandomByte() < lim)
						RedEnemyDoMove(inx, o, True); // continue in this direction
					else
						RedEnemyLeftRight(inx, o); // continue left or right
				}

				// else continue up or down
				else
					RedEnemyUpDown(inx, o);
			}

			// current direction is up or down
			else 
			{
				// same X as chicken, bypass the chicken
				if (o->x == Chicken.x)
				{
					dif = Chicken.y - o->y; // difference Y
					if (dif < 0) dif = -dif;
					u8 lim = (dif >= 6) ? 16 : 8;
					if (RandomByte() < lim)
						RedEnemyDoMove(inx, o, True); // continue in this direction
					else
						RedEnemyUpDown(inx, o); // continue up or down
				}

				// else continue left or right
				else
					RedEnemyLeftRight(inx, o);
			}
			break;
		}
	}
}

// red enemy move, phase 2
void RedEnemyMove2()
{
	int inx;
	sObj* o;

	for (inx = 0; inx < RedEnemiesNum; inx++)
	{
		o = &RedEnemies[inx];
		switch (o->state)
		{
		case CRASHED:
			break;

		case INVALID:
			break;

		case SLEEPING:
			RedEnemyDoSleep(inx, o);
			break;

		// move up
		case UPMOVE:
			ClearRedEnemy(inx, REDENEMYUP2); // clear
			o->state = UP; // standing up
			DispRedEnemy(inx, REDENEMYUP1); // display
			break;

		// move down
		case DOWNMOVE:
			ClearRedEnemy(inx, REDENEMYDOWN2); // clear
			o->y++; // shift coordinate
			o->state = DOWN; // standing down
			DispRedEnemy(inx, REDENEMYDOWN1); // display
			break;

		// move left
		case LEFTMOVE:
			ClearRedEnemy(inx, REDENEMYLEFT2); // clear
			o->state = LEFT; // standing left
			DispRedEnemy(inx, REDENEMYLEFT1); // display
			break;

		// move right
		case RIGHTMOVE:
			ClearRedEnemy(inx, REDENEMYRIGHT2); // clear
			o->x++; // shift coordinate
			o->state = RIGHT; // standing right
			DispRedEnemy(inx, REDENEMYRIGHT1); // display
			break;
		}
	}
}

// hit red enemy (returns True if hit)
Bool RedEnemyHit(sObj* o)
{
	if (o->state < LIVE) return False;

	u8 t = GetSign(o->x, o->y);
	if (ISREDENEMY(t))
	{
		int inx = t & OBJINX_MASK;
		sObj* o2 = &RedEnemies[inx];
		if (o2->state >= LIVE)
		{
			if ((o2->state == UPMOVE) || (o2->state == DOWNMOVE))
				ClearRedEnemy(inx, REDENEMYUP2); // clear
			else if ((o2->state == LEFTMOVE) || (o2->state == RIGHTMOVE))
				ClearRedEnemy(inx, REDENEMYLEFT2); // clear

			o2->state = SLEEPING;
			o2->phase = -1;
			o->state = INVALID; // destroy mushroom
			return True;
		}
	}
	return False;
}

// hit blue or red enemy (returns True if hit)
Bool EnemyHit(sObj* o)
{
	return BlueEnemyHit(o) || RedEnemyHit(o);
}
