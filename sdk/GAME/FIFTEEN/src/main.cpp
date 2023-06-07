
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// game board
u8 Board[TILESNUM]; // visible board
u8 BoardSave[TILESNUM]; // saved board during demo
u8 Pos[TILESNUM]; // positions of tiles (including hole)
u8 PosErr; // number of tiles on incorrect position
Bool Locked[TILESNUM]; // solved groups: locked tiles
Bool Solved[TILESNUM]; // solved groups: tiles to solve
int Dist; // current distance of numeric tiles from result position (0 = result is OK)

#define PREDEPTH_MAX 14 // max. depth of pre-solver (must be <= DEPTH_MAX)
#define DEPTH_MAX 17 // max. depth of solver (real depth is max. 19)
s8 Moves[DEPTH_MAX]; // moves
int MovesNum;	// number of moves
int DepthMax;	// current max. depth

s8 BestMoves[DEPTH_MAX]; // best moves
int BestMovesNum;	// number of best moves
int BestDist;	// distance of best moves

#define Hole Pos[TILE_EMPTY] // position of hole

// get hole X coordinate
INLINE u8 HoleX() { return Hole & 3; }

// get hole Y coordinate
INLINE u8 HoleY() { return Hole >> 2; }

// check goal state
INLINE Bool Check() { return PosErr == 0; }

// solved group table: number of tiles (0 = end mark), list of tiles 1..
const u8 SolverTab[] = {
	1, 1,
	1, 2,
	1, 5,
	1, 6,
	2, 3, 4,
	2, 7, 8,
	2, 9, 13,
	2, 10, 14,
	3, 11, 12, 15,
	0
};

// draw board
void DrawBoard()
{
	int i, j, x, y, b;
	for (i = 0; i < TILESY; i++)
	{
		for (j = 0; j < TILESX; j++)
		{
			b = Board[i*TILESX + j];
			x = j*TILEW+BOARDX;
			y = i*TILEH+BOARDY;
			DrawImg4Pal(TilesImg, TilesImg_Pal, 0, b*TILEH, x, y, TILEW, TILEH, TILEW);
		}
	}
	DispUpdate();
}

// wait icon ON
void WaitOn()
{
	int x = HoleX()*TILEW+BOARDX;
	int y = HoleY()*TILEH+BOARDY;
	DrawImg4Pal(TilesImg, TilesImg_Pal, 0, TILE_WAIT*TILEH, x, y, TILEW, TILEH, TILEW);
	DispUpdate();
}

// wait icon ON 2
void WaitOn2()
{
	int x = HoleX()*TILEW+BOARDX;
	int y = HoleY()*TILEH+BOARDY;
	DrawImg4Pal(TilesImg, TilesImg_Pal, 0, TILE_WAIT2*TILEH, x, y, TILEW, TILEH, TILEW);
	DispUpdate();
}

// wait icon OFF
void WaitOff()
{
	int x = HoleX()*TILEW+BOARDX;
	int y = HoleY()*TILEH+BOARDY;
	DrawImg4Pal(TilesImg, TilesImg_Pal, 0, TILE_EMPTY*TILEH, x, y, TILEW, TILEH, TILEW);
	DispUpdate();
}

// calculate position error
void CalcPos()
{
	int i, x, y, err, dist;
	u8 b;
	err = 0;
	dist = 0;
	for (i = 0; i < TILESNUM; i++)
	{
		b = Board[i];
		if (b != TILE_EMPTY)
		{
			if (Solved[b] && (b != (u8)i)) err++;
			x = (i & 3) - (b & 3);
			y = (i >> 2) - (b >> 2);
			if (Solved[b])
			{
				x *= 4;
				y *= 4;
			}
			dist += x*x + y*y;
		}
		Pos[b] = i;
	}
	PosErr = err;
	Dist = dist;
}

// shift hole (-4, -1, +1, +4), without checking coordinates
void Shift(s8 shift)
{
	int x, y;

	// old index of the hole (= tile new index)
	u8 oldinx = Hole;

	// new index of the hole (= tile old index)
	u8 newinx = oldinx + shift;

	// get tile
	u8 b = Board[newinx];
	if ((b == newinx) && Solved[b]) PosErr++;
	x = (b & 3) - (newinx & 3);
	y = (b >> 2) - (newinx >> 2);
	if (Solved[b])
	{
		x *= 4;
		y *= 4;
	}
	Dist -= x*x + y*y;

	// move tile
	Board[oldinx] = b;
	if ((b == oldinx) && Solved[b]) PosErr--;
	x = (b & 3) - (oldinx & 3);
	y = (b >> 2) - (oldinx >> 2);
	if (Solved[b])
	{
		x *= 4;
		y *= 4;
	}
	Dist += x*x + y*y;
	Pos[b] = oldinx;

	// set hole
	Board[newinx] = TILE_EMPTY;
	Hole = newinx;
}

