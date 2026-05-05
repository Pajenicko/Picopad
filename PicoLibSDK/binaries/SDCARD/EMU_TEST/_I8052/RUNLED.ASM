; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Running LED

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3

Start:
	; prepare register to new run
	mov	r2,#1		; R2 <- bit 0, bit mask of output to LED 0

	; output to LEDs
Run2:	mov	a,r2		; A <- output to LED
	mov	p2,a		; output to LED
	rl	a		; shift bit mask left
	mov	r2,a		; R2 <- save new bit mask of output to LED

	; delay before next step
	mov	r4,#200
Run3:	djnz	r3,Run3
	djnz	r4,Run3

	; next step
	jmp	Run2

	end
