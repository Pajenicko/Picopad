
// ****************************************************************************
//
//                                 PIO
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

/* How to use PIO:
- initialize PIO a all SMs with PioInit
- load program with PioLoadProg
- set start address with PioSetAddr if not 0
- setup GPIO pins to use PIO with PioSetupGPIO
- setup state machine parameters with PioSet*
- set pin state and direction with PioSetPin and PioSetPinDir
- setup DMA if needed
- setup IRQ if needed (PioIrqEnable)
- start SM with PioSMEnableMask
- transfer data with PioWriteWait and PioReadWait
*/

#if USE_PIO	// use PIO (sdk_pio.c, sdk_pio.h)

#ifndef _SDK_PIO_H
#define _SDK_PIO_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "../sdk_dreq.h"
#include "sdk_cpu.h"
#include "sdk_gpio.h"

#ifdef __cplusplus
extern "C" {
#endif

#define PIO_NUM			2		// number of PIO controllers
#define PIO_SM_NUM		4		// number of PIO state machines
#define PIO_MEM_NUM		32		// number of PIO instructions in memory
#define PIO_IRQ_NUM		2		// number of PIO interrupt requests
#define PIO_FIFO_NUM		4		// number of PIO single FIFO entries
#define PIO_FIFO2_NUM		8		// number of PIO double FIFO entries

// #define PIO0_BASE		0x50200000	// PIO 0
// #define PIO1_BASE		0x50300000	// PIO 1
#define PIO(pio)		(PIO0_BASE + (pio)*0x100000)	// PIO base (pio = 0 or 1)

#define PIO_CTRL(pio)		((volatile u32*)(PIO(pio)+0x00)) // control register
#define PIO_FSTAT(pio)		((volatile u32*)(PIO(pio)+0x04)) // FIFO status register
#define PIO_FDEBUG(pio)		((volatile u32*)(PIO(pio)+0x08)) // FIFO debug register
#define PIO_FLEVEL(pio)		((volatile u32*)(PIO(pio)+0x0C)) // FIFO level register
#define PIO_TXF(pio, sm)	((volatile u32*)(PIO(pio)+0x10+(sm)*4)) // TX FIFO for this state machine (sm = 0 to 3)
#define PIO_RXF(pio, sm)	((volatile u32*)(PIO(pio)+0x20+(sm)*4)) // RX FIFO for this state machine (sm = 0 to 3)
#define PIO_IRQ(pio)		((volatile u32*)(PIO(pio)+0x30)) // IRQ register
#define PIO_IRQFORCE(pio)	((volatile u32*)(PIO(pio)+0x34)) // IRQ force register
#define PIO_INPUTSYNC(pio)	((volatile u32*)(PIO(pio)+0x38)) // GPIO input synchronizer bypass
#define PIO_DBG_PADOUT(pio)	((volatile u32*)(PIO(pio)+0x3C)) // read pad output
#define PIO_DBG_PADOE(pio)	((volatile u32*)(PIO(pio)+0x40)) // read pad output enables
#define PIO_DBG_CFGINFO(pio)	((volatile u32*)(PIO(pio)+0x44)) // PIO config info
#define PIO_MEM(pio, off)	((volatile u32*)(PIO(pio)+0x48+(off)*4)) // instruction memory (off = 0 to 31)
#define PIO_CLKDIV(pio, sm)	((volatile u32*)(PIO(pio)+0xC8+(sm)*0x18)) // clock divider (sm = 0 to 3)
#define PIO_EXECCTRL(pio, sm)	((volatile u32*)(PIO(pio)+0xCC+(sm)*0x18)) // execution settings (sm = 0 to 3)
#define PIO_SHIFTCTRL(pio, sm)	((volatile u32*)(PIO(pio)+0xD0+(sm)*0x18)) // control shift registers (sm = 0 to 3)
#define PIO_ADDR(pio, sm)	((volatile u32*)(PIO(pio)+0xD4+(sm)*0x18)) // current instruction address (sm = 0 to 3)
#define PIO_INSTR(pio, sm)	((volatile u32*)(PIO(pio)+0xD8+(sm)*0x18)) // current executed instruction (sm = 0 to 3)
#define PIO_PINCTRL(pio, sm)	((volatile u32*)(PIO(pio)+0xDC+(sm)*0x18)) // pin control (sm = 0 to 3)
#define PIO_INTR(pio)		((volatile u32*)(PIO(pio)+0x128)) // raw interrupts
#define PIO_INTE(pio,irq)	((volatile u32*)(PIO(pio)+0x12C+(irq)*12)) // interrupt enable (irq = 0 or 1)
#define PIO_INTF(pio,irq)	((volatile u32*)(PIO(pio)+0x130+(irq)*12)) // interrupt force (irq = 0 or 1)
#define PIO_INTS(pio,irq)	((volatile u32*)(PIO(pio)+0x134+(irq)*12)) // interrupt status (irq = 0 or 1)

#define PIO_NOP		0xA042	// NOP pseudoinstruction = MOV Y,Y  side 0

// PIO instruction base bits
#define PIO_INSTR_JMP	0x0000
#define PIO_INSTR_WAIT	0x2000
#define PIO_INSTR_IN	0x4000
#define PIO_INSTR_OUT	0x6000
#define PIO_INSTR_PUSH	0x8000		// bit 7 is also crucial
#define PIO_INSTR_PULL	0x8080		// bit 7 is also crucial
#define PIO_INSTR_MOV	0xA000
#define PIO_INSTR_IRQ	0xC000
#define PIO_INSTR_SET	0xE000

#define PIO_INSTR_MASK	0xE000		// major instruction mask

// PIO JMP instruction condition
#define PIO_COND_ALWAYS		0	// always (no condition)
#define PIO_COND_NOTX		1	// !X (if scratch X is zero)
#define PIO_COND_XDEC		2	// X-- (if scratch X is non-zero, post-decrement)
#define PIO_COND_NOTY		3	// !Y (if scratch Y is zero)
#define PIO_COND_YDEC		4	// Y-- (if scratch Y is non-zero, post-decrement)
#define PIO_COND_NEQU		5	// X!=Y (if scratch X not equal scratch Y)
#define PIO_COND_PIN		6	// PIN (branch on input pin)
#define PIO_COND_NOSRE		7	// !OSRE (if output shift register is not empty)

// PIO WAIT source
#define PIO_WAIT_GPIO		0	// wait for GPIO pin selected by index (not affected by mapping)
#define PIO_WAIT_PIN		1	// wait for input pin selected by index (affected by mapping)
#define PIO_WAIT_IRQ		2	// wait for IRQ flag selected by index

// PIO instruction source/destination
#define PIO_SRCDST_PINS		0	// PINS
#define PIO_SRCDST_X		1	// X (scratch register X)
#define PIO_SRCDST_Y		2	// Y (scratch register Y)
#define PIO_SRCDST_NULL		3	// NULL (read all zeroes, write discard data)
#define PIO_SRCDST_DIRMOV	4	// write PINDIRS, MOV write EXEC as instruction
#define PIO_SRCDST_STATUSPC	5	// read STATUS, write PC
#define PIO_SRCDST_ISR		6	// ISR
#define PIO_SRCDST_OSROUT	7	// OSR, OUT write EXEC as instruction

// PIO MOV operation
#define PIO_OP_NONE		0	// none
#define PIO_OP_INV		1	// invert (bitwise complement)
#define PIO_OP_REV		2	// bit-reverse

// encode instructions (without delay/sideset)
//  JMP instruction, cond = condition PIO_COND_*, addr = destination address 0 to 31
#define PIO_ENCODE_JMP(cond, addr) (PIO_INSTR_JMP | ((cond)<<5) | ((addr)&0x1f))
//  WAIT instruction, pol = polarity wait for 1 or 0, src = source PIO_WAIT_*, inx = pin or IRQ index
#define PIO_ENCODE_WAIT(pol, src, inx) (PIO_INSTR_WAIT | ((pol)<<7) | ((src)<<5) | (inx))
//  IN instruction, src = source PIO_SRCDST_*, cnt = bit count 1..32
#define PIO_ENCODE_IN(src, cnt) (PIO_INSTR_IN | ((src)<<5) | ((cnt)&0x1f))
//  OUT instruction, dst = destination PIO_SRCDST_*, cnt = bit count 1..32
#define PIO_ENCODE_OUT(dst, cnt) (PIO_INSTR_OUT | ((dst)<<5) | ((cnt)&0x1f))
//  PUSH instruction, iffull = 1 do nothing until threshold, block = 1 stall if RX full
#define PIO_ENCODE_PUSH(iffull, block) (PIO_INSTR_PUSH | ((iffull)<<6) | ((block)<<5))
//  PULL instruction, ifempty = 1 do nothing until threshold, block = 1 stall if TX empty
#define PIO_ENCODE_PULL(ifempty, block) (PIO_INSTR_PULL | ((ifempty)<<6) | ((block)<<5))
//  MOV instruction, dst = destination PIO_SRCDST_*, op = operation PIO_OP_*, src = source PIO_SRCDST_*
#define PIO_ENCODE_MOV(dst, op, src) (PIO_INSTR_MOV | ((dst)<<5) | ((op)<<3) | (src))
//  IRQ instruction, clr = if 1 clear flag selected by inx, wait = if 1 halt, inx = IRQ index
#define PIO_ENCODE_IRQ(clr, wait, inx) (PIO_INSTR_IRQ | ((clr)<<6) | ((wait)<<5) | (inx))
//  SET instruction, dst = destination PIO_SRCDST_*, data = data 5-bit value 0..31
#define PIO_ENCODE_SET(dst, data) (PIO_INSTR_SET | ((dst)<<5) | (data))

// encode side-set of instructions (can be OR-ed with encoded instruction code)
//   bits = bits of sideset 0 to 5 including opt bit (0 = use only wait, 5 = use only sideset)
//   opt = 1 use sideset, or 0 use only wait, or 0 if not using opt bit
//   sideset = output sideset bits, or 0 use only wait
//   wait = wait cycles 0 to 31 or less
#define PIO_ENCODE_SIDESET(bits, opt, sideset, wait) (((opt)<<12) | ((sideset)<<(13-(bits))) | ((wait)<<8))

// PIO interrupt type
#define PIO_INT_RXNEMPTY	0	// RX FIFO is not empty
#define PIO_INT_TXNFULL		1	// TX FIFO is not full
#define PIO_INT_SM		2	// interrupt from state machine

// PIO FIFO joining type
#define PIO_FIFO_JOIN_RXTX	0		// use separate RX FIFO and TX FIFO, every 4-entries deep
#define PIO_FIFO_JOIN_TX	1		// use only TX FIFO, 8-entries deep
#define PIO_FIFO_JOIN_RX	2		// use only RX FIFO, 8-entries deep

// setup GPIO pins to use output from PIO
//  pio ... PIO number 0 or 1
//  pin ... pin base 0 to 29
//  count ... number of pins 0 to 29
INLINE void PioSetupGPIO(u8 pio, u8 pin, u8 count) { GPIO_FncMask(RangeMask(pin, pin+count-1), GPIO_FNC_PIO0 + pio); }

// PIO set state machine clock divider (frequency = sys_clk / clock_divider)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  clkdiv ... clock_divider * 256 (default 0x100, means clock_divider=1.00, 1 instruction per 1 system clock)
INLINE void PioSetClkdiv(u8 pio, u8 sm, u32 clkdiv) { *PIO_CLKDIV(pio, sm) = clkdiv << 8; }

// PIO setup sideset
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  base ... base GPIO pin asserted by sideset output, 0 to 31 (default 0)
//  count ... number of bits used for side set (inclusive enable bit if present), 0 to 5 (default 0)
//  optional ... topmost side set bit is used as enable flag for whether apply side set on that instruction (default False)
//  pindirs ... side set affects pin directions rather than values (default False)
void PioSetupSideset(u8 pio, u8 sm, u8 base, u8 count, Bool optional, Bool pindirs);

// PIO set GPIO pin for JMP PIN instruction
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  pin ... GPIO pin to use as condition for JMP PIN (0 to 29, default 0)
INLINE void PioSetJmpPin(u8 pio, u8 sm, u8 pin) { RegMask(PIO_EXECCTRL(pio, sm), (u32)pin << 24, B24+B25+B26+B27+B28); }

// PIO set special OUT
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  sticky ... enable 'sticky' output (continuously re-asserting most recent OUT/SET values to the pins; default False)
//  has_enable_pin ... use auxiliary OUT enable pin (default False; If True, use a bit of OUT data as an auxiliary
//                 write enable. When used in conjunction with OUT_STICKY, writes with an enable of False
//                 will deassert the latest pin write. This can create useful masking/override behaviour
//                 due to the priority ordering of state nachine pin writes SM0 < SM1 < … )
//  enable_pin_index ... Which data bit to use for auxiliary OUT enable (0..31; default 0)
INLINE void PioSetOutSpecial(u8 pio, u8 sm, Bool sticky, Bool has_enable_pin, u8 enable_pin_index)
{ 	RegMask(PIO_EXECCTRL(pio, sm), (sticky ? B17 : 0) | (has_enable_pin ? B18 : 0) |
		((u32)enable_pin_index << 19), B17 + B18 + B19+B20+B21+B22+B23);
}

// PIO set wrap address
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  wrap_target ... wrap destination, after reaching wrap_top execution is wrapped to this address (0 to 31, default 0)
//  wrap_top ... wrap source, after reaching this address execution is then wrapped to wrap_target (0 to 31, default 31)
// If wrap_top instruction is jump with true condition, the jump takes priority.
INLINE void PioSetWrap(u8 pio, u8 sm, u8 wrap_target, u8 wrap_top)
{
	RegMask(PIO_EXECCTRL(pio, sm), ((u32)(wrap_target & 0x1f) << 7) | 
		((u32)(wrap_top & 0x1f) << 12), (0x1f << 7) | (0x1f << 12));
}

// PIO set "MOV x,STATUS"
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  status_rx ... True compare RX FIFO level, False compare TX FIFO level (default False)
//  level ... comparison level N (default 0)
// Instruction "MOV x,STATUS" fills all-ones if FIFO level < N, otherwise all-zeroes
INLINE void PioSetMovStatus(u8 pio, u8 sm, Bool status_rx, u8 level) { RegMask(PIO_EXECCTRL(pio, sm), (status_rx ? B4 : 0) | (level & 0x0f), 0x1f); }

// PIO set FIFO joining
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  join ... set FIFO joining PIO_FIFO_JOIN_* (default PIO_FIFO_JOIN_RXTX)
INLINE void PioSetFifoJoin(u8 pio, u8 sm, u8 join) { RegMask(PIO_SHIFTCTRL(pio, sm), (u32)join << 30, B30+B31); }

// PIO set OUT shifting
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  shift_right ... shift OSR right (default True)
//  autopull ... autopull enable (pull when OSR is empty, default False)
//  pull_threshold ... threshold in bits to shift out before auto/conditional re-pulling OSR (1 to 32, default 32)
INLINE void PioSetOutShift(u8 pio, u8 sm, Bool shift_right, Bool autopull, u8 pull_threshold)
{
	RegMask(PIO_SHIFTCTRL(pio, sm), (shift_right ? B19 : 0) | (autopull ? B17 : 0) |
		((u32)(pull_threshold & 0x1f) << 25), B17+B19+B25+B26+B27+B28+B29);
}

// PIO set IN shifting
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  shift_right ... shift ISR right (data enters from left, default True)
//  autopush ... autopush enable (push when ISR is filled, default False)
//  push_threshold ... threshold in bits to shift in before auto/conditional re-pushing ISR (1 to 32, default 32)
INLINE void PioSetInShift(u8 pio, u8 sm, Bool shift_right, Bool autopush, u8 push_threshold)
{
	RegMask(PIO_SHIFTCTRL(pio, sm), (shift_right ? B18 : 0) | (autopush ? B16 : 0) |
		((u32)(push_threshold & 0x1f) << 20), B16+B18+B20+B21+B22+B23+B24);
}

// PIO setup SET pins
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  base ... base GPIO pin asserted by SET instruction, 0 to 31 (default 0)
//  count ... number of GPIO pins asserted by SET instruction, 0 to 5 (default 5)
INLINE void PioSetupSet(u8 pio, u8 sm, u8 base, u8 count)
{
	RegMask(PIO_PINCTRL(pio, sm), ((u32)base << 5) | ((u32)count << 26), B5+B6+B7+B8+B9 + B26+B27+B28);
}

// PIO setup OUT pins
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  base ... base GPIO pin asserted by OUT instruction, 0 to 31 (default 0)
//  count ... number of GPIO pins asserted by OUT instruction, 1 to 32 (default 32)
INLINE void PioSetupOut(u8 pio, u8 sm, u8 base, u8 count)
{
	RegMask(PIO_PINCTRL(pio, sm), base | ((u32)(count & 0x1f) << 20), B0+B1+B2+B3+B4 + B20+B21+B22+B23+B24+B25);
}

// PIO setup IN pins
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  base ... base GPIO pin asserted by IN instruction, 0 to 31 (default 0)
INLINE void PioSetupIn(u8 pio, u8 sm, u8 base)
{
	RegMask(PIO_PINCTRL(pio, sm), (u32)base << 15, B15+B16+B17+B18+B19);
}

// get DREQ to use for pacing transfers to state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  tx ... True for sending data from CPU to state machine, False for receiving data from state machine to CPU
INLINE u8 PioGetDreq(u8 pio, u8 sm, Bool tx)
{
	return DREQ_PIO0_TX0 + pio*(DREQ_PIO1_TX0 - DREQ_PIO0_TX0) + sm + (tx ? 0 : PIO_SM_NUM);
}

// PIO set default setup of state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
void PioSMDefault(u8 pio, u8 sm);

// enable PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE void PioSMEnable(u8 pio, u8 sm) { RegSet(PIO_CTRL(pio), 1 << sm); }

// disable PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE void PioSMDisable(u8 pio, u8 sm) { RegClr(PIO_CTRL(pio), 1 << sm); }

// enable multiple PIO state machines
//  pio ... PIO number 0 or 1
//  sm_mask ... state machines mask of bit B0 to B3
// To use mask in range (first..last), use function RangeMask.
INLINE void PioSMEnableMask(u8 pio, u8 sm_mask) { RegSet(PIO_CTRL(pio), sm_mask); }

// enable multiple PIO state machines synchronized (resets their clock dividers)
//  pio ... PIO number 0 or 1
//  sm_mask ... state machines mask of bit B0 to B3
// To use mask in range (first..last), use function RangeMask.
INLINE void PioSMEnableMaskSync(u8 pio, u8 sm_mask) { RegSet(PIO_CTRL(pio), sm_mask | ((u32)sm_mask << 8)); }

// disable multiple PIO state machines
//  pio ... PIO number 0 or 1
//  sm_mask ... state machines mask of bits B0 to B3
// To use mask in range (first..last), use function RangeMask.
INLINE void PioSMDisableMask(u8 pio, u8 sm_mask) { RegClr(PIO_CTRL(pio), sm_mask); }

// restart PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
// This method clears ISR, shift counters, clock divider counter,
// pin write flags, delay counter, latched EXEC instruction, IRQ wait condition
INLINE void PioSMRestart(u8 pio, u8 sm) { RegSet(PIO_CTRL(pio), 1 << (sm+4)); }

// restart multiple PIO state machines
//  pio ... PIO number 0 or 1
//  sm_mask ... state machines mask of bits B0 to B3
// This method clears ISR, shift counters, clock divider counter,
// pin write flags, delay counter, latched EXEC instruction, IRQ wait condition
INLINE void PioSMRestartMask(u8 pio, u8 sm_mask) { RegSet(PIO_CTRL(pio), (u32)sm_mask << 4); }

// restart clock divider of PIO state machine (resets fractional counter)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE void PioClkdivRestart(u8 pio, u8 sm) { RegSet(PIO_CTRL(pio), 1 << (sm+8)); }

// restart clock divider of multiple PIO state machines (resets fractional counter)
//  pio ... PIO number 0 or 1
//  sm_mask ... state machines mask of bits B0 to B3
INLINE void PioClkdivRestartMask(u8 pio, u8 sm_mask) { RegSet(PIO_CTRL(pio), (u32)sm_mask << 8); }

// get current program counter of PIO state machine (returns 0..31)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE u8 PioGetPC(u8 pio, u8 sm) { return (u8)(*PIO_ADDR(pio, sm) & 0x1f); }

// PIO execute one instruction and then resume execution of main program
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  instr ... instruction
INLINE void PioExec(u8 pio, u8 sm, u16 instr) { *PIO_INSTR(pio, sm) = instr; }

// check if instruction set by PioExec is still running
INLINE Bool PioIsExec(u8 pio, u8 sm) { return (*PIO_EXECCTRL(pio, sm) & B31) != 0; }

// PIO execute one instruction, wait to complete and then resume execution of main program
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  instr ... instruction
// State machine must be enabled with valid clock divider.
void PioExecWait(u8 pio, u8 sm, u16 instr);

// write data to TX FIFO of PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  data ... data value
// If TX FIFO is full, the most recent value will be overwritten.
INLINE void PioWrite(u8 pio, u8 sm, u32 data) { *PIO_TXF(pio, sm) = data; }

// read data from RX FIFO of PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
// If RX FIFO is empty, the return value is zero.
INLINE u32 PioRead(u8 pio, u8 sm) { return *PIO_RXF(pio, sm); }

// check if RX FIFO of PIO state machine is full
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE Bool PioRxIsFull(u8 pio, u8 sm) { return (*PIO_FSTAT(pio) & (1 << sm)) != 0; }

// check if RX FIFO of PIO state machine is empty
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE Bool PioRxIsEmpty(u8 pio, u8 sm) { return (*PIO_FSTAT(pio) & (1 << (sm + 8))) != 0; }

// get number of elements in RX FIFO of PIO state machine
INLINE u8 PioRxLevel(u8 pio, u8 sm) { return (*PIO_FLEVEL(pio) >> (sm*8 + 4)) & 0x0f; }

// check if TX FIFO of PIO state machine is full
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE Bool PioTxIsFull(u8 pio, u8 sm) { return (*PIO_FSTAT(pio) & (1 << (sm + 16))) != 0; }

// check if TX FIFO of PIO state machine is empty
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE Bool PioTxIsEmpty(u8 pio, u8 sm) { return (*PIO_FSTAT(pio) & (1 << (sm + 24))) != 0; }

// get number of elements in TX FIFO of PIO state machine
INLINE u8 PioTxLevel(u8 pio, u8 sm) { return (*PIO_FLEVEL(pio) >> (sm*8)) & 0x0f; }

// write data to TX FIFO of PIO state machine, wait if TX FIFO is full
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  data ... data value
void PioWriteWait(u8 pio, u8 sm, u32 data);

// read data from RX FIFO of PIO state machine, wait if RX FIFO is empty
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
u32 PioReadWait(u8 pio, u8 sm);

// clear TX and RX FIFOs of PIO state machine
void PioFifoClear(u8 pio, u8 sm);

// clear RX FIFO (read values)
void PioRxFifoClear(u8 pio, u8 sm);

// clear TX FIFO (executes OUT/PULL instruction; state machine should not be enabled)
void PioTxFifoClear(u8 pio, u8 sm);

// Load program into PIO memory
//  pio ... PIO number 0 or 1
//  program ... array of program instructions
//  len ... length of program in number of instrucions
//  off ... offset in PIO memory (program is wrapped to 32 instructions)
// Jump instructions are auto-reallocated to new offset address (program is always compiled from offset 0).
void PioLoadProg(u8 pio, const u16* program, int len, int off);

// fill PIO program by NOP instructions (= instruction MOV Y,Y)
//  pio ... PIO number 0 or 1
//  len ... length of program, number of instrucions
//  off ... offset in PIO memory (program is wrapped to 32 instructions)
void PioNopProg(u8 pio, int len, int off);

// clear PIO program by "JMP 0" instructions (= default reset value 0x0000)
//  pio ... PIO number 0 or 1
//  len ... length of program, number of instrucions
//  off ... offset in PIO memory (program is wrapped to 32 instructions)
void PioClearProg(u8 pio, int len, int off);

// set output value of pin controlled by the PIO (after initialization with PioSetupGPIO, but before running state machine)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  pin ... first pin index 0..29
//  count ... number of pins 1..30
//  val ... pin output value 0 or 1
// This is done by executing SET instruction on "victim" state machine (state machine should not be enabled).
void PioSetPin(u8 pio, u8 sm, u8 pin, u8 count, u8 val);

// set direction of pin controlled by the PIO (after initialization with PioSetupGPIO, but before running state machine)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  pin ... first pin index 0..29
//  count ... number of pins 1..30
//  dir ... pin direction, 1=output, 0=input
// This is done by executing SET instruction on "victim" state machine (state machine should not be enabled).
void PioSetPinDir(u8 pio, u8 sm, u8 pin, u8 count, u8 dir);

// set current program address of PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  addr ... program address 0 to 31
// This is done by executing JMP instruction on "victim" state machine (state machine should not be enabled).
void PioSetAddr(u8 pio, u8 sm, u8 addr);

// reset debug flags of PIO state machine
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
INLINE void PioDebugClear(u8 pio, u8 sm) { *PIO_FDEBUG(pio) = (B24+B16+B8+B0) << sm; }

// clear IRQ request
//  pio ... PIO number 0 or 1
//  irq ... IRQ index 0 to 7
INLINE void PioIrqClear(u8 pio, u8 irq) { *PIO_IRQ(pio) = 1 << irq; }

// clear IRQ requests by mask
//  pio ... PIO number 0 or 1
//  irq_mask ... IRQ bits B0 to B7
INLINE void PioIrqClearMask(u8 pio, u8 irq_mask) { *PIO_IRQ(pio) = irq_mask; }

// force IRQ request
//  pio ... PIO number 0 or 1
//  irq ... IRQ index 0 to 7
INLINE void PioIrqForce(u8 pio, u8 irq) { *PIO_IRQFORCE(pio) = 1 << irq; }

// force IRQ requests by mask
//  pio ... PIO number 0 or 1
//  irq_mask ... IRQ bits B0 to B7
INLINE void PioIrqForceMask(u8 pio, u8 irq_mask) { *PIO_IRQFORCE(pio) = irq_mask; }

// switch GPIO synchronizer OFF, synchronizer will be bypassed (used for high speed inputs)
//  pio ... PIO number 0 or 1
//  pin ... GPIO pin 0 to 31
INLINE void PioInBypass(u8 pio, u8 pin) { RegSet(PIO_INPUTSYNC(pio), 1<<pin); }

// switch GPIO synchronizer OFF by mask, synchronizer will be bypassed (used for high speed inputs)
//  pio ... PIO number 0 or 1
//  pin_mask ... GPIO pin mask of bits B0 to B31
INLINE void PioInBypassMask(u8 pio, u32 pin_mask) { RegSet(PIO_INPUTSYNC(pio), pin_mask); }

// switch GPIO synchronizer ON, input will be synchronized (default state)
//  pio ... PIO number 0 or 1
//  pin ... GPIO pin 0 to 31
INLINE void PioInSync(u8 pio, u8 pin) { RegClr(PIO_INPUTSYNC(pio), 1<<pin); }

// switch GPIO synchronizer ON by mask, input will be synchronized (default state)
//  pio ... PIO number 0 or 1
//  pin_mask ... GPIO pin mask of bits B0 to B31
INLINE void PioInSyncMask(u8 pio, u32 pin_mask) { RegClr(PIO_INPUTSYNC(pio), pin_mask); }

// read current values currently driving from PIO to GPIOs outputs
INLINE u32 PioGetPadOut(u8 pio) { return *PIO_DBG_PADOUT(pio); }

// read current values currently driving from PIO to GPIOs output enables (direction)
INLINE u32 PioGetPadOE(u8 pio) { return *PIO_DBG_PADOE(pio); }

// get size of instruction memory in number of instructions (typically 32)
INLINE u8 PioMemSize(u8 pio) { return (u8)((*PIO_DBG_CFGINFO(pio) >> 16) & 0x3f); }

// get number of state machines of one PIO (typically 4)
INLINE u8 PioSMCount(u8 pio) { return (u8)((*PIO_DBG_CFGINFO(pio) >> 8) & 0x0f); }

// get depth of one FIFO in number of words (typically 4)
INLINE u8 PioFifoDepth(u8 pio) { return (u8)(*PIO_DBG_CFGINFO(pio) & 0x3f); }

// get raw unmasked interrupt state (returns 1 if raw interrupt is set)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  type ... interrupt type PIO_INT_*
INLINE u8 PioIntRaw(u8 pio, u8 sm, u8 type) { return (u8)((*PIO_INTR(pio) >> (type*4 + sm)) & 1); }

// enable PIO interrupt
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  irq ... IRQ 0 or 1
//  type ... interrupt type PIO_INT_*
INLINE void PioIntEnable(u8 pio, u8 sm, u8 irq, u8 type) { RegSet(PIO_INTE(pio, irq), 1 << (type*4 + sm)); }

// disable PIO interrupt (default state)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  irq ... IRQ 0 or 1
//  type ... interrupt type PIO_INT_*
INLINE void PioIntDisable(u8 pio, u8 sm, u8 irq, u8 type) { RegClr(PIO_INTE(pio, irq), 1 << (type*4 + sm)); }

// force PIO interrupt
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  irq ... IRQ 0 or 1
//  type ... interrupt type PIO_INT_*
INLINE void PioIntForce(u8 pio, u8 sm, u8 irq, u8 type) { RegSet(PIO_INTF(pio, irq), 1 << (type*4 + sm)); }

// unforce PIO interrupt (default state)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  irq ... IRQ 0 or 1
//  type ... interrupt type PIO_INT_*
INLINE void PioIntUnforce(u8 pio, u8 sm, u8 irq, u8 type) { RegClr(PIO_INTF(pio, irq), 1 << (type*4 + sm)); }

// get interrupt state (returns 1 if interrupt is set)
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  irq ... IRQ 0 or 1
//  type ... interrupt type PIO_INT_*
INLINE u8 PioIntStatus(u8 pio, u8 sm, u8 irq, u8 type) { return (u8)((*PIO_INTS(pio, irq) >> (type*4 + sm)) & 1); }

// initialize PIO state machine, prepare default state
//  pio ... PIO number 0 or 1
//  sm ... state machine 0 to 3
//  addr ... program start address 0 to 31
void PioSMInit(u8 pio, u8 sm);

// initialize PIO with all state machines
//  pio ... PIO number 0 or 1
void PioInit(u8 pio);

#ifdef __cplusplus
}
#endif

#endif // _SDK_PIO_H

#endif // USE_PIO	// use PIO (sdk_pio.c, sdk_pio.h)
