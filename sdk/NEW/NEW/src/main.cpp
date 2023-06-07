
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "../include.h"

int main()
{
	// draw text
	DrawText2("Hello World!", (WIDTH-12*8*2)/2, (HEIGHT-8*2)/2, COL_WHITE);
	DispUpdate();

	// reset to boot loader
	while (KeyGet() != KEY_Y) {}
#if USE_SCREENSHOT		// use screen shots
	ScreenShot();
#endif
	ResetToBootLoader();
}
