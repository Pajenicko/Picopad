;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

Start:
	; prepare address of text -> HL
	ld	hl,Data

	; prepare count of characters
	ld	b,20		; B <- count of characters

	; output text
Msg2:	ld	a,(hl)		; load one character -> A
	out	(10),a		; output character to the display
	inc	hl		; increment register pair HL

	; short delay = speed of generating characters
	ld	d,50
Msg3:	dec	e
	jr	nz,Msg3
	dec	d
	jr	nz,Msg3

	; next character
	djnz	Msg2		; decrement B and loop if B not 0

	; long delay - delay between messages
	ld	d,7
Msg4:	djnz	Msg4		; loop B
	dec	e		; decrement E
	jr	nz,Msg4		; loop
	dec	d		; decrement D
	jr	nz,Msg4		; loop

	; repeat loop, output message again
	jp	Start

Data:	db	'   Hello from Z80!  '

	end
