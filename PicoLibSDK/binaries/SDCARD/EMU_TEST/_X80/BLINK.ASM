; X80 CPU speed: 4.194304 MHz (Machine Cycles 1.05 MHz)

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	LR35902		; Sharp X80 LR35902 CPU
	org	0		; start address of the code

; CPU speed: 4.194350 MHz
; delay 500 ms = 2097175 clock cycles

	; output A value to blink LED
Start:	ld	a,2		; A <- bit 1

Loop2:
	; [3*8+2097128=2097152] delay
	ld	b,2		; [8] B <- 2
	ld	c,255		; [8] C <- 255
	ld	d,126		; [8] D <- 126
Loop3:	dec	d		; [4] decrement D ... one step 4+12=16, last step 4+8=12, 126 steps 125*16+12=2012, 256 steps 255*16+12=4092
	jr	nz,Loop3	; [8,12] loop
	dec	c		; [4] decrement C ... first step 2012+4+12=2028, one step 4092+4+12=4108, last step 4092+4+8=4104, 255 steps 2028+253*4108+4104=1045456, 256 steps 255*4108+4104=1051644
	jr	nz,Loop3	; [8,12] loop
	dec	b		; [4]
	jr	nz,Loop3	; [8,12] outer loop ... first step 1045456+4+12=1045472, last step 1051644+4+8=1051656, 2 steps = 1045472+1051656=2097128

	; [24] output to port
	ldh	(8fh),a		; [12] output A to port
	jr	Loop2		; [12]

	end
