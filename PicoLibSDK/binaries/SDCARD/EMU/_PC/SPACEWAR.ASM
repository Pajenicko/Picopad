
PAGE  59,132

; Sourcer setup:
; Analysis Options = a b c d e f g h i j k l m n o p q r s t U v w x y z
; 2nd Options page = a b C d e f g h i j k l m
; uP               = 80186
; Math uP code     = OFF
; File format      = ASM
; Keep segments    = Def
; Label type       = Letter segment & offset
; Remarks          = All
; Segment display  = Hex
; Target Assembler = TASM-3.2, byte match
; Vertical lines   = 0
; Drive (output)   = Z
; Passes           = 9
; Xref             = OFF

;==========================================================================
;==					                                 ==
;==				SPACEWAR                                 ==
;==					                                 ==
;==      Created:   31-Jan-85		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_0000_0020_e	equ	20h
d_0000_0024_e	equ	24h
d_0000_2828_e	equ	2828h			;*
d_0000_334E_e	equ	334Eh			;*
d_0000_DADA_e	equ	0DADAh			;*
d_0000_DF36_e	equ	0DF36h			;*
d_0009_0600_e	equ	600h			;*
d_0009_8080_e	equ	8080h			;*
d_0040_0024_e	equ	24h
d_0040_003F_e	equ	3Fh
d_0040_0040_e	equ	40h
d_0040_006C_e	equ	6Ch
d_0040_006E_e	equ	6Eh
d_0040_0070_e	equ	70h
d_0040_0072_e	equ	72h
d_0166_00AA_e	equ	0AAh			;*
d_0166_00B4_e	equ	0B4h			;*
d_0166_0170_e	equ	170h			;*
d_0166_0171_e	equ	171h			;*
d_0166_0225_e	equ	225h			;*
d_0166_02D9_e	equ	2D9h			;*
d_0166_038D_e	equ	38Dh			;*
d_0166_0441_e	equ	441h			;*
d_0166_04F5_e	equ	4F5h			;*
d_0166_05A9_e	equ	5A9h			;*
d_0166_065D_e	equ	65Dh			;*
d_0166_0711_e	equ	711h			;*
d_0166_0D5C_e	equ	0D5Ch			;*
d_0166_0D6C_e	equ	0D6Ch			;*
d_0166_0D7C_e	equ	0D7Ch			;*
d_0166_0D8C_e	equ	0D8Ch			;*
d_0166_0E7C_e	equ	0E7Ch			;*
d_0166_0E8C_e	equ	0E8Ch			;*
d_0166_1076_e	equ	1076h			;*
d_0166_1081_e	equ	1081h			;*
d_0166_1083_e	equ	1083h			;*
d_0166_2040_e	equ	2040h			;*
d_0166_3035_e	equ	3035h			;*
d_0168_0000_e	equ	0			;*
d_10CD_8C36_e	equ	8C36h			;*
d_10CD_FE60_e	equ	0FE60h			;*
data_a_6E3C_e	equ	6E3Ch			;*
data_a_BB86_e	equ	0BB86h			;*
data_a_DCF9_e	equ	0DCF9h			;*
data_a_FFFE_e	equ	0FFFEh			;*
data_b_FFFE_e	equ	0FFFEh			;*
d_B800_4000_e	equ	4000h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	para public
		assume cs:seg_a  , ds:seg_a

data_a_0000	db	'SORRY !  You need a 640 X 200 Co'	; Data table (indexed access)
		db	'lor Graphics card to run SPACEWA'
		db	'R !$'
		db	'May the farce be with you.$'
data_a_005F	db	0
data_a_0060	db	0
data_a_0061	dw	0			; Data table (indexed access)
		db	0
data_a_0064	dw	0			; segment storage
		db	68 dup (0)
data_a_00AA	dw	0			; Data table (indexed access)
		db	8 dup (0)
data_a_00B4	db	0			; Data table (indexed access)
		db	19 dup (0)
data_a_00C8	db	0
		db	167 dup (0)
data_a_0170	db	0
data_a_0171	dw	0Fh			; Data table (indexed access)
		db	 0Eh, 00h, 11h, 00h, 0Eh, 00h
		db	 10h, 00h, 0Eh, 00h, 12h, 00h
		db	 0Eh, 00h, 0Fh, 00h, 0Eh, 00h
		db	 11h, 00h, 11h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Fh, 00h
		db	 0Eh, 00h, 10h, 00h, 0Eh, 00h
		db	 11h, 00h, 11h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Fh, 00h
		db	 0Eh, 00h, 11h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Eh, 00h
		db	 11h, 00h, 11h, 00h, 0Eh, 00h
		db	 12h, 00h, 0Eh, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Fh, 00h, 0Eh, 00h
		db	 11h, 00h, 11h, 00h, 0Eh, 00h
		db	 12h, 00h, 0Eh, 00h, 0Eh, 00h
		db	 11h, 00h, 0Eh, 00h, 0Fh, 00h
		db	 0Eh, 00h, 11h, 00h, 0Fh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Eh, 00h
		db	 11h, 00h, 12h, 00h, 10h, 00h
		db	 0Fh, 00h, 11h, 00h, 12h, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Eh, 00h
		db	 0Fh, 00h, 11h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Fh, 00h
		db	 0Eh, 00h, 11h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Eh, 00h
		db	 11h, 00h, 11h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 0Eh, 00h, 0Fh, 00h
		db	 0Eh, 00h, 10h, 00h, 0Eh, 00h
		db	 11h, 00h, 10h, 00h, 12h, 00h
		db	 10h, 00h, 12h, 00h
data_a_0225	dw	40h			; Data table (indexed access)
		db	 50h, 00h, 60h, 00h, 60h, 00h
		db	 60h, 00h, 50h, 00h, 40h, 00h
		db	 40h, 00h, 40h, 00h, 50h, 00h
		db	 60h, 00h, 80h, 00h, 80h, 00h
		db	 80h, 00h, 80h, 00h, 80h, 00h
		db	 90h, 00h,0A0h, 00h,0A0h, 00h
		db	0A0h, 00h,0C0h, 00h,0C0h, 00h
		db	0C0h, 00h,0C0h, 00h,0C0h, 00h
		db	0D0h, 00h,0E0h, 00h,0E0h, 00h
		db	0E0h, 00h,0D0h, 00h,0E0h, 00h
		db	0E0h, 00h, 20h, 01h, 10h, 01h
		db	 00h, 01h, 00h, 01h, 00h, 01h
		db	 00h, 01h, 00h, 01h, 10h, 01h
		db	 20h, 01h, 60h, 01h, 50h, 01h
		db	 40h, 01h, 40h, 01h, 40h, 01h
		db	 50h, 01h, 40h, 01h, 40h, 01h
		db	 50h, 01h, 60h, 01h,0B0h, 01h
		db	0B0h, 01h,0B0h, 01h,0B0h, 01h
		db	0B0h, 01h,0A0h, 01h,0A0h, 01h
		db	 90h, 01h, 90h, 01h, 80h, 01h
		db	 80h, 01h, 80h, 01h, 80h, 01h
		db	 80h, 01h,0D0h, 01h,0D0h, 01h
		db	0D0h, 01h,0D0h, 01h,0D0h, 01h
		db	0E0h, 01h,0F0h, 01h,0F0h, 01h
		db	0F0h, 01h,0E0h, 01h,0F0h, 01h
		db	0F0h, 01h, 10h, 02h, 10h, 02h
		db	 10h, 02h, 10h, 02h, 10h, 02h
		db	 20h, 02h, 30h, 02h, 30h, 02h
		db	 30h, 02h, 20h, 02h, 20h, 02h
		db	 30h, 02h, 30h, 02h
data_a_02D9	dw	70h			; Data table (indexed access)
		db	'p', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'`', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'X', 0
		db	'`', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'X', 0
		db	'`', 0
		db	'`', 0
		db	'h', 0
		db	'p', 0
		db	'p', 0
		db	'p', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'p', 0
		db	'p', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'X', 0
		db	'`', 0
		db	'h', 0
		db	'p', 0
		db	'p', 0
		db	'h', 0
		db	'h', 0
		db	'p', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'X', 0
		db	'`', 0
		db	'`', 0
		db	'h', 0
		db	'p', 0
		db	'p', 0
		db	'h', 0
		db	'`', 0
		db	'X', 0
		db	'P', 0
		db	'P', 0
		db	'P', 0
		db	'X', 0
		db	'`', 0
		db	'`', 0
		db	'h', 0
		db	'h', 0
		db	 70h, 00h
data_a_038D	db	64 dup (0)		; Data table (indexed access)
data_a_03CD	dw	0
		db	114 dup (0)
data_a_0441	dw	0			; Data table (indexed access)
		db	62 dup (0)
data_a_0481	dw	0
		db	114 dup (0)
data_a_04F5	dw	0			; Data table (indexed access)
		db	178 dup (0)
data_a_05A9	dw	0			; Data table (indexed access)
		db	178 dup (0)
data_a_065D	dw	0			; Data table (indexed access)
		db	178 dup (0)
data_a_0711	dw	0			; Data table (indexed access)
		db	541 dup (0)
data_a_0930	dw	0
data_a_0932	dw	0
		db	12 dup (0)
		db	 80h, 40h, 20h, 10h, 08h, 04h
		db	 02h, 01h
		db	8 dup (0)
data_a_0950	db	0
		db	95 dup (0)
		db	0A0h, 00h, 00h
		db	13 dup (0)
		db	0E0h, 01h
		db	14 dup (0)
		db	2Eh
		db	15 dup (0)
		db	 8Ah, 00h
		db	14 dup (0)
		db	0A0h, 00h, 00h
		db	13 dup (0)
		db	0E0h, 01h
		db	14 dup (0)
		db	2Eh
		db	15 dup (0)
		db	 8Ah, 00h
		db	174 dup (0)
		db	1, 0
		db	14 dup (0)
		db	1, 0
		db	30 dup (0)
		db	 80h, 00h, 00h
		db	29 dup (0)
		db	 80h, 00h, 00h
		db	109 dup (0)
		db	1Fh
		db	15 dup (0)
		db	1Fh
		db	15 dup (0)
		db	 7Fh, 00h
		db	14 dup (0)
		db	 7Fh, 00h
		db	78 dup (0)
		db	0FFh, 00h
		db	14 dup (0)
		db	0FFh, 00h
		db	142 dup (0)
		db	 35h, 28h, 2Eh, 07h, 5Bh, 02h
		db	 57h, 57h, 02h, 03h
		db	0, 0
data_a_0CBC	db	0			; Data table (indexed access)
		db	15 dup (0)
data_a_0CCC	db	0
		db	15 dup (0)
data_a_0CDC	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0CEC	dw	0
		db	14 dup (0)
data_a_0CFC	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0D0C	dw	0
		db	14 dup (0)
data_a_0D1C	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0D2C	dw	0
		db	14 dup (0)
data_a_0D3C	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0D4C	dw	0
		db	14 dup (0)
data_a_0D5C	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0D6C	dw	0
		db	14 dup (0)
data_a_0D7C	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0D8C	dw	0
		db	14 dup (0)
data_a_0D9C	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0DAC	dw	0
		db	14 dup (0)
data_a_0DBC	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0DCC	dw	0
		db	14 dup (0)
data_a_0DDC	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0DEC	dw	0
		db	14 dup (0)
data_a_0DFC	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0E0C	dw	0
		db	14 dup (0)
data_a_0E1C	db	0			; Data table (indexed access)
		db	15 dup (0)
data_a_0E2C	db	0
		db	15 dup (0)
data_a_0E3C	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_a_0E4C	dw	0
		db	14 dup (0)
data_a_0E5C	db	0			; Data table (indexed access)
		db	15 dup (0)
data_a_0E6C	db	0
		db	15 dup (0)
data_a_0E7C	db	0			; Data table (indexed access)
		db	15 dup (0)
data_a_0E8C	db	0
		db	15 dup (0)
data_a_0E9C	db	0
		db	15 dup (0)
data_a_0EAC	db	0
		db	15 dup (0)
data_a_0EBC	db	0
		db	15 dup (0)
data_a_0ECC	db	0
		db	15 dup (0)
data_a_0EDC	db	0
		db	15 dup (0)
data_a_0EEC	db	0
		db	15 dup (0)
data_a_0EFC	db	0
		db	15 dup (0)
data_a_0F0C	db	0
		db	15 dup (0)
data_a_0F1C	db	0			; Data table (indexed access)
		db	15 dup (0)
data_a_0F2C	db	0
		db	15 dup (0)
data_a_0F3C	db	0			; Data table (indexed access)
		db	63 dup (0)
data_a_0F7C	db	0
		db	15 dup (0)
data_a_0F8C	db	0
		db	15 dup (0)
data_a_0F9C	db	0
		db	15 dup (0)
data_a_0FAC	db	0
		db	15 dup (0)
data_a_0FBC	dw	0
		db	14 dup (0)
data_a_0FCC	dw	0
		db	14 dup (0)
data_a_0FDC	dw	0
		db	14 dup (0)
data_a_0FEC	dw	0
		db	14 dup (0)
data_a_0FFC	db	0
		db	15 dup (0)
data_a_100C	db	0
		db	15 dup (0)
data_a_101C	dw	0			; Data table (indexed access)
		db	62 dup (0)
data_a_105C	dw	0
data_a_105E	dw	0
data_a_1060	dw	0
		db	8 dup (0)
data_a_106A	dw	0
data_a_106C	dw	0
data_a_106E	dw	0
data_a_1070	dw	0
data_a_1072	dw	0
data_a_1074	dw	0
data_a_1076	db	0
data_a_1077	db	0
		db	0
data_a_1079	db	0
data_a_107A	db	0
		db	0, 0
data_a_107D	db	0
data_a_107E	db	0
data_a_107F	db	0
data_a_1080	db	0
data_a_1081	dw	0
data_a_1083	dw	0
data_a_1085	dw	0			; Data table (indexed access)
		db	366 dup (0)
data_a_11F5	dw	0
		db	14 dup (0)
data_a_1205	dw	0
		db	25 dup (0)
data_a_1220	db	20h			; Data table (indexed access)
		db	 1Eh, 2Eh, 2Ch, 10h, 12h, 1Fh
		db	 11h
		db	2Dh
data_a_1229	db	'MKQOGILHP'		; Data table (indexed access)
data_a_1232	dw	14 dup (8080h)		; Data table (indexed access)
		db	80h
data_a_124F	db	80h
		db	26 dup (80h)
data_a_126A	db	80h
		db	 80h, 80h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_126D	proc	near
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],80h
		add	byte ptr ds:d_0009_8080_e[bx+si],0
		db	18 dup (0)
		db	 10h, 00h, 1Ch, 00h, 18h, 00h
		db	10 dup (0)
		db	 18h, 00h, 30h, 00h, 24h, 00h
		db	 18h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 1Ch, 00h, 20h, 00h
		db	 52h, 00h, 42h, 00h, 2Ch, 00h
		db	 08h, 00h, 00h, 00h, 00h, 00h
		db	 30h, 00h, 42h, 00h, 0Ch, 00h
		db	 00h, 00h, 72h, 00h, 0Ch, 00h
		db	 00h, 00h, 18h, 00h, 04h, 00h
		db	 50h, 00h, 83h, 00h, 11h, 00h
		db	 48h, 00h, 08h, 00h, 18h, 00h
		db	 04h, 00h, 72h, 00h, 80h, 00h
		db	 25h, 00h, 10h, 00h,0D1h, 00h
		db	 02h, 00h, 20h, 00h, 42h, 00h
		db	 81h, 00h, 24h, 00h, 00h, 00h
		db	 00h, 00h, 08h, 00h, 01h, 00h
		db	 48h, 00h, 0Ah, 00h, 81h, 00h
		db	 00h, 00h, 85h, 00h,0A5h, 00h
		db	 08h, 00h, 01h, 00h, 52h, 00h
		db	 00h, 00h, 00h, 00h, 00h,0E0h
		db	 07h, 1Ch, 38h, 02h, 0Ch,0C1h
		db	 07h, 3Fh, 04h, 3Fh, 04h,0C1h
		db	 07h, 02h, 0Ch, 1Ch, 38h,0E0h
		db	 07h
		db	12 dup (0)
		db	0E0h, 0Fh, 1Ch, 1Ch, 02h, 0Eh
		db	0C1h, 07h, 21h, 04h, 3Dh, 0Ch
		db	0FFh, 1Bh, 06h, 70h, 1Ch, 38h
		db	0E0h, 07h
		db	12 dup (0)
		db	0E0h, 01h, 9Ch, 01h, 82h, 01h
		db	0C1h, 03h, 21h, 04h, 21h,0FCh
		db	0F9h, 83h, 3Eh, 40h, 1Ch, 38h
		db	0E0h, 07h
		db	12 dup (0)
		db	 60h, 00h, 7Ch, 00h, 62h, 40h
		db	0C1h,0FFh, 21h, 8Ch, 21h, 84h
		db	0E1h, 83h,0E2h, 41h,0FCh, 39h
		db	0E0h, 07h
		db	14 dup (0)
		db	 0Ch, 30h, 32h, 4Ch,0E1h, 87h
		db	 21h, 84h, 21h, 84h,0C1h, 83h
		db	0C2h, 43h,0DCh

locloop_a_13D7:
		cmp	sp,ax
		pop	es
		db	13 dup (0)
		db	 06h, 00h, 3Eh, 02h, 46h,0FFh
		db	 83h, 31h, 84h, 21h, 84h,0C1h
		db	 87h, 82h, 47h, 9Ch

locloop_a_13F7:
		aas				; Ascii adjust
;*		loopnz	locloop_a_1401		;*Loop if zf=0, cx>0

		db	0E0h, 07h		;  Fixup - byte match
		db	0, 0, 0, 0, 0, 0
		db	0
		db	 00h, 00h, 00h, 00h, 00h, 80h
		db	 07h, 80h, 39h, 80h, 41h,0C0h
		db	 83h, 20h, 84h, 3Fh, 84h,0C1h
		db	 9Fh, 02h, 7Ch, 1Ch, 38h,0E0h
		db	 07h
		db	12 dup (0)
		db	0F0h, 07h, 38h, 38h, 70h, 40h
		db	0E0h, 83h, 20h, 84h, 30h,0BCh
		db	0D8h,0FFh, 0Eh, 60h, 1Ch, 38h
		db	0E0h, 07h
		db	12 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 30h, 40h
		db	0E0h, 83h, 20h,0FCh, 20h,0FCh
		db	0E0h, 83h, 30h, 40h, 1Ch, 38h
		db	0E0h, 07h
		db	12 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 0Eh, 60h
		db	0D8h,0FFh, 30h,0BCh, 20h, 84h
		db	0E0h, 83h, 70h, 40h, 38h, 38h
		db	0F0h, 07h
		db	12 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 02h, 7Ch
		db	0C1h, 9Fh, 3Fh, 84h, 20h, 84h
		db	0C0h, 83h, 80h, 41h, 80h, 39h
		db	 80h, 07h, 00h
		db	11 dup (0)
		db	0E0h, 07h, 9Ch, 3Fh, 82h, 47h
		db	0C1h, 87h, 21h, 84h, 31h, 84h
		db	0FFh, 83h, 02h
		db	46h
loc_a_14B6:
		add	ds:d_0009_0600_e,bh
		db	12 dup (0)
		db	0E0h, 07h,0DCh, 3Bh,0C2h, 43h
		db	0C1h, 83h, 21h, 84h, 21h, 84h
		db	0E1h, 87h
		db	 32h, 4Ch, 0Ch, 30h
		db	14 dup (0)
		db	0E0h, 07h,0FCh, 39h,0E2h, 41h
		db	0E1h, 83h, 21h, 84h, 21h, 8Ch
		db	0C1h,0FFh, 62h, 40h, 7Ch, 00h
		db	60h
		db	13 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 3Eh, 40h
		db	0F9h, 83h, 21h,0FCh, 21h, 04h
		db	0C1h, 03h, 82h, 01h, 9Ch, 01h
		db	0E0h, 01h, 00h
		db	11 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 06h, 70h
		db	0FFh, 1Bh, 3Dh, 0Ch, 21h, 04h
		db	0C1h, 07h, 02h, 0Eh, 1Ch, 1Ch
		db	0E0h, 0Fh
		db	12 dup (0)
		db	0E0h, 07h, 00h

locloop_a_1549:
		cmp	[bx+si],al
		inc	ax
		rol	byte ptr ss:d_10CD_FE60_e[bp+di],60h	; '`' Rotate
		inc	al
		add	word ptr [bx+si],40h
		add	[bx+si],bh
;*		loopnz	locloop_a_1561		;*Loop if zf=0, cx>0

		db	0E0h, 07h		;  Fixup - byte match
		db	0, 0, 0, 0, 0, 0
		db	0
		db	 00h, 00h, 00h, 00h, 00h,0E0h
		db	 07h, 1Ch, 38h, 00h, 60h,0C0h
		db	0FFh, 60h,0BEh, 60h, 86h,0C0h
		db	 83h, 00h, 40h, 00h, 38h, 00h
		db	 07h
		db	12 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 02h, 7Ch
		db	0C0h, 9Fh, 60h, 86h, 60h, 86h
		db	0C0h, 83h, 00h, 40h, 00h, 38h
		db	 00h, 04h, 00h
		db	11 dup (0)
		db	0E0h, 07h, 9Ch, 3Fh, 82h, 47h
		db	0C1h, 87h, 61h, 86h, 61h, 86h
		db	0C0h, 83h, 00h, 40h, 00h
		db	15 dup (0)
		db	0E0h, 07h,0DCh, 3Bh,0C2h, 43h
		db	0C1h, 83h, 61h, 86h, 61h, 86h
		db	0C1h, 83h, 00h, 00h
		db	16 dup (0)
		db	0E0h, 07h,0FCh, 39h,0E2h, 41h
		db	0E1h, 83h, 61h, 86h, 61h, 86h
		db	0C1h, 03h, 02h
		db	17 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 3Eh, 40h
		db	0F9h, 03h, 61h, 06h, 61h, 06h
		db	0C1h, 03h, 02h, 00h, 1Ch, 00h
		db	20h
		db	13 dup (0)
		db	0E0h, 07h, 1Ch, 38h, 06h, 00h
		db	0FFh, 03h, 7Dh, 06h, 61h, 06h
		db	0C1h, 03h, 02h, 00h, 1Ch, 00h
		db	0E0h
		db	13 dup (0)
		db	0E0h, 07h, 1Ch, 00h, 02h, 00h
		db	0C1h, 03h, 7Fh, 06h, 7Fh, 06h
		db	0C1h, 03h, 02h, 00h, 1Ch, 00h
loc_a_1658:
;*		loopnz	locloop_a_1661		;*Loop if zf=0, cx>0

		db	0E0h, 07h		;  Fixup - byte match
		db	0, 0, 0, 0, 0, 0
		db	0
		db	 00h, 00h, 00h, 00h, 00h,0E0h
		db	 00h, 1Ch, 00h, 02h, 00h,0C1h
		db	 03h, 61h, 06h, 7Dh, 06h,0FFh
		db	 03h, 06h, 00h, 1Ch
		db	38h
