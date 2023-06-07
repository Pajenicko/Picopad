
// ****************************************************************************
//
//                   Ring Buffer with DMA in receiver mode
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_RINGRX		// use Ring buffer with DMA receiver (lib_ringrx.c, lib_ringrx.h)

#include "../../_sdk/inc/sdk_spinlock.h"	// spinlock
#include "../../_sdk/inc/sdk_cpu.h"
#include "../../_sdk/inc/sdk_dma.h"
#include "../inc/lib_stream.h"
#include "../inc/lib_ringrx.h"

// initialize DMA ring buffer (not needed with static ring buffer, created with RINGRX() macro)
//   ring = pointer to the ring buffer
//   buf = data buffer (of size '1 << order' bytes; start address must be aligned to '1 << order' bytes)
//   port = pointer to periphery data register (data port)
//   spin = index of spinlock (-1 = not used)
//   order = order of buffer size 1..15 (size = 1 << order; e.g. 8 means buffer of size 256 bytes)
//   dma = DMA channel
//   dreq = DMA channel data request DREQ_*
//   entry = entry size DMA_SIZE_*
void RingRxInit(sRingRx* ring, u8* buf, volatile u32* port, int spin, u8 order, u8 dma, u8 dreq, u8 entry)
{
	ring->buf = buf;
	ring->size = 1 << order;
	ring->read = 0;
	ring->port = port;
	ring->spinlock = spin;
	ring->order = order;
	ring->dma = dma;
	ring->dreq = dreq;
	ring->entry = entry;
}

// start DMA read transfer (data will be read from the port permanently, without checking for buffer overflow)
//  >>> The RingRxStart function must be started first before using any of the following functions. <<<
void RingRxStart(sRingRx* ring)
{
	RingRxStop(ring);		// stop DMA transfers
	u8 chan = ring->dma;		// get DMA channel
	ring->read = 0;			// reset read offset
	DMA_SetRead(chan, ring->port); 	// set read address from port
	DMA_SetWrite(chan, ring->buf);	// set write address to the buffer
	DMA_SetCount(chan, 0x7FFFFFFF);	// set number of transfers
	cb();				// compiler barrier
	DMA_SetCtrlTrig(		// set control word and trigger
		chan,				// DMA channel
		DMA_CTRL_TREQ(ring->dreq) |	// dta request
		DMA_CTRL_CHAIN(chan) |		// no chaining
		DMA_CTRL_RING_WRITE |		// write addresses are wrapped
		DMA_CTRL_RING_SIZE(ring->order) | // wrap size in order of bytes
		DMA_CTRL_INC_WRITE |		// increment on write
		DMA_CTRL_SIZE(ring->entry) |	// entry size
		DMA_CTRL_EN);			// enable DMA channel
}

// pause DMA read transfer
void RingRxPause(sRingRx* ring)
{
	DMA_Disable(ring->dma);		// disable DMA channel
}

// unpause DMA read transfer
void RingRxUnpause(sRingRx* ring)
{
	DMA_Enable(ring->dma);		// enable DMA channel
}

// stop DMA read transfer 
void RingRxStop(sRingRx* ring)
{
	u8 chan = ring->dma;		// get DMA channel
	DMA_Abort(chan);		// abort current transfer
	DMA_ClearError(chan);		// clear errors
	DMA_Disable(chan);		// disable DMA channel
}

// get free space in buffer
u32 RingRxFree(sRingRx* ring)
{
	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	u32 wr = (u8*)DMA_GetWrite(ring->dma) - ring->buf;
	if (wr >= ring->size) wr -= ring->size;
	u32 rd = ring->read;
	if (rd <= wr) rd += ring->size;

	// free space
	u32 num = rd - 1 - wr;

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	return num;
}

// get bytes available for reading
u32 RingRxNum(sRingRx* ring)
{
	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	u32 wr = (u8*)DMA_GetWrite(ring->dma) - ring->buf;
	if (wr >= ring->size) wr -= ring->size;
	u32 rd = ring->read;
	if (wr < rd) wr += ring->size;

	// number of valid bytes
	u32 num = wr - rd;

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	return num;
}

// check if ring buffer is ready to read required number of bytes
Bool RingRxReady(sRingRx* ring, u32 len)
{
	return RingRxNum(ring) >= len;
}

