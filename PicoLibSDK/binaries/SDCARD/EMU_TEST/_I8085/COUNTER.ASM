; I8085, I8085A CPU speed: 3 MHz
; I8085-2, I8085A-2 CPU speed: 5 MHz
; I8085AH-1 CPU speed: 6 MHz

; Compiled with Macroassembler AS

; Sample: Counter on 7-segment display

	cpu	8085		; Intel 8085 CPU
	org	0		; start address of the code

; ===== preparation

Count1:	lxi	h,Data		; HL <- numeric data
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

; ===== loop

	jmp	Count1		; loop

	; numeric data
Data:	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
