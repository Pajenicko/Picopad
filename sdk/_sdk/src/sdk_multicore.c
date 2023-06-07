
// ****************************************************************************
//
//                                Multicore
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_MULTICORE	// use Multicore (sdk_multicore.c, sdk_multicore.h)

#include "../inc/sdk_multicore.h"
#include "../inc/sdk_cpu.h"
#include "../inc/sdk_fifo.h"
#include "../inc/sdk_irq.h"
#include "../inc/sdk_bootrom.h"
#include "../inc/sdk_reset.h"

volatile Bool Core1IsRunning = False;	// flag that core 1 is running

// Core 1 stack (located in reserved section stack1)
u32 __attribute__((section(".stack1"))) Core1Stack[CORE1_STACK_SIZE/4];

// Core1 trampoline to jump to Core1Wrapper
static void __attribute__ ((naked)) Core1Trampoline()
{
	//  r0 ... input parameter 1, pointer to user function
	//  pc ... jump to Core1Wrapper
	__asm(" pop {r0, pc}\n");
}

// Core1 wrapper to call user function
void Core1Wrapper(pCore1Fnc entry)
{
	// set all interrupt priorities of NVIC of this CPU core to default value
	NVIC_IRQPrioDef();

	// set flag that core 1 is running
	Core1IsRunning = True;
	dmb(); // data memory barrier

	// call user function
	entry();

	// disable interrupts
	di();

	// core 1 not running
	Core1IsRunning = False;
	dmb(); // data memory barrier

	// jump to bootrom
	pWaitForVector fnc = (pWaitForVector)RomFunc(ROM_FUNC_WAIT_FOR_VECTOR);
	fnc();
}

// reset CPU core 1 (core 1 will send '0' to the FIFO when done)
void Core1Reset()
{
	// reset core 1
	RegSet(PSM_OFF, BIT(POWER_PROC1));

	// wait for core 1 to be in correct reset state
	while ((*PSM_OFF & BIT(POWER_PROC1)) == 0) {}

	// stop resetting core 1
	RegClr(PSM_OFF, BIT(POWER_PROC1));

	// core 1 not running
	Core1IsRunning = False;
	dmb(); // data memory barrier
}

// start core 1 function (must be called from core 0)
//  entry ... entry into Core1 function (function can exit to stop core 1)
// Core1IsRunning ... flag that core 1 is running
// Both cores use the same VTOR interrupt table (handlers are shared) but have separate NVIC interrupt controllers.
void Core1Exec(pCore1Fnc entry)
{
	// core 1 reset
	Core1Reset();

	// temporary disable interrupt from SIO_IRQ_PROC0
	Bool en = NVIC_IRQIsEnabled(IRQ_SIO_PROC0);
	NVIC_IRQDisable(IRQ_SIO_PROC0);

	// save and lock interrupts
	IRQ_LOCK;

	// prepare stack pointer to reset core 1
	u32* sp = &Core1Stack[CORE1_STACK_SIZE/4-2]; // last entry in the stack
	sp[0] = (u32)entry;	// parameter 1 - address of user function
	sp[1] = (u32)Core1Wrapper; // jump to Core1Wrapper

	// prepare data frame to launch core 1 from bootrom_rt0.S
	u32 frame[] = {
		0,		// synchronization
		0,		// synchronization
		1,		// command to start data sequence
		(u32)GetVTOR(),	// address of vector table (shared with core 0)
		(u32)sp,	// stack pointer
		(u32)Core1Trampoline};	// execute trampoline function

	// send data frame
	int i = 0;
	do {
		// flush read FIFO on synchronization
		if (i < 2)
		{
			// flush all read messages
			FifoReadFlush();

			// send event - core 1 may be waiting for FIFO via wfe()
			sev();
		}

		// get next word to send
		u32 c = frame[i++];

		// send data word
		FifoWrite(c);

		// receive response - it will be 0 if core 1 is just starting handshake
		u32 res = FifoRead();

		// reset on incorrect response (must be echoed value)
		if (res != c) i = 0;

	} while (i < count_of(frame));

	// unlock interrupts
	IRQ_UNLOCK;

	// enable interrupt IRQ_SIO_PROC0
	if (en) NVIC_IRQEnable(IRQ_SIO_PROC0);
}

// Lockout handler (must be in RAM and must not use flash functions - to enable flash writting from other core)
//  Name of alternative handler in Flash: isr_sio_proc0 and isr_sio_proc1
// - remember to keep the state of the divider in the interrupt handler in case division is used in the handler
void NOFLASH(LockoutHandler)()
{
	// save and lock interrupts
	IRQ_LOCK;

	// clear FIFO errors
	*FIFO_STATE = 0xff;

	// while inter-core RX FIFO is ready to read
	while ((*FIFO_STATE & FIFO_VLD) != 0)
	{
		// check start command 
		if (*FIFO_READ == LOCKOUT_MAGIC_START)
		{
			// send response
			while ((*FIFO_STATE & FIFO_RDY) == 0) {}
			*FIFO_WRITE = LOCKOUT_MAGIC_START;
			sev();

			// wait for end of lockout
			do {
				while ((*FIFO_STATE & FIFO_VLD) == 0) wfe();
			} while (*FIFO_READ != LOCKOUT_MAGIC_END);

			// send response
			while ((*FIFO_STATE & FIFO_RDY) == 0) {}
			*FIFO_WRITE = LOCKOUT_MAGIC_END;
			sev();
		}
	}

	// unlock interrupts
	IRQ_UNLOCK;
}


// initialize lockout handler for core 0 or 1
void LockoutInit(u8 core)
{
	// prepare IRQ number
	u8 irq = IRQ_SIO_PROC0 + core;

	// set handler
	SetHandler(irq, LockoutHandler);

	// enable IRQ
	NVIC_IRQEnable(irq);
}

// deinitialize lockout handler for core 0 or 1 (disables IRQ handler)
void LockoutTerm(u8 core)
{
	// disable IRQ
	NVIC_IRQDisable(IRQ_SIO_PROC0 + core);
}

// start lockout other core
void LockoutStart()
{
	FifoHandshake(LOCKOUT_MAGIC_START);
}

// stop lockout other core
void LockoutStop()
{
	FifoHandshake(LOCKOUT_MAGIC_END);
}

#endif // USE_MULTICORE	// use Multicore (sdk_multicore.c, sdk_multicore.h)
