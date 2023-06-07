
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

// main function
int main()
{
	Bool sel;

	while (True)
	{
		// draw title
		DrawClear(COL_BLACK);
		SelFont8x16();
		DrawText2("Ants", (WIDTH - 4*16)/2, 0, COL_YELLOW);

		// game goal
		SelFont6x8();
		DrawText("The aim of the game is to build a castle with", (WIDTH - (72-27)*6)/2, 32, RGBTO16(0, 186, 255));
		DrawText("height of 100, or to destroy opponent's castle.", (WIDTH - (74-27)*6)/2, 40, RGBTO16(0, 186, 255));

#define MENUX 10
#define MENUY (48)
#define MENUDY 16
		// draw menu
		SelFont8x16();
		DrawText("Press key to start the game:", MENUX+16, MENUY + 0*MENUDY, COL_GREEN);
		DrawText("LEFT ...... Play with black ants", MENUX, MENUY+1*MENUDY, COL_WHITE);
		DrawText("RIGHT ..... Play with red ants", MENUX, MENUY+2*MENUDY, COL_WHITE);
		DrawText("DOWN ...... 2 players", MENUX, MENUY+3*MENUDY, COL_WHITE);
		DrawText("UP ........ Demo", MENUX, MENUY+4*MENUDY, COL_WHITE);
		DrawText("Y ......... Return to game selection", MENUX, MENUY+5*MENUDY, COL_WHITE);

#define MENUY2 (MENUY+6*MENUDY)
		// draw game control
		DrawText("Game control:", MENUX+16, MENUY2+0*MENUDY, COL_GREEN);
		DrawText("LEFT/RIGHT ...... Move cursor", MENUX, MENUY2+1*MENUDY, COL_WHITE);
		DrawText("DOWN or A ....... Select card", MENUX, MENUY2+2*MENUDY, COL_WHITE);
		DrawText("UP or B ......... Discard card", MENUX, MENUY2+3*MENUDY, COL_WHITE);
		DrawText("X ............... Hint tip", MENUX, MENUY2+4*MENUDY, COL_WHITE);
		DrawText("Y ............... Quit the game", MENUX, MENUY2+5*MENUDY, COL_WHITE);

		// display update
		DispUpdate();

		// key
		sel = False;
		do {
			switch (KeyGet())
			{
			case KEY_LEFT:
				Game(False, True, False);
				sel = True;
				break;

			case KEY_RIGHT:
				Game(True, False, False);
				sel = True;
				break;

			case KEY_DOWN:
				Game(False, False, False);
				sel = True;
				break;

			case KEY_UP:
				Game(True, True, False);
				sel = True;
				break;

			case KEY_Y:
				return 0;
			}

			// short delay
			WaitMs(10);

		} while (!sel);

		KeyFlush();
	}
}
