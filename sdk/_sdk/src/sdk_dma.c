
// ****************************************************************************
//
//                                 DMA controller
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_DMA	// use DMA controller (sdk_dma.c, sdk_dma.h)

#include "../inc/sdk_cpu.h"
#include "../inc/sdk_dma.h"

// set DMA config, without trigger
//  chan = channel 0..11
//  src = source address
//  dst = destination address
//  count = number of transfers
//  ctrl = control word
void DMA_Config(u8 chan, const volatile void* src, volatile void* dst, int count, u32 ctrl)
{
	DMA_SetRead(chan, src);
	DMA_SetWrite(chan, dst);
	DMA_SetCount(chan, count);
	DMA_SetCtrl(chan, ctrl);
}

// set DMA config, with trigger
//  chan = channel 0..11
//  src = source address
//  dst = destination address
//  count = number of transfers
//  ctrl = control word
void DMA_ConfigTrig(u8 chan, const volatile void* src, volatile void* dst, int count, u32 ctrl)
{
	DMA_SetRead(chan, src);
	DMA_SetWrite(chan, dst);
	DMA_SetCount(chan, count);
	cb(); // compiler barrier (when used inline)
	DMA_SetCtrlTrig(chan, ctrl);
}

// perform 32-bit DMA transfer from memory to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u32 (must be aligned to u32)
//   src = pointer to first source u32 (must be aligned to u32)
//   count = number of u32 elements to transfer
// Transfer speed: 2 us per 1 KB
void DMA_MemCopy32(u8 chan, u32* dst, const u32* src, int count)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, src); // set source address
	DMA_SetWrite(chan, dst); // set destination address
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_INC_READ |
		DMA_CTRL_SIZE(DMA_SIZE_32) | DMA_CTRL_EN); // set control and trigger transfer
}

// perform 16-bit DMA transfer from memory to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u16 (must be aligned to u16)
//   src = pointer to first source u16 (must be aligned to u16)
//   count = number of u16 elements to transfer
// Transfer speed: 4 us per 1 KB
void DMA_MemCopy16(u8 chan, u16* dst, const u16* src, int count)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, src); // set source address
	DMA_SetWrite(chan, dst); // set destination address
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_INC_READ |
		DMA_CTRL_SIZE(DMA_SIZE_16) | DMA_CTRL_EN); // set control and trigger transfer
}

// perform 8-bit DMA transfer from memory to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u8
//   src = pointer to first source u8
//   count = number of u8 elements to transfer
// Transfer speed: 8 us per 1 KB
void DMA_MemCopy8(u8 chan, u8* dst, const u8* src, int count)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, src); // set source address
	DMA_SetWrite(chan, dst); // set destination address
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_INC_READ |
		DMA_CTRL_SIZE(DMA_SIZE_8) | DMA_CTRL_EN); // set control and trigger transfer
}

