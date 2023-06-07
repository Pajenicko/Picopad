
// ****************************************************************************
//
//                   Ring Buffer with DMA in transmitter mode
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_RINGTX	// use Ring buffer with DMA transmitter (lib_ringtx.c, lib_ringtx.h)

#include "../../_sdk/inc/sdk_spinlock.h"	// spinlock
#include "../../_sdk/inc/sdk_cpu.h"
#include "../../_sdk/inc/sdk_dma.h"
#include "../inc/lib_stream.h"
#include "../inc/lib_ringtx.h"
#include "../inc/lib_text.h"
#include "../inc/lib_print.h"

// initialize DMA ring buffer (not needed with static ring buffer, created with RINGTX() macro)
//   ring = pointer to DMA ring buffer
//   buf = data buffer (of size '1 << order' bytes)
//   port = periphery data register
//   spin = index of spinlock (-1 = not used)
//   order = order of buffer size 1..15 (size = 1 << order; e.g. 8 means buffer of size 256 bytes)
//   dma = DMA channel
//   dreq = DMA channel data request DREQ_*
//   entry = entry size DMA_SIZE_*
void RingTxInit(sRingTx* ring, u8* buf, volatile u32* port, int spin, u8 order, u8 dma, u8 dreq, u8 entry)
{
	ring->buf = buf;
	ring->size = 1 << order;
	ring->write = 0;
	ring->port = port;
	ring->spinlock = spin;
	ring->order = order;
	ring->dma = dma;
	ring->dreq = dreq;
	ring->entry = entry;
	RingTxPrep(ring); // prepare ring buffer
}

// start transfer using control register
static void RingTxCtrlTrig(sRingTx* ring)
{
	cb();				// compiler barrier (to setup other registers)
	DMA_SetCtrlTrig(		// set control word and trigger
		ring->dma,			// DMA channel
		DMA_CTRL_TREQ(ring->dreq) |	// dta request
		DMA_CTRL_CHAIN(ring->dma) |	// no chaining
		//DMA_CTRL_RING_WRITE |		// read addresses are wrapped
		DMA_CTRL_RING_SIZE(ring->order) | // wrap size in order of bytes
		DMA_CTRL_INC_READ |		// increment on read
		DMA_CTRL_SIZE(ring->entry) |	// entry size
		DMA_CTRL_EN);			// enable DMA channel
}

// start DMA write transfer in stream mode (continuous transmission)
void RingTxStart(sRingTx* ring)
{
	RingTxPrep(ring); 		// prepare ring buffer
	RingTxCtrlTrig(ring);		// start transfer using control register
}

// prepare DMA ring buffer, if created with RINGTX() macro and not with RingTxInit function
//  - must be called before any other function (not needed before RingTxStart function)
void RingTxPrep(sRingTx* ring)
{
	RingTxStop(ring);		// stop DMA transfers
	ring->write = 0;		// reset write offset
	u8 chan = ring->dma;		// get DMA channel
	DMA_SetWrite(chan, ring->port); // set write address to port
	DMA_SetRead(chan, ring->buf);	// set read address from the buffer
	DMA_SetCount(chan, 0x7FFFFFFF);	// set number of transfers
}

// pause DMA write transfer
void RingTxPause(sRingTx* ring)
{
	DMA_Disable(ring->dma);		// disable DMA channel
}

// unpause DMA write transfer
void RingTxUnpause(sRingTx* ring)
{
	DMA_Enable(ring->dma);		// enable DMA channel
}

// stop DMA write transfer 
void RingTxStop(sRingTx* ring)
{
	u8 chan = ring->dma;		// get DMA channel
	DMA_Abort(chan);		// abort current transfer
	DMA_ClearError(chan);		// clear errors
	DMA_Disable(chan);		// disable DMA channel
}

// send remaining data in the buffer (use in single-run mode, do not use in stream mode)
void RingTxSend(sRingTx* ring)
{
	// abort current transfer
	RingTxStop(ring);		// abort transfer

	// send number of transfers
	u32 n = RingTxNum(ring);	// get number of bytes in the buffer
	if (ring->entry >= DMA_SIZE_16) n /= 2; // 16-bit entry
	if (ring->entry >= DMA_SIZE_32) n /= 2; // 32-bit entry
	DMA_SetCount(ring->dma, n);	// set number of transfers

	// start transfer
	RingTxCtrlTrig(ring);		// start transfer using control register
}

