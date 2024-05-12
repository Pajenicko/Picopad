; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Alarm sound

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3

Start:	
	; prepare length of tone (number of pulses)
Alarm1:	mov	r3,#100		; R2 <- length of the tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	mov	r2,#180		; delay of impulse

	; short delay to generate one impulse
Alarm3:	djnz	r2,Alarm3	; wait for end of impulse

	; output to speaker
	mov	a,#0
	mov	p3,a
	mov	a,#40h		; bit 6: 0->1 flip output to speaker
	mov	p3,a		; output to speaker, flip output to the speaker

	; count pulses
	djnz	r3,Alarm2	; wait for a tone

	; delay before next tone
	mov	r3,#100
Alarm4:	djnz	r2,Alarm4
	djnz	r3,Alarm4	; waiting between tones

	; next tone
	jmp	Alarm1		; repeat next tone

	end
