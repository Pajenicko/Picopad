
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// All graphics and movements are multiply of 4 pixels.

#include "include.h"

u32 OldTime;

// spaceship
int Lives; // number of remaining lives
int ShipX; // spaceship X coordinate, multiply of 4
int Score; // current score
int MaxScore = 0; // max. score
int Level; // current level
u16 ColHouse; // house color
int NextLive; // score to next live

// aliens
Bool AlienLive[ALIENNUM]; // alien lives
int AlienNum; // number of aliens
int AlienX;	// X coordinate of alien block, multiply of 4
int AlienY;	// Y coordinate of alien block, multiply of 4
int AlienPhase; // alien animation phase (0 or 1)
const u8 AlienType[ALIENNUMY] = { 0, 1, 1, 2, 2 }; // types of aliens
const u8 AlienScore[ALIENNUMY] = { 30, 20, 20, 10, 10 }; // score of aliens
int AlienMinX;	// alien min. X coordinate
int AlienMaxX;	// alien max. X coordinate
Bool AlienLeft; // aliens are moving left
int AlienTimer; // alien timer to next step
int AlienTone; // current alien tone

// alien missiles
Bool MissileOn[MISSILENUM]; // missile is active
int MissileX[MISSILENUM]; // missile X coordinate
int MissileY[MISSILENUM]; // missile Y coordinate
Bool EnemyLast[ALIENNUMX]; // last enemy
int MissilePhase; // missile animation phase

// spaceship shoot
int ShootX, ShootY; // shoot coordinate
Bool ShootOn; // shoot is ON

// mothership
Bool MotherOn; // mothership is on
Bool MotherLeft; // moving left
int MotherX; // mothership X coordinate
int NextMother; // counter to next mothership

// tones
const u8* const Tones[4] = { Tone1Snd, Tone2Snd, Tone3Snd, Tone4Snd, };
const int TonesLen[4] = { sizeof(Tone1Snd), sizeof(Tone2Snd), sizeof(Tone3Snd), sizeof(Tone4Snd), };

// display sprite image
void DispSprite(int xs, int ys, int x, int y, int w, int h)
{
	DrawImg4Pal(SpritesImg, SpritesImg_Pal, xs, ys, x, y, w, h, SPRITESIMGW);
}

// display ship
void DispShip()
{
	DispSprite(SHIPIMGX, SHIPIMGY, ShipX, SHIPY, SHIPW, SHIPH);
}

// clear ship
void ClearShip()
{
	DrawRect(ShipX, SHIPY, SHIPW, SHIPH, COL_BLACK);
}

// display remaining lives
void DispLives()
{
	int i;
	DrawRect(0, HEIGHT-SHIPH-4, 10*SHIPDX, SHIPH, COL_BLACK);
	i = Lives;
	if (i > 10) i = 10;
	for (i--; i >= 0; i--)
		DispSprite(SHIPIMGX, SHIPIMGY, i*SHIPDX, HEIGHT-SHIPH-4, SHIPW, SHIPH);
}

// lost live
void Lost()
{
	DispSprite(SHIPEXPIMGX, SHIPEXPIMGY, ShipX, SHIPY, SHIPW, SHIPH);
	PLAYSOUND(CrashSnd);
	DispUpdate();
	WaitMs(1000);
	DrawRect(ShipX, SHIPY, SHIPW, SHIPH, COL_BLACK);
	Lives--;
	ShipX = SHIPX;
	DispShip();
	DispLives();
	DispUpdate();
}

// mothership move
void MoveMother()
{
	// generate new mothership
	NextMother--;
	if ((NextMother <= 0) && !MotherOn)
	{
		NextMother = NEXTMOTHER;
		MotherOn = True;
		MotherLeft = !MotherLeft;
		MotherX = MotherLeft ? WIDTH : -MOTHERW;
		PlaySoundChan(MOTHERCHAN, MotherSnd, sizeof(MotherSnd), True, 1, 1);
	}

	// move mothership
	if (MotherOn)
	{
		DrawRect(MotherX, MOTHERY, MOTHERW, MOTHERH, COL_BLACK);
		if (MotherLeft)
		{
			MotherX -= 2;
			if (MotherX < -MOTHERW)
			{
				MotherOn = False;
				StopSoundChan(MOTHERCHAN);
				return;
			}
		}
		else
		{
			MotherX += 2;
			if (MotherX >= WIDTH)
			{
				MotherOn = False;
				StopSoundChan(MOTHERCHAN);
				return;
			}
		}
		DispSprite(MOTHERIMGX, MOTHERIMGY, MotherX, MOTHERY, MOTHERW, MOTHERH);
		DispUpdate();
	}
}

