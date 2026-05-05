
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
;==				PANGO	                                 ==
;==					                                 ==
;==      Created:   16-Nov-84		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==      COPYRIGHT BY SHENG-CHUNG LIU, 1983                              ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_B800_0000_e	equ	0
d_B800_00A0_e	equ	0A0h
d_B800_00A1_e	equ	0A1h
d_B800_00A2_e	equ	0A2h
d_B800_00A3_e	equ	0A3h
d_B800_00F0_e	equ	0F0h
d_B800_00F1_e	equ	0F1h
d_B800_00F2_e	equ	0F2h
d_B800_00F3_e	equ	0F3h
d_B800_0140_e	equ	140h
d_B800_0141_e	equ	141h
d_B800_0142_e	equ	142h
d_B800_0143_e	equ	143h
d_B800_0148_e	equ	148h
d_B800_014A_e	equ	14Ah
d_B800_0190_e	equ	190h
d_B800_0191_e	equ	191h
d_B800_0192_e	equ	192h
d_B800_0193_e	equ	193h
d_B800_01E0_e	equ	1E0h
d_B800_01E1_e	equ	1E1h
d_B800_01E2_e	equ	1E2h
d_B800_01E3_e	equ	1E3h
d_B800_0230_e	equ	230h
d_B800_0231_e	equ	231h
d_B800_0232_e	equ	232h
d_B800_0233_e	equ	233h
d_B800_023A_e	equ	23Ah
d_B800_0280_e	equ	280h
d_B800_0288_e	equ	288h
d_B800_02CE_e	equ	2CEh
d_B800_0418_e	equ	418h
d_B800_045E_e	equ	45Eh
d_B800_1CC0_e	equ	1CC0h
d_B800_1E0A_e	equ	1E0Ah
d_B800_1EF0_e	equ	1EF0h
d_B800_1EFA_e	equ	1EFAh
d_B800_2000_e	equ	2000h
d_B800_2001_e	equ	2001h
d_B800_2002_e	equ	2002h
d_B800_2003_e	equ	2003h
d_B800_2004_e	equ	2004h
d_B800_2005_e	equ	2005h
d_B800_2006_e	equ	2006h
d_B800_2007_e	equ	2007h
d_B800_2008_e	equ	2008h
d_B800_2009_e	equ	2009h
d_B800_200A_e	equ	200Ah
d_B800_200B_e	equ	200Bh
d_B800_200C_e	equ	200Ch
d_B800_200D_e	equ	200Dh
d_B800_200E_e	equ	200Eh
d_B800_200F_e	equ	200Fh
d_B800_2010_e	equ	2010h
d_B800_2046_e	equ	2046h
d_B800_2050_e	equ	2050h
d_B800_2051_e	equ	2051h
d_B800_2052_e	equ	2052h
d_B800_2053_e	equ	2053h
d_B800_20A0_e	equ	20A0h
d_B800_20A1_e	equ	20A1h
d_B800_20A2_e	equ	20A2h
d_B800_20A3_e	equ	20A3h
d_B800_20F0_e	equ	20F0h
d_B800_20F1_e	equ	20F1h
d_B800_20F2_e	equ	20F2h
d_B800_20F3_e	equ	20F3h
d_B800_2140_e	equ	2140h
d_B800_2141_e	equ	2141h
d_B800_2142_e	equ	2142h
d_B800_2143_e	equ	2143h
d_B800_2190_e	equ	2190h
d_B800_2191_e	equ	2191h
d_B800_2192_e	equ	2192h
d_B800_2193_e	equ	2193h
d_B800_21E0_e	equ	21E0h
d_B800_21E1_e	equ	21E1h
d_B800_21E2_e	equ	21E2h
d_B800_21E3_e	equ	21E3h
d_B800_2230_e	equ	2230h
d_B800_2231_e	equ	2231h
d_B800_2232_e	equ	2232h
d_B800_2233_e	equ	2233h
d_B800_2280_e	equ	2280h
d_B800_3CC0_e	equ	3CC0h
d_B800_3EF0_e	equ	3EF0h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	para public
		assume cs:seg_a  , ds:seg_b , ss:stack_seg_c


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


PANGO		proc	far

start:
		push	ds
		sub	ax,ax
		push	ax
		mov	ax,seg_b
		mov	ds,ax

		; set display mode 0
		mov	ax,0
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

; !!! Picopad modification - do not use color monitor
		jmp	short loc_a_0024
		nop

		; print "Do You Use Color Monitor (Y/N) ?"
;		mov	dx,0B03h
		mov	si,2DBh
		mov	bl,0Eh
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_00D2		; Input key with echo
		cmp	al,59h			; 'Y'
		je	loc_a_002C		; Jump if equal
		cmp	al,79h			; 'y'
		je	loc_a_002C		; Jump if equal
loc_a_0024:	mov	byte ptr data_b_004A,1
		jmp	short loc_a_0031
		db	90h
loc_a_002C:
		mov	byte ptr data_b_004A,0
loc_a_0031:

; !!! Picopad modification - do not use joystick
		jmp	short loc_a_0044
		nop

		; print 'Do You Use Joystick (Y/N) ? $'
;		mov	dx,0E03h
		mov	si,2FDh
		mov	bl,0Eh
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_00D2		; Input key with echo
		cmp	al,79h			; 'y'
		je	loc_a_004F		; Jump if equal
		cmp	al,59h			; 'Y'
		je	loc_a_004F		; Jump if equal
loc_a_0044:	mov	byte ptr data_b_004C,0
		jmp	short loc_a_0054
		db	90h
loc_a_004F:
		mov	byte ptr data_b_004C,1
loc_a_0054:

; !!! Picopad modification - skip intro
;		call	sub_a_4A64		; Play intro demo screen
;		call	sub_a_09CC		; Wait a while
;		call	sub_a_09CC		; Wait a while

		nop
		nop
		nop

		nop
		nop
		nop

		nop
		nop
		nop

		call	sub_a_57A9		; Enable output to speaker
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound

		; select game menu
loc_a_0068:

; !!! Picopad modification - display help

		call	sub_a_486B		; display help
		mov	ah,al

		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

;		call	sub_a_4E46
;		cmp	ah,48h			; 'H'
;		je	loc_a_0096		; Jump if equal
;		cmp	ah,68h			; 'h'
;		je	loc_a_0096		; Jump if equal
		cmp	ah,58h			; 'X'
		je	loc_a_00C9		; Jump if equal
		cmp	ah,78h			; 'x'
		je	loc_a_00C9		; Jump if equal

;		cmp	ah,35h			; '5'
;		ja	loc_a_0068		; Jump if above
;		cmp	ah,30h			; '0'
;		jbe	loc_a_0068		; Jump if below or =

		mov	ah,31h
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

		; start game
		sub	ah,31h			; '1'
		mov	al,ah
		mov	ah,0
		mov	data_b_004D,ax
		jmp	short loc_a_00B5
		db	90h

		; display high score
loc_a_0096:
		; print 'High score of which level ? $'
		mov	dx,1806h
		mov	si,2BEh
		mov	bl,0Eh
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_00D2		; Input key with echo
		cmp	al,30h			; '0'
		jbe	loc_a_0068		; Jump if below or =
		cmp	al,35h			; '5'
		ja	loc_a_0068		; Jump if above
		sub	al,31h			; '1'
		mov	dh,al
		call	sub_a_4F35		; load and display high score
		jmp	short loc_a_0068

		; start game
loc_a_00B5:
		; set graphics mode 4
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		; set palettes
		mov	bh,1
		mov	bl,data_b_004A
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		call	sub_a_00EB		; game
		jmp	short loc_a_0068

		; game exit
loc_a_00C9:
		call	sub_a_57B2		; Disable output to speaker

		; set text mode 3
		mov	ax,3
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retf				; Return far

PANGO		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input key with echo

sub_a_00D2	proc	near
		push	bx
		pushf				; Push flags
loc_a_00D4:
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_a_00D4		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		mov	cx,1
		mov	bx,0Eh
		mov	ah,9
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		popf				; Pop flags
		pop	bx
		retn
sub_a_00D2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Start game

sub_a_00EB	proc	near
		mov	bx,0F618h
loc_a_00EE:
		dec	bx
		jnz	loc_a_00EE		; Jump if not zero
		mov	byte ptr data_b_0138,3
		mov	ax,data_b_004D
		mov	dh,al
		mov	dl,4
		call	sub_a_4FDC
		mov	si,offset data_b_013F
		mov	[si],ah
		mov	[si+1],al
		mov	[si+2],bh
		mov	[si+3],bl
		mov	[si+4],ch
		mov	[si+5],cl
		mov	dl,0
		call	sub_a_4FDC
		call	sub_a_02D8
		mov	bx,offset data_b_0149
		mov	[bx],ax
		mov	[bx+2],dx
		mov	ax,0
		mov	bx,offset data_b_0145
		mov	[bx],ax
		mov	[bx+2],ax
		mov	byte ptr data_b_0041,0
		mov	byte ptr data_b_013C,0
loc_a_0139:
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound
		mov	byte ptr data_b_013B,7
		call	sub_a_55C7		; Play sound
		mov	bx,data_b_004D
		mov	si,bx
		mov	ax,data_b_0054[bx+si]
		mov	data_b_0139,ax
		mov	data_b_0000,0
		mov	byte ptr data_b_0022,0
		mov	byte ptr data_b_013E,0
		mov	data_b_0042,0
		mov	byte ptr data_b_009D,0
		mov	data_b_00A3,0
		mov	byte ptr data_b_00D4,0
		mov	bl,data_b_013C
		mov	bh,0
		and	bl,0Fh
		mov	al,data_b_008D[bx]
		mov	data_b_00A0,al
		call	sub_a_0F33
		mov	dl,0
		mov	bx,offset data_b_0000+1
loc_a_0194:
		mov	data_b_00F2[bx],dl
		mov	data_b_00EB[bx],dl
		mov	data_b_00F9[bx],dl
		inc	bx
		cmp	bx,7
		jne	loc_a_0194		; Jump if not equal
		call	sub_a_408B
		call	sub_a_1FB4
		call	sub_a_1EB6
		call	sub_a_1E46
		call	sub_a_050B		; Print character sound setup (note)
		call	sub_a_0544
		call	sub_a_0266
		mov	bx,805h
		call	sub_a_1F1E
		mov	cx,si
		call	sub_a_2F87
		push	bx
		push	cx
		call	sub_a_09DD
		call	sub_a_09DD
		mov	bx,data_b_004D
		mov	dh,data_b_004F[bx]
		call	sub_a_0F61
		call	sub_a_09DD
		call	sub_a_09DD
		sub	data_b_00A0,dh
		call	sub_a_0F33
		call	sub_a_0291
		pop	cx
		pop	bx
		call	sub_a_0457		; Flush keyboard
		call	sub_a_031A
		mov	dh,data_b_0138
		cmp	dh,0
		je	loc_a_01FD		; Jump if equal
		jmp	loc_a_0139
loc_a_01FD:
		; print ' GAME OVER $'
		mov	dx,0C10h
		mov	si,31Ah
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_09CC		; Wait a while
		mov	di,offset data_b_019E
		mov	si,offset data_b_013F
		mov	bx,offset data_b_0000
loc_a_0214:
		mov	al,[bx+di]
		cmp	al,[bx+si]
		je	loc_a_0221		; Jump if equal
		cmp	al,[bx+si]
		jb	loc_ret_a_0240		; Jump if below

; !!! Picopad modification - no high score

;		jmp	short loc_a_0227
		jmp	short loc_ret_a_0240

		db	90h
loc_a_0221:
		inc	bx
		cmp	bx,6
		jne	loc_a_0214		; Jump if not equal

		; new high score
loc_a_0227:
		mov	ax,data_b_004D
		mov	dh,al
		mov	ah,[di]
		mov	al,[di+1]
		mov	bh,[di+2]
		mov	bl,[di+3]
		mov	ch,[di+4]
		mov	cl,[di+5]

		nop
		nop
		nop
;		call	sub_a_5059		; Write high score table

loc_ret_a_0240:
		retn
sub_a_00EB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print text DS:SI (with $) at position DX

sub_a_0241	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
loc_a_0246:
		; set cursor position
		mov	bh,0
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		; display character
		mov	cx,1
		mov	bh,0
		mov	ah,9
		mov	al,[si]
		cmp	al,24h			; '$'
		je	loc_a_0260		; Jump if equal
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		inc	si
		inc	dl
		jmp	short loc_a_0246
loc_a_0260:
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0241	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0266	proc	near
		push	dx
		push	cx
		push	bx
		mov	cx,0F3h
		mov	bl,data_b_0138
		add	bl,0Ah
		mov	bh,4
loc_a_0275:
		cmp	bl,0Bh
		jbe	loc_a_0280		; Jump if below or =
		call	sub_a_30CD
		jmp	short loc_a_0283
		db	90h
loc_a_0280:
		call	sub_a_3A2B
loc_a_0283:
		add	cx,2D0h
		dec	bl
		dec	bh
		jnz	loc_a_0275		; Jump if not zero
		pop	bx
		pop	cx
		pop	dx
		retn
sub_a_0266	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0291	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		mov	bx,data_b_004D
		mov	al,data_b_004F[bx]
		mul	data_b_00B5		; ax = data * al
		mov	bp,offset data_b_0000
loc_a_02A6:
		mov	bx,ds:data_b_005E[bp]
		call	sub_a_1F3D
		cmp	byte ptr data_b_0380[si],3
		jne	loc_a_02B8		; Jump if not equal
		dec	bh
		dec	si
loc_a_02B8:
		mov	ds:data_b_011C[bp],bx
		call	sub_a_1F1E
		mov	ds:data_b_012A[bp],si
		mov	cx,si
		call	sub_a_2550
		add	bp,2
		cmp	bp,ax
		jne	loc_a_02A6		; Jump if not equal
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0291	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_02D8	proc	near
		push	bx
		push	cx
		sub	ax,3030h
		sub	bx,3030h
		sub	cx,3030h
		mov	dl,al
		mov	al,ah
		mul	data_b_00BF		; ax = data * al
		add	al,dl
		mul	data_b_00BF		; ax = data * al
		push	bx
		mov	bl,bh
		mov	bh,0
		add	ax,bx
		mul	data_b_00BD		; dx:ax = data * ax
		pop	bx
		mov	bh,0
		add	ax,bx
		mul	data_b_00BD		; dx:ax = data * ax
		push	cx
		mov	cl,ch
		mov	ch,0
		add	ax,cx
		mul	data_b_00BD		; dx:ax = data * ax
		pop	cx
		mov	ch,0
		add	ax,cx
		pop	cx
		pop	bx
		retn
sub_a_02D8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_031A	proc	near
		push	cx
		push	dx
loc_a_031C:
		call	sub_a_04BE		; test key from keyboard (ZY = no key)
		jnz	loc_a_0334		; Jump if not zero
		mov	ah,data_b_004C
		cmp	ah,0
		je	loc_a_0332		; Jump if equal
		call	sub_a_53E0
		cmp	ah,0
		jne	loc_a_0334		; Jump if not equal
loc_a_0332:
		jmp	short loc_a_031C
loc_a_0334:
		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_00A5,cx
		mov	data_b_00A7,dx
		pop	dx
		pop	cx
		clc				; Clear carry flag
loc_a_0343:
		jc	loc_ret_a_034A		; Jump if carry Set
		call	sub_a_0468
		jnc	loc_a_034B		; Jump if carry=0

loc_ret_a_034A:
		retn
loc_a_034B:
		call	sub_a_04BE		; test key from keyboard (ZY = no key)
		jnz	loc_a_0371		; Jump if not zero
		mov	ah,data_b_004C
		cmp	ah,0
		je	loc_a_036A		; Jump if equal
		call	sub_a_53E0
		cmp	ah,data_b_004B
		je	loc_a_036A		; Jump if equal
		mov	byte ptr data_b_004B,0FFh
		jmp	short loc_a_0374
		db	90h
loc_a_036A:
		mov	ah,data_b_00D5
		jmp	short loc_a_0374
		db	90h
loc_a_0371:
		call	sub_a_0428		; input keys ;KOL (wait)
loc_a_0374:
		mov	al,data_b_00D4
		cmp	al,1
		jne	loc_a_0383		; Jump if not equal
		call	sub_a_218D
		mov	byte ptr data_b_00D4,0
loc_a_0383:
		cmp	ah,1
		je	loc_a_03B6		; Jump if equal
		cmp	ah,2
		je	loc_a_03C0		; Jump if equal
		cmp	ah,8
		je	loc_a_03CB		; Jump if equal
		cmp	ah,4
		je	loc_a_03D6		; Jump if equal
		cmp	ah,39h			; '9'
		je	loc_a_03E1		; Jump if equal
		cmp	ah,10h
		je	loc_a_03E6		; Jump if equal
loc_a_03A1:
		call	sub_a_05F8
		jc	loc_ret_a_03EB		; Jump if carry Set
		call	sub_a_11B0
		call	sub_a_03EC
		mov	byte ptr data_b_00D5,0
		call	sub_a_0956
		jmp	short loc_a_0343
loc_a_03B6:
		call	sub_a_05F8
		jc	loc_ret_a_03EB		; Jump if carry Set
		call	sub_a_0C46
		jmp	short loc_a_0343
loc_a_03C0:
		call	sub_a_05F8
		jc	loc_ret_a_03EB		; Jump if carry Set
		call	sub_a_0CC0
		jmp	loc_a_0343
loc_a_03CB:
		call	sub_a_05F8
		jc	loc_ret_a_03EB		; Jump if carry Set
		call	sub_a_0D3A
		jmp	loc_a_0343
loc_a_03D6:
		call	sub_a_05F8
		jc	loc_ret_a_03EB		; Jump if carry Set
		call	sub_a_0DB8
		jmp	loc_a_0343
loc_a_03E1:
		call	sub_a_0E36
		jmp	short loc_a_03A1
loc_a_03E6:
		call	sub_a_04C5		; setup sound output
		jmp	short loc_a_03A1

loc_ret_a_03EB:
		retn
sub_a_031A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_03EC	proc	near
		inc	data_b_0049
		cmp	byte ptr data_b_0049,12h
		jl	loc_a_0426		; Jump if <
		cmp	byte ptr data_b_00D6,1
		jne	loc_a_0404		; Jump if not equal
		call	sub_a_30CD
		jmp	short loc_a_0421
		db	90h
loc_a_0404:
		cmp	byte ptr data_b_00D6,2
		jne	loc_a_0411		; Jump if not equal
		call	sub_a_332C
		jmp	short loc_a_0421
		db	90h
loc_a_0411:
		cmp	byte ptr data_b_00D6,4
		jne	loc_a_041E		; Jump if not equal
		call	sub_a_2E4F
		jmp	short loc_a_0421
		db	90h
loc_a_041E:
		call	sub_a_2C46
loc_a_0421:
		mov	byte ptr data_b_0049,0
loc_a_0426:
		clc				; Clear carry flag
		retn
sub_a_03EC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; input keys ;KOL (wait)

