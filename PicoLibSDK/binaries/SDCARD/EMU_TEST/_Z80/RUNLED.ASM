;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Running LED

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

Start:
	; prepare register to new run
Run1:	ld	b,1		; B <- bit 0, bit mask of output to LED 0
	ld	c,1		; C <- 1, decimal point position 1

	; output to LEDs
Run2:	ld	a,b		; A <- output to LED
	out	(14),a		; output to LED
	rlca			; shift bit mask left
	ld	b,a		; B <- save new bit mask of output to LED

	; output to decimal point position
	ld	a,c		; A <- decimal point position
	out	(11),a		; output to set decimal point position
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
