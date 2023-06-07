
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

void game()
{
	int i;
	u8 ch;

	// clear screen
	DrawClear(COL_BLACK);

	// set first scene
	Level = LEVFIRST;
	Score = 0;

	// loop with demo scene
	while (True)
	{
		// demo
		i = Level; // save current level

		while (True)
		{
			// play demo scene 0
			Level = 0;
			ch = HelpLevel();
			if (ch == 2) return;
			if (ch != 0) break;

#ifdef AUTOMODE // automode - run levels to check solutions (help completes scene)
			break;
#endif

			// play random scene
			Level = RandU8MinMax(1, LEVNUM);

			ch = HelpLevel();
			if (ch == 2) return;
			if (ch != 0) break;
		}

		// return current level
		Level = i;
		InitLevel();

		// main loop
		while (True)
		{
			// game loop - called every single game step
			ch = GameLoop();
			if (ch == 2) return;
			if (ch != 0) break;

			// wait step
			WaitStep();
		}
	}
}

int main()
{
	u8 ch;
	while (True)
	{
		// draw title
		DrawClear(COL_BLACK);
		SelFont8x16();
		DrawText2("Train", (WIDTH - 4*16)/2, 0, COL_YELLOW);

#define MENUX 10
#define MENUY 60
#define MENUDY 16
		DrawText("Game control:", MENUX+16, MENUY+0*MENUDY, COL_GREEN);
		DrawText("arrows .......... Move train", MENUX, MENUY+1*MENUDY, COL_WHITE);
		DrawText("A ............... Enter password", MENUX, MENUY+2*MENUDY, COL_WHITE);
		DrawText("B ............... Restart scene", MENUX, MENUY+3*MENUDY, COL_WHITE);
		DrawText("X ............... Help solve scene", MENUX, MENUY+4*MENUDY, COL_WHITE);
		DrawText("Y ............... Quit the game", MENUX, MENUY+5*MENUDY, COL_WHITE);
		DrawText("Press key 'A' to start the game", MENUX+16, MENUY+6*MENUDY, COL_GREEN);

		DispUpdate();

		do ch = KeyGet(); while (ch == NOKEY);
		if (ch == KEY_Y) break;
		if (ch == KEY_A) game();
	}
	return 0;
}
