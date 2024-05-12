; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Counter on 7-segment display

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3
NUMBER	equ	30h		; number address

	; clear number (address 32..41)
	mov	r0,#NUMBER	; R0 <- index of number
	mov	r2,#10		; R2 <- count of digits
Count2:	mov	@r0,#0		; clear one digit
	inc	r0		; increment index of digit
	djnz	r2,Count2	; loop digits

	; increment number
Count3:	mov	r0,#NUMBER	; R0 <- index of number
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
	jmp	Count3

	end
