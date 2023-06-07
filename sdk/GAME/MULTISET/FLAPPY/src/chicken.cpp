
// ****************************************************************************
//
//                                 Chicken
//
// ****************************************************************************
// All coordinates are in multiply of "STEP", relative to start of game map.

#include "../include.h"

// chicken
sObj Chicken;
int Lives;		// number of remaining lives

// display lives
void DispLives()
{
	int i;
	int n = Lives;
	if (n > 5) n = 5;
	for (i = 0; i < n; i++) DispTile(CHICKENDOWN1, 1+2*i, -2);
	for (; i < 5; i++) ClearTile(CHICKENDOWN1, 1+2*i, -2);
}

// display chicken
void DispChicken(u8 tile)
{
	DispTileSign(tile, Chicken.x, Chicken.y, CHICKEN);
}

// clear chicken
void ClearChicken()
{
	ClearTileSign(CHICKENDOWN1, Chicken.x, Chicken.y);
}

// crush chicken by ball
void CrushChicken()
{
	if ((Chicken.state != CRASHED) &&
		(Chicken.state != EATEN) &&
		(Chicken.state != INVALID))
	{
		ClearChicken();
		Chicken.y += 1;
		DispChicken(CHICKENCRASH);
		Chicken.state = CRASHED;
		Chicken.phase = 0;
		Lives--;
	}
}

// eat chicken by enemy
void EatChicken()
{
	if ((Chicken.state != CRASHED) &&
		(Chicken.state != EATEN) &&
		(Chicken.state != INVALID))
	{
		ClearChicken();
		Chicken.y += 1;
		DispChicken(CHICKENEATEN1);
		Chicken.state = EATEN;
		Chicken.phase = 0;
		Lives--;
	}
}

// chicken start move left
void ChickenMove1Left()
{
	ClearChicken(); // clear chicken
	Chicken.x--; // shift coordinate
	Chicken.state = LEFTMOVE; // moving left
	DispChicken(CHICKENLEFT2); // display chicken
}

// chicken start move right
void ChickenMove1Right()
{
	ClearChicken(); // clear chicken
	Chicken.x++; // shift coordinate
	Chicken.state = RIGHTMOVE; // moving right
	DispChicken(CHICKENRIGHT2); // display chicken
}

// chicken start move down
void ChickenMove1Down()
{
	ClearChicken(); // clear chicken
	Chicken.y++;
	Chicken.state = DOWNMOVE; // moving down
	if ((Chicken.y & 2) == 0)
		DispChicken(CHICKENDOWN2); // display chicken
	else
		DispChicken(CHICKENDOWN3); // display chicken
}

// chicken start move up
void ChickenMove1Up()
{
	Chicken.state = UPMOVE; // moving up
	if ((Chicken.y & 2) == 0)
		DispChicken(CHICKENUP2); // display chicken
	else
		DispChicken(CHICKENUP3); // display chicken
}