// perform optimised DMA transfer from memory to memory, waiting for completion
//   dst = pointer to destination
//   src = pointer to source
//   num = number of bytes
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 32-bit aligned 2 us per 1 KB, 16-bit aligned 4 us per 1 KB,
//  unaligned 8 us per 1 KB (software loop 11 us, memcpy 32-bit aligned 7 us, memcpy unaligned 55 us)
void DMA_MemCopy(volatile void* dst, const volatile void* src, int num)
{
	int num2;
	u8* dst8 = (u8*)dst;
	const u8* src8 = (const u8*)src;
	u8 chan;

	// copy small amount of data
	if (num < 64)
	{
		memcpy(dst8, src8, num);
	}

	// fast copy 32-bit DMA, addresses must be dword aligned
	else if (((u32)dst & 3) == ((u32)src & 3))
	{
		// copy first unaligned bytes ('num' is big enough here)
		while (((u32)dst8 & 3) != 0)
		{
			*dst8++ = *src8++;
			num--;
		}

		chan = DMA_TEMP_CHAN(); // DMA temporary channel

		// copy 32-bit DMA
		num2 = num & 3; // rest in last dword
		num >>= 2; // number of dwords
		DMA_MemCopy32(chan, (u32*)dst8, (const u32*)src8, num);

		// wait DMA for completion
		DMA_Wait(chan);

		// disable DMA channel
		DMA_Disable(chan);

		// copy rest of data
		num <<= 2; // convert dwords back to bytes
		dst8 += num; // shift destination address
		src8 += num; // shift source address
		while (num2 > 0)
		{
			*dst8++ = *src8++;
			num2--;
		}
	}
	
	// copy 16-bit DMA, addresses must be word aligned
	else if (((u32)dst & 1) == ((u32)src & 1))
	{
		// copy first unaligned bytes ('num' is big enough here)
		if (((u32)dst8 & 1) != 0)
		{
			*dst8++ = *src8++;
			num--;
		}

		chan = DMA_TEMP_CHAN(); // DMA temporary channel

		// copy 16-bit DMA
		num2 = num & 1; // rest in last word
		num >>= 1; // number of words
		DMA_MemCopy16(chan, (u16*)dst8, (const u16*)src8, num);

		// wait DMA for completion
		DMA_Wait(chan);

		// disable DMA channel
		DMA_Disable(chan);

		// copy rest of data
		num <<= 1; // convert words back to bytes
		dst8 += num; // shift destination address
		src8 += num; // shift source address
		if (num2 > 0) *dst8++ = *src8++;
	}

	// copy 8-bit DMA
	else
	{
		chan = DMA_TEMP_CHAN(); // DMA temporary channel

		// copy 8-bit DMA
		DMA_MemCopy8(chan, dst8, src8, num);

		// wait DMA for completion
		DMA_Wait(chan);

		// disable DMA channel
		DMA_Disable(chan);
	}
}

// fill memory with 32-bit sample using 32-bit DMA, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u32 (must be aligned to u32)
//   data = pointer to 32-bit sample to fill (must be aligned to u32)
//   count = number of u32 elements to fill
// Transfer speed: 2 us per 1 KB
void DMA_MemFill32(u8 chan, u32* dst, const volatile u32* data, int count)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, data); // set source address
	DMA_SetWrite(chan, dst); // set destination address
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_SIZE(DMA_SIZE_32) | DMA_CTRL_EN); // set control and trigger transfer
}

// fill memory with 16-bit sample using 16-bit DMA, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u16 (must be aligned to u16)
//   data = pointer to 16-bit sample to fill (must be aligned to u16)
//   count = number of u16 elements to fill
// Transfer speed: 4 us per 1 KB
void DMA_MemFill16(u8 chan, u16* dst, const volatile u16* data, int count)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, data); // set source address
	DMA_SetWrite(chan, dst); // set destination address
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_SIZE(DMA_SIZE_16) | DMA_CTRL_EN); // set control and trigger transfer
}

// fill memory with 8-bit sample using 8-bit DMA, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u8
//   data = pointer to 8-bit sample to fill
//   count = number of u8 elements to fill
// Transfer speed: 8 us per 1 KB
void DMA_MemFill8(u8 chan, u8* dst, const volatile u8* data, int count)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, data); // set source address
	DMA_SetWrite(chan, dst); // set destination address
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_SIZE(DMA_SIZE_8) | DMA_CTRL_EN); // set control and trigger transfer
}

// fill memory with 32-bit double word sample using optimised DMA transfer, waiting for completion
//   dst = pointer to destination
//   data = 32-bit sample to fill
//   num = number of bytes (last sample may be cropped)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 2 us per 1 KB
void DMA_MemFillDW(volatile void* dst, u32 data, int num)
{
	int num2;
	u8* dst8 = (u8*)dst;
	u8 chan;

	// fill first unaligned bytes
	while (((u32)dst8 & 3) != 0)
	{
		if (num <= 0) return;
		*dst8++ = (u8)data;
		data = (data >> 8) | (data << 24);
		num--;
	}

	chan = DMA_TEMP_CHAN(); // DMA temporary channel

	// fill 32-bit DMA
	if (num <= 0) return;
	num2 = num & 3; // rest in last dword
	num >>= 2; // number of dwords
	cb(); // compiler barrier (data must stay valid at this point)
	DMA_MemFill32(chan, (u32*)dst8, &data, num);

	// wait DMA for completion
	DMA_Wait(chan);

	// compiler barrier (data must stay valid at this point)
	cb();

	// disable DMA channel
	DMA_Disable(chan);

	// copy rest of data
	num <<= 2; // convert dwords back to bytes
	dst8 += num; // shift destination address
	while (num2 > 0)
	{
		*dst8++ = (u8)data;
		data = (data >> 8) | (data << 24);
		num2--;
	}
}

