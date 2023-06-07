
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// ============================================================================
//                                 Data
// ============================================================================

// move direction
enum { MOVE_NO, MOVE_L, MOVE_R, MOVE_U, MOVE_D };

// weapon reload time
const int ReloadList[WEAPON_NUM] = { 2, 6, 5, 3, 12, 12, 50, };

// weapon speed
const float SpeedList[WEAPON_NUM] = { 30, 15, 15, 30, 15, 5, 1.0f, };

// weapon energy
const int WeaponEnergy[WEAPON_NUM] = { 26, 60, 120, 330, 80, 10000, 10000, };

// enemy speed list
const float EnemySpeed[ENEMY_NUM] = { 2, 3, 4, 3, 2, };

// enemy energy
const int EnemyEnergyList[ENEMY_NUM] = { 125, 250, 500, 1000, 2000, };

// enemy points
const int EnemyPoints[ENEMY_NUM] = { 20, 50, 100, 200, 500, };

// enemy missile speed list
const float EnemyMissileSpeed[ENEMY_NUM] = { 4, 6, 8, 6, 5, };

// enemy missile energy
const int EnemyMissileEnergy[ENEMY_NUM] = { 3, 5, 10, 20, 10, };

// weapon sounds
const u8* const SoundList[WEAPON_NUM] = {
	MachinegunSnd,		// weapon 0 - machine gun
	GreenrocketSnd,		// weapon 1 - green rocket
	SilverrocketSnd,	// weapon 2 - silver rocket
	LaserSnd,		// weapon 3 - laser
	ArtillerySnd,		// weapon 4 - artillery
	SonarSnd,		// weapon 5 - sonar bomb
	BlackholeSnd,		// weapon 6 - black hole
};

// weapon volume
const float SoundVolList[WEAPON_NUM] = {
	1.8f,		// weapon 0 - machine gun
	0.5f,		// weapon 1 - green rocket
	0.8f,		// weapon 2 - silver rocket
	0.6f,		// weapon 3 - laser
	0.8f,		// weapon 4 - artillery
	0.9f,		// weapon 5 - sonar bomb
	1.8f,		// weapon 6 - black hole
};

// size of weapon sounds
const int SoundLenList[WEAPON_NUM] = {
	count_of(MachinegunSnd),	// weapon 0 - machine gun
	count_of(GreenrocketSnd),	// weapon 1 - green rocket
	count_of(SilverrocketSnd),	// weapon 2 - silver rocket
	count_of(LaserSnd),		// weapon 3 - laser
	count_of(ArtillerySnd),		// weapon 4 - artillery
	count_of(SonarSnd),		// weapon 5 - sonar bomb
	count_of(BlackholeSnd),		// weapon 6 - black hole
};

int LandscapeY = 0;
u32 LastTime;
int Level;	// current level (1..)
int Weapon;	// current weapon (0=machine gun)
int WeaponMax;	// max. weapon (0=machine gun)
int Shields;	// number of shields (-1 = spaceship is dead)
int Energy;	// current energy
int Score;	// current score
int ShipX, ShipY; // spaceship current position
u8 Move = MOVE_NO; // spaceship moving state
int Frame;	// frame counter (to do animations)
int NextShield;	// score to get next shield
int ReloadNext0, ReloadNext; // reload time of weapon 0 (machine gun) and current weapon

// my flying missiles
#define MYMISSILE_MAX	50	// max. my missiles
sMissile	MyMissile[MYMISSILE_MAX];

// enemy flying missiles
#define ENMISSILE_MAX	50	// max. enemy missiles
sMissile	EnMissile[ENMISSILE_MAX];

// enemy list
#define ENEMY_MAX	50	// max. enemies
sEnemy		Enemy[ENEMY_MAX];

// weapon base index
const u8 WeaponList[WEAPON_NUM + 1] = {
	SPRITE_WEAPON0_TILE,
	SPRITE_WEAPON1_TILE,
	SPRITE_WEAPON2_TILE,
	SPRITE_WEAPON3_TILE,
	SPRITE_WEAPON4_TILE,
	SPRITE_WEAPON5_TILE,
	SPRITE_WEAPON6_TILE,
	SPRITE_HIT0-1, // hit
};

// ============================================================================
//                               Initialize
// ============================================================================

