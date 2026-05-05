; I8085, I8085A CPU speed: 3 MHz
; I8085-2, I8085A-2 CPU speed: 5 MHz
; I8085AH-1 CPU speed: 6 MHz

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	8085		; Intel 8085 CPU
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
	mvi	d,100
Msg3:	dcr	e
	jnz	Msg3
	dcr	d
	jnz	Msg3

	; next character
	dcr	b		; decrement loop counter
	jnz	Msg2		; loop if B not 0

	; long delay - delay between messages
	mvi	b,8
Msg4:	dcr	e		; decrement E
	jnz	Msg4		; loop
	dcr	d		; decrement D
	jnz	Msg4		; loop
	dcr	b		; decrement B
	jnz	Msg4		; loop

	; repeat loop, output message again
	jmp	Start

Data:	db	'  Hello from I8085! '

	end
