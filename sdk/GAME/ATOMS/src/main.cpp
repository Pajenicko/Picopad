
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

// players
sPlayer	Players[PLAYER_NUM] = {	// players
	{ PLAYER_HUMAN,	3*MAPW+3, 0, 0,	COL_RED,		0 },
	{ PLAYER_COMP,	3*MAPW+6, 0, 0,	COL_YELLOW,		0 },
	{ PLAYER_OFF,	6*MAPW+3, 0, 0,	COL_GREEN,		0 },
	{ PLAYER_OFF,	6*MAPW+6, 0, 0,	RGBTO16(0, 160, 255),	0 },
	{ PLAYER_OFF,	9*MAPW+3, 0, 0,	COL_MAGENTA,		0 }
};

int Player;	// current active players
int PlayerNum;	// number of active players
u32 CurTime;	// cursor blinking time
int PlayerHuman; // number of human players

// board
u8	Atoms[MAPSIZE];	// number of atoms
u8	Owner[MAPSIZE]; // owner of field

// player type
const char* const PlayerTypeTxt[3] = {
	"not playing",
	"HUMAN",
	"COMPUTER",
};

// open screen (returns False to quit game)
Bool Open()
{
	char ch;
	int i;

	Player = 0;
	KeyFlush();

	while (True)
	{
		DrawClear(COL_BLACK);
		SelFont8x16();
		DrawText2("Exploding Atoms", (WIDTH - 15*16)/2, 15, COL_YELLOW);

#define MENUX 10
#define MENUY 70
#define MENUDY 20
		DrawText("Setup players:", MENUX, MENUY - 10, COL_WHITE);

		DrawText("LEFT ..... Player 1 is", MENUX, MENUY+1*MENUDY, Players[0].color);
		DrawText("UP ....... Player 2 is", MENUX, MENUY+2*MENUDY, Players[1].color);
		DrawText("RIGHT .... Player 3 is", MENUX, MENUY+3*MENUDY, Players[2].color);
		DrawText("DOWN ..... Player 4 is", MENUX, MENUY+4*MENUDY, Players[3].color);
		DrawText("B ........ Player 5 is", MENUX, MENUY+5*MENUDY, Players[4].color);

		DrawText("A ........ Start The Game", MENUX, MENUY+6*MENUDY+10, COL_WHITE);

		for (i = 0; i < PLAYER_NUM; i++) DrawText(PlayerTypeTxt[Players[i].type],
							MENUX+23*8, MENUY+(i+1)*MENUDY, Players[i].color);

		ch = KeyGet();
		switch (ch)
		{
		case KEY_LEFT:
			Players[0].type++;
			if (Players[0].type > 2) Players[0].type = 0;
			break;

		case KEY_UP:
			Players[1].type++;
			if (Players[1].type > 2) Players[1].type = 0;
			break;

		case KEY_RIGHT:
			Players[2].type++;
			if (Players[2].type > 2) Players[2].type = 0;
			break;

		case KEY_DOWN:
			Players[3].type++;
			if (Players[3].type > 2) Players[3].type = 0;
			break;

		case KEY_B:
			Players[4].type++;
			if (Players[4].type > 2) Players[4].type = 0;
			break;

		case KEY_A:
			return True;

		case KEY_Y:
			return False;
		}

		DispUpdate();
	}
}

// display score of one player
void DispScore(u8 player)
{
	int len;

	// clear row
	DrawRect(INFOX+3, Players[player].scorey + 16, INFOW-7, 15, INFOBG);

	// zero - player lost
	if (Players[player].atoms == 0)
	{
		DrawText("-lost-", INFOX + (INFOW - 6*8)/2, Players[player].scorey + 16, Players[player].color);
	}

	// player is winner
	else if (PlayerNum == 1)
	{
		DrawText("WINNER", INFOX + (INFOW - 6*8)/2, Players[player].scorey + 16, Players[player].color);
	}
	else
	{
		// decode number of atoms
		len = DecUNum(DecNumBuf, Players[player].atoms, 0);

		// display score
		DrawText(DecNumBuf, INFOX + (INFOW - len*8)/2, Players[player].scorey + 16, Players[player].color);
	}
}

char PlayerText[] = "Player 1";

