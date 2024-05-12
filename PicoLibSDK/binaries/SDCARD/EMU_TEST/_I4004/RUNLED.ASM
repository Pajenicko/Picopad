; I4004 CPU speed: 740 kHz, clock period 1.35 us
; 1-word instruction 8 clock periods = 10.8 us
; 2-word instructon 16 clock periods = 21.6 us

; Sample: Copy keys to LEDs

	.strict			; strict mode (requires register names, not register numbers)

Reset:	
	; prepare position 0
	fim	R23,0x11	; R2 <- 1 bit mask of LED 0, R3 <- 1 decimal point position 1

Loop2:
	; short delay (not exact, just "sort of")
	fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	fim	R67,0x00	; R7 <- outer loop counter
Loop3:	ijnz	R5,Loop3	; increment R5, count inner loop
	ijnz	R4,Loop3	; increment R4, count middle loop
	ijnz	R7,Loop3	; increment R7, count outer loop

	; output decimal point position
	fim	R01,0xA0	; R01 <- 0xA0, output ROM port = 10
	src	R01		; setup output ROM port = 10
	ld	R3		; A <- R3, decimal point position
	wrr			; write A to ROM port
	inc	R3		; increment decimal point position

	; clear LEDs HIGH
	fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	src	R01		; setup output ROM port = 14
	clb			; clear A nad carry
	wrr			; write A to ROM port

	; output LEDs LOW
	fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	src	R01		; setup output ROM port = 13
	xch	R2		; A <- R2, bit mask of LEDs LOW
	wrr			; write A to ROM port

	; shift LED mask
	clc			; clear carry
	ral			; shift A left through carry
	xch	R2		; R2 <- new bit mask of LEDs LOW
	jnc	Loop2		; repeat low 4 bits

	; prepare position 4	
	fim	R23,0x15	; R2 <- 1 bit mask of LED 4, R3 <- 5 decimal point position 5

Loop4:
	; short delay (not exact, just "sort of")
	fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	fim	R67,0x00	; R7 <- outer loop counter
Loop5:	ijnz	R5,Loop5	; increment R5, count inner loop
	ijnz	R4,Loop5	; increment R4, count outer loop
	ijnz	R7,Loop5	; increment R7, count outer loop

	; output decimal point position
	fim	R01,0xA0	; R01 <- 0xA0, output ROM port = 10
	src	R01		; setup output ROM port = 10
	ld	R3		; A <- R3, decimal point position
	wrr			; write A to ROM port
	inc	R3		; increment decimal point position

	; clear LEDs LOW
	fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	src	R01		; setup output ROM port = 13
	clb			; clear A nad carry
	wrr			; write A to ROM port

	; output LEDs HIGH
	fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	src	R01		; setup output ROM port = 14
	xch	R2		; A <- R2, bit mask of LEDs HIGH
	wrr			; write A to ROM port

	; shift LED mask
	clc			; clear carry
	ral			; shift A left through carry
	xch	R2		; R2 <- new bit mask of LEDs HIGH
	jnc	Loop4		; repeat low 4 bits

	; repeat from start
	jmp	Reset
