
// ****************************************************************************
//
//                                Game engine
//
// ****************************************************************************

#ifndef _GAME_H
#define _GAME_H

// >>>>> DEBUG SETUP <<<<<
//#define AUTOMODE		// automode - autorun all levels to check solutions
#define LEVFIRST 	1	// first level

// Game speed
#ifdef AUTOMODE	// check levels
#define GAMESPEED	20	// game speed - delay between game steps, in [ms] (6 steps per second)
#else
#define GAMESPEED	166	// game speed - delay between game steps, in [ms] (6 steps per second)
#endif

// Game board
#define MAPW 20			// width of game board
#define MAPH 12			// height of game board
#define MAPSIZE (MAPW*MAPH)	// size of game board
#define MAPY	16		// board Y coordinate

// Info box
#define BOXW	(16*8)	// width of info box
#define BOXH	(5*16)	// height of info box
#define BOXX	((WIDTH-BOXW)/2) // coordinate X of info box
#define BOXY	((HEIGHT-8-BOXH)/2) // coordinate Y of info box

// Tiles
#define TILESIZE 16	// tile size in number of pixels

#define ITEM_NUM 19	// number of items

#define ITEMS(y,x) ((u8)((x)+(y)*(TILESNUMX))) // item index in image map

#define ITEM	ITEMS(0,0)	// items
#define ITEMMIN ITEMS(0,0)	// item min.
#define ITEMMAX ITEMS(2,19)	// item max.

#define WAGON	ITEMS(3,0)	// wagons
#define WAGONMIN ITEMS(3,0)	// wagon min.
#define WAGONMAX ITEMS(6,19)	// wagon max.

#define LOCO_R	ITEMS(7,2)	// locomotive right
#define LOCO_U	ITEMS(7,1)	// locomotive up
#define LOCO_L	ITEMS(7,0)	// locomotive left
#define LOCO_D	ITEMS(7,3)	// locomotive down
#define LOCOMIN	ITEMS(7,0)	// locomotive min.
#define LOCOMAX ITEMS(7,11)	// locomotive max.

#define GATE	ITEMS(7,12)	// gate
#define GATEMIN	ITEMS(7,12)	// gate min
#define GATEMAX	ITEMS(7,17)	// gate max

#define WALL	ITEMS(7,18)	// wall tile

#define	EMPTY	ITEMS(7,19)	// empty tile

#define CRASH	ITEMS(8,0)	// crash
#define CRASHMIN ITEMS(8,0)	// crash min.
#define CRASHMAX ITEMS(8,9)	// crash max.

#define TITLE2	ITEMS(8,11)	// title 2
#define TITLE2MIN ITEMS(8,11)	// title 2 min.
#define TITLE2NUM ITEMS(8,16)	// title 2 max.

#define TITLE	ITEMS(9,0)	// title
#define TITLEMIN ITEMS(9,0)	// title min.
#define TITLENUM ITEMS(10,19)	// title max.

// direction
enum {
	DIR_R=0,	// right
	DIR_U,		// up
	DIR_L,		// left
	DIR_D,		// down
};

// buffers
extern u8 Board[MAPSIZE];	// game board
extern u8 Dir[MAPSIZE];		// direction map DIR_*
#define PSWLEN 5		// password length
extern u8 PswBuf[PSWLEN];	// password buffer

// game state
enum {
	S_WAIT = 0,	// wait for start
	S_GO,		// game progress
	S_CRASH,	// crash
	S_FINISH,	// game finish
	S_HELP,		// help mode
};

// current game state
extern u8 Level;	// current level
extern u8 HeadX, HeadY;	// head (loco) coordinates
extern u8 GateX, GateY;	// gate coordinates
extern u16 Length;	// train length (including loco)
extern u16 ItemNum;	// number of items on game board
extern u8 State;	// game state S_*
extern u8 AnimCnt;	// animation counter
extern u8 Phase;	// current animation phase
extern u8 CurDir;	// current direction DIR_*
extern int Score;	// current score

// key buffset for 2 keys (NOKEY=no key)
extern char KeyBuf1, KeyBuf2;

// wait step
void WaitStep();

// open level
void OpenLevel();

// initialize current level
void InitLevel();

// help level (returns True on break from keyboard)
Bool HelpLevel();

// game loop - called every single game step (returns True on break Esc)
Bool GameLoop();

#endif // _GAME_H
