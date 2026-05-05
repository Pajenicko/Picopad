#include "../include.h"

const u8 MESSAGE_Prog[] = {
	0x20, 0x2D, 	// 000		fim	R01,@MsgData	; R0R1 <- pointer to message data
	0x32, 		// 002	Msg2:	fin	R23		; R2R3 <- load one character (R2=high part, R3=low part)
	0x71, 0x06, 	// 003		ijnz	R1,Msg4		; increment register R1, skip if not zero (low part of message pointer)
	0x60, 		// 005		inc	R0		; increment register R0 (high part of message pointer)
	0xA2, 		// 006	Msg4:	ld	R2		; A <- R2, character high part
	0x1C, 0x17, 	// 007		jnz	Msg6		; not 0, valid character, continue
	0x24, 0x00, 	// 009		fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	0x26, 0x00, 	// 00B		fim	R67,0x00	; R7 <- outer loop counter, R6 <- max outer loop counter
	0x75, 0x0D, 	// 00D	Msg5:	ijnz	R5,Msg5		; increment R5, count inner loop
	0x74, 0x0D, 	// 00F		ijnz	R4,Msg5		; increment R4, count outer loop
	0x77, 0x0D, 	// 011		ijnz	R7,Msg5		; increment R7, count outer loop
	0x76, 0x0D, 	// 013		ijnz	R6,Msg5		; increment R6, count max outer loop
	0x14, 0x00, 	// 015		jz	Reset		; reset text
	0x24, 0x90, 	// 017	Msg6:	fim	R45,0x90	; R45 <- 0x90, output ROM port = 9
	0x25, 		// 019		src	R45		; setup output ROM port = 9
	0xA2, 		// 01A		ld	R2		; A <- R2, character high part
	0xE2, 		// 01B		wrr			; write A to ROM port
	0x24, 0x80, 	// 01C		fim	R45,0x80	; R45 <- 0x80, output ROM port = 8
	0x25, 		// 01E		src	R45		; setup output ROM port = 8
	0xA3, 		// 01F		ld	R3		; A <- R3, character low part
	0xE2, 		// 020		wrr			; write A to ROM port
	0x24, 0x00, 	// 021		fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	0x26, 0x00, 	// 023		fim	R67,0x00	; R7 <- outer loop counter
	0x75, 0x25, 	// 025	Msg8:	ijnz	R5,Msg8		; increment R5, count inner loop
	0x74, 0x25, 	// 027		ijnz	R4,Msg8		; increment R4, count outer loop
	0x77, 0x25, 	// 029		ijnz	R7,Msg8		; increment R7, count outer loop
	0x40, 0x02, 	// 02B		jmp	Msg2		; continue to next cahracter
	0x20, 		// 02D	= ' '
	0x20, 		// 02E	= ' '
	0x48, 		// 02F	= 'H'
	0x65, 		// 030	= 'e'
	0x6C, 		// 031	= 'l'
	0x6C, 		// 032	= 'l'
	0x6F, 		// 033	= 'o'
	0x20, 		// 034	= ' '
	0x66, 		// 035	= 'f'
	0x72, 		// 036	= 'r'
	0x6F, 		// 037	= 'o'
	0x6D, 		// 038	= 'm'
	0x20, 		// 039	= ' '
	0x49, 		// 03A	= 'I'
	0x34, 		// 03B	= '4'
	0x30, 		// 03C	= '0'
	0x34, 		// 03D	= '4'
	0x30, 		// 03E	= '0'
	0x21, 		// 03F	= '!'
	0x20, 		// 040	= ' '
	0x00, 		// 041	= 0		; flag - end of text
};

const int MESSAGE_ProgLen = 66;
