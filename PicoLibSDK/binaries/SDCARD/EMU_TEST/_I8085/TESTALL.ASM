; I8085, I8085A CPU speed: 3 MHz
; I8085-2, I8085A-2 CPU speed: 5 MHz
; I8085AH-1 CPU speed: 6 MHz

; Compiled with Macroassembler AS

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	8085		; Intel 8085 CPU
	org	0		; start address of the code

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

Start:
	; prepare address of text -> HL
	lxi	h,TextData

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

	; Blinking LED - initialize main time counter
	; main time counter uses register D and D
MainLoop:
	mvi	d,9		; D <- initialize main time counter outer loop
	mvi	e,114		; E <- initialize main time counter inner loop

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------
; Uses registers: A, B, H, L

; ===== preparation

Count1:	lxi	h,NumData	; HL <- numeric data
	mvi	b,10		; B <- number of digits
	ora	a		; clear carry - to increase first digit

; ===== increment number

	; here is carry = 0 to increase next digit
Count2:	mov	a,m		; load one digit -> A
	sbi	0ffh		; increment A: A <- A + 1 - ~carry

	; adjust A on overflow > 9 ... we want the same timings on both paths
	cpi	10		; [7] check digit overflow: sets carry if < 10
	jc	Count4		; [7,10] skip if digit < 10
	mvi	a,0		; [7] A <- 0
	jmp	Count5		; [10]
Count4:	mov	m,a		; [7] ... delay
	mov	m,a		; [7] ... delay

	; save digit
Count5:	mov	m,a		; save new digit
	inx	h		; increment HL (carry flag stays unchanged)
	dcr	b		; decrement loop counter (carry flag stays unchanged)
	jnz	Count2		; loop if B not 0

; ===== output number (in order from highest digit to lowest)

	mvi	b,10		; B <- number of digits
Count6:	dcx	h		; decrement register HL
	mov	a,m		; load one digit -> A
	out	13		; send digit to shift register
	dcr	b		; decrement loop counter
	jnz	Count6		; loop if B not 0
	out	12		; send shift register to the display

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------
; Uses registers: A

	in	7		; [16] A <- input from keys
	out	14		; [12] output to LEDs <- A

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------
; Uses registers: A, D

	; count main time counter
	dcr	e		; decrement E
	jnz	MainLoop2	; main time loop
	dcr	d		; decrement D
	jnz	MainLoop2	; main time loop

	; additional delay to get precise 500 ms interval
	mvi	d,41
Blink2:	dcr	d
	jnz	Blink2
	lda	0

	; output A value to blink LED
	mvi	a,2		; A <- bit 1
	out	15		; output A to port 15
	jmp	MainLoop	; new interval

	; text data
TextData:
	db	'  Hello from I8085! '

	; numeric data
NumData:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
