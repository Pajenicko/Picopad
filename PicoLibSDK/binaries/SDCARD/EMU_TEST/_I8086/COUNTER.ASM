; I8086 CPU speed: 5 to 10 MHz
; I8088 CPU speed: 4.77 to 9 MHz

; Compiled with Macroassembler AS

; Memory (size min. 0x11000 = 69632 bytes = 68 KB):
; - 1 KB vector table (0x0000 - 0x03FF)
; - 512 bytes BIOS data (0x0400 - 0x05FF), with emulator INT traps at its end
; - start of user program at 0x0600
; 	256 bytes PSP Program Segment Prefix of user COM program (0x0060:0x0000 - 0x0060:0x00FF)
;	start of user COM program 0x0060:0x0100 (CS=DS=SS=ES=0x0060, IP=0x0100, SP=0xFFFE), size of COM max. 0xFE00 = 65024 bytes)

; Sample: Counter on 7-segment display

	cpu	8086		; Intel 8086 CPU
	org	100h		; start address of the code at 0x0060:0x0100

; ===== preparation

Count1:	mov	si,Data		; SI <- pointer to numeric data
	mov	cx,10		; CX <- number of digits
	or	al,al		; clear carry - to increase first digit

; ===== increment number

	; here is carry = 0 to increase next digit
Count2:	mov	al,[si]		; load one digit -> AL
	sbb	al,0ffh		; increment AL: AL <- AL + 1 - ~carry

	; [20] adjust AL on overflow > 9 ... we want the same timings on both paths
	cmp	al,10		; [4] check digit overflow: sets carry if < 10
	jc	Count4		; [16,4] skip if digit < 10
	mov	al,0		; [4] AL <- 0
	mov	al,0		; [4] delay
	mov	al,0		; [4] delay
Count4:	

	; save digit
	mov	[si],al		; save new digit
	inc	si		; increment SI (carry flag stays unchanged)
	loop	Count2		; loop

; ===== output number (in order from highest digit to lowest)

	mov	cl,10		; CL <- number of digits (here is CH = 0)
Count6:	dec	si		; decrement register SI
	mov	al,[si]		; load one digit -> AL
	out	0edh,al		; send digit to shift register
	loop	Count6		; loop
	out	0ech,al		; send shift register to the display

; ===== loop

	jmp	Count1		; loop

	; numeric data
Data:	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
