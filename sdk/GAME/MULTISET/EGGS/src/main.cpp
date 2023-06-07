
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

// game board
u8 Board[BOARDSIZE];

// directions
const s8 DirX[8] = {  1,  1,  0, -1, -1, -1,  0,  1 };
const s8 DirY[8] = {  0,  1,  1,  1,  0, -1, -1, -1 };

// players
int Stones[2];	// number of stones (player 1: number of eggs, player 2: number of hens)
int Wins[2] = { 0, 0 };	// number of wins
Bool Comp[2];	// player is computer
u8 Player;	// active player (0 or 1, 2=no player)
u8 CurX, CurY;	// cursor position
u8 CurBlink;	// blinking cursor
u8 Pos;		// number of possible positions
u8 Free;	// number of free positions

// flush characters from keyboard
void FlushChar()
{
	KeyFlush();
}

// draw board
void DrawBoard()
{
	int i, j, x, y, b;
	for (i = 0; i < BOARDH; i++)
	{
		for (j = 0; j < BOARDW; j++)
		{
			b = Board[i*BOARDW + j];
			x = j*TILEW;
			y = i*TILEH;
			DrawImg4Pal(TilesImg, TilesImg_Pal, 0, b*TILEH, x, y, TILEW, TILEH, TILEW);
		}
	}
	DispUpdate();
}

// get board on coordinates
u8 GetBoard(s8 x, s8 y)
{
	if ((x < 0) || (y < 0) || (x >= BOARDW) || (y >= BOARDH)) return TILE_BLACK;
	return Board[x + y*BOARDW];
}

// set board on coordinates (adds game start coordinates)
void SetBoard(s8 x, s8 y, u8 tile)
{
	Board[x + y*BOARDW] = tile;
}

// set cursor on
void CurOn()
{
	u8 c = GetBoard(CurX, CurY);
	if ((c >= TILE_OFFMIN) && (c <= TILE_OFFMAX))
	{
		SetBoard(CurX, CurY, c - TILE_OFFMIN + TILE_ONMIN);
	}
	CurBlink = 0;
}

// set cursor off
void CurOff()
{
	u8 c = GetBoard(CurX, CurY);
	if ((c >= TILE_ONMIN) && (c <= TILE_ONMAX))
	{
		SetBoard(CurX, CurY, c - TILE_ONMIN + TILE_OFFMIN);
	}
}

// discovery stones in one direction (returns number of stones; cursor must be off)
u8 GetStones1(s8 x, s8 y, s8 dx, s8 dy)
{
	u8 c;
	u8 steps = 0;
	u8 stones = 0;
	do {
		// do step
		x += dx;
		y += dy;

		// if chicken, number of steps is valid
		c = GetBoard(x, y);
		if (c == TILE_CHICKEN) stones = steps;

		// increase number of steps
		steps++;

	// while tile is valid
	} while ((c == TILE_EGG) || (c == TILE_CHICKEN) || (c == TILE_HEN));

	return stones;
}

// discovery stones in all directions (returns number of stones; cursor must be off)
u8 GetStones(s8 x, s8 y)
{
	u8 stones = 0;
	int i;
	for (i = 0; i < 8; i++) stones += GetStones1(x, y, DirX[i], DirY[i]);
	return stones;
}

// display possible positions (cursor must be off)
void DispPos()
{
	s8 x, y;
	u8 stones;
	u8 c;

	// clear number of possible positions
	Pos = 0;

	// loop through all game tiles
	for (y = 0; y < BOARDH; y++)
	{
		for (x = 0; x < BOARDW; x++)
		{
			// check if this tile is empty
			c = GetBoard(x, y);
			if ((c == TILE_EMPTY) || (c == TILE_DOT))
			{
				// count number of stones
				if (GetStones(x, y) > 0)
				{
					// increase number of possible positions
					Pos++;
					SetBoard(x, y, TILE_DOT);
				}
				else
					SetBoard(x, y, TILE_EMPTY);
			}
		}
	}
}

