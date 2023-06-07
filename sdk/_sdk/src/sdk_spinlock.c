
// ****************************************************************************
//
//                              Spinlock
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_SPINLOCK	// use Spinlock (sdk_spinlock.c, sdk_spinlock.h)

#include "../inc/sdk_spinlock.h"
#include "../inc/sdk_cpu.h"

// reset all spinlocks
void SpinResetAll()
{
	u8 lock;
	dmb(); // data memory barrier
	for (lock = 0; lock < SPINLOCK_NUM; lock++) SpinUnlock(lock);
}

#endif // USE_SPINLOCK	// use Spinlock (sdk_spinlock.c, sdk_spinlock.h)
