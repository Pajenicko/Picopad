
// ****************************************************************************
//
//                              PicoPad LEDs
//
// ****************************************************************************

#ifndef _PICOPAD_LED_H
#define _PICOPAD_LED_H

#ifdef __cplusplus
extern "C" {
#endif

// LED GPIOs
#define LED1_PIN	22	// LED1 inverted, blue, on right
#define LED2_PIN 	25	// default internal LED pin, on Pico board

// LED indices
#define LED1		0	// LED1 index (blue, on right)
#define LED2		1	// LED internal index (green, on Pico board)

#define LED_NUM		2	// number of LEDs

// GPIO with LED
extern const u8 LedGpioTab[LED_NUM];

// GPIO invert flag
extern const Bool LedGpioTabInv[LED_NUM];

// set LED ON (inx = LED index LED?_INX)
void LedOn(u8 inx);

// set LED OFF (inx = LED index LED?_INX)
void LedOff(u8 inx);

// flip LED (inx = LED index LED?_INX)
void LedFlip(u8 inx);

// set LED (inx = LED index LED?)
void LedSet(u8 inx, u8 val);

// initialize LEDs
void LedInit();

// terminate LEDs
void LedTerm();

#ifdef __cplusplus
}
#endif

#endif // _PICOPAD_LED_H