// display score table
void DispScoreTab()
{
	int i;
	DrawRect(INFOX, 0, INFOW, HEIGHT, INFOBG);
	for (i = 0; i < PLAYER_NUM; i++)
	{
		if (Players[i].type != PLAYER_OFF) // player is in game
		{
			PlayerText[7] = i + '1';
			DrawText(PlayerText, INFOX + (INFOW - 8*8)/2, Players[i].scorey, Players[i].color);
			DispScore(i);
		}
	}
}

// display score table with selection (blinking on end of game)
void DispScoreSel()
{
	DispScoreTab();
	if ((PlayerNum > 1) || (((Time() >> 17) & 1) == 1))
	{
		int y = Players[Player].scorey - 2;
		DrawFrame(INFOX+2, y, INFOW-5, 36, Players[Player].color);
	}
}

// display one tile
void DispTile(u8 inx, Bool cursor)
{
	// prepare number of atoms
	u8 n = Atoms[inx];
	if (n > 4) n = 4;

	// owner
	u8 owner = Owner[inx];

	// coordinates
	int y = inx / MAPW;
	int x = inx - y*MAPW;
	y *= TILEH;
	x *= TILEW;

	// index of tile image
	inx = 0;
	if (n > 0) inx = n + owner*4;

	// display tile
	DrawImg4Pal(AtomsImg, AtomsImg_Pal, 0, inx*TILEH, x, y, TILEW, TILEH, TILEW);

	// display cursor
	if (cursor) DrawFrame(x+1, y+1, TILEW-2, TILEH-2, Players[Player].color);
}

// display board
void DispBoard()
{
	int i;
	for (i = 0; i < MAPSIZE; i++) DispTile(i, False);
}

// display cursor of active player (blinking)
void DispCur()
{
	DispTile(Players[Player].cursor, (((Time() - CurTime) >> 17) & 3) < 3);
}

// hide cursor of active player
void DispCurOff()
{
	DispTile(Players[Player].cursor, False);
}

// new game
void NewGame()
{
	int i;

	KeyFlush();
	DrawClear(COL_BLACK);

	// clear board
	for (i = 0; i < MAPSIZE; i++)
	{
		Atoms[i] = 0;
		Owner[i] = 0;
	}

	// setup start condition
	PlayerNum = 0;
	PlayerHuman = 0;
	for (i = 0; i < PLAYER_NUM; i++)
	{
		// check if player is active
		if (Players[i].type != PLAYER_OFF)
		{
			Players[i].atoms = 1; // number of atoms
			Players[i].scorey = PlayerNum*48+8; // score Y coordinate
			PlayerNum++;
			Atoms[Players[i].start] = 1; // 1 default atom
			Owner[Players[i].start] = i; // atom owner
			Players[i].cursor = Players[i].start; // cursor
			if (Players[i].type == PLAYER_HUMAN) PlayerHuman++; // count of human players
		}
		else
			Players[i].atoms = 0; // player is not active, no atoms
	}

	// display board
	DispBoard();

	// display score table with selection
	DispScoreSel();

	// display update
	DispUpdate();
}

// catch neighbour (add 1 own electron)
void Catch(u8 inx)
{
	u8 n = Atoms[inx];
	u8 own = Owner[inx];

	// not empty atom of enemy player
	if ((n > 0) && (own != Player))
	{
		// subtract atoms from enemy
		Players[own].atoms -= n;
		DispScore(own);

		// add atoms to player
		Players[Player].atoms += n;
		DispScore(Player);

		// enemy lost
		if (Players[own].atoms == 0) PlayerNum--;
	}

	// increase atoms
	Atoms[inx] = n+1;
	Owner[inx] = Player;

	// display atom
	DispTile(inx, False);
}

