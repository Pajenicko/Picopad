
// ****************************************************************************
//
//                               SysTick alarm
//
// ****************************************************************************
// Picoino SDK: Copyright (c) 2023 Miroslav Nemecek, Panda38@seznam.cz

#include "../../global.h"	// globals

#if USE_ALARM			// use SysTick alarm (lib_alarm.c, lib_alarm.h)

#include "../../_sdk/inc/sdk_systime.h" 	// systime
#include "../inc/lib_alarm.h"		// alarms

// list of system alarms (each processor core has its own list)
sList AlarmList[CORE_NUM];

// register alarm (caller must unregister alarm after waking up if it is no longer needed)
// - Callback will be called under the same core from which the alarm was registered.
// - Registered alarm structure must remain valid until the alarm is unregistered.
void AlarmReg(sAlarm* alarm)
{
	// get current core
	int core = CpuID();

// No need to lock with spinlock, lists for CPU cores are separate

	// disable interrupts
	IRQ_LOCK;

	// add alarm to the list
	ListAddLast(&AlarmList[core], &alarm->list);

	// enable interrupts
	IRQ_UNLOCK;
}

// unregister alarm (need to be done after waking up if alarm is no longer needed)
// - Must be called from the same CPU core as it was registered.
void AlarmUnreg(sAlarm* alarm)
{
	// disable interrupts
	IRQ_LOCK;

	// remove entry from the alarm list
	ListEntryRemove(&alarm->list);

	// enable interrupts
	IRQ_UNLOCK;
}

// update alarms for this CPU core (caled from SysTick_Handler every SYSTICK_MS ms with IRQ locked)
void AlarmUpdate()
{
	// get current core
	int core = CpuID();

	// pointer to head of current list
	sList* head = &AlarmList[core];

	// find alarm with current time
	sListEntry* entry; // pointer to current entry
	sListEntry* next; // temporary pointer to next entry
	sAlarm* a; // alarm entry from the list entry
	sList* head2; // 

	// safe walking through alarms, entry can be deleted from the callback
	u32 systime = SysTime; // get current system time
	LISTFOREACHSAFE(entry, next, head)
	{
		// get alarm entry from the list entry
		//  parameters: pointer to list entry, type of alarm structure, name of list entry in alarm structure
		a = BASEFROMLIST(entry, sAlarm, list);

		// check if alarm is elapsed (tolerance some time into past, for case it was registered too late)
		if ((u32)(systime - a->time) <= 3*SYSTICK_MS)
		{
			// prepare next time
			a->time += a->delta;

			// callback
			a->callback(a);
		}
	}
}

// Initialize alarm lists for both cores
void AlarmInit()
{
	int i;
	for (i = 0; i < CORE_NUM; i++) ListInit(&AlarmList[i]);
}

#endif // USE_ALARM			// use SysTick alarm (lib_alarm.c, lib_alarm.h)