// fill memory with 16-bit word sample using optimised DMA transfer, waiting for completion
//   dst = pointer to destination
//   data = 16-bit sample to fill
//   num = number of bytes (last sample may be cropped)
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 2 us per 1 KB
void DMA_MemFillW(volatile void* dst, u16 data, int num)
{
	DMA_MemFillDW(dst, data | ((u32)data << 16), num);
}

// fill memory with 8-bit byte sample using optimised DMA transfer, waiting for completion
//   dst = pointer to destination
//   data = 8-bit sample to fill
//   num = number of bytes
// Can be used simultaneously in both CPUs, but not simultaneously in an interrupt.
// Transfer speed: 2 us per 1 KB
void DMA_MemFill(volatile void* dst, u8 data, int num)
{
	if (num < 32)
		// fill small amount of data
		memset((void*)dst, data, num);
	else
		// fast fill 32-bit DMA
		DMA_MemFillW(dst, data | ((u16)data << 8), num);
}

// DMA send data from memory to port, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   port = pointer to u32 port
//   src = pointer to first source u32 (must be aligned to u32)
//   count = number of u32 elements to transfer
//   dreq = data request channel of port DREQ_*
void DMA_ToPort(u8 chan, volatile u32* port, const u32* src, int count, u8 dreq)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, src); // set source address (memory)
	DMA_SetWrite(chan, port); // set destination address (port)
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ(dreq) | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_READ | DMA_CTRL_SIZE(DMA_SIZE_32) | DMA_CTRL_EN); // set control and trigger transfer
}

// DMA receive data from port to memory, not waiting for completion (wait with DMA_Wait function)
//   chan = DMA channel 0..11
//   dst = pointer to first destination u32 (must be aligned to u32)
//   port = pointer to u32 port
//   count = number of u32 elements to transfer
//   dreq = data request channel of port DREQ_*
void DMA_FromPort(u8 chan, u32* dst, const volatile u32* port, int count, u8 dreq)
{
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	DMA_SetRead(chan, port); // set source address (port)
	DMA_SetWrite(chan, dst); // set destination address (memory)
	DMA_SetCount(chan, count); // set count of elements
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_TREQ(dreq) | DMA_CTRL_CHAIN(chan) |
		DMA_CTRL_INC_WRITE | DMA_CTRL_SIZE(DMA_SIZE_32) | DMA_CTRL_EN); // set control and trigger transfer
}

