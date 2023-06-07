
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

int main()
{
	u16 x, y;

	// main loop
	while (True)
	{
		x = RandU16Max(WIDTH-1); // random X coordinate
		y = RandU16Max(HEIGHT-1); // random Y coordinate
		DispDirtyPoint(x, y); // mark pixel to be dirty
		FrameBuf[x + y*WIDTH] = RandU16(); // write pixel
		DispAutoUpdate(20); // auto update display

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
