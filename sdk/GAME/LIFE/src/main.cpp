
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

// game board
u8 Board[MAPSIZE];

// neighbors
u8 Neigh[MAPSIZE];

// slots
u8 Slot[MAPSIZE*SLOTNUM];
int SelSlot;

// clipboard
u8 Clip[MAPSIZE];

// cursor
int CurX, CurY;

// samples (first 2 bytes = width, height)
const u8 Samples[] = {

	// 0: Life
	5,5,
	1,1,1,1,1,
	1,1,1,1,1,
	1,1,1,1,1,
	1,1,1,1,1,
	1,1,1,1,1,

	// 1: penta-decathlon
	3,12,
	1,1,1,
	0,1,0,
	0,1,0,
	1,1,1,
	0,0,0,
	1,1,1,
	1,1,1,
	0,0,0,
	1,1,1,
	0,1,0,
	0,1,0,
	1,1,1,

	// 2: R-pentomino
	3,3,
	0,1,1,
	1,1,0,
	0,1,0,

	// 3: Diehard
	8,3,
	0,0,0,0,0,0,1,0,
	1,1,0,0,0,0,0,0,
	0,1,0,0,0,1,1,1,

	// 4. Acorn
	7,3,
	0,1,0,0,0,0,0,
	0,0,0,1,0,0,0,
	1,1,0,0,1,1,1,

	// 5: Glider
	3,3,
	0,0,1,
	1,0,1,
	0,1,1,

	// 6: spaceship
	5,4,
	1,0,0,1,0,
	0,0,0,0,1,
	1,0,0,0,1,
	0,1,1,1,1,

	// 7: pulsar
	15,15,
	0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,
	0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,
	0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	1,1,1,0,0,1,1,0,1,1,0,0,1,1,1,
	0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,
	0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,
	0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,
	1,1,1,0,0,1,1,0,1,1,0,0,1,1,1,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,1,1,0,0,0,1,1,0,0,0,0,
	0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,
	0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,

	// 8: Gosper glider gun
	38, 9,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,1,0,0,0,0, 0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,1,0,1,0,0,0,0, 0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,1,1,0,0,0,0,0, 0,1,1,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,1,0,0,0,1,0,0,0, 0,1,1,0,0,0,0,0,0,0, 0,0,0,0,0,1,1,0,
	0,1,1,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,1,0,0, 0,1,1,0,0,0,0,0,0,0, 0,0,0,0,0,1,1,0,
	0,1,1,0,0,0,0,0,0,0, 0,1,0,0,0,1,0,1,1,0, 0,0,0,1,0,1,0,0,0,0, 0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,1,0,0, 0,0,0,0,0,1,0,0,0,0, 0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,1,0,0,0,1,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,1,1,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,

	// 9: Simkin glider gun
	33,21,
	1,1,0,0,0,0,0,1,1,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	1,1,0,0,0,0,0,1,1,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,1,1,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,1,1,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,1,1,0,1,1,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,1,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,0,1,0, 0,1,1,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,1,1,1,0,0,0,1,0,0, 0,1,1,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,1,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 1,1,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 1,0,0,0,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,1,1,1,0,0,0,0,0,0, 0,0,0,
	0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,1,0,0,0,0,0,0, 0,0,0,
};

// draw board
void DrawBoard()
{
	int i, j, x, y, b;
	for (i = 0; i < MAPH; i++)
	{
		for (j = 0; j < MAPW; j++)
		{
			b = Board[(i+MAPY)*MAPW0 + j+MAPX];
			x = j*TILESIZE;
			y = i*TILESIZE;
			DrawImg4Pal(Tiles16Img, Tiles16Img_Pal, 0, b*TILESIZE, x, y, TILESIZE, TILESIZE, TILESIZE);
		}
	}
	DispUpdate();
}

// get character from keyboard (0 = no key)
char GetChar()
{
	return KeyGet();
}

// flush characters from keyboard
void FlushChar()
{
	KeyFlush();
}

// set cursor on
void CurOn()
{
	u8* d = &Board[CurX + CurY*MAPW0];
	u8 b = *d;
	if (b == TILE_FULL)
		b = TILE_SELFULL;
	else if (b == TILE_EMPTY)
		b = TILE_SELEMPTY;
	*d = b;
}

// set cursor off
void CurOff()
{
	u8* d = &Board[CurX + CurY*MAPW0];
	u8 b = *d;
	if (b == TILE_SELFULL)
		b = TILE_FULL;
	else if (b == TILE_SELEMPTY)
		b = TILE_EMPTY;
	*d = b;
}

// flip cursor
void CurFlip()
{
	u8* d = &Board[CurX + CurY*MAPW0];
	u8 b = *d;
	if (b == TILE_SELFULL)
		b = TILE_SELEMPTY;
	else if (b == TILE_SELEMPTY)
		b = TILE_SELFULL;
	*d = b;
}

