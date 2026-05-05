; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

Start:

; X: index of number
; Y: counter of digits
; 0x0010: number (10 digits)

	; clear number
	ldx	#0		; X <- index of number
	ldy	#10		; Y <- count of digits
	lda	#0		; A <- 0
Count2:	sta	$10,x		; clear one digit
	inx			; increment index of digit
	dey			; decrement counter of digits
	bne	Count2		; loop digits

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

; X: index of character
; Y: counter of characters
; 0x0000: counter0
; 0x0001: counter1

	; prepare index of text
	ldx	#0		; X <- index of character

	; prepare count of characters
	ldy	#20		; Y <- count of characters

	; output character
Msg2:	lda	TextData,x	; load one character -> A
	sta	$ef0a		; output character to the display

	; short delay = speed of generating characters
	lda	#100		; counter0
	sta	0
	lda	#0		; counter1
	sta	1
Msg3:	dec	1
	bne	Msg3
	dec	0
	bne	Msg3

	; next character
	inx			; increment index of character
	dey			; decrement counter of characters
	bne	Msg2		; loop


; 0x0005: counter5 (high)
; 0x0006: counter6 (low)

	; Blinking LED - initialize main time counter
	; main time counter uses register D and E
MainLoop:
	lda	#9		; counter5 (high)
	sta	5
	lda	#115		; counter6 (low)
	sta	6

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------

; X: index of number
; Y: counter of digits
; 0x0010: number (10 digits)

	; increment number
	ldx	#0		; X <- index of number
	ldy	#10		; Y <- count of digits
	sec			; set carry
Count4:	lda	$10,x		; A <- load digit
	adc	#0		; increment digit if carry is set

	; [8] adjust A on overflow > 9 ... we want the same timings on both paths
	cmp	#10		; [2] check overflow
	bcc	Count5		; [2] not overflow
	lda	#0		; [2] reset A <- 0 (here is carry set)
	bcs	Count6		; [2]
Count5:	nop			; [2]
	nop			; [2]

Count6:	sta	$10,x		; save digit
	inx			; increment index of digit
	dey			; decrement counter of digits
	bne	Count4		; loop digits

	; output digits to shift register
	ldx	#9		; X <- index of number
	ldy	#10		; Y <- count of digits
Count8:	lda	$10,x		; A <- load digit
	sta	$ef0d		; send digit
	dex			; decrement index of digit
	dey			; decrement counter of digits
	bne	Count8		; loop digits

	; copy digits to display
	sta	$ef0c		; copy digits to display

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------

	lda	$ef07		; A <- input from keys
	sta	$ef0e		; output to LEDs <- A

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------

; 0x0005: counter5 (high)
; 0x0006: counter6 (low)

	; count main time counter
	dec	6		; decrement counter6 (low)
	bne	MainLoop2	; main time loop
	dec	5		; decrement counter5 (high)
	bne	MainLoop2	; main time loop

	; additional delay to get precise 500 ms interval
	lda	#34		; counter0
	sta	0
Blink2:	dec	0		; [5]
	bne	Blink2		; [2]
	nop
	nop
	nop
	nop

	; output A value to blink LED
	lda	#2
	sta	$EF0F
	jmp	MainLoop	; new interval

	; text data
TextData:
	db	'  Hello from M6502! '

	end