// calculate optimised CRC checksum using DMA (wait for completion)
//   mode = CRC mode DMA_CRC_* (can include OR-ed flags DMA_CRC_INV and DMA_CRC_REV)
//   init = init data
//   chan = DMA channel 0..11
//   data = pointer to data
//   num = number of bytes
// Calculation speed: 2 us per 1 KB
u32 DMA_CRC(u8 mode, u32 init, u8 chan, const void* data, int num)
{
	int num2;

	// temporary destination
	u32 k = 0;

	// abort previous transfer
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	cb(); // compiler barrier

	// prepare sniff registers
	u32 sniff = DMA_SNIFF_EN | DMA_SNIFF_CHAN(chan) | DMA_SNIFF_CRC(mode & DMA_CRC_MASK);
	if ((mode & DMA_CRC_INV) != 0) sniff |= DMA_SNIFF_INV;
	if ((mode & DMA_CRC_REV) != 0) sniff |= DMA_SNIFF_REV;
	DMA_SetSniffCtrl(sniff); // set control word
	DMA_SetSniffData(init); // set init data

	// prepare DMA transfer
	DMA_SetRead(chan, data); // set source address
	DMA_SetWrite(chan, &k); // set destination address

	// prepare control word, without data size
	u32 ctrl = DMA_CTRL_SNIFF | DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan) | DMA_CTRL_INC_READ | DMA_CTRL_EN;

	// accumulate first unaligned bytes
	if ((((u32)data & 3) != 0) && (num > 0))
	{
		// prepare number of bytes - rest up to 32-bit boundary
		num2 = 4 - ((u32)data & 3);
		if (num2 > num) num2 = num;
		num -= num2;

		// set count of bytes
		DMA_SetCount(chan, num2);

		// set DMA control word and start transfer
		cb(); // compiler barrier
		DMA_SetCtrlTrig(chan, ctrl | DMA_CTRL_SIZE(DMA_SIZE_8)); // set control and trigger transfer

		// wait DMA for completion
		DMA_Wait(chan);
	}

	// accumulate aligned data
	num2 = num >> 2; // convert count to dwords
	if (num2 > 0)
	{
		// set count of dwords
		DMA_SetCount(chan, num2);

		// set DMA control word and start transfer
		cb(); // compiler barrier
		DMA_SetCtrlTrig(chan, ctrl | DMA_CTRL_SIZE(DMA_SIZE_32)); // set control and trigger transfer

		// wait DMA for completion
		DMA_Wait(chan);
	}

	// accumulate rest of unaligned bytes
	num -= num2 << 2;
	if (num > 0)
	{
		// set count of bytes
		DMA_SetCount(chan, num);

		// set DMA control word and start transfer
		cb(); // compiler barrier
		DMA_SetCtrlTrig(chan, ctrl | DMA_CTRL_SIZE(DMA_SIZE_8)); // set control and trigger transfer

		// wait DMA for completion
		DMA_Wait(chan);
	}

	// disable DMA channel
	DMA_Disable(chan);

	// get result and deactivate sniff
	u32 res = DMA_SniffData();
	DMA_SetSniffCtrl(0); // set control word, disable sniff
	return res;
}

// calculate checksum using DMA, on aligned data (wait for completion)
//   mode = CRC mode DMA_CRC_SUM or other (can include OR-ed flags DMA_CRC_INV and DMA_CRC_REV)
//   init = init data
//   chan = DMA channel 0..11
//   data = pointer to data (must be aligned to the u8/u16/u32 entry)
//   num = number of u8/u16/u32 entries
//   size = size of one entry DMA_SIZE_* (u8/u16/u32)
// Calculation speed: 32-bit 2 us per 1 KB, 16-bit 4 us per 1 KB, 8-bit 8 us per 1 KB
u32 DMA_SUM(u8 mode, u32 init, u8 chan, const void* data, int num, u8 size)
{
	// temporary destination
	u32 k = 0;

	// abort previous transfer
	DMA_Abort(chan); // abort current transfer
	DMA_ClearError(chan); // clear errors
	cb(); // compiler barrier

	// prepare sniff registers
	u32 sniff = DMA_SNIFF_EN | DMA_SNIFF_CHAN(chan) | DMA_SNIFF_CRC(mode & DMA_CRC_MASK);
	if ((mode & DMA_CRC_INV) != 0) sniff |= DMA_SNIFF_INV;
	if ((mode & DMA_CRC_REV) != 0) sniff |= DMA_SNIFF_REV;
	DMA_SetSniffCtrl(sniff); // set control word
	DMA_SetSniffData(init); // set init data

	// prepare DMA transfer
	DMA_SetRead(chan, data); // set source address
	DMA_SetWrite(chan, &k); // set destination address
	DMA_SetCount(chan, num); // set count of bytes

	// set DMA control word and start transfer
	cb(); // compiler barrier
	DMA_SetCtrlTrig(chan, DMA_CTRL_SNIFF | DMA_CTRL_TREQ_FORCE | DMA_CTRL_CHAIN(chan)
		| DMA_CTRL_INC_READ | DMA_CTRL_EN | DMA_CTRL_SIZE(size)); // set control and trigger transfer

	// wait DMA for completion
	DMA_Wait(chan);

	// disable DMA channel
	DMA_Disable(chan);

	// get result and deactivate sniff
	u32 res = DMA_SniffData();
	DMA_SetSniffCtrl(0); // set control word, disable sniff
	return res;
}

#endif // USE_DMA	// use DMA controller (sdk_dma.c, sdk_dma.h)
