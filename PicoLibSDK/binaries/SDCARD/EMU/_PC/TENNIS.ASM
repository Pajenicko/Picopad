
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
;==				TENNIS	                                 ==
;==					                                 ==
;==      Created:   6-May-85		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

jmpn            macro   location
                db      0E9h
                dw      offset location-$-2
endm

.186


; The following equates show data references outside the range of the program.

d_0000_0024_e	equ	24h
d_0000_1DB4_e	equ	1DB4h			;*
data_c_6424_e	equ	6424h			;*
d_B800_004E_e	equ	4Eh
d_B800_1E00_e	equ	1E00h
d_B800_1E02_e	equ	1E02h
d_B800_1E04_e	equ	1E04h
d_B800_2000_e	equ	2000h
d_B800_2002_e	equ	2002h
d_B800_204E_e	equ	204Eh
d_B800_3E00_e	equ	3E00h
d_B800_3E02_e	equ	3E02h
d_B800_3E04_e	equ	3E04h
d_B800_B800_e	equ	0B800h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	byte public
		assume cs:seg_a  , ds:seg_a , ss:stack_seg_c

data_a_0000	db	0			; Data table (indexed access)
data_a_0001	db	0			; Data table (indexed access)
data_a_0002	db	0			; Data table (indexed access)
data_a_0003	db	0
data_a_0004	db	0			; Data table (indexed access)
data_a_0005	db	0
data_a_0006	db	0
data_a_0007	db	0
data_a_0008	db	0
data_a_0009	db	0
data_a_000A	db	0
data_a_000B	db	0
data_a_000C	db	0			; Data table (indexed access)
data_a_000D	db	0
data_a_000E	db	0			; Data table (indexed access)
data_a_000F	db	0
data_a_0010	db	0			; Data table (indexed access)
data_a_0011	db	0
data_a_0012	db	0			; Data table (indexed access)
data_a_0013	db	0			; Data table (indexed access)
data_a_0014	dw	0			; Data table (indexed access)
		db	0, 0
data_a_0018	dw	0			; Data table (indexed access)
		db	0, 0
data_a_001C	dw	0			; Data table (indexed access)
		db	0, 0
data_a_0020	dw	0			; Data table (indexed access)
		db	0, 0
data_a_0024	db	0			; Data table (indexed access)
		db	0
data_a_0026	dw	0			; Data table (indexed access)
data_a_0028	dw	0			; Data table (indexed access)
data_a_002A	db	0
data_a_002B	db	0
data_a_002C	dw	0			; Data table (indexed access)
data_a_002E	db	0
data_a_002F	dw	0
data_a_0031	dw	0
data_a_0033	dw	0
data_a_0035	dw	0
data_a_0037	dw	0
data_a_0039	dw	0
data_a_003B	dw	0
data_a_003D	dw	0
data_a_003F	dw	0
data_a_0041	dw	0
data_a_0043	dw	0
data_a_0045	dw	0
data_a_0047	dw	0
data_a_0049	dw	0
data_a_004B	dw	0
data_a_004D	dw	0
data_a_004F	dw	0
data_a_0051	dw	0
data_a_0053	dw	0
data_a_0055	dw	0
		db	0
data_a_0058	db	0
data_a_0059	db	0
		db	45 dup (0)
data_a_0087	db	0
		db	 00h, 00h, 00h,0E2h, 1Ch, 0Eh
		db	 00h, 0Fh, 00h,0DBh, 00h, 00h
		db	 0Ah, 00h, 02h, 00h, 16h, 00h
		db	 11h, 00h
data_a_009C	db	0
		db	 00h, 00h, 00h, 2Ah, 20h, 0Eh
		db	 00h, 0Dh, 00h, 39h, 02h, 00h
		db	 0Ah, 00h, 00h, 00h, 16h, 00h
		db	 0Fh, 00h
data_a_00B1	db	0
		db	 00h, 00h, 00h, 92h, 24h, 0Eh
		db	 00h, 0Fh, 00h,0EFh, 02h, 00h
		db	 0Ah, 00h, 02h, 00h, 1Ah, 00h
		db	 11h, 00h
data_a_00C6	db	0
		db	 00h, 00h, 00h, 90h, 28h, 0Eh
		db	 00h, 0Dh, 00h, 4Dh, 04h, 00h
		db	 0Ah, 00h, 00h, 00h, 1Ah, 00h
		db	 11h, 00h,0FFh
		db	1063 dup (0FFh)
		db	0E2h, 1Ch, 2Ah, 20h, 58h, 1Fh
		db	 4Ch, 22h, 92h, 24h, 90h, 28h
		db	 08h, 27h,0B2h, 2Ah, 40h, 35h
		db	 12h, 36h,0E4h, 36h, 12h, 36h
		db	 40h, 35h,0B6h, 37h, 88h, 38h
		db	 5Ah, 39h, 2Ch, 3Ah,0E2h, 3Ah
		db	 98h, 3Bh, 4Eh, 3Ch, 04h, 3Dh
		db	0BAh
		db	'=p>&?B,p+p+p+B,'
		db	 14h, 2Dh,0E6h, 2Dh,0B8h, 2Eh
		db	 8Ah, 2Fh, 40h, 30h,0F6h, 30h
		db	0ACh, 31h, 62h, 32h, 18h, 33h
		db	0CEh, 33h, 84h, 34h, 84h, 41h
		db	 84h, 41h, 84h, 41h, 84h, 41h
		db	 84h, 41h, 84h, 41h, 56h, 42h
		db	 56h, 42h,0E0h, 3Fh,0E0h, 3Fh
		db	0E0h, 3Fh,0E0h, 3Fh,0E0h, 3Fh
		db	0E0h
		db	3Fh
loc_a_056F:
		mov	dl,40h			; '@'
		mov	dl,40h			; '@'
		adc	[si],bl
		adc	[si],bl
		loop	locloop_a_0595		; Loop if cx > 0

		mov	ah,1Dh
		xchg	data_a_2302,bl
		add	ah,[bp+di]
		sub	ah,[bx+si]
		loopnz	$+22h			; Loop if zf=0, cx>0

		xchg	si,ax
		and	[bx+si+1Fh],bx
		pop	ax
		pop	ds
		xchg	ds:d_0000_1DB4_e,bl
		loop	locloop_a_05AD		; Loop if cx > 0

		dec	sp
		and	cl,[si+22h]

locloop_a_0595:
		xchg	si,ax
;*		and	ax,sp
		db	 21h,0E0h		;  Fixup - byte match
		and	[bp+si],ch
;*		and	al,al
		db	 20h,0C0h		;  Fixup - byte match
		and	ax,ax
		and	dx,ss:data_c_6424_e[bp+si]
		and	ax,2636h
		db	0DAh, 27h,0DAh

locloop_a_05A8:
		daa				; Decimal adjust
		nop

locloop_a_05AA:
		sub	[bp+29h],al

locloop_a_05AD:
		cld				; Clear direction

locloop_a_05AE:
		sub	[bx+si],cx
		daa				; Decimal adjust
		or	[bx],ah
		db	 36h, 26h, 64h, 25h, 92h, 24h
		db	0B2h, 2Ah,0B2h, 2Ah,0FCh, 29h
		db	 46h, 29h, 90h, 28h, 30h, 43h
		db	 02h, 44h,0D4h, 44h,0A6h, 45h
		db	0BEh, 46h, 1Ch, 48h,0EEh, 48h
		db	0A4h, 49h, 5Ah, 4Ah, 10h, 4Bh
		db	0C6h, 4Bh, 7Ch, 4Ch, 40h, 4Dh
		db	 12h, 4Eh,0E4h, 4Eh,0B6h, 4Fh
		db	0CEh, 50h, 2Ch, 52h,0FEh, 52h
		db	0B4h, 53h, 6Ah, 54h, 20h, 55h
		db	0D6h, 55h, 8Ch
		db	56h
data_a_05F3	db	10h
		db	 1Ch,0D2h, 00h,0E2h, 1Ch,0D2h
		db	 00h,0B4h, 1Dh,0D2h, 00h, 86h
		db	 1Eh,0D2h, 00h, 58h, 1Fh,0D2h
		db	 00h, 02h, 23h,0B6h, 00h, 2Ah
		db	 20h,0B6h, 00h,0E0h, 20h,0B6h
		db	 00h, 96h, 21h,0B6h, 00h, 4Ch
		db	 22h,0B6h, 00h,0C0h, 23h,0D2h
		db	 00h, 92h, 24h,0D2h, 00h, 64h
		db	 25h,0D2h, 00h, 36h, 26h,0D2h
		db	 00h, 08h, 27h,0D2h, 00h,0DAh
		db	 27h,0B6h, 00h, 90h, 28h,0B6h
		db	 00h, 46h, 29h,0B6h, 00h,0FCh
		db	 29h,0B6h, 00h,0B2h, 2Ah,0B6h
		db	 00h, 70h, 2Bh,0D2h, 00h, 42h
		db	 2Ch,0D2h, 00h, 14h, 2Dh,0D2h
		db	 00h,0E6h, 2Dh,0D2h, 00h,0B8h
		db	 2Eh,0D2h, 00h, 8Ah, 2Fh,0B6h
		db	 00h, 40h, 30h,0B6h, 00h,0F6h
		db	 30h,0B6h, 00h,0ACh, 31h,0B6h
		db	 00h, 62h, 32h,0B6h, 00h, 18h
		db	 33h,0B6h, 00h,0CEh, 33h,0B6h
		db	 00h, 84h, 34h,0B6h, 00h, 40h
		db	 35h,0D2h, 00h, 12h, 36h,0D2h
		db	 00h,0E4h, 36h,0D2h, 00h,0B6h
		db	 37h,0D2h, 00h, 88h, 38h,0D2h
		db	 00h, 5Ah, 39h,0D2h, 00h, 2Ch
		db	 3Ah,0B6h, 00h,0E2h, 3Ah,0B6h
		db	 00h, 98h, 3Bh,0B6h, 00h, 4Eh
		db	 3Ch,0B6h, 00h, 04h, 3Dh,0B6h
		db	 00h,0BAh, 3Dh,0B6h, 00h, 70h
		db	 3Eh,0B6h, 00h, 26h, 3Fh,0B6h
		db	 00h,0E0h, 3Fh,0D2h, 00h, 84h
		db	 41h,0D2h, 00h,0B2h, 40h,0D2h
		db	 00h, 56h, 42h,0D2h, 00h, 30h
		db	 43h,0D2h, 00h, 02h, 44h,0D2h
		db	 00h,0D4h, 44h,0D2h, 00h,0A6h
		db	 45h, 18h, 01h,0BEh, 46h, 5Eh
		db	 01h, 1Ch, 48h,0D2h, 00h,0EEh
		db	 48h,0B6h, 00h,0A4h, 49h,0B6h
		db	 00h, 5Ah, 4Ah,0B6h, 00h, 10h
		db	 4Bh,0B6h, 00h,0C6h, 4Bh,0B6h
		db	 00h, 7Ch, 4Ch,0B6h, 00h, 40h
		db	 4Dh,0D2h, 00h, 12h, 4Eh,0D2h
		db	 00h,0E4h, 4Eh,0D2h, 00h,0B6h
		db	 4Fh, 18h, 01h,0CEh, 50h, 5Eh
		db	 01h, 2Ch, 52h,0D2h, 00h,0FEh
		db	 52h,0B6h, 00h,0B4h, 53h,0B6h
		db	 00h, 6Ah, 54h,0B6h, 00h, 20h
		db	 55h,0B6h, 00h,0D6h, 55h,0B6h
		db	 00h, 8Ch, 56h,0B6h, 00h, 50h
		db	 57h, 26h, 01h, 76h, 58h, 26h
		db	 01h, 9Ch, 59h, 26h, 01h,0C2h
		db	 5Ah, 26h, 01h,0E8h, 5Bh, 26h
		db	 01h, 0Eh, 5Dh, 26h, 01h, 34h
		db	 5Eh, 26h, 01h, 5Ah, 5Fh, 26h
		db	 01h, 80h, 60h, 26h, 01h,0A6h
		db	 61h, 26h, 01h, 00h
		db	0, 0, 0
data_a_074B	db	0
		db	0, 0, 0, 1
data_a_0750	db	0
		db	 00h, 64h, 00h, 01h
data_a_0755	db	0
		db	0, 0, 0, 1
data_a_075A	db	0
		db	 00h, 64h, 00h, 01h
data_a_075F	dw	10 dup (0)
		db	0
data_a_0774	dw	7 dup (0FFFFh)
data_a_0782	dw	7 dup (7777h)
data_a_0790	db	0B1h
		db	 00h,0C6h, 00h, 87h, 00h, 9Ch
		db	 00h
		db	44h
		db	'HERSKI#GfNPE8DO AB@YL XDMLG %RTE'
		db	'WSEESAsRGCUH\ D-*-R CPARPOHGFRIA'
		db	'RM; TBIYM AJIONEULT "S7A8N9A1 D&'
		db	'` AGRILLELIEASQ ATIAMLOAUDvOBIPR'
		db	'DES S1A9N8A5I IF ROAKNRCIE?', 0
data_a_0835	db	0B4h
		db	 00h, 4Ah, 00h, 64h, 00h, 8Ah
		db	 00h,0FAh,0FFh,0F8h,0FFh,0F9h
		db	0FFh, 17h, 00h, 10h, 00h, 28h
		db	 00h, 1Ch, 01h,0F8h, 00h, 76h
		db	 00h, 32h, 00h,0B0h, 00h, 70h
		db	 00h,0A2h, 00h, 32h, 00h,0B0h
		db	 00h, 5Dh, 00h, 8Ch, 00h, 8Eh
		db	 00h, 5Ah, 00h, 70h, 00h,0BEh
		db	 00h,0ACh, 00h, 95h, 00h, 53h
		db	 00h, 8Ch, 00h, 8Eh, 00h, 9Eh
		db	 00h, 2Ch, 00h,0CCh, 00h,0D4h
		db	 00h, 74h, 00h, 6Ch, 00h, 47h
		db	 00h, 8Fh, 00h, 87h, 00h,0B1h
		db	 00h, 9Ch, 00h,0C6h, 00h, 12h
		db	 00h, 1Ch, 00h
data_a_088D	db	0DCh
		db	 00h, 9Eh, 00h, 60h, 00h, 2Ch
		db	 00h, 54h, 00h, 9Eh, 00h,0D0h
		db	 00h, 2Ch, 00h
data_a_089D	db	0A8h
		db	 00h, 9Eh, 00h, 78h, 00h, 2Ch
		db	 00h, 78h, 00h, 9Eh, 00h,0A8h
		db	 00h, 2Ch, 00h,0BCh, 00h,0ABh
		db	 00h, 7Eh, 00h, 38h, 00h, 8Ch
		db	 00h,0ABh, 00h,0AEh, 00h, 38h
		db	 00h,0BCh, 00h,0B7h, 00h, 7Eh
		db	 00h, 46h, 00h, 8Ch, 00h,0B7h
		db	 00h,0AEh, 00h, 46h, 00h,0C2h
		db	 00h, 7Ah, 00h, 92h, 00h,0AAh
		db	 00h, 6Eh, 00h,0C0h, 00h,0C0h
		db	 00h, 6Eh, 00h, 02h, 04h, 06h
		db	 08h, 09h, 0Ah, 0Bh, 0Bh, 0Ch
		db	 0Ch, 0Ch, 0Bh, 0Bh, 0Ah, 09h
		db	 08h, 06h, 04h, 02h, 00h, 1Bh
		db	 1Dh, 1Fh
		db	21h
		db	'"$'
		db	'%', 27h, '()+,--.//00011111000//'
		db	'.--,+)(', 27h, '%$'
		db	'"!'
		db	1Fh
		db	' GAME  OVER '
		db	0
		db	'SECOND SERVE'
		db	11 dup (0)
data_a_0940	db	30h
data_a_0941	db	31h
data_a_0942	db	1Fh
data_a_0943	db	2Dh
data_a_0944	db	39h
data_a_0945	db	41h
data_a_0946	db	42h
data_a_0947	db	3Dh
data_a_0948	db	3Fh
data_a_0949	db	43h
data_a_094A	db	0
data_a_094B	dw	0
data_a_094D	dw	0
data_a_094F	db	0
data_a_0950	db	0
data_a_0951	db	0
data_a_0952	db	0
data_a_0953	db	0
data_a_0954	db	0
data_a_0955	db	0
data_a_0956	db	0
data_a_0957	db	0
data_a_0958	db	0
data_a_0959	db	0
data_a_095A	db	0
		db	27 dup (0)
data_a_0976	db	0
		db	0, 0
data_a_0979	db	0
		db	21 dup (0)
data_a_098F	db	0
		db	19 dup (0)
data_a_09A3	db	0
		db	0, 0, 0
data_a_09A7	db	0
		db	0, 0, 0, 0, 0
data_a_09AD	db	0
data_a_09AE	db	0
		db	0FFh, 01h, 01h, 03h, 02h
data_a_09B4	db	'DO YOU WANT TO USE :', 0
		db	6, 4
data_a_09CB	db	'1. JOYSTICKS', 0
		db	6, 5
data_a_09DA	db	'2. KEYBOARD', 0
		db	1
data_a_09E7	db	8, 'CONTROL KEYS CURRENTLY DEFINE'
		db	'D AS :', 0
		db	 04h, 0Ah
data_a_0A0E	db	'PLAYER ONE'
		db	10 dup (20h)
		db	'PLAYER TWO'
		db	0, 4
data_a_0A2E	db	0Ch, '0. LEFT  = B        5. LEFT'
		db	'  = F7', 0
		db	 04h, 0Dh
data_a_0A53	db	'1. RIGHT = N        6. RIGHT = F'
		db	'8', 0
		db	 04h, 0Eh
data_a_0A77	db	'2. UP    = S        7. UP    = F'
		db	'3', 0
		db	 04h, 0Fh
data_a_0A9B	db	'3. DOWN  = X        8. DOWN  = F'
		db	'5', 0
		db	 04h, 10h
data_a_0ABF	db	'4. FIRE  = sp       9. FIRE  = F'
		db	'9'
		db	 00h, 00h, 13h
data_a_0AE3	db	'TO CHANGE A KEY DEFINITION :', 0
		db	 00h, 14h
data_a_0B02	db	54h
		db	'YPE SELECTION NUMBER AND STRIKE '
		db	'NEW KEY', 0
		db	 09h, 17h
data_a_0B2D	db	'PRESS ESC KEY TO START', 0
data_a_0B44	db	20h
		db	 20h, 00h
		db	9 dup (0)
data_a_0B50	dw	0
data_a_0B52	dw	0
data_a_0B54	dw	0
data_a_0B56	dw	0
data_a_0B58	dw	0
data_a_0B5A	dw	0
data_a_0B5C	dw	0
data_a_0B5E	db	0
		db	 01h, 02h, 03h, 04h, 04h, 05h
		db	 06h, 07h, 07h, 08h, 08h, 09h
		db	 09h, 0Ah, 0Ah, 0Ah, 0Bh, 0Bh
		db	 0Bh, 0Bh
		db	0Ch
		db	8 dup (0Ch)
		db	 0Bh, 0Bh, 0Bh, 0Bh, 0Ah, 0Ah
		db	 0Ah, 09h, 09h, 08h, 08h, 07h
		db	 07h, 06h, 05h, 04h, 04h, 03h
		db	 02h, 01h, 00h, 4Fh, 55h, 54h
		db	 00h
data_a_0B95	db	0
		db	 00h, 00h, 00h, 0Eh, 5Dh, 0Eh
		db	 00h, 15h, 00h,0AAh, 0Bh, 00h
		db	 04h, 00h, 00h, 00h, 10h, 00h
		db	 15h, 00h,0FFh
		db	335 dup (0FFh)
data_a_0CFA	dw	0
data_a_0CFC	dw	5D0Eh			; Data table (indexed access)
data_a_0CFE	db	34h
		db	 5Eh, 5Ah, 5Fh, 80h, 60h,0A6h
		db	 61h
data_a_0D06	dw	5750h			; Data table (indexed access)
data_a_0D08	db	76h
		db	 58h, 9Ch, 59h,0C2h, 5Ah,0E8h
		db	 5Bh
data_a_0D10	db	0, 0
data_a_0D12	dw	0
data_a_0D14	db	0
data_a_0D15	db	0
data_a_0D16	db	0
data_a_0D17	dw	0D4Bh			; Data table (indexed access)
		db	0C3h, 0Dh
data_a_0D1B	dw	0E3Bh			; Data table (indexed access)
		db	 5Bh, 0Eh
data_a_0D1F	dw	0E7Bh			; Data table (indexed access)
		db	 8Bh, 0Eh
data_a_0D23	db	0Bh
		db	 0Ch, 0Ch,0FCh,0FEh
data_a_0D28	db	1Eh
		db	 1Eh, 19h, 0Dh, 12h
data_a_0D2D	db	0Bh
		db	 03h,0FFh, 02h, 0Ah
data_a_0D32	db	17h
		db	 11h, 0Eh, 10h, 16h,0FEh,0FEh
		db	 02h, 0Eh, 0Ah, 10h, 10h, 10h
		db	 1Eh, 1Dh, 0Ah, 02h,0FFh, 02h
		db	 0Ah, 17h, 0Fh, 0Eh, 10h, 16h
		db	'#44D34DD'
		db	16h
		db	'7HH77HHgxx'
		db	 88h, 78h, 78h, 78h
loc_a_0D62:
		mov	[bp+si],dl
		and	sp,[bp+di]
		inc	bx
		and	sp,[bp+di]
		xor	al,[bp+di+51h]
		db	 26h, 37h, 84h, 26h, 26h, 37h
		db	 48h, 55h, 67h, 67h, 87h, 67h
		db	 67h, 78h, 87h, 11h, 11h, 12h
		db	 32h, 11h, 11h, 12h, 12h
		db	'QQ%cQQ%%UUVgUUVV#4DD$'
		db	'44D', 27h, '78H&7HHxx'
		db	 88h, 88h, 67h, 87h, 88h, 88h
		db	 11h, 12h, 23h, 34h, 11h, 12h
		db	 23h, 34h, 16h, 26h, 37h, 48h
		db	 15h, 25h, 36h, 47h, 56h, 67h
		db	 87h, 88h, 55h, 56h, 67h, 78h
		db	 11h, 21h, 21h, 23h, 11h, 11h
		db	 21h, 22h, 15h, 15h, 26h, 47h
		db	 15h, 15h
		db	'&&UeegUeee'
		db	 12h, 32h, 32h, 34h, 12h, 12h
		db	 32h, 32h, 51h, 26h, 37h, 48h
		db	 15h, 15h, 37h, 37h, 56h, 76h
		db	 76h, 88h
		db	'Vevv#CCDCCCCb7'
		db	 84h, 48h, 37h, 37h, 84h, 84h
		db	 76h, 87h, 87h, 88h, 77h, 77h
		db	 87h, 87h, 11h, 21h, 32h, 12h
		db	 11h, 11h, 21h, 31h, 15h, 25h
		db	 26h, 36h, 15h, 15h
		db	'&GUUeVUevw!2CD!!CD'
		db	 15h, 26h, 37h, 47h, 16h, 16h
		db	'8HUVvxee'
		db	 87h, 88h, 4Ah, 00h, 74h, 00h
		db	0A0h, 00h,0CCh, 00h, 50h, 00h
		db	 78h, 00h,0A0h, 00h,0C8h, 00h
		db	 60h, 00h, 60h, 00h, 60h, 00h
		db	 60h, 00h, 4Ah, 00h, 4Ah, 00h
		db	 4Ah, 00h, 4Ah, 00h, 40h, 00h
		db	 70h, 00h,0A0h, 00h,0D0h, 00h
		db	 3Ah, 00h, 6Ch, 00h,0A0h, 00h
		db	0D4h, 00h, 86h, 00h, 86h, 00h
		db	 86h, 00h, 86h, 00h, 9Ch, 00h
		db	 9Ch, 00h, 9Ch, 00h, 9Ch, 00h
		db	0F6h, 14h, 14h, 32h,0F6h, 00h
		db	 00h, 00h, 06h,0E0h,0E0h, 00h
		db	 0Ah,0F8h,0F6h,0FAh,0F4h, 14h
		db	 28h, 38h,0F4h, 00h, 00h, 38h
		db	 08h, 3Ah, 3Ch, 05h, 10h, 26h
		db	 20h, 04h
		db	17 dup (0)
data_a_0EAC	db	0			; Data table (indexed access)
		db	 03h, 00h, 00h, 0Ch, 0Fh, 0Ch
		db	 0Ch, 00h, 03h, 00h, 00h, 00h
		db	 03h, 00h, 00h
		db	'0300<?<<03000300'
		db	 00h, 03h, 00h, 00h, 0Ch, 0Fh
		db	 0Ch, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 03h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 0Ch, 0Fh, 0Ch, 0Ch
		db	 00h, 03h, 00h, 00h, 00h, 03h
		db	 00h, 00h,0C0h,0C3h,0C0h,0C0h
		db	0CCh,0CFh,0CCh,0CCh,0C0h,0C3h
		db	0C0h,0C0h,0C0h,0C3h,0C0h,0C0h
		db	0F0h,0F3h,0F0h,0F0h,0FCh,0FFh
		db	0FCh,0FCh,0F0h,0F3h,0F0h,0F0h
		db	0F0h,0F3h,0F0h,0F0h,0C0h,0C3h
		db	0C0h,0C0h,0CCh,0CFh,0CCh,0CCh
		db	0C0h,0C3h,0C0h,0C0h,0C0h,0C3h
		db	0C0h,0C0h,0C0h,0C3h,0C0h,0C0h
		db	0CCh,0CFh,0CCh,0CCh,0C0h,0C3h
		db	0C0h,0C0h,0C0h,0C3h,0C0h,0C0h
		db	 00h, 03h, 00h, 00h, 0Ch, 0Fh
		db	 0Ch, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 03h, 00h, 00h
		db	'0300<?<<03000300'
		db	 00h, 03h, 00h, 00h, 0Ch, 0Fh
		db	 0Ch, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 03h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 0Ch, 0Fh, 0Ch, 0Ch
		db	 00h, 03h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 00h, 03h, 00h, 00h
		db	 0Ch, 0Fh, 0Ch, 0Ch, 00h, 03h
		db	 00h, 00h, 00h, 03h, 00h, 00h
		db	'0300<?<<03000300'
		db	 00h, 03h, 00h, 00h, 0Ch, 0Fh
		db	 0Ch, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 03h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 0Ch, 0Fh, 0Ch, 0Ch
		db	 00h, 03h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 00h, 00h, 00h, 00h
data_a_0FB0	db	0Fh
		db	0F1h,0EAh,0ECh,0F8h,0F8h,0FDh
		db	0FCh, 20h, 1Fh, 0Dh,0FEh, 1Eh
		db	 12h
data_a_0FBE	db	0FFh
		db	 0Ch, 10h, 1Dh, 16h, 52h, 26h
		db	 27h, 16h, 25h, 26h, 37h, 26h
		db	 16h, 52h, 67h, 27h, 13h, 67h
		db	 27h, 37h, 56h, 15h, 56h, 37h
		db	 53h, 56h, 15h
		db	'%', 27h, '#c#', 27h, 'g7g'
		db	17h
		db	'gRc7cgxh'
		db	 16h, 15h, 18h, 35h, 58h, 56h
		db	 25h, 52h, 63h, 37h, 16h, 52h
		db	 63h, 37h, 27h, 17h, 52h, 36h
		db	 63h, 53h, 26h, 63h, 87h, 58h
		db	 51h, 56h, 84h
		db	'XQQ', 27h, '6#8&', 27h, 'g6c'
		db	13h
		db	'g', 27h, 27h, 'gc', 27h, 'GhaRt'
		db	 87h, 56h, 16h
data_a_1022	db	6
		db	 34h, 34h
data_a_1025	db	46h
		db	 00h, 73h, 00h, 40h, 00h, 8Eh
		db	 00h, 76h, 00h, 73h, 00h, 76h
		db	 00h, 8Eh, 00h,0AAh, 00h, 73h
		db	 00h,0AAh, 00h, 8Eh, 00h,0DAh
		db	 00h, 73h, 00h,0E0h, 00h, 8Eh
		db	 00h, 4Ah, 00h, 55h, 00h, 52h
		db	 00h, 3Ah, 00h, 7Ah, 00h, 55h
		db	 00h, 7Ah, 00h, 3Ah, 00h,0A6h
		db	 00h, 55h, 00h,0A6h, 00h, 3Ah
		db	 00h,0D6h, 00h, 55h, 00h,0CEh
		db	 00h, 3Ah, 00h
data_a_1065	db	4Ch
		db	 7Fh, 66h,0B2h,0B2h, 80h, 00h
		db	 00h
		db	0, 0, 0
data_a_1070	db	0
data_a_1071	db	0
data_a_1072	db	0
data_a_1073	db	0
data_a_1074	db	0
data_a_1075	db	70h
		db	 2Bh, 42h, 2Ch, 14h, 2Dh,0E6h
		db	 2Dh,0B8h, 2Eh,0E0h, 3Fh,0B2h
		db	 40h, 10h, 1Ch,0E2h, 1Ch,0B4h
		db	 1Dh, 86h, 1Eh, 58h, 1Fh, 30h
		db	 43h, 02h, 44h,0D4h, 44h,0ECh
		db	 45h, 4Ah, 47h, 1Ch
		db	48h
data_a_1099	db	40h
		db	 35h, 12h, 36h,0E4h, 36h,0B6h
		db	 37h, 88h, 38h, 5Ah, 39h, 84h
		db	 41h, 56h, 42h,0C0h, 23h, 92h
		db	'$'
		db	'd%6&', 8, 27h, '@M'
		db	 12h, 4Eh,0E4h, 4Eh,0FCh
		db	 4Fh, 5Ah, 51h, 2Ch, 52h
data_a_10BF	db	18h
		db	 01h,0F6h, 00h, 67h, 00h, 61h
		db	 00h
data_a_10C7	db	0
data_a_10C8	db	0
data_a_10C9	db	0
		db	 53h, 45h
		db	'T POINT', 0
		db	'MATCH POINT', 0
		db	'SET  ', 0
		db	'GAME ', 0
		db	'  ', 0
		db	'00', 0
		db	'15', 0
		db	'30', 0
		db	'40', 0
		db	'AD'
		db	0, 0, 0
data_a_1100	dw	200h
data_a_1102	dw	0A00h
data_a_1104	dw	5
data_a_1106	dw	800h
data_a_1108	dw	300h
data_a_110A	dw	4
data_a_110C	dw	1A0h
data_a_110E	dw	1A0h
data_a_1110	dw	60h
		db	14 dup (0)
data_a_1120	dw	0
data_a_1122	db	0
		db	0
data_a_1124	db	0
		db	9 dup (0)
		db	'-O', 0
		db	'        ', 0
		db	'TENNIS', 0
		db	'OPTION SELECTION', 0
		db	'one', 0
		db	'two', 0
		db	'player', 0
		db	'players', 0
		db	'demo', 0
		db	'novice', 0
		db	'amateur', 0
		db	'pro', 0
		db	'PLAYER 1 : .........', 0
		db	'PLAYER 2 : .........', 0
data_a_11AB	db	'PLAYER1', 0
data_a_11B3	db	'PLAYER2', 0
data_a_11BB	db	'COMPUTER', 0
		db	'PRESS FIRE BUTTON TO START'
		db	0, 0
		db	9 dup (20h)
		db	0
