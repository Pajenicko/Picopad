; I8080 CPU speed: 2 MHz (instructions 4, 5, 7, 10 or 11 clock cycles)
; I808A-1 CPU speed: 3.125 MHz

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	8080		; Intel 8080 CPU
	org	0		; start address of the code

Start:
	; prepare address of text -> HL
	lxi	h,Data

	; prepare count of characters
	mvi	b,20		; B <- count of characters

	; output text
Msg2:	mov	a,m		; load one character -> A
	out	10		; output character to the display
	inx	h		; increment register pair HL

	; short delay = speed of generating characters
	mvi	d,50
Msg3:	dcr	e
	jnz	Msg3
	dcr	d
	jnz	Msg3

	; next character
	dcr	b		; decrement loop counter
	jnz	Msg2		; loop if B not 0

	; long delay - delay between messages
Msg4:	dcr	e		; decrement B
	jnz	Msg4		; loop
	dcr	d		; decrement C
	jnz	Msg4		; loop

	; repeat loop, output message again
	jmp	Start

Data:	db	'  Hello from I8080! '

	end
