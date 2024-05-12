; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Text message

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

; X: index of character
; Y: counter of characters
; 0x0000: counter0
; 0x0001: counter1
; 0x0002: counter2

Start:
	; prepare index of text
	ldx	#0		; X <- index of character

	; prepare count of characters
	ldy	#20		; Y <- count of characters

	; output character
Msg2:	lda	Data,x		; load one character -> A
	sta	$ef0a		; output character to the display

	; short delay = speed of generating characters
	lda	#100		; counter0
	sta	0
	lda	#0		; counter1
	sta	1
Msg3:	dec	1
	bne	Msg3
	dec	0
	bne	Msg3

	; next character
	inx			; increment index of character
	dey			; decrement counter of characters
	bne	Msg2		; loop

	; long delay - delay between messages
	lda	#10		; counter0
	sta	0
	lda	#0		; counter1
	sta	1
	sta	2
Msg4:	dec	2
	bne	Msg4
	dec	1
	bne	Msg4
	dec	0
	bne	Msg4

	; repeat loop, output message again
	jmp	Start

Data:	db	'  Hello from M6502! '

	end