// initialize new game
void NewGame()
{
	int i;
	LastTime = Time();

	// setup new game
	Level = 1; // current level
	Weapon = 0; // current weapon
	WeaponMax = 0; // max. weapon
	Shields = 5; // number of shields
	Energy = ENERGY_MAX; // energy
	Score = 0; // current score
	ShipX = (WIDTH - SPRITEW)/2; // spaceship X coordinate
	ShipY = HEIGHT - SPRITEH; // spaceship Y coordinate
	Move = 0; // spaceship moving mode
	Frame = 0; // frame counter
	NextShield = 10000; // score to get next shield
	ReloadNext0 = 0; // reload time of weapon 0 (machine gun)
	ReloadNext = 0; // reload time of current weapon

	// clear missile list
	for (i = 0; i < MYMISSILE_MAX; i++) MyMissile[i].type = -1;
	for (i = 0; i < ENMISSILE_MAX; i++) EnMissile[i].type = -1;

	// clear enemy list
	for (i = 0; i < ENEMY_MAX; i++) Enemy[i].type = -1;
}

// ============================================================================
//                               Controls
// ============================================================================

// move landscape
void DoLandscape()
{
	// shift landscape
	LandscapeY++;
	if (LandscapeY >= LANDSCAPEH) LandscapeY -= LANDSCAPEH;
}

// serve keys, select weapon (returns True to quit the game)
Bool DoKeys()
{
	char ch;

	while (True)
	{
		ch = KeyGet();
		if (ch == NOKEY) break;

		// quit the game
		if (ch == KEY_Y) return True;

#if USE_SCREENSHOT		// use screen shots
		if (ch == KEY_X) ScreenShot();
#endif

		// select weapon
		if ((ch == KEY_B) && (WeaponMax > 0) && (Shields >= 0))
		{
			Weapon++;
			if (Weapon > WeaponMax) Weapon = 1;
			ReloadNext = 0;
		}
	}
	return False;
}

// serve spaceship moving
void DoShip()
{
	int inx;
	if (Shields < 0) return; // dead

	// moving spaceship
	Move = MOVE_NO;
	if (KeyPressed(KEY_UP))
	{
		ShipY -= SHIP_SPEED;
		if (ShipY < TILEH)
			ShipY = TILEH;
		else
			Move = MOVE_U;
	}

	if (KeyPressed(KEY_DOWN))
	{
		ShipY += SHIP_SPEED;
		if (ShipY > HEIGHT-SPRITEH)
			ShipY = HEIGHT-SPRITEH;
		else
			Move = MOVE_D;
	}

	if (KeyPressed(KEY_LEFT))
	{
		ShipX -= SHIP_SPEED;
		if (ShipX < TILEW)
			ShipX = TILEW;
		else
			Move = MOVE_L;
	}

	if (KeyPressed(KEY_RIGHT))
	{
		ShipX += SHIP_SPEED;
		if (ShipX > WIDTH-TILEW-SPRITEW)
			ShipX = WIDTH-TILEW-SPRITEW;
		else
			Move = MOVE_R;
	}
}

