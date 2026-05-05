; I4040 CPU speed: 740 kHz, clock period 1.35 us
; 1-word instruction 8 clock periods = 10.8 us
; 2-word instructon 16 clock periods = 21.6 us

; Sample: Text message

	.strict			; strict mode (requires register names, not register numbers)

Reset:	
	; prepare pointer to message data (must be located in the same 256-byte page)
	fim	R01,@MsgData	; R0R1 <- pointer to message data

	; load one character [R0R1] -> R2R3
Msg2:	fin	R23		; R2R3 <- load one character (R2=high part, R3=low part)

	; increment pointer to message data
	ijnz	R1,Msg4		; increment register R1, skip if not zero (low part of message pointer)
	inc	R0		; increment register R0 (high part of message pointer)

	; check end of text
Msg4:	ld	R2		; A <- R2, character high part
	jnz	Msg6		; not 0, valid character, continue

	; long delay after message
	fim	R45,0x00	; R4 <- middle loop counter, R5 <- inner loop counter
	fim	R67,0x00	; R7 <- outer loop counter, R6 <- max outer loop counter
Msg5:	ijnz	R5,Msg5		; increment R5, count inner loop
	ijnz	R4,Msg5		; increment R4, count outer loop
	ijnz	R7,Msg5		; increment R7, count outer loop
	ijnz	R6,Msg5		; increment R6, count max outer loop
	jz	Reset		; reset text

	; output HIGH part of the character
Msg6:	fim	R45,0x90	; R45 <- 0x90, output ROM port = 9
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
