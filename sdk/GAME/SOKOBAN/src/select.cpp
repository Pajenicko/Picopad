
// ****************************************************************************
//
//                                 Select
//
// ****************************************************************************

#include "../include.h"

const char SelTitle[] = "Select Author";
const char SelTitleColl[] = "Collections";
const char SelTitleLev[] = "Levels";
const char SelTitleTotal[] = "Total";

const char SelAuthor[] = "Author:";
const char SelCollect[] = "Select Collection";

const char SelColl[] = "Collection:";
const char SelLevel[] = "Select Level";

#define AUTNAME_W	(21*8)	// width of author's name column
#define AUTCOLL_W	(12*8)	// width of column with number of collections
#define AUTLEV_W	(7*8)	// width of column with number of levels

#define COLNAME_W	(30*8)	// width of colection name column
#define COLLEV_W	(10*8)	// width of column with number of levels

#define LEVW	(4*8)	// width of one level
#define ROWLEV	(WIDTH/LEVW) // number of level columns per row

// redraw one author
int CollTotal;
int LevelTotal;
void AuthorSelect1(int inx)
{
	// prepare coordinates on screen
	int y = inx*FONTH + FONTH + 6;

	// pointer to author
	const sAuthor* aut = &Author[inx];

	// prepare color
	u16 col = COL_WHITE;
	u16 bgcol = COL_BLACK;
	if (inx == AutInx)
	{
		col = COL_BLACK;
		bgcol = COL_WHITE;
	}

	// clear row
	DrawRect(1, y, AUTNAME_W-1, FONTH, bgcol);
	DrawRect(AUTNAME_W+1, y, AUTCOLL_W-1, FONTH, bgcol);
	DrawRect(AUTNAME_W+AUTCOLL_W+1, y, AUTLEV_W-2, FONTH, bgcol);

	// print author's name
	DrawText(aut->author, 2, y, col);

	// print number of collections
	char buf[12];
	int n = DecNum(buf, aut->collnum, 0);
	CollTotal += aut->collnum;
	DrawText(buf, AUTNAME_W+2, y, col);

	// print number of levels
	int i, j;
	j = 0;
	for (i = 0; i < aut->collnum; i++) j += aut->collect[i].levnum;
	LevelTotal += j;
	n = DecNum(buf, j, 0);
	DrawText(buf, AUTNAME_W+AUTCOLL_W+2, y, col);
}

