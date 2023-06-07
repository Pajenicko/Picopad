
// ****************************************************************************
//
//                                 Timer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_TIMER	// use Timer with alarm (sdk_timer.c, sdk_timer.h)

#include "../inc/sdk_timer.h"
#include "../inc/sdk_cpu.h"

// get 64-bit absolute system time in [us] - fast method, but it is not atomic safe
//   - do not use simultaneously from both processor cores and from interrupts
u64 Time64Fast()
{
	u32 low = *TIMER_TIMELR; // get latched time LOW
	cb(); // compiler barrier (or else the compiler could swap the order of operations)
	u32 high = *TIMER_TIMEHR; // get latched time HIGH
	return ((u64)high << 32) | low;
}

// get 64-bit absolute system time in [us] - atomic method (concurrently safe)
u64 Time64()
{
	u32 low, high;
	u32 high2 = *TIMER_TIMERAWH;  // get raw time HIGH

	do {
		// accept new time HIGH
		high = high2;

		// get raw time LOW
		cb(); // compiler barrier (or else the compiler could swap the order of operations)
		low = *TIMER_TIMERAWL;

		// get raw time HIGH again
		cb(); // compiler barrier (or else the compiler could swap the order of operations)
		high2 = *TIMER_TIMERAWH;

	// check that HIGH has not changed, otherwise a re-read will be necessary
	} while (high != high2);

	// return result value
	return ((u64)high << 32) | low;
}

// wait for delay in [us] (max. 71 minutes, 4'294'967'295 us)
void WaitUs(u32 us)
{
	u32 start = Time();
	while ((u32)(Time() - start) < us) {}
}

// wait for delay in [ms] (max. 71 minutes, 4'294'967 ms)
void WaitMs(int ms)
{
	WaitUs((u32)ms*1000);
}

// start alarm
//   alarm = alarm number 0..3
//   handler = interrupt handler
//   time = absolute system time LOW in which to activate the alarm (max. difference 71 minutes)
//            If 64-bit time is required, check HIGH part of the time in interrupt service.
// Vector table must be located in RAM
// If vector table is not in RAM, use services with names isr_timer_0..isr_timer_3
// Call AlarmAck on start of interrupt, then AlarmRestart to restart again, or AlarmStop to deactivate.
// Alarm handler is shared between both processor cores. Only alarms of different numbers can be independent.
// - remember to keep the state of the divider in the interrupt handler in case division is used in the handler
void AlarmStart(u8 alarm, irq_handler_t handler, u32 time)
{
	// stop previous alarm
	AlarmStop(alarm);

	// prepare interrupt IRQ
	u8 irq = ALARM_IRQ(alarm);

	// set interrupt handler to VTOR interrupt table (VTOR should be in RAM)
	SetHandler(irq, handler);

	// enable interrupt on NVIC
	NVIC_IRQEnable(irq);

	// enable interrupt from the timer
	RegSet(TIMER_INTE, BIT(alarm));

	// arm timer
	*TIMER_ALARM(alarm) = time;
}

// restart alarm - can be called from an interrupt for a repeated alarm or if the 64-bit time has not been reached yet
//   timedelta = difference of new time LOW from old alarm in [us]
void AlarmRestart(u8 alarm, u32 timedelta)
{
	// re-arm timer
	*TIMER_ALARM(alarm) = *TIMER_ALARM(alarm) + timedelta;
}

// stop alarm - can be called from an interrupt if no next interrupt is required
void AlarmStop(u8 alarm)
{
	// disable interrupt from the timer
	RegClr(TIMER_INTE, BIT(alarm));

	// disarm alarm
	*TIMER_ARMED = BIT(alarm);

	// acknowledge alarm request
	AlarmAck(alarm);

	// disable interrupt on NVIC
	NVIC_IRQDisable(ALARM_IRQ(alarm));
}

#endif // USE_TIMER	// use Timer with alarm (sdk_timer.c, sdk_timer.h)