// spaceship shooting
void DoShooting()
{
	int i, j, n;
	sMissile* m;

	if (Shields < 0) return; // dead

	// shoot next missile
	if (ReloadNext0 > 0) ReloadNext0--; // count machine gun
	if (ReloadNext > 0) ReloadNext--; // count current weapon
	if (KeyPressed(KEY_A))
	{
		// playing sound of machine gun
		if (!PlayingSoundChan(SNDCHAN_GUN))
			PlaySoundChan(SNDCHAN_GUN, MachinegunSnd, count_of(MachinegunSnd), True, 1, SoundVolList[0]);

		// new missile of machine gun
		if (ReloadNext0 <= 0)
		{
			// search free entry
			m = MyMissile;
			for (i = 0; i < MYMISSILE_MAX; i++)
			{
				if (m->type < 0) // not used entry
				{
					m->type = 0;
					m->x = ShipX;
					m->y = ShipY;
					m->dx = 0;
					m->dy = SpeedList[0];
					m->anim = 0;
					ReloadNext0 = ReloadList[0];
					break;
				}
				m++;
			}
		}

		// new missile of current weapon
		if ((Weapon != 0) && (ReloadNext <= 0))
		{
			// search free entry
			m = MyMissile;
			n = (Weapon == WEAPON_ARTILLERY) ? ARTILLERY_NUM : 1; // artillery generates more missilies at once

			for (i = 0; (i < MYMISSILE_MAX) && (n > 0); i++)
			{
				if (m->type < 0) // not used entry
				{
					m->type = Weapon;
					m->x = ShipX;
					m->y = ShipY;
					m->dy = SpeedList[Weapon];
					m->dx = 0;
					m->anim = 0;

					// serve artillery
					if (Weapon == WEAPON_ARTILLERY)
					{
						float s = SpeedList[Weapon] * RandFloatMinMax(0.9f, 1.1f); // random speed
						m->dx = 0.7f * RandFloatMinMax(-1.0f, +1.0f); // random direction
						m->dy = sqrtf(1 - m->dx*m->dx);
						m->dx *= s;
						m->dy *= s;
					}
					n--;
				}
				m++;
			}
			ReloadNext = ReloadList[Weapon];

			// playing sound of the missile
			PlaySoundChan(SNDCHAN_WEAPON, SoundList[Weapon], SoundLenList[Weapon], False, 1, SoundVolList[Weapon]);
		}
	}
	else
	{
		// stop sound of machine gun
		StopSoundChan(SNDCHAN_GUN);
	}
}

// move spaceship missile
void MoveMissile()
{
	int i, j, k, kbest;
	float dx, dy, a, distbest;
	sMissile *m, *m2;
	sEnemy* e;
	
	// move missiles
	m = MyMissile;
	for (i = 0; i < MYMISSILE_MAX; i++)
	{
		j = m->type;
		if ((j >= 0) && (j < WEAPON_NUM)) // active missile
		{
			// control sonar bomb
			if (j == WEAPON_SONARBOMB)
			{
				m->dx = 0;
				m->dy = 0;

				// find nearest enemy
				e = Enemy;
				kbest = -1;
				for (k = 0; k < ENEMY_MAX; k++)
				{
					if ((e->type >= 0) && (e->type < ENEMY_NUM))
					{
						dx = e->x - m->x;
						dy = e->y - m->y;
						if ((kbest < 0) || (dx*dx + dy*dy < distbest))
						{
							kbest = k;
							distbest = dx*dx + dy*dy;
						}
					}
					e++;
				}

				// navigate to enemy
				if (kbest >= 0)
				{
					e = &Enemy[kbest];
					a = atan2f(e->y - m->y, e->x - m->x);
					m->dx = cosf(a)*SpeedList[WEAPON_SONARBOMB];
					m->dy = -sinf(a)*SpeedList[WEAPON_SONARBOMB];
				}
			}

			m->x += m->dx;
			m->y -= m->dy;
			if ((m->y < -SPRITEH) || (m->y > HEIGHT) || (m->x < -SPRITEW) || (m->x > WIDTH)) // flying out of the screen
				m->type = -1; // destroy missile
			else
			{
				// check hit enemy
				e = Enemy;
				for (k = 0; k < ENEMY_MAX; k++)
				{
					if ((e->type >= 0) && (e->type < ENEMY_NUM))
					{
						dx = e->x - m->x;
						dy = e->y - m->y;
						if (dx*dx + dy*dy < SPRITEW*SPRITEH)
						{
							e->energy -= WeaponEnergy[j];

							// destroy enemy
							if (e->energy <= 0)
							{
								// increase score
								Score += EnemyPoints[e->type];

								if (j == WEAPON_BLACKHOLE) // black hole
								{
									// sucked through a black hole
									PlaySoundChan(SNDCHAN_MISC, Blackhole2Snd, sizeof(Blackhole2Snd), False, 1, 1.0f);
									e->type = -1;
								}
								else
								{
									// change enemy to explosion
									PlaySoundChan(SNDCHAN_MISC, ExplosionSnd, sizeof(ExplosionSnd), False, 1, 1);
									e->type = ENEMY_NUM;
									e->anim = 0;
								}

								// increase shields
								if ((Score >= NextShield) && (Shields >= 0))
								{
									NextShield += 10000;
									Shields++;
									PlaySoundChan(SNDCHAN_MISC, LevelupSnd, sizeof(LevelupSnd), False, 1, 1);
								}

								// increase level (at score: 1000, 2000, 5000, 10000, 17000,...)
								if (Score >= 1000*(1+(Level-1)*(Level-1)))
								{
									Level++;
									PlaySoundChan(SNDCHAN_MISC, LevelupSnd, sizeof(LevelupSnd), False, 1, 1);

									// add weapon
									if (Level <= WEAPON_NUM)
									{
										WeaponMax = Level - 1;
										Weapon = WeaponMax;
									}
								}
							}

							// destroy missile (not black hole)
							if (j != WEAPON_BLACKHOLE)
							{
								m->type = WEAPON_NUM; // change to missile hit
								m->anim = 0;
								break;
							}
						}
					}
					e++;
				}

				// black hole - destroys enemy missiles
				if (j == WEAPON_BLACKHOLE)
				{
					m2 = EnMissile;
					for (k = 0; k < ENMISSILE_MAX; k++)
					{
						// active missile
						if (m2->type >= 0)
						{
							// check distance
							dx = m2->x - m->x;
							dy = m2->y - m->y;
							if (dx*dx + dy*dy < SPRITEW*SPRITEH)
							{
								// sucked through a black hole
								PlaySoundChan(SNDCHAN_MISC, Blackhole2Snd, sizeof(Blackhole2Snd), False, 1, 1.0f);
								m2->type = -1;
							}
						}
						m2++;
					}
				}
			}
		}
		m++;
	}	
}

