
// ****************************************************************************
//
//                                 Select
//
// ****************************************************************************

#include "../include.h"

const char SelSceneSet[] = "Select Scene Set";

const char SelSet[] = "Scene Set:";
const char SelLevel[] = "Select Scene";

#define SETY	50
#define SETH	134

// redraw one scene set
void SetSelect1(int inx)
{
	// prepare coordinates on screen
	int y = inx*FONTH + SETY + FONTH + 3;

	// pointer to scene set
	const sSceneSet* set = &SceneSets[inx];

	// prepare color
	u16 col = COL_WHITE;
	u16 bgcol = COL_BLACK;
	if (inx == SceneSetInx)
	{
		col = COL_BLACK;
		bgcol = COL_WHITE;
	}

	// clear row
	DrawRect(1, y, WIDTH-2, FONTH, bgcol);

	// print collection name
	DrawText(set->name, 2, y, col);
}

// select scene set (returns True = OK, False = Esc)
Bool SetSelect()
{
	// set font
	SelFont8x16();

	// clear screen
	DrawClear(COL_BLACK);

	// draw title
	DrawText2("Flappy", (WIDTH - 6*16)/2, 0, COL_YELLOW);
	DrawText("Flappy MZ-800 (c) dB-Soft 1984", (WIDTH - 30*8)/2, 32, COL_CYAN);

	// draw title bar
	DrawRect(0, SETY, WIDTH, FONTH, COL_YELLOW);
	DrawText(SelSceneSet, (WIDTH-(sizeof(SelSceneSet)-1)*FONTW)/2, SETY, COL_BLACK);

	// draw frame
	DrawRect(0, SETY+FONTH, 1, SETH-FONTH, COL_YELLOW); // left
	DrawRect(WIDTH-1, SETY+FONTH, 1, SETH-FONTH, COL_YELLOW); // right
	DrawRect(0, SETY+SETH-1, WIDTH, 1, COL_YELLOW); // bottom

	// print list of collections
	int i;
	for (i = 0; i < SCENESET_NUM; i++)
	{
		SetSelect1(i);
	}

	// select
	char c;
	int j;
	for (;;)
	{
		// redraw display
		DispUpdate();

		// get character
		c = KeyGet();

		switch (c)
		{
		case KEY_LEFT:
		case KEY_UP:
			i = SceneSetInx;
			SceneSetInx = -1;
			SetSelect1(i); // clear old selection
			i--;
			if (i < 0) i = SCENESET_NUM-1;
			SceneSetInx = i;
			SetSelect1(i); // display new selection

			SceneInx = 0; // selected level
			SceneSet = &SceneSets[SceneSetInx];
			SceneBase = SceneSet->first;
			SceneSetNum = SceneSet->num; // number of levels in current scene set
			break;

		case KEY_RIGHT:
		case KEY_DOWN:
			i = SceneSetInx;
			SceneSetInx = -1;
			SetSelect1(i); // clear old selection
			i++;
			if (i > SCENESET_NUM-1) i = 0;
			SceneSetInx = i;
			SetSelect1(i); // display new selection

			SceneInx = 0; // selected level
			SceneSet = &SceneSets[SceneSetInx];
			SceneBase = SceneSet->first;
			SceneSetNum = SceneSet->num; // number of levels in current scene set
			break;

		case KEY_A: // OK enter
			SceneInx = 0; // selected level
			SceneSet = &SceneSets[SceneSetInx];
			SceneBase = SceneSet->first;
			SceneSetNum = SceneSet->num; // number of levels in current scene set
			return True;

		case KEY_X:
		case KEY_Y:
		case KEY_B:
			return False;
		}
	}

	// redraw display
	DispUpdate();
	return False;
}

#define LEVW	(4*8)	// width of one level
#define ROWLEV	(WIDTH/LEVW) // number of level columns per row (= 10)

// print 1 level
void LevSelect1(int inx)
{
	// prepare coordinates on screen
	int y = inx / ROWLEV;
	int x = (inx - y*ROWLEV)*LEVW;
	y = y * FONTH + 2*FONTH + 3;

	// prepare color
	u16 col = COL_WHITE;
	u16 bgcol = COL_BLACK;
	if (inx == SceneInx)
	{
		col = COL_BLACK;
		bgcol = COL_WHITE;
	}

	// clear row
	DrawRect(x, y, LEVW, FONTH, bgcol);

	// display number
	char buf[12];
	int n = DecNum(buf, inx+SceneBase, 0);
	DrawText(buf, x + (LEVW - n*8)/2, y, col);
}

// select level (returns True = OK, False = Esc)
Bool LevSelect()
{
	// set font
	SelFont8x16();

	// clear screen
	DrawClear(COL_BLACK);

	// print collection name
	DrawText(SelSet, 0, 0, COL_WHITE);
	DrawText(SceneSet->name, sizeof(SelSet)*8, 0, COL_GREEN);

	// draw title
	DrawRect(0, FONTH, WIDTH, FONTH, COL_YELLOW);
	DrawText(SelLevel, (WIDTH-(sizeof(SelLevel)-1)*FONTW)/2, FONTH, COL_BLACK);

	// print list of levels
	int i;
	for (i = 0; i < SceneSetNum; i++)
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
		c = KeyGet();

		switch (c)
		{
		case KEY_UP:
			i = SceneInx;
			SceneInx = -1;
			LevSelect1(i);
			i -= ROWLEV;
			if (i < 0)
			{
				do i += ROWLEV; while (i < SceneSetNum);
				i -= ROWLEV;
				if (i < 0) i += ROWLEV;
			}
			SceneInx = i;
			LevSelect1(i);
			break;

		case KEY_LEFT:
			i = SceneInx;
			SceneInx = -1;
			LevSelect1(i);
			i--;
			if (i < 0) i = SceneSetNum-1;
			SceneInx = i;
			LevSelect1(i);
			break;

		case KEY_DOWN:
			i = SceneInx;
			SceneInx = -1;
			LevSelect1(i);
			i += ROWLEV;
			if (i >= SceneSetNum)
			{
				do i -= ROWLEV; while (i >= 0);
				i += ROWLEV;
				if (i >= SceneSetNum) i -= ROWLEV;
			}
			SceneInx = i;
			LevSelect1(i);
			break;

		case KEY_RIGHT:
			i = SceneInx;
			SceneInx = -1;
			LevSelect1(i);
			i++;
			if (i > SceneSetNum-1) i = 0;
			SceneInx = i;
			LevSelect1(i);
			break;

		case KEY_A: // select
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
