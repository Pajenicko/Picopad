
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
;==				TOWER	                                 ==
;==					                                 ==
;==      Created:   26-Jan-89		                                 ==
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

d_0000_0000_e	equ	0
d_0000_0003_e	equ	3
d_0040_0065_e	equ	65h
d_0040_00A0_e	equ	0A0h
d_0040_E050_e	equ	0E050h			;*
d_0040_E0A0_e	equ	0E0A0h			;*
d_0040_E0F0_e	equ	0E0F0h			;*
d_04E9_0006_e	equ	6			;*
d_04E9_000A_e	equ	0Ah			;*
d_04E9_0034_e	equ	34h			;*
d_04E9_0062_e	equ	62h			;*
d_04E9_0063_e	equ	63h			;*
d_04E9_0064_e	equ	64h			;*
d_04E9_00AD_e	equ	0ADh			;*
d_04E9_00DB_e	equ	0DBh			;*
d_04E9_0102_e	equ	102h			;*
d_04E9_0104_e	equ	104h			;*
d_04E9_0106_e	equ	106h			;*
d_04E9_0108_e	equ	108h			;*
d_04E9_010A_e	equ	10Ah			;*
d_04E9_010C_e	equ	10Ch			;*
d_04E9_010E_e	equ	10Eh			;*
d_04E9_0110_e	equ	110h			;*
d_04E9_0112_e	equ	112h			;*
d_04E9_0114_e	equ	114h			;*
d_04E9_0116_e	equ	116h			;*
d_04E9_015F_e	equ	15Fh			;*
d_04E9_0161_e	equ	161h			;*
d_04E9_0163_e	equ	163h			;*
d_04E9_0165_e	equ	165h			;*
d_04E9_0167_e	equ	167h			;*
d_04E9_0169_e	equ	169h			;*
d_04E9_016B_e	equ	16Bh			;*
d_04E9_016D_e	equ	16Dh			;*
d_04E9_016F_e	equ	16Fh			;*
d_04E9_0171_e	equ	171h			;*
d_04E9_0177_e	equ	177h			;*
d_04E9_0187_e	equ	187h			;*
d_04E9_0188_e	equ	188h			;*
d_04E9_018A_e	equ	18Ah			;*
d_04E9_018B_e	equ	18Bh			;*
d_04E9_018C_e	equ	18Ch			;*
d_04E9_018D_e	equ	18Dh			;*
d_04E9_018E_e	equ	18Eh			;*
d_04E9_018F_e	equ	18Fh			;*
d_04E9_0190_e	equ	190h			;*
d_04E9_0191_e	equ	191h			;*
d_04E9_0193_e	equ	193h			;*
d_04E9_0197_e	equ	197h			;*
d_04E9_0199_e	equ	199h			;*
d_04E9_01A5_e	equ	1A5h			;*
d_04E9_01A6_e	equ	1A6h			;*
d_04E9_01A7_e	equ	1A7h			;*
d_04E9_01A8_e	equ	1A8h			;*
d_04E9_01A9_e	equ	1A9h			;*
d_04E9_01AB_e	equ	1ABh			;*
d_04E9_01AC_e	equ	1ACh			;*
d_04E9_01AD_e	equ	1ADh			;*
d_04E9_01AE_e	equ	1AEh			;*
d_04E9_01AF_e	equ	1AFh			;*
d_04E9_01B3_e	equ	1B3h			;*
d_04E9_01B4_e	equ	1B4h			;*
d_04E9_01B5_e	equ	1B5h			;*
d_04E9_01B6_e	equ	1B6h			;*
d_04E9_01B7_e	equ	1B7h			;*
d_04E9_01BC_e	equ	1BCh			;*
d_04E9_01C0_e	equ	1C0h			;*
d_04E9_01C4_e	equ	1C4h			;*
d_04E9_01C8_e	equ	1C8h			;*
d_04E9_01CA_e	equ	1CAh			;*
d_04E9_01CB_e	equ	1CBh			;*
d_04E9_01D0_e	equ	1D0h			;*
d_04E9_01D4_e	equ	1D4h			;*
d_04E9_0218_e	equ	218h			;*
d_04E9_0219_e	equ	219h			;*
d_04E9_0236_e	equ	236h			;*
d_04E9_0238_e	equ	238h			;*
d_04E9_023D_e	equ	23Dh			;*
d_04E9_023E_e	equ	23Eh			;*
d_04E9_023F_e	equ	23Fh			;*
d_04E9_0241_e	equ	241h			;*
d_04E9_0242_e	equ	242h			;*
d_04E9_0251_e	equ	251h			;*
d_04E9_0253_e	equ	253h			;*
d_04E9_0254_e	equ	254h			;*
d_04E9_0256_e	equ	256h			;*
d_04E9_0258_e	equ	258h			;*
d_04E9_025A_e	equ	25Ah			;*
d_04E9_025D_e	equ	25Dh			;*
d_04E9_025E_e	equ	25Eh			;*
d_04E9_0260_e	equ	260h			;*
d_04E9_0261_e	equ	261h			;*
d_04E9_0262_e	equ	262h			;*
d_04E9_02B1_e	equ	2B1h			;*
d_04E9_02B2_e	equ	2B2h			;*
d_04E9_0517_e	equ	517h			;*
d_04E9_0A51_e	equ	0A51h			;*
d_04E9_0A57_e	equ	0A57h			;*
d_04E9_0A7E_e	equ	0A7Eh			;*
d_04E9_0BDA_e	equ	0BDAh			;*
d_04E9_0DDA_e	equ	0DDAh			;*
d_04E9_0EDA_e	equ	0EDAh			;*
d_04E9_10DA_e	equ	10DAh			;*
d_04E9_13D9_e	equ	13D9h			;*
d_04E9_15DA_e	equ	15DAh			;*
d_04E9_16D9_e	equ	16D9h			;*
d_04E9_18DA_e	equ	18DAh			;*
d_04E9_1A7E_e	equ	1A7Eh			;*
d_04E9_1A81_e	equ	1A81h			;*
d_04E9_1BF8_e	equ	1BF8h			;*
d_04E9_22F2_e	equ	22F2h			;*
d_04E9_23F2_e	equ	23F2h			;*
d_04E9_24F2_e	equ	24F2h			;*
d_04E9_25F2_e	equ	25F2h			;*
d_04E9_26F2_e	equ	26F2h			;*
d_04E9_3F14_e	equ	3F14h			;*
d_04E9_C9DE_e	equ	0C9DEh			;*
d_04E9_C9E0_e	equ	0C9E0h			;*
d_04E9_C9E2_e	equ	0C9E2h			;*
d_04E9_C9E3_e	equ	0C9E3h			;*
d_04E9_C9E4_e	equ	0C9E4h			;*
d_04E9_C9E5_e	equ	0C9E5h			;*
d_04E9_C9E6_e	equ	0C9E6h			;*
d_04E9_CB13_e	equ	0CB13h			;*
d_04E9_CB14_e	equ	0CB14h			;*
d_04E9_CB15_e	equ	0CB15h			;*
d_04E9_CB17_e	equ	0CB17h			;*
d_04E9_CBBA_e	equ	0CBBAh			;*
d_04E9_CD30_e	equ	0CD30h			;*
d_04E9_CDC8_e	equ	0CDC8h			;*
d_04E9_CDCC_e	equ	0CDCCh			;*
d_04E9_CDCD_e	equ	0CDCDh			;*
d_04E9_CDCE_e	equ	0CDCEh			;*
d_04E9_CDCF_e	equ	0CDCFh			;*
d_04E9_CDD0_e	equ	0CDD0h			;*
d_04E9_CDD1_e	equ	0CDD1h			;*
d_04E9_CDD2_e	equ	0CDD2h			;*
d_04E9_CDD3_e	equ	0CDD3h			;*
d_04E9_CDD4_e	equ	0CDD4h			;*
d_04E9_CDD5_e	equ	0CDD5h			;*
d_04E9_CDDE_e	equ	0CDDEh			;*
d_04E9_CDE1_e	equ	0CDE1h			;*
d_04E9_CDE5_e	equ	0CDE5h			;*
d_04E9_CDE9_e	equ	0CDE9h			;*
d_04E9_CDF6_e	equ	0CDF6h			;*
d_04E9_CDFD_e	equ	0CDFDh			;*
d_04E9_CE05_e	equ	0CE05h			;*
d_04E9_CE07_e	equ	0CE07h			;*
d_04E9_CE08_e	equ	0CE08h			;*
d_04E9_CE09_e	equ	0CE09h			;*
d_04E9_CE0A_e	equ	0CE0Ah			;*
d_04E9_CE0B_e	equ	0CE0Bh			;*
d_04E9_CE0C_e	equ	0CE0Ch			;*
d_04E9_CE15_e	equ	0CE15h			;*
d_04E9_CE1B_e	equ	0CE1Bh			;*
d_04E9_CE1D_e	equ	0CE1Dh			;*
d_04E9_CE4C_e	equ	0CE4Ch			;*
d_04E9_CE4D_e	equ	0CE4Dh			;*
d_04E9_CE5D_e	equ	0CE5Dh			;*
d_04E9_CE8C_e	equ	0CE8Ch			;*
d_04E9_CEA3_e	equ	0CEA3h			;*
d_04E9_CEBD_e	equ	0CEBDh			;*
d_04E9_CED0_e	equ	0CED0h			;*
d_04E9_CF06_e	equ	0CF06h			;*
d_04E9_CF08_e	equ	0CF08h			;*
d_04E9_CF0B_e	equ	0CF0Bh			;*
d_04E9_CF0C_e	equ	0CF0Ch			;*
d_04E9_CF0D_e	equ	0CF0Dh			;*
d_04E9_CF0F_e	equ	0CF0Fh			;*
d_04E9_CF20_e	equ	0CF20h			;*
d_04E9_CF23_e	equ	0CF23h			;*
d_04E9_CF24_e	equ	0CF24h			;*
d_04E9_CF25_e	equ	0CF25h			;*
d_04E9_CF27_e	equ	0CF27h			;*
d_04E9_CF3B_e	equ	0CF3Bh			;*
d_04E9_CF3C_e	equ	0CF3Ch			;*
d_04E9_CF3D_e	equ	0CF3Dh			;*
d_04E9_CF3F_e	equ	0CF3Fh			;*
d_04E9_CF59_e	equ	0CF59h			;*
d_04E9_CF82_e	equ	0CF82h			;*
d_04E9_CF95_e	equ	0CF95h			;*
d_04E9_CF9D_e	equ	0CF9Dh			;*
d_04E9_CFA5_e	equ	0CFA5h			;*
d_04E9_CFA6_e	equ	0CFA6h			;*
d_04E9_CFA8_e	equ	0CFA8h			;*
d_04E9_CFA9_e	equ	0CFA9h			;*
d_04E9_CFAA_e	equ	0CFAAh			;*
d_04E9_CFAB_e	equ	0CFABh			;*
d_04E9_CFB1_e	equ	0CFB1h			;*
d_04E9_CFB2_e	equ	0CFB2h			;*
d_04E9_CFB3_e	equ	0CFB3h			;*
d_04E9_D029_e	equ	0D029h			;*
d_04E9_D03E_e	equ	0D03Eh			;*
d_04E9_D045_e	equ	0D045h			;*
d_04E9_D047_e	equ	0D047h			;*
d_04E9_D04D_e	equ	0D04Dh			;*
d_04E9_D051_e	equ	0D051h			;*
d_04E9_D055_e	equ	0D055h			;*
d_04E9_D05A_e	equ	0D05Ah			;*
d_04E9_D07A_e	equ	0D07Ah			;*
d_04E9_D088_e	equ	0D088h			;*
d_04E9_D0B3_e	equ	0D0B3h			;*
d_04E9_D0EB_e	equ	0D0EBh			;*
d_04E9_D0EC_e	equ	0D0ECh			;*
d_04E9_D18F_e	equ	0D18Fh			;*
d_04E9_D190_e	equ	0D190h			;*
d_04E9_D1B7_e	equ	0D1B7h			;*
d_04E9_D1B8_e	equ	0D1B8h			;*
d_04E9_D1BD_e	equ	0D1BDh			;*
d_04E9_D1C1_e	equ	0D1C1h			;*
d_04E9_D1C2_e	equ	0D1C2h			;*
d_04E9_D1C6_e	equ	0D1C6h			;*
d_04E9_D1CB_e	equ	0D1CBh			;*
d_04E9_D1D0_e	equ	0D1D0h			;*
d_04E9_D1D5_e	equ	0D1D5h			;*
d_04E9_D1D6_e	equ	0D1D6h			;*
d_04E9_D1D7_e	equ	0D1D7h			;*
d_04E9_D1E6_e	equ	0D1E6h			;*
d_04E9_D202_e	equ	0D202h			;*
d_04E9_D209_e	equ	0D209h			;*
d_04E9_D20B_e	equ	0D20Bh			;*
d_04E9_D20C_e	equ	0D20Ch			;*
d_04E9_D20D_e	equ	0D20Dh			;*
d_04E9_D21D_e	equ	0D21Dh			;*
d_04E9_D21E_e	equ	0D21Eh			;*
d_04E9_D21F_e	equ	0D21Fh			;*
d_04E9_D220_e	equ	0D220h			;*
d_04E9_D22D_e	equ	0D22Dh			;*
d_04E9_D234_e	equ	0D234h			;*
d_04E9_D235_e	equ	0D235h			;*
d_04E9_D236_e	equ	0D236h			;*
d_04E9_D237_e	equ	0D237h			;*
d_04E9_D238_e	equ	0D238h			;*
d_04E9_D239_e	equ	0D239h			;*
d_04E9_D23C_e	equ	0D23Ch			;*
d_04E9_D23D_e	equ	0D23Dh			;*
d_04E9_D23E_e	equ	0D23Eh			;*
d_04E9_D240_e	equ	0D240h			;*
d_04E9_D241_e	equ	0D241h			;*
d_04E9_D242_e	equ	0D242h			;*
d_04E9_D244_e	equ	0D244h			;*
d_04E9_D245_e	equ	0D245h			;*
d_04E9_D246_e	equ	0D246h			;*
d_04E9_D247_e	equ	0D247h			;*
d_04E9_D263_e	equ	0D263h			;*
d_04E9_D27C_e	equ	0D27Ch			;*
d_04E9_D27D_e	equ	0D27Dh			;*
d_04E9_D27E_e	equ	0D27Eh			;*
d_04E9_D2A0_e	equ	0D2A0h			;*
d_04E9_D44D_e	equ	0D44Dh			;*
d_04E9_D5DD_e	equ	0D5DDh			;*
d_04E9_D5DF_e	equ	0D5DFh			;*
d_04E9_D5E5_e	equ	0D5E5h			;*
d_04E9_D5ED_e	equ	0D5EDh			;*
d_04E9_D5EE_e	equ	0D5EEh			;*
d_04E9_D5EF_e	equ	0D5EFh			;*
d_04E9_D5F0_e	equ	0D5F0h			;*
d_04E9_D5F1_e	equ	0D5F1h			;*
d_04E9_D5F6_e	equ	0D5F6h			;*
d_04E9_D717_e	equ	0D717h			;*
d_04E9_D79C_e	equ	0D79Ch			;*
d_04E9_D79E_e	equ	0D79Eh			;*
d_04E9_D7A0_e	equ	0D7A0h			;*
d_04E9_D7A2_e	equ	0D7A2h			;*
d_04E9_D7A4_e	equ	0D7A4h			;*
d_04E9_D7A6_e	equ	0D7A6h			;*
d_129D_0000_e	equ	0			;*
d_129D_00A0_e	equ	0A0h			;*
d_129D_00F0_e	equ	0F0h			;*
d_129D_011C_e	equ	11Ch			;*
d_129D_0516_e	equ	516h			;*
d_129D_08C8_e	equ	8C8h			;*
d_129D_2000_e	equ	2000h			;*
d_129D_2050_e	equ	2050h			;*
d_129D_20A0_e	equ	20A0h			;*
d_129D_20F0_e	equ	20F0h			;*
d_169D_0000_e	equ	0			;*
d_169D_0010_e	equ	10h			;*
d_169D_0020_e	equ	20h			;*
d_169D_0068_e	equ	68h			;*
d_169D_1FDC_e	equ	1FDCh			;*
d_169D_2D6A_e	equ	2D6Ah			;*
d_169D_3D7A_e	equ	3D7Ah			;*
d_169D_436A_e	equ	436Ah			;*
d_1C2B_0000_e	equ	0			;*
d_2013_0000_e	equ	0			;*
d_2013_0001_e	equ	1			;*
d_2013_0002_e	equ	2			;*
d_2013_0003_e	equ	3			;*
d_2013_0004_e	equ	4			;*
d_2013_0005_e	equ	5			;*
d_2013_000E_e	equ	0Eh			;*
d_2013_0014_e	equ	14h			;*
d_2013_001A_e	equ	1Ah			;*
d_2013_0020_e	equ	20h			;*
d_2013_0026_e	equ	26h			;*
d_2013_002C_e	equ	2Ch			;*
d_2013_0032_e	equ	32h			;*
d_2013_0034_e	equ	34h			;*
d_2013_0036_e	equ	36h			;*
d_2013_01C8_e	equ	1C8h			;*
d_2013_01C9_e	equ	1C9h			;*
d_2013_01CB_e	equ	1CBh			;*
d_2013_01CD_e	equ	1CDh			;*
d_2013_01CE_e	equ	1CEh			;*
d_2013_01CF_e	equ	1CFh			;*
d_2013_01D0_e	equ	1D0h			;*
d_2013_01D2_e	equ	1D2h			;*
d_2013_01D3_e	equ	1D3h			;*
d_2013_01D4_e	equ	1D4h			;*
d_2013_01E0_e	equ	1E0h			;*
d_2013_01E2_e	equ	1E2h			;*
d_2013_01E4_e	equ	1E4h			;*
d_2013_01E8_e	equ	1E8h			;*
d_2013_01F0_e	equ	1F0h			;*
d_2013_01F2_e	equ	1F2h			;*
d_2013_01F4_e	equ	1F4h			;*
d_2013_01F8_e	equ	1F8h			;*
d_2013_0200_e	equ	200h			;*
d_2013_063C_e	equ	63Ch			;*
d_2013_08C8_e	equ	8C8h			;*
d_B800_0000_e	equ	0
d_B800_03C0_e	equ	3C0h
d_B800_0516_e	equ	516h
d_B800_1B90_e	equ	1B90h
d_B800_1CC0_e	equ	1CC0h
d_B800_1FB0_e	equ	1FB0h
d_B800_1FDC_e	equ	1FDCh
d_B800_1FFC_e	equ	1FFCh
d_B800_1FFE_e	equ	1FFEh
d_B800_2000_e	equ	2000h
d_B800_2050_e	equ	2050h
d_B800_3B90_e	equ	3B90h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	byte public
		assume cs:seg_a  , ds:seg_a , ss:stack_seg_c


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 1Ch handler

sub_a_0000	proc	near
		push	ds
		mov	ah,35h			; '5'
		mov	al,1Ch
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	ax,4E9h
		mov	ds,ax
		mov	di,d_04E9_0006_e
		mov	[di],es
		mov	[di+2],bx
		push	cs
		pop	ds
		mov	dx,offset int_1Ch_entry
		mov	ah,25h			; '%'
		mov	al,1Ch
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		retn

;==== External Entry into Subroutine ======================================

sub_a_0021:
		push	ds
		mov	ax,4E9h
		mov	ds,ax
		mov	di,d_04E9_0006_e
		mov	dx,[di+2]
		mov	ax,[di]
		mov	ds,ax
		mov	ah,25h			; '%'
		mov	al,1Ch
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		retn
sub_a_0000	endp


;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

int_1Ch_entry	proc	far
		inc	cs:data_a_003F
		iret				; Interrupt return
int_1Ch_entry	endp

data_a_003F	db	0
		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0041	proc	near
		mov	cs:data_a_003F,0
		retn
sub_a_0041	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0048	proc	near
loc_a_0048:
		cmp	cs:data_a_003F,0
		je	loc_a_0048		; Jump if equal
		retn
sub_a_0048	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0051	proc	near
		call	sub_a_4C5B
		mov	ax,4E9h
		mov	ds,ax
		mov	byte ptr ds:d_04E9_0238_e,0
		mov	bp,d_04E9_000A_e
		call	sub_a_45FC
loc_a_0064:
		cmp	byte ptr ds:d_04E9_CDFD_e,1
		je	loc_a_00A7		; Jump if equal
		cmp	byte ptr ds:d_04E9_CDE1_e,1
		jne	loc_a_0064		; Jump if not equal
		mov	byte ptr ds:d_04E9_0238_e,1
		mov	bp,d_04E9_0034_e
		call	sub_a_45FC
loc_a_007D:
		cmp	byte ptr ds:d_04E9_CDCE_e,1
		je	loc_a_009A		; Jump if equal
		cmp	byte ptr ds:d_04E9_CDCF_e,1
		je	loc_a_008D		; Jump if equal
		jmp	short loc_a_007D
loc_a_008D:
		mov	byte ptr ds:d_04E9_0063_e,2
		call	sub_a_00B0
		call	sub_a_0160
		jmp	short loc_a_00A2
loc_a_009A:
		mov	byte ptr ds:d_04E9_0063_e,1
		call	sub_a_00B0
loc_a_00A2:
		mov	byte ptr ds:d_04E9_0238_e,1
loc_a_00A7:
		mov	byte ptr ds:d_04E9_01B5_e,0
		call	sub_a_4C5B
		retn
sub_a_0051	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_00B0	proc	near
		call	sub_a_4C5B
		mov	byte ptr ds:d_04E9_0062_e,1
		mov	byte ptr ds:d_04E9_01B5_e,0
		mov	bp,d_04E9_0064_e
		call	sub_a_45FC
;*		call	sub_a_0291		;*
		db	0E8h,0CBh, 01h		;  Fixup - byte match
loc_a_00C6:
;*		call	sub_a_0276		;*
		db	0E8h,0ADh, 01h		;  Fixup - byte match
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_00C6		; Jump if not equal
		call	sub_a_0219
		mov	ds:d_04E9_010A_e,bx
		mov	ds:d_04E9_010C_e,cx
;*		call	sub_a_0291		;*
		db	0E8h,0B3h, 01h		;  Fixup - byte match
		mov	bp,d_04E9_00AD_e
		call	sub_a_45FC
loc_a_00E4:
;*		call	sub_a_0276		;*
		db	0E8h, 8Fh, 01h		;  Fixup - byte match
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_00E4		; Jump if not equal
		call	sub_a_0219
		mov	ds:d_04E9_010E_e,bx
		mov	ds:d_04E9_0110_e,cx
;*		call	sub_a_0291		;*
		db	0E8h, 95h, 01h		;  Fixup - byte match
		mov	bp,d_04E9_00DB_e
		call	sub_a_45FC
loc_a_0102:
;*		call	sub_a_0276		;*
		db	0E8h, 71h, 01h		;  Fixup - byte match
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_0102		; Jump if not equal
		call	sub_a_0219
		mov	ds:d_04E9_0112_e,bx
		mov	ds:d_04E9_0114_e,cx
		mov	bx,ds:d_04E9_010E_e
		sub	bx,ds:d_04E9_0112_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_0112_e
		mov	ds:d_04E9_0104_e,bx
		mov	bx,ds:d_04E9_0112_e
		sub	bx,ds:d_04E9_010A_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_010A_e
		mov	ds:d_04E9_0102_e,bx
		mov	bx,ds:d_04E9_0110_e
		sub	bx,ds:d_04E9_0114_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_0114_e
		mov	ds:d_04E9_0108_e,bx
		mov	bx,ds:d_04E9_0114_e
		sub	bx,ds:d_04E9_010C_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_010C_e
		mov	ds:d_04E9_0106_e,bx
		retn
sub_a_00B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0160	proc	near
		call	sub_a_4C5B
		mov	byte ptr ds:d_04E9_0062_e,2
		mov	byte ptr ds:d_04E9_01B5_e,1
		mov	bp,d_04E9_0116_e
		call	sub_a_45FC
;*		call	sub_a_0291		;*
		db	0E8h, 1Bh, 01h		;  Fixup - byte match
loc_a_0176:
;*		call	sub_a_0276		;*
		db	0E8h,0FDh, 00h		;  Fixup - byte match
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_0176		; Jump if not equal
		call	sub_a_0219
		mov	ds:d_04E9_0167_e,bx
		mov	ds:d_04E9_0169_e,cx
;*		call	sub_a_0291		;*
		db	0E8h, 03h, 01h		;  Fixup - byte match
		mov	bp,d_04E9_00AD_e
		call	sub_a_45FC
loc_a_0194:
;*		call	sub_a_0276		;*
		db	0E8h,0DFh, 00h		;  Fixup - byte match
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_0194		; Jump if not equal
		call	sub_a_0219
		mov	ds:d_04E9_016B_e,bx
		mov	ds:d_04E9_016D_e,cx
;*		call	sub_a_0291		;*
		db	0E8h,0E5h, 00h		;  Fixup - byte match
		mov	bp,d_04E9_00DB_e
		call	sub_a_45FC
loc_a_01B2:
;*		call	sub_a_0276		;*
		db	0E8h,0C1h, 00h		;  Fixup - byte match
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_01B2		; Jump if not equal
		call	sub_a_0219
		mov	ds:d_04E9_016F_e,bx
		mov	ds:d_04E9_0171_e,cx
		mov	bx,ds:d_04E9_016B_e
		sub	bx,ds:d_04E9_016F_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_016F_e
		mov	ds:d_04E9_0161_e,bx
		mov	bx,ds:d_04E9_016F_e
		sub	bx,ds:d_04E9_0167_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_0167_e
		mov	ds:d_04E9_015F_e,bx
		mov	bx,ds:d_04E9_016D_e
		sub	bx,ds:d_04E9_0171_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_0171_e
		mov	ds:d_04E9_0165_e,bx
		mov	bx,ds:d_04E9_0171_e
		sub	bx,ds:d_04E9_0169_e
		shr	bx,1			; Shift w/zeros fill
		add	bx,ds:d_04E9_0169_e
		mov	ds:d_04E9_0163_e,bx
		retn
sub_a_0160	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0210	proc	near
		cmp	byte ptr ds:d_04E9_0062_e,1
		je	loc_a_024D		; Jump if equal
		jmp	short loc_a_0220

;==== External Entry into Subroutine ======================================

sub_a_0219:
		cmp	byte ptr ds:d_04E9_0062_e,1
		je	loc_a_024D		; Jump if equal
loc_a_0220:
		xor	bx,bx			; Zero register
		mov	cx,bx
		mov	si,0C350h
		mov	dx,201h
		cli				; Disable interrupts
		out	dx,al			; port 201h, start game 1-shots
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
loc_a_0237:
		in	al,dx			; port 201h, start game 1-shots
		and	ax,0Ch
		jz	loc_a_024B		; Jump if zero
		rcr	ax,1			; Rotate thru carry
		rcr	ax,1			; Rotate thru carry
		rcr	ax,1			; Rotate thru carry
		adc	bx,0
		add	cx,ax
		inc	si
		jnz	loc_a_0237		; Jump if not zero
loc_a_024B:
		sti				; Enable interrupts
		retn
loc_a_024D:
		xor	bx,bx			; Zero register
		mov	cx,bx
		mov	si,0C350h
		mov	dx,201h
		cli				; Disable interrupts
		out	dx,al			; port 201h, start game 1-shots
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
data_a_0263	db	90h, 0ECh, '%', 3, 0
		db	't', 0Ah, 0D1h, 0D8h, 83h, 0D3h, 0
		db	3, 0C8h, 'Fu', 0F0h, 0FBh, 0C3h, 'P'
		db	'SQRWVU', 6, 1Eh, 0E8h, ';', 0
		db	80h, '&L', 0CEh, 10h, 1Fh, 7, ']^'
		db	'_ZY[X', 0C3h, 'PSQRWVU', 6, 1Eh, 0E8h
		db	' ', 0
		db	80h, '&L', 0CEh, 10h, 80h, '>L', 0CEh
		db	10h, 't', 0F1h, 0B9h, 19h, 0
		db	'Q', 0E8h, 'FJY', 0E2h, 0F9h, 1Fh
		db	7, ']^_ZY[X', 0C3h, 0B8h, 0E9h, 4
		db	8Eh, 0D8h, 0C6h, 6, 'L', 0CEh, 0
		db	0C6h, 6, 'b', 0
		db	1, 80h, '>c', 0
		db	1, 'tt', 80h, '>', 0B5h, 1, 0
		db	'tm', 0FEh, 6, 'b', 0
		db	0E8h, '8', 0FFh, 8Bh, 0F3h, ';6_', 1
		db	's', 5, 80h, 0Eh, 'L', 0CEh, 2, ';'
		db	'6a', 1, 'v', 5, 80h, 0Eh, 'L', 0CEh
		db	1, 0E8h, 14h, 0FFh, 8Bh, 0F1h, ';'
		db	'6c', 1, 's', 5, 80h, 0Eh, 'L', 0CEh
		db	8, ';6e', 1, 'v', 5, 80h, 0Eh, 'L'
		db	0CEh, 4, 0BAh, 1, 2, 0ECh, 80h, '>'
		db	'b', 0
		db	1, 0B1h, ' ', 0B5h, 10h, 't', 4, 0B1h
		db	80h, 0B5h, '@', 84h, 0C1h, 'u', 5
		db	80h, 0Eh, 'L', 0CEh, ' ', 84h, 0C5h
		db	'u', 5, 80h, 0Eh, 'L', 0CEh, 10h, 80h
		db	'>', 5, 0CEh, 1, 't', 1, 0C3h, 80h
		db	0Eh, 'L', 0CEh, 10h, 0C3h, 0E8h, 0CFh
		db	0FEh, 8Bh, 0F3h, ';6', 2, 1, 's', 5
		db	80h, 0Eh, 'L', 0CEh, 2, ';6', 4, 1
		db	'v', 5, 80h, 0Eh, 'L', 0CEh, 1, 0E8h
		db	0ABh, 0FEh, 8Bh, 0F1h, ';6', 6, 1
		db	's', 5, 80h, 0Eh, 'L', 0CEh, 8, ';'
		db	'6', 8, 1, 'v', 5, 80h, 0Eh, 'L', 0CEh
		db	4, 0BAh, 1, 2, 0ECh, 80h, '>b', 0
		db	1, 0B1h, ' ', 0B5h, 10h, 't', 4, 0B1h
		db	80h, 0B5h, '@', 84h, 0C1h, 'u', 5
		db	80h, 0Eh, 'L', 0CEh, ' ', 84h, 0C5h
		db	'u', 5, 80h, 0Eh, 'L', 0CEh, 10h, 80h
		db	'>', 5, 0CEh, 1, 't', 1, 0C3h, 80h
		db	0Eh, 'L', 0CEh, 10h, 0C3h, 6, 9Ah
		db	'F', 0
		db	0E3h, 4, 7, 0B8h, 0E9h, 4, 8Eh, 0D8h
		db	8Ch, 0C0h, 0BBh, 0FCh, 27h, '+', 0D8h
		db	0B4h, 'J', 0CDh, '!s', 0Ch, 0BAh, 'c'
		db	2, 0B4h, 9, 0CDh, '!', 0B8h, 0FFh
		db	'L', 0CDh, '!', 0B8h, 0E9h, 4, 8Eh
		db	0D8h, 0B8h, 5, 0
		db	0CDh, 10h, 0B8h, '@', 0
		db	8Eh, 0C0h, '&', 0A0h, 'e', 0
		db	0Ch, 4, 0BAh, 0D8h, 3, 0EEh, '&', 0A2h
		db	'e', 0
		db	0B8h, 0E9h, 4, 8Eh, 0D8h, 0C6h, 6
		db	17h, 0D7h, 1, 0E8h, 0FAh, 19h, 0E8h
		db	' ', 0Ch, 0E8h, 'R', 1, 0B8h, 0E9h
		db	4, 8Eh, 0D8h, 0B9h, 0F4h, 1, 'Q', 0E8h
		db	0E5h, 'H', 0E8h, 'Y', 1Ah, 'Y', 80h
		db	'>L', 0CEh, 10h, 't', 2, 0E2h, 0EFh
		db	0B8h, 0E9h, 4, 8Eh, 0D8h, 0E8h, '5'
		db	'H', 0E8h, '|', 0Fh, 0E8h, 0B0h, ' '
		db	0E8h, 0FEh, 'H', 0E8h, 'm', 5, 0E8h
		db	'b5', 0C6h, 6, 0B4h, 1, 1, 0C6h, 6
		db	0CBh, 1, 80h, 0C6h, 6, 0A5h, 1, 0
		db	0C6h, 6, 'Z', 2, 0
		db	0E8h, 5, 0FCh, 0E8h, 'H5', 0C6h, 6
		db	0A6h, 1, 0
		db	0E8h, '%', 1Ch
loc_a_0457:
		call	sub_a_36C8
		call	sub_a_3997
		call	sub_a_36AC
		mov	byte ptr ds:d_04E9_01B5_e,1
loc_a_0465:
		call	sub_a_36D4
		pushf				; Push flags
		call	sub_a_246C
		popf				; Pop flags
;*		jnc	loc_a_044F		;*Jump if carry=0
		db	 73h,0E0h		;  Fixup - byte match
loc_a_046F:
		call	sub_a_1375
		call	sub_a_1386
		call	sub_a_2756
		mov	byte ptr ds:d_04E9_0261_e,0
		mov	byte ptr ds:d_04E9_0262_e,0
		call	sub_a_238B
		mov	byte ptr ds:d_04E9_0191_e,0
		mov	byte ptr ds:d_04E9_01CA_e,0FFh
		call	sub_a_1D04
		call	sub_a_0573
		call	sub_a_114D
loc_a_0498:
		call	sub_a_06DF
		cmp	byte ptr ds:d_04E9_0191_e,0
		jne	loc_a_04B8		; Jump if not equal
		cmp	byte ptr ds:d_04E9_01A7_e,2
		je	loc_a_04E9		; Jump if equal
		cmp	word ptr ds:d_04E9_01C8_e,0
		je	loc_a_04B5		; Jump if equal
		call	sub_a_28BA
		jmp	short loc_a_0498
loc_a_04B5:
		call	sub_a_1EB8
loc_a_04B8:
		mov	byte ptr ds:d_04E9_01CA_e,0FFh
		cmp	byte ptr ds:d_04E9_01A5_e,0
		jne	loc_a_04DB		; Jump if not equal
		mov	bx,d_04E9_01B6_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_04CF		; Jump if equal
		inc	bx
loc_a_04CF:
		dec	byte ptr [bx]
		push	bx
		call	sub_a_2756
		pop	bx
		cmp	byte ptr [bx],0
		je	loc_a_04E0		; Jump if equal
loc_a_04DB:
		call	sub_a_1D59
		jmp	short loc_a_0465
loc_a_04E0:
		call	sub_a_1D49
		call	sub_a_1E94
		jmp	loc_a_0465
loc_a_04E9:
		mov	byte ptr ds:d_04E9_01CA_e,0FFh
		mov	al,ds:d_04E9_0187_e
		push	ax
		push	word ptr ds:d_04E9_0188_e
		push	word ptr ds:d_04E9_0251_e
		call	sub_a_1EF3
		call	sub_a_1D04
		mov	byte ptr ds:d_04E9_01A7_e,3
		call	sub_a_0573
		pop	word ptr ds:d_04E9_0251_e
		pop	word ptr ds:d_04E9_0188_e
		pop	ax
		mov	ds:d_04E9_0187_e,al
		mov	byte ptr ds:d_04E9_018E_e,4
		mov	byte ptr ds:d_04E9_018D_e,1Dh
		mov	byte ptr ds:d_04E9_0190_e,0
loc_a_0523:
		call	sub_a_06DF
		call	sub_a_28BA
		cmp	byte ptr ds:d_04E9_01A7_e,4
		jne	loc_a_0523		; Jump if not equal
		mov	byte ptr ds:d_04E9_01A7_e,0
		call	sub_a_1D28
		cmp	al,8
		jne	loc_a_0545		; Jump if not equal
		call	sub_a_1D49
		call	sub_a_1ED9
		jmp	loc_a_0465
loc_a_0545:
		call	sub_a_1D59
		call	sub_a_246C
		call	sub_a_1375
		call	sub_a_1386
		call	sub_a_09A2
		jmp	loc_a_046F
sub_a_0210	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0557	proc	near
		mov	word ptr ds:d_04E9_D79C_e,0B800h
		mov	word ptr ds:d_04E9_D79E_e,0
		mov	word ptr ds:d_04E9_D7A0_e,4000h
		mov	word ptr ds:d_04E9_D7A2_e,29Ah
		call	sub_a_4D07
		retn
sub_a_0557	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0573	proc	near
		mov	ax,4E9h
		mov	es,ax
		mov	di,d_04E9_0A7E_e
		mov	cx,800h
		xor	ax,ax			; Zero register
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		call	sub_a_145D
		cmp	byte ptr ds:d_04E9_01AE_e,7
		jne	loc_a_05C6		; Jump if not equal
		mov	ax,4E9h
		mov	es,ax
		cmp	byte ptr ds:d_04E9_D5ED_e,0
		je	loc_a_05B0		; Jump if equal
		xor	ax,ax			; Zero register
		mov	di,d_04E9_0EDA_e
		stosw				; Store ax to es:[di]
		stosb				; Store al to es:[di]
		mov	di,d_04E9_10DA_e
		stosw				; Store ax to es:[di]
		stosb				; Store al to es:[di]
		mov	di,d_04E9_16D9_e
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	di,d_04E9_18DA_e
		stosw				; Store ax to es:[di]
		stosb				; Store al to es:[di]
		jmp	short loc_a_05C6
loc_a_05B0:
		xor	ax,ax			; Zero register
		mov	di,d_04E9_0BDA_e
		stosw				; Store ax to es:[di]
		stosb				; Store al to es:[di]
		mov	di,d_04E9_0DDA_e
		stosw				; Store ax to es:[di]
		stosb				; Store al to es:[di]
		mov	di,d_04E9_13D9_e
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	di,d_04E9_15DA_e
		stosw				; Store ax to es:[di]
		stosb				; Store al to es:[di]
loc_a_05C6:
		jmp	short loc_a_063C
			                        ;* No entry point to code
		push	es
		mov	ax,4E9h
		mov	es,ax
		mov	di,d_04E9_02B2_e
		mov	si,d_B800_0000_e
		mov	ax,0B800h
		mov	ds,ax
		mov	cx,3C0h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	si,d_B800_2000_e
		mov	cx,3C0h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	ax,4E9h
		mov	ds,ax
		mov	ax,0B800h
		mov	es,ax
		mov	di,d_B800_0000_e
		xor	ax,ax			; Zero register
		mov	cx,4000h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		pop	es
		mov	al,ds:d_04E9_01AE_e
		and	al,1
		jz	loc_a_0604		; Jump if zero
		jmp	short loc_a_060B
loc_a_0604:
		mov	ax,5
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		jmp	short loc_a_061A
loc_a_060B:
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ah,0Bh
		mov	bh,1
		mov	bl,1
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		jmp	short loc_a_061A
loc_a_061A:
		mov	cx,5

locloop_a_061D:
		call	sub_a_4CF6
		loop	locloop_a_061D		; Loop if cx > 0

		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	si,d_04E9_02B2_e
		mov	di,d_B800_0000_e
		mov	cx,3C0h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	di,d_B800_2000_e
		mov	cx,3C0h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
loc_a_063C:
		call	sub_a_0695
		call	sub_a_07B3
		call	sub_a_410D
		call	sub_a_3781
		mov	cx,4
		mov	di,d_04E9_0177_e
		mov	al,0FFh
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		cmp	byte ptr ds:d_04E9_01A7_e,3
		je	loc_a_068A		; Jump if equal
		call	sub_a_09A1
		mov	byte ptr ds:d_04E9_0197_e,1
		mov	al,24h			; '$'
		sub	al,ds:d_04E9_0187_e
		and	al,7Fh
		mov	ds:d_04E9_0253_e,al
		call	sub_a_1CBF
		call	sub_a_2C0E
		dec	byte ptr ds:d_04E9_0197_e
		mov	byte ptr ds:d_04E9_01A7_e,0
		mov	byte ptr ds:d_04E9_0218_e,7Dh	; '}'
		mov	byte ptr ds:d_04E9_0219_e,1
		mov	al,ds:d_04E9_01A5_e
		jmp	short loc_a_068C
loc_a_068A:
		mov	al,0FFh
loc_a_068C:
		mov	ds:d_04E9_01CA_e,al
		mov	byte ptr ds:d_04E9_0258_e,2
		retn
sub_a_0573	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0695	proc	near
		mov	byte ptr ds:d_04E9_0187_e,4
		mov	al,8
		mov	ds:d_04E9_0188_e,al
		mov	ds:d_04E9_018A_e,al
		sub	al,28h			; '('
		mov	ds:d_04E9_0251_e,al
		mov	al,0
		mov	byte ptr ds:d_04E9_0188_e+1,al
		mov	ds:d_04E9_018B_e,al
		sbb	al,0
		and	al,3
		mov	byte ptr ds:d_04E9_0251_e+1,al
		mov	byte ptr ds:d_04E9_01AC_e,0
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	byte ptr ds:d_04E9_0191_e,0
		mov	byte ptr ds:d_04E9_0241_e,0
		mov	byte ptr ds:d_04E9_0193_e,0
		mov	byte ptr ds:d_04E9_018E_e,0
		mov	byte ptr ds:d_04E9_018C_e,80h
		mov	byte ptr ds:d_04E9_0190_e,1
		retn
sub_a_0695	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_06DF	proc	near
		call	sub_a_0041
		cmp	byte ptr ds:d_04E9_0258_e,0
		je	loc_a_06FE		; Jump if equal
		dec	byte ptr ds:d_04E9_0258_e
		mov	byte ptr ds:d_04E9_023E_e,0
		mov	byte ptr ds:d_04E9_023F_e,0
		mov	byte ptr ds:d_04E9_023D_e,0
		jmp	short loc_a_0701
loc_a_06FE:
		call	sub_a_3733
loc_a_0701:
		cmp	byte ptr ds:d_04E9_01A6_e,0
		jne	loc_a_073E		; Jump if not equal
		cmp	byte ptr ds:d_04E9_01A7_e,3
		jne	loc_a_071C		; Jump if not equal
		call	sub_a_31E4
		cmp	byte ptr ds:d_04E9_01A7_e,4
		jne	loc_a_071A		; Jump if not equal
		retn
loc_a_071A:
		jmp	short loc_a_073E
loc_a_071C:
		call	sub_a_29EA
		call	sub_a_378A
		call	sub_a_31E4
		mov	al,ds:d_04E9_0219_e
		push	ax
		call	sub_a_3826
		pop	ax
		cmp	al,ds:d_04E9_0219_e
		je	loc_a_0738		; Jump if equal
		xor	al,al			; Zero register
		call	sub_a_1153
loc_a_0738:
		call	sub_a_4201
		call	sub_a_07BE
loc_a_073E:
		mov	al,24h			; '$'
		sub	al,ds:d_04E9_0187_e
		and	al,7Fh
		mov	ds:d_04E9_0253_e,al
		call	sub_a_1CBF
		call	sub_a_1318
		call	sub_a_1789
		call	sub_a_1421
		call	sub_a_161F
		call	sub_a_16DD
		call	sub_a_411D
		mov	ax,ds:d_04E9_025E_e
		mov	ds:d_04E9_D27E_e,ax
		mov	al,ds:d_04E9_0260_e
		mov	ds:d_04E9_D27D_e,al
		mov	al,ds:d_04E9_025D_e
		mov	ds:d_04E9_D27C_e,al
		mov	byte ptr ds:d_04E9_025D_e,0
		call	sub_a_41BE
		call	sub_a_3AAE
		call	sub_a_39A3
		call	sub_a_1197
		call	sub_a_14D3
		call	sub_a_1C59
		call	sub_a_1BA6
		cmp	byte ptr ds:d_04E9_01A7_e,3
		je	loc_a_079A		; Jump if equal
		call	sub_a_3684
		call	sub_a_2813
		call	sub_a_1337
loc_a_079A:
		call	sub_a_0048
		inc	byte ptr ds:d_04E9_0262_e
		and	byte ptr ds:d_04E9_0262_e,1
		jnz	loc_a_07A9		; Jump if not zero
		retn
loc_a_07A9:
		inc	byte ptr ds:d_04E9_0261_e
		and	byte ptr ds:d_04E9_0261_e,7
		retn
sub_a_06DF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07B3	proc	near
		mov	al,0FFh
		mov	ds:d_04E9_01AD_e,al
		mov	byte ptr ds:d_04E9_025D_e,0
		retn
sub_a_07B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07BE	proc	near
		mov	al,byte ptr ds:[18Eh]
		cmp	al,7
		jne	loc_a_07C6		; Jump if not equal
		retn
loc_a_07C6:
		cmp	al,4
		jne	loc_a_07D6		; Jump if not equal
		mov	al,byte ptr ds:[18Dh]
		cmp	al,0Ah
		jb	loc_a_07E2		; Jump if below
		cmp	al,1Fh
		jae	loc_a_07E2		; Jump if above or =
		retn
loc_a_07D6:
		cmp	al,8
		jne	loc_a_07DB		; Jump if not equal
		retn
loc_a_07DB:
		mov	al,byte ptr ds:[193h]
		or	al,al			; Zero ?
		jnz	loc_a_0829		; Jump if not zero
loc_a_07E2:
		call	sub_a_0850
		jc	loc_a_0803		; Jump if carry Set
		cmp	byte ptr ds:[18Eh],6
		je	loc_a_07EF		; Jump if equal
		retn
loc_a_07EF:
		mov	al,byte ptr ds:[187h]
		mov	bx,word ptr ds:[188h]
		call	sub_a_3494
		jc	loc_a_07FC		; Jump if carry Set
		retn
loc_a_07FC:
		mov	byte ptr ds:d_04E9_D20C_e,14h
		jmp	short loc_a_081A
loc_a_0803:
		mov	al,ds:[bp+30h]
		mov	ch,0Fh
		cmp	al,7
		je	loc_a_080F		; Jump if equal
		mov	ch,14h
loc_a_080F:
		mov	ds:d_04E9_D20C_e,ch
		mov	al,ds:d_04E9_018E_e
		cmp	al,6
		jne	loc_a_0826		; Jump if not equal
loc_a_081A:
		mov	al,ds:d_04E9_0188_e
		and	al,3
		jz	loc_a_0838		; Jump if zero
		inc	byte ptr ds:d_04E9_0193_e
		retn
loc_a_0826:
		jmp	loc_a_30F6
loc_a_0829:
		mov	al,ds:d_04E9_018E_e
		cmp	al,6
		jne	loc_a_0848		; Jump if not equal
		mov	al,ds:d_04E9_0188_e
		and	al,3
		jz	loc_a_0838		; Jump if zero
		retn
loc_a_0838:
		call	sub_a_2A52
		call	sub_a_29BB
		jnc	loc_a_0843		; Jump if carry=0
		mov	byte ptr [bx],8Dh
loc_a_0843:
		mov	byte ptr ds:d_04E9_01AD_e,0FFh
loc_a_0848:
		mov	byte ptr ds:d_04E9_0193_e,0
		jmp	loc_a_30F6
sub_a_07BE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0850	proc	near
		mov	bp,1D5h
		mov	al,byte ptr ds:[187h]
		mov	ds:[bp],al
		mov	al,byte ptr ds:[188h]
		add	al,1
		mov	ds:[bp+6],al
		mov	al,byte ptr ds:[189h]
		adc	al,0
		and	al,3
		mov	ds:[bp+0Ch],al
		call	sub_a_08C0
		jc	loc_a_08BC		; Jump if carry Set
		mov	cx,4
		mov	bp,1D0h

locloop_a_0879:
		cmp	byte ptr ds:[bp+30h],7
		je	loc_a_0885		; Jump if equal
		inc	bp
		loop	locloop_a_0879		; Loop if cx > 0

loc_a_0883:
		clc				; Clear carry flag
		retn
loc_a_0885:
		mov	al,ds:[bp]
		cmp	al,35h			; '5'
		jb	loc_a_0883		; Jump if below
		cmp	al,44h			; 'D'
		jae	loc_a_0883		; Jump if above or =
		mov	al,ds:[bp+6]
		add	al,7
		mov	bl,al
		mov	al,ds:[bp+0Ch]
		adc	al,0
		mov	bh,al
		mov	cx,word ptr ds:[188h]
		sub	bx,cx
		jc	loc_a_0883		; Jump if carry Set
		mov	bx,9
		add	bx,cx
		mov	cl,ds:[bp+6]
		mov	ch,ds:[bp+0Ch]
		sub	bx,cx
		jc	loc_a_0883		; Jump if carry Set
		stc				; Set carry flag
		retn
loc_a_08BC:
		mov	bp,bx
		stc				; Set carry flag
		retn
sub_a_0850	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_08C0	proc	near
		mov	al,4
		mov	si,1D0h
loc_a_08C5:
		xchg	al,ah
		mov	cx,si
		mov	bx,bp
		mov	al,bh
		cmp	al,ch
		jne	loc_a_08DA		; Jump if not equal
		mov	al,bl
		cmp	al,cl
		jne	loc_a_08DA		; Jump if not equal
		jmp	loc_a_0968
loc_a_08DA:
		mov	al,[si+30h]
		cmp	al,7
		jne	loc_a_08E4		; Jump if not equal
		jmp	loc_a_0968
loc_a_08E4:
		cmp	al,0
		jne	loc_a_08EA		; Jump if not equal
		jmp	short loc_a_0968
loc_a_08EA:
		cmp	al,4
		jne	loc_a_08F0		; Jump if not equal
		jmp	short loc_a_0968
loc_a_08F0:
		cmp	al,6
		jne	loc_a_08F6		; Jump if not equal
		jmp	short loc_a_0968
loc_a_08F6:
		mov	al,ds:[bp]
		sub	al,[si]
		and	al,7Fh
		cmp	al,4
		jb	loc_a_0908		; Jump if below
		cmp	al,7Ch			; '|'
		jae	loc_a_0908		; Jump if above or =
		jmp	short loc_a_0968
loc_a_0908:
		add	al,3
		and	al,7
		mov	byte ptr ds:[0A50h],al
		mov	al,ds:[bp+6]
		sub	al,[si+6]
		mov	bl,al
		mov	al,ds:[bp+0Ch]
		sbb	al,[si+0Ch]
		and	al,3
		jnz	loc_a_092B		; Jump if not zero
		mov	al,bl
		cmp	al,8
		jb	loc_a_0935		; Jump if below
		jmp	short loc_a_0968
loc_a_092B:
		cmp	al,3
		jne	loc_a_0968		; Jump if not equal
		mov	al,bl
		cmp	al,0F9h
		jb	loc_a_0968		; Jump if below
loc_a_0935:
		add	al,7
		mov	cl,al
		xor	ch,ch			; Zero register
		mov	bx,bp
		sub	bx,1D0h
		mov	al,bl
		add	bx,1D0h
		cmp	al,5
		je	loc_a_0965		; Jump if equal
		mov	bx,0A32h
		cmp	al,4
		jne	loc_a_0955		; Jump if not equal
		mov	bx,0A41h
loc_a_0955:
		add	bx,cx
		mov	al,[bx]
		inc	byte ptr ds:[0A50h]
		mov	cl,byte ptr ds:[0A50h]
		rcr	al,cl			; Rotate thru carry
		jnc	loc_a_0968		; Jump if carry=0
loc_a_0965:
		stc				; Set carry flag
		jmp	short loc_a_0973
loc_a_0968:
		inc	si
		xchg	al,ah
		dec	al
		jz	loc_a_0972		; Jump if zero
		jmp	loc_a_08C5
loc_a_0972:
		clc				; Clear carry flag
loc_a_0973:
		mov	bx,si
		retn
sub_a_08C0	endp

			                        ;* No entry point to code
		push	ds
		mov	ax,4E9h
		mov	ds,ax
loc_a_097C:
		call	sub_a_1E6D		; Load state of DS:SI keys -> AL
		cmp	byte ptr ds:d_04E9_CE4C_e,0
		jne	loc_a_097C		; Jump if not equal
		pop	ds
		retn
			                        ;* No entry point to code
		push	ds
		mov	ax,4E9h
		mov	ds,ax
loc_a_098E:
		call	sub_a_1E6D		; Load state of DS:SI keys -> AL
		cmp	byte ptr ds:d_04E9_CE4C_e,0
		je	loc_a_098E		; Jump if equal
		pop	ds
		retn
		db	0E8h,0EBh,0FFh,0EBh,0D7h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_099F	proc	near
		retn
sub_a_099F	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09A1	proc	near
		retn
sub_a_09A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09A2	proc	near
		call	sub_a_114D
		call	sub_a_1D04
		mov	al,1
		call	sub_a_105A
		mov	bp,d_04E9_0A51_e
		call	sub_a_48FD
		call	sub_a_2438
		mov	bp,d_04E9_0A57_e
		call	sub_a_48FD
loc_a_09BC:
		call	sub_a_1083
		jnc	loc_a_09BC		; Jump if carry=0
		call	sub_a_1D04
		mov	ax,2013h
		mov	es,ax
		mov	di,d_2013_0036_e
		mov	si,d_04E9_D44D_e
		mov	cx,0C8h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	ax,129Dh
		mov	es,ax
		mov	di,d_129D_0000_e
		xor	ax,ax			; Zero register
		mov	cx,2000h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,2013h
		mov	ds,ax
		mov	word ptr ds:d_2013_0032_e,274h
		mov	word ptr ds:d_2013_0034_e,280h
		xor	al,al			; Zero register
		mov	ds:d_2013_000E_e,al
		mov	ds:d_2013_0014_e,al
		mov	ds:d_2013_001A_e,al
		mov	ds:d_2013_0020_e,al
		mov	ds:d_2013_01C8_e,al
		mov	ds:d_2013_002C_e,al
		mov	byte ptr ds:d_2013_01D2_e,1
		mov	byte ptr ds:d_2013_01D3_e,0
		mov	word ptr ds:d_2013_01D4_e,0
		mov	bp,26h
		mov	byte ptr ds:[bp],1
		mov	byte ptr ds:[bp+1],20h	; ' '
		mov	byte ptr ds:[bp+2],68h	; 'h'
		mov	byte ptr ds:[bp+3],0
		mov	ax,4E9h
		mov	ds,ax
loc_a_0A34:
		call	sub_a_0041
		call	sub_a_0EC9
		call	sub_a_0A9A
		call	sub_a_0AE3
		call	sub_a_0E95
		call	sub_a_1197
		call	sub_a_1E6D		; Load state of DS:SI keys -> AL
		mov	dl,ds:d_04E9_CE4C_e
		mov	ax,2013h
		mov	ds,ax
		mov	ds:d_2013_01C8_e,dl
		inc	byte ptr ds:d_2013_01CE_e
		and	byte ptr ds:d_2013_01CE_e,1
		cmp	byte ptr ds:d_2013_01D2_e,0
		je	loc_a_0A6A		; Jump if equal
		inc	word ptr ds:d_2013_01D4_e
loc_a_0A6A:
		mov	ax,4E9h
		mov	ds,ax
		call	sub_a_2813
		call	sub_a_0048
		call	sub_a_1008
		mov	ax,2013h
		mov	ds,ax
		cmp	word ptr ds:d_2013_01D4_e,258h
		jb	loc_a_0A34		; Jump if below
		mov	byte ptr ds:d_2013_01D2_e,0
		cmp	byte ptr ds:d_2013_01D3_e,2
		jne	loc_a_0A34		; Jump if not equal
		mov	ax,4E9h
		mov	ds,ax
		call	sub_a_1D04
		retn
sub_a_09A2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0A9A	proc	near
		mov	ax,2013h
		mov	ds,ax
		mov	ax,129Dh
		mov	es,ax
		cmp	byte ptr ds:d_2013_01D2_e,0
		je	loc_a_0AB3		; Jump if equal
		dec	word ptr ds:d_2013_0032_e
		dec	word ptr ds:d_2013_0034_e
loc_a_0AB3:
		cmp	word ptr ds:d_2013_0032_e,48h
		ja	loc_a_0AC8		; Jump if above
		mov	di,0C80h
		add	di,ds:d_2013_0032_e
		mov	si,ds:d_2013_063C_e
		call	sub_a_0E1C
loc_a_0AC8:
		cmp	word ptr ds:[34h],48h
		ja	loc_a_0ADD		; Jump if above
		mov	di,0C80h
		add	di,word ptr ds:[34h]
		mov	si,word ptr ds:[63Eh]
		call	sub_a_0E1C
loc_a_0ADD:
		mov	ax,4E9h
		mov	ds,ax
		retn
sub_a_0A9A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0AE3	proc	near
		mov	ax,2013h
		mov	ds,ax
		mov	ax,129Dh
		mov	es,ax
		mov	bp,d_2013_002C_e
		mov	si,63Ah
		cmp	byte ptr ds:[bp+1],0F0h
		jb	loc_a_0AFF		; Jump if below
		mov	byte ptr ds:[bp],0
loc_a_0AFF:
		add	byte ptr ds:[bp+1],8
		call	sub_a_0DF5
		mov	cx,4

locloop_a_0B0A:
		push	cx
		mov	bx,d_2013_0004_e
		shl	cx,1			; Shift w/zeros fill
		add	bx,cx
		mov	bp,[bx]
		call	sub_a_0C5A
		call	sub_a_0CB4
		mov	si,602h
		call	sub_a_0DF5
		pop	cx
		loop	locloop_a_0B0A		; Loop if cx > 0

		mov	bp,d_2013_0026_e
		mov	si,622h
		cmp	byte ptr ds:d_2013_01D2_e,1
		je	loc_a_0B89		; Jump if equal
		mov	byte ptr ds:d_2013_01C8_e,0
		cmp	byte ptr ds:d_2013_01D3_e,1
		je	loc_a_0B76		; Jump if equal
		cmp	byte ptr ds:[bp+1],64h	; 'd'
		je	loc_a_0B51		; Jump if equal
		ja	loc_a_0B4C		; Jump if above
		or	byte ptr ds:d_2013_01C8_e,1
		jmp	short loc_a_0B51
loc_a_0B4C:
		or	byte ptr ds:d_2013_01C8_e,2
loc_a_0B51:
		cmp	byte ptr ds:[bp+2],6Ah	; 'j'
		je	loc_a_0B68		; Jump if equal
		ja	loc_a_0B61		; Jump if above
		or	byte ptr ds:d_2013_01C8_e,4
		jmp	short loc_a_0B89
loc_a_0B61:
		or	byte ptr ds:d_2013_01C8_e,8
		jmp	short loc_a_0B89
loc_a_0B68:
		cmp	byte ptr ds:[bp+1],64h	; 'd'
		jne	loc_a_0B89		; Jump if not equal
		mov	byte ptr ds:d_2013_01D3_e,1
		jmp	short loc_a_0B89
loc_a_0B76:
		cmp	byte ptr ds:[bp+2],40h	; '@'
		je	loc_a_0B84		; Jump if equal
		or	byte ptr ds:d_2013_01C8_e,8
		jmp	short loc_a_0B89
loc_a_0B84:
		mov	byte ptr ds:d_2013_01D3_e,2
loc_a_0B89:
		mov	al,ds:[bp+3]
		and	al,1
		add	al,2
		mov	cl,0FEh
		test	byte ptr ds:d_2013_01C8_e,8
		jnz	loc_a_0BA5		; Jump if not zero
		mov	cl,2
		test	byte ptr ds:d_2013_01C8_e,4
		jnz	loc_a_0BA5		; Jump if not zero
		mov	cl,0
loc_a_0BA5:
		add	al,cl
		add	al,ds:d_2013_01CD_e
		mov	ds:[bp+3],al
		call	sub_a_0DF5
		xor	byte ptr ds:d_2013_01CD_e,6
		test	byte ptr ds:d_2013_01C8_e,1
		jz	loc_a_0BD3		; Jump if zero
		cmp	byte ptr ds:[bp+1],0C0h
		jae	loc_a_0BD3		; Jump if above or =
		inc	byte ptr ds:[bp+3]
		and	byte ptr ds:[bp+3],1
		add	byte ptr ds:[bp+1],2
loc_a_0BD3:
		test	byte ptr ds:d_2013_01C8_e,2
		jz	loc_a_0BEF		; Jump if zero
		cmp	byte ptr ds:[bp+1],4
		jb	loc_a_0BEF		; Jump if below
		dec	byte ptr ds:[bp+3]
		and	byte ptr ds:[bp+3],1
		sub	byte ptr ds:[bp+1],2
loc_a_0BEF:
		test	byte ptr ds:d_2013_01C8_e,4
		jz	loc_a_0C02		; Jump if zero
		cmp	byte ptr ds:[bp+2],0A8h
		jae	loc_a_0C02		; Jump if above or =
		add	byte ptr ds:[bp+2],2
loc_a_0C02:
		test	byte ptr ds:d_2013_01C8_e,8
		jz	loc_a_0C15		; Jump if zero
		cmp	byte ptr ds:[bp+2],3Eh	; '>'
		jb	loc_a_0C15		; Jump if below
		sub	byte ptr ds:[bp+2],2
loc_a_0C15:
		test	byte ptr ds:d_2013_01C8_e,10h
		jz	loc_a_0C54		; Jump if zero
		mov	al,ds:[bp+1]
		mov	ah,ds:[bp+2]
		mov	bp,d_2013_002C_e
		cmp	byte ptr ds:[bp],1
		je	loc_a_0C54		; Jump if equal
		add	al,28h			; '('
		mov	ds:[bp+1],al
		add	ah,10h
		mov	ds:[bp+2],ah
		mov	byte ptr ds:[bp],1
		mov	byte ptr ds:[bp+3],0
		mov	ax,4E9h
		mov	ds,ax
		mov	al,3
		call	sub_a_1153
		mov	ax,2013h
		mov	ds,ax
loc_a_0C54:
		mov	ax,4E9h
		mov	ds,ax
		retn
sub_a_0AE3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0C5A	proc	near
		cmp	byte ptr ds:[bp],1
		jne	loc_a_0C62		; Jump if not equal
		retn
loc_a_0C62:
		cmp	byte ptr ds:d_2013_01D2_e,0
		jne	loc_a_0C6A		; Jump if not equal
		retn
loc_a_0C6A:
		inc	byte ptr ds:d_2013_01CF_e
		and	byte ptr ds:d_2013_01CF_e,1Fh
		jz	loc_a_0C76		; Jump if zero
		retn
loc_a_0C76:
		call	sub_a_0CA5
		mov	dl,al
		and	al,1
		mov	ds:[bp+4],al
		mov	al,dl
		and	al,0Fh
		mov	cl,3
		shl	al,cl			; Shift w/zeros fill
		add	al,3Eh			; '>'
		mov	ds:[bp+2],al
		mov	byte ptr ds:[bp+1],0FCh
		mov	byte ptr ds:[bp+3],0
		mov	byte ptr ds:[bp],1
		mov	byte ptr ds:[bp+5],0
		retn
sub_a_0C5A	endp

data_a_0CA4	db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0CA5	proc	near
		push	ds
		push	cs
		pop	ds
		xor	bx,bx			; Zero register
		mov	al,data_a_0CA4
		inc	data_a_0CA4
		xlat				; al=[al+[bx]] table
		pop	ds
		retn
sub_a_0CA5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0CB4	proc	near
		cmp	byte ptr ds:[bp],0
		jne	loc_a_0CBC		; Jump if not equal
		retn
loc_a_0CBC:
		mov	ds:d_2013_01D0_e,bp
		cmp	byte ptr ds:[bp+5],1
		je	loc_a_0D13		; Jump if equal
		mov	al,ds:[bp+1]
		mov	ah,ds:[bp+2]
		mov	bp,d_2013_002C_e
		cmp	byte ptr ds:[bp],0
		je	loc_a_0D13		; Jump if equal
		cmp	ah,ds:[bp+2]
		ja	loc_a_0D13		; Jump if above
		add	ah,18h
		cmp	ah,ds:[bp+2]
		jb	loc_a_0D13		; Jump if below
		cmp	al,ds:[bp+1]
		ja	loc_a_0D13		; Jump if above
		add	al,18h
		cmp	al,ds:[bp+1]
		jb	loc_a_0D13		; Jump if below
		mov	byte ptr ds:[bp],0
		mov	bp,ds:d_2013_01D0_e
		mov	byte ptr ds:[bp+5],1
		mov	ax,4E9h
		mov	ds,ax
		mov	al,9
		call	sub_a_1153
		mov	ax,2013h
		mov	ds,ax
loc_a_0D13:
		mov	bp,ds:d_2013_01D0_e
		cmp	byte ptr ds:[bp+5],0
		je	loc_a_0D80		; Jump if equal
		mov	al,ds:[bp+1]
		mov	ah,ds:[bp+2]
		mov	bp,d_2013_0026_e
		cmp	byte ptr ds:[bp],0
		je	loc_a_0D80		; Jump if equal
		mov	cl,ds:[bp+2]
		add	cl,1Fh
		cmp	ah,cl
		ja	loc_a_0D80		; Jump if above
		sub	cl,0Fh
		add	ah,18h
		cmp	ah,cl
		jb	loc_a_0D80		; Jump if below
		mov	cl,ds:[bp+1]
		add	cl,40h			; '@'
		cmp	al,cl
		ja	loc_a_0D80		; Jump if above
		sub	cl,40h			; '@'
		add	al,18h
		cmp	al,cl
		jb	loc_a_0D80		; Jump if below
		mov	bp,ds:d_2013_01D0_e
		mov	byte ptr ds:[bp],0
		mov	ax,4E9h
		mov	ds,ax
		mov	al,9
		call	sub_a_1153
		mov	ax,2013h
		mov	ds,ax
		push	ds
		mov	ax,4E9h
		mov	ds,ax
		mov	bx,50h
		push	es
		call	sub_a_1D81
		pop	es
		pop	ds
loc_a_0D80:
		mov	bp,ds:d_2013_01D0_e
		cmp	byte ptr ds:d_2013_01CE_e,1
		jne	loc_a_0D94		; Jump if not equal
		inc	byte ptr ds:[bp+3]
		and	byte ptr ds:[bp+3],7
loc_a_0D94:
		cmp	byte ptr ds:[bp+5],1
		jne	loc_a_0DA2		; Jump if not equal
		or	byte ptr ds:[bp+3],8
		jmp	short loc_a_0DA7
loc_a_0DA2:
		and	byte ptr ds:[bp+3],0F7h
loc_a_0DA7:
		cmp	byte ptr ds:[bp+5],1
		je	loc_a_0DD5		; Jump if equal
		cmp	byte ptr ds:[bp+2],36h	; '6'
		jb	loc_a_0DC1		; Jump if below
		cmp	byte ptr ds:[bp+2],0ACh
		jbe	loc_a_0DC6		; Jump if below or =
		mov	byte ptr ds:[bp+2],0ACh
loc_a_0DC1:
		xor	byte ptr ds:[bp+4],1
loc_a_0DC6:
		cmp	byte ptr ds:[bp+4],1
		mov	al,0FFh
		jnz	loc_a_0DD1		; Jump if not zero
		mov	al,1
loc_a_0DD1:
		add	ds:[bp+2],al
loc_a_0DD5:
		sub	byte ptr ds:[bp+1],4
		cmp	byte ptr ds:[bp+1],8
		jb	loc_a_0DE2		; Jump if below
		retn
loc_a_0DE2:
		mov	byte ptr ds:[bp+5],0
		cmp	byte ptr ds:d_2013_01D2_e,0
		je	loc_a_0DEF		; Jump if equal
		retn
loc_a_0DEF:
		mov	byte ptr ds:[bp],0
		retn
sub_a_0CB4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0DF5	proc	near
		cmp	byte ptr ds:[bp],0
		jne	loc_a_0DFD		; Jump if not equal
		retn
loc_a_0DFD:
		mov	al,ds:[bp+1]
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	ah,ds:[bp+2]
		call	sub_a_0E7E
		mov	di,ax
		mov	bx,si
		mov	al,ds:[bp+3]
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		mov	si,[bx]
sub_a_0DF5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0E1C	proc	near
		lodsw				; String [si] to ax
		mov	cx,ax
		lodsw				; String [si] to ax
		mov	bx,4
		cmp	ax,3
		je	locloop_a_0E4B		; Jump if equal
		mov	dx,ax

locloop_a_0E2A:
		push	dx
		push	di
loc_a_0E2C:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		dec	dx
		jnz	loc_a_0E2C		; Jump if not zero
		pop	di
		mov	ax,2000h
		test	di,ax
		jz	loc_a_0E45		; Jump if zero
		mov	ax,0E050h
loc_a_0E45:
		add	di,ax
		pop	dx
		loop	locloop_a_0E2A		; Loop if cx > 0

		retn

locloop_a_0E4B:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,6
		mov	ax,2000h
		test	di,ax
		jz	loc_a_0E79		; Jump if zero
		mov	ax,0E050h
loc_a_0E79:
		add	di,ax
		loop	locloop_a_0E4B		; Loop if cx > 0

		retn
sub_a_0E1C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0E7E	proc	near
		mov	byte ptr ds:[1C6h],al
		mov	bl,ah
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
;*		add	bx,36h
		db	 81h,0C3h, 36h, 00h	;  Fixup - byte match
		mov	ax,[bx]
		add	ax,word ptr ds:[1C6h]
		add	ax,8
		retn
sub_a_0E7E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0E95	proc	near
		mov	bx,1FC0h
		mov	bp,1FF0h
		mov	ax,129Dh
		mov	ds,ax
		mov	ax,0B800h
		mov	es,ax
		mov	si,d_129D_08C8_e
		mov	di,si
		mov	dx,48h
		mov	ax,20h
loc_a_0EB0:
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		add	si,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		sub	si,bp
		dec	dx
		jnz	loc_a_0EB0		; Jump if not zero
		mov	ax,4E9h
		mov	ds,ax
		retn
sub_a_0E95	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0EC9	proc	near
		mov	ax,2013h
		mov	ds,ax
		cmp	byte ptr ds:d_2013_01D2_e,0
		je	loc_a_0F18		; Jump if equal
		dec	byte ptr ds:d_2013_0002_e
		dec	byte ptr ds:d_2013_0002_e
		and	byte ptr ds:d_2013_0002_e,3Fh	; '?'
		dec	byte ptr ds:d_2013_0003_e
		and	byte ptr ds:d_2013_0003_e,3Fh	; '?'
		dec	byte ptr ds:d_2013_0000_e
		and	byte ptr ds:d_2013_0000_e,1
		jnz	loc_a_0EFF		; Jump if not zero
		dec	byte ptr ds:d_2013_0004_e
		and	byte ptr ds:d_2013_0004_e,3Fh	; '?'
loc_a_0EFF:
		dec	byte ptr ds:d_2013_0001_e
		and	byte ptr ds:d_2013_0001_e,3
		cmp	byte ptr ds:d_2013_0001_e,3
		jne	loc_a_0F18		; Jump if not equal
		dec	byte ptr ds:d_2013_0005_e
		and	byte ptr ds:d_2013_0005_e,3Fh	; '?'
loc_a_0F18:
		mov	ax,129Dh
		mov	es,ax
		mov	di,d_2013_08C8_e
		mov	bx,d_2013_01E0_e
		mov	dx,0Ch
		xor	al,al			; Zero register
		mov	cl,ds:d_2013_0002_e
		call	sub_a_0FAF
		mov	bx,d_2013_01E2_e
		mov	dx,8
		xor	al,al			; Zero register
		mov	cl,ds:d_2013_0003_e
		call	sub_a_0FAF
		mov	bx,d_2013_01E4_e
		mov	dx,8
		mov	al,ds:d_2013_0000_e
		mov	cl,ds:d_2013_0004_e
		call	sub_a_0FAF
		mov	bx,d_2013_01E8_e
		mov	dx,4
		mov	al,ds:d_2013_0001_e
		mov	cl,ds:d_2013_0005_e
		call	sub_a_0FAF
		mov	bx,d_2013_0200_e
		mov	dx,8
		xor	al,al			; Zero register
		xor	cl,cl			; Zero register
		call	sub_a_0FAF
		mov	bx,d_2013_01F8_e
		mov	dx,4
		mov	al,ds:d_2013_0001_e
		mov	cl,ds:d_2013_0005_e
		call	sub_a_0FAF
		mov	bx,d_2013_01F4_e
		mov	dx,8
		mov	al,ds:d_2013_0000_e
		mov	cl,ds:d_2013_0004_e
		call	sub_a_0FAF
		mov	bx,d_2013_01F2_e
		mov	dx,8
		xor	al,al			; Zero register
		mov	cl,ds:d_2013_0003_e
		call	sub_a_0FAF
		mov	bx,d_2013_01F0_e
		mov	dx,0Ch
		xor	al,al			; Zero register
		mov	cl,ds:d_2013_0002_e
		call	sub_a_0FAF
		mov	ax,4E9h
		mov	ds,ax
		retn
sub_a_0EC9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0FAF	proc	near
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		mov	si,[bx]
		mov	ds:d_2013_01CB_e,cl
		mov	al,40h			; '@'
		sub	al,cl
		mov	cl,al
		mov	ds:d_2013_01C9_e,cl
		mov	bx,2000h
		mov	bp,1FB0h
		add	di,ds:d_2013_01CB_e
loc_a_0FCF:
		mov	cx,ds:d_2013_01C9_e
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,ds:d_2013_01C9_e
		sub	di,ds:d_2013_01CB_e
		mov	cx,ds:d_2013_01CB_e
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ds:d_2013_01C9_e
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,ds:d_2013_01C9_e
		sub	di,ds:d_2013_01CB_e
		mov	cx,ds:d_2013_01CB_e
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		dec	dx
		jnz	loc_a_0FCF		; Jump if not zero
		sub	di,ds:d_2013_01CB_e
		retn
sub_a_0FAF	endp

loc_a_1003:
		pop	ax
		pop	ax
		jmp	loc_a_4C75

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1008	proc	near
		cmp	byte ptr ds:d_04E9_CDCD_e,1
		je	loc_a_1003		; Jump if equal
		cmp	byte ptr ds:d_04E9_CDE5_e,1
		je	loc_a_1017		; Jump if equal
		retn
loc_a_1017:
		call	sub_a_1E6D		; Load state of DS:SI keys -> AL
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_1017		; Jump if not equal
		retn
sub_a_1008	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1022	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	ax,1C2Bh
		mov	ds,ax
		mov	si,d_1C2B_0000_e
		mov	di,d_B800_0000_e
		mov	cx,64h

locloop_a_1035:
		push	cx
		mov	cx,50h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		add	di,d_B800_1FB0_e
		mov	cx,50h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,2000h
		pop	cx
		loop	locloop_a_1035		; Loop if cx > 0

		mov	ax,4E9h
		mov	ds,ax
		mov	cx,1F4h

locloop_a_1053:
		call	sub_a_4CF6
		loop	locloop_a_1053		; Loop if cx > 0

		retn
sub_a_1022	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_105A	proc	near
		mov	ds:d_04E9_C9E4_e,al

;==== External Entry into Subroutine ======================================

sub_a_105D:
		mov	al,ds:d_04E9_C9E4_e
		mov	bx,0CA02h
		mov	ah,9
		or	al,al			; Zero ?
		jz	loc_a_1075		; Jump if zero
		mov	bx,0CA14h
		mov	ah,1
		dec	al
		jz	loc_a_1075		; Jump if zero
		mov	bx,0CA16h
loc_a_1075:
		mov	ds:d_04E9_C9DE_e,bx
		mov	ds:d_04E9_C9E2_e,ah
		mov	byte ptr ds:d_04E9_C9E3_e,1
		retn
sub_a_105A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1083	proc	near
		cmp	byte ptr ds:d_04E9_C9E3_e,0
		je	loc_a_109B		; Jump if equal
loc_a_108A:
		mov	byte ptr ds:d_04E9_C9E3_e,0
		mov	si,ds:d_04E9_C9DE_e
		lodsw				; String [si] to ax
		mov	ds:d_04E9_C9DE_e,si
		mov	ds:d_04E9_C9E0_e,ax
loc_a_109B:
		mov	bx,ds:d_04E9_C9E0_e
		mov	al,[bx]
		cmp	al,0FFh
		jne	loc_a_10B8		; Jump if not equal
		dec	byte ptr ds:d_04E9_C9E2_e
		jnz	loc_a_108A		; Jump if not zero
		cmp	byte ptr ds:d_04E9_C9E4_e,0
		stc				; Set carry flag
		jnz	loc_ret_a_1106		; Jump if not zero
		call	sub_a_105D
		jmp	short loc_a_108A
loc_a_10B8:
		inc	bx
		mov	ds:d_04E9_C9E0_e,bx
		xor	ah,ah			; Zero register
		mov	bx,d_04E9_C9E2_e
		add	bx,ax
		cmp	byte ptr ds:d_04E9_01CB_e,0
		jne	loc_a_1107		; Jump if not equal
		mov	ah,[bx]
		mov	al,1
		add	al,ah
		mov	ds:d_04E9_C9E5_e,al
		mov	cl,0
		mov	ch,16h
		mov	bh,ah
loc_a_10DA:
		dec	bh
		jnz	loc_a_10E2		; Jump if not zero
		or	al,2
		mov	bh,ah
loc_a_10E2:
		dec	bl
		jnz	loc_a_10EC		; Jump if not zero
		or	al,2
		mov	bl,ds:d_04E9_C9E5_e
loc_a_10EC:
		add	al,8
		and	al,0FDh
		nop
		nop
		push	cx
		mov	cx,ds:d_04E9_D045_e

locloop_a_10F7:
		nop
		loop	locloop_a_10F7		; Loop if cx > 0

		pop	cx
		shr	al,1			; Shift w/zeros fill
		dec	cl
		jnz	loc_a_10DA		; Jump if not zero
		dec	ch
		jnz	loc_a_10DA		; Jump if not zero
		clc				; Clear carry flag

loc_ret_a_1106:
		retn
loc_a_1107:
		mov	ah,[bx]
		mov	al,1
		add	al,ah
		mov	ds:d_04E9_C9E5_e,al
		mov	cl,0
		mov	ch,16h
		mov	bh,ah
		in	al,61h			; port 61h, 8255 port B, read
		and	al,7Ch			; '|'
loc_a_111A:
		dec	bh
		jnz	loc_a_1122		; Jump if not zero
		or	al,2
		mov	bh,ah
loc_a_1122:
		dec	bl
		jnz	loc_a_112C		; Jump if not zero
		or	al,2
		mov	bl,ds:d_04E9_C9E5_e
loc_a_112C:
		test	byte ptr ds:d_04E9_C9E6_e,2
		jz	loc_a_1135		; Jump if zero
		xor	al,2
loc_a_1135:
		mov	ds:d_04E9_C9E6_e,al
		out	61h,al			; port 61h, 8255 B - spkr, etc
		push	cx
		mov	cx,ds:d_04E9_D045_e

locloop_a_113F:
		nop
		loop	locloop_a_113F		; Loop if cx > 0

		pop	cx
		dec	cl
		jnz	loc_a_111A		; Jump if not zero
		dec	ch
		jnz	loc_a_111A		; Jump if not zero
		clc				; Clear carry flag
		retn
sub_a_1083	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_114D	proc	near
		mov	byte ptr ds:d_04E9_CB13_e,0FFh
		retn
sub_a_114D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1153	proc	near
loc_a_1153:
		push	ax
		push	cx
		push	bx
		push	dx
		cmp	al,0Dh
		jae	loc_a_117E		; Jump if above or =
		call	sub_a_1183
		mov	dh,al
		cmp	byte ptr ds:d_04E9_CB13_e,0FFh
		je	loc_a_116E		; Jump if equal
		mov	al,ds:d_04E9_CB14_e
		cmp	al,ch
		jb	loc_a_117E		; Jump if below
loc_a_116E:
		mov	ds:d_04E9_CB15_e,bx
		mov	ds:d_04E9_CB17_e,cl
		mov	ds:d_04E9_CB13_e,dh
		mov	ds:d_04E9_CB14_e,ch
loc_a_117E:
		pop	dx
		pop	bx
		pop	cx
		pop	ax
		retn
sub_a_1153	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1183	proc	near
		mov	bl,al
		xor	bh,bh			; Zero register
		mov	dx,0CB18h
		add	bx,bx
		add	bx,dx
		mov	bx,[bx]
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
		inc	bx
		retn
sub_a_1183	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1197	proc	near
		cmp	byte ptr ds:[1CBh],0
		jne	loc_a_11A1		; Jump if not equal
		jmp	loc_ret_a_12C0
loc_a_11A1:
		cmp	byte ptr data_a_CB13,0FFh
		jne	loc_a_11AB		; Jump if not equal
		jmp	loc_ret_a_12C0
loc_a_11AB:
		mov	bx,data_a_CB15
		mov	al,[bx]
		inc	bx
		mov	data_a_CB15,bx
		cmp	al,80h
		jb	loc_a_11EE		; Jump if below
		jnz	loc_a_11C1		; Jump if not zero
		call	sub_a_121C
		jmp	short loc_a_11F1
loc_a_11C1:
		cmp	al,81h
		jne	loc_a_11CA		; Jump if not equal
		call	sub_a_11FE
		jmp	short loc_a_11F1
loc_a_11CA:
		cmp	al,0C8h
		jne	loc_a_11D3		; Jump if not equal
		call	sub_a_125A
		jmp	short loc_a_11F1
loc_a_11D3:
		cmp	al,0C9h
		jne	loc_a_11DC		; Jump if not equal
		call	sub_a_12C1
		jmp	short loc_a_11F1
loc_a_11DC:
		cmp	al,0CAh
		jne	loc_a_11E5		; Jump if not equal
		call	sub_a_12A6
		jmp	short loc_a_11F1
loc_a_11E5:
		cmp	al,82h
		jb	loc_a_11F8		; Jump if below
		call	sub_a_1221
		jmp	short loc_a_11F1
loc_a_11EE:
		call	sub_a_12C8
loc_a_11F1:
		dec	data_a_CB17
		jz	loc_a_11F8		; Jump if zero
		retn
loc_a_11F8:
		mov	byte ptr data_a_CB13,0FFh
		retn

;==== External Entry into Subroutine ======================================

sub_a_11FE:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,7Ch			; '|'
		mov	dl,al
		mov	ch,12h
		mov	dh,80h
loc_a_1208:
		mov	al,dl
		out	61h,al			; port 61h, 8255 B - spkr, etc
		xor	al,2
		mov	dl,al
		mov	cl,dh
		rcr	al,cl			; Rotate thru carry
		sub	dh,3
		dec	ch
		jnz	loc_a_1208		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_a_121C:
		mov	dx,143h
		jmp	short loc_a_1241

;==== External Entry into Subroutine ======================================

sub_a_1221:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,7Ch			; '|'
		mov	cl,al
		mov	ch,2
		mov	bh,al
		xor	bl,bl			; Zero register
		add	bx,offset data_a_CB32
		mov	dx,143h
loc_a_1234:
		mov	al,[bx]
		and	al,2
		or	al,cl
		out	61h,al			; port 61h, 8255 B - spkr, etc
		inc	bx
		dec	dx
		jnz	loc_a_1234		; Jump if not zero
		retn
loc_a_1241:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,7Ch			; '|'
		mov	cl,al
		mov	ch,2
loc_a_1249:
		call	sub_a_1306
		xor	al,dh
		add	al,dl
		and	al,2
		or	al,cl
		out	61h,al			; port 61h, 8255 B - spkr, etc
		dec	dx
		jnz	loc_a_1249		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_a_125A:
		call	sub_a_1306
		mov	dl,al
		mov	bx,2812h
		mov	cx,7Ah
		in	al,61h			; port 61h, 8255 port B, read
		and	al,7Ch			; '|'
		mov	dh,al

locloop_a_126B:
		mov	al,[bx]
		and	al,2
		or	al,dh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,bl
		add	al,dl
		mov	bl,al
		mov	al,[bx]
		and	al,2
		or	al,dh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,bl
		add	al,dl
		mov	bl,al
		mov	al,[bx]
		and	al,2
		or	al,dh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,bl
		add	al,dl
		mov	bl,al
		mov	al,[bx]
		and	al,2
		or	al,dh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,bl
		add	al,dl
		mov	bl,al
		loop	locloop_a_126B		; Loop if cx > 0

		retn

;==== External Entry into Subroutine ======================================

sub_a_12A6:
		mov	al,byte ptr ds:[1AFh]
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		cmp	al,23h			; '#'
		jb	loc_a_12B3		; Jump if below
		mov	al,22h			; '"'
loc_a_12B3:
		push	ax
		call	sub_a_1306
		and	al,3
		mov	ch,al
		pop	ax
		xor	al,ch
		jmp	short loc_a_12C8

loc_ret_a_12C0:
		retn

;==== External Entry into Subroutine ======================================

sub_a_12C1:
		call	sub_a_1306
		and	al,3
		jmp	short loc_a_12C8

;==== External Entry into Subroutine ======================================

sub_a_12C8:
loc_a_12C8:
		mov	bl,al
		xor	bh,bh			; Zero register
		add	bx,offset data_a_CB83
		mov	dx,148h
		mov	cl,[bx]
		mov	al,2
		xchg	al,ah
		in	al,61h			; port 61h, 8255 port B, read
		and	al,7Ch			; '|'
		mov	ch,al
		mov	bl,cl
loc_a_12E1:
		dec	bl
		jnz	loc_a_12F7		; Jump if not zero
		xchg	al,ah
		xor	al,2
		and	al,2
		or	al,ch
		out	61h,al			; port 61h, 8255 B - spkr, etc
		xchg	al,ah
		mov	bl,cl
loc_a_12F3:
		dec	dx
		jnz	loc_a_12E1		; Jump if not zero
		retn
loc_a_12F7:
		or	al,0
		push	cx
		mov	cx,data_a_D045

locloop_a_12FE:
		nop
		loop	locloop_a_12FE		; Loop if cx > 0

		pop	cx
		test	al,1
		jmp	short loc_a_12F3
sub_a_1197	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1306	proc	near
		mov	bx,offset data_a_CBA7
		inc	data_a_CBB7
		and	byte ptr data_a_CBB7,0Fh
		mov	al,data_a_CBB7
		xlat				; al=[al+[bx]] table
		retn
sub_a_1306	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1318	proc	near
		inc	data_a_CBB8
		and	byte ptr data_a_CBB8,3
		jz	loc_a_1324		; Jump if zero
		retn
loc_a_1324:
		add	byte ptr data_a_CBB9,8
		cmp	byte ptr data_a_CBB9,18h
		je	loc_a_1331		; Jump if equal
		retn
loc_a_1331:
		mov	byte ptr data_a_CBB9,0
		retn
sub_a_1318	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1337	proc	near
		cmp	byte ptr ds:[1A5h],1
		jne	loc_a_133F		; Jump if not equal
		retn
loc_a_133F:
		mov	bx,1CAh
		mov	al,[bx]
		test	al,80h
		jz	loc_a_1349		; Jump if zero
		retn
loc_a_1349:
		inc	al
		mov	[bx],al
		cmp	al,5
		jae	loc_a_1352		; Jump if above or =
		retn
loc_a_1352:
		mov	byte ptr [bx],0
		mov	bx,1C8h
		mov	al,[bx]
		sub	al,1
		das				; Decimal adjust
		mov	[bx],al
		inc	bx
		mov	al,[bx]
		sbb	al,0
		das				; Decimal adjust
		mov	[bx],al
		cmp	word ptr ds:[1C8h],0
		jne	loc_a_1373		; Jump if not equal
		mov	byte ptr ds:[1CAh],0FFh
loc_a_1373:
		jmp	short loc_a_1386

;==== External Entry into Subroutine ======================================

sub_a_1375:
		mov	bl,ds:d_04E9_01AE_e
		add	bl,bl
		xor	bh,bh			; Zero register
		add	bx,d_04E9_CBBA_e
		mov	ax,[bx]
		mov	ds:d_04E9_01C8_e,ax

;==== External Entry into Subroutine ======================================

sub_a_1386:
loc_a_1386:
		mov	word ptr ds:d_04E9_D190_e,24h
		mov	bx,1C9h
		call	sub_a_1393
		dec	bx
sub_a_1337	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1393	proc	near
		mov	al,[bx]
		call	sub_a_2877
		mov	al,[bx]
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		jmp	loc_a_2877
sub_a_1393	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_13A5	proc	near
		mov	ax,4E9h
		mov	es,ax
		mov	di,d_04E9_D44D_e
		mov	cx,64h
		xor	ax,ax			; Zero register

locloop_a_13B2:
		stosw				; Store ax to es:[di]
		add	ax,2000h
		stosw				; Store ax to es:[di]
		sub	ax,1FB0h
		loop	locloop_a_13B2		; Loop if cx > 0

		mov	cx,100h
		mov	di,d_04E9_22F2_e
		xor	al,al			; Zero register

locloop_a_13C4:
		stosb				; Store al to es:[di]
		inc	al
		loop	locloop_a_13C4		; Loop if cx > 0

		mov	si,d_04E9_24F2_e
		mov	di,d_04E9_25F2_e
		mov	cx,100h
		call	sub_a_1405
		mov	si,d_04E9_22F2_e
		mov	di,d_04E9_23F2_e
		mov	cx,100h
		call	sub_a_1405
		mov	si,d_04E9_D2A0_e
		mov	di,si
		mov	cx,57h

locloop_a_13E9:
		mov	al,[si]
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di+1],al
		lodsw				; String [si] to ax
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		inc	di
		loop	locloop_a_13E9		; Loop if cx > 0

		retn
sub_a_13A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1405	proc	near

locloop_a_1405:
		mov	al,[si]
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		xlat				; al=[al+[bx]] table
		mov	[si],al
		inc	si
		loop	locloop_a_1405		; Loop if cx > 0

		retn
sub_a_1405	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1421	proc	near
		xor	cl,cl			; Zero register
		mov	ax,word ptr ds:[251h]
		cmp	ah,3
		jne	loc_a_1443		; Jump if not equal
		cmp	al,0D8h
		jb	loc_a_1443		; Jump if below
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	al,15h
		cmp	al,byte ptr ds:[1AFh]
		jb	loc_a_1457		; Jump if below
		dec	al
		sub	al,byte ptr ds:[1AFh]
		jmp	short loc_a_1455
loc_a_1443:
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	al,13h
		cmp	al,byte ptr ds:[1AFh]
		jb	loc_a_1457		; Jump if below
		inc	al
		sub	al,byte ptr ds:[1AFh]
loc_a_1455:
		mov	cl,al
loc_a_1457:
		mov	al,cl
		mov	byte ptr ds:[259h],al
		retn
sub_a_1421	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_145D	proc	near
		mov	dl,ds:d_04E9_01AE_e
		mov	ax,169Dh
		mov	es,ax
		mov	ds,ax
		mov	bh,dl
		shl	bh,1			; Shift w/zeros fill
		xor	bl,bl			; Zero register
		add	bx,2D6Ah
		mov	si,bx
		mov	al,dl
		xor	ah,ah			; Zero register
		mov	bx,d_169D_3D7A_e
		xlat				; al=[al+[bx]] table
		mov	cx,ax
		mov	dh,al
		mov	al,dl
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		add	ax,3D6Ah
		push	si
		mov	si,ax
		lodsw				; String [si] to ax
		add	ax,2D6Ah
		mov	bp,ax
		pop	si
		mov	ax,4E9h
		mov	es,ax
		mov	di,d_04E9_0A7E_e

locloop_a_149B:
		push	di
		call	sub_a_14B6
		call	sub_a_14B6
		pop	di
		inc	di
		loop	locloop_a_149B		; Loop if cx > 0

		mov	ax,4E9h
		mov	ds,ax
		mov	ds:d_04E9_01AF_e,dh
		mov	word ptr ds:d_04E9_0236_e,0A7Eh
		retn
sub_a_145D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_14B6	proc	near
		mov	al,[si]
		inc	si
		push	cx
		mov	cx,8

locloop_a_14BD:
		ror	al,1			; Rotate
		jnc	loc_a_14CB		; Jump if carry=0
		push	ax
		mov	al,ds:[bp]
		inc	bp
		mov	es:[di],al
		pop	ax
loc_a_14CB:
		add	di,100h
		loop	locloop_a_14BD		; Loop if cx > 0

		pop	cx
		retn
sub_a_14B6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_14D3	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	cl,byte ptr ds:[242h]
		mov	dh,cl
		mov	dl,byte ptr ds:[259h]
		mov	al,cl
		shr	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		mov	cx,ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,cx
		mov	data_a_CBCA,ax
		mov	cx,129Dh
		mov	ds,cx
		mov	si,516h
		sub	si,ax
		mov	di,d_B800_0516_e
		mov	bx,d_169D_1FDC_e
		mov	bp,1FD4h
		mov	cx,4Ch
		mov	al,dl
		xor	ah,ah			; Zero register
		or	al,al			; Zero ?
		jnz	loc_a_1518		; Jump if not zero
		jmp	loc_a_15AC
loc_a_1518:
		dec	al
		jnz	loc_a_1529		; Jump if not zero
		shr	dh,1			; Shift w/zeros fill
		or	dh,dh			; Zero ?
		jnz	loc_a_1525		; Jump if not zero
		jmp	loc_a_15AC
loc_a_1525:
		mov	al,dh
		jmp	short loc_a_1531
loc_a_1529:
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shr	dh,1			; Shift w/zeros fill
		add	al,dh
loc_a_1531:
		push	si
		push	ax
		mov	cx,ax
		mov	ax,4E9h
		mov	ds,ax
		mov	dl,ds:d_04E9_0253_e
		mov	ax,169Dh
		mov	ds,ax
		mov	al,dl
		not	al
		and	al,7
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		mov	bx,ax

		;mov	si,ds:d_169D_0000_e[bx]
		db	8Bh, 0B7h, 0, 0

		mov	bx,si
		mov	dx,cx
loc_a_1557:
		mov	si,d_169D_0020_e
		cmp	dx,0Ch
		jge	loc_a_1578		; Jump if > or =
		mov	si,bx
		mov	ax,0Ch
		sub	ax,dx
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		mov	cx,ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,cx
		shl	ax,1			; Shift w/zeros fill
		add	si,ax
loc_a_1578:
		mov	cx,12h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,d_B800_1FDC_e
		mov	cx,12h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		dec	dx
		jnz	loc_a_1557		; Jump if not zero
		mov	bx,1FDCh
		mov	ax,129Dh
		mov	ds,ax
		pop	ax
		pop	si
		push	ax
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		mov	cx,ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,cx
		add	si,ax
		pop	cx
		mov	ax,4Ch
		sub	ax,cx
		mov	cx,ax
loc_a_15AC:
		mov	ax,4E9h
		mov	ds,ax
		mov	dl,ds:d_04E9_02B1_e
		mov	dh,ds:d_04E9_0242_e
		mov	ax,129Dh
		mov	ds,ax
		or	dl,dl			; Zero ?
		jz	loc_a_1601		; Jump if zero
		shl	dl,1			; Shift w/zeros fill
		shl	dl,1			; Shift w/zeros fill
		sub	cl,dl
		shr	dh,1			; Shift w/zeros fill
		add	cl,dh
		call	sub_a_1601
		sub	di,16h
		mov	cl,ds:d_04E9_02B1_e
		xor	ch,ch			; Zero register
		shl	cx,1			; Shift w/zeros fill
		shl	cx,1			; Shift w/zeros fill
		mov	si,d_04E9_26F2_e
		mov	bx,1FB0h
		mov	bp,2000h
		mov	dx,cx
loc_a_15E7:
		lodsw				; String [si] to ax
		mov	cx,28h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		add	di,bx
		mov	cx,28h
		lodsw				; String [si] to ax
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		sub	di,bp
		cmp	di,d_B800_1CC0_e
		jae	loc_ret_a_1600		; Jump if above or =
		dec	dx
		jnz	loc_a_15E7		; Jump if not zero

loc_ret_a_1600:
		retn

;==== External Entry into Subroutine ======================================

sub_a_1601:
loc_a_1601:
		mov	ax,12h
		mov	dx,cx
loc_a_1606:
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		add	si,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		sub	si,bp
		dec	dx
		jnz	loc_a_1606		; Jump if not zero
		mov	ax,4E9h
		mov	ds,ax
		retn
sub_a_14D3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_161F	proc	near
		mov	ax,129Dh
		mov	es,ax
		mov	dl,byte ptr ds:[251h]
		mov	dh,byte ptr ds:[253h]
		mov	ax,169Dh
		mov	ds,ax
		mov	al,dh
		not	al
		and	al,7
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		mov	bx,ax

		;mov	si,ds:d_169D_0010_e[bx]
		db	8Bh, 0B7h, 10h, 0

		mov	ds:d_169D_0068_e,si
		mov	di,d_129D_0516_e
		mov	bx,1FDCh
		mov	bp,1FD4h
		mov	al,dl
		and	al,7
		cmp	al,4
		jae	loc_a_165C		; Jump if above or =
		sub	di,140h
		jmp	short loc_a_1668
loc_a_165C:
		sub	di,280h
		mov	cx,0Bh
		mov	ax,12h
		jmp	short loc_a_166E
loc_a_1668:
		mov	cx,0Ah
		mov	ax,12h
loc_a_166E:
		mov	dx,cx
loc_a_1670:
		mov	si,ds:d_169D_0068_e
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bx
		mov	cx,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bp
		dec	dx
		jnz	loc_a_1670		; Jump if not zero
		mov	ax,4E9h
		mov	ds,ax
		retn
sub_a_161F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_16DD	proc	near
		mov	ax,129Dh
		mov	es,ax
		mov	data_a_CBCC,1BF8h
		mov	si,1A7Eh
		mov	di,3D6h
		mov	dx,14h
loc_a_16F1:
		mov	cx,12h

locloop_a_16F4:
		mov	bx,data_a_CBCC
		cmp	byte ptr [bx],0
		je	loc_a_1701		; Jump if equal
		mov	al,[bx]
		jmp	short loc_a_1754
loc_a_1701:
		cmp	byte ptr [si],0
		je	loc_a_170A		; Jump if equal
		mov	al,[si]
		jmp	short loc_a_171B
loc_a_170A:
		inc	si
		inc	data_a_CBCC
		inc	di
		inc	di
		loop	locloop_a_16F4		; Loop if cx > 0

		add	di,d_129D_011C_e
		dec	dx
		jnz	loc_a_16F1		; Jump if not zero
		retn
loc_a_171B:
		mov	ah,al
		mov	bx,25F2h
		xlat				; al=[al+[bx]] table
		xchg	ah,al
		dec	bh
		xlat				; al=[al+[bx]] table
		or	es:[di],ax
		or	es:[di+50h],ax
		or	es:d_129D_00A0_e[di],ax
		or	es:d_129D_00F0_e[di],ax
		mov	al,[si]
		mov	ah,al
		dec	bh
		xlat				; al=[al+[bx]] table
		xchg	ah,al
		dec	bh
		xlat				; al=[al+[bx]] table
		or	es:d_129D_20A0_e[di],ax
		or	es:d_129D_2050_e[di],ax
		or	es:d_129D_2000_e[di],ax
		jmp	short loc_a_170A
loc_a_1754:
		mov	ah,al
		mov	bx,25F2h
		xlat				; al=[al+[bx]] table
		xchg	ah,al
		dec	bh
		xlat				; al=[al+[bx]] table
		not	ax
		and	es:[di],ax
		and	es:[di+50h],ax
		and	es:d_129D_00A0_e[di],ax
		and	es:d_129D_00F0_e[di],ax
		and	es:d_129D_20F0_e[di],ax
		and	es:d_129D_20A0_e[di],ax
		and	es:d_129D_2050_e[di],ax
		and	es:d_129D_2000_e[di],ax
		jmp	loc_a_1701
sub_a_16DD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1789	proc	near
		mov	ax,4E9h
		mov	es,ax
		mov	byte ptr ds:[2B1h],0
		mov	di,d_04E9_1A7E_e
		mov	cx,17Ah
		xor	ax,ax			; Zero register
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,word ptr ds:[251h]
		cmp	ax,190h
		jb	loc_a_17EE		; Jump if below
		xor	ax,ax			; Zero register
		call	sub_a_17EE
		inc	byte ptr ds:[2B1h]
		mov	ax,word ptr ds:[251h]
loc_a_17B1:
		add	ax,4
		cmp	ah,4
		je	loc_a_17BF		; Jump if equal
		inc	byte ptr ds:[2B1h]
		jmp	short loc_a_17B1
loc_a_17BF:
		xor	ax,ax			; Zero register
		mov	cl,byte ptr ds:[2B1h]
		xor	ch,ch			; Zero register

locloop_a_17C7:
		xchg	cx,dx
		mov	cx,0ABh
		mov	di,d_04E9_1A7E_e
		mov	si,1A90h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,9
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	cx,0ABh
		mov	di,d_04E9_1BF8_e
		mov	si,1C0Ah
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,9
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xchg	cx,dx
		loop	locloop_a_17C7		; Loop if cx > 0

		retn

;==== External Entry into Subroutine ======================================

sub_a_17EE:
loc_a_17EE:
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	byte ptr ds:[2A8h],al
		mov	ax,word ptr ds:[251h]
		and	al,3
		shl	al,1			; Shift w/zeros fill
		mov	byte ptr ds:[242h],al
		mov	al,byte ptr ds:[253h]
		mov	cl,al
		and	al,7
		add	al,58h			; 'X'
		mov	byte ptr ds:[2A7h],al
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		mov	al,0Bh
		sub	al,cl
		and	al,0Fh
		mov	byte ptr data_a_0263+43h,al	; (' ')
		mov	byte ptr ds:[2A9h],0
		mov	word ptr ds:[2AAh],0CBCEh
loc_a_1825:
		cmp	byte ptr ds:[2A9h],8
		jne	loc_a_183F		; Jump if not equal
		mov	di,d_04E9_1A81_e
		mov	bl,14h
		xor	ax,ax			; Zero register
loc_a_1833:
		mov	cx,6
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		add	di,6
		dec	bl
		jnz	loc_a_1833		; Jump if not zero
loc_a_183F:
		mov	al,byte ptr ds:[2A8h]
		mov	ah,byte ptr data_a_0263+43h	; (' ')
		add	ax,0A7Eh
		mov	word ptr ds:[2ACh],ax
		mov	al,byte ptr ds:[2A7h]
		xor	ah,ah			; Zero register
		add	ax,2172h
		mov	bx,ax
		mov	al,[bx]
		test	al,80h
		jz	loc_a_185F		; Jump if zero
		jmp	loc_a_194F
loc_a_185F:
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	data_a_CC53,al
		mov	data_a_CBEE,al
		mov	al,[bx]
		and	al,3
		mov	data_a_CC52,al
		mov	data_a_CBEF,al
		mov	al,byte ptr ds:[2A7h]
		xor	ah,ah			; Zero register
		add	ax,21F2h
		mov	bx,ax
		mov	al,[bx]
		test	al,80h
		jnz	loc_a_1887		; Jump if not zero
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
loc_a_1887:
		mov	data_a_CC55,al
		mov	data_a_CC56,al
		mov	al,[bx]
		and	al,3
		mov	data_a_CC54,al
		mov	data_a_CC57,al
		mov	byte ptr ds:[2AEh],14h
		mov	si,1BD4h
loc_a_189F:
		mov	bx,word ptr ds:[2ACh]
		mov	al,[bx]
		inc	word ptr ds:[2ACh]
		add	al,al
		jc	loc_a_18C1		; Jump if carry Set
loc_a_18AD:
		sub	si,12h
		dec	byte ptr ds:[2AEh]
		jnz	loc_a_189F		; Jump if not zero
		jmp	loc_a_194F
data_a_18B9	dw	offset loc_a_1ABD	; Data table (indexed access)
data_a_18BB	dw	offset loc_a_1A50
data_a_18BD	dw	offset loc_a_1B19
data_a_18BF	dw	offset loc_a_1945
loc_a_18C1:
		ror	al,1			; Rotate
		mov	cl,al
		and	al,0Ch
		jz	loc_a_18CE		; Jump if zero
		test	cl,1
		jnz	loc_a_18DD		; Jump if not zero
loc_a_18CE:
		mov	al,cl
		and	al,3
		xor	ah,ah			; Zero register
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_18B9[bx]	;*4 entries
loc_a_18DD:
		mov	al,data_a_CBEE
		xor	ah,ah			; Zero register
		test	al,80h
		jnz	loc_a_18AD		; Jump if not zero
		push	si
		add	si,ax
		mov	al,data_a_CBEF
		or	al,al			; Zero ?
		jz	loc_a_192F		; Jump if zero
		dec	al
		jz	loc_a_191D		; Jump if zero
		dec	al
		jz	loc_a_190B		; Jump if zero
		mov	byte ptr [si+1],3Fh	; '?'
		mov	byte ptr [si+2],0FFh
		and	byte ptr [si+3],0Fh
		or	byte ptr [si+3],0C0h
		pop	si
		jmp	short loc_a_18AD
loc_a_190B:
		and	byte ptr [si],0FCh
		mov	byte ptr [si+1],0FFh
		mov	byte ptr [si+2],0FFh
		and	byte ptr [si+3],3Fh	; '?'
		pop	si
		jmp	short loc_a_18AD
loc_a_191D:
		and	byte ptr [si],0F0h
		or	byte ptr [si],3
		mov	byte ptr [si+1],0FFh
		mov	byte ptr [si+2],0FCh
		pop	si
		jmpn	loc_a_18AD
loc_a_192F:
		and	byte ptr [si],0C0h
		or	byte ptr [si],0Fh
		mov	byte ptr [si+1],0FFh
		and	byte ptr [si+2],3
		or	byte ptr [si+2],0F0h
		pop	si
		jmp	loc_a_18AD

;===== Indexed Entry Point ================================================

loc_a_1945:
		mov	al,byte ptr ds:[2A7h]
		cmp	al,40h			; '@'
		jb	loc_a_197C		; Jump if below
		jmp	loc_a_18AD
loc_a_194F:
		mov	al,byte ptr data_a_0263+43h	; (' ')
		mov	bx,word ptr ds:[2AAh]
		add	al,[bx]
		and	al,0Fh
		mov	byte ptr data_a_0263+43h,al	; (' ')
		inc	bx
		mov	al,byte ptr ds:[2A7h]
		add	al,[bx]
		and	al,7Fh
		mov	byte ptr ds:[2A7h],al
		inc	bx
		mov	word ptr ds:[2AAh],bx
		inc	byte ptr ds:[2A9h]
		test	byte ptr ds:[2A9h],10h
		jnz	loc_ret_a_197B		; Jump if not zero
		jmp	loc_a_1825

loc_ret_a_197B:
		retn
loc_a_197C:
		xor	ah,ah			; Zero register
		mov	word ptr ds:[2AFh],ax
		add	ax,2272h
		mov	di,ax
		mov	al,[di]
		add	al,3
		xor	ah,ah			; Zero register
		add	ax,si
		mov	data_a_CC50,ax
		mov	ax,word ptr ds:[2AFh]
		add	ax,22B2h
		mov	di,ax
		mov	al,[di]
		test	al,80h
		jz	loc_a_19CE		; Jump if zero
		and	al,0Fh
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		add	ax,0CBF0h
		mov	di,ax
		push	si
		mov	si,data_a_CC50
		mov	al,[si]
		and	al,[di]
		or	al,[di+1]
		mov	[si],al
		add	di,20h
		add	si,17Ah
		mov	al,[si]
		or	al,[di+1]
		mov	[si],al
		sub	si,17Ah
		pop	si
		jmp	loc_a_18AD
loc_a_19CE:
		push	si
		mov	cl,al
		and	al,3
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		add	ax,0CC30h
		mov	di,ax
		mov	si,data_a_CC50
		mov	al,[si]
		and	al,[di]
		or	al,[di+1]
		mov	[si],al
		add	si,17Ah
		or	al,[di+9]
		mov	[si],al
		sub	si,179h
		mov	al,cl
		and	al,30h			; '0'
		jz	loc_a_1A2B		; Jump if zero
		cmp	al,20h			; ' '
		mov	al,0
		jc	loc_a_1A1E		; Jump if carry Set
		jz	loc_a_1A11		; Jump if zero
		mov	[si],al
		add	si,17Ah
		mov	byte ptr [si],0FFh
		sub	si,179h
loc_a_1A11:
		mov	[si],al
		add	si,17Ah
		mov	byte ptr [si],0FFh
		sub	si,179h
loc_a_1A1E:
		mov	[si],al
		add	si,17Ah
		mov	byte ptr [si],0FFh
		sub	si,179h
loc_a_1A2B:
		mov	al,cl
		ror	al,1			; Rotate
		and	al,6
		xor	ah,ah			; Zero register
		add	ax,0CC40h
		mov	di,ax
		mov	al,[si]
		and	al,[di]
		or	al,[di+1]
		mov	[si],al
		add	si,17Ah
		mov	al,[si]
		or	al,[di+9]
		mov	[si],al
		pop	si
		jmp	loc_a_18AD

;===== Indexed Entry Point ================================================

loc_a_1A50:
		push	si
		mov	al,data_a_CC53
		xor	ah,ah			; Zero register
		add	si,ax
		mov	al,data_a_CC52
		or	al,al			; Zero ?
		jz	loc_a_1A7E		; Jump if zero
		dec	al
		jz	loc_a_1A8D		; Jump if zero
		dec	al
		jz	loc_a_1AA3		; Jump if zero
		and	byte ptr [si],0FCh
		mov	byte ptr [si+1],6Fh	; 'o'
		mov	byte ptr [si+2],0EEh
		and	byte ptr [si+3],3
		or	byte ptr [si+3],90h
		pop	si
		jmp	loc_a_18AD
loc_a_1A7E:
		mov	byte ptr [si],1Bh
		mov	byte ptr [si+1],0FBh
		mov	byte ptr [si+2],0A4h
		pop	si
		jmp	loc_a_18AD
loc_a_1A8D:
		and	byte ptr [si],0C0h
		or	byte ptr [si],6
		mov	byte ptr [si+1],0FEh
		mov	byte ptr [si+2],0E9h
		and	byte ptr [si+3],3Fh	; '?'
		pop	si
		jmp	loc_a_18AD
loc_a_1AA3:
		and	byte ptr [si],0F0h
		or	byte ptr [si],1
		mov	byte ptr [si+1],0BFh
		mov	byte ptr [si+2],0BAh
		and	byte ptr [si+3],0Fh
		or	byte ptr [si+3],40h	; '@'
		pop	si
		jmp	loc_a_18AD

;===== Indexed Entry Point ================================================

loc_a_1ABD:
		mov	al,data_a_CC55
		xor	ah,ah			; Zero register
		test	al,80h
		jz	loc_a_1AC9		; Jump if zero
		jmp	loc_a_18AD
loc_a_1AC9:
		push	si
		add	si,ax
		mov	al,data_a_CC54
		or	al,al			; Zero ?
		jz	loc_a_1B0A		; Jump if zero
		dec	al
		jz	loc_a_1AF8		; Jump if zero
		dec	al
		jz	loc_a_1AEA		; Jump if zero
		and	byte ptr [si],0FCh
		mov	byte ptr [si+1],0BEh
		and	byte ptr [si+2],3Fh	; '?'
		pop	si
		jmp	loc_a_18AD
loc_a_1AEA:
		and	byte ptr [si],0F0h
		or	byte ptr [si],2
		mov	byte ptr [si+1],0F8h
		pop	si
		jmp	loc_a_18AD
loc_a_1AF8:
		and	byte ptr [si],0C0h
		or	byte ptr [si],0Bh
		and	byte ptr [si+1],3
		or	byte ptr [si+1],0E0h
		pop	si
		jmp	loc_a_18AD
loc_a_1B0A:
		mov	byte ptr [si],2Fh	; '/'
		and	byte ptr [si+1],0Fh
		or	byte ptr [si+1],80h
		pop	si
		jmp	loc_a_18AD

;===== Indexed Entry Point ================================================

loc_a_1B19:
		mov	al,data_a_CC56
		xor	ah,ah			; Zero register
		test	al,80h
		jz	loc_a_1B25		; Jump if zero
		jmp	loc_a_18AD
loc_a_1B25:
		push	si
		add	si,ax
		mov	al,data_a_CC57
		or	al,al			; Zero ?
		jz	loc_a_1B8B		; Jump if zero
		dec	al
		jz	loc_a_1B6C		; Jump if zero
		dec	al
		jz	loc_a_1B52		; Jump if zero
		mov	al,data_a_CBB9
		add	ax,0CC5Eh
		mov	bx,ax
		mov	al,[si]
		and	al,0FCh
		mov	[si],al
		mov	al,[bx]
		mov	[si+1],al
		and	byte ptr [si+2],3Fh	; '?'
		pop	si
		jmp	loc_a_18AD
loc_a_1B52:
		mov	al,data_a_CBB9
		add	ax,0CC5Ch
		mov	bx,ax
		mov	al,[si]
		and	al,0F0h
		or	al,[bx]
		mov	[si],al
		mov	al,[bx+1]
		mov	[si+1],al
		pop	si
		jmp	loc_a_18AD
loc_a_1B6C:
		mov	al,data_a_CBB9
		add	ax,0CC5Ah
		mov	bx,ax
		mov	al,[si]
		and	al,0C0h
		or	al,[bx]
		mov	[si],al
		mov	al,[si+1]
		and	al,3
		or	al,[bx+1]
		mov	[si+1],al
		pop	si
		jmp	loc_a_18AD
loc_a_1B8B:
		mov	al,data_a_CBB9
		add	ax,0CC58h
		mov	bx,ax
		mov	al,[bx]
		mov	[si],al
		mov	al,[si+1]
		and	al,0Fh
		or	al,[bx+1]
		mov	[si+1],al
		pop	si
		jmp	loc_a_18AD
sub_a_1789	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1BA6	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	al,byte ptr ds:[253h]
		mov	data_a_CC70,al
		mov	data_a_CC75,al
		mov	cl,20h			; ' '
		mov	al,byte ptr ds:[251h]
		test	al,4
		jz	loc_a_1BC3		; Jump if zero
		mov	cl,28h			; '('
		dec	byte ptr ds:[259h]
loc_a_1BC3:
		and	al,3
		shl	al,1			; Shift w/zeros fill
		add	al,cl
		mov	cl,al
		mov	data_a_CC71,al
		mov	al,byte ptr ds:[251h]
		ror	al,1			; Rotate
		ror	al,1			; Rotate
		ror	al,1			; Rotate
		xor	al,0Fh
		and	al,0Fh
		xor	ah,ah			; Zero register
		add	ax,0CC78h
		mov	data_a_CC73,ax
		mov	word ptr ds:[2AFh],ax
		mov	data_a_CC77,cl
		mov	al,byte ptr ds:[259h]
		mov	byte ptr ds:[2AEh],al
		mov	cx,0Ah

locloop_a_1BF3:
		cmp	cx,0Ah
		je	loc_a_1C3E		; Jump if equal
		mov	bx,word ptr ds:[2AFh]
		mov	al,[bx]
		sub	al,data_a_CC75
		and	al,3Fh			; '?'
		cmp	al,24h			; '$'
		jae	loc_a_1C3E		; Jump if above or =
		test	byte ptr ds:[2AEh],80h
		jz	loc_a_1C17		; Jump if zero
		cmp	al,0Ch
		jb	loc_a_1C17		; Jump if below
		cmp	al,18h
		jb	loc_a_1C3E		; Jump if below
loc_a_1C17:
		add	al,2
		shl	al,1			; Shift w/zeros fill
		mov	ah,data_a_CC77
		call	sub_a_455B
		mov	si,ax
		cmp	word ptr es:[si],0
		jne	loc_a_1C3E		; Jump if not equal
		mov	word ptr es:[si],0C003h
		cmp	word ptr es:d_B800_2000_e[si],0
		jne	loc_a_1C3E		; Jump if not equal
		mov	word ptr es:d_B800_2000_e[si],0C003h
loc_a_1C3E:
		inc	word ptr ds:[2AFh]
		add	byte ptr data_a_CC77,10h
		cmp	byte ptr data_a_CC77,0B8h
		jae	loc_ret_a_1C58		; Jump if above or =
		dec	byte ptr ds:[2AEh]
		dec	byte ptr ds:[2AEh]
		loop	locloop_a_1BF3		; Loop if cx > 0


loc_ret_a_1C58:
		retn
sub_a_1BA6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1C59	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	ax,data_a_CC73
		mov	word ptr ds:[2AFh],ax
		mov	al,data_a_CC71
		mov	data_a_CC77,al
		mov	cx,0Ah
		mov	al,data_a_CC70
		mov	data_a_CC76,al

locloop_a_1C73:
		mov	bx,word ptr ds:[2AFh]
		mov	al,[bx]
		sub	al,data_a_CC76
		and	al,3Fh			; '?'
		cmp	al,24h			; '$'
		jae	loc_a_1CAC		; Jump if above or =
		add	al,2
		shl	al,1			; Shift w/zeros fill
		mov	ah,data_a_CC77
		call	sub_a_455B
		mov	si,ax
		cmp	word ptr es:[si],0C003h
		jne	loc_a_1CAC		; Jump if not equal
		mov	word ptr es:[si],0
		cmp	word ptr es:d_B800_2000_e[si],0C003h
		jne	loc_a_1CAC		; Jump if not equal
		mov	word ptr es:d_B800_2000_e[si],0
loc_a_1CAC:
		inc	word ptr ds:[2AFh]
		add	byte ptr data_a_CC77,10h
		cmp	byte ptr data_a_CC77,0B8h
		jae	loc_ret_a_1CBE		; Jump if above or =
		loop	locloop_a_1C73		; Loop if cx > 0


loc_ret_a_1CBE:
		retn
sub_a_1C59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1CBF	proc	near
		mov	ax,ds:d_04E9_0188_e
		sub	al,28h			; '('
		sbb	ah,0
		and	ah,3
		xor	bl,bl			; Zero register
		mov	cx,ds:d_04E9_0251_e
		sub	al,cl
		sbb	ah,ch
		and	ah,3
		cmp	ah,2
		jb	loc_a_1CE0		; Jump if below
		dec	bl
		neg	al
loc_a_1CE0:
		cmp	al,0
		je	loc_ret_a_1D03		; Jump if equal
		add	al,3
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		test	bl,80h
		jz	loc_a_1CF1		; Jump if zero
		neg	al
loc_a_1CF1:
		add	al,ds:d_04E9_0251_e
		mov	ds:d_04E9_0251_e,al
		adc	bl,byte ptr ds:d_04E9_0251_e+1
		and	bl,3
		mov	byte ptr ds:d_04E9_0251_e+1,bl

loc_ret_a_1D03:
		retn
sub_a_1CBF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1D04	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	di,d_B800_03C0_e
		mov	cx,58h
		xor	ax,ax			; Zero register

locloop_a_1D11:
		push	cx
		mov	cx,50h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		add	di,d_B800_1FB0_e
		mov	cx,50h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		sub	di,2000h
		pop	cx
		loop	locloop_a_1D11		; Loop if cx > 0

		retn
sub_a_1D04	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1D28	proc	near
		mov	al,ds:d_04E9_01AE_e
		xor	ah,ah			; Zero register
		add	ax,199h
		mov	bx,ax
		mov	byte ptr [bx],0
		mov	bx,d_04E9_0254_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1D41		; Jump if equal
		inc	bx
		inc	bx
loc_a_1D41:
		inc	byte ptr [bx]
		mov	al,[bx]
		mov	ds:d_04E9_01AE_e,al
		retn
sub_a_1D28	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1D49	proc	near
		mov	bx,255h
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1D55		; Jump if equal
		inc	bx
		inc	bx
loc_a_1D55:
		mov	byte ptr [bx],0
		retn
sub_a_1D49	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1D59	proc	near
		mov	bx,d_04E9_0254_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1D65		; Jump if equal
		inc	bx
		inc	bx
loc_a_1D65:
		mov	al,ds:d_04E9_01AE_e
		mov	[bx],al
		inc	bx
		push	bx
		mov	cx,8
		xor	al,al			; Zero register
		mov	bx,d_04E9_0199_e

locloop_a_1D74:
		mov	ah,[bx]
		rcr	ah,1			; Rotate thru carry
		rcr	al,1			; Rotate thru carry
		inc	bx
		loop	locloop_a_1D74		; Loop if cx > 0

		pop	bx
		mov	[bx],al
		retn
sub_a_1D59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1D81	proc	near
		mov	bp,1B8h
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1D8E		; Jump if equal
		mov	bp,d_04E9_01BC_e
loc_a_1D8E:
		mov	al,ds:[bp]
		add	al,bl
		daa				; Decimal adjust
		mov	ds:[bp],al
		inc	bp
		mov	al,ds:[bp]
		mov	dh,al
		adc	al,bh
		daa				; Decimal adjust
		mov	ds:[bp],al
		mov	dl,al
		inc	bp
		mov	al,ds:[bp]
		adc	al,0
		daa				; Decimal adjust
		mov	ds:[bp],al
		inc	bp
		mov	al,ds:[bp]
		adc	al,0
		daa				; Decimal adjust
		mov	ds:[bp],al
		inc	bp
		mov	al,dh
		and	al,0F0h
		cmp	al,40h			; '@'
		jne	loc_a_1DD2		; Jump if not equal
		mov	al,dl
		and	al,0F0h
		cmp	al,50h			; 'P'
		je	loc_a_1DE0		; Jump if equal
loc_a_1DD2:
		mov	al,dh
		and	al,0F0h
		cmp	al,90h
		jne	loc_ret_a_1DF8		; Jump if not equal
		mov	al,dl
		and	al,0F0h
		jnz	loc_ret_a_1DF8		; Jump if not zero
loc_a_1DE0:
		mov	bx,d_04E9_01B6_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1DEB		; Jump if equal
		inc	bx
loc_a_1DEB:
		inc	byte ptr [bx]
		cmp	byte ptr [bx],8
		jb	loc_a_1DF5		; Jump if below
		mov	byte ptr [bx],8
loc_a_1DF5:
		call	sub_a_2756

loc_ret_a_1DF8:
		retn
sub_a_1D81	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 09h and INT 1Ch handler

sub_a_1DF9	proc	near
		call	sub_a_0000		; Install INT 1Ch handler

		push	es
		mov	ah,35h			; '5'
		mov	al,9
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	di,d_04E9_CDC8_e
		mov	[di],es
		mov	[di+2],bx
		pop	es
		push	ds
		push	cs
		pop	ds
		mov	dx,offset int_09h_entry
		mov	ah,25h			; '%'
		mov	al,9
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		retn

;==== External Entry into Subroutine ======================================

; Restore INT 09h handler

sub_a_1E1A:
		call	sub_a_0021
		push	ds
		mov	di,offset data_a_CDC8
		mov	dx,[di+2]
		mov	ax,[di]
		mov	ds,ax
		mov	ah,25h			; '%'
		mov	al,9
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		xor	al,al			; Zero register
		out	21h,al			; port 21h, 8259-1 int comands
		retn
sub_a_1DF9	endp


;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

int_09h_entry	proc	far
		push	bx
		push	ax
		push	ds
		mov	ax,4E9h
		mov	ds,ax
		in	al,60h			; port 60h, keybd scan or sw1
		mov	bl,al
		in	al,61h			; port 61h, 8255 port B, read
		mov	ah,al
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
		xchg	ah,al
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,bl
		xor	ah,ah			; Zero register
		mov	bx,0CDCCh		; key pressed map
		test	al,80h
		jnz	loc_a_1E5E		; Jump if not zero
		add	bx,ax
		mov	byte ptr [bx],1
		jmp	short loc_a_1E65
loc_a_1E5E:
		and	al,7Fh
		add	bx,ax
		mov	byte ptr [bx],0
loc_a_1E65:
		mov	al,61h			; 'a'
		out	20h,al			; port 20h, 8259-1 int command
		pop	ds
		pop	ax
		pop	bx
		iret				; Interrupt return
int_09h_entry	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Load state of keys

sub_a_1E6D	proc	near
		cmp	byte ptr ds:d_04E9_0238_e,1
		jne	loc_a_1E77		; Jump if not equal
;*		jmp	loc_a_02BD		;*
		db	0E9h, 46h,0E4h		;  Fixup - byte match
loc_a_1E77:
		mov	cx,8
		xor	bx,bx			; Zero register
		mov	si,d_04E9_CE4D_e
		mov	di,d_04E9_CDCC_e	; key pressed map

locloop_a_1E82:
		mov	bl,[si]
		mov	al,[bx+di]
		shr	al,1			; Shift w/zeros fill
		rcl	byte ptr ds:d_04E9_CE4C_e,1	; Rotate thru carry
		inc	si
		loop	locloop_a_1E82		; Loop if cx > 0

		retn
sub_a_1E6D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1E90	proc	near
		call	sub_a_1D04
		retn
sub_a_1E90	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1E94	proc	near
		call	sub_a_1E90
		mov	al,2
		call	sub_a_105A
		mov	bp,d_04E9_CEA3_e
		call	sub_a_48FD
		call	sub_a_2438
		mov	bp,d_04E9_CEBD_e
		call	sub_a_48FD
loc_a_1EAB:
		call	sub_a_1083
		jnc	loc_a_1EAB		; Jump if carry=0
		mov	al,19h
		call	sub_a_2448
		jmp	loc_a_227A
sub_a_1E94	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1EB8	proc	near
		call	sub_a_1E90
		mov	al,2
		call	sub_a_105A
		mov	bp,d_04E9_CFAB_e
		call	sub_a_48FD
		call	sub_a_2438
		mov	bp,d_04E9_CF82_e
		call	sub_a_48FD
loc_a_1ECF:
		call	sub_a_1083
		jnc	loc_a_1ECF		; Jump if carry=0
		mov	al,19h
		jmp	loc_a_2448
sub_a_1EB8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1ED9	proc	near
		call	sub_a_1E90
		mov	bp,d_04E9_CF3F_e
		call	sub_a_48FD
		call	sub_a_2438
		mov	bp,d_04E9_CF59_e
		call	sub_a_48FD
		mov	al,0FFh
		call	sub_a_2448
		jmp	loc_a_227A
sub_a_1ED9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1EF3	proc	near
		call	sub_a_1E90
		mov	byte ptr ds:d_04E9_CFB1_e,0
		call	sub_a_1FB7
		mov	al,64h			; 'd'
		call	sub_a_2448
		and	word ptr ds:d_04E9_01C8_e,0F0h
loc_a_1F09:
		cmp	word ptr ds:d_04E9_01C8_e,0
		je	loc_a_1F33		; Jump if equal
		mov	al,ds:d_04E9_01C8_e
		sub	al,10h
		das				; Decimal adjust
		mov	ds:d_04E9_01C8_e,al
		mov	al,byte ptr ds:d_04E9_01C8_e+1
		sbb	al,0
		das				; Decimal adjust
		mov	byte ptr ds:d_04E9_01C8_e+1,al
		call	sub_a_1FB7
		call	sub_a_1386
		mov	bx,14h
		call	sub_a_1D81
		call	sub_a_2813
		jmp	short loc_a_1F09
loc_a_1F33:
		mov	bx,d_04E9_01C0_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1F3F		; Jump if equal
		inc	bx
		inc	bx
loc_a_1F3F:
		mov	al,[bx]
		or	al,[bx+1]
		jz	loc_a_1F64		; Jump if zero
		mov	al,[bx]
		sub	al,1
		das				; Decimal adjust
		mov	[bx],al
		mov	al,[bx+1]
		sbb	al,0
		das				; Decimal adjust
		mov	[bx+1],al
		call	sub_a_1FB7
		mov	bx,14h
		call	sub_a_1D81
		call	sub_a_2813
		jmp	short loc_a_1F33
loc_a_1F64:
		mov	bx,d_04E9_01C4_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1F70		; Jump if equal
		inc	bx
		inc	bx
loc_a_1F70:
		mov	al,[bx]
		or	al,[bx+1]
		jz	loc_a_1F95		; Jump if zero
		mov	al,[bx]
		sub	al,1
		das				; Decimal adjust
		mov	[bx],al
		mov	al,[bx+1]
		sbb	al,0
		das				; Decimal adjust
		mov	[bx+1],al
		call	sub_a_1FB7
		mov	bx,14h
		call	sub_a_1D81
		call	sub_a_2813
		jmp	short loc_a_1F64
loc_a_1F95:
		call	sub_a_1FB7
		mov	al,64h			; 'd'
		jmp	loc_a_2448
sub_a_1EF3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1F9D	proc	near
		cmp	byte ptr ds:d_04E9_01CB_e,0
		jne	loc_a_1FA5		; Jump if not equal
		retn
loc_a_1FA5:
		inc	byte ptr ds:d_04E9_CFB2_e
		and	byte ptr ds:d_04E9_CFB2_e,1Fh
		mov	al,ds:d_04E9_CFB2_e
		mov	cx,1388h
		jmp	loc_a_4BBA
sub_a_1F9D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1FB7	proc	near
		cmp	byte ptr ds:d_04E9_01CB_e,0
		je	loc_a_1FC1		; Jump if equal
		call	sub_a_1F9D
loc_a_1FC1:
		mov	al,byte ptr ds:d_04E9_01C8_e+1
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		add	al,30h			; '0'
		mov	ds:d_04E9_CF0B_e,al
		mov	al,byte ptr ds:d_04E9_01C8_e+1
		and	al,0Fh
		add	al,30h			; '0'
		mov	ds:d_04E9_CF0C_e,al
		mov	al,ds:d_04E9_01C8_e
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		add	al,30h			; '0'
		mov	ds:d_04E9_CF0D_e,al
		mov	bx,d_04E9_01C0_e
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_1FF7		; Jump if equal
		inc	bx
		inc	bx
loc_a_1FF7:
		mov	al,[bx+1]
		add	al,30h			; '0'
		mov	ds:d_04E9_CF23_e,al
		mov	al,[bx]
		and	al,0Fh
		add	al,30h			; '0'
		mov	ds:d_04E9_CF25_e,al
		mov	al,[bx]
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		add	al,30h			; '0'
		mov	ds:d_04E9_CF24_e,al
		add	bx,4
		mov	al,[bx+1]
		add	al,30h			; '0'
		mov	ds:d_04E9_CF3B_e,al
		mov	al,[bx]
		and	al,0Fh
		add	al,30h			; '0'
		mov	ds:d_04E9_CF3D_e,al
		mov	al,[bx]
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		add	al,30h			; '0'
		mov	ds:d_04E9_CF3C_e,al
		cmp	byte ptr ds:d_04E9_CFB1_e,0
		jne	loc_a_206A		; Jump if not equal
		mov	byte ptr ds:d_04E9_CFB1_e,1
		mov	bp,d_04E9_CED0_e
		call	sub_a_48FD
		mov	bp,d_04E9_CF08_e
		call	sub_a_48FD
		mov	bp,d_04E9_CF0F_e
		call	sub_a_48FD
		mov	bp,d_04E9_CF20_e
		call	sub_a_48FD
		mov	bp,d_04E9_CF27_e
		call	sub_a_48FD
		mov	bp,0CF38h
		jmp	loc_a_48FD
loc_a_206A:
		mov	bp,d_04E9_CF06_e
		call	sub_a_48FD
		mov	bp,d_04E9_CF20_e
		call	sub_a_48FD
		mov	bp,0CF38h
		jmp	loc_a_48FD
sub_a_1FB7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_207C	proc	near
		call	sub_a_1E90
		xor	al,al			; Zero register
		call	sub_a_105A
		mov	byte ptr ds:d_04E9_CFA8_e,0
		mov	byte ptr ds:d_04E9_CFA9_e,0C0h
		mov	byte ptr ds:d_04E9_CFAA_e,0
		jmp	short loc_a_2098
loc_a_2095:
		call	sub_a_1D04
loc_a_2098:
		cmp	byte ptr ds:d_04E9_CFA8_e,0
		je	loc_a_20A7		; Jump if equal
		call	sub_a_21C0
		call	sub_a_2249
		jmp	short loc_a_20B3
loc_a_20A7:
		call	sub_a_45C1
		mov	bp,d_04E9_CFB3_e
		call	sub_a_45FC
		call	sub_a_2249
loc_a_20B3:
		cmp	byte ptr ds:d_04E9_CFAA_e,0
		jne	loc_a_20C4		; Jump if not equal
loc_a_20BA:
		call	sub_a_3733
		cmp	byte ptr ds:d_04E9_023D_e,0
		jne	loc_a_20BA		; Jump if not equal
loc_a_20C4:
		mov	byte ptr ds:d_04E9_CFAA_e,1
		call	sub_a_1083
		cmp	byte ptr ds:d_04E9_CE15_e,1
		jne	loc_a_20E1		; Jump if not equal
		cmp	word ptr ds:d_04E9_D045_e,1
		je	loc_a_20E1		; Jump if equal
		dec	word ptr ds:d_04E9_D045_e
		call	sub_a_45B2
loc_a_20E1:
		cmp	byte ptr ds:d_04E9_CE1D_e,1
		jne	loc_a_20F6		; Jump if not equal
;*		cmp	word ptr ds:d_04E9_D045_e,0FFFFh
		db	 83h, 3Eh, 45h,0D0h,0FFh	;  Fixup - byte match
		jz	loc_a_20F6		; Jump if zero
		inc	word ptr ds:d_04E9_D045_e
		call	sub_a_45B2
loc_a_20F6:
		cmp	byte ptr ds:d_04E9_CE1B_e,1
		jne	loc_a_2107		; Jump if not equal
loc_a_20FD:
		cmp	byte ptr ds:d_04E9_CE1B_e,1
		je	loc_a_20FD		; Jump if equal
		call	sub_a_4D13
loc_a_2107:
		call	sub_a_1E6D
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_2114		; Jump if not equal
		jmp	loc_a_2461
loc_a_2114:
		cmp	byte ptr ds:d_04E9_CDCE_e,1
		je	loc_a_2124		; Jump if equal
		cmp	byte ptr ds:d_04E9_CE07_e,1
		je	loc_a_2124		; Jump if equal
		jmp	short loc_a_212C
loc_a_2124:
		mov	byte ptr ds:d_04E9_01B4_e,1
		jmp	loc_a_2098
loc_a_212C:
		cmp	byte ptr ds:d_04E9_CDCF_e,1
		je	loc_a_213C		; Jump if equal
		cmp	byte ptr ds:d_04E9_CE08_e,1
		je	loc_a_213C		; Jump if equal
		jmp	short loc_a_2144
loc_a_213C:
		mov	byte ptr ds:d_04E9_01B4_e,2
		jmp	loc_a_2098
loc_a_2144:
		cmp	byte ptr ds:d_04E9_CDD0_e,1
		je	loc_a_2154		; Jump if equal
		cmp	byte ptr ds:d_04E9_CE09_e,1
		je	loc_a_2154		; Jump if equal
		jmp	short loc_a_215C
loc_a_2154:
		mov	byte ptr ds:d_04E9_01CB_e,80h
		jmp	loc_a_2098
loc_a_215C:
		cmp	byte ptr ds:d_04E9_CDD1_e,1
		je	loc_a_216C		; Jump if equal
		cmp	byte ptr ds:d_04E9_CE0A_e,1
		je	loc_a_216C		; Jump if equal
		jmp	short loc_a_2174
loc_a_216C:
		mov	byte ptr ds:d_04E9_01CB_e,0
		jmp	loc_a_2098
loc_a_2174:
		cmp	byte ptr ds:d_04E9_D5ED_e,0
		je	loc_a_2191		; Jump if equal
		cmp	byte ptr ds:d_04E9_CE0B_e,1
		je	loc_a_218B		; Jump if equal
		cmp	byte ptr ds:d_04E9_CDD2_e,1
		je	loc_a_218B		; Jump if equal
		jmp	short loc_a_2191
loc_a_218B:
		call	sub_a_45D7
		jmp	loc_a_2098
loc_a_2191:
		cmp	byte ptr ds:d_04E9_D5ED_e,0FFh
		je	loc_a_21A6		; Jump if equal
		cmp	byte ptr ds:d_04E9_CE0C_e,1
		je	loc_a_218B		; Jump if equal
		cmp	byte ptr ds:d_04E9_CDD3_e,1
		je	loc_a_218B		; Jump if equal
loc_a_21A6:
		dec	byte ptr ds:d_04E9_CFA9_e
		jz	loc_a_21AF		; Jump if zero
		jmp	loc_a_20C4
loc_a_21AF:
		mov	al,1
		sub	al,ds:d_04E9_CFA8_e
		mov	ds:d_04E9_CFA8_e,al
		mov	byte ptr ds:d_04E9_CFA9_e,0C0h
		jmp	loc_a_2095
sub_a_207C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_21C0	proc	near
		mov	bp,d_04E9_D05A_e
		call	sub_a_45FC
		mov	bp,d_04E9_D047_e
		call	sub_a_45FC
		mov	bp,0D029h
		call	sub_a_21F5
		mov	bp,d_04E9_D04D_e
		call	sub_a_45FC
		mov	bp,0D030h
		call	sub_a_21F5
		mov	bp,d_04E9_D051_e
		call	sub_a_45FC
		mov	bp,0D037h
		call	sub_a_21F5
		mov	bp,d_04E9_D055_e
		call	sub_a_45FC
		mov	bp,d_04E9_D03E_e
		jmp	short $+2		; delay for I/O

;==== External Entry into Subroutine ======================================

sub_a_21F5:
		mov	al,ds:[bp+3]
		call	sub_a_2235
		mov	al,ds:[bp+2]
		call	sub_a_2235
		mov	al,ds:[bp+1]
		call	sub_a_2235
		mov	al,ds:[bp]
		call	sub_a_2235
		mov	al,20h			; ' '
		call	sub_a_460B
		mov	al,20h			; ' '
		call	sub_a_460B
		mov	al,20h			; ' '
		call	sub_a_460B
		mov	al,ds:[bp+4]
		call	sub_a_460B
		mov	al,ds:[bp+5]
		call	sub_a_460B
		mov	al,ds:[bp+6]
		jmp	loc_a_460B
sub_a_21C0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2235	proc	near
		push	ax
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		call	sub_a_2242
		pop	ax

;==== External Entry into Subroutine ======================================

sub_a_2242:
		and	al,0Fh
		add	al,30h			; '0'
		jmp	loc_a_460B
sub_a_2235	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2249	proc	near
		mov	bp,0D06Ch
		cmp	byte ptr ds:d_04E9_01B4_e,1
		je	loc_a_2256		; Jump if equal
		mov	bp,d_04E9_D07A_e
loc_a_2256:
		call	sub_a_45FC
		mov	bp,0D096h
		cmp	byte ptr ds:d_04E9_01CB_e,0
		je	loc_a_2266		; Jump if equal
		mov	bp,d_04E9_D088_e
loc_a_2266:
		call	sub_a_45FC
		mov	bp,0D0A4h
		cmp	byte ptr ds:d_04E9_D5ED_e,0
		je	loc_a_2276		; Jump if equal
		mov	bp,d_04E9_D0B3_e
loc_a_2276:
		call	sub_a_45FC
		retn
sub_a_2249	endp

loc_a_227A:
		call	sub_a_2313
		jc	loc_a_2280		; Jump if carry Set
		retn
loc_a_2280:
		mov	byte ptr ds:[bp+4],41h	; 'A'
		mov	byte ptr ds:[bp+5],20h	; ' '
		mov	byte ptr ds:[bp+6],20h	; ' '
		mov	data_a_D0C3,bp
		mov	byte ptr data_a_D0C2,4
		call	sub_a_1E90
loc_a_229B:
		call	sub_a_21C0
		mov	bp,offset data_a_D0C5
		call	sub_a_45FC
		call	sub_a_4CF6
loc_a_22A7:
		call	sub_a_3733
		mov	al,byte ptr ds:[23Dh]
		or	al,al			; Zero ?
		jnz	loc_a_22A7		; Jump if not zero
loc_a_22B1:
		mov	cx,6

locloop_a_22B4:
		call	sub_a_4CF6
		loop	locloop_a_22B4		; Loop if cx > 0

		call	sub_a_3733
		mov	al,byte ptr ds:[23Eh]
		or	al,byte ptr ds:[23Dh]
		jz	loc_a_22B1		; Jump if zero
		mov	al,byte ptr ds:[23Eh]
		or	al,al			; Zero ?
		jz	loc_a_22E8		; Jump if zero
		mov	bp,data_a_D0C3
		add	al,ds:[bp+4]
		cmp	al,40h			; '@'
		jne	loc_a_22DC		; Jump if not equal
		mov	al,5Ah			; 'Z'
		jmp	short loc_a_22E2
loc_a_22DC:
		cmp	al,5Bh			; '['
		jne	loc_a_22E2		; Jump if not equal
		mov	al,41h			; 'A'
loc_a_22E2:
		mov	ds:[bp+4],al
		jmp	short loc_a_229B
loc_a_22E8:
		mov	bp,data_a_D0C3
		inc	bp
		mov	data_a_D0C3,bp
		mov	al,data_a_D0C2
		inc	al
		mov	data_a_D0C2,al
		cmp	al,7
		je	loc_a_2307		; Jump if equal
		mov	al,ds:[bp+3]
		mov	ds:[bp+4],al
		jmp	short loc_a_229B
loc_a_2307:
		mov	cx,19h

locloop_a_230A:
		call	sub_a_4CF6
		loop	locloop_a_230A		; Loop if cx > 0

		call	sub_a_4D13
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2313	proc	near
		mov	al,byte ptr ds:[1B5h]
		mov	bp,1B8h
		or	al,al			; Zero ?
		jz	loc_a_2320		; Jump if zero
		mov	bp,1BCh
loc_a_2320:
		mov	si,offset data_a_D029
		mov	cx,4

locloop_a_2326:
		mov	al,[si]
		sub	al,ds:[bp]
		mov	al,[si+1]
		sbb	al,ds:[bp+1]
		mov	al,[si+2]
		sbb	al,ds:[bp+2]
		mov	al,[si+3]
		sbb	al,ds:[bp+3]
		jc	loc_a_234A		; Jump if carry Set
		add	si,7
		loop	locloop_a_2326		; Loop if cx > 0

		clc				; Clear carry flag
		retn
loc_a_234A:
		mov	dx,si
		mov	si,offset data_a_D03E
loc_a_234F:
		mov	bx,si
		mov	al,bl
		cmp	al,dl
		jne	loc_a_235D		; Jump if not equal
		mov	al,bh
		cmp	al,dh
		je	loc_a_236C		; Jump if equal
loc_a_235D:
		mov	cx,7

locloop_a_2360:
		dec	si
		mov	al,[si]
		inc	si
		mov	[si+6],al
		dec	si
		loop	locloop_a_2360		; Loop if cx > 0

		jmp	short loc_a_234F
loc_a_236C:
		mov	al,ds:[bp]
		mov	[si],al
		mov	al,ds:[bp+1]
		mov	[si+1],al
		mov	al,ds:[bp+2]
		mov	[si+2],al
		mov	al,ds:[bp+3]
		mov	[si+3],al
		mov	bp,si
		stc				; Set carry flag
		retn
sub_a_2313	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_238B	proc	near
		call	sub_a_1E90
		call	sub_a_2756
		mov	al,1
		call	sub_a_105A
		mov	bp,d_04E9_CE5D_e
		call	sub_a_48FD
		call	sub_a_2438
		mov	bp,d_04E9_CE8C_e
		call	sub_a_48FD
		mov	al,ds:d_04E9_01AE_e
		mov	cl,13h
		mul	cl			; ax = reg * al
		mov	bp,0CC98h
		cmp	byte ptr ds:d_04E9_D5ED_e,0
		je	loc_a_23B9		; Jump if equal
		mov	bp,d_04E9_CD30_e
loc_a_23B9:
		add	bp,ax
		call	sub_a_48FD
		mov	ax,0B800h
		mov	es,ax
		mov	di,d_B800_3B90_e
		mov	ax,0AAAAh
		mov	cx,18h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,d_B800_1B90_e
		mov	ax,0AAh
		mov	cx,18h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	byte ptr ds:d_04E9_CFA5_e,0
		mov	word ptr ds:d_04E9_CFA6_e,1B42h
		mov	cx,8

locloop_a_23E7:
		push	cx
		mov	al,ds:d_04E9_CFA5_e
		cmp	al,ds:d_04E9_01AE_e
		jb	loc_a_23F7		; Jump if below
		mov	bx,d_04E9_CF95_e
		xlat				; al=[al+[bx]] table
		jmp	short loc_a_23F9
loc_a_23F7:
		mov	al,1
loc_a_23F9:
		mov	cl,al
		xor	ch,ch			; Zero register
		mov	bx,d_04E9_CF9D_e
		mov	al,ds:d_04E9_CFA5_e
		xlat				; al=[al+[bx]] table
		mov	ah,al
		mov	di,ds:d_04E9_CFA6_e
		push	cx

locloop_a_240B:
		stosw				; Store ax to es:[di]
		sub	di,52h
		loop	locloop_a_240B		; Loop if cx > 0

		pop	cx
		add	di,d_B800_2050_e
		and	ax,0FC3Fh

locloop_a_2419:
		stosw				; Store ax to es:[di]
		add	di,4Eh
		loop	locloop_a_2419		; Loop if cx > 0

		mov	ax,ds:d_04E9_CFA6_e
		add	ax,6
		mov	ds:d_04E9_CFA6_e,ax
		inc	byte ptr ds:d_04E9_CFA5_e
		pop	cx
		loop	locloop_a_23E7		; Loop if cx > 0

loc_a_242F:
		call	sub_a_1083
		jnc	loc_a_242F		; Jump if carry=0
		mov	al,19h
		jmp	short loc_a_2448

;==== External Entry into Subroutine ======================================

sub_a_2438:
		mov	bp,0CE76h
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_2445		; Jump if equal
		mov	bp,0CE81h
loc_a_2445:
		jmp	loc_a_48FD

;==== External Entry into Subroutine ======================================

sub_a_2448:
loc_a_2448:
		mov	ds:d_04E9_D0EB_e,al
		call	sub_a_2461
loc_a_244E:
		call	sub_a_4CF6
		dec	byte ptr ds:d_04E9_D0EB_e
		jz	loc_ret_a_246B		; Jump if zero
		call	sub_a_3733
		cmp	byte ptr ds:d_04E9_023D_e,0
		je	loc_a_244E		; Jump if equal

;==== External Entry into Subroutine ======================================

sub_a_2461:
loc_a_2461:
		call	sub_a_3733
		cmp	byte ptr ds:d_04E9_023D_e,0
		jne	loc_a_2461		; Jump if not equal

loc_ret_a_246B:
		retn
sub_a_238B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_246C	proc	near
		mov	bx,1C0h
		cmp	byte ptr ds:d_04E9_01B5_e,0
		je	loc_a_2479		; Jump if equal
		add	bx,2
loc_a_2479:
		mov	byte ptr [bx],0
		mov	byte ptr [bx+1],1
		mov	byte ptr [bx+4],0
		mov	byte ptr [bx+5],0
		retn
sub_a_246C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2489	proc	near
		mov	ch,al
		mov	bx,1C4h
		cmp	byte ptr ds:[1B5h],0
		je	loc_a_2498		; Jump if equal
		add	bx,2
loc_a_2498:
		mov	al,[bx]
		add	al,ch
		daa				; Decimal adjust
		mov	[bx],al
		inc	bx
		mov	al,[bx]
		adc	al,0
		mov	[bx],al
		cmp	al,6
		jae	loc_a_24AB		; Jump if above or =
		retn
loc_a_24AB:
		mov	byte ptr [bx],5
		dec	bx
		mov	byte ptr [bx],0
		retn
sub_a_2489	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_24B3	proc	near
		mov	ch,al
		mov	bx,1C0h
		cmp	byte ptr ds:[1B5h],0
		je	loc_a_24C2		; Jump if equal
		add	bx,2
loc_a_24C2:
		mov	al,[bx]
		sub	al,ch
		das				; Decimal adjust
		mov	[bx],al
		inc	bx
		mov	al,[bx]
		sbb	al,0
		das				; Decimal adjust
		mov	[bx],al
		jc	loc_a_24D4		; Jump if carry Set
		retn
loc_a_24D4:
		mov	byte ptr [bx],0
		dec	bx
		mov	byte ptr [bx],0
		retn
sub_a_24B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_24DC	proc	near
		mov	ax,4E9h
		mov	ds,ax
		mov	es,ax
		mov	bp,d_04E9_D0EC_e
		call	sub_a_45FC
		mov	cx,0Ah
		mov	byte ptr ds:d_04E9_D18F_e,30h	; '0'
		mov	di,0D0EFh

locloop_a_24F4:
		push	di
		mov	al,ds:d_04E9_D18F_e
		inc	byte ptr ds:d_04E9_D18F_e
		call	sub_a_250D
		mov	si,d_04E9_D5F6_e
		pop	di
		push	cx
		mov	cx,10h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	cx
		loop	locloop_a_24F4		; Loop if cx > 0

		retn
sub_a_24DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_250D	proc	near
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,0D75Ah
		mov	si,ax
		mov	di,d_04E9_D5F6_e
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		retn
sub_a_250D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2756	proc	near
loc_a_2756:
		call	sub_a_2813
		xor	byte ptr ds:d_04E9_01B5_e,1
		call	sub_a_2813
		xor	byte ptr ds:d_04E9_01B5_e,1
		mov	word ptr ds:d_04E9_D190_e,22C0h
		mov	dl,ds:d_04E9_01B7_e
		call	sub_a_277D
		mov	word ptr ds:d_04E9_D190_e,2280h
		mov	dl,ds:d_04E9_01B6_e

;==== External Entry into Subroutine ======================================

sub_a_277D:
		mov	cx,8

locloop_a_2780:
		mov	ax,0A82Ah
		dec	dl
		test	dl,80h
		jz	loc_a_278C		; Jump if zero
		xor	ax,ax			; Zero register
loc_a_278C:
		mov	di,ds:d_04E9_D190_e
		inc	word ptr ds:d_04E9_D190_e
		inc	word ptr ds:d_04E9_D190_e
		mov	es:[di],ax
		mov	es:d_0040_E050_e[di],ax
		mov	es:[di+50h],ax
		mov	es:d_0040_E0A0_e[di],ax
		mov	es:d_0040_00A0_e[di],ax
		mov	es:d_0040_E0F0_e[di],ax
		loop	locloop_a_2780		; Loop if cx > 0

		retn
sub_a_2756	endp

loc_a_27B6:
		mov	data_a_D190,180h
		mov	al,byte ptr ds:[1BFh]
		call	sub_a_2877
		mov	al,byte ptr ds:[1BFh]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		call	sub_a_2877
		mov	al,byte ptr ds:[1BEh]
		call	sub_a_2877
		mov	al,byte ptr ds:[1BEh]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		call	sub_a_2877
		mov	al,byte ptr ds:[1BDh]
		call	sub_a_2877
		mov	al,byte ptr ds:[1BDh]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		call	sub_a_2877
		mov	al,byte ptr ds:[1BCh]
		call	sub_a_2877
		mov	al,byte ptr ds:[1BCh]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		jmp	short loc_a_2877

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2813	proc	near
		cmp	byte ptr ds:[1B5h],1
		jne	loc_a_281C		; Jump if not equal
		jmp	short loc_a_27B6
loc_a_281C:
		mov	data_a_D190,140h
		mov	al,byte ptr ds:[1BBh]
		call	sub_a_2877
		mov	al,byte ptr ds:[1BBh]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		call	sub_a_2877
		mov	al,byte ptr ds:[1BAh]
		call	sub_a_2877
		mov	al,byte ptr ds:[1BAh]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		call	sub_a_2877
		mov	al,byte ptr ds:[1B9h]
		call	sub_a_2877
		mov	al,byte ptr ds:[1B9h]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		call	sub_a_2877
		mov	al,byte ptr ds:[1B8h]
		call	sub_a_2877
		mov	al,byte ptr ds:[1B8h]
		and	al,0Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill

;==== External Entry into Subroutine ======================================

sub_a_2877:
loc_a_2877:
		mov	cx,0B800h
		mov	es,cx
		and	al,0F0h
		xor	ah,ah			; Zero register
		add	ax,0D0EFh
		mov	si,ax
		mov	di,ds:d_04E9_D190_e
		inc	word ptr ds:d_04E9_D190_e
		inc	word ptr ds:d_04E9_D190_e
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		retn
sub_a_2813	endp

loc_a_28B6:
		pop	ax
		jmp	loc_a_4C75

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_28BA	proc	near
		cmp	byte ptr ds:d_04E9_0258_e,0
		je	loc_a_28C2		; Jump if equal
		retn
loc_a_28C2:
		cmp	byte ptr ds:d_04E9_CDCD_e,1
		je	loc_a_28B6		; Jump if equal
		jmp	short loc_a_28F6
			                        ;* No entry point to code
		cmp	byte ptr ds:d_04E9_CDFD_e,1
		jne	loc_a_28F6		; Jump if not equal
		cmp	byte ptr ds:d_04E9_CDDE_e,1
		jne	loc_a_28F6		; Jump if not equal
		cmp	byte ptr ds:d_04E9_CDF6_e,1
		mov	al,1
		mov	ah,ds:d_04E9_025A_e
		jz	loc_a_28EF		; Jump if zero
		xor	ax,ax			; Zero register
		cmp	byte ptr ds:d_04E9_CDE9_e,1
		jne	loc_a_28F6		; Jump if not equal
loc_a_28EF:
		mov	ds:d_04E9_01A5_e,al
		mov	ds:d_04E9_025A_e,ah
loc_a_28F6:
		cmp	byte ptr ds:d_04E9_01A6_e,0
		jne	loc_a_2917		; Jump if not equal
		cmp	byte ptr ds:d_04E9_01CA_e,0
		jne	loc_a_2932		; Jump if not equal
		cmp	byte ptr ds:d_04E9_CDE5_e,1
		jne	loc_a_2932		; Jump if not equal
		mov	byte ptr ds:d_04E9_01A6_e,0FFh
		mov	byte ptr ds:d_04E9_01CA_e,0FFh
		jmp	short loc_a_2932
loc_a_2917:
		call	sub_a_1E6D
		cmp	byte ptr ds:d_04E9_CE4C_e,10h
		jne	loc_a_2932		; Jump if not equal
		mov	byte ptr ds:d_04E9_01A6_e,0
		mov	al,ds:d_04E9_01A5_e
		test	al,80h
		jnz	loc_a_292F		; Jump if not zero
		mov	al,1
loc_a_292F:
		mov	ds:d_04E9_01CA_e,al
loc_a_2932:
		cmp	byte ptr ds:d_04E9_01A5_e,0
		jne	loc_a_293A		; Jump if not equal
		retn
loc_a_293A:
		cmp	byte ptr ds:d_04E9_CDF6_e,1
		je	loc_a_2942		; Jump if equal
		retn
loc_a_2942:
		xor	bl,bl			; Zero register
		cmp	byte ptr ds:d_04E9_CDCE_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDCF_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDD0_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDD1_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDD2_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDD3_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDD4_e,1
		je	loc_a_298B		; Jump if equal
		inc	bl
		cmp	byte ptr ds:d_04E9_CDD5_e,1
		je	loc_a_298B		; Jump if equal
		retn
loc_a_298B:
		mov	ds:d_04E9_025A_e,bl
		pop	ax
		mov	byte ptr ds:d_04E9_01A6_e,0
		jmp	loc_a_0457
sub_a_28BA	endp

loc_a_2998:
		mov	bp,177h
		mov	cx,4

locloop_a_299E:
		cmp	byte ptr ds:[bp],0FFh
		je	loc_a_29B7		; Jump if equal
		cmp	bl,ds:[bp+4]
		jne	loc_a_29B7		; Jump if not equal
		cmp	bh,ds:[bp+8]
		jne	loc_a_29B7		; Jump if not equal
		mov	byte ptr ds:[bp],0FFh
		retn
loc_a_29B7:
		inc	bp
		loop	locloop_a_299E		; Loop if cx > 0

		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_29BB	proc	near
		mov	bp,177h
		mov	cx,4

locloop_a_29C1:
		cmp	byte ptr ds:[bp],0FFh
		jne	loc_a_29E5		; Jump if not equal
		mov	al,[bx]
		and	al,0Ch
		cmp	al,4
		je	loc_a_29E8		; Jump if equal
		mov	al,[bx]
		mov	ds:[bp+0Ch],al
		mov	ds:[bp+4],bl
		mov	ds:[bp+8],bh
		mov	byte ptr ds:[bp],7Dh	; '}'
		stc				; Set carry flag
		retn
loc_a_29E5:
		inc	bp
		loop	locloop_a_29C1		; Loop if cx > 0

loc_a_29E8:
		clc				; Clear carry flag
		retn
sub_a_29BB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_29EA	proc	near
		mov	bp,177h
		mov	cx,4

locloop_a_29F0:
		mov	al,ds:[bp]
		or	al,al			; Zero ?
		jz	loc_a_2A02		; Jump if zero
		cmp	al,0FFh
		je	loc_a_2A3D		; Jump if equal
		dec	byte ptr ds:[bp]
		jmp	short loc_a_2A3D
loc_a_2A02:
		mov	bl,ds:[bp+4]
		mov	bh,ds:[bp+8]
		mov	al,ds:[bp+0Ch]
		and	al,0Ch
		mov	[bx],al
		dec	bx
		mov	dl,ds:[bp+4]
		mov	dh,ds:[bp+8]
		dec	dx
		mov	ds:[bp+4],dl
		mov	ds:[bp+8],dh
		mov	al,[bx]
		mov	ds:[bp+0Ch],al
		and	al,0Ch
		cmp	al,4
		je	loc_a_2A35		; Jump if equal
		mov	byte ptr [bx],8Dh
		jmp	short loc_a_2A3D
loc_a_2A35:
		mov	byte ptr [bx],85h
		mov	byte ptr ds:[bp],0FFh
loc_a_2A3D:
		inc	bp
		loop	locloop_a_29F0		; Loop if cx > 0

		retn
sub_a_29EA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A41	proc	near
		call	sub_a_2A92
		jc	loc_a_2A47		; Jump if carry Set
		retn
loc_a_2A47:
		cmp	byte ptr ds:[23Eh],0
		je	loc_a_2A4F		; Jump if equal
		retn
loc_a_2A4F:
		jmp	loc_a_3626
sub_a_2A41	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A52	proc	near
		call	sub_a_2B59
		dec	bx
		cmp	byte ptr [bx],85h
		je	loc_a_2A67		; Jump if equal
		cmp	byte ptr [bx],89h
		je	loc_a_2A6B		; Jump if equal
		cmp	byte ptr [bx],8Dh
		je	loc_a_2A6D		; Jump if equal
		clc				; Clear carry flag
		retn
loc_a_2A67:
		mov	al,1
		stc				; Set carry flag
		retn
loc_a_2A6B:
		mov	al,0FFh
loc_a_2A6D:
		stc				; Set carry flag
		retn
sub_a_2A52	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A6F	proc	near
		call	sub_a_2B59
		dec	bx
		mov	al,[bx]
		test	al,80h
		jz	loc_ret_a_2A91		; Jump if zero
		mov	ch,al
		and	al,3
		cmp	al,1
		jne	loc_ret_a_2A91		; Jump if not equal
		mov	al,ch
		and	al,30h			; '0'
		cmp	al,10h
		jne	loc_ret_a_2A91		; Jump if not equal
		mov	byte ptr [bx],0
		mov	al,9
		call	sub_a_1153

loc_ret_a_2A91:
		retn
sub_a_2A6F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A92	proc	near
		call	sub_a_2B59
		dec	bx
		mov	al,[bx]
		test	al,80h
		jz	loc_a_2AB8		; Jump if zero
		mov	ch,al
		and	al,3
		cmp	al,1
		jne	loc_a_2AB8		; Jump if not equal
		mov	al,ch
		and	al,30h			; '0'
		cmp	al,20h			; ' '
		je	loc_a_2AB4		; Jump if equal
		cmp	al,30h			; '0'
		jne	loc_a_2AB8		; Jump if not equal
		mov	al,1
		stc				; Set carry flag
		retn
loc_a_2AB4:
		mov	al,0FFh
		stc				; Set carry flag
		retn
loc_a_2AB8:
		clc				; Clear carry flag
		retn
sub_a_2A92	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2ABA	proc	near
		mov	bx,word ptr ds:[188h]
		call	sub_a_2B71
		dec	al
		mov	bl,al
		mov	al,byte ptr ds:[187h]
		add	al,7Ah			; 'z'
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		and	al,0Fh
		push	ax
		mov	bh,al
		mov	ch,bl
		add	bx,0A7Eh
		xor	cl,cl			; Zero register
		mov	al,[bx]
		test	al,80h
		jz	loc_a_2AEB		; Jump if zero
		and	al,3
		cmp	al,3
		je	loc_a_2AEB		; Jump if equal
		mov	cl,2
loc_a_2AEB:
		pop	ax
		inc	al
		and	al,0Fh
		mov	bh,al
		mov	bl,ch
		add	bx,0A7Eh
		mov	al,[bx]
		test	al,80h
		jz	loc_a_2B06		; Jump if zero
		and	al,3
		cmp	al,3
		je	loc_a_2B06		; Jump if equal
		inc	cl
loc_a_2B06:
		mov	al,byte ptr ds:[187h]
		and	al,7
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		or	al,cl
		xor	ah,ah			; Zero register
		mov	bx,ax
		add	bx,offset data_a_D192
		mov	al,byte ptr ds:[18Ch]
		test	al,80h
		mov	al,[bx]
		jz	loc_a_2B2A		; Jump if zero
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
loc_a_2B2A:
		and	al,0Fh
		retn
sub_a_2ABA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B2D	proc	near
		call	sub_a_2B59
		mov	al,[bx]
		test	al,80h
		jz	loc_a_2B57		; Jump if zero
		mov	ah,al
		and	al,3
		cmp	al,3
		jne	loc_a_2B57		; Jump if not equal
		push	ax
		dec	bx
		mov	al,[bx]
		inc	bx
		test	al,80h
		jz	loc_a_2B56		; Jump if zero
		mov	ah,al
		and	al,3
		cmp	al,3
		je	loc_a_2B56		; Jump if equal
		pop	ax
		mov	al,ah
		and	al,40h			; '@'
		stc				; Set carry flag
		retn
loc_a_2B56:
		pop	ax
loc_a_2B57:
		clc				; Clear carry flag
		retn
sub_a_2B2D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B59	proc	near
		mov	bx,word ptr ds:[188h]
		call	sub_a_2B71
		mov	bl,al
		mov	bh,byte ptr ds:[187h]
		shr	bh,1			; Shift w/zeros fill
		shr	bh,1			; Shift w/zeros fill
		shr	bh,1			; Shift w/zeros fill
		add	bx,0A7Eh
		retn
sub_a_2B59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B71	proc	near
		push	bx
		mov	al,bl
		shr	bh,1			; Shift w/zeros fill
		rcr	al,1			; Rotate thru carry
		shr	bh,1			; Shift w/zeros fill
		rcr	al,1			; Rotate thru carry
		pop	bx
		retn
sub_a_2B71	endp

loc_a_2B7E:
		mov	byte ptr ds:[18Dh],0FFh
		mov	byte ptr ds:[18Eh],9

;===== Indexed Entry Point ================================================

loc_a_2B88:
		test	byte ptr ds:d_04E9_018D_e,80h
		jz	loc_a_2BE9		; Jump if zero
		mov	al,ds:d_04E9_01AF_e
		cmp	al,6
		je	loc_a_2BD4		; Jump if equal
		mov	bx,ds:d_04E9_0188_e
		sub	bx,4
		mov	ds:d_04E9_0188_e,bx
		mov	al,ds:d_04E9_01AF_e
		sub	al,5
		mov	bl,al
		xor	bh,bh			; Zero register
		add	bx,d_04E9_0A7E_e
		mov	cl,6
loc_a_2BB0:
		push	bx
		mov	ch,10h
loc_a_2BB3:
		mov	al,[bx]
		dec	bx
		mov	[bx],al
		inc	bx
		add	bx,100h
		dec	ch
		jnz	loc_a_2BB3		; Jump if not zero
		pop	bx
		inc	bx
		dec	cl
		jnz	loc_a_2BB0		; Jump if not zero
		dec	byte ptr ds:d_04E9_01AF_e
		call	sub_a_114D
		mov	al,0Ch
		call	sub_a_1153
		retn
loc_a_2BD4:
		mov	bx,word ptr ds:[251h]
		cmp	bh,3
		je	loc_a_2BDE		; Jump if equal
		retn
loc_a_2BDE:
		cmp	bl,0E0h
		je	loc_a_2BE4		; Jump if equal
		retn
loc_a_2BE4:
		inc	byte ptr ds:[18Dh]
		retn
loc_a_2BE9:
		mov	ax,4E9h
		mov	es,ax
		mov	si,offset data_a_D1B2
		mov	di,d_04E9_D1C1_e
		mov	cx,5
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	byte ptr data_a_D1B7,0
		mov	byte ptr data_a_D1D5,1
		mov	al,1
		call	sub_a_2C39
		mov	byte ptr ds:d_04E9_01A7_e,4
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C0E	proc	near
		mov	ax,4E9h
		mov	es,ax
		mov	si,d_04E9_D1C6_e
		mov	di,d_04E9_D1C1_e
		mov	cx,5
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	byte ptr ds:d_04E9_D1B7_e,0FFh
		mov	al,1
		mov	ds:d_04E9_D1D5_e,al
		call	sub_a_2D4C
		mov	cx,32h

locloop_a_2C2E:
		call	sub_a_4CF6
		loop	locloop_a_2C2E		; Loop if cx > 0

		xor	al,al			; Zero register
		call	sub_a_2C39
		retn
sub_a_2C0E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C39	proc	near
		mov	data_a_D1D7,al
		call	sub_a_114D
loc_a_2C3F:
		call	sub_a_2D4C
		mov	al,ds:d_04E9_D1D5_e
		cmp	al,1
		jne	loc_a_2C71		; Jump if not equal
		mov	al,0Bh
		call	sub_a_1153
		mov	bx,d_04E9_D1C2_e
		mov	cx,4

locloop_a_2C54:
		mov	al,[bx]
		sub	al,2
		mov	[bx],al
		inc	bx
		loop	locloop_a_2C54		; Loop if cx > 0

		cmp	al,68h			; 'h'
		jne	loc_a_2C3F		; Jump if not equal
		inc	byte ptr ds:d_04E9_D1D5_e
		mov	byte ptr ds:d_04E9_D1D6_e,0
		mov	al,3
		call	sub_a_1153
		jmp	short loc_a_2C3F
loc_a_2C71:
		cmp	al,2
		jne	loc_a_2CA5		; Jump if not equal
		mov	al,ds:d_04E9_D1D6_e
		shr	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		mov	cx,ax
		mov	bx,d_04E9_D1CB_e
		add	bx,cx
		mov	al,[bx]
		mov	ds:d_04E9_D1BD_e,al
		mov	bx,d_04E9_D1D0_e
		add	bx,cx
		mov	al,[bx]
		mov	ds:d_04E9_D1B8_e,al
		inc	byte ptr ds:d_04E9_D1D6_e
		cmp	byte ptr ds:d_04E9_D1D6_e,9
		je	loc_a_2C9F		; Jump if equal
		jmp	short loc_a_2C3F
loc_a_2C9F:
		inc	byte ptr ds:d_04E9_D1D5_e
		jmp	short loc_a_2C3F
loc_a_2CA5:
		cmp	al,3
		jne	loc_a_2CFA		; Jump if not equal
		cmp	byte ptr ds:d_04E9_D1D7_e,0
		jne	loc_a_2CD5		; Jump if not equal
		mov	byte ptr ds:d_04E9_D1B7_e,0
		mov	al,ds:d_04E9_D1C1_e
		sub	al,2
		mov	ds:d_04E9_D1C1_e,al
		cmp	al,54h			; 'T'
		je	loc_a_2CC4		; Jump if equal
		jmp	loc_a_2C3F
loc_a_2CC4:
		inc	byte ptr ds:d_04E9_D1D5_e
		mov	byte ptr ds:d_04E9_D1D6_e,8
		mov	al,3
		call	sub_a_1153
		jmp	loc_a_2C3F
loc_a_2CD5:
		mov	al,ds:d_04E9_D1C1_e
		add	al,2
		mov	ds:d_04E9_D1C1_e,al
		cmp	al,68h			; 'h'
		je	loc_a_2CE4		; Jump if equal
		jmp	loc_a_2C3F
loc_a_2CE4:
		inc	byte ptr ds:d_04E9_D1D5_e
		mov	byte ptr ds:d_04E9_D1B7_e,0FFh
		mov	byte ptr ds:d_04E9_D1D6_e,8
		mov	al,3
		call	sub_a_1153
		jmp	loc_a_2C3F
loc_a_2CFA:
		cmp	al,4
		jne	loc_a_2D30		; Jump if not equal
		mov	al,ds:d_04E9_D1D6_e
		shr	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		mov	cx,ax
		mov	bx,d_04E9_D1CB_e
		add	bx,cx
		mov	al,[bx]
		mov	ds:d_04E9_D1BD_e,al
		mov	bx,d_04E9_D1D0_e
		add	bx,cx
		mov	al,[bx]
		mov	ds:d_04E9_D1B8_e,al
		dec	byte ptr ds:d_04E9_D1D6_e
		test	byte ptr ds:d_04E9_D1D6_e,80h
		jnz	loc_a_2D29		; Jump if not zero
		jmp	loc_a_2C3F
loc_a_2D29:
		inc	byte ptr ds:d_04E9_D1D5_e
		jmp	loc_a_2C3F
loc_a_2D30:
		mov	al,0Bh
		call	sub_a_1153
		mov	bx,d_04E9_D1C2_e
		mov	cx,4

locloop_a_2D3B:
		mov	al,[bx]
		add	al,2
		mov	[bx],al
		inc	bx
		loop	locloop_a_2D3B		; Loop if cx > 0

		cmp	al,90h
		je	loc_ret_a_2D4B		; Jump if equal
		jmp	loc_a_2C3F

loc_ret_a_2D4B:
		retn
sub_a_2C39	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2D4C	proc	near
		call	sub_a_0041
		call	sub_a_1789
		call	sub_a_1421
		call	sub_a_4CF6
		call	sub_a_1197
		call	sub_a_161F
		call	sub_a_16DD
		call	sub_a_2D71
		call	sub_a_14D3
		call	sub_a_1C59
		call	sub_a_1BA6
		call	sub_a_0048
		retn
sub_a_2D4C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2D71	proc	near
		mov	ax,129Dh
		mov	es,ax
		mov	bp,d_04E9_D1B7_e
		mov	cx,5
loc_a_2D7C:
		push	bp
		push	cx
		cmp	byte ptr ds:[bp],0FFh
		jne	loc_a_2D88		; Jump if not equal
		jmp	loc_a_2E77
loc_a_2D88:
		mov	al,ds:[bp+5]
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	ah,ds:[bp+0Ah]
		sub	ah,8
		call	sub_a_4571
		inc	ax
		cmp	byte ptr ds:[bp],0
		jne	loc_a_2DA5		; Jump if not equal
		inc	ax
loc_a_2DA5:
		push	ax
		mov	al,ds:[bp]
		call	sub_a_3766
		mov	si,bx
		pop	di
		mov	al,ds:[bp+0Ah]
		cmp	al,7Ch			; '|'
		jb	loc_a_2DBB		; Jump if below
		jmp	loc_a_2E77
loc_a_2DBB:
		mov	ah,cl
		mov	cl,14h
		cmp	al,6Ah			; 'j'
		jb	loc_a_2DCB		; Jump if below
		mov	cl,al
		mov	al,7Ch			; '|'
		sub	al,cl
		mov	cl,al
loc_a_2DCB:
		xor	ch,ch			; Zero register
		mov	bx,4
		cmp	ah,4
		jne	loc_a_2DD7		; Jump if not equal
		jmp	short locloop_a_2E3A
loc_a_2DD7:
		cmp	ah,3
		jne	locloop_a_2DDE		; Jump if not equal
		jmp	short locloop_a_2E06

locloop_a_2DDE:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,bx
		mov	ax,2000h
		test	di,ax
		jz	loc_a_2E00		; Jump if zero
		mov	ax,0E050h
loc_a_2E00:
		add	di,ax
		loop	locloop_a_2DDE		; Loop if cx > 0

		jmp	short loc_a_2E77

locloop_a_2E06:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,6
		mov	ax,2000h
		test	di,ax
		jz	loc_a_2E34		; Jump if zero
		mov	ax,0E050h
loc_a_2E34:
		add	di,ax
		loop	locloop_a_2E06		; Loop if cx > 0

		jmp	short loc_a_2E77

locloop_a_2E3A:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,8
		mov	ax,2000h
		test	di,ax
		jz	loc_a_2E73		; Jump if zero
		mov	ax,0E050h
loc_a_2E73:
		add	di,ax
		loop	locloop_a_2E3A		; Loop if cx > 0

loc_a_2E77:
		pop	cx
		pop	bp
		inc	bp
		dec	cx
		jz	loc_ret_a_2E80		; Jump if zero
		jmp	loc_a_2D7C

loc_ret_a_2E80:
		retn
sub_a_2D71	endp

loc_a_2E81:
		mov	byte ptr ds:d_04E9_018E_e,4
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	byte ptr ds:d_04E9_D209_e,0
		mov	al,3
		call	sub_a_1153
		retn

;===== Indexed Entry Point ================================================

loc_a_2E96:
		mov	al,ds:d_04E9_018D_e
		cmp	al,7
		jb	loc_a_2EAC		; Jump if below
		cmp	al,23h			; '#'
		jae	loc_a_2EAC		; Jump if above or =
		sub	al,7
		and	al,3
		jnz	loc_a_2EAC		; Jump if not zero
		mov	al,2
		call	sub_a_1153
loc_a_2EAC:
		mov	al,ds:d_04E9_018D_e
		cmp	al,4
		jae	loc_a_2EE0		; Jump if above or =
		xor	cx,cx			; Zero register
		mov	bx,0D1EAh
		test	byte ptr ds:d_04E9_018C_e,80h
		jz	loc_a_2EC2		; Jump if zero
		mov	bx,d_04E9_D1E6_e
loc_a_2EC2:
		add	bx,cx
		mov	al,[bx]
		mov	ds:d_04E9_018F_e,al
		mov	al,ds:d_04E9_0187_e
		and	al,7
		cmp	al,4
		je	loc_a_2EDB		; Jump if equal
		mov	al,1
		jc	loc_a_2ED8		; Jump if carry Set
		mov	al,0FFh
loc_a_2ED8:
		call	sub_a_3626
loc_a_2EDB:
		inc	byte ptr ds:d_04E9_018D_e
		retn
loc_a_2EE0:
		cmp	al,7
		jae	loc_a_2EE9		; Jump if above or =
		mov	al,7
		mov	byte ptr ds:[18Dh],al
loc_a_2EE9:
		cmp	al,0Dh
		jae	loc_a_2EFE		; Jump if above or =
		xor	ah,ah			; Zero register
		add	ax,0D1EFh
		mov	bx,ax
		mov	al,[bx]
		mov	byte ptr ds:[18Fh],al
		inc	byte ptr ds:[18Dh]
		retn
loc_a_2EFE:
		cmp	al,1Dh
		jae	loc_a_2F39		; Jump if above or =
		mov	byte ptr ds:[190h],0
		cmp	byte ptr ds:[1A7h],0
		je	loc_a_2F14		; Jump if equal
		mov	byte ptr ds:[1A7h],2
		retn
loc_a_2F14:
		test	byte ptr ds:[18Ch],80h
		mov	al,2
		jnz	loc_a_2F1F		; Jump if not zero
		mov	al,0FEh
loc_a_2F1F:
		add	al,byte ptr ds:[187h]
		and	al,7Fh
		mov	byte ptr ds:[187h],al
		inc	data_a_D20A
		test	byte ptr data_a_D20A,1
		jz	loc_a_2F34		; Jump if zero
		retn
loc_a_2F34:
		inc	byte ptr ds:[18Dh]
		retn
loc_a_2F39:
		cmp	al,23h			; '#'
		jae	loc_a_2F53		; Jump if above or =
		xor	ah,ah			; Zero register
		add	ax,0D1DFh
		mov	bx,ax
		mov	al,[bx]
		mov	byte ptr ds:[18Fh],al
		mov	byte ptr ds:[190h],1
		inc	byte ptr ds:[18Dh]
		retn
loc_a_2F53:
		mov	ch,al
		cmp	byte ptr ds:[1A7h],3
		jne	loc_a_2F5F		; Jump if not equal
		jmp	loc_a_2B7E
loc_a_2F5F:
		mov	al,ch
		cmp	al,24h			; '$'
		jae	loc_a_2F88		; Jump if above or =
		mov	al,0FCh
		call	sub_a_3648
		jc	loc_a_2F6D		; Jump if carry Set
		retn
loc_a_2F6D:
		mov	ch,0
		cmp	byte ptr ds:[23Eh],0
		je	loc_a_2F83		; Jump if equal
		test	byte ptr ds:[23Eh],80h
		jnz	loc_a_2F7F		; Jump if not zero
		mov	ch,80h
loc_a_2F7F:
		mov	byte ptr ds:[18Ch],ch
loc_a_2F83:
		inc	byte ptr ds:[18Dh]
		retn
loc_a_2F88:
		cmp	al,28h			; '('
		jb	loc_a_2F8F		; Jump if below
		jmp	loc_a_3229
loc_a_2F8F:
		xor	ah,ah			; Zero register
		mov	bx,0D1CAh
		test	byte ptr ds:[18Ch],80h
		jnz	loc_a_2F9E		; Jump if not zero
		mov	bx,offset data_a_D1CE
loc_a_2F9E:
		add	bx,ax
		mov	al,[bx]
		mov	byte ptr ds:[18Fh],al
		inc	byte ptr ds:[18Dh]
		retn
loc_a_2FAA:
		mov	bp,d_04E9_01D4_e
		mov	al,ds:[bp+2Ah]
		cmp	al,0FFh
		je	loc_a_2FB8		; Jump if equal
		jmp	loc_a_3229
loc_a_2FB8:
		mov	byte ptr ds:d_04E9_018E_e,5
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	al,ds:d_04E9_018C_e
		or	al,0
		mov	ds:d_04E9_018F_e,al
		mov	al,8
		call	sub_a_1153
		retn

;===== Indexed Entry Point ================================================

loc_a_2FD0:
		call	sub_a_2A41
		mov	al,ds:d_04E9_018D_e
		cmp	al,3
		jne	loc_a_2FDD		; Jump if not equal
		jmp	loc_a_3229
loc_a_2FDD:
		mov	cl,al
		xor	ch,ch			; Zero register
		mov	bx,d_04E9_D202_e
		add	bx,cx
		mov	al,[bx]
		or	al,ds:d_04E9_018C_e
		mov	ds:d_04E9_018F_e,al
		mov	al,cl
		cmp	al,1
		jne	loc_a_2FF8		; Jump if not equal
		call	sub_a_2FFD
loc_a_2FF8:
		inc	byte ptr ds:d_04E9_018D_e
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2FFD	proc	near
		mov	bp,1D4h
		mov	bx,word ptr ds:[188h]
		mov	ds:[bp+6],bl
		mov	ds:[bp+0Ch],bh
		mov	al,byte ptr ds:[187h]
		dec	al
		test	byte ptr ds:[18Ch],80h
		jz	loc_a_301A		; Jump if zero
		add	al,2
loc_a_301A:
		and	al,7Fh
		mov	ds:[bp],al
		mov	byte ptr ds:[bp+2Ah],0
		mov	al,1
		test	byte ptr ds:[18Ch],80h
		jnz	loc_a_3030		; Jump if not zero
		mov	al,0FFh
loc_a_3030:
		mov	ds:[bp+36h],al
		retn
sub_a_2FFD	endp

loc_a_3035:
		mov	ds:d_04E9_D20B_e,al
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	byte ptr ds:d_04E9_018E_e,6
		call	sub_a_2A52
		jmp	loc_a_2998

;===== Indexed Entry Point ================================================

loc_a_3048:
		cmp	byte ptr ds:d_04E9_018D_e,0
		jne	loc_a_3083		; Jump if not equal
		mov	al,ds:d_04E9_0187_e
		and	al,7
		cmp	al,4
		je	loc_a_3068		; Jump if equal
		mov	al,1
		jc	loc_a_305E		; Jump if carry Set
		mov	al,0FFh
loc_a_305E:
		add	al,ds:d_04E9_0187_e
		and	al,7Fh
		mov	ds:d_04E9_0187_e,al
		retn
loc_a_3068:
		inc	byte ptr ds:[18Dh]
		mov	byte ptr ds:[1ADh],0FEh
		call	sub_a_2A52
		mov	al,[bx]
		and	al,0Ch
		test	byte ptr data_a_D20B,80h
		jnz	loc_a_3081		; Jump if not zero
		or	al,80h
loc_a_3081:
		mov	[bx],al
loc_a_3083:
		mov	al,data_a_D20B
		mov	ch,0
		test	al,80h
		jz	loc_a_308E		; Jump if zero
		dec	ch
loc_a_308E:
		mov	bx,word ptr ds:[188h]
		add	bl,al
		mov	al,ch
		adc	al,bh
		and	al,3
		mov	bh,al
		mov	word ptr ds:[188h],bx
		and	bl,3
		jz	loc_a_30A6		; Jump if zero
		retn
loc_a_30A6:
		mov	al,0Ah
		call	sub_a_1153
		call	sub_a_2A52
		test	byte ptr ds:d_04E9_D20B_e,80h
		jz	loc_a_30CB		; Jump if zero
		mov	al,[bx]
		and	al,0Ch
		cmp	al,4
		je	loc_a_30E7		; Jump if equal
		cmp	al,0Ch
		jne	loc_a_30C8		; Jump if not equal
		test	byte ptr ds:d_04E9_023F_e,80h
		jz	loc_a_30E7		; Jump if zero
loc_a_30C8:
		mov	[bx],al
		retn
loc_a_30CB:
		mov	al,[bx]
		and	al,0Ch
		cmp	al,8
		je	loc_a_30E7		; Jump if equal
		cmp	al,0Ch
		jne	loc_a_30E2		; Jump if not equal
		mov	ch,al
		mov	al,byte ptr ds:[23Fh]
		dec	al
		mov	al,ch
		jnz	loc_a_30E7		; Jump if not zero
loc_a_30E2:
		or	al,80h
		mov	[bx],al
		retn
loc_a_30E7:
		or	al,81h
		mov	[bx],al
		call	sub_a_29BB
		mov	byte ptr ds:[1ADh],0FFh
		jmp	loc_a_3229
loc_a_30F6:
		mov	byte ptr ds:[18Eh],7
		mov	byte ptr ds:[18Dh],0
		mov	byte ptr ds:[1A7h],0
		mov	al,2
		call	sub_a_24B3
		mov	al,5
		call	sub_a_1153
		retn

;===== Indexed Entry Point ================================================

loc_a_3110:
		mov	al,ds:d_04E9_018D_e
		cmp	al,ds:d_04E9_D20C_e
		je	loc_a_3160		; Jump if equal
		mov	cl,al
		shr	al,1			; Shift w/zeros fill
		and	al,3
		xor	ah,ah			; Zero register
		add	ax,0D205h
		mov	bx,ax
		mov	al,ds:d_04E9_018C_e
		or	al,[bx]
		mov	ds:d_04E9_018F_e,al
		mov	al,cl
		cmp	al,0Fh
		jb	loc_a_3136		; Jump if below
		mov	cl,0Fh
loc_a_3136:
		xor	ch,ch			; Zero register
		mov	bx,d_04E9_D20D_e
		add	bx,cx
		mov	al,[bx]
		test	al,80h
		jz	loc_a_3145		; Jump if zero
		dec	ch
loc_a_3145:
		add	al,ds:d_04E9_0188_e
		mov	ds:d_04E9_0188_e,al
		mov	al,ch
		adc	al,byte ptr ds:d_04E9_0188_e+1
		test	al,80h
		jnz	loc_a_3184		; Jump if not zero
		and	al,3
		mov	byte ptr ds:d_04E9_0188_e+1,al
		inc	byte ptr ds:d_04E9_018D_e
		retn
loc_a_3160:
		mov	al,byte ptr ds:[18Ch]
		or	al,0
		mov	byte ptr ds:[18Fh],al
		mov	bx,word ptr ds:[188h]
		sub	bx,4
		mov	word ptr ds:[188h],bx
		test	bh,80h
		jnz	loc_a_3184		; Jump if not zero
		mov	al,byte ptr ds:[187h]
		call	sub_a_3494
		jnc	loc_a_3181		; Jump if carry=0
		retn
loc_a_3181:
		jmp	loc_a_33A4
loc_a_3184:
		mov	byte ptr ds:d_04E9_018E_e,8
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	word ptr ds:d_04E9_0188_e,0
		mov	bp,1D0h
		mov	cx,4

locloop_a_319A:
		mov	al,ds:[bp+30h]
		cmp	al,0
		je	loc_a_31B5		; Jump if equal
		cmp	al,7
		jne	loc_a_31AA		; Jump if not equal
		mov	al,0
		jmp	short loc_a_31AC
loc_a_31AA:
		mov	al,4
loc_a_31AC:
		mov	ds:[bp+30h],al
		mov	byte ptr ds:[bp+2Ah],0
loc_a_31B5:
		inc	bp
		loop	locloop_a_319A		; Loop if cx > 0

		mov	al,6
		call	sub_a_1153

;===== Indexed Entry Point ================================================

loc_a_31BD:
		mov	bx,d_04E9_018D_e
		mov	al,[bx]
		cmp	al,18h
		jae	loc_a_31D0		; Jump if above or =
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	ds:d_04E9_018F_e,al
		inc	byte ptr [bx]
		retn
loc_a_31D0:
		mov	byte ptr ds:[190h],0
		mov	al,[bx]
		cmp	al,38h			; '8'
		je	loc_a_31DE		; Jump if equal
		inc	byte ptr [bx]
		retn
loc_a_31DE:
		mov	byte ptr ds:[191h],1
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_31E4	proc	near
		mov	bx,d_04E9_0241_e
		cmp	byte ptr [bx],0
		jne	loc_a_31F7		; Jump if not equal
		mov	al,ds:d_04E9_023D_e
		or	al,al			; Zero ?
		jz	loc_a_3207		; Jump if zero
		mov	[bx],al
		jmp	short loc_a_3207
loc_a_31F7:
		mov	al,ds:d_04E9_023D_e
		or	al,al			; Zero ?
		jnz	loc_a_3202		; Jump if not zero
		mov	[bx],al
		jmp	short loc_a_3207
loc_a_3202:
		mov	byte ptr ds:d_04E9_023D_e,0
loc_a_3207:
		mov	al,ds:d_04E9_018E_e
		xor	ah,ah			; Zero register
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_3215[bx]	;*10 entries
data_a_3215	dw	offset loc_a_324A	; Data table (indexed access)
data_a_3217	dw	offset loc_a_3336
data_a_3219	dw	offset loc_a_33F1
data_a_321B	dw	offset loc_a_3468
data_a_321D	dw	offset loc_a_2E96
data_a_321F	dw	offset loc_a_2FD0
data_a_3221	dw	offset loc_a_3048
data_a_3223	dw	offset loc_a_3110
data_a_3225	dw	offset loc_a_31BD
data_a_3227	dw	offset loc_a_2B88
loc_a_3229:
		mov	byte ptr ds:d_04E9_018E_e,0
		mov	byte ptr ds:d_04E9_018D_e,0
		retn
			                        ;* No entry point to code
		call	sub_a_4B7D
		mov	cx,1F4h

locloop_a_323A:
		nop
		loop	locloop_a_323A		; Loop if cx > 0

		xor	al,al			; Zero register
		jmp	loc_a_4B7D
data_a_3242	dw	offset loc_a_325B	; Data table (indexed access)
data_a_3244	dw	offset loc_a_33A4
data_a_3246	dw	offset loc_a_33B5
data_a_3248	dw	offset loc_a_33C4

;===== Indexed Entry Point ================================================

loc_a_324A:
		call	sub_a_2A6F
		call	sub_a_2ABA
		xor	ah,ah			; Zero register
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_3242[bx]	;*4 entries

;===== Indexed Entry Point ================================================

loc_a_325B:
		call	sub_a_2A41
		cmp	byte ptr ds:d_04E9_023E_e,0
		je	loc_a_32B4		; Jump if equal
		test	byte ptr ds:d_04E9_023E_e,80h
		jnz	loc_a_3276		; Jump if not zero
		test	byte ptr ds:d_04E9_018C_e,80h
		jnz	loc_a_3280		; Jump if not zero
		jmp	loc_a_345D
loc_a_3276:
		test	byte ptr ds:d_04E9_018C_e,80h
		jz	loc_a_3280		; Jump if zero
		jmp	loc_a_345D
loc_a_3280:
		cmp	byte ptr ds:d_04E9_023D_e,0
		je	loc_a_3289		; Jump if equal
		jmp	short loc_a_32FB
loc_a_3289:
		mov	al,ds:d_04E9_023E_e
		call	sub_a_3626
		jnc	loc_a_3294		; Jump if carry=0
		jmp	loc_a_331B
loc_a_3294:
		mov	al,ds:d_04E9_018D_e
		inc	al
		and	al,7
		mov	ds:d_04E9_018D_e,al
		add	al,ds:d_04E9_018C_e
		add	al,0
		mov	ds:d_04E9_018F_e,al
		mov	al,ds:d_04E9_018D_e
		and	al,3
		jz	loc_a_32AF		; Jump if zero
		retn
loc_a_32AF:
		mov	al,2
		jmp	loc_a_1153
loc_a_32B4:
		cmp	byte ptr ds:d_04E9_023D_e,0
		je	loc_a_32BE		; Jump if equal
		jmp	loc_a_2FAA
loc_a_32BE:
		cmp	byte ptr ds:d_04E9_023F_e,0
		je	loc_a_32F2		; Jump if equal
		call	sub_a_2A52
		jnc	loc_a_32DA		; Jump if carry=0
		or	al,al			; Zero ?
		jz	loc_a_32D4		; Jump if zero
		cmp	al,ds:d_04E9_023F_e
		jne	loc_a_32DA		; Jump if not equal
loc_a_32D4:
		mov	al,ds:d_04E9_023F_e
		jmp	loc_a_3035
loc_a_32DA:
		mov	al,ds:d_04E9_023F_e
		cmp	al,1
		jne	loc_a_32F2		; Jump if not equal
		call	sub_a_2B2D
		jnc	loc_a_32F2		; Jump if carry=0
		or	al,al			; Zero ?
		jz	loc_a_32EF		; Jump if zero
		mov	byte ptr ds:d_04E9_01A7_e,1
loc_a_32EF:
		jmp	loc_a_2E81
loc_a_32F2:
		mov	al,ds:d_04E9_018C_e
		or	al,0Ch
		mov	ds:d_04E9_018F_e,al
		retn
loc_a_32FB:
		mov	byte ptr ds:d_04E9_018E_e,1
		mov	al,ds:d_04E9_023E_e
		mov	ds:d_04E9_D21D_e,al
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	byte ptr ds:d_04E9_D21F_e,0
		mov	byte ptr ds:d_04E9_D220_e,0Ch
		mov	al,4
		call	sub_a_1153
		retn
loc_a_331B:
		mov	byte ptr ds:d_04E9_018E_e,1
		mov	al,ds:d_04E9_023E_e
		mov	ds:d_04E9_D21D_e,al
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	byte ptr ds:d_04E9_D21F_e,80h
		mov	byte ptr ds:d_04E9_D220_e,7
		retn

;===== Indexed Entry Point ================================================

loc_a_3336:
		mov	al,ds:d_04E9_018D_e
		and	al,7
		or	al,ds:d_04E9_018C_e
		add	al,0
		mov	ds:d_04E9_018F_e,al
		mov	al,ds:d_04E9_D21D_e
		call	sub_a_3626
		mov	cl,ds:d_04E9_018D_e
		xor	ch,ch			; Zero register
		mov	bx,0D221h
		test	byte ptr ds:d_04E9_D21F_e,80h
		jz	loc_a_335D		; Jump if zero
		mov	bx,d_04E9_D22D_e
loc_a_335D:
		add	bx,cx
		mov	al,[bx]
loc_a_3361:
		mov	ds:d_04E9_D21E_e,al
		call	sub_a_3648
		jnc	loc_a_3382		; Jump if carry=0
		mov	al,ds:d_04E9_D21E_e
		test	al,80h
		jnz	loc_a_3376		; Jump if not zero
		dec	al
		jnz	loc_a_3361		; Jump if not zero
		jmp	short loc_a_3382
loc_a_3376:
		inc	al
		jnz	loc_a_3361		; Jump if not zero
		mov	al,2
		call	sub_a_1153
		jmp	loc_a_3229
loc_a_3382:
		inc	byte ptr ds:d_04E9_018D_e
		mov	al,ds:d_04E9_018D_e
		cmp	al,ds:d_04E9_D220_e
		jae	loc_a_3390		; Jump if above or =
		retn
loc_a_3390:
		mov	al,0FFh
		call	sub_a_3648
		jc	loc_a_3399		; Jump if carry Set
		jmp	short loc_a_33AA
loc_a_3399:
		mov	byte ptr ds:d_04E9_018D_e,1
		mov	byte ptr ds:d_04E9_018E_e,2
		retn

;===== Indexed Entry Point ================================================

loc_a_33A4:
		mov	al,0
		mov	ch,0
		jmp	short loc_a_33D1
loc_a_33AA:
		mov	byte ptr ds:d_04E9_D234_e,3
		mov	al,0
		mov	ch,0
		jmp	short loc_a_33D6

;===== Indexed Entry Point ================================================

loc_a_33B5:
		mov	al,0Fh
		mov	ch,0FFh
		test	byte ptr ds:d_04E9_018C_e,80h
		jnz	loc_a_33D1		; Jump if not zero
		mov	ch,1
		jmp	short loc_a_33D1

;===== Indexed Entry Point ================================================

loc_a_33C4:
		mov	al,0Eh
		mov	ch,1
		test	byte ptr ds:d_04E9_018C_e,80h
		jnz	loc_a_33D1		; Jump if not zero
		mov	ch,0FFh
loc_a_33D1:
		mov	byte ptr ds:d_04E9_D234_e,1
loc_a_33D6:
		add	al,ds:d_04E9_018C_e
		mov	ds:d_04E9_018F_e,al
		mov	ds:d_04E9_D235_e,ch
		mov	byte ptr ds:d_04E9_018E_e,2
		mov	byte ptr ds:d_04E9_018D_e,0
		mov	byte ptr ds:d_04E9_D236_e,0FFh
		retn

;===== Indexed Entry Point ================================================

loc_a_33F1:
		cmp	byte ptr ds:d_04E9_018D_e,0
		jne	loc_a_342B		; Jump if not equal
		inc	byte ptr ds:d_04E9_D236_e
		mov	al,ds:d_04E9_D235_e
		call	sub_a_3626
		jnc	loc_a_3409		; Jump if carry=0
		mov	byte ptr ds:d_04E9_D235_e,0
loc_a_3409:
		mov	al,ds:d_04E9_D234_e
		neg	al
		call	sub_a_3648
		jnc	loc_a_344E		; Jump if carry=0
		dec	byte ptr ds:d_04E9_D234_e
		jnz	loc_a_3409		; Jump if not zero
		cmp	byte ptr ds:d_04E9_D235_e,0
		je	loc_a_3427		; Jump if equal
		cmp	byte ptr ds:d_04E9_D236_e,2
		jb	loc_a_344E		; Jump if below
loc_a_3427:
		inc	byte ptr ds:d_04E9_018D_e
loc_a_342B:
		mov	al,2
		sub	al,ds:d_04E9_018D_e
		add	al,ds:d_04E9_018C_e
		add	al,0Ch
		mov	ds:d_04E9_018F_e,al
		inc	byte ptr ds:d_04E9_018D_e
		cmp	byte ptr ds:d_04E9_018D_e,3
		je	loc_a_3446		; Jump if equal
		retn
loc_a_3446:
		mov	al,2
		call	sub_a_1153
		jmp	loc_a_3229
loc_a_344E:
		mov	al,ds:d_04E9_D234_e
		inc	al
		cmp	al,4
		jb	loc_a_3459		; Jump if below
		mov	al,4
loc_a_3459:
		mov	ds:d_04E9_D234_e,al
		retn
loc_a_345D:
		mov	byte ptr ds:d_04E9_018E_e,3
		mov	byte ptr ds:d_04E9_018D_e,0
		retn

;===== Indexed Entry Point ================================================

loc_a_3468:
		mov	al,ds:d_04E9_018D_e
		test	byte ptr ds:d_04E9_018C_e,80h
		jz	loc_a_3474		; Jump if zero
		add	al,7
loc_a_3474:
		xor	ah,ah			; Zero register
		add	ax,0D1D8h
		mov	bx,ax
		mov	al,[bx]
		mov	ds:d_04E9_018F_e,al
		inc	byte ptr ds:d_04E9_018D_e
		cmp	byte ptr ds:d_04E9_018D_e,7
		je	loc_a_348C		; Jump if equal
		retn
loc_a_348C:
		xor	byte ptr ds:d_04E9_018C_e,80h
		jmp	loc_a_3229
sub_a_31E4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3494	proc	near
		mov	data_a_D239,al
		mov	byte ptr data_a_D23A,0FDh
		mov	byte ptr data_a_D23B,2
		mov	byte ptr data_a_D23C,0
		mov	byte ptr data_a_D240,0
		mov	byte ptr data_a_D241,9
		jmp	short loc_a_3504

;==== External Entry into Subroutine ======================================

sub_a_34B2:
		mov	al,ds:[bp]
		mov	data_a_D239,al
		mov	bl,ds:[bp+6]
		mov	bh,ds:[bp+0Ch]
		mov	byte ptr data_a_D23A,0FEh
		mov	byte ptr data_a_D23B,1
		mov	byte ptr data_a_D23C,1
		mov	byte ptr data_a_D240,1
		mov	byte ptr data_a_D241,7
		jmp	short loc_a_3504

;==== External Entry into Subroutine ======================================

sub_a_34DC:
		mov	al,ds:[bp]
		mov	data_a_D239,al
		mov	bl,ds:[bp+6]
		mov	bh,ds:[bp+0Ch]
		mov	byte ptr data_a_D23A,0FFh
		mov	byte ptr data_a_D23B,0
		mov	byte ptr data_a_D23C,2
		mov	byte ptr data_a_D240,2
		mov	byte ptr data_a_D241,5
loc_a_3504:
		mov	al,data_a_D239
		add	al,data_a_D23A
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		and	al,0Fh
		mov	data_a_D237,al
		mov	al,data_a_D239
		add	al,data_a_D23B
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		inc	al
		and	al,0Fh
		mov	data_a_D238,al
		mov	al,bl
		shr	bx,1			; Shift w/zeros fill
		shr	bx,1			; Shift w/zeros fill
		mov	ch,al
		mov	al,data_a_D23C
		or	al,al			; Zero ?
		mov	cl,al
		mov	al,ch
		jz	loc_a_3543		; Jump if zero
		dec	cl
		jnz	loc_a_3558		; Jump if not zero
		jmp	short loc_a_355C
loc_a_3543:
		and	al,3
		cmp	al,3
		cmc				; Complement carry
		mov	al,2
		adc	al,0
		mov	byte ptr ds:[1ABh],al
		mov	al,data_a_D237
		mov	data_a_D244,bl
		jmp	short loc_a_356F
loc_a_3558:
		mov	ch,0
		jmp	short loc_a_355E
loc_a_355C:
		mov	ch,1
loc_a_355E:
		and	al,3
		jz	loc_a_3564		; Jump if zero
		inc	ch
loc_a_3564:
		mov	byte ptr ds:[1ABh],ch
		mov	al,data_a_D237
		mov	data_a_D244,bl
loc_a_356F:
		mov	bh,al
		mov	bl,ds:d_04E9_D244_e
		add	bx,0A7Eh
		mov	al,ds:d_04E9_01AB_e
		xor	ah,ah			; Zero register
		mov	ds:d_04E9_D242_e,ax
loc_a_3581:
		mov	ds:d_04E9_D23E_e,bx
		add	bx,ds:d_04E9_D242_e
		mov	al,[bx]
		test	al,80h
		jz	loc_a_35FD		; Jump if zero
		and	al,0Fh
		cmp	al,4
		jb	loc_a_359F		; Jump if below
		and	al,3
		cmp	al,1
		jne	loc_a_359F		; Jump if not equal
		xor	al,al			; Zero register
		jmp	short loc_a_35AB
loc_a_359F:
		and	al,3
		cmp	al,3
		je	loc_a_35FD		; Jump if equal
		shr	al,1			; Shift w/zeros fill
		jnc	loc_a_35AB		; Jump if carry=0
		jmp	short loc_a_3624
loc_a_35AB:
		mov	ds:d_04E9_D23D_e,al
		mov	al,ds:d_04E9_D237_e
		add	al,al
		add	al,al
		add	al,al
		adc	al,ds:d_04E9_D240_e
		mov	ds:d_04E9_D245_e,al
		adc	al,ds:d_04E9_D241_e
		mov	ds:d_04E9_D246_e,al
		mov	al,ds:d_04E9_D239_e
		cmp	al,ds:d_04E9_D245_e
		jb	loc_a_35FD		; Jump if below
		cmp	al,ds:d_04E9_D246_e
		jae	loc_a_35FD		; Jump if above or =
		mov	al,ds:d_04E9_D23D_e
		or	al,al			; Zero ?
		jz	loc_a_3624		; Jump if zero
		cmp	byte ptr ds:d_04E9_D23C_e,2
		jne	loc_a_3624		; Jump if not equal
		inc	byte ptr ds:d_04E9_01B3_e
		mov	byte ptr [bx],0
		push	bx
		mov	bx,50h
		call	sub_a_1D81
		mov	al,2
		call	sub_a_2489
		mov	al,9
		call	sub_a_1153
		pop	bx
		jmp	short loc_a_3624
loc_a_35FD:
		mov	bx,ds:d_04E9_D23E_e
		dec	byte ptr ds:d_04E9_D242_e
		cmp	byte ptr ds:d_04E9_D242_e,0FFh
		je	loc_a_360F		; Jump if equal
		jmp	loc_a_3581
loc_a_360F:
		mov	al,ds:d_04E9_D237_e
		inc	al
		and	al,0Fh
		mov	ds:d_04E9_D237_e,al
		cmp	al,ds:d_04E9_D238_e
		je	loc_a_3622		; Jump if equal
		jmp	loc_a_356F
loc_a_3622:
		clc				; Clear carry flag
		retn
loc_a_3624:
		stc				; Set carry flag
		retn
sub_a_3494	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3626	proc	near
loc_a_3626:
		mov	cl,al
		mov	al,byte ptr ds:[187h]
		mov	byte ptr ds:[1A8h],al
		add	al,cl
		and	al,7Fh
		mov	byte ptr ds:[187h],al
		mov	bx,word ptr ds:[188h]
		call	sub_a_3494
		jnc	loc_a_3646		; Jump if carry=0
		mov	al,ds:d_04E9_01A8_e
		mov	ds:d_04E9_0187_e,al
		stc				; Set carry flag
		retn
loc_a_3646:
		clc				; Clear carry flag
		retn
sub_a_3626	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3648	proc	near
		mov	bx,word ptr ds:[188h]
		mov	word ptr ds:[1A9h],bx
		xor	cl,cl			; Zero register
		test	al,80h
		jz	loc_a_3658		; Jump if zero
		dec	cl
loc_a_3658:
		add	al,bl
		mov	bl,al
		mov	al,cl
		adc	al,bh
		test	al,80h
		jnz	loc_a_3680		; Jump if not zero
		and	al,3
		mov	bh,al
		mov	word ptr ds:[188h],bx
		mov	al,byte ptr ds:[187h]
		call	sub_a_3494
		jnc	loc_a_367E		; Jump if carry=0
		mov	bx,ds:d_04E9_01A9_e
		mov	ds:d_04E9_0188_e,bx
		stc				; Set carry flag
		retn
loc_a_367E:
		clc				; Clear carry flag
		retn
loc_a_3680:
		pop	bx
		jmp	loc_a_3184
sub_a_3648	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3684	proc	near
		mov	ax,word ptr ds:[18Ah]
		sub	ax,word ptr ds:[188h]
		jc	loc_a_368E		; Jump if carry Set
		retn
loc_a_368E:
		mov	ax,word ptr ds:[18Ah]
		mov	cx,word ptr ds:[188h]
		cmp	al,cl
		jne	loc_a_369E		; Jump if not equal
		cmp	ah,ch
		jne	loc_a_369E		; Jump if not equal
		retn
loc_a_369E:
		push	ax
		mov	bx,10h
		call	sub_a_1D81
		pop	ax
		inc	ax
		mov	word ptr ds:[18Ah],ax
		jmp	short loc_a_368E
sub_a_3684	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_36AC	proc	near
		mov	byte ptr ds:d_04E9_01B6_e,3
		mov	byte ptr ds:d_04E9_01B7_e,3
		mov	byte ptr ds:d_04E9_0190_e,0
		mov	bx,1B8h
		mov	cx,8

locloop_a_36C1:
		mov	byte ptr [bx],0
		inc	bx
		loop	locloop_a_36C1		; Loop if cx > 0

		retn
sub_a_36AC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_36C8	proc	near
		mov	al,ds:d_04E9_025A_e
		mov	ah,0FFh
		mov	ds:d_04E9_0254_e,ax
		mov	ds:d_04E9_0256_e,ax
		retn
sub_a_36C8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_36D4	proc	near
		xor	al,al			; Zero register
		mov	bx,d_04E9_01B5_e
		cmp	byte ptr ds:d_04E9_01B4_e,1
		je	loc_a_36E4		; Jump if equal
		inc	al
		sub	al,[bx]
loc_a_36E4:
		mov	[bx],al
		mov	bx,d_04E9_0254_e+1
		or	al,al			; Zero ?
		jz	loc_a_36EF		; Jump if zero
		inc	bx
		inc	bx
loc_a_36EF:
		cmp	byte ptr [bx],0
		jne	loc_a_3713		; Jump if not equal
		cmp	byte ptr ds:d_04E9_01B4_e,1
		je	loc_a_3731		; Jump if equal
		mov	al,1
		sub	al,ds:d_04E9_01B5_e
		mov	ds:d_04E9_01B5_e,al
		mov	bx,d_04E9_0254_e+1
		or	al,al			; Zero ?
		jz	loc_a_370D		; Jump if zero
		inc	bx
		inc	bx
loc_a_370D:
		mov	al,[bx]
		or	al,al			; Zero ?
		jz	loc_a_3731		; Jump if zero
loc_a_3713:
		dec	bx
		mov	al,[bx]
		mov	ds:d_04E9_01AE_e,al
		inc	bx
		mov	ah,[bx]
		mov	bx,d_04E9_0199_e
		mov	cx,8

locloop_a_3722:
		xor	al,al			; Zero register
		rcr	ah,1			; Rotate thru carry
		jnc	loc_a_372A		; Jump if carry=0
		inc	al
loc_a_372A:
		mov	[bx],al
		inc	bx
		loop	locloop_a_3722		; Loop if cx > 0

		stc				; Set carry flag
		retn
loc_a_3731:
		clc				; Clear carry flag
		retn
sub_a_36D4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3733	proc	near
		cmp	byte ptr ds:d_04E9_0238_e,0
		je	loc_a_373F		; Jump if equal
;*		call	sub_a_02BD		;*
		db	0E8h, 80h,0CBh		;  Fixup - byte match
		jmp	short loc_a_3742
loc_a_373F:
		call	sub_a_1E6D
loc_a_3742:
		mov	al,ds:d_04E9_CE4C_e
		mov	ah,al
		and	al,1
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
		sbb	al,0
		mov	ds:d_04E9_023E_e,al
		mov	al,ah
		and	al,1
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
		sbb	al,0
		neg	al
		mov	ds:d_04E9_023F_e,al
		mov	ds:d_04E9_023D_e,ah
		retn
sub_a_3733	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3766	proc	near
		mov	bl,ds:d_04E9_0261_e
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		add	bx,d_04E9_D247_e
		mov	bx,[bx]
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		mov	bx,[bx]
		mov	cx,[bx]
		inc	bx
		inc	bx
		retn
sub_a_3766	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3781	proc	near
		mov	bp,1D4h
		mov	byte ptr ds:[bp+2Ah],0FFh
		retn
sub_a_3781	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_378A	proc	near
		mov	bp,1D4h
		mov	byte ptr ds:[bp+12h],0
		mov	al,ds:[bp+2Ah]
		cmp	al,0FFh
		jne	loc_a_379B		; Jump if not equal
		retn
loc_a_379B:
		cmp	al,0Ch
		jne	loc_a_37A5		; Jump if not equal
loc_a_379F:
		mov	byte ptr ds:[bp+2Ah],0FFh
		retn
loc_a_37A5:
		mov	cl,al
		inc	byte ptr ds:[bp+2Ah]
		mov	al,ds:[bp+36h]
		shl	al,1			; Shift w/zeros fill
		add	al,ds:[bp]
		and	al,7Fh
		mov	ds:[bp],al
		xor	ch,ch			; Zero register
		mov	bx,offset data_a_D257
		add	bx,cx
		mov	al,ds:[bp+6]
		add	al,[bx]
		mov	ds:[bp+6],al
		mov	al,ds:[bp+0Ch]
		adc	al,0
		and	al,3
		mov	ds:[bp+0Ch],al
		push	bp
		call	sub_a_34DC
		pop	bp
		jc	loc_a_379F		; Jump if carry Set
		call	sub_a_08C0
		jc	loc_a_37E5		; Jump if carry Set
		retn
loc_a_37E5:
		push	bp
		mov	bp,bx
		mov	al,ds:[bp+30h]
		cmp	al,5
		je	loc_a_3822		; Jump if equal
		cmp	al,8
		je	loc_a_3822		; Jump if equal
		cmp	al,9
		je	loc_a_3822		; Jump if equal
		cmp	al,2
		jne	loc_a_3808		; Jump if not equal
		mov	byte ptr ds:[bp+2Ah],4Bh	; 'K'
		mov	byte ptr ds:[bp+30h],5
		jmp	short loc_a_3822
loc_a_3808:
		mov	byte ptr ds:[bp+30h],4
		mov	byte ptr ds:[bp+2Ah],0
		mov	bx,100h
		call	sub_a_1D81
		mov	al,5
		call	sub_a_2489
		mov	al,9
		call	sub_a_1153
loc_a_3822:
		pop	bp
		jmp	loc_a_379F
sub_a_378A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3826	proc	near
		cmp	byte ptr ds:[18Eh],8
		jne	loc_a_382E		; Jump if not equal
		retn
loc_a_382E:
		cmp	byte ptr ds:[18Eh],9
		jne	loc_a_3836		; Jump if not equal
		retn
loc_a_3836:
		mov	bx,word ptr ds:[1CEh]
		rcr	bx,1			; Rotate thru carry
		rcr	bx,1			; Rotate thru carry
		mov	byte ptr ds:[1ABh],bl
		mov	bp,1D0h
		mov	cx,4

locloop_a_3848:
		mov	al,ds:[bp+30h]
		cmp	al,0
		je	loc_a_3854		; Jump if equal
		inc	bp
		loop	locloop_a_3848		; Loop if cx > 0

		retn
loc_a_3854:
		mov	bx,word ptr ds:[236h]
		sub	bx,0A7Eh
		cmp	byte ptr ds:[1AFh],bl
		jne	loc_a_3865		; Jump if not equal
		jmp	loc_a_3956
loc_a_3865:
		cmp	byte ptr ds:[1ABh],bl
		jne	loc_a_386E		; Jump if not equal
		jmp	loc_a_3956
loc_a_386E:
		jnc	loc_a_3873		; Jump if carry=0
		jmp	loc_a_3956
loc_a_3873:
		add	bx,0A7Eh
loc_a_3877:
		mov	al,[bx]
		test	al,80h
		jz	loc_a_387F		; Jump if zero
		jmp	short loc_a_3883
loc_a_387F:
		and	al,70h			; 'p'
		jnz	loc_a_389C		; Jump if not zero
loc_a_3883:
		sub	bx,0A7Eh
		inc	bh
		and	bh,0Fh
		mov	al,bh
		add	bx,0A7Eh
		cmp	al,0
		jne	loc_a_3877		; Jump if not equal
		inc	bx
		mov	word ptr ds:[236h],bx
		retn
loc_a_389C:
		mov	word ptr ds:[236h],bx
		mov	al,[bx]
		push	ax
		push	bx
		sub	bx,0A7Eh
		inc	bh
		and	bh,0Fh
		mov	al,bh
		add	bx,0A7Eh
		cmp	al,0
		jne	loc_a_38B8		; Jump if not equal
		inc	bx
loc_a_38B8:
		mov	word ptr ds:[236h],bx
		pop	bx
		pop	ax
		and	al,70h			; 'p'
		cmp	al,10h
		je	loc_a_3916		; Jump if equal
		cmp	al,60h			; '`'
		jae	loc_a_38FE		; Jump if above or =
		cmp	al,40h			; '@'
		jae	loc_a_38E6		; Jump if above or =
		cmp	al,20h			; ' '
		je	loc_a_38D4		; Jump if equal
		xor	al,al			; Zero register
		jmp	short loc_a_38D6
loc_a_38D4:
		mov	al,1
loc_a_38D6:
		mov	ds:[bp+36h],al
		mov	byte ptr ds:[bp+42h],1
		mov	byte ptr ds:[bp+3Ch],0
		jmp	short loc_a_3925
loc_a_38E6:
		and	al,10h
		jz	loc_a_38EC		; Jump if zero
		mov	al,1
loc_a_38EC:
		inc	al
		mov	ds:[bp+36h],al
		mov	byte ptr ds:[bp+42h],8
		mov	byte ptr ds:[bp+3Ch],0
		jmp	short loc_a_3925
loc_a_38FE:
		and	al,10h
		jz	loc_a_3904		; Jump if zero
		mov	al,1
loc_a_3904:
		inc	al
		mov	ds:[bp+36h],al
		mov	byte ptr ds:[bp+42h],9
		mov	byte ptr ds:[bp+3Ch],0
		jmp	short loc_a_3925
loc_a_3916:
		mov	byte ptr ds:[bp+36h],1
		mov	byte ptr ds:[bp+42h],2
		mov	byte ptr ds:[bp+3Ch],0
loc_a_3925:
		sub	bx,0A7Eh
		mov	al,bh
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	al,4
		and	al,7Fh
		mov	ds:[bp],al
		xor	al,al			; Zero register
		rcl	bl,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		rcl	bl,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		mov	ds:[bp+6],bl
		mov	ds:[bp+0Ch],al
		mov	byte ptr ds:[bp+30h],6
		mov	byte ptr ds:[bp+2Ah],0
		retn
loc_a_3956:
		mov	al,byte ptr ds:[218h]
		cmp	al,0FFh
		jne	loc_a_395E		; Jump if not equal
		retn
loc_a_395E:
		dec	al
		mov	byte ptr ds:[218h],al
		cmp	al,0FFh
		je	loc_a_3968		; Jump if equal
		retn
loc_a_3968:
		mov	byte ptr ds:[bp+30h],7
		mov	byte ptr ds:[bp+2Ah],0
		mov	al,byte ptr ds:[219h]
		neg	al
		mov	byte ptr ds:[219h],al
		mov	ds:[bp+36h],al
		add	al,al
		mov	al,0
		jnc	loc_a_3986		; Jump if carry=0
		mov	al,78h			; 'x'
loc_a_3986:
		mov	ds:[bp],al
		mov	bx,word ptr ds:[188h]
		mov	ds:[bp+6],bl
		mov	ds:[bp+0Ch],bh
		retn
sub_a_3826	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3997	proc	near
		mov	bp,d_04E9_D263_e
		call	sub_a_45FC
		call	sub_a_36AC
		jmp	loc_a_2756
sub_a_3997	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_39A3	proc	near
		mov	ax,129Dh
		mov	es,ax
		cmp	byte ptr ds:[190h],0
		jne	loc_a_39B0		; Jump if not equal
		retn
loc_a_39B0:
		mov	al,byte ptr ds:[18Fh]
		cmp	byte ptr ds:[18Eh],8
		jne	loc_a_39CA		; Jump if not equal
		mov	bx,18Ch
		test	byte ptr [bx],80h
		jz	loc_a_39C6		; Jump if zero
		add	al,1Fh
		jmp	short loc_a_39D9
loc_a_39C6:
		add	al,44h			; 'D'
		jmp	short loc_a_39D9
loc_a_39CA:
		mov	bh,al
		and	al,7Fh
		test	bh,80h
		jnz	loc_a_39D7		; Jump if not zero
		add	al,25h			; '%'
		jmp	short loc_a_39D9
loc_a_39D7:
		add	al,0
loc_a_39D9:
		call	sub_a_3766
		push	bx
		push	cx
		mov	al,byte ptr ds:[188h]
		sub	al,byte ptr ds:[251h]
		shl	al,1			; Shift w/zeros fill
		mov	cl,al
		mov	al,9Ch
		sub	al,cl
		mov	ah,al
		mov	al,10h
		mov	word ptr ds:[25Bh],ax
		call	sub_a_4571
		mov	di,ax
		pop	cx
		pop	si
		mov	bx,4
		mov	al,cl
		mov	cx,15h
		cmp	al,3
		je	locloop_a_3A30		; Jump if equal

locloop_a_3A07:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,4
		mov	ax,2000h
		test	di,ax
		jz	loc_a_3A2A		; Jump if zero
		mov	ax,0E050h
loc_a_3A2A:
		add	di,ax
		loop	locloop_a_3A07		; Loop if cx > 0

		jmp	short loc_a_3A62

locloop_a_3A30:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,6
		mov	ax,2000h
		test	di,ax
		jz	loc_a_3A5E		; Jump if zero
		mov	ax,0E050h
loc_a_3A5E:
		add	di,ax
		loop	locloop_a_3A30		; Loop if cx > 0

loc_a_3A62:
		cmp	byte ptr ds:[1ADh],0FFh
		jne	loc_a_3A6A		; Jump if not equal
		retn
loc_a_3A6A:
		mov	ax,word ptr ds:[25Bh]
		add	ah,14h
		call	sub_a_4571
		mov	di,ax
		xor	ax,ax			; Zero register
		stosw				; Store ax to es:[di]
		mov	es:[di],ax
		mov	ax,0FFFFh
		mov	cx,3

locloop_a_3A81:
		sub	di,1FB0h
		mov	es:[di],ax
		dec	di
		dec	di
		mov	es:[di],ax
		add	di,d_129D_2000_e
		stosw				; Store ax to es:[di]
		mov	es:[di],ax
		loop	locloop_a_3A81		; Loop if cx > 0

		sub	di,1FB0h
		mov	es:[di],ax
		dec	di
		dec	di
		mov	es:[di],ax
		add	di,d_129D_2000_e
		xor	ax,ax			; Zero register
		stosw				; Store ax to es:[di]
		mov	es:[di],ax
		retn
sub_a_39A3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3AAE	proc	near
		cmp	byte ptr data_a_D27C,0
		jne	loc_a_3AB6		; Jump if not equal
		retn
loc_a_3AB6:
		mov	byte ptr data_a_D27C,0
		mov	bx,data_a_D27E
		mov	ch,data_a_D27D
		mov	al,bl
		cmp	al,7
		jb	loc_a_3ACE		; Jump if below
		cmp	al,17h
		jae	loc_a_3ACE		; Jump if above or =
		retn
loc_a_3ACE:
		cmp	al,1Eh
		jb	loc_a_3AD3		; Jump if below
		retn
loc_a_3AD3:
		mov	cl,2
		cmp	al,5
		jb	loc_a_3AF6		; Jump if below
		jz	loc_a_3AFE		; Jump if zero
		dec	cl
		cmp	al,6
		je	loc_a_3AFE		; Jump if equal
		cmp	al,17h
		jne	loc_a_3AEC		; Jump if not equal
		mov	al,ch
		or	al,al			; Zero ?
		jnz	loc_a_3AEC		; Jump if not zero
		retn
loc_a_3AEC:
		inc	cl
		cmp	al,19h
		jae	loc_a_3AF6		; Jump if above or =
		inc	bl
		dec	cl
loc_a_3AF6:
		mov	al,ch
		or	al,al			; Zero ?
		jz	loc_a_3AFE		; Jump if zero
		inc	cl
loc_a_3AFE:
		mov	ax,bx
		add	al,2
		shl	al,1			; Shift w/zeros fill
		call	sub_a_455B
		mov	di,ax
		add	di,4
		mov	ax,0B800h
		mov	es,ax
		dec	cl
		jz	loc_a_3B1B		; Jump if zero
		dec	cl
		jz	loc_a_3B32		; Jump if zero
		jmp	short loc_a_3B4F
loc_a_3B1B:
		mov	cx,10h

locloop_a_3B1E:
		mov	word ptr es:[di],0
		mov	ax,2000h
		test	di,ax
		jz	loc_a_3B2D		; Jump if zero
		mov	ax,0E050h
loc_a_3B2D:
		add	di,ax
		loop	locloop_a_3B1E		; Loop if cx > 0

		retn
loc_a_3B32:
		mov	cx,10h

locloop_a_3B35:
		mov	word ptr es:[di],0
		mov	word ptr es:[di+2],0
		mov	ax,2000h
		test	di,ax
		jz	loc_a_3B4A		; Jump if zero
		mov	ax,0E050h
loc_a_3B4A:
		add	di,ax
		loop	locloop_a_3B35		; Loop if cx > 0

		retn
loc_a_3B4F:
		mov	cx,10h

locloop_a_3B52:
		mov	word ptr es:[di],0
		mov	word ptr es:[di+2],0
		mov	word ptr es:[di+4],0
		mov	ax,2000h
		test	di,ax
		jz	loc_a_3B6D		; Jump if zero
		mov	ax,0E050h
loc_a_3B6D:
		add	di,ax
		loop	locloop_a_3B52		; Loop if cx > 0

		retn
sub_a_3AAE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3B72	proc	near
		mov	al,ds:[bp]
		add	al,20h			; ' '
		sub	al,byte ptr ds:[187h]
		and	al,7Fh
		xor	ah,ah			; Zero register
		add	ax,2792h
		mov	bx,ax
		cmp	bp,1D4h
		mov	al,[bx]
		jnz	loc_a_3B8F		; Jump if not zero
		add	al,2
loc_a_3B8F:
		shl	al,1			; Shift w/zeros fill
		add	al,78h			; 'x'
		mov	byte ptr ds:[174h],al
		mov	al,ds:[bp+6]
		sub	al,byte ptr ds:[251h]
		shl	al,1			; Shift w/zeros fill
		mov	cl,al
		mov	al,0A8h
		sub	al,cl
		cmp	bp,1D4h
		jne	loc_a_3BAE		; Jump if not equal
		add	al,8
loc_a_3BAE:
		mov	byte ptr ds:[176h],al
		retn
sub_a_3B72	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3BB2	proc	near
		mov	bx,187h
		mov	al,4
		sub	al,[bx]
		and	al,7
		xor	bl,bl			; Zero register
		shr	al,1			; Shift w/zeros fill
		rcr	bl,1			; Rotate thru carry
		mov	bh,al
		mov	cx,1D72h
		add	bx,cx
		mov	word ptr ds:[222h],bx
		mov	bx,0D280h
		mov	al,4
loc_a_3BD1:
		push	ax
		call	sub_a_3C59
		add	al,1Eh
		mov	[bx],al
		inc	bx
		pop	ax
		add	al,8
		cmp	al,84h
		jne	loc_a_3BD1		; Jump if not equal
		mov	bx,0D290h
		mov	al,4
loc_a_3BE6:
		push	ax
		call	sub_a_3C6F
		mov	[bx],al
		inc	bx
		pop	ax
		add	al,8
		cmp	al,84h
		jne	loc_a_3BE6		; Jump if not equal
		mov	bp,1D0h
		mov	cx,4

locloop_a_3BFA:
		push	cx
		mov	al,ds:[bp+12h]
		mov	ds:[bp+18h],al
		mov	al,ds:[bp+30h]
		cmp	al,0
		je	loc_a_3C41		; Jump if equal
		cmp	al,7
		mov	al,40h			; '@'
		jz	loc_a_3C18		; Jump if zero
		mov	al,ds:[bp]
		call	sub_a_3C6F
loc_a_3C18:
		mov	ds:[bp+1Eh],al
		mov	bl,ds:[bp+6]
		mov	bh,ds:[bp+0Ch]
		mov	cx,word ptr ds:[1CCh]
		cmp	bx,cx
		jb	loc_a_3C4B		; Jump if below
		mov	cx,word ptr ds:[1CEh]
		sub	bx,cx
		jnc	loc_a_3C41		; Jump if carry=0
		mov	al,ds:[bp+30h]
		cmp	al,7
		je	loc_a_3C46		; Jump if equal
		call	sub_a_3C8E
		jnc	loc_a_3C46		; Jump if carry=0
loc_a_3C41:
		mov	byte ptr ds:[bp+18h],0FFh
loc_a_3C46:
		pop	cx
		inc	bp
		loop	locloop_a_3BFA		; Loop if cx > 0

		retn
loc_a_3C4B:
		cmp	byte ptr ds:[bp+30h],7
		je	loc_a_3C41		; Jump if equal
		mov	byte ptr ds:[bp+30h],0
		jmp	short loc_a_3C41
sub_a_3BB2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C59	proc	near
		push	bx
		add	al,20h			; ' '
		sub	al,byte ptr ds:[187h]
		and	al,7Fh
		mov	cl,al
		xor	ch,ch			; Zero register
		mov	bx,2792h
		add	bx,cx
		mov	al,[bx]
		pop	bx
		retn
sub_a_3C59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C6F	proc	near
		add	al,20h			; ' '
		sub	al,byte ptr ds:[187h]
		and	al,7Fh
		cmp	al,20h			; ' '
		jae	loc_a_3C7F		; Jump if above or =
		add	al,20h			; ' '
		jmp	short loc_ret_a_3C8D
loc_a_3C7F:
		cmp	al,60h			; '`'
		jb	loc_a_3C87		; Jump if below
		sub	al,60h			; '`'
		jmp	short loc_ret_a_3C8D
loc_a_3C87:
		mov	ah,al
		mov	al,60h			; '`'
		sub	al,ah

loc_ret_a_3C8D:
		retn
sub_a_3C6F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C8E	proc	near
		mov	al,ds:[bp]
		call	sub_a_3C59
		add	al,20h			; ' '
		and	al,0FCh
		mov	data_a_D362,al
		mov	bx,word ptr ds:[222h]
		add	bx,cx
		mov	al,[bx]
		cmp	al,0Fh
		jne	loc_a_3CA9		; Jump if not equal
		retn
loc_a_3CA9:
		cmp	al,0Eh
		cmc				; Complement carry
		jnz	loc_a_3CAF		; Jump if not zero
		retn
loc_a_3CAF:
		mov	ah,al
		mov	al,byte ptr ds:[187h]
		sub	al,1Dh
		and	al,7Fh
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	cl,al
		add	al,ah
		and	al,0Fh
		mov	data_a_D350,al
		mov	ah,al
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		add	al,cl
		and	al,0Fh
		mov	data_a_D34F,al
		mov	ax,0FFFFh
		mov	di,224h
		mov	cx,9
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	byte ptr data_a_D351,0
		mov	al,ds:[bp]
		call	sub_a_3C59
		test	cl,40h			; '@'
		mov	data_a_D364,al
		jz	loc_a_3D37		; Jump if zero
		add	al,1Eh
		mov	cl,al
		xor	ch,ch			; Zero register
		mov	bx,offset data_a_D366
		add	bx,cx
		mov	al,[bx]
		cmp	al,0FFh
		je	loc_a_3D37		; Jump if equal
		shl	al,1			; Shift w/zeros fill
		mov	cl,al
		shl	al,1			; Shift w/zeros fill
		add	cl,al
		mov	si,offset data_a_D2A0
		add	si,cx
		lodsw				; String [si] to ax
		mov	word ptr ds:[224h],ax
		mov	word ptr ds:[22Ah],ax
		mov	word ptr ds:[230h],ax
		lodsw				; String [si] to ax
		mov	word ptr ds:[226h],ax
		mov	word ptr ds:[22Ch],ax
		mov	word ptr ds:[232h],ax
		lodsw				; String [si] to ax
		mov	word ptr ds:[228h],ax
		mov	word ptr ds:[22Eh],ax
		mov	word ptr ds:[234h],ax
		inc	data_a_D351
loc_a_3D37:
		mov	al,ds:[bp+6]
		and	al,3
		mov	data_a_D363,al
		mov	bl,ds:[bp+6]
		mov	al,ds:[bp+0Ch]
		rcr	al,1			; Rotate thru carry
		rcr	bl,1			; Rotate thru carry
		rcr	al,1			; Rotate thru carry
		rcr	bl,1			; Rotate thru carry
		mov	ah,data_a_D350
		mov	al,data_a_D34F
loc_a_3D57:
		push	ax
		push	bx
		call	sub_a_3F02
		pop	bx
		pop	ax
		inc	al
		and	al,0Fh
		cmp	al,ah
		jne	loc_a_3D57		; Jump if not equal
		cmp	byte ptr data_a_D351,0
		jne	loc_a_3D6E		; Jump if not equal
		retn
loc_a_3D6E:
		mov	cx,bp
		sub	cx,1D0h
		mov	al,data_a_D364
		add	al,3Ch			; '<'
		and	al,3
		add	al,ds:[bp+12h]
		push	ax
		mov	al,cl
		add	al,7Ch			; '|'
		mov	ds:[bp+18h],al
		sub	al,7Ch			; '|'
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		mov	cx,ax
		shl	ax,1			; Shift w/zeros fill
		add	ax,cx
		shl	ax,1			; Shift w/zeros fill
		mov	di,3C14h
		add	di,ax
		pop	ax
		call	sub_a_3766
		mov	si,bx
		cmp	cl,2
		je	loc_a_3DB1		; Jump if equal
		jmp	loc_a_3E46
loc_a_3DB1:
		mov	bl,data_a_D363
		add	bl,bl
		add	bl,bl
		xor	bh,bh			; Zero register
		add	bx,offset data_a_D352
		mov	ax,[bx]
		mov	data_a_D3A3,ax
		mov	ax,[bx+2]
		mov	data_a_D3A5,ax
		cmp	byte ptr data_a_D363,0
		je	loc_a_3DEE		; Jump if equal
		mov	ax,word ptr ds:[224h]
		mov	data_a_D3A7,ax
		not	ax
		mov	data_a_D3A9,ax
		mov	ax,word ptr ds:[226h]
		mov	data_a_D3AB,ax
		not	ax
		mov	data_a_D3AD,ax
		mov	cx,data_a_D3A3
		call	sub_a_3E24
loc_a_3DEE:
		mov	ax,word ptr ds:[22Ah]
		mov	data_a_D3A7,ax
		not	ax
		mov	data_a_D3A9,ax
		mov	ax,word ptr ds:[22Ch]
		mov	data_a_D3AB,ax
		not	ax
		mov	data_a_D3AD,ax
		mov	cx,8
		call	sub_a_3E24
		mov	ax,word ptr ds:[230h]
		mov	data_a_D3A7,ax
		not	ax
		mov	data_a_D3A9,ax
		mov	ax,word ptr ds:[232h]
		mov	data_a_D3AB,ax
		not	ax
		mov	data_a_D3AD,ax
		mov	cx,data_a_D3A5

;==== External Entry into Subroutine ======================================

sub_a_3E24:

locloop_a_3E24:
		lodsw				; String [si] to ax
		or	ax,data_a_D3A9
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		and	ax,data_a_D3A7
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		or	ax,data_a_D3AD
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		and	ax,data_a_D3AB
		stosw				; Store ax to es:[di]
		mov	ax,0FFFFh
		stosw				; Store ax to es:[di]
		inc	ax
		stosw				; Store ax to es:[di]
		loop	locloop_a_3E24		; Loop if cx > 0

		clc				; Clear carry flag
		retn
loc_a_3E46:
		mov	bl,data_a_D363
		add	bl,bl
		add	bl,bl
		xor	bh,bh			; Zero register
		add	bx,offset data_a_D352
		mov	ax,[bx]
		mov	data_a_D3AF,ax
		mov	ax,[bx+2]
		mov	data_a_D3B1,ax
		cmp	byte ptr data_a_D363,0
		je	loc_a_3E8E		; Jump if equal
		mov	ax,word ptr ds:[224h]
		mov	data_a_D3B3,ax
		not	ax
		mov	data_a_D3B5,ax
		mov	ax,word ptr ds:[226h]
		mov	data_a_D3B7,ax
		not	ax
		mov	data_a_D3B9,ax
		mov	ax,word ptr ds:[228h]
		mov	data_a_D3BB,ax
		not	ax
		mov	data_a_D3BD,ax
		mov	cx,data_a_D3AF
		call	sub_a_3EDA
loc_a_3E8E:
		mov	ax,word ptr ds:[22Ah]
		mov	data_a_D3B3,ax
		not	ax
		mov	data_a_D3B5,ax
		mov	ax,word ptr ds:[22Ch]
		mov	data_a_D3B7,ax
		not	ax
		mov	data_a_D3B9,ax
		mov	ax,word ptr ds:[22Eh]
		mov	data_a_D3BB,ax
		not	ax
		mov	data_a_D3BD,ax
		mov	cx,8
		call	sub_a_3EDA
		mov	ax,word ptr ds:[230h]
		mov	data_a_D3B3,ax
		not	ax
		mov	data_a_D3B5,ax
		mov	ax,word ptr ds:[232h]
		mov	data_a_D3B7,ax
		not	ax
		mov	data_a_D3B9,ax
		mov	ax,word ptr ds:[234h]
		mov	data_a_D3BB,ax
		not	ax
		mov	data_a_D3BD,ax
		mov	cx,data_a_D3B1
sub_a_3C8E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3EDA	proc	near

locloop_a_3EDA:
		lodsw				; String [si] to ax
		or	ax,data_a_D3B5
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		and	ax,data_a_D3B3
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		or	ax,data_a_D3B9
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		and	ax,data_a_D3B7
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		or	ax,data_a_D3BD
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		and	ax,data_a_D3BB
		stosw				; Store ax to es:[di]
		loop	locloop_a_3EDA		; Loop if cx > 0

		clc				; Clear carry flag
		retn
sub_a_3EDA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3F02	proc	near
		mov	cl,al
		mov	bh,al
		add	bx,0A7Eh
		xor	ch,ch			; Zero register
		push	bx
		mov	bx,offset data_a_D280
		add	bx,cx
		mov	al,[bx]
		mov	cx,10h
		add	bx,cx
		mov	cl,al
		mov	al,[bx]
		cmp	al,ds:[bp+1Eh]
		jae	loc_a_3F25		; Jump if above or =
		pop	bx
		retn
loc_a_3F25:
		mov	al,cl
		sub	al,data_a_D362
		add	al,0Bh
		pop	bx
		test	al,80h
		jz	loc_a_3F33		; Jump if zero
		retn
loc_a_3F33:
		cmp	al,16h
		jb	loc_a_3F38		; Jump if below
		retn
loc_a_3F38:
		mov	cl,al
		push	cx
		mov	di,230h
		call	sub_a_3F57
		inc	bx
		pop	cx
		push	cx
		mov	di,22Ah
		call	sub_a_3F57
		inc	bx
		pop	cx
		cmp	byte ptr data_a_D363,0
		jne	loc_a_3F54		; Jump if not equal
		retn
loc_a_3F54:
		mov	di,224h
sub_a_3F02	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3F57	proc	near
		push	bx
		mov	al,[bx]
		test	al,80h
		jz	loc_a_3FA7		; Jump if zero
		mov	ah,al
		and	al,3
		cmp	al,3
		je	loc_a_3FA7		; Jump if equal
		shr	al,1			; Shift w/zeros fill
		jnc	loc_a_3F7A		; Jump if carry=0
		mov	al,ah
		and	al,0Ch
		jz	loc_a_3F75		; Jump if zero
		mov	bx,0D3D5h
		jmp	short loc_a_3F7D
loc_a_3F75:
		mov	bx,0D3BFh
		jmp	short loc_a_3F7D
loc_a_3F7A:
		mov	bx,offset data_a_D3EB
loc_a_3F7D:
		add	bx,cx
		mov	al,[bx]
		test	al,80h
		jnz	loc_a_3FA7		; Jump if not zero
		shl	al,1			; Shift w/zeros fill
		mov	cl,al
		shl	al,1			; Shift w/zeros fill
		add	cl,al
		mov	si,offset data_a_D2A0
		add	si,cx
		mov	ax,[di]
		and	ax,[si]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		and	ax,[si+2]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		and	ax,[si+4]
		stosw				; Store ax to es:[di]
		inc	data_a_D351
loc_a_3FA7:
		pop	bx
		retn
sub_a_3F57	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3FA9	proc	near
		mov	al,ds:[bp+18h]
		cmp	al,0FFh
		jne	loc_a_3FB2		; Jump if not equal
		retn
loc_a_3FB2:
		call	sub_a_3B72
		cmp	byte ptr ds:[bp+30h],7
		jne	loc_a_3FC5		; Jump if not equal
		mov	al,ds:[bp]
		shl	al,1			; Shift w/zeros fill
		mov	byte ptr ds:[174h],al
loc_a_3FC5:
		mov	ax,129Dh
		mov	es,ax
		mov	al,byte ptr ds:[176h]
		cmp	al,18h
		jae	loc_a_3FD2		; Jump if above or =
		retn
loc_a_3FD2:
		cmp	al,0B0h
		jb	loc_a_3FD7		; Jump if below
		retn
loc_a_3FD7:
		mov	bh,al
		mov	bl,byte ptr ds:[174h]
		rcr	bl,1			; Rotate thru carry
		rcr	bl,1			; Rotate thru carry
		rcr	bl,1			; Rotate thru carry
		and	bl,1Fh
		cmp	byte ptr ds:[bp+30h],7
		jne	loc_a_4030		; Jump if not equal
		mov	word ptr ds:[25Eh],bx
		mov	al,byte ptr ds:[176h]
		cmp	al,20h			; ' '
		jae	loc_a_3FF9		; Jump if above or =
		retn
loc_a_3FF9:
		cmp	al,0A8h
		jb	loc_a_3FFE		; Jump if below
		retn
loc_a_3FFE:
		mov	al,byte ptr ds:[174h]
		shr	al,1			; Shift w/zeros fill
		and	al,3
		mov	byte ptr ds:[260h],al
		mov	byte ptr ds:[25Dh],1
		mov	ax,129Dh
		mov	es,ax
		push	bx
		call	sub_a_4030
		call	sub_a_3AAE
		pop	bx
		mov	ax,0B800h
		mov	es,ax
		mov	ax,bx
		add	al,2
		shl	al,1			; Shift w/zeros fill
		sub	ah,1
		call	sub_a_455B
		add	ax,4
		jmp	short loc_a_403D

;==== External Entry into Subroutine ======================================

sub_a_4030:
loc_a_4030:
		mov	ax,bx
		shl	al,1			; Shift w/zeros fill
		sub	ah,8
		call	sub_a_4571
		sub	ax,0Eh
loc_a_403D:
		mov	bx,ax
		push	bx
		mov	al,ds:[bp+18h]
		cmp	al,7Ch			; '|'
		jb	loc_a_4069		; Jump if below
		sub	al,7Ch			; '|'
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		mov	cx,ax
		shl	ax,1			; Shift w/zeros fill
		add	ax,cx
		add	ax,ax
		mov	bx,3C14h
		add	bx,ax
		mov	dl,3
		mov	dh,10h
		jmp	short loc_a_4083
loc_a_4069:
		mov	cl,al
		mov	al,byte ptr ds:[174h]
		shr	al,1			; Shift w/zeros fill
		and	al,3
		add	al,cl
		push	ax
		call	sub_a_3766
		mov	dl,cl
		pop	ax
		mov	dh,10h
		cmp	al,4Eh			; 'N'
		jae	loc_a_4083		; Jump if above or =
		mov	dh,8
loc_a_4083:
		pop	di
		mov	si,bx
		mov	bx,4
		mov	cl,dh
		xor	ch,ch			; Zero register
		dec	dl
		jz	locloop_a_4097		; Jump if zero
		dec	dl
		jz	locloop_a_40B3		; Jump if zero
		jmp	short locloop_a_40DA

locloop_a_4097:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		mov	es:[di],ax
		add	si,bx
		mov	ax,2000h
		test	di,ax
		jz	loc_a_40AE		; Jump if zero
		mov	ax,0E050h
loc_a_40AE:
		add	di,ax
		loop	locloop_a_4097		; Loop if cx > 0

		retn

locloop_a_40B3:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,bx
		mov	ax,2000h
		test	di,ax
		jz	loc_a_40D5		; Jump if zero
		mov	ax,0E050h
loc_a_40D5:
		add	di,ax
		loop	locloop_a_40B3		; Loop if cx > 0

		retn

locloop_a_40DA:
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		mov	ax,es:[di]
		and	ax,[si]
		or	ax,[si+2]
		stosw				; Store ax to es:[di]
		add	si,bx
		sub	di,6
		mov	ax,2000h
		test	di,ax
		jz	loc_a_4108		; Jump if zero
		mov	ax,0E050h

;==== External Entry into Subroutine ======================================

sub_a_4108:
loc_a_4108:
		add	di,ax
		loop	locloop_a_40DA		; Loop if cx > 0

		retn
sub_a_3FA9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_410D	proc	near
		mov	bp,d_04E9_01D0_e
		mov	al,0
		mov	cx,4

locloop_a_4115:
		mov	ds:[bp+30h],al
		inc	bp
		loop	locloop_a_4115		; Loop if cx > 0

		retn
sub_a_410D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_411D	proc	near
		mov	ax,4E9h
		mov	es,ax
		mov	bx,word ptr ds:[251h]
		sub	bl,8
		sbb	bh,0
		and	bh,3
		cmp	bh,3
		jne	loc_a_413B		; Jump if not equal
		cmp	bl,0D0h
		jb	loc_a_413B		; Jump if below
		xor	bx,bx			; Zero register
loc_a_413B:
		mov	word ptr ds:[1CCh],bx
		mov	bx,word ptr ds:[251h]
		add	bl,4Dh			; 'M'
		adc	bh,0
		and	bh,3
		mov	word ptr ds:[1CEh],bx
		call	sub_a_3BB2
		mov	bp,1D0h
		xor	cx,cx			; Zero register
		mov	al,ds:[bp+1Eh]
		cmp	al,ds:[bp+1Fh]
		rcl	cl,1			; Rotate thru carry
		cmp	al,ds:[bp+20h]
		rcl	cl,1			; Rotate thru carry
		cmp	al,ds:[bp+21h]
		rcl	cl,1			; Rotate thru carry
		mov	al,ds:[bp+1Fh]
		cmp	al,ds:[bp+20h]
		rcl	cl,1			; Rotate thru carry
		cmp	al,ds:[bp+21h]
		rcl	cl,1			; Rotate thru carry
		mov	al,ds:[bp+20h]
		cmp	al,ds:[bp+21h]
		rcl	cl,1			; Rotate thru carry
		xor	cl,3Fh			; '?'
		mov	bx,offset data_a_D401
		add	bx,cx
		mov	cl,[bx]
		mov	al,cl
		and	al,3
		mov	ds:[bp+27h],al
		rcr	cl,1			; Rotate thru carry
		rcr	cl,1			; Rotate thru carry
		mov	al,cl
		and	al,3
		mov	ds:[bp+26h],al
		rcr	cl,1			; Rotate thru carry
		rcr	cl,1			; Rotate thru carry
		mov	al,cl
		and	al,3
		mov	ds:[bp+25h],al
		rcr	cl,1			; Rotate thru carry
		rcr	cl,1			; Rotate thru carry
		and	cl,3
		mov	ds:[bp+24h],cl
		retn
sub_a_411D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_41BE	proc	near
		mov	cl,3
loc_a_41C0:
		mov	bp,1D0h
		mov	ch,4
		mov	al,cl
loc_a_41C7:
		cmp	al,ds:[bp+24h]
		je	loc_a_41DB		; Jump if equal
		inc	bp
		dec	ch
		jnz	loc_a_41C7		; Jump if not zero
loc_a_41D2:
		dec	cl
		test	cl,80h
		jz	loc_a_41C0		; Jump if zero
		jmp	short loc_a_41E2
loc_a_41DB:
		push	cx
		call	sub_a_3FA9
		pop	cx
		jmp	short loc_a_41D2
loc_a_41E2:
		mov	bp,1D4h
		cmp	byte ptr ds:[bp+2Ah],0FFh
		jne	loc_a_41ED		; Jump if not equal
		retn
loc_a_41ED:
		mov	al,ds:[bp+12h]
		add	al,4Ah			; 'J'
		mov	ds:[bp+18h],al
		call	sub_a_3FA9
		mov	al,byte ptr ds:[174h]
		mov	byte ptr ds:[173h],al
		retn
sub_a_41BE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4201	proc	near
		mov	bp,1D0h
		mov	cx,4
loc_a_4207:
		push	cx
		mov	al,ds:[bp+30h]
		cmp	al,0
		jne	loc_a_4213		; Jump if not equal
		jmp	loc_a_44B9
loc_a_4213:
		cmp	al,7
		jne	loc_a_425E		; Jump if not equal
		mov	byte ptr ds:[bp+12h],4Eh	; 'N'
		mov	al,ds:[bp]
		add	al,ds:[bp+36h]
		mov	ds:[bp],al
		test	byte ptr ds:d_04E9_0219_e,80h
		jnz	loc_a_4240		; Jump if not zero
		cmp	al,3Ch			; '<'
		je	loc_a_4239		; Jump if equal
		cmp	al,78h			; 'x'
		jne	loc_a_425B		; Jump if not equal
		jmp	short loc_a_4251
loc_a_4239:
		mov	byte ptr ds:[bp+36h],2
		jmp	short loc_a_425B
loc_a_4240:
		cmp	al,3Ch			; '<'
		je	loc_a_424A		; Jump if equal
		or	al,al			; Zero ?
		jnz	loc_a_425B		; Jump if not zero
		jmp	short loc_a_4251
loc_a_424A:
		mov	byte ptr ds:[bp+36h],0FEh
		jmp	short loc_a_425B
loc_a_4251:
		mov	byte ptr ds:[bp+30h],0
		mov	byte ptr ds:d_04E9_0218_e,7Dh	; '}'
loc_a_425B:
		jmp	loc_a_44B9
loc_a_425E:
		cmp	al,4
		jne	loc_a_4264		; Jump if not equal
		jmp	short loc_a_4292
loc_a_4264:
		cmp	al,6
		jne	loc_a_426A		; Jump if not equal
		jmp	short loc_a_4292
loc_a_426A:
		cmp	al,5
		je	loc_a_4270		; Jump if equal
		jmp	short loc_a_4283
loc_a_4270:
		dec	byte ptr ds:[bp+2Ah]
		test	byte ptr ds:[bp+2Ah],80h
		jz	loc_a_4280		; Jump if zero
		mov	byte ptr ds:[bp+30h],2
loc_a_4280:
		jmp	loc_a_44B9
loc_a_4283:
		call	sub_a_34B2
		jnc	loc_a_4292		; Jump if carry=0
		mov	byte ptr ds:[bp+30h],4
		mov	byte ptr ds:[bp+2Ah],0
loc_a_4292:
		mov	al,ds:[bp+30h]
		cmp	al,4
		je	loc_a_42C4		; Jump if equal
		cmp	al,6
		jne	loc_a_42EB		; Jump if not equal
		mov	al,ds:[bp+2Ah]
		cmp	al,6
		je	loc_a_42AC		; Jump if equal
		neg	al
		add	al,5
		jmp	short loc_a_42D4
loc_a_42AC:
		mov	al,ds:[bp+42h]
		mov	ds:[bp+30h],al
		mov	al,ds:[bp+3Ch]
		mov	ds:[bp+2Ah],al
		mov	byte ptr ds:[bp+12h],52h	; 'R'
		jmp	loc_a_44B9
loc_a_42C4:
		mov	al,ds:[bp+2Ah]
		cmp	al,6
		jne	loc_a_42D4		; Jump if not equal
		mov	byte ptr ds:[bp+30h],0
		jmp	loc_a_44B9
loc_a_42D4:
		cmp	al,3
		jb	loc_a_42DA		; Jump if below
		sub	al,3
loc_a_42DA:
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	al,5Ah			; 'Z'
		mov	ds:[bp+12h],al
		inc	byte ptr ds:[bp+2Ah]
		jmp	loc_a_44B9
loc_a_42EB:
		cmp	al,3
		jne	loc_a_42F2		; Jump if not equal
		jmp	loc_a_4383
loc_a_42F2:
		cmp	al,8
		jne	loc_a_4357		; Jump if not equal
		mov	bl,ds:[bp+6]
		mov	bh,ds:[bp+0Ch]
		mov	ds:d_04E9_01A9_e,bx
		mov	cl,ds:[bp+36h]
		test	cl,80h
		mov	ch,0
		jz	loc_a_430F		; Jump if zero
		dec	ch
loc_a_430F:
		add	bx,cx
		test	bh,80h
		jz	loc_a_4319		; Jump if zero
		jmp	loc_a_44A6
loc_a_4319:
		mov	ds:[bp+6],bl
		mov	al,bh
		and	al,3
		mov	ds:[bp+0Ch],al
		call	sub_a_34B2
		jc	loc_a_432F		; Jump if carry Set
		call	sub_a_08C0
		jnc	loc_a_4345		; Jump if carry=0
loc_a_432F:
		mov	bx,ds:d_04E9_01A9_e
		mov	ds:[bp+6],bl
		mov	ds:[bp+0Ch],bh
		xor	al,al			; Zero register
		sub	al,ds:[bp+36h]
		mov	ds:[bp+36h],al
loc_a_4345:
		mov	al,byte ptr ds:[1AEh]
		and	al,3
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	al,66h			; 'f'
		mov	ds:[bp+12h],al
		jmp	loc_a_44B9
loc_a_4357:
		mov	al,ds:[bp]
		mov	byte ptr ds:[1A8h],al
		add	al,ds:[bp+36h]
		and	al,7Fh
		mov	ds:[bp],al
		call	sub_a_34B2
		jc	loc_a_4372		; Jump if carry Set
		call	sub_a_08C0
		jnc	loc_a_4383		; Jump if carry=0
loc_a_4372:
		mov	al,byte ptr ds:[1A8h]
		mov	ds:[bp],al
		xor	al,al			; Zero register
		sub	al,ds:[bp+36h]
		mov	ds:[bp+36h],al
loc_a_4383:
		mov	al,ds:[bp+30h]
		cmp	al,2
		jne	loc_a_438E		; Jump if not equal
		jmp	loc_a_447B
loc_a_438E:
		cmp	al,9
		jne	loc_a_4394		; Jump if not equal
		jmp	short loc_a_4345
loc_a_4394:
		mov	cl,ds:[bp+2Ah]
		xor	ch,ch			; Zero register
		mov	bx,offset data_a_D441
		add	bx,cx
		mov	al,[bx]
		or	al,al			; Zero ?
		jnz	loc_a_43A8		; Jump if not zero
		jmp	loc_a_4469
loc_a_43A8:
		mov	data_a_D44C,al
		mov	cl,al
		add	al,al
		sbb	al,al
		mov	ch,al
		mov	bl,ds:[bp+6]
		mov	bh,ds:[bp+0Ch]
		mov	word ptr ds:[1A9h],bx
		add	bx,cx
		test	bh,80h
		jz	loc_a_43C9		; Jump if zero
		jmp	loc_a_44A6
loc_a_43C9:
		mov	ds:[bp+6],bl
		mov	al,bh
		and	al,3
		mov	ds:[bp+0Ch],al
		call	sub_a_34B2
		jc	loc_a_43E2		; Jump if carry Set
		call	sub_a_08C0
		jc	loc_a_43E2		; Jump if carry Set
		jmp	loc_a_4469
loc_a_43E2:
		mov	bx,word ptr ds:[1A9h]
		mov	ds:[bp+6],bl
		mov	ds:[bp+0Ch],bh
		mov	al,data_a_D44C
		test	al,80h
		jnz	loc_a_43FB		; Jump if not zero
		dec	al
		jnz	loc_a_43A8		; Jump if not zero
		jmp	short loc_a_4469
loc_a_43FB:
		inc	al
		jnz	loc_a_43A8		; Jump if not zero
		mov	al,ds:[bp+30h]
		cmp	al,3
		jne	loc_a_4414		; Jump if not equal
		mov	byte ptr ds:[bp+30h],2
		mov	byte ptr ds:[bp+2Ah],0
		jmp	loc_a_44B9
loc_a_4414:
		cmp	byte ptr ds:[bp+36h],0
		jne	loc_a_445D		; Jump if not equal
		cmp	byte ptr ds:[190h],0
		je	loc_a_445D		; Jump if equal
		cmp	byte ptr ds:[18Eh],0
		jne	loc_a_445D		; Jump if not equal
		mov	al,byte ptr ds:[188h]
		cmp	al,ds:[bp+6]
		jne	loc_a_445D		; Jump if not equal
		mov	al,byte ptr ds:[189h]
		cmp	al,ds:[bp+0Ch]
		jne	loc_a_445D		; Jump if not equal
		mov	ch,0FFh
		mov	al,ds:[bp]
		sub	al,byte ptr ds:[187h]
		and	al,7Fh
		cmp	al,40h			; '@'
		jb	loc_a_444D		; Jump if below
		or	al,80h
loc_a_444D:
		cmp	al,80h
		jb	loc_a_4455		; Jump if below
		neg	al
		mov	ch,1
loc_a_4455:
		cmp	al,20h			; ' '
		jae	loc_a_445D		; Jump if above or =
		mov	ds:[bp+36h],ch
loc_a_445D:
		mov	byte ptr ds:[bp+2Ah],0
		mov	al,1
		call	sub_a_1153
		jmp	short loc_a_44B9
loc_a_4469:
		mov	al,ds:[bp+2Ah]
		inc	al
		cmp	al,0Ah
		jb	loc_a_4475		; Jump if below
		mov	al,0Ah
loc_a_4475:
		mov	ds:[bp+2Ah],al
		jmp	short loc_a_44B9
loc_a_447B:
		mov	al,56h			; 'V'
		mov	ds:[bp+12h],al
		call	sub_a_44C2
		or	al,al			; Zero ?
		jnz	loc_a_448A		; Jump if not zero
		jmp	short loc_a_44B9
loc_a_448A:
		cmp	al,1
		je	loc_a_449A		; Jump if equal
		xor	al,al			; Zero register
		sub	al,ds:[bp+36h]
		mov	ds:[bp+36h],al
		jmp	short loc_a_44B9
loc_a_449A:
		mov	byte ptr ds:[bp+30h],3
		mov	byte ptr ds:[bp+2Ah],0Ah
		jmp	short loc_a_44B9
loc_a_44A6:
		xor	al,al			; Zero register
		mov	ds:[bp+6],al
		mov	ds:[bp+0Ch],al
		mov	ds:[bp+2Ah],al
		mov	byte ptr ds:[bp+30h],4
loc_a_44B9:
		inc	bp
		pop	cx
		dec	cx
		jz	loc_ret_a_44C1		; Jump if zero
		jmp	loc_a_4207

loc_ret_a_44C1:
		retn
sub_a_4201	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_44C2	proc	near
		mov	al,ds:[bp]
		rcr	al,1			; Rotate thru carry
		rcr	al,1			; Rotate thru carry
		rcr	al,1			; Rotate thru carry
		and	al,0Fh
		mov	bh,al
		mov	bl,ds:[bp+6]
		mov	al,ds:[bp+0Ch]
		rcr	al,1			; Rotate thru carry
		rcr	bl,1			; Rotate thru carry
		rcr	al,1			; Rotate thru carry
		rcr	bl,1			; Rotate thru carry
		dec	bl
		add	bx,0A7Eh
		mov	al,[bx]
		test	al,80h
		jz	loc_a_44FE		; Jump if zero
		and	al,3
		cmp	al,1
		jne	loc_a_44FA		; Jump if not equal
		mov	al,[bx]
		and	al,0Ch
		jz	loc_a_4558		; Jump if zero
		jmp	short loc_a_4555
loc_a_44FA:
		cmp	al,3
		jne	loc_a_4558		; Jump if not equal
loc_a_44FE:
		mov	al,ds:[bp]
		and	al,7
		cmp	al,2
		jb	loc_a_450E		; Jump if below
		cmp	al,7
		jb	loc_a_4552		; Jump if below
		jmp	short loc_a_4530
loc_a_450E:
		sub	bx,0A7Eh
		dec	bh
		and	bh,0Fh
		add	bx,0A7Eh
		mov	al,[bx]
		test	al,80h
		jz	loc_a_4552		; Jump if zero
		and	al,3
		cmp	al,3
		je	loc_a_4552		; Jump if equal
		test	byte ptr ds:[bp+36h],80h
		jz	loc_a_4555		; Jump if zero
		jmp	short loc_a_4558
loc_a_4530:
		sub	bx,0A7Eh
		inc	bh
		and	bh,0Fh
		add	bx,0A7Eh
		mov	al,[bx]
		test	al,80h
		jz	loc_a_4552		; Jump if zero
		and	al,3
		cmp	al,3
		je	loc_a_4552		; Jump if equal
		test	byte ptr ds:[bp+36h],80h
		jnz	loc_a_4555		; Jump if not zero
		jmp	short loc_a_4558
loc_a_4552:
		mov	al,1
		retn
loc_a_4555:
		mov	al,2
		retn
loc_a_4558:
		xor	al,al			; Zero register
		retn
sub_a_44C2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_455B	proc	near
		push	bx
		mov	byte ptr data_a_D5DD,al
		mov	bl,ah
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		add	bx,offset data_a_D44D
		mov	ax,[bx]
		add	ax,data_a_D5DD
		pop	bx
		retn
sub_a_455B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4571	proc	near
		push	bx
		mov	bl,ds:d_04E9_0242_e
		not	bl
		and	bl,7
		add	ah,bl
		mov	ds:d_04E9_D5DD_e,al
		mov	bl,ah
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		add	bx,d_04E9_D44D_e
		mov	ax,[bx]
		add	ax,ds:d_04E9_D5DD_e
		add	ax,16h
		pop	bx
		retn
sub_a_4571	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4595	proc	near
		mov	ax,0B800h
		mov	es,ax

locloop_a_459A:
		push	cx
		mov	cx,dx
		push	cx
		push	di
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		pop	cx
		push	di
		add	di,d_B800_2000_e
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		add	di,50h
		pop	cx
		loop	locloop_a_459A		; Loop if cx > 0

		retn
sub_a_4595	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45B2	proc	near
		retn
sub_a_45B2	endp

			                        ;* No entry point to code
		mov	bp,d_04E9_D5DF_e
		call	sub_a_45FC
		mov	dx,ds:d_04E9_D045_e
		call	sub_a_4BCD
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45C1	proc	near
		mov	cx,1Ah
		mov	dx,10h
		mov	di,d_04E9_0517_e
		mov	si,d_04E9_3F14_e
		call	sub_a_4595
		mov	bp,d_04E9_D5E5_e
		call	sub_a_45FC
		retn
sub_a_45C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45D7	proc	near
		not	byte ptr ds:d_04E9_D5ED_e
		push	ds
		push	es
		mov	ax,169Dh
		mov	ds,ax
		mov	es,ax
		mov	si,d_169D_436A_e
		mov	di,d_169D_2D6A_e
		mov	cx,58D9h
		sub	cx,si

locloop_a_45EF:
		mov	al,[si]
		xchg	[di],al
		mov	[si],al
		inc	si
		inc	di
		loop	locloop_a_45EF		; Loop if cx > 0

		pop	es
		pop	ds
		retn
sub_a_45D7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45FC	proc	near
loc_a_45FC:
		mov	al,ds:[bp]
		or	al,al			; Zero ?
		jnz	loc_a_4605		; Jump if not zero
		retn
loc_a_4605:
		call	sub_a_460B
		inc	bp
		jmp	short loc_a_45FC
sub_a_45FC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_460B	proc	near
loc_a_460B:
		mov	bx,4E9h
		mov	es,bx
		cmp	byte ptr ds:d_04E9_D717_e,0
		jne	loc_a_461A		; Jump if not equal
		jmp	loc_a_4B1B
loc_a_461A:
		cmp	al,10h
		jne	loc_a_4621		; Jump if not equal
		jmp	loc_a_48DE
loc_a_4621:
		cmp	al,11h
		jne	loc_a_4628		; Jump if not equal
		jmp	loc_a_48C3
loc_a_4628:
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,0D75Ah
		mov	si,ax
		mov	di,d_04E9_D5F6_e
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,d_04E9_D7A6_e
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,ds:d_04E9_D5EE_e
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,ds:d_04E9_D5EF_e
		or	al,ah
		stosb				; Store al to es:[di]
		mov	ax,0B800h
		mov	es,ax
		mov	si,d_04E9_D5F6_e
		xor	ax,ax			; Zero register
		mov	al,ds:d_04E9_D5F0_e
		add	ax,ds:d_04E9_D5F1_e
		mov	di,ax
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		add	byte ptr ds:d_04E9_D5F0_e,2
		cmp	byte ptr ds:d_04E9_D5F0_e,50h	; 'P'
		jb	loc_ret_a_48C2		; Jump if below
		mov	byte ptr ds:d_04E9_D5F0_e,0
		add	word ptr ds:d_04E9_D5F1_e,140h

loc_ret_a_48C2:
		retn
loc_a_48C3:
		mov	al,ds:[bp+1]
		mov	cx,140h
		xor	ah,ah			; Zero register
		mul	cx			; dx:ax = reg * ax
		mov	data_a_D5F1,ax
		mov	al,ds:[bp+2]
		add	al,al
		mov	data_a_D5F0,al
		add	bp,2
		retn
loc_a_48DE:
		inc	bp
		mov	al,ds:[bp]
		push	ax
		call	sub_a_48F6
		mov	data_a_D5EE,al
		pop	ax
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		call	sub_a_48F6
		mov	data_a_D5EF,al
		retn
sub_a_460B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_48F6	proc	near
		and	al,3
		mov	bx,offset data_a_D7B6
		xlat				; al=[al+[bx]] table
		retn
sub_a_48F6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_48FD	proc	near
loc_a_48FD:
		mov	al,ds:[bp]
		or	al,al			; Zero ?
		jnz	loc_a_4906		; Jump if not zero
		retn
loc_a_4906:
		call	sub_a_490C
		inc	bp
		jmp	short loc_a_48FD
sub_a_48FD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_490C	proc	near
		push	ax
		mov	ax,4E9h
		mov	es,ax
		pop	ax
		cmp	al,10h
		jne	loc_a_4919		; Jump if not equal
		jmp	short loc_a_48DE
loc_a_4919:
		cmp	al,11h
		jne	loc_a_491F		; Jump if not equal
		jmp	short loc_a_48C3
loc_a_491F:
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,0D75Ah
		mov	si,ax
		mov	di,d_04E9_D5F6_e
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		or	al,[si]
		inc	si
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	si,offset data_a_D5F6
		mov	di,offset data_a_D807
		call	sub_a_4AB4
		mov	si,offset data_a_D5F7
		mov	di,offset data_a_D809
		call	sub_a_4AB4
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_a_D807
		xor	ax,ax			; Zero register
		mov	al,data_a_D5F0
		add	ax,data_a_D5F1
		mov	di,ax
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFC_e
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		sub	di,1FB4h
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFC_e
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		sub	di,1FB4h
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFC_e
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		sub	di,1FB4h
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFC_e
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		sub	di,1FB4h
		add	byte ptr data_a_D5F0,4
		cmp	byte ptr data_a_D5F0,50h	; 'P'
		jb	loc_ret_a_4AB3		; Jump if below
		mov	byte ptr data_a_D5F0,0
		add	data_a_D5F1,140h

loc_ret_a_4AB3:
		retn
sub_a_490C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4AB4	proc	near
		mov	cx,8

locloop_a_4AB7:
		push	cx
		mov	al,[si]
		and	al,0F0h
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,data_a_D5EE
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,data_a_D5EF
		or	al,ah
		stosb				; Store al to es:[di]
		mov	al,[si]
		add	si,2
		and	al,0Fh
		mov	bx,offset data_a_D7A6
		xlat				; al=[al+[bx]] table
		mov	[di],al
		and	al,data_a_D5EE
		mov	ah,al
		mov	al,[di]
		xor	al,0FFh
		and	al,data_a_D5EF
		or	al,ah
		stosb				; Store al to es:[di]
		add	di,2
		pop	cx
		loop	locloop_a_4AB7		; Loop if cx > 0

		retn
sub_a_4AB4	endp

			                        ;* No entry point to code
		mov	al,ds:[bp+1]
		mov	cx,140h
		xor	ah,ah			; Zero register
		mul	cx			; dx:ax = reg * ax
		mov	data_a_D5F1,ax
		mov	al,ds:[bp+2]
		add	al,al
		mov	data_a_D5F0,al
		add	bp,2
		retn
loc_a_4B1B:
		cmp	al,10h
		jne	loc_a_4B21		; Jump if not equal
		jmp	short loc_a_4B61
loc_a_4B21:
		cmp	al,11h
		jne	loc_a_4B27		; Jump if not equal
		jmp	short loc_a_4B42
loc_a_4B27:
		push	ax
		mov	ax,0B800h
		mov	es,ax
		pop	ax
		mov	di,data_a_D5F1
		mov	es:[di],al
		mov	al,data_a_D5EE
		mov	es:[di+1],al
		add	data_a_D5F1,2
		retn
loc_a_4B42:
		mov	al,ds:[bp+1]
		mov	cx,50h
		xor	ah,ah			; Zero register
		mul	cx			; dx:ax = reg * ax
		mov	bx,ax
		mov	al,ds:[bp+2]
		add	al,al
		xor	ah,ah			; Zero register
		add	bx,ax
		mov	data_a_D5F1,bx
		add	bp,2
		retn
loc_a_4B61:
		inc	bp
		mov	al,ds:[bp]
		mov	data_a_D5EE,al
		retn
			                        ;* No entry point to code
		mov	byte ptr data_a_D717,1
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ah,0Bh
		mov	bh,1
		mov	bl,1
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4B7D	proc	near
loc_a_4B7D:
		mov	dx,3D9h
		out	dx,al			; port 3D9h, CGA color control
		retn
sub_a_4B7D	endp

			                        ;* No entry point to code
		mov	ah,0
		mov	al,1
		mov	byte ptr data_a_D717,0
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ah,1
		mov	cx,1F1Fh
		int	10h			; Video display   ah=functn 01h
						;  set cursor mode in cx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4B95	proc	near
		mov	byte ptr data_a_D717,0
		xor	ah,ah			; Zero register
		mov	al,2
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retn
sub_a_4B95	endp

		db	0B9h, 10h, 27h

locloop_a_4BA4:
		nop
		loop	locloop_a_4BA4		; Loop if cx > 0

		retn
			                        ;* No entry point to code
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		retn
			                        ;* No entry point to code
		mov	al,28h			; '('
		mov	cx,88B8h
		call	sub_a_4BBA
		mov	al,3Ch			; '<'
		mov	cx,0EA60h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4BBA	proc	near
loc_a_4BBA:
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		out	42h,al			; port 42h, 8253 timer 2 spkr

locloop_a_4BC4:
		loop	locloop_a_4BC4		; Loop if cx > 0

		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_a_4BBA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4BCD	proc	near
		xor	bl,bl			; Zero register
		mov	cx,0D8F0h
		call	sub_a_4BEA
		mov	cx,0FC18h
		call	sub_a_4BEA
		mov	cx,0FF9Ch
		call	sub_a_4BEA
		mov	cl,0F6h
		call	sub_a_4BEA
		mov	al,dl
		jmp	short loc_a_4BFE

;==== External Entry into Subroutine ======================================

sub_a_4BEA:
		xor	al,al			; Zero register
loc_a_4BEC:
		add	dx,cx
		inc	al
		jc	loc_a_4BEC		; Jump if carry Set
		sub	dx,cx
		dec	al
		jnz	loc_a_4BFE		; Jump if not zero
		or	bl,bl			; Zero ?
		jz	loc_ret_a_4C0B		; Jump if zero
		xor	al,al			; Zero register
loc_a_4BFE:
		inc	bl
		add	al,30h			; '0'
		push	dx
		push	cx
		push	bx
		call	sub_a_460B
		pop	bx
		pop	cx
		pop	dx

loc_ret_a_4C0B:
		retn
sub_a_4BCD	endp

			                        ;* No entry point to code
		push	bx
		push	ax
		shr	data_a_D616,1		; Shift w/zeros fill
		mov	al,data_a_D615
		mov	bl,al
		shr	al,1			; Shift w/zeros fill
		mov	data_a_D616,al
		mov	al,data_a_D614
		mov	bh,al
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		mov	data_a_D615,al
		mov	al,data_a_D613
		mov	data_a_D614,al
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		and	al,0Fh
		or	al,data_a_D615
		mov	data_a_D615,bh
		xor	al,data_a_D616
		mov	data_a_D616,bl
		mov	bl,al
		mov	al,data_a_D612
		mov	data_a_D612,bl
		mov	data_a_D613,al
		pop	ax
		pop	bx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4C5B	proc	near
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		mov	di,d_B800_0000_e
		mov	ax,0
		mov	cx,2000h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xor	ax,ax			; Zero register
		mov	data_a_D5F0,al
		mov	data_a_D5F1,ax
		retn
sub_a_4C5B	endp

loc_a_4C75:
		call	sub_a_1E1A	; Restore INT 09h handler
		call	sub_a_4B95
		mov	ax,4C00h
		int	21h			; DOS Services  ah=function 4Ch
						;  terminate with al=return code
			                        ;* No entry point to code
		push	es
		push	cx
		mov	ax,4E9h
		mov	es,ax
		cld				; Clear direction
		mov	di,0D617h
		pop	cx

locloop_a_4C8C:
		lodsw				; String [si] to ax
		mov	bx,ax
		lodsw				; String [si] to ax
		mov	dx,ax
		push	cx
		mov	cx,2

locloop_a_4C96:
		push	cx
		call	sub_a_4CA3
		stosw				; Store ax to es:[di]
		pop	cx
		loop	locloop_a_4C96		; Loop if cx > 0

		pop	cx
		loop	locloop_a_4C8C		; Loop if cx > 0

		pop	es
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4CA3	proc	near
		mov	cx,8

locloop_a_4CA6:
		shl	dx,1			; Shift w/zeros fill
		rcl	ax,1			; Rotate thru carry
		shl	bx,1			; Shift w/zeros fill
		rcl	ax,1			; Rotate thru carry
		loop	locloop_a_4CA6		; Loop if cx > 0

		xchg	ah,al
		retn
sub_a_4CA3	endp

		db	0B9h, 08h, 00h

locloop_a_4CB6:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,1FFCh
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		sub	di,1FB4h
		loop	locloop_a_4CB6		; Loop if cx > 0

		retn
		db	0B9h, 10h, 00h

locloop_a_4CC8:
		push	di
		push	di
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		pop	di
		add	di,2000h
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		pop	di
		add	di,50h
		loop	locloop_a_4CC8		; Loop if cx > 0

		retn
			                        ;* No entry point to code
		add	byte ptr data_a_D5F3,4
		cmp	byte ptr data_a_D5F3,50h	; 'P'
		jb	loc_ret_a_4CF5		; Jump if below
		xor	al,al			; Zero register
		mov	data_a_D5F3,al
		add	data_a_D5F4,280h

loc_ret_a_4CF5:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4CF6	proc	near
		mov	dx,3DAh
		in	al,dx			; port 3DAh, CGA/EGA vid status
		and	al,8
		nop
		nop
		mov	dx,3DAh
		in	al,dx			; port 3DAh, CGA/EGA vid status
		and	al,8
		nop
		nop
		retn
sub_a_4CF6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4D07	proc	near
		call	sub_a_1E1A		; Restore INT 09h handler
		call	sub_a_4DCD
		call	sub_a_4E16
		jmp	loc_a_4DB4

;==== External Entry into Subroutine ======================================

sub_a_4D13:
		mov	word ptr ds:d_04E9_D7A2_e,0D827h
		mov	ax,4E9h
		mov	ds:d_04E9_D79C_e,ax
		mov	word ptr ds:d_04E9_D7A0_e,1Eh
		mov	word ptr ds:d_04E9_D79E_e,0D029h
		jmp	short loc_a_4DAB

;==== External Entry into Subroutine ======================================

sub_a_4D2D:
		mov	word ptr ds:d_04E9_D7A2_e,0D827h
		mov	ax,4E9h
		mov	ds:d_04E9_D79C_e,ax
		mov	word ptr ds:d_04E9_D7A0_e,1Eh
		mov	word ptr ds:d_04E9_D79E_e,0D029h
		call	sub_a_1E1A		; Restore INT 09h handler
		call	sub_a_4D50
		call	sub_a_4E16
		jmp	short loc_a_4DB4

;==== External Entry into Subroutine ======================================

sub_a_4D50:
		mov	dx,ds:d_04E9_D7A2_e
		xor	al,al			; Zero register
		mov	ah,3Dh
		int	21h			; DOS Services  ah=function 3Dh
						;  open file, al=mode,name@ds:dx
		jc	loc_a_4D60		; Jump if carry Set
		mov	ds:d_04E9_D7A4_e,ax
		retn
loc_a_4D60:
		pop	ax
		mov	ax,4E9h
		mov	es,ax
		mov	di,d_04E9_D029_e
		xor	al,al			; Zero register
		mov	cx,4
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	al,2Eh			; '.'
		mov	cx,3
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		xor	al,al			; Zero register
		mov	cx,4
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	al,2Eh			; '.'
		mov	cx,3
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		xor	al,al			; Zero register
		mov	cx,4
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	al,2Eh			; '.'
		mov	cx,3
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		xor	al,al			; Zero register
		mov	cx,4
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	al,2Eh			; '.'
		mov	cx,3
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	word ptr ds:d_04E9_D045_e,1
		call	sub_a_1DF9		; Install INT 09h handler
		retn
loc_a_4DAB:
		call	sub_a_1E1A		; Restore INT 09h handler
		call	sub_a_4DBB
		call	sub_a_4DDD
loc_a_4DB4:
		call	sub_a_4E2F
		call	sub_a_1DF9		; Install INT 09h handler
		retn
sub_a_4D07	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4DBB	proc	near
		mov	dx,data_a_D7A2
		xor	cx,cx			; Zero register
		mov	al,2
		mov	ah,3Ch
		int	21h			; DOS Services  ah=function 3Ch
						;  create/truncate file @ ds:dx
		jc	loc_a_4DF7		; Jump if carry Set
		mov	data_a_D7A4,ax
		retn

;==== External Entry into Subroutine ======================================

sub_a_4DCD:
		mov	dx,ds:d_04E9_D7A2_e
		xor	al,al			; Zero register
		mov	ah,3Dh
		int	21h			; DOS Services  ah=function 3Dh
						;  open file, al=mode,name@ds:dx
		jc	loc_a_4DF7		; Jump if carry Set
		mov	ds:d_04E9_D7A4_e,ax
		retn

;==== External Entry into Subroutine ======================================

sub_a_4DDD:
		mov	ax,data_a_D79C
		mov	bx,data_a_D7A4
		mov	cx,data_a_D7A0
		mov	dx,data_a_D79E
		push	ds
		mov	ds,ax
		mov	ah,40h
		int	21h			; DOS Services  ah=function 40h
						;  write file  bx=file handle
						;   cx=bytes from ds:dx buffer
		pop	ds
		jc	loc_a_4DF7		; Jump if carry Set
		retn
loc_a_4DF7:
		pop	ax
		call	sub_a_1DF9		; Install INT 09h handler
		retn
sub_a_4DBB	endp

			                        ;* No entry point to code
		call	sub_a_4C5B
		call	sub_a_1E1A		; Restore INT 09h handler
		call	sub_a_4B95
		mov	bp,offset data_a_D833
		call	sub_a_45FC
		mov	cx,12Ch

locloop_a_4E0E:
		call	sub_a_4CF6
		loop	locloop_a_4E0E		; Loop if cx > 0

		jmp	loc_a_4C75

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4E16	proc	near
		mov	ax,ds:d_04E9_D79C_e
		mov	bx,ds:d_04E9_D7A4_e
		mov	cx,0FFFFh
		mov	dx,ds:d_04E9_D79E_e
		push	ds
		mov	ds,ax
		mov	ah,3Fh
		int	21h			; DOS Services  ah=function 3Fh
						;  read file, bx=file handle
						;   cx=bytes to ds:dx buffer
		pop	ds
		jc	loc_a_4DF7		; Jump if carry Set
		retn
sub_a_4E16	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4E2F	proc	near
		mov	bx,data_a_D7A4
		mov	ah,3Eh
		int	21h			; DOS Services  ah=function 3Eh
						;  close file, bx=file handle
		jc	loc_a_4DF7		; Jump if carry Set
		retn
sub_a_4E2F	endp

		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 83h,0C4h, 06h, 58h, 8Bh,0C7h
		db	 5Bh, 59h, 5Ah, 5Eh, 5Fh, 5Dh
		db	 1Fh, 07h, 2Eh, 8Fh, 06h, 0Ah
		db	 00h, 2Eh, 8Fh, 06h, 0Ch, 00h
		db	 2Eh, 8Fh, 06h, 0Eh, 00h, 2Eh
		db	 83h, 0Eh, 0Eh, 00h, 01h, 2Eh
		db	0FFh, 36h, 0Eh, 00h, 0Eh, 2Eh
		db	0C7h, 06h, 0Eh, 00h, 58h, 00h
		db	 2Eh,0FFh, 36h, 0Eh, 00h,0CFh
		db	0B0h, 24h,0BAh, 10h, 00h,0E8h
		db	 01h, 00h,0CBh, 1Eh, 0Eh, 1Fh
		db	0B4h, 25h,0CDh, 21h, 1Fh,0C3h
		db	 9Ch, 50h,0B4h, 19h,0CDh, 21h
		db	 58h, 9Dh, 2Eh,0FFh, 2Eh, 0Ah
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 11h, 0Bh, 02h, 10h, 03h
		db	'DO YOU WANT TO USE A JOYSTICK? ('
		db	'Y/N)', 0
		db	 11h, 0Eh, 00h, 10h, 03h, 48h
		db	 4Fh
		db	'W MANY JOYSTICKS ARE PLUGGED IN?'
		db	' (1/2)'
		db	 00h, 00h, 00h, 11h, 00h, 00h
		db	 10h, 02h
		db	'TO CALIBRATE JOYSTICK 1...'
		db	 11h, 04h, 00h, 10h, 03h, 4Dh
		db	 4Fh
		db	'VE STICK TO TOP LEFT AND PUSH FI'
		db	'RE', 0
		db	 11h, 06h, 00h, 10h, 03h, 4Dh
		db	 4Fh
		db	'VE STICK TO BOTTOM RIGHT AND PUS'
		db	'H FIRE', 0
		db	 11h, 08h, 00h, 10h, 03h
		db	'CENTRE STICK HANDLE AND PUSH FIR'
		db	'E'
		db	 00h, 15h, 00h,0B1h, 11h, 00h
		db	 00h, 10h, 02h
		db	'TO CALIBRATE JOYSTICK 2...'
		db	 11h, 04h, 00h, 10h, 03h, 4Dh
		db	 4Fh
		db	'VE STICK TO TOP LEFT AND PUSH FI'
		db	'REH', 0
		db	0B2h, 00h, 05h, 01h,0B0h
		db	'Memory allocation error$'
		db	'No memory for program buffers$'
		db	0
		db	'TOPPLER.BINB', 0
		db	0B2h, 00h, 8Dh, 07h,0B0h, 1Ch
		db	 3Eh, 3Eh, 03h, 00h,0B2h, 7Fh
		db	 09h, 00h,0B0h, 3Eh, 3Eh, 1Ch
		db	 00h, 00h, 1Ch, 1Ch, 3Eh, 3Eh
		db	 3Eh, 3Eh, 3Eh, 3Eh, 3Eh, 1Ch
		db	 1Ch, 00h, 00h, 00h, 10h, 02h
		db	 11h, 0Bh, 0Ah, 00h, 10h, 03h
		db	 11h, 0Eh, 05h
		db	'CATCH SOME FISH'
		db	 10h, 01h, 11h, 11h
		db	8, 'FOR BONUSES!>'
		db	 00h,0B2h, 00h,0F6h, 12h,0B0h
		db	 12h, 12h, 12h, 12h, 13h, 13h
		db	 13h, 13h, 08h, 00h,0B2h, 23h
		db	 08h, 00h,0B0h, 0Fh, 0Fh, 34h
		db	 34h, 34h, 34h, 34h, 34h, 0Fh
		db	 0Fh, 0Fh, 45h, 45h, 45h, 45h
		db	 45h, 0Fh, 45h, 45h, 45h, 45h
		db	 45h, 0Fh, 0Fh, 0Fh, 56h, 56h
		db	 56h, 56h, 56h, 56h, 0Fh, 0Fh
		db	 21h, 00h,0B2h, 67h, 08h, 00h
		db	0B0h
		db	'hhhhxxxxyyyiiiiijjjjjjj'
		db	 17h, 00h,0B2h, 0Eh, 21h, 00h
		db	0B0h,0F3h,0F3h,0F3h,0F3h,0F3h
		db	0F3h,0F3h, 03h, 03h, 03h, 03h
		db	 03h, 02h, 02h, 02h, 02h, 12h
		db	 12h, 12h, 12h, 12h, 13h, 13h
		db	 13h, 18h, 00h,0B2h, 23h, 08h
		db	 00h,0B0h, 0Fh, 0Fh, 34h, 34h
		db	 34h, 34h, 34h, 34h, 0Fh, 0Fh
		db	 0Fh, 45h, 45h, 45h, 0Fh, 0Fh
		db	 0Fh, 45h, 45h, 45h, 45h, 45h
		db	 45h, 0Fh, 0Fh
		db	7 dup (56h)
		db	 0Fh, 21h, 00h,0B2h, 67h, 08h
		db	 00h,0B0h, 68h, 08h, 00h,0B0h
		db	 69h, 08h, 00h,0B0h, 6Ah, 6Ah
		db	 6Ah, 6Ah, 6Ah, 6Ah, 06h, 00h
		db	0B2h, 0Eh, 21h, 00h,0B0h,0F3h
		db	 08h, 00h,0B0h, 03h, 03h
		db	7 dup (2)
		db	7 dup (12h)
		db	 13h, 11h, 00h,0B2h, 23h, 08h
		db	 00h,0B0h, 0Fh, 0Fh, 34h, 34h
		db	 34h, 34h, 34h, 34h, 0Fh, 0Fh
		db	 0Fh, 45h, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Fh, 45h, 45h, 45h, 45h, 45h
		db	 45h, 0Fh, 0Fh
		db	7 dup (56h)
		db	 0Fh, 21h, 00h,0B2h, 67h, 08h
		db	 00h,0B0h, 68h, 08h, 00h,0B0h
		db	 69h, 08h, 00h,0B0h, 6Ah, 6Ah
		db	 6Ah, 6Ah, 6Ah, 05h, 00h,0B2h
		db	 0Eh, 21h, 00h,0B0h,0E3h,0F3h
		db	0F3h,0F3h,0F3h,0F3h,0F3h,0F2h
		db	0F2h, 09h, 00h,0B2h, 02h, 09h
		db	 00h,0B0h, 12h, 12h, 12h, 12h
		db	 12h, 12h, 12h, 13h, 08h, 00h
		db	0B2h, 23h, 08h, 00h,0B0h, 0Fh
		db	 0Fh, 34h, 34h, 34h, 34h, 34h
		db	 34h, 08h, 00h,0B2h, 0Fh, 09h
		db	 00h,0B0h, 45h, 45h, 45h, 45h
		db	 45h, 45h, 0Fh, 0Fh, 08h, 00h
		db	0B2h, 56h, 08h, 00h,0B0h, 67h
		db	 08h, 00h,0B0h, 68h, 08h, 00h
		db	0B0h, 69h, 08h, 00h,0B0h, 6Ah
		db	 6Ah, 6Ah, 6Ah, 04h, 00h,0B2h
		db	 0Eh, 21h, 00h,0B0h,0E2h,0E2h
		db	 02h, 00h,0B2h,0F2h, 08h, 00h
		db	0B0h, 02h, 09h, 00h,0B0h, 12h
		db	 08h, 00h,0B0h, 23h, 08h, 00h
		db	0B0h, 0Fh, 0Fh, 34h, 34h, 34h
		db	 34h, 34h, 34h, 08h, 00h,0B2h
		db	 0Fh, 09h, 00h,0B0h, 45h, 45h
		db	 45h, 45h, 45h, 45h, 0Fh, 0Fh
		db	 08h, 00h,0B2h, 56h, 08h, 00h
		db	0B0h, 67h, 08h, 00h,0B0h, 68h
		db	 08h, 00h,0B0h, 69h, 08h, 00h
		db	0B0h, 6Ah, 6Ah, 6Ah, 03h, 00h
		db	0B2h, 0Eh, 21h, 00h,0B0h,0E2h
		db	0E2h,0E2h, 03h, 00h,0B2h,0F2h
		db	 08h, 00h,0B0h, 02h, 09h, 00h
		db	0B0h, 12h, 08h, 00h,0B0h, 23h
		db	 08h, 00h,0B0h, 0Fh, 0Fh
data_a_523A	dw	3434h			; Data table (indexed access)
		db	 34h, 34h, 34h, 34h, 08h, 00h
		db	0B2h, 0Fh, 09h, 00h,0B0h, 45h
		db	 45h, 45h, 45h, 45h, 45h, 0Fh
		db	 0Fh, 08h, 00h,0B2h, 56h, 08h
		db	 00h,0B0h
		db	57h
		db	7 dup (67h)
		db	 08h, 00h,0B2h, 68h, 08h, 00h
		db	0B0h, 69h, 08h, 00h,0B0h, 6Ah
		db	 6Ah, 02h, 00h,0B2h, 0Eh, 21h
		db	 00h,0B0h,0E2h,0E2h,0E2h,0E2h
		db	 04h, 00h,0B2h,0F2h, 08h, 00h
		db	0B0h, 02h, 09h, 00h,0B0h, 12h
		db	 08h, 00h,0B0h, 0Fh
		db	7 dup (23h)
		db	 0Fh, 0Fh, 34h, 34h, 34h, 34h
		db	 34h, 34h, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Fh, 34h, 0Fh, 0Fh, 0Fh, 45h
		db	 45h, 45h, 45h, 45h, 45h, 0Fh
		db	 0Fh, 21h, 00h,0B2h, 56h, 08h
		db	 00h,0B0h
		db	57h
		db	7 dup (67h)
		db	 08h, 00h,0B2h, 68h, 08h, 00h
		db	0B0h
		db	'iiYYYYYYZ', 9
		db	 00h,0B2h, 0Eh, 21h, 00h,0B0h
		db	0E2h,0E2h,0E2h,0E2h,0E2h, 05h
		db	 00h,0B2h,0F2h, 08h, 00h,0B0h
		db	 02h, 09h, 00h,0B0h, 12h, 08h
		db	 00h,0B0h, 0Fh
		db	7 dup (23h)
		db	 0Fh, 0Fh, 34h, 34h, 34h, 34h
		db	 34h, 34h, 0Fh, 0Fh, 0Fh, 34h
		db	 34h, 34h, 0Fh, 0Fh, 0Fh, 45h
		db	 45h, 45h, 45h, 45h, 45h, 0Fh
		db	 0Fh, 21h, 00h,0B2h, 56h, 08h
		db	 00h,0B0h
		db	'WWWggggghhhhhhXX'
		db	 10h, 00h,0B2h, 59h, 08h, 00h
		db	0B0h, 0Eh, 21h, 00h,0B0h,0E2h
		db	0E2h,0E2h,0E2h,0E2h,0E2h, 06h
		db	 00h,0B2h,0F2h, 08h, 00h,0B0h
		db	 02h, 00h, 00h, 00h, 00h, 01h
		db	 01h, 01h, 02h, 02h, 03h, 04h
		db	 04h, 05h, 06h, 07h, 08h, 09h
		db	 0Ah, 0Bh, 0Ch, 0Dh, 0Fh, 10h
		db	 11h, 13h, 14h, 15h, 17h, 18h
		db	 1Ah, 1Bh, 1Dh, 1Eh, 1Fh
		db	'!"$'
		db	'%', 27h, '()+,-/01234567889::;;;'
		db	'<<<<<<<;;;::98876543210U', 0
		db	0B2h,0FFh, 1Ah, 00h,0B0h, 0Bh
		db	 0Ah, 09h, 08h, 07h, 06h, 05h
		db	 04h, 04h, 03h, 02h, 02h, 01h
		db	 01h, 01h, 00h, 00h, 00h, 03h
		db	 03h, 03h, 03h, 04h, 04h, 04h
		db	 05h, 05h, 06h, 07h, 07h, 08h
		db	 09h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh
		db	 0Fh, 10h, 12h, 13h, 14h, 16h
		db	 17h, 18h, 1Ah, 1Bh, 1Dh, 1Eh
		db	' !"$'
		db	'%', 27h, '(*+,./023456789:;;<==>'
		db	'>>???????>>>==<;;:987654320h', 0
		db	0B2h,0FFh, 1Bh, 00h,0B0h, 0Bh
		db	 0Ah, 09h, 08h, 07h, 07h, 06h
		db	 05h, 05h, 04h, 04h, 04h, 03h
		db	 03h, 03h, 0Fh, 00h,0B2h, 00h
		db	 10h, 00h,0B0h, 01h, 01h, 01h
		db	 01h, 01h, 02h, 02h, 02h, 02h
		db	 02h, 03h, 03h, 03h, 04h, 04h
		db	 04h, 04h, 05h, 05h, 05h, 05h
		db	 06h, 06h, 06h, 07h, 07h, 07h
		db	 07h
		db	8, 8, 8, 9, 9, 9, 9, 9, 0Ah, 0Ah, 0Ah
		db	0Ah, 0Ah
		db	7 dup (0Bh)
		db	 88h, 8Ch, 8Ch, 8Ch, 8Eh, 8Eh
		db	 8Fh, 8Fh, 00h, 05h, 05h, 09h
		db	 0Eh, 12h, 17h, 1Bh, 08h, 0Dh
		db	 11h, 16h, 1Fh, 10h, 15h, 1Ah
		db	 1Eh, 23h, 14h, 19h, 1Fh, 14h
		db	 19h, 1Eh, 23h, 14h, 19h, 1Eh
		db	 23h, 19h, 1Eh, 23h, 14h, 15h
		db	 1Ah, 1Fh, 10h, 16h, 1Bh, 08h
		db	 0Dh, 11h, 12h, 17h, 04h, 09h
		db	 0Ah, 0Ah, 0Fh, 8Fh, 8Fh, 87h
		db	 87h, 83h, 83h, 83h, 70h, 00h
		db	0B2h, 00h, 01h, 02h,0B0h, 02h
		db	 03h, 03h, 08h, 0Ah, 0Bh, 0Bh
		db	 0Ch, 0Eh, 0Fh, 0Fh, 0Ch, 0Eh
		db	 0Fh, 0Fh
		db	' "##(*++,.//,.//02338:;;<>??<>??'
		db	'02338:;;<>??<>??'
		db	 80h, 82h, 83h, 83h, 88h, 8Ah
		db	 8Bh, 8Bh, 8Ch, 8Eh, 8Fh, 8Fh
		db	 8Ch, 8Eh, 8Fh, 8Fh,0A0h,0A2h
		db	0A3h,0A3h,0A8h,0AAh,0ABh,0ABh
		db	0ACh,0AEh,0AFh,0AFh,0ACh,0AEh
		db	0AFh,0AFh,0B0h,0B2h,0B3h,0B3h
		db	0B8h,0BAh,0BBh,0BBh,0BCh,0BEh
		db	0BFh,0BFh,0BCh,0BEh,0BFh,0BFh
		db	0B0h,0B2h,0B3h,0B3h

locloop_a_54FB:
		mov	ax,0BBBAh
loc_a_54FE:
		mov	bx,0BEBCh
		mov	di,0BCBFh
		mov	si,0BFBFh
		rol	dl,0C3h			; Rotate
		retn
		db	0C8h

loc_ret_a_550C:
		retf	0CBCBh
			                        ;* No entry point to code
		int	3			; Debug breakpoint
		into				; Int 4 on overflow
		iret				; Interrupt return
			                        ;* No entry point to code
		iret				; Interrupt return
			                        ;* No entry point to code
		int	3			; Debug breakpoint
		into				; Int 4 on overflow
		iret				; Interrupt return
			                        ;* No entry point to code
		iret				; Interrupt return
			                        ;* No entry point to code
		loopnz	locloop_a_54FB		; Loop if zf=0, cx>0

		jcxz	loc_a_54FE		; Jump if cx=0
		call	sub_a_4108
		jmp	short loc_ret_a_550C
			                        ;* No entry point to code
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		db	0F0h,0F2h,0F3h,0F3h,0F8h,0FAh
		db	0FBh,0FBh,0FCh,0FEh,0FFh,0FFh
		db	0FCh,0FEh,0FFh,0FFh,0F0h,0F2h
		db	0F3h,0F3h

locloop_a_553B:
		clc				; Clear carry flag
		cli				; Disable interrupts
		sti				; Enable interrupts
loc_a_553E:
		sti				; Enable interrupts
		cld				; Clear direction
		db	0FEh,0FFh,0FFh,0FCh,0FEh,0FFh
		db	0FFh,0C0h,0C2h,0C3h,0C3h,0C8h

loc_ret_a_554C:
		retf	0CBCBh
			                        ;* No entry point to code
		int	3			; Debug breakpoint
		into				; Int 4 on overflow
		iret				; Interrupt return
			                        ;* No entry point to code
		iret				; Interrupt return
			                        ;* No entry point to code
		int	3			; Debug breakpoint
		into				; Int 4 on overflow
		iret				; Interrupt return
			                        ;* No entry point to code
		iret				; Interrupt return
			                        ;* No entry point to code
		loopnz	locloop_a_553B		; Loop if zf=0, cx>0

		jcxz	loc_a_553E		; Jump if cx=0
;*		call	sub_a_4148		;*
		db	0E8h,0EAh,0EBh		;  Fixup - byte match
		jmp	short loc_ret_a_554C
			                        ;* No entry point to code
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		db	0F0h,0F2h,0F3h,0F3h,0F8h,0FAh
		db	0FBh,0FBh,0FCh,0FEh,0FFh,0FFh
		db	0FCh,0FEh,0FFh,0FFh,0F0h,0F2h
		db	0F3h,0F3h,0F8h,0FAh,0FBh,0FBh
		db	0FCh,0FEh,0FFh,0FFh,0FCh,0FEh
		db	0FFh,0FFh,0FFh, 00h,0B2h, 00h
		db	 0Eh, 01h,0B0h, 50h, 05h,0F5h
		db	 5Fh,0FFh,0FFh, 7Fh,0FFh,0DFh
		db	0DDh
		db	'ww__uuW]]'
		db	0D5h, 75h, 55h, 55h, 75h, 55h
		db	 55h, 55h,0D5h,0D5h, 55h, 55h
		db	0D5h, 55h,0D5h
		db	'uUQUUuUUU'
		db	0D5h
		db	'TUUTEUUUU'
		db	 15h, 15h, 55h, 55h, 54h, 55h
		db	 15h, 45h, 55h, 55h, 54h, 51h
		db	 45h, 15h, 55h, 54h, 45h, 45h
		db	 11h, 14h, 55h, 45h, 11h, 11h
		db	 14h, 04h, 41h, 41h, 10h, 11h
		db	 44h, 44h, 10h, 11h, 04h, 40h
		db	 51h, 41h, 04h, 10h, 40h, 01h
		db	 01h, 10h, 04h, 41h, 00h, 04h
		db	 11h, 40h, 00h, 04h, 04h, 00h
		db	 00h, 40h, 10h, 01h, 00h, 10h
		db	 01h, 00h, 00h, 04h, 10h, 00h

locloop_a_5605:
		add	[bx+si+10h],ax
		add	[bx+si],ax
		add	[bx+si],dl
		db	 00h, 00h, 00h, 00h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 10h
		db	 8Ah, 00h,0B2h, 00h, 08h, 00h
		db	0B0h,0E2h,0E2h,0E2h,0E2h,0E3h
		db	0E3h,0E3h,0E4h,0E4h,0E5h,0E6h
		db	0E6h,0E7h,0E8h,0E9h,0EAh,0EBh
		db	0ECh,0EDh,0EEh,0EFh,0F1h,0F2h
		db	0F3h,0F5h,0F6h,0F7h,0F9h,0FAh
		db	0FCh,0FDh,0FFh, 00h, 01h, 03h
		db	 04h, 06h, 07h, 09h, 0Ah, 0Bh
		db	 0Dh, 0Eh, 0Fh, 11h, 12h, 13h
		db	 14h, 15h, 16h, 17h, 18h, 19h
		db	 1Ah, 1Ah, 1Bh, 1Ch, 1Ch, 1Dh
		db	 1Dh, 1Dh, 1Eh, 1Eh, 1Eh, 1Eh
		db	 1Eh, 1Eh, 1Eh, 1Dh, 1Dh, 1Dh
		db	 1Ch, 1Ch, 1Bh, 1Ah, 1Ah, 19h
		db	 18h, 17h, 16h, 15h, 14h, 13h
		db	 12h, 11h, 0Fh, 0Eh, 0Dh, 0Bh
		db	 0Ah, 09h, 07h, 06h, 04h, 03h
		db	 01h, 00h,0FFh,0FDh,0FCh,0FAh
		db	0F9h,0F7h,0F6h,0F5h,0F3h,0F2h
		db	0F1h,0EFh,0EEh,0EDh,0ECh,0EBh
		db	0EAh,0E9h,0E8h,0E7h,0E6h,0E6h
		db	0E5h,0E4h,0E4h,0E3h,0E3h,0E3h
		db	0E2h,0E2h,0E2h, 96h, 91h, 94h
		db	 92h, 92h, 93h, 90h, 94h, 8Eh
		db	 95h, 8Ch, 96h, 8Ah, 97h, 88h
		db	 98h, 86h, 99h, 84h, 9Ah, 2Eh
		db	 9Bh,0D8h, 9Bh, 82h, 9Ch, 80h
		db	 9Dh, 7Eh, 9Eh, 7Ch, 9Fh, 7Ah
		db	0A0h, 78h,0A1h, 22h,0A2h,0CCh
		db	0A2h, 76h,0A3h, 20h,0A4h,0CAh
		db	0A4h, 74h,0A5h, 1Eh,0A6h,0C8h
		db	0A6h, 72h,0A7h, 70h,0A8h, 6Eh
		db	0A9h, 6Ch,0AAh, 6Ah,0ABh, 68h
		db	0ACh, 66h,0ADh, 64h,0AEh, 0Eh
		db	0AFh,0B8h,0AFh, 62h,0B0h, 0Ch
		db	0B1h, 0Ah,0B2h, 08h,0B3h, 06h
		db	0B4h, 04h,0B5h, 02h,0B6h, 00h
		db	0B7h,0FEh,0B7h,0FCh,0B8h,0FAh
		db	0B9h,0A4h,0BAh, 4Eh,0BBh,0F8h
		db	0BBh,0F6h,0BCh,0F4h,0BDh,0F2h
		db	0BEh,0F0h,0BFh,0EEh,0C0h, 98h
		db	0C1h, 42h,0C2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h,0ECh,0C2h,0EAh
		db	0C3h,0E8h,0C4h,0E6h,0C5h,0E4h
		db	0C6h,0E2h,0C7h,0E0h,0C8h, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh, 62h
		db	0B0h,0AEh, 90h,0D0h, 90h, 12h
		db	 91h, 54h, 91h, 4Ch, 39h,0CEh
		db	 39h, 90h, 3Ah, 52h, 3Bh,0BCh
		db	 33h, 3Eh, 34h, 00h, 35h,0C2h
		db	 35h, 84h, 36h, 06h, 37h,0C8h
		db	 37h, 8Ah, 38h, 56h, 88h,0D8h
		db	 88h, 9Ah, 89h, 5Ch, 8Ah, 1Eh
		db	 8Bh,0A0h, 8Bh, 62h, 8Ch, 24h
		db	 8Dh,0E6h, 8Dh, 68h, 8Eh, 2Ah
		db	 8Fh,0ECh, 8Fh, 96h, 45h, 18h
		db	 46h,0DAh, 46h, 9Ch, 47h,0D6h
		db	 5Bh, 58h, 5Ch, 1Ah, 5Dh,0DCh
		db	 5Dh, 16h, 72h, 98h, 72h, 5Ah
		db	 73h, 1Ch, 74h,0D6h, 5Bh, 58h
		db	 5Ch, 1Ah, 5Dh,0DCh, 5Dh,0C2h
		db	 2Fh, 6Ch, 30h, 16h, 31h,0C0h
		db	 31h, 6Ah, 32h, 96h, 91h, 94h
		db	 92h, 92h, 93h, 90h, 94h, 8Eh
		db	 95h, 8Ch, 96h, 8Ah, 97h, 88h
		db	 98h, 86h, 99h, 84h, 9Ah, 2Eh
		db	 9Bh,0D8h, 9Bh, 82h, 9Ch, 80h
		db	 9Dh, 7Eh, 9Eh, 7Ch, 9Fh, 7Ah
		db	0A0h, 78h,0A1h, 22h,0A2h,0CCh
		db	0A2h, 76h,0A3h, 20h,0A4h,0CAh
		db	0A4h, 74h,0A5h, 1Eh,0A6h,0C8h
		db	0A6h, 72h,0A7h, 70h,0A8h, 6Eh
		db	0A9h, 6Ch,0AAh, 6Ah,0ABh, 68h
		db	0ACh, 66h,0ADh, 64h,0AEh, 0Eh
loc_a_57DA:
		scasw				; Scan es:[di] for ax
		mov	ax,62AFh
		mov	al,0Ch
		mov	cl,0Ah
		mov	dl,8
		mov	bl,6
		mov	ah,4
		mov	ch,2
		mov	dh,0
		mov	bh,0FEh
		mov	bh,0FCh
		mov	ax,0B9FAh
		movsb				; Mov [si] to es:[di]
		mov	dx,0BB4Eh
		clc				; Clear carry flag
		mov	bx,0BCF6h
		hlt				; Halt processor
		mov	bp,offset data_a_BEF2
                           lock	mov	di,0C0EEh
		cbw				; Convrt byte to word
		rol	word ptr [bp+si-3Eh],76h	; 'v' Rotate
		mov	data_a_A420,ax
		retf	74A4h
			                        ;* No entry point to code
		movsw				; Mov [si] to es:[di]
		push	ds
		cmpsb				; Cmp [si] to es:[di]
		enter	0ECA6h,0C2h		; Procedure entry
;*		jmp	far ptr l_E6C4_E8C3	;*
		db	0EAh
		dw	0E8C3h, 0E6C4h		;  Fixup - byte match
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh, 5Eh
		db	 48h,0E0h, 48h,0A2h, 49h, 64h
		db	 4Ah, 9Eh, 5Eh, 20h, 5Fh,0E2h
		db	 5Fh,0A4h, 60h,0DEh, 74h, 60h
		db	 75h, 22h, 76h,0E4h, 76h, 9Eh
		db	 5Eh, 20h, 5Fh,0E2h, 5Fh,0A4h
		db	 60h,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 96h
		db	 91h, 94h, 92h, 92h, 93h, 90h
		db	 94h, 8Eh, 95h, 8Ch, 96h, 8Ah
		db	 97h, 88h, 98h, 86h, 99h, 84h
		db	 9Ah, 2Eh, 9Bh,0D8h, 9Bh, 82h
		db	 9Ch, 80h, 9Dh, 7Eh, 9Eh, 7Ch
		db	 9Fh, 7Ah,0A0h, 78h,0A1h, 22h
		db	0A2h,0CCh,0A2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h, 72h,0A7h, 70h
		db	0A8h, 6Eh,0A9h, 6Ch,0AAh, 6Ah
		db	0ABh, 68h,0ACh, 66h,0ADh, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh, 62h
		db	0B0h, 0Ch,0B1h, 0Ah,0B2h, 08h
		db	0B3h, 06h,0B4h, 04h,0B5h, 02h
		db	0B6h, 00h,0B7h,0FEh,0B7h,0FCh
		db	0B8h,0FAh,0B9h,0A4h,0BAh, 4Eh
		db	0BBh,0F8h,0BBh,0F6h,0BCh,0F4h
		db	0BDh,0F2h,0BEh,0F0h,0BFh,0EEh
		db	0C0h, 98h,0C1h, 42h,0C2h, 76h
		db	0A3h, 20h,0A4h,0CAh,0A4h, 74h
		db	0A5h, 1Eh,0A6h,0C8h,0A6h,0ECh
		db	0C2h,0EAh,0C3h,0E8h,0C4h,0E6h
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh, 26h
		db	 4Bh,0A8h, 4Bh, 6Ah, 4Ch, 2Ch
		db	 4Dh, 66h, 61h,0E8h, 61h,0AAh
		db	 62h, 6Ch, 63h,0A6h, 77h, 28h
		db	 78h,0EAh, 78h,0ACh, 79h, 66h
		db	 61h,0E8h, 61h,0AAh, 62h, 6Ch
		db	 63h,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 96h
		db	 91h, 94h, 92h, 92h, 93h, 90h
		db	 94h, 8Eh, 95h, 8Ch, 96h, 8Ah
		db	 97h, 88h, 98h, 86h, 99h, 84h
		db	 9Ah, 2Eh, 9Bh,0D8h, 9Bh, 82h
		db	 9Ch, 80h, 9Dh, 7Eh, 9Eh, 7Ch
		db	 9Fh, 7Ah,0A0h, 78h,0A1h, 22h
		db	0A2h,0CCh,0A2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h, 72h,0A7h, 70h
		db	0A8h, 6Eh,0A9h, 6Ch,0AAh, 6Ah
		db	0ABh, 68h,0ACh, 66h,0ADh, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh, 62h
		db	0B0h, 0Ch,0B1h, 0Ah,0B2h, 08h
		db	0B3h, 06h,0B4h, 04h,0B5h, 02h
loc_a_59D6:
		mov	dh,0
		mov	bh,0FEh
		mov	bh,0FCh
		mov	ax,0B9FAh
		movsb				; Mov [si] to es:[di]
		mov	dx,0BB4Eh
		clc				; Clear carry flag
		mov	bx,0BCF6h
		hlt				; Halt processor
		mov	bp,offset data_a_BEF2
                           lock	mov	di,0C0EEh
		cbw				; Convrt byte to word
		rol	word ptr [bp+si-3Eh],76h	; 'v' Rotate
		mov	data_a_A420,ax
		retf	74A4h
			                        ;* No entry point to code
		movsw				; Mov [si] to es:[di]
		push	ds
		cmpsb				; Cmp [si] to es:[di]
		enter	0ECA6h,0C2h		; Procedure entry
;*		jmp	far ptr l_E6C4_E8C3	;*
		db	0EAh
		dw	0E8C3h, 0E6C4h		;  Fixup - byte match
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh,0EEh
		db	 4Dh, 70h, 4Eh, 32h, 4Fh,0F4h
		db	 4Fh, 2Eh, 64h,0B0h, 64h, 72h
		db	 65h, 34h, 66h, 6Eh, 7Ah,0F0h
		db	 7Ah,0B2h, 7Bh, 74h, 7Ch, 2Eh
		db	 64h,0B0h, 64h, 72h, 65h, 34h
		db	 66h,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 96h
		db	 91h, 94h, 92h, 92h, 93h, 90h
		db	 94h, 8Eh, 95h, 8Ch, 96h, 8Ah
		db	 97h, 88h, 98h, 86h, 99h, 84h
		db	 9Ah, 2Eh, 9Bh,0D8h, 9Bh, 82h
		db	 9Ch, 80h, 9Dh, 7Eh, 9Eh, 7Ch
		db	 9Fh, 7Ah,0A0h, 78h,0A1h, 22h
		db	0A2h,0CCh,0A2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h, 72h,0A7h, 70h
		db	0A8h, 6Eh,0A9h, 6Ch,0AAh, 6Ah
		db	0ABh, 68h,0ACh, 66h,0ADh, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh
		db	62h
loc_a_5AC0:
		mov	al,0Ch
		mov	cl,0Ah
		mov	dl,8
		mov	bl,6
		mov	ah,4
		mov	ch,2
		mov	dh,0
		mov	bh,0FEh
		mov	bh,0FCh
		mov	ax,0B9FAh
		movsb				; Mov [si] to es:[di]
		mov	dx,0BB4Eh
		clc				; Clear carry flag
		mov	bx,0BCF6h
		hlt				; Halt processor
		mov	bp,offset data_a_BEF2
                           lock	mov	di,0C0EEh
		cbw				; Convrt byte to word
		rol	word ptr [bp+si-3Eh],76h	; 'v' Rotate
		mov	data_a_A420,ax
		retf	74A4h
			                        ;* No entry point to code
		movsw				; Mov [si] to es:[di]
		push	ds
		cmpsb				; Cmp [si] to es:[di]
		enter	0ECA6h,0C2h		; Procedure entry
;*		jmp	far ptr l_E6C4_E8C3	;*
		db	0EAh
		dw	0E8C3h, 0E6C4h		;  Fixup - byte match
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh,0B6h
		db	 50h, 38h, 51h,0FAh, 51h,0BCh
		db	 52h,0F6h, 66h, 78h, 67h, 3Ah
		db	 68h,0FCh, 68h, 36h, 7Dh,0B8h
		db	 7Dh, 7Ah, 7Eh, 3Ch, 7Fh,0F6h
		db	 66h, 78h, 67h, 3Ah, 68h,0FCh
		db	 68h,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 96h
		db	 91h, 94h, 92h, 92h, 93h, 90h
		db	 94h, 8Eh, 95h, 8Ch, 96h, 8Ah
		db	 97h, 88h, 98h, 86h, 99h, 84h
		db	 9Ah, 2Eh, 9Bh,0D8h, 9Bh, 82h
		db	 9Ch, 80h, 9Dh, 7Eh, 9Eh, 7Ch
		db	 9Fh, 7Ah,0A0h, 78h,0A1h, 22h
		db	0A2h,0CCh,0A2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h, 72h,0A7h, 70h
		db	0A8h, 6Eh,0A9h, 6Ch,0AAh, 6Ah
		db	0ABh, 68h,0ACh, 66h,0ADh, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh, 62h
		db	0B0h, 0Ch,0B1h, 0Ah,0B2h, 08h
		db	0B3h, 06h,0B4h, 04h,0B5h, 02h
		db	0B6h, 00h,0B7h,0FEh,0B7h,0FCh
		db	0B8h,0FAh,0B9h,0A4h,0BAh, 4Eh
		db	0BBh,0F8h,0BBh,0F6h,0BCh,0F4h
		db	0BDh,0F2h,0BEh,0F0h,0BFh,0EEh
		db	0C0h, 98h,0C1h, 42h,0C2h, 76h
		db	0A3h, 20h,0A4h,0CAh,0A4h, 74h
		db	0A5h, 1Eh,0A6h,0C8h,0A6h,0ECh
		db	0C2h,0EAh,0C3h,0E8h,0C4h,0E6h
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh, 7Eh
		db	 53h, 00h, 54h,0C2h, 54h, 84h
		db	 55h,0BEh, 69h, 40h, 6Ah, 02h
		db	 6Bh,0C4h, 6Bh,0FEh, 7Fh, 80h
		db	 80h, 42h, 81h, 04h, 82h,0BEh
		db	 69h, 40h, 6Ah, 02h, 6Bh,0C4h
		db	 6Bh,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 96h
		db	 91h, 94h, 92h, 92h, 93h, 90h
		db	 94h, 8Eh, 95h, 8Ch, 96h, 8Ah
		db	 97h, 88h, 98h, 86h, 99h, 84h
		db	 9Ah, 2Eh, 9Bh,0D8h, 9Bh, 82h
		db	 9Ch, 80h, 9Dh, 7Eh, 9Eh, 7Ch
		db	 9Fh, 7Ah,0A0h, 78h,0A1h, 22h
		db	0A2h,0CCh,0A2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h, 72h,0A7h, 70h
		db	0A8h, 6Eh,0A9h, 6Ch,0AAh, 6Ah
		db	0ABh, 68h,0ACh, 66h,0ADh, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh, 62h
		db	0B0h, 0Ch,0B1h, 0Ah,0B2h, 08h
		db	0B3h, 06h,0B4h, 04h,0B5h, 02h
		db	0B6h, 00h,0B7h,0FEh,0B7h,0FCh
		db	0B8h,0FAh,0B9h,0A4h,0BAh, 4Eh
		db	0BBh,0F8h,0BBh,0F6h,0BCh,0F4h
		db	0BDh,0F2h,0BEh,0F0h,0BFh,0EEh
		db	0C0h, 98h,0C1h, 42h,0C2h, 76h
		db	0A3h, 20h,0A4h,0CAh,0A4h, 74h
		db	0A5h, 1Eh,0A6h,0C8h,0A6h,0ECh
		db	0C2h,0EAh,0C3h,0E8h,0C4h,0E6h
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh, 46h
		db	 56h,0C8h, 56h, 8Ah, 57h, 4Ch
		db	 58h, 86h, 6Ch, 08h, 6Dh,0CAh
		db	 6Dh, 8Ch, 6Eh,0C6h, 82h, 48h
		db	 83h, 0Ah, 84h,0CCh, 84h, 86h
		db	 6Ch, 08h, 6Dh,0CAh, 6Dh, 8Ch
		db	 6Eh,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 96h
		db	 91h, 94h, 92h, 92h, 93h, 90h
		db	 94h, 8Eh, 95h, 8Ch, 96h, 8Ah
		db	 97h, 88h, 98h, 86h, 99h, 84h
		db	 9Ah, 2Eh, 9Bh,0D8h, 9Bh, 82h
		db	 9Ch, 80h, 9Dh, 7Eh, 9Eh, 7Ch
		db	 9Fh, 7Ah,0A0h, 78h,0A1h, 22h
		db	0A2h,0CCh,0A2h, 76h,0A3h, 20h
		db	0A4h,0CAh,0A4h, 74h,0A5h, 1Eh
		db	0A6h,0C8h,0A6h, 72h,0A7h, 70h
		db	0A8h, 6Eh,0A9h, 6Ch,0AAh, 6Ah
		db	0ABh, 68h,0ACh, 66h,0ADh, 64h
		db	0AEh, 0Eh,0AFh,0B8h,0AFh, 62h
		db	0B0h, 0Ch,0B1h, 0Ah,0B2h, 08h
		db	0B3h, 06h,0B4h, 04h,0B5h, 02h
		db	0B6h, 00h,0B7h,0FEh,0B7h,0FCh
		db	0B8h,0FAh,0B9h,0A4h,0BAh, 4Eh
		db	0BBh,0F8h,0BBh,0F6h,0BCh,0F4h
		db	0BDh,0F2h,0BEh,0F0h,0BFh,0EEh
		db	0C0h, 98h,0C1h, 42h,0C2h, 76h
		db	0A3h, 20h,0A4h,0CAh,0A4h, 74h
		db	0A5h, 1Eh,0A6h,0C8h,0A6h,0ECh
		db	0C2h,0EAh,0C3h,0E8h,0C4h,0E6h
		db	0C5h,0E4h,0C6h,0E2h,0C7h,0E0h
		db	0C8h, 64h,0AEh, 0Eh,0AFh,0B8h
		db	0AFh, 62h,0B0h,0AEh, 90h,0D0h
		db	 90h, 12h, 91h, 54h, 91h, 4Ch
		db	 39h,0CEh, 39h, 90h, 3Ah, 52h
		db	 3Bh,0BCh, 33h, 3Eh, 34h, 00h
		db	 35h,0C2h, 35h, 84h, 36h, 06h
		db	 37h,0C8h, 37h, 8Ah, 38h, 56h
		db	 88h,0D8h, 88h, 9Ah, 89h, 5Ch
		db	 8Ah, 1Eh, 8Bh,0A0h, 8Bh, 62h
		db	 8Ch, 24h, 8Dh,0E6h, 8Dh, 68h
		db	 8Eh, 2Ah, 8Fh,0ECh, 8Fh, 0Eh
		db	 59h, 90h, 59h, 52h, 5Ah, 14h
		db	 5Bh, 4Eh, 6Fh,0D0h, 6Fh, 92h
		db	 70h, 54h, 71h, 8Eh, 85h, 10h
		db	 86h,0D2h, 86h, 94h, 87h, 4Eh
		db	 6Fh,0D0h, 6Fh, 92h, 70h, 54h
		db	 71h,0C2h, 2Fh, 6Ch, 30h, 16h
		db	 31h,0C0h, 31h, 6Ah, 32h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 03h,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h,0FDh
		db	 55h,0FFh, 00h, 00h, 0Fh, 00h
		db	 00h, 55h,0FFh,0FCh, 00h, 00h
		db	0D5h, 00h, 00h, 7Fh, 77h,0F0h
		db	 00h, 01h,0FFh, 00h, 00h,0F7h
		db	 55h,0C0h, 00h, 05h, 15h, 00h
		db	 00h,0D5h, 6Ah, 00h, 00h, 14h
		db	 41h, 00h, 00h, 55h,0AAh, 00h
		db	 0Ch, 11h, 50h, 00h, 00h,0D5h
		db	 65h, 03h, 3Ch, 10h, 40h, 00h
		db	 00h,0D5h, 56h,0CCh, 00h, 01h
		db	 55h, 00h, 00h, 95h, 55h,0FFh
		db	 3Ch, 00h, 40h, 00h, 00h,0A6h
		db	 55h,0FCh, 0Ch, 01h, 50h, 00h
		db	 00h, 0Ah, 99h,0FFh, 3Fh, 00h
		db	 40h,0F0h, 00h, 00h, 2Ah,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh,0F2h, 08h,0B2h, 00h, 0Ch
		db	 00h,0B0h,0FFh,0FFh, 00h, 00h
		db	0FFh, 55h, 00h, 00h, 55h, 55h
		db	 00h, 00h, 57h,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FDh, 55h
		db	 00h, 00h, 77h, 77h, 00h, 00h
		db	 77h,0FFh, 00h, 00h, 55h, 55h
		db	 00h, 00h, 55h, 55h, 00h, 00h
		db	0AAh,0FFh, 00h, 00h,0FDh, 55h
		db	 00h, 00h,0BFh,0FFh, 00h, 00h
		db	0AAh, 5Ah, 00h, 00h,0FFh,0AAh
		db	 00h, 00h,0A0h, 16h, 00h, 00h
		db	0AAh, 00h, 00h, 00h, 00h, 05h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 01h, 00h, 00h, 55h, 40h
		db	 00h, 00h, 00h, 01h, 00h, 00h
		db	 99h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AAh, 99h, 00h, 00h
		db	 98h, 00h, 00h, 00h, 0Ah,0AAh
		db	 00h, 00h,0AAh,0AAh,0F0h
		db	7 dup (0)
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 02h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 3Fh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 57h,0C0h
		db	 3Fh,0FFh, 00h, 00h, 00h, 00h
		db	0FFh,0FFh, 00h,0FFh,0C0h, 00h
		db	 00h, 00h, 55h,0DDh, 00h, 0Fh
		db	 55h, 00h, 00h, 00h,0F5h, 55h
		db	 00h, 03h,0DDh, 60h, 00h, 00h
		db	 5Fh,0FFh, 00h, 00h, 7Fh, 68h
		db	 00h, 00h, 55h, 57h, 00h, 00h
		db	0FFh,0D8h, 00h, 00h,0ABh,0F1h
		db	 00h, 00h,0DDh, 68h, 00h, 00h
		db	0BFh, 81h, 00h, 00h, 55h,0A8h
		db	 00h, 00h,0FAh,0A1h, 00h, 03h
		db	 56h,0A0h, 00h, 00h, 55h, 55h
		db	 00h, 0Fh, 5Ah, 80h, 00h, 00h
		db	 55h, 55h, 00h, 3Fh,0A8h, 00h
		db	 00h, 00h, 55h, 6Ah, 03h,0FFh
		db	 80h, 00h, 00h, 00h, 5Ah,0A0h
		db	 3Fh,0FFh, 00h, 00h, 00h, 0Fh
		db	0A8h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 02h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 00h, 03h,0FFh
		db	 00h, 00h,0FCh, 00h, 00h, 3Fh
		db	 00h, 3Fh,0FCh, 00h,0F0h, 00h
		db	 03h,0FDh, 00h, 0Fh, 77h,0C0h
		db	0C0h, 00h, 0Fh,0DDh, 00h, 03h
		db	0DDh, 70h, 00h, 00h, 3Fh, 75h
		db	 00h, 00h, 55h, 5Ch, 00h, 00h
		db	 3Dh,0D5h, 00h, 00h, 55h,0DCh
		db	 00h, 00h, 3Fh, 75h, 00h, 00h
		db	 55h, 5Ch, 00h, 00h, 3Fh, 59h
		db	 00h, 00h, 9Ah, 20h, 00h, 00h
		db	 36h, 66h, 00h, 00h, 68h, 80h
		db	 00h, 00h, 08h,0AAh, 00h, 00h
		db	 20h,0A9h, 01h,0B2h, 00h, 09h
		db	 00h,0B0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 04h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h, 0Fh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FCh, 00h, 00h
		db	 00h, 00h, 3Fh,0FCh, 3Fh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 03h, 00h, 00h
		db	0FDh, 77h, 0Fh,0FFh,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 0Fh, 00h, 00h,0DDh,0DDh
		db	 03h,0FFh, 70h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 3Fh
		db	 00h, 00h, 75h, 55h, 00h,0FFh
		db	 5Ch, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Dh, 00h, 00h
		db	0D5h, 55h, 00h,0FFh,0DCh, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Fh, 00h, 00h, 75h, 55h
		db	 00h,0FFh, 5Ch, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 3Fh
		db	 00h, 00h, 59h, 9Ah, 00h,0FFh
		db	 20h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 36h, 00h, 00h
		db	 66h, 68h, 00h,0FFh, 80h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 08h, 00h, 00h,0AAh, 20h
		db	 00h,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 1Bh, 01h,0B2h
		db	 00h, 08h, 00h,0B0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 3Fh, 0Fh,0FFh,0F0h
		db	 00h,0FCh, 00h, 03h,0FFh, 00h
		db	0FFh,0FFh, 00h,0F0h, 00h, 0Fh
		db	 5Fh, 00h, 3Fh,0FFh,0C0h,0C0h
		db	 00h, 3Dh, 7Fh, 00h, 0Fh,0FFh
		db	0F0h,0C0h, 00h, 3Dh, 7Fh, 00h
		db	 0Fh,0FFh,0F0h, 00h, 00h,0F5h
		db	0FFh, 00h, 03h,0FFh,0FCh, 00h
		db	 00h,0F5h,0FFh, 00h, 03h,0FFh
		db	0FCh, 00h, 00h,0F5h,0FFh, 00h
		db	 03h,0FFh,0FCh, 00h, 00h,0F5h
		db	0FFh, 00h, 03h,0FFh,0FCh, 00h
		db	 00h,0F5h,0FFh, 00h, 03h,0FFh
		db	0FCh,0C0h, 00h, 3Dh, 7Fh, 00h
		db	 0Fh,0FFh,0F0h,0C0h, 00h, 3Dh
		db	 7Fh, 00h, 0Fh,0FFh,0F0h,0F0h
		db	 00h, 0Fh, 5Fh, 00h, 3Fh,0FFh
		db	0C0h,0FCh, 00h, 03h,0FFh, 00h
		db	0FFh,0FFh, 00h,0FFh,0C0h, 00h
		db	 3Fh, 0Fh,0FFh,0F0h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h, 00h
		db	0FFh,0FFh, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 3Fh, 00h
		db	 0Fh,0FFh,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h,0F5h, 00h
		db	 03h,0FFh,0FCh,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h,0D7h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h,0D7h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 0Fh, 5Fh, 00h
		db	 00h,0FFh,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Fh, 5Fh, 00h
		db	 00h,0FFh,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Fh, 5Fh, 00h
		db	 00h,0FFh,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Fh, 5Fh, 00h
		db	 00h,0FFh,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Fh, 5Fh, 00h
		db	 00h,0FFh,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0FCh, 00h, 03h,0D7h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h,0D7h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h,0F5h, 00h
		db	 03h,0FFh,0FCh,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 3Fh, 00h
		db	 0Fh,0FFh,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h, 00h
		db	0FFh,0FFh, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 3Fh,0F0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 03h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 0Fh, 00h, 00h, 5Fh,0FFh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0C0h, 00h
		db	 3Dh, 00h, 00h, 7Fh,0FFh, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0C0h, 00h
		db	 3Dh, 00h, 00h, 7Fh,0FFh, 0Fh
		db	0FFh,0F0h, 00h,0FFh, 00h, 00h
		db	0F5h, 00h, 00h,0FFh,0FFh, 03h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	0F5h, 00h, 00h,0FFh,0FFh, 03h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	0F5h, 00h, 00h,0FFh,0FFh, 03h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	0F5h, 00h, 00h,0FFh,0FFh, 03h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	0F5h, 00h, 00h,0FFh,0FFh, 03h
		db	0FFh,0FCh, 00h,0FFh,0C0h, 00h
		db	 3Dh, 00h, 00h, 7Fh,0FFh, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0C0h, 00h
		db	 3Dh, 00h, 00h, 7Fh,0FFh, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0F0h, 00h
		db	 0Fh, 00h, 00h, 5Fh,0FFh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FCh, 00h
		db	 03h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 3Fh,0F0h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 3Fh
		db	0FFh, 0Fh,0FFh,0F0h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0F5h
		db	0FFh, 03h,0FFh,0FCh, 00h,0FFh
		db	0FCh, 00h, 03h, 00h, 00h,0D7h
		db	0FFh, 00h,0FFh,0FFh, 00h,0FFh
		db	0FCh, 00h, 03h, 00h, 00h,0D7h
		db	0FFh, 00h,0FFh,0FFh, 00h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 5Fh
		db	0FFh, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 5Fh
		db	0FFh, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 5Fh
		db	0FFh, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 5Fh
		db	0FFh, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 5Fh
		db	0FFh, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0FCh, 00h, 03h, 00h, 00h,0D7h
		db	0FFh, 00h,0FFh,0FFh, 00h,0FFh
		db	0FCh, 00h, 03h, 00h, 00h,0D7h
		db	0FFh, 00h,0FFh,0FFh, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0F5h
		db	0FFh, 03h,0FFh,0FCh, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 3Fh
		db	0FFh, 0Fh,0FFh,0F0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 15h, 0Fh,0FFh, 50h, 00h,0FCh
		db	 00h, 01h, 55h, 00h,0FFh, 55h
		db	 00h,0F0h, 00h, 05h,0F5h, 00h
		db	 3Fh, 55h, 40h,0C0h, 00h, 17h
		db	0D5h, 00h, 0Fh, 55h, 50h,0C0h
		db	 00h, 17h,0D5h, 00h, 0Fh, 55h
		db	 50h, 00h, 00h, 5Fh, 55h, 00h
		db	 03h, 55h, 54h, 00h, 00h, 5Fh
		db	 55h, 00h, 03h, 55h, 54h, 00h
		db	 00h, 5Fh, 55h, 00h, 03h, 55h
		db	 54h, 00h, 00h, 5Fh, 55h, 00h
		db	 03h, 55h, 54h, 00h, 00h, 5Fh
		db	 55h, 00h, 03h, 55h, 54h,0C0h
		db	 00h, 17h,0D5h, 00h, 0Fh, 55h
		db	 50h,0C0h, 00h, 17h,0D5h, 00h
		db	 0Fh, 55h, 50h,0F0h, 00h, 05h
		db	0F5h, 00h, 3Fh, 55h, 40h,0FCh
		db	 00h, 01h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0C0h, 00h, 15h, 0Fh
		db	0FFh, 50h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 5Fh, 00h, 03h, 55h
		db	 54h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 7Dh, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 7Dh, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h,0F5h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 05h,0F5h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 05h,0F5h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 05h,0F5h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 05h,0F5h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FCh
		db	 00h, 01h, 7Dh, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 7Dh, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 5Fh, 00h, 03h, 55h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 15h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h,0F5h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0C0h, 00h, 17h, 00h
		db	 00h,0D5h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0C0h, 00h, 17h, 00h
		db	 00h,0D5h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh, 00h, 00h, 5Fh, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 5Fh, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 5Fh, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 5Fh, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 5Fh, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh,0C0h, 00h, 17h, 00h
		db	 00h,0D5h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0C0h, 00h, 17h, 00h
		db	 00h,0D5h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h,0F5h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 15h, 50h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 15h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 5Fh, 55h, 03h
		db	0FFh, 54h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 7Dh, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 7Dh, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h,0F5h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h,0F5h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h,0F5h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h,0F5h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h,0F5h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 7Dh, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 7Dh, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 5Fh, 55h, 03h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 15h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0C0h, 00h
		db	 3Fh, 0Fh,0FFh,0F0h, 00h,0FFh
		db	0C0h, 00h, 3Fh, 0Fh,0FFh,0B0h
		db	 00h,0FFh,0C0h, 00h, 3Eh, 0Fh
		db	0FFh,0B0h, 00h,0FFh,0F0h, 00h
		db	 0Fh, 3Fh,0FFh,0C0h, 00h,0C0h
		db	0FCh, 3Fh, 03h,0FCh, 0Fh, 03h
		db	0F0h, 00h, 3Ch,0FFh,0C3h,0F0h
		db	 03h, 0Fh,0FCh, 00h, 00h,0FEh
		db	0D5h, 00h, 03h, 5Fh,0ECh, 00h
		db	 3Ch,0FAh,0C3h,0F0h, 03h, 0Fh
		db	0ACh,0C0h,0FCh, 3Fh, 03h,0FCh
		db	 0Fh, 03h,0F0h,0FFh,0F0h, 00h
		db	 0Fh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	0C0h, 00h, 3Fh, 0Fh,0FFh,0F0h
		db	 00h,0FFh,0C0h, 00h, 3Fh, 0Fh
		db	0FFh,0B0h, 00h,0FFh,0C0h, 00h
		db	 3Eh, 0Fh,0FFh,0B0h, 00h,0FFh
		db	0F0h, 00h, 0Fh, 3Fh,0FFh,0C0h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FFh, 3Fh, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0FEh,0C0h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 03h
		db	0F0h, 00h, 3Fh,0FAh,0C0h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 0Fh
		db	0FCh,0C0h,0FFh, 3Fh, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 0Fh
		db	0ECh,0CFh,0FFh, 30h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 0Fh
		db	0ADh, 0Fh, 03h, 70h,0FCh,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 03h
		db	0F0h, 00h, 00h,0D7h,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 3Ch, 00h,0C3h,0FBh,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 0Fh, 3Ch, 00h,0C3h,0EBh,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 3Fh, 0Fh, 03h,0F0h,0FCh,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 3Fh, 0Fh,0FFh,0B0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 3Eh, 0Fh,0FFh,0B0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 0Fh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0C0h, 00h
		db	 3Fh,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0FFh, 3Fh, 00h,0C0h
		db	0FFh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	 00h, 00h,0FEh, 3Fh, 00h,0C0h
		db	0FEh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	 00h, 00h,0FAh, 3Fh, 00h,0C0h
		db	0FAh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	0C0h, 00h, 3Fh, 3Fh, 00h, 40h
		db	 7Fh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0CCh,0FFh, 11h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F3h,0FFh, 04h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0CCh,0FFh, 11h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 3Fh, 3Fh, 00h, 40h
		db	 7Fh,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0FFh, 3Fh, 00h,0C0h
		db	0FFh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	 00h, 00h,0FEh, 3Fh, 00h,0C0h
		db	0FEh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	 00h, 00h,0FAh, 3Fh, 00h,0C0h
		db	0FAh, 3Fh,0FFh,0C0h, 00h,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0C0h, 00h
		db	 3Fh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 3Fh, 0Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 3Fh,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 3Fh,0B0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 3Eh,0B0h, 03h,0FFh,0FCh
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 3Ch, 0Fh,0C3h, 00h,0FFh,0FFh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 3Ch, 00h,0C3h, 00h,0FFh,0FBh
		db	 00h,0FFh,0FCh, 00h, 03h, 0Fh
		db	 00h,0F0h,0D7h, 00h,0FFh,0EBh
		db	 00h,0FFh,0F0h, 00h, 0Fh, 00h
		db	 0Fh,0FDh, 70h, 03h,0FFh,0FCh
		db	 00h,0FFh,0F0h, 00h, 0Fh, 03h
		db	0CFh,0ECh, 30h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 03h
		db	0C0h,0ACh, 3Fh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h, 0Fh
		db	 00h,0F0h,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0FEh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0FAh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh,0ADh
		db	 08h,0B2h, 00h, 4Ch, 03h,0B0h
		db	 55h, 55h, 50h, 05h, 50h, 01h
		db	 41h, 05h, 01h, 55h, 55h, 01h
		db	 55h, 0Dh, 00h,0B2h, 00h, 13h
		db	 00h,0B0h, 6Ah,0AAh,0A0h, 1Ah
		db	0A8h, 01h, 81h, 06h, 01h,0AAh
		db	0AAh, 01h,0AAh, 80h, 0Eh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 18h, 18h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 81h, 80h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 18h, 18h, 01h
		db	 81h, 06h, 01h, 80h, 00h, 01h
		db	 80h, 60h, 0Dh, 00h,0B2h, 00h
		db	 13h, 00h,0B0h, 60h, 00h, 60h
		db	 06h, 01h, 81h, 06h, 01h, 80h
		db	 00h, 01h, 80h, 60h, 0Dh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 60h, 06h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 80h, 60h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 60h, 06h, 01h
		db	 81h, 06h, 01h, 80h, 00h, 01h
		db	 80h, 60h, 0Dh, 00h,0B2h, 00h
		db	 13h, 00h,0B0h, 60h, 00h, 60h
		db	 06h, 01h, 81h, 06h, 01h, 80h
		db	 00h, 01h, 80h, 60h, 0Dh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 60h, 06h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 80h, 60h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 60h, 06h, 01h
		db	 81h, 06h, 01h, 80h, 00h, 01h
		db	 80h, 60h, 0Dh, 00h,0B2h, 00h
		db	 13h, 00h,0B0h, 60h, 00h, 60h
		db	 06h, 01h, 81h, 06h, 01h, 80h
		db	 00h, 01h, 80h, 60h, 0Dh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 60h, 06h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 80h, 60h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 60h, 06h, 01h
		db	 81h, 06h, 01h, 95h, 40h, 01h
		db	 95h, 80h, 0Dh, 00h,0B2h, 00h
		db	 13h, 00h,0B0h, 60h, 00h, 60h
		db	 06h, 01h, 81h, 06h, 01h,0AAh
		db	 80h, 01h,0AAh, 80h, 0Dh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 60h, 06h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 98h, 0Ch
		db	 00h,0B2h, 00h, 14h, 00h,0B0h
		db	 60h, 00h, 60h, 06h, 01h, 81h
		db	 06h, 01h, 80h, 00h, 01h, 98h
		db	 0Ch, 00h,0B2h, 00h, 14h, 00h
		db	0B0h, 60h, 00h, 60h, 06h, 01h
		db	 81h, 06h, 01h, 80h, 00h, 01h
		db	 86h, 0Ch, 00h,0B2h, 00h, 14h
		db	 00h,0B0h, 60h, 00h, 60h, 06h
		db	 01h, 81h, 06h, 01h, 80h, 00h
		db	 01h, 86h, 0Ch, 00h,0B2h, 00h
		db	 14h, 00h,0B0h, 60h, 00h, 60h
		db	 06h, 01h, 81h, 06h, 01h, 80h
		db	 00h, 01h, 86h, 0Ch, 00h,0B2h
		db	 00h, 14h, 00h,0B0h, 60h, 00h
		db	 60h, 06h, 01h, 81h, 06h, 01h
		db	 80h, 00h, 01h, 86h, 0Ch, 00h
		db	0B2h, 00h, 14h, 00h,0B0h, 60h
		db	 00h, 60h, 06h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 81h, 80h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 60h, 06h, 01h
		db	 81h, 06h, 01h, 80h, 00h, 01h
		db	 81h, 80h, 0Dh, 00h,0B2h, 00h
		db	 13h, 00h,0B0h, 60h, 00h, 60h
		db	 06h, 01h, 81h, 06h, 01h, 80h
		db	 00h, 01h, 81h, 80h, 0Dh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 60h, 06h, 01h, 81h, 06h
		db	 01h, 80h, 00h, 01h, 81h, 80h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 18h, 18h, 01h
		db	 81h, 06h, 01h, 80h, 00h, 01h
		db	 80h, 60h, 0Dh, 00h,0B2h, 00h
		db	 13h, 00h,0B0h, 60h, 00h, 18h
		db	 18h, 01h, 86h, 86h, 01h, 80h
		db	 00h, 01h, 80h, 60h, 0Dh, 00h
		db	0B2h, 00h, 13h, 00h,0B0h, 60h
		db	 00h, 19h, 68h, 00h, 58h, 58h
		db	 01h, 95h, 55h, 01h, 80h, 60h
		db	 0Dh, 00h,0B2h, 00h, 13h, 00h
		db	0B0h, 60h, 00h, 06h,0A0h, 00h
		db	 68h, 68h, 01h,0AAh,0AAh, 01h
		db	 80h, 60h, 0Dh, 00h,0B2h, 00h
		db	0D0h, 00h,0B0h, 03h, 00h, 00h
		db	 00h, 00h, 00h, 3Fh,0FCh
		db	7 dup (0)
		db	 3Fh, 10h, 00h,0B2h, 00h, 10h
		db	 00h,0B0h, 3Fh,0C0h,0FFh,0C0h
		db	 00h, 03h,0FFh,0FCh
		db	7 dup (0)
		db	 3Fh,0FCh, 00h, 00h, 00h, 3Fh
		db	0F0h, 16h, 00h,0B2h, 00h, 09h
		db	 00h,0B0h, 03h,0FCh, 0Fh,0FFh
		db	0FCh, 00h, 3Fh, 00h,0FFh, 0Fh
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	 3Fh,0FFh,0FCh, 00h, 0Fh,0FFh
		db	0FCh, 17h, 00h,0B2h, 00h, 09h
		db	 00h,0B0h, 3Fh,0C0h, 3Fh,0C0h
		db	 3Fh,0C3h,0FCh, 00h,0FCh, 0Fh
		db	0F0h, 00h,0FCh, 00h, 00h, 00h
		db	 3Fh, 03h,0FFh,0F0h,0FFh,0C0h
		db	0FFh, 17h, 00h,0B2h, 00h, 08h
		db	 00h,0B0h, 03h,0FFh, 00h, 3Fh
		db	 00h, 0Fh,0CFh,0F0h, 00h,0FCh
		db	 3Fh,0FFh, 00h,0FCh, 00h, 00h
		db	 00h,0FFh, 00h, 03h,0FCh,0FCh
		db	 00h, 3Fh, 18h, 00h,0B2h, 00h
		db	 08h, 00h,0B0h, 0Fh,0FFh,0C0h
		db	0FFh, 00h, 03h,0C3h,0F0h, 03h
		db	0F0h, 3Fh, 0Fh,0F0h, 3Fh, 00h
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	0FCh, 00h, 3Fh, 18h, 00h,0B2h
		db	 00h, 08h, 00h,0B0h,0FFh,0FFh
		db	0C0h,0FCh, 00h, 03h,0F3h,0FCh
		db	 0Fh,0C0h,0FCh, 00h,0FCh, 3Fh
		db	 00h, 00h, 00h,0FFh,0FCh, 00h
		db	 00h,0FFh, 00h
		db	3Fh
		db	7 dup (0)
		db	 0Fh,0F0h,0FFh,0C0h,0FCh, 00h
		db	 03h,0F0h,0FCh,0FCh, 00h,0FCh
		db	 00h, 3Fh, 3Fh, 00h, 00h, 03h
		db	0FFh,0FFh,0F0h, 00h, 3Fh, 0Fh
		db	0FCh
		db	7 dup (0)
		db	 0Fh, 00h,0FFh,0F0h,0FCh, 00h
		db	 03h,0F0h,0FFh,0C0h, 03h,0FFh
		db	 00h, 3Fh, 3Fh, 00h, 00h, 03h
		db	0FCh, 03h,0FCh, 00h, 3Fh,0FFh
		db	0FFh, 58h, 00h,0B2h, 00h, 09h
		db	 00h,0B0h, 3Fh,0F0h, 3Fh, 00h
		db	 0Fh,0C0h, 3Fh, 00h, 03h,0FFh
		db	0F0h, 3Fh, 0Fh,0C0h, 00h, 0Fh
		db	0F0h, 00h, 30h, 00h, 3Fh,0F0h
		db	 3Fh,0F0h, 18h, 00h,0B2h, 00h
		db	 08h, 00h,0B0h, 3Fh,0FCh, 3Fh
		db	 00h, 3Fh,0C0h, 3Fh,0C0h, 0Fh
		db	0C0h,0FFh,0FFh, 0Fh,0C0h,0FFh
		db	0CFh,0FCh, 00h, 00h, 00h, 0Fh
		db	0C0h, 03h,0FCh, 18h, 00h,0B2h
		db	 00h, 08h, 00h,0B0h, 0Fh,0FCh
		db	 0Fh,0FFh,0FFh, 00h, 0Fh,0C0h
		db	 0Fh,0C0h, 0Fh,0FCh, 0Fh,0FFh
		db	0FFh,0C0h,0FFh,0F0h, 00h, 00h
		db	 0Fh,0C0h, 00h, 30h, 18h, 00h
		db	0B2h, 00h, 08h, 00h,0B0h, 0Fh
		db	0FFh, 00h,0FFh,0F0h, 00h, 0Fh
		db	0F0h, 3Fh, 00h, 00h, 00h, 0Fh
		db	0FFh,0C0h, 00h, 03h,0FFh,0C0h
		db	 00h, 0Fh,0C0h, 16h, 00h,0B2h
		db	 00h, 0Ah, 00h,0B0h, 03h,0F0h
		db	 00h, 00h, 00h, 00h, 03h, 00h
		db	 03h, 00h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 00h, 0Fh,0FCh, 00h
		db	 0Fh,0C0h, 16h, 00h,0B2h, 00h
		db	 0Ah, 00h,0B0h, 03h, 01h, 00h
		db	0B2h, 00h, 11h, 00h,0B0h, 3Ch
		db	 01h, 00h,0B2h, 00h, 28h, 00h
		db	0B0h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 03h,0FFh, 54h
		db	 00h,0FCh, 00h, 01h, 40h, 00h
		db	 3Fh, 01h, 40h,0F0h, 00h, 04h
		db	 00h, 00h, 0Fh,0FCh, 10h,0C0h
		db	 00h, 10h, 16h, 00h, 03h, 0Fh
		db	0C4h, 00h, 00h, 4Ch, 5Ah, 00h
		db	 00h, 8Fh,0F1h, 00h, 00h, 31h
		db	 6Ch, 00h, 00h, 23h,0FCh, 00h
		db	 00h,0F1h, 60h, 00h, 00h, 23h
		db	0FFh, 00h, 00h,0F1h,0A0h, 00h
		db	 00h, 23h,0FFh, 00h, 00h, 3Ch
		db	 6Ah, 00h, 00h, 8Fh,0FCh, 00h
		db	 00h, 40h, 2Ah, 00h, 00h, 0Fh
		db	0C1h,0C0h, 00h, 14h, 00h, 00h
		db	 03h,0FCh, 14h,0F0h, 00h, 05h
		db	 40h, 00h, 0Fh, 01h, 50h,0FFh
		db	 00h, 00h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 14h, 00h
		db	 03h, 00h, 14h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 40h, 00h
		db	 00h, 0Fh,0C1h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 01h, 00h
		db	 00h, 60h,0FCh, 3Fh,0FFh, 40h
		db	 00h,0F0h, 00h, 04h,0C5h, 00h
		db	 00h,0A8h,0FFh, 0Fh,0FFh, 10h
		db	 00h,0F0h, 00h, 03h, 16h, 00h
		db	 00h,0C2h, 3Fh, 0Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Fh, 16h, 00h
		db	 00h, 02h, 3Fh, 0Fh,0FFh,0F0h
		db	 00h,0F0h, 00h, 0Fh, 1Ah, 00h
		db	 00h, 02h, 3Fh, 0Fh,0FFh,0F0h
		db	 00h,0F0h, 00h, 03h,0C6h, 00h
		db	 00h,0A8h,0FFh, 0Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 04h, 02h, 00h
		db	 00h,0A0h,0FCh, 0Fh,0FFh, 10h
		db	 00h,0FCh, 00h, 01h, 40h, 00h
		db	 00h, 0Fh,0C1h, 3Fh,0FFh, 40h
		db	 00h,0FFh, 00h, 00h, 54h, 00h
		db	 00h, 00h, 15h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 0Fh, 55h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 03h, 15h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 40h, 01h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 00h,0FCh, 0Fh
		db	0FFh, 10h, 00h,0FFh,0C0h, 00h
		db	 10h, 00h, 00h, 16h, 0Fh, 03h
		db	0FFh,0C4h, 00h,0FFh, 00h, 00h
		db	 4Ch, 00h, 00h, 5Ah, 8Fh, 00h
		db	0FFh,0F1h, 00h,0FFh, 00h, 00h
		db	 31h, 00h, 00h, 6Ch, 23h, 00h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	0F1h, 00h, 00h, 60h, 23h, 00h
		db	0FFh,0FFh, 00h,0FFh, 00h, 00h
		db	0F1h, 00h, 00h,0A0h, 23h, 00h
		db	0FFh,0FFh, 00h,0FFh, 00h, 00h
		db	 3Ch, 00h, 00h, 6Ah, 8Fh, 00h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	 40h, 00h, 00h, 2Ah, 0Fh, 00h
		db	0FFh,0C1h, 00h,0FFh,0C0h, 00h
		db	 14h, 00h, 00h, 00h,0FCh, 03h
		db	0FFh, 14h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 40h, 01h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 14h
		db	 00h, 03h,0FFh, 14h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 40h
		db	 0Fh, 00h,0FFh,0C1h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 01h
		db	 60h, 00h, 3Fh,0FCh, 40h,0FFh
		db	0F0h, 00h, 04h, 00h, 00h,0C5h
		db	0A8h, 00h, 0Fh,0FFh, 10h,0FFh
		db	0F0h, 00h, 03h, 00h, 00h, 16h
		db	0C2h, 00h, 0Fh, 3Fh,0C0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 16h
		db	 02h, 00h, 0Fh, 3Fh,0F0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h, 1Ah
		db	 02h, 00h, 0Fh, 3Fh,0F0h,0FFh
		db	0F0h, 00h, 03h, 00h, 00h,0C6h
		db	0A8h, 00h, 0Fh,0FFh,0C0h,0FFh
		db	0F0h, 00h, 04h, 00h, 00h, 02h
		db	0A0h, 00h, 0Fh,0FCh, 10h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 40h
		db	 0Fh, 00h, 3Fh,0C1h, 40h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 54h
		db	 00h, 00h,0FFh, 15h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 15h, 03h,0FFh, 54h, 00h,0FCh
		db	 00h, 01h, 55h, 00h, 3Fh, 55h
		db	 40h,0F0h, 00h, 05h, 55h, 00h
		db	 0Fh, 55h, 50h,0C0h, 00h, 15h
		db	 55h, 00h, 03h, 55h, 54h, 00h
		db	 00h, 55h, 00h, 00h, 00h, 00h
		db	 55h, 00h, 00h, 40h, 5Bh, 00h
		db	 00h, 08h, 01h, 00h, 00h, 3Ch
		db	 58h, 00h, 00h, 08h,0FCh, 00h
		db	 00h,0FCh, 68h, 00h, 00h, 08h
		db	0FFh, 00h, 00h, 3Fh, 1Ah, 00h
		db	 00h,0A3h,0FCh, 00h, 00h, 43h
		db	 0Ah, 00h, 00h, 83h,0C1h,0C0h
		db	 00h, 14h, 30h, 00h, 03h, 3Ch
		db	 14h,0F0h, 00h, 05h, 40h, 00h
		db	 0Fh, 01h, 50h,0FFh, 00h, 00h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 3Fh, 55h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 00h, 03h, 55h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 55h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 05h, 50h, 00h, 00h, 00h
		db	 05h, 0Fh,0FFh, 50h, 00h,0F0h
		db	 00h, 04h, 05h, 00h, 00h,0B0h
		db	 80h, 0Fh,0FFh, 10h, 00h,0F0h
		db	 00h, 03h,0C5h, 00h, 00h, 80h
		db	 8Fh, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 0Fh,0C6h, 00h, 00h, 80h
		db	 8Fh, 0Fh,0FFh,0F0h, 00h,0F0h
		db	 00h, 03h,0F1h, 00h, 00h,0AAh
		db	 3Fh, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 04h, 30h, 00h, 00h,0A8h
		db	 3Ch, 0Fh,0FFh, 10h, 00h,0FCh
		db	 00h, 01h, 43h, 00h, 00h, 03h
		db	0C1h, 3Fh,0FFh, 40h, 00h,0FFh
		db	 00h, 00h, 54h, 00h, 00h, 00h
		db	 15h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 03h, 15h, 54h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 55h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0C0h, 00h, 15h, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 00h, 00h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h, 40h, 00h
		db	 00h, 5Bh, 08h, 00h,0FFh, 01h
		db	 00h,0FFh, 00h, 00h, 3Ch, 00h
		db	 00h, 58h, 08h, 00h,0FFh,0FCh
		db	 00h,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 68h, 08h, 00h,0FFh,0FFh
		db	 00h,0FFh, 00h, 00h, 3Fh, 00h
		db	 00h, 1Ah,0A3h, 00h,0FFh,0FCh
		db	 00h,0FFh, 00h, 00h, 43h, 00h
		db	 00h, 0Ah, 83h, 00h,0FFh,0C1h
		db	 00h,0FFh,0C0h, 00h, 14h, 00h
		db	 00h, 30h, 3Ch, 03h,0FFh, 14h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 40h, 01h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 15h, 55h, 03h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 55h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 50h, 00h, 00h
		db	 0Fh, 05h, 50h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 05h,0B0h, 00h
		db	 0Fh, 80h, 10h,0FFh,0F0h, 00h
		db	 03h, 00h, 00h,0C5h, 80h, 00h
		db	 0Fh, 8Fh,0C0h,0FFh,0F0h, 00h
		db	 0Fh, 00h, 00h,0C6h, 80h, 00h
		db	 0Fh, 8Fh,0F0h,0FFh,0F0h, 00h
		db	 03h, 00h, 00h,0F1h,0AAh, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 30h,0A8h, 00h
		db	 0Fh, 3Ch, 10h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 43h, 03h, 00h
		db	 3Fh,0C1h, 40h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 54h, 00h, 00h
		db	0FFh, 15h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 15h, 03h
		db	0FFh, 54h, 00h,0FCh, 00h, 01h
		db	 55h, 00h, 3Fh, 55h, 40h,0F0h
		db	 00h, 05h, 55h, 00h, 0Fh, 55h
		db	 50h,0C0h, 00h, 15h, 55h, 00h
		db	 03h, 55h, 54h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 54h, 00h, 00h
		db	 00h, 00h, 15h, 00h, 00h, 43h
		db	 1Ah, 00h, 00h, 02h, 01h, 00h
		db	 00h, 3Fh,0C6h, 00h, 00h,0A8h
		db	0FCh, 00h, 00h, 43h,0C2h, 00h
		db	 00h,0A0h,0C1h,0C0h, 00h, 14h
		db	 3Ch, 00h, 03h, 0Ch, 14h,0F0h
		db	 00h, 05h, 40h, 00h, 0Fh, 01h
		db	 50h,0FFh, 00h, 00h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 3Fh, 55h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 15h, 00h, 03h, 55h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h, 00h, 00h, 55h, 55h, 3Fh
		db	0FFh, 40h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 05h
		db	 40h, 00h, 00h, 00h, 01h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 04h
		db	 31h, 00h, 00h,0A0h, 20h, 0Fh
		db	0FFh, 10h, 00h,0F0h, 00h, 03h
		db	0FCh, 00h, 00h, 6Ah, 8Fh, 0Fh
		db	0FFh,0C0h, 00h,0F0h, 00h, 04h
		db	 3Ch, 00h, 00h, 2Ah, 0Ch, 0Fh
		db	0FFh, 10h, 00h,0FCh, 00h, 01h
		db	 43h, 00h, 00h,0C0h,0C1h, 3Fh
		db	0FFh, 40h, 00h,0FFh, 00h, 00h
		db	 54h, 00h, 00h, 00h, 15h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 0Fh, 55h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 03h, 15h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0C0h, 00h, 15h, 00h, 00h, 55h
		db	 55h, 03h,0FFh, 54h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 54h, 00h, 00h, 00h
		db	 00h, 00h,0FFh, 15h, 00h,0FFh
		db	 00h, 00h, 43h, 00h, 00h, 1Ah
		db	 02h, 00h,0FFh, 01h, 00h,0FFh
		db	 00h, 00h, 3Fh, 00h, 00h,0C6h
		db	0A8h, 00h,0FFh,0FCh, 00h,0FFh
		db	 00h, 00h, 43h, 00h, 00h,0C2h
		db	0A0h, 00h,0FFh,0C1h, 00h,0FFh
		db	0C0h, 00h, 14h, 00h, 00h, 3Ch
		db	 0Ch, 03h,0FFh, 14h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 40h
		db	 01h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 15h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 55h, 55h, 00h, 3Fh, 55h
		db	 40h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 40h, 00h, 00h, 0Fh, 01h
		db	 50h,0FFh,0F0h, 00h, 04h, 00h
		db	 00h, 31h,0A0h, 00h, 0Fh, 20h
		db	 10h,0FFh,0F0h, 00h, 03h, 00h
		db	 00h,0FCh, 6Ah, 00h, 0Fh, 8Fh
		db	0C0h,0FFh,0F0h, 00h, 04h, 00h
		db	 00h, 3Ch, 2Ah, 00h, 0Fh, 0Ch
		db	 10h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 43h,0C0h, 00h, 3Fh,0C1h
		db	 40h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 54h, 00h, 00h,0FFh, 15h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 03h,0FFh, 54h
		db	 00h,0FCh, 00h, 01h, 55h, 00h
		db	 3Fh, 55h, 40h,0F0h, 00h, 05h
		db	 55h, 00h, 0Fh, 55h, 50h,0C0h
		db	 00h, 15h, 55h, 00h, 03h, 55h
		db	 54h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 15h, 55h, 00h
		db	 00h, 55h, 54h, 00h, 00h, 41h
		db	 55h, 00h, 00h, 55h, 41h, 00h
		db	 00h, 54h, 15h, 00h, 00h, 54h
		db	 15h,0C0h, 00h, 15h, 40h, 00h
		db	 03h, 01h, 54h,0F0h, 00h, 05h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	 00h, 00h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 15h, 00h
		db	 03h, 55h, 54h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h, 00h
		db	 00h, 55h, 55h, 3Fh,0FFh, 40h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0F0h, 00h, 01h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 40h
		db	 00h,0F0h, 00h, 04h, 15h, 00h
		db	 00h, 55h, 54h, 0Fh,0FFh, 10h
		db	 00h,0F0h, 00h, 05h, 41h, 00h
		db	 00h, 55h, 41h, 0Fh,0FFh, 50h
		db	 00h,0FCh, 00h, 01h, 54h, 00h
		db	 00h, 00h, 15h, 3Fh,0FFh, 40h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 0Fh, 55h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 03h, 15h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 55h, 55h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0C0h, 00h
		db	 15h, 00h, 00h, 55h, 55h, 03h
		db	0FFh, 54h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh, 00h, 00h
		db	 15h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 54h, 00h,0FFh, 00h, 00h
		db	 41h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 41h, 00h,0FFh, 00h, 00h
		db	 54h, 00h, 00h, 15h, 54h, 00h
		db	0FFh, 15h, 00h,0FFh,0C0h, 00h
		db	 15h, 00h, 00h, 40h, 01h, 03h
		db	0FFh, 54h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 15h
		db	 55h, 03h,0FFh, 54h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 55h
		db	 55h, 00h, 3Fh, 55h, 40h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	0F0h, 00h, 01h, 00h, 00h, 55h
		db	 55h, 00h, 0Fh, 55h, 40h,0FFh
		db	0F0h, 00h, 04h, 00h, 00h, 15h
		db	 55h, 00h, 0Fh, 54h, 10h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 41h
		db	 55h, 00h, 0Fh, 41h, 50h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 54h
		db	 00h, 00h, 3Fh, 15h, 40h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 15h, 03h,0FFh, 54h, 00h,0FCh
		db	 00h, 01h, 55h, 00h, 3Fh, 55h
		db	 40h,0F0h, 00h, 05h, 55h, 00h
		db	 0Fh, 55h, 50h,0C0h, 00h, 15h
		db	 55h, 00h, 03h, 55h, 54h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 54h
		db	 00h, 00h, 00h, 00h, 15h, 00h
		db	 00h, 43h,0F1h, 00h, 00h,0A0h
		db	 01h, 00h, 00h, 3Fh,0FCh, 00h
		db	 00h, 6Ah, 8Ch, 00h, 00h, 43h
		db	0FCh, 00h, 00h, 2Ah, 01h,0C0h
		db	 00h, 14h, 3Fh, 00h, 03h,0C0h
		db	 14h,0F0h, 00h, 05h, 40h, 00h
		db	 0Fh, 01h, 50h,0FFh, 00h, 00h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 3Fh, 55h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 00h, 03h, 55h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 55h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 05h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0F0h
		db	 00h, 05h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0F0h
		db	 00h, 05h, 40h, 00h, 00h, 00h
		db	 01h, 0Fh,0FFh, 50h, 00h,0F0h
		db	 00h, 04h, 3Fh, 00h, 00h, 1Ah
		db	 00h, 0Fh,0FFh, 10h, 00h,0F0h
		db	 00h, 03h,0FFh, 00h, 00h,0C6h
		db	0A8h, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 04h, 3Fh, 00h, 00h,0C2h
		db	0A0h, 0Fh,0FFh, 10h, 00h,0FCh
		db	 00h, 01h, 43h, 00h, 00h,0FCh
		db	 01h, 3Fh,0FFh, 40h, 00h,0FFh
		db	 00h, 00h, 54h, 00h, 00h, 00h
		db	 15h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 03h, 15h, 54h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 55h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0C0h, 00h, 15h, 00h
		db	 00h, 55h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h, 54h, 00h
		db	 00h, 00h, 00h, 00h,0FFh, 15h
		db	 00h,0FFh, 00h, 00h, 43h, 00h
		db	 00h,0F1h,0A0h, 00h,0FFh, 01h
		db	 00h,0FFh, 00h, 00h, 3Fh, 00h
		db	 00h,0FCh, 6Ah, 00h,0FFh, 8Ch
		db	 00h,0FFh, 00h, 00h, 43h, 00h
		db	 00h,0FCh, 2Ah, 00h,0FFh, 01h
		db	 00h,0FFh,0C0h, 00h, 14h, 00h
		db	 00h, 3Fh,0C0h, 03h,0FFh, 14h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 40h, 01h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 15h, 55h, 03h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 55h, 55h, 00h
		db	 3Fh, 55h, 40h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 40h, 00h, 00h
		db	 0Fh, 01h, 50h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 3Fh, 1Ah, 00h
		db	 0Fh, 00h, 10h,0FFh,0F0h, 00h
		db	 03h, 00h, 00h,0FFh,0C6h, 00h
		db	 0Fh,0A8h,0C0h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 3Fh,0C2h, 00h
		db	 0Fh,0A0h, 10h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 43h,0FCh, 00h
		db	 3Fh, 01h, 40h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 54h, 00h, 00h
		db	0FFh, 15h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 15h, 03h
		db	0FFh, 54h, 00h,0FCh, 00h, 01h
		db	 55h, 00h, 3Fh, 55h, 40h,0F0h
		db	 00h, 05h, 55h, 00h, 0Fh, 55h
		db	 50h,0C0h, 00h, 15h, 55h, 00h
		db	 03h, 55h, 54h, 00h, 00h, 55h
		db	 00h, 00h, 00h, 00h, 55h, 00h
		db	 00h, 40h,0C5h, 00h, 00h,0B0h
		db	 01h, 00h, 00h, 3Fh,0C5h, 00h
		db	 00h, 80h, 8Ch, 00h, 00h,0FFh
		db	0C6h, 00h, 00h, 80h, 8Fh, 00h
		db	 00h, 3Fh,0F1h, 00h, 00h,0AAh
		db	 3Ch, 00h, 00h, 43h,0F0h, 00h
		db	 00h,0A8h, 01h,0C0h, 00h, 14h
		db	 3Fh, 00h, 03h, 00h, 14h,0F0h
		db	 00h, 05h, 40h, 00h, 0Fh, 01h
		db	 50h,0FFh, 00h, 00h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 3Fh, 55h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 15h, 00h, 03h, 55h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h, 00h, 00h, 55h, 55h, 3Fh
		db	0FFh, 40h, 00h,0F0h, 00h, 05h
		db	 50h, 00h, 00h, 00h, 05h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 04h
		db	 0Ch, 00h, 00h, 5Bh, 00h, 0Fh
		db	0FFh, 10h, 00h,0F0h, 00h, 03h
		db	0FCh, 00h, 00h, 58h, 08h, 0Fh
		db	0FFh,0C0h, 00h,0F0h, 00h, 0Fh
		db	0FCh, 00h, 00h, 68h, 08h, 0Fh
		db	0FFh,0F0h, 00h,0F0h, 00h, 03h
		db	0FFh, 00h, 00h, 1Ah,0A3h, 0Fh
		db	0FFh,0C0h, 00h,0F0h, 00h, 04h
		db	 3Fh, 00h, 00h, 0Ah, 80h, 0Fh
		db	0FFh, 10h, 00h,0FCh, 00h, 01h
		db	 43h, 00h, 00h,0F0h, 01h, 3Fh
		db	0FFh, 40h, 00h,0FFh, 00h, 00h
		db	 54h, 00h, 00h, 00h, 15h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 0Fh, 55h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 03h, 15h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0C0h, 00h, 15h, 00h, 00h, 55h
		db	 55h, 03h,0FFh, 54h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 40h, 00h, 00h,0C5h
		db	0B0h, 00h,0FFh, 01h, 00h,0FFh
		db	 00h, 00h, 3Fh, 00h, 00h,0C5h
		db	 80h, 00h,0FFh, 8Ch, 00h,0FFh
		db	 00h, 00h,0FFh, 00h, 00h,0C6h
		db	 80h, 00h,0FFh, 8Fh, 00h,0FFh
		db	 00h, 00h, 3Fh, 00h, 00h,0F1h
		db	0AAh, 00h,0FFh, 3Ch, 00h,0FFh
		db	 00h, 00h, 43h, 00h, 00h,0F0h
		db	0A8h, 00h,0FFh, 01h, 00h,0FFh
		db	0C0h, 00h, 14h, 00h, 00h, 3Fh
		db	 00h, 03h,0FFh, 14h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 40h
		db	 01h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 15h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 55h, 55h, 00h, 3Fh, 55h
		db	 40h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 50h, 00h, 00h, 0Fh, 05h
		db	 50h,0FFh,0F0h, 00h, 04h, 00h
		db	 00h, 0Ch, 5Bh, 00h, 0Fh, 00h
		db	 10h,0FFh,0F0h, 00h, 03h, 00h
		db	 00h,0FCh, 58h, 00h, 0Fh, 08h
		db	0C0h,0FFh,0F0h, 00h, 0Fh, 00h
		db	 00h,0FCh, 68h, 00h, 0Fh, 08h
		db	0F0h,0FFh,0F0h, 00h, 03h, 00h
		db	 00h,0FFh, 1Ah, 00h, 0Fh,0A3h
		db	0C0h,0FFh,0F0h, 00h, 04h, 00h
		db	 00h, 3Fh, 0Ah, 00h, 0Fh, 80h
		db	 10h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 43h,0F0h, 00h, 3Fh, 01h
		db	 40h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 54h, 00h, 00h,0FFh, 15h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h, 03h,0FFh, 54h
		db	 00h,0FCh, 00h, 01h, 40h, 00h
		db	 3Fh, 01h, 40h,0F0h, 00h, 04h
		db	 3Ch, 00h, 0Fh, 0Ch, 10h,0C0h
		db	 00h, 13h,0C1h, 00h, 03h, 60h
		db	0C4h, 00h, 00h, 4Fh,0C5h, 00h
		db	 00h,0A8h,0F1h, 00h, 00h, 3Fh
		db	 16h, 00h, 00h,0C2h, 3Ch, 00h
		db	 00h,0FFh, 16h, 00h, 00h, 02h
		db	 3Fh, 00h, 00h,0FFh, 1Ah, 00h
		db	 00h, 02h, 3Fh, 00h, 00h, 3Fh
		db	0C6h, 00h, 00h,0A8h,0FCh, 00h
		db	 00h, 43h,0C2h, 00h, 00h,0A0h
		db	0C1h,0C0h, 00h, 14h, 3Ch, 00h
		db	 03h, 0Ch, 14h,0F0h, 00h, 05h
		db	 40h, 00h, 0Fh, 01h, 50h,0FFh
		db	 00h, 00h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 14h, 00h
		db	 03h, 00h, 14h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 43h, 00h
		db	 00h,0C0h,0C1h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 3Ch, 00h
		db	 00h, 16h, 0Ch, 3Fh,0FFh, 40h
		db	 00h,0F0h, 00h, 04h,0FCh, 00h
		db	 00h, 5Ah, 8Fh, 0Fh,0FFh, 10h
		db	 00h,0F0h, 00h, 03h,0F1h, 00h
		db	 00h, 6Ch, 23h, 0Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Fh,0F1h, 00h
		db	 00h, 60h, 23h, 0Fh,0FFh,0F0h
		db	 00h,0F0h, 00h, 0Fh,0F1h, 00h
		db	 00h,0A0h, 23h, 0Fh,0FFh,0F0h
		db	 00h,0F0h, 00h, 03h,0FCh, 00h
		db	 00h, 6Ah, 8Fh, 0Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 04h, 3Ch, 00h
		db	 00h, 2Ah, 0Ch, 0Fh,0FFh, 10h
		db	 00h,0FCh, 00h, 01h, 43h, 00h
		db	 00h,0C0h,0C1h, 3Fh,0FFh, 40h
		db	 00h,0FFh, 00h, 00h, 54h, 00h
		db	 00h, 00h, 15h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 0Fh, 55h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 03h, 15h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 40h, 01h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 3Ch, 0Ch, 0Fh
		db	0FFh, 10h, 00h,0FFh,0C0h, 00h
		db	 13h, 00h, 00h,0C1h, 60h, 03h
		db	0FFh,0C4h, 00h,0FFh, 00h, 00h
		db	 4Fh, 00h, 00h,0C5h,0A8h, 00h
		db	0FFh,0F1h, 00h,0FFh, 00h, 00h
		db	 3Fh, 00h, 00h, 16h,0C2h, 00h
		db	0FFh, 3Ch, 00h,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 16h, 02h, 00h
		db	0FFh, 3Fh, 00h,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 1Ah, 02h, 00h
		db	0FFh, 3Fh, 00h,0FFh, 00h, 00h
		db	 3Fh, 00h, 00h,0C6h,0A8h, 00h
		db	0FFh,0FCh, 00h,0FFh, 00h, 00h
		db	 43h, 00h, 00h,0C2h,0A0h, 00h
		db	0FFh,0C1h, 00h,0FFh,0C0h, 00h
		db	 14h, 00h, 00h, 3Ch, 0Ch, 03h
		db	0FFh, 14h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 40h, 01h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 14h
		db	 00h, 03h,0FFh, 14h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 43h
		db	0C0h, 00h,0FFh,0C1h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 3Ch
		db	 16h, 00h, 3Fh, 0Ch, 40h,0FFh
		db	0F0h, 00h, 04h, 00h, 00h,0FCh
		db	 5Ah, 00h, 0Fh, 8Fh, 10h,0FFh
		db	0F0h, 00h, 03h, 00h, 00h,0F1h
		db	 6Ch, 00h, 0Fh, 23h,0C0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h,0F1h
		db	 60h, 00h, 0Fh, 23h,0F0h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h,0F1h
		db	0A0h, 00h, 0Fh, 23h,0F0h,0FFh
		db	0F0h, 00h, 03h, 00h, 00h,0FCh
		db	 6Ah, 00h, 0Fh, 8Fh,0C0h,0FFh
		db	0F0h, 00h, 04h, 00h, 00h, 3Ch
		db	 2Ah, 00h, 0Fh, 0Ch, 10h,0FFh
		db	0FCh, 00h, 01h, 00h, 00h, 43h
		db	0C0h, 00h, 3Fh,0C1h, 40h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 54h
		db	 00h, 00h,0FFh, 15h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 15h, 03h,0FFh, 54h, 00h,0FCh
		db	 00h, 01h, 40h, 00h, 3Fh, 01h
		db	 40h,0F0h, 00h, 04h, 30h, 00h
		db	 0Fh, 3Ch, 10h,0C0h, 00h, 13h
		db	 05h, 00h, 03h, 83h,0C4h, 00h
		db	 00h, 4Fh, 16h, 00h, 00h,0A3h
		db	0F1h, 00h, 00h, 3Ch, 5Bh, 00h
		db	 00h, 08h,0FCh, 00h, 00h,0FCh
		db	 58h, 00h, 00h, 08h,0FFh, 00h
		db	 00h,0FCh, 68h, 00h, 00h, 08h
		db	0FFh, 00h, 00h, 3Fh, 1Ah, 00h
		db	 00h,0A3h,0FCh, 00h, 00h, 43h
		db	 0Ah, 00h, 00h, 83h,0C1h,0C0h
		db	 00h, 14h, 30h, 00h, 03h, 3Ch
		db	 14h,0F0h, 00h, 05h, 40h, 00h
		db	 0Fh, 01h, 50h,0FFh, 00h, 00h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 00h, 3Fh, 55h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 14h, 00h, 03h, 00h
		db	 14h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 43h, 00h, 00h, 03h
		db	0C1h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 01h, 30h, 00h, 00h, 58h
		db	 3Ch, 3Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 04h,0F1h, 00h, 00h, 6Ah
		db	 3Fh, 0Fh,0FFh, 10h, 00h,0F0h
		db	 00h, 03h,0C5h, 00h, 00h,0B0h
		db	 8Fh, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 0Fh,0C5h, 00h, 00h, 80h
		db	 8Fh, 0Fh,0FFh,0F0h, 00h,0F0h
		db	 00h, 0Fh,0C6h, 00h, 00h, 80h
		db	 8Fh, 0Fh,0FFh,0F0h, 00h,0F0h
		db	 00h, 03h,0F1h, 00h, 00h,0AAh
		db	 3Fh, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 04h, 30h, 00h, 00h,0A8h
		db	 3Ch, 0Fh,0FFh, 10h, 00h,0FCh
		db	 00h, 01h, 43h, 00h, 00h, 03h
		db	0C1h, 3Fh,0FFh, 40h, 00h,0FFh
		db	 00h, 00h, 54h, 00h, 00h, 00h
		db	 15h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 03h, 15h, 54h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h, 40h, 01h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0F0h, 00h, 04h, 00h
		db	 00h, 30h, 3Ch, 0Fh,0FFh, 10h
		db	 00h,0FFh,0C0h, 00h, 13h, 00h
		db	 00h, 05h, 83h, 03h,0FFh,0C4h
		db	 00h,0FFh, 00h, 00h, 4Fh, 00h
		db	 00h, 16h,0A3h, 00h,0FFh,0F1h
		db	 00h,0FFh, 00h, 00h, 3Ch, 00h
		db	 00h, 5Bh, 08h, 00h,0FFh,0FCh
		db	 00h,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 58h, 08h, 00h,0FFh,0FFh
		db	 00h,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 68h, 08h, 00h,0FFh,0FFh
		db	 00h,0FFh, 00h, 00h, 3Fh, 00h
		db	 00h, 1Ah,0A3h, 00h,0FFh,0FCh
		db	 00h,0FFh, 00h, 00h, 43h, 00h
		db	 00h, 0Ah, 83h, 00h,0FFh,0C1h
		db	 00h,0FFh,0C0h, 00h, 14h, 00h
		db	 00h, 30h, 3Ch, 03h,0FFh, 14h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 40h, 01h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 14h, 00h, 03h
		db	0FFh, 14h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 43h, 03h, 00h
		db	0FFh,0C1h, 00h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 30h, 58h, 00h
		db	 3Fh, 3Ch, 40h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h,0F1h, 6Ah, 00h
		db	 0Fh, 3Fh, 10h,0FFh,0F0h, 00h
		db	 03h, 00h, 00h,0C5h,0B0h, 00h
		db	 0Fh, 8Fh,0C0h,0FFh,0F0h, 00h
		db	 0Fh, 00h, 00h,0C5h, 80h, 00h
		db	 0Fh, 8Fh,0F0h,0FFh,0F0h, 00h
		db	 0Fh, 00h, 00h,0C6h, 80h, 00h
		db	 0Fh, 8Fh,0F0h,0FFh,0F0h, 00h
		db	 03h, 00h, 00h,0F1h,0AAh, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0F0h, 00h
		db	 04h, 00h, 00h, 30h,0A8h, 00h
		db	 0Fh, 3Ch, 10h,0FFh,0FCh, 00h
		db	 01h, 00h, 00h, 43h, 03h, 00h
		db	 3Fh,0C1h, 40h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 54h, 00h, 00h
		db	0FFh, 15h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 55h, 00h,0FFh, 55h, 00h,0F0h
		db	 00h, 05h, 55h, 00h, 0Fh, 55h
		db	 50h,0C0h, 00h, 1Eh, 5Eh, 00h
		db	 03h, 5Eh, 78h, 00h, 00h, 9Ah
		db	 5Ah, 00h, 00h, 5Ah, 69h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 20h, 82h, 00h
		db	 00h, 82h, 08h, 00h, 00h, 20h
		db	 82h, 00h, 00h, 82h, 08h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 9Eh, 5Eh, 00h
		db	 00h, 5Eh, 79h,0C0h, 00h, 1Ah
		db	 5Ah, 00h, 03h, 5Ah, 68h,0F0h
		db	 00h, 05h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh, 00h, 00h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 0Fh, 55h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	0E5h, 00h, 00h,0E5h,0E7h, 3Fh
		db	0FFh, 80h, 00h,0F0h, 00h, 09h
		db	0A5h, 00h, 00h,0A5h,0A6h, 0Fh
		db	0FFh, 90h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 02h
		db	 08h, 00h, 00h, 28h, 20h, 0Fh
		db	0FFh, 80h, 00h,0F0h, 00h, 02h
		db	 08h, 00h, 00h, 28h, 20h, 0Fh
		db	0FFh, 80h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 09h
		db	0E5h, 00h, 00h,0E5h,0E7h, 0Fh
		db	0FFh, 90h, 00h,0FCh, 00h, 01h
		db	0A5h, 00h, 00h,0A5h,0A6h, 3Fh
		db	0FFh, 80h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 0Fh, 55h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0C0h, 00h, 1Eh, 00h, 00h, 5Eh
		db	 5Eh, 03h,0FFh, 78h, 00h,0FFh
		db	 00h, 00h, 9Ah, 00h, 00h, 5Ah
		db	 5Ah, 00h,0FFh, 69h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 20h, 00h, 00h, 82h
		db	 82h, 00h,0FFh, 08h, 00h,0FFh
		db	 00h, 00h, 20h, 00h, 00h, 82h
		db	 82h, 00h,0FFh, 08h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 9Eh, 00h, 00h, 5Eh
		db	 5Eh, 00h,0FFh, 79h, 00h,0FFh
		db	0C0h, 00h, 1Ah, 00h, 00h, 5Ah
		db	 5Ah, 03h,0FFh, 68h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h,0E5h,0E5h, 00h, 3Fh,0E7h
		db	 80h,0FFh,0F0h, 00h, 09h, 00h
		db	 00h,0A5h,0A5h, 00h, 0Fh,0A6h
		db	 90h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh,0F0h, 00h, 02h, 00h
		db	 00h, 08h, 28h, 00h, 0Fh, 20h
		db	 80h,0FFh,0F0h, 00h, 02h, 00h
		db	 00h, 08h, 28h, 00h, 0Fh, 20h
		db	 80h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh,0F0h, 00h, 09h, 00h
		db	 00h,0E5h,0E5h, 00h, 0Fh,0E7h
		db	 90h,0FFh,0FCh, 00h, 01h, 00h
		db	 00h,0A5h,0A5h, 00h, 3Fh,0A6h
		db	 80h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 00h,0FFh, 55h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 0Fh, 55h, 50h,0C0h, 00h, 39h
		db	 79h, 00h, 03h, 79h,0E4h, 00h
		db	 00h, 69h, 69h, 00h, 00h, 69h
		db	0A7h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 20h
		db	 82h
		db	 00h, 00h, 82h, 08h,0F0h, 00h
		db	 0Fh,0AEh, 00h, 0Fh, 95h, 50h
		db	0F0h, 00h, 0Fh,0AEh, 00h, 0Fh
		db	 95h
loc_a_87CE:
		push	ax
		add	[bx+si],al
;*		and	data_c_0000[bp+si],al
		db	 20h, 82h, 00h, 00h	;  Fixup - byte match
;*		or	byte ptr [bx+si],0
		db	 82h, 08h, 00h		;  Fixup - byte match
		add	[di+55h],dl
		add	[bx+si],al
		push	bp
		push	bp
		add	[bx+si],al
		jns	loc_a_885C		; Jump if not sign
		add	[bx+si],al
		jns	loc_a_87CE		; Jump if not sign
		rol	byte ptr [bx+si],29h	; ')' Rotate
		imul	ax,word ptr [bx+si],6903h	; reg = data * value
		movsb				; Mov [si] to es:[di]
                           lock	add	[di],al
		push	bp
		add	[bx],cl
		push	bp
		push	ax
		inc	word ptr [bx+si]
;*		add	[di+0],dl
		db	 00h, 55h, 00h		;  Fixup - byte match
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 0Fh, 55h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h, 97h, 00h
		db	 00h, 97h, 9Eh, 3Fh,0FFh, 40h
		db	 00h,0F0h, 00h, 06h, 96h, 00h
		db	 00h, 96h, 9Ah, 0Fh,0FFh, 70h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0F0h, 00h, 02h, 08h, 00h
		db	 00h, 28h, 20h, 0Fh,0FFh, 80h
loc_a_885C:
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		add	[bx+si],al
		cli				; Disable interrupts
		add	[bx+si],al
;*		jmp	loc_a_87BB		;*
		db	0E9h, 55h,0FFh		;  Fixup - byte match
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	0FAh, 00h, 00h,0E9h, 55h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 02h
		db	 08h, 00h, 00h, 28h, 20h, 0Fh
		db	0FFh, 80h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 07h
		db	 97h, 00h, 00h, 97h, 9Eh, 0Fh
		db	0FFh, 70h, 00h,0FCh, 00h, 02h
		db	 96h, 00h, 00h, 96h, 9Ah, 3Fh
		db	0FFh, 40h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 0Fh, 55h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0C0h, 00h, 39h, 00h, 00h, 79h
		db	 79h, 03h,0FFh,0E4h, 00h,0FFh
		db	 00h, 00h, 69h, 00h, 00h, 69h
		db	 69h, 00h,0FFh,0A7h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 20h, 00h, 00h, 82h
		db	 82h, 00h,0FFh, 08h, 00h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h,0AEh
		db	 95h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0F0h, 00h, 0Fh, 00h, 00h,0AEh
		db	 95h, 0Fh,0FFh, 50h, 00h,0FFh
		db	 00h, 00h, 20h, 00h, 00h, 82h
		db	 82h, 00h,0FFh, 08h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	 00h, 00h, 79h, 00h, 00h, 79h
		db	 79h, 00h,0FFh,0E7h, 00h,0FFh
		db	0C0h, 00h, 29h, 00h, 00h, 69h
		db	 69h, 03h,0FFh,0A4h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FCh, 00h, 03h, 00h
		db	 00h, 97h, 97h, 00h, 3Fh, 9Eh
		db	 40h,0FFh,0F0h, 00h, 06h, 00h
		db	 00h, 96h, 96h, 00h, 0Fh, 9Ah
		db	 70h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh,0F0h, 00h, 02h, 00h
		db	 00h, 08h, 28h, 00h, 0Fh, 20h
		db	 80h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h,0FAh,0E9h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h,0FAh,0E9h, 00h,0FFh, 55h
		db	 00h,0FFh,0F0h, 00h, 02h, 00h
		db	 00h, 08h, 28h, 00h, 0Fh, 20h
		db	 80h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh,0F0h, 00h, 07h, 00h
		db	 00h, 97h, 97h, 00h, 0Fh, 9Eh
		db	 70h,0FFh,0FCh, 00h, 02h, 00h
		db	 00h, 96h, 96h, 00h, 3Fh, 9Ah
		db	 40h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 05h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh, 00h, 00h
		db	 55h, 00h,0FFh, 55h, 00h,0F0h
		db	 00h, 05h, 55h, 00h, 0Fh, 55h
		db	 50h,0C0h, 00h, 27h, 97h, 00h
		db	 03h, 97h, 9Ch, 00h, 00h,0A6h
		db	 96h, 00h, 00h, 96h, 9Ah, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 20h, 82h, 00h
		db	 00h, 82h, 08h,0F0h, 00h, 00h
		db	 03h, 00h, 0Fh, 75h, 50h,0F0h
		db	 00h, 0Ah,0EBh, 00h, 0Fh,0D5h
		db	 50h,0F0h, 00h, 0Ah,0EBh, 00h
		db	 0Fh, 55h, 50h,0F0h, 00h, 00h
		db	 01h, 00h, 0Fh,0D5h, 50h, 00h
		db	 00h, 20h, 82h, 00h, 00h, 82h
		db	 08h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h,0E7h
		db	 97h, 00h, 00h, 97h, 9Eh,0C0h
		db	 00h, 26h, 96h, 00h, 03h, 96h
		db	 98h,0F0h, 00h, 05h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh, 00h, 00h
		db	 55h, 00h,0FFh, 55h, 00h, 03h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 0Fh, 55h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 02h, 79h, 00h
		db	 00h, 79h, 79h, 3Fh,0FFh,0C0h
		db	 00h,0F0h, 00h, 0Ah, 69h, 00h
		db	 00h, 69h, 69h, 0Fh,0FFh,0A0h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0F0h, 00h, 02h, 08h, 00h
		db	 00h, 28h, 20h, 0Fh,0FFh, 80h
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 37h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h,0AEh, 00h
		db	 00h,0BDh, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h,0AEh, 00h
		db	 00h,0B5h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 1Dh, 55h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 02h, 08h, 00h
		db	 00h, 28h, 20h, 0Fh,0FFh, 80h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0F0h, 00h, 0Eh, 79h, 00h
		db	 00h, 79h, 79h, 0Fh,0FFh,0E0h
		db	 00h,0FCh, 00h, 02h, 69h, 00h
		db	 00h, 69h, 69h, 3Fh,0FFh, 80h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 0Fh, 55h, 50h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0C0h, 00h
		db	 27h, 00h, 00h, 97h, 97h, 03h
		db	0FFh, 9Ch, 00h,0FFh, 00h, 00h
		db	0A6h, 00h, 00h, 96h, 96h, 00h
		db	0FFh, 9Ah, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh, 00h, 00h
		db	 20h, 00h, 00h, 82h, 82h, 00h
		db	0FFh, 08h, 00h,0FFh,0F0h, 00h
		db	 00h, 00h, 00h, 03h, 75h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0F0h, 00h
		db	 0Ah, 00h, 00h,0EBh,0D5h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0F0h, 00h
		db	 0Ah, 00h, 00h,0EBh, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0F0h, 00h
		db	 00h, 00h, 00h, 01h,0D5h, 0Fh
		db	0FFh, 50h, 00h,0FFh, 00h, 00h
		db	 20h, 00h, 00h, 82h, 82h, 00h
		db	0FFh, 08h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh, 00h, 00h
		db	0E7h, 00h, 00h, 97h, 97h, 00h
		db	0FFh, 9Eh, 00h,0FFh,0C0h, 00h
		db	 26h, 00h, 00h, 96h, 96h, 03h
		db	0FFh, 98h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FCh, 00h, 02h, 00h, 00h, 79h
		db	 79h, 00h, 3Fh, 79h,0C0h,0FFh
		db	0F0h, 00h, 0Ah, 00h, 00h, 69h
		db	 69h, 00h, 0Fh, 69h,0A0h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	0F0h, 00h, 02h, 00h, 00h, 08h
		db	 28h, 00h, 0Fh, 20h, 80h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 37h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0AEh
		db	0BDh, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0AEh
		db	0B5h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 1Dh, 00h,0FFh, 55h, 00h,0FFh
		db	0F0h, 00h, 02h, 00h, 00h, 08h
		db	 28h, 00h, 0Fh, 20h, 80h,0FFh
		db	0F0h, 00h, 05h, 00h, 00h, 55h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	0F0h, 00h, 0Eh, 00h, 00h, 79h
		db	 79h, 00h, 0Fh, 79h,0E0h,0FFh
		db	0FCh, 00h, 02h, 00h, 00h, 69h
		db	 69h, 00h, 3Fh, 69h, 80h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 55h
		db	 55h, 00h,0FFh, 55h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 0Fh,0FFh, 50h, 00h, 02h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	0FFh, 55h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 0Fh, 55h, 50h,0C0h
		db	 00h, 37h, 97h, 00h, 03h, 97h
		db	 9Ch, 00h, 00h,0A6h, 96h, 00h
		db	 00h, 96h, 9Ah, 00h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 20h, 82h, 00h, 00h, 82h
		db	 08h,0F0h, 00h, 00h, 3Fh, 00h
		db	 0Fh, 75h, 40h,0F0h, 00h, 0Eh
		db	0BFh, 00h, 0Fh,0D5h, 60h,0F0h
		db	 00h, 0Eh,0B7h, 00h, 0Fh, 55h
		db	 60h,0F0h, 00h, 00h, 1Dh, 00h
		db	 0Fh,0D5h, 40h, 00h, 00h, 20h
		db	 82h, 00h, 00h, 82h, 08h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 55h
		db	 55h, 00h, 00h,0E7h, 97h, 00h
		db	 00h, 97h, 9Eh,0C0h, 00h, 26h
		db	 96h, 00h, 03h, 96h, 98h,0F0h
		db	 00h, 05h, 55h, 00h, 0Fh, 55h
		db	 50h,0FFh, 00h, 00h, 55h, 00h
		db	0FFh, 55h, 00h, 03h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 03h, 79h, 00h, 00h, 79h
		db	 79h, 3Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 0Ah, 69h, 00h, 00h, 69h
		db	 69h, 0Fh,0FFh,0A0h, 00h,0F0h
		db	 00h, 05h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0F0h
		db	 00h, 02h, 08h, 00h, 00h, 28h
		db	 20h, 0Fh,0FFh, 80h, 00h,0FFh
		db	 00h, 00h, 03h, 00h, 00h,0F7h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0EBh, 00h, 00h,0FDh
		db	 56h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0EBh, 00h, 00h, 75h
		db	 56h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 01h, 00h, 00h,0DDh
		db	 54h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 02h, 08h, 00h, 00h, 28h
		db	 20h, 0Fh,0FFh, 80h, 00h,0F0h
		db	 00h, 05h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 50h, 00h,0F0h
		db	 00h, 0Eh, 79h, 00h, 00h, 79h
		db	 79h, 0Fh,0FFh,0E0h, 00h,0FCh
		db	 00h, 02h, 69h, 00h, 00h, 69h
		db	 69h, 3Fh,0FFh, 80h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0C0h, 00h, 37h, 00h
		db	 00h, 97h, 97h, 03h,0FFh, 9Ch
		db	 00h,0FFh, 00h, 00h,0A6h, 00h
		db	 00h, 96h, 96h, 00h,0FFh, 9Ah
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h, 20h, 00h
		db	 00h, 82h, 82h, 00h,0FFh, 08h
		db	 00h,0FFh,0F0h, 00h, 00h, 00h
		db	 00h, 3Fh, 75h, 0Fh,0FFh, 40h
		db	 00h,0FFh,0F0h, 00h, 0Eh, 00h
		db	 00h,0BFh,0D5h, 0Fh,0FFh, 60h
		db	 00h,0FFh,0F0h, 00h, 0Eh, 00h
		db	 00h,0B7h, 55h, 0Fh,0FFh, 60h
		db	 00h,0FFh,0F0h, 00h, 00h, 00h
		db	 00h, 1Dh,0D5h, 0Fh,0FFh, 40h
		db	 00h,0FFh, 00h, 00h, 20h, 00h
		db	 00h, 82h, 82h, 00h,0FFh, 08h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h,0E7h, 00h
		db	 00h, 97h, 97h, 00h,0FFh, 9Eh
		db	 00h,0FFh,0C0h, 00h, 26h, 00h
		db	 00h, 96h, 96h, 03h,0FFh, 98h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FCh, 00h
		db	 03h, 00h, 00h, 79h, 79h, 00h
		db	 3Fh, 79h,0C0h,0FFh,0F0h, 00h
		db	 0Ah, 00h, 00h, 69h, 69h, 00h
		db	 0Fh, 69h,0A0h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh,0F0h, 00h
		db	 02h, 00h, 00h, 08h, 28h, 00h
		db	 0Fh, 20h, 80h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 03h,0F7h, 00h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0EBh,0FDh, 00h
		db	0FFh, 56h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0EBh, 75h, 00h
		db	0FFh, 56h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 01h,0DDh, 00h
		db	0FFh, 54h, 00h,0FFh,0F0h, 00h
		db	 02h, 00h, 00h, 08h, 28h, 00h
		db	 0Fh, 20h, 80h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh,0F0h, 00h
		db	 0Eh, 00h, 00h, 79h, 79h, 00h
		db	 0Fh, 79h,0E0h,0FFh,0FCh, 00h
		db	 02h, 00h, 00h, 69h, 69h, 00h
		db	 3Fh, 69h, 80h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h, 02h, 00h,0FFh
		db	 00h, 00h, 55h, 00h,0FFh, 55h
		db	 00h,0F0h, 00h, 05h, 55h, 00h
		db	 0Fh, 55h, 50h,0C0h, 00h, 27h
		db	 97h, 00h, 03h, 97h, 9Ch, 00h
		db	 00h,0A6h, 96h, 00h, 00h, 96h
		db	 9Ah, 00h, 00h, 55h, 55h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 20h
		db	 82h, 00h, 00h, 82h, 08h,0F0h
		db	 00h, 00h,0FFh, 00h, 0Fh, 75h
		db	 00h,0F0h, 00h, 0Ah,0FFh, 00h
		db	 0Fh,0D5h,0A0h,0F0h, 00h, 0Ah
		db	0F7h, 00h, 0Fh, 55h,0A0h,0F0h
		db	 00h, 00h,0DDh, 00h, 0Fh,0D5h
		db	 00h, 00h, 00h, 20h, 82h, 00h
		db	 00h, 82h, 08h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h,0E7h, 97h, 00h, 00h, 97h
		db	 9Eh,0C0h, 00h, 26h, 96h, 00h
		db	 03h, 96h, 98h,0F0h, 00h, 05h
		db	 55h, 00h, 0Fh, 55h, 50h,0FFh
		db	 00h, 00h, 55h, 00h,0FFh, 55h
		db	 00h, 03h, 00h,0FFh,0F0h, 00h
		db	 05h, 00h, 0Fh, 55h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 02h
		db	 79h, 00h, 00h, 79h, 79h, 3Fh
		db	0FFh,0C0h, 00h,0F0h, 00h, 0Ah
		db	 69h, 00h, 00h, 69h, 69h, 0Fh
		db	0FFh,0A0h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 02h
		db	 08h, 00h, 00h, 28h, 20h, 0Fh
		db	0FFh, 80h, 00h,0FFh, 00h, 00h
		db	 0Fh, 00h, 00h,0F7h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	0AFh, 00h, 00h,0FDh, 5Ah,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	0AFh, 00h, 00h, 75h, 5Ah,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 0Dh, 00h, 00h,0DDh, 50h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 02h
		db	 08h, 00h, 00h, 28h, 20h, 0Fh
		db	0FFh, 80h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 00h, 55h, 55h, 0Fh
		db	0FFh, 50h, 00h,0F0h, 00h, 0Eh
		db	 79h, 00h, 00h, 79h, 79h, 0Fh
		db	0FFh,0E0h, 00h,0FCh, 00h, 02h
		db	 69h, 00h, 00h, 69h, 69h, 3Fh
		db	0FFh, 80h, 00h,0FFh, 00h, 00h
		db	 55h, 00h, 00h, 55h, 55h,0FFh
data_a_9112	db	0FFh			; Data table (indexed access)
		db	 00h, 00h,0FFh,0F0h, 00h, 05h
		db	 00h, 0Fh, 55h, 50h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 55h, 55h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 05h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0C0h
		db	 00h, 27h, 00h, 00h, 97h, 97h
		db	 03h,0FFh, 9Ch, 00h,0FFh, 00h
		db	 00h,0A6h, 00h, 00h, 96h, 96h
		db	 00h,0FFh, 9Ah, 00h,0FFh, 00h
		db	 00h, 55h, 00h, 00h, 55h, 55h
		db	 00h,0FFh, 55h, 00h,0FFh, 00h
		db	 00h, 20h, 00h, 00h, 82h, 82h
		db	 00h,0FFh, 08h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 00h,0FFh, 75h
		db	 0Fh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 0Ah, 00h, 00h,0FFh,0D5h
		db	 0Fh,0FFh,0A0h, 00h,0FFh,0F0h
		db	 00h, 0Ah, 00h, 00h,0F7h, 55h
		db	 0Fh,0FFh,0A0h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 00h,0DDh,0D5h
		db	 0Fh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 20h, 00h, 00h, 82h, 82h
		db	 00h,0FFh, 08h, 00h,0FFh, 00h
		db	 00h, 55h, 00h, 00h, 55h, 55h
		db	 00h,0FFh, 55h, 00h,0FFh, 00h
		db	 00h,0E7h, 00h, 00h, 97h, 97h
		db	 00h,0FFh, 9Eh, 00h,0FFh,0C0h
		db	 00h, 26h, 00h, 00h, 96h, 96h
		db	 03h,0FFh, 98h, 00h,0FFh,0F0h
		db	 00h, 05h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 55h, 55h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 05h, 55h, 0Fh,0FFh, 50h, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 55h, 55h, 00h,0FFh, 55h, 00h
		db	0FFh,0FCh, 00h, 02h, 00h, 00h
		db	 79h, 79h, 00h, 3Fh, 79h,0C0h
		db	0FFh,0F0h, 00h, 0Ah, 00h, 00h
		db	 69h, 69h, 00h, 0Fh, 69h,0A0h
		db	0FFh,0F0h, 00h, 05h, 00h, 00h
		db	 55h, 55h, 00h, 0Fh, 55h, 50h
		db	0FFh,0F0h, 00h, 02h, 00h, 00h
		db	 08h, 28h, 00h, 0Fh, 20h, 80h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 0Fh,0F7h, 00h,0FFh, 50h, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0AFh,0FDh, 00h,0FFh, 5Ah, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0AFh, 75h, 00h,0FFh, 5Ah, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 0Dh,0DDh, 00h,0FFh, 50h, 00h
		db	0FFh,0F0h, 00h, 02h, 00h, 00h
		db	 08h, 28h, 00h, 0Fh, 20h, 80h
		db	0FFh,0F0h, 00h, 05h, 00h, 00h
		db	 55h, 55h, 00h, 0Fh, 55h, 50h
		db	0FFh,0F0h, 00h, 0Eh, 00h, 00h
		db	 79h, 79h, 00h, 0Fh, 79h,0E0h
		db	0FFh,0FCh, 00h, 02h, 00h, 00h
		db	 69h, 69h, 00h, 3Fh, 69h, 80h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 55h, 55h, 00h,0FFh, 55h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 05h, 55h, 0Fh,0FFh, 50h, 00h
		db	 02h, 00h,0FFh, 00h, 00h, 55h
		db	 00h,0FFh, 55h, 00h,0F0h, 00h
		db	 05h, 55h, 00h, 0Fh, 55h, 50h
		db	0C0h, 00h, 1Eh, 5Eh, 00h, 03h
		db	 5Eh, 78h, 00h, 00h, 9Ah, 5Ah
		db	 00h, 00h, 5Ah, 69h, 00h, 00h
		db	 55h, 55h, 00h, 00h, 55h, 55h
		db	 00h, 00h, 20h, 82h, 00h, 00h
		db	 82h, 08h,0F0h, 00h, 03h,0FFh
		db	 00h, 0Fh, 74h, 00h,0F0h, 00h
		db	 0Bh,0FFh, 00h, 0Fh,0D6h, 90h
		db	0F0h, 00h, 0Bh,0F7h, 00h, 0Fh
		db	 56h, 90h,0F0h, 00h, 03h,0DDh
		db	 00h, 0Fh,0D4h, 00h, 00h, 00h
		db	 20h, 82h, 00h, 00h, 82h, 08h
		db	 00h, 00h, 55h, 55h, 00h, 00h
		db	 55h, 55h, 00h, 00h, 9Eh, 5Eh
		db	 00h, 00h, 5Eh, 79h,0C0h, 00h
		db	 1Ah, 5Ah, 00h, 03h, 5Ah, 68h
		db	0F0h, 00h, 05h, 55h, 00h, 0Fh
		db	 55h, 50h,0FFh, 00h, 00h, 55h
		db	 00h,0FFh, 55h, 00h, 03h, 00h
		db	0FFh,0F0h, 00h, 05h, 00h, 0Fh
		db	 55h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 55h, 00h, 00h
		db	 55h, 55h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 01h,0E5h, 00h, 00h
		db	0E5h,0E7h, 3Fh,0FFh, 80h, 00h
		db	0F0h, 00h, 09h,0A5h, 00h, 00h
		db	0A5h,0A6h, 0Fh,0FFh, 90h, 00h
		db	0F0h, 00h, 05h, 55h, 00h, 00h
		db	 55h, 55h, 0Fh,0FFh, 50h, 00h
		db	0F0h, 00h, 02h, 08h, 00h, 00h
		db	 28h, 20h, 0Fh,0FFh, 80h, 00h
		db	0FFh, 00h, 00h, 3Fh, 00h, 00h
		db	0F7h, 40h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h,0BFh, 00h, 00h
		db	0FDh, 69h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h,0BFh, 00h, 00h
		db	 75h, 69h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Dh, 00h, 00h
		db	0DDh, 40h,0FFh,0FFh, 00h, 00h
		db	0F0h, 00h, 02h, 08h, 00h, 00h
		db	 28h, 20h, 0Fh,0FFh, 80h, 00h
		db	0F0h, 00h, 05h, 55h, 00h, 00h
		db	 55h, 55h, 0Fh,0FFh, 50h, 00h
		db	0F0h, 00h, 09h,0E5h, 00h, 00h
		db	0E5h,0E7h, 0Fh,0FFh, 90h, 00h
		db	0FCh, 00h, 01h,0A5h, 00h, 00h
		db	0A5h,0A6h, 3Fh,0FFh, 80h, 00h
		db	0FFh, 00h, 00h, 55h, 00h, 00h
		db	 55h, 55h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 05h, 00h, 0Fh
		db	 55h, 50h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 55h, 55h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 05h
		db	 00h, 00h, 55h, 55h, 0Fh,0FFh
		db	 50h, 00h,0FFh,0C0h, 00h, 1Eh
		db	 00h, 00h, 5Eh, 5Eh, 03h,0FFh
		db	 78h, 00h,0FFh, 00h, 00h, 9Ah
		db	 00h, 00h, 5Ah, 5Ah, 00h,0FFh
		db	 69h, 00h,0FFh, 00h, 00h, 55h
		db	 00h, 00h, 55h, 55h, 00h,0FFh
		db	 55h, 00h,0FFh, 00h, 00h, 20h
		db	 00h, 00h, 82h, 82h, 00h,0FFh
		db	 08h, 00h,0FFh,0F0h, 00h, 03h
		db	 00h, 00h,0FFh, 74h, 0Fh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 0Bh
		db	 00h, 00h,0FFh,0D6h, 0Fh,0FFh
		db	 90h, 00h,0FFh,0F0h, 00h, 0Bh
		db	 00h, 00h,0F7h, 56h, 0Fh,0FFh
		db	 90h, 00h,0FFh,0F0h, 00h, 03h
		db	 00h, 00h,0DDh,0D4h, 0Fh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 20h
		db	 00h, 00h, 82h, 82h, 00h,0FFh
		db	 08h, 00h,0FFh, 00h, 00h, 55h
		db	 00h, 00h, 55h, 55h, 00h,0FFh
		db	 55h, 00h,0FFh, 00h, 00h, 9Eh
		db	 00h, 00h, 5Eh, 5Eh, 00h,0FFh
		db	 79h, 00h,0FFh,0C0h, 00h, 1Ah
		db	 00h, 00h, 5Ah, 5Ah, 03h,0FFh
		db	 68h, 00h,0FFh,0F0h, 00h, 05h
		db	 00h, 00h, 55h, 55h, 0Fh,0FFh
		db	 50h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 55h, 55h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0F0h, 00h, 05h, 55h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 55h, 55h
		db	 00h,0FFh, 55h, 00h,0FFh,0FCh
		db	 00h, 01h, 00h, 00h,0E5h,0E5h
		db	 00h, 3Fh,0E7h, 80h,0FFh,0F0h
		db	 00h, 09h, 00h, 00h,0A5h,0A5h
		db	 00h, 0Fh,0A6h, 90h,0FFh,0F0h
		db	 00h, 05h, 00h, 00h, 55h, 55h
		db	 00h, 0Fh, 55h, 50h,0FFh,0F0h
		db	 00h, 02h, 00h, 00h, 08h, 28h
		db	 00h, 0Fh, 20h, 80h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 3Fh,0F7h
		db	 00h,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h,0BFh,0FDh
		db	 00h,0FFh, 69h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h,0BFh, 75h
		db	 00h,0FFh, 69h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 3Dh,0DDh
		db	 00h,0FFh, 40h, 00h,0FFh,0F0h
		db	 00h, 02h, 00h, 00h, 08h, 28h
		db	 00h, 0Fh, 20h, 80h,0FFh,0F0h
		db	 00h, 05h, 00h, 00h, 55h, 55h
		db	 00h, 0Fh, 55h, 50h,0FFh,0F0h
		db	 00h, 09h, 00h, 00h,0E5h,0E5h
		db	 00h, 0Fh,0E7h, 90h,0FFh,0FCh
		db	 00h, 01h, 00h, 00h,0A5h,0A5h
		db	 00h, 3Fh,0A6h, 80h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 55h, 55h
		db	 00h,0FFh, 55h, 00h,0FFh,0FFh
		db	 00h, 00h,0F0h, 00h, 05h, 55h
		db	 0Fh,0FFh, 50h, 00h, 02h, 00h
		db	0FFh, 00h, 00h, 55h, 00h,0FFh
		db	 55h, 00h,0F0h, 00h, 05h, 55h
		db	 00h, 0Fh, 55h, 50h,0C0h, 00h
		db	 39h, 79h, 00h, 03h, 79h,0E4h
		db	 00h, 00h, 69h, 69h, 00h, 00h
		db	 69h,0A6h, 00h, 00h, 55h, 55h
		db	 00h, 00h, 55h, 55h, 00h, 00h
		db	 20h, 82h, 00h, 00h, 82h, 08h
		db	0F0h, 00h, 0Fh,0FFh, 00h, 0Fh
		db	 40h, 00h,0F0h, 00h, 0Fh,0FFh
		db	 00h, 0Fh,0E9h,0A0h,0F0h, 00h
		db	 0Fh,0F7h, 00h, 0Fh, 69h,0A0h
		db	0F0h, 00h, 0Fh,0DDh, 00h, 0Fh
loc_a_95BD:
		rol	byte ptr [bx+si],0	; Rotate
		add	[bx+si],ah
;*		add	byte ptr [bx+si],0
		db	 82h, 00h, 00h		;  Fixup - byte match
;*		or	byte ptr [bx+si],0
		db	 82h, 08h, 00h		;  Fixup - byte match
		add	[di+55h],dl
		add	[bx+si],al
		push	bp
		push	bp
		add	[bx+si],al
		jns	loc_a_964C		; Jump if not sign
		add	[bx+si],al
		jns	loc_a_95BD		; Jump if not sign
		rol	byte ptr [bx+si],29h	; ')' Rotate
		imul	ax,word ptr [bx+si],6903h	; reg = data * value
		movsb				; Mov [si] to es:[di]
                           lock	add	[di],al
		push	bp
		add	[bx],cl
		push	bp
		push	ax
		inc	word ptr [bx+si]
;*		add	[di+0],dl
		db	 00h, 55h, 00h		;  Fixup - byte match
		db	0FFh, 55h, 00h, 03h, 00h,0FFh
		db	0F0h
loc_a_95F3:
		add	[di],al
		add	[bx],cl
		push	bp
		push	ax
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 55h, 00h, 00h, 55h, 55h
		db	0FFh,0FFh, 00h, 00h,0FCh, 00h
		db	 03h, 97h, 00h, 00h, 97h, 9Eh
		db	 3Fh,0FFh, 40h, 00h,0F0h, 00h
		db	 06h, 96h, 00h, 00h, 96h, 9Ah
		db	 0Fh,0FFh, 60h, 00h,0F0h, 00h
		db	 05h, 55h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh, 50h, 00h,0F0h, 00h
		db	 02h, 08h, 00h, 00h, 28h, 20h
		db	 0Fh,0FFh, 80h, 00h,0FFh, 00h
		db	 00h,0FFh, 00h, 00h,0F4h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h,0FFh, 00h, 00h,0FEh
loc_a_964C:
;*		call	far ptr s_0000_FFFF	;*
		db	9Ah
		dw	0FFFFh, 0		;  Fixup - byte match
		inc	word ptr [bx+si]
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		add	[bx+si],al
		jbe	loc_a_95F3		; Jump if below or =
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h,0FDh, 00h, 00h,0DCh, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 02h, 08h, 00h, 00h, 28h, 20h
		db	 0Fh,0FFh, 80h, 00h,0F0h, 00h
		db	 05h, 55h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh, 50h, 00h,0F0h, 00h
		db	 07h, 97h, 00h, 00h, 97h, 9Eh
		db	 0Fh,0FFh
		db	60h
data_a_968C	dw	0FC00h			; Data table (indexed access)
		db	 00h, 02h, 96h, 00h, 00h, 96h
		db	 9Ah, 3Fh,0FFh, 40h, 00h,0FFh
		db	 00h, 00h, 55h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 00h, 0Fh, 55h
		db	 50h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0C0h, 00h, 39h, 00h
		db	 00h, 79h, 79h, 03h,0FFh,0E4h
		db	 00h,0FFh, 00h, 00h, 69h, 00h
		db	 00h, 69h, 69h, 00h,0FFh,0A6h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h, 20h, 00h
		db	 00h, 82h, 82h, 00h,0FFh, 08h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 00h
		db	 00h,0FFh, 40h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 00h
		db	 00h,0FFh,0E9h, 0Fh,0FFh,0A0h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 00h
		db	 00h,0F7h, 69h, 0Fh,0FFh,0A0h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 00h
		db	 00h,0DDh,0C0h, 0Fh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 20h, 00h
		db	 00h, 82h, 82h, 00h,0FFh, 08h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	 00h, 55h, 55h, 00h,0FFh, 55h
		db	 00h,0FFh, 00h, 00h, 79h, 00h
		db	 00h, 79h, 79h, 00h,0FFh,0E6h
		db	 00h,0FFh,0C0h, 00h, 29h, 00h
		db	 00h, 69h, 69h, 03h,0FFh,0A4h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 00h, 55h, 55h, 0Fh,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FCh, 00h
		db	 03h, 00h, 00h, 97h, 97h, 00h
		db	 3Fh, 9Eh, 40h,0FFh,0F0h, 00h
		db	 06h, 00h, 00h, 96h, 96h, 00h
		db	 0Fh, 9Ah, 60h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh,0F0h, 00h
		db	 02h, 00h, 00h, 08h, 28h, 00h
		db	 0Fh, 20h, 80h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh,0F4h, 00h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh,0FEh, 00h
		db	0FFh, 9Ah, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh, 76h, 00h
		db	0FFh, 9Ah, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FDh,0DCh, 00h
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 02h, 00h, 00h, 08h, 28h, 00h
		db	 0Fh, 20h, 80h,0FFh,0F0h, 00h
		db	 05h, 00h, 00h, 55h, 55h, 00h
		db	 0Fh, 55h, 50h,0FFh,0F0h, 00h
		db	 07h, 00h, 00h, 97h, 97h, 00h
		db	 0Fh, 9Eh, 60h,0FFh,0FCh, 00h
		db	 02h, 00h, 00h, 96h, 96h, 00h
		db	 3Fh, 9Ah, 40h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 05h, 55h, 0Fh
		db	0FFh, 50h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 55h, 00h
		db	0FFh, 55h, 00h,0F0h, 00h, 05h
		db	 55h, 00h, 0Fh, 55h, 50h,0C0h
		db	 00h, 27h, 97h, 00h, 03h, 97h
		db	 9Ch, 00h, 00h,0A6h, 96h, 00h
		db	 00h, 96h, 9Ah, 00h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 20h, 82h, 00h, 00h, 82h
		db	 08h,0F0h, 00h, 0Fh,0FEh, 00h
		db	 0Fh, 9Ah, 50h,0F0h, 00h, 0Fh
		db	0F6h, 00h, 0Fh, 9Ah, 50h, 00h
		db	 00h, 20h, 82h, 00h, 00h, 82h
		db	 08h, 00h
data_a_9888	db	0			; Data table (indexed access)
		db	 55h, 55h, 00h, 00h, 55h, 55h
		db	 00h, 00h,0E7h, 97h, 00h, 00h
		db	 97h, 9Eh,0C0h, 00h, 26h, 96h
		db	 00h, 03h, 96h, 98h,0F0h, 00h
		db	 05h, 55h, 00h, 0Fh, 55h, 50h
		db	0FFh, 00h, 00h, 55h, 00h,0FFh
		db	 55h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 05h, 00h, 0Fh
		db	 55h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 55h, 00h, 00h
		db	 55h, 55h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 02h, 79h, 00h, 00h
		db	 79h, 79h, 3Fh,0FFh,0C0h, 00h
		db	0F0h, 00h, 0Ah, 69h, 00h, 00h
		db	 69h, 69h, 0Fh,0FFh,0A0h, 00h
		db	0F0h, 00h, 05h, 55h, 00h, 00h
		db	 55h, 55h, 0Fh,0FFh, 50h, 00h
		db	0F0h, 00h, 02h, 08h, 00h, 00h
		db	 28h, 20h, 0Fh,0FFh, 80h, 00h
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	0E9h,0A5h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 69h,0A5h,0FFh,0FFh, 00h, 00h
		db	0F0h, 00h, 02h, 08h, 00h, 00h
		db	 28h, 20h, 0Fh,0FFh, 80h, 00h
		db	0F0h, 00h, 05h, 55h, 00h, 00h
		db	 55h, 55h, 0Fh,0FFh, 50h, 00h
		db	0F0h, 00h, 0Eh, 79h, 00h, 00h
		db	 79h, 79h, 0Fh,0FFh,0E0h, 00h
		db	0FCh, 00h, 02h, 69h, 00h, 00h
		db	 69h, 69h, 3Fh,0FFh, 80h, 00h
		db	0FFh, 00h, 00h, 55h, 00h, 00h
		db	 55h, 55h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 05h, 00h, 0Fh
		db	 55h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 55h, 55h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 05h
		db	 00h, 00h, 55h, 55h, 0Fh,0FFh
		db	 50h, 00h,0FFh,0C0h, 00h, 27h
		db	 00h, 00h, 97h, 97h, 03h,0FFh
		db	 9Ch, 00h,0FFh, 00h, 00h,0A6h
		db	 00h, 00h, 96h, 96h, 00h,0FFh
		db	 9Ah, 00h,0FFh, 00h, 00h, 55h
		db	 00h, 00h, 55h, 55h, 00h,0FFh
		db	 55h, 00h,0FFh, 00h, 00h, 20h
		db	 00h, 00h, 82h, 82h, 00h,0FFh
		db	 08h, 00h,0FFh,0F0h, 00h, 0Fh
		db	 00h, 00h,0FEh, 9Ah, 0Fh,0FFh
		db	 50h, 00h,0FFh,0F0h, 00h, 0Fh
		db	 00h, 00h,0F6h, 9Ah, 0Fh,0FFh
		db	 50h, 00h,0FFh, 00h, 00h, 20h
		db	 00h, 00h, 82h, 82h, 00h,0FFh
		db	 08h, 00h,0FFh, 00h, 00h, 55h
		db	 00h, 00h, 55h, 55h, 00h,0FFh
		db	 55h, 00h,0FFh, 00h, 00h,0E7h
		db	 00h, 00h, 97h, 97h, 00h,0FFh
		db	 9Eh, 00h,0FFh,0C0h, 00h, 26h
		db	 00h, 00h, 96h, 96h, 03h,0FFh
		db	 98h, 00h,0FFh,0F0h, 00h, 05h
		db	 00h, 00h, 55h, 55h, 0Fh,0FFh
		db	 50h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 55h, 55h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0F0h, 00h, 05h, 55h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 55h, 55h
		db	 00h,0FFh, 55h, 00h,0FFh,0FCh
		db	 00h, 02h, 00h, 00h, 79h, 79h
		db	 00h, 3Fh, 79h,0C0h,0FFh,0F0h
		db	 00h, 0Ah, 00h, 00h, 69h, 69h
		db	 00h, 0Fh, 69h,0A0h,0FFh,0F0h
		db	 00h, 05h, 00h, 00h, 55h, 55h
		db	 00h, 0Fh
		db	55h
data_a_9A84	db	50h			; Data table (indexed access)
		db	0FFh,0F0h, 00h, 02h, 00h, 00h
		db	 08h, 28h, 00h, 0Fh, 20h, 80h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0FFh,0E9h, 00h,0FFh,0A5h, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0FFh, 69h, 00h,0FFh,0A5h, 00h
		db	0FFh,0F0h, 00h, 02h, 00h, 00h
		db	 08h, 28h, 00h, 0Fh, 20h, 80h
		db	0FFh,0F0h, 00h, 05h, 00h, 00h
		db	 55h, 55h, 00h, 0Fh, 55h, 50h
		db	0FFh,0F0h, 00h, 0Eh, 00h, 00h
		db	 79h, 79h, 00h, 0Fh, 79h,0E0h
		db	0FFh,0FCh, 00h, 02h, 00h, 00h
		db	 69h, 69h, 00h, 3Fh, 69h, 80h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 55h, 55h, 00h,0FFh, 55h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 05h, 55h, 0Fh,0FFh, 50h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 02h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0C3h,0FFh
		db	 1Ch, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FCh
		db	 00h, 03h, 0Fh, 03h,0F0h, 54h
		db	0F0h, 30h, 05h, 4Dh, 00h, 00h
		db	0FDh,0D5h,0C0h, 00h, 1Dh, 5Fh
		db	 00h, 00h,0FDh, 55h,0C0h, 00h
		db	 15h, 5Fh, 00h, 00h,0FDh, 55h
		db	0C0h, 0Ch, 15h, 53h, 0Fh, 03h
		db	0F0h, 54h,0F0h, 3Fh, 05h, 40h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C3h, 00h, 1Ch
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 3Fh, 01h,0C0h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0C0h,0F0h
		db	 3Fh, 05h, 3Fh,0FFh, 40h, 00h
		db	0FFh, 03h, 00h, 54h, 00h, 00h
		db	0DFh,0DDh, 0Fh,0FFh, 50h, 00h
		db	0FCh, 00h, 01h,0D5h, 00h, 00h
		db	0FFh,0D5h, 0Fh,0FFh, 50h, 00h
		db	0FCh, 00h, 01h, 55h, 00h, 00h
		db	0FFh,0D5h, 0Fh,0FFh, 50h, 00h
		db	0FCh, 00h, 01h, 55h,0C0h,0F0h
		db	 3Fh, 05h, 3Fh,0FFh, 40h, 00h
		db	0FFh, 03h, 00h, 54h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FCh
		db	 00h, 01h, 3Fh,0FFh,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C3h, 00h, 1Ch
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 0Fh, 03h,0F0h, 03h,0FFh
		db	 54h, 00h,0FFh,0F0h, 00h, 05h
		db	 30h, 00h, 4Dh,0FDh, 00h,0FFh
		db	0D5h, 00h,0FFh,0C0h, 00h, 1Dh
		db	 00h, 00h, 5Fh,0FDh, 00h,0FFh
		db	 55h, 00h,0FFh,0C0h, 00h, 15h
		db	 00h, 00h, 5Fh,0FDh, 00h,0FFh
		db	 55h, 00h,0FFh,0C0h, 00h, 15h
		db	 0Ch, 0Fh, 53h,0F0h, 03h,0FFh
		db	 54h, 00h,0FFh,0F0h, 00h, 05h
		db	 3Fh,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0C3h,0FFh
		db	 1Ch, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FCh
		db	 00h, 01h, 3Fh,0FFh,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 3Fh
		db	0F0h, 3Fh, 05h, 40h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h, 54h,0DFh
		db	 00h, 0Fh,0DDh, 50h,0FFh,0FCh
		db	 00h, 01h, 00h, 00h,0D5h,0FFh
		db	 00h, 0Fh,0D5h, 50h,0FFh,0FCh
		db	 00h, 01h, 00h, 00h, 55h,0FFh
		db	 00h, 0Fh,0D5h, 50h,0FFh,0FCh
		db	 00h, 01h, 00h,0C0h, 55h, 3Fh
		db	0F0h, 3Fh, 05h, 40h,0FFh,0FFh
		db	 00h, 00h, 03h,0FFh, 54h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 3Fh, 01h,0C0h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 02h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 3Fh
		db	 05h, 40h,0FFh, 03h, 00h, 54h
		db	0C0h, 0Fh, 1Dh, 50h,0FCh, 00h
		db	 01h,0D5h,0C0h, 0Fh, 15h, 50h
		db	0FCh, 00h, 01h, 55h,0C0h, 0Fh
		db	 15h, 50h,0FCh, 00h, 01h, 55h
		db	0F0h, 3Fh, 05h, 40h,0FFh, 03h
		db	 00h, 54h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FCh
		db	 00h, 03h, 0Fh,0FFh,0F0h, 00h
		db	0FFh,0F0h, 00h, 0Dh, 03h,0FFh
		db	0FCh, 00h,0FFh,0F0h, 00h, 0Fh
		db	 03h,0FFh,0FCh, 00h,0FFh,0F0h
		db	 00h, 0Fh, 03h,0FFh,0FCh, 00h
		db	0FFh,0FCh, 00h, 03h, 0Fh,0F3h
		db	0F0h, 04h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 15h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F3h, 00h, 0Ch
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 03h
		db	 00h, 54h,0FFh,0F0h, 00h, 05h
		db	 3Fh,0FFh, 40h, 00h,0FCh, 00h
		db	 01h,0D5h,0FFh,0C0h, 00h, 1Dh
		db	 0Fh,0FFh, 50h, 00h,0FCh, 00h
		db	 01h, 55h,0FFh,0C0h, 00h, 15h
		db	 0Fh,0FFh, 50h, 00h,0FCh, 00h
		db	 01h, 55h,0FFh,0C0h, 00h, 15h
		db	 0Fh,0FFh, 50h, 00h,0FFh, 03h
		db	 00h, 54h,0FFh,0F0h, 00h, 05h
		db	 3Fh,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h,0FFh, 3Fh, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 3Fh,0DFh,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 3Fh,0FFh,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 3Fh,0FFh,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h,0FFh, 3Fh, 00h
		db	 3Fh,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FCh, 00h, 01h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 3Fh,0FFh,0C0h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 05h, 3Fh,0FFh
		db	 40h, 00h, 03h,0FFh, 54h, 00h
		db	0FFh,0C0h, 00h, 1Dh, 0Fh,0FCh
		db	 50h, 01h, 00h,0FFh,0D5h, 00h
		db	0FFh,0C0h, 00h, 15h, 0Fh,0FCh
		db	 50h, 01h, 00h,0FFh, 55h, 00h
		db	0FFh,0C0h, 00h, 15h, 0Fh,0FCh
		db	 50h, 01h, 00h,0FFh, 55h, 00h
		db	0FFh,0F0h, 00h, 05h, 3Fh,0FFh
		db	 40h, 00h, 03h,0FFh, 54h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FCh, 0Fh
		db	 03h,0F0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 03h
		db	 0Dh,0FCh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 03h
		db	 0Fh,0FCh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 03h
		db	 0Fh,0FCh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FCh, 0Fh
		db	 03h,0F0h,0F3h,0FFh, 04h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h,0FFh, 15h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0F3h,0FFh, 0Ch, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h,0FFh, 54h, 00h,0F0h, 3Fh
		db	 05h, 40h,0FFh,0FCh, 00h, 01h
		db	 00h,0FFh,0D5h, 00h,0C0h, 0Fh
		db	 1Dh, 50h,0FFh,0FCh, 00h, 01h
		db	 00h,0FFh, 55h, 00h,0C0h, 0Fh
		db	 15h, 50h,0FFh,0FCh, 00h, 01h
		db	 00h,0FFh, 55h, 00h,0C0h, 0Fh
		db	 15h, 50h,0FFh,0FFh, 00h, 00h
		db	 03h,0FFh, 54h, 00h,0F0h, 3Fh
		db	 05h, 40h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 3Fh,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h,0DFh, 3Fh,0FFh
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h,0FFh, 3Fh,0FFh
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h,0FFh, 3Fh,0FFh
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 3Fh,0FFh, 3Fh
		db	 00h, 40h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FCh, 0Fh
		db	 01h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 3Fh
		db	 00h,0C0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 03h, 00h, 54h
		db	0F0h, 3Fh, 05h, 40h,0FCh, 00h
		db	 01h,0D5h,0C0h, 0Fh, 1Dh, 50h
		db	0FCh, 00h, 01h, 55h,0C0h, 0Fh
		db	 15h, 50h,0FCh, 00h, 01h, 55h
		db	0C0h, 0Fh, 15h, 50h,0FFh, 03h
		db	 00h, 54h,0F0h, 3Fh, 05h, 40h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FCh, 00h, 03h
		db	 0Fh,0FFh,0F0h, 00h,0C3h,0F0h
		db	 1Ch, 0Dh, 03h,0FFh,0FCh, 00h
		db	0FFh,0F0h, 00h, 0Fh, 03h,0FFh
		db	0FCh, 00h,0FFh,0F0h, 00h, 0Fh
		db	 03h,0FFh,0FCh, 00h,0FFh,0FCh
		db	 00h, 03h, 0Fh,0FFh,0F0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C3h
		db	 00h, 1Ch,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 05h
		db	 3Fh, 03h, 40h, 54h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 1Dh
		db	 0Ch, 00h, 51h,0D5h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 15h
		db	 0Ch, 00h, 51h, 55h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 15h
		db	 0Ch, 00h, 51h, 55h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 05h
		db	 3Fh, 03h, 40h, 54h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0C0h,0FFh, 3Fh, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 3Fh, 01h,0C0h
		db	 00h, 3Fh,0DFh,0C0h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 3Fh,0FFh,0C0h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 3Fh,0FFh,0C0h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0C0h,0FFh, 3Fh, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 01h, 3Fh,0FFh
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h,0F0h, 54h, 05h
		db	 3Fh,0FFh, 40h, 00h,0FFh,0FCh
		db	 00h, 01h, 00h,0C0h,0D5h, 1Dh
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FCh
		db	 00h, 01h, 00h,0C0h, 55h, 15h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FCh
		db	 00h, 01h, 00h,0C0h, 55h, 15h
		db	 0Fh,0FFh, 50h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h,0F0h, 54h, 05h
		db	 3Fh,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 0Fh, 03h,0F0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C3h
		db	 00h, 1Ch,0F0h, 03h, 0Dh,0FCh
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0F0h, 03h, 0Fh,0FCh
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0F0h, 03h, 0Fh,0FCh
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 0Fh, 03h,0F0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0C3h,0FFh, 1Ch, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 3Fh
		db	 05h, 40h, 03h,0FFh, 54h, 00h
		db	0FFh,0FFh, 00h, 00h,0C0h, 0Ch
		db	 1Dh, 51h, 00h,0FFh,0D5h, 00h
		db	0FFh,0FFh, 00h, 00h,0C0h, 0Ch
		db	 15h, 51h, 00h,0FFh, 55h, 00h
		db	0FFh,0FFh, 00h, 00h,0C0h, 0Ch
		db	 15h, 51h, 00h,0FFh, 55h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 3Fh
		db	 05h, 40h, 03h,0FFh, 54h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 3Fh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 01h, 3Fh, 00h
		db	0C0h,0DFh, 3Fh,0FFh,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h,0FFh, 3Fh,0FFh,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h,0FFh, 3Fh,0FFh,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 3Fh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 3Fh, 01h,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 02h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 05h, 03h,0FFh
		db	 54h, 00h,0FFh,0C0h, 00h, 1Dh
		db	 00h,0FFh, 55h, 00h,0FFh,0C0h
		db	 00h, 15h, 00h,0FFh, 55h, 00h
		db	0FFh,0C0h, 00h, 15h, 00h,0FFh
		db	 55h, 00h,0FFh,0F0h, 00h, 05h
		db	 03h,0FFh, 54h, 00h,0FFh,0FCh
		db	 00h, 03h, 0Fh,0FFh,0F0h, 00h
		db	0CFh,0F0h, 30h, 0Dh, 03h,0FFh
		db	0FCh, 00h, 03h,0F0h, 7Ch, 0Fh
		db	 03h,0FFh,0FCh, 00h,0CFh,0F0h
		db	 30h, 0Fh, 03h,0FFh,0FCh, 00h
		db	0FFh,0FCh, 00h, 03h, 0Fh,0FFh
		db	0F0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 3Fh
		db	 55h, 40h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 01h, 00h, 0Fh
		db	0D5h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 01h, 00h, 0Fh
		db	 55h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 01h, 00h, 0Fh
		db	 55h, 50h,0FFh,0FFh, 00h
data_a_A420	dw	0FF00h
		db	0FFh, 00h, 00h, 00h, 3Fh, 55h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h,0FFh, 3Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	0FFh, 03h, 00h, 00h, 3Fh,0DFh
		db	0C0h,0FFh,0FFh, 00h, 00h,0F0h
		db	 3Fh, 07h,0C0h, 00h, 3Fh,0FFh
		db	0C0h,0FFh,0FFh, 00h, 00h,0FCh
		db	0FFh, 03h, 00h, 00h, 3Fh,0FFh
		db	0C0h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h,0FFh, 3Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 03h, 05h, 54h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 1Dh, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 15h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 15h, 55h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 03h, 05h, 54h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 0Fh, 03h,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CFh, 00h, 30h,0F0h
		db	 03h, 0Dh,0FCh,0FFh,0FFh, 00h
		db	 00h,0FFh, 03h, 00h, 7Ch,0F0h
		db	 03h, 0Fh,0FCh,0FFh,0FFh, 00h
		db	 00h,0FFh,0CFh, 00h, 30h,0F0h
		db	 03h, 0Fh,0FCh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 0Fh, 03h,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 55h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h,0D5h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 01h, 55h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 55h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 3Fh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 03h,0FFh, 00h, 00h,0DFh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0F0h, 00h
		db	 07h, 3Fh, 00h,0C0h,0FFh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FCh, 00h
		db	 03h,0FFh, 00h, 00h,0FFh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 3Fh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C3h, 00h, 1Ch,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0F0h, 00h
		db	 07h, 03h,0FFh, 54h, 00h,0FFh
		db	0F0h, 00h, 05h, 03h,0FFh, 54h
		db	 00h,0FFh,0F0h, 00h, 05h, 03h
		db	0FFh, 54h, 00h,0FFh,0FCh, 00h
		db	 01h, 0Fh,0FFh, 50h, 00h,0C3h
		db	0FFh, 1Ch, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FFh, 15h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh, 75h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh, 55h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh, 55h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FFh, 15h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 3Fh, 01h
		db	0C0h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 1Ch, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 01h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 07h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 05h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 05h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 01h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C3h, 00h, 1Ch,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 3Fh, 01h
		db	0C0h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 75h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F3h, 00h
		db	 04h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 17h,0FFh,0F0h, 00h
		db	 0Fh, 3Fh,0F3h,0C0h, 04h,0FFh
		db	0C0h, 00h, 37h, 0Fh,0FFh,0F0h
		db	 00h,0FFh,0C0h, 00h, 3Fh, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0C0h, 00h
		db	 3Fh, 0Fh,0FFh,0F0h, 00h,0FFh
		db	0F0h, 00h, 0Fh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0C0h, 00h, 15h, 0Fh
		db	0FFh, 50h, 00h,0FFh, 00h, 00h
		db	 75h, 03h,0FFh, 54h, 00h,0FFh
		db	 00h, 00h, 55h, 03h,0FFh, 54h
		db	 00h,0FFh, 00h, 00h, 55h, 03h
		db	0FFh, 54h, 00h,0FFh,0C0h, 00h
		db	 15h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 0Fh,0FFh, 70h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	0FFh,0FCh, 00h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FCh, 00h, 03h, 00h
		db	0FFh, 7Fh, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h, 00h
		db	0FFh,0FFh, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h, 00h
		db	0FFh,0FFh, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	0FFh,0FCh, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 07h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 05h, 00h
		db	 3Fh, 55h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	0FFh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F3h
		db	0FFh, 04h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	0FFh, 17h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 3Fh, 0Fh,0C0h,0F3h
		db	0FFh, 04h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 37h,0F0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 3Fh,0F0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 3Fh,0F0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 3Fh, 0Fh,0C0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 15h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 03h, 75h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 03h, 55h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 03h, 55h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 0Fh, 15h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 3Fh, 00h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 0Fh, 01h, 70h,0FFh
		db	0FFh, 00h, 00h,0FFh, 03h, 00h
		db	0FCh,0FFh, 3Fh, 00h, 40h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 03h
		db	 7Fh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 03h, 00h
		db	0FCh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 07h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 05h
		db	 55h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	 55h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0C3h,0FFh, 1Ch, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 0Fh, 00h, 70h,0FFh
		db	0F0h, 00h, 0Fh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0C0h, 00h, 37h, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0C0h, 00h
		db	 3Fh, 0Fh,0FFh,0F0h, 00h,0FFh
		db	0C0h, 00h, 3Fh, 0Fh,0FFh,0F0h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 0Fh, 01h, 50h,0C0h,0FFh, 15h
		db	 00h,0F0h, 03h, 07h, 54h, 00h
		db	 3Fh, 75h, 40h,0F0h, 03h, 05h
		db	 54h, 00h, 3Fh, 55h, 40h,0F0h
		db	 03h, 05h, 54h, 00h, 3Fh, 55h
		db	 40h,0FCh, 0Fh, 01h, 50h,0C0h
		db	0FFh, 15h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FCh
		db	 3Fh, 01h,0C0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 07h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h,0FFh,0FCh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 03h, 00h,0FFh, 7Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 03h, 00h,0FFh,0FFh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 03h, 00h,0FFh,0FFh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h,0FFh,0FCh
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h,0FCh, 0Fh, 01h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 75h, 30h, 03h, 47h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 30h, 03h, 45h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 55h, 30h, 03h, 45h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 15h,0FCh, 0Fh, 01h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0C3h, 00h, 1Ch,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 0Fh,0FFh, 70h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 3Fh, 0Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 37h,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 3Fh,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 3Fh,0F0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 3Fh, 0Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 0Fh
		db	0C0h, 50h, 15h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 07h, 03h
		db	 00h, 54h, 75h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0F0h, 00h, 05h, 03h
		db	 00h, 54h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0F0h, 00h, 05h, 03h
		db	 00h, 54h, 55h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FCh, 00h, 01h, 0Fh
		db	0C0h, 50h, 15h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FCh, 00h
		db	 01h, 3Fh,0FFh,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FFh, 07h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 03h, 00h,0FCh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h, 7Fh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 03h,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 03h, 00h,0FCh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FCh, 15h, 01h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 30h, 75h, 47h, 03h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 30h, 55h, 45h, 03h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 30h, 55h, 45h, 03h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FCh, 15h, 01h, 0Fh
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F3h, 00h
		db	 04h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 17h,0FFh,0FCh, 00h
		db	 03h, 0Fh,0F3h,0F0h, 0Ch,0FFh
		db	0F0h, 00h, 0Dh, 03h,0FFh,0FCh
		db	 00h,0FFh,0F0h, 00h, 0Fh, 03h
		db	0FFh,0FCh, 00h,0FFh,0F0h, 00h
		db	 0Fh, 03h,0FFh,0FCh, 00h,0FFh
		db	0FCh, 00h, 03h, 0Fh,0FFh,0F0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 3Fh, 05h
		db	 40h,0FFh, 03h, 00h, 54h,0C0h
		db	 0Fh, 1Dh, 50h,0FCh, 00h, 01h
		db	0D5h,0C0h, 0Fh, 15h, 50h,0FCh
		db	 00h, 01h, 55h,0C0h, 0Fh, 15h
		db	 50h,0FCh, 00h, 01h, 55h,0F0h
		db	 3Fh, 05h, 40h,0FFh, 03h, 00h
		db	 54h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 0Fh
		db	0FFh, 70h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FFh, 3Fh, 00h, 3Fh
		db	0FFh,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0DFh,0C0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FFh, 3Fh, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 03h, 00h
		db	 54h,0FFh,0F0h, 00h, 05h, 3Fh
		db	0FFh, 40h, 00h,0FCh, 00h, 01h
		db	0D5h,0FFh,0C0h, 00h, 1Dh, 0Fh
		db	0FFh, 50h, 00h,0FCh, 00h, 01h
		db	 55h,0FFh,0C0h, 00h, 15h, 0Fh
		db	0FFh, 50h, 00h,0FCh, 00h, 01h
		db	 55h,0FFh,0C0h, 00h, 15h, 0Fh
		db	0FFh, 50h, 00h,0FFh, 03h, 00h
		db	 54h,0FFh,0F0h, 00h, 05h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F3h,0FFh, 04h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h,0FFh, 17h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 03h
		db	0F0h,0F3h,0FFh, 0Ch, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 0Dh
		db	0FCh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 0Fh
		db	0FCh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 03h, 0Fh
		db	0FCh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 03h
		db	0F0h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h, 3Fh,0FFh, 40h
		db	 00h, 03h,0FFh, 54h, 00h,0FFh
		db	0C0h, 00h, 1Dh, 0Fh,0FCh, 50h
		db	 01h, 00h,0FFh,0D5h, 00h,0FFh
		db	0C0h, 00h, 15h, 0Fh,0FCh, 50h
		db	 01h, 00h,0FFh, 55h, 00h,0FFh
		db	0C0h, 00h, 15h, 0Fh,0FCh, 50h
		db	 01h, 00h,0FFh, 55h, 00h,0FFh
		db	0F0h, 00h, 05h, 3Fh,0FFh, 40h
		db	 00h, 03h,0FFh, 54h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 3Fh, 00h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 01h
		db	 70h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 3Fh,0FFh, 3Fh, 00h
		db	0C0h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0DFh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h,0FFh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	0FFh, 54h, 00h,0F0h, 3Fh, 05h
		db	 40h,0FFh,0FCh, 00h, 01h, 00h
		db	0FFh,0D5h, 00h,0C0h, 0Fh, 1Dh
		db	 50h,0FFh,0FCh, 00h, 01h, 00h
		db	0FFh, 55h, 00h,0C0h, 0Fh, 15h
		db	 50h,0FFh,0FCh, 00h, 01h, 00h
		db	0FFh, 55h, 00h,0C0h, 0Fh, 15h
		db	 50h,0FFh,0FFh, 00h, 00h, 03h
		db	0FFh, 54h, 00h,0F0h, 3Fh, 05h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C3h, 00h, 1Ch,0C3h,0FFh, 34h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh,0F0h, 01h
		db	 05h, 0Fh, 3Fh, 50h, 40h,0FFh
		db	0C0h, 00h, 1Fh, 03h,0FFh,0F4h
		db	 00h,0FFh,0C0h, 00h, 1Fh, 03h
		db	0FFh,0F4h, 00h,0FCh,0F0h, 01h
		db	 05h, 0Fh, 3Fh, 50h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C3h, 00h, 1Ch,0C3h
		db	0FFh, 34h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 3Ch
		db	 3Fh,0C3h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CFh, 00h, 10h, 00h
		db	0F3h, 55h, 04h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 3Fh,0FFh, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 00h
		db	 3Fh,0FFh, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CFh, 00h, 10h, 00h
		db	0F3h, 55h, 04h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 01h, 3Ch
		db	 3Fh,0C3h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0C3h, 1Ch, 34h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h,0F0h, 0Fh, 05h, 50h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 03h, 1Fh,0F4h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 03h, 1Fh,0F4h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h,0F0h, 0Fh, 05h, 50h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0C3h, 1Ch, 34h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 3Ch, 01h
		db	0C3h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0CFh, 00h, 10h
		db	 55h,0F3h,0FFh, 04h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	0FFh, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 01h
		db	0FFh, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0CFh, 00h, 10h
		db	 55h,0F3h,0FFh, 04h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 3Ch, 01h
		db	0C3h, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0CFh, 00h
		db	 10h,0F3h,0FFh, 04h, 00h,0FCh
		db	 03h, 01h,0F4h,0C0h, 3Fh, 1Fh
		db	 40h,0FFh,0C3h, 00h, 14h,0C3h
		db	0FFh, 14h, 00h,0F3h
loc_a_B428:
		int	3			; Debug breakpoint
		add	al,11h
		xor	cx,di
		inc	sp
;*		adc	al,al
		db	 10h,0C0h		;  Fixup - byte match
		aas				; Ascii adjust
		sbb	ax,0FC40h
		add	ax,[bx+di]
		jz	loc_a_B428		; Jump if zero
		db	0F3h, 05h, 0Ch,0CFh, 0Fh, 30h
		db	 50h,0FFh, 3Ch, 00h, 41h, 3Ch
		db	0FFh, 41h, 00h,0FFh, 3Ch, 00h
		db	 41h, 3Ch,0FFh, 41h, 00h,0F0h
		db	0F3h, 05h, 0Ch,0CFh, 0Fh, 30h
		db	 50h,0C0h, 3Fh, 1Dh, 40h,0FCh
		db	 03h, 01h, 74h,0F3h,0CCh, 04h
		db	 11h, 33h,0CFh, 44h, 10h,0FFh
		db	0C3h, 00h, 14h,0C3h,0FFh, 14h
		db	 00h,0FCh, 03h, 01h,0F4h,0C0h
		db	 3Fh, 1Fh, 40h,0FFh,0CFh, 00h
		db	 10h,0F3h,0FFh, 04h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h,0FFh, 3Fh, 00h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 1Fh, 3Ch, 03h, 41h,0F4h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 3Ch, 3Fh, 41h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh, 3Ch, 00h
		db	 41h,0C3h, 3Ch, 14h, 41h,0FFh
		db	0FFh, 00h, 00h,0FCh, 03h, 01h
		db	0D4h,0FFh,0C0h, 00h, 17h, 3Fh
		db	0FFh, 40h, 00h,0FFh, 0Fh, 00h
		db	 50h, 3Ch,0F0h,0C3h, 05h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F3h, 00h
		db	 04h,0C3h,0CFh, 14h, 10h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F3h, 00h
		db	 04h,0C3h,0CFh, 14h, 10h,0FFh
		db	0FFh, 00h, 00h,0FFh, 0Fh, 00h
		db	 50h, 3Ch,0F0h,0C3h, 05h,0FFh
		db	0FFh, 00h, 00h,0FCh, 03h, 01h
		db	0D4h,0FFh,0C0h, 00h, 17h, 3Fh
		db	0FFh, 40h, 00h,0FFh, 3Ch, 00h
		db	 41h,0C3h, 3Ch, 14h, 41h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h, 3Ch, 3Fh, 41h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 1Fh, 3Ch, 03h, 41h,0F4h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h,0FFh, 3Fh, 00h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0CFh,0F3h, 10h
		db	 04h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 03h,0C0h,0F4h
		db	 1Fh, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0C3h,0C3h, 14h
		db	 14h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F3h, 00h, 04h,0CCh, 33h, 11h
		db	 44h,0CFh,0FFh, 10h, 00h,0FFh
		db	0C0h, 00h, 1Dh, 3Fh,0FCh, 40h
		db	 01h, 03h,0FFh, 74h, 00h,0FFh
		db	0F0h, 00h, 05h,0F3h,0CFh, 0Ch
		db	 30h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h, 3Ch, 3Ch, 41h
		db	 41h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 3Ch, 3Ch, 41h
		db	 41h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 05h,0F3h,0CFh, 0Ch
		db	 30h, 0Fh,0FFh, 50h, 00h,0FFh
		db	0C0h, 00h, 1Dh, 3Fh,0FCh, 40h
		db	 01h, 03h,0FFh, 74h, 00h,0FFh
		db	0F3h, 00h, 04h,0CCh, 33h, 11h
		db	 44h,0CFh,0FFh, 10h, 00h,0FFh
		db	0FFh, 00h, 00h,0C3h,0C3h, 14h
		db	 14h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 01h, 03h,0C0h,0F4h
		db	 1Fh, 3Fh,0FFh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0CFh,0F3h, 10h
		db	 04h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	0FFh, 01h, 00h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 3Ch, 1Fh, 41h, 03h,0FFh,0F4h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 3Ch, 01h, 41h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h, 3Ch
		db	0C3h, 41h, 14h, 3Ch,0FFh, 41h
		db	 00h,0FFh,0FCh, 00h, 01h, 03h
		db	0FFh,0D4h, 00h,0C0h, 3Fh, 17h
		db	 40h,0FFh,0FFh, 00h, 00h, 0Fh
		db	 3Ch, 50h,0C3h,0F0h,0FFh, 05h
		db	 00h,0FFh,0FFh, 00h, 00h,0F3h
		db	0C3h, 04h, 14h,0CFh,0FFh, 10h
		db	 00h,0FFh,0FFh, 00h, 00h,0F3h
		db	0C3h, 04h, 14h,0CFh,0FFh, 10h
		db	 00h,0FFh,0FFh, 00h, 00h, 0Fh
		db	 3Ch, 50h,0C3h,0F0h,0FFh, 05h
		db	 00h,0FFh,0FCh, 00h, 01h, 03h
		db	0FFh,0D4h, 00h,0C0h, 3Fh, 17h
		db	 40h,0FFh,0FFh, 00h, 00h, 3Ch
		db	0C3h, 41h, 14h, 3Ch,0FFh, 41h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 3Ch, 01h, 41h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 3Ch, 1Fh, 41h, 03h,0FFh,0F4h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	0FFh, 01h, 00h, 3Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh, 3Fh, 00h
		db	 40h,0FCh,0FFh, 01h, 00h,0FCh
		db	0CFh, 01h, 10h,0F3h, 3Fh, 04h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 3Fh,0F3h, 40h, 0Ch,0CFh
		db	0FCh, 30h, 01h,0FFh, 3Fh, 00h
		db	0C0h,0FCh,0FFh, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 3Fh, 00h
		db	0C0h,0FCh,0FFh, 03h, 00h, 3Fh
		db	0F3h, 40h, 0Ch,0CFh,0FCh, 30h
		db	 01h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh,0CFh, 01h, 10h,0F3h
		db	 3Fh, 04h, 40h,0FFh, 3Fh, 00h
		db	 40h,0FCh,0FFh, 01h, 00h, 03h
		db	 00h,0FFh,0F3h, 00h, 04h,0FFh
		db	0CFh, 00h, 10h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CCh, 00h, 11h,0FFh
		db	 33h, 00h, 44h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F3h,0FFh, 04h, 00h, 3Ch
		db	0FFh,0C3h, 00h,0CFh,0FFh, 10h
		db	 00h,0FFh,0F3h, 00h, 0Ch,0FFh
		db	0CFh, 00h, 30h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F3h, 00h, 0Ch,0FFh
		db	0CFh, 00h, 30h,0FFh,0FFh, 00h
		db	 00h,0F3h,0FFh, 04h, 00h, 3Ch
		db	0FFh,0C3h, 00h,0CFh,0FFh, 10h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CCh, 00h, 11h,0FFh
		db	 33h, 00h, 44h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F3h, 00h, 04h,0FFh
		db	0CFh, 00h, 10h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h, 3Fh,0FCh, 40h, 01h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h,0CFh,0F3h, 10h, 04h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 3Fh, 00h
		db	 40h,0F3h,0CFh, 0Ch, 30h,0FCh
		db	0FFh, 01h, 00h,0FFh,0FFh, 00h
		db	 00h, 3Fh,0FCh,0C0h, 03h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 3Fh,0FCh,0C0h, 03h,0FFh
		db	0FFh, 00h, 00h,0FFh, 3Fh, 00h
		db	 40h,0F3h,0CFh, 0Ch, 30h,0FCh
		db	0FFh, 01h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 01h,0CFh,0F3h, 10h, 04h, 3Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h, 3Fh,0FCh, 40h, 01h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0F3h,0FFh, 04h
		db	 00h,0CFh,0FFh, 10h, 00h,0FFh
		db	0FFh, 00h, 00h,0CCh,0FFh, 11h
		db	 00h, 33h,0FFh, 44h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F3h, 00h, 04h,0FFh, 3Ch, 00h
		db	0C3h,0FFh,0CFh, 00h, 10h,0FFh
		db	0FFh, 00h, 00h,0F3h,0FFh, 0Ch
		db	 00h,0CFh,0FFh, 30h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F3h,0FFh, 0Ch
		db	 00h,0CFh,0FFh, 30h, 00h,0FFh
		db	0F3h, 00h, 04h,0FFh, 3Ch, 00h
		db	0C3h,0FFh,0CFh, 00h, 10h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0CCh,0FFh, 11h
		db	 00h, 33h,0FFh, 44h, 00h,0FFh
		db	0FFh, 00h, 00h,0F3h,0FFh, 04h
		db	 00h,0CFh,0FFh, 10h, 00h, 01h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 0Fh, 03h,0F0h,0F0h, 03h, 0Fh
		db	0FCh,0C0h, 00h, 3Fh,0FFh,0C0h
		db	 00h, 3Fh,0FBh,0C0h, 00h, 3Fh
		db	0FBh,0F0h, 03h, 0Fh,0ACh,0FCh
		db	 0Fh, 03h,0F0h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 3Fh,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	0FFh, 3Fh,0FFh,0C0h, 00h,0FCh
		db	 00h, 03h,0FFh, 0Fh,0FFh,0F0h
		db	 00h,0FCh, 00h, 03h,0FFh, 0Fh
		db	0FFh,0B0h, 00h,0FCh, 00h, 03h
		db	0FFh, 0Fh,0FFh,0B0h, 00h,0FFh
		db	 00h, 00h,0FAh, 3Fh,0FFh,0C0h
		db	 00h,0FFh,0C0h, 00h, 3Fh,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0F0h, 00h
		db	 0Fh, 03h,0FFh,0FCh, 00h,0FFh
		db	0C0h, 00h, 3Fh, 00h,0FFh,0FFh
		db	 00h,0FFh,0C0h, 00h, 3Fh, 00h
		db	0FFh,0FBh, 00h,0FFh,0C0h, 00h
		db	 3Fh, 00h,0FFh,0FBh, 00h,0FFh
		db	0F0h, 00h, 0Fh, 03h,0FFh,0ACh
		db	 00h,0FFh,0FCh, 00h, 03h, 0Fh
		db	0FFh,0F0h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	0FFh, 3Fh, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0FFh,0C0h,0FFh
		db	0FCh, 00h, 03h, 00h, 0Fh,0FFh
		db	0F0h,0FFh,0FCh, 00h, 03h, 00h
		db	 0Fh,0FFh,0B0h,0FFh,0FCh, 00h
		db	 03h, 00h, 0Fh,0FFh,0B0h,0FFh
		db	0FFh, 00h, 00h, 00h, 3Fh,0FAh
		db	0C0h,0FFh,0FFh, 00h, 00h,0C0h
		db	0FFh, 3Fh, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 0Fh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h,0C0h, 3Fh, 0Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h,0C3h
		db	0C0h, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h, 0Ch
		db	 00h, 00h, 3Ch, 00h, 03h,0FAh
		db	0F0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 03h,0F4h, 00h, 03h,0ACh
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 0Fh, 54h, 00h, 03h,0A0h
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 3Dh, 55h, 00h, 00h, 20h
		db	 80h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 3Ah
		db	0CFh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 4Fh
		db	 35h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 15h, 55h, 00h, 00h, 50h
		db	0D4h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 05h, 55h, 00h, 00h, 55h
		db	 57h, 3Fh,0FFh, 00h, 00h,0C0h
		db	 00h, 05h, 5Ch, 00h, 00h, 54h
		db	 54h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 00h,0D7h, 00h, 03h, 15h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 37h, 00h,0FFh, 10h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 17h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 14h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0DCh, 3Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 57h, 0Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h,0C0h
		db	 3Fh, 0Fh, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Ah,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h, 00h, 00h, 00h, 00h
		db	 03h,0ACh,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 00h,0FCh, 00h
		db	 03h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Fh,0D4h, 00h
		db	 00h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 3Ah,0C3h, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 3Fh,0CDh, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 4Fh, 35h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 15h, 05h, 00h
		db	 00h, 50h, 54h, 0Fh,0FFh, 40h
		db	 00h,0C0h, 00h, 05h,0F1h, 00h
		db	 00h, 55h, 57h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 0Dh, 5Ch, 00h
		db	 00h, 54h, 54h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 00h, 5Ch, 00h
		db	 03h, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 51h, 00h
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 03h, 40h, 03h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 44h, 03h
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 54h, 0Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 03h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C3h,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0C0h, 3Fh, 0Fh, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h, 00h, 0Fh, 3Fh,0C0h,0FFh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h, 00h, 0Fh, 3Fh,0C0h,0FFh
		db	0FFh, 00h, 00h,0C3h, 00h, 00h
		db	 00h, 00h, 03h,0FAh,0F0h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	0FCh, 00h, 03h,0ACh,0A0h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 0Fh
		db	0D4h, 00h, 03h,0A0h,0A0h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 3Dh
		db	 55h, 00h, 00h, 20h, 80h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 35h
		db	 55h, 00h, 00h, 3Ah,0CFh, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 37h
		db	 15h, 00h, 00h, 4Fh, 35h, 0Fh
		db	0FFh,0C0h, 00h, 00h, 00h, 15h
		db	0C5h, 00h, 00h, 50h, 55h, 0Fh
		db	0FFh, 40h, 00h,0C0h, 00h, 0Dh
		db	 71h, 00h, 00h, 55h, 54h, 0Fh
		db	0FFh, 40h, 00h,0C0h, 00h, 01h
		db	 51h, 00h, 00h, 54h, 57h, 3Fh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 45h, 00h, 00h, 55h, 14h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 0Dh
		db	 01h, 00h,0C3h, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 05h
		db	 5Ch, 03h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 00h
		db	 54h, 00h,0FFh, 44h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 01h, 00h,0FFh, 54h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 03h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 0Fh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h,0C0h, 3Fh, 0Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h, 0Fh
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	0F0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h,0FCh, 00h, 03h,0FAh
		db	0F0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 0Fh,0D4h, 00h, 03h,0ACh
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 3Dh, 55h, 00h, 0Fh, 20h
		db	 80h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 20h
		db	 80h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 4Ah
		db	 3Fh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 15h, 41h, 00h, 00h, 50h
		db	0D5h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 07h, 7Ch, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 04h, 54h, 00h, 00h, 55h
		db	 54h, 0Fh,0FFh, 40h, 00h,0F0h
		db	 00h, 00h, 51h, 00h, 00h, 54h
		db	 57h, 3Fh,0FFh, 00h, 00h,0F0h
		db	 00h, 03h, 41h, 00h, 00h, 50h
		db	 14h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 44h, 0Fh,0C3h, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 54h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 01h, 03h,0FFh, 30h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 05h, 03h,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h,0C0h
		db	 3Fh, 0Fh, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0C0h, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h, 0Ch, 00h, 00h, 3Ch, 00h
		db	 03h,0FAh,0F0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 03h,0F4h, 00h
		db	 03h,0ACh,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Fh, 54h, 00h
		db	 03h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 20h, 80h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 3Ah,0CFh, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h
		db	35h
data_a_BEF2	db	55h
		db	 00h, 00h, 4Fh, 35h, 0Fh,0FFh
		db	 40h, 00h, 00h, 00h, 15h, 51h
		db	 00h, 00h, 50h, 55h, 0Fh,0FFh
		db	 40h, 00h,0C0h, 00h, 05h, 5Ch
		db	 00h, 00h, 55h, 54h, 0Fh,0FFh
		db	 40h, 00h,0C0h, 00h, 05h, 54h
		db	 00h, 00h, 54h, 57h, 3Fh,0FFh
		db	 00h, 00h,0F0h, 00h, 01h, 14h
		db	 00h, 00h, 55h, 14h,0FFh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0D4h
		db	 00h,0C3h, 10h, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h, 50h
		db	 0Fh,0FFh,0C0h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 15h
		db	 0Fh,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0C0h
		db	 0Fh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h, 55h
		db	 0Fh,0FFh, 40h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	 3Fh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0C3h,0FFh
		db	 00h, 00h,0F0h,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h,0FFh
		db	 00h, 00h,0C0h, 3Fh, 0Fh, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h,0FFh
		db	 00h, 00h, 00h, 0Fh, 3Fh,0C0h
		db	0FFh,0FFh, 00h, 00h,0F0h,0FFh
		db	 00h, 00h, 00h, 0Fh, 3Ah,0C0h
		db	0FFh,0FFh, 00h, 00h,0C3h, 00h
		db	 00h, 00h, 00h, 03h,0ACh,0A0h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 00h,0FCh, 00h, 03h,0A0h,0A0h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 0Fh,0D4h, 00h, 00h,0A0h,0A0h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 3Dh, 55h, 00h, 00h, 3Ah,0C3h
		db	 3Fh,0FFh, 00h, 00h, 00h, 00h
		db	 35h, 55h, 00h, 00h, 3Fh,0CDh
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 35h, 55h, 00h, 00h, 4Fh, 35h
		db	 0Fh,0FFh, 40h, 00h, 00h, 00h
		db	 15h, 54h, 00h, 00h, 50h, 54h
		db	 0Fh,0FFh, 40h, 00h,0C0h, 00h
		db	 05h, 57h, 00h, 00h, 15h, 57h
		db	 3Fh,0FFh, 00h, 00h,0C0h, 00h
		db	 05h, 45h, 00h, 00h,0C4h, 14h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 01h, 51h, 00h, 03h, 45h, 00h
data_a_C031	db	0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	 11h, 00h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 03h
		db	 4Dh, 03h,0FFh, 30h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 45h, 03h,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	 50h, 0Fh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 03h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h,0C0h, 3Fh, 0Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h, 00h, 0Fh, 3Ah
		db	0C0h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h, 00h, 0Fh, 2Ch
		db	 80h,0FFh,0FFh, 00h, 00h,0C3h
		db	 00h, 00h, 00h, 00h, 03h,0A0h
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h,0FCh, 00h, 03h,0A0h
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 0Fh,0D4h, 00h, 03h,0FAh
		db	0F0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 3Dh, 55h, 00h, 00h, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 3Fh
		db	0CFh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 4Fh
		db	 35h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 15h, 57h, 00h, 00h, 50h
		db	 55h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 05h, 55h, 00h, 00h, 15h
		db	 54h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 05h, 55h, 00h, 00h,0C4h
		db	 57h, 3Fh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 55h, 00h, 00h, 71h
		db	 14h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Ch, 13h, 00h,0C3h, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 05h, 4Dh, 03h,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 00h, 45h, 00h,0FFh, 34h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 01h, 00h,0FFh, 54h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 03h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h,0C0h
		db	 3Fh, 0Fh, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Ah,0C0h,0FFh,0FFh, 00h
		db	 00h, 0Fh, 00h, 00h, 00h, 00h
		db	 03h,0ACh,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 00h,0FCh, 00h
		db	 03h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Fh,0D4h, 00h
		db	 03h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 3Ah,0C0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 3Fh,0CFh, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 4Fh, 35h, 0Fh,0FFh, 40h
		db	 00h, 00h, 00h, 15h, 5Dh, 00h
		db	 00h, 50h, 55h, 0Fh,0FFh, 40h
		db	 00h,0C0h, 00h, 05h, 54h, 00h
		db	 00h, 55h, 54h, 0Fh,0FFh, 40h
		db	 00h,0C0h, 00h, 05h, 57h, 00h
		db	 00h, 14h,0D7h, 3Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 75h, 00h
		db	 00h,0C5h, 14h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 00h, 11h, 00h
		db	0C3h, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 03h, 41h, 0Fh
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 4Dh, 0Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 0Dh, 03h
		db	0FFh, 30h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 05h, 03h
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h, 0Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C0h, 3Fh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C3h,0FFh, 00h
		db	 00h, 00h, 0Fh, 3Ch,0C0h,0FFh
		db	0FFh, 00h, 00h,0F0h,0FCh, 00h
		db	 00h, 00h, 03h,0FFh, 30h,0FFh
		db	0FFh, 00h, 00h,0F0h,0C0h, 00h
		db	 00h, 00h, 03h,0EBh, 30h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 00h
		db	 32h, 00h, 00h,0B2h, 88h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 03h
		db	0F2h, 00h, 00h, 82h, 80h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 0Fh
		db	 52h, 00h, 00h, 82h, 80h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 3Dh
		db	 54h, 00h, 00h,0EBh, 3Ch,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 35h
		db	 54h, 00h, 00h,0FFh, 37h, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 35h
		db	 55h, 00h, 00h, 3Ch,0D5h, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 15h
		db	0C5h, 00h, 00h, 41h, 45h, 3Fh
		db	0FFh, 00h, 00h,0C0h, 00h, 05h
		db	 71h, 00h, 00h, 55h, 74h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 05h
		db	 5Ch, 00h, 03h, 51h, 50h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 1Ch, 00h, 0Fh, 54h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	 54h, 03h,0FFh, 50h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 03h
		db	 50h, 0Fh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 53h, 03h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	 55h, 00h,0FFh, 1Ch, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 00h,0FFh, 54h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 03h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FCh, 00h, 00h, 3Ch
		db	 3Fh, 00h, 00h,0FCh, 30h, 00h
		db	 03h, 00h, 0Fh,0C3h,0C0h,0FCh
		db	 00h, 00h, 0Fh, 00h, 03h,0F3h
		db	0F0h,0F0h, 00h, 00h, 0Fh, 00h
		db	 03h,0F3h,0F0h,0C0h, 00h, 03h
		db	 3Eh, 00h, 00h,0BCh,0ACh,0C0h
		db	 00h, 0Fh, 2Bh, 00h, 00h, 28h
		db	0C0h, 00h, 00h, 0Dh, 28h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 3Dh
		db	 28h, 00h, 03h, 0Fh, 00h, 00h
		db	 00h, 35h, 4Ch, 00h, 03h, 35h
		db	0D0h, 00h, 00h, 35h, 50h, 00h
		db	 03h,0D5h, 50h, 00h, 00h, 17h
		db	 14h, 00h, 03h, 51h, 40h,0C0h
		db	 00h, 05h,0C5h, 00h, 0Fh, 1Dh
		db	 40h,0C0h, 00h, 01h,0C5h, 00h
		db	 3Fh, 15h, 00h,0F0h, 00h, 01h
		db	 45h, 00h,0FFh, 40h, 00h,0C0h
		db	 00h, 0Dh, 05h, 00h,0FFh, 50h
		db	 00h,0C0h, 00h, 0Dh, 50h, 03h
		db	0FFh, 00h, 00h,0C0h, 0Ch, 05h
		db	 40h, 00h,0FFh, 40h, 00h,0F0h
		db	 3Ch, 00h, 00h, 00h, 3Fh, 5Fh
		db	 00h,0FFh,0FCh, 00h, 00h, 00h
		db	 3Fh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 03h, 00h
		db	 00h,0FCh, 3Fh, 00h, 00h,0FFh
		db	 00h, 00h, 3Ch,0F0h, 0Fh, 03h
		db	0C0h,0FCh, 00h, 00h,0FFh, 00h
		db	 03h, 0Fh,0F0h,0FCh, 00h, 00h
		db	0FFh, 00h, 03h, 0Fh,0F0h,0F0h
		db	 00h, 03h,0EBh, 00h, 00h,0CEh
		db	0BCh,0C0h, 00h, 02h,0B2h, 00h
		db	 00h, 8Bh, 28h,0C0h, 00h, 02h
		db	 82h, 00h, 00h, 80h, 28h, 00h
		db	 00h, 34h, 82h, 00h, 00h, 3Ch
		db	 28h, 00h, 00h, 34h,0E8h, 00h
		db	 03h,0D5h, 30h, 00h, 00h, 35h
		db	 33h, 00h, 03h, 55h, 00h, 00h
		db	 00h, 15h, 43h, 00h, 03h, 14h
		db	 10h,0C0h, 00h, 05h, 51h, 00h
		db	 03h,0D7h, 10h,0C0h, 00h, 05h
		db	 14h, 00h, 0Fh, 54h, 40h,0F0h
		db	 00h, 01h,0C5h, 00h, 3Fh, 01h
		db	 00h,0F0h, 00h, 01h, 45h, 00h
		db	 3Fh, 50h, 00h,0F0h, 00h, 00h
		db	 40h, 00h,0FFh, 04h, 00h,0C0h
		db	 0Fh, 0Dh, 00h,0C0h, 3Fh, 04h
		db	 00h,0C0h, 0Fh, 05h, 40h,0C0h
		db	 0Fh, 03h, 40h,0F0h, 3Fh, 00h
		db	 00h,0C0h, 0Fh, 05h, 40h,0FFh
		db	0FFh, 00h, 00h,0F0h, 3Fh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 30h, 00h, 00h,0FCh, 3Fh, 00h
		db	 00h,0F0h, 0Ch, 03h,0C0h, 30h
		db	 0Fh, 03h,0C0h,0C0h, 00h, 0Fh
		db	0F0h, 00h, 03h, 0Fh,0F0h,0C0h
		db	 00h, 0Fh,0F0h, 00h, 03h, 0Fh
		db	0F0h, 00h, 00h, 3Eh,0BCh, 00h
		db	 00h, 3Eh,0BCh, 00h, 00h, 2Bh
		db	 28h, 00h, 00h, 28h,0E8h, 00h
		db	 00h, 28h, 00h, 00h, 00h, 00h
		db	 28h, 00h, 00h, 08h, 0Fh, 00h
		db	 00h,0F0h, 20h, 00h, 00h, 0Eh
		db	 3Dh, 00h, 00h, 5Ch,0B0h, 00h
		db	 00h, 13h, 35h, 00h, 00h, 54h
		db	0C4h, 00h, 00h, 34h, 31h, 00h
		db	 00h, 44h, 14h,0C0h, 00h, 05h
		db	 1Dh, 00h, 03h, 74h, 50h,0C0h
		db	 00h, 0Dh, 45h, 00h, 03h, 51h
		db	 50h,0C0h, 00h, 0Dh, 70h, 00h
		db	 03h, 0Dh, 50h,0F0h, 00h, 01h
		db	 15h, 00h, 0Fh, 54h, 40h,0F0h
		db	 00h, 01h, 40h, 00h, 0Fh, 01h
		db	 40h,0F0h, 03h, 00h, 50h,0C0h
		db	 0Fh, 05h, 00h,0C0h, 0Fh, 0Dh
		db	 00h,0F0h, 03h, 00h,0D0h,0C0h
		db	 0Fh, 05h, 40h,0F0h, 03h, 01h
		db	 50h,0F0h, 3Fh, 00h, 00h,0FCh
		db	 0Fh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 0Fh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h,0C0h, 3Fh, 0Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h,0C3h
		db	0C0h, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0FFh,0FFh, 00h, 00h, 0Ch
		db	 00h, 00h, 3Ch, 00h, 03h,0FAh
		db	0F0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 03h,0F4h, 00h, 03h,0ACh
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 0Fh, 54h, 00h, 00h,0A0h
		db	0A0h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 3Dh, 55h, 00h, 00h, 20h
		db	 8Fh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 3Ah
		db	0CDh, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 35h,0C1h, 00h, 00h, 4Fh
		db	 35h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 15h, 7Ch, 00h, 00h, 50h
		db	 54h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 05h, 57h, 00h, 00h, 15h
		db	 57h, 3Fh,0FFh, 00h, 00h,0C0h
		db	 00h, 05h, 15h, 00h, 00h, 14h
		db	 54h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 34h, 00h, 03h, 57h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 34h, 00h,0FFh, 10h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0D1h, 0Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 55h, 0Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h,0C0h
		db	 3Fh, 0Fh, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0C0h, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 00h, 3Ch, 00h
		db	 03h,0FAh,0F0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 03h,0F4h, 00h
		db	 03h,0ACh,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Fh, 54h, 00h
		db	 00h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 20h, 83h, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 5Ch, 00h
		db	 00h, 3Ah,0CDh, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 35h, 57h, 00h
		db	 00h, 0Fh, 35h, 0Fh,0FFh, 40h
		db	 00h, 00h, 00h, 15h, 55h, 00h
		db	 00h, 10h, 54h, 0Fh,0FFh, 40h
		db	 00h,0C0h, 00h, 05h, 34h, 00h
		db	 00h, 55h, 57h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 05h, 34h, 00h
		db	 00h, 14h, 54h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 00h,0D1h, 00h
		db	 03h,0C7h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 55h, 00h
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h,0C0h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 00h
		db	 3Fh, 0Fh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 03h
		db	0F7h, 03h, 03h,0F0h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 0Fh
		db	 55h, 00h, 00h, 5Ch,0FCh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 0Dh
		db	 55h, 00h, 00h, 53h,0FFh, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 3Dh
		db	 55h, 00h, 00h, 4Ah,0AFh, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 35h
		db	 55h, 00h, 00h, 4Ah,0CBh, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 35h
		db	 75h, 00h, 00h, 48h, 0Bh, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 15h
		db	 51h, 00h, 00h, 52h, 28h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 04h
		db	 5Ch, 00h, 00h, 53h, 80h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 00h
		db	 54h, 00h, 00h, 54h, 3Fh, 3Fh
		db	0FFh, 00h, 00h,0F0h, 00h, 00h
		db	0D4h, 00h, 00h, 55h,0D7h, 0Fh
		db	0FFh,0C0h, 00h,0C0h, 00h, 0Dh
		db	 51h, 00h, 00h, 5Dh, 55h, 0Fh
		db	0FFh, 40h, 00h,0C0h, 00h, 0Dh
		db	 00h, 00h, 00h, 54h, 51h, 0Fh
		db	0FFh, 40h, 00h,0C0h, 03h, 05h
		db	 30h, 00h, 00h, 00h, 54h, 3Fh
		db	0FFh, 00h, 00h,0F0h, 03h, 01h
		db	 50h,0FFh, 03h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 03h, 00h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 0Fh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C3h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C3h
		db	0FFh, 00h, 00h, 00h,0FFh, 3Ch
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FCh, 00h, 00h, 00h, 3Fh,0FFh
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FCh, 00h, 00h, 00h, 3Fh,0FFh
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0C0h, 00h, 00h, 00h, 0Fh,0FFh
		db	0C0h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 00h, 3Ch, 00h, 00h,0EBh
		db	 80h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 03h,0F4h, 00h, 00h,0B2h
		db	 8Fh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 0Fh, 55h, 00h, 00h, 02h
		db	 8Dh, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 3Dh, 55h, 00h, 00h, 02h
		db	 34h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 4Bh
		db	 15h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 50h
		db	 55h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 55h
		db	 45h, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 15h, 5Ch, 00h, 00h, 15h
		db	 50h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 05h, 57h, 00h, 0Fh,0C5h
		db	 40h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Dh, 55h, 00h, 3Fh, 44h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 45h, 00h, 0Fh, 41h
		db	0C0h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 51h, 00h, 0Fh, 4Ch
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 01h, 00h, 3Fh, 54h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 01h, 00h,0FFh, 50h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h, 00h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FCh, 00h, 00h, 00h
		db	 3Fh,0CFh, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FCh, 00h, 00h, 00h
		db	 0Fh,0CFh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h, 00h, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C0h, 00h, 00h,0FFh, 00h
		db	 03h, 3Eh,0B0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 03h,0D5h, 00h
		db	 03h, 2Bh, 20h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Fh, 55h, 00h
		db	 03h, 28h, 20h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Dh, 55h, 00h
		db	 00h, 48h, 20h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 4Eh,0B3h, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 53h,0CDh, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 5Dh, 00h
		db	 00h, 54h, 35h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 05h, 57h, 00h
		db	 00h, 15h, 51h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 05h, 55h, 00h
		db	 00h,0C4h, 54h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 51h, 00h
		db	 03h, 45h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 53h, 00h
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 03h, 0Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0CDh, 03h
		db	0FFh, 30h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0C5h, 03h
		db	0FFh, 50h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 50h, 0Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	0FCh, 00h, 00h, 30h,0FFh, 00h
		db	 00h,0FCh, 30h, 00h, 03h, 00h
		db	 3Fh,0CFh, 00h,0FCh, 00h, 00h
		db	 0Fh, 00h, 0Fh,0CFh,0C0h,0FCh
		db	 00h, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C0h,0F0h, 00h, 00h, 3Dh, 00h
		db	 03h, 3Fh,0F0h,0C0h, 00h, 0Ch
		db	 35h, 00h, 03h, 3Eh,0B0h, 00h
		db	 00h, 3Ch, 15h, 00h, 03h, 2Bh
		db	 20h, 00h, 00h, 30h, 55h, 00h
		db	 03h, 28h, 20h, 00h, 00h, 31h
		db	 55h, 00h, 03h, 28h, 20h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 4Eh
		db	 8Ch, 00h, 00h, 35h, 57h, 00h
		db	 00h, 0Fh, 34h, 00h, 00h, 15h
		db	 55h, 00h, 00h,0F0h, 54h,0C0h
		db	 00h, 05h, 51h, 00h, 03h, 50h
		db	 50h,0C0h, 00h, 01h, 54h, 00h
		db	 0Fh, 51h, 00h,0F0h, 00h, 00h
		db	 14h, 00h,0FFh, 40h, 00h,0F0h
		db	 00h, 03h, 40h, 00h, 3Fh, 51h
		db	 00h,0C0h, 0Ch, 0Dh, 00h, 00h
		db	 3Fh, 55h, 00h,0C0h, 03h, 0Dh
		db	 10h, 00h,0FFh, 00h, 00h,0C0h
		db	 03h, 05h, 50h,0FFh,0FFh, 00h
		db	 00h,0F0h, 0Fh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h
data_a_CB13	db	0FFh
data_a_CB14	db	3
data_a_CB15	dw	0
data_a_CB17	db	0FCh
		db	 3Fh, 00h, 00h,0FFh, 00h, 00h
		db	 00h,0F0h, 0Fh, 03h,0C0h,0FCh
		db	 00h, 00h,0C3h, 00h, 03h, 0Fh
		db	0F0h,0FCh, 00h, 00h, 00h, 00h
		db	 03h, 0Fh
data_a_CB32	db	0F0h
		db	0F0h, 00h, 00h,0C3h, 00h, 00h
		db	 4Fh,0A8h,0C0h, 00h, 0Fh, 05h
		db	 00h, 00h, 4Ah,0B0h,0C0h, 00h
		db	 0Dh, 05h, 00h, 00h, 4Ah, 80h
		db	 00h, 00h, 3Ch, 15h, 00h, 03h
		db	 4Ah, 80h, 00h, 00h, 34h, 55h
		db	 00h, 00h, 53h,0A0h, 00h, 00h
		db	 35h, 55h, 00h, 00h, 53h,0CCh
		db	 00h, 00h, 15h, 55h, 00h, 00h
		db	 54h, 34h,0C0h, 00h, 05h, 55h
		db	 00h, 03h, 75h, 50h,0C0h, 00h
		db	 05h, 55h, 00h, 0Fh, 54h, 40h
		db	0F0h, 00h, 01h, 55h, 00h, 3Fh
		db	 17h, 00h
data_a_CB83	db	0F0h
		db	 00h, 00h, 55h, 00h, 3Fh, 45h
		db	 00h,0F0h, 00h, 01h, 00h, 00h
		db	 3Fh, 05h, 00h,0C0h, 3Fh, 0Dh
		db	 00h,0C0h, 0Fh, 05h, 40h,0C0h
		db	 0Fh, 0Dh, 40h,0C0h, 0Fh, 0Dh
		db	 40h,0C0h, 0Fh, 05h
		db	40h
data_a_CBA7	db	0F0h
		db	 3Fh, 00h, 00h,0F0h, 3Fh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh
data_a_CBB7	db	0
data_a_CBB8	db	0
data_a_CBB9	db	0FFh
		db	0FFh, 00h, 00h,0FFh, 0Ch, 00h
		db	 00h, 30h,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0F0h,0C0h
data_a_CBCA	dw	0F3Fh
data_a_CBCC	dw	0F000h
		db	 00h, 03h,0F0h, 00h, 0Fh, 3Fh
		db	0C0h,0F0h, 00h, 03h,0A0h, 00h
		db	 0Fh, 0Ah,0C0h,0C0h, 00h, 08h
		db	 00h, 00h, 03h, 50h,0A0h,0C0h
		db	 00h, 03h,0F0h, 00h, 03h, 55h
		db	 00h,0C0h
data_a_CBEE	db	0
data_a_CBEF	db	0Fh
		db	 50h, 00h, 03h, 55h, 50h, 00h
		db	 00h, 3Dh, 50h, 00h, 00h, 55h
		db	 54h, 00h, 00h, 35h, 54h, 00h
		db	 00h, 15h, 54h, 00h, 00h, 35h
		db	 57h, 00h, 00h, 15h, 54h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 55h
		db	 54h,0C0h, 00h, 05h, 55h, 00h
		db	 03h, 55h, 50h,0C0h, 00h, 0Dh
		db	 55h, 00h, 03h, 55h, 50h,0C0h
		db	 00h, 01h, 55h, 00h, 03h, 55h
		db	 40h,0F0h, 00h, 00h, 55h, 00h
		db	 0Fh, 55h, 00h,0F0h, 00h, 01h
		db	 00h, 00h, 0Fh, 00h, 40h,0F0h
		db	 0Fh, 01h, 40h,0F0h, 0Fh, 01h
		db	 40h,0C0h, 3Fh, 0Dh, 00h,0FCh
		db	 03h, 00h, 50h,0C0h, 3Fh, 05h
data_a_CC50	dw	0FC00h
data_a_CC52	db	3
data_a_CC53	db	0
data_a_CC54	db	0D0h
data_a_CC55	db	0F0h
data_a_CC56	db	0FFh
data_a_CC57	db	0
		db	 00h,0FFh, 0Fh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
data_a_CC70	db	0Ch
data_a_CC71	db	0
		db	0
data_a_CC73	dw	0FF30h
data_a_CC75	db	0
data_a_CC76	db	0
data_a_CC77	db	0FCh
		db	 00h, 00h,0F0h, 00h, 3Fh, 0Fh
		db	 00h,0FCh, 00h, 00h,0F0h, 00h
		db	 3Fh, 3Fh, 00h,0F0h, 00h, 03h
		db	0A0h, 00h, 0Fh, 0Ah,0C0h,0F0h
		db	 00h, 00h, 04h, 00h, 0Fh, 10h
		db	0C0h,0F0h, 00h, 03h,0F0h, 00h
		db	 0Fh, 55h, 00h,0F0h, 00h, 03h
		db	 50h, 00h, 0Fh, 55h, 40h,0C0h
		db	 00h, 0Fh, 54h, 00h, 03h, 15h
		db	 50h,0C0h, 00h, 0Dh, 55h, 00h
		db	 03h, 15h, 50h,0C0h, 00h, 0Dh
		db	 55h, 00h, 03h, 55h, 50h,0C0h
		db	 00h, 05h, 55h, 00h, 03h, 55h
		db	 50h,0F0h, 00h, 01h, 55h, 00h
		db	 0Fh, 55h, 40h,0F0h, 00h, 01h
		db	 55h, 00h, 0Fh, 55h, 40h,0FCh
		db	 00h, 00h, 55h, 00h, 0Fh, 55h
		db	 00h,0F0h, 00h, 03h, 00h, 00h
		db	 0Fh, 00h, 40h,0F0h, 0Fh, 01h
		db	 40h,0FCh, 03h, 00h, 50h,0C0h
		db	 3Fh, 0Dh, 00h,0FCh, 03h, 00h
		db	0D0h,0C0h, 3Fh, 05h, 00h,0FFh
		db	 0Fh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 0Ch, 00h, 00h, 30h
		db	0FFh, 00h, 00h,0FCh, 03h, 00h
		db	0F0h, 00h, 3Fh, 0Fh, 00h,0FCh
		db	 00h, 00h,0FCh, 00h, 3Fh, 3Fh
		db	 00h,0F0h, 00h, 03h,0E0h, 00h
		db	 0Fh, 0Bh,0C0h,0F0h, 00h, 03h
		db	 0Ch, 00h, 0Fh, 10h,0C0h,0FCh
		db	 00h, 00h,0F4h, 00h, 3Fh, 15h
		db	 00h,0F0h, 00h, 03h,0D4h, 00h
		db	 0Fh, 55h, 40h,0F0h, 00h, 03h
		db	 54h, 00h, 0Fh, 55h, 40h,0F0h
		db	 00h, 03h, 55h, 00h, 0Fh, 55h
		db	 40h,0F0h, 00h, 01h, 55h, 00h
		db	 0Fh, 55h, 40h,0FCh, 00h, 00h
		db	 55h, 00h, 3Fh, 55h, 00h,0FCh
		db	 00h, 00h, 55h, 00h, 3Fh, 55h
		db	 00h,0FCh, 00h, 00h, 15h, 00h
		db	0FFh, 54h, 00h,0FCh, 00h, 00h
		db	 40h, 00h, 3Fh, 00h, 00h,0F0h
		db	 0Fh, 03h, 40h,0C0h, 3Fh, 05h
		db	 00h,0F0h, 0Fh, 01h, 40h,0F0h
		db	 0Fh, 01h, 40h,0FCh, 3Fh, 00h
		db	 00h,0F0h, 0Fh, 03h, 40h,0FFh
		db	0FFh, 00h, 00h,0FCh, 3Fh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
data_a_CDC8	db	0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 00h,0C3h,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 0Ch
		db	 00h,0FFh, 0Ch, 00h,0FFh, 00h
		db	 00h, 3Fh, 00h, 3Fh, 3Fh, 00h
		db	0FFh, 00h, 00h, 38h, 00h, 3Fh
		db	 03h, 00h,0FFh, 00h, 00h, 00h
		db	 00h, 3Fh,0D4h, 00h,0FFh, 00h
		db	 00h, 3Ch, 00h, 3Fh, 55h, 00h
		db	0FCh, 00h, 00h,0F5h, 00h, 0Fh
		db	 15h, 40h,0FCh, 00h, 00h,0D5h
		db	 00h, 0Fh, 15h, 40h,0FCh, 00h
		db	 00h,0D5h, 00h, 0Fh, 55h, 40h
		db	0FCh, 00h, 00h, 55h, 00h, 0Fh
		db	 55h, 40h,0FFh, 00h, 00h, 15h
		db	 00h, 3Fh, 55h, 00h,0FFh,0C0h
		db	 00h, 01h, 00h, 3Fh, 54h, 00h
		db	0FFh,0C0h, 00h, 00h, 00h, 3Fh
		db	 00h, 00h,0FFh, 00h, 00h, 34h
		db	0F0h, 0Fh, 01h, 40h,0FFh, 00h
		db	 00h, 14h,0F0h, 0Fh, 03h, 40h
		db	0FFh,0C3h, 00h, 00h,0FCh, 3Fh
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0C3h, 00h, 00h
		db	0C3h,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Ch, 00h,0FFh, 3Ch, 00h
		db	0FCh, 00h, 00h,0FCh, 00h, 3Fh
		db	 3Fh, 00h,0FCh, 00h, 00h,0E8h
		db	 00h, 3Fh, 2Bh, 00h,0FCh, 00h
		db	 00h,0B0h, 00h, 3Fh, 0Eh, 00h
		db	0FCh, 00h, 00h, 00h, 00h, 3Fh
		db	 00h, 00h,0F0h, 00h, 03h, 23h
		db	 00h, 0Fh,0C8h, 40h,0F0h, 00h
		db	 03h, 4Dh, 00h, 0Fh, 51h, 40h
		db	0F0h, 00h, 03h, 44h, 00h, 0Fh
		db	 41h, 40h,0F0h, 00h, 01h, 51h
		db	 00h, 0Fh, 45h, 40h,0FCh, 00h
		db	 00h, 54h, 00h, 3Fh, 15h, 00h
		db	0FCh, 00h, 00h, 45h, 00h, 3Fh
		db	 45h, 00h,0FCh, 00h, 00h, 10h
		db	 00h,0FFh, 10h, 00h,0F0h, 0Fh
		db	 03h, 40h,0C0h, 3Fh, 05h, 00h
		db	0F0h, 0Fh, 01h, 40h,0C0h, 3Fh
		db	 05h, 00h,0FCh, 3Fh, 00h, 00h
		db	0F0h,0FFh, 00h, 00h, 02h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 03h, 00h, 00h,0C0h,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0FCh
		db	 00h, 3Fh, 3Fh, 00h,0FCh, 00h
		db	 00h,0FCh, 00h, 3Fh, 3Fh, 00h
		db	0F0h, 00h, 03h,0ACh, 00h, 0Fh
		db	 3Ah,0C0h,0F0h, 00h, 02h,0C8h
		db	 00h, 0Fh, 2Ch, 80h,0F0h, 00h
		db	 02h, 00h, 00h, 0Fh, 00h, 80h
		db	0F0h, 00h, 00h, 83h, 00h, 0Fh
		db	0F0h, 00h,0C0h, 00h, 0Ch, 0Fh
		db	 00h, 03h, 54h, 10h,0C0h, 00h
		db	 0Dh, 0Dh, 00h, 03h, 54h, 50h
		db	0C0h, 00h, 05h, 44h, 00h, 03h
		db	 44h, 50h,0F0h, 00h, 01h, 53h
		db	 00h, 0Fh, 71h, 40h,0F0h, 00h
		db	 01h, 54h, 00h, 0Fh, 05h, 40h
		db	0FCh, 00h, 00h, 45h, 00h, 3Fh
		db	 51h, 00h,0FCh, 00h, 00h, 50h
		db	 00h, 3Fh, 04h, 00h,0FCh, 03h
		db	 00h, 10h,0F0h, 0Fh, 01h, 40h
		db	0F0h, 0Fh, 03h, 40h,0F0h, 0Fh
		db	 01h, 40h,0F0h, 0Fh, 01h, 40h
		db	0FCh, 3Fh, 00h, 00h,0FCh, 3Fh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 02h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 03h, 00h, 00h,0C0h,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0F0h
		db	 00h, 3Fh, 0Fh, 00h,0F0h, 00h
		db	 03h,0FCh, 00h, 0Fh, 3Fh,0C0h
		db	0F0h, 00h, 03h,0FCh, 00h, 0Fh
		db	 3Fh,0C0h,0C0h, 00h, 0Fh,0ACh
		db	 00h, 03h, 3Ah,0F0h,0C0h, 00h
		db	 0Ah,0C8h, 00h, 03h, 2Ch,0A0h
		db	0C0h, 00h, 0Ah, 00h, 00h, 03h
		db	 00h,0A0h,0C0h, 00h, 02h, 0Fh
		db	 00h, 03h,0F0h, 80h,0C0h, 00h
		db	 0Ch, 3Dh, 00h, 03h, 54h, 10h
		db	0C0h, 00h, 0Dh, 35h, 00h, 03h
		db	 54h, 50h,0C0h, 00h, 05h, 11h
		db	 00h, 03h, 44h, 50h,0F0h, 00h
		db	 01h, 4Dh, 00h, 0Fh, 71h, 40h
		db	0F0h, 00h, 01h, 10h, 00h, 0Fh
		db	 04h
		db	40h
data_a_D029	db	0F0h
		db	 00h, 01h, 45h, 00h, 0Fh, 51h
		db	 40h,0F0h, 00h, 00h, 40h, 00h
		db	 0Fh, 01h, 40h,0C0h, 3Fh, 0Dh
		db	 00h,0F0h
data_a_D03E	db	0Fh
		db	 01h, 00h,0C0h, 3Fh, 05h, 00h
data_a_D045	dw	3FCh
		db	 00h, 50h,0F0h,0FFh, 00h, 00h
		db	0FCh, 03h, 00h, 50h,0FFh,0FFh
		db	 00h, 00h,0FFh, 0Fh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 0Fh,0FFh, 00h, 00h
		db	0F0h,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C3h,0FFh, 00h, 00h
		db	0C0h, 3Fh, 0Fh, 00h,0FFh,0FFh
		db	 00h, 00h,0C3h,0FFh, 00h, 00h
		db	 00h, 0Fh, 3Fh,0C0h,0FFh,0FFh
		db	 00h, 00h,0C3h,0C0h, 00h, 00h
		db	 00h, 0Fh, 3Fh,0C0h,0FFh,0FFh
		db	 00h, 00h, 0Ch, 00h, 00h, 3Ch
		db	 00h, 03h,0BEh,0B0h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 03h,0F4h
		db	 00h, 03h,0ABh, 20h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 0Fh, 54h
		db	 00h, 00h,0A8h, 20h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 3Dh, 55h
		db	 00h, 00h
		db	28h
data_a_D0C2	db	0Fh
data_a_D0C3	dw	0FF3Fh
data_a_D0C5	db	0
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 3Eh, 8Dh, 0Fh,0FFh, 40h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 4Fh, 35h, 0Fh,0FFh, 40h
		db	 00h, 00h, 00h, 15h, 55h, 00h
		db	 00h, 50h, 54h, 0Fh,0FFh, 40h
		db	 00h,0C0h, 00h, 05h, 5Ch, 00h
		db	 00h, 55h, 55h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 0Dh, 57h, 00h
		db	 00h, 14h, 54h,0FFh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 45h, 00h
		db	 03h,0C5h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 51h, 00h
		db	0FFh, 44h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 0Dh, 03h
		db	0FFh, 40h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 0Dh, 00h
		db	0FFh, 1Ch, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0D1h, 00h
		db	0FFh, 54h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 54h, 03h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C3h,0FFh, 00h
		db	 00h,0C0h, 3Fh, 0Fh, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h,0FFh, 00h
		db	 00h, 00h, 0Fh, 3Fh,0C0h,0FFh
		db	0FFh, 00h, 00h,0F0h,0C0h, 00h
		db	 00h, 00h, 0Fh
		db	3Fh
data_a_D190	dw	0FFC0h
data_a_D192	db	0FFh
		db	 00h, 00h,0C0h, 00h, 00h, 3Ch
		db	 00h, 03h,0BFh, 80h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 03h,0F4h
		db	 00h, 03h,0AAh,0C0h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 0Fh, 54h
		db	 00h
data_a_D1B2	db	0
		db	0AAh, 00h,0FFh,0FFh
data_a_D1B7	db	0
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 2Ah, 03h, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 54h, 00h
		db	 00h, 3Fh, 8Dh, 0Fh
data_a_D1CE	db	0FFh
		db	0C0h, 00h, 00h, 00h, 35h, 57h
data_a_D1D5	db	0
		db	0
data_a_D1D7	db	0Fh
		db	 35h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 15h, 55h, 00h, 00h, 70h
		db	 54h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 05h, 55h, 00h, 00h, 5Ch
		db	 17h, 3Fh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Dh, 54h, 00h, 00h, 54h
		db	0C4h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 55h, 00h, 03h, 15h
		db	 40h,0FFh
data_a_D20A	db	0FFh
data_a_D20B	db	0
data_a_D20C	db	0
		db	0FCh, 00h, 00h, 15h, 00h, 3Fh
		db	 35h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 01h, 00h,0FFh
		db	 40h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 34h, 0Fh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0D1h, 0Fh,0FFh
data_a_D237	db	40h
data_a_D238	db	0
data_a_D239	db	0FFh
data_a_D23A	db	0FFh
data_a_D23B	db	0
data_a_D23C	db	0
data_a_D23D	db	0FCh
data_a_D23E	dw	0
data_a_D240	db	55h
data_a_D241	db	3Fh
data_a_D242	dw	0FFh
data_a_D244	db	0
data_a_D245	db	0FFh
data_a_D246	db	0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h
data_a_D257	db	0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 00h,0F0h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
data_a_D27C	db	0
data_a_D27D	db	0
data_a_D27E	dw	0F5h
data_a_D280	db	3Fh
		db	 0Ah, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 00h, 00h, 0Fh
		db	 3Ah, 80h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0FCh, 00h, 03h
		db	0E0h, 20h,0FFh,0FFh, 00h, 00h
		db	0C0h
data_a_D2A0	db	0
		db	 03h,0D4h, 00h, 03h,0ECh, 20h
		db	0FFh,0FFh, 00h, 00h,0C0h, 00h
		db	 00h, 54h, 00h, 00h,0FAh,0B0h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 30h, 55h, 00h, 00h, 3Ah,0B3h
		db	 3Fh,0FFh, 00h, 00h, 00h, 00h
		db	 30h, 55h, 00h, 00h, 4Ah, 8Ch
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 01h, 55h, 00h, 00h, 50h, 15h
		db	 0Fh,0FFh, 40h, 00h, 00h, 00h
		db	 05h, 55h, 00h, 00h, 50h, 15h
		db	 0Fh,0FFh, 40h, 00h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 4Ah, 84h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 3Ah,0B1h
		db	 3Fh,0FFh, 00h, 00h,0C0h, 00h
		db	 05h, 54h, 00h, 00h,0FAh,0B0h
		db	0FFh,0FFh, 00h, 00h,0C0h, 00h
		db	 05h, 54h, 00h, 03h,0ECh, 20h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 00h, 54h, 00h, 03h,0E0h, 20h
		db	0FFh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 00h, 00h, 0Fh, 3Ah, 80h
		db	0FFh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 55h, 00h, 3Fh, 0Ah, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 00h,0F0h,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
data_a_D34F	db	0FFh
data_a_D350	db	0FFh
data_a_D351	db	0
data_a_D352	db	0
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh
data_a_D362	db	0
data_a_D363	db	0
data_a_D364	db	0
		db	3Fh
data_a_D366	db	0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0F5h, 0Fh,0FFh
		db	 40h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 54h, 3Fh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 14h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 15h, 0Fh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 35h, 00h,0FFh
data_a_D3A3	dw	30h
data_a_D3A5	dw	0FFFFh
data_a_D3A7	dw	0
data_a_D3A9	dw	0F0h
data_a_D3AB	dw	0F500h
data_a_D3AD	dw	300h
data_a_D3AF	dw	17h
data_a_D3B1	dw	0FFFFh
data_a_D3B3	dw	0
data_a_D3B5	dw	0C0h
data_a_D3B7	dw	0D40Fh
data_a_D3B9	dw	0
data_a_D3BB	dw	0FC54h
data_a_D3BD	dw	0FFFFh
		db	 00h, 00h,0C0h, 00h, 0Dh, 55h
		db	 00h, 00h, 55h,0D5h, 3Fh,0FFh
		db	 00h, 00h, 00h, 00h, 3Dh, 55h
		db	 00h, 00h, 50h, 54h, 0Fh,0FFh
		db	 40h, 00h, 00h, 00h, 35h, 55h
		db	 00h, 00h, 4Fh, 15h, 0Fh,0FFh
		db	 40h, 00h, 00h, 00h, 35h, 55h
		db	 00h, 00h
data_a_D3EB	db	3Ah
		db	0C5h, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 15h, 55h, 00h, 00h, 20h
		db	 80h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 05h
		db	54h
data_a_D401	db	0
		db	 03h,0A0h,0A0h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 01h, 54h, 00h
		db	 03h,0ACh,0A0h,0FFh,0FFh, 00h
		db	 00h, 0Ch, 00h, 00h, 14h, 00h
		db	 03h,0FAh,0F0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0C0h, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h,0C0h
		db	 3Fh, 0Fh, 00h
data_a_D441	db	0FFh
		db	0FFh, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h,0F0h,0FFh, 00h
data_a_D44C	db	0
data_a_D44D	db	0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0FDh, 0Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0D5h, 00h,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 00h, 55h, 00h, 0Fh, 3Fh
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Fh, 00h, 00h, 03h, 55h
		db	0F0h,0FFh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Dh, 55h, 00h, 00h, 55h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 3Dh, 55h, 00h, 00h, 54h
		db	0FFh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 57h
		db	0D5h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 35h, 55h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 15h, 55h, 00h, 00h, 54h
		db	 55h, 3Fh,0FFh, 00h, 00h,0C0h
		db	 00h, 05h, 55h, 00h, 00h, 55h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 05h, 00h, 00h, 03h, 55h
		db	 50h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h,0FDh, 00h, 0Fh, 05h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0D5h, 00h,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 55h, 0Fh,0FFh, 40h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h,0F0h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h,0C0h
		db	 3Fh, 0Fh, 00h,0FFh,0FFh, 00h
		db	 00h,0C3h,0FFh, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h,0C3h,0C0h, 00h, 00h, 00h
		db	 0Fh, 3Fh,0C0h,0FFh,0FFh, 00h
		db	 00h, 0Ch, 00h, 00h, 3Ch, 00h
		db	 03h,0FAh,0F0h
data_a_D5DD	dw	0FFFFh
		db	 00h, 00h, 00h, 00h, 03h,0F4h
		db	 00h, 03h,0ACh,0A0h,0FFh,0FFh
		db	 00h, 00h, 00h
data_a_D5EE	db	0
data_a_D5EF	db	0Fh
data_a_D5F0	db	54h
data_a_D5F1	dw	300h
data_a_D5F3	db	0A0h
data_a_D5F4	dw	0FFA0h
data_a_D5F6	db	0FFh
data_a_D5F7	db	0
		db	 00h, 00h, 00h, 3Dh, 55h, 00h
		db	 00h, 20h, 80h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 35h, 55h, 00h
		db	 00h, 3Ah,0CFh, 3Fh,0FFh, 00h
		db	 00h, 00h
data_a_D612	db	0
data_a_D613	db	35h
data_a_D614	db	55h
data_a_D615	db	0
data_a_D616	db	0
		db	 4Fh, 35h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 15h, 5Dh, 00h, 00h
		db	 50h,0D4h, 0Fh,0FFh, 40h, 00h
		db	0C0h, 00h, 05h, 55h, 00h, 00h
		db	 55h, 57h, 3Fh,0FFh, 00h, 00h
		db	0C0h, 00h, 0Dh, 5Ch, 00h, 00h
		db	 54h, 54h,0FFh,0FFh, 00h, 00h
		db	0F0h, 00h, 00h, 57h, 00h, 03h
		db	 15h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 0Fh,0FFh, 00h, 00h
		db	0F0h,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C3h,0FFh, 00h, 00h
		db	0C0h, 3Fh, 0Fh, 00h,0FFh,0FFh
		db	 00h, 00h,0C3h,0FFh, 00h, 00h
		db	 00h, 0Fh, 3Fh,0C0h, 3Fh,0FFh
		db	 00h, 00h,0C3h,0C0h, 00h, 00h
		db	 00h, 0Ch, 3Fh,0C0h
data_a_D717	db	0Fh
		db	0FFh,0C0h, 00h, 0Ch, 00h, 00h
		db	 3Ch, 00h, 03h,0FAh,0F0h, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 03h
		db	0F4h, 00h, 03h,0ACh,0A0h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 0Fh
		db	 54h, 00h, 03h,0A0h,0A0h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 3Dh
		db	 55h, 00h, 00h, 20h, 80h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
data_a_D79C	dw	0FF00h
data_a_D79E	dw	0FFh
data_a_D7A0	dw	0FF00h
data_a_D7A2	dw	0FFh
data_a_D7A4	dw	0FF00h
data_a_D7A6	db	0FFh
		db	 00h, 00h,0CFh,0FFh, 00h, 00h
		db	0FFh, 3Fh, 00h, 00h, 03h,0FFh
		db	 30h, 00h,0FCh
data_a_D7B6	db	0Fh
		db	 00h,0C0h,0CCh, 3Fh, 00h, 00h
		db	0FFh, 3Fh, 00h, 00h,0F0h, 0Fh
		db	 03h,0C0h,0FFh,0F3h, 00h, 00h
		db	0F0h, 0Fh, 03h,0C0h,0FFh,0C0h
		db	 00h, 0Ch,0FCh, 3Fh, 00h, 00h
		db	0FFh,0F3h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h
data_a_D807	db	0FFh
		db	0FFh
data_a_D809	db	0
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h
data_a_D833	db	3
		db	0FFh,0F0h, 00h,0FFh,0C0h, 00h
		db	 0Fh, 03h,0FFh, 30h, 00h,0FFh
		db	0C0h, 00h, 0Fh, 00h, 3Fh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h,0C0h
		db	 0Fh, 0Fh,0C0h,0FCh, 3Fh, 00h
		db	 00h,0C0h, 0Fh, 0Fh,0C0h,0F0h
		db	 0Fh, 03h,0C0h,0C0h, 0Fh, 0Fh
		db	0C0h,0F0h, 0Fh, 03h,0C0h,0F0h
		db	 3Fh, 00h, 00h,0FCh, 3Fh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 03h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 03h, 0Fh,0FFh,0C0h
		db	 00h,0FFh,0F0h, 00h, 03h, 0Fh
		db	0C3h,0C0h, 00h,0FFh,0FCh, 00h
		db	 00h, 3Fh, 00h, 00h, 3Ch,0FCh
		db	 3Fh, 00h, 00h,0FFh, 00h, 00h
		db	 3Ch,0F0h, 0Fh, 03h,0C0h,0FCh
		db	 03h, 00h, 00h,0F0h, 0Fh, 03h
		db	0C0h,0F0h, 0Fh, 03h,0C0h,0FCh
		db	 3Ch, 00h, 00h, 30h, 0Fh, 03h
		db	0C0h,0FFh,0F0h, 00h, 03h, 0Ch
		db	 3Fh,0C0h, 00h,0FFh,0F0h, 00h
		db	 03h, 0Ch, 3Fh,0C0h, 00h,0FFh
		db	0FCh, 00h, 00h, 30h, 0Fh, 03h
		db	0C0h,0FFh,0FFh, 00h, 00h,0F0h
		db	 0Fh, 03h,0C0h,0FFh,0FFh, 00h
		db	 00h,0FCh, 3Fh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0CFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 03h, 00h, 30h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0CFh, 00h, 00h,0CFh
		db	0FFh, 00h, 00h,0FFh, 03h, 00h
		db	 30h, 03h,0FFh, 30h, 00h,0FFh
		db	0CFh, 00h, 00h,0CFh,0FFh, 00h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 0Fh,0FFh,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0CFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 03h, 00h, 30h,0FFh
		db	0FFh, 00h, 00h,0FFh,0CFh, 00h
		db	 00h,0FFh, 3Fh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 0Fh, 00h
		db	0C0h,0FFh,0FFh, 00h, 00h,0FFh
		db	 3Fh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 0Fh, 3Fh,0FCh, 00h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 3Fh, 0Fh,0FCh,0C0h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 3Fh, 00h, 3Ch,0C0h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0FAh, 00h, 03h,0F3h
		db	0C0h, 0Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0A3h, 00h, 00h,0A1h
		db	0FCh, 0Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0A0h, 00h, 00h,0A1h
		db	 5Fh, 0Fh,0FFh, 00h, 00h,0F0h
		db	 00h, 00h, 20h, 00h, 00h, 85h
		db	 57h, 0Fh,0FFh,0C0h, 00h,0C0h
		db	 00h, 0Fh, 3Ah, 00h, 00h,0C5h
		db	 55h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 35h,0CFh, 00h, 00h, 15h
		db	 55h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 11h, 70h, 00h, 00h, 55h
		db	 55h, 0Fh,0FFh, 40h, 00h,0C0h
		db	 00h, 0Dh, 55h, 00h, 00h, 55h
		db	 55h, 3Fh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 51h, 00h, 00h, 53h
		db	 55h, 3Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h, 05h, 00h, 00h, 4Dh
		db	 70h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 00h, 00h, 03h, 4Dh
		db	0C0h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 0Fh, 0Dh
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 0Fh, 01h
		db	 40h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 03h, 03h
		db	 70h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 03h, 1Dh
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 0Fh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 0Fh, 3Fh
		db	0F0h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 3Fh, 0Fh
		db	0F0h,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 3Ah, 0Fh
		db	0F0h,0C0h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A3h, 00h
		db	 0Ch,0A0h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A0h, 00h
		db	 00h,0A3h,0F0h, 0Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 00h,0A0h, 00h
		db	 00h,0A1h, 7Fh, 0Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 0Ch, 3Ah, 00h
		db	 00h,0C5h, 57h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 37h, 3Fh, 00h
		db	 00h,0C5h, 55h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 35h,0CFh, 00h
		db	 00h, 15h, 55h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 11h, 50h, 00h
		db	 00h, 55h, 05h, 0Fh,0FFh, 40h
		db	 00h,0C0h, 00h, 0Dh, 55h, 00h
		db	 00h, 54h,0F5h, 3Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 51h, 00h
		db	 00h, 53h, 57h, 3Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h, 05h, 00h
		db	 00h, 53h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h, 00h
		db	 03h, 54h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 00h, 00h
		db	 00h, 00h, 1Ch,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 00h, 00h
		db	 00h, 51h, 14h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 03h, 01h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 0Fh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 00h,0FFh,0FCh, 00h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 0Fh, 3Fh,0F0h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 3Fh, 0Fh,0F0h,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 3Fh, 0Fh,0F0h,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	0FAh, 00h, 0Ch,0F0h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	0A3h, 00h, 00h,0A3h,0F0h, 0Fh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	0A0h, 00h, 00h,0A1h, 7Fh, 0Fh
		db	0FFh, 00h, 00h,0F0h, 00h, 00h
		db	 20h, 00h, 00h, 85h, 57h, 0Fh
		db	0FFh,0C0h, 00h,0C0h, 00h, 0Fh
		db	 3Ah, 00h, 00h,0C5h, 55h, 0Fh
		db	0FFh,0C0h, 00h, 00h, 00h, 35h
		db	0CFh, 00h, 00h, 15h, 4Dh, 0Fh
		db	0FFh,0C0h, 00h, 00h, 00h, 15h
		db	 50h, 00h, 00h, 55h, 35h, 0Fh
		db	0FFh, 40h, 00h, 00h, 00h, 11h
		db	 55h, 00h, 00h, 54h,0D7h, 3Fh
		db	0FFh, 00h, 00h,0C0h, 00h, 0Dh
		db	 51h, 00h, 00h, 54h, 54h, 3Fh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 45h, 00h, 00h, 55h, 14h,0FFh
		db	0FFh, 00h, 00h,0FCh, 30h, 00h
		db	 00h, 00h, 00h, 54h, 07h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 00h, 00h, 03h, 55h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 01h, 00h, 00h, 11h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 01h, 00h, 0Fh, 54h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 03h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 0Fh, 3Fh,0FCh, 00h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 3Fh, 0Fh,0FCh,0C0h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 3Fh, 0Fh,0FCh,0C0h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0FFh, 00h, 0Fh,0F0h
		db	 00h, 0Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0FAh, 00h, 00h,0F3h
		db	0F0h, 0Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0A3h, 00h, 00h,0A1h
		db	 7Fh, 0Fh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 20h, 00h, 00h, 85h
		db	 57h, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 00h, 00h, 20h, 00h, 00h, 85h
		db	 55h, 0Fh,0FFh,0C0h, 00h,0C0h
		db	 00h, 0Fh,0CAh, 00h, 00h, 15h
		db	 55h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 15h, 70h, 00h, 00h, 54h
		db	 15h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 15h, 55h, 00h, 00h, 53h
		db	0DDh, 3Fh,0FFh, 00h, 00h, 00h
		db	 00h, 11h, 55h, 00h, 00h, 51h
		db	 51h, 3Fh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Dh, 51h, 00h, 00h, 54h
		db	 50h,0FFh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 40h, 00h, 00h, 54h
		db	 1Ch,0FFh,0FFh, 00h, 00h,0FCh
		db	 3Fh, 00h, 00h, 00h, 00h, 11h
		db	 14h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 03h, 01h
		db	 50h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 00h, 0Fh,0C4h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 00h, 3Fh, 55h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 0Fh, 3Fh
		db	0FCh, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 3Fh, 0Fh
		db	0FCh,0C0h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 3Fh, 00h
		db	 3Ch,0C0h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0FAh, 00h
		db	 03h,0F3h,0C0h, 0Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A3h, 00h
		db	 00h,0A1h,0FCh, 0Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A0h, 00h
		db	 00h,0A1h, 5Fh, 0Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 00h, 20h, 00h
		db	 00h, 85h, 57h, 0Fh,0FFh,0C0h
		db	 00h,0C0h, 00h, 0Fh, 3Ah, 00h
		db	 00h,0C5h, 55h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 15h,0CFh, 00h
		db	 00h, 15h, 55h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 15h, 50h, 00h
		db	 00h, 54h, 55h, 0Fh,0FFh, 40h
		db	 00h, 00h, 00h, 11h, 55h, 00h
		db	 00h, 53h, 55h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 0Dh, 51h, 00h
		db	 00h, 51h, 55h, 3Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 45h, 00h
		db	 00h, 51h, 44h,0FFh,0FFh, 00h
		db	 00h,0FCh, 30h, 00h, 00h, 00h
		db	 03h, 41h, 70h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 03h, 30h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 0Fh, 15h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 03h, 00h, 30h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 03h, 15h, 50h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0C0h
		db	 0Fh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 00h,0FFh,0FCh, 00h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 0Fh, 3Fh,0F0h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 3Fh, 0Fh,0F0h,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 3Ah, 0Fh,0F0h,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	0A3h, 00h, 0Ch,0A0h, 00h, 3Fh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	0A0h, 00h, 00h,0A3h,0F0h, 0Fh
		db	0FFh, 00h, 00h,0F0h, 00h, 00h
		db	0A0h, 00h, 00h,0A1h, 7Fh, 0Fh
		db	0FFh, 00h, 00h,0C0h, 00h, 0Ch
		db	 3Ah, 00h, 00h,0C5h, 57h, 0Fh
		db	0FFh,0C0h, 00h, 00h, 00h, 37h
		db	 3Fh, 00h, 00h,0C5h, 55h, 0Fh
		db	0FFh,0C0h, 00h, 00h, 00h, 15h
		db	0CFh, 00h, 00h, 15h, 55h, 0Fh
		db	0FFh,0C0h, 00h, 00h, 00h, 11h
		db	 50h, 00h, 00h, 51h, 55h, 0Fh
		db	0FFh, 40h, 00h,0C0h, 00h, 0Dh
		db	 55h, 00h, 00h, 4Dh, 55h, 3Fh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 41h, 00h, 00h, 35h, 15h, 3Fh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	 05h, 00h, 00h, 14h, 54h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 00h, 00h, 03h, 04h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 00h, 00h,0C7h, 1Ch,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 00h, 00h, 55h, 14h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 03h, 00h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 0Fh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 03h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FFh
		db	0C0h, 00h, 0Fh, 3Fh,0F0h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 3Ah, 0Fh,0F0h,0C0h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 23h, 0Fh,0F0h, 80h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0A0h, 00h, 0Ch,0A0h
		db	 00h, 3Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0A0h, 00h, 00h,0A3h
		db	0F0h, 0Fh,0FFh, 00h, 00h,0FCh
		db	 00h, 00h,0FAh, 00h, 00h,0F1h
		db	 7Fh, 0Fh,0FFh, 00h, 00h,0F0h
		db	 00h, 00h, 3Fh, 00h, 00h,0C5h
		db	 57h, 0Fh,0FFh,0C0h, 00h,0C0h
		db	 00h, 0Fh, 3Fh, 00h, 00h,0C5h
		db	 55h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 15h,0CFh, 00h, 00h, 15h
		db	 55h, 0Fh,0FFh,0C0h, 00h, 00h
		db	 00h, 15h, 50h, 00h, 00h, 5Dh
		db	 55h, 0Fh,0FFh, 40h, 00h, 00h
		db	 00h, 11h, 55h, 00h, 00h, 45h
		db	 55h, 3Fh,0FFh, 00h, 00h,0C0h
		db	 00h, 0Dh, 51h, 00h, 00h, 35h
		db	 55h, 3Fh,0FFh, 00h, 00h,0F0h
		db	 00h, 01h, 44h, 00h, 00h,0D5h
		db	 54h,0FFh,0FFh, 00h, 00h,0FCh
		db	 30h, 00h, 00h, 00h, 00h, 5Ch
		db	 43h, 3Fh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 00h, 00h, 17h
		db	 15h, 3Fh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 01h, 00h, 00h,0C5h
		db	 10h,0FFh,0FFh, 00h, 00h,0FFh
		db	0F0h, 00h, 01h, 00h, 0Fh, 54h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FCh, 00h, 00h, 03h,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0F0h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h,0FFh,0C0h, 00h, 0Fh, 3Fh
		db	0FCh, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 3Fh, 0Fh
		db	0FCh,0C0h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 3Ah, 0Fh
		db	0FCh,0C0h, 00h, 3Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A3h, 00h
		db	 0Fh,0A0h, 00h, 0Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A0h, 00h
		db	 00h,0A3h,0F0h, 0Fh,0FFh, 00h
		db	 00h,0FCh, 00h, 00h,0A0h, 00h
		db	 00h,0A1h, 7Fh, 0Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 00h, 3Ah, 00h
		db	 00h,0C5h, 57h, 0Fh,0FFh,0C0h
		db	 00h,0C0h, 00h, 0Fh, 3Fh, 00h
		db	 00h,0C5h, 55h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 15h,0CFh, 00h
		db	 00h, 15h, 55h, 0Fh,0FFh,0C0h
		db	 00h, 00h, 00h, 15h, 50h, 00h
		db	 00h, 57h, 55h, 0Fh,0FFh, 40h
		db	 00h, 00h, 00h, 11h, 55h, 00h
		db	 00h, 51h, 55h, 3Fh,0FFh, 00h
		db	 00h,0C0h, 00h, 0Dh, 71h, 00h
		db	 00h, 4Dh, 55h, 3Fh,0FFh, 00h
		db	 00h,0F0h, 00h, 01h, 45h, 00h
		db	 00h, 35h,0D4h,0FFh,0FFh, 00h
		db	 00h,0FCh, 30h, 00h, 00h, 00h
		db	 00h, 14h, 40h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 14h, 1Ch,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 03h, 07h, 10h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 00h, 00h
		db	 0Fh,0C7h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh, 00h, 00h, 00h
		db	 3Fh, 55h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 03h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	0CFh, 3Fh,0F0h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 03h
		db	 3Fh, 0Fh,0C3h,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 03h
		db	 3Ah, 00h,0C3h,0C0h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 08h
		db	0A3h, 00h, 00h,0A3h, 00h,0FFh
		db	0FFh, 00h, 00h,0C0h, 00h, 00h
		db	0A0h, 00h, 00h,0A3h,0F0h, 3Fh
		db	0FFh, 00h, 00h,0C0h, 00h, 00h
		db	0A0h, 00h, 00h,0A1h, 7Ch, 3Fh
		db	0FFh, 00h, 00h,0C0h, 00h, 0Fh
		db	 3Ah, 00h, 00h,0C5h, 5Fh, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 37h
		db	 3Fh, 00h, 00h,0C5h, 57h, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 15h
		db	0CFh, 00h, 00h, 15h, 57h, 3Fh
		db	0FFh, 00h, 00h, 00h, 00h, 14h
		db	 50h, 00h, 00h, 54h,0D5h, 3Fh
		db	0FFh, 00h, 00h,0C0h, 00h, 07h
		db	 55h, 00h, 00h, 53h, 54h,0FFh
		db	0FFh, 00h, 00h,0F0h, 00h, 01h
		db	 51h, 00h, 00h, 4Dh, 54h,0FFh
		db	0FFh, 00h, 00h,0FCh, 00h, 00h
		db	 05h, 00h, 03h, 4Dh, 10h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 01h, 00h, 0Fh, 45h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FCh, 00h
		db	 00h, 00h, 03h, 01h, 70h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 00h, 00h, 03h, 31h, 50h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 0Dh, 00h, 0Fh, 15h, 40h,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 05h, 00h, 3Fh, 40h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0F0h, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 02h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FCh, 3Ch, 00h, 00h, 3Fh
		db	 0Fh, 00h, 00h,0F0h, 00h, 03h
		db	0C3h, 0Ch, 3Fh,0C0h, 00h,0C0h
		db	 00h, 0Fh,0CFh, 00h, 3Fh,0F0h
		db	 00h,0C0h, 00h, 0Fh,0CFh, 00h
		db	 0Fh,0F0h, 00h, 00h, 00h, 3Ah
		db	 3Eh, 00h, 03h,0BCh,0C0h, 00h
		db	 00h, 03h, 28h, 00h, 03h,0E8h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 28h, 70h,0C0h, 00h, 00h
		db	0F0h, 00h, 00h, 28h, 7Ch,0C0h
		db	 00h, 07h, 5Ch, 00h, 00h, 31h
		db	 5Ch,0C0h, 00h, 05h, 57h, 00h
		db	 00h, 05h, 5Ch,0C0h, 00h, 01h
		db	 45h, 00h, 00h, 14h,0D4h,0F0h
		db	 00h, 01h, 74h, 00h, 03h, 53h
		db	 50h,0FCh, 00h, 00h, 54h, 00h
		db	 03h, 53h, 40h,0FFh, 00h, 00h
		db	 01h, 00h, 0Fh, 51h, 40h,0FFh
		db	 00h, 00h, 05h, 00h, 03h, 50h
		db	 70h,0FFh,0C0h, 00h, 00h, 00h
		db	 03h, 05h, 70h,0FFh, 00h, 00h
		db	 01h, 30h, 03h, 01h, 50h,0FCh
		db	 00h, 00h,0F5h, 3Ch, 0Fh, 00h
		db	 00h,0FCh, 00h, 00h, 55h, 3Fh
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 02h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FCh, 3Fh, 00h
		db	 00h,0C0h, 3Fh, 00h, 00h,0F0h
		db	 0Fh, 03h,0C0h, 00h,0FFh, 3Ch
		db	 00h,0C0h, 00h, 0Fh,0F0h, 00h
		db	 3Fh,0FFh, 00h,0C0h, 00h, 0Fh
		db	0F0h, 00h, 3Fh,0FFh, 00h, 00h
		db	 00h, 3Eh,0B3h, 00h, 0Fh,0EBh
		db	0C0h, 00h, 00h, 28h,0E2h, 00h
		db	 03h, 8Eh, 80h, 00h, 00h, 28h
		db	 02h, 00h, 03h, 82h, 80h, 00h
		db	 00h, 28h, 3Ch, 00h, 00h, 82h
		db	 1Ch,0C0h, 00h, 0Ch, 57h, 00h
		db	 00h, 2Bh, 1Ch,0C0h, 00h, 00h
		db	 55h, 00h, 00h,0CCh, 5Ch,0C0h
		db	 00h, 04h, 14h, 00h, 00h,0C1h
		db	 54h,0C0h, 00h, 04h,0D7h, 00h
		db	 03h, 45h, 50h,0F0h, 00h, 01h
		db	 15h, 00h, 03h, 14h, 50h,0FCh
		db	 00h, 00h, 40h, 00h, 0Fh, 53h
		db	 40h,0FCh, 00h, 00h, 05h, 00h
		db	 0Fh, 51h, 40h,0FFh, 00h, 00h
		db	 10h, 00h, 0Fh, 01h, 00h,0FCh
		db	 03h, 00h, 10h,0F0h, 03h, 00h
		db	 70h,0F0h, 03h, 01h,0C0h,0F0h
		db	 03h, 01h, 50h,0F0h, 03h, 01h
		db	 50h,0FCh, 0Fh, 00h, 00h,0FCh
		db	 0Fh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 02h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FCh
		db	 3Fh, 00h, 00h, 0Ch, 3Fh, 00h
		db	 00h,0F0h, 0Ch, 03h,0C0h, 30h
		db	 0Fh, 03h,0C0h,0C0h, 00h, 0Fh
		db	0F0h, 00h, 03h, 0Fh,0F0h,0C0h
		db	 00h, 0Fh,0F0h, 00h, 03h, 0Fh
		db	0F0h, 00h, 00h, 3Eh,0BCh, 00h
		db	 00h, 3Eh,0BCh, 00h
loc_a_E468:
		add	[bp+di],ch
		sub	[bx+si],al
		add	[bx+si],ch
		call	sub_a_E471

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_E471	proc	near
		sub	[bx+si],al
		add	[bx+si],al
		add	[bx+si],ch
		add	[bx+si],al
		or	[bx],cl
		add	[bx+si],al
                           lock	and	[bx+si],al
		add	byte ptr ds:[35h],cl
		add	[si-50h],bh
		add	[bx+si],al
		adc	dx,[di]
		add	[bx+si],al
		pop	sp
		les	ax,dword ptr [bx+si]	; Load seg:offset ptr
		add	[si],dl
		adc	[bx+si],ax
		add	[si+1Ch],cl
		rol	byte ptr [bx+si],5	; Rotate
		sbb	ax,300h
;*		jz	loc_a_E4EF		;*Jump if zero
		db	 74h, 50h		;  Fixup - byte match
		rol	byte ptr [bx+si],5	; Rotate
		inc	bp
		add	[bp+di],al
		push	cx
		jo	loc_a_E468		; Jump if overflow=1
		add	[di],al
		jo	$+2			; delay for I/O
		add	cx,[di]
;*		jo	loc_a_E4A0		;*Jump if overflow=1
		db	 70h,0F0h		;  Fixup - byte match
		add	[bx+di],al
		adc	ax,0F00h
		push	sp
		inc	ax
                           lock	add	[bx+di],al
		inc	ax
		add	[bx],cl
		add	[bx+si-10h],ax
		add	ax,[bx+si]
		push	ax
		ror	byte ptr [bx],5		; Rotate
;*		add	al,al
		db	 00h,0C0h		;  Fixup - byte match
		db	 0Fh, 07h, 00h,0F0h, 03h, 00h
		db	 70h,0C0h, 0Fh, 05h, 40h,0F0h
		db	 03h, 01h, 50h,0F0h, 3Fh, 00h
		db	 00h,0FCh, 0Fh, 00h, 00h, 03h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 0Fh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 0Fh, 3Fh,0FCh, 00h, 00h
		db	 3Fh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Fh, 0Fh,0FCh,0C0h, 00h
		db	 3Fh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Fh, 00h, 3Ch,0C0h, 00h
		db	 3Fh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h,0FAh, 00h, 03h,0F3h,0C0h
		db	 0Fh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h,0A3h, 00h, 00h,0A1h,0FCh
		db	 0Fh,0FFh, 00h, 00h,0F0h, 00h
		db	 00h,0A0h, 00h, 00h,0A1h, 5Fh
		db	 0Fh,0FFh, 00h, 00h,0C0h, 00h
		db	 0Fh, 20h, 00h, 00h, 85h, 57h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 37h, 3Ah, 00h, 00h,0C5h, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h,0CFh, 00h, 00h, 14h, 35h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 11h, 50h, 00h, 00h, 53h,0D5h
		db	 0Fh,0FFh, 40h, 00h,0C0h, 00h
		db	 0Dh, 55h, 00h, 00h, 4Dh, 55h
		db	 3Fh,0FFh, 00h, 00h,0F0h, 00h
		db	 01h, 51h, 00h, 00h, 45h, 45h
		db	 3Fh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 0Dh, 00h, 00h, 51h,0C4h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 03h, 41h,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 03h, 34h, 70h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 03h, 15h, 50h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h, 0Fh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FCh
		db	 00h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 00h,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 0Fh, 3Fh,0F0h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Fh, 0Fh,0F0h
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Fh, 00h, 3Ch
		db	0C0h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0FAh, 00h, 00h
		db	0F3h,0C0h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0A3h, 00h, 00h
		db	0A1h,0FCh, 0Fh,0FFh, 00h, 00h
		db	0F0h, 00h, 00h,0A0h, 00h, 00h
		db	0A1h, 5Fh, 0Fh,0FFh, 00h, 00h
		db	0C0h, 00h, 0Ch, 20h, 00h, 00h
		db	 85h, 57h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 37h, 3Ah, 00h, 00h
		db	0C3h, 55h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 15h,0CFh, 00h, 00h
		db	 0Dh, 55h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 11h, 50h, 00h, 00h
		db	 45h, 55h, 0Fh,0FFh, 40h, 00h
		db	0C0h, 00h, 0Dh, 55h, 00h, 00h
		db	 51h,0C5h, 3Fh,0FFh, 00h, 00h
		db	0F0h, 00h, 01h, 51h, 00h, 00h
		db	 41h,0C5h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 0Dh, 00h, 00h
		db	 34h, 70h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 00h, 00h, 03h
		db	 15h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0C0h, 0Fh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0F0h, 0Fh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 03h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0F0h, 30h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 0Fh,0C0h, 3Fh,0FFh
		db	 00h, 00h,0FCh, 0Ch, 00h, 00h
		db	 00h, 00h,0FDh,0FCh, 3Fh,0FFh
		db	 00h, 00h,0F0h, 00h, 03h,0F3h
		db	 00h, 00h, 55h, 5Fh, 0Fh,0FFh
		db	 00h, 00h,0C0h, 00h, 0Fh,0FCh
		db	 00h, 00h, 55h, 57h, 0Fh,0FFh
		db	 00h, 00h,0C0h, 00h, 0Fh,0AAh
		db	 00h, 00h, 15h, 57h, 0Fh,0FFh
		db	0C0h, 00h,0C0h, 00h, 0Eh, 3Ah
		db	 00h, 00h, 15h, 55h, 0Fh,0FFh
		db	0C0h, 00h,0C0h, 00h, 0Eh, 02h
		db	 00h, 00h, 15h,0D5h, 0Fh,0FFh
		db	0C0h, 00h,0F0h, 00h, 02h, 88h
		db	 00h, 00h, 54h, 55h, 0Fh,0FFh
		db	 40h, 00h,0F0h, 00h, 00h, 2Ch
		db	 00h, 00h, 53h, 51h, 3Fh,0FFh
		db	 00h, 00h,0C0h, 00h, 0Fh,0C1h
		db	 00h, 00h, 51h, 50h, 3Fh,0FFh
		db	 00h, 00h, 00h, 00h, 3Dh, 75h
		db	 00h, 00h, 51h, 70h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 15h, 57h
		db	 00h, 00h, 54h, 57h, 3Fh,0FFh
		db	 00h, 00h, 00h, 00h, 14h, 51h
		db	 00h, 00h, 50h, 07h, 3Fh,0FFh
		db	 00h, 00h,0C0h, 00h, 01h, 50h
		db	 0Ch, 00h, 00h,0C5h, 3Fh,0FFh
		db	 00h, 00h,0FCh, 0Fh, 00h, 00h
		db	0FCh, 00h, 00h, 54h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 03h, 00h, 50h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 0Fh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FCh
		db	 00h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 03h, 0Fh,0FCh,0C0h, 00h
		db	 3Fh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 0Fh, 03h,0F0h,0F0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 0Fh, 03h,0F0h,0F0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Fh, 00h, 30h,0F0h, 00h
		db	0FFh,0FFh, 00h, 00h,0F0h, 00h
		db	 00h, 2Eh, 00h, 00h,0B3h,0C0h
		db	 3Fh,0FFh, 00h, 00h,0C0h, 00h
		db	 0Fh, 28h, 00h, 00h,0E1h,0FCh
		db	 3Fh,0FFh, 00h, 00h, 00h, 00h
		db	 17h, 28h, 00h, 00h, 05h, 5Fh
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 11h,0C8h, 00h, 00h, 05h, 57h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h, 4Eh, 00h, 00h, 15h, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h, 50h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh,0C0h, 00h,0C0h, 00h
		db	 05h, 15h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh,0C0h, 00h,0F0h, 00h
		db	 00h, 55h, 00h, 00h, 43h, 55h
		db	 0Fh,0FFh, 40h, 00h,0FFh, 00h
		db	 00h, 15h, 00h, 00h, 3Dh, 55h
		db	 3Fh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 01h, 00h, 00h, 15h, 57h
		db	 3Fh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 34h, 00h, 00h, 15h, 14h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 13h, 00h, 03h, 14h, 50h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 01h, 00h, 0Fh, 54h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h,0FFh, 54h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 00h, 3Fh,0FCh
		db	 00h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Ch, 0Fh,0F0h
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0FCh, 0Fh,0F0h
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0FFh, 00h, 30h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0F0h, 00h, 03h,0AFh, 00h, 00h
		db	 3Fh,0C0h,0FFh,0FFh, 00h, 00h
		db	0F0h, 00h, 02h, 3Ah, 00h, 00h
		db	 15h,0F0h, 3Fh,0FFh, 00h, 00h
		db	0F0h, 00h, 02h, 0Ah, 00h, 00h
		db	 15h, 7Ch, 3Fh,0FFh, 00h, 00h
		db	0C0h, 00h, 02h, 08h, 00h, 00h
		db	 55h, 5Ch, 3Fh,0FFh, 00h, 00h
		db	 00h, 00h, 33h,0ACh, 00h, 00h
		db	 55h, 5Fh, 3Fh,0FFh, 00h, 00h
		db	 00h, 00h, 1Ch,0F1h, 00h, 00h
		db	 55h, 57h, 3Fh,0FFh, 00h, 00h
		db	 00h, 00h, 17h, 05h, 00h, 00h
		db	 5Dh, 57h, 3Fh,0FFh, 00h, 00h
		db	 00h, 00h, 11h, 55h, 00h, 00h
		db	 35h, 54h,0FFh,0FFh, 00h, 00h
		db	0C0h, 00h, 05h, 44h, 00h, 00h
		db	0D5h, 54h,0FFh,0FFh, 00h, 00h
		db	0F0h, 00h, 00h, 14h, 00h, 03h
		db	 51h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 00h, 00h, 0Fh
		db	 71h, 40h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 00h, 00h, 3Fh
		db	 30h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 03h, 00h, 0Fh
		db	 1Ch,0C0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 01h, 00h, 0Fh
		db	 54h,0C0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 00h, 00h, 00h, 0Fh
		db	 01h, 40h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0C0h, 3Fh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 02h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 0Ch
		db	 00h, 00h, 3Fh, 0Fh, 00h, 00h
		db	0FCh, 00h, 00h,0F3h, 0Ch, 3Fh
		db	0C0h, 00h,0F0h, 00h, 03h,0F3h
		db	 00h, 3Fh,0F0h, 00h,0F0h, 00h
		db	 03h,0FCh, 00h, 3Fh, 00h, 00h
		db	0C0h, 00h, 0Fh,0FCh, 00h, 0Fh
		db	 7Ch, 00h,0C0h, 00h, 0Eh,0BCh
		db	 00h, 03h, 5Ch, 30h,0C0h, 00h
		db	 08h,0E8h, 00h, 00h, 54h, 3Ch
		db	0C0h, 00h, 08h, 28h, 00h, 00h
		db	 55h, 0Ch,0C0h, 00h, 08h, 28h
		db	 00h, 00h, 55h, 4Ch, 00h, 00h
		db	 32h,0B1h, 00h, 00h, 55h, 5Ch
		db	 00h, 00h, 1Ch,0F0h, 00h, 00h
		db	0D5h, 5Ch, 00h, 00h, 15h, 0Fh
		db	 00h, 00h, 55h, 54h,0C0h, 00h
		db	 05h, 05h, 00h, 03h, 45h, 50h
		db	0F0h, 00h, 00h, 45h, 00h, 03h
		db	 15h, 40h,0FFh, 00h, 00h, 01h
		db	 00h, 0Fh, 14h, 00h,0FCh, 00h
		db	 00h, 45h, 00h, 0Fh, 01h,0C0h
		db	0FCh, 00h, 00h, 55h, 30h, 03h
		db	 00h, 70h,0FFh, 00h, 00h, 00h
		db	0C0h, 03h, 04h, 70h,0FFh,0FFh
		db	 00h, 00h,0C0h, 03h, 05h, 50h
		db	0FFh,0FFh, 00h, 00h,0F0h, 0Fh
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 3Fh, 00h, 00h,0C0h,0FFh
		db	 00h, 00h,0F0h, 0Fh, 03h,0C0h
		db	 00h,0FFh, 00h, 00h,0C0h, 00h
		db	 0Fh,0F0h, 00h, 3Fh,0C3h, 00h
		db	0C0h, 00h, 0Fh,0F0h, 00h, 3Fh
		db	 00h, 00h, 00h, 00h, 2Ah,0F1h
		db	 00h, 0Fh,0C3h, 00h, 00h, 00h
		db	 0Eh,0A1h, 00h, 03h, 50h,0F0h
		db	 00h, 00h, 02h,0A1h, 00h, 03h
		db	 50h, 70h,0C0h, 00h, 02h,0A1h
		db	 00h, 00h, 54h, 3Ch, 00h, 00h
		db	 0Ah,0C5h, 00h, 00h, 55h, 1Ch
		db	 00h, 00h, 33h,0C5h, 00h, 00h
		db	 55h, 5Ch, 00h, 00h, 1Ch, 15h
		db	 00h, 00h, 55h, 54h,0C0h, 00h
		db	 05h, 5Dh, 00h, 03h, 55h, 50h
		db	0F0h, 00h, 01h, 15h, 00h, 03h
		db	 55h, 50h,0FCh, 00h, 00h,0D4h
		db	 00h, 0Fh, 55h, 40h,0FCh, 00h
		db	 00h, 51h, 00h, 0Fh, 55h, 00h
		db	0FCh, 00h, 00h, 50h, 00h, 0Fh
		db	 00h, 40h,0F0h, 03h, 01h, 50h
		db	0FCh, 03h, 00h, 70h,0F0h, 03h
		db	 01h, 70h,0F0h, 03h, 01h, 70h
		db	0FCh, 0Fh, 00h, 00h,0F0h, 03h
		db	 01h, 50h,0FFh,0FFh, 00h, 00h
		db	0FCh, 0Fh, 00h, 00h, 02h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 0Ch, 00h, 00h
		db	 30h,0FFh, 00h, 00h,0FCh, 03h
		db	 00h,0F0h, 00h, 3Fh, 0Fh, 00h
		db	0F0h, 00h, 03h,0FCh, 00h, 0Fh
		db	 0Fh,0C0h,0F0h, 00h, 03h,0A0h
		db	 00h, 0Fh, 0Ah,0C0h,0C0h, 00h
		db	 0Ah, 05h, 00h, 03h, 00h, 20h
		db	0C0h, 00h, 00h, 55h, 00h, 03h
		db	 0Fh,0C0h,0C0h, 00h, 05h, 55h
		db	 00h, 03h, 05h,0F0h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 05h, 7Ch
		db	 00h, 00h, 15h, 54h, 00h, 00h
		db	 15h, 5Ch, 00h, 00h, 15h, 54h
		db	 00h, 00h,0D5h, 5Ch, 00h, 00h
		db	 15h, 55h, 00h, 00h, 55h, 5Ch
		db	0C0h, 00h, 05h, 55h, 00h, 03h
		db	 55h, 50h,0C0h, 00h, 05h, 55h
		db	 00h, 03h, 55h, 70h,0C0h, 00h
		db	 01h, 55h, 00h, 03h, 55h, 40h
		db	0F0h, 00h, 00h, 55h, 00h, 0Fh
		db	 55h, 00h,0F0h, 00h, 01h, 00h
		db	 00h, 0Fh, 00h, 40h,0F0h, 0Fh
		db	 01h, 40h,0F0h, 0Fh, 01h, 40h
		db	0C0h, 3Fh, 05h, 00h,0FCh, 03h
		db	 00h, 70h,0C0h, 3Fh, 07h, 00h
		db	0FCh, 03h, 00h, 50h,0F0h,0FFh
		db	 00h, 00h,0FFh, 0Fh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 0Fh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 0Fh
		db	 3Fh,0FCh, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 3Fh
		db	 0Fh,0FCh,0C0h, 00h, 3Fh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 3Fh
		db	 00h, 3Ch,0C0h, 00h, 3Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0EBh
		db	 00h, 03h,0E3h,0C0h, 0Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h, 8Eh
		db	 00h, 00h,0A1h,0FCh, 0Fh,0FFh
		db	 00h, 00h,0F0h, 00h, 00h, 82h
		db	 00h, 00h,0A1h, 5Fh, 0Fh,0FFh
		db	 00h, 00h,0C0h, 00h, 0Fh, 02h
		db	 00h, 00h, 85h, 57h, 0Fh,0FFh
		db	0C0h, 00h, 00h, 00h, 17h, 2Bh
		db	 00h, 00h,0C5h, 55h, 0Fh,0FFh
		db	0C0h, 00h, 00h, 00h, 15h,0CFh
		db	 00h, 00h, 15h, 55h, 0Fh,0FFh
		db	0C0h, 00h, 00h, 00h, 11h, 50h
		db	 00h, 00h, 55h, 55h, 0Fh,0FFh
		db	 40h, 00h,0C0h, 00h, 05h, 55h
		db	 00h, 00h, 53h, 55h, 3Fh,0FFh
		db	 00h, 00h,0F0h, 00h, 01h, 51h
		db	 00h, 00h, 4Dh, 57h, 3Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h, 05h
		db	 00h, 00h, 35h, 14h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 01h
		db	 00h, 03h, 14h, 50h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FCh, 00h, 00h
		db	 00h, 0Fh, 17h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 03h
		db	 00h, 0Fh, 47h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 01h
		db	 00h, 03h, 54h, 70h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FCh, 00h, 00h
		db	 00h, 03h, 01h, 50h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0C0h, 0Fh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 0Fh, 3Fh,0FCh, 00h, 00h
		db	 3Fh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Fh, 0Fh,0F0h,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 3Fh, 00h, 30h,0C0h, 00h
		db	0FFh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 2Fh, 00h, 00h,0E3h,0C0h
		db	 3Fh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 3Ah, 00h, 00h,0A1h,0FCh
		db	 0Fh,0FFh, 00h, 00h,0F0h, 00h
		db	 00h, 0Ah, 00h, 00h,0A1h, 5Fh
		db	 0Fh,0FFh, 00h, 00h,0C0h, 00h
		db	 0Ch, 0Ah, 00h, 00h, 85h, 57h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 37h, 2Fh, 00h, 00h,0C1h, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h,0CFh, 00h, 00h, 0Dh, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 11h, 50h, 00h, 00h,0D5h, 55h
		db	 0Fh,0FFh, 40h, 00h,0C0h, 00h
		db	 0Dh, 43h, 00h, 00h, 55h, 55h
		db	 3Fh,0FFh, 00h, 00h,0F0h, 00h
		db	 01h, 31h, 00h, 00h, 51h, 57h
		db	 3Fh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 15h, 00h, 00h, 45h, 54h
		db	0FFh,0FFh, 00h, 00h,0FFh,0C0h
		db	 00h, 05h, 00h, 03h,0C5h, 40h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 0Fh, 14h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 0Fh, 01h,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 03h, 14h, 70h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h, 03h, 05h, 50h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0F0h, 0Fh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 00h,0F0h, 0Fh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 0Ah, 00h, 03h
		db	 05h,0F0h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 2Ah, 00h, 03h
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 80h, 00h, 00h
		db	0B3h,0F0h, 0Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 83h, 00h, 00h
		db	0B1h, 7Ch, 3Fh,0FFh, 00h, 00h
		db	0F0h, 00h, 00h,0EAh, 00h, 00h
		db	0F1h, 50h, 3Fh,0FFh, 00h, 00h
		db	0C0h, 00h, 0Ch,0EAh, 00h, 00h
		db	0C5h, 50h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 33h, 2Ah, 00h, 00h
		db	 15h, 50h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 15h, 40h, 00h, 00h
		db	 55h, 54h, 0Fh,0FFh, 00h, 00h
		db	 00h, 00h, 15h, 40h, 00h, 00h
		db	 55h, 55h, 0Fh,0FFh, 00h, 00h
		db	 00h, 00h, 31h, 2Ah, 00h, 00h
		db	 15h, 55h, 0Fh,0FFh, 40h, 00h
		db	0C0h, 00h, 04h,0EAh, 00h, 00h
		db	0C5h, 55h, 0Fh,0FFh, 40h, 00h
		db	0F0h, 00h, 00h,0EAh, 00h, 00h
		db	0F1h, 55h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 83h, 00h, 00h
		db	0B1h, 55h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 80h, 00h, 00h
		db	0B1h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 2Ah, 00h, 03h
		db	0C0h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 0Ah, 00h, 03h
		db	 05h, 50h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 00h,0F0h, 0Fh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0C0h, 0Fh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 03h, 15h,0F0h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0C0h, 03h, 01h, 50h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0F0h, 0Fh, 01h, 40h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 0Fh, 05h, 40h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 00h
		db	 00h, 03h,0C5h,0C0h,0FFh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h, 0Dh
		db	 00h, 00h, 45h,0F0h,0FFh,0FFh
		db	 00h, 00h,0F0h, 00h, 03h,0F1h
		db	 00h, 00h, 51h, 7Fh, 3Fh,0FFh
		db	 00h, 00h,0C0h, 00h, 05h, 75h
		db	 00h, 00h, 55h, 57h, 3Fh,0FFh
		db	 00h, 00h, 00h, 00h, 11h, 50h
		db	 00h, 00h, 55h, 57h, 0Fh,0FFh
		db	0C0h, 00h, 00h, 00h, 15h, 4Fh
		db	 00h, 00h, 15h, 55h, 0Fh,0FFh
		db	0C0h, 00h,0C0h, 00h, 05h, 3Ah
		db	 00h, 00h,0C5h, 55h, 0Fh,0FFh
		db	0C0h, 00h,0F0h, 00h, 00h, 20h
		db	 00h, 00h, 85h, 55h, 0Fh,0FFh
		db	 40h, 00h,0FCh, 00h, 00h,0A0h
		db	 00h, 00h,0A1h, 55h, 0Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0A3h
		db	 00h, 00h,0A1h, 54h, 0Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0FAh
		db	 00h, 03h,0F1h, 40h, 0Fh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 3Fh
		db	 00h, 3Ch,0C0h, 00h, 3Fh,0FFh
		db	 00h, 00h,0FFh, 00h, 00h, 3Fh
		db	 0Fh,0FCh,0C0h, 00h, 3Fh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 0Fh
		db	 3Fh,0FCh, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 0Fh,0FFh
		db	 00h, 00h, 03h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h, 0Fh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 03h, 17h,0F0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 03h, 15h, 70h
		db	0FFh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 0Fh, 00h, 00h,0C5h, 50h
		db	0FFh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h,0F5h, 00h, 00h, 50h, 0Fh
		db	 3Fh,0FFh, 00h, 00h,0F0h, 00h
		db	 00h, 05h, 00h, 00h, 55h, 57h
		db	 3Fh,0FFh, 00h, 00h,0C0h, 00h
		db	 0Fh,0F1h, 00h, 00h, 55h, 57h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 35h, 7Dh, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh,0C0h, 00h,0C0h, 00h
		db	 05h, 51h, 00h, 00h, 55h, 55h
		db	 0Fh,0FFh, 40h, 00h,0F0h, 00h
		db	 00h, 05h, 00h, 00h, 55h, 55h
		db	 3Fh,0FFh, 00h, 00h,0FCh, 00h
		db	 00h, 55h, 00h, 00h, 50h, 05h
		db	 0Fh,0FFh, 00h, 00h,0FFh, 00h
		db	 00h, 05h, 00h, 00h, 07h,0F0h
		db	 0Fh,0FFh, 00h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 03h, 15h, 70h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 03h, 15h, 50h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0C0h, 0Fh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 03h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0F0h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 0Fh,0FFh, 00h, 00h
		db	0FFh,0C0h, 00h, 0Fh, 3Fh,0FCh
		db	 00h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Fh, 0Fh,0FCh
		db	0C0h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h, 3Fh, 00h, 3Ch
		db	0C0h, 00h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0FAh, 00h, 03h
		db	0F3h,0C0h, 0Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0A3h, 00h, 00h
		db	0A1h,0FCh, 0Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h,0A0h, 00h, 00h
		db	0A1h, 5Fh, 0Fh,0FFh, 00h, 00h
		db	0F0h, 00h, 00h, 20h, 00h, 00h
		db	 85h, 57h, 0Fh,0FFh,0C0h, 00h
		db	0C0h, 00h, 0Fh, 3Ah, 00h, 00h
		db	0C5h, 55h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 35h,0CFh, 00h, 00h
		db	 15h, 55h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 11h, 70h, 00h, 00h
		db	 57h, 55h, 0Fh,0FFh, 40h, 00h
		db	0C0h, 00h, 0Dh, 55h, 00h, 00h
		db	 55h, 55h, 3Fh,0FFh, 00h, 00h
		db	0F0h, 00h, 01h, 51h, 00h, 00h
		db	 53h, 57h, 3Fh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 05h, 00h, 00h
		db	 4Dh, 50h,0FFh,0FFh, 00h, 00h
		db	 03h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0F0h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 0Fh,0FFh
		db	 00h, 00h,0FFh,0C0h, 00h, 0Fh
		db	 3Fh,0FCh, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h,0CFh, 00h, 00h, 3Fh
		db	 0Fh,0FCh,0C0h, 00h, 3Fh,0FFh
		db	 00h, 00h, 03h, 00h, 30h, 3Fh
		db	 00h, 3Ch,0C0h, 00h, 3Fh,0FFh
		db	 00h, 00h,0CCh, 00h, 00h,0FAh
		db	 00h, 03h,0F3h,0C0h, 0Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0A3h
		db	 00h, 00h,0A1h,0FCh, 0Fh,0FFh
		db	 00h, 00h,0FCh, 00h, 00h,0A0h
		db	 00h, 00h,0A1h, 5Fh, 0Fh,0FFh
		db	 00h, 00h,0F0h, 00h, 00h, 20h
		db	 00h, 00h, 85h, 57h, 0Fh,0FFh
		db	0C0h, 47h, 84h,0B2h, 00h, 0Bh
		db	 00h,0B0h,0F2h,0E7h,0D8h,0CDh
		db	0C2h,0B7h,0ACh,0A1h, 99h, 90h
		db	 88h, 80h
		db	'yslfa[VPLHD@96'
		db	 18h,0CAh, 18h,0CAh, 39h,0CAh
		db	 39h,0CAh, 5Ah,0CAh, 9Bh,0CAh
		db	 9Bh,0CAh,0DCh,0CAh,0DCh,0CAh
		db	0FDh,0CAh, 06h,0CBh, 18h, 16h
		db	 18h, 16h, 18h, 18h, 16h, 18h
		db	 18h, 16h, 18h, 16h, 1Bh, 1Ah
		db	 1Bh, 1Bh, 18h, 16h, 18h, 16h
		db	 18h, 18h, 13h, 16h, 16h, 15h
		db	 16h, 16h, 16h, 16h, 16h, 16h
		db	0FFh, 1Ah, 18h, 1Ah, 18h, 1Ah
		db	 1Ah, 18h, 1Ah, 1Ah, 18h, 1Ah
		db	 18h, 1Dh, 1Ch, 1Dh, 1Dh, 1Ah
		db	 18h, 1Ah, 18h, 1Ah, 1Ah, 15h
		db	 18h, 18h, 17h, 18h, 18h, 18h
		db	 18h, 18h, 18h,0FFh, 16h, 15h
		db	 11h, 0Eh, 15h, 13h, 10h, 0Ch
		db	 11h, 10h, 0Eh, 10h, 10h, 11h
		db	 11h, 11h, 16h, 15h, 11h, 0Eh
		db	 15h, 13h, 10h, 0Ch, 18h, 18h
		db	 16h, 15h, 15h, 11h, 11h, 11h
		db	 16h, 15h, 11h, 0Eh, 15h, 13h
		db	 10h, 0Ch, 11h, 10h, 0Eh, 10h
		db	 10h, 11h, 11h, 11h, 16h, 15h
		db	 13h, 15h, 15h, 16h, 16h, 16h
		db	 19h, 18h, 16h, 18h, 18h, 19h
		db	 19h, 1Ch,0FFh, 11h, 0Ah, 15h
		db	 0Ah, 11h, 0Ah, 15h, 11h, 0Ah
		db	 15h, 0Ah, 11h, 16h, 15h, 11h
		db	 0Eh, 10h, 09h, 13h, 09h, 10h
		db	 09h, 13h, 10h, 09h, 13h, 09h
		db	 10h, 11h, 10h, 0Ch, 09h, 0Eh
		db	 07h, 11h, 07h, 0Eh, 07h, 11h
		db	 0Eh, 07h, 11h, 07h, 0Eh, 10h
		db	 0Eh, 11h, 0Eh, 10h, 09h, 13h
		db	 09h, 10h, 09h, 13h, 10h, 09h
		db	 13h, 09h, 10h, 11h, 10h, 0Eh
		db	 10h,0FFh, 18h, 18h, 16h, 15h
		db	 15h, 11h, 0Eh, 11h, 13h, 11h
		db	 13h, 15h, 18h, 15h, 18h, 1Ah
		db	 18h, 18h, 15h, 11h, 11h, 0Eh
		db	 11h, 13h, 15h, 13h, 15h, 18h
		db	 1Ah, 18h, 15h, 11h,0FFh, 07h
		db	 08h, 0Bh, 0Ch, 0Eh, 0Eh, 0Eh
		db	 0Eh,0FFh, 0Eh, 0Eh, 0Ch, 0Ch
		db	 0Bh, 0Bh, 08h, 08h, 07h, 07h
		db	 07h, 07h,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 32h,0CBh, 3Ch,0CBh
		db	 3Fh,0CBh, 42h,0CBh, 47h,0CBh
		db	 4Fh,0CBh, 54h,0CBh, 6Eh,0CBh
		db	 6Eh,0CBh, 72h,0CBh, 7Ah,0CBh
		db	 7Dh,0CBh, 80h,0CBh, 14h, 08h
		db	 20h, 1Ch, 18h, 14h, 20h, 18h
		db	 20h, 18h, 05h, 01h, 81h, 0Ah
		db	 01h,0C9h, 0Ah, 03h, 01h, 20h
		db	 01h, 0Ah, 06h, 04h, 08h, 0Ch
		db	 10h, 14h, 18h, 1Eh, 03h, 01h
		db	 80h, 81h, 1Eh, 18h, 01h, 80h
		db	 82h, 01h, 80h, 82h, 80h, 82h
		db	 20h, 81h, 1Ch, 81h, 18h, 81h
		db	 14h, 81h, 10h, 82h, 0Ch, 82h
		db	 08h, 82h, 04h, 82h, 1Eh, 02h
		db	 81h, 82h, 1Eh, 06h, 82h, 83h
		db	 84h, 85h, 86h, 87h, 0Ah, 01h
		db	 80h, 28h, 01h,0C8h, 28h, 01h
		db	0CAh
		db	'fa[VQMHD@=9630-+(&$'
		db	'" '
		db	 1Eh, 1Ch, 1Bh, 19h, 18h, 16h
		db	 15h, 14h, 13h, 12h, 11h, 10h
		db	 0Fh, 0Eh, 0Dh, 17h, 43h, 51h
		db	 01h, 64h, 2Dh,0EAh, 15h, 07h
		db	 2Ah, 38h, 43h, 7Bh, 05h, 43h
		db	 20h, 00h, 00h, 00h, 00h, 05h
		db	 00h, 06h, 00h, 07h, 00h, 08h
		db	 00h, 09h, 00h, 10h, 00h, 11h
		db	 00h, 12h, 00h, 00h, 00h, 00h
		db	0FFh,0F8h,0FFh,0F8h,0FFh,0F8h
		db	 04h, 20h, 01h, 08h, 01h, 08h
		db	 01h, 08h,0F8h, 40h,0FFh,0F8h
		db	0FFh,0F8h,0FFh,0F8h,0FCh,0E0h
		db	 01h, 08h, 01h, 08h, 01h, 08h
		db	 00h, 00h, 00h, 00h,0FFh, 00h
		db	0FCh, 02h,0F3h, 08h,0F0h, 0Ah
		db	0CFh, 20h,0CCh, 00h,0C3h, 28h
		db	0C0h, 22h, 3Fh, 80h, 3Ch, 00h
		db	 33h, 00h, 30h, 00h, 0Fh,0A0h
		db	 0Ch, 00h, 03h, 88h, 00h, 82h
		db	0FFh, 00h,0FCh, 03h,0F3h, 0Ch
		db	0F0h, 0Fh,0CFh, 30h,0CCh, 00h
		db	0C3h, 3Ch,0C0h, 3Fh, 3Fh,0C0h
		db	 3Ch, 00h, 33h, 00h, 30h, 00h
		db	 0Fh,0F0h, 0Ch, 00h, 03h,0FCh
		db	 00h,0FFh, 00h, 80h,0C0h, 20h
		db	0F0h, 08h,0FCh, 02h, 00h,0FFh
		db	0C0h, 3Fh,0F0h, 0Fh,0FCh, 03h
		db	 3Fh, 80h, 0Fh, 20h, 03h, 08h
		db	 00h, 02h, 3Fh,0C0h, 0Fh,0F0h
		db	 03h,0FCh, 00h,0FFh, 68h, 02h
		db	0B2h, 00h, 08h, 00h,0B0h, 3Fh
		db	0C0h, 0Fh,0F0h, 03h,0FCh,0FFh
		db	 00h, 2Ah, 80h, 0Ah,0A0h, 02h
		db	0A8h,0AAh, 00h, 15h, 40h, 05h
		db	 50h, 01h, 54h, 55h, 17h, 00h
		db	0B2h, 00h, 0Ah, 00h,0B0h, 0Fh
		db	 17h, 2Fh, 09h, 38h, 20h, 3Eh
		db	 12h, 29h, 16h, 08h, 1Bh, 10h
		db	 3Fh, 2Ah, 00h, 0Fh, 17h, 2Fh
		db	 09h, 38h, 20h, 3Eh, 12h, 29h
		db	 16h, 08h, 1Bh, 10h
		db	3Fh
		db	'*  TOWER OF EYES   ', 0
		db	' REALM OF ROBOTS  ', 0
		db	'  TRAP OF TRICKS  ', 0
		db	'  SLIPPERY SLIDE  ', 0
		db	'   BROKEN PATH    ', 0
		db	' SWIMMERS DELIGHT ', 0
		db	'    NASTY ONE     ', 0
		db	'   EDGE OF DOOM   ', 0
		db	' BLINK OF THE EYE ', 0
		db	'  ROBOT', 27h, 'S HEAVEN  ', 0
		db	'  TRICK OF TRAPS  ', 0
		db	'  NO MANS', 27h, 'S LAND  ', 0
		db	'   OH,*******!!   ', 0
		db	' RIDDLE OF REASON ', 0
		db	' MAZE OF MISTAKES ', 0
		db	'    LAST TRUMP    N'
		db	 01h,0B2h, 00h, 86h, 00h,0B0h
		db	 3Bh, 2Bh, 01h, 39h, 48h, 50h
		db	 4Bh, 4Dh, 3Bh, 2Bh, 01h, 52h
		db	 48h, 50h, 4Bh, 4Dh, 10h, 01h
		db	 11h, 08h, 06h
		db	'>> GAME  ON <<'
		db	 10h, 02h, 11h, 0Ah, 0Ah, 00h
		db	'PLAYER ONE'
		db	0
		db	'PLAYER TWO'
		db	 00h, 10h, 01h, 11h, 0Eh
		db	8, 'ENTERING THE'
		db	 11h, 10h, 02h, 10h, 03h, 00h
		db	 10h, 02h, 11h, 0Ah, 05h
		db	'>> GAME OVER <<'
		db	 11h, 0Eh, 0Ah, 10h, 03h, 00h
		db	 10h, 02h, 11h, 12h, 07h
		db	'NO LIVES LEFT'
		db	 00h, 10h, 03h, 11h, 09h, 05h
		db	'TOWER COMPLETED'
		db	 11h, 0Bh
		db	8, 'BONUS POINTS'
		db	 10h, 01h, 11h, 0Dh, 04h
		db	'TIME LEFT 10*'
		db	 00h, 10h, 01h, 11h, 0Dh, 1Eh
		db	 39h, 39h, 39h, 00h, 11h, 0Fh
		db	 04h
		db	'TECHNIQUE 10*'
		db	 00h, 11h, 0Fh, 1Eh, 39h, 39h
		db	 39h, 00h, 11h, 11h, 04h
		db	'EXTRAS    10*'
		db	 00h, 11h, 11h, 1Eh, 39h, 39h
		db	 39h, 00h, 10h, 03h, 11h, 09h
		db	 05h
		db	'CONGRATULATIONS'
		db	 11h, 0Bh, 0Ah, 10h, 02h, 00h
		db	 10h, 01h, 11h
		db	0Dh, 0Ch, 'YOU HAVE'
		db	 11h, 0Fh, 0Bh
		db	'COMPLETED'
		db	 11h, 11h
		db	8, 'YOUR MISSION'
		db	 00h, 11h, 10h, 07h, 10h, 02h
		db	'TIME LIMIT UP'
		db	 00h, 05h, 06h, 05h, 06h, 07h
		db	 06h, 07h, 08h, 55h,0AAh,0FFh
		db	 55h,0AAh,0FFh, 55h,0AAh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 11h
		db	 0Ch, 0Ah, 10h, 01h, 00h, 00h
		db	 00h, 11h, 0Ch, 07h, 10h, 01h
		db	'DESIGNED BY JOHN PHILLIPS'
		db	 11h, 0Eh
		db	9, 'CONVERTED BY STE CORK'
		db	 10h, 03h, 11h, 10h
		db	0Ch, '(C) HEWSON 1988'
		db	 11h, 12h, 00h
		db	'PUBLISHED IN THE USA BY US.GOLD '
		db	'(TM) LTD'
		db	 00h, 00h, 00h, 00h, 00h, 2Eh
		db	 2Eh, 2Eh, 00h, 00h, 00h, 00h
		db	 2Eh, 2Eh, 2Eh, 00h, 00h, 00h
		db	 00h, 2Eh, 2Eh, 2Eh, 00h, 00h
		db	 00h, 00h, 2Eh, 2Eh, 2Eh, 01h
		db	 00h, 10h, 01h, 11h, 0Ah, 0Dh
		db	 00h, 11h, 0Ch, 0Dh, 00h, 11h
		db	 0Eh, 0Dh, 00h, 11h, 10h, 0Dh
		db	 00h, 00h, 11h, 06h, 0Eh, 10h
		db	 03h
		db	'HIGH SCORERS'
		db	 00h, 10h, 02h, 11h, 14h, 0Bh
		db	'1 PLAYER'
		db	 00h, 10h, 02h, 11h, 14h, 0Bh
		db	'2 PLAYER'
		db	 00h, 10h, 02h, 11h, 14h, 15h
		db	'SOUND ON'
		db	 00h, 10h, 02h, 11h, 14h, 15h
		db	'NO SOUND'
		db	 00h, 10h, 02h, 11h, 16h, 10h
		db	'MISSION 1'
		db	 00h, 10h, 02h, 11h, 16h, 10h
		db	'MISSION 2'
		db	 00h, 00h, 00h, 00h, 11h, 15h
		db	 0Eh, 10h, 03h
		db	'PLEASE ENTER'
		db	 11h, 17h, 0Dh, 10h, 03h
		db	'YOUR  INITIALS'
		db	 00h, 00h, 00h, 10h, 03h,0A1h
		db	 02h,0B2h, 00h,0A4h, 00h,0B0h
		db	 11h, 20h, 02h, 00h, 11h, 00h
		db	 32h, 00h, 11h, 00h, 32h, 00h
		db	 11h, 00h, 11h, 00h, 11h, 00h
		db	 11h, 00h, 11h, 00h, 11h, 00h
		db	 11h, 23h, 00h, 00h, 11h, 23h
		db	 00h, 00h, 54h, 81h, 8Eh, 8Eh
		db	 8Eh, 00h
		db	'yvwxpxXx'
		db	 98h, 00h, 00h, 00h, 00h, 00h
		db	 68h, 81h, 8Eh, 8Eh, 8Eh
		db	'xpphhyzyzy'
		db	 00h, 00h, 00h, 08h, 09h, 0Ah
		db	 0Bh, 8Ah, 89h, 88h, 88h, 89h
		db	 8Ah, 0Bh, 0Ah, 09h, 08h, 90h
		db	 91h, 92h, 13h, 10h, 11h, 12h
		db	 13h, 0Bh, 8Ah, 89h, 88h, 0Bh
		db	 0Ah, 09h, 08h, 94h, 14h, 15h
		db	 95h, 96h, 16h, 97h, 17h, 98h
		db	 18h, 19h, 99h, 1Ah, 1Bh, 1Ah
		db	 00h, 1Ch, 1Dh, 1Eh, 00h, 00h
		db	 00h, 00h, 03h, 02h, 01h, 01h
		db	 01h, 00h, 00h,0FFh,0FEh,0FEh
		db	0FDh,0FDh,0FDh,0FDh,0FDh,0FCh
		db	 00h, 00h, 00h, 00h, 03h, 02h
		db	 02h, 01h, 01h, 00h, 00h,0FFh
		db	0FFh,0FEh,0FEh,0FDh, 02h, 02h
		db	 01h, 00h,0FFh,0FEh,0FEh,0A2h
		db	 00h,0B2h, 00h, 13h, 00h,0B0h
		db	 12h, 28h, 08h, 29h,0FEh, 29h
		db	0F4h, 2Ah,0EAh, 2Bh,0E0h, 2Ch
		db	0D6h, 2Dh,0CCh, 2Eh, 00h, 01h
		db	 00h, 01h, 00h, 01h, 00h, 00h
		db	 01h, 00h, 00h, 00h, 10h, 01h
		db	 11h, 00h, 00h
		db	'PLAYER 1'
		db	 11h, 00h
		db	' PLAYER 24'
		db	 00h,0B2h, 00h, 25h, 00h,0B0h
		db	0FFh, 00h,0FFh, 00h,0FCh, 00h
		db	0FFh, 00h,0FFh, 00h,0F0h, 00h
		db	0FFh, 00h,0FFh, 00h,0C0h, 00h
		db	0FFh, 00h,0FFh, 00h, 00h, 00h
		db	0FFh, 00h,0FCh, 00h, 00h, 00h
		db	0FFh, 00h,0F0h, 00h, 00h, 00h
		db	0FFh, 00h,0C0h, 00h, 00h, 00h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	0FCh, 00h, 00h, 00h, 00h, 00h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	0C0h, 00h, 00h, 00h, 00h, 00h
		db	 3Fh, 00h,0FFh, 00h,0FFh, 00h
		db	 0Fh, 00h,0FFh, 00h,0FFh, 00h
		db	 03h, 00h,0FFh, 00h,0FFh, 00h
		db	 00h, 00h,0FFh, 00h,0FFh, 00h
		db	 00h, 00h, 3Fh, 00h,0FFh, 00h
		db	 00h, 00h, 0Fh, 00h,0FFh, 00h
		db	 00h, 00h, 03h, 00h,0FFh, 00h
		db	 00h, 00h, 00h, 00h,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 3Fh, 00h
		db	 00h, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 00h, 00h, 03h, 00h
		db	0C0h, 00h, 03h, 00h,0FFh, 00h
		db	0F0h, 00h, 00h, 00h,0FFh, 00h
		db	0FCh, 00h, 00h, 00h, 3Fh, 00h
		db	0FFh, 00h, 00h, 00h, 0Fh, 00h
		db	0FFh, 00h,0C0h, 00h, 03h, 00h
		db	0C0h, 00h, 00h, 00h, 03h,0A7h
		db	 00h,0B2h, 00h, 0Dh, 00h,0B0h
		db	 08h, 00h, 02h, 00h, 06h, 00h
		db	 04h, 00h, 04h, 00h, 06h, 00h
		db	 02h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 03h, 03h, 03h
		db	 07h, 07h, 07h, 07h, 1Ch, 00h
		db	0B2h, 00h, 29h, 00h,0B0h, 12h
		db	 12h, 12h, 0Eh, 0Eh, 0Eh, 0Eh
		db	0FFh,0FFh,0FFh, 0Ah, 00h,0B2h
		db	 00h, 1Ch, 00h,0B0h, 0Bh, 0Ch
		db	 0Dh, 0Eh, 0Fh, 10h, 11h, 12h
		db	 13h, 14h, 15h, 1Ch, 0Ah, 09h
		db	 08h, 07h, 06h, 05h, 04h, 03h
		db	 02h, 01h,0FFh, 0Bh, 0Ch, 0Dh
		db	 0Eh, 0Fh, 10h, 11h, 12h, 13h
		db	 14h, 1Bh, 09h, 08h, 07h, 06h
		db	 05h, 04h, 03h, 02h, 01h, 00h
		db	0FFh,0FFh,0FFh, 0Bh, 0Ch, 0Dh
		db	 0Eh, 0Fh, 10h, 16h, 17h, 18h
		db	 19h, 1Ah, 05h, 04h, 03h, 02h
		db	 01h, 00h,0FFh,0FFh,0E4h,0E1h
		db	 00h,0D2h,0D8h, 00h,0C9h,0C6h
		db	 00h, 00h, 00h, 93h, 00h, 00h
		db	 00h, 87h, 00h, 00h, 00h, 00h
		db	 9Ch, 00h, 8Dh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 4Eh, 4Bh
		db	0B4h,0B1h
		db	7 dup (0)
		db	 72h, 00h, 63h, 00h, 00h, 00h
		db	 00h, 78h, 00h, 00h, 00h, 6Ch
		db	 00h, 00h, 00h, 39h, 36h, 00h
		db	 27h, 2Dh, 00h, 1Eh, 1Bh, 02h
		db	 02h, 01h, 01h, 00h, 00h,0FFh
		db	0FFh,0FEh,0FEh,0FCh, 8Dh, 00h
		db	0B2h, 00h, 93h, 01h,0B0h, 11h
		db	 05h, 00h, 10h, 02h, 00h, 11h
		db	 08h, 1Bh, 10h, 03h, 54h, 4Dh
		db	 0Dh, 00h,0B2h, 00h, 26h, 00h
		db	0B0h, 55h,0AAh, 23h,0F3h, 7Ch
		db	 05h, 00h,0B2h, 00h, 90h, 01h
		db	0B0h, 03h, 0Ch, 0Fh, 30h, 33h
		db	 3Ch, 3Fh,0C0h,0C3h,0CCh,0CFh
		db	0F0h,0F3h,0FCh,0FFh, 00h, 55h
		db	0AAh,0FFh
		db	'INSUFFICIENT MEMORY AVAILABLE0'
		db	 00h,0B2h, 2Eh, 0Dh, 00h,0B0h
		db	 20h, 09h, 00h,0B0h
		db	'PRESS ANY KEY TO CONTINUE$'
		db	 1Ah, 00h,0B2h, 00h, 20h, 00h
		db	0B0h
		db	'HISCORE.BIN'
		db	 00h, 11h, 00h, 00h, 10h, 03h
		db	'File not found! ,bye bye!.......'
		db	'1', 0
		db	0B2h, 00h, 0Bh, 00h,0B0h, 10h
		db	 10h, 10h, 10h, 00h, 10h, 00h
		db	 00h, 24h, 24h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 24h, 7Eh, 24h
		db	 24h, 7Eh, 24h, 00h, 00h, 08h
		db	 3Eh, 28h, 3Eh, 0Ah, 3Eh, 08h
		db	 00h, 62h, 64h, 08h, 10h, 26h
		db	 46h, 00h, 00h, 10h, 28h, 10h
		db	 2Ah, 44h, 3Ah, 00h, 00h, 08h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 08h, 08h, 08h, 08h
		db	 04h, 00h, 00h, 20h, 10h, 10h
		db	 10h, 10h, 20h, 00h, 00h, 00h
		db	 14h, 08h, 3Eh, 08h, 14h, 00h
		db	 00h, 00h, 08h, 08h, 3Eh, 08h
		db	 08h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 08h, 08h, 10h, 00h, 00h
		db	 00h, 00h, 3Eh, 64h, 00h,0B2h
		db	 00h, 08h, 00h,0B0h, 18h, 18h
		db	 00h, 00h, 00h, 02h, 04h, 08h
		db	 10h, 20h, 00h, 00h, 3Ch, 46h
		db	 4Ah, 52h, 62h, 3Ch, 00h, 00h
		db	 18h, 28h, 08h, 08h, 08h, 3Eh
		db	 00h, 00h, 3Ch, 42h, 02h, 3Ch
		db	 40h, 7Eh, 00h, 00h, 3Ch, 42h
		db	 0Ch, 02h, 42h, 3Ch, 00h, 00h
		db	 08h, 18h, 28h, 48h, 7Eh, 08h
		db	 00h, 00h, 7Eh, 40h, 7Ch, 02h
		db	 42h, 3Ch, 00h, 00h, 3Ch, 40h
		db	 7Ch, 42h, 42h, 3Ch, 00h, 00h
		db	 7Eh, 02h, 04h, 08h, 10h, 10h
		db	 00h, 00h, 3Ch, 42h, 3Ch, 42h
		db	 42h, 3Ch, 00h, 00h, 3Ch, 42h
		db	 42h, 3Eh, 02h, 3Ch, 00h, 00h
		db	 00h, 00h, 10h, 00h, 00h, 10h
		db	 00h, 00h, 00h, 10h, 00h, 00h
		db	 10h, 10h, 20h, 00h, 00h, 04h
		db	 08h, 10h, 08h, 04h, 00h, 00h
		db	 00h, 00h, 3Eh, 00h, 3Eh, 00h
		db	 00h, 00h, 00h, 10h, 08h, 04h
		db	 08h, 10h, 00h, 00h, 3Ch, 42h
		db	 04h, 08h, 00h, 08h, 00h, 00h
		db	 3Ch, 4Ah, 56h, 5Eh, 40h, 3Ch
		db	 00h, 00h, 3Ch, 42h, 42h, 7Eh
		db	 42h, 42h, 00h, 00h, 7Ch, 42h
		db	 7Ch, 42h, 42h, 7Ch, 00h, 00h
		db	 3Ch, 42h, 40h, 40h, 42h, 3Ch
		db	 00h, 00h, 78h, 44h, 42h, 42h
		db	 44h, 78h, 00h, 00h, 7Eh, 40h
		db	 7Ch, 40h, 40h, 7Eh, 00h, 00h
		db	 7Eh, 40h, 7Ch, 40h, 40h, 40h
		db	 00h, 00h, 3Ch, 42h, 40h, 4Eh
		db	 42h, 3Ch, 00h, 00h, 42h, 42h
		db	 7Eh, 42h, 42h, 42h, 00h, 00h
		db	 3Eh, 08h, 08h, 08h, 08h, 3Eh
		db	 00h, 00h, 02h, 02h, 02h, 42h
		db	 42h, 3Ch, 00h, 00h, 44h, 48h
		db	 70h, 48h, 44h, 42h, 00h, 00h
		db	 40h, 40h, 40h, 40h, 40h, 7Eh
		db	 00h, 00h, 42h, 66h, 5Ah, 42h
		db	 42h, 42h, 00h, 00h, 42h, 62h
		db	 52h, 4Ah, 46h, 42h, 00h, 00h
		db	 3Ch, 42h, 42h, 42h, 42h, 3Ch
		db	 00h, 00h, 7Ch, 42h, 42h, 7Ch
		db	 40h, 40h, 00h, 00h, 3Ch, 42h
		db	 42h, 52h, 4Ah, 3Ch, 00h, 00h
		db	 7Ch, 42h, 42h, 7Ch, 44h, 42h
		db	 00h, 00h, 3Ch, 40h, 3Ch, 02h
		db	 42h, 3Ch, 00h, 00h,0FEh, 10h
		db	 10h, 10h
loc_a_FDFE:
		adc	[bx+si],dl
		add	[bx+si],al
		inc	dx
		inc	dx
		inc	dx
		inc	dx
		inc	dx
		cmp	al,0
		add	[bp+si+42h],al
		inc	dx
		inc	dx
		and	al,18h
		add	[bx+si],al
		inc	dx
		inc	dx
		inc	dx
		inc	dx
		pop	dx
		and	al,0
		add	[bp+si+24h],al
		sbb	[bx+si],bl
		and	al,42h			; 'B'
		add	[bx+si],al
;*		add	byte ptr [si+28h],10h
		db	 82h, 44h, 28h, 10h	;  Fixup - byte match
		adc	[bx+si],dl
		add	[bx+si],al
;*		jle	loc_a_FE30		;*Jump if < or =
		db	 7Eh, 04h		;  Fixup - byte match
		or	[bx+si],dl
		and	[bp],bh
		add	byte ptr ds:[165h],cl
		mov	dl,0
		or	al,41h			; 'A'
		mov	al,6Ah			; 'j'
;*		add	dl,cl
		db	 00h,0CAh		;  Fixup - byte match
		add	bp,[bp+si]
		pop	es
		mov	cl,[bp+si]
;*		jmp	far ptr l_AA11_4A0D	;*
sub_a_E471	endp

		db	0EAh
		dw	4A0Dh, 0AA11h		;  Fixup - byte match
		db	 14h, 0Ah, 18h, 6Ah, 1Bh,0AAh
		db	 1Dh,0EAh, 1Fh, 2Ah, 22h, 6Ah
		db	 24h,0AAh, 26h,0EAh, 28h, 2Ah
		db	 2Bh, 20h, 00h,0B2h, 00h, 4Ah
		db	 00h,0B0h, 22h, 88h, 80h, 02h
		db	 28h,0A2h, 20h, 00h, 08h,0A2h
		db	 88h, 80h, 00h, 88h, 08h,0A2h
		db	 88h, 80h, 00h, 88h, 08h,0A2h
		db	 88h, 80h, 00h, 02h, 28h,0A2h
		db	 20h, 00h, 8Ah, 28h, 80h, 08h
		db	0A2h, 88h, 0Ah,0A2h, 00h, 0Ah
		db	0A2h,0A8h, 80h, 02h, 2Ah, 8Ah
		db	0A2h, 00h, 00h,0AAh, 2Ah, 8Ah
		db	0A2h, 00h, 00h,0AAh, 2Ah, 8Ah
		db	0A2h, 00h, 00h, 8Ah,0A2h,0A8h
		db	 80h, 02h,0A8h,0AAh, 20h, 0Ah
		db	 8Ah,0A0h, 2Ah,0AAh, 00h, 2Ah
		db	0AAh,0AAh, 80h, 02h,0AAh,0AAh
		db	0AAh, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h,0AAh,0AAh,0AAh
		db	 80h, 02h,0AAh,0AAh,0A0h, 0Ah
		db	0AAh,0A8h, 2Ah,0A8h, 80h, 2Ah
		db	0AAh,0AAh, 20h, 02h,0AAh,0AAh
		db	0A8h, 80h, 00h,0AAh,0AAh,0AAh
		db	0A8h, 80h, 00h,0AAh,0AAh,0AAh
		db	0A8h, 80h, 00h,0AAh,0AAh,0AAh
		db	 20h, 02h,0AAh,0AAh, 80h, 0Ah
		db	0AAh,0A8h, 2Ah,0A2h, 00h, 2Ah
		db	0AAh,0A8h, 80h, 02h,0AAh,0AAh
		db	0A2h, 00h, 00h,0AAh,0AAh
data_a_FF00	dw	0A2AAh			; Data table (indexed access)
		db	 00h, 00h,0AAh,0AAh,0AAh,0A2h
		db	 00h, 00h,0AAh,0AAh,0A8h, 80h
		db	 02h,0AAh,0AAh, 20h, 0Ah,0AAh
		db	0A0h, 2Ah,0A8h, 80h, 2Ah,0AAh
		db	0AAh, 20h, 02h,0AAh,0AAh,0A8h
		db	 80h, 00h,0AAh,0AAh,0AAh,0A8h
		db	 80h, 00h,0AAh,0AAh,0AAh,0A8h
		db	 80h, 00h,0AAh,0AAh,0AAh, 20h
		db	 02h,0AAh,0AAh, 80h, 0Ah,0AAh
		db	0A8h, 2Ah,0A8h, 00h, 2Ah,0AAh
		db	0AAh, 00h, 02h,0AAh,0AAh,0A8h
		db	 00h, 00h,0AAh,0AAh,0AAh,0A8h
		db	 00h, 00h,0AAh,0AAh,0AAh,0A8h
		db	 00h, 00h,0AAh,0AAh,0AAh, 00h
		db	 02h,0AAh,0AAh, 80h, 0Ah,0AAh
		db	0A8h, 2Ah,0A2h, 00h, 2Ah,0AAh
		db	0A8h, 80h, 02h,0AAh,0AAh,0A2h
		db	 00h, 00h,0AAh,0AAh,0AAh,0A2h
		db	 00h, 00h,0AAh,0AAh,0AAh,0A2h
		db	 00h, 00h,0AAh,0AAh,0A8h, 80h
		db	 02h,0AAh,0AAh, 20h, 0Ah,0AAh
		db	0A0h,0AAh,0AAh, 82h,0AAh,0AAh
		db	0AAh,0A8h, 2Ah,0AAh,0AAh,0AAh
		db	 88h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	 88h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	 88h, 2Ah,0AAh,0AAh,0AAh,0A2h
		db	 2Ah,0AAh,0AAh,0A8h, 2Ah,0AAh
		db	0AAh,0AAh,0AAh,0A2h,0AAh,0AAh
		db	0AAh,0AAh, 2Ah,0AAh,0AAh,0AAh
		db	0AAh, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	 2Ah,0AAh,0AAh,0AAh, 2Ah,0AAh
		db	0AAh,0AAh,0AAh, 82h,0AAh,0AAh
		db	0AAh,0A8h, 2Ah,0AAh,0AAh,0AAh
		db	0A8h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	 2Ah,0AAh,0AAh,0AAh, 2Ah,0AAh
		db	0AAh,0AAh,0A8h, 22h

seg_a		ends

	include	tower.inc

;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_a , ss:stack_seg_c

data_b_0000	db	0, 0
data_b_0002	db	0
data_b_0003	db	0
data_b_0004	dw	0	; SP
data_b_0006	dw	0
data_b_0008	db	0

;==========================================================================
;
;                       program	entry point
;
;==========================================================================


TOWER		proc	far

start:
		pushf				; Push flags
		push	ax
		push	ds
		push	es

		push	cs
		pop	ds

		push	cs
		pop	es

		assume	ds:seg_b
		mov	data_b_0004,sp
		mov	word ptr data_b_0000,201h
		mov	al,0
		mov	data_b_0008,al

		mov	al,13h
		mov	byte ptr ds:[0DCh],al
		mov	byte ptr ds:[151h],al
		mov	byte ptr ds:[71h],al
		mov	cx,2707h
		push	cx
		mov	cl,0F1h
		pop	cx
		nop
		nop
		mov	cx,2708h
		push	cx
		mov	cl,0DEh
		pop	cx
		nop
		nop
		jmp	loc_b_00F4
			                        ;* No entry point to code
		pop	ax
		mov	data_b_0006,ax
		push	cx
		int	11h			; Put equipment bits in ax
		and	ax,0C0h
		mov	cl,6
		shr	ax,cl			; Shift w/zeros fill
		inc	al
		inc	al
		mov	data_b_0002,al
;*		lea	si,cs:[16Ch]		; Load effective addr
		db	 8Dh, 36h, 6Ch, 01h	;  Fixup - byte match
		lea	bx,[si+20h]		; Load effective addr
		pop	cx
		mov	dl,data_b_0008
		cmp	dl,0
		jne	loc_b_0095		; Jump if not equal
		xor	dx,dx			; Zero register
loc_b_0068:
		push	cx
		mov	data_b_0003,0
		xor	ax,ax			; Zero register
		int	13h			; Disk  dl=drive a  ah=func 00h
						;  reset disk, al=return status
		mov	cx,1401h
;*		call	sub_b_0147		;*
		db	0E8h,0CFh, 00h		;  Fixup - byte match
		pop	cx
		mov	data_b_0003,10h
;*		call	sub_b_0147		;*
		db	0E8h,0C6h, 00h		;  Fixup - byte match
		test	ah,10h
		jnz	loc_b_0091		; Jump if not zero
		inc	dl
		cmp	dl,data_b_0002
		jb	loc_b_0068		; Jump if below
		jmp	short loc_b_00E7
		db	90h
loc_b_0091:
		mov	data_b_0008,dl
loc_b_0095:
		mov	bp,cx
		lea	bx,[si]			; Load effective addr
		pop	cx
		mov	data_b_0003,0
;*		call	sub_b_0147		;*
		db	0E8h,0A5h, 00h		;  Fixup - byte match
		jc	loc_b_00E7		; Jump if carry Set
		lea	bx,[si+20h]		; Load effective addr
		mov	cx,bp
		mov	data_b_0003,10h
;*		call	sub_b_0147		;*
		db	0E8h, 96h, 00h		;  Fixup - byte match
		lea	di,ds:[0ACh][si]	; Load effective addr
		mov	cx,10h
		cld				; Clear direction
		repe	cmpsw			; Rep zf=1+cx >0 Cmp [si] to es:[di]
		jnz	loc_b_00E7		; Jump if not zero
;*		lea	si,data_b_016C		; Load effective addr
		db	 8Dh, 36h, 6Ch, 01h	;  Fixup - byte match
;*		lea	di,data_b_0164		; Load effective addr
		db	 8Dh, 3Eh, 64h, 01h	;  Fixup - byte match
		mov	cx,4
		repe	cmpsw			; Rep zf=1+cx >0 Cmp [si] to es:[di]
		jnz	loc_b_00E7		; Jump if not zero
		mov	cx,bp
		mov	cl,1
		mov	ax,0F000h
		mov	es,ax
		mov	si,3
loc_b_00D8:
		mov	ax,209h
		int	13h			; Disk  dl=drive b  ah=func 02h
						;  read sectors to memory es:bx
						;   al=#,ch=cyl,cl=sectr,dh=head
		jnc	loc_b_00E2		; Jump if carry=0
		dec	si
		jnz	loc_b_00D8		; Jump if not zero
loc_b_00E2:
		mov	ax,data_b_0006
		push	ax
		retn
loc_b_00E7:
		call	sub_b_0127
		mov	sp,word ptr ds:[4]
		sub	cx,cx
		pop	ax
		push	ax
		jmp	short loc_b_00FF
loc_b_00F4:
		call	sub_b_0127
		mov	cx,12h
		mov	ax,cs
		add	ax,0FFE1h
loc_b_00FF:
		std				; Set direction flag
		cli				; Disable interrupts
		stosw				; Store ax to es:[di]
		mov	ax,cx
		stosw				; Store ax to es:[di]
		inc	di
		mov	cx,16h
;*		lea	si,ds:[146h]		; Load effective addr
		db	 8Dh, 36h, 46h, 01h	;  Fixup - byte match
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		cld				; Clear direction
		inc	di
		push	es
		push	di
		push	cs
		pop	es
		mov	cx,di
		sub	di,di
		shr	cx,1			; Shift w/zeros fill
		sub	ax,ax
		mov	bx,cs
		add	bx,0A47h
		mov	dx,80h
		retf				; Return far

TOWER		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0127	proc	near
		push	ss
		pop	es
		mov	di,word ptr ds:[4]
		sub	di,58h
		retn
sub_b_0127	endp

			                        ;* No entry point to code
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		pop	ds
		pop	es
		pop	ax
		pop	cx
		mov	ss,bx
		mov	sp,dx
		push	cx
		popf				; Pop flags
		push	ax
		mov	ah,4Ah			; 'J'
		mov	bx,2833h
		int	21h			; DOS Services  ah=function 4Ah
						;  change memory allocation
						;   bx=bytes/16, es=mem segment
		pop	ax
;*		jmp	far ptr l_BE56_071E	;*
		db	0EAh
		dw	71Eh, 0BE56h		;  Fixup - byte match
		db	6, 0
loc_b_014D:
		mov	ax,ds:d_0000_0000_e
		int	13h			; Disk  dl=drive a  ah=func 10h
						;  get drive ready status in al
		jnc	loc_b_0162		; Jump if carry=0
		test	ah,80h
		jnz	loc_b_0162		; Jump if not zero
		test	ah,ds:d_0000_0003_e
		jnz	loc_b_0162		; Jump if not zero
		dec	si
		jnz	loc_b_014D		; Jump if not zero
loc_b_0162:
		pop	si
		retn
data_b_0164	db	1
		db	 26h, 89h, 31h, 33h, 30h, 30h
		db	 67h
data_b_016C	db	?
		db	41731 dup (?)

seg_b		ends



;------------------------------------------------------  stack_seg_c   ----

stack_seg_c	segment	word stack 'stack'

data_c_0000	db	?
		db	127 dup (?)

stack_seg_c	ends



		end	start