// explosions
void Explo()
{
	int x, y, i, n;
	u8 mx;
	do {
		// count exploding atoms (note: player does not need to be tested,
		//	no other player can have an exploding atom at this time)
		n = 0;
		for (y = 0; y < MAPH; y++)
		{
			for (x = 0; x < MAPW; x++)
			{
				// field index
				i = y*MAPW+x;

				// prepare maximum of atom
				mx = 4;
				if ((x == 0) || (x == MAPW-1)) mx--;
				if ((y == 0) || (y == MAPH-1)) mx--;

				// check exploding atom
				if (Atoms[i] >= mx) n++;
			}
		}

		// stop, no explosion
		if (n == 0) break;

		// select random atom to explode
		n = RandS16Max(n - 1);

		// find exploding atom
		for (y = 0; y < MAPH; y++)
		{
			for (x = 0; x < MAPW; x++)
			{
				// field index
				i = y*MAPW+x;

				// prepare maximum of atom
				mx = 4;
				if ((x == 0) || (x == MAPW-1)) mx--;
				if ((y == 0) || (y == MAPH-1)) mx--;

				// found exploding atom
				if (Atoms[i] >= mx)
				{
					n--;
					if (n < 0)
					{
						// decrease this field
						Atoms[i] -= mx;
						DispTile(i, False);

						// catch neighbours
						if (x > 0) Catch(i-1);
						if (x < MAPW-1) Catch(i+1);
						if (y > 0) Catch(i-MAPW);
						if (y < MAPH-1) Catch(i+MAPW);

						// update display
						PLAYSOUND(CrashSnd);
						DispUpdate();
						WaitMs(80);
						break;
					}
				}
			}
			if (n < 0) break;
		}

	// if 1 player left and board is too full, the explosions might never end
	}while (PlayerNum > 1);
}

// auto-play (search cursor)
void Auto()
{
	u8 bestsize = 0;
	int bestnum = 0;
	int i;
	DispCurOff();


	// find best atom size and count
	for (i = 0; i < MAPSIZE; i++)
	{
		if (Owner[i] == Player)
		{
			if (Atoms[i] > bestsize)
			{
				bestsize= Atoms[i];
				bestnum = 1;
			}
			else if (Atoms[i] == bestsize) bestnum++;			
		}
	}

	// select field
	bestnum = RandU8Max(bestnum-1);
	for (i = 0; ; i++)
	{
		if ((Owner[i] == Player) && (Atoms[i] == bestsize))
		{
			bestnum--;
			if (bestnum < 0) break;
		}
	}

	// set cursor to this field
	Players[Player].cursor = i;

	// display cursor for a while
	DispTile(i, True);

	// display update
	DispUpdate();
	WaitMs(200);
}

// game
void Game()
{
	int cur;
	u8 ch;

	// cursor time
	CurTime = Time();

	while (True)
	{
		// break demo
		if (PlayerHuman == 0)
		{
			if (KeyGet() != NOKEY) return;
		}

		// auto player
		if (Players[Player].type == PLAYER_COMP)
		{
			Auto();
			ch = KEY_A;
		}
		else
			ch = KeyGet();

		// keyboard control
		cur = Players[Player].cursor;

		switch (ch)
		{
		// cursor left
		case KEY_LEFT:
			DispCurOff();
			cur--;
			if ((cur < 0) || ((cur % MAPW) == MAPW-1)) cur += MAPW;
			CurTime = Time();
			break;

		// cursor right
		case KEY_RIGHT:
			DispCurOff();
			cur++;
			if ((cur % MAPW) == 0) cur -= MAPW;
			CurTime = Time();
			break;

		// cursor up
		case KEY_UP:
			DispCurOff();
			cur -= MAPW;
			if (cur < 0) cur += MAPSIZE;
			CurTime = Time();
			break;

		// cursor down
		case KEY_DOWN:
			DispCurOff();
			cur += MAPW;
			if (cur >= MAPSIZE) cur -= MAPSIZE;
			CurTime = Time();
			break;

		case KEY_A: // put atom
			// check color
			if ((Atoms[cur] == 0) || (Owner[cur] == Player))
			{
				Owner[cur] = Player;
				Atoms[cur]++;
				Players[Player].atoms++;
				DispTile(cur, False);
				DispScore(Player);

				// explosions
				Explo();

				// end of game
				if (PlayerNum < 2)
				{
					// hide cursor of active player
					DispCurOff();
					DispUpdate();

					// report end of game
					KeyFlush();
					while (KeyGet() == NOKEY)
					{
						// display score selection (blinking on end of game)
						DispScoreSel();
						DispUpdate();
					}
					return;
				}

				// change player
				do {
					Player++;
					if (Player >= PLAYER_NUM) Player = 0;
				} while (Players[Player].atoms == 0);

				cur = Players[Player].cursor;

				DispScoreSel();
				CurTime = Time();
			}
			break;

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif

		case KEY_Y:	// quit game
			return;

		}
		Players[Player].cursor = cur;

		// blinking cursor
		DispCur();

		// display update
		DispUpdate();
	}

}

// main function
int main()
{
	while (True)
	{
		// open screen
		if (!Open()) ResetToBootLoader();

		// start new game
		NewGame();

		// game (check number of selected players)
		if (PlayerNum > 1) Game();
	}
}