loc_a_1678:
;*		loopnz	locloop_a_1681		;*Loop if zf=0, cx>0

		db	0E0h, 07h		;  Fixup - byte match
		db	0, 0, 0, 0, 0, 0
		db	0
		db	 00h, 00h, 00h, 00h, 00h, 20h
		db	 00h, 1Ch, 00h, 02h, 00h,0C1h
		db	 03h, 61h, 06h, 61h, 06h,0F9h
		db	 03h, 3Eh, 40h, 1Ch, 38h,0E0h
		db	 07h
		db	16 dup (0)
		db	 02h, 00h,0C1h, 03h, 61h, 86h
		db	 61h, 86h,0E1h, 83h,0E2h, 41h
		db	0FCh, 39h,0E0h, 07h
		db	18 dup (0)
		db	0C1h, 83h, 61h, 86h, 61h, 86h
		db	0C1h, 83h,0C2h, 43h,0DCh, 3Bh
		db	0E0h, 07h
		db	17 dup (0)
		db	 40h,0C0h, 83h, 61h, 86h, 61h
		db	 86h,0C1h, 87h, 82h, 47h, 9Ch
		db	 3Fh,0E0h, 07h
		db	13 dup (0)
		db	 04h, 00h, 38h, 00h, 40h,0C0h
		db	 83h, 60h, 86h, 60h, 86h,0C0h
		db	 9Fh, 02h, 7Ch, 1Ch, 38h,0E0h
		db	 07h
		db	13 dup (0)
		db	 07h, 00h, 38h, 00h, 40h,0C0h
		db	 83h, 60h, 86h, 60h,0BEh,0C0h
		db	0FFh, 00h, 60h, 1Ch, 38h,0E0h
		db	 07h
		db	9 dup (0)
		db	0C0h, 00h, 3Eh, 00h, 3Eh, 00h
		db	0C0h
		db	7 dup (0)
		db	 20h, 00h, 20h, 00h,0F0h, 00h
		db	 38h
		db	9 dup (0)
		db	 48h, 00h, 78h, 00h, 30h, 00h
		db	 30h, 00h, 30h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 10h, 00h
		db	 10h, 00h, 3Ch, 00h, 70h, 00h
		db	60h
		db	9 dup (0)
		db	 03h, 00h, 7Ch, 00h, 7Ch, 00h
		db	 03h, 00h
		db	8 dup (0)
		db	 60h, 00h, 70h, 00h, 3Ch, 00h
		db	 10h, 00h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 30h, 00h
		db	 30h, 00h, 30h, 00h, 78h, 00h
		db	48h
		db	7 dup (0)
		db	 18h, 00h, 38h, 00h,0F0h, 00h
		db	 20h, 00h, 20h, 00h, 00h, 00h
		db	 00h, 00h, 40h, 00h, 30h, 00h
		db	 1Ch, 00h, 1Ch, 00h, 30h, 00h
		db	40h
		db	7 dup (0)
		db	 0Ch, 00h, 0Ch, 00h, 06h, 00h
		db	 76h, 00h, 1Eh
		db	7 dup (0)
		db	0C6h, 00h, 6Ch, 00h, 7Ch, 00h
		db	 38h, 00h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 60h, 00h
		db	 60h, 00h,0C0h, 00h,0DCh, 00h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 0Ch, 00h, 38h, 00h,0F0h, 00h
		db	0F0h, 00h, 38h, 00h, 0Ch, 00h
		db	 00h, 00h, 00h, 00h,0F0h, 00h
		db	0DCh, 00h,0C0h, 00h, 60h, 00h
		db	60h
		db	7 dup (0)
		db	 10h, 00h, 38h, 00h, 7Ch, 00h
		db	 6Ch, 00h,0C6h
		db	7 dup (0)
		db	 1Eh, 00h, 76h, 00h, 06h, 00h
		db	 0Ch, 00h
		db	0Ch
		db	0, 0, 0, 0, 0, 0
data_a_1840	db	0
		db	31 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0F0h,0FFh,0C0h, 40h, 80h, 03h
		db	 7Fh, 80h, 00h,0FCh, 80h, 40h
		db	 00h, 00h, 00h
		db	3Fh
		db	58 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 10h, 18h, 08h, 00h, 0Fh, 10h
		db	0F0h,0FFh, 10h, 08h, 80h, 03h
		db	0FFh, 07h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 02h, 41h
		db	 02h, 00h, 01h, 3Eh,0FCh,0FFh
		db	 01h, 11h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 1Fh, 80h
		db	 01h, 80h, 20h, 80h, 01h, 40h
		db	0C0h,0FFh,0FFh, 3Fh, 20h, 40h
		db	 02h, 40h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 02h, 40h, 02h, 04h
		db	0FCh,0FFh,0FFh, 03h, 02h, 80h
		db	 01h, 04h, 01h, 80h, 01h,0F8h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 88h, 40h,0FFh, 3Fh
		db	 7Ch, 80h, 00h, 40h, 82h, 40h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h,0E0h,0FFh,0C0h, 01h
		db	 10h, 08h,0FFh, 0Fh, 08h,0F0h
		db	 00h, 10h, 18h, 08h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	58 dup (0)
		db	0FCh, 00h, 00h, 00h, 02h, 01h
		db	 3Fh, 00h, 01h,0FEh,0C0h, 01h
		db	 02h, 03h,0FFh, 0Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
data_a_1C1C	db	3Fh
		db	 00h, 00h,0FCh
		db	58 dup (0)
		db	0FCh, 00h, 00h, 00h, 02h, 01h
		db	 3Fh, 00h, 01h,0FEh,0C0h, 01h
		db	 82h, 03h,0FFh, 0Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h,0E0h,0FFh,0C0h, 01h
		db	 90h, 03h,0FFh, 0Fh,0F8h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 0Fh
		db	0F0h,0FFh,0C0h, 01h, 80h, 03h
		db	 3Fh, 00h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 1Fh
		db	0F0h,0FFh,0C0h, 09h, 80h, 03h
		db	0FFh, 07h, 00h,0FCh
		db	64 dup (0)
		db	 3Fh, 00h, 00h,0FCh,0C0h, 01h
		db	 80h, 03h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0FCh,0FFh, 00h, 40h, 02h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 80h
		db	 01h, 00h, 00h, 80h, 01h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 40h
		db	 02h, 00h,0FFh, 3Fh,0FCh,0FFh
		db	 00h, 10h, 08h, 00h,0FFh, 3Fh
		db	0F0h,0FFh,0C0h, 41h, 80h, 03h
		db	 7Fh, 80h, 00h,0FCh, 80h, 40h
		db	 00h, 00h, 00h
		db	3Fh
		db	26 dup (0)
data_a_2040	db	0
data_a_2041	db	0
		db	8 dup (0)
		db	0, 0, 0, 0, 0, 0
data_a_2050	dw	0			; Data table (indexed access)
		db	 24h, 03h, 48h, 06h, 6Ah, 09h
		db	 8Ch, 0Ch,0ABh, 0Fh,0C8h, 12h
		db	0E2h, 15h,0F9h
loc_a_2061:
		sbb	[bp+di],cl
		sbb	al,1Ah
		pop	ds
		and	sp,[bp+si]
		sub	[di],ah
loc_a_206A:
		sub	es:[bx],bl
		sub	dx,[bx+di]
		db	 2Eh,0FBh
loc_a_2071:
;*		xor	bh,bl
		db	 30h,0DFh		;  Fixup - byte match
		xor	di,ss:d_10CD_8C36_e[bp+si]
		cmp	[bp+3Ch],dx
		pop	ss
		aas				; Ascii adjust
		into				; Int 4 on overflow
		inc	cx
		jp	$+46h			; Jump if parity=1
		sbb	al,47h			; 'G'
		mov	ah,49h			; 'I'
		aas				; Ascii adjust
		dec	sp
		mov	di,d_0000_334E_e
		push	cx
		db	 9Bh, 53h,0F5h, 55h, 42h, 58h
		db	 82h, 5Ah,0B3h, 5Ch,0D7h, 5Eh
		db	0EBh, 60h,0F1h, 62h,0E8h, 64h
		db	0CFh, 66h,0A6h
		db	 68h, 6Dh, 6Ah
loc_a_20A2:
		and	bp,[si-37h]
		insw				; Port dx to es:[di]
		pop	si
		outsw				; Out [si] to port dx
		loop	locloop_a_211A		; Loop if cx > 0

loc_a_20AA:
		push	sp
;*		jc	loc_a_2062		;*Jump if carry Set
		db	 72h,0B5h		;  Fixup - byte match
		jnc	$+6			; Jump if carry=0
;*		jnz	loc_a_20F2		;*Jump if not zero
		db	 75h, 41h		;  Fixup - byte match
		jbe	loc_a_211E		; Jump if below or =
;*		ja	loc_a_2039		;*Jump if above
		db	 77h, 84h		;  Fixup - byte match
;*		js	loc_a_2040		;*Jump if sign=1
		db	 78h, 89h		;  Fixup - byte match
		jns	loc_a_2135		; Jump if not sign
;*		jp	loc_a_2117		;*Jump if parity=1
		db	 7Ah, 5Ch		;  Fixup - byte match
;*		jnp	loc_a_20E6		;*Jump if not parity
		db	 7Bh, 29h		;  Fixup - byte match
		jl	loc_a_20A2		; Jump if <
;*		jl	loc_a_204A		;*Jump if <
		db	 7Ch, 89h		;  Fixup - byte match
;*		jge	loc_a_20E0		;*Jump if > or =
		db	 7Dh, 1Dh		;  Fixup - byte match
		jle	loc_a_2061		; Jump if < or =
		jle	$+0Bh			; Jump if < or =
;*		jg	loc_a_212A		;*Jump if >
		db	 7Fh, 61h		;  Fixup - byte match
		jg	loc_a_2071		; Jump if >
		jg	$-26h			; Jump if >
		jg	$-9			; Jump if >
		db	 7Fh,0FFh, 7Fh,0F5h, 7Fh,0D8h
		db	 7Fh,0A6h, 7Fh, 61h, 7Fh
		db	9
loc_a_20DB:
;*		jg	loc_a_2079		;*Jump if >
		db	 7Fh, 9Ch		;  Fixup - byte match
		jle	loc_a_20FC		; Jump if < or =
		jle	loc_a_206A		; Jump if < or =
;*		jge	loc_a_20C6		;*Jump if > or =
		db	 7Dh,0E3h		;  Fixup - byte match
		jl	loc_a_210E		; Jump if <
		jl	$+5Eh			; Jump if <
		jnp	loc_a_2165		; Jump if not parity
;*		jp	loc_a_2074		;*Jump if parity=1
		db	 7Ah, 89h		;  Fixup - byte match
		jns	loc_a_2071		; Jump if not sign
;*		js	loc_a_215A		;*Jump if sign=1
		db	 78h, 6Bh		;  Fixup - byte match
;*		ja	loc_a_2132		;*Jump if above
		db	 77h, 41h		;  Fixup - byte match
		jbe	loc_a_20F7		; Jump if below or =
		jnz	loc_a_20AA		; Jump if not zero
		jnc	$+56h			; Jump if carry=0
loc_a_20F7:
		jc	loc_a_20DB		; Jump if carry Set
		jo	loc_a_2159		; Jump if overflow=1
		outsw				; Out [si] to port dx
loc_a_20FC:
		leave				; Procedure exit
		insw				; Port dx to es:[di]
		and	bp,[si+6Dh]
		push	0FFA6h
		push	66CFh
		call	sub_a_126D
		db	 62h,0EBh, 60h,0D7h, 5Eh
loc_a_210E:
		mov	bl,5Ch			; '\'
;*		sbb	byte ptr [bp+si+42h],58h	; 'X'
		db	 82h, 5Ah, 42h, 58h	;  Fixup - byte match
		cmc				; Complement carry
		push	bp
		db	 9Bh, 53h, 33h, 51h

locloop_a_211A:
		mov	di,3F4Eh
		dec	sp
loc_a_211E:
		mov	ah,49h			; 'I'
		sbb	al,47h			; 'G'
;*		jp	loc_a_2168		;*Jump if parity=1
		db	 7Ah, 44h		;  Fixup - byte match
		into				; Int 4 on overflow
		inc	cx
		pop	ss
		aas				; Ascii adjust
		push	si
		cmp	al,8Ch
		cmp	ss:d_0000_DF36_e[bp+si],di
		xor	di,bx
		xor	[bx+di],dl
		db	 2Eh, 1Fh
loc_a_2135:
		sub	sp,ds:d_0000_2828_e
		and	ax,2223h
		sbb	bl,[bx]
loc_a_213E:
		or	bx,[si]
		stc				; Set carry flag
;*		sbb	dl,ah
		db	 18h,0E2h		;  Fixup - byte match
		adc	ax,12C8h
		stosw				; Store ax to es:[di]
		db	 0Fh, 8Ch, 0Ch, 6Ah, 09h, 48h
		db	 06h, 24h, 03h, 00h, 00h,0DCh
		db	0FCh,0B8h,0F9h, 96h,0F6h
		db	74h
loc_a_2159:
		db	0F3h, 55h,0F0h, 38h,0EDh, 1Eh
		db	0EAh, 07h,0E7h,0F5h,0E3h,0E6h
loc_a_2165:
;*		loopnz	locloop_a_2144		;*Loop if zf=0, cx>0

		db	0E0h,0DDh		;  Fixup - byte match

;		fstp	qword ptr ds:d_0000_DADA_e[bx+si]	; Pop st to memory
		db	0ddh, 0d8h, 0dah, 0dah

		xlat				; al=[al+[bx]] table
;*		loopz	locloop_a_2142		;*Loop if zf=1, cx>0

		db	0E1h,0D4h		;  Fixup - byte match
		out	dx,ax			; port 44h ??i/o non-standard
		rol	word ptr [di],1		; Rotate
		iret				; Interrupt return
sub_a_126D	endp

			                        ;* No entry point to code
;*		and	sp,cx
		db	 21h,0CCh		;  Fixup - byte match
		inc	si
		leave				; Procedure exit
		jz	loc_a_213E		; Jump if zero
		stosb				; Store al to es:[di]
		retn
			                        ;* No entry point to code
		jmp	$+32C3h
			                        ;* No entry point to code
		mov	si,data_a_BB86_e
		in	al,0B8h			; port 0B8h ??i/o non-standard
		dec	bp
		mov	dh,0C1h
		mov	bl,41h			; 'A'
		mov	cl,0CDh
		scasb				; Scan es:[di] for al
		db	 65h,0ACh, 0Bh,0AAh,0BEh,0A7h
		db	 7Eh,0A5h, 4Dh,0A3h, 29h,0A1h
		db	 15h, 9Fh, 0Fh, 9Dh, 18h, 9Bh
		db	 31h, 99h, 5Ah, 97h, 93h, 95h
		db	0DDh, 93h, 37h, 92h,0A2h, 90h
		db	 1Eh, 8Fh,0ACh, 8Dh, 4Bh, 8Ch
		db	0FCh, 8Ah,0BFh, 89h, 95h, 88h
		db	 7Ch, 87h, 77h, 86h, 84h, 85h
		db	0A4h, 84h,0D7h, 83h, 1Dh, 83h
		db	 77h, 82h,0E3h, 81h, 64h, 81h
		db	0F7h, 80h, 9Fh, 80h, 5Ah, 80h
		db	 28h, 80h, 0Bh, 80h, 01h, 80h
		db	 0Bh, 80h, 28h, 80h, 5Ah, 80h
		db	 9Fh, 80h,0F7h, 80h, 64h, 81h
		db	0E3h, 81h, 77h, 82h, 1Dh, 83h
		db	0D7h, 83h,0A4h, 84h, 84h, 85h
		db	 77h, 86h, 7Ch, 87h, 95h, 88h
		db	0BFh, 89h,0FCh, 8Ah, 4Bh, 8Ch
		db	0ACh, 8Dh, 1Eh, 8Fh,0A2h, 90h
		db	 37h, 92h,0DDh, 93h, 93h, 95h
		db	 5Ah, 97h, 31h, 99h, 18h, 9Bh
		db	 0Fh, 9Dh, 15h, 9Fh, 29h,0A1h
		db	 4Dh,0A3h, 7Eh,0A5h,0BEh,0A7h
		db	 0Bh,0AAh, 65h,0ACh,0CDh,0AEh
		db	 41h,0B1h,0C1h,0B3h, 4Ch,0B6h
		db	0E4h,0B8h, 86h,0BBh, 32h,0BEh
		db	0E9h,0C0h,0AAh,0C3h, 74h,0C6h
		db	 46h,0C9h, 21h,0CCh, 05h,0CFh
		db	0EFh,0D1h

locloop_a_2234:
		loopz	$-2Ah			; Loop if zf=1, cx>0

		db	0DAh,0D7h,0D8h,0DAh,0DDh,0DDh
		db	0E6h
loc_a_223D:
		loopnz	locloop_a_2234		; Loop if zf=0, cx>0

		jcxz	loc_a_2248		; Jump if cx=0
		out	1Eh,ax			; port 1Eh ??i/o non-standard
;*		jmp	far ptr l_F055_ED38	;*
		db	0EAh
		dw	0ED38h, 0F055h		;  Fixup - byte match
loc_a_2248:
		jz	loc_a_223D		; Jump if zero
		xchg	bp,ax
		idiv	byte ptr ds:data_a_DCF9_e[bx+si]	; al,ah rem = ax/data
		cld				; Clear direction
		add	[bx+si],al
		and	al,3
		dec	dx
		push	es
		jno	loc_a_2261		; Jump if not overflw
		db	 9Bh, 0Ch,0C9h, 0Fh,0FDh, 12h
		db	 36h, 16h
		db	76h
loc_a_2261:
		sbb	ss:data_a_101C[bp],di
		and	[si+23h],ch
;*		aam	26h			; '&' undocumented inst
		db	0D4h, 26h		;  Fixup - byte match
		dec	cx
		sub	cl,ah
		sub	ax,3160h
		add	ax,0BD35h
		cmp	ss:data_a_6E3C_e[bp+si],cl
		inc	ax
		push	44h
;*		or	byte ptr [bx+si-48h],4Ch	; 'L'
		db	 82h, 48h,0B8h, 4Ch	;  Fixup - byte match
		or	ax,8651h
		push	bp
		and	ax,0EE5Ah
		pop	si
		in	al,63h			; port 63h, 8255 mode reg
		or	bp,[bx+di+69h]
		outsb				; Out [si] to port dx
		add	dh,[si-23h]
		jns	$+2			; delay for I/O
		db	0