sub_a_0428	proc	near

		; input key, wait
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan

		; key ;
		cmp	ah,27h			; '''
		jne	loc_a_0436		; Jump if not equal
		mov	ah,1
		jmp	short loc_a_0451
		db	90h
loc_a_0436:
		; key K
		cmp	ah,25h			; '%'
		jne	loc_a_0440		; Jump if not equal
		mov	ah,2
		jmp	short loc_a_0451
		db	90h
loc_a_0440:
		; key O
		cmp	ah,18h
		jne	loc_a_044A		; Jump if not equal
		mov	ah,8
		jmp	short loc_a_0451
		db	90h
loc_a_044A:
		; key L
		cmp	ah,26h			; '&'
		jne	loc_ret_a_0456		; Jump if not equal
		mov	ah,4
loc_a_0451:
		mov	byte ptr data_b_004B,0

loc_ret_a_0456:
		retn
sub_a_0428	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Flush keyboard

sub_a_0457	proc	near
		push	ax
		pushf				; Push flags
loc_a_0459:
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_a_0465		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		jmp	short loc_a_0459
loc_a_0465:
		popf				; Pop flags
		pop	ax
		retn
sub_a_0457	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0468	proc	near
		push	dx
		call	sub_a_1F3D
		mov	dh,data_b_0380[si]
		cmp	dh,10h
		jl	loc_a_047E		; Jump if <
		call	sub_a_09EE
		call	sub_a_0457		; Flush keyboard
		jmp	short loc_a_0482
		db	90h
loc_a_047E:
		clc				; Clear carry flag
		add	dh,1
loc_a_0482:
		pop	dx
		retn
sub_a_0468	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0484	proc	near
		push	dx
		push	bx
		call	sub_a_1F3D
		mov	dh,data_b_0380[si]
		cmp	dh,10h
		jl	loc_a_04B7		; Jump if <
		mov	bl,data_b_0380[si]
		sub	bl,0Fh
		mov	bh,0
		mov	dh,data_b_00E4[bx]
		or	dh,data_b_00D6
		cmp	dh,3
		je	loc_a_04AD		; Jump if equal
		cmp	dh,0Ch
		jne	loc_a_04B7		; Jump if not equal
loc_a_04AD:
		pop	bx
		call	sub_a_09EE
		call	sub_a_0457		; Flush keyboard
		jmp	short loc_a_04BC
		db	90h
loc_a_04B7:
		clc				; Clear carry flag
		add	dh,1
		pop	bx
loc_a_04BC:
		pop	dx
		retn
sub_a_0484	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; test key from keyboard (ZY = no key)

sub_a_04BE	proc	near
		push	ax
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		pop	ax
		retn
sub_a_04BE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; setup sound output

sub_a_04C5	proc	near
		push	ax
		push	bx
		push	dx
		push	cx
		inc	data_b_0048		; sound setup
		mov	al,data_b_0048
		cbw				; Convrt byte to word
		div	data_b_00B8		; al,ah rem = ax/data  / 3
		cmp	ah,1
		je	loc_a_04FB		; Jump if equal
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		mov	ah,al
		or	ah,0FCh
		neg	ah
		and	al,0FCh
		or	al,ah
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		cmp	ah,0
		jne	loc_a_0503		; Jump if not equal
		mov	byte ptr data_b_013B,9
		call	sub_a_55C7		; Play sound
		jmp	short loc_a_0503
		db	90h
loc_a_04FB:
		mov	byte ptr data_b_013B,8
		call	sub_a_55C7		; Play sound
loc_a_0503:
		call	sub_a_050B		; Print character sound setup (note)
		pop	cx
		pop	dx
		pop	bx
		pop	ax
		retn
sub_a_04C5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print character sound setup (note)

sub_a_050B	proc	near
		push	ax
		push	bx
		push	cx
		push	dx

		; set cursor
		mov	bx,3
		mov	ah,2
		mov	dx,0
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	al,data_b_0048		; sound setup
		cbw				; Convrt byte to word
		div	data_b_00B8		; al,ah rem = ax/data
		cmp	ah,0
		jne	loc_a_052C		; Jump if not equal
		mov	ax,90Eh			; character double note
		jmp	short loc_a_053A
		db	90h
loc_a_052C:
		cmp	ah,1
		jne	loc_a_0537		; Jump if not equal
		mov	ax,90Dh			; character single note
		jmp	short loc_a_053A
		db	90h
loc_a_0537:
		mov	ax,900h			; character space
loc_a_053A:
		mov	cx,1
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_050B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0544	proc	near
		push	ax
		push	dx
		push	si
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	si,d_B800_0000_e
		mov	dl,0D7h
loc_a_0552:
		mov	es:d_B800_0280_e[si],dl
		mov	es:d_B800_2280_e[si],dl
		add	si,50h
		cmp	si,1090h
		jl	loc_a_0552		; Jump if <
		mov	dl,0EBh
		cmp	si,1C70h
		jne	loc_a_0552		; Jump if not equal
		mov	dl,0FFh
		mov	es:d_B800_1EF0_e,dl
		mov	es:d_B800_3EF0_e,dl
		mov	es:d_B800_0230_e,dl
		mov	es:d_B800_2230_e,dl
		pop	es
		pop	si
		pop	dx
		pop	ax
		retn
sub_a_0544	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0588	proc	near
		push	ax
		push	si
		push	cx
		push	dx
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	ax,dx
		cwd				; Word to double word
		div	data_b_00C0		; ax,dxrem=dx:ax/data
		mul	data_b_00C8		; ax = data * al
		cmp	ax,1C70h
		jge	loc_a_05BF		; Jump if > or =
		mov	si,ax
		mov	dl,0C3h
		mov	es:d_B800_0280_e[si],dl
		mov	es:d_B800_2280_e[si],dl
		cmp	si,0
		je	loc_a_05BF		; Jump if equal
		mov	es:d_B800_0230_e[si],dl
		mov	es:d_B800_2230_e[si],dl
loc_a_05BF:
		pop	es
		pop	dx
		pop	cx
		pop	si
		pop	ax
		retn
sub_a_0588	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_05C5	proc	near
		push	ax
		push	cx
		push	dx

		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
;*		and	dx,7
		db	 81h,0E2h, 07h, 00h	;  Fixup - byte match
		cmp	dx,7
		jne	loc_a_05E6		; Jump if not equal
		mov	cx,data_b_0044
		call	sub_a_3A5B
		mov	cx,data_b_0046
		call	sub_a_3A5B
		jmp	short loc_a_05F4
		db	90h
loc_a_05E6:
		mov	cx,data_b_0044
		call	sub_a_3BBC
		mov	cx,data_b_0046
		call	sub_a_3BBC
loc_a_05F4:
		pop	dx
		pop	cx
		pop	ax
		retn
sub_a_05C5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_05F8	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		cmp	data_b_0042,0
		je	loc_a_0606		; Jump if equal
		call	sub_a_05C5
loc_a_0606:
		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	cx,data_b_00A5
		cmp	cx,0
		je	loc_a_061E		; Jump if equal
		mov	bx,data_b_00A7
		neg	bx
		add	dx,bx
		jmp	short loc_a_0622
		db	90h
loc_a_061E:
		sub	dx,data_b_00A7
loc_a_0622:
		call	sub_a_0588
		push	dx
		mov	ax,dx
		cwd				; Word to double word
		div	data_b_00CA		; ax,dxrem=dx:ax/data
		cmp	ax,1
		jl	loc_a_0656		; Jump if <
		mov	byte ptr data_b_013B,5
		call	sub_a_55C7		; Play sound
		cmp	ax,2
		jae	loc_a_0676		; Jump if above or =
		call	sub_a_06E2
		mov	bl,data_b_00C9
		cmp	bl,1
		jne	loc_a_0656		; Jump if not equal
		inc	data_b_009D
		cmp	byte ptr data_b_009D,0Fh
		jae	loc_a_0676		; Jump if above or =
loc_a_0656:
		mov	bx,data_b_0139
		cmp	bx,0
		jne	loc_a_0696		; Jump if not equal
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound
		inc	data_b_009D
		cmp	byte ptr data_b_009D,19h
		jae	loc_a_0676		; Jump if above or =
		pop	cx
		jmp	short loc_a_06DC
		db	90h
loc_a_0676:
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound
		pop	cx
		push	ax
		mov	ax,dx
		div	data_b_00C7		; al,ah rem = ax/data
		mov	dl,al
		mov	dh,0
		pop	ax
		call	sub_a_07CD
		inc	data_b_013C
		stc				; Set carry flag
		jmp	short loc_a_06DD
		db	90h
loc_a_0696:
		pop	dx
		cmp	dx,27Dh
		jle	loc_a_06BE		; Jump if < or =
		mov	byte ptr data_b_00FA,1
		mov	byte ptr data_b_00FB,1
		mov	byte ptr data_b_00FC,1
		mov	byte ptr data_b_00FD,1
		mov	byte ptr data_b_00FE,1
		mov	byte ptr data_b_00FF,1
		jmp	short loc_a_06DC
		db	90h
loc_a_06BE:
		mov	byte ptr data_b_00FA,0
		mov	byte ptr data_b_00FB,0
		mov	byte ptr data_b_00FC,0
		mov	byte ptr data_b_00FD,0
		mov	byte ptr data_b_00FE,0
		mov	byte ptr data_b_00FF,0
loc_a_06DC:
		clc				; Clear carry flag
loc_a_06DD:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_05F8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_06E2	proc	near
		push	bx
		push	cx
		push	dx
		push	si
		push	di
		mov	byte ptr data_b_00C9,1
		mov	cx,0
loc_a_06EF:
		mov	dx,data_b_0139
		ror	dx,cl			; Rotate
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
		jz	loc_a_0749		; Jump if zero
		mov	si,cx
		cmp	byte ptr data_b_00F3[si],1
		jae	loc_a_0744		; Jump if above or =
		add	si,cx
		mov	bx,data_b_011C[si]
		cmp	bx,0
		jne	loc_a_0718		; Jump if not equal
		mov	di,offset data_b_0000
		call	sub_a_0756
		jmp	short loc_a_0749
		db	90h
loc_a_0718:
		cmp	bx,0Ah
		jne	loc_a_0726		; Jump if not equal
		mov	di,offset data_b_0000+1
		call	sub_a_0756
		jmp	short loc_a_0749
		db	90h
loc_a_0726:
		cmp	bx,100Ah
		jne	loc_a_0735		; Jump if not equal
		mov	di,offset data_b_0002
		call	sub_a_0756
		jmp	short loc_a_0749
		db	90h
loc_a_0735:
		cmp	bx,1000h
		jne	loc_a_0744		; Jump if not equal
		mov	di,offset data_b_0002+1
		call	sub_a_0756
		jmp	short loc_a_0749
		db	90h
loc_a_0744:
		mov	byte ptr data_b_00C9,0
loc_a_0749:
		inc	cl
		cmp	cl,6
		jne	loc_a_06EF		; Jump if not equal
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_06E2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0756	proc	near
		push	bx
		push	cx
		push	dx
		push	si
		inc	data_b_009E[di]
		mov	dl,data_b_009E[di]
		call	sub_a_1F1E
		cmp	dl,19h
		jge	loc_a_07AA		; Jump if > or =
		cmp	dl,14h
		je	loc_a_0796		; Jump if equal
		cmp	dl,0Eh
		je	loc_a_0787		; Jump if equal
		cmp	dl,8
		je	loc_a_077C		; Jump if equal
		jmp	short loc_a_07A2
		db	90h
loc_a_077C:
		mov	cx,si
		call	sub_a_3A2B
		call	sub_a_2355
		jmp	short loc_a_07A2
		db	90h
loc_a_0787:
		mov	cx,si
		call	sub_a_3A2B
		add	cx,0A1h
		call	sub_a_2789
		jmp	short loc_a_07A2
		db	90h
loc_a_0796:
		mov	cx,si
		call	sub_a_3A2B
		add	cx,0A1h
		call	sub_a_274D
loc_a_07A2:
		mov	byte ptr data_b_00C9,0
		jmp	short loc_a_07C8
		db	90h
loc_a_07AA:
		push	cx
		mov	cx,si
		call	sub_a_3A2B
		pop	cx
		mov	dx,data_b_00B3
		rol	dx,cl			; Rotate
		and	data_b_0139,dx
		call	sub_a_1F3D
		mov	byte ptr data_b_0380[si],0
		mov	byte ptr data_b_009E[di],0
loc_a_07C8:
		pop	si
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_0756	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07CD	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	di
		push	ax
		push	dx
		push	ax
		push	dx
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound

		; print spaces
		mov	bl,3
		mov	dx,104h
		mov	si,16Ch
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		; print ' GAME TIME :    Min.    Sec.    '
		mov	dx,204h
		mov	si,1B6h
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		pop	dx
		pop	ax
		add	al,30h			; '0'
		mov	data_b_01DE,al
		mov	ax,dx
		div	data_b_00BF		; al,ah rem = ax/data
		add	ah,30h			; '0'
		add	al,30h			; '0'
		mov	data_b_01DB+1,ah
		mov	data_b_01DB,al

		; print '0$'
		mov	dx,212h
		mov	si,1DEh
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		; print '00$'
		mov	dx,219h
		mov	si,1DBh
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		; text 'FROM  0 TO 19 Sec.  ..... 5000 p'
		mov	si,1E0h
		mov	cx,304h
		mov	bh,0
loc_a_0826:
		; print spaces
		push	si
		mov	dh,ch
		mov	dl,4
		mov	si,16Ch
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		pop	si

		; print 'FROM  0 TO 19 Sec.  ..... 5000 p'
		mov	dh,cl
		mov	dl,4
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		add	si,25h
		add	cx,202h
		inc	bh
		cmp	bh,6
		jne	loc_a_0826		; Jump if not equal

		; print spaces
		mov	dh,ch
		mov	dl,4
		mov	si,16Ch
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		; print spaces
		mov	dh,cl
		mov	dl,4
		mov	si,16Ch
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		call	sub_a_09CC		; Wait a while
		pop	dx
		pop	ax
		cmp	ax,1
		jge	loc_a_0899		; Jump if > or =
		cmp	dx,14h
		jge	loc_a_0872		; Jump if > or =
		mov	di,0
		jmp	short loc_a_08A2
		db	90h
loc_a_0872:
		cmp	dx,1Eh
		jge	loc_a_087D		; Jump if > or =
		mov	di,1
		jmp	short loc_a_08A2
		db	90h
loc_a_087D:
		cmp	dx,28h
		jge	loc_a_0888		; Jump if > or =
		mov	di,2
		jmp	short loc_a_08A2
		db	90h
loc_a_0888:
		cmp	dx,32h
		jge	loc_a_0893		; Jump if > or =
		mov	di,3
		jmp	short loc_a_08A2
		db	90h
loc_a_0893:
		mov	di,4
		jmp	short loc_a_08A2
			                        ;* No entry point to code
		nop
loc_a_0899:
		mov	di,offset data_b_0005
		call	sub_a_08C3
		jmp	short loc_a_08B9
		db	90h
loc_a_08A2:
		call	sub_a_08C3
		mov	byte ptr data_b_013B,6
		call	sub_a_55C7		; Play sound
		mov	bx,di
		mov	cx,data_b_0035[bx+di]
		call	sub_a_1F59
		call	sub_a_2043
loc_a_08B9:
		call	sub_a_09CC		; Wait a while
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_07CD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_08C3	proc	near
		push	bx
		push	cx
		push	si
		mov	cl,5
loc_a_08C8:
		; print spaces
		mov	dh,data_b_0023[di]
		mov	dl,4
		mov	si,16Ch
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		; print 'FROM  0 TO 19 Sec.  ..... 5000 p'
		mov	dh,data_b_0023[di]
		mov	dl,4
		mov	si,1E0h
		mov	bx,di
		add	si,data_b_0029[bx+di]
		mov	bl,1
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_09C3
		dec	cl
		jnz	loc_a_08C8		; Jump if not zero
		pop	si
		pop	cx
		pop	bx
		retn
sub_a_08C3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_08F3	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		call	sub_a_1F1E
		mov	cx,si
		call	sub_a_3A2B
		mov	dl,data_b_00B0
		call	sub_a_3D2F
		call	sub_a_09C3
		call	sub_a_3A2B
		call	sub_a_3EB4
		call	sub_a_09C3
		call	sub_a_3A2B
		call	sub_a_401D
		call	sub_a_09C3
		call	sub_a_3A2B
		call	sub_a_1F3D
		mov	byte ptr data_b_0380[si],0
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_08F3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_092D	proc	near
		push	ax
		push	bx
		cmp	byte ptr data_b_0022,0
		jne	loc_a_0953		; Jump if not equal
		mov	ax,data_b_004D
		mov	ah,data_b_013C
		add	al,ah
		mul	data_b_00C4		; ax = data * al
		cmp	ax,258h
		jb	loc_a_094B		; Jump if below
		mov	ax,258h
loc_a_094B:
		mov	bx,384h
		sub	bx,ax
loc_a_0950:
		dec	bx
		jnz	loc_a_0950		; Jump if not zero
loc_a_0953:
		pop	bx
		pop	ax
		retn
sub_a_092D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0956	proc	near
		push	ax
		push	bx
		cmp	byte ptr data_b_0022,0
		jne	loc_a_097C		; Jump if not equal
		mov	ax,data_b_004D
		mov	ah,data_b_013C
		add	al,ah
		mul	data_b_00C2		; ax = data * al
		cmp	ax,12Ch
		jb	loc_a_0974		; Jump if below
		mov	ax,12Ch
loc_a_0974:
		mov	bx,1C2h
		sub	bx,ax
loc_a_0979:
		dec	bx
		jnz	loc_a_0979		; Jump if not zero
loc_a_097C:
		pop	bx
		pop	ax
		retn
sub_a_0956	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_097F	proc	near
		push	ax
		push	bx
		mov	ax,data_b_004D
		mov	ah,data_b_013C
		add	al,ah
		mul	data_b_00C4		; ax = data * al
		cmp	ax,258h
		jb	loc_a_0996		; Jump if below
		mov	ax,258h
loc_a_0996:
		mov	bx,384h
		sub	bx,ax
loc_a_099B:
		dec	bx
		jnz	loc_a_099B		; Jump if not zero
		pop	bx
		pop	ax
		retn
sub_a_097F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09A1	proc	near
		push	ax
		push	bx
		mov	ax,data_b_004D
		mov	ah,data_b_013C
		add	al,ah
		mul	data_b_00C8		; ax = data * al
		cmp	ax,4B0h
		jb	loc_a_09B8		; Jump if below
		mov	ax,4B0h
loc_a_09B8:
		mov	bx,708h
		sub	bx,ax
loc_a_09BD:
		dec	bx
		jnz	loc_a_09BD		; Jump if not zero
		pop	bx
		pop	ax
		retn
sub_a_09A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09C3	proc	near
		push	ax
		mov	ax,1388h
loc_a_09C7:
		dec	ax
		jnz	loc_a_09C7		; Jump if not zero
		pop	ax
		retn
sub_a_09C3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait a while

sub_a_09CC	proc	near
		push	ax
		push	bx
		mov	bx,4
loc_a_09D1:
		mov	ax,0FA00h
loc_a_09D4:
		dec	ax
		jnz	loc_a_09D4		; Jump if not zero
		dec	bx
		jnz	loc_a_09D1		; Jump if not zero
		pop	bx
		pop	ax
		retn
sub_a_09CC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09DD	proc	near
		push	ax
		push	bx
		mov	bx,2
loc_a_09E2:
		mov	ax,3A98h
loc_a_09E5:
		dec	ax
		jnz	loc_a_09E5		; Jump if not zero
		dec	bx
		jnz	loc_a_09E2		; Jump if not zero
		pop	bx
		pop	ax
		retn
sub_a_09DD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09EE	proc	near
		push	di
		push	bp
		push	dx
		push	bx
		push	cx
		cmp	data_b_0042,0
		je	loc_a_0A08		; Jump if equal
		mov	cx,data_b_0044
		call	sub_a_3BBC
		mov	cx,data_b_0046
		call	sub_a_3BBC
loc_a_0A08:
		mov	bl,data_b_0380[si]
		sub	bl,0Fh
		mov	bh,0
		mov	dh,data_b_00F2[bx]
		cmp	dh,0
		je	loc_a_0A4D		; Jump if equal
		mov	byte ptr data_b_013B,2
		call	sub_a_55C7		; Play sound
		call	sub_a_0AD7
		mov	cl,bl
		dec	cl
		mov	bx,data_b_00B3
		rol	bx,cl			; Rotate
		and	data_b_0139,bx
		mov	cx,64h
		call	sub_a_1F59
		call	sub_a_2043
		mov	byte ptr data_b_0380[si],0
		pop	cx
		pop	bx
		call	sub_a_0AE1
		clc				; Clear carry flag
		sub	dx,dx
		pop	dx
		pop	bp
		pop	di
		retn
loc_a_0A4D:
		push	ax
		push	cx

		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_00AB,dx
		mov	data_b_00A9,cx
		pop	cx
		pop	ax
		mov	byte ptr data_b_013B,3
		call	sub_a_55C7		; Play sound
		call	sub_a_09DD
		call	sub_a_09DD
		call	sub_a_0AD7
		pop	cx
		pop	bx
		call	sub_a_0B0C
		dec	data_b_0138
		cmp	byte ptr data_b_0138,0
		jne	loc_a_0A81		; Jump if not equal
		jmp	short loc_a_0ACF
		db	90h
loc_a_0A81:
		push	bx
		push	cx
		mov	byte ptr data_b_00D4,1
		mov	byte ptr data_b_0380[si],0
		call	sub_a_09CC		; Wait a while
		call	sub_a_0266
		pop	cx
		pop	bx
		call	sub_a_3A2B
		call	sub_a_0B58
		mov	bx,805h
loc_a_0A9E:
		call	sub_a_1F3D
		cmp	byte ptr data_b_0380[si],3
		jne	loc_a_0AAC		; Jump if not equal
		dec	bh
		jmp	short loc_a_0A9E
loc_a_0AAC:
		mov	byte ptr data_b_0380[si],0
		call	sub_a_1F1E
		mov	cx,si
		call	sub_a_2F87
		mov	byte ptr data_b_0103,0
		mov	data_b_0101,0
		mov	byte ptr data_b_0104,0
		xor	di,di			; Zero register
		clc				; Clear carry flag
		jmp	short loc_a_0AD0
		db	90h
loc_a_0ACF:
		stc				; Set carry flag
loc_a_0AD0:
		call	sub_a_09CC		; Wait a while
		pop	dx
		pop	bp
		pop	di
		retn
sub_a_09EE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0AD7	proc	near
		mov	di,bx
		mov	cx,data_b_0128[bx+di]
		call	sub_a_3A2B
		retn
sub_a_0AD7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0AE1	proc	near
		push	dx
		mov	dl,data_b_00D6
		cmp	dl,1
		jne	loc_a_0AF1		; Jump if not equal
		call	sub_a_2F87
		jmp	short loc_a_0B0A
		db	90h
loc_a_0AF1:
		cmp	dl,2
		jne	loc_a_0AFC		; Jump if not equal
		call	sub_a_2FAB
		jmp	short loc_a_0B0A
		db	90h
loc_a_0AFC:
		cmp	dl,4
		jne	loc_a_0B07		; Jump if not equal
		call	sub_a_2B2A
		jmp	short loc_a_0B0A
		db	90h
loc_a_0B07:
		call	sub_a_2B0A
loc_a_0B0A:
		pop	dx
		retn
sub_a_0AE1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0B0C	proc	near
		push	ax
		push	dx
		push	cx
		push	bx
		push	si
		push	bp
		call	sub_a_3A2B
		mov	dl,1
		call	sub_a_2896
		mov	bx,0
		mov	si,0
loc_a_0B20:
		inc	si
		cmp	si,10h
		jge	loc_a_0B49		; Jump if > or =
		mov	ax,si
		and	ax,1
		cmp	ax,1
		jne	loc_a_0B35		; Jump if not equal
		mov	dl,0
		jmp	short loc_a_0B37
		db	90h
loc_a_0B35:
		mov	dl,1
loc_a_0B37:
		call	sub_a_2896
		mov	bp,data_b_0002[bx]
		call	sub_a_1F4E		; Set speaker frequency
		add	bx,2
		call	sub_a_09DD
		jmp	short loc_a_0B20
loc_a_0B49:
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound
		pop	bp
		pop	si
		pop	bx
		pop	cx
		pop	dx
		pop	ax
		retn
sub_a_0B0C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0B58	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	bp
		push	si
		mov	cx,0
loc_a_0B61:
		mov	dx,data_b_0139
		ror	dx,cl			; Rotate
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
		jz	loc_a_0BC7		; Jump if zero
		mov	bx,cx
		mov	ax,cx
		mov	dh,cl
		add	dh,10h
		push	cx
		push	bx
		mul	data_b_00B5		; ax = data * al
		mov	bp,ax
		mov	bx,ds:data_b_011C[bp]
		call	sub_a_1F3D
		mov	cx,ds:data_b_012A[bp]
		call	sub_a_3A2B
		cmp	bh,8
		jg	loc_a_0BA5		; Jump if >
		cmp	bh,6
		jl	loc_a_0BB4		; Jump if <
		mov	bh,0
		mov	byte ptr data_b_0380[si],0
		call	sub_a_0BD5
		jmp	short loc_a_0BB4
		db	90h
loc_a_0BA5:
		cmp	bh,0Bh
		jg	loc_a_0BB4		; Jump if >
		mov	bh,10h
		mov	byte ptr data_b_0380[si],0
		call	sub_a_0BD5
loc_a_0BB4:
		pop	bx
		mov	al,data_b_00F3[bx]
		cmp	al,1
		jae	loc_a_0BC3		; Jump if above or =
		call	sub_a_2550
		jmp	short loc_a_0BC6
		db	90h
loc_a_0BC3:
		call	sub_a_45BA
loc_a_0BC6:
		pop	cx
loc_a_0BC7:
		inc	cl
		cmp	cl,6
		jne	loc_a_0B61		; Jump if not equal
		pop	si
		pop	bp
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0B58	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0BD5	proc	near
loc_a_0BD5:
		call	sub_a_1F3D
		cmp	byte ptr data_b_0380[si],3
		jae	loc_a_0BF5		; Jump if above or =
		mov	data_b_0380[si],dh
		mov	ds:data_b_011C[bp],bx
		call	sub_a_1F1E
		mov	ds:data_b_012A[bp],si
		mov	cx,si
		jmp	short loc_ret_a_0C02
		db	90h
loc_a_0BF5:
		cmp	bh,8
		jae	loc_a_0BFE		; Jump if above or =
		inc	bh
		jmp	short loc_a_0BD5
loc_a_0BFE:
		dec	bh
		jmp	short loc_a_0BD5

loc_ret_a_0C02:
		retn
sub_a_0BD5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0C03	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	bp
		mov	cx,0
loc_a_0C0B:
		mov	dx,data_b_0139
		ror	dx,cl			; Rotate
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
		jz	loc_a_0C39		; Jump if zero
		mov	bx,cx
		mov	ax,cx
		push	cx
		mul	data_b_00B5		; ax = data * al
		mov	bp,ax
		mov	cx,ds:data_b_012A[bp]
		mov	al,data_b_00F3[bx]
		cmp	al,1
		jae	loc_a_0C35		; Jump if above or =
		call	sub_a_2550
		jmp	short loc_a_0C38
		db	90h
loc_a_0C35:
		call	sub_a_45BA
loc_a_0C38:
		pop	cx
loc_a_0C39:
		inc	cl
		cmp	cl,6
		jne	loc_a_0C0B		; Jump if not equal
		pop	bp
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0C03	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0C46	proc	near
		mov	byte ptr data_b_00D6,1
		mov	byte ptr data_b_00D5,1
		call	sub_a_2F87
		call	sub_a_1F3D
		cmp	bh,10h
		je	loc_a_0CAD		; Jump if equal
		mov	byte ptr data_b_0103,0
		inc	si
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_0C95		; Jump if equal
		cmp	dh,3
		je	loc_a_0C9E		; Jump if equal
		mov	data_b_0101,0
		mov	dh,data_b_00D2
loc_a_0C79:
		call	sub_a_3A2B
		inc	cx
		call	sub_a_2F87
		call	sub_a_11B0
		dec	dh
		jnz	loc_a_0C79		; Jump if not zero
		call	sub_a_0484
		jz	loc_ret_a_0CBF		; Jump if zero
		inc	bh
		mov	data_b_0136,bx
		jmp	short loc_a_0CBE
		db	90h
loc_a_0C95:
		mov	data_b_0101,1
		jmp	short loc_a_0CA4
		db	90h
loc_a_0C9E:
		mov	data_b_0101,8000h
loc_a_0CA4:
		call	sub_a_09A1
		call	sub_a_11B0
		jmp	short loc_a_0CBE
		db	90h
loc_a_0CAD:
		mov	byte ptr data_b_0103,1
		mov	data_b_0101,0
		call	sub_a_09A1
		call	sub_a_11B0
loc_a_0CBE:
		clc				; Clear carry flag

loc_ret_a_0CBF:
		retn
sub_a_0C46	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0CC0	proc	near
		mov	byte ptr data_b_00D6,2
		mov	byte ptr data_b_00D5,2
		call	sub_a_2FAB
		call	sub_a_1F3D
		cmp	bh,0
		je	loc_a_0D27		; Jump if equal
		mov	byte ptr data_b_0103,0
		dec	si
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_0D0F		; Jump if equal
		cmp	dh,3
		je	loc_a_0D18		; Jump if equal
		mov	data_b_0101,0
		mov	dh,data_b_00D2
loc_a_0CF3:
		call	sub_a_3A2B
		dec	cx
		call	sub_a_2FAB
		call	sub_a_11B0
		dec	dh
		jnz	loc_a_0CF3		; Jump if not zero
		call	sub_a_0484
		jz	loc_ret_a_0D39		; Jump if zero
		dec	bh
		mov	data_b_0136,bx
		jmp	short loc_a_0D38
		db	90h
loc_a_0D0F:
		mov	data_b_0101,1
		jmp	short loc_a_0D1E
		db	90h
loc_a_0D18:
		mov	data_b_0101,8000h
loc_a_0D1E:
		call	sub_a_09A1
		call	sub_a_11B0
		jmp	short loc_a_0D38
		db	90h
loc_a_0D27:
		mov	byte ptr data_b_0103,2
		mov	data_b_0101,0
		call	sub_a_09A1
		call	sub_a_11B0
loc_a_0D38:
		clc				; Clear carry flag

loc_ret_a_0D39:
		retn
sub_a_0CC0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0D3A	proc	near
		mov	byte ptr data_b_00D6,8
		mov	byte ptr data_b_00D5,8
		call	sub_a_2B0A
		call	sub_a_1F3D
		cmp	bl,0
		je	loc_a_0DA5		; Jump if equal
		mov	byte ptr data_b_0103,0
		sub	si,11h
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_0D8D		; Jump if equal
		cmp	dh,3
		je	loc_a_0D96		; Jump if equal
		mov	data_b_0101,0
		mov	dh,data_b_00D3
loc_a_0D6F:
		call	sub_a_3A2B
		sub	cx,50h
		call	sub_a_2B0A
		call	sub_a_11B0
		dec	dh
		jnz	loc_a_0D6F		; Jump if not zero
		call	sub_a_0484
		jz	loc_ret_a_0DB7		; Jump if zero
		dec	bl
		mov	data_b_0136,bx
		jmp	short loc_a_0DB6
		db	90h
loc_a_0D8D:
		mov	data_b_0101,1
		jmp	short loc_a_0D9C
		db	90h
loc_a_0D96:
		mov	data_b_0101,8000h
loc_a_0D9C:
		call	sub_a_097F
		call	sub_a_11B0
		jmp	short loc_a_0DB6
		db	90h
loc_a_0DA5:
		mov	byte ptr data_b_0103,8
		mov	data_b_0101,0
		call	sub_a_097F
		call	sub_a_11B0
loc_a_0DB6:
		clc				; Clear carry flag

loc_ret_a_0DB7:
		retn
sub_a_0D3A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0DB8	proc	near
		mov	byte ptr data_b_00D6,4
		mov	byte ptr data_b_00D5,4
		call	sub_a_2B2A
		call	sub_a_1F3D
		cmp	bl,0Ah
		je	loc_a_0E23		; Jump if equal
		mov	byte ptr data_b_0103,0
		add	si,11h
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_0E0B		; Jump if equal
		cmp	dh,3
		je	loc_a_0E14		; Jump if equal
		mov	data_b_0101,0
		mov	dh,data_b_00D3
loc_a_0DED:
		call	sub_a_3A2B
		add	cx,50h
		call	sub_a_2B2A
		call	sub_a_11B0
		dec	dh
		jnz	loc_a_0DED		; Jump if not zero
		call	sub_a_0484
		jz	loc_ret_a_0E35		; Jump if zero
		inc	bl
		mov	data_b_0136,bx
		jmp	short loc_a_0E34
		db	90h
loc_a_0E0B:
		mov	data_b_0101,1
		jmp	short loc_a_0E1A
		db	90h
loc_a_0E14:
		mov	data_b_0101,8000h
loc_a_0E1A:
		call	sub_a_097F
		call	sub_a_11B0
		jmp	short loc_a_0E34
		db	90h
loc_a_0E23:
		mov	byte ptr data_b_0103,4
		mov	data_b_0101,0
		call	sub_a_097F
		call	sub_a_11B0
loc_a_0E34:
		clc				; Clear carry flag

loc_ret_a_0E35:
		retn
sub_a_0DB8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0E36	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	dx,data_b_0101
		cmp	dx,0
		je	loc_a_0E96		; Jump if equal
		mov	dh,data_b_00D6
		cmp	dh,1
		jne	loc_a_0E5C		; Jump if not equal
		call	sub_a_375B
		inc	bh
		mov	di,bx
		call	sub_a_17DA
		call	sub_a_1A39
		jmp	short loc_a_0EA2
		db	90h
loc_a_0E5C:
		cmp	dh,2
		jne	loc_a_0E71		; Jump if not equal
		call	sub_a_38C4
		dec	bh
		mov	di,bx
		call	sub_a_1803
		call	sub_a_1AB3
		jmp	short loc_a_0EA2
		db	90h
loc_a_0E71:
		cmp	dh,4
		jne	loc_a_0E86		; Jump if not equal
		call	sub_a_35F2
		inc	bl
		mov	di,bx
		call	sub_a_184F
		call	sub_a_1BB0
		jmp	short loc_a_0EA2
		db	90h
loc_a_0E86:
		call	sub_a_348D
		dec	bl
		mov	di,bx
		call	sub_a_1828
		call	sub_a_1B2D
		jmp	short loc_a_0EA2
		db	90h
loc_a_0E96:
		mov	dh,data_b_0103
		cmp	dh,0
		je	loc_a_0EA2		; Jump if equal
		call	sub_a_0EB3
loc_a_0EA2:
		mov	data_b_0101,0
		mov	bp,20h
		call	sub_a_1F4E		; Set speaker frequency
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0E36	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0EB3	proc	near
		push	cx
		push	dx
		push	bp
		mov	bp,2000h
		call	sub_a_1F4E		; Set speaker frequency
		mov	dh,data_b_0103
		cmp	dh,1
		jg	loc_a_0ED6		; Jump if >
		call	sub_a_375B
		call	sub_a_43BE
		mov	byte ptr data_b_0104,1
		call	sub_a_0F1A
		jmp	short loc_a_0F10
		db	90h
loc_a_0ED6:
		cmp	dh,2
		jg	loc_a_0EEC		; Jump if >
		call	sub_a_38C4
		call	sub_a_44BC
		mov	byte ptr data_b_0104,2
		call	sub_a_0F1A
		jmp	short loc_a_0F10
		db	90h
loc_a_0EEC:
		cmp	dh,4
		jg	loc_a_0F02		; Jump if >
		call	sub_a_35F2
		call	sub_a_40EA
		mov	byte ptr data_b_0104,4
		call	sub_a_0F1A
		jmp	short loc_a_0F10
		db	90h
loc_a_0F02:
		call	sub_a_348D
		call	sub_a_4254
		mov	byte ptr data_b_0104,8
		call	sub_a_0F1A
loc_a_0F10:
		mov	bp,20h
		call	sub_a_1F4E		; Set speaker frequency
		pop	bp
		pop	dx
		pop	cx
		retn
sub_a_0EB3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F1A	proc	near
		call	sub_a_11B0
		call	sub_a_09C3
		mov	bp,2500h
		call	sub_a_1F4E		; Set speaker frequency
		call	sub_a_11B0
		mov	bp,2000h
		call	sub_a_1F4E		; Set speaker frequency
		call	sub_a_408B
		retn
sub_a_0F1A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F33	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		mov	bl,data_b_00A0
		mov	bh,0
		mov	si,0
		mov	cx,1D64h
loc_a_0F44:
		cmp	si,bx
		jb	loc_a_0F4E		; Jump if below
		call	sub_a_284B
		jmp	short loc_a_0F51
		db	90h
loc_a_0F4E:
		call	sub_a_2789
loc_a_0F51:
		sub	cx,190h
		inc	si
		cmp	si,0Ch
		jne	loc_a_0F44		; Jump if not equal
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0F33	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F61	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		mov	bl,data_b_00A0
		mov	bh,0
		mov	ax,bx
		sub	bl,dh
		mov	si,0
		mov	cx,1D64h
loc_a_0F76:
		cmp	si,ax
		jb	loc_a_0F80		; Jump if below
		call	sub_a_284B
		jmp	short loc_a_0F8D
		db	90h
loc_a_0F80:
		cmp	si,bx
		jge	loc_a_0F8A		; Jump if > or =
		call	sub_a_2789
		jmp	short loc_a_0F8D
		db	90h
loc_a_0F8A:
		call	sub_a_27E6
loc_a_0F8D:
		sub	cx,190h
		inc	si
		cmp	si,0Ch
		jne	loc_a_0F76		; Jump if not equal
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_0F61	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F9D	proc	near
		push	ax
		push	cx
		push	dx
		push	di
		push	si
		push	cx
		mov	di,0
loc_a_0FA6:
		inc	di
		cmp	di,1Eh
		ja	loc_a_0FCD		; Jump if above

		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		and	dl,0Fh
		mov	bh,dl
		and	dh,7
		add	dh,1
		mov	bl,dh
		call	sub_a_1F3D
		mov	dl,data_b_0380[si]
		cmp	dl,1
		jne	loc_a_0FA6		; Jump if not equal
		pop	cx
		jmp	short loc_a_1003
		db	90h
loc_a_0FCD:
		pop	cx
loc_a_0FCE:
		and	cl,3
		cmp	cl,0
		jne	loc_a_0FDC		; Jump if not equal
		mov	bx,1000h
		jmp	short loc_a_0FF5
		db	90h
loc_a_0FDC:
		cmp	cl,1
		jne	loc_a_0FE7		; Jump if not equal
		mov	bx,0Ah
		jmp	short loc_a_0FF5
		db	90h
loc_a_0FE7:
		cmp	cl,2
		jne	loc_a_0FF2		; Jump if not equal
		mov	bx,100Ah
		jmp	short loc_a_0FF5
		db	90h
loc_a_0FF2:
		mov	bx,0
loc_a_0FF5:
		call	sub_a_1F3D
		cmp	byte ptr data_b_0380[si],3
		jne	loc_a_1003		; Jump if not equal
		inc	cl
		jmp	short loc_a_0FCE
loc_a_1003:
		mov	data_b_00A1,bx
		pop	si
		pop	di
		pop	dx
		pop	cx
		pop	ax
		retn
sub_a_0F9D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_100D	proc	near
		push	ax
		mov	bp,8A1h
		mov	ax,data_b_00A3
		sub	ax,46h
		mul	data_b_00BF		; ax = data * al
		sub	bp,ax
		pop	ax
		retn
sub_a_100D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_101F	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		mov	bx,data_b_004D
		mov	dh,data_b_004F[bx]
		mov	cx,0
loc_a_1030:
		mov	bx,data_b_00B6
		rol	bx,cl			; Rotate
		mov	ax,bx
		and	bx,data_b_0139
		cmp	bx,0
		je	loc_a_104E		; Jump if equal
		inc	cl
		cmp	cl,dh
		jne	loc_a_1030		; Jump if not equal
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
loc_a_104E:
		inc	data_b_00A3
		cmp	data_b_00A3,3Ch
		jne	loc_a_107B		; Jump if not equal
		mov	dh,1
		call	sub_a_0F61
		call	sub_a_0F9D
		call	sub_a_1F3D
		push	cx
		mov	cl,0Fh
		mov	data_b_0380[si],cl
		call	sub_a_1F1E
		mov	cx,si
		add	cx,0A1h
		call	sub_a_274D
		pop	cx
		jmp	short loc_a_10AC
		db	90h
loc_a_107B:
		cmp	data_b_00A3,4Bh
		jne	loc_a_1097		; Jump if not equal
		mov	bx,data_b_00A1
		call	sub_a_1F1E
		push	cx
		mov	cx,si
		add	cx,0A1h
		call	sub_a_2789
		pop	cx
		jmp	short loc_a_10AC
		db	90h
loc_a_1097:
		cmp	data_b_00A3,5Ah
		jne	loc_a_10AC		; Jump if not equal
		mov	bx,data_b_00A1
		call	sub_a_1F1E
		push	cx
		mov	cx,si
		call	sub_a_2355
		pop	cx
loc_a_10AC:
		cmp	data_b_00A3,3Ch
		jl	loc_a_10CF		; Jump if <
		call	sub_a_100D
		call	sub_a_1F4E		; Set speaker frequency
		cmp	data_b_00A3,64h
		jl	loc_a_10CF		; Jump if <
		call	sub_a_10D6
		mov	bp,20h
		call	sub_a_1F4E		; Set speaker frequency
		mov	data_b_00A3,0
loc_a_10CF:
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_101F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_10D6	proc	near
		or	data_b_0139,ax
		mov	bp,cx
		mov	byte ptr ds:data_b_00F3[bp],0
		mov	byte ptr ds:data_b_00EC[bp],0
		add	bp,cx
		mov	bx,data_b_00A1
		call	sub_a_1F3D
		add	cx,10h
		mov	data_b_0380[si],cl
		call	sub_a_1F1E
		mov	ds:data_b_012A[bp],si
		mov	cx,si
		call	sub_a_2550
		mov	ds:data_b_011C[bp],bx
		sub	byte ptr data_b_00A0,1
		call	sub_a_0F33
		retn
sub_a_10D6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1113	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	di
		mov	ch,0
		inc	cl
		mov	bx,cx
		mov	di,cx
		add	di,bx
		mov	al,data_b_00E4[bx]
		mov	data_b_00E4,al
		mov	ax,data_b_011A[di]
		mov	data_b_011A,ax
		mov	ax,data_b_0128[di]
		mov	data_b_0128,ax
		mov	al,data_b_00F2[bx]
		mov	data_b_00F2,al
		mov	al,data_b_00EB[bx]
		mov	data_b_00EB,al
		mov	al,data_b_00F9[bx]
		mov	data_b_00F9,al
		mov	ax,data_b_010C[di]
		mov	data_b_010C,ax
		mov	al,data_b_0105[bx]
		mov	data_b_0105,al
		mov	al,data_b_00D7[bx]
		mov	data_b_00D7,al
		add	cl,0Fh
		mov	data_b_006A,cl
		call	sub_a_1249
		mov	al,data_b_00E4
		mov	data_b_00E4[bx],al
		mov	ax,data_b_011A
		mov	data_b_011A[di],ax
		mov	ax,data_b_0128
		mov	data_b_0128[di],ax
		mov	al,data_b_00F2
		mov	data_b_00F2[bx],al
		mov	al,data_b_00EB
		mov	data_b_00EB[bx],al
		mov	al,data_b_00F9
		mov	data_b_00F9[bx],al
		mov	ax,data_b_010C
		mov	data_b_010C[di],ax
		mov	al,data_b_0105
		mov	data_b_0105[bx],al
		mov	al,data_b_00D7
		mov	data_b_00D7[bx],al
		pop	di
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1113	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_11B0	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		cmp	byte ptr data_b_00A0,0
		je	loc_a_11C5		; Jump if equal
		cmp	byte ptr data_b_013B,5
		je	loc_a_11C5		; Jump if equal
		call	sub_a_101F
loc_a_11C5:
		mov	cl,0
loc_a_11C7:
		mov	bl,cl
		mov	bh,0
		mov	dl,data_b_00EC[bx]
		cmp	dl,2
		je	loc_a_11E3		; Jump if equal
		mov	bx,data_b_00B6
		rol	bx,cl			; Rotate
		and	bx,data_b_0139
		cmp	bx,0
		je	loc_a_11E9		; Jump if equal
loc_a_11E3:
		call	sub_a_1113
		jmp	short loc_a_11EF
		db	90h
loc_a_11E9:
		call	sub_a_0956
		call	sub_a_097F
loc_a_11EF:
		cmp	byte ptr data_b_0022,0
		je	loc_a_1204		; Jump if equal
		cmp	byte ptr data_b_0022,0Ch
		jae	loc_a_1204		; Jump if above or =
		inc	data_b_0022
		jmp	short loc_a_1209
		db	90h
loc_a_1204:
		mov	byte ptr data_b_0022,0
loc_a_1209:
		inc	cl
		cmp	cl,6
		jne	loc_a_11C7		; Jump if not equal
		inc	data_b_0000
		mov	byte ptr data_b_0104,0
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_11B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_121E	proc	near
		push	dx
		mov	dh,data_b_00E4
		cmp	dh,1
		jne	loc_a_122E		; Jump if not equal
		call	sub_a_158E
		jmp	short loc_a_1247
		db	90h
loc_a_122E:
		cmp	dh,2
		jne	loc_a_1239		; Jump if not equal
		call	sub_a_1620
		jmp	short loc_a_1247
		db	90h
loc_a_1239:
		cmp	dh,8
		jne	loc_a_1244		; Jump if not equal
		call	sub_a_16B2
		jmp	short loc_a_1247
		db	90h
loc_a_1244:
		call	sub_a_1746
loc_a_1247:
		pop	dx
		retn
sub_a_121E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1249	proc	near
		push	dx
		push	cx
		push	ax
		push	bp
loc_a_124D:
		call	sub_a_1522
		mov	dh,data_b_0100
		cmp	dh,1
		je	loc_a_1274		; Jump if equal
		mov	dh,data_b_0104
		cmp	dh,0
		je	loc_a_1265		; Jump if equal
		call	sub_a_12AC
loc_a_1265:
		call	sub_a_121E
		mov	dh,data_b_00EB
		cmp	dh,0
		jne	loc_a_124D		; Jump if not equal
		jmp	short loc_a_12A2
		db	90h
loc_a_1274:
		mov	dh,data_b_00EB
		cmp	dh,0
		jne	loc_a_129F		; Jump if not equal
		mov	dh,data_b_00F2
		cmp	dh,0
		je	loc_a_1291		; Jump if equal
		cmp	dh,8Ch
		jae	loc_a_1291		; Jump if above or =
		call	sub_a_12EC
		jmp	short loc_a_129F
		db	90h
loc_a_1291:
		mov	byte ptr data_b_00F2,0
		call	sub_a_133C
		call	sub_a_121E
		jmp	short loc_a_12A2
		db	90h
loc_a_129F:
		call	sub_a_0956
loc_a_12A2:
		mov	byte ptr data_b_00EB,0
		pop	bp
		pop	ax
		pop	cx
		pop	dx
		retn
sub_a_1249	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_12AC	proc	near
		push	dx
		push	bx
		mov	bx,data_b_011A
		mov	dh,data_b_0104
		cmp	dh,1
		jne	loc_a_12C3		; Jump if not equal
		cmp	bh,10h
		je	loc_a_12E2		; Jump if equal
		jmp	short loc_a_12E9
		db	90h
loc_a_12C3:
		cmp	dh,2
		jne	loc_a_12D0		; Jump if not equal
		cmp	bh,0
		je	loc_a_12E2		; Jump if equal
		jmp	short loc_a_12E9
		db	90h
loc_a_12D0:
		cmp	dh,4
		jne	loc_a_12DD		; Jump if not equal
		cmp	bl,0Ah
		je	loc_a_12E2		; Jump if equal
		jmp	short loc_a_12E9
		db	90h
loc_a_12DD:
		cmp	bl,0
		jne	loc_a_12E9		; Jump if not equal
loc_a_12E2:
		mov	bh,1
		mov	byte ptr data_b_00F2,1
loc_a_12E9:
		pop	bx
		pop	dx
		retn
sub_a_12AC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_12EC	proc	near
		push	cx
		push	bx
		call	sub_a_55C7		; Play sound
		mov	bx,data_b_011A
		call	sub_a_1F3D
		mov	cl,0
		cmp	data_b_0380[si],cl
		je	loc_a_1335		; Jump if equal
		mov	cx,data_b_0128
		call	sub_a_3A2B
		mov	bl,data_b_00F2
		cmp	bl,78h			; 'x'
		jae	loc_a_1324		; Jump if above or =
		and	bl,4
		cmp	bl,4
		je	loc_a_131E		; Jump if equal
		call	sub_a_45BA
		jmp	short loc_a_1335
		db	90h
loc_a_131E:
		call	sub_a_4839
		jmp	short loc_a_1335
		db	90h
loc_a_1324:
		and	bl,4
		cmp	bl,4
		je	loc_a_1332		; Jump if equal
		call	sub_a_45CE
		jmp	short loc_a_1335
		db	90h
loc_a_1332:
		call	sub_a_45E2
loc_a_1335:
		inc	data_b_00F2
		pop	bx
		pop	cx
		retn
sub_a_12EC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_133C	proc	near
		push	ax
		push	bx
		push	cx
		mov	bl,data_b_00F9
		cmp	bl,1
		jne	loc_a_1362		; Jump if not equal
		mov	al,data_b_013B
		cmp	al,5
		jne	loc_a_135D		; Jump if not equal
		mov	ax,data_b_011A
		cmp	ax,0
		je	loc_a_1381		; Jump if equal
		call	sub_a_1458
		jmp	short loc_a_1389
		db	90h
loc_a_135D:
		call	sub_a_1436
		jz	loc_a_1389		; Jump if zero
loc_a_1362:
		mov	al,data_b_0105
		cmp	al,0
		jne	loc_a_137B		; Jump if not equal
		mov	ax,data_b_010C
		cmp	ax,0
		je	loc_a_1381		; Jump if equal
		and	ax,8000h
		cmp	ax,8000h
		je	loc_a_137B		; Jump if equal
		nop
		nop
loc_a_137B:
		call	sub_a_13D7
		jmp	short loc_a_1389
		db	90h
loc_a_1381:
		mov	byte ptr data_b_00D7,0
		call	sub_a_0956
loc_a_1389:
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_133C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_138D	proc	near
		push	cx
		push	dx
		mov	cx,data_b_011A
		mov	dx,data_b_0136
		cmp	ch,dh
		jne	loc_a_13A1		; Jump if not equal
		call	sub_a_13B5
		jmp	short loc_a_13B2
		db	90h
loc_a_13A1:
		cmp	ch,dh
		ja	loc_a_13AD		; Jump if above
		mov	byte ptr data_b_00E4,1
		jmp	short loc_a_13B2
		db	90h
loc_a_13AD:
		mov	byte ptr data_b_00E4,2
loc_a_13B2:
		pop	dx
		pop	cx
		retn
sub_a_138D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_13B5	proc	near
		push	cx
		push	dx
		mov	cx,data_b_011A
		mov	dx,data_b_0136
		cmp	cl,dl
		je	loc_a_13D4		; Jump if equal
		cmp	cl,dl
		ja	loc_a_13CF		; Jump if above
		mov	byte ptr data_b_00E4,4
		jmp	short loc_a_13D4
		db	90h
loc_a_13CF:
		mov	byte ptr data_b_00E4,8
loc_a_13D4:
		pop	dx
		pop	cx
		retn
sub_a_13B5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_13D7	proc	near
		push	ax
		push	dx
		cmp	byte ptr data_b_00D7,0
		jne	loc_a_13EA		; Jump if not equal
		call	sub_a_138D
		inc	data_b_00D7
		jmp	short loc_a_1433
		db	90h
loc_a_13EA:
		cmp	byte ptr data_b_00D7,1
		ja	loc_a_13FB		; Jump if above
		call	sub_a_13B5
		inc	data_b_00D7
		jmp	short loc_a_1433
		db	90h
loc_a_13FB:
		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		and	dl,3
		cmp	dl,3
		jne	loc_a_140F		; Jump if not equal
		mov	byte ptr data_b_00E4,1
		jmp	short loc_a_142E
		db	90h
loc_a_140F:
		cmp	dl,2
		jne	loc_a_141C		; Jump if not equal
		mov	byte ptr data_b_00E4,2
		jmp	short loc_a_142E
		db	90h
loc_a_141C:
		cmp	dl,1
		jne	loc_a_1429		; Jump if not equal
		mov	byte ptr data_b_00E4,8
		jmp	short loc_a_142E
		db	90h
loc_a_1429:
		mov	byte ptr data_b_00E4,4
loc_a_142E:
		mov	byte ptr data_b_00D7,0
loc_a_1433:
		pop	dx
		pop	ax
		retn
sub_a_13D7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1436	proc	near
		push	bx
		push	cx
		push	dx
		mov	bl,data_b_006A
		and	bl,3
		mov	cl,6
		mov	dx,data_b_0000
		shr	dx,cl			; Shift w/zeros fill
		and	dl,3
		cmp	dl,bl
		jne	loc_a_1454		; Jump if not equal
		call	sub_a_138D
		sub	cx,cx
loc_a_1454:
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_1436	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1458	proc	near
		push	bx
		push	ax
		mov	bl,data_b_006A
		sub	bl,10h
		mov	bh,0
		mov	ax,data_b_010C
		and	ax,8000h
		cmp	ax,8000h
		jne	loc_a_1478		; Jump if not equal
		inc	data_b_00DE[bx]
		call	sub_a_13D7
		jmp	short loc_a_14A7
		db	90h
loc_a_1478:
		and	byte ptr data_b_00DE[bx],3
		cmp	byte ptr data_b_00DE[bx],0
		jne	loc_a_148A		; Jump if not equal
		call	sub_a_14AA
		jmp	short loc_a_14A7
		db	90h
loc_a_148A:
		cmp	byte ptr data_b_00DE[bx],1
		jne	loc_a_1497		; Jump if not equal
		call	sub_a_14E6
		jmp	short loc_a_14A7
		db	90h
loc_a_1497:
		cmp	byte ptr data_b_00DE[bx],2
		jne	loc_a_14A4		; Jump if not equal
		call	sub_a_1504
		jmp	short loc_a_14A7
		db	90h
loc_a_14A4:
		call	sub_a_14C8
loc_a_14A7:
		pop	ax
		pop	bx
		retn
sub_a_1458	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_14AA	proc	near
		push	bx
		mov	bx,data_b_011A
		cmp	bh,0
		je	loc_a_14BC		; Jump if equal
		mov	byte ptr data_b_00E4,2
		jmp	short loc_a_14C6
		db	90h
loc_a_14BC:
		cmp	bl,0
		je	loc_a_14C6		; Jump if equal
		mov	byte ptr data_b_00E4,8
loc_a_14C6:
		pop	bx
		retn
sub_a_14AA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_14C8	proc	near
		push	bx
		mov	bx,data_b_011A
		cmp	bl,0Ah
		je	loc_a_14DA		; Jump if equal
		mov	byte ptr data_b_00E4,4
		jmp	short loc_a_14E4
		db	90h
loc_a_14DA:
		cmp	bh,10h
		je	loc_a_14E4		; Jump if equal
		mov	byte ptr data_b_00E4,1
loc_a_14E4:
		pop	bx
		retn
sub_a_14C8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_14E6	proc	near
		push	bx
		mov	bx,data_b_011A
		cmp	bl,0
		je	loc_a_14F8		; Jump if equal
		mov	byte ptr data_b_00E4,8
		jmp	short loc_a_1502
		db	90h
loc_a_14F8:
		cmp	bh,0
		je	loc_a_1502		; Jump if equal
		mov	byte ptr data_b_00E4,1
loc_a_1502:
		pop	bx
		retn
sub_a_14E6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1504	proc	near
		push	bx
		mov	bx,data_b_011A
		cmp	bh,0
		je	loc_a_1516		; Jump if equal
		mov	byte ptr data_b_00E4,2
		jmp	short loc_a_1520
		db	90h
loc_a_1516:
		cmp	bl,0Ah
		je	loc_a_1520		; Jump if equal
		mov	byte ptr data_b_00E4,4
loc_a_1520:
		pop	bx
		retn
sub_a_1504	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1522	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	ax,data_b_0128
		sub	ax,28Ah
		cwd				; Word to double word
		div	data_b_00BB		; ax,dxrem=dx:ax/data
		cmp	dx,0
		jne	loc_a_1551		; Jump if not equal
		mov	bx,data_b_011A
		mov	bl,bh
		mov	bh,0
		sub	ax,bx
		div	data_b_00C6		; al,ah rem = ax/data
		cmp	ah,0
		jne	loc_a_1551		; Jump if not equal
		mov	byte ptr data_b_0100,1
		jmp	short loc_a_1556
		db	90h
loc_a_1551:
		mov	byte ptr data_b_0100,0
loc_a_1556:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1522	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_155B	proc	near
		inc	data_b_010C
		mov	dx,data_b_010C
		mov	dh,data_b_00F9
		cmp	dh,0
		jne	loc_a_1574		; Jump if not equal
		cmp	dl,0Ch
		jbe	loc_a_158A		; Jump if below or =
		jmp	short loc_a_1579
		db	90h
loc_a_1574:
		cmp	dl,2
		jbe	loc_a_158A		; Jump if below or =
loc_a_1579:
		call	sub_a_08F3
		mov	data_b_010C,0
		mov	byte ptr data_b_0022,1
		jmp	short loc_ret_a_158D
		db	90h
loc_a_158A:
		call	sub_a_0956

loc_ret_a_158D:
		retn
sub_a_155B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_158E	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		call	sub_a_55C7		; Play sound
		mov	byte ptr data_b_00E4,1
		call	sub_a_1522
		mov	dh,data_b_0100
		cmp	dh,1
		jne	loc_a_15E9		; Jump if not equal
		mov	bx,data_b_011A
		cmp	bh,10h
		je	loc_a_160B		; Jump if equal
		mov	byte ptr data_b_0105,0
		inc	bh
		call	sub_a_1F3D
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_15CC		; Jump if equal
		cmp	dh,3
		jge	loc_a_1602		; Jump if > or =
		jmp	short loc_a_15D2
		db	90h
loc_a_15CC:
		call	sub_a_155B
		jmp	short loc_a_1619
		db	90h
loc_a_15D2:
		mov	data_b_010C,0
		mov	data_b_011A,bx
		mov	dh,data_b_006A
		mov	data_b_0380[si],dh
		mov	byte ptr data_b_037F[si],0
loc_a_15E9:
		mov	cx,data_b_0128
		call	sub_a_3A2B
		inc	cx
		mov	data_b_0128,cx
		mov	dl,data_b_00AF
		call	sub_a_2550
		call	sub_a_092D
		jmp	short loc_a_1619
		db	90h
loc_a_1602:
		mov	data_b_010C,8000h
		jmp	short loc_a_1616
		db	90h
loc_a_160B:
		mov	byte ptr data_b_0105,1
		mov	data_b_010C,0
loc_a_1616:
		call	sub_a_092D
loc_a_1619:
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_158E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1620	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		call	sub_a_55C7		; Play sound
		mov	byte ptr data_b_00E4,2
		call	sub_a_1522
		mov	dh,data_b_0100
		cmp	dh,1
		jne	loc_a_167B		; Jump if not equal
		mov	bx,data_b_011A
		cmp	bh,0
		je	loc_a_169D		; Jump if equal
		mov	byte ptr data_b_0105,0
		dec	bh
		call	sub_a_1F3D
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_165E		; Jump if equal
		cmp	dh,3
		jge	loc_a_1694		; Jump if > or =
		jmp	short loc_a_1664
		db	90h
loc_a_165E:
		call	sub_a_155B
		jmp	short loc_a_16AB
		db	90h
loc_a_1664:
		mov	data_b_010C,0
		mov	data_b_011A,bx
		mov	dh,data_b_006A
		mov	data_b_0380[si],dh
		mov	byte ptr data_b_0381[si],0
loc_a_167B:
		mov	cx,data_b_0128
		call	sub_a_3A2B
		dec	cx
		mov	data_b_0128,cx
		mov	dl,data_b_00AF
		call	sub_a_2496
		call	sub_a_092D
		jmp	short loc_a_16AB
		db	90h
loc_a_1694:
		mov	data_b_010C,8000h
		jmp	short loc_a_16AB
		db	90h
loc_a_169D:
		mov	byte ptr data_b_0105,1
		mov	data_b_010C,0
		call	sub_a_092D
loc_a_16AB:
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1620	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_16B2	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		call	sub_a_55C7		; Play sound
		mov	byte ptr data_b_00E4,8
		call	sub_a_1522
		mov	dh,data_b_0100
		cmp	dh,1
		jne	loc_a_170D		; Jump if not equal
		mov	bx,data_b_011A
		cmp	bl,0
		je	loc_a_1731		; Jump if equal
		mov	byte ptr data_b_0105,0
		dec	bl
		call	sub_a_1F3D
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_16F0		; Jump if equal
		cmp	dh,3
		jge	loc_a_1728		; Jump if > or =
		jmp	short loc_a_16F6
		db	90h
loc_a_16F0:
		call	sub_a_155B
		jmp	short loc_a_173F
		db	90h
loc_a_16F6:
		mov	data_b_010C,0
		mov	data_b_011A,bx
		mov	dh,data_b_006A
		mov	data_b_0380[si],dh
		mov	byte ptr data_b_0391[si],0
loc_a_170D:
		mov	cx,data_b_0128
		call	sub_a_3A2B
		sub	cx,50h
		mov	data_b_0128,cx
		mov	dl,data_b_00AF
		call	sub_a_26FE
		call	sub_a_0956
		jmp	short loc_a_173F
		db	90h
loc_a_1728:
		mov	data_b_010C,8000h
		jmp	short loc_a_173F
		db	90h
loc_a_1731:
		mov	byte ptr data_b_0105,1
		mov	data_b_010C,0
		call	sub_a_0956
loc_a_173F:
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_16B2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1746	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		call	sub_a_55C7		; Play sound
		mov	byte ptr data_b_00E4,4
		call	sub_a_1522
		mov	dh,data_b_0100
		cmp	dh,1
		jne	loc_a_17A1		; Jump if not equal
		mov	bx,data_b_011A
		cmp	bl,0Ah
		je	loc_a_17C5		; Jump if equal
		mov	byte ptr data_b_0105,0
		inc	bl
		call	sub_a_1F3D
		mov	dh,data_b_0380[si]
		cmp	dh,1
		je	loc_a_1784		; Jump if equal
		cmp	dh,3
		jge	loc_a_17BC		; Jump if > or =
		jmp	short loc_a_178A
		db	90h
loc_a_1784:
		call	sub_a_155B
		jmp	short loc_a_17D3
		db	90h
loc_a_178A:
		mov	data_b_010C,0
		mov	data_b_011A,bx
		mov	dh,data_b_006A
		mov	data_b_0380[si],dh
		mov	byte ptr data_b_036F[si],0
loc_a_17A1:
		mov	cx,data_b_0128
		call	sub_a_3A2B
		add	cx,50h
		mov	data_b_0128,cx
		mov	dl,data_b_00AF
		call	sub_a_26F6
		call	sub_a_092D
		jmp	short loc_a_17D3
		db	90h
loc_a_17BC:
		mov	data_b_010C,8000h
		jmp	short loc_a_17D3
		db	90h
loc_a_17C5:
		mov	byte ptr data_b_0105,1
		mov	data_b_010C,0
		call	sub_a_092D
loc_a_17D3:
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1746	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_17DA	proc	near
		mov	bx,di
		call	sub_a_1F3D
		mov	cx,di
		inc	ch
		inc	si
loc_a_17E4:
		cmp	ch,data_b_00CC
		je	loc_a_17FB		; Jump if equal
		mov	bl,data_b_0380[si]
		and	bl,0F1h
		cmp	bl,1
		je	loc_a_17FB		; Jump if equal
		inc	si
		inc	ch
		jmp	short loc_a_17E4
loc_a_17FB:
		dec	si
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		retn
sub_a_17DA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1803	proc	near
		mov	bx,di
		call	sub_a_1F3D
		mov	cx,di
loc_a_180A:
		cmp	ch,data_b_00D1
		je	loc_a_1821		; Jump if equal
		mov	bl,data_b_037F[si]
		and	bl,0F1h
		cmp	bl,1
		je	loc_a_1821		; Jump if equal
		dec	si
		dec	ch
		jmp	short loc_a_180A
loc_a_1821:
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		retn
sub_a_1803	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1828	proc	near
		mov	bx,di
		call	sub_a_1F3D
		mov	cx,di
loc_a_182F:
		cmp	cl,data_b_00D1
		je	loc_a_1848		; Jump if equal
		mov	bl,data_b_036F[si]
		and	bl,0F1h
		cmp	bl,1
		je	loc_a_1848		; Jump if equal
		sub	si,11h
		dec	cl
		jmp	short loc_a_182F
loc_a_1848:
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		retn
sub_a_1828	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_184F	proc	near
		mov	bx,di
		call	sub_a_1F3D
		mov	cx,di
		inc	cl
		add	si,11h
loc_a_185B:
		cmp	cl,data_b_00CD
		je	loc_a_1874		; Jump if equal
		mov	bl,data_b_0380[si]
		and	bl,0F1h
		cmp	bl,1
		je	loc_a_1874		; Jump if equal
		add	si,11h
		inc	cl
		jmp	short loc_a_185B
loc_a_1874:
		sub	si,11h
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		retn
sub_a_184F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_187E	proc	near
		mov	bx,di
		call	sub_a_1F3D
		mov	byte ptr data_b_0380[si],0
		mov	bx,ax
		call	sub_a_1F1E
		mov	ax,si
		mov	bx,di
		call	sub_a_1F1E
		mov	cx,si
		retn
sub_a_187E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1897	proc	near
		push	ax
		mov	ax,data_b_0101
		and	ax,8000h
		cmp	ax,8000h
		jne	loc_a_18A9		; Jump if not equal
		call	sub_a_3BBC
		jmp	short loc_a_18B0
		db	90h
loc_a_18A9:
		mov	dl,data_b_00B0
		call	sub_a_3A5B
loc_a_18B0:
		call	sub_a_092D
		sub	bp,5
		cmp	bp,0D0h
		jl	loc_a_18C2		; Jump if <
		call	sub_a_1F4E		; Set speaker frequency
		jmp	short loc_a_18C2
		db	90h
loc_a_18C2:
		pop	ax
		retn
sub_a_1897	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_18C4	proc	near
		push	dx
		mov	bx,ax
		call	sub_a_1F3D
		mov	dx,data_b_0101
		and	dx,8000h
		cmp	dx,8000h
		je	loc_a_18E7		; Jump if equal
		mov	byte ptr data_b_0380[si],1
		mov	dl,data_b_00B0
		call	sub_a_3A5B
		jmp	short loc_a_1907
		db	90h
loc_a_18E7:
		mov	byte ptr data_b_0380[si],3
		call	sub_a_3BBC
		mov	dh,data_b_013E
		cmp	dh,1
		je	loc_a_1907		; Jump if equal
		mov	dl,3
		call	sub_a_1909
		cmp	data_b_0042,1
		je	loc_a_1907		; Jump if equal
		call	sub_a_19B1
loc_a_1907:
		pop	dx
		retn
sub_a_18C4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1909	proc	near
		push	bx
		push	cx
		push	dx
		push	si
		mov	dl,3
		mov	si,offset data_b_0000
loc_a_1912:
		mov	bx,offset data_b_0000
loc_a_1915:
		cmp	data_b_0380[bx+si],dl
		jne	loc_a_1979		; Jump if not equal
		call	sub_a_19A2
		call	sub_a_3BBC
		inc	bx
		cmp	data_b_0380[bx+si],dl
		je	loc_a_1931		; Jump if equal
		mov	data_b_0042,0
		jmp	short loc_a_197A
		db	90h
loc_a_1931:
		cmp	data_b_0042,1
		je	loc_a_194C		; Jump if equal
		mov	data_b_0042,1
		call	sub_a_19A2
		mov	data_b_0046,cx
		sub	cx,4
		mov	data_b_0044,cx
loc_a_194C:
		inc	bx
		cmp	data_b_0380[bx+si],dl
		jne	loc_a_1988		; Jump if not equal
		call	sub_a_198D
		cmp	si,0
		jne	loc_a_195E		; Jump if not equal
		jmp	short loc_a_1964
		db	90h
loc_a_195E:
		cmp	si,0AAh
		jne	loc_a_196D		; Jump if not equal
loc_a_1964:
		mov	data_b_014D,1388h
		jmp	short loc_a_1973
		db	90h
loc_a_196D:
		mov	data_b_014D,2710h
loc_a_1973:
		call	sub_a_20DA
		jmp	short loc_a_1988
		db	90h
loc_a_1979:
		inc	bx
loc_a_197A:
		cmp	bx,10h
		jne	loc_a_1915		; Jump if not equal
		add	si,11h
		cmp	si,0BBh
		jne	loc_a_1912		; Jump if not equal
loc_a_1988:
		pop	si
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_1909	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_198D	proc	near
		mov	data_b_0042,0
		mov	cx,data_b_0044
		call	sub_a_3BBC
		mov	cx,data_b_0046
		call	sub_a_3BBC
		retn
sub_a_198D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_19A2	proc	near
		push	si
		push	bx
		add	si,bx
		call	sub_a_1F11
		call	sub_a_1F1E
		mov	cx,si
		pop	bx
		pop	si
		retn
sub_a_19A2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_19B1	proc	near
		push	bx
		push	cx
		push	dx
		push	si
		mov	dl,3
		mov	si,offset data_b_0000
loc_a_19BA:
		mov	bx,offset data_b_0000
loc_a_19BD:
		cmp	data_b_0380[bx+si],dl
		jne	loc_a_1A25		; Jump if not equal
		call	sub_a_19A2
		call	sub_a_3BBC
		add	bx,11h
		cmp	data_b_0380[bx+si],dl
		je	loc_a_19DB		; Jump if equal
		mov	data_b_0042,0
		jmp	short loc_a_1A28
		db	90h
loc_a_19DB:
		cmp	data_b_0042,10h
		je	loc_a_19F7		; Jump if equal
		mov	data_b_0042,10h
		call	sub_a_19A2
		mov	data_b_0046,cx
		sub	cx,280h
		mov	data_b_0044,cx
loc_a_19F7:
		add	bx,11h
		cmp	data_b_0380[bx+si],dl
		jne	loc_a_1A34		; Jump if not equal
		call	sub_a_198D
		cmp	si,0
		jne	loc_a_1A0B		; Jump if not equal
		jmp	short loc_a_1A10
		db	90h
loc_a_1A0B:
		cmp	si,10h
		jne	loc_a_1A19		; Jump if not equal
loc_a_1A10:
		mov	data_b_014D,1388h
		jmp	short loc_a_1A1F
		db	90h
loc_a_1A19:
		mov	data_b_014D,2710h
loc_a_1A1F:
		call	sub_a_20DA
		jmp	short loc_a_1A34
		db	90h
loc_a_1A25:
		add	bx,11h
loc_a_1A28:
		cmp	bx,0AAh
		jne	loc_a_19BD		; Jump if not equal
		inc	si
		cmp	si,11h
		jne	loc_a_19BA		; Jump if not equal
loc_a_1A34:
		pop	si
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_19B1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A39	proc	near
		cmp	ax,di
		je	loc_a_1A96		; Jump if equal
		mov	bp,120h
		call	sub_a_1F4E		; Set speaker frequency
		push	ax
		call	sub_a_187E
loc_a_1A47:
		call	sub_a_1C5E
		call	sub_a_11B0
		mov	di,4
loc_a_1A50:
		mov	dh,data_b_013D
		cmp	dh,0
		je	loc_a_1A74		; Jump if equal
		add	cx,4
		cmp	cx,ax
		jge	loc_a_1A71		; Jump if > or =
		call	sub_a_3A2B
		inc	cx
		mov	dl,data_b_00AF
		call	sub_a_2550
		sub	cx,5
		jmp	short loc_a_1A74
		db	90h
loc_a_1A71:
		sub	cx,4
loc_a_1A74:
		call	sub_a_3A2B
		inc	cx
		call	sub_a_1897
		dec	di
		jnz	loc_a_1A50		; Jump if not zero
		inc	bh
		call	sub_a_1C5E
		cmp	cx,ax
		jne	loc_a_1A47		; Jump if not equal
		call	sub_a_1C31
		mov	byte ptr data_b_013D,0
		pop	ax
		call	sub_a_18C4
		jmp	short loc_ret_a_1AB2
		db	90h
loc_a_1A96:
		mov	dx,data_b_0101
		and	dx,8000h
		cmp	dx,8000h
		je	loc_a_1AAF		; Jump if equal
		mov	bx,ax
		call	sub_a_08F3
		mov	data_b_0101,0
loc_a_1AAF:
		call	sub_a_11B0

loc_ret_a_1AB2:
		retn
sub_a_1A39	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1AB3	proc	near
		cmp	ax,di
		je	loc_a_1B10		; Jump if equal
		mov	bp,120h
		call	sub_a_1F4E		; Set speaker frequency
		push	ax
		call	sub_a_187E
loc_a_1AC1:
		call	sub_a_1CD4
		call	sub_a_11B0
		mov	di,4
loc_a_1ACA:
		mov	dh,data_b_013D
		cmp	dh,0
		je	loc_a_1AEE		; Jump if equal
		sub	cx,4
		cmp	cx,ax
		jle	loc_a_1AEB		; Jump if < or =
		call	sub_a_3A2B
		dec	cx
		mov	dl,data_b_00AF
		call	sub_a_2496
		add	cx,5
		jmp	short loc_a_1AEE
		db	90h
loc_a_1AEB:
		add	cx,4
loc_a_1AEE:
		call	sub_a_3A2B
		dec	cx
		call	sub_a_1897
		dec	di
		jnz	loc_a_1ACA		; Jump if not zero
		dec	bh
		call	sub_a_1CD4
		cmp	cx,ax
		jne	loc_a_1AC1		; Jump if not equal
		call	sub_a_1C31
		mov	byte ptr data_b_013D,0
		pop	ax
		call	sub_a_18C4
		jmp	short loc_ret_a_1B2C
		db	90h
loc_a_1B10:
		mov	dx,data_b_0101
		and	dx,8000h
		cmp	dx,8000h
		je	loc_a_1B29		; Jump if equal
		mov	bx,ax
		call	sub_a_08F3
		mov	data_b_0101,0
loc_a_1B29:
		call	sub_a_11B0

loc_ret_a_1B2C:
		retn
sub_a_1AB3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1B2D	proc	near
		cmp	ax,di
		je	loc_a_1B93		; Jump if equal
		mov	bp,120h
		call	sub_a_1F4E		; Set speaker frequency
		push	ax
		call	sub_a_187E
loc_a_1B3B:
		call	sub_a_1D4F
		call	sub_a_11B0
		mov	di,8
loc_a_1B44:
		mov	dh,data_b_013D
		cmp	dh,0
		je	loc_a_1B6F		; Jump if equal
		sub	cx,280h
		cmp	cx,ax
		jle	loc_a_1B6B		; Jump if < or =
		mov	dl,0
		call	sub_a_3A2B
		sub	cx,50h
		mov	dl,data_b_00AF
		call	sub_a_26FE
		add	cx,2D0h
		jmp	short loc_a_1B6F
		db	90h
loc_a_1B6B:
		add	cx,280h
loc_a_1B6F:
		call	sub_a_3A2B
		sub	cx,50h
		call	sub_a_1897
		dec	di
		jnz	loc_a_1B44		; Jump if not zero
		dec	bl
		call	sub_a_1D4F
		cmp	cx,ax
		jne	loc_a_1B3B		; Jump if not equal
		call	sub_a_1C31
		mov	byte ptr data_b_013D,0
		pop	ax
		call	sub_a_18C4
		jmp	short loc_ret_a_1BAF
		db	90h
loc_a_1B93:
		mov	dx,data_b_0101
		and	dx,8000h
		cmp	dx,8000h
		je	loc_a_1BAC		; Jump if equal
		mov	bx,ax
		call	sub_a_08F3
		mov	data_b_0101,0
loc_a_1BAC:
		call	sub_a_11B0

loc_ret_a_1BAF:
		retn
sub_a_1B2D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1BB0	proc	near
		cmp	ax,di
		je	loc_a_1C14		; Jump if equal
		mov	bp,120h
		call	sub_a_1F4E		; Set speaker frequency
		push	ax
		call	sub_a_187E
loc_a_1BBE:
		call	sub_a_1DCF
		call	sub_a_11B0
		mov	di,8
loc_a_1BC7:
		mov	dh,data_b_013D
		cmp	dh,0
		je	loc_a_1BF0		; Jump if equal
		add	cx,280h
		cmp	cx,ax
		jge	loc_a_1BEC		; Jump if > or =
		call	sub_a_3A2B
		add	cx,50h
		mov	dl,data_b_00AF
		call	sub_a_26F6
		sub	cx,2D0h
		jmp	short loc_a_1BF0
		db	90h
loc_a_1BEC:
		sub	cx,280h
loc_a_1BF0:
		call	sub_a_3A2B
		add	cx,50h
		call	sub_a_1897
		dec	di
		jnz	loc_a_1BC7		; Jump if not zero
		inc	bl
		call	sub_a_1DCF
		cmp	cx,ax
		jne	loc_a_1BBE		; Jump if not equal
		call	sub_a_1C31
		mov	byte ptr data_b_013D,0
		pop	ax
		call	sub_a_18C4
		jmp	short loc_ret_a_1C30
		db	90h
loc_a_1C14:
		mov	dx,data_b_0101
		and	dx,8000h
		cmp	dx,8000h
		je	loc_a_1C2D		; Jump if equal
		mov	bx,ax
		call	sub_a_08F3
		mov	data_b_0101,0
loc_a_1C2D:
		call	sub_a_11B0

loc_ret_a_1C30:
		retn
sub_a_1BB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1C31	proc	near
		push	ax
		push	cx
		mov	ah,data_b_013D
		cmp	ah,1
		jb	loc_a_1C5B		; Jump if below
		cmp	ah,1
		ja	loc_a_1C47		; Jump if above
		mov	cx,190h
		jmp	short loc_a_1C55
		db	90h
loc_a_1C47:
		cmp	ah,2
		ja	loc_a_1C52		; Jump if above
		mov	cx,640h
		jmp	short loc_a_1C55
		db	90h
loc_a_1C52:
		mov	cx,0C80h
loc_a_1C55:
		call	sub_a_1F59
		call	sub_a_2043
loc_a_1C5B:
		pop	cx
		pop	ax
		retn
sub_a_1C31	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1C5E	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	dx,bx
		cmp	dh,10h
		je	loc_a_1CCF		; Jump if equal
		mov	dh,10h
		call	sub_a_1F3D
		cmp	si,10h
		jle	loc_a_1C84		; Jump if < or =
		cmp	byte ptr data_b_0370[si],dh
		jb	loc_a_1C84		; Jump if below
		mov	bl,byte ptr data_b_0370[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1C84:
		cmp	data_b_0392[si],dh
		jb	loc_a_1C95		; Jump if below
		mov	bl,data_b_0392[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1C95:
		cmp	data_b_0382[si],dh
		jb	loc_a_1CA6		; Jump if below
		mov	bl,data_b_0382[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1CA6:
		cmp	data_b_0381[si],dh
		jb	loc_a_1CCF		; Jump if below
		mov	cl,data_b_0381[si]
		sub	cl,10h
		mov	bx,data_b_00B3
		rol	bx,cl			; Rotate
		and	data_b_0139,bx
		mov	byte ptr data_b_0381[si],0
		inc	data_b_013D
		mov	bl,cl
		mov	bh,0
		mov	byte ptr data_b_00EC[bx],2
loc_a_1CCF:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1C5E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1CD4	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	dx,bx
		cmp	dh,0
		je	loc_a_1D4A		; Jump if equal
		mov	dh,10h
		call	sub_a_1F3D
		cmp	si,10h
		jle	loc_a_1CFA		; Jump if < or =
		cmp	data_b_036E[si],dh
		jb	loc_a_1CFA		; Jump if below
		mov	bl,data_b_036E[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1CFA:
		cmp	data_b_0390[si],dh
		jb	loc_a_1D0B		; Jump if below
		mov	bl,data_b_0390[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1D0B:
		cmp	si,1
		jle	loc_a_1D21		; Jump if < or =
		cmp	data_b_037E[si],dh
		jb	loc_a_1D21		; Jump if below
		mov	bl,data_b_037E[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1D21:
		cmp	data_b_037F[si],dh
		jb	loc_a_1D4A		; Jump if below
		mov	cl,data_b_037F[si]
		sub	cl,10h
		mov	bx,data_b_00B3
		rol	bx,cl			; Rotate
		and	data_b_0139,bx
		mov	byte ptr data_b_037F[si],0
		inc	data_b_013D
		mov	bl,cl
		mov	bh,0
		mov	byte ptr data_b_00EC[bx],2
loc_a_1D4A:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1CD4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1D4F	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	dx,bx
		cmp	dl,0
		je	loc_a_1DCA		; Jump if equal
		mov	dh,10h
		call	sub_a_1F3D
		cmp	si,10h
		jle	loc_a_1DCA		; Jump if < or =
		cmp	data_b_036E[si],dh
		jb	loc_a_1D75		; Jump if below
		mov	bl,data_b_036E[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1D75:
		cmp	byte ptr data_b_0370[si],dh
		jb	loc_a_1D86		; Jump if below
		mov	bl,byte ptr data_b_0370[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1D86:
		cmp	si,22h
		jb	loc_a_1D9C		; Jump if below
		cmp	data_b_035E[si],dh
		jb	loc_a_1D9C		; Jump if below
		mov	bl,data_b_035E[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1D9C:
		cmp	si,10h
		jbe	loc_a_1DCA		; Jump if below or =
		cmp	data_b_036F[si],dh
		jb	loc_a_1DCA		; Jump if below
		mov	cl,data_b_036F[si]
		sub	cl,10h
		mov	bx,data_b_00B3
		rol	bx,cl			; Rotate
		and	data_b_0139,bx
		mov	byte ptr data_b_036F[si],0
		inc	data_b_013D
		mov	bl,cl
		mov	bh,0
		mov	byte ptr data_b_00EC[bx],2
loc_a_1DCA:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1D4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1DCF	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	dx,bx
		cmp	dl,0Ah
		je	loc_a_1E41		; Jump if equal
		mov	dh,10h
		call	sub_a_1F3D
		cmp	data_b_0390[si],dh
		jb	loc_a_1DF0		; Jump if below
		mov	bl,data_b_0390[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1DF0:
		cmp	data_b_0392[si],dh
		jb	loc_a_1E01		; Jump if below
		mov	bl,data_b_0392[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1E01:
		cmp	si,offset data_b_0099
		jge	loc_a_1E18		; Jump if > or =
		cmp	data_b_03A2[si],dh
		jb	loc_a_1E18		; Jump if below
		mov	bl,data_b_03A2[si]
		mov	bh,0
		mov	byte ptr data_b_00DC[bx],1
loc_a_1E18:
		cmp	data_b_0391[si],dh
		jb	loc_a_1E41		; Jump if below
		mov	cl,data_b_0391[si]
		sub	cl,10h
		mov	bx,data_b_00B3
		rol	bx,cl			; Rotate
		and	data_b_0139,bx
		mov	byte ptr data_b_0391[si],0
		inc	data_b_013D
		mov	bl,cl
		mov	bh,0
		mov	byte ptr data_b_00EC[bx],2
loc_a_1E41:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1DCF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1E46	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		mov	si,28Ah
		mov	dl,data_b_00B0
		mov	bl,0Bh
loc_a_1E54:
		mov	bh,11h
loc_a_1E56:
		mov	cx,si
		call	sub_a_3A5B
		add	si,4
		dec	bh
		jnz	loc_a_1E56		; Jump if not zero
		add	si,23Ch
		dec	bl
		jnz	loc_a_1E54		; Jump if not zero
		mov	si,offset data_b_0000
loc_a_1E6D:
		cmp	si,data_b_00CE
		je	loc_a_1EB0		; Jump if equal
		mov	al,data_b_0380[si]
		cmp	al,0
		je	loc_a_1E86		; Jump if equal
		cmp	al,10h
		jge	loc_a_1E86		; Jump if > or =
		cmp	al,3
		je	loc_a_1E9B		; Jump if equal
		inc	si
		jmp	short loc_a_1E6D
loc_a_1E86:
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		mov	bx,ax
		push	si
		call	sub_a_1F1E
		mov	cx,si
		call	sub_a_3A2B
		pop	si
		inc	si
		jmp	short loc_a_1E6D
loc_a_1E9B:
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		mov	bx,ax
		push	si
		call	sub_a_1F1E
		mov	cx,si
		call	sub_a_3BBC
		pop	si
		inc	si
		jmp	short loc_a_1E6D
loc_a_1EB0:
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1E46	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1EB6	proc	near
		push	si
		push	ax
		push	bx
		push	cx
		push	dx
		push	bp
		mov	al,data_b_013C
		cmp	al,10h
		jl	loc_a_1ECB		; Jump if <
		mov	ah,0
		div	data_b_00B9		; al,ah rem = ax/data
		mov	al,ah
loc_a_1ECB:
		inc	al
		mul	data_b_00D0		; ax = data * al
		mov	bx,ax
		mov	si,offset data_b_0000
loc_a_1ED6:
		mov	dl,data_b_0380[bx+si]
		mov	data_b_0380[si],dl
		inc	si
		cmp	si,0BBh
		jne	loc_a_1ED6		; Jump if not equal
		mov	bx,0
loc_a_1EE8:
		inc	bx

		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		add	dx,bx
		mov	dh,0
		cmp	dl,0BBh
		jb	loc_a_1EF9		; Jump if below
		sub	dx,69h
loc_a_1EF9:
		mov	si,dx
		mov	dl,data_b_0380[si]
		cmp	dl,1
		jne	loc_a_1EE8		; Jump if not equal
		mov	dl,3
		mov	data_b_0380[si],dl
		pop	bp
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		pop	si
		retn
sub_a_1EB6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1F11	proc	near
		push	ax
		mov	ax,si
		div	data_b_00CC		; al,ah rem = ax/data
		mov	bh,ah
		mov	bl,al
		pop	ax
		retn
sub_a_1F11	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1F1E	proc	near
		push	ax
		push	cx
		mov	al,bh
		mul	data_b_00BA		; ax = data * al
		mov	cx,ax
		mov	al,bl
		mul	data_b_00BA		; ax = data * al
		mul	data_b_00C6		; ax = data * al
		add	cx,ax
		add	cx,28Ah
		mov	si,cx
		pop	cx
		pop	ax
		retn
sub_a_1F1E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1F3D	proc	near
		push	ax
		push	cx
		mov	cx,bx
		mov	al,cl
		mul	data_b_00CC		; ax = data * al
		add	al,ch
		mov	si,ax
		pop	cx
		pop	ax
		retn
sub_a_1F3D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set speaker frequency

sub_a_1F4E	proc	near
		push	ax
		mov	ax,bp
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		pop	ax
		retn
sub_a_1F4E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1F59	proc	near
		push	ax
		push	bx
		push	dx
		push	bp
		pushf				; Push flags
		mov	bx,offset data_b_0145
		mov	dx,[bx+2]
		clc				; Clear carry flag
		add	data_b_0145,cx
		adc	dx,0
		mov	[bx+2],dx
		popf				; Pop flags
		mov	bl,data_b_0041
		cmp	bl,2
		jge	loc_a_1FAF		; Jump if > or =
		cmp	bl,1
		je	loc_a_1F8B		; Jump if equal
		mov	bx,data_b_0145
		cmp	bx,7530h
		jae	loc_a_1F98		; Jump if above or =
		jmp	short loc_a_1FAF
		db	90h
loc_a_1F8B:
		mov	bx,data_b_0145
		cmp	bx,0EA60h
		jae	loc_a_1F98		; Jump if above or =
		jmp	short loc_a_1FAF
		db	90h
loc_a_1F98:
		inc	data_b_0041
		inc	data_b_0138
		mov	bp,54Ch
		call	sub_a_1F4E		; Set speaker frequency
		call	sub_a_0266
		call	sub_a_09C3
		call	sub_a_09C3
loc_a_1FAF:
		pop	bp
		pop	dx
		pop	bx
		pop	ax
		retn
sub_a_1F59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1FB4	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si

		; print 'HIGH:$'
		mov	dx,1Dh
		mov	si,198h
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		mov	bx,offset data_b_0145
		mov	dx,[bx+6]
		mov	cx,[bx+4]
		xchg	[bx+2],dx
		xchg	[bx],cx
		push	bx
		push	cx
		push	dx
		call	sub_a_208B

		; print '000000$'
		mov	dx,22h
		mov	si,19Eh
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		pop	dx
		pop	cx
		pop	bx

		; print 'SCORE:$'
		mov	[bx+2],dx
		mov	[bx],cx
		mov	dx,4
		mov	si,191h
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_208B

		; print '000000$'
		mov	dx,0Ah
		mov	si,19Eh
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX

		mov	al,data_b_013C
		mov	ah,0
		inc	ax
		div	data_b_00BF		; al,ah rem = ax/data
		add	ah,30h			; '0'
		add	al,30h			; '0'
		mov	bx,offset data_b_0151+4	; ('R')

		; print 'R:  $'
		mov	[bx+2],al
		mov	[bx+3],ah
		mov	dx,12h
		mov	si,155h
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		mov	ax,data_b_004D
		add	al,31h			; '1'
		mov	bx,offset data_b_0151	; ('L: $R:  $               ')
		mov	[bx+2],al

		; print 'L: $'
		mov	dx,18h
		mov	si,151h
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_1FB4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2043	proc	near
		push	si
		push	bx
		push	dx
		call	sub_a_208B

		; print '000000$'
		mov	dx,0Ah
		mov	si,19Eh
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		pop	dx
		pop	bx
		pop	si
		retn
sub_a_2043	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2058	proc	near
		pushf				; Push flags
		push	ax
		push	bx
		push	cx
		push	dx
		mov	bx,offset data_b_0145
		mov	dx,[bx+0Ah]
		mov	cx,[bx+8]
		xchg	[bx+2],dx
		xchg	[bx],cx
		push	dx
		push	cx
		push	bx
		call	sub_a_208B

		; print '000000$'
		mov	dx,0B15h
		mov	si,19Eh
		inc	si
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		pop	bx
		pop	cx
		pop	dx
		mov	[bx+2],dx
		mov	[bx],cx
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		popf				; Pop flags
		retn
sub_a_2058	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_208B	proc	near
		push	ax
		push	bx
		push	dx
		mov	bx,offset data_b_0145
		mov	dx,[bx+2]
		mov	ax,[bx]
		div	data_b_00BD		; ax,dxrem=dx:ax/data
		add	dl,30h			; '0'
		mov	data_b_019E+5,dl
		cwd				; Word to double word
		div	data_b_00BD		; ax,dxrem=dx:ax/data
		add	dl,30h			; '0'
		mov	data_b_019E+4,dl
		cwd				; Word to double word
		div	data_b_00BD		; ax,dxrem=dx:ax/data
		add	dl,30h			; '0'
		mov	data_b_019E+3,dl
		cwd				; Word to double word
		div	data_b_00BD		; ax,dxrem=dx:ax/data
		add	dl,30h			; '0'
		mov	data_b_019E+2,dl
		cwd				; Word to double word
		div	data_b_00BD		; ax,dxrem=dx:ax/data
		add	dl,30h			; '0'
		mov	data_b_019E+1,dl
		add	al,30h			; '0'
		mov	data_b_019E,al
		pop	dx
		pop	bx
		pop	ax
		retn
sub_a_208B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_20DA	proc	near
		push	ax
		push	bx
		push	cx
		push	dx

		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_00AB,dx
		mov	data_b_00A9,cx
		cmp	byte ptr data_b_004A,1
		je	loc_a_20F8		; Jump if equal

		; set palettes
		mov	ah,0Bh
		mov	bx,101h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
loc_a_20F8:
		; print 'BONUS:       PTS$'
		mov	dx,0B0Fh
		mov	si,1A5h
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_2058
		call	sub_a_21C7
loc_a_2109:
		sub	data_b_014D,64h
		call	sub_a_2058
		mov	bp,6B2h
		call	sub_a_1F4E		; Set speaker frequency
		call	sub_a_097F
		mov	cx,64h
		call	sub_a_1F59
		call	sub_a_2043
		mov	bp,54Ch
		call	sub_a_1F4E		; Set speaker frequency
		call	sub_a_097F
		cmp	data_b_014D,0
		jne	loc_a_2109		; Jump if not equal
		mov	byte ptr data_b_013B,1
		call	sub_a_55C7		; Play sound
		call	sub_a_09CC		; Wait a while
		cmp	byte ptr data_b_004A,1
		je	loc_a_214C		; Jump if equal

		; set palettes
		mov	ah,0Bh
		mov	bx,100h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
loc_a_214C:
		; print spaces
		mov	dx,0B0Fh
		mov	si,15Ah
		mov	bl,3
		call	sub_a_0241		; Print text DS:SI (with $) at position DX
		call	sub_a_1E46
		mov	bx,data_b_0136
		call	sub_a_1F1E
		mov	cx,si
		call	sub_a_2F87
		mov	bx,offset data_b_0000+1
loc_a_2169:
		mov	byte ptr data_b_00F2[bx],1
		inc	bx
		cmp	bx,8
		jne	loc_a_2169		; Jump if not equal
		call	sub_a_0C03
		mov	byte ptr data_b_013E,1
		mov	data_b_014D,2710h
		call	sub_a_09CC		; Wait a while
		call	sub_a_218D
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_20DA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_218D	proc	near
		push	ax
		push	bx
		push	cx
		push	dx

		; get system timer
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	cx,data_b_00A9
		cmp	cx,0
		je	loc_a_21A9		; Jump if equal
		mov	bx,data_b_00AB
		neg	bx
		add	dx,bx
		jmp	short loc_a_21AD
		db	90h
loc_a_21A9:
		sub	dx,data_b_00AB
loc_a_21AD:
		add	data_b_00A7,dx
		mov	data_b_00A5,cx
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_218D	endp

			                        ;* No entry point to code
		push	ax

		; set text videomode 40x25
		mov	ax,1
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set graphics videomode
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		pop	ax
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_21C7	proc	near
		push	si
		push	ax
		push	dx
		mov	si,offset data_b_0000
loc_a_21CD:
		mov	bp,word ptr data_b_0326[si]
		call	sub_a_1F4E		; Set speaker frequency
		call	sub_a_09DD
		cmp	si,1Ch
		je	loc_a_21E1		; Jump if equal
		cmp	si,3Ch
		jne	loc_a_21EB		; Jump if not equal
loc_a_21E1:
		mov	bp,word ptr data_b_0326[si]
		call	sub_a_1F4E		; Set speaker frequency
		jmp	short loc_a_21F1
		db	90h
loc_a_21EB:
		mov	bp,50h
		call	sub_a_1F4E	; Set speaker frequency
loc_a_21F1:
		call	sub_a_0956
		add	si,2
		cmp	si,40h
		jne	loc_a_21CD		; Jump if not equal
		pop	dx
		pop	ax
		pop	si
		retn
sub_a_21C7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2200	proc	near
		push	bx
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,0FFh
		mov	[si+51h],dl
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	dl,3
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E1_e[si],dl
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,3
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20F1_e[si],dl
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_21E1_e[si],dl
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	bx
		retn
sub_a_2200	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2355	proc	near
		push	bx
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	[si+52h],dl
		mov	[si+53h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0193_e[si],dl
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	ds:d_B800_0231_e[si],dl
		mov	ds:d_B800_0232_e[si],dl
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20F1_e[si],dl
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2193_e[si],dl
		mov	ds:d_B800_21E0_e[si],dl
		mov	ds:d_B800_21E1_e[si],dl
		mov	ds:d_B800_21E2_e[si],dl
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	bx
		retn
sub_a_2355	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2496	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	es
		push	ds
		mov	dx,seg seg_b
		mov	es,dx
		mov	bx,0B800h
		mov	ds,bx
		call	sub_a_2200
		mov	dl,7
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,7
		mov	ds:d_B800_20F1_e[si],dl
		mov	ax,cx
		add	ax,6
		cwd				; Word to double word
		div	es:data_b_0372		; ax,dxrem=dx:ax/data
		cmp	dl,8
		jl	loc_a_24CF		; Jump if <
		call	sub_a_24D7
loc_a_24CF:
		pop	ds
		pop	es
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_2496	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_24D7	proc	near
		mov	dl,0Fh
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2193_e[si],dl
		retn
sub_a_24D7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2550	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	es
		push	ds
		mov	dx,seg seg_b
		mov	es,dx
		mov	bx,0B800h
		mov	ds,bx
		call	sub_a_2200
		mov	dl,0D0h
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0D0h
		mov	ds:d_B800_20F2_e[si],dl
		mov	ax,cx
		add	ax,2
		cwd				; Word to double word
		div	es:data_b_0372		; ax,dxrem=dx:ax/data
		cmp	dl,8
		jl	loc_a_2589		; Jump if <
		call	sub_a_24D7
loc_a_2589:
		pop	ds
		pop	es
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_2550	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2591	proc	near
		push	bx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,0FFh
		mov	[si+51h],dl
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	dl,0Fh
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,47h			; 'G'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0D1h
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E1_e[si],dl
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2003_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_21E1_e[si],dl
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	dx
		pop	bx
		retn
sub_a_2591	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_26F6	proc	near
		push	ax
		push	cx
		call	sub_a_2591
		pop	cx
		pop	ax
		retn
sub_a_26F6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_26FE	proc	near
		push	bx
		push	dx
		push	si
		push	ds
		call	sub_a_2591
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0DDh
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0DDh
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20F3_e[si],dl
		pop	ds
		pop	si
		pop	dx
		pop	bx
		retn
sub_a_26FE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_274D	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,3
		mov	[si+50h],dl
		mov	dl,0C0h
		mov	[si+51h],dl
		mov	dl,0Fh
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,3
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_20A1_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_274D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2789	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0Fh
		mov	[si],dl
		mov	dl,0F0h
		mov	[si+1],dl
		mov	dl,0FFh
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_20F1_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2789	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_27E6	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0C0h
		mov	[si],dl
		mov	dl,0C3h
		mov	[si+1],dl
		mov	dl,0
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	dl,0F3h
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,33h			; '3'
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,0CCh
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0CFh
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,0C3h
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,3
		mov	ds:d_B800_20F1_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_27E6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_284B	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20F0_e[si],dl
		mov	ds:d_B800_20F1_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_284B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2896	proc	near
		cmp	dl,1
		je	loc_a_28A1		; Jump if equal
		call	sub_a_29D5
		jmp	short loc_ret_a_28A4
		db	90h
loc_a_28A1:
		call	sub_a_28A5

loc_ret_a_28A4:
		retn
sub_a_2896	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_28A5	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,30h			; '0'
		mov	[si+50h],dl
		mov	dl,0F0h
		mov	[si+51h],dl
		mov	dl,0
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,5
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,5
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,3
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0CDh
		mov	ds:d_B800_2141_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,1
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_28A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_29D5	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,5
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,43h			; 'C'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,5
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20A2_e[si],dl
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0CDh
		mov	ds:d_B800_2141_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,43h			; 'C'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,4Fh			; 'O'
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,1
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_29D5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2AFF	proc	near
		mov	ax,cx
		sub	ax,28Ah
		cwd				; Word to double word
		div	data_b_0374		; ax,dxrem=dx:ax/data
		retn
sub_a_2AFF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B0A	proc	near
		push	ax
		push	bx
		push	dx
		push	ds
		mov	dx,seg seg_b
		mov	ds,dx
		call	sub_a_2AFF
		and	al,1
		cmp	al,1
		jne	loc_a_2B22		; Jump if not equal
		call	sub_a_2C5A
		jmp	short loc_a_2B25
		db	90h
loc_a_2B22:
		call	sub_a_2C6E
loc_a_2B25:
		pop	ds
		pop	dx
		pop	bx
		pop	ax
		retn
sub_a_2B0A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B2A	proc	near
		push	ax
		push	bx
		push	dx
		push	ds
		mov	dx,seg seg_b
		mov	ds,dx
		call	sub_a_2AFF
		and	al,1
		cmp	al,1
		jne	loc_a_2B42		; Jump if not equal
		call	sub_a_2E63
		jmp	short loc_a_2B45
		db	90h
loc_a_2B42:
		call	sub_a_2E77
loc_a_2B45:
		pop	ds
		pop	dx
		pop	bx
		pop	ax
		retn
sub_a_2B2A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B4A	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,15h
		mov	[si+51h],dl
		mov	dl,54h			; 'T'
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	dl,1
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,77h			; 'w'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,5
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,5
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,77h			; 'w'
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,1
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2193_e[si],dl
		retn
sub_a_2B4A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C46	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2B4A
		call	sub_a_2C82
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2C46	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C5A	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2B4A
		call	sub_a_2D99
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2C5A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C6E	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2B4A
		call	sub_a_2DF2
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2C6E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C82	proc	near
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		retn
sub_a_2C82	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2CE3	proc	near
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0232_e[si],dl
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		retn
sub_a_2CE3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2D40	proc	near
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,3
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		retn
sub_a_2D40	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2D99	proc	near
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,3
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		retn
sub_a_2D99	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2DF2	proc	near
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0232_e[si],dl
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		retn
sub_a_2DF2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2E4F	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2E8B
		call	sub_a_2C82
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2E4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2E63	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2E8B
		call	sub_a_2CE3
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2E63	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2E77	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2E8B
		call	sub_a_2D40
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_2E77	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2E8B	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,15h
		mov	[si+51h],dl
		mov	dl,54h			; 'T'
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	dl,1
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0CDh
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,73h			; 's'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,5
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,5
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,1
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2193_e[si],dl
		retn
sub_a_2E8B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2F87	proc	near
		push	ax
		push	dx
		push	ds
		mov	dx,seg seg_b
		mov	ds,dx
		mov	ax,cx
		add	ax,2
		cwd				; Word to double word
		div	data_b_0370		; ax,dxrem=dx:ax/data
		cmp	dl,4
		jge	loc_a_2FA4		; Jump if > or =
		call	sub_a_31A7
		jmp	short loc_a_2FA7
		db	90h
loc_a_2FA4:
		call	sub_a_313A
loc_a_2FA7:
		pop	ds
		pop	dx
		pop	ax
		retn
sub_a_2F87	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2FAB	proc	near
		push	ax
		push	dx
		push	ds
		mov	dx,seg seg_b
		mov	ds,dx
		mov	ax,cx
		add	ax,2
		cwd				; Word to double word
		div	data_b_0370		; ax,dxrem=dx:ax/data
		cmp	dl,4
		jge	loc_a_2FC8		; Jump if > or =
		call	sub_a_3406
		jmp	short loc_a_2FCB
		db	90h
loc_a_2FC8:
		call	sub_a_3399
loc_a_2FCB:
		pop	ds
		pop	dx
		pop	ax
		retn
sub_a_2FAB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2FCF	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,5
		mov	[si+51h],dl
		mov	dl,50h			; 'P'
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0CDh
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,1
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,1
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2193_e[si],dl
		retn
sub_a_2FCF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_30CD	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2FCF
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,17h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0D4h
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,7
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0D0h
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_30CD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_313A	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2FCF
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,17h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0D4h
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,7
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0D0h
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_313A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_31A7	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_2FCF
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0C1h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,43h			; 'C'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_31A7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_322E	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,5
		mov	[si+51h],dl
		mov	dl,50h			; 'P'
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,73h			; 's'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,1
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,1
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,1
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2193_e[si],dl
		retn
sub_a_322E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_332C	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_322E
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,17h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0D4h
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,7
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0D0h
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_332C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3399	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_322E
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,17h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0D4h
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,7
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0D0h
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_3399	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3406	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_322E
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0F1h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,4Fh			; 'O'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_3406	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_348D	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,15h
		mov	[si+51h],dl
		mov	dl,57h			; 'W'
		mov	[si+52h],dl
		mov	dl,0C0h
		mov	[si+53h],dl
		mov	dl,1
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,77h			; 'w'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,5
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0232_e[si],dl
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2003_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,5
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,77h			; 'w'
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,1
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2232_e[si],dl
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_348D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_35F2	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,15h
		mov	[si+51h],dl
		mov	dl,54h			; 'T'
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	dl,1
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0CDh
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,73h			; 's'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,7
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,5
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,7Fh
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,17h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_2141_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,3
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0FDh
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_35F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_375B	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,5
		mov	[si+51h],dl
		mov	dl,0
		mov	[si+52h],dl
		mov	[si+53h],dl
		mov	dl,1
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0D4h
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,5
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,4Fh			; 'O'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,1
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_01E1_e[si],dl
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,5
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,5Ch			; '\'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0D5h
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,5
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,43h			; 'C'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,5
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,5Fh			; '_'
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_375B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_38C4	proc	near
		push	bx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	dl,50h			; 'P'
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,5
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,17h
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0F1h
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_01E1_e[si],dl
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,1
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,57h			; 'W'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,35h			; '5'
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,54h			; 'T'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,0C1h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0F4h
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,55h			; 'U'
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,1
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0F5h
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E3_e[si],dl
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	dx
		pop	bx
		retn
sub_a_38C4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3A2B	proc	near
		push	ax
		push	bx
		push	dx
		push	si
		push	bp
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	bp,280h
		mov	bx,d_B800_0000_e
		mov	dl,0
loc_a_3A3E:
		mov	si,cx
		mov	ax,4
loc_a_3A43:
		mov	[bx+si],dl
		mov	ds:d_B800_2000_e[bx+si],dl
		inc	si
		dec	ax
		jnz	loc_a_3A43		; Jump if not zero
		add	bx,50h
		cmp	bx,bp
		jne	loc_a_3A3E		; Jump if not equal
		pop	ds
		pop	bp
		pop	si
		pop	dx
		pop	bx
		pop	ax
		retn
sub_a_3A2B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3A5B	proc	near
		push	bx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,2
		mov	[si],dl
		mov	dl,0AAh
		mov	[si+1],dl
		mov	[si+2],dl
		mov	dl,80h
		mov	[si+3],dl
		mov	dl,2Ah			; '*'
		mov	[si+50h],dl
		mov	dl,0AAh
		mov	[si+51h],dl
		mov	[si+52h],dl
		mov	dl,0ACh
		mov	[si+53h],dl
		mov	dl,0AAh
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_0190_e[si],dl
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_01E0_e[si],dl
		mov	ds:d_B800_01E1_e[si],dl
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0Ah
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0A0h
		mov	ds:d_B800_2003_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0EAh
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_2140_e[si],dl
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_2190_e[si],dl
		mov	ds:d_B800_2191_e[si],dl
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,2Ah			; '*'
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_21E1_e[si],dl
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0ACh
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	dx
		pop	bx
		retn
sub_a_3A5B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3BBC	proc	near
		push	bx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,2
		mov	[si],dl
		mov	dl,0ABh
		mov	[si+1],dl
		mov	dl,0AAh
		mov	[si+2],dl
		mov	dl,80h
		mov	[si+3],dl
		mov	dl,2Ah			; '*'
		mov	[si+50h],dl
		mov	dl,0BFh
		mov	[si+51h],dl
		mov	dl,0FAh
		mov	[si+52h],dl
		mov	dl,0A8h
		mov	[si+53h],dl
		mov	dl,0ABh
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0BFh
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0FBh
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0BFh
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0141_e[si],dl
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0FBh
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,2Ah			; '*'
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0BFh
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0FAh
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,0Ah
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0A0h
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0Ah
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,0EAh
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0A0h
		mov	ds:d_B800_2003_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,0FEh
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,0EBh
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_20F0_e[si],dl
		mov	ds:d_B800_20F1_e[si],dl
		mov	ds:d_B800_20F2_e[si],dl
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0EBh
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0AAh
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0FEh
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0ABh
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,2Ah			; '*'
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0AFh
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0EAh
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0A8h
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2231_e[si],dl
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	dx
		pop	bx
		retn
sub_a_3BBC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3D2F	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	dl,0F0h
		mov	[si+1],dl
		mov	dl,0
		mov	[si+2],dl
		mov	dl,0
		mov	[si+3],dl
		mov	dl,3Ch			; '<'
		mov	[si+50h],dl
		mov	dl,0F0h
		mov	[si+51h],dl
		mov	dl,0F3h
		mov	[si+52h],dl
		mov	dl,0F0h
		mov	[si+53h],dl
		mov	dl,0
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0CCh
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0CFh
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_2000_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2003_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2050_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2051_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2052_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2053_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20A0_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_20A1_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_20A3_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,3
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2141_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0CFh
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_3D2F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_3EB4	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,0
		mov	[si],dl
		mov	dl,0
		mov	[si+1],dl
		mov	dl,0
		mov	[si+2],dl
		mov	dl,0
		mov	[si+3],dl
		mov	dl,0
		mov	[si+50h],dl
		mov	dl,0
		mov	[si+51h],dl
		mov	dl,0
		mov	[si+52h],dl
		mov	dl,0
		mov	[si+53h],dl
		mov	dl,0
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F0_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F1_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_00F2_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,33h			; '3'
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0CFh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	ds:d_B800_2053_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	ds:d_B800_20A3_e[si],dl
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0F3h
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2141_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2142_e[si],dl
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0CCh
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_21E2_e[si],dl
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,33h			; '3'
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_3EB4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_401D	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		mov	dl,3
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,33h			; '3'
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,30h			; '0'
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,3
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0Ch
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0CFh
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,3Ch			; '<'
		mov	ds:d_B800_2233_e[si],dl
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_401D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_408B	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		push	ds
		mov	dl,77h			; 'w'
		mov	bx,0B800h
		mov	ds,bx
		mov	bp,140h
		mov	bx,d_B800_0000_e
loc_a_409F:
		mov	si,d_B800_0148_e
		mov	ax,48h
loc_a_40A5:
		mov	[bx+si],dl
		mov	ds:d_B800_2000_e[bx+si],dl
		mov	ds:d_B800_1CC0_e[bx+si],dl
		mov	ds:d_B800_3CC0_e[bx+si],dl
		inc	si
		dec	ax
		jnz	loc_a_40A5		; Jump if not zero
		add	bx,50h
		cmp	bx,bp
		jne	loc_a_409F		; Jump if not equal
		mov	bp,1B80h
		mov	bx,d_B800_0000_e
loc_a_40C4:
		mov	si,d_B800_0288_e
		mov	ax,2
loc_a_40CA:
		mov	[bx+si],dl
		mov	ds:d_B800_2000_e[bx+si],dl
		mov	[bx+si+46h],dl
		mov	ds:d_B800_2046_e[bx+si],dl
		inc	si
		dec	ax
		jnz	loc_a_40CA		; Jump if not zero
		add	bx,50h
		cmp	bx,bp
		jne	loc_a_40C4		; Jump if not equal
		pop	ds
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_408B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_40EA	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	dl,77h			; 'w'
		mov	si,d_B800_1EFA_e
		mov	ax,4
loc_a_40FD:
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+5],dl
		mov	[si+6],dl
		mov	[si+9],dl
		mov	[si+0Ah],dl
		mov	[si+0Dh],dl
		mov	[si+0Eh],dl
		add	si,11h
		dec	ax
		jnz	loc_a_40FD		; Jump if not zero
		mov	si,d_B800_1EFA_e
		mov	ax,4
loc_a_4121:
		mov	dl,70h			; 'p'
		mov	[si+3],dl
		mov	[si+0Bh],dl
		mov	ds:d_B800_200E_e[si],dl
		mov	ds:d_B800_2006_e[si],dl
		mov	dl,7
		mov	[si],dl
		mov	[si+8],dl
		mov	ds:d_B800_2005_e[si],dl
		mov	ds:d_B800_200D_e[si],dl
		mov	dl,40h			; '@'
		mov	[si+7],dl
		mov	[si+0Fh],dl
		mov	dl,3
		mov	[si+4],dl
		mov	[si+0Ch],dl
		mov	dl,37h			; '7'
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2009_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_200A_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_4121		; Jump if not zero
		mov	si,d_B800_1EFA_e
		mov	ax,4
loc_a_4170:
		mov	dl,0
		mov	[si+10h],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2004_e[si],dl
		mov	ds:d_B800_2007_e[si],dl
		mov	ds:d_B800_2008_e[si],dl
		mov	ds:d_B800_2009_e[si],dl
		mov	ds:d_B800_200B_e[si],dl
		mov	ds:d_B800_200C_e[si],dl
		mov	ds:d_B800_200F_e[si],dl
		mov	ds:d_B800_2010_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_4170		; Jump if not zero
		mov	dl,0
		mov	si,d_B800_1E0A_e
		mov	ax,4
loc_a_41AB:
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+5],dl
		mov	[si+6],dl
		mov	[si+9],dl
		mov	[si+0Ah],dl
		mov	[si+0Dh],dl
		mov	[si+0Eh],dl
		add	si,11h
		dec	ax
		jnz	loc_a_41AB		; Jump if not zero
		mov	si,d_B800_1E0A_e
		mov	ax,4
loc_a_41CF:
		mov	dl,7
		mov	[si+3],dl
		mov	[si+0Bh],dl
		mov	ds:d_B800_200E_e[si],dl
		mov	ds:d_B800_2006_e[si],dl
		mov	dl,70h			; 'p'
		mov	[si],dl
		mov	[si+8],dl
		mov	ds:d_B800_2005_e[si],dl
		mov	ds:d_B800_200D_e[si],dl
		mov	dl,37h			; '7'
		mov	[si+7],dl
		mov	[si+0Fh],dl
		mov	dl,74h			; 't'
		mov	[si+4],dl
		mov	[si+0Ch],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2009_e[si],dl
		mov	dl,3
		mov	ds:d_B800_200A_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_41CF		; Jump if not zero
		mov	si,d_B800_1E0A_e
		mov	ax,4
loc_a_421E:
		mov	dl,77h			; 'w'
		mov	[si+10h],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2004_e[si],dl
		mov	ds:d_B800_2007_e[si],dl
		mov	ds:d_B800_2008_e[si],dl
		mov	ds:d_B800_200B_e[si],dl
		mov	ds:d_B800_200C_e[si],dl
		mov	ds:d_B800_200F_e[si],dl
		mov	ds:d_B800_2010_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_421E		; Jump if not zero
		pop	ds
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_40EA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4254	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	dl,77h			; 'w'
		mov	si,d_B800_023A_e
		mov	ax,4
loc_a_4267:
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+5],dl
		mov	[si+6],dl
		mov	[si+9],dl
		mov	[si+0Ah],dl
		mov	[si+0Dh],dl
		mov	[si+0Eh],dl
		add	si,11h
		dec	ax
		jnz	loc_a_4267		; Jump if not zero
		mov	si,d_B800_023A_e
		mov	ax,4
loc_a_428B:
		mov	dl,70h			; 'p'
		mov	[si+3],dl
		mov	[si+0Bh],dl
		mov	ds:d_B800_200E_e[si],dl
		mov	ds:d_B800_2006_e[si],dl
		mov	dl,7
		mov	[si],dl
		mov	[si+8],dl
		mov	ds:d_B800_2005_e[si],dl
		mov	ds:d_B800_200D_e[si],dl
		mov	dl,40h			; '@'
		mov	[si+7],dl
		mov	[si+0Fh],dl
		mov	dl,3
		mov	[si+4],dl
		mov	[si+0Ch],dl
		mov	dl,37h			; '7'
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2009_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_200A_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_428B		; Jump if not zero
		mov	si,d_B800_023A_e
		mov	ax,4
loc_a_42DA:
		mov	dl,0
		mov	[si+10h],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2004_e[si],dl
		mov	ds:d_B800_2007_e[si],dl
		mov	ds:d_B800_2008_e[si],dl
		mov	ds:d_B800_2009_e[si],dl
		mov	ds:d_B800_200B_e[si],dl
		mov	ds:d_B800_200C_e[si],dl
		mov	ds:d_B800_200F_e[si],dl
		mov	ds:d_B800_2010_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_42DA		; Jump if not zero
		mov	dl,0
		mov	si,d_B800_014A_e
		mov	ax,4
loc_a_4315:
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+5],dl
		mov	[si+6],dl
		mov	[si+9],dl
		mov	[si+0Ah],dl
		mov	[si+0Dh],dl
		mov	[si+0Eh],dl
		add	si,11h
		dec	ax
		jnz	loc_a_4315		; Jump if not zero
		mov	si,d_B800_014A_e
		mov	ax,4
loc_a_4339:
		mov	dl,7
		mov	[si+3],dl
		mov	[si+0Bh],dl
		mov	ds:d_B800_200E_e[si],dl
		mov	ds:d_B800_2006_e[si],dl
		mov	dl,70h			; 'p'
		mov	[si],dl
		mov	[si+8],dl
		mov	ds:d_B800_2005_e[si],dl
		mov	ds:d_B800_200D_e[si],dl
		mov	dl,37h			; '7'
		mov	[si+7],dl
		mov	[si+0Fh],dl
		mov	dl,74h			; 't'
		mov	[si+4],dl
		mov	[si+0Ch],dl
		mov	dl,40h			; '@'
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2009_e[si],dl
		mov	dl,3
		mov	ds:d_B800_200A_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_4339		; Jump if not zero
		mov	si,d_B800_014A_e
		mov	ax,4
loc_a_4388:
		mov	dl,77h			; 'w'
		mov	[si+10h],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2004_e[si],dl
		mov	ds:d_B800_2007_e[si],dl
		mov	ds:d_B800_2008_e[si],dl
		mov	ds:d_B800_200B_e[si],dl
		mov	ds:d_B800_200C_e[si],dl
		mov	ds:d_B800_200F_e[si],dl
		mov	ds:d_B800_2010_e[si],dl
		add	si,11h
		dec	ax
		jnz	loc_a_4388		; Jump if not zero
		pop	ds
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_4254	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_43BE	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,d_B800_02CE_e
		mov	ax,8
loc_a_43CF:
		mov	dl,77h			; 'w'
		mov	[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_2140_e[si],dl
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,70h			; 'p'
		mov	[si+1],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,37h			; '7'
		mov	[si+50h],dl
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,74h			; 't'
		mov	[si+51h],dl
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,37h			; '7'
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,7
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		add	si,370h
		dec	ax
		jnz	loc_a_43CF		; Jump if not zero
		mov	si,d_B800_045E_e
		mov	ax,8
loc_a_443D:
		mov	dl,77h			; 'w'
		mov	ds:d_B800_2000_e[si],dl
		mov	[si+50h],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_20F1_e[si],dl
		mov	ds:d_B800_0190_e[si],dl
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,70h			; 'p'
		mov	ds:d_B800_2001_e[si],dl
		mov	[si+51h],dl
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,37h			; '7'
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2141_e[si],dl
		add	si,370h
		dec	ax
		jnz	loc_a_443D		; Jump if not zero
		mov	si,d_B800_045E_e
		mov	ax,8
loc_a_448C:
		mov	dl,37h			; '7'
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,7
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		mov	ds:d_B800_20F0_e[si],dl
		add	si,370h
		dec	ax
		jnz	loc_a_448C		; Jump if not zero
		pop	ds
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_43BE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_44BC	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,d_B800_0288_e
		mov	ax,8
loc_a_44CD:
		mov	dl,77h			; 'w'
		mov	[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_2140_e[si],dl
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,70h			; 'p'
		mov	[si+1],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2141_e[si],dl
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,37h			; '7'
		mov	[si+50h],dl
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,74h			; 't'
		mov	[si+51h],dl
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,37h			; '7'
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,7
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		add	si,370h
		dec	ax
		jnz	loc_a_44CD		; Jump if not zero
		mov	si,d_B800_0418_e
		mov	ax,8
loc_a_453B:
		mov	dl,77h			; 'w'
		mov	ds:d_B800_2000_e[si],dl
		mov	[si+50h],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_20F1_e[si],dl
		mov	ds:d_B800_0190_e[si],dl
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,70h			; 'p'
		mov	ds:d_B800_2001_e[si],dl
		mov	[si+51h],dl
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,37h			; '7'
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2141_e[si],dl
		add	si,370h
		dec	ax
		jnz	loc_a_453B		; Jump if not zero
		mov	si,d_B800_0418_e
		mov	ax,8
loc_a_458A:
		mov	dl,37h			; '7'
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,74h			; 't'
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,7
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		mov	ds:d_B800_20F0_e[si],dl
		add	si,370h
		dec	ax
		jnz	loc_a_458A		; Jump if not zero
		pop	ds
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_44BC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45BA	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_4760
		call	sub_a_4600
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_45BA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45CE	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_4760
		call	sub_a_46F6
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_45CE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_45E2	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_4760
		mov	dl,0FFh
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		call	sub_a_46F6
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_45E2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4600	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	[si+52h],dl
		mov	dl,54h			; 'T'
		mov	[si+53h],dl
		mov	dl,5
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,5
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A3_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_00F2_e[si],dl
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	ds:d_B800_2053_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_20A3_e[si],dl
		retn
sub_a_4600	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4678	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	dl,54h			; 'T'
		mov	[si+51h],dl
		mov	dl,0
		mov	[si+52h],dl
		mov	[si+53h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	dl,5
		mov	ds:d_B800_00A1_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00A2_e[si],dl
		mov	dl,50h			; 'P'
		mov	ds:d_B800_00A3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_00F0_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_00F2_e[si],dl
		mov	ds:d_B800_00F3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	dl,15h
		mov	ds:d_B800_2002_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	ds:d_B800_2053_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	dl,5
		mov	ds:d_B800_20A3_e[si],dl
		retn
sub_a_4678	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_46F6	proc	near
		mov	dl,0
		mov	[si],dl
		mov	[si+1],dl
		mov	[si+2],dl
		mov	[si+3],dl
		mov	[si+50h],dl
		mov	[si+51h],dl
		mov	[si+52h],dl
		mov	[si+53h],dl
		mov	ds:d_B800_00A0_e[si],dl
		mov	ds:d_B800_00A1_e[si],dl
		mov	ds:d_B800_00A2_e[si],dl
		mov	ds:d_B800_00A3_e[si],dl
		mov	ds:d_B800_00F0_e[si],dl
		mov	ds:d_B800_00F1_e[si],dl
		mov	ds:d_B800_00F2_e[si],dl
		mov	ds:d_B800_00F3_e[si],dl
		mov	ds:d_B800_2000_e[si],dl
		mov	ds:d_B800_2001_e[si],dl
		mov	ds:d_B800_2002_e[si],dl
		mov	ds:d_B800_2003_e[si],dl
		mov	ds:d_B800_2050_e[si],dl
		mov	ds:d_B800_2051_e[si],dl
		mov	ds:d_B800_2052_e[si],dl
		mov	ds:d_B800_2053_e[si],dl
		mov	ds:d_B800_20A0_e[si],dl
		mov	ds:d_B800_20A1_e[si],dl
		mov	ds:d_B800_20A2_e[si],dl
		mov	ds:d_B800_20A3_e[si],dl
		retn
sub_a_46F6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4760	proc	near
		mov	dl,0
		mov	ds:d_B800_0140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0141_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0142_e[si],dl
		mov	dl,0
		mov	ds:d_B800_0143_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_0190_e[si],dl
		mov	dl,0C3h
		mov	ds:d_B800_0191_e[si],dl
		mov	dl,0C3h
		mov	ds:d_B800_0192_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_0193_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_01E0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E1_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_01E2_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_01E3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_0230_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0231_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_0232_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_0233_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20F0_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_20F1_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_20F2_e[si],dl
		mov	dl,0
		mov	ds:d_B800_20F3_e[si],dl
		mov	dl,3
		mov	ds:d_B800_2140_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2141_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_2142_e[si],dl
		mov	dl,0C0h
		mov	ds:d_B800_2143_e[si],dl
		mov	dl,3Fh			; '?'
		mov	ds:d_B800_2190_e[si],dl
		mov	dl,0C3h
		mov	ds:d_B800_2191_e[si],dl
		mov	dl,0C3h
		mov	ds:d_B800_2192_e[si],dl
		mov	dl,0FCh
		mov	ds:d_B800_2193_e[si],dl
		mov	dl,0Fh
		mov	ds:d_B800_21E0_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_21E1_e[si],dl
		mov	dl,0FFh
		mov	ds:d_B800_21E2_e[si],dl
		mov	dl,0F0h
		mov	ds:d_B800_21E3_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2230_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2231_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2232_e[si],dl
		mov	dl,0
		mov	ds:d_B800_2233_e[si],dl
		retn
sub_a_4760	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4839	proc	near
		push	bx
		push	si
		push	ds
		mov	bx,0B800h
		mov	ds,bx
		mov	si,cx
		call	sub_a_4760
		mov	dl,0FFh
		mov	ds:d_B800_0191_e[si],dl
		mov	ds:d_B800_0192_e[si],dl
		call	sub_a_4678
		pop	ds
		pop	si
		pop	bx
		retn
sub_a_4839	endp

		db	9 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4860	proc	near
		push	ax
		mov	ax,bp
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		pop	ax
		retn
sub_a_4860	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display help

sub_a_486B	proc	near

;		push	ax
		push	bx
		push	cx
		push	dx
		push	si

		; set graphics videomode
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set palettes
		mov	ah,0Bh
		mov	bh,1
		mov	bl,data_b_15F3
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	cx,928h
		call	sub_a_2E4F
		add	cx,3C0h
		call	sub_a_26F6
		add	cx,3C0h
		call	sub_a_3A5B
		add	cx,3C0h
		call	sub_a_3BBC
		add	cx,3C0h
		call	sub_a_45BA

		; print spaces
		mov	bl,3
		mov	dx,0
		mov	si,1312h
		call	sub_a_4F10		; Print text DS:SI at position DX

		; print 'Attempt to clear bees in the field'
		mov	dx,201h
		mov	si,128Bh
		call	sub_a_4F10		; Print text DS:SI at position DX

		mov	dx,301h
		mov	si,12AEh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,401h
		mov	si,12D2h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,501h
		mov	si,12FAh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,601h
		mov	si,1320h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,811h
		mov	si,132Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0B11h
		mov	si,1334h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0E11h
		mov	si,1338h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1111h
		mov	si,133Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1411h
		mov	si,134Ch
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bl,1
		mov	dx,1808h
		mov	si,10B5h
		call	sub_a_4F10		; Print text DS:SI at position DX

		; get key from keyboard without echo (wait)
		mov	ah,8
		int	21h			; DOS Services  ah=function 08h
						;  get keybd char al, no echo

; !!! Picopad modification - exit help
; !!! Picopad modification - exit help
		cmp	al,58h			; 'X'
		je	sub_a_486BY2		; Jump if equal
		cmp	al,78h			; 'x'
sub_a_486BY2:	jne	sub_a_486BY3
		jmp	sub_a_486BX

sub_a_486BY3:

		; set graphics videomode
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set palettes
;		mov	ah,0Bh
;		mov	bh,1
;		mov	bl,data_b_15F3
;		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	bl,3
		mov	dx,0
		mov	si,1356h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,302h
		mov	si,1378h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,502h
		mov	si,1387h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,702h
		mov	si,1396h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,902h
		mov	si,13A5h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bl,1
		mov	dx,31Bh
		mov	si,1368h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,51Bh
		mov	si,136Ah
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,717h
		mov	si,136Ch
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,91Bh
		mov	si,1376h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bl,3
		mov	dx,0B02h
		mov	si,13B4h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0D02h
		mov	si,13C5h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1000h
		mov	si,13DAh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1202h
		mov	si,13ECh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1302h
		mov	si,1406h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1402h
		mov	si,141Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1502h
		mov	si,1433h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bl,1
		mov	dx,1808h
		mov	si,10B5h
		call	sub_a_4F10		; Print text DS:SI at position DX

		; input key from keyboard, with echo (wait)
		mov	ah,1
		int	21h			; DOS Services  ah=function 01h
						;  get keybd char al, with echo


; !!! Picopad modification - exit help
		cmp	al,58h			; 'X'
		je	sub_a_486BX2		; Jump if equal
		cmp	al,78h			; 'x'
sub_a_486BX2:	jne	sub_a_486BX3
		jmp	sub_a_486BX

sub_a_486BX3:

		; set graphics videomode
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set palettes
;		mov	ah,0Bh
;		mov	bh,1
;		mov	bl,data_b_15F3
;		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	bl,3
		mov	dx,0
		mov	si,1445h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,200h
		mov	si,15BBh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,300h
		mov	si,15DFh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,400h
		mov	si,156Ch
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,500h
		mov	si,1593h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,600h
		mov	si,1544h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,700h
		mov	si,151Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,800h
		mov	si,14F8h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,900h
		mov	si,14D2h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0A00h
		mov	si,14ACh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0B00h
		mov	si,1495h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0C00h
		mov	si,147Dh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0C00h
		mov	si,1457h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bl,1
		mov	dx,1808h
		mov	si,10B5h
		call	sub_a_4F10		; Print text DS:SI at position DX

		; input key from keybaord, with echo (wait)
		mov	ah,1
		int	21h			; DOS Services  ah=function 01h
						;  get keybd char al, with echo

sub_a_486BX:
		pop	si
		pop	dx
		pop	cx
		pop	bx
;		pop	ax
		retn
sub_a_486B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play intro demo screen

sub_a_4A64	proc	near
		push	ax
		push	bx
		push	cx
		push	bp
		push	di
		push	ds
		push	es
		mov	ah,data_b_004A
		mov	dx,seg seg_b
		mov	es,dx
		mov	ds,dx
		mov	data_b_15F3,ah

		; set graphics videomode
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set palettes
		mov	ah,0Bh
		mov	bh,1
		mov	bl,data_b_15F3
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	cx,661h
		call	sub_a_3BBC
		mov	cx,671h
		call	sub_a_3BBC
		mov	cx,669h
		call	sub_a_3BBC
		mov	cx,1CE9h
		call	sub_a_2E4F

		; print "PANGO"
		mov	bl,3
		mov	dx,1011h
		mov	si,1281h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,807h
		mov	si,1283h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0C15h
		mov	si,1285h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,821h
		mov	si,1287h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1019h
		mov	si,1289h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_5343
loc_a_4AD3:
		call	sub_a_2B0A
		call	sub_a_5353
		mov	dl,0
		call	sub_a_3A2B
		sub	cx,50h
		cmp	cx,1109h
		jne	loc_a_4AD3		; Jump if not equal
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_348D
		call	sub_a_57A9		; Enable output to speaker
		mov	bl,3
		mov	bp,120h
		mov	dl,15h
		mov	dh,0Ch
loc_a_4AFF:
		mov	si,127Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		sub	bp,5
		call	sub_a_4860
		dec	dh
		mov	si,1285h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_5363
		cmp	dh,8
		jne	loc_a_4AFF		; Jump if not equal
		call	sub_a_57B2		; Disable output to speaker
		call	sub_a_5363
		call	sub_a_2C46
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_30CD
loc_a_4B2D:
		call	sub_a_2F87
		call	sub_a_5363
		mov	dl,0
		call	sub_a_3A2B
		add	cx,1
		cmp	cx,1125h
		jne	loc_a_4B2D		; Jump if not equal
loc_a_4B41:
		call	sub_a_2B0A
		call	sub_a_5353
		mov	dl,0
		call	sub_a_3A2B
		sub	cx,50h
		cmp	cx,9A5h
		jne	loc_a_4B41		; Jump if not equal
		call	sub_a_5363
		call	sub_a_332C
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_38C4
		call	sub_a_57A9		; Enable output to speaker
		mov	bl,3
		mov	bp,120h
		mov	dx,821h
loc_a_4B72:
		mov	si,127Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		sub	bp,5
		call	sub_a_4860
		dec	dl
		mov	si,1287h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_5363
		cmp	dl,17h
		jne	loc_a_4B72		; Jump if not equal
		call	sub_a_57B2		; Disable output to speaker
		call	sub_a_5363
		call	sub_a_332C
loc_a_4B97:
		call	sub_a_2B2A
		call	sub_a_5353
		mov	dl,0
		call	sub_a_3A2B
		add	cx,50h
		cmp	cx,1625h
		jne	loc_a_4B97		; Jump if not equal
		call	sub_a_5363
		call	sub_a_332C
loc_a_4BB1:
		call	sub_a_2FAB
		call	sub_a_5363
		mov	dl,0
		call	sub_a_3A2B
		dec	cx
		cmp	cx,1611h
		jne	loc_a_4BB1		; Jump if not equal
		call	sub_a_5363
		call	sub_a_2C46
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_348D
		call	sub_a_57A9		; Enable output to speaker
		mov	bl,3
		mov	bp,120h
		mov	dx,1019h
loc_a_4BE0:
		mov	si,127Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		sub	bp,5
		call	sub_a_4860
		dec	dh
		mov	si,1289h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_5363
		cmp	dh,8
		jne	loc_a_4BE0		; Jump if not equal
		call	sub_a_57B2		; Disable output to speaker
		call	sub_a_5363
		call	sub_a_2C46
loc_a_4C05:
		call	sub_a_2B0A
		call	sub_a_5353
		mov	dl,0
		call	sub_a_3A2B
		sub	cx,50h
		cmp	cx,1111h
		jne	loc_a_4C05		; Jump if not equal
		call	sub_a_5363
		call	sub_a_332C
loc_a_4C1F:
		call	sub_a_2FAB
		call	sub_a_5363
		mov	dl,0
		call	sub_a_3A2B
		dec	cx
		cmp	cx,10E8h
		jne	loc_a_4C1F		; Jump if not equal
		call	sub_a_5363
		call	sub_a_2C46
loc_a_4C37:
		call	sub_a_2B0A
		call	sub_a_5353
		mov	dl,0
		call	sub_a_3A2B
		sub	cx,50h
		cmp	cx,968h
		jne	loc_a_4C37		; Jump if not equal
		call	sub_a_5363
		call	sub_a_30CD
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_375B
		call	sub_a_57A9		; Enable output to speaker
		mov	bl,3
		mov	bp,120h
		mov	dx,807h
loc_a_4C68:
		mov	si,127Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		sub	bp,5
		call	sub_a_4860
		inc	dl
		mov	si,1283h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_5363
		cmp	dl,13h
		jne	loc_a_4C68		; Jump if not equal
		call	sub_a_57B2		; Disable output to speaker
loc_a_4C87:
		call	sub_a_2B2A
		call	sub_a_5353
		mov	dl,0
		call	sub_a_3A2B
		add	cx,50h
		cmp	cx,15E8h
		jne	loc_a_4C87		; Jump if not equal
		call	sub_a_5363
		call	sub_a_30CD
loc_a_4CA1:
		call	sub_a_2F87
		call	sub_a_5363
		mov	dl,0
		call	sub_a_3A2B
		inc	cx
		cmp	cx,1601h
		jne	loc_a_4CA1		; Jump if not equal
		call	sub_a_2C46
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_5363
		call	sub_a_348D
		call	sub_a_57A9		; Enable output to speaker
		mov	bl,3
		mov	bp,120h
		mov	dx,1011h
loc_a_4CCD:
		mov	si,127Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		sub	bp,5
		call	sub_a_4860
		dec	dh
		mov	si,1281h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_5363
		cmp	dh,8
		jne	loc_a_4CCD		; Jump if not equal
		call	sub_a_5363
		call	sub_a_2C46
		call	sub_a_2E4F
		mov	dx,150Bh
		mov	si,1259h
		mov	bl,3
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,170Eh
		mov	si,126Fh
		mov	bl,3
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bl,3
loc_a_4D0A:
		mov	dx,811h
		mov	si,1281h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_4E16
		call	sub_a_4DA1
		call	sub_a_5353
		cmp	bl,67h			; 'g'
		je	loc_a_4D23		; Jump if equal
		inc	bl
loc_a_4D23:
		mov	dx,813h
		mov	si,1283h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_4E16
		call	sub_a_4DA1
		call	sub_a_5353
		cmp	bl,67h			; 'g'
		je	loc_a_4D3C		; Jump if equal
		inc	bl
loc_a_4D3C:
		mov	dx,815h
		mov	si,1285h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_4E16
		call	sub_a_4DA1
		call	sub_a_5353
		cmp	bl,67h			; 'g'
		je	loc_a_4D55		; Jump if equal
		inc	bl
loc_a_4D55:
		mov	bp,6B2h
		call	sub_a_4860
		mov	dx,817h
		mov	si,1287h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_4E16
		call	sub_a_4DA1
		call	sub_a_5353
		cmp	bl,67h			; 'g'
		je	loc_a_4D74		; Jump if equal
		inc	bl
loc_a_4D74:
		mov	dx,819h
		mov	si,1289h
		call	sub_a_4F10		; Print text DS:SI at position DX
		call	sub_a_4E16
		call	sub_a_4DA1
		call	sub_a_5353
		cmp	bl,67h			; 'g'
		je	loc_a_4D96		; Jump if equal
		inc	bl
		mov	bp,54Ch
		call	sub_a_4860
		jmp	loc_a_4D0A
loc_a_4D96:
		call	sub_a_57B2		; Disable output to speaker
		pop	es
		pop	ds
		pop	di
		pop	bp
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_4A64	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4DA1	proc	near
		push	dx
		push	cx
		mov	cx,96Ah
		mov	dx,186Ah
		call	sub_a_4DB8
		mov	cx,9A5h
		mov	dx,18A5h
		call	sub_a_4DB8
		pop	cx
		pop	dx
		retn
sub_a_4DA1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4DB8	proc	near
		push	bx
		push	cx
		and	bl,38h			; '8'
loc_a_4DBD:
		cmp	bl,0
		jne	loc_a_4DC8		; Jump if not equal
		call	sub_a_3A5B
		jmp	short loc_a_4E0B
		db	90h
loc_a_4DC8:
		cmp	bl,8
		jne	loc_a_4DD3		; Jump if not equal
		call	sub_a_2550
		jmp	short loc_a_4E0B
		db	90h
loc_a_4DD3:
		cmp	bl,10h
		jne	loc_a_4DDE		; Jump if not equal
		call	sub_a_3A5B
		jmp	short loc_a_4E0B
		db	90h
loc_a_4DDE:
		cmp	bl,18h
		jne	loc_a_4DE9		; Jump if not equal
		call	sub_a_2496
		jmp	short loc_a_4E0B
		db	90h
loc_a_4DE9:
		cmp	bl,20h			; ' '
		jne	loc_a_4DF4		; Jump if not equal
		call	sub_a_3A5B
		jmp	short loc_a_4E0B
		db	90h
loc_a_4DF4:
		cmp	bl,28h			; '('
		call	sub_a_26F6
		jmp	short loc_a_4E0B
			                        ;* No entry point to code
		nop
		cmp	bl,30h			; '0'
		jne	loc_a_4E08		; Jump if not equal
		call	sub_a_3A5B
		jmp	short loc_a_4E0B
		db	90h
loc_a_4E08:
		call	sub_a_26FE
loc_a_4E0B:
		add	cx,280h
		cmp	cx,dx
		jne	loc_a_4DBD		; Jump if not equal
		pop	cx
		pop	bx
		retn
sub_a_4DB8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4E16	proc	near
		cmp	cx,1601h
		jb	loc_a_4E2E		; Jump if below
		cmp	cx,1609h
		je	loc_a_4E2E		; Jump if equal
		mov	dl,0
		call	sub_a_3A2B
		inc	cx
		call	sub_a_2F87
		jmp	short loc_ret_a_4E45
		db	90h
loc_a_4E2E:
		cmp	cx,0E89h
		je	loc_a_4E42		; Jump if equal
		mov	dl,0
		call	sub_a_3A2B
		sub	cx,50h
		call	sub_a_2B0A
		jmp	short loc_ret_a_4E45
		db	90h
loc_a_4E42:
		call	sub_a_2E4F

loc_ret_a_4E45:
		retn
sub_a_4E16	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Game menu

sub_a_4E46	proc	near
		push	bx
		push	cx
		push	dx
		push	si
		push	ds
		push	es
		mov	ah,data_b_004A
		mov	dx,seg seg_b
		mov	es,dx
		mov	ds,dx
		mov	data_b_15F3,ah
loc_a_4E5B:
		cmp	byte ptr data_b_15F3,0
		jne	loc_a_4E71		; Jump if not equal

		; set text videomode
		mov	ax,1
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set palettes
		mov	ah,0Bh
		mov	bx,1
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		jmp	short loc_a_4E76
		db	90h
loc_a_4E71:
		; set text videomode
		mov	ax,0
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
loc_a_4E76:
		mov	bl,0Eh
		call	sub_a_532D

		; display frame top
		mov	dx,607h
		mov	si,1111h
		call	sub_a_4F10		; Print text DS:SI at position DX

		mov	dx,707h
		mov	si,1145h
		call	sub_a_4F10		; Print text DS:SI at position DX

		; print menu "1 : Level...
		mov	dx,807h
		mov	si,115Fh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,907h
		mov	si,1179h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0A07h
		mov	si,1193h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0B07h
		mov	si,11ADh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0C07h
		mov	si,11C7h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0D07h
		mov	si,11E1h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0E07h
		mov	si,11FBh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,0F07h
		mov	si,1215h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1007h
		mov	si,1145h
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,1107h
		mov	si,112Bh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	dx,180Ch
		mov	si,122Fh
		call	sub_a_4F10		; Print text DS:SI at position DX

		; input key from keyboard, with echo (wait)
		mov	ah,1
		int	21h			; DOS Services  ah=function 01h
						;  get keybd char al, with echo
		mov	ah,al
		cmp	ah,50h			; 'P'
		je	loc_a_4F03		; Jump if equal
		cmp	ah,70h			; 'p'
		je	loc_a_4F03		; Jump if equal
		jmp	short loc_a_4F09	; help
		db	90h

		; display help
loc_a_4F03:
		call	sub_a_486B		; Display help
		jmp	loc_a_4E5B
loc_a_4F09:
		pop	es
		pop	ds
		pop	si
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_4E46	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print text DS:SI at position DX

sub_a_4F10	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
loc_a_4F15:
		; set cursor position
		mov	bh,0
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx

		; print character
		mov	cx,1
		mov	bh,0
		mov	ah,9
		mov	al,[si]
		cmp	al,24h			; '$'
		je	loc_a_4F2F		; Jump if equal
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		inc	si
		inc	dl
		jmp	short loc_a_4F15
loc_a_4F2F:
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_4F10	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; load and display high score

sub_a_4F35	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	ds
		push	es
		push	dx
		push	dx
		mov	dx,seg seg_b
		mov	es,dx
		cmp	byte ptr data_b_004A,0
		jne	loc_a_4F51		; Jump if not equal
		mov	ax,1
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		jmp	short loc_a_4F56
		db	90h
loc_a_4F51:
		mov	ax,0
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
loc_a_4F56:
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,11h
		int	21h			; DOS Services  ah=function 11h
						;  find filename, FCB @ ds:dx
		cmp	al,0FFh
		jne	loc_a_4F73		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,16h
		int	21h			; DOS Services  ah=function 16h
						;  creat/truncat file FCB @ds:dx
		call	sub_a_5373
loc_a_4F73:
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh
						;  open file, FCB @ ds:dx
		call	sub_a_532D
		mov	dx,seg seg_b
		mov	ds,dx
		mov	dx,10Ah
		mov	si,10A2h
		mov	bl,0Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		pop	dx
		add	dh,31h			; '1'
		mov	byte ptr data_b_1230+25h,dh	; (' ')
		mov	dx,30Fh
		mov	si,124Fh
		mov	bl,0Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		pop	dx
		mov	ch,6
		mov	dl,0
loc_a_4FA9:
		call	sub_a_5250
		add	ch,3
		inc	dl
		cmp	dl,5
		jne	loc_a_4FA9		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,10h
		int	21h			; DOS Services  ah=function 10h
						;  close file, FCB @ ds:dx
		mov	dx,seg seg_b
		mov	ds,dx
		mov	dx,1706h
		mov	si,10B5h
		mov	bl,0Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	ah,7
		int	21h			; DOS Services  ah=function 07h
						;  get keybd char al, no echo
		pop	es
		pop	ds
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_4F35	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_4FDC	proc	near
		push	dx
		push	si
		push	ds
		push	es
		push	bp
		push	dx
		mov	dx,seg seg_b
		mov	es,dx
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,11h
		int	21h			; DOS Services  ah=function 11h
						;  find filename, FCB @ ds:dx
		cmp	al,0FFh
		jne	loc_a_5004		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,16h
		int	21h			; DOS Services  ah=function 16h
						;  creat/truncat file FCB @ds:dx
		call	sub_a_5373
loc_a_5004:
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh
						;  open file, FCB @ ds:dx
		pop	dx
		mov	data_b_1010,dl
		call	sub_a_51A6
		mov	al,dh
		mul	data_b_15F2		; ax = data * al
		mov	bp,ax
		mov	si,offset data_b_0000
loc_a_5022:
		mov	bl,ds:data_b_1021[bp+si]
		mov	data_b_1015[si],bl
		inc	si
		cmp	si,6
		jne	loc_a_5022		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,10h
		int	21h			; DOS Services  ah=function 10h
						;  close file, FCB @ ds:dx
		mov	ah,data_b_1015
		mov	al,data_b_1016
		mov	bh,data_b_1017
		mov	bl,data_b_1018
		mov	ch,data_b_1019
		mov	cl,data_b_101A
		pop	bp
		pop	es
		pop	ds
		pop	si
		pop	dx
		retn
sub_a_4FDC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Write high score table

sub_a_5059	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	ds
		push	es
		push	dx
		mov	dx,seg seg_b
		mov	es,dx
		mov	data_b_1015,ah
		mov	data_b_1016,al
		mov	data_b_1017,bh
		mov	data_b_1018,bl
		mov	data_b_1019,ch
		mov	data_b_101A,cl
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,11h
		int	21h			; DOS Services  ah=function 11h
						;  find filename, FCB @ ds:dx
		cmp	al,0FFh
		jne	loc_a_509A		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,16h
		int	21h			; DOS Services  ah=function 16h
						;  creat/truncat file FCB @ds:dx
		call	sub_a_5373
loc_a_509A:
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh
						;  open file, FCB @ ds:dx
		pop	dx
		call	sub_a_52D9
		call	sub_a_50CD
		call	sub_a_51DC		; High score table
		call	sub_a_5129
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,10h
		int	21h			; DOS Services  ah=function 10h
						;  close file, FCB @ ds:dx
		call	sub_a_5343
		mov	ax,3
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		pop	es
		pop	ds
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_5059	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_50CD	proc	near
		push	ax
		push	cx
		push	dx
		push	si
		push	bp
		cmp	cl,4
		jge	loc_a_5123		; Jump if > or =
		mov	ch,3
loc_a_50D9:
		mov	data_b_1010,ch
		call	sub_a_51A6
		mov	si,offset data_b_0000
		mov	al,dh
		mul	data_b_15F2		; ax = data * al
		mov	bp,ax
loc_a_50EB:
		mov	al,ds:data_b_1021[bp+si]
		mov	data_b_10F8[si],al
		inc	si
		cmp	si,19h
		jne	loc_a_50EB		; Jump if not equal
		inc	ch
		mov	data_b_1010,ch
		call	sub_a_51A6
		mov	si,offset data_b_0000
loc_a_5106:
		mov	al,data_b_10F8[si]
		mov	ds:data_b_1021[bp+si],al
		inc	si
		cmp	si,19h
		jne	loc_a_5106		; Jump if not equal
		mov	data_b_1010,ch
		call	sub_a_51C1
		sub	ch,2
		cmp	ch,cl
		jge	loc_a_50D9		; Jump if > or =
loc_a_5123:
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	ax
		retn
sub_a_50CD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5129	proc	near
		push	ax
		push	cx
		push	dx
		push	si
		push	bp
		mov	data_b_1010,cl
		call	sub_a_51A6
		mov	al,dh
		mul	data_b_15F2		; ax = data * al
		mov	bp,ax
		mov	si,offset data_b_0000
		mov	ah,0
loc_a_5142:
		mov	ds:data_b_1021[bp+si],ah
		inc	si
		cmp	si,13h
		jne	loc_a_5142		; Jump if not equal
		mov	ah,data_b_1015
		mov	ds:data_b_1021[bp],ah
		mov	ah,data_b_1016
		mov	ds:data_b_1022[bp],ah
		mov	ah,data_b_1017
		mov	ds:data_b_1023[bp],ah
		mov	ah,data_b_1018
		mov	ds:data_b_1024[bp],ah
		mov	ah,data_b_1019
		mov	ds:data_b_1025[bp],ah
		mov	ah,data_b_101A
		mov	ds:data_b_1026[bp],ah
		mov	si,0
loc_a_5186:
		mov	ah,1
		int	21h			; DOS Services  ah=function 01h
						;  get keybd char al, with echo
		cmp	al,0Dh
		je	loc_a_5199		; Jump if equal
		mov	ds:data_b_1027[bp+si],al
		inc	si
		cmp	si,12h
		jne	loc_a_5186		; Jump if not equal
loc_a_5199:
		mov	data_b_1010,cl
		call	sub_a_51C1
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	ax
		retn
sub_a_5129	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_51A6	proc	near
		push	ax
		push	dx
		mov	dx,offset data_b_1021
		mov	ax,es
		mov	ds,ax
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,14h
		int	21h			; DOS Services  ah=function 14h
						;  sequentl file read FCB @ds:dx
						;   returns al=0 ok, not 0=error
		pop	dx
		pop	ax
		retn
sub_a_51A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_51C1	proc	near
		push	ax
		push	dx
		mov	dx,offset data_b_1021
		mov	ax,es
		mov	ds,ax
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,15h
		int	21h			; DOS Services  ah=function 15h
						;  sequent file write FCB @ds:dx
						;   returns al=0 ok, not 0=error
		pop	dx
		pop	ax
		retn
sub_a_51C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; High score table

sub_a_51DC	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	bp
		push	dx
		push	dx
		cmp	byte ptr data_b_15F3,0
		jne	loc_a_51F3		; Jump if not equal
		mov	ax,1
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		jmp	short loc_a_51F8
		db	90h
loc_a_51F3:
		mov	ax,0
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
loc_a_51F8:
		mov	dx,10Ah
		mov	si,10A2h
		mov	bl,0Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		pop	dx
		add	dh,31h			; '1'
		mov	byte ptr data_b_1230+25h,dh	; (' ')
		mov	si,124Fh
		mov	dx,30Fh
		mov	bl,0Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		pop	dx
		mov	ch,6
		mov	dl,0
loc_a_521B:
		cmp	dl,cl
		jne	loc_a_5226		; Jump if not equal
		call	sub_a_529D
		push	cx
		jmp	short loc_a_5229
		db	90h
loc_a_5226:
		call	sub_a_5250
loc_a_5229:
		add	ch,3
		inc	dl
		cmp	dl,5
		jne	loc_a_521B		; Jump if not equal
		mov	dx,170Bh
		mov	si,123Eh
		mov	bl,0Eh
		call	sub_a_4F10		; Print text DS:SI at position DX
		mov	bh,0
		mov	ah,2
		pop	cx
		mov	dh,ch
		mov	dl,3
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		pop	bp
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_51DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5250	proc	near
		push	si
		push	bx
		push	cx
		push	dx
		mov	data_b_1010,dl
		call	sub_a_51A6
		mov	si,offset data_b_0000
		mov	al,dh
		mul	data_b_15F2		; ax = data * al
		mov	bx,ax
loc_a_5266:
		mov	cl,data_b_1027[bx+si]
		mov	data_b_10D2[si],cl
		inc	si
		cmp	si,13h
		jne	loc_a_5266		; Jump if not equal
		mov	si,offset data_b_0000
loc_a_5277:
		mov	cl,data_b_1021[bx+si]
		mov	data_b_10F1[si],cl
		inc	si
		cmp	si,6
		jne	loc_a_5277		; Jump if not equal
		add	dl,31h			; '1'
		mov	byte ptr data_b_10A1+2Eh,dl	; ('1')
		mov	dl,0
		mov	dh,ch
		mov	si,10CFh
		mov	bl,0Bh
		call	sub_a_4F10		; Print text DS:SI at position DX
		pop	dx
		pop	cx
		pop	bx
		pop	si
		retn
sub_a_5250	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_529D	proc	near
		push	si
		push	bx
		push	cx
		push	dx
		mov	si,offset data_b_0000
loc_a_52A4:
		mov	bl,0
		mov	data_b_10D2[si],bl
		inc	si
		cmp	si,13h
		jne	loc_a_52A4		; Jump if not equal
		mov	si,offset data_b_0000
loc_a_52B3:
		mov	bl,data_b_1015[si]
		mov	data_b_10F1[si],bl
		inc	si
		cmp	si,6
		jne	loc_a_52B3		; Jump if not equal
		add	dl,31h			; '1'
		mov	byte ptr data_b_10A1+2Eh,dl	; ('1')
		mov	dl,0
		mov	dh,ch
		mov	si,10CFh
		mov	bl,0Bh
		call	sub_a_4F10		; Print text DS:SI at position DX
		pop	dx
		pop	cx
		pop	bx
		pop	si
		retn
sub_a_529D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_52D9	proc	near
		push	si
		push	bx
		push	dx
		push	bp
		mov	dl,0
loc_a_52DF:
		mov	data_b_1010,dl
		call	sub_a_51A6
		mov	al,dh
		mul	data_b_15F2		; ax = data * al
		mov	bp,ax
		mov	si,offset data_b_0000
loc_a_52F1:
		mov	bl,ds:data_b_1021[bp+si]
		mov	data_b_101B[si],bl
		inc	si
		cmp	si,6
		jne	loc_a_52F1		; Jump if not equal
		mov	si,offset data_b_0000
loc_a_5303:
		mov	bl,data_b_101B[si]
		cmp	bl,data_b_1015[si]
		je	loc_a_5316		; Jump if equal
		cmp	bl,data_b_1015[si]
		jg	loc_a_531F		; Jump if >
		jmp	short loc_a_5326
		db	90h
loc_a_5316:
		inc	si
		cmp	si,6
		jne	loc_a_5303		; Jump if not equal
		jmp	short loc_a_5326
		db	90h
loc_a_531F:
		inc	dl
		cmp	dl,6
		jne	loc_a_52DF		; Jump if not equal
loc_a_5326:
		mov	cl,dl
		pop	bp
		pop	dx
		pop	bx
		pop	si
		retn
sub_a_52D9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_532D	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	cx,0
		mov	dx,1827h
		mov	bh,7
		mov	ax,600h
		int	10h			; Video display   ah=functn 06h
						;  scroll up, al=lines
						;   bh=attrib, cx+dx=window size
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_532D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5343	proc	near
		push	bx
		push	cx
		mov	bl,5
loc_a_5347:
		mov	cx,0FA00h

locloop_a_534A:
		loop	locloop_a_534A		; Loop if cx > 0

		dec	bl
		jnz	loc_a_5347		; Jump if not zero
		pop	cx
		pop	bx
		retn
sub_a_5343	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5353	proc	near
		push	bx
		push	cx
		mov	bl,4
loc_a_5357:
		mov	cx,3E8h

locloop_a_535A:
		loop	locloop_a_535A		; Loop if cx > 0

		dec	bl
		jnz	loc_a_5357		; Jump if not zero
		pop	cx
		pop	bx
		retn
sub_a_5353	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5363	proc	near
		push	bx
		push	cx
		mov	bl,7
loc_a_5367:
		mov	cx,3E8h

locloop_a_536A:
		loop	locloop_a_536A		; Loop if cx > 0

		dec	bl
		jnz	loc_a_5367		; Jump if not zero
		pop	cx
		pop	bx
		retn
sub_a_5363	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5373	proc	near
		push	ax
		push	bx
		push	cx
		push	si
		push	bp
		mov	cl,0
		mov	bx,0
loc_a_537D:
		mov	data_b_1010,cl
		mov	dx,offset data_b_1021
		mov	ax,es
		mov	ds,ax
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx
		mov	bp,offset data_b_0000
loc_a_538F:
		mov	ah,1
		mov	ds:data_b_1027[bp],ah
		mov	si,offset data_b_0000
loc_a_5399:
		mov	ah,30h			; '0'
		mov	ds:data_b_1021[bp+si],ah
		inc	si
		cmp	si,6
		jne	loc_a_5399		; Jump if not equal
		add	bp,19h
		cmp	bp,7Dh
		jne	loc_a_538F		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,15h
		int	21h			; DOS Services  ah=function 15h
						;  sequent file write FCB @ds:dx
						;   returns al=0 ok, not 0=error
		inc	cl
		add	bx,6
		cmp	cl,5
		jne	loc_a_537D		; Jump if not equal
		mov	dx,offset data_b_0FF0
		mov	ax,es
		mov	ds,ax
		mov	ah,10h
		int	21h			; DOS Services  ah=function 10h
						;  close file, FCB @ ds:dx
		pop	bp
		pop	si
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_5373	endp

		db	12 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_53E0	proc	near
		push	bx
		push	cx
		push	dx
		push	ds
		mov	cx,seg seg_b
		mov	ds,cx
		mov	ch,0
		call	sub_a_548C
		cmp	ch,1
		je	loc_a_545B		; Jump if equal
		mov	data_b_1600,0
		mov	data_b_1602,0
		mov	dx,201h
		mov	al,0FFh
		out	dx,al			; port 201h, start game 1-shots
loc_a_5405:
		in	al,dx			; port 201h, start game 1-shots
		mov	ah,al
		mov	bl,ah
		and	al,1
		jz	loc_a_5412		; Jump if zero
		inc	data_b_1600
loc_a_5412:
		and	ah,2
		jz	loc_a_541B		; Jump if zero
		inc	data_b_1602
loc_a_541B:
		and	bl,3
		jz	loc_a_5422		; Jump if zero
		jmp	short loc_a_5405
loc_a_5422:
		mov	cx,data_b_1600
		mov	dx,data_b_1602
		cmp	data_b_1600,0Ch
		jl	loc_a_544B		; Jump if <
		cmp	data_b_1600,3Ch
		ja	loc_a_544B		; Jump if above
		cmp	data_b_1602,0Ch
		jl	loc_a_544B		; Jump if <
		cmp	data_b_1602,3Ch
		ja	loc_a_544B		; Jump if above
		mov	al,0
		jmp	short loc_a_545B
		db	90h
loc_a_544B:
		cmp	cx,dx
		jl	loc_a_5455		; Jump if <
		call	sub_a_5462
		jmp	short loc_a_545B
		db	90h
loc_a_5455:
		call	sub_a_5477
		jmp	short loc_a_545B
		db	90h
loc_a_545B:
		mov	ah,al
		pop	ds
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_53E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5462	proc	near
		push	bx
		push	cx
		push	dx
		add	cx,dx
		cmp	cx,4Bh
		ja	loc_a_5471		; Jump if above
		mov	al,8
		jmp	short loc_a_5473
		db	90h
loc_a_5471:
		mov	al,1
loc_a_5473:
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_5462	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_5477	proc	near
		push	bx
		push	cx
		push	dx
		add	cx,dx
		cmp	cx,46h
		ja	loc_a_5486		; Jump if above
		mov	al,2
		jmp	short loc_a_5488
		db	90h
loc_a_5486:
		mov	al,4
loc_a_5488:
		pop	dx
		pop	cx
		pop	bx
		retn
sub_a_5477	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_548C	proc	near
		push	bx
		push	dx
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		and	al,30h			; '0'
		jz	loc_a_54A3		; Jump if zero
		cmp	al,10h
		je	loc_a_54A3		; Jump if equal
		cmp	al,20h			; ' '
		je	loc_a_54A3		; Jump if equal
		mov	ch,0
		jmp	short loc_a_54A7
		db	90h
loc_a_54A3:
		mov	ch,1
		mov	al,39h			; '9'
loc_a_54A7:
		pop	dx
		pop	bx
		retn
sub_a_548C	endp

		db	0, 0, 0, 0, 0, 0
data_a_54B0	db	3
data_a_54B1	db	5
data_a_54B2	db	1
data_a_54B3	dw	0
data_a_54B5	dw	0
data_a_54B7	dw	0
data_a_54B9	dw	0
data_a_54BB	dw	30h			; Data table (indexed access)
		db	 93h, 1Ch, 30h, 15h,0DCh, 11h
		db	 49h, 0Eh, 30h, 00h, 49h, 0Eh
		db	 65h, 0Dh, 49h, 0Eh, 12h, 10h
		db	0DCh, 11h, 42h, 13h,0DCh, 11h
		db	 30h, 00h,0DCh, 11h, 12h, 10h
		db	0DCh, 11h, 42h, 13h, 30h, 15h
		db	0A0h, 16h, 30h, 15h, 30h, 15h
		db	0C9h, 1Ah,0C9h, 1Ah,0C9h, 1Ah
		db	 30h, 15h,0C9h, 1Ah, 30h, 15h
		db	0DCh, 11h,0DCh, 11h, 42h, 13h
		db	 42h, 13h, 30h, 00h, 93h, 1Ch
		db	 30h, 15h,0DCh, 11h, 49h, 0Eh
		db	 30h, 00h, 49h, 0Eh, 65h, 0Dh
		db	 49h, 0Eh, 12h, 10h,0DCh, 11h
		db	 42h, 13h,0DCh, 11h, 30h, 00h
		db	0DCh, 11h, 12h, 10h,0DCh, 11h
		db	 42h, 13h, 30h, 15h,0A0h, 16h
		db	 30h, 15h,0DCh, 11h,0DCh, 11h
		db	 30h, 15h, 49h, 0Eh, 49h, 0Eh
		db	 93h, 1Ch, 93h, 1Ch,0C0h, 18h
		db	0C0h, 18h,0A0h, 16h,0A0h, 16h
		db	 30h, 15h, 30h, 15h, 30h, 15h
		db	 30h, 00h, 42h, 13h, 30h, 00h
		db	 42h, 13h, 42h, 13h, 42h, 13h
		db	 49h, 0Eh, 12h, 10h,0DCh, 11h
		db	 42h, 13h,0DCh, 11h, 30h, 15h
		db	0DCh, 11h, 42h, 13h, 30h, 00h
		db	 42h, 13h, 42h, 13h, 42h, 13h
		db	 49h, 0Eh, 12h, 10h,0DCh, 11h
		db	 42h, 13h, 93h, 1Ch,0C0h, 18h
		db	0A0h, 16h, 30h, 15h, 42h, 13h
		db	0DCh, 11h, 30h, 15h, 12h, 10h
		db	 65h, 0Dh, 49h, 0Eh, 12h, 10h
		db	0DCh, 11h, 42h, 13h, 30h, 15h
		db	0A0h, 16h, 30h, 15h, 30h, 15h
		db	 30h, 15h, 30h, 15h, 42h, 13h
		db	 42h, 13h, 42h, 13h, 42h, 13h
		db	0DCh, 11h,0DCh, 11h,0DCh, 11h
		db	0DCh, 11h
data_a_55A3	dw	8EEh			; Data table (indexed access)
		db	0A1h, 09h, 98h, 0Ah,0EEh, 08h
		db	0A1h, 09h, 98h, 0Ah,0E8h, 0Bh
		db	 98h, 0Ah,0A1h, 09h, 30h, 00h
		db	 30h, 00h, 30h, 00h, 30h, 00h
		db	 30h, 00h, 30h, 00h, 30h, 00h
		db	 30h, 00h, 30h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play sound

sub_a_55C7	proc	near
		push	ax
		push	cx
		push	dx
		mov	dl,data_b_013B
		cmp	dl,0
		jne	loc_a_55E1		; Jump if not equal
		cmp	cs:data_a_54B2,0
		je	loc_a_564A		; Jump if equal
		call	sub_a_564E		; Play sound
		jmp	short loc_a_564A
		db	90h
loc_a_55E1:
		cmp	dl,9
		jne	loc_a_55EF		; Jump if not equal
		mov	cs:data_a_54B2,1
		jmp	short loc_a_5645
		db	90h
loc_a_55EF:
		cmp	dl,8
		jne	loc_a_55FD		; Jump if not equal
		mov	cs:data_a_54B2,0
		jmp	short loc_a_563C
		db	90h
loc_a_55FD:
		cmp	dl,7
		jne	loc_a_560C		; Jump if not equal
		mov	cs:data_a_54B7,0
		jmp	short loc_a_5645
		db	90h
loc_a_560C:
		cmp	dl,2
		jne	loc_a_5614		; Jump if not equal
		jmp	short loc_a_563C
		db	90h
loc_a_5614:
		cmp	dl,1
		jne	loc_a_561C		; Jump if not equal
		jmp	short loc_a_563C
		db	90h
loc_a_561C:
		cmp	dl,5
		jne	loc_a_562F		; Jump if not equal
		cmp	cs:data_a_54B2,0
		je	loc_a_564A		; Jump if equal
		call	sub_a_56E3		; Play sound
		jmp	short loc_a_564A
		db	90h
loc_a_562F:
		cmp	byte ptr data_b_013B,6
		jne	loc_a_563C		; Jump if not equal
		call	sub_a_5776		; Play 2 tones
		jmp	short loc_a_5645
		db	90h
loc_a_563C:
		mov	ax,30h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
loc_a_5645:
		mov	byte ptr data_b_013B,0
loc_a_564A:
		pop	dx
		pop	cx
		pop	ax
		retn
sub_a_55C7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play sound

sub_a_564E	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	ax,cs:data_a_54B7
		cmp	ax,0
		jne	loc_a_567C		; Jump if not equal
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	cs:data_a_54B5,dx
		mov	cs:data_a_54B3,cx
		mov	ax,cs:data_a_54BB
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		add	cs:data_a_54B7,2
		jmp	short loc_a_56DE
		db	90h
loc_a_567C:
		mov	ax,data_b_004D
		mov	ah,data_b_013C
		add	al,ah
		mov	ah,0
		div	cs:data_a_54B0		; al,ah rem = ax/data
		mov	bl,cs:data_a_54B1
		sub	bl,al
		mov	bh,0
		cmp	bl,1
		jg	loc_a_569D		; Jump if >
		mov	bx,1
loc_a_569D:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,cs:data_a_54B5
		cmp	ax,bx
		jl	loc_a_56DE		; Jump if <
		mov	bx,cs:data_a_54B7
		mov	ax,cs:data_a_54BB[bx]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	cs:data_a_54B3,cx
		mov	cs:data_a_54B5,dx
		add	cs:data_a_54B7,2
		mov	bx,cs:data_a_54B7
		cmp	bx,0E8h
		jl	loc_a_56DE		; Jump if <
		sub	cs:data_a_54B7,0E8h
loc_a_56DE:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_564E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play sound

sub_a_56E3	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		mov	ax,cs:data_a_54B9
		cmp	ax,0
		jne	loc_a_5711		; Jump if not equal
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	cs:data_a_54B5,dx
		mov	cs:data_a_54B3,cx
		mov	ax,cs:data_a_55A3
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		add	cs:data_a_54B9,2
		jmp	short loc_a_5771
		db	90h
loc_a_5711:
		mov	ax,data_b_004D
		mov	ah,data_b_013C
		add	al,ah
		mov	ah,0
		div	cs:data_a_54B0		; al,ah rem = ax/data
		mov	bl,cs:data_a_54B0
		sub	bl,al
		mov	bh,0
		cmp	bl,1
		jg	loc_a_5732		; Jump if >
		mov	bx,1
loc_a_5732:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,cs:data_a_54B5
		cmp	ax,bx
		jl	loc_a_5771		; Jump if <
		mov	bx,cs:data_a_54B9
		mov	ax,cs:data_a_55A3[bx]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	cs:data_a_54B3,cx
		mov	cs:data_a_54B5,dx
		add	cs:data_a_54B9,2
		mov	bx,cs:data_a_54B9
		cmp	bx,24h
		jl	loc_a_5771		; Jump if <
		sub	cs:data_a_54B9,24h
loc_a_5771:
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_a_56E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play 2 tones

sub_a_5776	proc	near
		push	ax
		push	cx
		mov	cx,0Ah

locloop_a_577B:
		mov	ax,8EEh
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		call	sub_a_57A1		; Short delay
		mov	ax,0A98h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		call	sub_a_57A1		; Short delay
		loop	locloop_a_577B		; Loop if cx > 0

		mov	ax,30h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		pop	cx
		pop	ax
		retn
sub_a_5776	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Short delay

sub_a_57A1	proc	near
		push	cx
		mov	cx,1388h

locloop_a_57A5:
		loop	locloop_a_57A5		; Loop if cx > 0

		pop	cx
		retn
sub_a_57A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Enable output to speaker

sub_a_57A9	proc	near
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		retn
sub_a_57A9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Disable output to speaker

sub_a_57B2	proc	near
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		retn
sub_a_57B2	endp

		db	0, 0, 0, 0, 0

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_c

data_b_0000	dw	0
data_b_0002	dw	1C93h			; Data table (indexed access)
		db	20h
data_b_0005	db	0
		db	 93h, 1Ch, 20h, 00h, 93h, 1Ch
		db	 20h, 00h,0CFh, 17h,0C0h, 18h
		db	0C0h, 18h, 93h, 1Ch, 93h, 1Ch
		db	 00h, 1Eh, 93h, 1Ch, 93h, 1Ch
		db	 93h, 1Ch, 93h, 1Ch
data_b_0022	db	0
data_b_0023	db	4			; Data table (indexed access)
		db	 06h, 08h, 0Ah, 0Ch, 0Eh
data_b_0029	dw	0			; Data table (indexed access)
		db	 25h, 00h, 4Ah, 00h, 6Fh, 00h
		db	 94h, 00h,0B9h, 00h
data_b_0035	dw	1388h			; Data table (indexed access)
		db	0D0h, 07h,0E8h, 03h,0F4h, 01h
		db	 0Ah
		db	0, 0, 0
data_b_0041	db	0
data_b_0042	dw	0
data_b_0044	dw	0
data_b_0046	dw	0
data_b_0048	db	0			; sound setup
data_b_0049	db	0
data_b_004A	db	0
data_b_004B	db	0
data_b_004C	db	0
data_b_004D	dw	0
data_b_004F	db	2			; Data table (indexed access)
		db	3, 4, 5, 6
data_b_0054	dw	3			; Data table (indexed access)
		db	 07h, 00h, 0Fh, 00h, 1Fh, 00h
		db	 3Fh, 00h
data_b_005E	dw	30Ah			; Data table (indexed access)
		db	 01h, 10h, 01h, 03h, 0Ah, 10h
		db	 0Ah, 06h, 01h, 06h
data_b_006A	db	10h
copyright	db	'COPYRIGHT BY SHENG-CHUNG LIU, 19'
		db	'83'
data_b_008D	db	6			; Data table (indexed access)
		db	 06h, 07h, 07h, 08h, 08h, 09h
		db	 09h, 0Ah, 0Ah, 0Bh, 0Bh
data_b_0099	db	0Ch
		db	 0Ch, 0Ch, 0Ch
data_b_009D	db	0
data_b_009E	db	0			; Data table (indexed access)
		db	0
data_b_00A0	db	0			; Data table (indexed access)
data_b_00A1	dw	0			; Data table (indexed access)
data_b_00A3	dw	0			; Data table (indexed access)
data_b_00A5	dw	0
data_b_00A7	dw	0
data_b_00A9	dw	0
data_b_00AB	dw	0
		db	0F4h, 01h
data_b_00AF	db	55h
data_b_00B0	db	0AAh
		db	0FFh, 77h
data_b_00B3	dw	0FFFEh
data_b_00B5	db	2
data_b_00B6	dw	1
data_b_00B8	db	3
data_b_00B9	db	10h
data_b_00BA	db	4
data_b_00BB	dw	4
data_b_00BD	dw	0Ah
data_b_00BF	db	0Ah
data_b_00C0	dw	0Ch
data_b_00C2	db	14h
		db	1Eh
data_b_00C4	db	28h
		db	32h
data_b_00C6	db	0A0h
data_b_00C7	db	12h
data_b_00C8	db	50h
data_b_00C9	db	0
data_b_00CA	dw	444h
data_b_00CC	db	11h
data_b_00CD	db	0Bh
data_b_00CE	dw	0BBh
data_b_00D0	db	0BBh
data_b_00D1	db	0
data_b_00D2	db	4
data_b_00D3	db	8
data_b_00D4	db	0
data_b_00D5	db	0
data_b_00D6	db	1
data_b_00D7	db	0			; Data table (indexed access)
		db	0, 0, 0, 0
data_b_00DC	db	0			; Data table (indexed access)
		db	0
data_b_00DE	db	1			; Data table (indexed access)
		db	2, 3, 4, 5, 6
data_b_00E4	db	1			; Data table (indexed access)
		db	1, 1, 1, 1, 1, 1
data_b_00EB	db	0			; Data table (indexed access)
data_b_00EC	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
data_b_00F2	db	0			; Data table (indexed access)
data_b_00F3	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
data_b_00F9	db	0			; Data table (indexed access)
data_b_00FA	db	0
data_b_00FB	db	0
data_b_00FC	db	0
data_b_00FD	db	0
data_b_00FE	db	0
data_b_00FF	db	0
data_b_0100	db	0
data_b_0101	dw	0
data_b_0103	db	0
data_b_0104	db	0
data_b_0105	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_b_010C	dw	0			; Data table (indexed access)
		db	12 dup (0)
data_b_011A	dw	0			; Data table (indexed access)
data_b_011C	dw	0			; Data table (indexed access)
		db	10 dup (0)
data_b_0128	dw	0			; Data table (indexed access)
data_b_012A	dw	0			; Data table (indexed access)
		db	10 dup (0)
data_b_0136	dw	805h
data_b_0138	db	0
data_b_0139	dw	0
data_b_013B	db	0
data_b_013C	db	0
data_b_013D	db	0
data_b_013E	db	0
data_b_013F	db	30h
		db	 30h, 30h, 30h, 30h, 30h
data_b_0145	dw	0
		db	0, 0
data_b_0149	db	0
		db	0, 0, 0
data_b_014D	dw	2710h
		db	0, 0
data_b_0151	db	'L: $'
		db	'R:  $'
		db	'                 $'
		db	'                                '
		db	'    $'
		db	'SCORE:$'
		db	'HIGH:$'
data_b_019E	db	'000000$'
		db	'BONUS:       PTS$'
		db	' GAME TIME :    Min.    Sec.    '
		db	'    $'
data_b_01DB	db	'00$'
data_b_01DE	db	'0$'
		db	'FROM  0 TO 19 Sec.  ..... 5000 p'
		db	'ts  $'
		db	'FROM 20 TO 29 Sec.  ..... 2000 p'
		db	'ts  $'
		db	'FROM 30 TO 39 Sec.  ..... 1000 p'
		db	'ts  $'
		db	'FROM 40 TO 49 Sec.  .....  500 p'
		db	'tS  $'
		db	'FROM 50 TO 59 Sec.  .....   10 p'
		db	'ts  $'
		db	'FROM 60 and OVER    ..... NO BON'
		db	'US  $'
		db	'High score of which level ? $'
		db	'Do You Use Color Monitor (Y/N) ?'
		db	' $'
		db	'Do You Use Joystick (Y/N) ? $'
		db	' GAME OVER $'
data_b_0326	db	'%'
		db	 07h, 25h, 07h,0B2h, 06h,0F4h
		db	 05h,0F4h, 05h,0B2h, 06h, 25h
		db	 07h, 09h, 08h,0EEh, 08h,0EEh
		db	 08h, 09h, 08h, 25h, 07h, 25h
		db	 07h, 09h, 08h, 09h, 08h, 09h
		db	 08h, 25h, 07h, 25h, 07h,0B2h
		db	 06h,0F4h, 05h,0F4h, 05h,0B2h
		db	 06h, 25h, 07h, 09h, 08h,0EEh
		db	 08h,0EEh, 08h, 09h, 08h, 25h
		db	 07h
data_b_035E	db	9			; Data table (indexed access)
		db	 08h,0EEh, 08h,0EEh, 08h,0EEh
		db	 08h, 00h
		db	7 dup (0)
data_b_036E	db	0			; Data table (indexed access)
data_b_036F	db	0			; Data table (indexed access)
data_b_0370	dw	8			; Data table (indexed access)
data_b_0372	dw	10h
data_b_0374	dw	280h
		db	8 dup (0)
data_b_037E	db	0			; Data table (indexed access)
data_b_037F	db	0			; Data table (indexed access)
data_b_0380	db	1			; Data table (indexed access)
data_b_0381	db	1			; Data table (indexed access)
data_b_0382	db	1			; Data table (indexed access)
		db	13 dup (1)
data_b_0390	db	1			; Data table (indexed access)
data_b_0391	db	1			; Data table (indexed access)
data_b_0392	db	1			; Data table (indexed access)
		db	15 dup (1)
data_b_03A2	db	1			; Data table (indexed access)
		db	152 dup (1)
		db	0, 0, 0, 0, 1, 0
		db	0, 0, 0, 1
		db	7 dup (0)
		db	1, 1, 0, 1, 1, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0, 1, 1, 0
		db	0, 0, 0, 0, 0, 0
		db	1, 0, 3, 0, 1, 0
		db	1, 0, 0, 0, 1, 1
		db	1, 1, 1, 1, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0
		db	7 dup (0)
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 0, 1
		db	0, 3, 1, 1, 0, 0
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 0, 0, 1, 0
		db	1, 0, 0, 1, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	1, 1, 0, 1, 0, 1
		db	0, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 0, 0
		db	0, 0, 1, 0, 1
		db	8 dup (0)
		db	1, 1, 1, 0, 1, 0
		db	0, 0, 1, 0, 0, 1
		db	0, 1, 0, 1, 0, 0
		db	0, 0, 0, 1, 1, 1
		db	11 dup (0)
		db	1, 0
		db	8 dup (0)
		db	1, 1, 1, 1, 1, 1
		db	0, 1, 1, 1, 0, 1
		db	1, 1, 1, 0
		db	8 dup (0)
		db	1, 0
		db	7 dup (0)
		db	1, 1, 1, 1, 0, 1
		db	1, 0, 1, 0, 1, 1
		db	1, 1, 0, 1, 0, 0
		db	1, 0, 0, 0, 0, 1
		db	0, 1, 0, 0, 0, 0
		db	0, 0, 1, 0, 0, 1
		db	1, 1, 0, 3, 1, 0
		db	0, 1, 3, 1, 1, 1
		db	0, 1, 1, 0, 0, 0
		db	1, 0, 1
		db	10 dup (0)
		db	1, 0, 1, 0, 1, 0
		db	1, 0
		db	8 dup (1)
		db	0, 1, 0, 1, 0, 1
		db	10 dup (0)
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 1, 1
		db	1, 1, 0, 1, 0, 1
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	1
		db	7 dup (0)
		db	1, 0, 0, 0, 0, 1
		db	1, 1, 0, 1, 0, 1
		db	1, 1, 0, 1, 0, 1
		db	0, 1, 0, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 0, 1, 0, 1
		db	0, 0, 0, 0, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 0, 1, 0, 1, 0
		db	1, 1, 1, 0, 1, 0
		db	1, 0, 0, 0, 1, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 0, 1, 0, 3
		db	1, 1, 0, 1, 0, 0
		db	1, 1, 1, 1, 1, 0
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1
		db	8 dup (0)
		db	1, 0, 1, 1, 0, 1
		db	1, 1, 1, 0, 0, 1
		db	0, 1, 0, 1
		db	12 dup (0)
		db	1, 0, 1, 0, 1, 0
		db	1, 1, 1, 3, 0, 1
		db	0, 1, 1, 1, 0, 0
		db	0, 1, 0, 1
		db	11 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1, 1, 1, 1
		db	0, 0, 0, 0, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 0, 0, 0, 0, 0
		db	1, 1, 1, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 1, 0, 1
		db	0, 1, 0, 0, 0, 1
		db	0, 3, 0, 1, 0, 1
		db	0, 0, 1, 0, 1, 0
		db	0, 0, 0, 1, 1, 0
		db	1, 0, 1, 0, 1, 1
		db	0, 1, 0, 1, 0, 1
		db	1, 0, 0, 0, 0, 1
		db	0, 1
		db	11 dup (0)
		db	1, 1, 1, 1, 0, 1
		db	0, 1, 0, 1, 3, 1
		db	1, 1, 1, 0, 0, 0
		db	0, 0, 0, 0, 1, 0
		db	1, 1, 0, 0, 0, 0
		db	1, 0, 0, 0, 1, 1
		db	0, 1, 0, 1, 0, 0
		db	1, 0, 1, 1, 0, 1
		db	1, 0, 0, 0, 1, 0
		db	1, 0, 1, 1, 0, 1
		db	0
		db	10 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 1, 1, 1, 1
		db	0, 0, 1, 1, 1, 0
		db	0, 0, 0, 0, 0, 0
		db	1, 1, 0
		db	8 dup (0)
		db	1, 0, 1, 1, 1, 0
		db	1, 0, 0, 1, 1, 1
		db	0, 3, 1, 1, 0, 1
		db	0, 0, 0, 3
		db	7 dup (0)
		db	1, 1, 0, 0, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	1, 1, 0, 1, 0, 1
		db	0, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 1, 1, 0, 1, 1
		db	1, 1, 0, 1, 0, 1
		db	14 dup (0)
		db	1, 0, 1, 0, 1, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 1, 1, 0, 1
		db	0, 0, 0, 1, 0, 0
		db	1, 0, 1, 0, 1, 0
		db	0, 0, 0, 0, 0, 0
		db	1, 0, 0, 1, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	1, 1, 1, 0, 1, 1
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1
		db	10 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1, 1, 0
		db	9 dup (0)
		db	1, 0, 1, 0, 0, 1
		db	0, 0, 1, 1, 1, 1
		db	1, 0, 1, 1, 0, 1
		db	0, 1, 0, 0, 1, 0
		db	1, 1, 0, 1, 0, 0
		db	0, 1, 0, 0, 1, 0
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1, 0, 1, 0
		db	1, 0, 1, 1, 0, 1
		db	0, 0, 1, 1, 1, 1
		db	0, 3, 0, 1, 0, 1
		db	0, 0, 0, 0, 1, 0
		db	0, 0, 3
		db	9 dup (0)
		db	1, 0, 0, 0, 0, 1
		db	0, 0, 0, 1, 0, 1
		db	1, 1, 1, 1, 0, 1
		db	0, 1, 1, 0, 1, 1
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 0, 0, 1, 0
		db	1, 0, 0, 0, 1, 0
		db	7 dup (0)
		db	1, 1, 0, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 1, 0, 0
		db	0, 0, 1, 1, 0, 1
		db	0, 0, 0, 0, 0, 1
		db	0, 1, 1, 0, 1, 1
		db	13 dup (0)
		db	1, 0, 1, 1, 1, 1
		db	0, 0, 0, 0, 1, 1
		db	1, 1, 0, 1, 0, 1
		db	0, 0, 0, 0, 0, 0
		db	1
		db	7 dup (0)
		db	1, 0, 1, 0, 1, 1
		db	3, 1, 0, 1, 0, 0
		db	1, 0, 1, 0, 1, 1
		db	0, 1, 0, 1
		db	7 dup (0)
		db	1, 0, 1, 0, 0, 0
		db	0, 0, 0, 1, 1, 1
		db	1, 0, 1, 1, 0, 1
		db	0, 1, 0, 1, 1, 1
		db	0, 1
		db	8 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 1, 0, 1, 1
		db	1, 0, 1, 0, 1, 1
		db	0, 3, 0, 1, 1, 0
		db	0, 1, 0, 0, 0, 1
		db	0, 1, 0, 0, 1, 0
		db	1, 0, 1, 0, 0, 1
		db	0, 0, 1, 0, 0, 0
		db	1, 0, 0, 1, 0, 1
		db	0, 1, 0, 1, 1, 0
		db	1, 1, 1, 1, 0, 1
		db	0, 0, 0, 0, 1
		db	16 dup (0)
		db	1, 0
		db	13 dup (0)
		db	1, 0, 1, 0, 1, 0
		db	1, 0
		db	7 dup (1)
		db	0, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 0, 0
		db	1, 0, 0, 0, 1, 0
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 0, 0, 0, 0
		db	1, 0, 1, 0, 1, 0
		db	0, 0, 0, 0, 1, 0
		db	1, 1, 1, 0, 0, 1
		db	0, 1, 0, 1, 1, 1
		db	0, 1, 0, 1, 0
		db	13 dup (0)
		db	1, 0, 1, 0, 1, 1
		db	1, 1, 1, 1, 0, 3
		db	1, 1, 3, 1, 0, 1
		db	0, 1
		db	18 dup (0)
		db	1, 0, 1, 0, 0, 1
		db	1, 1, 1, 1, 1, 1
		db	0, 1, 0, 1, 1, 1
		db	1, 1
		db	10 dup (0)
		db	1, 0
		db	11 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0, 1, 0, 0
		db	1, 0, 0, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 0, 1
		db	0, 1, 0, 0, 0, 1
		db	0, 3
		db	10 dup (0)
		db	1, 1, 1, 0, 1, 0
		db	1, 1, 1, 1, 1, 0
		db	1, 0, 1, 1
		db	11 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 0, 1, 0, 1
		db	1, 1, 0, 1, 0, 1
		db	0, 3, 0, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	0, 0, 1, 0, 1, 0
		db	1, 0
		db	9 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	1, 0, 0, 1, 1, 1
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 1, 1, 0, 1
		db	0
		db	9 dup (0)
		db	1, 0
		db	16 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1, 1, 1, 0
		db	1, 1, 1, 1, 0, 1
		db	0, 1, 1, 1, 3, 0
		db	0, 1, 0
		db	7 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1, 0, 1, 0
		db	1, 1, 1, 1, 0, 1
		db	0, 1, 1, 1, 1
		db	13 dup (0)
		db	1, 0, 0, 0, 0, 1
		db	1, 1, 1, 0, 1, 1
		db	1, 0, 0, 1, 0, 1
		db	0, 1, 1, 1, 0, 0
		db	0, 1, 0, 0, 1, 1
		db	0, 0, 1, 0, 3, 0
		db	0, 0, 0, 0, 1
		db	7 dup (0)
		db	1, 1, 0, 1, 0, 1
		db	1, 0, 0, 1, 1, 0
		db	1, 1, 1, 0, 1, 0
		db	8 dup (0)
		db	1, 1, 1, 0, 0, 0
		db	0, 1, 0, 1, 1, 0
		db	1, 1, 1, 0, 0, 0
		db	0, 0, 0, 1, 1, 0
		db	18 dup (0)
		db	1, 0
		db	7 dup (0)
		db	1, 1, 0, 1, 1, 1
		db	1, 0, 1, 0, 1, 1
		db	1, 0, 1, 0, 0, 0
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 0, 0, 0, 1
		db	0, 1, 0, 0, 1, 1
		db	1, 1, 1, 1, 3, 0
		db	1, 0, 1, 0, 0, 0
		db	1, 0
		db	11 dup (0)
		db	1, 1, 1, 0, 1, 0
		db	1, 1, 0, 1, 0, 1
		db	1, 1, 0, 3, 0, 0
		db	0, 0, 0, 1
		db	10 dup (0)
		db	1, 0, 1, 1, 1, 0
		db	0, 0, 0, 1, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 0, 0, 1, 0, 1
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 0, 0
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0, 1, 1, 1
		db	1, 1, 1, 1, 0, 0
		db	0, 0, 0, 0, 1
		db	22 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 1, 0, 1, 0, 1
		db	1, 1, 3, 1, 0, 1
		db	0, 1, 1, 1, 0, 0
		db	1, 0, 1, 0, 0, 0
		db	0, 0, 0, 0, 1
		db	8 dup (0)
		db	1, 1, 1, 0, 1, 1
		db	1, 0, 1, 0, 1, 1
		db	1, 0, 1, 1, 0, 1
		db	7 dup (0)
		db	1, 0
		db	9 dup (0)
		db	1, 1, 0, 0, 1, 0
		db	0, 0, 1, 0, 1, 0
		db	0, 1, 0, 1, 0, 1
		db	1, 0, 1, 1, 0, 1
		db	0, 1, 0, 1, 0, 0
		db	1, 0
		db	12 dup (0)
		db	1, 0, 0, 1, 0, 1
		db	0, 1, 1, 0, 3, 0
		db	1, 1, 1, 0, 1, 0
		db	0, 0, 1, 0, 1, 0
		db	0, 1, 0, 1, 0, 0
		db	0, 0, 0, 1, 0, 1
		db	0, 0, 0, 0, 0, 1
		db	1, 0, 0, 0, 0, 1
		db	1, 0, 0, 0, 1, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 0, 1, 0, 1, 0
		db	1, 0, 1, 1, 1, 0
		db	1, 0, 1, 1, 1, 1
		db	0, 1, 0, 1, 0, 1
		db	0
		db	11 dup (0)
		db	1, 0, 1, 0, 0, 0
		db	1, 0, 1, 0, 1, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0, 1, 1, 1
		db	0, 1, 0, 1, 1, 0
		db	1, 0, 1, 0, 0, 0
		db	0, 0, 0, 0, 1, 0
		db	1, 0, 0, 1, 0, 1
		db	0, 1, 0, 1, 1, 0
		db	1, 1, 0, 1, 0
		db	10 dup (0)
		db	1, 0, 1, 1, 0, 1
		db	0, 1, 1, 1, 1, 0
		db	3, 0, 1, 1, 0, 0
		db	0, 0, 1
		db	13 dup (0)
		db	1, 1, 0, 1, 0, 1
		db	1, 3, 0, 1, 1, 0
		db	1, 0, 1, 1, 0, 1
		db	11 dup (0)
		db	1, 0, 0, 0, 0, 1
		db	0, 0, 0, 0, 1
		db	7 dup (0)
		db	1, 1, 1, 0, 0, 0
		db	1, 1, 0, 1, 0, 1
		db	0, 1, 0, 1, 0, 0
		db	0, 0, 0, 1, 0, 0
		db	0, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 1, 1
		db	1, 0, 1, 1, 0, 1
		db	0, 0, 0, 0, 0, 3
		db	7 dup (0)
		db	1, 1, 0, 1, 0, 1
		db	1, 1, 0, 1, 0, 1
		db	1, 1, 0, 1, 0, 0
		db	1, 0, 1, 0
		db	10 dup (0)
		db	1, 0, 1, 0, 0, 0
		db	0, 3, 0, 1, 1, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0, 1, 1, 0
		db	1, 0, 0, 0, 0, 0
		db	1, 0, 1, 0, 0, 0
		db	0, 0, 0, 1, 0, 1
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 0, 1, 1, 0
		db	1, 0
		db	15 dup (0)
		db	1, 0, 1, 1, 0, 1
		db	1, 0, 0, 0, 0, 0
		db	1, 1, 1, 1, 0, 1
		db	1, 1, 1, 0, 0, 0
		db	0, 0, 1, 1, 1, 1
		db	1
		db	8 dup (0)
		db	1, 0, 1, 0, 0, 0
		db	0, 0, 0, 0, 1, 0
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 0, 1, 1, 1
		db	0, 1, 0, 3, 0
		db	18 dup (0)
		db	1, 0, 1, 0, 1, 1
		db	1, 0, 1, 0, 1, 0
		db	1, 1, 1, 1, 0, 1
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 0, 1, 0, 0
		db	0, 0, 0, 0, 1, 0
		db	1, 0, 1, 1, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	1
		db	14 dup (0)
		db	1, 0, 1, 0, 0, 1
		db	1, 1, 0, 1, 0, 3
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 0, 0, 0, 0
		db	0, 0, 1
		db	11 dup (0)
		db	1, 1, 1, 1, 0, 0
		db	0, 1, 1, 1, 0, 1
		db	1, 1, 0, 1, 1, 0
		db	0, 0, 1, 1, 1, 0
		db	11 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	1, 0, 1, 1, 1, 0
		db	1, 0, 1, 0, 0, 1
		db	0, 3, 1, 1, 0, 1
		db	0, 0, 0, 0, 0, 1
		db	0, 1, 0, 0, 1, 0
		db	1, 0, 0, 0, 1, 1
		db	1, 1, 1, 0, 1, 0
		db	7 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	0, 0, 1, 0, 1, 1
		db	0, 1, 1, 1, 0, 1
		db	0, 1, 0, 1, 0, 1
		db	0, 1, 0
		db	7 dup (0)
		db	1, 0, 1, 0, 1, 0
		db	1, 0, 1, 0, 1, 0
		db	0, 1, 0, 3, 0, 1
		db	0, 1
		db	7 dup (0)
		db	1, 0, 0, 1, 0, 1
		db	0, 0, 0, 0, 0, 1
		db	0, 1, 1, 1, 0, 1
		db	0, 0, 1, 0, 1, 0
		db	1, 1, 1, 0, 1, 0
		db	9 dup (0)
		db	1, 0, 0, 0, 0, 0
		db	1, 0, 1, 1, 1, 1
		db	1
		db	0, 0, 0, 0, 0, 0
data_b_0FF0	db	0
		db	'PANGO   HGH'
		db	 00h, 00h, 80h, 00h, 00h
		db	15 dup (0)
data_b_1010	db	0
		db	0, 0, 0, 0
data_b_1015	db	31h			; Data table (indexed access)
data_b_1016	db	31h
data_b_1017	db	31h
data_b_1018	db	31h
data_b_1019	db	31h
data_b_101A	db	31h
data_b_101B	db	30h			; Data table (indexed access)
		db	 30h, 30h, 30h, 30h, 30h
data_b_1021	db	0			; Data table (indexed access)
data_b_1022	db	0			; Data table (indexed access)
data_b_1023	db	0			; Data table (indexed access)
data_b_1024	db	0			; Data table (indexed access)
data_b_1025	db	0			; Data table (indexed access)
data_b_1026	db	0			; Data table (indexed access)
data_b_1027	db	0			; Data table (indexed access)
		db	121 dup (0)
data_b_10A1	db	'$'
		db	'HIGH SCORE TO DATE$'
		db	'Press Any Key to Continue$'
		db	'1: '
data_b_10D2	db	0			; Data table (indexed access)
		db	30 dup (0)
data_b_10F1	db	0			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 00h, 24h
data_b_10F8	db	0			; Data table (indexed access)
		db	24 dup (0)
		db	0C9h
		db	23 dup (0CDh)
		db	0BBh, 24h,0C8h
		db	23 dup (0CDh)
		db	0BCh, 24h,0BAh
		db	23 dup (20h)
		db	0BAh, 24h,0BAh
		db	' 1 : Level 1 (novice)  '
		db	0BAh, 24h,0BAh
		db	' 2 : Level 2'
		db	11 dup (20h)
		db	0BAh, 24h,0BAh
		db	' 3 : Level 3'
		db	11 dup (20h)
		db	0BAh, 24h,0BAh
		db	' 4 : Level 4'
		db	11 dup (20h)
		db	0BAh, 24h,0BAh
		db	' 5 : Level 5 (expert)  '
		db	0BAh, 24h,0BAh
		db	' H : See High Score    '
		db	0BAh, 24h,0BAh
		db	' P : How t'
loc_b_1206:
		outsw				; Out [si] to port dx
		and	[bx+si+6Ch],dl
		popa				; Restore all regs
		jns	loc_b_122D		; Jump if not sign
		aas				; Ascii adjust
		db	 20h, 20h, 20h, 20h, 20h,0BAh
		db	 24h,0BAh
		db	' X : Exit to System    '
loc_b_122D:
		mov	dx,5924h
data_b_1230	db	'our choice ? $'
		db	'Enter your name $'
		db	'LEVEL    $'
		db	'(C) Copyright 1983 by$'
		db	'Sheng-Chung LIU$'
		db	' $'
		db	'P$'
		db	'A$'
		db	'N$'
		db	'G$'
		db	'O$'
		db	'Attempt to clear bees in the fie'
		db	'ld$'
		db	'within one minute by squashing t'
		db	'hem$'
		db	'with blocks.  Bees may also be c'
		db	'aptured$'
		db	'after they are shocked.$'
		db	'             $'
		db	'             $'
		db	'PANGO$'
		db	'Bee$'
		db	'Block$'
		db	'Diamond Block$'
		db	'Dazed Bee$'
		db	'Keyboard Control:$'
		db	18h
		db	'$'
		db	'O$'
		db	1Bh, ' K L ; '
		db	 1Ah, 24h, 19h
		db	'$'
		db	'   Up: key "O"$'
		db	' Down: key "L"$'
		db	' Left: key "K"$'
		db	'Right: key ";"$'
		db	' Kick: space bar$'
		db	' Stop: any other key$'
		db	'Sound Switch: "Q"$'
		db	'Three modes are available$'
		db	'1:Theme and sound effect$'
		db	'2:Sound effect only$'
		db	'3:No sound at all$'
		db	'Rules of Scoring:$'
		db	'   10 - finish a round in 50-59 '
		db	'secs.$'
		db	'  100 - catch dazed bee$'
		db	'  400 - squash one bee$'
		db	'  500 - finish a round in 40-49 '
		db	'secs.$'
		db	' 1000 - finish a round in 30-39 '
		db	'secs.$'
		db	' 1600 - squash two bees with one'
		db	' kick$'
		db	' 2000 - finish a round in 20-29 '
		db	'secs.$'
		db	' 3200 - squash three bees with o'
		db	'ne kick$'
		db	' 5000 - finish a round in  0-19 '
		db	'secs.,$'
		db	'     or line up diamond blocks o'
		db	'n walls$'
		db	'10000 - line up diamond blocks a'
		db	'way$'
		db	'        from walls$'
data_b_15F2	db	19h
data_b_15F3	db	1
		db	12 dup (0)
data_b_1600	dw	0
data_b_1602	dw	0
		db	12 dup (0)

seg_b		ends



;------------------------------------------------------  stack_seg_c   ----

stack_seg_c	segment	word stack 'stack'

		db	44 dup (0)
		db	'STACK  STACK  STACK  STACK  STAC'
		db	'K  STACK  STACK  STACK  STACK  S'
		db	'TACK  STACK  STACK  STACK  STACK'
		db	'  STACK  STACK  STACK  STACK  ST'
		db	'ACK  STACK  STACK  STACK  STACK '
		db	' STACK  STACK  STACK  STACK  STA'
		db	'CK  STACK  STACK  STACK  STACK  '
		db	'STACK  STACK  STACK  STACK  STAC'
		db	'K  STACK  STACK  STACK  STACK  S'
		db	'TACK  STACK  STACK  STACK  STACK'
		db	'  STACK  STACK  STACK  STACK  ST'
		db	'ACK  STACK  STACK  STACK  STACK '
		db	' STACK  STACK  STACK  STACK  STA'
		db	'CK  STACK  STACK  STACK  STACK  '
		db	'STACK  STACK  STACK  STACK  STAC'
		db	'K  STACK  STACK  STACK  STACK  S'
		db	'TACK  STACK  STACK  STACK  STACK'
		db	'  STACK  STACK  STACK  STACK  ST'
		db	'ACK  STACK  STACK  STACK  STACK '
		db	' STACK  STACK  STACK  STACK  STA'
		db	'CK  STACK  STACK  STACK  STACK  '
		db	'STACK  STACK  STACK  STACK  STAC'
		db	'K  STACK  STACK  STACK  STACK  S'
		db	'TACK  STACK  STACK  STACK  STACK'
		db	'  STACK  STACK  STACK  STACK  ST'
		db	'ACK  STACK  STACK  STACK  STACK '
		db	' STACK  STACK  STACK  STACK STAC'
		db	'K STACK STACK STACK STACK STACK '
		db	'STACK STACK STACK STACK STACK ST'
		db	'ACK STACK STACK STACK STACK STAC'
		db	'K STACK STACK STACK '

stack_seg_c	ends



		end	start
