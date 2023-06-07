
// ****************************************************************************
//
//                                 Scene
//
// ****************************************************************************

#include "../include.h"

int SceneSetInx = 0;	// current scene set index (0..)
int SceneSetNum;	// number of levels in current scene set
int SceneInx = 0;	// current scene index (0..)
int SceneBase = 1;	// number of first scene in current scene set
const sSceneSet* SceneSet; // current scene set
const u8* Scene;	// current scene

// ckeck wall in scene definition
Bool ParseSceneWall(u8 x, u8 y)
{
	// frame
	if ((x < 1) || (x >= MAPW-1) || (y < 1) || (y >= MAPH-1)) return True;

	// map coordinates
	x--;
	y--;
	int wb = 5; // number of bytes per row

	// wall map type 2x2
	if (SceneSet->height == 10)
	{
		x /= 2;
		y /= 2;
		wb = 3;
	}

	// check wall map
	return (Scene[y*wb + x/8] & (0x80 >> (x & 7))) != 0;
}

// parse scene and display game screen
void ParseScene()
{
	u8 x, y;
	int i, n;

	// current scene set
	const sSceneSet* sets = &SceneSets[SceneSetInx];
	SceneSet = sets;
	SceneBase = sets->first;

	// current scene
	const u8* s = sets->list[SceneInx];
	Scene = s;

	// parse walls
	for (y = 0; y < MAPH; y++)
	{
		for (x = 0; x < MAPW; x++)
		{
			if (ParseSceneWall(x, y))
				DispTileSign(WALLTILE, x, y, WALL);
			else
				DispTileSign(SPACETILE, x, y, SPACE);
		}
	}

	// skip wall map
	s += (sets->height == 10) ? (3*10) : (5*20);

	// parse red balls
	n = *s++;
	RedBallsNum = n;
	for (i = 0; i < n; i++)
	{
		RedBalls[i].state = LIVE;
		RedBalls[i].x = *s++;
		RedBalls[i].y = *s++;
		RedBalls[i].phase = 0;
		DispTileSign(REDBALLTILE, RedBalls[i].x, RedBalls[i].y, REDBALL + i);
	}

	// parse blue enemies
	n = *s++;
	BlueEnemiesNum = n;
	for (i = 0; i < n; i++)
	{
		BlueEnemies[i].state = LEFT;
		BlueEnemies[i].x = *s++;
		BlueEnemies[i].y = *s++;
		BlueEnemies[i].phase = 0;
		DispTileSign(BLUEENEMYLEFT1, BlueEnemies[i].x, BlueEnemies[i].y, BLUEENEMY + i);
	}

	// parse red enemies
	n = *s++;
	RedEnemiesNum = n;
	for (i = 0; i < n; i++)
	{
		RedEnemies[i].state = DOWN;
		RedEnemies[i].x = *s++;
		RedEnemies[i].y = *s++;
		RedEnemies[i].phase = 0;
		DispTileSign(REDENEMYDOWN1, RedEnemies[i].x, RedEnemies[i].y, REDENEMY + i);
	}

	// parse mushrooms
	n = *s++;
	MushroomsNum = n;
	for (i = 0; i < n; i++)
	{
		Mushrooms[i].state = LIVE;
		Mushrooms[i].x = *s++;
		Mushrooms[i].y = *s++;
		Mushrooms[i].phase = 0;
		DispTileSign(MUSHROOMTILE, Mushrooms[i].x, Mushrooms[i].y, MUSHROOM + i);
	}

	// load blue ball
	BlueBall.state = LIVE;
	BlueBall.x = *s++;
	BlueBall.y = *s++;
	BlueBall.phase = 0;
	DispTileSign(BLUEBALLTILE, BlueBall.x, BlueBall.y, BLUEBALL);

	// load blue wall
	x = *s++;
	y = *s++;
	DispTileSign(BLUEWALLTILE, x, y, BLUEWALL);
	DispTileSign(BLUEWALLTILE, x+1, y, BLUEWALL);
}

