; I8085, I8085A CPU speed: 3 MHz
; I8085-2, I8085A-2 CPU speed: 5 MHz
; I8085AH-1 CPU speed: 6 MHz

; Compiled with Macroassembler AS

; Sample: Running LED

	cpu	8085		; Intel 8085 CPU
	org	0		; start address of the code

Start:
	; prepare register to new run
Run1:	mvi	b,1		; B <- bit 0, bit mask of output to LED 0
	mvi	c,1		; C <- 1, decimal point position 1

	; output to LEDs
Run2:	mov	a,b		; A <- output to LED
	out	14		; output to LED
	rlc			; shift bit mask left
	mov	b,a		; B <- save new bit mask of output to LED

	; output to decimal point position
	mov	a,c		; A <- decimal point position
	out	11		; output to set decimal point position
	inr	a		; increment decimal point position
	mov	c,a		; C <- save new decimal point position

	; delay before next step
	mvi	e,0
	mvi	d,0
Run3:	dcr	e
	jnz	Run3
	dcr	d
	jnz	Run3

	; check end position
	cpi	9		; decimal point position = 9 ?
	jnz	Run2		; shift to next position

	; restart, start from LED 0 again
	jmp	Run1

	end
