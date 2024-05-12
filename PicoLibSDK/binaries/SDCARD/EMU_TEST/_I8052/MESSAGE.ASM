; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3

Start:
	; prepare address of text
	mov	r0,#Data	; R0 <- address of the text

	; prepare count of characters
	mov	r2,#20		; R2 <- count of characters

	; output character (DPTR is initialized to 0 on reset)
Msg2:	mov	a,r0
	movc	a,@a+dptr	; load one character -> A
	mov	p1,a		; set bit 7 to low
	orl	a,#80h
	mov	p1,a		; set bit 7 to high - output character to the display

	; short delay = speed of generating characters
	mov	r4,#100
	mov	r3,#0
Msg3:	djnz	r3,Msg3
	djnz	r4,Msg3

	; next character
	inc	r0		; increment address of the text
	djnz	r2,Msg2		; loop

	; long delay - delay between messages
	mov	r4,#10
	mov	r3,#0
	mov	r2,#0
Msg4:	djnz	r2,Msg4		; loop
	djnz	r3,Msg4		; loop
	djnz	r4,Msg4		; loop

	; repeat loop, output message again
	jmp	Start

Data:	db	'  Hello from I8052! '

	end
