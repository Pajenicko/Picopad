
// ****************************************************************************
//
//                            RTC Real-time clock
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

// Leap year does not work OK for years 1900 and 2100,
//   so RTC with leap should be used in range 1901..2099.
// (RP2040 datasheet page 562)

#if USE_RTC	// use RTC Real-time clock (sdk_rtc.c, sdk_rtc.h)

#ifndef _SDK_RTC_H
#define _SDK_RTC_H

#include "../sdk_addressmap.h"		// Register address offsets
#include "../../_lib/inc/lib_calendar.h"		// datetime structure

#ifdef __cplusplus
extern "C" {
#endif

//#define RTC_BASE		0x4005c000	// RTC real-time clock
#define RTC_CLKDIV	((volatile u32*)(RTC_BASE+0x00)) // divider minus 1 for 1-second counter
#define RTC_SETUP0	((volatile u32*)(RTC_BASE+0x04)) // setup 0
#define RTC_SETUP1	((volatile u32*)(RTC_BASE+0x08)) // setup 1
#define RTC_CTRL	((volatile u32*)(RTC_BASE+0x0C)) // control and status
#define RTC_IRQSET0	((volatile u32*)(RTC_BASE+0x10)) // IRQ setup 0
#define RTC_IRQSET1	((volatile u32*)(RTC_BASE+0x14)) // IRQ setup 1
#define RTC_1		((volatile u32*)(RTC_BASE+0x18)) // RTC register 1
#define RTC_0		((volatile u32*)(RTC_BASE+0x1C)) // RTC register 0 (read this before RTC_1)
#define RTC_INTR	((volatile u32*)(RTC_BASE+0x20)) // raw interrupts
#define RTC_INTE	((volatile u32*)(RTC_BASE+0x24)) // interrupt enable
#define RTC_INTF	((volatile u32*)(RTC_BASE+0x28)) // interrupt force
#define RTC_INTS	((volatile u32*)(RTC_BASE+0x2C)) // interrupt status

// RTC alarm callback
typedef void (*pRtcAlarm)();

// current RTC alarm callback (NULL=none)
extern pRtcAlarm RtcAlarm;

// check if RTC is running
INLINE Bool RtcRunning() { return (*RTC_CTRL & B1) != 0; }

// check if RTC alarm is pending
INLINE Bool RtcPending() { return (*RTC_INTS & B0) != 0; }

// initialize RTC (not running yet - it will start after setting date and time RtcSetDateTime)
void RtcInit();

// set RTC clock from datetime structure
void RtcSetDateTime(const sDateTime* dt);

// get RTC to datetime structure
void RtcGetDateTime(sDateTime* dt);

// enable RTC alarm
void RtcAlarmEnable();

// disable RTC alarm
void RtcAlarmDisable();

// check datetime structure, if alarm will be repeated (some entry has value = -1)
Bool RtcDateTimeRepeated(const sDateTime* dt);

// check if RTC alarm is repeated
Bool RtcRepeated();

// start alarm from datetime structure (set entries to -1 to disable matching and enable repeating)
// - to deactivate, use RtcStopAlarm() function
void RtcAlarmStart(const sDateTime* dt, pRtcAlarm callback);

// stop alarm (deactivate callback)
void RtcAlarmStop();

// force alarm IRQ (must be cleared in IRQ handler)
INLINE void RtcAlarmForce() { *RTC_INTF = B0; }

#ifdef __cplusplus
}
#endif

#endif // _SDK_RTC_H

#endif // USE_RTC	// use RTC Real-time clock (sdk_rtc.c, sdk_rtc.h)
