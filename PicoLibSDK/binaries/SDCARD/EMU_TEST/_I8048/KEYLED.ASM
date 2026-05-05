; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

	; input keys into A
Start:	ins	a,bus		; A <- input from keys
	outl	p1,a		; output to LEDs <- A
	jmp	Start		; loop

	end
