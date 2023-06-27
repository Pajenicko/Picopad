
// ****************************************************************************
//
//                              PicoPad Battery
//
// ****************************************************************************

#include "../../global.h"	// globals
#include "../../_sdk/inc/sdk_adc.h"
#include "../../_sdk/inc/sdk_gpio.h"
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
	// workaroud for battery measurement on Pico W
	GPIO_Init(LED_PIN); 
	GPIO_PullDown(LED_PIN);
	GPIO_DirOut(LED_PIN); 
	GPIO_Out(LED_PIN, 1); 

	// switch to battery input
	ADC_Mux(BAT_ADC);

	// get battery voltage
	float voltage = ADC_SingleU()*BAT_MUL+BAT_DIODE_FV;
	GPIO_Reset(LED_PIN); 
	return voltage;
}

// get battery voltage, integer in mV
int GetBatInt()
{
	// workaroud for battery measurement on Pico W
	GPIO_Init(LED_PIN); 
	GPIO_PullDown(LED_PIN);
	GPIO_DirOut(LED_PIN); 
	GPIO_Out(LED_PIN, 1); 

	// switch to battery input
	ADC_Mux(BAT_ADC);
	// get battery voltage
	int voltage = ADC_SingleUint()*BAT_MUL+BAT_DIODE_FV_INT;

	GPIO_Reset(LED_PIN); 
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
