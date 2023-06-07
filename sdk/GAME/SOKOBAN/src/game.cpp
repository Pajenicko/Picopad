
// ****************************************************************************
//
//                                Game engine
//
// ****************************************************************************

#include "../include.h"

// buffers
u8 Board[MAPWMAX*MAPHMAX]; // game board
int MapW, MapH;		// current board dimension
int TileSize;		// current tile size (4, 8, 12, 16, 20, 24, 28 or 32, 0=text)

// current game state
u16 MarkNum;		// number of remaining marks
u8 LevelW, LevelH;	// level width and height
u8 LevelX, LevelY;	// level coordinates
u8 PosX, PosY;		// player coordinates
#ifdef AUTOMODE // automode - autorun all levels to check solutions
Bool FastMode = True;	// fast mode
#else
Bool FastMode = False;	// fast mode
#endif

// tile image
const u16* TilesImgPal = NULL;
const u8* TilesImg = NULL;
int TilesImgW;

// player save screen
u16 SaveScr[32*32];
Bool SaveScrOn = False; // screen is saved
int SaveScrX, SaveScrY; // screen coordinate

// set tile/text mode, 0 = text mode
void SetTileMode(int tilesize)
{
	// align tile size to multiply of 4
	if ((tilesize > 0) && (tilesize < 4)) tilesize = 4;
	if (tilesize > 32) tilesize = 32;
	tilesize &= ~3;
	TileSize = tilesize;

	// set tiles
	switch (tilesize)
	{
	case 32:
		TilesImgPal = Tiles32Img_Pal;
		TilesImg = Tiles32Img;
		break;

	case 28:
		TilesImgPal = Tiles28Img_Pal;
		TilesImg = Tiles28Img;
		break;

	case 24:
		TilesImgPal = Tiles24Img_Pal;
		TilesImg = Tiles24Img;
		break;

	case 20:
		TilesImgPal = Tiles20Img_Pal;
		TilesImg = Tiles20Img;
		break;

	case 16:
		TilesImgPal = Tiles16Img_Pal;
		TilesImg = Tiles16Img;
		break;

	case 12:
		TilesImgPal = Tiles12Img_Pal;
		TilesImg = Tiles12Img;
		break;

	case 8:
		TilesImgPal = Tiles8Img_Pal;
		TilesImg = Tiles8Img;
		break;

	default: // 4
		TilesImgPal = Tiles4Img_Pal;
		TilesImg = Tiles4Img;
		break;
	}
	TilesImgW = tilesize*TILES_NUM;

	if (tilesize > 0)
	{
		// board dimension
		MapW = WIDTH / tilesize;
		MapH = HEIGHT / tilesize;
	}

	// clear screen
	DrawClear(COL_BLACK);

	// flush keyboard
	KeyFlush();
}

// display one tile of the board
void DispTile(u8 x, u8 y)
{
	u8 tile = Board[x + y*MapW];
	DrawImg4Pal(TilesImg, TilesImgPal, tile*TileSize, 0,
		x*TileSize + LevelX, y*TileSize + LevelY, TileSize, TileSize, TilesImgW);
}

// display all tiles
void DispBoard()
{
	int x, y;
	for (y = 0; y < MapH; y++)
	{
		for (x = 0; x < MapW; x++) DispTile(x, y);
	}
	SaveScrOn = False; // screen is not saved
}

// put tile on the board
void PutTile(u8 x, u8 y, u8 tile)
{
	Board[x + y*MapW] = tile;
	DispTile(x, y);
}

// get tile
u8 GetTile(u8 x, u8 y)
{
	if (((u32)x >= (u32)MapW) || ((u32)y >= (u32)MapH)) return EMPTY;
	return Board[x + y*MapW];
}

// player save screen (x,y graphics coordinate)
void SavePlayer(int x, int y)
{
	SaveScrOn = True;
	SaveScrX = x;
	SaveScrY = y;

	u16* d = SaveScr;
	u16* s = &FrameBuf[x + y*WIDTH];
	int h;
	for (h = TileSize; h > 0; h--)
	{
		memcpy(d, s, TileSize*2);
		d += TileSize;
		s += WIDTH;
	}
}

// restore player save screen
void RestorePlayer()
{
	if (SaveScrOn) DrawImg(SaveScr, SaveScrX, SaveScrY, TileSize, TileSize, TileSize);
}

