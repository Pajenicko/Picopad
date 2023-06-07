
// ****************************************************************************
//
//                                 Chicken
//
// ****************************************************************************

#ifndef _CHICKEN_H
#define _CHICKEN_H

// chicken
extern sObj Chicken;
extern int Lives;		// number of remaining lives

// display lives
void DispLives();

// display chicken
void DispChicken(u8 tile);

// clear chicken
void ClearChicken();

// crush chicken by ball
void CrushChicken();

// eat chicken by enemy
void EatChicken();

// chicken move, phase 1
void ChickenMove1();

// chicken move, phase 2
void ChickenMove2();

// fire mushroom (must be after phase 2 of chicken move)
void FireMushroom();

#endif // _CHICKEN_H
