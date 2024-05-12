
PAGE  59,132

; Sourcer setup:
; -------------
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
;==				AV	                                 ==
;==					                                 ==
;==      Created:   18-Nov-88		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==      Copyright (c) 1987 Borland Intl.                                ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

callf           macro   location
                push    cs
                call    near ptr location
endm

jmpn            macro   location
                db      0E9h
                dw      offset location-$-2
endm

calls           macro   dummy1, dummy2, slocation
                db      9Ah                     ; forced call far instruction
                dw      offset slocation, seg slocation
endm

.186


; The following equates show data references outside the range of the program.

d_0000_002F_e	equ	2Fh
d_0000_0056_e	equ	56h
d_0000_005A_e	equ	5Ah
d_0000_0074_e	equ	74h
d_0000_007C_e	equ	7Ch
d_0000_0088_e	equ	88h
d_0000_008E_e	equ	8Eh
d_0000_0412_e	equ	412h
d_0000_0416_e	equ	416h
d_0000_047C_e	equ	47Ch
d_0000_050E_e	equ	50Eh			;*
d_0000_055F_e	equ	55Fh			;*
d_0000_0561_e	equ	561h			;*
d_0000_0569_e	equ	569h			;*
d_0000_056B_e	equ	56Bh			;*
d_0000_05F7_e	equ	5F7h			;*
d_0000_05FB_e	equ	5FBh			;*
d_0000_05FD_e	equ	5FDh			;*
d_0000_05FF_e	equ	5FFh			;*
d_0000_0601_e	equ	601h			;*
d_0000_0603_e	equ	603h			;*
d_0000_0605_e	equ	605h			;*
d_0000_0607_e	equ	607h			;*
d_0000_0609_e	equ	609h			;*
d_0000_060D_e	equ	60Dh			;*
d_0000_060E_e	equ	60Eh			;*
d_0000_060F_e	equ	60Fh			;*
d_0000_0610_e	equ	610h			;*
d_0000_0611_e	equ	611h			;*
d_0000_0612_e	equ	612h			;*
d_0000_0614_e	equ	614h			;*
d_0000_0616_e	equ	616h			;*
d_0000_0618_e	equ	618h			;*
d_0000_061A_e	equ	61Ah			;*
d_0000_061C_e	equ	61Ch			;*
d_0000_0634_e	equ	634h			;*
d_0000_0640_e	equ	640h			;*
d_0000_067C_e	equ	67Ch			;*
d_0000_094C_e	equ	94Ch			;*
d_0000_094E_e	equ	94Eh			;*
d_0000_094F_e	equ	94Fh			;*
d_0000_0950_e	equ	950h			;*
d_0000_0951_e	equ	951h			;*
d_0000_0955_e	equ	955h			;*
d_0000_095A_e	equ	95Ah			;*
d_0000_0966_e	equ	966h			;*
d_0000_0A94_e	equ	0A94h			;*
d_0000_0A96_e	equ	0A96h			;*
d_0000_0A98_e	equ	0A98h			;*
d_0000_0A9A_e	equ	0A9Ah			;*
d_0000_0A9C_e	equ	0A9Ch			;*
d_0000_0A9E_e	equ	0A9Eh			;*
d_0000_0AAC_e	equ	0AACh			;*
d_0000_0AAE_e	equ	0AAEh			;*
d_0000_0AB0_e	equ	0AB0h			;*
d_0000_0AB8_e	equ	0AB8h			;*
d_0000_0AB9_e	equ	0AB9h			;*
d_0000_0ABB_e	equ	0ABBh			;*
d_0000_0ABD_e	equ	0ABDh			;*
d_0000_0ABF_e	equ	0ABFh			;*
d_0000_0AC1_e	equ	0AC1h			;*
d_0000_0AC3_e	equ	0AC3h			;*
d_0000_0B29_e	equ	0B29h			;*
d_0000_0B2B_e	equ	0B2Bh			;*
d_0000_0B2D_e	equ	0B2Dh			;*
d_0000_0B37_e	equ	0B37h			;*
d_0000_0B3C_e	equ	0B3Ch			;*
d_0000_0B3E_e	equ	0B3Eh			;*
d_0000_0B3F_e	equ	0B3Fh			;*
d_0000_0B4F_e	equ	0B4Fh			;*
d_0000_0B51_e	equ	0B51h			;*
d_0000_0B5D_e	equ	0B5Dh			;*
d_0000_0B61_e	equ	0B61h			;*
d_0000_0B63_e	equ	0B63h			;*
d_0000_0B65_e	equ	0B65h			;*
d_0000_0B67_e	equ	0B67h			;*
d_0000_0B69_e	equ	0B69h			;*
d_0000_0B6B_e	equ	0B6Bh			;*
d_0000_0B6D_e	equ	0B6Dh			;*
d_0000_83EC_e	equ	83ECh			;*
d_0000_8BF0_e	equ	8BF0h			;*
d_0040_0010_e	equ	10h
d_0040_006C_e	equ	6Ch
PSP_free_seg	equ	2
PSP_envirn_seg	equ	2Ch
d_9033_0057_e	equ	57h
d_9033_0078_e	equ	78h
d_9033_007A_e	equ	7Ah
d_9033_007C_e	equ	7Ch
d_9033_007E_e	equ	7Eh
d_9033_0080_e	equ	80h
d_9033_0082_e	equ	82h
d_9033_095C_e	equ	95Ch			;*
data_b_0BE0_e	equ	0BE0h			;*
data_b_0DE0_e	equ	0DE0h			;*
data_b_0DE2_e	equ	0DE2h			;*
data_b_0DE4_e	equ	0DE4h			;*
data_b_0DE6_e	equ	0DE6h			;*
data_b_0DE8_e	equ	0DE8h			;*
data_b_0DEA_e	equ	0DEAh			;*
data_b_0DEC_e	equ	0DECh			;*
data_b_0DEE_e	equ	0DEEh			;*
data_b_0DF0_e	equ	0DF0h			;*
data_b_0DF2_e	equ	0DF2h			;*
data_b_0DF6_e	equ	0DF6h			;*
data_b_0DFA_e	equ	0DFAh			;*
data_b_0DFE_e	equ	0DFEh			;*
data_b_0E02_e	equ	0E02h			;*
data_b_0E03_e	equ	0E03h			;*
data_b_0E04_e	equ	0E04h			;*
data_b_0E05_e	equ	0E05h			;*
data_b_0E06_e	equ	0E06h			;*
data_b_0E07_e	equ	0E07h			;*
data_b_0E08_e	equ	0E08h			;*
data_b_0E0A_e	equ	0E0Ah			;*
data_b_0E0B_e	equ	0E0Bh			;*
data_b_0E0D_e	equ	0E0Dh			;*
data_b_0E0F_e	equ	0E0Fh			;*
data_b_0E11_e	equ	0E11h			;*
data_b_0E12_e	equ	0E12h			;*
data_b_0E2E_e	equ	0E2Eh			;*
data_b_0E2F_e	equ	0E2Fh			;*
data_b_0E9F_e	equ	0E9Fh			;*
data_b_0EA1_e	equ	0EA1h			;*
data_b_0EA2_e	equ	0EA2h			;*
data_b_0F50_e	equ	0F50h			;*
data_b_0F52_e	equ	0F52h			;*
data_b_0F54_e	equ	0F54h			;*
data_b_0F56_e	equ	0F56h			;*
data_b_0F58_e	equ	0F58h			;*
data_b_0F5A_e	equ	0F5Ah			;*
data_b_0FC0_e	equ	0FC0h			;*
data_b_0FCE_e	equ	0FCEh			;*
data_b_116A_e	equ	116Ah			;*
data_b_116C_e	equ	116Ch			;*
data_b_116E_e	equ	116Eh			;*
data_b_1170_e	equ	1170h			;*
data_b_1172_e	equ	1172h			;*
data_b_1174_e	equ	1174h			;*
data_b_1176_e	equ	1176h			;*
data_b_1202_e	equ	1202h			;*
data_b_12EB_e	equ	12EBh			;*
data_b_12EC_e	equ	12ECh			;*
data_b_12ED_e	equ	12EDh			;*
data_b_12EF_e	equ	12EFh			;*
data_b_12F1_e	equ	12F1h			;*
data_b_12F3_e	equ	12F3h			;*
data_b_12F5_e	equ	12F5h			;*
data_b_12F7_e	equ	12F7h			;*
data_b_12F9_e	equ	12F9h			;*
data_b_12FB_e	equ	12FBh			;*
data_b_12FE_e	equ	12FEh			;*
data_b_1301_e	equ	1301h			;*
data_b_1302_e	equ	1302h			;*
data_b_1304_e	equ	1304h			;*
data_b_1305_e	equ	1305h			;*
data_b_1307_e	equ	1307h			;*
data_b_130D_e	equ	130Dh			;*
data_b_130F_e	equ	130Fh			;*
data_b_1311_e	equ	1311h			;*
data_b_1315_e	equ	1315h			;*
data_b_1317_e	equ	1317h			;*
data_b_1454_e	equ	1454h			;*
data_b_14D5_e	equ	14D5h			;*
data_b_160A_e	equ	160Ah			;*
data_b_16AD_e	equ	16ADh			;*
data_b_16CD_e	equ	16CDh			;*
data_b_703E_e	equ	703Eh			;*
data_b_7200_e	equ	7200h			;*
data_b_9110_e	equ	9110h			;*
data_b_98AD_e	equ	98ADh			;*
data_b_F111_e	equ	0F111h			;*
data_b_FFF2_e	equ	0FFF2h			;*
data_c_83EC_e	equ	83ECh			;*
data_c_FF6E_e	equ	0FF6Eh			;*
data_c_FF70_e	equ	0FF70h			;*
data_c_FF71_e	equ	0FF71h			;*
data_c_FF72_e	equ	0FF72h			;*
data_c_FF74_e	equ	0FF74h			;*
data_c_FF76_e	equ	0FF76h			;*
data_c_FF77_e	equ	0FF77h			;*
data_c_FF78_e	equ	0FF78h			;*
data_c_FF7A_e	equ	0FF7Ah			;*
data_c_FF7C_e	equ	0FF7Ch			;*
data_c_FF7D_e	equ	0FF7Dh			;*
d_B800_2000_e	equ	2000h
d_B800_B800_e	equ	0B800h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	byte public
		assume cs:seg_a  , ds:seg_b , ss:stack_seg_c


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


AV		proc	far

start:
		sti				; Enable interrupts
		mov	dx,seg seg_b
		mov	cs:data_a_01A3,dx	; data segment DS = seg_b

		; get DOS version
		mov	ah,30h
		int	21h			; DOS Services  ah=function 30h
						;  get DOS version number ax

		; save segments
		mov	bp,ds:PSP_free_seg	; PSP free segment
		mov	bx,ds:PSP_envirn_seg	; PSP environment segment
		mov	ds,dx
		mov	data_b_0086,ax
		mov	data_b_0084,es		; PSP segment
		mov	word ptr data_b_007E+2,bx ; PSP environment segment
		mov	data_b_009C,bp		; PSP free segment
		mov	data_b_008A,0FFFFh	; 1 = coprocessor 8087

		call	sub_a_0155		; Install INT 00h handler

		; prepare to parse environment ES:DI
		les	di,data_b_007E		; Load seg:offset ptr; segment = PSP environment segment
		mov	ax,di			; AX <- 0
		mov	bx,ax			; BX <- 0
		mov	cx,7FFFh

		; check coprocessor in environment (87=Y)
loc_a_003A:	cmp	word ptr es:[di],3738h	; '87'
		jne	loc_a_005A		; Jump if not equal
		mov	dx,es:[di+2]
		cmp	dl,3Dh			; '='
		jne	loc_a_005A		; Jump if not equal
		and	dh,0DFh
		inc	data_b_008A
		cmp	dh,59h			; 'Y'
		jne	loc_a_005A		; Jump if not equal
		inc	data_b_008A		; 1 = coprocessor 8087
loc_a_005A:	repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_a_00C5		; Jump if cx=0
		inc	bx
		cmp	es:[di],al
		jne	loc_a_003A		; Jump if not equal


		or	ch,80h
		neg	cx
		mov	word ptr data_b_007E,cx ; + 2 = PSP environment segment
		mov	cx,1
		shl	bx,cl			; Shift w/zeros fill
		add	bx,8
;*		and	bx,0FFF8h
		db	 81h,0E3h,0F8h,0FFh	;  Fixup - byte match
		mov	data_b_0082,bx

		push	cs
		call	word ptr data_b_0958

		mov	dx,ds
		sub	bp,dx

		mov	di,data_b_047E
		cmp	di,100h
		jae	loc_a_0097		; Jump if above or =
		mov	di,100h
		mov	data_b_047E,di
loc_a_0097:
		add	di,0B75h
		jc	loc_a_00C5		; Jump if carry Set
		add	di,data_b_041A
		jc	loc_a_00C5		; Jump if carry Set
		mov	cl,4
		shr	di,cl			; Shift w/zeros fill
		inc	di
		cmp	bp,di
		jb	loc_a_00C5		; Jump if below
		cmp	data_b_047E,0
		je	loc_a_00BA		; Jump if equal
		cmp	data_b_041A,0
		jne	loc_a_00C8		; Jump if not equal
loc_a_00BA:
		mov	di,1000h
		cmp	bp,di
		ja	loc_a_00C8		; Jump if above
		mov	di,bp
		jmp	short loc_a_00C8
loc_a_00C5:
		jmp	loc_a_018D	; Error 'Abnormal program termination'
loc_a_00C8:
		mov	bx,di
		add	bx,dx
		mov	data_b_0094,bx
		mov	data_b_0098,bx
		mov	ax,data_b_0084		; PSP segment
		sub	bx,ax
		mov	es,ax
		mov	ah,4Ah			; 'J'
		push	di
		int	21h			; DOS Services  ah=function 4Ah
						;  change memory allocation
						;   bx=bytes/16, es=mem segment
		pop	di
		shl	di,cl			; Shift w/zeros fill
		mov	ss,dx
		mov	sp,di
		call	sub_a_49F6
		call	sub_a_4AE1
		xor	ax,ax			; Zero register
		mov	es,cs:data_a_01A3	; data segment DS = seg_b
		mov	di,d_0000_0966_e
		mov	cx,0B75h
		sub	cx,di
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		call	word ptr ds:d_9033_095C_e
		push	word ptr ds:d_9033_007C_e
		push	word ptr ds:d_9033_007A_e
		push	word ptr ds:d_9033_0078_e
		call	sub_a_01A5
		push	ax
		call	sub_a_402F

AV		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

;      Note: Subroutine does not return	to instruction after call

; Quit program

sub_a_0115	proc	near
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		call	sub_a_0171		; Restore INT 00h handler
		push	cs
		call	word ptr ds:d_0000_095A_e
		xor	ax,ax			; Zero register
		mov	si,ax
		mov	cx,2Fh
		nop
		cld				; Clear direction

locloop_a_012B:
		add	al,[si]
		adc	ah,0
		inc	si
		loop	locloop_a_012B		; Loop if cx > 0

		sub	ax,0D36h
		nop
		jz	loc_a_0143		; Jump if zero

		; print error 'Null pointer assignment'
		mov	cx,19h
		nop
		mov	dx,d_0000_002F_e
		call	sub_a_0185		; Write to DOS error console
loc_a_0143:
		; quit
		mov	bp,sp
		mov	ah,4Ch			; 'L'
		mov	al,[bp+2]
		int	21h			; DOS Services  ah=function 4Ch
						;  terminate with al=return code
sub_a_0115	endp


;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

; INT 00h handler 
; Exit and print error: Divide error

int_00h_entry	proc	far
		mov	cx,0Eh
		nop
		mov	dx,48h
		jmp	short loc_a_0194
int_00h_entry	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 00h handler

sub_a_0155	proc	near

		; save INT 08h old handler
		push	ds
		mov	ax,3500h
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	word ptr data_b_0073+1,bx
		mov	data_b_0076,es

		; install new INT 00h handler
		mov	ax,2500h
		mov	dx,cs
		mov	ds,dx
		mov	dx,offset int_00h_entry
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		retn
sub_a_0155	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Restore INT 00h handler

sub_a_0171	proc	near
		push	ds
		mov	ax,2500h
		lds	dx,dword ptr ds:d_0000_0074_e	; Load seg:offset ptr
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		retn
sub_a_0171	endp

; 017Dh: Exit routine, clear exit code

			                        ;* No entry point to code
		mov	data_b_008A,0		; 1 = coprocessor 8087
		retf				; Return far
		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Write to DOS error console

sub_a_0185	proc	near
		mov	ah,40h			; '@'
		mov	bx,2
		int	21h			; DOS Services  ah=function 40h
						;  write file  bx=file handle
						;   cx=bytes from ds:dx buffer
		retn

sub_a_0185	endp

		; Error 'Abnormal program termination'
loc_a_018D:
		mov	cx,1Eh
		nop
		mov	dx,d_0000_0056_e
loc_a_0194:
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		call	sub_a_0185		; Write to DOS error console
		mov	ax,3
		push	ax
		call	sub_a_0115		; Sub does not return here ; Quit program

data_a_01A3	dw	0		; data segment DS = seg_b

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_01A5	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,4

		mov	word ptr [bp-4],1
		mov	word ptr [bp-2],3

		mov	ax,2470h
		push	ax			; PARAMETER_1
		call	sub_a_420C
		inc	sp
		inc	sp
		or	ax,ax			; Zero ?
		jge	loc_a_01CD		; Jump if > or =

		mov	ax,1
		push	ax
		call	sub_a_402F
		inc	sp
		inc	sp

loc_a_01CD:	push	ds
		mov	ax,2B2h
		push	ax
		push	ss
		lea	ax,[bp-2]		; Load effective addr
		push	ax
		push	ss
		lea	ax,[bp-4]		; Load effective addr
		push	ax
		calls	far ptr sub_a_5AA2
		add	sp,0Ch

		calls	far ptr sub_a_539D
		or	ax,ax			; Zero ?
		jge	loc_a_01F9		; Jump if > or =

		mov	ax,2B3h
		push	ax
		call	sub_a_3E36
		inc	sp
		inc	sp
		jmp	loc_a_02FA

loc_a_01F9:	call	sub_a_043A		; Read file AV.DAT
		or	ax,ax			; Zero ?
		jnz	loc_a_0203		; Jump if not zero
		jmp	loc_a_02F5

loc_a_0203:	xor	ax,ax			; Zero register
		mov	data_b_024E,ax
		mov	data_b_09D8,ax
		call	sub_a_0300		; Input mouse
		or	ax,ax			; Zero ?
		jnz	loc_a_0254		; Jump if not zero
		mov	di,1
		jmp	short loc_a_024F

loc_a_0217:	xor	si,si			; Zero register
		jmp	short loc_a_023C

loc_a_021B:	mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,si
		mov	al,data_b_00D8[bx]
		push	ax
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,si
		pop	ax
		mov	data_b_00CA[bx],al
		inc	si

loc_a_023C:	cmp	si,0Eh
		jl	loc_a_021B		; Jump if <
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		dec	data_b_00AC[bx]
		inc	di

loc_a_024F:	cmp	di,3
		jl	loc_a_0217		; Jump if <

loc_a_0254:	call	sub_a_3C21
		test	ax,1
		jz	loc_a_0263		; Jump if zero
		call	sub_a_0724		; Check joystick
		or	ax,ax			; Zero ?
		jnz	loc_a_02C5		; Jump if not zero
loc_a_0263:
		mov	di,1
		jmp	short loc_a_02C0
loc_a_0268:
		xor	si,si			; Zero register
		jmp	short loc_a_02AD
loc_a_026C:
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,si
		mov	al,data_b_00CA[bx]
		push	ax
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,si
		pop	ax
		mov	data_b_00BC[bx],al
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,si
		mov	al,data_b_00D8[bx]
		push	ax
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,si
		pop	ax
		mov	data_b_00CA[bx],al
		inc	si
loc_a_02AD:
		cmp	si,0Eh
		jl	loc_a_026C		; Jump if <
		mov	ax,di
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		dec	data_b_00AC[bx]
		inc	di
loc_a_02C0:
		cmp	di,3
		jl	loc_a_0268		; Jump if <
loc_a_02C5:
		call	sub_a_0BEE
		mov	data_b_098C,40h
		mov	data_b_098E,0E2h
		mov	data_b_09E4,0ADh
		mov	data_b_09E6,0ADh

; Game menu

loc_a_02E0:	call	sub_a_09AF		; Game menu
		or	ax,ax			; Zero ?
		jz	loc_a_02F5		; Jump if zero - exit

		call	sub_a_2008
		mov	ax,data_b_09D8
		xor	ax,1
		mov	data_b_09D8,ax
		jmp	short loc_a_02E0

; Exit game

loc_a_02F5:	calls	far ptr sub_a_5CE3
loc_a_02FA:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_01A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input mouse

sub_a_0300	proc	near

LOCAL_8		=	-10h			; bp+0FFF0h
LOCAL_7		=	-0Eh			; bp+0FFF2h
LOCAL_6		=	-0Ch			; bp+0FFF4h
LOCAL_5		=	-0Ah			; bp+0FFF6h
LOCAL_4		=	-8			; bp+0FFF8h
LOCAL_3		=	-6			; bp+0FFFAh
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,10h
		mov	word ptr [bp+LOCAL_8],0
		lea	ax,[bp+LOCAL_8]		; Load effective addr
		push	ax
		lea	ax,[bp+LOCAL_8]		; Load effective addr
		push	ax
		mov	ax,33h
		push	ax
		call	sub_a_4230		; Call INT xx function
		add	sp,6
		cmp	word ptr [bp+LOCAL_8],0
		jne	loc_a_0327		; Jump if not equal
		xor	ax,ax			; Zero register
		jmp	short loc_a_0341
loc_a_0327:
		mov	word ptr [bp+LOCAL_8],2
		lea	ax,[bp+LOCAL_8]		; Load effective addr
		push	ax
		lea	ax,[bp+LOCAL_8]		; Load effective addr
		push	ax
		mov	ax,33h
		push	ax
		call	sub_a_4230		; Call INT xx function
		add	sp,6
		mov	ax,1
loc_a_0341:
		mov	sp,bp
		pop	bp
		retn
sub_a_0300	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0345	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ch
		mov	bx,[bp+8]
		mov	bx,[bx]
		mov	ax,[bx]
		add	ax,4
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mov	[bp-4],ax
		mov	bx,[bp+8]
		mov	bx,[bx]
		mov	ax,[bx+2]
		inc	ax
		mov	[bp-2],ax
		mov	word ptr [bp-6],0
		jmp	loc_a_040B
loc_a_0372:
		mov	bx,[bp-6]
		shl	bx,1			; Shift w/zeros fill
		add	bx,[bp+8]
		mov	si,[bx]
		mov	ax,[bp-2]
		dec	ax
		push	ax
		push	word ptr [si]
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		calls	far ptr sub_a_6324
		add	sp,8
		push	ax
		call	sub_a_44B8
		inc	sp
		inc	sp
		mov	bx,[bp-6]
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		add	bx,[bp+8]
		mov	[bx],ax
		mov	bx,[bp-6]
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		add	bx,[bp+8]
		mov	di,[bx]
		mov	word ptr [bp-8],0
		jmp	short loc_a_03BB
loc_a_03B2:
		mov	al,[si]
		mov	[di],al
		inc	si
		inc	di
		inc	word ptr [bp-8]
loc_a_03BB:
		cmp	word ptr [bp-8],4
		jl	loc_a_03B2		; Jump if <
		mov	word ptr [bp-8],0
		jmp	short loc_a_0400
loc_a_03C8:
		mov	word ptr [bp-0Ch],0
		mov	word ptr [bp-0Ah],0
		jmp	short loc_a_03F5
loc_a_03D4:
		mov	al,[si]
		mov	ah,0
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		add	al,[bp-0Ch]
		mov	[di],al
		inc	di
		mov	al,[si]
		mov	ah,0
		and	ax,3
		mov	cx,6
		shl	ax,cl			; Shift w/zeros fill
		mov	[bp-0Ch],ax
		inc	si
		inc	word ptr [bp-0Ah]
loc_a_03F5:
		mov	ax,[bp-0Ah]
		cmp	ax,[bp-4]
		jl	loc_a_03D4		; Jump if <
		inc	word ptr [bp-8]
loc_a_0400:
		mov	ax,[bp-8]
		cmp	ax,[bp-2]
		jl	loc_a_03C8		; Jump if <
		inc	word ptr [bp-6]
loc_a_040B:
		cmp	word ptr [bp-6],3
		jge	loc_a_0414		; Jump if > or =
		jmp	loc_a_0372
loc_a_0414:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0345	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_041A	proc	near
		push	si
		push	bp
		mov	bp,sp
		push	word ptr [bp+6]
		call	sub_a_44B8
		mov	sp,bp
		mov	si,ax
		push	word ptr [bp+6]
		push	si
		push	data_b_0A50
		call	sub_a_464E		; Read file
		mov	sp,bp
		mov	ax,si
		pop	bp
		pop	si
		retn
sub_a_041A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read file AV.DAT

sub_a_043A	proc	near
		push	si
		mov	ax,1
		push	ax
		mov	ax,2CBh
		push	ax
		call	sub_a_45F4		; Open file
		add	sp,4
		mov	data_b_0A50,ax
		cmp	ax,0FFFFh
		jne	loc_a_0463		; Jump if not equal
		push	ds
		mov	ax,2D2h
		push	ax
		calls	far ptr sub_a_63F4
		add	sp,4
		xor	ax,ax			; Zero register
		jmp	loc_a_063D
loc_a_0463:
		mov	ax,46h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09DA,ax
		mov	ax,46h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0A38,ax
		mov	ax,1Ah
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09BA,ax
		mov	ax,10Ah
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09EE,ax
		mov	ax,10Ah
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09F6,ax
		mov	ax,132h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09FE,ax
		mov	ax,132h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0A06,ax
		mov	ax,10Ah
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0994,ax
		mov	ax,10Ah
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_099C,ax
		mov	ax,132h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09A4,ax
		mov	ax,132h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09AC,ax
		mov	ax,0CAh
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_09B4,ax
		mov	ax,146h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0A18,ax
		mov	ax,146h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0A20,ax
		mov	ax,146h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0A28,ax
		mov	ax,146h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0A30,ax
		mov	ax,0B6h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0966,ax
		mov	ax,0B6h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_096E,ax
		mov	ax,0B6h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	data_b_0976,ax
		mov	ax,0B6h
		push	ax
		call	sub_a_041A
		inc	sp
		inc	sp
		mov	word ptr data_b_097D+1,ax
		push	data_b_0A50
		call	sub_a_3CBD		; Close file
		inc	sp
		inc	sp
		xor	si,si			; Zero register
		jmp	short loc_a_05A5
loc_a_0560:
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,994h
		push	ax
		call	sub_a_0345
		inc	sp
		inc	sp
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,9EEh
		push	ax
		call	sub_a_0345
		inc	sp
		inc	sp
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,0A18h
		push	ax
		call	sub_a_0345
		inc	sp
		inc	sp
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,966h
		push	ax
		call	sub_a_0345
		inc	sp
		inc	sp
		inc	si
loc_a_05A5:
		cmp	si,4
		jl	loc_a_0560		; Jump if <
		mov	ax,0Fh
		push	ax
		mov	ax,1
		push	ax
		calls	far ptr sub_a_6035
		add	sp,4
		mov	ax,7
		push	ax
		mov	ax,70h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		calls	far ptr sub_a_6324
		add	sp,8
		push	ax
		call	sub_a_44B8
		inc	sp
		inc	sp
		mov	data_b_09C2,ax
		call	sub_a_22BF		; Wait for VSYNC
		mov	ax,7
		push	ax			; PARAMETER_4
		mov	ax,70h
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6A19
		add	sp,8
		mov	ax,data_b_09C2
		mov	dx,ds
		push	dx
		push	ax			; PARAMETER_5
		mov	ax,7
		push	ax			; PARAMETER_4
		mov	ax,70h
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6D73
		add	sp,0Ch
		push	data_b_09C2
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		xor	ax,ax			; Zero register
		push	ax
		mov	ax,1
		push	ax
		calls	far ptr sub_a_6035
		add	sp,4
		mov	ax,7
		push	ax			; PARAMETER_4
		mov	ax,70h
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6A19
		add	sp,8
		mov	ax,1
loc_a_063D:
		pop	si
		retn
sub_a_043A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_063F	proc	near
		push	si
		push	di
loc_a_0641:
		call	sub_a_432B		; Check DOS key
		or	ax,ax			; Zero ?
		jz	loc_a_064B		; Jump if zero
		jmp	loc_a_071E
loc_a_064B:
		inc	data_b_09E2
		mov	bx,data_b_09D6
		shl	bx,1			; Shift w/zeros fill
;*		cmp	data_b_09E8[bx],0FFFFh
		db	 83h,0BFh,0E8h, 09h,0FFh	;  Fixup - byte match
		jnz	loc_a_0683		; Jump if not zero
		mov	ax,data_b_09D6
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	data_b_09CC[bx],0
		mov	ax,1
		sub	ax,data_b_09D6
		mov	data_b_09D6,ax
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	data_b_09CC[bx],1
loc_a_0683:
		call	sub_a_0E7A
		mov	si,data_b_098C
		mov	di,data_b_098E
		call	sub_a_22BF		; Wait for VSYNC
		mov	bx,data_b_09BE
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,si
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0994[bx]
		push	data_b_09E4
		push	si
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		mov	bx,data_b_09C0
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,di
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_09EE[bx]
		push	data_b_09E6
		push	di
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		cmp	si,6
		jge	loc_a_06EE		; Jump if > or =
		push	data_b_09DA
		mov	ax,data_b_09E4
		add	ax,0FFFEh
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
loc_a_06EE:
		cmp	di,113h
		jle	loc_a_0709		; Jump if < or =
		push	data_b_0A38
		mov	ax,data_b_09E6
		add	ax,0FFFEh
		push	ax
		mov	ax,138h
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
loc_a_0709:
		push	data_b_09B4
		mov	ax,67h
		push	ax
		mov	ax,9Eh
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		jmp	loc_a_0641
loc_a_071E:
		call	sub_a_4104
		pop	di
		pop	si
		retn
sub_a_063F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check joystick

sub_a_0724	proc	near
		push	si
		push	di
		mov	di,201h
		mov	data_b_0A42,7D00h
		xor	si,si			; Zero register
		mov	al,7Fh
		mov	dx,di
		out	dx,al			; port 201h, start game 1-shots
loc_a_0736:
		mov	dx,di
		in	al,dx			; port 201h, start game 1-shots
;*		test	al,1
		db	0F6h,0C0h, 01h		;  Fixup - byte match
		jnz	loc_a_0747		; Jump if not zero
		cmp	si,data_b_0A42
		jge	loc_a_0747		; Jump if > or =
		inc	si
		jmp	short loc_a_0736
loc_a_0747:
		or	si,si			; Zero ?
		jl	loc_a_0762		; Jump if <
		xor	si,si			; Zero register
loc_a_074D:
		mov	dx,di
		in	al,dx			; port 201h, start game 1-shots
;*		test	al,1
		db	0F6h,0C0h, 01h		;  Fixup - byte match
		jz	loc_a_075E		; Jump if zero
		cmp	si,data_b_0A42
		jge	loc_a_075E		; Jump if > or =
		inc	si
		jmp	short loc_a_074D
loc_a_075E:
		or	si,si			; Zero ?
		jge	loc_a_0766		; Jump if > or =
loc_a_0762:
		xor	ax,ax			; Zero register
		jmp	short loc_a_0776
loc_a_0766:
		mov	data_b_0A44,si
		mov	ax,si
		sar	ax,1			; Shift w/sign fill
		add	ax,si
		mov	data_b_0A42,ax
		mov	ax,1
loc_a_0776:
		pop	di
		pop	si
		retn
sub_a_0724	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Game menu

sub_a_0779	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,8
		mov	word ptr [bp-6],68h
		mov	word ptr [bp-4],70h
		mov	di,28h
		xor	si,si			; Zero register
		jmp	short loc_a_07AB
loc_a_0792:
		push	data_b_09C2
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax
		push	word ptr [bp-6]
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		inc	si
loc_a_07AB:
		cmp	si,7
		jl	loc_a_0792		; Jump if <
		call	sub_a_22BF		; Wait for VSYNC
		xor	si,si			; Zero register
		jmp	short loc_a_07F4
loc_a_07B7:
		mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_00AA[bx]
		mov	dx,0Eh
		mul	dx			; dx:ax = reg * ax
		push	ax
		mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	dx,ax
		pop	ax
		add	ax,dx
		add	ax,0AEh
		mov	dx,ds
		push	dx
		push	ax			; PARAMETER_3
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax			; PARAMETER_2
		push	word ptr [bp-4]		; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8
		inc	si

; display menu cursor

loc_a_07F4:	cmp	si,7
		jl	loc_a_07B7		; Jump if <
		push	data_b_09C2
		push	di
		push	word ptr [bp-6]
		call	sub_a_234E		; Display image XOR: X, Y, image(with, height, data)
		add	sp,6
		xor	si,si			; Zero register
		mov	byte ptr [bp-1],0
loc_a_080D:
		call	sub_a_063F
		mov	[bp-1],al
;*		cmp	al,0Dh
		db	 80h,0F8h, 0Dh		;  Fixup - byte match
		jz	loc_a_0882		; Jump if zero
		call	sub_a_432B		; Check DOS key
		or	ax,ax			; Zero ?
		jz	loc_a_0825		; Jump if zero
		call	sub_a_4104
		mov	[bp-1],al
loc_a_0825:
		mov	ax,0FA0h
		push	ax			; PARAMETER_1
		call	sub_a_4B2B		; Enable output to speaker, set tone
		inc	sp
		inc	sp
		call	sub_a_4B57		; Disable output to speaker
		call	sub_a_22BF		; Wait for VSYNC

; clear menu cursor (XOR box)

		push	data_b_09C2
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax
		push	word ptr [bp-6]
		call	sub_a_234E		; Display image XOR: X, Y, image(with, height, data)
		add	sp,6

; '2' or 'P' - menu down

		cmp	byte ptr [bp-1],32h	; '2'
		je	loc_a_0858		; Jump if equal
		cmp	byte ptr [bp-1],50h	; 'P'
		jne	loc_a_0863		; Jump if not equal

loc_a_0858:	inc	si
		mov	ax,si
		mov	bx,7
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	si,dx

; '8' or 'H' - menu up

loc_a_0863:	cmp	byte ptr [bp-1],38h	; '8'
		je	loc_a_0872		; Jump if equal
		cmp	byte ptr [bp-1],48h	; 'H'
		je	loc_a_0872		; Jump if equal
		jmp	loc_a_0919

loc_a_0872:	mov	ax,si
		add	ax,6
		mov	bx,offset data_b_0007
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	si,dx
		jmp	loc_a_0919

loc_a_0882:	mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		cmp	data_b_00AC[bx],0
		jg	loc_a_0895		; Jump if >
		jmp	loc_a_0934

loc_a_0895:	mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		inc	data_b_00AA[bx]
		mov	ax,data_b_00AA[bx]
		push	ax
		mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		cwd				; Word to double word
		idiv	data_b_00AC[bx]		; ax,dxrem=dx:ax/data
		mov	ax,si
		mov	bx,offset data_b_003C	; ('assignment')
		push	dx
		mul	bx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_00AA[bx],ax
		push	data_b_09C2
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax
		push	word ptr [bp-6]
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_00AA[bx]
		mov	dx,0Eh
		mul	dx			; dx:ax = reg * ax
		push	ax
		mov	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	dx,ax
		pop	ax
		add	ax,dx
		add	ax,0AEh
		mov	dx,ds
		push	dx
		push	ax			; PARAMETER_3
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax			; PARAMETER_2
		push	word ptr [bp-4]		; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

; clear menu cursor on new position

loc_a_0919:	push	data_b_09C2
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax
		push	word ptr [bp-6]
		call	sub_a_234E		; Display image XOR: X, Y, image(with, height, data)
		add	sp,6
		jmp	loc_a_080D

loc_a_0934:	mov	word ptr [bp-8],0
		jmp	short loc_a_0957

loc_a_093B:	push	data_b_09C2
		mov	ax,[bp-8]
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,di
		push	ax
		push	word ptr [bp-6]
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		inc	word ptr [bp-8]

loc_a_0957:	cmp	word ptr [bp-8],7
		jl	loc_a_093B		; Jump if <

		mov	ax,si
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0779	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0965	proc	near
		push	si
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		push	ss
		lea	ax,[bp-2]		; Load effective addr
		push	ax			; PARAMETER_3
		push	ds			; PARAMETER_2
		mov	ax,2B0h
		push	ax			; PARAMETER_1
		mov	cx,2
		calls	far ptr sub_a_466C
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_3C3B
		inc	sp
		inc	sp
		mov	si,ax
		mov	ax,si
;*		and	al,0FFh
		db	 80h,0E0h,0FFh		;  Fixup - byte match
		mov	[bp-2],al
		push	ss
		lea	ax,[bp-2]		; Load effective addr
		push	ax			; PARAMETER_3
		push	word ptr [bp+6]		; PARAMETER_2
		mov	ax,0C8h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8
		mov	ax,si
		mov	cx,8
		sar	ax,cl			; Shift w/sign fill
		mov	sp,bp
		pop	bp
		pop	si
		retn
sub_a_0965	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Game menu

sub_a_09AF	proc	near

		push	si
		push	di
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		mov	bx,data_b_09BE
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098C
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0994[bx]
		push	data_b_09E4
		push	data_b_098C
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		mov	bx,data_b_09C0
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098E
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_09EE[bx]
		push	data_b_09E6
		push	data_b_098E
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		mov	ax,0C7h
		push	ax
		mov	ax,138h
		push	ax
		mov	ax,0Bh
		push	ax
		mov	ax,3
		push	ax
		calls	far ptr sub_a_5FCA
		add	sp,8
		push	data_b_09B4
		mov	ax,67h
		push	ax
		mov	ax,9Eh
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		xor	si,si			; Zero register
		jmp	short loc_a_0A7B

loc_a_0A30:	xor	ax,ax			; Zero register
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09BE[bx],ax
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09C8[bx],ax
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CA[bx],ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	data_b_09CC[bx],si
		mov	ax,si
		dec	ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E8[bx],ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E4[bx],0ADh
		inc	si

loc_a_0A7B:	cmp	si,2
		jl	loc_a_0A30		; Jump if <
		mov	data_b_09D6,1

; Select option of game menu

loc_a_0A86:	call	sub_a_0779		; Game menu
		mov	[bp-2],ax		; selecte option

; 4: Define keys

		cmp	ax,4
		je	loc_a_0A94		; Jump if equal
		jmp	loc_a_0B82

loc_a_0A94:	mov	di,9Eh
		push	ds
		mov	ax,2EDh
		push	ax			; PARAMETER_3
		mov	ax,28h
		push	ax			; PARAMETER_2
		mov	ax,68h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		mov	ax,28h
		push	ax
		call	sub_a_0965
		inc	sp
		inc	sp
		mov	[di],ax

		push	ds
		mov	ax,2FAh
		push	ax			; PARAMETER_3
		mov	ax,30h
		push	ax			; PARAMETER_2
		mov	ax,68h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		mov	ax,30h
		push	ax
		call	sub_a_0965
		inc	sp
		inc	sp
		mov	[di+2],ax

		push	ds
		mov	ax,307h
		push	ax			; PARAMETER_3
		mov	ax,38h
		push	ax			; PARAMETER_2
		mov	ax,68h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		mov	ax,38h
		push	ax
		call	sub_a_0965
		inc	sp
		inc	sp
		mov	[di+4],ax

		mov	di,0A4h
		push	ds
		mov	ax,314h
		push	ax			; PARAMETER_3
		mov	ax,40h
		push	ax			; PARAMETER_2
		mov	ax,68h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		mov	ax,40h
		push	ax
		call	sub_a_0965
		inc	sp
		inc	sp
		mov	[di],ax

		push	ds
		mov	ax,321h
		push	ax			; PARAMETER_3
		mov	ax,48h
		push	ax			; PARAMETER_2
		mov	ax,68h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		mov	ax,48h
		push	ax
		call	sub_a_0965
		inc	sp
		inc	sp
		mov	[di+2],ax

		push	ds
		mov	ax,32Eh
		push	ax			; PARAMETER_3
		mov	ax,50h
		push	ax			; PARAMETER_2
		mov	ax,68h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		mov	ax,50h
		push	ax
		call	sub_a_0965
		inc	sp
		inc	sp
		mov	[di+4],ax

		xor	si,si			; Zero register
		jmp	short loc_a_0B7D

loc_a_0B62:	push	data_b_09C2
		mov	ax,si
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	ax,28h
		push	ax
		mov	ax,68h
		push	ax
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		inc	si

loc_a_0B7D:	cmp	si,7
		jl	loc_a_0B62		; Jump if <

; 5: Set joystick

loc_a_0B82:
		cmp	word ptr [bp-2],5
		jne	loc_a_0BC3		; Jump if not equal
		push	ds
		mov	ax,33Bh
		push	ax			; PARAMETER_3
		mov	ax,28h
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8
		call	sub_a_4104
		call	sub_a_0724		; Check joystick
		xor	si,si			; Zero register
		jmp	short loc_a_0BBE

loc_a_0BA4:	push	data_b_09C2
		mov	ax,28h
		push	ax
		mov	ax,si
		mov	dx,2Ah
		mul	dx			; dx:ax = reg * ax
		add	ax,28h
		push	ax
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		inc	si

loc_a_0BBE:	cmp	si,4
		jl	loc_a_0BA4		; Jump if <

loc_a_0BC3:	cmp	word ptr [bp-2],0
		jle	loc_a_0BD2		; Jump if < or =
		cmp	word ptr [bp-2],6
		jge	loc_a_0BD2		; Jump if > or =
		jmp	loc_a_0A86

; 6: Exit game

loc_a_0BD2:	cmp	word ptr [bp-2],6
		jne	loc_a_0BDC		; Jump if not equal
		xor	ax,ax			; Zero register
		jmp	short loc_a_0BE8

loc_a_0BDC:	mov	ax,data_b_015E
		xor	ax,1
		mov	data_b_024E,ax
		mov	ax,1

loc_a_0BE8:	mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_09AF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0BEE	proc	near

		call	sub_a_22BF		; Wait for VSYNC

		calls	far ptr sub_a_5D80

		mov	ax,0C7h
		push	ax
		mov	ax,138h
		push	ax
		mov	ax,0Bh
		push	ax
		mov	ax,3
		push	ax
		calls	far ptr sub_a_5FCA
		add	sp,8

		push	data_b_09B4
		mov	ax,67h
		push	ax
		mov	ax,9Eh
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6

		push	ds
		mov	ax,35Ah
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		mov	ax,5Ah
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		push	ds
		mov	ax,36Ch
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		mov	ax,28h
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8

		push	ds
		mov	ax,36Eh
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		mov	ax,10Eh
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8
		retn
sub_a_0BEE	endp


; 0C5D: INT 09h service
			                        ;* No entry point to code
		push	ax
		push	bx
		push	cx
		push	dx
		push	es
		push	ds
		push	si
		push	di
		push	bp
		mov	bp,seg seg_b
		mov	ds,bp
		mov	bp,sp
		sub	sp,4
		in	al,60h			; port 60h, keybd scan or sw1
		mov	[bp-2],al
		in	al,61h			; port 61h, 8255 port B, read
		mov	[bp-1],al
		mov	al,[bp-1]
;*		or	al,80h
		db	 80h,0C8h, 80h		;  Fixup - byte match
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,[bp-1]
		out	61h,al			; port 61h, 8255 B - spkr, etc
		cmp	byte ptr [bp-2],81h
		jne	loc_a_0C93		; Jump if not equal
		mov	data_b_09D4,1
loc_a_0C93:
		mov	word ptr [bp-4],0
		jmp	loc_a_0D37
loc_a_0C9B:
		mov	ax,[bp-4]
		inc	ax
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		cmp	data_b_00AA[bx],0
		je	loc_a_0CB0		; Jump if equal
		jmp	loc_a_0D34
loc_a_0CB0:
		mov	ax,[bp-4]
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	si,ax
		add	si,offset data_b_009E
		mov	ax,[bp-4]
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	di,ax
		add	di,offset data_b_09C8
		mov	al,[bp-2]
		mov	ah,0
		cmp	ax,[si]
		jne	loc_a_0CD9		; Jump if not equal
		mov	word ptr [di],0FFFEh
loc_a_0CD9:
		mov	al,[bp-2]
		mov	ah,0
		mov	dx,[si]
		add	dx,80h
		cmp	ax,dx
		jne	loc_a_0CEC		; Jump if not equal
		mov	word ptr [di],0
loc_a_0CEC:
		mov	al,[bp-2]
		mov	ah,0
		cmp	ax,[si+2]
		jne	loc_a_0CFB		; Jump if not equal
		mov	word ptr [di+2],2
loc_a_0CFB:
		mov	al,[bp-2]
		mov	ah,0
		mov	dx,[si+2]
		add	dx,80h
		cmp	ax,dx
		jne	loc_a_0D10		; Jump if not equal
		mov	word ptr [di+2],0
loc_a_0D10:
		mov	al,[bp-2]
		mov	ah,0
		cmp	ax,[si+4]
		jne	loc_a_0D1F		; Jump if not equal
		mov	word ptr [di+4],1
loc_a_0D1F:
		mov	al,[bp-2]
		mov	ah,0
		mov	dx,[si+4]
		add	dx,80h
		cmp	ax,dx
		jne	loc_a_0D34		; Jump if not equal
		mov	word ptr [di+4],0
loc_a_0D34:
		inc	word ptr [bp-4]
loc_a_0D37:
		cmp	word ptr [bp-4],2
		jge	loc_a_0D40		; Jump if > or =
		jmp	loc_a_0C9B
loc_a_0D40:
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		pop	es
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; input player from Joystick

sub_a_0D50	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,201h
		xor	si,si			; Zero register
		mov	dx,di
		in	al,dx			; port 201h, start game 1-shots
;*		test	al,10h
		db	0F6h,0C0h, 10h		;  Fixup - byte match
		jnz	loc_a_0D67		; Jump if not zero
		mov	ax,1
		jmp	short loc_a_0D69
loc_a_0D67:
		xor	ax,ax			; Zero register
loc_a_0D69:
		push	ax
		mov	ax,[bp+8]
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CC[bx],ax
		mov	al,0FFh
		mov	dx,di
		out	dx,al			; port 201h, start game 1-shots
loc_a_0D7E:
		mov	dx,di
		in	al,dx			; port 201h, start game 1-shots
;*		test	al,1
		db	0F6h,0C0h, 01h		;  Fixup - byte match
		jnz	loc_a_0D8F		; Jump if not zero
		cmp	si,data_b_0A42
		jge	loc_a_0D8F		; Jump if > or =
		inc	si
		jmp	short loc_a_0D7E
loc_a_0D8F:
		xor	si,si			; Zero register
loc_a_0D91:
		mov	dx,di
		in	al,dx			; port 201h, start game 1-shots
;*		test	al,1
		db	0F6h,0C0h, 01h		;  Fixup - byte match
		jz	loc_a_0DA2		; Jump if zero
		cmp	si,data_b_0A42
		jge	loc_a_0DA2		; Jump if > or =
		inc	si
		jmp	short loc_a_0D91
loc_a_0DA2:
		mov	ax,data_b_0A44
		sar	ax,1			; Shift w/sign fill
		cmp	ax,si
		jge	loc_a_0DB0		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_0DB2
loc_a_0DB0:
		xor	ax,ax			; Zero register
loc_a_0DB2:
		shl	ax,1			; Shift w/zeros fill
		push	ax
		mov	ax,[bp+8]
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CA[bx],ax
		cmp	si,data_b_0A42
		jge	loc_a_0DCF		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_0DD1
loc_a_0DCF:
		xor	ax,ax			; Zero register
loc_a_0DD1:
		neg	ax
		shl	ax,1			; Shift w/zeros fill
		push	ax
		mov	ax,[bp+8]
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09C8[bx],ax
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0D50	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input player AX from keyboard or mouse

sub_a_0DE9	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,10h
		mov	di,[bp+8]
		mov	word ptr [bp-10h],3
		lea	ax,[bp-10h]		; Load effective addr
		push	ax
		lea	ax,[bp-10h]		; Load effective addr
		push	ax
		mov	ax,33h
		push	ax
		call	sub_a_4230		; Call INT xx function
		add	sp,6
		mov	ax,[bp-0Eh]
		and	ax,1
		push	ax
		mov	ax,di
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CC[bx],ax
		mov	word ptr [bp-10h],0Bh
		lea	ax,[bp-10h]		; Load effective addr
		push	ax
		lea	ax,[bp-10h]		; Load effective addr
		push	ax
		mov	ax,33h
		push	ax
		call	sub_a_4230		; Call INT xx function
		add	sp,6
		mov	si,[bp-0Ch]
		or	si,si			; Zero ?
		jle	loc_a_0E43		; Jump if < or =
		mov	ax,1
		jmp	short loc_a_0E45
loc_a_0E43:
		xor	ax,ax			; Zero register
loc_a_0E45:
		shl	ax,1			; Shift w/zeros fill
		push	ax
		mov	ax,di
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CA[bx],ax
		or	si,si			; Zero ?
		jge	loc_a_0E5F		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_0E61
loc_a_0E5F:
		xor	ax,ax			; Zero register
loc_a_0E61:
		neg	ax
		shl	ax,1			; Shift w/zeros fill
		push	ax
		mov	ax,di
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09C8[bx],ax
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0DE9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0E7A	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,4
		xor	si,si			; Zero register
		jmp	loc_a_0FF8
loc_a_0E87:
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		cmp	data_b_09CC[bx],0
		je	loc_a_0EAC		; Jump if equal
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
;*		cmp	data_b_09E8[bx],0FFFFh
		db	 83h,0BFh,0E8h, 09h,0FFh	;  Fixup - byte match
		jnz	loc_a_0EAC		; Jump if not zero
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E8[bx],0
loc_a_0EAC:
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	di,data_b_09C8[bx]
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	di,data_b_09CA[bx]
		mov	[bp-4],di
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		add	di,data_b_098C[bx]
		mov	ax,si
		mov	dx,9Bh
		mul	dx			; dx:ax = reg * ax
		add	ax,3
		mov	[bp-2],ax
		cmp	word ptr [bp-4],0
		jle	loc_a_0EFB		; Jump if < or =
		add	ax,77h
		cmp	ax,di
		jg	loc_a_0F00		; Jump if >
		mov	ax,[bp-2]
		add	ax,77h
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_098C[bx],ax
		jmp	short loc_a_0F15
loc_a_0EFB:
		cmp	di,[bp-2]
		jle	loc_a_0F0A		; Jump if < or =
loc_a_0F00:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_098C[bx],di
		jmp	short loc_a_0F15
loc_a_0F0A:
		mov	ax,[bp-2]
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_098C[bx],ax
loc_a_0F15:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
;*		cmp	data_b_09E8[bx],0FFFEh
		db	 83h,0BFh,0E8h, 09h,0FEh	;  Fixup - byte match
		jnz	loc_a_0F3E		; Jump if not zero
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E4[bx],0ADh
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09BE[bx],0
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E8[bx],0FFFFh
loc_a_0F3E:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
;*		cmp	data_b_09E8[bx],0FFFFh
		db	 83h,0BFh,0E8h, 09h,0FFh	;  Fixup - byte match
		jnz	loc_a_0F95		; Jump if not zero
		cmp	word ptr [bp-4],0
		je	loc_a_0F89		; Jump if equal
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0990[bx]
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		sub	ax,data_b_098C[bx]
		or	ax,ax			; Zero ?
		jge	loc_a_0F65		; Jump if > or =
		neg	ax
loc_a_0F65:
		cmp	ax,4
		jg	loc_a_0F6D		; Jump if >
		jmp	loc_a_0FF7
loc_a_0F6D:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
;*		xor	data_b_09BE[bx],1
		db	 81h,0B7h,0BEh, 09h, 01h, 00h	;  Fixup - byte match
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098C[bx]
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_0990[bx],ax
		jmp	short loc_a_0FF7
loc_a_0F89:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09BE[bx],0
		jmp	short loc_a_0FF7
loc_a_0F95:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_09E8[bx],12h
		jle	loc_a_0FA5		; Jump if < or =
		mov	ax,1
		jmp	short loc_a_0FA7
loc_a_0FA5:
		xor	ax,ax			; Zero register
loc_a_0FA7:
		add	ax,2
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09BE[bx],ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_09E8[bx],13h
		jne	loc_a_0FC6		; Jump if not equal
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		sub	data_b_09E4[bx],4
loc_a_0FC6:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_09E8[bx]
		inc	data_b_09E8[bx]
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0264[bx]
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		add	data_b_09E4[bx],ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_09E8[bx],25h
		jle	loc_a_0FF7		; Jump if < or =
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E8[bx],0FFFEh
loc_a_0FF7:
		inc	si
loc_a_0FF8:
		cmp	si,2
		jge	loc_a_1000		; Jump if > or =
		jmp	loc_a_0E87
loc_a_1000:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0E7A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1006	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		mov	di,data_b_0988
		mov	si,data_b_09B6
		cmp	di,13Fh
		jle	loc_a_101E		; Jump if < or =
		mov	di,13Fh
loc_a_101E:
		cmp	di,0FEC1h
		jge	loc_a_1027		; Jump if > or =
		mov	di,0FEC1h
loc_a_1027:
		cmp	si,13Fh
		jle	loc_a_1030		; Jump if < or =
		mov	si,13Fh
loc_a_1030:
		cmp	si,0FEC1h
		jge	loc_a_1039		; Jump if > or =
		mov	si,0FEC1h
loc_a_1039:
		mov	ax,data_b_09C6
		mov	data_b_0A3A,ax
		mov	ax,data_b_098A
		mov	data_b_09C4,ax
		add	data_b_0A40,di
		add	data_b_09EC,si
		cmp	data_b_0A40,140h
		jge	loc_a_1083		; Jump if > or =
		mov	data_b_0A40,140h
		mov	ax,di
		neg	ax
		mov	di,ax
		mov	ax,di
		mov	cx,4
		sar	ax,cl			; Shift w/sign fill
		sub	di,ax
		mov	ax,si
		sar	ax,cl			; Shift w/sign fill
		sub	si,ax
		cmp	data_b_09D6,1
		jne	loc_a_1083		; Jump if not equal
		mov	data_b_09D6,2
		mov	data_b_09DC,0
loc_a_1083:
		cmp	data_b_0A40,46C0h
		jle	loc_a_10B9		; Jump if < or =
		mov	data_b_0A40,46C0h
		mov	ax,di
		neg	ax
		mov	di,ax
		mov	ax,di
		mov	cx,4
		sar	ax,cl			; Shift w/sign fill
		sub	di,ax
		mov	ax,si
		sar	ax,cl			; Shift w/sign fill
		sub	si,ax
		cmp	data_b_09D6,0
		jne	loc_a_10B9		; Jump if not equal
		mov	data_b_09D6,2
		mov	data_b_09DC,0
loc_a_10B9:
		cmp	data_b_09EC,340h
		jge	loc_a_10DC		; Jump if > or =
		mov	data_b_09EC,340h
		mov	ax,si
		neg	ax
		mov	si,ax
		mov	ax,di
		mov	cx,4
		sar	ax,cl			; Shift w/sign fill
		sub	di,ax
		mov	ax,si
		sar	ax,cl			; Shift w/sign fill
		sub	si,ax
loc_a_10DC:
		cmp	data_b_09EC,2C80h
		jle	loc_a_10F7		; Jump if < or =
		mov	data_b_09EC,2C80h
		mov	ax,si
		neg	ax
		mov	si,ax
		mov	word ptr [bp-2],0
		jmp	short loc_a_10FC
loc_a_10F7:
		mov	word ptr [bp-2],1
loc_a_10FC:
		inc	si
		mov	ax,data_b_0A40
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		mov	data_b_09C6,ax
		mov	ax,data_b_09EC
		sar	ax,cl			; Shift w/sign fill
		mov	data_b_098A,ax
		mov	data_b_0988,di
		mov	data_b_09B6,si
		mov	ax,[bp-2]
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_1006	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1121	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,6
		xor	si,si			; Zero register
		jmp	loc_a_125C
loc_a_112E:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	di,data_b_09C6
		mov	ax,data_b_098C[bx]
		sub	di,ax
		mov	ax,si
		mov	dx,7
		mul	dx			; dx:ax = reg * ax
		sub	di,ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098A
		mov	dx,data_b_09E4[bx]
		sub	ax,dx
		sar	ax,1			; Shift w/sign fill
		mov	[bp-6],ax
		mov	ax,di
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mul	di			; dx:ax = reg * ax
		push	ax
		mov	ax,[bp-6]
		mul	word ptr [bp-6]		; dx:ax = data * ax
		pop	dx
		add	dx,ax
		mov	[bp-4],dx
		cmp	dx,6Eh
		jl	loc_a_1174		; Jump if <
		jmp	loc_a_1243
loc_a_1174:
		mov	ax,data_b_09E2
		and	ax,0Fh
		mov	dx,8
		sub	dx,ax
		mov	[bp-2],dx
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
;*		cmp	data_b_09E8[bx],0FFFFh
		db	 83h,0BFh,0E8h, 09h,0FFh	;  Fixup - byte match
		jle	loc_a_11BA		; Jump if < or =
		mov	ax,data_b_09B6
		or	ax,ax			; Zero ?
		jge	loc_a_1196		; Jump if > or =
		neg	ax
loc_a_1196:
		neg	ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_09E8[bx]
		shl	bx,1			; Shift w/zeros fill
		mov	dx,data_b_0264[bx]
		mov	bx,offset data_b_0003
		mov	cx,data_b_09BC
		shl	bx,cl			; Shift w/zeros fill
		mov	cx,bx
		shl	dx,cl			; Shift w/zeros fill
		add	ax,dx
		mov	data_b_09B6,ax
		jmp	short loc_a_11C8
loc_a_11BA:
		mov	ax,data_b_09B6
		or	ax,ax			; Zero ?
		jge	loc_a_11C3		; Jump if > or =
		neg	ax
loc_a_11C3:
		neg	ax
		mov	data_b_09B6,ax
loc_a_11C8:
		mov	ax,[bp-2]
		add	data_b_09B6,ax
		mov	ax,di
		or	ax,ax			; Zero ?
		jge	loc_a_11D7		; Jump if > or =
		neg	ax
loc_a_11D7:
		mul	di			; dx:ax = reg * ax
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_09CA[bx]
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		add	ax,data_b_09C8[bx]
		mov	cx,data_b_09BC
		add	cx,4
		shl	ax,cl			; Shift w/zeros fill
		pop	dx
		add	dx,ax
		add	dx,[bp-2]
		add	data_b_0988,dx
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_09DE[bx],0
		jne	loc_a_125B		; Jump if not equal
		mov	data_b_0A4D,0C8h
		mov	data_b_0A4B,0
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09DE[bx],1
		mov	ax,data_b_09D6
		cmp	ax,si
		je	loc_a_123D		; Jump if equal
		mov	data_b_09D6,si
		mov	data_b_09DC,0
		jmp	short loc_a_125B
loc_a_123D:
		inc	data_b_09DC
		jmp	short loc_a_125B
loc_a_1243:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_09DE[bx],0
		je	loc_a_125B		; Jump if equal
		xor	ax,ax			; Zero register
		mov	data_b_09BC,ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09DE[bx],ax
loc_a_125B:
		inc	si
loc_a_125C:
		cmp	si,2
		jge	loc_a_1264		; Jump if > or =
		jmp	loc_a_112E
loc_a_1264:
		mov	si,1
		cmp	data_b_098A,5Bh
		jle	loc_a_12BB		; Jump if < or =
		cmp	data_b_0A3A,80h
		jge	loc_a_1295		; Jump if > or =
		cmp	data_b_09C6,7Fh
		jle	loc_a_1295		; Jump if < or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1286		; Jump if > or =
		neg	ax
loc_a_1286:
		neg	ax
		sar	ax,1			; Shift w/sign fill
		mov	data_b_0988,ax
		mov	data_b_0A40,1FC0h
		jmp	short loc_a_12B9
loc_a_1295:
		cmp	data_b_0A3A,9Fh
		jle	loc_a_12BB		; Jump if < or =
		cmp	data_b_09C6,0A0h
		jge	loc_a_12BB		; Jump if > or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_12AE		; Jump if > or =
		neg	ax
loc_a_12AE:
		sar	ax,1			; Shift w/sign fill
		mov	data_b_0988,ax
		mov	data_b_0A40,2800h
loc_a_12B9:
		xor	si,si			; Zero register
loc_a_12BB:
		or	si,si			; Zero ?
		jnz	loc_a_12C2		; Jump if not zero
		jmp	loc_a_13C4
loc_a_12C2:
		cmp	data_b_098A,51h
		jg	loc_a_12CC		; Jump if >
		jmp	loc_a_13C4
loc_a_12CC:
		cmp	data_b_09C6,7Fh
		jg	loc_a_12D6		; Jump if >
		jmp	loc_a_13C4
loc_a_12D6:
		cmp	data_b_09C6,0A0h
		jl	loc_a_12E1		; Jump if <
		jmp	loc_a_13C4
loc_a_12E1:
		cmp	data_b_098A,5Bh
		jle	loc_a_1310		; Jump if < or =
		cmp	data_b_09C6,94h
		jge	loc_a_1301		; Jump if > or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_12F9		; Jump if > or =
		neg	ax
loc_a_12F9:
		neg	ax
		mov	data_b_0988,ax
		jmp	loc_a_13C4
loc_a_1301:
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_130A		; Jump if > or =
		neg	ax
loc_a_130A:
		mov	data_b_0988,ax
		jmp	loc_a_13C4
loc_a_1310:
		cmp	data_b_09C6,93h
		jle	loc_a_1330		; Jump if < or =
		mov	bx,offset data_b_005A+1
		sub	bx,data_b_098A
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0250[bx]
		mov	dx,0A1h
		sub	dx,data_b_09C6
		cmp	ax,dx
		jle	loc_a_1357		; Jump if < or =
loc_a_1330:
		cmp	data_b_09C6,94h
		jl	loc_a_133B		; Jump if <
		jmp	loc_a_13C4
loc_a_133B:
		mov	bx,offset data_b_005A+1
		sub	bx,data_b_098A
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0250[bx]
		mov	dx,data_b_09C6
		add	dx,0FF7Bh
		cmp	ax,dx
		jle	loc_a_1357		; Jump if < or =
		jmpn	loc_a_13C4
loc_a_1357:
		cmp	data_b_09B6,0
		jle	loc_a_1398		; Jump if < or =
		mov	di,data_b_09C6
		add	di,0FF6Fh
;*		cmp	di,0FFFBh
		db	 83h,0FFh,0FBh		;  Fixup - byte match
		jge	loc_a_1379		; Jump if > or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1374		; Jump if > or =
		neg	ax
loc_a_1374:
		neg	ax
		mov	data_b_0988,ax
loc_a_1379:
		cmp	di,5
		jle	loc_a_138A		; Jump if < or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1387		; Jump if > or =
		neg	ax
loc_a_1387:
		mov	data_b_0988,ax
loc_a_138A:
		mov	ax,data_b_09B6
		or	ax,ax			; Zero ?
		jge	loc_a_1393		; Jump if > or =
		neg	ax
loc_a_1393:
		neg	ax
		mov	data_b_09B6,ax
loc_a_1398:
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_13A1		; Jump if > or =
		neg	ax
loc_a_13A1:
		cmp	ax,20h
		jle	loc_a_13AE		; Jump if < or =
		mov	ax,data_b_0988
		sar	ax,1			; Shift w/sign fill
		mov	data_b_0988,ax
loc_a_13AE:
		mov	ax,data_b_09B6
		or	ax,ax			; Zero ?
		jge	loc_a_13B7		; Jump if > or =
		neg	ax
loc_a_13B7:
		cmp	ax,20h
		jle	loc_a_13C4		; Jump if < or =
		mov	ax,data_b_09B6
		sar	ax,1			; Shift w/sign fill
		mov	data_b_09B6,ax
loc_a_13C4:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_1121	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_13CA	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	si,[bp+8]
;*		add	si,0FFFCh
		db	 83h,0C6h,0FCh		;  Fixup - byte match
		mov	di,[bp+0Ah]
;*		add	di,0FFFBh
		db	 83h,0C7h,0FBh		;  Fixup - byte match
		cmp	si,4
		jge	loc_a_13E3		; Jump if > or =
		mov	si,4
loc_a_13E3:
		cmp	si,110h
		jle	loc_a_13EC		; Jump if < or =
		mov	si,offset data_b_0110
loc_a_13EC:
		cmp	di,0Bh
		jge	loc_a_13F4		; Jump if > or =
		mov	di,0Bh
loc_a_13F4:
		cmp	di,0A7h
		jle	loc_a_13FD		; Jump if < or =
		mov	di,0A7h
loc_a_13FD:
		cmp	word ptr [bp+8],8
		jge	loc_a_1410		; Jump if > or =
		push	data_b_09DA
		push	di
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		mov	sp,bp
loc_a_1410:
		cmp	word ptr [bp+8],117h
		jle	loc_a_1425		; Jump if < or =
		push	data_b_0A38
		push	di
		mov	ax,138h
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		mov	sp,bp
loc_a_1425:
		cmp	word ptr [bp+0Ah],11h
		jge	loc_a_1439		; Jump if > or =
		push	data_b_09BA
		mov	ax,0Bh
		push	ax
		push	si
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		mov	sp,bp
loc_a_1439:
		cmp	word ptr [bp+0Ah],0ABh
		jle	loc_a_144E		; Jump if < or =
		push	data_b_09BA
		mov	ax,0C7h
		push	ax
		push	si
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		mov	sp,bp
loc_a_144E:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_13CA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1452	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		mov	si,data_b_098C
		mov	di,data_b_098E
		mov	ax,data_b_09C6
		sub	ax,si
		or	ax,ax			; Zero ?
		jge	loc_a_146C		; Jump if > or =
		neg	ax
loc_a_146C:
		cmp	ax,29h
		jge	loc_a_1483		; Jump if > or =
		mov	ax,data_b_098A
		sub	ax,data_b_09E4
		or	ax,ax			; Zero ?
		jge	loc_a_147E		; Jump if > or =
		neg	ax
loc_a_147E:
		cmp	ax,21h
		jl	loc_a_14AD		; Jump if <
loc_a_1483:
		mov	ax,data_b_09C6
		sub	ax,di
		or	ax,ax			; Zero ?
		jge	loc_a_148E		; Jump if > or =
		neg	ax
loc_a_148E:
		cmp	ax,29h
		jge	loc_a_14A5		; Jump if > or =
		mov	ax,data_b_098A
		sub	ax,data_b_09E6
		or	ax,ax			; Zero ?
		jge	loc_a_14A0		; Jump if > or =
		neg	ax
loc_a_14A0:
		cmp	ax,21h
		jl	loc_a_14AD		; Jump if <
loc_a_14A5:
		cmp	data_b_09C4,0ABh
		jle	loc_a_14B2		; Jump if < or =
loc_a_14AD:
		mov	ax,1
		jmp	short loc_a_14B4
loc_a_14B2:
		xor	ax,ax			; Zero register
loc_a_14B4:
		mov	[bp-2],ax
		call	sub_a_22BF		; Wait for VSYNC
		cmp	data_b_0A0E,0
		je	loc_a_14E9		; Jump if equal
		mov	bx,data_b_0A3C
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0A3A
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0966[bx]
		push	data_b_09C4
		push	data_b_0A3A
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		jmp	short loc_a_152C
loc_a_14E9:
		cmp	word ptr [bp-2],0
		je	loc_a_152C		; Jump if equal
		mov	bx,data_b_0A3C
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0A3A
		add	ax,0FFFCh
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0A18[bx]
		mov	ax,data_b_09C4
		add	ax,0FFFBh
		push	ax
		mov	ax,data_b_0A3A
		add	ax,0FFFCh
		push	ax
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		push	data_b_09C4
		push	data_b_0A3A
		call	sub_a_13CA
		add	sp,4
loc_a_152C:
		mov	ax,[bp-2]
		mov	data_b_0A0E,ax
		mov	ax,data_b_0986
		dec	data_b_0986
		or	ax,ax			; Zero ?
		jnz	loc_a_1573		; Jump if not zero
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1546		; Jump if > or =
		neg	ax
loc_a_1546:
		mov	dx,data_b_09B6
		or	dx,dx			; Zero ?
		jge	loc_a_1550		; Jump if > or =
		neg	dx
loc_a_1550:
		add	ax,dx
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		mov	dx,0Ch
		sub	dx,ax
		or	dx,dx			; Zero ?
		jge	loc_a_1562		; Jump if > or =
		neg	dx
loc_a_1562:
		mov	data_b_0986,dx
		inc	data_b_0A3C
		mov	ax,data_b_0A3C
		and	ax,3
		mov	data_b_0A3C,ax
loc_a_1573:
		mov	bx,data_b_09BE
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,si
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0994[bx]
		push	data_b_09E4
		push	si
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		mov	bx,data_b_09C0
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,di
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_09EE[bx]
		push	data_b_09E6
		push	di
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		cmp	data_b_0A0E,0
		je	loc_a_15E6		; Jump if equal
		mov	bx,data_b_0A3C
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_09C6
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0966[bx]
		push	data_b_098A
		push	data_b_09C6
		call	sub_a_234E		; Display image XOR: X, Y, image(with, height, data)
		add	sp,6
		jmp	short loc_a_1615
loc_a_15E6:
		mov	bx,data_b_0A3C
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_09C6
		add	ax,0FFFCh
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0A18[bx]
		mov	ax,data_b_098A
		add	ax,0FFFBh
		push	ax
		mov	ax,data_b_09C6
		add	ax,0FFFCh
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
loc_a_1615:
		push	data_b_098A
		push	data_b_09C6
		call	sub_a_13CA
		add	sp,4
		cmp	si,6
		jge	loc_a_163C		; Jump if > or =
		push	data_b_09DA
		mov	ax,data_b_09E4
		add	ax,0FFFEh
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
loc_a_163C:
		cmp	di,113h
		jle	loc_a_1657		; Jump if < or =
		push	data_b_0A38
		mov	ax,data_b_09E6
		add	ax,0FFFEh
		push	ax
		mov	ax,138h
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
loc_a_1657:
		push	data_b_09B4
		mov	ax,67h
		push	ax
		mov	ax,9Eh
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_1452	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_166F	proc	near
		call	sub_a_22BF		; Wait for VSYNC
		cmp	data_b_0A0E,0
		je	loc_a_16A1		; Jump if equal
		mov	bx,data_b_0A3C
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_09C6
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0966[bx]
		push	data_b_098A
		push	data_b_09C6
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
		jmp	short loc_a_16D0
loc_a_16A1:
		mov	bx,data_b_0A3C
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_09C6
		add	ax,0FFFCh
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0A18[bx]
		mov	ax,data_b_098A
		add	ax,0FFFBh
		push	ax
		mov	ax,data_b_09C6
		add	ax,0FFFCh
		push	ax
		call	sub_a_23E2		; Clear box by image: X, Y, image(with, height, data)
		add	sp,6
loc_a_16D0:
		mov	bx,data_b_09BE
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098C
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_0994[bx]
		push	data_b_09E4
		push	data_b_098C
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		mov	bx,data_b_09C0
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098E
		and	ax,3
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		push	data_b_09EE[bx]
		push	data_b_09E6
		push	data_b_098E
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		mov	ax,0C7h
		push	ax
		mov	ax,138h
		push	ax
		mov	ax,0Bh
		push	ax
		mov	ax,3
		push	ax
		calls	far ptr sub_a_5FCA
		add	sp,8
		push	data_b_09B4
		mov	ax,67h
		push	ax
		mov	ax,9Eh
		push	ax
		call	sub_a_22D0		; Display image: X, Y, image(with, height, data)
		add	sp,6
		retn
sub_a_166F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1747	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ah
		cmp	data_b_09DC,2
		jle	loc_a_175F		; Jump if < or =
		mov	si,1
		sub	si,data_b_09D6
		jmp	short loc_a_176E
loc_a_175F:
		cmp	data_b_09C6,96h
		jge	loc_a_176C		; Jump if > or =
		mov	si,1
		jmp	short loc_a_176E
loc_a_176C:
		xor	si,si			; Zero register
loc_a_176E:
		call	sub_a_1452
		mov	ax,data_b_09B6
		or	ax,ax			; Zero ?
		jge	loc_a_177A		; Jump if > or =
		neg	ax
loc_a_177A:
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mov	[bp-6],ax
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_178C		; Jump if > or =
		neg	ax
loc_a_178C:
		mov	di,ax
		sar	di,1			; Shift w/sign fill
		sar	di,1			; Shift w/sign fill
		sar	di,1			; Shift w/sign fill
		mov	word ptr [bp-8],14h
loc_a_1799:
		xor	ax,ax			; Zero register
		mov	data_b_09D2,ax
		mov	data_b_09CC,ax
		call	sub_a_4B57		; Disable output to speaker
		call	sub_a_0E7A
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_17B0		; Jump if > or =
		neg	ax
loc_a_17B0:
		cmp	ax,di
		jle	loc_a_17C8		; Jump if < or =
		cmp	data_b_0988,0
		jge	loc_a_17C4		; Jump if > or =
		mov	ax,di
		neg	ax
		mov	data_b_0988,ax
		jmp	short loc_a_17C8
loc_a_17C4:
		mov	data_b_0988,di
loc_a_17C8:
		mov	ax,data_b_09B6
		or	ax,ax			; Zero ?
		jge	loc_a_17D1		; Jump if > or =
		neg	ax
loc_a_17D1:
		cmp	ax,[bp-6]
		jle	loc_a_17ED		; Jump if < or =
		cmp	data_b_09B6,0
		jge	loc_a_17E7		; Jump if > or =
		mov	ax,[bp-6]
		neg	ax
		mov	data_b_09B6,ax
		jmp	short loc_a_17ED
loc_a_17E7:
		mov	ax,[bp-6]
		mov	data_b_09B6,ax
loc_a_17ED:
		call	sub_a_1121
		cmp	data_b_024E,0
		je	loc_a_1811		; Jump if equal
		cmp	si,data_b_0A14
		jne	loc_a_1808		; Jump if not equal
		mov	ax,1388h
		push	ax			; PARAMETER_1
		call	sub_a_4B2B		; Enable output to speaker, set tone
		inc	sp
		inc	sp
		jmp	short loc_a_1811
loc_a_1808:
		mov	ax,64h
		push	ax			; PARAMETER_1
		call	sub_a_4B2B		; Enable output to speaker, set tone
		inc	sp
		inc	sp
loc_a_1811:
		call	sub_a_1006
		call	sub_a_1452
		mov	ax,[bp-8]
		dec	word ptr [bp-8]
		or	ax,ax			; Zero ?
		jle	loc_a_1824		; Jump if < or =
		jmp	loc_a_1799
loc_a_1824:
;*		cmp	data_b_09E8,0FFFFh
		db	 83h, 3Eh,0E8h, 09h,0FFh	;  Fixup - byte match
		jz	loc_a_182E		; Jump if zero
		jmp	loc_a_1799
loc_a_182E:
;*		cmp	data_b_09EA,0FFFFh
		db	 83h, 3Eh,0EAh, 09h,0FFh	;  Fixup - byte match
		jz	loc_a_1838		; Jump if zero
		jmp	loc_a_1799
loc_a_1838:
		call	sub_a_4B57		; Disable output to speaker
		mov	ax,si
		mov	dx,0E6h
		mul	dx			; dx:ax = reg * ax
		add	ax,28h
		mov	[bp-0Ah],ax
		cmp	si,data_b_0A14
		jne	loc_a_18BF		; Jump if not equal
		mov	ax,7
		push	ax			; PARAMETER_4
		mov	ax,[bp-0Ah]
		add	ax,0Fh
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	word ptr [bp-0Ah]	; PARAMETER_1
		calls	far ptr sub_a_6A19
		add	sp,8
		mov	ax,0Ah
		push	ax			; PARAMETER_3
		lea	ax,[bp-4]		; Load effective addr
		push	ax			; PARAMETER_2
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_0A10[bx]
		mov	ax,data_b_0A10[bx]
		push	ax			; PARAMETER_1
		call	sub_a_4439
		add	sp,6
		mov	dx,ds
		push	dx
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	word ptr [bp-0Ah]	; PARAMETER_1
		calls	far ptr sub_a_6C42
		add	sp,8
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_0A10[bx],0Eh
		jle	loc_a_190D		; Jump if < or =
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_0A10[bx]
		mov	bx,offset data_b_0001
		sub	bx,si
		shl	bx,1			; Shift w/zeros fill
		sub	ax,data_b_0A10[bx]
		cmp	ax,1
		jle	loc_a_190D		; Jump if < or =
		mov	data_b_09D4,1
		jmp	short loc_a_190D
loc_a_18BF:
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6B04
		inc	sp
		inc	sp
		mov	ax,1
		push	ax
		mov	ax,3
		push	ax
		mov	ax,1
		sub	ax,si
		mov	dx,0E6h
		mul	dx			; dx:ax = reg * ax
		add	ax,23h
		push	ax
		calls	far ptr sub_a_6129
		add	sp,6
		mov	ax,0Fh
		push	ax			; PARAMETER_1
		calls	far ptr sub_a_6B04
		inc	sp
		inc	sp
		mov	ax,1
		push	ax
		mov	ax,3
		push	ax
		mov	ax,[bp-0Ah]
		add	ax,0FFFBh
		push	ax
		calls	far ptr sub_a_6129
		add	sp,6
		mov	data_b_0A14,si
loc_a_190D:
		mov	ax,64h
		push	ax
		call	sub_a_3F7A
		inc	sp
		inc	sp
		call	sub_a_166F
		mov	ax,si
		mov	dx,0A5h
		mul	dx			; dx:ax = reg * ax
		add	ax,40h
		mov	data_b_0A3A,ax
		mov	data_b_09C6,ax
		mov	cx,6
		shl	ax,cl			; Shift w/zeros fill
		mov	data_b_0A40,ax
		mov	ax,87h
		mov	data_b_09C4,ax
		mov	data_b_098A,ax
		shl	ax,cl			; Shift w/zeros fill
		mov	data_b_09EC,ax
		xor	ax,ax			; Zero register
		mov	data_b_09E0,ax
		mov	data_b_09DE,ax
		mov	data_b_09DC,ax
		mov	data_b_09B6,ax
		mov	data_b_0988,ax
		mov	data_b_0A0E,ax
		mov	data_b_0A3C,ax
		mov	data_b_0986,cx
		mov	ax,1
		mov	data_b_09BC,ax
		mov	data_b_0A4B,ax
		mov	data_b_09D6,2
		mov	ax,data_b_09E2
		or	ax,ax			; Zero ?
		jge	loc_a_1972		; Jump if > or =
		neg	ax
loc_a_1972:
		mov	bx,offset data_b_0004+1	; ('u')
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_0A3E,dx
		mov	bx,data_b_0A14
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_0A10[bx],0Eh
		jne	loc_a_198F		; Jump if not equal
		mov	data_b_0A3E,5
loc_a_198F:
		mov	data_b_09B8,0
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_1747	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_199B	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	ax,[bp+8]
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	si,ax
		add	si,offset data_b_09C8
		mov	bx,[bp+8]
		shl	bx,1			; Shift w/zeros fill
		mov	di,data_b_098C[bx]
		mov	ax,di
		sub	ax,[bp+0Ah]
		or	ax,ax			; Zero ?
		jge	loc_a_19C2		; Jump if > or =
		neg	ax
loc_a_19C2:
		cmp	ax,[bp+0Ch]
		jge	loc_a_19D5		; Jump if > or =
		mov	word ptr [si],0
		mov	word ptr [si+2],0
		mov	ax,1
		jmp	short loc_a_19F0
loc_a_19D5:
		cmp	di,[bp+0Ah]
		jge	loc_a_19E5		; Jump if > or =
		mov	word ptr [si],0
		mov	word ptr [si+2],2
		jmp	short loc_a_19EE
loc_a_19E5:
		mov	word ptr [si],0FFFEh
		mov	word ptr [si+2],0
loc_a_19EE:
		xor	ax,ax			; Zero register
loc_a_19F0:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_199B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_19F4	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,6
		mov	data_b_09CC,0
		mov	ax,data_b_098A
		cmp	ax,data_b_0A4D
		jge	loc_a_1A0E		; Jump if > or =
		mov	data_b_0A4D,ax
loc_a_1A0E:
		mov	ax,data_b_09E2
		mov	bx,0Ah
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	ax,5
		sub	ax,dx
		mov	[bp-2],ax
		cmp	data_b_0A4B,0
		jne	loc_a_1A29		; Jump if not equal
		jmp	loc_a_1B3E
loc_a_1A29:
		test	data_b_0A14,1
		jz	loc_a_1A34		; Jump if zero
		jmp	loc_a_1B3E
loc_a_1A34:
		mov	ax,data_b_0A3E
		cmp	ax,5
		jbe	loc_a_1A3F		; Jump if below or =
		jmp	loc_a_1B37
loc_a_1A3F:
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_1A48[bx]	;*6 entries
data_a_1A48	dw	offset loc_a_1A54	; Data table (indexed access)
data_a_1A4A	dw	offset loc_a_1A6A
data_a_1A4C	dw	offset loc_a_1A80
data_a_1A4E	dw	offset loc_a_1A96
data_a_1A50	dw	offset loc_a_1ABB
data_a_1A52	dw	offset loc_a_1AF6

;===== Indexed Entry Point ================================================

loc_a_1A54:
		mov	ax,2
		push	ax
		mov	ax,37h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		jmp	loc_a_1B37

;===== Indexed Entry Point ================================================

loc_a_1A6A:
		mov	ax,2
		push	ax
		mov	ax,54h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		jmp	loc_a_1B37

;===== Indexed Entry Point ================================================

loc_a_1A80:
		mov	ax,2
		push	ax
		mov	ax,50h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		jmp	loc_a_1B37

;===== Indexed Entry Point ================================================

loc_a_1A96:
		cmp	data_b_09B8,0
		jne	loc_a_1AE3		; Jump if not equal
		mov	ax,2
		push	ax
		mov	ax,2Ch
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		mov	ax,si
		or	ax,ax			; Zero ?
		jnz	loc_a_1AB9		; Jump if not zero
		jmpn	loc_a_1B37
loc_a_1AB9:
		jmp	short loc_a_1ADB

;===== Indexed Entry Point ================================================

loc_a_1ABB:
		cmp	data_b_09B8,0
		jne	loc_a_1AE3		; Jump if not equal
		mov	ax,2
		push	ax
		mov	ax,5Ah
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		mov	ax,si
		or	ax,ax			; Zero ?
		jz	loc_a_1B37		; Jump if zero
loc_a_1ADB:
		mov	data_b_09B8,1
		jmp	short loc_a_1B37
loc_a_1AE3:
		mov	ax,2
		push	ax
		mov	ax,3Ah
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	short loc_a_1B34

;===== Indexed Entry Point ================================================

loc_a_1AF6:
		cmp	data_b_09B8,0
		jne	loc_a_1B1C		; Jump if not equal
		mov	ax,2
		push	ax
		mov	ax,3
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		or	ax,ax			; Zero ?
		jz	loc_a_1B18		; Jump if zero
		mov	data_b_09B8,1
loc_a_1B18:
		xor	si,si			; Zero register
		jmp	short loc_a_1B37
loc_a_1B1C:
		mov	ax,1
		push	ax
		mov	ax,data_b_09B8
		inc	data_b_09B8
		add	ax,8
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
loc_a_1B34:
		mov	si,1
loc_a_1B37:
		mov	data_b_09CC,si
		jmp	loc_a_1CE4
loc_a_1B3E:
		cmp	data_b_09B6,0
		jg	loc_a_1B48		; Jump if >
		jmp	loc_a_1CD3
loc_a_1B48:
		cmp	data_b_09C6,8Ch
		jl	loc_a_1B53		; Jump if <
		jmp	loc_a_1CD3
loc_a_1B53:
		mov	ax,data_b_09B6
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		or	ax,ax			; Zero ?
		jnz	loc_a_1B66		; Jump if not zero
		mov	word ptr [bp-6],0
		jmp	short loc_a_1B7C
loc_a_1B66:
		mov	ax,8Ch
		sub	ax,data_b_098A
		mov	bx,data_b_09B6
		mov	cx,6
		sar	bx,cl			; Shift w/sign fill
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	[bp-6],ax
loc_a_1B7C:
		cmp	word ptr [bp-6],1
		jl	loc_a_1B8E		; Jump if <
		mov	ax,data_b_0988
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		or	ax,ax			; Zero ?
		jnz	loc_a_1B94		; Jump if not zero
loc_a_1B8E:
		mov	di,data_b_09C6
		jmp	short loc_a_1BA8
loc_a_1B94:
		mov	ax,data_b_0988
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		mul	word ptr [bp-6]		; dx:ax = data * ax
		mov	di,ax
		add	di,data_b_09C6
;*		add	di,0FFFCh
		db	 83h,0C7h,0FCh		;  Fixup - byte match
loc_a_1BA8:
		mov	ax,data_b_098C
		sub	ax,data_b_09C6
		mov	[bp-4],ax
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1BBB		; Jump if > or =
		neg	ax
loc_a_1BBB:
		cmp	ax,80h
		jge	loc_a_1C18		; Jump if > or =
		cmp	data_b_0A4D,4Bh
		jge	loc_a_1C18		; Jump if > or =
		cmp	data_b_098A,9Eh
		jge	loc_a_1BD4		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_1BD6
loc_a_1BD4:
		xor	ax,ax			; Zero register
loc_a_1BD6:
		push	ax
		cmp	data_b_0988,0
		jge	loc_a_1BE3		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_1BE5
loc_a_1BE3:
		xor	ax,ax			; Zero register
loc_a_1BE5:
		pop	dx
		xor	dx,ax
		jz	loc_a_1C01		; Jump if zero
		mov	ax,3
		push	ax
		mov	ax,data_b_09C6
		add	ax,0FFF1h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	loc_a_1CE4
loc_a_1C01:
		mov	ax,3
		push	ax
		mov	ax,data_b_09C6
		add	ax,0Fh
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	loc_a_1CE4
loc_a_1C18:
		cmp	data_b_098A,82h
		jg	loc_a_1C23		; Jump if >
		jmp	loc_a_1CA6
loc_a_1C23:
		mov	ax,[bp-4]
		or	ax,ax			; Zero ?
		jge	loc_a_1C2C		; Jump if > or =
		neg	ax
loc_a_1C2C:
		cmp	ax,6
		jle	loc_a_1C62		; Jump if < or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1C3A		; Jump if > or =
		neg	ax
loc_a_1C3A:
		cmp	ax,400h
		jge	loc_a_1C62		; Jump if > or =
		mov	ax,3
		push	ax
		mov	ax,data_b_098C
		add	ax,0FFC4h
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mov	dx,data_b_09C6
		sub	dx,ax
		push	dx
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	loc_a_1CE4
loc_a_1C62:
		mov	ax,0Ah
		push	ax
		mov	ax,data_b_098C
		add	ax,0FFC4h
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mov	dx,data_b_09C6
		add	dx,[bp-2]
		add	ax,dx
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		cmp	data_b_098C,69h
		jge	loc_a_1C9F		; Jump if > or =
		cmp	data_b_09D6,0
		jne	loc_a_1C9A		; Jump if not equal
		cmp	data_b_09DC,2
		jge	loc_a_1C9F		; Jump if > or =
loc_a_1C9A:
		mov	ax,1
		jmp	short loc_a_1CA1
loc_a_1C9F:
		xor	ax,ax			; Zero register
loc_a_1CA1:
		mov	data_b_09CC,ax
		jmp	short loc_a_1CE4
loc_a_1CA6:
		cmp	di,3
		jge	loc_a_1CB2		; Jump if > or =
		mov	ax,6
		sub	ax,di
		mov	di,ax
loc_a_1CB2:
		cmp	di,7Bh
		jle	loc_a_1CBE		; Jump if < or =
		mov	ax,0F6h
		sub	ax,di
		mov	di,ax
loc_a_1CBE:
		mov	ax,3
		push	ax
		mov	ax,di
		add	ax,[bp-2]
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	short loc_a_1CE4
loc_a_1CD3:
		mov	ax,8
		push	ax
		mov	ax,38h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_199B
		add	sp,6
loc_a_1CE4:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_19F4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1CEA	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,6
		mov	data_b_09D2,0
		mov	ax,data_b_098A
		cmp	ax,data_b_0A4D
		jge	loc_a_1D04		; Jump if > or =
		mov	data_b_0A4D,ax
loc_a_1D04:
		mov	ax,data_b_09E2
		mov	bx,0Ah
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	ax,5
		sub	ax,dx
		mov	[bp-2],ax
		cmp	data_b_0A4B,0
		jne	loc_a_1D1F		; Jump if not equal
		jmp	loc_a_1E56
loc_a_1D1F:
		mov	ax,data_b_0A14
		and	ax,1
		cmp	ax,1
		je	loc_a_1D2D		; Jump if equal
		jmp	loc_a_1E56
loc_a_1D2D:
		mov	ax,data_b_0A3E
		cmp	ax,5
		jbe	loc_a_1D38		; Jump if below or =
		jmp	loc_a_1E4F
loc_a_1D38:
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_1D41[bx]	;*6 entries
data_a_1D41	dw	offset loc_a_1D4D	; Data table (indexed access)
data_a_1D43	dw	offset loc_a_1D64
data_a_1D45	dw	offset loc_a_1D7B
data_a_1D47	dw	offset loc_a_1D92
data_a_1D49	dw	offset loc_a_1DCD
data_a_1D4B	dw	offset loc_a_1E0A

;===== Indexed Entry Point ================================================

loc_a_1D4D:
		mov	ax,2
		push	ax
		mov	ax,0E8h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		jmp	loc_a_1E4F

;===== Indexed Entry Point ================================================

loc_a_1D64:
		mov	ax,2
		push	ax
		mov	ax,0CAh
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		jmp	loc_a_1E4F

;===== Indexed Entry Point ================================================

loc_a_1D7B:
		mov	ax,2
		push	ax
		mov	ax,0D0h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		jmp	loc_a_1E4F

;===== Indexed Entry Point ================================================

loc_a_1D92:
		cmp	data_b_09B8,0
		jne	loc_a_1DB8		; Jump if not equal
		mov	ax,2
		push	ax
		mov	ax,0FAh
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		mov	ax,si
		or	ax,ax			; Zero ?
		jnz	loc_a_1DB6		; Jump if not zero
		jmp	loc_a_1E4F
loc_a_1DB6:
		jmp	short loc_a_1DEE
loc_a_1DB8:
		mov	ax,2
		push	ax
		mov	ax,0DCh
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		jmpn	loc_a_1E4C

;===== Indexed Entry Point ================================================

loc_a_1DCD:
		cmp	data_b_09B8,0
		jne	loc_a_1DF6		; Jump if not equal
		mov	ax,2
		push	ax
		mov	ax,0BEh
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		mov	si,ax
		mov	ax,si
		or	ax,ax			; Zero ?
		jz	loc_a_1E4F		; Jump if zero
loc_a_1DEE:
		mov	data_b_09B8,1
		jmp	short loc_a_1E4F
loc_a_1DF6:
		mov	ax,2
		push	ax
		mov	ax,0E6h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	short loc_a_1E4C

;===== Indexed Entry Point ================================================

loc_a_1E0A:
		cmp	data_b_09B8,0
		jne	loc_a_1E31		; Jump if not equal
		mov	ax,2
		push	ax
		mov	ax,115h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		or	ax,ax			; Zero ?
		jz	loc_a_1E2D		; Jump if zero
		mov	data_b_09B8,1
loc_a_1E2D:
		xor	si,si			; Zero register
		jmp	short loc_a_1E4F
loc_a_1E31:
		mov	ax,1
		push	ax
		mov	ax,data_b_09B8
		inc	data_b_09B8
		mov	dx,110h
		sub	dx,ax
		push	dx
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
loc_a_1E4C:
		mov	si,1
loc_a_1E4F:
		mov	data_b_09D2,si
		jmp	loc_a_2002
loc_a_1E56:
		cmp	data_b_09B6,0
		jg	loc_a_1E60		; Jump if >
		jmp	loc_a_1FF0
loc_a_1E60:
		cmp	data_b_09C6,7Dh
		jg	loc_a_1E6A		; Jump if >
		jmp	loc_a_1FF0
loc_a_1E6A:
		mov	ax,data_b_09B6
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		or	ax,ax			; Zero ?
		jnz	loc_a_1E7D		; Jump if not zero
		mov	word ptr [bp-6],0
		jmp	short loc_a_1E93
loc_a_1E7D:
		mov	ax,8Ch
		sub	ax,data_b_098A
		mov	bx,data_b_09B6
		mov	cx,6
		sar	bx,cl			; Shift w/sign fill
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	[bp-6],ax
loc_a_1E93:
		cmp	word ptr [bp-6],1
		jl	loc_a_1EA5		; Jump if <
		mov	ax,data_b_0988
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		or	ax,ax			; Zero ?
		jnz	loc_a_1EAB		; Jump if not zero
loc_a_1EA5:
		mov	di,data_b_09C6
		jmp	short loc_a_1EBF
loc_a_1EAB:
		mov	ax,data_b_0988
		mov	cx,6
		sar	ax,cl			; Shift w/sign fill
		mul	word ptr [bp-6]		; dx:ax = data * ax
		mov	di,ax
		add	di,data_b_09C6
;*		add	di,0FFFCh
		db	 83h,0C7h,0FCh		;  Fixup - byte match
loc_a_1EBF:
		mov	ax,data_b_098E
		sub	ax,data_b_09C6
		mov	[bp-4],ax
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1ED2		; Jump if > or =
		neg	ax
loc_a_1ED2:
		cmp	ax,80h
		jge	loc_a_1F31		; Jump if > or =
		cmp	data_b_0A4D,4Bh
		jge	loc_a_1F31		; Jump if > or =
		cmp	data_b_098A,9Eh
		jge	loc_a_1EEB		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_1EED
loc_a_1EEB:
		xor	ax,ax			; Zero register
loc_a_1EED:
		push	ax
		cmp	data_b_0988,0
		jge	loc_a_1EFA		; Jump if > or =
		mov	ax,1
		jmp	short loc_a_1EFC
loc_a_1EFA:
		xor	ax,ax			; Zero register
loc_a_1EFC:
		pop	dx
		xor	dx,ax
		jz	loc_a_1F19		; Jump if zero
		mov	ax,3
		push	ax
		mov	ax,data_b_09C6
		add	ax,0Fh
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	loc_a_2002
loc_a_1F19:
		mov	ax,3
		push	ax
		mov	ax,data_b_09C6
		add	ax,0FFF1h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	loc_a_2002
loc_a_1F31:
		cmp	data_b_098A,82h
		jg	loc_a_1F3C		; Jump if >
		jmp	loc_a_1FC0
loc_a_1F3C:
		mov	ax,[bp-4]
		or	ax,ax			; Zero ?
		jge	loc_a_1F45		; Jump if > or =
		neg	ax
loc_a_1F45:
		cmp	ax,6
		jle	loc_a_1F7A		; Jump if < or =
		mov	ax,data_b_0988
		or	ax,ax			; Zero ?
		jge	loc_a_1F53		; Jump if > or =
		neg	ax
loc_a_1F53:
		cmp	ax,400h
		jge	loc_a_1F7A		; Jump if > or =
		mov	ax,3
		push	ax
		mov	ax,data_b_098E
		add	ax,0FF26h
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		add	ax,data_b_09C6
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	loc_a_2002
loc_a_1F7A:
		mov	ax,0Ah
		push	ax
		mov	ax,data_b_098E
		add	ax,0FF26h
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mov	dx,data_b_09C6
		sub	dx,[bp-2]
		sub	dx,ax
		push	dx
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		cmp	data_b_098E,0AFh
		jle	loc_a_1FB9		; Jump if < or =
		cmp	data_b_09D6,1
		jne	loc_a_1FB4		; Jump if not equal
		cmp	data_b_09DC,2
		jge	loc_a_1FB9		; Jump if > or =
loc_a_1FB4:
		mov	ax,1
		jmp	short loc_a_1FBB
loc_a_1FB9:
		xor	ax,ax			; Zero register
loc_a_1FBB:
		mov	data_b_09D2,ax
		jmp	short loc_a_2002
loc_a_1FC0:
		cmp	di,9Eh
		jge	loc_a_1FCD		; Jump if > or =
		mov	ax,13Ch
		sub	ax,di
		mov	di,ax
loc_a_1FCD:
		cmp	di,115h
		jle	loc_a_1FDA		; Jump if < or =
		mov	ax,22Ah
		sub	ax,di
		mov	di,ax
loc_a_1FDA:
		mov	ax,3
		push	ax
		mov	ax,di
		sub	ax,[bp-2]
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
		jmp	short loc_a_2002
loc_a_1FF0:
		mov	ax,8
		push	ax
		mov	ax,0D3h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_199B
		add	sp,6
loc_a_2002:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_1CEA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2008	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,4
		xor	ax,ax			; Zero register
		mov	data_b_09B6,ax
		mov	data_b_0988,ax
		mov	data_b_0A0E,ax
		mov	data_b_0A3C,ax
		mov	data_b_09DC,ax
		mov	data_b_0986,6
		mov	data_b_0A4D,0C8h
		mov	si,ax
		jmp	loc_a_20EC
loc_a_2032:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_098C[bx]
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_0990[bx],ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E4[bx],0ADh
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09E8[bx],0FFFFh
		xor	ax,ax			; Zero register
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09BE[bx],ax
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CC[bx],ax
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09C8[bx],ax
		push	ax
		mov	ax,si
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		mov	data_b_09CA[bx],ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_0A10[bx],ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_09DE[bx],ax
		mov	ax,si
		inc	ax
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_00AA[bx]
		push	ax
		mov	ax,si
		inc	ax
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_00AC[bx]
		dec	ax
		pop	dx
		cmp	dx,ax
		jge	loc_a_20EB		; Jump if > or =
		mov	ax,2
		sub	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_00AA[bx]
		push	ax
		mov	ax,2
		sub	ax,si
		mov	dx,3Ch
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,data_b_00AC[bx]
		dec	ax
		pop	dx
		cmp	dx,ax
		jne	loc_a_20EB		; Jump if not equal
		mov	data_b_09D8,si
loc_a_20EB:
		inc	si
loc_a_20EC:
		cmp	si,2
		jge	loc_a_20F4		; Jump if > or =
		jmp	loc_a_2032
loc_a_20F4:
		mov	ax,data_b_0A44
		sar	ax,1			; Shift w/sign fill
		add	ax,data_b_0A44
		mov	data_b_0A42,ax
		mov	ax,data_b_09D8
		mov	dx,0A5h
		mul	dx			; dx:ax = reg * ax
		add	ax,40h
		mov	data_b_0A3A,ax
		mov	data_b_09C6,ax
		mov	cx,6
		shl	ax,cl			; Shift w/zeros fill
		mov	data_b_0A40,ax
		mov	ax,87h
		mov	data_b_09C4,ax
		mov	data_b_098A,ax
		shl	ax,cl			; Shift w/zeros fill
		mov	data_b_09EC,ax
		mov	ax,data_b_09D8
		add	ax,2
		mov	data_b_0A14,ax
		mov	data_b_09D6,2
		mov	ax,1
		mov	data_b_09BC,ax
		mov	data_b_0A4B,ax
		mov	data_b_09D4,0
		xor	ax,ax			; Zero register
		mov	[bp-2],ax
		mov	[bp-4],ax
		mov	ax,data_b_00E6
		mov	dx,0Eh
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	al,byte ptr data_b_00EE[bx]	; ('Keyboard')
		mov	ah,0
		cmp	ax,20h
		je	loc_a_2175		; Jump if equal
		cmp	ax,43h
		je	loc_a_217C		; Jump if equal
		cmp	ax,4Ah
		je	loc_a_216E		; Jump if equal
		jmp	short loc_a_2181
loc_a_216E:
		mov	word ptr [bp-4],1
		jmp	short loc_a_2181
loc_a_2175:
		mov	word ptr [bp-4],2
		jmp	short loc_a_2181
loc_a_217C:
		mov	word ptr [bp-4],3
loc_a_2181:
		mov	ax,data_b_0122
		mov	dx,0Eh
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	al,byte ptr data_b_012A[bx]	; ('Keyboard')
		mov	ah,0
		cmp	ax,20h
		je	loc_a_21A9		; Jump if equal
		cmp	ax,43h
		je	loc_a_21B0		; Jump if equal
		cmp	ax,4Ah
		je	loc_a_21A2		; Jump if equal
		jmp	short loc_a_21B5
loc_a_21A2:
		mov	word ptr [bp-2],1
		jmp	short loc_a_21B5
loc_a_21A9:
		mov	word ptr [bp-2],2
		jmp	short loc_a_21B5
loc_a_21B0:
		mov	word ptr [bp-2],3
loc_a_21B5:
		; save INT 9 address
		mov	ax,9
		push	ax			; PARAMETER_1
		call	sub_a_413C		; Get INT vector
		inc	sp
		inc	sp
		mov	word ptr data_b_0A48+1,dx
		mov	word ptr data_b_0A46+1,ax

		; install INT 09h handler
		mov	ax,0C5Dh
		mov	dx,cs
		push	dx
		push	ax			; PARAMETER_2
		mov	ax,9
		push	ax			; PARAMETER_1
		call	sub_a_414C		; Set INT vector
		add	sp,6
		call	sub_a_0BEE
		xor	si,si			; Zero register
loc_a_21DB:
		cmp	data_b_09D4,0
		je	loc_a_21E5		; Jump if equal
		jmp	loc_a_2298
loc_a_21E5:
		mov	ax,data_b_09E2
		mov	dx,5
		mul	dx			; dx:ax = reg * ax
		inc	ax
		mov	data_b_09E2,ax

; Player 1 input

		mov	ax,[bp-4]
		dec	ax
		cmp	ax,2
		ja	loc_a_2224		; Jump if above
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_2203[bx]	;*3 entries
data_a_2203	dw	offset loc_a_2209	; Data table (indexed access)
data_a_2205	dw	offset loc_a_2213
data_a_2207	dw	offset loc_a_2221

;===== Indexed Entry Point ================================================

; Player 1 - Input from joystick

loc_a_2209:
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_0D50		; input from Joystick
		inc	sp
		inc	sp
		jmp	short loc_a_2224

;===== Indexed Entry Point ================================================

; Player 1 - Input from keyboard

loc_a_2213:
		or	si,si			; Zero ?
		jz	loc_a_2224		; Jump if zero
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_0DE9		; input player from keyboard
		inc	sp
		inc	sp
		jmp	short loc_a_2224

;===== Indexed Entry Point ================================================

; Player 1 - Input from computer

loc_a_2221:
		call	sub_a_19F4
loc_a_2224:


; Player 2 input

		mov	ax,[bp-2]
		dec	ax
		cmp	ax,2
		ja	loc_a_2259		; Jump if above
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_2236[bx]	;*3 entries
data_a_2236	dw	offset loc_a_223C	; Data table (indexed access)
data_a_2238	dw	offset loc_a_2247
data_a_223A	dw	offset loc_a_2256

;===== Indexed Entry Point ================================================

; Player 2 - Input from joystick

loc_a_223C:
		mov	ax,1
		push	ax
		call	sub_a_0D50		; input from Joystick
		inc	sp
		inc	sp
		jmp	short loc_a_2259

;===== Indexed Entry Point ================================================

; Player 2 - Input from keyboard

loc_a_2247:
		or	si,si			; Zero ?
		jz	loc_a_2259		; Jump if zero
		mov	ax,1
		push	ax
		call	sub_a_0DE9
		inc	sp
		inc	sp
		jmp	short loc_a_2259

;===== Indexed Entry Point ================================================

; Player 3 - Input from computer

loc_a_2256:
		call	sub_a_1CEA
loc_a_2259:
		mov	ax,1
		sub	ax,si
		mov	si,ax
		call	sub_a_0E7A
		cmp	data_b_0A4B,0
		je	loc_a_2275		; Jump if equal
		call	sub_a_1121
		call	sub_a_1452
		mov	di,1
		jmp	short loc_a_2284
loc_a_2275:
		or	di,di			; Zero ?
		jz	loc_a_2284		; Jump if zero
		call	sub_a_1121
		call	sub_a_1006
		mov	di,ax
		call	sub_a_1452
loc_a_2284:
		or	di,di			; Zero ?
		jz	loc_a_2292		; Jump if zero
		cmp	data_b_09DC,2
		jg	loc_a_2292		; Jump if >
		jmp	loc_a_21DB
loc_a_2292:
		call	sub_a_1747
		jmp	loc_a_21DB
loc_a_2298:
		call	sub_a_166F
		push	word ptr data_b_0A48+1
		push	word ptr data_b_0A46+1	; PARAMETER_2
		mov	ax,9
		push	ax			; PARAMETER_1
		call	sub_a_414C		; Set INT vector
		add	sp,6
loc_a_22AD:
		call	sub_a_432B		; Check DOS key
		or	ax,ax			; Zero ?
		jz	loc_a_22B9		; Jump if zero
		call	sub_a_4104
		jmp	short loc_a_22AD
loc_a_22B9:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_2008	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait for VSYNC

sub_a_22BF	proc	near
		mov	dx,3DAh
loc_a_22C2:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		test	al,8
		jnz	loc_a_22C2		; Jump if not zero
		mov	dx,3DAh
loc_a_22CA:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		test	al,8
		jz	loc_a_22CA		; Jump if zero
		retn
sub_a_22BF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display image: X, Y, image(with, height, data)

sub_a_22D0	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ch

		mov	dx,0B800h
		mov	es,dx

		mov	ax,[bp+0Ah]		; start line Y
		mov	cl,al
		and	al,0FEh
		mov	dx,28h
		mul	dx			; dx:ax = reg * ax

		mov	di,[bp+8]		; start position X
		shr	di,1			; Shift w/zeros fill
		shr	di,1			; Shift w/zeros fill
		add	di,ax

		mov	si,[bp+0Ch]		; image definition
		mov	bx,[si]			; image width
		add	bx,4
		shr	bx,1			; Shift w/zeros fill
		shr	bx,1			; Shift w/zeros fill

		mov	ax,[si+2]		; image height
		inc	al
		shr	al,1			; Shift w/zeros fill
		add	si,4
		mov	dx,50h
		sub	dx,bx
		test	cl,1
		jz	loc_a_2330		; Jump if zero
		add	di,d_B800_2000_e
loc_a_2316:
		mov	cx,bx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xor	di,2000h
		add	di,dx
		mov	cx,bx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bx
		xor	di,2000h
		dec	al
		jg	loc_a_2316		; Jump if >
		jmp	short loc_a_2348
loc_a_2330:
		mov	cx,bx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,bx
		xor	di,2000h
		mov	cx,bx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xor	di,2000h
		add	di,dx
		dec	al
		jg	loc_a_2330		; Jump if >
loc_a_2348:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_22D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display image XOR: X, Y, image(with, height, data)

sub_a_234E	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ch

		mov	dx,0B800h
		mov	es,dx

		mov	ax,[bp+0Ah]		; start line Y
		mov	cl,al
		and	al,0FEh
		mov	dx,28h
		mul	dx			; dx:ax = reg * ax

		mov	di,[bp+8]		; start position X
		shr	di,1			; Shift w/zeros fill
		shr	di,1			; Shift w/zeros fill
		add	di,ax

		mov	si,[bp+0Ch]		; image definition
		mov	bx,[si]			; image width
		add	bx,4
		shr	bx,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill

		mov	ax,[si+2]		; image height
		inc	al
		shr	al,1			; Shift w/zeros fill
		mov	ah,al
		add	si,4
		mov	dx,50h
		sub	dx,bx
		test	cl,1
		jz	loc_a_23BA		; Jump if zero
		add	di,d_B800_2000_e
loc_a_2396:
		mov	cl,bl

locloop_a_2398:
		lodsb				; String [si] to al
		xor	es:[di],al
		inc	di
		loop	locloop_a_2398		; Loop if cx > 0

		xor	di,2000h
		add	di,dx
		mov	cl,bl

locloop_a_23A7:
		lodsb				; String [si] to al
		xor	es:[di],al
		inc	di
		loop	locloop_a_23A7		; Loop if cx > 0

		sub	di,bx
		xor	di,2000h
		dec	ah
		jg	loc_a_2396		; Jump if >
		jmp	short loc_a_23DC


loc_a_23BA:
		mov	cl,bl

locloop_a_23BC:
		lodsb				; String [si] to al
		xor	es:[di],al
		inc	di
		loop	locloop_a_23BC		; Loop if cx > 0

		sub	di,bx
		xor	di,2000h
		mov	cl,bl

locloop_a_23CB:
		lodsb				; String [si] to al
		xor	es:[di],al
		inc	di
		loop	locloop_a_23CB		; Loop if cx > 0

		xor	di,2000h
		add	di,dx
		dec	ah
		jg	loc_a_23BA		; Jump if >
loc_a_23DC:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_234E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear box by image: X, Y, image(with, height, data)

sub_a_23E2	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ch

		mov	dx,0B800h
		mov	es,dx

		mov	ax,[bp+0Ah]		; start line Y
		mov	cl,al
		and	al,0FEh
		mov	dx,28h
		mul	dx			; dx:ax = reg * ax

		mov	di,[bp+8]		; start position X
		shr	di,1			; Shift w/zeros fill
		shr	di,1			; Shift w/zeros fill
		add	di,ax

		mov	si,[bp+0Ch]		; image definition
		mov	bx,[si]			; image width
		add	bx,4
		shr	bx,1			; Shift w/zeros fill
		shr	bx,1			; Shift w/zeros fill

		mov	ax,[si+2]		; image height
		inc	al
		shr	al,1			; Shift w/zeros fill
		mov	ah,al

		xor	al,al			; Zero register
		mov	dx,50h
		sub	dx,bx
		test	cl,1
		jz	loc_a_2443		; Jump if zero
		add	di,d_B800_2000_e
loc_a_2429:
		mov	cx,bx
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		xor	di,2000h
		add	di,dx
		mov	cx,bx
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		sub	di,bx
		xor	di,2000h
		dec	ah
		jg	loc_a_2429		; Jump if >
		jmp	short loc_a_245B

loc_a_2443:
		mov	cx,bx
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		sub	di,bx
		xor	di,2000h
		mov	cx,bx
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		xor	di,2000h
		add	di,dx
		dec	ah
		jg	loc_a_2443		; Jump if >
loc_a_245B:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_23E2	endp

		db	15 dup (0)
		db	'pk', 8, 8, 'BGI Device Driver (C'
		db	'GA/MCGA)  V1.00 - 31 September 1'
		db	'987', 0Dh, 0Ah, 'Copyright (c) 1'
		db	'987 Borland International', 0Dh, 0Ah
		db	0
		db	 1Ah,0A0h, 00h, 00h, 00h,0EDh
		db	 16h, 01h, 00h, 01h, 00h
		db	45 dup (0)
		db	 1Eh, 0Eh, 1Fh,0FCh, 55h,0FFh
		db	 94h, 16h, 00h, 5Dh, 1Fh,0CBh
		db	 43h, 42h, 00h, 00h,0C3h, 00h
		db	 00h, 00h, 00h,0C3h,0D7h, 01h
		db	 31h, 02h, 48h, 02h, 15h, 00h
		db	 97h, 02h, 9Fh, 02h,0B3h, 02h
		db	 10h, 00h, 10h, 00h,0FEh, 07h
		db	 10h, 00h, 10h, 00h, 15h, 00h
		db	0BDh, 00h,0DEh, 00h, 86h, 02h
		db	0E3h, 00h,0D2h, 03h, 98h, 03h
		db	 5Ch, 03h,0FDh, 00h, 15h, 00h
		db	 9Fh, 00h,0DCh, 0Fh,0F5h, 0Fh
		db	 6Ch, 00h, 84h, 00h, 99h, 00h
		db	 50h, 00h,0A3h,0FCh, 03h, 89h
		db	 1Eh,0FEh, 03h, 89h, 0Eh, 00h
		db	 04h, 89h, 16h, 02h, 04h,0C3h
		db	 81h, 00h, 81h, 00h, 82h, 00h
		db	 82h, 00h, 72h, 00h, 83h, 00h
		db	 0Eh, 07h,0BBh, 60h, 00h,0C3h
		db	 2Eh, 80h, 3Eh, 0Ah, 01h, 00h
		db	 75h, 04h,0B8h, 02h, 00h,0CBh
		db	0B8h, 01h, 00h,0CBh,0CBh,0CBh
		db	0E8h, 03h, 00h,0E9h, 8Bh
		db	0Dh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_259A	proc	near
		mov	si,cx
		mov	di,dx
		add	cx,es:[bx]
		inc	bx
		inc	bx
		add	dx,es:[bx]
		inc	bx
		inc	bx
		retn
sub_a_259A	endp

			                        ;* No entry point to code
		call	sub_a_259A
		jmp	loc_a_33DD
			                        ;* No entry point to code
		mov	si,ax
		mov	di,bx
		mov	dl,0FFh
		mov	al,byte ptr data_b_02BE
		cmp	al,2
		jae	loc_a_25C6		; Jump if above or =
		xor	dl,dl			; Zero register
		and	al,al
		jz	loc_a_25C6		; Jump if zero
		mov	dl,byte ptr data_b_010C+1
loc_a_25C6:
		mov	dh,cl
		xor	bl,bl			; Zero register
		jmp	loc_a_365B
			                        ;* No entry point to code
		mov	bh,bl
		mov	bl,al
		cmp	al,0FFh
		je	loc_a_25DA		; Jump if equal
		and	bl,bl
		jz	loc_a_25DA		; Jump if zero
		retn
loc_a_25DA:
		and	bh,0Fh
		cmp	byte ptr data_b_0110,0
		jne	loc_a_25E7		; Jump if not equal
		or	bh,10h
loc_a_25E7:
		mov	data_b_010F,bh
		jmp	loc_a_29A3
			                        ;* No entry point to code
		mov	bh,es:[bx]
		jmp	short loc_a_25DA
			                        ;* No entry point to code
		cmp	al,0FFh
		jne	loc_a_2609		; Jump if not equal
		mov	cx,8
		mov	di,offset data_b_0A30

locloop_a_25FD:
		mov	al,es:[bx]
		mov	[di],al
		inc	di
		inc	bx
		loop	locloop_a_25FD		; Loop if cx > 0

		mov	ax,0C0Ch
loc_a_2609:
		call	sub_a_27D2
		retn
			                        ;* No entry point to code
		mov	ax,cx
		mul	data_b_0115		; dx:ax = data * ax
		mov	bx,ax
		mov	cx,data_b_0117
		retn
		db	11 dup (0)
		db	8, 0, 8, 0
		db	18 dup (0)
		db	 3Fh, 01h,0C7h, 00h, 3Fh, 01h
		db	0C7h, 00h, 28h, 23h, 58h, 1Bh
		db	 8Dh, 20h, 08h, 08h, 03h, 02h
		db	 04h, 0Eh, 90h, 00h, 00h, 3Fh
		db	 01h,0C7h, 00h, 3Fh, 01h,0C7h
		db	 00h, 28h, 23h, 58h, 1Bh, 8Dh
		db	 20h, 08h, 08h, 03h, 03h, 05h
		db	 07h, 90h, 00h, 00h, 7Fh, 02h
		db	0C7h, 00h, 7Fh, 02h,0C7h, 00h
		db	 28h, 23h, 58h, 1Bh, 47h, 10h
		db	 08h, 08h, 01h, 07h, 90h, 00h
		db	 00h, 7Fh, 02h,0DFh, 01h, 7Fh
		db	 02h,0DFh, 01h, 28h, 23h, 58h
		db	 1Bh, 10h, 27h, 08h, 08h, 01h
		db	 07h, 90h, 29h, 01h, 40h, 01h
		db	 57h, 01h, 6Ch, 01h, 04h, 00h
		db	 12h
		db	'320 x 200 CGA P1  '
		db	12h
		db	'320 x 200 CGA P2  '
		db	12h
		db	'640 x 200 CGA     '
		db	12h
		db	'640 x 480 MCGA    <'
		db	 01h, 75h, 05h, 8Bh, 0Eh, 89h
		db	 01h,0C3h, 0Eh, 07h, 3Ch, 02h
		db	 75h, 0Dh,0B0h, 13h,0F6h,0E1h
		db	 8Ah,0D8h, 32h,0FFh, 81h,0C3h
		db	 8Bh, 01h,0C3h, 8Ah,0C5h, 32h
		db	0E4h, 40h,0A3h, 89h, 01h, 8Ah
		db	0C1h, 32h,0DBh, 3Ch, 04h, 73h
		db	 06h, 3Ch, 02h, 72h, 04h,0FEh
		db	0C3h, 2Ch, 02h, 88h, 1Eh, 10h
		db	 01h, 8Ah,0C8h,0A2h, 0Bh, 01h
		db	0C6h, 06h, 0Ah, 01h,0FFh, 3Ch
		db	 02h, 73h, 05h,0C6h, 06h, 0Ah
		db	 01h, 00h, 8Ah,0D9h,0D0h,0E3h
		db	 32h,0FFh, 8Bh, 9Fh, 81h, 01h
		db	 89h, 1Eh, 27h, 01h,0C3h, 26h
		db	 8Ah, 07h, 24h, 0Fh, 80h, 3Eh
		db	 10h, 01h, 00h, 75h, 02h, 0Ch
		db	 10h,0A2h, 0Fh, 01h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2752	proc	near
		mov	al,data_b_010B
		jmp	loc_a_295A
			                        ;* No entry point to code
		mov	al,data_b_03F2
		cmp	al,3
		jb	loc_a_2777		; Jump if below
		cmp	al,3
		je	loc_a_2786		; Jump if equal
		push	data_b_0400
		push	data_b_0402
		call	sub_a_2752
		pop	data_b_0402
		pop	data_b_0400
		retn

; Clear screen CGA

loc_a_2777:
		xor	cx,cx			; Zero register
		mov	dh,18h
		mov	dl,4Fh			; 'O'
		xor	bh,bh			; Zero register
		xor	al,al			; Zero register
		mov	ah,6
		int	10h			; Video display   ah=functn 06h
						;  scroll up, al=lines
						;   bh=attrib, cx+dx=window size
		retn

; Clear screen EGA

loc_a_2786:
		mov	ax,0A000h
		mov	es,ax
		mov	cx,4B00h
		cld				; Clear direction
		xor	ax,ax			; Zero register
		mov	di,ax
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn
			                        ;* No entry point to code
		and	ax,303h
		cmp	byte ptr data_b_010A,0
		je	loc_a_27A3		; Jump if equal
		and	ax,101h
loc_a_27A3:
		mov	data_b_010C,ax
		retn
			                        ;* No entry point to code
		mov	data_b_0111,ax
		mov	data_b_0113,bx
		retn
			                        ;* No entry point to code
		push	cx
		push	dx
		mov	cx,ax
		mov	dx,bx
		xchg	data_b_0111,ax
		xchg	data_b_0113,bx
		call	sub_a_27C3
		pop	dx
		pop	cx
		retn

;==== External Entry into Subroutine ======================================

sub_a_27C3:
		mov	si,data_b_010C
		mov	di,word ptr data_b_03C6
		jmp	loc_a_2AE8
		db	0, 0, 0, 0

;==== External Entry into Subroutine ======================================

sub_a_27D2:
		mov	data_b_02BE,ax
		mov	bl,byte ptr data_b_010C+1
		push	cs
		pop	es
		cld				; Clear direction
		cmp	al,2
		jb	loc_a_2835		; Jump if below
		sub	al,2
		xor	ah,ah			; Zero register
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
		mov	si,offset data_b_09E0
		add	si,ax
		mov	di,34Ch
		cmp	byte ptr data_b_010A,0
		je	loc_a_2803		; Jump if equal
		mov	cx,4
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	data_b_034A,8
		retn
loc_a_2803:
		mov	data_b_034A,10h
		mov	bh,byte ptr data_b_010C+1
		mov	cx,8

locloop_a_2810:
		lodsb				; String [si] to al
		call	sub_a_2822
		xchg	dl,al
		stosb				; Store al to es:[di]
		mov	al,dl
		call	sub_a_2822
		mov	al,dl
		stosb				; Store al to es:[di]
		loop	locloop_a_2810		; Loop if cx > 0

		retn

;==== External Entry into Subroutine ======================================

sub_a_2822:
		xor	dl,dl			; Zero register
		mov	bl,4
loc_a_2826:
		rol	dl,1			; Rotate
		rol	dl,1			; Rotate
		rcl	al,1			; Rotate thru carry
		jnc	loc_a_2830		; Jump if carry=0
		or	dl,bh
loc_a_2830:
		dec	bl
		jnz	loc_a_2826		; Jump if not zero
		retn
loc_a_2835:
		cmp	byte ptr data_b_010A,0
		je	loc_a_2843		; Jump if equal
		and	bl,bl
		jz	loc_a_2843		; Jump if zero
		mov	bx,offset data_b_0003
loc_a_2843:
		cmp	al,1
		je	loc_a_2849		; Jump if equal
		xor	bx,bx			; Zero register
loc_a_2849:
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		mov	al,data_b_0951[bx]
		mov	di,34Ch
		mov	cx,10h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		retn
		db	8, 0
		db	16 dup (0)
		db	 80h, 3Eh, 1Ah, 01h, 01h, 75h
		db	 03h, 03h,0D9h
		db	4Bh

locloop_a_2876:
		mov	al,es:[bx]
		and	al,al
		jz	loc_ret_a_28A7		; Jump if zero
		push	es
		push	bx
		push	cx
		mov	bx,data_b_0111
		mov	cx,data_b_0113
		call	sub_a_2F92
		pop	cx
		pop	bx
		pop	es
		mov	dx,data_b_0115
		cmp	byte ptr data_b_011A,1
		jne	loc_a_28A0		; Jump if not equal
		add	data_b_0113,dx
		dec	bx
		jmp	short loc_a_28A5
loc_a_28A0:
		add	data_b_0111,dx
		inc	bx
loc_a_28A5:
		loop	locloop_a_2876		; Loop if cx > 0


loc_ret_a_28A7:
		retn
			                        ;* No entry point to code
		mov	data_b_0119,al
		mov	data_b_011A,ah
		and	bx,0F8h
		mov	data_b_0115,bx
		and	cx,0F8h
		mov	data_b_0117,cx
		push	bx
		push	cx
		mov	al,byte ptr data_b_010C
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		call	sub_a_2F5A
		pop	cx
		pop	bx
		retn
		db	0FFh,0FFh, 01h, 00h,0FFh,0FFh
loc_a_28DC:
		int	3			; Debug breakpoint
		int	3			; Debug breakpoint
		js	loc_a_28DC		; Jump if sign=1
		clc				; Clear carry flag
		clc				; Clear carry flag
		cmp	al,4
		je	loc_a_28F0		; Jump if equal
		xor	ah,ah			; Zero register
		shl	al,1			; Shift w/zeros fill
		mov	bx,ax
		mov	bx,word ptr data_b_03CA[bx]
loc_a_28F0:
		mov	word ptr data_b_03C6,bx
		mov	word ptr data_b_03C8,cx
		retn
		db	8 dup (0)
		db	0B8h, 00h, 00h
		db	12 dup (0)
		db	 7Fh, 02h,0C7h, 00h, 3Fh, 01h
		db	0C7h, 00h, 28h, 00h, 00h,0B8h
		db	 7Eh, 04h, 3Fh, 01h,0C7h, 00h
		db	 28h, 00h, 00h,0B8h, 82h, 04h
		db	 7Fh, 02h,0C7h, 00h, 28h, 00h
		db	 00h,0B8h,0A8h, 04h, 7Fh, 02h
		db	0DFh, 01h, 50h, 00h, 00h,0A0h
		db	0AEh, 04h,0CFh, 02h, 5Bh, 01h
		db	 5Ah, 00h, 00h,0B0h,0DCh, 04h
		db	 7Fh, 02h, 8Fh, 01h, 50h, 00h
		db	 00h,0B8h,0B4h, 04h,0CFh, 02h
		db	 5Dh, 01h, 5Ah, 00h, 00h,0B8h
		db	0BAh, 04h
loc_a_295A:
		cmp	al,7
		jb	loc_a_2960		; Jump if below
		mov	al,2
loc_a_2960:
		mov	data_b_03F2,al
		mov	ah,0Ah
		mul	ah			; ax = reg * al
		mov	bx,ax
		add	bx,offset data_b_0404
		mov	ax,[bx]
		mov	data_b_03F8,ax
		mov	data_b_0400,ax
		mov	ax,[bx+2]
		mov	data_b_03FA,ax
		mov	data_b_0402,ax
		mov	ax,[bx+4]
		mov	data_b_03F3,ax
		mov	ax,[bx+6]
		mov	data_b_03F0,ax
		call	word ptr [bx+8]		;*
		retn
sub_a_2752	endp

			                        ;* No entry point to code
		xor	al,al			; Zero register
		jmp	short loc_a_2994
		db	0B0h, 01h
loc_a_2994:
		; set display mode 4
		push	ax
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		pop	ax

		; set color
		mov	bh,1
		mov	bl,al
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
loc_a_29A3:
		cmp	byte ptr data_b_03F2,4
		je	loc_ret_a_29B7		; Jump if equal
		mov	al,data_b_010F
		mov	ah,0Bh
		xor	bh,bh			; Zero register
		and	al,1Fh
		mov	bl,al
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)

loc_ret_a_29B7:
		retn
			                        ;* No entry point to code
		mov	ax,6
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retn
			                        ;* No entry point to code
		mov	ax,11h
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retn
			                        ;* No entry point to code
		mov	ax,40h
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retn
			                        ;* No entry point to code
		cld				; Clear direction
		mov	ax,30h
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

; clear screen
		mov	ax,0B800h
		mov	es,ax
		xor	ax,ax			; Zero register
		xor	di,di			; Zero register
		cld				; Clear direction
		mov	cx,4000h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn

; MDA setup
			                        ;* No entry point to code
		xor	ax,2E2Dh
		pop	es
		pop	bx
		add	dl,[bx+57h]
		add	al,[bp+di]
		add	[bx+si],al
		mov	al,3
		mov	dx,3BFh
		out	dx,al			; port 3BFh, Hercules config
		mov	al,2
		mov	si,offset data_b_04D0
		xor	bx,bx			; Zero register
		mov	cx,8000h
		push	ax
		push	bx
		push	cx
		mov	dx,3B8h
		out	dx,al			; port 3B8h, MDA video control
		mov	ax,ds
		mov	es,ax
		mov	dx,3B4h
		mov	cx,0Ch
		xor	ah,ah			; Zero register

locloop_a_2A0F:
		mov	al,ah
		out	dx,al			; port 3B4h, MDA/EGA reg index
						;  al = 0, horiz char total
		inc	dx
		lodsb				; String [si] to al
		out	dx,al			; port 3B5h, MDA/EGA indxd data
		inc	ah
		dec	dx
		loop	locloop_a_2A0F		; Loop if cx > 0

		pop	cx
		mov	ax,data_b_03F0
		cld				; Clear direction
		mov	es,ax
		xor	di,di			; Zero register
		pop	ax
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	dx,3B8h
		pop	ax
		or	al,8
		out	dx,al			; port 3B8h, MDA video control
		retn
		db	 38h, 05h, 38h, 05h, 48h, 05h
		db	 38h, 05h, 48h, 05h, 38h, 05h
		db	 48h, 05h, 58h, 05h, 5Eh, 05h
		db	 6Ch, 05h, 8Ch, 05h,0A6h, 05h
		db	0C6h, 05h, 34h, 01h,0A8h, 01h
		db	 74h, 05h, 81h,0C3h, 00h, 20h
		db	0C3h
loc_a_2A53:
		sub	bx,1FB0h
		retn
			                        ;* No entry point to code
		xor	al,1
		test	al,1
		jz	loc_a_2A63		; Jump if zero
		add	bx,1FB0h
		retn
loc_a_2A63:
		sub	bx,2000h
		retn
			                        ;* No entry point to code
		add	bx,word ptr cs:[3F3h]
		retn
			                        ;* No entry point to code
		sub	bx,word ptr cs:[3F3h]
		retn
		db	 00h,0B0h, 00h,0B2h, 00h,0B4h
		db	 00h,0B6h, 51h, 8Ah,0C8h,0FEh
		db	0C1h, 80h,0E1h, 03h, 75h, 03h
		db	 83h,0C3h, 5Ah, 53h, 24h,0FCh
		db	 0Ah,0C1h, 8Ah,0D9h,0D0h,0E3h
		db	 32h,0FFh, 2Eh, 8Eh, 87h, 64h
		db	 05h, 5Bh, 59h,0C3h, 51h, 8Ah
		db	0C8h,0FEh,0C9h, 80h,0E1h, 03h
		db	 80h,0F9h, 03h, 75h,0E0h, 83h
		db	0EBh, 5Ah,0EBh,0DBh, 00h,0B8h
		db	 00h,0BAh, 00h,0BCh, 00h,0BEh
		db	 51h, 8Ah,0C8h,0FEh,0C1h, 80h
		db	0E1h, 03h, 75h, 03h, 83h,0C3h
		db	 50h, 53h, 24h,0FCh, 0Ah,0C1h
		db	 8Ah,0D9h,0D0h,0E3h, 32h,0FFh
		db	 2Eh, 8Eh, 87h, 9Eh, 05h, 5Bh
		db	 59h,0C3h, 51h, 8Ah,0C8h,0FEh
		db	0C9h, 80h,0E1h, 03h, 80h,0F9h
		db	 03h, 75h,0E0h, 83h,0EBh, 50h
		db	0EBh,0DBh
loc_a_2AE8:
		cmp	ax,data_b_03F8
		ja	loc_ret_a_2B00		; Jump if above
		cmp	cx,data_b_03F8
		ja	loc_ret_a_2B00		; Jump if above
		cmp	bx,data_b_03FA
		ja	loc_ret_a_2B00		; Jump if above
		cmp	dx,data_b_03FA
		jbe	loc_a_2B01		; Jump if below or =

loc_ret_a_2B00:
		retn
loc_a_2B01:
		mov	bp,sp
		sub	sp,14h
		mov	[bp-2],si
		mov	data_b_03F6,di
		cmp	ax,cx
		jb	loc_a_2B14		; Jump if below
		xchg	cx,ax
		xchg	bx,dx
loc_a_2B14:
		mov	[bp-4],ax
		mov	[bp-6],bx
		mov	byte ptr [bp-14h],0
		cmp	bx,dx
		jb	loc_a_2B28		; Jump if below
		xchg	bx,dx
		mov	byte ptr [bp-14h],80h
loc_a_2B28:
		xchg	cx,ax
		sub	ax,cx
		mov	[bp-0Ch],ax
		xchg	bx,dx
		sub	bx,dx
		mov	[bp-0Eh],bx
		call	sub_a_2C4C
		mov	ax,[bp-0Ch]
		mov	bx,[bp-0Eh]
		cmp	ax,bx
		jb	loc_a_2B5A		; Jump if below
		mov	[bp-0Ah],ax
		shl	bx,1			; Shift w/zeros fill
		mov	[bp-0Eh],bx
		sub	bx,ax
		mov	[bp-8],bx
		sub	bx,ax
		mov	[bp-0Ch],bx
		call	sub_a_2B72
		jmp	short loc_a_2BD8
		db	90h
loc_a_2B5A:
		mov	[bp-0Ah],bx
		shl	ax,1			; Shift w/zeros fill
		mov	[bp-0Ch],ax
		sub	ax,bx
		mov	[bp-8],ax
		sub	ax,bx
		mov	[bp-0Eh],ax
		call	sub_a_2B72
		jmp	loc_a_2C12

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B72	proc	near
		mov	bx,[bp-10h]
		mov	dx,[bp-8]
		mov	di,[bp-0Ch]
		mov	si,[bp-0Eh]
		mov	ax,[bp-6]
		and	al,3
		cmp	byte ptr data_b_010B,4
		jae	loc_a_2B8C		; Jump if above or =
		and	al,1
loc_a_2B8C:
		or	al,[bp-14h]
		cmp	byte ptr data_b_010A,0
		je	loc_a_2B98		; Jump if equal
		or	al,40h			; '@'
loc_a_2B98:
		cmp	byte ptr data_b_03F5,0
		je	loc_a_2BA1		; Jump if equal
		or	al,20h			; ' '
loc_a_2BA1:
		mov	ah,[bp-2]
		mov	ch,[bp-12h]
		mov	bp,[bp-0Ah]
		inc	bp
		rol	data_b_03F6,1		; Rotate
		jnc	loc_a_2BBB		; Jump if carry=0
		mov	cl,es:[bx]
		and	cl,ch
		or	cl,ah
		mov	es:[bx],cl

;==== External Entry into Subroutine ======================================

sub_a_2BBB:
loc_a_2BBB:
		push	bx
		mov	bl,byte ptr ds:[10Bh]
		shl	bl,1			; Shift w/zeros fill
		shl	bl,1			; Shift w/zeros fill
		xor	bh,bh			; Zero register
		add	bx,520h
		and	al,al
		jns	loc_a_2BD0		; Jump if not sign
		inc	bx
		inc	bx
loc_a_2BD0:
		mov	bx,[bx]
		mov	word ptr ds:[51Eh],bx
		pop	bx
		retn
sub_a_2B72	endp

loc_a_2BD8:
		dec	bp
		jnz	loc_a_2BDF		; Jump if not zero
		add	sp,14h
		retn
loc_a_2BDF:
		test	dh,80h
		jnz	loc_a_2BEC		; Jump if not zero
		add	dx,di
		call	word ptr data_b_051E
		jmp	short loc_a_2BEE
loc_a_2BEC:
		add	dx,si
loc_a_2BEE:
		test	al,40h			; '@'
		jnz	loc_a_2BF6		; Jump if not zero
		ror	ah,1			; Rotate
		ror	ch,1			; Rotate
loc_a_2BF6:
		ror	ah,1			; Rotate
		ror	ch,1			; Rotate
		test	ch,80h
		jnz	loc_a_2C00		; Jump if not zero
		inc	bx
loc_a_2C00:
		rol	data_b_03F6,1		; Rotate
		jnc	loc_a_2C10		; Jump if carry=0
		mov	cl,es:[bx]
		and	cl,ch
		or	cl,ah
		mov	es:[bx],cl
loc_a_2C10:
		jmp	short loc_a_2BD8
loc_a_2C12:
		dec	bp
		jnz	loc_a_2C19		; Jump if not zero
		add	sp,14h
		retn
loc_a_2C19:
		test	dh,80h
		jnz	loc_a_2C34		; Jump if not zero
		add	dx,si
		test	al,40h			; '@'
		jnz	loc_a_2C28		; Jump if not zero
		ror	ah,1			; Rotate
		ror	ch,1			; Rotate
loc_a_2C28:
		ror	ah,1			; Rotate
		ror	ch,1			; Rotate
		test	ch,80h
		jnz	loc_a_2C32		; Jump if not zero
		inc	bx
loc_a_2C32:
		jmp	short loc_a_2C36
loc_a_2C34:
		add	dx,di
loc_a_2C36:
		call	word ptr data_b_051E
		rol	data_b_03F6,1		; Rotate
		jnc	loc_a_2C4A		; Jump if carry=0
		mov	cl,es:[bx]
		and	cl,ch
		or	cl,ah
		mov	es:[bx],cl
loc_a_2C4A:
		jmp	short loc_a_2C12

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C4C	proc	near
		mov	cx,[bp-4]
		mov	dx,[bp-6]
		mov	al,data_b_010B
		cmp	al,3
		jae	loc_a_2C5D		; Jump if above or =
		and	dx,0FEh
loc_a_2C5D:
		cmp	al,4
		jb	loc_a_2C65		; Jump if below
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
loc_a_2C65:
		mov	ax,data_b_03F3
		mul	dx			; dx:ax = reg * ax
		mov	si,ax
		mov	dx,cx
		cmp	byte ptr data_b_010A,0
		je	loc_a_2C7C		; Jump if equal
		mov	cx,703h
		mov	al,0FEh
		jmp	short loc_a_2C81
loc_a_2C7C:
		mov	cx,302h
		mov	al,0FCh
loc_a_2C81:
		and	ch,dl
		shr	dx,cl			; Shift w/zeros fill
		add	si,dx
		inc	ch
		mov	ah,[bp-2]
		mov	dh,al
		mov	al,data_b_010A
loc_a_2C91:
		ror	ah,1			; Rotate
		ror	dh,1			; Rotate
		and	al,al
		jnz	loc_a_2C9D		; Jump if not zero
		ror	ah,1			; Rotate
		ror	dh,1			; Rotate
loc_a_2C9D:
		dec	ch
		jnz	loc_a_2C91		; Jump if not zero
		mov	al,data_b_010B
		mov	[bp-2],ah
		mov	[bp-12h],dh
		mov	bx,si
		cmp	al,3
		jae	loc_a_2CBB		; Jump if above or =
		test	word ptr [bp-6],1
		jz	loc_a_2CBB		; Jump if zero
		add	bx,2000h
loc_a_2CBB:
		mov	[bp-10h],bx
		mov	es,data_b_03F0
		cmp	al,4
		jb	loc_ret_a_2CDB		; Jump if below
		mov	bx,[bp-6]
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	es,data_b_0564[bx]
		cmp	al,5
		jne	loc_ret_a_2CDB		; Jump if not equal
		mov	es,data_b_059E[bx]

loc_ret_a_2CDB:
		retn
sub_a_2C4C	endp

		db	 00h, 00h, 00h,0F1h, 07h, 00h
		db	 00h,0DDh, 07h,0E1h, 07h,0E5h
		db	 07h,0F1h, 07h,0EDh, 07h, 26h
		db	 08h, 05h,0C3h, 26h, 30h, 05h
		db	0C3h,0F6h,0D3h, 0Ah,0C3h, 26h
		db	 20h, 05h,0C3h,0F6h,0D0h,0EBh
		db	 00h, 22h,0C3h,0F6h,0D3h, 26h
		db	 22h, 1Dh, 0Ah,0C3h, 26h, 88h
		db	 05h,0C3h, 3Bh,0C1h, 72h, 01h
		db	 91h, 3Bh,0DAh, 72h, 02h, 87h
		db	0DAh
loc_a_2D19:
		mov	si,ax
		mov	data_b_07D2,al
		mov	di,bx
		mov	al,3
		push	cs
		pop	es
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		cmp	byte ptr data_b_010A,0
		jne	loc_a_2D31		; Jump if not equal
		shl	bx,1			; Shift w/zeros fill
loc_a_2D31:
		add	bx,34Ch
		sub	dx,di
		inc	dx
		mov	data_b_07CC,dx
		push	bx
		xor	bh,bh			; Zero register
		mov	bl,al
		shl	bl,1			; Shift w/zeros fill
		add	bx,offset data_b_07D3
		mov	bx,[bx]
		mov	data_b_07CF,bx
		mov	bx,si
		mov	ax,cx
		sub	ax,bx
		mov	data_b_07D1,al
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		cmp	byte ptr data_b_010A,0
		je	loc_a_2D63		; Jump if equal
		shr	ax,1			; Shift w/zeros fill
loc_a_2D63:
		inc	ax
		pop	bx
		push	ax
		push	si
		push	cx
		push	es
		push	bx
		call	sub_a_2E65
		mov	byte ptr ds:[7CEh],bl
		cld				; Clear direction
		pop	si
		pop	ds
		mov	cl,al
		pop	bx
		call	sub_a_2E3D
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_2D84		; Jump if not equal
		inc	bl
loc_a_2D84:
		mov	ch,byte ptr cs:[949h][bx]
		pop	bx
		call	sub_a_2E3D
		mov	bh,byte ptr cs:[941h][bx]
		mov	bl,ch
		pop	bp
		mov	al,byte ptr cs:[7CEh]
loc_a_2D99:
		push	ax
		push	bx
		push	bp
		push	di
		cmp	byte ptr cs:[10Ah],0
		je	loc_a_2DAA		; Jump if equal
		lodsb				; String [si] to al
		mov	ah,al
		jmp	short loc_a_2DB5
loc_a_2DAA:
		lodsw				; String [si] to ax
		test	byte ptr cs:[7D2h],4
		jnz	loc_a_2DB5		; Jump if not zero
		xchg	ah,al
loc_a_2DB5:
		push	si
		mov	dx,ax
		call	sub_a_2DEA
		pop	si
		mov	ax,10h
		cmp	byte ptr cs:[10Ah],0
		je	loc_a_2DCA		; Jump if equal
		mov	ax,8
loc_a_2DCA:
		add	ax,34Ch
		cmp	si,ax
		jb	loc_a_2DD4		; Jump if below
		mov	si,34Ch
loc_a_2DD4:
		pop	di
		pop	bp
		pop	bx
		pop	ax
		xchg	bx,di
		call	word ptr ds:[51Eh]
		xchg	bx,di
		dec	word ptr cs:[7CCh]
		jnz	loc_a_2D99		; Jump if not zero
		push	cs
		pop	ds
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2DEA	proc	near
		push	bx
		mov	al,dl
		dec	bp
		mov	bl,bh
		and	bp,bp
		jz	loc_a_2E03		; Jump if zero
loc_a_2DF4:
		call	word ptr cs:[7CFh]
		mov	bl,0FFh
		inc	di
		xchg	dh,dl
		mov	al,dl
		dec	bp
		jnz	loc_a_2DF4		; Jump if not zero
loc_a_2E03:
		mov	ah,dh
		mov	dh,3
		cmp	byte ptr cs:[10Ah],0
		je	loc_a_2E11		; Jump if equal
		mov	dh,7
loc_a_2E11:
		mov	dl,byte ptr cs:[7D1h]
		and	dl,dh
		sub	dh,dl
		mov	dl,cl
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_2E26		; Jump if not equal
		shr	dl,1			; Shift w/zeros fill
loc_a_2E26:
		cmp	dh,dl
		pop	dx
		jge	loc_a_2E35		; Jump if > or =
		call	word ptr cs:[7CFh]
		inc	di
		mov	al,ah
		mov	bl,0FFh
loc_a_2E35:
		and	bl,dl
		call	word ptr cs:[7CFh]
		retn
sub_a_2DEA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2E3D	proc	near
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_2E4E		; Jump if not equal
		and	bl,3
		shl	bl,1			; Shift w/zeros fill
loc_a_2E4E:
		mov	al,bl
		retn
sub_a_2E3D	endp

		db	0FFh, 7Fh, 3Fh, 1Fh, 0Fh, 07h
		db	 03h, 01h, 80h,0C0h,0E0h,0F0h
		db	0F8h,0FCh,0FEh,0FFh, 00h, 55h
		db	0AAh,0FFh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2E65	proc	near
		xor	al,al			; Zero register

;==== External Entry into Subroutine ======================================

sub_a_2E67:
		call	sub_a_2BBB
		mov	dx,di
		push	di
		mov	al,byte ptr ds:[10Bh]
		cmp	al,3
		jae	loc_a_2E78		; Jump if above or =
		and	dx,0FEh
loc_a_2E78:
		cmp	al,4
		jb	loc_a_2E80		; Jump if below
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
loc_a_2E80:
		mov	ax,word ptr ds:[3F3h]
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	dx,si
		mov	cx,302h
		mov	al,3Fh			; '?'
		mov	ah,byte ptr ds:[10Ah]
		and	ah,ah
		jz	loc_a_2E9B		; Jump if zero
		mov	cx,703h
		mov	al,7Fh
loc_a_2E9B:
		and	ch,dl
		shr	dx,cl			; Shift w/zeros fill
		add	bx,dx
		and	ah,ah
		jnz	loc_a_2EA7		; Jump if not zero
		shl	ch,1			; Shift w/zeros fill
loc_a_2EA7:
		mov	cl,ch
		ror	al,cl			; Rotate
		xchg	al,cl
		mov	di,bx
		mov	es,word ptr ds:[3F0h]
		pop	bx
		mov	ah,byte ptr ds:[10Bh]
		cmp	ah,3
		jae	loc_a_2EC7		; Jump if above or =
		and	bl,1
		jz	loc_ret_a_2EC6		; Jump if zero
		add	di,2000h

loc_ret_a_2EC6:
		retn
loc_a_2EC7:
		cmp	ah,4
		jb	loc_ret_a_2EE1		; Jump if below
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		shl	bl,1			; Shift w/zeros fill
		mov	es,word ptr ds:[564h][bx]
		cmp	ah,5
		jne	loc_a_2EDF		; Jump if not equal
		mov	es,word ptr ds:[59Eh][bx]
loc_a_2EDF:
		shr	bl,1			; Shift w/zeros fill

loc_ret_a_2EE1:
		retn
sub_a_2E65	endp

		db	14 dup (0)
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 01h, 02h, 04h, 08h
		db	 10h, 20h, 40h, 80h,0E0h,0C1h
		db	 83h, 07h, 0Eh, 1Ch, 38h, 70h
		db	0F0h, 78h, 3Ch, 1Eh, 0Fh, 87h
		db	0C3h,0E1h,0A5h,0D2h, 69h,0B4h
		db	 5Ah, 2Dh, 96h, 4Bh,0FFh, 88h
		db	 88h, 88h,0FFh, 88h, 88h, 88h
		db	 81h, 42h, 24h, 18h, 18h, 24h
		db	 42h, 81h,0CCh, 33h,0CCh, 33h
		db	0CCh, 33h,0CCh, 33h, 80h, 00h
		db	 08h, 00h, 80h, 00h, 08h, 00h
		db	 88h, 00h, 22h, 00h, 88h, 00h
		db	 22h, 00h,0FFh
		db	7 dup (0FFh)
		db	9 dup (0)
		db	1, 1
		db	7 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2F5A	proc	near
		mov	byte ptr data_b_0A44+1,ah
		mov	ah,al
		and	ah,80h
		mov	byte ptr data_b_0A40,ah
		and	al,3
		and	bl,bl
		jnz	loc_a_2F6F		; Jump if not zero
		inc	bl
loc_a_2F6F:
		mov	byte ptr data_b_0A40+1,bl
		and	cl,cl
		jnz	loc_a_2F79		; Jump if not zero
		inc	cl
loc_a_2F79:
		mov	byte ptr data_b_0A42,cl
		mov	al,8
		mul	bl			; ax = reg * al
		sub	ax,2
		mov	data_b_0A46,ax
		mov	al,8
		mul	cl			; ax = reg * al
		sub	ax,2
		mov	data_b_0A48,ax

loc_ret_a_2F91:
		retn
sub_a_2F5A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2F92	proc	near
		and	bx,bx
		js	loc_ret_a_2F91		; Jump if sign=1
		mov	di,data_b_0400
		sub	di,data_b_0A46
		cmp	bx,di
		jae	loc_ret_a_2F91		; Jump if above or =
		and	cx,cx
		js	loc_ret_a_2F91		; Jump if sign=1
		mov	di,data_b_0402
		sub	di,data_b_0A48
		cmp	cx,di
		jae	loc_ret_a_2F91		; Jump if above or =
		push	ds
		push	bx
		push	cx
		call	sub_a_304A
		pop	di
		pop	si
		push	es
		call	sub_a_30E2
		pop	es
		mov	byte ptr cs:[0A44h],8
loc_a_2FC5:
		mov	ch,byte ptr cs:[0A42h]
loc_a_2FCA:
		push	ax
		push	bx
		mov	dl,es:[bp]
		mov	di,8
loc_a_2FD3:
		mov	cl,byte ptr cs:[0A41h]
		call	sub_a_2FF3
		rol	dl,1			; Rotate
		dec	di
		jnz	loc_a_2FD3		; Jump if not zero
		pop	bx
		call	sub_a_301C
		pop	ax
		dec	ch
		jnz	loc_a_2FCA		; Jump if not zero
		inc	bp
		dec	byte ptr cs:[0A44h]
		jnz	loc_a_2FC5		; Jump if not zero
		pop	ds
		retn
sub_a_2F92	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2FF3	proc	near
loc_a_2FF3:
		test	dl,80h
		jnz	loc_a_2FFA		; Jump if not zero
		jmp	short loc_a_3002
loc_a_2FFA:
		mov	dh,[bx]
		and	dh,ah
		or	dh,al
		mov	[bx],dh
loc_a_3002:
		ror	al,1			; Rotate
		ror	ah,1			; Rotate
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_3012		; Jump if not equal
		ror	al,1			; Rotate
		ror	ah,1			; Rotate
loc_a_3012:
		and	ah,ah
		js	loc_a_3017		; Jump if sign=1
		inc	bx
loc_a_3017:
		dec	cl
		jnz	loc_a_2FF3		; Jump if not zero
		retn
sub_a_2FF3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_301C	proc	near
		mov	al,byte ptr cs:[0A43h]
		cmp	byte ptr cs:[10Bh],4
		jae	loc_a_3032		; Jump if above or =
		call	word ptr cs:[51Eh]
		mov	byte ptr cs:[0A43h],al
		retn
loc_a_3032:
		push	es
		call	word ptr cs:[51Eh]
		mov	byte ptr cs:[0A43h],al
		mov	ax,es
		mov	ds,ax
		pop	es
		retn
sub_a_301C	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_304A	proc	near
		cmp	al,30h			; '0'
		jne	loc_a_3050		; Jump if not equal
		mov	al,4Fh			; 'O'
loc_a_3050:
		xor	ah,ah			; Zero register
		mov	bp,ax
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		cmp	al,41h			; 'A'
		jb	loc_a_3062		; Jump if below
		cmp	al,7Bh			; '{'
		jb	loc_a_3093		; Jump if below
loc_a_3062:
		cmp	al,80h
		jb	loc_a_3088		; Jump if below
		mov	ax,0
		mov	es,ax
		mov	bx,d_0000_007C_e
		sub	bp,400h
		mov	ax,es:[bx]
		and	ax,ax
		jz	loc_a_3085		; Jump if zero
		add	bp,ax
		mov	ax,es:[bx+2]
		mov	es,ax
		and	ax,ax
		jnz	loc_a_3099		; Jump if not zero
loc_a_3085:
		mov	bp,100h
loc_a_3088:
		add	bp,0FA6Eh
		mov	ax,0F000h
		mov	es,ax
		jmp	short loc_a_3099
loc_a_3093:
		push	cs
		pop	es
		add	bp,9F9h
loc_a_3099:
		cmp	byte ptr data_b_0A44+1,0
		je	loc_ret_a_30E1		; Jump if equal
		mov	ax,es:[bp]
		mov	bx,es:[bp+2]
		mov	cx,es:[bp+4]
		mov	dx,es:[bp+6]
		push	cs
		pop	es
		mov	di,0B32h
		mov	bp,8
loc_a_30B8:
		shr	al,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	ah,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	bl,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	bh,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	cl,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	ch,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	dl,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		shr	dh,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		xchg	si,ax
		stosb				; Store al to es:[di]
		xchg	si,ax
		dec	bp
		jnz	loc_a_30B8		; Jump if not zero
		mov	bp,0B32h

loc_ret_a_30E1:
		retn
sub_a_304A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_30E2	proc	near
		call	sub_a_2E65
		mov	byte ptr ds:[0A43h],bl
		mov	al,0FFh
		mov	bl,byte ptr ds:[10Ch]
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		cmp	byte ptr ds:[10Ah],0
		je	loc_a_3100		; Jump if equal
		and	bl,bl
		jz	loc_a_3100		; Jump if zero
		mov	bl,3
loc_a_3100:
		mov	al,byte ptr ds:[951h][bx]
		mov	ah,cl
		not	ah
		and	al,ah
		push	es
		pop	ds
		mov	ah,cl
		mov	bx,di
		retn
sub_a_30E2	endp

		db	 38h, 6Ch,0C6h,0C6h,0FEh,0C6h
		db	0C6h, 00h,0FCh,0C6h,0C6h,0FCh
		db	0C6h,0C6h,0FCh, 00h, 7Ch,0C6h
		db	0C6h,0C0h,0C0h,0C6h, 7Ch, 00h
		db	0F8h,0CCh,0C6h,0C6h,0C6h,0CCh
		db	0F8h, 00h,0FEh,0C0h,0C0h,0FCh
		db	0C0h,0C0h,0FEh, 00h,0FEh,0C0h
		db	0C0h,0FCh,0C0h,0C0h,0C0h, 00h
		db	 7Ch,0C6h,0C0h,0CEh,0C6h,0C6h
		db	 7Eh, 00h,0C6h,0C6h,0C6h,0FEh
		db	0C6h,0C6h,0C6h, 00h, 78h, 30h
		db	 30h, 30h, 30h, 30h, 78h, 00h
		db	 1Eh, 06h, 06h, 06h,0C6h,0C6h
		db	 7Ch, 00h,0C6h,0CCh,0D8h,0F0h
		db	0D8h,0CCh,0C6h, 00h,0C0h,0C0h
		db	0C0h,0C0h,0C0h,0C0h,0FEh, 00h
		db	0C6h,0EEh,0FEh,0D6h,0C6h,0C6h
		db	0C6h, 00h,0C6h,0E6h,0F6h,0DEh
		db	0CEh,0C6h,0C6h, 00h, 7Ch,0C6h
		db	0C6h,0C6h,0C6h,0C6h, 7Ch, 00h
		db	0FCh,0C6h,0C6h,0FCh,0C0h,0C0h
		db	0C0h, 00h, 7Ch,0C6h,0C6h,0C6h
		db	0C6h,0C6h, 7Ch, 06h,0FCh,0C6h
		db	0C6h,0FCh,0C6h,0C6h,0C6h, 00h
		db	 78h,0CCh, 60h, 30h, 18h,0CCh
		db	 78h, 00h,0FCh, 30h, 30h, 30h
		db	 30h, 30h, 30h, 00h,0C6h,0C6h
		db	0C6h,0C6h,0C6h,0C6h, 7Ch, 00h
		db	0C6h,0C6h,0C6h,0C6h,0C6h, 6Ch
		db	 38h, 00h,0C6h,0C6h,0C6h,0D6h
		db	0FEh,0EEh,0C6h, 00h,0C6h,0C6h
		db	 6Ch, 38h, 6Ch,0C6h,0C6h, 00h
		db	0C3h,0C3h, 66h, 3Ch, 18h, 18h
		db	 18h, 00h,0FEh, 0Ch, 18h, 30h
		db	 60h,0C0h,0FEh, 00h, 3Ch, 30h
		db	 30h, 30h, 30h, 30h, 3Ch, 00h
		db	0C0h, 60h, 30h, 18h, 0Ch, 06h
		db	 03h, 00h, 3Ch, 0Ch, 0Ch, 0Ch
		db	 0Ch, 0Ch, 3Ch, 00h, 00h, 38h
		db	 6Ch,0C6h, 00h, 00h
		db	9 dup (0)
		db	0FFh, 30h, 30h, 18h
		db	7 dup (0)
		db	 7Ch, 06h, 7Eh,0C6h, 7Eh, 00h
		db	0C0h,0C0h,0FCh,0C6h,0C6h,0E6h
		db	0DCh, 00h, 00h, 00h, 7Ch,0C6h
		db	0C0h,0C0h, 7Eh, 00h, 06h, 06h
		db	 7Eh,0C6h,0C6h,0CEh, 76h, 00h
		db	 00h, 00h, 7Ch,0C6h,0FEh,0C0h
		db	 7Eh, 00h, 1Eh, 30h, 7Ch, 30h
		db	 30h, 30h, 30h, 00h, 00h, 00h
		db	 7Eh,0C6h,0CEh, 76h, 06h, 7Ch
		db	0C0h,0C0h,0FCh,0C6h,0C6h,0C6h
		db	0C6h, 00h, 18h, 00h, 38h, 18h
		db	 18h, 18h, 3Ch, 00h, 18h, 00h
		db	 38h, 18h, 18h, 18h, 18h,0F0h
		db	0C0h,0C0h,0CCh,0D8h,0F0h,0D8h
		db	0CCh, 00h, 38h, 18h, 18h, 18h
		db	 18h, 18h, 3Ch, 00h, 00h, 00h
		db	0CCh,0FEh,0D6h,0C6h,0C6h, 00h
		db	 00h, 00h,0FCh,0C6h,0C6h,0C6h
		db	0C6h, 00h, 00h, 00h, 7Ch,0C6h
		db	0C6h,0C6h, 7Ch, 00h, 00h, 00h
		db	0FCh,0C6h,0C6h,0E6h,0DCh,0C0h
		db	 00h, 00h, 7Eh,0C6h,0C6h,0CEh
		db	 76h, 06h, 00h, 00h, 6Eh, 70h
		db	 60h, 60h, 60h, 00h, 00h, 00h
		db	 7Ch,0C0h, 7Ch, 06h,0FCh, 00h
		db	 30h, 30h, 7Ch, 30h, 30h, 30h
		db	 1Ch, 00h, 00h, 00h,0C6h,0C6h
		db	0C6h,0C6h, 7Eh, 00h, 00h, 00h
		db	0C6h,0C6h,0C6h, 6Ch, 38h, 00h
		db	 00h, 00h,0C6h,0C6h,0D6h,0FEh
		db	 6Ch, 00h, 00h, 00h,0C6h, 6Ch
		db	 38h, 6Ch,0C6h, 00h, 00h, 00h
		db	0C6h,0C6h,0CEh, 76h, 06h, 7Ch
		db	 00h, 00h,0FCh, 18h, 30h, 60h
		db	0FCh
		db	69 dup (0)
loc_a_3325:
		sub	cx,si
		sub	dx,di
		inc	dx
		mov	ds:data_b_0E12_e,dx
		push	cx
		push	es
		push	bx
		call	sub_a_2E65
		mov	byte ptr ds:[0E14h],bl
		cld				; Clear direction
		push	es
		pop	ds
		mov	si,di
		pop	di
		pop	es
		mov	cl,al
		pop	bx
		mov	dx,bx
		call	sub_a_34BC
		inc	bl
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		cmp	byte ptr cs:[10Ah],0
		je	loc_a_3359		; Jump if equal
		dec	bl
		shr	dx,1			; Shift w/zeros fill
loc_a_3359:
		mov	bl,byte ptr cs:[949h][bx]
		mov	al,byte ptr cs:[0E14h]
loc_a_3362:
		push	ax
		push	dx
		push	si
		call	sub_a_3393
		pop	si
		pop	dx
		pop	ax
		xchg	bx,si
		cmp	byte ptr cs:[10Bh],4
		jb	loc_a_3380		; Jump if below
		push	es
		call	word ptr cs:[51Eh]
		push	es
		pop	ds
		pop	es
		jmp	short loc_a_3385
loc_a_3380:
		call	word ptr cs:[51Eh]
loc_a_3385:
		xchg	bx,si
		dec	word ptr cs:[0E12h]
		jnz	loc_a_3362		; Jump if not zero
		mov	bx,di
		push	cs
		pop	ds
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3393	proc	near
		lodsb				; String [si] to al
		mov	ah,al
loc_a_3396:
		lodsb				; String [si] to al
		mov	ch,al
		shl	ax,cl			; Shift w/zeros fill
		and	dx,dx
		jz	loc_a_33A8		; Jump if zero
		mov	es:[di],ah
		inc	di
		mov	ah,ch
		dec	dx
		jmp	short loc_a_3396
loc_a_33A8:
		and	ah,bl
		mov	es:[di],ah
		inc	di
		retn
sub_a_3393	endp

		db	 00h, 00h, 00h,0BCh, 0Eh,0ACh
		db	 0Eh,0B0h, 0Eh,0B4h, 0Eh,0C9h
		db	 0Eh, 26h, 30h, 05h,0C3h, 26h
		db	 08h, 05h,0C3h,0F6h,0D3h, 0Ah
		db	0C3h, 26h, 20h, 05h,0C3h, 22h
		db	0C3h,0F6h,0D3h, 26h, 22h, 1Dh
		db	 0Ah,0C3h, 26h, 88h, 05h,0C3h
		db	0F6h,0D0h,0EBh,0EFh
loc_a_33DD:
		sub	dx,di
		inc	dx
		mov	ds:data_b_0E12_e,dx
		push	bx
		xor	bh,bh			; Zero register
		mov	bl,al
		shl	bl,1			; Shift w/zeros fill
		add	bx,data_b_0EA2_e
		mov	bx,[bx]
		mov	ds:data_b_0E9F_e,bx
		mov	bx,si
		mov	ax,cx
		sub	ax,bx
		mov	ds:data_b_0EA1_e,al
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		cmp	byte ptr data_b_010A,0
		je	loc_a_340B		; Jump if equal
		shr	ax,1			; Shift w/zeros fill
loc_a_340B:
		inc	ax
		pop	bx
		push	ax
		push	si
		push	cx
		push	es
		push	bx
		call	sub_a_2E65
		mov	byte ptr ds:[0E14h],bl
		cld				; Clear direction
		pop	si
		pop	ds
		mov	cl,al
		pop	bx
		call	sub_a_34BC
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_342C		; Jump if not equal
		inc	bl
loc_a_342C:
		mov	ch,byte ptr cs:[949h][bx]
		pop	bx
		call	sub_a_34BC
		mov	bh,byte ptr cs:[941h][bx]
		mov	bl,ch
		pop	dx
		mov	al,byte ptr cs:[0E14h]
loc_a_3441:
		push	ax
		push	bx
		push	dx
		push	di
		call	sub_a_3461
		pop	di
		pop	dx
		pop	bx
		pop	ax
		xchg	bx,di
		call	word ptr cs:[51Eh]
		xchg	bx,di
		dec	word ptr cs:[0E12h]
		jnz	loc_a_3441		; Jump if not zero
		mov	bx,si
		push	cs
		pop	ds
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3461	proc	near
		push	bx
		lodsb				; String [si] to al
		dec	dx
		xor	ah,ah			; Zero register
		mov	ch,al
		mov	bl,bh
loc_a_346A:
		shr	ax,cl			; Shift w/zeros fill
		and	dx,dx
		jz	loc_a_3480		; Jump if zero
		call	word ptr cs:[0E9Fh]
		mov	bl,0FFh
		inc	di
		mov	ah,ch
		lodsb				; String [si] to al
		mov	ch,al
		dec	dx
		jmp	short loc_a_346A
loc_a_3480:
		mov	dh,3
		cmp	byte ptr cs:[10Ah],0
		je	loc_a_348C		; Jump if equal
		mov	dh,7
loc_a_348C:
		mov	dl,byte ptr cs:[0EA1h]
		and	dl,dh
		sub	dh,dl
		mov	dl,cl
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_34A1		; Jump if not equal
		shr	dl,1			; Shift w/zeros fill
loc_a_34A1:
		cmp	dh,dl
		pop	dx
		jge	loc_a_34B4		; Jump if > or =
		call	word ptr cs:[0E9Fh]
		inc	di
		mov	ah,ch
		xor	al,al			; Zero register
		shr	ax,cl			; Shift w/zeros fill
		mov	bl,0FFh
loc_a_34B4:
		and	bl,dl
		call	word ptr cs:[0E9Fh]
		retn
sub_a_3461	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_34BC	proc	near
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		cmp	byte ptr cs:[10Ah],0
		jne	loc_a_34CD		; Jump if not equal
		and	bl,3
		shl	bl,1			; Shift w/zeros fill
loc_a_34CD:
		mov	al,bl
		retn
sub_a_34BC	endp

			                        ;* No entry point to code
		pop	ss
		adc	[bx],dl
		adc	ds:data_b_9110_e[si],bl
		adc	[bp+si+10h],dl
		cmp	dx,[bx+si]
		mov	[bx+si],ss
		rcl	byte ptr [bx+si],0C0h	; Rotate thru carry
		adc	[bx+di],dh
		adc	ds:data_b_F111_e,sp
;*		adc	ah,bl
		db	 10h,0DCh		;  Fixup - byte match
		adc	[bx+di],ah
		adc	ss:d_0000_8BF0_e[bp+di],cx
		sti				; Enable interrupts
		mov	es,data_b_03F0
		mov	bl,data_b_03F2
		xor	bh,bh			; Zero register
		shl	bl,1			; Shift w/zeros fill
		call	word ptr ds:data_b_0FCE_e[bx]	;*
		mov	dl,al
		xor	dh,dh			; Zero register
		retn
			                        ;* No entry point to code
;*		and	dx,3
		db	 81h,0E2h, 03h, 00h	;  Fixup - byte match
		cmp	byte ptr data_b_010A,0
		je	loc_a_3513		; Jump if equal
		and	dl,1
loc_a_3513:
		mov	si,ax
		mov	di,bx
		mov	es,data_b_03F0
		mov	bl,data_b_03F2
		xor	bh,bh			; Zero register
		shl	bl,1			; Shift w/zeros fill
		jmp	word ptr ds:data_b_0FC0_e[bx]	;*
			                        ;* No entry point to code
		call	sub_a_3646
		mov	ax,si
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	di,ax
;*		and	si,3
		db	 81h,0E6h, 03h, 00h	;  Fixup - byte match
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,dx
		shl	si,1			; Shift w/zeros fill
		mov	ax,ds:data_b_16AD_e[si]
		and	al,es:[di]
		or	al,ah
		mov	es:[di],al
		retn
			                        ;* No entry point to code
		mov	bx,dx
		mov	ax,di
;*		and	di,3
		db	 81h,0E7h, 03h, 00h	;  Fixup - byte match
		shl	di,1			; Shift w/zeros fill
		mov	es,data_b_059E[di]
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	di,50h
		jmp	short loc_a_3577
			                        ;* No entry point to code
		mov	bx,dx
		mov	ax,di
;*		and	di,3
		db	 81h,0E7h, 03h, 00h	;  Fixup - byte match
		shl	di,1			; Shift w/zeros fill
		mov	es,data_b_0564[di]
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	di,d_0000_005A_e
loc_a_3577:
		mul	di			; dx:ax = reg * ax
		mov	di,ax
		mov	ax,si
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	di,ax
;*		and	si,7
		db	 81h,0E6h, 07h, 00h	;  Fixup - byte match
		shl	si,1			; Shift w/zeros fill
		add	si,bx
		shl	si,1			; Shift w/zeros fill
		mov	ax,ds:data_b_16CD_e[si]
		and	al,es:[di]
		or	al,ah
		mov	es:[di],al
		retn
			                        ;* No entry point to code
		mov	ax,5Ah
		jmp	short loc_a_35A4
		db	0B8h, 50h, 00h
loc_a_35A4:
		push	dx
		mul	di			; dx:ax = reg * ax
		pop	dx
		mov	di,ax
		jmp	short loc_a_35AF
		db	0E8h, 97h, 00h
loc_a_35AF:
		mov	ax,si
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	di,ax
;*		and	si,7
		db	 81h,0E6h, 07h, 00h	;  Fixup - byte match
		shl	si,1			; Shift w/zeros fill
		add	si,dx
		shl	si,1			; Shift w/zeros fill
		mov	ax,ds:data_b_16CD_e[si]
		and	al,es:[di]
		or	al,ah
		mov	es:[di],al
		retn
			                        ;* No entry point to code
		call	sub_a_3646
		mov	ax,si
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	cx,si
;*		and	cx,3
		db	 81h,0E1h, 03h, 00h	;  Fixup - byte match
		inc	cx
		shl	cx,1			; Shift w/zeros fill
		mov	al,es:[di]
		rol	al,cl			; Rotate
		and	al,3
		retn
			                        ;* No entry point to code
		mov	ax,di
;*		and	di,3
		db	 81h,0E7h, 03h, 00h	;  Fixup - byte match
		shl	di,1			; Shift w/zeros fill
		mov	es,data_b_059E[di]
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	di,50h
		jmp	short loc_a_3614
			                        ;* No entry point to code
		mov	ax,di
;*		and	di,3
		db	 81h,0E7h, 03h, 00h	;  Fixup - byte match
		shl	di,1			; Shift w/zeros fill
		mov	es,data_b_0564[di]
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	di,offset data_b_005A
loc_a_3614:
		mul	di			; dx:ax = reg * ax
		mov	di,ax
loc_a_3618:
		mov	ax,si
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	cx,si
		and	cl,7
		inc	cl
		mov	al,es:[di]
		rol	al,cl			; Rotate
		and	al,1
		retn
			                        ;* No entry point to code
		mov	ax,5Ah
		jmp	short loc_a_3639
		db	0B8h, 50h, 00h
loc_a_3639:
		push	dx
		mul	di			; dx:ax = reg * ax
		pop	dx
		mov	di,ax
		jmp	short loc_a_3618
		db	0E8h, 02h, 00h,0EBh,0D2h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3646	proc	near
		push	dx
		mov	ax,di
		shr	ax,1			; Shift w/zeros fill
		pushf				; Push flags
		mov	di,50h
		mul	di			; dx:ax = reg * ax
		popf				; Pop flags
		jnc	loc_a_3657		; Jump if carry=0
		add	ax,2000h
loc_a_3657:
		mov	di,ax
		pop	dx
		retn
sub_a_3646	endp

loc_a_365B:
		push	cs
		pop	ds
		call	sub_a_3B03
		call	sub_a_3A83
		cmp	dl,0FFh
		je	loc_a_367D		; Jump if equal
		cmp	dl,4
		jb	loc_a_366F		; Jump if below
		mov	dl,3
loc_a_366F:
		cmp	byte ptr ds:[10Ah],0
		je	loc_a_367D		; Jump if equal
		cmp	dl,2
		jb	loc_a_367D		; Jump if below
		mov	dl,1
loc_a_367D:
		mov	byte ptr ds:[0E02h],dl
		mov	bh,al
		mov	word ptr ds:[0E03h],bx
		mov	word ptr ds:[0DEEh],sp
		mov	byte ptr ds:[0E0Ah],0
		mov	bp,sp
		sub	bp,80h
		mov	bl,dh
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		mov	dh,byte ptr ds:[951h][bx]
		cmp	byte ptr ds:[10Ah],0
		je	loc_a_36AD		; Jump if equal
		and	dh,dh
		jz	loc_a_36AD		; Jump if zero
		mov	dh,0FFh
loc_a_36AD:
		push	dx
		mov	ax,0FFFFh
		dec	bp
		dec	bp
		mov	[bp],ax
		mov	ax,word ptr ds:[3FAh]
		sub	ax,di
		dec	bp
		dec	bp
		mov	[bp],ax
		mov	word ptr ds:[0DF6h],ax
		mov	word ptr ds:[0DFAh],0
		mov	ax,word ptr ds:[400h]
		mov	word ptr ds:[0DFEh],ax
		dec	bp
		dec	bp
		mov	[bp],si
		mov	byte ptr ds:[0E06h],0
		call	sub_a_3AA5
		dec	bp
		dec	bp
		mov	[bp],di
		not	cl
		pop	dx
		call	sub_a_3A53
		call	sub_a_39DE
		mov	al,es:[di]
		and	al,cl
		mov	ah,dh
		and	ah,cl
		cmp	al,ah
		je	loc_a_3716		; Jump if equal
		xor	ch,ch			; Zero register
		jmp	short loc_a_3720
loc_a_36FB:
		pop	bx
		mov	ds:data_b_0DF6_e,bx
		mov	ax,ds:data_b_0DF2_e
		mov	ds:data_b_0DFA_e,ax
		mov	ax,ds:data_b_0DF0_e
		mov	ds:data_b_0DFE_e,ax
		mov	cx,[bp]
		inc	bp
		inc	bp
;*		cmp	cx,0FFFFh
		db	 83h,0F9h,0FFh		;  Fixup - byte match
		jnz	loc_a_3720		; Jump if not zero
loc_a_3716:
		mov	sp,ds:data_b_0DEE_e
		mov	al,ds:data_b_0E0A_e
		ror	al,1			; Rotate
		retn
loc_a_3720:
		mov	di,[bp]
		inc	bp
		inc	bp
		mov	si,[bp]
		inc	bp
		inc	bp
		mov	bx,[bp]
		inc	bp
		inc	bp
		call	sub_a_3B55
		push	bx
		mov	al,ch
		push	ax
		call	sub_a_385D
		call	sub_a_37B4
		pop	ax
		test	al,2
		jz	loc_a_3747		; Jump if zero
		test	al,80h
		jnz	loc_a_3753		; Jump if not zero
		jmp	short loc_a_3760
loc_a_3747:
		cmp	byte ptr ds:data_b_0E06_e,0
		jne	loc_a_375D		; Jump if not equal
		call	sub_a_3765
		jnc	loc_a_3758		; Jump if carry=0
loc_a_3753:
		call	sub_a_378B
		jmp	short loc_a_36FB
loc_a_3758:
		call	sub_a_3780
		jc	loc_a_3760		; Jump if carry Set
loc_a_375D:
		call	sub_a_378B
loc_a_3760:
		call	sub_a_379E
		jmp	short loc_a_36FB

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3765	proc	near
		mov	ax,ds:data_b_0DF6_e
		inc	ax
		cmp	ax,bx
		jne	loc_a_3788		; Jump if not equal
loc_a_376D:
		mov	ax,ds:data_b_0DFA_e
		dec	ax
		cmp	ds:data_b_0DF2_e,ax
		jle	loc_a_3788		; Jump if < or =
		mov	ax,ds:data_b_0DFE_e
		inc	ax
		cmp	ds:data_b_0DF0_e,ax
		retn

;==== External Entry into Subroutine ======================================

sub_a_3780:
		mov	ax,ds:data_b_0DF6_e
		dec	ax
		cmp	ax,bx
		je	loc_a_376D		; Jump if equal
loc_a_3788:
		xor	al,al			; Zero register
		retn
sub_a_3765	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_378B	proc	near
		cmp	bx,ds:data_b_0DEA_e
		jae	loc_ret_a_379D		; Jump if above or =
		call	word ptr ds:data_b_0DE2_e
		call	sub_a_39DE
		mov	ch,80h
		call	sub_a_38D1

loc_ret_a_379D:
		retn
sub_a_378B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_379E	proc	near
		call	sub_a_3A39
		cmp	bx,ds:data_b_0DE8_e
		je	loc_ret_a_37B3		; Jump if equal
		call	word ptr ds:data_b_0DE0_e
		call	sub_a_39DE
		xor	ch,ch			; Zero register
		call	sub_a_38D1

loc_ret_a_37B3:
		retn
sub_a_379E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_37B4	proc	near
		mov	ch,es:[di]
		cmp	si,data_b_03FC
		je	loc_a_37D6		; Jump if equal
		dec	si
		rol	cl,1			; Rotate
		cmp	byte ptr data_b_010A,0
		jne	loc_a_37C9		; Jump if not equal
		rol	cl,1			; Rotate
loc_a_37C9:
		test	cl,1
		jz	loc_a_37D6		; Jump if zero
		dec	di
		xchg	ds:data_b_0E07_e,dl
		mov	ch,es:[di]
loc_a_37D6:
		mov	al,ch
		and	al,cl
		mov	ah,dh
		and	ah,cl
		cmp	al,ah
		je	loc_a_381A		; Jump if equal
		mov	al,dl
		and	al,cl
		mov	ah,cl
		not	ah
		and	ch,ah
		or	ch,al
		cmp	si,data_b_03FC
		je	loc_a_381A		; Jump if equal
		dec	si
		rol	cl,1			; Rotate
		cmp	byte ptr data_b_010A,0
		jne	loc_a_3800		; Jump if not equal
		rol	cl,1			; Rotate
loc_a_3800:
		test	cl,1
		jz	loc_a_3810		; Jump if zero
		mov	es:[di],ch
		dec	di
		xchg	ds:data_b_0E07_e,dl
		mov	ch,es:[di]
loc_a_3810:
		test	cl,1
		jz	loc_a_37D6		; Jump if zero
		call	sub_a_383E
		jmp	short loc_a_37D6
loc_a_381A:
		mov	es:[di],ch
		inc	si
		ror	cl,1			; Rotate
		cmp	byte ptr data_b_010A,0
		jne	loc_a_3829		; Jump if not equal
		ror	cl,1			; Rotate
loc_a_3829:
		test	cl,80h
		jz	loc_a_3836		; Jump if zero
		inc	di
		xchg	ds:data_b_0E07_e,dl
		mov	ch,es:[di]
loc_a_3836:
		mov	ds:data_b_0DF2_e,si
		call	sub_a_39C1
		retn
sub_a_37B4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_383E	proc	near
		mov	al,ds:data_b_0E05_e
loc_a_3841:
		mov	ch,es:[di]
		cmp	ch,al
		jne	loc_ret_a_385C		; Jump if not equal
		mov	es:[di],dl
		cmp	si,ds:data_b_0DE4_e
		jl	loc_ret_a_385C		; Jump if <
		sub	si,ds:data_b_0DEC_e
		dec	di
		xchg	ds:data_b_0E07_e,dl
		jmp	short loc_a_3841

loc_ret_a_385C:
		retn
sub_a_383E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_385D	proc	near
		call	sub_a_39C1
		mov	ch,es:[di]
loc_a_3863:
		mov	al,ch
		and	al,cl
		mov	ah,dh
		and	ah,cl
		cmp	al,ah
		je	loc_a_38A7		; Jump if equal
		mov	al,dl
		and	al,cl
		mov	ah,cl
		not	ah
		and	ch,ah
		or	ch,al
		cmp	si,data_b_0400
		jge	loc_a_38A7		; Jump if > or =
		inc	si
		ror	cl,1			; Rotate
		cmp	byte ptr data_b_010A,0
		jne	loc_a_388D		; Jump if not equal
		ror	cl,1			; Rotate
loc_a_388D:
		test	cl,80h
		jz	loc_a_389D		; Jump if zero
		mov	es:[di],ch
		inc	di
		xchg	ds:data_b_0E07_e,dl
		mov	ch,es:[di]
loc_a_389D:
		test	cl,80h
		jz	loc_a_3863		; Jump if zero
		call	sub_a_38B2
		jmp	short loc_a_3863
loc_a_38A7:
		mov	es:[di],ch
		dec	si
		mov	ds:data_b_0DF0_e,si
		jmp	loc_a_3A39

;==== External Entry into Subroutine ======================================

sub_a_38B2:
		mov	al,ds:data_b_0E05_e
loc_a_38B5:
		mov	ch,es:[di]
		cmp	ch,al
		jne	loc_ret_a_38D0		; Jump if not equal
		mov	es:[di],dl
		cmp	si,ds:data_b_0DE6_e
		jae	loc_ret_a_38D0		; Jump if above or =
		add	si,ds:data_b_0DEC_e
		inc	di
		xchg	ds:data_b_0E07_e,dl
		jmp	short loc_a_38B5

loc_ret_a_38D0:
		retn

;==== External Entry into Subroutine ======================================

sub_a_38D1:
		and	ch,80h
		jmp	short loc_a_38EF
loc_a_38D6:
		inc	si
		ror	cl,1			; Rotate
		cmp	byte ptr data_b_010A,0
		jne	loc_a_38E2		; Jump if not equal
		ror	cl,1			; Rotate
loc_a_38E2:
		test	cl,80h
		jz	loc_a_38EF		; Jump if zero
		xchg	ds:data_b_0E07_e,dl
		inc	di
		call	sub_a_399A
loc_a_38EF:
		mov	al,es:[di]
		and	al,cl
		mov	ah,dh
		and	ah,cl
		cmp	al,ah
		jne	loc_a_3901		; Jump if not equal
		and	ch,0FEh
		jmp	short loc_a_395F
loc_a_3901:
		cmp	byte ptr ds:data_b_0E02_e,0FFh
		jne	loc_a_3910		; Jump if not equal
		mov	ah,dl
		or	ah,ds:data_b_0E07_e
		jz	loc_a_391D		; Jump if zero
loc_a_3910:
		cmp	byte ptr ds:data_b_0E03_e,0
		je	loc_a_3927		; Jump if equal
		cmp	dl,ds:data_b_0E04_e
		jne	loc_a_3927		; Jump if not equal
loc_a_391D:
		or	ch,2
		mov	byte ptr ds:data_b_0E06_e,0FFh
		jmp	short loc_a_393E
loc_a_3927:
		test	cl,80h
		jz	loc_a_3936		; Jump if zero
		call	sub_a_396E
		jnz	loc_a_3936		; Jump if not zero
		and	ch,0FEh
		jmp	short loc_a_395F
loc_a_3936:
		mov	ah,dl
		and	ah,cl
		cmp	ah,al
		je	loc_a_395F		; Jump if equal
loc_a_393E:
		test	ch,1
		jnz	loc_a_395F		; Jump if not zero
		or	ch,1
		cmp	bp,0Eh
		jb	loc_a_3968		; Jump if below
		dec	bp
		dec	bp
		mov	[bp],bx
		dec	bp
		dec	bp
		mov	[bp],si
		dec	bp
		dec	bp
		mov	[bp],di
		dec	bp
		dec	bp
		mov	[bp],cx
loc_a_395F:
		cmp	si,ds:data_b_0DF0_e
		jae	loc_ret_a_396D		; Jump if above or =
		jmp	loc_a_38D6
loc_a_3968:
		mov	byte ptr ds:data_b_0E0A_e,0FFh

loc_ret_a_396D:
		retn

;==== External Entry into Subroutine ======================================

sub_a_396E:
		cmp	dl,es:[di]
		jne	loc_ret_a_3999		; Jump if not equal
		mov	ax,ds:data_b_0DF0_e
		sub	ax,ds:data_b_0DEC_e
loc_a_397A:
		cmp	dl,es:[di]
		jne	loc_a_398E		; Jump if not equal
		cmp	si,ax
		jg	loc_a_398E		; Jump if >
		add	si,ds:data_b_0DEC_e
		inc	di
		xchg	ds:data_b_0E07_e,dl
		jmp	short loc_a_397A
loc_a_398E:
		mov	al,es:[di]
		and	al,cl
		mov	ah,dh
		and	ah,cl
		cmp	ah,al

loc_ret_a_3999:
		retn

;==== External Entry into Subroutine ======================================

sub_a_399A:
		test	ch,1
		jz	loc_ret_a_39C0		; Jump if zero
		mov	ax,ds:data_b_0DF0_e
		sub	ax,ds:data_b_0DEC_e
		push	cx
		mov	ch,ds:data_b_0E05_e
loc_a_39AB:
		cmp	ch,es:[di]
		jne	loc_a_39BF		; Jump if not equal
		cmp	si,ax
		jae	loc_a_39BF		; Jump if above or =
		add	si,ds:data_b_0DEC_e
		inc	di
		xchg	ds:data_b_0E07_e,dl
		jmp	short loc_a_39AB
loc_a_39BF:
		pop	cx

loc_ret_a_39C0:
		retn

;==== External Entry into Subroutine ======================================

sub_a_39C1:
		mov	ds:data_b_0E0B_e,si
		mov	ds:data_b_0E0D_e,bx
		mov	ds:data_b_0E0F_e,di
		mov	ds:data_b_0E11_e,cl
		call	sub_a_39DE
		mov	al,dl
		mov	ah,ds:data_b_0E07_e
		mov	ds:data_b_0E08_e,ax
		retn

;==== External Entry into Subroutine ======================================

sub_a_39DE:
		mov	ax,bx
		mov	bl,byte ptr ds:[0E02h]
		cmp	bl,0FFh
		je	loc_a_3A05		; Jump if equal
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		mov	dl,byte ptr ds:[951h][bx]
		mov	bx,ax
		cmp	byte ptr ds:[10Ah],0
		je	loc_a_3A00		; Jump if equal
		and	dl,dl
		jz	loc_a_3A00		; Jump if zero
		mov	dl,0FFh
loc_a_3A00:
		mov	byte ptr ds:[0E07h],dl
		retn
loc_a_3A05:
		push	ax
		push	dx
		neg	ax
		add	ax,word ptr ds:[3FAh]
		and	ax,7
		cmp	byte ptr ds:[10Ah],0
		jne	loc_a_3A19		; Jump if not equal
		shl	ax,1			; Shift w/zeros fill
loc_a_3A19:
		mov	bx,ax
		pop	dx
		mov	ax,word ptr ds:[34Ch][bx]
		mov	dl,al
		cmp	byte ptr ds:[10Ah],0
		je	loc_a_3A2B		; Jump if equal
		mov	ah,al
loc_a_3A2B:
		test	si,4
		jnz	loc_a_3A33		; Jump if not zero
		xchg	ah,dl
loc_a_3A33:
		mov	byte ptr ds:[0E07h],ah
		pop	bx
		retn

;==== External Entry into Subroutine ======================================

sub_a_3A39:
loc_a_3A39:
		mov	si,ds:data_b_0E0B_e
		mov	bx,ds:data_b_0E0D_e
		mov	di,ds:data_b_0E0F_e
		mov	cl,ds:data_b_0E11_e
		mov	ax,ds:data_b_0E08_e
		mov	ds:data_b_0E07_e,ah
		mov	dl,al
		retn
sub_a_385D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3A53	proc	near
		mov	al,es:[di]
		cmp	byte ptr ds:[10Ah],0
		jne	loc_a_3A75		; Jump if not equal
		mov	byte ptr ds:[0E05h],al
		xor	al,dh
		mov	ah,3
loc_a_3A64:
		test	al,ah
		jz	loc_a_3A79		; Jump if zero
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		jnc	loc_a_3A64		; Jump if carry=0
		retn
loc_a_3A6F:
		mov	byte ptr ds:[0E05h],0
		retn
loc_a_3A75:
		and	al,al
		jz	loc_a_3A6F		; Jump if zero
loc_a_3A79:
		and	dh,dh
		jnz	loc_a_3A6F		; Jump if not zero
		mov	byte ptr ds:[0E05h],0FFh
		retn
sub_a_3A53	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3A83	proc	near
		cmp	dl,0FFh
		jne	loc_ret_a_3AA4		; Jump if not equal
		push	bx
		push	cx
		push	ax
		mov	bx,34Ch
		mov	cx,word ptr ds:[34Ah]
		jcxz	loc_a_3A9F		; Jump if cx=0
		xor	al,al			; Zero register

locloop_a_3A96:
		or	al,[bx]
		inc	bx
		loop	locloop_a_3A96		; Loop if cx > 0

		and	al,al
		jnz	loc_a_3AA1		; Jump if not zero
loc_a_3A9F:
		xor	dl,dl			; Zero register
loc_a_3AA1:
		pop	ax
		pop	cx
		pop	bx

loc_ret_a_3AA4:
		retn
sub_a_3A83	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3AA5	proc	near
		call	sub_a_2E67
		push	ax
		mov	word ptr ds:[0DECh],4
		cmp	byte ptr ds:[10Ah],0
		je	loc_a_3ABC		; Jump if equal
		mov	word ptr ds:[0DECh],8
loc_a_3ABC:
		mov	ax,word ptr ds:[3FCh]
		add	ax,word ptr ds:[0DECh]
		mov	word ptr ds:[0DE4h],ax
		mov	ax,word ptr ds:[400h]
		sub	ax,word ptr ds:[0DECh]
		inc	ax
		mov	word ptr ds:[0DE6h],ax
		mov	ax,word ptr ds:[3FAh]
		sub	ax,word ptr ds:[402h]
		mov	word ptr ds:[0DE8h],ax
		mov	ax,word ptr ds:[3FAh]
		sub	ax,word ptr ds:[3FEh]
		mov	word ptr ds:[0DEAh],ax
		pop	ax
		retn
sub_a_3AA5	endp

		db	 11h, 16h, 21h, 16h, 11h, 16h
		db	 21h, 16h, 11h, 16h, 21h, 16h
		db	 31h, 16h, 36h, 16h, 5Dh, 16h
		db	 73h, 16h, 85h, 16h, 9Bh, 16h
		db	 3Bh, 16h, 40h, 16h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3B03	proc	near
		push	ax
		push	bx
		mov	bl,byte ptr ds:[3F2h]
		shl	bl,1			; Shift w/zeros fill
		shl	bl,1			; Shift w/zeros fill
		xor	bh,bh			; Zero register
		add	bx,15D7h
		mov	ax,[bx]
		mov	word ptr ds:[0DE0h],ax
		mov	ax,[bx+2]
		mov	word ptr ds:[0DE2h],ax
		pop	bx
		pop	ax
		retn
sub_a_3B03	endp

			                        ;* No entry point to code
		dec	bx
		test	bl,1
		jnz	loc_a_3B2C		; Jump if not zero
		add	di,2000h
		retn
loc_a_3B2C:
		sub	di,1FB0h
		retn
			                        ;* No entry point to code
		inc	bx
		test	bl,1
		jnz	loc_a_3B3C		; Jump if not zero
		add	di,1FB0h
		retn
loc_a_3B3C:
		sub	di,2000h
		retn
			                        ;* No entry point to code
		dec	bx
		add	di,50h
		retn
			                        ;* No entry point to code
		inc	bx
		sub	di,50h
		retn
			                        ;* No entry point to code
		dec	bx
		add	di,5Ah
		retn
		db	 43h, 83h,0EFh, 5Ah,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3B55	proc	near
		mov	al,data_b_03F2
		cmp	al,4
		jb	loc_ret_a_3B82		; Jump if below
		cmp	al,6
		jae	loc_ret_a_3B82		; Jump if above or =
		push	bx
		not	bl
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		cmp	al,5
		je	loc_a_3BA2		; Jump if equal
		jmp	short loc_a_3B7A
			                        ;* No entry point to code
		dec	bx
		push	bx
		not	bl
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		jnz	loc_a_3B7A		; Jump if not zero
		add	di,5Ah
loc_a_3B7A:
		shl	bl,1			; Shift w/zeros fill
		mov	es,word ptr cs:[564h][bx]
		pop	bx

loc_ret_a_3B82:
		retn
			                        ;* No entry point to code
		inc	bx
		push	bx
		not	bl
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		cmp	bl,3
		jne	loc_a_3B7A		; Jump if not equal
		sub	di,5Ah
		jmp	short loc_a_3B7A
			                        ;* No entry point to code
		dec	bx
		push	bx
		not	bl
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		jnz	loc_a_3BA2		; Jump if not zero
		add	di,50h
loc_a_3BA2:
		shl	bl,1			; Shift w/zeros fill
		mov	es,word ptr cs:[59Eh][bx]
		pop	bx
		retn
sub_a_3B55	endp

			                        ;* No entry point to code
		inc	bx
		push	bx
		not	bl
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		cmp	bl,3
		jne	loc_a_3BA2		; Jump if not equal
		sub	di,50h
		jmp	short loc_a_3BA2
			                        ;* No entry point to code
		aas				; Ascii adjust
		add	[bx],bh
		inc	ax
		aas				; Ascii adjust
		cmp	byte ptr [bx],0C0h
		iret				; Interrupt return
		db	 00h,0CFh, 10h,0CFh, 20h,0CFh
		db	 30h,0F3h, 00h,0F3h, 04h,0F3h
		db	 08h,0F3h, 0Ch,0FCh, 00h,0FCh
		db	 01h,0FCh, 02h,0FCh, 03h, 7Fh
		db	 00h, 7Fh, 80h,0BFh, 00h,0BFh
		db	 40h,0DFh, 00h,0DFh, 20h,0EFh
		db	 00h,0EFh, 10h,0F7h, 00h,0F7h
		db	 08h,0FBh, 00h,0FBh, 04h,0FDh
		db	 00h,0FDh, 02h,0FEh, 00h,0FEh
		db	 01h, 55h, 8Bh,0ECh, 83h, 3Eh
		db	 70h, 03h, 20h, 75h, 05h,0B8h
		db	 01h, 00h,0EBh, 13h, 8Bh, 46h
		db	 04h, 8Bh, 1Eh, 70h, 03h,0D1h
		db	0E3h, 89h, 87h, 52h, 0Ah,0FFh
		db	 06h, 70h, 03h, 33h,0C0h, 5Dh
		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C21	proc	near
		int	11h			; Put equipment bits in ax
		retn
sub_a_3C21	endp

			                        ;* No entry point to code
		int	12h			; Put (memory size)/1K in ax
		retn
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	ah,[bp+4]
		mov	cx,[bp+8]
		mov	dx,[bp+6]
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		mov	dx,cx
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C3B	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		mov	ah,[bp+PARAMETER_1]
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		jnz	loc_a_3C4D		; Jump if not zero
		cmp	byte ptr [bp+PARAMETER_1],1
		jne	loc_a_3C4D		; Jump if not equal
		xor	ax,ax			; Zero register
loc_a_3C4D:
		pop	bp
		retn
sub_a_3C3B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C4F	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	dx,sp
		sub	dx,100h
		cmp	ax,dx
		jae	loc_a_3C64		; Jump if above or =
		mov	ds:d_0000_008E_e,ax
		jmp	short loc_a_3C6D
loc_a_3C64:
		mov	word ptr ds:d_0000_0088_e,8
		mov	ax,0FFFFh
loc_a_3C6D:
		pop	bp
		retn
sub_a_3C4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3C6F	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	dx,[bp+PARAMETER_2]
		add	ax,data_b_008E
		adc	dx,0
		mov	cx,ax
		add	cx,100h
		adc	dx,0
		or	dx,dx			; Zero ?
		jnz	loc_a_3C96		; Jump if not zero
		cmp	cx,sp
		jae	loc_a_3C96		; Jump if above or =
		xchg	data_b_008E,ax
		jmp	short loc_a_3C9F
loc_a_3C96:
		mov	data_b_0088,8
		mov	ax,0FFFFh
loc_a_3C9F:
		pop	bp
		retn
sub_a_3C6F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3CA1	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_1]	; PARAMETER_1
		call	sub_a_3C4F
		pop	cx
		pop	bp
		retn
sub_a_3CA1	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	ax,[bp+4]
		cwd				; Word to double word
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_3C6F
		mov	sp,bp
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Close file

sub_a_3CBD	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+6]
		mov	ah,3Eh			; '>'
		mov	bx,si
		int	21h			; DOS Services  ah=function 3Eh
						;  close file, bx=file handle
		jc	loc_a_3CD8		; Jump if carry Set
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_03E8[bx],0FFFFh
		xor	ax,ax			; Zero register
		jmp	short loc_a_3CDC
loc_a_3CD8:
		push	ax
		call	sub_a_42F2
loc_a_3CDC:
		pop	bp
		pop	si
		retn
sub_a_3CBD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3CDF	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,4
		mov	byte ptr [bp-3],0
		call	sub_a_50E0
		mov	ah,0
		mov	si,ax
		call	sub_a_50E0
		mov	cx,8
		shr	ax,cl			; Shift w/zeros fill
		mov	ah,0
		mov	di,ax
loc_a_3CFE:
		mov	ax,[bp+0Ah]
		dec	word ptr [bp+0Ah]
		or	ax,ax			; Zero ?
		jnz	loc_a_3D0B		; Jump if not zero
		jmp	loc_a_3E04
loc_a_3D0B:
		mov	bx,[bp+0Ch]
		inc	word ptr [bp+0Ch]
		mov	al,[bx]
		mov	[bp-3],al
		mov	ah,0
		cmp	ax,0Dh
		ja	loc_a_3D70		; Jump if above
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_3D26[bx]	;*14 entries
data_a_3D26	dw	offset loc_a_3D42	; Data table (indexed access)
data_a_3D28	dw	offset loc_a_3D70
data_a_3D2A	dw	offset loc_a_3D70
data_a_3D2C	dw	offset loc_a_3D70
data_a_3D2E	dw	offset loc_a_3D70
data_a_3D30	dw	offset loc_a_3D70
data_a_3D32	dw	offset loc_a_3D70
data_a_3D34	dw	offset loc_a_3D47
data_a_3D36	dw	offset loc_a_3D51
data_a_3D38	dw	offset loc_a_3D70
data_a_3D3A	dw	offset loc_a_3D66
data_a_3D3C	dw	offset loc_a_3D70
data_a_3D3E	dw	offset loc_a_3D70
data_a_3D40	dw	offset loc_a_3D5D

;===== Indexed Entry Point ================================================

loc_a_3D42:
		xor	ax,ax			; Zero register
		jmp	loc_a_3E18

;===== Indexed Entry Point ================================================

loc_a_3D47:
		mov	ah,0Eh
		mov	al,7
		call	sub_a_3E83
		jmpn	loc_a_3DC4

;===== Indexed Entry Point ================================================

loc_a_3D51:
		mov	al,byte ptr data_b_0372
		mov	ah,0
		cmp	ax,si
		jge	loc_a_3DC4		; Jump if > or =
		dec	si
		jmp	short loc_a_3DC4

;===== Indexed Entry Point ================================================

loc_a_3D5D:
		mov	al,byte ptr data_b_0372
		mov	ah,0
		mov	si,ax
		jmp	short loc_a_3DC4

;===== Indexed Entry Point ================================================

loc_a_3D66:
		mov	al,byte ptr data_b_0374
		mov	ah,0
		mov	si,ax
		inc	si
		jmp	short loc_a_3DC4

;===== Indexed Entry Point ================================================

loc_a_3D70:
		cmp	byte ptr data_b_037B,0
		jne	loc_a_3DA3		; Jump if not equal
		cmp	data_b_0381,0
		je	loc_a_3DA3		; Jump if equal
		mov	ah,data_b_0376
		mov	al,[bp-3]
		mov	[bp-2],ax
		mov	ax,si
		inc	ax
		push	ax			; PARAMETER_2
		mov	ax,di
		inc	ax
		push	ax			; PARAMETER_1
		call	sub_a_5045
		push	dx
		push	ax
		push	ss
		lea	ax,[bp-2]		; Load effective addr
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_5068
		jmp	short loc_a_3DC3
loc_a_3DA3:
		mov	ax,si
		mov	dl,al
		mov	ax,di
		mov	dh,al
		mov	ah,2
		mov	bh,0
		call	sub_a_3E83
		mov	bl,data_b_0376
		mov	al,[bp-3]
		mov	ah,9
		mov	bh,0
		mov	cx,1
		call	sub_a_3E83
loc_a_3DC3:
		inc	si
loc_a_3DC4:
		mov	al,byte ptr data_b_0374
		mov	ah,0
		cmp	ax,si
		jl	loc_a_3DD0		; Jump if <
		jmp	loc_a_3CFE
loc_a_3DD0:
		mov	al,byte ptr data_b_0372
		mov	ah,0
		mov	si,ax
		inc	di
		mov	ax,di
		mov	dl,byte ptr data_b_0374+1
		mov	dh,0
		cmp	ax,dx
		jg	loc_a_3DE7		; Jump if >
		jmp	loc_a_3CFE
loc_a_3DE7:
		mov	al,6
		push	ax			; PARAMETER_6
		push	data_b_0372		; PARAMETER_5
		push	word ptr data_b_0372+1	; PARAMETER_4
		push	data_b_0374		; PARAMETER_3
		push	word ptr data_b_0374+1	; PARAMETER_2
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_a_46BA
		dec	di
		jmp	loc_a_3CFE
loc_a_3E04:
		mov	ax,si
		mov	dl,al
		mov	ax,di
		mov	dh,al
		mov	ah,2
		mov	bh,0
		call	sub_a_3E83
		mov	al,[bp-3]
		mov	ah,0
loc_a_3E18:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn	6
sub_a_3CDF	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	ax,3CDFh
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	word ptr [bp+4]
		lea	ax,[bp+6]		; Load effective addr
		push	ax
		call	sub_a_4BA4
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3E36	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_1]
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_4B5E
		pop	cx
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_3CDF
		pop	bp
		retn
sub_a_3E36	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3E4C	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
loc_a_3E4F:
		mov	bx,[bp+PARAMETER_1]
		cmp	byte ptr [bx],0
		je	loc_a_3E6B		; Jump if equal
		inc	word ptr [bp+PARAMETER_1]
		mov	al,[bx]
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		inc	word ptr [bp+PARAMETER_2]
		cmp	al,es:[bx]
		je	loc_a_3E4F		; Jump if equal
		xor	ax,ax			; Zero register
		jmp	short loc_a_3E6E
loc_a_3E6B:
		mov	ax,1
loc_a_3E6E:
		pop	bp
		retn	6
sub_a_3E4C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3E72	proc	near
		mov	ax,1130h
		mov	bh,0
		mov	dl,0FFh
		call	sub_a_3E83
		mov	al,dl
		inc	al
		mov	ah,0
		retn
sub_a_3E72	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3E83	proc	near
		push	si
		push	di
		mov	data_b_0A92,bp
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		mov	bp,data_b_0A92
		pop	di
		pop	si
		retn
sub_a_3E83	endp

			                        ;* No entry point to code
		mov	ah,0Fh
		call	sub_a_3E83
		push	ax			; PARAMETER_1
		call	sub_a_3EAF
		pop	cx
		mov	ah,8
		mov	bh,0
		call	sub_a_3E83
		and	ah,7Fh
		mov	data_b_0377,ah
		mov	data_b_0376,ah
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3EAF	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	al,[bp+PARAMETER_1]
		cmp	al,3
		jbe	loc_a_3EBF		; Jump if below or =
		cmp	al,7
		je	loc_a_3EBF		; Jump if equal
		mov	al,3
loc_a_3EBF:
		mov	data_b_0378,al
		mov	ah,0Fh
		call	sub_a_3E83
		mov	al,al
		cmp	al,data_b_0378
		je	loc_a_3EDF		; Jump if equal
		mov	al,data_b_0378
		mov	ah,0
		call	sub_a_3E83
		mov	ah,0Fh
		call	sub_a_3E83
		mov	data_b_0378,al
loc_a_3EDF:
		mov	data_b_037A,ah
		cmp	byte ptr data_b_0378,3
		jbe	loc_a_3EF6		; Jump if below or =
		cmp	byte ptr data_b_0378,7
		je	loc_a_3EF6		; Jump if equal
		mov	ax,1
		jmp	short loc_a_3EF8
loc_a_3EF6:
		xor	ax,ax			; Zero register
loc_a_3EF8:
		mov	data_b_037B,al
		mov	byte ptr data_b_0379,19h
		cmp	byte ptr data_b_0378,7
		je	loc_a_3F26		; Jump if equal
		mov	dx,0F000h
		mov	ax,0FFEAh
		push	dx
		push	ax			; PARAMETER_2
		mov	ax,383h
		push	ax			; PARAMETER_1
		call	sub_a_3E4C
		or	ax,ax			; Zero ?
		jnz	loc_a_3F26		; Jump if not zero
		call	sub_a_3E72
		or	ax,ax			; Zero ?
		jnz	loc_a_3F26		; Jump if not zero
		mov	ax,1
		jmp	short loc_a_3F28
loc_a_3F26:
		xor	ax,ax			; Zero register
loc_a_3F28:
		mov	data_b_037C,al
		cmp	byte ptr data_b_0378,7
		jne	loc_a_3F37		; Jump if not equal
		mov	ax,0B000h
		jmp	short loc_a_3F3A
loc_a_3F37:
		mov	ax,0B800h
loc_a_3F3A:
		mov	data_b_037F,ax
		mov	data_b_037D,0
		mov	al,0
		mov	byte ptr data_b_0372+1,al
		mov	byte ptr data_b_0372,al
		mov	al,data_b_037A
		add	al,0FFh
		mov	byte ptr data_b_0374,al
		mov	byte ptr data_b_0374+1,18h
		pop	bp
		retn
sub_a_3EAF	endp

			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		mov	cx,2Ch
		nop
		mov	dx,38Ah
		jmp	short loc_a_3F6D
			                        ;* No entry point to code
		mov	cx,2Bh
		nop
		mov	dx,offset data_b_0383+33h	; ('scanf : floating')
		jmp	short loc_a_3F6D
loc_a_3F6D:
		mov	ah,40h			; '@'
		mov	bx,2
		int	21h			; DOS Services  ah=function 40h
						;  write file  bx=file handle
						;   cx=bytes from ds:dx buffer
		jmp	loc_a_018D
		db	0
data_a_3F78	dw	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3F7A	proc	near
		dec	sp
		dec	sp
		push	bp
		mov	bp,sp
		push	si
		push	di
		push	ds
		push	es
		mov	cx,[bp+6]
		mov	ax,cs:data_a_3F78
		or	ax,ax			; Zero ?
		jnz	loc_a_3FB1		; Jump if not zero
		mov	ax,40h
		mov	es,ax
		mov	bx,es:d_0040_006C_e
		call	sub_a_3FD5
		sub	bx,es:d_0040_006C_e
		neg	bx
		mov	ax,37h
		mul	bx			; dx:ax = reg * ax
		cmp	cx,ax
		jbe	loc_a_3FC9		; Jump if below or =
		sub	cx,ax
		mov	ax,cs:data_a_3F78
loc_a_3FB1:
		xor	bx,bx			; Zero register
		mov	es,bx
		mov	dl,es:[bx]
		jcxz	loc_a_3FC9		; Jump if cx=0

locloop_a_3FBA:
		mov	si,cx
		mov	cx,ax

locloop_a_3FBE:
		cmp	dl,es:[bx]
		jnz	$+2			; delay for I/O
		loop	locloop_a_3FBE		; Loop if cx > 0

		mov	cx,si
		loop	locloop_a_3FBA		; Loop if cx > 0

loc_a_3FC9:
		mov	ax,cs:data_a_3F78
		pop	es
		pop	ds
		pop	di
		pop	si
		pop	bp
		inc	sp
		inc	sp
		retn
sub_a_3F7A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3FD5	proc	near
		push	bx
		push	cx
		push	dx
		push	es
		mov	ax,40h
		mov	es,ax
		mov	bx,d_0040_006C_e
		mov	al,es:[bx]
		mov	cx,0FFFFh
loc_a_3FE7:
		mov	dl,es:[bx]
		cmp	al,dl
		je	loc_a_3FE7		; Jump if equal

locloop_a_3FEE:
		cmp	dl,es:[bx]
		jne	loc_a_3FF5		; Jump if not equal
		loop	locloop_a_3FEE		; Loop if cx > 0

loc_a_3FF5:
		neg	cx
		dec	cx
		mov	ax,37h
		xchg	cx,ax
		xor	dx,dx			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		mov	cs:data_a_3F78,ax
loc_a_4004:
		mov	al,es:[bx]
		mov	cx,0FFFFh
loc_a_400A:
		mov	dl,es:[bx]
		cmp	al,dl
		je	loc_a_400A		; Jump if equal
		push	bx
		push	dx
		mov	ax,37h
		push	ax
		call	sub_a_3F7A
		pop	ax
		pop	dx
		pop	bx
		cmp	dl,es:[bx]
		je	loc_a_4029		; Jump if equal
		dec	cs:data_a_3F78
		jmp	short loc_a_4004
loc_a_4029:
		pop	es
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_3FD5	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_402F	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
loc_a_4032:
		mov	ax,data_b_0370
		dec	data_b_0370
		or	ax,ax			; Zero ?
		jz	loc_a_4049		; Jump if zero
		mov	bx,data_b_0370
		shl	bx,1			; Shift w/zeros fill
		call	word ptr data_b_0A52[bx]	;*
		jmp	short loc_a_4032
loc_a_4049:
		call	word ptr data_b_03E2
		call	word ptr data_b_03E4
		call	word ptr data_b_03E6
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_0115		; Sub does not return here ; Quit program
sub_a_402F	endp

		db	 59h, 5Dh,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_405E	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		cmp	word ptr [bp+8],0
		jne	loc_a_406C		; Jump if not equal
		jmp	loc_a_4100
loc_a_406C:
		mov	di,[bp+8]
;*		add	di,0FFFEh
		db	 83h,0C7h,0FEh		;  Fixup - byte match
		mov	si,ds:d_0000_047C_e
		jmp	short loc_a_408D
loc_a_4078:
		mov	ax,[si+2]
		cmp	ax,si
		ja	loc_a_408A		; Jump if above
		cmp	di,si
		ja	loc_a_4098		; Jump if above
		mov	ax,[si+2]
		cmp	ax,di
		ja	loc_a_4098		; Jump if above
loc_a_408A:
		mov	si,[si+2]
loc_a_408D:
		cmp	di,si
		jbe	loc_a_4078		; Jump if below or =
		mov	ax,[si+2]
		cmp	ax,di
		jbe	loc_a_4078		; Jump if below or =
loc_a_4098:
		mov	ax,[di]
		add	ax,di
		cmp	ax,[si+2]
		jne	loc_a_40B3		; Jump if not equal
		mov	bx,[si+2]
		mov	ax,[bx]
		add	[di],ax
		mov	bx,[si+2]
		mov	ax,[bx+2]
		mov	[di+2],ax
		jmp	short loc_a_40B9
loc_a_40B3:
		mov	ax,[si+2]
		mov	[di+2],ax
loc_a_40B9:
		mov	ax,[si]
		add	ax,si
		cmp	ax,di
		jne	loc_a_40CF		; Jump if not equal
		mov	ax,[di]
		add	[si],ax
		mov	ax,[di+2]
		mov	[si+2],ax
		mov	di,si
		jmp	short loc_a_40D2
loc_a_40CF:
		mov	[si+2],di
loc_a_40D2:
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_3C6F
		mov	sp,bp
		mov	dx,[di]
		add	dx,di
		cmp	ax,dx
		jne	loc_a_40FC		; Jump if not equal
		mov	si,di
		jmp	short loc_a_40EA
loc_a_40E7:
		mov	si,[si+2]
loc_a_40EA:
		mov	ax,[si+2]
		cmp	ax,di
		jne	loc_a_40E7		; Jump if not equal
		mov	ax,[di+2]
		mov	[si+2],ax
		push	di			; PARAMETER_1
		call	sub_a_3CA1
		pop	cx
loc_a_40FC:
		mov	ds:d_0000_047C_e,si
loc_a_4100:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_405E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4104	proc	near
		mov	ax,700h
		xchg	data_b_0410,al
		or	al,al			; Zero ?
		jnz	loc_a_4111		; Jump if not zero
		int	21h			; DOS Services  ah=function 07h
						;  get keybd char al, no echo
loc_a_4111:
		xor	ah,ah			; Zero register
		retn
sub_a_4104	endp

			                        ;* No entry point to code
		push	si
		call	sub_a_4104
		mov	si,ax
		push	si			; PARAMETER_1
		call	sub_a_463B
		pop	cx
		mov	ax,si
		pop	si
		retn
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		cmp	byte ptr data_b_0410,0
		je	loc_a_4132		; Jump if equal
		mov	ax,0FFFFh
		jmp	short loc_a_413A
loc_a_4132:
		mov	al,[bp+4]
		mov	data_b_0410,al
		xor	ah,ah			; Zero register
loc_a_413A:
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get INT vector

sub_a_413C	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ah,35h			; '5'
		mov	al,[bp+PARAMETER_1]
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	ax,bx
		mov	dx,es
		pop	bp
		retn
sub_a_413C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set INT vector

sub_a_414C	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	ah,25h			; '%'
		mov	al,[bp+PARAMETER_1]
		push	ds
		lds	dx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		pop	bp
		retn
sub_a_414C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_415D	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_2]
		call	sub_a_402F
		pop	cx
		pop	bp
		retf				; Return far
sub_a_415D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4169	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_2]
		call	sub_a_405E
		pop	cx
		pop	bp
		retf				; Return far
sub_a_4169	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4175	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_2]
		call	sub_a_44B8
		pop	cx
		mov	dx,ds
		pop	bp
		retf				; Return far
sub_a_4175	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4183	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		push	word ptr [bp+8]		; PARAMETER_4
		push	word ptr [bp+0Ah]	; PARAMETER_3
		push	word ptr [bp+0Ch]	; PARAMETER_2
		push	word ptr [bp+0Eh]	; PARAMETER_1
		call	sub_a_4993
		or	ax,ax			; Zero ?
		jnz	loc_a_419F		; Jump if not zero
		xor	ax,ax			; Zero register
		jmp	short loc_a_41CF
loc_a_419F:
		mov	di,[bp+0Ch]
		sub	di,[bp+8]
		inc	di
		mov	si,[bp+0Ah]
		jmp	short loc_a_41C7
loc_a_41AB:
		mov	ax,[bp+10h]
		mov	dx,ds
		push	dx
		push	ax
		push	word ptr [bp+8]		; PARAMETER_2
		push	si			; PARAMETER_1
		call	sub_a_5045
		push	dx
		push	ax
		push	di
		call	sub_a_4958
		mov	ax,di
		shl	ax,1			; Shift w/zeros fill
		add	[bp+10h],ax
		inc	si
loc_a_41C7:
		cmp	si,[bp+0Eh]
		jle	loc_a_41AB		; Jump if < or =
		mov	ax,1
loc_a_41CF:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_4183	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_41D3	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+0Ch]
		sub	di,[bp+8]
		inc	di
		mov	si,[bp+0Ah]
		jmp	short loc_a_4200
loc_a_41E4:
		push	word ptr [bp+8]		; PARAMETER_2
		push	si			; PARAMETER_1
		call	sub_a_5045
		push	dx
		push	ax
		mov	ax,[bp+10h]
		mov	dx,ds
		push	dx
		push	ax
		push	di
		call	sub_a_4958
		mov	ax,di
		shl	ax,1			; Shift w/zeros fill
		add	[bp+10h],ax
		inc	si
loc_a_4200:
		cmp	si,[bp+0Eh]
		jle	loc_a_41E4		; Jump if < or =
		mov	ax,1
		pop	bp
		pop	di
		pop	si
		retn
sub_a_41D3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_420C	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	dx,cs
		push	dx
		push	ax
		callf	sub_a_547D
		mov	sp,bp
		pop	bp
		retn
sub_a_420C	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	ax,[bp+4]
		mov	dx,cs
		push	dx
		push	ax
		callf	sub_a_5513
		mov	sp,bp
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Call INT xx function

sub_a_4230	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
LOCAL_4		=	-8			; bp+0FFF8h
LOCAL_3		=	-6			; bp+0FFFAh
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,8
		lea	ax,[bp+LOCAL_4]		; Load effective addr
		push	ax
		call	sub_a_49DB		; Save segments
		pop	cx
		lea	ax,[bp+LOCAL_4]		; Load effective addr
		push	ax
		push	word ptr [bp+PARAMETER_3]
		push	word ptr [bp+PARAMETER_2]
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_4255		; Call INT xx function
		add	sp,8
		mov	sp,bp
		pop	bp
		retn
sub_a_4230	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Call INT xx function

sub_a_4255	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Eh
		push	ds

		lea	cx,[bp-0Ah]		; Load effective addr
		mov	[bp-0Eh],cx
		mov	[bp-0Ch],ss
		mov	byte ptr [bp-0Ah],55h	; 'U'
		mov	byte ptr [bp-9],0CDh
		mov	ax,[bp+8]
		mov	[bp-8],al
		mov	word ptr [bp-7],0CB5Dh
		cmp	al,25h			; '%'
		jb	loc_a_4293		; Jump if below
		cmp	al,26h			; '&'
		ja	loc_a_4293		; Jump if above
		mov	byte ptr [bp-7],36h	; '6'
		mov	word ptr [bp-6],68Fh
		mov	[bp-4],cx
		mov	word ptr [bp-2],0CB5Dh
loc_a_4293:
		mov	si,[bp+0Eh]
		push	word ptr [si]
		push	word ptr [si+6]
		mov	si,[bp+0Ah]
		mov	ax,[si]
		mov	bx,[si+2]
		mov	cx,[si+4]
		mov	dx,[si+6]
		mov	di,[si+0Ah]
		mov	si,[si+8]
		pop	ds
		pop	es
		call	dword ptr [bp-0Eh]	;*
		pushf				; Push flags
		pushf				; Push flags
		push	si
		push	ds
		push	es
		mov	ds,[bp-10h]
		mov	si,[bp+0Eh]
		pop	word ptr [si]
		pop	word ptr [si+6]
		mov	si,[bp+0Ch]
		pop	word ptr [si+8]
		pop	word ptr [si+0Eh]
		pop	word ptr [si+0Ch]
;*		and	word ptr [si+0Ch],1
		db	 81h, 64h, 0Ch, 01h, 00h	;  Fixup - byte match
		mov	[si+0Ah],di
		mov	[si+6],dx
		mov	[si+4],cx
		mov	[si+2],bx
		mov	[si],ax
		pop	ds
		jz	loc_a_42EC		; Jump if zero
		push	ax
		push	ax
		call	sub_a_42F2
		pop	ax
loc_a_42EC:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_4255	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_42F2	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+6]
		or	si,si			; Zero ?
		jl	loc_a_4311		; Jump if <
		cmp	si,58h
		jbe	loc_a_4305		; Jump if below or =
loc_a_4302:
		mov	si,d_9033_0057_e
loc_a_4305:
		mov	data_b_041C,si
		mov	al,data_b_041E[si]
		cbw				; Convrt byte to word
		xchg	si,ax
		jmp	short loc_a_431E
loc_a_4311:
		neg	si
		cmp	si,22h
		ja	loc_a_4302		; Jump if above
		mov	data_b_041C,0FFFFh
loc_a_431E:
		mov	ax,si
		mov	data_b_0088,ax
		mov	ax,0FFFFh
		pop	bp
		pop	si
		retn	2
sub_a_42F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check DOS key

sub_a_432B	proc	near
		mov	ah,0Bh
		int	21h			; DOS Services  ah=function 0Bh
						;  if keybd char available,al=FF
		cbw				; Convrt byte to word
		retn
sub_a_432B	endp

			                        ;* No entry point to code
		mov	cl,3
		jmp	short loc_a_433F
			                        ;* No entry point to code
		mov	cl,2
		jmp	short loc_a_433F
		db	0B1h, 01h,0EBh, 02h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Divide

sub_a_433D	proc	near
		xor	cx,cx			; Zero register
loc_a_433F:
		push	bp
		push	si
		push	di
		mov	bp,sp
		mov	ax,[bp+0Ah]
		mov	dx,[bp+0Ch]
		mov	bx,[bp+0Eh]
		mov	bp,[bp+10h]
		xor	si,si			; Zero register
		test	cl,1
		jnz	loc_a_4376		; Jump if not zero
		or	dx,dx			; Zero ?
		jns	loc_a_4364		; Jump if not sign
		neg	dx
		neg	ax
		sbb	dx,si
		or	cl,4
loc_a_4364:
		or	bp,bp			; Zero ?
		jns	loc_a_4376		; Jump if not sign
		neg	bp
		neg	bx
		sbb	bp,si
		test	cl,2
		jnz	loc_a_4376		; Jump if not zero
		xor	cl,4
loc_a_4376:
		mov	di,bp
		or	di,dx
		jnz	loc_a_4382		; Jump if not zero
		div	bx			; ax,dx rem=dx:ax/reg
		xchg	si,dx
		jmp	short loc_a_43A2
loc_a_4382:
		push	cx
		mov	cx,20h
		mov	di,si

locloop_a_4388:
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		rcl	si,1			; Rotate thru carry
		rcl	di,1			; Rotate thru carry
		cmp	di,bp
		jb	loc_a_439F		; Jump if below
		ja	loc_a_439A		; Jump if above
		cmp	si,bx
		jb	loc_a_439F		; Jump if below
loc_a_439A:
		sub	si,bx
		sbb	di,bp
		inc	ax
loc_a_439F:
		loop	locloop_a_4388		; Loop if cx > 0

		pop	cx
loc_a_43A2:
		test	cl,2
		jz	loc_a_43AA		; Jump if zero
		xchg	si,ax
		mov	dx,di
loc_a_43AA:
		test	cl,4
		jz	loc_a_43B6		; Jump if zero
		neg	dx
		neg	ax
		sbb	dx,0
loc_a_43B6:
		pop	di
		pop	si
		pop	bp
		retf	8			; Return far
sub_a_433D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_43BC	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,22h
		push	es
		mov	di,[bp+0Eh]
		push	ds
		pop	es
		mov	bx,[bp+0Ch]
		cmp	bx,24h
		ja	loc_a_442A		; Jump if above
		cmp	bl,2
		jb	loc_a_442A		; Jump if below
		mov	ax,[bp+10h]
		mov	cx,[bp+12h]
		or	cx,cx			; Zero ?
		jge	loc_a_43F2		; Jump if > or =
		cmp	byte ptr [bp+0Ah],0
		je	loc_a_43F2		; Jump if equal
		mov	byte ptr [di],2Dh	; '-'
		inc	di
		neg	cx
		neg	ax
		sbb	cx,0
loc_a_43F2:
		lea	si,[bp-22h]		; Load effective addr
		jcxz	loc_a_4406		; Jump if cx=0
loc_a_43F7:
		xchg	cx,ax
		sub	dx,dx
		div	bx			; ax,dx rem=dx:ax/reg
		xchg	cx,ax
		div	bx			; ax,dx rem=dx:ax/reg
		mov	[si],dl
		inc	si
		jcxz	loc_a_440D		; Jump if cx=0
		jmp	short loc_a_43F7
loc_a_4406:
		sub	dx,dx
		div	bx			; ax,dx rem=dx:ax/reg
		mov	[si],dl
		inc	si
loc_a_440D:
		or	ax,ax			; Zero ?
		jnz	loc_a_4406		; Jump if not zero
		lea	cx,[bp-22h]		; Load effective addr
		neg	cx
		add	cx,si
		cld				; Clear direction

locloop_a_4419:
		dec	si
		mov	al,[si]
		sub	al,0Ah
		jnc	loc_a_4424		; Jump if carry=0
		add	al,3Ah			; ':'
		jmp	short loc_a_4427
loc_a_4424:
		add	al,[bp+8]
loc_a_4427:
		stosb				; Store al to es:[di]
		loop	locloop_a_4419		; Loop if cx > 0

loc_a_442A:
		mov	al,0
		stosb				; Store al to es:[di]
		pop	es
		mov	ax,[bp+0Eh]
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn	0Ch
sub_a_43BC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4439	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		cmp	word ptr [bp+PARAMETER_3],0Ah
		jne	loc_a_4448		; Jump if not equal
		mov	ax,[bp+PARAMETER_1]
		cwd				; Word to double word
		jmp	short loc_a_444D
loc_a_4448:
		mov	ax,[bp+PARAMETER_1]
		xor	dx,dx			; Zero register
loc_a_444D:
		push	dx
		push	ax
		push	word ptr [bp+PARAMETER_2]
		push	word ptr [bp+PARAMETER_3]
		mov	al,1
		push	ax
		mov	al,61h			; 'a'
		push	ax
		call	sub_a_43BC
		pop	bp
		retn
sub_a_4439	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	word ptr [bp+6]
		push	word ptr [bp+4]
		push	word ptr [bp+8]
		push	word ptr [bp+0Ah]
		mov	al,0
		push	ax
		mov	al,61h			; 'a'
		push	ax
		call	sub_a_43BC
		pop	bp
		retn
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	word ptr [bp+6]
		push	word ptr [bp+4]
		push	word ptr [bp+8]
		push	word ptr [bp+0Ah]
		cmp	word ptr [bp+0Ah],0Ah
		jne	loc_a_4494		; Jump if not equal
		mov	ax,1
		jmp	short loc_a_4496
loc_a_4494:
		xor	ax,ax			; Zero register
loc_a_4496:
		push	ax
		mov	al,61h			; 'a'
		push	ax
		call	sub_a_43BC
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_449F	proc	near
		push	si
		xchg	si,ax
		xchg	dx,ax
		test	ax,ax
		jz	loc_a_44A8		; Jump if zero
		mul	bx			; dx:ax = reg * ax
loc_a_44A8:
		xchg	cx,ax
		test	ax,ax
		jz	loc_a_44B1		; Jump if zero
		mul	si			; dx:ax = reg * ax
		add	cx,ax
loc_a_44B1:
		xchg	si,ax
		mul	bx			; dx:ax = reg * ax
		add	dx,cx
		pop	si
		retf				; Return far
sub_a_449F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_44B8	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,4
		mov	di,[bp+8]
		or	di,di			; Zero ?
		jnz	loc_a_44CC		; Jump if not zero
		xor	ax,ax			; Zero register
		jmp	loc_a_454E
loc_a_44CC:
		mov	ax,di
		add	ax,5
		and	ax,0FFFEh
		mov	di,ax
		mov	ax,data_b_047C
		mov	[bp-4],ax
		mov	bx,[bp-4]
		mov	si,[bx+2]
loc_a_44E2:
		mov	ax,[si]
		cmp	ax,di
		jb	loc_a_4515		; Jump if below
		mov	ax,[si]
		mov	dx,di
		add	dx,4
		cmp	ax,dx
		ja	loc_a_44FE		; Jump if above
		mov	ax,[si+2]
		mov	bx,[bp-4]
		mov	[bx+2],ax
		jmp	short loc_a_4508
loc_a_44FE:
		sub	[si],di
		mov	ax,[si]
		add	ax,si
		mov	si,ax
		mov	[si],di
loc_a_4508:
		mov	ax,[bp-4]
		mov	data_b_047C,ax
		mov	ax,si
		add	ax,2
		jmp	short loc_a_454E
loc_a_4515:
		cmp	si,data_b_047C
		jne	loc_a_451D		; Jump if not equal
		jmp	short loc_a_4525
loc_a_451D:
		mov	[bp-4],si
		mov	si,[si+2]
		jmp	short loc_a_44E2
loc_a_4525:
		mov	ax,di
		xor	dx,dx			; Zero register
		and	ax,0FFFFh
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_3C6F
		pop	cx
		pop	cx
		mov	[bp-2],ax
;*		cmp	word ptr [bp-2],0FFFFh
		db	 83h, 7Eh,0FEh,0FFh	;  Fixup - byte match
		jnz	loc_a_4544		; Jump if not zero
		xor	ax,ax			; Zero register
		jmp	short loc_a_454E
loc_a_4544:
		mov	si,[bp-2]
		mov	[si],di
		mov	ax,si
		add	ax,2
loc_a_454E:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_44B8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4554	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,6
		mov	si,[bp+0Ah]
		push	word ptr [bp+8]		; PARAMETER_4
		push	si			; PARAMETER_3
		push	word ptr [bp+0Ch]	; PARAMETER_2
		push	word ptr [bp+0Eh]	; PARAMETER_1
		call	sub_a_4993
		or	ax,ax			; Zero ?
		jz	loc_a_4590		; Jump if zero
		push	word ptr [bp+10h]	; PARAMETER_4
		push	word ptr [bp+12h]	; PARAMETER_3
		mov	ax,[bp+0Ch]
		sub	ax,[bp+8]
		add	ax,[bp+10h]
		push	ax			; PARAMETER_2
		mov	ax,[bp+0Eh]
		sub	ax,si
		add	ax,[bp+12h]
		push	ax			; PARAMETER_1
		call	sub_a_4993
		or	ax,ax			; Zero ?
		jnz	loc_a_4594		; Jump if not zero
loc_a_4590:
		xor	ax,ax			; Zero register
		jmp	short loc_a_45EE
loc_a_4594:
		mov	[bp-6],si
		mov	ax,[bp+0Eh]
		mov	[bp-4],ax
		mov	word ptr [bp-2],1
		cmp	si,[bp+12h]
		jge	loc_a_45B5		; Jump if > or =
		mov	ax,[bp+0Eh]
		mov	[bp-6],ax
		mov	[bp-4],si
		mov	word ptr [bp-2],0FFFFh
loc_a_45B5:
		mov	di,[bp-6]
		jmp	short loc_a_45E1
loc_a_45BA:
		push	word ptr [bp+10h]	; PARAMETER_2
		mov	ax,di
		sub	ax,si
		add	ax,[bp+12h]
		push	ax			; PARAMETER_1
		call	sub_a_5045
		push	dx
		push	ax
		push	word ptr [bp+8]		; PARAMETER_2
		push	di			; PARAMETER_1
		call	sub_a_5045
		push	dx
		push	ax
		mov	ax,[bp+0Ch]
		sub	ax,[bp+8]
		inc	ax
		push	ax
		call	sub_a_4958
		add	di,[bp-2]
loc_a_45E1:
		mov	ax,[bp-4]
		add	ax,[bp-2]
		cmp	ax,di
		jne	loc_a_45BA		; Jump if not equal
		mov	ax,1
loc_a_45EE:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_4554	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Open file

sub_a_45F4	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	al,1
		mov	cx,[bp+8]
		test	cx,2
		jnz	loc_a_460D		; Jump if not zero
		mov	al,2
		test	cx,4
		jnz	loc_a_460D		; Jump if not zero
		mov	al,0
loc_a_460D:
		mov	dx,[bp+6]
		mov	cl,0F0h
		and	cl,[bp+8]
		or	al,cl
		mov	ah,3Dh
		int	21h			; DOS Services  ah=function 3Dh
						;  open file, al=mode,name@ds:dx
		jc	loc_a_4634		; Jump if carry Set
		mov	si,ax
		mov	ax,[bp+8]
		and	ax,0F8FFh
		or	ax,8000h
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_03E8[bx],ax
		mov	ax,si
		jmp	short loc_a_4638
loc_a_4634:
		push	ax
		call	sub_a_42F2
loc_a_4638:
		pop	bp
		pop	si
		retn
sub_a_45F4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_463B	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		lea	ax,[bp+PARAMETER_1]	; Load effective addr
		push	ax
		mov	ax,1
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_3CDF
		pop	bp
		retn
sub_a_463B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read file

sub_a_464E	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		mov	ah,3Fh			; '?'
		mov	bx,[bp+PARAMETER_1]
		mov	cx,[bp+PARAMETER_3]
		mov	dx,[bp+PARAMETER_2]
		int	21h			; DOS Services  ah=function 3Fh
						;  read file, bx=file handle
						;   cx=bytes to ds:dx buffer
		jc	loc_a_4662		; Jump if carry Set
		jmp	short loc_a_4666
loc_a_4662:
		push	ax
		call	sub_a_42F2
loc_a_4666:
		pop	bp
		retn
sub_a_464E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4668	proc	near
		jmp	word ptr data_b_095E
sub_a_4668	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_466C	proc	far

PARAMETER_1	=	6			; bp+6
PARAMETER_2	=	8			; bp+8
PARAMETER_3	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		push	si
		push	di
		push	ds
		lds	si,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		les	di,dword ptr [bp+PARAMETER_3]	; Load seg:offset ptr
		mov	ax,ds
		mov	dx,es
		cmp	ax,dx
		ja	loc_a_468F		; Jump if above
		cmp	si,di
		ja	loc_a_468F		; Jump if above
		cld				; Clear direction
loc_a_4685:
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		cld				; Clear direction
		pop	ds
		pop	di
		pop	si
		pop	bp
		retf	8			; Return far
loc_a_468F:
		add	si,cx
		add	di,cx
		dec	si
		dec	di
		std				; Set direction flag
		jmp	short loc_a_4685
sub_a_466C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4698	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+0Ah]
		mov	cx,[si]
		mov	cl,20h			; ' '
		jmp	short loc_a_46AD
loc_a_46A5:
		mov	[si],cx
		add	si,2
		inc	word ptr [bp+8]
loc_a_46AD:
		mov	ax,[bp+8]
		cmp	ax,[bp+6]
		jle	loc_a_46A5		; Jump if < or =
		pop	bp
		pop	si
		retn	6
sub_a_4698	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_46BA	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh
LOCAL_15	=	-1Eh			; bp+0FFE2h
LOCAL_14	=	-1Ch			; bp+0FFE4h
LOCAL_13	=	-1Ah			; bp+0FFE6h
LOCAL_12	=	-18h			; bp+0FFE8h
LOCAL_11	=	-16h			; bp+0FFEAh
LOCAL_10	=	-14h			; bp+0FFECh
LOCAL_9		=	-12h			; bp+0FFEEh
LOCAL_8		=	-10h			; bp+0FFF0h
LOCAL_7		=	-0Eh			; bp+0FFF2h
LOCAL_6		=	-0Ch			; bp+0FFF4h
LOCAL_5		=	-0Ah			; bp+0FFF6h
LOCAL_4		=	-8			; bp+0FFF8h
LOCAL_3		=	-6			; bp+0FFFAh
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,0A0h
		cmp	byte ptr data_b_037B,0
		je	loc_a_46CB		; Jump if equal
		jmp	loc_a_4803
loc_a_46CB:
		cmp	data_b_0381,0
		jne	loc_a_46D5		; Jump if not equal
		jmp	loc_a_4803
loc_a_46D5:
		cmp	byte ptr [bp+PARAMETER_1],1
		je	loc_a_46DE		; Jump if equal
		jmp	loc_a_4803
loc_a_46DE:
		inc	byte ptr [bp+PARAMETER_5]
		inc	byte ptr [bp+PARAMETER_4]
		inc	byte ptr [bp+PARAMETER_3]
		inc	byte ptr [bp+PARAMETER_2]
		cmp	byte ptr [bp+PARAMETER_6],6
		je	loc_a_46F3		; Jump if equal
		jmp	loc_a_477B
loc_a_46F3:
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_3]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		inc	ax
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		call	sub_a_4554
		add	sp,0Ch
		lea	ax,cs:[0FF60h][bp]	; Load effective addr
		push	ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		call	sub_a_4183
		add	sp,0Ah
		lea	ax,cs:[0FF60h][bp]	; Load effective addr
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_3]
		mov	ah,0
		push	ax
		call	sub_a_4698
		lea	ax,cs:[0FF60h][bp]	; Load effective addr
		push	ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_3]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		call	sub_a_41D3
		add	sp,0Ah
		jmp	loc_a_4801
loc_a_477B:
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		inc	ax
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,0
		dec	ax
		push	ax
		mov	al,[bp+PARAMETER_3]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		call	sub_a_4554
		add	sp,0Ch
		lea	ax,cs:[0FF60h][bp]	; Load effective addr
		push	ax
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		call	sub_a_4183
		add	sp,0Ah
		lea	ax,cs:[0FF60h][bp]	; Load effective addr
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_3]
		mov	ah,0
		push	ax
		call	sub_a_4698
		lea	ax,cs:[0FF60h][bp]	; Load effective addr
		push	ax
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_3]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_4]
		mov	ah,0
		push	ax
		mov	al,[bp+PARAMETER_5]
		mov	ah,0
		push	ax
		call	sub_a_41D3
		add	sp,0Ah
loc_a_4801:
		jmp	short loc_a_481C
loc_a_4803:
		mov	bh,data_b_0376
		mov	ah,[bp+PARAMETER_6]
		mov	al,[bp+PARAMETER_1]
		mov	ch,[bp+PARAMETER_4]
		mov	cl,[bp+PARAMETER_5]
		mov	dh,[bp+PARAMETER_2]
		mov	dl,[bp+PARAMETER_3]
		call	sub_a_3E83
loc_a_481C:
		mov	sp,bp
		pop	bp
		retn	0Ch
sub_a_46BA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4822	proc	near
		push	si
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		mov	si,[bp+6]
		shr	si,1			; Shift w/zeros fill
		mov	ax,si
		mov	dl,data_b_037A
		mov	dh,0
		mov	bx,dx
		xor	dx,dx			; Zero register
		div	bx			; ax,dx rem=dx:ax/reg
		mov	[bp-2],al
		mov	al,[bp-2]
		mov	ah,0
		mov	dl,data_b_037A
		mov	dh,0
		mul	dx			; dx:ax = reg * ax
		mov	dx,si
		sub	dl,al
		mov	[bp-1],dl
		mov	ah,[bp-2]
		mov	al,[bp-1]
		mov	sp,bp
		pop	bp
		pop	si
		retn	4
sub_a_4822	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_485F	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+8]
		mov	ax,[si]
		mov	bx,[bp+6]
		cmp	ax,[bx]
		je	loc_a_4878		; Jump if equal
		mov	dx,[si]
		mov	bh,0
		mov	ah,2
		call	sub_a_3E83
loc_a_4878:
		mov	bx,[bp+6]
		mov	[bx],dx
		inc	dl
		mov	al,dl
		cmp	al,data_b_037A
		jb	loc_a_488B		; Jump if below
		inc	dh
		mov	dl,0
loc_a_488B:
		mov	[si],dx
		pop	bp
		pop	si
		retn	4
sub_a_485F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4892	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ah
		call	sub_a_50E0
		mov	di,ax
		mov	ax,di
		mov	[bp-6],ax
		mov	ax,[bp+10h]
		cmp	ax,data_b_037F
		jne	loc_a_48B2		; Jump if not equal
		mov	ax,1
		jmp	short loc_a_48B4
loc_a_48B2:
		xor	ax,ax			; Zero register
loc_a_48B4:
		mov	[bp-4],ax
		or	ax,ax			; Zero ?
		jz	loc_a_48C7		; Jump if zero
		push	word ptr [bp+10h]
		push	word ptr [bp+0Eh]
		call	sub_a_4822
		mov	[bp-0Ah],ax
loc_a_48C7:
		mov	ax,[bp+0Ch]
		cmp	ax,data_b_037F
		jne	loc_a_48D5		; Jump if not equal
		mov	ax,1
		jmp	short loc_a_48D7
loc_a_48D5:
		xor	ax,ax			; Zero register
loc_a_48D7:
		mov	[bp-2],ax
		or	ax,ax			; Zero ?
		jz	loc_a_48EA		; Jump if zero
		push	word ptr [bp+0Ch]
		push	word ptr [bp+0Ah]
		call	sub_a_4822
		mov	[bp-8],ax
loc_a_48EA:
		mov	ax,[bp+8]
		dec	word ptr [bp+8]
		or	ax,ax			; Zero ?
		jz	loc_a_4947		; Jump if zero
		cmp	word ptr [bp-2],0
		je	loc_a_4910		; Jump if equal
		lea	ax,[bp-8]		; Load effective addr
		push	ax
		lea	ax,[bp-6]		; Load effective addr
		push	ax
		call	sub_a_485F
		mov	bh,0
		mov	ah,8
		call	sub_a_3E83
		mov	si,ax
		jmp	short loc_a_491A
loc_a_4910:
		les	bx,dword ptr [bp+0Ah]	; Load seg:offset ptr
		mov	si,es:[bx]
		add	word ptr [bp+0Ah],2
loc_a_491A:
		cmp	word ptr [bp-4],0
		je	loc_a_493B		; Jump if equal
		lea	ax,[bp-0Ah]		; Load effective addr
		push	ax
		lea	ax,[bp-6]		; Load effective addr
		push	ax
		call	sub_a_485F
		mov	ax,si
		mov	bl,ah
		mov	cx,1
		mov	bh,0
		mov	ah,9
		call	sub_a_3E83
		jmp	short loc_a_4945
loc_a_493B:
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	es:[bx],si
		add	word ptr [bp+0Eh],2
loc_a_4945:
		jmp	short loc_a_48EA
loc_a_4947:
		mov	dx,di
		mov	bh,0
		mov	ah,2
		call	sub_a_3E83
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn	0Ah
sub_a_4892	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4958	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
		cmp	byte ptr data_b_037B,0
		jne	loc_a_497D		; Jump if not equal
		cmp	data_b_0381,0
		je	loc_a_497D		; Jump if equal
		push	word ptr [bp+PARAMETER_5]
		push	word ptr [bp+PARAMETER_4]
		push	word ptr [bp+PARAMETER_3]
		push	word ptr [bp+PARAMETER_2]
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_5068
		jmp	short loc_a_498F
loc_a_497D:
		push	word ptr [bp+PARAMETER_5]
		push	word ptr [bp+PARAMETER_4]
		push	word ptr [bp+PARAMETER_3]
		push	word ptr [bp+PARAMETER_2]
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_4892
loc_a_498F:
		pop	bp
		retn	0Ah
sub_a_4958	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4993	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		mov	al,data_b_037A
		mov	ah,0
		mov	cx,ax
		mov	al,data_b_0379
		mov	ah,0
		mov	dx,ax
		mov	ax,[bp+PARAMETER_4]
		cmp	ax,cx
		ja	loc_a_49D5		; Jump if above
		mov	ax,[bp+PARAMETER_2]
		cmp	ax,cx
		ja	loc_a_49D5		; Jump if above
		mov	ax,[bp+PARAMETER_4]
		cmp	ax,[bp+PARAMETER_2]
		jg	loc_a_49D5		; Jump if >
		mov	ax,[bp+PARAMETER_3]
		cmp	ax,dx
		ja	loc_a_49D5		; Jump if above
		mov	ax,[bp+PARAMETER_1]
		cmp	ax,dx
		ja	loc_a_49D5		; Jump if above
		mov	ax,[bp+PARAMETER_3]
		cmp	ax,[bp+PARAMETER_1]
		jg	loc_a_49D5		; Jump if >
		mov	ax,1
		jmp	short loc_a_49D7
loc_a_49D5:
		xor	ax,ax			; Zero register
loc_a_49D7:
		pop	bp
		retn	8
sub_a_4993	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Save segments

sub_a_49DB	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+6]
		mov	[si],es
		mov	[si+2],cs
		mov	[si+4],ss
		mov	[si+6],ds
		pop	bp
		pop	si
		retn
sub_a_49DB	endp

data_a_49F0	dw	0
data_a_49F2	dw	0			; segment storage
		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_49F6	proc	near
		pop	word ptr cs:data_a_49F0
		mov	cs:data_a_49F2,ds
		cld				; Clear direction
		mov	es,data_b_0084		; PSP segment
		mov	si,d_9033_0080_e
		xor	ax,ax			; Zero register
		lods	byte ptr es:[si]	; String [si] to al
		inc	ax
		mov	bp,es
		xchg	dx,si
		xchg	bx,ax
		mov	si,word ptr data_b_007E
		add	si,2
		mov	cx,1
		cmp	byte ptr data_b_0086,3
		jb	loc_a_4A34		; Jump if below
		mov	es,word ptr data_b_007E+2 ; PSP environment segment
		mov	di,si
		mov	cl,7Fh
		xor	al,al			; Zero register
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_a_4AA7		; Jump if cx=0
		xor	cl,7Fh
loc_a_4A34:
		sub	sp,2
		mov	ax,1
		add	ax,bx
		add	ax,cx
		and	ax,0FFFEh
		mov	di,sp
		sub	di,ax
		jc	loc_a_4AA7		; Jump if carry Set
		mov	sp,di
		mov	ax,es
		mov	ds,ax
		mov	ax,ss
		mov	es,ax
		push	cx
		dec	cx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xor	al,al			; Zero register
		stosb				; Store al to es:[di]
		mov	ds,bp
		xchg	si,dx
		xchg	bx,cx
		mov	ax,bx
		mov	dx,ax
		inc	bx
loc_a_4A63:
		call	sub_a_4A7F
		ja	loc_a_4A6F		; Jump if above
loc_a_4A68:
		jc	loc_a_4AAA		; Jump if carry Set
		call	sub_a_4A7F
		ja	loc_a_4A68		; Jump if above
loc_a_4A6F:
		cmp	al,20h			; ' '
		je	loc_a_4A7B		; Jump if equal
		cmp	al,0Dh
		je	loc_a_4A7B		; Jump if equal
		cmp	al,9
		jne	loc_a_4A63		; Jump if not equal
loc_a_4A7B:
		xor	al,al			; Zero register
		jmp	short loc_a_4A63

;==== External Entry into Subroutine ======================================

sub_a_4A7F:
		or	ax,ax			; Zero ?
		jz	loc_a_4A8A		; Jump if zero
		inc	dx
		stosb				; Store al to es:[di]
		or	al,al			; Zero ?
		jnz	loc_a_4A8A		; Jump if not zero
		inc	bx
loc_a_4A8A:
		xchg	ah,al
		xor	al,al			; Zero register
		stc				; Set carry flag
		jcxz	loc_ret_a_4AA6		; Jump if cx=0
		lodsb				; String [si] to al
		dec	cx
		sub	al,22h			; '"'
		jz	loc_ret_a_4AA6		; Jump if zero
		add	al,22h			; '"'
		cmp	al,5Ch			; '\'
		jne	loc_a_4AA4		; Jump if not equal
		cmp	byte ptr [si],22h	; '"'
		jne	loc_a_4AA4		; Jump if not equal
		lodsb				; String [si] to al
		dec	cx
loc_a_4AA4:
		or	si,si			; Zero ?

loc_ret_a_4AA6:
		retn
loc_a_4AA7:
		jmp	loc_a_018D
loc_a_4AAA:
		pop	cx
		add	cx,dx
		mov	ds,cs:data_a_49F2
		mov	data_b_0078,bx
		inc	bx
		add	bx,bx
		mov	si,sp
		mov	bp,sp
		sub	bp,bx
		jc	loc_a_4AA7		; Jump if carry Set
		mov	sp,bp
		mov	data_b_007A,bp
loc_a_4AC7:
		jcxz	loc_a_4AD7		; Jump if cx=0
		mov	[bp],si
		add	bp,2

locloop_a_4ACF:
		lods	byte ptr ss:[si]	; String [si] to al
		or	al,al			; Zero ?
		loopnz	locloop_a_4ACF		; Loop if zf=0, cx>0

		jz	loc_a_4AC7		; Jump if zero
loc_a_4AD7:
		xor	ax,ax			; Zero register
		mov	[bp],ax
		jmp	word ptr cs:data_a_49F0
sub_a_49F6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4AE1	proc	near
		mov	cx,ds:d_9033_007E_e
		push	cx
		call	sub_a_44B8
		pop	cx
		mov	di,ax
		or	ax,ax			; Zero ?
		jz	loc_a_4B14		; Jump if zero
		push	ds
		push	ds
		pop	es
		mov	ds,ds:d_9033_0080_e
		xor	si,si			; Zero register
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		mov	di,ax
		push	es
		push	word ptr ds:d_9033_0082_e
		call	sub_a_44B8
		add	sp,2
		mov	bx,ax
		pop	es
		mov	ds:d_9033_007C_e,ax
		or	ax,ax			; Zero ?
		jnz	loc_a_4B17		; Jump if not zero
loc_a_4B14:
		jmp	loc_a_018D
loc_a_4B17:
		xor	ax,ax			; Zero register
		mov	cx,0FFFFh
loc_a_4B1C:
		mov	[bx],di
		add	bx,2
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		cmp	es:[di],al
		jne	loc_a_4B1C		; Jump if not equal
		mov	[bx],ax
		retn
sub_a_4AE1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Enable output to speaker, set tone

sub_a_4B2B	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	bx,[bp+PARAMETER_1]
		mov	ax,34DDh
		mov	dx,12h
		cmp	dx,bx
		jae	loc_a_4B55		; Jump if above or =
		div	bx			; ax,dx rem=dx:ax/reg
		mov	bx,ax
		in	al,61h			; port 61h, 8255 port B, read
		test	al,3
		jnz	loc_a_4B4D		; Jump if not zero
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
loc_a_4B4D:
		mov	al,bl
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,bh
		out	42h,al			; port 42h, 8253 timer 2 spkr
loc_a_4B55:
		pop	bp
		retn
sub_a_4B2B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Disable output to speaker

sub_a_4B57	proc	near
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_a_4B57	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4B5E	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	ax,ds
		mov	es,ax
		cld				; Clear direction
		mov	di,[bp+8]
		xor	al,al			; Zero register
		mov	cx,0FFFFh
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		mov	ax,cx
		not	ax
		dec	ax
		pop	bp
		pop	di
		pop	si
		retn
sub_a_4B5E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4B7B	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	dx,[bp+PARAMETER_1]
		mov	cx,0F04h
		mov	bx,offset data_b_0487	; ('0123456789ABCDEF')
		cld				; Clear direction
		mov	al,dh
		shr	al,cl			; Shift w/zeros fill
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,dh
		and	al,ch
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,dl
		shr	al,cl			; Shift w/zeros fill
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,dl
		and	al,ch
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		pop	bp
		retn	2
sub_a_4B7B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4BA4	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,92h
		mov	word ptr [bp-54h],0
		mov	byte ptr [bp-51h],50h	; 'P'
		push	es
		cld				; Clear direction
		lea	di,[bp-50h]		; Load effective addr
		mov	ss:data_c_FF6E_e[bp],di
loc_a_4BBF:
		mov	di,ss:data_c_FF6E_e[bp]
loc_a_4BC3:
		mov	si,[bp+0Ah]
loc_a_4BC6:
		lodsb				; String [si] to al
		or	al,al			; Zero ?
		jz	loc_a_4BDF		; Jump if zero
		cmp	al,25h			; '%'
		je	loc_a_4BE2		; Jump if equal
loc_a_4BCF:
		mov	[di],al
		inc	di
		dec	byte ptr [bp-51h]
		jg	loc_a_4BC6		; Jump if >
		call	sub_a_4BDA

;==== External Entry into Subroutine ======================================

sub_a_4BDA:
		jmp	loc_a_5015
		jmp	short loc_a_4BC6
loc_a_4BDF:
		jmp	loc_a_4FE2
loc_a_4BE2:
		mov	ss:data_c_FF7A_e[bp],si
		lodsb				; String [si] to al
		cmp	al,25h			; '%'
		je	loc_a_4BCF		; Jump if equal
		mov	ss:data_c_FF6E_e[bp],di
		sub	cx,cx
		mov	ss:data_c_FF78_e[bp],cx
		mov	ss:data_c_FF76_e[bp],cl
		mov	ss:data_c_FF77_e[bp],cl
		mov	word ptr ss:data_c_FF72_e[bp],0FFFFh
		mov	word ptr ss:data_c_FF74_e[bp],0FFFFh
		jmp	short loc_a_4C0C
loc_a_4C0B:
		lodsb				; String [si] to al
loc_a_4C0C:
		cbw				; Convrt byte to word
		mov	dx,ax
		xchg	bx,ax
		sub	bl,20h			; ' '
		cmp	bl,60h			; '`'
		jae	loc_a_4C5D		; Jump if above or =
		mov	bl,data_b_0497[bx]
		mov	ax,bx
		cmp	ax,16h
		jbe	loc_a_4C26		; Jump if below or =
		jmp	loc_a_4FCD
loc_a_4C26:
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_4C2F[bx]	;*23 entries
data_a_4C2F	dw	offset loc_a_4C78	; Data table (indexed access)
data_a_4C31	dw	offset loc_a_4C60
data_a_4C33	dw	offset loc_a_4CB6
data_a_4C35	dw	offset loc_a_4C6C
data_a_4C37	dw	offset loc_a_4CDA
data_a_4C39	dw	offset loc_a_4CE3
data_a_4C3B	dw	offset loc_a_4D19
data_a_4C3D	dw	offset loc_a_4D22
data_a_4C3F	dw	offset loc_a_4C9E
data_a_4C41	dw	offset loc_a_4D50
data_a_4C43	dw	offset loc_a_4D2B
data_a_4C45	dw	offset loc_a_4D2F
data_a_4C47	dw	offset loc_a_4D33
data_a_4C49	dw	offset loc_a_4DA1
data_a_4C4B	dw	offset loc_a_4E54
data_a_4C4D	dw	offset loc_a_4DF3
data_a_4C4F	dw	offset loc_a_4E13
data_a_4C51	dw	offset loc_a_4FA1
data_a_4C53	dw	offset loc_a_4FCD
data_a_4C55	dw	offset loc_a_4FCD
data_a_4C57	dw	offset loc_a_4FCD
data_a_4C59	dw	offset loc_a_4C8A
data_a_4C5B	dw	offset loc_a_4C94
loc_a_4C5D:
		jmp	loc_a_4FCD

;===== Indexed Entry Point ================================================

loc_a_4C60:
		cmp	ch,0
		ja	loc_a_4C5D		; Jump if above
		or	byte ptr ss:data_c_FF76_e[bp],1
		jmp	short loc_a_4C0B

;===== Indexed Entry Point ================================================

loc_a_4C6C:
		cmp	ch,0
		ja	loc_a_4C5D		; Jump if above
		or	byte ptr ss:data_c_FF76_e[bp],2
		jmp	short loc_a_4C0B

;===== Indexed Entry Point ================================================

loc_a_4C78:
		cmp	ch,0
		ja	loc_a_4C5D		; Jump if above
		cmp	byte ptr ss:data_c_FF77_e[bp],2Bh	; '+'
		je	loc_a_4C0B		; Jump if equal
		mov	ss:data_c_FF77_e[bp],dl
		jmp	short loc_a_4C0B

;===== Indexed Entry Point ================================================

loc_a_4C8A:
		and	byte ptr ss:data_c_FF76_e[bp],0DFh
		mov	ch,5
		jmp	loc_a_4C0B

;===== Indexed Entry Point ================================================

loc_a_4C94:
		or	byte ptr ss:data_c_FF76_e[bp],20h	; ' '
		mov	ch,5
		jmp	loc_a_4C0B

;===== Indexed Entry Point ================================================

loc_a_4C9E:
		cmp	ch,0
		ja	loc_a_4CE3		; Jump if above
		test	byte ptr ss:data_c_FF76_e[bp],2
		jnz	loc_a_4CCA		; Jump if not zero
		or	byte ptr ss:data_c_FF76_e[bp],8
		mov	ch,1
		jmp	short loc_a_4CCA
loc_a_4CB3:
		jmp	loc_a_4FCD

;===== Indexed Entry Point ================================================

loc_a_4CB6:
		mov	di,[bp+8]
		mov	ax,[di]
		add	word ptr [bp+8],2
		cmp	ch,2
		jae	loc_a_4CCD		; Jump if above or =
		mov	ss:data_c_FF72_e[bp],ax
		mov	ch,3
loc_a_4CCA:
		jmp	loc_a_4C0B
loc_a_4CCD:
		cmp	ch,4
		jne	loc_a_4CB3		; Jump if not equal
		mov	ss:data_c_FF74_e[bp],ax
		inc	ch
		jmp	short loc_a_4CCA

;===== Indexed Entry Point ================================================

loc_a_4CDA:
		cmp	ch,4
		jae	loc_a_4CB3		; Jump if above or =
		mov	ch,4
		jmp	short loc_a_4CCA

;===== Indexed Entry Point ================================================

loc_a_4CE3:
		xchg	dx,ax
		sub	al,30h			; '0'
		cbw				; Convrt byte to word
		cmp	ch,2
		ja	loc_a_4D01		; Jump if above
		mov	ch,2
		xchg	ss:data_c_FF72_e[bp],ax
		or	ax,ax			; Zero ?
		jl	loc_a_4CCA		; Jump if <
		mov	dx,0Ah
		mul	dx			; dx:ax = reg * ax
		add	ss:data_c_FF72_e[bp],ax
		jmp	short loc_a_4CCA
loc_a_4D01:
		cmp	ch,4
		jne	loc_a_4CB3		; Jump if not equal
		xchg	ss:data_c_FF74_e[bp],ax
		or	ax,ax			; Zero ?
		jl	loc_a_4CCA		; Jump if <
		mov	dx,0Ah
		mul	dx			; dx:ax = reg * ax
		add	ss:data_c_FF74_e[bp],ax
		jmp	short loc_a_4CCA

;===== Indexed Entry Point ================================================

loc_a_4D19:
		or	byte ptr ss:data_c_FF76_e[bp],10h
		mov	ch,5
		jmp	short loc_a_4CCA

;===== Indexed Entry Point ================================================

loc_a_4D22:
		and	byte ptr ss:data_c_FF76_e[bp],0EFh
		mov	ch,5
		jmp	short loc_a_4CCA

;===== Indexed Entry Point ================================================

loc_a_4D2B:
		mov	bh,8
		jmp	short loc_a_4D39

;===== Indexed Entry Point ================================================

loc_a_4D2F:
		mov	bh,0Ah
		jmp	short loc_a_4D3E

;===== Indexed Entry Point ================================================

loc_a_4D33:
		mov	bh,10h
		mov	bl,0E9h
		add	bl,dl
loc_a_4D39:
		mov	byte ptr ss:data_c_FF77_e[bp],0
loc_a_4D3E:
		mov	byte ptr ss:data_c_FF71_e[bp],0
		mov	ss:data_c_FF70_e[bp],dl
		mov	di,[bp+8]
		mov	ax,[di]
		sub	dx,dx
		jmp	short loc_a_4D61

;===== Indexed Entry Point ================================================

loc_a_4D50:
		mov	bh,0Ah
		mov	byte ptr ss:data_c_FF71_e[bp],1
		mov	ss:data_c_FF70_e[bp],dl
		mov	di,[bp+8]
		mov	ax,[di]
		cwd				; Word to double word
loc_a_4D61:
		inc	di
		inc	di
		mov	[bp+0Ah],si
		test	byte ptr ss:data_c_FF76_e[bp],10h
		jz	loc_a_4D71		; Jump if zero
		mov	dx,[di]
		inc	di
		inc	di
loc_a_4D71:
		mov	[bp+8],di
		push	dx
		push	ax
		or	ax,dx
		jz	loc_a_4D7F		; Jump if zero
		or	byte ptr ss:data_c_FF76_e[bp],4
loc_a_4D7F:
		lea	di,ss:data_c_FF7D_e[bp]	; Load effective addr
		push	di
		mov	al,bh
		cbw				; Convrt byte to word
		push	ax
		mov	al,ss:data_c_FF71_e[bp]
		push	ax
		push	bx
		call	sub_a_43BC
		push	ss
		pop	es
		mov	dx,ss:data_c_FF74_e[bp]
		or	dx,dx			; Zero ?
		jg	loc_a_4D9E		; Jump if >
		jmp	loc_a_4E86
loc_a_4D9E:
		jmp	loc_a_4E95

;===== Indexed Entry Point ================================================

loc_a_4DA1:
		mov	ss:data_c_FF70_e[bp],dl
		mov	[bp+0Ah],si
		lea	di,ss:data_c_FF7C_e[bp]	; Load effective addr
		mov	bx,[bp+8]
		push	word ptr [bx]
		inc	bx
		inc	bx
		mov	[bp+8],bx
		test	byte ptr ss:data_c_FF76_e[bp],20h	; ' '
		jz	loc_a_4DCC		; Jump if zero
		push	word ptr [bx]		; PARAMETER_1
		inc	bx
		inc	bx
		mov	[bp+8],bx
		push	ss
		pop	es
		call	sub_a_4B7B
		mov	al,3Ah			; ':'
		stosb				; Store al to es:[di]
loc_a_4DCC:
		push	ss
		pop	es
		call	sub_a_4B7B
		mov	byte ptr [di],0
		mov	byte ptr ss:data_c_FF71_e[bp],0
		and	byte ptr ss:data_c_FF76_e[bp],0FBh
		lea	cx,cs:[0FF7Ch][bp]	; Load effective addr
		sub	di,cx
		xchg	cx,di
		mov	dx,ss:data_c_FF74_e[bp]
		cmp	dx,cx
		jg	loc_a_4DF0		; Jump if >
		mov	dx,cx
loc_a_4DF0:
		jmp	loc_a_4E86

;===== Indexed Entry Point ================================================

loc_a_4DF3:
		mov	[bp+0Ah],si
		mov	ss:data_c_FF70_e[bp],dl
		mov	di,[bp+8]
		mov	ax,[di]
		add	word ptr [bp+8],2
		push	ss
		pop	es
		lea	di,ss:data_c_FF7D_e[bp]	; Load effective addr
		mov	ah,0
		mov	[di],ax
		mov	cx,1
		jmp	loc_a_4EC5

;===== Indexed Entry Point ================================================

loc_a_4E13:
		mov	[bp+0Ah],si
		mov	ss:data_c_FF70_e[bp],dl
		mov	di,[bp+8]
		test	byte ptr ss:data_c_FF76_e[bp],20h	; ' '
		jnz	loc_a_4E30		; Jump if not zero
		mov	di,[di]
		add	word ptr [bp+8],2
		push	ds
		pop	es
		or	di,di			; Zero ?
		jmp	short loc_a_4E3A
loc_a_4E30:
		les	di,dword ptr [di]	; Load seg:offset ptr
		add	word ptr [bp+8],4
		mov	ax,es
		or	ax,di
loc_a_4E3A:
		jnz	loc_a_4E41		; Jump if not zero
		push	ds
		pop	es
		mov	di,480h
loc_a_4E41:
		call	sub_a_4E44

;==== External Entry into Subroutine ======================================

sub_a_4E44:
		jmp	loc_a_4FF5
			                        ;* No entry point to code
		cmp	cx,ss:data_c_FF74_e[bp]
		jbe	loc_a_4E51		; Jump if below or =
		mov	cx,ss:data_c_FF74_e[bp]
loc_a_4E51:
		jmp	short loc_a_4EC5
		db	90h

;===== Indexed Entry Point ================================================

loc_a_4E54:
		mov	[bp+0Ah],si
		mov	ss:data_c_FF70_e[bp],dl
		mov	di,[bp+8]
		mov	cx,ss:data_c_FF74_e[bp]
		or	cx,cx			; Zero ?
		jge	loc_a_4E69		; Jump if > or =
		mov	cx,6
loc_a_4E69:
		push	di
		push	cx
		lea	bx,cs:[0FF7Dh][bp]	; Load effective addr
		push	bx
		push	dx
		mov	ax,1
		and	al,ss:data_c_FF76_e[bp]
		push	ax
		call	sub_a_4668
		add	word ptr [bp+8],8
		push	ss
		pop	es
		lea	di,ss:data_c_FF7D_e[bp]	; Load effective addr
loc_a_4E86:
		test	byte ptr ss:data_c_FF76_e[bp],8
		jz	loc_a_4EA3		; Jump if zero
		mov	dx,ss:data_c_FF72_e[bp]
		or	dx,dx			; Zero ?
		jle	loc_a_4EA3		; Jump if < or =
loc_a_4E95:
		call	sub_a_4E98

;==== External Entry into Subroutine ======================================

sub_a_4E98:
		jmp	loc_a_4FF5
			                        ;* No entry point to code
		sub	dx,cx
		jle	loc_a_4EA3		; Jump if < or =
		mov	ss:data_c_FF78_e[bp],dx
loc_a_4EA3:
		mov	al,ss:data_c_FF77_e[bp]
		or	al,al			; Zero ?
		jz	loc_a_4EBF		; Jump if zero
		cmp	byte ptr es:[di],2Dh	; '-'
		je	loc_a_4EBF		; Jump if equal
		dec	di
		sub	word ptr ss:data_c_FF78_e[bp],1
		adc	word ptr ss:data_c_FF78_e[bp],0
		mov	es:[di],al
loc_a_4EBF:
		call	sub_a_4EC2

;==== External Entry into Subroutine ======================================

sub_a_4EC2:
		jmp	loc_a_4FF5
loc_a_4EC5:
		mov	si,di
		mov	di,ss:data_c_FF6E_e[bp]
		mov	bx,ss:data_c_FF72_e[bp]
		mov	al,5
		and	al,ss:data_c_FF76_e[bp]
		cmp	al,5
		jne	loc_a_4F10		; Jump if not equal
		mov	ah,ss:data_c_FF70_e[bp]
		cmp	ah,6Fh			; 'o'
		jne	loc_a_4EF1		; Jump if not equal
		cmp	word ptr ss:data_c_FF78_e[bp],0
		jg	loc_a_4F10		; Jump if >
		mov	word ptr ss:data_c_FF78_e[bp],1
		jmp	short loc_a_4F10
loc_a_4EF1:
		cmp	ah,78h			; 'x'
		je	loc_a_4EFB		; Jump if equal
		cmp	ah,58h			; 'X'
		jne	loc_a_4F10		; Jump if not equal
loc_a_4EFB:
		or	byte ptr ss:data_c_FF76_e[bp],40h	; '@'
		sub	bx,2
		sub	word ptr ss:data_c_FF78_e[bp],2
		jge	loc_a_4F10		; Jump if > or =
		mov	word ptr ss:data_c_FF78_e[bp],0
loc_a_4F10:
		add	cx,ss:data_c_FF78_e[bp]
		test	byte ptr ss:data_c_FF76_e[bp],2
		jnz	loc_a_4F2A		; Jump if not zero
		jmp	short loc_a_4F26
loc_a_4F1D:
		mov	al,20h			; ' '
		call	sub_a_4F22

;==== External Entry into Subroutine ======================================

sub_a_4F22:
		jmp	loc_a_5007
		db	4Bh
loc_a_4F26:
		cmp	bx,cx
		jg	loc_a_4F1D		; Jump if >
loc_a_4F2A:
		test	byte ptr ss:data_c_FF76_e[bp],40h	; '@'
		jz	loc_a_4F43		; Jump if zero
		mov	al,30h			; '0'
		call	sub_a_4F36

;==== External Entry into Subroutine ======================================

sub_a_4F36:
		jmp	loc_a_5007
			                        ;* No entry point to code
		mov	al,ss:data_c_FF70_e[bp]
		call	sub_a_4F40

;==== External Entry into Subroutine ======================================

sub_a_4F40:
		jmp	loc_a_5007
loc_a_4F43:
		mov	dx,ss:data_c_FF78_e[bp]
		or	dx,dx			; Zero ?
		jle	loc_a_4F78		; Jump if < or =
		sub	cx,dx
		sub	bx,dx
		mov	al,es:[si]
		cmp	al,2Dh			; '-'
		je	loc_a_4F5E		; Jump if equal
		cmp	al,20h			; ' '
		je	loc_a_4F5E		; Jump if equal
		cmp	al,2Bh			; '+'
		jne	loc_a_4F68		; Jump if not equal
loc_a_4F5E:
		lods	byte ptr es:[si]	; String [si] to al
		call	sub_a_4F63

;==== External Entry into Subroutine ======================================

sub_a_4F63:
		jmp	loc_a_5007
		db	 49h, 4Bh
loc_a_4F68:
		xchg	cx,dx
		jcxz	loc_a_4F76		; Jump if cx=0
		mov	al,30h			; '0'
		call	sub_a_4F71

;==== External Entry into Subroutine ======================================

sub_a_4F71:
		jmp	loc_a_5007
		db	0E2h,0F6h
loc_a_4F76:
		xchg	cx,dx
loc_a_4F78:
		sub	bx,cx
		jcxz	loc_a_4F8E		; Jump if cx=0

locloop_a_4F7C:
		lods	byte ptr es:[si]	; String [si] to al
		mov	[di],al
		inc	di
		dec	byte ptr [bp-51h]
		jg	loc_a_4F8C		; Jump if >
		call	sub_a_4F89

;==== External Entry into Subroutine ======================================

sub_a_4F89:
		jmp	loc_a_5015
loc_a_4F8C:
		loop	locloop_a_4F7C		; Loop if cx > 0

loc_a_4F8E:
		or	bx,bx			; Zero ?
		jle	loc_a_4F9E		; Jump if < or =
		mov	cx,bx
		mov	al,20h			; ' '
		call	sub_a_4F99

;==== External Entry into Subroutine ======================================

sub_a_4F99:
		jmp	short loc_a_5007
		db	 90h,0E2h,0F6h
loc_a_4F9E:
		jmp	loc_a_4BC3

;===== Indexed Entry Point ================================================

loc_a_4FA1:
		mov	[bp+0Ah],si
		mov	di,[bp+8]
		test	byte ptr ss:data_c_FF76_e[bp],20h	; ' '
		jnz	loc_a_4FB8		; Jump if not zero
		mov	di,[di]
		add	word ptr [bp+8],2
		push	ds
		pop	es
		jmp	short loc_a_4FBE
loc_a_4FB8:
		les	di,dword ptr [di]	; Load seg:offset ptr
		add	word ptr [bp+8],4
loc_a_4FBE:
		mov	ax,50h
		sub	al,[bp-51h]
		add	ax,[bp-54h]
		mov	es:[di],ax
		jmp	loc_a_4BBF

;===== Indexed Entry Point ================================================

loc_a_4FCD:
		mov	si,ss:data_c_FF7A_e[bp]
		mov	di,ss:data_c_FF6E_e[bp]
		mov	al,25h			; '%'
loc_a_4FD7:
		call	sub_a_4FDA

;==== External Entry into Subroutine ======================================

sub_a_4FDA:
		jmp	short loc_a_5007
			                        ;* No entry point to code
		nop
		lodsb				; String [si] to al
		or	al,al			; Zero ?
		jnz	loc_a_4FD7		; Jump if not zero
loc_a_4FE2:
		cmp	byte ptr [bp-51h],50h	; 'P'
		jge	loc_a_4FEE		; Jump if > or =
		call	sub_a_4FEB

;==== External Entry into Subroutine ======================================

sub_a_4FEB:
		jmp	short loc_a_5015
		db	90h
loc_a_4FEE:
		pop	es
		mov	ax,[bp-54h]
		jmp	short loc_a_503D
		db	90h
loc_a_4FF5:
		push	di
		mov	cx,0FFFFh
		mov	al,0
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		not	cx
		dec	cx
		pop	di
		pop	ax
;*		add	ax,offset loc_a_0003	;*
		db	5, 3, 0			;  Fixup - byte match
		jmp	ax			;*Register jump
loc_a_5007:
		mov	[di],al
		inc	di
		dec	byte ptr [bp-51h]
		jle	loc_a_5015		; Jump if < or =
		pop	ax
;*		add	ax,offset loc_a_0003	;*
		db	5, 3, 0			;  Fixup - byte match
		jmp	ax			;*Register jump
loc_a_5015:
		push	bx
		push	cx
		push	dx
		push	es
		lea	ax,[bp-50h]		; Load effective addr
		sub	di,ax
		lea	ax,[bp-50h]		; Load effective addr
		push	ax
		push	di
		push	word ptr [bp+0Ch]
		call	word ptr [bp+0Eh]	;*
		mov	byte ptr [bp-51h],50h	; 'P'
		add	[bp-54h],di
		lea	di,[bp-50h]		; Load effective addr
		pop	es
		pop	dx
		pop	cx
		pop	bx
		pop	ax
;*		add	ax,offset loc_a_0003	;*
		db	5, 3, 0			;  Fixup - byte match
		jmp	ax			;*Register jump
loc_a_503D:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn	8
sub_a_4BA4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5045	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		dec	ax
		mov	dl,data_b_037A
		mov	dh,0
		mul	dx			; dx:ax = reg * ax
		add	ax,data_b_037D
		mov	dx,[bp+PARAMETER_2]
		dec	dx
		add	ax,dx
		shl	ax,1			; Shift w/zeros fill
		mov	dx,data_b_037F
		pop	bp
		retn	4
sub_a_5045	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5068	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		mov	al,data_b_037C
		mov	ah,0
		mov	[bp-2],ax
		push	ds
		mov	cx,[bp+8]
		jcxz	loc_a_50D7		; Jump if cx=0
		les	di,dword ptr [bp+0Eh]	; Load seg:offset ptr
		lds	si,dword ptr [bp+0Ah]	; Load seg:offset ptr
		cld				; Clear direction
		cmp	si,di
		jae	loc_a_5092		; Jump if above or =
		mov	ax,cx
		dec	ax
		shl	ax,1			; Shift w/zeros fill
		add	si,ax
		add	di,ax
		std				; Set direction flag
loc_a_5092:
		cmp	word ptr [bp-2],0
		jne	loc_a_509C		; Jump if not equal
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		jmp	short loc_a_50D7
loc_a_509C:
		mov	dx,3DAh
		mov	ax,es
		mov	bx,ds
		cmp	ax,bx
		je	locloop_a_50B8		; Jump if equal

locloop_a_50A7:
		cli				; Disable interrupts
loc_a_50A8:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		ror	al,1			; Rotate
		jc	loc_a_50A8		; Jump if carry Set
loc_a_50AD:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		ror	al,1			; Rotate
		jnc	loc_a_50AD		; Jump if carry=0
		movsw				; Mov [si] to es:[di]
		sti				; Enable interrupts
		loop	locloop_a_50A7		; Loop if cx > 0

		jmp	short loc_a_50D7

locloop_a_50B8:
		cli				; Disable interrupts
loc_a_50B9:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		ror	al,1			; Rotate
		jc	loc_a_50B9		; Jump if carry Set
loc_a_50BE:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		ror	al,1			; Rotate
		jnc	loc_a_50BE		; Jump if carry=0
		lodsw				; String [si] to ax
		sti				; Enable interrupts
		mov	bx,ax
loc_a_50C7:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		ror	al,1			; Rotate
		jc	loc_a_50C7		; Jump if carry Set
loc_a_50CC:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		ror	al,1			; Rotate
		jnc	loc_a_50CC		; Jump if carry=0
		mov	ax,bx
		stosw				; Store ax to es:[di]
		sti				; Enable interrupts
		loop	locloop_a_50B8		; Loop if cx > 0

loc_a_50D7:
		pop	ds
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn	0Ah
sub_a_5068	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_50E0	proc	near
		mov	ah,3
		mov	bh,0
		call	sub_a_3E83
		mov	ax,dx
		retn
sub_a_50E0	endp

			                        ;* No entry point to code
		call	sub_a_50E0
		mov	ah,0
		mov	dl,byte ptr data_b_0372
		mov	dh,0
		sub	ax,dx
		inc	ax
		retn
			                        ;* No entry point to code
		call	sub_a_50E0
		mov	cx,8
		shr	ax,cl			; Shift w/zeros fill
		mov	ah,0
		mov	dl,byte ptr data_b_0372+1
		mov	dh,0
		sub	ax,dx
		inc	ax
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_510D	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+8]
		mov	si,d_0000_0AB8_e
		mov	byte ptr ds:d_0000_0AB8_e,0
loc_a_511D:
		dec	si
		mov	ax,di
		mov	bx,0Ah
		xor	dx,dx			; Zero register
		div	bx			; ax,dx rem=dx:ax/reg
		add	dl,30h			; '0'
		mov	[si],dl
		mov	ax,di
		xor	dx,dx			; Zero register
		div	bx			; ax,dx rem=dx:ax/reg
		mov	di,ax
		or	di,di			; Zero ?
		jnz	loc_a_511D		; Jump if not zero
		mov	ax,si
		pop	bp
		pop	di
		pop	si
		retn	2
sub_a_510D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Copy ASCIIZ string

sub_a_5140	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		push	ds
		lds	si,dword ptr [bp+8]	; Load seg:offset ptr
		les	di,dword ptr [bp+0Ch]	; Load seg:offset ptr
loc_a_514C:
		lodsb				; String [si] to al
		stosb				; Store al to es:[di]
		and	al,al
		jnz	loc_a_514C		; Jump if not zero
		pop	ds
		mov	dx,[bp+0Eh]
		mov	ax,[bp+0Ch]
		pop	bp
		pop	di
		pop	si
		retn	8
sub_a_5140	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Find end of ASCIIZ string

sub_a_515F	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		les	di,dword ptr [bp+8]	; Load seg:offset ptr
		mov	cx,0FFFFh
		xor	al,al			; Zero register
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		dec	di
		mov	ax,di
		mov	dx,es
		pop	bp
		pop	di
		pop	si
		retn	4
sub_a_515F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; merge strings

sub_a_517A	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		push	ds
		les	di,dword ptr [bp+10h]	; Load seg:offset ptr
		lds	si,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	ax,ds
		or	ax,si
		jz	loc_a_5193		; Jump if zero
loc_a_518C:
		lodsb				; String [si] to al
		stosb				; Store al to es:[di]
		and	al,al
		jnz	loc_a_518C		; Jump if not zero
		dec	di
loc_a_5193:
		lds	si,dword ptr [bp+8]	; Load seg:offset ptr
loc_a_5196:
		lodsb				; String [si] to al
		stosb				; Store al to es:[di]
		and	al,al
		jnz	loc_a_5196		; Jump if not zero
		dec	di
		pop	ds
		mov	ax,di
		mov	dx,es
		pop	bp
		pop	di
		pop	si
		retn	0Ch
sub_a_517A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print DOS string

sub_a_51A8	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		push	ds
		lds	dx,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		mov	ah,9
		int	21h			; DOS Services  ah=function 09h
						;  display char string at ds:dx
		pop	ds
		pop	bp
		retn	4
sub_a_51A8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Close file

sub_a_51B8	proc	near
		mov	bx,ds:d_0000_0AAC_e
		mov	ah,3Eh
		int	21h			; DOS Services  ah=function 3Eh
						;  close file, bx=file handle
		retn
sub_a_51B8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_51C1	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		push	ds
		lds	dx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	ax,3D00h
		int	21h			; DOS Services  ah=function 3Dh
						;  open file, al=mode,name@ds:dx
		pop	ds
		jnc	loc_a_51D7		; Jump if carry=0
		mov	ax,0FFFDh
		jmp	short loc_a_5202
loc_a_51D7:
		mov	ds:d_0000_0AAC_e,ax
		mov	bx,ax
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		mov	ax,4202h
		int	21h			; DOS Services  ah=function 42h
						;  move file ptr, bx=file handle
						;   al=method, cx,dx=offset
		jc	loc_a_51F4		; Jump if carry Set
		and	ax,ax
		jz	loc_a_51F4		; Jump if zero
		and	dx,dx
		jnz	loc_a_51F4		; Jump if not zero
		cmp	ax,3C00h
		jbe	loc_a_51FC		; Jump if below or =
loc_a_51F4:
		call	sub_a_51B8		; Close file
		mov	ax,[bp+8]
		jmp	short loc_a_5202
loc_a_51FC:
		les	di,dword ptr [bp+0Ah]	; Load seg:offset ptr
		stosw				; Store ax to es:[di]
		xor	ax,ax			; Zero register
loc_a_5202:
		pop	bp
		pop	di
		pop	si
		retn	0Ah
sub_a_51C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5208	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		mov	bx,ds:d_0000_0AAC_e
		xor	cx,cx			; Zero register
		mov	dx,[bp+PARAMETER_4]
		mov	ax,4200h
		int	21h			; DOS Services  ah=function 42h
						;  move file ptr, bx=file handle
						;   al=method, cx,dx=offset
		jc	loc_a_5231		; Jump if carry Set
		push	ds
		mov	bx,ds:d_0000_0AAC_e
		mov	cx,[bp+PARAMETER_3]
		lds	dx,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		mov	ah,3Fh
		int	21h			; DOS Services  ah=function 3Fh
						;  read file, bx=file handle
						;   cx=bytes to ds:dx buffer
		pop	ds
		jc	loc_a_5231		; Jump if carry Set
		xor	ax,ax			; Zero register
		jmp	short loc_a_523D
loc_a_5231:
		call	sub_a_51B8		; Close file
		mov	word ptr ds:d_0000_0A9E_e,0FFF4h
		mov	ax,1
loc_a_523D:
		pop	bp
		retn	8
sub_a_5208	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,8
		mov	word ptr [bp-2],0
		mov	word ptr [bp-4],0
		mov	ax,[bp+8]
		sub	ax,0FFF1h
		cmp	ax,0Fh
		jbe	loc_a_5265		; Jump if below or =
		jmp	loc_a_5345
loc_a_5265:
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_526E[bx]	;*16 entries
data_a_526E	dw	offset loc_a_533B	; Data table (indexed access)
data_a_5270	dw	offset loc_a_5331
data_a_5272	dw	offset loc_a_531F
data_a_5274	dw	offset loc_a_5315
data_a_5276	dw	offset loc_a_530B
data_a_5278	dw	offset loc_a_5301
data_a_527A	dw	offset loc_a_52F7
data_a_527C	dw	offset loc_a_52ED
data_a_527E	dw	offset loc_a_52E2
data_a_5280	dw	offset loc_a_52D7
data_a_5282	dw	offset loc_a_52CC
data_a_5284	dw	offset loc_a_52B9
data_a_5286	dw	offset loc_a_52AF
data_a_5288	dw	offset loc_a_52A4
data_a_528A	dw	offset loc_a_5299
data_a_528C	dw	offset loc_a_528E

;===== Indexed Entry Point ================================================

loc_a_528E:
		mov	[bp-6],ds
		mov	word ptr [bp-8],738h
		jmp	loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_5299:
		mov	[bp-6],ds
		mov	word ptr [bp-8],741h
		jmp	loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_52A4:
		mov	[bp-6],ds
		mov	word ptr [bp-8],75Eh
		jmp	loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_52AF:
		mov	[bp-6],ds
		mov	word ptr [bp-8],77Dh
		jmp	short loc_a_52C1

;===== Indexed Entry Point ================================================

loc_a_52B9:
		mov	[bp-6],ds
		mov	word ptr [bp-8],79Ch
loc_a_52C1:
		mov	[bp-2],ds
		mov	word ptr [bp-4],501h
		jmp	loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_52CC:
		mov	[bp-6],ds
		mov	word ptr [bp-8],7B9h
		jmp	loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_52D7:
		mov	[bp-6],ds
		mov	word ptr [bp-8],7DAh
		jmp	short loc_a_535D
		db	90h

;===== Indexed Entry Point ================================================

loc_a_52E2:
		mov	[bp-6],ds
		mov	word ptr [bp-8],7F5h
		jmp	short loc_a_535D
		db	90h

;===== Indexed Entry Point ================================================

loc_a_52ED:
		mov	[bp-6],ds
		mov	word ptr [bp-8],811h
		jmp	short loc_a_5327

;===== Indexed Entry Point ================================================

loc_a_52F7:
		mov	[bp-6],ds
		mov	word ptr [bp-8],827h
		jmp	short loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_5301:
		mov	[bp-6],ds
		mov	word ptr [bp-8],846h
		jmp	short loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_530B:
		mov	[bp-6],ds
		mov	word ptr [bp-8],870h
		jmp	short loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_5315:
		mov	[bp-6],ds
		mov	word ptr [bp-8],87Fh
		jmp	short loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_531F:
		mov	[bp-6],ds
		mov	word ptr [bp-8],892h
loc_a_5327:
		mov	[bp-2],ds
		mov	word ptr [bp-4],4F8h
		jmp	short loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_5331:
		mov	[bp-6],ds
		mov	word ptr [bp-8],8A6h
		jmp	short loc_a_535D

;===== Indexed Entry Point ================================================

loc_a_533B:
		mov	[bp-6],ds
		mov	word ptr [bp-8],8BAh
		jmp	short loc_a_535D
loc_a_5345:
		mov	[bp-6],ds
		mov	word ptr [bp-8],8D0h
		push	word ptr [bp+8]
		call	sub_a_510D
		mov	bx,ax
		push	ds
		pop	es
		mov	[bp-2],es
		mov	[bp-4],bx
loc_a_535D:
		mov	ax,[bp-4]
		or	ax,[bp-2]
		jz	loc_a_538A		; Jump if zero
		push	ds
		mov	ax,0AC5h
		push	ax
		push	word ptr [bp-6]
		push	word ptr [bp-8]
		push	word ptr [bp-2]
		push	word ptr [bp-4]
		call	sub_a_517A		; merge strings
		push	dx
		push	ax
		push	ds
		mov	ax,8E1h
		push	ax
		call	sub_a_5140		; Copy ASCIIZ string
		mov	ax,0AC5h
		mov	dx,ds
		jmp	short loc_a_5398
loc_a_538A:
		push	ds
		mov	ax,0AC5h
		push	ax
		push	word ptr [bp-6]
		push	word ptr [bp-8]
		call	sub_a_5140		; Copy ASCIIZ string
loc_a_5398:
		mov	sp,bp
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_539D	proc	far
		push	ds
		push	si
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	si,ds:d_0000_0A9E_e
		mov	word ptr ds:d_0000_0A9E_e,0
		mov	ax,si
		pop	bp
		pop	si
		pop	ds
		retf				; Return far
sub_a_539D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Error - BGI graphics not initialized

sub_a_53B5	proc	near
		cmp	word ptr ds:d_0000_0616_e,0
		je	loc_a_53C6		; Jump if equal
		push	ds
		mov	ax,8E3h
		push	ax			; PARAMETER_1
		call	sub_a_51A8		; Print DOS string
		jmp	short loc_a_53CE
loc_a_53C6:
		push	ds
		mov	ax,907h
		push	ax			; PARAMETER_1
		call	sub_a_51A8		; Print DOS string
loc_a_53CE:
		mov	ax,1
		push	ax
		callf	sub_a_415D
		pop	cx
		retf
sub_a_53B5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_53D8	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp			; PARAMETER_2
		mov	bp,sp
		push	word ptr [bp+PARAMETER_3]	; PARAMETER_1
		callf	sub_a_4175
		pop	cx
		mov	cx,ax
		or	cx,dx
		jz	loc_a_53F7		; Jump if zero
		or	ax,ax			; Zero ?
		jnz	loc_a_53F7		; Jump if not zero
		mov	bx,ds
		cmp	bx,dx
		jne	loc_a_53F7		; Jump if not equal
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
loc_a_53F7:
		les	bx,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		mov	es:[bx],ax
		mov	es:[bx+2],dx
		mov	ax,1
		jcxz	loc_a_5407		; Jump if cx=0
		dec	ax
loc_a_5407:
		pop	bp
		retn
sub_a_53D8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5409	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		les	bx,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		mov	ax,es:[bx]
		or	ax,es:[bx+2]
		jz	loc_a_5431		; Jump if zero
		cmp	word ptr [bp+PARAMETER_3],0
		je	loc_a_5431		; Jump if equal
		push	word ptr [bp+PARAMETER_3]
		les	bx,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		push	word ptr es:[bx+2]	; PARAMETER_2
		push	word ptr es:[bx]	; PARAMETER_1
		callf	sub_a_4169
		mov	sp,bp
loc_a_5431:
		les	bx,dword ptr [bp+PARAMETER_1]	; Load seg:offset ptr
		mov	word ptr es:[bx+2],0
		mov	word ptr es:[bx],0
		pop	bp
		retn
sub_a_5409	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5441	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	si,[bp+0Eh]
		les	bx,dword ptr [bp+0Ah]	; Load seg:offset ptr
		add	si,es:[bx]
		mov	ax,si
		and	ax,0Fh
		sub	es:[bx],ax
		mov	dx,[bp+10h]
		mov	ax,si
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		add	dx,ax
		and	si,0Fh
		jz	loc_a_5475		; Jump if zero
		mov	cx,[bp+8]
		push	ds
		mov	ds,dx
		mov	es,dx
		xor	di,di			; Zero register
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
loc_a_5475:
		xor	ax,ax			; Zero register
		pop	bp
		pop	di
		pop	si
		retn	0Ah
sub_a_5441	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_547D	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,6
		cmp	word ptr ds:d_0000_0616_e,0
		je	loc_a_549B		; Jump if equal
		mov	ax,0FFF5h
		mov	ds:d_0000_0A9E_e,ax
		jmp	short loc_a_550C
		db	90h
loc_a_549B:
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		cmp	word ptr es:[bx],6B70h
		jne	loc_a_54DC		; Jump if not equal
		les	di,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	cx,0FFFFh
		mov	al,1Ah
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		mov	[bp-6],di
		mov	[bp-4],es
		les	bx,dword ptr [bp-6]	; Load seg:offset ptr
		mov	ax,es:[bx+2]
		mov	[bp-2],ax
		or	ax,ax			; Zero ?
		jc	loc_a_54DC		; Jump if carry Set
		cmp	ax,5
		jbe	loc_a_54CB		; Jump if below or =
		jmp	short loc_a_54DC
loc_a_54CB:
		les	bx,dword ptr [bp-6]	; Load seg:offset ptr
		cmp	byte ptr es:[bx+6],1
		jb	loc_a_54DC		; Jump if below
		cmp	byte ptr es:[bx+8],1
		jbe	loc_a_54E4		; Jump if below or =
loc_a_54DC:
		mov	ax,0FFFCh
		mov	ds:d_0000_0A9E_e,ax
		jmp	short loc_a_550C
loc_a_54E4:
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		push	word ptr [bp-4]
		push	word ptr [bp-6]
		les	bx,dword ptr [bp-6]	; Load seg:offset ptr
		push	word ptr es:[bx+4]
		call	sub_a_5441
		mov	bx,[bp-2]
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:d_0000_061C_e+2[bx],dx
		mov	ds:d_0000_061C_e[bx],ax
		mov	ax,[bp-2]
loc_a_550C:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far
sub_a_547D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5513	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,12h
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		cmp	word ptr es:[bx],4B50h
		jne	loc_a_554D		; Jump if not equal
		les	di,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	cx,0FFFFh
		mov	al,1Ah
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		mov	[bp-10h],di
		mov	[bp-0Eh],es
		les	bx,dword ptr [bp-10h]	; Load seg:offset ptr
		cmp	byte ptr es:[bx+8],1
		jb	loc_a_554D		; Jump if below
		cmp	byte ptr es:[bx+0Ah],1
		jbe	loc_a_5556		; Jump if below or =
loc_a_554D:
		mov	ax,0FFF3h
		mov	ds:d_0000_0A9E_e,ax
		jmp	loc_a_563D
loc_a_5556:
		les	bx,dword ptr [bp-10h]	; Load seg:offset ptr
		add	bx,2
		mov	[bp-0Ah],es
		mov	[bp-0Ch],bx
		mov	word ptr [bp-8],56Bh
		mov	word ptr [bp-2],0FFFFh
		mov	word ptr [bp-4],0
		jmp	short loc_a_55B1
loc_a_5573:
		les	bx,dword ptr [bp-0Ch]	; Load seg:offset ptr
		mov	dx,es:[bx+2]
		mov	ax,es:[bx]
		mov	bx,[bp-8]
		push	dx
		push	ax
		push	ds
		pop	es
		pop	ax
		pop	dx
		cmp	dx,es:[bx+2]
		jne	loc_a_5591		; Jump if not equal
		cmp	ax,es:[bx]
		je	loc_a_55B7		; Jump if equal
loc_a_5591:
		cmp	word ptr [bp-2],0
		jae	loc_a_55AA		; Jump if above or =
		mov	bx,[bp-8]
		cmp	byte ptr [bx],0
		jne	loc_a_55AA		; Jump if not equal
		mov	ax,[bp-4]
		mov	[bp-2],ax
		mov	ax,bx
		mov	[bp-6],ax
loc_a_55AA:
		add	word ptr [bp-8],0Fh
		inc	word ptr [bp-4]
loc_a_55B1:
		cmp	word ptr [bp-4],0Ah
		jb	loc_a_5573		; Jump if below
loc_a_55B7:
		cmp	word ptr [bp-4],0Ah
		jb	loc_a_55EC		; Jump if below
;*		cmp	word ptr [bp-2],0FFFFh
		db	 83h, 7Eh,0FEh,0FFh	;  Fixup - byte match
		jnz	loc_a_55CC		; Jump if not zero
		mov	ax,0FFF5h
		mov	ds:d_0000_0A9E_e,ax
		jmp	short loc_a_563D
		db	90h
loc_a_55CC:
		les	bx,dword ptr [bp-0Ch]	; Load seg:offset ptr
		mov	dx,es:[bx+2]
		mov	ax,es:[bx]
		mov	bx,[bp-6]
		push	dx
		push	ax
		push	ds
		pop	es
		pop	ax
		pop	dx
		mov	es:[bx+2],dx
		mov	es:[bx],ax
		mov	ax,[bp-2]
		mov	[bp-4],ax
loc_a_55EC:
		mov	ax,[bp-4]
		mov	dx,0Fh
		mul	dx			; dx:ax = reg * ax
		add	ax,561h
		mov	[bp-12h],ax
		mov	bx,ax
		push	word ptr [bx+8]		; PARAMETER_3
		mov	dx,ds
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		mov	bx,[bp-12h]
		mov	word ptr [bx+2],0
		mov	word ptr [bx],0
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		push	word ptr [bp-0Eh]
		push	word ptr [bp-10h]
		les	bx,dword ptr [bp-10h]	; Load seg:offset ptr
		push	word ptr es:[bx+6]
		call	sub_a_5441
		mov	bx,[bp-12h]
		mov	[bx+6],dx
		mov	[bx+4],ax
		mov	word ptr [bx+8],0
		mov	ax,[bp-4]
		inc	ax
loc_a_563D:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
sub_a_5513	endp

			                        ;* No entry point to code
		push	ds
		push	si
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	si,ds:d_0000_055F_e
		cmp	word ptr ds:d_0000_0616_e,0
		je	loc_a_5661		; Jump if equal
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		jmp	short loc_a_5667
loc_a_5661:
		mov	ax,[bp+0Ah]
		mov	ds:d_0000_055F_e,ax
loc_a_5667:
		mov	ax,si
		pop	bp
		pop	si
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_566D	proc	near
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		les	bx,dword ptr [bp+0Ah]	; Load seg:offset ptr
		mov	word ptr es:[bx],0
		mov	ax,[bp+8]
		dec	ax
		cmp	ax,9
		ja	loc_a_56E8		; Jump if above
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_5690[bx]	;*10 entries
data_a_5690	dw	offset loc_a_56A4	; Data table (indexed access)
data_a_5692	dw	offset loc_a_56AE
data_a_5694	dw	offset loc_a_56DE
data_a_5696	dw	offset loc_a_56DE
data_a_5698	dw	offset loc_a_56C2
data_a_569A	dw	offset loc_a_56DE
data_a_569C	dw	offset loc_a_56D4
data_a_569E	dw	offset loc_a_56AE
data_a_56A0	dw	offset loc_a_56B8
data_a_56A2	dw	offset loc_a_56D4

;===== Indexed Entry Point ================================================

loc_a_56A4:
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],4
		jmp	short loc_a_56F8

;===== Indexed Entry Point ================================================

loc_a_56AE:
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],5
		jmp	short loc_a_56F8

;===== Indexed Entry Point ================================================

loc_a_56B8:
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],2
		jmp	short loc_a_56F8

;===== Indexed Entry Point ================================================

loc_a_56C2:
		les	bx,dword ptr [bp+0Ah]	; Load seg:offset ptr
		mov	word ptr es:[bx],3
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],3
		jmp	short loc_a_56F8

;===== Indexed Entry Point ================================================

loc_a_56D4:
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],0
		jmp	short loc_a_56F8

;===== Indexed Entry Point ================================================

loc_a_56DE:
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],1
		jmp	short loc_a_56F8
loc_a_56E8:
		les	bx,dword ptr [bp+0Ah]	; Load seg:offset ptr
		mov	word ptr es:[bx],0FFFFh
		les	bx,dword ptr [bp+0Eh]	; Load seg:offset ptr
		mov	word ptr es:[bx],0FFFFh
loc_a_56F8:
		pop	bp
		pop	ds
		retf
sub_a_566D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_56FB	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,4
		push	ss
		lea	ax,[bp+LOCAL_2]		; Load effective addr
		push	ax
		push	ss
		lea	ax,[bp+LOCAL_1]		; Load effective addr
		push	ax
		push	word ptr [bp+PARAMETER_2]
		callf	sub_a_566D
		add	sp,0Ah
		cmp	word ptr [bp+PARAMETER_2],0
		je	loc_a_5740		; Jump if equal
		mov	ax,[bp+PARAMETER_1]
		cmp	ax,[bp+LOCAL_1]
		jl	loc_a_5728		; Jump if <
		cmp	ax,[bp+LOCAL_2]
		jle	loc_a_5740		; Jump if < or =
loc_a_5728:
		cmp	word ptr [bp+LOCAL_2],0
		jge	loc_a_5736		; Jump if > or =
		mov	word ptr ds:d_0000_0A9E_e,0FFF1h
		jmp	short loc_a_573C
loc_a_5736:
		mov	word ptr ds:d_0000_0A9E_e,0FFF6h
loc_a_573C:
		xor	ax,ax			; Zero register
		jmp	short loc_a_5743
loc_a_5740:
		mov	ax,1
loc_a_5743:
		mov	sp,bp
		pop	bp
		retn	4
sub_a_56FB	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		callf	sub_a_6903
		mov	sp,bp
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		cmp	word ptr es:[bx],0
		jge	loc_a_5776		; Jump if > or =
		mov	ax,0FFFEh
		mov	es:[bx],ax
		mov	ds:d_0000_0A9E_e,ax
loc_a_5776:
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5779	proc	near
		mov	word ptr ds:d_0000_0416_e+2,cs
		mov	word ptr ds:d_0000_0416_e,53B5h ; Error - BGI graphics not initialized
		mov	word ptr ds:d_0000_0412_e+2,cs
		mov	word ptr ds:d_0000_0412_e,53B5h ; Error - BGI graphics not initialized
		mov	word ptr ds:d_0000_05F7_e+2,0
		mov	word ptr ds:d_0000_05F7_e,0
		mov	word ptr ds:d_0000_0607_e,0
		mov	word ptr ds:d_0000_0605_e,0
		mov	word ptr ds:d_0000_05FD_e,0
		mov	word ptr ds:d_0000_05FB_e,0
		mov	word ptr ds:d_0000_0603_e,0
		mov	word ptr ds:d_0000_0601_e,0
		mov	word ptr ds:d_0000_0B5D_e+2,0
		mov	word ptr ds:d_0000_0B5D_e,0
		mov	word ptr ds:d_0000_0B61_e,0
		mov	word ptr ds:d_0000_061A_e,0
		mov	word ptr ds:d_0000_0616_e,0
		retn
sub_a_5779	endp

			                        ;* No entry point to code
		push	si
		push	di
		push	bp
		mov	bp,sp
		les	di,dword ptr [bp+8]	; Load seg:offset ptr
		mov	ax,es:[di]
		add	ax,0Fh
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		add	es:[di+2],ax
		mov	word ptr es:[di],0
		pop	bp
		pop	di
		pop	si
		retn	4

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_57FD	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh
PARAMETER_7	=	10h			; bp+10h
LOCAL_15	=	-1Eh			; bp+0FFE2h
LOCAL_14	=	-1Ch			; bp+0FFE4h
LOCAL_13	=	-1Ah			; bp+0FFE6h
LOCAL_12	=	-18h			; bp+0FFE8h
LOCAL_11	=	-16h			; bp+0FFEAh
LOCAL_10	=	-14h			; bp+0FFECh
LOCAL_9		=	-12h			; bp+0FFEEh
LOCAL_8		=	-10h			; bp+0FFF0h
LOCAL_7		=	-0Eh			; bp+0FFF2h
LOCAL_6		=	-0Ch			; bp+0FFF4h
LOCAL_5		=	-0Ah			; bp+0FFF6h
LOCAL_4		=	-8			; bp+0FFF8h
LOCAL_3		=	-6			; bp+0FFFAh
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,64h
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		mov	word ptr es:[bx],0
		push	ss
		lea	ax,[bp-64h]		; Load effective addr
		push	ax
		push	word ptr [bp+PARAMETER_7]
		push	word ptr [bp+PARAMETER_6]
		push	word ptr [bp+PARAMETER_5]
		push	word ptr [bp+PARAMETER_4]
		call	sub_a_517A		; merge strings
		push	ss
		lea	ax,[bp-64h]		; Load effective addr
		push	ax
		push	word ptr [bp+PARAMETER_3]
		push	word ptr [bp+PARAMETER_2]
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_51C1
		mov	ds:d_0000_0A9E_e,ax
		or	ax,ax			; Zero ?
		jz	loc_a_583C		; Jump if zero
		mov	ax,1
		jmp	short loc_a_583E
loc_a_583C:
		xor	ax,ax			; Zero register
loc_a_583E:
		mov	sp,bp
		pop	bp
		retn	0Eh
sub_a_57FD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5844	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+0Ah]
		push	ds
		mov	ax,501h
		push	ax
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,ds:d_0000_0634_e[bx]
		mov	dx,ds
		push	dx
		push	ax
		push	ds
		mov	ax,941h
		push	ax
		call	sub_a_517A		; merge strings
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	dx,word ptr ds:d_0000_061C_e+2[bx]
		mov	ax,ds:d_0000_061C_e[bx]
		mov	word ptr ds:d_0000_0416_e+2,dx
		mov	ds:d_0000_0416_e,ax
		or	dx,ax
		jz	loc_a_5892		; Jump if zero
		mov	word ptr ds:d_0000_05FD_e,0
		mov	word ptr ds:d_0000_05FB_e,0
		mov	word ptr ds:d_0000_05FF_e,0
		jmp	loc_a_593B
loc_a_5892:
		push	word ptr [bp+8]
		push	word ptr [bp+6]
		push	ds
		mov	ax,501h
		push	ax
		push	ds
		mov	ax,5FFh
		push	ax
		mov	ax,0FFFCh
		push	ax
		call	sub_a_57FD
		or	ax,ax			; Zero ?
		jz	loc_a_58C6		; Jump if zero
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		push	ds
		mov	ax,501h
		push	ax
		push	ds
		mov	ax,5FFh
		push	ax
		mov	ax,0FFFCh
		push	ax
		call	sub_a_57FD
		or	ax,ax			; Zero ?
		jnz	loc_a_5922		; Jump if not zero
loc_a_58C6:
		push	word ptr ds:d_0000_05FF_e
		push	ds
		mov	ax,5FBh
		push	ax
		call	sub_a_53D8
		mov	sp,bp
		or	ax,ax			; Zero ?
		jz	loc_a_58E3		; Jump if zero
		call	sub_a_51B8		; Close file
		mov	word ptr ds:d_0000_0A9E_e,0FFFBh
		jmp	short loc_a_5922
loc_a_58E3:
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_4
		push	word ptr ds:d_0000_05FF_e	; PARAMETER_3
		push	word ptr ds:d_0000_05FD_e	; PARAMETER_2
		push	word ptr ds:d_0000_05FB_e	; PARAMETER_1
		call	sub_a_5208
		or	ax,ax			; Zero ?
		jnz	loc_a_5914		; Jump if not zero
		push	word ptr ds:d_0000_05FD_e
		push	word ptr ds:d_0000_05FB_e
		callf	sub_a_547D
		mov	sp,bp
		cmp	ax,si
		je	loc_a_5926		; Jump if equal
		call	sub_a_51B8		; Close file
		mov	word ptr ds:d_0000_0A9E_e,0FFFCh
loc_a_5914:
		push	word ptr ds:d_0000_05FF_e	; PARAMETER_3
		push	ds			; PARAMETER_2
		mov	ax,5FBh
		push	ax			; PARAMETER_1
		call	sub_a_5409
		mov	sp,bp
loc_a_5922:
		xor	ax,ax			; Zero register
		jmp	short loc_a_593E
loc_a_5926:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		les	bx,dword ptr ds:d_0000_061C_e[bx]	; Load seg:offset ptr
		mov	word ptr ds:d_0000_0416_e+2,es
		mov	ds:d_0000_0416_e,bx
		call	sub_a_51B8		; Close file
loc_a_593B:
		mov	ax,1
loc_a_593E:
		pop	bp
		pop	si
		retn	6
sub_a_5844	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5943	proc	near
		push	si
		mov	ax,ds:d_0000_0AC3_e
		dec	ax
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,ds:d_0000_0B4F_e
		mov	al,ds:d_0000_0640_e[bx]
		mov	ah,0
		mov	si,ax
		mov	ax,ds:d_0000_0AC3_e
		sub	ax,3
		cmp	ax,2
		ja	loc_a_59BD		; Jump if above
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_a_596F[bx]	;*
data_a_596F	dw	offset loc_a_5989	; Data table (indexed access)
data_a_5971	dw	offset loc_a_59A3
data_a_5973	dw	offset loc_a_5975

;===== Indexed Entry Point ================================================

loc_a_5975:
		mov	bx,0B3Eh
		push	ds
		push	bx			; PARAMETER_3
		mov	bx,6EBh
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,11h
		callf	sub_a_466C
		jmp	short loc_a_59EB
		db	90h

;===== Indexed Entry Point ================================================

loc_a_5989:
		cmp	word ptr ds:d_0000_0B4F_e,1
		je	loc_a_59DA		; Jump if equal
loc_a_5990:
		mov	bx,0B3Eh
		push	ds
		push	bx			; PARAMETER_3
		mov	bx,6DAh
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,11h
		callf	sub_a_466C
		jmp	short loc_a_59EB

;===== Indexed Entry Point ================================================

loc_a_59A3:
		cmp	word ptr ds:d_0000_0B4F_e,1
		jne	loc_a_5990		; Jump if not equal
		mov	bx,0B3Eh
		push	ds
		push	bx			; PARAMETER_3
		mov	bx,6C9h
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,11h
		callf	sub_a_466C
		jmp	short loc_a_59EB
loc_a_59BD:
		cmp	si,1
		je	loc_a_59C7		; Jump if equal
		cmp	si,4
		jne	loc_a_59DA		; Jump if not equal
loc_a_59C7:
		mov	bx,0B3Eh
		push	ds
		push	bx			; PARAMETER_3
		mov	bx,6FCh
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,11h
		callf	sub_a_466C
		jmp	short loc_a_59EB
loc_a_59DA:
		mov	bx,0B3Eh
		push	ds
		push	bx			; PARAMETER_3
		mov	bx,6B8h
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,11h
		callf	sub_a_466C
loc_a_59EB:
		mov	ax,si
		mov	ds:d_0000_0B3E_e,al
		pop	si
		retn
sub_a_5943	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_59F2	proc	near
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		cmp	word ptr ds:d_0000_0616_e,0
		jne	loc_a_5A04		; Jump if not equal
		callf	sub_a_53B5		; Error - BGI graphics not initialized

loc_a_5A04:
		mov	ax,1
		push	ax
		push	word ptr ds:d_0000_0B2D_e
		push	word ptr ds:d_0000_0B2B_e
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_5D98
		add	sp,0Ah
		call	sub_a_5943
		cmp	byte ptr ds:d_0000_0B3E_e,1
		je	loc_a_5A2D		; Jump if equal
		xor	ax,ax			; Zero register
		push	ax
		callf	sub_a_6197
		pop	cx
loc_a_5A2D:
		mov	byte ptr ds:d_0000_060F_e,0
		callf	sub_a_62FA
		push	ax			; PARAMETER_1
		callf	sub_a_6B04
		pop	cx
		callf	sub_a_62FA
		push	ax
		push	ds
		mov	ax,70Dh
		push	ax
		callf	sub_a_608C
		add	sp,6
		mov	ax,1
		push	ax
		push	ax
		push	ax
		push	ax
		callf	sub_a_666C
		add	sp,8
		callf	sub_a_62FA
		push	ax
		mov	ax,1
		push	ax
		callf	sub_a_6035
		pop	cx
		pop	cx
		mov	ax,1
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_5F8B
		add	sp,6
		mov	ax,1
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_647D
		add	sp,6
		mov	ax,2
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		callf	sub_a_643D
		pop	cx
		pop	cx
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_5E9E
		pop	cx
		pop	cx
		pop	bp
		pop	ds
		retf				; Return far
sub_a_59F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5AA2	proc	far
		push	ds
		push	si
		push	di
		push	bp

		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,8

		mov	[bp-2],cs
		mov	word ptr [bp-4],6F70h

		les	bx,dword ptr [bp-4]	; Load seg:offset ptr
		mov	dx,es:[bx]
		add	dx,bx
		mov	cx,4
		shr	dx,cl			; Shift w/zeros fill
		mov	ax,cs
		add	dx,ax
		xor	ax,ax			; Zero register
		mov	word ptr ds:d_0000_0412_e+2,dx
		mov	ds:d_0000_0412_e,ax

		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr

		push	word ptr es:[bx]
		les	bx,dword ptr [bp+10h]	; Load seg:offset ptr
		push	word ptr es:[bx]
		call	sub_a_56FB
		or	ax,ax			; Zero ?
		jnz	loc_a_5AE8		; Jump if not zero
		jmp	loc_a_5B8E
loc_a_5AE8:
		push	word ptr [bp+12h]	; PARAMETER_6
		push	word ptr [bp+10h]	; PARAMETER_5
		push	word ptr [bp+0Eh]	; PARAMETER_4
		push	word ptr [bp+0Ch]	; PARAMETER_3
		push	ds			; PARAMETER_2
		mov	ax,0B3Ch
		push	ax			; PARAMETER_1
		callf	sub_a_68AB		; Initialize videomode and check display
		add	sp,0Ch

		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr

		cmp	word ptr es:[bx],0
		jge	loc_a_5B17		; Jump if > or =
		mov	word ptr ds:d_0000_0A9E_e,0FFFEh
		mov	word ptr es:[bx],0FFFEh
		jmp	loc_a_5BF3
loc_a_5B17:
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	ax,es:[bx]
		mov	ds:d_0000_0AC3_e,ax
		les	bx,dword ptr [bp+10h]	; Load seg:offset ptr
		mov	ax,es:[bx]
		mov	ds:d_0000_0B4F_e,ax
		mov	ax,[bp+14h]
		or	ax,[bp+16h]
		jnz	loc_a_5B38		; Jump if not zero
		mov	byte ptr ds:d_0000_050E_e,0
		jmp	short loc_a_5B7E

loc_a_5B38:	push	ds
		mov	ax,50Eh
		push	ax
		push	word ptr [bp+16h]
		push	word ptr [bp+14h]
		call	sub_a_5140		; Copy ASCIIZ string

		cmp	byte ptr ds:d_0000_050E_e,0
		je	loc_a_5B7E		; Jump if equal

		push	ds
		mov	ax,50Eh
		push	ax
		call	sub_a_515F		; Find end of ASCIIZ string
		mov	[bp-6],dx
		mov	[bp-8],ax

		les	bx,dword ptr [bp-8]	; Load seg:offset ptr
		dec	bx
		cmp	byte ptr es:[bx],3Ah	; ':'
		je	loc_a_5B7E		; Jump if equal

		mov	bx,ax
		dec	bx
		cmp	byte ptr es:[bx],5Ch	; '\'
		je	loc_a_5B7E		; Jump if equal

		mov	bx,ax
		mov	byte ptr es:[bx],5Ch	; '\'
		inc	word ptr [bp-8]
		mov	bx,[bp-8]
		mov	byte ptr es:[bx],0
loc_a_5B7E:
		push	word ptr ds:d_0000_0B3C_e
		push	ds
		mov	ax,50Eh
		push	ax
		call	sub_a_5844
		or	ax,ax			; Zero ?
		jnz	loc_a_5B9A		; Jump if not zero
loc_a_5B8E:
		mov	ax,ds:d_0000_0A9E_e
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	es:[bx],ax
		jmp	short loc_a_5BF3
		db	90h
loc_a_5B9A:
		callf	sub_a_66F1
		push	si
		push	di
		push	ds
		pop	es
		mov	di,d_0000_0B29_e
		mov	si,ds:d_0000_0609_e
		mov	ds,word ptr ds:d_0000_0609_e+2
		mov	cx,13h
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	di,d_0000_0B51_e
		mov	cx,16h
		xor	al,al			; Zero register
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	ax,es
		mov	ds,ax
		pop	di
		pop	si
		push	word ptr ds:d_0000_055F_e
		push	ds
		mov	ax,0B5Dh
		push	ax
		call	sub_a_53D8
		add	sp,6
		or	ax,ax			; Zero ?
		jz	loc_a_5BF8		; Jump if zero
		mov	word ptr ds:d_0000_0A9E_e,0FFFBh
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	word ptr es:[bx],0FFFBh
		push	word ptr ds:d_0000_05FF_e	; PARAMETER_3
		push	ds			; PARAMETER_2
		mov	ax,5FBh
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
loc_a_5BF3:
		call	sub_a_5779
		jmp	short loc_a_5C2F
loc_a_5BF8:
		les	bx,dword ptr ds:d_0000_0B5D_e	; Load seg:offset ptr
		mov	ds:d_0000_0603_e,es
		mov	ds:d_0000_0601_e,bx
		mov	ax,ds:d_0000_055F_e
		mov	ds:d_0000_0B61_e,ax
		mov	ds:d_0000_0B65_e,ds
		mov	word ptr ds:d_0000_0B63_e,0A9Eh
		push	ds			; PARAMETER_2
		mov	ax,0B51h
		push	ax			; PARAMETER_1
		callf	sub_a_6940
		pop	cx
		pop	cx
		mov	word ptr ds:d_0000_0616_e,1
		callf	sub_a_59F2
		mov	word ptr ds:d_0000_0A9E_e,0
loc_a_5C2F:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
sub_a_5AA2	endp

			                        ;* No entry point to code
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr ds:d_0000_0AC3_e
		push	word ptr [bp+0Ch]
		call	sub_a_56FB
		or	ax,ax			; Zero ?
		jnz	loc_a_5C58		; Jump if not zero
		mov	word ptr ds:d_0000_0A9E_e,0FFF6h
		jmp	short loc_a_5CA4
		db	90h
loc_a_5C58:
		mov	ax,ds:d_0000_05F7_e
		or	ax,word ptr ds:d_0000_05F7_e+2
		jz	loc_a_5C79		; Jump if zero
		les	bx,dword ptr ds:d_0000_05F7_e	; Load seg:offset ptr
		mov	word ptr ds:d_0000_0412_e+2,es
		mov	ds:d_0000_0412_e,bx
		mov	word ptr ds:d_0000_05F7_e+2,0
		mov	word ptr ds:d_0000_05F7_e,0
loc_a_5C79:
		mov	ax,[bp+0Ch]
		mov	ds:d_0000_0B4F_e,ax
		push	ax
		callf	sub_a_674D
		pop	cx
		push	si
		push	di
		push	ds
		pop	es
		mov	di,d_0000_0B29_e
		mov	si,ds:d_0000_0609_e
		mov	ds,word ptr ds:d_0000_0609_e+2
		mov	cx,13h
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	ax,es
		mov	ds,ax
		pop	di
		pop	si
		callf	sub_a_59F2
loc_a_5CA4:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	ax,ds:d_0000_0B4F_e
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5CB6	proc	near
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		callf	sub_a_6781
		mov	ax,ds:d_0000_05F7_e
		or	ax,word ptr ds:d_0000_05F7_e+2
		jnz	loc_a_5CE0		; Jump if not zero
		les	bx,dword ptr ds:d_0000_0412_e	; Load seg:offset ptr
		mov	word ptr ds:d_0000_05F7_e+2,es
		mov	ds:d_0000_05F7_e,bx
		mov	word ptr ds:d_0000_0412_e+2,cs
		mov	word ptr ds:d_0000_0412_e,53B5h ; Error - BGI graphics not initialized
loc_a_5CE0:
		pop	bp
		pop	ds
		retf				; Return far
sub_a_5CB6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5CE3	proc	far
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		cmp	word ptr ds:d_0000_0616_e,0
		jne	loc_a_5CF6		; Jump if not equal
		jmp	loc_a_5D7B
loc_a_5CF6:
		callf	sub_a_5CB6
		push	word ptr ds:d_0000_055F_e	; PARAMETER_3
		push	ds			; PARAMETER_2
		mov	ax,601h
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		mov	ax,ds:d_0000_05FB_e
		or	ax,ds:d_0000_05FD_e
		jz	loc_a_5D35		; Jump if zero
		push	word ptr ds:d_0000_05FF_e	; PARAMETER_3
		push	ds			; PARAMETER_2
		mov	ax,5FBh
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		mov	bx,ds:d_0000_0B3C_e
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:d_0000_061C_e+2[bx],0
		mov	word ptr ds:d_0000_061C_e[bx],0
loc_a_5D35:
		call	sub_a_5779
		xor	di,di			; Zero register
		mov	si,d_0000_0561_e
		jmp	short loc_a_5D76
loc_a_5D3F:
		cmp	byte ptr [si+0Ah],0
		je	loc_a_5D72		; Jump if equal
		cmp	word ptr [si+8],0
		je	loc_a_5D72		; Jump if equal
		push	word ptr [si+8]		; PARAMETER_3
		mov	ax,si
		mov	dx,ds
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		mov	word ptr [si+2],0
		mov	word ptr [si],0
		mov	word ptr [si+6],0
		mov	word ptr [si+4],0
		mov	word ptr [si+8],0
loc_a_5D72:
		inc	di
		add	si,0Fh
loc_a_5D76:
		cmp	di,0Ah
		jb	loc_a_5D3F		; Jump if below
loc_a_5D7B:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far
sub_a_5CE3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5D80	proc	far
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		callf	sub_a_6965
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_5E9E
		pop	cx
		pop	cx
		pop	bp
		pop	ds
		retf				; Return far
sub_a_5D80	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5D98	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	di,[bp+0Eh]
		mov	si,[bp+0Ch]
		or	si,si			; Zero ?
		jl	loc_a_5DD1		; Jump if <
		or	di,di			; Zero ?
		jl	loc_a_5DD1		; Jump if <
		mov	ax,[bp+10h]
		cmp	ax,ds:d_0000_0B2B_e
		ja	loc_a_5DD1		; Jump if above
		mov	ax,[bp+12h]
		cmp	ax,ds:d_0000_0B2D_e
		ja	loc_a_5DD1		; Jump if above
		mov	ax,[bp+10h]
		cmp	ax,si
		jl	loc_a_5DD1		; Jump if <
		mov	ax,[bp+12h]
		cmp	ax,di
		jge	loc_a_5DD9		; Jump if > or =
loc_a_5DD1:
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		jmp	short loc_a_5E0C
loc_a_5DD9:
		mov	ds:d_0000_0A94_e,si
		mov	ds:d_0000_0A96_e,di
		mov	ax,[bp+10h]
		mov	ds:d_0000_0A98_e,ax
		mov	ax,[bp+12h]
		mov	ds:d_0000_0A9A_e,ax
		mov	ax,[bp+14h]
		mov	ds:d_0000_0A9C_e,ax
		push	ax
		push	word ptr [bp+12h]
		push	word ptr [bp+10h]
		push	di
		push	si
		callf	sub_a_6721
		mov	sp,bp
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_5E9E
		mov	sp,bp
loc_a_5E0C:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
sub_a_5D98	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		push	es
		push	bx			; PARAMETER_3
		mov	bx,0A94h
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,0Ah
		callf	sub_a_466C
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,4
		mov	dx,ds:d_0000_0AB0_e
		mov	ax,ds:d_0000_0AAE_e
		mov	[bp-2],dx
		mov	[bp-4],ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_6035
		pop	cx
		pop	cx
		mov	ax,ds:d_0000_0A9A_e
		sub	ax,ds:d_0000_0A96_e
		push	ax			; PARAMETER_4
		mov	ax,ds:d_0000_0A98_e
		sub	ax,ds:d_0000_0A94_e
		push	ax			; PARAMETER_3
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		callf	sub_a_6A19
		add	sp,8
		cmp	word ptr [bp-4],0Ch
		jne	loc_a_5E83		; Jump if not equal
		push	word ptr [bp-2]
		push	ds
		mov	ax,0B6Dh
		push	ax
		callf	sub_a_608C
		add	sp,6
		jmp	short loc_a_5E8F
loc_a_5E83:
		push	word ptr [bp-2]
		push	word ptr [bp-4]
		callf	sub_a_6035
		pop	cx
		pop	cx
loc_a_5E8F:
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		callf	sub_a_5E9E
		pop	cx
		pop	cx
		mov	sp,bp
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5E9E	proc	near
		push	ds
		push	bp			; PARAMETER_3
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+0Ah]	; PARAMETER_2
		push	word ptr [bp+8]		; PARAMETER_1
		callf	sub_a_697C
		mov	sp,bp
		mov	ax,[bp+8]
		mov	ds:d_0000_0612_e,ax
		mov	ax,[bp+0Ah]
		mov	ds:d_0000_0614_e,ax
		pop	bp
		pop	ds
		retf
sub_a_5E9E	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	ax,ds:d_0000_0614_e
		add	ax,[bp+0Ah]
		push	ax
		mov	ax,ds:d_0000_0612_e
		add	ax,[bp+8]
		push	ax
		callf	sub_a_5E9E
		mov	sp,bp
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	ax,ds:d_0000_0612_e
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	ax,ds:d_0000_0614_e
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	ax,ds:d_0000_0B2B_e
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	ax,ds:d_0000_0B2D_e
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp			; PARAMETER_3
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+0Ah]	; PARAMETER_2
		push	word ptr [bp+8]		; PARAMETER_1
		callf	sub_a_6999
		mov	sp,bp
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		callf	sub_a_5E9E
		mov	sp,bp
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp			; PARAMETER_3
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	ax,ds:d_0000_0614_e
		add	ax,[bp+0Ah]
		push	ax			; PARAMETER_2
		mov	ax,ds:d_0000_0612_e
		add	ax,[bp+8]
		push	ax			; PARAMETER_1
		callf	sub_a_6999
		mov	sp,bp
		mov	ax,ds:d_0000_0614_e
		add	ax,[bp+0Ah]
		push	ax
		mov	ax,ds:d_0000_0612_e
		add	ax,[bp+8]
		push	ax
		callf	sub_a_5E9E
		mov	sp,bp
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		push	es
		push	bx			; PARAMETER_3
		mov	bx,0B67h
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,6
		callf	sub_a_466C
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5F8B	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	di,[bp+10h]
		mov	si,[bp+0Ch]
		cmp	si,4
		ja	loc_a_5FA6		; Jump if above
		cmp	di,3
		jbe	loc_a_5FAE		; Jump if below or =
loc_a_5FA6:
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		jmp	short loc_a_5FC5
loc_a_5FAE:
		mov	ds:d_0000_0B67_e,si
		mov	ax,[bp+0Eh]
		mov	ds:d_0000_0B69_e,ax
		mov	ds:d_0000_0B6B_e,di
		push	di
		push	ax
		push	si
		callf	sub_a_6BA4
		mov	sp,bp
loc_a_5FC5:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far
sub_a_5F8B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5FCA	proc	far
		push	ds
		push	si
		push	di
		push	bp			; PARAMETER_5
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	di,[bp+0Eh]
		mov	si,[bp+0Ch]
		push	di			; PARAMETER_4
		push	word ptr [bp+10h]	; PARAMETER_3
		push	di			; PARAMETER_2
		push	si			; PARAMETER_1
		callf	sub_a_69B6
		mov	sp,bp
		push	word ptr [bp+12h]
		push	word ptr [bp+10h]
		push	di
		push	word ptr [bp+10h]
		callf	sub_a_69B6
		mov	sp,bp
		push	word ptr [bp+12h]
		push	si
		push	word ptr [bp+12h]
		push	word ptr [bp+10h]
		callf	sub_a_69B6
		mov	sp,bp
		push	di
		push	si
		push	word ptr [bp+12h]
		push	si
		callf	sub_a_69B6
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
sub_a_5FCA	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	dx,ds:d_0000_0AB0_e
		mov	ax,ds:d_0000_0AAE_e
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		mov	es:[bx+2],dx
		mov	es:[bx],ax
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6035	proc	far
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	di,[bp+0Eh]
		mov	si,[bp+0Ch]
		cmp	si,0Bh
		ja	loc_a_604F		; Jump if above
		or	di,di			; Zero ?
		jge	loc_a_6057		; Jump if > or =
loc_a_604F:
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		jmp	short loc_a_6067
loc_a_6057:
		mov	ds:d_0000_0AAE_e,si
		mov	ds:d_0000_0AB0_e,di
		push	di
		push	si
		callf	sub_a_6C12
		mov	sp,bp
loc_a_6067:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
sub_a_6035	endp

			                        ;* No entry point to code
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	si
		push	di
		mov	si,d_0000_0B6D_e
		les	di,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	cx,8
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		pop	si
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_608C	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		callf	sub_a_62FA
		cmp	ax,[bp+10h]
		jae	loc_a_60A8		; Jump if above or =
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		jmp	short loc_a_60D9
loc_a_60A8:
		mov	word ptr ds:d_0000_0AAE_e,0Ch
		mov	ax,[bp+10h]
		mov	ds:d_0000_0AB0_e,ax
		push	si
		push	di
		lds	si,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	ax,ds
		mov	es,ax
		mov	di,d_0000_0B6D_e
		mov	cx,8
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	ds,ax
		pop	di
		pop	si
		push	word ptr [bp+10h]
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		callf	sub_a_6809
		mov	sp,bp
loc_a_60D9:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far
sub_a_608C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_60DE	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		xor	dx,dx			; Zero register
		mov	ax,2710h
		push	dx
		push	ax
		mov	ax,[bp+PARAMETER_1]
		xor	dx,dx			; Zero register
		mov	bx,ds:d_0000_0B37_e
		xor	cx,cx			; Zero register
		callf	sub_a_449F
		push	dx
		push	ax
		callf	sub_a_433D		; Divide
		pop	bp
		retn	2
sub_a_60DE	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+10h]	; PARAMETER_1
		call	sub_a_60DE
		push	ax
		push	word ptr [bp+10h]
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		callf	sub_a_6A7B
		mov	sp,bp
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6129	proc	far
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+0Ch]	; PARAMETER_1
		call	sub_a_60DE
		push	ax
		push	word ptr [bp+0Ch]
		mov	ax,168h
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		callf	sub_a_6A7B
		mov	sp,bp
		pop	bp
		pop	ds
		retf
sub_a_6129	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	ax,ds:d_0000_0B37_e
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		mov	es:[bx],ax
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	word ptr es:[bx],2710h
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+10h]	; PARAMETER_1
		call	sub_a_60DE
		push	ax
		push	word ptr [bp+10h]
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		callf	sub_a_6AAB
		mov	sp,bp
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6197	proc	near
		push	ds
		push	si
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	si,[bp+0Ah]
		cmp	si,0Fh
		ja	loc_a_61CA		; Jump if above
		mov	ax,si
		mov	ds:d_0000_060F_e,al
		or	si,si			; Zero ?
		jnz	loc_a_61B9		; Jump if not zero
		mov	byte ptr ds:d_0000_0B3F_e,0
		jmp	short loc_a_61C0
loc_a_61B9:
		mov	al,ds:d_0000_0B3F_e[si]
		mov	ds:d_0000_0B3F_e,al
loc_a_61C0:
		mov	al,ds:d_0000_0B3F_e
		cbw				; Convrt byte to word
		push	ax
		callf	sub_a_6B25
		pop	cx
loc_a_61CA:
		pop	bp
		pop	si
		pop	ds
		retf
sub_a_6197	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	al,ds:d_0000_060D_e
		mov	ah,0
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	al,ds:d_0000_060F_e
		mov	ah,0
		pop	bp
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,1Ah
		les	bx,dword ptr [bp+0Ch]	; Load seg:offset ptr
		mov	[bp-14h],es
		mov	[bp-16h],bx
		cmp	word ptr ds:d_0000_0616_e,0
		jne	loc_a_620D		; Jump if not equal
		jmp	loc_a_6294
loc_a_620D:
		les	bx,dword ptr [bp-16h]	; Load seg:offset ptr
		mov	al,es:[bx]
		mov	ah,0
		cmp	ax,10h
		jle	loc_a_6221		; Jump if < or =
		mov	word ptr [bp-18h],10h
		jmp	short loc_a_622C
loc_a_6221:
		les	bx,dword ptr [bp-16h]	; Load seg:offset ptr
		mov	al,es:[bx]
		mov	ah,0
		mov	[bp-18h],ax
loc_a_622C:
		mov	word ptr [bp-1Ah],0
		jmp	short loc_a_6257
loc_a_6233:
		les	bx,dword ptr [bp-16h]	; Load seg:offset ptr
		add	bx,[bp-1Ah]
		mov	al,es:[bx+1]
		cbw				; Convrt byte to word
		cmp	ax,0FFFFh
		jle	loc_a_6254		; Jump if < or =
		mov	bx,[bp-16h]
		add	bx,[bp-1Ah]
		mov	al,es:[bx+1]
		mov	bx,[bp-1Ah]
		mov	ds:d_0000_0B3F_e[bx],al
loc_a_6254:
		inc	word ptr [bp-1Ah]
loc_a_6257:
		mov	ax,[bp-1Ah]
		cmp	ax,[bp-18h]
		jb	loc_a_6233		; Jump if below
		les	bx,dword ptr [bp-16h]	; Load seg:offset ptr
		mov	al,es:[bx+1]
		cbw				; Convrt byte to word
		cmp	ax,0FFFFh
		je	loc_a_6271		; Jump if equal
		mov	byte ptr ds:d_0000_060F_e,0
loc_a_6271:
		push	si
		push	di
		push	ss
		pop	es
		mov	si,d_0000_0B3E_e
		lea	di,[bp-12h]		; Load effective addr
		mov	cx,11h
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		pop	si
		mov	al,ds:d_0000_0618_e
		mov	[bp-1],al
		push	ss			; PARAMETER_2
		lea	ax,[bp-12h]		; Load effective addr
		push	ax			; PARAMETER_1
		callf	sub_a_6B89
		pop	cx
		pop	cx
loc_a_6294:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	di,[bp+0Eh]
		mov	si,[bp+0Ch]
		cmp	word ptr ds:d_0000_0616_e,0
		je	loc_a_62D8		; Jump if equal
		mov	al,ds:d_0000_0B3E_e
		mov	ah,0
		dec	ax
		cmp	ax,si
		jb	loc_a_62D8		; Jump if below
		or	di,di			; Zero ?
		jl	loc_a_62D8		; Jump if <
		mov	ax,di
		mov	ds:d_0000_0B3F_e[si],al
		or	si,si			; Zero ?
		jnz	loc_a_62D0		; Jump if not zero
		mov	byte ptr ds:d_0000_060F_e,0
loc_a_62D0:
		push	di
		push	si
		callf	sub_a_6B6A
		mov	sp,bp
loc_a_62D8:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		push	es
		push	bx			; PARAMETER_3
		mov	bx,0B3Eh
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,11h
		callf	sub_a_466C
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_62FA	proc	near
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		cmp	word ptr ds:d_0000_0616_e,0
		je	loc_a_631F		; Jump if equal
		mov	ax,ds:d_0000_0AC3_e
		dec	ax
		mov	dx,6
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,ds:d_0000_0B4F_e
		mov	al,ds:d_0000_067C_e[bx]
		mov	ah,0
		jmp	short loc_a_6321
loc_a_631F:
		xor	ax,ax			; Zero register
loc_a_6321:
		pop	bp
		pop	ds
		retf				; Return far
sub_a_62FA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6324	proc	far
		push	ds
		push	si
		push	bp			; PARAMETER_5
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+10h]	; PARAMETER_4
		push	word ptr [bp+0Eh]	; PARAMETER_3
		push	word ptr [bp+0Ch]	; PARAMETER_2
		push	word ptr [bp+0Ah]	; PARAMETER_1
		callf	sub_a_6859
		mov	sp,bp
		mov	si,ax
		mov	ax,si
		cmp	ax,0FFFFh
		jne	loc_a_6353		; Jump if not equal
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		xor	ax,ax			; Zero register
		jmp	short loc_a_6355
loc_a_6353:
		mov	ax,si
loc_a_6355:
		pop	bp
		pop	si
		pop	ds
		retf
sub_a_6324	endp

			                        ;* No entry point to code
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		dec	sp
		dec	sp
		les	bx,dword ptr [bp+10h]	; Load seg:offset ptr
		mov	ax,es:[bx]
		mov	[bp-2],ax
		mov	si,es:[bx+2]
		mov	di,si
		mov	ax,[bp+0Eh]
		add	ax,ds:d_0000_0A96_e
		mov	si,ds:d_0000_0B2D_e
		sub	si,ax
		cmp	si,di
		jbe	loc_a_6388		; Jump if below or =
		mov	si,di
loc_a_6388:
		mov	ax,[bp+0Ch]
		add	ax,ds:d_0000_0A94_e
		add	ax,[bp-2]
		cmp	ax,ds:d_0000_0B2B_e
		ja	loc_a_63D0		; Jump if above
		mov	ax,[bp+0Ch]
		add	ax,ds:d_0000_0A94_e
		jl	loc_a_63D0		; Jump if <
		or	si,si			; Zero ?
		jbe	loc_a_63D0		; Jump if below or =
		mov	ax,[bp+0Eh]
		add	ax,ds:d_0000_0A96_e
		jl	loc_a_63D0		; Jump if <
		les	bx,dword ptr [bp+10h]	; Load seg:offset ptr
		mov	es:[bx+2],si
		push	word ptr [bp+14h]
		push	word ptr [bp+12h]
		push	bx
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ch]
		callf	sub_a_6DB0
		add	sp,0Ah
		les	bx,dword ptr [bp+10h]	; Load seg:offset ptr
		mov	es:[bx+2],di
loc_a_63D0:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf
			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		push	es
		push	bx			; PARAMETER_3
		mov	bx,0AB9h
		push	ds			; PARAMETER_2
		push	bx			; PARAMETER_1
		mov	cx,0Ah
		callf	sub_a_466C
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_63F4	proc	far
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]		; PARAMETER_3
		push	word ptr ds:d_0000_0614_e	; PARAMETER_2
		push	word ptr ds:d_0000_0612_e	; PARAMETER_1
		callf	sub_a_6C42
		mov	sp,bp
		cmp	word ptr ds:d_0000_0ABF_e,0
		jne	loc_a_643A		; Jump if not equal
		cmp	word ptr ds:d_0000_0ABB_e,0
		jne	loc_a_643A		; Jump if not equal
		push	word ptr ds:d_0000_0614_e
		push	word ptr [bp+0Ah]	; PARAMETER_2
		push	word ptr [bp+8]		; PARAMETER_1
		callf	sub_a_6CE4
		pop	cx
		pop	cx
		add	ax,ds:d_0000_0612_e
		push	ax
		callf	sub_a_5E9E
		mov	sp,bp
loc_a_643A:
		pop	bp
		pop	ds
		retf				; Return far
sub_a_63F4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_643D	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	di,[bp+0Eh]
		mov	si,[bp+0Ch]
		or	si,si			; Zero ?
		jl	loc_a_6460		; Jump if <
		cmp	si,2
		jg	loc_a_6460		; Jump if >
		or	di,di			; Zero ?
		jl	loc_a_6460		; Jump if <
		cmp	di,2
		jle	loc_a_6468		; Jump if < or =
loc_a_6460:
		mov	word ptr ds:d_0000_0A9E_e,0FFF5h
		jmp	short loc_a_6478
loc_a_6468:
		mov	ds:d_0000_0ABF_e,si
		mov	ds:d_0000_0AC1_e,di
		push	di
		push	si
		callf	sub_a_683C
		mov	sp,bp
loc_a_6478:
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far
sub_a_643D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_647D	proc	near
		push	ds
		push	si
		push	di
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		sub	sp,0Ch
		mov	si,[bp+0Ch]
		cmp	si,0Ah
		jg	loc_a_64AC		; Jump if >
		or	si,si			; Zero ?
		jl	loc_a_64AC		; Jump if <
		or	si,si			; Zero ?
		jz	loc_a_64B5		; Jump if zero
		mov	ax,si
		dec	ax
		mov	dx,0Fh
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		cmp	byte ptr ds:d_0000_056B_e[bx],0
		jne	loc_a_64B5		; Jump if not equal
loc_a_64AC:
		mov	word ptr ds:d_0000_0A9E_e,0FFF2h
		jmp	loc_a_6642
loc_a_64B5:
		or	si,si			; Zero ?
		jnz	loc_a_64BC		; Jump if not zero
		jmp	loc_a_6649
loc_a_64BC:
		cmp	si,ds:d_0000_0AB9_e
		jne	loc_a_64C5		; Jump if not equal
		jmp	loc_a_6649
loc_a_64C5:
		mov	ax,si
		dec	ax
		mov	dx,0Fh
		mul	dx			; dx:ax = reg * ax
		mov	di,ax
		add	di,561h
		cmp	si,ds:d_0000_061A_e
		jne	loc_a_64DC		; Jump if not equal
		jmp	loc_a_662F
loc_a_64DC:
		cmp	word ptr ds:d_0000_061A_e,0
		je	loc_a_652E		; Jump if equal
		mov	ax,ds:d_0000_061A_e
		dec	ax
		mov	dx,0Fh
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		cmp	word ptr ds:d_0000_0569_e[bx],0
		je	loc_a_652E		; Jump if equal
		mov	ax,ds:d_0000_061A_e
		dec	ax
		mov	dx,0Fh
		mul	dx			; dx:ax = reg * ax
		add	ax,561h
		mov	[bp-2],ax
		mov	bx,ax
		push	word ptr [bx+8]		; PARAMETER_3
		mov	dx,ds
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		mov	bx,[bp-2]
		mov	word ptr [bx+2],0
		mov	word ptr [bx],0
		mov	word ptr [bx+6],0
		mov	word ptr [bx+4],0
		mov	word ptr [bx+8],0
loc_a_652E:
		mov	ax,[di+4]
		or	ax,[di+6]
		jz	loc_a_6539		; Jump if zero
		jmp	loc_a_662B
loc_a_6539:
		push	ds
		mov	ax,4F8h
		push	ax
		mov	ax,di
		add	ax,0Ah
		mov	dx,ds
		push	dx
		push	ax
		push	ds
		mov	ax,946h
		push	ax
		call	sub_a_517A		; merge strings
		push	ds
		mov	ax,50Eh
		push	ax
		push	ds
		mov	ax,4F8h
		push	ax
		push	ss
		lea	ax,[bp-0Ch]		; Load effective addr
		push	ax
		mov	ax,0FFF3h
		push	ax
		call	sub_a_57FD
		or	ax,ax			; Zero ?
		jz	loc_a_6595		; Jump if zero
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		push	ds
		mov	ax,4F8h
		push	ax
		push	ss
		lea	ax,[bp-0Ch]		; Load effective addr
		push	ax
		mov	ax,0FFF3h
		push	ax
		call	sub_a_57FD
		or	ax,ax			; Zero ?
		jz	loc_a_6595		; Jump if zero
;*		cmp	word ptr ds:d_0000_0A9E_e,0FFFDh
		db	 83h, 3Eh, 9Eh, 0Ah,0FDh	;  Fixup - byte match
		jz	loc_a_658C		; Jump if zero
		jmp	loc_a_6642
loc_a_658C:
		mov	word ptr ds:d_0000_0A9E_e,0FFF8h
		jmp	loc_a_6642
loc_a_6595:
		mov	ax,[bp-0Ch]
		add	ax,10h
		push	ax
		push	ss
		lea	ax,[bp-0Ah]		; Load effective addr
		push	ax
		call	sub_a_53D8
		add	sp,6
		or	ax,ax			; Zero ?
		jz	loc_a_65B7		; Jump if zero
		call	sub_a_51B8		; Close file
		mov	word ptr ds:d_0000_0A9E_e,0FFF7h
		jmp	loc_a_6642
loc_a_65B7:
		mov	dx,[bp-8]
		mov	ax,[bp-0Ah]
		add	ax,0Fh
		mov	cx,4
		shr	ax,cl			; Shift w/zeros fill
		add	dx,ax
		xor	ax,ax			; Zero register
		mov	[bp-4],dx
		mov	[bp-6],ax
		push	ax			; PARAMETER_4
		push	word ptr [bp-0Ch]	; PARAMETER_3
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_5208
		or	ax,ax			; Zero ?
		jz	loc_a_65F0		; Jump if zero
		mov	ax,[bp-0Ch]
		add	ax,10h
		push	ax			; PARAMETER_3
		push	ss			; PARAMETER_2
		lea	ax,[bp-0Ah]		; Load effective addr
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		jmp	short loc_a_6642
loc_a_65F0:
		call	sub_a_51B8		; Close file
		push	word ptr [bp-4]
		push	word ptr [bp-6]
		callf	sub_a_5513
		pop	cx
		pop	cx
		cmp	ax,si
		je	loc_a_6617		; Jump if equal
		mov	ax,[bp-0Ch]
		add	ax,10h
		push	ax			; PARAMETER_3
		push	ss			; PARAMETER_2
		lea	ax,[bp-0Ah]		; Load effective addr
		push	ax			; PARAMETER_1
		call	sub_a_5409
		add	sp,6
		jmp	short loc_a_663C
loc_a_6617:
		mov	dx,[bp-8]
		mov	ax,[bp-0Ah]
		mov	[di+2],dx
		mov	[di],ax
		mov	ax,[bp-0Ch]
		add	ax,10h
		mov	[di+8],ax
loc_a_662B:
		mov	ds:d_0000_061A_e,si
loc_a_662F:
		les	bx,dword ptr [di+4]	; Load seg:offset ptr
		mov	ds:d_0000_0607_e,es
		mov	ds:d_0000_0605_e,bx
		jmp	short loc_a_6649
loc_a_663C:
		mov	word ptr ds:d_0000_0A9E_e,0FFF3h
loc_a_6642:
		xor	si,si			; Zero register
		mov	word ptr [bp+10h],1
loc_a_6649:
		mov	ds:d_0000_0AB9_e,si
		mov	ax,[bp+0Eh]
		mov	ds:d_0000_0ABB_e,ax
		mov	ax,[bp+10h]
		mov	ds:d_0000_0ABD_e,ax
		push	ax
		push	word ptr [bp+0Eh]
		push	si
		callf	sub_a_6C78
		add	sp,6
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		pop	ds
		retf				; Return far
sub_a_647D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_666C	proc	near
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		mov	ax,[bp+8]
		cmp	ax,ds:d_0000_0B2B_e
		ja	loc_a_66A9		; Jump if above
		mov	ax,[bp+0Ah]
		cmp	ax,ds:d_0000_0B2B_e
		ja	loc_a_66A9		; Jump if above
		mov	ax,[bp+0Ch]
		cmp	ax,ds:d_0000_0B2D_e
		ja	loc_a_66A9		; Jump if above
		mov	ax,[bp+0Eh]
		cmp	ax,ds:d_0000_0B2D_e
		ja	loc_a_66A9		; Jump if above
		push	ax
		push	word ptr [bp+0Ch]
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		callf	sub_a_6CBE
		mov	sp,bp
loc_a_66A9:
		pop	bp
		pop	ds
		retf
sub_a_666C	endp

			                        ;* No entry point to code
		push	ds
		push	bp
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		mov	bp,sp
		callf	sub_a_6D11
		pop	bp
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_66BC	proc	near
		push	es
		push	bx
		retf				; Return far
sub_a_66BC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_66BF	proc	near
		cmp	byte ptr ds:d_0000_0955_e,0FFh
		jne	loc_ret_a_66F0		; Jump if not equal
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		mov	ds:d_0000_0955_e,al
		mov	ax,40h
		mov	es,ax
		mov	bx,d_0040_0010_e
		mov	al,es:[bx]
		mov	byte ptr ds:d_0000_0955_e+1,al
		cmp	byte ptr ds:d_0000_094E_e,5
		je	loc_ret_a_66F0		; Jump if equal
		cmp	byte ptr ds:d_0000_094E_e,7
		je	loc_ret_a_66F0		; Jump if equal
		and	al,0CFh
		or	al,10h
		mov	es:[bx],al

loc_ret_a_66F0:
		retn
sub_a_66BF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_66F1	proc	near
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	byte ptr ds:d_0000_0955_e,0FFh
		xor	al,al			; Zero register
		xor	ch,ch			; Zero register
		mov	cl,byte ptr ds:d_0000_094C_e+1
		les	bx,dword ptr ds:d_0000_0416_e	; Load seg:offset ptr
		mov	si,0
		call	dword ptr ds:d_0000_0412_e
		mov	word ptr ds:d_0000_0609_e+2,es
		mov	ds:d_0000_0609_e,bx
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_66F1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6721	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	cx,[bp+PARAMETER_4]
		mov	dx,[bp+PARAMETER_5]
		cmp	byte ptr [bp+PARAMETER_6],0
		jne	loc_a_6741		; Jump if not equal
		or	ah,80h
loc_a_6741:
		mov	si,38h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6721	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_674D	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		call	sub_a_66BF
		mov	al,[bp+PARAMETER_2]
		cmp	al,0Ah
		jae	loc_a_6771		; Jump if above or =
		mov	byte ptr ds:d_0000_094C_e+1,al
		push	word ptr ds:d_0000_0955_e
		callf	sub_a_66F1
		pop	word ptr ds:d_0000_0955_e
loc_a_6771:
		les	bx,dword ptr ds:d_0000_0951_e	; Load seg:offset ptr
		mov	si,2
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_674D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6781	proc	near
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		cmp	byte ptr ds:d_0000_0955_e,0FFh
		je	loc_a_67B4		; Jump if equal
		mov	si,6
		call	dword ptr ds:d_0000_0412_e
		mov	ax,40h
		mov	es,ax
		mov	bx,d_0040_0010_e
		mov	al,byte ptr ds:d_0000_0955_e+1
		mov	es:[bx],al
		xor	ah,ah			; Zero register
		mov	al,ds:d_0000_0955_e
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	byte ptr ds:d_0000_0955_e,0FFh
loc_a_67B4:
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_6781	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	al,[bp+6]
		cmp	byte ptr ds:d_0000_094C_e,3
		jne	loc_a_67DA		; Jump if not equal
		mov	dx,3B8h
		ror	al,1			; Rotate
		and	al,80h
		or	al,0Ah
		out	dx,al			; port 3B8h, MDA video control
		jmp	short loc_a_67DE
loc_a_67DA:
		mov	ah,5
		int	10h			; Video display   ah=functn 05h
						;  set display page al
loc_a_67DE:
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	al,[bp+6]
		xor	ah,ah			; Zero register
		push	ax
		mov	si,32h
		call	dword ptr ds:d_0000_0412_e
		mov	bx,es:[bx+0Ah]
		pop	ax
		callf	sub_a_66BC
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6809	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ah,[bp+PARAMETER_4]
		mov	ds:d_0000_060E_e,ah
		mov	al,ds:d_0000_060D_e
		mov	si,1Eh
		call	dword ptr ds:d_0000_0412_e
		mov	byte ptr ds:d_0000_0611_e,0Ch
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		mov	ax,0FFFFh
		mov	si,20h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6809	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_683C	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ah,[bp+PARAMETER_2]
		mov	al,[bp+PARAMETER_3]
		mov	si,2Ah
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_683C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6859	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_4]
		sub	ax,[bp+PARAMETER_2]
		jns	loc_a_686E		; Jump if not sign
		neg	ax
loc_a_686E:
		inc	ax
		add	ax,7
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		push	ax
		mov	si,32h
		call	dword ptr ds:d_0000_0412_e
		mov	bx,es:[bx+8]
		callf	sub_a_66BC
		pop	bx
		mul	bx			; dx:ax = reg * ax
		mov	cx,[bp+PARAMETER_5]
		sub	cx,[bp+PARAMETER_3]
		jns	loc_a_6895		; Jump if not sign
		neg	cx
loc_a_6895:
		inc	cx
		mul	cx			; dx:ax = reg * ax
		add	ax,6
		jc	loc_a_68A1		; Jump if carry Set
		and	dx,dx
		jz	loc_a_68A6		; Jump if zero
loc_a_68A1:
		mov	ax,0FFFFh
		mov	dx,ax
loc_a_68A6:
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6859	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Initialize videomode and check display

sub_a_68AB	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	byte ptr ds:d_0000_094C_e,0FFh
		mov	byte ptr ds:d_0000_094C_e+1,0
		les	di,dword ptr [bp+PARAMETER_4]	; Load seg:offset ptr
		mov	al,es:[di]
		mov	ds:d_0000_094E_e,al
		and	al,al
		jnz	loc_a_68DB		; Jump if not zero
		add	bp,4
		call	sub_a_691E		; Initialize videomode and check display
		sub	bp,4
		mov	al,ds:d_0000_094C_e
		jmp	short loc_a_68F6
loc_a_68DB:
		les	di,dword ptr [bp+PARAMETER_6]	; Load seg:offset ptr
		mov	al,es:[di]
		mov	byte ptr ds:d_0000_094C_e+1,al
		les	di,dword ptr [bp+PARAMETER_4]	; Load seg:offset ptr
		mov	bl,es:[di]
		xor	bh,bh			; Zero register
		add	bx,offset data_a_6DD3
		mov	al,cs:[bx]
		mov	ds:d_0000_094C_e,al
loc_a_68F6:
		les	di,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		xor	ah,ah			; Zero register
		mov	es:[di],ax
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_68AB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6903	proc	near
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		push	word ptr ds:d_0000_094C_e
		call	sub_a_691E		; Initialize videomode and check display
		pop	word ptr ds:d_0000_094C_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6903	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Initialize videomode and check display

sub_a_691E	proc	near
		push	bp
		call	sub_a_6DF7		; Initialize videomode and check display
		pop	bp
		les	di,dword ptr [bp+6]	; Load seg:offset ptr
		mov	al,ds:d_0000_094E_e
		xor	ah,ah			; Zero register
		cmp	al,0FFh
		jne	loc_a_6931		; Jump if not equal
		mov	ah,al
loc_a_6931:
		mov	es:[di],ax
		xor	ah,ah			; Zero register
		mov	al,byte ptr ds:d_0000_094C_e+1
		les	di,dword ptr [bp+0Ah]	; Load seg:offset ptr
		mov	es:[di],ax
		retn
sub_a_691E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6940	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		call	sub_a_66BF
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		mov	ds:d_0000_0951_e,bx
		mov	word ptr ds:d_0000_0951_e+2,es
		mov	si,2
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6940	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6965	proc	near
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	si,4
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6965	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_697C	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	si,8
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_697C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6999	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	si,0Ah
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6999	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_69B6	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	cx,[bp+PARAMETER_4]
		mov	dx,[bp+PARAMETER_5]
		mov	si,0Ch
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_69B6	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	cx,[bp+6]
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		mov	ax,6
		mov	si,0Eh
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	cx,[bp+6]
		les	bx,dword ptr [bp+8]	; Load seg:offset ptr
		mov	ax,7
		mov	si,0Eh
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6A19	proc	far

PARAMETER_1	=	6			; bp+6
PARAMETER_2	=	8			; bp+8
PARAMETER_3	=	0Ah			; bp+0Ah
PARAMETER_4	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_1]
		mov	bx,[bp+PARAMETER_2]
		mov	cx,[bp+PARAMETER_3]
		mov	dx,[bp+PARAMETER_4]
		mov	si,12h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_6A19	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+6]
		mov	bx,[bp+8]
		mov	cx,[bp+0Ah]
		mov	dx,[bp+0Ch]
		cmp	ax,cx
		jb	loc_a_6A58		; Jump if below
		xchg	cx,ax
loc_a_6A58:
		cmp	bx,dx
		jae	loc_a_6A5E		; Jump if above or =
		xchg	bx,dx
loc_a_6A5E:
		push	cx
		push	dx
		mov	si,8
		call	dword ptr ds:d_0000_0412_e
		pop	bx
		pop	ax
		mov	cx,[bp+0Eh]
		mov	dx,[bp+10h]
		mov	si,10h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6A7B	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh
PARAMETER_7	=	10h			; bp+10h

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	si,8
		call	dword ptr ds:d_0000_0412_e
		mov	ax,[bp+PARAMETER_4]
		mov	bx,[bp+PARAMETER_5]
		mov	cx,[bp+PARAMETER_6]
		mov	dx,[bp+PARAMETER_7]
		mov	si,14h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6A7B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6AAB	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh
PARAMETER_7	=	10h			; bp+10h

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	si,8
		call	dword ptr ds:d_0000_0412_e
		mov	ax,[bp+PARAMETER_4]
		mov	bx,[bp+PARAMETER_5]
		mov	cx,[bp+PARAMETER_6]
		mov	dx,[bp+PARAMETER_7]
		mov	si,16h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_6AAB	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		push	ds
		mov	ax,0FFFFh
		mov	si,14h
		call	dword ptr ds:d_0000_0412_e
		mov	si,bx
		push	es
		pop	ds
		les	di,dword ptr [bp+6]	; Load seg:offset ptr
		cld				; Clear direction
		mov	cx,6
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6B04	proc	far

PARAMETER_1	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	al,[bp+PARAMETER_1]
		mov	ds:d_0000_060D_e,al
		mov	ah,ds:d_0000_060E_e
		mov	si,1Eh
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6B04	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6B25	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	bl,[bp+PARAMETER_2]
		xor	bh,bh			; Zero register
		mov	ax,0FFFFh
		mov	si,1Ah
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_6B25	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+6]
		or	ah,80h
		mov	bx,[bp+8]
		mov	cx,[bp+0Ah]
		mov	dx,[bp+0Ch]
		mov	si,1Ah
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6B6A	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		xor	ah,ah			; Zero register
		mov	bx,[bp+PARAMETER_3]
		mov	si,1Ah
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6B6A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6B89	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		inc	bx
		mov	si,1Ch
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6B89	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6BA4	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	ds:d_0000_0610_e,al
		mov	bx,[bp+PARAMETER_3]
		mov	cl,[bp+PARAMETER_4]
		mov	ds:d_0000_0950_e,cl
		xor	ch,ch			; Zero register
		mov	si,22h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_6BA4	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+6]
		mov	bx,[bp+8]
		mov	cx,[bp+0Ah]
		les	si,dword ptr ds:d_0000_0951_e	; Load seg:offset ptr
		mov	di,es:[si+0Ch]
		mov	dx,es:[si+0Eh]
		add	di,es:[si+10h]
		sub	di,2
		cli				; Disable interrupts
		xchg	sp,di
		mov	bp,ss
		mov	ss,dx
		sti				; Enable interrupts
		push	di
		push	bp
		mov	si,2Ch
		call	dword ptr ds:d_0000_0412_e
		pop	bx
		pop	ax
		cli				; Disable interrupts
		mov	ss,bx
		mov	sp,ax
		sti				; Enable interrupts
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6C12	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ah,[bp+PARAMETER_3]
		mov	ds:d_0000_060E_e,ah
		mov	al,ds:d_0000_060D_e
		mov	si,1Eh
		call	dword ptr ds:d_0000_0412_e
		mov	al,[bp+PARAMETER_2]
		mov	ds:d_0000_0611_e,al
		mov	ah,al
		mov	si,20h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6C12	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6C42	proc	far

PARAMETER_1	=	6			; bp+6
PARAMETER_2	=	8			; bp+8
PARAMETER_3	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_1]
		mov	bx,[bp+PARAMETER_2]
		mov	si,8
		call	dword ptr ds:d_0000_0412_e
		les	bx,dword ptr [bp+PARAMETER_3]	; Load seg:offset ptr
		mov	di,bx
		xor	al,al			; Zero register
		mov	cx,0FFFFh
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		mov	cx,di
		sub	cx,bx
		dec	cx
		mov	si,26h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6C42	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6C78	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		les	bx,dword ptr ds:d_0000_0609_e	; Load seg:offset ptr
		mov	bx,es:[bx+10h]
		and	bx,7F7Fh
		mov	dl,[bp+PARAMETER_4]
		mov	al,bh
		mul	dl			; ax = reg * al
		mov	cx,ax
		mov	al,bl
		mul	dl			; ax = reg * al
		mov	bx,ax
		mov	al,[bp+PARAMETER_2]
		mov	ah,[bp+PARAMETER_3]
		and	al,al
		jz	loc_a_6CB2		; Jump if zero
		mov	cl,dl
		xor	ch,ch			; Zero register
		mov	bx,cx
		mov	dx,ds:d_0000_0607_e
loc_a_6CB2:
		mov	si,24h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6C78	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6CBE	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_3]
		mov	cx,[bp+PARAMETER_4]
		mov	dx,[bp+PARAMETER_5]
		or	ah,80h
		mov	si,24h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6CBE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6CE4	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		mov	di,bx
		xor	al,al			; Zero register
		mov	cx,0FFFFh
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		mov	cx,di
		sub	cx,bx
		dec	cx
		mov	si,28h
		call	dword ptr ds:d_0000_0412_e
		mov	ax,bx
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6CE4	endp

		db	 4Dh, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6D11	proc	near
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	cx,1
		push	cs
		pop	es
		mov	bx,6D0Fh
		mov	si,28h
		call	dword ptr ds:d_0000_0412_e
		mov	ax,cx
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
sub_a_6D11	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+6]
		mov	bx,[bp+8]
		mov	si,2Eh
		call	dword ptr ds:d_0000_0412_e
		xor	ah,ah			; Zero register
		mov	al,dl
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		mov	ax,[bp+6]
		mov	bx,[bp+8]
		mov	dl,[bp+0Ah]
		mov	si,30h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6D73	proc	far

PARAMETER_1	=	6			; bp+6
PARAMETER_2	=	8			; bp+8
PARAMETER_3	=	0Ah			; bp+0Ah
PARAMETER_4	=	0Ch			; bp+0Ch
PARAMETER_5	=	0Eh			; bp+0Eh

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		les	bx,dword ptr [bp+PARAMETER_5]	; Load seg:offset ptr
		mov	cx,[bp+PARAMETER_1]
		mov	dx,[bp+PARAMETER_2]
		mov	si,[bp+PARAMETER_3]
		mov	di,[bp+PARAMETER_4]
		cmp	cx,si
		jb	loc_a_6D93		; Jump if below
		xchg	si,cx
loc_a_6D93:
		cmp	dx,di
		jb	loc_a_6D99		; Jump if below
		xchg	di,dx
loc_a_6D99:
		sub	si,cx
		mov	es:[bx],si
		sub	di,dx
		mov	es:[bx+2],di
		mov	si,34h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6D73	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6DB0	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh

		push	bp
		mov	bp,sp
		push	ds
		mov	ds,cs:data_a_01A3	; data segment DS = seg_b
		push	si
		push	di
		les	bx,dword ptr [bp+PARAMETER_4]	; Load seg:offset ptr
		mov	cx,[bp+PARAMETER_2]
		mov	dx,[bp+PARAMETER_3]
		mov	al,[bp+PARAMETER_6]
		mov	si,36h
		call	dword ptr ds:d_0000_0412_e
		pop	di
		pop	si
		pop	ds
		pop	bp
		retf				; Return far
sub_a_6DB0	endp

data_a_6DD3	db	0			; Data table (indexed access)
		db	0, 0, 1, 1, 1, 2
		db	3, 4, 1, 5, 6
data_a_6DDF	db	0			; Data table (indexed access)
		db	4, 5, 1, 0, 3, 0
		db	0, 5, 2, 0, 0
data_a_6DEB	db	0			; Data table (indexed access)
		db	4, 5, 1, 0, 3, 0
		db	0, 5, 2, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Initialize videomode and check display

sub_a_6DF7	proc	near
		mov	byte ptr ds:d_0000_094C_e,0FFh
		mov	byte ptr ds:d_0000_094E_e,0FFh
		mov	byte ptr ds:d_0000_094C_e+1,0
		call	sub_a_6E2D		; Initialize videomode and check display
		mov	bl,ds:d_0000_094E_e
		cmp	bl,0FFh
		je	loc_ret_a_6E2C		; Jump if equal
		xor	bh,bh			; Zero register
		mov	al,cs:data_a_6DD3[bx]
		mov	ds:d_0000_094C_e,al
		mov	al,cs:data_a_6DDF[bx]
		mov	byte ptr ds:d_0000_094C_e+1,al
		mov	al,cs:data_a_6DEB[bx]
		mov	ds:d_0000_094F_e,al

loc_ret_a_6E2C:
		retn
sub_a_6DF7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Initialize videomode and check display

sub_a_6E2D	proc	near
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		cmp	al,7
		je	loc_a_6E66		; Jump if equal
		call	sub_a_6F0B
		jnc	loc_a_6E40		; Jump if carry=0
		mov	byte ptr ds:d_0000_094E_e,6
		retn
loc_a_6E40:
		call	sub_a_6E94		; Check EGA
		jnc	loc_a_6E49		; Jump if carry=0
loc_a_6E45:
		call	sub_a_6EB2
		retn
loc_a_6E49:
		call	sub_a_6F40
		and	ax,ax
		jz	loc_a_6E56		; Jump if zero
		mov	byte ptr ds:d_0000_094E_e,0Ah
		retn
loc_a_6E56:
		mov	byte ptr ds:d_0000_094E_e,1
		call	sub_a_6EEA
		jnc	loc_ret_a_6E65		; Jump if carry=0
		mov	byte ptr ds:d_0000_094E_e,2

loc_ret_a_6E65:
		retn
loc_a_6E66:
		call	sub_a_6E94		; Check EGA
		jc	loc_a_6E45		; Jump if carry Set
		call	sub_a_6F0E
		and	al,al
		jz	loc_a_6E78		; Jump if zero
		mov	byte ptr ds:d_0000_094E_e,7
		retn
loc_a_6E78:
		mov	si,d_B800_B800_e
		mov	es,si
		xor	si,si			; Zero register
		mov	ax,es:[si]
		not	ax
		not	word ptr es:[si]
		nop
		nop
		cmp	ax,es:[si]
		jne	loc_ret_a_6E93		; Jump if not equal
		mov	byte ptr ds:d_0000_094E_e,1

loc_ret_a_6E93:
		retn
sub_a_6E2D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check EGA

sub_a_6E94	proc	near
		mov	ax,1200h
		mov	bl,10h
		mov	bh,0FFh
		mov	cl,0Fh
		int	10h			; Video display   ah=functn 12h
						;  EGA/VGA special, bl=function
		cmp	cl,0Ch
		jge	loc_a_6EB0		; Jump if > or =
		cmp	bh,1
		jg	loc_a_6EB0		; Jump if >
		cmp	bl,3
		jg	loc_a_6EB0		; Jump if >
		stc				; Set carry flag
		retn
loc_a_6EB0:
		clc				; Clear carry flag
		retn
sub_a_6E94	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6EB2	proc	near
		mov	byte ptr ds:d_0000_094E_e,4
		cmp	bh,1
		je	loc_a_6ED5		; Jump if equal
		call	sub_a_6EDB
		jc	loc_ret_a_6ED4		; Jump if carry Set
		and	bl,bl
		jz	loc_ret_a_6ED4		; Jump if zero
		mov	byte ptr ds:d_0000_094E_e,3
		call	sub_a_6EEA
		jnc	loc_ret_a_6ED4		; Jump if carry=0
		mov	byte ptr ds:d_0000_094E_e,9

loc_ret_a_6ED4:
		retn
loc_a_6ED5:
		mov	byte ptr ds:d_0000_094E_e,5
		retn
sub_a_6EB2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6EDB	proc	near
		cmp	cl,2
		jb	loc_ret_a_6EE9		; Jump if below
		cmp	cl,6
		cmc				; Complement carry
		jnc	loc_ret_a_6EE9		; Jump if carry=0
		cmp	cl,8

loc_ret_a_6EE9:
		retn
sub_a_6EDB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6EEA	proc	near
		mov	ax,1A00h
		int	10h			; Video display   ah=functn 1Ah
						;  get display type in bx
		cmp	al,1Ah
		jne	loc_a_6F09		; Jump if not equal
		cmp	bl,7
		je	loc_a_6F07		; Jump if equal
		cmp	bl,8
		je	loc_a_6F07		; Jump if equal
		cmp	bl,0Bh
		jb	loc_a_6F09		; Jump if below
		cmp	bl,0Ch
		ja	loc_a_6F09		; Jump if above
loc_a_6F07:
		stc				; Set carry flag
		retn
loc_a_6F09:
		clc				; Clear carry flag
		retn
sub_a_6EEA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6F0B	proc	near
		xor	al,al			; Zero register
		retn
sub_a_6F0B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6F0E	proc	near
		mov	dx,3BAh
		xor	bl,bl			; Zero register
		in	al,dx			; port 3BAh, MDA/EGA vid status
		and	al,80h
		mov	ah,al
		mov	cx,8000h

locloop_a_6F1B:
		in	al,dx			; port 3BAh, MDA/EGA vid status
		and	al,80h
		cmp	al,ah
		je	loc_a_6F29		; Jump if equal
		inc	bl
		cmp	bl,0Ah
		jae	loc_a_6F2E		; Jump if above or =
loc_a_6F29:
		loop	locloop_a_6F1B		; Loop if cx > 0

		xor	al,al			; Zero register
		retn
loc_a_6F2E:
		mov	cx,8000h

locloop_a_6F31:
		in	al,dx			; port 3BAh, MDA/EGA vid status
		and	al,30h			; '0'
		cmp	al,10h
		jne	loc_a_6F3D		; Jump if not equal
		loop	locloop_a_6F31		; Loop if cx > 0

		mov	al,2
		retn
loc_a_6F3D:
		mov	al,1
		retn
sub_a_6F0E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_6F40	proc	near
		mov	al,6
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		mov	ah,30h
		int	10h			; Video display   ah=functn 30h
						;  locate 3270 PC Config table
		mov	ax,cx
		or	ax,dx
		jz	loc_a_6F6D		; Jump if zero
		push	ds
		mov	ds,cx
		mov	bx,dx
		mov	al,[bx+2]
		pop	ds
		or	al,al			; Zero ?
		jz	loc_a_6F61		; Jump if zero
		cmp	al,2
		jne	loc_a_6F6D		; Jump if not equal
loc_a_6F61:
		mov	dx,188h
		in	al,dx			; port 188h ??i/o non-standard
		test	al,4
		jz	loc_a_6F6D		; Jump if zero
		mov	ax,1
		retn
loc_a_6F6D:
		xor	ax,ax			; Zero register
		retn
sub_a_6F40	endp

		db	 20h, 00h, 0Eh, 17h
		db	28 dup (0)
		db	 1Eh, 0Eh, 1Fh, 56h,0FFh, 94h
		db	 0Fh, 00h, 5Eh, 1Fh, 2Eh,0FFh
		db	 2Eh, 49h, 00h,0D2h, 01h, 22h
		db	 02h, 79h, 00h, 79h, 00h,0DCh
		db	 00h,0ECh, 00h, 26h, 01h, 7Ah
		db	 00h, 1Dh, 01h, 40h, 01h, 49h
		db	 01h, 79h, 00h, 79h, 00h, 79h
		db	 00h, 79h, 00h, 73h, 02h, 82h
		db	 02h,0B2h, 02h, 56h, 01h,0B4h
		db	 01h,0BAh, 01h,0C8h, 01h, 08h
		db	 01h, 1Dh, 01h, 08h, 01h, 79h
		db	 00h, 14h, 01h, 14h, 01h, 7Fh
		db	 00h
		db	17 dup (0)
		db	 10h, 27h
		db	10 dup (0)
		db	 08h, 00h, 08h, 01h, 00h, 00h
		db	 00h, 00h, 64h, 00h, 64h, 00h
		db	 00h, 01h, 00h
loc_a_7005:
		pop	si
		pop	si
		pop	ds
		retf
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		call	sub_a_73C5
		jmp	short loc_a_7005
		db	 50h,0C7h, 06h, 5Dh, 00h, 00h
		db	 00h,0C7h, 06h, 5Fh, 00h, 00h
		db	 00h, 80h,0E4h, 7Fh, 3Bh,0C1h
		db	 72h, 01h, 91h, 3Bh,0DAh, 72h
		db	 02h, 87h,0DAh
loc_a_702A:
		and	ax,ax
		js	loc_a_704F		; Jump if sign=1
		and	bx,bx
		js	loc_a_704F		; Jump if sign=1
		cmp	cx,1
		jl	loc_a_704F		; Jump if <
		cmp	dx,1
		jl	loc_a_704F		; Jump if <
		mov	word ptr data_b_005D,ax
		mov	word ptr data_b_005F,bx
		call	sub_a_705C
		pop	ax
		and	ah,ah
		jns	loc_ret_a_704E		; Jump if not sign
		call	sub_a_7050

loc_ret_a_704E:
		retn
loc_a_704F:
		pop	ax

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7050	proc	near
		xor	ax,ax			; Zero register
		mov	bx,ax
		mov	cx,word ptr data_b_0056
		mov	dx,word ptr data_b_0058

;==== External Entry into Subroutine ======================================

sub_a_705C:
		mov	word ptr data_b_0061,ax
		mov	word ptr data_b_0063,bx
		mov	word ptr data_b_0065,cx
		mov	word ptr data_b_0067,dx
		retn
sub_a_7050	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_706C	proc	near
		add	ax,word ptr data_b_005D
		add	bx,word ptr data_b_005F
		mov	data_b_02BA,ax
		mov	data_b_02BC,bx
		retn
sub_a_706C	endp

			                        ;* No entry point to code
		mov	cx,data_b_02BA
		mov	dx,data_b_02BC
		call	sub_a_706C
		call	sub_a_7EEC
		jnc	loc_a_70A1		; Jump if carry=0
		push	cx
		push	dx
		mov	si,8
		call	dword ptr data_b_0049
		pop	bx
		pop	ax
		retn
			                        ;* No entry point to code
		call	sub_a_70AD
		call	sub_a_80DE
		jnc	loc_a_70A1		; Jump if carry=0
		retn
loc_a_70A1:
		jmp	loc_a_7005
			                        ;* No entry point to code
		add	cx,word ptr data_b_005D
		add	dx,word ptr data_b_005F
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_70AD	proc	near
		add	ax,word ptr data_b_005D
		add	bx,word ptr data_b_005F
		retn
sub_a_70AD	endp

			                        ;* No entry point to code
		call	sub_a_70BF
		call	sub_a_735D
		jmp	loc_a_7005

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_70BF	proc	near
		add	ax,word ptr data_b_005D
		add	bx,word ptr data_b_005F
		add	cx,word ptr data_b_005D
		add	dx,word ptr data_b_005F

loc_ret_a_70CF:
		retn
sub_a_70BF	endp

			                        ;* No entry point to code
		call	sub_a_70BF
		call	sub_a_8092
		jnc	loc_a_70A1		; Jump if carry=0
		retn
			                        ;* No entry point to code
		cmp	ax,0FFFFh
		jne	loc_ret_a_70CF		; Jump if not equal
		push	cs
		pop	es
		mov	bx,2BEh
		jmp	loc_a_7005
			                        ;* No entry point to code
		and	ah,ah
		jns	loc_a_70F0		; Jump if not sign
		and	ah,7Fh
		jmp	loc_a_82A9
loc_a_70F0:
		mov	ds:data_b_116A_e,ax
		mov	ds:data_b_116E_e,bx
		mov	ds:data_b_1170_e,cx
		mov	word ptr ds:data_b_1172_e,8
		mov	byte ptr data_b_0072,0
		mov	word ptr ds:data_b_1174_e,0
		mov	word ptr ds:data_b_1311_e+2,0
		and	al,al
		jz	loc_a_712F		; Jump if zero
		call	sub_a_7135
		cmp	word ptr ds:data_b_1311_e+2,0
		je	loc_a_712F		; Jump if equal
		mov	byte ptr data_b_0072,0FFh
		mov	word ptr ds:data_b_1174_e,0FFFFh
		mov	ds:data_b_1172_e,bx
loc_a_712F:
		call	sub_a_814D
		jmp	loc_a_7005

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7135	proc	near
		mov	es,dx
		xor	si,si			; Zero register
		cmp	byte ptr es:[si],2Bh	; '+'
		jne	loc_ret_a_7143		; Jump if not equal
		mov	word ptr ds:data_b_1311_e+2,dx

loc_ret_a_7143:
		retn
sub_a_7135	endp

			                        ;* No entry point to code
		call	sub_a_8107
		jmp	loc_a_7005
			                        ;* No entry point to code
		cmp	byte ptr data_b_0072,0
		je	loc_ret_a_7157		; Jump if equal
		call	sub_a_8355
		jmp	loc_a_7005

loc_ret_a_7157:
		retn
			                        ;* No entry point to code
		mov	ds:data_b_116C_e,ah
		mov	byte ptr ds:data_b_116C_e+1,al
		jmp	loc_a_7005
		db	 22h,0C0h, 74h, 01h,0C3h
loc_a_7167:
		mov	word ptr data_b_0049,bx
		mov	word ptr data_b_0049+2,es
		call	dword ptr data_b_0049
		mov	word ptr data_b_004D,bx
		mov	word ptr data_b_004F,es
		push	es
		push	bx
		les	di,dword ptr data_b_0049	; Load seg:offset ptr
		add	di,10h
		mov	al,9Ah
		cld				; Clear direction
		stosb				; Store al to es:[di]
		mov	ax,2FCh
		stosw				; Store ax to es:[di]
		mov	ax,cs
		stosw				; Store ax to es:[di]
		les	si,dword ptr cs:[4Dh]	; Load seg:offset ptr
		add	si,2
		mov	ax,es:[si]
		mov	word ptr data_b_0056,ax
		les	si,dword ptr cs:[4Dh]	; Load seg:offset ptr
		add	si,4
		mov	ax,es:[si]
		mov	word ptr data_b_0058,ax
		pop	bx
		pop	es
		jmp	loc_a_7005
		db	 00h, 00h, 50h, 53h, 51h, 52h
		db	 06h, 26h, 8Bh, 47h, 0Ch, 40h
		db	 40h,0A3h, 2Bh, 04h, 26h, 8Bh
		db	 47h, 0Eh,0A3h, 2Dh, 04h, 26h
		db	 8Bh, 47h, 10h,0A3h, 20h, 02h
		db	 33h,0D2h,0B9h, 06h, 00h,0F7h
		db	0F1h,0A3h, 27h, 04h, 26h,0C4h
		db	 5Fh, 12h, 89h, 1Eh, 51h, 00h
		db	 8Ch, 06h, 53h, 00h, 07h, 5Ah
		db	 59h, 5Bh, 58h,0FFh, 1Eh, 49h
		db	 00h,0C6h, 06h, 72h, 00h, 00h
		db	0E8h, 25h, 0Fh,0E9h, 0Dh,0FEh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_71F8	proc	near
loc_a_71F8:
		mov	word ptr data_b_0073,ax
		mov	si,1Eh
		call	dword ptr data_b_0049
		retn
sub_a_71F8	endp

			                        ;* No entry point to code
		mov	word ptr data_b_0073,ax
		retn
			                        ;* No entry point to code
		mov	word ptr data_b_0069,ax
		mov	si,20h
		call	dword ptr data_b_0049
		retn
			                        ;* No entry point to code
		cmp	al,0FFh
		jne	loc_a_721D		; Jump if not equal
		mov	word ptr data_b_0069,0C0Ch
		retn
loc_a_721D:
		mov	word ptr data_b_0069,ax
		retn
		db	 00h, 01h, 00h, 32h,0C0h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7226	proc	near
		mov	cx,1
		jmp	short loc_a_7230
		db	 32h,0C0h,0B9h, 03h, 00h
loc_a_7230:
		mov	byte ptr ds:[291h],al
		mov	byte ptr ds:[292h],cl
		mov	cx,1
		mov	si,22h
		call	dword ptr ds:[49h]
		retn
sub_a_7226	endp

			                        ;* No entry point to code
		mov	byte ptr data_b_0291,al
		mov	byte ptr data_b_0291+1,cl
		retn
		db	28 dup (0)
		db	 10h, 00h, 0Ch, 06h, 12h, 00h
		db	0C7h, 03h, 20h, 00h, 8Eh, 03h
		db	 26h, 00h, 0Ch, 16h, 24h, 00h
		db	 29h, 13h, 28h, 00h,0C5h, 13h
		db	 16h, 00h, 33h, 07h, 0Eh, 00h
		db	 80h, 09h, 14h, 00h, 15h, 07h
		db	 00h, 00h, 1Eh, 0Eh, 1Fh, 50h
		db	 8Bh,0FEh,0BEh,0D6h, 02h
loc_a_7295:
		lodsw				; String [si] to ax
		and	ax,ax
		jz	loc_a_72A6		; Jump if zero
		cmp	ax,di
		lodsw				; String [si] to ax
		jnz	loc_a_7295		; Jump if not zero
		mov	di,ax
		pop	ax
		call	di			;*
		pop	ds
		retf				; Return far
loc_a_72A6:
		pop	ax
		pop	ds
		retf				; Return far

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_72A9	proc	near
		mov	ax,data_b_02BA
		mov	bx,data_b_02BC
		jmp	short loc_a_72BC
			                        ;* No entry point to code
		mov	word ptr cs:[2BAh],ax
		mov	word ptr cs:[2BCh],bx
		retf				; Return far

;==== External Entry into Subroutine ======================================

sub_a_72BC:
loc_a_72BC:
		call	sub_a_7517
		jc	loc_ret_a_72CF		; Jump if carry Set
		mov	data_b_02BA,ax
		mov	data_b_02BC,bx
		mov	si,8
		call	dword ptr data_b_0049

loc_ret_a_72CF:
		retn
sub_a_72A9	endp

			                        ;* No entry point to code
		add	ax,data_b_02BA
		add	bx,data_b_02BC
		mov	data_b_02BA,ax
		mov	data_b_02BC,bx
		jmp	short loc_a_72BC
			                        ;* No entry point to code
		add	ax,data_b_02BA
		add	bx,data_b_02BC
		push	ax
		push	bx
		call	sub_a_72F8
		pop	bx
		pop	ax
		mov	word ptr ds:[2BAh],ax
		mov	word ptr ds:[2BCh],bx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_72F8	proc	near
loc_a_72F8:
		call	sub_a_7517
		jc	loc_ret_a_7310		; Jump if carry Set
		push	cx
		push	dx
		mov	cx,ax
		mov	dx,bx
		xchg	word ptr ds:[2BAh],ax
		xchg	word ptr ds:[2BCh],bx
		call	sub_a_735D
		pop	dx
		pop	cx

loc_ret_a_7310:
		retn
sub_a_72F8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7311	proc	near
loc_a_7311:
		call	sub_a_8092
		jnc	loc_ret_a_731D		; Jump if carry=0
		mov	si,12h
		call	dword ptr ds:[49h]

loc_ret_a_731D:
		retn
sub_a_7311	endp

			                        ;* No entry point to code
		mov	word ptr ds:[69h],ax
		mov	byte ptr ds:[97Fh],0FFh
		retn
		db	48 dup (0)
		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7358	proc	near
		call	sub_a_7517
		jc	loc_ret_a_7370		; Jump if carry Set

;==== External Entry into Subroutine ======================================

sub_a_735D:
		cmp	byte ptr data_b_0291+1,3
		jae	loc_a_7371		; Jump if above or =

;==== External Entry into Subroutine ======================================

sub_a_7364:
		call	sub_a_7EEC
		jnc	loc_ret_a_7370		; Jump if carry=0
		mov	si,0Ch
		call	dword ptr data_b_0049

loc_ret_a_7370:
		retn
loc_a_7371:
		call	sub_a_73A8
		mov	di,ax
		sub	di,cx
		jns	loc_a_737C		; Jump if not sign
		neg	di
loc_a_737C:
		mov	si,bx
		sub	si,dx
		jns	loc_a_7384		; Jump if not sign
		neg	si
loc_a_7384:
		cmp	di,si
		mov	di,data_b_097D
		jnc	loc_a_739B		; Jump if carry=0
		sub	ax,di
		sub	cx,di
		call	sub_a_73A8
		shl	di,1			; Shift w/zeros fill
		add	ax,di
		add	cx,di
		jmp	short loc_a_73A8
loc_a_739B:
		sub	bx,di
		sub	dx,di
		call	sub_a_73A8
		shl	di,1			; Shift w/zeros fill
		add	bx,di
		add	dx,di

;==== External Entry into Subroutine ======================================

sub_a_73A8:
loc_a_73A8:
		push	ax
		push	bx
		push	cx
		push	dx
		push	di
		call	sub_a_7364
		pop	di
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_7358	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_73C5	proc	near
		cmp	al,8
		jb	loc_a_73CB		; Jump if below
		mov	al,5
loc_a_73CB:
		xor	ah,ah			; Zero register
		shl	al,1			; Shift w/zeros fill
		mov	di,ax
		jmp	word ptr data_b_0445[di]	;*
sub_a_73C5	endp

			                        ;* No entry point to code
		push	bp
		add	al,0BEh
		add	al,0FCh
		add	al,0C3h
		add	al,67h			; 'g'
		add	al,0E8h
		add	al,6Dh			; 'm'
		add	al,71h			; 'q'
		add	al,0C6h
		push	es
		db	 26h, 04h, 01h,0C7h, 06h, 29h
		db	 04h, 00h, 00h,0C7h, 06h, 2Fh
		db	 04h, 00h, 00h,0C3h,0C6h, 06h
		db	 26h, 04h, 02h,0C3h, 32h,0C0h
		db	0EBh, 02h,0B0h,0FFh,0E3h, 48h
		db	 50h, 06h, 53h, 51h, 33h,0C0h
		db	0E8h,0B7h,0FFh, 59h, 5Fh, 07h
loc_a_7411:
		call	sub_a_7506
		add	ax,word ptr data_b_005D
		add	bx,word ptr data_b_005F
		call	sub_a_74FC
		and	cx,cx
		jnz	loc_a_7411		; Jump if not zero
		pop	ax
		and	al,al
		mov	ax,1
		jz	loc_a_744A		; Jump if zero
		les	bx,dword ptr data_b_042B	; Load seg:offset ptr
		mov	ax,es:[bx]
		mov	bx,es:[bx+2]
		mov	data_b_042F,0
		call	sub_a_72BC
		mov	ax,3
		cmp	byte ptr data_b_0073,0
		je	loc_a_744A		; Jump if equal
		dec	ax
loc_a_744A:
		call	sub_a_73C5

loc_ret_a_744D:
		retn
		db	0E8h, 2Dh, 00h,0EBh, 58h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7453	proc	near
		call	sub_a_747E
loc_a_7456:
		mov	ax,word ptr ds:[429h]
		cmp	ax,word ptr ds:[427h]
		jae	loc_a_7478		; Jump if above or =
		cmp	ax,4
		jb	loc_a_7478		; Jump if below
		les	bx,dword ptr ds:[42Bh]	; Load seg:offset ptr
		mov	cx,word ptr ds:[427h]
		mov	byte ptr ds:[426h],0
		mov	si,0Eh
		call	dword ptr ds:[49h]
loc_a_7478:
		mov	byte ptr ds:[426h],0
		retn
sub_a_7453	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_747E	proc	near
		mov	ax,8000h
		mov	bx,ax
		call	sub_a_72BC
		mov	byte ptr ds:[426h],0
		retn
sub_a_747E	endp

			                        ;* No entry point to code
		cmp	word ptr data_b_0070,0B4h
		jb	loc_a_7499		; Jump if below
		mov	byte ptr data_b_097F,0FFh
loc_a_7499:
		cmp	byte ptr data_b_097F,0
		je	loc_a_74A8		; Jump if equal
		call	sub_a_747E
		call	sub_a_74AB
		jmp	short loc_a_7456
loc_a_74A8:
		call	sub_a_7453

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_74AB	proc	near
		mov	byte ptr data_b_0426,0
		les	di,dword ptr data_b_042B	; Load seg:offset ptr
		mov	cx,data_b_0429
		cmp	cx,data_b_0427
		jae	loc_a_7478		; Jump if above or =
		cmp	cx,2
		jb	loc_a_7478		; Jump if below
		push	data_b_02BA
		push	data_b_02BC
		call	sub_a_74F9
loc_a_74CE:
		call	sub_a_7506
		cmp	bh,80h
		jne	loc_a_74E3		; Jump if not equal
		and	bl,bl
		jz	loc_a_74F0		; Jump if zero
		call	sub_a_74F9
		and	cx,cx
		jnz	loc_a_74CE		; Jump if not zero
		jmp	short loc_a_74F0
loc_a_74E3:
		push	es
		push	di
		push	cx
		call	sub_a_72F8
		pop	cx
		pop	di
		pop	es
		and	cx,cx
		jnz	loc_a_74CE		; Jump if not zero
loc_a_74F0:
		pop	word ptr ds:[2BCh]
		pop	word ptr ds:[2BAh]
		retn
sub_a_74AB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_74F9	proc	near
		call	sub_a_7506

;==== External Entry into Subroutine ======================================

sub_a_74FC:
		push	es
		push	di
		push	cx
		call	sub_a_72BC
		pop	cx
		pop	di
		pop	es
		retn
sub_a_74F9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7506	proc	near
		mov	bx,8000h
		jcxz	loc_ret_a_7516		; Jump if cx=0
		mov	ax,es:[di]
		inc	di
		inc	di
		mov	bx,es:[di]
		inc	di
		inc	di
		dec	cx

loc_ret_a_7516:
		retn
sub_a_7506	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7517	proc	near
		cmp	byte ptr data_b_0426,0
		je	loc_ret_a_758C		; Jump if equal
		cmp	byte ptr data_b_0426,2
		je	loc_a_7535		; Jump if equal
		cmp	data_b_042F,0
		jne	loc_a_7546		; Jump if not equal
		mov	data_b_0431,ax
		mov	data_b_0433,bx
		jmp	short loc_a_756B
loc_a_7535:
		mov	dl,byte ptr data_b_0073
		call	sub_a_80DE
		jnc	loc_ret_a_7545		; Jump if carry=0
		mov	si,30h
		call	dword ptr data_b_0049

loc_ret_a_7545:
		retn
loc_a_7546:
		cmp	ax,data_b_0431
		jne	loc_a_756B		; Jump if not equal
		cmp	bx,data_b_0433
		jne	loc_a_756B		; Jump if not equal
		cmp	data_b_042F,1
		je	loc_a_758B		; Jump if equal
		call	sub_a_756B
		mov	ax,8001h
		mov	bx,ax
		call	sub_a_756B
		mov	data_b_042F,0
		retn

;==== External Entry into Subroutine ======================================

sub_a_756B:
loc_a_756B:
		inc	data_b_042F
		mov	di,data_b_0429
		cmp	di,data_b_0427
		jae	loc_a_758D		; Jump if above or =
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		les	si,dword ptr data_b_042B	; Load seg:offset ptr
		add	di,si
		stosw				; Store ax to es:[di]
		mov	es:[di],bx
		inc	data_b_0429
loc_a_758B:
		stc				; Set carry flag

loc_ret_a_758C:
		retn
loc_a_758D:
		push	es
		push	bx
		les	bx,dword ptr data_b_0051	; Load seg:offset ptr
		mov	word ptr es:[bx],0FFFAh
		pop	bx
		pop	es
		stc				; Set carry flag
		retn
sub_a_7517	endp

			                        ;* No entry point to code
		push	cx
		push	dx
		mov	data_b_02CE,ax
		mov	data_b_02D0,bx
		mov	cx,data_b_02BA
		mov	dx,data_b_02BC
		mov	data_b_02CA,cx
		mov	data_b_02CC,dx
		call	sub_a_7689
		mov	ax,word ptr ds:[73h]
		jc	loc_a_75C6		; Jump if carry Set
		xchg	ah,al
		mov	si,1Eh
		call	dword ptr ds:[49h]
loc_a_75C6:
		mov	bx,word ptr ds:[2D0h]
		push	bx
		mov	ax,word ptr ds:[2CAh]
		call	sub_a_72F8
		mov	ax,word ptr ds:[2CEh]
		pop	bx
		push	ax
		call	sub_a_72F8
		pop	ax
		mov	bx,word ptr ds:[2CCh]
		push	bx
		call	sub_a_72F8
		pop	bx
		mov	ax,word ptr ds:[2CAh]
		call	sub_a_72F8
		mov	ax,word ptr ds:[2CEh]
		mov	bx,word ptr ds:[2CCh]
		push	ax
		call	sub_a_72BC
		pop	ax
		pop	dx
		pop	cx
		or	cx,cx			; Zero ?
		jz	loc_a_763A		; Jump if zero
		push	dx
		mov	dx,cx
		mov	di,dx
		shl	dx,1			; Shift w/zeros fill
		add	dx,di
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		cmp	byte ptr ds:[6Bh],0
		je	loc_a_761E		; Jump if equal
		mov	cx,dx
		neg	cx
		pop	di
		and	di,di
		jnz	loc_a_761D		; Jump if not zero
		call	sub_a_766A
		jmp	short loc_a_763A
loc_a_761D:
		push	di
loc_a_761E:
		add	ax,cx
		sub	bx,dx
		push	ax
		call	sub_a_72F8
		pop	ax
		mov	bx,word ptr ds:[2D0h]
		sub	bx,dx
		push	bx
		call	sub_a_72F8
		pop	bx
		pop	di
		and	di,di
		jz	loc_a_763A		; Jump if zero
		call	sub_a_7645
loc_a_763A:
		mov	ax,word ptr ds:[73h]
		mov	si,1Eh
		call	dword ptr ds:[49h]
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7645	proc	near
		mov	ax,word ptr ds:[2CAh]
		add	ax,cx
		call	sub_a_72F8
		mov	ax,word ptr ds:[2CAh]
		mov	bx,word ptr ds:[2D0h]
		push	bx
		call	sub_a_72F8
		pop	bx
		mov	ax,word ptr ds:[2CEh]
		push	ax
		push	bx
		call	sub_a_72BC
		pop	bx
		pop	ax
		add	ax,cx
		sub	bx,dx
		jmp	loc_a_72F8
sub_a_7645	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_766A	proc	near
		mov	ax,word ptr ds:[2CAh]
		mov	bx,word ptr ds:[2D0h]
		push	bx
		push	ax
		call	sub_a_72BC
		pop	ax
		pop	bx
		sub	bx,dx
		add	ax,cx
		push	bx
		call	sub_a_72F8
		mov	ax,word ptr ds:[2CEh]
		add	ax,cx
		pop	bx
		jmp	loc_a_72F8
sub_a_766A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7689	proc	near
		cmp	ax,cx
		jl	loc_a_768E		; Jump if <
		xchg	cx,ax
loc_a_768E:
		cmp	bx,dx
		jge	loc_a_7694		; Jump if > or =
		xchg	bx,dx
loc_a_7694:
		inc	ax
		dec	cx
		dec	bx
		inc	dx
		call	sub_a_7311
		stc				; Set carry flag
		retn
sub_a_7689	endp

			                        ;* No entry point to code
		clc				; Clear carry flag
		retn
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	0C6h, 06h, 14h, 07h, 00h,0E8h
		db	0D1h, 00h, 80h, 3Eh, 92h, 02h
		db	 03h, 73h, 14h,0BEh, 04h, 00h
		db	0E8h,0DBh, 00h,0E8h, 24h, 02h
		db	0B8h, 05h, 00h,0E9h, 02h,0FDh
		db	0C6h, 06h, 14h, 07h,0FFh, 80h
		db	 3Eh, 6Bh, 00h, 00h, 74h, 02h
		db	 87h,0CAh
loc_a_76D1:
		call	sub_a_777E
		xor	dx,dx			; Zero register
		mov	data_b_0713,dl
		mov	data_b_070F,dx
		mov	data_b_0711,dx
		mov	data_b_02CE,dx
		mov	data_b_02D0,dx
		mov	data_b_02D2,dx
		mov	data_b_02D4,dx
		call	sub_a_78C2
loc_a_76F5:
		push	ax
		push	bx
		xor	dx,dx			; Zero register
		mov	cx,5Ah
		div	cx			; ax,dx rem=dx:ax/reg
		mov	di,ax
		mov	ax,bx
		xor	dx,dx			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		cmp	ax,4
		jb	loc_a_770E		; Jump if below
		mov	ax,3
loc_a_770E:
		mov	si,ax
		pop	bx
		pop	ax
		cmp	si,di
		je	loc_a_7734		; Jump if equal
		push	bx
		push	ax
		mov	ax,5Ah
		inc	di
		mul	di			; dx:ax = reg * ax
		mov	bx,ax
		pop	ax
		push	bx
		xor	si,si			; Zero register
		cmp	ax,bx
		pushf				; Push flags
		call	sub_a_7795
		popf				; Pop flags
		jz	loc_a_7730		; Jump if zero
		call	sub_a_783B
loc_a_7730:
		pop	ax
		pop	bx
		jmp	short loc_a_76F5
loc_a_7734:
		xor	si,si			; Zero register
		cmp	ax,bx
		pushf				; Push flags
		call	sub_a_7795
		popf				; Pop flags
		jz	loc_a_7742		; Jump if zero
		call	sub_a_783B
loc_a_7742:
		mov	ax,data_b_02BA
		mov	bx,data_b_02BC
		mov	cx,data_b_070F
		mov	data_b_02CE,cx
		mov	dx,data_b_0711
		mov	data_b_02D0,dx
		cmp	byte ptr data_b_0714,0
		je	loc_a_777A		; Jump if equal
		add	cx,ax
		add	dx,bx
		push	ax
		push	bx
		call	sub_a_7358
		pop	bx
		pop	ax
		mov	cx,data_b_02D2
		mov	dx,data_b_02D4
		add	cx,ax
		add	dx,bx
		call	sub_a_7358
loc_a_777A:
		call	sub_a_78E1
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_777E	proc	near
		mov	data_b_02CA,cx
		mov	data_b_02CC,dx
		push	ax
		mov	ax,data_b_02BA
		mov	data_b_02BE,ax
		mov	ax,data_b_02BC
		mov	data_b_02C0,ax
		pop	ax
		retn
sub_a_777E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7795	proc	near
		mov	cx,data_b_02CA
		mov	dx,data_b_02CC
		cmp	byte ptr data_b_006B,0
		je	loc_a_77AA		; Jump if equal
		add	ax,5Ah
		add	bx,5Ah
loc_a_77AA:
		mov	di,bx
		sub	di,ax
		mov	word ptr data_b_006C,di
		and	di,di
		jnz	loc_a_77B9		; Jump if not zero
		jmp	loc_a_7875
loc_a_77B9:
		push	data_b_02BA
		push	data_b_02BC
		push	cx
		push	dx
		mov	di,0FFFFh
		push	di
		push	di
		push	si
		push	bx
		push	bx
		push	ax
		push	ax
		call	sub_a_788E
		mov	data_b_02CE,ax
		pop	ax
		call	sub_a_789B
		mov	data_b_02D0,ax
		pop	ax
		call	sub_a_788E
		mov	data_b_02D2,ax
		pop	ax
		call	sub_a_789B
		mov	data_b_02D4,ax
		pop	si
		pop	si
		push	data_b_02CE
		push	data_b_02D0
		push	data_b_02D2
		push	ax
		mov	ax,si
		call	sub_a_73C5
		mov	ax,data_b_02CE
		cmp	ax,data_b_02D2
		jne	loc_a_781B		; Jump if not equal
		mov	ax,data_b_02D0
		cmp	ax,data_b_02D4
		jne	loc_a_781B		; Jump if not equal
		cmp	word ptr data_b_006C,15Eh
		jae	loc_a_7837		; Jump if above or =
		add	sp,14h
		jmp	short loc_a_7825
loc_a_781B:
		cmp	word ptr data_b_006C,2
		jae	loc_a_7837		; Jump if above or =
		add	sp,14h
loc_a_7825:
		mov	ax,data_b_02D2
		mov	bx,data_b_02D4
		add	ax,data_b_02BA
		add	bx,data_b_02BC
		jmp	loc_a_72BC
loc_a_7837:
		call	sub_a_7B75
		retn

;==== External Entry into Subroutine ======================================

sub_a_783B:
		cmp	byte ptr data_b_0714,0
		jne	loc_a_784A		; Jump if not equal
		mov	ax,1
		call	sub_a_73C5
		jmp	short loc_a_7875
loc_a_784A:
		call	sub_a_72A9
		les	bx,dword ptr data_b_042B	; Load seg:offset ptr
		mov	ax,es:[bx]
		mov	bx,es:[bx+2]
		mov	data_b_042F,0
		call	sub_a_72BC
		mov	ax,3
		call	sub_a_73C5
		mov	ax,data_b_0429
		sub	ax,3
		jc	loc_a_7875		; Jump if carry Set
		mov	data_b_0429,ax
		call	sub_a_74AB
loc_a_7875:
		cmp	byte ptr ds:[713h],0
		jne	loc_ret_a_788D		; Jump if not equal
		mov	byte ptr ds:[713h],0FFh
		mov	ax,word ptr ds:[2CEh]
		mov	word ptr ds:[70Fh],ax
		mov	ax,word ptr ds:[2D0h]
		mov	word ptr ds:[711h],ax

loc_ret_a_788D:
		retn
sub_a_7795	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_788E	proc	near
		pop	di
;*		call	sub_a_7E75		;*
		db	0E8h,0E3h, 05h		;  Fixup - byte match
		mov	cx,data_b_02CA
		call	sub_a_78AA
		jmp	di			;*Register jump

;==== External Entry into Subroutine ======================================

sub_a_789B:
		pop	di
		call	sub_a_7E82
		mov	cx,data_b_02CC
		call	sub_a_78AA
		neg	ax
		jmp	di			;*Register jump

;==== External Entry into Subroutine ======================================

sub_a_78AA:
		mov	dx,ax
		mov	ax,bx
		mov	bx,cx
		call	sub_a_78B6
		mov	ax,dx
		retn
sub_a_788E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_78B6	proc	near
		mov	cx,ax
		mov	ax,dx
		mul	bx			; dx:ax = reg * ax
		xchg	cx,ax
		mul	bx			; dx:ax = reg * ax
		add	dx,cx
		retn
sub_a_78B6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_78C2	proc	near
		push	cx
		push	dx
		mov	cx,168h
		xor	dx,dx			; Zero register
		div	cx			; ax,dx rem=dx:ax/reg
		push	dx
		cmp	bx,cx
		je	loc_a_78D8		; Jump if equal
		xor	dx,dx			; Zero register
		mov	ax,bx
		div	cx			; ax,dx rem=dx:ax/reg
		mov	bx,dx
loc_a_78D8:
		pop	ax
		cmp	ax,bx
		jb	loc_a_78DE		; Jump if below
		xchg	bx,ax
loc_a_78DE:
		pop	dx
		pop	cx
		retn
sub_a_78C2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_78E1	proc	near
		push	cs
		pop	es
		cld				; Clear direction
		mov	si,offset data_b_02BE
		mov	di,si
		lodsw				; String [si] to ax
		sub	ax,word ptr data_b_005D
		stosw				; Store ax to es:[di]
		mov	bx,ax
		lodsw				; String [si] to ax
		sub	ax,word ptr data_b_005F
		stosw				; Store ax to es:[di]
		mov	cx,ax
		mov	si,offset data_b_02CE
		lodsw				; String [si] to ax
		add	ax,bx
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		add	ax,cx
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		add	ax,bx
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		add	ax,cx
		stosw				; Store ax to es:[di]
		retn
sub_a_78E1	endp

			                        ;* No entry point to code
		add	[bx+si],ax
		add	ds:data_b_703E_e[bx+di],al
		add	ds:data_b_7200_e[si],dh
		add	ax,6C6h
		jg	loc_a_7925		; Jump if >
		dec	word ptr ss:data_c_83EC_e[bp+di]
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		sbb	[di],bh
		add	ax,[bx+si]
loc_a_7925:
		jc	loc_a_794D		; Jump if carry Set
		mov	[bp-10h],cx
		mov	[bp-2],bx
		mov	[bp-8],ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		mov	[bp-4],bx
		push	word ptr data_b_0073
		call	sub_a_7B12
		jnc	loc_a_794D		; Jump if carry=0
		call	sub_a_7954
		call	sub_a_7B72
		jnc	loc_a_794D		; Jump if carry=0
		call	sub_a_7954
loc_a_794D:
		pop	ax
		add	sp,18h
		jmp	loc_a_71F8

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7954	proc	near
		push	es
		pop	ds
		call	sub_a_7A33
		mov	ax,[bp-0Ch]
		mov	[bp-0Ah],ax
		mov	word ptr [bp-12h],0
loc_a_7964:
		call	sub_a_7995
		call	sub_a_7A62
		mov	ax,[bp-14h]
		cmp	byte ptr [bp-18h],2
		jb	loc_a_7985		; Jump if below
		inc	word ptr [bp-12h]
		mov	bx,[bp-16h]
		cmp	bx,[bp-12h]
		jne	loc_a_7985		; Jump if not equal
		mov	word ptr [bp-12h],0
		imul	bx			; dx:ax = reg * ax
loc_a_7985:
		add	[bp-0Ah],ax
		mov	ax,[bp-0Ah]
		cmp	ax,[bp-0Eh]
		jl	loc_a_7964		; Jump if <
		push	ds
		pop	es
		push	cs
		pop	ds
		retn
sub_a_7954	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7995	proc	near
		mov	word ptr [bp-6],0
		mov	bx,[bp-2]
		inc	bx
		inc	bx
		mov	cx,[bx]
loc_a_79A1:
		mov	ax,[bp-0Ah]
loc_a_79A4:
		add	bx,4
		mov	di,cx
		mov	dx,[bx]
		mov	cx,dx
		cmp	dh,80h
		je	loc_a_79CC		; Jump if equal
		cmp	dx,di
		jl	loc_a_79B8		; Jump if <
		xchg	dx,di
loc_a_79B8:
		cmp	ax,dx
		jl	loc_a_79A4		; Jump if <
		cmp	ax,di
		jge	loc_a_79A4		; Jump if > or =
		push	bx
		push	cx
		call	sub_a_79DC
		call	sub_a_7A03
		pop	cx
		pop	bx
		jmp	short loc_a_79A1
loc_a_79CC:
		cmp	dl,1
		jne	loc_ret_a_79DB		; Jump if not equal
		add	bx,4
		mov	cx,[bx]
		cmp	ch,80h
		jne	loc_a_79A1		; Jump if not equal

loc_ret_a_79DB:
		retn
sub_a_7995	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_79DC	proc	near
		mov	si,[bx-6]
		mov	di,[bx-4]
		mov	cx,[bx-2]
		mov	dx,[bx]
		cmp	dx,di
		jl	loc_a_79EF		; Jump if <
		xchg	cx,si
		xchg	dx,di
loc_a_79EF:
		mov	ax,cx
		sub	di,dx
		jz	loc_ret_a_7A02		; Jump if zero
		mov	ax,[bp-0Ah]
		sub	ax,dx
		sub	si,cx
		imul	si			; dx:ax = reg * ax
		idiv	di			; ax,dx rem=dx:ax/reg
		add	ax,cx

loc_ret_a_7A02:
		retn
sub_a_79DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7A03	proc	near
		mov	dx,ax
		mov	si,[bp-4]
		mov	ax,[bp-6]
		cmp	ax,[bp-10h]
		jae	loc_ret_a_7A32		; Jump if above or =
		inc	word ptr [bp-6]
		and	ax,ax
		jz	loc_a_7A2C		; Jump if zero
loc_a_7A17:
		dec	ax
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	cx,[bx+si]
		inc	ax
		cmp	cx,dx
		jl	loc_a_7A2C		; Jump if <
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	[bx+si],cx
		dec	ax
		jnz	loc_a_7A17		; Jump if not zero
loc_a_7A2C:
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	[bx+si],dx

loc_ret_a_7A32:
		retn
sub_a_7A03	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7A33	proc	near
		mov	word ptr [bp-0Ch],7FFFh
		mov	word ptr [bp-0Eh],8000h
		mov	bx,[bp-2]
loc_a_7A40:
		inc	bx
		inc	bx
		mov	ax,[bx]
		inc	bx
		inc	bx
		cmp	ah,80h
		jne	loc_a_7A50		; Jump if not equal
		cmp	al,1
		je	loc_a_7A40		; Jump if equal
		retn
loc_a_7A50:
		cmp	ax,[bp-0Ch]
		jge	loc_a_7A58		; Jump if > or =
		mov	[bp-0Ch],ax
loc_a_7A58:
		cmp	ax,[bp-0Eh]
		jl	loc_a_7A40		; Jump if <
		mov	[bp-0Eh],ax
		jmp	short loc_a_7A40
sub_a_7A33	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7A62	proc	near
		mov	si,[bp-4]
		xor	ax,ax			; Zero register
		mov	cx,[bp-6]
		jcxz	loc_ret_a_7A92		; Jump if cx=0

locloop_a_7A6C:
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		push	ax
		push	si
		push	ds
		push	bp
		test	ax,1
		mov	ax,[bx+si]
		mov	bx,[bp-0Ah]
		push	cs
		pop	ds
		jnz	loc_a_7A85		; Jump if not zero
		call	sub_a_7A97
		jmp	short loc_a_7A88
loc_a_7A85:
		call	sub_a_7AA9
loc_a_7A88:
		pop	bp
		pop	ds
		pop	si
		pop	ax
		inc	ax
		cmp	ax,[bp-6]
		jb	locloop_a_7A6C		; Jump if below

loc_ret_a_7A92:
		retn
sub_a_7A62	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7A97	proc	near
		cmp	word ptr ds:[0BE0h],0
		je	loc_a_7AA1		; Jump if equal
		call	sub_a_7B72
loc_a_7AA1:
		mov	word ptr ds:[0B03h],ax
		mov	word ptr ds:[0B05h],bx
		retn
sub_a_7A97	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7AA9	proc	near
		cmp	word ptr ds:[0BE0h],0
		je	loc_a_7AB3		; Jump if equal
		call	sub_a_7B72
loc_a_7AB3:
		mov	cx,ax
		mov	dx,bx
		xchg	word ptr ds:[0B03h],cx
		xchg	word ptr ds:[0B05h],dx
		cmp	ax,cx
		jb	loc_a_7AC4		; Jump if below
		xchg	cx,ax
loc_a_7AC4:
		cmp	byte ptr ds:[97Fh],0
		jne	loc_a_7ACE		; Jump if not equal
		jmp	loc_a_7311
loc_a_7ACE:
		mov	si,0Ch
		call	dword ptr ds:[49h]
		retn
sub_a_7AA9	endp

		db	 00h, 00h, 01h, 00h, 00h, 02h
		db	 04h, 02h, 00h, 5Ah, 00h, 00h
		db	 0Ah,0E1h, 87h, 02h, 0Ah, 01h
		db	0E1h, 87h, 02h, 02h, 05h, 87h
		db	0E1h, 03h, 02h, 05h, 87h, 87h
		db	 01h, 5Ah, 0Ah, 00h, 00h, 01h
		db	 87h, 11h,0E1h,0E1h, 03h, 05h
		db	 01h, 00h, 00h, 03h, 0Ah, 01h
		db	 00h, 00h, 03h, 05h, 02h, 00h
		db	 00h, 00h, 00h, 01h, 00h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7B12	proc	near
		mov	word ptr ds:data_b_0BE0_e,0
		mov	al,byte ptr data_b_0069
		dec	al
		clc				; Clear carry flag
		js	loc_ret_a_7B6F		; Jump if sign=1
		cmp	byte ptr data_b_097F,0
		jne	loc_a_7B29		; Jump if not equal
		xor	al,al			; Zero register
loc_a_7B29:
		mov	bl,al
		shl	bl,1			; Shift w/zeros fill
		shl	bl,1			; Shift w/zeros fill
		add	bl,al
		xor	bh,bh			; Zero register
		add	bx,0B46h
		mov	si,bx
		lodsb				; String [si] to al
		mov	[bp-18h],al
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		mov	[bp-16h],ax
		lodsb				; String [si] to al
		imul	data_b_097D		; dx:ax = data * ax
		mov	[bp-14h],ax
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		cmp	byte ptr data_b_006B,0
		je	loc_a_7B5D		; Jump if equal
		cmp	byte ptr data_b_097F,0
		je	loc_a_7B5D		; Jump if equal
		lodsb				; String [si] to al
loc_a_7B5D:
		call	sub_a_7B72
		push	es
		mov	al,byte ptr data_b_0073+1
		mov	ah,al
		mov	si,1Eh
		call	dword ptr data_b_0049
		pop	es
		stc				; Set carry flag

loc_ret_a_7B6F:
		retn
sub_a_7B12	endp

		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7B72	proc	near
		xor	al,al			; Zero register
		retn
sub_a_7B72	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7B75	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch
PARAMETER_6	=	0Eh			; bp+0Eh
PARAMETER_7	=	10h			; bp+10h
PARAMETER_8	=	12h			; bp+12h
LOCAL_15	=	-1Eh			; bp+0FFE2h
LOCAL_14	=	-1Ch			; bp+0FFE4h
LOCAL_13	=	-1Ah			; bp+0FFE6h
LOCAL_12	=	-18h			; bp+0FFE8h
LOCAL_11	=	-16h			; bp+0FFEAh
LOCAL_10	=	-14h			; bp+0FFECh
LOCAL_9		=	-12h			; bp+0FFEEh
LOCAL_8		=	-10h			; bp+0FFF0h
LOCAL_7		=	-0Eh			; bp+0FFF2h
LOCAL_6		=	-0Ch			; bp+0FFF4h
LOCAL_5		=	-0Ah			; bp+0FFF6h
LOCAL_4		=	-8			; bp+0FFF8h
LOCAL_3		=	-6			; bp+0FFFAh
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,2Ah
		mov	ax,[bp+PARAMETER_4]
		mov	bx,[bp+PARAMETER_3]
		call	sub_a_7D70
		mov	[bp-26h],ax
		mov	ax,[bp+PARAMETER_2]
		mov	bx,[bp+PARAMETER_1]
		call	sub_a_7D70
		mov	byte ptr [bp-2Ah],0
		cmp	ax,[bp-26h]
		jg	loc_a_7B9D		; Jump if >
		mov	byte ptr [bp-2Ah],0FFh
loc_a_7B9D:
		mov	[bp-28h],ax
		test	word ptr [bp+PARAMETER_8],0FFFFh
		jnz	loc_a_7BAA		; Jump if not zero
		inc	word ptr [bp+PARAMETER_8]
loc_a_7BAA:
		test	word ptr [bp+PARAMETER_7],0FFFFh
		jnz	loc_a_7BB4		; Jump if not zero
		inc	word ptr [bp+PARAMETER_7]
loc_a_7BB4:
		mov	ax,[bp+PARAMETER_7]
		mov	bx,[bp+PARAMETER_8]
		cmp	ax,bx
		ja	loc_a_7BC0		; Jump if above
		mov	ax,bx
loc_a_7BC0:
		mul	ax			; dx:ax = reg * ax
		mov	bx,64h
		call	sub_a_7DA9
		jnc	loc_a_7BCD		; Jump if carry=0
		jmp	loc_a_7C9E
loc_a_7BCD:
		mov	[bp-24h],ax
		mov	[bp-22h],dx
		mov	bx,[bp+PARAMETER_8]
		call	sub_a_7D97
		call	sub_a_7D97
		mov	[bp+LOCAL_4],ax
		mov	[bp+LOCAL_3],dx
		xor	ax,ax			; Zero register
		mov	[bp+LOCAL_1],ax
		mov	[bp+LOCAL_10],ax
		mov	[bp+LOCAL_9],ax
		mov	ax,[bp-24h]
		mov	dx,[bp-22h]
		mov	bx,[bp+PARAMETER_7]
		mov	[bp+LOCAL_2],bx
		call	sub_a_7D97
		call	sub_a_7D97
		mov	[bp+LOCAL_6],ax
		mov	[bp+LOCAL_5],dx
		call	sub_a_7DA9
		jnc	loc_a_7C0D		; Jump if carry=0
		jmp	loc_a_7C9E
loc_a_7C0D:
		mov	si,dx
		mov	di,ax
		call	sub_a_7DA9
		jnc	loc_a_7C19		; Jump if carry=0
		jmp	loc_a_7C9E
loc_a_7C19:
		sub	ax,[bp-24h]
		sbb	dx,[bp-22h]
		mov	[bp+LOCAL_8],ax
		mov	[bp+LOCAL_7],dx
		shl	di,1			; Shift w/zeros fill
		rcl	si,1			; Rotate thru carry
		mov	[bp+LOCAL_12],di
		mov	[bp+LOCAL_11],si
loc_a_7C2F:
		call	sub_a_7D0D
		call	sub_a_7CA4
		mov	ax,[bp+LOCAL_8]
		mov	bx,[bp+LOCAL_7]
		add	ax,ax
		adc	bx,bx
		add	ax,[bp+LOCAL_14]
		adc	bx,[bp+LOCAL_13]
		add	ax,[bp+LOCAL_14]
		adc	bx,[bp+LOCAL_13]
		cmp	bx,[bp+LOCAL_15]
		jl	loc_a_7C5A		; Jump if <
		jnz	loc_a_7C57		; Jump if not zero
		cmp	ax,[bp-20h]
		jb	loc_a_7C5A		; Jump if below
loc_a_7C57:
		call	sub_a_7CEB
loc_a_7C5A:
		call	sub_a_7CC9
		mov	ax,[bp+LOCAL_9]
		cmp	ax,[bp+LOCAL_11]
		jl	loc_a_7C2F		; Jump if <
		jnz	loc_a_7C6F		; Jump if not zero
		mov	ax,[bp+LOCAL_10]
		cmp	ax,[bp+LOCAL_12]
		jb	loc_a_7C2F		; Jump if below
loc_a_7C6F:
		call	sub_a_7D0D
		call	sub_a_7CA4
		mov	ax,[bp+LOCAL_14]
		mov	bx,[bp+LOCAL_13]
		shr	bx,1			; Shift w/zeros fill
		rcr	ax,1			; Rotate thru carry
		add	ax,[bp+LOCAL_8]
		adc	bx,[bp+LOCAL_7]
		cmp	bx,[bp+LOCAL_15]
		jg	loc_a_7C94		; Jump if >
		jnz	loc_a_7C91		; Jump if not zero
		cmp	ax,[bp-20h]
		ja	loc_a_7C94		; Jump if above
loc_a_7C91:
		call	sub_a_7CC9
loc_a_7C94:
		call	sub_a_7CEB
		test	word ptr [bp+LOCAL_2],8000h
		jz	loc_a_7C6F		; Jump if zero
loc_a_7C9E:
		mov	sp,bp
		pop	bp
		retn	14h
sub_a_7B75	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7CA4	proc	near
		mov	ax,[bp-14h]
		add	ax,[bp-8]
		mov	[bp-1Ch],ax
		mov	ax,[bp-12h]
		adc	ax,[bp-6]
		mov	[bp-1Ah],ax
		mov	ax,[bp-18h]
		sub	ax,[bp-0Ch]
		mov	[bp-20h],ax
		mov	ax,[bp-16h]
		sbb	ax,[bp-0Ah]
		mov	[bp-1Eh],ax
		retn
sub_a_7CA4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7CC9	proc	near
		inc	word ptr [bp-2]
		mov	ax,[bp-1Ch]
		add	[bp-10h],ax
		mov	ax,[bp-1Ah]
		adc	[bp-0Eh],ax
		mov	ax,[bp-1Ch]
		add	ax,[bp-8]
		mov	[bp-14h],ax
		mov	ax,[bp-1Ah]
		adc	ax,[bp-6]
		mov	[bp-12h],ax
		retn
sub_a_7CC9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7CEB	proc	near
		dec	word ptr [bp-4]
		mov	ax,[bp-20h]
		sub	[bp-10h],ax
		mov	ax,[bp-1Eh]
		sbb	[bp-0Eh],ax
		mov	ax,[bp-20h]
		sub	ax,[bp-0Ch]
		mov	[bp-18h],ax
		mov	ax,[bp-1Eh]
		sbb	ax,[bp-0Ah]
		mov	[bp-16h],ax
		retn
sub_a_7CEB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7D0D	proc	near
		mov	dx,[bp+0Eh]
		mov	si,[bp-2]
		mov	di,[bp-4]
		test	word ptr [bp+0Ch],8000h
		jnz	loc_a_7D3C		; Jump if not zero
		call	sub_a_7D2E
		neg	si
		call	sub_a_7D2E
		neg	si
		neg	di
		call	sub_a_7D2E
		neg	si

;==== External Entry into Subroutine ======================================

sub_a_7D2E:
loc_a_7D2E:
		push	di
		push	si
		add	si,[bp+16h]
		add	di,[bp+14h]
		call	sub_a_7DB7
		pop	si
		pop	di
		retn
loc_a_7D3C:
		call	sub_a_7D4D
		neg	si
		call	sub_a_7D4D
		neg	si
		neg	di
		call	sub_a_7D4D
		neg	si
sub_a_7D0D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7D4D	proc	near
		mov	ax,si
		mov	bx,di
		call	sub_a_7D70
		cmp	byte ptr [bp-2Ah],0
		jne	loc_a_7D65		; Jump if not equal
		cmp	ax,[bp-26h]
		jl	loc_ret_a_7D64		; Jump if <
		cmp	ax,[bp-28h]
		jle	loc_a_7D2E		; Jump if < or =

loc_ret_a_7D64:
		retn
loc_a_7D65:
		cmp	ax,[bp-26h]
		jge	loc_a_7D2E		; Jump if > or =
		cmp	ax,[bp-28h]
		jle	loc_a_7D2E		; Jump if < or =
		retn
sub_a_7D4D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7D70	proc	near
		neg	bx
		or	ah,ah			; Zero ?
		js	loc_a_7D85		; Jump if sign=1
		or	bh,bh			; Zero ?
		js	loc_a_7D7F		; Jump if sign=1
		sub	bx,ax
		mov	ax,bx
		retn
loc_a_7D7F:
		add	ax,1770h
		add	ax,bx
		retn
loc_a_7D85:
		or	bh,bh			; Zero ?
		js	loc_a_7D91		; Jump if sign=1
		neg	ax
		add	ax,7D0h
		sub	ax,bx
		retn
loc_a_7D91:
		add	ax,0FA0h
		sub	ax,bx
		retn
sub_a_7D70	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7D97	proc	near
		or	bx,bx			; Zero ?
		stc				; Set carry flag
		jz	loc_ret_a_7DA8		; Jump if zero
		xor	cx,cx			; Zero register
		xchg	cx,dx
		xchg	cx,ax
		div	bx			; ax,dx rem=dx:ax/reg
		xchg	cx,ax
		div	bx			; ax,dx rem=dx:ax/reg
		xchg	cx,dx

loc_ret_a_7DA8:
		retn
sub_a_7D97	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7DA9	proc	near
		mov	cx,ax
		mov	ax,dx
		mul	bx			; dx:ax = reg * ax
		jc	loc_ret_a_7DB6		; Jump if carry Set
		xchg	cx,ax
		mul	bx			; dx:ax = reg * ax
		add	dx,cx

loc_ret_a_7DB6:
		retn
sub_a_7DA9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7DB7	proc	near
		mov	ax,si
		mov	bx,di
		jmp	loc_a_72BC
sub_a_7DB7	endp

		db	 00h, 00h, 00h, 3Bh, 02h, 77h
		db	 04h,0B2h, 06h,0EDh, 08h, 27h
		db	 0Bh, 61h, 0Dh, 99h, 0Fh,0D0h
		db	 11h, 06h, 14h, 3Ah, 16h, 6Ch
		db	 18h, 9Ch, 1Ah,0CBh, 1Ch,0F7h
		db	 1Eh, 20h, 21h, 48h, 23h, 6Ch
		db	 25h, 8Dh, 27h,0ACh, 29h,0C7h
		db	 2Bh,0DFh, 2Dh,0F3h
		db	2Fh
loc_a_7DED:
		add	si,[bp+si]
		db	 0Fh, 34h, 18h, 36h, 1Ch, 38h
loc_a_7DF5:
		sbb	al,3Ah			; ':'
		pop	ss
		cmp	al,0Eh
		db	 3Eh, 00h, 40h,0ECh, 41h,0D4h
		db	 43h,0B6h
		db	45h
loc_a_7E03:
		xchg	bx,ax
		inc	di
		push	49h
		cmp	al,4Bh			; 'K'
		or	[di-33h],cl
loc_a_7E0C:
		dec	si
		lea	dx,[bx+si+46h]		; Load effective addr
		push	dx
		stc				; Set carry flag
loc_a_7E12:
		push	bx
		cmpsb				; Cmp [si] to es:[di]
		push	bp
		dec	bx
		push	di
;*		jmp	far ptr l_135A_8258	;*
		db	0EAh
		dw	8258h, 135Ah		;  Fixup - byte match
loc_a_7E1C:
		pop	sp
		pushf				; Push flags
		pop	bp
		pop	ds
		pop	di
;*		call	far ptr s_7962_0D60	;*
		db	9Ah
		dw	0D60h, 7962h		;  Fixup - byte match
		db	 63h,0DDh, 64h, 39h, 66h, 8Dh
		db	 67h,0D9h, 68h, 1Dh, 6Ah, 59h
		db	 6Bh, 8Ch, 6Ch,0B7h, 6Dh,0D9h
		db	 6Eh,0F3h, 6Fh, 04h, 71h, 0Ch
		db	 72h, 0Bh
		db	73h
loc_a_7E41:
		add	[si-11h],si
;*		jz	loc_a_7E19		;*Jump if zero
		db	 74h,0D3h		;  Fixup - byte match
		jnz	loc_a_7DF5		; Jump if not zero
;*		jbe	loc_a_7EC9		;*Jump if below or =
		db	 76h, 7Fh		;  Fixup - byte match
;*		ja	loc_a_7E93		;*Jump if above
		db	 77h, 47h		;  Fixup - byte match
		js	loc_a_7E54		; Jump if sign=1
		jns	loc_a_7E0C		; Jump if not sign
;*		jns	loc_a_7EBA		;*Jump if not sign
		db	 79h, 68h		;  Fixup - byte match
		jp	loc_a_7E5E		; Jump if parity=1
loc_a_7E54:
;*		jnp	loc_a_7DF9		;*Jump if not parity
		db	 7Bh,0A3h		;  Fixup - byte match
;*		jnp	loc_a_7E8A		;*Jump if not parity
		db	 7Bh, 32h		;  Fixup - byte match
		jl	loc_a_7E12		; Jump if <
;*		jl	loc_a_7E8F		;*Jump if <
		db	 7Ch, 33h		;  Fixup - byte match
loc_a_7E5C:
		jge	loc_a_7E03		; Jump if > or =
loc_a_7E5E:
		jge	loc_a_7E6E		; Jump if > or =
;*		jle	loc_a_7ECE		;*Jump if < or =
		db	 7Eh, 6Ch		;  Fixup - byte match
;*		jle	loc_a_7E25		;*Jump if < or =
		db	 7Eh,0C1h		;  Fixup - byte match
;*		jle	loc_a_7E71		;*Jump if < or =
		db	 7Eh, 0Bh		;  Fixup - byte match
		jg	loc_a_7EB4		; Jump if >
		jg	loc_a_7DED		; Jump if >
		jg	loc_a_7E1C		; Jump if >
		jg	loc_a_7E41		; Jump if >
loc_a_7E6E:
		jg	loc_a_7E5C		; Jump if >
;*		jg	loc_a_7E6D		;*Jump if >
		db	 7Fh,0FBh		;  Fixup - byte match
		jg	$+2			; delay for I/O
		adc	byte ptr [di-7Dh],0ECh
		add	ss:d_0000_83EC_e[bp+di],cl
		inc	si
		add	al,5Ah			; 'Z'
		jmp	short loc_a_7E88
		db	90h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7E82	proc	near
		push	bp
		sub	sp,0
		mov	bp,sp
loc_a_7E88:
		mov	byte ptr ds:data_b_0E2E_e,0
		mov	ax,[bp+4]
		test	ax,ax
		jge	loc_a_7E9A		; Jump if > or =
		neg	ax
		not	byte ptr ds:data_b_0E2E_e
loc_a_7E9A:
		xor	dx,dx			; Zero register
		mov	cx,168h
		idiv	cx			; ax,dx rem=dx:ax/reg
		mov	ax,dx
		cmp	ax,0B4h
		jle	loc_a_7EAF		; Jump if < or =
		sub	ax,0B4h
		not	byte ptr ds:data_b_0E2E_e
loc_a_7EAF:
		cmp	ax,5Ah
		jle	loc_a_7EB9		; Jump if < or =
loc_a_7EB4:
		neg	ax
		add	ax,0B4h
loc_a_7EB9:
		shl	ax,1			; Shift w/zeros fill
		mov	si,ax
		mov	bx,ds:data_b_0E2F_e[si]
		mov	cx,bx
		xor	ax,ax			; Zero register
		clc				; Clear carry flag
		rcl	bx,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		cmp	byte ptr ds:data_b_0E2E_e,0
		je	loc_a_7EDB		; Jump if equal
		not	bx
		not	ax
		add	bx,1
		adc	ax,0
loc_a_7EDB:
		add	sp,0
		pop	bp
		retn
sub_a_7E82	endp

		db	12 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7EEC	proc	near
		mov	byte ptr data_b_005C,1
		call	sub_a_80DE
		jnc	loc_a_7F02		; Jump if carry=0
		xchg	cx,ax
		xchg	bx,dx
		call	sub_a_80DE
		xchg	cx,ax
		xchg	bx,dx
		jnc	loc_a_7F02		; Jump if carry=0
		retn
loc_a_7F02:
		mov	ds:data_b_0F54_e,ax
		mov	ds:data_b_0F56_e,bx
		mov	ds:data_b_0F58_e,cx
		mov	ds:data_b_0F5A_e,dx
		call	sub_a_7F37
		cmp	byte ptr data_b_005C,0
		je	loc_a_7F2C		; Jump if equal
		mov	ax,ds:data_b_0F54_e
		mov	bx,ds:data_b_0F56_e
		mov	cx,ds:data_b_0F58_e
		mov	dx,ds:data_b_0F5A_e
		stc				; Set carry flag
		retn
loc_a_7F2C:
		mov	ax,0FFFFh
		mov	bx,ax
		mov	cx,ax
		mov	dx,ax
		clc				; Clear carry flag
		retn
sub_a_7EEC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_7F37	proc	near
		mov	bx,data_b_0F54_e
		call	sub_a_802F
		mov	ch,al
		mov	bx,data_b_0F58_e
		call	sub_a_802F
		or	al,ch
		jnz	loc_a_7F4A		; Jump if not zero
		retn
loc_a_7F4A:
		mov	ax,ds:data_b_0F58_e
		sub	ax,ds:data_b_0F54_e
		mov	ds:data_b_0F50_e,ax
		jz	loc_a_7F60		; Jump if zero
		mov	ax,ds:data_b_0F5A_e
		sub	ax,ds:data_b_0F56_e
		mov	ds:data_b_0F52_e,ax
loc_a_7F60:
		mov	bx,data_b_0F54_e
		call	sub_a_802F
		mov	ch,al
		mov	bx,data_b_0F58_e
		call	sub_a_802F
		mov	dl,al
		or	al,ch
		jnz	loc_a_7F75		; Jump if not zero
		retn
loc_a_7F75:
		and	dl,ch
		jz	loc_a_7F7F		; Jump if zero
		mov	byte ptr data_b_005C,0
		retn
loc_a_7F7F:
		and	ch,ch
		jnz	loc_a_7F86		; Jump if not zero
		call	sub_a_805B
loc_a_7F86:
		mov	byte ptr data_b_005C,2
		cmp	word ptr ds:data_b_0F50_e,0
		jne	loc_a_7FB0		; Jump if not equal
		mov	ax,ds:data_b_0F56_e
		cmp	ax,word ptr data_b_0063
		jge	loc_a_7FA1		; Jump if > or =
		mov	ax,word ptr data_b_0063
		mov	ds:data_b_0F56_e,ax
loc_a_7FA1:
		mov	ax,word ptr data_b_0067
		cmp	ax,ds:data_b_0F56_e
		jge	loc_a_7FAD		; Jump if > or =
		mov	ds:data_b_0F56_e,ax
loc_a_7FAD:
		jmp	short loc_a_8025
		db	90h
loc_a_7FB0:
		cmp	word ptr ds:data_b_0F52_e,0
		jne	loc_a_7FD5		; Jump if not equal
		mov	ax,ds:data_b_0F54_e
		cmp	ax,word ptr data_b_0061
		jge	loc_a_7FC6		; Jump if > or =
		mov	ax,word ptr data_b_0061
		mov	ds:data_b_0F54_e,ax
loc_a_7FC6:
		mov	ax,word ptr data_b_0065
		cmp	ax,ds:data_b_0F54_e
		jge	loc_a_7FD2		; Jump if > or =
		mov	ds:data_b_0F54_e,ax
loc_a_7FD2:
		jmp	short loc_a_8025
		db	90h
loc_a_7FD5:
		mov	ax,ds:data_b_0F54_e
		cmp	ax,word ptr data_b_0061
		jge	loc_a_7FEB		; Jump if > or =
		mov	ax,word ptr data_b_0061
		push	ax
		call	sub_a_8081
		pop	word ptr ds:data_b_0F54_e
		jmp	short loc_a_8025
loc_a_7FEB:
		mov	ax,word ptr data_b_0065
		cmp	ax,ds:data_b_0F54_e
		jge	loc_a_7FFE		; Jump if > or =
		push	ax
		call	sub_a_8081
		pop	word ptr ds:data_b_0F54_e
		jmp	short loc_a_8025
loc_a_7FFE:
		mov	ax,ds:data_b_0F56_e
		cmp	ax,word ptr data_b_0063
		jge	loc_a_8014		; Jump if > or =
		mov	ax,word ptr data_b_0063
		push	ax
		call	sub_a_8070
		pop	word ptr ds:data_b_0F56_e
		jmp	short loc_a_8025
loc_a_8014:
		mov	ax,word ptr data_b_0067
		cmp	ax,ds:data_b_0F56_e
		jge	loc_a_8025		; Jump if > or =
		push	ax
		call	sub_a_8070
		pop	word ptr ds:data_b_0F56_e
loc_a_8025:
		and	ch,ch
		jnz	loc_a_802C		; Jump if not zero
		call	sub_a_805B
loc_a_802C:
		jmp	loc_a_7F60
sub_a_7F37	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_802F	proc	near
		xor	dl,dl			; Zero register
		mov	ax,[bx]
		cmp	ax,word ptr data_b_0061
		jge	loc_a_803B		; Jump if > or =
		mov	dl,1
loc_a_803B:
		cmp	ax,word ptr data_b_0065
		jle	loc_a_8043		; Jump if < or =
		mov	dl,2
loc_a_8043:
		mov	ax,[bx+2]
		cmp	ax,word ptr data_b_0063
		jge	loc_a_804F		; Jump if > or =
		add	dl,4
loc_a_804F:
		cmp	ax,word ptr data_b_0067
		jle	loc_a_8058		; Jump if < or =
		add	dl,8
loc_a_8058:
		mov	al,dl
		retn
sub_a_802F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_805B	proc	near
		mov	ax,ds:data_b_0F54_e
		xchg	ds:data_b_0F58_e,ax
		mov	ds:data_b_0F54_e,ax
		mov	ax,ds:data_b_0F56_e
		xchg	ds:data_b_0F5A_e,ax
		mov	ds:data_b_0F56_e,ax
		retn
sub_a_805B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8070	proc	near
		sub	ax,ds:data_b_0F56_e
		imul	word ptr ds:data_b_0F50_e	; dx:ax = data * ax
		idiv	word ptr ds:data_b_0F52_e	; ax,dxrem=dx:ax/data
		add	ds:data_b_0F54_e,ax
		retn
sub_a_8070	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8081	proc	near
		sub	ax,ds:data_b_0F54_e
		imul	word ptr ds:data_b_0F52_e	; dx:ax = data * ax
		idiv	word ptr ds:data_b_0F50_e	; ax,dxrem=dx:ax/data
		add	ds:data_b_0F56_e,ax
		retn
sub_a_8081	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8092	proc	near
		call	sub_a_80DE
		jc	loc_a_80AC		; Jump if carry Set
		xchg	bx,dx
		call	sub_a_80DE
		jc	loc_a_80AC		; Jump if carry Set
		xchg	cx,ax
		call	sub_a_80DE
		jc	loc_a_80AC		; Jump if carry Set
		xchg	bx,dx
		call	sub_a_80DE
		xchg	cx,ax
		jnc	loc_ret_a_80CF		; Jump if carry=0
loc_a_80AC:
		mov	di,word ptr data_b_0061
		mov	si,word ptr data_b_0065
		call	sub_a_80D0
		xchg	cx,ax
		call	sub_a_80D0
		xchg	cx,ax
		mov	di,word ptr data_b_0063
		mov	si,word ptr data_b_0067
		xchg	bx,ax
		call	sub_a_80D0
		xchg	bx,ax
		xchg	dx,ax
		call	sub_a_80D0
		xchg	dx,ax
		stc				; Set carry flag

loc_ret_a_80CF:
		retn
sub_a_8092	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_80D0	proc	near
		cmp	ax,di
		jge	loc_a_80D7		; Jump if > or =
		mov	ax,di
		retn
loc_a_80D7:
		cmp	ax,si
		jbe	loc_ret_a_80DD		; Jump if below or =
		mov	ax,si

loc_ret_a_80DD:
		retn
sub_a_80D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_80DE	proc	near
		cmp	ax,word ptr data_b_0065
		ja	loc_a_80F8		; Jump if above
		cmp	bx,word ptr data_b_0067
		ja	loc_a_80F8		; Jump if above
		cmp	ax,word ptr data_b_0061
		jl	loc_a_80F8		; Jump if <
		cmp	bx,word ptr data_b_0063
		jl	loc_a_80F8		; Jump if <
		stc				; Set carry flag
		retn
loc_a_80F8:
		clc				; Clear carry flag
		retn
sub_a_80DE	endp

		db	8 dup (0)
		db	8, 0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8107	proc	near
		xor	ch,ch			; Zero register
		jcxz	loc_ret_a_8119		; Jump if cx=0
		push	bx
		push	es
		mov	ds:data_b_1176_e,cl
		call	sub_a_81CA
		pop	es
		pop	bx
		call	sub_a_81FC

loc_ret_a_8119:
		retn
sub_a_8107	endp

			                        ;* No entry point to code
		cmp	byte ptr data_b_0072,0
		je	loc_a_8135		; Jump if equal
		xor	al,al			; Zero register
		xor	ah,ah			; Zero register
		and	al,al
		jnz	loc_a_812B		; Jump if not zero
		mov	al,4
loc_a_812B:
		cmp	byte ptr data_b_0072,0
		je	loc_a_8135		; Jump if equal
		mov	ds:data_b_1172_e,ax
loc_a_8135:
		mov	byte ptr ds:data_b_116C_e,0
		mov	byte ptr ds:data_b_116C_e+1,2
		xor	ax,ax			; Zero register
		mov	ds:data_b_116A_e,ax
		mov	ax,ds:data_b_1172_e
		mov	ds:data_b_116E_e,ax
		mov	ds:data_b_1170_e,ax

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_814D	proc	near
		mov	bx,ds:data_b_116E_e
		mov	cx,ds:data_b_1170_e
		cmp	byte ptr data_b_0072,0
		je	loc_a_815F		; Jump if equal
		call	sub_a_81B1
loc_a_815F:
		mov	ax,ds:data_b_116A_e
		mov	dx,ds:data_b_116C_e
		cmp	byte ptr data_b_0055,0
		jne	loc_a_8179		; Jump if not equal
		cmp	byte ptr data_b_0072,0
		je	loc_a_8179		; Jump if equal
		call	sub_a_82B9
		jmp	short loc_a_8189
loc_a_8179:
		or	bx,bx			; Zero ?
		jnz	loc_a_8182		; Jump if not zero
		mov	bx,8
		mov	cx,bx
loc_a_8182:
		mov	si,24h
		call	dword ptr data_b_0049
loc_a_8189:
		mov	ds:data_b_116E_e,bx
		mov	ds:data_b_1170_e,cx
		retn
sub_a_814D	endp

		db	 00h, 00h, 03h, 05h, 02h, 03h
		db	 03h, 04h, 01h, 01h, 04h, 03h
		db	 05h, 03h, 02h, 01h, 05h, 02h
		db	 03h, 01h, 04h, 01h,0E8h, 06h
		db	 00h,0A1h, 6Ah, 11h,0E9h, 08h
		db	 01h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_81B1	proc	near
		mov	bx,ds:data_b_1172_e
		cmp	bx,0Ah
		jb	loc_a_81BD		; Jump if below
		mov	bx,offset data_b_000A
loc_a_81BD:
		shl	bl,1			; Shift w/zeros fill
		mov	bx,ds:data_b_1202_e[bx]
		mov	cl,bh
		xor	ch,ch			; Zero register
		xor	bh,bh			; Zero register
		retn
sub_a_81B1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_81CA	proc	near
		mov	ax,data_b_02BA
		mov	bx,data_b_02BC
		push	bx
		mov	bx,ax
		cmp	byte ptr ds:data_b_1174_e,0
		jne	loc_a_81DE		; Jump if not equal
		call	sub_a_822D
loc_a_81DE:
		pop	ax
		push	bx
		mov	bx,ax
		cmp	byte ptr ds:data_b_1174_e+1,0
		jne	loc_a_81EC		; Jump if not equal
		call	sub_a_8253
loc_a_81EC:
		pop	ax
		mov	data_b_02BA,ax
		mov	data_b_02BC,bx
		mov	si,8
		call	dword ptr data_b_0049
		retn
sub_a_81CA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_81FC	proc	near
		cmp	byte ptr ds:data_b_1174_e,0
		jne	loc_a_820B		; Jump if not equal
		mov	ax,data_b_02BA
		and	ax,ax
		jns	loc_a_820B		; Jump if not sign
		retn
loc_a_820B:
		mov	cl,ds:data_b_1176_e
		xor	ch,ch			; Zero register
		mov	ax,ds:data_b_116C_e
		cmp	byte ptr data_b_0055,0
		jne	loc_a_8225		; Jump if not equal
		cmp	byte ptr data_b_0072,0
		je	loc_a_8225		; Jump if equal
		jmp	loc_a_859C
loc_a_8225:
		mov	si,26h
		call	dword ptr data_b_0049
		retn
sub_a_81FC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_822D	proc	near
		mov	al,1
		cmp	byte ptr ds:data_b_116A_e+1,1
		je	loc_a_8240		; Jump if equal
		cmp	byte ptr ds:data_b_116C_e,0
		je	loc_ret_a_8252		; Jump if equal
		mov	al,ds:data_b_1176_e
loc_a_8240:
		xor	ah,ah			; Zero register
		mul	word ptr ds:data_b_116E_e	; dx:ax = data * ax
		cmp	byte ptr ds:data_b_116C_e,1
		jne	loc_a_8250		; Jump if not equal
		shr	ax,1			; Shift w/zeros fill
		dec	ax
loc_a_8250:
		sub	bx,ax

loc_ret_a_8252:
		retn
sub_a_822D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8253	proc	near
		cmp	byte ptr ds:data_b_116A_e+1,1
		jne	loc_a_8265		; Jump if not equal
		mov	al,ds:data_b_1176_e
		xor	ah,ah			; Zero register
		mul	word ptr ds:data_b_1170_e	; dx:ax = data * ax
		jmp	short loc_a_8268
loc_a_8265:
		mov	ax,ds:data_b_1170_e
loc_a_8268:
		cmp	byte ptr ds:data_b_116C_e+1,2
		je	loc_ret_a_827A		; Jump if equal
		cmp	byte ptr ds:data_b_116C_e+1,1
		jne	loc_a_8278		; Jump if not equal
		shr	ax,1			; Shift w/zeros fill
loc_a_8278:
		sub	bx,ax

loc_ret_a_827A:
		retn
sub_a_8253	endp

			                        ;* No entry point to code
		inc	word ptr [bx+si]
		add	[bx+si],ax
		add	[bx+si],ax
		add	[bx+si],ax
		add	[bx+si],ax
		add	[bx+si],ax
		add	[bx+si],ax
		add	[bx+si],ax
		add	[bx+si],ax
		sub	ax,[bx+si]
		db	26 dup (0)
loc_a_82A9:
		mov	ds:data_b_12F5_e,ax
		mov	ds:data_b_12F7_e,bx
		mov	ds:data_b_12F9_e,cx
		mov	ds:data_b_12FB_e,dx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_82B9	proc	near
		cmp	byte ptr data_b_0055,3
		je	loc_ret_a_82DB		; Jump if equal
		mov	ds:data_b_12EC_e,ah
		cmp	al,ds:data_b_12EB_e
		je	loc_a_82DC		; Jump if equal
		mov	ds:data_b_12EB_e,al
		push	bx
		push	cx
		call	sub_a_855F
		pop	cx
		pop	bx
		jc	loc_a_82DC		; Jump if carry Set
		mov	byte ptr ds:data_b_12EB_e,0FFh

loc_ret_a_82DB:
		retn
loc_a_82DC:
		and	bx,bx
		jnz	loc_a_8304		; Jump if not zero
		mov	ax,ds:data_b_12F5_e
		mov	ds:data_b_12ED_e,ax
		mov	ax,ds:data_b_12F9_e
		mov	ds:data_b_12F1_e,ax
		mov	ax,ds:data_b_12F7_e
		and	ax,ax
		jnz	loc_a_82F4		; Jump if not zero
		inc	ax
loc_a_82F4:
		mov	ds:data_b_12EF_e,ax
		mov	ax,ds:data_b_12FB_e
		and	ax,ax
		jnz	loc_a_82FF		; Jump if not zero
		inc	ax
loc_a_82FF:
		mov	ds:data_b_12F3_e,ax
		jmp	short loc_a_8335
loc_a_8304:
		mov	ds:data_b_12ED_e,bx
		mov	ds:data_b_12F1_e,bx
		mov	ds:data_b_12EF_e,cx
		mov	ds:data_b_12F3_e,cx
		cmp	byte ptr ds:data_b_12EC_e,0
		jne	loc_a_8335		; Jump if not equal
		mov	bx,word ptr data_b_005A
		mov	cx,2710h
		cmp	bx,cx
		jae	loc_a_8335		; Jump if above or =
		mul	cx			; dx:ax = reg * ax
		div	bx			; ax,dx rem=dx:ax/reg
		mov	bx,ax
		and	bx,bx
		jnz	loc_a_8331		; Jump if not zero
		inc	bx
loc_a_8331:
		mov	ds:data_b_12ED_e,bx
loc_a_8335:
		call	sub_a_8340
		mov	bx,ds:data_b_1315_e
		mov	cx,bx
		stc				; Set carry flag
		retn
sub_a_82B9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8340	proc	near
		mov	al,ds:data_b_1305_e
		sub	al,ds:data_b_1307_e
		xor	ah,ah			; Zero register
		mul	word ptr ds:data_b_12F1_e	; dx:ax = data * ax
		div	word ptr ds:data_b_12F3_e	; ax,dxrem=dx:ax/data
		mov	ds:data_b_1315_e,ax
		retn
sub_a_8340	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8355	proc	near
		call	sub_a_8361
		mov	bx,word ptr ds:[1317h]
		mov	cx,word ptr ds:[1315h]
		retn
sub_a_8355	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8361	proc	near
		push	bx
		push	cx
		call	sub_a_8340
		mov	word ptr ds:data_b_1317_e,0
		mov	ax,ds:data_b_12FE_e
		shl	ax,1			; Shift w/zeros fill
		add	ax,10h
		lds	di,dword ptr ds:data_b_1311_e	; Load seg:offset ptr
		add	di,ax

locloop_a_837A:
		mov	al,es:[bx]
		inc	bx
		sub	al,byte ptr cs:[1301h]
		xor	ah,ah			; Zero register
		mov	si,di
		add	si,ax
		lodsb				; String [si] to al
		mul	word ptr cs:[12EDh]	; dx:ax = data * ax
		div	word ptr cs:[12EFh]	; ax,dxrem=dx:ax/data
		add	word ptr cs:[1317h],ax
		loop	locloop_a_837A		; Loop if cx > 0

		push	cs
		pop	ds
		mov	ax,word ptr ds:[1317h]
		pop	cx
		pop	bx
		retn
sub_a_8361	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_83A3	proc	near
		mov	word ptr ds:data_b_130D_e,0
		mov	word ptr ds:data_b_130F_e,0
		sub	al,ds:data_b_1301_e
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		les	di,dword ptr ds:data_b_1311_e	; Load seg:offset ptr
		mov	bx,di
		add	bx,10h
		add	bx,ax
		add	di,es:[bx]
		add	di,ds:data_b_1302_e
		cmp	byte ptr ds:data_b_1304_e,0
		je	loc_a_83D5		; Jump if equal
		jmp	short loc_a_8449
		db	90h
loc_a_83D3:
		pop	di
		pop	es
loc_a_83D5:
		call	sub_a_8431
		push	es
		push	di
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		mov	di,ax
		jmp	word ptr ds:data_b_1454_e[di]	;*
			                        ;* No entry point to code
		pop	sp
		adc	al,8Bh
		adc	al,81h
		adc	al,8Dh
		adc	al,0A1h
		or	ax,8B13h
		push	ds
		db	 0Fh, 13h, 8Ah, 0Eh, 6Bh, 00h
		db	 80h,0E1h, 01h, 8Ah, 2Eh,0ECh
		db	 12h, 3Ah,0CDh, 75h, 08h, 22h
		db	0C9h, 74h, 05h,0F7h,0D8h,0EBh
		db	 01h, 93h,0E8h, 43h, 02h, 5Fh
		db	 07h,0C3h,0E8h, 93h, 00h,0A3h
		db	 0Dh, 13h, 89h, 1Eh, 0Fh, 13h
		db	0EBh,0B6h,0E8h, 87h, 00h, 8Bh
		db	0C8h, 8Bh,0D3h, 87h, 0Eh, 0Dh
		db	 13h, 87h, 16h, 0Fh, 13h,0E8h
		db	 2Dh, 02h,0EBh,0A2h

;==== External Entry into Subroutine ======================================

sub_a_8431:
		mov	cx,es:[di]
		xchg	ch,cl
		inc	di
		inc	di
		xor	al,al			; Zero register
		test	ch,80h
		jz	loc_a_8441		; Jump if zero
		add	al,2
loc_a_8441:
		test	cl,80h
		jz	loc_ret_a_8448		; Jump if zero
		inc	al

loc_ret_a_8448:
		retn
loc_a_8449:
		push	es
		push	di
		xor	ax,ax			; Zero register
		call	sub_a_73C5
		pop	di
		pop	es
loc_a_8452:
		call	sub_a_8431
		push	es
		push	di
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		mov	di,ax
		call	word ptr ds:data_b_14D5_e[di]	;*
		pop	di
		pop	es
		jmp	short loc_a_8452
sub_a_83A3	endp

		db	0DDh, 14h,0EBh, 14h,0F6h, 14h
		db	0F6h, 14h,0FFh, 0Eh, 29h, 04h
		db	0B8h, 03h, 00h,0E8h, 4Eh,0EFh
		db	 58h,0E9h, 71h,0FFh,0B8h, 03h
		db	 00h,0E8h, 44h,0EFh, 33h,0C0h
		db	0E9h, 3Fh,0EFh,0E8h, 1Eh, 00h
		db	0A3h, 0Dh, 13h, 89h, 1Eh, 0Fh
		db	 13h,0F7h,0DBh, 80h, 3Eh, 6Bh
		db	 00h, 00h, 74h, 03h,0F7h,0D8h
		db	 93h, 03h, 06h,0BAh, 02h, 03h
		db	 1Eh,0BCh, 02h,0E9h, 15h,0EEh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_84A7	proc	near
		mov	al,ch
		call	sub_a_84BC
		call	sub_a_84D1
		push	ax
		mov	al,cl
		call	sub_a_84BC
		call	sub_a_84E8
		mov	bx,ax
		pop	ax
		retn
sub_a_84A7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_84BC	proc	near
		xor	dx,dx			; Zero register
		and	al,7Fh
		mov	bl,al
		xor	bh,bh			; Zero register
		and	al,40h			; '@'
		jz	loc_a_84CE		; Jump if zero
		dec	bh
		dec	dx
		or	bl,80h
loc_a_84CE:
		mov	ax,bx
		retn
sub_a_84BC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_84D1	proc	near
		mov	bx,ds:data_b_12ED_e
		cmp	bx,1
		je	loc_a_84DC		; Jump if equal
		imul	bx			; dx:ax = reg * ax
loc_a_84DC:
		mov	bx,ds:data_b_12EF_e
		cmp	bx,1
		je	loc_ret_a_84E7		; Jump if equal
		idiv	bx			; ax,dx rem=dx:ax/reg

loc_ret_a_84E7:
		retn
sub_a_84D1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_84E8	proc	near
		mov	bx,ds:data_b_12F1_e
		cmp	bx,1
		je	loc_a_84F3		; Jump if equal
		imul	bx			; dx:ax = reg * ax
loc_a_84F3:
		mov	bx,ds:data_b_12F3_e
		cmp	bx,1
		je	loc_ret_a_84FE		; Jump if equal
		idiv	bx			; ax,dx rem=dx:ax/reg

loc_ret_a_84FE:
		retn
sub_a_84E8	endp

		db	 00h, 00h,0FFh,0FFh,0E0h
		db	'.BOLD.CHR', 0
		db	'TRIP.CHR', 0
		db	'SANS.CHR', 0
		db	'LITT.CHR', 0
		db	'SIMP.CHR', 0
		db	'TSCR.CHR', 0
		db	'SCRI.CHR', 0
		db	'EURO.CHR', 0
		db	'LCOM.CHR', 0
		db	'GOTH.CHR', 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_855F	proc	near
		call	sub_a_8595
		and	ax,ax
		jnz	loc_a_856C		; Jump if not zero
		mov	byte ptr ds:data_b_12EB_e,0FFh
		retn
loc_a_856C:
		mov	word ptr ds:data_b_1311_e,0
		call	sub_a_8576
		retn
sub_a_855F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8576	proc	near
		lds	si,dword ptr ds:data_b_1311_e	; Load seg:offset ptr
		mov	cx,10h
		mov	di,12FDh
		push	cs
		pop	es
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		push	cs
		pop	ds
		cmp	byte ptr ds:[12FDh],2Bh	; '+'
		mov	byte ptr ds:[1304h],0
		stc				; Set carry flag
		jz	loc_ret_a_8594		; Jump if zero
		cmc				; Complement carry

loc_ret_a_8594:
		retn
sub_a_8576	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8595	proc	near
		mov	ax,word ptr ds:data_b_1311_e+2
		retn
sub_a_8595	endp

		db	0C3h, 00h, 00h
loc_a_859C:
		cmp	byte ptr ds:data_b_12EB_e,0FFh
		je	loc_ret_a_85E7		; Jump if equal
		jcxz	loc_ret_a_85E7		; Jump if cx=0
		push	data_b_0291
		mov	ds:data_b_160A_e,ax
		push	es
		push	bx
		call	sub_a_85E8
		push	cx
		xor	al,al			; Zero register
		mov	cx,1
		call	sub_a_7226
		cmp	byte ptr ds:[1304h],0
		je	loc_a_85C9		; Jump if equal
		mov	ax,word ptr ds:[73h]
		xchg	al,ah
		call	sub_a_71F8
loc_a_85C9:
		pop	cx
		pop	bx
		pop	es

locloop_a_85CC:
		mov	al,es:[bx]
		and	al,7Fh
		jz	loc_a_85DF		; Jump if zero
		push	es
		push	bx
		push	cx
		call	sub_a_83A3
		pop	cx
		pop	bx
		pop	es
		inc	bx
		loop	locloop_a_85CC		; Loop if cx > 0

loc_a_85DF:
		pop	ax
		mov	cl,ah
		xor	ch,ch			; Zero register
		call	sub_a_7226

loc_ret_a_85E7:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_85E8	proc	near
		push	cx
		call	sub_a_8361
		call	sub_a_85F4
		call	sub_a_8623
		pop	cx
		retn
sub_a_85E8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_85F4	proc	near
		cmp	byte ptr ds:[160Ah],0
		je	loc_ret_a_8622		; Jump if equal
		mov	ax,word ptr ds:[1315h]
		cmp	byte ptr ds:[12ECh],0
		jne	loc_a_8608		; Jump if not equal
		mov	ax,word ptr ds:[1317h]
loc_a_8608:
		cmp	byte ptr ds:[160Ah],1
		jne	loc_a_8612		; Jump if not equal
		shr	ax,1			; Shift w/zeros fill
		dec	ax
loc_a_8612:
		cmp	byte ptr ds:[6Bh],0
		je	loc_a_861E		; Jump if equal
		add	word ptr ds:[2BCh],ax
		retn
loc_a_861E:
		sub	word ptr ds:[2BAh],ax

loc_ret_a_8622:
		retn
sub_a_85F4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8623	proc	near
		mov	ax,word ptr ds:[1317h]
		cmp	byte ptr ds:[12ECh],0
		jne	loc_a_8630		; Jump if not equal
		mov	ax,word ptr ds:[1315h]
loc_a_8630:
		cmp	byte ptr ds:[160Bh],0
		je	loc_ret_a_8650		; Jump if equal
		cmp	byte ptr ds:[160Bh],1
		jne	loc_a_8640		; Jump if not equal
		shr	ax,1			; Shift w/zeros fill
loc_a_8640:
		cmp	byte ptr ds:[6Bh],0
		je	loc_a_864C		; Jump if equal
		add	word ptr ds:[2BAh],ax
		retn
loc_a_864C:
		add	word ptr ds:[2BCh],ax

loc_ret_a_8650:
		retn
sub_a_8623	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_8651	proc	near
		neg	bx
		add	data_b_02BC,bx
		add	data_b_02BA,ax
		retn
sub_a_8651	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_865C	proc	near
		push	ax
		mov	al,data_b_006B
		and	al,1
		mov	ah,ds:data_b_12EC_e
		cmp	al,ah
		jne	loc_a_8675		; Jump if not equal
		and	al,al
		pop	ax
		jz	loc_a_867D		; Jump if zero
		neg	ax
		neg	cx
		jmp	short loc_a_8681
loc_a_8675:
		pop	ax
		xchg	bx,ax
		xchg	cx,dx
		neg	ax
		neg	cx
loc_a_867D:
		neg	bx
		neg	dx
loc_a_8681:
		add	ax,data_b_02BA
		add	bx,data_b_02BC
		add	cx,data_b_02BA
		add	dx,data_b_02BC
		call	sub_a_7EEC
		jnc	loc_ret_a_869D		; Jump if carry=0
		mov	si,0Ch
		call	dword ptr data_b_0049

loc_ret_a_869D:
		retn
sub_a_865C	endp

		db	0, 0

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_c

		db	0
data_b_0001	db	0
		db	0
data_b_0003	db	0
data_b_0004	db	'Tur'
data_b_0007	db	'bo-'
data_b_000A	db	'C - Copyright (c) 1987 Bor'
		db	'land Intl.', 0
		db	'Null pointer '
data_b_003C	db	'assignment', 0Dh, 0Ah
		db	'D'
data_b_0049	db	'ivid'
data_b_004D	db	'e '
data_b_004F	db	'er'
data_b_0051	db	'ror', 0Dh
data_b_0055	db	0Ah
data_b_0056	db	'Ab'
data_b_0058	db	'no'
data_b_005A	db	'rm'
data_b_005C	db	'a'
data_b_005D	db	'l '
data_b_005F	db	'pr'
data_b_0061	db	'og'
data_b_0063	db	'ra'
data_b_0065	db	'm '
data_b_0067	db	'te'
data_b_0069	db	'rm'
data_b_006B	db	'i'
data_b_006C	db	'nati'
data_b_0070	db	'on'
data_b_0072	db	0Dh
data_b_0073	db	0Ah
		dw	0
data_b_0076	dw	0			; segment storage
data_b_0078	dw	0
data_b_007A	dw	0
data_b_007C	dw	0
data_b_007E	dd	00000h			; +2 = PSP environment segment
data_b_0082	dw	0
data_b_0084	dw	0			; PSP segment
data_b_0086	dw	0
data_b_0088	dw	0
data_b_008A	dw	0			; 1 = coprocessor 8087
		db	 75h, 0Bh
data_b_008E	dw	0B75h
		db	 75h, 0Bh
		db	0, 0
data_b_0094	dw	0
		db	0, 0
data_b_0098	dw	0
		db	0, 0
data_b_009C	dw	0			; PSP free segment
data_b_009E	db	2Ch
		db	 00h, 2Eh, 00h, 2Dh, 00h, 4Fh
		db	 00h, 51h, 00h, 50h, 00h
data_b_00AA	dw	0			; Data table (indexed access)
data_b_00AC	dw	0			; Data table (indexed access)
		db	'    Play    '
		db	0
		db	0
data_b_00BC	db	0			; Data table (indexed access)
		db	13 dup (0)
data_b_00CA	db	0			; Data table (indexed access)
		db	13 dup (0)
data_b_00D8	db	0			; Data table (indexed access)
		db	13 dup (0)
data_b_00E6	dw	0
		db	 04h, 00h, 50h, 4Ch, 31h, 20h
data_b_00EE	db	'Keyboard', 0		; Data table (indexed access)
		db	0
		db	'PL1 Joystick'
		db	 00h, 00h, 20h, 50h, 4Ch, 31h
data_b_010A	db	20h
data_b_010B	db	20h
data_b_010C	dw	6F4Dh
		db	75h
data_b_010F	db	73h
data_b_0110	db	65h
data_b_0111	dw	20h
data_b_0113	dw	5000h
data_b_0115	dw	314Ch
data_b_0117	dw	4320h
data_b_0119	db	6Fh
data_b_011A	db	6Dh
		db	 70h, 75h, 74h, 65h, 72h, 00h
		db	 00h
data_b_0122	dw	0
		db	 04h, 00h, 50h, 4Ch, 32h, 20h
data_b_012A	db	'Keyboard', 0		; Data table (indexed access)
		db	0
		db	'PL2 Joystick'
		db	0, 0
		db	' PL2  Mouse '
		db	0, 0
		db	'PL2 Computer'
		db	0, 0
data_b_015E	dw	0
		db	2, 0
		db	'  Sound On  '
		db	0, 0
		db	' Sound  Off '
		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_017D	proc	near
		db	33 dup (0)
		db	'Define  Keys'
		db	48 dup (0)
		db	'Set Joystick'
		db	0, 0
		db	46 dup (0)
		db	'    Exit    '
		db	0
		db	43 dup (0)
data_b_024E	dw	1
data_b_0250	dw	0			; Data table (indexed access)
		db	 01h, 00h, 02h, 00h, 03h, 00h
		db	 03h, 00h, 04h, 00h, 06h, 00h
		db	 07h, 00h, 09h, 00h, 0Eh, 00h
data_b_0264	dw	0FFFCh			; Data table (indexed access)
		db	0FCh,0FFh,0FDh,0FFh,0FDh,0FFh
		db	0FDh,0FFh,0FDh,0FFh,0FEh,0FFh
		db	0FEh,0FFh,0FEh,0FFh,0FEh,0FFh
		db	0FEh
		db	13 dup (0FFh)
		db	8 dup (0)
		db	1, 0, 1
data_b_0291	dw	100h
		db	0, 1, 0, 1, 0, 1
		db	0, 2, 0, 2, 0, 2
		db	0, 2, 0, 2, 0, 3
		db	0, 3, 0, 3, 0, 3
		db	0, 4, 0, 4, 0, 0
		db	0, 0
		db	 43h, 47h
		db	'A mod'
data_b_02BA	dw	2065h
data_b_02BC	dw	6F6Eh
data_b_02BE	dw	2074h
data_b_02C0	dw	7661h
		db	'ailable.'
data_b_02CA	dw	6100h
data_b_02CC	dw	2E76h
data_b_02CE	dw	6164h
data_b_02D0	dw	74h
data_b_02D2	dw	6946h
data_b_02D4	dw	656Ch
		db	' ``AV.DAT', 27h, 27h, ' not foun'
		db	'd.'
		db	0
		db	'PL1 Left  : '
		db	0
		db	'PL1 Right : '
		db	0
		db	'PL1 Jump  : '
		db	0
		db	'PL2 Left  : '
		db	0
		db	'PL2 Right : '
		db	0
		db	'PL2 Jump  : '
		db	0
		db	'Center stick th'
data_b_034A	dw	6E65h
		db	' press a key.'
		db	0
		db	'Arcade Volleyball'
		db	 00h, 30h, 00h, 30h, 00h
data_b_0370	dw	0
data_b_0372	dw	0
data_b_0374	dw	0
data_b_0376	db	0
data_b_0377	db	0
data_b_0378	db	0
data_b_0379	db	0
data_b_037A	db	0
data_b_037B	db	0
data_b_037C	db	0
data_b_037D	dw	0
data_b_037F	dw	0
data_b_0381	dw	1
data_b_0383	db	'COMPAQ', 0
		db	'printf : floating point formats '
		db	'not linked', 0Dh, 0Ah, 'scanf : '
		db	'floating'
data_b_03C6	db	' p'
data_b_03C8	db	'oi'
data_b_03CA	db	'nt '
		db	'formats '
		db	'not linke'
		db	'd', 0Dh, 0Ah, 0
data_b_03E2	db	'.@'
data_b_03E4	db	'.@'
data_b_03E6	db	'.@'
data_b_03E8	dw	2001h			; Data table (indexed access)
		db	 02h, 20h, 02h, 20h, 04h,0A0h
data_b_03F0	dw	0A002h
data_b_03F2	db	0FFh
data_b_03F3	dw	0FFFFh
data_b_03F5	db	0FFh
data_b_03F6	dw	0FFFFh
data_b_03F8	dw	0FFFFh
data_b_03FA	dw	0FFFFh
data_b_03FC	dw	0FFFFh
		db	0FFh,0FFh
data_b_0400	dw	0FFFFh
data_b_0402	dw	0FFFFh
data_b_0404	dw	6 dup (0FFFFh)
data_b_0410	db	0
		db	9 dup (0)
data_b_041A	dw	0
data_b_041C	dw	0
data_b_041E	db	0			; Data table (indexed access)
		db	13h
data_b_0420	dw	202h
data_b_0422	dw	504h
data_b_0424	dw	806h
data_b_0426	db	8
data_b_0427	dw	1408h
data_b_0429	dw	515h
data_b_042B	dw	0FF13h, 516h
data_b_042F	dw	211h
data_b_0431	dw	0FFFFh
data_b_0433	dw	0FFFFh
		db	9 dup (0FFh)
		db	 05h, 05h,0FFh
		db	0FFh,0FFh,0FFh,0FFh
data_b_0445	dw	0FFFFh
		db	9 dup (0FFh)
		db	 0Fh,0FFh,0FFh, 02h,0FFh, 0Fh
		db	0FFh,0FFh,0FFh,0FFh, 13h,0FFh
		db	0FFh, 02h, 02h, 05h, 0Fh, 02h
		db	0FFh,0FFh,0FFh, 13h
		db	15 dup (0FFh)
		db	 13h,0FFh, 00h, 00h, 00h, 78h
		db	 04h
data_b_047C	dw	478h
data_b_047E	dw	1000h			; Data table (indexed access)
		db	 28h, 6Eh, 75h, 6Ch, 6Ch, 29h
		db	 00h
data_b_0487	db	'0123456789ABCDEF'
data_b_0497	db	0			; Data table (indexed access)
		db	 13h, 13h, 01h, 13h, 14h, 13h
		db	 13h, 13h, 13h, 02h, 00h, 13h
		db	 03h, 04h, 13h, 08h, 05h
		db	8 dup (5)
		db	11 dup (13h)
		db	 0Eh, 16h, 0Eh, 07h, 13h, 13h
		db	 13h, 13h, 13h, 15h
		db	9 dup (13h)
		db	0Ch
data_b_04D0	db	13h
		db	9 dup (13h)
		db	 0Fh, 09h, 0Eh, 0Eh, 0Eh, 07h
		db	 09h, 13h, 13h, 06h, 13h, 11h
		db	 0Ah, 0Dh, 13h, 13h, 10h, 13h
		db	 0Bh, 13h, 13h
		db	0Ch
		db	7 dup (13h)
		db	39 dup (0)
data_b_051E	dw	0
		db	64 dup (0)
		db	 10h, 00h
		db	0, 0
data_b_0564	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
		db	 54h, 52h, 49h, 50h
		db	11 dup (0)
		db	 4Ch, 49h, 54h, 54h
		db	11 dup (0)
		db	 53h, 41h, 4Eh, 53h
		db	11 dup (0)
		db	 47h, 4Fh, 54h, 48h
		db	0, 0
data_b_059E	dw	0			; Data table (indexed access)
		db	111 dup (0)
data_b_060F	db	0
		db	36 dup (0)
		db	 15h, 07h, 19h, 07h, 20h, 07h
		db	 28h, 07h, 2Dh, 07h, 31h, 07h
data_b_0640	db	1			; Data table (indexed access)
		db	 01h, 01h, 01h, 01h,0FFh, 01h
		db	 01h, 01h, 01h, 01h, 01h, 10h
		db	 10h,0FFh,0FFh,0FFh,0FFh, 10h
		db	 10h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 04h,0FFh,0FFh, 7Fh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 01h
		db	 01h, 01h, 01h, 01h, 01h, 10h
		db	 10h, 10h,0FFh,0FFh,0FFh, 01h
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 03h
		db	 03h, 03h, 03h, 01h, 00h, 03h
		db	 03h, 03h, 03h, 01h, 01h, 0Fh
		db	 0Fh, 00h, 00h, 00h, 00h, 0Fh
		db	 03h
		db	7 dup (0)
		db	 03h, 00h, 00h, 0Fh, 0Fh, 00h
		db	 00h, 00h, 00h, 01h, 00h, 00h
		db	 00h, 00h, 00h, 03h, 03h, 03h
		db	 03h, 01h, 01h, 0Fh, 0Fh, 0Fh
		db	 00h, 00h, 00h, 01h
		db	7 dup (0)
		db	 01h, 02h, 03h, 04h, 05h, 14h
		db	 07h
		db	'89:;<=>?'
		db	 00h, 00h, 01h, 00h, 00h, 04h
		db	 07h, 00h, 00h, 00h, 01h, 00h
		db	 00h, 04h, 07h, 00h, 00h, 00h
		db	 00h, 01h, 02h, 03h, 04h, 05h
		db	 06h, 07h, 10h, 11h, 12h, 13h
		db	 14h, 15h, 16h, 17h, 00h, 00h
		db	 08h, 00h, 00h, 18h, 18h, 00h
		db	 00h, 00h, 08h, 00h, 00h, 00h
		db	 18h, 00h, 3Fh, 00h, 00h, 01h
		db	 02h, 03h, 04h, 05h, 06h, 07h
		db	 08h, 09h, 0Ah, 0Bh, 0Ch, 0Dh
		db	 0Eh, 0Fh
		db	0FFh,0FFh
data_b_070F	dw	0FFFFh
data_b_0711	dw	0FFFFh
data_b_0713	db	0FFh
data_b_0714	db	0FFh
		db	'CGA', 0
		db	'EGAVGA', 0
		db	'IBM8514', 0
		db	'HERC', 0
		db	'ATT', 0
		db	'PC3270', 0
		db	'No error', 0
		db	'(BGI) graphics not installed', 0
		db	'Graphics hardware not detected', 0
		db	'Device driver file not found (', 0
		db	'Invalid device driver file (', 0
		db	'Not enough memory t'
data_b_07CC	dw	206Fh
data_b_07CE	db	6Ch
data_b_07CF	dw	616Fh
data_b_07D1	db	64h
data_b_07D2	db	20h
data_b_07D3	db	64h
		db	 72h, 69h, 76h, 65h, 72h, 00h
		db	'Out of memory in scan fill'
		db	0
		db	'Out of memory in flood fill'
		db	0
		db	'Font file not found ('
		db	0
		db	'Not enough memory to load font'
		db	0
		db	'Invalid graphics mode for select'
		db	'ed driver'
		db	0
		db	'Graphics error'
		db	0
		db	'Graphics I/O error'
		db	0
		db	'Invalid font file ('
		db	0
		db	'Invalid font number'
		db	0
		db	'Invalid device number'
		db	0
		db	'Graphics error ('
		db	 00h, 29h, 00h
		db	0Ah, 'BGI Error: not in graphics '
		db	'mode', 0Ah, 0Ah, '$'
		db	0
		db	0Ah, 'BGI Error: graphics not ini'
		db	'tialized (use ', 27h, 'initgraph'
		db	27h, ')', 0Ah, 0Ah, '$'
		db	 00h, 2Eh, 42h, 47h, 49h, 00h
		db	 2Eh, 43h, 48h, 52h, 00h, 00h
		db	0FFh, 00h, 00h, 00h, 00h
data_b_0951	db	0			; Data table (indexed access)
		db	 00h, 00h, 00h,0FFh, 00h, 00h
data_b_0958	dw	offset sub_b_017D
		db	 7Dh, 01h
data_b_095C	dw	3E92h
data_b_095E	dw	3F5Bh
		db	 64h, 3Fh, 64h, 3Fh, 64h, 3Fh
data_b_0966	dw	?			; Data table (indexed access)
		db	?, ?, ?, ?, ?, ?
data_b_096E	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_0976	dw	?
		db	?, ?, ?, ?, ?
data_b_097D	dw	?
data_b_097F	db	?
		db	?, ?, ?, ?, ?, ?
data_b_0986	dw	?
data_b_0988	dw	?
data_b_098A	dw	?
data_b_098C	dw	?			; Data table (indexed access)
data_b_098E	dw	?
data_b_0990	dw	?			; Data table (indexed access)
		db	?, ?
data_b_0994	dw	?			; Data table (indexed access)
		db	?, ?, ?, ?, ?, ?
data_b_099C	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_09A4	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_09AC	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_09B4	dw	?
data_b_09B6	dw	?
data_b_09B8	dw	?
data_b_09BA	dw	?
data_b_09BC	dw	?
data_b_09BE	dw	?			; Data table (indexed access)
data_b_09C0	dw	?
data_b_09C2	dw	?
data_b_09C4	dw	?
data_b_09C6	dw	?
data_b_09C8	dw	?			; Data table (indexed access)
data_b_09CA	dw	?			; Data table (indexed access)
data_b_09CC	dw	?			; Data table (indexed access)
		db	?, ?, ?, ?
data_b_09D2	dw	?
data_b_09D4	dw	?
data_b_09D6	dw	?
data_b_09D8	dw	?
data_b_09DA	dw	?
data_b_09DC	dw	?
data_b_09DE	dw	?			; Data table (indexed access)
data_b_09E0	dw	?
data_b_09E2	dw	?
data_b_09E4	dw	?			; Data table (indexed access)
data_b_09E6	dw	?
data_b_09E8	dw	?			; Data table (indexed access)
data_b_09EA	dw	?
data_b_09EC	dw	?
data_b_09EE	dw	?			; Data table (indexed access)
		db	?, ?, ?, ?, ?, ?
data_b_09F6	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_09FE	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_0A06	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_0A0E	dw	?
data_b_0A10	dw	?			; Data table (indexed access)
		db	?, ?
data_b_0A14	dw	?
		db	?, ?
data_b_0A18	dw	?			; Data table (indexed access)
		db	?, ?, ?, ?, ?, ?
data_b_0A20	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_0A28	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_0A30	dw	?
		db	?, ?, ?, ?, ?, ?
data_b_0A38	dw	?
data_b_0A3A	dw	?
data_b_0A3C	dw	?
data_b_0A3E	dw	?
data_b_0A40	dw	?
data_b_0A42	dw	?
data_b_0A44	dw	?
data_b_0A46	dw	?
data_b_0A48	dw	?
		db	?
data_b_0A4B	dw	?
data_b_0A4D	dw	?
		db	?
data_b_0A50	dw	?
data_b_0A52	dw	?			; Data table (indexed access)
		db	62 dup (?)
data_b_0A92	dw	?
		db	10 dup (?)
data_b_0A9E	dw	?
		db	12 dup (?)
data_b_0AAC	dw	?
		db	21 dup (?)
data_b_0AC3	dw	?
		db	102 dup (?)
data_b_0B2B	dw	?
data_b_0B2D	dw	?
		db	15 dup (?)
data_b_0B3E	db	?
		db	16 dup (?)
data_b_0B4F	dw	?
		db	47 dup (?)
sub_b_017D	endp


seg_b		ends



;------------------------------------------------------  stack_seg_c   ----

stack_seg_c	segment	word stack 'stack'

		db	128 dup (?)

stack_seg_c	ends



		end	start
