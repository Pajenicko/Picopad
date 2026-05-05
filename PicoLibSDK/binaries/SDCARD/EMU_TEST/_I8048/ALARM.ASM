; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

Start:	
	; prepare length of tone (number of pulses)
Alarm1:	mov	r3,#100		; R2 <- length of the tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	mov	r2,#180		; delay of impulse

	; short delay to generate one impulse
Alarm3:	djnz	r2,Alarm3	; wait for end of impulse

	; output to speaker
	mov	a,#0
	outl	p2,a
	mov	a,#40h		; bit 6: 0->1 flip output to speaker
	outl	p2,a		; output to speaker, flip output to the speaker

	; count pulses
	djnz	r3,Alarm2	; wait for a tone

	; delay before next tone
	mov	r3,#100
Alarm4:	djnz	r2,Alarm4
	djnz	r3,Alarm4	; waiting between tones

	; next tone
	jmp	Alarm1		; repeat next tone

	end
