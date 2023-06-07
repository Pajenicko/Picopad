
// ****************************************************************************
//
//                                Game engine
//
// ****************************************************************************

#include "../include.h"

// buffers
u8 Board[MAPSIZE];	// game board
u8 Dir[MAPSIZE];	// direction map DIR_*
u8 PswBuf[PSWLEN];	// password buffer

// current game state
u8 Level;		// current level
u8 HeadX, HeadY;	// head (loco) coordinates
u8 GateX, GateY;	// gate coordinates
u16 Length;		// length of the (including loco)
u16 ItemNum;		// number of items on game board
u8 State;		// game state S_*
u8 Phase;		// current animation phase (0, 1, 2)
u8 CurDir;		// current direction DIR_*
int Score;		// current score
u32 LastTime;		// time of last step

// key buffers for 2 keys (NOKEY=no key)
char KeyBuf1, KeyBuf2;

// texts
const char LevelTxt[] = "LEVEL";
const char PswTxt[] = "password";
const char LevelHlp[] = "KEY-A:PSW";
const char OkHlp[] = "KEY-A:OK";
const char EscHlp[] = "KEY-Y:CANCEL";
const char CongTxt[] = "CONGRATULATIONS!";
const char Cong2Txt[] = "You became absolute";
const char Cong3Txt[] = "winner of the game!";
const char ScoreHlp[] = "SCORE";

// wait step
void WaitStep()
{
	DispUpdate();
	u32 t;
	for (;;)
	{
		t = Time();
		if ((u32)(t - LastTime) >= GAMESPEED*1000) break;
		KeyScan(); // scan keyboard
	}
	LastTime = t;
}

// clear info row
void InfoClear()
{
	DrawRect(0, MAPY+MAPH*TILESIZE, WIDTH, 16, COL_BLACK);
}

// display text to info row
void InfoDispTextBg(int x, const char* txt, u16 col, u16 bgcol)
{
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;
	DrawTextBg(txt, x, MAPY+MAPH*TILESIZE, col, bgcol);
}

// display text to info row
void InfoDispText(int x, const char* txt, u16 col)
{
	InfoDispTextBg(x, txt, col, COL_BLACK);
}

// display info bottom row
void InfoRow()
{
	// clear info row
	InfoClear();

	// display score
	InfoDispText(0, ScoreHlp, COL_GREEN);
	char buf[10];
	DecUNum(buf, Score, 0);
	InfoDispText(6*8, buf, COL_YELLOW);
	
	// display text ENTER: PSW
	InfoDispText(16*8, LevelHlp, COL_RED);

	// display level
	InfoDispText(WIDTH - 8*8, LevelTxt, COL_GREEN);
	DecUNum(buf, Level, 0);
	InfoDispText(WIDTH - 2*8, buf, COL_YELLOW);
}

