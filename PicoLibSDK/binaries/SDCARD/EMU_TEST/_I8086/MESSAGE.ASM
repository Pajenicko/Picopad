; I8086 CPU speed: 5 to 10 MHz
; I8088 CPU speed: 4.77 to 9 MHz

; Compiled with Macroassembler AS

; Memory (size min. 0x11000 = 69632 bytes = 68 KB):
; - 1 KB vector table (0x0000 - 0x03FF)
; - 512 bytes BIOS data (0x0400 - 0x05FF), with emulator INT traps at its end
; - start of user program at 0x0600
; 	256 bytes PSP Program Segment Prefix of user COM program (0x0060:0x0000 - 0x0060:0x00FF)
;	start of user COM program 0x0060:0x0100 (CS=DS=SS=ES=0x0060, IP=0x0100, SP=0xFFFE), size of COM max. 0xFE00 = 65024 bytes)

; Sample: Text message

	cpu	8086		; Intel 8086 CPU
	org	100h		; start address of the code at 0x0060:0x0100

Start:
	; prepare address of text -> SI
	mov	si,Data

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

	; long delay - delay between messages (on start CX = 0 and DX = 0)
	mov	dl,10
Msg4:	loop	Msg4		; loop
	dec	dx		; decrement DX
	jnz	Msg4		; loop

	; repeat loop, output message again
	jmp	Start

Data:	db	'  Hello from I8086! '

	end
