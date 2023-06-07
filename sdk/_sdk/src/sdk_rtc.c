
// ****************************************************************************
//
//                            RTC Real-time clock
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_RTC	// use RTC Real-time clock (sdk_rtc.c, sdk_rtc.h)

#include "../inc/sdk_rtc.h"
#include "../inc/sdk_irq.h"
#include "../inc/sdk_cpu.h"
#include "../inc/sdk_clocks.h"
#include "../inc/sdk_reset.h"

// current RTC alarm callback (NULL=none)
pRtcAlarm RtcAlarm = NULL;

// initialize RTC (not running yet - it will start after setting date and time RtcSetDateTime)
void RtcInit()
{
	// get clk_rtc frequency
	u32 freq = CurrentFreq[CLK_RTC];

	// reset RTC
	ResetPeriphery(BIT(RESET_RTC));

	// setup clock divider to get 1 Hz clock frequency
	*RTC_CLKDIV = freq - 1;
}

// set RTC clock from datetime structure
void RtcSetDateTime(const sDateTime* dt)
{
	// stop RTC
	*RTC_CTRL = 0; // clear enable bit

	// wait while RTC is still running
	while (RtcRunning()) { }

	// setup date and time
	*RTC_SETUP0 = ((u32)dt->year << 12) | ((u32)dt->mon << 8) | dt->day;
	*RTC_SETUP1 = ((u32)dt->dayofweek << 24) | ((u32)dt->hour << 16) | ((u32)dt->min << 8) | dt->sec;

	// load setup values into RTC
	*RTC_CTRL = B4;

	// start RTC
	*RTC_CTRL = B0;

	// wait for RTC to be running
	while (!RtcRunning()) {}
}

// get RTC to datetime structure
void RtcGetDateTime(sDateTime* dt)
{
	// read registers (RTC_0 must be read before RTC_1)
	u32 rtc0 = *RTC_0;
	cb(); // compiler barrier
	u32 rtc1 = *RTC_1;

	// get date and time
	dt->timelow = 0; // clear us and ms
	dt->dayofweek = (s8)((rtc0 >> 24) & 0x0f);
	dt->sec = (s8)(rtc0 & 0x3f);
	dt->min = (s8)((rtc0 >> 8) & 0x3f);
	dt->hour = (s8)((rtc0 >> 16) & 0x1f);
	dt->day = (s8)(rtc1 & 0x1f);
	dt->mon = (s8)((rtc1 >> 8) & 0xf);
	dt->year = (s16)((rtc1 >> 12) & 0xfff);
}

// enable RTC alarm
void RtcAlarmEnable()
{
	// set global match enable bit
	RegSet(RTC_IRQSET0, B28);

	// wait for it to start being active
	while ((*RTC_IRQSET0 & B29) == 0) {}
}

// disable RTC alarm
void RtcAlarmDisable()
{
	// clear force request
	*RTC_INTF = 0;

	// clear global match enable bit
	RegClr(RTC_IRQSET0, B28);

	// wait for it to stop being active
	while ((*RTC_IRQSET0 & B29) != 0) {}
}

// check datetime structure, if alarm will be repeated (some entry has value = -1)
Bool RtcDateTimeRepeated(const sDateTime* dt)
{
	return	(dt->sec < 0) ||
		(dt->min < 0) ||
		(dt->hour < 0) ||
		(dt->day < 0) ||
		(dt->mon < 0) ||
		(dt->year < 0);
}

// check if RTC alarm is repeated
Bool RtcRepeated()
{
	return ((*RTC_IRQSET0 & (B26|B25|B24)) != (B26|B25|B24)) ||
		((*RTC_IRQSET1 & (B30|B29|B28)) != (B30|B29|B28));
}

// alarm interrupt handler (default name isr_rtc)
static void RtcHandler()
{
	// disable alarm to clear current IRQ
	RtcAlarmDisable();

	// re-enable alarm, if repeated
	if (RtcRepeated()) RtcAlarmEnable();

	// callback user function
	if (RtcAlarm != NULL) RtcAlarm();
}

// start alarm from datetime structure (set entries to -1 to disable matching and enable repeating)
// - to deactivate, use RtcStopAlarm() function
void RtcAlarmStart(const sDateTime* dt, pRtcAlarm callback)
{
	// disable alarm
	RtcAlarmDisable();

	// setup alarm date and time
	u32 k = 0;
	if (dt->year >= 0) k = ((u32)dt->year << 12) | B26;
	if (dt->mon >= 0) k |= ((u32)dt->mon << 8) | B25;
	if (dt->day >= 0) k |= dt->day | B24;
	*RTC_IRQSET0 = k;

	k = 0;
	if (dt->dayofweek >= 0) k = ((u32)dt->dayofweek << 24) | B31;
	if (dt->hour >= 0) k |= ((u32)dt->hour << 16) | B30;
	if (dt->min >= 0) k |= ((u32)dt->min << 8) | B29;
	if (dt->sec >= 0) k |= dt->sec | B28;
	*RTC_IRQSET1 = k;

	// save callback	
	RtcAlarm = callback;

	// set IRQ handler
	SetHandler(IRQ_RTC, RtcHandler);

	// enable IRQ of RTC
	*RTC_INTE = B0;

	// enable IRQ of NVIC
	NVIC_IRQEnable(IRQ_RTC);

	// enable alarm
	RtcAlarmEnable();
}

// stop alarm (deactivate callback)
void RtcAlarmStop()
{
	// disable IRQ of NVIC
	NVIC_IRQDisable(IRQ_RTC);

	// disable IRQ of RTC
	*RTC_INTE = 0;

	// disable alarm
	RtcAlarmDisable();

	// clear callback
	RtcAlarm = NULL;
}

#endif // USE_RTC	// use RTC Real-time clock (sdk_rtc.c, sdk_rtc.h)
