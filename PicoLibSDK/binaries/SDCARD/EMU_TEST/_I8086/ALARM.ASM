; I8086 CPU speed: 5 to 10 MHz
; I8088 CPU speed: 4.77 to 9 MHz

; Compiled with Macroassembler AS

; Memory (size min. 0x11000 = 69632 bytes = 68 KB):
; - 1 KB vector table (0x0000 - 0x03FF)
; - 512 bytes BIOS data (0x0400 - 0x05FF), with emulator INT traps at its end
; - start of user program at 0x0600
; 	256 bytes PSP Program Segment Prefix of user COM program (0x0060:0x0000 - 0x0060:0x00FF)
;	start of user COM program 0x0060:0x0100 (CS=DS=SS=ES=0x0060, IP=0x0100, SP=0xFFFE), size of COM max. 0xFE00 = 65024 bytes)

; Sample: Alarm sound

	cpu	8086		; Intel 8086 CPU
	org	100h		; start address of the code at 0x0060:0x0100

	; output value to the speaker
Start:	mov	al,2		; AL <- output value: bit 1, flip output to the speaker

	; prepare length of tone (number of pulses)
Alarm1:	mov	bl,0		; BL <- length of the tone

	; prepare frequency of the tone (delay of pulses)
Alarm2:	mov	cx,250		; delay of impulse

	; short delay to generate one impulse
Alarm3:	loop	Alarm3		; wait for end of impulse

	; output to speaker
	out	0e9h,al		; output to speaker, flip output to the speaker

	; count pulses
	dec	bl		; count pulses of one tone
	jnz	Alarm2		; wait for a tone

	; delay before next tone
	mov	cx,50000	; delay length
Alarm4:	loop	Alarm4		; waiting between tones

	; next tone
	jmp	Alarm1		; repeat next tone

	end
