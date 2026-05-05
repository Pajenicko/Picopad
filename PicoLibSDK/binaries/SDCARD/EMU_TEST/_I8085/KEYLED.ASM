; I8085, I8085A CPU speed: 3 MHz
; I8085-2, I8085A-2 CPU speed: 5 MHz
; I8085AH-1 CPU speed: 6 MHz

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	8085		; Intel 8085 CPU
	org	0		; start address of the code

	; input keys into A
Start:	in	7		; A <- input from keys
	out	14		; output to LEDs <- A
	jmp	Start		; loop

	end
