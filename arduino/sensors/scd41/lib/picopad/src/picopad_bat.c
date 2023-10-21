
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

#include "picopad.h"

// init battery measurement
void BatInit()
{
	// ADC init
	ADC_Init();

	// init battery GPIO
	ADC_PinInit(BAT_PIN);
}

// get battery voltage in V
float GetBat()
{
	// workaround for battery measurement on Pico W
	GPIO_Fnc(LED_PIN, GPIO_FNC_SIO);
	GPIO_DirOut(LED_PIN);
	GPIO_Out1(LED_PIN);
	WaitUs(20);

	// switch to battery input
	ADC_Mux(BAT_ADC);

	// get battery voltage
	float voltage = ADC_SingleU()*BAT_MUL+BAT_DIODE_FV;
	GPIO_Out0(LED_PIN);
	return voltage;
}

// get battery voltage, integer in mV
int GetBatInt()
{
	// workaround for battery measurement on Pico W
	GPIO_Fnc(LED_PIN, GPIO_FNC_SIO);
	GPIO_DirOut(LED_PIN);
	GPIO_Out1(LED_PIN);
	WaitUs(20);

	// switch to battery input
	ADC_Mux(BAT_ADC);

	// get battery voltage
	int voltage = ADC_SingleUint()*BAT_MUL+BAT_DIODE_FV_INT;
	GPIO_Out0(LED_PIN);
	return voltage;
}

// terminate battery measurement
void BatTerm()
{
	// terminate battery GPIO
	ADC_PinTerm(BAT_PIN);

	// disable ADC
	ADC_Disable();
}

u8 BatLevel()
{
	float bat = GetBat();
	int i = (bat - BATTERY_EMPTY) / (BATTERY_FULL - BATTERY_EMPTY) * 12;
	if (i < 0) i = 0;
	if (i > 12) i = 12;

	return i;
}
