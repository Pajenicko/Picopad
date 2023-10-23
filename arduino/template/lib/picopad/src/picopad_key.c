
// ****************************************************************************
//
//                             PicoPad Buttons
//
// ****************************************************************************
// PicoLibSDK - Alternative SDK library for Raspberry Pico and RP2040
// Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz, hardyplotter2@gmail.com
// 	https://github.com/Panda381/PicoLibSDK
//	https://www.breatharian.eu/hw/picolibsdk/index_en.html
//	https://github.com/pajenicko/picopad
//	https://picopad.eu/en/
// License:
//	This source code is freely available for any purpose, including commercial.
//	It is possible to take and modify the code or parts of it, without restriction.

#include "picopad.h"

// buttons GPIOs
const u8 KeyGpioTab[KEY_NUM] = {
	BTN_UP_PIN,		// up
	BTN_LEFT_PIN,		// left
	BTN_RIGHT_PIN,		// right
	BTN_DOWN_PIN,		// down
	BTN_X_PIN,		// X
	BTN_Y_PIN,		// Y
	BTN_A_PIN,		// A
	BTN_B_PIN,		// B
};

// remap key to characters
const char KeyMapToChar[KEY_NUM+1] = {
	NOCHAR,		// 0 NOKEY
	CH_UP,		// 1 KEY_UP
	CH_LEFT,	// 2 KEY_LEFT
	CH_RIGHT,	// 3 KEY_RIGHT
	CH_DOWN,	// 4 KEY_DOWN
	CH_TAB,		// 5 KEY_X
	CH_ESC,		// 6 KEY_Y
	CH_CR,		// 7 KEY_A
	CH_SPC,		// 8 KEY_B
};

// time of last press/release
u16 KeyLastPress[KEY_NUM];
u16 KeyLastRelease[KEY_NUM];

// keys are currently pressed (index = button code - 1)
volatile Bool KeyPressMap[KEY_NUM];

// keyboard buffer
#define KEYBUF_SIZE	10 // size of keyboard buffer
char KeyBuf[KEYBUF_SIZE]; // keyboard buffer
char KeyRetBuf;	// returned key to keyboard buffer (NOKEY = no key)
volatile u8 KeyWriteOff; // write offset to keyboard buffer
volatile u8 KeyReadOff;	// read offset from keyboard buffer

// initialize keys
void KeyInit()
{
	int i;
	for (i = 0; i < KEY_NUM; i++)
	{
		GPIO_Init(KeyGpioTab[i]); // initialize GPIO to input
		GPIO_PullUp(KeyGpioTab[i]); // pull-up
		KeyPressMap[i] = False;
	}

	KeyRetBuf = NOKEY;
	KeyWriteOff = 0;
	KeyReadOff = 0;
}

// terminate keys
void KeyTerm()
{
	int i;
	for (i = 0; i < KEY_NUM; i++)
	{
		GPIO_Reset(KeyGpioTab[i]); // reset GPIO
	}
}

// write key to keyboard buffer
void KeyWriteKey(char key)
{
	u8 w = KeyWriteOff;
	u8 w2 = w + 1;
	if (w2 >= KEYBUF_SIZE) w2 = 0;
	_dmb();
	if (w2 != KeyReadOff)
	{
		KeyBuf[w] = key;
		KeyWriteOff = w2;
	}
}

// scan keys
void KeyScan()
{
	int i;
	u16 t = TimeMs(); // time in [ms]
	for (i = 0; i < KEY_NUM; i++)
	{
		// check if button is pressed
		if (GPIO_In(KeyGpioTab[i]) == 0)
		{
			// button is pressed for the first time
			if (!KeyPressMap[i])
			{
				KeyLastPress[i] = t + (KEY_REP_TIME1 - KEY_REP_TIME2);
				KeyPressMap[i] = True;
				KeyWriteKey(i+1);
			}

			// button is already pressed - check repeat interval
			else
			{
				if ((s32)(t - KeyLastPress[i]) >= (s16)KEY_REP_TIME2)
				{
					KeyLastPress[i] = t;
					KeyWriteKey(i+1);
				}
			}
			KeyLastRelease[i] = t;
		}

		// button is release - check stop of press
		else
		{
			if (KeyPressMap[i])
			{
				if ((s16)(t - KeyLastRelease[i]) >= (s16)KEY_REL_TIME)
				{
					KeyPressMap[i] = False;
				}
			}
		}
	}
}

// check if key KEY_* is currently pressed
Bool KeyPressed(char key)
{
#if !SYSTICK_KEYSCAN	// call KeyScan() function from SysTick system timer
	KeyScan();
#endif
	if ((key < 1) || (key > KEY_NUM)) return False;
	return KeyPressMap[key-1];
}

// get button from keyboard buffer (returns NOKEY if no scan code)
char KeyGet()
{
#if !SYSTICK_KEYSCAN	// call KeyScan() function from SysTick system timer
	// scan keyboard
	KeyScan();
#endif

	// get key from temporary 1-key buffer
	char ch = KeyRetBuf;
	if (ch != NOKEY)
	{
		KeyRetBuf = NOKEY;
		return ch;
	}

	// check if keyboard buffer is empty
	u8 r = KeyReadOff;
	_dmb();
	if (r == KeyWriteOff) return NOKEY;

	// get key from keyboard buffer
	ch = KeyBuf[r];

	// write new read offset
	r++;
	if (r >= KEYBUF_SIZE) r = 0;
	KeyReadOff = r;

	return ch;
}

// get character from local keyboard
char KeyChar()
{
	return KeyMapToChar[KeyGet()];
}

// flush keyboard buffer
void KeyFlush()
{
	KeyReadOff = KeyWriteOff;
	KeyRetBuf = NOKEY;
}

// return key to keyboard buffer (can hold only 1 key)
void KeyRet(char key)
{
	KeyRetBuf = key;
}

// check no pressed key
Bool KeyNoPressed()
{
	int i;
	for (i = 0; i < KEY_NUM; i++) if (KeyPressMap[i]) return False;
	return True;
}

// wait for no key pressed
void KeyWaitNoPressed()
{
	while (!KeyNoPressed()) {}
}

// Function to delay for a specified number of milliseconds
// Additionally, it checks for a key press every 10 milliseconds.
// If the key is pressed, return pressed key.
char wait_for_keypress(uint16_t ms) {
	char ch = NOKEY;
	for (uint16_t i = 0; i < ms / 10; i++) {
		sleep_ms(10);
		ch = KeyGet();
		if (ch != NOKEY) return ch;
	}
	return ch;
}
