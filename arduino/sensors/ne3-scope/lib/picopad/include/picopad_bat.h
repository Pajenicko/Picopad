
// ****************************************************************************
//
//                              PicoPad Battery
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

#ifndef _PICOPAD_BAT_H
#define _PICOPAD_BAT_H

#ifdef __cplusplus
extern "C" {
#endif

// battery input pin

// Using divider 1:1
//#define BAT_PIN		28		// input from battery
//#define BAT_ADC		ADC_MUX_GPIO28	// ADC input
//#define BAT_MUL		2		// voltage multiplier

// Using Pico internal divider 1:2
//#define BAT_PIN		29		// input from battery
//#define BAT_ADC		ADC_MUX_GPIO29	// ADC input
//#define BAT_MUL		3		// voltage multiplier

// init battery measurement
void BatInit();

// get battery voltage in V
float GetBat();

// get battery voltage, integer in mV
int GetBatInt();

// terminate battery measurement
void BatTerm();

// Battery level from 0 .. 12
u8 BatLevel();

#ifdef __cplusplus
}
#endif

#endif // _PICOPAD_BAT_H