// start open page (returns character)
u8 OpenScreen()
{
	int i;
	u8 ch;

	// draw title
	DrawClear(COL_BLACK);
	SelFont8x16();
	DrawText2("Eggs", (WIDTH - 4*16)/2, 0, COL_YELLOW);

#define MENUX 10
#define MENUY (32+4)
#define MENUDY 16
	// draw menu
	SelFont8x16();
	DrawText("Press key to start the game:", MENUX+16, MENUY + 0*MENUDY, COL_GREEN);
	DrawText("LEFT ...... Play for eggs", MENUX, MENUY+1*MENUDY, COL_WHITE);
	DrawText("RIGHT ..... Play for hens", MENUX, MENUY+2*MENUDY, COL_WHITE);
	DrawText("DOWN ...... 2 players", MENUX, MENUY+3*MENUDY, COL_WHITE);
	DrawText("UP ........ Demo", MENUX, MENUY+4*MENUDY, COL_WHITE);
	DrawText("Y ......... Return to game selection", MENUX, MENUY+5*MENUDY, COL_WHITE);

#define MENUY2 (MENUY+6*MENUDY+4)
	// draw game control
	DrawText("Game control:", MENUX+16, MENUY2+0*MENUDY, COL_GREEN);
	DrawText("arrows .... Move cursor", MENUX, MENUY2+1*MENUDY, COL_WHITE);
	DrawText("A ......... Put chicken", MENUX, MENUY2+2*MENUDY, COL_WHITE);
	DrawText("X ......... Hint tip", MENUX, MENUY2+3*MENUDY, COL_WHITE);
	DrawText("Y ......... Quit the game", MENUX, MENUY2+4*MENUDY, COL_WHITE);

	// display update
	DispUpdate();

	while (True)
	{
		// wait for a key
		ch = KeyGet();
		switch(ch)
		{
		// start game
		case KEY_LEFT:
		case KEY_RIGHT:
		case KEY_DOWN:
		case KEY_UP:
		case KEY_Y:
			return ch;
		}

		WaitMs(10);
	}
}

// display selected player
void DispSel()
{
	int play;
	int y = 0;
	for (play = 0; play < 2; play++)
	{
		// draw background
		DrawImg4Pal(FrameImg, FrameImg_Pal, 0, y, FRAMEX, y, FRAMEW, SELECTH, FRAMEW);

		// draw computer
		if (Comp[play]) DrawImg4Pal(ComputerImg, ComputerImg_Pal, 0, 0, COMPX, y+COMPY, COMPW, COMPH, COMPW);

		// draw selection frame
		if (play == Player) DrawBlit4Pal(SelectImg, SelectImg_Pal, 0, 0, SELECTX, y+SELECTY, SELECTW, SELECTH, SELECTW, COL_WHITE);

		// shift Y coordinate
		y += FRAMEY;
	}
	DispUpdate();
}

char NumBuf[20];

// display score
void DispScore()
{
	int play;
	int n;
	for (play = 0; play < 2; play++)
	{
		n = DecNum(NumBuf, Stones[play], 0);
		NumBuf[n++] = ' ';
		NumBuf[n++] = 0;
		DrawTextBg(NumBuf, SCOREX, SCOREY+play*FRAMEY, SCORECOL, SCOREBG);
	}
	DispUpdate();
}

// display wins
void DispWin()
{
	int play;
	int n;
	for (play = 0; play < 2; play++)
	{
		n = DecNum(NumBuf, Wins[play], 0);
		NumBuf[n++] = ' ';
		NumBuf[n++] = ' ';
		NumBuf[n++] = ' ';
		NumBuf[n++] = 0;
		DrawTextBg(NumBuf, WINX, WINY+play*FRAMEY, SCORECOL, SCOREBG);
	}
	DispUpdate();
}

// open game
void OpenGame(Bool comp1, Bool comp2)
{
	int i;

	// copy board template
	for (i = 0; i < BOARDSIZE; i++) Board[i] = 1;
	Board[3*8+3] = 4;
	Board[3*8+4] = 4;
	Board[4*8+3] = 4;
	Board[4*8+4] = 4;
	DrawBoard();

	// copy frame image
	DrawImg4Pal(FrameImg, FrameImg_Pal, 0, 0, FRAMEX, 0, FRAMEW, FRAMEH, FRAMEW);

	// initialize players
	Stones[0] = 0;
	Stones[1] = 0;
	Comp[0] = comp1;
	Comp[1] = comp2;

	// start random player
	Player = RandU8() & 1;

	// cursor position
	CurX = 3;
	CurY = 3;

	// initialize number of free positions
	Free = BOARDW*BOARDH-4;
	Pos = 12;

	// display selected player
	DispSel();

	// display score
	DispScore();

	// display wins
	DispWin();
}

