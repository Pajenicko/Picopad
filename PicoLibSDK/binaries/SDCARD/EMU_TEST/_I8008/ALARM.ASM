; I8008 CPU speed: 500 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 20 us
; I8008-1 CPU speed: 800 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 12.5 us

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	8008new		; Intel 8008 CPU with new mnemonics
	org	0		; start address of the code

	; output value to the speaker
Start:	mvi	a,2		; A <- output value: bit 1, flip output to the speaker

	; prepare length of tone (number of pulses)
Alarm1:	mvi	b,0		; B <- length of the tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	mvi	c,8		; delay of impulse

	; short delay to generate one impulse
Alarm3:	dcr	c		; counting impulse delay
	jnz	Alarm3		; wait for end of impulse

	; output to speaker
	out	9		; output to speaker, flip output to the speaker

	; count pulses
	dcr	b		; count pulses of one tone
	jnz	Alarm2		; wait for a tone

	; delay before next tone
Alarm4:	dcr	c		; counting delay between tones
	nop			; yet some delay
	jnz	Alarm4		; waiting between tones

	; next tone
	jmp	Alarm1		; repeat next tone

	end
