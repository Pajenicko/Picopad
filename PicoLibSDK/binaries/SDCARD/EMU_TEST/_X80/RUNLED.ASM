; X80 CPU speed: 4.194304 MHz (Machine Cycles 1.05 MHz)

; Compiled with Macroassembler AS

; Sample: Running LED

	cpu	LR35902		; Sharp X80 LR35902 CPU
	org	0		; start address of the code

Start:
	; prepare register to new run
Run1:	ld	b,1		; B <- bit 0, bit mask of output to LED 0
	ld	c,1		; C <- 1, decimal point position 1

	; output to LEDs
Run2:	ld	a,b		; A <- output to LED
	ldh	(8eh),a		; output to LED
	rlca			; shift bit mask left
	ld	b,a		; B <- save new bit mask of output to LED

	; output to decimal point position
	ld	a,c		; A <- decimal point position
	ldh	(8bh),a		; output to set decimal point position
	inc	a		; increment decimal point position
	ld	c,a		; C <- save new decimal point position

	; delay before next step
	ld	e,0
	ld	d,100
Run3:	dec	e
	jr	nz,Run3
	dec	d
	jr	nz,Run3

	; check end position
	cp	9		; decimal point position = 9 ?
	jr	nz,Run2		; shift to next position

	; restart, start from LED 0 again
	jr	Run1

	end
