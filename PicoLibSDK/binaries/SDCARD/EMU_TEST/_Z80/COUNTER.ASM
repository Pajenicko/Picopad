;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Counter on 7-segment display

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

; ===== preparation

Count1:	ld	hl,Data		; HL <- numeric data
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

; ===== loop

	jp	Count1		; loop

	; numeric data
Data:	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