// set player graphics position
void SetPlayer(int x, int y, u8 tile)
{
	x += LevelX;
	y += LevelY;
	RestorePlayer();
	SavePlayer(x, y);
	DrawBlit4Pal(TilesImg, TilesImgPal, tile*TileSize, 0, x, y, TileSize, TileSize, TilesImgW, TRANSCOL);
}

// soft move player in direction
void MovePlayer(u8 dir)
{
	int dx = (dir == DIR_L) ? -1 : ((dir == DIR_R) ? 1 : 0);
	int dy = (dir == DIR_U) ? -1 : ((dir == DIR_D) ? 1 : 0);
	int x = PosX*TileSize;
	int y = PosY*TileSize;
	u8 tile = FACE_R + dir*4;

	SetPlayer(x, y, tile);
	DispUpdate();
	WaitMs(MOVESPEED);
	KeyScan();

	if (!FastMode)
	{
		x += dx*(TileSize/4);
		y += dy*(TileSize/4);
	
		SetPlayer(x, y, tile+1);
		DispUpdate();
		WaitMs(MOVESPEED);
		KeyScan();
		x += dx*(TileSize/4);
		y += dy*(TileSize/4);

		SetPlayer(x, y, tile+2);
		DispUpdate();
		WaitMs(MOVESPEED);
		KeyScan();
		x += dx*(TileSize/4);
		y += dy*(TileSize/4);

		SetPlayer(x, y, tile+3);
		DispUpdate();
		WaitMs(MOVESPEED);
		KeyScan();
		x += dx*(TileSize/4);
		y += dy*(TileSize/4);
	}

	PosX += dx;
	PosY += dy;
	SetPlayer(PosX*TileSize, PosY*TileSize, tile);
	DispUpdate();
}

// clear board
void ClearBoard()
{
	memset(Board, EMPTY, MAPWMAX*MAPHMAX);
}

// detect board dimension
void BoardDim()
{
	LevDef = Levels[Level*2]; // current level definition
	LevSolve = Levels[Level*2+1]; // current level solve

	// get board definition
	const char* s = LevDef;

	// detect board dimension
	LevelW = 1;
	LevelH = 0;
	int i = 0;
	char ch;
	const char* s2 = s;
	while ((ch = *s2++) != 0)
	{
		// next row
		if ((ch == '!') || (ch == '|'))
		{
			LevelH++;
			if (i > LevelW) LevelW = i;
			i = 0;
		}
		else
			i++;
	}
	if (i > LevelW) LevelW = i;
	if (i > 0) LevelH++;
};


// initialize current level
//   x = grass (empty)
//   # = wall
//   ! or | = next row
//   space or _ or - = floor
//   $ or b = box
//   * or B = box on mark
//   . = mark
//   @ or p = player
//   + or P = player on mark
void LevelInit()
{
	// detect board dimension
	BoardDim();

	// initialize tile size
	TileSize = 32;
	while ((LevelW*TileSize > WIDTH) || (LevelH*TileSize > HEIGHT)) TileSize -= 4;
	if (TileSize < 4) TileSize = 4;
	SetTileMode(TileSize);
	LevelX = (MapW - LevelW)*TileSize/2;
	LevelY = (MapH - LevelH)*TileSize/2;

	// clear board
	ClearBoard();

	// decode level
	char ch;
	int x, y;
	MarkNum = 0;
	PosX = LevelW/2;
	PosY = LevelH/2;
	u8* d = Board;
	const char* s = LevDef;
	x = 0;
	y = 0;
	while ((ch = *s++) != 0)
	{
		// next row
		if ((ch == '!') || (ch == '|'))
		{
			y++;
			if (y >= MapH) break;
			x = 0;
			d = BoardAddr(x,y);
		}
		else
		{
			if (x >= MapW) continue;
	
			switch (ch)
			{
			// grass (empty)
			case 'x':
				ch = EMPTY;
				break;

			// wall
			case '#':
				ch = WALL;
				break;

			// player
			case 'p':
			case '@':
				PosX = x;
				PosY = y;
				ch = FLOOR;
				break;

			// player on mark
			case 'P':
			case '+':
				PosX = x;
				PosY = y;
				ch = MARK;
				MarkNum++;
				break;

			// box
			case 'b':
			case '$':
				ch = CRATE;
				break;

			// box on mark
			case 'B':
			case '*':
				ch = FULL;
				break;

			// mark
			case '.':
				ch = MARK;
				MarkNum++;
				break;

			// floor
			// case ' ':
			// case '_':
			// case '-':
			default:
				ch = FLOOR;
				break;
			}

			// increase position
			*d++ = ch;
			x++;
		}
	}

	// display board
	DispBoard();

	// set player, direction down
	SetPlayer(PosX*TileSize, PosY*TileSize, FACE_D);

	// display update
	DispUpdate();

	// flush keys
	KeyFlush();
}

