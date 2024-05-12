; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3
NUMBER	equ	30h		; number address

Start:
	; clear number (address 32..41)
	mov	r0,#NUMBER	; R0 <- index of number
	mov	r2,#10		; R2 <- count of digits
Count2:	mov	@r0,#0		; clear one digit
	inc	r0		; increment index of digit
	djnz	r2,Count2	; loop digits

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

	; prepare address of text
	mov	r0,#TextData	; R0 <- address of the text

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


	; Blinking LED - initialize main time counter
	; main time counter uses register R6 and R7
MainLoop:
	mov	r7,#11		; initialize main time counter
	mov	r6,#187		; initialize main time counter

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------

	; increment number
	mov	r0,#NUMBER	; R0 <- index of number
	mov	r2,#10		; R2 <- count of digits
	clr	c		; clear carry
	cpl	c		; complement carry
Count4:	mov	a,@r0		; load digit
	swap	a		; swap nibbles
	addc	a,#09h		; add carry
	da	a		; decimal adjust
	swap	a		; return nibbles
	anl	a,#0fh		; mask digit
	mov	@r0,a		; save digit
	inc	r0		; increment index of digit
	djnz	r2,Count4	; loop digits

	; output digits to shift register
	mov	r0,#NUMBER+9	; R0 <- index of number
	mov	r2,#10		; R2 <- count of digits
Count5:	mov	a,@r0		; load digit
	mov	p3,a		; set '0' bit
	orl	a,#10h		; set write bit
	mov	p3,a		; set '1' bit
	dec	r0		; decrement index of digit
	djnz	r2,Count5	; loop digits

	; copy digits to display
	mov	a,#20h
	mov	p3,a		; copy digits to display

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------

	mov	a,p0		; A <- input from keys
	mov	p2,a		; output to LEDs <- A

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------

	djnz	r6,MainLoop2	; [18 or 22] main time loop
	djnz	r7,MainLoop2	; [18 or 22] main time loop

	; additional delay
	mov	r6,#7
Blink4:	djnz	r6,Blink4
	nop

	; output to port
	mov	a,#80h
	mov	p3,a
	mov	a,#0
	mov	p3,a
	jmp	MainLoop	; new interval

	; text data - must be in first 256-byte page
TextData:
	db	'  Hello from I8052! '

	end
