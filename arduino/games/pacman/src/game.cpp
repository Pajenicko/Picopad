
// ****************************************************************************
//
//                                 Game
//
// ****************************************************************************
#include "Arduino.h"
#include "data.h"
#include "img/logo.h"
#include "img/tiles.h"
#include "img/sprites.h"
#include "img/status.h"

#include "snd/startsnd.h"
#include "snd/siren.h"
#include "snd/wakka.h"
#include "snd/frighten.h"
#include "snd/eatghost.h"
#include "snd/eatfruit.h"
#include "snd/death.h"
#include "snd/extrapac.h"

// Generate an 8-bit signed integer random number in range MIN to MAX (inclusive).
// If MIN > MAX, then the number is generated out of interval.
// Takes approximately 2 us.
s8 RandS8MinMax(s8 min, s8 max) {
	// If min is greater than max, return a random number outside the interval [min, max].
	if (min > max) {
		// Generate a random number and check if it lies outside [min, max].
		// If it lies within the range, flip the sign to push it outside.
		s8 result = rp2040.hwrand32() & 0xFF;  // Take lower 8 bits.
		return (result >= min && result <= max) ? -result : result;
	}

	// If min equals max, return min.
	if (min == max) return min;

	// Compute the range
	uint8_t range = max - min + 1;

	// Generate a random number within the desired range.
	return (rp2040.hwrand32() % range) + min;
}

// put tile on the board
void PutTile(u8 x, u8 y, u8 tile)
{
	Board[x + y*MAPW] = tile;
}

// get tile from board
u8 GetTile(u8 x, u8 y) { return Board[x + y*MAPW]; }

// Display all
void DispAll(u32 wait)
{
	int i, j, k, n, x, y;
	u8 *s;
	sChar* ch;
	Bool moving;
	u8 b, tile;
	u32 t;

	// clear screen
	DrawClear();

	// update blink pellets
	b = Blink + 1;
	if (b == 3)
	{
		b = 0;
		for (y = 0; y < MAPH; y++)
		{
			for (x = 0; x < MAPW; x++)
			{
				tile = GetTile(x, y);
				if (tile == TILE_PELLET)
					PutTile(x, y, TILE_PELLETOFF);
				else if (tile == TILE_PELLETOFF)
					PutTile(x, y, TILE_PELLET);
			}
		}
	}
	Blink = b;

	// display board
	s = Board;
	for (y = 0; y < MAPH; y++)
	{
		for (x = 0; x < MAPW; x++)
		{
			DrawImg4Pal(TilesImg, TilesImg_Pal, (*s++)*TILEW, 0, x*TILEW+MAPX, y*TILEH+MAPY, TILEW, TILEH, TILESIMGW);
		}
	}

	// fruit
	if (FruitSpriteImg >= 0)
		DrawBlit4Pal(SpritesImg, SpritesImg_Pal, FruitSpriteImg*SPRITEW, 0, FruitSpriteX,
			FruitSpriteY, SPRITEW, SPRITEH, SPRITEIMGW, COL_BLACK);

	// display score
	n = DecUNum(NumBuf, Score, 0);
	DrawText(NumBuf, 115 - n*4, HEIGHT-9, COL_WHITE);

	// max. score
	n = DecUNum(NumBuf, MaxScore, 0);
	DrawText(NumBuf, 185 - n*4, HEIGHT-9, ((MaxScore == Score) && (MaxScore > 0)) ? COL_GREEN : COL_WHITE);

	// display remaining lives
	for (i = 0; i < 5; i++)
	{
		if (i < Lives)
			DrawImg4Pal(StatusImg, StatusImg_Pal, 0, 0, i*STATUSW+MAPX,
				HEIGHT-STATUSH, STATUSW, STATUSH, STATUSIMGW);
		else
			DrawRect(i*STATUSW+MAPX, HEIGHT-STATUSH, STATUSW, STATUSH, COL_BLACK);
	}	

	// display level
	j = 0;
	k = Level;
	if (k > 6) j = k - 6;
	for (i = 0; i < 7; i++)
	{
		if (j > FRUITTABMAX-1) j = FRUITTABMAX-1;
		if (j <= k)
			DrawImg4Pal(StatusImg, StatusImg_Pal, (FruitTab[j]+1)*STATUSW, 0, MAPX+MAPWIDTH-(i+1)*STATUSW,
				HEIGHT-STATUSH, STATUSW, STATUSH, STATUSIMGW);
		else
			DrawRect(MAPX+MAPWIDTH-(i+1)*STATUSW, HEIGHT-STATUSH, STATUSW, STATUSH, COL_BLACK);
		j++;
	}	

	// display sprites
	for (i = 0; i < 5; i++)
	{
		ch = &Chars[i];
		moving = (ch->dx != 0) || (ch->dy != 0);
		k = i;
		if (ch->state == S_FRIGHTEN)
		{
			k = CH_FRIGHTEN;
			if ((FrightenCnt < 3000/SPEED) && ((FrightenCnt & 4) == 0)) k = CH_FROZEN;
		}
		else if (ch->state == S_EATEN)
			k = CH_EYES;

		if ((i == CH_PACMAN) && (ch->state != 0)) // pacman dead
			k = ch->state;
		else
			k = SpriteInx[k*4*4 + ch->dir*4 + (moving ? Phase : 1)]; // get sprite index

		// display sprite
		DrawBlit4Pal(SpritesImg, SpritesImg_Pal, k*SPRITEW, 0, ch->x, ch->y, SPRITEW, SPRITEH, SPRITEIMGW, COL_BLACK);
	}

	// update display
	DispUpdate();

	// wait
	wait *= 1000;
	do t = Time(); while ((u32)(t - DispNextTime) < (u32)wait);
	DispNextTime = t;
}