// update stones in one direction
void PutStone1(s8 x, s8 y, s8 dx, s8 dy)
{
	u8 c;

	// check number of stones in this direction
	u8 stones = GetStones1(x, y, dx, dy);
	for (; stones > 0; stones--)
	{
		DrawBoard();

		// play sound and short delay
		KeyScan();
		PLAYSOUND(BeepSnd);
		WaitMs(100);

		// step
		x += dx;
		y += dy;

		// get tile
		c = GetBoard(x, y);

		// player 2 is active, direction egg -> chicken -> hen
		if (Player == 1)
		{
			// egg -> chicken
			if (c == TILE_EGG)
			{
				Stones[0]--; // decrease number of eggs of player 1
				c = TILE_CHICKEN; // change to chicken
			}

			// hen -> egg
			else if (c == TILE_HEN)
			{
				Stones[1]--; // decrease number of hens of player 2
				Stones[0]++; // increase number of eggs of player 1
				c = TILE_EGG;
			}

			// chicken -> hen
			else
			{
				Stones[1]++; // increase number of hens of player 2
				c = TILE_HEN;
			}
		}

		// player 1 is active, direction hen -> chicken -> egg
		else
		{
			// egg -> hen
			if (c == TILE_EGG)
			{
				Stones[0]--; // decrease number of effs of player 1
				Stones[1]++; // increase number of hens of player 2
				c = TILE_HEN;
			}

			// hen -> chicken
			else if (c == TILE_HEN)
			{
				Stones[1]--; // decrease number of hens of player 2
				c = TILE_CHICKEN;
			}

			// chicken -> egg
			else
			{
				Stones[0]++; // increase number of effs of player 1
				c = TILE_EGG;
			}
		}

		// set tile
		SetBoard(x, y, c);
		DrawBoard();

		// display score
		DispScore();
	}
}

// put stone (cursor must be off and current tile must be 'dot')
void PutStone()
{
	int i;

	// short blink cursor (must leave cursor off)
	for (i = 5; i > 0; i--)
	{
		DrawBoard();
		KeyScan();
		WaitMs(50);
		CurOn();
		DrawBoard();
		KeyScan();
		WaitMs(50);
		CurOff();
	}
	DrawBoard();

	// put chicken into current position
	SetBoard(CurX, CurY, TILE_CHICKEN);

	// decrease free positions
	Free--;

	// update stones in all directions
	for (i = 0; i < 8; i++) PutStone1(CurX, CurY, DirX[i], DirY[i]);
}

// get profit in one direction
s8 Profit1(s8 x, s8 y, s8 dx, s8 dy)
{
	u8 c;
	s8 profit = 0;

	// check number of stones in this direction
	u8 stones = GetStones1(x, y, dx, dy);
	for (; stones > 0; stones--)
	{
		// step
		x += dx;
		y += dy;

		// get tile
		c = GetBoard(x, y);

		// player 2 is active (egg -> chicken -> hen)
		if (Player == 1)
		{
			// this player loses hen, opposite gains egg
			if (c == TILE_HEN)
				profit -= 2;

			// this player gains hen or opposite loses egg
			else
				profit++;
		}

		// player 1 is active (hen -> chicken -> egg)
		else
		{
			// this player loses egg, opposite gains hen
			if (c == TILE_EGG)
				profit -= 2;

			// this player gains egg or opposite loses hen
			else
				profit++;
		}
	}
	return profit;
}

// get tile profit
s8 Profit(s8 x, s8 y)
{
	s8 profit = 0;
	int i;
	for (i = 0; i < 8; i++) profit += Profit1(x, y, DirX[i], DirY[i]);
	return profit;
}

// find best position (cursor must be off)
void FindPos()
{
	s8 x, y;
	u8 c;
	s8 bestprofit = -125; // profit of founded tiles
	s8 profit;

	// loop through all game tiles
	for (y = 0; y < BOARDH; y++)
	{
		for (x = 0; x < BOARDW; x++)
		{
			// check if this tile is valid
			c = GetBoard(x, y);
			if (c == TILE_DOT)
			{
				// get profit of this field
				profit = Profit(x, y);

				// check better profit
				if ((profit > bestprofit) ||
					((profit == bestprofit) && (RandU8() < 80)))
				{
					// save new best state
					bestprofit = profit;
					CurX = x;
					CurY = y;
				}
			}
		}
	}
}

