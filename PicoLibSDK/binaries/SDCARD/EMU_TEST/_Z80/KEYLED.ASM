;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

	; input keys into A
Start:	in	a,(7)		; A <- input from keys
	out	(14),a		; output to LEDs <- A
	jp	Start		; loop

	end
