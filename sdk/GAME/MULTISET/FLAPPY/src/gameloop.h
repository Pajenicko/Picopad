
// ****************************************************************************
//
//                                 Game Loop
//
// ****************************************************************************

#ifndef _GAMELOOP_H
#define _GAMELOOP_H

#define TIMESTEP	100		// time step

extern int Score;		// current score
extern int GameTime;		// current game time
extern u32 LastTime;		// last wait time

extern const char* Macro;	// macro (NULL=not playing)
extern char MacroCh;		// macro next character
extern int MacroRep;		// macro repeater

// sync wait and display update
void WaitTime(int ms);

// display number with number of digits
void DispNum(int num, int x, int y, int dignum);

// display score
void DispScore();

// display time
void DispTime();

// display scene number
void DispSceneNum();

// display lives
void DispLives();

// display mushrooms in stock
void DispMushrooms();

// game loop (return True = continue to next level, False = break)
Bool GameLoop();

#endif // _GAMELOOP_H
