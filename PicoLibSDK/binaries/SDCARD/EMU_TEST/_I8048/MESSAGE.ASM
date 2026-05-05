; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

Start:
	; prepare address of text
	mov	r0,#Data	; R0 <- address of the text

	; prepare count of characters
	mov	r2,#20		; R2 <- count of characters

	; output character
Msg2:	mov	a,r0
	movp	a,@a		; load one character -> A
	outl	bus,a		; output character to the display

	; short delay = speed of generating characters
	mov	r4,#50
	mov	r3,#0
Msg3:	djnz	r3,Msg3
	djnz	r4,Msg3

	; next character
	inc	r0		; increment address of the text
	djnz	r2,Msg2		; loop

	; long delay - delay between messages
	mov	r4,#0
	mov	r3,#0
Msg4:	djnz	r3,Msg4		; loop
	djnz	r4,Msg4		; loop

	; repeat loop, output message again
	jmp	Start

Data:	db	'  Hello from I8048! '

	end