// enter password
void Psw()
{
	// display help
	InfoClear();

	// display help
	InfoDispText(0, OkHlp, COL_GREEN);
	InfoDispText(WIDTH - (sizeof(EscHlp)-1)*8, EscHlp, COL_GREEN);

	// load password
	char buf[PSWLEN+1];
	memcpy(buf, &LevelPsw[Level*PSWLEN], PSWLEN);
	buf[PSWLEN] = 0;

	// display password
	int x = (WIDTH - (sizeof(PswTxt) - 1 + 1 + 5)*8)/2 - 16;
	InfoDispText(x, PswTxt, COL_RED);
	x += (sizeof(PswTxt) - 1 + 1)*8;

	// edit password
	int pos = 0;
	char c;
	char buf2[2];
	buf2[1] = 0;
	for (;;)
	{
		// display password
		InfoDispText(x, buf, COL_YELLOW);
		buf2[0] = buf[pos];
		InfoDispTextBg(x + pos*8, buf2, COL_BLACK, COL_YELLOW);
		DispUpdate();

		// input keys
		c = KeyGet();

		// Esc break
		if ((c == KEY_B) || (c == KEY_X) || (c == KEY_Y))
		{
			InfoRow();
			return;
		}

		// OK enter
		if (c == KEY_A)
		{
			// search password
			int i;
			for (i = 1; i <= LEVNUM; i++)
			{
				// check password
				if (memcmp(buf, &LevelPsw[i*PSWLEN], PSWLEN) == 0)
				{
					// set new level
					Level = i;
					break;
				}
			}

			// restart this scene
			InfoRow();
			OpenLevel();
			InitLevel();
			return;
		}

		// Left
		if (c == KEY_LEFT)
		{
			pos--;
			if (pos < 0) pos = PSWLEN-1;
		}

		// right
		if (c == KEY_RIGHT)
		{
			pos++;
			if (pos >= PSWLEN) pos = 0;
		}

		// up
		if (c == KEY_UP)
		{
			buf[pos]++;
			if ((u8)buf[pos] > (u8)'Z') buf[pos] = 'A';
		}

		// down
		if (c == KEY_DOWN)
		{
			buf[pos]--;
			if ((u8)buf[pos] < (u8)'A') buf[pos] = 'Z';
		}
	}
}

// display one tile of the board
void DispTile(u8 x, u8 y)
{
	u8 tile = Board[x + y*MAPW];
	int row = tile / TILESNUMX;
	int col = tile - row*TILESNUMX;
	DrawImg4Pal(TilesImg, TilesImg_Pal, col*TILESIZE, row*TILESIZE,
		x*TILESIZE, y*TILESIZE + MAPY, TILESIZE, TILESIZE, TILESIMGW);
}

// display all tiles
void DispBoard()
{
	int x, y;
	for (y = 0; y < MAPH; y++)
	{
		for (x = 0; x < MAPW; x++) DispTile(x, y);
	}
}

// put tile on the board
void PutTile(u8 x, u8 y, u8 tile)
{
	Board[x + y*MAPW] = tile;
	DispTile(x, y);
}

// get tile from board
u8 GetTile(u8 x, u8 y) { return Board[x + y*MAPW]; }

// clear level screen
void ClearLevel(u8 tile)
{
	u8 x, y;

	// clear screen with bricks
	for (x = 0; x < MAPW; x++)
	{
		for(y = 0; y < MAPH; y++) PutTile(x, y, tile);
		DispUpdate();
		WaitMs(20);
	}
}

// congratulate
void CongLevel()
{
	// clear screen with bricks
	ClearLevel(WALL);

	// set info box ON
	DrawRect(BOXX-3*8, BOXY, BOXW+6*8, BOXH, COL_BLACK);

	// display frame
	DrawFrame(BOXX-1-3*8, BOXY-1, BOXW+2+6*8, BOXH+2, COL_WHITE);

	// display text
	DrawText(CongTxt, (WIDTH - (sizeof(CongTxt)-1)*8)/2, BOXY + 16, COL_YELLOW);
	DrawText(Cong2Txt, (WIDTH - (sizeof(Cong2Txt)-1)*8)/2, BOXY + 2*16, COL_GREEN);
	DrawText(Cong3Txt, (WIDTH - (sizeof(Cong3Txt)-1)*8)/2, BOXY + 3*16, COL_GREEN);

	// display info row
	InfoRow();

	// update display
	DispUpdate();

	// wait
	WaitMs(250);
	KeyFlush();
	while (KeyGet() == NOKEY) {}

	// clear screen with empty
	ClearLevel(EMPTY);
}