// display bottom line
void DispLine()
{
	DrawRect(0, LINEY1, WIDTH, 1, COL_WHITE);
	DrawRect(0, LINEY2, WIDTH, 1, COL_WHITE);
}

// prepare alien limits
void LimitAlien()
{
	int x, y, xmin, xmax, i;
	xmin = WIDTH;
	xmax = 0;
	for (i = 0; i < ALIENNUM; i++)
	{
		if (AlienLive[i])
		{
			y = i / ALIENNUMX;
			x = i - y*ALIENNUMX;
			y = y*ALIENDY;
			x = x*ALIENDX;
			if (x < xmin) xmin = x;
			if (x > xmax) xmax = x;	
		}
	}
	AlienMinX = ALIENMINX - xmin;
	AlienMaxX = ALIENMAXX - ALIENDX - xmax + ALIENSPACEX;
}

// clear one alien
void ClearAlien(int inx)
{
	int x, y;
	y = inx / ALIENNUMX;
	x = inx - y*ALIENNUMX;
	y = AlienY + y*ALIENDY;
	x = AlienX + x*ALIENDX;
	DrawRect(x, y, ALIENW, ALIENH, COL_BLACK);
}

// clear aliens
void ClearAliens()
{
	int i;
	for (i = 0; i < ALIENNUM; i++) if (AlienLive[i]) ClearAlien(i);
}

// display one alien
void DispAlien(int inx)
{
	int x, y, ys;

	y = inx / ALIENNUMX;
	x = inx - y*ALIENNUMX;
	ys = AlienType[y]*ALIENH;
	y = AlienY + y*ALIENDY;
	x = AlienX + x*ALIENDX;

	if (AlienLive[inx])
		DispSprite(AlienPhase*ALIENW, ys, x, y, ALIENW, ALIENH);
	else
		DispSprite(2*ALIENW, ys, x, y, ALIENW, ALIENH);

	// end game
	if (y >= SHIPY)
	{
		// lost live
		Lost();
		ClearAliens();
		AlienY -= 4*10;
	}
}

// display aliens
void DispAliens()
{
	int i;
	for (i = 0; i < ALIENNUM; i++) if (AlienLive[i]) DispAlien(i);
}

// check house collision (returns number of house pixels in area 8x4)
int CheckHouse(int x, int y)
{
	// check base Y cooordinate
	if ((y + 8 <= HOUSEY) || (y >= HOUSEY + HOUSEH)) return 0;

	// check base X coordinate
	if ((x + 4 <= HOUSEX) || (x >= HOUSEX + HOUSETOTW)) return 0;

	// check closer X coordinate
	int i = (x - HOUSEX) % HOUSEDX;
	if (i >= HOUSEW) return 0;

	// count pixels of house
	int j, num;
	u16* s = &FrameBuf[x + y*WIDTH];
	num = 0;
	for (i = 8; i > 0; i--)
	{
		for (j = 4; j > 0; j--)
		{
			if (*s == ColHouse /*HOUSECOL*/) num++;
			s++;
		}
		s += WIDTH - 4;
	}
	return num;
}

// shoot hit house
void ShootHitHouse()
{
	if (ShootOn)
	{
		if (CheckHouse(ShootX, ShootY) > 15)
		{
			ShootOn = False;
			DrawBlit4Pal(SpritesImg, SpritesImg_Pal, SHOOTEXP2X, SHOOTEXP2Y,
				ShootX, ShootY, SHOOTW, SHOOTH, SPRITESIMGW, COL_WHITE);
		}
	}
}

// missile hit house
void MissileHitHouse()
{
	int i;
	for (i = 0; i < MISSILENUM; i++)
	{
		if (MissileOn[i])
		{
			if (CheckHouse(MissileX[i], MissileY[i]) > 10)
			{
				MissileOn[i] = False;
				DrawBlit4Pal(SpritesImg, SpritesImg_Pal, MISSILEINVIMGX, MISSILEINVIMGY,
					MissileX[i]-2, MissileY[i], MISSILEEXPW, MISSILEEXPH, SPRITESIMGW, COL_YELLOW);
			}
		}
	}
}