// shift X coordinate in direction (wrap coordinate and direction)
s8 ShiftX(s8 x, s8 dir)
{
	dir &= 3;
	x += DirX[dir];
	if (x < 0) x += MAPW;
	if (x >= MAPW) x -= MAPW;
	return x;
}

// shift Y coordinate in direction (wrap coordinate and direction)
s8 ShiftY(s8 y, s8 dir)
{
	dir &= 3;
	y += DirY[dir];
	if (y < 0) y += MAPH;
	if (y >= MAPH) y -= MAPH;
	return y;
}

// get board 1 step in (wrapped) direction
u8 GetBoardDir(s8 x, s8 y, s8 dir)
{
	x = ShiftX(x, dir);
	y = ShiftY(y, dir);
	return GetTile(x, y);
}

// check free tile on the direction (gate = gate is transparent)
Bool CheckBoard(s8 x, s8 y, s8 dir, Bool gate)
{
	u8 b = GetBoardDir(x, y, dir);
	return (b == TILE_EMPTY) || (b == TILE_DOT) || (b == TILE_PELLET) ||
		(b == TILE_PELLETOFF) || ((b == TILE_GATE) && gate);
}

// add (and display) score
void AddScore(int score)
{
	Score += score;
	if (Score > MaxScore) MaxScore = Score;

	// extra pacman
	if ((Score >= 10000) && (Score - score < 10000))
	{
		Lives++;
		DispAll(1);
		PLAYSOUND(ExtraPacSnd);
		while (PlayingSound()) {}
	}
}

// dot eaten
void EatDot()
{
	DotCnt--;
	int i;

	// appear fruit
	if ((DotCnt == DOT_FRUIT1) || (DotCnt == DOT_FRUIT2))
	{
		// get bonus symbol
		i = Level;
		if (i > FRUITTABMAX-1) i = FRUITTABMAX-1;
		i = FruitTab[i] + SPRITE_FRUIT;

		// display fruit
		FruitSpriteImg = i;
		FruitSpriteX = (WIDTH-SPRITEW)/2;
		FruitSpriteY = MAPTOY(13);

		// fruit time counter 10 seconds
		FruitCnt = 10*1000/SPEED;
	}
}

