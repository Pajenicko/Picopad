
// ****************************************************************************
//
//                                   Balls
//
// ****************************************************************************

#ifndef _BALLS_H
#define _BALLS_H

#define REDBALLS_MAX		32 // (min. 15) max. number of red balls

extern sObj RedBalls[REDBALLS_MAX]; // red balls
extern int RedBallsNum; // initial number of red balls (including destroyed)

extern sObj BlueBall; // blue ball

// crash ball (index will be masked)
void CrashBall(u8 inx);

// move (or crash) balls
void MoveBalls();

#endif // _BALLS_H
