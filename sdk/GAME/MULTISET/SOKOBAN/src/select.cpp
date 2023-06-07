
// ****************************************************************************
//
//                                 Select
//
// ****************************************************************************

#include "../include.h"

const char SelLevel[] = "Select Level";

#define LEVW	(4*8)	// width of one level
#define ROWLEV	(WIDTH/LEVW) // number of level columns per row

// print 1 level
void LevSelect1(int inx)
{
	// prepare coordinates on screen
	int y = inx / ROWLEV;
	int x = (inx - y*ROWLEV)*LEVW;
	y = y * DrawFontHeight + FONTH + 4;

	// prepare color
	u16 col = COL_WHITE;
	u16 bgcol = COL_BLACK;
	if (inx == Level)
	{
		col = COL_BLACK;
		bgcol = COL_WHITE;
	}

	// clear row
	DrawRect(x, y, LEVW, FONTH, bgcol);

	// display number
	char buf[12];
	int n = DecNum(buf, inx+1, 0);
	DrawText(buf, x + (LEVW - n*8)/2, y, col);
}

// select level (returns True = OK, False = Esc)
Bool LevSelect()
{
	// set text mode
	SetTileMode(0);

	// set font
	SelFont8x16();

	// draw title
	DrawRect(0, 0, WIDTH, FONTH, COL_YELLOW);
	DrawText(SelLevel, (WIDTH-(sizeof(SelLevel)-1)*FONTW)/2, 0, COL_BLACK);

	// print list of levels
	int i;
	for (i = 0; i < LevNum; i++)
	{
		LevSelect1(i);
	}

	// select
	char c;
	int j;
	for (;;)
	{
		// redraw display
		DispUpdate();

		// get character
		c = WaitChar();

		switch (c)
		{
		case KEY_UP:
			i = Level;
			Level = -1;
			LevSelect1(i);
			i -= ROWLEV;
			if (i < 0)
			{
				do i += ROWLEV; while (i < LevNum);
				i -= ROWLEV;
				if (i < 0) i += ROWLEV;
			}
			Level = i;
			LevSelect1(i);

			LevDef = Levels[i*2]; // current level definition
			LevSolve = Levels[i*2+1]; // current level solve
			break;

		case KEY_LEFT:
			i = Level;
			Level = -1;
			LevSelect1(i);
			i--;
			if (i < 0) i = LevNum-1;
			Level = i;
			LevSelect1(i);

			LevDef = Levels[i*2]; // current level definition
			LevSolve = Levels[i*2+1]; // current level solve
			break;

		case KEY_DOWN:
			i = Level;
			Level = -1;
			LevSelect1(i);
			i += ROWLEV;
			if (i >= LevNum)
			{
				do i -= ROWLEV; while (i >= 0);
				i += ROWLEV;
				if (i >= LevNum) i -= ROWLEV;
			}
			Level = i;
			LevSelect1(i);

			LevDef = Levels[i*2]; // current level definition
			LevSolve = Levels[i*2+1]; // current level solve
			break;

		case KEY_RIGHT:
			i = Level;
			Level = -1;
			LevSelect1(i);
			i++;
			if (i > LevNum-1) i = 0;
			Level = i;
			LevSelect1(i);

			LevDef = Levels[i*2]; // current level definition
			LevSolve = Levels[i*2+1]; // current level solve
			break;

		case KEY_A: // select
			LevDef = Levels[i*2]; // current level definition
			LevSolve = Levels[i*2+1]; // current level solve
			return True;

		case KEY_X:
		case KEY_Y:
		case KEY_B: // Esc
			return False;
		}
	}

	// redraw display
	DispUpdate();
	return False;
}
