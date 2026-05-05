; I8085, I8085A CPU speed: 3 MHz
; I8085-2, I8085A-2 CPU speed: 5 MHz
; I8085AH-1 CPU speed: 6 MHz

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	8085		; Intel 8085 CPU
	org	0		; start address of the code

; CPU speed: 5 MHz
; delay 500 ms = 2500000 clock cycles

	; output A value to blink LED
Start:	mvi	a,2		; A <- bit 1

Loop2:
	; [3*7+2499952+7=2499980] delay
	mvi	b,3		; [7] B <- 3
	mvi	c,184		; [7] C <- 184
	mvi	d,99		; [7] D <- 99
Loop3:	dcr	d		; [4] decrement D ... one step 4+10=14, last step 4+7=11, 99 steps 98*14+11=1383, 256 steps 255*14+11=3581
	jnz	Loop3		; [7,10] loop
	dcr	c		; [4] decrement C ... first step 1383+4+10=1397, one step 3581+4+10=3595, last step 3581+4+7=3592, 184 steps 1397+182*3595+3592=659279, 256 steps 255*3595+3592=920317
	jnz	Loop3		; [7,10] loop
	dcr	b		; [4] decrement B ... first step 659279+4+10=659293, one step 920317+4+10=920331, last step 920317+4+7=920328, 3 steps = 659293+920331+920328=2499952
	jnz	Loop3		; [7,10] loop
	mvi	b,0		; [7] ... delay

	; [20] output to port
	out	15		; [10] output A to port 15
	jmp	Loop2		; [10]

	end
