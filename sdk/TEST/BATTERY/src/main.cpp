
// ****************************************************************************
//
//                                 Main code
//
// ****************************************************************************

#include "include.h"

// color
const u16 BatCol[8] = {
	COL_BLACK,		// 0
	COL_RED,		// 1
	RGBTO16(255, 120, 0),	// 2
	RGBTO16(255, 120, 0),	// 3
	RGBTO16(255, 240, 0),	// 4
	RGBTO16(255, 240, 0),	// 5
	RGBTO16(0, 240, 0),	// 6
	RGBTO16(0, 240, 0),	// 7
};

int main()
{
	int i;

	pText txt;
	TextInit(&txt);	

	// set font
	pDrawFont = FontBold8x16; // font 8x8
	DrawFontHeight = 16; // font height

	int k = 0;

	while (True)
	{
		// draw battery
		float bat = GetBat();
		i = (bat - BATTERY_EMPTY)/(BATTERY_FULL-BATTERY_EMPTY)*8;
		if (i < 0) i = 0;
		if (i > 7) i = 7;
		DrawImgRle(BatteryImg, BatteryImg_Pal, 0, 0, 128, 240);

		u16 col = BatCol[i];
		if (i > 0)
		{
			for (i--; i >= 0; i--) DrawRect(25, 198 - i*26, 77, 19, col);
		}

#define DISPX	128
#define DISPW	(WIDTH-128)
#define DY	25
		int y = 30;

		// title
		DrawText2("PicoPad", DISPX + (DISPW-7*16)/2, y, COL_YELLOW);
		y += 50;

		// SDK version
		TextPrint(&txt, "SDK version %.2f", SDK_VER*0.01f);
		DrawTextBg(TextPtr(&txt), DISPX + (DISPW - TextLen(&txt)*8)/2, y, COL_WHITE, COL_BLACK);
		y += DY;

		// CPU
		TextPrint(&txt, "CPU version RP2040-B%d", RomGetVersion() - 1);
		DrawTextBg(TextPtr(&txt), DISPX + (DISPW - TextLen(&txt)*8)/2, y, COL_WHITE, COL_BLACK);
		y += DY;

		// temperature
		TextPrint(&txt, " temperature %.1f`C ", ADC_Temp());
		DrawTextBg(TextPtr(&txt), DISPX + (DISPW - TextLen(&txt)*8)/2, y, COL_WHITE, COL_BLACK);
		y += DY;

		// battery
		TextPrint(&txt, " battery %.2fV ", bat);
		DrawTextBg(TextPtr(&txt), DISPX + (DISPW - TextLen(&txt)*8)/2, y, COL_WHITE, COL_BLACK);
		y += DY;

		// frequency
		TextPrint(&txt, " frequency %dMHz ", (ClockGetHz(CLK_SYS)+500000)/1000000);
		DrawTextBg(TextPtr(&txt), DISPX + (DISPW - TextLen(&txt)*8)/2, y, COL_WHITE, COL_BLACK);
		y += DY;

		// redraw display
		DispUpdate();

		// indicate work done
		WaitMs(100);

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
