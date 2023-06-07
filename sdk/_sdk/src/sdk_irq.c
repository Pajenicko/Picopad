
// ****************************************************************************
//
//                             IRQ interrupt request
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_IRQ	// use IRQ interrupts (sdk_irq.c, sdk_irq.h)

#include "../inc/sdk_irq.h"
#include "../inc/sdk_cpu.h"

// set interrupt priority of NVIC of this CPU core (prio = priority IRQ_PRIO_*) (irq = 0..25)
void NVIC_IRQPrio(u8 irq, u8 prio)
{
	volatile u32* reg = &NVIC_IPR0[irq >> 2]; // register (every register contains 4 entries)
	irq = 8 * (irq & 3); // bit in the register
	u32 val = (u32)prio << irq; // prepare priority
	u32 mask = 0xffUL << irq; // prepare mask
	*reg = (*reg & ~mask) | val;
}

// set all interrupt priorities of NVIC of this CPU core to default value
void NVIC_IRQPrioDef()
{
	// set RP2040 device interrupts
	int i;
	for (i = 0; i < IRQ_NUM; i++) NVIC_IRQPrio((u8)i, IRQ_PRIO_NORMAL);

	// set exception priorities
	NVIC_SVCallPrio(IRQ_PRIO_NORMAL); // SVCall
	NVIC_PendSVPrio(IRQ_PRIO_PENDSV); // PendSV
	NVIC_SysTickPrio(IRQ_PRIO_SYSTICK); // SysTick
}

/*
// system reset (send reset signal)
void SystemReset()
{
	// data synchronization barrier
	dsb();

	// send reset signal (0x05FAUL is register key)
	*SCB_AIRCR = (0x05FAUL << 16) | B2;

	// data synchronization barrier
	dsb();

	// waiting for reset in infinite loop
	for (;;) nop();
}
*/

#endif // USE_IRQ	// use IRQ interrupts (sdk_irq.c, sdk_irq.h)
