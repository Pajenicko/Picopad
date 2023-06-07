
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

int main()
{
	// copy image to the screen
	DrawImgRle(MonoscopeImg, MonoscopeImg_Pal, 0, 0, WIDTH, HEIGHT);
	DispUpdateAll();

	// reset to boot loader
	while (KeyGet() != KEY_Y) {}
#if USE_SCREENSHOT		// use screen shots
	ScreenShot();
#endif
	ResetToBootLoader();
}
