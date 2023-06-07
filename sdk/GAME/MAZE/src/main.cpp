
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// "wave" maze generator: https://www.itnetwork.cz/navrh/algoritmy/algoritmy-bludiste/algoritmus-tvorba-nahodneho-bludiste
// - MAZEW and MAZEH must be odd numbers!

#include "../include.h"

// game board
u8 Board[MAPSIZE];

// board address
#define BoardAddr(x, y) (&Board[(x) + (y)*MAPW])

u8 StopX, StopY; // stop position
u8 PosX, PosY;	// current position
u8 Anim;	// animation phase

// direction
#define	L 0	// left
#define	U 1	// up
#define R 2	// right
#define D 3	// down

// draw board
void DrawBoard()
{
	int i, j, x, y, b;
	for (i = 0; i < MAPH; i++)
	{
		for (j = 0; j < MAPW; j++)
		{
			b = Board[i*MAPW + j];
			x = j*TILESIZE + TILESIZE/2;
			y = i*TILESIZE + TILESIZE/2;
			DrawImg4Pal(TilesImg, TilesImg_Pal, 0, b*TILESIZE, x, y, TILESIZE, TILESIZE, TILESIZE);
		}
	}
	DispUpdate();
}

// get character from keyboard (NOKEY = no key)
u8 GetChar()
{
	return KeyGet();
}

// flush characters from keyboard
void FlushChar()
{
	KeyFlush();
}

// maze generator
void Gener()
{
	s16 i, s, x, y;

	// clear board with black tile (on right and on down will leave black tiles)
	memset(Board, S_BLACK, MAPSIZE);

	// clear maze - set empty tiles
	for (y = 0; y < MAZEH; y++)
		for (x = 0; x < MAZEW; x++)
			*BoardAddr(x, y) = S_EMPTY_HIDE;

	// add stones - only to odd coordinates (MAZEW and MAZEH must be odd numbers!)
	for (y = 1; y < MAZEH; y += 2)
		for (x = 1; x < MAZEW; x += 2)
			*BoardAddr(x, y) = S_DOOR_HIDE;

	// generator loop
	for (;;)
	{
		// calculate remaining stones
		s = 0;
		for (i = 0; i < MAPSIZE; i++) if (Board[i] == S_DOOR_HIDE) s++;
		if (s == 0) break; // no stones left, end of generation

		// select random stone
		s = RandS16Max(s-1);

		// find stone (only odd coordinates)
		for (y = 1; y < MAZEH; y += 2)
		{
			for (x = 1; x < MAZEW; x += 2)
			{
				if (*BoardAddr(x, y) == S_DOOR_HIDE)
				{
					s--;
					if (s < 0) break;
				}
			}
			if (s < 0) break;
		}

		// select random direction (L=0, U=1, R=2, D=3)
		i = RandU8Max(3);

		// build wall, until we meet another wall
		for (;;)
		{
			// put one wall
			*BoardAddr(x, y) = S_WALL_HIDE;

			// shift coordinates
			switch (i)
			{
			case L: x--; break;
			case U: y--; break;
			case R: x++; break;
			default: y++; break; // D
			}

			// coordinates are out of range
			if ((x < 0) || (x >= MAZEW) || (y < 0) || (y >= MAZEH)) break;

			// check wall on new position
			if (*BoardAddr(x, y) == S_WALL_HIDE) break;
		}
	}
}

// get one tile (returns S_WALL if out of range)
u8 GetTile(s8 x, s8 y)
{
	if ((x < 0) || (x >= MAZEW) || (y < 0) || (y >= MAZEH)) return S_WALL;
	if ((x == PosX) && (y == PosY)) return S_FACE;
	if ((x == StopX) && (y == StopY)) return S_DOOR;
	u8 tile = *BoardAddr(x, y);
	if (tile == S_WALL_HIDE) tile = S_WALL;
	if (tile == S_EMPTY_HIDE) tile = S_EMPTY;
	if (tile == S_DOOR_HIDE) tile = S_DOOR;
	return tile;
}

// hide face
void Hide()
{
	*BoardAddr(PosX, PosY) = S_EMPTY;
}

// show face
void Show()
{
	*BoardAddr(PosX, PosY) = S_FACE;
}

// check if position is free
Bool IsEmpty(s8 x, s8 y)
{
	u8 t = GetTile(x, y);
	return (t == S_EMPTY) || (t == S_DOOR);
}

// show all maze
void ShowAll()
{
	int x, y;
	for (x = 0; x < MAZEW; x++)
	{
		for (y = 0; y < MAZEH; y++)
			*BoardAddr(x, y) = GetTile(x, y);

		DrawBoard();
		WaitMs(40);
	}
}

// look around
void Look()
{
	if (PosX > 0) *BoardAddr(PosX-1, PosY) = GetTile(PosX-1, PosY);
	if (PosX < MAZEW-1) *BoardAddr(PosX+1, PosY) = GetTile(PosX+1, PosY);
	if (PosY > 0) *BoardAddr(PosX, PosY-1) = GetTile(PosX, PosY-1);
	if (PosY < MAZEH-1) *BoardAddr(PosX, PosY+1) = GetTile(PosX, PosY+1);
}

