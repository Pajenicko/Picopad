
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../include.h"

// Render time on 1 core: 15 sec, render time on 2 cores: 8 sec
int main()
{
#if RENDER_BOTHCORES	// 1 = use both cores to render, 0 = use only core 0

	// start render on core 1
	Core1Exec(Render3D);

	// leaving little head start for core 1 so that both lines can be displayed simultaneously
	WaitMs(100);

#endif

	// render image without antialiasing
	Render3D();

	// some delay if core 1 was too late
	WaitMs(100);

	// update display
	DispUpdateAll();

	while(True)
	{
		// indicate work done
		LedOn(LED1);
		WaitMs(125);
		LedOff(LED1);
		WaitMs(125);

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
