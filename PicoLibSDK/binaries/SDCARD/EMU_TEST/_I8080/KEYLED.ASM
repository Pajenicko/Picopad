; I8080 CPU speed: 2 MHz (instructions 4, 5, 7, 10 or 11 clock cycles)
; I808A-1 CPU speed: 3.125 MHz

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	8080		; Intel 8080 CPU
	org	0		; start address of the code

	; input keys into A
Start:	in	7		; A <- input from keys
	out	14		; output to LEDs <- A
	jmp	Start		; loop

	end