// read whole data from ring buffer, without waiting (returns False if buffer has not enough data)
// Data is read only if there is enough data in the ring buffer. Cannot read only part of the data.
Bool RingRxRead(sRingRx* ring, void* dst, u32 len)
{
	u32 wr, rd, num, size;
	Bool ok;
	u8* d;

// The first test is performed without locking the locks,
// to give the service enough time to perform the operations

	// get ring offsets
	wr = (u8*)DMA_GetWrite(ring->dma) - ring->buf;
	rd = ring->read;
	size = ring->size;
	if (wr >= size) wr -= size;
	if (wr < rd) wr += size;

	// check data size
	num = wr - rd;
	if (num < len) return False;

	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	wr = (u8*)DMA_GetWrite(ring->dma) - ring->buf;
	rd = ring->read;
	if (wr < rd) wr += size;

	// check data size
	num = wr - rd;
	ok = False;
	if (num >= len)
	{
		d = (u8*)dst;

		// read data from buffer
		for (; len > 0; len--)
		{
			*d++ = ring->buf[rd++];
			if (rd >= size) rd -= size;
		}
		ring->read = rd;
		ok = True;
	}

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	// Refresh DMA counter during transfers to run infinitely - should be called sometimes
	if ((DMA_GetCount(ring->dma) < 0x78000000) && DMA_IsBusy(ring->dma) && DMA_IsEnabled(ring->dma)) DMA_SetCountTrig(ring->dma, 0x7FFFFFFF);

	return ok;
}

// read part of data from ring buffer, without waiting (returns number of read bytes)
u32 RingRxReadData(sRingRx* ring, void* dst, u32 len)
{
	u32 wr, rd, num, ok, size;
	u8* d;

// The first test is performed without locking the locks,
// to give the service enough time to perform the operations

	// get ring offsets
	wr = (u8*)DMA_GetWrite(ring->dma) - ring->buf;
	rd = ring->read;
	size = ring->size;
	if (wr >= size) wr -= size;
	if (wr < rd) wr += size;

	// check data size
	num = wr - rd;
	if (num == 0) return 0;

	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	wr = (u8*)DMA_GetWrite(ring->dma) - ring->buf;
	rd = ring->read;
	if (wr < rd) wr += size;

	// check data size
	num = wr - rd;
	if (num > len) num = len;
	ok = num;
	if (num > 0)
	{
		d = (u8*)dst;

		// read data from buffer
		for (; num > 0; num--)
		{
			*d++ = ring->buf[rd++];
			if (rd >= size) rd -= size;
		}
		ring->read = rd;
	}

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	// Refresh DMA counter during transfers to run infinitely - should be called sometimes
	if ((DMA_GetCount(ring->dma) < 0x78000000) && DMA_IsBusy(ring->dma) && DMA_IsEnabled(ring->dma)) DMA_SetCountTrig(ring->dma, 0x7FFFFFFF);

	return ok;
}

// read 8-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRxRead8(sRingRx* ring, u8* dst) { return RingRxRead(ring, dst, 1); }

// read 16-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRxRead16(sRingRx* ring, u16* dst) { return RingRxRead(ring, dst, 2); }

// read 32-bit data from ring buffer, without waiting (returns False if buffer has not enough data)
Bool RingRxRead32(sRingRx* ring, u32* dst) { return RingRxRead(ring, dst, 4); }

// read data from ring buffer, wait until ready
void RingRxReadWait(sRingRx* ring, void* dst, u32 len)
{
	u32 n;
	u8* d = (u8*)dst;
	while (len > 0)
	{
		n = RingRxReadData(ring, d, len);
		len -= n;
		d += n;
	}
}

// read 8-bit data from ring buffer and wait until ready
u8 RingRxRead8Wait(sRingRx* ring)
{
	u8 data;
	while (!RingRxRead8(ring, &data)) {}
	return data;
}

// read 16-bit data from ring buffer and wait until ready
u16 RingRxRead16Wait(sRingRx* ring)
{
	u16 data;
	while (!RingRxRead16(ring, &data)) {}
	return data;
}

// read 32-bit data from ring buffer and wait until ready
u32 RingRxRead32Wait(sRingRx* ring)
{
	u32 data;
	while (!RingRxRead32(ring, &data)) {}
	return data;
}

#endif // USE_RINGRX		// use Ring buffer with DMA receiver (lib_ringrx.c, lib_ringrx.h)
