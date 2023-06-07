
// ****************************************************************************
//
//                                 PIO
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_PIO	// use PIO (sdk_pio.c, sdk_pio.h)

#include "../inc/sdk_pio.h"

// PIO setup sideset
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  base ... base GPIO pin asserted by sideset output, 0 to 31 (default 0)
//  count ... number of bits used for side set (inclusive enable bit if present), 0 to 5 (default 0)
//  optional ... topmost side set bit is used as enable flag for whether apply side set on that instruction (default False)
//  pindirs ... side set affects pin directions rather than values (default False)
void PioSetupSideset(u8 pio, u8 sm, u8 base, u8 count, Bool optional, Bool pindirs)
{
	RegMask(PIO_PINCTRL(pio, sm), ((u32)count << 29) | ((u32)base << 10), B29+B30+B31 + B10+B11+B12+B13+B14);
	RegMask(PIO_EXECCTRL(pio, sm), (optional ? B30 : 0) | (pindirs ? B29 : 0), B29+B30);
}

// PIO set default setup of state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
void PioSMDefault(u8 pio, u8 sm)
{
	*PIO_CLKDIV(pio, sm) = 0x10000;
	*PIO_EXECCTRL(pio, sm) = 0x1f << 12;
	*PIO_SHIFTCTRL(pio, sm) = B19 + B18;
	*PIO_PINCTRL(pio, sm) = 5 << 26;
}

// PIO execute one instruction, wait to complete and then resume execution of main program
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  instr ... instruction
// State machine must be enabled with valid clock divider.
void PioExecWait(u8 pio, u8 sm, u16 instr)
{
	*PIO_INSTR(pio, sm) = instr;
	while ((*PIO_EXECCTRL(pio, sm) & B31) != 0) {}
}

// write data to TX FIFO of PIO state machine, wait if TX FIFO is full
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  data ... data value
void PioWriteWait(u8 pio, u8 sm, u32 data)
{
	while (PioTxIsFull(pio, sm)) {}
	PioWrite(pio, sm, data);
}

// read data from RX FIFO of PIO state machine, wait if RX FIFO is empty
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
u32 PioReadWait(u8 pio, u8 sm)
{
	while (PioRxIsEmpty(pio, sm)) {}
	return PioRead(pio, sm);
}

// clear TX and RX FIFOs of PIO state machine
void PioFifoClear(u8 pio, u8 sm)
{
	// changing the FIFO join state clears the fifo
	RegXor(PIO_SHIFTCTRL(pio, sm), B30+B31);
	RegXor(PIO_SHIFTCTRL(pio, sm), B30+B31);
}

// clear RX FIFO (read values)
void PioRxFifoClear(u8 pio, u8 sm)
{
	u32 val;
	while (!PioRxIsEmpty(pio, sm)) { val = PioRead(pio, sm); }
}

// clear TX FIFO (executes OUT/PULL instruction; state machine should not be enabled)
void PioTxFifoClear(u8 pio, u8 sm)
{
	// prepare instruction - use "OUT null,32" if autopull, or "PULL" if not
	u32 instr = ((*PIO_SHIFTCTRL(pio, sm) & B17) != 0) ? PIO_ENCODE_OUT(PIO_SRCDST_NULL, 32) : PIO_ENCODE_PULL(0, 0);
	u32 save = *PIO_PINCTRL(pio, sm); // save control register
	*PIO_PINCTRL(pio, sm) = 0; // no side set
	while (!PioTxIsEmpty(pio,sm)) PioExec(pio, sm, instr);
	*PIO_PINCTRL(pio, sm) = save; // restore control register
}

// Load program into PIO memory
//  pio ... PIO number 0 or 1
//  program ... array of program instructions
//  len ... length of program in number of instrucions
//  off ... offset in PIO memory (program is wrapped to 32 instructions)
// Jump instructions are auto-reallocated to new offset address (program is always compiled from offset 0).
void PioLoadProg(u8 pio, const u16* program, int len, int off)
{
	u16 instr;
	int inx = off;
	for (; len > 0; len--)
	{
		// wrap instruction offset
		while (inx < 0) inx += PIO_MEM_NUM;
		while (inx >= PIO_MEM_NUM) inx -= PIO_MEM_NUM;

		// reallocate jump instruction (wrap to 32-addresses)
		instr = *program++;
		if ((instr & PIO_INSTR_MASK) == PIO_INSTR_JMP) // JMP instruction
			instr = (instr & ~0x1F) | ((instr + off) & 0x1F);

		// save instruction into program memory
		*PIO_MEM(pio, inx) = instr;
		inx++;
	}
}

