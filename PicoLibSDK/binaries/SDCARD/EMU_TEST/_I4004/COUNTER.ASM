; I4004 CPU speed: 740 kHz, clock period 1.35 us
; 1-word instruction 8 clock periods = 10.8 us
; 2-word instructon 16 clock periods = 21.6 us

; Sample: Counter on 7-segment display

	.strict			; strict mode (requires register names, not register numbers)

Reset:	
	; clear digits in RAM memory, register 0, RAM chip 0
	clb			; clear A and carry
	fim	R01,0x00	; R01 <- 0x00, RAM address 0
Count1:	src	R01		; setup RAM address
	wrm			; write A into RAM memory
	ijnz	R1,Count1	; increment R1 and loop to next digit

	; increment number in RAM memory, register 0, RAM chip 0
Count2:	fim	R01,0x00	; R01 <- 0x00, RAM address 0
	stc			; set carry flag
Count3:	src	R01		; setup RAM address
	ldi	0		; load 0 to A
	adm			; add RAM and carry to A (= increment memory if carry was set)
	daa			; decimal adjust: add 6 if A > 9 and set carry
	wrm			; write A into RAM memory
	ijnz	R1,Count3	; increment R1 and loop to next digit

	; send number to shift register
	fim	R01,0x09	; R01 <- 0x00, RAM address 9
Count4:	src	R01		; setup RAM address
	rdm			; read A from RAM memory
	fim	R23,0xC0	; R23 <- 0xC0, output ROM port = 12
	src	R23		; setup output ROM port = 12
	wrr			; write A to ROM port
	ld	R1		; load register R1 to A
	dac			; decrement A
	xch	R1		; write A to register R1
	jc	Count4		; loop of not borrow

	; copy digits from shift register to the display
	fim	R23,0xB0	; R23 <- 0xB0, output ROM port = 11
	src	R23		; setup output ROM port = 11
	wrr			; write A to ROM port
	jmp	Count2		; next number