// get cell on coordinates (0 or 1)
int Cell(int x, int y)
{
	while (x < 0) x += MAPW0;
	while (x >= MAPW0) x -= MAPW0;
	while (y < 0) y += MAPH0;
	while (y >= MAPH0) y -= MAPH0;
	u8* d = &Board[x + y*MAPW0];
	u8 b = *d;
	return (b == TILE_FULL) ? 1 : 0;
}

// save to current slot
void SaveSlot()
{
	memcpy(&Slot[MAPSIZE*SelSlot], Board, MAPSIZE);
}

// load from current slot
void LoadSlot()
{
	memcpy(Board, &Slot[MAPSIZE*SelSlot], MAPSIZE);
}

// run life
void Run()
{
	int x, y;
	u8 b;
	u8* d;
	u8* s;

	FlushChar();

	// break with a key
	while (GetChar() == NOKEY)
	{
		// calculate neighbors
		d = Neigh;
		for (y = 0; y < MAPH0; y++)
		{
			for (x = 0; x < MAPW0; x++)
			{
				*d++ =	Cell(x-1, y-1) +
					Cell(x  , y-1) +
					Cell(x+1, y-1) +

					Cell(x-1, y  ) +
					Cell(x+1, y  ) +

					Cell(x-1, y+1) +
					Cell(x  , y+1) +
					Cell(x+1, y+1);
			}
		}

		// update cells
		s = Neigh;
		d = Board;
		for (x = MAPSIZE; x > 0; x--)
		{
			b = *s++;

			// 3 -> new cell
			if (b == 3) 
				*d = TILE_FULL;

			// 2 -> unchanged
			else if (b == 2)
				;
			// else -> dead
			else
				*d = TILE_EMPTY;
			d++;
		}

		DrawBoard();

		// delay
		WaitMs(SPEED/4);
		KeyScan();
		WaitMs(SPEED/4);
		KeyScan();
		WaitMs(SPEED/4);
		KeyScan();
		WaitMs(SPEED/4);
		KeyScan();
	}
}

// initialize slots by samples
void InitSlot()
{
	int slot;
	u8* d;
	const u8* s = Samples;
	int w, h;
	for (slot = 0; slot < SLOTNUM; slot++)
	{
		// destination slot
		d = &Slot[MAPSIZE*slot];

		// sample dimension
		w = *s++;
		h = *s++;

		// center image
		d += (MAPW0-w)/2 + (MAPH0-h)/2*MAPW0;

		// copy sample
		for (; h > 0; h--)
		{
			memcpy(d, s, w);
			d += MAPW0;
			s += w;
		}
	}
}

int main()
{
	int i;
	char ch;

	// clear buffer
	memset(Board, TILE_EMPTY, MAPSIZE);
	memset(Slot, TILE_EMPTY, MAPSIZE*SLOTNUM);
	memset(Clip, TILE_EMPTY, MAPSIZE);
	CurX = MAPW0/2;
	CurY = MAPH0/2;
	SelSlot = 1;

	// fill slots with samples
	InitSlot();

	// load current slot
	LoadSlot();

	// set cursor on
	CurOn();

	// draw board
	DrawBoard();

	// loop with demo scene
	while (True)
	{
		// keyboard
		ch = GetChar();
		if (ch != NOKEY)
		{
			switch (ch)
			{
			// right
			case KEY_RIGHT:
				CurOff(); // set cursor off
				CurX++;
				if (CurX >= MAPX+MAPW) CurX = MAPX;
				CurOn(); // set cursor on
				DrawBoard();
				break;

			// left
			case KEY_LEFT:
				CurOff(); // set cursor off
				CurX--;
				if (CurX < MAPX) CurX = MAPX+MAPW-1;
				CurOn(); // set cursor on
				DrawBoard();
				break;

			// down
			case KEY_DOWN:
				CurOff(); // set cursor off
				CurY++;
				if (CurY >= MAPY+MAPH) CurY = MAPY;
				CurOn(); // set cursor on
				DrawBoard();
				break;

			// up
			case KEY_UP:
				CurOff(); // set cursor off
				CurY--;
				if (CurY < MAPY) CurY = MAPY+MAPH-1;
				CurOn(); // set cursor on
				DrawBoard();
				break;
		
			// toggle
			case KEY_A:
				CurFlip(); // flip cursor
				DrawBoard();
				break;

			// run
			case KEY_B:
#if USE_SCREENSHOT		// use screen shots
				ScreenShot();
#endif
				CurOff(); // set cursor off
				SaveSlot(); // save state
				Run(); // run life
				LoadSlot(); // restore state
				CurOn(); // set cursor on
				DrawBoard();
				break;

			// select slot
			case KEY_X:
				CurOff(); // set cursor off
				SaveSlot();
				SelSlot++;
				if (SelSlot >= SLOTNUM) SelSlot = 0;
				LoadSlot();
				CurOn(); // set cursor on
				DrawBoard();
				break;

			case KEY_Y: ResetToBootLoader();
			}
		}
	}
}
