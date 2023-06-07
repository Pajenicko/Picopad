
// ****************************************************************************
//
//                                 ADC controller
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

/*
Conversion speed: 500 kS/s (using 48 MHz clock)
Capturing a sample takes 96 clock cycles (91 x 1/48MHz) = 2 us per sample (500 kS/s)
4 inpus on GPIO26 .. GPIO29, 1 input internal temperature sensor
Temperature: T = 27 - (ADC_voltage - 0.706) / 0.001721

Hot to use:
1) initialize ADC with ADC_Init()
2) prepare GPIO inputs with ADC_PinInit()
 ... or if using temperature sensor 2) enable temperature sensor with ADC_TempEnable()
3) select input with ADC_Mux()
4) read conversion with ADC_Single() ... takes 2 us
*/

#if USE_ADC		// use ADC controller (sdk_adc.c, sdk_adc.h)

#ifndef _SDK_ADC_H
#define _SDK_ADC_H

//#include "resource.h"		// Resources
#include "../sdk_addressmap.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// #define ADC_BASE		0x4004c000	// ADC controller
#define ADC_CS		((volatile u32*)(ADC_BASE+0x00)) // control and status
#define ADC_RESULT	((volatile u32*)(ADC_BASE+0x04)) // result
#define ADC_FCS		((volatile u32*)(ADC_BASE+0x08)) // FIFO control and status
#define ADC_FIFO	((volatile u32*)(ADC_BASE+0x0C)) // conversion result FIFO
#define ADC_DIV		((volatile u32*)(ADC_BASE+0x10)) // clock divider
#define ADC_INTR	((volatile u32*)(ADC_BASE+0x14)) // raw interrupt
#define ADC_INTE	((volatile u32*)(ADC_BASE+0x18)) // interrupt enable
#define ADC_INTF	((volatile u32*)(ADC_BASE+0x1C)) // interrupt force
#define ADC_INTS	((volatile u32*)(ADC_BASE+0x20)) // interrupt status

// ADC inputs
#define ADC_MUX_GPIO26	0	// pin GPIO 26
#define ADC_MUX_GPIO27	1	// pin GPIO 27
#define ADC_MUX_GPIO28	2	// pin GPIO 28
#define ADC_MUX_GPIO29	3	// pin GPIO 29
#define ADC_MUX_TEMP	4	// temperature sensor

// ADC init
void ADC_Init();

// ADC disable
INLINE void ADC_Disable() { *ADC_CS = 0; }

// initialize GPIO to use as an ADC pin
void ADC_PinInit(u8 pin);

// terminate pin as ADC input
void ADC_PinTerm(u8 pin);

// select ADC input
//  input ... input 0 to 4 (use ADC_MUX_*)
INLINE void ADC_Mux(u8 input) { RegMask(ADC_CS, (u32)input << 12, 7 << 12); }

// get currently selected ADC input (returns 0 to 4)
INLINE u8 ADC_GetMux() { return (u8)((*ADC_CS >> 12) & 7); }

// set round robin sampling selector
//  mask ... mask of bits B0 to B4 of inputs (use BIT(ADC_MUX_*))
//           set 0 to disable round robin sampling
INLINE void ADC_RoundRobin(u8 mask) { RegMask(ADC_CS, (u32)mask << 16, 0x1f << 16); }

// enable temperature sensor
void ADC_TempEnable();

// disable temperature sensor (saves 40 uA)
INLINE void ADC_TempDisable() { RegClr(ADC_CS, B1); }

// start single conversion
INLINE void ADC_StartOnce() { RegSet(ADC_CS, B2); }

// check if ADC is ready (False if conversion is in progress)
INLINE Bool ADC_Ready() { return (*ADC_CS & B8) != 0; }

// wait for end of conversion
INLINE void ADC_Wait() { while (!ADC_Ready()) {} }

// get last conversion result
INLINE u16 ADC_Result() { return (u16)(*ADC_RESULT & 0xfff); }

// do single conversion (takes 96 clock cycles = 2 us on 48 MHz clock)
u16 ADC_Single();

// do single conversion with denoise (returns value 0..0xffff; takes 32 us on 48 MHz clock)
u16 ADC_SingleDenoise();

// do single conversion and recalculate to voltage on 3.3V
float ADC_SingleU();

// do single conversion and recalculate to voltage on 3.3V, integer in mV (range 0..3300)
int ADC_SingleUint();

