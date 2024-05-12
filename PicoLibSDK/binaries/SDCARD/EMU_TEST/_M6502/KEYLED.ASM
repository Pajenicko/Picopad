; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Copy keys to LEDs

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

	; input keys into A
Start:	lda	$ef07		; A <- input from keys
	sta	$ef0e		; output to LEDs <- A
	jmp	Start		; loop

	end