data_a_11EA	db	24h
		db	 00h, 12h, 01h, 14h, 00h, 04h
		db	 42h, 04h, 04h, 06h,0FFh, 06h
		db	 06h, 06h, 06h, 25h, 00h, 10h
		db	 01h, 14h, 00h, 04h, 40h, 04h
		db	 04h, 06h,0FFh, 06h, 06h, 06h
		db	 06h, 26h, 00h, 0Eh, 01h, 18h
		db	 00h, 40h, 42h, 04h, 40h, 04h
		db	 04h, 06h,0FFh, 06h, 06h, 06h
		db	 06h, 27h, 00h, 0Eh, 01h, 18h
		db	 00h, 42h, 42h, 04h, 42h, 04h
		db	 04h, 06h,0FFh, 06h, 06h, 06h
		db	 06h, 28h, 00h, 0Eh, 01h, 1Ch
		db	 00h, 40h, 42h, 04h, 40h, 04h
		db	 04h, 06h,0FFh, 06h, 06h, 06h
		db	 06h, 06h, 06h, 29h, 00h, 0Eh
		db	 01h, 1Ch, 00h, 42h, 42h, 04h
		db	 42h, 04h, 04h, 06h,0FFh, 06h
		db	 06h, 06h, 06h, 06h, 06h, 2Ah
		db	 00h, 0Ah, 01h, 20h, 00h
		db	'@BB@B@BB'
		db	 06h,0FFh, 06h, 06h, 06h, 06h
		db	 06h, 06h, 2Bh, 00h, 0Ah, 01h
		db	 20h, 00h
		db	'BB@BBB@@'
		db	 06h,0FFh, 06h, 06h, 06h, 06h
		db	 06h, 06h, 2Ch, 00h, 0Ah, 01h
		db	 20h, 00h, 40h, 42h, 42h, 40h
		db	 40h, 42h, 06h, 06h, 06h,0FFh
		db	 06h, 06h, 06h, 06h, 06h, 06h
		db	 2Dh, 00h, 0Ah, 01h, 20h, 00h
		db	 42h, 42h, 42h, 42h, 40h, 40h
		db	 06h, 06h, 06h,0FFh, 06h, 06h
		db	 06h, 06h, 06h, 06h, 2Eh, 00h
		db	 0Ah, 01h, 20h, 00h, 42h, 42h
		db	 40h, 42h, 06h, 40h, 06h, 06h
		db	 06h,0FFh, 06h, 06h, 06h, 06h
		db	 06h, 06h, 2Fh, 00h, 0Ah, 01h
		db	 20h, 00h, 40h, 42h, 40h, 40h
		db	 06h, 06h, 06h, 06h, 06h,0FFh
		db	 06h, 06h, 06h, 06h, 06h, 06h
		db	'#', 0
		db	'p', 0
		db	'`', 0
		db	'OOOO""""""""""""""""""""""""""""'
		db	'""""""""""/"OOOO$'
		db	0
		db	'p', 0
		db	'`', 0
		db	'OO"B""""""""""""""""""""""""""""'
		db	'""""""""""""O"OO%', 0
		db	'p', 0
		db	'`', 0
		db	'BO""O/OOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOO"O""OO&', 0
		db	'p', 0
		db	'`', 0
		db	'"OO"OOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOO"BO/', 27h, 0
		db	'p', 0
		db	'`', 0
		db	'"OOOO"OO"OOO"OOOOOOOO"OOOO"O""O"'
		db	'OOO"OO"O""OOBOO/(', 0
		db	'p', 0
		db	'`', 0
		db	'"B"O""OO""O"""O"OO"O""OOOO""""""'
		db	'"O""OO""""O"BOO")', 0
		db	'p', 0
		db	'`', 0
		db	'/B"O""OO""O"""O"OO"O""OOOO""""""'
		db	'"O""OO""""""OOO"*', 0
		db	'p', 0
		db	'`', 0
		db	'/""O""OO""O"""O"OO"O""OO"O""O"""'
		db	'"O"""O""O"""OO/"+', 0
		db	'p', 0
		db	'`', 0
		db	'O""O""OO""""""O"OO"""OO""O""OOOO'
		db	'"O"""O""OOOOOO/B,', 0
		db	'p', 0
		db	'`', 0
		db	'O""O""OO""""""O"OO"""OO""O""OOOO'
		db	'"O"""O""OOOOOO/B-', 0
		db	'p', 0
		db	'`', 0
		db	'O""O"""O""""""""OO""""O""O"""O""'
		db	'"O"""O""OOOOOO/B.', 0
		db	'p', 0
		db	'`', 0
		db	'/""O"""O"""""""""O"""""""O""O"""'
		db	'"O"""O""O"""OO/"/', 0
		db	'p', 0
		db	'`', 0
		db	'/B"O"""OO"""O""""O"""O""OO""""""'
		db	'"O""OO""""""OOO"0', 0
		db	'p', 0
		db	'`', 0
		db	'"B"O"""OO"""O""""O"""O""OO""""""'
		db	'"O""OO""""O"BOO"1', 0
		db	'p', 0
		db	'`', 0
		db	'"OOOO""OOO"OOO"OOOO"OOO"OO"O""O"'
		db	'OOO"OO"O""OOBOO/2', 0
		db	'p', 0
		db	'`', 0
		db	'"OO"OOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOO"BO/3', 0
		db	'p', 0
		db	'`', 0
		db	'BO""O/OOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOO"O""OO4', 0
		db	'p', 0
		db	'`', 0
		db	'OO"B""""""""""""""""""""""""""""'
		db	'""""""""""""O"OO5', 0
		db	'p', 0
		db	'`', 0
		db	'OOOO""""""""""""""""""""""""""""'
		db	'""""""""""/"OOOOb', 0
		db	 20h, 01h, 04h, 00h, 40h, 40h
		db	 63h, 00h, 1Ch, 01h, 08h, 00h
		db	 40h, 22h, 40h, 40h, 64h, 00h
		db	 20h, 01h, 04h, 00h, 60h, 60h
		db	 65h, 00h, 20h, 01h, 04h, 00h
		db	 60h, 60h, 66h, 00h, 20h, 01h
		db	 04h, 00h, 60h, 06h, 67h, 00h
		db	 20h, 01h, 08h, 00h, 06h, 06h
		db	 00h, 04h, 68h, 00h, 1Eh, 01h
		db	 0Ch, 00h, 06h, 22h, 06h, 06h
		db	 00h, 00h, 69h, 00h, 1Ah, 01h
		db	 10h, 00h, 60h, 22h, 60h, 60h
		db	 60h, 06h, 00h, 00h, 6Ah, 00h
		db	 1Ah, 01h, 10h, 00h, 60h, 22h
		db	 22h, 22h, 06h, 06h, 00h, 00h
		db	 6Bh, 00h, 1Eh, 01h, 0Ch, 00h
		db	 60h, 22h, 60h, 60h, 00h, 06h
		db	 6Ch, 00h, 1Eh, 01h, 0Ch, 00h
		db	 60h, 22h, 06h, 06h, 00h, 06h
		db	 6Dh, 00h, 1Ah, 01h, 10h, 00h
		db	 60h, 22h, 60h, 60h, 06h, 06h
		db	 00h, 06h, 6Eh, 00h, 1Ah, 01h
		db	 10h, 00h, 60h, 22h, 60h, 60h
		db	 06h, 60h, 00h, 06h, 6Fh, 00h
		db	 1Ah, 01h, 10h, 00h, 60h, 22h
		db	 60h, 40h, 00h, 60h, 00h, 00h
		db	 70h, 00h, 1Ah, 01h, 10h, 00h
		db	'`"`@@@@"q'
		db	 00h, 1Ah, 01h, 10h, 00h, 22h
		db	 00h, 60h, 40h, 40h, 40h, 40h
		db	 22h, 72h, 00h, 1Ah, 01h, 10h
		db	 00h
		db	'`@@@@"@"s'
		db	 00h, 1Ah, 01h, 10h, 00h, 40h
		db	 22h, 22h, 00h, 40h, 40h, 40h
		db	 22h, 74h, 00h, 1Ah, 01h, 10h
		db	 00h, 40h,0FFh, 40h, 22h, 40h
		db	 40h, 40h, 22h, 75h, 00h, 1Ah
		db	 01h, 10h, 00h, 40h,0FFh, 40h
		db	 22h, 40h, 22h, 40h, 22h, 76h
		db	 00h, 1Ah, 01h, 10h, 00h, 40h
		db	0FFh, 40h, 22h, 40h, 22h, 40h
		db	 22h, 77h, 00h, 1Ah, 01h, 10h
		db	 00h, 40h,0FFh, 40h, 22h, 40h
		db	 22h, 40h, 22h, 78h, 00h, 1Ah
		db	 01h, 10h, 00h, 22h,0FFh, 40h
		db	 40h, 40h, 22h, 40h, 22h, 79h
		db	 00h, 1Ah, 01h, 10h, 00h, 22h
		db	0FFh, 22h, 40h, 40h, 22h, 40h
		db	 22h, 7Ah, 00h, 1Ah, 01h, 10h
		db	 00h, 22h,0FFh, 22h, 40h, 40h
		db	 22h, 40h, 22h, 7Bh, 00h, 1Ah
		db	 01h, 10h, 00h, 22h,0FFh, 22h
		db	 40h, 40h, 22h, 40h, 22h, 7Ch
		db	 00h, 1Ah, 01h, 10h, 00h, 40h
		db	0FFh, 22h, 40h, 40h, 22h, 40h
		db	 22h, 7Dh, 00h, 1Ah, 01h, 10h
		db	 00h, 40h,0FFh, 22h, 22h, 40h
		db	 22h, 40h, 22h, 7Eh, 00h, 1Ah
		db	 01h, 10h, 00h, 40h,0FFh, 22h
		db	 22h, 22h, 22h, 40h, 22h, 7Fh
		db	 00h, 1Ah, 01h, 10h, 00h, 40h
		db	0FFh, 22h, 22h, 22h, 22h, 40h
		db	 22h, 80h, 00h, 1Ah, 01h, 10h
		db	 00h
		db	'@"""""@"'
		db	 81h, 00h, 1Ah, 01h, 10h, 00h
		db	 40h,0F2h, 22h, 22h, 22h, 22h
		db	 40h, 22h, 82h, 00h, 1Ah, 01h
		db	 10h, 00h, 40h,0F2h, 22h, 22h
		db	 22h, 22h, 40h, 22h, 83h, 00h
		db	 1Ah, 01h, 10h, 00h, 40h,0FFh
		db	 22h, 22h, 22h, 22h, 40h, 22h
		db	 12h, 00h, 51h, 00h, 18h, 00h
		db	 00h, 00h, 00h, 66h, 66h, 00h
		db	 00h, 00h, 60h, 06h, 06h, 00h
		db	 13h, 00h, 51h, 00h, 14h, 00h
		db	 66h, 06h, 06h, 66h, 66h, 66h
		db	 06h, 66h, 60h, 66h, 14h, 00h
		db	 51h, 00h, 18h, 00h, 06h, 60h
		db	 00h, 66h, 66h, 06h, 06h, 66h
		db	 66h, 66h, 66h, 00h, 15h, 00h
		db	 51h, 00h, 18h, 00h, 60h, 66h
		db	 06h, 66h, 66h, 66h, 06h, 66h
		db	 66h, 66h, 06h, 66h, 16h, 00h
		db	 51h, 00h, 18h, 00h, 00h, 00h
		db	 00h, 66h, 66h, 00h, 06h, 66h
		db	 60h, 66h, 06h, 00h, 12h, 00h
		db	0CEh, 00h, 20h, 00h, 00h, 00h
		db	 60h, 66h, 66h, 06h, 66h, 06h
		db	 60h, 06h, 06h, 00h, 00h, 60h
		db	 66h, 06h, 13h, 00h,0CEh, 00h
		db	 20h, 00h, 66h, 06h, 06h, 66h
		db	 66h, 60h, 60h, 00h, 60h, 06h
		db	 66h, 66h, 66h, 60h, 66h, 66h
		db	 14h, 00h,0CEh, 00h, 20h, 00h
		db	 00h, 06h, 00h, 66h, 66h, 00h
		db	 06h, 06h, 60h, 06h, 66h, 00h
		db	 00h, 66h, 66h, 66h, 15h, 00h
		db	0CEh, 00h, 20h, 00h, 60h, 06h
		db	 06h, 66h, 66h, 60h, 66h, 06h
		db	 60h, 06h, 66h, 66h, 66h, 66h
		db	 66h, 06h, 16h, 00h,0CEh, 00h
		db	 20h, 00h, 00h, 00h, 06h, 66h
		db	 66h, 60h, 66h, 06h, 60h, 06h
		db	 06h, 00h, 00h, 60h, 66h, 06h
		db	 12h, 00h,0EEh, 00h, 20h, 00h
		db	 00h, 60h, 60h, 06h, 06h, 00h
		db	 66h, 60h, 66h, 06h, 00h, 06h
		db	 06h, 00h, 00h, 00h, 13h, 00h
		db	0EEh, 00h, 20h, 00h, 66h, 60h
		db	 60h, 06h, 06h, 66h, 66h, 60h
		db	 66h, 00h, 66h, 06h, 66h, 06h
		db	 66h, 06h, 14h, 00h,0EEh, 00h
		db	 20h, 00h, 00h, 60h, 60h, 06h
		db	 06h, 66h, 66h, 60h, 06h, 06h
		db	 66h, 06h, 66h, 06h, 06h, 60h
		db	 15h, 00h,0EEh, 00h, 20h, 00h
		db	 66h, 60h, 60h, 66h, 06h, 66h
		db	 66h, 60h, 60h, 06h, 66h, 06h
		db	 66h, 06h, 60h, 66h, 16h, 00h
		db	0EEh, 00h, 20h, 00h, 66h, 60h
		db	 60h, 66h, 06h, 00h, 66h, 60h
		db	 66h, 06h, 66h, 06h, 66h, 06h
		db	 00h, 00h, 0Bh, 00h, 7Eh, 00h
		db	 04h, 00h, 00h, 00h, 0Ch, 00h
		db	 7Eh, 00h, 04h, 00h,0F0h, 0Fh
		db	 0Dh, 00h, 7Eh, 00h, 04h, 00h
		db	0F0h, 0Fh, 0Eh, 00h, 7Eh, 00h
		db	 04h, 00h, 00h, 00h, 1Ah, 00h
		db	 7Eh, 00h, 04h, 00h, 06h, 06h
		db	 1Bh, 00h, 7Eh, 00h, 04h, 00h
		db	 06h, 06h, 1Ch, 00h, 7Eh, 00h
		db	 04h, 00h, 06h, 06h, 1Dh, 00h
		db	 7Eh, 00h, 04h, 00h, 06h, 06h
		db	 62h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 63h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 64h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 65h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 66h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 67h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 68h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 69h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 6Ah, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 6Bh, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 6Ch, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 6Dh, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 6Eh, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 6Fh, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 70h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 71h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 72h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 73h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 76h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 2Fh,0F2h,0F2h, 77h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 2Fh
		db	0F2h,0F2h, 79h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 2Fh,0F2h,0F2h
		db	 7Ah, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 2Fh,0F2h,0F2h, 7Ch, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 2Fh
		db	0F2h,0F2h, 7Dh, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 2Fh,0F2h,0F2h
		db	 80h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 81h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 82h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 83h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 84h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 85h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 86h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 87h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 88h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 89h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 8Ah, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 8Bh, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 8Ch, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 8Dh, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 8Eh, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 8Fh, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 90h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 91h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 92h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 93h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 94h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 95h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 96h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 97h, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	 98h, 00h, 9Ch, 00h, 08h, 00h
		db	 2Fh, 22h, 22h,0F2h, 99h, 00h
		db	 9Ch, 00h, 08h, 00h, 2Fh, 22h
		db	 22h,0F2h, 9Ah, 00h, 9Ch, 00h
		db	 08h, 00h, 2Fh, 22h, 22h,0F2h
		db	12 dup (0)
		db	33 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0A0h,0CCh,0AAh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0AFh,0FFh,0CAh
		db	11 dup (0AAh)
		db	0FFh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0FFh,0FFh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0CCh,0FFh,0FFh,0FCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CFh,0FFh,0FFh,0ACh,0CAh,0AAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0FAh,0AAh,0CCh,0AAh
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FFh,0FAh,0AAh
		db	0CCh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh
		db	30 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0CCh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0CAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AFh,0FFh,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0CFh,0FFh,0FFh,0FFh
		db	0FAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0ACh,0CCh,0FFh
		db	0FFh,0FCh,0CAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0ACh
		db	0CFh,0FFh,0FFh,0ACh,0CAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CFh,0FFh,0FAh,0AAh
		db	0CCh,0CAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0FAh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	35 dup (0AAh)
		db	0A0h, 00h, 0Ah,0AAh,0AAh, 00h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 00h, 00h,0CAh,0AAh
		db	0A0h,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	0CAh,0AAh,0A0h,0AAh, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 0Ch,0CAh,0AAh,0A0h,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0CCh,0AAh,0AAh
		db	0A0h,0AAh
		db	0Ah
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0A0h,0A0h
		db	0AAh
		db	7 dup (0AAh)
		db	0FFh,0FAh,0AAh,0AAh,0A0h,0A0h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0FFh,0FAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0FFh,0FFh,0FFh
		db	0CCh,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0CFh
		db	0FFh,0FFh,0CCh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0AFh,0FFh,0FFh,0ACh,0CAh
		db	0C0h
		db	7 dup (0AAh)
		db	0CCh,0CFh,0FFh,0FAh,0AAh,0CCh
		db	0CCh
		db	7 dup (0AAh)
		db	0ACh,0CFh,0FFh,0FAh,0AAh,0CCh
		db	0CAh,0AAh,0AAh
		db	34 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	0C0h, 00h, 0Ah
		db	8 dup (0AAh)
		db	 00h, 00h,0AAh,0C0h, 00h, 0Ah
		db	7 dup (0AAh)
		db	0A0h,0AAh,0AAh, 0Ah,0CCh, 00h
		db	 0Ah
		db	7 dup (0AAh)
		db	0A0h,0AAh,0AAh,0A0h,0ACh, 00h
		db	8 dup (0AAh)
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0CCh
		db	8 dup (0AAh)
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0FFh
		db	0FAh
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0AFh,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h, 00h, 00h,0ACh
		db	0CFh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0CCh,0CFh,0FFh,0CAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0FFh,0FFh,0CAh
		db	8 dup (0AAh)
		db	0CCh,0CCh,0CAh,0FFh,0FFh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0FFh,0FFh,0AAh
		db	0AAh,0AAh
		db	39 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	0CCh, 00h, 0Ah
		db	11 dup (0AAh)
		db	0CCh, 00h, 0Ah
		db	11 dup (0AAh)
		db	0CCh,0C0h, 0Ah,0AAh
		db	10 dup (0AAh)
		db	0ACh,0C0h,0AAh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh
		db	13 dup (0AAh)
		db	0CFh,0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0FFh,0FFh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0FFh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AFh,0FFh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 0Ah
		db	0AAh,0AAh,0CCh,0AAh,0CFh,0FFh
		db	0FFh,0AAh,0AAh,0AAh,0AAh, 0Ah
		db	0AAh,0A0h,0AAh,0AAh,0CAh,0ACh
		db	0CCh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh, 0Ah,0ACh
		db	0CAh,0CCh,0CAh,0FFh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A1h
		db	 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h,0CCh
		db	11 dup (0AAh)
		db	0CCh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FAh,0AAh,0AAh,0AFh,0FAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0FAh,0AAh,0AFh,0FFh
		db	0FAh
		db	9 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 1Ch,0AAh,0AAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0ACh,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CCh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FAh,0AAh,0AAh,0AFh,0FAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0AAh,0AAh,0AFh,0FFh
		db	0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0C1h, 11h, 1Ah
		db	10 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FAh
		db	0AAh,0AAh,0AFh,0FAh
		db	8 dup (0AAh)
		db	0FFh,0FAh,0AAh,0AAh,0FFh,0FAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0A0h, 0Ch, 00h
		db	0CAh,0AAh, 11h, 11h,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0AAh,0A1h, 11h, 11h
		db	 1Ah,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0A1h
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0C1h, 11h, 1Ah
		db	10 dup (0AAh)
		db	0CCh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0CAh,0CCh,0CAh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0ACh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0AAh,0AAh,0FFh
		db	0FFh,0AAh,0AAh
data_a_2302	db	0AAh
		db	0AAh,0AAh,0A1h, 11h, 1Ah,0AAh
		db	0ACh,0CAh,0AAh, 0Ah,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh, 11h, 11h
		db	 11h,0AAh,0ACh, 00h, 00h,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh, 11h, 11h,0CCh,0AAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0CCh,0CCh
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0CAh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FAh,0AAh,0AAh,0AFh,0FAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0FAh,0AAh,0AFh,0FFh
		db	0FAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	8 dup (0)
		db	34 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CCh, 00h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0ACh,0CCh, 00h,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh, 0Ah,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CFh,0FAh
		db	11 dup (0AAh)
		db	6, 6, 6
		db	10 dup (0AAh)
		db	0AFh, 06h, 06h,0FCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CFh, 06h,0FCh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh, 06h, 06h,0CCh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0CCh,0AAh,0AFh,0FCh
		db	0CAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0ACh,0CAh,0AAh
		db	0AFh,0CCh,0FAh
		db	37 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CCh, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h, 00h, 0Ah,0AAh
		db	0AAh,0AAh,0ACh,0CCh, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0CCh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 0Ah,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0AAh,0ACh,0CFh,0FAh
		db	0AAh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh, 06h
		db	 06h, 06h,0FAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AFh, 06h, 06h, 06h,0CCh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h, 0Ah
		db	0AAh,0AAh,0ACh,0CFh, 06h, 06h
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0ACh,0CAh
		db	 06h, 06h,0FCh,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 0Ah,0ACh
		db	0CCh,0AAh,0AFh, 06h,0CCh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0CAh,0AAh,0AFh,0FCh
		db	0CAh,0AAh,0AAh
		db	31 dup (0AAh)
		db	0A0h,0AAh,0AAh,0AAh,0A0h, 00h
		db	 0Ah
		db	7 dup (0AAh)
		db	 0Ah, 0Ah,0AAh,0AAh,0ACh,0C0h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0A0h,0AAh,0AAh
		db	0ACh,0CCh, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 0Ah,0A0h
		db	0AAh,0AAh,0ACh,0CCh, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0A0h,0AAh,0AAh,0AAh,0CCh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh, 0Ah,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	 0Ah,0AAh,0AAh,0ACh,0CFh
		db	8 dup (0AAh)
		db	 0Ah, 0Ah,0AAh,0AFh, 06h, 06h
		db	 06h
		db	7 dup (0AAh)
		db	0A0h,0AAh,0AAh,0CCh, 06h, 06h
		db	0FCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h, 0Ah,0AAh,0CCh
		db	 06h, 06h,0FCh,0CCh
		db	7 dup (0AAh)
		db	 0Ch,0ACh,0CAh, 06h, 06h,0FAh
		db	0CCh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0AAh,0AFh, 06h,0CCh
		db	0CCh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AFh,0FCh,0CCh
		db	40 dup (0AAh)
		db	0A0h, 00h, 0Ah,0AAh,0AAh
		db	0AAh
