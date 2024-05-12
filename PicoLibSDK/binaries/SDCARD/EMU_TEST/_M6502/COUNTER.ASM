; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Counter on 7-segment display

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

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

	; increment number
Count3:	ldx	#0		; X <- index of number
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
	jmp	Count3

	end
