; I8080 CPU speed: 2 MHz (instructions 4, 5, 7, 10 or 11 clock cycles)
; I808A-1 CPU speed: 3.125 MHz

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	8080		; Intel 8080 CPU
	org	0		; start address of the code

	; output value to the speaker
Start:	mvi	a,2		; A <- output value: bit 1, flip output to the speaker

	; prepare length of tone (number of pulses)
Alarm1:	mvi	b,0		; B <- length of the tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	mvi	c,50		; delay of impulse

	; short delay to generate one impulse
Alarm3:	dcr	c		; counting impulse delay
	jnz	Alarm3		; wait for end of impulse

	; output to speaker
	out	9		; output to speaker, flip output to the speaker

	; count pulses
	dcr	b		; count pulses of one tone
	jnz	Alarm2		; wait for a tone

	; delay before next tone
	mvi	b,50		; delay length
Alarm4:	dcr	c		; counting delay between tones
	jnz	Alarm4		; waiting between tones
	dcr	b		; outer loop
	jnz	Alarm4

	; next tone
	jmp	Alarm1		; repeat next tone

	end
