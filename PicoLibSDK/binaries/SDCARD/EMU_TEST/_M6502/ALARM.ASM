; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

; 0x0000: counter, length of tone
; 0x0001: counter, delay of impulse

Start:	
	; prepare length of tone (number of pulses)
Alarm1:	lda	#100		; length of the tone
	sta	0

	; prepare frequency of the tone (delay of pulses)
Alarm2:	lda	#180		; delay of impulse
	sta	1

	; short delay to generate one impulse
Alarm3:	dec	1		; counter of one impulse
	bne	Alarm3		; wait for end of impulse

	; output to speaker
	lda	#2		; bit 1: flip output to speaker
	sta	$EF09		; output to speaker, flip output to the speaker

	; count pulses
	dec	0
	bne	Alarm2		; wait for a tone

	; delay before next tone
	lda	#100
	sta	1
Alarm4:	dec	0
	bne	Alarm4
	dec	1
	bne	Alarm4		; waiting between tones

	; next tone
	jmp	Alarm1		; repeat next tone

	end
