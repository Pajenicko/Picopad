
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// main function
int main()
{
	int x, x2, y;
	float phase;

	// draw sky and mast
	DrawImg4Pal(CloudsImg, CloudsImg_Pal, 0, 0, 0, 0, WIDTH, HEIGHT, WIDTH);
	DrawBlit4Pal(MastImg, MastImg_Pal, 0, 0, MASTX, HEIGHT - MASTH, MASTW, MASTH, MASTW, COL_WHITE);

	// redraw all display
	DispUpdateAll();

#define WAVELEN	0.03f	// wave length
#define WAVESPEED 0.18f	// animation speed
#define WAVEAMP 0.1f	// wave amplitude

	// main loop
	phase = 0;
	while (True)
	{
		// draw flag
		for (x = 0; x < FLAGW; x++)
		{
			// calculate vertical coordinate of the flag
			y = (int)(FLAGY + WAVEAMP*sin(phase - x*WAVELEN)*x);
			x2 = x + FLAGX + MASTX;

			// draw flag
			DrawImg4Pal(FlagImg, FlagImg_Pal, x, 0, x2, y, 1, FLAGH, FLAGW);

			// redraw sky
			if (x2 >= MASTX + MASTW) // to avoid overwrite top part of the mast
			{
				DrawImg4Pal(CloudsImg, CloudsImg_Pal, x2, 0, x2, 0, 1, y, WIDTH);
				DrawImg4Pal(CloudsImg, CloudsImg_Pal, x2, y + FLAGH, x2, y + FLAGH, 1, HEIGHT - y - FLAGH, WIDTH);
			}
		}

		// increase phase
		phase += WAVESPEED;
		if (phase > PI*2) phase -= PI*2;

		// update display
		DispUpdate();

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
	}
}