// select author (returns True = OK, False = Esc)
//  13 authors by 16 lines + 1 title = 224
Bool AuthorSelect()
{
	// set text mode
	SetTileMode(0);

	// draw title bar
	DrawRect(0, 0, WIDTH, FONTH, COL_YELLOW);

	// draw frame
	DrawRect(0, FONTH, 1, HEIGHT-FONTH-3, COL_YELLOW); // left
	DrawRect(AUTNAME_W, FONTH, 1, HEIGHT-FONTH-3, COL_YELLOW); 
	DrawRect(AUTNAME_W+AUTCOLL_W, FONTH, 1, HEIGHT-FONTH-3, COL_YELLOW);
	DrawRect(WIDTH-1, FONTH, 1, HEIGHT-FONTH-3, COL_YELLOW); // right
	DrawRect(0, HEIGHT-3, WIDTH, 1, COL_YELLOW); // bottom

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;

	// draw title
	DrawText(SelTitle, (AUTNAME_W-(sizeof(SelTitle)-1)*FONTW)/2, 0, COL_BLACK);
	DrawText(SelTitleColl, AUTNAME_W+(AUTCOLL_W-(sizeof(SelTitleColl)-1)*FONTW)/2, 0, COL_BLACK);
	DrawText(SelTitleLev, AUTNAME_W+AUTCOLL_W+(AUTLEV_W-(sizeof(SelTitleLev)-1)*FONTW)/2, 0, COL_BLACK);

	// print list of authors
	CollTotal = 0;
	LevelTotal = 0;
	int i;
	for (i = 0; i < AutNum; i++)
	{
		AuthorSelect1(i);
	}

	// set font
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;

	// print total
	DrawTextBg(SelTitleTotal, 6, HEIGHT-7, COL_YELLOW, COL_BLACK);
	char buf[12];
	i = DecNum(buf, AutNum, 0);
	DrawTextBg(buf, (AUTNAME_W-i*8)/2, HEIGHT-7, COL_YELLOW, COL_BLACK);
	i = DecNum(buf, CollTotal, 0);
	DrawTextBg(buf, AUTNAME_W+(AUTCOLL_W-i*8)/2, HEIGHT-7, COL_YELLOW, COL_BLACK);
	i = DecNum(buf, LevelTotal, 0);
	DrawTextBg(buf, AUTNAME_W+AUTCOLL_W+(AUTLEV_W-i*8)/2, HEIGHT-7, COL_YELLOW, COL_BLACK);

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;

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
		case KEY_LEFT:
		case KEY_UP:
			i = AutInx;
			AutInx = -1;
			AuthorSelect1(i); // clear old selection
			i--;
			if (i < 0) i = AutNum-1;
			AutInx = i;
			AuthorSelect1(i); // display new selection

			CollInx = 0; // selected collection
			AutName = Author[i].author; // author's name
			Collect = Author[i].collect; // pointer to list of collections
			CollNum = Author[i].collnum; // number of collections
			break;

		case KEY_RIGHT:
		case KEY_DOWN:
			i = AutInx;
			AutInx = -1;
			AuthorSelect1(i); // clear old selection
			i++;
			if (i > AutNum-1) i = 0;
			AutInx = i;
			AuthorSelect1(i); // display new sleection

			CollInx = 0; // selected collection
			AutName = Author[i].author; // author's name
			Collect = Author[i].collect; // pointer to list of collections
			CollNum = Author[i].collnum; // number of collections
			break;

		case KEY_A: // OK enter
			CollInx = 0; // selected collection
			AutName = Author[AutInx].author; // author's name
			Collect = Author[AutInx].collect; // pointer to list of collections
			CollNum = Author[AutInx].collnum; // number of collections
			return True;

		case KEY_X:
		case KEY_Y:
		case KEY_B: // Escape
			return False;
		}
	}

	// redraw display
	DispUpdate();
	return False;
}

// redraw one collection
void CollSelect1(int inx)
{
	// prepare coordinates on screen
	int y = inx*DrawFontHeight + 2*16 + 6;

	// pointer to collection
	const sCollect* coll = &Collect[inx];

	// prepare color
	u16 col = COL_WHITE;
	u16 bgcol = COL_BLACK;
	if (inx == CollInx)
	{
		col = COL_BLACK;
		bgcol = COL_WHITE;
	}

	// clear row
	DrawRect(1, y, COLNAME_W-1, DrawFontHeight, bgcol);
	DrawRect(COLNAME_W+1, y, COLLEV_W-2, DrawFontHeight, bgcol);

	// print collection name
	DrawText(coll->name, 2, y, col);

	// print number of levels
	LevelTotal += coll->levnum;
	char buf[12];
	int n = DecNum(buf, coll->levnum, 0);
	DrawText(buf, COLNAME_W+2, y, col);
}