// serve enemies
void DoEnemy()
{
	int i, j;
	sEnemy* e;

	// randomness to generate new enemy
	if (RandU16() < 4000 + 400*Level)
	{
		// find free entry
		e = Enemy;
		for (i = 0; i < ENEMY_MAX; i++)
		{
			if (e->type < 0) // entry is not used
			{
				j = Level-1; // max. level
				if (j >= ENEMY_NUM) j = ENEMY_NUM-1; // limit to max. enemy
				e->type = RandU8Max(j); // generate enemy type
				e->x = RandU16MinMax(SPRITEW, WIDTH - TILEW - SPRITEW); // generate X coordinate
				e->y = -2*SPRITEH;
				e->dx = 0;
				e->dy = EnemySpeed[e->type]; // enemy speed
				e->anim = 0;
				e->energy = EnemyEnergyList[e->type];
				if (e->type > 1) e->dx = (ShipX - e->x)*0.01f; // move towards spaceship
				break;
			}
			e++;
		}
	}

	// move enemy (or dead enemy)
	e = Enemy;
	for (i = 0; i < ENEMY_MAX; i++)
	{
		j = e->type;
		if (j >= 0)
		{
			e->x += e->dx;
			e->y += e->dy;
			if (e->y > HEIGHT) e->type = -1; // enemy is out of the screen
		}
		e++;
	}
}

// serve enemy shooting
void DoEnemyShooting()
{
	int i, j, k;
	sEnemy* e;
	sMissile* m;

	// find valid enemy
	e = Enemy;
	for (i = 0; i < ENEMY_MAX; i++)
	{
		j = e->type;
		if ((j >= 0) && (j < ENEMY_NUM)) // entry is valid and not dead
		{
			// randomness to generate missile
			if (RandU16() < 1000)
			{
				// find unused missile entry
				m = EnMissile;
				for (k = 0; k < ENMISSILE_MAX; k++)
				{
					if (m->type < 0) // not used entry
					{
						m->type = j; // missile type
						m->x = e->x;
						m->y = e->y;
						m->dy = EnemyMissileSpeed[j];
						m->dx = 0;
						if (j > 1) m->dx = (ShipX - m->x)*0.02f; // move towards spaceship
						break;
					}
					m++;
				}
			}
		}
		e++;
	}
}