data_a_2660	dw	0AAAAh			; Data table (indexed access)
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0A0h, 00h, 0Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 00h,0CCh,0CAh, 0Ah
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0CCh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0CAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FCh,0CAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 06h, 06h
		db	0A0h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0CCh
		db	 06h,0FCh,0C0h, 00h, 00h
		db	7 dup (0AAh)
		db	0ACh,0CCh, 06h,0FCh, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CFh, 06h,0F0h
		db	0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CAh,0CCh,0CCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 06h,0FAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh
		db	32 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 0Ch,0CCh
		db	11 dup (0AAh)
		db	0A0h, 0Ch,0CCh
		db	12 dup (0AAh)
		db	 0Ch,0CAh
		db	12 dup (0AAh)
		db	0CCh
		db	12 dup (0AAh)
		db	 06h,0CCh
		db	11 dup (0AAh)
		db	0AFh, 06h, 06h,0FAh
		db	10 dup (0AAh)
		db	0AFh,0CCh, 06h,0CCh
		db	10 dup (0AAh)
		db	 06h,0CCh,0CFh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	 06h, 06h,0CFh,0AAh,0CCh,0AAh
		db	0AAh,0A0h, 00h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh, 06h, 06h,0CCh,0AAh
		db	0ACh,0AAh,0AAh, 0Ah,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0AAh, 06h, 06h
		db	0ACh,0CCh,0ACh,0CAh,0A0h,0AAh
		db	0AAh,0AAh, 0Ah, 0Ah,0AAh,0AAh
		db	0A0h,0AAh,0ACh,0CAh,0AAh,0A1h
		db	 11h, 1Ah,0AAh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0AAh, 00h, 00h,0CAh
		db	0AAh, 11h, 11h, 11h,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh, 11h, 11h, 11h
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0CCh
		db	 11h, 11h,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0CCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CCh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FAh
		db	0AAh,0AAh,0AFh,0FAh
		db	7 dup (0AAh)
		db	0AFh,0FFh,0FAh,0AAh,0AFh,0FFh
		db	0FAh
		db	10 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh, 11h, 11h
		db	10 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CCh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FAh
		db	0AAh,0AAh,0AFh,0FAh
		db	7 dup (0AAh)
		db	0AFh,0FFh,0FAh,0AAh,0AFh,0FFh
		db	0FAh
		db	9 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0C1h, 11h, 1Ah
		db	10 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CAh,0CCh,0CAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FAh
		db	0AAh,0AAh,0AFh,0FAh
		db	8 dup (0AAh)
		db	0FFh,0FAh,0AAh,0AAh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h,0CCh
		db	11 dup (0AAh)
		db	0CCh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CAh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0ACh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0FAh,0AAh,0AAh
		db	0FFh,0FAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 11h, 11h,0AAh,0ACh, 00h
		db	0C0h, 0Ah,0AAh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0A1h, 11h, 11h, 1Ah
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0A1h, 11h
		db	 11h, 1Ah,0AAh,0AAh,0AAh,0AAh
		db	 0Ah,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0A1h, 11h, 1Ch,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h, 00h, 0Ah,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CCh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0FFh,0AAh,0AAh
		db	0FFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh
		db	8 dup (0)
		db	33 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0CCh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0CAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0FFh,0FFh,0FFh
		db	0FAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0FFh
		db	0FFh,0FCh,0CAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0AFh,0FFh,0FFh,0ACh,0CAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FFh,0FAh,0AAh
		db	0CCh,0CAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0FAh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	35 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0CCh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0CAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0ACh,0FFh,0FFh,0FFh
		db	0FAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0CCh,0FFh
		db	0FFh,0FCh,0CAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0CFh,0FFh,0FFh,0ACh,0CAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FFh,0FAh,0AAh
		db	0CCh,0CAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0FAh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	35 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0CCh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0CAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AFh,0FFh,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0CFh,0FFh,0FFh,0FFh
		db	0FAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0ACh,0CCh,0FFh
		db	0FFh,0FCh,0CAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0ACh
		db	0CFh,0FFh,0FFh,0ACh,0CAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CFh,0FFh,0FAh,0AAh
		db	0CCh,0CAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0FAh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	8 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 0Ch,0CCh
		db	12 dup (0AAh)
		db	 0Ch,0CAh
		db	12 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0AAh,0A0h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FCh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0FFh,0FFh,0FAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0ACh,0FFh,0FFh
		db	0FFh,0FFh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0CCh
		db	0CFh,0FFh,0FFh,0CCh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0ACh,0CAh,0FFh,0FFh,0FAh,0CCh
		db	0AAh,0AAh,0A0h,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0ACh,0CAh,0FFh,0FFh
		db	0AAh,0ACh,0CAh,0AAh,0A0h, 00h
		db	 00h,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0FFh,0FFh,0AAh,0AAh,0CCh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0AAh, 11h, 11h, 1Ah,0AAh
		db	0ACh,0C0h
		db	7 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ch,0AAh,0AAh
		db	0CCh
		db	9 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0A0h,0CCh,0AAh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AFh,0FFh,0CAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AFh,0FFh,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0CFh,0FFh
		db	0FFh,0FFh,0FAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0ACh
		db	0CCh,0FFh,0FFh,0FCh,0CAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0ACh,0CFh,0FFh,0FFh,0ACh
		db	0CAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0CFh,0FFh
		db	0FAh,0AAh,0CCh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0AFh,0FFh,0FAh,0AAh,0ACh,0CAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A1h, 11h, 1Ah,0AAh
		db	0AAh,0CCh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 11h, 11h
		db	 11h,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h,0CCh
		db	11 dup (0AAh)
		db	0CCh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FFh,0CCh,0CCh,0CCh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0CCh,0CCh,0CAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0FAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FAh,0AAh,0AAh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0AFh,0FAh
		db	12 dup (0AAh)
		db	0AFh,0FFh,0FAh
		db	8 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	12 dup (0AAh)
		db	 11h, 11h
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0ACh,0CCh
		db	12 dup (0AAh)
		db	0ACh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0FCh,0CCh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0AFh,0FCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0AAh,0AAh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0AAh,0AAh,0CCh
		db	13 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	12 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0CCh,0CAh
		db	9 dup (0AAh)
		db	0AFh,0FCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0FCh,0CCh
		db	11 dup (0AAh)
		db	0AFh,0CCh
		db	12 dup (0AAh)
		db	0AFh,0CCh
		db	13 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 11h,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0FFh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0FFh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0FAh
		db	10 dup (0AAh)
		db	0AFh,0CAh,0AAh,0FAh
		db	10 dup (0AAh)
		db	0AFh,0FAh
		db	13 dup (0AAh)
		db	0FFh,0FAh
		db	12 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0CAh
		db	10 dup (0AAh)
		db	 11h, 11h, 1Ch,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0ACh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0AAh,0FFh
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0FFh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0AAh,0FAh
		db	9 dup (0AAh)
		db	0AFh,0CAh,0AAh,0AAh,0FAh
		db	9 dup (0AAh)
		db	0AFh,0FAh
		db	13 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 11h,0CCh
		db	10 dup (0AAh)
		db	 11h, 1Ah, 1Ch,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh,0AFh,0FAh
		db	7 dup (0AAh)
		db	0FFh,0CCh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0FAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0FAh
		db	13 dup (0AAh)
		db	0AFh
		db	15 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ch,0CAh
		db	9 dup (0AAh)
		db	0ACh, 11h,0A1h,0CCh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CCh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0AAh,0AAh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0FFh,0CCh,0CCh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0CCh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0FFh
		db	0CCh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0CCh,0AAh,0FAh,0AAh,0AAh
		db	0AAh,0FAh
		db	7 dup (0AAh)
		db	0AFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	0FAh
		db	7 dup (0AAh)
		db	0AFh,0FAh
		db	49 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 1Ah, 11h,0CAh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0ACh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FFh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	0CCh
		db	7 dup (0AAh)
		db	0FFh,0CCh,0CCh,0AAh,0AAh,0AAh
		db	0CCh
		db	7 dup (0AAh)
		db	0FAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0CCh
		db	7 dup (0AAh)
		db	0FAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0AAh,0FAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0AFh,0FAh
		db	33 dup (0AAh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh
		db	31 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0ACh,0C0h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0ACh,0CCh
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0CCh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0AFh
		db	 06h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0AAh, 06h, 06h,0FAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0AFh, 06h, 06h,0CCh
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0ACh,0CFh, 06h,0CCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0CCh,0AFh
		db	 06h,0FCh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0CCh
		db	0CAh,0AFh, 06h,0CCh
		db	11 dup (0AAh)
		db	0AFh,0CCh,0CAh,0AAh,0AAh
		db	36 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0ACh,0C0h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0ACh,0CCh
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0CCh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0AFh
		db	 06h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0AAh, 06h, 06h,0FAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0AFh, 06h, 06h,0CCh
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0ACh,0CFh, 06h,0CCh
		db	8 dup (0AAh)
		db	0A0h,0AAh,0CCh,0AFh, 06h,0FCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0CCh,0CAh,0AFh
		db	0FCh,0CCh
		db	11 dup (0AAh)
		db	0ACh,0CCh,0FAh
		db	38 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0ACh,0C0h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0ACh,0CCh
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0CCh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0AFh
		db	 06h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0AAh, 06h, 06h,0FAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0AFh, 06h, 06h,0CCh
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0ACh,0CFh, 06h,0CCh
		db	8 dup (0AAh)
		db	0A0h,0AAh,0CCh,0AFh, 06h,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0ACh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0AFh, 06h,0FAh
		db	38 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0ACh,0C0h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0ACh,0CCh
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0CCh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh,0AFh
		db	 06h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0AAh, 06h, 06h,0FAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0AFh, 06h, 06h,0CCh
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0ACh,0CFh, 06h,0CCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0CCh,0AFh
		db	 06h,0FAh,0CCh
		db	8 dup (0AAh)
		db	0CCh,0CAh,0AFh, 06h,0FCh,0CAh
		db	0AAh,0AAh
		db	8 dup (0AAh)
		db	0AFh,0FCh,0CCh
		db	10 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh
		db	10 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CCh, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0CCh, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AFh, 06h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh, 06h, 06h,0FAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AFh, 06h
		db	 06h,0CCh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0ACh,0CFh, 06h,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0ACh,0CFh, 06h,0FAh
		db	0CCh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0CCh,0AFh, 06h,0FAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0ACh,0CAh,0AFh
		db	 06h,0FAh,0ACh,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0CCh
		db	0AAh, 11h, 11h, 1Ah,0AAh,0CAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh, 11h, 11h, 11h,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh
		db	10 dup (0AAh)
		db	0ACh,0C0h, 00h,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CCh, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0CCh, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AFh, 06h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0AAh, 06h, 06h,0FAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AFh, 06h
		db	 06h,0CCh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0ACh,0CFh, 06h,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0ACh,0CFh, 06h,0FAh
		db	0CCh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0CCh,0AFh, 06h,0FCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0ACh,0CAh,0AFh
		db	0FCh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh, 11h, 11h
		db	10 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0CCh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CCh,0CCh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0ACh
		db	0CCh,0CCh,0FFh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AFh
		db	7 dup (0AAh)
		db	0AFh,0FAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0FAh
		db	14 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CFh,0FAh
		db	10 dup (0AAh)
		db	0CCh,0CCh,0CFh,0FAh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0AAh,0FAh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0AAh,0FAh
		db	10 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0ACh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0CCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0CCh,0CFh,0FAh
		db	11 dup (0AAh)
		db	0CCh,0CFh,0FAh
		db	12 dup (0AAh)
		db	0CCh,0FAh
		db	12 dup (0AAh)
		db	0CCh,0FAh
		db	12 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0CCh,0CCh,0CAh
		db	0AAh,0AAh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0FFh,0ACh,0CAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0FFh,0AAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0AFh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0AFh,0AAh,0ACh,0FAh
		db	12 dup (0AAh)
		db	0AFh,0FAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh, 11h, 11h, 11h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0C1h, 11h, 11h
		db	9 dup (0AAh)
		db	0CCh,0CCh,0CAh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0FFh,0AAh
		db	0CCh,0CAh
		db	10 dup (0AAh)
		db	0FFh,0AAh,0ACh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0AAh,0AAh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0AAh,0AAh,0ACh,0FAh
		db	12 dup (0AAh)
		db	0AFh,0FAh
		db	12 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh, 11h, 11h, 11h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0C1h,0A1h, 11h
		db	0AAh,0AAh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FAh,0AAh,0AAh
		db	0ACh,0CCh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh,0FFh,0FAh
		db	0AAh,0AAh,0AAh,0CCh,0FFh,0AAh
		db	0AAh,0AAh
		db	10 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0AFh
		db	13 dup (0AAh)
		db	0FAh
		db	8 dup (0AAh)
		db	0CCh, 11h, 11h, 11h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CCh,0C1h,0A1h, 1Ch
		db	0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CCh,0CAh,0AAh,0AAh
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0AAh
		db	0AAh,0AAh,0ACh,0CCh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0CCh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0CFh,0FAh
		db	0AAh,0AAh,0AAh,0FAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0ACh
		db	0CFh,0FAh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0FAh,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0FAh
		db	49 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh, 11h,0A1h, 11h,0AAh
		db	9 dup (0AAh)
		db	0CCh,0CCh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CCh,0CCh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CCh,0AAh,0AAh,0AAh
		db	0CCh,0CCh,0FFh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0AAh
		db	0CCh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FAh
		db	12 dup (0AAh)
		db	0AFh,0FAh
		db	36 dup (0AAh)
		db	 00h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh
		db	31 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh, 00h, 00h
		db	8 dup (0AAh)
		db	0A0h, 00h, 0Ah,0ACh, 00h, 00h
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0ACh,0C0h, 00h
		db	0AAh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah,0C0h, 0Ah
		db	0AAh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0AAh, 0Ah
		db	0AFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0FFh,0FFh,0FAh
		db	8 dup (0AAh)
		db	 00h, 00h, 0Ah,0CCh,0FFh,0FFh
		db	0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0FFh,0FCh
		db	10 dup (0AAh)
		db	0CCh,0CFh,0FFh,0FCh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0CCh,0AFh,0FFh,0FAh
		db	8 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AFh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh, 00h, 00h
		db	8 dup (0AAh)
		db	0A0h, 00h, 0Ah,0ACh, 00h, 00h
		db	8 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0ACh,0C0h, 00h
		db	0AAh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah,0C0h, 0Ah
		db	0AAh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0AAh, 0Ah
		db	0AFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0FFh,0FFh,0FAh
		db	8 dup (0AAh)
		db	 00h, 00h, 0Ah,0CCh,0FFh,0FFh
		db	0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0FFh,0FCh
		db	10 dup (0AAh)
		db	0CCh,0CFh,0FFh,0FCh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0CCh,0AFh,0FFh,0FAh
		db	8 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AFh,0FFh,0FAh
		db	11 dup (0AAh)
		db	0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	33 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0A0h,0CCh,0AAh,0AAh,0A0h, 00h
		db	 0Ah
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FCh,0CAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 06h, 06h
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0CCh
		db	 06h, 06h,0CAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0CCh, 06h, 06h,0CAh,0A0h
		db	0AAh,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CFh, 06h, 06h
		db	0C0h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CCh
		db	0CCh,0C0h, 0Ch,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AFh, 06h,0FAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 00h, 0Ch,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 00h,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0A0h,0CCh,0AAh,0AAh,0A0h, 00h
		db	 0Ah
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FCh,0CAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 06h, 06h
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0CCh
		db	 06h, 06h,0CAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0CCh, 06h, 06h,0CAh,0A0h
		db	0AAh,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CFh, 06h, 06h
		db	0C0h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CCh
		db	0CCh,0C0h, 0Ch,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AFh, 06h,0FAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A1h, 11h, 1Ah
		db	11 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh
		db	8 dup (0)
		db	49 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 0Ch,0CCh
		db	12 dup (0AAh)
		db	 0Ch,0CAh
		db	11 dup (0AAh)
		db	0FFh,0FCh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0FFh,0FFh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0AFh,0FFh,0FFh,0FCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0FFh,0FFh,0FFh,0CCh,0CCh,0CCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AFh,0FFh,0FFh,0AAh,0ACh
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh,0FFh,0FAh
		db	0AAh,0AAh,0CCh
		db	42 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0A0h, 0Ch,0CCh
		db	12 dup (0AAh)
		db	 0Ch,0CAh
		db	12 dup (0AAh)
		db	0CCh
		db	12 dup (0AAh)
		db	0AFh,0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0FFh,0FFh,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CFh,0FFh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0CCh,0CFh,0FFh,0FCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CAh,0FFh,0FFh,0ACh
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0CCh,0AAh,0FFh
		db	0FFh,0AAh,0ACh,0CCh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AFh,0FFh,0FAh,0AAh,0AAh,0ACh
		db	0CCh
		db	36 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h, 00h,0CCh,0AAh,0AAh,0AAh
		db	0ACh
		db	7 dup (0AAh)
		db	0A0h, 00h,0CCh,0AAh,0AAh,0AAh
		db	0CCh
		db	7 dup (0AAh)
		db	0A0h, 0Ch,0CCh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 0Ch,0CAh,0AAh
		db	0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0FFh,0FAh,0AFh,0CCh
		db	9 dup (0AAh)
		db	0AFh,0FFh,0FFh,0FFh,0FAh,0AAh
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0FFh,0FFh,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0ACh,0CFh,0FFh
		db	0FFh,0FAh,0AAh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0CCh
		db	0CCh,0FFh,0FFh,0FAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh, 00h
		db	0CCh,0CAh,0AAh,0AFh,0FFh,0FFh
		db	0AAh,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	14 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0AAh
		db	10 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0A0h, 0Ah,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh, 00h, 00h, 0Ah
		db	0AAh,0AAh,0AAh, 00h,0CCh,0AAh
		db	0AAh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h, 00h
		db	0CCh,0CAh,0ACh,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h, 00h,0CCh,0CAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0ACh,0AAh,0AAh, 00h,0CCh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0AAh,0A0h
		db	0CCh,0AAh,0FFh,0CAh
		db	7 dup (0AAh)
		db	0CCh,0CCh,0AAh,0FFh,0FFh,0FFh
		db	0CAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0FFh,0FFh,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh,0FFh,0FFh
		db	0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0FFh,0FAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 11h, 11h
		db	9 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	8 dup (0AAh)
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	8 dup (0AAh)
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	9 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0AAh
		db	10 dup (0AAh)
		db	0A0h, 00h, 00h
		db	14 dup (0AAh)
		db	 0Ah,0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	0A0h,0AAh,0AAh
		db	12 dup (0AAh)
		db	0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h, 00h,0AAh,0CAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A0h, 00h, 0Ch,0AAh,0CCh
		db	9 dup (0AAh)
		db	0A0h, 00h, 0Ch,0AAh,0ACh
		db	9 dup (0AAh)
		db	0A0h, 00h,0CCh,0AAh,0CCh
		db	10 dup (0AAh)
		db	 00h,0CAh,0ACh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0ACh,0CAh,0FCh,0CAh
		db	10 dup (0AAh)
		db	0AFh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0AFh,0FFh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0ACh,0CFh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0CCh,0CFh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0ACh,0CAh,0AFh,0FFh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0FFh
		db	0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0FFh,0FFh,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	50 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h, 00h, 00h
		db	11 dup (0AAh)
		db	0A0h, 00h, 00h
		db	11 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	12 dup (0AAh)
		db	 00h,0CAh
		db	12 dup (0AAh)
		db	0AFh,0FFh,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0AFh,0FFh,0FFh,0FFh,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CFh,0FFh,0FFh,0CCh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0FFh,0FFh,0AAh,0CCh,0CAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0FFh,0FFh,0FAh,0AAh
		db	0CCh
		db	7 dup (0AAh)
		db	0ACh,0AAh,0AFh,0FFh,0FAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CCh,0AAh,0AFh,0FFh
		db	0FAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A1h
		db	 11h, 1Ah,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 11h, 11h, 11h,0AAh,0AAh
		db	0AAh,0CCh
		db	7 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 11h, 11h, 1Ch,0AAh
		db	0AAh,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0CCh
		db	0CCh,0CAh,0AAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0CCh,0CCh,0CCh,0CAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0CCh,0ACh
		db	0CCh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0CAh,0CCh,0CAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0CCh,0CAh,0AAh,0ACh,0CAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0CCh,0CCh,0AAh,0AAh
		db	0CCh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0FCh,0AAh
		db	0AAh,0AAh,0CCh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0FFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FAh,0AAh,0AAh
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0A1h, 11h, 1Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0AAh,0AAh, 11h, 11h
		db	 11h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0A0h
		db	0AAh,0AAh, 11h, 11h, 1Ch,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0CCh,0CCh
		db	0CCh,0CCh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0CCh,0CAh,0ACh,0CCh,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0CCh,0CAh,0AAh,0CCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh, 00h
		db	 00h,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0FCh
		db	8 dup (0AAh)
		db	0AFh,0FAh,0AAh,0AAh,0AAh,0FFh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FFh,0FAh,0AAh
		db	0AAh,0AFh,0FFh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 11h, 11h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A1h, 11h, 11h, 1Ah
		db	0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 11h, 1Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 1Ch,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CCh
		db	10 dup (0AAh)
		db	0ACh,0CCh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	8 dup (0AAh)
		db	0CCh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0ACh,0CCh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0CAh,0AAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0AFh,0FCh,0AAh,0AAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0AFh,0FAh,0AAh,0AAh,0AAh,0FFh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0FFh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0ACh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0AFh,0CAh,0FCh,0AAh
		db	10 dup (0AAh)
		db	0AFh,0FAh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0FFh,0AFh,0FAh,0AAh
		db	9 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0A1h, 11h, 11h
		db	11 dup (0AAh)
		db	0ACh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	11 dup (0AAh)
		db	0CAh,0ACh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0AFh,0CAh,0FCh,0AAh
		db	10 dup (0AAh)
		db	0AFh,0FAh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0AFh,0AAh,0FAh
		db	19 dup (0AAh)
		db	0CAh,0AAh,0A1h, 11h, 1Ah,0AAh
		db	0AAh,0AAh, 00h, 00h, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 11h, 11h
		db	 11h,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	 0Ah,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0C1h, 11h, 11h,0AAh
		db	0AAh,0AAh, 0Ah, 0Ah,0AAh, 0Ah
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0CCh
		db	0CCh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0CAh,0CCh,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0CCh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0CCh,0CAh
		db	0CCh,0CAh
		db	8 dup (0AAh)
		db	0AFh,0FCh,0CCh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AFh,0FCh,0CAh,0AAh
		db	0CCh
		db	9 dup (0AAh)
		db	0AFh,0AAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0AFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh
		db	10 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh
		db	14 dup (0)
		db	47 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	0CCh, 00h, 0Ah
		db	11 dup (0AAh)
		db	0CCh, 00h, 0Ah
		db	11 dup (0AAh)
		db	0CCh,0C0h, 0Ah,0AAh
		db	10 dup (0AAh)
		db	0ACh,0C0h,0AAh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CFh, 06h
		db	12 dup (0AAh)
		db	6, 6, 6
		db	11 dup (0AAh)
		db	 06h, 06h, 06h,0FAh
		db	10 dup (0AAh)
		db	0CCh, 06h, 06h,0FAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0CCh,0CCh,0AFh, 06h
		db	 06h
		db	8 dup (0AAh)
		db	0ACh,0CCh,0CAh,0AAh, 06h, 06h
		db	0FAh
		db	8 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AFh, 06h,0FAh
		db	34 dup (0AAh)
		db	0, 0
		db	8 dup (0AAh)
data_a_4E3B	db	0AAh			; Data table (indexed access)
		db	0AAh,0AAh,0AAh,0CCh, 00h, 0Ah
		db	11 dup (0AAh)
		db	0CCh, 00h, 0Ah
		db	11 dup (0AAh)
		db	0CCh,0C0h, 0Ah,0AAh
		db	10 dup (0AAh)
		db	0ACh,0C0h,0AAh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh
		db	13 dup (0AAh)
		db	 06h,0FAh
		db	11 dup (0AAh)
		db	 06h, 06h, 06h,0FAh
		db	9 dup (0AAh)
		db	0AFh, 06h, 06h, 06h,0FCh
		db	9 dup (0AAh)
		db	0ACh,0CFh, 06h, 06h,0CCh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0CAh, 06h, 06h,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CCh,0CAh,0AAh, 06h
		db	 06h,0AAh,0CCh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh,0AFh, 06h,0FAh,0AAh, 0Ah
		db	0AAh,0AAh,0AAh
		db	34 dup (0AAh)
		db	0, 0
		db	8 dup (0AAh)
		db	0CAh,0AAh,0AAh,0AAh,0CCh, 00h
		db	 0Ah
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0CCh, 00h
		db	 0Ah
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh,0C0h
		db	 0Ah,0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0C0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0AAh,0AAh
		db	0CCh
		db	10 dup (0AAh)
		db	0CCh,0FAh,0AFh, 06h
		db	10 dup (0AAh)
		db	0AFh, 06h, 06h, 06h,0FAh
		db	10 dup (0AAh)
		db	 06h, 06h, 06h, 06h,0AAh,0AAh
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AFh, 06h, 06h, 06h
		db	0CAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0AFh, 06h
		db	 06h,0FCh,0CCh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0AAh
		db	 06h, 06h,0FAh,0AAh,0ACh,0CCh
		db	 00h,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh, 06h, 06h,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0A0h
		db	25 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0ACh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh,0AAh,0A0h,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0A0h, 0Ah,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh, 0Ah,0AAh
		db	0AAh,0ACh,0AAh,0AAh,0CCh, 00h
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0ACh
		db	0CCh, 00h, 0Ah,0AAh,0AAh, 0Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0ACh
		db	0CAh,0ACh,0CCh, 00h, 0Ah,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ACh,0CAh,0AAh,0CCh, 00h
		db	0AAh,0AAh,0CAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh, 06h,0AAh
		db	0CCh, 0Ah,0AAh,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0ACh
		db	 06h, 06h, 06h,0AAh,0CCh,0CCh
		db	8 dup (0AAh)
		db	 06h, 06h, 06h, 06h,0CCh,0CAh
		db	0AAh,0AAh
		db	7 dup (0AAh)
		db	 06h, 06h, 06h,0FAh
		db	9 dup (0AAh)
		db	0AFh, 06h, 06h,0FAh
		db	10 dup (0AAh)
		db	 06h, 06h,0FAh
		db	11 dup (0AAh)
		db	6, 6
		db	12 dup (0AAh)
		db	6, 6
		db	12 dup (0AAh)
		db	 11h, 11h
		db	15 dup (0AAh)
		db	0, 0
		db	11 dup (0AAh)
		db	0A0h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah
		db	10 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah
		db	10 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 0Ah
		db	10 dup (0AAh)
		db	 0Ah,0AAh,0A0h,0AAh
		db	10 dup (0AAh)
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A0h,0AAh,0AAh
		db	11 dup (0AAh)
		db	 0Ah,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0ACh
		db	13 dup (0AAh)
		db	0ACh,0AAh, 00h, 00h
		db	10 dup (0AAh)
		db	0CCh,0AAh,0CCh,0C0h, 0Ah,0AAh
		db	8 dup (0AAh)
		db	0CAh,0AAh,0CCh,0C0h, 0Ah,0AAh
		db	8 dup (0AAh)
		db	0CCh,0AAh,0CCh,0C0h, 0Ah,0AAh
		db	8 dup (0AAh)
		db	0ACh,0CAh,0ACh,0C0h
		db	10 dup (0AAh)
		db	0ACh,0CFh,0AAh,0CCh
		db	11 dup (0AAh)
		db	6, 6, 6
		db	11 dup (0AAh)
		db	0AFh, 06h, 06h,0FAh
		db	10 dup (0AAh)
		db	0AFh, 06h,0FCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0AFh, 06h,0FCh,0CCh
		db	10 dup (0AAh)
		db	 06h, 06h,0FAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	 06h, 06h,0AAh,0ACh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	 06h, 06h,0AAh,0CCh
		db	10 dup (0AAh)
		db	 11h, 11h,0ACh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	39 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	0CCh,0C0h, 0Ah,0AAh
		db	10 dup (0AAh)
		db	0CCh,0C0h, 0Ah,0AAh
		db	10 dup (0AAh)
		db	0CCh,0CCh, 0Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0ACh,0CCh
		db	13 dup (0AAh)
		db	0CCh
		db	12 dup (0AAh)
		db	0AFh, 06h
		db	11 dup (0AAh)
		db	0AFh, 06h, 06h, 06h
		db	9 dup (0AAh)
		db	0ACh,0CCh,0CFh, 06h, 06h,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CCh,0CAh,0AFh, 06h
		db	0FCh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0AAh
		db	 06h, 06h,0FAh,0CCh
		db	7 dup (0AAh)
		db	 0Ah,0AAh,0AAh, 06h, 06h,0AAh
		db	0ACh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh,0AAh, 06h
		db	 06h,0AAh,0ACh,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0A1h, 11h, 1Ah
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh, 11h, 11h
		db	 11h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	 11h, 11h, 11h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AAh,0C1h, 11h, 11h,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h, 0Ah
		db	0AAh,0AAh,0AAh,0ACh,0CCh,0CCh
		db	0CCh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh, 0Ah,0AAh,0AAh,0ACh,0CCh
		db	0CCh,0CCh,0AAh,0AAh,0AAh,0AAh
		db	 0Ah,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	0CCh,0CAh,0CCh,0CAh,0AAh,0AAh
		db	0AAh,0AAh, 0Ah,0AAh,0AAh, 0Ah
		db	0AAh,0ACh,0CCh,0ACh,0CCh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 0Ah,0AAh
		db	0AAh, 0Ah,0AAh,0ACh,0CAh,0AAh
		db	0CCh,0CCh,0AAh,0AAh,0AAh,0AAh
		db	 0Ah,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0CCh,0AAh,0AAh,0CCh,0CCh,0AAh
		db	0AAh,0AAh,0A0h, 00h, 0Ah,0AAh
		db	0AAh,0AAh,0CCh,0AAh,0AAh,0AAh
		db	0CFh
		db	9 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0AAh,0AAh,0AFh
		db	0FAh
		db	7 dup (0AAh)
		db	0A1h, 11h, 1Ah,0AAh,0A0h,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	 11h, 11h, 11h,0AAh,0AAh, 00h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 11h, 11h, 11h,0AAh
		db	0AAh, 0Ah,0AAh,0A0h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ACh,0C1h, 11h
		db	 11h,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0CCh
		db	0CCh,0CCh,0CCh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0CCh,0CAh,0ACh,0CCh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh, 0Ah,0AAh
		db	0AAh,0AAh,0ACh,0CCh,0AAh,0ACh
		db	0CCh,0AAh,0AAh,0A0h,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0CCh,0AAh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0CFh,0AAh,0AAh,0AAh
		db	0ACh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh,0AFh,0FAh
		db	7 dup (0AAh)
		db	0FFh,0FAh,0AAh,0AAh,0AFh,0FFh
		db	0FAh
		db	9 dup (0AAh)
		db	 11h, 11h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh, 0Ah,0AAh
		db	0AAh,0A1h, 11h, 11h, 1Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	0AAh,0AAh,0AAh,0A1h, 11h, 11h
		db	 1Ah,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0CCh,0C1h, 11h, 1Ah
		db	10 dup (0AAh)
		db	0CCh,0CCh,0CCh,0CAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CCh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0CAh,0AAh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0AAh,0CCh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0AAh,0AAh,0ACh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0CFh,0FAh
		db	8 dup (0AAh)
		db	0FFh,0AAh,0AAh,0AAh,0AFh,0FAh
		db	7 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh,0FFh
		db	0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h
		db	12 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CCh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0CCh,0AAh
		db	11 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CFh,0ACh,0FAh
		db	11 dup (0AAh)
		db	0FFh,0AFh,0FAh,0AAh
		db	9 dup (0AAh)
		db	0AFh,0FAh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 11h, 11h, 1Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CAh,0ACh,0AAh
		db	11 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CCh,0ACh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0CFh,0ACh,0FAh
		db	11 dup (0AAh)
		db	0FFh,0AFh,0FAh,0AAh
		db	9 dup (0AAh)
		db	0AFh,0AAh,0FAh
		db	23 dup (0AAh)
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	 11h, 11h,0AAh,0AAh,0CAh,0AAh
		db	0AAh,0A0h,0AAh,0AAh, 0Ah,0AAh
		db	0AAh,0A1h, 11h, 11h, 1Ah,0AAh
		db	0AAh,0AAh,0AAh, 0Ah,0AAh,0AAh
		db	 0Ah,0AAh,0AAh,0A1h, 11h, 11h
		db	 1Ah,0AAh,0AAh,0AAh,0AAh, 0Ah
		db	0AAh,0AAh, 0Ah,0AAh,0AAh,0A1h
		db	 11h, 11h,0CAh,0AAh,0AAh,0AAh
		db	0AAh, 0Ah,0AAh,0AAh, 0Ah,0AAh
		db	0AAh,0ACh,0CCh,0CCh,0CAh,0AAh
		db	0AAh,0AAh,0AAh, 0Ah,0AAh,0A0h
		db	0AAh,0AAh,0AAh,0ACh,0CAh,0CCh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0A0h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0ACh
		db	0CAh,0CCh,0AAh
		db	10 dup (0AAh)
		db	0CCh,0CAh,0CCh,0CAh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0ACh,0CCh,0FFh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ACh,0CAh,0AAh,0CCh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ACh,0CAh
		db	0AAh,0AAh,0AFh
		db	9 dup (0AAh)
		db	0AFh,0FAh,0AAh,0AAh,0AFh
		db	9 dup (0AAh)
		db	0FFh,0FAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh
		db	14 dup (0)
		db	1470 dup (0FFh)
		db	89 dup (0AAh)
		db	0A0h, 00h,0AAh
		db	11 dup (0AAh)
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	11 dup (0AAh)
		db	0FFh,0FFh,0CAh
		db	10 dup (0AAh)
		db	0FFh,0FFh,0FFh,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0AFh,0FFh,0FFh,0CCh
		db	10 dup (0AAh)
		db	0AFh,0FFh,0FFh,0CCh
		db	10 dup (0AAh)
		db	 00h, 0Fh,0AAh,0CCh,0CCh,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 00h, 00h,0CCh,0CAh
		db	0AAh,0CAh
		db	8 dup (0AAh)
		db	0ACh,0CCh,0ACh,0CCh
		db	11 dup (0AAh)
		db	0ACh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0FCh,0CCh,0ACh,0AAh,0ACh
		db	9 dup (0AAh)
		db	0FAh,0CCh,0CCh,0AAh,0AFh
		db	9 dup (0AAh)
		db	0FFh,0AAh,0CCh,0AAh,0AFh,0FFh
		db	0AAh,0AAh,0AAh
		db	21 dup (0AAh)
		db	0A0h, 00h,0AAh
		db	11 dup (0AAh)
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0FFh,0CAh
		db	11 dup (0AAh)
		db	0CFh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0ACh,0FFh,0FCh,0FAh
		db	10 dup (0AAh)
		db	0ACh,0FFh,0FCh
		db	12 dup (0AAh)
		db	0FFh,0FCh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0FFh,0FFh,0AAh,0CAh,0AAh
		db	9 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0A0h, 00h,0CCh
		db	11 dup (0AAh)
		db	0ACh,0CAh,0CCh,0CAh
		db	8 dup (0AAh)
		db	0AFh,0FCh,0CCh,0CAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0AFh,0AAh,0ACh,0AAh,0AAh,0CCh
		db	8 dup (0AAh)
		db	0AFh,0AAh,0AAh,0AAh,0AAh,0CAh
		db	0AAh,0AAh
		db	11 dup (0AAh)
		db	0CAh,0AAh,0AAh
		db	11 dup (0AAh)
		db	0FAh
		db	13 dup (0AAh)
		db	0FFh,0FAh
		db	24 dup (0AAh)
		db	0A0h, 00h,0AAh
		db	11 dup (0AAh)
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0FFh,0CAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0FAh
		db	11 dup (0AAh)
		db	0AFh,0FCh,0FAh
		db	11 dup (0AAh)
		db	0FFh,0CFh
		db	12 dup (0AAh)
		db	0FFh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	 00h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0A0h, 00h, 0Ah
		db	11 dup (0AAh)
		db	0ACh,0CCh,0CAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0FCh,0CCh,0CCh
		db	11 dup (0AAh)
		db	0FAh,0CCh
		db	12 dup (0AAh)
		db	0FAh,0CAh,0AAh,0AAh
		db	11 dup (0AAh)
		db	0CAh,0AAh,0AAh
		db	11 dup (0AAh)
		db	0FAh
		db	13 dup (0AAh)
		db	0FFh,0FAh
		db	26 dup (0AAh)
		db	0A0h, 00h,0AAh
		db	11 dup (0AAh)
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0FFh,0CAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0FAh
		db	11 dup (0AAh)
		db	0CCh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0ACh,0FFh,0FFh,0CAh
		db	10 dup (0AAh)
		db	0ACh,0FFh,0FFh,0CCh,0CAh,0AAh
		db	0AAh
		db	8 dup (0AAh)
		db	0CFh,0FFh,0AAh,0AAh,0AAh
		db	9 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h, 00h,0CCh
		db	11 dup (0AAh)
		db	0CCh,0AAh,0CCh,0CAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CCh,0AAh,0AAh,0CCh
		db	10 dup (0AAh)
		db	0CCh,0AAh,0ACh,0CAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0FFh
		db	10 dup (0AAh)
		db	0FCh,0AAh,0AAh,0AFh,0FAh
		db	9 dup (0AAh)
		db	0FAh
		db	13 dup (0AAh)
		db	0AFh,0FAh
		db	14 dup (0AAh)
		db	0A0h, 00h,0AAh
		db	11 dup (0AAh)
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h,0CCh
		db	12 dup (0AAh)
		db	0CCh,0CCh
		db	12 dup (0AAh)
		db	0FFh,0CAh
		db	11 dup (0AAh)
		db	0AFh,0FFh,0FAh
		db	11 dup (0AAh)
		db	0CCh,0FFh,0FAh
		db	10 dup (0AAh)
		db	0ACh,0FFh,0FFh,0ACh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0CAh,0FFh,0FFh,0AAh,0CAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0CAh,0FFh,0FFh,0AAh,0ACh
		db	10 dup (0AAh)
		db	0, 0
		db	12 dup (0AAh)
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	8 dup (0AAh)
		db	 00h, 00h,0CCh
		db	11 dup (0AAh)
		db	0CCh,0AAh,0CCh,0CAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0ACh,0CAh,0AAh,0AAh,0CCh
		db	9 dup (0AAh)
		db	0CCh,0AAh,0AAh,0AAh,0ACh
		db	8 dup (0AAh)
		db	0FFh,0CAh,0AAh,0AAh,0AAh,0ACh
		db	0CAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0FAh,0FAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0FAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0AAh,0AAh
		db	32 dup (0AAh)
		db	0, 0, 0, 0
data_a_62D0	db	6
		db	6, 6
		db	413 dup (6)
		db	'                                '
		db	'                                '
		db	16 dup (6)
		db	'                                '
		db	'                                '
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'  ffffffffffffffffffffffffffffff'
		db	'ffffffffffffffffffffffffffffffff'
		db	16 dup (6)
		db	'                                '
		db	'                                '
		db	16 dup (6)
		db	'                                '
		db	'                                '
		db	24 dup (6)
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	24 dup (6)
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	17 dup (6)
		db	 04h, 04h,0FFh, 06h, 06h, 06h
		db	 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	16 dup (6)
		db	 04h, 04h, 04h,0FFh, 06h, 06h
		db	 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	15 dup (6)
		db	 42h, 04h, 04h, 04h,0FFh, 06h
		db	 06h, 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	14 dup (6)
		db	 42h, 42h, 04h, 04h, 04h,0FFh
		db	 06h, 06h, 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	0EEh,0EEh,0EEh,0EEh,0EEh, 44h
		db	 44h, 44h, 06h, 06h, 06h, 06h
		db	 06h, 06h, 42h, 42h, 04h, 04h
		db	 04h,0FFh, 06h, 06h, 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOOBBBB'
		db	0EEh
		db	7 dup (6)
		db	 40h, 40h, 42h, 42h, 04h, 04h
		db	 04h,0FFh, 06h, 06h, 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOO'
		db	 00h, 00h, 42h,0EEh, 42h, 06h
		db	 06h, 06h, 44h, 06h, 06h, 06h
		db	 40h, 40h, 42h, 42h, 04h, 04h
		db	 04h,0FFh, 06h, 06h, 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOOf', 0
		db	0EEh, 42h, 42h,0EEh, 06h, 06h
		db	 06h, 06h, 06h, 06h, 40h, 40h
		db	 42h, 42h, 04h, 04h, 04h,0FFh
		db	 06h, 06h, 06h, 06h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOOOOOOOOOOOOOOOOOOff', 0
		db	 42h,0EEh, 42h, 06h, 06h, 06h
		db	 06h, 06h, 06h, 40h, 40h, 42h
		db	 42h, 04h, 06h, 06h,0FFh, 06h
		db	 06h, 06h, 06h
		db	15 dup (4Fh)
		db	4, 4
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOO', 0
		db	'B', 0
		db	0EEh, 42h, 42h,0EEh, 06h, 06h
		db	 44h, 06h, 06h, 40h, 40h, 42h
		db	 42h, 04h, 06h, 06h,0FFh, 06h
		db	 06h, 06h, 06h
		db	15 dup (4Fh)
		db	0CCh,0CCh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOO'
		db	0DDh, 42h,0DDh, 00h, 42h,0EEh
		db	 42h, 42h, 06h, 06h, 06h, 06h
		db	 40h, 40h, 42h, 42h, 06h, 06h
		db	 06h,0FFh, 06h, 06h, 06h, 06h
		db	13 dup (4Fh)
		db	 88h, 88h,0CCh,0CCh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOOB', 0
		db	0DDh, 00h,0EEh, 42h, 42h,0EEh
		db	 06h, 06h, 44h, 06h, 40h, 40h
		db	 42h, 06h, 06h, 06h, 06h,0FFh
		db	 06h, 06h, 06h, 06h
		db	13 dup (4Fh)
		db	 88h, 88h, 88h, 88h, 88h, 4Fh
		db	 4Fh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOB', 0
		db	 42h, 00h, 00h, 42h,0EEh, 42h
		db	 42h
		db	10 dup (22h)
		db	0FFh, 22h, 22h, 22h, 22h, 4Fh
		db	 4Fh
		db	11 dup (4Fh)
		db	0CCh, 88h, 88h, 88h, 88h
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOOB'
		db	0DDh, 42h, 00h, 00h,0EEh, 42h
		db	 42h,0EEh
		db	 22h, 22h, 44h
		db	7 dup (22h)
		db	0FFh, 22h, 22h, 22h, 22h, 4Fh
		db	 4Fh
		db	11 dup (4Fh)
		db	0CCh, 88h, 88h, 88h,0CCh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOOOO'
		db	0FFh,0DDh, 00h, 00h,0DDh, 00h
		db	0FFh, 4Fh,0FFh,0FFh
		db	22h
		db	8 dup (22h)
		db	0FFh, 22h, 22h, 22h, 22h, 4Fh
		db	 4Fh
		db	10 dup (4Fh)
		db	0FFh, 60h, 42h, 8Ch, 60h, 60h
		db	0FFh,0FFh
		db	 4Fh, 4Fh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OO'
		db	0FFh,0DDh, 00h,0DDh,0DDh, 00h
		db	 4Fh,0FFh,0FFh
		db	'O""@""""""'
		db	0FFh, 22h, 22h, 22h, 22h
		db	12 dup (4Fh)
		db	0FFh,0FFh, 60h, 8Ch,0C8h, 42h
		db	0FFh,0FFh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOO'
		db	0FFh,0FFh, 00h,0DDh,0FFh, 00h
		db	 00h,0FFh, 4Fh,0FFh,0FFh
		db	22h
		db	7 dup (22h)
		db	0FFh, 22h, 22h, 22h, 22h, 4Fh
		db	 4Fh
		db	10 dup (4Fh)
		db	0FFh, 60h,0FFh, 42h, 42h,0FFh
		db	 60h,0FFh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOO'
		db	0FFh, 00h, 40h, 40h,0DDh,0FFh
		db	 00h, 4Fh,0FFh,0FFh
		db	'O""@"""""'
		db	0FFh, 22h, 22h, 22h, 22h, 4Fh
		db	 4Fh
		db	10 dup (4Fh)
		db	0FFh, 60h,0FFh,0FFh,0FFh,0FFh
		db	 60h,0FFh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOO'
		db	0FFh, 00h,0DDh, 40h,0FFh,0DDh
		db	 00h,0DDh,0FFh, 4Fh,0FFh
		db	4Fh
		db	7 dup (22h)
		db	0FFh, 22h, 22h, 22h, 22h, 4Fh
		db	 4Fh
		db	10 dup (4Fh)
		db	0FFh, 60h,0FFh,0FFh,0FFh,0FFh
		db	 60h,0FFh
		db	'OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
		db	'OOOO'
		db	0FFh, 00h,0DDh,0DDh,0FFh,0FFh
		db	0FFh,0DDh, 4Fh,0FFh,0FFh
		db	'O""@""""'
		db	0FFh, 22h, 22h, 2Fh,0FFh,0FEh
		db	11 dup (22h)
		db	0FFh, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""', 0
		db	0FFh,0FFh,0FFh,0FFh, 40h,0FFh
		db	0DDh, 00h,0FFh, 4Fh,0FFh,0FFh
		db	 22h, 22h, 22h, 22h, 22h, 22h
		db	0FFh, 22h, 22h, 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""', 0
		db	0FFh,0FFh,0DDh, 40h,0DDh, 40h
		db	0FFh, 00h, 4Fh,0FFh,0FFh, 4Fh
		db	 22h, 22h, 40h, 22h, 22h, 22h
		db	0FFh, 22h, 22h, 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""', 0
		db	0FFh,0FFh,0DDh, 40h,0DDh,0FFh
		db	 40h, 00h, 00h,0FFh, 4Fh,0FFh
		db	0FFh, 22h, 22h, 22h, 22h, 22h
		db	0FFh, 22h, 22h, 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""'
		db	0FFh,0FFh, 20h,0DDh,0DDh, 40h
		db	0FFh, 00h, 00h, 00h, 4Fh,0FFh
		db	0FFh, 4Fh, 22h, 22h, 40h, 22h
		db	 22h,0FFh, 22h, 2Fh,0FFh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""   '
		db	0DDh,0DDh, 00h,0FFh, 00h, 00h
		db	0FFh, 00h,0FFh, 4Fh,0FFh, 4Fh
		db	 22h, 22h, 22h, 22h,0FFh, 22h
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""""""""""'
		db	0DDh, 20h,0FFh,0DDh,0FFh,0FFh
		db	 00h,0DDh,0DDh,0FFh,0DDh, 4Fh
		db	0FFh,0FFh, 4Fh, 22h, 22h, 40h
		db	 22h,0FFh, 22h, 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""""""""""'
		db	0DDh, 20h,0FFh, 20h,0DDh,0FFh
		db	 00h,0DDh,0DDh,0FFh,0FFh, 00h
		db	0FFh, 4Fh,0FFh, 4Fh, 22h, 22h
		db	 22h,0FFh, 22h, 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""""""""""'
		db	0DDh,0FFh, 22h,0FFh,0DDh,0DDh
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	 4Fh,0FFh,0FFh, 4Fh, 22h, 22h
		db	 40h,0FFh,0FFh,0FFh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""""""""""'
		db	0F6h, 62h, 2Fh,0FFh,0FFh, 00h
		db	0DDh,0D4h,0FFh, 00h, 00h,0FFh
		db	 00h, 4Fh,0FFh,0FFh, 4Fh, 22h
		db	 22h,0FFh,0FFh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""'
		db	0F6h, 6Dh,0DFh,0FFh,0FFh, 00h
		db	0DDh, 40h,0FFh,0FDh,0DDh,0DFh
		db	0F0h, 0Eh,0EFh,0FFh,0FEh,0E2h
		db	 22h,0F4h, 4Fh,0F2h
		db	'"""""""""""""""""""""""""""""""'
		db	27 dup (22h)
		db	 2Dh,0DFh,0FFh,0FFh,0DDh, 00h
		db	 00h, 00h, 60h,0DDh,0DDh,0FFh
		db	 00h, 00h,0FFh, 4Fh,0FFh,0FFh
		db	 22h,0FFh,0FFh
		db	22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""""""""""""""'
		db	0FFh,0DDh, 00h, 00h,0DDh, 60h
		db	 60h,0FFh,0FFh,0FFh,0F0h, 0Eh
		db	0EFh,0FFh,0FEh,0E2h
		db	22h
		db	'$'
		db	'@B""""""""""""""""""""""""""""""'
		db	'"'
		db	28 dup (22h)
		db	0FFh,0FFh, 00h, 00h, 00h,0DDh
		db	 60h, 40h,0DDh,0DDh, 00h, 00h
		db	 00h,0FFh, 4Fh,0FFh,0FFh,0FFh
		db	22h
		db	'$'
		db	'B"""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""""""""""""'
		db	0FFh,0DDh,0DDh, 00h, 40h, 40h
		db	0FFh, 60h, 00h, 60h,0FFh, 00h
		db	 0Eh,0E0h, 00h,0FFh,0FFh,0FEh
		db	0EFh,0F2h
		db	'$'
		db	'B"""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""'
		db	0FFh,0FFh,0DDh, 20h,0DDh,0DDh
		db	 40h,0DDh,0FFh,0DDh,0FFh,0DDh
		db	0DDh, 00h, 00h,0DDh, 4Fh,0FFh
		db	0FFh,0FEh,0E2h
		db	24h
		db	'B"""""""""""""""""""""""""""""""'
		db	'""""'
		db	22 dup (22h)
		db	0DDh,0DFh,0DDh,0DDh,0FFh, 40h
		db	 40h, 40h, 60h,0DDh,0FFh,0FDh
		db	0DDh,0D0h, 00h,0DDh, 4Fh,0FFh
		db	0FFh,0FEh,0E2h
		db	24h
		db	'B"""""""""""""""""""""""""""""""'
		db	'""""'
		db	22 dup (22h)
		db	0FFh, 40h, 40h, 00h,0FFh, 00h
		db	 00h,0FFh, 4Fh, 4Fh, 4Fh, 00h
		db	0DDh, 00h,0DDh,0DDh, 04h,0FFh
		db	 4Fh,0FFh, 4Fh,0E2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""'
		db	0FFh, 40h,0DDh,0DDh,0FFh,0DDh
		db	0DDh,0FFh, 4Fh, 4Fh,0DDh, 00h
		db	 04h, 00h,0DDh,0DDh, 04h, 4Fh
		db	0FFh,0FEh,0E2h
		db	22h
		db	7 dup (22h)
		db	2Fh
		db	50 dup (0FFh)
		db	 40h, 40h, 00h,0FFh, 22h,0DDh
		db	0DDh,0FFh, 4Fh,0FFh, 00h,0DDh
		db	 00h, 00h, 00h,0FFh, 04h, 04h
		db	 4Fh,0FFh,0F2h
		db	8 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""'
		db	0DDh,0FFh, 00h,0DDh,0DDh, 22h
		db	0FFh,0FFh,0DDh,0DDh, 00h, 4Fh
		db	 04h, 04h,0FFh, 04h, 04h, 04h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""'
		db	0DDh,0DDh,0DDh,0FFh,0DDh,0DDh
		db	0FFh, 00h,0FFh, 00h, 00h, 4Fh
		db	 00h,0DDh,0DDh, 04h, 04h, 04h
		db	22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""'
		db	0DDh,0DDh,0DDh,0FFh,0DDh,0DDh
		db	0FFh, 00h,0FFh, 00h, 00h, 4Fh
		db	 00h,0DDh,0DDh, 04h, 04h, 04h
		db	22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""@'
		db	0DDh,0DDh,0FFh, 22h, 22h, 00h
		db	 00h,0FFh, 00h, 00h,0FFh,0DDh
		db	0DDh,0FFh, 04h, 04h, 04h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""@'
		db	0DDh,0FFh,0FFh, 22h,0FFh, 00h
		db	0DDh, 4Fh, 00h, 4Fh,0FFh, 04h
		db	0FFh,0FFh, 04h, 04h, 04h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""'
		db	0EEh,0EEh,0FFh,0FFh,0FFh,0FFh
		db	0DDh,0DDh, 00h, 00h,0DDh,0FFh
		db	 04h,0DDh, 04h, 04h, 04h
		db	22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""'
		db	0EEh,0EEh, 04h, 04h, 04h, 60h
		db	 60h, 60h, 00h, 00h,0FFh,0FFh
		db	 04h,0FFh, 04h, 04h, 04h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""'
		db	0EEh,0DDh,0DDh,0FFh,0FFh,0FFh
		db	 60h, 60h,0DDh,0DDh,0FFh, 00h
		db	 00h,0FFh, 04h, 04h, 04h
		db	22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""'
		db	 00h, 00h,0DDh,0FFh,0FFh,0FFh
		db	 60h, 00h,0DDh,0DDh, 22h, 00h
		db	0DDh, 04h, 04h, 04h
		db	22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""', 0
		db	0DDh,0DDh,0FFh, 60h,0DDh,0FFh
		db	 00h, 22h, 22h, 22h, 00h,0DDh
		db	 04h, 04h, 04h
		db	22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""', 0
		db	'OO'
		db	0FFh,0DDh,0FFh,0FFh, 00h, 00h
		db	 00h, 22h,0DDh,0DDh, 04h, 04h
		db	 04h
		db	22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""'
		db	0FFh,0DDh,0EEh,0DDh,0FFh,0FFh
		db	 00h, 00h, 00h,0DDh,0FFh,0FFh
		db	0FFh, 04h, 04h, 04h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""'
		db	0FFh,0DDh,0DDh,0FFh,0FFh,0FFh
		db	0DDh,0DDh,0DDh,0DDh,0FFh,0DDh
		db	0FFh,0DDh, 04h, 04h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""'
		db	0FFh,0FFh,0FFh,0EEh,0EEh,0FFh
		db	0DDh,0DDh,0DDh, 04h, 04h,0DDh
		db	 04h, 04h, 04h
		db	22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""'
		db	0FFh,0FFh,0FFh,0EEh,0DDh, 00h
		db	0DDh,0D4h, 40h, 04h,0DDh, 40h
		db	 04h, 04h, 04h
		db	22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""'
		db	0FFh,0FFh, 60h,0DDh,0DDh, 00h
		db	0FFh,0FFh, 40h, 04h,0DDh,0FFh
		db	 04h, 04h, 04h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""'
		db	0DDh,0FFh, 60h, 60h,0DDh,0DDh
		db	0DDh,0FFh, 40h,0DDh,0DDh,0FFh
		db	 04h, 04h, 04h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""'
		db	0DDh, 60h, 60h, 60h, 00h, 00h
		db	0DDh,0DDh,0FFh,0FFh, 40h, 04h
		db	 04h, 04h
		db	22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""'
		db	0DDh,0EEh, 60h,0DDh, 00h,0DDh
		db	0DDh,0FFh,0FFh,0DDh, 40h, 04h
		db	 04h, 04h
		db	22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	8 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""'
		db	0DDh,0EEh,0FFh,0FFh, 00h, 00h
		db	0DDh,0FFh, 04h,0DDh,0FFh, 04h
		db	 04h, 04h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""'
		db	0EEh,0EEh,0FFh,0FFh,0DDh,0DDh
		db	0FFh,0FFh, 04h,0DDh,0FFh, 04h
		db	 04h, 04h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""'
data_a_80D0	db	0FFh
		db	0FFh,0FFh, 00h, 00h,0DDh,0FFh
		db	0FFh, 04h,0FFh, 04h, 04h, 04h
		db	12 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""'
		db	0DDh,0FFh,0FFh, 0Dh,0DDh,0DDh
		db	 22h,0FFh,0EEh,0EEh, 04h, 04h
		db	 04h
		db	22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	45 dup (0FFh)
		db	 20h, 00h, 0Dh,0DDh, 22h,0DDh
		db	 22h,0EEh,0DDh, 04h, 04h, 04h
		db	22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""/  ', 0
		db	' """'
		db	0DDh,0DDh, 04h, 04h, 04h, 04h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/  ', 0
		db	' ""B '
		db	0FFh, 04h, 04h, 04h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/'
		db	0DDh, 00h, 00h,0DDh,0DDh, 22h
		db	 7Dh,0DDh,0FFh, 04h, 04h, 04h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/'
		db	0DDh, 00h,0FFh,0FFh,0DDh, 22h
		db	 7Dh,0DDh,0DDh,0DDh, 04h, 04h
		db	12 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/ ', 0
		db	0FDh,0DDh, 42h,0FFh,0DDh,0FFh
		db	0FFh, 04h, 04h, 04h
		db	12 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/', 0
		db	0EEh,0EEh,0DDh,0DDh,0FFh,0DDh
		db	0FFh, 04h, 04h, 04h
		db	13 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/', 0
		db	0EEh,0EEh,0FFh,0FFh,0FFh, 60h
		db	 60h, 04h, 04h, 04h
		db	22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""/', 0
		db	0EEh,0DDh,0FFh,0FFh,0FFh, 60h
		db	 60h, 60h, 04h, 04h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/', 0
		db	0DDh,0DDh,0FFh,0FFh, 55h,0DDh
		db	0DDh, 04h, 04h
		db	13 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/'
		db	0DDh,0DDh, 42h,0FFh,0DDh,0DDh
		db	0DDh, 04h, 04h, 04h
		db	13 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/', 0
		db	0DDh, 42h,0FFh, 55h, 55h, 55h
		db	 04h, 04h, 04h
		db	22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/'
		db	0DDh,0DDh,0EEh,0EEh,0DDh, 55h
		db	 55h, 04h, 04h, 04h
		db	22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/'
		db	0DDh,0FFh,0FFh,0DDh,0DDh,0DDh
		db	 55h, 04h, 04h
		db	13 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/'
		db	0FFh,0FFh,0DDh,0DDh,0EEh,0FFh
		db	 04h, 04h, 04h
		db	22h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""/'
		db	0DDh, 20h, 20h,0DDh, 04h,0FFh
		db	 04h, 04h, 04h
		db	22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""/"'
		db	0DDh,0DDh,0FFh,0EEh,0EEh, 04h
		db	 04h, 04h
		db	22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""/""'
		db	0DDh, 22h,0DDh,0EEh, 04h, 04h
		db	14 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""/  '
		db	0DDh,0DDh,0DDh, 04h, 04h, 04h
		db	 22h, 22h, 22h, 22h, 22h, 22h
		db	66 dup (0FFh)
		db	 20h,0DDh, 22h,0FFh,0FFh, 04h
		db	 04h, 04h, 22h, 22h, 22h, 22h
		db	 22h, 22h,0FFh,0FFh
		db	 77h, 77h
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	0DDh,0DDh,0FFh, 22h,0DDh, 04h
		db	 04h, 04h, 22h, 22h, 22h, 22h
		db	 22h, 22h,0FFh,0FFh
		db	22h
		db	'r', 27h, '"r', 27h, 'rr', 27h, '"'
		db	'r', 27h, '"r', 27h, '"rw"r', 27h
		db	'"r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"'
		db	0DDh,0DDh,0FFh, 22h,0DDh, 04h
		db	 04h, 04h, 22h, 22h, 22h, 22h
		db	 22h, 22h,0FFh,0FFh
		db	22h
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'@@'
		db	0FFh,0FFh, 04h, 04h, 04h
		db	7 dup (22h)
		db	0FFh,0FFh, 77h, 77h
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	0DDh,0DDh,0DDh,0FFh, 04h, 04h
		db	 04h, 22h, 22h, 22h, 22h, 22h
		db	 22h, 22h,0FFh,0FFh
		db	22h
		db	'r', 27h, '"rw"r', 27h, '"r', 27h
		db	'"r', 27h, '"ww"r', 27h, '"r', 27h
		db	'"r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"'
		db	0DDh, 40h,0FFh,0FFh, 04h, 04h
		db	 04h
		db	7 dup (22h)
		db	0FFh,0FFh, 22h
		db	'r', 27h, '"rw"r', 27h, '"r', 27h
		db	'"r', 27h, '"ww"r', 27h, '"r', 27h
		db	'"r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"'
		db	0DDh, 40h,0DDh,0DDh, 04h, 04h
		db	 04h, 22h, 22h, 22h, 22h, 22h
		db	 22h, 22h,0FFh,0FFh
		db	 77h, 77h
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwww@@'
		db	0FFh, 04h, 04h, 04h
		db	8 dup (22h)
		db	0FFh,0FFh, 22h
		db	'r', 27h, '"ww"r', 27h, '"r', 27h
		db	'"r', 27h, '"w', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"'
		db	0FFh,0DDh,0DDh, 04h, 04h, 04h
		db	 22h
		db	7 dup (22h)
		db	0FFh,0FFh, 22h
		db	'r', 27h, '"ww"r', 27h, '"r', 27h
		db	'"r', 27h, '"w', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"r', 27h, '"'
		db	'r', 27h, '"r', 27h, '"'
		db	0FFh,0FFh,0DDh, 04h, 04h, 04h
		db	 22h
		db	7 dup (22h)
		db	0FFh,0FFh, 77h, 77h
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwww@'
		db	0FFh,0DDh, 04h, 04h, 04h, 22h
		db	7 dup (22h)
		db	0FFh,0FFh, 77h, 77h
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	'wwwwwwwwwwwwwwwwwwwwwwwwwwwwww'
		db	0FFh,0DDh, 04h, 04h, 04h, 22h
		db	14 dup (22h)
		db	0FFh, 22h
		db	9 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/'
		db	0FFh,0DDh, 04h, 04h, 04h, 22h
		db	13 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/``'
		db	 04h, 04h, 04h, 22h
		db	13 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/`'
		db	0DDh,0DDh, 04h, 04h
		db	14 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/U'
		db	 04h, 04h, 04h, 22h
		db	14 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/'
		db	0FFh, 04h, 04h, 04h
		db	15 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/'
		db	0FFh, 04h, 04h, 04h
		db	15 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""/'
		db	0FFh, 04h, 04h, 04h
		db	14 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	 04h, 04h, 04h, 22h
		db	14 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	 04h, 04h, 04h, 22h
		db	14 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	 04h, 04h, 04h, 22h
		db	14 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	 04h, 04h, 04h, 22h
		db	14 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	4, 4
		db	15 dup (22h)
		db	 2Fh,0F2h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	4, 4
		db	15 dup (22h)
		db	 2Fh,0F2h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""/'
		db	4, 4
		db	15 dup (22h)
		db	 2Fh,0F2h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/'
		db	4, 4
		db	15 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/'
		db	 04h, 22h
		db	15 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/'
		db	 04h, 22h
		db	15 dup (22h)
		db	0FFh, 22h
		db	10 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/'
		db	 04h, 22h
		db	14 dup (22h)
		db	 2Fh,0F2h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/'
		db	 04h, 22h
		db	14 dup (22h)
		db	 2Fh,0F2h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/"""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""/"""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""/""""""""""""""'
		db	'""'
		db	0FFh, 22h
		db	10 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""/""""""""""""""'
		db	'"/'
		db	0F2h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""/""""""""""""""'
		db	'"/'
		db	0F2h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""/""""""""""""""'
		db	'"/'
		db	0F2h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""/""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'"""""""""""""""""/""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	52 dup (0FFh)
		db	15 dup (22h)
		db	0FFh, 22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"/'
		db	0F2h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	0FFh, 22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	0FFh, 22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'"'
		db	0FFh, 22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	0FFh, 22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	0FFh, 22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	0FFh, 22h
		db	11 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'/'
		db	0F2h
		db	12 dup (22h)
		db	 2Fh,0F2h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	0FFh, 22h
		db	12 dup (22h)
		db	0FFh, 22h
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	70 dup (0FFh)
data_a_9C00	db	22h			; Data table (indexed access)
		db	1231 dup (22h)
data_a_A0D0	db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	'""""""""""""""""""""""""""""""""'
		db	16272 dup (0)
data_a_E0E0	db	0
		db	1391 dup (0)

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_a , ss:stack_seg_c


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


TENNIS		proc	far

start:
		cli				; Disable interrupts
		push	ds
		mov	ax,0
		push	ax
		mov	ax,seg_a
		mov	ds,ax
		call	sub_b_1798
		call	sub_b_1AC0
		call	sub_b_1110
		mov	data_a_0058,1
		sti				; Enable interrupts
		call	sub_b_2680
loc_b_001D:
		call	sub_b_26E0
loc_b_0020:
		mov	data_a_0003,0
		cmp	data_a_0058,0
		je	loc_b_0037		; Jump if equal
		mov	data_a_0058,0
		call	sub_b_29B0
		jmp	short loc_b_0071
		db	90h
loc_b_0037:
		call	sub_b_2AF4
		mov	si,offset data_a_0B95
		mov	word ptr [si+4],5D0Eh
		mov	word ptr [si],10h
		mov	word ptr [si+2],7Bh
		mov	word ptr [si+0Ah],0BAAh
		call	sub_b_1B34
		mov	si,offset data_a_0B95
		mov	word ptr [si],1Ch
		mov	word ptr [si+2],5Bh
		mov	word ptr [si+0Ah],0C52h
		call	sub_b_1B34
		cmp	data_a_0011,0FFh
		je	loc_b_0071		; Jump if equal
		call	sub_b_2552
loc_b_0071:
		call	sub_b_0195
		call	sub_b_237C
		mov	data_a_0053,100h
		call	sub_b_1109
loc_b_0080:
		call	sub_b_0946
		call	sub_b_0403
loc_b_0086:
		call	sub_b_0FAC
		test	data_a_0000,10h
		jnz	loc_b_0093		; Jump if not zero
		jmp	loc_b_012A
loc_b_0093:
		cmp	data_a_0006,2
		je	loc_b_00BA		; Jump if equal
		mov	al,data_a_000C
		mov	ah,0
		mov	data_a_002F,ax
		call	sub_b_1C80
		cmp	data_a_0006,1
		je	loc_b_00E2		; Jump if equal
		mov	al,data_a_000B
		mov	ah,0
		mov	data_a_002F,ax
		call	sub_b_1C80
		jmp	short loc_b_010A
		db	90h
loc_b_00BA:
		mov	data_a_000D,2
		mov	al,data_a_000C
		mov	ah,0
		mov	data_a_002F,ax
		mov	si,offset data_a_0059
		add	si,data_a_002F
		test	byte ptr [si],8
		jz	loc_b_00DC		; Jump if zero
		call	sub_b_0922
;*		call	sub_b_17D0		;*
		db	0E8h,0F7h, 16h		;  Fixup - byte match
		jmp	short loc_b_00DF
		db	90h
loc_b_00DC:
		call	sub_b_08B4
loc_b_00DF:
		call	sub_b_048F
loc_b_00E2:
		mov	data_a_000D,1
		mov	al,data_a_000B
		mov	ah,0
		mov	data_a_002F,ax
		mov	si,offset data_a_0059
		add	si,data_a_002F
		test	byte ptr [si],8
		jz	loc_b_0104		; Jump if zero
		call	sub_b_0922
;*		call	sub_b_17D0		;*
		db	0E8h,0CFh, 16h		;  Fixup - byte match
		jmp	short loc_b_0107
		db	90h
loc_b_0104:
		call	sub_b_08B4
loc_b_0107:
		call	sub_b_048F
loc_b_010A:
		call	sub_b_143F
		call	sub_b_0317
		call	sub_b_10B0
		cmp	ah,1
		jne	loc_b_011B		; Jump if not equal
		jmp	loc_b_001D
loc_b_011B:
		call	sub_b_12DD
		mov	ax,data_a_0037
		mov	data_a_0053,ax
		call	sub_b_1109
		jmp	loc_b_0086
loc_b_012A:
		mov	bx,74Bh
		mov	byte ptr [bx+4],0
		mov	bx,755h
		mov	byte ptr [bx+4],0
		call	sub_b_0317
		call	sub_b_2160
		mov	data_a_0053,0FFFFh
		call	sub_b_1109
		test	data_a_0000,80h
		jnz	loc_b_0151		; Jump if not zero
		call	sub_b_0403
loc_b_0151:
		test	data_a_0000,1
		jnz	loc_b_015B		; Jump if not zero
		jmp	loc_b_0080
loc_b_015B:
		mov	si,91Ch
		mov	dh,18h
		mov	dl,0Eh
		mov	bl,82h
		call	sub_b_2621
		mov	data_a_0953,0
		mov	cx,100h

locloop_b_016F:
		push	cx
		mov	data_a_0053,0FFFh
		call	sub_b_1109
		call	sub_b_0FAC
		mov	data_a_000D,1
		call	sub_b_0FCD
		cmp	data_a_0003,1
		je	loc_b_0191		; Jump if equal
		pop	cx
		loop	locloop_b_016F		; Loop if cx > 0

		jmp	loc_b_001D
loc_b_0191:
		pop	cx
		jmp	loc_b_0020

TENNIS		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0195	proc	near
		mov	data_a_0000,18h
		mov	si,offset data_a_0059
		mov	word ptr [si],0
		mov	data_a_002F,0
		mov	data_a_000B,0
		mov	data_a_000C,1
		mov	data_a_0011,0FFh
		mov	data_a_0010,33h		; '3'
		cmp	data_a_0007,0
		jne	loc_b_01D1		; Jump if not equal
		mov	data_a_000A,4
		mov	al,3
		mov	data_a_0008,1
		jmp	short loc_b_01F3
		db	90h
loc_b_01D1:
		cmp	data_a_0007,1
		jne	loc_b_01E7		; Jump if not equal
		mov	data_a_000A,4
		mov	al,4
		mov	data_a_0008,2
		jmp	short loc_b_01F3
		db	90h
loc_b_01E7:
		mov	data_a_000A,6
		mov	al,5
		mov	data_a_0008,3
loc_b_01F3:
		mov	ch,0
		mov	cl,data_a_000A
		shr	cx,1			; Shift w/zeros fill
		mov	data_a_0039,cx
		mov	data_a_003B,cx
		sub	cx,1
		add	data_a_003B,cx
		mov	data_a_0009,al
		push	si
		mov	si,offset data_a_0087
		mov	di,offset data_a_009C
		mov	al,data_a_000A
		mov	ah,0
		add	ax,6
		mov	[si+0Dh],ax
		mov	[di+0Dh],ax
		mov	si,offset data_a_00B1
		mov	di,offset data_a_00C6
		mov	al,data_a_000A
		mov	ah,0
		add	ax,6
		mov	[si+0Dh],ax
		mov	[di+0Dh],ax
		mov	al,data_a_000A
		mov	ah,0
		shl	ax,1			; Shift w/zeros fill
		add	ax,10h
		add	ax,1Ch
		shr	ax,1			; Shift w/zeros fill
		mov	[si+11h],ax
		mov	[di+11h],ax
		mov	si,offset data_a_0087
		mov	di,offset data_a_009C
		mov	[si+11h],ax
		mov	[di+11h],ax
		pop	si
		mov	data_a_0037,1
		mov	data_a_0035,4
		mov	byte ptr data_a_002C+1,0
		mov	word ptr [si+4],202h
		mov	al,data_a_0009
		mov	[si+2],al
		mov	[si+3],al
		mov	al,byte ptr data_a_0035
		mov	[si+6],al
		mov	[si+7],al
		mov	byte ptr [si+8],1
		mov	byte ptr [si+9],1
		mov	word ptr [si+0Ch],0
		mov	word ptr [si+0Ah],0
		mov	word ptr [si+0Eh],0
		mov	word ptr [si+10h],0
		mov	word ptr [si+12h],0
		mov	data_a_0033,2
		mov	data_a_0031,0
		mov	data_a_000E,1
		mov	bx,offset data_a_0087
		mov	word ptr [bx],0A8h
		mov	word ptr [bx+2],9Eh
		mov	bx,offset data_a_009C
		mov	word ptr [bx],0A8h
		mov	word ptr [bx+2],0ADh
		mov	bx,offset data_a_00B1
		mov	word ptr [bx],60h
		mov	word ptr [bx+2],2Ch
		mov	bx,offset data_a_00C6
		mov	word ptr [bx],60h
		mov	word ptr [bx+2],3Bh
		mov	si,offset data_a_0B95
		mov	word ptr [si],10h
		mov	word ptr [si+2],7Bh
		mov	word ptr [si+0Ah],0BAAh
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		mov	si,offset data_a_0B95
		mov	word ptr [si],1Ch
		mov	word ptr [si+2],5Bh
		mov	word ptr [si+0Ah],0C52h
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		retn
sub_b_0195	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0317	proc	near
		push	si
		push	di
		mov	si,offset data_a_0087
		cmp	byte ptr [si+0Ch],0
		jne	loc_b_0328		; Jump if not equal
		call	sub_b_03DC
		jmp	loc_b_03D9
loc_b_0328:
		mov	si,offset data_a_00B1
		call	sub_b_1ADB
		mov	si,offset data_a_00C6
		call	sub_b_1ADB
		mov	si,offset data_a_00B1
		mov	di,seg seg_a
		mov	es,di
		mov	bx,[si]
		mov	cx,bx
		mov	dx,74h
		call	sub_b_1B70
		mov	di,si
		add	di,62D0h
		mov	si,offset data_a_0774
		mov	cx,7
		call	sub_b_2ACC
		mov	dx,72h
		mov	cx,4

locloop_b_035B:
		push	cx
		mov	cx,bx
		add	dx,3
		call	sub_b_1B70
		mov	di,si
		add	di,62D0h
		mov	si,offset data_a_0782
		mov	cx,7
		call	sub_b_2ACC
		pop	cx
		loop	locloop_b_035B		; Loop if cx > 0

		mov	si,offset data_a_0087
		call	sub_b_1ADB
		mov	si,offset data_a_009C
		call	sub_b_1ADB
		call	sub_b_1C1F
		mov	si,offset data_a_00B1
		call	sub_b_1B8B
		mov	si,offset data_a_00C6
		call	sub_b_1B8B
		mov	si,offset data_a_0087
		call	sub_b_1B8B
		mov	si,offset data_a_009C
		call	sub_b_1B8B
		call	sub_b_1BD3
		mov	si,offset data_a_0755
		mov	di,offset data_a_075A
		mov	ax,[si]
		mov	[di],ax
		mov	ax,[si+2]
		mov	[di+2],ax
		mov	si,offset data_a_074B
		mov	di,offset data_a_0750
		mov	ax,[si]
		mov	[di],ax
		mov	ax,[si+2]
		mov	[di+2],ax
		mov	di,offset data_a_0790
		add	di,8
loc_b_03C6:
		dec	di
		dec	di
		push	di
		mov	si,[di]
		mov	byte ptr [si+0Ch],0
		call	sub_b_1B34
		pop	di
		cmp	di,790h
		jne	loc_b_03C6		; Jump if not equal
loc_b_03D9:
		pop	di
		pop	si
		retn
sub_b_0317	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_03DC	proc	near
		call	sub_b_1C1F
		call	sub_b_1BD3
		mov	si,offset data_a_0755
		mov	di,offset data_a_075A
		mov	ax,[si]
		mov	[di],ax
		mov	ax,[si+2]
		mov	[di+2],ax
		mov	si,offset data_a_074B
		mov	di,offset data_a_0750
		mov	ax,[si]
		mov	[di],ax
		mov	ax,[si+2]
		mov	[di+2],ax
		retn
sub_b_03DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0403	proc	near
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_a_80D0
		mov	di,d_B800_1E00_e
		mov	cx,0A0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	si,offset data_a_A0D0	; ('""""""""""""""""""""""""')
		mov	di,d_B800_3E00_e
		mov	cx,0A0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		retn
sub_b_0403	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0421	proc	near
		push	ds
		push	es
		push	si
		mov	ax,0B800h
		mov	es,ax
		mov	ds,ax
		mov	si,d_B800_1E04_e
		mov	di,d_B800_1E02_e
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,4
		add	di,4
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,4
		add	di,4
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,4
		add	di,4
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	si,d_B800_3E04_e
		mov	di,d_B800_3E02_e
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,4
		add	di,4
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,4
		add	di,4
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,4
		add	di,4
		mov	cx,26h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	si
		pop	es
		inc	si
		pop	ds
		retn
sub_b_0421	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0488	proc	near
;*		lea	bx,cs:[564h]		; Load effective addr
		db	 8Dh, 1Eh, 64h, 05h	;  Fixup - byte match
		jmp	short loc_b_0493
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_048F:
;*		lea	bx,cs:[4D6h]		; Load effective addr
		db	 8Dh, 1Eh,0D6h, 04h	;  Fixup - byte match
loc_b_0493:
		mov	si,offset data_a_0059
		add	si,data_a_002F
		mov	di,si
		add	di,data_a_002F
		dec	byte ptr [si+2]
		jz	loc_b_04A8		; Jump if zero
		jmp	loc_b_07E6
loc_b_04A8:
		mov	al,data_a_0009
		mov	[si+2],al
		test	data_a_0000,20h		; ' '
		jz	loc_b_04C1		; Jump if zero
		dec	byte ptr [si+4]
		jz	loc_b_04BD		; Jump if zero
		jmp	loc_b_07E6
loc_b_04BD:
		mov	byte ptr [si+4],2
loc_b_04C1:
		cmp	data_a_002F,0
		jne	loc_b_04D1		; Jump if not equal
		push	bx
		mov	bx,87h
		mov	byte ptr [bx+0Ch],1
		pop	bx
loc_b_04D1:
		call	sub_b_0FCD
		jmp	bx			;*Register jump
loc_b_04D6:
		cmp	data_a_002F,0
		jne	loc_b_04E4		; Jump if not equal
		inc	byte ptr data_a_002C+1
		jmp	short loc_b_04F3
		db	90h
loc_b_04E4:
		cmp	byte ptr data_a_002C+1,3
		jne	loc_b_04F3		; Jump if not equal
		mov	byte ptr data_a_002C+1,0
		jmp	loc_b_07E6
loc_b_04F3:
		mov	cl,0
		cmp	data_a_0002,0FFh
		jne	loc_b_0503		; Jump if not equal
		dec	cl
		dec	cl
		jmp	short loc_b_050E
		db	90h
loc_b_0503:
		cmp	data_a_0002,1
		jne	loc_b_056B		; Jump if not equal
		inc	cl
		inc	cl
loc_b_050E:
		cmp	data_a_002F,0
		jne	loc_b_051B		; Jump if not equal
		mov	bx,9Ch
		jmp	short loc_b_051E
			                        ;* No entry point to code
		nop
loc_b_051B:
		mov	bx,offset data_a_00C6
loc_b_051E:
		mov	dx,[bx+2]
		mov	al,cl
		cbw				; Convrt byte to word
		add	dx,ax
		push	di
		mov	di,offset data_a_0835
		add	di,data_a_002F
		add	di,data_a_002F
		test	data_a_0000,4
		jz	loc_b_054F		; Jump if zero
		mov	ax,data_a_0031
		cmp	ax,data_a_002F
		je	loc_b_054F		; Jump if equal
		cmp	dx,[di+20h]
		js	loc_b_055C		; Jump if sign=1
		cmp	dx,[di+24h]
		jns	loc_b_055C		; Jump if not sign
		jmp	short loc_b_0560
		db	90h
loc_b_054F:
		cmp	dx,[di+18h]
		js	loc_b_055C		; Jump if sign=1
		cmp	dx,[di+1Ch]
		jns	loc_b_055C		; Jump if not sign
		jmp	short loc_b_0560
		db	90h
loc_b_055C:
		pop	di
		jmp	short loc_b_0564
		db	90h
loc_b_0560:
		pop	di
		jmp	short loc_b_056B
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_0564:
loc_b_0564:
		mov	data_a_0002,0
		mov	cl,0
loc_b_056B:
		mov	al,cl
		cmp	data_a_002F,0
		jne	loc_b_0576		; Jump if not equal
		neg	al
loc_b_0576:
		cmp	al,0
		jne	loc_b_057F		; Jump if not equal
		mov	al,1
		jmp	short loc_b_0588
		db	90h
loc_b_057F:
		jns	loc_b_0586		; Jump if not sign
		mov	al,0
		jmp	short loc_b_0588
		db	90h
loc_b_0586:
		mov	al,2
loc_b_0588:
		mov	[si+0Ch],al
		cmp	byte ptr [si+0Ah],0
		je	loc_b_059D		; Jump if equal
		dec	byte ptr [si+8]
		jz	loc_b_0599		; Jump if zero
		jmp	loc_b_07E6
loc_b_0599:
		mov	byte ptr [si+8],1
loc_b_059D:
		mov	ch,0
		cmp	data_a_0001,1
		jne	loc_b_05AD		; Jump if not equal
		mov	ch,data_a_000A
		jmp	short loc_b_05BD
		db	90h
loc_b_05AD:
		cmp	data_a_0001,0FFh
		je	loc_b_05B7		; Jump if equal
		jmp	loc_b_0713
loc_b_05B7:
		mov	ch,data_a_000A
		neg	ch
loc_b_05BD:
		cmp	data_a_002F,0
		jne	loc_b_05CA		; Jump if not equal
		mov	bx,9Ch
		jmp	short loc_b_05CD
			                        ;* No entry point to code
		nop
loc_b_05CA:
		mov	bx,offset data_a_00C6
loc_b_05CD:
		mov	dx,[bx]
		cmp	word ptr [bx+4],224Ch
		jne	loc_b_05D9		; Jump if not equal
		add	dx,6
loc_b_05D9:
		cmp	word ptr [bx+4],2AB2h
		jne	loc_b_05E3		; Jump if not equal
		sub	dx,6
loc_b_05E3:
		mov	al,ch
		cbw				; Convrt byte to word
		add	dx,ax
		push	di
		mov	di,offset data_a_0835
		add	di,data_a_002F
		add	di,data_a_002F
		cmp	dx,[di+10h]
		jb	loc_b_0602		; Jump if below
		cmp	dx,[di+14h]
		jae	loc_b_0602		; Jump if above or =
		pop	di
		jmp	short loc_b_0608
		db	90h
loc_b_0602:
		pop	di
		mov	ch,0
		jmp	loc_b_0713
loc_b_0608:
		test	byte ptr [si],8
		jz	loc_b_061A		; Jump if zero
		cmp	data_a_002F,1
		jne	loc_b_0617		; Jump if not equal
		mov	bx,87h
loc_b_0617:
		jmp	loc_b_07FC
loc_b_061A:
		test	byte ptr [si],4
		jz	loc_b_0622		; Jump if zero
		jmp	loc_b_0701
loc_b_0622:
		cmp	ch,0
		jns	loc_b_0636		; Jump if not sign
		jnz	loc_b_062C		; Jump if not zero
		jmp	loc_b_0713
loc_b_062C:
		test	byte ptr [si],2
		mov	al,0
		jz	loc_b_0640		; Jump if zero
		jmp	loc_b_0786
loc_b_0636:
		test	byte ptr [si],2
		mov	al,1
		jnz	loc_b_0640		; Jump if not zero
		jmp	loc_b_0786
loc_b_0640:
		cmp	byte ptr [si+0Ah],8
		jae	loc_b_06A7		; Jump if above or =
		inc	byte ptr [si+0Ah]
		inc	byte ptr [si+0Ah]
		dec	byte ptr [si+24h]
		dec	byte ptr [si+24h]
		jns	loc_b_066A		; Jump if not sign
		cmp	byte ptr [si+0Ah],2
		jne	loc_b_0666		; Jump if not equal
		test	byte ptr [si],1
		jnz	loc_b_0666		; Jump if not zero
		mov	byte ptr [si+24h],4
		jmp	short loc_b_066A
		db	90h
loc_b_0666:
		mov	byte ptr [si+24h],0Eh
loc_b_066A:
		test	byte ptr [si],2
		jz	loc_b_068B		; Jump if zero
		mov	word ptr [di+2Ah],523h
		cmp	data_a_002F,0
		jne	loc_b_0683		; Jump if not equal
		mov	word ptr [di+26h],563h
		jmp	loc_b_07FC
loc_b_0683:
		mov	word ptr [di+26h],513h
		jmp	loc_b_07FC
loc_b_068B:
		mov	word ptr [di+2Ah],543h
		cmp	data_a_002F,0
		jne	loc_b_069F		; Jump if not equal
		mov	word ptr [di+26h],533h
		jmp	loc_b_07FC
loc_b_069F:
		mov	word ptr [di+26h],553h
		jmp	loc_b_07FC
loc_b_06A7:
		mov	byte ptr [si+0Ah],0
		or	byte ptr [si],4
		and	byte ptr [si],0FEh
		cmp	data_a_002F,0
		jne	loc_b_06DC		; Jump if not equal
		cmp	al,0
		jne	loc_b_06CC		; Jump if not equal
		mov	word ptr [di+26h],573h
		mov	word ptr [di+2Ah],57Dh
		or	byte ptr [si],2
		jmp	short loc_b_06FD
		db	90h
loc_b_06CC:
		mov	word ptr [di+26h],587h
		mov	word ptr [di+2Ah],591h
		and	byte ptr [si],0FDh
		jmp	short loc_b_06FD
		db	90h
loc_b_06DC:
		cmp	al,0
		jne	loc_b_06F0		; Jump if not equal
		mov	word ptr [di+26h],5AFh
		mov	word ptr [di+2Ah],5B9h
		or	byte ptr [si],2
		jmp	short loc_b_06FD
		db	90h
loc_b_06F0:
		mov	word ptr [di+26h],59Bh
		mov	word ptr [di+2Ah],5A5h
		and	byte ptr [si],0FDh
loc_b_06FD:
		mov	byte ptr [si+24h],0FEh
loc_b_0701:
		inc	byte ptr [si+24h]
		inc	byte ptr [si+24h]
		cmp	byte ptr [si+24h],8
		jne	loc_b_0710		; Jump if not equal
		and	byte ptr [si],0FBh
loc_b_0710:
		jmp	loc_b_07FC
loc_b_0713:
		mov	data_a_0001,0
		mov	byte ptr [si+0Ah],0
		and	byte ptr [si],0FBh
		test	byte ptr [si],8
		jz	loc_b_0731		; Jump if zero
		cmp	data_a_002F,1
		jne	loc_b_072E		; Jump if not equal
		mov	bx,offset data_a_0087
loc_b_072E:
		jmp	loc_b_07FC
loc_b_0731:
		cmp	data_a_0002,0
		jne	loc_b_0786		; Jump if not equal
		and	byte ptr [si],0FEh
		test	byte ptr [si],2
		jz	loc_b_0761		; Jump if zero
		cmp	data_a_002F,0
		jne	loc_b_0754		; Jump if not equal
		mov	word ptr [di+26h],507h
		mov	word ptr [di+2Ah],509h
		jmp	short loc_b_077F
		db	90h
loc_b_0754:
		mov	word ptr [di+26h],50Bh
		mov	word ptr [di+2Ah],50Dh
		jmp	short loc_b_077F
		db	90h
loc_b_0761:
		cmp	data_a_002F,0
		jne	loc_b_0775		; Jump if not equal
		mov	word ptr [di+26h],503h
		mov	word ptr [di+2Ah],505h
		jmp	short loc_b_077F
		db	90h
loc_b_0775:
		mov	word ptr [di+26h],50Fh
		mov	word ptr [di+2Ah],511h
loc_b_077F:
		mov	byte ptr [si+24h],0
		jmp	short loc_b_07FC
		db	90h
loc_b_0786:
		mov	byte ptr [si+0Ah],0
		test	byte ptr [si],1
		jnz	loc_b_07D3		; Jump if not zero
		or	byte ptr [si],1
		mov	byte ptr [si+24h],0
		test	byte ptr [si],2
		jz	loc_b_07B7		; Jump if zero
		mov	word ptr [di+2Ah],523h
		cmp	data_a_002F,0
		jne	loc_b_07AF		; Jump if not equal
		mov	word ptr [di+26h],563h
		jmp	short loc_b_07FC
		db	90h
loc_b_07AF:
		mov	word ptr [di+26h],513h
		jmp	short loc_b_07FC
		db	90h
loc_b_07B7:
		mov	word ptr [di+2Ah],543h
		cmp	data_a_002F,0
		jne	loc_b_07CB		; Jump if not equal
		mov	word ptr [di+26h],533h
		jmp	short loc_b_07FC
		db	90h
loc_b_07CB:
		mov	word ptr [di+26h],553h
		jmp	short loc_b_07FC
		db	90h
loc_b_07D3:
		inc	byte ptr [si+24h]
		inc	byte ptr [si+24h]
		cmp	byte ptr [si+24h],10h
		jne	loc_b_07FC		; Jump if not equal
		mov	byte ptr [si+24h],0
		jmp	short loc_b_07FC
		db	90h
loc_b_07E6:
		mov	cx,0
		test	byte ptr [si],8
		jnz	loc_b_07F1		; Jump if not zero
		jmp	loc_ret_b_08B3
loc_b_07F1:
		mov	ax,data_a_0035
		cmp	[si+6],al
		je	loc_b_07FC		; Jump if equal
		jmp	loc_ret_b_08B3
loc_b_07FC:
		cmp	data_a_002F,0
		jne	loc_b_080C		; Jump if not equal
		mov	ax,87h
		mov	dx,9Ch
		jmp	short loc_b_0812
		db	90h
loc_b_080C:
		mov	ax,0B1h
		mov	dx,0C6h
loc_b_0812:
		mov	bx,ax
		cmp	word ptr [bx+4],1F58h
		jne	loc_b_081E		; Jump if not equal
		add	word ptr [bx],6
loc_b_081E:
		cmp	word ptr [bx+4],2708h
		jne	loc_b_0828		; Jump if not equal
		sub	word ptr [bx],6
loc_b_0828:
		mov	bx,dx
		cmp	word ptr [bx+4],224Ch
		jne	loc_b_0834		; Jump if not equal
		add	word ptr [bx],6
loc_b_0834:
		cmp	word ptr [bx+4],2AB2h
		jne	loc_b_083E		; Jump if not equal
		sub	word ptr [bx],6
loc_b_083E:
		mov	bx,ax
		push	ax
		mov	al,ch
		cbw				; Convrt byte to word
		add	[bx],ax
		mov	byte ptr [bx+0Ch],1
		mov	al,cl
		cbw				; Convrt byte to word
		add	[bx+2],ax
		mov	bx,dx
		mov	al,ch
		cbw				; Convrt byte to word
		add	[bx],ax
		mov	byte ptr [bx+0Ch],1
		mov	al,cl
		cbw				; Convrt byte to word
		add	[bx+2],ax
		cmp	data_a_002F,0
		je	loc_b_0873		; Jump if equal
		mov	cx,[bx]
		mov	bx,offset data_a_075F
		mov	[bx],cx
		mov	byte ptr [bx+0Ch],1
loc_b_0873:
		pop	ax
		mov	cl,[si+24h]
		mov	ch,0
		mov	si,cx
		mov	bx,[di+26h]
		mov	bp,[bx+si]
		mov	bx,ax
		mov	[bx+4],bp
		cmp	bp,1F58h
		jne	loc_b_088E		; Jump if not equal
		sub	word ptr [bx],6
loc_b_088E:
		cmp	bp,2708h
		jne	loc_b_0897		; Jump if not equal
		add	word ptr [bx],6
loc_b_0897:
		mov	bx,[di+2Ah]
		mov	bp,[bx+si]
		mov	bx,dx
		mov	[bx+4],bp
		cmp	bp,224Ch
		jne	loc_b_08AA		; Jump if not equal
		sub	word ptr [bx],6
loc_b_08AA:
		cmp	bp,2AB2h
		jne	loc_ret_b_08B3		; Jump if not equal
		add	word ptr [bx],6

loc_ret_b_08B3:
		retn
sub_b_0488	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_08B4	proc	near
		call	sub_b_0FCD
		cmp	data_a_0003,1
		jne	loc_ret_b_0921		; Jump if not equal

;==== External Entry into Subroutine ======================================

sub_b_08BE:
		test	byte ptr [si],4
		jnz	loc_ret_b_0921		; Jump if not zero
		mov	di,si
		add	di,data_a_002F
		test	byte ptr [si],2
		jnz	loc_b_08F2		; Jump if not zero
		or	byte ptr [si],2
		cmp	data_a_002F,0
		je	loc_b_08E5		; Jump if equal
		mov	word ptr [di+26h],5AFh
		mov	word ptr [di+2Ah],5B9h
		jmp	short loc_b_0913
		db	90h
loc_b_08E5:
		mov	word ptr [di+26h],573h
		mov	word ptr [di+2Ah],57Dh
		jmp	short loc_b_0913
		db	90h
loc_b_08F2:
		and	byte ptr [si],0FDh
		cmp	data_a_002F,0
		je	loc_b_0909		; Jump if equal
		mov	word ptr [di+26h],59Bh
		mov	word ptr [di+2Ah],5A5h
		jmp	short loc_b_0913
		db	90h
loc_b_0909:
		mov	word ptr [di+26h],587h
		mov	word ptr [di+2Ah],591h
loc_b_0913:
		mov	byte ptr [si+24h],0
		or	byte ptr [si],8
		and	byte ptr [si],0FEh
		mov	byte ptr [si+6],1

loc_ret_b_0921:
		retn
sub_b_08B4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0922	proc	near
		dec	byte ptr [si+6]
		jnz	loc_ret_b_0945		; Jump if not zero
		mov	ax,data_a_0035
		mov	[si+6],al
		push	bx
		mov	bx,87h
		mov	byte ptr [bx+0Ch],1
		pop	bx
		inc	byte ptr [si+24h]
		inc	byte ptr [si+24h]
		cmp	byte ptr [si+24h],0Ah
		jne	loc_ret_b_0945		; Jump if not equal
		and	byte ptr [si],0F7h

loc_ret_b_0945:
		retn
sub_b_0922	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0946	proc	near
		mov	si,offset data_a_0059
		mov	di,835h
		mov	data_a_002B,0
		mov	data_a_002E,0
		and	byte ptr [si],0F7h
		and	byte ptr [si+1],0F7h
		and	byte ptr [si],0FBh
		and	byte ptr [si+1],0FBh
		or	data_a_0000,4
		and	data_a_0000,0DFh
		test	data_a_0000,8
		jnz	loc_b_0987		; Jump if not zero
		or	data_a_0000,8
		push	si
		mov	si,929h
		mov	dl,0Dh
		call	sub_b_260E
		pop	si
		jmp	short loc_b_0995
		db	90h
loc_b_0987:
		and	data_a_0000,0F7h
		sub	data_a_0033,2
		neg	data_a_0033
loc_b_0995:
		mov	cx,data_a_0031
		add	si,cx
		add	di,cx
		add	di,cx
		mov	data_a_000F,0
		cmp	cl,data_a_000B
		je	loc_b_09AF		; Jump if equal
		mov	data_a_000F,2
loc_b_09AF:
		mov	cx,data_a_0033
		mov	ax,data_a_0031
		add	cl,al
		mov	data_a_0055,cx
		dec	al
		neg	al
		mov	cl,al
		push	si
		push	di
		mov	di,offset data_a_0059
		add	di,cx
		add	di,cx
		mov	si,data_a_0033
		add	si,cx
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_a_088D
		mov	ax,[si]
		mov	[di+1Ch],ax
		mov	ax,[si+2]
		mov	[di+20h],ax
		mov	di,offset data_a_0059
		add	di,data_a_0031
		add	di,data_a_0031
		mov	si,data_a_0055
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_a_089D
		mov	ax,[si]
		mov	[di+1Ch],ax
		mov	ax,[si+2]
		mov	[di+20h],ax
		push	cx
		call	sub_b_24C1
		pop	cx
		pop	di
		pop	si
		call	sub_b_0D72
		call	sub_b_0DF8
		mov	bx,offset data_a_00C6
		mov	ax,[bx]
		mov	bx,offset data_a_075F
		mov	[bx],ax
		mov	byte ptr [bx+0Ch],1
		mov	data_a_0051,8E6h
		push	si
		push	di
		mov	di,data_a_0055
		shl	di,1			; Shift w/zeros fill
		mov	si,di
		shl	di,1			; Shift w/zeros fill
		add	di,offset data_a_088D
		add	si,88Dh
		mov	bx,offset data_a_074B
		mov	byte ptr [bx+4],1
		mov	ax,[di+20h]
		mov	[bx],ax
		mov	cx,[di+22h]
		mov	[bx+2],cx
		mov	bx,offset data_a_0755
		mov	byte ptr [bx+4],1
		mov	ax,[di+30h]
		mov	[bx],ax
		mov	cx,[di+32h]
		mov	[bx+2],cx
		mov	data_a_003F,cx
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0A75		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0A75:
		call	sub_b_0317
		call	sub_b_0FA0
		and	al,7
		inc	al
		inc	al
		mov	byte ptr data_a_002C,al
		mov	al,data_a_0009
		mov	byte ptr data_a_002C+1,al
loc_b_0A8A:
		call	sub_b_0D4F
		cmp	byte ptr data_a_0026,0
		jne	loc_b_0AA1		; Jump if not equal
		call	sub_b_2681
		dec	byte ptr data_a_002C
		mov	data_a_0051,8DDh
loc_b_0AA1:
		mov	data_a_0053,800h
		call	sub_b_1109
		call	sub_b_0FAC
		call	sub_b_0E7C
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0AC2		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0AC2:
		call	sub_b_0317
		cmp	data_a_0006,2
		je	loc_b_0B07		; Jump if equal
		cmp	data_a_0006,0
		je	loc_b_0ADC		; Jump if equal
		mov	ax,data_a_0031
		cmp	data_a_000C,al
		jne	loc_b_0B07		; Jump if not equal
loc_b_0ADC:
		cmp	byte ptr data_a_002C,0
		jne	loc_b_0A8A		; Jump if not equal
		call	sub_b_0FA0
		mov	cl,0
		ror	al,1			; Rotate
		jc	loc_b_0AEE		; Jump if carry Set
		mov	cl,0FFh
loc_b_0AEE:
		mov	data_a_0002,cl
		mov	cl,0
		ror	al,1			; Rotate
		jc	loc_b_0B00		; Jump if carry Set
		mov	cl,0FFh
		ror	al,1			; Rotate
		jc	loc_b_0B00		; Jump if carry Set
		mov	cl,1
loc_b_0B00:
		mov	data_a_0001,cl
		jmp	short loc_b_0B1A
		db	90h
loc_b_0B07:
		mov	al,data_a_000E
		mov	data_a_000D,al
		call	sub_b_0FCD
		cmp	data_a_0003,1
		je	loc_b_0B1A		; Jump if equal
		jmp	loc_b_0A8A
loc_b_0B1A:
		call	sub_b_0F07
		mov	bx,offset data_a_074B
		mov	ax,[di+22h]
		dec	ax
		mov	[bx+2],ax
		mov	ax,[di+20h]
		cmp	data_a_0031,0
		jne	loc_b_0B37		; Jump if not equal
		add	ax,6
		jmp	short loc_b_0B3A
		db	90h
loc_b_0B37:
		sub	ax,6
loc_b_0B3A:
		mov	[bx],ax
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0B4E		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0B4E:
		call	sub_b_0317
		mov	data_a_0053,200h
		call	sub_b_1109
		pop	di
		mov	ax,[si+48h]
		mov	data_a_0041,ax
		cmp	data_a_0001,0FFh
		jne	loc_b_0B70		; Jump if not equal
		sub	data_a_0041,1Eh
		jmp	short loc_b_0B7C
		db	90h
loc_b_0B70:
		cmp	data_a_0001,1
		jne	loc_b_0B7C		; Jump if not equal
		add	data_a_0041,1Eh
loc_b_0B7C:
		cmp	data_a_0002,0FFh
		je	loc_b_0B8A		; Jump if equal
		cmp	data_a_0002,1
		jne	loc_b_0B8F		; Jump if not equal
loc_b_0B8A:
		or	data_a_0000,20h		; ' '
loc_b_0B8F:
		mov	bx,offset data_a_0755
		mov	ax,[di]
		mov	data_a_003F,ax
		mov	[bx+2],ax
		mov	ax,[si+40h]
		mov	data_a_003D,ax
		mov	[bx],ax
		call	sub_b_0F07
		mov	data_a_0051,8F1h
		mov	bx,offset data_a_074B
		mov	ax,[si+40h]
		mov	[bx],ax
		mov	ax,data_a_003F
		mov	[bx+2],ax
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0BCB		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0BCB:
		call	sub_b_0317
loc_b_0BCE:
		call	sub_b_0D4F
		mov	data_a_0053,400h
		call	sub_b_1109
		call	sub_b_0FAC
		call	sub_b_0E7C
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0BF2		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0BF2:
		call	sub_b_0317
		cmp	data_a_0051,911h
		jne	loc_b_0BCE		; Jump if not equal
		call	sub_b_0F07
loc_b_0C00:
		call	sub_b_0D4F
		mov	data_a_0053,400h
		call	sub_b_1109
		call	sub_b_0FAC
		call	sub_b_0E7C
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0C24		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0C24:
		call	sub_b_0317
		cmp	data_a_0051,918h
		jne	loc_b_0C00		; Jump if not equal
		call	sub_b_0F07
loc_b_0C32:
		call	sub_b_0D4F
		mov	data_a_0053,400h
		call	sub_b_1109
		call	sub_b_0FAC
		call	sub_b_0E7C
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0C56		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0C56:
		call	sub_b_0317
		cmp	data_a_0051,91Bh
		jne	loc_b_0C32		; Jump if not equal
		call	sub_b_2695
		call	sub_b_0F07
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0C79		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0C79:
		call	sub_b_0317
		mov	data_a_0053,300h
		call	sub_b_1109
		mov	cx,data_a_0031
		push	si
		mov	si,offset data_a_0835
		add	si,cx
		add	si,cx
		mov	bx,[si+4Ch]
		sub	word ptr [bx+0Fh],0Ah
		sub	word ptr [bx+13h],0Ah
		pop	si
		call	sub_b_0D72
		mov	bx,si
		pop	si
		or	byte ptr [si],40h	; '@'
		mov	ax,[bx+40h]
		mov	data_a_0045,ax
		mov	ax,[di]
		mov	data_a_0047,ax
		mov	ax,[di+4]
		mov	data_a_0043,ax
		mov	byte ptr data_a_0026+1,11h
		mov	byte ptr data_a_0028,20h	; ' '
		call	sub_b_0FA0
		test	data_a_0000,20h		; ' '
		jz	loc_b_0CCD		; Jump if zero
		and	al,3Fh			; '?'
loc_b_0CCD:
		cmp	al,0Ch
		jae	loc_b_0CD9		; Jump if above or =
		mov	byte ptr data_a_0026+1,9
		jmp	short loc_b_0CF3
		db	90h
loc_b_0CD9:
		cmp	al,18h
		jae	loc_b_0CF3		; Jump if above or =
		mov	data_a_002B,0FFh
		mov	cx,[di+8]
		add	data_a_0041,cx
		mov	cx,[di+0Ch]
		add	data_a_0043,cx
		jmp	short loc_b_0D0D
		db	90h
loc_b_0CF3:
		call	sub_b_0FA0
		and	al,0Fh
		mov	ah,0
		add	data_a_0041,ax
		call	sub_b_0FA0
		mov	cl,4
		ror	al,cl			; Rotate
		and	al,0Fh
		mov	ah,0
		add	data_a_0043,ax
loc_b_0D0D:
		push	si
		call	sub_b_1320
		call	sub_b_1373
		pop	si
		mov	bx,offset data_a_00B1
		mov	al,[bx+0Ch]
		mov	bx,offset data_a_0087
		cmp	byte ptr [bx+0Ch],1
		je	loc_b_0D27		; Jump if equal
		mov	[bx+0Ch],al
loc_b_0D27:
		call	sub_b_0317
		or	data_a_0000,10h
		and	data_a_0000,0BFh
		or	byte ptr [si],10h
		mov	si,data_a_0031
		dec	si
		neg	si
		add	si,59h
		and	byte ptr [si],0EFh
		mov	si,offset data_a_0059
		and	byte ptr [si],0DFh
		and	byte ptr [si+1],0DFh
		retn
sub_b_0946	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0D4F	proc	near
		call	sub_b_0D64
		mov	ax,data_a_003F
		mov	bl,byte ptr data_a_0026
		mov	bh,0
		sub	ax,bx
		mov	bx,offset data_a_074B
		mov	[bx+2],ax
		retn
sub_b_0D4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0D64	proc	near
		mov	bx,data_a_0051
		mov	al,[bx]
		mov	byte ptr data_a_0026,al
		inc	data_a_0051
		retn
sub_b_0D64	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0D72	proc	near
		push	si
		push	di
		mov	si,offset data_a_0059
		add	si,cx
		mov	di,si
		add	di,cx
		and	byte ptr [si],0FEh
		and	byte ptr [si],0F7h
		and	byte ptr [si],0FBh
		test	byte ptr [si],2
		jz	loc_b_0DAA		; Jump if zero
		cmp	cx,0
		jne	loc_b_0D9D		; Jump if not equal
		mov	word ptr [di+26h],507h
		mov	word ptr [di+2Ah],509h
		jmp	short loc_b_0DC6
		db	90h
loc_b_0D9D:
		mov	word ptr [di+26h],50Bh
		mov	word ptr [di+2Ah],50Dh
		jmp	short loc_b_0DC6
		db	90h
loc_b_0DAA:
		cmp	cx,0
		jne	loc_b_0DBC		; Jump if not equal
		mov	word ptr [di+26h],503h
		mov	word ptr [di+2Ah],505h
		jmp	short loc_b_0DC6
		db	90h
loc_b_0DBC:
		mov	word ptr [di+26h],50Fh
		mov	word ptr [di+2Ah],511h
loc_b_0DC6:
		mov	byte ptr [si+24h],0
		push	di
		mov	di,offset data_a_0835
		add	di,cx
		add	di,cx
		mov	ax,[di+4Ch]
		mov	dx,[di+50h]
		pop	di
		mov	bx,[di+26h]
		mov	bp,[bx]
		mov	bx,ax
		mov	[bx+4],bp
		mov	byte ptr [bx+0Ch],1
		mov	bx,[di+2Ah]
		mov	bp,[bx]
		mov	bx,dx
		mov	[bx+4],bp
		mov	byte ptr [bx+0Ch],1
		pop	di
		pop	si
		retn
sub_b_0D72	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0DF8	proc	near
		push	si
		push	di
		mov	si,offset data_a_0059
		add	si,data_a_0031
		mov	di,si
		add	di,data_a_0031
		mov	byte ptr [si+24h],0
		cmp	data_a_0031,0
		jne	loc_b_0E28		; Jump if not equal
		mov	word ptr [di+26h],5C3h
		mov	word ptr [di+2Ah],5CFh
		mov	ax,87h
		mov	dx,9Ch
		and	byte ptr [si],0FDh
		jmp	short loc_b_0E3B
		db	90h
loc_b_0E28:
		mov	word ptr [di+26h],5DBh
		mov	word ptr [di+2Ah],5E7h
		mov	ax,0B1h
		mov	dx,0C6h
		or	byte ptr [si],2
loc_b_0E3B:
		mov	bx,[di+26h]
		mov	bp,[bx]
		mov	bx,ax
		mov	[bx+4],bp
		mov	byte ptr [bx+0Ch],1
		mov	bx,[di+2Ah]
		mov	bp,[bx]
		mov	bx,dx
		mov	[bx+4],bp
		mov	byte ptr [bx+0Ch],1
		mov	si,data_a_0055
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_a_089D
		mov	cx,[si]
		mov	bp,[si+2]
		mov	bx,ax
		mov	[bx],cx
		mov	[bx+2],bp
		mov	bx,dx
		mov	[bx],cx
		add	bp,0Fh
		mov	[bx+2],bp
		pop	di
		pop	si
		retn
sub_b_0DF8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0E7C	proc	near
		push	si
		push	di
		mov	al,data_a_000E
		sub	al,3
		neg	al
		mov	data_a_000D,al
		mov	ax,data_a_0031
		dec	ax
		neg	ax
		mov	data_a_002F,ax
		cmp	data_a_0006,2
		je	loc_b_0EBE		; Jump if equal
		cmp	data_a_0006,0
		je	loc_b_0EA8		; Jump if equal
		mov	ax,data_a_0031
		cmp	data_a_000C,al
		je	loc_b_0EBE		; Jump if equal
loc_b_0EA8:
		dec	byte ptr data_a_002C+1
		jnz	loc_b_0EFE		; Jump if not zero
		mov	al,data_a_0009
		mov	byte ptr data_a_002C+1,al
		mov	si,87h
		mov	byte ptr [si+0Ch],1
		jmp	short loc_b_0EFE
		db	90h
loc_b_0EBE:
		call	sub_b_0488
		mov	si,offset data_a_0059
		add	si,data_a_002F
		test	byte ptr [si],8
		jz	loc_b_0ED9		; Jump if zero
		mov	di,si
		add	di,data_a_002F
		call	sub_b_0922
		jmp	short loc_b_0EFE
		db	90h
loc_b_0ED9:
		mov	al,data_a_000E
		sub	al,3
		neg	al
		mov	data_a_000D,al
		call	sub_b_08B4
		jmp	short loc_b_0EFE
			                        ;* No entry point to code
		nop
		mov	si,offset data_a_0059
		add	si,data_a_002F
		mov	di,si
		add	di,data_a_002F
		mov	data_a_0001,0
		call	sub_b_0564
loc_b_0EFE:
		mov	ax,data_a_0031
		mov	data_a_002F,ax
		pop	di
		pop	si
		retn
sub_b_0E7C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0F07	proc	near
		push	si
		push	di
		mov	si,offset data_a_0059
		add	si,data_a_0031
		inc	byte ptr [si+24h]
		inc	byte ptr [si+24h]
		cmp	data_a_0031,0
		jne	loc_b_0F26		; Jump if not equal
		mov	ax,87h
		mov	dx,9Ch
		jmp	short loc_b_0F2C
		db	90h
loc_b_0F26:
		mov	ax,0B1h
		mov	dx,0C6h
loc_b_0F2C:
		mov	di,si
		add	di,data_a_0031
		mov	bx,offset data_a_0087
		mov	byte ptr [bx+0Ch],1
		mov	bx,ax
		mov	byte ptr [bx+0Ch],1
		cmp	word ptr [bx+4],46BEh
		je	loc_b_0F4D		; Jump if equal
		cmp	word ptr [bx+4],50CEh
		jne	loc_b_0F59		; Jump if not equal
loc_b_0F4D:
		sub	word ptr [bx+8],0Ah
		add	word ptr [bx+2],0Ah
		add	word ptr [bx+0Fh],0Ah
loc_b_0F59:
		mov	cl,[si+24h]
		mov	ch,0
		mov	si,cx
		mov	bx,[di+26h]
		mov	bp,[bx+si]
		mov	bx,ax
		mov	[bx+4],bp
		cmp	bp,45A6h
		je	loc_b_0F82		; Jump if equal
		cmp	bp,46BEh
		je	loc_b_0F82		; Jump if equal
		cmp	bp,4FB6h
		je	loc_b_0F82		; Jump if equal
		cmp	bp,50CEh
		jne	loc_b_0F8E		; Jump if not equal
loc_b_0F82:
		add	word ptr [bx+8],5
		sub	word ptr [bx+2],5
		add	word ptr [bx+13h],5
loc_b_0F8E:
		mov	bx,[di+2Ah]
		mov	bp,[bx+si]
		mov	bx,dx
		mov	[bx+4],bp
		mov	byte ptr [bx+0Ch],1
		pop	di
		pop	si
		retn
sub_b_0F07	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0FA0	proc	near
		push	dx
		push	cx
		mov	ah,0
		sti				; Enable interrupts
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	al,dl
		pop	cx
		pop	dx
		retn
sub_b_0FA0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0FAC	proc	near
		cmp	data_a_094A,0
		je	loc_b_0FB4		; Jump if equal
		retn
loc_b_0FB4:
		mov	dx,201h
		mov	al,0FFh
		out	dx,al			; port 201h, start game 1-shots
		mov	cx,50h

locloop_b_0FBD:
		loop	locloop_b_0FBD		; Loop if cx > 0

		in	al,dx			; port 201h, start game 1-shots
		mov	data_a_0004,al
		mov	cx,50h

locloop_b_0FC6:
		loop	locloop_b_0FC6		; Loop if cx > 0

		in	al,dx			; port 201h, start game 1-shots
		mov	data_a_0005,al
		retn
sub_b_0FAC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0FCD	proc	near
		mov	data_a_0003,0
		cmp	data_a_000D,1
		jne	loc_b_1035		; Jump if not equal
		cmp	data_a_094A,0
		je	loc_b_1014		; Jump if equal
		push	bx
		mov	al,data_a_0953
		mov	data_a_0003,al
		mov	bx,offset data_a_09AE
		mov	ax,0
		mov	al,data_a_0950
		shl	al,1			; Shift w/zeros fill
		add	al,data_a_094F
		add	bx,ax
		mov	al,[bx]
		mov	data_a_0001,al
		mov	bx,offset data_a_09AE
		mov	al,data_a_0952
		shl	al,1			; Shift w/zeros fill
		add	al,data_a_0951
		add	bx,ax
		mov	al,[bx]
		mov	data_a_0002,al
		pop	bx
		jmp	short loc_ret_b_108E
		db	90h
loc_b_1014:
		mov	cl,0
		call	sub_b_108F
		mov	data_a_0001,dl
		mov	cl,1
		call	sub_b_108F
		mov	data_a_0002,dl
		mov	al,data_a_0004
		and	al,10h
		jnz	loc_ret_b_108E		; Jump if not zero
		mov	data_a_0003,1
		jmp	short loc_ret_b_108E
		db	90h
loc_b_1035:
		cmp	data_a_094A,0
		je	loc_b_1070		; Jump if equal
		push	bx
		mov	al,data_a_0958
		mov	data_a_0003,al
		mov	bx,offset data_a_09AE
		mov	ax,0
		mov	al,data_a_0955
		shl	al,1			; Shift w/zeros fill
		add	al,data_a_0954
		add	bx,ax
		mov	al,[bx]
		mov	data_a_0001,al
		mov	bx,offset data_a_09AE
		mov	al,data_a_0957
		shl	al,1			; Shift w/zeros fill
		add	al,data_a_0956
		add	bx,ax
		mov	al,[bx]
		mov	data_a_0002,al
		pop	bx
		jmp	short loc_ret_b_108E
		db	90h
loc_b_1070:
		mov	cl,2
		call	sub_b_108F
		mov	data_a_0001,dl
		mov	cl,3
		call	sub_b_108F
		mov	data_a_0002,dl
		mov	al,data_a_0004
		and	al,40h			; '@'
		jnz	loc_ret_b_108E		; Jump if not zero
		mov	data_a_0003,1

loc_ret_b_108E:
		retn
sub_b_0FCD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_108F	proc	near
		mov	ah,data_a_0004
		mov	al,data_a_0005
		shr	ah,cl			; Shift w/zeros fill
		and	ah,1
		jnz	loc_b_10A2		; Jump if not zero
		mov	dl,0FFh
		jmp	short loc_ret_b_10AF
		db	90h
loc_b_10A2:
		shr	al,cl			; Shift w/zeros fill
		and	al,1
		jnz	loc_b_10AD		; Jump if not zero
		mov	dl,0
		jmp	short loc_ret_b_10AF
		db	90h
loc_b_10AD:
		mov	dl,1

loc_ret_b_10AF:
		retn
sub_b_108F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_10B0	proc	near
		cmp	data_a_094A,0
		je	loc_b_10F6		; Jump if equal
		mov	ah,0
		cmp	data_a_095A,1
		jne	loc_b_10C5		; Jump if not equal
		mov	ah,1
		jmp	short loc_ret_b_1108
		db	90h
loc_b_10C5:
		cmp	data_a_09A7,1
		jne	loc_b_10D1		; Jump if not equal
		mov	ah,4Eh			; 'N'
		jmp	short loc_ret_b_1108
		db	90h
loc_b_10D1:
		cmp	data_a_09A3,1
		jne	loc_b_10DD		; Jump if not equal
		mov	ah,4Ah			; 'J'
		jmp	short loc_ret_b_1108
		db	90h
loc_b_10DD:
		mov	ah,data_a_0976
		add	ah,data_a_0979
		add	ah,data_a_098F
		cmp	ah,3
		jne	loc_b_10F1		; Jump if not equal
loc_b_10EE:
		call	sub_b_25E5
loc_b_10F1:
		mov	ah,0
		jmp	short loc_ret_b_1108
		db	90h
loc_b_10F6:
		sti				; Enable interrupts
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jnz	loc_b_1100		; Jump if not zero
		xor	ah,ah			; Zero register
		retn
loc_b_1100:
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	al,4
		je	loc_b_10EE		; Jump if equal

loc_ret_b_1108:
		retn
sub_b_10B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1109	proc	near
loc_b_1109:
		dec	data_a_0053
		jnz	loc_b_1109		; Jump if not zero
		retn
sub_b_1109	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1110	proc	near
		push	es
		mov	ax,0
		mov	es,ax
		mov	di,d_0000_0024_e
		mov	ax,es:[di]
		mov	data_a_094D,ax
		mov	ax,es:[di+2]
		mov	data_a_094B,ax
		pop	es
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	dx,3D9h
		mov	al,0
		out	dx,al			; port 3D9h, CGA color control
		mov	si,offset data_a_09B4	; ('DO YOU WANT TO USE :')
		mov	dx,[si-2]
		mov	bx,6
		call	sub_b_2621
		mov	si,offset data_a_09CB	; ('1. JOYSTICKS')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_09DA	; ('2. KEYBOARD')
		mov	dx,[si-2]
		call	sub_b_2621
loc_b_1150:
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	al,32h			; '2'
		je	loc_b_1162		; Jump if equal
		cmp	al,31h			; '1'
		jne	loc_b_1150		; Jump if not equal
		mov	data_a_094A,0
		retn
loc_b_1162:
		mov	bx,6
		mov	si,offset data_a_09E7+1	; ('CONTROL KEYS CURRENTLY D')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0A0E	; ('PLAYER ONE')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0A2E+1	; ('0. LEFT  = B        5. L')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0A53	; ('1. RIGHT = N        6. R')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0A77	; ('2. UP    = S        7. U')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0A9B	; ('3. DOWN  = X        8. D')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0ABF	; ('4. FIRE  = sp       9. F')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0AE3	; ('TO CHANGE A KEY DEFINITI')
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0B02
		mov	dx,[si-2]
		call	sub_b_2621
		mov	si,offset data_a_0B2D	; ('PRESS ESC KEY TO START')
		mov	dx,[si-2]
		call	sub_b_2621
loc_b_11BF:
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	ah,1
		je	loc_b_1206		; Jump if equal
		cmp	al,30h			; '0'
		jb	loc_b_11BF		; Jump if below
		cmp	al,39h			; '9'
		ja	loc_b_11BF		; Jump if above
		sub	al,30h			; '0'
		xor	ah,ah			; Zero register
		mov	si,940h
		mov	dh,al
		add	si,ax
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	ah,1
		je	loc_b_1206		; Jump if equal
		mov	[si],ah
		mov	si,offset data_a_0B44
		cmp	al,0
		jne	loc_b_11ED		; Jump if not equal
		mov	al,20h			; ' '
loc_b_11ED:
		mov	[si],al
		mov	dl,0Fh
		cmp	dh,5
		jb	loc_b_11FB		; Jump if below
		mov	dl,23h			; '#'
		sub	dh,5
loc_b_11FB:
		add	dh,0Ch
		mov	bx,6
		call	sub_b_2621
		jmp	short loc_b_11BF
loc_b_1206:
		call	sub_b_120F
		mov	data_a_094A,1
		retn
sub_b_1110	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_120F	proc	near
		push	es
		cli				; Disable interrupts
		mov	ax,0
		mov	es,ax
		mov	di,d_0000_0024_e
		mov	ax,1228h
		cld				; Clear direction
		stosw				; Store ax to es:[di]
		mov	ax,cs
		stosw				; Store ax to es:[di]
		mov	al,0FCh
		out	21h,al			; port 21h, 8259-1 int comands
		sti				; Enable interrupts
		pop	es
		retn
sub_b_120F	endp

			                        ;* No entry point to code
		push	ax
		push	bx
		push	cx
		push	ds
		mov	ax,seg_a
		mov	ds,ax
		in	al,60h			; port 60h, keybd scan or sw1
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
		and	al,7Fh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		mov	cl,0
		test	al,80h
		jnz	loc_b_1247		; Jump if not zero
		inc	cl
loc_b_1247:
		and	al,7Fh
		cmp	al,data_a_0942
		jne	loc_b_1256		; Jump if not equal
		mov	data_a_0951,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_1256:
		cmp	al,data_a_0943
		jne	loc_b_1263		; Jump if not equal
		mov	data_a_0952,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_1263:
		cmp	al,data_a_0940
		jne	loc_b_1270		; Jump if not equal
		mov	data_a_094F,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_1270:
		cmp	al,data_a_0941
		jne	loc_b_127D		; Jump if not equal
		mov	data_a_0950,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_127D:
		cmp	al,data_a_0944
		jne	loc_b_128A		; Jump if not equal
		mov	data_a_0953,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_128A:
		cmp	al,data_a_0947
		jne	loc_b_1297		; Jump if not equal
		mov	data_a_0956,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_1297:
		cmp	al,data_a_0948
		jne	loc_b_12A4		; Jump if not equal
		mov	data_a_0957,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_12A4:
		cmp	al,data_a_0945
		jne	loc_b_12B1		; Jump if not equal
		mov	data_a_0954,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_12B1:
		cmp	al,data_a_0946
		jne	loc_b_12BE		; Jump if not equal
		mov	data_a_0955,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_12BE:
		cmp	al,data_a_0949
		jne	loc_b_12CB		; Jump if not equal
		mov	data_a_0958,cl
		jmp	short loc_b_12D4
		db	90h
loc_b_12CB:
		mov	ah,0
		mov	bx,offset data_a_0959
		add	bx,ax
		mov	[bx],cl
loc_b_12D4:
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	ds
		pop	cx
		pop	bx
		pop	ax
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_12DD	proc	near
		cmp	ah,data_a_09AD
		je	loc_ret_b_1312		; Jump if equal
		mov	data_a_09AD,ah
		or	ah,ah			; Zero ?
		jnz	loc_b_12EC		; Jump if not zero
		retn
loc_b_12EC:
		cmp	ah,4Eh			; 'N'
		jne	loc_b_12FF		; Jump if not equal
		cmp	data_a_0037,1
		je	loc_ret_b_1312		; Jump if equal
		sub	data_a_0037,100h
		retn
loc_b_12FF:
		cmp	ah,4Ah			; 'J'
		jne	loc_ret_b_1312		; Jump if not equal
		cmp	data_a_0037,1800h
		jae	loc_ret_b_1312		; Jump if above or =
		add	data_a_0037,100h

loc_ret_b_1312:
		retn
sub_b_12DD	endp

		db	13 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1320	proc	near
		and	data_a_0000,0BFh
		mov	dl,0FFh
		mov	ax,data_a_0045
		sub	ax,data_a_0041
		jnc	loc_b_1334		; Jump if carry=0
		mov	dl,1
		neg	ax
loc_b_1334:
		mov	data_a_004B,ax
		mov	cx,ax
		mov	byte ptr data_a_0028+1,dl
		mov	dl,0FFh
		mov	ax,data_a_0047
		sub	ax,data_a_0043
		jnc	loc_b_134C		; Jump if carry=0
		mov	dl,1
		neg	ax
loc_b_134C:
		mov	data_a_002A,dl
		mov	data_a_004D,ax
		cmp	ax,cx
		jae	loc_b_1359		; Jump if above or =
		mov	ax,cx
loc_b_1359:
		shr	ax,1			; Shift w/zeros fill
		mov	data_a_004F,ax
		mov	bx,offset data_a_0755
		mov	ax,data_a_0047
		mov	data_a_003F,ax
		mov	[bx+2],ax
		mov	ax,data_a_0045
		mov	data_a_003D,ax
		mov	[bx],ax
		retn
sub_b_1320	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1373	proc	near
		mov	cl,0
		mov	ax,data_a_0043
		sub	ax,data_a_0047
		jnz	loc_b_1381		; Jump if not zero
		add	ax,1
loc_b_1381:
		jnc	loc_b_1385		; Jump if carry=0
		neg	ax
loc_b_1385:
		mov	data_a_0B50,ax
		mov	ax,data_a_0047
		sub	ax,80h
		jnz	loc_b_1393		; Jump if not zero
		add	ax,1
loc_b_1393:
		jnc	loc_b_1397		; Jump if carry=0
		neg	ax
loc_b_1397:
		mov	data_a_0B54,ax
		mov	bx,data_a_0B50
		sub	bx,ax
		mov	data_a_0B56,bx
		mov	ax,bx
		mul	byte ptr data_a_0028	; ax = data * al
		push	ax
		mov	ax,data_a_0B50
		mul	byte ptr data_a_0026+1	; ax = data * al
		pop	bx
		sub	ax,bx
		jnc	loc_b_13BB		; Jump if carry=0
		mov	cl,1
		neg	ax
loc_b_13BB:
		jnz	loc_b_13C0		; Jump if not zero
		mov	ax,1
loc_b_13C0:
		push	ax
		mov	ax,data_a_0B56
		mov	bl,0Ah
		mul	bl			; ax = reg * al
		mul	data_a_0B54		; dx:ax = data * ax
		pop	bx
		div	bx			; ax,dx rem=dx:ax/reg
		mov	bx,data_a_0B50
		mul	bl			; ax = reg * al
		neg	ax
		js	loc_b_13DB		; Jump if sign=1
		neg	ax
loc_b_13DB:
		jnz	loc_b_13E0		; Jump if not zero
		mov	ax,1
loc_b_13E0:
		mov	data_a_0B58,ax
		mov	ax,data_a_0B50
		mul	al			; ax = reg * al
		mov	bx,0Ah
		mul	bx			; dx:ax = reg * ax
		mov	cl,0
		mov	bx,data_a_0B58
		cmp	bx,0
		jns	loc_b_13FC		; Jump if not sign
		neg	bx
		mov	cl,1
loc_b_13FC:
		mov	data_a_0B5A,bx
		div	bx			; ax,dx rem=dx:ax/reg
		cmp	cl,0
		je	loc_b_1409		; Jump if equal
		neg	ax
loc_b_1409:
		mov	bl,byte ptr data_a_0028
		mov	bh,0
		add	ax,bx
		neg	ax
		mov	data_a_0B5C,ax
		mov	data_a_0B54,80h
		mov	bl,byte ptr data_a_0028
		mov	byte ptr data_a_0026,bl
		mov	bh,0
		mov	ax,data_a_003F
		sub	ax,bx
		mov	data_a_0049,ax
		mov	bx,offset data_a_074B
		mov	[bx+2],ax
		mov	ax,data_a_003D
		mov	[bx],ax
		mov	data_a_0B5E,2
		retn
sub_b_1373	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_143F	proc	near
		mov	bx,data_a_004D
		cmp	data_a_004B,bx
		jb	loc_b_1470		; Jump if below
		jz	loc_b_1470		; Jump if zero
		add	data_a_004F,bx
		mov	al,byte ptr data_a_0028+1
		cbw				; Convrt byte to word
		add	data_a_003D,ax
		mov	bx,data_a_004B
		cmp	data_a_004F,bx
		jb	loc_b_1496		; Jump if below
		sub	data_a_004F,bx
		mov	al,data_a_002A
		cbw				; Convrt byte to word
		add	data_a_003F,ax
		jmp	short loc_b_1496
		db	90h
loc_b_1470:
		mov	al,data_a_002A
		cbw				; Convrt byte to word
		add	data_a_003F,ax
		mov	bx,data_a_004B
		add	data_a_004F,bx
		mov	bx,data_a_004D
		cmp	data_a_004F,bx
		jb	loc_b_1496		; Jump if below
		sub	data_a_004F,bx
		mov	al,byte ptr data_a_0028+1
		cbw				; Convrt byte to word
		add	data_a_003D,ax
loc_b_1496:
		test	data_a_0000,40h		; '@'
		jz	loc_b_14A3		; Jump if zero
		call	sub_b_0D64
		jmp	short loc_b_14FB
		db	90h
loc_b_14A3:
		mov	cl,0
		mov	ax,data_a_003F
		sub	ax,data_a_0047
		jnc	loc_b_14B0		; Jump if carry=0
		neg	ax
loc_b_14B0:
		mov	data_a_0B52,ax
		mul	al			; ax = reg * al
		mov	bx,0Ah
		mul	bx			; dx:ax = reg * ax
		mov	bx,data_a_0B5A
		cmp	bx,data_a_0B58
		je	loc_b_14C6		; Jump if equal
		mov	cl,1
loc_b_14C6:
		div	bx			; ax,dx rem=dx:ax/reg
		cmp	cl,0
		je	loc_b_14CF		; Jump if equal
		neg	ax
loc_b_14CF:
		push	ax
		mov	cl,0
		mov	ax,data_a_0B5C
		cmp	ax,0
		jns	loc_b_14DE		; Jump if not sign
		mov	cl,1
		neg	ax
loc_b_14DE:
		mul	data_a_0B52		; dx:ax = data * ax
		div	data_a_0B50		; ax,dxrem=dx:ax/data
		cmp	cl,0
		je	loc_b_14ED		; Jump if equal
		neg	ax
loc_b_14ED:
		pop	bx
		add	ax,bx
		mov	bl,byte ptr data_a_0028
		mov	bh,0
		add	ax,bx
		mov	byte ptr data_a_0026,al
loc_b_14FB:
		cmp	data_a_003F,38h
		jb	loc_b_1519		; Jump if below
		cmp	data_a_003F,0C8h
		jae	loc_b_1519		; Jump if above or =
		cmp	data_a_003D,1
		jb	loc_b_1519		; Jump if below
		cmp	data_a_003D,140h
		jb	loc_b_1529		; Jump if below
loc_b_1519:
		and	data_a_0000,0EFh
		and	data_a_0000,0BFh
		call	sub_b_26A9
		jmp	loc_ret_b_15F2
loc_b_1529:
		mov	bx,offset data_a_0755
		cmp	data_a_003F,80h
		jae	loc_b_1542		; Jump if above or =
		cmp	data_a_003F,74h
		jb	loc_b_1542		; Jump if below
		mov	byte ptr [bx+4],0
		jmp	short loc_b_1546
		db	90h
loc_b_1542:
		mov	byte ptr [bx+4],1
loc_b_1546:
		mov	ax,data_a_003D
		mov	[bx],ax
		mov	ax,data_a_003F
		mov	[bx+2],ax
		mov	si,offset data_a_0059
		mov	ax,data_a_003F
		mov	bl,byte ptr data_a_0026
		mov	bh,0
		sub	ax,bx
		mov	data_a_0049,ax
		mov	bx,offset data_a_074B
		mov	[bx+2],ax
		mov	ax,data_a_003D
		mov	[bx],ax
		cmp	data_a_003F,7Eh
		je	loc_b_158C		; Jump if equal
		jnc	loc_b_15AC		; Jump if carry=0
		cmp	data_a_0B5E,2
		jne	loc_b_15AC		; Jump if not equal
		cmp	data_a_002A,1
		je	loc_b_15AC		; Jump if equal
		and	data_a_0001[si],0BFh
		jmp	short loc_b_15AC
		db	90h
loc_b_158C:
		cmp	data_a_002A,1
		jne	loc_b_1598		; Jump if not equal
;*		and	data_a_0000[si],0BFh
		db	 80h,0A4h, 00h, 00h,0BFh	;  Fixup - byte match
loc_b_1598:
		cmp	byte ptr data_a_0026,0Ch
		jae	loc_b_15AC		; Jump if above or =
		and	data_a_0000,0EFh
		mov	data_a_002B,0FFh
		call	sub_b_15F3
loc_b_15AC:
		cmp	byte ptr data_a_0026,0
		je	loc_b_15B5		; Jump if equal
		jns	loc_ret_b_15F2		; Jump if not sign
loc_b_15B5:
		mov	data_a_0051,0B5Fh
		or	data_a_0000,40h		; '@'
		call	sub_b_2681
		cmp	data_a_002B,0FFh
		jne	loc_b_15E2		; Jump if not equal
;*		or	data_a_0000[si],40h	; '@'
		db	 80h, 8Ch, 00h, 00h, 40h	;  Fixup - byte match
		or	data_a_0001[si],40h	; '@'
		dec	data_a_002B
		push	si
		mov	si,0B91h
		mov	dl,11h
		call	sub_b_260E
		pop	si
loc_b_15E2:
		dec	data_a_0B5E
		jnz	loc_ret_b_15F2		; Jump if not zero
;*		or	data_a_0000[si],40h	; '@'
		db	 80h, 8Ch, 00h, 00h, 40h	;  Fixup - byte match
		or	data_a_0001[si],40h	; '@'

loc_ret_b_15F2:
		retn
sub_b_143F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_15F3	proc	near
		call	sub_b_2681
		mov	si,offset data_a_074B
		mov	di,offset data_a_0755
		mov	bx,offset data_a_0B95
		cmp	data_a_000F,0
		jne	loc_b_1610		; Jump if not equal
		cmp	data_a_000B,0
		je	loc_b_1632		; Jump if equal
		jmp	short loc_b_1617
		db	90h
loc_b_1610:
		cmp	data_a_000C,0
		je	loc_b_1632		; Jump if equal
loc_b_1617:
		mov	word ptr [si+2],6Dh
		mov	word ptr [di+2],6Eh
		mov	word ptr [bx],1Ch
		mov	word ptr [bx+2],5Bh
		mov	word ptr [bx+0Ah],0C52h
		jmp	short loc_b_164A
		db	90h
loc_b_1632:
		mov	word ptr [si+2],87h
		mov	word ptr [di+2],88h
		mov	word ptr [bx],10h
		mov	word ptr [bx+2],7Bh
		mov	word ptr [bx+0Ah],0BAAh
loc_b_164A:
		call	sub_b_0317
		mov	si,offset data_a_0059
		mov	di,offset data_a_0835
		mov	bx,word ptr data_a_004B+1[di]
		mov	ax,[bx]
		mov	data_a_001C[si],ax
		cmp	word ptr [bx+2],8Fh
		jae	loc_b_166D		; Jump if above or =
		mov	data_a_0020[si],8Fh
		jmp	short loc_b_1674
		db	90h
loc_b_166D:
		mov	ax,[bx+2]
		mov	data_a_0020[si],ax
loc_b_1674:
		add	si,2
		mov	bx,word ptr data_a_004D+1[di]
		mov	ax,[bx]
		mov	data_a_001C[si],ax
		cmp	word ptr [bx+2],3Dh
		jb	loc_b_1690		; Jump if below
		mov	data_a_0020[si],3Dh
		jmp	short loc_b_1697
		db	90h
loc_b_1690:
		mov	ax,[bx+2]
		mov	data_a_0020[si],ax
loc_b_1697:
		call	sub_b_24C1
		mov	si,offset data_a_0B95
		call	sub_b_1B34
		mov	si,offset data_a_074B
		mov	cx,[si]
		sub	cx,0Fh
		mov	bx,offset data_a_0B95
		mov	word ptr [bx+0Dh],4
		mov	ax,[bx]
		mov	data_a_0CFA,ax
		mov	di,offset data_a_0CFE
loc_b_16B8:
		mov	bp,[di]
		mov	[bx+4],bp
		inc	di
		inc	di
		cmp	di,0D06h
		jne	loc_b_16C8		; Jump if not equal
		mov	di,0CFEh
loc_b_16C8:
		push	bx
		push	di
		push	cx
		mov	si,bx
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		mov	si,offset data_a_0B95
		call	sub_b_1B34
		mov	data_a_0053,0A00h
		call	sub_b_1109
		pop	cx
		pop	di
		pop	bx
		add	word ptr [bx],4
		cmp	[bx],cx
		jb	loc_b_16B8		; Jump if below
		mov	si,74Bh
		mov	byte ptr [si+4],0
		mov	si,755h
		mov	byte ptr [si+4],0
		call	sub_b_0317
		mov	si,offset data_a_0B95
		mov	word ptr [si+4],5D0Eh
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		mov	si,offset data_a_0B95
		call	sub_b_1B34
		mov	data_a_0053,3000h
		call	sub_b_1109
		mov	si,offset data_a_0B95
		mov	word ptr [si+4],5750h
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		mov	si,offset data_a_0B95
		call	sub_b_1B34
		mov	data_a_0053,3000h
		call	sub_b_1109
		mov	cx,data_a_0CFA
		mov	bx,offset data_a_0B95
		mov	word ptr [bx+0Dh],0
		mov	di,offset data_a_0D08
loc_b_174F:
		mov	bp,[di]
		mov	[bx+4],bp
		inc	di
		inc	di
		cmp	di,0D10h
		jne	loc_b_175F		; Jump if not equal
		mov	di,0D08h
loc_b_175F:
		push	bx
		push	di
		push	cx
		mov	si,bx
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		mov	si,offset data_a_0B95
		call	sub_b_1B34
		mov	data_a_0053,0A00h
		call	sub_b_1109
		pop	cx
		pop	di
		pop	bx
		sub	word ptr [bx],4
		cmp	cx,[bx]
		jb	loc_b_174F		; Jump if below
		mov	si,offset data_a_0B95
		mov	word ptr [si+4],5D0Eh
		call	sub_b_1ADB
		mov	si,offset data_a_0B95
		call	sub_b_1B8B
		retn
sub_b_15F3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1798	proc	near
		mov	bx,offset data_a_0000
loc_b_179B:
		mov	si,data_a_0CFC[bx]
		mov	di,data_a_0D06[bx]
		push	bx
		call	sub_b_17B0
		pop	bx
		inc	bx
		inc	bx
		cmp	bx,0Ah
		jne	loc_b_179B		; Jump if not equal
		retn
sub_b_1798	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_17B0	proc	near
		mov	cx,15h

locloop_b_17B3:
		mov	bx,offset data_a_000E
loc_b_17B6:
		dec	bx
		mov	al,[bx+si]
		ror	al,1			; Rotate
		ror	al,1			; Rotate
		ror	al,1			; Rotate
		ror	al,1			; Rotate
		mov	[di],al
		inc	di
		cmp	bx,0
		jne	loc_b_17B6		; Jump if not equal
		add	si,0Eh
		loop	locloop_b_17B3		; Loop if cx > 0

		retn
sub_b_17B0	endp

			                        ;* No entry point to code
		add	data_c_0059[bp],bh
		add	si,data_a_002F
		mov	di,offset data_a_0835
		add	di,data_a_002F
		add	di,data_a_002F
;*		test	data_a_0000[si],40h	; '@'
		db	0F6h, 84h, 00h, 00h, 40h	;  Fixup - byte match
		jz	loc_b_17EA		; Jump if zero
		retn
loc_b_17EA:
		cmp	byte ptr data_a_0026,21h	; '!'
		jbe	loc_b_17F2		; Jump if below or =
		retn
loc_b_17F2:
		call	sub_b_19FC
		cmp	data_a_0D14,0
		jne	loc_b_17FD		; Jump if not equal
		retn
loc_b_17FD:
		and	data_a_0000,0DFh
;*		or	data_a_0000[si],40h	; '@'
		db	 80h, 8Ch, 00h, 00h, 40h	;  Fixup - byte match
		mov	data_a_002E,0
		mov	byte ptr data_a_0026+1,14h
		push	si
		mov	ax,data_a_002F
		dec	ax
		neg	ax
		mov	si,offset data_a_0059
		add	si,ax
;*		and	data_a_0000[si],0DFh
		db	 80h,0A4h, 00h, 00h,0DFh	;  Fixup - byte match
		pop	si
		call	sub_b_2695
		call	sub_b_19A9
		cmp	data_a_0D15,4
		jb	loc_b_187A		; Jump if below
		cmp	data_a_000C[si],0
		jne	loc_b_187A		; Jump if not equal
		push	di
		mov	ax,data_a_002F
		dec	ax
		neg	ax
		mov	di,offset data_a_0835
		add	di,ax
		add	di,ax
		mov	bx,word ptr data_a_004B+1[di]
		mov	ax,[bx]
		mov	word ptr data_a_0D10,ax
		mov	ax,[bx+2]
		mov	data_a_0D12,ax
		mov	al,data_a_0D15
		mov	data_a_0D16,al
		call	sub_b_19A9
		pop	di
		mov	al,data_a_0D15
		mov	bl,data_a_0D16
		mov	data_a_0D15,bl
		cmp	al,4
		jae	loc_b_188B		; Jump if above or =
		mov	data_a_000C[si],2
		mov	byte ptr data_a_0026+1,3Ch	; '<'
		jmp	short loc_b_188B
		db	90h
loc_b_187A:
		cmp	data_a_000C[si],2
		jne	loc_b_188B		; Jump if not equal
		or	data_a_0000,20h		; ' '
		mov	byte ptr data_a_0026+1,11h
loc_b_188B:
		mov	al,data_a_0D14
		dec	al
		cbw				; Convrt byte to word
		mov	cl,18h
		mul	cl			; ax = reg * al
		mov	cl,data_a_000C[si]
		shl	cl,1			; Shift w/zeros fill
		shl	cl,1			; Shift w/zeros fill
		shl	cl,1			; Shift w/zeros fill
		mov	ch,0
		push	di
		mov	di,data_a_002F
		add	di,data_a_002F
		mov	bx,data_a_0D17[di]
		pop	di
		add	bx,ax
		add	bx,cx
		mov	cl,data_a_0D15
		add	bx,cx
loc_b_18B9:
		push	di
		mov	di,data_a_002F
		add	di,data_a_002F
		mov	cl,[bx]
		mov	data_a_002B,0
		and	data_a_0000,0FBh
		or	data_a_0000,8
		mov	data_a_000F,0
		mov	al,data_a_000B
		mov	ah,0
		cmp	ax,data_a_002F
		je	loc_b_18E8		; Jump if equal
		mov	data_a_000F,2
loc_b_18E8:
		call	sub_b_0FA0
		rcr	al,1			; Rotate thru carry
		jc	loc_b_18FA		; Jump if carry Set
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		jmp	short loc_b_18FD
		db	90h
loc_b_18FA:
		and	cl,0Fh
loc_b_18FD:
		dec	cl
		mov	bx,data_a_0D1B[di]
		mov	ch,0
		mov	dx,cx
		shl	dx,1			; Shift w/zeros fill
		add	bx,dx
		mov	ax,[bx]
		mov	data_a_0041,ax
		add	bx,10h
		mov	ax,[bx]
		mov	data_a_0043,ax
		call	sub_b_0FA0
		cmp	al,5
		jae	loc_b_1927		; Jump if above or =
		mov	byte ptr data_a_0026+1,9
		jmp	short loc_b_194A
		db	90h
loc_b_1927:
		cmp	al,0Dh
		jae	loc_b_194A		; Jump if above or =
		mov	data_a_002B,0FFh
		mov	bx,data_a_0D1F[di]
		add	bx,cx
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	data_a_0041,ax
		add	bx,8
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	data_a_0043,ax
		jmp	short loc_b_197A
		db	90h
loc_b_194A:
		call	sub_b_0FA0
		and	al,1Fh
		mov	ah,0
		add	data_a_0041,ax
		call	sub_b_0FA0
		mov	cl,5
		shr	al,cl			; Shift w/zeros fill
		mov	ah,0
		add	data_a_0041,ax
		call	sub_b_0FA0
		and	al,7
		mov	ah,0
		add	data_a_0043,ax
		call	sub_b_0FA0
		mov	cl,4
		shr	al,cl			; Shift w/zeros fill
		mov	ah,0
		add	data_a_0043,ax
loc_b_197A:
		pop	di
		mov	ax,data_a_003D
		mov	data_a_0045,ax
		cmp	data_a_002F,0
		je	loc_b_1994		; Jump if equal
		dec	data_a_003F
		dec	data_a_003F
		dec	data_a_003F
loc_b_1994:
		mov	ax,data_a_003F
		mov	data_a_0047,ax
		mov	al,byte ptr data_a_0026
		inc	al
		mov	byte ptr data_a_0028,al
		call	sub_b_1320
		call	sub_b_1373

loc_ret_b_19A8:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_19A9	proc	near
		mov	ax,word ptr data_a_0D10
		cmp	ax,data_a_0028[di]
		jae	loc_b_19C2		; Jump if above or =
		cmp	ax,data_a_002C[di]
		jae	loc_b_19BD		; Jump if above or =
		mov	cl,0
		jmp	short loc_b_19CF
		db	90h
loc_b_19BD:
		mov	cl,1
		jmp	short loc_b_19CF
		db	90h
loc_b_19C2:
		cmp	ax,word ptr data_a_002F+1[di]
		jae	loc_b_19CD		; Jump if above or =
		mov	cl,2
		jmp	short loc_b_19CF
		db	90h
loc_b_19CD:
		mov	cl,3
loc_b_19CF:
		mov	ax,data_a_0D12
		cmp	di,offset data_a_0835
		jne	loc_b_19E9		; Jump if not equal
		cmp	ax,word ptr data_a_0033+1[di]
		jb	loc_b_19F7		; Jump if below
		inc	cl
		inc	cl
		inc	cl
		inc	cl
		jmp	short loc_b_19F7
		db	90h
loc_b_19E9:
		cmp	ax,word ptr data_a_0033+1[di]
		jae	loc_b_19F7		; Jump if above or =
		inc	cl
		inc	cl
		inc	cl
		inc	cl
loc_b_19F7:
		mov	data_a_0D15,cl
		retn
sub_b_19A9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_19FC	proc	near
		mov	data_a_0D14,0
		mov	bx,word ptr data_a_004B+1[di]
		mov	ax,[bx]
		mov	word ptr data_a_0D10,ax
		mov	ax,[bx+2]
		mov	data_a_0D12,ax
		push	di
		mov	di,si
		add	di,data_a_002F
		mov	ax,data_a_0026[di]
		pop	di
		cmp	ax,5AFh
		je	loc_b_1A3A		; Jump if equal
		cmp	ax,587h
		je	loc_b_1A3A		; Jump if equal
		cmp	ax,59Bh
		jz	$+2			; delay for I/O
		mov	al,data_a_0024[si]
		shr	al,1			; Shift w/zeros fill
		dec	al
		cmp	al,3
		jb	loc_b_1A4A		; Jump if below
		jmp	loc_ret_b_1ABD
loc_b_1A3A:
		mov	al,data_a_0024[si]
		shr	al,1			; Shift w/zeros fill
		dec	al
		cmp	al,2
		jae	loc_ret_b_1ABD		; Jump if above or =
		neg	al
		add	al,4
loc_b_1A4A:
		cmp	data_a_002F,0
		je	loc_b_1A53		; Jump if equal
		add	al,14h
loc_b_1A53:
		mov	dl,al
		mov	dh,0
		mov	bp,word ptr data_a_0D10
		mov	bx,offset data_a_0D23
		add	bx,dx
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	ax,bp
		mov	cx,data_a_003D
		cmp	cx,ax
		jb	loc_ret_b_1ABD		; Jump if below
		mov	bp,word ptr data_a_0D10
		mov	bx,offset data_a_0D28
		add	bx,dx
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	ax,bp
		mov	cx,data_a_003D
		cmp	cx,ax
		jae	loc_ret_b_1ABD		; Jump if above or =
		mov	bp,data_a_0D12
		mov	bx,offset data_a_0D2D
		add	bx,dx
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	ax,bp
		mov	cx,data_a_0049
		cmp	cx,ax
		jb	loc_ret_b_1ABD		; Jump if below
		mov	bp,data_a_0D12
		mov	bx,offset data_a_0D32
		add	bx,dx
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	ax,bp
		mov	cx,data_a_0049
		cmp	cx,ax
		jae	loc_ret_b_1ABD		; Jump if above or =
		cmp	dl,14h
		jb	loc_b_1AB7		; Jump if below
		sub	dl,14h
loc_b_1AB7:
		inc	dl
		mov	data_a_0D14,dl

loc_ret_b_1ABD:
		retn
sub_b_19FC	endp

		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1AC0	proc	near
		push	ds
		pop	es
		mov	bx,offset data_a_05F3
loc_b_1AC5:
		mov	si,[bx]
		mov	di,si
		mov	cx,[bx+2]
		shr	cx,1			; Shift w/zeros fill
		call	sub_b_2ACC
		add	bx,4
		cmp	word ptr [bx+2],0
		jne	loc_b_1AC5		; Jump if not equal
		retn
sub_b_1AC0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1ADB	proc	near
		mov	ax,[si+0Ah]
		mov	di,ax
		mov	ax,[si+4]
		mov	bx,ax
		mov	ax,[si]
		mov	cx,ax
		mov	al,[si+2]
		mov	dl,al
		mov	bp,si
		call	sub_b_1B70
		mov	ax,ds:[bp+8]
		mov	cx,ax

locloop_b_1AF9:
		add	si,offset data_a_62D0
		mov	bp,cx
		mov	cx,7

locloop_b_1B02:
		xor	ah,ah			; Zero register
		mov	al,[bx]
		mov	dx,bx
		mov	bx,ax
		mov	ah,data_a_0EAC[bx]
		mov	bx,dx
		mov	dh,ah
		mov	ah,[si]
		mov	[di],ah
		and	ah,dh
		not	dh
		and	al,dh
		or	ah,al
		mov	[si],ah
		inc	bx
		inc	si
		inc	di
		loop	locloop_b_1B02		; Loop if cx > 0

		sub	si,8287h
		jnc	loc_b_1B2F		; Jump if carry=0
		add	si,3FB0h
loc_b_1B2F:
		mov	cx,bp
		loop	locloop_b_1AF9		; Loop if cx > 0

		retn
sub_b_1ADB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1B34	proc	near
		mov	ax,ds
		mov	es,ax
		mov	ax,[si]
		mov	cx,ax
		mov	al,[si+2]
		mov	dl,al
		mov	di,si
		call	sub_b_1B70
		mov	ax,[di+8]
		mov	cx,ax
		mov	ax,[di+0Ah]
		mov	di,si
		mov	si,ax
		mov	dx,7
		mov	bx,62D0h
		mov	bp,8287h

locloop_b_1B5B:
		add	di,bx
		mov	ax,cx
		mov	cx,dx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		jnc	loc_b_1B6B		; Jump if carry=0
		add	di,3FB0h
loc_b_1B6B:
		mov	cx,ax
		loop	locloop_b_1B5B		; Loop if cx > 0

		retn
sub_b_1B34	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1B70	proc	near
		push	cx
		push	dx
		mov	si,0
		shr	dl,1			; Shift w/zeros fill
		jnc	loc_b_1B7C		; Jump if carry=0
		mov	si,2000h
loc_b_1B7C:
		mov	al,50h			; 'P'
		mul	dl			; ax = reg * al
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		add	ax,cx
		add	si,ax
		pop	dx
		pop	cx
		retn
sub_b_1B70	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1B8B	proc	near
		mov	ax,[si]
		sub	ax,[si+0Dh]
		mov	cx,ax
		mov	al,[si+2]
		sub	al,[si+0Fh]
		mov	dl,al
		mov	di,si
		call	sub_b_1B70
		mov	ax,[di+13h]
		mov	cx,ax
		mov	ax,[di+11h]
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	dx,ax
		mov	bx,62D0h
		mov	bp,8280h
		mov	di,d_B800_B800_e
		mov	es,di

locloop_b_1BB8:
		mov	di,si
		add	si,bx
		mov	ax,cx
		mov	cx,dx
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	si,dx
		sub	si,dx
		sub	si,bp
		jnc	loc_b_1BCE		; Jump if carry=0
		add	si,3FB0h
loc_b_1BCE:
		mov	cx,ax
		loop	locloop_b_1BB8		; Loop if cx > 0

		retn
sub_b_1B8B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1BD3	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_a_0755
		cmp	byte ptr [si+4],1
		jne	loc_b_1BFF		; Jump if not equal
		mov	cx,[si]
		mov	dx,[si+2]
		call	sub_b_1B70
		or	byte ptr es:[si],0A0h
		and	byte ptr es:[si],0AFh
		add	dx,1
		call	sub_b_1B70
		or	byte ptr es:[si],0A0h
		and	byte ptr es:[si],0AFh
loc_b_1BFF:
		mov	si,offset data_a_074B
		cmp	byte ptr [si+4],1
		jne	loc_ret_b_1C1E		; Jump if not equal
		mov	cx,[si]
		mov	dx,[si+2]
		call	sub_b_1B70
		and	byte ptr es:[si],0Fh
		add	dx,1
		call	sub_b_1B70
		and	byte ptr es:[si],0Fh

loc_ret_b_1C1E:
		retn
sub_b_1BD3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1C1F	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_a_0750
		mov	cx,[si]
		mov	dx,[si+2]
		call	sub_b_1B70
		mov	di,si
		add	si,offset data_a_62D0
		mov	al,[si]
		mov	es:[di],al
		mov	al,[si+50h]
		mov	es:[di+50h],al
		add	dx,1
		call	sub_b_1B70
		mov	di,si
		add	si,offset data_a_62D0
		mov	al,[si]
		mov	es:[di],al
		mov	si,offset data_a_075A
		mov	cx,[si]
		mov	dx,[si+2]
		call	sub_b_1B70
		mov	di,si
		add	si,offset data_a_62D0
		mov	al,[si]
		mov	es:[di],al
		add	dx,1
		call	sub_b_1B70
		mov	di,si
		add	si,offset data_a_62D0
		mov	al,[si]
		mov	es:[di],al
		retn
sub_b_1C1F	endp

		db	0, 0, 0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1C80	proc	near
		mov	cx,data_a_002F
		mov	si,offset data_a_0059
		mov	di,835h
		add	si,cx
		add	di,cx
		add	di,cx
;*		test	data_a_0000[si],8
		db	0F6h, 84h, 00h, 00h, 08h	;  Fixup - byte match
		jz	loc_b_1CA0		; Jump if zero
		call	sub_b_0922
		call	sub_b_1FE9
		jmp	short loc_b_1CA3
		db	90h
loc_b_1CA0:
		call	sub_b_1D91
loc_b_1CA3:
		mov	cx,data_a_002F
		add	si,cx
		mov	bx,word ptr data_a_004B+1[di]
		mov	ax,[bx]
		cmp	word ptr [bx+4],1F58h
		jne	loc_b_1CB9		; Jump if not equal
		add	ax,6
loc_b_1CB9:
		cmp	word ptr [bx+4],2708h
		jne	loc_b_1CC3		; Jump if not equal
		sub	ax,6
loc_b_1CC3:
		mov	data_a_0014[si],ax
		mov	ax,[bx+2]
		mov	data_a_0018[si],ax
		sub	si,cx
;*		test	data_a_0000[si],20h	; ' '
		db	0F6h, 84h, 00h, 00h, 20h	;  Fixup - byte match
		jz	loc_b_1CE0		; Jump if zero
loc_b_1CD7:
		call	sub_b_1D01
		call	sub_b_1D57
		jmp	short loc_ret_b_1D00
		db	90h
loc_b_1CE0:
;*		test	data_a_0000[si],10h
		db	0F6h, 84h, 00h, 00h, 10h	;  Fixup - byte match
		jz	loc_b_1CF2		; Jump if zero
		call	sub_b_1DF8
;*		and	data_a_0000[si],0EFh
		db	 80h,0A4h, 00h, 00h,0EFh	;  Fixup - byte match
		jmp	short loc_b_1CF5
		db	90h
loc_b_1CF2:
		call	sub_b_1EF1
loc_b_1CF5:
;*		or	data_a_0000[si],20h	; ' '
		db	 80h, 8Ch, 00h, 00h, 20h	;  Fixup - byte match
		mov	cx,data_a_002F
		jmp	short loc_b_1CD7

loc_ret_b_1D00:
		retn
sub_b_1C80	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1D01	proc	near
		add	si,cx
		mov	data_a_0002,0
		mov	ax,data_a_0020[si]
		cmp	ax,data_a_0018[si]
		je	loc_b_1D28		; Jump if equal
		inc	ax
		cmp	ax,data_a_0018[si]
		jb	loc_b_1D23		; Jump if below
		jz	loc_b_1D28		; Jump if zero
		mov	data_a_0002,1
		jmp	short loc_b_1D28
		db	90h
loc_b_1D23:
		mov	data_a_0002,0FFh
loc_b_1D28:
		mov	data_a_0001,0
		mov	ax,data_a_001C[si]
		sub	ax,data_a_0039
		cmp	ax,data_a_0014[si]
		je	loc_b_1D54		; Jump if equal
		jnc	loc_b_1D4F		; Jump if carry=0
		add	ax,data_a_003B
		cmp	ax,data_a_0014[si]
		jae	loc_b_1D54		; Jump if above or =
		mov	data_a_0001,0FFh
		jmp	short loc_b_1D54
		db	90h
loc_b_1D4F:
		mov	data_a_0001,1
loc_b_1D54:
		sub	si,cx
		retn
sub_b_1D01	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1D57	proc	near
		mov	di,si
		add	di,cx
		dec	data_a_0002[si]
		jz	loc_b_1D64		; Jump if zero
		jmp	loc_b_07E6
loc_b_1D64:
		mov	al,data_a_0009
		mov	data_a_0002[si],al
		test	data_a_0000,20h		; ' '
		jz	loc_b_1D80		; Jump if zero
		dec	data_a_0004[si]
		jz	loc_b_1D7B		; Jump if zero
		jmp	loc_b_07E6
loc_b_1D7B:
		mov	data_a_0004[si],2
loc_b_1D80:
		cmp	data_a_002F,0
		jne	loc_b_1D8E		; Jump if not equal
		mov	bx,87h
		mov	byte ptr [bx+0Ch],1
loc_b_1D8E:
		jmp	loc_b_04D6
sub_b_1D57	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1D91	proc	near
		push	di
		mov	di,offset data_a_0FB0
		add	di,data_a_002F
;*		test	data_a_0000[si],40h	; '@'
		db	0F6h, 84h, 00h, 00h, 40h	;  Fixup - byte match
		jnz	loc_b_1DF6		; Jump if not zero
;*		and	data_a_0000[si],0F7h
		db	 80h,0A4h, 00h, 00h,0F7h	;  Fixup - byte match
		add	si,data_a_002F
		mov	dx,data_a_0014[si]
		mov	al,[di+6]
		cbw				; Convrt byte to word
		add	ax,dx
		cmp	data_a_003D,ax
		jb	loc_b_1DF2		; Jump if below
		mov	dx,data_a_0014[si]
		mov	al,[di+8]
		cbw				; Convrt byte to word
		add	ax,dx
		cmp	data_a_003D,ax
		je	loc_b_1DCB		; Jump if equal
		jnc	loc_b_1DF2		; Jump if carry=0
loc_b_1DCB:
		mov	ax,data_a_0018[si]
		add	ax,0
		cmp	data_a_0049,ax
		jb	loc_b_1DF2		; Jump if below
		mov	ax,data_a_0018[si]
		add	ax,16h
		cmp	data_a_0049,ax
		je	loc_b_1DE7		; Jump if equal
		jnc	loc_b_1DF2		; Jump if carry=0
loc_b_1DE7:
		sub	si,data_a_002F
		call	sub_b_08BE
		add	si,data_a_002F
loc_b_1DF2:
		sub	si,data_a_002F
loc_b_1DF6:
		pop	di
		retn
sub_b_1D91	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1DF8	proc	near
		add	si,data_a_002F
		call	sub_b_0FA0
		mov	bl,data_a_0007
		mov	bh,0
		add	bx,offset data_a_1065
		cmp	al,[bx]
		jae	loc_b_1E20		; Jump if above or =
		mov	ax,word ptr data_a_0037+1[di]
		mov	data_a_001C[si],ax
		mov	ax,word ptr data_a_003B+1[di]
		mov	data_a_0020[si],ax
		jmp	short loc_b_1E57
		db	90h
loc_b_1E20:
		add	bx,3
		cmp	al,[bx]
		jae	loc_b_1E3A		; Jump if above or =
		mov	ax,data_a_0014[si]
		mov	data_a_001C[si],ax
		mov	ax,data_a_0018[si]
		mov	data_a_0020[si],ax
		jmp	short loc_b_1E57
		db	90h
loc_b_1E3A:
		mov	al,data_a_0007
		or	al,al			; Zero ?
		jnz	loc_b_1E54		; Jump if not zero
		mov	ax,word ptr data_a_0037+1[di]
		mov	data_a_001C[si],ax
		mov	ax,data_a_0018[si]
		mov	data_a_0020[si],ax
		jmp	short loc_b_1E57
		db	90h
loc_b_1E54:
		call	sub_b_1E5C
loc_b_1E57:
		sub	si,data_a_002F
		retn
sub_b_1DF8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1E5C	proc	near
		mov	ax,data_a_0041
		cmp	ax,0A0h
		jae	loc_b_1E74		; Jump if above or =
		cmp	ax,word ptr data_a_0043+1[di]
		jae	loc_b_1E6F		; Jump if above or =
		mov	ch,0
		jmp	short loc_b_1E81
		db	90h
loc_b_1E6F:
		mov	ch,1
		jmp	short loc_b_1E81
		db	90h
loc_b_1E74:
		cmp	ax,word ptr data_a_003F+1[di]
		jae	loc_b_1E7F		; Jump if above or =
		mov	ch,2
		jmp	short loc_b_1E81
		db	90h
loc_b_1E7F:
		mov	ch,3
loc_b_1E81:
		shl	ch,1			; Shift w/zeros fill
		shl	ch,1			; Shift w/zeros fill
		mov	dx,data_a_002F
		mov	cl,4
		shl	dl,cl			; Shift w/zeros fill
		add	ch,dl
		cmp	dl,0
		jne	loc_b_1EB2		; Jump if not equal
		mov	ax,data_a_0043
		cmp	ax,word ptr data_a_0047+1[di]
		jb	loc_b_1ECC		; Jump if below
		jz	loc_b_1ECC		; Jump if zero
		mov	ax,data_a_0018[si]
		cmp	ax,word ptr data_a_0033+1[di]
		jb	loc_b_1ED9		; Jump if below
		jz	loc_b_1ED9		; Jump if zero
		inc	ch
		inc	ch
		jmp	short loc_b_1ED9
		db	90h
loc_b_1EB2:
		mov	ax,data_a_0043
		cmp	ax,word ptr data_a_0047+1[di]
		jae	loc_b_1ECC		; Jump if above or =
		mov	ax,data_a_0018[si]
		cmp	ax,word ptr data_a_0033+1[di]
		jae	loc_b_1ED9		; Jump if above or =
		inc	ch
		inc	ch
		jmp	short loc_b_1ED9
		db	90h
loc_b_1ECC:
		call	sub_b_0FA0
		mov	cl,4
		shr	al,cl			; Shift w/zeros fill
		jnc	loc_b_1ED9		; Jump if carry=0
		inc	ch
		inc	ch
loc_b_1ED9:
		mov	cl,ch
		mov	ch,0
		mov	bx,offset data_a_1025
		add	bx,cx
		mov	ax,[bx]
		mov	data_a_001C[si],ax
		inc	bx
		inc	bx
		mov	ax,[bx]
		mov	data_a_0020[si],ax
		retn
sub_b_1E5C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1EF1	proc	near
		add	si,data_a_002F
		mov	ax,data_a_0018[si]
		cmp	ax,word ptr data_a_0033+1[di]
		jb	loc_b_1F09		; Jump if below
		cmp	data_a_002F,0
		jne	loc_b_1F10		; Jump if not equal
		jmp	short loc_b_1F3F
		db	90h
loc_b_1F09:
		cmp	data_a_002F,0
		jne	loc_b_1F3F		; Jump if not equal
loc_b_1F10:
		cmp	byte ptr data_a_0026+1,3Ch	; '<'
		je	loc_b_1F3F		; Jump if equal
		push	di
		mov	di,0FB0h
		add	di,data_a_002F
		mov	ax,data_a_0018[si]
		mov	data_a_0020[si],ax
		cmp	data_a_002F,0
		jne	loc_b_1F54		; Jump if not equal
		mov	dx,data_a_0020[si]
		mov	al,data_a_0FB0
		cbw				; Convrt byte to word
		add	ax,dx
		mov	data_a_0020[si],ax
		jmp	short loc_b_1F54
		db	90h
loc_b_1F3F:
		push	di
		mov	di,offset data_a_0FB0
		add	di,data_a_002F
		mov	dx,data_a_0043
		mov	al,[di]
		cbw				; Convrt byte to word
		add	ax,dx
		mov	data_a_0020[si],ax
loc_b_1F54:
		call	sub_b_1FAA
		mov	ax,data_a_0020[si]
		add	ax,0FFF1h
		mov	data_a_0020[si],ax
		mov	ax,data_a_0014[si]
		cmp	ax,data_a_001C[si]
		jb	loc_b_1F8C		; Jump if below
		mov	dx,data_a_001C[si]
		mov	al,[di+4]
		cbw				; Convrt byte to word
		add	ax,dx
		mov	data_a_001C[si],ax
		pop	di
		sub	si,data_a_002F
;*		test	data_a_0000[si],2
		db	0F6h, 84h, 00h, 00h, 02h	;  Fixup - byte match
		jnz	loc_ret_b_1FA9		; Jump if not zero
		call	sub_b_08BE
		jmp	short loc_ret_b_1FA9
		db	90h
loc_b_1F8C:
		mov	dx,data_a_001C[si]
		mov	al,[di+2]
		cbw				; Convrt byte to word
		add	ax,dx
		mov	data_a_001C[si],ax
		pop	di
		sub	si,data_a_002F
;*		test	data_a_0000[si],2
		db	0F6h, 84h, 00h, 00h, 02h	;  Fixup - byte match
		jz	loc_ret_b_1FA9		; Jump if zero
		call	sub_b_08BE

loc_ret_b_1FA9:
		retn
sub_b_1EF1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1FAA	proc	near
		mov	bl,0
		mov	ax,data_a_0020[si]
		sub	ax,data_a_0043
		jnc	loc_b_1FBA		; Jump if carry=0
		inc	bl
		neg	ax
loc_b_1FBA:
		mov	cx,data_a_0041
		sub	cx,data_a_0045
		jnc	loc_b_1FC8		; Jump if carry=0
		inc	bl
		neg	cx
loc_b_1FC8:
		mul	cx			; dx:ax = reg * ax
		mov	cx,data_a_0043
		sub	cx,data_a_0047
		jnc	loc_b_1FD8		; Jump if carry=0
		inc	bl
		neg	cx
loc_b_1FD8:
		div	cx			; ax,dx rem=dx:ax/reg
		shr	bl,1			; Shift w/zeros fill
		jnc	loc_b_1FE0		; Jump if carry=0
		neg	ax
loc_b_1FE0:
		add	ax,data_a_0041
		mov	data_a_001C[si],ax
		retn
sub_b_1FAA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1FE9	proc	near
;*		test	data_a_0000[si],40h	; '@'
		db	0F6h, 84h, 00h, 00h, 40h	;  Fixup - byte match
		jz	loc_b_1FF3		; Jump if zero
		jmp	loc_ret_b_19A8
loc_b_1FF3:
		cmp	byte ptr data_a_0026,21h	; '!'
		je	loc_b_1FFF		; Jump if equal
		jc	loc_b_1FFF		; Jump if carry Set
		jmp	loc_ret_b_19A8
loc_b_1FFF:
		add	si,data_a_002F
		mov	ax,data_a_0026[si]
		cmp	ax,5AFh
		je	loc_b_2017		; Jump if equal
		cmp	ax,587h
		je	loc_b_2017		; Jump if equal
		mov	bx,0FBAh
		jmp	short loc_b_201A
			                        ;* No entry point to code
		nop
loc_b_2017:
		mov	bx,offset data_a_0FBE
loc_b_201A:
		add	bx,data_a_002F
		mov	dx,data_a_0014[si]
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	ax,dx
		cmp	data_a_003D,ax
		jb	loc_b_2058		; Jump if below
		mov	dx,data_a_0014[si]
		inc	bx
		inc	bx
		mov	al,[bx]
		cbw				; Convrt byte to word
		add	ax,dx
		cmp	data_a_003D,ax
		jae	loc_b_2058		; Jump if above or =
		mov	ax,data_a_0018[si]
		add	ax,0
		cmp	data_a_0049,ax
		jb	loc_b_2058		; Jump if below
		mov	ax,data_a_0018[si]
		add	ax,16h
		cmp	data_a_0049,ax
		jb	loc_b_205F		; Jump if below
loc_b_2058:
		sub	si,data_a_002F
		jmp	loc_ret_b_19A8
loc_b_205F:
		sub	si,data_a_002F
		and	data_a_0000,0DFh
;*		or	data_a_0000[si],40h	; '@'
		db	 80h, 8Ch, 00h, 00h, 40h	;  Fixup - byte match
;*		or	data_a_0000[si],10h
		db	 80h, 8Ch, 00h, 00h, 10h	;  Fixup - byte match
;*		and	data_a_0000[si],0DFh
		db	 80h,0A4h, 00h, 00h,0DFh	;  Fixup - byte match
		mov	byte ptr data_a_0026+1,14h
		call	sub_b_2695
		add	si,data_a_002F
		mov	ax,data_a_0014[si]
		mov	word ptr data_a_0D10,ax
		mov	ax,data_a_0018[si]
		mov	data_a_0D12,ax
		sub	si,data_a_002F
		call	sub_b_19A9
		mov	al,data_a_0D15
		mov	data_a_0D16,al
		push	si
		push	di
		mov	ax,data_a_002F
		dec	ax
		neg	ax
		mov	si,offset data_a_0059
		add	si,ax
		mov	di,offset data_a_0835
		add	di,ax
		add	di,ax
;*		and	data_a_0000[si],0DFh
		db	 80h,0A4h, 00h, 00h,0DFh	;  Fixup - byte match
;*		and	data_a_0000[si],0EFh
		db	 80h,0A4h, 00h, 00h,0EFh	;  Fixup - byte match
		mov	bx,word ptr data_a_004B+1[di]
		mov	ax,[bx]
		mov	word ptr data_a_0D10,ax
		mov	ax,[bx+2]
		mov	data_a_0D12,ax
		call	sub_b_19A9
		pop	di
		pop	si
		mov	al,data_a_0D16
		mov	cl,al
		cmp	al,2
		jb	loc_b_210C		; Jump if below
		cmp	al,4
		je	loc_b_210C		; Jump if equal
		cmp	al,5
		je	loc_b_210C		; Jump if equal
		jnc	loc_b_20E8		; Jump if carry=0
		mov	bl,3
		jmp	short loc_b_20EA
		db	90h
loc_b_20E8:
		mov	bl,0Bh
loc_b_20EA:
		sub	al,bl
		neg	al
		mov	cl,al
		mov	al,data_a_0D15
		cmp	al,2
		jb	loc_b_210C		; Jump if below
		cmp	al,4
		je	loc_b_210C		; Jump if equal
		cmp	al,5
		je	loc_b_210C		; Jump if equal
		jnc	loc_b_2106		; Jump if carry=0
		mov	bl,3
		jmp	short loc_b_2108
		db	90h
loc_b_2106:
		mov	bl,0Bh
loc_b_2108:
		sub	al,bl
		neg	al
loc_b_210C:
		mov	ch,al
		cmp	cl,2
		jb	loc_b_2117		; Jump if below
		dec	cl
		dec	cl
loc_b_2117:
		mov	al,18h
		mul	cl			; ax = reg * al
		mov	bx,0FC2h
		add	bx,ax
		mov	al,data_a_0007
		mov	ah,0
		mov	cl,3
		shl	al,cl			; Shift w/zeros fill
		add	bx,ax
		mov	al,data_a_0D15
		add	bx,ax
		mov	cl,data_a_0007
		mov	ch,0
		call	sub_b_0FA0
		push	bx
		mov	bx,offset data_a_1022
		add	bx,cx
		cmp	al,[bx]
		pop	bx
		jnc	loc_b_214C		; Jump if carry=0
		or	data_a_0000,20h		; ' '
		jmp	short loc_b_215B
		db	90h
loc_b_214C:
		cmp	bx,6Bh
		je	loc_b_2156		; Jump if equal
		cmp	bx,64h
		jne	loc_b_215B		; Jump if not equal
loc_b_2156:
		mov	byte ptr data_a_0026+1,3Ch	; '<'
loc_b_215B:
		jmp	loc_b_18B9
sub_b_1FE9	endp

		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2160	proc	near
		and	data_a_0000,7Fh
		cmp	data_a_002B,0
		je	loc_b_2186		; Jump if equal
		sub	data_a_000F,2
		neg	data_a_000F
		test	data_a_0000,8
		jnz	loc_b_2186		; Jump if not zero
		test	data_a_0000,4
		jz	loc_b_2186		; Jump if zero
		jmp	loc_ret_b_237B
loc_b_2186:
		or	data_a_0000,8
		mov	si,offset data_a_0059
		mov	di,si
		mov	al,data_a_000F
		shr	al,1			; Shift w/zeros fill
		mov	ah,0
		add	si,ax
		cmp	al,0
		jne	loc_b_219E		; Jump if not equal
		inc	di
loc_b_219E:
		inc	data_a_000E[si]
		test	data_a_0000,2
		jnz	loc_b_21AC		; Jump if not zero
		jmp	loc_b_2255
loc_b_21AC:
		mov	al,data_a_000E[si]
		cmp	al,6
		jb	loc_b_21F7		; Jump if below
		jz	loc_b_21C8		; Jump if zero
		dec	al
		cmp	al,data_a_000E[di]
		je	loc_b_21CF		; Jump if equal
		jc	loc_b_21F7		; Jump if carry Set
		and	data_a_0000,0FDh
		jmp	short loc_b_2238
		db	90h
loc_b_21C8:
		cmp	data_a_000E[di],6
		je	loc_b_21F7		; Jump if equal
loc_b_21CF:
		mov	al,data_a_0012[si]
		inc	al
		or	data_a_0000,80h
		cmp	al,data_a_0008
		jb	loc_b_21ED		; Jump if below
		push	si
		mov	si,10D4h
		mov	dl,0Eh
		call	sub_b_260E
		pop	si
		jmp	short loc_b_21F7
		db	90h
loc_b_21ED:
		push	si
		mov	si,10CAh
		mov	dl,0Fh
		call	sub_b_260E
		pop	si
loc_b_21F7:
		mov	al,data_a_000E[si]
		add	al,data_a_000E[di]
		mov	bl,al
		shr	bl,1			; Shift w/zeros fill
		jnc	loc_b_2219		; Jump if carry=0
		sub	data_a_000E,3
		neg	data_a_000E
		dec	data_a_0031
		neg	data_a_0031
		jmp	loc_b_22AF
loc_b_2219:
		mov	ah,0
		mov	bl,6
		div	bl			; al, ah rem = ax/reg
		cmp	ah,0
		je	loc_b_2227		; Jump if equal
		jmp	loc_b_22AF
loc_b_2227:
		dec	data_a_0031
		neg	data_a_0031
		call	sub_b_237C
		call	sub_b_2473
		jmp	loc_ret_b_237B
loc_b_2238:
		inc	data_a_0010[si]
		mov	data_a_000E[si],0
		mov	data_a_000E[di],0
		sub	data_a_000E,3
		neg	data_a_000E
		call	sub_b_26BD
		jmp	short loc_b_22B5
		db	90h
loc_b_2255:
		mov	al,data_a_000E[si]
		cmp	al,4
		jb	loc_b_2267		; Jump if below
		dec	al
		cmp	al,data_a_000E[di]
		je	loc_b_2267		; Jump if equal
		jnc	loc_b_2238		; Jump if carry=0
loc_b_2267:
		mov	al,data_a_000E[si]
		cmp	al,3
		jb	loc_b_22AF		; Jump if below
		cmp	al,data_a_000E[di]
		jb	loc_b_22AF		; Jump if below
		jz	loc_b_22AF		; Jump if zero
		mov	al,data_a_0010[si]
		cmp	al,5
		jb	loc_b_22AF		; Jump if below
		cmp	al,data_a_0010[di]
		jb	loc_b_22AF		; Jump if below
		jz	loc_b_22AF		; Jump if zero
		or	data_a_0000,80h
		mov	al,data_a_0012[si]
		inc	al
		cmp	al,data_a_0008
		jb	loc_b_22A5		; Jump if below
		push	si
		mov	si,10D4h
		mov	dl,0Eh
		call	sub_b_260E
		pop	si
		jmp	short loc_b_22AF
		db	90h
loc_b_22A5:
		push	si
		mov	si,10CAh
		mov	dl,0Fh
		call	sub_b_260E
		pop	si
loc_b_22AF:
		call	sub_b_237C
		jmp	loc_ret_b_237B
loc_b_22B5:
		cmp	data_a_0010[si],6
		jae	loc_b_22BF		; Jump if above or =
		jmp	loc_b_2354
loc_b_22BF:
		cmp	data_a_0010[di],6
		jne	loc_b_22F2		; Jump if not equal
		cmp	data_a_0010[si],6
		jne	loc_b_22D5		; Jump if not equal
		or	data_a_0000,2
		jmpn	loc_b_2354
loc_b_22D5:
		inc	data_a_0012[si]
		call	sub_b_2417
		mov	ah,data_a_0010[si]
		mov	al,data_a_0010[di]
		push	ax
		mov	data_a_0010[si],0
		mov	data_a_0010[di],0
		jmp	short loc_b_2301
		db	90h
loc_b_22F2:
		mov	al,data_a_0010[di]
		inc	al
		cmp	al,data_a_0010[si]
		jb	loc_b_22D5		; Jump if below
		jmp	short loc_b_2354
		db	90h
loc_b_2301:
		mov	al,data_a_0012[si]
		cmp	al,data_a_0008
		jne	loc_b_2310		; Jump if not equal
		or	data_a_0000,1
loc_b_2310:
		push	si
		mov	si,offset data_a_0835
		mov	al,data_a_000F
		shr	al,1			; Shift w/zeros fill
		mov	ah,0
		add	si,ax
		add	si,ax
		mov	si,word ptr data_a_0053+1[si]
		mov	dl,11h
		call	sub_b_260E
		mov	si,10E0h
		mov	dl,0Ch
		call	sub_b_2619
		pop	si
		call	sub_b_237C
		pop	ax
		mov	data_a_0010[si],ah
		mov	data_a_0010[di],al
		test	data_a_0000,1
		jnz	loc_b_2347		; Jump if not zero
		call	sub_b_2456
loc_b_2347:
		mov	data_a_0010[si],0
		mov	data_a_0010[di],0
		jmp	short loc_ret_b_237B
		db	90h
loc_b_2354:
		push	si
		mov	si,offset data_a_0835
		mov	al,data_a_000F
		shr	al,1			; Shift w/zeros fill
		mov	ah,0
		add	si,ax
		add	si,ax
		mov	si,word ptr data_a_0053+1[si]
		mov	dl,11h
		call	sub_b_260E
		mov	si,10E6h
		mov	dl,0Ch
		call	sub_b_2619
		pop	si
		call	sub_b_237C
		call	sub_b_2456

loc_ret_b_237B:
		retn
sub_b_2160	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_237C	proc	near
		push	si
		push	di
		mov	si,offset data_a_0059
		mov	di,5Ah
		mov	dl,0
loc_b_2386:
		push	dx
		mov	al,data_a_0010[si]
		add	al,30h			; '0'
		mov	data_a_10C7,al
		mov	data_a_10C8,0
		mov	dh,1
		add	dh,dl
		push	dx
		mov	dl,1Bh
		push	si
		call	sub_b_2642
		mov	si,10C7h
		mov	bl,82h
		call	sub_b_2621
		pop	si
		pop	dx
		mov	al,data_a_000E[si]
		test	data_a_0000,2
		jnz	loc_b_23DD		; Jump if not zero
		cmp	al,3
		je	loc_b_23BB		; Jump if equal
		jnc	loc_b_23C7		; Jump if carry=0
loc_b_23BB:
		mov	bx,10EFh
		mov	cl,3
		mul	cl			; ax = reg * al
		add	bx,ax
		jmp	short loc_b_23F7
		db	90h
loc_b_23C7:
		mov	al,data_a_000E[di]
		cmp	al,data_a_000E[si]
		jb	loc_b_23D7		; Jump if below
		mov	bx,10F8h
		jmp	short loc_b_23F7
		db	90h
loc_b_23D7:
		mov	bx,10FBh
		jmp	short loc_b_23F7
		db	90h
loc_b_23DD:
		mov	ah,0
		mov	cl,0Ah
		div	cl			; al, ah rem = ax/reg
		add	al,30h			; '0'
		mov	data_a_10C7,al
		add	ah,30h			; '0'
		mov	data_a_10C8,ah
		mov	data_a_10C9,0
		mov	bx,10C7h
loc_b_23F7:
		push	si
		push	bx
		mov	dl,1Fh
		call	sub_b_2642
		pop	bx
		mov	si,bx
		mov	bl,82h
		call	sub_b_2621
		pop	si
		pop	dx
		cmp	dl,0
		jne	loc_b_2414		; Jump if not equal
		mov	dl,2
		xchg	si,di
		jmp	loc_b_2386
loc_b_2414:
		pop	di
		pop	si
		retn
sub_b_237C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2417	proc	near
		push	si
		push	di
		mov	si,offset data_a_0059
		mov	ch,data_a_0012[si]
		add	ch,data_a_0013[si]
		sub	ch,1
		shl	ch,1			; Shift w/zeros fill
		mov	cl,0
loc_b_242B:
		mov	al,data_a_0010[si]
		add	al,30h			; '0'
		mov	data_a_10C7,al
		mov	data_a_10C8,0
		mov	dh,1
		add	dh,cl
		mov	dl,7
		add	dl,ch
		push	si
		mov	si,10C7h
		mov	bl,82h
		call	sub_b_2621
		pop	si
		cmp	cl,0
		jne	loc_b_2414		; Jump if not equal
		inc	si
		mov	cl,2
		jmp	short loc_b_242B
sub_b_2417	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2456	proc	near
		mov	data_a_0033,2
		mov	al,data_a_0010[si]
		add	al,data_a_0010[di]
		shr	al,1			; Shift w/zeros fill
		jc	loc_b_2473		; Jump if carry Set
		dec	data_a_0031
		neg	data_a_0031
		jmp	short loc_ret_b_248E
		db	90h

;==== External Entry into Subroutine ======================================

sub_b_2473:
loc_b_2473:
		push	si
		push	di
		mov	cx,0
		call	sub_b_248F
		mov	al,data_a_000B
		mov	ah,data_a_000C
		mov	data_a_000B,ah
		mov	data_a_000C,al
		call	sub_b_2552
		pop	di
		pop	si

loc_ret_b_248E:
		retn
sub_b_2456	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_248F	proc	near
		mov	cx,0
loc_b_2492:
		mov	si,offset data_a_0059
		add	si,cx
;*		and	data_a_0000[si],0F7h
		db	 80h,0A4h, 00h, 00h,0F7h	;  Fixup - byte match
		add	si,cx
		mov	di,offset data_a_10BF
		add	di,cx
		add	di,cx
		mov	ax,[di]
		mov	data_a_001C[si],ax
		mov	ax,[di+4]
		mov	data_a_0020[si],ax
		cmp	cl,0
		jne	loc_b_24BD		; Jump if not equal
		dec	cl
		neg	cl
		jmp	short loc_b_2492
loc_b_24BD:
		call	sub_b_24C1
		retn
sub_b_248F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_24C1	proc	near
		mov	al,data_a_0000
		push	ax
		and	data_a_0000,0FBh
		mov	cx,0
		mov	data_a_1070,0FFh
		mov	data_a_1071,0FFh
loc_b_24D7:
		dec	cl
		neg	cl
		mov	data_a_002F,cx
		mov	si,offset data_a_0059
		add	si,cx
		add	si,cx
		mov	di,offset data_a_0835
		add	di,cx
		add	di,cx
		mov	bx,word ptr data_a_004B+1[di]
		mov	ax,[bx]
		cmp	word ptr [bx+4],1F58h
		jne	loc_b_24FD		; Jump if not equal
		add	ax,6
loc_b_24FD:
		cmp	word ptr [bx+4],2708h
		jne	loc_b_2507		; Jump if not equal
		sub	ax,6
loc_b_2507:
		mov	data_a_0014[si],ax
		mov	ax,[bx+2]
		mov	data_a_0018[si],ax
		push	di
		sub	si,cx
		call	sub_b_1D01
		call	sub_b_1D57
		pop	di
		cmp	data_a_0002,0
		jne	loc_b_2538		; Jump if not equal
		cmp	data_a_0001,0
		jne	loc_b_2538		; Jump if not equal
		cmp	data_a_1071,0
		jne	loc_b_2538		; Jump if not equal
		cmp	data_a_1070,0
		je	loc_b_254D		; Jump if equal
loc_b_2538:
		mov	al,data_a_0001
		mov	data_a_1070,al
		mov	al,data_a_0002
		mov	data_a_1071,al
		call	sub_b_0317
		mov	cx,data_a_002F
		jmp	short loc_b_24D7
loc_b_254D:
		pop	ax
		mov	data_a_0000,al
		retn
sub_b_24C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2552	proc	near
		mov	di,offset data_a_1075
		mov	cl,12h
		mov	ch,data_a_0011
		mov	al,data_a_0010
		mov	data_a_1072,al
		call	sub_b_2585
		mov	di,offset data_a_1099
		mov	cl,13h
		mov	ch,data_a_0010
		mov	al,data_a_0011
		mov	data_a_1072,al
		call	sub_b_2585
		mov	al,data_a_0011
		mov	ah,data_a_0010
		mov	data_a_0011,ah
		mov	data_a_0010,al
		retn
sub_b_2552	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2585	proc	near
		mov	dh,ch
		and	dh,0F0h
		mov	dl,ch
		and	dl,0Fh
		mov	al,data_a_1072
		and	al,0F0h
		mov	data_a_1073,al
		mov	al,data_a_1072
		and	al,0Fh
		mov	data_a_1074,al
loc_b_259F:
		mov	bx,[di]
		mov	si,offset data_a_0000
loc_b_25A4:
		mov	al,[bx+si]
		cmp	al,ch
		jne	loc_b_25B1		; Jump if not equal
		mov	ah,data_a_1072
		jmp	short loc_b_25D6
		db	90h
loc_b_25B1:
		mov	ah,al
		and	ah,0Fh
		cmp	ah,dl
		jne	loc_b_25C5		; Jump if not equal
		and	al,0F0h
		mov	ah,data_a_1074
		or	ah,al
		jmp	short loc_b_25D6
		db	90h
loc_b_25C5:
		mov	ah,al
		and	ah,0F0h
		cmp	ah,dh
		jne	loc_b_25D8		; Jump if not equal
		and	al,0Fh
		mov	ah,data_a_1073
		or	ah,al
loc_b_25D6:
		mov	[bx+si],ah
loc_b_25D8:
		inc	si
		cmp	si,69h
		jne	loc_b_25A4		; Jump if not equal
		inc	di
		inc	di
		dec	cl
		jnz	loc_b_259F		; Jump if not zero
		retn
sub_b_2585	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_25E5	proc	near
		mov	si,798h
loc_b_25E8:
		mov	dx,1826h
		mov	bx,81h
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	al,[si]
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		mov	data_a_0053,2400h
		call	sub_b_1109
		call	sub_b_0421
		inc	si
		cmp	byte ptr [si],0
		jne	loc_b_25E8		; Jump if not equal
		call	sub_b_0403
		retn
sub_b_25E5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_260E	proc	near
		push	cx
		push	dx
		push	di
		push	si
		call	sub_b_0403
		pop	si
		pop	di
		pop	dx
		pop	cx

;==== External Entry into Subroutine ======================================

sub_b_2619:
		mov	dh,18h
		mov	bl,82h
		call	sub_b_2621
		retn
sub_b_260E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2621	proc	near
		push	si
		mov	ah,2
		mov	bh,0
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		pop	si
		push	bx
		sar	bl,1			; Shift w/sign fill
		and	bl,83h
loc_b_262F:
		mov	al,[si]
		cmp	al,0
		je	loc_b_2640		; Jump if equal
		push	si
		mov	ah,0Eh
		mov	bh,0
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		pop	si
		inc	si
		jmp	short loc_b_262F
loc_b_2640:
		pop	bx
		retn
sub_b_2621	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2642	proc	near
		push	cx
		push	dx
		push	es
		mov	al,0A0h
		mul	dh			; ax = reg * al
		mov	dh,0
		add	ax,dx
		shl	ax,1			; Shift w/zeros fill
		mov	bx,ax
		mov	dx,0B800h
		mov	es,dx
		mov	dx,0FFFFh
		mov	cx,4

locloop_b_265C:
		mov	es:[bx],dx
		mov	es:[bx+2],dx
		mov	es:d_B800_2000_e[bx],dx
		mov	es:d_B800_2002_e[bx],dx
		add	bx,50h
		loop	locloop_b_265C		; Loop if cx > 0

		pop	es
		pop	dx
		pop	cx
		retn
sub_b_2642	endp

		db	10 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2680	proc	near
		retn
sub_b_2680	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2681	proc	near
		push	bx
		push	dx
		mov	cx,data_a_1106
		mov	bx,data_a_1108
		mov	dx,data_a_110A
		call	sub_b_26BE
		pop	dx
		pop	bx
		retn
sub_b_2681	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2695	proc	near
		push	bx
		push	dx
		mov	cx,data_a_1100
		mov	bx,data_a_1102
		mov	dx,data_a_1104
		call	sub_b_26BE
		pop	dx
		pop	bx
		retn
sub_b_2695	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_26A9	proc	near
		push	bx
		push	dx
		mov	cx,data_a_110C
		mov	bx,data_a_110E
		mov	dx,data_a_1110
		call	sub_b_26BE
		pop	dx
		pop	bx
		retn
sub_b_26A9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_26BD	proc	near
		retn
sub_b_26BD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_26BE	proc	near
		cli				; Disable interrupts
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
loc_b_26C3:
		or	al,2
		out	61h,al			; port 61h, 8255 B - spkr, etc
		push	cx

locloop_b_26C8:
		loop	locloop_b_26C8		; Loop if cx > 0

		and	al,0FDh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		mov	cx,bx

locloop_b_26D0:
		loop	locloop_b_26D0		; Loop if cx > 0

		pop	cx
		dec	dx
		jnz	loc_b_26C3		; Jump if not zero
		sti				; Enable interrupts
		retn
sub_b_26BE	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_26E0	proc	near
		mov	ah,0
		mov	al,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	dx,3D9h
		mov	al,0
		out	dx,al			; port 3D9h, CGA color control
		mov	ax,ds
		mov	es,ax
		call	sub_b_27C5
		mov	data_a_0953,0
		mov	data_a_0003,0
		call	sub_b_2840
		push	es
		mov	ax,0
		mov	es,ax
		mov	di,d_0000_0024_e
		mov	ax,data_a_094D
		cld				; Clear direction
		cli				; Disable interrupts
		stosw				; Store ax to es:[di]
		mov	ax,data_a_094B
		stosw				; Store ax to es:[di]
		sti				; Enable interrupts
		pop	es
		mov	data_a_0953,0
		call	sub_b_29A2
		mov	si,offset data_a_11AB	; ('PLAYER1')
		mov	di,offset data_a_0012
		mov	cx,0Ah
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	si,offset data_a_11B3	; ('PLAYER2')
		mov	di,offset data_a_001C
		mov	cx,0Ah
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	data_a_0053,2000h
		call	sub_b_1109
		mov	dh,13h
		mov	dl,0Ah
		mov	bl,8Dh
		mov	si,1181h
		call	sub_b_2621
		mov	si,12h
		mov	dl,15h
		call	sub_b_2933
		mov	dh,15h
		mov	dl,0Ah
		mov	bl,8Dh
		mov	si,1196h
		call	sub_b_2621
		cmp	data_a_0006,1
		jne	loc_b_2780		; Jump if not equal
		mov	dl,15h
		push	bx
		mov	bl,2
		mov	si,1131h
		call	sub_b_2621
		pop	bx
		mov	si,11BBh
		call	sub_b_2621
		mov	si,offset data_a_11BB	; ('COMPUTER')
		mov	di,offset data_a_001C
		mov	cx,9
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
loc_b_2780:
		mov	data_a_0053,2000h
		call	sub_b_1109
		mov	dl,15h
		mov	si,1Ch
		call	sub_b_2933
		cmp	data_a_094A,0
		je	loc_b_279D		; Jump if equal
		push	es
		call	sub_b_120F
		pop	es
loc_b_279D:
		mov	dh,18h
		mov	dl,7
		mov	bl,0Fh
		mov	si,11C4h
		call	sub_b_2621
loc_b_27A9:
		mov	data_a_0053,2000h
		call	sub_b_1109
		call	sub_b_0FAC
		mov	data_a_000D,1
		call	sub_b_0FCD
		cmp	data_a_0003,1
		jne	loc_b_27A9		; Jump if not equal
		retn
sub_b_26E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_27C5	proc	near
		mov	dl,11h
		mov	dh,1
		mov	bl,0Fh
		mov	si,113Ah
		call	sub_b_2621
		mov	dl,0Ch
		mov	dh,3
		mov	bl,0Fh
		mov	si,1141h
		call	sub_b_2621
		mov	bl,4
		mov	dh,5
loc_b_27E1:
		mov	dl,3
loc_b_27E3:
		mov	si,1138h
		call	sub_b_2621
		inc	dl
		cmp	dl,25h			; '%'
		jne	loc_b_27E3		; Jump if not equal
		inc	dh
		cmp	dh,12h
		jne	loc_b_27E1		; Jump if not equal
		mov	bl,8Bh
		mov	dh,6
		mov	dl,10h
		mov	si,1152h
		call	sub_b_2621
		mov	dl,18h
		mov	si,1156h
		call	sub_b_2621
		mov	dh,7
		mov	dl,0Eh
		mov	si,115Ah
		call	sub_b_2621
		mov	dl,16h
		mov	si,1161h
		call	sub_b_2621
		mov	dl,1Fh
		mov	si,1169h
		call	sub_b_2621
		mov	dl,4
		mov	dh,9
		mov	si,116Eh
		call	sub_b_2621
		mov	dh,0Ch
		mov	si,1175h
		call	sub_b_2621
		mov	dh,0Fh
		mov	si,117Dh
		call	sub_b_2621
		retn
sub_b_27C5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2840	proc	near
		mov	data_a_0006,0
		mov	data_a_0007,0
		mov	dh,9
		mov	dl,11h
		mov	cx,0
		jmp	loc_b_28F1
loc_b_2854:
		cmp	data_a_1120,0
		jne	loc_b_2888		; Jump if not equal
		mov	data_a_0006,0
		mov	data_a_0007,2
		mov	si,offset data_a_11AB	; ('PLAYER1')
		mov	di,offset data_a_0012
		mov	cx,0Ah
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	si,offset data_a_11B3	; ('PLAYER2')
		mov	di,offset data_a_001C
		mov	cx,0Ah
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		cmp	data_a_094A,0
		jne	loc_b_2885		; Jump if not equal
		call	sub_b_29A2
loc_b_2885:
		inc	sp
		inc	sp
		retn
loc_b_2888:
		push	dx
		call	sub_b_0FAC
		mov	data_a_000D,1
		call	sub_b_0FCD
		pop	dx
		mov	cx,0
		cmp	data_a_0002,0FFh
		jne	loc_b_28AF		; Jump if not equal
		cmp	data_a_0007,0
		je	loc_b_290B		; Jump if equal
		mov	ch,0FDh
		dec	data_a_0007
		jmp	short loc_b_28F1
		db	90h
loc_b_28AF:
		cmp	data_a_0002,1
		jne	loc_b_28C6		; Jump if not equal
		cmp	data_a_0007,2
		je	loc_b_290B		; Jump if equal
		mov	ch,3
		inc	data_a_0007
		jmp	short loc_b_28F1
		db	90h
loc_b_28C6:
		cmp	data_a_0001,0FFh
		jne	loc_b_28DD		; Jump if not equal
		cmp	data_a_0006,0
		je	loc_b_290B		; Jump if equal
		mov	cl,0F8h
		dec	data_a_0006
		jmp	short loc_b_28F1
		db	90h
loc_b_28DD:
		cmp	data_a_0001,1
		jne	loc_b_290B		; Jump if not equal
		cmp	data_a_0006,2
		je	loc_b_290B		; Jump if equal
		mov	cl,8
		inc	data_a_0006
loc_b_28F1:
		mov	data_a_1120,100h
		mov	bl,4
		mov	si,1137h
		call	sub_b_2621
		add	dh,ch
		add	dl,cl
		mov	bl,84h
		mov	si,112Eh
		call	sub_b_2621
loc_b_290B:
		mov	data_a_0053,2000h
		call	sub_b_1109
		dec	data_a_1120
		cmp	data_a_0003,1
		je	loc_b_2922		; Jump if equal
		jmp	loc_b_2854
loc_b_2922:
		inc	data_a_0006
		cmp	data_a_0006,3
		jb	loc_ret_b_2932		; Jump if below
		mov	data_a_0006,0

loc_ret_b_2932:
		retn
sub_b_2840	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2933	proc	near
		mov	cl,9
		push	si
		mov	di,1124h
loc_b_2939:
		push	di
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		pop	di
		cmp	ah,0Eh
		je	loc_b_2949		; Jump if equal
		cmp	ah,4Bh			; 'K'
		jne	loc_b_296A		; Jump if not equal
loc_b_2949:
		cmp	cl,9
		je	loc_b_2939		; Jump if equal
		dec	dl
		push	bx
		mov	bl,2
		mov	si,1138h
		call	sub_b_2621
		pop	bx
		mov	data_a_1122,2Eh		; '.'
		mov	si,1122h
		call	sub_b_2621
		dec	di
		inc	cl
		jmp	short loc_b_2939
loc_b_296A:
		cmp	al,0Dh
		je	loc_b_298E		; Jump if equal
		push	ax
		push	bx
		mov	bl,2
		mov	si,1138h
		call	sub_b_2621
		pop	bx
		pop	ax
		push	ax
		mov	data_a_1122,al
		mov	si,1122h
		call	sub_b_2621
		pop	ax
		inc	dl
		mov	[di],al
		inc	di
		dec	cl
		jnz	loc_b_2939		; Jump if not zero
loc_b_298E:
		cmp	cl,9
		jne	loc_b_2995		; Jump if not equal
		pop	si
		retn
loc_b_2995:
		mov	byte ptr [di],0
		mov	si,offset data_a_1124
		pop	di
		mov	cx,0Ah
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		retn
sub_b_2933	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_29A2	proc	near
loc_b_29A2:
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_ret_b_29AE		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		jmp	short loc_b_29A2

loc_ret_b_29AE:
		retn
sub_b_29A2	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_29B0	proc	near
		mov	ah,0
		mov	al,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	dx,3D9h
		mov	al,0
		out	dx,al			; port 3D9h, CGA color control
		mov	si,0B800h
		mov	es,si
		mov	si,offset data_a_62D0
		mov	bx,64h
		xor	ax,ax			; Zero register
loc_b_29C9:
		mov	di,ax
		mov	cx,28h
		call	sub_b_2ACC
		mov	di,ax
		add	di,2000h
		mov	cx,28h
		call	sub_b_2ACC
		add	ax,50h
		dec	bx
		jnz	loc_b_29C9		; Jump if not zero
		push	ds
		push	es
		pop	ds
		xor	si,si			; Zero register
		mov	di,d_B800_004E_e
		call	sub_b_2A27
		mov	si,d_B800_2000_e
		mov	di,d_B800_204E_e
		call	sub_b_2A27
		pop	ds
		mov	di,offset data_a_11EA
loc_b_29FB:
		mov	dx,[di]
		mov	cx,[di+2]
		mov	bx,[di+4]
		call	sub_b_1B70
		add	di,6
loc_b_2A09:
		push	bx
		mov	ax,[di]
		add	di,2
		call	sub_b_2AE0
		mov	es:[si],bl
		add	si,1
		pop	bx
		sub	bx,4
		jnz	loc_b_2A09		; Jump if not zero
		cmp	word ptr [di],0
		jne	loc_b_29FB		; Jump if not equal
		call	sub_b_2A6C
		retn
sub_b_29B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2A27	proc	near
		mov	dx,64h
loc_b_2A2A:
		mov	cx,14h

locloop_b_2A2D:
		cld				; Clear direction
		lodsw				; String [si] to ax
		xchg	dx,ax
		cmp	ax,49h
		xchg	dx,ax
		jnc	loc_b_2A52		; Jump if carry=0
		push	dx
		push	cx
		mov	cx,8

locloop_b_2A3B:
		push	cx
		rcl	ax,1			; Rotate thru carry
		rcr	cx,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		rcr	bx,1			; Rotate thru carry
		rcl	cx,1			; Rotate thru carry
		rcr	bx,1			; Rotate thru carry
		pop	cx
		loop	locloop_b_2A3B		; Loop if cx > 0

		mov	ax,bx
		pop	cx
		pop	dx
		jmp	short loc_b_2A5C
		db	90h
loc_b_2A52:
		push	cx
		mov	cl,4
		rol	al,cl			; Rotate
		rol	ah,cl			; Rotate
		pop	cx
		xchg	ah,al
loc_b_2A5C:
		std				; Set direction flag
		stosw				; Store ax to es:[di]
		loop	locloop_b_2A2D		; Loop if cx > 0

		add	si,28h
		mov	di,si
		add	di,4Eh
		dec	dx
		jnz	loc_b_2A2A		; Jump if not zero
		retn
sub_b_2A27	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2A6C	proc	near
		mov	cl,0
		mov	di,835h
loc_b_2A71:
		mov	dh,1
		add	dh,cl
		mov	dl,11h
		push	dx
		call	sub_b_2642
		add	dl,2
		call	sub_b_2642
		add	dl,2
		call	sub_b_2642
		add	dl,2
		call	sub_b_2642
		pop	dx
		mov	bl,82h
		mov	si,word ptr data_a_0053+1[di]
		call	sub_b_2621
		cmp	cl,0
		jne	loc_b_2AA3		; Jump if not equal
		mov	cl,2
		add	di,2
		jmp	short loc_b_2A71
loc_b_2AA3:
		push	ds
		mov	si,d_B800_B800_e
		mov	ds,si
		mov	di,seg seg_a
		mov	es,di
		cld				; Clear direction
		mov	bx,0
loc_b_2AB2:
		cmp	bx,4000h
		je	loc_b_2ACA		; Jump if equal
		mov	si,bx
		mov	di,offset data_a_62D0
		add	di,bx
		mov	cx,0FA0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	bx,2000h
		jmp	short loc_b_2AB2
loc_b_2ACA:
		pop	ds
		retn
sub_b_2A6C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2ACC	proc	near
		push	ax
		push	bx

locloop_b_2ACE:
		mov	ax,[si]
		xchg	ah,al
		call	sub_b_2AE0
		mov	es:[di],bl
		inc	si
		inc	si
		inc	di
		loop	locloop_b_2ACE		; Loop if cx > 0

		pop	bx
		pop	ax
		retn
sub_b_2ACC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2AE0	proc	near
		push	cx
		mov	cx,4

locloop_b_2AE4:
		rcl	ax,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		rcl	bl,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		rcl	bl,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		loop	locloop_b_2AE4		; Loop if cx > 0

		pop	cx
		retn
sub_b_2AE0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2AF4	proc	near
		mov	ah,0
		mov	al,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	dx,3D9h
		mov	al,0
		out	dx,al			; port 3D9h, CGA color control
		push	ds
		mov	di,d_B800_B800_e
		mov	es,di
		mov	si,seg seg_a
		mov	ds,si
		cld				; Clear direction
		mov	bx,0
loc_b_2B0F:
		cmp	bx,4000h
		je	loc_b_2B27		; Jump if equal
		mov	di,bx
		mov	si,offset data_a_62D0
		add	si,bx
		mov	cx,0FA0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	bx,2000h
		jmp	short loc_b_2B0F
loc_b_2B27:
		pop	ds
		call	sub_b_2A6C
		retn
sub_b_2AF4	endp

		db	0, 0, 0, 0

seg_b		ends



;------------------------------------------------------  stack_seg_c   ----

stack_seg_c	segment	word stack 'stack'

		db	89 dup (?)
data_c_0059	db	?			; Data table (indexed access)
		db	422 dup (?)

stack_seg_c	ends



		end	start
