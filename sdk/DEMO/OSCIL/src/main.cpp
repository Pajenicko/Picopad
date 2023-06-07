
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

int main()
{
	int i;
	float f1, f2, f3; // animation phase
	int lasty0, lasty, y;
	u32 t, t2, dt;

	// draw oscilloscope
	DrawImgRle(OscilImg, OscilImg_Pal, 0, 0, WIDTH, HEIGHT);

	// main loop
	f1 = f2 = f3 = 0;
	t = Time();
	lasty0 = GRIDY+GRIDH/2;
	while (True)
	{
		// draw grid
		DrawImg4Rle(GridImg, GridImg_Pal, GRIDX, GRIDY, GRIDW, GRIDH);

		// delta time
		t2 = Time();
		dt = t2 - t;
		t = t2;

		// draw samples
		lasty = lasty0;
		for (i = 1; i < GRIDW; i++)
		{
			y = GRIDY + (u8)(GRIDH*(
				sin(i*0.08 + f1)*0.25 + 
				sin(i*0.11 + f2)*0.13 + 
				sin(i*0.19 + f3)*0.08 + 
				0.5));
			DrawLine(GRIDX+i-1, lasty, GRIDX+i, y, COL_GREEN);
			lasty = y;
			if (i == 1) lasty0 = lasty;
		}

		// increase phases
		f1 += 0.3*dt/100000;
		f2 += 0.58*dt/100000;
		f3 += 1.22*dt/100000;

		// display update
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