data_a_2292	db	0
		db	29 dup (0)
		db	 40h, 80h, 40h, 84h, 40h, 8Ch
		db	 40h, 84h, 40h, 84h, 40h, 8Eh
		db	 40h, 80h,0C0h,0FFh, 40h, 80h
		db	 40h, 9Eh, 40h,0A1h, 40h, 86h
		db	 40h, 98h, 40h,0BFh, 40h, 80h
		db	0C0h,0FFh, 40h, 80h, 40h,0BEh
		db	 40h, 81h, 40h, 8Eh, 40h, 81h
		db	 40h,0BEh, 40h, 80h,0C0h,0FFh
		db	 40h, 80h, 40h, 86h, 40h, 8Ah
		db	 40h, 92h, 40h,0BFh, 40h, 82h
		db	 40h, 80h,0C0h,0FFh, 40h, 80h
		db	 40h,0BFh, 40h,0A0h, 40h,0BEh
		db	 40h, 81h, 40h,0BEh, 40h, 80h
		db	0C0h,0FFh, 40h, 80h, 40h, 9Eh
		db	 40h,0A0h, 40h,0BEh, 40h,0A1h
		db	 40h, 9Eh, 40h, 80h,0C0h,0FFh
		db	 40h, 80h, 40h,0BFh, 40h, 82h
		db	 40h, 84h, 40h, 88h, 40h, 90h
		db	 40h, 80h,0C0h,0FFh
		db	14 dup (0)
		db	0C0h,0FFh, 00h, 80h, 00h, 80h
		db	 00h, 80h, 00h, 80h, 00h, 80h
		db	 00h, 80h, 00h, 80h, 00h, 80h
		db	16 dup (0)
		db	 40h, 00h, 40h, 00h, 40h, 00h
		db	 40h, 00h, 40h, 00h, 40h, 00h
		db	 40h, 00h, 40h, 00h,0C0h,0FFh
		db	0C0h,0FFh,0C0h,0FFh,0C0h,0FFh
		db	0C0h,0FFh,0C0h,0FFh,0C0h,0FFh
		db	 00h
		db	17 dup (0)
		db	16 dup (0FFh)
		db	 03h, 00h, 0Fh, 00h, 3Fh, 00h
		db	0FFh, 00h,0FFh, 03h,0FFh, 0Fh
		db	0FFh, 3Fh,0FFh,0FFh, 00h,0C0h
		db	 00h,0F0h, 00h,0FCh, 00h,0FFh
		db	0C0h,0FFh,0F0h,0FFh,0FCh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FCh,0FFh
		db	0F0h,0FFh,0C0h,0FFh, 00h,0FFh
		db	 00h,0FCh, 00h,0F0h, 00h,0C0h
		db	0FFh,0FFh,0FFh, 3Fh,0FFh, 0Fh
		db	0FFh, 03h,0FFh, 00h, 3Fh, 00h
		db	 0Fh, 00h, 03h
		db	16 dup (0)
		db	 80h, 00h, 33h, 00h, 33h, 00h
		db	0F3h, 00h, 03h, 00h, 03h, 00h
		db	0F3h, 00h, 33h, 00h, 33h, 00h
		db	 33h, 00h, 33h, 00h, 33h, 00h
		db	 33h, 00h, 33h, 00h, 33h, 00h
		db	 33h, 00h, 33h, 00h, 00h, 00h
		db	 00h, 00h,0FFh, 00h, 03h, 00h
		db	 03h, 00h,0F3h, 00h, 33h, 00h
		db	 33h, 00h, 33h, 00h, 33h, 00h
		db	0F3h, 00h, 03h, 00h, 03h, 00h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 33h, 00h, 33h,0C0h, 33h, 00h
		db	 30h, 00h, 30h,0C0h
		db	3Fh
		db	8 dup (0)
		db	0C0h, 3Fh, 00h, 30h, 00h, 30h
		db	0C0h, 33h, 00h, 33h, 00h, 33h
		db	 00h, 33h, 00h, 33h,0C0h,0F3h
		db	 00h, 00h, 00h, 00h,0C0h,0FFh
		db	 00h
		db	7 dup (0)
		db	0C0h,0FFh, 00h, 00h, 00h, 00h
		db	0C0h,0F3h, 00h, 33h, 00h, 33h
		db	 00h, 33h, 00h, 33h,0C0h, 33h
		db	 00h, 30h, 00h, 30h,0C0h, 33h
		db	 00h, 33h, 00h, 33h, 00h, 00h
		db	 00h, 00h,0C0h,0FFh, 00h, 00h
		db	 00h, 00h,0C0h,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 33h, 00h, 33h
		db	0C0h,0F3h, 00h, 00h, 00h, 00h
		db	0C0h,0F3h, 00h, 33h, 00h
		db	33h
		db	33 dup (0)
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 00h, 00h
		db	 0Ch, 00h, 00h, 00h, 33h, 00h
		db	 33h, 00h
		db	12 dup (0)
		db	 33h, 00h, 33h, 80h, 7Fh, 00h
		db	 33h, 80h, 7Fh, 00h, 33h, 00h
		db	 33h, 00h, 00h, 00h, 0Ch, 80h
		db	 3Fh, 00h, 6Ch, 00h, 3Fh, 80h
		db	 0Dh, 00h, 7Fh, 00h, 0Ch, 00h
		db	 00h, 80h, 71h, 00h, 53h, 00h
		db	 76h, 00h, 0Ch, 80h, 1Bh, 80h
		db	 32h, 80h, 63h, 00h, 00h, 00h
		db	 3Ch, 00h, 66h, 00h, 3Ch, 80h
		db	 39h, 00h, 6Fh, 00h, 6Fh, 80h
		db	 3Dh, 00h, 00h, 00h, 18h, 00h
		db	 30h, 00h, 60h, 00h
		db	10 dup (0)
		db	 0Ch, 00h, 18h, 00h, 30h, 00h
		db	 30h, 00h, 30h, 00h, 18h, 00h
		db	 0Ch, 00h, 00h, 00h, 0Ch, 00h
		db	 06h, 00h, 03h, 00h, 03h, 00h
		db	 03h, 00h, 06h, 00h, 0Ch, 00h
		db	 00h, 00h, 0Ch, 80h, 6Dh, 00h
		db	 3Fh, 00h, 1Eh, 00h, 3Fh, 80h
		db	 6Dh, 00h, 0Ch, 00h, 00h, 00h
		db	 00h, 00h, 0Ch, 00h, 0Ch, 80h
		db	 7Fh, 00h, 0Ch, 00h
		db	0Ch
		db	13 dup (0)
		db	 0Ch, 00h, 0Ch, 00h, 18h, 00h
		db	7 dup (0)
		db	 80h, 7Fh, 00h, 00h
		db	15 dup (0)
		db	 0Ch, 00h, 0Ch, 00h, 00h, 00h
		db	 00h, 80h, 01h, 00h, 03h, 00h
		db	 06h, 00h, 0Ch, 00h, 18h, 00h
		db	 30h, 00h, 60h, 00h, 00h, 00h
		db	 3Fh, 80h, 63h, 80h, 67h, 80h
		db	 6Dh, 80h, 79h, 80h, 71h, 00h
		db	 3Fh, 00h, 00h, 00h, 0Ch, 00h
		db	 1Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 1Eh, 00h
		db	 00h, 00h, 3Fh, 80h, 61h, 80h
		db	 01h, 00h, 0Fh, 00h, 38h, 00h
		db	 60h, 80h, 7Fh, 00h, 00h, 00h
		db	 3Fh, 80h, 61h, 80h, 01h, 00h
		db	 0Fh, 80h, 01h, 80h, 61h, 00h
		db	 3Fh, 00h, 00h, 00h, 07h, 00h
		db	 0Fh, 00h, 1Bh, 00h, 33h, 80h
		db	 7Fh, 00h, 03h, 00h, 03h, 00h
		db	 00h, 80h, 7Fh, 00h, 60h, 00h
		db	 60h, 00h, 7Fh, 80h, 01h, 80h
		db	 61h, 00h, 3Fh, 00h, 00h, 00h
		db	 1Fh, 00h, 30h, 00h, 60h, 00h
		db	 7Fh, 80h, 61h, 80h, 61h, 00h
		db	 3Fh, 00h, 00h, 80h, 7Fh, 80h
		db	 01h, 00h, 03h, 00h, 06h, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 00h, 00h, 3Fh, 80h, 61h, 80h
		db	 61h, 00h, 3Fh, 80h, 61h, 80h
		db	 61h, 00h, 3Fh, 00h, 00h, 00h
		db	 3Fh, 80h, 61h, 80h, 61h, 80h
		db	 3Fh, 80h, 01h, 00h, 03h, 00h
		db	3Eh
		db	7 dup (0)
		db	 0Ch, 00h, 0Ch, 00h, 00h, 00h
		db	 0Ch, 00h, 0Ch, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 00h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 18h, 00h, 06h, 00h
		db	 0Ch, 00h, 18h, 00h, 30h, 00h
		db	 18h, 00h, 0Ch, 00h, 06h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 3Fh, 00h, 00h, 00h
		db	3Fh
		db	7 dup (0)
		db	 18h, 00h, 0Ch, 00h, 06h, 00h
		db	 03h, 00h, 06h, 00h, 0Ch, 00h
		db	 18h, 00h, 00h, 00h, 3Fh, 80h
		db	 61h, 00h, 03h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 00h, 00h, 0Ch, 00h
		db	 00h, 00h, 3Fh, 80h, 61h, 80h
		db	 67h, 80h, 6Dh, 00h, 67h, 00h
		db	 60h, 00h, 3Fh, 00h, 00h, 00h
		db	 1Eh, 00h, 33h, 80h, 61h, 80h
		db	 7Fh, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 00h, 00h, 7Fh, 80h
		db	 61h, 80h, 61h, 00h, 7Fh, 80h
		db	 61h, 80h, 61h, 00h, 7Fh, 00h
		db	 00h, 00h, 3Fh, 80h, 61h, 00h
		db	 60h, 00h, 60h, 00h, 60h, 80h
		db	 61h, 00h, 3Fh, 00h, 00h, 00h
		db	 7Fh, 80h, 61h, 80h, 61h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 00h
		db	 7Fh, 00h, 00h, 80h, 7Fh, 00h
		db	 60h, 00h, 60h, 00h, 7Eh, 00h
		db	 60h, 00h, 60h, 80h, 7Fh, 00h
		db	 00h, 80h, 7Fh, 00h, 60h, 00h
		db	 60h, 00h, 7Eh, 00h, 60h, 00h
		db	 60h, 00h, 60h, 00h, 00h, 00h
		db	 3Fh, 80h, 61h, 00h, 60h, 80h
		db	 67h, 80h, 61h, 80h, 63h, 80h
		db	 3Fh, 00h, 00h, 80h, 61h, 80h
		db	 61h, 80h, 61h, 80h, 7Fh, 80h
		db	 61h, 80h, 61h, 80h, 61h, 00h
		db	 00h, 00h, 1Eh, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 1Eh, 00h, 00h, 80h
		db	 01h, 80h, 01h, 80h, 01h, 80h
		db	 01h, 80h, 61h, 80h, 61h, 00h
		db	 3Fh, 00h, 00h, 00h, 63h, 00h
		db	 66h, 00h, 6Ch, 00h, 78h, 00h
		db	 6Ch, 00h, 66h, 00h, 63h, 00h
		db	 00h, 00h, 60h, 00h, 60h, 00h
		db	 60h, 00h, 60h, 00h, 60h, 00h
		db	 60h, 80h, 7Fh, 00h, 00h, 80h
		db	 61h, 80h, 73h, 80h, 7Fh, 80h
		db	 6Dh, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 00h, 80h, 61h, 80h
		db	 71h, 80h, 79h, 80h, 6Dh, 80h
		db	 67h, 80h, 63h, 80h, 61h, 00h
		db	 00h, 00h, 3Fh, 80h, 61h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 3Fh, 00h, 00h, 00h
		db	 7Fh, 80h, 61h, 80h, 61h, 00h
		db	 7Fh, 00h, 60h, 00h, 60h, 00h
		db	 60h, 00h, 00h, 00h, 3Fh, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 6Dh, 00h, 66h, 00h, 3Bh, 00h
		db	 00h, 00h, 7Fh, 80h, 61h, 80h
		db	 61h, 00h, 7Fh, 00h, 63h, 80h
		db	 61h, 80h, 61h, 00h, 00h, 00h
		db	 3Fh, 80h, 61h, 00h, 60h, 00h
		db	 3Fh, 80h, 01h, 80h, 61h, 00h
		db	 3Fh, 00h, 00h, 80h, 7Fh, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 00h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 3Fh, 00h, 00h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 33h, 00h, 1Eh, 00h
		db	 0Ch, 00h, 00h, 80h, 61h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 6Dh, 80h, 7Fh, 00h, 33h, 00h
		db	 00h, 80h, 61h, 00h, 33h, 00h
		db	 1Eh, 00h, 0Ch, 00h, 1Eh, 00h
		db	 33h, 80h, 61h, 00h, 00h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 00h
		db	 3Fh, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 00h, 80h, 7Fh, 00h
		db	 03h, 00h, 06h, 00h, 0Ch, 00h
		db	 18h, 00h, 30h, 80h, 7Fh, 00h
		db	 00h, 00h, 1Eh, 00h, 18h, 00h
		db	 18h, 00h, 18h, 00h, 18h, 00h
		db	 18h, 00h, 1Eh, 00h, 00h, 00h
		db	 60h, 00h, 30h, 00h, 18h, 00h
		db	 0Ch, 00h, 06h, 00h, 03h, 80h
		db	 01h, 00h, 00h, 00h, 1Eh, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 1Eh, 00h
		db	 00h, 00h, 04h, 00h, 0Eh, 00h
		db	1Bh
		db	22 dup (0)
		db	 80h, 7Fh, 00h, 00h, 00h, 30h
		db	 00h, 18h, 00h
		db	0Ch
		db	15 dup (0)
		db	 3Fh, 80h, 61h, 80h, 61h, 80h
		db	 63h, 80h, 3Dh, 00h, 00h, 00h
		db	 60h, 00h, 60h, 00h, 7Fh, 80h
		db	 61h, 80h, 61h, 80h, 61h, 00h
		db	 7Fh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 3Fh, 80h, 60h, 00h
		db	 60h, 80h, 60h, 00h, 3Fh, 00h
		db	 00h, 80h, 01h, 80h, 01h, 80h
		db	 3Fh, 80h, 61h, 80h, 61h, 80h
		db	 61h, 80h, 3Fh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 3Fh, 80h
		db	 61h, 80h, 7Fh, 00h, 60h, 00h
		db	 3Fh, 00h, 00h, 00h, 1Fh, 80h
		db	 31h, 00h, 30h, 00h, 7Ch, 00h
		db	 30h, 00h, 30h, 00h, 30h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 80h
		db	 3Fh, 80h, 61h, 80h, 61h, 80h
		db	 3Fh, 80h, 01h, 00h, 3Fh, 00h
		db	 60h, 00h, 60h, 00h, 7Fh, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 00h, 00h, 0Ch, 00h
		db	 00h, 00h, 1Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 00h, 80h, 01h, 00h, 00h, 80h
		db	 03h, 80h, 01h, 80h, 01h, 80h
		db	 01h, 00h, 3Fh, 00h, 00h, 00h
		db	 60h, 00h, 60h, 00h, 66h, 00h
		db	 6Ch, 00h, 78h, 00h, 6Ch, 00h
		db	 66h, 00h, 00h, 00h, 1Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 7Fh, 80h, 6Dh, 80h, 6Dh, 80h
		db	 6Dh, 80h, 6Dh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 7Fh, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 3Fh, 80h, 61h, 80h
		db	 61h, 80h, 61h, 00h
		db	3Fh
		db	7 dup (0)
		db	 7Fh, 80h, 61h, 80h, 61h, 00h
		db	 7Fh, 00h, 60h, 00h, 60h, 00h
		db	 00h, 00h, 00h, 80h, 3Fh, 80h
		db	 61h, 80h, 61h, 80h, 3Fh, 80h
		db	 01h, 80h, 01h, 00h, 00h, 00h
		db	 00h, 00h, 5Fh, 80h, 71h, 00h
		db	 60h, 00h, 60h, 00h
		db	60h
		db	7 dup (0)
		db	 3Fh, 00h, 60h, 00h, 3Fh, 80h
		db	 01h, 00h, 3Fh, 00h, 00h, 00h
		db	 18h, 00h, 18h, 00h, 7Eh, 00h
		db	 18h, 00h, 18h, 00h, 18h, 00h
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 80h, 61h, 80h, 61h, 80h
		db	 61h, 80h, 61h, 80h, 3Fh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 80h
		db	 61h, 80h, 61h, 00h, 33h, 00h
		db	 1Eh, 00h, 0Ch, 00h, 00h, 00h
		db	 00h, 00h, 00h, 80h, 61h, 80h
		db	 61h, 80h, 6Dh, 80h, 7Fh, 00h
		db	 33h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 80h, 61h, 00h, 33h, 00h
		db	 1Eh, 00h, 33h, 80h, 61h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 80h
		db	 61h, 80h, 61h, 80h, 61h, 80h
		db	 3Fh, 80h, 01h, 00h, 3Fh, 00h
		db	 00h, 00h, 00h, 80h, 7Fh, 00h
		db	 03h, 00h, 0Ch, 00h, 30h, 80h
		db	 7Fh, 00h, 00h, 00h, 07h, 00h
		db	 0Ch, 00h, 0Ch, 00h, 38h, 00h
		db	 0Ch, 00h, 0Ch, 00h, 07h, 00h
		db	 00h, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 00h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 00h, 00h
		db	 38h, 00h, 0Ch, 00h, 0Ch, 00h
		db	 07h, 00h, 0Ch, 00h, 0Ch, 00h
		db	 38h, 00h, 00h, 00h, 00h, 80h
		db	 3Dh, 00h
		db	6Fh
		db	10 dup (0)
		db	0F0h, 0Fh, 0Ch, 30h,0C6h, 63h
		db	 03h,0C6h, 03h,0C6h,0C6h, 63h
		db	 0Ch, 30h,0F0h, 0Fh
data_a_2AA0	db	0			; Data table (indexed access)
data_a_2AA1	db	0			; Data table (indexed access)
data_a_2AA2	db	0
data_a_2AA3	db	0
data_a_2AA4	db	0
data_a_2AA5	db	0
		db	10 dup (0)

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_b


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


SPACEWAR	proc	far

start:
		mov	ax,ds
		mov	word ptr cs:data_b_00B8+2,ax
		mov	ax,seg_a
		mov	ds,ax
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		assume	ds:seg_a
		mov	data_a_005F,al
		mov	dx,3BFh
		mov	al,0
		out	dx,al			; port 3BFh, Hercules config
		mov	ax,0B800h
		mov	data_a_1060,ax
		mov	es,ax
		mov	bx,0
		xor	di,di			; Zero register
		mov	dx,1000h
loc_b_0028:
		mov	es:[di],di
		add	di,dx
		cmp	di,d_B800_4000_e
		jne	loc_b_0028		; Jump if not equal
		sub	di,dx
loc_b_0035:
		cmp	es:[di],di
		jne	loc_b_00A6		; Jump if not equal
		sub	di,dx
		jnc	loc_b_0035		; Jump if carry=0
		mov	ax,40h
		mov	es,ax
		mov	byte ptr es:d_0040_0040_e,0
		and	byte ptr es:d_0040_003F_e,0F0h
		mov	al,0Ch
		mov	dx,3F2h
		out	dx,al			; port 3F2h, dsk0 contrl output
		cli				; Disable interrupts
		mov	ax,ss
		mov	data_a_0064,ax
		mov	word ptr data_a_0061+1,sp
		mov	ax,seg_a
		mov	ss,ax
		mov	sp,166h
		call	sub_b_1EBC
		mov	al,36h			; '6'
		out	43h,al			; port 43h, 8253 timer control
		mov	al,6
		out	40h,al			; port 40h, 8253 timer 0 clock
		mov	al,40h			; '@'
		out	40h,al			; port 40h, 8253 timer 0 clock
		mov	si,d_0040_0024_e
		mov	ax,1F80h
		mov	es:[si],ax
		mov	es:[si+2],cs
		sti				; Enable interrupts
		call	sub_b_1EA0
		call	sub_b_1F5C
		call	sub_b_2916
		mov	data_a_2292,1
		jmp	loc_b_0940
loc_b_0095:
		cli				; Disable interrupts
		call	sub_b_1EE2
		mov	sp,word ptr data_a_0061+1
		mov	ax,data_a_0064
		mov	ss,ax
		sti				; Enable interrupts
		mov	bx,44h
loc_b_00A6:
		push	bx
		xor	ah,ah			; Zero register
		mov	al,data_a_005F
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		pop	dx
		mov	ah,9
		int	21h			; DOS Services  ah=function 09h
						;  display char string at ds:dx
		jmp	dword ptr cs:data_b_00B8
data_b_00B8	dw	0, 0
loc_b_00BC:
		mov	sp,166h
		mov	data_a_0170,0
		call	sub_b_1F29
		call	sub_b_1F70
		call	sub_b_1F14
loc_b_00CD:
		cmp	data_a_0F7C,14h
		jne	loc_b_00DB		; Jump if not equal
		call	sub_b_1FE0
		dec	data_a_0F7C
loc_b_00DB:
		test	byte ptr data_a_0E3C,0FFh
		jz	loc_b_00EE		; Jump if zero
		js	loc_b_0107		; Jump if sign=1
		call	sub_b_024F
		test	data_a_0EBC,2
		jz	loc_b_00F4		; Jump if zero
loc_b_00EE:
		call	sub_b_1B8E
		jmp	short loc_b_0107
		db	90h
loc_b_00F4:
		test	data_a_0E1C,0FFh
		jz	loc_b_0104		; Jump if zero
		call	sub_b_1B8E
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
		call	sub_b_022E
loc_b_0104:
		call	sub_b_1B7E
loc_b_0107:
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
loc_b_010A:
		inc	si
		inc	si
		cmp	si,10h
		jae	loc_b_0141		; Jump if above or =
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_010A		; Jump if zero
		js	loc_b_010A		; Jump if sign=1
		test	data_a_0E1C[si],0FFh
		jz	loc_b_010A		; Jump if zero
		call	sub_b_1BC1
		test	data_a_0F1C[si],0FFh
		jnz	loc_b_0139		; Jump if not zero
		cli				; Disable interrupts
		mov	data_a_0E1C[si],0
		mov	byte ptr data_a_0E3C[si],0FFh
		sti				; Enable interrupts
		jmp	short loc_b_010A
loc_b_0139:
		call	sub_b_022E
		call	sub_b_1BC1
		jmp	short loc_b_010A
loc_b_0141:
		cmp	data_a_0F8C,14h
		jne	loc_b_014F		; Jump if not equal
		call	sub_b_2043
		dec	data_a_0F8C
loc_b_014F:
		test	byte ptr data_a_0E4C,0FFh
		jz	loc_b_0162		; Jump if zero
		js	loc_b_017B		; Jump if sign=1
		call	sub_b_04A6
		test	data_a_0ECC,2
		jz	loc_b_0168		; Jump if zero
loc_b_0162:
		call	sub_b_1B86
		jmp	short loc_b_017B
		db	90h
loc_b_0168:
		test	data_a_0E2C,0FFh
		jz	loc_b_0178		; Jump if zero
		call	sub_b_1B86
		mov	si,offset 10h		; ('d a 640 X 200 Color Grap')
		call	sub_b_022E
loc_b_0178:
		call	sub_b_1B76
loc_b_017B:
		mov	si,offset 10h		; ('d a 640 X 200 Color Grap')
loc_b_017E:
		inc	si
		inc	si
		cmp	si,20h
		jae	loc_b_01B5		; Jump if above or =
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_017E		; Jump if zero
		js	loc_b_017E		; Jump if sign=1
		test	data_a_0E1C[si],0FFh
		jz	loc_b_017E		; Jump if zero
		call	sub_b_1BC1
		test	data_a_0F1C[si],0FFh
		jnz	loc_b_01AD		; Jump if not zero
		cli				; Disable interrupts
		mov	data_a_0E1C[si],0
		mov	byte ptr data_a_0E3C[si],0FFh
		sti				; Enable interrupts
		jmp	short loc_b_017E
loc_b_01AD:
		call	sub_b_022E
		call	sub_b_1BC1
		jmp	short loc_b_017E
loc_b_01B5:
		call	sub_b_18A0
		call	sub_b_08FF
		call	sub_b_1D2F
		test	data_a_0EFC,80h
		jz	loc_b_01C8		; Jump if zero
		jmp	loc_b_07DC
loc_b_01C8:
		test	data_a_0F0C,80h
		jz	loc_b_01D2		; Jump if zero
		jmp	loc_b_07BC
loc_b_01D2:
		test	byte ptr ds:[126Dh],80h
		jnz	loc_b_01DC		; Jump if not zero
		jmp	loc_b_0940
loc_b_01DC:
		test	byte ptr ds:[1274h],80h
		jnz	loc_b_01F7		; Jump if not zero
		test	data_a_107A,20h		; ' '
		jnz	loc_b_01FC		; Jump if not zero
		or	data_a_107A,20h		; ' '
		xor	data_a_2292,1
		jmp	short loc_b_01FC
		db	90h
loc_b_01F7:
		and	data_a_107A,0DFh
loc_b_01FC:
		test	byte ptr ds:[1273h],80h
		jnz	loc_b_0217		; Jump if not zero
		test	data_a_107A,10h
		jnz	loc_b_021C		; Jump if not zero
		xor	data_a_0170,1
		or	data_a_107A,10h
		jmp	short loc_b_021C
		db	90h
loc_b_0217:
		and	data_a_107A,0EFh
loc_b_021C:
		test	data_a_0170,1
		jnz	loc_b_0226		; Jump if not zero
		jmp	loc_b_00CD
loc_b_0226:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		jmp	short loc_b_01D2

SPACEWAR	endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_022E	proc	near
		pushf				; Push flags
		cli				; Disable interrupts
		mov	ax,data_a_0D1C[si]
		mov	data_a_0D5C[si],ax
		mov	ax,data_a_0D3C[si]
		mov	data_a_0D7C[si],ax
		mov	al,data_a_0E5C[si]
		mov	data_a_0E7C[si],al
		mov	data_a_0E1C[si],0
		popf				; Pop flags
		retn
sub_b_022E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_024F	proc	near
		test	data_a_1076,1
		jz	loc_b_0259		; Jump if zero
		jmp	loc_b_038E
loc_b_0259:
		mov	data_a_0E9C,0
		mov	si,offset 8
loc_b_0261:
		mov	al,data_a_1220[si]
		xor	ah,ah			; Zero register
		mov	di,ax
		push	si
		shl	si,1			; Shift w/zeros fill
		test	byte ptr data_a_1232[di],80h
		jns	loc_b_027B		; Jump if not sign
		call	word ptr cs:data_b_0285[si]	;*18 entries
		jmp	short loc_b_0280
		db	90h
loc_b_027B:
		call	word ptr cs:data_b_0297[si]	;*9 entries
loc_b_0280:
		pop	si
		dec	si
		jns	loc_b_0261		; Jump if not sign
		retn
data_b_0285	dw	offset sub_b_02A9	; Data table (indexed access)
data_b_0287	dw	offset sub_b_02B5
data_b_0289	dw	offset sub_b_02C1
data_b_028B	dw	offset sub_b_02E0
data_b_028D	dw	offset sub_b_02FF
data_b_028F	dw	offset sub_b_031A
data_b_0291	dw	offset sub_b_0348
data_b_0293	dw	offset sub_b_035B
data_b_0295	dw	offset sub_b_036E
data_b_0297	dw	offset sub_b_02AA	; Data table (indexed access)
data_b_0299	dw	offset sub_b_02B6
data_b_029B	dw	offset sub_b_02C2
data_b_029D	dw	offset sub_b_02E1
data_b_029F	dw	offset sub_b_0300
data_b_02A1	dw	offset sub_b_0320
data_b_02A3	dw	offset sub_b_034E
data_b_02A5	dw	offset sub_b_0361
data_b_02A7	dw	offset sub_b_0374

;==== External Entry into Subroutine ======================================

sub_b_02A9:
		retn

;==== External Entry into Subroutine ======================================

sub_b_02AA:
		mov	data_a_0E9C,2
		or	data_a_0E1C,1
		retn

;==== External Entry into Subroutine ======================================

sub_b_02B5:
		retn

;==== External Entry into Subroutine ======================================

sub_b_02B6:
		mov	data_a_0E9C,0FEh
		or	data_a_0E1C,1
		retn

;==== External Entry into Subroutine ======================================

sub_b_02C1:
		retn

;==== External Entry into Subroutine ======================================

sub_b_02C2:
		mov	al,data_a_1080
		and	al,3
		jnz	loc_ret_b_02DF		; Jump if not zero
		mov	al,data_a_0EFC
		mov	ah,data_a_0F1C
		dec	ah
		js	loc_ret_b_02DF		; Jump if sign=1
		inc	al
		js	loc_ret_b_02DF		; Jump if sign=1
		mov	data_a_0EFC,al
		mov	data_a_0F1C,ah

loc_ret_b_02DF:
		retn

;==== External Entry into Subroutine ======================================

sub_b_02E0:
		retn

;==== External Entry into Subroutine ======================================

sub_b_02E1:
		mov	al,data_a_1080
		and	al,3
		jnz	loc_ret_b_02FE		; Jump if not zero
		mov	al,data_a_0EFC
		mov	ah,data_a_0F1C
		dec	al
		js	loc_ret_b_02FE		; Jump if sign=1
		inc	ah
		js	loc_ret_b_02FE		; Jump if sign=1
		mov	data_a_0EFC,al
		mov	data_a_0F1C,ah

loc_ret_b_02FE:
		retn

;==== External Entry into Subroutine ======================================

sub_b_02FF:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0300:
		test	data_a_0F7C,80h
		jz	loc_ret_b_0319		; Jump if zero
		mov	al,data_a_0F1C
		sub	al,1
		js	loc_ret_b_0319		; Jump if sign=1
		mov	data_a_0F1C,al
		mov	data_a_0F7C,18h
		call	sub_b_2006

