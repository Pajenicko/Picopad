; X80 CPU speed: 4.194304 MHz (Machine Cycles 1.05 MHz)

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	LR35902		; Sharp X80 LR35902 CPU
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
	ldh	(89h),a		; output to speaker, flip output to the speaker

	; count pulses
	dec	b
	jr	nz,Alarm2	; wait for a tone

	; delay before next tone
	ld	b,80		; delay length
Alarm4:	dec	c		; counting delay between tones
	jr	nz,Alarm4	; waiting between tones
	dec	b
	jr	nz,Alarm4

	; next tone
	jr	Alarm1		; repeat next tone

	end
