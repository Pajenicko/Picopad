
// ****************************************************************************
//
//                                GPIO pins
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals
#include "../inc/sdk_gpio.h"
#include "../inc/sdk_cpu.h"

// set GPIO function GPIO_FNC_*, reset overrides to normal mode, reset pad setup (pin = 0..29)
void GPIO_Fnc(u8 pin, u8 fnc)
{
	*GPIO_PAD(pin) = B1|B2|B4|B6; // reset pad setup
	*GPIO_CTRL(pin) = fnc; // set function, reset all overrides
}

// set GPIO function GPIO_FNC_* with mask (bit '1' to set function of this pin)
// To use pin mask in range (first..last), use function RangeMask.
void GPIO_FncMask(u32 mask, u8 fnc)
{
	int i;
	for (i = 0; i < GPIO_PIN_NUM; i++)
	{
		if ((mask & 1) != 0) GPIO_Fnc((u8)i, fnc);
		mask >>= 1;
	}
}

// acknowledge IRQ interrupt for both CPU
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to acknowledge
void GPIO_IRQAck(u8 pin, u8 events)
{
	volatile u32* reg = &GPIO_IRQ_INTR[pin >> 3];
	u32 mask = (u32)events << (4*(pin & 7));
	*reg = mask;
}

// enable IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to enable

// After enabling interrupt from pin, following steps are necessary:
//   - set handler of IRQ_IO_BANK0 (use function SetHandler), or use isr_io_bank0 handler
//   - not necessary, but rather clear pending interrupt of IRQ_IO_BANK0 (use function NVIC_IRQClear)
//   - enable NVIC interrupt of IRQ_IO_BANK0 (use function NVIC_IRQEnable)
//   - enable global interrupt ei()

void GPIO_IRQEnableCpu(u8 cpu, u8 pin, u8 events)
{
	volatile u32* reg = &GPIO_IRQ_INTE(cpu)[pin >> 3];
	u32 mask = (u32)events << (4*(pin & 7));
	RegSet(reg, mask);
}

// disable IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to disable
void GPIO_IRQDisableCpu(u8 cpu, u8 pin, u8 events)
{
	volatile u32* reg = &GPIO_IRQ_INTE(cpu)[pin >> 3];
	u32 mask = (u32)events << (4*(pin & 7));
	RegClr(reg, mask);
}

// force IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to force
void GPIO_IRQForceCpu(u8 cpu, u8 pin, u8 events)
{
	volatile u32* reg = &GPIO_IRQ_INTF(cpu)[pin >> 3];
	u32 mask = (u32)events << (4*(pin & 7));
	RegSet(reg, mask);
}

// clear force IRQ interrupt for selected/current CPU
//   cpu = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   events = bit mask with IRQ_EVENT_* of events to unforce
void GPIO_IRQUnforceCpu(u8 cpu, u8 pin, u8 events)
{
	volatile u32* reg = &GPIO_IRQ_INTF(cpu)[pin >> 3];
	u32 mask = (u32)events << (4*(pin & 7));
	RegClr(reg, mask);
}

// check IRQ interrupt status for selected/current CPU (returns 1 if IRQ is pending)
//   core = CPU core 0 or 1, use CpuID() to get current core
//   pin = 0..29
//   returns events = bit mask with IRQ_EVENT_* of incoming events
u8 GPIO_IRQIsPendingCpu(u8 cpu, u8 pin)
{
	volatile u32* reg = &GPIO_IRQ_INTS(cpu)[pin >> 3];
	return (u8)((*reg >> (4*(pin & 7))) & IRQ_EVENT_ALL);
}

// initialize GPIO pin base function, reset pad setup, set input mode, LOW output value (pin = 0..29)
void GPIO_Init(u8 pin)
{
	GPIO_DirIn(pin);	// disable output
	GPIO_Out0(pin);		// set output to LOW
	GPIO_Fnc(pin, GPIO_FNC_SIO); // set function, reset overrides, reset pad setup
}

// initialize GPIO pin base function masked (bit '1' to initialize this pin)
// To use pin mask in range (first..last), use function RangeMask.
void GPIO_InitMask(u32 mask)
{
	GPIO_DirInMask(mask);		// disable output
	GPIO_ClrMask(mask);		// set output to LOW
	GPIO_FncMask(mask, GPIO_FNC_SIO); // set function, reset overrides, reset pad setup
}

// reset GPIO pin (return to reset state)
void GPIO_Reset(u8 pin)
{
	GPIO_IRQDisableCpu(0, pin, IRQ_EVENT_ALL); // disable IRQ
	GPIO_IRQDisableCpu(1, pin, IRQ_EVENT_ALL);
	GPIO_IRQUnforceCpu(0, pin, IRQ_EVENT_ALL); // clear force IRQ
	GPIO_IRQUnforceCpu(1, pin, IRQ_EVENT_ALL);
	GPIO_IRQAck(pin, IRQ_EVENT_ALL); // acknowledge IRQ
	GPIO_DirIn(pin); // disable output
	GPIO_Out0(pin); // set output to 0
	GPIO_Fnc(pin, GPIO_FNC_NULL); // reset function, reset overrides, reset pad setup
}

// reset GPIO pins masked (return to reset state)
// To use pin mask in range (first..last), use function RangeMask.
void GPIO_ResetMask(u32 mask)
{
	int i;
	for (i = 0; i < GPIO_PIN_NUM; i++) GPIO_Reset((u8)i);
}
