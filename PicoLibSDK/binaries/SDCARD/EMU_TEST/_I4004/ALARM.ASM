; I4004 CPU speed: 740 kHz, clock period 1.35 us
; 1-word instruction 8 clock periods = 10.8 us
; 2-word instructon 16 clock periods = 21.6 us

; Sample: Alarm sound

	.strict			; strict mode (requires register names, not register numbers)

Reset:	
	; prepare length of tone (number of pulses)
Alarm1:	fim	R23,0x70	; R23 <- length of tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	fim	R45,0xE8	; R45 <- delay of impulse

	; short delay to generate one impulse
Alarm3:	ijnz	R5,Alarm3	; increment R5 and repeat if not zero
	ijnz	R4,Alarm3	; increment R4 and repeat if not zero

	; output to speaker
	fim	R01,0x70	; R01 <- 0x70, output ROM port = 7
	src	R01		; setup output ROM port = 7
	ldi	2		; load 2 into A
	wrr			; write A to ROM port

	; count pulses
	ijnz	R3,Alarm2	; increment R3 and repeat with next pulse
	ijnz	R2,Alarm2	; increment R2 and repeat with next pulse

	; delay before next tone (here is R23 = 0 and R5 = 0)
Alarm4:	ijnz	R3,Alarm4	; increment R3 and repeat if not zero
	ijnz	R2,Alarm4	; increment R2 and repeat if not zero
	ijnz	R5,Alarm4	; increment R5 and repeat if not zero

	; next tone
	jmp	Alarm1
