; I8052 ... 12 MHz, 8 KB ROM, 256 B RAM, 32-bit I/O, 3x 16-bit counter, 1x UART
; Clock is divided by 12 steps of one instruction cycle - it gives 1 us, 2 us or 4us per instruction on 12 MHz

; Compiled with Macroassembler AS

; Sample: Blinking LED with 1-second period

	cpu	8052		; Intel 8052 CPU
	org	0		; start address of the code

P0	equ	80h		; port P0
P1	equ	90h		; port P1
P2	equ	0a0h		; port P2
P3	equ	0b0h		; port P3

Start:

; CPU speed 12 MHz, delay 500 ms = 6000000 clock cycles

	; [36] initialize new loop
Loop1:  mov	r2,#4		; [12] R2 <- 4
	mov	r3,#205		; [12] R3 <- 205
	mov	r4,#186		; [12] R4 <- 186

	; [5999892]
Loop2:	djnz	r4,Loop2	; [24] decrement R4 ... first run 186*24=4464, next run 256*24=6144 clock cycles
	djnz	r3,Loop2	; [24] decrement R3 ... first run 4464+24+204*(6144+24)=1262760, next run 256*(6144+24)=1579008
	djnz	r2,Loop2	; [24] decrement R2 ... total 1262760+24+3*(1579008+24)=5999880 clock cycles
	nop			; [12]

	; [72] output to port
	mov	a,#80h		; [12]
	mov	p3,a		; [12]
	mov	a,#0		; [12]
	mov	p3,a		; [12]
	sjmp	Loop1		; [24]

	end
