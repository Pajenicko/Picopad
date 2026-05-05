
// ****************************************************************************
//
//                                 Open screen
//
// ****************************************************************************

#include "open.h"

const char* const OpenCharName[4] = { "SHADOW", "SPEEDY", "BASHFUL", "POKEY" };
const char* const OpenCharNick[4] = { "\"BLINKY\"", "\"PINKY\"", "\"INKY\"", "\"CLYDE\"" };
const char* const OpenScore[4] = { "200", "400", "800", "1600" };
const u16 OpenCharCol[4] = { COL_BLINKY, COL_PINKY, COL_INKY, COL_CLYDE };

u32 LastTime;

// update display and wait
void DispWait(u32 ms)
{
	ms *= 1000;
	u32 t;
	DispUpdate();
	do {
		t = Time(); 
		if (KeyGet() == KEY_Y) reset_to_boot_loader();
	} while ((u32)(t - LastTime) < (u32)ms);
	LastTime = t;
}

// animate pellet
void AnimPellet(int y1)
{
	Blink++;
	if (Blink <= 3)
	{
		// clear pellets
		DrawRect(120, y1, TILEW, TILEH, COL_BLACK);
	}
	else
	{
		// draw pellets
		if (Blink == 6) Blink = 0;
		DrawImg4Pal(TilesImg, TilesImg_Pal, TILE_PELLET*TILEW, 0, 120, y1, TILEW, TILEH, TILESIMGW);
	}
}