// move characters (returns False on death)
Bool Move()
{
	int i, j, dist, bestdist;
	int targx, targy, bestx, besty, dir, dir2, bestdir, x0, x2, y0, y2, dx, dy, xpac, ypac, dirpac;
	u8 tile;
	sChar* ch;
	sChar* ch2;
	Bool athome, atgate;

	// prepare pacman coordinates
	xpac = XTOMAP(Chars[CH_PACMAN].x);
	ypac = YTOMAP(Chars[CH_PACMAN].y);
	dirpac = Chars[CH_PACMAN].dir;

	for (i = 0; i < 5; i++)
	{
		ch = &Chars[i];

		// move
		ch->x += ch->dx;
		if (ch->x >= MAPX+MAPWIDTH-SPRITEW/2) ch->x -= MAPWIDTH;
		if (ch->x < MAPX-SPRITEW/2) ch->x += MAPWIDTH;
		ch->y += ch->dy;
		if (ch->y >= MAPY+MAPHEIGHT-SPRITEH/2) ch->y -= MAPHEIGHT;
		if (ch->y < MAPY-SPRITEH/2) ch->y += MAPHEIGHT;
		ch->steps--;

		// end of step
		if (ch->steps <= 0)
		{
			// pacman
			if (i == CH_PACMAN)
			{
				// correction coordinates if step is not precise
				xpac = XTOMAP(ch->x);
				ypac = YTOMAP(ch->y);
				ch->x = MAPTOX(xpac);
				ch->y = MAPTOY(ypac);

				// collision with ghost
				for (j = 1; j < 5; j++)
				{
					// check distance to ghost
					ch2 = &Chars[j];
					if (((ch2->x - ch->x)*(ch2->x - ch->x) + 
						(ch2->y - ch->y)*(ch2->y - ch->y)) < (SPRITEW-3)*(SPRITEH-3))
					{
						// eat ghost
						if (ch2->state == S_FRIGHTEN)
						{
							ch2->state = S_EATEN;
							PLAYSOUND(EatGhostSnd);
							AddScore(Eaten);
							Eaten *= 2; // increase eaten bonus
						}

						// eaten by the ghost
						else if (ch2->state != S_EATEN)
						{
							// Pacman death
							PLAYSOUND(DeathSnd);
#ifndef DEBUG_DDQD	// flag - debug immortality
							Lives--;
#endif

							// hide ghosts
							int n;
							for (n = 1; n < 5; n++) Chars[n].y = HEIGHT + 100;

							// animate death
							for (n = SPRITE_DIE; n < SPRITE_DIE+SPRITE_DIENUM; n++)
							{
								ch->state = n;
								DispAll(300);
							}
							ch->state = 0;
							ch->y = HEIGHT+100;
							DispAll(2000);
							return False;
						}
					}
				}

				if ((FrightenCnt > 0) && !PlayingSound())
					SetNextSound(FrightenSnd, sizeof(FrightenSnd));

				// collect dot
				tile = GetTile(xpac, ypac);
				if (tile == TILE_DOT)
				{
					if (FrightenCnt == 0) SetNextSound(WakkaSnd, sizeof(WakkaSnd));
					PutTile(xpac, ypac, TILE_EMPTY);
					AddScore(10);
					EatDot();
				}

				// collect pellet
				else if ((tile == TILE_PELLET) || (tile == TILE_PELLETOFF))
				{
					SetNextSound(FrightenSnd, sizeof(FrightenSnd));
					if (Level < FRIGHTENTABMAX) FrightenCnt = FrightenTab[Level]*1000/SPEED;
					Eaten = 200;
					PutTile(xpac, ypac, TILE_EMPTY);
					AddScore(50);

					// frighten ghosts
					for (j = 1; j < 5; j++)
					{
						ch2 = &Chars[j];
						if (ch2->state != S_EATEN)
						{
							if (FrightenCnt > 0) ch2->state = S_FRIGHTEN;
							ch2->dir = (ch2->dir + 2) & 3; // turn around
						}
					}
					EatDot();
				}

				// collect bonus fruit
				else if ((FruitCnt > 0) && 
					(((ch->x - FruitSpriteX)*(ch->x - FruitSpriteX) +
					((ch->y - FruitSpriteY)*(ch->y - FruitSpriteY))) < SPRITEW*SPRITEH))
				{
					// add score
					j = Level;
					if (j > FRUITTABMAX-1) j = FRUITTABMAX-1;
					j = FruitTab[j];
					j = BonusTab[j];
					AddScore(j);

					// play sound
		       			PLAYSOUND(EatFruitSnd);

					// hide fruit
					FruitSpriteImg = -1;
					FruitCnt = 0;
				}
				else
				{
					if (FrightenCnt == 0) SetNextSound(SirenSnd, sizeof(SirenSnd));
				}

				// change direction
				if (CheckBoard(xpac, ypac, NextDir, False))
				{
					dirpac = NextDir;
					Chars[CH_PACMAN].dir = dirpac;
				}

				// check tile if it is empty
				if (CheckBoard(xpac, ypac, dirpac, False))
				{
					// do step
					dx = ShiftX(xpac, dirpac) - xpac;
					if (dx < -MAPW/2) dx += MAPW;
					if (dx > MAPW/2) dx -= MAPW;
					ch->dx = dx*CHARSPEED;

					dy = ShiftY(ypac, dirpac) - ypac;
					if (dy < -MAPH/2) dy += MAPH;
					if (dy > MAPH/2) dy -= MAPH;
					ch->dy = dy*CHARSPEED;

					ch->steps = CHARSTEPS;
				}

				// else stop moving
				else
				{
					ch->dx = 0;
					ch->dy = 0;
					ch->steps = 1;
				}
			}

			// ghosts
			else
			{
				// prepare current coordinate
				x0 = XTOMAP(ch->x);
				y0 = YTOMAP(ch->y);
				dir = ch->dir;

				// correction current coordinate - step can be not precise during eaten state
				ch->y = MAPTOY(y0);
				ch->x = MAPTOX(x0);

				// check if at home
				athome = (x0 >= HOMEXMIN) && (x0 <= HOMEXMAX) &&
					(y0 >= HOMEYMIN) && (y0 <= HOMEYMAX);

				// check if at gate
				atgate = ((dir == DIR_U) || (dir == DIR_D)) &&
					(x0 == HOMEXMID) &&
					(y0 == 9); //(y0 >= 9) && (y0 <= HOMEYMAX);

				// ghost at home or at the gate
				if (athome || atgate)
				{
					// correct coordinates
					if (atgate) ch->x = (WIDTH-SPRITEW)/2;

					// sleeping at home
					if (ch->sleeptimer > 0)
					{
						if (y0 == HOMEYMIN)
						{
							ch->dy = CHARSPEED;
							ch->dir = DIR_D;
						}

						if (y0 == HOMEYMAX)
						{
							ch->dy = -CHARSPEED;
							ch->dir = DIR_U;
						}
						ch->steps = CHARSTEPS;
						continue;
					}

					// eaten mode - go home
					if (ch->state == S_EATEN)
					{
						targx = HOMEXMID;
						targy = HOMEYMAX;
					}

					// respawn at home
					if (athome)
					{
						if (ch->state == S_EATEN) ch->state = (ScatterCnt > 0) ? S_SCATTER : S_CHASE;

						// go out from the house
						targx = HOMEXMID;
						targy = 8; //0;
					}
				}
				else
				{
					// prepare new target tile
					switch (ch->state)
					{
					// scatter mode - go to corners
					case S_SCATTER:
						switch (i)
						{
						case CH_BLINKY: // Blinky: target to right up corner
							targx = MAPW-3;
							targy = -3;
							break;

						case CH_PINKY: // Pinky: target to left up corner
							targx = 3;
							targy = -3;
							break;

						case CH_INKY: // Inky: target to right down corner
							targx = MAPW-1;
							targy = MAPH+2;
							break;

						case CH_CLYDE: // Clyde: target to left down corner
							targx = 0;
							targy = MAPH+2;
							break;
						}
						break;

					// chase mode - follow pacman
					case S_CHASE: // target is tile with pacman
						switch (i)
						{
						case CH_BLINKY: // Blinky: target is tile with pacman
							targx = xpac;
							targy = ypac;
							break;

						case CH_PINKY: // Pinky: target is 4 steps before pacman
							targx = xpac + 4*DirX[dirpac];
							targy = ypac + 4*DirY[dirpac];

							// direction UP adds 4 steps to the left
							if (dirpac == DIR_U) targx -= 4;
							break;

						case CH_INKY: // Inky: 2 steps before pacman and then inverse vector to Blinky

							// reference is 2 steps before pacman
							targx = xpac + 2*DirX[dirpac];
							targy = ypac + 2*DirY[dirpac];

							// direction UP adds 2 steps to the left
							if (dirpac == DIR_U) targx -= 2;

							// use inverse vector to Blinky position
							targx = targx + (targx - XTOMAP(Chars[CH_BLINKY].x));
							targy = targy + (targy - YTOMAP(Chars[CH_BLINKY].y));
							break;

						case CH_CLYDE: // Clyde follow pacman (dist > 8) or scatter (dist < 8)

							// check distance to pacman
							targx = xpac - x0;
							targy = ypac - y0;

							if (((int)targx*targx + (int)targy*targy) >= 8*8)
							{
								// distance is > 8 tiles, target is tile with pacman
								targx = xpac;
								targy = ypac;
							}
							else
							{
								// distance is < 8 tiles, target is left down corner
								targx = 0;
								targy = MAPH+2;
							}
							break;
						}
						break;

					// eaten mode - go home
					case S_EATEN:
						targx = HOMEXMID;
						targy = HOMEYMAX;
						break;

					// other modes - random
					default:
						targx = x0 + RandS8MinMax(-10, +10);
						targy = y0 + RandS8MinMax(-10, +10);
						break;
					}
				}
				
				// find best next tile
				bestdist = 100*100;
				bestdir = dir;
				bestx = x0;
				besty = y0;
				for (dir2 = dir-1; dir2 <= dir+(athome ? 2 : 1); dir2++)
				{
					// check tile if it is empty
					if (CheckBoard(x0, y0, dir2, (athome || (ch->state == S_EATEN))))
					{
						// check distance to target
						x2 = ShiftX(x0, dir2);
						y2 = ShiftY(y0, dir2);
						dist = (targx-x2)*(targx-x2) + (targy-y2)*(targy-y2);

						// better distance
						if (dist < bestdist)
						{
							bestdist = dist;
							bestx = x2;
							besty = y2;
							bestdir = dir2;
						}
					}
				}

				// not found
				if (bestdist == 100*100)
				{
					ch->dx = 0;
					ch->dy = 0;
					ch->steps = 1;
				}
				else
				{
					// wrap new direction
					bestdir &= 3;

					// start moving to next tile
					ch->dir = bestdir;

					dx = bestx - x0;
					if (dx < MAPW/2) dx += MAPW;
					if (dx > MAPW/2) dx -= MAPW;

					dy = besty - y0;
					if (dy < MAPH/2) dy += MAPH;
					if (dy > MAPH/2) dy -= MAPH;

					if (ch->state == S_FRIGHTEN)
					{
						ch->dx = dx*(CHARSPEED/2);
						ch->dy = dy*(CHARSPEED/2);
						ch->steps = CHARSTEPS*2;
					}
					else if (ch->state == S_EATEN)
					{
						ch->dx = dx*CHARSPEED*2;
						ch->dy = dy*CHARSPEED*2;
						ch->steps = CHARSTEPS/2;
					}
					else
					{
						ch->dx = dx*CHARSPEED;
						ch->dy = dy*CHARSPEED;
						ch->steps = CHARSTEPS;
					}
				}
			}
		}
	}

	return True;
}

