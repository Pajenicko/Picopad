
// ****************************************************************************
//
//                           QSPI flash pins
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_qspi.h"
#include "../inc/sdk_gpio.h"
#include "../inc/sdk_cpu.h"

// set QSPI function QSPI_FNC_*, reset overrides to normal mode, reset pad setup (pin = QSPI_PIN_*)
void QSPI_Fnc(u8 pin, u8 fnc)
{
	*GPIO_PAD(pin) = B1|B2|B4|B6; // reset pad setup
	*QSPI_CTRL(pin) = fnc; // set function, reset all overrides
}

// set QSPI function QSPI_FNC_* with mask (bit '1' to set function of this pin)
// To use pin mask in range (first..last), use function RangeMask.
void QSPI_FncMask(u32 mask, u8 fnc)
{
	int i;
	for (i = 0; i < QSPI_PIN_NUM; i++)
	{
		if ((mask & 1) != 0) QSPI_Fnc((u8)i, fnc);
		mask >>= 1;
	}
}

// initialize QSPI pin base function, set input mode, LOW output value (pin = QSPI_PIN_*)
void QSPI_Init(u8 pin)
{
	QSPI_DirIn(pin);	// disable output
	QSPI_Out0(pin);		// set output to LOW
	QSPI_Fnc(pin, QSPI_FNC_SIO); // set function, reset overrides, reset pad setup
}

// initialize QSPI pin base function masked (bit '1' to initialize this pin)
// To use pin mask in range (first..last), use function RangeMask.
void QSPI_InitMask(u32 mask)
{
	QSPI_DirInMask(mask);		// disable output
	QSPI_ClrMask(mask);		// set output to LOW
	QSPI_FncMask(mask, QSPI_FNC_SIO); // set function, reset overrides, reset pad setup
}

// reset QSPI pin (return to reset state)
void QSPI_Reset(u8 pin)
{
	QSPI_IRQDisableCpu(0, pin, IRQ_EVENT_ALL); // disable IRQ
	QSPI_IRQDisableCpu(1, pin, IRQ_EVENT_ALL);
	QSPI_IRQUnforceCpu(0, pin, IRQ_EVENT_ALL); // clear force IRQ
	QSPI_IRQUnforceCpu(1, pin, IRQ_EVENT_ALL);
	QSPI_IRQAck(pin, IRQ_EVENT_ALL); // acknowledge IRQ
	QSPI_DirIn(pin); // disable output
	QSPI_Out0(pin); // set output to 0
	QSPI_Fnc(pin, QSPI_FNC_NULL); // reset function, reset overrides, reset pad setup
}

// reset QSPI pins masked (return to reset state)
// To use pin mask in range (first..last), use function RangeMask.
void QSPI_ResetMask(u32 mask)
{
	int i;
	for (i = 0; i < QSPI_PIN_NUM; i++) QSPI_Reset((u8)i);
}