// open level
void OpenLevel()
{
	// clear screen with bricks
	ClearLevel(WALL);

	// set info box ON
	DrawRect(BOXX, BOXY, BOXW, BOXH, COL_BLACK);

	// display frame
	DrawFrame(BOXX-1, BOXY-1, BOXW+2, BOXH+2, COL_WHITE);

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	DrawFontWidth = 8;

	// display current scene
	int x, x2;
	char buf[10];
	int n = DecUNum(buf, Level, 0);
	x = (WIDTH - (sizeof(LevelTxt)+n)*8)/2;
	DrawText(LevelTxt, x, BOXY + 16, COL_GREEN);
	x += sizeof(LevelTxt)*8;
	DrawText(buf, x, BOXY + 16, COL_YELLOW);

	// display password
	x = (WIDTH - (sizeof(PswTxt)+PSWLEN)*8)/2;
	DrawText(PswTxt, x, BOXY + 3*16, COL_GREEN);
	memcpy(buf, &LevelPsw[Level*PSWLEN], PSWLEN);
	buf[PSWLEN] = 0;
	x += sizeof(PswTxt)*8;
	DrawText(buf, x, BOXY + 3*16, COL_YELLOW);

	// display info row
	InfoRow();

	// update display
	DispUpdate();

	// wait
	WaitMs(250);
	KeyFlush();
#ifndef AUTOMODE // automode - run levels to check solutions (help completes scene)
	while (KeyGet() == NOKEY) {}
#endif

	// clear screen with empty
	ClearLevel(EMPTY);
}

// initialize current level
void InitLevel()
{
	// copy items to game board
	memcpy(Board, &Levels[MAPSIZE*Level], MAPSIZE);

	// analyse board
	u8 b;
	int x, y;
	ItemNum = 0;
	for (y = 0; y < MAPH; y++)
	{
		for (x = 0; x < MAPW; x++)
		{
			// get item from board
			b = Board[x+y*MAPW];

			// locomotive
			if ((b >= LOCOMIN) && (b <= LOCOMAX))
			{
				HeadX = x;
				HeadY = y;
			}

			// gate
			else if (b == GATE)
			{
				GateX = x;
				GateY = y;
			}

			// item
			else if ((b >= ITEMMIN) && (b <= ITEMMAX))
			{
				ItemNum++;
			}
		}
	}

	// reset variables
	State = S_WAIT;
	Length = 1;
	CurDir = DIR_R;
	Phase = 0;
	KeyBuf1 = NOKEY;
	KeyBuf2 = NOKEY;

	// display info row
	if (Level == 0)
		InfoClear();
	else
		InfoRow();

	// display board
	DispBoard();

	// time of last step
	LastTime = Time();
}