// initialize new game (cont = continue current level)
void NewGame(Bool cont)
{
	int i, x, y;

	DispNextTime = Time(); // display next time

	// hide sprites
	for (i = 0; i < 5; i++)
	{
		Chars[i].steps = CHARSTEPS/2;
		Chars[i].dx = 0;
		Chars[i].dy = 0;
		Chars[i].state = S_SCATTER;
		Chars[i].anim = i*4*4;
		Chars[i].sleeptimer = 0;
		Chars[i].x = WIDTH;
		Chars[i].y = HEIGHT;
	}

	// initialize game screen
	if (!cont)
	{
		FrightenCnt = 0; // frighten counter
		DotCnt = DOT_NUM; // dot counter
		FruitSpriteImg = -1;
		FruitCnt = 0; // fruit counter

		// draw board
		const u8* s = BoardTemp;
		for (y = 0; y < MAPH; y++)
		{
			for (x = 0; x < MAPW; x++) PutTile(x, y, *s++);
		}
	}
	else
	{
		// display READY text
		for (i = 11; i <= 16; i++) PutTile(i, 13, 35 + i - 11);
	}

	// play start music
	PLAYSOUND(StartSnd);

	// delay
	DispAll(2000);

	// initialize variables
	Phase = 0; // reset animation phase
	NextDir = DIR_L; // pacman next direction
	Blink = 0;

	// prepare sprites
	Chars[CH_PACMAN].x = (WIDTH-SPRITEW)/2;
	Chars[CH_PACMAN].y = MAPTOY(17);
	Chars[CH_PACMAN].dx = CHARSPEED;
	Chars[CH_PACMAN].dir = DIR_L;

	Chars[CH_BLINKY].x = (WIDTH-SPRITEW)/2;
	Chars[CH_BLINKY].y = MAPTOY(8);
	Chars[CH_BLINKY].dx = CHARSPEED;
	Chars[CH_BLINKY].dir = DIR_L;

	Chars[CH_PINKY].x = (WIDTH-SPRITEW)/2;
	Chars[CH_PINKY].y = MAPTOY(10);
	Chars[CH_PINKY].dy = CHARSPEED;
	Chars[CH_PINKY].dir = DIR_D;

	Chars[CH_INKY].x = (WIDTH-SPRITEW)/2-SPRITEW;
	Chars[CH_INKY].y = MAPTOY(10);
	Chars[CH_INKY].dy = -CHARSPEED;
	Chars[CH_INKY].dir = DIR_U;
	Chars[CH_INKY].sleeptimer = 5000/SPEED; // sleep 5 seconds

	Chars[CH_CLYDE].x = (WIDTH-SPRITEW)/2+SPRITEW;
	Chars[CH_CLYDE].y = MAPTOY(10);
	Chars[CH_CLYDE].dy = -CHARSPEED;
	Chars[CH_CLYDE].dir = DIR_U;
	Chars[CH_CLYDE].sleeptimer = 15000/SPEED; // sleep 15 seconds

	// delay, wait for music end
	DispAll(2000);
	while (PlayingSound()) {}

	// clear ready text
	for (i = 11; i <= 16; i++) PutTile(i, 13, TILE_EMPTY);

	// prepare scatter timer
	i = Level;
	if (i > 4) i = 4;
	ScatterCnt = ScatterTab[i*4*2]*1000/SPEED;
	ScatterTabNext = 1;
	ChaseCnt = 0;
}

