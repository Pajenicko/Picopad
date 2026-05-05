#include "../include.h"

const u8 RUNLED_Prog[] = {
	0x22, 0x11, 	// 000		fim	R23,0x11	; R2 <- 1 bit mask of LED 0, R3 <- 1 decimal point position 1
	0x24, 0x00, 	// 002		fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	0x26, 0x00, 	// 004		fim	R67,0x00	; R7 <- outer loop counter
	0x75, 0x06, 	// 006	Loop3:	ijnz	R5,Loop3	; increment R5, count inner loop
	0x74, 0x06, 	// 008		ijnz	R4,Loop3	; increment R4, count middle loop
	0x77, 0x06, 	// 00A		ijnz	R7,Loop3	; increment R7, count outer loop
	0x20, 0xA0, 	// 00C		fim	R01,0xA0	; R01 <- 0xA0, output ROM port = 10
	0x21, 		// 00E		src	R01		; setup output ROM port = 10
	0xA3, 		// 00F		ld	R3		; A <- R3, decimal point position
	0xE2, 		// 010		wrr			; write A to ROM port
	0x63, 		// 011		inc	R3		; increment decimal point position
	0x20, 0xE0, 	// 012		fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	0x21, 		// 014		src	R01		; setup output ROM port = 14
	0xF0, 		// 015		clb			; clear A nad carry
	0xE2, 		// 016		wrr			; write A to ROM port
	0x20, 0xD0, 	// 017		fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	0x21, 		// 019		src	R01		; setup output ROM port = 13
	0xB2, 		// 01A		xch	R2		; A <- R2, bit mask of LEDs LOW
	0xE2, 		// 01B		wrr			; write A to ROM port
	0xF1, 		// 01C		clc			; clear carry
	0xF5, 		// 01D		ral			; shift A left through carry
	0xB2, 		// 01E		xch	R2		; R2 <- new bit mask of LEDs LOW
	0x1A, 0x02, 	// 01F		jnc	Loop2		; repeat low 4 bits
	0x22, 0x15, 	// 021		fim	R23,0x15	; R2 <- 1 bit mask of LED 4, R3 <- 5 decimal point position 5
	0x24, 0x00, 	// 023		fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	0x26, 0x00, 	// 025		fim	R67,0x00	; R7 <- outer loop counter
	0x75, 0x27, 	// 027	Loop5:	ijnz	R5,Loop5	; increment R5, count inner loop
	0x74, 0x27, 	// 029		ijnz	R4,Loop5	; increment R4, count outer loop
	0x77, 0x27, 	// 02B		ijnz	R7,Loop5	; increment R7, count outer loop
	0x20, 0xA0, 	// 02D		fim	R01,0xA0	; R01 <- 0xA0, output ROM port = 10
	0x21, 		// 02F		src	R01		; setup output ROM port = 10
	0xA3, 		// 030		ld	R3		; A <- R3, decimal point position
	0xE2, 		// 031		wrr			; write A to ROM port
	0x63, 		// 032		inc	R3		; increment decimal point position
	0x20, 0xD0, 	// 033		fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	0x21, 		// 035		src	R01		; setup output ROM port = 13
	0xF0, 		// 036		clb			; clear A nad carry
	0xE2, 		// 037		wrr			; write A to ROM port
	0x20, 0xE0, 	// 038		fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	0x21, 		// 03A		src	R01		; setup output ROM port = 14
	0xB2, 		// 03B		xch	R2		; A <- R2, bit mask of LEDs HIGH
	0xE2, 		// 03C		wrr			; write A to ROM port
	0xF1, 		// 03D		clc			; clear carry
	0xF5, 		// 03E		ral			; shift A left through carry
	0xB2, 		// 03F		xch	R2		; R2 <- new bit mask of LEDs HIGH
	0x1A, 0x23, 	// 040		jnc	Loop4		; repeat low 4 bits
	0x40, 0x00, 	// 042		jmp	Reset
};

const int RUNLED_ProgLen = 68;
