
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

// main function
int main()
{
	// main loop
	while (True)
	{
		// random radius
		int r = RandU8MinMax(5,25);
		int r2 = r*r;
		int r3 = (r+r/4)*(r+r/4);

		// random center coordinate
		int xc = RandU16MinMax(r,WIDTH-r);
		int yc = RandU16MinMax(r,HEIGHT-r);

		// dirty frame
		DispDirtyRect(xc-r, yc-r, 2*r, 2*r);

		// random color
		u16 col = RandU16();

		// loop Y
		int x, y, dist;
		u16* d;
		for (y = -r; y < r; y++)
		{
			// pointer into draw box
			d = &FrameBuf[WIDTH*(yc+y) + xc-r];

			// loop X
			for (x = -r; x < r; x++)
			{
				// distance from center
				dist = x*x + y*y;

				// inside sphere
				if (dist <= r2)
				{
					// new center if right top edge
					int x2 = x - r/4;
					int y2 = y + r/4;
					dist = x2*x2 + y2*y2;

					// draw color or black
					if (dist < RandU16Max(r3))
						*d = col;
					else
						*d = COL_BLACK;
				}

				// increase destination pointer
				d++;
			}
		}

		// auto update display
		DispAutoUpdate(20);

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
