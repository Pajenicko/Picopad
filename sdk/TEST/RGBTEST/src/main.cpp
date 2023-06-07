
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

int main()
{
	int y;

	pDrawFont = FontBold8x16; // font 8x8
	DrawFontHeight = 16; // font height

	// draw rainbow gradient
	for (y = 0; y < HEIGHT; y++) GenGrad(&FrameBuf[y*WIDTH], WIDTH);

	// draw text
	y = 106;
#define DX 24
	DrawRect(0, y, WIDTH, 20, COL_BLACK);
	y += 2;
	DrawText("Red", DX*1-14, y, COL_RED);
	DrawText("Yellow", DX*3-20, y, COL_YELLOW);
	DrawText("Green", DX*5-10, y, COL_GREEN);
	DrawText("Cyan", DX*7, y, COL_CYAN);
	DrawText("Blue", DX*9+3, y, COL_BLUE);
	DrawText("Magenta", DX*11-2, y, COL_MAGENTA);

	// gradient
//	memcpy(&FrameBuf[126*WIDTH], GradientImg, sizeof(GradientImg));

	DispUpdateAll();

	// reset to boot loader
	while (KeyGet() != KEY_Y) {}
#if USE_SCREENSHOT		// use screen shots
	ScreenShot();
#endif
	ResetToBootLoader();
}
