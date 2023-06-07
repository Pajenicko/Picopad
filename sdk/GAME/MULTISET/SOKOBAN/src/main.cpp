
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// wait for a character
char WaitChar()
{
	char c;
	while ((c = KeyGet()) == NOKEY) {}
	return c;
}

int main()
{
	u8 ch;
	while (True)
	{
		// set text mode
		SetTileMode(0);

		// draw title
		DrawClear(COL_BLACK);
		SelFont8x16();
		DrawText2("Sokoban", (WIDTH - 7*16)/2, 0, COL_YELLOW);

#define MENUX 10
#define MENUY 60
#define MENUDY 16
		DrawText("Game control:", MENUX+16, MENUY+0*MENUDY, COL_GREEN);
		DrawText("arrows .......... Move", MENUX, MENUY+1*MENUDY, COL_WHITE);
		DrawText("B ............... Restart scene", MENUX, MENUY+2*MENUDY, COL_WHITE);
		DrawText("X ............... Solution of the scene", MENUX, MENUY+3*MENUDY, COL_WHITE);
		DrawText("Left/Right+A .... Prev/next scene", MENUX, MENUY+4*MENUDY, COL_WHITE);
		DrawText("Up+A ............ Fast mode", MENUX, MENUY+5*MENUDY, COL_WHITE);
		DrawText("Down+A .......... Slow mode", MENUX, MENUY+6*MENUDY, COL_WHITE);
		DrawText("Y ............... Quit the game", MENUX, MENUY+7*MENUDY, COL_WHITE);

		DrawText("Press key 'A' to start the game", MENUX+16, MENUY+8*MENUDY, COL_GREEN);

		DispUpdate();

		do ch = KeyGet(); while (ch == NOKEY);

		if (ch == KEY_Y) break;
		if (ch == KEY_A)
		{
			// select level
			while (LevSelect())
			{
				// game loop
				GameLoop();
			}
		}
	}

	return 0;
}
