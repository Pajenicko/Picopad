; MOS-6502 CPU speed: 1 MHz to 3 MHz (Atari PAL: 1.77 MHz, Atari NTSC: 1.79 MHz)

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	6502		; MOS-6502 CPU
	org	$2000		; start address of the code

; 0x0000: counter0
; 0x0001: counter1
; 0x0002: counter2

Start:

; CPU speed 1.77 MHz, delay 500 ms = 885000 clock cycles

	; [15] initialize new loop
Loop1:  lda	#2		; [2] counter0 <- 2
	sta	0		; [3]
	lda	#236		; [2] counter1 <- 236
	sta	1		; [3]
	lda	#234		; [2] counter2 <- 234
	sta	2		; [3]

	; [884976]
Loop2:	dec	2		; [5]
	bne	Loop2		; [2] decrement counter2 ... first run 234*7=1638, next run 256*7=1792 clock cycles
	dec	1		; [5]
	bne	Loop2		; [2] decrement counter1 ... first run 1638+7+235*(1792+7)=424410, next run 256*(1792+7)=460544
	dec	0		; [5]
	bne	Loop2		; [2] decrement counter0 ... total 424410+7+460544+7=884968 clock cycles
	nop			; [2]
	nop			; [2]
	nop			; [2]
	nop			; [2]

	; [9] output to port
	lda	#2		; [2]
	sta	$EF0F		; [4]
	jmp	Loop1		; [3]

	end