// train step
void StepLevel()
{
	// next position
	s8 x = HeadX;
	s8 y = HeadY;
	u8 d = CurDir;
	if (d == DIR_L) x--;
	if (d == DIR_U) y--;
	if (d == DIR_R) x++;
	if (d == DIR_D) y++;
	u8* bold = &Board[HeadX + HeadY*MAPW]; // current position
	u8* bnew = &Board[x + y*MAPW]; // new position
	u8 b = *bnew; // item on new position

	// crash
	if ((x < 0) || (x >= MAPW) || // x is out of board
		(y < 0) || (y >= MAPH) || // y is out of board
		((b != EMPTY) && // not empty field
		((b <= GATEMIN) || (b > GATEMAX)) && // not open gate
		((b < ITEMMIN) || (b > ITEMMAX)))) // not valid item
	{
		State = S_CRASH;	// crash state
		b = CRASH;		// crash image

		// crash animation
		PLAYSOUND(CrashSnd);

		while (True)
		{
			PutTile(HeadX, HeadY, b); // set locomotive crash image
			WaitStep();
			b++;
			if (b > CRASHMAX) b = CRASHMAX - 2;
			if (KeyGet() != NOKEY) break;
		}

		// restart new level
		InitLevel();
		return;
	}

	// set loco to new position
	u8 b2;
	s8 xold = HeadX;
	s8 yold = HeadY;
	if (d == DIR_L)
		b2 = LOCO_L; // direction left
	else if (d == DIR_U)
		b2 = LOCO_U; // direction up
	else if (d == DIR_R)
		b2 = LOCO_R; // direction right
	else b2 = LOCO_D; // direction down
	PutTile(x, y, b2); // store new locomotive image
	Dir[x + y*MAPW] = d; // store new direction at this point
	HeadX = x; // new locomotive position
	HeadY = y;

	// move wagons
	int i;
	for (i = Length-1; i > 0; i--)
	{
		x = xold;
		y = yold;

		// get position of previous wagon
		d = Dir[x + y*MAPW];
		if (d == DIR_L) x++;
		if (d == DIR_U) y++;
		if (d == DIR_R) x--;
		if (d == DIR_D) y--;

		// change direction of previous wagon
		b2 = GetTile(x, y); // get wagon on new (previous) position
		while (b2 >= WAGONMIN + 20) b2 -= 20;
		if (d == DIR_U) b2 += 20;
		if (d == DIR_R) b2 += 2*20;
		if (d == DIR_D) b2 += 3*20;

		// put wagon on new position
		PutTile(xold, yold, b2);

		xold = x;
		yold = y;
	}

	// collect item, increase train length
	if ((b >= ITEMMIN) && (b <= ITEMMAX))
	{
		// collect sound
		PLAYSOUND(CollectSnd);

		// increase train length
		Length++;

		// new wagon
		b += WAGONMIN - ITEMMIN;
		while (b >= WAGONMIN + 20) b -= 20;
		d = Dir[xold + yold*MAPW];
		if (d == DIR_U) b += 20;
		if (d == DIR_R) b += 2*20;
		if (d == DIR_D) b += 3*20;
		PutTile(xold, yold, b);

		// decrease number of items
		ItemNum--;

		// start opening gate
		if (ItemNum == 0) PutTile(GateX, GateY, GATEMIN+1);

		// count score
		if (State == S_GO)
		{
			Score += 10;
			InfoRow();
		}
	}
	else
	{
		// step sound
		PLAYSOUND(StepSnd);

		// empty last position
		PutTile(xold, yold, EMPTY);
	}

	// gate
	if ((HeadX == GateX) && (HeadY == GateY))
	{
		int s = State;
		State = S_FINISH;
		DispUpdate();
		WaitMs(500);
		KeyFlush();

#ifndef AUTOMODE // automode - run levels to check solutions (help completes scene)
		if (s == S_HELP) return;
#endif

		// play sound
		PLAYSOUND(SuccessSnd);
		WaitMs(1000);

		// open next level
		if (Level < LEVNUM)
		{
			Level++;
			OpenLevel();
		}
		else
			CongLevel();
		InitLevel();
	}
}

// level animation - called every single game step
void AnimLevel()
{
	// set phase of the objects
	int x, y;
	u8 b;
	for (y = 0; y < MAPH; y++)
	{
		for (x = 0; x < MAPW; x++)
		{
			b = GetTile(x, y);

			// animate items
			if ((b >= ITEMMIN) && (b <= ITEMMAX))
			{
				while (b >= ITEMMIN+20) b -= 20;
				b += Phase*20;
				PutTile(x, y, b);
			}

			// animate locomotive
			else if ((b >= LOCOMIN) && (b <= LOCOMAX))
			{
				while (b >= LOCOMIN+4) b -= 4;
				b += Phase*4;
				PutTile(x, y, b);
			}

			// animate gate
			else if ((b > GATEMIN) && (b < GATEMAX))
			{
				PutTile(x, y, b + 1);
			}
		}
	}

	// increase animation phase
	Phase++;
	if (Phase >= 3)
	{
		Phase = 0;

		// change direction by keyboard (and potentially start the game)
		char c = KeyBuf1;
		KeyBuf1 = KeyBuf2;
		KeyBuf2 = NOKEY;
		if (c != NOKEY)
		{
			if (State == S_WAIT) State = S_GO;
			if (c == KEY_DOWN) CurDir = DIR_D;
			if (c == KEY_RIGHT) CurDir = DIR_R;
			if (c == KEY_LEFT) CurDir = DIR_L;
			if (c == KEY_UP) CurDir = DIR_U;
		}

		// one step
		if ((State == S_GO) || (State == S_HELP)) StepLevel();
	}
}

