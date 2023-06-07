
// ****************************************************************************
//
//                                 ADC controller
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_ADC		// use ADC controller (sdk_adc.c, sdk_adc.h)

#include "../inc/sdk_reset.h"
#include "../inc/sdk_gpio.h"
#include "../inc/sdk_clocks.h"
#include "../inc/sdk_adc.h"
#include "../inc/sdk_timer.h"

// temperature noise reduction
#if TEMP_NOISE > 0
u16 ADCTempHist[TEMP_NOISE];		// deep of temperature history
u32 ADCTempHistSum = 0;			// sum of history
int ADCTempHistNum = 0;			// number of entries
int ADCTempHistInx = 0;			// index in temperature history
#endif // TEMP_NOISE

// ADC init
void ADC_Init()
{
	// reset ADC
	ResetPeripheryOn(BIT(RESET_ADC));
	ResetPeripheryOffWait(BIT(RESET_ADC));

#if TEMP_NOISE > 0
	// clear noise rediction history
	ADCTempHistSum = 0;
	ADCTempHistNum = 0;
	ADCTempHistInx = 0;
#endif

	// enable ADC
	*ADC_CS = B0;

	// wait for power-up sequence
	ADC_Wait();
}

// initialize GPIO to use as an ADC pin
//  pin ... pin 26 to 29
void ADC_PinInit(u8 pin)
{
	// disable all functions to make output driver high impedance
	GPIO_Fnc(pin, GPIO_FNC_NULL);

	// disable pulls
	GPIO_NoPull(pin);

	// disable input
	GPIO_InDisable(pin);
}

// terminate pin as ADC input
void ADC_PinTerm(u8 pin)
{
	GPIO_Reset(pin);
}

// do single conversion (takes 96 clock cycles = 2 us on 48 MHz clock)
u16 ADC_Single()
{
	ADC_StartOnce(); // start single conversion
	ADC_Wait(); // wait for end of conversion
	return ADC_Result(); // get conversion result
}

// do single conversion with denoise (returns value 0..0xffff; takes 32 us on 48 MHz clock
u16 ADC_SingleDenoise()
{
	int i;
	u16 t = 0;
	for (i = 16; i > 0; i--) t += ADC_Single();
	return t;
}

// do single conversion and recalculate to voltage on 3.3V
float ADC_SingleU()
{
	return ADC_SingleDenoise() * 3.3f / (4096*16);
}

// do single conversion and recalculate to voltage on 3.3V, integer in mV (range 0..3300)
int ADC_SingleUint()
{
	return ADC_SingleDenoise() * 3300 / (4096*16);
}

// set ADC sampling frequency of repeated conversions
//  freq ... sampling frequency in Hz, minimal 732 Hz, maximal 500000 Hz, 0 = switch off
void ADC_Freq(u32 freq)
{
	// switch off
	if (freq == 0)
	{
		ADC_ClkDiv(0);
		return;
	}

	// get current frequency of ADC
	u32 freq0 = CurrentFreq[CLK_ADC];

	// clock divisor * 256
	u32 clkdiv = (u32)(((u64)freq0*256 + freq/2) / freq);

	// limit range
	if (clkdiv > 0x10000FF) clkdiv = 0x10000FF;
	if (clkdiv < 0x6000) clkdiv = 0x6000;

	// set clock divisor
	ADC_ClkDiv(clkdiv - 256);
}

// get current sampling frequency in Hz (732 to 500000 Hz, 0 = off)
u32 ADC_GetFreq()
{
	// switch off
	u32 clkdiv = *ADC_DIV & 0xffffff;
	if (clkdiv == 0) return 0;
	clkdiv += 256;

	// get current frequency of ADC
	u32 freq0 = CurrentFreq[CLK_ADC];

	// frequency
	return (u32)(((u64)freq0*256 + clkdiv/2) / clkdiv);
}

// setup ADC FIFO (FIFO is 4 samples long)
//  en ... True to enable write each conversion result to the FIFO
//  shift ... True to right-shift result to be one byte 8-bit in size (enables DMA to byte buffers)
//  err ... True means bit 15 of FIFO contains error flag for each sample
//  dreq_en ... enable DMA requests when FIFO contains data
//  dreq_thresh ... threshold for DMA requests/FIFO IRQ if enabled (DREQ/IRQ asserted then level >= threshold)
void ADC_FifoSetup(Bool en, Bool shift, Bool err, Bool dreq_en, u8 dreq_thresh)
{
	RegMask(ADC_FCS, (en ? B0:0) | (shift ? B1:0) | (err ? B2:0) | (dreq_en ? B3:0)
		| ((u32)dreq_thresh << 24), B0+B1+B2+B3 + B24+B25+B26+B27);
}

// get value from ADC FIFO and wait to have data (bit 15 can contain error flag)
u16 ADC_FifoWait()
{
	while (ADC_IsEmpty()) {}
	return ADC_Fifo();
}

// discard FIFO results
void ADC_FifoFlush()
{
	// wait for end of conversion
	ADC_Wait();

	// flush FIFO
	while (!ADC_IsEmpty()) (void)ADC_Fifo();
}

// enable temperature sensor
void ADC_TempEnable()
{
	// if not enabled, wait some time to stabilize (requires min. 500 us)
	if ((*ADC_CS & B1) == 0)
	{
		RegSet(ADC_CS, B1);
		WaitMs(1);
	}
}

// get current temperature in °C
float ADC_Temp()
{
	int i;

	// enable temperature sensor
	ADC_TempEnable();
	
	// select ADC input
	ADC_Mux(ADC_MUX_TEMP);

	// do single conversion with fast denoise
	u16 t = ADC_SingleDenoise();

	// temperature noise reduction
#if TEMP_NOISE > 0
	ADCTempHistSum += t;
	if (ADCTempHistNum < TEMP_NOISE) // initialize
	{
		ADCTempHistNum++;
		ADCTempHist[ADCTempHistInx] = t;
		t = (ADCTempHistSum + ADCTempHistNum/2) / ADCTempHistNum;
	}
	else
	{
		ADCTempHistSum -= ADCTempHist[ADCTempHistInx];
		ADCTempHist[ADCTempHistInx] = t;
		t = (ADCTempHistSum + TEMP_NOISE/2) / TEMP_NOISE;
	}
	ADCTempHistInx++;
	if (ADCTempHistInx >= TEMP_NOISE) ADCTempHistInx = 0;
#endif // TEMP_NOISE

	// do single conversion (T = 27 - (ADC_voltage - 0.706) / 0.001721)
	return 27 - (t*3.3f/(4096*16) - 0.706f) / 0.001721f;
}

#endif // USE_ADC		// use ADC controller (sdk_adc.c, sdk_adc.h)