// move enemy missiles
void MoveEnemyMissile()
{
	int i, j;
	sMissile* m;
	float dx, dy;

	// find valid missile
	m = EnMissile;
	for (i = 0; i < ENMISSILE_MAX; i++)
	{
		j = m->type;
		if (j >= 0) // used entry
		{
			m->x += m->dx;
			m->y += m->dy;
			if ((m->y < -SPRITEH) || (m->y > HEIGHT) || (m->x < -SPRITEW) || (m->x > WIDTH)) // flying out of the screen
				m->type = -1; // destroy missile
			else
			{
				// check distance
				dx = ShipX - m->x;
				dy = ShipY - m->y;
				if ((dx*dx + dy*dy < SPRITEW*SPRITEH*0.4) && (Shields >= 0))
				{
					// lost energy
					Energy -= EnemyMissileEnergy[j];
					m->type = -1;
					PlaySoundChan(SNDCHAN_MISC, FailSnd, sizeof(FailSnd), False, 1, 1.0f);

					// next shield
					if (Energy < 0)
					{
						Shields--;
						PlaySoundChan(SNDCHAN_MISC, LostSnd, sizeof(LostSnd), False, 1, 1.0f);
						if (Shields >= 0) Energy = ENERGY_MAX; else Energy = 0;
					}
				}
			}
		}
		m++;
	}
}

// ============================================================================
//                               Display
// ============================================================================

// display sprite
void DispSprite(int sprite, int x, int y)
{
	DrawBlitPal(SpritesImg + sprite*SPRITEH*SPRITEW, SpritesImg_Pal, x, y, SPRITEW, SPRITEH, SPRITEW, TRANSCOL);
}

// display tile
void DispTile(int tile, int x, int y)
{
	DrawBlit4Pal(TilesImg, TilesImg_Pal, 0, tile*TILEH, x, y, TILEW, TILEH, TILEW, TRANSCOL);
}

// display shadow
void DispShadow(int shadow, int x, int y)
{
	DrawBlit1Shadow(ShadowsImg, 0, shadow*SHADOWH, x+SHADOW_SHIFTX, y+SHADOW_SHIFTY, SHADOWW, SHADOWH, SHADOWW, 13);
}

// display landscape
void DispLandscape()
{
	// display landscape
	DrawImg4Pal(LandscapeImg, LandscapeImg_Pal, 0, 0, 0, LandscapeY, LANDSCAPEW, LANDSCAPEH, LANDSCAPEW);
	DrawImg4Pal(LandscapeImg, LandscapeImg_Pal, 0, 0, 0, LandscapeY - LANDSCAPEH, LANDSCAPEW, LANDSCAPEH, LANDSCAPEW);
}

// display spaceship shadow
void DispShipShadow()
{
	// display shadow
	if (Shields >= 0) DispShadow(SHADOW_SHIP, ShipX, ShipY);
}

// display enemy shadows
void DispEnemyShadow()
{
	int i, j;
	sEnemy* e;

	// display shadow
	e = Enemy;
	for (i = 0; i < ENEMY_MAX; i++)
	{
		j = e->type;
		if ((j >= 0) && (j < ENEMY_NUM)) // entry is valid and not dead
		{
			DispShadow(SHADOW_ENEMY1+j, (int)e->x, (int)e->y);
		}
		e++;
	}
}

// display spaceship shooting
void DispShooting()
{
	int i, j, n;
	sMissile* m;

	// display missiles
	m = MyMissile;
	for (i = 0; i < MYMISSILE_MAX; i++)
	{
		j = m->type;
		if (j >= 0) // active missile (including hit)
		{
			n = WeaponList[j]+1;

			// serve sonar bomb
			if (j == WEAPON_SONARBOMB)
			{
				m->anim++;
				if (m->anim >= SPRITE_WEAPON5_NUM) m->anim = 0;
				n += m->anim;
			}

			// serve black hole
			if (j == WEAPON_BLACKHOLE)
			{
				m->anim++;
				if (m->anim >= SPRITE_WEAPON6_NUM) m->anim = 0;
				n += (SPRITE_WEAPON6_NUM - 1 - m->anim);
			}

			// serve hit
			if (j == WEAPON_NUM)
			{
				n += m->anim;
				m->anim++;
				if (m->anim >= 4) m->type = -1; // destroy missile
			}

			// display missile
			DispSprite(n, (int)m->x, (int)m->y);
		}
		m++;
	}	
}