loc_ret_b_0319:
		retn

;==== External Entry into Subroutine ======================================

sub_b_031A:
		and	data_a_0EDC,0FEh
		retn

;==== External Entry into Subroutine ======================================

sub_b_0320:
		test	data_a_0EDC,1
		jnz	loc_ret_b_0347		; Jump if not zero
		test	data_a_0F1C,0FFh
		js	loc_ret_b_0347		; Jump if sign=1
		or	data_a_0EDC,1
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
loc_b_0336:
		inc	si
		inc	si
		cmp	si,10h
		jae	loc_ret_b_0347		; Jump if above or =
		test	byte ptr data_a_0E3C[si],0FFh
		jnz	loc_b_0336		; Jump if not zero
		call	sub_b_2950

loc_ret_b_0347:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0348:
loc_b_0348:
		and	data_a_0EBC,0FEh
		retn

;==== External Entry into Subroutine ======================================

sub_b_034E:
		test	data_a_0F1C,0FFh
		js	loc_b_0348		; Jump if sign=1
		or	data_a_0EBC,1
		retn

;==== External Entry into Subroutine ======================================

sub_b_035B:
loc_b_035B:
		and	data_a_0EBC,0FDh
		retn

;==== External Entry into Subroutine ======================================

sub_b_0361:
		test	data_a_0F1C,0FFh
		js	loc_b_035B		; Jump if sign=1
		or	data_a_0EBC,2
		retn

;==== External Entry into Subroutine ======================================

sub_b_036E:
		and	data_a_0EDC,0FDh
		retn

;==== External Entry into Subroutine ======================================

sub_b_0374:
		test	data_a_0EDC,2
		jnz	loc_ret_b_038D		; Jump if not zero
		or	data_a_0EDC,2
		mov	al,data_a_0F1C
		sub	al,8
		js	loc_ret_b_038D		; Jump if sign=1
		mov	data_a_0F1C,al
		call	sub_b_06F6

loc_ret_b_038D:
		retn
loc_b_038E:
		mov	al,data_a_0F1C
		mov	ah,data_a_0EFC
		cmp	ah,al
		je	loc_b_03A4		; Jump if equal
		jc	loc_b_03A1		; Jump if carry Set
		call	sub_b_02E1
		jmp	short loc_b_03A4
		db	90h
loc_b_03A1:
		call	sub_b_02C2
loc_b_03A4:
		test	data_a_0F1C,0FFh
		jnz	loc_b_03B2		; Jump if not zero
		call	sub_b_0348
		call	sub_b_02FF
		retn
loc_b_03B2:
		mov	si,offset 0Eh
loc_b_03B5:
		inc	si
		inc	si
		cmp	si,20h
		jb	loc_b_03BF		; Jump if below
		jmp	loc_b_0484
loc_b_03BF:
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_03B5		; Jump if zero
		js	loc_b_03B5		; Jump if sign=1
		mov	ax,data_a_0D3C
		sub	ax,data_a_0D3C[si]
		jns	loc_b_03D3		; Jump if not sign
		neg	ax
loc_b_03D3:
		cmp	ax,60h
		jae	loc_b_03B5		; Jump if above or =
		mov	ax,data_a_0D1C
		sub	ax,data_a_0D1C[si]
		jns	loc_b_03E3		; Jump if not sign
		neg	ax
loc_b_03E3:
		cmp	ax,60h
		jae	loc_b_03B5		; Jump if above or =
		xor	bx,bx			; Zero register
		mov	cx,data_a_0D1C[si]
		sub	cx,data_a_0D1C
		mov	dx,data_a_0D3C[si]
		sub	dx,data_a_0D3C
		or	cx,cx			; Zero ?
		jns	loc_b_0403		; Jump if not sign
		neg	cx
		or	bh,1
loc_b_0403:
		or	dx,dx			; Zero ?
		jns	loc_b_040C		; Jump if not sign
		neg	dx
		xor	bh,2
loc_b_040C:
		cmp	dx,cx
		jne	loc_b_0416		; Jump if not equal
		add	bl,20h			; ' '
		jmp	short loc_b_045A
		db	90h
loc_b_0416:
		jnc	loc_b_0438		; Jump if carry=0
		xor	ax,ax			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		shr	ax,1			; Shift w/zeros fill
		push	bx
		mov	bx,offset 3Eh
loc_b_0422:
		cmp	ax,word ptr ds:[2250h][bx]
		jae	loc_b_042E		; Jump if above or =
		dec	bx
		dec	bx
		jns	loc_b_0422		; Jump if not sign
		xor	bx,bx			; Zero register
loc_b_042E:
		shr	bx,1			; Shift w/zeros fill
		mov	ax,bx
		pop	bx
		add	bl,al
		jmp	short loc_b_045A
		db	90h
loc_b_0438:
		xchg	dx,cx
		xor	ax,ax			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		shr	ax,1			; Shift w/zeros fill
		push	bx
		mov	bx,offset 3Eh
loc_b_0444:
		cmp	ax,word ptr ds:[2250h][bx]
		jae	loc_b_0450		; Jump if above or =
		dec	bx
		dec	bx
		jns	loc_b_0444		; Jump if not sign
		xor	bx,bx			; Zero register
loc_b_0450:
		shr	bx,1			; Shift w/zeros fill
		mov	ax,bx
		pop	bx
		add	bl,40h			; '@'
		sub	bl,al
loc_b_045A:
		xor	al,al			; Zero register
		shr	bh,1			; Shift w/zeros fill
		jnc	loc_b_0464		; Jump if carry=0
		mov	al,80h
		neg	bl
loc_b_0464:
		shr	bh,1			; Shift w/zeros fill
		jnc	loc_b_046A		; Jump if carry=0
		neg	bl
loc_b_046A:
		add	al,bl
		mov	data_a_0E9C,0
		mov	bl,data_a_0E5C
		cmp	al,bl
		je	loc_b_0481		; Jump if equal
		mov	data_a_0E5C,al
		or	data_a_0E1C,1
loc_b_0481:
		call	sub_b_0300
loc_b_0484:
		call	sub_b_28F2
		cmp	al,10h
		jae	loc_b_0491		; Jump if above or =
		call	sub_b_034E
		jmp	short loc_b_0494
		db	90h
loc_b_0491:
		call	sub_b_0348
loc_b_0494:
		call	sub_b_28F2
		and	ax,3FFh
		jnz	loc_b_04A2		; Jump if not zero
		call	sub_b_0374
		jmp	short loc_ret_b_04A5
		db	90h
loc_b_04A2:
		call	sub_b_036E

loc_ret_b_04A5:
		retn
sub_b_024F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_04A6	proc	near
		test	data_a_1076,2
		jz	loc_b_04B0		; Jump if zero
		jmp	loc_b_05E5
loc_b_04B0:
		mov	data_a_0EAC,0
		mov	si,offset 8
loc_b_04B8:
		mov	al,byte ptr data_a_1229[si]	; ('MKQOGILHP')
		xor	ah,ah			; Zero register
		mov	di,ax
		push	si
		shl	si,1			; Shift w/zeros fill
		test	byte ptr data_a_1232[di],80h
		jz	loc_b_04D2		; Jump if zero
		call	word ptr cs:data_b_04DC[si]	;*12 entries
		jmp	short loc_b_04D7
		db	90h
loc_b_04D2:
		call	word ptr cs:data_b_04EE[si]	;*3 entries
loc_b_04D7:
		pop	si
		dec	si
		jns	loc_b_04B8		; Jump if not sign
		retn
data_b_04DC	dw	offset sub_b_0500	; Data table (indexed access)
data_b_04DE	dw	offset sub_b_050C
data_b_04E0	dw	offset sub_b_0518
data_b_04E2	dw	offset sub_b_0537
data_b_04E4	dw	offset sub_b_0556
data_b_04E6	dw	offset sub_b_0571
data_b_04E8	dw	offset sub_b_059F
data_b_04EA	dw	offset sub_b_05B2
data_b_04EC	dw	offset sub_b_05C5
data_b_04EE	dw	offset sub_b_0501	; Data table (indexed access)
data_b_04F0	dw	offset sub_b_050D
data_b_04F2	dw	offset sub_b_0519
		db	38h
data_b_04F5	dw	5705h			; Data table (indexed access)
		db	 05h, 77h, 05h,0A5h, 05h,0B8h
		db	 05h,0CBh, 05h

;==== External Entry into Subroutine ======================================

sub_b_0500:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0501:
		mov	data_a_0EAC,2
		or	data_a_0E2C,1
		retn

;==== External Entry into Subroutine ======================================

sub_b_050C:
		retn

;==== External Entry into Subroutine ======================================

sub_b_050D:
		mov	data_a_0EAC,0FEh
		or	data_a_0E2C,1
		retn

;==== External Entry into Subroutine ======================================

sub_b_0518:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0519:
		mov	al,data_a_1080
		and	al,3
		jnz	loc_ret_b_0536		; Jump if not zero
		mov	al,data_a_0F0C
		mov	ah,data_a_0F2C
		dec	ah
		js	loc_ret_b_0536		; Jump if sign=1
		inc	al
		js	loc_ret_b_0536		; Jump if sign=1
		mov	data_a_0F0C,al
		mov	data_a_0F2C,ah

loc_ret_b_0536:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0537:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0538:
		assume	ds:seg_b
		assume	ds:seg_a
		mov	al,data_a_1080
		and	al,3
		jnz	loc_ret_b_0555		; Jump if not zero
		mov	al,byte ptr data_a_0F0C
		assume	ds:seg_b
		mov	ah,byte ptr data_b_0F25+7	; ('M E    I N S T R U C T I')
		dec	al
		js	loc_ret_b_0555		; Jump if sign=1
		inc	ah
		js	loc_ret_b_0555		; Jump if sign=1
		assume	ds:seg_a
		mov	byte ptr data_a_0F0C,al
		assume	ds:seg_b
		mov	byte ptr data_b_0F25+7,ah	; ('M E    I N S T R U C T I')

loc_ret_b_0555:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0556:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0557:
		test	byte ptr data_b_0F89+3,80h	; ('ECT: Destroy the')
		jz	loc_ret_b_0570		; Jump if zero
		mov	al,byte ptr data_b_0F25+7	; ('M E    I N S T R U C T I')
		sub	al,1
		js	loc_ret_b_0570		; Jump if sign=1
		mov	byte ptr data_b_0F25+7,al	; ('M E    I N S T R U C T I')
		mov	byte ptr data_b_0F89+3,18h	; ('ECT: Destroy the')
		call	sub_b_2069

loc_ret_b_0570:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0571:
		assume	ds:seg_a
		and	data_a_0EEC,0FEh
		retn

;==== External Entry into Subroutine ======================================

sub_b_0577:
		test	byte ptr ds:[0EECh],1
		jnz	loc_ret_b_059E		; Jump if not zero
		assume	ds:seg_b
		test	byte ptr data_b_0F25+7,0FFh	; ('M E    I N S T R U C T I')
		js	loc_ret_b_059E		; Jump if sign=1
		or	byte ptr ds:[0EECh],1
		mov	si,10h
loc_b_058D:
		inc	si
		inc	si
		cmp	si,20h
		jae	loc_ret_b_059E		; Jump if above or =
		test	byte ptr data_b_0E3C[si],0FFh
		jnz	loc_b_058D		; Jump if not zero
		call	sub_b_2A0F

loc_ret_b_059E:
		retn

;==== External Entry into Subroutine ======================================

sub_b_059F:
loc_b_059F:
		assume	ds:seg_a
		and	data_a_0ECC,0FEh
		retn

;==== External Entry into Subroutine ======================================

sub_b_05A5:
		assume	ds:seg_b
		test	byte ptr data_b_0F25+7,0FFh	; ('M E    I N S T R U C T I')
		js	loc_b_059F		; Jump if sign=1
		or	byte ptr data_b_0ECC,1
		retn

;==== External Entry into Subroutine ======================================

sub_b_05B2:
loc_b_05B2:
		assume	ds:seg_a
		and	data_a_0ECC,0FDh
		retn
			                        ;* No entry point to code
		test	data_a_0F2C,0FFh
		js	loc_b_05B2		; Jump if sign=1
		or	data_a_0ECC,2
		retn

;==== External Entry into Subroutine ======================================

sub_b_05C5:
		and	data_a_0EEC,0FDh
		retn

;==== External Entry into Subroutine ======================================

sub_b_05CB:
		test	byte ptr ds:[0EECh],2
		jnz	loc_ret_b_05E4		; Jump if not zero
		or	byte ptr ds:[0EECh],2
		assume	ds:seg_b
		mov	al,byte ptr data_b_0F25+7	; ('M E    I N S T R U C T I')
		sub	al,8
		js	loc_ret_b_05E4		; Jump if sign=1
		mov	byte ptr data_b_0F25+7,al	; ('M E    I N S T R U C T I')
		call	sub_b_0759

loc_ret_b_05E4:
		retn
loc_b_05E5:
		xor	bp,bp			; Zero register
		xor	bx,bx			; Zero register
		mov	cx,data_b_0D1C
		sub	cx,data_b_0D2C
		mov	dx,data_b_0D3C
		sub	dx,data_b_0D4C
		or	cx,cx			; Zero ?
		jns	loc_b_0602		; Jump if not sign
		neg	cx
		or	bh,1
loc_b_0602:
		cmp	cx,60h
		jae	loc_b_0608		; Jump if above or =
		inc	bp
loc_b_0608:
		or	dx,dx			; Zero ?
		jns	loc_b_0611		; Jump if not sign
		neg	dx
		xor	bh,2
loc_b_0611:
		cmp	dx,60h
		jae	loc_b_0617		; Jump if above or =
		inc	bp
loc_b_0617:
		cmp	dx,cx
		jne	loc_b_0621		; Jump if not equal
		add	bl,20h			; ' '
		jmp	short loc_b_0665
		db	90h
loc_b_0621:
		jnc	loc_b_0643		; Jump if carry=0
		xor	ax,ax			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		shr	ax,1			; Shift w/zeros fill
		push	bx
		mov	bx,3Eh
loc_b_062D:
		cmp	ax,word ptr ds:[2250h][bx]
		jae	loc_b_0639		; Jump if above or =
		dec	bx
		dec	bx
		jns	loc_b_062D		; Jump if not sign
		xor	bx,bx			; Zero register
loc_b_0639:
		shr	bx,1			; Shift w/zeros fill
		mov	ax,bx
		pop	bx
		add	bl,al
		jmp	short loc_b_0665
		db	90h
loc_b_0643:
		xchg	dx,cx
		xor	ax,ax			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		shr	ax,1			; Shift w/zeros fill
		push	bx
		mov	bx,3Eh
loc_b_064F:
		cmp	ax,word ptr ds:[2250h][bx]
		jae	loc_b_065B		; Jump if above or =
		dec	bx
		dec	bx
		jns	loc_b_064F		; Jump if not sign
		xor	bx,bx			; Zero register
loc_b_065B:
		shr	bx,1			; Shift w/zeros fill
		mov	ax,bx
		pop	bx
		add	bl,40h			; '@'
		sub	bl,al
loc_b_0665:
		xor	al,al			; Zero register
		shr	bh,1			; Shift w/zeros fill
		jnc	loc_b_066F		; Jump if carry=0
		mov	al,80h
		neg	bl
loc_b_066F:
		shr	bh,1			; Shift w/zeros fill
		jnc	loc_b_0675		; Jump if carry=0
		neg	bl
loc_b_0675:
		add	al,bl
		mov	byte ptr data_b_0EAC,0
		mov	bl,data_b_0E6C
		cmp	al,bl
		je	loc_b_068C		; Jump if equal
		mov	data_b_0E6C,al
		or	byte ptr data_b_0E2C,1
loc_b_068C:
		mov	al,byte ptr data_b_0F25+7	; ('M E    I N S T R U C T I')
		assume	ds:seg_a
		mov	ah,byte ptr data_a_0F0C
		assume	ds:seg_b
		cmp	ah,al
		je	loc_b_06A2		; Jump if equal
		jc	loc_b_069F		; Jump if carry Set
		call	sub_b_0538
		jmp	short loc_b_06A2
		db	90h
loc_b_069F:
		call	sub_b_0519
loc_b_06A2:
		test	byte ptr data_b_0F25+7,0FFh	; ('M E    I N S T R U C T I')
		jnz	loc_b_06B0		; Jump if not zero
		call	sub_b_059F
		call	sub_b_0571
		retn
loc_b_06B0:
		call	sub_b_28F2
		cmp	al,10h
		jae	loc_b_06BD		; Jump if above or =
		call	sub_b_05A5
		jmp	short loc_b_06C0
		db	90h
loc_b_06BD:
		call	sub_b_059F
loc_b_06C0:
		call	sub_b_28F2
		cmp	al,8
		jb	loc_b_06D0		; Jump if below
		call	sub_b_0571
		call	sub_b_0556
		jmp	short loc_b_06E4
		db	90h
loc_b_06D0:
		cmp	bp,2
		jne	loc_b_06DE		; Jump if not equal
		call	sub_b_0571
		call	sub_b_0557
		jmp	short loc_b_06E4
		db	90h
loc_b_06DE:
		call	sub_b_0556
		call	sub_b_0577
loc_b_06E4:
		call	sub_b_28F2
		and	ax,3FFh
		jnz	loc_b_06F2		; Jump if not zero
		call	sub_b_05CB
		jmp	short loc_ret_b_06F5
		db	90h
loc_b_06F2:
		call	sub_b_05C5

loc_ret_b_06F5:
		retn
sub_b_04A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_06F6	proc	near
		cli				; Disable interrupts
		xor	al,al			; Zero register
		assume	ds:seg_a
		mov	byte ptr data_a_0E3C,al
		mov	data_a_0E1C,al
		sti				; Enable interrupts
		call	sub_b_28D0
		mov	data_a_0D1C,ax
		sub	ax,data_a_0D5C
		mov	dx,ax
		mov	cl,6
		sar	ax,cl			; Shift w/sign fill
		mov	cl,0Ah
		shl	dx,cl			; Shift w/zeros fill
		mov	data_a_0DDC,dx
		mov	data_a_0D9C,ax
		call	sub_b_28E1
		mov	data_a_0D3C,ax
		sub	ax,data_a_0D7C
		mov	dx,ax
		mov	cl,6
		sar	ax,cl			; Shift w/sign fill
		mov	cl,0Ah
		shl	dx,cl			; Shift w/zeros fill
		mov	data_a_0DFC,dx
		mov	data_a_0DBC,ax
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	di,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	cx,20h
		call	sub_b_08B9
		mov	es,data_a_1060
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	cx,20h
		call	sub_b_08EF
		inc	data_a_0060
		or	byte ptr ds:[2290h],10h
		retn
sub_b_06F6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0759	proc	near
		cli				; Disable interrupts
		xor	al,al			; Zero register
		assume	ds:seg_b
		mov	data_b_0E4C,al
		mov	data_b_0E2C,al
		sti				; Enable interrupts
		call	sub_b_28D0
		mov	data_b_0D2C,ax
		sub	ax,data_b_0D6C
		mov	dx,ax
		mov	cl,6
		sar	ax,cl			; Shift w/sign fill
		mov	cl,0Ah
		shl	dx,cl			; Shift w/zeros fill
		mov	data_b_0DEC,dx
		mov	data_b_0DAC,ax
		call	sub_b_28E1
		mov	data_b_0D4C,ax
		sub	ax,data_b_0D8C
		mov	dx,ax
		mov	cl,6
		sar	ax,cl			; Shift w/sign fill
		mov	cl,0Ah
		shl	dx,cl			; Shift w/zeros fill
		mov	data_b_0E0C,dx
		mov	data_b_0DCC,ax
		mov	si,10h
		mov	di,40h
		mov	cx,20h
		call	sub_b_08B9
		assume	ds:seg_a
		mov	es,data_a_1060
		mov	si,40h
		mov	cx,20h
		call	sub_b_08EF
		inc	byte ptr ds:[61h]
		or	byte ptr ds:[2290h],10h
		retn
sub_b_0759	endp

loc_b_07BC:
		call	sub_b_1B86
		cli				; Disable interrupts
		assume	ds:seg_b
		xor	al,al			; Zero register
		mov	data_b_0E2C,al
		mov	data_b_0E4C,al
		mov	data_b_0EAC,al
		mov	data_b_0ECC,al
		sti				; Enable interrupts
		assume	ds:seg_a
		inc	data_a_1081
		mov	si,10h
		call	sub_b_07FC
		jmp	loc_b_0940
loc_b_07DC:
		call	sub_b_1B8E
		cli				; Disable interrupts
		xor	al,al			; Zero register
		mov	data_a_0E1C,al
		mov	byte ptr data_a_0E3C,al
		mov	data_a_0E9C,al
		mov	data_a_0EBC,al
		sti				; Enable interrupts
		inc	data_a_1083
		assume	ds:seg_b
		mov	si,0
		call	sub_b_07FC
		jmp	loc_b_0940

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_07FC	proc	near
		mov	byte ptr ds:[2290h],80h
		call	sub_b_08B4
		call	sub_b_08E6
		mov	cx,80h
loc_b_080A:
		mov	bp,81h
		sub	bp,cx
		push	cx
		mov	cx,5Ah
		xor	si,si			; Zero register
loc_b_0815:
		mov	bx,word ptr ds:[38Dh][si]
		mov	dx,word ptr ds:[441h][si]
		call	sub_b_1AFC
		mov	ax,word ptr ds:[65Dh][si]
		cwd				; Word to double word
		add	data_b_04F5[si],ax
		adc	dx,word ptr ds:[38Dh][si]
		jns	loc_b_0836		; Jump if not sign
		add	dx,280h
		jmp	short loc_b_0840
		db	90h
loc_b_0836:
		cmp	dx,280h
		jb	loc_b_0840		; Jump if below
		sub	dx,280h
loc_b_0840:
		mov	word ptr ds:[38Dh][si],dx
		mov	ax,word ptr ds:[711h][si]
		cwd				; Word to double word
		add	word ptr ds:[5A9h][si],ax
		adc	dx,word ptr ds:[441h][si]
		jns	loc_b_085A		; Jump if not sign
		add	dx,0C8h
		jmp	short loc_b_0864
		db	90h
loc_b_085A:
		cmp	dx,0C8h
		jb	loc_b_0864		; Jump if below
		sub	dx,0C8h
loc_b_0864:
		mov	word ptr ds:[441h][si],dx
		mov	bx,word ptr ds:[38Dh][si]
		mov	dx,word ptr ds:[441h][si]
		call	sub_b_1AFC
		inc	si
		inc	si
		dec	bp
		jnz	loc_b_0894		; Jump if not zero
		test	byte ptr ds:[2292h],0FFh
		jz	loc_b_088D		; Jump if zero
		call	sub_b_28F2
		and	ah,2
		in	al,61h			; port 61h, 8255 port B, read
		xor	al,ah
		and	al,0FEh
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_b_088D:
		pop	ax
		mov	bp,81h
		sub	bp,ax
		push	ax
loc_b_0894:
		loop	locloop_b_089C		; Loop if cx > 0

		pop	cx
		loop	locloop_b_089F		; Loop if cx > 0

		jmp	short loc_b_08A2
		db	90h

locloop_b_089C:
		jmp	loc_b_0815

locloop_b_089F:
		jmp	loc_b_080A
loc_b_08A2:
		call	sub_b_08E6
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	cx,8

locloop_b_08AE:
		dec	ax
		jnz	locloop_b_08AE		; Jump if not zero
		loop	locloop_b_08AE		; Loop if cx > 0

		retn
sub_b_07FC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_08B4	proc	near
		mov	cx,5Ah
		xor	di,di			; Zero register

;==== External Entry into Subroutine ======================================

sub_b_08B9:

