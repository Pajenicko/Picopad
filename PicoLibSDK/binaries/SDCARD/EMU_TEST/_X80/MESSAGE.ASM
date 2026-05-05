; X80 CPU speed: 4.194304 MHz (Machine Cycles 1.05 MHz)

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	LR35902		; Sharp X80 LR35902 CPU
	org	0		; start address of the code

Start:
	; prepare address of text -> HL
	ld	hl,Data

	; prepare count of characters
	ld	b,20		; B <- count of characters

	; output text
Msg2:	ld	a,(hl)		; load one character -> A
	ldh	(8ah),a		; output character to the display
	inc	hl		; increment register pair HL

	; short delay = speed of generating characters
	ld	d,50
Msg3:	dec	e
	jr	nz,Msg3
	dec	d
	jr	nz,Msg3

	; next character
	dec	b
	jr	nz,Msg2		; decrement B and loop if B not 0

	; long delay - delay between messages
	ld	d,7
Msg4:	dec	b
	jr	nz,Msg4		; loop B
	dec	e		; decrement E
	jr	nz,Msg4		; loop
	dec	d		; decrement D
	jr	nz,Msg4		; loop

	; repeat loop, output message again
	jr	Start

Data:	db	'   Hello from X80!  '

	end
