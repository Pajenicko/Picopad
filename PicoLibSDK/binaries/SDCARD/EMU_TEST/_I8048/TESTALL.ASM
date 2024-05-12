; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

Start:
	; clear number (address 32..41)
	mov	r0,#32		; R0 <- index of number
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


	; Blinking LED - initialize main time counter
	; main time counter uses register R6 and R7
MainLoop:
	mov	r7,#4		; initialize main time counter
	mov	r6,#65		; initialize main time counter

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------

	; increment number
	mov	r0,#32		; R0 <- index of number
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
	mov	r0,#32+9	; R0 <- index of number
	mov	r2,#10		; R2 <- count of digits
Count5:	mov	a,@r0		; load digit
	outl	p2,a		; set '0' bit
	orl	a,#10h		; set write bit
	outl	p2,a		; set '1' bit
	dec	r0		; decrement index of digit
	djnz	r2,Count5	; loop digits

	; copy digits to display
	mov	a,#20h
	outl	p2,a		; copy digits to display

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------

	ins	a,bus		; A <- input from keys
	outl	p1,a		; output to LEDs <- A

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------

	djnz	r6,MainLoop2	; [18 or 22] main time loop
	djnz	r7,MainLoop2	; [18 or 22] main time loop

	; additional delay
	mov	r6,#28
Blink4:	djnz	r6,Blink4

	; output to port
	mov	a,#80h
	outl	p2,a
	mov	a,#0
	outl	p2,a
	jmp	MainLoop	; new interval

	; text data - must be in first 256-byte page
TextData:
	db	'  Hello from I8048! '

	end
