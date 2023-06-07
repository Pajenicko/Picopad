
// ****************************************************************************
//
//                             PicoPad Buttons
//
// ****************************************************************************

#ifndef _PICOPAD_KEY_H
#define _PICOPAD_KEY_H

#ifdef __cplusplus
extern "C" {
#endif

// buttons GPIO
#define BTN_UP_PIN	4	// up
#define BTN_LEFT_PIN	3	// left
#define BTN_RIGHT_PIN	2	// right
#define BTN_DOWN_PIN	5	// down
#define BTN_X_PIN	9	// X
#define BTN_Y_PIN	8	// Y
#define BTN_A_PIN	7	// A
#define BTN_B_PIN	6	// B

// buttons indices
#define KEY_UP		0	// up
#define KEY_LEFT	1	// left
#define KEY_RIGHT	2	// right
#define KEY_DOWN	3	// down
#define KEY_X		4	// X
#define KEY_Y		5	// Y
#define KEY_A		6	// A
#define KEY_B		7	// B

#define KEY_NUM		8	// number of buttons

#define NOKEY		127	// no button

// timings
#define KEY_REP_TIME1	400000	// delta time of first press
#define KEY_REP_TIME2	100000	// delta time of repeat press
#define KEY_REL_TIME	50000	// delta time of release

// initilize keys
void KeyInit();

// terminate keys
void KeyTerm();

// check if button BTN_* is currently pressed
Bool KeyPressed(char key);

// scan keyboard
void KeyScan();

// get button from keyboard buffer (returns NOKEY if no scan code)
char KeyGet();

// flush keyboard buffer
void KeyFlush();

// return key to keyboard buffer (can hold only 1 key)
void KeyRet(char key);

#ifdef __cplusplus
}
#endif

#endif // _PICOPAD_KEY_H