locloop_b_08B9:
		xor	ax,ax			; Zero register
		assume	ds:seg_a
		mov	data_a_04F5[di],ax
		mov	data_a_05A9[di],ax
		mov	ax,data_a_0D5C[si]
		mov	word ptr data_a_038D[di],ax
		mov	ax,data_a_0D7C[si]
		mov	data_a_0441[di],ax
		call	sub_b_28F2
		mov	data_a_065D[di],ax
		call	sub_b_28F2
		mov	data_a_0711[di],ax
		inc	di
		inc	di
		loop	locloop_b_08B9		; Loop if cx > 0

		retn
sub_b_08B4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_08E6	proc	near
		mov	es,data_a_1060
		mov	cx,5Ah
		xor	si,si			; Zero register

;==== External Entry into Subroutine ======================================

sub_b_08EF:

locloop_b_08EF:
		mov	bx,word ptr data_a_038D[si]
		mov	dx,data_a_0441[si]
		call	sub_b_1AFC
		inc	si
		inc	si
		loop	locloop_b_08EF		; Loop if cx > 0

		retn
sub_b_08E6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_08FF	proc	near
		mov	si,data_a_FFFE_e
loc_b_0902:
		inc	si
		inc	si
		cmp	si,20h
		jae	loc_ret_b_093D		; Jump if above or =
		test	byte ptr data_a_0E3C[si],80h
		jns	loc_b_0902		; Jump if not sign
		inc	data_a_0F3C[si]
		inc	data_a_0F3C[si]
		js	loc_b_0929		; Jump if sign=1
		or	byte ptr ds:[2290h],8
		mov	al,data_a_0F3C[si]
		and	al,7
		jnz	loc_b_0902		; Jump if not zero
		jz	loc_b_0938		; Jump if zero
loc_b_0929:
		mov	data_a_0F3C[si],0
		mov	byte ptr data_a_0E3C[si],0
		and	byte ptr ds:[2290h],0F7h
loc_b_0938:
		call	sub_b_1E11
		jmp	short loc_b_0902

loc_ret_b_093D:
		retn
sub_b_08FF	endp

		db	0, 0
loc_b_0940:
		cli				; Disable interrupts
		mov	sp,166h
		mov	data_a_0170,0
		call	sub_b_28B4
		call	sub_b_1F70
		call	sub_b_1880
		sti				; Enable interrupts
		call	sub_b_1CD3
		call	sub_b_2932
		call	sub_b_159A
loc_b_095C:
		call	sub_b_098E
		call	sub_b_0A1C
		call	sub_b_0A43
		call	sub_b_0A87
		call	sub_b_0A79
		call	sub_b_098E
		call	sub_b_0EE9
		call	sub_b_0A1C
		call	sub_b_0A76
		call	sub_b_0EE9
		call	sub_b_0AD2
		call	sub_b_0A76
		call	sub_b_0AD2
		call	sub_b_12B8
		call	sub_b_0A76
		call	sub_b_12B8
		jmp	short loc_b_095C

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_098E	proc	near
		mov	ax,122h
		mov	dx,90h
		call	sub_b_1C82
		push	si
		xor	ds:d_0166_3035_e,bp
		add	ds:d_0166_00B4_e[bx+si],bh
		mov	dx,0A0h
		call	sub_b_1C82
		inc	bx
		dec	di
		push	ax
		pop	cx
		push	dx
		dec	cx
		inc	di
		dec	ax
		push	sp
		and	[bx+si],ah
		jg	loc_b_09D3		; Jump if >
		xor	[bx+di],di
		cmp	[di],dh
		and	[bx+si],ah
		inc	dx
		and	[bp+di+45h],dl
		dec	cx
		dec	sp
		inc	bp
		push	dx
		db	 2Eh, 00h,0C7h, 06h, 5Ch, 0Dh
		db	0A0h, 00h,0C7h, 06h, 7Ch, 0Dh
		db	0B0h, 00h,0C6h, 06h, 7Ch, 0Eh
loc_b_09D3:
;*		sub	al,0C8h
		db	 80h,0E8h,0C8h		;  Fixup - byte match
		adc	ds:d_0166_00AA_e[bx+si],di
		mov	dx,0B0h
		call	sub_b_1C82
		and	[di],bh
		and	[bx+si],al
		mov	si,ax
		mov	di,dx
		mov	dx,ds:d_0166_1081_e
		call	sub_b_1C94
		mov	word ptr ds:d_0166_0D6C_e,1A4h
		mov	word ptr ds:d_0166_0D8C_e,0B0h
		mov	byte ptr ds:d_0166_0E8C_e,80h
		call	sub_b_1B96
		mov	ax,1AEh
		mov	dx,0B0h
		call	sub_b_1C82
		and	[di],bh
		and	[bx+si],al
		mov	si,ax
		mov	di,dx
		mov	dx,ds:d_0166_1083_e
		call	sub_b_1C94
		retn
sub_b_098E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A1C	proc	near
		mov	cx,5Ah
		xor	si,si			; Zero register

locloop_b_0A21:
		mov	ax,ds:d_0166_0225_e[si]
		mov	ds:d_0166_038D_e[si],ax
		mov	ax,ds:d_0166_02D9_e[si]
		mov	ds:d_0166_0441_e[si],ax
		xor	ax,ax			; Zero register
		mov	ds:d_0166_04F5_e[si],ax
		mov	ds:d_0166_05A9_e[si],ax
		call	sub_b_1CB7
		inc	si
		inc	si
		loop	locloop_b_0A21		; Loop if cx > 0

		retn
sub_b_0A1C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A43	proc	near
		mov	cx,5Ah
		xor	si,si			; Zero register

locloop_b_0A48:
		call	sub_b_28F2
		sar	ax,1			; Shift w/sign fill
		mov	ds:d_0166_065D_e[si],ax
		call	sub_b_28F2
		sar	ax,1			; Shift w/sign fill
		mov	ds:d_0166_0711_e[si],ax
		inc	si
		inc	si
		loop	locloop_b_0A48		; Loop if cx > 0

		call	sub_b_0A79
		call	sub_b_0A87
		mov	cx,5Ah
		xor	si,si			; Zero register

locloop_b_0A69:
		neg	word ptr ds:d_0166_065D_e[si]
		neg	word ptr ds:d_0166_0711_e[si]
		inc	si
		inc	si
		loop	locloop_b_0A69		; Loop if cx > 0

		retn
sub_b_0A43	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A76	proc	near
		call	sub_b_0A79

;==== External Entry into Subroutine ======================================

sub_b_0A79:
		call	sub_b_1895
		mov	cx,8

locloop_b_0A7F:
		xor	ax,ax			; Zero register
loc_b_0A81:
		dec	ax
		jnz	loc_b_0A81		; Jump if not zero
		loop	locloop_b_0A7F		; Loop if cx > 0

		retn
sub_b_0A76	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A87	proc	near
		mov	cx,1Eh

locloop_b_0A8A:
		xor	si,si			; Zero register
loc_b_0A8C:
		call	sub_b_1895
		call	sub_b_1CB7
		mov	ax,data_a_065D[si]
		cwd				; Word to double word
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	data_a_04F5[si],ax
		adc	word ptr data_a_038D[si],dx
		mov	ax,data_a_0711[si]
		cwd				; Word to double word
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	data_a_05A9[si],ax
		adc	data_a_0441[si],dx
		call	sub_b_1CB7
		inc	si
		inc	si
		cmp	si,0B4h
		jb	loc_b_0A8C		; Jump if below
		loop	locloop_b_0A8A		; Loop if cx > 0

		retn
sub_b_0A87	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0AD2	proc	near
		mov	ax,0C8h
		mov	dx,8
		call	sub_b_1C82
		and	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		adc	ax,[bx+si]
		mov	ax,0C8h
		mov	dx,10h
		call	sub_b_1C82
		and	[bx+si],ah
		and	[bx+20h],al
		inc	cx
		and	[di+20h],cl
		inc	bp
		db	'    K E Y S  '
		db	 00h,0B8h,0C8h, 00h,0BAh, 10h
		db	 00h,0E8h, 63h, 11h, 0Bh
		db	8
		db	22 dup (8)
		db	 09h, 00h,0B8h, 50h, 00h,0BAh
		db	 28h, 00h,0E8h, 40h, 11h
		db	'LEFT PLAYER KEYS'
		db	 00h,0C7h, 06h, 5Ch, 0Dh, 04h
		db	 01h,0C7h, 06h, 7Ch, 0Dh, 28h
		db	 00h,0C6h, 06h, 7Ch, 0Eh, 80h
		db	0E8h, 38h, 10h,0B8h, 72h, 01h
		db	0BAh, 28h, 00h,0E8h, 12h, 11h
		db	'RIGHT PLAYER KEYS'
		db	 00h,0C7h, 06h, 6Ch, 0Dh, 26h
		db	 02h,0C7h, 06h, 8Ch, 0Dh, 28h
		db	 00h,0C6h, 06h, 8Ch, 0Eh, 80h
		db	0E8h, 00h, 10h,0B8h, 32h, 00h
		db	0BAh, 38h, 00h,0E8h,0E3h, 10h
		db	 19h, 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
		db	 1Dh, 1Dh, 1Bh, 1Dh, 1Dh, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Bh, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
		db	 16h, 20h, 20h, 20h, 20h, 19h
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
		db	 1Dh, 1Bh, 1Dh, 1Dh, 1Dh, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Bh, 1Dh, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh, 16h
		db	 00h,0B8h, 32h, 00h,0BAh, 40h
		db	 00h,0E8h,0A3h, 10h, 15h, 20h
		db	 20h, 20h, 51h, 20h, 20h, 20h
		db	 15h, 20h, 20h, 20h, 57h, 20h
		db	 20h, 20h, 15h, 20h, 20h, 20h
		db	 45h, 20h, 20h, 20h, 15h, 20h
		db	 20h, 20h, 20h, 15h, 20h, 20h
		db	 20h, 37h, 20h, 20h, 20h, 15h
		db	 20h, 20h, 20h, 38h, 20h, 20h
		db	 20h, 15h, 20h, 20h, 20h, 39h
		db	 20h, 20h, 20h, 15h, 00h,0B8h
		db	 32h, 00h,0BAh, 48h, 00h,0E8h
		db	 63h, 10h, 15h, 1Fh, 20h, 46h
		db	 49h, 52h, 45h, 20h, 1Fh, 15h
		db	 20h, 20h, 20h, 20h, 20h, 20h
		db	 20h, 15h, 1Fh, 20h, 46h, 49h
		db	 52h, 45h, 20h, 1Fh, 15h, 20h
		db	 20h, 20h, 20h, 15h, 1Fh, 20h
		db	 46h, 49h, 52h, 45h, 20h, 1Fh
		db	 15h, 20h, 20h, 20h, 20h, 20h
		db	 20h, 20h, 15h, 1Fh, 20h, 46h
		db	 49h, 52h, 45h, 20h, 1Fh, 15h
		db	 00h,0B8h, 32h, 00h,0BAh, 50h
		db	 00h,0E8h, 1Fh, 10h, 15h, 50h
		db	 48h, 41h, 53h, 45h, 52h, 53h
		db	 15h, 20h, 43h, 4Ch, 4Fh, 41h
		db	 4Bh, 20h, 15h, 50h, 48h, 4Fh
		db	 54h, 4Fh, 4Eh, 53h, 15h, 20h
		db	 20h, 20h, 20h, 15h, 50h, 48h
		db	 41h, 53h, 45h, 52h, 53h, 15h
		db	 20h, 43h, 4Ch, 4Fh, 41h, 4Bh
		db	 20h, 15h, 50h, 48h, 4Fh, 54h
		db	 4Fh, 4Eh, 53h, 15h, 00h,0B8h
		db	 32h, 00h,0BAh, 58h, 00h,0E8h
		db	0DFh, 0Fh, 1Ch, 1Dh, 1Dh, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Eh
		db	7 dup (1Dh)
		db	1Eh
		db	7 dup (1Dh)
		db	 14h, 20h, 20h, 20h, 20h, 1Ch
		db	7 dup (1Dh)
		db	1Eh
		db	7 dup (1Dh)
		db	1Eh
		db	7 dup (1Dh)
		db	 14h, 00h,0B8h, 32h
data_b_0CDC	dw	0BA00h			; Data table (indexed access)
		db	 60h, 00h,0E8h, 9Fh, 0Fh, 15h
		db	 20h, 20h, 20h, 41h, 20h, 20h
		db	 20h, 15h
data_b_0CEC	dw	2020h
		db	 20h, 53h, 20h, 20h, 20h, 15h
		db	 20h, 20h, 20h, 44h, 20h, 20h
		db	 20h, 15h
data_b_0CFC	dw	2020h			; Data table (indexed access)
		db	 20h, 20h, 15h, 20h, 20h, 20h
		db	 34h, 20h, 20h, 20h, 15h
		db	 20h, 20h, 20h
data_b_0D0C	dw	2035h
		db	 20h, 20h, 15h, 20h, 20h, 20h
		db	 36h, 20h, 20h, 20h, 15h, 00h
		db	0B8h
		db	32h
data_b_0D1C	dw	0BA00h			; Data table (indexed access)
		db	 68h, 00h,0E8h, 5Fh, 0Fh, 15h
		db	 1Fh, 52h, 4Fh, 54h, 41h, 54h
		db	 45h, 1Fh
data_b_0D2C	dw	4915h
		db	 4Dh, 50h, 55h, 4Ch, 53h, 45h
		db	 15h, 1Fh
		db	 52h, 4Fh, 54h, 41h, 54h, 45h
data_b_0D3C	dw	151Fh			; Data table (indexed access)
		db	 20h, 20h, 20h, 20h, 15h, 1Fh
		db	 52h, 4Fh, 54h, 41h, 54h, 45h
		db	 1Fh, 15h
data_b_0D4C	dw	4D49h
		db	 50h, 55h, 4Ch, 53h, 45h, 15h
		db	 1Fh, 52h, 4Fh, 54h, 41h, 54h
		db	 45h, 1Fh
data_b_0D5C	dw	15h			; Data table (indexed access)
		db	0B8h, 32h, 00h,0BAh, 70h, 00h
		db	0E8h, 1Bh, 0Fh, 15h
		db	 20h, 20h, 43h, 43h
data_b_0D6C	dw	2057h
		db	 20h, 15h, 45h, 4Eh, 47h, 49h
		db	 4Eh, 45h, 53h, 15h, 1Fh
		db	 20h, 20h, 43h
data_b_0D7C	dw	2057h			; Data table (indexed access)
		db	 20h, 1Fh, 15h, 20h, 20h, 20h
		db	 20h, 15h
		db	 20h, 20h, 43h, 43h, 57h, 20h
data_b_0D8C	dw	1520h
		db	 45h, 4Eh, 47h, 49h, 4Eh, 45h
		db	 53h, 15h, 1Fh
		db	 20h, 20h, 43h, 57h, 20h
data_b_0D9C	dw	1F20h			; Data table (indexed access)
		db	 15h, 00h,0B8h, 32h, 00h,0BAh
		db	 78h, 00h,0E8h,0D9h, 0Eh, 1Ch
		db	 1Dh, 1Dh
data_b_0DAC	dw	1D1Dh
		db	 1Dh, 1Dh, 1Dh, 1Eh
		db	7 dup (1Dh)
		db	1Eh
		db	 1Dh, 1Dh
data_b_0DBC	dw	1D1Dh			; Data table (indexed access)
		db	 1Dh, 1Dh, 1Dh, 14h, 20h, 20h
		db	 20h, 20h, 1Ch
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
data_b_0DCC	dw	1D1Dh
		db	1Eh
		db	7 dup (1Dh)
		db	1Eh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
data_b_0DDC	dw	1D1Dh			; Data table (indexed access)
		db	 14h, 00h,0B8h, 32h, 00h,0BAh
		db	 80h, 00h,0E8h, 99h, 0Eh, 15h
		db	 20h, 20h
data_b_0DEC	dw	5A20h
		db	 20h, 20h, 20h, 15h, 20h, 20h
		db	 20h, 58h, 20h, 20h, 20h, 15h
		db	 20h, 20h
data_b_0DFC	dw	4320h			; Data table (indexed access)
		db	 20h, 20h, 20h, 15h, 20h, 20h
		db	 20h, 20h, 15h
		db	 20h, 20h, 20h, 31h, 20h
data_b_0E0C	dw	2020h
		db	 15h, 20h, 20h, 20h, 32h, 20h
		db	 20h, 20h, 15h
		db	 20h, 20h, 20h, 33h, 20h
data_b_0E1C	db	20h			; Data table (indexed access)
		db	 20h, 15h, 00h,0B8h, 32h, 00h
		db	0BAh, 88h, 00h,0E8h, 59h, 0Eh
		db	 15h, 1Fh
		db	57h
data_b_0E2C	db	45h
		db	 41h, 50h, 4Fh, 4Eh, 1Fh, 15h
		db	 20h, 48h, 59h, 50h, 45h, 52h
		db	 20h, 15h, 1Fh
data_b_0E3C	db	53h			; Data table (indexed access)
		db	 48h, 49h, 45h, 4Ch, 44h, 1Fh
		db	 15h, 20h, 20h, 20h, 20h, 15h
		db	 1Fh
		db	 57h, 45h
data_b_0E4C	db	41h
		db	 50h, 4Fh, 4Eh, 1Fh, 15h, 20h
		db	 48h, 59h, 50h, 45h, 52h, 20h
		db	 15h, 1Fh
		db	53h
data_b_0E5C	db	48h			; Data table (indexed access)
		db	 49h, 45h, 4Ch, 44h, 1Fh, 15h
		db	 00h,0B8h, 32h, 00h,0BAh, 90h
		db	 00h,0E8h, 15h
data_b_0E6C	db	0Eh
		db	 15h, 1Fh, 45h, 4Eh, 45h, 52h
		db	 47h, 59h, 1Fh, 15h
		db	 20h, 53h, 50h, 41h, 43h
data_b_0E7C	db	45h			; Data table (indexed access)
		db	 20h, 15h, 1Fh, 45h, 4Eh, 45h
		db	 52h, 47h, 59h, 1Fh, 15h
		db	 20h, 20h, 20h, 20h
data_b_0E8C	db	15h
		db	 1Fh, 45h, 4Eh, 45h, 52h, 47h
		db	 59h, 1Fh, 15h
		db	 20h, 53h, 50h, 41h, 43h, 45h
data_b_0E9C	db	20h
		db	 15h, 1Fh, 45h, 4Eh, 45h, 52h
		db	 47h, 59h, 1Fh, 15h, 00h,0B8h
		db	 32h, 00h,0BAh
data_b_0EAC	db	98h
		db	 00h,0E8h,0D1h, 0Dh, 18h, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
		db	 1Ah, 1Dh, 1Dh
data_b_0EBC	db	1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Ah, 1Dh
		db	 1Dh, 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
		db	 17h
		db	 20h, 20h
data_b_0ECC	db	20h
		db	 20h, 18h
		db	7 dup (1Dh)
		db	 1Ah, 1Dh, 1Dh, 1Dh, 1Dh, 1Dh
data_b_0EDC	db	1Dh
		db	 1Dh, 1Ah, 1Dh, 1Dh, 1Dh, 1Dh
		db	 1Dh, 1Dh, 1Dh, 17h, 00h,0C3h

;==== External Entry into Subroutine ======================================

sub_b_0EE9:
		mov	ax,78h
		mov	dx,8
		call	sub_b_1C82
		and	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		adc	ax,[bx+si]
		mov	ax,78h
		mov	dx,10h
		call	sub_b_1C82
data_b_0F25	db	'   G A M E    I N S T R U C T I '
		db	'O N S  ', 0
		db	0B8h, 78h, 00h,0BAh, 10h, 00h
		db	0E8h, 2Ch, 0Dh, 0Bh
		db	8
data_b_0F58	db	8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
		db	8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
		db	8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
		db	8, 8, 9, 0
		db	0B8h, 0Ah, 00h,0BAh, 20h, 00h
		db	0E8h,0F9h
		db	0Ch
data_b_0F89	db	'OBJECT: Destroy the other ship w'
		db	'ith PHOTON TORPEDOS or', 0Dh, 0Ah
		db	'        PHASERS until all its SH'
		db	'IELD energy is gone.', 0Dh, 0Ah, 0Dh
		db	0Ah, 'WEAPONS:PHOTON TORPEDOS - U'
		db	'se = 1 unit, Damage = 4 units.', 0Dh
		db	0Ah, '        PHASERS         - U'
		db	'se = 1 unit, Damage = 2 units.', 0Dh
		db	0Ah, 0Dh, 0Ah, 'DEFENSE:IMPULSE E'
		db	'NGINES - Use = 1 unit every 1/2 '
		db	'second.', 0Dh, 0Ah, '        CLO'
		db	'AK           - Use = 1 unit ever'
		db	'y 1/2 second.', 0Dh, 0Ah, '     '
		db	'   HYPER SPACE     - Use = 8 uni'
		db	'ts.', 0Dh, 0Ah, 'COMMENT:You mus'
		db	't have energy to use WEAPONS or '
		db	'DEFENCES.', 0Dh, 0Ah, '        E'
		db	'NERGY is recharged at 1 unit eve'
		db	'ry 2 seconds.', 0Dh, 0Ah, '     '
		db	'   Use PHASERS to shoot incoming'
		db	' PHOTON TORPEDOS.', 0Dh, 0Ah, ' '
		db	'       The WARNING sound indicat'
		db	'es SHIELD power too low.', 0Dh, 0Ah
		db	'        Touching the PLANET will'
		db	' drain your SHIELDS.', 0Dh, 0Ah, ' '
		db	'       The Left Robot player is '
		db	'defensive.', 0Dh, 0Ah, '        '
		db	'The Right Robot player is offens'
		db	'ive.', 0Dh, 0Ah, '        Functi'
		db	'on key 8 toggles sound on or off'
		db	'.', 0Dh, 0Ah, 0
		db	0C3h

;==== External Entry into Subroutine ======================================

sub_b_12B8:
		mov	ax,0Ah
		mov	dx,20h
		call	sub_b_1C82
		db	'SPACEWAR is distributed under th'
		db	'e USER-SUPPORTED', 0Dh, 0Ah, 'co'
		db	'ncept.  You are encouraged to co'
		db	'py and share this', 0Dh, 0Ah, 'p'
		db	'rogram with other users.  If you'
		db	' enjoy SPACEWAR, and want me', 0Dh
		db	0Ah, 'to finish SPACE MINEZ your '
		db	'contribution ($'
		db	'20 suggested) will', 0Dh, 0Ah, 'b'
		db	'e appreciated.  For a $'
		db	'30 contribution you will receive'
		db	' the', 0Dh, 0Ah, 'source code fo'
		db	'r latest version of SPACEWAR.', 0Dh
		db	0Ah, 0Dh, 0Ah, 'USER-SUPPORTED so'
		db	'ftware is based on these three b'
		db	'eliefs:', 0Dh, 0Ah, ' 1.  The va'
		db	'lue of software is best assessed'
		db	' by the', 0Dh, 0Ah, '     user o'
		db	'n his own system.', 0Dh, 0Ah, ' '
		db	'2.  Creation of personal compute'
		db	'r software can and', 0Dh, 0Ah, ' '
		db	'    should be supported by compu'
		db	'ting community.', 0Dh, 0Ah, ' 3.'
		db	'  That copying of programs shoul'
		db	'd be encourged,', 0Dh, 0Ah, '   '
		db	'  rather than restricted.', 0Dh, 0Ah
		db	0Dh, 0Ah, 'Bill Seiler == 317 Loc'
		db	'kewood Lane == Scotts Valley, CA'
		db	'. 95066', 0Dh, 0Ah, 0
		db	0C3h

;==== External Entry into Subroutine ======================================

