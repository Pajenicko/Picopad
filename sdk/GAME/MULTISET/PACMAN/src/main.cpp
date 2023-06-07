
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

int main()
{
	int i;
	char ch;

	LastTime = Time();

	// loop with open screen
	MaxScore = 0;
	while (True)
	{
		// draw title
		DrawClear(COL_BLACK);
		SelFont8x16();
		DrawText2("PacMan", (WIDTH - 6*16)/2, 0, COL_YELLOW);

#define MENUX 10
#define MENUY 60
#define MENUDY 16
		DrawText("Game control:", MENUX+16, MENUY+0*MENUDY, COL_GREEN);
		DrawText("arrows .......... Move", MENUX, MENUY+1*MENUDY, COL_WHITE);
		DrawText("A ............... Pause", MENUX, MENUY+2*MENUDY, COL_WHITE);
		DrawText("Y ............... Quit the game", MENUX, MENUY+3*MENUDY, COL_WHITE);
		DrawText("Press key 'A' to start the game", MENUX+16, MENUY+4*MENUDY, COL_GREEN);

		DispUpdate();

		do ch = KeyGet(); while (ch == NOKEY);
		if (ch == KEY_Y) break;
		if (ch == KEY_A) OpenGame();
	}

	return 0;
}
