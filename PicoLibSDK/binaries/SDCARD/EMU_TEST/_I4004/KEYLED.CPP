#include "../include.h"

const u8 KEYLED_Prog[] = {
	0x20, 0x60, 	// 000		fim	R01,0x60	; R01 <- 0x60, input ROM port = 6
	0x21, 		// 002		src	R01		; setup input ROM port = 6
	0xEA, 		// 003		rdr			; read ROM port to A
	0x20, 0xE0, 	// 004		fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	0x21, 		// 006		src	R01		; setup output ROM port = 14
	0xE2, 		// 007		wrr			; write A to ROM port
	0x20, 0x50, 	// 008		fim	R01,0x50	; R01 <- 0x50, input ROM port = 5
	0x21, 		// 00A		src	R01		; setup input ROM port = 5
	0xEA, 		// 00B		rdr			; read ROM port to A
	0x20, 0xD0, 	// 00C		fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	0x21, 		// 00E		src	R01		; setup output ROM port = 13
	0xE2, 		// 00F		wrr			; write A to ROM port
	0x40, 0x00, 	// 010		jmp	Reset		; jump to main loop
};

const int KEYLED_ProgLen = 18;