// initialize new game of current scene
void NewGame(Bool init)
{
	// de-randomize random generator
	//   Do not change seed value 123456789 - solution macros are tuned to this value
	RandomSet(123456789);

// --- prepare scene

	// initialize base game variables
	LastTime = Time();
	if (init)
	{
		Score = 0;
		Lives = 5;
	}
	GameTime = 1500;
	MushroomsStock = 0;
	Macro = NULL;
	MacroRep = 0;

// --- show screen with scene number

	// clear screen
	DrawClear(COL_BLACK);

	// draw all walls
	int x, y;
	for (y = -3; y < MAPH; y++)
		for (x = 0; x < MAPW; x++)
			DispTile(WALLTILE, x, y);

	// clear header
	DrawRect(BOARDX+12*STEP, BOARDY+STEP, 14*STEP, 2*STEP, COL_BLACK);
	DrawRect(BOARDX+27*STEP, BOARDY+STEP, 12*STEP, 2*STEP, COL_BLACK);

	// titles
	DispTile(TEXTSCORE, 13, -2);
	DispTile(TEXTTIME, 28, -2);
	//DispTile(TEXTDBSOFT, 29, -1);
	DispTile(TEXTREDSCENE, 28, -1);

	// display score
	DispScore();

	// display time
	DispTime();

	// display scene number
	DispSceneNum();

	// display lives
	DispLives();

	// decode scene number
	int n = DecUNum(DecNumBuf, SceneInx+SceneBase, 0);
	x = (MAPW - (6 + n))/2;
	y = MAPH/2;

	// display scene text
	DispTile(TEXTYELSCENE, x, y);
	x += 5;
	DispTile(SPACETILE, x, y);

	// display scene number
	int i;
	for (i = 0; i < n; i++)
	{
		x++;
		DispTile(DIGIT0+(DecNumBuf[i]-'0'), x, y);
	}

	// wait
	WaitTime(750);

// --- parse scene and show game screen

	// parse scene and show game screen
	ParseScene();

	// display update
	DispUpdate();
	WaitTime(3*TIMESTEP);

// --- chicken go out of home

	// chicken jumps down
	DispTile(CHICKENJUMPING2, 1, -2); // low
	WaitTime(TIMESTEP);
	ClearTile(CHICKENJUMPING2, 1, -2); // low

	for (y = -1; y <= 1; y++)
	{
		DispTile(CHICKENJUMPING1, 1, y); // high
		WaitTime(TIMESTEP);

		DispTile(CHICKENJUMPING2, 1, y); // low
		WaitTime(TIMESTEP);
		ClearTile(CHICKENJUMPING2, 1, y); // low
	}

	DispTileSign(CHICKENDOWN1, 1, 1, CHICKEN);
	DispTileSign(WALLTILE, 1, 0, WALL);
	DispTileSign(WALLTILE, 2, 0, WALL);
	WaitTime(3*TIMESTEP);

	Chicken.state = DOWN;
	Chicken.x = 1;
	Chicken.y = 1;
	Chicken.phase = 0;

	// rest of chickens go left
	if (Lives > 1)
	{
		int x0 = 3;

		for (x = x0; x < x0+(Lives-1)*2; x += 2) DispTile(CHICKENLEFT1, x, -2);
		WaitTime(2*TIMESTEP);

		for (n = 2; n > 0; n--)
		{
			ClearTile(CHICKENLEFT1, x0+(Lives-2)*2, -2);
			x0--;

			for (x = x0; x < x0+(Lives-1)*2; x += 2) DispTile(CHICKENLEFT2, x, -2);
			WaitTime(TIMESTEP);

			for (x = x0; x < x0+(Lives-1)*2; x += 2) DispTile(CHICKENLEFT1, x, -2);
			WaitTime(TIMESTEP);
		}

		for (x = 1; x < 1+(Lives-1)*2; x += 2)
		{
			DispTile(CHICKENDOWN1, x, -2);
			WaitTime(2*TIMESTEP);
		}
		WaitTime(2*TIMESTEP);
	}
}
