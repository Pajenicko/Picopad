;  cpu Z80: max. 2.5 MHz
;  cpu Z80A: max. 4 MHz
;  cpu Z80B: max. 6 MHz
;  cpu Z80H: max. 8 MHz

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	z80		; Zilog Z80 CPU
	org	0		; start address of the code

; CPU speed: 4 MHz
; delay 500 ms = 2000000 clock cycles

	; output A value to blink LED
Start:	ld	a,2		; A <- bit 1

Loop2:
	; [3*7+1999944+3*4=1999977] delay
	ld	b,2		; [7] B <- 2
	ld	c,231		; [7] C <- 231
	ld	d,245		; [7] D <- 245
Loop3:	dec	d		; [4] decrement D ... one step 4+12=16, last step 4+7=11, 245 steps 244*16+11=3915, 256 steps 255*16+11=4091
	jr	nz,Loop3	; [7,12] loop
	dec	c		; [4] decrement C ... first step 3915+4+12=3931, one step 4091+4+12=4107, last step 4091+4+7=4102, 231 steps 3931+229*4107+4102=948536, 256 steps 255*4107+4102=1051387
	jr	nz,Loop3	; [7,12] loop
	djnz	Loop3		; [8,13] outer loop ... first step 948536+13=948549, one step 1051387+13=1051400, last step 1051387+8=1051395, 2 steps = 948549+1051395=1999944
	nop			; [4]
	nop			; [4]
	nop			; [4]

	; [23] output to port
	out	(15),a		; [11] output A to port 15
	jr	Loop2		; [12]

	end