// enable continuously repeated conversion
INLINE void ADC_MultiEnable() { RegSet(ADC_CS, B3); }

// disable continuously repeated conversion
INLINE void ADC_MultiDisable() { RegClr(ADC_CS, B3); }

// check if most recent ADC conversion encountered an error; result is undefined or noisy
INLINE Bool ADC_Err() { return (*ADC_CS & B9) != 0; }

// some past ADC conversion encountered an error (clear with ADC_ErrClear())
INLINE Bool ADC_ErrSticky() { return (*ADC_CS & B10) != 0; }

// clear sticky error
INLINE void ADC_ErrClear() { RegSet(ADC_CS, B10); }

// set ADC clock divisor
//  clkdiv ... clock divisor * 256 (if non-zero, ADC_MultiEnable() will start conversions with that interval)
// Interval of samples will be (1 + clkdiv/256) cycles. One conversion takes 96 cycles, so minimal value
// of clkdiv is 96*256 = 0x5F00 (period 2 us, 500 kHz). Maximal value is 0xFFFFFF (period 1365 us, 732 Hz).
INLINE void ADC_ClkDiv(u32 clkdiv) { *ADC_DIV = clkdiv; }

// set ADC sampling frequency of repeated conversions
//  freq ... sampling frequency in Hz, minimal 732 Hz, maximal 500000 Hz, 0 = switch off
void ADC_Freq(u32 freq);

// get current sampling frequency in Hz (732 to 500000 Hz, 0 = off)
u32 ADC_GetFreq();

// setup ADC FIFO (FIFO is 4 samples long)
//  en ... True to enable write each conversion result to the FIFO
//  shift ... True to right-shift result to be one byte 8-bit in size (enables DMA to byte buffers)
//  err ... True means bit 15 of FIFO contains error flag for each sample
//  dreq_en ... enable DMA requests when FIFO contains data
//  dreq_thresh ... threshold for DMA requests/FIFO IRQ if enabled (DREQ/IRQ asserted then level >= threshold)
void ADC_FifoSetup(Bool en, Bool shift, Bool err, Bool dreq_en, u8 dreq_thresh);

// check if ADC FIFO is empty
INLINE Bool ADC_IsEmpty() { return ((*ADC_FCS >> 8) & 1) != 0; }

// check if ADC FIFO is full
INLINE Bool ADC_IsFull() { return ((*ADC_FCS >> 9) & 1) != 0; }

// check if ADC FIFO has been underflow
INLINE Bool ADC_IsUnder() { return ((*ADC_FCS >> 10) & 1) != 0; }

// check if ADC FIFO has been overflow
INLINE Bool ADC_IsOver() { return ((*ADC_FCS >> 11) & 1) != 0; }

// clear flag of ADC FIFO has been underflow
INLINE void ADC_ClearUnder() { RegSet(ADC_FCS, B10); }

// clear flag of ADC FIFO has been overflow
INLINE void ADC_ClearOver() { RegSet(ADC_FCS, B11); }

// get number of samples waiting in FIFO
INLINE u8 ADC_Level() { return (u8)((*ADC_FCS >> 16) & 0x0f); }

// get value from ADC FIFO (bit 15 can contain error flag)
INLINE u16 ADC_Fifo() { return (u16)(*ADC_FIFO & 0x8fff); }

// get value from ADC FIFO and wait to have data (bit 15 can contain error flag)
u16 ADC_FifoWait();

// discard FIFO results
void ADC_FifoFlush();

// get raw interrupt flag (= FIFO reaches threshold level)
INLINE Bool ADC_IntRaw() { return (*ADC_INTR & 1) != 0; }

// enable FIFO interrupt
INLINE void ADC_IntEnable() { RegSet(ADC_INTE, B0); }

// disable FIFO interrupt
INLINE void ADC_IntDisable() { RegClr(ADC_INTE, B0); }

// force FIFO interrupt enable
INLINE void ADC_ForceEnable() { RegSet(ADC_INTF, B0); }

// force FIFO interrupt disable
INLINE void ADC_ForceDisable() { RegClr(ADC_INTF, B0); }

// get masked interrupt flag
INLINE Bool ADC_GetInt() { return (*ADC_INTS & 1) != 0; }

// get current temperature in °C
float ADC_Temp();

#ifdef __cplusplus
}
#endif

#endif // _SDK_ADC_H

#endif // USE_ADC		// use ADC controller (sdk_adc.c, sdk_adc.h)
