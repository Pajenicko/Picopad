
// ****************************************************************************
//
//                                 Blue Enemies
//
// ****************************************************************************

#ifndef _BLUEENEMY_H
#define _BLUEENEMY_H

#define BLUEENEMIES_MAX		32 // (min. 11) max. number of blue enemies

extern sObj BlueEnemies[BLUEENEMIES_MAX]; // blue enemies
extern int BlueEnemiesNum; // initial number of blue enemies (including dead)

// display blue enemy
void DispBlueEnemy(int inx, u8 tile);

// clear blue enemy
void ClearBlueEnemy(int inx);

// crush blue enemy by ball
void CrushBlueEnemy(int inx);

// blue enemy move, phase 1
void BlueEnemyMove1();

// blue enemy move, phase 2
void BlueEnemyMove2();

// hit blue enemy (returns True if hit)
Bool BlueEnemyHit(sObj* o);

#endif // _BLUEENEMY_H
