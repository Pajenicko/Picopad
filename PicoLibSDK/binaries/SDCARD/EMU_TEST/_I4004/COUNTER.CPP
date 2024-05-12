#include "../include.h"

const u8 COUNTER_Prog[] = {
	0xF0, 		// 000		clb			; clear A and carry
	0x20, 0x00, 	// 001		fim	R01,0x00	; R01 <- 0x00, RAM address 0
	0x21, 		// 003	Count1:	src	R01		; setup RAM address
	0xE0, 		// 004		wrm			; write A into RAM memory
	0x71, 0x03, 	// 005		ijnz	R1,Count1	; increment R1 and loop to next digit
	0x20, 0x00, 	// 007	Count2:	fim	R01,0x00	; R01 <- 0x00, RAM address 0
	0xFA, 		// 009		stc			; set carry flag
	0x21, 		// 00A	Count3:	src	R01		; setup RAM address
	0xD0, 		// 00B		ldi	0		; load 0 to A
	0xEB, 		// 00C		adm			; add RAM and carry to A (= increment memory if carry was set)
	0xFB, 		// 00D		daa			; decimal adjust: add 6 if A > 9 and set carry
	0xE0, 		// 00E		wrm			; write A into RAM memory
	0x71, 0x0A, 	// 00F		ijnz	R1,Count3	; increment R1 and loop to next digit
	0x20, 0x09, 	// 011		fim	R01,0x09	; R01 <- 0x00, RAM address 9
	0x21, 		// 013	Count4:	src	R01		; setup RAM address
	0xE9, 		// 014		rdm			; read A from RAM memory
	0x22, 0xC0, 	// 015		fim	R23,0xC0	; R23 <- 0xC0, output ROM port = 12
	0x23, 		// 017		src	R23		; setup output ROM port = 12
	0xE2, 		// 018		wrr			; write A to ROM port
	0xA1, 		// 019		ld	R1		; load register R1 to A
	0xF8, 		// 01A		dac			; decrement A
	0xB1, 		// 01B		xch	R1		; write A to register R1
	0x12, 0x13, 	// 01C		jc	Count4		; loop of not borrow
	0x22, 0xB0, 	// 01E		fim	R23,0xB0	; R23 <- 0xB0, output ROM port = 11
	0x23, 		// 020		src	R23		; setup output ROM port = 11
	0xE2, 		// 021		wrr			; write A to ROM port
	0x40, 0x07, 	// 022		jmp	Count2		; next number
};

const int COUNTER_ProgLen = 36;
