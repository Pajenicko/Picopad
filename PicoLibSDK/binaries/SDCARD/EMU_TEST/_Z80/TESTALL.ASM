;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

Start:
	; prepare address of text -> HL
	ld	hl,TextData

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

	; Blinking LED - initialize main time counter
	; main time counter uses register D and E
MainLoop:
	ld	d,7		; D <- initialize main time counter outer loop
	ld	e,177		; E <- initialize main time counter inner loop

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------
; Uses registers: A, B, H, L

; ===== preparation

Count1:	ld	hl,NumData	; HL <- numeric data
	ld	b,10		; B <- number of digits
	or	a		; clear carry - to increase first digit

; ===== increment number

	; here is carry = 0 to increase next digit
Count2:	ld	a,(hl)		; load one digit -> A
	sbc	a,0ffh		; increment A: A <- A + 1 - ~carry

	; adjust A on overflow > 9 ... we want the same timings on both paths
	cp	10		; [7] check digit overflow: sets carry if < 10
	jr	c,Count4	; [7,12] skip if digit < 10
	ld	a,0		; [7] A <- 0
	jr	Count5		; [12]
Count4:	ld	(hl),a		; [7] ... delay
	ld	(hl),a		; [7] ... delay

	; save digit
Count5:	ld	(hl),a		; save new digit
	inc	hl		; increment HL (carry flag stays unchanged)
	djnz	Count2		; decrement B and loop if B not 0 (carry flag stays unchanged)

; ===== output number (in order from highest digit to lowest)

	ld	b,10		; B <- number of digits
Count6:	dec	hl		; decrement register HL
	ld	a,(hl)		; load one digit -> A
	out	(13),a		; send digit to shift register
	djnz	Count6		; decrement B and loop if B not 0
	out	(12),a		; send shift register to the display

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------
; Uses registers: A

	in	a,(7)		; A <- input from keys
	out	(14),a		; output to LEDs <- A

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------

	; count main time counter
	dec	e		; decrement E
	jr	nz,MainLoop2	; main time loop
	dec	d		; decrement D
	jr	nz,MainLoop2	; main time loop

	; additional delay to get precise 500 ms interval
	ld	b,61
Blink2:	djnz	Blink2
	add	hl,bc
	ld	b,0

	; output A value to blink LED
	ld	a,2		; A <- bit 1
	out	(15),a		; output A to port 15
	jr	MainLoop	; new interval

	; text data
TextData:
	db	'   Hello from Z80!  '

	; numeric data
NumData:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
