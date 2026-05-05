; I8008 CPU speed: 500 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 20 us
; I8008-1 CPU speed: 800 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 12.5 us

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	8008new		; Intel 8008 CPU with new mnemonics
	org	0		; start address of the code

	; input keys into A
Start:	in	7		; A <- input from keys
	out	14		; output to LEDs <- A
	jmp	Start		; loop

	end