// get free space for writing
u32 RingTxFree(sRingTx* ring)
{
	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	u32 wr = ring->write;
	u32 rd = (u8*)DMA_GetRead(ring->dma) - ring->buf;
	if (rd >= ring->size) rd -= ring->size;
	if (rd <= wr) rd += ring->size;

	// free space
	u32 num = rd - 1 - wr;

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	return num;
}

// get bytes in buffer
u32 RingTxNum(sRingTx* ring)
{
	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	u32 wr = ring->write;
	u32 rd = (u8*)DMA_GetRead(ring->dma) - ring->buf;
	if (rd >= ring->size) rd -= ring->size;
	if (wr < rd) wr += ring->size;

	// number of valid bytes
	u32 num = wr - rd;

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	return num;
}

// check if ring buffer is ready to write required number of bytes
Bool RingTxReady(sRingTx* ring, u32 len)
{
	return RingTxFree(ring) >= len;
}

// write whole data into ring buffer, without waiting (returns False if buffer has not free space)
// Data is written only if there is enough space in the ring buffer. Cannot write only part of the data.
Bool RingTxWrite(sRingTx* ring, const void* src, u32 len)
{
	u32 wr, rd, num, size;
	Bool ok;
	const u8* s;

// The first test is performed without locking the locks,
// to give the service enough time to perform the operations

	// get ring offsets
	size = ring->size;
	wr = ring->write;
	rd = (u8*)DMA_GetRead(ring->dma) - ring->buf;
	if (rd >= size) rd -= size;
	if (rd <= wr) rd += size;

	// check free space
	num = rd - 1 - wr;
	if (num < len)
	{
		// insufficient free space - start sending data if DMA is running in single mode
		if (!DMA_IsBusy(ring->dma)) RingTxSend(ring);
		return False;
	}

	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	wr = ring->write;
	rd = (u8*)DMA_GetRead(ring->dma) - ring->buf;
	if (rd >= size) rd -= size;
	if (rd <= wr) rd += size;

	// check free space
	num = rd - 1 - wr;
	ok = False;
	if (num >= len)
	{
		s = (const u8*)src;

		// write data into buffer
		for (; len > 0; len--)
		{
			ring->buf[wr++] = *s++;
			if (wr >= size) wr -= size;
		}
		ring->write = wr;
		ok = True;
	}

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	// Refresh DMA counter during transfers in stream mode to run infinitely - should be called sometimes
	num = DMA_GetCount(ring->dma);
	if ((num < 0x78000000) && (num > 0x70000000) && DMA_IsBusy(ring->dma) && DMA_IsEnabled(ring->dma)) DMA_SetCountTrig(ring->dma, 0x7FFFFFFF);

	return ok;
}

// write part of data into ring buffer, without waiting (returns number of written bytes)
Bool RingTxWriteData(sRingTx* ring, const void* src, u32 len)
{
	u32 wr, rd, num, size;
	Bool ok;
	const u8* s;

// The first test is performed without locking the locks,
// to give the service enough time to perform the operations

	// get ring offsets
	size = ring->size;
	wr = ring->write;
	rd = (u8*)DMA_GetRead(ring->dma) - ring->buf;
	if (rd >= size) rd -= size;
	if (rd <= wr) rd += size;

	// check free space
	num = rd - 1 - wr;
	if (num == 0)
	{
		// insufficient free space - start sending data if DMA is running in single mode
		if (!DMA_IsBusy(ring->dma)) RingTxSend(ring);
		return 0;
	}

	// lock ring buffer and IRQ
	SPINLOCK_LOCK(ring->spinlock);

	// get ring offsets
	wr = ring->write;
	rd = (u8*)DMA_GetRead(ring->dma) - ring->buf;
	if (rd >= size) rd -= size;
	if (rd <= wr) rd += size;

	// check free space
	num = rd - 1 - wr;
	if (num > len) num = len;
	ok = num;
	if (num > 0)
	{
		s = (const u8*)src;

		// write data into buffer
		for (; len > 0; len--)
		{
			ring->buf[wr++] = *s++;
			if (wr >= size) wr -= size;
		}
		ring->write = wr;
	}

	// unlock ring buffer and IRQ
	SPINLOCK_UNLOCK(ring->spinlock);

	// Refresh DMA counter during transfers in stream mode to run infinitely - should be called sometimes
	num = DMA_GetCount(ring->dma);
	if ((num < 0x78000000) && (num > 0x70000000) && DMA_IsBusy(ring->dma) && DMA_IsEnabled(ring->dma)) DMA_SetCountTrig(ring->dma, 0x7FFFFFFF);

	return ok;
}

