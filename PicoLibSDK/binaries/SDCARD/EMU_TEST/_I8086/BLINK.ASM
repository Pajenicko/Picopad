; I8086 CPU speed: 5 to 10 MHz
; I8088 CPU speed: 4.77 to 9 MHz

; Compiled with Macroassembler AS

; Memory (size min. 0x11000 = 69632 bytes = 68 KB):
; - 1 KB vector table (0x0000 - 0x03FF)
; - 512 bytes BIOS data (0x0400 - 0x05FF), with emulator INT traps at its end
; - start of user program at 0x0600
; 	256 bytes PSP Program Segment Prefix of user COM program (0x0060:0x0000 - 0x0060:0x00FF)
;	start of user COM program 0x0060:0x0100 (CS=DS=SS=ES=0x0060, IP=0x0100, SP=0xFFFE), size of COM max. 0xFE00 = 65024 bytes)

; Sample: Blinking LED with 1-second period

	cpu	8086		; Intel 8086 CPU
	org	100h		; start address of the code at 0x0060:0x0100

; CPU speed: 4.7715976 MHz
; delay 500 ms = 2385798 clock cycles

	; output AL value to blink LED
Start:	mov	al,2		; AL <- bit 1

Loop2:
	; [4+4+2385755=2385763] delay
	mov	bl,3		; [4] BL <- 3
	mov	cx,9266		; [4] CX <- 9266
Loop3:	loop	Loop3		; [17,5] decrement CX ... one step 17, last step 5, 9266 steps 9265*17+5=157510, 65536 steps 65535*17+5=1114100
	dec	bl		; [3] decrement BL ... first step 157510+3+16=157529, one step 1114100+3+16=1114119, last step 1114100+3+4=1114107, 3 steps = 157529+1114119+1114107=2385755
	jnz	Loop3		; [16,4] loop

	; [10] additional delay
	nop			; [3]
	nop			; [3]
	cbw			; [2]
	cbw			; [2]

	; [25] output to port
	out	0efh,al		; [10] output AL to USR LED port 0xEF
	jmp	Loop2		; [15]

	end
