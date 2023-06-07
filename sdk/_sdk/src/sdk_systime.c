
// ****************************************************************************
//
//                             SysTick system timer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_SYSTICK		// use SysTick system timer (sdk_systime.c, sdk_systime.h)

#include "../inc/sdk_cpu.h"
#include "../inc/sdk_systime.h"
#include "../inc/sdk_timer.h"
#include "../inc/sdk_irq.h"
#include "../../_lib/inc/lib_alarm.h"

// system time counter, counts time from system start - incremented every SYSTICK_MS ms
// with overflow after 49 days (use difference, not absolute value!)
volatile u32 SysTime;

// current date and time (incremented every SYSTICK_MS ms from CPU core 0)
volatile u32 UnixTime;		// current date and time in Unix format
				// - number of seconds since 1/1/1970 (thursday) up to 12/31/2099
volatile s16 TimeMs;		// current time in [ms] 0..999
volatile u16 LastTimeUs;	// last [us] time during timer interrupt

// SysTick handler
void SysTick_Handler()
{
	// disable interrupts (to avoid interrupt by higher IRQ)
	IRQ_LOCK;

	// get current core
	int core = CpuID();

	// update system time - only for CPU core 0
	if (core == 0)
	{
		// increase current system time
		u32 systime = SysTime;	// get current system time
		systime += SYSTICK_MS;	// increase current system time
		SysTime = systime;	// update new value

		// save last time
#if USE_TIMER
		LastTimeUs = (u16)Time(); // get current time in [us]
#else
		LastTimeUs = 0;
#endif

		// update current date and time
		u16 ms = TimeMs + SYSTICK_MS; // new [ms] time
		if (ms >= 1000) // overflow to second?
		{
			ms -= 1000;
			UnixTime++; // increase Unix time
		}
		TimeMs = ms;	// save new [ms] time
	}

#if USE_ALARM			// use SysTick alarm (lib_alarm.c, lib_alarm.h)
	// update alarms of this CPU core
	AlarmUpdate();
#endif

	// enable interrupts
	IRQ_UNLOCK;

	// request to reschedule tasks (use in multitask system)
	//NVIC_PendSVForce();
}

// initialize SysTick timer for this CPU core to interrupt every SYSTICK_MS ms
// - AlarmInit() function must be called before initializing SysTick timers.
// - It must be called from each CPU core separately.
void SysTickInit()
{
	// get current core
	int core = CpuID();

	// initialize variables - only for CPU core 0
	if (core == 0)
	{
		SysTime = 0;	// reset system time counter
		UnixTime = 0;	// reset current date and time in Unix format
		TimeMs = 0;	// reset current time in [ms]
#if USE_TIMER
		LastTimeUs = Time(); // reset last [us] time during timer interrupt
#else
		LastTimeUs = 0;
#endif
	}

	// temporary disable SysTick counter
	*SYSTICK_CSR = B1;	// disable SysTick handler

	// register SysTick handler
	SetHandler(IRQ_SYSTICK, SysTick_Handler);	

	// initialize system tick timer to 1 ms
	*SYSTICK_RVR = SYSTICK_TICKS - 1; // set reload register 
	NVIC_SysTickPrio(IRQ_PRIO_SYSTICK); // set interrupt priority
	*SYSTICK_CVR = 0;	// reset counter
	*SYSTICK_CSR = B0 | B1;	// set control register - counter enabled,
				//   trigger SysTick exception, use external reference clock
}

// terminate SysTick timer
void SysTickTerm()
{
	*SYSTICK_CSR = B1;	// disable SysTick handler
}

// get current date and time in Unix format with [ms] and [us], synchronized (NULL = entries not required)
//  Takes 1 us
u32 GetUnixTime(s16* ms, s16* us)
{
	s16 m, m2, u, u2;
	u32 t, t2;
	int core;

	// get current core
	core = CpuID();

	// fast prepare old values on core 1
	if (core != 0)
	{
		// get current time in [ms]
		m2 = TimeMs;

		// get current time in [us]
#if USE_TIMER
		u2 = (s16)(Time() - LastTimeUs);
#else
		u2 = 0;
#endif

		// get Unix time
		t2 = UnixTime;
	}

	// on core 1 use multiply passes (result may be unstable)
	while (True)
	{
		// disable interrupts
		IRQ_LOCK;

		// get current time in [ms]
		m = TimeMs;

		// get current time in [us]
#if USE_TIMER
		u = (s16)(Time() - LastTimeUs);
#else
		u = 0;
#endif

		// get Unix time
		t = UnixTime;

		// enable interrupts
		IRQ_UNLOCK;

		// unserved pending interrupt or normalize long period
		while (u >= 1000)
		{
			u -= 1000; // [us] correction
			m++; // [ms] correction

			// [ms] overflow
			if (m >= 1000)
			{
				m -= 1000; // [ms] correction
				t++; // seconds correction
			}
		}


		// on core 0 result is valid immediately
		if (core == 0) break;

		// check difference from previous value
		u2 = u - u2;
		m2 = m - m2;
		t2 = t - t2;

		while (u2 < 0)
		{
			u2 += 1000;
			m2--;
		}

		while (u2 >= 1000)
		{
			u2 -= 1000;
			m2++;
		}

		while (m2 < 0)
		{
			m2 += 1000;
			t2--;
		}

		while (m2 >= 1000)
		{
			m2 -= 1000;
			t2++;
		}

		// check difference - must be less than 1 ms
		if ((t2 == 0) && (m2 == 0)) break;

		// save old values
		m2 = m;
		u2 = u;
		t2 = t;
	}

	// save current [us]
	if (us != NULL) *us = u;
	
	// save current [ms]
	if (ms != NULL) *ms = m;

	return t;
}

// set current date and time in Unix format with [ms] (0..999)
// - Should be called from CPU core 0. From core 1, the setting may be inaccurate.
//  Takes 280 ns
void SetUnixTime(u32 time, s16 ms)
{
	// disable interrupts
	IRQ_LOCK;

	// store new values
	UnixTime = time;
	TimeMs = ms;

	// enable interrupts
	IRQ_UNLOCK;
}

#endif // USE_SYSTICK		// use SysTick system timer (sdk_systime.c, sdk_systime.h)
