
// ****************************************************************************
//
//                              PicoPad Battery
//
// ****************************************************************************

#include "../../global.h"	// globals
#include "../../_sdk/inc/sdk_adc.h"
#include "picopad_bat.h"

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
	// switch to battery input
	ADC_Mux(BAT_ADC);

	// get battery voltage
	return ADC_SingleU()*BAT_MUL;
}

// get battery voltage, integer in mV
int GetBatInt()
{
	// switch to battery input
	ADC_Mux(BAT_ADC);

	// get battery voltage
	return ADC_SingleUint()*BAT_MUL;
}

// terminate battery measurement
void BatTerm()
{
	// terminate battery GPIO
	ADC_PinTerm(BAT_PIN);

	// disable ADC
	ADC_Disable();
}