// initialize new game
void NewGame(Bool shuffle)
{
	int i;
	u8 r;

	// clear screen
	DrawClear(COL_BLACK);

	// initialize new state
	for (i = 0; i < TILESNUM; i++)
	{
		Locked[i] = False;
		Solved[i] = True;
		Board[i] = i;
		Pos[i] = i;
	}
	Dist = 0;
	PosErr = 0;

	// shuffle
	if (shuffle)
	{
		// start shuffling sound
		PLAYSOUNDREP(ShufflingSnd);

		// shuffle board (2 seconds)
		for (i = 4000; i > 0; i--)
		{
			r = RandU8();
			if (r >= 0x80) // shift in X direction
			{
				if ((r & 1) == 0)
				{
					// shift hole left
					if (HoleX() > 0) Shift(-1);
				}
				else
				{
					// shift hole right
					if (HoleX() < TILESX-1) Shift(1);
				}
			}
			else // shift in Y direction
			{
				if ((r & 1) == 0)
				{
					// shift hole up
					if (HoleY() > 0) Shift(-TILESX);
				}
				else
				{
					// shift hole down
					if (HoleY() < TILESY-1) Shift(TILESX);
				}
			}

			// draw board
			if ((i & 0x7f) == 0) DrawBoard();
		}

		// stop shuffling sound
		StopSound();

		// flush keyboard
		KeyFlush();
	}

	// draw resulting state
	DrawBoard();
}

// pre-solve 1 level
void PreSolve1()
{
	// completed
	if (Dist == 0) return;

	// copy better solution
	if ((Dist < BestDist) || ((Dist == BestDist) && (MovesNum < BestMovesNum)))
	{
		memcpy(BestMoves, Moves, MovesNum);
		BestMovesNum = MovesNum;
		BestDist = Dist;
	}

	// check max. depth
	int movesnum = MovesNum;
	if (movesnum >= DepthMax) return;
	MovesNum = movesnum+1;

	// shift hole left
	if ((HoleX() > 0) && !Locked[Board[Hole - 1]])
	{
		Shift(-1);
		Moves[movesnum] = -1;
		PreSolve1();
		Shift(1);
	}

	// shift hole right
	if ((HoleX() < TILESX-1) && !Locked[Board[Hole + 1]])
	{
		Shift(1);
		Moves[movesnum] = 1;
		PreSolve1();
		Shift(-1);
	}

	// shift hole up
	if ((HoleY() > 0) && !Locked[Board[Hole - TILESX]])
	{
		Shift(-TILESX);
		Moves[movesnum] = -TILESX;
		PreSolve1();
		Shift(TILESX);
	}

	// shift hole down
	if ((HoleY() < TILESY-1) && !Locked[Board[Hole + TILESX]])
	{
		Shift(TILESX);
		Moves[movesnum] = TILESX;
		PreSolve1();
		Shift(-TILESX);
	}

	// return number of moves
	MovesNum = movesnum;
}

// solve 1 level (returns True to completed)
Bool Solve1()
{
	Bool res;

	// completed
	if (PosErr == 0) return True;

	// check max. depth
	int movesnum = MovesNum;
	if (movesnum >= DepthMax) return False;
	MovesNum = movesnum+1;

	// shift hole left
	if ((HoleX() > 0) && !Locked[Board[Hole - 1]])
	{
		Shift(-1);
		Moves[movesnum] = -1;
		res = Solve1();
		Shift(1);
		if (res) return True;
	}

	// shift hole right
	if ((HoleX() < TILESX-1) && !Locked[Board[Hole + 1]])
	{
		Shift(1);
		Moves[movesnum] = 1;
		res = Solve1();
		Shift(-1);
		if (res) return True;
	}

	// shift hole up
	if ((HoleY() > 0) && !Locked[Board[Hole - TILESX]])
	{
		Shift(-TILESX);
		Moves[movesnum] = -TILESX;
		res = Solve1();
		Shift(TILESX);
		if (res) return True;
	}

	// shift hole down
	if ((HoleY() < TILESY-1) && !Locked[Board[Hole + TILESX]])
	{
		Shift(TILESX);
		Moves[movesnum] = TILESX;
		res = Solve1();
		Shift(-TILESX);
		if (res) return True;
	}

	// return number of moves
	MovesNum = movesnum;

	return False;
}