sub_b_159A:
		mov	ax,0
		mov	dx,0B8h
		call	sub_b_1C82
		and	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bp+di],dl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		adc	cx,[bx+si]
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bp+di],dl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		adc	cx,[bx+si]
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bp+di],dl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		adc	cx,[bx+si]
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bp+di],dl
;*		add	byte ptr data_a_0000[bx+si],bh	; ('SORRY !  You need a 640 ')
		db	 00h,0B8h, 00h, 00h	;  Fixup - byte match
		mov	dx,0C0h
		call	sub_b_1C82
		and	[bx+di],al
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+di],cl
		add	cl,[bx+si]
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bp+di],ax
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+di],cl
		add	al,8
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[di],ax
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+di],cl
		push	es
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+di],cl
		pop	es
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+si],cl
		or	[bx+di],cl
;*		add	byte ptr data_a_0000[bx+si],bh	; ('SORRY !  You need a 640 ')
		db	 00h,0B8h, 00h, 00h	;  Fixup - byte match
		mov	dx,0C0h
		call	sub_b_1C82
		and	[bx+si],ah
		pop	ds
		and	[di+58h],al
		dec	cx
		push	sp
		and	[bx],bl
		and	[bx+si],ah
		pop	ds
		and	[bx+si+4Ch],dl
		inc	cx
		pop	cx
		and	[bx],bl
		and	[bx+si],ah
		pop	ds
		push	dx
		dec	di
		inc	dx
		dec	di
		push	sp
		pop	ds
		dec	sp
		and	[bx+si],ah
		pop	ds
		push	dx
		dec	di
		inc	dx
		dec	di
		push	sp
		pop	ds
		push	dx
		and	[bx+si],ah
		pop	ds
		push	ax
		dec	sp
		inc	cx
		dec	si
		inc	bp
		push	sp
		pop	ds
		and	[bx+si],ah
		inc	di
		push	dx
		inc	cx
		push	si
		dec	cx
		push	sp
		pop	cx
		and	[bx+si],ah
		and	[bx+si+41h],dl
		push	bp
		push	bx
		inc	bp
		and	[bx+si],al
		test	byte ptr ds:d_0166_1076_e,1
		jz	loc_b_1686		; Jump if zero
		call	sub_b_16D3
loc_b_1686:
		test	byte ptr ds:d_0166_1076_e,2
		jz	loc_b_1690		; Jump if zero
		call	sub_b_16E5
loc_b_1690:
		test	byte ptr ds:d_0166_2040_e,1
		jz	loc_b_169A		; Jump if zero
		call	sub_b_16F7
loc_b_169A:
		test	byte ptr ds:d_0166_2040_e,2
		jz	loc_b_16A4		; Jump if zero
		call	sub_b_1709
loc_b_16A4:
		test	byte ptr ds:d_0166_0170_e,1
		jz	loc_ret_b_16AE		; Jump if zero
		call	sub_b_171B

loc_ret_b_16AE:
		retn
sub_b_0AD2	endp

			                        ;* No entry point to code
		mov	ax,14h
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn
			                        ;* No entry point to code
		mov	ax,6Eh
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_16D3	proc	near
		mov	ax,0C8h
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn
sub_b_16D3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_16E5	proc	near
		mov	ax,122h
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn
sub_b_16E5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_16F7	proc	near
		mov	ax,17Ch
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn
sub_b_16F7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1709	proc	near
		mov	ax,1D6h
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn
sub_b_1709	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_171B	proc	near
		mov	ax,230h
		mov	dx,0C0h
		call	sub_b_1C82
		or	al,0Ch
		or	al,0Ch
		or	al,0Ch
		or	al,0
		retn
sub_b_171B	endp

			                        ;* No entry point to code
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	di
		push	bp
		push	ds
		push	es
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		mov	ax,seg_a
		mov	ds,ax
		inc	data_a_1080
		test	data_a_1080,3
		jnz	loc_b_177C		; Jump if not zero
		mov	ax,40h
		mov	es,ax
		inc	word ptr es:d_0040_006C_e
		jnz	loc_b_175B		; Jump if not zero
		inc	word ptr es:d_0040_006E_e
loc_b_175B:
		cmp	word ptr es:d_0040_006E_e,18h
		jne	loc_b_177C		; Jump if not equal
		cmp	word ptr es:d_0040_006C_e,0B0h
		jne	loc_b_177C		; Jump if not equal
		xor	ax,ax			; Zero register
		mov	es:d_0040_006C_e,ax
		mov	es:d_0040_006E_e,ax
		mov	byte ptr es:d_0040_0070_e,1
loc_b_177C:
		mov	al,data_a_1080
		and	al,0Fh
		jnz	loc_b_1793		; Jump if not zero
		mov	bx,250h
		mov	dx,18h
		inc	data_a_2041
		mov	al,data_a_2041
		call	sub_b_1CE2
loc_b_1793:
		test	byte ptr ds:[126Fh],80h
		jnz	loc_b_17B1		; Jump if not zero
		test	data_a_107A,1
		jnz	loc_b_17B6		; Jump if not zero
		call	sub_b_16D3
		xor	data_a_1076,1
		or	data_a_107A,1
		jmp	short loc_b_17B6
		db	90h
loc_b_17B1:
		and	data_a_107A,0FEh
loc_b_17B6:
		test	byte ptr ds:[1270h],80h
		jnz	loc_b_17D4		; Jump if not zero
		test	data_a_107A,2
		jnz	loc_b_17D9		; Jump if not zero
		call	sub_b_16E5
		xor	data_a_1076,2
		or	data_a_107A,2
		jmp	short loc_b_17D9
		db	90h
loc_b_17D4:
		and	data_a_107A,0FDh
loc_b_17D9:
		test	byte ptr ds:[1271h],80h
		jnz	loc_b_17F7		; Jump if not zero
		test	data_a_107A,4
		jnz	loc_b_17FC		; Jump if not zero
		call	sub_b_16F7
		xor	data_a_2040,1
		or	data_a_107A,4
		jmp	short loc_b_17FC
		db	90h
loc_b_17F7:
		and	data_a_107A,0FBh
loc_b_17FC:
		test	byte ptr ds:[1272h],80h
		jnz	loc_b_181A		; Jump if not zero
		test	data_a_107A,8
		jnz	loc_b_181F		; Jump if not zero
		call	sub_b_1709
		xor	data_a_2040,2
		or	data_a_107A,8
		jmp	short loc_b_181F
		db	90h
loc_b_181A:
		and	data_a_107A,0F7h
loc_b_181F:
		test	byte ptr ds:[1273h],80h
		jnz	loc_b_183D		; Jump if not zero
		test	data_a_107A,10h
		jnz	loc_b_1842		; Jump if not zero
		call	sub_b_171B
		xor	data_a_0170,1
		or	data_a_107A,10h
		jmp	short loc_b_1842
		db	90h
loc_b_183D:
		and	data_a_107A,0EFh
loc_b_1842:
		test	byte ptr ds:[1274h],80h
		jnz	loc_b_185D		; Jump if not zero
		test	data_a_107A,20h		; ' '
		jnz	loc_b_1862		; Jump if not zero
		xor	data_a_2292,1
		or	data_a_107A,20h		; ' '
		jmp	short loc_b_1862
		db	90h
loc_b_185D:
		and	data_a_107A,0DFh
loc_b_1862:
		test	byte ptr ds:[126Eh],80h
		jnz	loc_b_186C		; Jump if not zero
		jmp	loc_b_00BC
loc_b_186C:
		test	byte ptr ds:[126Dh],80h
		jnz	loc_b_1876		; Jump if not zero
		jmp	loc_b_0095
loc_b_1876:
		pop	es
		pop	ds
		pop	bp
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1880	proc	near
		cli				; Disable interrupts
		mov	ax,0
		mov	es,ax
		mov	si,d_0000_0020_e
		mov	ax,172Dh
		mov	es:[si],ax
		mov	es:[si+2],cs
		sti				; Enable interrupts
		retn
sub_b_1880	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1895	proc	near
		sti				; Enable interrupts
loc_b_1896:
		test	byte ptr ds:d_0166_0170_e,1
		jnz	loc_b_1896		; Jump if not zero
		retn
sub_b_1895	endp

		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_18A0	proc	near
		mov	data_a_0930,10h
		mov	di,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	si,offset 10h		; ('d a 640 X 200 Color Grap')
		call	sub_b_1AB1
		jc	loc_b_18B4		; Jump if carry Set
		jmp	loc_b_1990
loc_b_18B4:
		mov	ax,data_a_0DDC
		mov	bx,data_a_0D9C
		mov	cx,data_a_0DEC
		mov	dx,data_a_0DAC
		sar	bx,1			; Shift w/sign fill
		rcr	ax,1			; Rotate thru carry
		sar	dx,1			; Shift w/sign fill
		rcr	cx,1			; Rotate thru carry
		mov	data_a_0DDC,cx
		mov	data_a_0D9C,dx
		mov	data_a_0DEC,ax
		mov	data_a_0DAC,bx
		mov	ax,data_a_0DFC
		mov	bx,data_a_0DBC
		mov	cx,data_a_0E0C
		mov	dx,data_a_0DCC
		sar	bx,1			; Shift w/sign fill
		rcr	ax,1			; Rotate thru carry
		sar	dx,1			; Shift w/sign fill
		rcr	cx,1			; Rotate thru carry
		mov	data_a_0DFC,cx
		mov	data_a_0DBC,dx
		mov	data_a_0E0C,ax
		mov	data_a_0DCC,bx
		mov	si,data_a_0D1C
		mov	di,data_a_0D2C
		cmp	di,si
		js	loc_b_1925		; Jump if sign=1
		sub	si,2
		jns	loc_b_1915		; Jump if not sign
		add	si,280h
loc_b_1915:
		add	di,2
		cmp	di,280h
		js	loc_b_1922		; Jump if sign=1
		sub	di,280h
loc_b_1922:
		jmp	short loc_b_193B
		db	90h
loc_b_1925:
		sub	di,2
		jns	loc_b_192E		; Jump if not sign
		add	di,280h
loc_b_192E:
		add	si,2
		cmp	si,280h
		js	loc_b_193B		; Jump if sign=1
		sub	si,280h
loc_b_193B:
		mov	data_a_0D1C,si
		mov	data_a_0D2C,di
		mov	si,data_a_0D3C
		mov	di,data_a_0D4C
		cmp	di,si
		js	loc_b_1968		; Jump if sign=1
		sub	si,2
		jns	loc_b_1958		; Jump if not sign
		add	si,0C8h
loc_b_1958:
		add	di,2
		cmp	di,0C8h
		js	loc_b_1965		; Jump if sign=1
		sub	di,0C8h
loc_b_1965:
		jmp	short loc_b_197E
		db	90h
loc_b_1968:
		sub	di,2
		jns	loc_b_1971		; Jump if not sign
		add	di,0C8h
loc_b_1971:
		add	si,2
		cmp	si,0C8h
		js	loc_b_197E		; Jump if sign=1
		sub	si,0C8h
loc_b_197E:
		mov	data_a_0D3C,si
		mov	data_a_0D4C,di
		or	data_a_0E1C,1
		or	data_a_0E2C,1
loc_b_1990:
		mov	di,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	si,offset 10h		; ('d a 640 X 200 Color Grap')
		mov	data_a_0932,20h
		mov	data_a_0930,8
		call	sub_b_1A66
		mov	di,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	data_a_0932,10h
		mov	data_a_0930,8
		call	sub_b_1A66
		mov	di,offset 10h		; ('d a 640 X 200 Color Grap')
		mov	si,offset data_a_0000	; ('SORRY !  You need a 640 ')
		mov	data_a_0932,10h
		mov	data_a_0930,8
		call	sub_b_1A66
		mov	di,offset 10h		; ('d a 640 X 200 Color Grap')
		mov	si,offset 10h		; ('d a 640 X 200 Color Grap')
		mov	data_a_0932,20h
		mov	data_a_0930,8
		call	sub_b_1A66
		mov	data_a_0930,6
		mov	data_a_0932,20h
		mov	di,offset data_a_0000	; ('SORRY !  You need a 640 ')
loc_b_19F3:
		inc	di
		inc	di
		cmp	di,10h
		jae	loc_b_1A02		; Jump if above or =
		mov	si,offset 10h		; ('d a 640 X 200 Color Grap')
		call	sub_b_1A66
		jmp	short loc_b_19F3
loc_b_1A02:
		test	data_a_2040,1
		jz	loc_ret_b_1A65		; Jump if zero
		mov	si,data_a_FFFE_e
loc_b_1A0C:
		inc	si
		inc	si
		cmp	si,20h
		jae	loc_ret_b_1A65		; Jump if above or =
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_1A0C		; Jump if zero
		js	loc_b_1A0C		; Jump if sign=1
		mov	ax,data_a_0D1C[si]
		sub	ax,13Fh
		jns	loc_b_1A27		; Jump if not sign
		neg	ax
loc_b_1A27:
		cmp	ax,10h
		jae	loc_b_1A0C		; Jump if above or =
		mov	ax,data_a_0D3C[si]
		sub	ax,63h
		jns	loc_b_1A37		; Jump if not sign
		neg	ax
loc_b_1A37:
		cmp	ax,10h
		jae	loc_b_1A0C		; Jump if above or =
		cmp	si,0
		jne	loc_b_1A48		; Jump if not equal
		sub	data_a_0EFC,2
		jmp	short loc_b_1A0C
loc_b_1A48:
		cmp	si,10h
		jne	loc_b_1A54		; Jump if not equal
		sub	data_a_0F0C,2
		jmp	short loc_b_1A0C
loc_b_1A54:
		call	sub_b_1BC1
		cli				; Disable interrupts
		mov	data_a_0E1C[si],0
		mov	byte ptr data_a_0E3C[si],0FFh
		sti				; Enable interrupts
		jmp	short loc_b_1A0C

loc_ret_b_1A65:
		retn
sub_b_18A0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1A66	proc	near
loc_b_1A66:
		sti				; Enable interrupts
		inc	si
		inc	si
		cmp	si,data_a_0932
		jae	loc_ret_b_1AB0		; Jump if above or =
		call	sub_b_1AB1
		jnc	loc_b_1A66		; Jump if carry=0
		push	di
		call	sub_b_1BC1
		cli				; Disable interrupts
		mov	data_a_0E1C[si],0
		mov	byte ptr data_a_0E3C[si],0FFh
		sti				; Enable interrupts
		pop	di
		cmp	di,0
		jne	loc_b_1A91		; Jump if not equal
		sub	data_a_0EFC,4
		jmp	short loc_b_1A66
loc_b_1A91:
		cmp	di,10h
		jne	loc_b_1A9D		; Jump if not equal
		sub	data_a_0F0C,4
		jmp	short loc_b_1A66
loc_b_1A9D:
		push	di
		mov	si,di
		call	sub_b_1BC1
		pop	di
		cli				; Disable interrupts
		mov	data_a_0E1C[di],0
		mov	byte ptr data_a_0E3C[di],0FFh
		sti				; Enable interrupts

loc_ret_b_1AB0:
		retn
sub_b_1A66	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1AB1	proc	near
		test	byte ptr data_a_0E3C[di],0FFh
		jz	loc_ret_b_1AE5		; Jump if zero
		js	loc_ret_b_1AE5		; Jump if sign=1
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_ret_b_1AE5		; Jump if zero
		js	loc_ret_b_1AE5		; Jump if sign=1
		mov	ax,data_a_0D3C[di]
		sub	ax,data_a_0D3C[si]
		jns	loc_b_1ACF		; Jump if not sign
		neg	ax
loc_b_1ACF:
		mov	cx,data_a_0930
		cmp	ax,cx
		jae	loc_ret_b_1AE5		; Jump if above or =
		mov	ax,data_a_0D1C[di]
		sub	ax,data_a_0D1C[si]
		jns	loc_b_1AE3		; Jump if not sign
		neg	ax
loc_b_1AE3:
		cmp	ax,cx

loc_ret_b_1AE5:
		retn
sub_b_1AB1	endp

		db	10 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1AF0	proc	near
		mov	es,word ptr ds:[1060h]
		mov	bx,word ptr ds:[105Ch]
		mov	dx,word ptr ds:[105Eh]

;==== External Entry into Subroutine ======================================

sub_b_1AFC:
		mov	ax,bx
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	di,dx
		shl	di,1			; Shift w/zeros fill
		mov	di,word ptr ds:[1085h][di]
		add	di,ax
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		mov	al,byte ptr ds:[940h][bx]
		xor	es:[di],al
		retn
sub_b_1AF0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1B1A	proc	near
loc_b_1B1A:
		mov	es,data_a_1060
		xor	bx,bx			; Zero register
		mov	bl,ch
		shr	bx,1			; Shift w/zeros fill
		sub	ax,bx
		jns	loc_b_1B2B		; Jump if not sign
		add	ax,280h
loc_b_1B2B:
		mov	cl,al
		and	cl,7
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	di,dx
		sub	di,bx
		jns	loc_b_1B40		; Jump if not sign
		add	di,offset data_a_00C8
loc_b_1B40:
		shl	di,1			; Shift w/zeros fill
		mov	di,data_a_1085[di]
		add	di,ax
		push	si
		mov	si,bp
		mov	bx,1FFEh
		mov	bp,4000h
		cld				; Clear direction
loc_b_1B52:
		lodsw				; String [si] to ax
		xor	dx,dx			; Zero register
		mov	dh,al
		shr	ax,cl			; Shift w/zeros fill
		shr	dx,cl			; Shift w/zeros fill
		xor	es:[di],ah
		inc	di
		xor	es:[di],al
		inc	di
		xor	es:[di],dl
		add	di,bx
		cmp	di,bp
		jb	loc_b_1B70		; Jump if below
		sub	di,3FB0h
loc_b_1B70:
		dec	ch
		jnz	loc_b_1B52		; Jump if not zero
		pop	si
		retn
sub_b_1B1A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1B76	proc	near
		test	data_a_0CCC,1
		jz	loc_b_1B96		; Jump if zero
		retn

;==== External Entry into Subroutine ======================================

sub_b_1B7E:
		test	data_a_0CBC,1
		jz	loc_b_1B9F		; Jump if zero
		retn

;==== External Entry into Subroutine ======================================

sub_b_1B86:
		test	data_a_0CCC,1
		jnz	loc_b_1B96		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_b_1B8E:
		test	data_a_0CBC,1
		jnz	loc_b_1B9F		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_b_1B96:
loc_b_1B96:
		mov	si,10h
		mov	bp,1540h
		jmp	short loc_b_1BA5
			                        ;* No entry point to code
		nop
loc_b_1B9F:
		mov	si,d_0168_0000_e
		mov	bp,1340h
loc_b_1BA5:
		mov	ax,ds:d_0166_0D5C_e[si]
		mov	dx,ds:d_0166_0D7C_e[si]
		mov	bl,ds:d_0166_0E7C_e[si]
		add	bl,8
		and	bx,0F0h
		shl	bx,1			; Shift w/zeros fill
		add	bp,bx
		mov	ch,10h
		jmp	short loc_b_1BE5
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_1BC1:
		mov	ax,data_a_0D5C[si]
		mov	dx,data_a_0D7C[si]
		mov	bl,data_a_0E7C[si]
		mov	ch,8
		mov	bp,1740h
		cmp	si,10h
		jb	loc_b_1BDA		; Jump if below
		mov	bp,17C0h
loc_b_1BDA:
		add	bl,10h
		and	bx,0E0h
		shr	bx,1			; Shift w/zeros fill
		add	bp,bx
loc_b_1BE5:
		xor	data_a_0CBC[si],1
		jmp	loc_b_1B1A
sub_b_1B76	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1BED	proc	near
		mov	ax,0Ah
		mov	dx,0B8h
		mov	bl,53h			; 'S'
		xor	data_a_1079,1
		jmp	short loc_b_1C2D
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_1BFD:
		mov	ax,276h
		mov	dx,0B8h
		mov	bl,53h			; 'S'
		xor	data_a_1079,2
		jmp	short loc_b_1C2D
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_1C0D:
		mov	ax,0Ah
		mov	dx,0C0h
		mov	bl,45h			; 'E'
		xor	data_a_1079,4
		jmp	short loc_b_1C2D
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_1C1D:
		mov	ax,276h
		mov	dx,0C0h
		mov	bl,45h			; 'E'
		xor	data_a_1079,8
		jmp	short loc_b_1C2D
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_1C2D:
loc_b_1C2D:
		cmp	bl,0Dh
		jne	loc_b_1C38		; Jump if not equal
		mov	ax,0Ah
		jmp	short loc_ret_b_1C81
		db	90h
loc_b_1C38:
		cmp	bl,0Ah
		jne	loc_b_1C43		; Jump if not equal
		add	dx,8
		jmp	short loc_ret_b_1C81
		db	90h
loc_b_1C43:
		cmp	bl,1Fh
		jne	loc_b_1C4E		; Jump if not equal
		add	ax,5
		jmp	short loc_b_1C6C
		db	90h
loc_b_1C4E:
		cmp	bl,20h			; ' '
		je	loc_b_1C69		; Jump if equal
		mov	ch,8
		mov	bp,22A0h

		;and	bx,7Fh
		db	81h, 0e3h, 7Fh, 0

		mov	cl,4
		shl	bx,cl			; Shift w/zeros fill
		add	bp,bx
		push	ax
		push	dx
		call	sub_b_1B1A
		pop	dx
		pop	ax
loc_b_1C69:
		add	ax,0Ah
loc_b_1C6C:
		cmp	ax,280h
		jb	loc_ret_b_1C81		; Jump if below
		sub	ax,280h
		add	dx,8
		cmp	dx,0C8h
		jb	loc_ret_b_1C81		; Jump if below
		sub	dx,0C8h

loc_ret_b_1C81:
		retn
sub_b_1BED	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1C82	proc	near
		jmp	short loc_b_1C88
		db	90h
loc_b_1C85:
		call	sub_b_1C2D
loc_b_1C88:
		pop	bp
		mov	bl,cs:[bp]
		inc	bp
		push	bp
		and	bl,bl
		jnz	loc_b_1C85		; Jump if not zero
		retn
sub_b_1C82	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1C94	proc	near
		mov	ax,dx
		xor	dx,dx			; Zero register
		mov	cx,0Ah
		div	cx			; ax,dx rem=dx:ax/reg
		push	dx
		mov	dx,ax
		or	ax,ax			; Zero ?
		jz	loc_b_1CA7		; Jump if zero
		call	sub_b_1C94
loc_b_1CA7:
		pop	bx
		add	bl,30h			; '0'
		mov	ax,si
		mov	dx,di
		call	sub_b_1C2D
		mov	si,ax
		mov	di,dx
		retn
sub_b_1C94	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1CB7	proc	near
		push	cx
		mov	ax,ds:d_0166_038D_e[si]
		mov	dx,ds:d_0166_0441_e[si]
		mov	bp,ds:d_0166_0171_e[si]
		mov	cl,4
		shl	bp,cl			; Shift w/zeros fill
		add	bp,22A0h
		mov	ch,8
		call	sub_b_1B1A
		pop	cx
		retn
sub_b_1CB7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1CD3	proc	near
		mov	es,data_a_1060
		mov	cx,2000h
		xor	ax,ax			; Zero register
		xor	di,di			; Zero register
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn
sub_b_1CD3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1CE2	proc	near
		mov	es,data_a_1060
		and	ax,0Fh
		mov	si,ax
		mov	cl,7
		shl	si,cl			; Shift w/zeros fill
		add	si,offset data_a_1840
		sub	bx,10h
		sub	dx,10h
		mov	di,dx
		shl	di,1			; Shift w/zeros fill
		mov	di,data_a_1085[di]
		shr	bx,1			; Shift w/zeros fill
		shr	bx,1			; Shift w/zeros fill
		shr	bx,1			; Shift w/zeros fill
		add	di,bx
		mov	cx,20h
		mov	bx,1FFEh
		mov	dx,3FB0h
		mov	bp,4000h
		cld				; Clear direction

locloop_b_1D16:
		lodsw				; String [si] to ax
		xchg	ah,al
		mov	es:[di],ax
		inc	di
		inc	di
		lodsw				; String [si] to ax
		xchg	ah,al
		mov	es:[di],ax
		add	di,bx
		cmp	di,bp
		jb	loc_b_1D2C		; Jump if below
		sub	di,dx
