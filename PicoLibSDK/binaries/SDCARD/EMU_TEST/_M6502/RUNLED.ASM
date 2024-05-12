; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Running LED

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

; X: bit mask of output to LED
; Y: decimal point position
; 0x0000: counter0
; 0x0001: counter1

Start:
	; prepare register to new run
	ldx	#1		; X <- bit 0, bit mask of output to LED 0
	ldy	#1		; Y <- 1, decimal point position 1

	; output to LEDs
Run2:	stx	$ef0e		; output to LED
	txa			; A <- X
	asl	a		; A << 1
	tax			; X <- A

	; output to decimal point position
	sty	$ef0b		; output decimal point position
	iny			; increment decimal point position

	; delay before next step
	lda	#100		; counter0
	sta	0
	lda	#0		; counter1
	sta	1
Run3:	dec	1
	bne	Run3
	dec	0
	bne	Run3

	; check end position
	cpy	#9		; decimal point position = 9 ?
	bcc	Run2		; shift to next position

	; restart, start from LED 0 again
	jmp	Start

	end
