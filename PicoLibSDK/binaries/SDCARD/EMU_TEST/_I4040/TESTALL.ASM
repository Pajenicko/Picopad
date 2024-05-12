; I4040 CPU speed: 740 kHz, clock period 1.35 us
; 1-word instruction 8 clock periods = 10.8 us
; 2-word instructon 16 clock periods = 21.6 us

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	.strict			; strict mode (requires register names, not register numbers)

Reset:	
	; clear digits in RAM memory, register 0, RAM chip 0
	clb			; clear A and carry
	fim	R01,0x00	; R01 <- 0x00, RAM address 0
Count1:	src	R01		; setup RAM address
	wrm			; write A into RAM memory
	ijnz	R1,Count1	; increment R1 and loop to next digit

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

	; prepare pointer to message data (must be located in the same 256-byte page)
	fim	R01,@MsgData	; R0R1 <- pointer to message data

	; load one character [R0R1] -> R2R3
Msg2:	fin	R23		; R2R3 <- load one character (R2=high part, R3=low part)

	; increment pointer to message data
	ijnz	R1,Msg4		; increment register R1, skip if not zero (low part of message pointer)
	inc	R0		; increment register R0 (high part of message pointer)

	; check end of text
Msg4:	ld	R2		; A <- R2, character high part
	jz	MainLoop	; end mark 0, continue to next test

	; output HIGH part of the character
	fim	R45,0x90	; R45 <- 0x90, output ROM port = 9
	src	R45		; setup output ROM port = 9
	ld	R2		; A <- R2, character high part
	wrr			; write A to ROM port

	; output LOW part of the character
	fim	R45,0x80	; R45 <- 0x80, output ROM port = 8
	src	R45		; setup output ROM port = 8
	ld	R3		; A <- R3, character low part
	wrr			; write A to ROM port

	; short delay between characters
	fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	fim	R67,0x00	; R7 <- outer loop counter
Msg8:	ijnz	R5,Msg8		; increment R5, count inner loop
	ijnz	R4,Msg8		; increment R4, count outer loop
	ijnz	R7,Msg8		; increment R7, count outer loop
	jmp	Msg2		; continue to next cahracter

; message data (20 characters)
MsgData:
= ' '
= ' '
= 'H'
= 'e'
= 'l'
= 'l'
= 'o'
= ' '
= 'f'
= 'r'
= 'o'
= 'm'
= ' '
= 'I'
= '4'
= '0'
= '4'
= '0'
= '!'
= ' '
= 0		; flag - end of text

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------

MainLoop:
	fim	R89,0x47	; R89 <- initialize main time counter
MainLoop2:

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

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------

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

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------

	; count main time counter
	ijnz	R9,MainLoop2
	ijnz	R8,MainLoop2

	; additional delay
	fim	R01,0xBA
Blink2:	ijnz	R1,Blink2
	ijnz	R0,Blink2

	; flip LED
	fim	R01,0xF0	; R01 <- 0xF0, output ROM port = 15
	src	R01		; setup output ROM port = 15
	ldi	2		; A <- bit 1
	wrr			; write A to ROM port
	jmp	MainLoop	; jump to main loop