loc_b_1D2C:
		loop	locloop_b_1D16		; Loop if cx > 0

		retn
sub_b_1CE2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1D2F	proc	near
		mov	es,data_a_1060
		cld				; Clear direction
		mov	al,data_a_0EFC
		or	al,al			; Zero ?
		js	loc_b_1D6C		; Jump if sign=1
		mov	di,data_a_11F5
		add	di,3
		mov	cl,al
;*		and	cx,0Fh
		db	 81h,0E1h, 0Fh, 00h	;  Fixup - byte match
		mov	dx,0FFFFh
		shr	dx,cl			; Shift w/zeros fill
		not	dx
		mov	cl,al
		xor	ch,ch			; Zero register
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		or	cx,cx			; Zero ?
		jz	loc_b_1D64		; Jump if zero
		mov	ax,0FFFFh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
loc_b_1D64:
		mov	ax,dx
		xchg	al,ah
		stosw				; Store ax to es:[di]
		xor	ax,ax			; Zero register
		stosw				; Store ax to es:[di]
loc_b_1D6C:
		mov	al,data_a_0F1C
		or	al,al			; Zero ?
		js	loc_b_1DA2		; Jump if sign=1
		mov	di,data_a_1205
		add	di,3
		mov	cl,al
;*		and	cx,0Fh
		db	 81h,0E1h, 0Fh, 00h	;  Fixup - byte match
		mov	dx,0FFFFh
		shr	dx,cl			; Shift w/zeros fill
		not	dx
		mov	cl,al
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		or	cx,cx			; Zero ?
		jz	loc_b_1D9A		; Jump if zero
		mov	ax,0FFFFh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
loc_b_1D9A:
		mov	ax,dx
		xchg	al,ah
		stosw				; Store ax to es:[di]
		xor	ax,ax			; Zero register
		stosw				; Store ax to es:[di]
loc_b_1DA2:
		std				; Set direction flag
		mov	al,data_a_0F0C
		or	al,al			; Zero ?
		js	loc_b_1DD9		; Jump if sign=1
		mov	di,data_a_11F5
		add	di,4Bh
		mov	cl,al
;*		and	cx,0Fh
		db	 81h,0E1h, 0Fh, 00h	;  Fixup - byte match
		mov	dx,0FFFFh
		shl	dx,cl			; Shift w/zeros fill
		not	dx
		mov	cl,al
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		or	cx,cx			; Zero ?
		jz	loc_b_1DD1		; Jump if zero
		mov	ax,0FFFFh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
loc_b_1DD1:
		mov	ax,dx
		xchg	al,ah
		stosw				; Store ax to es:[di]
		xor	ax,ax			; Zero register
		stosw				; Store ax to es:[di]
loc_b_1DD9:
		mov	al,data_a_0F2C
		or	al,al			; Zero ?
		js	loc_b_1E0F		; Jump if sign=1
		mov	di,data_a_1205
		add	di,4Bh
		mov	cl,al
;*		and	cx,0Fh
		db	 81h,0E1h, 0Fh, 00h	;  Fixup - byte match
		mov	dx,0FFFFh
		shl	dx,cl			; Shift w/zeros fill
		not	dx
		mov	cl,al
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		or	cx,cx			; Zero ?
		jz	loc_b_1E07		; Jump if zero
		mov	ax,0FFFFh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
loc_b_1E07:
		mov	ax,dx
		xchg	al,ah
		stosw				; Store ax to es:[di]
		xor	ax,ax			; Zero register
		stosw				; Store ax to es:[di]
loc_b_1E0F:
		cld				; Clear direction
		retn
sub_b_1D2F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1E11	proc	near
		mov	bp,12C0h
		mov	al,data_a_0F3C[si]
		and	ax,38h
		shl	ax,1			; Shift w/zeros fill
		add	bp,ax
		mov	ax,data_a_0D1C[si]
		mov	dx,data_a_0D3C[si]
		mov	ch,8
		jmp	loc_b_1B1A
sub_b_1E11	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1E30	proc	near
		mov	ax,data_a_0D1C[si]
		sub	ax,13Fh
		js	loc_b_1E56		; Jump if sign=1
		mov	dx,data_a_0D3C[si]
		sub	dx,63h
		js	loc_b_1E4C		; Jump if sign=1
		call	sub_b_1E85
		neg	bx
		neg	cx
		jmp	short loc_b_1E6E
		db	90h
loc_b_1E4C:
		neg	dx
		call	sub_b_1E85
		neg	bx
		jmp	short loc_b_1E6E
		db	90h
loc_b_1E56:
		neg	ax
		mov	dx,data_a_0D3C[si]
		sub	dx,63h
		js	loc_b_1E69		; Jump if sign=1
		call	sub_b_1E85
		neg	cx
		jmp	short loc_b_1E6E
		db	90h
loc_b_1E69:
		neg	dx
		call	sub_b_1E85
loc_b_1E6E:
		mov	ax,bx
		cwd				; Word to double word
		add	data_a_0DDC[si],ax
		adc	data_a_0D9C[si],dx
		mov	ax,cx
		cwd				; Word to double word
		add	data_a_0DFC[si],ax
		adc	data_a_0DBC[si],dx
		retn
sub_b_1E30	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1E85	proc	near
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	cx,dx
		shl	cx,1			; Shift w/zeros fill
		shl	cx,1			; Shift w/zeros fill
		shl	cx,1			; Shift w/zeros fill
		retn
sub_b_1E85	endp

		db	10 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1EA0	proc	near
		mov	ax,ds
		mov	es,ax
		mov	cx,64h
		xor	ax,ax			; Zero register
		mov	di,offset data_a_1085

locloop_b_1EAC:
		mov	bl,2
loc_b_1EAE:
		stosw				; Store ax to es:[di]
		add	ax,2000h
		dec	bl
		jnz	loc_b_1EAE		; Jump if not zero
		sub	ax,3FB0h
		loop	locloop_b_1EAC		; Loop if cx > 0

		retn
sub_b_1EA0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1EBC	proc	near
		mov	ax,0
		mov	es,ax
		mov	si,d_0000_0020_e
		mov	ax,es:[si]
		mov	data_a_1072,ax
		mov	ax,es:[si+2]
		mov	data_a_1074,ax
		mov	si,d_0000_0024_e
		mov	ax,es:[si]
		mov	data_a_106E,ax
		mov	ax,es:[si+2]
		mov	data_a_1070,ax
		retn
sub_b_1EBC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1EE2	proc	near
		cli				; Disable interrupts
		mov	ax,0
		mov	es,ax
		mov	si,d_0000_0020_e
		mov	ax,data_a_1072
		mov	es:[si],ax
		mov	ax,data_a_1074
		mov	es:[si+2],ax
		mov	al,36h			; '6'
		out	43h,al			; port 43h, 8253 timer control
		xor	al,al			; Zero register
		out	40h,al			; port 40h, 8253 timer 0 clock
		out	40h,al			; port 40h, 8253 timer 0 clock
		mov	si,d_0000_0024_e
		mov	ax,data_a_106E
		mov	es:[si],ax
		mov	ax,data_a_1070
		mov	es:[si+2],ax
		sti				; Enable interrupts
		retn
sub_b_1EE2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1F14	proc	near
		cli				; Disable interrupts
		mov	ax,0
		mov	es,ax
		mov	si,d_0000_0020_e
		mov	ax,233Dh
		mov	es:[si],ax
		mov	es:[si+2],cs
		sti				; Enable interrupts
		retn
sub_b_1F14	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1F29	proc	near
		mov	ax,ds
		mov	es,ax
		mov	si,offset data_a_0950
		mov	di,offset data_a_0CBC
		mov	cx,360h
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		call	sub_b_1CD3
		call	sub_b_2932
		call	sub_b_1B7E
		call	sub_b_1B76
		and	data_a_1079,0F0h
		call	sub_b_1BED
		call	sub_b_1BFD
		call	sub_b_1C0D
		call	sub_b_1C1D
		mov	byte ptr ds:[2290h],0
		retn
sub_b_1F29	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1F5C	proc	near
		mov	ax,6
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retn
sub_b_1F5C	endp

		db	14 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1F70	proc	near
		mov	ax,ds
		mov	es,ax
		mov	di,offset 1232h		; ('The Left Robot player is')
		mov	al,80h
		mov	cx,80h
		cld				; Clear direction
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		retn
sub_b_1F70	endp

			                        ;* No entry point to code
		push	ax
		push	dx
		push	di
		push	ds
		mov	ax,seg_a
		mov	ds,ax
		in	al,60h			; port 60h, keybd scan or sw1
		mov	di,ax

		;and	di,7Fh
		db	81h, 0e7h, 7Fh, 0

		mov	byte ptr data_a_1232[di],al
		in	al,61h			; port 61h, 8255 port B, read
		mov	ah,al
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
		xchg	al,ah
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		test	data_a_124F,80h
		jnz	loc_b_1FB6		; Jump if not zero
		test	data_a_126A,80h
		jnz	loc_b_1FB6		; Jump if not zero
		test	byte ptr ds:[1285h],80h
		jz	loc_b_1FBF		; Jump if zero
loc_b_1FB6:
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	ds
		pop	di
		pop	dx
		pop	ax
		iret				; Interrupt return
loc_b_1FBF:
		mov	ax,40h
		mov	ds,ax
		mov	word ptr ds:d_0040_0072_e,1234h
		xor	ax,ax			; Zero register
		dec	ax
		push	ax
		inc	ax
		push	ax
		retf				; Return far
		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1FE0	proc	near
		mov	data_a_1077,0
		mov	al,data_a_0F9C
		mov	ah,data_a_0FFC
		mov	bx,data_a_0FBC
		mov	cx,data_a_0FDC
		mov	data_a_107E,al
		mov	data_a_107F,ah
		mov	data_a_105C,bx
		mov	data_a_105E,cx
		jmp	loc_b_20A6

;==== External Entry into Subroutine ======================================

sub_b_2006:
		mov	data_a_1077,1
		mov	al,60h			; '`'
		cli				; Disable interrupts
		mov	ah,data_a_0E5C
		mov	bx,data_a_0D1C
		mov	cx,data_a_0D3C
		sti				; Enable interrupts
		mov	data_a_107E,al
		mov	data_a_107F,ah
		mov	data_a_0FFC,ah
		mov	data_a_0FBC,bx
		mov	data_a_105C,bx
		mov	data_a_0FDC,cx
		mov	data_a_105E,cx
		call	sub_b_28A7
		call	sub_b_20A6
		mov	al,data_a_107D
		mov	data_a_0F9C,al
		retn

;==== External Entry into Subroutine ======================================

sub_b_2043:
		mov	data_a_1077,0
		mov	al,data_a_0FAC
		mov	ah,data_a_100C
		mov	bx,data_a_0FCC
		mov	cx,data_a_0FEC
		mov	data_a_107E,al
		mov	data_a_107F,ah
		mov	data_a_105C,bx
		mov	data_a_105E,cx
		jmp	short loc_b_20A6
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_2069:
		mov	byte ptr ds:[1077h],1
		mov	al,60h			; '`'
		cli				; Disable interrupts
		assume	ds:seg_b
		mov	ah,data_b_0E6C
		mov	bx,data_b_0D2C
		mov	cx,data_b_0D4C
		sti				; Enable interrupts
		mov	byte ptr ds:[107Eh],al
		mov	byte ptr ds:[107Fh],ah
		mov	byte ptr ds:[100Ch],ah	; ('EDOS - Use = 1 unit, Dam')
		mov	word ptr ds:[0FCCh],bx
		mov	word ptr ds:[105Ch],bx
		mov	word ptr ds:[0FECh],cx
		mov	word ptr ds:[105Eh],cx
		call	sub_b_28A7
		call	sub_b_20A6
		mov	al,byte ptr ds:[107Dh]
		mov	byte ptr ds:[0FACh],al	; (' PHOTON TORPEDOS')
		retn

;==== External Entry into Subroutine ======================================

sub_b_20A6:
loc_b_20A6:
		xor	ax,ax			; Zero register
		assume	ds:seg_a
		mov	data_a_107D,al
		mov	data_a_106A,ax
		mov	data_a_106C,ax
		mov	bl,data_a_107F
		call	sub_b_27B0
		mov	dx,ax
		mov	bl,data_a_107F
		call	sub_b_27B3
		xor	di,di			; Zero register
		or	dx,dx			; Zero ?
		jns	loc_b_20CB		; Jump if not sign
		neg	dx
		inc	di
		inc	di
loc_b_20CB:
		or	ax,ax			; Zero ?
		jns	loc_b_20D2		; Jump if not sign
		neg	ax
		inc	di
loc_b_20D2:
		shl	dx,1			; Shift w/zeros fill
		js	loc_b_20DC		; Jump if sign=1
		shl	ax,1			; Shift w/zeros fill
		js	loc_b_20DE		; Jump if sign=1
		jmp	short loc_b_20D2
loc_b_20DC:
		shl	ax,1			; Shift w/zeros fill
loc_b_20DE:
		mov	word ptr ds:[1066h],dx
		mov	word ptr ds:[1068h],ax
		shl	di,1			; Shift w/zeros fill
		assume	ds:seg_b
		jmp	word ptr cs:data_b_20EC[di]	;*4 entries
data_b_20EC	dw	offset loc_b_20F4	; Data table (indexed access)
data_b_20EE	dw	offset loc_b_212B
data_b_20F0	dw	offset loc_b_2162
data_b_20F2	dw	offset loc_b_2199

;===== Indexed Entry Point ================================================

loc_b_20F4:
		xor	cx,cx			; Zero register
		call	sub_b_21D0
		call	sub_b_21FF
		or	cx,cx			; Zero ?
		jz	loc_b_20F4		; Jump if zero
		inc	byte ptr ds:[107Dh]
		mov	al,byte ptr ds:[107Dh]
		cmp	al,9
		jb	loc_b_20F4		; Jump if below
		call	sub_b_1AF0
		test	byte ptr ds:[1077h],0FFh
		jz	loc_b_2121		; Jump if zero
		mov	al,byte ptr ds:[107Dh]
		and	al,7
		jnz	loc_b_2121		; Jump if not zero
		call	sub_b_222E
		jc	loc_ret_b_212A		; Jump if carry Set
loc_b_2121:
		mov	al,byte ptr ds:[107Dh]
		cmp	al,byte ptr ds:[107Eh]
		jb	loc_b_20F4		; Jump if below

loc_ret_b_212A:
		retn

;===== Indexed Entry Point ================================================

loc_b_212B:
		xor	cx,cx			; Zero register
		call	sub_b_21D0
		call	sub_b_2217
		or	cx,cx			; Zero ?
		jz	loc_b_212B		; Jump if zero
		inc	byte ptr ds:[107Dh]
		mov	al,byte ptr ds:[107Dh]
		cmp	al,9
		jb	loc_b_212B		; Jump if below
		call	sub_b_1AF0
		test	byte ptr ds:[1077h],0FFh
		jz	loc_b_2158		; Jump if zero
		mov	al,byte ptr ds:[107Dh]
		and	al,7
		jnz	loc_b_2158		; Jump if not zero
		call	sub_b_222E
		jc	loc_ret_b_2161		; Jump if carry Set
loc_b_2158:
		mov	al,byte ptr ds:[107Dh]
		cmp	al,byte ptr ds:[107Eh]
		jb	loc_b_212B		; Jump if below

loc_ret_b_2161:
		retn

;===== Indexed Entry Point ================================================

loc_b_2162:
		xor	cx,cx			; Zero register
		call	sub_b_21E8
		call	sub_b_21FF
		or	cx,cx			; Zero ?
		jz	loc_b_2162		; Jump if zero
		inc	byte ptr ds:[107Dh]
		mov	al,byte ptr ds:[107Dh]
		cmp	al,9
		jb	loc_b_2162		; Jump if below
		call	sub_b_1AF0
		test	byte ptr ds:[1077h],0FFh
		jz	loc_b_218F		; Jump if zero
		mov	al,byte ptr ds:[107Dh]
		and	al,7
		jnz	loc_b_218F		; Jump if not zero
		call	sub_b_222E
		jc	loc_ret_b_2198		; Jump if carry Set
loc_b_218F:
		mov	al,byte ptr ds:[107Dh]
		cmp	al,byte ptr ds:[107Eh]
		jb	loc_b_2162		; Jump if below

loc_ret_b_2198:
		retn

;===== Indexed Entry Point ================================================

loc_b_2199:
		xor	cx,cx			; Zero register
		call	sub_b_21E8
		call	sub_b_2217
		or	cx,cx			; Zero ?
		jz	loc_b_2199		; Jump if zero
		inc	byte ptr ds:[107Dh]
		mov	al,byte ptr ds:[107Dh]
		cmp	al,9
		jb	loc_b_2199		; Jump if below
		call	sub_b_1AF0
		test	byte ptr ds:[1077h],0FFh
		jz	loc_b_21C6		; Jump if zero
		mov	al,byte ptr ds:[107Dh]
		and	al,7
		jnz	loc_b_21C6		; Jump if not zero
		call	sub_b_222E
		jc	loc_ret_b_21CF		; Jump if carry Set
loc_b_21C6:
		mov	al,byte ptr ds:[107Dh]
		cmp	al,byte ptr ds:[107Eh]
		jb	loc_b_2199		; Jump if below

loc_ret_b_21CF:
		retn
sub_b_1FE0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_21D0	proc	near
		mov	ax,word ptr ds:[1066h]
		add	word ptr ds:[106Ah],ax
		jnc	loc_ret_b_21FE		; Jump if carry=0
		inc	cx
		mov	ax,word ptr ds:[105Ch]
		inc	ax
		cmp	ax,280h
		jb	loc_b_21FB		; Jump if below
		xor	ax,ax			; Zero register
		jmp	short loc_b_21FB
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_21E8:
		mov	ax,word ptr ds:[1066h]
		add	word ptr ds:[106Ah],ax
		jnc	loc_ret_b_21FE		; Jump if carry=0
		inc	cx
		mov	ax,word ptr ds:[105Ch]
		dec	ax
		jns	loc_b_21FB		; Jump if not sign
		mov	ax,27Fh
loc_b_21FB:
		mov	word ptr ds:[105Ch],ax

loc_ret_b_21FE:
		retn
sub_b_21D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_21FF	proc	near
		mov	ax,word ptr ds:[1068h]
		add	word ptr ds:[106Ch],ax
		jnc	loc_ret_b_222D		; Jump if carry=0
		inc	cx
		mov	ax,word ptr ds:[105Eh]
		inc	ax
		cmp	ax,0C8h
		jb	loc_b_222A		; Jump if below
		xor	ax,ax			; Zero register
		jmp	short loc_b_222A
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_2217:
		mov	ax,word ptr ds:[1068h]
		add	word ptr ds:[106Ch],ax
		jnc	loc_ret_b_222D		; Jump if carry=0
		inc	cx
		mov	ax,word ptr ds:[105Eh]
		dec	ax
		jns	loc_b_222A		; Jump if not sign
		mov	ax,0C7h
loc_b_222A:
		mov	word ptr ds:[105Eh],ax

loc_ret_b_222D:
		retn
sub_b_21FF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_222E	proc	near
		mov	si,data_b_FFFE_e
loc_b_2231:
		mov	ax,word ptr ds:[105Eh]
loc_b_2234:
		inc	si
		inc	si
		cmp	si,20h
		jb	loc_b_225F		; Jump if below
		test	byte ptr ds:[2040h],1
		jz	loc_b_225D		; Jump if zero
		sub	ax,63h
		jns	loc_b_2249		; Jump if not sign
		neg	ax
loc_b_2249:
		cmp	ax,10h
		jae	loc_b_225D		; Jump if above or =
		mov	ax,word ptr ds:[105Ch]
		sub	ax,13Fh
		jns	loc_b_2258		; Jump if not sign
		neg	ax
loc_b_2258:
		cmp	ax,10h
		jb	loc_b_22AE		; Jump if below
loc_b_225D:
		clc				; Clear carry flag
		retn
loc_b_225F:
		test	data_b_0E3C[si],0FFh
		jz	loc_b_2234		; Jump if zero
		js	loc_b_2234		; Jump if sign=1
		sub	ax,data_b_0D3C[si]
		jns	loc_b_2270		; Jump if not sign
		neg	ax
loc_b_2270:
		cmp	ax,8
		jae	loc_b_2231		; Jump if above or =
		mov	ax,word ptr ds:[105Ch]
		sub	ax,data_b_0D1C[si]
		jns	loc_b_2280		; Jump if not sign
		neg	ax
loc_b_2280:
		cmp	ax,8
		jae	loc_b_2231		; Jump if above or =
		cmp	si,0
		jne	loc_b_2292		; Jump if not equal
		sub	word ptr ds:[0EFCh],2
		jmp	short loc_b_22AE
			                        ;* No entry point to code
		nop
loc_b_2292:
		cmp	si,10h
		jne	loc_b_229F		; Jump if not equal
		sub	word ptr ds:[0F0Ch],2
		jmp	short loc_b_22AE
		db	90h
loc_b_229F:
		call	sub_b_1BC1
		cli				; Disable interrupts
		mov	data_b_0E1C[si],0
		mov	data_b_0E3C[si],0FFh
		sti				; Enable interrupts
loc_b_22AE:
		stc				; Set carry flag
		retn
sub_b_222E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_22B0	proc	near
		call	sub_b_27B0
		jmp	short loc_b_22B9
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_22B6:
		call	sub_b_27B3
loc_b_22B9:
		cwd				; Word to double word
		push	cx
		mov	cx,3

locloop_b_22BE:
		sar	dx,1			; Shift w/sign fill
		rcr	ax,1			; Rotate thru carry
		loop	locloop_b_22BE		; Loop if cx > 0

		pop	cx
		retn
sub_b_22B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_22C6	proc	near
		assume	ds:seg_a
		mov	ax,data_a_0DDC[si]
		mov	dx,data_a_0D9C[si]
		add	data_a_0CDC[si],ax
		adc	dx,data_a_0D1C[si]
		jns	loc_b_22DC		; Jump if not sign
		add	dx,280h
loc_b_22DC:
		cmp	dx,8
		jae	loc_b_22E8		; Jump if above or =
		add	dx,270h
		jmp	short loc_b_22F2
		db	90h
loc_b_22E8:
		cmp	dx,278h
		jb	loc_b_22F2		; Jump if below
		sub	dx,270h
loc_b_22F2:
		mov	data_a_0D1C[si],dx
		cmp	dx,data_a_0D5C[si]
		je	loc_b_2301		; Jump if equal
		or	data_a_0E1C[si],1
loc_b_2301:
		mov	ax,data_a_0DFC[si]
		mov	dx,data_a_0DBC[si]
		add	data_a_0CFC[si],ax
		adc	dx,data_a_0D3C[si]
		jns	loc_b_2317		; Jump if not sign
		add	dx,0C8h
loc_b_2317:
		cmp	dx,8
		jae	loc_b_2323		; Jump if above or =
		add	dx,0B8h
		jmp	short loc_b_232D
		db	90h
loc_b_2323:
		cmp	dx,0C0h
		jb	loc_b_232D		; Jump if below
		sub	dx,0B8h
loc_b_232D:
		mov	data_a_0D3C[si],dx
		cmp	dx,data_a_0D7C[si]
		je	loc_ret_b_233C		; Jump if equal
		or	data_a_0E1C[si],1

loc_ret_b_233C:
		retn
sub_b_22C6	endp

			                        ;* No entry point to code
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	di
		push	bp
		push	ds
		push	es
		mov	ax,seg_a
		mov	ds,ax
		inc	data_a_1080
		test	data_a_1080,3
		jnz	loc_b_2388		; Jump if not zero
		mov	ax,40h
		mov	es,ax
		inc	word ptr es:d_0040_006C_e
		jnz	loc_b_2367		; Jump if not zero
		inc	word ptr es:d_0040_006E_e
