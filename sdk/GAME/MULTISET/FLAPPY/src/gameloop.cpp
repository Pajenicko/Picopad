
// ****************************************************************************
//
//                                 Game Loop
//
// ****************************************************************************

#include "../include.h"

int Score;		// current score
int GameTime;		// current game time
u32 LastTime;		// last wait time

const char* Macro;	// macro (NULL=not playing)
char MacroCh;		// macro next character
int MacroRep;		// macro repeater

// sync wait and display update
void WaitTime(int ms)
{
	DispUpdate();
	ms *= 1000;
	u32 t;
	do { t = Time(); KeyScan(); } while ((u32)(t - LastTime) < ms);
	LastTime = t;
}

// display number with number of digits
void DispNum(int num, int x, int y, int dignum)
{
	// decode number into temporary buffer
	int n = DecUNum(DecNumBuf, num, 0);

	// overflow - display '9'
	if (n > dignum)
	{
		for (; dignum > 0; dignum--)
		{
			DispTile(DIGIT9, x, y);
			x++;
		}
		return;
	}

	// display zeroes
	dignum -= n;
	for (; dignum > 0; dignum--)
	{
		DispTile(DIGIT0, x, y);
		x++;
	}

	// display digits
	char* s = DecNumBuf;
	for (; n > 0; n--)
	{
		DispTile(DIGIT0 + (*s++ - '0'), x, y);
		x++;
	}
}

// display score
void DispScore()
{
	DispNum(Score, 19, -2, 6);
}

// display time
void DispTime()
{
	DispNum(GameTime, 33, -2, 5);
}

// display scene number
void DispSceneNum()
{
	DispNum(SceneInx+SceneBase, 34, -1, 3);
}

// check game end (returns True = game finished)
Bool CheckGameEnd()
{
	int i;

	// check conditions
	if ((Chicken.state >= LIVE) &&
		ISBLUEWALL(GetSign(BlueBall.x, BlueBall.y+2)) &&
		ISBLUEWALL(GetSign(BlueBall.x+1, BlueBall.y+2)))
	{
		Macro = NULL;
		MacroRep = 0;

		// chicken jump
		WaitTime(150);
		for (i = 0; i < 3; i++)
		{
			DispChicken(CHICKENJUMPING1);
			WaitTime(150);
			DispChicken(CHICKENJUMPING2);
			WaitTime(30);
			DispChicken(CHICKENDOWN1);
			WaitTime(100);
		}
		WaitTime(80);

		// count mushrooms
		while (MushroomsStock > 0)
		{
			Score += 10;
			MushroomsStock--;
			DispScore();
			DispMushrooms();
			WaitTime(20);
		}

		// count time
		while (GameTime > 0)
		{
			GameTime -= 13;
			if (GameTime < 0) GameTime = 0;
			DispTime();
			Score += 10;
			DispScore();
			WaitTime(15);
		}

		WaitTime(200);

		// clear screen
		DrawRect(MAPX+STEP, MAPY+STEP, (MAPW-2)*STEP, (MAPH-2)*STEP, COL_BLACK);

		// chicken return home
		int destx = (Lives-1)*2 + 1;
		while (Chicken.x != destx)
		{
			ClearChicken();
			if (destx < Chicken.x)
				Chicken.x--;
			else
				Chicken.x++;
			DispChicken(CHICKENGOHOME);
			WaitTime(7);
		}

		while (Chicken.y > 0)
		{
			ClearChicken();
			Chicken.y--;
			DispChicken(CHICKENGOHOME);
			WaitTime(7);
		}
		ClearChicken();
		WaitTime(7);

		DispTile(CHICKENDOWN1, destx, -2);
		WaitTime(100);
		return True;
	}
	return False;
}

// game loop (return True = continue to next level, False = break)
Bool GameLoop()
{
	char ch;
	while (True)
	{
		// keyboard input
		ch = KeyGet();

		// stop macro
		if ((ch != NOKEY) && (Macro != NULL))
		{
			Macro = NULL;
			MacroRep = 0;
			ch = NOKEY;
		}

		switch(ch)
		{
		// Y quit
		case KEY_Y:
			return False;

		// X macro
		case KEY_X:
			if ((SceneSet->solution != NULL) && (SceneInx < SceneSet->solutionnum))
			{
				NewGame(False);
				Macro = SceneSet->solution[SceneInx];
				MacroRep = 0;
			}
			break;
		}

		// chicken move, phase 1
		ChickenMove1();

		// move (or crash) balls
		MoveBalls();

		// check game end
		if (CheckGameEnd()) return True;

		// blue enemy move, phase 1
		BlueEnemyMove1();

		// red enemy move, phase 1
		RedEnemyMove1();

		// decrease game time
		if (GameTime > 0)
		{
			GameTime--;
			DispTime();
		}

		// sleep		
		WaitTime(TIMESTEP);

		// chicken move, phase 2
		ChickenMove2();

		// move (or crash) balls
		MoveBalls();

		// check game end
		if (CheckGameEnd()) return True;

		// fire mushroom (must be after phase 2 of chicken move)
		FireMushroom();

		// move mushrooms
		MoveMushrooms();

		// blue enemy move, phase 2
		BlueEnemyMove2();

		// red enemy move, phase 2
		RedEnemyMove2();

		// sleep
		WaitTime(TIMESTEP);

		// dead
		if (((Chicken.state == CRASHED) || (Chicken.state == EATEN)) && (Chicken.phase >= 25))
		{
			if (Lives <= 0) return False;
			NewGame(False);
		}
	}
}