// display score
void DispScore()
{
	char buf[6];
	int n = Score;
	int i, x;
	u8 ch;
	for (i = 4; i >= 0; i--)
	{
		x = n/10;
		buf[i] = (n - x*10) + '0';
		n = x;
	}
	buf[5] = 0;
	DrawTextBg(buf, SCOREX+7*8, SCOREY, COL_WHITE, COL_BLACK);

	// next live
	if (Score >= NextLive)
	{
		Lives++;
		DispLives();
		NextLive *= 2;
	}
}

// display max. score
void DispMaxScore()
{
	char buf[6];
	int n = MaxScore;
	int i, x;
	u8 ch;
	for (i = 4; i >= 0; i--)
	{
		x = n/10;
		buf[i] = (n - x*10) + '0';
		n = x;
	}
	buf[5] = 0;
	DrawTextBg(buf, MAXSCOREX+10*8, SCOREY, ((MaxScore > 0) && (MaxScore == Score)) ? COL_GREEN : COL_WHITE, COL_BLACK);
}

// display level
void DispLevel()
{
	char buf[3];
	int n = Level+1;
	if (n > 99) n = 99;
	int i, x;
	u8 ch;
	for (i = 1; i >= 0; i--)
	{
		x = n/10;
		buf[i] = (n - x*10) + '0';
		n = x;
	}
	buf[2] = 0;
	DrawTextBg(buf, LEVELX+7*8, LEVELY, COL_WHITE, COL_BLACK);
}

// generate missiles
void GenMissile()
{
	int i, j, x, y;
	for (x = 0; x < ALIENNUMX; x++) EnemyLast[x] = True;

	i = ALIENNUM-1;
	for (y = ALIENNUMY-1; y >= 0; y--)
	{
		for (x = ALIENNUMX-1; x >= 0; x--)
		{
			if (AlienLive[i] && EnemyLast[x])
			{
				EnemyLast[x] = False;
				if ((RandU16() < 300) && (AlienY + y*ALIENDY + 8 < SHIPY))
				{
					for (j = 0; j < MISSILENUM; j++)
					{
						if (!MissileOn[j])
						{
							MissileOn[j] = True;
							MissileX[j] = AlienX + x*ALIENDX + 4;
							MissileY[j] = AlienY + y*ALIENDY + 8;
							break;
						}
					}
				}
			}

			i--;
		}
	}
}

// move missiles
void MoveMissile()
{
	int i;
	for (i = 0; i < MISSILENUM; i++)
	{
		if (MissileOn[i])
		{
			MissileY[i] += 4;
			if (MissileY[i] > SHIPY) MissileOn[i] = False;
		}
	}
}

// clear missiles
void ClearMissile()
{
	int i;
	for (i = 0; i < MISSILENUM; i++)
	{
		if (MissileOn[i])
		{
			DrawRect(MissileX[i], MissileY[i], MISSILEW, MISSILEH, COL_BLACK);
		}
	}
}

// display missiles
void DispMissile()
{
	int i;
	for (i = 0; i < MISSILENUM; i++)
	{
		if (MissileOn[i])
		{
			if (MissilePhase)
				DispSprite(MISSILE2IMGX, MISSILE2IMGY, MissileX[i], MissileY[i], MISSILEW, MISSILEH);
			else
				DispSprite(MISSILE1IMGX, MISSILE1IMGY, MissileX[i], MissileY[i], MISSILEW, MISSILEH);
		}
	}
	MissilePhase = (MissilePhase + 1) & 1;
}

