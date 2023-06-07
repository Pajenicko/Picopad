
// ****************************************************************************
//
//                                 DMA controller
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// DMA has 12 channels
// RP2040 datasheet page 88

#if USE_DMA	// use DMA controller (sdk_dma.c, sdk_dma.h)

#ifndef _SDK_DMA_H
#define _SDK_DMA_H

//#include "resource.h"		// Resources
#include "../sdk_addressmap.h"		// Register address offsets
#include "../sdk_dreq.h"
#include "sdk_cpu.h"

#ifdef __cplusplus
extern "C" {
#endif

#define DMA_CHANNELS 12		// number of DMA channels

// Trigger: write nonzero value to reload counter and start transfer
// Read address - auto shifted during transfer, can be read to get next address
// Write address - auto shifted during transfer, can be read to get next address
// Transfer count - can be read to get number of remaining transfers; auto reloaded from last set value on the trigger

// DMA channel register index - alias 0
#define DMA_CH_READ		0	// DMA channel read address
#define DMA_CH_WRITE		1	// DMA channel write address
#define DMA_CH_COUNT		2	// DMA channel transfer count (auto reloaded on trigger)
#define DMA_CH_CTRL_TRIG	3	// DMA channel control and status + trigger

// DMA channel register index - alias 1
#define DMA_CH_AL1_CTRL		4	// DMA channel control and status
#define DMA_CH_AL1_READ		5	// DMA channel read address
#define DMA_CH_AL1_WRITE	6	// DMA channel write address
#define DMA_CH_AL1_COUNT_TRIG	7	// DMA channel transfer count + trigger (auto reloaded on trigger)

// DMA channel register index - alias 2
#define DMA_CH_AL2_CTRL		8	// DMA channel control and status
#define DMA_CH_AL2_COUNT	9	// DMA channel transfer count (auto reloaded on trigger)
#define DMA_CH_AL2_READ		10	// DMA channel read address
#define DMA_CH_AL2_WRITE_TRIG	11	// DMA channel write address + trigger

// DMA channel register index - alias 3
#define DMA_CH_AL3_CTRL		12	// DMA channel control and status
#define DMA_CH_AL3_WRITE	13	// DMA channel write address
#define DMA_CH_AL3_COUNT	14	// DMA channel transfer count (auto reloaded on trigger)
#define DMA_CH_AL3_READ_TRIG	15	// DMA channel read address + trigger

// DMA registers

//#define DMA_BASE		0x50000000	// DMA controller
#define DMA_CHAN(chan)	((volatile u32*)(DMA_BASE+(chan)*0x40)) // DMA channel base address (chan = 0..11)

#define DMA_READ(chan)		(DMA_CHAN(chan)+DMA_CH_READ)	// DMA channel read register
#define DMA_READ_TRIG(chan)	(DMA_CHAN(chan)+DMA_CH_AL3_READ_TRIG) // DMA channel read register + trigger
#define DMA_WRITE(chan)		(DMA_CHAN(chan)+DMA_CH_WRITE)	// DMA channel write register
#define DMA_WRITE_TRIG(chan)	(DMA_CHAN(chan)+DMA_CH_AL2_WRITE_TRIG) // DMA channel write register + trigger
#define DMA_COUNT(chan)		(DMA_CHAN(chan)+DMA_CH_COUNT)	// DMA channel count register
#define DMA_COUNT_TRIG(chan)	(DMA_CHAN(chan)+DMA_CH_AL1_COUNT_TRIG) // DMA channel count register + trigger
#define DMA_CTRL(chan)		(DMA_CHAN(chan)+DMA_CH_AL1_CTRL)	// DMA channel control register
#define DMA_CTRL_TRIG(chan)	(DMA_CHAN(chan)+DMA_CH_CTRL_TRIG) // DMA channel control register + trigger

#define DMA_INTR	((volatile u32*)(DMA_BASE+0x400))	// raw interrupt status (write 1 to bit 0..15 to clear interrupt request)
#define DMA_INTE0	((volatile u32*)(DMA_BASE+0x404))	// interrupt enables for IRQ 0 (1 on bit 0..15 = pass interrupt to IRQ_DMA_0)
#define DMA_INTF0	((volatile u32*)(DMA_BASE+0x408))	// force interrupts for IRQ 0 (1 on bit 0..15 = force interrupt to IRQ_DMA_0, must be cleared)
#define DMA_INTS0	((volatile u32*)(DMA_BASE+0x40c))	// interrupt status for IRQ 0 (1 on bit 0..15 if request is pending on IRQ_DMA_0, write 1 to clear)
#define DMA_INTE1	((volatile u32*)(DMA_BASE+0x414))	// interrupt enables for IRQ 1 (1 on bit 0..15 = pass interrupt to IRQ_DMA_1)
#define DMA_INTF1	((volatile u32*)(DMA_BASE+0x418))	// force interrupts for IRQ 1 (1 on bit 0..15 = force interrupt to IRQ_DMA_1, must be cleared)
#define DMA_INTS1	((volatile u32*)(DMA_BASE+0x41c))	// interrupt status for IRQ 1 (1 on bit 0..15 if request is pending on IRQ_DMA_1, write 1 to clear)
#define DMA_TIMER(inx)	((volatile u32*)(DMA_BASE+0x420+(inx)*4)) // base address of fractional timer 0..3, trigger on rate X/Y*sys_clk, bit 0..15=Y, bit 16..31=X, 0=off
#define DMA_MULTRIG	((volatile u32*)(DMA_BASE+0x430))	// multiply trigger, bits 0..15
#define DMA_SNIFF_CTRL	((volatile u32*)(DMA_BASE+0x434))	// sniffer control
#define DMA_SNIFF_DATA	((volatile u32*)(DMA_BASE+0x438))	// sniffer data (write initial seed value, read result)
#define DMA_FIFO_LEVELS	((volatile u32*)(DMA_BASE+0x440))	// debug levels (bit 0..7 = transfer data FIFO, bit 8..15 = write address FIFO, bit 16..23 = read address FIFO)
#define DMA_ABORT	((volatile u32*)(DMA_BASE+0x444))	// abort transfer (write 1 to bit 0..15 to abort transfer, read to wait until abort completed)

#define DMA_NEXT(chan)	((volatile u32*)(DMA_BASE+0x804+(chan)*0x40)) // next transfer count of channel 0..11 (auto loaded into count register on trigger)

// DMA transfer size
#define DMA_SIZE_8	0	// 1 byte (8 bits)
#define DMA_SIZE_16	1	// 2 bytes (16 bits)
#define DMA_SIZE_32	2	// 4 bytes (32 bits)

// flags of DMA control and status register CTRL
#define DMA_CTRL_ERROR		B31	// 1 = read or write error, channel halts on error and raises IRQ (read only)
#define DMA_CTRL_READ_ERROR	B30	// 1 = read error (write 1 to clear)
#define DMA_CTRL_WRITE_ERROR	B29	// 1 = write error (write 1 to clear)
#define DMA_CTRL_BUSY		B24	// 1 = DMA transfer is busy, transfer was triggered but not finished yet (read only)
#define DMA_CTRL_SNIFF		B23	// 1 = transfer is visible to sniff CRC hardware, 0 = normal DMA transfer
#define DMA_CTRL_BSWAP		B22	// 1 = swap order of bytes
#define DMA_CTRL_QUIET		B21	// 1 = generate IRQ when NULL is written to a trigger, 0 = generate IRQ at end of every transfer block
#define DMA_CTRL_TREQ(dreq)	((u32)(dreq)<<15) // 0..0x3f select transfer request signal 0..0x3a = DREQ_*, 0x3b..0x3e = Timer0..Timer3, 0x3f = permanent request
#define DMA_CTRL_TREQ_FORCE	DMA_CTRL_TREQ(DREQ_FORCE) // permanent request
#define DMA_CTRL_CHAIN(chan)	((chan)<<11) // trigger channel 0..11 when completed, disable by setting to this channel (=default state)
#define DMA_CTRL_RING_WRITE	B10	//  1 = write addresses are wrapped, 0 = read addresses are wrapped
#define DMA_CTRL_RING_SIZE(order) ((order)<<6) // size 1..15 of address wrap region in bytes '1 << order' (2..32768 bytes), 0 = don't wrap
					//     Ring buffer must be aligned to wrap size (only lowest 'order' bits are changed)
#define DMA_CTRL_INC_WRITE	B5	// 1 = increment write address with each transfer (memory), 0 = do not increment (port)
#define DMA_CTRL_INC_READ	B4	// 1 = increment read address with each transfer (memory), 0 = do not increment (port)
#define DMA_CTRL_SIZE(size)	((size)<<2) // data transfer size DMA_SIZE_* (0=8 bits, 1=16 bits, 2=32 bits)
#define DMA_CTRL_HIGH_PRIORITY	B1	// 1 = channel is preferred during DMA scheduling round, 0 = normal priority
#define DMA_CTRL_EN		B0	// 1 = channel is enabled and responds to trigger, 0 = channel is paused (BUSY will remain unchanged)

// DMA CRC method
#define DMA_CRC_CRC32		0	// CRC-32
#define DMA_CRC_CRC32REV	1	// CRC-32 bit reversed data
#define DMA_CRC_CRC16		2	// CRC-16-CCITT
#define DMA_CRC_CRC16REV	3	// CRC-16-CCITT bit reversed data
#define DMA_CRC_XOR		14	// XOR reduction over all data
#define DMA_CRC_SUM		15	// simple 32-bit sum

#define DMA_CRC_MASK		0x0f	// mask of base CRC method (used internally in DMA_CRC function)
#define DMA_CRC_INV		0x10	// invert result (used only as parameter of DMA_CRC function)
#define DMA_CRC_REV		0x20	// bit-reverse result (used only as parameter of DMA_CRC function)

// flags of DMA sniffer control register
#define DMA_SNIFF_INV		B11	// 1 = inverted result on read (bitwise complement)
#define DMA_SNIFF_REV		B10	// 1 = bit-reverse result on read
#define DMA_SNIFF_BSWAP		B9	// 1 = byte reverse sniffed data (cancel effect if BSWAP of DMA is set)
#define DMA_SNIFF_CRC(crc)	((crc)<<5) // CRC method DMA_CRC_* (0=CRC32, 1=CRC32 reversed, 2=CRC16-CCITT, 3=CCR16_CCITT reversed, 14=XOR, 15=sum)
#define DMA_SNIFF_CHAN(chan)	((chan)<<1) // used DMA channel for sniffer 0..11
#define DMA_SNIFF_EN		B0	// 1 = enable sniffer

// check DMA read or write error
INLINE Bool DMA_IsError(u8 chan) { return (*DMA_CTRL(chan) & DMA_CTRL_ERROR) != 0; }

// check DMA read error
INLINE Bool DMA_IsReadError(u8 chan) { return (*DMA_CTRL(chan) & DMA_CTRL_READ_ERROR) != 0; }

// check DMA write error
INLINE Bool DMA_IsWriteError(u8 chan) { return (*DMA_CTRL(chan) & DMA_CTRL_WRITE_ERROR) != 0; }

// clear DMA error flags
INLINE void DMA_ClearError(u8 chan) { *DMA_CTRL(chan) = *DMA_CTRL(chan); cb(); }

// check if DMA is busy (can stay busy if paused using enable flag)
INLINE Bool DMA_IsBusy(u8 chan) { return (*DMA_CTRL(chan) & DMA_CTRL_BUSY) != 0; }

// start multiply DMA transfers with mask (bit 0..11 = channels set to 1)
INLINE void DMA_StartMask(u32 mask) { *DMA_MULTRIG = mask; }

// start DMA transfer of channel 0..11
INLINE void DMA_Start(u8 chan) { DMA_StartMask(BIT(chan)); }

// get DMA read address
INLINE void* DMA_GetRead(u8 chan) { return (void*)*DMA_READ(chan); }

// set DMA read address, without trigger
INLINE void DMA_SetRead(u8 chan, const volatile void* addr) { *DMA_READ(chan) = (u32)addr; }

// set DMA read address, with trigger
INLINE void DMA_SetReadTrig(u8 chan, const volatile void* addr) { cb(); *DMA_READ_TRIG(chan) = (u32)addr; }

// get DMA write address
INLINE void* DMA_GetWrite(u8 chan) { return (void*)*DMA_WRITE(chan); }

// set DMA write address, without trigger
INLINE void DMA_SetWrite(u8 chan, volatile void* addr) { *DMA_WRITE(chan) = (u32)addr; }

// set DMA write address, with trigger
INLINE void DMA_SetWriteTrig(u8 chan, volatile void* addr) { cb(); *DMA_WRITE_TRIG(chan) = (u32)addr; }

// get DMA transfer count
INLINE int DMA_GetCount(u8 chan) { return (int)*DMA_COUNT(chan); }

// set DMA transfer count, without trigger
INLINE void DMA_SetCount(u8 chan, int count) { *DMA_COUNT(chan) = (u32)count; }

// set DMA transfer count, with trigger
INLINE void DMA_SetCountTrig(u8 chan, int count) { cb(); *DMA_COUNT_TRIG(chan) = (u32)count; }

// get DMA next transfer count (not updated during transfer, auto loaded to COUNT at trigger)
INLINE int DMA_Next(u8 chan) { return (int)*DMA_NEXT(chan); }

// get DMA control register
INLINE u32 DMA_GetCtrl(u8 chan) { return *DMA_CTRL(chan); }

// set DMA control register, without trigger
INLINE void DMA_SetCtrl(u8 chan, u32 ctrl) { *DMA_CTRL(chan) = ctrl; }

// set DMA control register, with trigger
INLINE void DMA_SetCtrlTrig(u8 chan, u32 ctrl) { cb(); *DMA_CTRL_TRIG(chan) = ctrl; }

// set DMA config, without trigger
//  chan = channel 0..11
//  src = source address
//  dst = destination address
//  count = number of transfers
//  ctrl = control word
void DMA_Config(u8 chan, const volatile void* src, volatile void* dst, int count, u32 ctrl);

// set DMA config, with trigger
//  chan = channel 0..11
//  src = source address
//  dst = destination address
//  count = number of transfers
//  ctrl = control word
void DMA_ConfigTrig(u8 chan, const volatile void* src, volatile void* dst, int count, u32 ctrl);

// get DMA base address of alias 0..3 of channel 0..11
INLINE volatile u32* DMA_Alias(u8 chan, u8 alias) { return DMA_CHAN(chan) + alias*4; }

// get DMA sniff control register
INLINE u32 DMA_SniffCtrl() { return *DMA_SNIFF_CTRL; }

// set DMA sniff control register
INLINE void DMA_SetSniffCtrl(u32 ctrl) { *DMA_SNIFF_CTRL = ctrl; }

// get sniff control data
INLINE u32 DMA_SniffData() { return *DMA_SNIFF_DATA; }

// set sniff control data
INLINE void DMA_SetSniffData(u32 data) { *DMA_SNIFF_DATA = data; }

// wait DMA for completion
INLINE void DMA_Wait(u8 chan) { cb(); while (DMA_IsBusy(chan)) {} cb(); }

// abort DMA transfer
// - recommended to disable IRQ before aborting DMA.
INLINE void DMA_Abort(u8 chan)
{
	*DMA_ABORT = BIT(chan); // request to abort transfers
	DMA_Wait(chan); // wait to finish all transfers from FIFO

// This alternative is not safe if IRQ is in "in-flight" state, IRQ may occurs later:
//	while ((*DMA_ABORT & BIT(chan)) != 0) {} // wait to finish all transfers from FIFO
//	cb(); // compiler barrier (when used inline)
}

// disable DMA channel (pause - transfer will be paused but not aborted, busy will stay active)
INLINE void DMA_Disable(u8 chan) { RegClr(DMA_CTRL(chan), DMA_CTRL_EN); }

// enable DMA channel (unpause - continue transfers)
INLINE void DMA_Enable(u8 chan) { RegSet(DMA_CTRL(chan), DMA_CTRL_EN); }

// check if DMA is enabled (not paused)
INLINE Bool DMA_IsEnabled(u8 chan) { return (*DMA_CTRL(chan) & DMA_CTRL_EN) != 0; }

// perform 32-bit DMA transfer from memory to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u32
//   src = pointer to first source u32
//   count = number of u32 elements to transfer
// Transfer speed: 2 us per 1 KB
void DMA_MemCopy32(u8 chan, u32* dst, const u32* src, int count);

// perform 16-bit DMA transfer from memory to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u16
//   src = pointer to first source u16
//   count = number of u16 elements to transfer
// Transfer speed: 4 us per 1 KB
void DMA_MemCopy16(u8 chan, u16* dst, const u16* src, int count);

// perform 8-bit DMA transfer from memory to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u8
//   src = pointer to first source u8
//   count = number of u8 elements to transfer
// Transfer speed: 8 us per 1 KB
void DMA_MemCopy8(u8 chan, u8* dst, const u8* src, int count);

// perform optimised DMA transfer from memory to memory, waiting for completion
//   dst = pointer to destination
//   src = pointer to source
//   num = number of bytes
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 32-bit alilgned 2 us per 1 KB, 16-bit aligned 4 us per 1 KB,
//  unaligned 8 us per 1 KB (software loop 11 us, memcpy 32-bit aligned 7 us, memcpy unaligned 55 us)
void DMA_MemCopy(volatile void* dst, const volatile void* src, int num);

// fill memory with 32-bit sample using 32-bit DMA, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u32 (must be aligned to u32)
//   data = pointer to 32-bit sample to fill (must be aligned to u32)
//   count = number of u32 elements to fill
// Transfer speed: 2 us per 1 KB
void DMA_MemFill32(u8 chan, u32* dst, const volatile u32* data, int count);

// fill memory with 16-bit sample using 16-bit DMA, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u16 (must be aligned to u16)
//   data = pointer to 16-bit sample to fill (must be aligned to u16)
//   count = number of u16 elements to fill
// Transfer speed: 4 us per 1 KB
void DMA_MemFill16(u8 chan, u16* dst, const volatile u16* data, int count);

// fill memory with 8-bit sample using 8-bit DMA, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u8
//   data = pointer to 8-bit sample to fill
//   count = number of u8 elements to fill
// Transfer speed: 8 us per 1 KB
void DMA_MemFill8(u8 chan, u8* dst, const volatile u8* data, int count);

// fill memory with 32-bit double word sample using optimised DMA transfer, waiting for completion
//   dst = pointer to destination
//   data = 32-bit sample to fill
//   num = number of bytes (last sample may be cropped)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 2 us per 1 KB
void DMA_MemFillDW(volatile void* dst, u32 data, int num);

// fill memory with 16-bit word sample using optimised DMA transfer, waiting for completion
//   dst = pointer to destination
//   data = 16-bit sample to fill
//   num = number of bytes (last sample may be cropped)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 2 us per 1 KB
void DMA_MemFillW(volatile void* dst, u16 data, int num);

// fill memory with 8-bit byte sample using optimised DMA transfer, waiting for completion
//   dst = pointer to destination
//   data = 8-bit sample to fill
//   num = number of bytes
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 2 us per 1 KB
void DMA_MemFill(volatile void* dst, u8 data, int num);

// DMA send data from memory to port, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   port = pointer to u32 port
//   src = pointer to first source u32
//   count = number of u32 elements to transfer
//   dreq = data request channel of port DREQ_*
void DMA_ToPort(u8 chan, volatile u32* port, const u32* src, int count, u8 dreq);

// DMA receive data from port to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u32
//   port = pointer to u32 port
//   count = number of u32 elements to transfer
//   dreq = data request channel of port DREQ_*
void DMA_FromPort(u8 chan, u32* dst, const volatile u32* port, int count, u8 dreq);

// enable interrupt from DMA channels for IRQ_DMA_0 masked (set bits 0..11 to enable channel 0..11)
INLINE void DMA_IRQ0EnableMask(u32 mask) { RegSet(DMA_INTE0, mask); }

// enable interrupt from DMA channels for IRQ_DMA_1 masked (set bits 0..11 to enable channel 0..11)
INLINE void DMA_IRQ1EnableMask(u32 mask) { RegSet(DMA_INTE1, mask); }

// enable interrupt from DMA channel for IRQ_DMA_0
INLINE void DMA_IRQ0Enable(u8 chan) { DMA_IRQ0EnableMask(BIT(chan)); }

// enable interrupt from DMA channel for IRQ_DMA_1
INLINE void DMA_IRQ1Enable(u8 chan) { DMA_IRQ1EnableMask(BIT(chan)); }

// disable interrupt from DMA channels for IRQ_DMA_0 masked (set bits 0..11 to enable channel 0..11)
INLINE void DMA_IRQ0DisableMask(u32 mask) { RegClr(DMA_INTE0, mask); }

// disable interrupt from DMA channels for IRQ_DMA_1 masked (set bits 0..11 to enable channel 0..11)
INLINE void DMA_IRQ1DisableMask(u32 mask) { RegClr(DMA_INTE1, mask); }

// disable interrupt from DMA channel for IRQ_DMA_0
INLINE void DMA_IRQ0Disable(u8 chan) { DMA_IRQ0DisableMask(BIT(chan)); }

// disable interrupt from DMA channel for IRQ_DMA_1
INLINE void DMA_IRQ1Disable(u8 chan) { DMA_IRQ1DisableMask(BIT(chan)); }

// check if DMA interrupt request IRQ_DMA_0 is pending
INLINE Bool DMA_IRQ0IsPending(u8 chan) { return (*DMA_INTS0 & BIT(chan)) != 0; }

// check if DMA interrupt request IRQ_DMA_1 is pending
INLINE Bool DMA_IRQ1IsPending(u8 chan) { return (*DMA_INTS1 & BIT(chan)) != 0; }

// clear DMA interrupt request IRQ_DMA_0
INLINE void DMA_IRQ0Clear(u8 chan) { *DMA_INTS0 = BIT(chan); cb(); }

// clear DMA interrupt request IRQ_DMA_1
INLINE void DMA_IRQ1Clear(u8 chan) { *DMA_INTS1 = BIT(chan); cb(); }

// calculate optimised CRC checksum using DMA (wait for completion)
//   mode = CRC mode DMA_CRC_* (can include OR-ed flags DMA_CRC_INV and DMA_CRC_REV)
//   init = init data
//   chan = DMA channel 0..11
//   data = pointer to data
//   num = number of bytes
// Calculation speed: 2 us per 1 KB
u32 DMA_CRC(u8 mode, u32 init, u8 chan, const void* data, int num);

// calculate checksum using DMA, on aligned data (wait for completion)
//   mode = CRC mode DMA_CRC_SUM or other (can include OR-ed flags DMA_CRC_INV and DMA_CRC_REV)
//   init = init data
//   chan = DMA channel 0..11
//   data = pointer to data (must be aligned to the u8/u16/u32 entry)
//   num = number of u8/u16/u32 entries
//   size = size of one entry DMA_SIZE_* (u8/u16/u32)
// Calculation speed: 32-bit 2 us per 1 KB, 16-bit 4 us per 1 KB, 8-bit 8 us per 1 KB
u32 DMA_SUM(u8 mode, u32 init, u8 chan, const void* data, int num, u8 size);

// set DMA fractional timer (trigger on rate X/Y*sys_clk)
//   timer = index of timer 0..3
//   x = numerator (0 = timer is OFF)
//   y = denominator
INLINE void DMA_SetTimer(u8 timer, u16 x, u16 y) { *DMA_TIMER(timer) = ((u32)x << 16) | y; }

#ifdef __cplusplus
}
#endif

#endif // _SDK_DMA_H

#endif // USE_DMA	// use DMA controller (sdk_dma.c, sdk_dma.h)