// open screen (break with a valid key)
void OpenScreen()
{
	int i, x, x2, y, y1, y2, phase;

	// clear open screen
	DrawClear();

	// set font
	pDrawFont = FontBold8x8;
	DrawFontHeight = 8;

	// draw logo
	y = 3;
	DrawImg4Pal(LogoImg, LogoImg_Pal, 0, 0, (WIDTH-LOGOW)/2, y, LOGOW, LOGOH, LOGOW);
	y += LOGOH;
	DispWait(200);
	DrawText("for Raspberry Pico", (WIDTH-18*8)/2, y, COL_GREEN);
	y += 25;
	DispWait(400);

	// draw title
	DrawText("CHARACTER / NICKNAME", 90, y, COL_WHITE);
	y += 20;
	DispWait(400);

	// draw characters
	for (i = 0; i < 4; i++)
	{
		DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_BLINKY+4+i*8)*SPRITEW, 0, 70, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		DispWait(400);
		DrawText(OpenCharName[i], 110, y, OpenCharCol[i]);
		DispWait(200);
		DrawText(OpenCharNick[i], 180, y, OpenCharCol[i]);
		DispWait(200);
		y += 20;
	}
	DispWait(400);
	y += 35;

	// draw dot points
	DrawImg4Pal(TilesImg, TilesImg_Pal, TILE_DOT*TILEW, 0, 120, y, TILEW, TILEH, TILESIMGW);
	DrawText("10 pts", 140, y+2, COL_WHITE);
	y += 20;

	// draw pellet points
	y1 = y;
	DrawImg4Pal(TilesImg, TilesImg_Pal, TILE_PELLET*TILEW, 0, 120, y1, TILEW, TILEH, TILESIMGW);
	DrawText("50 pts", 140, y+2, COL_WHITE);
	y -= 40;
	DispWait(400);

	// destination pellet
	y2 = y;
	DrawImg4Pal(TilesImg, TilesImg_Pal, TILE_PELLET*TILEW, 0, 73, y2, TILEW, TILEH, TILESIMGW);
	DispWait(400);

	// prepare sprites for animation
	x = 320;
	phase = 0;
	Blink = 0;

	// play sound (2-times)
	PLAYSOUND(IntermissionSnd);

	// animate sprites to the left
	do {
		// shift sprites
		x -= CHARSPEED;

		// animate pellets
		AnimPellet(y1);
		if (Blink <= 3)
			// clear pellets
			DrawRect(73, y2, TILEW, TILEH, COL_BLACK);
		else
			// draw pellets
			DrawImg4Pal(TilesImg, TilesImg_Pal, TILE_PELLET*TILEW, 0, 73, y2, TILEW, TILEH, TILESIMGW);

		// draw sprites
		DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_PACL+phase)*SPRITEW, 0, x, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_BLINKY+phase)*SPRITEW, 0, x+SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_PINKY+phase)*SPRITEW, 0, x+2*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_INKY+phase)*SPRITEW, 0, x+3*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_CLYDE+phase)*SPRITEW, 0, x+4*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		DrawRect(x+5*SPRITEW, y-6, SPRITEW, SPRITEH, COL_BLACK);

		// animation delay
		DispWait(SPEED);

		// increase animation phase
		phase = (phase+1) & 1;

	} while (x > 70);

	// clear eaten pellet
	DrawRect(120, y1, TILEW, TILEH, COL_BLACK);
	DrawRect(73, y2, TILEW, TILEH, COL_BLACK);

	// animate sprites to the right
	x2 = x;
	Bool eat1 = False;
	Bool eat2 = False;
	Bool eat3 = False;
	Bool eat4 = False;
	Bool wait;
	do {
		// shift sprites
		x += CHARSPEED;
		x2 += FRIGHSPEED;

		if (!PlayingSound()) PLAYSOUND(IntermissionSnd);

		// animate pellets
		AnimPellet(y1);

		// eat ghosts
		wait = False;
		DrawRect(x-SPRITEW, y-6, 2*SPRITEW, SPRITEH, COL_BLACK);
		if ((x2 < x - SPRITEW/2) && !eat1)
		{
			DrawImg4Pal(SpritesImg, SpritesImg_Pal, SPRITE_200*SPRITEW, 0, x2+SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
			wait = True;
			eat1 = True;
		}
		else if ((x2 < x - SPRITEW/2-1*SPRITEW) && !eat2)
		{
			DrawImg4Pal(SpritesImg, SpritesImg_Pal, SPRITE_400*SPRITEW, 0, x2+2*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
			wait = True;
			eat2 = True;
		}
		else if ((x2 < x - SPRITEW/2-2*SPRITEW) && !eat3)
		{
			DrawImg4Pal(SpritesImg, SpritesImg_Pal, SPRITE_800*SPRITEW, 0, x2+3*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
			wait = True;
			eat3 = True;
		}
		else if ((x2 < x - SPRITEW/2-3*SPRITEW) && !eat4)
		{
			DrawImg4Pal(SpritesImg, SpritesImg_Pal, SPRITE_1600*SPRITEW, 0, x2+4*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
			wait = True;
			eat4 = True;
		}

		// draw sprites
		if (!eat1) DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_FRIGH+phase)*SPRITEW, 0, x2+SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		if (!eat2) DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_FRIGH+phase)*SPRITEW, 0, x2+2*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		if (!eat3) DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_FRIGH+phase)*SPRITEW, 0, x2+3*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);
		if (!eat4) DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_FRIGH+phase)*SPRITEW, 0, x2+4*SPRITEW, y-6, SPRITEW, SPRITEH, SPRITEIMGW);

		// draw pacman
		if (!wait) DrawImg4Pal(SpritesImg, SpritesImg_Pal, (SPRITE_PACR+phase)*SPRITEW, 0, x, y-6, SPRITEW, SPRITEH, SPRITEIMGW);

		// animation delay
		DispWait(SPEED);
		if (wait)
		{
			for (i = 1000/SPEED; i > 0; i--)
			{
				// animate pellets
				AnimPellet(y1);
				DispWait(SPEED);
			}
		}

		// increase animation phase
		phase = (phase+1) & 1;

	} while (x < WIDTH);

	// wait for sound
	while (PlayingSound())
	{
		// animate pellets
		AnimPellet(y1);
		DispWait(SPEED);
	}
}
