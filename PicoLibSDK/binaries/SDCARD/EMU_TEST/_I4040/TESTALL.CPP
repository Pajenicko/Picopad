#include "../include.h"

const u8 TESTALL_Prog[] = {
	0xF0, 		// 000		clb			; clear A and carry
	0x20, 0x00, 	// 001		fim	R01,0x00	; R01 <- 0x00, RAM address 0
	0x21, 		// 003	Count1:	src	R01		; setup RAM address
	0xE0, 		// 004		wrm			; write A into RAM memory
	0x71, 0x03, 	// 005		ijnz	R1,Count1	; increment R1 and loop to next digit
	0x20, 0x26, 	// 007		fim	R01,@MsgData	; R0R1 <- pointer to message data
	0x32, 		// 009	Msg2:	fin	R23		; R2R3 <- load one character (R2=high part, R3=low part)
	0x71, 0x0D, 	// 00A		ijnz	R1,Msg4		; increment register R1, skip if not zero (low part of message pointer)
	0x60, 		// 00C		inc	R0		; increment register R0 (high part of message pointer)
	0xA2, 		// 00D	Msg4:	ld	R2		; A <- R2, character high part
	0x14, 0x3B, 	// 00E		jz	MainLoop	; end mark 0, continue to next test
	0x24, 0x90, 	// 010		fim	R45,0x90	; R45 <- 0x90, output ROM port = 9
	0x25, 		// 012		src	R45		; setup output ROM port = 9
	0xA2, 		// 013		ld	R2		; A <- R2, character high part
	0xE2, 		// 014		wrr			; write A to ROM port
	0x24, 0x80, 	// 015		fim	R45,0x80	; R45 <- 0x80, output ROM port = 8
	0x25, 		// 017		src	R45		; setup output ROM port = 8
	0xA3, 		// 018		ld	R3		; A <- R3, character low part
	0xE2, 		// 019		wrr			; write A to ROM port
	0x24, 0x00, 	// 01A		fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	0x26, 0x00, 	// 01C		fim	R67,0x00	; R7 <- outer loop counter
	0x75, 0x1E, 	// 01E	Msg8:	ijnz	R5,Msg8		; increment R5, count inner loop
	0x74, 0x1E, 	// 020		ijnz	R4,Msg8		; increment R4, count outer loop
	0x77, 0x1E, 	// 022		ijnz	R7,Msg8		; increment R7, count outer loop
	0x40, 0x09, 	// 024		jmp	Msg2		; continue to next cahracter
	0x20, 		// 026	= ' '
	0x20, 		// 027	= ' '
	0x48, 		// 028	= 'H'
	0x65, 		// 029	= 'e'
	0x6C, 		// 02A	= 'l'
	0x6C, 		// 02B	= 'l'
	0x6F, 		// 02C	= 'o'
	0x20, 		// 02D	= ' '
	0x66, 		// 02E	= 'f'
	0x72, 		// 02F	= 'r'
	0x6F, 		// 030	= 'o'
	0x6D, 		// 031	= 'm'
	0x20, 		// 032	= ' '
	0x49, 		// 033	= 'I'
	0x34, 		// 034	= '4'
	0x30, 		// 035	= '0'
	0x34, 		// 036	= '4'
	0x30, 		// 037	= '0'
	0x21, 		// 038	= '!'
	0x20, 		// 039	= ' '
	0x00, 		// 03A	= 0		; flag - end of text
	0x28, 0x47, 	// 03B		fim	R89,0x47	; R89 <- initialize main time counter
	0x20, 0x00, 	// 03D	Count2:	fim	R01,0x00	; R01 <- 0x00, RAM address 0
	0xFA, 		// 03F		stc			; set carry flag
	0x21, 		// 040	Count3:	src	R01		; setup RAM address
	0xD0, 		// 041		ldi	0		; load 0 to A
	0xEB, 		// 042		adm			; add RAM and carry to A (= increment memory if carry was set)
	0xFB, 		// 043		daa			; decimal adjust: add 6 if A > 9 and set carry
	0xE0, 		// 044		wrm			; write A into RAM memory
	0x71, 0x40, 	// 045		ijnz	R1,Count3	; increment R1 and loop to next digit
	0x20, 0x09, 	// 047		fim	R01,0x09	; R01 <- 0x00, RAM address 9
	0x21, 		// 049	Count4:	src	R01		; setup RAM address
	0xE9, 		// 04A		rdm			; read A from RAM memory
	0x22, 0xC0, 	// 04B		fim	R23,0xC0	; R23 <- 0xC0, output ROM port = 12
	0x23, 		// 04D		src	R23		; setup output ROM port = 12
	0xE2, 		// 04E		wrr			; write A to ROM port
	0xA1, 		// 04F		ld	R1		; load register R1 to A
	0xF8, 		// 050		dac			; decrement A
	0xB1, 		// 051		xch	R1		; write A to register R1
	0x12, 0x49, 	// 052		jc	Count4		; loop of not borrow
	0x22, 0xB0, 	// 054		fim	R23,0xB0	; R23 <- 0xB0, output ROM port = 11
	0x23, 		// 056		src	R23		; setup output ROM port = 11
	0xE2, 		// 057		wrr			; write A to ROM port
	0x20, 0x60, 	// 058		fim	R01,0x60	; R01 <- 0x60, input ROM port = 6
	0x21, 		// 05A		src	R01		; setup input ROM port = 6
	0xEA, 		// 05B		rdr			; read ROM port to A
	0x20, 0xE0, 	// 05C		fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	0x21, 		// 05E		src	R01		; setup output ROM port = 14
	0xE2, 		// 05F		wrr			; write A to ROM port
	0x20, 0x50, 	// 060		fim	R01,0x50	; R01 <- 0x50, input ROM port = 5
	0x21, 		// 062		src	R01		; setup input ROM port = 5
	0xEA, 		// 063		rdr			; read ROM port to A
	0x20, 0xD0, 	// 064		fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	0x21, 		// 066		src	R01		; setup output ROM port = 13
	0xE2, 		// 067		wrr			; write A to ROM port
	0x79, 0x3D, 	// 068		ijnz	R9,MainLoop2
	0x78, 0x3D, 	// 06A		ijnz	R8,MainLoop2
	0x20, 0xBA, 	// 06C		fim	R01,0xBA
	0x71, 0x6E, 	// 06E	Blink2:	ijnz	R1,Blink2
	0x70, 0x6E, 	// 070		ijnz	R0,Blink2
	0x20, 0xF0, 	// 072		fim	R01,0xF0	; R01 <- 0xF0, output ROM port = 15
	0x21, 		// 074		src	R01		; setup output ROM port = 15
	0xD2, 		// 075		ldi	2		; A <- bit 1
	0xE2, 		// 076		wrr			; write A to ROM port
	0x40, 0x3B, 	// 077		jmp	MainLoop	; jump to main loop
};

const int TESTALL_ProgLen = 121;