// new game
void NewGame(int level)
{
	int i;

	// clear screen
	DrawClear(COL_BLACK);

	// draw houses
	for (i = 0; i < HOUSENUM; i++)
		DispSprite(HOUSEIMGX, HOUSEIMGY, HOUSEX + i*HOUSEDX, HOUSEY, HOUSEW, HOUSEH);
	ColHouse = FrameBuf[HOUSEX + HOUSEW/2 + HOUSEY*WIDTH];

	// clear missiles
	for (i = 0; i < MISSILENUM; i++) MissileOn[i] = False;

	// display ship
	ShipX = SHIPX;
	ShootOn = False;
	DispShip();

	// display bottom line
	DispLine();

	// display remaining lives
	if (level == 0)
	{
		Lives = 3;
		NextLive = 1500; // score to next live
		Score = 0;
	}
	DispLives();

	// aliens
	AlienX = ALIENTOTX;
	AlienY = ALIENTOTY + level*8;
	if (AlienY > ALIENMAXY) AlienY = ALIENMAXY;
	for (i = 0; i < ALIENNUM; i++) AlienLive[i] = True;
	AlienNum = ALIENNUM;
	AlienPhase = 0;
	AlienLeft = True;
	LimitAlien();
	DispAliens();
	AlienTimer = 1;
	AlienTone = 0;
	MissilePhase = 0;

	// display score
	NextMother = NEXTMOTHER; // score of next mothership
	MotherOn = False;
	MotherLeft = True;
	Level = level;
	SelFont8x16();
	DrawText("SCORE:", SCOREX, SCOREY, COL_WHITE);
	DispScore();

	// display max. score
	DrawText("HI-SCORE:", MAXSCOREX, SCOREY, COL_WHITE);
	DispMaxScore();

	// display level
	DrawText("LEVEL:", LEVELX, LEVELY, COL_WHITE);
	DispLevel();

	// update display
	DispUpdate();

	OldTime = Time();
}

// display shoot
void DispShoot()
{
	DispSprite(SHOOTIMGX, SHOOTIMGY, ShootX, ShootY, SHOOTW, SHOOTH);
}

// clear shoot collision
void ClearShoot()
{
	DrawRect(ShootX, ShootY, SHOOTW, SHOOTH, COL_BLACK);
}

// shoot collision service
void ShootCollision()
{
	int i, x, y, k;
	if (!ShootOn) return;

	// shoot enemy
	if ((ShootX >= AlienX) && (ShootY >= AlienY) &&
		(ShootX < AlienX + ALIENTOTW) && (ShootY < AlienY + ALIENTOTH))
	{
		x = (ShootX - AlienX)/ALIENDX;
		y = (ShootY - AlienY)/ALIENDY;
		k = y;
		i = x + y*ALIENNUMX;
		x = AlienX + x*ALIENDX - ShootX;
		y = AlienY + y*ALIENDY - ShootY;
		if (AlienLive[i] && (x < ALIENW) && (y < ALIENH))
		{
			AlienLive[i] = False;
			AlienNum--;
			ShootOn = False;
			ClearShoot();
			PLAYSOUND(HitSnd);
			DispAlien(i);
			Score += AlienScore[k];
			DispScore();
			if (Score > MaxScore)
			{
				MaxScore = Score;
				DispMaxScore();
			}			
			DispUpdate();
			WaitMs(100);
			ClearAlien(i);
			DispUpdate();
			LimitAlien();
			return;
		}
	}

	// missile collision
	for (i = 0; i < MISSILENUM; i++)
	{
		if (MissileOn[i] && (MissileX[i] < ShootX+SHOOTW) && (MissileX[i] + MISSILEW >= ShootX) &&
			(MissileY[i] < ShootY+2*SHOOTH) && (MissileY[i] + MISSILEH >= ShootY))
		{
			MissileOn[i] = False;
			ClearShoot();
			DrawRect(MissileX[i], MissileY[i], MISSILEW, MISSILEH, COL_BLACK);
			ShootOn = False;
			DispSprite(SHOOTEXPX, SHOOTEXPY, ShootX, ShootY, SHOOTEXPW, SHOOTEXPH);
			DispUpdate();
			WaitMs(150);
			ClearShoot();
			DispUpdate();
		}
	}
	if (!ShootOn) return;

	// shoot mothership
	if (MotherOn && (ShootY < MOTHERY+MOTHERH) && (ShootX+4 >= MotherX) && (ShootX < MotherX+MOTHERW))
	{
		MotherOn = False;
		ShootOn = False;
		ClearShoot();
		DispSprite(MOTHEREXPIMGX, MOTHEREXPIMGY, MotherX, MOTHERY, MOTHERW, MOTHERH);
		StopSoundChan(MOTHERCHAN);
		PLAYSOUND(HitSnd);
		Score += 1000;
		DispScore();
		if (Score > MaxScore)
		{
			MaxScore = Score;
			DispMaxScore();
		}			
		DispUpdate();
		WaitMs(100);
		DrawRect(MotherX, MOTHERY, MOTHERW, MOTHERH, COL_BLACK);
		DispUpdate();
		return;
	}
}