// help level
//  Returns: 0=continue, 1=restart scene, 2=quit game
u8 HelpLevel()
{
	char b;
	u8 ch;

	// re-initialize current scene
	InitLevel();

	// help mode
	State = S_HELP;

	// prepare pointer to level solution
	const char* s = Solution[Level];

	// macro loop
	while (State == S_HELP)
	{
		// get next key from solution macro
		b = *s++;
		if (b == 0)
		{
			State = S_FINISH;

			// wait 1.6 seconds on end of scene
			for (b = 10; b > 0; b--)
			{
				ch = KeyGet();
				if (ch == KEY_Y) return 2;
				if (ch != NOKEY) return 1;
				AnimLevel();
				// wait step
				WaitStep();
			}
			return 0;
		}
		if (b == 'R') CurDir = DIR_R;
		if (b == 'U') CurDir = DIR_U;
		if (b == 'L') CurDir = DIR_L;
		if (b == 'D') CurDir = DIR_D;

		ch = KeyGet();
		if (ch == KEY_Y) return 2;
		if (ch != NOKEY) return 1;

		AnimLevel();
		WaitStep();

		ch = KeyGet();
		if (ch == KEY_Y) return 2;
		if (ch != NOKEY) return 1;

		AnimLevel();
		WaitStep();

		ch = KeyGet();
		if (ch == KEY_Y) return 2;
		if (ch != NOKEY) return 1;

		AnimLevel();

		// text on demo screen
		if (Level == 0)
		{
			if (HeadY == 9)
				DrawImg4Pal(TilesImg, TilesImg_Pal, 0, 9*16, 0, 8*16+MAPY, HeadX*TILESIZE, 32, TILESIMGW);
			else if ((HeadY == 10) && (HeadX >= 13))
			{
				DrawImg4Pal(TilesImg, TilesImg_Pal, 11*16 + (HeadX-13)*16, 8*16,
					(HeadX+1)*16, 10*16+MAPY, 6*16 - (HeadX-13), 16, TILESIMGW);
				DrawImg4Pal(TilesImg, TilesImg_Pal, 0, 9*16, 0, 8*16+MAPY, TILESIMGW, 32, TILESIMGW);
			}
		}

		// step
		WaitStep();

		// break help
		ch = KeyGet();
		if (ch == KEY_Y) return 2;
		if (ch != NOKEY) return 1;
	}

	// no break from keyboard
	return 0;
}

// game loop - called every single game step
//  Returns: 0=continue, 1=restart scene, 2=quit game
u8 GameLoop()
{
	// animation
	AnimLevel();

	// key input
	char c = KeyGet();

#ifdef AUTOMODE // automode - run levels to check solutions (help completes scene)
	c = KEY_X;
#endif

	if (c == NOKEY) return 0;

	switch (c)
	{
	// enter password
	case KEY_A:
		Psw();
		break;

	// quit
	case KEY_Y:
		return 2;

	// restart
	case KEY_B:
		// break
		if (State != S_GO) return 1; 

		// restart scene
		InitLevel();
		break;

	// help
	case KEY_X:
		HelpLevel();
		InitLevel();
		break;

	// direction
	case KEY_RIGHT:
	case KEY_UP:
	case KEY_LEFT:
	case KEY_DOWN:
		// save key into key buffer
		if (KeyBuf1 == NOKEY)
			KeyBuf1 = c;
		else
		{
			if (KeyBuf2 == NOKEY)
				KeyBuf2 = c;
			else
			{
				KeyBuf1 = KeyBuf2;
				KeyBuf2 = c;
			}
		}
		break;

	// unknown key - display help
	default:
		KeyFlush();
	}

	// no break
	return 0;
}