// check floor (with or without mark, but no box)
Bool IsFloor(u8 x, u8 y)
{
	u8 tile = GetTile(x, y);
	return (tile == FLOOR) || (tile == MARK);
}

// check box (with or without mark)
Bool IsBox(u8 x, u8 y)
{
	u8 tile = GetTile(x, y);
	return (tile == CRATE) || (tile == FULL);
}

// check mark (with or without box)
Bool IsMark(u8 x, u8 y)
{
	u8 tile = GetTile(x, y);
	return (tile == MARK) || (tile == FULL);
}

// hide box
void HideBox(u8 x, u8 y)
{
	u8 tile = GetTile(x, y);
	if (tile == FULL)
	{
		MarkNum++;
		PutTile(x, y, MARK);
	}
	else
	{
		PutTile(x, y, FLOOR);
	}
}

// show box
void ShowBox(u8 x, u8 y)
{
	u8 tile = GetTile(x, y);
	if (tile == MARK)
	{
		MarkNum--;
		PutTile(x, y, FULL);
	}
	else
	{
		PutTile(x, y, CRATE);
	}
}

// step one level (key = move key, returns False on unsupported key)
Bool Step(char key)
{
	int dx = (key == KEY_LEFT) ? -1 : ((key == KEY_RIGHT) ? 1 : 0);
	int dy = (key == KEY_UP) ? -1 : ((key == KEY_DOWN) ? 1 : 0);
	if (dx + dy == 0) return False;

	if (IsBox(PosX+dx, PosY+dy) && (IsFloor(PosX+2*dx, PosY+2*dy)))
	{
		HideBox(PosX+dx, PosY+dy);
		ShowBox(PosX+2*dx, PosY+2*dy);
	}
	int dir = (key == KEY_LEFT) ? DIR_L :
		((key == KEY_RIGHT) ? DIR_R :
		((key == KEY_UP) ? DIR_U : DIR_D));
	if (IsFloor(PosX+dx, PosY+dy)) MovePlayer(dir);

	return True;
}

// step solve animation (return True = break)
Bool StepAnim(char key)
{
	if ((key >= 'a') && (key <= 'z')) key -= 32;
	if (key == 'L')
		Step(KEY_LEFT);
	else if (key == 'R')
		Step(KEY_RIGHT);
	else if (key == 'U')
		Step(KEY_UP);
	else if (key == 'D')
		Step(KEY_DOWN);

#ifdef AUTOMODE // automode - autorun all levels to check solutions
	return False;
#else
	return (KeyGet() != NOKEY);
#endif
}

// play subanimation (in brackets; returns True = break)
Bool SubAnim(const char* s)
{
	int i;
	char ch;
	while ((ch = *s++) != 0)
	{
		// end of brackets
		if (ch == ')') break;

		// loop (except last passage of the loop)
		if ((ch >= '0') && (ch <= '9'))
		{
			i = ch - '0';
			for (; i > 1; i--) if (StepAnim(*s)) return True;
			continue;
		}

		if (StepAnim(ch)) return True;
	}
	return False;
}

// play level solve (returns True on break from keyboard)
Bool PlaySolve()
{
	int i;

	// re-initialize current level
	LevelInit();

	// prepare pointer to level solution
	const char* s = LevSolve;

	// macro loop
	char ch;
	while ((ch = *s++) != 0)
	{
		if ((ch == '(') || (ch == ')')) continue;

		// loop (except last passage of the loop)
		if ((ch >= '0') && (ch <= '9'))
		{
			i = ch - '0';
			ch = *s;
			if ((ch >= '0') && (ch <= '9'))
			{
				i = i*10 + (ch - '0');
				s++;
			}

			for (; i > 1; i--)
			{
				if (*s == '(')
				{
					if (SubAnim(s+1)) return True;
				}
				else
					if (StepAnim(*s)) return True;
			}
			continue;
		}

		// step
		if (StepAnim(ch)) return True;
	}

	return False;
}

