#include "../include.h"

const u8 ALARM_Prog[] = {
	0x22, 0x70, 	// 000	Alarm1:	fim	R23,0x70	; R23 <- length of tone
	0x24, 0xE8, 	// 002	Alarm2:	fim	R45,0xE8	; R45 <- delay of impulse
	0x75, 0x04, 	// 004	Alarm3:	ijnz	R5,Alarm3	; increment R5 and repeat if not zero
	0x74, 0x04, 	// 006		ijnz	R4,Alarm3	; increment R4 and repeat if not zero
	0x20, 0x70, 	// 008		fim	R01,0x70	; R01 <- 0x70, output ROM port = 7
	0x21, 		// 00A		src	R01		; setup output ROM port = 7
	0xD2, 		// 00B		ldi	2		; load 2 into A
	0xE2, 		// 00C		wrr			; write A to ROM port
	0x73, 0x02, 	// 00D		ijnz	R3,Alarm2	; increment R3 and repeat with next pulse
	0x72, 0x02, 	// 00F		ijnz	R2,Alarm2	; increment R2 and repeat with next pulse
	0x73, 0x11, 	// 011	Alarm4:	ijnz	R3,Alarm4	; increment R3 and repeat if not zero
	0x72, 0x11, 	// 013		ijnz	R2,Alarm4	; increment R2 and repeat if not zero
	0x75, 0x11, 	// 015		ijnz	R5,Alarm4	; increment R5 and repeat if not zero
	0x40, 0x00, 	// 017		jmp	Alarm1
};

const int ALARM_ProgLen = 25;