// clear display and start new scene
void Clear()
{
	// generate new maze
	Gener();

	// generate stop position
	for (;;)
	{
		StopX = RandU8Max(MAZEW-1);
		StopY = RandU8Max(MAZEH-1);
		if (*BoardAddr(StopX, StopY) == S_EMPTY_HIDE) break;
	}
	*BoardAddr(StopX, StopY) = S_DOOR_HIDE;

	// generate start position
	for (;;)
	{
		PosX = RandU8Max(MAZEW-1);
		PosY = RandU8Max(MAZEH-1);
		if ((*BoardAddr(PosX, PosY) == S_EMPTY_HIDE) &&
			(abs(PosX - StopX) > 4) && (abs(PosY - StopY) > 4)) break;
	}
	Show();

	// look around
	Look();

	// reset animation
	Anim = 0;

	DrawBoard();
}

int main()
{
	int i;
	char ch;

	// clear display and start new scene
	DrawClear(COL_BLACK);
	Clear();

	// main loop
	while (True)
	{
		// face animation
		Anim++;
		if (Anim == 90) *BoardAddr(PosX, PosY) = S_WINK;
		if (Anim == 100)
		{
			*BoardAddr(PosX, PosY) = S_FACE;
			Anim = 0;
			DrawBoard();
		}

		// key service
		ch = GetChar();
		switch (ch)
		{
		// key "A" = show door
		case KEY_A:
			{
				u8 t = *BoardAddr(StopX, StopY);
				int k;
				for (k = 3; k > 0; k--)
				{
					*BoardAddr(StopX, StopY) = S_DOOR;
					DrawBoard();
					WaitMs(100);
					*BoardAddr(StopX, StopY) = S_DOOR_HIDE;
					DrawBoard();
					WaitMs(50);
				}
				*BoardAddr(StopX, StopY) = t;
				DrawBoard();
			}
			FlushChar();
			break;

		// left
		case KEY_LEFT:
			if ((PosX > 0) && IsEmpty(PosX-1, PosY))
			{
				*BoardAddr(PosX-1, PosY) = S_LEFT1;
				*BoardAddr(PosX, PosY) = S_LEFT2;
				DrawBoard();
				WaitMs(SPEED);
				*BoardAddr(PosX-1, PosY) = S_RIGHT1;
				*BoardAddr(PosX, PosY) = S_RIGHT2;
				DrawBoard();
				WaitMs(SPEED);
				Hide();
				PosX--;
				Show();
				Look();
				DrawBoard();
			}
			FlushChar();
			break;

		// right
		case KEY_RIGHT:
			if ((PosX < MAZEW-1) && IsEmpty(PosX+1, PosY))
			{
				*BoardAddr(PosX, PosY) = S_RIGHT1;
				*BoardAddr(PosX+1, PosY) = S_RIGHT2;
				DrawBoard();
				WaitMs(SPEED);
				*BoardAddr(PosX, PosY) = S_LEFT1;
				*BoardAddr(PosX+1, PosY) = S_LEFT2;
				DrawBoard();
				WaitMs(SPEED);
				Hide();
				PosX++;
				Show();
				Look();
				DrawBoard();
			}
			FlushChar();
			break;

		// up
		case KEY_UP:
			if ((PosY > 0) && IsEmpty(PosX, PosY-1))
			{
				*BoardAddr(PosX, PosY-1) = S_UP2;
				*BoardAddr(PosX, PosY) = S_UP1;
				DrawBoard();
				WaitMs(SPEED);
				*BoardAddr(PosX, PosY-1) = S_DOWN1;
				*BoardAddr(PosX, PosY) = S_DOWN2;
				DrawBoard();
				WaitMs(SPEED);
				Hide();
				PosY--;
				Show();
				Look();
				DrawBoard();
			}
			FlushChar();
			break;

		// down
		case KEY_DOWN:
			if ((PosY < MAZEH-1) && IsEmpty(PosX, PosY+1))
			{
				*BoardAddr(PosX, PosY) = S_DOWN1;
				*BoardAddr(PosX, PosY+1) = S_DOWN2;
				DrawBoard();
				WaitMs(SPEED);
				*BoardAddr(PosX, PosY) = S_UP2;
				*BoardAddr(PosX, PosY+1) = S_UP1;
				DrawBoard();
				WaitMs(SPEED);
				Hide();
				PosY++;
				Show();
				Look();
				DrawBoard();
			}
			FlushChar();
			break;

		case KEY_Y: ResetToBootLoader();

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif

		// no key
		case NOKEY:
			break;

		// invalid key
		default:
			FlushChar();
			break;
		}

		// SOLVED
		if ((PosX == StopX) && (PosY == StopY))
		{
			// show all maze
			ShowAll();

			// winking
			for (i = 0; i < 5; i++)
			{
				*BoardAddr(PosX, PosY) = S_WINK;
				DrawBoard();
				WaitMs(100);
				*BoardAddr(PosX, PosY) = S_FACE;
				DrawBoard();
				WaitMs(100);
			}
			*BoardAddr(StopX, StopY) = S_DOOR;
			DrawBoard();

			// wait for a key press
			FlushChar();
			while (GetChar() == 0) {}

			// new scene
			Clear();
			FlushChar();
		}

		// animation delay
		//WaitMs(20);
	}
}