// fill PIO program by NOP instructions (= instruction MOV Y,Y)
//  pio ... PIO number 0 or 1
//  len ... length of program, number of instrucions
//  off ... offset in PIO memory (program is wrapped to 32 instructions)
void PioNopProg(u8 pio, int len, int off)
{
	for (; len > 0; len--)
	{
		// wrap instruction offset
		while (off < 0) off += PIO_MEM_NUM;
		while (off >= PIO_MEM_NUM) off -= PIO_MEM_NUM;

		// save instruction into program memory
		*PIO_MEM(pio, off) = PIO_NOP;
		off++;
	}
}

// clear PIO program by "JMP 0" instructions (= default reset value 0x0000)
//  pio ... PIO number 0 or 1
//  len ... length of program, number of instrucions
//  off ... offset in PIO memory (program is wrapped to 32 instructions)
void PioClearProg(u8 pio, int len, int off)
{
	for (; len > 0; len--)
	{
		// wrap instruction offset
		while (off < 0) off += PIO_MEM_NUM;
		while (off >= PIO_MEM_NUM) off -= PIO_MEM_NUM;

		// save instruction into program memory
		*PIO_MEM(pio, off) = 0x0000;
		off++;
	}
}

// set output value of pin controlled by the PIO (after initialization with PioSetupGPIO, but before running state machine)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  pin ... first pin index 0..29
//  count ... number of pins 1..30
//  val ... pin output value 0 or 1
// This is done by executing SET instruction on "victim" state machine (state machine should not be enabled).
void PioSetPin(u8 pio, u8 sm, u8 pin, u8 count, u8 val)
{
	u32 save = *PIO_PINCTRL(pio, sm); // save control register
	for (; count > 0; count--)
	{
		*PIO_PINCTRL(pio, sm) = (1 << 26) | ((u32)pin << 5); // setup SET instruction pin, no sideset
		PioExec(pio, sm, PIO_INSTR_SET + val); // execute SET instruction
		pin++;
	}
	*PIO_PINCTRL(pio, sm) = save; // restore control register
}

// set direction of pin controlled by the PIO (after initialization with PioSetupGPIO, but before running state machine)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  pin ... first pin index 0..29
//  count ... number of pins 1..30
//  dir ... pin direction, 1=output, 0=input
// This is done by executing SET instruction on "victim" state machine (state machine should not be enabled).
void PioSetPinDir(u8 pio, u8 sm, u8 pin, u8 count, u8 dir)
{
	PioSetPin(pio, sm, pin, count, dir + (4 << 5)); // set to PINDIR destination
}

// set current program address of PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  addr ... program address 0 to 31
// This is done by executing JMP instruction on "victim" state machine (state machine should not be enabled).
void PioSetAddr(u8 pio, u8 sm, u8 addr)
{
	u32 save = *PIO_PINCTRL(pio, sm); // save control register
	*PIO_PINCTRL(pio, sm) = 0; // no side set
	PioExec(pio, sm, PIO_INSTR_JMP + addr); // execute JMP instruction
	*PIO_PINCTRL(pio, sm) = save; // restore control register
}

// initialize PIO state machine, prepare default state
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
void PioSMInit(u8 pio, u8 sm)
{
	// disable PIO state machine
	PioSMDisable(pio, sm);

	// clear TX and RX FIFOs of PIO state machine
	PioFifoClear(pio, sm);

	// restart PIO state machine
	PioSMRestart(pio, sm);

	// restart clock divider of PIO state machine (resets fractional counter)
	PioClkdivRestart(pio, sm);

	// reset debug flags of PIO state machine
	PioDebugClear(pio, sm);

	// PIO set default setup of state machine
	PioSMDefault(pio, sm);

	// reset current program address of PIO state machine to 0
	PioSetAddr(pio, sm, 0);
}

// initialize PIO with all state machines
//  pio ... PIO number 0 or 1
void PioInit(u8 pio)
{
	u8 sm;
	for (sm = 0; sm < PIO_SM_NUM; sm++) PioSMInit(pio, sm); // initialize PIO state machine
	*PIO_IRQFORCE(pio) = 0; // clear IRQ force
	*PIO_IRQ(pio) = 0xff; // clear IRQ requests
	*PIO_INTE(pio, 0) = 0; // disable IRQ 0
	*PIO_INTE(pio, 1) = 0; // disable IRQ 1
	*PIO_INTF(pio, 0) = 0; // reset IRQ 0 force
	*PIO_INTF(pio, 1) = 0; // reset IRQ 1 force
}

#endif // USE_PIO	// use PIO (sdk_pio.c, sdk_pio.h)
