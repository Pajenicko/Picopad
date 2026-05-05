; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3

	; input keys into A
Start:	mov	a,p0		; A <- input from keys
	mov	p2,a		; output to LEDs <- A
	jmp	Start		; loop

	end