// solver
void Solver()
{
	Bool ok;
	const u8* t = SolverTab;
	int i, j;
	int faster1 = 7; // speed-up pre-solver
	int faster2 = 10; // speed-up solver
	Bool err;

	// clear solved group tabled
	for (i = 0; i < TILESNUM; i++)
	{
		Locked[i] = False;
		Solved[i] = False;
	}

	while (True)
	{
		// prepare next solved group
		MovesNum = 0;
		for (i = 0; i < TILESNUM; i++)
		{
			if (Solved[i]) Locked[i] = True; // lock already solved tiles
		}

		// update positions
		i = *t++; // number of tiles of next solved group
		if (i == 0) break; // end of table
		for (; i > 0; i--) Solved[*t++ - 1] = True;
		CalcPos();

PRE_AGAIN:
		// pre-solver
		err = True;
		WaitOn();

		// pre-solve
		BestMovesNum = 0;
		BestDist = Dist;
		DepthMax = PREDEPTH_MAX - faster1;
		PreSolve1();

		// play moves
		if (BestMovesNum > 0)
		{
			WaitOff();
			for (i = 0; i < BestMovesNum; i++)
			{
				// shift tile
				Shift(BestMoves[i]);
				PLAYSOUND(MoveSnd);
				DrawBoard();

				// wait some time
				WaitMs(100);
				if (KeyGet() != NOKEY) return;
				WaitMs(100);
				if (KeyGet() != NOKEY) return;
			}
			WaitOn();
			err = False;

			// found some solution, so slower solver
			if (faster2 < 10) faster2++;
		}

		// quit
		if (KeyGet() != NOKEY) return;

		// solver
		WaitOn2();
		DepthMax = 0;
		do {
			DepthMax++;
			ok = Solve1();
		} while (!ok && (DepthMax < DEPTH_MAX - faster2));

		// not found, slower down all and repeat all again
		if (!ok && !Check())
		{
			if (err && (faster1 > 0)) faster1--;
			if (err && (faster2 > 0)) faster2--;
			goto PRE_AGAIN; // not found, try pre-solver again
		}

		// play moves
		if (MovesNum > 0)
		{
			WaitOff();
			for (i = 0; i < MovesNum; i++)
			{
				// shift tile
				Shift(Moves[i]);
				PLAYSOUND(MoveSnd);
				DrawBoard();

				// wait some time
				WaitMs(100);
				if (KeyGet() != NOKEY) return;
				WaitMs(100);
				if (KeyGet() != NOKEY) return;
			}
			WaitOn2();
			err = False;

			// found some solution, so slower pre-solver
			if (faster1 < 7) faster1++;
		}

		// error of pre-solver and solver, slower down all
		if (err && (faster1 > 0)) faster1--;
		if (err && (faster2 > 0)) faster2--;
	}

	// initialize new state
	for (i = 0; i < TILESNUM; i++)
	{
		Locked[i] = False;
		Solved[i] = True;
	}
	WaitOff();
	CalcPos();
	DrawBoard();
}

// main function
int main()
{
	int i;

	// new game
	NewGame(True);

	// game loop
	while (True)
	{
		// key
		switch(KeyGet())
		{
		// right
		case KEY_RIGHT:
			if (HoleX() > 0)
			{
				Shift(-1);
				PLAYSOUND(MoveSnd);
				DrawBoard();
			}
			else
				PLAYSOUND(BumpSnd);
			break;

		// left
		case KEY_LEFT:
			if (HoleX() < TILESX-1)
			{
				Shift(1);
				PLAYSOUND(MoveSnd);
				DrawBoard();
			}
			else
				PLAYSOUND(BumpSnd);
			break;

		// up
		case KEY_UP:
			if (HoleY() < TILESY-1)
			{
				Shift(TILESX);
				PLAYSOUND(MoveSnd);
				DrawBoard();
			}
			else
				PLAYSOUND(BumpSnd);
			break;

		// down
		case KEY_DOWN:
			if (HoleY() > 0)
			{
				Shift(-TILESX);
				PLAYSOUND(MoveSnd);
				DrawBoard();
			}
			else
				PLAYSOUND(BumpSnd);
			break;

		// new game
		case KEY_A:
			NewGame(True);
			break;

		// solver
		case KEY_X:
#if USE_SCREENSHOT		// use screen shots
			ScreenShot();
#endif
			Solver();

			for (i = 0; i < TILESNUM; i++)
			{
				Locked[i] = False;
				Solved[i] = True;
			}
			CalcPos();
			break;

		case KEY_Y: ResetToBootLoader();
		}

		// check solution
		if (Check())
		{
			// play fanfare
			PLAYSOUND(FanfareSnd);

			// winning animation
			for (i = 4; i > 0; i--)
			{
				WaitMs(150);
				DrawClear(COL_BLACK);
				DispUpdate();
				WaitMs(150);
				DrawBoard();
			}

			// flush keyboard
			KeyFlush();

			// wait for a key
			while (KeyGet() == NOKEY) {}

			// start new game
			NewGame(True);
		}
	}
}