// display solved animation (returns True if solved)
Bool SolvedAnim(Bool sound)
{
	// check if solved
	if (MarkNum > 0) return False;

	// play sound
	if (sound) PLAYSOUND(YippeeSnd);

	// animation
	int i, j;
	u8 x, y;
	u8 k;
	for (i = 5; i > 0; i--)
	{
		// hide boxes
		for (y = 0; y < MapH; y++)
		{
			for (x = 0; x < MapW; x++)
			{
				if (GetTile(x, y) == FULL) PutTile(x, y, MARK);
			}
		}

		// set player, direction down
		SetPlayer(PosX*TileSize, PosY*TileSize, FACE_WIN);

		// delay
		DispUpdate();
		WaitMs(100);

		// show boxes
		for (y = 0; y < MapH; y++)
		{
			for (x = 0; x < MapW; x++)
			{
				if (GetTile(x, y) == MARK) PutTile(x, y, FULL);
			}
		}

		// set down image
		SetPlayer(PosX*TileSize, PosY*TileSize, FACE_D);

		// delay
		DispUpdate();
		WaitMs(100);
	}

	while (PlayingSound()) {}
	StopSound();

	return True;
}

// level info
void LevelInfo()
{
	SetTileMode(0);

	// set font
	pDrawFont = FontBold8x16;
	DrawFontHeight = 16;

	// print author's name
	DrawText(SelAuthor, 0, FONTH, COL_WHITE);
	DrawText(AutName, 8*8, FONTH, COL_GREEN);

	// print collection name
	DrawText(SelColl, 0, 2*FONTH, COL_WHITE);
	DrawText(CollName, 12*8, 2*FONTH, COL_GREEN);

	// print level number
	DrawText("LEVEL:", 0, 3*FONTH, COL_WHITE);
	char buf[12];
	DecNum(buf, Level+1, 0);
	DrawText(buf, 7*8, 3*FONTH, COL_GREEN);

	DispUpdate();
}

// game loop
void GameLoop()
{
	int i;

	// initialize current level
	LevelInit();

	while (True)
	{
		// get key
		i = KeyGet();

		// slow mode - delete direction key, use holding keys instead
		if (!FastMode)
		{
			// holding direction key
			if (i == NOKEY)
			{
				if (KeyPressed(KEY_LEFT)) i = KEY_LEFT;
				if (KeyPressed(KEY_RIGHT)) i = KEY_RIGHT;
				if (KeyPressed(KEY_UP)) i = KEY_UP;
				if (KeyPressed(KEY_DOWN)) i = KEY_DOWN;
			}

			// flush direction keys 
			else
			{
				if (!KeyPressed(KEY_A))
				{
					if ((i == KEY_LEFT) ||
						(i == KEY_RIGHT) ||
						(i == KEY_UP) ||
						(i == KEY_DOWN))
							i = NOKEY;
				}
			}
		}

		if (i != NOKEY)
		{
			// Esc return to selection
			if (i == KEY_Y) return;

			// help solution
			if (i == KEY_X)
			{
#if USE_SCREENSHOT		// use screen shots
				ScreenShot();
#endif
				PlaySolve();
				SolvedAnim(False);
				LevelInit();
			}

			// restart scene
			else if (i == KEY_B)
			{
				LevelInit();
			}

			// next scene
			else if ((i == KEY_RIGHT) && KeyPressed(KEY_A))
			{
				Level++;
				if (Level >= LevNum) Level = 0;
				LevelInfo();
				WaitMs(300);
				LevelInit();
			}

			// previous scene
			else if ((i == KEY_LEFT) && KeyPressed(KEY_A))
			{
				Level--;
				if (Level < 0) Level = LevNum-1;
				LevelInfo();
				WaitMs(300);
				LevelInit();
			}

			// select fast mode
			else if ((i == KEY_UP) && KeyPressed(KEY_A))
			{
				FastMode = True;
			}

			// select slow mode
			else if ((i == KEY_DOWN) && KeyPressed(KEY_A))
			{
				FastMode = False;
			}

			// step
			else
			{
				// one step
				KeyFlush();
				Step(i);
			}

			// solved
			if (SolvedAnim(True))
			{
				DispUpdate();
				WaitMs(200);
				ClearBoard();
				DispUpdate();
				WaitMs(100);

				// increase scene level
				Level++;
				if (Level >= LevNum) Level = 0;

				// level info
				LevelInfo();
				WaitMs(600);
				LevelInit();
			}
		}
	}
}
