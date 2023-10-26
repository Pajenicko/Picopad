
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

#ifndef _PICOPAD_KEY_H
#define _PICOPAD_KEY_H

#ifdef __cplusplus
extern "C" {
#endif

// buttons codes (= button indice + 1) (0 = no key)
#define KEY_UP		1	// up
#define KEY_LEFT	2	// left
#define KEY_RIGHT	3	// right
#define KEY_DOWN	4	// down
#define KEY_X		5	// X
#define KEY_Y		6	// Y
#define KEY_A		7	// A
#define KEY_B		8	// B

#define KEY_NUM		8	// number of buttons

// timings
#define KEY_REL_TIME	50	// delta time of release in [ms]

// initialize keys
void KeyInit();

// terminate keys
void KeyTerm();

// check if button KEY_* is currently pressed
Bool KeyPressed(char key);

// scan keyboard (called from SysTick)
void KeyScan();

// get button from keyboard buffer (returns NOKEY if no scan code)
char KeyGet();

// get character from local keyboard (returns NOCHAR if no character)
char KeyChar();

// flush keyboard buffer
void KeyFlush();

// return key to keyboard buffer (can hold only 1 key)
void KeyRet(char key);

// check no pressed key
Bool KeyNoPressed();

// wait for no key pressed
void KeyWaitNoPressed();

// Function to delay for a specified number of milliseconds
// Additionally, it checks for a key press every 10 milliseconds.
// If the key is pressed, return pressed key.
char wait_for_keypress(uint16_t ms);

#ifdef __cplusplus
}
#endif

#endif // _PICOPAD_KEY_H
