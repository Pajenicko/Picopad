; I8008 CPU speed: 500 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 20 us
; I8008-1 CPU speed: 800 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 12.5 us

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	8008new		; Intel 8008 CPU with new mnemonics
	org	0		; start address of the code

hi	function x,(x>>8)&255	; get high byte
lo	function x,x&255	; get low byte

Start:
	; prepare address of text
	mvi	l,lo(Data)	; L <- data LOW
	mvi	h,hi(Data)	; H <- data HIGH

	; prepare count of characters
	mvi	b,20		; B <- count of characters

	; output text
Msg2:	mov	a,m		; load one character -> A
	out	10		; output character to the display
; Text data array is always at address < 256,
; register H will always be 0, so we can
; increment only register L.
	inr	l		; increment register L

	; short delay = speed of generating characters
	mvi	e,0
	mvi	d,10
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

Data:	db	'  Hello from I8008! '

	end
