
// ****************************************************************************
//
//                              PicoPad LEDs
//
// ****************************************************************************

#include "../../global.h"	// globals
#include "../../_sdk/inc/sdk_gpio.h"
#include "picopad_led.h"

// GPIO with LED
const u8 LedGpioTab[LED_NUM] = {
	LED1_PIN,	// LED1 inverted, blue, on right
	LED2_PIN,	// default internal LED pin, on Pico board
};

// GPIO invert flag
const Bool LedGpioTabInv[LED_NUM] = {
	True,		// LED1 inverted, blue, on right
	False,		// default internal LED pin, on Pico board
};

// set LED ON (inx = LED index LED?)
void LedOn(u8 inx)
{
	GPIO_Out1(LedGpioTab[inx]);
}

// set LED OFF (inx = LED index LED?)
void LedOff(u8 inx)
{
	GPIO_Out0(LedGpioTab[inx]);
}

// flip LED (inx = LED index LED?)
void LedFlip(u8 inx)
{
	GPIO_Flip(LedGpioTab[inx]);
}

// set LED (inx = LED index LED?)
void LedSet(u8 inx, u8 val)
{
	if (val == 0) LedOff(inx); else LedOn(inx);
}

// initialize LEDs
void LedInit()
{
	int i;
	for (i = 0; i < LED_NUM; i++)
	{
		GPIO_Init(LedGpioTab[i]);
		GPIO_DirOut(LedGpioTab[i]);
		if (LedGpioTabInv[i]) GPIO_OutOverInvert(LedGpioTab[i]);
		LedOff(i);
	}
}

// terminate LEDs
void LedTerm()
{
	int i;
	for (i = 0; i < LED_NUM; i++)
	{
		GPIO_Reset(LedGpioTab[i]);
	}
}