// write 8-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingTxWrite8(sRingTx* ring, u8 data) { return RingTxWrite(ring, &data, 1); }

// write 16-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingTxWrite16(sRingTx* ring, u16 data) { return RingTxWrite(ring, &data, 2); }

// write 32-bit data into ring buffer, without waiting (data is lost if buffer is full - returns False on buffer overflow)
Bool RingTxWrite32(sRingTx* ring, u32 data) { return RingTxWrite(ring, &data, 4); }

// write data into ring buffer, wait until ready
void RingTxWriteWait(sRingTx* ring, const void* src, u32 len)
{
	u32 n;
	const u8* s = (const u8*)src;
	while (len > 0)
	{
		n = RingTxWriteData(ring, s, len);
		len -= n;
		s += n;
	}
}

// write 8-bit data into ring buffer, wait until ready
void RingTxWrite8Wait(sRingTx* ring, u8 data) { while (!RingTxWrite8(ring, data)) {} }

// write 16-bit data into ring buffer, wait until ready
void RingTxWrite16Wait(sRingTx* ring, u16 data) { while (!RingTxWrite16(ring, data)) {} }

// write 32-bit data into ring buffer, wait until ready
void RingTxWrite32Wait(sRingTx* ring, u32 data) { while (!RingTxWrite32(ring, data)) {} }

// write data into ring buffer and send remaining data
void RingTxWriteSend(sRingTx* ring, const void* src, u32 len)
{
	// write data and send
	RingTxWriteWait(ring, src, len);

	// send remaining data (not in stream mode)
	if (DMA_GetCount(ring->dma) < 0x70000000) RingTxSend(ring);
}

// callback - close stream, send rest of data
static void StreamCloseRingTx(sStream* str)
{
	// destination ring
	sRingTx* ring = (sRingTx*)str->cookie;

	// send remaining data (not in stream mode)
	if (DMA_GetCount(ring->dma) < 0x70000000) RingTxSend(ring);
}

// callback - write data to ring buffer
static u32 StreamWriteRingTx(sStream* str, const void* buf, u32 num)
{
	// destination ring
	sRingTx* ring = (sRingTx*)str->cookie;

	// write data into ring buffer, wait until ready
	RingTxWriteWait(ring, buf, num);

	return num;
}

// initialize stream to write to ring buffer
void StreamWriteRingTxInit(sStream* str, sRingTx* ring)
{
	Stream0Init(str); // clear stream descriptor
	str->cookie = (u32)ring; // cookie = pointer to ring descriptor
	str->close = StreamCloseRingTx; // close function
	str->write = StreamWriteRingTx; // write function
}

// formated print string into ring buffer, with argument list
u32 RingTxPrintArg(sRingTx* ring, const char* fmt, va_list args)
{
	// write and read stream
	sStream wstr, rstr;

	// initialize stream to read from
	StreamReadBufInit(&rstr, fmt, StrLen(fmt));

	// initialize stream to write to
	StreamWriteRingTxInit(&wstr, ring);
	
	// print string
	return StreamPrintArg(&wstr, &rstr, args);
}

// formated print string into ring buffer, with variadic arguments
NOINLINE u32 RingTxPrint(sRingTx* ring, const char* fmt, ...)
{
	u32 n;
	va_list args;
	va_start(args, fmt);
	n = RingTxPrintArg(ring, fmt, args);
	va_end(args);
	return n;
}

#endif // USE_RINGTX	// use Ring buffer with DMA transmitter (lib_ringtx.c, lib_ringtx.h)