// chicken move, phase 1
void ChickenMove1()
{
	u8 t, t1, t2;
	char ch;

	// new direction
	int dir = 0;
	if (KeyPressed(KEY_UP)) dir = UP;
	if (KeyPressed(KEY_DOWN)) dir = DOWN;
	if (KeyPressed(KEY_LEFT)) dir = LEFT;
	if (KeyPressed(KEY_RIGHT)) dir = RIGHT;

	// macro, prepare repeater and character
	if ((Macro != NULL) && (MacroRep == 0))
	{
		do ch = *Macro++; while (ch == ' ');
		if (ch != 0)
		{
			if ((ch >= '0') && (ch <= '9'))
			{
				MacroRep = ch - '0';
				if (MacroRep == 0) MacroRep = 10;
				if (MacroRep == 1) MacroRep = 11;
				if (MacroRep == 2) MacroRep = 12;
				do ch = *Macro++; while (ch == ' ');
			}
			else
				MacroRep = 1;

			if (ch != 0)
			{
				MacroCh = ch;
			}
			else
			{
				Macro = NULL;
				MacroRep = 0;
			}
		}
		else
			Macro = NULL;
	}

	// parse next macro character
	if ((MacroRep != 0) && ((Chicken.state < UPFIRE) || (Chicken.state > RIGHTFIRE)))
	{
		MacroRep--;

		switch (MacroCh)
		{
		// up
		case 'U':
		case 'u':
			dir = UP;
			break;

		// down
		case 'D':
		case 'd':
			dir = DOWN;
			break;

		// left
		case 'L':
		case 'l':
			dir = LEFT;
			break;

		// right
		case 'R':
		case 'r':
			dir = RIGHT;
			break;

		// wait
		case 'W':
		case 'w':
			dir = 0;
			break;

		// shoot
		case 'X':
		case 'x':
			dir = 0;
			MacroRep++;
			break;
		}
	}

	// current coordinate
	u8 x = Chicken.x;
	u8 y = Chicken.y;

	switch (Chicken.state)
	{
	case CRASHED:
		Chicken.phase++;
		break;

	case EATEN:
		Chicken.phase++;
		if (Chicken.phase < 20) DispChicken(CHICKENEATEN1);
		break;

	case INVALID:
		break;

	case UPFIRE:
		DispChicken(CHICKENUPFIRE2);
		break;

	case DOWNFIRE:
		DispChicken(CHICKENDOWNFIRE2);
		break;

	case LEFTFIRE:
		DispChicken(CHICKENLEFTFIRE2);
		break;

	case RIGHTFIRE:
		DispChicken(CHICKENRIGHTFIRE2);
		break;

	default:

		// try to move
		switch (dir)
		{

		// try to move up
		case UP:
			// get object on up
			t = TestMove(UP, x, y);

			// passable
			if (t == SPACE)
			{
				// chicken move up
				ChickenMove1Up();
			}

			// red ball
			else if (ISREDBALL(t))
			{
				// crash balls
				t1 = GetSign(x, y-1);
				t2 = GetSign(x+1, y-1);

				if (ISREDBALL(t1)) CrashBall(t1);
				if (ISREDBALL(t2)) CrashBall(t2);
				Chicken.state = UP;
			}

			// sleeping red enemy
			else if (ISREDENEMY(t))
			{
				sObj* o = &RedEnemies[t & OBJINX_MASK];

				// check if enemy can move
				t2 = TestMove(UP, x, y-2);

				// passable, move enemy up
				if ((o->state == SLEEPING) && (t2 == SPACE))
				{
					// clear enemy on old position
					ClearTileSign(REDENEMYSLEEP5, x, y-2);

					// shift enemy coordinate
					o->y--;

					// display enemy on new position
					DispTileSign(REDENEMYSLEEP5, x, y-3, t);

					// chicken move up
					ChickenMove1Up();
				}
				else
					// stop
					Chicken.state = UP;
			}

			// cannot pass
			else
				Chicken.state = UP;

			break;

		// try to move down
		case DOWN:

			// get object on down
			t = TestMove(DOWN, x, y);

			// passable
			if (t == SPACE)
			{
				// chicken move down
				ChickenMove1Down();
			}

			// red ball
			else if (ISREDBALL(t))
			{
				// crash balls
				t1 = GetSign(x, y+2);
				t2 = GetSign(x+1, y+2);

				if (ISREDBALL(t1)) CrashBall(t1);
				if (ISREDBALL(t2)) CrashBall(t2);
				Chicken.state = DOWN;
			}

			// sleeping red enemy
			else if (ISREDENEMY(t))
			{
				sObj* o = &RedEnemies[t & OBJINX_MASK];

				// check if enemy can move
				t2 = TestMove(DOWN, x, y+2);

				// passable, move enemy up
				if ((o->state == SLEEPING) && (t2 == SPACE))
				{
					// clear enemy on old position
					ClearTileSign(REDENEMYSLEEP5, x, y+2);

					// shift enemy coordinate
					o->y++;

					// display enemy on new position
					DispTileSign(REDENEMYSLEEP5, x, y+3, t);

					// chicken move up
					ChickenMove1Down();
				}
				else
					// stop
					Chicken.state = DOWN;
			}

			// cannot pass
			else
				Chicken.state = DOWN;

			break;

		// try to move left
		case LEFT:

			// get object on left
			t = TestMove(LEFT, x, y);

			// passable
			if (t == SPACE)
			{
				// chicken move left
				ChickenMove1Left();
			}

			// red ball
			else if (ISREDBALL(t))
			{
				// check if ball will crash
				t2 = TestMove(LEFT, x-2, y);

				// passable, move ball left
				if (t2 == SPACE)
				{
					// clear ball on old position
					ClearTileSign(REDBALLTILE, x-2, y);

					// shift ball coordinate
					RedBalls[t & OBJINX_MASK].x--;

					// display ball on new position
					DispTileSign(REDBALLTILE, x-3, y, t);

					// chicken move left
					ChickenMove1Left();
				}

				// destroys ball
				else
				{
					CrashBall(t);
					Chicken.state = LEFT;
				}
			}

			// blue ball
			else if (ISBLUEBALL(t))
			{
				// check if ball can move
				t2 = TestMove(LEFT, x-2, y);

				// passable, move ball left
				if (t2 == SPACE)
				{
					// clear ball on old position
					ClearTileSign(BLUEBALLTILE, x-2, y);

					// shift ball coordinate
					BlueBall.x--;

					// display ball on new position
					DispTileSign(BLUEBALLTILE, x-3, y, t);

					// chicken move left
					ChickenMove1Left();
				}
				else
					// stop
					Chicken.state = LEFT;
			}

			// sleeping blue enemy
			else if (ISBLUEENEMY(t))
			{
				sObj* o = &BlueEnemies[t & OBJINX_MASK];

				// check if enemy can move
				t2 = TestMove(LEFT, x-2, y);

				// passable, move enemy left
				if ((o->state == SLEEPING) && (t2 == SPACE))
				{
					// clear enemy on old position
					ClearTileSign(BLUEENEMYSLEEP5, x-2, y);

					// shift enemy coordinate
					o->x--;

					// display enemy on new position
					DispTileSign(BLUEENEMYSLEEP5, x-3, y, t);

					// chicken move left
					ChickenMove1Left();
				}
				else
					// stop
					Chicken.state = LEFT;
			}

			// sleeping red enemy
			else if (ISREDENEMY(t))
			{
				sObj* o = &RedEnemies[t & OBJINX_MASK];

				// check if enemy can move
				t2 = TestMove(LEFT, x-2, y);

				// passable, move enemy left
				if ((o->state == SLEEPING) && (t2 == SPACE))
				{
					// clear enemy on old position
					ClearTileSign(REDENEMYSLEEP5, x-2, y);

					// shift enemy coordinate
					o->x--;

					// display enemy on new position
					DispTileSign(REDENEMYSLEEP5, x-3, y, t);

					// chicken move left
					ChickenMove1Left();
				}
				else
					// stop
					Chicken.state = LEFT;
			}

			// cannot pass
			else
				Chicken.state = LEFT;

			break;

		// try to move right
		case RIGHT:

			// get object on right
			t = TestMove(RIGHT, x, y);

			// passable
			if (t == SPACE)
			{
				// chicken move right
				ChickenMove1Right();
			}

			// red ball
			else if (ISREDBALL(t))
			{
				// check if ball will crash
				t2 = TestMove(RIGHT, x+2, y);

				// passable, move ball left
				if (t2 == SPACE)
				{
					// clear ball on old position
					ClearTileSign(REDBALLTILE, x+2, y);

					// shift ball coordinate
					RedBalls[t & OBJINX_MASK].x++;

					// display ball on new position
					DispTileSign(REDBALLTILE, x+3, y, t);

					// chicken move right
					ChickenMove1Right();
				}

				// destroys ball
				else
				{
					CrashBall(t);
					Chicken.state = RIGHT;
				}
			}

			// blue ball
			else if (ISBLUEBALL(t))
			{
				// check if ball can move
				t2 = TestMove(RIGHT, x+2, y);

				// passable, move ball left
				if (t2 == SPACE)
				{
					// clear ball on old position
					ClearTileSign(BLUEBALLTILE, x+2, y);

					// shift ball coordinate
					BlueBall.x++;

					// display ball on new position
					DispTileSign(BLUEBALLTILE, x+3, y, t);

					// chicken move right
					ChickenMove1Right();
				}

				// cannot pass
				else
					Chicken.state = RIGHT;
			}

			// sleeping blue enemy
			else if (ISBLUEENEMY(t))
			{
				sObj* o = &BlueEnemies[t & OBJINX_MASK];

				// check if enemy can move
				t2 = TestMove(RIGHT, x+2, y);

				// passable, move enemy left
				if ((o->state == SLEEPING) && (t2 == SPACE))
				{
					// clear enemy on old position
					ClearTileSign(BLUEENEMYSLEEP5, x+2, y);

					// shift enemy coordinate
					o->x++;

					// display enemy on new position
					DispTileSign(BLUEENEMYSLEEP5, x+3, y, t);

					// chicken move right
					ChickenMove1Right();
				}
				else
					// stop
					Chicken.state = RIGHT;
			}

			// sleeping red enemy
			else if (ISREDENEMY(t))
			{
				sObj* o = &RedEnemies[t & OBJINX_MASK];

				// check if enemy can move
				t2 = TestMove(RIGHT, x+2, y);

				// passable, move enemy left
				if ((o->state == SLEEPING) && (t2 == SPACE))
				{
					// clear enemy on old position
					ClearTileSign(REDENEMYSLEEP5, x+2, y);

					// shift enemy coordinate
					o->x++;

					// display enemy on new position
					DispTileSign(REDENEMYSLEEP5, x+3, y, t);

					// chicken move right
					ChickenMove1Right();
				}
				else
					// stop
					Chicken.state = RIGHT;
			}

			// cannot pass
			else
				Chicken.state = RIGHT;

			break;

		// standing
		default:

			break;
		}
		break;
	}
}

