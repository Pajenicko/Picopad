; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Counter on 7-segment display

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

	; clear number (address 32..41)
	mov	r0,#32		; R0 <- index of number
	mov	r2,#10		; R2 <- count of digits
Count2:	mov	@r0,#0		; clear one digit
	inc	r0		; increment index of digit
	djnz	r2,Count2	; loop digits

	; increment number
Count3:	mov	r0,#32		; R0 <- index of number
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
	jmp	Count3

	end
