;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

	; output value to the speaker
Start:	ld	a,2		; A <- output value: bit 1, flip output to the speaker

	; prepare length of tone (number of pulses)
Alarm1:	ld	b,0		; B <- length of the tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	ld	c,100		; delay of impulse

	; short delay to generate one impulse
Alarm3:	dec	c		; counting impulse delay
	jr	nz,Alarm3	; wait for end of impulse

	; output to speaker
	out	(9),a		; output to speaker, flip output to the speaker

	; count pulses
	djnz	Alarm2		; wait for a tone

	; delay before next tone
	ld	b,80		; delay length
Alarm4:	dec	c		; counting delay between tones
	jr	nz,Alarm4	; waiting between tones
	djnz	Alarm4

	; next tone
	jr	Alarm1		; repeat next tone

	end
