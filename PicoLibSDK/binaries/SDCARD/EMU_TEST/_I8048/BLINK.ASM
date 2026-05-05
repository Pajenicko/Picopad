; I8048 ... 6 MHz, 1 KB ROM, 3 KB external ROM, 64 B RAM (or 256 B external RAM), 27-bit I/O, 1x 8-bit counter
;    Clock is divided by 15 steps of one instruction cycle - it gives 2.5 us per 1-byte instruction on 6 MHz
;    1-byte instruction (1 cycle, 15 ticks): 2.5 us, 2-byte instruction (2 cycles, 30 ticks): 5.0 us

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	8048		; Intel 8048 CPU
	org	0		; start address of the code

Start:

; CPU speed 6 MHz, delay 500 ms = 3000000 clock cycles

	; [90] initialize new loop
Loop1:  mov	r2,#2		; [30] R2 <- 2
	mov	r3,#134		; [30] R3 <- 134
	mov	r4,#16		; [30] R4 <- 16

	; [2999760]
Loop2:	djnz	r4,Loop2	; [30] decrement R4 ... first run 16*30=480, next run 256*30=7680 clock cycles
	djnz	r3,Loop2	; [30] decrement R3 ... first run 480+30+133*(7680+30)=1025940, next run 256*(7680+30)=1973760
	djnz	r2,Loop2	; [30] decrement C ... total 1025940+30+1973760+30=2999760 clock cycles

	; [150] output to port
	mov	a,#80h		; [30]
	outl	p2,a		; [30]
	mov	a,#0		; [30]
	outl	p2,a		; [30]
	jmp	Loop1		; [30]

	end
