; I8086 CPU speed: 5 to 10 MHz
; I8088 CPU speed: 4.77 to 9 MHz

; Compiled with Macroassembler AS

; Memory (size min. 0x11000 = 69632 bytes = 68 KB):
; - 1 KB vector table (0x0000 - 0x03FF)
; - 512 bytes BIOS data (0x0400 - 0x05FF), with emulator INT traps at its end
; - start of user program at 0x0600
; 	256 bytes PSP Program Segment Prefix of user COM program (0x0060:0x0000 - 0x0060:0x00FF)
;	start of user COM program 0x0060:0x0100 (CS=DS=SS=ES=0x0060, IP=0x0100, SP=0xFFFE), size of COM max. 0xFE00 = 65024 bytes)

; Sample: Running LED

	cpu	8086		; Intel 8086 CPU
	org	100h		; start address of the code at 0x0060:0x0100

Start:
	; prepare register to new run
Run1:	mov	bl,1		; BL <- bit 0, bit mask of output to LED 0
	mov	bh,1		; BH <- 1, decimal point position 1

	; output to LEDs
Run2:	mov	al,bl		; AL <- output to LED
	out	0eeh,al		; output to LED
	rol	al,1		; shift bit mask left
	mov	bl,al		; BL <- save new bit mask of output to LED

	; output to decimal point position
	mov	al,bh		; AL <- decimal point position
	out	0ebh,al		; output to set decimal point position
	inc	ax		; increment decimal point position
	mov	bh,al		; BH <- save new decimal point position

	; delay before next step
	mov	cx,50000
Run3:	loop	Run3

	; check end position
	cmp	al,9		; decimal point position = 9 ?
	jne	Run2		; shift to next position

	; restart, start from LED 0 again
	jmp	Run1

	end
