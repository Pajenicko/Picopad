; I8008 CPU speed: 500 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 20 us
; I8008-1 CPU speed: 800 kHz, one T-state is 2 clock period, base instruction (5 T-states) takes 12.5 us

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	8008new		; Intel 8008 CPU with new mnemonics
	org	0		; start address of the code

hi	function x,(x>>8)&255	; get high byte
lo	function x,x&255	; get low byte

; When calculating instruction timings, use twice the number of T cycles
; because each T cycle takes 2 crystal clock cycles.

; To execute loops:
;   B ... 1 step 10+22=32 clock cycles, 256 clock cycles 32*256-4=8188
;   C ... 1 step 8188+10+22=8220 clock cycles

; CPU speed: 500 kHz
; delay 500 ms = 250000 clock cycles
; output to LED and initialize 32+34=66
; without output to LED and initialize 250000 - 66 = 249934 clock cycles
; number of whole C steps 249934/8220 = 30, remains 3334
; correction of last step: 3334 + 4 = remains 3338
; for additional first loop: 3338 + 4 - 10 - 22 = 3310
; number of remaining B steps 3310/32 = 103, remains 14

; Initialize:
;   B = 103
;   C = 30+1=31

	; output A value to blink LED
Start:	mvi	a,2		; A <- bit 1

	; prepare destination address for time correction
	mvi	l,lo(Data)	; L <- data LOW
	mvi	h,hi(Data)	; H <- data HIGH

; total: 250000 clock cycles

	; [32] initialize new loop
Loop1:	mvi	b,103		; [16] B <- 103
	mvi	c,31		; [16] C <- 31

	; [249920]
Loop2:	dcr	b		; [10] decrement B ... first run (10+22)*102+10+18=3292 clock cycles ... next run (10+22)*255+10+18=8188 clock cycles
	jnz	Loop2		; [18 or 22] loop
	dcr	c		; [10] decrement C ... total 3292+10+22 + (8188+10+22)*29 + 8188+10+18 = 249920
	jnz	Loop2		; [18 or 22] loop

	; [14] time correction ... we add missing 14 clock cycles
	mov	m,a		; [14] (HL) <- A

	; [34] output to port
	out	15		; [12] output A to port 15
	jmp	Loop1		; [22]

Data:	db	0		; for timing correction

	end
