; I4040 CPU speed: 740 kHz, clock period 1.35 us
; 1-word instruction 8 clock periods = 10.8 us
; 2-word instructon 16 clock periods = 21.6 us

; Sample: Copy keys to LEDs

	.strict			; strict mode (requires register names, not register numbers)

Reset:	
	; input keys HIGH
	fim	R01,0x60	; R01 <- 0x60, input ROM port = 6
	src	R01		; setup input ROM port = 6
	rdr			; read ROM port to A

	; output LEDs HIGH
	fim	R01,0xE0	; R01 <- 0xE0, output ROM port = 14
	src	R01		; setup output ROM port = 14
	wrr			; write A to ROM port

	; input keys LOW
	fim	R01,0x50	; R01 <- 0x50, input ROM port = 5
	src	R01		; setup input ROM port = 5
	rdr			; read ROM port to A

	; output LEDs LOW
	fim	R01,0xD0	; R01 <- 0xD0, output ROM port = 13
	src	R01		; setup output ROM port = 13
	wrr			; write A to ROM port

	jmp	Reset		; jump to main loop