// chicken move, phase 2
void ChickenMove2()
{
	switch (Chicken.state)
	{
	case CRASHED:
		break;

	case EATEN:
		DispChicken(CHICKENEATEN2);
		break;

	case INVALID:
		break;

	// move up
	case UPMOVE:
		ClearChicken(); // clear chicken
		Chicken.y--; // shift coordinate
	case UPFIRE:
		Chicken.state = UP; // standing up
		DispChicken(CHICKENUP1); // display chicken
		break;

	// move down
	case DOWNMOVE:
	case DOWNFIRE:
		Chicken.state = DOWN; // standing down
		DispChicken(CHICKENDOWN1); // display chicken
		break;

	// move left
	case LEFTFIRE:
	case LEFTMOVE:
		Chicken.state = LEFT; // standing left
		DispChicken(CHICKENLEFT1); // display chicken
		break;

	// move right
	case RIGHTFIRE:
	case RIGHTMOVE:
		Chicken.state = RIGHT; // standing right
		DispChicken(CHICKENRIGHT1); // display chicken
		break;

	default:
		break;
	}
}

// fire mushroom (must be after phase 2 of chicken move)
void FireMushroom()
{
	sObj* o;
	int i;

	// check if fire next mushroom
	if ((MushroomsStock == 0) || (Chicken.state < UP) || (Chicken.state > RIGHT)) return;

	// keyboard or macro shoot
	Bool shoot = KeyPressed(KEY_A);
	if ((MacroRep != 0) && ((MacroCh == 'X') || (MacroCh == 'x')))
	{
		MacroRep--;
		shoot = True;
	}

	// check if fire next mushroom
	if (shoot)
	{
		// decrease number of mushrooms in the stock
		MushroomsStock--;
		DispMushrooms(); // display new stock

		// open new mushroom
		for (i = 0; i < MushroomsNum; i++)
		{
			o = &Mushrooms[i];
			if (o->state == INVALID)
			{
				switch (Chicken.state)
				{
				case UP:
					o->state = UPMOVE;
					o->x = Chicken.x + 1;
					o->y = Chicken.y - 1  +1;
					o->phase = 6  +1;

					Chicken.state = UPFIRE;
					DispChicken(CHICKENUPFIRE1);
					break;

				case DOWN:
					o->state = DOWNMOVE;
					o->x = Chicken.x;
					o->y = Chicken.y + 2  -1;
					o->phase = 0  +1;

					Chicken.state = DOWNFIRE;
					DispChicken(CHICKENDOWNFIRE1);
					break;

				case LEFT:
					o->state = LEFTMOVE;
					o->x = Chicken.x - 1  +1;
					o->y = Chicken.y;
					o->phase = 15  +1;

					Chicken.state = LEFTFIRE;
					DispChicken(CHICKENLEFTFIRE1);
					break;

				default: // RIGHT
					o->state = RIGHTMOVE;
					o->x = Chicken.x + 2  -1;
					o->y = Chicken.y;
					o->phase = 15  +1;

					Chicken.state = RIGHTFIRE;
					DispChicken(CHICKENRIGHTFIRE1);
					break;
				}
				break;
			}
		}
	}
}