// select collection (returns True = OK, False = Esc)
Bool CollSelect()
{
	// set text mode
	SetTileMode(0);

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;

	// print author's name
	DrawText(SelAuthor, 0, 0, COL_WHITE);
	DrawText(AutName, sizeof(SelAuthor)*8, 0, COL_GREEN);

	// draw title bar
	DrawRect(0, FONTH, WIDTH, FONTH, COL_YELLOW);

	// draw frame
	DrawRect(0, 2*FONTH, 1, HEIGHT-2*FONTH-3, COL_YELLOW); // left
	DrawRect(COLNAME_W, 2*FONTH, 1, HEIGHT-2*FONTH-3, COL_YELLOW); 
	DrawRect(WIDTH-1, 2*FONTH, 1, HEIGHT-2*FONTH-3, COL_YELLOW); // right
	DrawRect(0, HEIGHT-3, WIDTH, 1, COL_YELLOW); // bottom

      	// draw title
	DrawText(SelCollect, (COLNAME_W-(sizeof(SelCollect)-1)*FONTW)/2, FONTH, COL_BLACK);
	DrawText(SelTitleLev, COLNAME_W+(COLLEV_W-(sizeof(SelTitleLev)-1)*FONTW)/2, FONTH, COL_BLACK);

	// prepare small font (remaining space for rows: HEIGHT - 2*16 - 6 - 6 = 196)
	if (CollNum > 12)
	{
		pDrawFont = FontBold8x14;
		DrawFontHeight = 14;

		if (CollNum > 14)
		{
			pDrawFont = FontBold8x8;
			DrawFontHeight = 8;
		}
	}

	// print list of collections
	LevelTotal = 0;
	int i;
	for (i = 0; i < CollNum; i++)
	{
		CollSelect1(i);
	}

	// set font
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;

	// print total
	DrawTextBg(SelTitleTotal, 6, HEIGHT-7, COL_YELLOW, COL_BLACK);
	char buf[12];
	i = DecNum(buf, CollNum, 0);
	DrawTextBg(buf, (COLNAME_W-i*8)/2, HEIGHT-7, COL_YELLOW, COL_BLACK);
	i = DecNum(buf, LevelTotal, 0);
	DrawTextBg(buf, COLNAME_W+(COLLEV_W-i*8)/2, HEIGHT-7, COL_YELLOW, COL_BLACK);

	// prepare font (remaining space for rows: HEIGHT - 2*16 - 6 - 6 = 196)
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;
	if (CollNum > 12)
	{
		pDrawFont = FontBold8x14;
		DrawFontHeight = 14;

		if (CollNum > 14)
		{
			pDrawFont = FontBold8x8;
			DrawFontHeight = 8;
		}
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
		case KEY_LEFT:
		case KEY_UP:
			i = CollInx;
			CollInx = -1;
			CollSelect1(i); // clear old selection
			i--;
			if (i < 0) i = CollNum-1;
			CollInx = i;
			CollSelect1(i); // display new selection

			Level = 0; // selected level
			CollName = Collect[i].name; // name of collection
			Levels = Collect[i].levels; // pointer to list of levels
			LevNum = Collect[i].levnum; // number of levels
			break;

		case KEY_RIGHT:
		case KEY_DOWN:
			i = CollInx;
			CollInx = -1;
			CollSelect1(i); // clear old selection
			i++;
			if (i > CollNum-1) i = 0;
			CollInx = i;
			CollSelect1(i); // display new selection

			Level = 0; // selected level
			CollName = Collect[i].name; // name of collection
			Levels = Collect[i].levels; // pointer to list of levels
			LevNum = Collect[i].levnum; // number of levels
			break;

		case KEY_A: // OK enter
			Level = 0; // selected level
			CollName = Collect[CollInx].name; // name of collection
			Levels = Collect[CollInx].levels; // pointer to list of levels
			LevNum = Collect[CollInx].levnum; // number of levels
			return True;

		case KEY_X:
		case KEY_Y:
		case KEY_B: // Escape
			return False;
		}
	}

	// redraw display
	DispUpdate();
	return False;
}

// print 1 level
void LevSelect1(int inx)
{
	// prepare coordinates on screen
	int y = inx / ROWLEV;
	int x = (inx - y*ROWLEV)*LEVW;
	y = y * DrawFontHeight + 3*16 + 6;

	// prepare color
	u16 col = COL_WHITE;
	u16 bgcol = COL_BLACK;
	if (inx == Level)
	{
		col = COL_BLACK;
		bgcol = COL_WHITE;
	}

	// clear row
	DrawRect(x, y, LEVW, DrawFontHeight, bgcol);

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
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;

	// print author's name
	DrawText(SelAuthor, 0, 0, COL_WHITE);
	DrawText(AutName, sizeof(SelAuthor)*8, 0, COL_GREEN);

	// print collection name
	DrawText(SelColl, 0, FONTH, COL_WHITE);
	DrawText(CollName, sizeof(SelColl)*8, FONTH, COL_GREEN);

	// draw title
	DrawRect(0, 2*FONTH, WIDTH, FONTH, COL_YELLOW);
	DrawText(SelLevel, (WIDTH-(sizeof(SelLevel)-1)*FONTW)/2, 2*FONTH, COL_BLACK);

	// prepare small font (remaining space for rows: HEIGHT - 3*16 - 6 = 186)
	if (LevNum > 11*ROWLEV)
	{
		pDrawFont = FontBold8x14;
		DrawFontHeight = 14;

		if (LevNum > 13*ROWLEV)
		{
			pDrawFont = FontBold8x8;
			DrawFontHeight = 8;
		}
	}

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