loc_b_2367:
		cmp	word ptr es:d_0040_006E_e,18h
		jne	loc_b_2388		; Jump if not equal
		cmp	word ptr es:d_0040_006C_e,0B0h
		jne	loc_b_2388		; Jump if not equal
		xor	ax,ax			; Zero register
		mov	es:d_0040_006C_e,ax
		mov	es:d_0040_006E_e,ax
		mov	byte ptr es:d_0040_0070_e,1
loc_b_2388:
		test	data_a_0170,1
		jz	loc_b_2392		; Jump if zero
		jmp	loc_b_2781
loc_b_2392:
		test	data_a_0E3C,0FFh
		jz	loc_b_240A		; Jump if zero
		mov	al,data_a_0E5C
		add	al,data_a_0E9C
		mov	data_a_0E5C,al
		test	data_a_0EBC,1
		jz	loc_b_23F8		; Jump if zero
		mov	al,data_a_1080
		and	al,1Fh
		jnz	loc_b_23B8		; Jump if not zero
		dec	data_a_0F1C
		jz	loc_b_240A		; Jump if zero
loc_b_23B8:
		mov	bl,data_a_0E5C
		call	sub_b_22B0
		add	data_a_0DDC,ax
		adc	dx,data_a_0D9C
		mov	ax,dx
		or	ax,ax			; Zero ?
		jns	loc_b_23CF		; Jump if not sign
		neg	ax
loc_b_23CF:
		cmp	ax,8
		jae	loc_b_23D8		; Jump if above or =
		mov	data_a_0D9C,dx
loc_b_23D8:
		mov	bl,data_a_0E5C
		call	sub_b_22B6
		add	data_a_0DFC,ax
		adc	dx,data_a_0DBC
		mov	ax,dx
		or	ax,ax			; Zero ?
		jns	loc_b_23EF		; Jump if not sign
		neg	ax
loc_b_23EF:
		cmp	ax,8
		jae	loc_b_23F8		; Jump if above or =
		mov	data_a_0DBC,dx
loc_b_23F8:
		test	data_a_0EBC,2
		jz	loc_b_240A		; Jump if zero
		mov	al,data_a_1080
		and	al,1Fh
		jnz	loc_b_240A		; Jump if not zero
		dec	data_a_0F1C
loc_b_240A:
		test	data_a_0E4C,0FFh
		jz	loc_b_2482		; Jump if zero
		mov	al,data_a_0E6C
		add	al,data_a_0EAC
		mov	data_a_0E6C,al
		test	data_a_0ECC,1
		jz	loc_b_2470		; Jump if zero
		mov	al,data_a_1080
		and	al,1Fh
		jnz	loc_b_2430		; Jump if not zero
		dec	data_a_0F2C
		jz	loc_b_2482		; Jump if zero
loc_b_2430:
		mov	bl,data_a_0E6C
		call	sub_b_22B0
		add	data_a_0DEC,ax
		adc	dx,data_a_0DAC
		mov	ax,dx
		or	ax,ax			; Zero ?
		jns	loc_b_2447		; Jump if not sign
		neg	ax
loc_b_2447:
		cmp	ax,8
		jae	loc_b_2450		; Jump if above or =
		mov	data_a_0DAC,dx
loc_b_2450:
		mov	bl,data_a_0E6C
		call	sub_b_22B6
		add	data_a_0E0C,ax
		adc	dx,data_a_0DCC
		mov	ax,dx
		or	ax,ax			; Zero ?
		jns	loc_b_2467		; Jump if not sign
		neg	ax
loc_b_2467:
		cmp	ax,8
		jae	loc_b_2470		; Jump if above or =
		mov	data_a_0DCC,dx
loc_b_2470:
		test	data_a_0ECC,2
		jz	loc_b_2482		; Jump if zero
		mov	al,data_a_1080
		and	al,1Fh
		jnz	loc_b_2482		; Jump if not zero
		dec	data_a_0F2C
loc_b_2482:
		mov	si,data_a_FFFE_e
loc_b_2485:
		inc	si
		inc	si
		cmp	si,20h
		jae	loc_b_24A4		; Jump if above or =
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_2485		; Jump if zero
		js	loc_b_2485		; Jump if sign=1
		call	sub_b_22C6
		test	data_a_2040,2
		jz	loc_b_2485		; Jump if zero
		call	sub_b_1E30
		jmp	short loc_b_2485
loc_b_24A4:
		mov	al,data_a_1080
		and	al,1Fh
		jnz	loc_b_24F4		; Jump if not zero
		and	byte ptr ds:[2290h],0FEh
		test	byte ptr data_a_0E3C,0FFh
		jz	loc_b_24D2		; Jump if zero
		js	loc_b_24D2		; Jump if sign=1
		mov	al,data_a_0EFC
		cmp	al,10h
		jb	loc_b_24CA		; Jump if below
		test	data_a_1079,1
		jz	loc_b_24CF		; Jump if zero
		jmp	short loc_b_24D2
		db	90h
loc_b_24CA:
		or	byte ptr ds:[2290h],1
loc_b_24CF:
		call	sub_b_1BED
loc_b_24D2:
		test	byte ptr data_a_0E3C,0FFh
		jz	loc_b_24F4		; Jump if zero
		js	loc_b_24F4		; Jump if sign=1
		mov	al,data_a_0F0C
		cmp	al,10h
		jb	loc_b_24EC		; Jump if below
		test	data_a_1079,2
		jz	loc_b_24F1		; Jump if zero
		jmp	short loc_b_24F4
		db	90h
loc_b_24EC:
		or	byte ptr ds:[2290h],1
loc_b_24F1:
		call	sub_b_1BFD
loc_b_24F4:
		mov	al,data_a_1080
		and	al,0FFh
		jnz	loc_b_2517		; Jump if not zero
		mov	al,data_a_0F1C
		or	al,al			; Zero ?
		jz	loc_b_2509		; Jump if zero
		inc	al
		js	loc_b_2509		; Jump if sign=1
		mov	data_a_0F1C,al
loc_b_2509:
		mov	al,data_a_0F2C
		or	al,al			; Zero ?
		jz	loc_b_2517		; Jump if zero
		inc	al
		js	loc_b_2517		; Jump if sign=1
		mov	data_a_0F2C,al
loc_b_2517:
		mov	al,data_a_1080
		and	al,0Fh
		jnz	loc_b_255C		; Jump if not zero
		mov	si,2
loc_b_2521:
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_2536		; Jump if zero
		js	loc_b_2536		; Jump if sign=1
		mov	al,data_a_0F1C[si]
		or	al,al			; Zero ?
		jz	loc_b_2536		; Jump if zero
		dec	data_a_0F1C[si]
loc_b_2536:
		inc	si
		inc	si
		cmp	si,10h
		jb	loc_b_2521		; Jump if below
		mov	si,12h
loc_b_2540:
		test	byte ptr data_a_0E3C[si],0FFh
		jz	loc_b_2555		; Jump if zero
		js	loc_b_2555		; Jump if sign=1
		mov	al,data_a_0F1C[si]
		or	al,al			; Zero ?
		jz	loc_b_2555		; Jump if zero
		dec	data_a_0F1C[si]
loc_b_2555:
		inc	si
		inc	si
		cmp	si,20h
		jb	loc_b_2540		; Jump if below
loc_b_255C:
		mov	al,data_a_0F7C
		or	al,al			; Zero ?
		js	loc_b_256B		; Jump if sign=1
		cmp	al,14h
		je	loc_b_256B		; Jump if equal
		dec	data_a_0F7C
loc_b_256B:
		mov	al,data_a_0F8C
		or	al,al			; Zero ?
		js	loc_b_257A		; Jump if sign=1
		cmp	al,14h
		je	loc_b_257A		; Jump if equal
		dec	data_a_0F8C
loc_b_257A:
		call	sub_b_27C0
		mov	al,data_a_0060
		or	al,al			; Zero ?
		jnz	loc_b_2587		; Jump if not zero
		jmp	loc_b_267F
loc_b_2587:
		mov	es,data_a_1060
		inc	data_a_0060
		cmp	al,20h			; ' '
		jne	loc_b_25A8		; Jump if not equal
		mov	si,0
		mov	cx,20h

locloop_b_2599:
		neg	data_a_065D[si]
		neg	data_a_0711[si]
		inc	si
		inc	si
		loop	locloop_b_2599		; Loop if cx > 0

		jmp	short loc_b_25AF
		db	90h
loc_b_25A8:
		cmp	al,40h			; '@'
		jne	loc_b_25AF		; Jump if not equal
		jmp	loc_b_2630
loc_b_25AF:
		mov	si,0
		mov	cx,20h

locloop_b_25B5:
		mov	bx,word ptr data_a_038D[si]
		mov	dx,data_a_0441[si]
		call	sub_b_1AFC
		mov	ax,data_a_065D[si]
		cwd				; Word to double word
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	ax,data_a_0DDC
		adc	dx,data_a_0D9C
		add	data_a_04F5[si],ax
		adc	dx,word ptr data_a_038D[si]
		jns	loc_b_25E2		; Jump if not sign
		add	dx,280h
		jmp	short loc_b_25EC
		db	90h
loc_b_25E2:
		cmp	dx,280h
		jb	loc_b_25EC		; Jump if below
		sub	dx,280h
loc_b_25EC:
		mov	word ptr data_a_038D[si],dx
		mov	bx,dx
		mov	ax,data_a_0711[si]
		cwd				; Word to double word
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	ax,data_a_0DFC
		adc	dx,data_a_0DBC
		add	data_a_05A9[si],ax
		adc	dx,data_a_0441[si]
		jns	loc_b_2618		; Jump if not sign
		add	dx,0C8h
		jmp	short loc_b_2622
		db	90h
loc_b_2618:
		cmp	dx,0C8h
		jb	loc_b_2622		; Jump if below
		sub	dx,0C8h
loc_b_2622:
		mov	data_a_0441[si],dx
		call	sub_b_1AFC
		inc	si
		inc	si
		loop	locloop_b_25B5		; Loop if cx > 0

		jmp	short loc_b_267F
			                        ;* No entry point to code
		nop
loc_b_2630:
		mov	si,0
		mov	cx,20h

locloop_b_2636:
		mov	bx,word ptr data_a_038D[si]
		mov	dx,data_a_0441[si]
		call	sub_b_1AFC
		inc	si
		inc	si
		loop	locloop_b_2636		; Loop if cx > 0

		mov	data_a_0060,0
		or	data_a_0E1C,1
		or	byte ptr data_a_0E3C,1
		mov	ax,word ptr data_a_038D
		mov	data_a_0D1C,ax
		mov	data_a_0D5C,ax
		mov	ax,data_a_0441
		mov	data_a_0D3C,ax
		mov	data_a_0D7C,ax
		xor	ax,ax			; Zero register
		mov	data_a_0D9C,ax
		mov	data_a_0DDC,ax
		mov	data_a_0DBC,ax
		mov	data_a_0DFC,ax
		mov	data_a_0CDC,ax
		mov	data_a_0CFC,ax
		and	byte ptr ds:[2290h],0EFh
loc_b_267F:
		mov	al,byte ptr data_a_0061
		or	al,al			; Zero ?
		jnz	loc_b_2689		; Jump if not zero
		jmp	loc_b_2781
loc_b_2689:
		mov	es,data_a_1060
		inc	byte ptr data_a_0061
		cmp	al,20h			; ' '
		jne	loc_b_26AA		; Jump if not equal
		mov	si,40h
		mov	cx,20h

locloop_b_269B:
		neg	data_a_065D[si]
		neg	data_a_0711[si]
		inc	si
		inc	si
		loop	locloop_b_269B		; Loop if cx > 0

		jmp	short loc_b_26B1
		db	90h
loc_b_26AA:
		cmp	al,40h			; '@'
		jne	loc_b_26B1		; Jump if not equal
		jmp	loc_b_2732
loc_b_26B1:
		mov	si,40h
		mov	cx,20h

locloop_b_26B7:
		mov	bx,word ptr data_a_038D[si]
		mov	dx,data_a_0441[si]
		call	sub_b_1AFC
		mov	ax,data_a_065D[si]
		cwd				; Word to double word
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	ax,data_a_0DEC
		adc	dx,data_a_0DAC
		add	data_a_04F5[si],ax
		adc	dx,word ptr data_a_038D[si]
		jns	loc_b_26E4		; Jump if not sign
		add	dx,280h
		jmp	short loc_b_26EE
		db	90h
loc_b_26E4:
		cmp	dx,280h
		jb	loc_b_26EE		; Jump if below
		sub	dx,280h
loc_b_26EE:
		mov	word ptr data_a_038D[si],dx
		mov	bx,dx
		mov	ax,data_a_0711[si]
		cwd				; Word to double word
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	ax,data_a_0E0C
		adc	dx,data_a_0DCC
		add	data_a_05A9[si],ax
		adc	dx,data_a_0441[si]
		jns	loc_b_271A		; Jump if not sign
		add	dx,0C8h
		jmp	short loc_b_2724
		db	90h
loc_b_271A:
		cmp	dx,0C8h
		jb	loc_b_2724		; Jump if below
		sub	dx,0C8h
loc_b_2724:
		mov	data_a_0441[si],dx
		call	sub_b_1AFC
		inc	si
		inc	si
		loop	locloop_b_26B7		; Loop if cx > 0

		jmp	short loc_b_2781
			                        ;* No entry point to code
		nop
loc_b_2732:
		mov	si,40h
		mov	cx,20h

locloop_b_2738:
		mov	bx,word ptr data_a_038D[si]
		mov	dx,data_a_0441[si]
		call	sub_b_1AFC
		inc	si
		inc	si
		loop	locloop_b_2738		; Loop if cx > 0

		mov	byte ptr data_a_0061,0
		or	data_a_0E2C,1
		or	byte ptr data_a_0E4C,1
		mov	ax,data_a_03CD
		mov	data_a_0D2C,ax
		mov	data_a_0D6C,ax
		mov	ax,data_a_0481
		mov	data_a_0D4C,ax
		mov	data_a_0D8C,ax
		xor	ax,ax			; Zero register
		mov	data_a_0DAC,ax
		mov	data_a_0DEC,ax
		mov	data_a_0DCC,ax
		mov	data_a_0E0C,ax
		mov	data_a_0CEC,ax
		mov	data_a_0D0C,ax
		and	byte ptr ds:[2290h],0EFh
loc_b_2781:
		mov	al,data_a_1080
		and	al,0Fh
		jnz	loc_b_279F		; Jump if not zero
		test	data_a_2040,1
		jz	loc_b_279F		; Jump if zero
		inc	data_a_2041
		mov	al,data_a_2041
		mov	bx,13Fh
		mov	dx,63h
		call	sub_b_1CE2
loc_b_279F:
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	es
		pop	ds
		pop	bp
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		iret				; Interrupt return
		db	0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_27B0	proc	near
		add	bl,40h			; '@'

;==== External Entry into Subroutine ======================================

sub_b_27B3:
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_a_2050[bx]
		retn
sub_b_27B0	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_27C0	proc	near
		test	data_a_2292,0FFh
		jz	loc_b_27D0		; Jump if zero
		test	byte ptr ds:[2290h],0FFh
		js	loc_ret_b_27F6		; Jump if sign=1
		jnz	loc_b_27D3		; Jump if not zero
loc_b_27D0:
		jmp	loc_b_28B4
loc_b_27D3:
		test	byte ptr ds:[2290h],10h
		jz	loc_b_27F7		; Jump if zero
		mov	ah,data_a_0060
		xor	al,al			; Zero register
		add	ah,byte ptr data_a_0061
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		pop	ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

loc_ret_b_27F6:
		retn
loc_b_27F7:
		test	byte ptr ds:[2290h],2
		jz	loc_b_2827		; Jump if zero
		mov	al,byte ptr ds:[2291h]
		or	al,al			; Zero ?
		js	loc_b_27D0		; Jump if sign=1
		add	al,8
		mov	byte ptr ds:[2291h],al
		neg	al
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		pop	ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
loc_b_2827:
		test	byte ptr ds:[2290h],4
		jz	loc_b_2859		; Jump if zero
		mov	al,byte ptr ds:[2291h]
		or	al,al			; Zero ?
		jnz	loc_b_284E		; Jump if not zero
		mov	byte ptr ds:[2291h],2
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,80h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
loc_b_284E:
		dec	al
		jz	loc_b_2856		; Jump if zero
		mov	byte ptr ds:[2291h],al
		retn
loc_b_2856:
		jmp	short loc_b_28B4
		db	90h
loc_b_2859:
		test	byte ptr ds:[2290h],1
		jz	loc_b_2889		; Jump if zero
		mov	al,data_a_1080
		mov	ah,al
		and	ah,1Fh
		jnz	loc_ret_b_28A6		; Jump if not zero
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	bx,400h
		pop	ax
		and	al,20h			; ' '
		jz	loc_b_2880		; Jump if zero
		mov	bx,800h
loc_b_2880:
		mov	al,bl
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,bh
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
loc_b_2889:
		test	byte ptr ds:[2290h],8
		jz	loc_ret_b_28A6		; Jump if zero
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		call	sub_b_28F2
		or	ax,2000h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

loc_ret_b_28A6:
		retn

;==== External Entry into Subroutine ======================================

sub_b_28A7:
		cli				; Disable interrupts
		mov	byte ptr ds:[2291h],0
		or	byte ptr ds:[2290h],2
		sti				; Enable interrupts
		retn

;==== External Entry into Subroutine ======================================

sub_b_28B4:
loc_b_28B4:
		mov	byte ptr ds:[2290h],0
		mov	byte ptr ds:[2291h],0
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		retn
sub_b_27C0	endp

		db	11 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_28D0	proc	near
loc_b_28D0:
		call	sub_b_28F2
		and	ax,3FFh
		cmp	ax,8
		jb	loc_b_28D0		; Jump if below
		cmp	ax,278h
		jae	loc_b_28D0		; Jump if above or =
		retn
sub_b_28D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_28E1	proc	near
loc_b_28E1:
		call	sub_b_28F2
		and	ax,1FFh
		cmp	ax,8
		jb	loc_b_28E1		; Jump if below
		cmp	ax,0C0h
		jae	loc_b_28E1		; Jump if above or =
		retn
sub_b_28E1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_28F2	proc	near
		push	di
		stc				; Set carry flag
		mov	al,data_a_2AA1
		adc	al,data_a_2AA4
		adc	al,data_a_2AA5
		mov	data_a_2AA0,al
		mov	di,offset 4
loc_b_2905:
		mov	al,data_a_2AA0[di]
		mov	data_a_2AA1[di],al
		dec	di
		jns	loc_b_2905		; Jump if not sign
		pop	di
		mov	ah,data_a_2AA2
		retn
sub_b_28F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2916	proc	near
		mov	ax,40h
		mov	es,ax
		mov	ax,es:d_0040_006C_e
		mov	data_a_2AA1,al
		mov	data_a_2AA2,ah
		mov	ax,es:d_0040_006E_e
		mov	data_a_2AA3,al
		mov	data_a_2AA4,ah
		retn
sub_b_2916	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2932	proc	near
		mov	cx,200h
		mov	es,data_a_1060

locloop_b_2939:
		call	sub_b_28D0
		mov	bx,ax
		call	sub_b_28E1
		mov	dx,ax
		call	sub_b_1AFC
		loop	locloop_b_2939		; Loop if cx > 0

		retn
sub_b_2932	endp

		db	7 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2950	proc	near
		cli				; Disable interrupts
		inc	byte ptr data_a_0E3C[si]
		mov	bl,data_a_0E5C
		call	sub_b_2ACE
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	dx,data_a_0D1C
		jns	loc_b_2972		; Jump if not sign
		add	dx,280h
loc_b_2972:
		cmp	dx,8
		jae	loc_b_297B		; Jump if above or =
		add	dx,270h
loc_b_297B:
		cmp	dx,278h
		jb	loc_b_2985		; Jump if below
		sub	dx,270h
loc_b_2985:
		mov	data_a_0D1C[si],dx
		mov	data_a_0D5C[si],dx
		mov	bl,data_a_0E5C
		call	sub_b_2AD4
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	dx,data_a_0D3C
		jns	loc_b_29AA		; Jump if not sign
		add	dx,0C8h
loc_b_29AA:
		cmp	dx,8
		jae	loc_b_29B3		; Jump if above or =
		add	dx,0B8h
loc_b_29B3:
		cmp	dx,0C0h
		jb	loc_b_29BD		; Jump if below
		sub	dx,0B8h
loc_b_29BD:
		mov	data_a_0D3C[si],dx
		mov	data_a_0D7C[si],dx
		mov	bl,data_a_0E5C
		mov	data_a_0E5C[si],bl
		mov	data_a_0E7C[si],bl
		call	sub_b_2ACE
		add	ax,data_a_0DDC
		mov	data_a_0DDC[si],ax
		adc	dx,data_a_0D9C
		mov	data_a_0D9C[si],dx
		mov	bl,data_a_0E5C
		call	sub_b_2AD4
		add	ax,data_a_0DFC
		mov	data_a_0DFC[si],ax
		adc	dx,data_a_0DBC
		mov	data_a_0DBC[si],dx
		mov	data_a_0F1C[si],28h	; '('
		sti				; Enable interrupts
		sub	data_a_0F1C,1
		call	sub_b_1BC1
		or	byte ptr ds:[2290h],4
		retn
sub_b_2950	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2A0F	proc	near
		cli				; Disable interrupts
		assume	ds:seg_b
		inc	data_b_0E3C[si]
		mov	bl,data_b_0E6C
		call	sub_b_2ACE
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	dx,data_b_0D2C
		jns	loc_b_2A31		; Jump if not sign
		add	dx,280h
loc_b_2A31:
		cmp	dx,8
		jae	loc_b_2A3A		; Jump if above or =
		add	dx,270h
loc_b_2A3A:
		cmp	dx,278h
		jb	loc_b_2A44		; Jump if below
		sub	dx,270h
loc_b_2A44:
		mov	data_b_0D1C[si],dx
		mov	data_b_0D5C[si],dx
		mov	bl,data_b_0E6C
		call	sub_b_2AD4
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		add	dx,data_b_0D4C
		jns	loc_b_2A69		; Jump if not sign
		add	dx,0C8h
loc_b_2A69:
		cmp	dx,8
		jae	loc_b_2A72		; Jump if above or =
		add	dx,0B8h
loc_b_2A72:
		cmp	dx,0C0h
		jb	loc_b_2A7C		; Jump if below
		sub	dx,0B8h
loc_b_2A7C:
		mov	data_b_0D3C[si],dx
		mov	data_b_0D7C[si],dx
		mov	bl,data_b_0E6C
		mov	data_b_0E5C[si],bl
		mov	data_b_0E7C[si],bl
		call	sub_b_2ACE
		add	ax,data_b_0DEC
		mov	data_b_0DDC[si],ax
		adc	dx,data_b_0DAC
		mov	data_b_0D9C[si],dx
		mov	bl,data_b_0E6C
		call	sub_b_2AD4
		add	ax,data_b_0E0C
		mov	data_b_0DFC[si],ax
		adc	dx,data_b_0DCC
		mov	data_b_0DBC[si],dx
		mov	byte ptr ds:[0F1Ch][si],28h	; '('
		sti				; Enable interrupts
		sub	byte ptr data_b_0F25+7,1	; ('M E    I N S T R U C T I')
		call	sub_b_1BC1
		or	byte ptr ds:[2290h],4
		retn
sub_b_2A0F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2ACE	proc	near
		call	sub_b_27B0
		jmp	short loc_b_2AD7
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_2AD4:
		call	sub_b_27B3
loc_b_2AD7:
		cwd				; Word to double word
		push	cx
		mov	cx,2

locloop_b_2ADC:
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		loop	locloop_b_2ADC		; Loop if cx > 0

		pop	cx
		retn
sub_b_2ACE	endp


seg_b		ends


;------------------------------------------------------  stack_seg_d   ----

;stack_seg_d	segment	word stack 'stack'

;		db	1024 dup (?)

;stack_seg_d	ends

		end	start
