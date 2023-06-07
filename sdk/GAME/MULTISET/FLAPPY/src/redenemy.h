
// ****************************************************************************
//
//                                 Red Enemies
//
// ****************************************************************************

#ifndef _REDENEMY_H
#define _REDENEMY_H

#define REDENEMIES_MAX		32 // (min. 10) max. number of red enemies

extern sObj RedEnemies[REDENEMIES_MAX]; // red enemies
extern int RedEnemiesNum; // initial number of red enemies (including dead)

// display red enemy
void DispRedEnemy(int inx, u8 tile);

// clear red enemy
void ClearRedEnemy(int inx, u8 tile);

// crush red enemy by ball
void CrushRedEnemy(int inx);

// red enemy move, phase 1
void RedEnemyMove1();

// red enemy move, phase 2
void RedEnemyMove2();

// hit red enemy (returns True if hit)
Bool RedEnemyHit(sObj* o);

// hit blue or red enemy (returns True if hit)
Bool EnemyHit(sObj* o);

#endif // _REDENEMY_H
