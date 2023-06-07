
// ****************************************************************************
//
//                                 Timer
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// 64-bit timer with 1-us resolution and with 4 alarms.
// Time source is shared with watchdog counter.
// Alarm handler is shared between both processor cores. Only alarms of different numbers can be independent.

#if USE_TIMER	// use Timer with alarm (sdk_timer.c, sdk_timer.h)

#ifndef _SDK_TIMER_H
#define _SDK_TIMER_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "sdk_irq.h"		// Register address offsets

#ifdef __cplusplus
extern "C" {
#endif

// === Timer (RP2040 datasheet page 553)

// registers
//#define TIMER_BASE		0x40054000	// us timer
#define TIMER_TIMEHW ((volatile u32*)(TIMER_BASE + 0x00)) // latched write HIGH (write completely first LOW and then HIGH)
#define TIMER_TIMELW ((volatile u32*)(TIMER_BASE + 0x04)) // latched write LOW (write completely first LOW and then HIGH)
#define TIMER_TIMEHR ((volatile u32*)(TIMER_BASE + 0x08)) // latched read HIGH (read first LOW and then HIGH)
#define TIMER_TIMELR ((volatile u32*)(TIMER_BASE + 0x0C)) // latched read LOW (read first LOW and then HIGH)
#define TIMER_ALARM0 ((volatile u32*)(TIMER_BASE + 0x10)) // arm alarm 0 (fires if == TIMELR)
#define TIMER_ALARM1 ((volatile u32*)(TIMER_BASE + 0x14)) // arm alarm 1 (fires if == TIMELR)
#define TIMER_ALARM2 ((volatile u32*)(TIMER_BASE + 0x18)) // arm alarm 2 (fires if == TIMELR)
#define TIMER_ALARM3 ((volatile u32*)(TIMER_BASE + 0x1C)) // arm alarm 3 (fires if == TIMELR)
#define TIMER_ARMED ((volatile u32*)(TIMER_BASE + 0x20)) // bit 0..3: 1=alarm is armed, write 1 to disarm, write to alarm to arm
#define TIMER_TIMERAWH ((volatile u32*)(TIMER_BASE + 0x24)) // raw read HIGH
#define TIMER_TIMERAWL ((volatile u32*)(TIMER_BASE + 0x28)) // raw read LOW
#define TIMER_DBGPAUSE ((volatile u32*)(TIMER_BASE + 0x2C)) // bit 1: 1=pause timer during debug of CPU0, bit 2: ...of CPU1
#define TIMER_PAUSE ((volatile u32*)(TIMER_BASE + 0x30)) // bit 0: 1=pause timer
#define TIMER_INTR ((volatile u32*)(TIMER_BASE + 0x34)) // bit 0..3: raw interrupts
#define TIMER_INTE ((volatile u32*)(TIMER_BASE + 0x38)) // bit 0..3: interrupt enable
#define TIMER_INTF ((volatile u32*)(TIMER_BASE + 0x3C)) // bit 0..3: interrupt force
#define TIMER_INTS ((volatile u32*)(TIMER_BASE + 0x40)) // bit 0..3: interrupt status

#define TIMER_ALARM(alarm) ((volatile u32*)(TIMER_BASE + 0x10 + (alarm)*4)) // arm alarm 0..3 (fires if == TIMELR)

// get IRQ number IRQ_TIMER_0..IRQ_TIMER_3 for alarm 0..3
#define ALARM_IRQ(alarm) (IRQ_TIMER_0 + (alarm))

// get 32-bit absolute system time LOW in [us]
#define Time() (*TIMER_TIMERAWL)

// get 64-bit absolute system time in [us] - fast method, but it is not atomic safe
//   - do not use simultaneously from both processor cores and from interrupts
u64 Time64Fast();

// get 64-bit absolute system time in [us] - atomic method (concurrently safe)
u64 Time64();

// wait for delay in [us] (max. 71 minutes, 4'294'967'295 us)
void WaitUs(u32 us);

// wait for delay in [ms] (max. 71 minutes, 4'294'967 ms)
void WaitMs(int ms);

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
void AlarmStart(u8 alarm, irq_handler_t handler, u32 time);

// force alarm
#define AlarmForce(alarm) *TIMER_INTF = BIT(alarm)

// acknowledge alarm 0..3 interrupt - should be called from start of interrupt handler
//   Alarm will be disarmed automatically when it is triggered
#define AlarmAck(alarm) *TIMER_INTR = BIT(alarm)

// check alarm pending status
#define AlarmIsPending(alarm) ((*TIMER_INTS & BIT(alarm)) != 0)

// restart alarm - can be called from an interrupt for a repeated alarm or if the 64-bit time has not been reached yet
//   timedelta = difference of new time LOW from old alarm in [us]
void AlarmRestart(u8 alarm, u32 timedelta);

// stop alarm - can be called from an interrupt if no next interrupt is required
void AlarmStop(u8 alarm);

#ifdef __cplusplus
}
#endif

#endif // _SDK_TIMER_H

#endif // USE_TIMER	// use Timer with alarm (sdk_timer.c, sdk_timer.h)
