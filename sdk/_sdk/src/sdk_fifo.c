
// ****************************************************************************
//
//                              Inter-core FIFO
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_FIFO	// use Inter-core FIFO (sdk_fifo.c, sdk_fifo.h)

#include "../inc/sdk_fifo.h"
#include "../inc/sdk_cpu.h"
#include "../inc/sdk_timer.h"

// write message to other core (wait if not ready)
void FifoWrite(u32 data)
{
	// wait TX FIFO to ready
	while (!FifoWriteReady()) {}

	// send message
	*FIFO_WRITE = data;

	// send event to the other code
	sev();
}

// write message to other core with time-out in [us] (wait if not ready, max. 71 minutes, returns False on time-out)
Bool FifoWriteTime(u32 data, u32 us)
{
	// prepare current time
	u32 start = Time();

	// wait TX FIFO to ready
	while (!FifoWriteReady())
	{
		// check time-out (returns False on time-out)
		if ((u32)(Time() - start) >= us) return False;
	}

	// send message
	*FIFO_WRITE = data;

	// send event to the other code
	sev();
	return True;
}

// read message from other core (wait if not ready)
u32 FifoRead()
{
	// wait RX FIFO to ready
	while (!FifoReadReady())
	{
		// wait for event
		wfe();
	}

	// receive message
	return *FIFO_READ;
}

// read message from other core with time-out in [us] (wait if not ready, max. 71 minutes, returns False on time-out)
Bool FifoReadTime(u32* data, u32 us)
{
	// prepare current time
	u32 start = Time();

	// wait RX FIFO to ready
	while (!FifoReadReady())
	{
		// wait for event
		wfe();

		// check time-out (returns False on time-out)
		if ((u32)(Time() - start) >= us) return False;
	}

	// receive message
	*data = *FIFO_READ;
	return True;
}

// FIFO hanshake - send code and wait for same response
void FifoHandshake(u32 code)
{
	// save and lock interrupts
	IRQ_LOCK;

	// send code
	FifoWrite(code);

	// wait for same response
	while (FifoRead() != code) {}

	// unlock interrupts
	IRQ_UNLOCK;
}

#endif // USE_FIFO	// use Inter-core FIFO (sdk_fifo.c, sdk_fifo.h)
