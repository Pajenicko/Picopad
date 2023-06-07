
// ****************************************************************************
//
//                                Movable objects
//
// ****************************************************************************

#include "../include.h"

// test move - get object on next step (direction UP, DOWN,...)
// Returned value:
//   SPACE ... can move (empty or mushroom)
//   CHICKEN ... chicken (full or part)
//   BLUEENEMY+inx or REDENEMY+inx ... whole enemy, with index
//   REDBALL+inx ... whole red ball, or vertically partially red ball
//   BLUEBALL ... whole blue ball (only horizontally)
//   WALL ... cannot move
u8 TestMove(u8 dir, u8 x, u8 y)
{
	// load tiles
	u8 t1, t2;
	switch (dir)
	{
	case UP:
		t1 = GetSign(x, y-1);
		t2 = GetSign(x+1, y-1);
		break;

	case DOWN:
		t1 = GetSign(x, y+2);
		t2 = GetSign(x+1, y+2);
		break;

	case LEFT:
		t1 = GetSign(x-1, y);
		t2 = GetSign(x-1, y+1);
		break;

	default: // RIGHT
		t1 = GetSign(x+2, y);
		t2 = GetSign(x+2, y+1);
		break;
	}

	// wall
	if (ISWALL(t1) || ISWALL(t2)) return WALL;

	// empty or mushroom
	if (ISEMPTY(t1) && ISEMPTY(t2)) return SPACE;

	// part of chicken
	if (ISCHICKEN(t1) || ISCHICKEN(t2)) return CHICKEN;

	// ball
	if (ISBALL(t1) || ISBALL(t2))
	{
		// horizontal - only full ball
		if ((dir == LEFT) || (dir == RIGHT))
		{
			if (t1 == t2) return t1;
			return WALL;
		}

		// vertically - one or more balls, not blue balls
		if (ISREDBALL(t1)) return t1;
		if (ISREDBALL(t2)) return t2;
		return WALL; // not blue ball
	} 

	// whole enemy
	if ((t1 == t2) && ISENEMY(t1)) return t1;

	// cannot pass
	return WALL;
}
