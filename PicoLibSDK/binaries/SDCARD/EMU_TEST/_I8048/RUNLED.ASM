; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Running LED

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

Start:
	; prepare register to new run
	mov	r2,#1		; R2 <- bit 0, bit mask of output to LED 0

	; output to LEDs
Run2:	mov	a,r2		; A <- output to LED
	outl	p1,a		; output to LED
	rl	a		; shift bit mask left
	mov	r2,a		; R2 <- save new bit mask of output to LED

	; delay before next step
	mov	r4,#100
Run3:	djnz	r3,Run3
	djnz	r4,Run3

	; next step
	jmp	Run2

	end