// display enemies
void DispEnemy()
{
	int i, j;
	sEnemy* e;

	// display enemy
	e = Enemy;
	for (i = 0; i < ENEMY_MAX; i++)
	{
		j = e->type;
		if (j >= 0) // active enemy (including explosion)
		{
			// explosion
			if (j >= ENEMY_NUM)
			{
				DispSprite(SPRITE_EXPLOSE1 + e->anim, (int)e->x, (int)e->y);
				e->anim++;
				if (e->anim >= 8) e->type = -1;
			}
			else
			{
				j *= 2;
				if (j == 4*2) // animate enemy 5
				{
					e->anim++;
					if (e->anim >= 3) e->anim = 0;
					if (e->anim != 0) j += e->anim+1;
				}
				DispSprite(SPRITE_ENEMY1+j, (int)e->x, (int)e->y);
			}
		}
		e++;
	}
}

// display spaceship
void DispShip()
{
	int inx;

	// dead
	if (Shields < 0)
	{
		DispSprite(SPRITE_EXPLOSE5 + (Frame & 3), ShipX, ShipY);
	}
	else
	{
		// display ship
		if (Move == MOVE_L) // left
			inx = SPRITE_SHIPL;
		else if (Move == MOVE_R) // right
			inx = SPRITE_SHIPR;
		else if (Move == MOVE_D) // down
			inx = SPRITE_SHIPD;
		else if (Move == MOVE_U) // up
			inx = SPRITE_SHIPU;
		else
			inx = SPRITE_SHIP + (Frame & 1);
		DispSprite(inx, ShipX, ShipY);
	}
}

// display enemy missiles
void DispEnemyShooting()
{
	int i, j;
	sMissile* m;

	// display missiles
	m = EnMissile;
	for (i = 0; i < ENMISSILE_MAX; i++)
	{
		j = m->type;
		if (j >= 0) // active missile
		{
			// display missile
			DispSprite(j*2 + SPRITE_ENEMY1_MISSILE, (int)m->x, (int)m->y);
		}
		m++;
	}	
}

// display shields
void DispShields()
{
	int i;
	for (i = 0; i < Shields; i++) DispTile(TILE_SHIELD, 0, i*TILEH);
}

// dispay score
void DispScore()
{
	int i, s, s2;
	s = Score;
	for (i = 5; (i >= 0) || (s > 0); i--)
	{
		s2 = s/10;
		DispTile(TILE_DIGIT0 + s - s2*10, (WIDTH - 6*TILEW - SPRITEW/2)/2 + i*TILEW, 0);
		s = s2;
	}
}

// display current selected weapon
void DispSelWeapon()
{
	DispSprite(WeaponList[Weapon], WIDTH-TILEW-SPRITEW, 2);
}

// display energy
void DispEnergy()
{
	int i;
	for (i = 0; i < Energy; i += 2)
	{
		if (i <= Energy - 2)
			DispTile(TILE_ENERGY2, WIDTH-TILEW, i*TILEH/2);
		else
			DispTile(TILE_ENERGY1, WIDTH-TILEW, i*TILEH/2);
	}
}

// ============================================================================
//                             Main function
// ============================================================================

// wait time and update
void WaitTime(u32 ms)
{
	u32 t;
	ms *= 1000;
	DispUpdate();
	do t = Time(); while ((u32)(t - LastTime) < ms);
	LastTime = t;
}

// main function
int main()
{
// ---- initialize

	// initialize new game
	NewGame();

	// main loop
	while (True)
	{

// --- controls

		// move landscape
		DoLandscape();

		// serve keys, select weapon (returns True to quit the game)
		if (DoKeys()) ResetToBootLoader();

		// serve spaceship moving
		DoShip();

		// spaceship shooting
		DoShooting();

		// move spaceship missile
		MoveMissile();

		// serve enemies
		DoEnemy();

		// serve enemy shooting
		DoEnemyShooting();

		// move enemy missile
		MoveEnemyMissile();

// --- display

		// display landscape
		DispLandscape();

		// display spaceship shadow
		DispShipShadow();

		// display enemy shadows
		DispEnemyShadow();

		// display spaceship shooting
		DispShooting();

		// display enemies
		DispEnemy();

		// display spaceship
		DispShip();

		// display enemy missiles
		DispEnemyShooting();

		// display shields
		DispShields();

		// dispay score
		DispScore();

		// display current selected weapon
		DispSelWeapon();

		// display energy
		DispEnergy();

// --- main loop

		// display update and wait
		WaitTime(100);

		// drame counter (to serve some animations)
		Frame++;
	}
}
