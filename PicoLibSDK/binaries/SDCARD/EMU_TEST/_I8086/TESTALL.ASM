; I8086 CPU speed: 5 to 10 MHz
; I8088 CPU speed: 4.77 to 9 MHz

; Compiled with Macroassembler AS

; Memory (size min. 0x11000 = 69632 bytes = 68 KB):
; - 1 KB vector table (0x0000 - 0x03FF)
; - 512 bytes BIOS data (0x0400 - 0x05FF), with emulator INT traps at its end
; - start of user program at 0x0600
; 	256 bytes PSP Program Segment Prefix of user COM program (0x0060:0x0000 - 0x0060:0x00FF)
;	start of user COM program 0x0060:0x0100 (CS=DS=SS=ES=0x0060, IP=0x0100, SP=0xFFFE), size of COM max. 0xFE00 = 65024 bytes)

; Sample: Run most of the tests (print message, counter, copy keys to LEDs, blinking LED)

	cpu	8086		; Intel 8086 CPU
	org	100h		; start address of the code at 0x0060:0x0100

; -----------------------------------------------------------
;                     Print message
; -----------------------------------------------------------

Start:
	; prepare address of text -> SI
	mov	si,TextData

	; prepare count of characters
	mov	cx,20		; CX <- count of characters

	; output text
Msg2:	lodsb			; load one character -> AL (SI will be incremented, direction flag is cleared at default)
	out	0eah,al		; output character to the display

	; short delay = speed of generating characters
	mov	dx,20000
Msg3:	dec	dx
	jnz	Msg3

	; next character
	loop	Msg2

	; Blinking LED - initialize main time counter
	; main time counter uses register DI
MainLoop:
	mov	di,2060	; DI <- initialize main time counter loop

MainLoop2:

; -----------------------------------------------------------
;                     Counter
; -----------------------------------------------------------

; ===== preparation

Count1:	mov	si,NumData	; SI <- numeric data
	mov	cx,10		; CX <- number of digits
	clc			; clear carry - to increase first digit

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

; -----------------------------------------------------------
;                Copy keys to the LEDs
; -----------------------------------------------------------

	in	al,0e7h		; AL <- input from keys
	out	0eeh,al		; output to LEDs <- AL

; -----------------------------------------------------------
;                    Blinking LED
; -----------------------------------------------------------

	; count main time counter
	dec	di		; decrement DI
	jnz	MainLoop2	; main time loop

	; additional delay to get precise 500 ms interval
	mov	cx,17
Blink2:	loop	Blink2
	mov	al,2		; delay
	mov	al,2		; delay
	mov	al,2		; delay
	mov	al,2		; delay

	; output AL value to blink LED
	mov	al,2		; AL <- bit 1
	out	0efh,al		; output AL to port 0xEF
	jmp	MainLoop	; new interval

	; text data
TextData:
	db	'  Hello from I8086! '

	; numeric data
NumData:
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0	; digits (from lower)

	end
