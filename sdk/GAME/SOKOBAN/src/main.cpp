
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

#ifdef AUTOMODE		// automode - autorun all levels to check solutions
// DEBUG: auto mode, to check all levels
void AutoMode()
{
	int abslevel = 1;	// absolute level
	char buf[12];

	// select first author
	AutInx = 0;
	AutName = Author[0].author; // author's name
	Collect = Author[0].collect; // pointer to list of collections
	CollNum = Author[0].collnum; // number of collections

	// select first collection
	CollInx = 0;
	CollName = Collect[0].name; // name of collection
	Levels = Collect[0].levels; // pointer to list of levels
	LevNum = Collect[0].levnum; // number of levels

	// select first level
	Level = 0;
	LevDef = Levels[0]; // current level definition
	LevSolve = Levels[1]; // current level solve

	// check all levels	
	for (;;)
	{
		// display level info
		LevelInfo();

		// display absolute level number
		DecNum(buf, abslevel, 0);
		DrawText(buf, 0, 5*FONTH, COL_YELLOW);
		DispUpdate();
		WaitMs(100);

		// solve level
		PlaySolve();
		WaitMs(100);

		// check if solved
		if (MarkNum != 0)
		{
			LevelInfo();
			DrawText("ERROR!", 0, 5*FONTH, COL_RED);
			DispUpdate();
			break;
		}

		// increase scene level
		Level++;
		if (Level >= LevNum)
		{
			// next collection of current author
			int c = CollInx + 1;
			if (c < CollNum)
			{
				CollInx = c; // select next collection
				Level = 0; // selected level
				CollName = Collect[c].name; // name of collection
				Levels = Collect[c].levels; // pointer to list of levels
				LevNum = Collect[c].levnum; // number of levels
			}

			// else next author
			else
			{
				// next author
				int a = AutInx + 1;
				if (a < AutNum)
				{
					AutInx = a;
					CollInx = 0; // selected collection
					AutName = Author[a].author; // author's name
					Collect = Author[a].collect; // pointer to list of collections
					CollNum = Author[a].collnum; // number of collections

					Level = 0; // selected level
					CollName = Collect[0].name; // name of collection
					Levels = Collect[0].levels; // pointer to list of levels
					LevNum = Collect[0].levnum; // number of levels
				}
				// else stop
				else
				{
					SetTileMode(0);
					pDrawFont = FontBold8x16;
					DrawFontHeight = 16;
					DecNum(buf, abslevel, 0);
					DrawText(buf, 0, 0, COL_YELLOW);
					DrawText2("ALL OK", 100, 6*FONTH, COL_GREEN);
					DispUpdate();
					break;
				}
			}
		}
		abslevel++;
	}
}
#endif // AUTOMODE		// automode - autorun all levels to check solutions

int main()
{
	int i;

	// DEBUG: auto mode, to check all levels
#ifdef AUTOMODE		// automode - autorun all levels to check solutions
	AutoMode();
#else
	// set text mode
	SetTileMode(0);
	DispUpdate();

	// main loop
	AutInx = 0;
	while (True)
	{
		int oldaut = AutInx;

		// play demo level
		while (True)
		{
			// play demo scene
			LevNum = 0;
			Levels = IntroLevel;
			Level = 0;
			if (PlaySolve()) break;
			SolvedAnim(False);

			// play random scene
			do {
				i = RandU8Max(AutNum-1);
				AutInx = i;
				AutName = Author[i].author; // author's name
				Collect = Author[i].collect; // pointer to list of collections
				CollNum = Author[i].collnum; // number of collections

				i = RandU8Max(CollNum-1);
				CollInx = i;
				CollName = Collect[i].name; // name of collection
				Levels = Collect[i].levels; // pointer to list of levels
				LevNum = Collect[i].levnum; // number of levels

				i = RandU16Max(LevNum-1);
				Level = i;
				LevDef = Levels[i*2]; // current level definition
				LevSolve = Levels[i*2+1]; // current level solve

				BoardDim();

			} while ((LevelW > 15) || (LevelH > 12));
			if (PlaySolve()) break;
			SolvedAnim(False);
		}

		if (KeyPressed(KEY_Y)) ResetToBootLoader();

		AutInx = oldaut;

		// select author
		while (AuthorSelect())
		{
			// select collection
			while (CollSelect())
			{
				// select level
				while (LevSelect())
				{
					// game loop
					GameLoop();
				}
			}
		}
	}
#endif // AUTOMODE
}