// play game
void PlayGame(Bool comp1, Bool comp2)
{
	int i;
	char ch;
	s8 x, y;

	// demo mode
	Bool demo = comp1 && comp2;

	// open game
	OpenGame(comp1, comp2);

	// display possible positions
	DispPos();

	// display cursor on
	CurOn();
	DrawBoard();

	// while there is some possible position
	while ((Pos > 0) && (Free > 0))
	{
		// wait for a key
		ch = KeyGet();

		// break demo
		if (demo && (ch != NOKEY)) return;

		// player is computer
		if (Comp[Player])
		{
			// find position
			CurOff();
			FindPos();
			CurOn();
			DrawBoard();

			// put stone
			if (!demo) FlushChar();
			ch = KEY_A;
		}

		switch (ch)
		{
		// break game
		case KEY_Y:
			return;

		// right
		case KEY_RIGHT:
			if (CurX < BOARDW-1)
			{
				CurOff();
				CurX++;
				CurOn();
				DrawBoard();
			}
			break;

		// up
		case KEY_UP:
			if (CurY > 0)
			{
				CurOff();
				CurY--;
				CurOn();
				DrawBoard();
			}
			break;

		// left
		case KEY_LEFT:
			if (CurX > 0)
			{
				CurOff();
				CurX--;
				CurOn();
				DrawBoard();
			}
			break;

		// down
		case KEY_DOWN:
			if (CurY < BOARDH-1)
			{
				CurOff();
				CurY++;
				CurOn();
				DrawBoard();
			}
			break;

		// help
		case KEY_X:
			CurOff();
			FindPos();
			CurOn();
			DrawBoard();
			break;

		// put stone
		case KEY_A:
			CurOff();
			if (GetBoard(CurX, CurY) == TILE_DOT)
			{
				// put stone
				PutStone();

				// update possible positions
				DispPos();

				// change player
				Player ^= 1;

				// display selected player
				DispSel();

				// display score
				DispScore();
			}
			CurOn();
			DrawBoard();
			break;

		// no key, short delay
		case NOKEY:
			WaitMs(50);
			break;

		// invalid key
		default:
			break;
		}

		// blinking cursor
		CurBlink++;
		if (CurBlink == 5)
		{
			CurOff();
			DrawBoard();
		}

		if (CurBlink == 8)
		{
			CurOn();
			DrawBoard();
		}
	}

	// cursor off
	CurOff();

	// select no player
	Player = 2;
	DispSel();

	// max. time of blinking
	i = demo ? 10 : 1000000000;

	// player 1 (eggs) wins
	if (Stones[0] > Stones[1])
	{
		// animate
		for (y = 0; y < 8; y++)
		{
			for (x = 0; x < 8; x++)
			{
				if (GetBoard(x, y) == TILE_EGG)
				{
					SetBoard(x, y, TILE_EGGWIN);
					PLAYSOUND(Beep2Snd);
					DrawBoard();
					WaitMs(200);
				}
			}
		}

		// display wins
		Wins[0]++;
		DispWin();

		// blink winner
		for (; i > 0; i--)
		{
			Player = 0;
			DispSel();
			DrawBoard();
			WaitMs(200);
			if (KeyGet() != NOKEY) return;
			Player = 2;
			DispSel();
			DrawBoard();
			WaitMs(200);
			if (KeyGet() != NOKEY) return;
		}
	}

	// player 2 (hens) wins
	else if (Stones[1] > Stones[0])
	{
		// animate
		for (y = 0; y < 8; y++)
		{
			for (x = 0; x < 8; x++)
			{
				if (GetBoard(x, y) == TILE_HEN)
				{
					SetBoard(x, y, TILE_HENWIN);
					PLAYSOUND(Beep2Snd);
					DrawBoard();
					WaitMs(200);
				}
			}
		}

		// display wins
		Wins[1]++;
		DispWin();

		// blink winner
		for (; i > 0; i--)
		{
			Player = 1;
			DispSel();
			DrawBoard();
			WaitMs(200);
			if (KeyGet() != NOKEY) return;
			Player = 2;
			DispSel();
			DrawBoard();
			WaitMs(200);
			if (KeyGet() != NOKEY) return;
		}
	}

	// no winner
	else
	{
		// blink winner
		for (; i > 0; i--)
		{
			Player = 0;
			DispSel();
			DrawBoard();
			WaitMs(200);
			if (KeyGet() != NOKEY) return;
			Player = 1;
			DispSel();
			DrawBoard();
			WaitMs(200);
			if (KeyGet() != NOKEY) return;
		}
	}
}

// main function
int main()
{
	char ch;

	// main loop
	while (True)
	{
		// open screen
		ch = OpenScreen();

		// start new game
		switch (ch)
		{
		// player is EGG
		case KEY_LEFT:
			PlayGame(False, True);
			break;

		// player is HEN
		case KEY_RIGHT:
			PlayGame(True, False);
			break;

		// demo
		case KEY_UP:
			PlayGame(True, True);
			break;

		// 2 players
		case KEY_DOWN:
			PlayGame(False, False);
			break;

		// quit
		case KEY_Y:
			return 0;
		}
	}
}
