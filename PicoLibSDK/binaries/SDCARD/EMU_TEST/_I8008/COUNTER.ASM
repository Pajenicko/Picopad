; I8008 CPU speed: 500 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 20 us
; I8008-1 CPU speed: 800 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 12.5 us

; Compiled with Macroassembler AS

; Sample: Counter on 7-segment display

	cpu	8008new		; Intel 8008 CPU with new mnemonics
	org	0		; start address of the code

hi	function x,(x>>8)&255	; get high byte
lo	function x,x&255	; get low byte

; One increment of the number takes 2388 clock cycles. At 500 kHz,
; it means 4776 us per increment, 209.38 increments per second

; ===== [58] preparation

	; [32] prepare address of numeric data
Count1:	mvi	l,lo(Data)	; [16] L <- numeric data LOW
	mvi	h,hi(Data)	; [16] H <- numeric data HIGH

	; [16] prepare number of digits
	mvi	b,10		; [16] B <- number of digits

	; [10] clear carry - to increase first digit
	cmp	a		; [10] clear carry

; ===== [1596] increment number: 10 loops, 1 loop takes 160 clock cycles, last loop takes 156 clock cycles

	; [32] increase one digit (here is carry = 0 to increase next digit)
Count2:	mov	a,m		; [16] load one digit -> A
	sbi	0ffh		; [16] increment A: A <- A + 1 - ~carry

	; [38 if < 10 skip, 34 if >= 10 not skip] check digit overflow
	cpi	10		; [16] check digit overflow: sets carry if < 10
	jc	Count4		; [18, 22] skip if digit < 10

	; [38] reset digit to 0
	mvi	a,0		; [16] A <- 0
	jmp	Count5		; [22]

; This part for time synchronization is not necessary,
; but we want to keep the counter running regularly,
; independent of the value of the number

	; [34] time synchronization
Count4:	nop			; [10]
	nop			; [10]
	mov	m,a		; [14] save new digit

	; [14] save new digit
Count5:	mov	m,a		; [14] save new digit

; The data array is always at address < 256,
; register H will always be 0, so we can
; increment only register L.

	; [10] increment HL pointer (carry flag stays unchanged)
	inr	l		; [10] increment register L

	; [32 if B > 0 loop, 28 if B = 0 not loop] loop counter (carry flag stays unchanged)
	dcr	b		; [10] decrement loop counter
	jnz	Count2		; [18, 22] loop if B not 0

; ===== [712] output number (in order from highest digit to lowest)

	; [16] prepare number of digits
	mvi	b,10		; [16] B <- number of digits

	; [708] decrement HL pointer: 10 loops, 1 loop takes 70 clock cycles, last loop takes 66 clock cycles
Count6:	dcr	l		; [10] decrement register L
	mov	a,m		; [16] load one digit -> A
	out	13		; [12] send digit to shift register
	dcr	b		; [10] decrement loop counter
	jnz	Count6		; [18, 22] loop if B not 0

	out	12		; [12] send shift register to the display

; ===== [22] loop

	jmp	Count1		; [22] loop

	; numeric data - must be in first 256-byte page
Data:	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