// wake up ghosts
void WakeUp()
{
	int i;

	// wake up ghosts
	for (i = 1; i < 5; i++)
	{
		if (Chars[i].sleeptimer > 0) Chars[i].sleeptimer--;
	}
}

// unfrighten ghosts, update scatter and chase timers
void Unfrighten()
{
	int i;

	if (FrightenCnt > 0)
	{
		FrightenCnt--;
		if (FrightenCnt == 0)
		{
			for (i = 1; i < 5; i++)
			{
				if (Chars[i].state == S_FRIGHTEN)
				{
					Chars[i].state = (ScatterCnt > 0) ? S_SCATTER : S_CHASE;
				}
			}
		}
	}

	// unpause scatter/chase counters
	else
	{
		if (ScatterCnt > 0)
		{
			ScatterCnt--;
			if (ScatterCnt == 0)
			{
				for (i = 1; i < 5; i++)
				{
					if (Chars[i].state == S_SCATTER)
					{
						Chars[i].state = S_CHASE;
						Chars[i].dir = (Chars[i].dir + 2) & 3; // turn around
					}
				}

				i = Level;
				if (i > 4) i = 4;
				i = ScatterTab[i*4*2 + ScatterTabNext];
				ChaseCnt = i*1000/SPEED;
				ScatterTabNext++;
			}
		}

		else if (ChaseCnt > 0)
		{
			ChaseCnt--;
			if (ChaseCnt == 0)
			{
				for (i = 1; i < 5; i++)
				{
					if (Chars[i].state == S_CHASE)
					{
						Chars[i].state = S_SCATTER;
						Chars[i].dir = (Chars[i].dir + 2) & 3; // turn around
					}
				}

				i = Level;
				if (i > 4) i = 4;
				i = ScatterTab[i*4*2 + ScatterTabNext];
				ScatterCnt = i*1000/SPEED;
				ScatterTabNext++;
			}
		}
	}
}

