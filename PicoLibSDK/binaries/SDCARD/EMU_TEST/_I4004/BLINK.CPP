#include "../include.h"

const u8 BLINK_Prog[] = {
	0x20, 0xF0, 	// 000	Reset:	fim	R01,0xF0	; R01 <- 0xF0, output ROM port = 15
	0x21, 		// 002		src	R01		; setup output ROM port = 15
	0xD2, 		// 003		ldm	2		; A <- bit 1
	0x20, 0x55, 	// 004	Loop1:	fim	R01,0x55	; [16] set registers R0<-5, R1<-5
	0x22, 0xBA, 	// 006		fim	R23,0xBA	; [16] set registers R2<-11, R3<-10
	0x70, 0x08, 	// 008	Loop2:	ijnz	R0,Loop2	; increment R0 and loop if not zero ... 16*16 = 256 clock cycles, first run (16-5)*16 = 176
	0x71, 0x08, 	// 00A		ijnz	R1,Loop2	; increment R1 and loop if not zero ... (256+16)*16 = 4352 clock cycles, first run 176 + 16 + (16-5-1)*272 = 2912
	0x72, 0x08, 	// 00C		ijnz	R2,Loop2	; increment R2 and loop if not zero ... (4352+16)*16 = 69888 clock cycles, first run 2912 + 16 + (16-11-1)*4368 = 20400
	0x73, 0x08, 	// 00E		ijnz	R3,Loop2	; increment R3 and loop if not zero ... run 20400 + 16 + (16-10-1)*69904 = 369936
	0x00, 		// 010		nop			; [8] timings
	0xE2, 		// 011		wrr			; [8] write A to ROM port
	0x40, 0x04, 	// 012		jmp	Loop1		; [16] jump to main loop
};

const int BLINK_ProgLen = 20;
