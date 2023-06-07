
// ****************************************************************************
//
//                                Movable objects
//
// ****************************************************************************

#ifndef _OBJECTS_H
#define _OBJECTS_H

// object state, directions
#define INVALID		0	// object is invalid (dead)
#define CRASHED		1	// crashed (chicken, enemy, red ball)
#define EATEN		2	// eaten (chicken)
#define LIVE		3	// object is valid

#define UP		4	// direction up, standing
#define DOWN		5	// direction down, standing
#define LEFT		6	// direction left, standing
#define RIGHT		7	// direction right, standing

#define UPMOVE		8	// direction up, moving
#define DOWNMOVE	9	// direction down, moving
#define LEFTMOVE	10	// direction left, moving
#define RIGHTMOVE	11	// direction right, moving

#define UPFIRE		12	// fire up
#define DOWNFIRE	13	// fire down
#define LEFTFIRE	14	// fire left
#define RIGHTFIRE	15	// fire right

#define SLEEPING	16	// sleeping

// movable object descriptor
typedef struct {
	u8	state;		// state or direction
	u8	x;		// X coordinate
	u8	y;		// Y coordinate
	u8	phase;		// current phase
} sObj;

// test move - get object on next step (direction UP, DOWN,...)
// Returned value:
//   SPACE ... can move (empty or mushroom)
//   CHICKEN ... chicken
//   BLUEENEMY+inx or REDENEMY+inx ... whole enemy, with index
//   REDBALL ... whole red ball, or vertically first partially red ball
//   BLUEBALL ... whole blue ball
//   WALL ... cannot move
u8 TestMove(u8 dir, u8 x, u8 y);

#endif // _OBJECTS_H
