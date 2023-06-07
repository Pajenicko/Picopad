
// ****************************************************************************
//
//                                Game engine
//
// ****************************************************************************

#ifndef _GAME_H
#define _GAME_H

//#define AUTOMODE		// automode - autorun all levels to check solutions

// game speed
#ifdef AUTOMODE	// automode - autorun all levels to check solutions
#define MOVESPEED	1	// step delay in [ms]
#else
#define MOVESPEED	50	// step delay in [ms]
#endif

#define TRANSCOL	RGBTO16(84, 0, 84)	// transparent color

// Define game board, tiles 16x16
#define MAPWMAX (WIDTH/4)	// max. width of game board
#define MAPHMAX (HEIGHT/4)	// max. height of game board
extern u8 Board[MAPWMAX*MAPHMAX]; // game board
extern int MapW, MapH;		// current board dimension
extern int TileSize;		// current tile size (4, 8, 12, 16, 20, 24, 28 or 32)

#define BoardAddr(x,y) (&Board[(x)+(y)*MapW]) // baord address

// current game state
extern u16 MarkNum;		// number of remaining marks
extern u8 LevelW, LevelH;	// level width and height
extern u8 LevelX, LevelY;	// level coordinates
extern u8 PosX, PosY;		// player coordinates
extern Bool FastMode;		// fast mode

// Tiles
#define	EMPTY	0	// empty (grass)
#define WALL	1	// wall
#define FLOOR	2	// floor
#define MARK	3	// mark
#define CRATE	4	// crate
#define FULL	5	// full crate (crate on mark)
#define FACE_R	6	// (4) face left
#define FACE_U	10	// (4) face up
#define FACE_L	14	// (4) face left
#define FACE_D	18	// (4) face down
#define FACE_WIN 22	// (1) winning face
#define TILES_NUM 23	// number of tiles

// direction
enum {
	DIR_R=0,	// right
	DIR_U,		// up
	DIR_L,		// left
	DIR_D,		// down
};

// set tile/text mode, 0 = text mode
void SetTileMode(int tilesize);

// set player graphics position
void SetPlayer(int x, int y, u8 tile);

// soft move player in direction
void MovePlayer(u8 dir);

// clear board
void ClearBoard();

// detect board dimension
void BoardDim();

// display program info
void DispInfo();

// initialize current level
void LevelInit();

// step one level (key = move key, returns False on unsupported key)
Bool Step(char key);

// play level solve (returns True on break from keyboard)
Bool PlaySolve();

// display solved animation (returns True of solved)
Bool SolvedAnim(Bool sound);

// level info
void LevelInfo();

// game loop
void GameLoop();

#endif // _GAME_H
