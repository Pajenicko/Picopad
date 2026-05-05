; I8080 CPU speed: 2 MHz (instructions 4, 5, 7, 10 or 11 clock cycles)
; I808A-1 CPU speed: 3.125 MHz

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	8080		; Intel 8080 CPU
	org	0		; start address of the code

; CPU speed: 2 MHz
; delay 500 ms = 1000000 clock cycles

	; output A value to blink LED
Start:	mvi	a,2		; A <- bit 1

Loop2:
	; [986894] long delay
	mvi	b,0		; [7] B <- 0
	mvi	c,0		; [7] C <- 0
Loop3:	dcr	b		; [5] decrement B ... one step 5+10=15, 256 steps = 3840 clock cycles
	jnz	Loop3		; [10] loop
	dcr	c		; [5] decrement C ... one step 3840+5+10=3855, 256 steps = 986880 clock cycles
	jnz	Loop3		; [10] loop

	; [13086] short delay
	mvi	b,99		; [7] B <- 99
	mvi	c,4		; [7] C <- 4
Loop4:	dcr	b		; [5] decrement B ... one step 5+10=15, 256 steps = 3840 clock cycles, first step 15*99 = 1485
	jnz	Loop4		; [10] loop
	dcr	c		; [5] decrement C ... one step 3840+5+10=3855, 3 steps = 11565, first step 1485+15=1500
	jnz	Loop4		; [10] loop
	mvi	b,0		; [7] ... delay

	; [20] output to port
	out	15		; [10] output A to port 15
	jmp	Loop2		; [10]

	end
