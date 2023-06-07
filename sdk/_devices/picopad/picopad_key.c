
// ****************************************************************************
//
//                             PicoPad Buttons
//
// ****************************************************************************

#include "../../global.h"	// globals
#include "../../_sdk/inc/sdk_gpio.h"
#include "../../_sdk/inc/sdk_timer.h"
#include "picopad_key.h"

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

// time of last press/release
u32 KeyLastPress[KEY_NUM];
u32 KeyLastRelease[KEY_NUM];

// keys are currently pressed
Bool KeyPressMap[KEY_NUM];

// keyboard buffer
#define KEYBUF_SIZE	10 // size of keyboard buffer
char KeyBuf[KEYBUF_SIZE]; // keyboard buffer
char KeyRetBuf;	// returned key to keyboard buffer (NOKEY = no key)
u8 KeyWriteOff; // write offset to keyboard buffer
u8 KeyReadOff;	// read offset from keyboard buffer

// initilize keys
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
	u32 t = Time();
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
				KeyWriteKey(i);
			}

			// button is already pressed - check repeat interval
			else
			{
				if ((s32)(t - KeyLastPress[i]) >= (s32)KEY_REP_TIME2)
				{
					KeyLastPress[i] = t;
					KeyWriteKey(i);
				}
			}
			KeyLastRelease[i] = t;
		}

		// button is release - check stop of press
		else
		{
			if (KeyPressMap[i])
			{
				if ((s32)(t - KeyLastRelease[i]) >= (s32)KEY_REL_TIME)
				{
					KeyPressMap[i] = False;
				}
			}
		}
	}
}

// check if button BTN_* is currently pressed
Bool KeyPressed(char key)
{
	KeyScan();
	return KeyPressMap[key];
}

// get button from keyboard buffer (returns NOKEY if no scan code)
char KeyGet()
{
	// scan keyboard
	KeyScan();

	// get key from temporary 1-key buffer
	char ch = KeyRetBuf;
	if (ch != NOKEY)
	{
		KeyRetBuf = NOKEY;
		return ch;
	}

	// check if keyboard buffer is empty
	u8 r = KeyReadOff;
	if (r == KeyWriteOff) return NOKEY;

	// get key from keyboard buffer
	ch = KeyBuf[r];

	// write new read offset
	r++;
	if (r >= KEYBUF_SIZE) r = 0;
	KeyReadOff = r;

	return ch;
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