// move shoot
void MoveShoot()
{
	// move shoot
	if (ShootOn)
	{
		ClearShoot();
		ShootY -= 8;
		if (ShootY < MOTHERY)
			ShootOn = False;
		else
		{
			ShootHitHouse();
			if (ShootOn)
			{
				DispShoot();

				// shoot collision service
				ShootCollision();
			}
		}
		DispUpdate();
	}
}

// spaceship control
void SpaceCtrl()
{
	// move ship left
	if (KeyPressed(KEY_LEFT) && (ShipX >= 4))
	{
		ClearShip();
		ShipX -= 4;
		DispShip();
		DispUpdate();
	}

	// move ship right
	if (KeyPressed(KEY_RIGHT) && (ShipX < WIDTH-ALIENW))
	{
		ClearShip();
		ShipX += 4;
		DispShip();
		DispUpdate();
	}

	// shooting
	if (KeyPressed(KEY_A) && !ShootOn)
	{
		ShootOn = True;
		ShootX = ShipX + 4;
		ShootY = SHIPY - 8;
		PLAYSOUND(ShootSnd);
		DispShoot();
		DispUpdate();
	}
}

// move aliens
void AlienMove()
{
	// move aliens
	AlienTimer--;
	if (AlienTimer <= 0)
	{
		// clear aliens
		ClearAliens();

		// shift aliens
		if (AlienLeft)
		{
			AlienX -= 8;
			if (AlienX < AlienMinX)
			{
				AlienX += 16;
				AlienLeft = False;
				AlienY += 8;
			}
		}
		else
		{
			AlienX += 8;
			if (AlienX > AlienMaxX)
			{
				AlienX -= 16;
				AlienLeft = True;
				AlienY += 8;
			}
		}

		DispAliens();	// display aliens
		DispUpdate();
		AlienTimer = AlienNum/4+2;
		AlienPhase = (AlienPhase+1) & 1;

		AlienTone = (AlienTone+1) & 3;
		PlaySoundChan(1, Tones[AlienTone], TonesLen[AlienTone], False, 1, 1);
	}
}

// crash collision service
void Crash()
{
	int i;
	for (i = 0; i < MISSILENUM; i++)
	{
		if (MissileOn[i])
		{
			// spaceship collision
			if ((MissileX[i] < ShipX+SHIPW) && (MissileX[i] + MISSILEW >= ShipX) &&
				(MissileY[i] < SHIPY+SHIPH) && (MissileY[i] + MISSILEH >= SHIPY))
			{
				MissileOn[i] = False;
				DrawRect(MissileX[i], MissileY[i], MISSILEW, MISSILEH, COL_BLACK);

				// lost live
				Lost();
			}
		}
	}
}

// game loop
void Game()
{
	u32 t;
	int x, y, i;

	while (True)
	{
		// move shoot
		MoveShoot();

		// spaceship control
		SpaceCtrl();

		// move aliens
		AlienMove();

		// serve missiles
		ClearMissile();
		MoveMissile();
		GenMissile();
		MissileHitHouse();
		DispMissile();
		DispUpdate();

		// mothership move
		MoveMother();

		// shoot collision service
		ShootCollision();

		// crash collision service
		Crash();

		// time step
		do t = Time(); while ((u32)(t - OldTime) < (u32)50000);
		OldTime = t;

		switch (KeyGet())
		{
		// reset to boot loader
		case KEY_Y: ResetToBootLoader();

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif
		}

		// new level
		if (AlienNum == 0)
		{
			DrawTextBg(" LEVEL UP ", (WIDTH-10*8)/2, (HEIGHT-16)/2, COL_GREEN, COL_BLACK);
			DispUpdate();
			WaitMs(1000);
			KeyFlush();
			NewGame(Level+1);
		}

		// end game
		if (Lives < 0)
		{
			DrawTextBg(" GAME OVER ", (WIDTH-11*8)/2, (HEIGHT-16)/2, COL_RED, COL_WHITE);
			DispUpdate();
			WaitMs(500);
			KeyFlush();
			while (KeyGet() == NOKEY) {}
			return;
		}
	}
}

int main()
{
	while (True)
	{
		// new game
		NewGame(0);

		// game loop
		Game();
	}
}
