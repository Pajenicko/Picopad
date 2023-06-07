
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

int main()
{
	int i;

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
			if (HelpLevel()) break; // break

#ifdef AUTOMODE // automode - run levels to check solutions (help completes scene)
			break;
#endif

			// play random scene
			Level = RandU8MinMax(1, LEVNUM);
			if (HelpLevel()) break; // break
		}

		if (KeyPressed(KEY_Y)) ResetToBootLoader();

		// return current level
		Level = i;
		InitLevel();

		// main loop
		while (True)
		{
			// game loop - called every single game step
			if (GameLoop()) break;

			// wait step
			WaitStep();
		}
	}
}
