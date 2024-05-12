; X80 CPU speed: 4.194304 MHz (Machine Cycles 1.05 MHz)

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	LR35902		; Sharp X80 LR35902 CPU
	org	0		; start address of the code

	; input keys into A
Start:	ldh	a,(87h)		; A <- input from keys
	ldh	(8eh),a		; output to LEDs <- A
	jr	Start		; loop

	end