// open new game
void OpenGame()
{
	char ch;

	// initialize new game
	Score = 0; // reset score
	Level = 0; // start level
	Lives = 4; // remaining lives
	NewGame(False);

/*
	// DEBUG: count and display number of dots+pellets
	int i;
	for (i = 0; i < MAPSIZE; i++) if ((BoardTemp[i] == TILE_DOT) || (BoardTemp[i] == TILE_PELLET)) Score++;
	DispAll(100000);
*/

	// game loop
	while (True)
	{
		// keyboard
		ch = KeyGet();
		switch (ch)
		{
		// left
		case KEY_LEFT:
			NextDir = DIR_L;
			break;

		// right
		case KEY_RIGHT:
			NextDir = DIR_R;
			break;

		// up
		case KEY_UP:
			NextDir = DIR_U;
			break;

		// down
		case KEY_DOWN:
			NextDir = DIR_D;
			break;

		// pause
		case KEY_A:
			StopSound();
			KeyFlush();
			DispAll(1);
			while (KeyGet() == NOKEY) {}
			PLAYSOUND(SirenSnd);
			break;

		case KEY_Y:
			return;

#if USE_SCREENSHOT		// use screen shots
		case KEY_X:
			ScreenShot();
			break;
#endif

		// no key
		case NOKEY:
			break;

		// invalid key
		default:
			KeyFlush();
			break;
		}

		// increase animation phase
		Phase = (Phase+1) & 3;

		// wake up ghosts
		WakeUp();

		// unfrighten ghosts, update scatter and chase timers
		Unfrighten();

		// hide bonus
		if (FruitCnt > 0)
		{
			FruitCnt--;
			if (FruitCnt == 0) FruitSpriteImg = -1;
		}

		// move characters
		if (!Move())
		{
			// death
			if (Lives < 0) return;
			NewGame(True);
		}

		// animation delay
		DispAll(SPEED);

		// next level
		if (DotCnt <= 0)
		{
			StopSound();
			WaitMs(2000);
			Level++;
			NewGame(False);
		}
	}
}
