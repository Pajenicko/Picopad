
PAGE  59,132

; Where in the game is the loss of lives:
; - address 0929h (file offset 0829h, label loc_lives_dec):
;        instruction DEC AH (FEh CCh) -> change to NOP, NOP (90h 90h)
; - this instruction is modified from function sub_044B starting at address 044Bh (file offset 034Bh):
;        byte FEh at address 486h (offset 386h) -> 90h
;        byte CCh at address 48Ch (offset 38Ch) -> 90h
; - and also modified from location loc_3138:
;        byte FEh at address 3173h (offset 3073h) -> 90h
;        byte CCh at address 3179h (offset 3079h) -> 90h

; Key input:
;  Table at location 0CE48h - scan codes of the keys
;  Interrupt routine INT 09h


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
; Target Assembler = TASM-3.2
; Vertical lines   = 0
; Input filename   = GOODY.COM
; Code style       = Com
; Drive (output)   = Z
; Output filename  = GOODY.LST
; Passes           = 9
; Xref             = OFF

;==========================================================================
;==					                                 ==
;==				GOODY	                                 ==
;==					                                 ==
;==      Created:   1-May-85		                                 ==
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
d_0000_0070_e	equ	70h
d_0000_2202_e	equ	2202h			;*
data_0000_e	equ	0
data_0005_e	equ	5
data_00C2_e	equ	0C2h
data_00FD_e	equ	0FDh
data_F103_e	equ	0F103h			;*
data_F105_e	equ	0F105h			;*
data_F107_e	equ	0F107h			;*
data_F109_e	equ	0F109h			;*
data_F10A_e	equ	0F10Ah			;*
data_F10B_e	equ	0F10Bh			;*
data_F10C_e	equ	0F10Ch			;*
data_F10D_e	equ	0F10Dh			;*
data_F10E_e	equ	0F10Eh			;*
data_F10F_e	equ	0F10Fh			;*
data_F110_e	equ	0F110h			;*
data_F111_e	equ	0F111h			;*
data_F112_e	equ	0F112h			;*
data_F113_e	equ	0F113h			;*
data_F114_e	equ	0F114h			;*
data_F115_e	equ	0F115h			;*
data_F116_e	equ	0F116h			;*
data_F11A_e	equ	0F11Ah			;*
data_F11B_e	equ	0F11Bh			;*		; lives
data_F11C_e	equ	0F11Ch			;*
data_F11D_e	equ	0F11Dh			;*
data_F120_e	equ	0F120h			;*
data_F122_e	equ	0F122h			;*
data_F124_e	equ	0F124h			;*
data_F125_e	equ	0F125h			;*
data_F126_e	equ	0F126h			;*
data_F127_e	equ	0F127h			;*
data_F12A_e	equ	0F12Ah			;*
data_F12C_e	equ	0F12Ch			;*
data_F12D_e	equ	0F12Dh			;*
data_F12E_e	equ	0F12Eh			;*
data_F12F_e	equ	0F12Fh			;*
data_F131_e	equ	0F131h			;*
data_F133_e	equ	0F133h			;*
data_F136_e	equ	0F136h			;*
data_F137_e	equ	0F137h			;*
data_F138_e	equ	0F138h			;*
data_F139_e	equ	0F139h			;*
data_F142_e	equ	0F142h			;*
data_F144_e	equ	0F144h			;*
data_F146_e	equ	0F146h			;*
data_F148_e	equ	0F148h			;*
data_F14A_e	equ	0F14Ah			;*
data_F14C_e	equ	0F14Ch			;*
data_F164_e	equ	0F164h			;*
data_F166_e	equ	0F166h			;*
data_F168_e	equ	0F168h			;*
data_F169_e	equ	0F169h			;*
data_F16B_e	equ	0F16Bh			;*
data_F16D_e	equ	0F16Dh			;*
data_F16E_e	equ	0F16Eh			;*
data_F170_e	equ	0F170h			;*
data_F174_e	equ	0F174h			;*
data_F176_e	equ	0F176h			;*
data_F17A_e	equ	0F17Ah			;*
data_F17B_e	equ	0F17Bh			;*
data_F17D_e	equ	0F17Dh			;*
data_F17E_e	equ	0F17Eh			;*
data_F19E_e	equ	0F19Eh			;*
data_F1A0_e	equ	0F1A0h			;*
data_F1A2_e	equ	0F1A2h			;*
data_F1AF_e	equ	0F1AFh			;*
data_F1B5_e	equ	0F1B5h			;*
data_F1B9_e	equ	0F1B9h			;*
data_F1C1_e	equ	0F1C1h			;*
data_F1C3_e	equ	0F1C3h			;*
data_F1C5_e	equ	0F1C5h			;*
data_F1C7_e	equ	0F1C7h			;*
data_F1C9_e	equ	0F1C9h			;*
data_F1CD_e	equ	0F1CDh			;*
data_F1CF_e	equ	0F1CFh			;*
data_F1D0_e	equ	0F1D0h			;*
data_F1DA_e	equ	0F1DAh			;*
data_F1DC_e	equ	0F1DCh			;*
data_F1DF_e	equ	0F1DFh			;*
data_F1E0_e	equ	0F1E0h			;*
data_F1E2_e	equ	0F1E2h			;*
data_F1F4_e	equ	0F1F4h			;*
data_F1F8_e	equ	0F1F8h			;*
data_F221_e	equ	0F221h			;*
data_F3BB_e	equ	0F3BBh			;*
data_F3BD_e	equ	0F3BDh			;*
data_F3CB_e	equ	0F3CBh			;*
data_F3CC_e	equ	0F3CCh			;*
data_F3CD_e	equ	0F3CDh			;*
data_F3CE_e	equ	0F3CEh			;*
data_F3CF_e	equ	0F3CFh			;*
data_F3D0_e	equ	0F3D0h			;*
data_F3D2_e	equ	0F3D2h			;*
data_F3D4_e	equ	0F3D4h			;*
data_F3DA_e	equ	0F3DAh			;*
data_F465_e	equ	0F465h			;*
data_F47E_e	equ	0F47Eh			;*
data_F47F_e	equ	0F47Fh			;*
data_F480_e	equ	0F480h			;*
data_F4C1_e	equ	0F4C1h			;*
data_F4DA_e	equ	0F4DAh			;*
data_F4F3_e	equ	0F4F3h			;*
data_F4F5_e	equ	0F4F5h			;*
d_B800_1FFE_e	equ	1FFEh
d_B800_2000_e	equ	2000h

seg_a		segment	byte public
		assume	cs:seg_a, ds:seg_a


		org	100h

GOODY		proc	far

start:
		; save jump to 0 - exit program
		push	cs
;*		sub	ax,ax
		db	 29h,0C0h		;  Fixup - byte match
		push	ax

		; initialize segments
		mov	cs:data_0409,sp		; saved SP
		mov	ax,cs
		add	ax,0
		mov	es,ax
		mov	ds,ax
		mov	ss,ax

		; clear area data_EDE3
		mov	bx,offset data_EDE3
		mov	word ptr [bx],0
		mov	dx,0EDE4h
		mov	cx,710h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		; set area data_EDE3 to 0xff
		mov	bx,offset data_EDE3
		mov	dx,0EDE4h
		mov	word ptr [bx],0FFh
		mov	cx,31Fh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		mov	bx,0EDE3h
		mov	dx,0F4F3h
		mov	cx,320h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		call	sub_3779
		call	sub_36F3
		call	sub_3059
		call	sub_0FF6
		call	sub_021B
		call	sub_3839
		mov	cs:data_0409,sp		; saved SP

loc_016F:
		mov	sp,cs:data_0409		; saved SP
		call	sub_02DE
		call	sub_02F7
		call	sub_3944
		call	sub_3188
		call	sub_33D8
		mov	ah,54h			; 'T'
		mov	ds:data_F11D_e,ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F17B_e,ah
		mov	word ptr ds:data_F17B_e+1,0
		mov	byte ptr ds:data_F47E_e,0
		call	sub_2BD2
		call	sub_2B25
		call	sub_38B9
		call	sub_39A9
		call	sub_021B
		call	sub_0247
		call	sub_0FFC
		call	sub_23DA
		call	sub_33B6
		mov	ch,3
		mov	cl,0Dh
		mov	dh,0Ah
		mov	dl,14h
		call	sub_1162
		call	sub_342C
		call	sub_031D

		; set area 0EDE3h to 50h
		mov	ah,50h			; 'P'
		mov	ds:data_F11D_e,ah
		mov	bx,0EDE3h
		mov	dx,0EDE4h
		mov	cx,31Fh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		call	sub_3944
		mov	word ptr ds:data_F107_e,0
		cmp	byte ptr cs:data_413B,0
		je	loc_0201		; Jump if equal
		mov	byte ptr cs:data_413C,0
		mov	bx,4140h
		mov	cs:data_413E,bx
		jmp	short loc_020F
loc_0201:
		mov	bx,413Eh
		mov	cs:data_413E,bx
		mov	byte ptr cs:data_413D,0FFh
loc_020F:
		mov	word ptr ds:data_F1AF_e,8
		call	sub_040B
		jmp	loc_016F

GOODY		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_021B	proc	near
		mov	ah,0Fh			; initial number of lives
		mov	ds:data_F11B_e,ah	; lives
		call	sub_2373

;==== External Entry into Subroutine ======================================

sub_0224:
		call	sub_0276
		mov	bx,0
		mov	ds:data_F12A_e,bx

;==== External Entry into Subroutine ======================================

sub_022E:
		mov	ah,1
		mov	ds:data_F17B_e,ah
		mov	bx,0F1CFh
		mov	word ptr ds:data_F17B_e+1,bx
		mov	bx,0
		mov	ds:data_F17E_e,bx
		mov	ds:data_F1F4_e,ah
		retn
sub_021B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0247	proc	near
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F12C_e,ah
		mov	ds:data_F12A_e,ah
		mov	byte ptr ds:data_F12A_e+1,ah
		mov	ah,0FFh
		mov	bx,data_F103_e
		mov	[bx],ah
		inc	bx
		mov	[bx],ah
		inc	bx
		mov	[bx],ah
		inc	bx
		mov	[bx],ah
		mov	ds:data_F3CF_e,ah
		mov	bx,0F125h
		mov	byte ptr [bx],16h
		mov	bx,0F124h
		mov	byte ptr [bx],8
		retn
sub_0247	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0276	proc	near

		mov	bx,data_F1CF_e
		mov	word ptr [bx],0
		mov	dx,0F1D0h
		mov	cx,1ECh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		mov	bx,data_F3BB_e
		mov	word ptr [bx],0FFh
		mov	bx,0DF68h
		mov	dx,0F480h
		mov	cx,41h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		mov	bx,0DFB9h
		mov	dx,0F4C1h
		mov	cx,32h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx

		call	sub_02C1
		retn
sub_0276	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02C1	proc	near
		mov	bx,0DFF9h
		call	sub_02CA
		mov	bx,offset data_E02A

;==== External Entry into Subroutine ======================================

sub_02CA:
		mov	ah,[bx]
		inc	bx
		mov	dx,4
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,1
		inc	bx
loc_02D5:
		mov	[bx],ah
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_02D5		; Jump if not zero
		retn
sub_02C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02DE	proc	near
		mov	bx,data_F126_e
		mov	word ptr [bx],0
		mov	dx,0F127h
		mov	cx,8
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_02DE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02F7	proc	near
		mov	bx,data_F12E_e
		mov	word ptr [bx],0
		mov	dx,0F12Fh
		mov	cx,0Ch
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_02F7	endp

data_0310	db	1Eh
		db	 03h, 04h, 26h, 03h, 04h, 07h
		db	 06h, 09h, 1Fh, 03h, 04h,0FFh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_031D	proc	near
		mov	bx,0
		mov	ds:data_F17B_e,bx
		mov	word ptr ds:data_F17B_e+1,bx
		mov	bx,30Dh
		mov	ds:data_F1C9_e,bx
loc_032F:
		mov	bx,ds:data_F1C9_e
		mov	dx,3
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ds:data_F1C9_e,bx
		mov	cx,17h
		mov	bx,1080h
		call	sub_03D5
loc_0345:
		call	sub_39A9
		call	sub_3839
		jz	loc_0354		; Jump if zero
		mov	byte ptr cs:data_413B,0
		retn
loc_0354:
		test	byte ptr ds:[0CE55h],80h
		jz	loc_0362		; Jump if zero
		mov	byte ptr cs:data_413B,1
		retn
loc_0362:
		mov	cx,1E17h
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		call	sub_03E8
		mov	cx,2710h
		call	sub_114F
		mov	ah,[si+0Ch]
		cmp	ah,1Eh
		jae	loc_0345		; Jump if above or =
		mov	di,ds:data_F1C9_e
		test	byte ptr [di],80h
		jz	loc_0388		; Jump if zero
		mov	di,offset data_0310
		mov	ds:data_F1C9_e,di
loc_0388:
		mov	ch,[di]
		mov	cl,[di+1]
		mov	bx,1040h
		call	sub_03D5
loc_0393:
		call	sub_39A9
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	cx,1E17h
		call	sub_03E8
		mov	di,ds:data_F1C9_e
		mov	ah,[di]
		mov	cl,[di+1]
		mov	ch,[di+2]
		call	sub_03E8
		test	byte ptr [si],10h
		jz	loc_03B5		; Jump if zero
		jmp	loc_032F
loc_03B5:
		mov	cx,0BB8h
		call	sub_114F
		call	sub_3839
		jz	loc_03C7		; Jump if zero
		mov	byte ptr cs:data_413B,0
		retn
loc_03C7:
		test	byte ptr ds:[0CE55h],80h
		jz	loc_0393		; Jump if zero
		mov	byte ptr cs:data_413B,1
		retn
sub_031D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_03D5	proc	near
		push	cx
		push	bx
		call	sub_12A7
		jnc	loc_03DD		; Jump if carry=0
		retn
loc_03DD:
		pop	bx
		pop	cx
		mov	dh,24h			; '$'
		mov	dl,0
		mov	ah,0C0h
		jmp	loc_1274
sub_03D5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_03E8	proc	near
		push	cx
		call	sub_1459
		pop	cx
		jnc	loc_03F0		; Jump if carry=0
		retn
loc_03F0:
		push	di
		pop	si
		mov	dl,1
		call	sub_1065
		jc	loc_03FA		; Jump if carry Set
		retn
loc_03FA:
		call	sub_2CBE
		mov	ah,[si+0Ch]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0405		; Jump if zero
		retn
loc_0405:
		or	byte ptr [si],10h
		retn
sub_03E8	endp

data_0409	dw	0F6h			; saved SP

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_040B	proc	near
		call	sub_0BBA
loc_040E:
		mov	byte ptr data_4877,0
		mov	ah,ds:data_F115_e
		mov	ds:data_F116_e,ah
		call	sub_379E
		call	sub_4059
		call	sub_2C34
		call	sub_2321
		call	sub_231A
		call	sub_048E
		call	sub_0587
		call	sub_1FBC
		call	sub_0C1A
		call	sub_39A9
		call	sub_10F3
		call	sub_23A8
loc_043F:
		cmp	byte ptr data_4877,3
		jb	loc_043F		; Jump if below
		call	sub_044B		; Update demo mode
		jmp	short loc_040E
sub_040B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Update demo mode

sub_044B	proc	near
		test	word ptr ds:[0CE48h],80h
		jz	loc_0478		; Jump if zero
		test	word ptr ds:[0CE4Bh],80h
		jz	loc_0478		; Jump if zero
		test	word ptr ds:[0CE55h],80h
		jz	loc_0478		; Jump if zero

		test	word ptr ds:[0CE49h],80h ; 80h - demo mode
		jz	loc_0478		; Jump if zero

		mov	byte ptr cs:[loc_lives_dec],90h	; 2x instruction NOP
		mov	byte ptr cs:[loc_lives_dec+1],90h
;		mov	byte ptr cs:[929h],90h
;		mov	byte ptr cs:[92Ah],90h
		retn
loc_0478:
		test	word ptr ds:[0CE4Ah],80h
		jnz	loc_0481		; Jump if not zero
		retn
loc_0481:
		mov	byte ptr cs:[loc_lives_dec],0FEh	; instruction DEC AH
		mov	byte ptr cs:[loc_lives_dec+1],0CCh
;		mov	byte ptr cs:[929h],0FEh
;		mov	byte ptr cs:[92Ah],0CCh
		retn
sub_044B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_048E	proc	near
		mov	ah,byte ptr ds:data_F12A_e+1
		test	ah,1
		jz	loc_0498		; Jump if zero
		retn
loc_0498:
		test	ah,2
		jz	loc_049E		; Jump if zero
		retn
loc_049E:
		mov	si,data_F1CF_e
		call	sub_0A19
		mov	ah,ds:data_F3CC_e
		mov	ds:data_F133_e,ah
		call	sub_215F
		test	byte ptr [si+24h],2
		jz	loc_04B8		; Jump if zero
		call	sub_0976
loc_04B8:
		test	byte ptr [si+11h],1
		jz	loc_04C1		; Jump if zero
		jmp	loc_0604
loc_04C1:
		test	byte ptr [si+11h],4
		jz	loc_04CA		; Jump if zero
		jmp	loc_07C2
loc_04CA:
		call	sub_09EF
		cmp	byte ptr ds:data_F11C_e,3Fh	; '?'
		je	loc_04DD		; Jump if equal
		test	byte ptr [si+11h],8
		jz	loc_04DD		; Jump if zero
		jmp	loc_074D
loc_04DD:
		test	byte ptr [si+11h],40h	; '@'
		jnz	loc_04E6		; Jump if not zero
		call	sub_058F
loc_04E6:
		mov	ah,ds:data_F115_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_04F1		; Jump if not zero
		jmp	loc_087F
loc_04F1:
		mov	ah,ds:data_F12D_e
		test	ah,80h
		jz	loc_0511		; Jump if zero
		mov	bx,0D396h
		test	byte ptr [si+13h],80h
		jz	loc_0506		; Jump if zero
		mov	bx,0D3C8h
loc_0506:
		call	sub_0907
		mov	dl,2
		call	sub_1065
		jc	loc_0511		; Jump if carry Set
		retn
loc_0511:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F12D_e,ah
		call	sub_09AA
		mov	ah,ds:data_F115_e
		cmp	ah,2
		jne	loc_0526		; Jump if not equal
		call	sub_085C
loc_0526:
		cmp	ah,20h			; ' '
		jne	loc_052E		; Jump if not equal
		call	sub_0D41
loc_052E:
		mov	bx,offset data_DF4D
		test	byte ptr [bx],1
		mov	ah,ds:data_F115_e
		jnz	loc_053F		; Jump if not zero
		and	byte ptr [bx],0FDh
		jmp	short loc_055B
loc_053F:
		call	sub_20F5
		mov	ah,ds:data_F115_e
		test	byte ptr [bx],2
		jz	loc_055B		; Jump if zero
		cmp	ah,20h			; ' '
		jne	loc_0553		; Jump if not equal
		call	sub_0DC8
loc_0553:
		and	ah,3
		jz	loc_055B		; Jump if zero
		call	sub_0E33
loc_055B:
		mov	ah,ds:data_F115_e
		test	ah,1
		jz	loc_0567		; Jump if zero
		call	sub_07F3
loc_0567:
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		mov	ah,byte ptr ds:data_F12A_e+1
		test	ah,80h
		jnz	loc_0584		; Jump if not zero
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		test	ah,4
		jz	loc_057C		; Jump if zero
		call	sub_06D1
loc_057C:
		test	ah,8
		jz	loc_0584		; Jump if zero
		call	sub_064D
loc_0584:
		jmp	loc_087F

;==== External Entry into Subroutine ======================================

sub_0587:
		mov	bx,data_F136_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		rcl	byte ptr [bx],1		; Rotate thru carry
		retn

;==== External Entry into Subroutine ======================================

sub_058F:
		mov	bx,offset data_DF4D
		test	byte ptr [bx],2
		jz	loc_0598		; Jump if zero
		retn
loc_0598:
		pop	cx
		test	byte ptr [si+24h],40h	; '@'
		jz	loc_05A0		; Jump if zero
		retn
loc_05A0:
		mov	bx,0D382h
		test	byte ptr [si+13h],80h
		jz	loc_05AC		; Jump if zero
		mov	bx,0D3B4h
loc_05AC:
		call	sub_0907
		call	sub_1065
		jc	loc_05B5		; Jump if carry Set
		retn
loc_05B5:
		call	sub_2CE2
		call	sub_0B2C
		mov	ah,[si+11h]
		or	ah,[si+24h]
		test	byte ptr [si+13h],80h
		jnz	loc_05D9		; Jump if not zero
		test	ah,20h			; ' '
		jnz	loc_05CD		; Jump if not zero
		retn
loc_05CD:
		mov	byte ptr [si+13h],1
		dec	byte ptr [si+0Ch]
		mov	byte ptr [si+0Bh],0
		retn
loc_05D9:
		test	ah,10h
		jnz	loc_05DF		; Jump if not zero
		retn
loc_05DF:
		mov	byte ptr [si+13h],0FFh
		mov	byte ptr [si+0Bh],0
		inc	byte ptr [si+0Ch]
		retn
loc_05EB:
		mov	bx,0D375h
		test	byte ptr [si+13h],80h
		jz	loc_05F7		; Jump if zero
		mov	bx,offset data_D3A7
loc_05F7:
		test	byte ptr [si+14h],80h
		jz	loc_05FE		; Jump if zero
		dec	bx
loc_05FE:
		mov	ah,[bx]
		mov	[si+10h],ah
		retn
loc_0604:
		mov	ah,ds:data_F11D_e
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	bx,offset data_DFE9
		mov	dx,3
loc_0610:
		mov	ah,[bx]
		cmp	ah,0FFh
		je	loc_0633		; Jump if equal
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jz	loc_061F		; Jump if zero
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		jmp	short loc_0610
loc_061F:
		push	bx
		pop	di
		mov	bl,0
		mov	bh,[di+1]
		mov	ds:data_F1DA_e,bx
		mov	bl,80h
		mov	bh,[di+2]
		mov	ds:data_F1DC_e,bx
loc_0633:
		mov	bx,0CF0Eh
		call	sub_3192
		mov	bx,0D3BEh
		call	sub_0907
		call	sub_1065
		jc	loc_0645		; Jump if carry Set
		retn
loc_0645:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_064A		; Jump if not zero
		retn
loc_064A:
		jmp	loc_0925

;==== External Entry into Subroutine ======================================

sub_064D:
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jnz	loc_065A		; Jump if not zero
		mov	byte ptr [si+0Dh],80h
loc_065A:
		test	byte ptr [si+11h],20h	; ' '
		jz	loc_0698		; Jump if zero
		mov	ch,[si+0Eh]
		mov	cl,[si+0Ch]
		inc	cl
		inc	cl
		inc	cl
		call	sub_10D5
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_067C		; Jump if zero
		cmp	ah,4Eh			; 'N'
		jae	loc_067C		; Jump if above or =
		jmp	short loc_0698
loc_067C:
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0698		; Jump if zero
		cmp	ah,4Eh			; 'N'
		jae	loc_0698		; Jump if above or =
		dec	byte ptr [si+0Eh]
		inc	byte ptr [si+0Ch]
		mov	byte ptr [si+0Bh],0
loc_0698:
		pop	cx
		mov	ah,[si+2]
		cmp	ah,12h
		je	loc_06A6		; Jump if equal
		inc	ah
		mov	[si+2],ah
loc_06A6:
		mov	bx,0D36Eh
		call	sub_0907
		call	sub_1065
		jc	loc_06B2		; Jump if carry Set
		retn
loc_06B2:
		inc	byte ptr [si+0Ch]
		mov	byte ptr [si+0Bh],0
		call	sub_0B2C
		mov	ah,[si+24h]
		or	ah,[si+11h]
		test	ah,20h			; ' '
		jnz	loc_06C8		; Jump if not zero
		retn
loc_06C8:
		dec	byte ptr [si+0Ch]
		mov	byte ptr [si+0Bh],0
		stc				; Set carry flag
		retn

;==== External Entry into Subroutine ======================================

sub_06D1:
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jnz	loc_06DE		; Jump if not zero
		mov	byte ptr [si+0Dh],80h
loc_06DE:
		mov	ah,[si+11h]
		test	ah,10h
		jz	loc_0718		; Jump if zero
		mov	ch,[si+0Eh]
		mov	cl,[si+0Ch]
		dec	cl
		call	sub_10D5
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_06FC		; Jump if zero
		cmp	ah,4Eh			; 'N'
		jb	loc_0718		; Jump if below
loc_06FC:
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0718		; Jump if zero
		cmp	ah,4Eh			; 'N'
		jae	loc_0718		; Jump if above or =
		dec	byte ptr [si+0Eh]
		dec	byte ptr [si+0Ch]
		mov	byte ptr [si+0Bh],0
loc_0718:
		pop	cx
		mov	ah,[si+2]
		cmp	ah,12h
		je	loc_0726		; Jump if equal
		inc	ah
		mov	[si+2],ah
loc_0726:
		mov	bx,0D3A0h
		call	sub_0907
		call	sub_1065
		jc	loc_0732		; Jump if carry Set
		retn
loc_0732:
		dec	byte ptr [si+0Ch]
		mov	byte ptr [si+0Bh],0
		call	sub_0B2C
		mov	ah,[si+24h]
		or	ah,[si+11h]
		test	ah,10h
		jnz	loc_0748		; Jump if not zero
		retn
loc_0748:
		inc	byte ptr [si+0Ch]
		stc				; Set carry flag
		retn
loc_074D:
		test	byte ptr [si+11h],1
		jz	loc_0756		; Jump if zero
		jmp	loc_0604
loc_0756:
		test	byte ptr [si+24h],8
		jnz	loc_07B3		; Jump if not zero
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0770		; Jump if not zero
loc_0763:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si+2],ah
		call	sub_120D
		and	byte ptr [si+11h],0F7h
		retn
loc_0770:
		dec	ah
		mov	[si+2],ah
		call	sub_2CE2
		call	sub_0B2C
		mov	ah,[si+11h]
		or	ah,[si+24h]
		test	ah,80h
		jnz	loc_0763		; Jump if not zero
		test	byte ptr [si+13h],80h
		jnz	loc_079C		; Jump if not zero
		mov	ah,[si+11h]
		or	ah,[si+24h]
		test	ah,20h			; ' '
		jnz	loc_0763		; Jump if not zero
		mov	bx,0D373h
		jmp	short loc_07AA
loc_079C:
		mov	ah,[si+11h]
		or	ah,[si+24h]
		test	ah,10h
		jnz	loc_0763		; Jump if not zero
		mov	bx,0D3A5h
loc_07AA:
		call	sub_0907
		mov	[si+10h],cl
		jmp	loc_05EB
loc_07B3:
		dec	byte ptr [si+12h]
		jz	loc_07B9		; Jump if zero
		retn
loc_07B9:
		and	byte ptr [si+24h],0F7h
		and	byte ptr [si+11h],0F7h
		retn
loc_07C2:
		mov	bx,0D37Dh
		test	byte ptr [si+13h],80h
		jz	loc_07CE		; Jump if zero
		mov	bx,0D3AFh
loc_07CE:
		call	sub_0907
		call	sub_1065
		jc	loc_07D7		; Jump if carry Set
		retn
loc_07D7:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_07DC		; Jump if not zero
		retn
loc_07DC:
		mov	[si+10h],ah
		and	byte ptr [si+11h],0FBh
		and	byte ptr [si+24h],0F7h
		call	sub_0BED
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F127_e,ah
		jmp	loc_364E

;==== External Entry into Subroutine ======================================

sub_07F3:
		pop	cx
		mov	bx,0D373h
		test	byte ptr [si+13h],80h
		jz	loc_0800		; Jump if zero
		mov	bx,0D3A5h
loc_0800:
		call	sub_0907
		or	byte ptr [si+11h],8
		call	sub_1065
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0817		; Jump if zero
		mov	bx,0CE6Bh
		jmp	loc_3192
loc_0817:
		mov	ah,[si+0Eh]
		sub	ah,2
		jnc	loc_0820		; Jump if carry=0
		retn
loc_0820:
		mov	cl,1
		test	byte ptr [si+13h],80h
		jnz	loc_082A		; Jump if not zero
		mov	cl,0FFh
loc_082A:
		mov	[si+13h],cl
		or	byte ptr [si+24h],8
		mov	byte ptr [si+12h],8
		test	byte ptr [si+11h],80h
		jnz	loc_0856		; Jump if not zero
		test	byte ptr [si+24h],80h
		jnz	loc_0856		; Jump if not zero
		dec	byte ptr [si+0Eh]
		dec	byte ptr [si+0Eh]
		call	sub_0B2C
		test	byte ptr [si+11h],80h
		jz	loc_0856		; Jump if zero
		inc	byte ptr [si+0Eh]
		inc	byte ptr [si+0Eh]
loc_0856:
		mov	bx,0CE61h
		jmp	loc_3192

;==== External Entry into Subroutine ======================================

sub_085C:
		test	byte ptr [si+11h],40h	; '@'
		jnz	loc_0863		; Jump if not zero
		retn
loc_0863:
		mov	bx,offset data_DF4D
		test	byte ptr [bx],2
		jz	loc_086C		; Jump if zero
		retn
loc_086C:
		pop	cx
		mov	bx,0D378h
		test	byte ptr [si+13h],80h
		jz	loc_0879		; Jump if zero
		mov	bx,0D3AAh
loc_0879:
		call	sub_0907
		jmp	loc_1065
loc_087F:
		mov	ah,ds:data_F126_e
		test	ah,4
		jz	loc_0889		; Jump if zero
		retn
loc_0889:
		test	ah,40h			; '@'
		jnz	loc_0893		; Jump if not zero
		mov	ah,80h
		mov	[si+0Dh],ah
loc_0893:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si+2],ah
		mov	ah,data_DF4D
		test	ah,2
		jnz	loc_08F5		; Jump if not zero
		mov	ah,ds:data_F133_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_08F5		; Jump if zero
		cmp	ah,4Eh			; 'N'
		jae	loc_08F5		; Jump if above or =
		mov	ah,ds:data_F12D_e
		test	ah,80h
		jnz	loc_08E3		; Jump if not zero
		inc	ah
		mov	ds:data_F12D_e,ah
		cmp	ah,0C8h
		jne	loc_08F5		; Jump if not equal
		dec	ah
		mov	ds:data_F12D_e,ah
		mov	bx,0D396h
		test	byte ptr [si+13h],80h
		jz	loc_08D4		; Jump if zero
		mov	bx,0D3C8h
loc_08D4:
		call	sub_0907
		call	sub_1065
		jc	loc_08DD		; Jump if carry Set
		retn
loc_08DD:
		mov	ah,80h
		mov	ds:data_F12D_e,ah
loc_08E3:
		mov	bx,0D39Bh
		test	byte ptr [si+13h],80h
		jz	loc_08EF		; Jump if zero
		mov	bx,0D3CDh
loc_08EF:
		call	sub_0907
		jmp	loc_1065
loc_08F5:
		test	byte ptr [si+13h],80h
		mov	bx,0D36Fh
		jz	loc_0901		; Jump if zero
		mov	bx,offset data_D3A1
loc_0901:
		mov	ah,[bx]
		mov	[si+10h],ah
		retn

;==== External Entry into Subroutine ======================================

sub_0907:
		mov	dl,[bx]
		inc	bx
		mov	cl,[bx]
		inc	bx
		mov	ch,[bx]
		inc	bx
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0919		; Jump if zero
		mov	[si+13h],ah
loc_0919:
		inc	bx
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0921		; Jump if not zero
		retn
loc_0921:
		mov	[si+14h],ah
		retn
loc_0925:
		mov	ah,ds:data_F11B_e	; lives
; This instruction is self-modified (address 0929h)
loc_lives_dec:	dec	ah			; decrement lives
		mov	ds:data_F11B_e,ah	; save new lives
		push	ax
		call	sub_2373
		pop	ax
		cmp	ah,0FFh
		jne	loc_093C		; Jump if not equal
		jmp	loc_016F
loc_093C:
		mov	si,data_F1CF_e
		mov	byte ptr [si+11h],0
		mov	byte ptr [si+24h],0
		or	byte ptr [si],20h	; ' '
		call	sub_39A9
		call	sub_1327
		and	byte ptr [si],0DFh
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F126_e,ah
		mov	ds:data_F133_e,ah
		mov	ah,ds:data_F131_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0966		; Jump if not zero
		retn
loc_0966:
		call	sub_1D1A
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F131_e,ah
		mov	ah,16h
		mov	ds:data_F125_e,ah
		retn
sub_048E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0976	proc	near
		pop	bx
		test	byte ptr [si+11h],40h	; '@'
		jnz	loc_0984		; Jump if not zero
		mov	byte ptr [si+14h],7Fh
		jmp	loc_2CE2
loc_0984:
		test	byte ptr [si+11h],1
		jz	loc_098D		; Jump if zero
		jmp	loc_0633
loc_098D:
		mov	bx,0D387h
		test	byte ptr [si+13h],80h
		jz	loc_0999		; Jump if zero
		mov	bx,0D3B9h
loc_0999:
		call	sub_0907
		call	sub_1065
		jc	loc_09A2		; Jump if carry Set
		retn
loc_09A2:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_ret_09A9		; Jump if zero
		jmp	loc_0925

loc_ret_09A9:
		retn
sub_0976	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_09AA	proc	near
		mov	ah,ds:data_F115_e
		test	byte ptr [si+11h],4
		jz	loc_09B5		; Jump if zero
		retn
loc_09B5:
		test	ah,10h
		jnz	loc_09BB		; Jump if not zero
		retn
loc_09BB:
		mov	ah,ds:data_F11D_e
		cmp	ah,42h			; 'B'
		jne	loc_09C5		; Jump if not equal
		retn
loc_09C5:
		cmp	ah,3Bh			; ';'
		jne	loc_09CB		; Jump if not equal
		retn
loc_09CB:
		cmp	ah,41h			; 'A'
		jne	loc_09D1		; Jump if not equal
		retn
loc_09D1:
		mov	ah,ds:data_F133_e
		cmp	ah,3Ch			; '<'
		jne	loc_09DB		; Jump if not equal
		retn
loc_09DB:
		mov	ah,ds:data_F127_e
		cmp	ah,3Ch			; '<'
		jb	loc_09E5		; Jump if below
		retn
loc_09E5:
		add	ah,1
		mov	ds:data_F127_e,ah
		jmp	loc_364E
sub_09AA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_09EF	proc	near
		mov	ah,ds:data_F115_e
		test	ah,10h
		jz	loc_09F9		; Jump if zero
		retn
loc_09F9:
		mov	ah,ds:data_F127_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0A02		; Jump if not zero
		retn
loc_0A02:
		pop	bx
		or	byte ptr [si+11h],4
		mov	bx,0D37Eh
		test	byte ptr [si+13h],80h
		jz	loc_0A13		; Jump if zero
		mov	bx,offset data_D3B0
loc_0A13:
		mov	ah,[bx]
		mov	[si+10h],ah
		retn
sub_09EF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A19	proc	near
		and	byte ptr [si+11h],0BFh
		call	sub_0A8E
		call	sub_0ABA
		call	sub_2C79
		jmp	short $+2		; delay for I/O
		mov	cx,20h
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	cx,ds:data_F1C5_e
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	ah,[si+0Fh]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0A5A		; Jump if zero
		xchg	dx,bx
		mov	cx,ds:data_F1C3_e
		shr	ch,1			; Shift w/zeros fill
		rcr	cl,1			; Rotate thru carry
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		xchg	dx,bx
;*		mov	ch,bh
		db	 88h,0FDh		;  Fixup - byte match
;*		mov	cl,dh
		db	 88h,0F1h		;  Fixup - byte match
		call	sub_0A79
		cmp	ah,32h			; '2'
		je	loc_0A55		; Jump if equal
		retn
loc_0A55:
		and	byte ptr [si+11h],0BFh
		retn
loc_0A5A:
		mov	ah,13h
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jnc	loc_0A67		; Jump if carry=0
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F3CC_e,ah
		retn
loc_0A67:
;*		mov	ch,bh
		db	 88h,0FDh		;  Fixup - byte match
;*		mov	cl,dh
		db	 88h,0F1h		;  Fixup - byte match
		call	sub_0A79
		inc	bx
		call	sub_0A7C
		mov	ds:data_F3CC_e,ah
		inc	bx
		jmp	short loc_0A7C

;==== External Entry into Subroutine ======================================

sub_0A79:
		call	sub_10D5

;==== External Entry into Subroutine ======================================

sub_0A7C:
loc_0A7C:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0A83		; Jump if not zero
		retn
loc_0A83:
		cmp	ah,4Eh			; 'N'
		jb	loc_0A89		; Jump if below
		retn
loc_0A89:
		or	byte ptr [si+11h],40h	; '@'
		retn
sub_0A19	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A8E	proc	near
		mov	bx,offset data_D465
		mov	dl,[si+0Fh]
		shl	dl,1			; Shift w/zeros fill
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dh,[bx]
		inc	bx
		mov	dl,[bx]
;*		mov	bl,dh
		db	 88h,0F3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	ds:data_F1C5_e,bx
;*		mov	dh,dl
		db	 88h,0D6h		;  Fixup - byte match
		mov	dl,0
		mov	ds:data_F1C3_e,dx
		retn
sub_0A8E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0ABA	proc	near
		mov	ah,[si+24h]
		and	ah,0Fh
		mov	[si+24h],ah
		mov	ah,[si+0Eh]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0ACD		; Jump if not zero
		call	sub_0B0D
loc_0ACD:
		test	ah,80h
		jz	loc_0AD5		; Jump if zero
		call	sub_0B0D
loc_0AD5:
		mov	dx,ds:data_F1C5_e
		mov	bh,[si+0Eh]
		mov	bl,[si+0Dh]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dx,1400h
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		jc	loc_0AEB		; Jump if carry Set
		call	sub_0B26
loc_0AEB:
		mov	ah,[si+0Ch]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0AF5		; Jump if not zero
		call	sub_0B21
loc_0AF5:
		mov	dx,ds:data_F1C3_e
		mov	bl,[si+0Bh]
		mov	bh,[si+0Ch]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,27h			; '''
;*		sub	ah,bh
		db	 28h,0FCh		;  Fixup - byte match
		jc	loc_0B08		; Jump if carry Set
		retn
loc_0B08:
		or	byte ptr [si+24h],20h	; ' '
		retn
sub_0ABA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B0D	proc	near
		test	ah,80h
		jnz	loc_0B1C		; Jump if not zero
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jnz	loc_0B1C		; Jump if not zero
		retn
loc_0B1C:
		or	byte ptr [si+24h],80h
		retn
sub_0B0D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B21	proc	near
		or	byte ptr [si+24h],10h
		retn
sub_0B21	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B26	proc	near
		or	byte ptr [si+24h],40h	; '@'
		retn
sub_0B26	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B2C	proc	near
		mov	ah,ds:data_F107_e
		test	ah,8
		jz	loc_0B36		; Jump if zero
		retn
loc_0B36:
		mov	ah,ds:data_F107_e
		test	ah,20h			; ' '
		jz	loc_0B40		; Jump if zero
		retn
loc_0B40:
		and	byte ptr [si+11h],7Fh
		and	byte ptr [si+11h],0DFh
		and	byte ptr [si+11h],0EFh
		mov	cl,[si+0Ch]
		mov	ch,[si+0Eh]
		call	sub_10D5
		mov	ah,10h
		mov	ds:data_F1B5_e,ah
		mov	di,offset data_D3D1
		mov	dh,0
loc_0B60:
		push	bx
		inc	di
		mov	ah,0FFh
		mov	dl,[di]
;*		cmp	ah,dl
		db	 38h,0D4h		;  Fixup - byte match
		jz	loc_0B84		; Jump if zero
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
		cmp	ah,4Eh			; 'N'
		pop	bx
		jnc	loc_0B60		; Jump if carry=0
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0B60		; Jump if zero
		mov	ah,ds:data_F1B5_e
		or	ah,[si+11h]
		mov	[si+11h],ah
		jmp	short loc_0B60
loc_0B84:
		pop	bx
		mov	ah,ds:data_F1B5_e
		shl	ah,1			; Shift w/zeros fill
		mov	ds:data_F1B5_e,ah
		jnc	loc_0B60		; Jump if carry=0
		mov	ah,[si+0Ch]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0B9E		; Jump if zero
		cmp	ah,24h			; '$'
		jae	loc_0BA3		; Jump if above or =
		retn
loc_0B9E:
		and	byte ptr [si+11h],0EFh
		retn
loc_0BA3:
		and	byte ptr [si+11h],0DFh
		retn
sub_0B2C	endp

			                        ;* No entry point to code
		mov	ah,0Dh
		mov	bx,data_F17B_e
		sub	ah,[bx]
		mov	dx,12Ch
		call	sub_1139
		push	bx
		pop	cx
		jmp	loc_114F

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0BBA	proc	near
		call	sub_3944
		call	sub_0224
		call	sub_02DE
		call	sub_2373
		call	sub_0FFC
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_DF4D,ah
loc_0BCF:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	byte ptr ds:data_F12A_e+1,ah
		call	sub_02F7
		call	sub_022E
		call	sub_0E0C
		call	sub_2BD2
		call	sub_2B25
		call	sub_0DEC
		call	sub_38B9
		jmp	loc_3180
sub_0BBA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0BED	proc	near
		mov	si,data_F1F8_e
		test	byte ptr [si],80h
		jz	loc_0BF6		; Jump if zero
		retn
loc_0BF6:
		mov	ah,0A0h
		call	sub_2C70
		jnz	loc_0C03		; Jump if not zero
		inc	dh
		inc	dh
		neg	ah
loc_0C03:
		mov	cl,0
		mov	ch,1
		call	sub_1274
		mov	ah,ds:data_F127_e
		shl	ah,1			; Shift w/zeros fill
		neg	ah
		mov	[si+14h],ah
		mov	ah,1
		jmp	loc_3F5B
sub_0BED	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0C1A	proc	near
		mov	si,data_F1CF_e
		mov	ah,[si+24h]
		and	ah,0F0h
		jnz	loc_0C26		; Jump if not zero
		retn
loc_0C26:
		mov	di,ds:data_F1CD_e
		test	ah,80h
		jnz	loc_0C73		; Jump if not zero
		test	ah,40h			; '@'
		jz	loc_0C37		; Jump if zero
		jmpn	loc_0CAB
loc_0C37:
		test	ah,20h			; ' '
		jnz	loc_0C57		; Jump if not zero
		call	sub_0D1D
		jnz	loc_0C42		; Jump if not zero
		retn
loc_0C42:
		mov	ah,[di]
		cmp	ah,0FFh
		jne	loc_0C52		; Jump if not equal
		and	byte ptr [si+11h],0FEh
		mov	byte ptr [si+0Ch],0
		retn
loc_0C52:
		mov	dl,25h			; '%'
		jmp	loc_0CDB
loc_0C57:
		call	sub_0D18
		jz	loc_0C5D		; Jump if zero
		retn
loc_0C5D:
		mov	dx,2
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	ah,[di]
		cmp	ah,0FFh
		jne	loc_0C6E		; Jump if not equal
		and	byte ptr [si+11h],0FEh
		retn
loc_0C6E:
		mov	dl,0
		jmpn	loc_0CDB
loc_0C73:
		mov	ah,[si+0Eh]
		test	ah,80h
		jnz	loc_0C94		; Jump if not zero
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jz	loc_0C8D		; Jump if zero
		mov	ah,ds:data_F47E_e
		test	ah,80h
		jnz	loc_0C94		; Jump if not zero
loc_0C8D:
		test	byte ptr [si+14h],80h
		jnz	loc_0C94		; Jump if not zero
		retn
loc_0C94:
		mov	ah,[di+3]
		cmp	ah,0FFh
		jne	loc_0C9D		; Jump if not equal
		retn
loc_0C9D:
		mov	ds:data_F11D_e,ah
		mov	byte ptr [si+0Eh],10h
		mov	byte ptr [si+0Dh],80h
		jmp	short loc_0CE6
loc_0CAB:
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jz	loc_0CBD		; Jump if zero
		mov	ah,ds:data_F47E_e
		test	ah,80h
		jz	loc_0CC4		; Jump if zero
loc_0CBD:
		test	byte ptr [si+14h],80h
		jz	loc_0CC4		; Jump if zero
		retn
loc_0CC4:
		inc	di
		mov	ah,[di]
		cmp	ah,0FFh
		jne	loc_0CCD		; Jump if not equal
		retn
loc_0CCD:
		mov	ds:data_F11D_e,ah
		mov	byte ptr [si+0Eh],0
		mov	byte ptr [si+0Dh],80h
		jmp	short loc_0CE6
loc_0CDB:
		mov	ds:data_F11D_e,ah
		mov	byte ptr [si+0Bh],0
		mov	[si+0Ch],dl
loc_0CE6:
		call	sub_3944
		mov	si,data_F1CF_e
		or	byte ptr [si],40h	; '@'
		call	sub_11F3
		call	sub_2240
		call	sub_12D3
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F126_e,ah
		mov	bx,0F1F8h
		mov	byte ptr [bx],0
		mov	dx,0F1F9h
		mov	cx,1C2h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		jmp	loc_0BCF
sub_0C1A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D18	proc	near
		test	byte ptr [si+13h],80h
		retn
sub_0D18	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D1D	proc	near
		mov	ah,ds:data_F133_e
		cmp	ah,2Ch			; ','
		je	loc_0D2B		; Jump if equal
		test	byte ptr [si+13h],80h
		retn
loc_0D2B:
		mov	ah,ds:data_F115_e
		test	ah,8
		jnz	loc_0D3E		; Jump if not zero
		or	ah,80h
		mov	ds:data_F1E2_e,ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_0D3E:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
sub_0D1D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D41	proc	near
		mov	bx,data_F136_e
		or	byte ptr [bx],1
		test	byte ptr [bx],2
		jz	loc_0D4F		; Jump if zero
		jmpn	loc_0DC0
loc_0D4F:
		mov	bx,data_F126_e
		test	byte ptr [bx],40h	; '@'
		jz	loc_0D58		; Jump if zero
		retn
loc_0D58:
		mov	ah,ds:data_F11D_e
		cmp	ah,42h			; 'B'
		jne	loc_0D62		; Jump if not equal
		retn
loc_0D62:
		mov	ah,ds:data_F133_e
		cmp	ah,2Ch			; ','
		jne	loc_0D6C		; Jump if not equal
		retn
loc_0D6C:
		cmp	ah,3Ch			; '<'
		jne	loc_0D72		; Jump if not equal
		retn
loc_0D72:
		mov	bx,ds:data_F1DC_e
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,0Ah
		push	bx
		jc	loc_0DC2		; Jump if carry Set
		mov	ah,data_DF4D
		test	ah,1
		jnz	loc_0DC2		; Jump if not zero
		mov	bx,ds:data_F1DA_e
		mov	data_DF50,bx
		test	byte ptr [si+13h],80h
		jnz	loc_0D9D		; Jump if not zero
		inc	bh
		inc	bh
		mov	data_DF50,bx
loc_0D9D:
		pop	bx
		pop	cx
		mov	dx,200h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_DF52,bx
		call	sub_0ED2
		jnc	loc_0DAE		; Jump if carry=0
		retn
loc_0DAE:
		call	sub_0FE3
		mov	bx,offset data_DF4D
		or	byte ptr [bx],1
		mov	ah,ds:data_F11D_e
		mov	ds:data_F122_e,ah
		retn
loc_0DC0:
		pop	cx
		retn
loc_0DC2:
		pop	bx
		mov	ah,ds:data_F115_e
		retn
sub_0D41	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0DC8	proc	near
		mov	bx,data_F136_e
		or	byte ptr [bx],1
		test	byte ptr [bx],2
		jnz	loc_0DC0		; Jump if not zero
		mov	ah,data_DF4D
		test	ah,2
		jnz	loc_0DDD		; Jump if not zero
		retn
loc_0DDD:
		and	ah,0F8h
		mov	data_DF4D,ah
		call	sub_0F82
		call	sub_0FE3
		pop	cx
		retn
sub_0DC8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0DEC	proc	near
		mov	ah,data_DF4D
		test	ah,1
		jnz	loc_0DF6		; Jump if not zero
		retn
loc_0DF6:
		mov	ah,ds:data_F122_e
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,ds:data_F11D_e
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jz	loc_0E05		; Jump if zero
		retn
loc_0E05:
		call	sub_0ED2
		jnc	loc_ret_0E0B		; Jump if carry=0
		retn

loc_ret_0E0B:
		retn
sub_0DEC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0E0C	proc	near
		mov	ch,8
		mov	bx,data_F480_e
loc_0E11:
		push	cx
		push	bx
		mov	ah,ds:data_F11D_e
		cmp	ah,[bx]
		jne	loc_0E27		; Jump if not equal
		inc	bx
		inc	bx
		push	bx
		call	sub_12A7
		pop	di
		jc	loc_0E27		; Jump if carry Set
		call	sub_1229
loc_0E27:
		mov	dx,8
		pop	bx
		pop	cx
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_0E11		; Jump if not zero
		retn
sub_0E0C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0E33	proc	near
		mov	bx,offset data_DF4D
		and	byte ptr [bx],0FBh
		mov	ah,ds:data_F115_e
		test	ah,2
		jnz	loc_0E7C		; Jump if not zero
		test	ah,1
		jnz	loc_0E48		; Jump if not zero
		retn
loc_0E48:
		mov	ch,[si+0Eh]
		dec	ch
		mov	cl,[si+0Ch]
		call	sub_10D5
		mov	ah,66h			; 'f'
		cmp	ah,[bx]
		je	loc_0E6C		; Jump if equal
		mov	ah,69h			; 'i'
		cmp	ah,[bx]
		je	loc_0E6C		; Jump if equal
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,[bx]
		jz	loc_0E6C		; Jump if zero
		mov	ah,4Eh			; 'N'
		cmp	ah,[bx]
		jb	loc_0E6C		; Jump if below
		retn
loc_0E6C:
		mov	bx,0D391h
		call	sub_0907
		call	sub_1065
		jnc	loc_0EC0		; Jump if carry=0
		dec	byte ptr [si+0Eh]
		jmp	short loc_0EBA
loc_0E7C:
		mov	ah,ds:data_F133_e
		cmp	ah,66h			; 'f'
		je	loc_0E90		; Jump if equal
		cmp	ah,69h			; 'i'
		je	loc_0E90		; Jump if equal
		cmp	ah,4Eh			; 'N'
		jae	loc_0E90		; Jump if above or =
		retn
loc_0E90:
		mov	ah,byte ptr data_DF52+1
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,byte ptr ds:data_F1DC_e+1
		inc	ah
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnz	loc_0EA1		; Jump if not zero
		retn
loc_0EA1:
		jc	loc_0EA4		; Jump if carry Set
		retn
loc_0EA4:
		mov	ah,0Fh
		cmp	ah,[si+0Eh]
		jae	loc_0EAC		; Jump if above or =
		retn
loc_0EAC:
		mov	bx,0D3C3h
		call	sub_0907
		call	sub_1065
		jnc	loc_0EC0		; Jump if carry=0
		inc	byte ptr [si+0Eh]
loc_0EBA:
		mov	bx,0CF4Fh
		call	sub_3192
loc_0EC0:
		mov	bx,data_DF50
		mov	bl,0
		mov	ds:data_F1DA_e,bx
		mov	bx,offset data_DF4D
		or	byte ptr [bx],4
		pop	cx
		retn
sub_0E33	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0ED2	proc	near
		mov	ah,ds:data_F11D_e
		cmp	ah,42h			; 'B'
		jne	loc_0EDC		; Jump if not equal
		retn
loc_0EDC:
		mov	ah,byte ptr data_DF50+1
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ah,byte ptr data_DF52+1
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		push	cx
		inc	ch
		call	sub_10D5
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0EFB		; Jump if not zero
		inc	bx
		cmp	ah,[bx]
		jne	loc_0EFB		; Jump if not equal
		jmp	short loc_0F2D
loc_0EFB:
		pop	cx
		push	cx
		call	sub_10D5
		mov	dx,0F465h
		mov	ch,0Ah
		push	bx
loc_0F06:
		push	cx
		mov	al,[bx]
		xchg	dx,bx
		mov	[bx],al
		xchg	dx,bx
		inc	bx
		inc	dx
		mov	al,[bx]
		xchg	dx,bx
		mov	[bx],al
		xchg	dx,bx
		inc	bx
		inc	dx
		mov	cx,2Ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_0F06		; Jump if not zero
		call	sub_0F67
		jc	loc_0F30		; Jump if carry Set
		pop	bx
loc_0F2D:
		pop	cx
		stc				; Set carry flag
		retn
loc_0F30:
		pop	bx
		mov	ch,0Ah
loc_0F33:
		push	cx
		mov	ah,66h			; 'f'
		mov	[bx],ah
		inc	bx
		mov	ah,69h			; 'i'
		mov	[bx],ah
		mov	cx,29h
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_0F33		; Jump if not zero
		pop	cx
		mov	ah,0Ah
loc_0F4C:
		push	ax
		push	cx
		mov	ah,66h			; 'f'
		call	sub_3895
		pop	cx
		push	cx
		inc	cl
		mov	ah,69h			; 'i'
		call	sub_3895
		pop	cx
		dec	ch
		pop	ax
		dec	ah
		jnz	loc_0F4C		; Jump if not zero
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_0ED2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F67	proc	near
		mov	bx,data_F465_e
		mov	ch,14h
loc_0F6C:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,[bx]
		jz	loc_0F7B		; Jump if zero
		mov	ah,4Eh			; 'N'
		cmp	ah,[bx]
		jb	loc_0F7B		; Jump if below
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_0F7B:
		inc	bx
		dec	ch
		jnz	loc_0F6C		; Jump if not zero
		stc				; Set carry flag
		retn
sub_0F67	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F82	proc	near
		mov	ah,byte ptr data_DF50+1
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ah,byte ptr data_DF52+1
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		push	cx
		call	sub_10D5
		mov	dx,0F465h
		mov	ch,0Ah
		xchg	dx,bx
loc_0F99:
		push	cx
		mov	al,[bx]
		xchg	dx,bx
		mov	[bx],al
		xchg	dx,bx
		inc	bx
		inc	dx
		mov	al,[bx]
		xchg	dx,bx
		mov	[bx],al
		xchg	dx,bx
		inc	bx
		inc	dx
		mov	cx,2Ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		xchg	dx,bx
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		xchg	dx,bx
		pop	cx
		dec	ch
		jnz	loc_0F99		; Jump if not zero
		pop	cx
		mov	ah,0Ah
		mov	bx,data_F465_e
loc_0FC4:
		push	ax
		push	cx
		mov	ah,[bx]
		push	bx
		call	sub_3895
		pop	bx
		pop	cx
		push	cx
		inc	cl
		inc	bx
		mov	ah,[bx]
		push	bx
		call	sub_3895
		pop	bx
		inc	bx
		pop	cx
		dec	ch
		pop	ax
		dec	ah
		jnz	loc_0FC4		; Jump if not zero
		retn
sub_0F82	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FE3	proc	near
		retn
sub_0FE3	endp

			                        ;* No entry point to code
		mov	cx,ds:data_F17B_e
		mov	si,data_F17D_e
		mov	bl,[si]
		mov	bh,[si+1]
		or	byte ptr [bx],40h	; '@'
		retn
		db	 75h,0F5h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FF6	proc	near
		mov	ah,8
		mov	ds:data_F1AF_e,ah

;==== External Entry into Subroutine ======================================

sub_0FFC:
		call	sub_1058
		mov	byte ptr ds:data_F107_e+1,ah
		call	sub_1058
		mov	ds:data_F109_e,ah
		call	sub_1058
		mov	ds:data_F10A_e,ah
		call	sub_1058
		mov	ds:data_F10B_e,ah
		call	sub_1058
		mov	ds:data_F10C_e,ah
		call	sub_1058
		mov	ds:data_F10D_e,ah
		call	sub_1058
		mov	ds:data_F10E_e,ah
		call	sub_1058
		mov	ds:data_F10F_e,ah
		call	sub_1058
		mov	ds:data_F110_e,ah
		call	sub_1058
		mov	ds:data_F111_e,ah
		call	sub_1058
		mov	ds:data_F112_e,ah
		call	sub_1058
		mov	ds:data_F113_e,ah
		call	sub_1058
		mov	ds:data_F114_e,ah
		retn
sub_0FF6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1058	proc	near
loc_1058:
		call	sub_1111
		and	ah,0Fh
		cmp	ah,0Ah
		jae	loc_1058		; Jump if above or =
		retn
sub_1058	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1065	proc	near
loc_1065:
		inc	ch
		mov	ah,[si+10h]
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jc	loc_1072		; Jump if carry Set
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_10A4		; Jump if carry Set
loc_1072:
		mov	[si+10h],cl
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si+15h],ah
		retn
			                        ;* No entry point to code
		inc	ch
		mov	ah,[si+10h]
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jc	loc_1088		; Jump if carry Set
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_10A4		; Jump if carry Set
loc_1088:
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1095		; Jump if zero
		mov	ah,[si+10h]
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
		jmp	short loc_109A
loc_1095:
		mov	ah,[si+10h]
;*		sub	ah,ch
		db	 28h,0ECh		;  Fixup - byte match
loc_109A:
		mov	[si+10h],ah
		mov	byte ptr [si+15h],0
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
loc_10A4:
		mov	ah,[si+15h]
;*		cmp	ah,dl
		db	 38h,0D4h		;  Fixup - byte match
		jnc	loc_10B1		; Jump if carry=0
		inc	byte ptr [si+15h]
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
loc_10B1:
		mov	ah,[si+10h]
		inc	ah
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_10C4		; Jump if carry=0
		mov	[si+10h],ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si+15h],ah
		stc				; Set carry flag
		retn
loc_10C4:
		dec	ch
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		mov	[si+10h],cl
		mov	byte ptr [si+15h],0
		stc				; Set carry flag
		retn
sub_1065	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10D5	proc	near
;*		mov	bl,ch
		db	 88h,0EBh		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ch,0
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	dx,0EDE3h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		retn
sub_10D5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10F3	proc	near
		call	sub_381E
		jz	loc_10FB		; Jump if zero
		jmp	loc_016F
loc_10FB:
		call	sub_3833
		jnz	loc_1101		; Jump if not zero
		retn
loc_1101:
		call	sub_3833
		jnz	loc_1101		; Jump if not zero
loc_1106:
		call	sub_3833
		jz	loc_1106		; Jump if zero
loc_110B:
		call	sub_3833
		jnz	loc_110B		; Jump if not zero
		retn
sub_10F3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1111	proc	near
		push	bx
		push	dx
		mov	dx,ds:data_F1AF_e
;*		mov	bh,dl
		db	 88h,0D7h		;  Fixup - byte match
		mov	bl,0FDh
;*		mov	ah,dh
		db	 88h,0F4h		;  Fixup - byte match
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		sbb	ah,0
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		sbb	ah,0
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		jnc	loc_1130		; Jump if carry=0
		inc	bx
loc_1130:
		mov	ds:data_F1AF_e,bx
;*		mov	ah,bl
		db	 88h,0DCh		;  Fixup - byte match
		pop	dx
		pop	bx
		retn
sub_1111	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1139	proc	near
		push	cx
		mov	bx,0
		mov	ch,8
loc_113F:
		rcr	ah,1			; Rotate thru carry
		jnc	loc_1145		; Jump if carry=0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
loc_1145:
		rcl	dl,1			; Rotate thru carry
		rcl	dh,1			; Rotate thru carry
		dec	ch
		jnz	loc_113F		; Jump if not zero
		pop	cx
		retn
sub_1139	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_114F	proc	near
loc_114F:
		dec	cx
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
;*		or	ah,cl
		db	 08h,0CCh		;  Fixup - byte match
		jnz	loc_114F		; Jump if not zero
		retn
sub_114F	endp

			                        ;* No entry point to code
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1162	proc	near
loc_1162:
		push	dx
		push	cx
loc_1164:
		mov	ah,0FFh
		call	sub_2C57
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	dh,1
		push	dx
		call	sub_3851
		pop	dx
		inc	cl
		dec	dl
		jnz	loc_1164		; Jump if not zero
		pop	cx
		pop	dx
		inc	ch
		dec	dh
		jnz	loc_1162		; Jump if not zero
		retn
sub_1162	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1181	proc	near
loc_1181:
		mov	ah,[bx]
		cmp	ah,0FFh
		jne	loc_1189		; Jump if not equal
		retn
loc_1189:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_11A0		; Jump if zero
		cmp	ah,20h			; ' '
		je	loc_1195		; Jump if equal
		sub	ah,20h			; ' '
loc_1195:
		sub	ah,20h			; ' '
		push	bx
		call	sub_11B1
		pop	bx
		inc	bx
		jmp	short loc_1181
loc_11A0:
		inc	bx
		mov	ah,[bx]
		inc	bx
		mov	byte ptr ds:data_F1B9_e+1,ah
		mov	ah,[bx]
		mov	ds:data_F1B9_e,ah
		inc	bx
		jmp	short loc_1181
sub_1181	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_11B1	proc	near
		push	dx
		mov	dx,0
		mov	cx,ds:data_F1B9_e
		mov	dx,0FFFFh
		call	sub_3851
		pop	dx
		mov	cx,ds:data_F1B9_e
		inc	cl
		mov	ah,27h			; '''
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jnc	loc_11D9		; Jump if carry=0
		mov	cl,0
		inc	ch
		mov	ah,18h
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_11D9		; Jump if carry=0
		mov	cx,0
loc_11D9:
		mov	ds:data_F1B9_e,cx
		retn
sub_11B1	endp

loc_11DE:
		push	cx
		mov	ah,[bx]
;*		mov	cl,dl
		db	 88h,0D1h		;  Fixup - byte match
;*		mov	ch,dh
		db	 88h,0F5h		;  Fixup - byte match
		push	dx
		call	sub_3895
		pop	dx
		inc	dl
		inc	bx
		pop	cx
		dec	ch
		jnz	loc_11DE		; Jump if not zero
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_11F3	proc	near
loc_11F3:
		push	si
		pop	bx
		mov	cx,3
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		push	bx
		pop	dx
		mov	cx,8
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_11F3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_120D	proc	near
loc_120D:
		push	si
		pop	bx
		mov	cx,3
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		push	bx
		pop	dx
		mov	cx,8
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		xchg	dx,bx
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_120D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1229	proc	near
loc_1229:
		call	sub_1292
		mov	ah,[di-1]
		mov	[si+0Ah],ah
		mov	ah,[di]
		mov	[si+7],ah
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ah,[di+1]
		mov	[si+8],ah
		mov	ah,[di+2]
		mov	[si+3],ah
		mov	ah,[di+3]
		mov	[si+4],ah
		mov	ah,[di+4]
		mov	[si+5],ah
		mov	ah,[di+5]
		mov	[si+6],ah
		mov	ah,[di+6]
		mov	[si+22h],ah
		add	ah,7
		mov	[si+20h],ah
		mov	ah,[di+7]
		mov	[si+23h],ah
		adc	ah,0
		mov	[si+21h],ah
		mov	ah,[si+8]
		jmp	short loc_128C

;==== External Entry into Subroutine ======================================

sub_1274:
loc_1274:
		call	sub_1292
		mov	[si+7],ch
		mov	[si+8],cl
		mov	[si+3],dl
		mov	[si+4],dh
		mov	[si+5],bl
		mov	[si+6],bh
		mov	[si+13h],ah
loc_128C:
		call	sub_3B61
		jmp	loc_120D
sub_1229	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1292	proc	near
		push	di
		push	cx
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,28h
		mov	al,0
		cld				; Clear direction
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		or	byte ptr [si],80h
		or	byte ptr [si],40h	; '@'
		pop	cx
		pop	di
		retn
sub_1292	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_12A7	proc	near
		mov	ah,ds:data_F133_e
		cmp	ah,3Ch			; '<'
		jne	loc_12B2		; Jump if not equal
		stc				; Set carry flag
		retn

;==== External Entry into Subroutine ======================================

sub_12B2:
loc_12B2:
		mov	si,data_F221_e
		mov	dx,29h
		mov	ch,0Ah
loc_12BA:
		test	byte ptr [si],80h
		jz	loc_12C7		; Jump if zero
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_12BA		; Jump if not zero
		stc				; Set carry flag
		retn
loc_12C7:
		push	di
		push	bx
		mov	ah,64h			; 'd'
		call	sub_3F5B
		pop	bx
		pop	di
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_12A7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_12D3	proc	near
		push	di
		push	cx
		mov	di,data_F3DA_e
		mov	ch,4
		mov	si,data_F1CF_e
		push	si
loc_12DE:
		mov	ah,[si+0Bh]
		mov	[di],ah
		inc	di
		inc	si
		dec	ch
		jnz	loc_12DE		; Jump if not zero
		pop	si
		mov	ah,[si+13h]
		mov	[di],ah
		pop	cx
		pop	di
		retn
sub_12D3	endp

			                        ;* No entry point to code
		mov	bx,0F3DFh
		mov	dx,0F3DAh
		mov	cx,5
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		jmp	short loc_1327
			                        ;* No entry point to code
		mov	bx,data_F3DA_e
		mov	dx,0F3DFh
		mov	cx,5
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	ah,ds:data_F11D_e
		xchg	dx,bx
		mov	[bx],ah
		xchg	dx,bx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1327	proc	near
loc_1327:
		mov	si,data_F1CF_e
		mov	bx,data_F3DA_e
		mov	ch,4
loc_132F:
		mov	ah,[bx]
		mov	[si+0Bh],ah
		inc	bx
		inc	si
		dec	ch
		jnz	loc_132F		; Jump if not zero
		mov	si,data_F1CF_e
		mov	ah,[bx]
		mov	[si+13h],ah
		or	byte ptr [si],40h	; '@'
		jmp	loc_11F3
sub_1327	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1348	proc	near
		mov	ah,byte ptr ds:data_F1DC_e+1
		sub	ah,[si+0Eh]
		jc	loc_1352		; Jump if carry Set
		retn
loc_1352:
		neg	ah
		retn
sub_1348	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1355	proc	near
		mov	ah,byte ptr ds:data_F1DA_e+1
		sub	ah,[si+0Ch]
		jc	loc_135F		; Jump if carry Set
		retn
loc_135F:
		neg	ah
		retn
sub_1355	endp

			                        ;* No entry point to code
		push	bx
		mov	bx,2C0h
		mov	cx,ds:data_F1DC_e
		mov	ds:data_F1B5_e,cx
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	ds:data_F1DC_e,bx
		pop	bx
		mov	ch,1
		mov	cl,11h
		call	sub_1385
		mov	cx,ds:data_F1B5_e
		mov	ds:data_F1DC_e,cx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1385	proc	near
loc_1385:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	di,data_F1CF_e
		test	byte ptr [di],80h
		jnz	loc_1390		; Jump if not zero
		retn
loc_1390:
		mov	ah,[di+24h]
		and	ah,3
		jz	loc_1399		; Jump if zero
		retn
loc_1399:
		mov	ah,byte ptr ds:data_F12A_e+1
		test	ah,8
		jz	loc_13A3		; Jump if zero
		retn
loc_13A3:
		mov	ah,[di+10h]
		cmp	ah,8
		je	loc_13B0		; Jump if equal
		cmp	ah,1Fh
		jne	loc_13C0		; Jump if not equal
loc_13B0:
		inc	byte ptr [di+0Eh]
		inc	byte ptr [di+0Eh]
		call	sub_13C0
		dec	byte ptr [di+0Eh]
		dec	byte ptr [di+0Eh]
		retn

;==== External Entry into Subroutine ======================================

sub_13C0:
loc_13C0:
		mov	ch,16h
		mov	cl,11h
		jmp	short loc_13F4

;==== External Entry into Subroutine ======================================

sub_13C6:
loc_13C6:
		mov	di,data_F1F8_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		test	byte ptr [di],80h
		jnz	loc_13D1		; Jump if not zero
		retn
loc_13D1:
		mov	ah,[di+0Fh]
		cmp	ah,2
		je	loc_13EE		; Jump if equal
		mov	ch,0Ah
		mov	cl,7
		call	sub_13F4
		jc	loc_13E3		; Jump if carry Set
		retn
loc_13E3:
		mov	ah,1
		call	sub_1459
		or	byte ptr [di+11h],40h	; '@'
		stc				; Set carry flag
		retn
loc_13EE:
		mov	ch,0Ah
		mov	cl,7
		jmp	short loc_13F4

;==== External Entry into Subroutine ======================================

sub_13F4:
loc_13F4:
		push	dx
		push	bx
		mov	bh,[si+0Ch]
		mov	bl,[si+0Bh]
		rcl	bl,1			; Rotate thru carry
		rcl	bh,1			; Rotate thru carry
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		rcl	bl,1			; Rotate thru carry
		rcl	bh,1			; Rotate thru carry
;*		add	ah,bh
		db	 00h,0FCh		;  Fixup - byte match
		pop	bx
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
;*		add	ah,bl
		db	 00h,0DCh		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	dh,[di+0Ch]
		mov	dl,[di+0Bh]
		rcl	dl,1			; Rotate thru carry
		rcl	dh,1			; Rotate thru carry
;*		mov	ah,dh
		db	 88h,0F4h		;  Fixup - byte match
		rcl	dl,1			; Rotate thru carry
		rcl	dh,1			; Rotate thru carry
;*		add	ah,dh
		db	 00h,0F4h		;  Fixup - byte match
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		call	sub_3CAA
		pop	dx
		jc	loc_142E		; Jump if carry Set
		retn
loc_142E:
		mov	bh,[si+0Eh]
		mov	bl,[si+0Dh]
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
;*		add	ah,dl
		db	 00h,0D4h		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		push	bx
		mov	bh,[di+0Eh]
		mov	bl,[di+0Dh]
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
;*		add	ah,ch
		db	 00h,0ECh		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		pop	bx
		jmp	loc_3CAA
sub_1385	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1459	proc	near
		push	cx
		push	dx
		mov	ch,0Ch
		mov	dx,29h
		mov	di,data_F1CF_e
loc_1463:
		test	byte ptr [di],80h
		jz	loc_146D		; Jump if zero
		cmp	ah,[di+0Fh]
		je	loc_1477		; Jump if equal
loc_146D:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		dec	ch
		jnz	loc_1463		; Jump if not zero
		stc				; Set carry flag
		pop	dx
		pop	cx
		retn
loc_1477:
		pop	dx
		pop	cx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_1459	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_147C	proc	near
		push	cx
		push	dx
		mov	ch,0Ch
		mov	dx,29h
		mov	di,data_F1CF_e
loc_1486:
		test	byte ptr [di],80h
		jz	loc_1490		; Jump if zero
		cmp	ah,[di+0Fh]
		je	loc_149A		; Jump if equal
loc_1490:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		dec	ch
		jnz	loc_1486		; Jump if not zero
		stc				; Set carry flag
		pop	dx
		pop	cx
		retn
loc_149A:
		mov	ds:data_F1B5_e,ah
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
		cmp	ah,[di+10h]
		mov	ah,ds:data_F1B5_e
		jnz	loc_1490		; Jump if not zero
		pop	dx
		pop	cx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_147C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_14AE	proc	near
		push	cx
		push	dx
		mov	ch,0Ch
		mov	dx,29h
		mov	di,data_F1CF_e
loc_14B8:
		test	byte ptr [di],80h
		jz	loc_14D4		; Jump if zero
		cmp	ah,[di+0Fh]
		jne	loc_14D4		; Jump if not equal
		mov	ds:data_F1B5_e,ah
		mov	ah,[di+12h]
		and	ah,7
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		mov	ah,ds:data_F1B5_e
		jz	loc_14DE		; Jump if zero
loc_14D4:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		dec	ch
		jnz	loc_14B8		; Jump if not zero
		stc				; Set carry flag
		pop	dx
		pop	cx
		retn
loc_14DE:
		pop	dx
		pop	cx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_14AE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_14E3	proc	near
		push	cx
		push	dx
		mov	ch,0Ch
		mov	dx,29h
		mov	di,data_F1CF_e
loc_14ED:
		test	byte ptr [di],80h
		jz	loc_14F7		; Jump if zero
		cmp	ah,[di+12h]
		je	loc_1501		; Jump if equal
loc_14F7:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		dec	ch
		jnz	loc_14ED		; Jump if not zero
		stc				; Set carry flag
		pop	dx
		pop	cx
		retn
loc_1501:
		pop	dx
		pop	cx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_14E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1506	proc	near
loc_1506:
		mov	ah,ds:data_F107_e
		test	ah,8
		jz	loc_1510		; Jump if zero
		retn
loc_1510:
		mov	ah,ds:data_F11D_e
		cmp	ah,3Fh			; '?'
		jne	loc_151A		; Jump if not equal
		retn
loc_151A:
		mov	ah,ds:data_F133_e
		cmp	ah,3Ch			; '<'
		jne	loc_1524		; Jump if not equal
		retn
loc_1524:
		push	si
		mov	byte ptr ds:data_F125_e,16h
		mov	si,data_F1CF_e
		or	byte ptr [si+24h],2
		mov	byte ptr [si+11h],0
		mov	bx,data_F126_e
		or	byte ptr [bx],8
		pop	si
		retn
sub_1506	endp

			                        ;* No entry point to code
		mov	ah,25h			; '%'
		call	sub_1459
		jc	loc_1545		; Jump if carry Set
		retn
loc_1545:
		mov	bx,offset data_E0A2
		mov	dx,3
		mov	ah,ds:data_F11D_e
loc_154F:
		test	byte ptr [bx],80h
		jz	loc_1555		; Jump if zero
		retn
loc_1555:
		cmp	ah,[bx]
		je	loc_155D		; Jump if equal
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		jmp	short loc_154F
loc_155D:
		inc	bx
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
		mov	ds:data_F3D0_e,cx
		call	sub_1111
		and	ah,7Fh
		cmp	ah,8
		je	loc_1573		; Jump if equal
		retn
loc_1573:
		mov	dx,658Dh
		call	sub_15A7
		call	sub_12A7
		jnc	loc_157F		; Jump if carry=0
		retn
loc_157F:
		mov	bx,ds:data_F3D0_e
		inc	bh
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		mov	dh,bl
		db	 88h,0DEh		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	cl,2
		mov	ch,25h			; '%'
		mov	ah,0A0h
		call	sub_1274
		mov	byte ptr [si+2],8
		call	sub_1355
		cmp	ah,7
		jb	loc_15A3		; Jump if below
		retn
loc_15A3:
		or	byte ptr [si],10h
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_15A7	proc	near
loc_15A7:
		mov	ds:data_F19E_e,dx
		mov	bx,0CF45h
		call	sub_3192
		mov	dx,ds:data_F19E_e
		mov	cx,ds:data_F3D0_e
;*		mov	ah,dh
		db	 88h,0F4h		;  Fixup - byte match
		call	sub_2C57
		call	sub_3895
		mov	dx,ds:data_F19E_e
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
		inc	cl
		call	sub_2C57
		jmp	loc_3895
sub_15A7	endp

			                        ;* No entry point to code
		call	sub_0A19
		mov	bl,0Ch
		mov	dl,0Ch
		call	sub_1385
		jnc	loc_15DF		; Jump if carry=0
		pop	bx
		jmp	loc_1506
loc_15DF:
		mov	bl,0Ch
		mov	dl,0Ch
		call	sub_13C6
		jnc	loc_15F0		; Jump if carry=0
		or	byte ptr [si],10h
		mov	dx,6467h
		jmp	short loc_15A7
loc_15F0:
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1609		; Jump if zero
		mov	cx,302h
		mov	dl,2
		call	sub_1065
		jc	loc_1602		; Jump if carry Set
		retn
loc_1602:
		call	sub_2CE2
		dec	byte ptr [si+2]
		retn
loc_1609:
		test	byte ptr [si+24h],4
		jnz	loc_1645		; Jump if not zero
		test	byte ptr [si+24h],8
		jnz	loc_1627		; Jump if not zero
		or	byte ptr [si+24h],8
		mov	byte ptr [si+13h],0
		mov	byte ptr [si+14h],40h	; '@'
		mov	dx,6467h
		call	sub_15A7
loc_1627:
		test	byte ptr [si+11h],40h	; '@'
		jnz	loc_1630		; Jump if not zero
		jmp	loc_2CE2
loc_1630:
		or	byte ptr [si+24h],4
		mov	byte ptr [si+14h],0
		call	sub_1355
		mov	ah,40h			; '@'
		jnc	loc_1641		; Jump if carry=0
		neg	ah
loc_1641:
		mov	[si+13h],ah
		retn
loc_1645:
		mov	ah,[si+11h]
		or	ah,[si+24h]
		and	ah,30h			; '0'
		jz	loc_1654		; Jump if zero
		or	byte ptr [si],10h
		retn
loc_1654:
		mov	cx,302h
		test	byte ptr [si+13h],80h
		jnz	loc_1660		; Jump if not zero
		mov	cx,100h
loc_1660:
		mov	dl,2
		call	sub_1065
		jc	loc_1668		; Jump if carry Set
		retn
loc_1668:
		jmp	loc_2CBE
			                        ;* No entry point to code
		mov	di,0E136h
		mov	ah,26h			; '&'
		mov	bx,0E14Bh
		jmp	short loc_16B7
			                        ;* No entry point to code
		mov	di,0E108h
		mov	ah,1Eh
		mov	bx,0E14Bh
		jmp	short loc_16B7
			                        ;* No entry point to code
		mov	di,0E125h
		mov	ah,1Fh
		mov	bx,0E14Bh
		jmp	short loc_16B7
			                        ;* No entry point to code
		mov	di,0E0EFh
		mov	ah,7
		mov	bx,0E14Fh
		jmp	short loc_16B7
			                        ;* No entry point to code
		mov	di,0E0BEh
		mov	ah,17h
		call	sub_16B7
		mov	ah,17h
		call	sub_1459
		jnc	loc_16A3		; Jump if carry=0
		retn
loc_16A3:
		test	byte ptr [si],40h	; '@'
		jnz	loc_16A9		; Jump if not zero
		retn
loc_16A9:
		test	byte ptr [si],10h
		jz	loc_16AF		; Jump if zero
		retn
loc_16AF:
		mov	bx,0CF3Dh
		mov	ah,2
		jmp	loc_3192

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_16B7	proc	near
loc_16B7:
		mov	ds:data_F1A0_e,bx
		mov	ds:data_F1A2_e,ah
		push	di
		call	sub_1459
		pop	di
		jc	loc_16C7		; Jump if carry Set
		retn
loc_16C7:
		mov	dx,4
		mov	ah,ds:data_F11D_e
loc_16CE:
		test	byte ptr [di],80h
		jz	loc_16D4		; Jump if zero
		retn
loc_16D4:
		cmp	ah,[di]
		je	loc_16DC		; Jump if equal
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		jmp	short loc_16CE
loc_16DC:
		call	sub_1111
		cmp	ah,2
		jb	loc_16E5		; Jump if below
		retn
loc_16E5:
		call	sub_12A7
		jnc	loc_16EB		; Jump if carry=0
		retn
loc_16EB:
		mov	bl,[di+1]
		mov	bh,[di+2]
		mov	cl,0
		mov	dh,[di+3]
;*		mov	dl,cl
		db	 88h,0CAh		;  Fixup - byte match
		mov	ah,ds:data_F1A2_e
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		call	sub_1274
		mov	bx,ds:data_F1A0_e
		mov	[si+22h],bl
		mov	[si+23h],bh
		call	sub_1355
		cmp	ah,5
		jb	loc_1714		; Jump if below
		retn
loc_1714:
		or	byte ptr [si],10h
		retn
sub_16B7	endp

			                        ;* No entry point to code
		test	byte ptr [si+11h],1
		jnz	loc_1721		; Jump if not zero
		jmp	loc_18C0
loc_1721:
		mov	ah,[si+2]
		cmp	ah,19h
		jne	loc_1730		; Jump if not equal
		mov	byte ptr [si+2],0Ah
		call	sub_1506
loc_1730:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_173D		; Jump if not zero
loc_1734:
		and	byte ptr [si+11h],0FEh
		mov	byte ptr [si+2],0
		retn
loc_173D:
		mov	cx,201h
		test	byte ptr [si+13h],80h
		jz	loc_1749		; Jump if zero
		mov	cx,504h
loc_1749:
		mov	dl,4
		call	sub_1065
		jc	loc_1751		; Jump if carry Set
		retn
loc_1751:
		dec	byte ptr [si+2]
		mov	bx,0CF4Fh
		jmp	loc_3192
			                        ;* No entry point to code
		test	byte ptr [si+11h],1
		jnz	loc_1763		; Jump if not zero
		jmp	loc_18C0
loc_1763:
		test	byte ptr [si+11h],2
		jnz	loc_17A3		; Jump if not zero
		mov	ah,ds:data_F12A_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1734		; Jump if zero
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	dx,4
		mov	di,offset data_E028
loc_177B:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	ah,[di]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_177B		; Jump if not zero
		mov	byte ptr [di],1
		dec	ch
		jnz	loc_177B		; Jump if not zero
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
		mov	[si+2],ah
		or	byte ptr [si+11h],2
		mov	bx,data_F12A_e+1
		or	byte ptr [bx],1
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F12A_e,ah
loc_17A3:
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_17B7		; Jump if not zero
		mov	bx,data_F12A_e+1
		and	byte ptr [bx],0FEh
		and	byte ptr [si+11h],0FDh
		jmpn	loc_1734
loc_17B7:
		mov	cx,201h
		test	byte ptr [si+13h],80h
		jz	loc_17C3		; Jump if zero
		mov	cx,504h
loc_17C3:
		mov	dl,4
		call	sub_1065
		jc	loc_17CB		; Jump if carry Set
		retn
loc_17CB:
		mov	bx,0CF18h
		call	sub_3192
		dec	byte ptr [si+2]
		mov	ah,[si+2]
		mov	dx,19h
		call	sub_1139
		mov	cx,1505h
		mov	ah,5
		call	sub_3388
		retn
			                        ;* No entry point to code
		test	byte ptr [si+11h],1
		jnz	loc_17EF		; Jump if not zero
		jmp	loc_18C0
loc_17EF:
		test	byte ptr [si+11h],2
		jnz	loc_1815		; Jump if not zero
		mov	byte ptr [si+2],0Ah
		mov	bx,data_F12A_e+1
		or	byte ptr [bx],80h
		mov	cx,202h
		test	byte ptr [si+13h],80h
		jz	loc_180B		; Jump if zero
		mov	cx,505h
loc_180B:
		mov	dl,1
		call	sub_1065
		or	byte ptr [si+11h],2
		retn
loc_1815:
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_183E		; Jump if not zero
		mov	bx,data_F12A_e+1
		and	byte ptr [bx],7Fh
		mov	ah,ds:data_F125_e
		sub	ah,5
		jnc	loc_1830		; Jump if carry=0
		call	sub_1506
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
loc_1830:
		mov	ds:data_F125_e,ah
		call	sub_361D
		and	byte ptr [si+11h],0FDh
		jmp	loc_1734
loc_183E:
		dec	byte ptr [si+2]
		mov	bx,0D3A7h
		mov	cl,40h			; '@'
		test	byte ptr [si+13h],80h
		jz	loc_1851		; Jump if zero
		mov	bx,offset data_D375
		mov	cl,0C0h
loc_1851:
		mov	si,data_F1CF_e
		mov	[si+13h],cl
		mov	byte ptr [si+14h],0
		mov	ah,[bx]
		mov	[si+10h],ah
		call	sub_2CBE
		call	sub_0B2C
		mov	ah,[si+11h]
		and	ah,30h			; '0'
		jnz	loc_186F		; Jump if not zero
		retn
loc_186F:
		mov	ah,[si+3]
		mov	[si+0Bh],ah
		mov	ah,[si+4]
		mov	[si+0Ch],ah
		mov	byte ptr [si+2],0
		retn
			                        ;* No entry point to code
		test	byte ptr [si+11h],1
		jz	loc_18C0		; Jump if zero
		mov	ah,[si+2]
		cmp	ah,19h
		jne	loc_189A		; Jump if not equal
		mov	ah,30h			; '0'
		mov	ds:data_F1DF_e,ah
		mov	bx,data_F12A_e+1
		or	byte ptr [bx],1
loc_189A:
		mov	cx,504h
		test	byte ptr [si+13h],80h
		jz	loc_18A6		; Jump if zero
		mov	cx,0B0Ah
loc_18A6:
		mov	dl,4
		call	sub_1065
		jc	loc_18AE		; Jump if carry Set
		retn
loc_18AE:
		dec	byte ptr [si+2]
		jz	loc_18B4		; Jump if zero
		retn
loc_18B4:
		call	sub_1506
		mov	bx,data_F12A_e+1
		and	byte ptr [bx],0FEh
		jmp	loc_1734
loc_18C0:
		mov	bl,12h
		mov	dl,17h
		call	sub_13C6
		jnc	loc_18D2		; Jump if carry=0
		or	byte ptr [si],10h
		mov	bx,0CED3h
		jmp	loc_3192
loc_18D2:
		mov	ah,ds:data_F1E0_e
		test	ah,40h			; '@'
		jz	loc_1906		; Jump if zero
		mov	bl,12h
		mov	dl,17h
		call	sub_1385
		jnc	loc_1906		; Jump if carry=0
		test	byte ptr ds:data_F107_e,8
		jnz	loc_18FD		; Jump if not zero
		or	byte ptr [si+11h],1
		mov	byte ptr [si+2],19h
		mov	ah,ds:data_F1E2_e
		xor	ah,[si+13h]
		jge	loc_18FD		; Jump if > or =
		retn
loc_18FD:
		mov	ah,[si+13h]
		neg	ah
		mov	[si+13h],ah
		retn
loc_1906:
		test	byte ptr [si],40h	; '@'
		jnz	loc_192D		; Jump if not zero
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1941		; Jump if not zero
		call	sub_1111
		cmp	ah,1Eh
		jb	loc_192D		; Jump if below
		mov	byte ptr [si+13h],40h	; '@'
		test	ah,1
		jz	loc_1927		; Jump if zero
		mov	byte ptr [si+13h],0C0h
loc_1927:
		mov	byte ptr [si+2],19h
		jmp	short loc_1941
loc_192D:
		mov	byte ptr [si+13h],40h	; '@'
		call	sub_1355
		jnc	loc_193A		; Jump if carry=0
		mov	byte ptr [si+13h],0C0h
loc_193A:
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
		mov	[si+2],ah
loc_1941:
		mov	bl,[si+22h]
		mov	bh,[si+23h]
		test	byte ptr [si+13h],80h
		jz	loc_194F		; Jump if zero
		inc	bx
		inc	bx
loc_194F:
		mov	cl,[bx]
		inc	bx
		mov	ch,[bx]
		mov	dl,2
		call	sub_1065
		jc	loc_195C		; Jump if carry Set
		retn
loc_195C:
		dec	byte ptr [si+2]
		call	sub_2CBE
		call	sub_0A19
		call	sub_3001
		test	byte ptr [si+11h],40h	; '@'
		jz	loc_1988		; Jump if zero
		mov	ah,[si+11h]
		or	ah,[si+24h]
		test	byte ptr [si+13h],80h
		jz	loc_1982		; Jump if zero
		test	ah,10h
		jnz	loc_1980		; Jump if not zero
		retn
loc_1980:
		jmp	short loc_1988
loc_1982:
		test	ah,20h			; ' '
		jnz	loc_1988		; Jump if not zero
		retn
loc_1988:
		mov	ah,[si+13h]
		neg	ah
		mov	[si+13h],ah
		jmp	loc_120D
			                        ;* No entry point to code
		pusha				; Save all regs
		inc	ax
		pusha				; Save all regs
		pusha				; Save all regs
		pusha				; Save all regs
;*		js	loc_19FA		;*Jump if sign=1
		db	 78h, 60h		;  Fixup - byte match
		shl	byte ptr [bx+si-60h],60h	; '`' Shift w/zeros fill
		mov	ss:data_B901[bp+di],dh
		add	[bp+si],al
		mov	ah,[si+0Ch]
		cmp	ah,14h
		jb	loc_19B1		; Jump if below
		mov	bl,0FFh
		mov	cx,503h
loc_19B1:
		mov	[si+13h],bl
		mov	dl,0Ah
		call	sub_1065
		jc	loc_19BC		; Jump if carry Set
		retn
loc_19BC:
		call	sub_1111
		cmp	ah,96h
		jae	loc_19C5		; Jump if above or =
		retn
loc_19C5:
		mov	bl,[si+10h]
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,1993h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
		mov	ds:data_F1A0_e,cx
		mov	ah,ds:data_F139_e
		cmp	ah,3
		jb	loc_19E4		; Jump if below
		retn
loc_19E4:
		call	sub_2C79
		push	bx
		push	dx
		call	sub_12A7
		pop	dx
		pop	bx
		jnc	loc_19F1		; Jump if carry=0
		retn
loc_19F1:
		mov	ah,ds:data_F139_e
		inc	ah
		mov	ds:data_F139_e,ah
		inc	bh
		inc	dh
		mov	cl,0
		mov	ch,24h			; '$'
		mov	ah,ds:data_F1A0_e
		call	sub_1274
		mov	ah,byte ptr ds:data_F1A0_e+1
		mov	[si+14h],ah
		retn
			                        ;* No entry point to code
		mov	bl,4
		mov	dl,4
		call	sub_1385
		jnc	loc_1A1E		; Jump if carry=0
		jmp	loc_1506
loc_1A1E:
		call	sub_0A19
		mov	ah,[si+24h]
		and	ah,70h			; 'p'
		jz	loc_1A37		; Jump if zero
		or	byte ptr [si],10h
		mov	ah,ds:data_F139_e
		dec	ah
		mov	ds:data_F139_e,ah
		retn
loc_1A37:
		mov	cx,100h
		mov	dl,0
		call	sub_1065
		jc	loc_1A42		; Jump if carry Set
		retn
loc_1A42:
		jmp	loc_2CBE
			                        ;* No entry point to code
		test	byte ptr [si+11h],1
		jz	loc_1A4E		; Jump if zero
		jmpn	loc_1AC6
loc_1A4E:
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1A73		; Jump if not zero
		call	sub_1355
		call	sub_2DBF
		mov	[si+2],ah
		mov	ah,40h			; '@'
		jnc	loc_1A64		; Jump if carry=0
		neg	ah
loc_1A64:
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		xor	ah,[si+13h]
		mov	[si+13h],dl
		jns	loc_1A73		; Jump if not sign
		or	byte ptr [si+11h],1
		retn
loc_1A73:
		mov	ah,21h			; '!'
		call	sub_1459
		jnc	loc_1A8E		; Jump if carry=0
		mov	ah,22h			; '"'
		call	sub_1459
		jnc	loc_1A8E		; Jump if carry=0
		call	sub_1111
		cmp	ah,0F5h
		push	si
		jc	loc_1A8D		; Jump if carry Set
		call	sub_1B15
loc_1A8D:
		pop	si
loc_1A8E:
		mov	cx,100h
		test	byte ptr [si+13h],80h
		jz	loc_1A9A		; Jump if zero
		mov	cx,403h
loc_1A9A:
		mov	dl,0
		call	sub_1065
		jc	loc_1AA2		; Jump if carry Set
		retn
loc_1AA2:
		dec	byte ptr [si+2]
		call	sub_1AE7
		call	sub_0A19
		mov	ah,20h			; ' '
		test	byte ptr [si+13h],80h
		jz	loc_1AB5		; Jump if zero
		mov	ah,10h
loc_1AB5:
		and	ah,[si+24h]
		jnz	loc_1ABB		; Jump if not zero
		retn
loc_1ABB:
		or	byte ptr [si],10h
		mov	bx,0CF8Eh
		mov	ah,2
		jmp	loc_3192
loc_1AC6:
		mov	ah,[si+13h]
		mov	byte ptr [si+13h],0
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		call	sub_1AE7
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		mov	[si+13h],ah
		mov	cx,202h
		mov	dl,0Ah
		call	sub_1065
		jc	loc_1AE2		; Jump if carry Set
		retn
loc_1AE2:
		and	byte ptr [si+11h],0FEh
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1AE7	proc	near
		mov	ah,[si+14h]
		add	ah,8
		mov	[si+14h],ah
		call	sub_2CBE
		test	byte ptr [si+14h],80h
		jnz	loc_1B07		; Jump if not zero
		mov	ah,[si+0Eh]
		cmp	ah,8
		jae	loc_1B02		; Jump if above or =
		retn
loc_1B02:
		mov	byte ptr [si+14h],80h
		retn
loc_1B07:
		mov	ah,[si+0Eh]
		cmp	ah,0
		je	loc_1B10		; Jump if equal
		retn
loc_1B10:
		mov	byte ptr [si+14h],0
		retn
sub_1AE7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1B15	proc	near
		call	sub_2C79
		push	dx
		push	bx
		call	sub_12A7
		pop	bx
		pop	dx
		jnc	loc_1B22		; Jump if carry=0
		retn
loc_1B22:
		inc	bh
		inc	bh
		inc	dh
		inc	dh
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,22h			; '"'
		call	sub_1274
		mov	byte ptr [si+14h],40h	; '@'
		mov	bx,0CF6Dh
		mov	ah,1
		jmp	loc_3192
sub_1B15	endp

			                        ;* No entry point to code
		call	sub_0A19
		call	sub_3001
		mov	bl,6
		mov	dl,6
		call	sub_1385
		jnc	loc_1B53		; Jump if carry=0
		call	sub_1506
		jmp	short loc_1B5F
loc_1B53:
		test	byte ptr [si+11h],1
		jnz	loc_1B98		; Jump if not zero
		test	byte ptr [si+11h],40h	; '@'
		jz	loc_1B6C		; Jump if zero
loc_1B5F:
		mov	word ptr [si+0Fh],21h
		mov	ah,1
		mov	bx,0CE75h
		jmp	loc_3192
loc_1B6C:
		call	sub_2CE2
		mov	ah,byte ptr ds:data_F1DC_e+1
		inc	ah
		cmp	ah,[si+0Eh]
		jb	loc_1B7B		; Jump if below
		retn
loc_1B7B:
		or	byte ptr [si+11h],1
		mov	byte ptr [si+13h],20h	; ' '
		call	sub_1355
		jnc	loc_1B8C		; Jump if carry=0
		mov	byte ptr [si+13h],0E0h
loc_1B8C:
		mov	byte ptr [si+14h],0
		mov	ah,1
		mov	bx,0CF32h
		jmp	loc_3192
loc_1B98:
		mov	cx,201h
		test	byte ptr [si+13h],80h
		jz	loc_1BA4		; Jump if zero
		mov	cx,403h
loc_1BA4:
		mov	dl,0
		call	sub_1065
		jc	loc_1BAC		; Jump if carry Set
		retn
loc_1BAC:
		call	sub_2CD6
		mov	ah,1
		test	byte ptr [si+13h],80h
		jz	loc_1BB9		; Jump if zero
		mov	ah,0FFh
loc_1BB9:
		add	ah,[si+13h]
		mov	[si+13h],ah
		mov	ah,[si+11h]
		and	ah,30h			; '0'
		jnz	loc_1B5F		; Jump if not zero
		mov	ah,[si+24h]
		and	ah,30h			; '0'
		jnz	loc_1BD0		; Jump if not zero
		retn
loc_1BD0:
		or	byte ptr [si],10h
		mov	bx,0CF8Eh
		mov	ah,1
		jmp	loc_3192
			                        ;* No entry point to code
		mov	bl,0Ch
		mov	dl,8
		call	sub_1385
		jnc	loc_1BE7		; Jump if carry=0
		jmp	loc_1506
loc_1BE7:
		mov	cx,400h
		mov	dl,5
		call	sub_1065
		jc	loc_1BF2		; Jump if carry Set
		retn
loc_1BF2:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1BF7		; Jump if not zero
		retn
loc_1BF7:
		or	byte ptr [si],10h
		retn
			                        ;* No entry point to code
		mov	ah,ds:data_F115_e
		test	ah,2
		jz	loc_1C18		; Jump if zero
		mov	ah,ds:data_F116_e
		test	ah,2
		jnz	loc_1C18		; Jump if not zero
		mov	ah,ds:data_F47E_e
		xor	ah,40h			; '@'
		mov	ds:data_F47E_e,ah
loc_1C18:
		mov	ah,ds:data_F131_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1C6D		; Jump if not zero
		mov	si,offset data_E05A
		mov	dx,4
		mov	di,ds:data_F1CD_e
		mov	ah,[di+4]
loc_1C2D:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		cmp	ah,[si]
		jne	loc_1C2D		; Jump if not equal
		inc	si
		mov	ds:data_F3D2_e,si
		mov	bx,data_F47E_e
		mov	dl,[si+2]
		mov	ah,byte ptr ds:data_F1DC_e+1
		mov	dh,[si]
		and	byte ptr [bx],7Fh
		cmp	ah,0Ah
		jb	loc_1C52		; Jump if below
		or	byte ptr [bx],80h
		mov	dh,[si+1]
loc_1C52:
		mov	ah,14h
;*		cmp	ah,dh
		db	 38h,0F4h		;  Fixup - byte match
		jnz	loc_1C5C		; Jump if not zero
		dec	dh
		jmp	short loc_1C66
loc_1C5C:
		mov	ah,1
;*		cmp	ah,dh
		db	 38h,0F4h		;  Fixup - byte match
		jnz	loc_1C66		; Jump if not zero
		inc	dh
		inc	dh
loc_1C66:
		mov	ds:data_F131_e,dx
		jmp	loc_1D23
loc_1C6D:
		mov	bx,data_F126_e
		or	byte ptr [bx],40h	; '@'
		mov	ah,ds:data_F133_e
		cmp	ah,32h			; '2'
		je	loc_1C7F		; Jump if equal
		and	byte ptr [bx],0BFh
loc_1C7F:
		mov	ah,ds:data_F138_e
		inc	ah
		mov	ds:data_F138_e,ah
		cmp	ah,5
		je	loc_1C8F		; Jump if equal
		retn
loc_1C8F:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F138_e,ah
		mov	si,ds:data_F3D2_e
		mov	bx,data_F47E_e
		test	byte ptr [bx],40h	; '@'
		jnz	loc_1CA2		; Jump if not zero
		retn
loc_1CA2:
		mov	ah,byte ptr ds:data_F131_e+1
		test	byte ptr [bx],80h
		jz	loc_1CB4		; Jump if zero
		cmp	ah,[si]
		jne	loc_1CBC		; Jump if not equal
		and	byte ptr [bx],7Fh
		jmp	short loc_1CEB
loc_1CB4:
		cmp	ah,[si+1]
		jne	loc_1CEB		; Jump if not equal
		or	byte ptr [bx],80h
loc_1CBC:
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jz	loc_1CCD		; Jump if zero
		call	sub_1D44
		jnc	loc_1CCB		; Jump if carry=0
		retn
loc_1CCB:
		jmp	short loc_1CD3
loc_1CCD:
		call	sub_1D7B
		jnc	loc_1CD3		; Jump if carry=0
		retn
loc_1CD3:
		call	sub_1D1A
		mov	bx,data_F131_e+1
		dec	byte ptr [bx]
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jz	loc_1D23		; Jump if zero
		mov	bx,data_F1DC_e+1
		dec	byte ptr [bx]
		jmp	short loc_1D23
loc_1CEB:
		call	sub_1DC3
		jnz	loc_1CF1		; Jump if not zero
		retn
loc_1CF1:
		call	sub_1D85
		jnc	loc_1CFD		; Jump if carry=0
		mov	bx,data_F47E_e
		or	byte ptr [bx],80h
		retn
loc_1CFD:
		call	sub_1D1A
		mov	bx,data_F131_e+1
		inc	byte ptr [bx]
		call	sub_1D4A
		jc	loc_1D23		; Jump if carry Set
		mov	ah,ds:data_F126_e
		test	ah,40h			; '@'
		jz	loc_1D23		; Jump if zero
		mov	bx,data_F1DC_e+1
		inc	byte ptr [bx]
		jmp	short loc_1D23

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D1A	proc	near
		mov	cx,ds:data_F131_e
		mov	di,0D355h
		jmp	short loc_1D2A
loc_1D23:
		mov	cx,ds:data_F131_e
		mov	di,offset data_D35B
loc_1D2A:
		mov	ah,14h
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnz	loc_1D31		; Jump if not zero
		retn
loc_1D31:
		mov	ah,[di]
		cmp	ah,0FFh
		jne	loc_1D39		; Jump if not equal
		retn
loc_1D39:
		call	sub_2C57
		call	sub_3895
		inc	di
		inc	cl
		jmp	short loc_1D31
sub_1D1A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D44	proc	near
		mov	bh,0FFh
		mov	bl,0
		jmp	short loc_1D4D

;==== External Entry into Subroutine ======================================

sub_1D4A:
		mov	bx,2A0h
loc_1D4D:
		mov	cx,ds:data_F1DC_e
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
;*		mov	ch,bh
		db	 88h,0FDh		;  Fixup - byte match
		mov	ah,byte ptr ds:data_F1DA_e+1
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		call	sub_10D5
		mov	cx,data_D465
loc_1D62:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1D73		; Jump if zero
		cmp	ah,32h			; '2'
		je	loc_1D73		; Jump if equal
		cmp	ah,4Eh			; 'N'
		jae	loc_1D73		; Jump if above or =
		retn
loc_1D73:
		inc	bx
		dec	ch
		jnz	loc_1D62		; Jump if not zero
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_1D44	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D7B	proc	near
		call	sub_1DA7
		jc	loc_1D81		; Jump if carry Set
		retn
loc_1D81:
		mov	cl,0FFh
		jmp	short loc_1D8D

;==== External Entry into Subroutine ======================================

sub_1D85:
		call	sub_1DA7
		jc	loc_1D8B		; Jump if carry Set
		retn
loc_1D8B:
		mov	cl,1
loc_1D8D:
		mov	ah,byte ptr ds:data_F131_e+1
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		inc	ah
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
sub_1D7B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D99	proc	near
		mov	ah,byte ptr ds:data_F1DC_e+1
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
		add	ah,2
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		jmp	loc_3CAA
sub_1D99	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1DA7	proc	near
		mov	ah,ds:data_F131_e
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		add	ah,5
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match

;==== External Entry into Subroutine ======================================

sub_1DB2:
		mov	ah,byte ptr ds:data_F1DA_e+1
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
		mov	cx,data_D465
;*		add	ah,ch
		db	 00h,0ECh		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		jmp	loc_3CAA
sub_1DA7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1DC3	proc	near
		mov	cx,ds:data_F131_e
		inc	ch
		call	sub_10D5
		mov	ch,5
loc_1DCE:
		mov	ah,[bx]
		cmp	ah,66h			; 'f'
		jne	loc_1DD6		; Jump if not equal
		retn
loc_1DD6:
		inc	bx
		dec	ch
		jnz	loc_1DCE		; Jump if not zero
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_1DC3	endp

			                        ;* No entry point to code
		test	byte ptr [si+24h],1
		jz	loc_1DE9		; Jump if zero
		jmpn	loc_1E5E
loc_1DE9:
		test	byte ptr [si+24h],4
		jnz	loc_1DF9		; Jump if not zero
		or	byte ptr [si+24h],4
		mov	ah,[si+0Eh]
		mov	[si+23h],ah
loc_1DF9:
		test	byte ptr [si+24h],2
		jnz	loc_1E13		; Jump if not zero
		call	sub_1111
		and	ah,1Fh
		or	ah,8
		mov	[si+2],ah
		mov	byte ptr [si+14h],0A0h
		or	byte ptr [si+24h],2
loc_1E13:
		mov	bl,5
		mov	dl,0Ah
		call	sub_1385
		jnc	loc_1E20		; Jump if carry=0
		pop	bx
		jmp	loc_1506
loc_1E20:
		call	sub_0A19
		call	sub_3001
		mov	ah,[si+24h]
		or	ah,[si+11h]
		test	ah,80h
		jnz	loc_1E38		; Jump if not zero
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1E4D		; Jump if not zero
loc_1E38:
		mov	byte ptr [si+14h],60h	; '`'
		mov	ah,[si+0Eh]
		mov	dl,[si+23h]
		dec	dl
;*		cmp	ah,dl
		db	 38h,0D4h		;  Fixup - byte match
		jnz	loc_1E50		; Jump if not zero
		or	byte ptr [si+24h],1
		retn
loc_1E4D:
		dec	byte ptr [si+2]
loc_1E50:
		mov	cx,100h
		mov	dl,3
		call	sub_1065
		jc	loc_ret_1E5D		; Jump if carry Set
		jmp	loc_2CE2

loc_ret_1E5D:
		retn
loc_1E5E:
		mov	cx,702h
		mov	dl,5
		call	sub_1065
		jc	loc_1E69		; Jump if carry Set
		retn
loc_1E69:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1E6E		; Jump if not zero
		retn
loc_1E6E:
		mov	byte ptr [si+10h],0
		and	byte ptr [si+24h],0FEh
		and	byte ptr [si+24h],0FDh
		mov	ah,[si+23h]
		mov	[si+0Eh],ah
		mov	byte ptr [si+0Dh],0
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1E85	proc	near
		call	sub_1F5E
		mov	cx,0
		call	sub_114F
		call	sub_1F49
		mov	ch,28h			; '('
loc_1E93:
		push	cx
		call	sub_1F34
		call	sub_1EE1
		call	sub_38AD
		pop	cx
		dec	ch
		jnz	loc_1E93		; Jump if not zero
		retn
sub_1E85	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1EA3	proc	near
		mov	bx,0EDE3h
		mov	dx,0F4F3h
		mov	cx,320h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	bx,0
		mov	ds:data_F1A0_e,bx
		mov	ch,28h			; '('
loc_1EC0:
		push	cx
		call	sub_1F34
		mov	cx,ds:data_F1A0_e
		inc	cx
		mov	ds:data_F1A0_e,cx
		call	sub_1F08
		call	sub_38AD
		pop	cx
		dec	ch
		jnz	loc_1EC0		; Jump if not zero
		mov	cx,0
		call	sub_114F
		jmp	loc_1F8F

;==== External Entry into Subroutine ======================================

sub_1EE1:
		mov	ah,9
		mov	bx,offset data_EF99
		mov	dx,0EF9Ah
loc_1EE9:
		mov	cx,27h
		xchg	si,bx
		xchg	di,dx
		std				; Set direction flag
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		inc	bx
		mov	[bx],ch
		mov	cl,4Eh			; 'N'
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
		inc	dx
		dec	ah
		jnz	loc_1EE9		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_1F08:
		mov	ah,9
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	bx,0F83Bh
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		mov	dx,0EF73h
loc_1F14:
		push	cx
		push	bx
		push	dx
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	cl,28h			; '('
		pop	bx
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
		pop	bx
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		pop	cx
		dec	ah
		jnz	loc_1F14		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_1F34:
		mov	bx,0EF73h
		mov	dx,0F683h
		mov	cx,168h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn

;==== External Entry into Subroutine ======================================

sub_1F49:
		mov	bx,0EF73h
		mov	dx,0F813h
		mov	cx,168h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn

;==== External Entry into Subroutine ======================================

sub_1F5E:
		mov	cx,0E07h
		call	sub_1F67
		mov	cx,0E1Ch

;==== External Entry into Subroutine ======================================

sub_1F67:
		mov	di,offset data_E153
		mov	ah,4
loc_1F6C:
		push	ax
		mov	ah,4
loc_1F6F:
		push	ax
		mov	ah,[di]
		call	sub_2C57
		call	sub_3895
		inc	di
		inc	cl
		pop	ax
		dec	ah
		jnz	loc_1F6F		; Jump if not zero
		inc	ch
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
		sub	ah,4
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		pop	ax
		dec	ah
		jnz	loc_1F6C		; Jump if not zero
		retn
loc_1F8F:
		mov	cx,0E07h
		call	sub_1F98
		mov	cx,0E1Ch
sub_1EA3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1F98	proc	near
		mov	ah,4
loc_1F9A:
		push	ax
		mov	ah,4
loc_1F9D:
		push	ax
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		call	sub_2C57
		call	sub_3895
		inc	cl
		pop	ax
		dec	ah
		jnz	loc_1F9D		; Jump if not zero
		inc	ch
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
		sub	ah,4
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		pop	ax
		dec	ah
		jnz	loc_1F9A		; Jump if not zero
		retn
sub_1F98	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1FBC	proc	near
		mov	bx,data_F17B_e
		mov	ah,[bx]
		mov	ds:data_F120_e,ah
		inc	bx
		mov	ds:data_F1C1_e,bx
loc_1FCA:
		mov	si,ds:data_F1C1_e
		mov	dl,[si]
		mov	dh,[si+1]
		mov	si,data_0000_e
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		test	byte ptr [si],80h
		jz	loc_1FFA		; Jump if zero
		test	byte ptr [si],10h
		jnz	loc_1FFA		; Jump if not zero
		mov	ah,[si+0Fh]
		shl	ah,1			; Shift w/zeros fill
		push	di
		mov	di,offset data_D407
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	bl,[di]
		mov	bh,[di+1]
		pop	di
		call	sub_2011
loc_1FFA:
		mov	bx,ds:data_F1C1_e
		inc	bx
		inc	bx
		mov	ds:data_F1C1_e,bx
		mov	ah,ds:data_F120_e
		dec	ah
		mov	ds:data_F120_e,ah
		jnz	loc_1FCA		; Jump if not zero
		retn
sub_1FBC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2011	proc	near
		jmp	bx			;*
			                        ;* No entry point to code
		test	byte ptr [si+2],80h
		jnz	loc_2069		; Jump if not zero
		mov	ah,[si+12h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2034		; Jump if zero
		mov	bl,[si+0Dh]
		mov	bh,[si+0Eh]
		mov	[si+22h],bl
		mov	[si+23h],bh
		mov	byte ptr [si+12h],0
		mov	byte ptr [si+14h],4
loc_2034:
		mov	bl,3
		mov	dl,0Ch
		call	sub_1385
		jnc	loc_2041		; Jump if carry=0
		pop	bx
		jmp	loc_1506
loc_2041:
		call	sub_0A19
		mov	ah,[si+24h]
		or	ah,[si+11h]
		test	ah,40h			; '@'
		jz	loc_2054		; Jump if zero
		or	byte ptr [si+2],80h
		retn
loc_2054:
		mov	ah,[si+14h]
		add	ah,3
		cmp	ah,7Ch			; '|'
		jae	loc_2062		; Jump if above or =
		mov	[si+14h],ah
loc_2062:
		mov	byte ptr [si+13h],0
		jmp	loc_2CE2
loc_2069:
		mov	cx,801h
		mov	dl,3
		call	sub_1065
		jc	loc_2074		; Jump if carry Set
		retn
loc_2074:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2079		; Jump if not zero
		retn
loc_2079:
		mov	byte ptr [si+10h],0
		mov	byte ptr [si+2],0
		mov	bl,[si+22h]
		mov	bh,[si+23h]
		mov	[si+0Dh],bl
		mov	[si+0Eh],bh
		mov	byte ptr [si+14h],4
		or	byte ptr [si],40h	; '@'
		jmp	loc_11F3
sub_2011	endp

			                        ;* No entry point to code
		test	byte ptr [si+14h],80h
		jnz	loc_20A1		; Jump if not zero
		mov	ah,7Fh
		jmp	short loc_20A7
loc_20A1:
		mov	ah,[si+14h]
		add	ah,1
loc_20A7:
		mov	[si+14h],ah
		call	sub_2CD6
		call	sub_0A19
		mov	ah,[si+24h]
		and	ah,0F0h
		jnz	loc_20B9		; Jump if not zero
		retn
loc_20B9:
		or	byte ptr [si],10h
		jmp	loc_120D
			                        ;* No entry point to code
		mov	cx,200h
		mov	dl,4
		call	sub_1065
		jc	loc_20CA		; Jump if carry Set
		retn
loc_20CA:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_20CF		; Jump if not zero
		retn
loc_20CF:
		or	byte ptr [si],10h
		retn
			                        ;* No entry point to code
		mov	bl,3
		mov	dl,0Ch
		call	sub_1385
		jnc	loc_20E0		; Jump if carry=0
		pop	bx
		jmp	loc_1506
loc_20E0:
		mov	ch,2
		mov	cl,0
		mov	dl,1
		call	sub_1065
		jc	loc_20EC		; Jump if carry Set
		retn
loc_20EC:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_20F1		; Jump if not zero
		retn
loc_20F1:
		or	byte ptr [si],10h
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_20F5	proc	near
		mov	bx,offset data_DF4D
		and	byte ptr [bx],0FDh
		and	byte ptr [bx],0FBh
		mov	ah,ds:data_F11D_e
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,ds:data_F122_e
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jz	loc_210D		; Jump if zero
		retn
loc_210D:
		mov	ch,69h			; 'i'
		mov	ah,ds:data_F133_e
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jz	loc_2123		; Jump if zero
		mov	ch,66h			; 'f'
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jz	loc_2123		; Jump if zero
		call	sub_212A
		jc	loc_2123		; Jump if carry Set
		retn
loc_2123:
		mov	bx,offset data_DF4D
		or	byte ptr [bx],2
		retn
sub_20F5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_212A	proc	near
		mov	ah,byte ptr data_DF52+1
		add	ah,0F5h
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,byte ptr ds:data_F1DC_e+1
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		cmc				; Complement carry
		jc	loc_213D		; Jump if carry Set
		retn
loc_213D:
		mov	ah,byte ptr data_DF50+1
		dec	ah
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,byte ptr ds:data_F1DA_e+1
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_2156		; Jump if carry=0
		add	ah,3
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jz	loc_ret_2155		; Jump if zero
		cmc				; Complement carry

loc_ret_2155:
		retn
loc_2156:
		inc	ch
		inc	ch
		inc	ch
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		retn
sub_212A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_215F	proc	near
		mov	di,2192h
		push	di
		mov	ah,ds:data_F107_e
		test	ah,8
		jnz	loc_2190		; Jump if not zero
		mov	ch,0
		mov	ah,ds:data_F133_e
		cmp	ah,3Ah			; ':'
		jne	loc_2178		; Jump if not equal
		retn
loc_2178:
		inc	ch
		cmp	ah,0Bh
		jne	loc_2180		; Jump if not equal
		retn
loc_2180:
		inc	ch
		cmp	ah,0Ch
		jne	loc_2188		; Jump if not equal
		retn
loc_2188:
		inc	ch
		cmp	ah,14h
		jne	loc_2190		; Jump if not equal
		retn
loc_2190:
		stc				; Set carry flag
		retn
sub_215F	endp

		db	 73h, 01h,0C3h
loc_2195:
		push	bx
		mov	bx,data_F1E0_e
		or	byte ptr [bx],1
		pop	bx
		retn
			                        ;* No entry point to code
		mov	ah,ds:data_F137_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_21A9		; Jump if not zero
		call	sub_2221
loc_21A9:
		mov	ah,ds:data_F138_e
		inc	ah
		mov	ds:data_F138_e,ah
		cmp	ah,3
		je	loc_21B9		; Jump if equal
		retn
loc_21B9:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F138_e,ah
loc_21BF:
		mov	cl,12h
		mov	ah,ds:data_F137_e
		test	ah,80h
		jz	loc_21CC		; Jump if zero
		mov	cl,0FFh
loc_21CC:
		and	ah,7Fh
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0Ch
		mov	ds:data_F1A0_e,cx
		call	sub_10D5
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_21EF		; Jump if zero
		mov	ah,ds:data_F137_e
		xor	ah,80h
		mov	ds:data_F137_e,ah
		jmp	short loc_21BF
loc_21EF:
		mov	ah,32h			; '2'
		mov	cx,ds:data_F1A0_e
		call	sub_2C57
		call	sub_3895
		mov	ah,1
		mov	bx,data_F137_e
		mov	cl,[bx]
		test	byte ptr [bx],80h
		jz	loc_2215		; Jump if zero
		mov	ah,[bx]
		and	ah,7Fh
		add	ah,11h
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		dec	byte ptr [bx]
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
loc_2215:
		add	ah,[bx]
		mov	[bx],ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		call	sub_2C57
		jmp	loc_3895

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2221	proc	near
		mov	ah,0Bh
		mov	ds:data_F137_e,ah
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0Ch
		mov	ah,12h
loc_222D:
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		mov	ah,32h			; '2'
		call	sub_2C57
		call	sub_3895
		inc	cl
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		dec	ah
		jnz	loc_222D		; Jump if not zero
		retn
sub_2221	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2240	proc	near
		mov	ah,ds:data_F11D_e
		mov	bx,offset data_E057
loc_2247:
		cmp	ah,[bx]
		je	loc_2273		; Jump if equal
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		mov	ah,[bx]
		cmp	ah,0FFh
		je	loc_2259		; Jump if equal
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		inc	bx
		jmp	short loc_2247
loc_2259:
		mov	ah,ds:data_F11D_e
		mov	bx,offset data_E050
loc_2260:
		cmp	ah,[bx]
		je	loc_229B		; Jump if equal
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		mov	ah,[bx]
		cmp	ah,0FFh
		jne	loc_226E		; Jump if not equal
		retn
loc_226E:
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		inc	bx
		jmp	short loc_2260
loc_2273:
		mov	bx,ds:data_F1DA_e
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,14h
		jb	loc_227F		; Jump if below
		retn
loc_227F:
		mov	bx,ds:data_F1DC_e
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,2
		jae	loc_228B		; Jump if above or =
		retn
loc_228B:
		cmp	ah,0Ah
		jb	loc_2294		; Jump if below
		mov	bh,4
		jmp	short loc_2296
loc_2294:
		mov	bh,10h
loc_2296:
		mov	ds:data_F1DC_e,bx
		retn
loc_229B:
		mov	bx,ds:data_F1DA_e
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,14h
		jae	loc_22A7		; Jump if above or =
		retn
loc_22A7:
		mov	bx,ds:data_F1DC_e
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,2
		jae	loc_22B3		; Jump if above or =
		retn
loc_22B3:
		cmp	ah,0Ah
		jb	loc_22BE		; Jump if below
		mov	ah,4
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		jmp	short loc_22C2
loc_22BE:
		mov	ah,10h
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
loc_22C2:
		mov	ds:data_F1DC_e,bx
		retn
sub_2240	endp

			                        ;* No entry point to code
		mov	bl,7
		mov	dl,8
		call	sub_1385
		jc	loc_22D1		; Jump if carry Set
		retn
loc_22D1:
		or	byte ptr [si],10h
		mov	bx,0CEFAh
		call	sub_3192
		mov	bx,offset data_E02A
		call	sub_22FD
		mov	ah,ds:data_F12A_e
		inc	ah
		mov	ds:data_F12A_e,ah

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_22EA	proc	near
		mov	ah,ds:data_F12A_e
		mov	dx,64h
		call	sub_1139
		mov	cx,1505h
		mov	ah,5
		call	sub_3388
		retn
sub_22EA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_22FD	proc	near
		mov	dx,4
		mov	ah,[bx]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	bx
		mov	ah,ds:data_F11D_e
loc_2309:
		cmp	ah,[bx]
		je	loc_2314		; Jump if equal
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_2309		; Jump if not zero
		retn
loc_2314:
		inc	bx
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[bx],ah
		retn
sub_22FD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_231A	proc	near
		mov	ah,0Bh
		mov	bx,0E02Ah
		jmp	short loc_2326

;==== External Entry into Subroutine ======================================

sub_2321:
		mov	ah,15h
		mov	bx,0DFF9h
loc_2326:
		mov	ds:data_F3CD_e,ah
		push	bx
		call	sub_1459
		pop	bx
		jc	loc_2332		; Jump if carry Set
		retn
loc_2332:
		mov	ah,[bx]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	bx
		mov	ah,ds:data_F11D_e
		mov	dx,4
loc_233E:
		cmp	ah,[bx]
		je	loc_2349		; Jump if equal
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_233E		; Jump if not zero
		retn
loc_2349:
		inc	bx
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2351		; Jump if not zero
		retn
loc_2351:
		call	sub_12A7
		jnc	loc_2357		; Jump if carry=0
		retn
loc_2357:
		mov	ah,ds:data_F3CD_e
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	cl,0
		inc	bx
		mov	dh,[bx]
		mov	dl,0
		inc	bx
		mov	bh,[bx]
		cmp	ah,0Bh
		mov	bl,20h			; ' '
		jnz	loc_2370		; Jump if not zero
		mov	bl,80h
loc_2370:
		jmp	loc_1274
sub_231A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2373	proc	near
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		mov	ah,ds:data_F11B_e
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	ah,2
		mov	ch,17h
		mov	cl,13h
		jmp	loc_3388
sub_2373	endp

			                        ;* No entry point to code
		mov	bl,4
		mov	dl,4
		call	sub_1385
		jc	loc_2390		; Jump if carry Set
		retn
loc_2390:
		or	byte ptr [si],10h
		mov	bx,0CEFAh
		call	sub_3192
		mov	bx,offset data_DFF9
		call	sub_22FD
		mov	ah,16h
		mov	ds:data_F125_e,ah
		jmp	loc_361D

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_23A8	proc	near
		mov	bx,data_F11A_e
		test	byte ptr [bx],40h	; '@'
		jnz	loc_23B1		; Jump if not zero
		retn
loc_23B1:
		and	byte ptr [bx],0BFh
		dec	byte ptr ds:data_F124_e
		jz	loc_23BB		; Jump if zero
		retn
loc_23BB:
		mov	ah,8
		mov	ds:data_F124_e,ah
		mov	bx,data_F125_e
		cmp	byte ptr [bx],0
		je	loc_23D0		; Jump if equal
		dec	byte ptr [bx]
		jz	loc_23D0		; Jump if zero
		jmp	loc_361D
loc_23D0:
		mov	ah,16h
		mov	[bx],ah
		call	sub_361D
		jmp	loc_1506
sub_23A8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_23DA	proc	near
		mov	di,offset data_D3DC
		mov	dx,3
loc_23E0:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		test	byte ptr [di],80h
		jz	loc_23E8		; Jump if zero
		retn
loc_23E8:
		and	byte ptr [di+1],7Fh
		and	byte ptr [di+1],0BFh
		jmp	short loc_23E0
sub_23DA	endp

			                        ;* No entry point to code
		call	sub_244E
		test	byte ptr [di+1],80h
		jz	loc_23FC		; Jump if zero
		retn
loc_23FC:
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
		mov	ds:data_F12F_e,ah
		mov	ah,byte ptr ds:data_F12F_e+1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_240D		; Jump if not zero
		call	sub_2469
loc_240D:
		mov	bh,[di+2]
;*		mov	bl,bh
		db	 88h,0FBh		;  Fixup - byte match
		call	sub_1D99
		jc	loc_2418		; Jump if carry Set
		retn
loc_2418:
		mov	bh,[di+1]
;*		mov	bl,bh
		db	 88h,0FBh		;  Fixup - byte match
		inc	bl
		call	sub_1DB2
		jc	loc_2425		; Jump if carry Set
		retn
loc_2425:
		mov	cl,[di+1]
		or	byte ptr [di+1],80h
		mov	ch,[di+2]
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		call	sub_2C57
		call	sub_3895
		mov	cx,ds:data_F12F_e
		mov	ch,0
		call	sub_33C3
		mov	bx,data_F11B_e
		inc	byte ptr [bx]
		call	sub_2373
		mov	bx,0CEFAh
		jmp	loc_3192

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_244E	proc	near
		mov	ah,ds:data_F11D_e
		mov	cl,0FFh
		mov	di,offset data_D3DC
		mov	dx,3
loc_245A:
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		test	byte ptr [di],80h
		jz	loc_2462		; Jump if zero
		retn
loc_2462:
		inc	cl
		cmp	ah,[di]
		jne	loc_245A		; Jump if not equal
		retn
sub_244E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2469	proc	near
		mov	cl,[di+1]
		mov	ch,[di+2]
		mov	ah,5Ah			; 'Z'
		mov	byte ptr ds:data_F12F_e+1,ah
		call	sub_2C57
		jmp	loc_3895
sub_2469	endp

loc_247B:
		mov	ah,ds:data_F3CF_e
		cmp	ah,0FFh
		jne	loc_2485		; Jump if not equal
		retn
loc_2485:
		call	sub_24B9
		jnz	loc_248B		; Jump if not zero
		retn
loc_248B:
		mov	ah,byte ptr ds:data_F105_e+1
		cmp	ah,0FFh
		jne	loc_24A3		; Jump if not equal
		mov	ah,ds:data_F12A_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_249D		; Jump if not zero
		retn
loc_249D:
		dec	ah
		mov	ds:data_F12A_e,ah
loc_24A3:
		call	sub_22EA
		mov	ah,ds:data_F3CF_e
		call	sub_268B
		call	sub_368E
		call	sub_24C9
		mov	bx,0CEFAh
		jmp	loc_3192

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_24B9	proc	near
		mov	dx,8
		call	sub_1139
		mov	dx,0F480h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,0FFh
		cmp	ah,[bx]
		retn
sub_24B9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_24C9	proc	near
		mov	bx,ds:data_F103_e
		call	sub_24E2
		mov	bx,word ptr ds:data_F103_e+1
		call	sub_24E2
		mov	bx,ds:data_F105_e
		call	sub_24E2
		mov	bx,word ptr ds:data_F105_e+1

;==== External Entry into Subroutine ======================================

sub_24E2:
;*		mov	ah,bl
		db	 88h,0DCh		;  Fixup - byte match
		test	ah,80h
		jz	loc_24EA		; Jump if zero
		retn
loc_24EA:
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	di,data_F480_e
		xchg	dx,bx
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	word ptr [di],0FFFFh
		mov	cl,[di+3]
		mov	ah,4
		call	sub_147C
		jnc	loc_2508		; Jump if carry=0
		retn
loc_2508:
		or	byte ptr [di],10h
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_24C9	endp

			                        ;* No entry point to code
		mov	ah,byte ptr ds:data_F1DC_e+1
		cmp	ah,8
		jae	loc_2518		; Jump if above or =
		retn
loc_2518:
		mov	ah,ds:data_F115_e
		test	ah,10h
		mov	bx,data_F12A_e+1
		jnz	loc_253A		; Jump if not zero
		test	byte ptr [bx],1
		jnz	loc_252A		; Jump if not zero
		retn
loc_252A:
		and	byte ptr [bx],0FEh
		mov	ah,ds:data_F11D_e
		cmp	ah,42h			; 'B'
		jne	loc_ret_2539		; Jump if not equal
		jmp	loc_247B

loc_ret_2539:
		retn
loc_253A:
		or	byte ptr [bx],1
		mov	bl,[si+0Bh]
		mov	bh,[si+0Ch]
		mov	dx,40h
		test	ah,4
		jnz	loc_2599		; Jump if not zero
		test	ah,8
		jnz	loc_25A4		; Jump if not zero
		mov	ah,ds:data_F11D_e
		cmp	ah,3Bh			; ';'
		jne	loc_255C		; Jump if not equal
		jmp	loc_2606
loc_255C:
		mov	bl,[si+0Dh]
		mov	bh,[si+0Eh]
		mov	ah,ds:data_F115_e
		mov	dx,20h
		test	ah,1
		jnz	loc_2574		; Jump if not zero
		test	ah,2
		jnz	loc_257F		; Jump if not zero
		retn
loc_2574:
		mov	ah,4
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jnz	loc_2588		; Jump if not zero
		retn
loc_257F:
		mov	ah,10h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jnz	loc_2588		; Jump if not zero
		retn
loc_2588:
		mov	[si+0Dh],bl
		mov	[si+0Eh],bh
loc_258E:
		mov	ah,ds:data_F11D_e
		cmp	ah,42h			; 'B'
		je	loc_25B5		; Jump if equal
		jmp	short loc_25EB
loc_2599:
		mov	ah,4
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jnz	loc_25AD		; Jump if not zero
		retn
loc_25A4:
		mov	ah,24h			; '$'
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jnz	loc_25AD		; Jump if not zero
		retn
loc_25AD:
		mov	[si+0Bh],bl
		mov	[si+0Ch],bh
		jmp	short loc_258E
loc_25B5:
		mov	ah,7
loc_25B7:
		mov	ds:data_F3CD_e,ah
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ah,4
		call	sub_147C
		jc	loc_25D0		; Jump if carry Set
		mov	bl,0Eh
		mov	dl,8
		mov	cx,1010h
		call	sub_13F4
		jc	loc_25DD		; Jump if carry Set
loc_25D0:
		mov	ah,ds:data_F3CD_e
		dec	ah
		cmp	ah,0FFh
		je	loc_25E6		; Jump if equal
		jmp	short loc_25B7
loc_25DD:
		mov	ah,ds:data_F3CD_e
		mov	ds:data_F3CF_e,ah
		retn
loc_25E6:
		mov	ds:data_F3CF_e,ah
		retn
loc_25EB:
		mov	bx,data_F3CB_e
		mov	ah,0FFh
		mov	[bx],ah
		mov	ah,[si+0Ch]
		cmp	ah,1Fh
		jb	loc_25FB		; Jump if below
		retn
loc_25FB:
		sub	ah,5
		jnc	loc_2601		; Jump if carry=0
		retn
loc_2601:
		shr	ah,1			; Shift w/zeros fill
		mov	[bx],ah
		retn
loc_2606:
		mov	bx,data_F3BD_e
		mov	ah,ds:data_F3CB_e
		cmp	ah,0FFh
		jne	loc_2613		; Jump if not equal
		retn
loc_2613:
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,ds:data_F115_e
		test	ah,2
		jnz	loc_262D		; Jump if not zero
		test	ah,1
		jnz	loc_263A		; Jump if not zero
		test	ah,20h			; ' '
		jnz	loc_2664		; Jump if not zero
		retn
loc_262D:
		mov	ah,[bx]
		dec	ah
		cmp	ah,0FFh
		jne	loc_2645		; Jump if not equal
		mov	ah,9
		jmp	short loc_2645
loc_263A:
		mov	ah,[bx]
		inc	ah
		cmp	ah,0Ah
		jne	loc_2645		; Jump if not equal
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
loc_2645:
		mov	[bx],ah
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
		mov	ch,5
		mov	ah,ds:data_F3CB_e
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
		add	ah,5
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ah,1
		call	sub_3388
		mov	cx,0FFFFh
		call	sub_114F
		retn
loc_2664:
		call	sub_266F
		jc	loc_266C		; Jump if carry Set
		jmp	loc_33FD
loc_266C:
		jmp	loc_2812

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_266F	proc	near
		mov	bx,data_F3BD_e
		mov	si,data_F107_e+1
		mov	ch,0Ch
		mov	ah,[bx]
		and	ah,0Fh
		cmp	ah,[si]
		stc				; Set carry flag
		jz	loc_2682		; Jump if zero
		retn
loc_2682:
		inc	bx
		inc	si
		dec	ch
		jnz	loc_2682		; Jump if not zero
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_266F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_268B	proc	near
		cmp	ah,0FFh
		je	loc_2697		; Jump if equal
		cmp	ah,8
		cmc				; Complement carry
		jnc	loc_2697		; Jump if carry=0
		retn
loc_2697:
		push	ax
		mov	ah,byte ptr ds:data_F105_e+1
		push	ax
		cmp	ah,0FFh
		je	loc_26A5		; Jump if equal
		call	sub_26C6
loc_26A5:
		mov	ah,ds:data_F105_e
		mov	byte ptr ds:data_F105_e+1,ah
		mov	ah,byte ptr ds:data_F103_e+1
		mov	ds:data_F105_e,ah
		mov	ah,ds:data_F103_e
		mov	byte ptr ds:data_F103_e+1,ah
		pop	dx
		pop	ax
		mov	ds:data_F103_e,ah
;*		mov	ah,dh
		db	 88h,0F4h		;  Fixup - byte match
		retn
sub_268B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_26C6	proc	near
		mov	dx,8
		call	sub_1139
		mov	dx,0F480h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,42h			; 'B'
		mov	[bx],ah
		inc	bx
		inc	bx
		push	bx
		call	sub_12B2
		jnc	loc_26DE		; Jump if carry=0
		retn
loc_26DE:
		pop	di
		jmp	loc_1229
sub_26C6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_26E2	proc	near
		mov	ah,ds:data_F115_e
		test	ah,20h			; ' '
		jnz	loc_26EC		; Jump if not zero
		retn
loc_26EC:
		test	ah,4
		jnz	loc_2725		; Jump if not zero
		test	ah,8
		jnz	loc_26F7		; Jump if not zero
		retn
loc_26F7:
		and	ah,0DFh
		and	ah,0F7h
		mov	ds:data_F115_e,ah
		mov	ah,byte ptr ds:data_F105_e+1
		push	ax
		mov	ah,ds:data_F105_e
		mov	byte ptr ds:data_F105_e+1,ah
		mov	ah,byte ptr ds:data_F103_e+1
		mov	ds:data_F105_e,ah
		mov	ah,ds:data_F103_e
		mov	byte ptr ds:data_F103_e+1,ah
		pop	ax
		mov	ds:data_F103_e,ah
		jmp	short loc_2751
loc_2725:
		and	ah,0DFh
		and	ah,0FBh
		mov	ds:data_F115_e,ah
		mov	ah,ds:data_F103_e
		push	ax
		mov	ah,byte ptr ds:data_F103_e+1
		mov	ds:data_F103_e,ah
		mov	ah,ds:data_F105_e
		mov	byte ptr ds:data_F103_e+1,ah
		mov	ah,byte ptr ds:data_F105_e+1
		mov	ds:data_F105_e,ah
		pop	ax
		mov	byte ptr ds:data_F105_e+1,ah
loc_2751:
		call	sub_368E
		mov	cx,0FFFFh
		jmp	loc_114F
sub_26E2	endp

			                        ;* No entry point to code
		mov	ah,ds:data_F12F_e
		test	ah,10h
		jnz	loc_2766		; Jump if not zero
		call	sub_2849
loc_2766:
		mov	ah,ds:data_F133_e
		cmp	ah,3Ch			; '<'
		mov	ah,byte ptr ds:data_F12A_e+1
		pushf				; Push flags
		and	ah,0F7h
		popf				; Pop flags
		jz	loc_2779		; Jump if zero
		retn
loc_2779:
		or	ah,8
		call	sub_26E2
		mov	ah,ds:data_F115_e
		test	ah,10h
		jnz	loc_2789		; Jump if not zero
		retn
loc_2789:
		mov	ah,byte ptr ds:data_F105_e+1
		cmp	ah,0FFh
		jne	loc_2793		; Jump if not equal
		retn
loc_2793:
		call	sub_28E6
		jc	loc_27E3		; Jump if carry Set
		call	sub_2879
		mov	ah,byte ptr ds:data_F105_e+1
		mov	dx,8
		call	sub_1139
		mov	dx,0F480h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,ds:data_F11D_e
		mov	[bx],ah
		inc	bx
		push	bx
		pop	si
		mov	bx,ds:data_F1DA_e
		mov	[si+4],bh
		mov	bx,ds:data_F1DC_e
		inc	bh
		mov	[si+6],bh
		push	si
		call	sub_12B2
		pop	di
		inc	di
		jc	loc_27CE		; Jump if carry Set
		call	sub_1229
loc_27CE:
		mov	ah,0FFh
		mov	byte ptr ds:data_F105_e+1,ah
		mov	bx,data_F115_e
		and	byte ptr [bx],0EFh
		call	sub_368E
		mov	bx,0CEFAh
		jmp	loc_3192
loc_27E3:
		mov	ah,byte ptr ds:data_F105_e+1
		mov	dx,8
		call	sub_1139
		push	bx
		mov	dx,0DF68h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		pop	si
		mov	dx,0F480h
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		push	si
		pop	dx
		mov	cx,8
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	ah,0FFh
		mov	byte ptr ds:data_F105_e+1,ah
		call	sub_368E
loc_2812:
		mov	bx,0CF59h
		call	sub_3192
		mov	cx,0
		call	sub_114F
		call	sub_114F
		mov	ah,ds:data_F11D_e
		cmp	ah,41h			; 'A'
		jne	loc_282D		; Jump if not equal
		jmp	loc_33EC
loc_282D:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F133_e,ah
		mov	ds:data_F127_e,ah
		mov	si,0F1CFh
		mov	byte ptr [si+0Eh],10h
		mov	byte ptr [si+0Dh],80h
		mov	dl,19h
		mov	ah,52h			; 'R'
		jmp	loc_0CDB

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2849	proc	near
		mov	ah,ds:data_F11D_e
		mov	bx,data_F4C1_e
		mov	dx,6
		mov	ch,8
loc_2855:
		cmp	ah,[bx]
		je	loc_2860		; Jump if equal
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_2855		; Jump if not zero
		retn
loc_2860:
		inc	bx
		mov	ah,1
		cmp	ah,[bx]
		je	loc_2882		; Jump if equal
		retn

;==== External Entry into Subroutine ======================================

sub_2868:
		mov	ah,byte ptr ds:data_F105_e+1
		mov	dx,6
		call	sub_1139
		mov	dx,0F4C1h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		inc	bx
		retn

;==== External Entry into Subroutine ======================================

sub_2879:
		call	sub_2868
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[bx],ah
		jmp	short loc_2882
loc_2882:
		push	bx
		pop	si
		mov	cl,[si+1]
		mov	ch,[si+2]
		push	ax
		push	si
		call	sub_10D5
		pop	si
		pop	ax
		mov	ch,[si+4]
loc_2894:
		push	bx
		push	cx
		mov	ch,[si+3]
loc_2899:
		mov	[bx],ah
		inc	bx
		dec	ch
		jnz	loc_2899		; Jump if not zero
		pop	cx
		pop	bx
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_2894		; Jump if not zero
		mov	dh,[si+2]
		mov	dl,[si+1]
		mov	ch,[si+4]
		mov	cl,[si+3]
		call	sub_28C6
		mov	ah,ds:data_F12F_e
		or	ah,10h
		mov	ds:data_F12F_e,ah
		retn
sub_2849	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_28C6	proc	near
loc_28C6:
		push	cx
		push	dx
;*		mov	ch,cl
		db	 88h,0CDh		;  Fixup - byte match
loc_28CA:
		push	cx
;*		mov	ch,dh
		db	 88h,0F5h		;  Fixup - byte match
;*		mov	cl,dl
		db	 88h,0D1h		;  Fixup - byte match
		push	dx
		push	ax
		call	sub_3895
		pop	ax
		pop	dx
		inc	dl
		pop	cx
		dec	ch
		jnz	loc_28CA		; Jump if not zero
		pop	dx
		inc	dh
		pop	cx
		dec	ch
		jnz	loc_28C6		; Jump if not zero
		retn
sub_28C6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_28E6	proc	near
		mov	dx,2
		call	sub_1139
		mov	dx,0DFA8h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,ds:data_F11D_e
		cmp	ah,[bx]
		jne	loc_28FA		; Jump if not equal
		retn
loc_28FA:
		stc				; Set carry flag
		retn
sub_28E6	endp

			                        ;* No entry point to code
		mov	ah,ds:data_F12F_e
		test	ah,40h			; '@'
		jz	loc_2906		; Jump if zero
		retn
loc_2906:
		or	ah,40h			; '@'
		mov	ds:data_F12F_e,ah
		mov	si,ds:data_F1CD_e
		mov	ah,[si+8]
		mov	si,0DC6Ch
		call	sub_2923
		mov	si,0DCF5h
		call	sub_2923
		mov	si,offset data_DD46

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2923	proc	near
		mov	[si+8],ah
		mov	[si+11h],ah
		retn
sub_2923	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_292A	proc	near
		mov	ah,14h
		mov	cl,1
		call	sub_14AE
		jnc	loc_2936		; Jump if carry=0
		jmp	loc_3426
loc_2936:
		call	sub_2965
		mov	ah,14h
		mov	cl,2
		call	sub_14AE
		jnc	loc_2945		; Jump if carry=0
		jmp	loc_3426
loc_2945:
		call	sub_2965
		mov	bx,0F4F3h
		mov	dx,0F4F4h
		mov	byte ptr [bx],0
		mov	cx,31Fh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		call	sub_38B9
		jmp	loc_39A9
sub_292A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2965	proc	near
		mov	ah,ds:data_F1E2_e
		test	ah,80h
		jnz	loc_2972		; Jump if not zero
		inc	byte ptr [di+10h]
		retn
loc_2972:
		dec	byte ptr [di+10h]
		retn
sub_2965	endp

			                        ;* No entry point to code
		mov	ah,byte ptr ds:data_F1DC_e+1
		cmp	ah,0Eh
		jae	loc_2985		; Jump if above or =
		mov	ah,0Fh
		mov	byte ptr ds:data_F1DC_e+1,ah
loc_2985:
		mov	ah,byte ptr ds:data_F1DA_e+1
		cmp	ah,8
		je	loc_2994		; Jump if equal
		cmp	ah,1Dh
		je	loc_2994		; Jump if equal
		retn
loc_2994:
		mov	bx,data_F1CF_e
		or	byte ptr [bx],20h	; ' '
		call	sub_39A9
		call	sub_1E85
		call	sub_3608
		call	sub_292A
		call	sub_1EA3
		mov	si,data_F1CF_e
		test	byte ptr [si+13h],80h
		mov	ah,7
		jnz	loc_29B6		; Jump if not zero
		mov	ah,1Fh
loc_29B6:
		mov	[si+0Ch],ah
		or	byte ptr [si],40h	; '@'
		and	byte ptr [si],0DFh
		jmp	loc_11F3
			                        ;* No entry point to code
		mov	ah,ds:data_F3CE_e
		inc	ah
		cmp	ah,6
		mov	ds:data_F3CE_e,ah
		jz	loc_29D2		; Jump if zero
		retn
loc_29D2:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F3CE_e,ah
		mov	ah,ds:data_F133_e
		cmp	ah,2Ch			; ','
		jne	loc_2A04		; Jump if not equal
		mov	ah,byte ptr ds:data_F1DA_e+1
		dec	ah
		mov	byte ptr ds:data_F1DA_e+1,ah
		mov	si,data_F1CF_e
		call	sub_0B2C
		mov	ah,ds:data_F1E0_e
		test	ah,20h			; ' '
		jz	loc_2A04		; Jump if zero
		mov	ah,byte ptr ds:data_F1DA_e+1
		inc	ah
		mov	byte ptr ds:data_F1DA_e+1,ah
loc_2A04:
		mov	ah,ds:data_F11D_e
		cmp	ah,28h			; '('
		je	loc_2A18		; Jump if equal
		cmp	ah,27h			; '''
		je	loc_2A39		; Jump if equal
		cmp	ah,29h			; ')'
		je	loc_2A5A		; Jump if equal
		retn
loc_2A18:
		mov	ah,data_F0B3
		mov	bx,0F0B4h
		mov	dx,0F0B3h
		mov	cx,27h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	data_F0DA,ah
		mov	bx,0F0B3h
		jmp	short loc_2A7B
loc_2A39:
		mov	ah,data_F0BA
		mov	bx,0F0BBh
		mov	dx,0F0BAh
		mov	cx,20h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	data_F0DA,ah
		mov	bx,0F0B3h
		jmp	short loc_2A7B
loc_2A5A:
		mov	ah,data_F0B3
		mov	bx,0F0B4h
		mov	dx,0F0B3h
		mov	cx,20h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	data_F0D3,ah
		mov	bx,0F0B3h
		jmp	short loc_2A7B
loc_2A7B:
		mov	ch,28h			; '('
		mov	dh,12h
		mov	dl,0
		jmp	loc_11DE
			                        ;* No entry point to code
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,4
		mov	ds:data_F115_e,ah
		retn
			                        ;* No entry point to code
		mov	bx,data_F107_e
		mov	ah,byte ptr ds:data_F1DC_e+1
		cmp	ah,0Eh
		jb	loc_2ACE		; Jump if below
		mov	ah,ds:data_F11D_e
		cmp	ah,0Dh
		je	loc_2AB3		; Jump if equal
		cmp	ah,6
		jne	loc_2ABC		; Jump if not equal
		mov	ah,byte ptr ds:data_F1DA_e+1
		cmp	ah,10h
		jb	loc_2ACE		; Jump if below
		jmp	short loc_2ABC
loc_2AB3:
		mov	ah,byte ptr ds:data_F1DA_e+1
		cmp	ah,0Ah
		jae	loc_2ACE		; Jump if above or =
loc_2ABC:
		or	byte ptr [bx],20h	; ' '
		mov	ah,ds:data_F1E0_e
		and	ah,0EFh
		and	ah,0DFh
		mov	ds:data_F1E0_e,ah
		retn
loc_2ACE:
		and	byte ptr [bx],0DFh
		retn
			                        ;* No entry point to code
		mov	bx,data_F12F_e
		test	byte ptr [bx],20h	; ' '
		jnz	loc_2B12		; Jump if not zero
		or	byte ptr [bx],20h	; ' '
		call	sub_2849
		mov	bx,data_F1DC_e+1
		inc	byte ptr [bx]
		mov	bx,0F1DBh
		mov	byte ptr [bx],23h	; '#'
		call	sub_39A9
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	ds:data_F12A_e,ah
		call	sub_22EA
		mov	bx,data_F4DA_e
		mov	ah,1
		cmp	ah,[bx]
		jne	loc_2B12		; Jump if not equal
		mov	bx,data_F103_e
		mov	ch,4
loc_2B05:
		test	byte ptr [bx],80h
		jz	loc_2B12		; Jump if zero
		inc	bx
		dec	ch
		jnz	loc_2B05		; Jump if not zero
		jmp	loc_33EC
loc_2B12:
		mov	bx,data_F107_e
		and	byte ptr [bx],0DFh
		mov	ah,byte ptr ds:data_F1DA_e+1
		cmp	ah,1Ch
		jb	loc_ret_2B24		; Jump if below
		or	byte ptr [bx],20h	; ' '

loc_ret_2B24:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2B25	proc	near
		mov	bx,0EDE3h
		mov	dx,0F4F3h
		mov	cx,320h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		call	sub_2BB9
		mov	ah,ds:data_F11C_e
		shl	ah,1			; Shift w/zeros fill
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
		mov	bx,offset data_6336
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		mov	di,offset data_487B
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	ch,[di]
		inc	di
loc_2B58:
		push	cx
		mov	bh,0
		mov	bl,[di+1]
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		push	bx
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		pop	dx
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[di]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dx,0EDE3h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		xchg	dx,bx
		mov	bl,[di+2]
		mov	bh,[di+3]
		mov	cx,7782h
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
		inc	bx
loc_2B8A:
		push	cx
		push	dx
loc_2B8C:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2B98		; Jump if zero
		xchg	dx,bx
		mov	[bx],ah
		xchg	dx,bx
loc_2B98:
		inc	bx
		inc	dx
		dec	ch
		jnz	loc_2B8C		; Jump if not zero
		pop	dx
		mov	ah,28h			; '('
;*		add	ah,dl
		db	 00h,0D4h		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		jnc	loc_2BA9		; Jump if carry=0
		inc	dh
loc_2BA9:
		pop	cx
		dec	cl
		jnz	loc_2B8A		; Jump if not zero
		mov	dx,4
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_2B58		; Jump if not zero
		retn
sub_2B25	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2BB9	proc	near
		mov	bx,offset data_EDE3
		mov	dx,0EDE4h
		mov	cx,31Fh
		mov	word ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_2BB9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2BD2	proc	near
		mov	ah,ds:data_F11D_e
		shl	ah,1			; Shift w/zeros fill
		mov	dh,0
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	di,offset data_D4C3
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	dl,[di]
		mov	dh,[di+1]
		mov	ds:data_F1CD_e,dx
		mov	di,data_0005_e
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	ah,[di-1]
		mov	ds:data_F11C_e,ah
		mov	ah,[di]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	di
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2C2F		; Jump if zero
loc_2BFF:
		push	cx
		inc	di
		test	byte ptr [di-1],80h
		jnz	loc_2C25		; Jump if not zero
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		cmp	ah,[di]
		jne	loc_2C1D		; Jump if not equal
		mov	si,data_F1CF_e
		test	byte ptr [si],80h
		jnz	loc_2C25		; Jump if not zero
		call	sub_1229
		call	sub_12D3
		jmp	short loc_2C25
loc_2C1D:
		call	sub_12A7
		jc	loc_2C25		; Jump if carry Set
		call	sub_1229
loc_2C25:
		mov	dx,8
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_2BFF		; Jump if not zero
loc_2C2F:
		mov	ds:data_F1C7_e,di
		retn
sub_2BD2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C34	proc	near
		mov	di,ds:data_F1C7_e
		mov	ah,[di]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2C3F		; Jump if not zero
		retn
loc_2C3F:
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	di
loc_2C42:
		push	cx
		push	di
		call	sub_2C50
		pop	di
		inc	di
		inc	di
		pop	cx
		dec	ch
		jnz	loc_2C42		; Jump if not zero
		retn
sub_2C34	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C50	proc	near
		mov	bl,[di]
		mov	bh,[di+1]
		jmp	bx			;*Register jump

;==== External Entry into Subroutine ======================================

sub_2C57:
		push	bx
		push	cx
		push	dx
		call	sub_10D5
		mov	[bx],ah
		pop	dx
		pop	cx
		pop	bx
		retn
sub_2C50	endp

			                        ;* No entry point to code
		mov	[si+0Bh],dl
		mov	[si+0Ch],dh
		mov	[si+0Dh],bl
		mov	[si+0Eh],bh
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C70	proc	near
		push	si
		mov	si,data_F1CF_e
		call	sub_2C79
		pop	si
		retn
sub_2C70	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C79	proc	near
		mov	dl,[si+0Bh]
		mov	dh,[si+0Ch]
		mov	bl,[si+0Dh]
		mov	bh,[si+0Eh]
		test	byte ptr [si+13h],80h
		retn
sub_2C79	endp

			                        ;* No entry point to code
		mov	ah,[si+13h]
		cmp	ah,7Fh
		jne	loc_2C93		; Jump if not equal
		retn
loc_2C93:
		inc	byte ptr [si+13h]
		retn
			                        ;* No entry point to code
		mov	ah,[si+13h]
		cmp	ah,81h
		jne	loc_2CA0		; Jump if not equal
		retn
loc_2CA0:
		dec	byte ptr [si+13h]
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CA4	proc	near
		mov	ah,[si+14h]
		cmp	ah,7Fh
		jne	loc_2CAD		; Jump if not equal
		retn
loc_2CAD:
		inc	byte ptr [si+14h]
		retn
sub_2CA4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CB1	proc	near
		mov	ah,[si+14h]
		cmp	ah,81h
		jne	loc_2CBA		; Jump if not equal
		retn
loc_2CBA:
		dec	byte ptr [si+14h]
		retn
sub_2CB1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CBE	proc	near
loc_2CBE:
		call	sub_2CE2
		mov	cl,[si+13h]
		mov	bl,[si+0Bh]
		mov	bh,[si+0Ch]
		call	sub_2D0B
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	[si+0Bh],bl
		mov	[si+0Ch],bh
		retn
sub_2CBE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CD6	proc	near
		call	sub_2CBE
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	[si+0Bh],bl
		mov	[si+0Ch],bh
		retn
sub_2CD6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CE2	proc	near
loc_2CE2:
		mov	cl,[si+13h]
		mov	bl,[si+3]
		mov	bh,[si+4]
		call	sub_2D0B
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	[si+0Bh],bl
		mov	[si+0Ch],bh
		mov	cl,[si+14h]
		call	sub_2D0B
		mov	bl,[si+5]
		mov	bh,[si+6]
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	[si+0Dh],bl
		mov	[si+0Eh],bh
		retn
sub_2CE2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D0B	proc	near
		mov	ch,0
		test	cl,80h
		jnz	loc_2D13		; Jump if not zero
		retn
loc_2D13:
		mov	ch,0FFh
		retn
sub_2D0B	endp

			                        ;* No entry point to code
		mov	bl,[si+22h]
		mov	bh,[si+23h]
		mov	dx,5
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
		inc	bx
		mov	bh,[bx]
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		jmp	bx			;*Register jump

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D2A	proc	near
		mov	bl,[si+22h]
		mov	bh,[si+23h]
		mov	dl,[bx]
loc_2D32:
		test	byte ptr [si+13h],80h
		jz	loc_2D3A		; Jump if zero
		inc	bx
		inc	bx
loc_2D3A:
		inc	bx
		mov	cl,[bx]
		inc	bx
		mov	ch,[bx]
		jmp	loc_1065
sub_2D2A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D43	proc	near
		mov	bl,[si+22h]
		mov	bh,[si+23h]
		mov	dl,[bx]
		mov	cx,0Bh
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		jmp	short loc_2D32
sub_2D43	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D52	proc	near
		call	sub_2D58
		jmp	loc_1385
sub_2D52	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D58	proc	near
		mov	dl,[si+20h]
		mov	dh,[si+21h]
		mov	di,data_0000_e
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	bl,[di]
		mov	dl,[di+1]
		retn
sub_2D58	endp

			                        ;* No entry point to code
		mov	ah,[si+24h]
		add	ah,2
		mov	bh,0
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	dl,[si+20h]
		mov	dh,[si+21h]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		xchg	dx,bx
		mov	di,0
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D83	proc	near
		call	sub_2D58
		jmp	loc_13C6
sub_2D83	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D89	proc	near
		call	sub_2D83
		jc	loc_2D8F		; Jump if carry Set
		retn
loc_2D8F:
		or	byte ptr [si],10h
		pop	bx
		mov	bx,0CED3h
		jmp	loc_3192
sub_2D89	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D99	proc	near
		call	sub_1355
		call	sub_2DBF
		jc	loc_2DA5		; Jump if carry Set
		mov	[si+13h],dl
		retn
loc_2DA5:
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
		neg	ah
		mov	[si+13h],ah
		retn
sub_2D99	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2DAD	proc	near
		call	sub_1348
		call	sub_2DBF
		jc	loc_2DB9		; Jump if carry Set
		mov	[si+14h],dl
		retn
loc_2DB9:
		neg	ah
		mov	[si+14h],ah
		retn
sub_2DAD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2DBF	proc	near
		push	ax
		pushf				; Push flags
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,dl
		db	 00h,0D4h		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		popf				; Pop flags
		pop	ax
		retn
sub_2DBF	endp

			                        ;* No entry point to code
		call	sub_2D89
		call	sub_2D99
		call	sub_2DAD
		test	byte ptr [si+24h],1
		jnz	loc_2DFA		; Jump if not zero
		call	sub_2D2A
		jc	loc_2DE1		; Jump if carry Set
		retn
loc_2DE1:
		jnz	loc_2DE4		; Jump if not zero
		retn
loc_2DE4:
		call	sub_1111
		cmp	ah,0C8h
		jae	loc_2DED		; Jump if above or =
		retn
loc_2DED:
		mov	ah,[si+2]
		cmp	ah,1
		jb	loc_2DF6		; Jump if below
		retn
loc_2DF6:
		or	byte ptr [si+24h],1
loc_2DFA:
		call	sub_2D43
		jc	loc_2E00		; Jump if carry Set
		retn
loc_2E00:
		jnz	loc_2E03		; Jump if not zero
		retn
loc_2E03:
		and	byte ptr [si+24h],0FEh
		call	sub_2D58
		mov	ds:data_F1A2_e,di
		call	sub_2C79
		mov	cx,140h
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		inc	dh
		mov	ds:data_F19E_e,bx
		mov	ds:data_F1A0_e,dx
		mov	ds:data_F1B5_e,si
		call	sub_12A7
		jnc	loc_2E2A		; Jump if carry=0
		retn
loc_2E2A:
		mov	bx,0CF4Fh
		call	sub_3192
		mov	cl,0
		mov	di,ds:data_F1A2_e
		mov	ch,[di+4]
		mov	dx,ds:data_F1A0_e
		mov	bx,ds:data_F19E_e
		call	sub_1274
		mov	di,ds:data_F1B5_e
		mov	ah,[di+12h]
		mov	[si+2],ah
		mov	ah,[di+13h]
		mov	[si+13h],ah
		mov	ah,[di+14h]
		mov	[si+14h],ah
		inc	byte ptr [di+2]
		mov	di,ds:data_F1A2_e
		mov	ah,[di+2]
		mov	[si+22h],ah
		add	ah,7
		mov	[si+20h],ah
		mov	ah,[di+3]
		mov	[si+23h],ah
		adc	ah,0
		mov	[si+21h],ah
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2E7A	proc	near
		call	sub_2D52
		jnc	loc_2E85		; Jump if carry=0
		pop	bx
		call	sub_1506
		jmp	short loc_2EA3
loc_2E85:
		call	sub_2D2A
		jc	loc_2E8B		; Jump if carry Set
		retn
loc_2E8B:
		call	sub_2CA4
		call	sub_2CBE
		call	sub_0A19
		mov	ah,[si+24h]
		and	ah,0B0h
		jnz	loc_2EA3		; Jump if not zero
		test	byte ptr [si+11h],40h	; '@'
		jnz	loc_2EA3		; Jump if not zero
		retn
loc_2EA3:
		call	sub_120D
		or	byte ptr [si],10h
		mov	ah,[si+2]
		call	sub_14E3
		jnc	loc_2EB2		; Jump if carry=0
		retn
loc_2EB2:
		mov	ah,[di+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2EBA		; Jump if not zero
		retn
loc_2EBA:
		dec	byte ptr [di+2]
		retn
sub_2E7A	endp

			                        ;* No entry point to code
		call	sub_2F8E
		jnz	loc_2EA3		; Jump if not zero
		retn
			                        ;* No entry point to code
		call	sub_2E7A
		test	byte ptr [si],10h
		jnz	loc_2ECD		; Jump if not zero
		retn
loc_2ECD:
		and	byte ptr [si],0EFh
		mov	ah,1Bh
		mov	[si+0Fh],ah
		retn
			                        ;* No entry point to code
		test	byte ptr [si+24h],1
		jz	loc_2EE2		; Jump if zero
		call	sub_2F8E
		jnz	loc_2EA3		; Jump if not zero
		retn
loc_2EE2:
		call	sub_2D2A
		jc	loc_2EE8		; Jump if carry Set
		retn
loc_2EE8:
		call	sub_1111
		cmp	ah,3
		jb	loc_2EF1		; Jump if below
		retn
loc_2EF1:
		or	byte ptr [si+24h],1
		retn
			                        ;* No entry point to code
		call	sub_2D83
		jnc	loc_2EFF		; Jump if carry=0
		or	byte ptr [si],10h
		retn
loc_2EFF:
		call	sub_2D52
		jnc	loc_2F08		; Jump if carry=0
		pop	bx
		jmp	loc_1506
loc_2F08:
		mov	ah,[si+13h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2F17		; Jump if not zero
		mov	dl,9
		call	sub_2F7C
		mov	[si+13h],bl
loc_2F17:
		call	sub_1111
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	dl,0Ah
		call	sub_2F7C
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
;*		cmp	ah,bl
		db	 38h,0DCh		;  Fixup - byte match
		jz	loc_2F41		; Jump if zero
		jc	loc_2F41		; Jump if carry Set
		call	sub_1355
		mov	ah,[si+13h]
		test	ah,80h
		jnz	loc_2F3A		; Jump if not zero
		jnc	loc_2F3E		; Jump if carry=0
		neg	ah
		jmp	short loc_2F3E
loc_2F3A:
		jc	loc_2F3E		; Jump if carry Set
		neg	ah
loc_2F3E:
		mov	[si+13h],ah
loc_2F41:
		call	sub_2D2A
		jc	loc_2F47		; Jump if carry Set
		retn
loc_2F47:
		call	sub_2CE2
		call	sub_0A19
		call	sub_3001
		mov	ah,[si+11h]
		test	ah,40h			; '@'
		jz	loc_2F6D		; Jump if zero
		or	ah,[si+24h]
		test	byte ptr [si+13h],80h
		jnz	loc_2F67		; Jump if not zero
		test	ah,20h			; ' '
		jnz	loc_2F6D		; Jump if not zero
		retn
loc_2F67:
		test	ah,10h
		jnz	loc_2F6D		; Jump if not zero
		retn
loc_2F6D:
		mov	ah,[si+13h]
		neg	ah
		mov	[si+13h],ah
		mov	byte ptr [si+2],0
		jmp	loc_120D

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2F7C	proc	near
		mov	bl,[si+22h]
		mov	bh,[si+23h]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
		inc	bx
		mov	bh,[bx]
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		retn
sub_2F7C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2F8E	proc	near
		call	sub_2D52
		jnc	loc_2F98		; Jump if carry=0
		pop	bx
		pop	bx
		jmp	loc_1506

;==== External Entry into Subroutine ======================================

sub_2F98:
loc_2F98:
		call	sub_2D2A
		jnc	loc_2FAE		; Jump if carry=0
		call	sub_2CD6
		test	byte ptr [si+14h],80h
		jnz	loc_2FAB		; Jump if not zero
		call	sub_2CA4
		jmp	short loc_2FAE
loc_2FAB:
		call	sub_2CB1
loc_2FAE:
		call	sub_0A19
		mov	ah,[si+24h]
		and	ah,0F0h
		retn
sub_2F8E	endp

			                        ;* No entry point to code
		call	sub_2D52
		jnc	loc_2FC7		; Jump if carry=0
		pop	bx
		mov	byte ptr [si+2],32h	; '2'
		call	sub_1506
		jmp	short loc_2FEE
loc_2FC7:
		call	sub_2D83
		jnc	loc_2FD0		; Jump if carry=0
		or	byte ptr [si],10h
		retn
loc_2FD0:
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2FE1		; Jump if not zero
		call	sub_2D99
		call	sub_2DAD
		mov	byte ptr [si+2],32h	; '2'
loc_2FE1:
		call	sub_2F98
		jnz	loc_2FEA		; Jump if not zero
		dec	byte ptr [si+2]
		retn
loc_2FEA:
		mov	byte ptr [si+2],0Ah
loc_2FEE:
		mov	ah,[si+13h]
		neg	ah
		mov	[si+13h],ah
		mov	ah,[si+14h]
		neg	ah
		mov	[si+14h],ah
		jmp	loc_120D

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3001	proc	near
		mov	ah,[si+11h]
		and	ah,0CFh
		mov	[si+11h],ah
		mov	cl,[si+0Ch]
		mov	ch,[si+0Eh]
		call	sub_10D5
		mov	ah,byte ptr ds:data_F1C5_e+1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_301D		; Jump if not zero
		inc	ah
loc_301D:
		push	ax
		push	bx
		call	sub_303F
		jnc	loc_3028		; Jump if carry=0
		or	byte ptr [si+11h],10h
loc_3028:
		pop	bx
		pop	ax
		mov	dx,ds:data_F1C3_e
;*		mov	dl,dh
		db	 88h,0F2h		;  Fixup - byte match
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		call	sub_303F
		jc	loc_303A		; Jump if carry Set
		retn
loc_303A:
		or	byte ptr [si+11h],20h	; ' '
		retn
sub_3001	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_303F	proc	near
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	dx,28h
loc_3044:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_3050		; Jump if zero
		cmp	ah,4Eh			; 'N'
		jae	loc_3050		; Jump if above or =
		retn
loc_3050:
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_3044		; Jump if not zero
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_303F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3059	proc	near
		cli				; Disable interrupts
		push	ds
		mov	ax,0
		mov	ds,ax

		mov	bx,d_0000_0024_e	; INT 09h vector
		mov	ax,[bx]
		mov	cs:data_30A0,ax		; save old INT 09h routine
		mov	word ptr [bx],30EAh	; install INT 09h routine
		inc	bx
		inc	bx
		mov	ax,[bx]
		mov	cs:data_30A2,ax
		mov	ax,cs
		mov	[bx],ax

		mov	bx,d_0000_0070_e	; INT 28h vector (waiting on key)
		mov	ax,[bx]
		mov	cs:data_30A4,ax
		mov	word ptr [bx],30A8h
		inc	bx
		inc	bx
		mov	ax,[bx]
		mov	cs:data_30A6,ax
		mov	ax,cs
		mov	[bx],ax
		mov	cx,2E9Eh
;*		mov	al,cl
		db	 88h,0C8h		;  Fixup - byte match
		out	40h,al			; port 40h, 8253 timer 0 clock
;*		mov	al,ch
		db	 88h,0E8h		;  Fixup - byte match
		out	40h,al			; port 40h, 8253 timer 0 clock
		pop	ds
		sti				; Enable interrupts
		retn
sub_3059	endp

data_30A0	dw	115Fh			; old INT 09h routine
data_30A2	dw	0FC00h
data_30A4	dw	3F4Dh			; old INT 28h routine
data_30A6	dw	0FC00h

; INT 28h routine
loc_30A8:
		db	0FAh, 1Eh, 06h, 50h, 53h, 51h
		db	 52h, 56h, 57h, 8Ch,0C8h, 05h
		db	 00h, 00h, 8Eh,0D8h,0FEh, 06h
		db	 17h,0F1h, 80h, 3Eh, 17h,0F1h
		db	0C8h, 75h, 0Ah,0C6h, 06h, 17h
		db	0F1h, 00h, 80h, 0Eh, 1Ah,0F1h
		db	 40h,0FEh, 06h, 77h, 48h,0FFh
		db	 06h, 78h, 48h,0F7h, 06h, 78h
		db	 48h, 01h, 00h, 75h, 03h,0E8h
		db	0D8h, 00h
loc_30E0:
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		pop	es
		pop	ds
		sti				; Enable interrupts
		iret				; Interrupt return

; INT 09h interrupt routine
loc_30EA:

			                        ;* No entry point to code
		cli				; Disable interrupts
		push	ds
		push	ax
		push	bx
		push	cx
		mov	ax,cs
		add	ax,0
		mov	ds,ax
		in	al,60h			; port 60h, keybd scan or sw1
		xchg	bx,ax
		in	al,61h			; port 61h, 8255 port B, read
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
		xchg	al,ah
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		xchg	bx,ax
		mov	bx,0CE48h
loc_3109:
		cmp	byte ptr [bx],0
		je	loc_3118		; Jump if equal
		cmp	al,[bx]
		je	loc_3115		; Jump if equal
		inc	bx
		jmp	short loc_3109
loc_3115:
		xor	byte ptr [bx],80h
loc_3118:
		in	al,20h			; port 20h, 8259-1 int IRR/ISR
		or	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
		test	byte ptr ds:[0CE56h],80h
		jz	loc_3138		; Jump if zero
		test	byte ptr ds:[0CE57h],80h
		jz	loc_3138		; Jump if zero
		test	byte ptr ds:[0CE58h],80h
		jz	loc_3138		; Jump if zero
;*		jmp	far ptr l_FFFF_0000	;*
		db	0EAh
		dw	0, 0FFFFh		;  Fixup - byte match
loc_3138:
		test	byte ptr ds:[0CE4Bh],80h
		jz	loc_3167		; Jump if zero
		test	byte ptr ds:[0CE4Ch],80h
		jz	loc_3167		; Jump if zero
		test	byte ptr ds:[0CE52h],80h
		jz	loc_3167		; Jump if zero
		test	byte ptr ds:[0CE53h],80h
		jz	loc_3167		; Jump if zero
		test	byte ptr ds:[0CE4Eh],80h
		jz	loc_3167		; Jump if zero
		mov	byte ptr cs:[loc_lives_dec],90h
		mov	byte ptr cs:[loc_lives_dec+1],90h
;		mov	byte ptr cs:[929h],90h
;		mov	byte ptr cs:[92Ah],90h
loc_3167:
		test	byte ptr ds:[0CE54h],80h
		jz	loc_317A		; Jump if zero
		mov	byte ptr cs:[loc_lives_dec],0FEh
		mov	byte ptr cs:[loc_lives_dec+1],0CCh
;		mov	byte ptr cs:[929h],0FEh
;		mov	byte ptr cs:[92Ah],0CCh
loc_317A:
		pop	cx
		pop	bx
		pop	ax
		pop	ds
		sti				; Enable interrupts
		iret				; Interrupt return
loc_3180:
		mov	byte ptr data_487A,0
		jmp	loc_324D

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3188	proc	near
		mov	byte ptr data_487A,1
		mov	bx,0D235h
		jmp	short loc_319A

;==== External Entry into Subroutine ======================================

sub_3192:
loc_3192:
		test	byte ptr data_487A,0FFh
		jz	loc_319A		; Jump if zero
		retn
loc_319A:
		cli				; Disable interrupts
		mov	data_4855,485Fh
		mov	data_4857,31B7h
		mov	byte ptr data_4859,1
		mov	word ptr data_4850+1,bx
		mov	byte ptr data_4850,1
		sti				; Enable interrupts
		retn
sub_3188	endp

		db	81h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_31B8	proc	near
		mov	al,byte ptr data_4850
		test	al,1
		jnz	loc_31C0		; Jump if not zero
		retn
loc_31C0:
		test	al,2
		jnz	loc_31E0		; Jump if not zero
loc_31C4:
		mov	bx,word ptr data_4850+1
		mov	al,[bx]
		inc	bx
		mov	word ptr data_4850+1,bx
		mov	ah,0
		mov	bx,offset data_323F
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		call	word ptr [bx]		;*7 entries
		mov	al,byte ptr data_4850
		test	al,80h
		jnz	loc_31C4		; Jump if not zero
		retn
loc_31E0:
		mov	cx,data_4853
		dec	cx
		mov	data_4853,cx
		jnz	loc_31F5		; Jump if not zero
		mov	al,byte ptr data_4850
		and	al,7Dh			; '}'
		mov	byte ptr data_4850,al
		jmp	short loc_31C4
loc_31F5:
		test	data_4850,40h
		jnz	loc_ret_3209		; Jump if not zero
		mov	ah,data_485C
		dec	ah
		jz	loc_320A		; Jump if zero
		mov	data_485C,ah

loc_ret_3209:
		retn
loc_320A:
		mov	ah,data_4859
		mov	data_485C,ah
		mov	bx,data_485A
		mov	al,[bx]
		cmp	al,81h
		jne	loc_321D		; Jump if not equal
		retn
loc_321D:
		cmp	al,80h
		jne	loc_3231		; Jump if not equal
		mov	bx,data_4857
		mov	data_485A,bx
		mov	al,data_4859
		mov	data_485C,al
		mov	al,[bx]
loc_3231:
		cbw				; Convrt byte to word
		mov	cx,data_485D
;*		add	cx,ax
		db	 01h,0C1h		;  Fixup - byte match
		mov	data_485D,cx
		jmp	loc_32FF
data_323F	dw	offset sub_324D
data_3241	dw	offset sub_32D0
data_3243	dw	offset sub_3314
data_3245	dw	offset sub_3279
data_3247	dw	offset sub_3259
data_3249	dw	offset sub_32BD
data_324B	dw	offset sub_3297

;==== External Entry into Subroutine ======================================

sub_324D:
loc_324D:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	byte ptr data_4850,0
		retn

;==== External Entry into Subroutine ======================================

sub_3259:
		cmp	data_4855,485Fh
		je	loc_324D		; Jump if equal
		or	byte ptr data_4850,80h
		dec	data_4855
		dec	data_4855
		mov	si,data_4855
		mov	bx,[si]
		mov	word ptr data_4850+1,bx
		retn

;==== External Entry into Subroutine ======================================

sub_3279:
		or	byte ptr data_4850,80h
		mov	bx,word ptr data_4850+1
		mov	cx,[bx]
		inc	bx
		inc	bx
		mov	word ptr data_4850+1,cx
		mov	si,data_4855
		mov	[si],bx
		inc	si
		inc	si
		mov	data_4855,si
		retn

;==== External Entry into Subroutine ======================================

sub_3297:
		mov	al,byte ptr data_4850
		or	al,80h
		mov	byte ptr data_4850,al
		mov	bx,word ptr data_4850+1
		mov	al,[bx]
		mov	data_4859,al
		mov	data_485C,al
		inc	bx
		mov	cx,[bx]
		inc	bx
		inc	bx
		mov	word ptr data_4850+1,bx
		mov	data_4857,cx
		mov	data_485A,cx
		retn

;==== External Entry into Subroutine ======================================

sub_32BD:
		mov	al,byte ptr data_4850
		or	al,80h
		mov	byte ptr data_4850,al
		mov	bx,word ptr data_4850+1
		mov	cx,[bx]
		mov	word ptr data_4850+1,cx
		retn

;==== External Entry into Subroutine ======================================

sub_32D0:
		mov	al,byte ptr data_4850
		and	al,3Fh			; '?'
		or	al,2
		mov	byte ptr data_4850,al
		mov	cx,data_4857
		mov	data_485A,cx
		mov	al,data_4859
		mov	data_485C,al
		mov	bx,word ptr data_4850+1
		mov	cx,[bx]
		inc	bx
		inc	bx
		mov	ax,[bx]
		inc	bx
		inc	bx
		mov	data_4853,ax
		mov	word ptr data_4850+1,bx
		mov	data_485D,cx
loc_32FF:
		in	al,61h			; port 61h, 8255 port B, read
		push	ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
;*		mov	al,cl
		db	 88h,0C8h		;  Fixup - byte match
		out	42h,al			; port 42h, 8253 timer 2 spkr
;*		mov	al,ch
		db	 88h,0E8h		;  Fixup - byte match
		out	42h,al			; port 42h, 8253 timer 2 spkr
		pop	ax
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_31B8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3314	proc	near
		mov	al,byte ptr data_4850
		and	al,7Fh
		or	al,42h			; 'B'
		mov	byte ptr data_4850,al
		mov	bx,word ptr data_4850+1
		mov	ax,[bx]
		inc	bx
		inc	bx
		mov	data_4853,ax
		mov	word ptr data_4850+1,bx
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_3314	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3334	proc	near
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	dh,0FFh
		mov	cx,2710h
loc_333B:
		inc	dh
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		jnc	loc_333B		; Jump if carry=0
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	cx,3E8h
		mov	dl,0FFh
loc_334A:
		inc	dl
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		jnc	loc_334A		; Jump if carry=0
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		push	dx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	dx,64h
		mov	ch,0FFh
loc_335A:
		inc	ch
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		jnc	loc_335A		; Jump if carry=0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	dx,0Ah
		mov	cl,0FFh
loc_3369:
		inc	cl
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		jnc	loc_3369		; Jump if carry=0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		pop	dx
		mov	si,data_F3D4_e
		mov	[si],dh
		mov	[si+1],dl
		mov	[si+2],ch
		mov	[si+3],cl
		mov	[si+4],bl
		mov	byte ptr [si+5],0FFh
		retn
sub_3334	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3388	proc	near
loc_3388:
		push	si
		push	dx
		push	cx
		push	ax
		call	sub_3334
		pop	ax
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	ah,5
;*		sub	ah,dl
		db	 28h,0D4h		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		pop	cx
loc_339D:
		mov	ah,[si]
		test	ah,80h
		jnz	loc_33B2		; Jump if not zero
		add	ah,1Eh
		mov	dx,0FFFFh
		call	sub_3851
		inc	cl
		inc	si
		jmp	short loc_339D
loc_33B2:
		pop	dx
		pop	si
		retn
sub_3388	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_33B6	proc	near
		call	sub_368E
		call	sub_361D
		mov	dx,0
		call	sub_22EA
		retn
sub_33B6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_33C3	proc	near
		mov	bx,data_F107_e+1
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	ah,1Ah
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,17h
		mov	ah,[bx]
		add	ah,1Eh
		jmp	loc_3851
sub_33C3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_33D8	proc	near
		mov	ch,0Dh
		mov	cl,1Ah
loc_33DC:
		push	cx
		mov	ch,17h
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		call	sub_3851
		pop	cx
		inc	cl
		dec	ch
		jnz	loc_33DC		; Jump if not zero
		retn
sub_33D8	endp

loc_33EC:
		mov	cx,404h
		mov	dx,522h
		call	sub_1162
		mov	bx,offset data_3585
		call	sub_1181
		jmp	short loc_340C
loc_33FD:
		mov	cx,404h
		mov	dx,723h
		call	sub_1162
		mov	bx,offset data_34C6
		call	sub_1181
loc_340C:
		mov	cx,0FFFFh
		call	sub_114F
		mov	cx,0
		call	sub_114F
		mov	cx,0FFFFh
		call	sub_114F
loc_341E:
		call	sub_3839
		jz	loc_341E		; Jump if zero
		jmp	loc_016F
loc_3426:
		mov	bx,356Eh
		jmp	loc_1181

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_342C	proc	near
		mov	bx,3432h
		jmp	loc_1181
sub_342C	endp

		db	0, 3
		db	0Dh, '[[[[[[GOODY[[[[[['
		db	0, 5
		db	0Dh, 'O[[[[[[[IZQU['
		db	 00h, 06h, 0Dh, 50h
		db	7 dup (5Bh)
		db	 44h, 45h, 52h, 43h, 5Bh, 00h
		db	 07h
		db	0Dh, 'Q[[[[[[[ARR[', 0
		db	8, 0Dh, 'A[[[[[[[ABJ[', 0
		db	9, 0Dh, 'BREACK[[MENU[', 0
		db	0Ah, 0Dh, 'R[[[[[[[STOP[', 0
		db	0Bh
		db	0Dh, 'SPACE[[[EMPEZAR'
		db	0
		db	0Ch, 0Dh, 'D[[[[[[[DEMO'
		db	0FFh
data_34C6	db	0
		db	5, 5
		db	'OPERA SE HA QUEDADO SIN DINERO'
		db	0, 6, 5
		db	'NOS VEMOS EN LA OBLIGACION DE  '
		db	0, 7, 5
		db	'DE DECLARARNOS EN QUIEBRA      '
		db	0, 8, 5
		db	'ACEPTARIAS UN PAGARE\[[[[[[  '
		db	0, 4, 5
		db	'ROGAMOS DISCULPEN LAS MOLESTIAS'
		db	0FFh, 00h
		db	0Ah, 0Ah, 'CUIDADO NO FUNCIONA'
		db	0FFh
data_3585	db	0
		db	5, 5
		db	'AQUI SE ACABARON TUS CORRERIAS'
		db	0, 6, 5
		db	'PERO TU ESFUERZO NO HA SIDO EN'
		db	0, 7, 5
		db	'VANO EL POLI RODRIGUEZ TE DEBE]'
		db	0, 8, 6
		db	'ASCENSO A JEFE DE POLICIA['
		db	0FFh,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3608	proc	near
		mov	ch,0A0h
		mov	cl,50h			; 'P'
		mov	dx,0
		mov	ah,0
		call	sub_3748
		mov	cx,0
		call	sub_114F
		jmp	loc_114F
sub_3608	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_361D	proc	near
loc_361D:
		mov	ah,ds:data_F125_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_3631		; Jump if zero
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,2
		mov	ah,0FFh
		mov	dx,0
		call	sub_3646
loc_3631:
		mov	ah,16h
		sub	ah,ds:data_F125_e
		jnz	loc_363A		; Jump if not zero
		retn
loc_363A:
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	dl,ds:data_F125_e
		mov	dh,0
		mov	ch,2
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
sub_361D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3646	proc	near
		add	dx,1CC8h
		call	sub_3748
		retn
sub_3646	endp

loc_364E:
		mov	ah,3Ch			; '<'
		mov	di,196Ch
		sub	ah,ds:data_F127_e
		jz	loc_365E		; Jump if zero
		mov	bh,0
		call	sub_3669
loc_365E:
		mov	bh,0AAh
		mov	ah,ds:data_F127_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_3669		; Jump if not zero
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3669	proc	near
loc_3669:
		mov	cl,3
		shr	ah,cl			; Shift w/zeros fill
		jnz	loc_3670		; Jump if not zero
		retn
loc_3670:
		inc	ah
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0
		push	es
		mov	ax,0B800h
		mov	es,ax

locloop_367C:
		mov	es:[di],bh
		mov	es:[di+1],bh
		mov	es:[di+2],bh
		add	di,50h
		loop	locloop_367C		; Loop if cx > 0

		pop	es
		retn
sub_3669	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_368E	proc	near
		mov	si,offset data_DF56
		push	si
		mov	ah,ds:data_F103_e
		call	sub_36CC
		mov	dx,19D3h
		call	sub_36E3
		pop	si
		push	si
		mov	ah,byte ptr ds:data_F103_e+1
		call	sub_36CC
		mov	dx,19DAh
		call	sub_36E3
		pop	si
		push	si
		mov	ah,ds:data_F105_e
		call	sub_36CC
		mov	dx,19E1h
		call	sub_36E3
		pop	si
		mov	ah,byte ptr ds:data_F105_e+1
		call	sub_36CC
		mov	dx,19E8h
		call	sub_36E3
		retn
sub_368E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_36CC	proc	near
		cmp	ah,0FFh
		jne	loc_36D2		; Jump if not equal
		retn
loc_36D2:
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		mov	bx,[si]
		mov	cl,[bx]
		inc	bx
		mov	ch,[bx]
		inc	bx
		retn
sub_36CC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_36E3	proc	near
		cmp	ah,0FFh
		je	loc_36EA		; Jump if equal
		jmp	short loc_3736
loc_36EA:
		mov	cl,6
		mov	ch,10h
		mov	ah,0
		jmp	short loc_373E
			                        ;* No entry point to code
		retn

;==== External Entry into Subroutine ======================================

sub_36F3:
		mov	bx,offset data_E163
		mov	dx,1900h
		mov	cl,50h			; 'P'
		mov	ch,28h			; '('
		jmp	short $+2		; delay for I/O
		push	es
		mov	ax,0B800h
		mov	es,ax
loc_3705:
		push	cx
;*		mov	di,dx
		db	 89h,0D7h		;  Fixup - byte match
loc_3708:
		mov	al,[bx]
		mov	es:[di],al
		inc	bx
		inc	di
		dec	cl
		jnz	loc_3708		; Jump if not zero
		pop	cx
		dec	ch
		jnz	loc_371A		; Jump if not zero
		pop	es
		retn
loc_371A:
		push	cx
;*		mov	di,dx
		db	 89h,0D7h		;  Fixup - byte match
		add	di,d_B800_2000_e
loc_3721:
		mov	al,[bx]
		mov	es:[di],al
		inc	bx
		inc	di
		dec	cl
		jnz	loc_3721		; Jump if not zero
		pop	cx
		add	dx,50h
		dec	ch
		jnz	loc_3705		; Jump if not zero
		pop	es
		retn
loc_3736:
		push	es
		mov	ax,0B800h
		mov	es,ax
		jmp	short loc_371A
loc_373E:
		push	ds
		push	ax
		mov	ax,0B800h
		mov	ds,ax
		pop	ax
		jmp	short loc_3761

;==== External Entry into Subroutine ======================================

sub_3748:
		push	ds
		push	ax
		mov	ax,0B800h
		mov	ds,ax
		pop	ax
loc_3750:
		push	cx
;*		mov	bx,dx
		db	 89h,0D3h		;  Fixup - byte match
loc_3753:
		mov	[bx],ah
		inc	bx
		dec	cl
		jnz	loc_3753		; Jump if not zero
		pop	cx
		dec	ch
		jnz	loc_3761		; Jump if not zero
		pop	ds
		retn
loc_3761:
		push	cx
;*		mov	bx,dx
		db	 89h,0D3h		;  Fixup - byte match
		add	bx,2000h
loc_3768:
		mov	[bx],ah
		inc	bx
		dec	cl
		jnz	loc_3768		; Jump if not zero
		pop	cx
		add	dx,50h
		dec	ch
		jnz	loc_3750		; Jump if not zero
		pop	ds
		retn
sub_36E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3779	proc	near
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		call	sub_3782
		retn
sub_3779	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3782	proc	near
loc_3782:
		mov	bx,100h
		mov	cs:data_3943,bl
		mov	ax,0B00h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		retn
sub_3782	endp

loc_3790:
		mov	bx,101h
		mov	cs:data_3943,bl
		mov	ax,0B00h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_379E	proc	near
		mov	byte ptr ds:data_F115_e,0
		mov	al,byte ptr ds:[0CE4Dh]
		or	al,byte ptr ds:[0CE5Ch]
		test	al,80h
		jz	loc_37B3		; Jump if zero
		or	byte ptr ds:data_F115_e,1
loc_37B3:
		mov	al,byte ptr ds:[0CE4Eh]
		or	al,byte ptr ds:[0CE5Dh]
		test	al,80h
		jz	loc_37C3		; Jump if zero
		or	byte ptr ds:data_F115_e,2
loc_37C3:
		mov	al,byte ptr ds:[0CE4Bh]
		or	al,byte ptr ds:[0CE5Ah]
		test	al,80h
		jz	loc_37D3		; Jump if zero
		or	byte ptr ds:data_F115_e,4
loc_37D3:
		mov	al,byte ptr ds:[0CE4Ch]
		or	al,byte ptr ds:[0CE5Bh]
		test	al,80h
		jz	loc_37E3		; Jump if zero
		or	byte ptr ds:data_F115_e,8
loc_37E3:
		mov	al,byte ptr ds:[0CE4Fh]
		or	al,byte ptr ds:[0CE5Eh]
		test	al,80h
		jz	loc_37F3		; Jump if zero
		or	byte ptr ds:data_F115_e,10h
loc_37F3:
		mov	al,byte ptr ds:[0CE51h]
		or	al,byte ptr ds:[0CE5Fh]
		test	al,80h
		jz	loc_3803		; Jump if zero
		or	byte ptr ds:data_F115_e,20h	; ' '
loc_3803:
		mov	al,byte ptr ds:[0CE50h]
		test	al,80h
		jz	loc_380F		; Jump if zero
		or	byte ptr ds:data_F115_e,40h	; '@'
loc_380F:
		test	byte ptr ds:[0CE59h],80h
		jz	loc_ret_381B		; Jump if zero
		or	byte ptr ds:data_F115_e,80h

loc_ret_381B:
		retn
sub_379E	endp

		db	0C3h,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_381E	proc	near
		test	byte ptr ds:data_F115_e,40h	; '@'
		jnz	loc_3826		; Jump if not zero
		retn
loc_3826:
		test	byte ptr ds:[0CE50h],80h
		jnz	loc_3826		; Jump if not zero
		mov	al,1
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		retn
sub_381E	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3833	proc	near
		test	byte ptr ds:[0CE53h],80h
		retn
sub_3833	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3839	proc	near
		test	byte ptr ds:[0CE4Fh],80h
		retn
sub_3839	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_383F	proc	near
		push	si
		push	di
		push	ax
		push	cx
		push	dx
		push	bx
		push	es
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		add	ax,63C2h
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		jmp	short loc_3867

;==== External Entry into Subroutine ======================================

sub_3851:
loc_3851:
		push	si
		push	di
		push	ax
		push	cx
		push	dx
		push	bx
		push	es
;*		mov	bx,cx
		db	 89h,0CBh		;  Fixup - byte match
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		mov	ah,0
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		add	ax,73C2h
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
loc_3867:
		mov	dx,0B800h
		mov	es,dx
;*		mov	dl,bh
		db	 88h,0FAh		;  Fixup - byte match
		mov	dh,0
		mov	ax,140h
		mul	dx			; dx:ax = reg * ax
		mov	bh,0
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
;*		mov	di,ax
		db	 89h,0C7h		;  Fixup - byte match
		cld				; Clear direction
		mov	cx,4

locloop_3881:
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		loop	locloop_3881		; Loop if cx > 0

		pop	es
		pop	bx
		pop	dx
		pop	cx
		pop	ax
		pop	di
		pop	si
		retn
sub_383F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3895	proc	near
loc_3895:
		push	si
		push	di
		push	ax
		push	cx
		push	dx
		push	bx
		push	es
;*		mov	bx,cx
		db	 89h,0CBh		;  Fixup - byte match
		mov	cl,4
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		mov	ah,0
		shl	ax,cl			; Shift w/zeros fill
		add	ax,63C2h
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		jmp	short loc_3867
sub_3895	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_38AD	proc	near
		mov	di,0EF73h
		mov	si,0F683h
		mov	bh,0Ah
		mov	bl,0
		jmp	short loc_38C2

;==== External Entry into Subroutine ======================================

sub_38B9:
		mov	di,offset data_EDE3
		mov	si,data_F4F3_e
		mov	bx,0
loc_38C2:
		mov	al,[di]
		cld				; Clear direction
		cmpsb				; Cmp [si] to es:[di]
		jz	loc_38D1		; Jump if zero
		mov	ah,0
		push	si
		push	di
		call	sub_383F
		pop	di
		pop	si
loc_38D1:
		inc	bl
		cmp	bl,28h			; '('
		jne	loc_38C2		; Jump if not equal
		mov	bl,0
		inc	bh
		cmp	bh,14h
		jne	loc_38C2		; Jump if not equal
		mov	byte ptr ds:data_F47F_e,1
		call	sub_38EA
		retn
sub_38AD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_38EA	proc	near
		cmp	byte ptr ds:data_F11C_e,6
		jb	loc_3937		; Jump if below
		cmp	byte ptr ds:data_F11C_e,0Bh
		jb	loc_392B		; Jump if below
		cmp	byte ptr ds:data_F11C_e,0Eh
		jb	loc_3937		; Jump if below
		cmp	byte ptr ds:data_F11C_e,16h
		jb	loc_392B		; Jump if below
		cmp	byte ptr ds:data_F11C_e,2Dh	; '-'
		jb	loc_3937		; Jump if below
		cmp	byte ptr ds:data_F11C_e,3Ch	; '<'
		jb	loc_392B		; Jump if below
		cmp	byte ptr ds:data_F11C_e,3Ch	; '<'
		je	loc_3937		; Jump if equal
		cmp	byte ptr ds:data_F11C_e,42h	; 'B'
		je	loc_3937		; Jump if equal
		cmp	byte ptr ds:data_F11C_e,44h	; 'D'
		jb	loc_392B		; Jump if below
		jmp	short loc_3937
loc_392B:
		cmp	byte ptr cs:data_3943,0
		jne	loc_ret_3936		; Jump if not equal
		jmp	loc_3790

loc_ret_3936:
		retn
loc_3937:
		cmp	byte ptr cs:data_3943,1
		jne	loc_ret_3942		; Jump if not equal
		jmp	loc_3782

loc_ret_3942:
		retn
sub_38EA	endp

data_3943	db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3944	proc	near
		mov	si,data_F1CF_e
loc_3947:
		test	byte ptr [si],80h
		jz	loc_394F		; Jump if zero
		call	sub_3969
loc_394F:
		mov	dx,29h
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		cmp	byte ptr [si],0FFh
		jne	loc_3947		; Jump if not equal
		retn
sub_3944	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_395A	proc	near
		mov	ax,28h
		mul	ch			; ax = reg * al
		mov	ch,0
;*		add	ax,cx
		db	 01h,0C8h		;  Fixup - byte match
		mov	bx,0EDE3h
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		retn
sub_395A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3969	proc	near
		mov	cx,[si+1Ah]
		shr	cl,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		call	sub_395A
		mov	cx,[si+1Eh]
		shr	cl,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		inc	ch
		inc	ch
		inc	cl
		inc	cl
		mov	dx,28h
		mov	ah,0FFh
loc_398D:
		push	cx
		push	bx
loc_398F:
		mov	[bx],ah
		inc	bx
		dec	cl
		jnz	loc_398F		; Jump if not zero
		mov	cx,0F0DBh
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
		jnc	loc_39A6		; Jump if carry=0
		pop	bx
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_398D		; Jump if not zero
		retn
loc_39A6:
		pop	bx
		pop	cx
		retn
sub_3969	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_39A9	proc	near
loc_39A9:
		push	si
		mov	di,data_F17B_e+1
loc_39AD:
		call	sub_39EE
		jz	loc_39CB		; Jump if zero
		test	byte ptr [si],4
		jz	loc_39C6		; Jump if zero
		test	byte ptr [si],10h
		jz	loc_39AD		; Jump if zero
		call	sub_3F1D
		dec	di
		dec	di
		mov	byte ptr [si],0
		jmp	short loc_39AD
loc_39C6:
		call	sub_39FE
		jmp	short loc_39AD
loc_39CB:
		call	sub_39EE
		jz	loc_39E7		; Jump if zero
		test	byte ptr [si],4
		jnz	loc_39CB		; Jump if not zero
		test	byte ptr [si+1],1
		jnz	loc_39DE		; Jump if not zero
		call	sub_3BA2
loc_39DE:
		and	byte ptr [si+1],0FEh
		and	byte ptr [si],0BFh
		jmp	short loc_39CB
loc_39E7:
		pop	si
		mov	byte ptr ds:data_F47F_e,1
		retn
sub_39A9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_39EE	proc	near
		mov	al,[di]
		or	al,[di+1]
		jnz	loc_39F9		; Jump if not zero
		mov	di,data_F17B_e+1
		retn
loc_39F9:
		mov	si,[di]
		inc	di
		inc	di
		retn
sub_39EE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_39FE	proc	near
		test	byte ptr [si],40h	; '@'
		jz	loc_3A08		; Jump if zero
		call	sub_3EF4
		jmp	short loc_3A2A
loc_3A08:
		mov	cx,[si+1Eh]
		mov	ds:data_F166_e,cx
		mov	cx,[si+1Ah]
		mov	ds:data_F164_e,cx
		mov	ah,[si+1]
		mov	ds:data_F17A_e,ah
		and	byte ptr [si+1],0FDh
		and	byte ptr [si+1],0FBh
		test	byte ptr [si],20h	; ' '
		jnz	loc_3A7B		; Jump if not zero
loc_3A2A:
		call	sub_3B61
		mov	dx,[si+0Bh]
		test	dh,80h
		jz	loc_3A62		; Jump if zero
		mov	byte ptr [si+1Ah],0
		mov	bx,0
;*		sub	bx,dx
		db	 29h,0D3h		;  Fixup - byte match
		call	sub_3B8A
		jnc	loc_3A46		; Jump if carry=0
		jmp	loc_3B58
loc_3A46:
		mov	ah,[si+1Eh]
;*		sub	ah,cl
		db	 28h,0CCh		;  Fixup - byte match
		jnc	loc_3A50		; Jump if carry=0
		jmp	loc_3B58
loc_3A50:
		jnz	loc_3A55		; Jump if not zero
		jmp	loc_3B58
loc_3A55:
		mov	[si+1Eh],ah
		mov	ah,[si+1Ch]
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
		mov	[si+1Ch],ah
		jmp	short loc_3A7B
loc_3A62:
		xchg	dx,bx
		call	sub_3B8A
		jnc	loc_3A6C		; Jump if carry=0
		jmp	loc_3B58
loc_3A6C:
		mov	[si+1Ah],cl
		mov	ah,50h			; 'P'
;*		sub	ah,cl
		db	 28h,0CCh		;  Fixup - byte match
		cmp	ah,[si+1Eh]
		jae	loc_3A7B		; Jump if above or =
		mov	[si+1Eh],ah
loc_3A7B:
		mov	dx,[si+0Dh]
		test	dh,80h
		jz	loc_3AB0		; Jump if zero
		mov	byte ptr [si+1Bh],0
		mov	bx,0
;*		sub	bx,dx
		db	 29h,0D3h		;  Fixup - byte match
		call	sub_3B95
		jnc	loc_3A94		; Jump if carry=0
		jmp	loc_3B58
loc_3A94:
		mov	ah,[si+1Fh]
;*		sub	ah,cl
		db	 28h,0CCh		;  Fixup - byte match
		jnc	loc_3A9E		; Jump if carry=0
		jmp	loc_3B58
loc_3A9E:
		jnz	loc_3AA3		; Jump if not zero
		jmp	loc_3B58
loc_3AA3:
		mov	[si+1Fh],ah
		mov	ah,[si+1Dh]
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
		mov	[si+1Dh],ah
		jmp	short loc_3AC9
loc_3AB0:
		xchg	dx,bx
		call	sub_3B95
		jnc	loc_3ABA		; Jump if carry=0
		jmp	loc_3B58
loc_3ABA:
		mov	[si+1Bh],cl
		mov	ah,0A0h
;*		sub	ah,cl
		db	 28h,0CCh		;  Fixup - byte match
		cmp	ah,[si+1Fh]
		jae	loc_3AC9		; Jump if above or =
		mov	[si+1Fh],ah
loc_3AC9:
		test	byte ptr [si],40h	; '@'
		jnz	loc_3ADF		; Jump if not zero
		mov	ah,ds:data_F17A_e
		test	ah,4
		jz	loc_3AFE		; Jump if zero
		test	byte ptr [si],20h	; ' '
		jz	loc_3ADF		; Jump if zero
		jmpn	loc_3B58
loc_3ADF:
		mov	ah,[si+1Ah]
		mov	[si+16h],ah
		add	ah,[si+1Eh]
		mov	[si+17h],ah
		mov	ah,[si+1Bh]
		mov	[si+18h],ah
		mov	al,[si+1Fh]
		shr	al,1			; Shift w/zeros fill
		inc	al
;*		add	ah,al
		db	 00h,0C4h		;  Fixup - byte match
		mov	[si+19h],ah
		retn
loc_3AFE:
		mov	cx,ds:data_F164_e
		mov	ah,[si+1Ah]
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jc	loc_3B0E		; Jump if carry Set
		mov	[si+16h],cl
		jmp	short loc_3B11
loc_3B0E:
		mov	[si+16h],ah
loc_3B11:
		mov	ah,[si+1Bh]
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_3B1D		; Jump if carry Set
		mov	[si+18h],ch
		jmp	short loc_3B20
loc_3B1D:
		mov	[si+18h],ah
loc_3B20:
		add	cl,ds:data_F166_e
		mov	ah,byte ptr ds:data_F166_e+1
		shr	ah,1			; Shift w/zeros fill
		inc	ah
;*		add	ch,ah
		db	 00h,0E5h		;  Fixup - byte match
		mov	ah,[si+1Ah]
		add	ah,[si+1Eh]
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jc	loc_3B3D		; Jump if carry Set
		mov	[si+17h],ah
		jmp	short loc_3B40
loc_3B3D:
		mov	[si+17h],cl
loc_3B40:
		mov	ah,[si+1Bh]
		mov	al,[si+1Fh]
		shr	al,1			; Shift w/zeros fill
		inc	al
;*		add	ah,al
		db	 00h,0C4h		;  Fixup - byte match
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_3B54		; Jump if carry Set
		mov	[si+19h],ah
		retn
loc_3B54:
		mov	[si+19h],ch
		retn
loc_3B58:
		or	byte ptr [si+1],2
		or	byte ptr [si+1],4
		retn
sub_39FE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3B61	proc	near
		mov	bx,offset data_CC5E
		mov	ch,0
		mov	cl,[si+0Fh]
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	dx,[bx]
		xchg	dx,bx
		mov	cl,[si+10h]
;*		add	cx,cx
		db	 01h,0C9h		;  Fixup - byte match
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	dx,[bx]
		xchg	dx,bx
		mov	[si+26h],bx
		mov	dx,[bx]
		mov	[si+1Eh],dx
		mov	word ptr [si+1Ch],0
		retn
sub_3B61	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3B8A	proc	near
		mov	ah,27h			; '''
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jc	loc_ret_3B94		; Jump if carry Set
		rcl	bx,1			; Rotate thru carry
;*		mov	cl,bh
		db	 88h,0F9h		;  Fixup - byte match

loc_ret_3B94:
		retn
sub_3B8A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3B95	proc	near
		mov	ah,13h
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jc	loc_ret_3B94		; Jump if carry Set
		rcl	bx,1			; Rotate thru carry
		rcl	bx,1			; Rotate thru carry
;*		mov	cl,bh
		db	 88h,0F9h		;  Fixup - byte match
		retn
sub_3B95	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3BA2	proc	near
		call	sub_3C10
		mov	byte ptr ds:data_F168_e,1
		mov	ah,[si+16h]
		mov	ds:data_F169_e,ah
		mov	ah,[si+17h]
		mov	byte ptr ds:data_F169_e+1,ah
		mov	ah,[si+18h]
		mov	ds:data_F16B_e,ah
		mov	ah,[si+19h]
		mov	byte ptr ds:data_F16B_e+1,ah
		or	byte ptr [si],8
		call	sub_3BF6
loc_3BCC:
		push	si
		push	di
		mov	byte ptr ds:data_F16D_e,0
loc_3BD3:
		call	sub_39EE
		jz	loc_3BE3		; Jump if zero
		test	byte ptr [si+1],1
		jnz	loc_3BD3		; Jump if not zero
		call	sub_3C19
		jmp	short loc_3BD3
loc_3BE3:
		pop	di
		mov	ah,ds:data_F16D_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_3BEF		; Jump if zero
		pop	si
		jmp	short loc_3BCC
loc_3BEF:
		pop	si
		push	si
		call	sub_3CB6
		pop	si
		retn
sub_3BA2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3BF6	proc	near
		mov	bx,ds:data_F14A_e
		mov	[bx],si
		inc	bx
		inc	bx
		mov	ds:data_F14A_e,bx
		retn
sub_3BF6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3C03	proc	near
		mov	bx,ds:data_F14A_e
		mov	si,[bx]
		inc	bx
		inc	bx
		mov	ds:data_F14A_e,bx
		retn
sub_3C03	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3C10	proc	near
		mov	bx,ds:data_F14C_e
		mov	ds:data_F14A_e,bx
		retn
sub_3C10	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3C19	proc	near
		mov	bh,[si+16h]
		mov	bl,[si+17h]
		mov	dh,ds:data_F169_e
		mov	dl,byte ptr ds:data_F169_e+1
		call	sub_3CAA
		jc	loc_3C2F		; Jump if carry Set
		jmpn	loc_ret_3C9B
loc_3C2F:
		mov	bh,[si+18h]
		mov	bl,[si+19h]
		mov	dh,ds:data_F16B_e
		mov	dl,byte ptr ds:data_F16B_e+1
		call	sub_3CAA
		jnc	loc_ret_3C9B		; Jump if carry=0
		mov	ch,[si+16h]
		mov	ah,ds:data_F169_e
		call	sub_3CA3
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	ch,[si+17h]
		mov	ah,byte ptr ds:data_F169_e+1
		call	sub_3C9C
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
;*		sub	ah,dl
		db	 28h,0D4h		;  Fixup - byte match
		cmp	ah,3Eh			; '>'
		jae	loc_ret_3C9B		; Jump if above or =
		mov	ch,[si+18h]
		mov	ah,ds:data_F16B_e
		call	sub_3CA3
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	ch,[si+19h]
		mov	ah,byte ptr ds:data_F16B_e+1
		call	sub_3C9C
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
;*		sub	ah,bl
		db	 28h,0DCh		;  Fixup - byte match
		cmp	ah,80h
		jae	loc_ret_3C9B		; Jump if above or =
		mov	ds:data_F169_e,dx
		mov	ds:data_F16B_e,bx
		call	sub_3BF6
		mov	byte ptr ds:data_F16D_e,1
		or	byte ptr [si+1],1
		or	byte ptr [si],8
		inc	byte ptr ds:data_F168_e

loc_ret_3C9B:
		retn
sub_3C19	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3C9C	proc	near
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_ret_3CA2		; Jump if carry=0
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match

loc_ret_3CA2:
		retn
sub_3C9C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3CA3	proc	near
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_ret_3CA2		; Jump if carry Set
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		retn
sub_3CA3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3CAA	proc	near
loc_3CAA:
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
;*		cmp	ah,bh
		db	 38h,0FCh		;  Fixup - byte match
		jc	loc_3CB4		; Jump if carry Set
;*		mov	ah,bl
		db	 88h,0DCh		;  Fixup - byte match
;*		cmp	ah,dh
		db	 38h,0F4h		;  Fixup - byte match
loc_3CB4:
		cmc				; Complement carry
		retn
sub_3CAA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3CB6	proc	near
		mov	ah,ds:data_F47F_e
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_3CDC		; Jump if not zero
		mov	ah,ds:data_F168_e
		cmp	ah,1
		jne	loc_3CDC		; Jump if not equal
		mov	bx,data_F14C_e
		mov	dx,[bx]
		xchg	dx,bx
		inc	bx
		test	byte ptr [bx],4
		jz	loc_3CDC		; Jump if zero
		test	byte ptr [bx],2
		jz	loc_3CDC		; Jump if zero
		jmp	loc_3EF4
loc_3CDC:
		mov	cl,ds:data_F169_e
		shr	cl,1			; Shift w/zeros fill
		mov	ch,ds:data_F16B_e
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		mov	ds:data_F174_e,cx
		mov	dl,byte ptr ds:data_F169_e+1
		test	dl,1
		jz	loc_3CFA		; Jump if zero
		add	dl,2
loc_3CFA:
		shr	dl,1			; Shift w/zeros fill
;*		sub	dl,cl
		db	 28h,0CAh		;  Fixup - byte match
		mov	dh,byte ptr ds:data_F16B_e+1
		test	dh,3
		jz	loc_3D0A		; Jump if zero
		add	dh,4
loc_3D0A:
		shr	dh,1			; Shift w/zeros fill
		shr	dh,1			; Shift w/zeros fill
;*		sub	dh,ch
		db	 28h,0EEh		;  Fixup - byte match
		mov	ds:data_F176_e,dx
		mov	ch,byte ptr ds:data_F174_e+1
;*		add	ch,dh
		db	 00h,0F5h		;  Fixup - byte match
		cmp	ch,14h
		jb	loc_3D28		; Jump if below
		sub	ch,14h
;*		sub	dh,ch
		db	 28h,0EEh		;  Fixup - byte match
		mov	byte ptr ds:data_F176_e+1,dh
loc_3D28:
		mov	cx,ds:data_F174_e
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
;*		add	ch,ch
		db	 00h,0EDh		;  Fixup - byte match
;*		add	ch,ch
		db	 00h,0EDh		;  Fixup - byte match
		mov	ds:data_F16E_e,cx
		mov	cx,ds:data_F176_e
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
;*		add	ch,ch
		db	 00h,0EDh		;  Fixup - byte match
;*		add	ch,ch
		db	 00h,0EDh		;  Fixup - byte match
		mov	ds:data_F170_e,cx
		mov	dx,ds:data_F176_e
;*		mov	al,dl
		db	 88h,0D0h		;  Fixup - byte match
		mov	ah,0
		mul	dh			; ax = reg * al
		mov	cl,8
		mul	cl			; ax = reg * al
;*		mov	cx,ax
		db	 89h,0C1h		;  Fixup - byte match
		push	si
		push	di
		mov	si,data_F4F3_e
		mov	di,data_F4F5_e
		mov	word ptr [si],0
		cld				; Clear direction
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	ax,ds:data_F170_e
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
		mov	ds:data_F142_e,ax
		mov	dx,ds:data_F174_e
		mov	ax,28h
		mul	dh			; ax = reg * al
		mov	dh,0
;*		add	ax,dx
		db	 01h,0D0h		;  Fixup - byte match
		add	ax,0EDE3h
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	dx,ds:data_F176_e
		mov	di,0F4F3h
loc_3D88:
		push	dx
		push	bx
		push	di
loc_3D8B:
		push	bx
		push	dx
		mov	al,[bx]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_3D98		; Jump if zero
		mov	ah,0
		call	sub_3E31
loc_3D98:
		inc	di
		inc	di
		pop	dx
		pop	bx
		inc	bx
		dec	dl
		jnz	loc_3D8B		; Jump if not zero
		pop	di
		mov	dx,ds:data_F142_e
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		pop	bx
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		pop	dx
		dec	dh
		jnz	loc_3D88		; Jump if not zero
		pop	di
		pop	si
		call	sub_3C10
		mov	ds:data_F148_e,di
		mov	ah,ds:data_F168_e
		push	si
loc_3DC1:
		push	ax
		call	sub_3C03
		test	byte ptr [si],10h
		jz	loc_3DCF		; Jump if zero
		call	sub_3F08
		jmp	short loc_3DE5
loc_3DCF:
		test	byte ptr [si+1],2
		jnz	loc_3DDA		; Jump if not zero
		test	byte ptr [si],20h	; ' '
		jz	loc_3DDF		; Jump if zero
loc_3DDA:
		call	sub_3EF4
		jmp	short loc_3DE5
loc_3DDF:
		call	sub_3E4E
		call	sub_3EF4
loc_3DE5:
		pop	ax
		dec	ah
		jnz	loc_3DC1		; Jump if not zero
		pop	si
		mov	di,ds:data_F148_e
		push	si
		push	di
		push	es
		mov	dx,0B800h
		mov	es,dx
		mov	dx,ds:data_F16E_e
		mov	ax,50h
		mul	dh			; ax = reg * al
		mov	dh,0
;*		add	ax,dx
		db	 01h,0D0h		;  Fixup - byte match
;*		mov	di,ax
		db	 89h,0C7h		;  Fixup - byte match
		mov	si,data_F4F3_e
		mov	cx,ds:data_F176_e
		shl	ch,1			; Shift w/zeros fill
		shl	ch,1			; Shift w/zeros fill
loc_3E11:
		push	cx
		mov	ch,0
		push	di
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		add	di,d_B800_2000_e
		pop	cx
		push	cx
		mov	ch,0
		push	di
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		sub	di,1FB0h
		pop	cx
		dec	ch
		jnz	loc_3E11		; Jump if not zero
		pop	es
		pop	di
		pop	si
		retn

;==== External Entry into Subroutine ======================================

sub_3E31:
		push	di
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		add	ax,63C2h
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	dx,ds:data_F170_e
		mov	dh,0
		dec	dx
		dec	dx
		cld				; Clear direction
		mov	cx,8

locloop_3E47:
		movsw				; Mov [si] to es:[di]
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		loop	locloop_3E47		; Loop if cx > 0

		pop	di
		retn

;==== External Entry into Subroutine ======================================

sub_3E4E:
		push	si
		push	di
		mov	bx,[si+26h]
		mov	dl,[bx]
		mov	ds:data_F146_e,dl
		inc	bx
		inc	bx
		mov	al,[si+1Ch]
		mov	ah,0
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		mov	al,[si+1Dh]
		mul	dl			; ax = reg * al
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		mov	ds:data_F144_e,bx
		mov	ah,0
		mov	di,0F4F3h
		mov	cx,ds:data_F16E_e
		mov	dx,[si+1Ah]
;*		mov	al,dl
		db	 88h,0D0h		;  Fixup - byte match
;*		sub	al,cl
		db	 28h,0C8h		;  Fixup - byte match
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
;*		mov	al,dh
		db	 88h,0F0h		;  Fixup - byte match
;*		sub	al,ch
		db	 28h,0E8h		;  Fixup - byte match
		mov	cl,ds:data_F170_e
		mul	cl			; ax = reg * al
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		mov	cx,[si+1Eh]
		mov	si,ds:data_F144_e
		mov	bl,ds:data_F170_e
		mov	bh,0
		mov	dl,ds:data_F146_e
		mov	dh,0
		cld				; Clear direction
loc_3EA1:
		push	cx
		push	si
		push	di
		mov	ch,0
		call	sub_3EB7
		pop	di
;*		add	di,bx
		db	 01h,0DFh		;  Fixup - byte match
		pop	si
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_3EA1		; Jump if not zero
		pop	di
		pop	si
		retn

;==== External Entry into Subroutine ======================================

sub_3EB7:

locloop_3EB7:
		mov	al,[si]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_3EDD		; Jump if zero
		test	al,3
		jz	loc_3EC3		; Jump if zero
		or	al,3
loc_3EC3:
		test	al,0Ch
		jz	loc_3EC9		; Jump if zero
		or	al,0Ch
loc_3EC9:
		test	al,30h			; '0'
		jz	loc_3ECF		; Jump if zero
		or	al,30h			; '0'
loc_3ECF:
		test	al,0C0h
		jz	loc_3ED5		; Jump if zero
		or	al,0C0h
loc_3ED5:
		xor	al,0FFh
		and	al,[di]
		or	al,[si]
		mov	[di],al
loc_3EDD:
		inc	di
		inc	si
		loop	locloop_3EB7		; Loop if cx > 0

		retn
			                        ;* No entry point to code
		push	si
		push	di
		add	si,3
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		mov	cx,8
;*		add	di,cx
		db	 01h,0CFh		;  Fixup - byte match
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		pop	si
		retn

;==== External Entry into Subroutine ======================================

sub_3EF4:
loc_3EF4:
		push	si
		push	di
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		add	di,3
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		mov	cx,8
;*		add	si,cx
		db	 01h,0CEh		;  Fixup - byte match
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		pop	si
		retn
sub_3CB6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3F08	proc	near
		mov	byte ptr [si],0
		call	sub_3F1D
		mov	cx,ds:data_F148_e
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
		jnc	loc_ret_3F1C		; Jump if carry=0
		dec	cx
		dec	cx
		mov	ds:data_F148_e,cx

loc_ret_3F1C:
		retn
sub_3F08	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3F1D	proc	near
;*		mov	dx,si
		db	 89h,0F2h		;  Fixup - byte match
		mov	ch,ds:data_F17B_e
		mov	bx,data_F17B_e+1
loc_3F26:
		mov	ax,[bx]
;*		cmp	ax,dx
		db	 39h,0D0h		;  Fixup - byte match
		jz	loc_3F33		; Jump if zero
		inc	bx
		inc	bx
		dec	ch
		jnz	loc_3F26		; Jump if not zero
		retn
loc_3F33:
		dec	ch
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		jz	loc_3F54		; Jump if zero
		push	bx
;*		mov	dx,bx
		db	 89h,0DAh		;  Fixup - byte match
		inc	dx
		inc	dx
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0
		inc	cx
		xchg	si,dx
		xchg	di,bx
		cld				; Clear direction
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,dx
		xchg	di,bx
loc_3F4E:
		dec	byte ptr ds:data_F17B_e
		pop	bx
		retn
loc_3F54:
		push	bx
		mov	word ptr [bx],0
		jmp	short loc_3F4E
sub_3F1D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3F5B	proc	near
loc_3F5B:
		push	si
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_3F62		; Jump if not zero
		inc	ah
loc_3F62:
		mov	[si+25h],ah
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,ds:data_F17B_e
		mov	di,data_F17B_e+1
loc_3F6E:
		mov	ax,[di]
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jz	loc_3FAC		; Jump if zero
		mov	bx,[di]
		push	bx
		pop	si
		mov	al,[si+25h]
;*		cmp	al,cl
		db	 38h,0C8h		;  Fixup - byte match
		jnc	loc_3F85		; Jump if carry=0
		inc	di
		inc	di
		dec	ch
		jmp	short loc_3F6E
loc_3F85:
		push	bx
;*		mov	cl,ch
		db	 88h,0E9h		;  Fixup - byte match
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
		mov	ch,0
		push	di
		pop	bx
		inc	cx
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		push	bx
		pop	dx
		inc	dx
		inc	dx
		inc	cx
		xchg	si,bx
		xchg	di,dx
		std				; Set direction flag
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	cx
loc_3FA2:
		pop	si
		push	si
		pop	bx
		mov	[di],bx
		inc	byte ptr ds:data_F17B_e
		retn
loc_3FAC:
		mov	word ptr [di+2],0
		jmp	short loc_3FA2
sub_3F5B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3FB3	proc	near
		push	di
		push	ax
		call	sub_3FCB
		jc	loc_3FC7		; Jump if carry Set
		pop	ax
		call	sub_3F5B
		or	byte ptr [si],80h
		or	byte ptr [si],40h	; '@'
		pop	di
		clc				; Clear carry flag
		retn
loc_3FC7:
		pop	ax
		pop	di
		stc				; Set carry flag
		retn
sub_3FB3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3FCB	proc	near
		mov	ch,0Ch
		mov	dx,29h
		mov	si,data_F1CF_e
loc_3FD3:
		test	byte ptr [si],80h
		jz	loc_3FE0		; Jump if zero
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_3FD3		; Jump if not zero
		stc				; Set carry flag
		retn
loc_3FE0:
		push	si
		push	di
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		inc	di
		mov	cx,28h
		mov	byte ptr [si],0
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	di
		pop	si
		clc				; Clear carry flag
		retn
sub_3FCB	endp

			                        ;* No entry point to code
		mov	si,data_F1CF_e
		mov	di,data_F1D0_e
		mov	cx,1EBh
		mov	byte ptr [si],0
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		inc	si
		mov	byte ptr [si],0FFh
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		mov	ds:data_F17B_e,al
		mov	si,0F1CFh
		mov	di,data_F17B_e+1
		mov	[di],ax
		retn
			                        ;* No entry point to code
		push	dx
		push	bx
		call	sub_3FB3
		pop	bx
		jc	loc_403B		; Jump if carry Set
		pop	dx
		push	dx
		push	si
;*		mov	di,bx
		db	 89h,0DFh		;  Fixup - byte match
		mov	ah,0
loc_4022:
;*		mov	bx,dx
		db	 89h,0D3h		;  Fixup - byte match
		mov	al,[bx]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_4034		; Jump if zero
		inc	dx
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,[di]
		mov	[bx+si],al
		inc	di
		jmp	short loc_4022
loc_4034:
		pop	si
		call	sub_3EF4
		clc				; Clear carry flag
;*		mov	bx,di
		db	 89h,0FBh		;  Fixup - byte match
loc_403B:
		pop	dx
		retn
			                        ;* No entry point to code
		push	ax
		call	sub_3F1D
		pop	ax
		call	sub_3F5B
		retn
		db	'AQUI HAY QUE POKEAR'

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_4059	proc	near
		mov	ah,cs:data_413B
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		nop
		nop
		jz	loc_ret_408E		; Jump if zero
		test	byte ptr ds:[0CE50h],80h
		jz	loc_4075		; Jump if zero
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,40h			; '@'
		mov	ds:data_F115_e,ah
		retn
loc_4075:
		mov	ah,cs:data_413C
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_408F		; Jump if zero
		dec	ah
		mov	cs:data_413C,ah
		mov	ah,cs:data_413D
		mov	ds:data_F115_e,ah

loc_ret_408E:
		retn
loc_408F:
		mov	bx,cs:data_413E
		mov	ah,[bx]
		dec	ah
		mov	cs:data_413C,ah
		inc	bx
		mov	ah,[bx]
		mov	cs:data_413D,ah
		inc	bx
		mov	cs:data_413E,bx
		mov	ds:data_F115_e,ah
		retn
sub_4059	endp

			                        ;* No entry point to code
		mov	ah,ds:data_F115_e
		mov	bx,offset data_413D
		cmp	ah,[bx]
		je	loc_4123		; Jump if equal
loc_40BB:
		mov	bx,cs:data_413E
		inc	bx
		inc	bx
		mov	cs:data_413E,bx
		mov	dx,4140h
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,7
		jne	loc_410D		; Jump if not equal
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,40h			; '@'
		mov	bx,cs:data_413E
		mov	byte ptr [bx],1
		inc	bx
		mov	[bx],ah
		mov	ds:data_F115_e,ah
		mov	ax,cs
		mov	es,ax
		mov	bx,100h
		mov	dl,10h
		mov	ch,0Eh
		mov	cl,1
loc_40F6:
		push	dx
		mov	ax,308h
		mov	dx,0
		int	13h			; Disk  dl=drive a  ah=func 03h
						;  write sectors from mem es:bx
						;   al=#,ch=cyl,cl=sectr,dh=head
		inc	ch
		add	bx,1000h
		pop	dx
		dec	dl
		jnz	loc_40F6		; Jump if not zero
		jmp	start
loc_410D:
		mov	ah,1
		mov	bx,cs:data_413E
		mov	[bx],ah
		mov	ah,ds:data_F115_e
		inc	bx
		mov	cs:data_413D,ah
		mov	[bx],ah
		retn
loc_4123:
		mov	bx,cs:data_413E
		mov	ah,[bx]
		inc	ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_40BB		; Jump if zero
		mov	[bx],ah
		inc	bx
		mov	ah,cs:data_413D
		mov	[bx],ah
		retn
data_413B	db	0
data_413C	db	0
data_413D	db	0
data_413E	dw	4840h
		db	 19h, 00h, 57h, 08h, 0Ah, 00h
		db	 03h, 08h, 0Ah, 00h, 02h, 04h
		db	 07h, 00h, 04h, 02h, 03h, 00h
		db	 0Ch, 10h, 18h, 00h, 05h, 02h
		db	 11h, 00h, 02h, 10h, 15h, 00h
		db	 6Eh, 04h, 0Bh, 00h, 3Ah, 08h
		db	 03h, 10h, 0Bh, 00h, 09h, 08h
		db	 04h, 00h, 05h, 10h, 0Fh, 00h
		db	 49h, 08h, 03h, 10h, 08h, 00h
		db	 21h, 08h, 06h, 00h, 02h, 04h
		db	 07h, 00h, 06h, 02h, 30h, 00h
		db	 04h, 02h, 09h, 00h, 09h, 04h
		db	 18h, 00h, 26h, 04h, 10h, 00h
		db	 1Bh, 08h, 16h, 00h, 03h, 02h
		db	 17h, 00h, 09h, 08h, 2Dh, 00h
		db	 03h, 02h, 03h, 00h, 80h, 08h
		db	 08h, 09h, 29h, 08h, 01h, 00h
		db	 23h, 04h, 01h, 0Ch, 03h, 08h
		db	 01h, 18h, 02h, 10h, 01h, 14h
		db	 33h, 04h, 09h, 10h, 3Eh, 18h
		db	 05h, 19h, 21h, 11h, 08h, 10h
		db	 07h, 00h, 03h, 10h, 4Bh, 14h
		db	 01h, 15h, 1Ch, 11h, 01h, 10h
		db	 11h, 00h, 4Fh, 08h, 02h, 00h
		db	 18h, 04h, 01h, 0Ch, 11h, 08h
		db	 5Ch, 00h, 04h, 04h, 07h, 00h
		db	 05h, 08h, 07h, 00h, 04h, 10h
		db	 07h, 00h, 27h, 08h, 01h, 0Ch
		db	 0Bh, 04h, 0Ch, 08h, 05h, 09h
		db	0B4h, 08h, 05h, 00h, 03h, 02h
		db	 1Dh, 00h, 05h, 02h, 18h, 00h
		db	 02h, 04h, 0Ch, 00h, 02h, 04h
		db	 0Ah, 00h, 02h, 08h, 25h, 00h
		db	 04h, 20h, 03h, 00h, 2Ah, 01h
		db	 01h, 00h, 04h, 08h, 18h, 00h
		db	 04h, 04h, 0Fh, 00h, 03h, 20h
		db	 1Dh, 00h, 39h, 08h, 0Fh, 09h
		db	 34h, 01h, 0Eh, 00h, 04h, 20h
		db	 13h, 00h, 27h, 08h, 01h, 18h
		db	 19h, 10h, 09h, 11h, 01h, 01h
		db	 15h, 00h, 63h, 08h, 09h, 09h
		db	 22h, 08h, 16h, 18h, 04h, 00h
		db	 11h, 08h, 08h, 09h, 09h, 08h
		db	 04h, 00h, 05h, 10h, 1Ch, 00h
		db	 13h, 10h, 1Dh, 00h, 30h, 08h
		db	 1Bh, 18h, 0Ah, 10h, 07h, 11h
		db	 15h, 00h, 05h, 10h, 1Bh, 00h
		db	 02h, 10h, 13h, 00h, 02h, 10h
		db	 20h, 00h, 04h, 08h, 04h, 09h
		db	 03h, 01h, 0Dh, 00h, 26h, 08h
		db	 05h, 09h, 1Bh, 08h, 08h, 00h
		db	 05h, 10h, 02h, 00h, 1Ah, 08h
		db	 0Bh, 00h, 04h, 10h, 0Eh, 00h
		db	 07h, 01h, 09h, 00h, 1Ch, 08h
		db	 03h, 00h, 22h, 04h, 0Ah, 10h
		db	 23h, 18h, 01h, 1Ch, 04h, 14h
		db	 06h, 10h, 06h, 11h, 01h, 10h
		db	 0Fh, 00h, 0Fh, 04h, 03h, 06h
		db	 01h, 02h, 0Ah, 00h, 03h, 08h
		db	 04h, 00h, 04h, 10h, 2Eh, 00h
		db	 03h, 02h, 04h, 00h, 0Ch, 08h
		db	 08h, 00h, 03h, 08h, 07h, 00h
		db	 07h, 01h, 0Dh, 00h, 01h, 08h
		db	 09h, 00h, 01h, 08h, 12h, 00h
		db	 02h, 02h, 1Ah, 00h, 35h, 10h
		db	 07h, 12h, 02h, 10h, 1Ah, 18h
		db	 24h, 10h, 0Ah, 14h, 04h, 15h
		db	 2Ah, 14h, 01h, 10h, 04h, 18h
		db	 07h, 10h, 05h, 11h, 02h, 10h
		db	 19h, 00h, 28h, 04h, 0Ah, 00h
		db	 07h, 08h, 06h, 09h, 0Dh, 08h
		db	 07h, 09h, 08h, 08h, 03h, 00h
		db	 18h, 04h, 05h, 08h, 09h, 09h
		db	 17h, 08h, 09h, 18h, 07h, 10h
		db	 05h, 18h, 0Ah, 10h, 03h, 14h
		db	 22h, 10h, 05h, 11h, 02h, 01h
		db	 1Ch, 00h, 13h, 04h, 07h, 00h
		db	 0Fh, 08h, 03h, 00h, 07h, 04h
		db	 02h, 05h, 01h, 01h, 15h, 00h
		db	 03h, 04h, 0Bh, 00h, 02h, 04h
		db	 0Bh, 00h, 02h, 04h, 10h, 00h
		db	 17h, 10h, 02h, 12h, 5Ch, 10h
		db	 02h, 16h, 2Bh, 14h, 52h, 18h
		db	 10h, 10h, 2Ah, 00h, 05h, 10h
		db	 22h, 00h, 04h, 04h, 09h, 00h
		db	 04h, 08h, 0Ah, 00h, 03h, 10h
		db	 19h, 00h, 05h, 10h, 20h, 00h
		db	 0Ch, 08h, 0Bh, 00h, 06h, 01h
		db	 34h, 00h, 0Bh, 10h, 08h, 00h
		db	 25h, 08h, 02h, 00h, 07h, 04h
		db	 0Ah, 08h, 02h, 09h, 03h, 01h
		db	 3Ah, 00h, 30h, 08h, 02h, 00h
		db	 04h, 04h, 01h, 00h, 0Ah, 08h
		db	 02h, 09h, 02h, 01h, 2Fh, 00h
		db	 02h, 04h, 09h, 00h, 0Dh, 10h
		db	 1Ah, 00h, 0Fh, 08h, 09h, 00h
		db	 06h, 04h, 07h, 05h, 24h, 04h
		db	 10h, 00h, 02h, 08h, 0Ch, 00h
		db	 01h, 08h, 0Fh, 00h, 07h, 20h
		db	 19h, 00h, 06h, 04h, 07h, 00h
		db	 01h, 08h, 19h, 00h, 02h, 20h
		db	 03h, 00h, 2Eh, 01h, 02h, 05h
		db	 18h, 04h, 15h, 08h, 31h, 02h
		db	 01h, 06h, 04h, 04h, 18h, 00h
		db	 04h, 20h, 25h, 00h, 08h, 04h
		db	 0Ah, 00h, 03h, 08h, 01h, 09h
		db	 05h, 01h, 17h, 00h, 0Bh, 08h
		db	 0Bh, 00h, 11h, 04h, 0Ah, 00h
		db	 10h, 10h, 0Dh, 14h, 04h, 18h
		db	 14h, 00h, 03h, 10h, 13h, 00h
		db	 17h, 08h, 05h, 10h, 3Ah, 00h
		db	 0Ah, 08h, 34h, 00h, 08h, 04h
		db	 03h, 05h, 01h, 04h, 1Ch, 00h
		db	 06h, 08h, 1Ah, 00h, 03h, 10h
		db	 10h, 00h, 0Bh, 08h, 02h, 18h
		db	 03h, 10h, 04h, 00h, 6Fh, 08h
		db	 01h, 00h, 02h, 10h, 04h, 00h
		db	 2Dh, 08h, 3Ah, 00h, 16h, 08h
		db	 03h, 10h, 0Eh, 00h, 09h, 08h
		db	 01h, 18h, 1Bh, 10h, 04h, 11h
		db	 02h, 01h, 0Fh, 00h, 60h, 08h
		db	 03h, 09h, 1Ah, 00h, 17h, 10h
		db	 0Fh, 00h, 17h, 08h, 07h, 09h
		db	 16h, 08h, 17h, 00h, 1Bh, 08h
		db	 06h, 09h, 13h, 08h, 01h, 18h
		db	 03h, 10h, 12h, 00h, 1Fh, 08h
		db	 04h, 00h, 10h, 10h, 0Fh, 18h
		db	 0Fh, 10h, 0Ah, 14h, 0Bh, 10h
		db	 05h, 11h, 02h, 01h, 24h, 00h
		db	 11h, 04h, 04h, 10h, 18h, 00h
		db	 05h, 10h, 0Fh, 00h, 0Ah, 04h
		db	 2Ah, 00h, 05h, 04h, 07h, 00h
		db	 01h, 08h, 1Ch, 00h, 05h, 20h
		db	 02h, 00h, 29h, 01h, 02h, 08h
		db	 21h, 00h, 06h, 20h, 13h, 00h
		db	 1Dh, 08h, 06h, 10h, 20h, 00h
		db	 17h, 10h, 03h, 11h, 02h, 01h
		db	 17h, 00h, 0Ah, 08h, 02h, 00h
		db	 06h, 10h, 09h, 14h, 0Dh, 10h
		db	 02h, 18h, 0Bh, 10h, 04h, 11h
		db	 02h, 01h, 28h, 00h, 02h, 10h
		db	 29h, 00h, 03h, 02h, 11h, 00h
		db	 04h, 08h, 04h, 00h, 0Bh, 08h
		db	 0Bh, 00h, 15h, 08h, 1Eh, 00h
		db	 23h, 10h, 04h, 12h, 13h, 10h
		db	 01h, 12h, 05h, 10h, 04h, 12h
		db	 01h, 02h, 19h, 00h, 10h, 04h
		db	 10h, 00h, 22h, 10h, 0Dh, 00h
		db	 0Ah, 02h, 25h, 00h, 1Ah, 08h
		db	 01h, 1Ch, 04h, 14h, 07h, 10h
		db	 05h, 11h, 19h, 00h, 09h, 10h
		db	 09h, 11h, 01h, 10h, 18h, 00h
		db	 18h, 08h, 06h, 00h, 05h, 08h
		db	 0Ah, 00h, 05h, 10h, 09h, 14h
		db	 08h, 10h, 04h, 11h, 40h, 00h
		db	 05h, 02h, 01h, 06h, 13h, 04h
		db	 04h, 05h, 0Eh, 04h, 07h, 00h
		db	 03h, 08h, 03h, 00h, 02h, 10h
		db	 08h, 00h, 09h, 08h, 01h, 00h
		db	 09h, 04h, 03h, 05h, 0Bh, 04h
		db	 0Fh, 00h, 02h, 02h, 05h, 00h
		db	 06h, 10h, 04h, 18h, 02h, 10h
		db	 30h, 00h, 05h, 02h, 06h, 00h
		db	 04h, 08h, 08h, 00h, 04h, 02h
		db	 04h, 00h, 08h, 04h, 06h, 00h
		db	 07h, 04h, 0Ah, 00h, 02h, 08h
		db	 11h, 00h, 04h, 02h, 07h, 00h
		db	 06h, 04h, 0Ah, 00h, 12h, 08h
		db	 04h, 09h, 27h, 08h, 19h, 00h
		db	 0Ah, 04h, 08h, 00h, 06h, 10h
		db	 25h, 00h, 09h, 10h, 20h, 00h
		db	 05h, 08h, 07h, 00h, 0Bh, 04h
		db	 02h, 05h, 37h, 04h, 0Ah, 10h
		db	 0Ah, 14h, 16h, 00h, 08h, 01h
		db	 65h, 00h, 1Ah, 04h, 13h, 00h
		db	 03h, 10h, 05h, 18h, 04h, 10h
		db	 13h, 18h, 01h, 08h, 0Fh, 00h
		db	 0Dh, 08h, 01h, 00h, 02h, 10h
		db	 16h, 00h, 07h, 08h, 23h, 00h
		db	 31h, 04h, 04h, 05h, 05h, 04h
		db	 39h, 00h, 0Eh, 04h, 26h, 00h
		db	 05h, 20h, 02h, 00h, 1Dh, 01h
		db	 06h, 04h, 15h, 00h, 04h, 20h
		db	 03h, 00h, 0Fh, 08h, 26h, 00h
		db	 03h, 04h, 1Ch, 00h, 03h, 20h
		db	 0Ah, 00h, 06h, 01h, 13h, 00h
		db	 0Dh, 02h, 06h, 00h, 1Dh, 01h
		db	 01h, 05h, 04h, 04h, 15h, 00h
		db	 02h, 20h, 0Ch, 00h, 18h, 04h
		db	 72h, 00h, 22h, 08h, 02h, 00h
		db	 03h, 04h, 01h, 00h, 04h, 10h
		db	 20h, 00h, 04h, 02h, 07h, 00h
		db	 03h, 04h, 06h, 00h, 04h, 08h
		db	 1Ah, 00h, 03h, 20h, 15h, 00h
		db	 05h, 20h, 0Dh, 00h, 02h, 08h
		db	 19h, 00h, 02h, 20h, 03h, 00h
		db	 33h, 01h, 01h, 00h, 02h, 08h
		db	 1Ah, 00h, 03h, 20h, 1Fh, 00h
		db	 03h, 04h, 1Ah, 00h, 02h, 20h
		db	 12h, 00h, 10h, 08h, 0Fh, 00h
		db	 06h, 10h, 1Fh, 00h, 12h, 08h
		db	 0Ch, 00h, 08h, 04h, 07h, 00h
		db	 03h, 08h, 01h, 09h, 04h, 01h
		db	 25h, 00h, 03h, 20h, 0Ah, 00h
		db	 2Dh, 01h, 1Ch
		db	8
data_460C	dw	7
		db	 1Ch, 04h, 0Dh, 00h, 04h, 04h
		db	 0Ch, 00h, 02h, 08h, 09h, 00h
		db	 02h, 08h, 16h, 00h, 03h, 20h
		db	 31h, 00h, 0Ah, 08h, 04h, 01h
		db	 25h, 00h, 09h, 08h, 04h, 09h
		db	 09h, 08h, 0Eh, 00h, 0Dh, 08h
		db	 1Ah, 00h, 08h, 08h, 05h, 00h
		db	 05h
data_4639	db	4
		db	 06h, 00h, 0Ah, 08h, 05h, 09h
		db	 08h, 08h, 10h, 00h, 05h, 08h
		db	 19h, 00h, 08h, 08h, 02h, 09h
		db	 03h, 01h, 23h, 00h, 02h, 20h
		db	 04h, 00h, 27h, 01h, 02h, 08h
		db	 18h, 00h, 02h, 20h, 11h, 00h
		db	 0Fh, 08h, 0Bh, 00h, 01h, 10h
		db	 04h, 00h, 0Bh, 04h, 0Dh, 00h
		db	 05h, 08h, 06h, 00h, 04h, 10h
		db	 1Dh, 00h, 08h, 08h, 32h, 00h
		db	 10h, 08h, 06h, 09h, 24h, 08h
		db	 05h, 09h, 08h, 08h, 10h, 00h
		db	 02h, 04h, 0Bh, 00h, 01h, 04h
		db	 0Ah, 00h, 01h, 08h, 14h, 00h
		db	 02h, 20h, 02h, 00h, 27h, 01h
		db	 03h, 08h, 1Ah, 00h, 03h, 20h
		db	 0Eh, 00h, 09h, 08h, 1Ch, 00h
		db	 03h, 08h, 44h, 00h, 0Ah, 08h
		db	 1Ch, 00h, 02h, 10h, 0Fh, 00h
		db	 30h, 08h, 65h, 00h, 04h, 20h
		db	 17h, 00h, 34h, 01h, 03h, 08h
		db	 1Ch, 00h, 03h, 20h, 15h, 00h
		db	 0Dh, 08h, 4Ch, 00h, 02h, 10h
		db	 12h, 00h, 1Bh, 08h, 05h, 00h
		db	 05h, 04h, 07h, 00h, 10h, 08h
		db	 03h, 09h, 06h, 08h, 18h, 00h
		db	 05h, 08h, 13h, 00h, 02h, 04h
		db	 0Dh, 00h, 02h, 04h, 1Ah, 00h
		db	 05h, 20h, 06h, 00h, 31h, 01h
		db	 26h, 00h, 03h, 20h, 24h, 00h
		db	 22h, 08h, 09h, 00h, 08h, 10h
		db	 20h, 00h, 0Bh, 08h, 09h, 00h
		db	 0Ch, 04h, 07h, 00h, 02h, 08h
		db	 0Bh, 00h, 02h, 10h, 21h, 00h
		db	 18h, 08h, 05h, 00h, 38h, 08h
		db	 08h, 00h, 05h, 04h, 07h, 00h
		db	 03h, 08h, 18h, 00h, 04h, 20h
		db	 04h, 00h, 30h, 01h, 03h, 08h
		db	 26h, 00h, 03h, 20h, 15h, 00h
		db	 09h, 08h, 14h, 00h, 0Ch, 08h
		db	 11h, 00h, 02h, 10h, 1Eh, 00h
		db	 0Ch, 04h, 19h, 00h, 09h, 08h
		db	 02h, 09h, 05h, 01h, 0Fh, 00h
		db	 0Fh, 08h, 04h, 09h, 10h, 08h
		db	 07h, 00h, 03h, 04h, 18h, 00h
		db	 04h, 20h, 27h, 01h, 11h, 04h
		db	 0Fh, 00h, 09h, 08h, 0Fh, 00h
		db	 28h, 02h, 03h, 00h, 01h, 08h
		db	 16h, 00h, 01h, 20h, 10h, 00h
		db	 07h, 08h, 09h, 00h, 04h, 04h
		db	 09h, 00h, 01h, 08h, 17h, 00h
		db	 03h, 20h, 02h, 00h, 20h, 01h
		db	 01h, 00h, 02h, 08h, 1Bh, 00h
		db	 02h, 20h, 1Ch, 00h, 08h, 08h
		db	 69h, 00h, 12h, 08h, 15h, 00h
		db	 03h, 10h, 21h, 00h, 03h, 02h
		db	 3Dh, 00h, 05h, 02h, 03h, 00h
		db	 11h, 08h, 02h, 09h, 08h, 08h
		db	 14h, 00h, 04h, 04h, 27h, 00h
		db	 03h, 08h, 2Dh, 00h, 27h, 04h
		db	 09h, 00h, 02h, 04h, 17h, 00h
		db	 01h, 20h, 06h, 00h, 31h, 01h
		db	 02h, 00h, 05h, 04h, 0Bh, 00h
		db	 03h, 08h, 09h, 00h, 02h, 08h
		db	 18h, 00h, 03h, 20h, 14h, 00h
		db	 11h, 04h, 0Dh, 00h, 07h, 10h
		db	 04h, 00h, 27h, 04h, 01h, 00h
		db	 03h, 10h, 12h, 00h, 0Ah, 04h
		db	 04h, 00h, 07h, 08h, 2Dh, 00h
		db	 10h, 04h, 04h, 05h, 04h, 04h
		db	 5Ah, 00h, 03h, 20h, 09h, 00h
		db	 2Ch, 01h, 0Ch, 00h, 05h, 04h
		db	 21h, 00h, 03h, 20h, 17h, 00h
		db	 05h, 04h, 10h, 00h, 06h, 10h
		db	 24h, 00h, 04h, 04h, 61h, 00h
		db	 06h, 04h, 16h, 00h, 02h, 10h
		db	 0Fh, 00h, 04h, 04h, 0Eh, 00h
		db	 04h, 08h, 09h, 00h, 01h, 04h
		db	 18h, 00h, 03h, 20h, 01h, 00h
		db	 2Fh, 01h, 03h, 00h, 04h, 04h
		db	 19h, 00h, 03h, 20h, 1Ch, 00h
		db	 03h, 04h, 28h, 00h, 36h, 04h
		db	 09h, 00h, 03h, 10h, 1Eh, 00h
		db	 06h, 10h, 23h, 00h, 05h, 04h
		db	 32h, 00h, 14h, 04h, 05h, 05h
		db	 2Ch, 04h, 0Dh, 00h, 0Fh, 04h
		db	 16h, 00h, 01h, 40h, 00h, 44h
		db	 44h,0E8h, 46h, 00h, 83h, 7Eh
		db	 06h, 00h, 74h, 17h, 8Ah
		db	46h
data_4850	dw	3501h			; Data table (indexed access)
		db	0D2h
data_4853	dw	0
data_4855	dw	485Fh
data_4857	dw	31B7h
data_4859	db	1
data_485A	dw	0CF7Ch
data_485C	db	1
data_485D	dw	488h
		db	0DCh,0CEh
		db	22 dup (0)
data_4877	db	0F7h
data_4878	dw	0BB9Ch
data_487A	db	1
data_487B	db	46h
		db	 25h, 00h, 00h, 0Fh, 0Ah, 17h
		db	 00h, 0Fh, 0Ah, 13h, 01h,0F1h
		db	 09h, 00h, 00h, 82h, 04h, 00h
		db	 11h,0AAh, 0Bh, 00h, 08h,0AAh
		db	 0Bh, 00h, 07h,0A1h, 08h, 05h
		db	 06h,0EEh, 04h, 19h, 06h,0EEh
		db	 04h, 0Ah, 0Ah, 39h, 03h, 15h
		db	 0Ah, 39h, 03h, 1Eh, 0Bh, 64h
		db	 0Bh, 15h, 0Dh, 01h, 00h, 0Ah
		db	 13h, 39h, 03h, 00h, 0Bh, 39h
		db	 03h, 00h, 0Ch, 01h, 00h, 00h
		db	 13h, 39h, 03h, 10h, 0Fh,0D5h
		db	 06h, 07h, 0Fh,0D5h, 06h, 0Ch
		db	 0Fh,0D5h, 06h, 0Ch, 0Ch, 98h
		db	 04h, 10h, 10h,0CAh, 00h, 01h
		db	 0Fh,0D5h, 06h, 00h, 0Ch, 62h
		db	 02h, 0Ch, 11h, 21h, 07h, 13h
		db	 0Ch, 9Eh, 04h, 1Eh, 08h,0A3h
		db	 0Ah, 1Eh, 04h,0A3h, 0Ah, 23h
		db	 06h, 01h, 00h, 23h, 0Bh, 01h
		db	 00h, 1Ch, 06h, 01h, 00h, 16h
		db	 11h, 6Ah, 00h, 00h, 0Eh,0D5h
		db	 06h, 00h, 0Fh,0D5h, 06h, 00h
		db	 10h, 6Ah, 01h, 15h, 0Dh,0D5h
		db	 06h, 19h, 0Bh,0D5h, 06h, 1Eh
		db	 00h, 00h, 0Fh, 0Ah, 0Dh, 00h
		db	 0Fh, 0Ah, 1Ah, 00h, 0Fh, 0Ah
		db	 02h, 00h, 82h, 04h, 0Fh, 03h
		db	0F1h, 09h, 00h, 07h,0A1h, 08h
		db	 21h, 05h,0D5h, 00h, 00h, 08h
		db	0AAh, 0Bh, 00h, 0Bh,0AAh, 0Bh
		db	 00h, 0Eh,0AAh, 0Bh, 00h, 11h
		db	0AAh, 0Bh, 1Ch, 00h, 82h, 04h
		db	 21h, 0Ah, 2Dh, 07h, 21h, 06h
		db	0D5h, 00h, 02h, 0Ah, 2Dh, 07h
		db	 05h, 0Ah, 2Dh, 07h, 07h, 0Ch
		db	0D5h, 06h, 04h, 0Ch,0D5h, 06h
		db	 04h, 0Eh,0D5h, 06h, 06h, 0Eh
		db	0D5h, 06h, 0Ch, 0Ah, 2Dh, 07h
		db	 12h, 10h,0F3h, 00h, 12h, 0Ah
		db	0F3h, 00h, 0Ch, 0Ch,0D5h, 06h
		db	 11h, 0Ch,0D5h, 06h, 16h, 0Ah
		db	0A3h, 0Ah, 16h, 0Bh,0A3h, 0Ah
		db	 08h, 06h,0EEh, 04h, 16h, 03h
		db	0A3h, 0Ah, 16h, 02h,0EAh, 09h
		db	 14h, 00h, 00h, 0Fh, 0Ah, 07h
		db	 00h, 0Fh, 0Ah, 07h, 00h,0F1h
		db	 09h, 0Dh, 0Ch, 01h, 00h, 15h
		db	 09h, 41h, 05h, 1Ah, 00h, 0Fh
		db	 0Ah, 1Ah, 04h,0F1h, 09h, 00h
		db	 12h, 31h, 03h, 00h, 05h, 40h
		db	 00h, 04h, 05h,0F8h, 03h, 0Dh
		db	 0Bh, 01h, 00h, 0Eh, 0Eh,0D5h
		db	 06h, 0Eh, 0Fh,0D5h, 06h, 0Dh
		db	 0Eh,0FDh, 0Dh, 00h, 13h, 09h
		db	 05h, 18h, 13h, 6Ah, 00h, 19h
		db	 13h, 6Ah, 00h, 0Eh, 10h, 5Ah
		db	 0Bh, 14h, 10h,0A2h, 0Bh, 12h
		db	 10h,0A2h, 0Bh, 10h, 00h, 13h
		db	 6Ah, 00h, 1Ch, 13h, 55h, 04h
		db	 15h, 0Bh, 1Ch, 01h, 21h, 0Bh
		db	 1Ch, 01h, 21h, 05h, 1Ch, 01h
		db	 10h, 13h, 55h, 04h, 0Eh, 13h
		db	0DDh, 01h, 16h, 01h,0F1h, 09h
		db	 0Bh, 06h, 82h, 04h, 00h, 00h
		db	 0Fh, 0Ah, 0Bh, 00h, 0Fh, 0Ah
		db	 03h, 00h, 82h, 04h, 15h, 05h
		db	 1Ch, 01h, 1Bh, 05h, 1Ch, 01h
		db	 1Bh, 0Ch, 98h, 01h, 13h, 10h
		db	0A2h, 0Bh, 11h, 00h, 00h, 0Fh
		db	 0Ah, 0Eh, 00h, 0Fh, 0Ah, 00h
		db	 00h, 82h, 04h, 0Eh, 03h,0F1h
		db	 09h, 17h, 01h, 82h, 04h, 00h
		db	 0Bh, 1Ch, 01h, 00h, 05h, 1Ch
		db	 01h, 00h, 13h, 09h, 05h, 16h
		db	 0Bh,0A3h, 0Ah, 16h, 0Ah,0EAh
		db	 09h, 0Dh, 10h,0A2h, 0Bh, 0Fh
		db	 10h,0DBh, 0Dh, 11h, 10h,0A2h
		db	 0Bh, 1Fh, 12h,0EEh, 04h, 1Fh
		db	 0Ah, 40h, 00h, 20h, 0Ch, 01h
		db	 00h, 1Fh, 12h,0F3h, 00h, 18h
		db	 00h, 12h,0EEh, 04h, 04h, 09h
		db	 27h, 08h, 14h, 0Ah, 2Ch, 06h
		db	 15h, 00h, 0Fh, 0Ah, 00h, 00h
		db	 0Fh, 0Ah, 00h, 00h, 82h, 04h
		db	 0Bh, 00h, 0Fh, 0Ah, 17h, 03h
		db	0F1h, 09h, 0Ah, 0Dh, 24h, 0Ch
		db	 27h, 05h, 11h, 00h, 24h, 05h
		db	0CBh, 01h, 23h, 0Ch,0C3h, 00h
		db	 25h, 00h, 1Bh, 06h, 17h, 0Dh
		db	0D5h, 00h, 1Eh, 0Dh,0D5h, 00h
		db	 19h, 0Fh,0D5h, 00h, 20h, 0Fh
		db	0D5h, 00h, 25h, 0Fh, 1Bh, 06h
		db	 17h, 11h,0F3h, 00h, 17h, 0Dh
		db	0FDh, 00h, 25h, 0Dh, 1Bh, 06h
		db	 00h, 13h,0A1h, 08h, 26h, 06h
		db	 05h, 0Eh, 07h, 10h,0A2h, 0Bh
		db	 18h, 00h, 13h, 78h, 02h, 24h
		db	 09h, 4Fh, 06h, 14h, 02h, 98h
		db	 04h, 1Bh, 02h, 9Eh, 04h, 22h
		db	 02h,0C0h, 05h, 1Bh, 10h, 63h
		db	 04h, 0Fh, 0Ah, 79h, 03h, 1Ch
		db	 0Ah, 79h, 03h, 15h, 09h, 4Fh
		db	 06h, 19h, 08h,0FDh, 00h, 16h
		db	 06h, 4Ch, 02h, 1Eh, 06h, 4Ch
		db	 02h, 12h, 06h,0EBh, 06h, 13h
		db	 08h,0FDh, 00h, 00h, 00h
loc_4AFD:
		add	[bx+si],ax
		add	[bx+si],al
		js	loc_4B05		; Jump if sign=1
		add	[di],al
loc_4B05:
		inc	word ptr [bp+si]
		add	byte ptr ds:[0DFDh],al
		add	[bx+di],cx
		pop	dx
		or	ax,[bx+si]
		or	al,1
		add	[bx+si],al
		adc	bh,ch
		add	[bx+si],al
		or	al,3Ah			; ':'
		add	[bp+si],al
		or	al,0A4h
		add	al,0Dh
		adc	bh,[bp+si]
		add	[bx+si],dl
		add	[bp+di],dl
		js	loc_4B2A		; Jump if sign=1
		add	[bx+di],cl
loc_4B2A:
		dec	di
		push	es
		sbb	[bx+di],cl
		dec	di
		push	es
		and	cx,[bx+di]
		dec	di
		push	es
		or	al,9
		dec	di
		push	es
		add	[bx+si],al
;*		js	loc_4B3E		;*Jump if sign=1
		db	 78h, 02h		;  Fixup - byte match
		sbb	ax,790Ah
		add	dx,[bx+di]
		or	bh,[bx+di+3]
		add	ax,790Ah
		add	ax,data_C002
		add	ax,21Bh
		cbw				; Convrt byte to word
		add	al,0
		or	[bx+si+2],bh
		add	byte ptr ds:[24Ch],al
		or	al,byte ptr ds:[24Ch]
		adc	al,6
		dec	sp
		add	bl,data_4C06
		add	bl,[si]
		add	[bp+di],dl
		js	loc_4B6B		; Jump if sign=1
		add	[bx+si],al
loc_4B6B:
		js	$+4			; Jump if sign=1
		add	[bx+di],cl
		dec	di
		push	es
		or	[bp+di],cx
		rol	byte ptr [di],9		; Rotate
		or	ax,5C0h
		db	 0Fh, 0Bh,0C0h, 05h, 15h, 0Bh
		db	 87h, 03h, 15h, 0Eh,0C0h, 05h
		db	 15h, 10h,0ACh, 05h, 1Bh, 0Bh
		db	0C0h, 05h, 1Bh, 0Dh,0C0h, 05h
		db	 08h, 04h, 79h, 03h, 1Dh, 04h
		db	 79h, 03h, 09h, 0Ah,0D4h, 05h
		db	 0Fh, 10h,0ACh, 05h, 09h, 0Fh
		db	0ACh, 05h, 09h, 10h, 87h, 03h
		db	 1Bh, 0Fh,0ACh, 05h, 1Bh, 10h
		db	 87h, 03h, 24h, 09h, 4Fh, 06h
		db	 00h, 06h,0FFh, 06h, 00h, 08h
		db	0FDh, 00h, 04h, 08h,0E3h, 0Ch
		db	 0Ah, 08h,0E3h, 0Ch, 10h, 0Fh
		db	 1Ah, 0Eh, 13h, 0Eh,0F7h, 01h
		db	 12h, 01h,0EEh, 05h, 23h, 08h
		db	0C3h, 00h, 18h, 0Ah, 04h,0EBh
		db	 0Ch, 00h, 13h, 78h, 02h, 10h
		db	 09h, 4Fh, 06h, 19h, 09h, 4Fh
		db	 06h, 00h, 08h,0D4h, 05h, 10h
		db	 08h,0D4h, 05h, 00h, 02h,0C0h
		db	 05h, 00h, 05h,0C0h, 05h, 06h
		db	 02h,0C0h, 05h, 0Ch, 05h,0C0h
		db	 05h, 0Ch, 02h,0C0h, 05h, 22h
		db	 05h,0C0h, 05h
data_4C06	db	22h
		db	 02h,0C0h, 05h, 1Ch, 02h,0C0h
		db	 05h, 1Ch, 05h,0C0h, 05h, 06h
		db	 05h, 87h, 03h, 24h, 09h, 4Fh
		db	 06h, 1Eh, 0Ah, 79h, 03h, 0Ah
		db	 0Ah, 79h, 03h, 05h
		db	 09h, 4Fh
loc_4C25:
		push	es
		adc	al,12h
;*		jmp	far ptr l_7800_0009	;*
		db	0EAh
		dw	9, 7800h		;  Fixup - byte match
			                        ;* No entry point to code
		add	dl,[si]
		add	byte ptr ss:[140Ah][bp+di],ah
		or	word ptr ss:[1F0Ah][bp+di],sp
		add	[bp+di],dl
		js	loc_4C3D		; Jump if sign=1
		add	[bx+si],al
loc_4C3D:
		js	$+4			; Jump if sign=1
		or	[bp+di],cx
		cbw				; Convrt byte to word
		add	al,0Fh
		or	di,[bx+di+3]
		and	byte ptr ds:[5ACh],cl
		and	[bx+si],dl
		xchg	[bp+di],ax
		sbb	cl,[si]
		rol	byte ptr [di],1Ah	; Rotate
		adc	byte ptr ds:[1A05h][si],ch
		or	ax,5C0h
		add	al,6
		push	1
		or	[bp+si],al
		sahf				; Store ah into flags
		add	al,20h			; ' '
		or	al,0C0h
		add	ax,0B1Ah
		rol	byte ptr [di],23h	; '#' Rotate
		add	al,8Ah
		add	[bp+di],sp
		add	ax,533h
		adc	[di],ax
		mov	al,[bx+di]
		and	[di],al
		xor	ax,[di]
		sbb	ax,[di]
		xor	ax,[di]
		adc	al,0Bh
		mov	word ptr ds:[70Ah],ax
		db	 0Fh, 9Ch, 09h, 06h, 11h,0CBh
		db	 08h, 0Fh, 10h,0CAh, 00h, 00h
		db	 0Dh, 0Ah, 0Bh, 00h, 01h, 1Bh
		db	 06h, 00h, 08h, 1Bh, 06h, 00h
		db	 05h, 1Bh, 06h, 00h, 09h, 78h
		db	 02h, 14h, 00h,0A3h, 0Ah, 14h
		db	 06h,0A3h, 0Ah, 07h, 05h, 1Ah
		db	 0Eh, 03h, 0Bh,0F7h, 01h, 18h
		db	 00h, 13h, 78h, 02h, 00h, 0Fh
		db	 0Fh, 03h, 06h, 0Fh, 0Fh, 03h
		db	 0Ch, 0Fh, 0Fh, 03h, 22h, 0Fh
		db	 0Fh, 03h, 1Ch, 0Fh, 0Fh, 03h
		db	 17h, 0Fh, 0Fh, 03h, 12h, 0Fh
		db	 0Fh, 03h, 00h, 00h, 0Fh, 0Ah
		db	 0Eh, 00h, 0Fh, 0Ah, 1Bh, 00h
		db	 0Fh, 0Ah, 00h, 00h, 82h, 04h
		db	 1Ah, 02h,0F1h, 09h, 00h, 0Ch
		db	 2Ch, 06h, 1Dh, 0Ch, 2Ch, 06h
		db	 1Ah, 0Ch,0A4h, 09h, 0Ch, 0Ch
		db	0A4h, 09h, 14h, 0Bh,0A3h, 0Ah
		db	 00h, 12h, 39h, 03h, 09h, 12h
		db	 39h, 03h, 19h, 12h, 39h, 03h
		db	 1Dh, 12h, 39h, 03h, 04h, 0Bh
		db	 05h, 0Eh, 20h, 0Bh, 05h, 0Eh
		db	 16h, 00h, 0Fh, 0Fh, 03h, 06h
		db	 0Fh, 0Fh, 03h, 0Ch, 0Fh, 0Fh
		db	 03h, 12h, 0Fh, 0Fh, 03h, 00h
		db	 00h, 0Fh, 0Ah, 0Eh, 00h, 0Fh
		db	 0Ah, 1Bh, 00h, 0Fh, 0Ah, 00h
		db	 12h, 39h, 03h, 0Bh, 12h, 39h
		db	 03h, 00h, 13h,0FDh, 00h, 07h
		db	 13h,0FDh, 00h, 00h, 0Ch,0A4h
		db	 09h, 03h, 0Ch, 2Ch, 06h, 0Fh
		db	 0Ch,0A4h, 09h, 09h, 04h,0F1h
		db	 09h, 14h, 00h, 82h, 04h, 22h
		db	 05h, 0Fh, 03h, 25h, 0Eh,0F6h
		db	 0Ah, 24h, 08h, 14h, 0Eh, 24h
		db	 0Ch, 14h, 0Eh, 24h, 10h, 14h
		db	 0Eh, 25h, 08h,0F6h, 0Ah, 1Bh
		db	 22h, 10h,0EBh, 06h, 00h, 13h
		db	 78h, 02h, 1Ch, 13h, 55h, 04h
		db	 00h, 09h, 4Fh, 06h, 00h, 06h
		db	 87h, 03h, 00h, 02h,0C0h, 05h
		db	 00h, 03h,0C0h, 05h, 0Bh, 09h
		db	 79h, 03h, 06h, 10h
		db	63h
loc_4D91:
		add	al,0
;*		add	ch,bh
		db	 00h,0FDh		;  Fixup - byte match
		add	[bx],al
;*		add	ch,bh
		db	 00h,0FDh		;  Fixup - byte match
		add	[bp+si],dl
		add	[bx+si+0Dh],bh
		adc	dl,[bx+di]
		db	0F3h, 00h, 22h, 0Bh, 0Dh, 08h
		db	 16h, 10h, 2Ch, 06h, 16h, 10h
		db	0A2h, 0Bh, 13h, 0Ah,0FDh, 0Dh
		db	 13h, 0Bh,0FDh, 0Dh, 14h, 0Eh
		db	 5Ah, 0Bh, 18h, 10h,0A2h, 0Bh
		db	 00h, 08h, 3Ah, 00h, 03h, 08h
		db	 3Ah, 00h, 25h, 00h,0F6h, 0Ah
		db	 25h, 04h,0F6h, 0Ah, 22h, 06h
		db	0F3h, 00h, 16h, 04h, 79h, 06h
		db	 1Eh, 04h, 7Dh, 0Eh, 19h, 00h
		db	 13h, 78h, 02h, 00h, 00h,0AAh
		db	 0Bh, 00h, 03h,0AAh, 0Bh, 21h
		db	 09h, 2Dh, 07h, 22h, 09h, 23h
		db	 03h, 00h, 09h, 2Dh, 07h, 00h
		db	 09h, 23h, 03h, 0Bh, 05h, 40h
		db	 00h, 19h, 05h, 40h, 00h, 0Dh
		db	 05h, 64h, 0Bh, 16h, 00h,0A3h
		db	 0Ah, 00h, 03h, 0Fh, 03h, 06h
		db	 04h,0F3h, 00h, 0Ah, 04h,0F3h
		db	 00h, 08h, 02h,0F3h, 00h, 1Dh
		db	 04h,0F3h, 00h, 24h, 04h,0F3h
		db	 00h, 21h, 04h,0F3h, 00h, 16h
		db	 12h,0EAh, 09h, 16h, 09h,0A3h
		db	 0Ah, 0Fh, 09h,0D5h, 00h, 1Bh
		db	 0Dh,0D5h, 06h, 0Bh, 09h,0F3h
		db	 00h, 12h, 07h,0F3h, 00h, 0Bh
		db	 0Dh,0D5h, 06h, 1Ch, 00h, 00h
		db	0AAh, 0Bh, 22h, 10h, 0Fh, 03h
		db	 00h, 0Dh, 0Fh, 03h, 00h, 0Ah
		db	 0Fh, 03h, 16h, 10h, 0Fh, 03h
		db	 02h, 10h, 0Fh, 03h, 00h, 13h
		db	 99h, 07h, 0Bh, 10h, 0Fh, 03h
		db	 00h, 09h, 40h, 00h, 00h, 02h
		db	0FEh, 0Ch, 0Fh, 03h, 1Ah, 00h
		db	 14h, 03h, 1Ah, 00h, 19h, 03h
		db	 1Ah, 00h, 14h, 04h,0D5h, 06h
		db	 1Eh, 04h, 1Bh, 07h, 20h, 04h
		db	0E3h, 0Dh, 1Eh, 06h, 08h, 0Eh
		db	 0Fh, 04h,0D5h, 06h, 1Dh, 08h
		db	 27h, 07h, 15h, 09h,0E3h, 0Dh
		db	 11h, 09h,0E3h, 0Dh, 0Fh, 09h
		db	 1Bh, 07h, 0Fh, 04h,0E3h, 0Dh
		db	 18h, 04h, 14h, 0Eh, 17h, 04h
		db	 0Eh, 0Eh, 00h, 04h,0E3h, 0Ch
		db	 04h, 00h, 14h, 0Eh, 04h, 03h
		db	 1Eh, 0Eh, 1Fh, 00h, 13h, 99h
		db	 07h, 00h, 00h,0AAh, 0Bh, 06h
		db	 10h, 0Fh, 03h, 00h, 10h, 0Fh
		db	 03h, 22h, 0Bh, 0Fh, 03h, 22h
		db	 0Eh, 23h, 03h, 25h, 0Bh
		db	'C', 0Ah, '%', 0Ch, 'C', 0Ah, '"', 9
		db	 0Fh, 03h, 20h, 10h, 0Fh, 03h
		db	 1Eh, 10h, 0Fh, 03h, 00h, 02h
		db	0FEh, 0Ch, 13h, 04h, 1Ah, 00h
		db	 14h, 02h, 43h, 0Ah, 05h, 00h
		db	0D5h, 06h, 05h, 01h,0D5h, 06h
		db	 13h, 0Ah,0E3h, 0Dh, 18h, 0Ah
		db	0E3h, 0Ch, 18h, 04h, 1Bh, 07h
		db	 1Ah, 04h,0E3h, 0Dh, 18h, 06h
		db	 08h, 0Eh, 17h, 09h, 27h, 07h
		db	 11h, 04h, 0Eh, 0Eh, 12h, 06h
		db	 14h, 0Eh, 12h, 09h, 1Eh, 0Eh
		db	 04h, 04h,0E3h, 0Ch, 04h, 00h
		db	 08h, 0Eh, 03h, 03h, 27h, 07h
		db	 0Ah, 00h, 14h, 0Eh, 0Ah, 03h
		db	 1Eh, 0Eh, 13h, 10h, 0Fh, 03h
		db	 18h, 00h, 13h, 99h, 07h, 00h
		db	 00h,0AAh, 0Bh, 14h, 10h, 0Fh
		db	 03h, 22h, 0Bh, 0Fh, 03h, 22h
		db	 0Eh, 23h, 03h, 25h, 0Bh, 43h
		db	 0Ah, 25h, 0Ch, 43h, 0Ah, 00h
		db	 0Bh, 0Fh, 03h, 00h, 0Eh, 0Fh
		db	 03h, 00h, 0Ch, 43h, 0Ah, 00h
		db	 0Bh, 43h, 0Ah, 0Dh, 08h,0FDh
		db	 00h, 0Bh, 08h,0D5h, 06h, 18h
		db	 08h,0D5h, 06h, 00h, 09h, 0Fh
		db	 03h, 22h, 09h, 0Fh, 03h, 1Fh
		db	 10h, 0Fh, 03h, 03h, 11h, 23h
		db	 03h, 0Ch, 11h, 23h, 03h, 00h
		db	 02h,0FEh, 0Ch, 10h, 00h,0D5h
		db	 00h, 16h, 02h,0F3h, 00h, 12h
		db	 02h, 40h, 00h, 0Eh, 02h,0F3h
		db	 00h, 1Dh, 00h, 00h,0AAh, 0Bh
		db	 22h, 0Bh, 0Fh, 03h, 22h, 0Eh
		db	 23h, 03h, 25h, 0Bh, 43h, 0Ah
		db	 25h, 0Ch, 43h, 0Ah, 01h, 11h
		db	 23h, 03h, 00h, 0Ch, 43h, 0Ah
		db	 00h, 0Bh, 43h, 0Ah, 00h, 09h
		db	 0Fh, 03h, 1Fh, 10h, 0Fh, 03h
		db	 08h, 10h, 0Fh, 03h, 06h, 09h
		db	 0Fh, 03h, 22h, 09h, 0Fh, 03h
		db	 00h, 02h,0FEh, 0Ch, 03h, 0Ch
		db	 08h, 0Eh, 03h, 0Dh, 08h, 0Eh
		db	 03h, 0Ch, 1Bh, 07h, 05h, 0Ch
		db	0E3h, 0Dh, 0Bh, 0Bh, 27h, 07h
		db	 12h, 04h,0E3h, 0Ch, 12h, 00h
		db	 08h, 0Eh, 11h, 03h, 27h, 07h
		db	 16h, 00h, 14h, 0Eh, 16h, 03h
		db	 1Eh, 0Eh, 00h, 13h, 99h, 07h
		db	 11h, 10h, 0Fh, 03h, 15h, 09h
		db	 2Dh, 07h, 12h, 09h, 0Fh, 03h
		db	 18h, 09h, 0Fh, 03h, 10h, 00h
		db	 13h, 99h, 07h, 00h, 00h,0AAh
		db	 0Bh, 00h, 0Ch, 43h, 0Ah, 00h
		db	 0Bh, 43h, 0Ah, 03h, 0Bh, 6Eh
		db	 05h, 0Dh, 12h, 31h, 03h, 22h
		db	 0Fh, 0Fh, 03h, 22h, 12h, 31h
		db	 03h, 00h, 09h, 23h, 03h, 17h
		db	 12h, 31h, 03h, 1Dh, 12h, 31h
		db	 03h, 07h, 12h, 31h, 03h, 01h
		db	 12h, 31h, 03h, 00h, 02h,0FEh
		db	 0Ch, 19h, 09h, 6Eh, 05h, 22h
		db	 0Dh, 23h, 03h, 15h, 00h, 13h
		db	 99h, 07h, 00h, 00h,0AAh, 0Bh
		db	 22h, 11h, 23h, 03h, 22h, 0Bh
		db	 0Fh, 03h, 22h, 0Eh, 0Fh, 03h
		db	 18h, 12h, 31h, 03h, 00h, 0Fh
		db	 0Fh, 03h, 00h, 12h, 31h, 03h
		db	 06h, 12h, 31h, 03h, 1Eh, 12h
		db	 31h, 03h, 22h, 09h, 0Fh, 03h
		db	 24h, 09h, 40h, 00h, 00h, 02h
		db	0FEh, 0Ch, 14h, 04h, 0Eh, 0Eh
		db	 16h, 04h,0E3h, 0Ch, 1Ah, 00h
		db	 14h, 0Eh, 1Ah, 03h, 1Eh, 0Eh
		db	 00h, 09h, 6Eh, 05h, 00h, 0Dh
		db	 23h, 03h, 10h, 12h,0EAh, 09h
		db	 0Eh, 09h, 6Eh, 05h, 1Ah, 00h
		db	 13h, 99h, 07h, 00h, 00h,0AAh
		db	 0Bh, 22h, 11h, 23h, 03h, 24h
		db	 09h, 40h, 00h, 00h, 09h, 40h
		db	 00h, 00h, 0Bh, 01h, 00h, 22h
		db	 09h, 40h, 00h, 26h, 0Bh, 01h
		db	 00h, 16h, 12h, 31h, 03h, 10h
		db	 12h, 31h, 03h, 04h, 12h, 31h
		db	 03h, 1Ch, 12h, 31h, 03h, 1Eh
		db	 0Fh, 0Fh, 03h, 00h, 02h,0FEh
		db	 0Ch, 14h, 04h, 40h, 00h, 17h
		db	 08h, 0Fh, 03h, 15h, 06h, 01h
		db	 00h, 14h, 0Ch,0F3h, 00h, 22h
		db	 04h,0E3h, 0Ch, 20h, 03h, 27h
		db	 07h, 21h, 00h, 08h, 0Eh, 04h
		db	 11h,0E3h, 0Dh, 08h, 11h, 0Eh
		db	 0Eh, 0Ah, 11h,0E3h, 0Ch, 00h
		db	 11h,0F3h, 00h, 24h, 0Bh, 01h
		db	 00h, 14h, 00h, 09h, 2Dh, 07h
		db	 00h, 13h, 99h, 07h, 07h, 09h
		db	 87h, 07h, 16h, 0Bh, 82h, 04h
		db	 0Ch, 09h, 82h, 04h, 00h, 00h
		db	 0Fh, 0Ah, 0Ch, 00h, 0Fh, 0Ah
		db	 19h, 00h, 0Fh, 0Ah, 00h, 00h
		db	0F1h, 09h, 18h, 00h, 82h, 04h
		db	 00h, 0Bh, 01h, 00h, 02h, 0Bh
		db	 01h, 00h, 00h, 07h, 78h, 02h
		db	 00h
		db	8
loc_5139:
		xchg	word ptr ds:[1100h],ax
		db	0F3h, 00h, 24h, 09h, 40h, 00h
		db	 26h, 0Bh, 01h, 00h, 24h, 11h
		db	0F3h, 00h, 20h, 09h, 75h, 07h
		db	 07h, 0Ah, 05h, 0Eh, 1Ah, 21h
		db	 09h, 2Dh, 07h, 1Dh, 09h, 75h
		db	 07h, 00h, 13h, 99h, 07h, 16h
		db	 0Bh, 82h, 04h, 00h, 00h, 0Fh
		db	 0Ah, 0Ch, 00h, 0Fh, 0Ah, 19h
		db	 00h, 0Fh, 0Ah, 24h, 0Bh, 01h
		db	 00h, 26h, 0Bh, 01h, 00h, 00h
		db	 07h, 78h, 02h, 0Ch, 0Ah, 82h
		db	 04h, 1Bh, 10h, 0Fh, 03h, 00h
		db	 08h, 87h, 06h, 0Fh, 06h,0D5h
		db	 06h, 02h, 03h, 82h, 04h, 15h
		db	 01h,0F1h, 09h, 24h, 11h,0F3h
		db	 00h, 21h, 11h,0F3h, 00h, 00h
		db	 09h, 40h, 00h, 00h, 0Bh, 01h
		db	 00h, 00h, 11h,0F3h, 00h, 04h
		db	 09h, 87h, 07h, 04h, 10h, 0Fh
		db	 03h, 10h, 10h, 0Fh, 03h, 20h
		db	 0Ah, 05h, 0Eh, 13h, 06h,0D5h
		db	 06h, 1Ah, 00h, 00h, 0Fh, 0Ah
		db	 0Dh, 00h, 0Fh, 0Ah, 1Ah, 00h
		db	 0Fh, 0Ah, 12h, 03h, 82h, 04h
		db	 00h, 00h, 40h, 00h, 00h, 03h
		db	 40h, 00h, 12h, 0Dh, 64h, 0Bh
		db	 0Ah, 0Dh, 74h, 0Ch, 17h, 0Dh
		db	 64h, 0Bh, 1Eh, 0Fh,0F3h, 00h
		db	 1Eh, 11h,0F3h, 00h, 12h, 0Dh
		db	0FDh, 00h, 1Eh, 0Dh,0F3h, 00h
		db	 1Dh, 06h, 82h, 04h, 05h, 0Dh
		db	 24h, 0Ch, 00h, 0Dh, 74h, 0Ch
		db	 05h, 0Dh, 74h, 0Ch, 00h, 13h
		db	 09h, 05h, 00h, 13h,0FDh, 00h
		db	 16h, 0Bh,0A3h, 0Ah, 04h, 0Ah
		db	0FFh, 06h, 08h, 0Ah,0FFh, 06h
		db	 0Ch, 0Ah,0FFh, 06h, 04h, 03h
		db	 0Dh, 08h, 04h, 07h, 82h, 04h
		db	 04h, 00h, 79h, 06h, 10h, 19h
		db	 0Ch, 73h, 0Ah, 1Dh, 0Ch, 73h
		db	 0Ah, 1Eh, 0Eh, 5Dh, 0Ah, 00h
		db	 13h, 09h, 05h, 03h, 09h, 41h
		db	 05h, 00h, 00h, 0Fh, 0Ah, 0Dh
		db	 00h, 0Fh, 0Ah, 00h, 00h,0F1h
		db	 09h, 10h, 03h, 82h, 04h, 12h
		db	 10h, 10h, 07h, 1Ah, 0Eh, 09h
		db	 08h, 05h, 10h,0A2h, 0Bh, 07h
		db	 10h,0A2h, 0Bh, 1Eh, 09h, 8Bh
		db	 0Ah, 15h, 06h, 73h, 0Ah, 1Dh
		db	 06h, 73h, 0Ah, 1Eh, 00h, 13h
		db	 09h, 05h, 00h, 0Ch, 73h, 0Ah
		db	 06h, 07h, 5Dh, 0Ah, 0Bh, 00h
		db	 9Ch, 0Ah, 11h, 00h, 9Ch, 0Ah
		db	 0Ch, 00h,0A3h, 0Ah, 0Bh, 12h
		db	0EAh, 09h, 0Dh, 12h,0EAh, 09h
		db	 0Bh, 0Ch,0D2h, 0Ah, 06h, 0Eh
		db	0D6h, 0Ah, 11h, 0Ch, 73h, 0Ah
		db	 11h, 0Ah,0D2h, 0Ah, 1Bh, 0Ch
		db	 73h, 0Ah, 1Dh, 0Ch, 73h, 0Ah
		db	 13h, 10h, 8Bh, 0Ah, 0Ch, 09h
		db	0A3h, 0Ah, 06h, 0Fh,0D6h, 0Ah
		db	 06h, 10h,0D6h, 0Ah, 06h, 11h
		db	0D6h, 0Ah, 06h, 12h,0D6h, 0Ah
		db	 11h, 05h, 73h, 0Ah, 1Bh, 05h
		db	 73h, 0Ah, 1Dh, 05h, 73h, 0Ah
		db	 16h, 02h, 8Bh, 0Ah, 1Ch, 00h
		db	0DCh, 0Ah, 11h, 00h,0DCh, 0Ah
		db	 1Bh, 0Eh, 09h, 08h, 00h, 06h
		db	 73h, 0Ah, 0Bh, 03h, 9Ch, 0Ah
		db	 1Fh, 0Eh, 5Dh, 0Ah, 12h, 00h
		db	 0Ch, 73h, 0Ah, 0Bh, 0Ch,0D2h
		db	 0Ah, 0Bh, 0Fh, 9Ch, 0Ah, 0Bh
		db	 0Bh, 9Ch, 0Ah, 1Ah, 00h,0F8h
		db	 03h, 27h, 07h, 9Ch, 0Ah, 00h
		db	 00h,0F8h, 03h, 26h, 07h, 9Ch
		db	 0Ah, 1Eh, 00h, 82h, 04h, 08h
		db	 02h, 82h, 04h, 0Dh, 00h, 9Bh
		db	 03h, 1Ch, 12h,0DCh, 0Ah, 11h
		db	 12h,0DCh, 0Ah, 04h, 09h, 8Bh
		db	 0Ah, 0Ch, 0Bh,0A3h, 0Ah, 1Ch
		db	 0Bh, 73h, 0Ah, 19h, 09h, 10h
		db	 07h, 11h, 0Bh, 73h, 0Ah, 07h
		db	 1Dh, 0Ch, 73h, 0Ah, 1Bh, 00h
		db	 9Bh, 03h, 00h, 00h, 0Fh, 0Ah
		db	 0Dh, 01h, 0Fh, 0Ah, 00h, 06h
		db	0F1h, 09h, 12h, 02h, 82h, 04h
		db	 1Fh, 0Eh, 09h, 08h, 10h, 1Eh
		db	 00h, 82h, 04h, 1Ch, 12h,0DCh
		db	 0Ah, 11h, 12h,0DCh, 0Ah, 00h
		db	 00h, 9Bh, 03h, 0Dh, 00h,0F8h
		db	 03h, 00h, 07h, 9Ch
		db	0Ah, 1Bh, 0Dh, ']', 0Ah, 1Bh, 0Ch
		db	']', 0Ah
		db	 1Dh, 0Ah, 73h, 0Ah, 13h, 0Ah
		db	 73h, 0Ah, 00h, 12h, 73h, 0Ah
		db	 00h, 0Ah, 73h, 0Ah, 20h, 0Fh
		db	 8Bh, 0Ah, 03h, 07h, 8Bh, 0Ah
		db	 01h, 07h, 9Ch, 0Ah, 16h, 0Ch
		db	 09h, 08h, 18h, 1Ch, 00h,0DCh
		db	 0Ah, 12h, 00h,0DCh, 0Ah, 00h
		db	 00h,0DCh, 0Ah, 15h, 02h, 75h
		db	 07h, 1Bh, 02h, 87h, 07h, 18h
		db	 02h, 5Dh, 0Ah, 18h, 04h, 5Dh
		db	 0Ah, 1Ch, 09h, 73h, 0Ah, 18h
		db	 0Bh, 5Dh, 0Ah, 18h, 0Fh, 5Dh
		db	 0Ah, 06h, 0Dh, 5Dh, 0Ah, 06h
		db	 0Fh, 5Dh, 0Ah, 00h, 13h, 09h
		db	 05h, 00h, 0Ch, 73h, 0Ah, 00h
		db	 05h, 73h, 0Ah, 08h, 05h,0D5h
		db	 06h, 0Dh, 10h, 10h, 07h, 0Fh
		db	 10h, 10h, 07h, 0Dh, 0Dh, 10h
		db	 07h, 0Bh, 10h, 10h, 07h, 13h
		db	 02h, 09h, 08h, 21h, 0Bh, 01h
		db	 00h, 1Fh, 12h, 31h, 03h, 14h
		db	 09h, 73h, 0Ah, 17h, 00h, 00h
		db	0DCh, 0Ah, 15h, 0Ah, 2Dh, 07h
		db	 1Ch, 0Ah, 2Dh, 07h, 21h, 08h
		db	 2Dh, 07h, 1Eh, 0Ch, 62h, 02h
		db	 1Eh, 10h, 62h, 02h
data_5400	db	23h			; Data table (indexed access)
		db	 12h,0F3h, 00h, 24h, 12h,0F3h
		db	 00h, 1Eh, 0Eh, 62h, 02h, 19h
		db	 07h,0FDh, 00h, 19h, 06h,0D5h
		db	 06h, 1Ch, 06h,0D5h, 06h, 00h
		db	 09h, 73h, 0Ah, 03h, 0Bh, 5Dh
		db	 0Ah, 03h, 0Fh, 5Dh, 0Ah, 00h
		db	 13h, 09h, 05h, 0Fh, 10h, 10h
		db	 07h, 19h, 0Ch, 62h, 02h, 19h
		db	 0Eh, 62h, 02h, 19h, 10h, 62h
		db	 02h, 17h, 0Ch,0F3h, 00h, 17h
		db	 10h,0F3h, 00h, 12h, 10h, 10h
		db	 07h, 12h, 15h, 00h,0DCh, 0Ah
		db	 0Bh, 00h,0DCh, 0Ah, 00h, 00h
		db	0DCh, 0Ah, 14h, 0Ah,0B1h, 06h
		db	 1Ah, 02h, 01h, 00h, 1Ah, 03h
		db	 01h, 00h, 00h, 12h,0DCh, 0Ah
		db	 06h, 0Dh, 5Dh, 0Ah, 06h, 09h
		db	 5Dh, 0Ah, 06h, 02h, 5Dh, 0Ah
		db	 06h, 06h, 5Dh, 0Ah, 00h, 0Ah
		db	 73h, 0Ah, 02h, 0Ah, 73h, 0Ah
		db	 14h, 0Bh, 09h, 08h, 14h, 02h
		db	 01h, 00h, 14h, 06h,0D5h, 06h
		db	 16h, 02h, 75h, 07h, 0Ah, 02h
		db	 87h, 07h, 1Ch, 00h, 13h, 09h
		db	 05h, 00h, 08h, 39h, 03h, 22h
		db	 10h,0EBh, 06h, 00h, 00h, 0Fh
		db	 0Ah, 11h, 00h, 0Fh, 0Ah, 19h
		db	 00h, 0Fh, 0Ah, 0Ch, 00h,0F1h
		db	 09h, 1Ah, 04h, 82h, 04h, 00h
		db	 09h, 2Dh, 07h, 05h, 09h, 7Bh
		db	 00h, 0Ah, 09h, 40h, 00h, 05h
		db	 08h, 74h, 0Ch, 05h, 13h, 74h
		db	 0Ch, 17h, 09h, 41h, 05h, 11h
		db	 10h, 10h, 07h, 00h, 07h,0FDh
		db	 00h, 05h, 04h,0D5h, 06h, 00h
		db	 04h, 82h, 04h, 0Ah, 04h,0D5h
		db	 06h, 22h, 0Ah, 0Dh, 08h, 04h
		db	 09h, 08h, 0Eh, 04h, 0Dh, 08h
		db	 0Eh, 04h, 10h, 08h, 0Eh, 0Ah
		db	 09h, 14h, 0Eh, 0Ah, 0Dh, 14h
		db	 0Eh, 0Ah, 10h, 14h, 0Eh, 25h
		db	 00h,0F6h, 0Ah, 25h, 04h,0F6h
		db	 0Ah, 1Ch, 00h, 10h,0FFh, 06h
		db	 00h, 00h, 0Fh, 0Ah, 0Dh, 00h
		db	 0Fh, 0Ah, 1Ah, 00h, 0Fh, 0Ah
		db	 02h, 06h,0F1h, 09h, 12h, 03h
		db	 82h, 04h, 00h, 13h, 09h, 05h
		db	 10h, 0Fh,0D5h, 00h, 16h, 0Fh
		db	0D5h, 00h, 16h, 06h,0A2h, 02h
		db	 1Ch, 0Fh,0D5h, 00h, 10h, 01h
		db	 27h, 08h, 1Bh, 01h, 27h, 08h
		db	 10h, 06h,0A2h, 02h, 1Ch, 06h
		db	0A2h, 02h, 21h, 06h,0A2h, 02h
		db	 21h, 0Fh,0D5h, 00h, 12h, 11h
		db	 62h, 02h, 1Ch, 11h, 62h, 02h
		db	 1Eh, 11h, 62h, 02h, 00h, 0Ah
		db	 0Dh, 08h, 08h, 09h, 41h, 05h
		db	 0Ch, 10h,0A2h, 0Bh, 0Eh, 10h
		db	0A2h, 0Bh, 1Ch, 02h, 05h, 0Eh
		db	 00h, 00h,0F6h, 0Ah, 00h, 04h
		db	0F6h, 0Ah, 1Bh, 04h, 6Bh, 05h
		db	 1Ch, 00h, 00h, 0Fh, 0Ah, 0Dh
		db	 00h, 0Fh, 0Ah, 1Ah, 00h, 0Fh
		db	 0Ah, 12h, 03h, 82h, 04h, 00h
		db	 13h, 09h, 05h, 16h, 06h,0A2h
		db	 02h, 10h, 01h, 27h, 08h, 1Bh
		db	 01h, 27h, 08h, 10h, 06h,0A2h
		db	 02h, 1Ch, 06h,0A2h, 02h, 21h
		db	 06h,0A2h, 02h, 09h, 01h, 27h
		db	 08h, 00h, 01h, 27h, 08h, 0Ch
		db	 06h,0A2h, 02h, 00h, 06h,0A2h
		db	 02h, 06h, 06h,0A2h, 02h, 00h
		db	 0Fh, 91h, 0Ch, 00h, 11h, 62h
		db	 02h, 0Ah, 11h, 62h, 02h, 14h
		db	 11h, 62h, 02h, 1Eh, 11h, 62h
		db	 02h, 16h, 0Bh,0A3h, 0Ah, 16h
		db	 0Ah,0EAh, 09h, 00h, 06h, 77h
		db	 04h, 0Bh, 04h, 6Bh, 05h, 13h
		db	 03h, 6Bh, 05h, 14h, 04h, 6Bh
		db	 05h, 1Bh, 04h, 6Bh, 05h, 2Eh
		db	 00h, 00h, 0Fh, 0Ah, 0Dh, 00h
		db	 0Fh, 0Ah, 1Ah, 00h, 0Fh, 0Ah
		db	 12h, 03h, 82h, 04h, 00h, 13h
		db	 09h, 05h, 10h, 01h, 27h, 08h
		db	 1Bh, 01h, 27h, 08h, 1Ch, 06h
		db	0A2h, 02h, 21h, 06h,0A2h, 02h
		db	 09h, 01h, 27h, 08h, 00h, 01h
		db	 27h, 08h, 00h, 06h,0A2h, 02h
		db	 06h, 06h
data_5613	db	0A2h
		db	 02h, 00h, 0Fh, 91h, 0Ch, 12h
		db	 06h, 2Ch, 06h, 1Ah, 0Fh,0F3h
		db	 00h, 0Dh, 05h,0FBh, 01h, 1Bh
		db	 05h,0FBh, 01h, 10h, 0Dh,0E6h
		db	 01h, 13h, 0Dh,0E6h, 01h, 16h
		db	 0Dh,0E6h, 01h, 18h, 0Dh,0E6h
		db	 01h, 10h, 11h,0F1h, 0Ch, 10h
		db	 08h,0E6h, 01h, 13h, 08h,0E6h
		db	 01h, 16h, 08h,0E6h, 01h, 18h
		db	 08h,0E6h, 01h, 10h, 0Bh,0F1h
		db	 0Ch, 10h, 0Ch,0F1h, 0Ch, 10h
		db	 05h,0A2h, 0Dh, 1Ah, 0Fh,0F3h
		db	 00h, 10h, 12h,0E3h, 0Ch, 15h
		db	 12h,0E3h, 0Ch, 00h, 11h, 62h
		db	 02h, 06h, 11h, 62h, 02h, 0Dh
		db	 0Fh,0F3h, 00h, 1Bh, 11h, 62h
		db	 02h, 00h, 06h, 77h, 04h, 19h
		db	 02h, 05h, 0Eh, 09h, 02h, 05h
		db	 0Eh, 13h, 03h, 6Bh, 05h, 14h
		db	 04h, 6Bh, 05h, 0Bh, 04h, 6Bh
		db	 05h, 10h, 05h, 6Bh, 05h, 19h
		db	 05h, 6Bh, 05h, 1Bh, 04h, 6Bh
		db	 05h, 11h, 00h, 00h, 0Fh, 0Ah
		db	 0Dh, 00h, 0Fh, 0Ah, 1Ah, 00h
		db	 0Fh, 0Ah, 12h, 03h, 82h, 04h
		db	 00h, 13h, 09h, 05h, 00h, 01h
		db	 27h, 08h, 16h, 13h, 56h, 01h
		db	 0Ch, 13h, 56h, 01h, 1Dh, 10h
		db	 2Ch, 06h, 1Ch, 06h, 27h, 08h
		db	 00h, 06h,0A2h, 02h, 07h, 05h
		db	0FBh, 01h, 07h, 0Fh,0F3h, 00h
		db	 00h, 11h, 62h, 02h, 11h, 12h
		db	0EEh, 04h, 0Ah, 06h, 79h, 06h
		db	 00h, 06h, 77h, 04h, 18h, 00h
		db	 13h,0A1h, 08h, 00h, 00h, 0Fh
		db	 0Ah, 0Dh, 00h, 0Fh, 0Ah, 1Ah
		db	 00h, 0Fh, 0Ah, 08h, 00h,0F1h
		db	 09h, 17h, 03h,0F1h, 09h, 00h
		db	 03h, 82h, 04h, 00h, 09h, 27h
		db	 08h, 16h, 10h,0EBh, 06h, 16h
		db	 0Fh, 02h, 05h, 16h, 13h, 31h
		db	 03h, 22h, 0Dh,0EBh, 06h, 1Ch
		db	 0Fh,0EBh, 06h, 1Ch, 0Eh, 02h
		db	 05h, 21h, 0Dh,0EBh, 06h, 21h
		db	 0Ch, 02h, 05h, 21h, 10h
loc_5721:
;*		aad	0			; undocumented inst
		db	0D5h, 00h		;  Fixup - byte match
		sbb	al,12h
		db	0F3h, 00h, 1Fh, 12h,0F3h, 00h
		db	 09h, 0Ah, 05h, 0Eh, 13h, 0Ah
		db	0F6h, 0Ah, 0Ah, 10h, 2Ch, 06h
		db	 13h, 0Eh,0F6h, 0Ah, 16h, 09h
		db	 79h, 06h, 19h, 00h, 00h, 0Fh
		db	 0Ah, 0Dh, 00h, 0Fh, 0Ah, 1Ah
		db	 00h, 0Fh, 0Ah, 00h, 13h, 99h
		db	 07h, 0Fh, 05h, 27h, 08h, 0Bh
		db	 0Ch, 2Ch, 06h, 00h, 05h, 27h
		db	 08h, 00h, 0Ch, 2Ch, 06h, 1Ch
		db	 05h, 27h, 08h, 1Dh, 0Ch, 2Ch
		db	 06h, 00h, 10h,0D5h, 00h, 00h
		db	 0Dh,0FFh, 06h, 02h, 0Dh,0FFh
		db	 06h, 06h, 0Bh, 02h, 05h, 07h
		db	 0Fh, 1Bh, 02h, 10h, 0Fh, 1Bh
		db	 02h, 19h, 0Fh, 1Bh, 02h, 1Eh
		db	 0Fh, 1Bh, 02h, 00h, 00h, 82h
		db	 04h, 0Fh, 02h,0F1h, 09h, 07h
		db	 12h, 68h, 0Eh, 23h, 12h, 76h
		db	 0Eh, 17h, 12h, 68h, 0Eh, 12h
		db	 12h, 76h, 0Eh, 16h, 0Ch, 6Bh
		db	 09h, 18h, 00h, 00h, 0Fh, 0Ah
		db	 0Dh, 00h, 0Fh, 0Ah, 1Ah, 00h
		db	 0Fh, 0Ah, 08h, 00h,0F1h, 09h
		db	 17h, 03h,0F1h, 09h, 00h, 03h
		db	 82h, 04h, 00h, 13h, 99h, 07h
		db	 00h, 0Fh, 1Bh, 02h, 0Fh, 05h
		db	 27h, 08h, 00h, 05h, 27h, 08h
		db	 00h, 0Ch, 2Ch, 06h, 1Ch, 05h
		db	 27h, 08h, 1Dh, 0Ch, 2Ch, 06h
		db	 0Ah, 0Fh, 1Bh, 02h, 14h, 0Fh
		db	 1Bh, 02h, 1Eh, 0Fh, 1Bh, 02h
		db	 00h, 12h, 68h, 0Eh, 18h, 12h
		db	 68h, 0Eh, 23h, 12h, 76h, 0Eh
		db	 08h, 12h, 68h, 0Eh, 13h, 12h
		db	 76h, 0Eh, 10h, 06h, 05h, 0Eh
		db	 0Bh, 0Ch, 6Bh, 09h, 12h, 0Ch
		db	 2Ch, 06h, 18h, 00h, 00h, 0Fh
		db	 0Ah, 0Dh, 00h, 0Fh, 0Ah, 1Ah
		db	 00h, 0Fh, 0Ah, 00h, 13h, 99h
		db	 07h, 00h, 0Fh, 1Bh, 02h, 0Fh
		db	 05h, 27h, 08h, 0Bh, 0Ch, 2Ch
		db	 06h, 00h, 05h, 27h, 08h, 00h
		db	 0Ch, 2Ch, 06h, 21h, 10h,0D5h
		db	 00h, 22h, 0Dh,0EBh, 06h, 09h
		db	 0Fh, 1Bh, 02h, 12h, 0Fh, 1Bh
		db	 02h, 17h, 0Fh, 1Bh, 02h, 22h
		db	 0Bh, 02h, 05h, 1Bh, 05h, 27h
		db	 08h, 16h, 0Ch, 2Ch, 06h, 00h
		db	 03h,0F1h, 09h, 1Ah, 01h,0F1h
		db	 09h, 0Ch, 00h, 82h, 04h, 00h
		db	 12h, 68h, 0Eh, 1Ch, 12h, 76h
		db	 0Eh, 10h, 12h, 68h, 0Eh, 0Bh
		db	 12h, 76h, 0Eh, 10h, 00h, 13h
		db	0A1h, 08h, 00h, 00h, 0Fh, 0Ah
		db	 0Dh, 00h, 0Fh, 0Ah, 00h, 00h
		db	0F1h, 09h, 10h, 04h, 82h, 04h
		db	 00h, 0Dh,0FFh, 06h, 02h, 0Dh
		db	0FFh, 06h, 06h, 0Ch, 02h, 05h
		db	 00h, 10h,0D5h, 00h, 0Dh, 06h
		db	0A2h, 02h, 13h, 06h,0A2h, 02h
		db	 19h, 06h,0A2h, 02h, 1Fh, 06h
		db	0A2h, 02h, 21h, 06h,0A2h, 02h
		db	 13h, 11h, 62h, 02h, 1Dh, 11h
		db	 62h, 02h, 16h, 22h, 10h,0EBh
		db	 06h, 06h, 00h, 0Fh, 0Ah, 14h
		db	 00h, 0Fh, 0Ah, 1Ah, 00h,0F1h
		db	 09h, 00h, 13h,0A1h, 08h, 1Ch
		db	 13h, 55h, 04h, 10h, 13h, 55h
		db	 04h, 00h, 06h,0A2h, 02h, 06h
		db	 06h,0A2h, 02h, 0Ah, 05h,0FBh
		db	 01h, 00h, 11h, 62h, 02h, 00h
		db	 02h, 82h, 04h, 12h, 09h, 41h
		db	 05h, 0Ah, 0Fh,0F3h, 00h, 09h
		db	 11h,0F3h, 00h, 22h, 0Bh, 0Dh
		db	 08h, 16h, 09h, 27h, 08h, 0Eh
		db	 10h,0A2h, 0Bh, 10h, 10h,0DBh
		db	 0Dh, 25h, 00h,0F6h, 0Ah, 25h
		db	 04h,0F6h, 0Ah, 00h, 06h, 77h
		db	 04h, 1Dh, 00h, 00h, 0Fh, 0Ah
		db	 12h, 00h, 0Fh, 0Ah, 0Ah, 01h
		db	0F1h, 09h, 00h, 00h, 82h, 04h
		db	 00h, 10h,0FFh, 06h, 00h, 13h
		db	 09h, 05h, 19h, 03h,0FDh, 00h
		db	 22h, 00h, 0Fh, 03h, 1Ch, 00h
		db	 0Fh, 03h, 16h, 00h, 0Fh, 03h
		db	 10h, 00h, 0Fh, 03h, 10h, 03h
		db	0FDh, 00h, 19h, 0Eh,0FDh, 00h
		db	 17h, 0Fh,0D5h, 00h, 1Eh, 0Fh
		db	0D5h, 00h, 21h, 0Fh,0D5h, 00h
		db	 10h, 04h, 4Fh, 06h, 06h, 0Dh
		db	 24h, 0Ch, 11h, 0Eh,0FDh, 00h
		db	 10h, 0Fh,0D5h, 00h, 0Eh, 11h
		db	0F3h, 00h, 00h, 0Bh, 0Dh, 08h
		db	 00h, 00h,0F6h, 0Ah, 00h, 04h
		db	0F6h, 0Ah, 18h, 04h, 4Fh, 06h
		db	 1Ch, 09h, 44h, 0Bh, 1Ch, 0Dh
		db	0EAh, 09h, 21h, 0Dh,0EAh, 09h
		db	 23h, 0Dh,0EAh, 09h, 10h, 0Bh
		db	 07h, 79h, 03h, 14h, 07h, 79h
		db	 03h, 00h, 06h,0FFh, 02h, 00h
		db	 13h, 78h, 02h, 01h, 0Bh,0FFh
		db	 06h, 14h, 10h, 63h, 04h, 21h
		db	 0Ch, 46h, 03h, 21h, 01h,0EEh
		db	 05h, 00h, 0Dh,0A4h, 04h, 04h
		db	 0Fh, 09h, 06h, 08h, 11h, 09h
		db	 06h, 00h, 0Dh, 09h, 06h, 00h
		db	 00h, 11h, 00h, 00h, 00h, 78h
		db	 02h, 00h, 07h,0FDh, 0Dh, 01h
		db	 0Ah, 5Ah, 0Bh, 0Bh, 00h, 13h
		db	 78h, 02h, 00h, 00h
loc_59BD:
		js	loc_59C1		; Jump if sign=1
		add	ax,[bx+di]
loc_59C1:
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,10Ch
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,115h
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,11Dh
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,0C18h
		inc	si
		add	dx,[bp+si]
		or	al,46h			; 'F'
		add	cx,[si]
		or	al,46h			; 'F'
		add	ax,data_460C
		add	ax,[bx+si]
		or	al,46h			; 'F'
		add	dx,[bx+di]
		add	[bx+si],al
;*		js	loc_59EA		;*Jump if sign=1
		db	 78h, 02h		;  Fixup - byte match
		push	es
;*		add	si,bp
		db	 01h,0EEh		;  Fixup - byte match
		add	ax,110h
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,11Ah
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,123h
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,0A25h
		xor	ax,[di]
		and	cl,[bp+di]
		mov	al,[bx+di]
		sbb	ds:data_00FD_e,cx
		adc	[bx+si],cl
		mov	al,[bx+di]
		adc	[bp+si],cl
		mov	al,[bx+di]
		sbb	byte ptr ds:[49Eh],al
		add	[bp+di],dl
		xchg	word ptr ds:[0E00h],ax
		and	al,0Ch
		push	ss
		or	sp,word ptr ss:[140Ah][bp+di]
		or	bp,[bp+si+1]
		or	ax,0FD0Eh
		add	[bx],dl
		or	bl,[bp+si]
		push	cs
		sbb	[bx+si],ax
		add	[bx+si+2],bh
		adc	al,0Bh
		push	1
		adc	[bx+si],cl
		mov	al,[bx+di]
		sbb	byte ptr ds:[49Eh],al
		add	[bp+di],dl
		xchg	word ptr ds:[0E00h],ax
		js	loc_5A43		; Jump if sign=1
		add	[bp+si],cl
loc_5A43:
		mov	al,[bx+di]
		add	ax,6A0Bh
		add	[bx+di],cx
		push	es
		sahf				; Store ah into flags
		add	al,10h
		or	dh,[bp+di]
		add	ax,825h
		xor	ax,[di]
		and	ax,8A0Ah
		add	[bp+si],sp
		or	cl,byte ptr ss:[2201h][bp+si]
		or	[bp+di],dh
		add	ax,0A1Fh
		mov	al,[bx+di]
		pop	ds
		or	[bp+di],si
		add	ax,0A17h
		sbb	cl,byte ptr ds:[104h]
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,10Eh
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,118h
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,121h
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,0F10h
		inc	sp
		or	ax,word ptr ds:[1A0Ah]
		push	cs
		or	al,0Ah
		sbb	cl,byte ptr ds:[915h]
		test	word ptr [bx+di],1Ah
		add	[bx+si+2],bh
		push	es
;*		add	si,bp
		db	 01h,0EEh		;  Fixup - byte match
		add	ax,1300h
		xchg	word ptr ds:[0E00h],ax
		js	loc_5AA0		; Jump if sign=1
		add	[bp+si],cl
loc_5AA0:
		mov	al,[bx+di]
		add	ax,6A0Bh
		add	[bx+di],cx
		push	es
		sahf				; Store ah into flags
		add	al,0
		or	[bp+di],dh
		add	ax,0A1Ch
		mov	al,[bx+di]
		pop	ds
		or	cl,byte ptr ss:[2201h][bp+si]
		or	cl,byte ptr ss:[2501h][bp+si]
		or	cl,byte ptr ss:[1C01h][bp+si]
		add	word ptr ss:[1F01h][bp+si],cx
		add	word ptr ss:[2201h][bp+si],cx
		add	word ptr ss:[2501h][bp+si],cx
		add	word ptr ss:[1C01h][bp+si],cx
		or	byte ptr ss:[1F01h][bp+si],cl
		or	byte ptr ss:[2201h][bp+si],cl
		or	byte ptr ss:[2501h][bp+si],cl
		or	byte ptr ss:[1501h][bp+si],cl
		add	[bx],cx
		add	dx,[bx]
		or	al,0F3h
		add	[di],dl
		or	al,0F3h
		add	[bx+si],dl
		or	[si+0Bh],ax
		adc	[di],cl
;*		jmp	far ptr l_1A0A_0709	;*
		db	0EAh
		dw	709h, 1A0Ah		;  Fixup - byte match
			                        ;* No entry point to code
		push	cs
		adc	al,[bx+si]
		add	[bx+si+2],bh
		add	[bp+di],dl
		xchg	word ptr ds:[0E00h],ax
		js	$+4			; Jump if sign=1
		add	[bp+si],cl
		mov	al,[bx+di]
		add	[bx+si],cl
		mov	al,[bx+di]
		add	cx,[bx+si]
		mov	al,[bx+di]
		add	cx,[bp+si]
		mov	al,[bx+di]
		add	[bx+di],al
		mov	al,[bx+di]
		add	ax,[bx+di]
		mov	al,[bx+di]
		push	ds
		db	 0Fh, 62h, 02h, 1Eh, 11h, 62h
		db	 02h, 22h, 0Ah,0BBh, 06h, 08h
		db	 01h,0EEh, 05h, 1Ch, 0Bh, 0Fh
		db	 03h, 1Ch, 01h, 23h, 03h, 17h
		db	 0Dh,0EAh, 09h, 17h, 09h, 44h
		db	 0Bh, 0Bh, 0Eh,0E3h, 0Ch, 13h
		db	 00h, 00h, 78h, 02h, 00h, 13h
		db	 87h, 06h, 00h, 0Ah,0BBh, 06h
		db	 00h, 0Eh,0FDh, 00h, 00h, 0Fh
		db	 62h, 02h, 00h, 11h, 62h, 02h
		db	 0Ah, 13h,0FDh, 00h, 19h, 13h
		db	0FDh, 00h, 22h, 0Fh,0BBh, 06h
		db	 1Ch, 0Fh,0BBh, 06h, 16h, 0Fh
		db	0BBh, 06h, 04h, 01h,0EEh, 05h
		db	 10h, 06h,0D4h, 05h, 22h, 02h
		db	0BBh, 06h, 1Ch, 02h,0BBh, 06h
		db	 16h, 02h,0BBh, 06h, 22h, 0Bh
		db	0BBh, 06h, 10h, 0Eh,0D4h, 05h
		db	 0Eh, 0Eh,0E3h, 0Ch, 17h, 00h
		db	 00h, 78h, 02h, 00h, 13h, 78h
		db	 02h, 00h, 0Fh,0BBh, 06h, 06h
		db	 0Fh,0BBh, 06h, 0Ch, 0Fh,0BBh
		db	 06h, 00h, 06h,0D4h, 05h, 00h
		db	 02h,0BBh, 06h, 06h, 02h,0BBh
		db	 06h, 15h, 01h,0EEh, 05h, 19h
		db	 0Eh,0FDh, 00h, 1Bh, 0Fh,0BBh
		db	 06h, 22h, 0Fh, 0Fh, 03h, 21h
		db	 0Fh, 0Fh, 03h, 22h, 12h, 31h
		db	 03h, 21h, 12h, 31h, 03h, 12h
		db	 06h,0E3h, 0Ch, 00h, 0Bh,0BBh
		db	 06h, 00h, 0Eh,0D4h, 05h, 14h
		db	 0Eh,0E3h, 0Ch, 1Fh, 0Ch, 23h
		db	 03h, 1Fh, 01h, 0Fh, 03h, 1Ah
		db	 0Dh,0EAh, 09h, 1Ah, 09h, 44h
		db	 0Bh, 20h, 00h, 00h, 0Fh, 0Ah
		db	 11h, 00h, 0Fh, 0Ah, 15h, 02h
		db	 82h, 04h, 00h, 04h, 0Fh, 03h
		db	 09h, 00h,0F1h, 09h, 00h, 01h
		db	 0Fh, 03h, 00h, 00h, 31h, 03h
		db	 00h, 13h, 99h, 07h, 00h, 13h
		db	0FDh, 00h, 19h, 13h,0FDh, 00h
		db	 06h, 05h,0D1h, 01h, 1Ch, 06h
		db	0D1h, 01h, 17h, 04h, 0Fh, 03h
		db	 11h, 04h, 0Fh, 03h, 0Bh, 04h
		db	 0Fh, 03h, 06h, 04h, 0Fh, 03h
		db	 00h, 0Eh,0FDh, 00h, 00h, 11h
		db	0F3h, 00h, 00h, 0Fh,0F3h, 00h
		db	 15h, 07h,0F3h, 00h, 22h, 04h
		db	 0Fh, 03h, 1Dh, 04h, 0Fh, 03h
		db	 22h, 07h, 0Fh, 03h, 22h, 0Ah
		db	 0Fh, 03h, 01h, 0Fh,0D5h, 00h
		db	 08h, 0Fh,0D5h, 00h, 0Bh, 11h
		db	0F3h, 00h, 1Bh, 12h,0EAh, 09h
		db	 1Bh, 0Eh, 44h, 0Bh, 20h, 12h
		db	 31h, 03h, 20h, 0Ah, 0Fh, 03h
		db	 23h, 12h,0EAh, 09h, 1Bh, 00h
		db	 00h, 0Fh, 0Ah, 11h, 00h, 0Fh
		db	 0Ah, 00h, 04h, 0Fh, 03h, 11h
		db	 04h, 0Fh, 03h, 00h, 12h, 31h
		db	 03h, 00h, 07h, 0Fh, 03h, 00h
		db	 0Ah, 0Fh, 03h, 0Dh, 05h,0D1h
		db	 01h, 1Ch, 05h,0D1h, 01h, 0Bh
		db	 04h, 0Fh, 03h, 06h, 04h, 0Fh
		db	 03h, 00h, 13h,0FDh, 00h, 0Ch
		db	 13h,0FDh, 00h, 15h, 10h, 0Fh
		db	 03h, 15h, 0Dh, 0Fh, 03h, 15h
		db	 07h, 23h, 03h, 1Ah, 01h, 0Fh
		db	 0Ah, 1Fh, 04h, 0Fh, 03h, 1Dh
		db	 04h, 0Fh, 03h, 17h, 04h, 0Fh
		db	 03h, 0Ah, 13h, 45h, 02h, 0Ch
		db	 13h, 45h, 02h, 1Bh, 0Bh,0A3h
		db	 0Ah, 20h, 07h, 40h, 00h, 20h
		db	 0Ah, 40h, 00h, 02h, 01h,0F1h
		db	 09h, 1Dh, 00h, 82h, 04h, 1Eh
		db	 15h, 00h, 0Fh, 03h, 15h, 03h
		db	 0Fh, 03h, 05h, 00h, 0Fh, 03h
		db	 00h, 00h, 0Fh, 03h, 00h, 03h
		db	 40h, 00h, 00h, 09h, 40h, 00h
		db	 0Bh, 00h, 0Fh, 03h, 25h, 07h
		db	 43h, 0Ah, 25h, 0Dh, 43h, 0Ah
		db	 1Fh, 06h,0EEh, 04h, 00h, 13h
		db	0FDh, 00h, 15h, 11h, 0Fh
data_5D07	db	3
		db	 15h, 0Eh, 0Fh, 03h, 15h, 0Bh
		db	 0Fh, 03h, 02h, 09h,0F3h, 00h
		db	 1Eh, 08h, 64h, 0Bh, 1Eh, 0Eh
		db	 64h, 0Bh, 1Bh, 00h,0A3h, 0Ah
		db	 1Bh, 09h,0A3h, 0Ah, 1Bh, 0Bh
		db	0A3h, 0Ah, 20h, 00h, 40h, 00h
		db	 20h, 0Ah, 40h, 00h, 06h, 13h
		db	0FDh, 00h, 24h, 04h,0DBh, 0Dh
		db	 26h, 04h,0A2h, 0Bh, 11h, 00h
		db	 0Fh, 03h, 0Ah, 13h, 45h, 02h
		db	 04h, 03h,0E3h, 0Dh, 0Fh, 03h
		db	 0Eh, 0Eh, 0Bh, 03h, 40h, 00h
		db	 18h, 15h, 00h, 0Fh, 03h, 15h
		db	 03h, 0Fh, 03h, 00h, 0Ah, 40h
		db	 00h, 00h, 00h, 40h, 00h, 00h
		db	 00h, 23h, 03h, 04h, 00h, 0Fh
		db	 03h, 0Ah, 00h, 0Fh, 03h, 10h
		db	 00h, 0Fh, 03h, 1Eh, 00h, 64h
		db	 0Bh, 1Eh, 06h, 64h, 0Bh, 1Eh
		db	 0Ch, 64h, 0Bh, 1Eh, 0Eh, 64h
		db	 0Bh, 1Bh, 00h,0A3h, 0Ah, 1Bh
		db	 09h,0A3h, 0Ah, 20h, 00h, 40h
		db	 00h, 20h, 0Ah, 40h, 00h, 15h
		db	 06h, 23h, 03h, 15h, 08h, 23h
		db	 03h, 1Bh, 0Bh,0A3h, 0Ah, 15h
		db	 11h, 0Fh, 03h, 15h, 0Eh, 0Fh
		db	 03h, 02h, 10h,0D5h, 00h, 09h
		db	 10h,0D5h, 00h, 02h, 0Ah,0F3h
		db	 00h, 1Eh, 17h, 0Ah, 40h, 00h
		db	 17h, 00h, 40h, 00h, 17h, 08h
		db	0D5h, 06h, 1Eh, 0Eh, 64h, 0Bh
		db	 20h, 0Ah, 40h, 00h, 00h, 06h
		db	 91h, 0Ch, 1Eh, 00h, 64h, 0Bh
		db	 1Eh, 06h, 64h, 0Bh, 1Bh, 07h
		db	0A3h, 0Ah, 1Bh, 00h,0A3h, 0Ah
		db	 20h, 00h, 40h, 00h, 23h, 08h
		db	0D5h, 06h, 0Bh, 05h,0D5h, 06h
		db	 0Dh, 05h,0D5h, 06h, 24h, 06h
		db	0F3h, 00h, 24h, 0Eh,0F3h, 00h
		db	 00h, 00h,0FDh, 00h, 20h, 08h
		db	 40h, 00h, 00h, 0Ah, 40h, 00h
		db	 00h, 08h,0D5h, 06h, 00h, 13h
		db	 99h, 07h, 0Ah, 11h, 23h, 03h
		db	 16h, 0Ah,0D5h, 06h, 00h, 0Dh
		db	 23h, 03h, 09h, 08h,0F3h, 00h
		db	 17h, 10h,0D5h, 00h, 1Eh, 10h
		db	0D5h, 00h, 21h, 10h,0D5h, 00h
		db	 22h, 0Ah,0D5h, 06h, 22h, 0Ah
		db	 44h, 0Bh, 16h, 00h, 13h, 99h
		db	 07h, 00h, 0Ah, 40h, 00h, 00h
		db	 08h,0D5h, 06h, 24h, 0Ah, 40h
		db	 00h, 23h, 08h,0D5h, 06h, 12h
		db	 09h, 40h, 00h, 21h, 04h,0D5h
		db	 00h, 1Bh, 04h,0D5h, 00h, 0Dh
		db	 00h,0D5h, 00h, 06h, 00h,0D5h
		db	 00h, 00h, 04h,0D5h, 00h, 1Bh
		db	 08h,0D5h, 06h, 1Eh, 00h, 64h
		db	 0Bh, 06h, 04h,0D5h, 00h, 00h
		db	 00h, 64h, 0Bh, 19h, 00h,0FDh
		db	 00h, 14h, 00h,0D5h, 00h, 17h
		db	 00h,0D5h, 00h, 23h, 01h,0D5h
		db	 06h, 22h, 05h,0E3h, 0Ch, 1Eh
		db	 01h,0D5h, 06h, 1Eh, 05h,0E3h
		db	 0Ch, 1Eh, 00h, 13h, 99h, 07h
		db	 00h, 0Ah, 40h, 00h, 24h, 0Ah
		db	 40h, 00h, 00h, 00h,0AAh, 0Bh
		db	 00h, 02h, 99h, 07h, 00h, 04h
		db	 40h, 00h, 00h, 03h, 78h, 02h
		db	 10h, 10h, 0Fh, 03h, 10h, 0Dh
		db	 0Fh, 03h, 04h, 0Dh, 0Fh, 03h
		db	 04h, 10h, 0Fh, 03h, 04h, 0Ch
		db	0FDh, 00h, 10h, 0Ch,0FDh, 00h
		db	 24h, 04h, 40h, 00h, 23h, 08h
		db	0D5h, 06h, 21h, 00h,0D5h, 00h
		db	 04h, 04h, 24h, 0Eh, 06h, 04h
		db	 24h, 0Eh, 08h, 04h, 24h, 0Eh
		db	 0Ah, 04h, 24h, 0Eh, 0Ch, 04h
		db	 24h, 0Eh, 0Eh, 04h, 24h, 0Eh
		db	 10h, 04h, 24h, 0Eh, 12h, 04h
		db	 24h, 0Eh, 14h, 04h, 24h, 0Eh
		db	 16h, 04h, 24h, 0Eh, 18h, 04h
		db	 24h, 0Eh, 1Ah, 04h, 24h, 0Eh
		db	 09h, 07h, 3Eh, 0Eh, 1Ch, 04h
		db	 24h, 0Eh, 2Ch, 00h, 00h,0FDh
		db	 00h, 00h, 09h,0FDh, 00h, 00h
		db	 13h,0FDh, 00h, 02h, 13h,0FDh
		db	 00h, 09h, 0Ch,0C0h, 05h, 09h
		db	 0Fh,0ACh, 05h, 09h, 10h, 87h
		db	 03h, 03h, 10h,0ACh, 05h, 03h
		db	 0Dh,0C0h, 05h, 03h, 0Bh,0C0h
		db	 05h, 02h, 09h,0FDh, 00h, 03h
		db	 05h, 33h, 05h, 06h, 05h, 33h
		db	 05h, 06h, 04h, 8Ah, 01h, 17h
		db	 08h,0E3h, 0Ch, 12h, 00h, 78h
		db	 0Dh, 12h, 0Ah, 78h, 0Dh, 10h
		db	 00h, 30h, 0Bh, 10h, 09h, 30h
		db	 0Bh, 10h, 0Bh, 30h, 0Bh, 01h
		db	 00h,0FDh, 00h, 0Bh, 02h, 98h
		db	 04h, 16h, 10h, 79h, 06h, 0Ah
		db	 07h, 21h, 07h, 0Bh, 0Ah,0F7h
		db	 01h, 25h, 00h,0F6h, 0Ah, 25h
		db	 06h,0F6h, 0Ah, 25h, 0Eh,0F6h
		db	 0Ah, 25h, 0Ah,0F6h, 0Ah, 20h
		db	 07h, 7Dh, 0Eh, 24h, 00h, 14h
		db	 0Eh, 24h, 04h, 14h, 0Eh, 23h
		db	 0Ah, 27h, 07h, 22h, 0Bh, 1Bh
		db	 07h, 24h, 06h, 14h, 0Eh, 1Fh
		db	 0Eh,0EBh, 06h, 20h, 10h,0F3h
		db	 00h, 24h, 10h
loc_5F93:
		db	0F3h, 00h, 10h, 05h,0D5h, 06h
		db	 11h, 05h,0D5h, 06h, 12h, 0Ah
		db	 3Ah, 00h, 14h, 07h,0FFh, 06h
		db	 14h, 09h,0F3h, 00h, 05h, 09h
		db	0FDh, 00h, 22h, 00h, 00h,0AAh
		db	 0Bh, 00h, 03h,0AAh, 0Bh, 00h
		db	 06h,0AAh, 0Bh, 00h, 11h,0AAh
		db	 0Bh, 00h, 0Eh,0AAh, 0Bh, 23h
		db	 06h,0D5h, 06h, 21h, 0Ch,0D5h
		db	 00h, 21h, 10h,0D5h, 00h, 18h
		db	 0Eh,0D5h, 06h, 18h, 0Fh,0D5h
		db	 06h, 18h, 13h, 45h, 02h, 1Dh
		db	 0Eh,0D5h, 00h, 1Ah, 07h,0D5h
		db	 06h, 21h, 0Ah,0F3h, 00h, 00h
		db	 0Eh,0D5h, 00h, 07h, 0Eh,0D5h
		db	 00h, 0Eh, 0Eh,0D5h, 00h, 11h
		db	 0Eh,0D5h, 00h, 1Eh, 06h,0D5h
		db	 06h, 1Eh, 02h,0D5h, 06h, 1Ah
		db	 05h,0F3h, 00h, 17h, 07h,0F3h
		db	 00h, 00h, 07h,0F3h, 00h, 1Eh
		db	 02h,0F3h, 00h, 22h, 02h,0F3h
		db	 00h, 24h, 04h,0F3h, 00h, 23h
		db	 04h,0EBh, 0Ch, 04h, 08h,0F3h
		db	 00h, 08h, 09h,0F3h, 00h, 0Bh
		db	 06h, 0Fh, 03h, 11h, 07h,0F3h
		db	 00h, 14h, 07h,0F3h, 00h, 06h
		db	 06h,0F3h, 00h, 22h, 09h, 0Fh
		db	 03h, 11h, 0Ch, 0Dh,0A4h, 04h
		db	 00h, 07h,0A4h, 04h, 00h, 00h
		db	0EBh, 06h, 00h, 0Fh, 62h, 02h
		db	 00h, 0Dh, 62h, 02h, 00h, 11h
		db	 62h, 02h, 0Ah, 0Dh, 01h, 00h
		db	 00h, 13h, 78h, 02h, 1Eh, 0Ch
		db	 7Bh, 0Ch, 24h, 05h, 40h, 00h
		db	 24h, 09h, 40h, 00h, 22h, 10h
		db	0EBh, 06h
loc_6067:
		sbb	ax,0EB10h
		push	es
		add	[si],al
		js	loc_6071		; Jump if sign=1
		add	[bp+di],al
loc_6071:
;*		aad	6			; undocumented inst
		db	0D5h, 06h		;  Fixup - byte match
		add	[bp+di],al
		or	[di],ax
		adc	ax,[di]
		lodsb				; String [si] to al
		or	[bp+si],dx
		add	[bp+di],al
		js	$+4			; Jump if sign=1
		add	[bx+si],al
		stosb				; Store al to es:[di]
		or	ax,[bx+si]
		adc	dx,sp
		add	ax,424h
		inc	ax
		add	[bx+si],dl
		adc	dx,sp
		add	ax,400h
		inc	ax
		add	[bp+di],ah
		or	dl,ch
		push	es
		add	[bp+si],cl
;*		aad	6			; undocumented inst
		db	0D5h, 06h		;  Fixup - byte match
		and	[bp+di],cx
		db	0DDh, 08h, 1Bh, 0Bh, 39h, 09h
		db	 16h, 0Bh, 0Fh, 09h, 00h, 0Bh
		db	 82h, 09h, 11h, 0Bh, 0Fh, 09h
		db	 0Ch, 0Bh, 0Fh, 09h, 03h, 0Bh
		db	0DDh, 08h, 06h, 0Bh, 39h, 09h
		db	 08h, 04h,0ACh, 09h, 17h, 04h
		db	0ACh, 09h, 12h, 00h, 04h, 78h
		db	 02h, 00h, 03h, 09h, 05h, 23h
		db	 00h,0FFh, 06h, 00h, 05h, 40h
		db	 00h, 00h, 09h, 40h, 00h, 05h
		db	 0Ch, 7Bh, 0Ch, 00h, 10h,0FFh
		db	 06h, 04h, 10h,0FFh, 06h, 06h
		db	 10h,0FFh, 06h, 23h, 04h,0D5h
		db	 06h, 0Fh, 0Dh, 24h, 0Ch, 1Bh
		db	 07h, 24h, 0Ch, 1Ch, 0Dh, 62h
		db	 02h, 1Ch, 0Fh, 62h, 02h, 1Ch
		db	 11h, 62h, 02h, 26h, 0Dh, 01h
		db	 00h, 00h, 13h, 78h, 02h, 09h
		db	 05h,0ACh, 09h, 1Bh, 00h, 13h
		db	 78h, 02h, 0Ch, 04h
loc_6114:
		rol	word ptr [bx+di],1	; Rotate
		add	[bx+si],al
		xchg	cx,ax
		or	al,19h
		add	al,0FDh
		add	[bx+di],ah
		add	ax,7Bh
		or	al,0Ah
		sahf				; Store ah into flags
		add	al,1Ah
		add	ax,7Bh
		sbb	cl,[bx+di]
		jnp	$+2			; delay for I/O
		and	[bx+di],cx
		jnp	$+2			; delay for I/O
		sbb	al,9
		in	ax,dx			; port 0FFA0h ??i/o non-standard
		or	ax,925h
		in	ax,dx			; port 0FFA0h ??i/o non-standard
		or	ax,0F1Dh
		retf
			                        ;* No entry point to code
		or	[bx+si],ah
		pop	es
		push	cs
		add	[si],cx
		db	 0Fh, 1Ah, 0Eh, 07h, 10h, 6Ah
		db	 01h, 14h, 05h, 7Bh, 00h, 14h
		db	 09h, 7Bh, 00h, 12h, 02h, 40h
		db	 00h, 12h, 11h,0F3h, 00h, 11h
		db	 0Ch,0D5h, 06h, 11h, 0Dh,0D5h
		db	 06h, 16h, 12h,0EAh, 09h, 16h
		db	 0Eh, 44h, 0Bh, 16h, 04h,0FDh
		db	 00h, 00h, 0Ch, 98h, 01h, 00h
		db	 02h, 01h, 00h, 00h, 09h,0F3h
		db	 00h, 19h, 00h, 13h, 78h, 02h
		db	 0Dh, 00h, 0Fh, 0Ah, 18h, 00h
		db	0F1h, 09h, 22h, 12h, 31h, 03h
		db	 04h, 0Fh,0A4h, 09h, 00h, 09h
		db	 40h, 00h, 00h, 12h, 31h, 03h
		db	 24h, 05h, 40h, 00h, 00h, 05h
		db	 91h, 0Ch, 0Eh, 10h, 6Ah, 01h
		db	 08h, 10h,0CAh, 00h, 00h, 07h
		db	0F3h, 00h, 1Bh, 11h, 21h, 07h
		db	 13h, 0Eh, 9Ch, 09h, 10h, 0Eh
		db	0F7h, 01h, 04h, 09h,0CBh, 08h
		db	 09h, 09h,0CBh, 08h, 1Ch, 09h
		db	0CBh, 08h, 17h, 09h,0CBh, 08h
		db	 13h, 08h, 9Eh, 04h, 17h, 0Ch
		db	0CBh, 08h, 04h, 0Ch,0CBh, 08h
		db	 09h, 0Ch,0CBh, 08h, 1Ch, 0Ch
		db	0CBh, 08h, 00h, 00h, 82h, 04h
		db	 18h, 00h, 13h, 78h, 02h, 00h
		db	 00h,0AAh, 0Bh, 00h, 03h,0AAh
		db	 0Bh, 00h, 09h, 2Dh, 07h, 00h
		db	 09h, 23h, 03h, 19h, 09h, 40h
		db	 00h, 19h, 00h, 40h, 00h, 15h
		db	 11h,0F3h, 00h, 14h, 00h, 40h
		db	 00h, 16h, 00h,0A3h, 0Ah, 16h
		db	 08h,0A3h, 0Ah, 1Dh, 11h,0F3h
		db	 00h, 1Dh, 0Bh, 64h, 0Bh, 1Dh
		db	 05h, 64h, 0Bh, 00h, 04h,0F3h
		db	 00h, 04h, 03h, 0Fh, 03h, 0Ah
		db	 04h,0F3h, 00h, 0Dh, 02h,0D5h
		db	 00h, 21h, 11h,0F3h, 00h, 24h
		db	 11h,0F3h, 00h, 25h, 06h, 43h
		db	 0Ah, 25h, 0Ah, 43h, 0Ah, 07h
		db	 10h,0A2h, 0Bh, 09h, 10h,0A2h
		db	 0Bh, 27h, 00h, 00h, 0Fh, 0Ah
		db	 17h, 00h, 0Fh, 0Ah, 13h, 01h
		db	0F1h, 09h, 00h, 00h, 82h, 04h
		db	 00h, 11h,0AAh, 0Bh, 00h, 07h
		db	0A1h, 08h, 19h, 06h,0EEh, 04h
		db	 1Dh, 04h, 82h, 04h, 00h, 13h
		db	 39h, 03h, 26h, 0Bh, 01h, 00h
		db	 23h, 0Eh,0D5h, 06h, 1Eh, 0Eh
		db	0D5h, 06h, 14h, 11h, 39h, 03h
		db	 0Ah, 11h, 39h, 03h, 02h, 0Fh
		db	0D5h, 06h, 07h, 0Fh,0D5h, 06h
		db	 0Ah, 0Dh, 01h, 00h, 09h, 0Dh
		db	0D5h, 06h, 04h, 06h,0EEh, 04h
		db	 04h, 04h,0A2h, 0Bh, 07h, 04h
		db	0DBh, 0Dh, 09h, 04h,0A2h, 0Bh
		db	 0Eh, 0Fh,0CBh, 08h, 0Fh, 0Dh
		db	 9Ch, 09h, 17h, 09h,0D1h, 01h
		db	 00h, 08h,0AAh, 0Bh, 00h, 0Ah
		db	 87h, 06h, 00h, 00h, 40h, 00h
		db	 03h, 0Ah, 01h, 00h, 03h, 0Dh
		db	 01h, 00h, 00h, 0Ah, 40h, 00h
		db	 14h, 0Dh,0F7h, 01h, 19h, 0Fh
		db	 21h, 07h, 05h, 0Bh, 08h, 0Eh
		db	 05h, 0Fh, 08h, 0Eh, 1Dh, 13h
		db	 39h, 03h, 17h, 12h, 39h, 03h
		db	 22h, 0Fh,0D5h, 06h, 23h, 0Fh
		db	0D5h, 06h, 16h, 00h, 00h, 0Fh
		db	 0Ah, 07h, 00h, 0Fh, 0Ah, 1Ah
		db	 00h, 0Fh, 0Ah, 0Eh, 0Eh,0D5h
		db	 06h, 0Eh, 0Fh,0D5h, 06h, 00h
		db	 13h, 09h, 05h, 22h, 12h, 31h
		db	 03h, 14h, 01h,0F1h, 09h, 05h
		db	 04h, 82h, 04h, 11h, 13h, 6Ah
		db	 00h, 22h, 00h, 0Fh, 03h, 22h
		db	 03h, 0Fh, 03h, 22h, 06h, 23h
		db	 03h, 24h, 08h, 4Fh, 06h, 0Ch
		db	 13h, 6Ah, 00h, 09h, 09h, 41h
		db	 05h, 00h, 00h, 7Bh, 00h, 00h
		db	 03h, 7Bh, 00h, 01h, 0Dh,0FDh
		db	 0Dh, 00h, 12h,0EAh, 09h, 02h
		db	 0Fh, 5Ah, 0Bh, 00h, 02h, 1Ch
		db	 01h
data_6336	db	1
		db	 00h, 96h, 00h, 0Fh, 01h, 60h
		db	 01h,0A1h, 01h,0E6h, 01h, 47h
		db	 02h,0A8h, 02h,0E9h, 02h, 5Ah
		db	 03h,0BBh, 03h, 38h, 04h, 99h
		db	 04h,0F2h, 04h, 5Fh, 05h,0C4h
		db	 05h, 35h, 06h,0B2h, 06h, 13h
		db	 07h, 88h, 07h,0C9h, 07h, 1Eh
		db	 08h, 87h, 08h,0D8h, 08h, 41h
		db	 09h,0AAh, 09h,0EBh, 09h, 64h
		db	 0Ah,0ADh, 0Ah,0CAh, 0Ah, 0Bh
		db	 0Bh, 6Ch, 0Bh,0C9h, 0Bh, 12h
		db	 0Ch, 83h, 0Ch,0F4h, 0Ch, 65h
		db	 0Dh, 1Eh, 0Eh, 63h, 0Eh,0C4h
		db	 0Eh, 29h, 0Fh, 8Ah, 0Fh,0EBh
		db	 0Fh, 2Ch, 10h, 85h, 10h,0FAh
		db	 10h, 3Bh, 11h, 68h, 11h,0ADh
		db	 11h, 12h, 12h, 7Bh, 12h,0C4h
		db	 12h, 11h, 13h, 6Eh, 13h,0EFh
		db	 13h, 5Ch, 14h,0D5h, 14h, 36h
		db	 15h,0AFh, 15h, 08h, 16h, 81h
		db	 16h, 32h, 17h,0BBh, 17h, 00h
		db	 18h, 49h, 18h, 92h, 18h,0FFh
		db	 18h, 64h, 19h,0C5h, 19h, 62h
		db	 1Ah
		db	18 dup (0)
		db	0A8h, 3Ah,0A8h, 2Ah, 88h, 2Ah
		db	 00h, 00h, 3Ah,0A8h, 2Ah,0A8h
		db	 2Ah, 88h, 0Fh,0FFh, 3Ah,0AAh
		db	 3Eh,0AAh, 3Bh,0AAh, 3Eh,0AAh
		db	 3Bh,0AAh, 0Eh,0EAh, 00h, 00h
		db	0FFh,0CCh,0AAh,0A2h,0AAh, 88h
		db	0AAh,0A2h,0AAh, 88h,0AAh, 22h
		db	 88h, 88h, 00h, 00h, 0Fh,0CFh
		db	 35h, 71h, 95h, 45h,0A5h, 55h
		db	 99h
data_640B	dw	0A555h
		db	 65h, 2Ah, 82h, 00h, 00h,0F3h
		db	0FFh, 57h,0F7h, 5Dh,0D5h, 54h
		db	 15h,0DFh, 45h,0F7h,0D5h,0A8h
		db	 2Ah, 00h, 00h,0FFh,0F0h, 55h
		db	 5Ch, 7Dh, 14h, 50h, 54h, 45h
		db	 54h, 54h, 50h, 22h, 80h, 00h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 2Ah, 02h,0A8h, 2Ah, 80h,0A8h
		db	 00h, 80h, 00h, 00h, 00h, 00h
		db	 00h, 3Dh,0FFh,0F7h,0FFh,0E6h
		db	 6Ah, 00h, 00h, 3Dh,0FFh,0F7h
		db	0FFh,0E6h, 6Ah, 00h, 00h,0FCh
		db	 60h,0FFh, 18h,0AAh,0A8h, 00h
		db	 00h,0FCh, 60h,0FFh, 18h,0AAh
		db	0A8h,0AAh,0A8h, 00h, 28h,0A0h
		db	0A8h, 82h,0A8h, 0Ah,0A3h, 2Ah
		db	 0Ch, 28h,0FFh, 28h,0FFh, 42h
		db	 65h, 41h, 99h, 00h, 00h, 10h
		db	 99h, 10h, 66h, 10h, 99h, 10h
		db	 66h, 10h, 99h, 55h, 55h, 55h
		db	 55h, 00h, 00h
		db	'UWUWUWUWUW'
		db	 05h, 50h, 55h, 50h, 55h, 00h
		db	 50h, 00h
		db	15 dup (0)
		db	 0Fh, 00h,0FAh, 0Fh,0A0h,0FAh
		db	 0Ah, 00h,0A5h,0AFh, 00h, 0Ah
		db	0F0h,0A0h,0AFh,0AAh, 0Ah, 5Ah
		db	0A0h, 05h,0AAh, 00h, 5Ah, 00h
		db	 05h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0F0h, 00h,0AFh, 00h, 0Ah
		db	0F0h,0A0h,0AFh,0AAh, 00h, 06h
		db	0A0h, 05h, 8Ah, 00h, 5Ah, 00h
		db	 05h
		db	8 dup (0)
		db	 19h, 17h, 15h, 53h, 11h, 5Fh
		db	 19h, 7Dh, 05h, 47h, 11h, 7Dh
		db	 18h, 5Fh, 05h, 53h, 2Ah,0AAh
		db	 2Ah,0AAh, 22h, 22h, 08h, 88h
		db	 2Ah,0AAh, 2Ah,0AAh, 2Ah,0AAh
		db	 2Ah,0AAh,0FFh,0C3h,0FFh,0C3h
		db	 00h, 00h,0FFh, 0Ch,0FFh, 0Ch
		db	0FFh, 0Ch,0FFh, 0Ch,0FFh, 0Ch
		db	 00h, 00h,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h,0AAh,0AAh, 00h, 00h
		db	 55h, 55h, 3Dh,0DDh, 43h, 47h
		db	0DCh, 5Ch, 55h, 77h, 1Fh,0FDh
		db	0F3h, 3Fh,0D5h, 88h,0F5h, 60h
		db	0F1h, 88h,0CDh,0E0h,0F5h, 88h
		db	 15h, 20h,0D5h, 88h, 5Dh, 20h
		db	0F7h,0DCh,0FFh, 7Fh,0FFh,0FFh
		db	0FCh,0D3h, 1Fh,0F7h, 7Fh,0FFh
		db	0F3h,0FFh,0DFh,0CFh, 00h, 00h
		db	0FFh,0FFh, 55h, 57h,0D5h,0D5h
		db	 55h,0D5h, 57h, 5Dh, 5Dh, 55h
		db	0AAh,0AAh, 00h, 00h, 45h, 45h
		db	 53h, 77h,0BFh,0FFh,0FFh,0FFh
		db	0FFh,0EFh,0FEh,0BBh,0FFh,0FFh
		db	 00h,0FAh, 0Fh,0A0h,0FAh, 0Ah
		db	0A0h,0A5h, 0Ah, 55h,0A5h, 50h
		db	 55h, 00h, 50h, 00h, 3Ch,0C8h
		db	0F3h, 20h,0CCh, 88h, 33h, 20h
		db	0CCh, 88h, 22h, 28h,0A2h, 80h
		db	 00h, 00h,0BFh,0FEh,0EBh,0CCh
		db	0FEh, 33h,0FCh,0CCh, 23h, 33h
		db	0CCh,0CCh, 88h, 2Ah, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	0FFh, 33h,0CCh,0CCh, 33h, 33h
		db	 88h, 88h, 00h, 00h, 15h, 3Fh
		db	 05h,0FFh, 17h,0FEh, 15h,0ECh
		db	 05h, 32h, 14h,0CCh, 02h, 22h
		db	 00h, 00h,0AAh,0AAh, 82h, 0Bh
		db	0AAh,0AAh, 82h, 0Bh,0AAh,0AAh
		db	 82h, 0Bh,0AAh,0AAh, 00h, 00h
		db	 24h, 5Fh, 25h, 57h, 0Bh, 35h
		db	 25h,0C1h, 29h, 55h, 0Ah,0A2h
		db	 00h, 88h, 00h, 00h, 00h, 00h
		db	 51h, 20h,0FFh,0C8h,0FFh, 28h
		db	0FFh,0C8h,0FFh, 20h,0FCh,0C8h
		db	0F3h, 20h, 00h, 00h, 01h, 15h
		db	 17h,0D4h, 17h,0FFh, 37h,0FFh
		db	 07h,0FFh, 13h,0FFh, 07h,0FFh
		db	0AAh,0A8h,0FFh,0F8h,0AAh,0A8h
		db	0FFh,0F8h,0AAh,0A8h,0FFh,0F8h
		db	0AAh,0A8h, 00h, 00h, 01h,0C0h
		db	 00h, 00h, 01h,0C0h, 00h, 00h
		db	 01h,0C0h, 00h, 00h, 01h,0C0h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h, 55h, 55h, 57h, 15h
		db	 54h, 15h, 55h, 55h, 55h, 55h
		db	 55h, 55h, 57h, 15h, 54h, 15h
		db	0FFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h, 00h, 00h, 0Ah, 85h
		db	 0Ah, 85h, 0Ah, 85h, 0Ah, 81h
		db	0AAh,0A8h,0AAh,0A8h, 00h, 00h
		db	 00h, 00h,0AAh,0A8h,0AAh,0A8h
		db	 0Ah, 80h, 0Ah, 85h, 0Ah, 85h
		db	 0Ah, 85h, 0Ah, 85h, 0Ah, 85h
		db	 2Ah,0AAh, 00h, 00h, 4Ah,0AAh
		db	 02h,0AAh, 30h,0A2h,0CCh, 28h
		db	0FFh,0CAh,0FFh,0F0h
		db	'USEUuUUQUUX'
		db	 99h,0A2h, 2Ah, 00h, 00h,0AAh
		db	0AAh, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 22h
		db	 22h,0AAh,0AAh,0DFh,0D3h, 47h
		db	 1Fh, 50h,0D7h
		db	57h
data_6699	dw	1515h, 0A6D5h		; Data table (indexed access)
		db	 22h, 88h, 88h, 00h, 00h, 55h
		db	 55h,0FFh,0FFh,0FAh,0AAh,0E8h
		db	 00h,0E0h, 00h,0E0h, 00h,0E0h
		db	 00h,0E0h, 00h, 55h, 55h,0EFh
		db	 7Dh, 8Ah, 9Ah, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 15h, 55h,0FFh,0FFh,0AAh
		db	0AFh, 00h, 07h, 00h, 07h, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 00h, 28h, 28h, 8Ah,0AAh,0AAh
		db	 8Ah,0A2h,0A2h, 88h, 88h, 22h
		db	 22h, 88h, 08h,0AAh,0AAh, 00h
		db	 00h, 55h, 55h, 57h, 15h, 54h
		db	 15h, 55h, 55h,0FFh,0FFh,0AAh
		db	0AAh, 2Ah,0AAh, 2Eh,0EEh, 3Bh
		db	0BBh, 2Eh,0EEh, 2Ah,0AAh, 2Ah
		db	0AAh, 2Ah,0CAh, 2Ah, 0Ah,0D4h
		db	 88h, 15h, 20h, 54h, 88h, 52h
		db	 20h, 48h, 88h, 22h, 20h, 8Ah
		db	 80h, 00h
		db	7 dup (0)
		db	0AAh,0AAh,0BBh,0BBh,0EEh,0EEh
		db	0BBh,0BBh,0AAh
		db	9 dup (0AAh)
		db	 88h, 88h, 22h, 22h,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0A8h,0A0h, 08h
		db	 02h, 80h, 22h,0A2h,0A0h, 00h
		db	 28h,0A8h, 00h,0A0h, 28h, 02h
		db	0A0h, 0Ah, 82h, 00h, 0Ah, 82h
		db	 2Ah, 02h, 20h, 20h, 00h,0A8h
		db	 88h, 80h, 08h, 0Ah,0AAh,0A0h
		db	0AAh, 0Fh,0A0h,0FFh, 0Fh
		db	9 dup (0FFh)
		db	 30h, 00h,0CCh,0CCh,0B3h,0F3h
		db	0AAh,0EEh,0A9h,0A9h, 9Ah, 9Ah
		db	 66h,0A6h,0A9h, 99h
		db	8 dup (0FFh)
		db	 5Fh,0FFh,0A5h,0FFh,0AAh, 5Fh
		db	0AAh,0A5h,0AAh,0AAh,0FFh,0FFh
		db	 88h, 88h, 22h, 22h, 88h, 88h
		db	 22h, 22h,0FFh,0FFh,0AAh,0AAh
		db	 2Ah,0AAh, 2Ah,0CAh, 2Ah, 0Ah
		db	 2Ah,0AAh, 08h, 88h, 22h, 22h
		db	 08h, 88h, 22h, 22h, 00h, 00h
		db	0AAh, 00h,0FEh, 80h,0ABh,0A0h
		db	0AAh,0E8h, 2Ah,0B8h, 8Ah,0B8h
		db	 22h,0B8h, 2Ah,0CAh, 2Ah, 0Ah
		db	 2Ah,0AAh, 2Ah,0AAh, 2Ah,0AAh
		db	 08h, 88h, 22h, 22h, 2Ah,0AAh
		db	0AAh,0AAh, 88h, 88h, 22h, 22h
		db	 88h, 88h
		db	 22h, 22h
		db	22 dup (0)
		db	 99h, 99h, 66h, 66h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 22h, 22h
		db	 88h, 88h, 00h, 00h, 0Ah,0A8h
		db	 28h, 22h,0A0h, 82h,0A0h,0A8h
		db	0A0h, 00h,0A8h, 02h, 22h,0AAh
		db	 0Ah,0A8h,0AAh,0AAh
		db	0Ah, ' ', 0Ah, ' ', 0Ah, ' ', 0Ah
		db	' ', 0Ah, ' ', 8, ' '
		db	 02h, 80h, 00h, 00h, 0Fh, 3Fh
		db	 18h, 1Dh, 11h, 55h, 15h, 1Dh
		db	 19h, 54h, 1Ch,0DFh, 0Fh,0FFh
		db	'UUUUUUUU'
		db	8 dup (0FAh)
		db	 00h, 00h,0FFh,0E0h, 15h, 28h
		db	 47h,0A0h, 5Fh,0C8h,0D7h,0A0h
		db	0F3h,0E8h, 3Fh, 20h, 10h, 10h
		db	 04h, 40h, 10h, 44h, 41h, 15h
		db	 55h, 51h, 11h, 10h, 00h, 4Ah
		db	0A2h, 02h, 00h, 04h, 10h, 10h
		db	 04h, 41h, 04h, 51h, 55h, 45h
		db	0A1h, 11h, 88h, 48h, 00h, 28h
		db	 00h, 00h,0AAh,0AAh,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0AAh, 88h, 88h
		db	 22h, 22h, 00h, 00h, 02h,0A8h
		db	0ABh,0FCh,0FEh,0A8h,0AAh,0A8h
		db	0AAh,0A8h, 8Ah,0A8h, 22h, 20h
		db	 00h, 88h, 00h, 00h, 00h,0AAh
		db	 02h,0BFh, 0Ah,0EAh, 2Bh,0AAh
		db	 2Eh,0A8h, 2Eh,0A2h, 2Eh, 88h
		db	 2Eh,0A0h, 2Eh, 88h, 2Eh,0A0h
		db	 2Eh, 88h,0BAh,0A2h,0BAh,0A8h
		db	0BAh,0A2h, 00h, 00h, 2Eh,0A0h
		db	0BAh, 88h,0EAh,0A0h,0AAh, 88h
		db	0AAh, 20h, 88h, 80h, 22h, 00h
		db	 00h, 00h, 11h,0DDh, 13h, 77h
		db	 11h,0DDh, 13h, 77h, 11h,0DDh
		db	 10h, 00h, 15h, 55h, 00h, 00h
		db	 00h, 00h, 77h, 77h, 00h, 00h
		db	 77h, 77h, 00h, 00h, 77h, 77h
		db	0DDh,0DDh, 77h, 77h, 00h, 00h
		db	0BFh,0FFh,0BEh,0AAh,0BEh,0AAh
		db	0BEh,0AAh,0BEh,0AAh, 80h, 00h
		db	0AAh,0AAh, 00h, 00h,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	 00h, 00h,0FFh,0FFh,0AAh,0AAh
		db	0AAh, 9Ah,0A5h, 6Ah,0AAh,0AAh
		db	 00h, 00h,0AAh,0AAh, 00h, 00h
		db	0FFh,0FEh,0AAh,0A2h,0AAh,0A2h
		db	0AAh,0A2h,0AAh,0A2h, 00h, 02h
		db	0AAh,0AAh, 00h, 00h, 77h, 77h
		db	 00h, 00h, 17h, 77h, 10h, 00h
		db	 13h, 77h, 11h,0DDh, 13h, 77h
		db	 00h, 00h, 77h, 77h, 00h, 00h
		db	 77h, 77h, 00h, 00h, 77h, 77h
		db	0C0h, 3Dh, 7Ah,0AFh, 00h, 00h
		db	 77h, 74h, 00h, 00h, 77h, 70h
		db	 00h, 10h, 76h, 30h,0DEh, 10h
		db	 76h, 30h, 00h, 00h, 3Fh,0FCh
		db	 3Fh,0FCh, 00h, 00h,0DDh,0DDh
		db	 00h, 00h, 55h, 55h, 00h, 00h
		db	0DEh, 10h, 76h, 10h,0D6h, 10h
		db	 56h, 10h, 56h, 10h, 00h, 10h
		db	 55h, 50h, 00h, 00h, 8Ah,0AEh
		db	 20h, 00h, 22h,0B8h, 8Ah,0AEh
		db	 8Ah,0AEh, 20h, 00h, 22h,0B8h
		db	 8Ah,0AEh, 41h, 41h, 41h, 41h
		db	 40h, 01h, 50h, 05h, 54h, 15h
		db	 50h, 05h, 40h, 01h, 41h, 41h
		db	 05h, 50h, 05h, 50h, 05h, 40h
		db	 05h, 40h, 0Ah, 00h, 0Ah, 00h
		db	 0Ah, 00h, 0Ah, 00h,0F3h,0C0h
		db	0CDh, 60h, 35h, 58h, 35h, 96h
		db	 16h, 56h, 16h, 58h, 14h,0A0h
		db	 15h, 40h,0FFh,0FFh, 99h, 99h
		db	'ffUU""""'
		db	 00h, 00h, 00h, 00h, 8Ah,0ABh
		db	 8Ah,0ABh,0AAh,0ABh,0AAh,0ABh
		db	 2Ah,0ACh, 0Ah,0B0h, 15h, 54h
		db	0FFh,0FFh, 00h, 00h, 05h, 05h
		db	0AAh,0AAh
		db	8 dup (5Fh)
		db	 90h, 50h,0ABh,0AEh,0AAh,0AEh
		db	0ABh,0AEh,0AAh,0AEh,0ABh,0AEh
		db	0AAh,0B8h, 00h, 08h,0AAh,0A0h
		db	0FFh,0FFh
		db	14 dup (0FFh)
		db	 0Ah,0AAh,0F0h,0AAh,0FFh, 0Ah
		db	0FFh,0F0h
		db	8 dup (0FFh)
		db	8 dup (0)
		db	 02h, 22h, 08h,0AAh, 02h, 2Ah
		db	 00h, 00h, 00h, 88h, 02h, 2Ah
		db	 00h, 2Ah, 00h, 02h, 54h, 03h
		db	 50h, 40h, 45h, 03h, 04h, 4Fh
		db	0A8h, 00h,0A4h, 00h,0A8h, 00h
		db	0A0h,0AAh, 8Ah,0AAh, 8Ah, 22h
		db	 80h, 00h,0A4h, 00h, 00h, 00h
		db	 00h, 00h,0A0h, 00h,0A0h, 00h
		db	0AAh,0B8h,0AAh,0AEh,0AAh,0BBh
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	 0Fh, 57h, 3Dh,0D5h, 35h,0D5h
		db	 37h, 5Dh, 0Dh, 55h, 02h,0AAh
		db	 00h, 29h, 00h, 2Ah, 00h, 29h
		db	0AAh, 2Ah, 88h, 29h, 22h, 2Ah
		db	 00h, 29h, 00h, 2Ah, 00h, 00h
		db	0FFh,0F0h, 55h, 68h,0D5h, 68h
		db	 55h, 68h, 55h, 68h, 55h,0A0h
		db	0AAh, 80h, 00h, 00h, 00h, 00h
		db	 00h, 01h, 00h, 00h, 00h, 3Fh
		db	 00h, 15h, 00h, 04h, 00h, 04h
		db	 00h, 00h, 00h, 00h, 80h, 00h
		db	 00h, 00h,0FCh, 00h,0A8h, 00h
		db	 20h, 00h, 20h, 00h, 05h,0A8h
		db	 55h,0AAh, 56h,0AAh, 00h, 00h
		db	0FFh,0FFh, 6Ah,0AAh, 03h, 80h
		db	 03h, 80h, 20h, 00h, 20h, 00h
		db	 20h, 00h, 20h, 00h, 20h, 00h
		db	 80h, 00h, 80h, 00h, 00h, 00h
		db	 33h, 8Ch,0B3h, 8Eh, 33h, 8Ch
		db	 03h, 80h, 03h, 80h, 03h, 80h
		db	 02h, 80h,0FFh,0EAh, 00h, 0Ch
		db	 00h, 0Ch, 00h, 0Ch, 00h, 0Ch
		db	 00h, 0Ch, 00h, 03h, 00h, 03h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h,0A0h, 00h,0A0h, 00h
		db	0A0h, 00h,0A0h, 00h,0A0h, 00h
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	 3Fh,0FFh, 00h
		db	7 dup (0)
		db	0A8h, 02h,0A3h,0FCh, 28h, 02h
		db	 0Ah,0AAh,0CAh, 66h,0CAh, 88h
		db	0CAh, 66h,0CAh, 88h,0A0h, 00h
		db	0A0h, 00h,0A0h, 00h,0A0h, 00h
		db	0A8h, 00h,0AAh,0AAh,0AAh,0AAh
		db	 03h,0C0h
		db	10 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	 0Ah,0AAh, 08h, 02h, 0Bh,0FEh
		db	 08h, 02h, 29h, 56h,0AAh,0AAh
		db	0AAh,0AAh, 03h,0C0h, 0Ah,0B8h
		db	 22h,0B8h, 0Ah,0B8h, 22h,0B8h
		db	 8Ah,0AEh, 2Ah,0AEh, 8Ah,0AEh
		db	 00h, 00h,0A0h, 00h,0AAh, 00h
		db	0AAh,0A0h,0AAh,0AAh, 0Ah,0AAh
		db	0F0h,0AAh,0FFh, 0Ah,0FFh,0F0h
		db	8 dup (0)
		db	0A0h, 00h,0AAh, 00h,0AAh,0A0h
		db	0AAh,0AAh,0A5h, 84h, 25h,0A5h
		db	 05h,0A5h, 05h, 25h, 05h, 05h
		db	 05h, 05h, 05h, 05h, 05h, 05h
		db	 00h, 0Ah, 00h,0AAh, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0A0h,0AAh, 0Fh
		db	0A0h,0FFh, 0Fh,0FFh, 00h
		db	8 dup (0)
		db	 0Ah, 00h,0AAh, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	 00h,0A0h, 00h, 00h
		db	7 dup (0)
		db	0FFh,0F5h,0FFh, 5Ah,0F5h,0AAh
		db	 5Ah,0AAh,0AAh,0AAh,0AAh,0A0h
		db	0AAh, 00h,0A0h, 00h, 5Fh,0FFh
		db	0A5h,0FFh,0AAh, 5Fh,0AAh,0A5h
		db	0AAh,0AAh, 0Ah,0AAh, 00h,0AAh
		db	 00h, 0Ah,0AAh,0AAh, 0Ah,0AAh
		db	 00h,0AAh, 00h
		db	0Ah
		db	8 dup (0)
		db	9 dup (0FFh)
		db	0F5h,0FFh, 5Ah,0F5h,0AAh, 5Ah
		db	0AAh, 22h, 30h, 88h, 8Fh, 22h
		db	 20h, 88h, 88h, 22h, 22h, 88h
		db	 88h, 22h, 22h, 88h, 88h,0AAh
		db	0AAh,0AAh,0AAh, 22h, 22h, 88h
		db	 88h, 22h, 22h, 88h, 80h, 22h
		db	 0Fh, 88h, 30h,0AAh,0AAh,0AAh
		db	0AAh, 22h, 22h, 88h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_6C09	proc	near
		mov	[bx+si],al
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		inc	word ptr [bx+si]
		add	[bx+si],al
		add	ss:data_AAAA[bp+si],ch
		stosb				; Store al to es:[di]
		and	ah,[bp+si]
		mov	ds:d_0000_2202_e[bx+si],cl
		cld				; Clear direction
		or	[bp+di],al
		retn	3000h
sub_6C09	endp

		db	 00h, 32h, 00h, 30h, 00h, 32h
		db	 00h, 30h, 00h, 32h, 00h, 30h
		db	 00h, 32h, 00h, 30h, 00h, 32h
		db	 03h,0C8h,0FCh, 22h, 00h, 88h
		db	 22h, 22h, 88h, 88h, 22h, 22h
		db	 88h, 88h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 22h, 22h
		db	 88h, 88h, 22h, 22h, 88h, 88h
		db	0A7h,0DAh, 9Fh,0F6h, 7Fh,0FDh
		db	 04h, 10h, 7Fh,0FDh, 9Fh,0F6h
		db	0A7h,0DAh,0AAh,0AAh, 4Fh,0FFh
		db	 3Fh,0FDh, 3Fh,0FDh, 3Fh,0FDh
		db	 3Fh,0FDh, 3Fh,0FDh, 15h, 55h
		db	 55h, 55h, 00h,0C0h, 00h,0C0h
		db	 00h, 30h, 00h, 30h, 00h, 30h
		db	 00h, 30h, 00h, 30h, 00h, 30h
		db	0AAh,0AAh,0AFh,0FFh,0AFh, 88h
		db	0AFh, 22h,0AFh, 88h,0AFh, 22h
		db	0AFh,0FFh,0AAh,0AAh, 82h, 80h
		db	0A8h, 20h, 2Ah, 80h, 82h,0B8h
		db	 28h, 2Eh, 02h, 83h,0C0h, 2Eh
		db	0F3h, 00h, 2Ah,0A0h,0AAh, 88h
		db	 80h, 2Ah, 00h, 0Ah, 2Ah, 0Ah
		db	 82h, 0Ah, 88h, 28h, 2Ah,0A0h
		db	 03h,0C0h, 0Ch, 30h, 0Ch, 30h
		db	 01h,0C0h, 11h, 7Ch, 45h, 57h
		db	 0Ah,0B0h, 22h,0ACh, 02h,0BFh
		db	 0Dh, 63h, 35h, 58h,0D4h, 56h
		db	0D5h, 16h, 35h, 16h, 00h, 16h
		db	 01h, 56h, 07h,0E0h, 07h, 20h
		db	 07h,0E0h, 07h, 20h, 07h,0E0h
		db	 07h, 20h, 07h,0E0h, 07h, 20h
		db	0AAh,0AAh,0FFh,0FAh, 88h,0BAh
		db	 22h, 3Ah, 88h,0BAh, 22h, 3Ah
		db	0FFh,0FAh,0AAh,0AAh, 00h, 00h
		db	 55h, 55h, 55h, 55h, 00h, 00h
		db	0CCh,0CCh, 33h, 33h,0FFh,0FFh
		db	0FFh,0FFh,0C3h, 00h, 0Ch,0CCh
		db	 3Fh,0F3h,0CDh,0CFh, 55h,0FFh
		db	 45h, 71h, 54h, 55h, 55h, 45h
		db	 00h, 00h, 00h, 00h, 22h, 22h
		db	0AAh,0AAh, 55h, 55h,0AAh,0AAh
		db	0A0h,0A0h,0F0h,0F0h, 00h, 00h
		db	 31h,0C4h, 39h,0C6h, 00h, 39h
		db	 4Bh, 1Eh, 0Fh, 48h, 03h, 1Eh
		db	 5Ah, 48h, 44h, 45h, 11h, 55h
		db	 44h, 54h, 11h, 15h, 04h, 55h
		db	 11h, 51h, 44h, 54h, 11h, 45h
		db	 30h, 30h,0CCh,0CCh,0F7h,0D3h
		db	0DCh,0FDh, 7Dh,0D3h, 37h, 77h
		db	 51h,0D4h, 55h, 45h, 00h, 00h
		db	0F0h, 00h,0FFh, 00h,0F3h,0C0h
		db	 1Fh,0F0h, 77h,0F0h, 53h,0FCh
		db	 17h, 3Ch, 51h, 11h, 44h, 44h
		db	 11h, 15h, 46h, 95h, 11h,0A6h
		db	'EjQYUeQUW'
		db	0D1h, 1Ch, 35h, 51h, 55h, 55h
		db	 45h,0C7h,0D5h, 75h, 34h, 51h
		db	 55h,0F3h,0CFh, 4Dh, 75h, 75h
		db	 57h, 51h, 15h, 4Ch,0C5h, 37h
		db	 31h, 55h,0C5h, 15h, 15h, 51h
		db	0F3h, 17h, 7Ch, 55h,0FCh, 51h
		db	 5Fh, 55h,0FCh, 55h, 3Ch, 55h
		db	0D3h, 17h, 7Ch, 54h,0FFh, 17h
		db	 7Ch, 5Ch,0FCh, 57h,0F0h,0CFh
		db	0C0h,0FFh, 00h,0F0h, 00h, 00h
		db	 00h, 0Ah,0B8h, 22h,0AEh, 0Ah
		db	0ABh, 22h,0AAh, 08h,0AAh, 02h
		db	 22h, 00h, 88h, 00h, 00h, 0Ah
		db	0AAh, 02h, 22h, 08h,0A8h, 02h
		db	 2Ah, 08h,0A8h, 02h, 2Ah, 08h
		db	0A8h, 02h, 2Ah,0AAh,0AAh, 22h
		db	 22h,0ABh,0AEh,0AAh,0AEh,0ABh
		db	0AEh,0AAh,0AEh,0ABh,0AEh,0AAh
		db	0AEh, 08h,0A8h, 02h, 2Ah, 08h
		db	0A8h, 02h, 2Ah, 08h,0A8h, 02h
		db	 2Ah, 02h, 00h, 00h,0AAh, 00h
		db	 00h,0FFh,0FAh, 55h, 5Ah,0D5h
		db	0DAh, 55h,0DAh, 57h, 5Ah, 5Dh
		db	 5Ah,0AAh,0AAh, 88h
loc_6E03:
		stosb				; Store al to es:[di]
		and	ch,[bp+si]
		mov	byte ptr ss:[2A22h][bp+si],ch
		mov	byte ptr ss:[2A22h][bp+si],ch
		mov	byte ptr ss:[2A22h][bp+si],ch
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		scasb				; Scan es:[di] for al
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		scasb				; Scan es:[di] for al
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		scasb				; Scan es:[di] for al
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		scasb				; Scan es:[di] for al
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bp+si],al
		mov	data_A3C2,ax
		retn	0C2A3h
			                        ;* No entry point to code
		mov	ds:data_00C2_e,ax
		add	ch,ss:data_AAAA[bp+si]
		stosb				; Store al to es:[di]
		add	[bx+si],al
		push	bx
		lds	dx,dword ptr [bp+di-3Bh]	; Load seg:offset ptr
		push	bx
		lds	dx,dword ptr [bp+di-3Bh]	; Load seg:offset ptr
		add	[bx+si],al
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		db	16 dup (0)
		db	 2Ah,0AAh, 20h, 00h
		db	'%<%<%<%< '
		db	 00h, 2Ah
		db	17 dup (0AAh)
		db	 22h, 30h, 88h, 30h, 22h, 30h
		db	 88h, 30h, 22h, 30h, 88h, 30h
		db	 22h, 30h, 88h, 30h, 5Fh, 5Fh
		db	 00h, 00h
		db	12 dup (5Fh)
		db	0AAh,0AAh,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0FFh,0FFh
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	 0Fh, 00h, 0Fh, 00h,0FAh,0F0h
		db	0F8h,0F0h, 0Fh, 40h, 0Fh, 10h
		db	 00h, 04h, 00h, 00h, 00h,0A0h
		db	 00h,0A0h, 0Ah,0FAh, 0Ah,0CAh
		db	 01h,0A0h, 04h,0A0h, 10h, 00h
		db	0A8h, 80h,0AAh, 20h,0A8h, 80h
		db	0AAh, 20h,0A8h, 80h,0A8h, 80h
		db	0A2h, 00h, 88h, 00h, 0Ah,0AAh
		db	 0Ah,0AAh, 0Ah,0AAh, 0Ah,0AAh
		db	 02h,0AAh, 02h,0AAh, 00h,0AAh
		db	 00h,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h
		db	40h
		db	25 dup (0)
		db	 0Ch, 00h,0C3h, 00h, 3Fh, 0Ch
		db	0CFh, 13h, 3Fh, 04h, 5Dh, 11h
		db	 15h, 04h, 55h, 0Fh, 1Eh, 0Fh
		db	 4Bh, 1Eh, 0Fh, 4Bh, 0Fh, 1Eh
		db	 0Fh, 4Bh, 5Ah, 1Eh, 0Fh, 0Fh
		db	 0Fh, 00h, 00h,0F0h,0C0h,0FFh
		db	 00h, 5Fh,0CCh, 51h,0F0h, 15h
		db	0F0h, 51h, 7Ch, 15h, 3Ch, 04h
		db	 55h, 11h, 15h, 04h, 55h, 11h
		db	 11h, 04h, 45h, 01h, 11h, 00h
		db	 44h, 00h, 01h
		db	'TTEQQTEU'
		db	 14h, 14h, 44h, 00h, 50h, 00h
		db	 00h, 00h, 3Fh,0FCh, 0Ah,0A0h
		db	 3Fh, 3Ch,0DFh,0FFh,0DEh,0F3h
		db	0FFh,0BFh, 33h,0FCh, 05h, 50h
		db	 00h, 00h, 0Ah,0A0h, 2Fh,0A8h
		db	 2Eh,0A8h, 2Ah,0A8h, 2Ah,0A8h
		db	 0Ah,0A0h, 00h, 00h, 54h, 54h
		db	 15h, 52h, 51h, 49h, 15h, 49h
		db	 81h, 29h, 68h,0A5h, 16h, 94h
		db	 56h, 91h,0EAh, 88h,0B8h,0A2h
		db	0EAh,0A8h,0BAh,0A2h,0EEh, 80h
		db	0BAh,0A2h,0EAh, 28h,0BAh,0A2h
		db	0FFh,0C0h,0FFh, 00h,0AAh, 88h
		db	0AAh, 88h, 03h, 00h, 55h, 54h
		db	0CCh,0CFh, 55h, 55h, 85h, 54h
		db	 21h, 61h, 08h, 41h, 02h, 15h
		db	 00h, 85h, 00h, 21h, 00h, 08h
		db	 00h, 02h, 00h, 03h, 00h, 0Fh
		db	 02h, 2Ah, 02h, 2Ah, 00h,0C0h
		db	 15h, 55h,0CCh,0CCh, 55h, 55h
		db	0AAh,0AAh,0FFh,0FEh, 00h, 0Eh
		db	 00h, 0Eh, 00h, 0Eh, 00h, 0Eh
		db	 00h, 0Eh, 00h, 0Eh, 0Ch, 03h
		db	 0Ch, 03h, 30h, 03h, 30h, 03h
		db	 30h, 03h, 30h, 03h, 30h, 03h
		db	 30h, 03h, 00h, 02h, 00h, 0Ah
		db	 00h, 00h, 00h, 0Ah, 00h, 00h
		db	 00h, 0Ah, 00h, 0Fh, 00h, 33h
		db	 00h, 00h, 80h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 80h, 00h
		db	0C0h, 00h,0F0h, 00h,0D0h, 00h
		db	0F4h, 00h,0F5h, 00h,0F5h, 00h
		db	0D5h, 00h, 54h, 00h, 50h, 00h
		db	 00h, 00h, 00h, 33h, 00h,0CFh
		db	 00h,0CFh, 03h, 3Fh, 03h, 3Fh
		db	 00h,0CDh, 00h, 15h, 00h, 00h
		db	 00h, 0Eh, 00h, 00h, 00h, 0Eh
		db	 00h, 00h, 00h, 0Eh, 00h, 0Eh
		db	 00h, 00h, 00h, 0Eh, 02h,0C0h
		db	 00h, 00h, 03h,0C0h, 03h,0C0h
		db	 03h,0C0h, 40h, 01h, 15h, 54h
		db	 01h, 40h, 40h, 00h, 10h, 00h
		db	 44h, 00h, 51h, 00h, 54h, 40h
		db	 61h, 10h, 41h, 44h, 15h, 51h
		db	 00h, 02h, 00h, 08h, 00h, 21h
		db	 00h, 85h, 02h, 15h, 08h, 61h
		db	 21h, 41h, 85h, 54h, 15h, 51h
		db	 61h, 44h, 41h, 10h, 54h, 40h
		db	 51h, 00h, 44h, 00h, 10h, 00h
		db	 40h, 00h,0BAh,0A8h,0AAh,0A8h
		db	0BAh,0A8h,0ABh, 28h,0B8h, 28h
		db	0AAh,0A8h,0BAh,0A8h,0AAh,0A8h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 50h,0AAh, 94h, 00h, 25h
		db	 00h, 25h, 00h, 94h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 05h, 55h
		db	 16h,0AAh, 58h, 00h, 58h, 00h
		db	 16h
		db	7 dup (0)
		db	 55h, 55h,0AAh,0AAh
		db	'  00  00  00  00  00  '
		db	 00h, 00h, 0Fh, 7Dh, 35h, 55h
		db	 35h, 75h, 1Dh, 55h, 35h,0C5h
		db	 15h, 70h, 35h, 5Fh, 00h, 00h
		db	 3Fh,0FFh, 5Fh,0D5h
		db	 75h, 55h
		db	8 dup (55h)
		db	 00h, 00h,0FFh,0F8h, 65h, 68h
		db	 59h, 68h, 55h,0A8h, 55h, 68h
		db	 55h,0A0h
		db	'VhUhUhUhUXU'
		db	0E8h, 56h, 68h, 59h, 98h,0A2h
		db	0A0h, 57h, 55h, 54h,0F5h
		db	'W', 0Dh, 'W3U]UU'
		db	0A2h, 8Ah, 00h, 00h, 35h, 55h
		db	 35h, 55h, 15h, 55h, 35h, 55h
		db	 35h, 5Dh, 15h, 75h, 2Ah, 8Ah
		db	 00h
		db	13 dup (0)
		db	 33h,0CCh,0FFh, 3Fh, 00h, 03h
		db	 00h, 3Fh, 00h,0CFh, 03h,0FFh
		db	 03h,0FFh, 0Ch,0FFh, 3Fh, 0Fh
		db	0FFh,0FFh,0F0h, 00h,0FFh, 00h
		db	0CFh,0C0h,0FCh,0C0h,0F3h,0F0h
		db	 3Fh, 30h,0F3h,0CCh,0FFh,0F3h
		db	0DEh,0CFh, 7Bh,0CCh,0CCh,0F3h
		db	 0Fh, 3Ch, 33h,0DEh,0CFh,0FFh
		db	0FFh,0CFh, 3Fh, 7Bh,0B7h, 7Bh
		db	 3Fh,0FFh,0FFh,0FFh, 4Bh,0CFh
		db	0FFh,0FFh,0DEh, 3Fh,0FFh,0DEh
		db	 1Eh,0FFh, 16h, 3Eh, 56h, 3Ah
		db	 56h, 3Eh,0ABh,0FAh
loc_717A:
		jg	loc_717A		; Jump if >
		add	[bx+si],al
loc_717E:
		jg	loc_717E		; Jump if >
		add	[bx+si],al
		pop	es
		loopnz	locloop_7185		; Loop if zf=0, cx>0


locloop_7185:
		add	[bx],bl
		call	sub_6C09
loc_718A:
		jg	loc_718A		; Jump if >
		add	[bp+si],bh
		push	si
		db	 3Eh, 56h, 3Ah, 01h, 20h, 03h
		db	 60h, 01h, 20h, 03h, 60h, 01h
		db	 20h, 03h, 60h, 01h, 20h, 03h
		db	 60h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 0Fh,0E0h, 07h,0E0h, 02h
		db	 80h, 00h, 20h, 03h, 60h, 00h
		db	 00h, 00h,0FCh, 43h,0FDh, 57h
		db	0F1h, 41h, 41h, 00h, 54h, 00h
		db	 00h, 00h, 00h, 00h, 00h,0A8h
		db	 2Ah,0A0h, 2Ah, 88h, 2Ah, 00h
		db	 00h, 2Ah,0A8h, 2Ah,0A0h, 2Ah
		db	 88h, 00h, 00h, 0Fh,0F0h, 3Bh
		db	0FCh,0EFh,0FFh,0EFh,0FFh,0FFh
		db	0FFh, 3Fh,0FCh, 0Fh,0F0h, 8Fh
		db	0FFh,0A3h,0FFh, 23h, 3Fh, 28h
		db	0FFh, 0Ah, 0Ch, 02h,0A0h, 00h
		db	 2Ah, 00h, 00h, 3Fh,0C8h,0CFh
		db	 20h,0F3h, 20h,0FCh, 80h,0C2h
		db	 00h, 28h, 00h, 80h, 00h, 00h
		db	 00h, 80h, 00h, 28h, 00h,0C2h
		db	 00h,0FCh, 80h,0F3h, 20h,0FFh
		db	 20h,0FFh,0C8h,0FCh,0C8h, 00h
		db	 2Ah, 02h,0A0h, 0Ah, 0Ch, 28h
		db	0FCh, 23h, 3Ch,0A3h,0FCh, 8Fh
		db	0FCh, 8Ch,0FCh, 51h, 0Eh, 54h
		db	 0Eh, 80h, 0Eh, 80h, 0Eh, 91h
		db	 0Eh, 00h, 0Eh,0FFh,0F2h,0AAh
		db	0A8h,0E0h, 15h,0E0h, 05h,0E0h
		db	 02h,0E0h, 02h,0E1h, 06h,0E0h
		db	 00h

locloop_723E:
		iret				; Interrupt return
			                        ;* No entry point to code
		jmp	dword ptr [bp+si]	;*
			                        ;* No entry point to code
		stosb				; Store al to es:[di]
		db	0FFh,0FCh,0AAh,0A2h, 00h, 0Eh
		db	 50h, 0Eh, 44h, 0Eh, 15h, 0Eh
		db	 51h, 0Eh, 14h, 0Eh, 3Fh,0FFh
		db	0CAh,0AAh,0E0h, 00h,0E0h, 03h
		db	0E0h, 15h,0E0h, 73h,0E0h, 54h
		db	0E1h, 33h, 00h, 0Fh, 0Fh
		db	13 dup (0)
		db	0CFh,0FFh, 33h,0C3h,0F0h
		db	11 dup (0)
		db	0FFh,0FFh,0FFh, 33h,0CCh,0CCh
		db	 33h,0C3h,0CCh
		db	7 dup (0)
		db	0FCh,0FFh,0CFh, 33h, 30h,0CCh
		db	 00h
		db	33h
		db	8 dup (0)
		db	 0Fh, 3Fh, 03h,0CCh, 00h, 33h
		db	22 dup (0)
		db	 5Fh, 4Ch, 05h, 17h, 00h
		db	11 dup (0)
		db	 54h, 00h,0FDh, 50h
		db	8 dup (0)
		db	 50h, 00h,0F5h, 01h,0FFh, 57h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 50h, 05h,0F5h
		db	5Fh
		db	7 dup (0FFh)
		db	11 dup (0)
		db	 15h, 01h, 7Fh, 07h,0FFh, 0Ah
		db	0A0h, 2Ah, 88h, 8Ah,0A2h,0A0h
		db	0A8h, 2Ah, 88h, 82h,0A2h, 2Ah
		db	 88h, 0Ah, 20h,0FFh, 3Fh,0FCh
		db	0CFh, 33h, 3Ch, 55h, 55h, 55h
		db	 55h, 10h, 44h,0CFh,0F3h, 3Fh
		db	0FCh,0C3h,0FFh, 3Fh,0FFh, 3Fh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 3Fh
		db	0FFh, 3Fh,0FFh,0C3h,0FFh,0AAh
		db	 80h,0AAh,0A8h,0AAh,0A8h, 03h
		db	 00h, 03h, 00h, 00h,0C0h, 3Fh
		db	0C0h,0C0h,0C0h,0FFh,0C3h,0FFh
		db	0FCh,0FFh, 33h,0FFh,0CCh,0FFh
		db	0F3h,0FFh,0CFh,0FFh,0FCh,0FFh
		db	0C3h, 00h, 00h, 40h, 04h, 40h
		db	 10h, 10h, 10h,0AAh,0A2h,0AAh
		db	0A8h,0AAh,0A2h, 00h, 00h, 0Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 03h
		db	 00h, 03h, 00h, 0Ch, 00h, 0Fh
		db	0F0h, 0Ch, 0Fh, 00h, 00h, 2Ch
		db	0B8h,0B2h, 2Eh,0B8h, 8Eh,0B2h
		db	 2Eh,0B8h, 8Eh,0B2h, 2Eh, 2Ch
		db	 38h, 00h, 00h, 21h, 84h,0A5h
		db	0F0h,0B4h, 30h,0B4h, 30h,0B4h
		db	 30h, 21h,0C0h, 21h,0C0h,0AEh
		db	0AEh,0BBh,0BBh,0AAh,0AAh,0AAh
		db	0AAh,0A2h,0A2h, 88h, 88h, 22h
		db	 22h, 00h, 00h, 0Ah, 80h, 0Eh
		db	 20h, 0Ah, 80h, 0Eh,0A0h, 0Ah
		db	 80h, 0Eh, 20h, 0Ah, 80h, 0Eh
		db	 20h,0A8h, 2Ah, 80h, 02h, 80h
		db	 02h, 00h, 00h, 00h, 00h, 80h
		db	 02h, 80h, 02h,0A8h, 2Ah, 00h
		db	15 dup (0)
		db	 0Ah,0A0h, 28h, 28h, 28h, 28h
		db	 2Ah,0A8h, 14h, 14h, 14h, 14h
		db	 3Ch, 3Ch, 00h, 00h, 2Ah,0A0h
		db	 28h, 28h, 28h, 28h, 2Ah,0A0h
		db	 14h, 14h, 14h, 14h, 3Fh,0F0h
		db	 00h, 00h, 0Ah,0A0h, 28h, 08h
		db	 28h, 00h, 28h, 00h, 14h, 00h
		db	 14h, 04h, 0Fh,0F0h, 00h, 00h
		db	 2Ah,0A0h, 28h, 28h, 28h, 28h
		db	 28h, 28h, 14h, 14h, 14h, 14h
		db	 3Fh,0F0h, 00h, 00h, 2Ah,0A8h
		db	 28h, 00h, 28h, 00h, 2Ah,0A0h
		db	 14h, 00h, 14h, 00h, 3Fh,0FCh
		db	 00h, 00h, 2Ah,0A8h, 28h, 00h
		db	 28h, 00h, 2Ah,0A0h, 14h, 00h
		db	 14h, 00h, 3Ch, 00h, 00h, 00h
		db	 0Ah,0A0h, 28h, 08h, 28h, 00h
		db	 28h, 00h, 14h, 54h, 14h, 14h
		db	 0Fh,0F0h, 00h, 00h, 28h, 28h
		db	 28h, 28h, 28h, 28h, 2Ah,0A8h
		db	 14h, 14h, 14h, 14h, 3Ch, 3Ch
		db	 00h, 00h, 0Ah,0A0h, 02h, 80h
		db	 02h, 80h, 02h, 80h, 01h, 40h
		db	 01h, 40h, 0Fh,0F0h, 00h, 00h
		db	 0Ah,0A8h, 00h, 28h, 00h, 28h
		db	 00h, 28h, 00h, 14h, 14h, 14h
		db	 0Fh,0F0h, 00h, 00h, 28h, 28h
		db	 28h, 28h, 28h, 80h, 2Ah, 00h
		db	 14h, 40h, 14h, 14h, 3Ch, 3Ch
		db	 00h, 00h, 28h, 00h, 28h, 00h
		db	 28h, 00h, 28h, 00h, 14h, 00h
		db	 14h, 0Ch, 3Fh,0FCh, 00h, 00h
		db	 28h, 28h, 2Ah,0A8h, 2Ah,0A8h
		db	 28h, 28h, 14h, 14h, 14h, 14h
		db	 3Ch, 3Ch, 00h, 00h, 2Ah,0A8h
		db	 28h, 28h, 28h, 28h, 28h, 28h
		db	 14h, 14h, 14h, 14h, 3Ch, 3Ch
		db	 00h, 00h, 0Ah,0A0h, 28h, 28h
		db	 28h, 28h, 28h, 28h, 14h, 14h
		db	 14h, 14h, 0Fh,0F0h, 00h, 00h
		db	 2Ah,0A0h, 28h, 28h, 28h, 28h
		db	 2Ah,0A0h, 14h, 00h, 14h, 00h
		db	 3Ch, 00h, 00h, 00h, 0Ah,0A0h
		db	 28h, 28h, 28h, 28h, 28h, 28h
		db	 14h, 14h, 05h, 50h, 00h,0FCh
		db	 00h, 00h, 2Ah,0A0h, 28h, 28h
		db	 28h, 28h, 2Ah,0A0h, 14h, 50h
		db	 14h, 14h, 3Ch, 3Ch, 00h, 00h
		db	 0Ah,0A0h, 28h, 08h, 28h, 00h
		db	 0Ah,0A0h, 00h, 14h, 10h, 14h
		db	 0Fh,0F0h, 00h, 00h, 2Ah,0A8h
		db	 22h, 88h, 02h, 80h, 02h, 80h
		db	 01h, 40h, 01h, 40h, 0Fh,0F0h
		db	 00h, 00h
		db	8 dup (28h)
		db	 14h, 14h, 14h, 14h, 0Fh,0F0h
		db	 00h, 00h
		db	8 dup (28h)
		db	 14h, 14h, 05h, 50h, 03h,0C0h
		db	 00h, 00h
		db	8 dup (28h)
		db	 15h, 54h, 15h, 54h, 3Ch, 3Ch
		db	 00h, 00h, 28h, 28h, 28h, 28h
		db	 08h, 20h, 02h, 80h, 04h, 10h
		db	 14h, 14h, 3Ch, 3Ch, 00h, 00h
		db	 28h, 28h, 28h, 28h, 28h, 28h
		db	 0Ah,0A8h, 00h, 14h, 10h, 14h
		db	 0Fh,0F0h, 00h, 00h, 2Ah,0A8h
		db	 20h, 28h, 00h,0A0h, 02h, 80h
		db	 05h, 00h, 14h, 04h, 3Fh,0FCh
		db	12 dup (0)
		db	 01h, 40h, 03h,0C0h, 00h, 00h
		db	 0Ah,0A0h, 20h, 28h, 00h, 28h
		db	 02h,0A0h, 01h, 40h, 00h, 00h
		db	 03h,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 02h, 80h, 02h, 80h
		db	 00h, 00h, 01h, 40h, 03h,0C0h
		db	 00h, 00h, 0Fh,0F0h, 14h, 14h
		db	 14h, 14h
		db	8 dup (28h)
		db	 0Ah,0A0h, 03h,0C0h, 05h, 40h
		db	 05h, 40h, 02h, 80h, 02h, 80h
		db	 02h, 80h, 02h, 80h, 0Ah,0A0h
		db	 0Fh,0F0h, 10h, 14h, 00h, 14h
		db	 02h,0A0h, 0Ah, 00h, 28h, 00h
		db	 28h, 08h, 2Ah,0A8h, 0Fh,0F0h
		db	 10h, 14h, 00h, 14h, 02h,0A0h
		db	 00h, 28h, 00h, 28h, 20h, 28h
		db	 0Ah,0A0h, 3Ch, 00h, 14h, 14h
		db	 14h, 14h, 28h, 28h, 2Ah,0A8h
		db	 00h, 28h, 00h, 28h, 00h, 28h
		db	 3Fh,0FCh, 14h, 00h, 14h, 00h
		db	 2Ah,0A0h, 00h, 28h, 00h, 28h
		db	 20h, 28h, 0Ah,0A0h, 0Fh,0F0h
		db	 14h, 04h, 14h, 00h, 2Ah,0A0h
		db	 28h, 28h, 28h, 28h, 28h, 28h
		db	 0Ah,0A0h, 3Fh,0FCh, 10h, 14h
		db	 00h, 14h, 00h,0A0h, 02h, 80h
		db	 02h, 80h, 02h, 80h, 02h, 80h
		db	 0Fh,0F0h, 14h, 14h, 14h, 14h
		db	 0Ah,0A0h, 28h, 28h, 28h, 28h
		db	 28h, 28h, 0Ah,0A0h, 0Fh,0F0h
		db	 14h, 14h, 14h, 14h, 0Ah,0A8h
		db	 00h, 28h, 00h, 28h, 20h, 28h
		db	 0Ah,0A0h, 0Ah, 85h, 0Ah, 85h
		db	 0Ah, 85h, 0Ah, 81h,0AAh,0A8h
		db	0AAh,0A8h, 00h, 00h, 00h, 00h
		db	0AAh,0A8h,0AAh,0A8h, 0Ah, 80h
		db	 0Ah, 85h, 0Ah, 85h, 0Ah, 85h
		db	 0Ah, 85h, 0Ah, 85h, 2Ah,0AAh
		db	 00h, 00h, 4Ah,0AAh, 02h,0AAh
		db	 30h,0A2h,0CCh, 28h,0FFh,0CAh
		db	0FFh,0F0h
		db	'USEUuUUQUUX'
		db	 99h,0A2h, 2Ah, 00h, 00h,0AAh
		db	0AAh, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 22h
		db	 22h,0AAh,0AAh,0DFh,0D3h, 47h
		db	 1Fh, 50h,0D7h, 57h, 15h, 15h
		db	0D5h,0A6h, 22h, 88h, 88h, 00h
		db	 00h, 55h, 55h,0FFh,0FFh,0FAh
		db	0AAh,0E8h, 00h,0E0h, 00h,0E0h
		db	 00h,0E0h, 00h,0E0h, 00h, 55h
		db	 55h,0EFh, 7Dh, 8Ah, 9Ah, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 15h, 55h,0FFh
		db	0FFh,0AAh,0AFh, 00h, 07h, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 07h, 00h, 00h, 28h, 28h, 8Ah
		db	0AAh,0AAh, 8Ah,0A2h,0A2h, 88h
		db	 88h, 22h, 22h, 88h, 08h,0AAh
		db	0AAh, 00h, 00h, 55h, 55h, 57h
		db	 15h, 54h, 15h, 55h, 55h,0FFh
		db	0FFh,0AAh,0AAh, 2Ah,0AAh, 2Eh
		db	0EEh, 3Bh,0BBh, 2Eh,0EEh, 2Ah
		db	0AAh, 2Ah,0AAh, 2Ah,0CAh, 2Ah
		db	 0Ah,0D4h, 88h, 15h, 20h, 54h
		db	 88h, 52h, 20h, 48h, 88h, 22h
		db	 20h, 8Ah, 80h, 00h
		db	7 dup (0)
		db	0AAh,0AAh,0BBh,0BBh,0EEh,0EEh
		db	0BBh,0BBh,0AAh
		db	9 dup (0AAh)
		db	 88h, 88h, 22h, 22h,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0A8h,0A0h, 08h
		db	 02h, 80h, 22h,0A2h,0A0h, 00h
		db	 28h,0A8h, 00h,0A0h, 28h, 02h
		db	0A0h, 0Ah, 82h, 00h, 0Ah, 82h
		db	 2Ah, 02h, 20h, 20h, 00h,0A8h
		db	 88h, 80h, 08h, 0Ah,0AAh,0A0h
		db	0AAh, 0Fh,0A0h,0FFh, 0Fh
		db	9 dup (0FFh)
		db	 30h, 00h,0CCh,0CCh,0B3h,0F3h
		db	0AAh,0EEh,0A9h,0A9h, 9Ah, 9Ah
		db	 66h,0A6h,0A9h, 99h
		db	8 dup (0FFh)
		db	 5Fh,0FFh,0A5h,0FFh,0AAh, 5Fh
		db	0AAh,0A5h, 8Bh, 02h, 07h
		db	15 dup (1)
		db	7
		db	7 dup (51h)
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 05h, 05h, 06h, 04h, 05h, 06h
		db	 04h, 05h, 06h, 04h, 05h, 05h
		db	 06h, 04h, 05h, 06h, 04h, 05h
		db	 06h, 04h, 05h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 01h, 19h, 19h
		db	 19h, 6Ah, 04h, 0Ah, 23h, 1Ah
		db	 1Ah, 22h, 1Fh, 1Eh, 1Eh, 1Ch
		db	 1Ah, 22h, 23h, 22h, 1Eh, 1Ch
		db	 1Fh, 1Ch, 23h, 1Ah, 1Ah, 22h
		db	 1Fh, 1Eh, 1Dh, 1Ch, 1Ah, 22h
		db	 23h, 22h, 1Eh, 1Ch, 1Fh, 1Ch
		db	 23h, 1Ah, 1Ah, 22h, 1Fh, 1Eh
		db	 1Dh, 1Ch, 0Fh, 01h
		db	31h
		db	14 dup (31h)
		db	 07h, 0Ah,0D0h,0D1h,0D1h,0D2h
		db	0D0h,0D1h,0D2h,0D5h,0D4h,0D4h
		db	0D3h,0D5h,0D4h,0D3h,0D1h,0D2h
		db	0D0h,0D1h,0D1h,0D2h,0D0h,0D4h
		db	0D3h,0D5h,0D4h,0D4h,0D3h,0D5h
		db	0D0h,0D1h,0D1h,0D2h,0D0h,0D1h
		db	0D2h,0D5h,0D4h,0D4h,0D3h,0D5h
		db	0D4h,0D3h,0D1h,0D2h,0D0h,0D1h
		db	0D1h,0D2h,0D0h,0D4h,0D3h,0D5h
		db	0D4h,0D4h,0D3h,0D5h,0D0h,0D1h
		db	0D1h,0D2h,0D0h,0D1h,0D2h,0D5h
		db	0D4h,0D4h,0D3h,0D5h,0D4h,0D3h
		db	 05h, 01h, 68h, 19h, 19h, 19h
		db	 19h, 03h, 03h,0F6h,0F6h,0F8h
		db	 90h,0F5h, 5Dh, 5Ch, 5Eh, 5Ch
		db	 07h, 04h, 23h, 1Ah, 1Ah, 22h
		db	 23h, 1Ah, 22h, 1Fh, 1Eh, 1Dh
		db	 1Ch, 1Fh, 1Eh, 1Ch, 1Ah, 22h
		db	 23h, 1Ah, 1Ah, 22h, 23h, 1Eh
		db	 1Ch, 1Fh, 1Eh, 1Dh, 1Ch, 1Fh
		db	 04h, 02h, 23h, 1Ah, 1Ah, 22h
		db	 1Fh, 1Eh, 1Dh, 1Ch, 0Fh, 01h
		db	 19h
		db	14 dup (19h)
		db	3

locloop_7891:
		add	al,0DEh

locloop_7893:
		db	0DEh,0DEh

locloop_7895:
		db	9 dup (0DEh)
		db	7, 8, 1, 1, 1, 1
		db	1, 1, 1

locloop_78A7:
;*		aad	0D4h			; undocumented inst
		db	0D5h,0D4h		;  Fixup - byte match

locloop_78A9:
;*		aam	0D3h			; undocumented inst
		db	0D4h,0D3h		;  Fixup - byte match
;*		aad	0D4h			; undocumented inst
		db	0D5h,0D4h		;  Fixup - byte match
		rcl	cx,cl			; Rotate thru carry
		loopnz	locloop_7891		; Loop if zf=0, cx>0

		loopnz	locloop_7893		; Loop if zf=0, cx>0

;*		loopnz	locloop_7885		;*Loop if zf=0, cx>0

		db	0E0h,0D0h		;  Fixup - byte match
;*		aam	0E0h			; undocumented inst
		db	0D4h,0E0h		;  Fixup - byte match
;*		mov	dh,0C6h
		db	0C6h,0C6h,0C6h		;  Fixup - byte match
		loopnz	locloop_7891		; Loop if zf=0, cx>0

		shl	al,1			; Shift w/zeros fill
;*		mov	dh,0C6h
		db	0C6h,0C6h,0C6h		;  Fixup - byte match
		loopnz	locloop_7895		; Loop if zf=0, cx>0

;*		aad	0E0h			; undocumented inst
		db	0D5h,0E0h		;  Fixup - byte match
		loopnz	locloop_78A7		; Loop if zf=0, cx>0

		loopnz	locloop_78A9		; Loop if zf=0, cx>0

		rcl	ax,cl			; Rotate thru carry
		rcl	cx,1			; Rotate thru carry
		rcl	al,cl			; Rotate thru carry
		rcl	dx,1			; Rotate thru carry
;*		aad	0D4h			; undocumented inst
		db	0D5h,0D4h		;  Fixup - byte match
;*		aam	0D3h			; undocumented inst
		db	0D4h,0D3h		;  Fixup - byte match
;*		aad	0D4h			; undocumented inst
		db	0D5h,0D4h		;  Fixup - byte match
		rcl	word ptr [bp+si],cl	; Rotate thru carry
		add	[bx+di+49h],cx
		dec	ax
		dec	cx
		dec	ax
		dec	cx
		dec	ax
		dec	cx
		dec	ax
		dec	cx
		dec	ax
		dec	cx
		dec	ax
		dec	cx
		dec	cx
		dec	ax
		dec	cx
		dec	cx
		or	al,[bp+di]
		push	cx
		push	dx
		push	dx
		push	dx
		push	dx
		push	dx
		push	dx
		push	dx
		push	dx
		push	sp
		add	[bx+di+54h],dl
		add	[bx+si],al
		add	[bx+di+53h],dl

locloop_7900:
		push	sp
		add	[bx+si],al
		push	cx
		push	sp
		add	[bx+si],al
		add	[bx+di+53h],dl
		push	sp
		add	[bp+di],al
		add	al,55h			; 'U'
		push	si
		push	di
		push	bp
		push	si
		push	di
		push	bp
		push	si
		push	di
		push	bp
		push	si
		push	di
		pop	es
		pop	es
;*		add	al,ah
		db	 00h,0E0h		;  Fixup - byte match
		loopnz	locloop_7900		; Loop if zf=0, cx>0

;*		loopnz	locloop_7902		;*Loop if zf=0, cx>0

		db	0E0h,0E0h		;  Fixup - byte match
		add	[bx+si],al
		loopnz	$-20h			; Loop if zf=0, cx>0

		db	0DEh,0DEh,0E0h, 00h, 00h,0E0h
		db	0DEh,0DEh,0DEh,0E0h, 00h, 00h
		db	0E0h,0DEh,0DEh,0DEh,0E0h, 00h
		db	 00h,0E0h,0DEh,0DEh,0DEh,0E0h
		db	 00h, 00h, 68h, 19h, 19h, 19h
		db	 6Ah, 00h, 68h, 19h, 19h, 19h
		db	 19h, 19h, 6Ah, 04h, 01h, 51h
		db	 52h, 52h, 52h, 02h, 05h,0C6h
		db	 00h,0C6h, 00h,0C6h, 00h,0C2h
		db	0C3h,0C5h,0C4h, 07h, 01h, 23h
		db	 2Eh, 2Fh, 2Fh, 30h, 22h, 1Ah
		db	 03h, 05h,0DDh,0DDh
		db	13 dup (0DDh)
		db	 01h, 02h,0AFh,0B9h, 03h, 0Ah
		db	 23h, 1Ah, 22h, 1Fh, 1Eh, 1Ch
		db	0E0h,0D0h,0D2h,0E0h,0D5h,0D3h
		db	0D0h,0D1h,0D2h,0D5h,0D4h,0D3h
		db	0E0h,0D0h,0D2h,0E0h,0D1h,0D3h
		db	0D0h,0D1h,0D2h,0D5h,0D4h,0D3h
		db	 0Ah, 04h,0CEh
		db	9 dup (0CEh)
		db	10 dup (0CFh)
		db	0D0h,0D2h,0D0h,0D1h,0D1h,0D2h
		db	0D0h,0D1h,0D2h,0D0h,0D5h,0D3h
		db	0D5h,0D4h,0D4h,0D3h,0D5h,0D4h
		db	0D3h,0D5h, 05h, 01h, 3Ah, 3Ah
		db	 3Ah, 3Ah, 3Ah, 0Ah, 02h
		db	10 dup (0CEh)
		db	10 dup (0CFh)
		db	 0Ah, 02h
		db	20 dup (1)
		db	 28h, 01h
		db	40 dup (19h)
		db	 07h, 0Dh, 00h,0DDh,0DDh,0DDh
		db	0DDh,0DDh,0DDh, 00h,0DEh,0DEh
		db	0DEh,0DEh,0DEh,0DEh, 00h,0DDh
		db	0DDh,0DDh,0DDh,0DDh,0DDh, 00h
		db	0DDh,0DDh,0DDh,0DDh,0DDh,0DDh
		db	 00h,0DDh,0DDh,0DDh,0DDh,0DDh
		db	0DDh, 00h,0DDh,0DDh,0DDh,0DDh
		db	0DDh,0DDh, 00h,0DDh,0DDh,0DDh
		db	0DDh,0DDh,0DDh, 00h,0DEh,0DEh
		db	0DEh,0DEh,0DEh,0DEh, 00h,0DEh
		db	0DEh,0DEh,0DEh,0DEh,0DEh, 23h
		db	 1Ah, 1Ah, 22h, 23h, 1Ah, 1Ah
		db	 1Fh, 1Eh, 1Eh, 1Ch, 1Fh, 1Eh
		db	 1Eh, 23h, 22h, 01h, 01h, 01h
		db	 01h, 01h, 1Fh, 1Ch, 01h, 01h
		db	 01h, 01h, 01h, 02h, 07h, 15h
		db	 54h,0DDh,0B3h,0DDh,0B3h,0DDh
		db	0B3h,0DDh,0B3h,0DDh,0B3h,0DDh
		db	0B3h, 06h, 03h, 45h, 16h, 16h
		db	 16h, 16h, 47h, 12h, 18h, 18h
		db	 18h, 18h, 17h, 21h, 2Dh, 2Dh
		db	 2Bh, 2Dh, 34h, 06h, 02h, 45h
		db	 16h, 16h, 16h, 16h, 47h, 21h
		db	 2Bh, 2Dh, 2Dh, 2Dh, 34h, 06h
		db	 01h, 45h, 16h, 16h, 16h, 16h
		db	 47h, 0Bh, 01h
		db	11 dup (1)
		db	 07h, 07h, 55h, 50h, 50h, 50h
		db	 50h, 50h, 57h,0DDh,0CFh,0CFh
		db	0CFh,0CFh,0CFh,0CFh,0DDh,0CFh
		db	0CFh,0CFh,0CFh,0CFh,0CFh,0DDh
		db	0CFh,0CFh,0C0h,0CFh,0CFh,0CFh
		db	7 dup (52h)
		db	 00h, 55h, 57h, 55h, 57h, 55h
		db	 00h, 00h, 57h, 55h, 57h, 55h
		db	 57h, 00h, 04h, 03h, 00h, 00h
		db	0C7h, 00h, 00h,0C7h,0DEh,0C7h
		db	 00h,0CDh,0DBh,0CCh, 06h, 03h
		db	'QSTQSTQSTQSTQSTQST', 0Dh
		db	7, 0
		db	11 dup (0)
		db	0Eh
		db	10 dup (0)
		db	 0Eh, 1Bh, 0Dh
		db	8 dup (0)
		db	 0Eh, 1Bh, 0Dh
		db	8 dup (0)
		db	 0Eh, 1Bh, 0Dh
		db	8 dup (0)
		db	 0Eh, 1Bh, 0Dh
		db	8 dup (0)
		db	 0Eh, 1Bh, 0Dh
		db	8 dup (0)
		db	 0Eh, 1Bh, 0Dh
		db	10 dup (0)
		db	 0Dh, 07h, 10h
		db	12 dup (0)
		db	 11h, 0Fh, 10h, 00h
		db	11 dup (0)
		db	 11h, 0Fh, 10h, 00h
		db	11 dup (0)
		db	 11h, 0Fh, 10h, 00h
		db	11 dup (0)
		db	 11h, 0Fh, 10h, 00h
		db	11 dup (0)
		db	 11h, 0Fh, 10h, 00h
		db	11 dup (0)
		db	 11h, 0Fh, 10h, 0Ch, 01h, 23h
		db	 1Ah, 1Ah, 22h, 23h, 1Ah, 1Ah
		db	 22h, 23h, 1Ah, 1Ah, 22h, 06h
		db	 03h,0F6h,0F6h,0F6h,0F6h,0F6h
		db	0F8h, 90h,0F5h,0F5h,0F5h,0F5h
		db	 5Dh, 5Ch, 5Eh, 5Eh, 5Eh, 5Eh
		db	 5Ch, 01h, 09h,0DDh,0DEh,0DDh
		db	0DDh,0DDh,0DDh,0DDh,0DEh,0DEh
		db	 0Ah, 02h,0F3h,0F2h,0F2h,0F1h
		db	0F1h,0F0h,0F0h, 00h,0F0h, 00h
		db	0EEh,0EDh,0EDh,0ECh,0ECh,0EBh
		db	0EBh,0EAh, 00h,0EAh, 02h, 02h
		db	0E9h,0E8h,0E7h,0E6h, 02h, 02h
		db	0E5h,0E4h,0E2h,0E3h, 0Ch, 06h
		db	 19h, 6Ah, 00h
		db	9 dup (0)
		db	 01h, 19h, 19h, 6Ah, 00h
		db	7 dup (0)
		db	 01h, 01h, 01h, 19h, 19h, 6Ah
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 01h, 01h, 01h, 01h, 19h
		db	 19h, 6Ah, 00h, 00h, 00h, 00h
		db	 01h, 01h, 01h, 01h, 01h, 01h
		db	 01h, 19h, 19h, 6Ah, 00h, 00h
		db	 01h
		db	8 dup (1)
		db	 19h, 19h, 6Ah, 09h, 02h,0AFh
		db	 00h,0AEh, 00h,0AFh, 00h,0AEh
		db	 00h,0AFh
		db	'HIHIHIHII'
		db	 01h, 05h,0E1h,0E0h,0E0h,0E0h
		db	0E0h, 28h, 01h, 23h, 1Ah, 1Ah
		db	 22h, 23h, 1Ah, 1Ah, 22h, 23h
		db	 1Ah, 1Ah, 22h, 23h, 1Ah, 1Ah
		db	 22h, 23h, 1Ah, 1Ah, 22h, 23h
		db	 1Ah, 1Ah, 22h, 23h, 1Ah, 1Ah
		db	 22h, 23h, 1Ah, 1Ah, 22h, 23h
		db	 1Ah, 1Ah, 22h, 23h, 1Ah, 1Ah
		db	 22h, 03h, 04h
		db	'UVWOXYUVWOXY'
		db	 03h, 0Ah, 00h, 00h, 00h, 6Bh
		db	 6Dh, 6Ch, 70h, 6Fh, 6Eh, 00h
		db	0DEh, 00h, 00h,0DDh, 00h, 00h
		db	0DDh, 00h, 00h,0DDh, 00h, 00h
		db	0DDh, 00h, 00h,0DCh, 00h, 00h
		db	0DBh, 00h, 02h, 04h,0E0h
		db	7 dup (0E0h)
		db	 01h, 01h, 9Bh, 0Fh, 04h
		db	'355553555535553'
		db	 13h, 36h, 36h, 36h, 36h, 13h
		db	 36h, 36h, 36h, 36h, 13h, 36h
		db	 36h, 36h, 13h
		db	'?6666?6666?666?=@@@@=@@@@=@@@='
		db	6, 3
		db	'QSRRSTQSRRSTQSRRST'
		db	 06h, 03h,0A9h,0A7h,0A6h,0A9h
		db	0A7h,0A6h,0A9h,0A6h,0A9h,0A7h
		db	0A7h,0A6h,0A9h,0A7h,0A6h,0A9h
		db	0A7h,0A6h, 18h, 01h
		db	52h
		db	22 dup (15h)
		db	 52h, 05h, 05h, 00h, 00h,0DBh
		db	 00h, 00h, 00h,0CDh,0DEh,0CCh
		db	 00h,0BAh,0CDh,0BAh,0CCh,0BAh
		db	 00h,0BAh,0DEh,0BAh, 00h, 00h
		db	 00h,0BAh, 00h, 00h, 08h, 02h
		db	 19h, 15h, 15h, 52h, 52h,0A3h
		db	 00h, 00h, 00h, 00h, 19h, 15h
		db	 15h, 52h, 52h,0A3h, 03h, 05h
		db	 04h, 05h, 06h, 05h, 06h, 01h
		db	 04h, 05h, 06h, 05h, 06h, 01h
		db	 04h, 05h, 06h, 0Bh, 03h,0B4h
		db	 98h, 94h, 98h, 94h, 98h, 94h
		db	 98h, 94h, 98h, 99h, 97h, 9Bh
		db	 9Bh,0BBh, 9Bh, 9Bh, 9Bh,0BBh
		db	 9Bh, 9Bh, 9Dh,0B7h,0BBh, 9Bh
		db	 9Bh, 9Bh,0BBh, 9Bh, 9Bh,0BBh
		db	 9Bh, 9Eh, 04h, 0Ah, 68h, 19h
		db	 19h, 6Ah, 00h,0A4h,0A5h, 00h
		db	 00h,0A4h,0A5h, 00h, 00h,0A4h
		db	0A5h, 00h, 00h,0A4h,0A5h, 00h
		db	 00h,0A4h,0A5h, 00h, 00h,0A4h
		db	0A5h, 00h, 00h,0A4h,0A5h, 00h
		db	 00h,0A4h,0A5h, 00h, 68h, 19h
		db	 19h, 6Ah, 04h, 03h, 00h, 6Bh
		db	 6Dh, 6Ch, 00h, 70h, 6Fh, 6Eh
		db	 43h, 07h, 8Eh, 00h, 28h, 01h
		db	40 dup (1)
		db	8, 1
		db	8 dup (32h)
		db	6, 4
		db	8, 9, 8, 9, 8, 9, 8, 9, 8, 9, 8, 9
		db	8, 9, 8, 9, 8, 9, 8, 9, 8, 9, 8, 9
		db	 05h, 04h,0B3h
		db	19 dup (0B3h)
		db	 06h, 03h,0CDh,0CEh,0CEh,0CEh
		db	0CEh,0CEh, 00h,0CFh,0CFh,0CFh
		db	0CFh,0CFh, 00h,0CFh,0CFh,0CFh
		db	0CFh,0CFh, 05h, 03h,0CEh,0CEh
		db	0CEh,0CEh,0CCh,0CFh,0CFh,0CFh
		db	0CFh, 00h,0CFh,0CFh,0CFh,0CFh
		db	 00h, 03h, 03h, 0Bh, 0Ch, 14h
		db	 0Bh, 0Ch, 14h, 0Bh, 0Ch, 14h
		db	 02h, 02h, 4Ch, 4Bh, 4Dh, 00h
		db	 02h, 02h,0FAh,0F7h,0C1h, 8Bh
		db	 02h, 02h, 00h, 4Dh, 4Bh, 4Eh
		db	 07h, 0Ah, 23h, 1Ah, 1Ah, 22h
		db	 23h, 1Ah, 22h, 1Fh, 1Eh, 1Dh
		db	 1Ch, 1Fh, 1Eh, 1Ch, 1Ah, 22h
		db	 23h, 1Ah, 1Ah, 22h, 23h, 1Eh
		db	 1Ch, 1Fh, 1Eh, 1Dh, 1Ch, 1Fh
		db	 23h, 1Ah, 1Ah, 22h, 23h, 1Ah
		db	 22h, 1Fh, 1Eh, 1Dh, 1Ch, 1Fh
		db	 1Eh, 1Ch, 1Ah, 22h, 23h, 1Ah
		db	 1Ah, 22h, 23h, 1Eh, 1Ch, 1Fh
		db	 1Eh, 1Dh, 1Ch, 1Fh, 23h, 1Ah
		db	 1Ah, 22h, 23h, 1Ah, 22h, 1Fh
		db	 1Eh, 1Dh, 1Ch, 1Fh, 1Eh, 1Ch
		db	 04h, 04h,0BEh,0C8h, 00h, 00h
		db	 00h,0BEh,0C8h, 00h, 00h, 00h
		db	0BEh,0C8h, 00h, 00h, 00h,0BEh
		db	 04h, 04h, 00h, 00h,0C9h,0CAh
		db	 00h,0C9h,0CAh, 00h,0C9h,0CAh
		db	 00h, 00h,0CAh, 00h, 00h, 00h
		db	 28h, 01h
		db	3Ah
		db	'::::::::::::::::::::::::::::::::'
		db	':::::::"'
		db	 02h, 04h, 05h, 06h, 04h, 05h
		db	 06h, 04h, 05h, 06h, 04h, 04h
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 04h, 05h, 06h, 04h, 05h, 06h
		db	 04h, 04h, 05h, 06h, 04h, 05h
		db	 06h, 04h, 05h, 06h, 04h, 05h
		db	 06h, 04h, 05h, 06h, 04h, 05h
		db	 06h, 04h, 05h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 05h, 05h, 06h
		db	 04h, 05h, 06h, 04h, 05h, 05h
		db	 06h, 04h, 05h, 06h, 04h, 05h
		db	 06h, 04h, 05h, 01h, 02h, 8Fh
		db	 5Fh, 06h, 04h, 00h, 00h, 7Ch
		db	 79h, 00h, 00h, 7Ch, 7Bh, 39h
		db	 63h, 78h, 79h, 80h, 7Fh, 3Bh
		db	 81h, 7Eh, 7Dh, 00h, 00h, 80h
		db	 7Dh, 00h, 00h, 0Ch, 0Ah, 00h
		db	 00h, 00h,0B4h,0B6h,0B4h, 9Ch
		db	0B6h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0B4h, 9Ah, 9Bh, 9Bh,0BBh
		db	 9Bh,0B6h, 00h, 00h, 00h,0B4h
		db	0B6h, 9Bh, 9Bh, 9Ah, 9Ch, 9Bh
		db	 9Ch, 9Ah, 9Ah,0B6h, 00h,0B7h
		db	 9Ah, 9Bh, 9Ch,0BBh, 9Bh, 9Bh
		db	0BBh, 9Ah, 9Ch, 9Bh,0B6h, 00h
		db	0B7h,0B8h, 9Ch, 9Bh, 9Ch,0B8h
		db	0B7h, 9Ch,0B8h, 9Ch,0B8h, 00h
		db	 00h, 00h, 00h, 00h,0BCh, 00h
		db	 00h
		db	9 dup (0)
		db	0BCh, 00h, 00h
		db	9 dup (0)
		db	0BCh, 00h, 00h
		db	9 dup (0)
		db	0BCh, 00h, 00h
		db	9 dup (0)
		db	0BCh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 28h, 01h
		db	 49h, 49h
data_8027	db	'HIHHIHIHIHIIHHIHHIIHIHIHIHIHIHIH'
		db	'IHIHIH', 8
		db	2
		db	'BBBBBBBB'
		db	 00h, 44h, 00h, 00h, 00h, 00h
		db	 44h, 00h, 06h, 08h, 8Ah, 8Ah
		db	 8Ah, 8Ah, 8Ah, 00h,0ADh,0ADh
		db	0ADh, 83h, 84h, 00h, 83h, 84h
		db	 85h,0ABh, 00h, 00h,0ABh, 00h
		db	 86h,0ABh, 00h, 00h,0ABh, 00h
		db	 86h,0ABh, 00h, 00h, 82h, 88h
		db	 87h, 82h, 88h, 88h,0AAh,0AAh
		db	0AAh
data_8088	db	0ADh			; Data table (indexed access)
		db	0ADh,0ADh,0ADh,0ADh,0ADh,0AAh
		db	0AAh, 89h, 05h, 08h, 8Ah, 8Ah
		db	 8Ah, 8Ah, 8Ah,0ADh,0ADh,0ADh
		db	0ADh,0ADh, 83h, 84h, 84h, 84h
		db	 85h
data_80A2	db	0ABh			; Data table (indexed access)
		db	 00h, 00h, 00h, 86h,0ABh, 00h
		db	 00h
data_80AA	db	0			; Data table (indexed access)
		db	 86h, 82h, 88h, 88h, 88h, 87h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0ADh
		db	0ADh,0ADh,0ADh,0ADh, 06h, 08h
		db	 8Ah, 8Ah, 8Ah, 8Ah, 8Ah, 8Ah
		db	0ADh,0ADh,0ADh,0ADh,0ADh,0ADh
		db	 83h, 84h, 84h, 84h, 84h, 85h
		db	0ABh,0B3h,0B3h,0B3h,0B3h, 86h
		db	0ABh,0B3h,0B3h,0B3h,0B3h, 86h
		db	0ABh,0B3h,0B3h,0B3h,0B3h, 86h
		db	0ABh,0B3h,0B3h,0B3h,0B3h, 86h
		db	 19h, 19h, 19h, 19h, 19h, 19h
		db	 07h, 03h,0B4h, 98h, 98h
data_80F2	db	98h
		db	 98h, 98h, 99h, 97h, 9Bh, 9Bh
		db	0BBh, 9Bh, 9Bh, 9Dh,0B7h,0BBh
		db	 9Bh, 9Bh, 9Bh,0BBh, 9Eh, 03h
		db	 08h, 00h, 8Ah, 8Ah, 00h, 84h
		db	 85h, 00h, 00h, 86h, 00h, 00h
		db	 86h, 00h, 00h, 86h, 88h, 88h
		db	 87h,0ADh,0ADh,0ADh, 89h,0AAh
		db	0AAh, 03h, 02h, 71h, 72h, 73h
		db	 74h, 75h, 76h, 02h, 03h,0AEh
		db	0AFh,0F9h,0F9h,0B1h,0B0h, 0Ah
		db	 06h, 00h, 00h, 00h, 00h, 7Ch
		db	 79h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 7Ch, 7Bh, 39h, 63h, 78h
		db	 79h, 00h, 00h
		db	'|{9bbbbcxy'
		db	 80h, 7Fh, 3Bh, 62h, 62h, 62h
		db	 62h, 81h, 7Eh, 7Dh, 00h, 00h
		db	 80h, 7Fh, 3Bh, 81h, 7Eh, 7Dh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 7Dh, 00h, 00h, 00h, 00h
		db	 05h, 01h, 45h, 16h, 16h, 16h
		db	 47h, 0Eh, 02h,0F3h,0F2h,0F1h
		db	0F2h,0F2h,0F1h,0F0h, 00h,0F3h
		db	0F1h,0F0h, 00h,0F0h, 00h,0EEh
		db	0EDh,0EDh,0ECh,0ECh,0EBh,0EBh
		db	0EBh,0EDh,0ECh,0EBh, 00h, 00h
		db	0EAh, 0Ah, 05h, 00h, 00h, 00h
		db	0B2h, 00h, 00h, 00h, 00h, 00h
		db	0B2h, 00h, 00h, 00h, 00h, 00h
		db	0B2h, 00h, 00h
		db	9 dup (0)
		db	0B2h, 00h, 00h, 00h, 00h,0B2h
		db	 00h, 00h
		db	13 dup (0)
		db	0B2h, 00h, 03h, 07h
		db	'878787878787778877878'
		db	 01h, 01h, 25h, 04h, 05h,0FEh
		db	0FEh,0FEh,0FEh,0FDh,0FDh,0FDh
		db	0FDh,0FEh,0FEh,0FEh,0FEh,0FDh
		db	0FDh,0FDh,0FDh,0FEh,0FEh,0FEh
		db	0FEh, 0Bh, 02h
		db	' $'
		db	' $'
		db	' $'
		db	' $'
		db	' '
data_8200	db	24h
		db	' $'
		db	' $'
		db	' $'
		db	' $'
		db	' '
data_820A	db	24h
		db	 20h, 24h, 05h, 03h, 00h, 00h
		db	0D6h, 00h, 00h, 00h,0D7h,0D9h
		db	0D8h, 00h,0D7h,0D9h,0D9h,0D9h
		db	0D8h, 01h, 05h, 20h, 24h, 20h
		db	 24h, 20h, 05h, 09h,0DDh,0B3h
		db	0B3h,0B3h,0DDh,0DDh,0B3h,0B3h
		db	0B3h,0DDh,0DDh,0B3h,0B3h,0B3h
		db	0DDh,0DDh,0B3h,0B3h,0B3h,0DDh
		db	0DDh,0B3h,0B3h,0B3h,0DDh,0DDh
		db	0B3h,0B3h,0B3h,0DDh,0DDh,0B3h
		db	0B3h,0B3h,0DDh,0DDh,0B3h,0B3h
		db	0B3h,0DDh,0DDh,0B3h,0B3h,0B3h
		db	0DDh, 01h, 02h, 24h, 20h, 04h
		db	 01h, 16h, 16h, 16h, 16h, 0Ch
		db	 02h
		db	 29h, 26h, 26h, 26h
		db	8 dup (26h)
		db	 28h, 27h
		db	10 dup (27h)
		db	 03h, 06h, 23h, 1Ah, 22h, 1Fh
		db	 1Eh, 1Ch, 01h, 23h, 22h, 01h
		db	 1Fh, 1Ch, 23h, 1Ah, 22h, 1Fh
		db	 1Eh, 1Ch, 06h, 06h, 19h, 19h
		db	 19h, 19h, 6Ah, 00h, 51h, 54h
		db	 00h, 00h, 00h, 00h, 01h, 54h
		db	 00h, 00h, 00h, 00h, 51h, 54h
		db	 00h, 00h, 00h, 00h, 01h, 54h
		db	 00h, 00h, 00h, 00h, 19h, 19h
		db	 19h, 19h, 19h, 6Ah, 02h, 09h
		db	 23h, 1Ah, 19h, 19h, 23h, 1Ah
		db	 19h, 19h, 23h, 1Ah, 19h, 19h
		db	 23h, 1Ah, 19h, 19h, 23h, 1Ah
		db	 05h, 04h, 95h, 95h, 95h, 95h
		db	 95h, 91h,0B3h,0B3h,0B3h, 91h
		db	 91h,0B3h,0B3h,0B3h, 91h, 8Ch
		db	 3Ch, 3Ch, 3Ch, 92h, 01h, 01h
		db	0DFh, 05h, 01h, 52h, 52h, 52h
		db	 52h, 52h, 0Ah, 06h
		db	 38h, 37h
		db	'87887878787887878878787787878787'
		db	'88787878788787887878778787'
		db	 02h, 03h, 64h, 67h,0A0h,0A1h
		db	0A2h, 61h, 28h, 03h
		db	'87788778787878878878778878778788'
		db	'77887887878787877787787878787887'
		db	'87787877877878788787887788787787'
		db	'788787778777887877878777', 0Dh
		db	6
		db	10 dup (0)
		db	 68h, 19h, 19h
		db	8 dup (0)
		db	 68h, 19h, 19h, 01h, 01h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 68h
		db	 19h, 19h, 01h, 01h, 01h, 01h
		db	 00h, 00h, 00h, 00h, 68h, 19h
		db	 19h, 01h, 01h, 01h, 01h, 01h

locloop_83DB:
		add	[bx+si],ax

locloop_83DD:
		add	[bx+si+19h],ch
		sbb	[bx+di],ax
		add	[bx+di],ax
		add	[bx+di],ax
		add	[bx+di],ax
		add	[bx+si+19h],bp
		sbb	[bx+di],ax
		add	[bx+di],ax
		add	[bx+di],ax
		add	[bx+di],ax
		add	[bx+di],ax
		add	[di],ax
;*		add	ax,sp
		db	 01h,0E0h		;  Fixup - byte match
		loopnz	locloop_83DB		; Loop if zf=0, cx>0

		loopnz	locloop_83DD		; Loop if zf=0, cx>0

		add	ax,5504h
		push	ax
		push	ax
		push	ax
		push	di
		movsw				; Mov [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		shl	byte ptr ds:[19A5h][si],19h	; Shift w/zeros fill
		sbb	[bx+di],bx
		sbb	[bx+si],bp
		add	ah,[bp+di]
		sbb	bl,[bp+si]
		and	ah,[bp+di]
		sbb	ah,[bp+si]
		and	bx,[bp+si]
		sbb	ah,[bp+si]
		and	bx,[bp+si]
		and	ah,[bp+di]
		sbb	bl,[bp+si]
		and	ah,[bp+di]
		sbb	ah,[bp+si]
		and	bx,[bp+si]
		sbb	ah,[bp+si]
		and	bx,[bp+si]
		and	ah,[bp+di]
		sbb	bl,[bp+si]
		and	ah,[bp+di]
		sbb	bl,[bp+si]
		sbb	ah,[bp+si]
		and	bx,[bp+si]
		and	bl,[bx]
		push	ds
		sbb	ax,1F1Ch
		push	ds
		sbb	al,1Fh
		push	ds
		sbb	ax,1F1Ch
		push	ds
		sbb	al,1Fh
		push	ds
		sbb	ax,1F1Ch
		push	ds
		sbb	al,1Fh
		push	ds
		sbb	ax,1F1Ch
		push	ds
		sbb	al,1Fh
		push	ds
		sbb	ax,1F1Ch
		push	ds
		push	ds
		sbb	ax,1F1Ch
		push	ds
		sbb	al,6
		add	ss:data_B3B3[bp+di],si
		mov	bl,0B3h
		mov	bl,1
		add	al,0B3h
		mov	bl,0B3h
		mov	bl,0Bh
;*		add	si,bx
		db	 01h,0DEh		;  Fixup - byte match
		db	10 dup (0DEh)
		db	 28h, 03h, 04h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 04h, 05h, 06h, 04h, 05h, 06h
		db	 04h, 05h, 04h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 04h, 05h, 06h
		db	 04h, 05h, 04h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 05h, 05h, 06h
		db	 04h, 05h, 06h, 04h, 05h, 06h
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 05h, 05h, 06h, 04h, 05h, 06h
		db	 05h, 06h, 04h, 05h, 06h, 04h
		db	 05h, 06h, 04h, 05h
		db	'JJKJJKJJKJJKJJKJJKJJKJJKJJKJJKJJ'
		db	'KJJKJJKJ'
		db	 04h, 0Ah, 02h, 03h, 02h, 03h
		db	 01h, 01h, 02h, 03h, 02h, 03h
		db	 02h, 03h, 01h, 01h
data_850A	db	2			; Data table (indexed access)
		db	 03h, 02h, 03h, 02h, 03h, 01h
		db	 01h, 02h, 03h, 02h, 03h, 02h
		db	 03h, 01h, 01h, 02h, 03h, 02h
		db	 03h, 02h, 03h, 01h, 01h, 02h
		db	 03h, 0Bh, 05h, 00h, 00h, 9Bh
		db	0DEh,0DEh, 9Bh,0DEh,0DEh, 9Bh
		db	 00h, 00h,0B8h, 9Bh,0DEh,0DEh
		db	0DEh,0DEh,0DEh,0DEh,0DEh, 9Bh
		db	 00h, 9Bh,0DEh,0DEh,0DDh,0DDh
		db	0DEh,0DDh,0DDh,0DEh,0DEh, 9Bh
		db	0DEh,0DEh
		db	7 dup (0DDh)
		db	0DEh,0DEh,0DEh,0DDh,0DDh,0DDh
		db	0DDh,0DEh,0DDh,0DDh,0DDh,0DDh
		db	0DEh, 02h, 03h, 65h, 8Dh,0A0h
		db	0A1h,0A2h, 61h, 08h, 01h
		db	'JJKJJKJJ'
		db	 02h, 07h,0D0h, 5Bh,0D5h, 5Bh
		db	0D1h, 5Bh,0D4h, 5Bh,0D0h, 5Bh
		db	0D5h, 5Bh, 42h, 42h, 01h, 06h
		db	0FBh,0FBh,0FBh,0FBh,0FBh,0FBh
		db	 01h, 01h,0F4h, 01h, 04h, 4Dh
		db	 4Dh, 4Dh, 4Dh, 02h, 02h, 4Bh
		db	 3Eh, 00h, 77h, 01h, 04h, 77h
		db	 77h, 77h, 77h, 02h, 01h,0BFh
		db	0BDh, 02h, 02h, 77h, 00h, 9Fh
		db	 4Bh, 03h, 08h, 1Ch, 1Ch, 1Ch
		db	 1Ch, 00h, 1Ch, 22h, 22h, 22h
		db	 1Ch, 1Ch, 1Ch
		db	12 dup (77h)
		db	8, 5
		db	'#"#"#"#"'
		db	 1Fh, 1Ch,0CBh,0CBh,0CBh,0CBh
		db	 1Fh, 1Ch, 1Fh, 1Ch,0CBh,0B3h
		db	0B3h,0CBh, 1Fh, 1Ch, 1Fh, 1Ch
		db	0CBh,0CBh,0CBh,0CBh, 1Fh, 1Ch
		db	 1Fh, 1Ch,0CBh,0CBh,0CBh,0CBh
		db	 1Fh, 1Ch, 0Ch, 01h
		db	 2Ah, 2Ch, 2Ch, 2Ch, 0Ah
		db	7 dup (93h)
		db	 05h, 01h, 2Ah, 2Ch, 2Ch, 2Ch
		db	 0Ah, 04h, 03h, 6Bh, 6Dh, 6Ch
		db	 00h, 70h, 6Fh, 6Eh, 00h, 00h
		db	 43h, 07h, 8Eh, 93h, 06h, 10h
		db	104 dup (0)
		db	 06h, 10h, 00h
		db	20 dup (0)
		db	 0Fh,0FFh,0FCh, 00h, 00h, 01h
		db	 3Ch, 00h,0FFh, 11h, 11h, 11h
		db	0FCh,0AAh, 0Fh, 00h, 00h, 01h
		db	 1Ch, 00h, 0Fh, 00h, 00h, 00h
		db	 05h, 55h,0FFh, 00h, 00h, 00h
		db	 00h, 09h,0FFh, 00h, 00h, 00h
		db	 00h, 01h,0FFh, 00h, 00h, 00h
		db	 00h, 01h, 7Ch, 00h, 00h, 00h
		db	 00h, 01h
		db	50h
		db	24 dup (0)
		db	 06h, 10h, 00h
		db	7 dup (0)
		db	 0Ch,0F3h, 00h, 00h, 00h, 00h
		db	 00h, 2Ah, 80h, 00h, 04h, 44h
		db	 40h,0A0h,0A0h, 00h, 05h, 11h
		db	 55h,0A0h,0A0h, 00h, 04h, 44h
		db	 40h, 2Ah, 8Fh,0C0h, 00h, 00h
		db	 00h, 50h, 30h,0F0h, 00h, 00h
		db	 2Ah,0A8h, 80h,0F0h, 00h, 00h
		db	0AAh,0AAh, 20h,0F0h, 00h, 00h
		db	0AAh,0AAh, 80h,0F0h, 00h, 00h
		db	0AAh,0AAh, 23h,0C0h, 00h, 00h
		db	0AAh,0AAh, 8Fh, 00h, 00h, 00h
		db	0AAh,0AAh, 20h, 00h, 00h, 00h
		db	 0Ah, 0Ah, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0A0h
		db	7 dup (0)
		db	 06h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h, 34h, 00h, 00h
		db	 00h, 00h, 00h,0D4h, 00h, 00h
		db	 00h, 00h, 00h,0D4h, 00h, 00h
		db	 00h, 00h, 00h,0D4h, 00h, 00h
		db	 00h, 00h, 0Fh,0D5h,0AAh,0AAh
		db	0AAh,0A0h, 0Ah, 55h, 88h, 88h
		db	 88h, 88h, 0Fh,0D5h, 22h, 22h
		db	 22h, 20h, 00h,0D4h, 00h, 00h
		db	 00h, 00h, 00h,0D4h, 00h, 00h
		db	 00h, 00h, 03h, 55h, 00h, 00h
		db	 00h, 00h, 03h,0FFh, 00h
		db	21 dup (0)
		db	 06h, 10h, 00h
		db	33 dup (0)
		db	0FFh,0FCh,0EEh, 00h, 00h,0F3h
		db	 55h, 57h,0AAh,0EEh,0EEh,0FFh
		db	0FFh,0FFh, 8Ah, 00h, 00h,0F3h
		db	 11h, 13h, 00h, 00h, 00h, 00h
		db	0CCh,0CCh
		db	36 dup (0)
data_8800	db	6			; Data table (indexed access)
		db	 10h, 00h
		db	21 dup (0)
		db	 0Fh,0FCh, 00h, 00h, 00h, 00h
		db	 3Ch, 0Dh, 00h, 00h, 00h, 00h
		db	 3Ch, 05h,0FFh,0FFh,0FFh,0FFh
		db	0FCh,0D5h, 0Ah,0A2h, 80h, 00h
		db	 14h, 05h, 05h, 51h, 40h, 00h
		db	 14h, 05h, 05h, 51h, 40h, 00h
		db	 05h, 54h, 0Ah,0A2h, 80h, 00h
		db	 00h, 00h, 05h
		db	 51h, 40h
		db	27 dup (0)
		db	 06h, 10h, 00h
		db	7 dup (0)
		db	 05h, 55h, 50h, 00h, 00h, 00h
		db	 0Fh,0FFh,0F0h, 00h, 00h, 00h
		db	 00h, 34h, 00h, 00h, 00h, 00h
		db	 08h,0B4h, 88h, 80h, 00h, 00h
		db	 22h, 36h, 22h, 00h, 00h, 00h
		db	 88h, 88h, 88h, 80h, 00h, 02h
		db	0AAh,0AAh,0A2h, 00h, 00h, 02h
		db	0AAh,0AAh,0A8h, 80h, 00h, 3Eh
		db	0AAh,0AAh,0A2h, 00h, 03h,0C2h
		db	0AAh,0AAh,0A8h, 80h, 0Ch, 02h
		db	0AAh,0AAh,0A2h, 00h, 03h, 02h
		db	0AAh,0AAh,0A8h, 00h, 03h, 02h
		db	0AAh,0AAh,0A0h, 00h, 00h,0C3h
		db	0C0h, 00h, 00h, 00h, 00h, 3Ch
		db	 30h, 00h, 00h, 00h, 06h, 10h
		db	 00h
		db	23 dup (0)
		db	 0Fh,0F0h, 00h, 00h, 0Fh,0F0h
		db	 35h, 5Ch, 00h, 00h, 35h, 5Ch
		db	 00h, 97h,0FFh,0FFh,0D6h, 00h
		db	 00h, 95h,0AAh,0AAh, 56h, 00h
		db	 00h, 95h, 55h, 55h, 56h, 00h
		db	 16h, 54h, 00h, 00h, 15h, 94h
		db	 05h, 50h, 00h, 00h, 05h
		db	50h
		db	30 dup (0)
		db	 06h, 10h, 00h
		db	9 dup (0)
		db	 03h,0FCh, 00h, 00h, 00h, 00h
		db	 3Eh,0A8h, 00h, 00h, 00h, 03h
		db	0E8h, 00h, 0Fh,0FFh,0C0h, 3Eh
		db	 80h, 00h, 3Eh,0AFh,0F3h,0E8h
		db	 00h, 00h, 38h, 0Ah, 86h, 80h
		db	 00h, 00h, 00h, 00h, 15h, 00h
		db	 00h, 00h, 38h, 0Ah, 86h, 80h
		db	 00h, 00h, 3Eh,0AFh,0F3h,0E8h
		db	 00h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_8964	proc	near
		db	 0Fh,0FFh,0C0h, 3Eh, 80h, 00h
		db	 00h, 00h, 00h, 03h,0E8h, 00h
		db	 00h, 00h, 00h, 00h, 3Eh,0A8h
		db	 00h, 00h, 00h, 00h, 03h,0FCh
		db	12 dup (0)
		db	 03h, 05h,0AAh,0AAh,0AAh,0FFh
		db	0FEh, 22h,0AAh,0AAh,0AAh,0FFh
		db	0FEh, 22h,0AAh,0AAh,0AAh, 08h
		db	 0Dh, 00h, 00h,0AAh,0AAh, 00h
		db	 00h, 00h, 00h, 00h, 2Ah,0AAh
		db	0AAh,0A0h, 00h,0AAh, 00h, 02h
		db	0AAh,0A2h,0AAh, 8Ah, 0Ah,0A2h
		db	 80h, 0Ah,0AAh, 00h, 2Ah,0A0h
		db	 8Ah, 80h,0A0h, 2Ah,0A8h,0A2h
		db	 8Ah,0AAh, 2Ah,0A0h,0A0h,0AAh
		db	0A8h,0A2h,0AAh,0AAh, 0Ah,0A0h
		db	0A0h,0A2h,0AAh, 00h, 2Ah,0A8h
		db	0A0h,0A8h, 80h, 88h,0AAh,0A2h
		db	 8Ah,0A2h,0A0h, 0Ah, 00h,0A2h
		db	0A8h,0A2h, 8Ah,0AAh, 80h, 00h
		db	 00h, 28h,0AAh, 00h, 2Ah, 22h
		db	 00h, 00h, 00h, 0Ah, 2Ah,0A2h
		db	0A8h, 88h, 00h, 00h, 00h, 00h
		db	0A2h, 2Ah, 22h, 80h, 00h, 00h
		db	 00h, 00h, 08h, 88h, 88h, 00h
data_8A00	db	0			; Data table (indexed access)
		db	 00h, 00h, 04h, 0Fh, 00h,0F0h
		db	0F0h, 00h,0CFh,0CFh, 3Fh, 00h
		db	 3Fh, 3Fh,0FFh, 00h,0CFh, 5Fh
		db	 55h, 00h,0F5h, 0Fh, 05h, 55h
		db	 34h,0F0h,0F1h, 05h, 04h,0FFh
		db	0F1h, 05h, 04h,0FFh,0F1h, 05h
		db	 04h,0BFh,0E1h, 05h, 04h,0EAh
		db	0B1h, 04h, 04h,0ABh,0A1h, 50h
		db	 04h,0BAh,0A1h, 00h, 04h,0AAh
		db	0E1h, 00h, 05h, 00h, 05h, 00h
		db	 01h, 55h, 54h, 00h, 0Ch, 08h
		db	0AAh,0AAh,0AAh
		db	22 dup (0AAh)
		db	0BFh,0FAh,0AFh,0FAh,0BEh,0BEh
		db	0AFh,0FAh,0AFh,0FAh,0AAh,0AAh
		db	0BEh,0BEh,0BEh,0BEh,0BFh,0BEh
		db	0BEh,0BEh,0BEh,0BEh,0AAh,0AAh
		db	0BFh,0FAh,0BFh,0FEh,0BFh,0FEh
		db	0BEh,0AAh,0BEh,0BEh,0AAh,0AAh
		db	0BEh,0BEh,0BEh,0BEh,0BEh,0FEh
		db	0BEh,0BEh,0BEh,0BEh,0AAh,0AAh
		db	0BFh,0FAh,0BEh,0BEh,0BEh,0BEh
		db	0AFh,0FAh,0AFh,0FAh
		db	13 dup (0AAh)
		db	 0Ch, 08h
		db	0AAh,0AAh,0AAh,0AAh,0AAh
data_8AAA	db	0AAh			; Data table (indexed access)
		db	19 dup (0AAh)
		db	0AFh,0FEh,0AFh,0FAh,0BEh,0BEh
		db	0BFh,0FEh,0AFh,0FAh,0AAh,0AAh
		db	0BEh,0AAh,0BEh,0BEh,0BFh,0BEh
		db	0BAh,0FAh,0BEh,0BEh,0AAh,0AAh
		db	0BEh,0FEh,0BEh,0BEh,0BFh,0FEh
		db	0ABh,0EAh,0BEh,0BEh,0AAh,0AAh
		db	0BEh,0BEh,0BEh,0BEh,0BEh,0FEh
		db	0AFh,0AEh,0BEh,0BEh,0AAh,0AAh
		db	0AFh,0FAh,0AFh,0FAh,0BEh,0BEh
		db	0BFh,0FEh,0AFh,0FAh
		db	13 dup (0AAh)
		db	 0Ch, 08h
		db	24 dup (0AAh)
loc_8B1F:
		stosw				; Store ax to es:[di]
		jmp	dword ptr ss:data_EBFF[bp+di]	;*
sub_8964	endp

		db	0FFh,0EBh,0EBh,0FFh,0AAh,0FFh
		db	0AAh,0ABh,0EBh,0EBh,0EAh,0AAh
		db	0BEh,0ABh,0EBh,0EBh,0EBh,0EBh
		db	0EAh,0ABh,0FFh,0ABh,0FFh,0AAh
		db	0BEh,0ABh,0EBh,0FFh,0ABh,0EBh
		db	0EAh,0ABh,0EBh,0EBh,0EAh,0AAh
		db	0BEh,0ABh,0EBh,0EBh,0EBh,0EBh
		db	0EAh,0ABh,0EBh,0EBh,0FFh,0EAh
		db	0BEh,0ABh,0EBh,0EBh,0EAh,0FFh
		db	0AAh,0AAh,0AAh
		db	10 dup (0AAh)
		db	 0Ch, 08h
		db	25 dup (0AAh)
		db	0AFh,0FAh,0BFh,0FAh,0BFh,0FEh
		db	0BFh,0FAh,0AFh,0FAh,0AAh,0AAh
		db	0BEh,0BEh,0BEh,0BEh,0BEh,0AAh
		db	0BEh,0BEh,0BEh,0BEh,0AAh,0AAh
		db	0BEh,0BEh,0BFh,0FAh,0BFh,0FAh
		db	0BFh,0FAh,0BFh,0FEh,0AAh,0AAh
		db	0BEh,0BEh,0BEh,0AAh,0BEh,0AAh
		db	0BEh,0BEh,0BEh,0BEh,0AAh,0AAh
		db	0AFh,0FAh,0BEh,0AAh,0BFh,0FEh
		db	0BEh,0BEh,0BEh,0BEh,0AAh,0AAh
		db	11 dup (0AAh)
		db	 06h, 17h, 00h, 00h,0ABh,0C0h
		db	 00h, 00h, 00h,0A2h,0AFh, 3Ch
		db	 00h, 00h, 01h, 0Ah, 83h,0C0h
		db	 00h, 00h, 08h, 02h, 3Fh,0FFh
		db	 00h, 00h, 00h, 00h,0CFh,0C0h
		db	 00h, 00h, 00h, 00h,0FFh, 3Ch
		db	 03h, 00h, 00h, 00h, 3Fh,0FFh
		db	 0Fh,0F0h, 00h, 01h, 69h, 05h
		db	 0Fh,0C0h, 00h, 05h, 5Ah, 50h
		db	 07h, 00h, 00h, 04h, 46h, 95h
		db	 15h, 00h, 00h, 04h, 7Fh, 95h
		db	 54h, 00h, 00h, 05h, 3Fh, 94h
		db	 50h, 00h, 00h, 01h, 56h, 94h
		db	 00h, 00h, 00h, 05h, 51h, 50h
		db	 00h, 00h, 00h, 15h, 05h, 04h
		db	 00h, 00h, 00h, 14h, 15h, 44h
		db	 00h, 00h, 00h, 10h, 05h, 44h
		db	 00h, 00h, 00h, 04h, 01h, 44h
		db	 00h, 00h, 00h, 04h, 01h, 50h
		db	 00h, 00h, 00h, 00h, 01h, 40h
		db	 00h, 00h, 00h, 00h, 06h, 80h
		db	 00h, 00h, 00h, 00h, 3Bh,0F0h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 06h, 17h, 00h
		db	7 dup (0)
		db	0ABh,0C0h, 00h, 00h, 00h, 02h
		db	0AFh, 3Ch, 00h, 00h, 08h, 2Ah
		db	 83h,0C0h, 00h, 00h, 01h, 82h
		db	 3Fh,0FFh, 00h, 00h, 00h, 00h
		db	0CFh,0C0h, 00h, 00h, 00h, 00h
		db	0FFh, 3Ch, 03h, 00h, 00h, 00h
		db	 3Fh,0FFh, 0Fh,0F0h, 00h, 01h
		db	 69h, 05h, 0Fh,0C0h, 00h, 05h
		db	 5Ah, 50h, 07h, 00h, 00h, 04h
		db	 46h, 95h, 15h, 00h, 00h, 04h
		db	 7Fh, 95h, 54h, 00h, 00h, 05h
		db	 3Fh, 94h, 50h, 00h, 00h, 01h
		db	 56h, 94h, 00h, 00h, 00h, 05h
		db	 51h, 50h, 00h, 00h, 00h, 15h
		db	 04h, 45h, 00h, 00h, 00h, 14h
		db	 55h, 15h, 40h, 00h, 00h, 10h
		db	 15h, 41h, 40h, 00h, 00h, 10h
		db	 15h, 40h, 50h, 00h, 00h, 40h
		db	 15h, 00h, 50h, 00h, 00h, 00h
		db	 64h, 01h,0A0h, 00h, 00h, 03h
		db	0F0h, 00h,0FCh, 00h, 00h, 0Fh
		db	0FFh, 03h,0FFh,0C0h, 06h, 17h
		db	 20h, 00h, 00h, 00h, 00h, 00h
		db	 40h,0ABh,0C0h, 00h, 00h, 00h
		db	 82h,0AFh, 3Ch, 00h, 00h, 3Ch
		db	 2Ah, 83h,0C0h, 00h, 00h, 0Fh
		db	 02h, 3Fh,0FFh, 00h, 00h, 0Fh
		db	 00h,0CFh,0C0h, 03h, 00h, 0Fh
		db	 00h,0FFh, 3Ch, 3Fh,0C0h, 0Fh
		db	 00h, 3Fh,0FFh, 3Fh, 00h, 7Fh
		db	 00h, 6Ah, 45h, 14h, 05h,0B0h
		db	 01h, 7Fh, 90h, 50h, 55h, 40h
		db	 05h, 3Fh,0A5h, 05h, 50h, 00h
		db	 05h, 05h,0A9h, 55h, 00h, 00h
		db	 05h, 55h,0A5h, 50h, 00h, 00h
		db	 00h, 50h, 55h, 00h, 00h, 00h
		db	 00h, 05h, 56h, 40h, 00h, 00h
		db	 00h, 55h, 6Ah, 90h, 00h, 00h
		db	 01h, 54h, 5Ah,0A4h, 00h, 00h
		db	 05h, 40h, 05h,0A4h, 00h, 00h
		db	 05h, 40h, 00h, 59h, 00h, 00h
		db	 01h, 50h, 00h, 05h, 00h, 00h
		db	 00h, 68h, 00h, 01h, 00h, 00h
		db	 00h, 0Fh,0C0h, 00h, 00h, 00h
		db	 00h,0FFh,0F0h, 00h, 00h, 00h
		db	 06h, 17h, 00h, 00h, 03h,0EAh
		db	 00h, 00h, 00h, 00h, 3Ch,0FAh
		db	 8Ah, 00h, 00h, 00h, 03h,0C2h
		db	0A0h, 40h, 00h, 00h,0FFh,0FCh
		db	 80h, 20h, 00h, 00h, 03h,0F3h
		db	 00h, 00h, 00h,0C0h, 3Ch,0FFh
		db	 00h, 00h, 0Fh,0F0h,0FFh,0FCh
		db	 00h, 00h, 03h,0F0h, 50h, 69h
		db	 40h, 00h, 00h,0D0h, 05h,0A5h
		db	 50h, 00h, 00h, 54h, 56h, 91h
		db	 10h, 00h, 00h, 15h, 56h,0FDh
		db	 10h, 00h, 00h, 05h, 16h,0FCh
		db	 50h, 00h, 00h, 00h, 16h, 95h
		db	 40h, 00h, 00h, 00h, 05h, 45h
		db	 50h, 00h, 00h, 00h, 10h, 50h
		db	 54h, 00h, 00h, 00h, 11h, 54h
		db	 14h, 00h, 00h, 00h, 11h, 50h
		db	 04h, 00h, 00h, 00h, 11h, 40h
		db	 10h, 00h, 00h, 00h, 05h, 40h
		db	 10h, 00h, 00h, 00h, 01h, 40h
		db	 00h, 00h, 00h, 00h, 02h, 90h
		db	 00h, 00h, 00h, 00h, 0Fh,0ECh
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 06h, 17h, 00h
		db	7 dup (0)
		db	 03h,0EAh, 00h, 00h, 00h, 00h
		db	 3Ch,0FAh, 80h, 00h, 00h, 00h
		db	 03h,0C2h,0A8h, 20h, 00h, 00h
		db	0FFh,0FCh, 82h, 40h, 00h, 00h
		db	 03h,0F3h, 00h, 00h, 00h,0C0h
		db	 3Ch,0FFh, 00h, 00h, 0Fh,0F0h
		db	0FFh,0FCh, 00h, 00h, 03h,0F0h
		db	 50h, 69h, 40h, 00h, 00h,0D0h
		db	 05h,0A5h, 50h, 00h, 00h, 54h
		db	 56h, 91h, 10h, 00h, 00h, 15h
		db	 56h,0FDh, 10h, 00h, 00h, 05h
		db	 16h,0FCh, 50h, 00h, 00h, 00h
		db	 16h, 95h, 40h, 00h, 00h, 00h
		db	 05h, 45h, 50h, 00h, 00h, 00h
		db	 51h, 10h, 54h, 00h, 00h, 01h
		db	 54h, 55h, 14h, 00h, 00h, 01h
		db	 41h, 54h, 04h, 00h, 00h, 05h
		db	 01h, 54h, 04h, 00h, 00h, 05h
		db	 00h, 54h, 01h, 00h, 00h, 0Ah
		db	 40h, 19h, 00h, 00h, 00h, 3Fh
		db	 00h, 0Fh,0C0h, 00h, 03h,0FFh
		db	0C0h,0FFh,0F0h, 00h, 06h, 17h
		db	 00h, 00h, 00h, 00h, 00h, 08h
		db	 00h, 00h, 00h, 03h,0EAh, 01h
		db	 3Ch, 00h, 00h, 3Ch,0FAh, 82h
		db	0F0h, 00h, 00h, 03h,0C2h,0A8h
		db	0F0h, 00h, 00h,0FFh,0FCh, 80h
		db	0F0h, 00h,0C0h, 03h,0F3h, 00h
		db	0F0h, 03h,0FCh, 3Ch,0FFh, 00h
		db	0FDh, 00h,0FCh,0FFh,0FCh, 00h
		db	 0Eh, 50h, 14h, 51h,0A9h, 00h
		db	 01h, 55h, 05h, 06h,0FDh, 40h
		db	 00h, 05h, 50h, 5Ah,0FCh, 50h
		db	 00h, 00h, 55h, 6Ah, 50h, 50h
		db	 00h, 00h, 05h, 5Ah, 55h, 50h
		db	 00h, 00h, 00h, 55h, 05h, 00h
		db	 00h, 00h, 01h, 95h, 50h, 00h
		db	 00h, 00h, 06h,0A9h, 55h, 00h
		db	 00h, 00h, 1Ah,0A5h, 15h, 40h
		db	 00h, 00h, 1Ah, 50h, 01h, 50h
		db	 00h, 00h, 65h, 00h, 01h, 50h
		db	 00h, 00h, 50h, 00h, 05h, 40h
		db	 00h, 00h, 40h, 00h, 29h, 00h
		db	 00h, 00h, 00h, 03h,0F0h, 00h
		db	 00h, 00h, 00h, 0Fh,0FFh, 00h
		db	 07h, 14h, 00h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 55h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 00h, 00h,0AAh, 0Ch,0E0h, 00h
		db	 00h,0AAh, 00h, 2Ah,0A2h,0AAh
		db	 80h, 0Ah,0AAh,0A0h,0FAh,0AAh
		db	0AAh,0A0h, 2Ah, 88h, 0Bh, 3Fh
		db	 00h, 0Fh, 00h, 8Ah,0A2h,0FAh
		db	0F0h, 00h, 02h, 80h, 2Ah, 8Bh
		db	0FAh,0BCh, 00h, 00h, 00h, 88h
		db	0ABh,0F2h, 3Ch, 00h, 00h, 00h
		db	 22h, 83h,0FCh,0F2h, 00h, 00h
		db	 00h, 00h, 02h,0AAh,0A2h, 80h
		db	 00h, 00h, 00h, 00h,0AAh, 80h
		db	 80h, 00h, 00h, 00h, 00h, 0Ah
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah, 00h, 00h, 00h, 00h, 00h
		db	 00h, 28h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0ACh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FBh,0BCh
		db	 00h, 00h, 00h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 00h, 07h, 14h
		db	 00h
		db	9 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 55h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h,0AAh, 0Ch,0E0h
		db	 00h, 00h, 2Ah, 00h, 2Ah,0A2h
		db	0AAh, 80h, 02h,0AAh,0A8h,0FAh
		db	0AAh,0AAh,0A0h, 2Ah,0A8h, 0Ah
		db	 3Fh, 00h, 0Fh, 00h, 8Ah,0A2h
		db	0FCh,0A0h, 00h, 02h, 80h, 2Ah
		db	0ABh,0FCh,0A8h, 00h, 00h, 00h
		db	 88h,0ABh,0FCh, 2Ch, 00h, 00h
		db	 00h, 22h, 23h,0FFh,0F0h, 00h
		db	 00h, 00h, 02h, 82h,0AAh, 8Ah
		db	 00h, 00h, 00h, 00h, 00h,0A8h
		db	 2Ah, 80h, 00h, 00h, 00h, 00h
		db	0A0h, 02h,0A0h, 00h, 00h, 00h
		db	 0Ah,0A0h, 00h,0A0h, 00h, 00h
		db	 00h,0AAh, 00h, 00h,0A0h,0F0h
		db	 00h, 03h,0F8h, 00h, 00h,0BEh
		db	 50h, 00h, 01h, 6Fh, 00h, 00h
		db	0E5h, 00h, 00h, 00h, 16h,0F0h
		db	 00h, 50h, 00h, 00h, 07h, 14h
		db	 00h
		db	9 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 55h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h,0AAh, 0Ch,0E0h
		db	 00h, 02h,0A8h, 00h, 2Ah,0A2h
		db	0AAh, 80h, 2Ah,0AAh,0A0h,0FAh
		db	0AAh,0AAh,0A0h, 2Ah,0A2h, 0Fh
		db	 3Fh, 00h, 0Fh, 00h, 8Ah, 88h
		db	0A3h,0F0h, 00h, 02h, 80h, 2Ah
		db	 8Bh,0A8h,0FCh, 00h, 00h, 00h
		db	 88h,0ABh,0E0h,0FCh,0A0h, 00h
		db	 00h, 22h, 23h,0F3h,0F3h,0A8h
		db	 00h, 00h, 02h, 80h, 2Ah,0AAh
		db	 08h, 00h, 00h, 00h, 00h, 0Ah
		db	0AAh, 80h, 00h, 00h, 00h, 00h
		db	 80h, 02h,0A0h, 00h, 00h, 00h
		db	 0Ah,0A0h, 00h,0A0h, 00h, 00h
		db	 00h,0AAh, 00h, 00h,0A0h,0F0h
		db	 00h, 03h,0F8h, 00h, 00h,0BEh
		db	 50h, 00h, 01h, 6Fh, 00h, 00h
		db	0E5h, 00h, 00h, 00h, 16h,0F0h
		db	 00h, 50h, 00h, 00h, 07h, 14h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 02h,0A8h, 01h, 55h, 54h
		db	 00h, 00h, 02h,0A0h, 01h, 55h
		db	 55h, 40h, 00h, 00h,0E8h, 00h
		db	 00h, 3Ch, 00h, 00h, 00h, 3Fh
		db	 02h,0A8h, 33h, 80h, 00h, 00h
		db	 2Ah, 00h,0AAh, 8Ah,0AAh, 00h
		db	 02h,0AAh,0ABh,0EAh,0AAh,0AAh
		db	 80h, 2Ah,0A8h, 0Ah,0FCh, 00h
		db	 3Ch, 00h, 8Ah,0A2h,0FCh,0A0h
		db	 00h, 0Ah, 00h, 2Ah,0ABh,0FCh
		db	0A8h, 00h, 00h, 00h, 88h,0ABh
		db	0FCh, 2Ch, 00h, 00h, 00h, 22h
		db	 23h,0FFh, 32h,0A0h, 00h, 00h
		db	 02h, 82h,0AAh, 8Ah,0A8h, 00h
		db	 00h, 00h, 00h,0A8h, 00h, 28h
		db	0F0h, 00h, 00h, 00h,0A0h, 00h
		db	 2Bh, 90h, 00h, 00h, 0Ah,0A0h
		db	 00h, 2Fh, 40h, 00h, 00h,0AAh
		db	 00h, 00h, 39h, 00h, 00h, 03h
		db	0F8h, 00h, 00h, 14h, 00h, 00h
		db	 01h, 6Fh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 16h,0F0h, 00h, 00h
		db	 00h, 00h, 07h, 14h, 00h
		db	9 dup (0)
		db	 15h, 55h, 40h, 00h, 00h, 00h
		db	 00h, 15h, 55h, 54h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 00h, 00h, 2Ah, 83h, 38h
		db	 00h, 00h,0AAh, 00h, 0Ah,0A8h
		db	0AAh,0A0h, 0Ah,0AAh, 80h,0FAh
		db	0AAh,0AAh,0A8h, 2Ah,0A8h, 2Fh
		db	 3Fh, 00h, 03h,0C0h, 8Ah,0A2h
		db	0AFh,0F0h, 00h, 00h,0A0h, 2Ah
		db	0ABh,0A8h,0FCh,0F0h, 00h, 00h
		db	 88h,0ABh,0E0h,0FCh,0FFh,0EAh
		db	 00h, 22h, 23h,0C3h,0F0h, 03h
		db	0EAh, 80h, 02h, 82h,0AAh, 8Ah
		db	 00h, 08h, 20h, 00h, 00h,0A8h
		db	 2Ah, 80h, 00h, 00h, 00h, 00h
		db	0A0h, 02h,0A0h, 00h, 00h, 00h
		db	 0Ah,0A0h, 00h,0A0h, 00h, 00h
		db	 00h,0AAh, 00h, 00h,0A0h,0F0h
		db	 00h, 03h,0F8h, 00h, 00h,0BEh
		db	 50h, 00h, 01h, 6Fh, 00h, 00h
		db	0E5h, 00h, 00h, 00h, 16h,0F0h
		db	 00h, 50h, 00h, 00h, 07h, 14h
		db	 00h
		db	9 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 55h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h,0AAh, 0Ch,0E0h
		db	 00h, 02h,0A8h, 00h, 2Ah,0A2h
		db	0AAh, 80h, 2Ah,0AAh,0A0h,0FAh
		db	0AAh,0AAh,0A0h, 2Ah,0A2h, 0Fh
		db	 3Fh, 00h, 0Fh, 00h, 8Ah, 88h
		db	0A3h,0F2h,0A0h, 02h, 80h, 2Ah
		db	 8Bh,0A8h,0FEh,0A8h, 00h, 00h
		db	 88h,0ABh,0E0h,0FCh, 82h, 00h
		db	 00h, 22h, 23h,0F3h,0F2h,0A0h
		db	 00h, 00h, 00h, 02h,0AAh,0A2h
		db	0A8h, 00h, 00h, 1Eh, 82h,0AAh
		db	 88h, 28h, 00h, 00h, 1Ah,0A2h
		db	0A0h, 00h, 0Ah, 03h,0C0h, 1Fh
		db	 2Ah, 80h, 00h, 0Ah,0F9h, 40h
		db	 06h,0CAh, 00h, 00h, 03h, 94h
		db	 00h, 01h,0C0h, 00h, 00h, 01h
		db	 40h, 00h
		db	14 dup (0)
		db	 07h, 14h, 00h, 00h, 55h, 55h
		db	 00h, 00h, 00h, 00h, 00h, 55h
		db	 55h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh, 00h, 00h, 00h, 00h
		db	0A8h,0AAh, 0Ch,0E0h, 00h, 00h
		db	 0Ah,0AAh, 2Ah,0A2h,0AAh, 80h
		db	 00h, 2Ah,0A2h,0BAh,0AAh,0AAh
		db	0A0h, 00h, 8Ah,0A8h, 2Fh, 00h
		db	 0Fh, 00h, 00h, 2Ah, 82h, 0Ah
		db	 0Ah, 82h, 80h, 00h, 88h,0ABh
		db	0CAh, 8Ah,0A0h, 00h, 00h, 22h
		db	 2Bh,0C2h,0F2h, 08h, 00h, 00h
		db	 02h, 8Fh,0F0h,0F0h, 00h, 00h
		db	 00h, 00h, 03h,0FFh,0E8h, 00h
		db	 00h, 00h, 00h, 00h,0AAh,0A2h
		db	 80h, 00h, 00h, 00h, 00h, 0Ah
		db	0A8h, 28h, 0Fh, 00h, 00h, 00h
		db	 00h, 2Ah, 82h,0F0h, 00h, 00h
		db	 00h, 00h, 02h,0A8h, 0Fh, 00h
		db	 00h, 00h, 00h, 00h, 2Bh,0E5h
		db	 00h, 00h, 00h, 00h, 00h, 0Eh
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 05h
		db	9 dup (0)
		db	 07h, 14h, 00h
		db	51 dup (0)
		db	 55h, 55h, 00h, 00h, 02h,0A8h
		db	 00h, 55h, 55h, 50h, 00h, 2Ah
		db	0AAh, 80h, 00h, 0Fh, 00h, 00h
		db	 8Ah,0AAh,0A0h,0AAh, 0Ch,0E0h
		db	 00h, 2Ah,0AAh, 8Ch, 2Ah,0A2h
		db	0AAh, 80h, 88h,0ABh, 2Bh,0FAh
		db	0AAh,0AAh,0A0h, 22h, 2Fh,0EAh
		db	0FFh, 00h, 0Fh, 00h, 02h, 8Fh
		db	0CBh,0EAh,0A0h, 02h, 80h, 00h
		db	 03h,0FEh, 82h,0A0h, 00h, 00h
		db	 00h, 02h,0A8h,0AAh, 00h, 00h
		db	 00h, 00h, 0Ah,0A0h,0A8h, 00h
		db	 00h, 00h, 00h, 0Fh,0BCh,0FBh
		db	0B0h, 00h, 00h, 00h, 05h, 54h
		db	 55h, 54h, 00h, 00h, 06h, 14h
		db	 00h
		db	30 dup (0)
		db	 05h, 55h, 50h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 0Ah,0A0h,0CEh, 00h, 00h, 00h
		db	 02h,0AAh, 2Ah,0A8h, 00h, 00h
		db	 3Eh,0AAh,0AAh,0AAh, 00h, 00h
		db	 0Fh,0C0h, 00h, 3Ch, 00h, 02h
		db	0AFh, 00h, 00h, 0Ah, 00h, 2Ah
		db	0ABh,0F0h, 00h, 00h, 00h,0AAh
		db	0BEh,0BFh, 00h,0A0h, 00h, 8Ah
		db	0BEh,0AFh,0A2h,0A8h, 0Dh, 2Ah
		db	0ACh, 8Eh,0AAh, 0Ah, 09h, 8Ah
		db	0ABh, 3Eh,0A8h, 02h,0BDh, 22h
		db	 28h,0FEh,0A0h, 02h,0F9h, 08h
		db	0A0h, 3Ah, 00h, 00h, 54h, 06h
		db	 14h, 00h
		db	30 dup (0)
		db	 01h, 00h, 00h, 00h, 00h, 01h
		db	 44h, 00h, 00h, 00h, 00h, 05h
		db	 50h, 0Ah, 00h, 05h, 00h, 15h
		db	 72h, 28h, 00h, 0Eh, 50h, 55h
		db	 3Eh,0A3h,0C0h, 00h,0E5h, 54h
		db	0AAh, 80h,0A0h, 00h, 3Fh, 52h
		db	0AAh, 00h, 00h, 00h,0A0h, 0Ah
		db	0A8h, 00h, 00h, 00h,0A0h, 02h
		db	0AFh, 00h, 00h, 02h, 80h, 2Ah
		db	0FFh,0FFh, 00h, 0Ah, 00h,0AAh
		db	0AAh,0FFh,0F0h,0A8h, 0Dh, 8Ah
		db	0ABh,0A3h,0EAh,0A2h, 09h, 2Ah
		db	0ABh,0A8h,0AAh, 8Ah,0BDh, 88h
		db	0ABh,0E3h,0AAh, 02h,0F9h, 22h
		db	 20h,0CFh,0A0h, 00h, 54h, 05h
		db	 13h, 00h, 05h, 54h, 00h, 00h
		db	 00h, 55h, 58h, 2Ah, 00h, 05h
		db	 56h,0AAh, 0Ah, 00h, 05h, 6Ah
		db	0AAh, 2Ah, 00h, 00h, 2Ah,0AAh
		db	 0Fh, 00h, 00h,0AAh,0AFh,0AFh
		db	 00h, 00h, 0Ah,0FAh,0AFh, 00h
		db	 00h, 0Fh,0AAh,0ABh, 00h, 00h
		db	 3Eh,0AAh, 28h, 00h, 03h,0F8h
		db	 88h,0A2h, 00h, 0Fh,0FEh, 22h
		db	0FAh, 80h, 0Fh, 0Fh,0FFh,0A8h
		db	 80h, 00h, 0Ah,0AAh, 82h, 80h
		db	 00h, 2Ah, 80h, 0Ah, 80h, 00h
		db	 28h, 00h, 0Ah, 30h, 00h, 2Ah
		db	 00h, 0Ah,0C0h, 00h, 0Ah,0A0h
		db	 0Fh, 00h, 00h, 03h,0A0h, 00h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 05h, 13h, 00h, 00h, 15h, 50h
		db	 00h, 00h,0A8h, 25h, 55h, 00h
		db	 00h,0A0h,0AAh, 95h, 50h, 00h
		db	0A8h,0AAh,0A9h, 50h, 00h,0F0h
		db	0AAh,0A8h, 00h, 00h,0FAh,0FAh
		db	0AAh, 00h, 00h,0FAh,0AFh,0A0h
		db	 00h, 00h,0EAh,0AAh,0F0h, 00h
		db	 00h, 28h,0AAh,0BCh, 00h, 00h
		db	 8Ah, 22h, 2Fh,0C0h, 02h,0AFh
		db	 88h,0BFh,0F0h, 02h, 2Ah,0FFh
		db	0F0h,0F0h, 02h, 82h,0AAh,0A0h
		db	 00h, 02h,0A0h, 02h,0A8h, 00h
		db	 0Ch,0A0h, 00h, 28h, 00h, 03h
		db	0A0h, 00h,0A8h, 00h, 00h,0F0h
		db	 0Ah,0A0h, 00h, 00h, 00h, 0Ah
		db	0C0h, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 07h, 14h, 00h
		db	9 dup (0)
		db	 15h, 55h, 40h, 00h, 00h, 00h
		db	 00h, 15h, 55h, 54h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0C0h, 00h
		db	 00h,0AAh, 00h, 2Ah, 83h, 38h
		db	 00h, 0Ah,0AAh,0A0h, 0Ah,0A8h
		db	0AAh,0A0h, 2Ah, 88h, 0Bh, 3Eh
		db	0AAh,0AAh,0A8h, 8Ah,0A2h,0FAh
		db	0FFh,0C0h, 03h,0C0h, 2Ah, 8Bh
		db	0FAh,0BCh, 00h, 00h,0A0h, 88h
		db	0ABh,0F2h, 3Ch, 00h, 00h, 00h
		db	 22h, 83h,0FCh,0F3h, 00h, 00h
		db	 00h, 00h, 02h,0AAh,0A3h,0EAh
		db	 00h, 00h, 00h, 00h,0AAh, 83h
		db	0A9h, 55h, 00h, 00h, 00h, 02h
		db	0A0h, 29h, 55h, 40h, 00h, 00h
		db	 00h,0A0h, 03h, 33h, 00h, 00h
		db	 00h, 02h, 80h, 03h, 33h, 00h
		db	 00h, 00h, 0Ah, 00h, 0Ch,0FCh
		db	0C0h, 00h, 00h, 2Ch, 00h, 0Ch
		db	 30h,0C0h, 00h, 00h,0FBh,0BCh
		db	 00h, 00h, 00h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 00h, 07h, 14h
		db	 00h
		db	16 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 55h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h,0AAh, 0Ch,0E0h
		db	 00h, 00h, 2Ah, 00h, 2Ah,0A2h
		db	0AAh, 80h, 02h,0AAh,0A8h,0FAh
		db	0AAh, 0Ah,0A0h, 2Ah,0A8h, 0Ah
		db	 3Fh, 20h,0AFh, 00h, 8Ah,0A2h
		db	0FCh,0A0h, 2Ah, 82h, 80h, 2Ah
		db	0ABh,0FCh,0A8h, 3Ah, 00h, 00h
		db	 88h,0ABh,0FCh, 2Ch,0F0h, 00h
		db	 00h, 22h, 23h,0FFh,0FAh, 80h
		db	 00h, 00h, 02h, 80h,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 01h, 55h
		db	 00h,0A0h, 00h, 00h, 00h, 05h
		db	 55h, 40h,0A0h, 00h, 00h, 00h
		db	 03h, 33h, 00h,0A0h, 00h, 00h
		db	 00h, 03h, 33h,0C0h,0ACh, 00h
		db	 00h, 00h, 0Ch,0FCh,0C0h,0FBh
		db	0B0h, 00h, 00h, 0Ch, 30h,0C0h
		db	 55h, 54h, 00h, 07h, 14h, 00h
		db	16 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 55h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h,0AAh, 0Ch,0E0h
		db	 00h, 00h, 2Ah, 00h, 2Ah,0A2h
		db	0AAh, 80h, 02h,0AAh,0A8h,0FAh
		db	0AAh, 0Ah,0A0h, 2Ah,0A8h, 0Ah
		db	 3Fh, 20h,0AFh, 00h, 8Ah,0A2h
		db	0FCh,0A0h, 2Ah, 82h, 80h, 2Ah
		db	0ABh,0FCh,0A8h, 3Ah, 00h, 00h
		db	 88h,0ABh,0FCh, 2Ch,0F0h, 00h
		db	 00h, 22h, 23h,0FFh,0FAh, 80h
		db	 00h, 00h, 02h, 80h,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 01h, 55h
		db	 00h,0A0h, 00h, 00h, 00h, 05h
		db	 55h, 40h,0A0h, 00h, 00h, 00h
		db	 03h, 33h, 00h,0A0h,0F0h, 00h
		db	 00h, 03h, 33h,0C0h,0BEh, 50h
		db	 00h, 00h, 0Ch,0FCh,0C0h,0E5h
		db	 00h, 00h, 00h, 0Ch, 30h,0C0h
		db	 50h, 00h, 00h, 07h, 14h, 00h
		db	 00h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 55h, 00h, 00h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 0Bh, 30h,0AAh
		db	 00h, 00h, 00h, 02h,0AAh, 8Ah
		db	0A8h, 00h,0AAh, 00h, 0Ah,0AAh
		db	0AAh,0AFh, 0Ah,0AAh,0A0h, 00h
		db	0F0h, 00h,0FCh,0E0h, 22h,0A8h
		db	 02h, 80h, 00h, 0Fh,0AFh, 8Ah
		db	0A2h, 00h, 00h, 00h, 3Eh,0AFh
		db	0E2h,0A8h, 00h, 00h, 00h, 3Ch
		db	 8Fh,0EAh, 22h, 00h, 00h, 00h
		db	 8Fh, 3Fh,0C2h, 88h, 00h, 00h
		db	 02h, 8Ah,0AAh, 80h, 00h, 00h
		db	 00h, 02h, 02h,0AAh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 00h,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 28h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah, 00h, 00h, 00h, 00h
		db	 00h, 00h, 3Ah, 00h, 00h, 00h
		db	 00h, 00h, 3Eh,0EFh, 00h, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 07h, 14h, 00h
		db	8 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh, 30h,0AAh, 00h
		db	 00h, 00h, 02h,0AAh, 8Ah,0A8h
		db	 00h,0A8h, 00h, 0Ah,0AAh,0AAh
		db	0AFh, 2Ah,0AAh, 80h, 00h,0F0h
		db	 00h,0FCh,0A0h, 2Ah,0A8h, 02h
		db	 80h, 00h, 0Ah, 3Fh, 8Ah,0A2h
		db	 00h, 00h, 00h, 2Ah, 3Fh,0EAh
		db	0A8h, 00h, 00h, 00h, 38h, 3Fh
		db	0EAh, 22h, 00h, 00h, 00h, 0Fh
		db	0FFh,0C8h, 88h, 00h, 00h, 00h
		db	0A2h,0AAh, 82h, 80h, 00h, 00h
		db	 02h,0A8h, 2Ah, 00h, 00h, 00h
		db	 00h, 0Ah, 80h, 0Ah, 00h, 00h
		db	 00h, 00h, 0Ah, 00h, 0Ah,0A0h
		db	 00h, 00h, 0Fh, 0Ah, 00h, 00h
		db	0AAh, 00h, 00h, 05h,0BEh, 00h
		db	 00h, 2Fh,0C0h, 00h, 00h, 5Bh
		db	 00h, 00h,0F9h, 40h, 00h, 00h
		db	 05h, 00h, 0Fh, 94h, 00h, 07h
		db	 14h, 00h
		db	8 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh, 30h,0AAh, 00h
		db	 00h, 00h, 02h,0AAh, 8Ah,0A8h
		db	 00h, 2Ah, 80h, 0Ah,0AAh,0AAh
		db	0AFh, 0Ah,0AAh,0A8h, 00h,0F0h
		db	 00h,0FCh,0F0h, 8Ah,0A8h, 02h
		db	 80h, 00h, 0Fh,0CAh, 22h,0A2h
		db	 00h, 00h, 00h, 3Fh, 2Ah,0E2h
		db	0A8h, 00h, 00h, 0Ah, 3Fh, 0Bh
		db	0EAh, 22h, 00h, 00h, 2Ah,0CFh
		db	0CFh,0C8h, 88h, 00h, 00h, 20h
		db	0AAh,0A8h, 02h, 80h, 00h, 00h
		db	 02h,0AAh,0A0h, 00h, 00h, 00h
		db	 00h, 0Ah, 80h, 02h, 00h, 00h
		db	 00h, 00h, 0Ah, 00h, 0Ah,0A0h
		db	 00h, 00h, 0Fh, 0Ah, 00h, 00h
		db	0AAh, 00h, 00h, 05h,0BEh, 00h
		db	 00h, 2Fh,0C0h, 00h, 00h, 5Bh
		db	 00h, 00h,0F9h, 40h, 00h, 00h
		db	 05h, 00h, 0Fh, 94h, 00h, 07h
		db	 14h, 00h
		db	8 dup (0)
		db	 15h, 55h, 40h, 2Ah, 80h, 00h
		db	 01h, 55h, 55h, 40h, 0Ah, 80h
		db	 00h, 00h, 3Ch, 00h, 00h, 2Bh
		db	 00h, 00h, 02h,0CCh, 2Ah, 80h
		db	0FCh, 00h, 00h,0AAh,0A2h,0AAh
		db	 00h,0A8h, 00h, 02h,0AAh,0AAh
		db	0ABh,0EAh,0AAh, 80h, 00h, 3Ch
		db	 00h, 3Fh,0A0h, 2Ah,0A8h, 00h
		db	0A0h, 00h, 0Ah, 3Fh, 8Ah,0A2h
		db	 00h, 00h, 00h, 2Ah, 3Fh,0EAh
		db	0A8h, 00h, 00h, 00h, 38h, 3Fh
		db	0EAh, 22h, 00h, 00h, 0Ah, 8Ch
		db	0FFh,0C8h, 88h, 00h, 00h, 2Ah
		db	0A2h,0AAh, 82h, 80h, 00h, 0Fh
		db	 28h, 00h, 2Ah, 00h, 00h, 00h
		db	 06h,0E8h, 00h, 0Ah, 00h, 00h
		db	 00h, 01h,0F8h, 00h, 0Ah,0A0h
		db	 00h, 00h, 00h, 6Ch, 00h, 00h
		db	0AAh, 00h, 00h, 00h, 14h, 00h
		db	 00h, 2Fh,0C0h, 00h, 00h, 00h
		db	 00h, 00h,0F9h, 40h, 00h, 00h
		db	 00h, 00h, 0Fh, 94h, 00h
data_9919	dw	1407h			; Data table (indexed access)
		db	0
		db	7 dup (0)
		db	 01h, 55h, 54h, 00h, 00h, 00h
		db	 00h, 15h, 55h, 54h, 00h, 00h
		db	 00h, 00h, 03h,0C0h, 00h, 00h
		db	 00h, 00h, 00h, 2Ch,0C2h,0A8h
		db	 00h, 00h, 00h, 0Ah,0AAh, 2Ah
		db	0A0h, 00h,0AAh, 00h, 2Ah,0AAh
		db	0AAh,0AFh, 02h,0AAh,0A0h, 03h
		db	0C0h, 00h,0FCh,0F8h, 2Ah,0A8h
		db	 0Ah, 00h, 00h, 0Fh,0FAh, 8Ah
		db	0A2h, 00h, 00h, 0Fh, 3Fh, 2Ah
		db	0EAh,0A8h, 00h,0ABh,0FFh, 3Fh
		db	 0Bh,0EAh, 22h, 02h,0ABh,0C0h
		db	 0Fh,0C3h,0C8h, 88h, 08h, 20h
		db	 00h,0A2h,0AAh, 82h, 80h, 00h
		db	 00h, 02h,0A8h, 2Ah, 00h, 00h
		db	 00h, 00h, 0Ah, 80h, 0Ah, 00h
		db	 00h, 00h, 00h, 0Ah, 00h, 0Ah
		db	0A0h, 00h, 00h, 0Fh, 0Ah, 00h
		db	 00h,0AAh, 00h, 00h, 05h,0BEh
		db	 00h, 00h, 2Fh,0C0h, 00h, 00h
		db	 5Bh, 00h, 00h,0F9h, 40h, 00h
		db	 00h, 05h, 00h, 0Fh, 94h, 00h
		db	 07h, 14h, 00h
		db	8 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh, 30h,0AAh, 00h
		db	 00h, 00h, 02h,0AAh, 8Ah,0A8h
		db	 00h, 2Ah, 80h, 0Ah,0AAh,0AAh
		db	0AFh, 0Ah,0AAh,0A8h, 00h,0F0h
		db	 00h,0FCh,0F0h, 8Ah,0A8h, 02h
		db	 80h, 0Ah, 8Fh,0CAh, 22h,0A2h
		db	 00h, 00h, 2Ah,0BFh, 2Ah,0E2h
		db	0A8h, 00h, 00h, 82h, 3Fh, 0Bh
		db	0EAh, 22h, 00h, 00h, 0Ah, 8Fh
		db	0CFh,0C8h, 88h, 00h, 00h, 2Ah
		db	 8Ah,0AAh, 80h, 00h, 00h, 00h
		db	 28h, 22h,0AAh, 82h,0B4h, 03h
		db	0C0h,0A0h, 00h, 0Ah, 8Ah,0A4h
		db	 01h, 6Fh,0A0h, 00h, 02h,0A8h
		db	0F4h, 00h, 16h,0C0h, 00h, 00h
		db	0A3h, 90h, 00h, 01h, 40h, 00h
		db	 00h, 03h
		db	40h
		db	14 dup (0)
		db	 07h, 14h, 00h, 00h, 00h, 55h
		db	 55h, 00h, 00h, 00h, 00h, 05h
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 0Bh, 30h,0AAh, 2Ah, 00h
		db	 00h, 02h,0AAh, 8Ah,0A8h,0AAh
		db	0A0h, 00h, 0Ah,0AAh,0AAh,0AEh
		db	 8Ah,0A8h, 00h, 00h,0F0h, 00h
		db	0F8h, 2Ah,0A2h, 00h, 02h, 82h
		db	0A0h,0A0h, 82h,0A8h, 00h, 00h
		db	 0Ah,0A2h,0A3h,0EAh, 22h, 00h
		db	 00h, 20h, 8Fh, 83h,0E8h, 88h
		db	 00h, 00h, 00h, 0Fh, 0Fh,0F2h
		db	 80h, 00h, 00h, 00h, 2Bh,0FFh
		db	0C0h, 00h, 00h, 00h, 02h, 8Ah
		db	0AAh, 00h, 00h, 00h,0F0h, 28h
		db	 2Ah,0A0h, 00h, 00h, 00h, 0Fh
		db	 82h,0A8h, 00h, 00h, 00h, 00h
		db	0F0h, 2Ah, 80h, 00h, 00h, 00h
		db	 00h, 5Bh,0E8h, 00h, 00h, 00h
		db	 00h, 00h, 05h,0B0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 00h
		db	10 dup (0)
		db	 07h, 14h, 00h
		db	50 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 2Ah, 80h
		db	 00h, 00h,0F0h, 00h, 02h,0AAh
		db	0A8h, 00h, 0Bh, 30h,0AAh, 0Ah
		db	0AAh,0A2h, 02h,0AAh, 8Ah,0A8h
		db	 32h,0AAh,0A8h, 0Ah,0AAh,0AAh
		db	0AFh,0E8h,0EAh
loc_9B1F:
		and	al,[bx+si]
;*                         lock	add	bh,bh
		db	0F0h, 00h,0FFh		;  Fixup - byte match
		stosw				; Store ax to es:[di]
		clc				; Clear carry flag
		mov	[bp+si],al
		or	byte ptr [bp+si],0ABh
		jcxz	loc_9B1F		; Jump if cx=0
		add	byte ptr [bx+si],0
		or	al,ss:data_C0BF[bp+si]
		db	 00h, 00h, 00h, 00h,0AAh, 2Ah
		db	 80h, 00h, 00h, 00h, 00h, 2Ah
		db	 0Ah,0A0h, 00h, 00h, 00h, 0Eh
		db	0EFh, 3Eh,0F0h, 00h, 00h, 00h
		db	 15h, 55h, 15h, 50h, 00h, 06h
		db	 14h, 00h
		db	31 dup (0)
		db	 05h, 55h, 50h, 00h, 00h, 00h
		db	 55h, 55h, 50h, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	0B3h, 0Ah,0A0h, 00h, 00h, 2Ah
		db	0A8h,0AAh, 80h, 00h, 00h,0AAh
		db	0AAh,0AAh,0BCh, 00h, 00h, 3Ch
		db	 00h, 03h,0F0h, 00h, 00h,0A0h
		db	 00h, 00h,0FAh, 80h, 00h, 00h
		db	 00h, 0Fh,0EAh,0A8h, 00h, 0Ah
		db	 00h,0FEh,0BEh,0AAh, 70h, 2Ah
		db	 8Ah,0FAh,0BEh,0A2h, 60h,0A0h
		db	0AAh,0B2h, 3Ah,0A8h, 7Eh, 80h
		db	 2Ah,0BCh,0EAh,0A2h, 6Fh, 80h
		db	 0Ah,0BFh, 28h, 88h, 15h, 00h
		db	 00h,0ACh, 0Ah, 20h, 06h, 14h
		db	 00h
		db	33 dup (0)
		db	 40h, 00h, 00h, 00h, 00h, 00h
		db	 11h, 40h, 00h, 50h, 00h,0A0h
		db	 05h, 50h, 05h,0B0h, 00h, 28h
		db	 8Dh, 54h, 5Bh, 00h, 03h,0CAh
data_9C07	dw	55BCh
		db	0FCh, 00h, 0Ah, 02h,0AAh, 15h
		db	 0Ah, 00h, 00h, 00h,0AAh, 85h
		db	 0Ah, 00h, 00h, 00h, 2Ah,0A0h
		db	 02h, 80h, 00h, 00h,0FAh, 80h
		db	 00h,0A0h, 00h,0FFh,0FFh,0A8h
		db	 70h, 2Ah, 0Fh,0FFh,0AAh,0AAh
		db	 60h, 8Ah,0ABh,0CAh,0EAh,0A2h
		db	 7Eh,0A2h,0AAh, 2Ah,0EAh,0A8h
		db	 6Fh, 80h,0AAh,0CBh,0EAh, 22h
		db	 15h, 00h, 0Ah,0F3h, 08h, 88h
		db	 07h, 14h
		db	8 dup (0)
		db	 01h, 55h, 54h, 00h, 00h, 00h
		db	 00h, 15h, 55h, 54h, 00h, 00h
		db	 00h, 00h, 03h,0C0h, 00h, 00h
		db	 00h, 00h, 00h, 2Ch,0C2h,0A8h
		db	 00h,0AAh, 00h, 0Ah,0AAh, 2Ah
		db	0A0h, 0Ah,0AAh,0A0h, 2Ah,0AAh
		db	0AAh,0BCh,0E0h, 22h,0A8h, 03h
		db	0C0h, 03h,0FFh,0AFh, 8Ah,0A2h
		db	 0Ah, 00h, 00h, 3Eh,0AFh,0E2h
		db	0A8h, 00h, 00h, 00h, 3Ch, 8Fh
		db	0EAh, 22h, 00h, 00h, 00h,0CFh
		db	 3Fh,0C2h, 88h, 00h, 00h,0ABh
		db	0CAh,0AAh, 80h, 00h, 00h, 55h
		db	 6Ah,0C2h,0AAh, 00h, 00h, 01h
		db	 55h, 68h, 0Ah, 80h, 00h, 00h
		db	 00h,0CCh,0C0h, 0Ah, 00h, 00h
		db	 00h, 00h,0CCh,0C0h, 02h, 80h
		db	 00h, 00h, 03h
data_9CB8	db	3Fh			; Data table (indexed access)
		db	 30h, 00h,0A0h, 00h, 00h, 03h
		db	 0Ch, 30h, 00h, 38h, 00h, 00h
		db	 00h, 00h, 00h, 3Eh,0EFh, 00h
		db	 00h, 00h, 00h, 00h, 55h, 55h
		db	 00h, 00h, 07h, 14h, 00h
		db	15 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh, 30h,0AAh, 00h
		db	 00h, 00h, 02h,0AAh, 8Ah,0A8h
		db	 00h,0A8h, 00h, 0Ah,0A0h,0AAh
		db	0AFh, 2Ah,0AAh, 80h, 00h,0FAh
		db	 08h,0FCh,0A0h, 2Ah,0A8h, 02h
		db	 82h,0A8h, 0Ah, 3Fh, 8Ah,0A2h
		db	 00h, 00h,0ACh, 2Ah, 3Fh,0EAh
		db	0A8h, 00h, 00h, 0Fh, 38h, 3Fh
		db	0EAh, 22h, 00h, 00h, 02h,0AFh
		db	0FFh,0C8h, 88h, 00h, 00h, 0Ah
		db	0AAh,0AAh, 02h, 80h, 00h, 00h
		db	 0Ah, 00h, 55h, 40h, 00h, 00h
		db	 00h, 0Ah, 01h, 55h, 50h, 00h
		db	 00h, 00h, 0Ah, 00h,0CCh,0C0h
		db	 00h, 00h, 00h, 3Ah, 03h,0CCh
		db	0C0h, 00h, 00h, 0Eh,0EFh, 03h
		db	 3Fh, 30h, 00h, 00h, 15h, 55h
		db	 03h, 0Ch, 30h, 00h, 07h, 14h
		db	 00h
		db	15 dup (0)
		db	 55h, 55h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh, 30h,0AAh, 00h
		db	 00h, 00h, 02h,0AAh, 8Ah,0A8h
		db	 00h,0A8h, 00h, 0Ah,0A0h,0AAh
		db	0AFh, 2Ah,0AAh, 80h, 00h,0FAh
		db	 08h,0FCh,0A0h, 2Ah,0A8h, 02h
		db	 82h,0A8h, 0Ah, 3Fh, 8Ah,0A2h
		db	 00h, 00h,0ACh, 2Ah, 3Fh,0EAh
		db	0A8h, 00h, 00h, 0Fh, 38h, 3Fh
		db	0EAh, 22h, 00h, 00h, 02h,0AFh
		db	0FFh,0C8h, 88h, 00h, 00h, 0Ah
		db	0AAh,0AAh, 02h, 80h, 00h, 00h
		db	 0Ah, 00h, 55h, 40h, 00h, 00h
		db	 00h, 0Ah, 01h, 55h, 50h, 00h
		db	 00h, 0Fh, 0Ah, 00h,0CCh,0C0h
		db	 00h, 00h, 05h,0BEh, 03h,0CCh
		db	0C0h, 00h, 00h, 00h, 5Bh, 03h
		db	 3Fh, 30h, 00h, 00h, 00h, 05h
		db	 03h, 0Ch, 30h, 00h, 08h, 15h
		db	 00h, 00h, 00h, 00h, 00h,0AAh
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh,0AAh, 00h, 00h, 00h
		db	 00h, 00h,0FEh,0AFh,0FAh,0C0h
		db	 00h, 00h, 00h, 00h,0CEh,0BFh
		db	 8Fh, 00h, 00h, 00h, 00h, 00h
		db	0FAh,0BFh, 0Fh, 00h, 00h, 00h
		db	 00h, 0Ah,0AAh,0CFh,0F0h,0C0h
		db	 00h, 00h, 00h,0A2h,0A0h,0F0h
		db	0FFh,0F0h, 00h, 00h, 0Ah, 2Ah
		db	0AAh, 3Fh, 28h, 00h, 00h, 00h
		db	 28h,0AAh,0AAh, 83h,0FFh, 00h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	 80h, 00h, 00h, 00h, 8Ah,0AAh
		db	0AAh, 0Ah,0A0h, 00h, 00h, 02h
		db	 2Ah,0AAh,0AAh,0A2h,0A8h, 00h
		db	 00h, 02h, 2Ah,0A8h,0AAh,0A8h
		db	0AAh, 00h, 00h, 08h,0AAh,0AAh
		db	 2Ah,0AAh, 2Ah, 00h, 00h, 08h
		db	0AAh,0AAh, 8Ah,0AAh, 2Ah, 80h
		db	 00h, 0Ah, 2Ah,0AAh, 82h,0AAh
		db	 88h, 80h, 00h, 02h,0AAh,0AAh
		db	 88h,0A8h, 8Ah, 30h, 00h, 00h
		db	 0Ah,0AAh, 2Ah, 22h, 32h,0F0h
		db	 00h, 0Eh,0AAh,0A8h,0A8h, 08h
		db	0F3h,0F0h, 00h, 0Fh,0AAh, 82h
		db	0A0h, 03h,0FFh,0C0h, 00h, 03h
		db	0FFh,0F3h,0FCh, 3Fh,0C0h, 00h
		db	 08h, 15h, 00h, 00h, 00h, 00h
		db	0AAh,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0AAh,0AAh, 00h, 00h
		db	 00h, 00h, 00h,0FEh,0AFh,0FAh
		db	0C0h, 00h, 00h, 00h, 00h,0CEh
		db	0BFh, 8Fh, 00h, 00h, 00h, 00h
		db	 00h,0FAh,0BFh, 0Fh, 00h, 00h
		db	 00h, 00h, 00h,0AAh,0CFh,0F0h
		db	0C0h, 00h, 00h, 00h, 0Ah,0A0h
		db	0F0h,0FFh,0F0h, 00h, 00h, 00h
		db	0AAh,0AAh, 3Ch, 28h, 00h, 00h
		db	 00h, 0Ah, 2Ah,0AAh, 8Fh,0A8h
		db	 00h, 00h, 00h, 2Ah,0AAh,0AAh
		db	0ABh,0FFh, 00h, 00h, 00h, 8Ah
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	 02h, 2Ah,0AAh,0AAh,0AAh, 20h
		db	 00h, 00h, 02h, 2Ah, 8Ah,0AAh
		db	0A0h,0A0h, 00h, 00h, 08h,0AAh
		db	0A2h,0AAh, 8Ah,0A0h, 00h, 00h
		db	 08h,0AAh,0A8h,0AAh, 8Ah,0A0h
		db	 00h, 00h, 0Ah, 2Ah,0A8h,0AAh
		db	 8Ah,0A0h, 00h, 00h, 02h,0AAh
		db	0A8h,0AAh, 8Ah,0A0h, 00h, 00h
		db	 00h, 0Ah,0AAh, 28h,0CAh, 30h
		db	 00h, 00h, 00h, 2Ah,0AAh, 2Bh
		db	0CAh,0F0h, 00h, 00h, 00h,0FAh
		db	0AAh, 0Fh,0CBh,0F0h, 00h, 00h
		db	 00h, 3Fh,0FCh,0FFh, 3Fh,0C0h
		db	 00h, 00h, 08h, 15h, 00h, 00h
		db	 0Ah,0AAh, 80h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh,0A0h, 00h
		db	 00h, 00h, 00h, 0Fh,0EAh,0FFh
		db	0ACh, 00h, 00h, 00h, 00h, 0Ch
		db	0EBh,0F8h,0F0h, 00h, 00h, 00h
		db	 00h, 0Fh,0ABh,0F0h,0F0h, 00h
		db	 00h, 00h, 00h, 00h,0ACh,0FFh
		db	 0Ch, 00h, 00h, 00h, 00h, 0Ah
		db	 8Fh, 0Fh,0FFh, 00h, 00h, 00h
		db	 00h,0AAh,0A3h,0F2h, 80h, 00h
		db	 00h, 00h, 02h,0AAh,0A8h, 3Fh
		db	0F0h, 00h, 00h, 00h, 0Ah,0AAh
		db	0AAh,0AAh, 80h, 00h, 00h, 00h
		db	 0Ah,0AAh,0AAh,0F3h,0FCh, 0Ah
		db	 80h, 00h, 2Ah,0A8h,0ABh,0CFh
		db	0FFh, 2Ah,0A0h, 00h, 2Ah,0A8h
		db	0ABh,0FFh,0FFh,0AAh,0A0h, 00h
		db	 2Ah,0A2h,0ABh,0EAh,0AFh,0AAh
		db	0A0h, 00h, 2Ah,0A2h,0A8h,0AAh
		db	0A8h,0A2h, 3Fh,0F0h, 2Ah,0A2h
		db	0AAh,0AAh,0AAh, 0Bh,0FFh, 00h
		db	 08h, 82h,0AAh,0A8h,0AAh, 03h
		db	0C0h, 00h, 02h, 30h,0AAh,0A2h
		db	0A2h, 00h, 00h, 00h, 03h,0F3h
		db	0AAh,0A8h, 8Bh,0FFh, 00h, 00h
		db	 0Fh,0CFh, 2Ah, 80h, 3Fh,0F0h
		db	 00h, 00h,0FFh, 3Ch, 00h, 00h
		db	 0Fh,0C0h, 00h, 00h, 08h, 15h
		db	 00h, 02h,0AAh,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 2Ah,0AAh,0A8h
		db	 05h, 55h, 50h, 00h, 03h
data_A000	db	0FAh			; Data table (indexed access)
		db	0BFh,0EBh, 05h, 55h, 55h, 00h
		db	 03h, 3Ah,0FEh, 3Ch, 00h, 00h
		db	0F0h, 00h, 03h,0EAh,0FCh, 3Ch
		db	 0Ah,0A0h,0CEh, 00h, 00h,0ABh
		db	 3Fh,0C3h, 02h,0AAh, 2Ah,0A8h
		db	 02h,0ABh,0CFh,0FFh,0C3h,0EAh
		db	0AAh,0AAh, 0Ah,0A3h,0F0h,0A0h
		db	 00h,0FCh, 00h,0F0h, 08h,0A8h
		db	 3Fh,0FCh, 23h, 03h, 00h, 28h
		db	 22h,0AAh,0A8h, 22h, 8Fh,0FFh
		db	 00h, 00h, 2Ah,0AAh,0AAh, 88h
		db	 23h,0FFh, 00h, 00h, 8Ah,0A2h
		db	0AAh,0A2h,0A8h,0FCh,0C0h, 00h
		db	0AAh, 88h, 2Ah,0AAh,0A8h, 03h
		db	0A0h, 2Dh, 8Ah,0AAh, 8Ah,0AAh
		db	0A0h,0AAh,0A8h,0ADh, 8Ah,0AAh
		db	0A2h,0AAh, 00h, 2Ah, 2Ah,0B9h
		db	0A2h,0AAh,0A8h, 00h, 00h, 0Ah
		db	 0Ah, 0Dh, 2Ah, 2Ah,0AAh, 2Ah
		db	 00h, 0Ah, 00h, 09h, 02h,0AAh
		db	0A8h,0AAh, 00h, 28h, 00h, 0Dh
		db	 0Eh,0AAh,0A2h,0A8h, 03h,0A0h
		db	 00h, 00h, 0Fh,0AAh, 0Ah,0A0h
		db	 01h, 78h, 00h, 00h, 03h,0FFh
		db	0F3h,0FFh, 00h, 15h, 40h, 00h
		db	 08h, 15h, 00h, 00h, 0Ah,0AAh
		db	 85h, 55h, 50h, 00h, 00h, 00h
		db	0AAh,0AAh,0A5h
		db	 55h, 55h
data_A0A8	db	0			; Data table (indexed access)
		db	 00h, 0Fh,0EAh,0FFh,0ACh, 00h
		db	 00h, 00h, 00h, 0Ch,0EBh,0FFh
		db	0FEh,0A0h,0CEh, 00h, 00h, 0Fh
		db	0ABh,0F0h,0F2h,0AAh, 2Ah,0A8h
		db	 00h, 02h,0ACh,0FFh, 0Ch,0EAh
		db	0AAh,0AAh, 00h, 0Ah,0AFh, 3Fh
		db	0FFh, 3Ch, 00h, 00h, 00h,0AAh
		db	0A3h,0C0h, 83h, 03h, 28h, 3Ch
		db	 0Ah, 2Ah,0A8h,0F2h,0AFh,0FFh
		db	 02h, 8Ah, 22h,0AAh,0AAh, 3Fh
		db	0F3h,0FFh, 00h, 00h, 2Ah,0AAh
		db	0AAh,0AAh,0A8h,0FCh,0C0h, 00h
		db	 8Ah,0A2h,0AAh,0AAh,0A8h, 03h
		db	0A0h, 00h,0AAh, 88h, 2Ah,0AAh
		db	0A0h,0AAh,0AAh, 00h, 8Ah,0AAh
		db	 82h,0AAh, 00h,0A8h, 0Ah, 80h
		db	 8Ah,0AAh,0A0h, 20h, 00h,0A0h
		db	 02h, 80h,0A2h,0AAh,0A8h,0A8h
		db	 00h,0A0h, 02h, 8Fh, 2Ah, 2Ah
		db	0AAh, 2Ah, 00h, 28h, 02h,0EDh
		db	 02h,0AAh,0A8h,0AAh, 00h, 0Ah
		db	0C3h, 94h, 0Eh
data_A12A	db	0AAh			; Data table (indexed access)
		db	0A2h,0A8h, 00h, 03h, 41h, 40h
		db	 0Fh,0AAh, 0Ah,0A0h, 00h, 39h
		db	 00h, 00h, 03h,0FFh,0F3h,0FFh
		db	 00h,0F4h, 00h, 00h
data_A141	db	8
		db	 15h, 00h, 2Ah,0AAh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 00h, 03h
		db	0AFh,0FAh,0BFh, 00h, 00h, 00h
		db	 00h, 00h,0F2h,0FEh,0B3h, 00h
		db	 00h, 00h, 00h, 00h,0F0h,0FEh
		db	0AFh, 00h, 00h, 00h, 00h, 03h
		db	 0Fh,0F3h,0AAh,0A0h, 00h, 00h
		db	 00h, 0Fh,0FFh, 0Fh, 0Ah, 8Ah
		db	 00h, 00h, 00h, 00h, 28h,0FCh
		db	0AAh,0A8h,0A0h, 00h, 00h, 00h
		db	0FFh,0C2h,0AAh,0AAh, 28h, 00h
		db	 00h, 00h, 02h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 0Ah,0A0h
		db	0AAh,0AAh,0A2h, 00h, 00h, 00h
		db	 2Ah, 8Ah,0AAh,0AAh,0A8h, 80h
		db	 00h, 00h,0AAh, 2Ah,0AAh, 2Ah
		db	0A8h, 80h, 00h, 00h,0A8h,0AAh
		db	0A8h,0AAh,0AAh, 20h, 00h, 02h
		db	0A8h,0AAh,0A2h,0AAh,0AAh, 20h
		db	 00h, 02h, 22h,0AAh, 82h,0AAh
		db	0A8h,0A0h, 00h, 0Ch,0A2h, 2Ah
		db	 22h,0AAh,0AAh, 80h, 00h, 0Fh
		db	 8Ch, 88h,0A8h,0AAh,0A0h, 00h
		db	 00h, 0Fh,0CFh, 20h, 2Ah, 2Ah
		db	0AAh,0B0h, 00h, 03h,0FFh,0C0h
		db	 0Ah, 82h,0AAh,0F0h, 00h, 00h
		db	 03h,0FCh, 3Fh,0CFh,0FFh,0C0h
		db	 00h
data_A1EB	db	8
		db	 15h, 00h, 00h, 2Ah,0AAh, 00h
		db	 00h, 00h, 00h, 00h, 00h,0AAh
		db	0AAh,0A0h, 00h, 00h, 00h, 00h
		db	 03h,0AFh,0FAh,0BFh, 00h, 00h
		db	 00h, 00h, 00h,0F2h,0FEh,0B3h
		db	 00h, 00h, 00h, 00h, 00h,0F0h
		db	0FEh,0AFh, 00h, 00h, 00h, 00h
		db	 03h, 0Fh,0F3h,0AAh, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh, 0Fh, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 28h
		db	 3Ch,0AAh,0AAh, 00h, 00h, 00h
		db	 00h
		db	2Ah
data_A230	db	0F2h			; Data table (indexed access)
		db	0AAh,0A8h,0A0h, 00h, 00h, 00h
		db	0FFh,0EAh,0AAh,0AAh,0A8h, 00h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0A2h, 00h, 00h, 00h, 08h,0AAh
		db	0AAh,0AAh,0A8h, 80h, 00h, 00h
		db	 0Ah, 0Ah,0AAh,0A2h,0A8h, 80h
		db	 00h, 00h, 0Ah,0A2h,0AAh, 8Ah
		db	0AAh, 20h, 00h, 00h, 0Ah,0A2h
		db	0AAh, 2Ah,0AAh, 20h, 00h, 00h
		db	 0Ah,0A2h,0AAh, 2Ah,0A8h,0A0h
		db	 00h, 00h, 0Ah,0A2h,0AAh, 2Ah
		db	0AAh, 80h, 00h, 00h, 0Ch,0A3h
		db	 28h,0AAh,0A0h, 00h, 00h, 00h
		db	 0Fh,0A3h,0E8h,0AAh,0A8h, 00h
		db	 00h, 00h, 0Fh,0E3h,0F0h,0AAh
		db	0AFh, 00h, 00h, 00h, 03h,0FCh
		db	0FFh, 3Fh,0FCh, 00h, 08h, 15h
		db	 00h, 00h, 00h, 02h,0AAh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 0Ah
		db	0AAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 3Ah,0FFh,0ABh,0F0h, 00h
		db	 00h, 00h, 00h, 0Fh, 2Fh,0EBh
		db	 30h, 00h, 00h, 00h, 00h, 0Fh
		db	 0Fh,0EAh,0F0h, 00h, 00h, 00h
		db	 00h, 30h,0FFh, 3Ah, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0F0h,0F2h
		db	0A0h, 00h, 00h, 00h, 00h, 02h
		db	 8Fh,0CAh,0AAh, 00h, 00h, 00h
		db	 00h, 0Fh,0FCh, 2Ah,0AAh, 80h
		db	 00h, 00h, 00h, 02h,0AAh,0AAh
		db	0AAh,0A0h, 00h, 02h,0A0h, 3Fh
		db	0CFh,0AAh,0AAh,0A0h, 00h, 0Ah
		db	0A8h,0FFh,0F3h,0EAh, 2Ah,0A8h
		db	 00h, 0Ah,0AAh,0FFh,0FFh,0EAh
		db	 2Ah,0A8h, 00h, 0Ah,0AAh,0FAh
		db	0ABh,0EAh, 8Ah,0A8h, 0Fh,0FCh
		db	 8Ah
		db	2Ah
data_A30B	db	0AAh
		db	 2Ah, 8Ah,0A8h, 00h,0FFh,0E0h
		db	0AAh,0AAh,0AAh, 8Ah,0A8h, 00h
		db	 03h,0C0h,0AAh, 2Ah,0AAh, 82h
		db	 20h, 00h, 00h, 00h, 8Ah, 8Ah
		db	0AAh, 0Ch, 80h, 00h, 00h,0FFh
		db	0E2h, 2Ah,0AAh,0CFh,0C0h, 00h
		db	 00h, 0Fh,0FCh, 02h,0A8h,0F3h
		db	0F0h, 00h, 00h, 03h,0F0h, 00h
		db	 00h, 3Ch,0FFh, 08h, 15h, 00h
		db	 00h, 00h, 00h, 0Ah,0AAh, 80h
		db	 00h, 00h, 05h, 55h, 50h, 2Ah
		db	0AAh,0A8h, 00h, 00h
		db	 55h, 55h, 50h
loc_A355:
		jmp	short loc_A355
			                        ;* No entry point to code
		scasw				; Scan es:[di] for ax
		rol	byte ptr [bx+si],0Fh	; Rotate
		add	[bx+si],al
		cmp	al,0BFh
		lodsb				; String [si] to al
		rol	byte ptr [bx+si],0B3h	; Rotate
		or	ah,byte ptr ds:[3F3Ch][bx+si]
		stosw				; Store ax to es:[di]
		shr	byte ptr [bp+si],0A8h	; Shift w/zeros fill
		stosb				; Store al to es:[di]
		add	bl,0FCh
;*		jmp	far ptr l_ABAA_AA00	;*
		db	0EAh
		dw	0AA00h, 0ABAAh		;  Fixup - byte match
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
;*		push	bx
		db	0FFh,0F3h		;  Fixup - byte match
;*		jmp	far ptr l_3F00_0F80	;*
		db	0EAh
		dw	0F80h, 3F00h		;  Fixup - byte match
		db	 00h, 0Ah, 0Fh,0CAh,0A0h, 28h
		db	 00h,0C0h,0C8h, 3Fh,0FCh, 2Ah
		db	 20h, 00h, 00h,0FFh,0F2h, 88h
		db	 2Ah,0AAh, 88h, 00h, 00h,0FFh
		db	0C8h, 22h,0AAh,0AAh,0A8h, 00h
		db	 03h, 3Fh, 2Ah, 8Ah,0AAh, 8Ah
		db	0A2h, 78h, 0Ah,0C0h, 2Ah,0AAh
		db	0A8h, 22h,0AAh, 7Ah, 2Ah,0AAh
		db	 0Ah,0AAh,0A2h,0AAh,0A2h, 6Eh
		db	0A8h,0A8h, 00h,0AAh, 8Ah,0AAh
		db	0A2h, 70h,0A0h,0A0h, 00h, 00h
		db	 2Ah,0AAh, 8Ah
		db	60h
data_A3C2	dw	0A000h
		db	 00h,0A8h,0AAh,0A8h,0A8h, 70h
		db	 00h, 28h, 00h,0AAh, 2Ah,0AAh
		db	 80h, 00h, 00h, 0Ah,0C0h, 2Ah
		db	 8Ah,0AAh,0B0h, 00h, 00h, 2Dh
		db	 40h, 0Ah,0A0h,0AAh,0F0h, 00h
		db	 01h, 54h, 00h,0FFh,0CFh,0FFh
		db	0C0h
data_A3E9	dw	1508h
		db	 00h, 05h, 55h, 52h,0AAh,0A0h
		db	 00h, 00h, 00h, 55h, 55h, 5Ah
		db	0AAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 3Ah,0FFh,0ABh,0F0h, 00h
		db	 00h,0B3h, 0Ah,0BFh,0FFh,0EBh
		db	 30h, 00h, 2Ah,0A8h,0AAh, 8Fh
		db	 0Fh,0EAh,0F0h, 00h,0AAh,0AAh
		db	0ABh, 30h,0FFh, 3Ah, 80h, 00h
		db	 00h, 00h, 3Ch,0FFh,0FCh,0FAh
		db	0A0h, 00h, 3Ch, 28h,0C0h,0C2h
		db	 03h,0CAh,0AAh, 00h,0A2h, 80h
		db	0FFh,0FAh, 8Fh, 2Ah,0A8h,0A0h
		db	 00h, 00h,0FFh,0CFh,0FCh,0AAh
		db	0AAh, 88h, 00h, 03h, 3Fh, 2Ah
		db	0AAh,0AAh,0AAh,0A8h, 00h, 0Ah
		db	0C0h, 2Ah,0AAh,0AAh, 8Ah,0A2h
		db	 00h,0AAh,0AAh, 0Ah,0AAh,0A8h
		db	 22h,0AAh, 02h,0A0h, 2Ah, 00h
		db	0AAh, 82h,0AAh,0A2h, 02h, 80h
		db	 0Ah, 00h, 08h, 0Ah,0AAh,0A2h
		db	0F2h, 80h, 0Ah, 00h, 2Ah, 2Ah
		db	0AAh, 8Ah, 7Bh, 80h, 28h, 00h
		db	0A8h,0AAh,0A8h,0A8h, 16h,0C3h
		db	0A0h, 00h,0AAh, 2Ah,0AAh, 80h
		db	 01h, 41h,0C0h, 00h, 2Ah, 8Ah
		db	0AAh,0B0h, 00h, 00h, 6Ch, 00h
		db	 0Ah,0A0h,0AAh,0F0h, 00h, 00h
		db	 1Fh, 00h,0FFh,0CFh,0FFh,0C0h
		db	 05h, 0Ch, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 03h, 00h, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 00h, 0Fh
		db	0C0h, 00h, 00h, 00h, 3Fh,0F0h
		db	 00h, 00h, 00h, 3Fh,0BCh, 00h
		db	 00h, 00h,0FFh,0EFh, 00h, 00h
		db	 00h,0FFh,0EBh, 00h, 00h, 00h
		db	0FFh,0ABh, 00h, 00h, 00h,0FEh
		db	0AFh, 00h, 00h, 00h, 3Fh,0FCh
		db	 00h, 00h, 05h, 0Ch, 00h
		db	20 dup (0)
		db	 03h, 00h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 00h, 00h, 0Fh,0C0h
		db	 00h, 00h, 00h, 3Fh,0FCh, 00h
		db	 00h, 03h,0FFh,0EFh,0C0h, 00h
		db	 0Fh,0FFh,0ABh,0F0h, 00h, 0Fh
		db	0FEh,0AFh,0F0h, 00h, 03h,0FFh
		db	0FFh,0C0h, 00h, 05h, 0Ch, 00h
		db	 00h, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 00h, 0Fh, 00h,0F0h, 00h
		db	 00h, 00h, 00h, 00h, 00h,0F0h
		db	 00h,0BEh, 00h, 00h,0A0h,0A0h
		db	 00h, 00h, 30h, 00h,0F0h, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	0FFh, 00h, 0Fh, 0Bh, 00h,0F0h
		db	 0Fh
		db	12 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 05h, 0Ch
		db	 00h
		db	10 dup (0)
		db	0F0h, 00h, 00h, 00h, 00h, 20h
		db	 00h,0F0h, 00h, 0Fh, 00h, 00h
		db	 20h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 02h, 00h, 8Fh, 00h, 00h, 0Fh
		db	 00h,0F0h, 0Fh
		db	12 dup (0)
		db	0FFh,0FFh,0FFh, 00h, 04h, 14h
		db	 00h, 15h, 55h, 50h, 01h, 7Fh
		db	0FCh, 00h, 07h, 00h,0F0h, 00h
		db	 1Ch, 3Fh, 30h, 00h, 10h,0FFh
		db	 00h, 00h, 70h,0F0h,0FFh,0F0h
		db	 70h,0F0h,0FFh,0F0h, 7Ch, 3Fh
		db	 00h,0F0h, 7Fh,0FCh,0FFh,0C0h
		db	 7Fh,0FFh, 00h, 00h, 7Ch, 0Fh
		db	 00h, 00h, 70h,0FFh,0C0h, 00h
		db	 70h, 0Fh,0F0h, 00h, 70h,0F0h
		db	 00h, 00h, 7Fh,0FFh,0F0h, 00h
		db	 1Fh,0FFh,0C0h, 00h, 1Fh,0FFh
		db	 00h, 00h, 07h,0FFh,0C0h, 00h
		db	 01h, 7Fh,0FCh, 00h, 00h, 15h
		db	 55h, 50h, 04h, 14h, 00h, 15h
		db	 55h, 50h, 01h, 7Fh,0FCh, 00h
		db	 07h, 03h,0F0h, 00h, 1Ch, 30h
		db	0F0h, 00h, 10h,0FFh, 00h, 00h
		db	 70h,0F0h,0FFh,0F0h, 70h,0F0h
		db	0FFh,0F0h, 7Ch, 3Fh, 00h,0F0h
		db	 7Fh,0FCh,0FFh,0C0h, 7Fh,0FFh
		db	 00h, 00h, 7Fh, 0Fh, 00h, 00h
		db	 7Fh,0F0h, 3Fh, 00h, 7Fh,0F0h
		db	0F0h, 00h, 7Fh,0F0h, 00h, 00h
		db	 7Fh,0F0h,0F0h, 00h, 1Fh, 0Fh
		db	 3Fh, 00h, 1Fh,0FFh, 00h, 00h
		db	 07h,0FFh,0F0h, 00h, 01h, 7Fh
		db	0FFh, 00h, 00h, 15h, 55h, 50h
		db	 04h, 14h, 05h, 55h, 54h, 00h
		db	 00h, 3Fh,0FDh, 40h, 00h, 0Fh
		db	 00h,0D0h, 00h, 0Ch,0FCh, 34h
		db	 00h, 00h,0FFh, 04h, 0Fh,0FFh
		db	 0Fh, 0Dh, 0Fh,0FFh, 0Fh, 0Dh
		db	 0Fh, 00h,0FCh, 3Dh, 03h,0FFh
		db	 3Fh,0FDh, 00h, 00h,0FFh,0FDh
		db	 00h, 00h,0F0h, 3Dh, 00h, 03h
		db	0FFh, 0Dh, 00h, 0Fh,0F0h, 0Dh
		db	 00h, 00h, 0Fh, 0Dh, 00h, 0Fh
		db	0FFh,0FDh, 00h, 03h,0FFh,0F4h
		db	 00h, 00h,0FFh,0F4h, 00h, 03h
		db	0FFh,0D0h, 00h, 3Fh,0FDh, 40h
		db	 05h, 55h, 54h, 00h, 04h, 14h
		db	 05h, 55h, 54h, 00h, 00h, 3Fh
		db	0FDh, 40h, 00h, 0Fh,0C0h,0D0h
		db	 00h, 0Fh, 0Ch, 34h, 00h, 00h
		db	0FFh, 04h, 0Fh,0FFh, 0Fh, 0Dh
		db	 0Fh,0FFh, 0Fh, 0Dh, 0Fh, 00h
		db	0FCh, 3Dh, 03h,0FFh, 3Fh,0FDh
		db	 00h, 00h,0FFh,0FDh, 00h, 00h
		db	0F0h,0FDh, 00h,0FCh, 0Fh,0FDh
		db	 00h, 0Fh, 0Fh,0FDh, 00h, 00h
		db	 0Fh,0FDh, 00h, 0Fh, 0Fh,0FDh
		db	 00h,0FCh,0F0h,0F4h, 00h, 00h
		db	0FFh,0F4h, 00h, 0Fh,0FFh,0D0h
		db	 00h,0FFh,0FDh, 40h, 05h, 55h
		db	 54h, 00h, 06h, 17h, 00h
		db	7 dup (0)
		db	 30h,0FFh, 00h, 00h, 00h, 03h
		db	 0Fh, 3Fh,0F3h, 00h, 00h, 00h
		db	0F3h,0EAh, 0Ch, 00h, 00h, 33h
		db	0CFh,0A3h,0A0h, 00h, 00h, 0Fh
		db	0FFh,0AAh,0A8h, 00h, 00h, 03h
		db	 0Eh,0EAh, 00h, 00h, 00h, 00h
		db	0EAh,0A0h,0C0h, 10h, 00h, 0Fh
		db	0FAh, 00h, 20h, 70h, 00h, 3Ah
		db	0FFh, 00h, 01h,0F0h, 00h,0AAh
		db	0FFh, 00h, 07h,0C0h, 00h,0AFh
		db	0FFh,0C2h, 9Ch, 00h, 00h,0ABh
		db	0FFh,0FAh,0A0h, 00h, 00h, 2Ah
		db	0BFh, 0Ah, 50h, 00h, 00h, 02h
		db	0A0h, 50h, 50h, 00h, 00h, 00h
		db	 05h, 50h, 10h, 00h, 00h, 00h
		db	 50h, 55h, 00h, 00h, 00h, 00h
		db	 50h, 05h, 40h, 00h, 00h, 05h
		db	 50h, 00h, 50h, 00h, 01h, 45h
		db	 00h, 00h, 50h, 0Ah, 0Ah, 50h
		db	 00h, 00h, 05h,0AAh, 0Ah,0A0h
		db	 00h, 00h, 5Ah,0A0h, 02h,0AAh
		db	 80h, 00h, 0Ah, 00h, 06h, 17h
		db	 00h, 00h, 00h,0FFh, 0Ch, 00h
		db	 00h, 00h, 0Fh,0FFh,0F3h, 00h
		db	 00h, 0Ch,0F3h,0EAh, 00h, 00h
		db	 00h, 03h, 3Fh,0A3h,0A0h, 00h
		db	 00h, 0Fh,0F3h,0AAh,0A8h, 00h
		db	 00h, 33h, 0Eh,0AAh, 00h, 00h
		db	 00h, 00h, 0Ah,0A0h,0C0h, 10h
		db	 00h, 00h,0EAh, 00h, 20h, 70h
		db	 00h, 0Fh,0FAh, 00h, 01h,0F0h
		db	 00h, 3Eh,0BFh, 00h, 07h,0C0h
		db	 00h, 3Ah,0AFh, 02h, 9Ch, 00h
		db	 00h, 3Ah,0FFh,0CAh,0A0h, 00h
		db	 00h, 0Ah,0BFh,0FAh, 50h, 00h
		db	 00h, 02h,0AAh, 00h, 50h, 00h
		db	 00h, 00h, 18h, 40h, 10h, 00h
		db	 00h, 00h, 01h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 05h, 40h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h,0A5h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0A0h, 00h, 00h
		db	 00h, 00h, 82h,0AAh, 00h, 00h
		db	 06h, 17h, 00h, 00h, 0Ch, 3Fh
		db	0C0h, 00h, 00h, 00h, 03h,0CFh
		db	0FCh,0C0h, 00h, 03h, 3Ch,0FAh
		db	 83h, 00h, 00h, 0Ch,0F3h,0E8h
		db	0E8h, 00h, 00h, 03h,0FFh,0EAh
		db	0AAh, 00h, 00h, 00h,0C3h,0AAh
		db	 80h, 04h, 00h, 00h, 02h,0A8h
		db	 30h, 1Ch, 00h, 00h,0EAh, 00h
		db	 08h, 7Ch, 00h, 0Fh,0FAh, 00h
		db	 01h,0F0h, 00h, 3Eh,0BFh, 00h
		db	0A7h, 00h, 00h, 3Ah,0AFh, 02h
		db	0A8h, 00h, 00h, 3Ah,0FFh,0EAh
		db	 94h, 00h, 00h, 0Ah,0BFh,0F8h
		db	 14h, 00h, 00h, 02h,0AAh, 00h
		db	 04h, 00h, 00h, 00h, 18h, 40h
		db	 00h, 00h, 00h, 00h, 01h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 50h
		db	 00h, 00h, 00h, 00h, 05h, 40h
		db	 00h, 00h, 00h, 00h, 50h, 00h
		db	 00h, 00h, 00h, 00h,0A5h, 00h
		db	 00h, 00h, 00h, 00h,0AAh,0A0h
		db	 00h, 00h, 00h, 00h, 82h,0AAh
		db	 00h, 00h, 06h, 17h, 00h
		db	7 dup (0)
		db	0FFh, 0Ch, 00h, 00h, 00h,0CFh
		db	0FCh,0F0h,0C0h, 00h, 00h, 30h
		db	0ABh,0CFh, 00h, 00h, 00h, 0Ah
		db	0CAh,0F3h,0CCh, 00h, 00h, 2Ah
		db	0AAh,0FFh,0F0h, 00h, 00h, 00h
		db	0ABh,0B0h,0C0h, 00h, 04h, 03h
		db	 0Ah,0ABh, 00h, 00h
		db	0Dh
data_A8AA	db	8			; Data table (indexed access)
		db	 00h,0AFh,0F0h, 00h, 0Fh, 40h
		db	 00h,0FFh,0ACh, 00h, 03h,0D0h
		db	 00h,0FFh,0AAh, 00h, 00h, 36h
		db	 83h,0FFh,0FAh, 00h, 00h, 0Ah
		db	0AFh,0FFh,0EAh, 00h, 00h, 05h
		db	0A0h,0FEh,0A8h, 00h, 00h, 05h
		db	 05h, 0Ah, 80h, 00h, 00h, 04h
		db	 05h, 50h, 00h, 00h, 00h, 00h
		db	 55h, 05h, 00h, 00h, 00h, 01h
		db	 50h, 05h, 00h, 00h, 00h, 05h
		db	 00h, 05h, 50h, 00h,0A0h, 05h
		db	 00h, 00h, 51h, 40h,0AAh, 50h
		db	 00h, 00h, 05h,0A0h, 0Ah,0A5h
		db	 00h, 00h, 0Ah,0A0h, 00h,0A0h
		db	 00h, 02h,0AAh, 80h, 06h, 17h
		db	 00h, 30h,0FFh, 00h, 00h, 00h
		db	 00h,0CFh,0FFh,0F0h, 00h, 00h
		db	 00h, 00h,0ABh,0CFh, 30h, 00h
		db	 00h, 0Ah,0CAh,0FCh,0C0h, 00h
		db	 00h, 2Ah,0AAh,0CFh,0F0h, 00h
		db	 00h, 00h,0AAh,0B0h,0CCh, 00h
		db	 04h, 03h, 0Ah,0A0h, 00h, 00h
		db	 0Dh, 08h, 00h,0ABh, 00h, 00h
		db	 0Fh, 40h, 00h,0AFh,0F0h, 00h
		db	 03h,0D0h, 00h,0FEh,0BCh, 00h
		db	 00h, 36h, 80h,0FAh,0ACh, 00h
		db	 00h, 0Ah,0A3h,0FFh,0ACh, 00h
		db	 00h, 05h,0AFh,0FEh,0A0h, 00h
		db	 00h, 05h, 00h,0AAh, 80h, 00h
		db	 00h, 04h, 01h, 24h, 00h, 00h
		db	 00h, 00h, 05h, 40h, 00h, 00h
		db	 00h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 05h, 00h, 00h
		db	 00h, 00h, 00h, 5Ah, 00h, 00h
		db	 00h, 00h, 0Ah,0AAh, 00h, 00h
		db	 00h, 00h,0AAh, 82h, 00h, 00h
data_A98F	dw	1706h			; Data table (indexed access)
		db	 00h, 03h,0FCh, 30h, 00h, 00h
		db	 03h, 3Fh,0F3h,0C0h, 00h, 00h
		db	 00h,0C2h,0AFh, 3Ch,0C0h, 00h
		db	 00h, 2Bh, 2Bh,0CFh, 30h, 00h
		db	 00h,0AAh,0ABh,0FFh,0C0h, 00h
		db	 10h, 02h,0AAh,0C3h, 00h, 00h
		db	 34h, 0Ch, 2Ah, 80h, 00h, 00h
		db	 3Dh, 20h, 00h,0ABh, 00h, 00h
		db	 0Fh, 40h, 00h,0AFh,0F0h, 00h
		db	 00h,0DAh, 00h,0FEh,0BCh, 00h
		db	 00h, 2Ah, 80h,0FAh,0ACh, 00h
		db	 00h, 16h,0ABh,0FFh,0ACh, 00h
		db	 00h, 14h, 2Fh,0FEh,0A0h, 00h
		db	 00h, 10h, 00h,0AAh, 80h, 00h
		db	 00h, 00h, 01h, 24h, 00h, 00h
		db	 00h, 00h, 05h, 40h, 00h, 00h
		db	 00h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 01h
data_AA00	db	50h			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 00h, 05h
		db	 00h, 00h, 00h, 00h, 00h, 5Ah
		db	 00h, 00h, 00h, 00h, 0Ah,0AAh
		db	 00h, 00h, 00h, 00h,0AAh, 82h
		db	 00h, 00h, 06h, 17h, 00h, 00h
		db	 55h, 50h, 00h
data_AA22	db	0F0h			; Data table (indexed access)
		db	 00h, 05h,0A5h, 00h, 00h,0F0h
		db	 00h, 00h, 55h, 55h, 00h,0F0h
		db	 00h, 02h,0BCh,0AAh, 00h,0F0h
		db	 00h, 08h,0AFh, 80h, 02h,0F8h
		db	 00h, 02h,0AAh, 0Ah, 02h,0E8h
		db	 05h, 50h,0AAh,0AAh, 00h,0A8h
		db	 25h, 55h, 50h,0A8h, 01h, 50h
		db	 54h, 05h, 56h, 11h, 55h, 40h
		db	0A8h, 05h,0A9h,0A4h, 14h, 00h
		db	0AAh, 01h,0A9h, 69h, 40h, 00h
		db	0A0h, 01h, 65h, 5Ah, 50h, 00h
		db	 20h, 00h, 55h, 5Ah, 50h, 00h
		db	 00h, 00h, 2Ah,0AAh, 40h, 00h
		db	 00h, 00h, 55h, 54h, 00h, 00h
		db	 00h, 00h, 55h, 01h, 40h, 00h
		db	 00h, 00h, 50h, 15h
		db	40h
data_AA82	db	0			; Data table (indexed access)
		db	 00h, 01h, 50h, 01h, 50h, 00h
		db	 00h, 05h, 40h, 00h, 50h, 00h
		db	 01h, 55h, 00h, 00h, 50h, 0Ah
		db	 0Ah, 50h, 00h, 00h, 15h,0AAh
		db	 0Ah,0A8h, 00h, 00h, 1Ah,0A0h
		db	 02h,0AAh, 80h, 00h, 0Ah, 00h
		db	 06h
data_AAA8	dw	17h			; Data table (indexed access)
data_AAAA	db	0			; Data table (indexed access)
		db	 55h, 50h, 3Ch, 00h, 00h, 05h
		db	0A5h, 00h, 0Fh, 00h, 00h, 00h
		db	 55h, 55h, 03h
data_AABA	db	0C0h
		db	 00h, 02h,0BCh,0AAh, 02h,0F8h
		db	 00h, 08h,0AFh, 80h, 02h,0B8h
		db	 00h, 02h,0AAh, 0Ah, 00h,0A8h
		db	 00h, 00h,0AAh,0AAh, 00h, 50h
		db	 00h, 05h, 50h,0A8h, 01h, 50h
		db	 00h, 55h, 56h, 11h, 55h, 40h
		db	 01h, 55h,0A9h,0A4h, 14h, 00h
		db	 05h, 41h,0A9h, 69h, 40h, 00h
		db	 09h, 01h, 65h, 5Ah, 50h, 00h
		db	 05h, 00h, 55h, 5Ah, 50h, 00h
		db	 2Ah, 00h, 0Ah,0AAh, 40h, 00h
		db	 2Ah, 80h, 15h, 55h, 00h, 00h
		db	 28h, 00h, 05h, 54h, 00h, 00h
		db	 08h, 00h, 01h, 59h, 00h, 00h
		db	 00h, 00h, 00h, 59h, 00h, 00h
		db	 00h, 00h, 00h, 59h, 00h, 00h
		db	 00h, 00h, 05h, 64h, 00h, 00h
		db	 00h, 00h, 15h, 90h, 00h, 00h
		db	 00h, 00h, 2Ah,0A8h, 80h, 00h
		db	 00h, 00h, 2Ah,0AAh, 20h, 00h
data_AB33	dw	1706h			; Data table (indexed access)
		db	 00h, 05h, 55h, 00h, 00h, 00h
		db	 00h, 5Ah, 50h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 50h, 00h, 03h
		db	 00h, 2Bh,0CAh,0A0h, 00h, 0Fh
		db	 00h, 8Ah,0F8h, 00h, 00h, 3Ch
		db	 00h, 2Ah,0A0h,0A0h, 02h,0F0h
		db	 00h, 0Ah,0AAh,0A0h, 0Bh,0E0h
		db	 15h, 40h, 0Ah, 80h, 5Ah, 80h
		db	 95h, 55h, 61h, 15h, 56h, 00h
		db	 54h, 1Ah, 9Ah, 41h, 40h, 00h
		db	0A8h, 1Ah, 96h, 94h, 00h, 00h
		db	0AAh, 16h, 55h,0A5h, 00h, 00h
		db	0A0h, 05h, 55h,0A5h, 00h, 00h
		db	 20h, 00h,0AAh,0A4h, 00h
data_AB88	db	0			; Data table (indexed access)
		db	 00h, 00h, 15h, 59h, 00h, 00h
		db	 00h, 00h, 05h, 54h, 00h, 00h
		db	 00h, 00h, 01h, 59h, 00h, 00h
		db	 00h, 00h, 00h, 59h, 00h, 00h
		db	 00h, 00h, 00h, 59h, 00h, 00h
		db	 00h, 00h, 05h, 64h, 00h, 00h
		db	 00h, 00h, 15h, 90h, 00h, 00h
		db	 00h, 00h, 2Ah,0A8h, 80h, 00h
		db	 00h, 00h, 2Ah,0AAh, 20h, 00h
		db	 06h, 17h, 0Fh, 00h, 05h, 55h
		db	 00h, 00h, 0Fh, 00h, 00h, 5Ah
		db	 50h, 00h, 0Fh, 00h, 55h, 55h
		db	 00h, 00h, 0Fh, 00h,0AAh, 3Eh
		db	 80h, 00h, 2Fh, 80h, 02h,0FAh
		db	 20h, 00h, 2Bh, 80h,0A0h,0AAh
		db	 80h, 00h, 2Ah, 00h,0AAh,0AAh
		db	 05h, 50h, 05h, 40h, 2Ah, 05h
		db	 55h, 58h, 01h, 55h, 44h, 95h
		db	 50h, 15h, 00h, 14h, 1Ah, 6Ah
		db	 50h, 2Ah, 00h, 01h, 69h, 6Ah
		db	 40h,0AAh, 00h, 05h,0A5h, 59h
		db	 40h, 0Ah, 00h, 05h,0A5h, 55h
		db	 00h, 08h, 00h, 01h,0AAh,0A8h
		db	 00h, 00h, 00h, 00h, 15h, 55h
		db	 00h, 00h, 00h, 01h, 40h, 55h
		db	 00h, 00h, 00h, 01h, 54h, 05h
		db	 00h, 00h, 00h, 05h, 40h, 05h
		db	 40h, 00h, 00h, 05h, 00h, 01h
		db	 50h, 00h,0A0h, 05h, 00h, 00h
		db	 55h, 40h,0AAh, 54h, 00h, 00h
		db	 05h,0A0h, 0Ah,0A4h, 00h, 00h
		db	 2Ah,0A0h, 00h,0A0h, 00h, 02h
		db	0AAh, 80h, 06h, 17h, 00h, 3Ch
		db	 05h, 55h, 00h, 00h, 00h,0F0h
		db	 00h, 5Ah, 50h, 00h, 03h,0C0h
		db	 55h, 55h, 00h, 00h, 2Fh, 80h
		db	0AAh, 3Eh, 80h, 00h, 2Eh, 80h
		db	 02h,0FAh, 20h, 00h, 2Ah, 00h
		db	0A0h,0AAh, 80h, 00h, 05h, 00h
		db	0AAh,0AAh, 00h, 00h, 05h, 40h
		db	 2Ah, 05h, 50h, 00h, 01h, 55h
		db	 44h, 95h, 55h, 00h, 00h, 14h
		db	 1Ah, 6Ah, 55h, 40h, 00h, 01h
		db	 69h, 6Ah, 41h, 50h, 00h, 05h
		db	0A5h, 59h, 40h, 60h, 00h, 05h
		db	0A5h, 55h, 00h, 50h, 00h, 01h
		db	0AAh,0A0h, 00h,0A8h, 00h, 00h
		db	 55h, 54h, 02h,0A8h, 00h, 00h
		db	 15h, 50h, 00h, 28h, 00h, 00h
		db	 65h, 40h, 00h, 20h, 00h, 00h
		db	 65h, 00h, 00h, 00h, 00h, 00h
		db	 65h, 00h, 00h, 00h, 00h, 00h
		db	 19h, 50h, 00h, 00h, 00h, 00h
		db	 06h, 54h, 00h, 00h, 00h, 02h
		db	 2Ah,0A8h, 00h, 00h, 00h, 08h
		db	0AAh,0A8h, 00h, 00h, 06h, 17h
		db	 00h, 00h, 00h, 55h, 50h, 00h
		db	 00h, 00h, 00h, 05h,0A5h, 00h
		db	0C0h, 00h, 05h, 55h, 50h, 00h
		db	0F0h, 00h, 0Ah,0A3h,0E8h, 00h
		db	 3Ch, 00h, 00h, 2Fh,0A2h, 00h
		db	 0Fh, 80h, 0Ah, 0Ah,0A8h, 00h
		db	 0Bh,0E0h, 0Ah,0AAh,0A0h, 00h
		db	 02h,0A5h, 02h,0A0h, 01h, 54h
		db	 00h, 95h, 54h, 49h, 55h, 56h
		db	 00h, 01h, 41h,0A6h,0A4h, 15h
		db	 00h, 00h, 16h, 96h,0A4h, 2Ah
		db	 00h, 00h, 5Ah, 55h, 94h,0AAh
		db	 00h, 00h, 5Ah, 55h, 50h, 0Ah
		db	 00h, 00h, 1Ah,0AAh, 00h, 08h
		db	 00h, 00h, 65h, 54h, 00h, 00h
		db	 00h, 00h, 15h, 50h, 00h, 00h
		db	 00h, 00h, 65h, 40h, 00h, 00h
		db	 00h, 00h, 65h, 00h, 00h, 00h
		db	 00h, 00h, 65h, 00h, 00h, 00h
		db	 00h, 00h, 19h, 50h, 00h, 00h
		db	 00h, 00h, 06h, 54h, 00h, 00h
		db	 00h, 02h, 2Ah,0A8h, 00h, 00h
		db	 00h, 08h,0AAh,0A8h, 00h, 00h
		db	 05h, 0Fh, 0Ah, 00h, 00h, 00h
		db	 00h, 0Fh,0A0h, 00h, 00h, 00h
		db	 2Ah,0FAh, 00h, 00h, 00h, 2Ah
		db	0AFh,0A0h, 00h, 00h, 89h,0AAh
		db	0F0h, 00h, 00h,0A0h,0AAh, 80h
		db	 00h, 00h, 0Ah, 06h, 8Ah, 80h
		db	 00h, 00h,0A0h, 2Ah, 80h, 00h
		db	 00h
		db	 0Ah, 0Ah
		db	32 dup (0)
		db	 05h, 0Fh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 80h, 00h, 00h, 00h
		db	 02h,0E0h, 00h, 00h, 00h, 0Ah
		db	0B8h, 00h, 00h, 00h, 2Ah,0AEh
		db	 00h, 00h, 00h, 89h,0ABh, 80h
		db	 00h, 00h, 22h,0AAh,0E0h, 00h
		db	 00h, 08h,0AAh,0B8h, 00h, 00h
		db	 02h, 26h,0A0h, 00h, 00h, 00h
		db	 8Ah, 88h, 00h, 00h, 00h, 2Ah
		db	 2Ah, 00h, 00h, 00h, 08h, 2Ah
		db	 00h, 00h, 00h, 00h
		db	8
		db	12 dup (0)
		db	 05h, 0Fh, 00h, 00h
		db	14 dup (0)
		db	0E0h, 00h, 00h, 00h, 0Ah,0E0h
		db	 00h, 00h, 00h, 8Ah,0B8h, 00h
		db	 00h, 00h, 89h,0B8h, 00h, 00h
		db	 00h, 22h,0AEh, 00h, 00h, 00h
		db	 22h,0AEh, 00h, 00h, 00h, 08h
		db	 6Bh, 80h, 00h, 00h, 08h,0ABh
		db	 80h, 00h, 00h, 02h, 28h, 00h
		db	 00h, 00h, 02h, 02h, 80h, 00h
		db	 00h, 00h, 0Ah, 80h, 00h, 00h
		db	 00h, 0Ah, 00h, 00h, 00h, 05h
		db	 0Fh, 00h, 00h, 00h, 00h,0A0h
		db	 00h, 00h, 00h, 0Ah,0F0h, 00h
		db	 00h, 00h,0AFh,0A8h, 00h, 00h
		db	 0Ah,0FAh,0A8h, 00h, 00h, 0Fh
		db	0AAh, 62h, 00h, 00h, 02h,0AAh
		db	 0Ah, 00h, 02h,0A2h, 90h,0A0h
		db	 00h, 02h,0A8h, 0Ah, 00h, 00h
		db	 00h,0A0h,0A0h, 00h
		db	30 dup (0)
		db	 05h, 0Fh, 00h
		db	7 dup (0)
		db	 02h, 00h, 00h, 00h, 00h, 0Bh
		db	 80h, 00h, 00h, 00h, 2Eh,0A0h
		db	 00h, 00h, 00h,0BAh,0A8h, 00h
		db	 00h, 02h,0EAh, 62h, 00h, 00h
		db	 0Bh,0AAh, 88h, 00h, 00h, 2Eh
		db	0AAh, 20h, 00h, 00h, 0Ah, 98h
		db	 80h, 00h, 00h, 22h,0A2h, 00h
		db	 00h, 00h,0A8h,0A8h, 00h, 00h
		db	 00h,0A8h, 20h, 00h, 00h, 00h
		db	20h
		db	12 dup (0)
		db	 05h, 0Fh, 00h
		db	17 dup (0)
		db	 0Bh, 00h, 00h, 00h, 00h, 0Bh
		db	0A0h, 00h, 00h, 00h, 2Eh,0A2h
		db	 00h, 00h, 00h, 2Eh, 62h, 00h
		db	 00h, 00h,0BAh, 88h, 00h, 00h
		db	 00h,0BAh, 88h, 00h, 00h, 02h
		db	0E9h, 20h, 00h, 00h, 02h,0EAh
		db	 20h, 00h, 00h, 00h, 28h, 80h
		db	 00h, 00h, 02h, 80h, 80h, 00h
		db	 00h, 02h,0A0h, 00h, 00h, 00h
		db	 00h,0A0h, 00h, 07h, 16h
		db	101 dup (0)
		db	 0Ch, 00h, 03h, 00h, 00h,0F0h
		db	 00h, 00h, 00h, 80h, 00h, 00h
		db	 00h,0F0h, 00h,0C0h,0F0h, 00h
		db	 30h, 00h, 00h, 30h, 0Fh, 00h
		db	 0Fh, 00h, 30h,0F0h, 80h, 00h
		db	 0Fh, 00h, 0Fh, 80h, 00h, 0Fh
		db	 00h, 00h,0C0h, 00h, 00h, 00h
		db	0BAh, 80h, 00h, 00h, 00h, 00h
		db	 0Fh,0AEh,0F8h, 00h, 00h, 07h
		db	 16h
		db	59 dup (0)
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	 00h,0FAh,0F0h, 00h, 00h, 00h
		db	 00h, 0Fh,0A2h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 8Fh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0F2h, 00h
		db	 00h, 00h, 00h, 0Ch, 00h, 88h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 22h, 00h, 30h, 00h, 00h, 00h
		db	 00h,0F8h,0C0h, 00h, 00h, 00h
		db	 00h,0F0h,0B2h, 00h, 00h, 00h
		db	 00h, 0Ch, 00h, 88h, 80h,0C0h
		db	 00h, 00h, 00h, 0Fh, 2Fh, 20h
		db	 00h, 00h, 00h, 00h, 88h,0AAh
		db	0F0h, 80h, 00h, 0Fh, 22h, 2Fh
		db	0FAh,0FFh, 0Fh, 00h,0FAh,0FAh
		db	0FAh,0AFh,0AFh,0FAh,0F0h, 07h
		db	 16h, 00h, 00h, 00h,0F0h, 00h
		db	 00h,0F0h, 03h, 0Fh, 00h, 00h
		db	 00h,0F0h, 00h, 30h, 08h,0AFh
		db	 0Fh, 00h, 00h, 00h, 00h,0A2h
		db	 2Ah, 2Ah,0A3h, 00h,0F0h, 0Fh
		db	 88h, 88h, 88h,0B0h, 0Fh, 00h
		db	 0Ah, 2Ah,0F2h, 32h, 08h,0A0h
		db	 0Fh,0E8h, 30h, 28h, 8Ah,0FAh
		db	0AFh, 00h, 00h, 00h, 2Eh, 2Fh
		db	 22h, 2Ah,0F0h, 00h,0F0h,0A8h
		db	 88h, 88h, 0Ah, 00h
data_B0AA	db	30h			; Data table (indexed access)
		db	 00h,0C2h, 22h, 22h, 00h, 0Ch
		db	 00h, 00h, 00h, 88h, 80h, 00h
		db	 00h, 00h,0C0h, 00h, 2Fh, 00h
		db	0C0h,0F0h, 00h, 00h, 00h, 88h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 2Eh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 88h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0A2h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 28h, 00h, 00h
		db	 00h, 00h, 00h, 02h, 88h, 00h
		db	 00h, 00h, 00h, 00h, 02h,0A8h
		db	 00h, 00h, 00h, 00h, 00h, 0Ah
		db	 82h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah,0A2h, 80h, 00h, 00h, 00h
		db	 00h,0A8h, 88h,0A0h, 00h, 00h
		db	 09h, 11h, 2Ch, 00h
		db	7 dup (0)
		db	0C2h, 00h, 00h, 00h, 00h, 0Ah
		db	 00h, 00h, 00h, 83h, 00h, 0Eh
		db	 0Fh,0FAh, 0Fh, 0Ah,0FFh, 0Bh
		db	 3Ah, 80h, 00h, 00h, 00h, 0Ah
		db	 00h, 00h, 00h, 0Ah, 28h, 00h
		db	 00h, 0Ah,0FFh,0FCh, 00h, 00h
		db	 00h,0A2h, 80h, 00h,0ABh,0D5h
		db	 7Fh,0C0h, 00h, 00h, 0Ah, 2Ah
		db	0AAh,0ABh, 55h, 57h,0F0h, 00h
		db	 00h, 00h,0A2h, 8Ah,0A9h, 40h
		db	 05h,0FCh, 00h, 00h, 00h, 0Ah
		db	 2Ah,0A9h, 3Ch, 01h, 7Fh, 00h
		db	 00h, 00h, 00h,0AAh,0AAh, 0Fh
		db	 00h, 7Fh, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh, 83h,0C0h, 7Fh, 00h
		db	 00h, 00h, 00h, 00h,0AAh,0AAh
		db	 01h, 7Ch, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0AAh,0AAh, 80h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 10h
		db	 40h, 01h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 11h, 55h, 54h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 10h
		db	 00h, 10h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 55h, 40h, 00h
		db	 09h, 11h
		db	38h
		db	8 dup (0)
		db	 83h, 00h, 00h, 00h, 00h, 0Ah
		db	 00h, 00h, 00h,0C2h, 00h, 0Ah
		db	0FFh, 0Ah,0FFh,0FAh, 0Fh,0FAh
		db	 2Eh, 80h, 00h, 00h, 00h, 0Ah
		db	 00h, 00h, 00h, 0Ah, 28h, 00h
		db	 00h, 0Ah,0FFh,0FCh, 00h, 00h
		db	 00h,0A2h, 80h, 00h,0ABh,0D5h
		db	 7Fh,0C0h, 00h, 00h, 0Ah, 2Ah
		db	0AAh,0ABh, 55h, 57h,0F0h, 00h
		db	 00h, 00h,0A2h, 8Ah,0A9h, 40h
		db	 05h,0FCh, 00h, 00h, 00h, 0Ah
		db	 2Ah,0A9h, 3Ch, 01h, 7Fh, 00h
		db	 00h, 00h, 00h,0AAh,0AAh, 0Fh
		db	 00h, 7Fh, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh, 83h,0C0h, 7Fh, 00h
		db	 00h, 00h, 00h, 00h,0AAh,0AAh
		db	 01h, 7Ch, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0AAh,0AAh, 80h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 10h
		db	 40h, 01h, 00h, 00h, 00h, 00h
		db	 00h, 55h, 11h, 55h, 54h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 10h
		db	 00h, 10h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 55h, 55h, 40h, 00h
		db	 09h, 11h, 00h, 00h, 00h, 00h
		db	3Ch
		db	8 dup (0)
		db	 28h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 0Ah,0F0h,0FFh, 0Fh,0A0h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	28h
		db	8 dup (0)
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0BFh,0F0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 1Bh
		db	0F7h,0F4h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 6Fh,0DDh,0FDh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 6Fh
		db	 77h,0FDh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 6Fh,0DFh,0FDh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 5Fh
		db	0FFh,0F5h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 27h,0FFh,0D8h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 0Ah
		db	0AAh,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 10h, 00h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 20h
		db	 00h, 08h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 10h, 00h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 54h
		db	 00h, 15h, 00h, 00h, 00h, 09h
		db	 11h, 00h
		db	7 dup (0)
		db	 38h, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 00h, 83h,0E0h,0FFh
		db	0A0h,0F0h,0AFh,0F0h,0B0h, 00h
		db	0C2h, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 02h,0ACh, 00h, 00h
		db	 3Fh,0FFh,0A0h, 00h, 00h, 28h
		db	0A0h, 00h, 03h,0FDh, 57h,0EAh
		db	 00h, 02h, 8Ah, 00h, 00h, 0Fh
		db	0D5h, 55h,0EAh,0AAh,0A8h,0A0h
		db	 00h, 00h, 3Fh, 50h, 01h, 6Ah
		db	0A2h, 8Ah, 00h, 00h, 00h,0FDh
		db	 40h, 3Ch, 6Ah,0A8h,0A0h, 00h
		db	 00h, 00h,0FDh, 00h,0F0h,0AAh
		db	0AAh, 00h, 00h, 00h, 00h,0FDh
		db	 03h,0C2h,0AAh,0A0h, 00h, 00h
		db	 00h, 00h, 3Dh, 40h,0AAh,0AAh
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0AAh,0AAh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 40h, 01h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 15h
		db	 55h, 44h, 55h, 00h, 00h, 00h
		db	 00h, 00h, 04h, 00h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 01h
		db	 55h, 55h, 55h, 50h, 00h, 00h
		db	 00h, 09h, 11h, 00h
		db	7 dup (0)
		db	 2Ch, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 00h,0C2h,0AFh,0F0h
		db	0AFh,0FFh,0A0h,0FFh,0A0h, 00h
		db	 83h, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 02h,0B8h, 00h, 00h
		db	 3Fh,0FFh,0A0h, 00h, 00h, 28h
		db	0A0h, 00h, 03h,0FDh, 57h,0EAh
		db	 00h, 02h, 8Ah, 00h, 00h, 0Fh
		db	0D5h, 55h,0EAh,0AAh,0A8h,0A0h
		db	 00h, 00h
data_B3B3	dw	503Fh			; Data table (indexed access)
		db	 01h, 6Ah,0A2h, 8Ah, 00h, 00h
		db	 00h,0FDh, 40h, 3Ch, 6Ah,0A8h
		db	0A0h, 00h, 00h, 00h,0FDh, 00h
		db	0F0h,0AAh,0AAh, 00h, 00h, 00h
		db	 00h,0FDh, 03h,0C2h,0AAh,0A0h
		db	 00h, 00h, 00h, 00h, 3Dh, 40h
		db	0AAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 02h,0AAh,0AAh,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 40h, 01h
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 15h, 55h, 44h, 55h, 00h
		db	 00h, 00h, 00h, 00h, 04h, 00h
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 01h, 55h, 55h, 55h, 50h
		db	 00h, 00h, 00h, 06h, 15h, 00h
		db	36 dup (0)
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	 3Dh, 70h,0FCh, 00h, 00h, 00h
		db	 35h, 57h,0D7h,0C0h, 00h, 00h
		db	 0Dh, 97h, 55h, 70h, 00h, 00h
		db	 05h, 55h, 59h, 70h, 00h, 00h
		db	 35h, 65h, 95h,0C0h, 00h, 00h
		db	0D6h, 59h, 55h,0C0h, 00h, 00h
		db	0D5h, 56h, 65h, 00h, 00h, 00h
		db	0F7h,0D5h, 57h, 00h, 00h, 00h
		db	 3Ch, 33h, 5Fh, 00h, 00h, 00h
		db	 00h, 00h,0FCh
		db	26 dup (0)
		db	 06h, 15h, 00h, 00h
		db	17 dup (0)
		db	0FCh, 00h,0FFh, 00h, 00h, 03h
		db	0D7h, 03h,0D5h,0C0h, 00h, 03h
		db	 55h,0F5h, 55h, 40h, 00h, 03h
		db	 55h, 55h, 55h, 7Ch, 00h, 00h
		db	0D5h, 55h,0A5h, 57h, 00h, 00h
		db	0D5h,0A5h, 59h, 57h, 00h, 00h
		db	 1Ah, 56h, 69h, 5Fh, 00h, 00h
		db	 29h, 65h, 65h,0FCh, 00h, 03h
		db	 65h, 95h, 65h,0C0h, 00h, 0Dh
		db	 59h, 59h, 95h,0C0h, 00h, 0Dh
		db	 56h, 55h, 55h, 50h, 00h, 0Fh
		db	 55h, 59h,0A5h, 5Ch, 00h, 03h
		db	0D5h,0D6h, 95h, 5Fh, 00h, 00h
		db	 35h, 55h, 57h,0D7h, 00h, 00h
		db	 00h,0F5h,0C0h, 3Ch, 00h, 00h
		db	 00h
		db	3Fh
		db	15 dup (0)
		db	 06h, 15h, 20h, 00h, 00h, 20h
		db	 00h, 28h, 08h, 08h, 00h,0A8h
		db	 02h,0A0h, 0Ah, 00h,0FCh,0A8h
		db	 0Ah, 80h, 02h,0A3h,0DFh,0C8h
		db	0FAh, 00h, 02h,0A3h, 55h, 77h
		db	 7Ch, 00h, 00h, 2Fh, 59h, 55h
		db	 5Ch, 00h, 02h, 0Dh, 55h, 59h
		db	 5Ch, 00h, 28h, 15h, 5Ah, 55h
		db	 70h, 00h, 00h,0D9h, 55h, 55h
		db	 42h, 80h, 03h, 55h, 66h, 65h
		db	 7Ah,0A8h, 03h, 56h, 59h, 95h
		db	 7Eh, 00h, 03h,0D5h, 55h, 59h
		db	 5Ch, 00h, 00h,0FFh,0D5h, 95h
		db	0F0h, 00h, 20h, 2Fh, 25h, 56h
		db	 00h, 20h, 00h,0AAh, 0Dh, 5Eh
		db	 80h, 20h, 00h,0A8h, 0Dh,0FAh
		db	0A0h, 00h, 02h, 80h, 0Bh,0C2h
		db	0A8h, 00h, 0Ah, 00h, 28h, 00h
		db	 0Ah, 00h, 20h, 00h, 28h, 28h
		db	 00h, 80h, 00h, 00h, 20h, 00h
		db	8 dup (0)
		db	 06h, 18h, 00h, 05h,0F0h, 00h
		db	 00h, 00h, 00h, 10h, 7Fh,0C0h
		db	 00h, 00h, 00h, 00h, 1Fh,0FFh
		db	 00h, 00h, 00h, 00h, 1Fh,0CAh
		db	 00h, 00h, 00h, 00h, 07h,0CAh
		db	0C0h, 00h, 00h, 00h, 07h,0FFh
		db	0FFh, 00h, 00h, 00h, 01h, 0Fh
		db	0FCh, 00h, 00h, 00h, 01h,0F0h
		db	0F0h, 00h, 00h, 00h, 00h, 7Fh
		db	 00h, 00h, 00h, 00h, 00h, 70h
		db	 00h, 00h, 00h, 00h, 00h, 7Fh
		db	 02h,0A0h, 00h, 00h, 00h, 7Fh
		db	0CFh,0E8h, 00h, 00h, 00h, 7Fh
		db	0FFh,0FAh, 02h,0A8h, 00h, 1Fh
		db	0FFh,0F8h, 09h, 6Ah, 01h, 05h
		db	0FFh, 60h, 09h,0A8h, 07h,0F0h
		db	 55h, 00h, 0Ah,0A2h, 07h,0AFh
		db	 00h, 00h, 02h, 88h, 07h,0FAh
		db	 00h, 00h, 08h, 00h, 1Fh,0FEh
		db	 00h, 00h, 20h, 00h, 1Fh,0FEh
		db	 00h, 00h, 20h, 00h, 7Fh,0FEh
		db	 00h, 00h, 0Ah, 01h,0FFh,0FEh
		db	 00h, 00h, 00h, 17h,0FFh,0E8h
		db	 00h, 00h, 05h, 7Fh,0EAh, 80h
		db	 00h, 00h, 06h, 18h, 01h, 5Fh
		db	 00h, 00h, 00h, 00h, 00h, 07h
		db	0FCh, 00h, 00h, 00h, 00h, 01h
		db	0FFh,0F0h, 00h, 00h, 00h, 01h
		db	0FCh,0A0h, 00h, 00h, 00h, 00h
		db	 7Ch,0ACh, 00h, 00h, 00h, 00h
		db	 7Fh,0FFh,0F0h, 00h, 00h, 00h
		db	 10h,0FFh,0C0h, 00h, 00h, 00h
		db	 1Fh, 0Fh, 00h, 00h, 00h, 00h
		db	 07h,0F0h, 00h, 00h, 00h, 00h
		db	 07h, 00h, 2Ah, 00h, 00h, 00h
		db	 07h,0FCh,0FEh, 80h, 00h, 00h
		db	 07h,0FFh,0FFh,0A0h, 2Ah, 80h
		db	 01h,0FFh,0FFh, 80h, 96h,0A0h
		db	 00h, 5Fh,0F6h, 00h, 9Ah, 80h
		db	 01h, 05h, 50h, 00h,0AAh, 20h
		db	 07h,0F0h, 00h, 00h, 28h, 80h
		db	 07h,0AFh, 00h, 00h, 00h, 20h
		db	 07h,0FAh, 00h, 00h, 00h, 80h
		db	 1Fh,0FEh, 00h, 00h, 0Ah, 00h
		db	 7Fh,0FEh, 00h, 00h, 50h, 05h
		db	0FFh,0FEh, 00h, 00h, 05h, 5Fh
		db	0FFh,0F8h, 00h, 00h, 00h,0FFh
		db	0F5h,0A0h, 00h, 00h, 00h, 00h
		db	0AAh, 00h, 00h, 00h, 06h, 18h
		db	 00h, 00h, 00h, 0Fh, 50h, 00h
		db	 00h, 00h, 03h,0FDh, 04h, 00h
		db	 00h, 00h,0FFh,0F4h, 00h, 00h
		db	 00h, 00h,0A3h,0F4h, 00h, 00h
		db	 00h, 03h,0A3h,0D0h, 00h, 00h
		db	 00h,0FFh,0FFh,0D0h, 00h, 00h
		db	 00h, 3Fh,0F0h, 40h, 00h, 00h
		db	 00h, 0Fh, 0Fh, 40h, 00h, 00h
		db	 00h, 00h,0FDh, 00h, 00h, 00h
		db	 00h, 00h, 0Dh, 00h, 00h, 00h
		db	 0Ah, 80h,0FDh, 00h, 00h, 00h
		db	 2Bh,0F3h,0FDh, 00h, 00h, 00h
		db	0AFh,0FFh,0FDh, 00h, 00h, 00h
		db	 2Fh,0FFh,0F4h, 00h, 2Ah, 80h
		db	 09h,0FFh, 50h, 40h,0A9h, 60h
		db	 00h, 55h, 0Fh,0D0h, 2Ah, 60h
		db	 00h, 00h,0FAh,0D0h, 8Ah,0A0h
		db	 00h, 00h,0AFh,0D0h, 22h, 80h
		db	 00h, 00h,0BFh,0F4h, 00h, 20h
		db	 00h, 00h,0BFh,0F4h, 00h, 08h
		db	 00h, 00h,0BFh,0FDh, 00h, 08h
		db	 00h, 00h,0BFh,0FFh, 40h,0A0h
		db	 00h, 00h, 2Bh,0FFh,0D4h, 00h
		db	 00h, 00h, 02h,0ABh,0FDh, 50h
		db	 06h, 18h, 00h, 00h, 00h, 00h
		db	0F5h, 40h, 00h, 00h, 00h, 3Fh
		db	0D0h, 00h, 00h, 00h, 0Fh,0FFh
		db	 40h, 00h, 00h, 00h, 0Ah, 3Fh
		db	 40h, 00h, 00h, 00h, 3Ah, 3Dh
		db	 00h, 00h, 00h, 0Fh,0FFh,0FDh
		db	 00h, 00h, 00h, 03h,0FFh, 04h
		db	 00h, 00h, 00h, 00h,0F0h,0F4h
		db	 00h, 00h, 00h, 00h, 0Fh,0D0h
		db	 00h, 00h, 00h,0A8h, 00h,0D0h
		db	 00h, 00h, 02h,0BFh, 3Fh,0D0h
		db	 00h, 00h, 0Ah,0FFh,0FFh,0D0h
		db	 00h, 00h, 02h,0FFh,0FFh, 40h
		db	 02h,0A8h, 00h, 9Fh,0F5h, 00h
		db	 0Ah, 96h, 00h, 05h, 50h, 40h
		db	 02h,0A6h, 00h, 00h, 0Fh,0D0h
		db	 08h,0AAh, 00h, 00h,0FAh,0D0h
		db	 02h, 28h, 00h, 00h,0AFh,0D0h
		db	 08h, 00h, 00h, 00h,0BFh,0F4h
		db	 02h, 00h, 00h, 00h,0BFh,0FDh
		db	 00h,0A0h, 00h, 00h,0BFh,0FFh
		db	 50h, 05h, 00h, 00h, 2Fh,0FFh
		db	0F5h, 50h, 00h, 00h, 0Ah, 5Fh
		db	0FFh, 00h, 00h, 00h, 00h,0AAh
		db	 00h, 00h, 05h, 0Bh, 00h, 00h
		db	 00h, 02h,0A0h, 00h, 00h, 00h
		db	 0Ah,0A8h, 00h, 00h, 00h, 0Ah
		db	 0Ah, 00h, 00h, 00h, 0Ah,0A0h
		db	 00h, 00h, 00h, 00h,0A8h, 00h
		db	 00h, 00h, 00h, 2Ah, 00h, 02h
		db	0A0h, 00h, 0Ah, 00h, 0Ah,0AAh
		db	 00h, 0Ah, 00h, 0Ah, 0Ah, 80h
		db	0AAh,0A0h,0A8h, 02h,0AAh,0A8h
		db	 0Ah, 80h, 00h,0AAh, 80h, 05h
		db	 0Bh, 00h, 00h, 00h, 02h,0A0h
		db	 00h, 00h, 00h, 0Ah,0A8h, 00h
		db	 00h, 00h, 0Ah, 0Ah, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 00h
		db	 00h,0A8h, 00h, 00h, 2Ah, 80h
		db	 2Ah, 0Ah, 00h,0AAh,0A0h, 0Ah
		db	 00h,0A0h,0A0h,0A0h, 0Ah, 00h
		db	0A0h,0A0h,0A8h, 2Ah, 00h, 2Ah
		db	 80h, 2Ah,0A8h, 00h, 0Ah, 00h
		db	 0Ah, 80h, 05h, 0Bh, 00h, 00h
		db	 00h, 02h,0A0h, 00h, 00h, 00h
		db	 0Ah,0A8h, 00h, 00h, 00h, 0Ah
		db	 0Ah, 00h, 00h, 28h, 0Ah,0A0h
		db	 00h, 00h,0AAh, 82h,0A8h, 08h
		db	 00h,0A2h,0A0h,0A0h, 02h, 80h
		db	0A0h,0A0h,0A0h, 00h,0A0h,0A0h
		db	0A0h,0A0h, 00h,0A0h,0A0h,0A2h
		db	0A0h, 00h, 2Ah, 80h, 2Ah, 80h
		db	 00h, 0Ah, 00h, 0Ah, 00h, 05h
		db	 0Bh, 0Ah, 80h, 00h, 00h, 00h
		db	 2Ah,0A0h, 00h, 00h, 00h,0A0h
		db	0A0h, 00h, 00h, 00h, 0Ah,0A0h
		db	 00h, 00h, 00h, 2Ah, 00h, 00h
		db	 00h, 00h,0A8h, 00h, 00h, 00h
		db	 00h,0A0h, 00h, 0Ah, 80h, 00h
		db	0A0h, 00h,0AAh,0A0h, 00h,0AAh
		db	 02h,0A0h,0A0h, 00h, 2Ah,0AAh
		db	 80h, 2Ah, 0Ah, 02h,0AAh, 00h
		db	 02h,0A0h, 05h, 0Bh, 0Ah, 80h
		db	 00h, 00h, 00h, 2Ah,0A0h, 00h
		db	 00h, 00h,0A0h,0A0h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 00h
		db	 2Ah, 00h, 00h, 00h, 00h,0A8h
		db	 02h,0A8h, 00h, 00h,0A0h, 0Ah
		db	0AAh, 00h,0A0h,0A0h, 0Ah, 0Ah
		db	 0Ah, 00h,0A8h, 2Ah, 0Ah, 0Ah
		db	 00h, 2Ah,0A8h, 02h,0A8h, 00h
		db	 02h,0A0h, 00h,0A0h, 00h, 05h
		db	 0Bh, 0Ah, 80h, 00h, 00h, 00h
		db	 2Ah,0A0h, 00h, 00h, 00h,0A0h
		db	0A0h, 00h, 00h
data_B901	db	0			; Data table (indexed access)
		db	 0Ah,0A0h, 28h, 00h, 00h, 2Ah
		db	 82h,0AAh, 00h, 00h, 0Ah, 0Ah
		db	 8Ah, 00h, 20h, 0Ah, 0Ah, 0Ah
		db	 02h, 80h, 0Ah, 0Ah, 0Ah, 0Ah
		db	 00h, 0Ah, 8Ah, 0Ah, 0Ah, 00h
		db	 02h,0A8h, 02h,0A8h, 00h, 00h
		db	0A0h, 00h,0A0h, 00h, 12h, 0Ch
		db	0AAh
		db	9 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0ABh,0FFh,0ABh,0FFh
		db	0ABh,0ABh,0ABh,0FFh,0ABh,0FFh
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 20h, 00h,0AFh,0FFh,0EFh,0FFh
		db	0EFh,0EFh,0EFh,0FFh,0EFh,0FFh
		db	0E8h, 02h,0A0h, 7Fh, 02h,0AFh
		db	0FFh, 80h,0AFh,0ABh,0EFh,0ABh
		db	0EFh,0FFh,0EFh,0ABh,0EFh,0ABh
		db	0E8h, 08h, 08h,0C1h, 88h, 00h
		db	 30h, 00h,0AFh,0ABh,0EFh,0FFh
		db	0EFh,0FFh,0EFh,0FFh,0AFh,0ABh
		db	0E8h, 08h, 00h,0C1h, 88h, 00h
		db	 30h, 00h,0AFh,0FFh,0AFh,0FFh
		db	0EFh,0BBh,0EFh,0ABh,0EFh,0ABh
		db	0E8h, 02h, 83h, 01h, 8Ah,0A0h
		db	0C0h, 00h,0AFh,0BEh,0AFh,0ABh
		db	0EFh,0ABh,0EFh,0ABh,0EFh,0ABh
		db	0E8h, 00h, 23h, 06h, 08h, 00h
		db	0C0h, 00h,0AFh,0BEh,0AFh,0ABh
		db	0EFh,0ABh,0EFh,0FFh,0EFh,0FFh
		db	0E8h, 20h, 23h, 06h, 20h, 03h
		db	 00h, 00h,0ABh,0AFh,0ABh,0ABh
		db	0ABh,0ABh,0ABh,0FFh,0ABh,0FFh
		db	0A8h, 0Ah, 81h,0FCh, 20h, 03h
		db	 00h, 00h,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 07h, 10h, 00h
		db	17 dup (0)
		db	0AAh,0A0h, 00h, 00h, 00h, 10h
		db	0A2h,0CAh, 88h, 00h, 00h, 00h
		db	 4Ah, 22h,0FAh, 20h, 00h, 00h
		db	 01h, 22h, 8Ah,0A8h, 80h, 00h
		db	 00h, 01h, 88h, 8Ah, 82h, 00h
		db	 00h, 00h, 04h, 82h, 22h,0A8h
		db	 80h, 00h, 28h, 02h, 2Ah,0A2h
		db	0AAh,0A0h, 00h,0AAh, 08h, 9Ah
		db	 98h, 2Ah, 00h, 00h, 02h,0AAh
		db	0A9h,0AAh, 80h, 00h, 00h, 02h
		db	 82h, 6Ah, 68h, 00h, 00h, 00h
		db	 0Ah, 80h, 00h, 40h, 00h, 00h
		db	 00h, 2Ah, 00h, 01h, 00h, 00h
		db	 00h, 00h
		db	20h
		db	13 dup (0)
		db	 07h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 20h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 2Ah, 00h
		db	 00h, 44h, 00h, 00h, 00h, 0Ah
		db	 80h, 05h, 11h, 10h, 00h, 00h
		db	 02h, 82h, 88h, 8Ah, 50h, 00h
		db	 00h, 02h,0AAh, 22h, 22h, 08h
		db	 00h, 00h,0AAh, 0Ah, 68h, 88h
		db	0AAh, 00h, 00h, 28h, 02h,0A6h
		db	 22h,0BEh,0A0h, 00h, 00h, 00h
		db	0AAh, 62h,0B2h,0A8h, 00h, 00h
		db	 00h, 26h, 8Ah, 2Ah,0AAh, 00h
		db	 00h, 00h, 06h, 8Ah, 80h, 02h
		db	 80h, 00h, 00h, 12h, 8Ah, 82h
		db	 88h, 00h, 00h, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 02h,0AAh
		db	16 dup (0)
		db	 07h, 10h, 00h
		db	14 dup (0)
		db	 0Ah,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 22h,0A3h, 8Ah, 04h, 00h
		db	 00h, 00h, 08h,0AFh, 88h,0A1h
		db	 00h, 00h, 00h, 02h, 2Ah,0A2h
		db	 88h, 40h, 00h, 00h, 00h, 82h
		db	0A2h, 22h, 40h, 00h, 00h, 02h
		db	 2Ah, 88h, 82h, 10h, 00h, 00h
		db	 0Ah,0AAh, 8Ah,0A8h, 80h, 28h
		db	 00h, 00h,0A8h, 26h,0A6h, 20h
		db	0AAh, 00h, 00h, 02h,0AAh, 6Ah
		db	0AAh, 80h, 00h, 00h, 00h, 29h
		db	0A9h, 82h, 80h, 00h, 00h, 00h
		db	 01h, 00h, 02h,0A0h, 00h, 00h
		db	 00h, 00h, 40h, 00h,0A8h, 00h
		db	 00h, 00h, 00h, 00h, 00h
		db	8
		db	7 dup (0)
		db	 07h, 10h, 00h
		db	12 dup (0)
		db	 08h, 00h, 00h, 00h, 11h, 00h
		db	 00h,0A8h, 00h, 00h, 04h, 44h
		db	 50h, 02h,0A0h, 00h, 00h, 05h
		db	0A2h, 22h, 82h, 80h, 00h, 00h
		db	 20h, 88h, 88h,0AAh, 80h, 00h
		db	 00h,0AAh, 22h, 29h,0A0h,0AAh
		db	 00h, 0Ah,0BEh, 88h, 9Ah, 80h
		db	 28h, 00h, 2Ah, 8Eh, 89h,0AAh
		db	 00h, 00h, 00h,0AAh,0A8h,0A2h
		db	 98h, 00h, 00h, 02h, 80h, 02h
		db	0A2h, 90h, 00h, 00h, 00h, 22h
		db	 82h,0A2h, 84h, 00h, 00h, 00h
		db	 00h, 2Ah,0A8h, 00h, 00h, 00h
		db	 00h, 00h,0AAh, 80h, 00h
		db	16 dup (0)
		db	 04h, 16h, 00h, 01h, 15h, 00h
		db	 00h, 04h, 55h, 50h, 00h, 05h
		db	 55h, 54h, 00h, 0Ah, 2Bh, 80h
		db	 00h, 20h,0ACh,0A8h, 03h,0CAh
		db	0AAh, 00h, 3Eh,0B0h,0A0h,0A0h
		db	0F8h,0A2h, 2Ah,0A8h,0FAh,0A0h
		db	 0Ah,0A0h,0FEh,0AAh, 00h, 00h
		db	0FFh,0AAh,0AAh,0A0h,0FFh,0FAh
		db	0ABh, 0Ah, 3Eh,0A5h, 00h,0F8h
		db	0C1h, 54h, 40h,0F0h, 00h, 55h
		db	 10h, 00h, 00h, 05h, 44h, 54h
		db	 00h, 05h, 44h, 14h, 00h, 05h
		db	 10h, 54h, 00h, 54h, 40h, 00h
		db	 02h, 92h, 40h,0F0h, 0Ah, 82h
		db	 00h, 00h, 2Ah,0A8h,0A0h,0F0h
		db	 04h, 16h, 00h, 01h, 15h, 00h
		db	 00h, 04h, 55h, 50h, 00h, 05h
		db	 55h, 54h, 00h, 20h,0ACh,0A8h
		db	 03h,0CAh,0AAh, 00h, 3Eh,0B0h
		db	0A0h,0A0h,0F8h,0A2h, 2Ah,0A8h
		db	0FAh,0A0h, 0Ah,0A0h,0FEh,0AAh
		db	 00h, 00h,0FFh,0AAh,0AAh,0A0h
		db	0FFh,0FAh,0ABh, 0Ah, 3Eh,0A5h
		db	 00h,0F8h, 31h, 54h, 40h,0F0h
		db	 00h, 55h, 10h,0F0h, 00h, 05h
		db	 44h, 00h, 00h, 05h, 44h,0F0h
		db	 00h, 05h, 44h, 00h, 00h, 05h
		db	 10h, 54h, 00h, 54h, 40h, 14h
		db	 02h, 92h, 40h, 54h, 0Ah, 82h
		db	 00h, 00h, 2Ah,0A8h,0A0h,0F0h
		db	 04h, 16h, 00h, 54h, 40h, 00h
data_BC86	db	5
		db	 55h, 10h, 00h, 15h, 55h, 50h
		db	 00h, 02h,0E8h,0A0h, 00h, 2Ah
		db	 3Ah, 08h, 00h, 00h,0AAh,0A3h
		db	0C0h, 0Ah, 0Ah, 0Eh,0BCh, 2Ah
		db	0A8h, 8Ah
		db	2Fh
data_BCA2	db	0Ah			; Data table (indexed access)
		db	0A0h, 0Ah,0AFh, 00h, 00h,0AAh
		db	0BFh, 0Ah,0AAh,0AAh,0FFh,0A0h
		db	0EAh,0AFh,0FFh, 2Fh, 00h, 5Ah
		db	0BCh, 0Fh, 01h, 15h, 43h, 00h
		db	 04h, 55h, 00h, 15h, 11h, 50h
		db	 00h, 14h, 11h, 50h, 00h, 15h
		db	 04h, 50h, 00h, 00h, 01h, 15h
		db	 00h, 0Fh, 01h, 86h, 80h, 00h
		db	 00h, 82h,0A0h, 0Fh, 0Ah, 2Ah
		db	0A8h, 04h, 16h, 00h, 54h, 40h
		db	 00h, 05h, 55h, 10h, 00h, 15h
		db	 55h, 50h, 00h, 2Ah, 3Ah, 08h
		db	 00h, 00h,0AAh,0A3h,0C0h, 0Ah
		db	 0Ah, 0Eh,0BCh, 2Ah,0A8h, 8Ah
		db	 2Fh, 0Ah,0A0h, 0Ah,0AFh, 00h
		db	 00h,0AAh,0BFh, 0Ah,0AAh,0AAh
		db	0FFh,0A0h,0EAh,0AFh,0FFh, 2Fh
		db	 00h, 5Ah,0BCh, 0Fh, 01h, 15h
		db	 4Ch, 0Fh, 04h, 55h, 00h, 00h
		db	 11h, 50h, 00h, 0Fh, 11h, 50h
		db	 00h, 00h, 11h, 50h, 00h, 15h
		db	 04h, 50h, 00h, 14h, 01h, 15h
		db	 00h, 15h, 01h, 86h, 80h, 00h
		db	 00h, 82h,0A0h, 0Fh, 0Ah, 2Ah
		db	0A8h, 05h, 0Ch, 10h, 00h, 00h
		db	 00h, 00h, 04h, 00h, 28h, 00h
		db	 00h, 04h, 00h,0A8h, 00h, 00h
		db	 10h, 00h,0A2h, 00h, 00h, 40h
		db	 00h,0A2h, 00h,0A0h, 42h,0A0h
		db	 28h,0C2h, 20h, 4Ah,0A8h, 8Ah
		db	0AAh, 80h, 1Ah,0AAh,0AAh,0A8h
		db	0C0h, 0Ah,0AAh,0AAh, 08h, 00h
		db	 02h,0AAh, 08h, 02h, 00h, 02h
		db	 0Ah, 82h, 80h, 00h, 08h, 00h
		db	 00h, 00h, 00h, 05h, 0Ch, 10h
		db	 00h, 00h, 00h, 00h, 44h, 00h
		db	 00h, 00h, 00h, 04h, 00h, 28h
		db	 00h, 00h, 10h, 00h,0A8h, 00h
		db	 00h, 42h,0A0h,0A2h, 00h, 00h
		db	 4Ah,0A8h,0A2h, 00h,0A0h, 1Ah
		db	0A8h, 28h,0C2h, 20h, 0Ah,0AAh
		db	 82h,0AAh, 80h, 02h,0AAh,0AAh
		db	0A8h,0C0h, 02h, 0Ah, 82h, 88h
		db	 00h, 00h, 82h,0A8h, 02h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 05h
		db	 0Ch, 00h, 00h, 00h, 00h, 04h
		db	 00h, 00h, 28h, 00h, 10h, 00h
		db	 00h, 2Ah, 00h, 10h, 00h, 00h
		db	 8Ah, 00h, 04h, 0Ah, 00h, 8Ah
		db	 00h, 01h, 08h, 83h, 28h, 0Ah
		db	 81h, 02h,0AAh,0A2h, 2Ah,0A1h
		db	 03h, 2Ah,0AAh,0AAh,0A4h, 00h
		db	 20h,0AAh,0AAh,0A0h, 00h, 80h
		db	 20h,0AAh, 80h, 00h, 02h, 82h
		db	0A0h, 80h, 00h, 00h, 00h, 00h
		db	 20h, 05h, 0Ch, 00h, 00h, 00h
		db	 00h, 04h, 00h, 00h, 00h, 00h
		db	 11h, 00h, 00h, 28h, 00h, 10h
		db	 00h, 00h, 2Ah, 00h, 04h, 00h
		db	 00h, 8Ah, 0Ah, 81h, 0Ah, 00h
		db	 8Ah, 2Ah,0A1h, 08h, 83h, 28h
		db	 2Ah,0A4h, 02h,0AAh, 82h,0AAh
		db	0A0h, 03h, 2Ah,0AAh,0AAh, 80h
		db	 00h, 22h, 82h,0A0h, 80h, 00h
		db	 80h, 2Ah, 82h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 07h, 17h, 00h
		db	0FCh, 3Fh,0C0h, 00h, 00h, 00h
		db	 03h,0FEh,0FFh,0A0h, 00h, 00h
		db	 00h, 00h,0F3h,0FEh,0FCh, 00h
		db	 00h, 00h, 00h, 03h,0F2h,0F2h
		db	0A0h, 00h, 00h, 00h, 00h,0CAh
		db	0AAh, 80h, 00h, 00h, 00h, 01h
		db	 22h,0A2h, 00h, 00h, 00h, 00h
		db	 05h, 4Ah,0A8h, 00h, 00h, 00h
		db	 00h, 15h, 70h,0F0h, 00h, 00h
		db	 00h, 00h, 57h,0AFh,0FCh, 00h
		db	 00h, 00h, 00h, 56h,0ABh,0FFh
		db	 00h, 00h, 00h, 00h,0FEh,0AFh
		db	0FFh, 00h, 00h, 00h, 00h,0FFh
		db	0EFh,0CFh, 00h, 00h, 00h, 00h
		db	0FFh,0ECh, 3Fh, 00h, 00h, 00h
		db	 00h,0FFh, 8Ah,0FCh, 00h, 00h
		db	 00h, 00h, 7Fh,0AAh, 0Dh, 00h
		db	 00h, 00h, 00h, 57h,0ABh,0D5h
		db	 00h, 00h, 00h, 00h, 15h,0EDh
		db	 54h, 00h, 00h, 00h, 00h, 01h
		db	 5Dh, 40h, 00h, 00h, 00h, 00h
		db	 01h, 56h, 80h, 00h, 00h, 00h
		db	 00h, 02h,0A9h, 40h, 00h, 00h
		db	 00h, 00h, 01h, 55h, 40h, 00h
		db	 00h, 00h, 00h, 09h, 56h, 8Ah
		db	 80h, 00h, 00h, 00h, 0Bh,0FEh
		db	 8Ah, 80h, 00h, 00h, 07h, 17h
		db	 00h,0FCh, 3Fh,0C0h, 00h, 00h
		db	 00h, 03h,0FEh,0FFh,0A0h, 00h
		db	 00h, 00h, 00h,0F3h,0FEh,0FCh
		db	 00h, 00h, 00h, 00h, 03h,0F2h
		db	0F2h,0A0h, 00h, 00h, 00h, 00h
		db	0CAh,0AAh, 80h, 00h, 00h, 00h
		db	 01h, 22h,0A2h, 00h, 00h, 00h
		db	 00h, 05h, 4Ah,0A8h, 00h, 00h
		db	 00h, 00h, 15h, 70h,0F0h, 00h
		db	 00h, 00h, 00h, 58h,0BFh,0FFh
		db	 00h, 00h, 00h, 00h, 52h,0AFh
		db	0FFh,0C0h, 00h, 00h, 00h,0FAh
		db	0AFh,0CFh,0C0h, 00h, 00h, 00h
		db	0FFh,0AFh,0CFh,0C0h, 00h, 00h
		db	 00h,0CFh, 3Ah, 3Fh, 00h, 00h
		db	 00h, 00h,0F0h,0FAh,0ACh, 00h
		db	 00h, 00h, 00h, 7Fh,0FAh,0A1h
		db	 00h, 00h, 00h, 00h, 57h,0FFh
		db	0A9h, 00h, 00h, 00h, 00h, 15h
		db	 55h, 5Ah, 80h, 00h, 00h, 00h
		db	 01h, 55h, 40h,0A5h, 00h, 00h
		db	 00h, 02h, 82h, 80h, 55h, 90h
		db	 00h, 00h, 01h, 41h, 40h, 06h
		db	 55h, 70h, 00h, 01h, 41h, 40h
		db	 00h, 55h,0C0h, 00h, 0Ah,0AAh
		db	 8Ah, 80h, 0Fh, 00h, 00h, 0Ah
		db	0AAh, 8Ah, 80h, 00h, 00h, 07h
		db	 17h, 00h,0FCh, 3Fh,0C0h, 00h
		db	 00h, 00h, 03h,0FEh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h,0F3h,0FEh
		db	0FCh, 00h, 00h, 00h, 00h, 03h
		db	0F2h,0F2h,0A0h, 00h, 00h, 00h
		db	 00h,0CAh,0AAh, 80h, 00h, 00h
		db	 00h, 00h, 22h,0A2h, 00h, 00h
		db	 00h, 00h,0A5h, 0Ah,0A8h, 00h
		db	 00h, 00h, 00h,0A2h,0F0h,0F0h
		db	 00h, 00h, 00h, 00h, 4Ah,0AFh
		db	0FFh, 00h, 00h, 00h, 00h, 5Ah
		db	0AFh,0FFh,0C0h, 00h, 00h, 00h
		db	 5Fh, 2Ah,0FCh,0F0h, 00h, 00h
		db	 00h,0FFh, 3Eh,0A3h,0F0h, 00h
		db	 00h, 00h,0F0h,0FFh,0EAh,0B0h
		db	 00h, 00h, 00h,0FFh,0FFh,0FAh
		db	0A0h, 00h, 00h, 00h, 7Fh,0FFh
		db	0FEh,0AAh, 50h, 00h, 00h, 57h
		db	0FFh,0F5h, 05h, 59h, 57h, 00h
		db	 15h, 55h, 54h, 00h, 65h, 5Ch
		db	 00h, 01h, 55h, 40h, 00h, 05h
		db	0F0h, 00h, 02h, 82h, 80h, 00h
		db	 00h, 00h, 00h, 01h, 41h, 40h
		db	 00h, 00h, 00h, 00h, 01h
data_C002	dw	4041h
		db	 00h, 00h, 00h, 00h, 0Ah,0AAh
		db	 8Ah, 80h, 00h, 00h, 00h, 0Ah
		db	0AAh, 8Ah, 80h, 00h, 00h, 07h
		db	 17h, 00h, 00h, 00h, 03h,0FCh
		db	 3Fh, 00h, 00h, 00h, 00h, 0Ah
		db	0FFh,0BFh,0C0h, 00h, 00h, 00h
		db	 3Fh,0BFh,0CFh, 00h, 00h, 00h
		db	 0Ah, 8Fh, 8Fh,0C0h, 00h, 00h
		db	 00h, 02h,0AAh,0A3h, 00h, 00h
		db	 00h, 00h, 00h, 8Ah, 88h, 40h
		db	 00h, 00h, 00h, 00h, 2Ah,0A1h
		db	 50h, 00h, 00h, 00h, 00h, 0Fh
		db	 0Dh, 54h, 00h, 00h, 00h, 00h
		db	 3Fh,0FAh,0D5h, 00h, 00h, 00h
		db	 00h,0FFh,0EAh, 95h, 00h, 00h
		db	 00h, 00h,0FFh,0FAh,0BFh, 00h
		db	 00h, 00h, 00h,0F3h,0FBh,0FFh
		db	 00h, 00h, 00h, 00h,0FCh, 3Bh
		db	0FFh, 00h, 00h, 00h, 00h, 3Fh
		db	0A2h,0FFh, 00h, 00h, 00h, 00h
		db	 70h,0AAh,0FDh, 00h, 00h, 00h
		db	 00h, 57h,0EAh,0D5h, 00h, 00h
		db	 00h, 00h, 15h, 7Bh, 54h, 00h
		db	 00h, 00h, 00h, 01h, 75h, 40h
		db	 00h, 00h, 00h, 00h, 02h, 95h
		db	 40h, 00h, 00h, 00h, 00h, 01h
		db	 6Ah, 80h, 00h, 00h, 00h, 00h
		db	 01h, 55h, 40h, 00h, 00h, 00h
		db	 02h,0A2h, 95h, 60h, 00h, 00h
		db	 00h, 02h,0A2h,0BFh,0E0h, 00h
		db	 07h, 17h, 00h, 00h, 00h, 03h
		db	0FCh
data_C0BF	db	3Fh			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 0Ah,0FFh
		db	0BFh,0C0h, 00h, 00h, 00h, 3Fh
		db	0BFh,0CFh, 00h, 00h, 00h, 0Ah
		db	 8Fh, 8Fh,0C0h, 00h, 00h, 00h
		db	 02h,0AAh,0A3h, 00h, 00h, 00h
		db	 00h, 00h, 8Ah, 88h, 40h, 00h
		db	 00h, 00h, 00h, 2Ah,0A1h, 50h
		db	 00h, 00h, 00h, 00h, 0Fh, 0Dh
		db	 54h, 00h, 00h, 00h, 00h,0FFh
		db	0FEh, 25h, 00h, 00h, 00h, 03h
		db	0FFh,0FAh, 85h, 00h, 00h, 00h
		db	 03h,0F3h,0FAh,0AFh, 00h, 00h
		db	 00h, 03h,0F3h,0FAh,0FFh, 00h
		db	 00h, 00h, 00h,0FCh,0ACh,0F3h
		db	 00h, 00h, 00h, 00h, 3Ah,0AFh
		db	 0Fh, 00h, 00h, 00h, 00h, 4Ah
		db	0AFh,0FDh, 00h, 00h, 00h, 00h
		db	 6Ah,0FFh,0D5h, 00h, 00h, 00h
		db	 02h,0A5h, 55h, 54h, 00h, 00h
		db	 00h, 5Ah, 01h, 55h, 40h, 00h
		db	 00h, 06h, 55h, 02h, 82h, 80h
		db	 00h, 0Dh, 55h, 90h, 01h, 41h
		db	 40h, 00h, 03h, 55h, 00h, 01h
		db	 41h, 40h, 00h, 00h,0F0h, 02h
		db	0A2h,0AAh,0A0h, 00h, 00h, 00h
		db	 02h,0A2h,0AAh,0A0h, 00h, 07h
		db	 17h, 00h, 00h, 00h, 03h,0FCh
		db	 3Fh, 00h, 00h, 00h, 00h, 0Ah
		db	0FFh,0BFh,0C0h, 00h, 00h, 00h
		db	 3Fh,0BFh,0CFh, 00h, 00h, 00h
		db	 0Ah, 8Fh, 8Fh,0C0h, 00h, 00h
		db	 00h, 02h,0AAh,0A3h, 00h, 00h
		db	 00h, 00h, 00h, 8Ah, 88h, 00h
		db	 00h, 00h, 00h, 00h, 2Ah,0A0h
		db	 5Ah, 00h, 00h, 00h, 00h, 0Fh
		db	 0Fh, 8Ah, 00h, 00h, 00h, 00h
		db	0FFh,0FAh,0A1h, 00h, 00h, 00h
		db	 03h,0FFh,0FAh,0A5h, 00h, 00h
		db	 00h, 0Fh, 3Fh,0A8h,0F5h, 00h
		db	 00h, 00h, 0Fh,0CAh,0BCh,0FFh
		db	 00h, 00h, 00h, 0Eh,0ABh,0FFh
		db	 0Fh, 00h, 00h, 00h, 0Ah,0AFh
		db	0FFh,0FFh, 00h, 00h, 05h,0AAh
		db	0BFh,0FFh,0FDh, 00h,0D5h, 65h
		db	 50h, 5Fh,0FFh,0D5h, 00h, 35h
		db	 59h, 00h, 15h, 55h, 54h, 00h
		db	 0Fh, 50h, 00h, 01h, 55h, 40h
		db	 00h, 00h, 00h, 00h, 02h, 82h
		db	 80h, 00h, 00h, 00h, 00h, 01h
		db	 41h, 40h, 00h, 00h, 00h, 00h
		db	 01h, 41h, 40h, 00h, 00h, 00h
		db	 02h,0A2h,0AAh,0A0h, 00h, 00h
		db	 00h, 02h,0A2h,0AAh,0A0h, 00h
		db	 02h, 03h,0FFh, 00h,0FFh,0F0h
		db	0FFh,0FFh, 02h, 03h, 00h,0FFh
		db	 0Fh,0FFh,0FFh,0FFh, 04h, 0Ch
		db	 00h, 00h, 2Fh, 00h, 00h,0F2h
		db	 02h, 00h, 0Fh, 20h,0F0h, 00h
		db	 02h, 00h, 88h, 50h, 08h, 50h
		db	 0Fh, 80h, 00h, 08h, 88h, 0Fh
data_C228	db	0F2h
		db	 0Fh, 00h, 20h, 00h, 20h, 25h
		db	 00h, 08h, 82h, 02h, 0Fh, 0Fh
		db	 0Fh, 0Fh, 20h, 00h, 20h, 20h
		db	0F0h, 00h, 03h,0C0h, 00h, 04h
		db	 0Ch, 00h, 0Fh, 00h, 00h, 02h
		db	 00h, 88h,0F0h, 0Fh, 20h, 00h
		db	 00h, 20h, 00h,0F2h, 00h, 05h
		db	 08h, 20h, 50h, 08h, 0Fh, 0Fh
		db	 20h,0F0h, 80h, 22h, 00h, 0Fh
		db	 08h, 80h, 0Fh, 02h, 00h,0F2h
		db	 08h,0F0h, 25h, 0Fh, 00h, 08h
		db	 00h, 80h, 80h, 00h,0F0h, 00h
		db	 00h, 04h, 0Ch, 0Fh, 00h, 08h
		db	0F0h, 00h, 20h, 50h, 00h, 08h
		db	 02h, 00h, 80h, 00h, 80h, 20h
		db	 08h, 00h,0F2h, 0Fh, 00h, 20h
		db	 00h, 20h, 80h,0F0h, 82h, 00h
		db	 2Fh, 02h, 0Fh, 22h, 02h, 00h
		db	 20h, 85h, 00h, 08h, 00h, 08h
		db	 20h, 0Fh, 22h, 00h,0F0h, 00h
		db	 8Fh, 08h, 00h, 01h, 03h, 30h
		db	0DCh, 30h, 01h, 03h,0CCh, 10h
		db	0CCh, 04h, 03h, 3Dh,0FFh,0FCh
		db	 60h,0F7h,0FFh,0FFh, 18h,0E6h
		db	 6Ah,0AAh,0A8h, 04h, 10h, 0Fh
		db	 00h, 00h, 00h, 3Ah,0C0h, 00h
		db	 00h, 3Ah,0B0h, 00h, 00h, 0Eh
		db	0ACh,0F0h, 00h, 03h,0ABh,0ACh
		db	 00h, 03h,0EAh,0EBh, 00h, 0Eh
		db	0AAh,0BEh,0C0h, 0Eh,0BAh,0AAh
		db	0C0h, 3Ah,0EAh,0AAh,0C0h, 3Bh
		db	0AAh,0AAh,0C0h, 0Eh,0AAh,0AAh
		db	0B0h, 03h,0AAh,0AAh,0ACh, 00h
		db	0EAh,0AAh,0B0h, 00h, 3Fh,0EAh
		db	0C0h, 00h, 00h, 3Bh, 00h, 00h
		db	 00h, 0Ch, 00h, 02h, 09h, 11h
		db	 44h, 05h, 50h, 01h, 40h, 05h
		db	0F0h, 15h, 7Ch, 15h, 7Ch, 25h
		db	 78h, 1Ah,0ACh, 0Fh,0F0h, 04h
		db	 05h, 00h, 04h, 0Fh,0ECh, 0Ah
		db	 81h, 3Fh,0FBh,0ABh,0E5h, 75h
		db	 5Bh, 2Ah, 81h, 15h, 5Bh, 00h
		db	 04h, 05h, 64h, 04h, 05h, 00h
		db	 04h, 0Fh,0ECh, 02h, 01h, 3Fh
		db	0FBh, 2Bh, 85h, 75h, 5Bh, 02h
		db	 01h, 15h, 5Bh, 00h, 04h, 05h
		db	 64h, 04h, 05h, 3Bh,0F0h, 10h
		db	 00h,0EFh,0FCh, 42h,0A0h,0E5h
		db	 5Dh, 5Bh,0EAh,0E5h, 54h, 42h
		db	0A8h, 19h, 50h, 10h, 00h, 04h
		db	 05h, 3Bh,0F0h, 10h, 00h,0EFh
		db	0FCh, 40h, 80h,0E5h, 5Dh, 52h
		db	0E8h,0E5h, 54h, 40h, 80h, 19h
		db	 50h, 10h, 00h, 06h, 19h, 00h
		db	24 dup (0)
		db	 02h, 2Ah, 80h, 00h, 00h, 00h
		db	 08h,0AAh,0A0h, 00h, 00h, 00h
		db	 3Ah,0AAh,0A8h, 00h, 00h, 03h
		db	0FFh,0ABh,0F0h, 00h, 00h, 03h
		db	0FFh,0EBh,0CAh, 00h, 00h, 00h
		db	0FEh,0AAh,0AAh,0A0h, 00h, 00h
		db	 02h,0AAh, 20h, 00h, 00h, 00h
		db	 00h,0A0h,0EAh, 00h, 00h, 00h
		db	 04h, 2Ah,0AAh, 00h, 00h, 00h
		db	 54h, 00h, 00h, 00h, 00h, 01h
		db	 55h, 15h, 00h, 00h, 00h, 05h
		db	 41h, 15h, 40h, 00h, 00h, 15h
		db	 55h, 11h, 50h, 00h, 00h, 15h
		db	 15h, 01h, 51h, 00h, 00h, 54h
		db	 40h, 05h, 45h, 40h, 00h, 66h
		db	 11h, 55h, 05h, 40h, 00h,0AAh
		db	0A4h, 50h, 15h, 00h, 00h, 2Ah
		db	 80h, 00h, 14h, 00h, 00h, 0Ah
		db	 90h, 00h, 54h, 00h, 00h,0AAh
		db	 90h, 00h, 6Ah,0A0h, 00h,0A2h
		db	 20h, 00h, 88h,0A0h, 00h, 06h
		db	 19h, 00h, 02h, 2Ah, 80h, 00h
		db	 00h, 00h, 08h,0AAh,0A0h, 00h
		db	 00h, 00h, 3Ah,0AAh,0A8h, 00h
		db	 00h, 03h,0FFh,0ABh,0F0h, 00h
		db	 00h, 03h,0FFh,0EBh,0CAh, 00h
		db	 00h, 00h,0FEh,0AAh,0AAh,0A0h
		db	 00h, 00h, 02h,0AAh, 20h, 00h
		db	 00h, 00h, 00h,0A0h,0EAh, 00h
		db	 00h, 00h, 04h, 2Ah,0AAh, 00h
		db	 00h, 00h, 54h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 15h, 00h, 00h
		db	 00h, 15h, 41h, 15h, 40h, 00h
		db	 00h, 54h, 55h, 11h, 50h, 00h
		db	 00h, 62h, 54h, 05h, 50h, 00h
		db	 00h,0AAh,0A1h, 55h, 40h, 00h
		db	 00h, 2Ah,0BCh, 50h, 00h, 00h
		db	 00h, 0Ah, 80h, 04h, 00h, 00h
		db	 00h, 00h, 14h, 51h, 00h, 00h
		db	 00h, 01h, 40h, 05h, 40h, 00h
		db	 00h, 05h, 00h, 01h, 40h, 00h
		db	 00h, 05h, 00h, 00h, 50h, 00h
		db	 00h, 01h, 40h, 00h, 50h, 00h
		db	 00h, 01h, 50h, 00h, 54h, 00h
		db	 00h,0AAh, 90h, 00h, 6Ah,0A0h
		db	 00h,0A2h, 20h, 00h, 88h,0A0h
		db	 00h, 06h, 19h, 00h, 00h, 02h
		db	 2Ah, 80h, 00h, 00h, 00h, 08h
		db	0AAh,0A0h, 00h, 00h, 00h, 3Ah
		db	0AAh,0A8h, 00h, 00h, 03h,0FFh
		db	0ABh,0F0h, 00h, 00h, 03h,0FFh
		db	0EBh,0CAh, 00h, 00h, 00h,0FEh
		db	0AAh,0AAh,0A0h, 00h, 00h, 02h
		db	0AAh, 20h, 00h, 00h, 00h, 00h
		db	0A0h,0EAh, 00h, 00h, 00h, 14h
		db	 2Ah,0AAh, 02h, 00h, 00h, 55h
		db	 00h, 00h, 28h, 00h, 01h, 55h
		db	 05h, 00h,0A0h, 00h, 01h, 55h
		db	 41h, 42h, 80h, 00h, 05h, 45h
		db	 50h, 3Eh,0A8h, 00h, 05h, 51h
		db	 55h, 4Fh, 00h, 00h, 05h, 44h
		db	 15h, 50h, 00h, 00h, 15h, 15h
		db	 40h, 00h, 00h, 00h, 50h, 55h
		db	 15h, 00h, 00h, 00h, 01h, 44h
		db	 51h, 00h, 00h, 00h, 05h, 50h
		db	 05h, 00h, 00h, 00h, 05h, 00h
		db	 05h, 00h, 00h, 00h, 14h, 00h
		db	 14h, 00h, 00h, 00h, 14h, 00h
		db	 50h, 00h, 00h, 01h, 50h, 00h
		db	 54h, 00h, 00h,0AAh, 90h, 00h
		db	 6Ah,0A0h, 00h,0A2h, 20h, 00h
		db	 88h,0A0h, 00h, 06h, 19h, 00h
		db	25 dup (0)
		db	 02h,0A8h, 80h, 00h, 00h, 00h
		db	 0Ah,0AAh, 20h, 00h, 00h, 00h
		db	 2Ah,0AAh,0ACh, 00h, 00h, 00h
		db	 0Fh,0EAh,0FFh,0C0h, 00h, 00h
		db	0A3h,0EBh,0FFh,0C0h, 00h, 0Ah
		db	0AAh,0AAh,0BFh, 00h, 00h, 00h
		db	 08h,0AAh, 80h, 00h, 00h, 00h
		db	0ABh, 0Ah, 00h, 00h, 00h, 00h
		db	0AAh,0A8h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 00h, 00h, 00h
		db	 00h, 54h, 55h, 40h, 00h, 00h
		db	 01h, 54h, 41h, 50h, 00h, 00h
		db	 05h, 44h, 55h, 54h, 00h, 00h
		db	 45h, 40h, 54h, 54h, 00h, 01h
		db	 51h, 50h, 01h, 15h, 00h, 01h
		db	 50h, 55h, 44h, 99h, 00h, 00h
		db	 54h, 05h, 1Ah,0AAh, 00h, 00h
		db	 14h, 00h, 02h,0A8h, 00h, 00h
		db	 15h, 00h, 06h,0A0h, 00h, 0Ah
		db	0A9h, 00h, 06h,0AAh, 00h, 0Ah
		db	 22h, 00h, 08h, 8Ah, 06h, 19h
		db	 00h, 00h, 02h,0A8h, 80h, 00h
		db	 00h, 00h, 0Ah,0AAh, 20h, 00h
		db	 00h, 00h, 2Ah,0AAh,0ACh, 00h
		db	 00h, 00h, 0Fh,0EAh,0FFh,0C0h
		db	 00h, 00h,0A3h,0EBh,0FFh,0C0h
		db	 00h, 0Ah,0AAh,0AAh,0BFh, 00h
		db	 00h, 00h, 08h,0AAh, 80h, 00h
		db	 00h, 00h,0ABh, 0Ah, 00h, 00h
		db	 00h, 00h,0AAh,0A8h, 10h, 00h
		db	 00h, 00h, 00h, 00h, 15h, 00h
		db	 00h, 00h, 00h, 54h, 55h, 50h
		db	 00h, 00h, 01h, 54h, 41h, 54h
		db	 00h, 00h, 05h, 44h, 55h, 15h
		db	 00h, 00h, 05h, 50h, 15h, 89h
		db	 00h, 00h, 01h, 55h, 4Ah,0AAh
		db	 00h, 00h, 00h, 05h, 3Eh,0A8h
		db	 00h, 00h, 00h, 10h, 02h,0A0h
		db	 00h, 00h, 00h, 45h, 14h, 00h
		db	 00h, 00h, 01h, 50h, 01h, 40h
		db	 00h, 00h, 01h, 40h, 00h, 50h
		db	 00h, 00h, 05h, 00h, 00h, 50h
		db	 00h, 00h, 05h, 00h, 01h, 40h
		db	 00h, 00h, 15h, 00h, 05h, 40h
		db	 00h, 0Ah,0A9h, 00h, 06h,0AAh
		db	 00h, 0Ah, 22h, 00h, 08h, 8Ah
		db	 06h, 19h, 00h, 02h,0A8h, 80h
		db	 00h, 00h, 00h, 0Ah,0AAh, 20h
		db	 00h, 00h, 00h, 2Ah,0AAh,0ACh
		db	 00h, 00h, 00h, 0Fh,0EAh,0FFh
		db	0C0h, 00h, 00h,0A3h,0EBh,0FFh
		db	0C0h, 00h, 0Ah,0AAh,0AAh,0BFh
		db	 00h, 00h, 00h, 08h,0AAh, 80h
		db	 00h, 00h, 00h,0ABh, 0Ah, 00h
		db	 00h, 00h, 80h,0AAh,0A8h, 14h
		db	 00h, 00h, 28h, 00h, 00h, 55h
		db	 00h, 00h, 0Ah, 00h, 50h, 55h
		db	 40h, 00h, 02h, 81h, 41h, 55h
		db	 40h, 00h, 2Ah,0BCh, 05h, 51h
		db	 50h, 00h, 00h,0F1h, 55h, 45h
		db	 50h, 00h, 00h, 05h, 54h, 11h
		db	 50h, 00h, 00h, 00h, 01h, 54h
		db	 54h, 00h, 00h, 00h, 54h, 55h
		db	 05h, 00h, 00h, 00h, 45h, 11h
		db	 40h, 00h, 00h, 00h, 50h, 05h
		db	 50h, 00h, 00h, 00h, 50h, 00h
		db	 50h, 00h, 00h, 00h, 14h, 00h
		db	 14h, 00h, 00h, 00h, 05h, 00h
		db	 14h, 00h, 00h, 00h, 15h, 00h
		db	 05h, 40h, 00h, 0Ah,0A9h, 00h
		db	 06h,0AAh, 00h, 0Ah, 22h, 00h
		db	 08h, 8Ah, 06h, 18h
		db	8 dup (0)
		db	 04h, 70h, 00h, 00h, 00h, 00h
		db	 11h, 5Fh, 00h, 00h, 00h, 00h
		db	 15h, 55h,0C0h, 00h, 00h, 00h
		db	 0Ah,0AAh, 00h, 00h, 00h, 00h
		db	0A2h,0BCh,0A0h, 00h, 00h, 02h
		db	 2Ah,0AAh,0AAh, 00h, 00h, 00h
		db	0A2h, 82h, 00h, 00h, 0Ah, 80h
		db	 0Ah,0A8h,0A0h, 00h, 2Ah,0A5h
		db	 0Ah,0A8h, 00h, 00h, 28h,0AAh
		db	 50h,0A2h, 80h, 00h,0A8h, 5Ah
		db	 5Ah, 0Ah, 00h, 00h,0A8h, 55h
		db	 50h, 00h, 00h, 00h,0AAh, 05h
		db	 54h, 00h, 00h, 00h, 22h,0A5h
		db	 55h, 00h, 00h, 00h, 00h, 2Ah
		db	 14h, 80h, 00h, 00h, 00h, 3Eh
		db	0A2h,0A0h, 00h, 00h, 00h, 03h
		db	0E2h, 80h, 00h, 00h, 00h, 00h
		db	 3Eh,0B0h, 00h, 00h, 00h, 00h
		db	0FCh,0D5h, 50h, 00h, 00h, 0Fh
		db	0C3h, 15h, 55h, 00h, 00h, 3Ch
		db	 3Fh, 05h, 55h, 00h, 00h,0AAh
		db	0A2h,0A9h, 50h, 00h, 02h,0AAh
		db	0A2h,0A8h, 00h, 00h, 06h, 18h
		db	 00h
		db	8 dup (0)
		db	 47h, 00h, 00h, 00h, 00h, 01h
		db	 15h,0F0h, 00h, 00h, 00h, 01h
		db	 55h, 5Ch, 00h, 00h, 00h, 00h
		db	0AAh,0A0h, 00h, 00h, 00h, 0Ah
		db	 2Bh,0CAh, 00h, 00h, 00h, 22h
		db	0AAh,0AAh,0A0h, 00h, 00h, 0Ah
		db	 28h, 20h, 00h, 00h, 00h, 00h
		db	0AAh, 8Ah, 00h, 00h, 29h, 50h
		db	0AAh, 80h, 00h, 02h,0AAh, 95h
		db	 0Ah, 28h, 00h, 0Ah,0A6h, 95h
		db	0A0h,0A0h, 00h, 0Ah,0A5h, 55h
		db	 00h, 00h, 00h, 02h,0A9h, 56h
		db	 00h, 00h, 00h, 00h, 6Ah,0A4h
		db	 80h, 00h, 00h, 00h, 4Ah,0A9h
		db	 88h, 00h, 00h, 00h, 3Eh,0AAh
		db	 2Ah, 00h, 00h, 00h, 03h,0F2h
		db	0AAh, 00h, 00h, 00h, 00h, 3Ch
		db	0EAh, 95h, 50h, 00h, 00h,0FCh
		db	0C0h, 55h, 55h, 00h, 0Fh,0C3h
		db	 00h, 05h, 55h, 00h, 3Ch, 3Fh
		db	 00h, 00h, 50h, 00h,0AAh,0A2h
		db	0A8h, 00h, 00h, 02h,0AAh,0A2h
		db	0A8h, 00h, 00h, 06h, 18h, 00h
		db	 00h, 04h, 70h, 00h, 00h, 00h
		db	 00h, 11h, 5Fh, 00h, 00h, 00h
		db	 00h, 15h, 55h,0C0h, 00h, 00h
		db	 00h, 0Ah,0AAh, 00h, 00h, 00h
		db	 00h,0A2h,0BCh,0A0h, 00h, 00h
		db	 02h, 2Ah,0AAh,0AAh, 00h, 00h
		db	 00h,0A2h, 82h, 00h, 00h, 00h
		db	 00h, 0Ah,0A8h,0A0h, 00h, 00h
		db	 05h, 0Ah,0A8h, 00h, 00h, 00h
		db	 1Ah, 50h,0A2h, 80h, 00h, 00h
		db	 6Ah, 95h, 0Ah, 00h, 50h, 01h
		db	0AAh, 55h, 80h, 05h, 55h, 01h
		db	0A9h, 54h,0A2h, 55h, 55h, 01h
		db	0AAh,0A5h, 0Ah, 95h, 50h, 00h
		db	0FAh,0AAh,0AAh, 80h, 00h, 00h
		db	 3Fh,0AAh, 08h, 00h, 00h, 00h
		db	 03h,0F3h, 00h, 00h, 00h, 00h
		db	 00h, 3Ch,0C0h, 00h, 00h, 00h
		db	 00h,0FCh,0C0h, 00h, 00h, 00h
		db	 0Fh,0C3h, 00h, 00h, 00h, 00h
		db	 3Ch, 0Fh, 00h, 00h, 00h, 00h
		db	 3Ch, 0Fh, 00h, 00h, 00h, 00h
		db	0AAh,0A2h,0A8h, 00h, 00h, 02h
		db	0AAh,0A2h,0A8h, 00h, 00h, 06h
		db	 18h, 00h
		db	7 dup (0)
		db	 0Dh, 10h, 00h, 00h, 00h, 00h
		db	0F5h, 44h, 00h, 00h, 00h, 03h
		db	 55h, 54h, 00h, 00h, 00h, 00h
		db	0AAh,0A0h, 00h, 00h, 00h, 0Ah
		db	 3Eh, 8Ah, 00h, 00h, 00h,0AAh
		db	0AAh,0A8h, 80h, 00h, 00h, 00h
		db	 82h, 8Ah, 00h, 00h, 00h, 0Ah
		db	 2Ah,0A0h, 02h,0A0h, 00h, 00h
		db	 2Ah,0A0h, 5Ah,0A8h, 00h, 02h
		db	 8Ah, 05h,0AAh, 28h, 00h, 00h
		db	0A0h,0A5h,0A5h, 2Ah, 00h, 00h
		db	 00h, 05h, 55h, 2Ah, 00h, 00h
		db	 00h, 15h, 50h,0AAh, 00h, 00h
		db	 00h, 55h, 5Ah, 88h, 00h, 00h
		db	 02h, 14h,0A8h, 00h, 00h, 00h
		db	 0Ah, 8Ah,0BCh, 00h, 00h, 00h
		db	 02h, 8Bh,0C0h, 00h, 00h, 00h
		db	 0Eh,0BCh, 00h, 00h, 00h, 05h
		db	 57h, 3Fh, 00h, 00h, 00h, 55h
		db	 54h,0C3h,0F0h, 00h, 00h, 55h
		db	 50h,0FCh, 3Ch, 00h, 00h, 05h
		db	 6Ah, 8Ah,0AAh, 00h, 00h, 00h
		db	 2Ah, 8Ah,0AAh, 80h, 06h, 18h
		db	 00h
		db	7 dup (0)
		db	0D1h, 00h, 00h, 00h, 00h, 0Fh
		db	 54h, 40h, 00h, 00h, 00h, 35h
		db	 55h, 40h, 00h, 00h, 00h, 0Ah
		db	0AAh, 00h, 00h, 00h, 00h,0A3h
		db	0E8h,0A0h, 00h, 00h, 0Ah,0AAh
		db	0AAh, 88h, 00h, 00h, 00h, 08h
		db	 28h,0A0h, 00h, 00h, 00h,0A2h
		db	0AAh, 00h, 00h, 00h, 00h, 02h
		db	0AAh, 05h, 68h, 00h, 00h, 28h
		db	0A0h, 56h,0AAh, 80h, 00h, 0Ah
		db	 0Ah, 56h, 9Ah,0A0h, 00h, 00h
		db	 00h, 55h, 5Ah,0A0h, 00h, 00h
		db	 00h, 95h, 6Ah, 80h, 00h, 00h
		db	 02h, 1Ah,0A9h, 00h, 00h, 00h
		db	 22h, 6Ah,0A1h, 00h, 00h, 00h
		db	0A8h,0AAh,0BCh, 00h, 00h, 00h
		db	0AAh, 8Fh,0C0h, 00h, 05h, 56h
		db	0ABh, 3Ch, 00h, 00h, 55h, 55h
		db	 03h, 3Fh, 00h, 00h, 55h, 50h
		db	 00h,0C3h,0F0h, 00h, 05h, 00h
		db	 00h,0FCh, 3Ch, 00h, 00h, 00h
		db	 2Ah, 8Ah,0AAh, 00h, 00h, 00h
		db	 2Ah, 8Ah,0AAh, 80h, 06h, 18h
		db	 00h, 00h, 0Dh, 10h, 00h, 00h
		db	 00h, 00h,0F5h, 44h, 00h, 00h
		db	 00h, 03h, 55h, 54h, 00h, 00h
		db	 00h, 00h,0AAh,0A0h, 00h, 00h
		db	 00h, 0Ah, 3Eh, 8Ah, 00h, 00h
		db	 00h,0AAh,0AAh,0A8h, 80h, 00h
		db	 00h, 00h, 82h, 8Ah, 00h, 00h
		db	 00h, 0Ah, 2Ah,0A0h, 00h, 00h
		db	 00h, 00h, 2Ah,0A0h, 50h, 00h
		db	 00h, 02h, 8Ah, 05h,0A4h, 00h
		db	 05h, 00h,0A0h, 56h,0A9h, 00h
		db	 55h, 50h, 02h, 55h,0AAh, 40h
		db	 55h, 55h, 8Ah, 15h, 6Ah, 40h
		db	 05h, 56h,0A0h, 5Ah,0AAh, 40h
		db	 00h, 02h,0AAh,0AAh,0AFh, 00h
		db	 00h, 00h, 20h,0AAh,0FCh, 00h
		db	 00h, 00h, 00h,0CFh,0C0h, 00h
		db	 00h, 00h, 03h, 3Ch, 00h, 00h
		db	 00h, 00h, 03h, 3Fh, 00h, 00h
		db	 00h, 00h, 00h,0C3h,0F0h, 00h
		db	 00h, 00h, 00h,0F0h, 3Ch, 00h
		db	 00h, 00h, 00h,0F0h, 3Ch, 00h
		db	 00h, 00h, 2Ah, 8Ah,0AAh, 00h
		db	 00h, 00h, 2Ah, 8Ah,0AAh, 80h
		db	 02h, 06h, 03h,0B0h, 0Fh,0ECh
		db	 3Dh, 5Bh, 35h, 6Bh, 35h,0BCh
		db	 0Eh,0F0h, 06h, 0Fh,0FFh, 03h
		db	0FCh, 40h, 00h, 00h,0EFh,0F0h
		db	0F1h, 50h, 00h, 00h,0AFh,0FFh
		db	 05h, 55h, 50h, 00h,0AAh, 00h
		db	0EBh,0F0h, 00h, 00h, 28h,0FFh
		db	0CBh,0CAh,0A0h, 00h, 54h,0FFh
		db	 2Ah,0F8h, 80h, 00h, 54h, 3Eh
		db	 8Ah,0AAh, 00h, 00h, 54h, 00h
		db	0A8h, 00h, 00h, 00h, 54h, 00h
		db	 0Ah, 00h, 00h, 00h, 14h, 00h
		db	 02h,0A0h, 00h, 00h, 15h, 51h
		db	 50h, 00h, 00h, 00h, 05h, 55h
		db	 55h, 04h, 00h, 00h, 00h, 54h
		db	 55h, 41h, 00h, 00h, 00h, 01h
		db	 40h, 41h, 40h, 00h, 00h, 05h
		db	 55h, 41h, 10h, 00h, 06h, 0Fh
		db	 00h, 03h,0FCh, 40h, 00h, 00h
		db	 00h, 0Fh,0F1h, 50h, 00h, 00h
		db	 00h, 00h, 05h, 55h, 50h, 00h
		db	 03h, 3Fh,0EBh,0F0h, 00h, 00h
		db	 00h,0FFh,0CBh,0CAh,0A0h, 00h
		db	 00h,0FFh, 2Ah,0F8h, 80h, 00h
		db	 03h, 3Eh, 8Ah,0AAh, 00h, 00h
		db	 00h, 00h,0A8h, 00h, 00h, 00h
		db	 00h, 00h, 0Ah, 00h, 00h, 0Ah
		db	 00h, 00h, 02h,0A0h, 00h, 28h
		db	 00h, 01h, 50h, 00h, 00h,0A0h
		db	 00h, 05h, 55h, 04h, 02h,0A0h
		db	 00h, 05h, 55h, 51h, 06h,0A8h
		db	 00h, 05h, 05h, 55h, 55h, 00h
		db	 00h, 05h, 50h, 15h, 50h, 00h
		db	 06h, 0Fh, 00h, 00h, 01h, 3Fh
		db	0C0h,0FFh, 00h, 00h, 05h, 4Fh
		db	 0Fh,0FBh, 00h, 05h, 55h, 50h
		db	0FFh,0FAh, 00h, 00h, 0Fh,0EBh
		db	 00h,0AAh, 00h, 0Ah,0A3h,0E3h
		db	0FFh, 28h, 00h, 02h, 2Fh,0A8h
		db	0FFh, 15h, 00h, 00h,0AAh,0A2h
		db	0BCh, 15h, 00h, 00h, 00h, 2Ah
		db	 00h, 15h, 00h, 00h, 00h,0A0h
		db	 00h, 15h, 00h, 00h, 0Ah, 80h
		db	 00h, 14h, 00h, 00h, 00h, 05h
		db	 45h, 54h, 00h, 00h, 10h, 55h
		db	 55h, 50h, 00h, 00h, 41h, 55h
		db	 15h, 00h, 00h, 01h, 41h, 01h
		db	 40h, 00h, 00h, 04h, 41h, 55h
		db	 50h, 00h, 06h, 0Fh, 00h, 00h
		db	 01h, 3Fh,0C0h, 00h, 00h, 00h
		db	 05h, 4Fh,0F0h, 00h, 00h, 05h
		db	 55h, 50h, 00h, 00h, 00h
		db	 00h, 0Fh,0EBh,0FCh,0C0h, 00h
		db	 0Ah,0A3h,0E3h,0FFh, 00h, 00h
		db	 02h, 2Fh,0A8h,0FFh, 00h, 00h
		db	 00h,0AAh,0A2h,0BCh,0C0h, 00h
		db	 00h, 00h, 2Ah, 00h, 00h,0A0h
		db	 00h, 00h,0A0h, 00h, 00h, 28h
		db	 00h, 0Ah, 80h, 00h, 00h, 0Ah
		db	 00h, 00h, 05h, 40h, 00h, 0Ah
		db	 80h, 10h, 55h, 50h, 00h, 2Ah
		db	 90h, 45h, 55h, 50h, 00h, 00h
		db	 55h, 55h, 50h, 50h, 00h, 00h
		db	 05h, 54h, 05h, 50h, 00h, 04h
		db	 09h, 00h, 00h, 03h,0F0h, 00h
		db	 55h, 0Fh, 3Ch, 05h, 55h, 50h
		db	0F0h, 17h,0FFh,0D5h, 00h, 7Fh
		db	0FFh,0FFh, 40h, 7Fh,0FFh,0FFh
		db	0F0h, 3Ch,0FFh,0FFh,0C0h, 0Fh
		db	 33h, 33h, 00h, 00h,0CCh,0C0h
		db	 00h, 04h, 09h, 01h, 54h, 00h
		db	 00h, 05h, 55h, 00h, 00h, 05h
		db	0FDh, 05h, 40h, 01h,0FFh, 5Fh
		db	 50h, 00h, 7Fh,0FFh,0D0h, 0Fh
		db	0FFh,0FFh,0C0h, 3Fh,0FCh,0CFh
		db	 0Fh, 3Fh,0F3h, 30h,0F3h, 0Ch
		db	0CCh, 00h, 3Ch, 03h, 07h, 00h
		db	 05h, 50h,0F0h,0FFh,0D4h, 03h
		db	0F3h,0F4h, 0Fh, 3Fh,0C4h, 00h
		db	0F3h,0D0h, 00h, 0Fh, 00h, 0Fh
		db	 00h, 00h, 03h, 07h, 05h, 50h
		db	 00h, 17h,0FFh, 0Fh, 1Fh,0CFh
		db	0C0h, 13h,0FCh,0F0h, 07h,0CFh
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	0F0h
data_CC5E	db	0BAh
		db	0CCh, 1Ch,0CDh, 1Eh,0CDh, 1Eh
		db	0CDh, 20h,0CDh, 32h,0CDh, 42h
		db	0CDh, 44h,0CDh, 5Ch,0CDh, 5Ch
		db	0CDh, 5Ch,0CDh, 5Ch,0CDh, 88h
		db	0CDh, 5Eh,0CDh, 6Ah,0CDh,0DAh
		db	0CDh,0EAh,0CDh,0F6h,0CDh,0FAh
		db	0CDh, 76h,0CDh, 7Eh,0CDh, 86h
		db	0CDh, 88h,0CDh,0BCh,0CDh,0C6h
		db	0CDh,0D2h,0CDh, 88h,0CDh, 8Ah
		db	0CDh, 9Ah,0CDh, 88h,0CDh, 9Ch
		db	0CDh,0A8h,0CDh,0B4h,0CDh,0FAh
		db	0CDh, 04h,0CEh, 0Eh,0CEh, 10h
		db	0CEh,0D2h,0CDh, 14h,0CEh, 20h
		db	0CEh, 2Ch,0CEh, 2Eh,0CEh, 36h
		db	0CEh, 3Ah,0CEh, 40h,0CEh, 98h
		db	0CDh, 11h, 8Fh, 11h, 8Fh, 2Dh
		db	 90h, 2Dh, 90h, 11h, 8Fh, 11h
		db	 8Fh, 9Fh, 8Fh, 9Fh, 8Fh,0F3h
		db	 92h,0D7h, 91h, 65h, 92h,0BBh
		db	 90h, 49h, 91h, 81h, 93h,0FBh
		db	 93h, 75h, 94h,0D6h, 94h, 31h
		db	0AFh,0CDh,0AFh, 69h,0B0h, 37h
		db	 95h,0C5h, 95h, 53h, 96h,0E1h
		db	 96h,0E1h, 96h,0FDh, 97h,0FDh
		db	 97h,0E1h, 96h,0E1h, 96h
		db	6Fh
		db	 97h, 6Fh, 97h,0C3h, 9Ah,0A7h
		db	 99h, 35h, 9Ah, 8Bh, 98h, 19h
		db	 99h, 51h, 9Bh,0CBh, 9Bh, 75h
		db	 94h,0D6h, 94h, 31h,0AFh,0CDh
		db	0AFh, 69h,0B0h,0CDh,0AFh, 31h
		db	0AFh, 45h, 9Ch,0D3h, 9Ch, 61h
		db	 9Dh, 0Eh, 86h, 88h, 89h, 2Ah
		db	0B9h, 26h, 89h, 78h, 86h, 9Eh
		db	 87h, 62h, 88h, 00h, 88h,0C4h
		db	 88h, 3Ch, 87h,0DAh, 86h, 0Eh
		db	 86h, 02h,0C4h, 6Ah,0C3h, 02h
		db	0C4h, 9Ah,0C4h

locloop_CD3A:
		retf	32C5h
		db	0C5h,0CAh,0C5h, 62h,0C6h,0AEh
		db	0C2h,0EFh, 9Dh, 99h, 9Eh
		db	43h
		db	 9Fh, 99h, 9Eh,0EDh, 9Fh, 97h
		db	0A0h, 41h,0A1h,0EBh,0A1h, 95h
		db	0A2h,0EBh,0A1h, 3Fh,0A3h,0E9h
		db	0A3h, 99h, 89h,0D4h,0B7h, 0Dh
		db	0B8h, 46h,0B8h, 7Fh,0B8h,0B8h
		db	0B8h,0F1h,0B8h,0A7h,0AAh, 1Bh
		db	0AAh, 33h,0ABh, 4Bh,0ACh
		db	0BFh,0ABh,0D7h,0ACh, 8Bh,0A5h
		db	0DDh,0A5h, 2Fh,0A6h, 81h,0A6h
		db	 67h, 8Bh,0A3h, 8Ah, 05h, 8Bh
		db	 41h, 8Ah, 03h, 8Ah, 93h,0A4h
		db	0D1h,0A4h, 0Fh,0A5h, 4Dh,0A5h
		db	 0Eh, 86h, 0Eh, 86h, 0Eh, 86h
		db	 0Eh, 86h, 0Eh, 86h,0BCh,0C2h
		db	0D3h,0A6h, 5Fh,0A7h,0EBh,0A7h
		db	 77h,0A8h, 03h,0A9h, 8Fh,0A9h
		db	0C9h, 8Bh, 55h, 8Ch,0E1h, 8Ch
		db	 6Dh, 8Dh,0F9h, 8Dh, 85h, 8Eh
		db	0CCh,0BBh, 26h,0BCh, 80h,0BCh
		db	0DAh,0BCh, 05h,0B1h,0A0h,0B1h
		db	 3Bh,0B2h,0D6h,0B2h, 71h,0B3h
		db	 63h,0ADh,0B0h,0ADh,0FDh,0ADh
		db	 4Ah,0AEh, 97h,0AEh,0E4h,0AEh
		db	 34h,0BDh, 72h,0BDh,0B0h,0BDh
		db	0EEh,0BDh, 04h,0BAh, 76h,0BAh
		db	 31h,0AFh,0CDh,0AFh, 69h,0B0h
		db	0CDh,0AFh, 31h,0AFh, 0Eh, 86h
		db	 2Ch,0BEh,0CFh,0BEh, 72h,0BFh
		db	 15h,0C0h,0B8h,0C0h, 5Bh,0C1h
		db	0E4h,0CBh, 0Ah,0CCh, 0Ch,0B4h
		db	 8Ch,0B4h, 0Ch,0B5h, 8Ch,0B4h
		db	 0Ch,0B4h,0FEh,0C2h, 12h,0C3h
		db	 28h,0C3h, 3Eh,0C3h, 54h,0C3h
		db	 66h,0CAh,0A4h,0C2h,0A9h,0C2h
		db	 1Bh,0AAh,0A7h,0AAh, 33h,0ABh
		db	0BFh,0ABh, 4Bh,0ACh,0D7h,0ACh
		db	0FAh,0C6h, 8Ch,0C7h, 1Eh,0C8h
		db	0B0h,0C8h, 42h,0C9h,0D4h,0C9h
		db	 30h,0CCh, 74h,0CAh,0D0h,0CAh
		db	 2Ch,0CBh, 88h,0CBh,0FEh,0C1h
		db	 06h,0C2h, 0Eh,0C2h, 40h,0C2h
loc_CE3E:
		jc	$-3Ch			; Jump if carry Set
		db	 8Ch,0B5h, 1Eh,0B6h,0B0h,0B6h
		db	 42h,0B7h

loc_CE48: ; file offset CD48 ... keyboard scan codes

		db	22h	; key G
		db	15h	; key Y
		db	25h	; key K
		db	18h ;4Bh	; key Left ... old 18h, key O
		db	19h ;4Dh	; key Right ... old 19h, key P
		db	10h ;48h	; key Up ... old 10h, key Q
		db	1Eh ;50h	; key Down ... old 1Eh, key A
		db	39h	; key Space (shooting)
		db	01h	; key Esc (quit) ... old 46h, key Sroll Lock
		db	1Ch	; key Enter (ladder)
		db	12h	; key E
		db	13h	; key R
		db	1Fh ;7Eh	; old 1Fh, key S


;		and	dl,[di]	; 22h 15h
;		and	ax,1918h ; 25h 18h 19h
;		adc	data_4639,bl ; 10h 1Eh 39h 46h
;		sbb	al,12h ; 1Ch 12h
;		adc	bx,[bx] ; 13h 1Fh


		and	[bx+si],bh
		sbb	ax,3B53h
;*		jp	loc_CED5		;*Jump if parity=1
		db	 7Ah, 79h		;  Fixup - byte match
		jl	loc_CED9		; Jump if <
;*		ja	loc_CED8		;*Jump if above
		db	 77h, 78h		;  Fixup - byte match
		add	[si],cl
		add	[bx-31h],si
		add	al,byte ptr ds:[1403h][si]
		add	[bx+si],cl
		or	al,1
		jl	loc_CE3E		; Jump if <
		add	dl,byte ptr ds:[1401h][bx+si]
		add	[bx+si],cl
		or	al,1
		jbe	loc_CE48		; Jump if below or =
		add	al,byte ptr ds:[103h][si]
		add	[si],al
		add	[bx+si],ax
		add	ch,al
		add	ax,[bx+di]
		add	[si],al
		add	[bx+si],ax
		add	dl,al
		pop	es
		add	[bx+si],ax
		add	al,1
		add	[bp+si],al
		mov	ax,10Bh
		add	[si],al
		add	[bx+si],ax
		add	ah,byte ptr ds:[10Fh][bx+si]
		add	[si],al
		add	[bx+si],ax
		add	cl,byte ptr ds:[113h][bx+si]
		add	[si],al

locloop_CEA7:
		add	[bx+si],ax
		add	dh,[bx+si+17h]
		add	[bx+si],ax
		add	al,1
		add	[bp+si],al
		pop	ax
		sbb	ax,[bx+di]
		add	[si],al
		add	[bx+si],ax
		add	al,[bx+si+1Fh]
		add	[bx+si],ax
		add	al,1
		add	[bp+si],al
		sub	[bp+di],ah
		add	[bx+si],ax
		add	al,1
		add	[bp+si],al
		adc	[bx],ah
		add	[bx+si],ax
		add	al,1
		add	[bx+si],cl
		or	byte ptr ds:[0CEE0h],al
		push	es
		loopnz	locloop_CEA7		; Loop if zf=0, cx>0

loc_CED9:
		push	es
;*		loopnz	locloop_CEAA		;*Loop if zf=0, cx>0

		db	0E0h,0CEh		;  Fixup - byte match
		push	es
;*		loopnz	locloop_CEAD		;*Loop if zf=0, cx>0

		db	0E0h,0CEh		;  Fixup - byte match
		or	[bp+si],al
loc_CEE1:
		nop
		add	[bp+si],ax
		add	[bp+si],al
		and	[bp+di],al
		add	al,[bx+si]
		add	cl,al
		add	[bp+si],al
		add	[bp+si],al
		nop
		add	[bp+si],ax
		add	[bp+si],al
		inc	ax
		push	es
		add	al,[bx+si]
		or	[si],cl
		add	[bp-31h],si
		add	dl,byte ptr ds:[0A01h][bx+si]
		add	[bp+si],al
		hlt				; Halt processor
		add	[bp+si],cx
		add	[bp+si],al
		pop	ax
		add	cl,[bp+si]
		add	[bx+si],cl
		or	al,1
		ja	loc_CEE1		; Jump if above
		add	ch,al
;*		add	sp,[si+0]
		db	 03h, 64h, 00h		;  Fixup - byte match
		db	 08h, 02h, 90h, 01h, 02h, 00h
		db	 02h, 20h, 03h, 02h, 00h, 02h
		db	0C8h, 00h, 02h, 00h, 02h, 90h
		db	 01h, 02h, 00h, 02h, 40h, 06h
		db	 02h, 00h, 08h, 08h, 0Ch, 01h
		db	 7Ah,0CFh, 02h, 64h, 00h, 0Fh
data_CF3B	dw	800h, 3002h
data_CF3F	db	75h
		db	 02h, 00h, 0Ah, 3Dh,0CFh, 0Ch
		db	 01h, 7Ah,0CFh, 02h,0E8h, 03h
		db	 05h, 00h, 08h, 0Ch, 01h, 7Ah
		db	0CFh, 02h, 64h, 00h, 0Fh, 00h
		db	 08h, 0Ch, 01h, 76h,0CFh, 02h
		db	 90h, 01h, 0Ah, 00h, 02h,0F4h
		db	 01h, 0Ah, 00h, 02h, 58h, 02h
		db	 0Ah, 00h, 08h, 08h, 02h, 10h
		db	 27h,0E8h, 03h, 0Ah, 6Dh,0CFh
		db	 81h,0ECh, 28h, 80h, 28h, 80h
		db	 28h,0B0h, 1Eh,0C4h, 28h,0ECh
		db	 1Eh,0CEh, 14h,0CEh, 32h,0ECh
		db	 32h,0ECh, 0Ah,0E2h, 3Ch, 80h
		db	 00h, 02h,0DBh, 11h, 0Eh, 00h
		db	 02h, 5Ah, 0Dh, 15h, 00h, 02h
		db	0E9h, 08h, 07h, 00h, 02h, 74h
		db	 09h, 4Dh, 00h, 02h,0E9h, 08h
		db	 07h, 00h, 02h,0E3h, 0Bh, 15h
		db	 00h, 02h, 3Bh, 0Bh, 0Eh, 00h
		db	 02h,0D3h, 10h, 9Ah, 00h, 04h
		db	 15h, 00h
		db	8
data_CFBB	db	4
		db	 23h, 00h, 02h,0E9h, 08h, 07h
		db	 00h, 02h, 69h, 08h, 0Eh, 00h
		db	 02h, 9Dh, 05h, 15h, 00h, 02h
		db	0F1h, 05h, 5Bh, 00h, 02h,0F1h
		db	 05h, 15h, 00h, 02h, 9Dh, 05h
		db	 0Eh, 00h, 02h,0F1h, 05h, 15h
		db	 00h, 02h,0ADh, 06h, 1Ch, 00h
		db	 02h, 9Dh, 05h, 15h, 00h, 02h
		db	 00h, 05h, 0Eh, 00h, 02h, 9Dh
		db	 05h, 15h, 00h, 02h,0F1h, 05h
		db	 15h, 00h, 02h, 4Ch, 06h, 2Ah
		db	 00h, 02h, 7Eh, 07h, 07h, 00h
		db	 02h, 4Ch, 06h, 0Eh, 00h, 02h
		db	 34h, 04h, 07h, 00h, 04h, 0Eh
		db	 00h, 08h, 04h, 0Eh, 00h, 02h
		db	0DBh, 11h, 0Eh, 00h, 04h, 07h
		db	 00h, 02h,0DBh, 11h, 07h, 00h
		db	 02h,0FCh, 0Eh, 0Eh, 00h, 04h
		db	 07h, 00h, 02h,0FCh, 0Eh, 0Eh
		db	 00h, 02h, 5Ah, 0Dh, 15h, 00h
		db	 02h,0FCh, 0Eh, 07h, 00h, 02h
		db	 2Ah, 0Eh, 0Eh, 00h, 02h, 5Ah
		db	 0Dh, 15h, 00h, 04h, 1Ch, 00h
		db	 08h, 04h, 38h, 00h, 02h,0FCh
		db	 0Eh, 07h, 00h, 02h, 2Ah, 0Eh
		db	 0Eh, 00h, 02h, 5Ah, 0Dh, 5Bh
		db	 00h, 04h, 15h, 00h, 02h, 00h
		db	 0Ah, 0Eh, 00h, 02h,0E3h, 0Bh
		db	 07h, 00h, 02h, 74h, 09h, 0Eh
		db	 00h, 02h,0E9h, 08h, 07h, 00h
		db	 04h, 15h, 00h, 02h, 00h, 0Ah
		db	 0Eh, 00h, 02h,0E3h, 0Bh, 07h
		db	 00h, 02h, 00h, 0Ah, 0Eh, 00h
		db	 04h, 07h, 00h, 02h
loc_D086:
		jz	$+0Bh			; Jump if zero
		push	cs
		add	[bp+si],al
		jmp	$+70Bh
		db	 00h, 04h, 15h, 00h, 08h, 02h
		db	0C9h, 1Ah, 15h, 00h, 06h, 39h
		db	0D1h, 02h, 6Bh, 1Ch, 15h, 00h
		db	 06h, 39h,0D1h, 02h, 11h, 1Eh
		db	 15h, 00h, 06h, 39h,0D1h, 02h
		db	0ECh, 1Fh, 15h, 00h, 06h, 39h
		db	0D1h, 02h,0C6h, 21h, 15h, 00h
		db	 06h, 39h,0D1h, 02h, 2Eh, 28h
		db	 15h, 00h, 06h, 39h,0D1h, 02h
		db	 8Fh, 2Fh, 15h, 00h, 06h, 39h
		db	0D1h, 02h,0DAh, 23h, 15h, 00h
		db	 06h, 39h,0D1h, 08h, 02h, 2Eh
		db	 28h, 15h, 00h, 02h,0DAh, 23h
		db	 15h, 00h, 02h,0C6h, 21h, 15h
		db	 00h, 02h, 2Eh, 28h, 15h, 00h
		db	 02h,0DAh, 23h, 15h, 00h, 02h
		db	 2Eh, 28h, 15h, 00h, 02h, 40h
		db	 2Dh, 15h, 00h, 02h, 8Fh, 2Fh
		db	 15h, 00h, 02h, 92h, 35h, 15h
		db	 00h, 02h, 8Fh, 2Fh, 15h, 00h
		db	 02h, 40h, 2Dh, 15h, 00h, 02h
		db	 2Eh, 28h, 15h, 00h, 02h,0E4h
		db	 25h, 15h, 00h, 02h,0C6h, 21h
		db	 15h, 00h, 02h,0C9h, 1Ah, 15h
		db	 00h, 02h, 84h, 16h, 15h, 00h
		db	 02h, 31h, 19h, 15h, 00h, 02h
		db	0C9h, 1Ah, 15h, 00h, 02h, 11h
		db	 1Eh, 15h, 00h, 02h,0C6h, 21h
		db	 15h, 00h, 08h, 04h, 0Eh, 00h
		db	 04h, 07h, 00h, 08h, 04h, 15h
		db	 00h, 06h, 39h,0D1h, 04h, 15h
		db	 00h, 06h, 39h,0D1h, 08h, 02h
		db	0D6h, 38h, 2Ah, 00h, 02h, 40h
		db	 2Dh, 15h, 00h, 06h, 39h,0D1h
		db	 04h, 15h, 00h, 06h, 39h,0D1h
		db	 06h, 40h,0D1h, 06h, 40h,0D1h
		db	 02h, 2Eh, 28h, 0Eh, 00h, 04h
		db	 15h, 00h, 02h, 2Eh, 28h, 07h
		db	 00h, 04h, 07h, 00h, 04h, 07h
		db	 00h, 04h, 07h, 00h, 04h, 07h
		db	 00h, 04h, 07h, 00h, 04h, 07h
		db	 00h, 06h, 93h,0D0h, 02h,0C9h
		db	 1Ah, 15h, 00h, 06h, 39h,0D1h
		db	 02h, 31h, 19h, 15h, 00h, 06h
		db	 39h,0D1h, 02h,0C7h, 17h, 15h
		db	 00h, 06h, 39h,0D1h, 02h, 84h
		db	 16h, 15h, 00h, 06h, 39h,0D1h
		db	 02h, 00h, 14h, 15h, 00h, 06h
		db	 39h,0D1h, 02h, 84h, 16h, 15h
		db	 00h, 06h, 39h,0D1h, 02h,0C7h
		db	 17h, 15h, 00h, 06h, 39h,0D1h
		db	 02h,0B4h, 47h, 15h, 00h, 06h
		db	 39h,0D1h, 06h, 93h,0D0h, 04h
		db	 0Eh, 00h, 04h, 15h, 00h, 04h
		db	 07h, 00h, 04h, 15h, 00h, 04h
		db	 0Eh, 00h, 04h, 15h, 00h, 04h
		db	 07h, 00h, 04h, 0Eh, 00h, 04h
		db	 15h, 00h, 02h,0DAh, 23h, 07h
		db	 00h, 02h,0E4h, 25h, 15h, 00h
		db	 06h,0D4h,0D0h, 02h,0DAh, 23h
		db	 15h, 00h, 02h, 2Eh, 28h, 15h
		db	 00h, 02h, 40h, 2Dh, 15h, 00h
		db	 02h, 8Fh, 2Fh, 15h, 00h, 02h
		db	 92h, 35h, 15h, 00h, 02h, 8Fh
		db	 2Fh, 15h, 00h, 02h, 40h, 2Dh
		db	 15h, 00h, 02h, 2Eh, 28h, 15h
		db	 00h, 02h,0DAh, 23h, 15h, 00h
		db	 02h, 11h, 1Eh, 15h, 00h, 02h
		db	0ECh, 1Fh, 15h, 00h, 02h,0E4h
		db	 25h, 15h, 00h, 06h,0D4h,0D0h
		db	 0Ah, 66h,0D1h, 06h, 8Fh,0CFh
		db	 02h,0DBh, 11h, 0Eh, 00h, 02h
		db	 5Ah, 0Dh, 0Eh, 00h, 02h,0E9h
		db	 08h, 0Eh, 00h, 02h, 7Eh, 07h
		db	 69h, 00h, 02h,0ADh, 06h, 0Eh
		db	 00h, 02h,0E9h, 08h, 1Ch, 00h
		db	 02h, 00h, 0Ah, 15h, 00h, 02h
		db	 3Bh, 0Bh, 0Eh, 00h, 02h, 00h
		db	 0Ah, 15h, 00h, 02h,0E3h, 0Bh
		db	 1Ch, 00h, 02h, 3Bh, 0Bh, 15h
		db	 00h, 02h, 00h, 0Ah, 0Eh
loc_D273:
		add	[bp+si],al
		jmp	$+1C0Bh
		db	 00h, 06h, 8Fh,0CFh, 06h, 12h
		db	0D0h, 06h,0BBh,0CFh, 02h, 74h
		db	 04h, 5Bh, 00h, 06h, 12h,0D0h
		db	 06h,0BBh,0CFh, 02h, 74h, 04h
		db	 5Bh, 00h, 0Ah, 35h,0D2h, 02h
		db	 84h, 16h, 2Ah, 00h, 02h,0DAh
		db	 23h, 2Ah, 00h, 04h,0E0h, 00h
		db	 02h,0DAh, 23h, 15h, 00h, 04h
		db	 07h, 00h, 02h,0E4h, 25h, 0Eh
		db	 00h, 02h,0DAh, 23h, 1Ch, 00h
		db	 06h, 47h,0D0h, 04h, 2Ah, 00h
		db	 02h, 98h, 0Ch, 07h, 00h, 02h
		db	0E3h, 0Bh, 07h, 00h, 02h, 3Bh
		db	 0Bh, 07h, 00h, 02h, 97h, 0Ah
		db	 07h, 00h, 02h, 00h, 0Ah, 07h
		db	 00h, 02h, 74h, 09h, 07h, 00h
		db	 02h,0E9h, 08h, 54h, 00h, 02h
		db	 00h, 0Ah, 2Ah, 00h, 02h, 69h
		db	 08h, 2Ah, 00h, 02h,0E3h, 0Bh
		db	 2Ah, 00h, 02h, 2Ah, 0Eh, 2Ah
		db	 00h, 06h, 47h,0D0h, 04h, 0Eh
		db	 00h, 02h,0C7h, 17h, 0Eh, 00h
		db	 04h, 07h, 00h, 02h,0C7h, 17h
		db	 07h, 00h, 02h, 00h, 14h, 0Eh
		db	 00h, 04h, 07h, 00h, 02h, 00h
		db	 14h, 0Eh, 00h, 02h,0DBh, 11h
		db	 15h, 00h, 02h, 00h, 14h, 07h
		db	 00h, 02h,0F2h, 12h, 0Eh, 00h
		db	 02h,0DBh, 11h, 15h, 00h, 04h
		db	 1Ch, 00h, 06h, 40h,0D1h, 06h
		db	 40h,0D1h, 06h, 40h,0D1h, 06h
		db	 40h,0D1h, 06h, 40h,0D1h, 06h
		db	 40h,0D1h, 06h, 40h,0D1h, 06h
		db	 40h,0D1h, 06h, 40h,0D1h, 06h
		db	 40h,0D1h, 06h, 40h,0D1h, 06h
		db	 40h,0D1h, 06h, 40h,0D1h, 04h
		db	 0Eh, 00h, 0Ah,0A2h,0D2h,0DDh
		db	 00h, 00h, 00h,0DDh,0FFh
data_D35B	db	32h
		db	 32h, 32h, 32h, 32h,0FFh, 06h
		db	 80h, 07h, 01h, 08h, 20h, 04h
		db	 10h, 04h, 40h, 02h, 40h, 04h
		db	 01h, 00h, 07h, 01h, 00h, 00h
		db	9
data_D375	db	0Ah
		db	 7Fh, 81h, 01h, 08h, 08h, 01h
		db	 00h, 01h, 0Bh, 0Ch, 00h, 00h
		db	 00h, 0Ah, 0Ah, 00h, 7Fh, 14h
		db	 0Dh, 0Eh, 00h, 00h, 04h, 11h
		db	 13h, 00h, 00h, 04h, 0Fh, 10h
		db	 00h, 00h, 0Ah, 14h, 14h, 00h
		db	 00h, 05h, 15h, 16h, 00h, 00h
		db	 01h
data_D3A1	db	17h
		db	 1Eh,0FFh, 00h, 00h, 20h
data_D3A7	db	21h
		db	 81h, 81h, 01h, 1Fh, 1Fh,0FFh
		db	 00h, 01h
data_D3B0	db	22h
		db	 23h, 00h, 00h, 00h, 21h, 21h
		db	 00h, 7Fh, 14h, 24h, 25h, 00h
		db	 00h, 04h, 28h, 2Ch, 00h, 00h
		db	 04h, 26h, 27h, 00h, 00h, 0Ah
		db	 2Dh, 2Dh, 00h, 00h, 05h, 2Eh
		db	 2Fh, 00h
data_D3D1	db	0
		db	 00h, 28h, 50h,0FFh, 02h, 2Ah
		db	 52h,0FFh,0FFh, 00h
data_D3DC	db	1
		db	 02h,0FFh, 01h, 05h, 11h, 0Dh
		db	 23h, 05h, 0Fh, 17h, 07h, 2Eh
		db	 1Ah, 0Bh, 1Ah, 05h, 05h, 1Bh
		db	 24h, 0Ah, 20h, 18h, 09h, 25h
		db	 0Ch, 05h, 2Bh, 0Ah, 04h, 37h
		db	 04h, 08h, 39h, 24h, 09h, 3Ah
		db	 1Eh, 05h, 4Eh, 21h, 11h,0FFh
data_D407	db	0D2h
		db	 20h, 97h, 20h,0BFh, 20h,0D2h
		db	 20h,0D2h, 20h, 16h, 2Dh, 16h
		db	 2Dh, 80h, 18h,0D2h, 20h,0D2h
		db	 20h,0D2h, 20h,0C7h, 22h, 16h
		db	 2Dh, 16h, 2Dh, 16h, 2Dh,0E0h
		db	 1Dh, 16h, 2Dh, 16h, 2Dh,0D2h
		db	 20h, 16h, 2Dh,0D2h, 20h, 86h
		db	 23h, 16h, 2Dh, 45h, 1Ah, 9Fh
		db	 19h, 16h, 2Dh, 16h, 2Dh,0D3h
		db	 20h, 0Eh, 25h, 13h, 20h, 5Ah
		db	 17h,0E6h, 17h, 16h, 2Dh,0DBh
		db	 1Bh, 3Fh, 1Bh, 16h, 2Dh, 12h
		db	 1Ah,0CFh, 15h, 18h, 17h, 16h
		db	 2Dh, 16h, 2Dh, 16h, 2Dh, 16h
		db	 2Dh, 16h, 2Dh, 16h, 2Dh, 16h
		db	 2Dh,0F5h
		db	20h
data_D465	dw	316h
		db	 0Ah, 01h, 0Dh, 01h, 0Ah, 05h
		db	 10h, 03h, 1Ah, 03h, 03h, 02h
		db	 18h, 03h, 0Eh, 01h, 1Ah, 03h
		db	 08h, 04h, 0Ch, 03h, 0Bh, 02h
		db	 0Bh, 02h, 18h, 03h, 0Eh, 03h
		db	 18h, 03h, 09h, 02h, 10h, 02h
		db	 15h, 02h, 08h, 06h, 11h, 02h
		db	 14h, 01h, 11h, 04h, 0Fh, 02h
		db	 0Ch, 03h, 05h, 03h, 0Bh, 02h
		db	 0Fh, 02h, 0Bh, 02h, 18h, 03h
		db	 18h, 03h, 17h, 02h, 16h, 03h
		db	 03h, 02h, 06h, 01h, 04h, 01h
		db	 0Ch, 03h, 18h, 03h, 19h, 03h
		db	 07h, 01h, 12h, 03h, 03h, 01h
		db	 0Ch, 03h, 18h, 03h, 01h, 01h
		db	 01h, 01h
data_D4C3	db	6Dh
		db	0D5h, 7Fh,0D5h, 9Ch,0D5h,0B2h
		db	0D5h,0C8h,0D5h,0DCh,0D5h, 02h
		db	0D6h, 1Fh,0D6h, 45h,0D6h, 69h
		db	0D6h, 88h,0D6h,0A3h,0D6h,0C0h
		db	0D6h,0DDh,0D6h,0EEh,0D6h, 00h
		db	0D7h, 26h,0D7h, 41h,0D7h, 5Ch
		db	0D7h, 80h,0D7h,0AFh,0D7h,0CCh
		db	0D7h,0E7h,0D7h, 02h,0D8h, 1Fh
		db	0D8h, 33h,0D8h, 50h,0D8h, 76h
		db	0D8h, 97h,0D8h,0B4h,0D8h,0CDh
		db	0D8h,0E8h,0D8h,0FAh,0D8h, 0Ch
		db	0D9h, 19h,0D9h, 36h,0D9h, 43h
		db	0D9h, 67h,0D9h, 84h,0D9h,0A1h
		db	0D9h,0B5h,0D9h,0D2h,0D9h,0E8h
		db	0D9h, 0Ch,0DAh, 22h,0DAh, 34h
		db	0DAh, 4Fh,0DAh, 6Ah,0DAh, 97h
		db	0DAh,0BBh,0DAh,0E8h,0DAh, 0Ch
		db	0DBh, 37h,0DBh, 5Bh,0DBh, 78h
		db	0DBh, 9Eh,0DBh,0BBh,0DBh,0CDh
		db	0DBh,0F5h,0DBh, 0Bh,0DCh, 1Dh
		db	0DCh, 36h,0DCh, 51h,0DCh, 6Ch
		db	0DCh, 87h,0DCh,0ABh,0DCh,0BFh
		db	0DCh,0D1h,0DCh,0F5h,0DCh, 10h
		db	0DDh, 34h,0DDh, 46h,0DDh, 61h
		db	0DDh, 85h,0DDh, 97h,0DDh,0A9h
		db	0DDh,0BBh,0DDh,0CDh,0DDh,0EFh
		db	0DDh, 13h,0DEh, 2Ch,0DEh, 3Eh
		db	0DEh, 52h,0DEh, 64h,0DEh, 64h
		db	0DEh, 50h,0FFh, 01h,0FFh, 00h
		db	 01h, 01h, 0Dh, 00h, 00h, 18h
		db	 00h, 06h, 7Fh,0DEh, 01h,0FBh
		db	 1Bh, 00h, 49h, 42h,0FFh, 01h
		db	 02h, 03h, 1Dh, 00h, 00h, 0Eh
		db	 00h, 0Ch, 00h, 00h, 04h, 0Dh
		db	 00h, 00h, 14h, 00h, 06h, 7Fh
		db	0DEh, 02h,0FBh, 1Bh,0F2h, 23h
		db	 42h,0FFh, 03h,0FFh, 02h, 01h
		db	 02h, 13h, 00h, 00h, 23h, 00h
		db	 01h, 95h,0DEh, 03h, 3Dh, 15h
		db	 93h, 16h, 75h, 16h, 02h,0FFh
		db	 04h,0FFh, 03h, 01h, 02h, 13h
		db	 00h, 00h, 12h, 00h, 01h, 95h
		db	0DEh, 03h, 3Dh, 15h, 6Bh, 16h
		db	 93h, 16h, 03h, 4Ah, 05h,0FFh
		db	 04h, 01h, 03h, 13h, 00h, 00h
		db	 08h, 00h, 02h, 95h,0DEh, 02h
		db	0FBh, 1Bh, 93h, 16h, 04h,0FFh
		db	 06h,0FFh, 05h, 03h, 01h, 13h
		db	 00h, 00h, 03h, 00h, 02h, 95h
		db	0DEh, 02h, 07h, 00h, 00h, 1Ch
		db	0A0h, 0Ah, 4Fh,0E1h, 03h, 2Dh
		db	 00h, 00h, 25h, 00h, 05h,0E0h
		db	0DEh, 02h, 3Dh, 15h, 93h, 16h
		db	 05h,0FFh, 07h,0FFh, 06h, 02h
		db	 01h, 10h, 00h, 00h, 12h, 60h
		db	 10h,0AEh,0DEh, 02h, 2Ch, 00h
		db	 00h, 03h, 00h, 01h, 44h,0DFh
		db	 02h, 7Fh, 16h, 8Eh, 2Ah, 06h
		db	0FFh, 08h,0FFh, 07h, 03h, 01h
		db	 1Fh, 00h, 00h, 12h, 60h, 10h
		db	 4Bh,0E1h, 02h, 10h, 00h, 00h
		db	 12h, 60h, 05h,0AEh,0DEh, 03h
		db	 2Ch, 00h, 00h, 15h, 00h, 09h
		db	 44h,0DFh, 02h, 7Fh, 16h, 8Eh
		db	 2Ah, 07h,0FFh, 09h,0FFh, 08h
		db	 03h, 01h, 1Fh, 00h, 00h, 12h
		db	 60h, 07h, 4Bh,0E1h, 02h, 2Ch
		db	 00h, 00h, 07h, 00h, 01h, 44h
		db	0DFh, 03h, 2Ch, 00h, 00h, 1Bh
		db	 00h, 01h, 44h,0DFh, 01h, 8Eh
		db	 2Ah, 08h,0FFh, 0Dh, 0Ah, 09h
		db	 02h, 01h, 10h, 00h, 00h, 19h
		db	 60h, 05h,0AEh,0DEh, 02h, 2Ch
		db	 00h, 00h, 07h, 00h, 09h, 44h
		db	0DFh, 03h,0FBh, 1Bh, 7Fh, 16h
		db	 8Eh, 2Ah,0FFh, 09h, 3Ch, 0Bh
		db	 0Ah, 02h, 01h, 29h, 00h, 00h
		db	 0Ah, 40h, 04h,0F9h,0DEh, 00h
		db	 2Ch, 00h, 00h, 1Bh, 00h, 01h
		db	 44h,0DFh, 01h,0FBh, 1Bh,0FFh
		db	 0Ah, 0Ch,0FFh, 0Bh, 02h, 02h
		db	 13h, 00h, 00h, 03h, 00h, 02h
		db	 95h,0DEh, 04h, 2Dh, 00h, 00h
		db	 1Fh, 00h, 0Ah,0E0h,0DEh, 02h
		db	0FBh, 1Bh, 93h, 16h, 0Bh, 3Ch
		db	0FFh,0FFh, 0Ch, 02h, 01h, 0Dh
		db	 00h, 00h, 13h,0A0h, 0Dh, 7Fh
		db	0DEh, 03h, 13h, 00h, 00h, 23h
		db	 00h, 02h, 95h,0DEh, 02h, 93h
		db	 16h, 89h, 16h, 09h,0FFh, 3Eh
		db	 3Ch, 0Dh, 00h, 05h,0F2h, 23h
		db	 7Fh, 16h, 6Bh, 16h, 3Dh, 15h
		db	 8Eh, 2Ah, 15h,0FFh,0FFh, 2Fh
		db	 43h, 01h, 01h, 0Dh, 00h, 00h
		db	 09h,0A0h, 11h, 7Fh,0DEh, 01h
		db	0FBh, 1Bh, 4Bh,0FFh, 10h,0FFh
		db	 0Fh, 03h, 01h, 0Dh, 00h, 00h
		db	 0Fh,0A0h, 06h, 7Fh,0DEh, 03h
		db	 1Dh, 00h, 00h, 0Fh, 00h, 0Bh
		db	 00h, 00h, 04h, 1Dh, 00h, 00h
		db	 1Eh, 00h, 0Ah, 00h, 00h, 02h
		db	 5Fh, 21h,0F2h, 23h, 0Fh,0FFh
		db	 12h, 21h, 10h, 02h, 01h, 1Dh
		db	 00h, 00h, 1Bh, 00h, 05h, 00h
		db	 00h, 02h, 0Fh, 00h, 00h, 0Dh
		db	 00h, 12h, 0Fh, 00h, 01h, 5Fh
		db	 21h, 4Ah,0FFh, 13h,0FFh, 11h
		db	 02h, 01h, 0Fh, 00h, 00h, 1Bh
		db	 00h, 12h, 00h, 00h, 02h, 1Dh
		db	 00h, 00h, 0Ah, 00h, 05h, 00h
		db	 00h, 01h, 5Fh, 21h, 10h,0FFh
		db	 4Ch,0FFh, 12h, 03h, 01h, 19h
		db	 00h, 00h, 08h, 80h, 07h, 8Ah
		db	0DEh, 02h, 19h, 00h, 00h, 12h
		db	 80h, 07h, 8Ah,0DEh, 03h, 1Dh
		db	 00h, 00h, 0Fh, 00h, 05h, 00h
		db	 00h, 01h, 5Fh, 21h, 11h,0FFh
		db	 14h,0FFh, 13h, 04h, 01h, 19h
		db	 00h, 00h, 08h, 80h, 09h, 8Ah
		db	0DEh, 02h, 19h, 00h, 00h, 1Ah
		db	 80h, 07h, 8Ah,0DEh, 03h, 1Dh
		db	 00h, 00h, 15h, 00h, 05h, 00h
		db	 00h, 04h, 19h, 00h, 00h, 07h
		db	0A0h, 10h, 8Ah,0DEh, 02h
data_D7AB	db	5Fh
		db	 21h, 75h, 16h, 13h,0FFh, 4Bh
		db	0FFh, 14h, 02h, 01h, 19h, 00h
		db	 00h, 18h, 80h, 07h, 8Ah,0DEh
		db	 02h, 1Dh, 00h, 00h, 15h, 00h
		db	 06h, 00h, 00h, 02h, 5Fh, 21h
		db	 75h, 16h, 4Eh,0FFh, 0Eh,0FFh
		db	 15h, 02h, 01h, 19h, 00h, 00h
		db	 11h, 80h, 10h, 8Ah,0DEh, 02h
		db	 0Fh
		db	 00h, 00h, 0Ch, 00h, 12h, 00h
		db	 00h, 01h, 5Fh, 21h, 1Fh,0FFh
		db	 17h,0FFh, 16h, 02h, 01h, 1Eh
		db	 00h, 00h, 1Ah, 60h, 04h, 4Bh
		db	0E1h, 02h, 2Dh, 00h, 00h, 07h
		db	 00h, 08h,0E0h,0DEh, 01h, 75h
		db	 16h, 16h,0FFh, 21h,0FFh, 17h
		db	 02h, 02h, 1Eh, 03h, 00h, 1Bh
		db	 60h, 04h, 4Bh,0E1h, 03h, 2Dh
		db	 00h, 00h, 20h, 00h, 09h,0E0h
		db	0DEh, 02h, 5Fh, 21h, 75h, 16h
		db	 40h, 4Bh, 19h,0FFh, 18h, 01h
		db	 03h, 13h, 00h, 00h, 0Bh, 00h
		db	 02h, 95h,0DEh, 02h,0FBh, 1Bh
		db	 93h, 16h, 18h,0FFh, 1Ah,0FFh
		db	 19h, 02h, 01h, 13h, 00h, 00h
		db	 08h, 00h, 02h, 95h,0DEh, 02h
		db	 27h, 00h, 00h, 1Ch, 00h, 09h
		db	 12h,0DFh, 02h, 5Fh, 21h, 3Dh
		db	 15h, 19h,0FFh, 1Eh, 1Bh, 1Ah
		db	 03h, 01h, 27h, 00h, 00h, 17h
		db	 00h, 10h, 12h,0DFh, 02h, 27h
		db	 00h, 00h, 1Ah, 00h, 02h, 12h
		db	0DFh, 03h, 20h, 00h, 00h, 0Ah
		db	 40h, 09h, 2Bh,0DFh, 02h,0FBh
		db	 1Bh,0F2h, 23h, 1Ch, 1Ah, 1Dh
		db	0FFh, 1Bh, 02h, 01h, 27h, 00h
		db	 00h, 08h, 00h, 09h, 12h,0DFh
		db	 02h, 20h, 00h, 00h, 18h, 40h
		db	 0Fh, 2Bh,0DFh, 04h, 5Fh, 21h
		db	0FBh, 1Bh,0F2h, 23h, 89h, 16h
		db	0FFh, 19h, 1Bh,0FFh, 1Ch, 02h
		db	 01h, 13h, 00h, 00h, 08h, 00h
		db	 02h, 95h,0DEh, 02h, 20h, 00h
		db	 00h, 1Eh, 40h, 09h, 2Bh,0DFh
		db	 02h, 5Fh, 21h, 93h, 16h, 1Bh
		db	 1Eh, 20h,0FFh, 1Dh, 02h, 01h
		db	 27h, 00h, 00h, 07h, 00h, 07h
		db	 12h,0DFh, 02h, 20h, 00h, 00h
		db	 17h, 40h, 0Fh, 2Bh,0DFh, 00h
		db	 1Ah,0FFh, 1Fh, 1Dh, 1Eh, 02h
		db	 01h, 20h, 00h, 00h, 1Dh, 40h
		db	 06h, 2Bh,0DFh, 02h, 20h, 00h
		db	 00h, 07h, 40h, 09h, 2Bh,0DFh
		db	 01h, 5Fh, 21h, 1Eh,0FFh, 16h
		db	 20h, 1Fh, 01h, 01h, 20h, 00h
		db	 00h, 19h, 40h, 07h, 2Bh,0DFh
		db	 01h, 5Fh, 21h, 1Dh, 1Fh,0FFh
		db	0FFh, 20h, 01h, 02h, 20h, 00h
		db	 00h, 0Ah, 40h, 07h, 2Bh,0DFh
		db	 01h,0F2h, 23h, 17h, 10h, 43h
		db	0FFh, 21h, 00h, 03h, 5Fh, 21h
		db	 6Bh, 16h, 93h, 16h, 45h,0FFh
		db	 23h,0FFh, 22h, 02h, 02h, 13h
		db	 00h, 00h, 08h, 00h, 02h, 95h
		db	0DEh, 03h, 2Dh, 00h, 00h, 1Ch
		db	 00h, 01h,0E0h,0DEh, 02h, 3Dh
		db	 15h, 75h, 16h, 22h, 4Ch, 24h
		db	0FFh, 23h, 00h, 03h,0FBh, 1Bh
		db	 6Bh, 16h, 89h, 16h, 23h,0FFh
		db	 25h,0FFh, 24h, 03h, 01h, 0Dh
		db	 00h, 00h, 10h,0A0h, 11h, 7Fh
		db	0DEh, 03h, 2Dh, 00h, 00h, 0Ah
		db	 00h, 01h,0E0h,0DEh, 04h, 2Dh
		db	 00h, 00h, 19h, 00h, 01h,0E0h
		db	0DEh, 01h, 75h, 16h, 24h,0FFh
		db	 26h,0FFh, 25h, 02h, 01h, 13h
		db	 00h, 00h, 23h, 00h, 02h, 95h
		db	0DEh, 02h, 0Dh, 00h, 00h, 0Bh
		db	0A0h, 11h, 7Fh,0DEh, 02h, 89h
		db	 16h,0F2h, 23h, 25h,0FFh, 27h
		db	0FFh, 26h, 02h, 01h, 13h, 00h
		db	 00h, 08h, 00h, 02h, 95h,0DEh
		db	 02h, 2Dh, 00h, 00h, 0Ah, 00h
		db	 09h,0E0h,0DEh, 02h, 93h, 16h
		db	 89h, 16h, 26h,0FFh, 28h,0FFh
		db	 27h, 01h, 03h, 13h, 00h, 00h
		db	 08h, 00h, 02h, 95h,0DEh, 02h
		db	 5Fh, 21h,0C2h, 29h, 27h,0FFh
		db	 29h,0FFh, 28h, 02h, 01h, 13h
		db	 00h, 00h, 08h, 00h, 02h, 95h
		db	0DEh, 02h, 2Dh, 00h, 00h, 10h
		db	 00h, 04h,0E0h,0DEh, 02h, 5Fh
		db	 21h,0C2h, 29h, 28h,0FFh, 2Ah
		db	0FFh, 29h, 01h, 03h, 13h, 00h
		db	 00h, 06h, 00h, 00h, 95h,0DEh
		db	 03h, 5Fh, 21h,0C2h, 29h, 93h
		db	 16h, 29h,0FFh, 2Bh,0FFh, 2Ah
		db	 03h, 01h, 13h, 00h, 00h, 08h
		db	 00h, 02h, 95h,0DEh, 02h, 07h
		db	 00h, 00h, 1Ah,0A0h, 0Ch, 4Fh
		db	0E1h, 03h, 0Dh, 00h, 00h, 08h
		db	0A0h, 11h, 7Fh,0DEh, 01h, 93h
		db	 16h, 2Ah,0FFh, 46h,0FFh, 2Bh
		db	 01h, 03h, 13h, 00h, 00h, 11h
		db	 00h, 02h, 95h,0DEh, 03h, 3Dh
		db	 15h, 89h, 16h,0F2h, 23h, 48h
		db	0FFh, 2Dh,0FFh, 2Ch, 01h, 01h
		db	 26h, 00h, 00h, 14h, 60h, 0Bh
		db	 4Bh,0E1h, 01h, 5Ah, 27h, 2Ch
		db	0FFh, 2Eh,0FFh, 2Dh, 02h, 01h
		db	 18h, 01h, 00h, 01h, 00h, 01h
		db	 00h, 00h, 02h, 29h, 00h, 00h
		db	 16h, 40h, 0Eh,0F9h,0DEh, 01h
		db	 6Bh, 16h, 2Dh,0FFh, 2Fh,0FFh
		db	 2Eh, 02h, 01h, 29h, 00h, 00h
		db	 08h, 40h, 0Eh,0F9h,0DEh, 02h
		db	 29h, 00h, 00h, 15h, 40h, 0Eh
		db	0F9h,0DEh, 01h,0F2h, 23h, 2Eh
		db	 0Eh, 30h,0FFh, 2Fh, 04h, 01h
		db	 29h, 00h, 00h, 1Ah, 40h, 09h
		db	0F9h,0DEh, 02h, 18h, 00h, 00h
		db	 22h, 00h, 01h, 00h, 00h, 03h
		db	 18h, 00h, 00h, 00h, 00h, 01h
		db	 00h, 00h, 04h, 10h, 00h, 00h
		db	 23h, 60h, 10h,0AEh,0DEh, 01h
		db	0FBh, 1Bh, 2Fh,0FFh, 31h,0FFh
		db	 30h, 03h, 01h, 29h, 00h, 00h
		db	 09h, 40h, 09h,0F9h,0DEh, 02h
		db	 29h, 00h, 00h, 1Ah, 40h, 09h
		db	0F9h,0DEh, 03h, 18h, 00h, 00h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 5Ah, 27h, 30h,0FFh, 32h,0FFh
		db	 31h, 04h, 01h, 26h, 00h, 00h
		db	 14h, 60h, 10h, 4Bh,0E1h, 02h
		db	 10h, 00h, 00h, 20h, 60h, 05h
		db	0AEh,0DEh, 03h, 29h, 00h, 00h
		db	 0Bh, 40h, 09h,0F9h,0DEh, 04h
		db	 18h, 00h, 00h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 5Ah, 27h, 31h
		db	0FFh, 33h,0FFh, 32h, 03h, 01h
		db	 26h, 00h, 00h, 14h, 60h, 10h
		db	 4Bh,0E1h, 02h, 18h, 00h, 00h
		db	 06h, 00h, 01h, 00h, 00h, 03h
		db	 05h, 00h, 00h, 23h, 00h, 07h
		db	0C7h,0DEh, 01h, 5Ah, 27h, 32h
		db	0FFh, 34h,0FFh, 33h, 04h, 01h
		db	 26h, 00h, 00h, 0Eh, 60h, 10h
		db	 4Bh,0E1h, 02h, 05h, 00h, 00h
		db	 06h, 00h, 0Bh,0C7h,0DEh, 03h
		db	 05h, 00h, 00h, 13h, 00h, 03h
		db	0C7h,0DEh, 04h, 05h, 00h, 00h
		db	 1Fh, 00h, 0Bh,0C7h,0DEh, 00h
		db	 33h,0FFh, 35h,0FFh, 34h, 03h
		db	 01h, 26h, 00h, 00h, 15h, 60h
		db	 10h, 4Bh,0E1h, 02h, 05h, 00h
		db	 00h, 06h, 00h, 0Bh,0C7h,0DEh
		db	 03h, 05h, 00h, 00h, 0Ch, 00h
		db	 03h,0C7h,0DEh, 01h, 5Ah, 27h
		db	 34h,0FFh, 36h,0FFh, 35h, 02h
		db	 01h, 0Fh, 00h, 00h, 12h, 00h
		db	 12h, 00h, 00h, 02h, 20h, 00h
		db	 00h, 20h, 40h, 01h, 2Bh,0DFh
		db	 02h, 5Fh, 21h, 5Ah, 27h, 35h
		db	 37h,0FFh,0FFh, 36h, 03h, 01h
		db	 20h, 00h, 00h, 18h, 40h, 01h
		db	 2Bh,0DFh, 02h, 0Fh, 00h, 00h
		db	 0Ch, 00h, 12h, 00h, 00h, 03h
		db	 10h, 00h, 00h, 16h, 60h, 0Ah
		db	0AEh,0DEh, 02h, 5Fh, 21h,0FBh
		db	 1Bh,0FFh, 38h,0FFh, 36h, 37h
		db	 02h, 01h, 0Fh, 00h, 00h, 0Bh
		db	 00h, 12h, 00h, 00h, 02h, 1Dh
		db	 00h, 00h, 10h, 00h, 05h, 00h
		db	 00h, 02h,0FBh, 1Bh,0F2h, 23h
		db	0FFh, 39h,0FFh, 37h, 38h, 01h
		db	 01h, 19h, 00h, 00h, 05h, 80h
		db	 0Eh, 8Ah,0DEh, 01h,0FBh, 1Bh
		db	 3Ah,0FFh, 3Dh, 38h, 39h, 03h
		db	 01h, 0Fh, 00h, 00h, 06h, 00h
		db	 12h, 00h, 00h, 02h, 0Fh, 00h
		db	 00h, 12h, 00h, 12h, 00h, 00h
		db	 03h, 19h, 00h, 00h, 07h, 80h
		db	 04h, 8Ah,0DEh, 03h,0FBh, 1Bh
		db	 5Ah, 27h,0F2h, 23h, 3Bh,0FFh
		db	 39h,0FFh, 3Ah, 01h, 01h, 19h
		db	 00h, 00h, 12h, 80h, 07h, 8Ah
		db	0DEh, 03h, 5Fh, 21h, 9Eh, 21h
		db	0F2h, 23h,0FFh,0FFh, 3Ah,0FFh
		db	 3Bh, 01h, 01h, 1Ch, 00h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 01h
		db	 5Fh, 21h, 0Ah, 0Dh,0FFh, 0Ch
		db	 3Ch, 02h, 01h, 1Fh, 00h, 00h
		db	 0Ah, 60h, 06h, 4Bh,0E1h, 02h
		db	 1Dh, 00h, 00h, 22h, 00h, 0Dh
		db	 00h, 00h, 00h, 39h,0FFh, 49h
		db	0FFh, 3Dh, 02h, 01h, 0Fh, 00h
		db	 00h, 19h, 00h, 12h, 00h, 00h
		db	 02h, 19h, 00h, 00h, 14h, 80h
		db	 0Ch, 8Ah,0DEh, 01h, 5Fh, 21h
		db	 0Dh,0FFh, 3Fh,0FFh, 3Eh, 02h
		db	 02h, 14h, 00h, 00h, 15h, 80h
		db	 07h, 00h, 00h, 01h, 26h, 00h
		db	 00h, 1Eh, 60h, 10h, 4Bh,0E1h
		db	 01h,0FCh, 28h, 3Eh,0FFh, 40h
		db	0FFh, 3Fh, 02h, 02h, 14h, 01h
		db	 00h, 0Ah, 80h, 06h, 00h, 00h
		db	 01h, 14h, 01h, 00h, 19h, 80h
		db	 06h, 00h, 00h, 01h, 76h, 29h
		db	 3Fh,0FFh, 18h,0FFh, 40h, 03h
		db	 02h, 14h, 01h, 00h, 0Bh, 80h
		db	 07h, 00h, 00h, 01h, 26h, 00h
		db	 00h, 0Ah, 60h, 10h, 4Bh,0E1h
		db	 03h, 10h, 00h, 00h, 18h, 60h
		db	 0Ah,0AEh,0DEh, 01h,0FCh, 28h
		db	 03h,0FFh,0FFh,0FFh, 41h, 01h
		db	 03h, 26h, 00h, 00h, 06h, 60h
		db	 10h, 4Bh,0E1h, 02h, 5Ah, 27h
		db	0D2h, 2Ah, 01h,0FFh, 02h,0FFh
		db	 42h, 01h, 02h, 1Ch, 00h, 00h
		db	 0Fh, 00h, 0Fh, 00h, 00h, 01h
		db	0E2h, 26h, 21h,0FFh, 44h,0FFh
		db	 3Eh, 03h, 02h, 14h, 01h, 00h
		db	 15h, 80h, 07h, 00h, 00h, 01h
		db	 10h, 00h, 00h, 1Ah, 60h, 10h
		db	0AEh,0DEh, 02h, 20h, 00h, 00h
		db	 14h, 40h, 00h, 2Bh,0DFh, 01h
		db	0FCh, 28h, 43h,0FFh, 45h,0FFh
		db	 3Fh, 02h, 02h, 14h, 01h, 00h
		db	 0Ah, 80h, 06h, 00h, 00h, 01h
		db	 14h, 01h, 00h, 19h, 80h, 06h
		db	 00h, 00h, 01h, 76h, 29h, 44h
		db	0FFh, 22h,0FFh, 40h, 03h, 02h
		db	 14h, 02h, 00h, 0Bh, 80h, 07h
		db	 00h, 00h, 01h, 26h, 00h, 00h
		db	 0Ah, 60h, 10h, 4Bh,0E1h, 03h
		db	 10h, 00h, 00h, 18h, 60h, 0Ah
		db	0AEh,0DEh, 01h,0FCh, 28h, 2Bh
		db	0FFh, 47h,0FFh, 3Eh, 01h, 02h
		db	 14h, 02h, 00h, 15h, 80h, 07h
		db	 00h, 00h, 01h,0FCh
		db	28h
data_DD46	db	46h
		db	0FFh, 48h,0FFh, 3Fh, 02h, 02h
		db	 14h, 01h, 00h, 0Ah, 80h, 06h
		db	 00h, 00h, 01h, 14h, 01h, 00h
		db	 19h, 80h, 06h, 00h, 00h, 01h
		db	 76h, 29h, 47h,0FFh, 2Ch,0FFh
		db	 40h, 03h, 02h, 14h, 03h, 00h
		db	 0Bh, 80h, 07h, 00h, 00h, 01h
		db	 26h, 00h, 00h, 0Ah, 60h, 10h
		db	 4Bh,0E1h, 03h, 10h, 00h, 00h
		db	 18h, 60h, 0Ah,0AEh,0DEh, 01h
		db	0FCh, 28h, 3Dh,0FFh, 4Fh, 01h
		db	 0Eh, 01h, 01h, 19h, 00h, 00h
		db	 09h, 80h, 11h, 8Ah,0DEh, 01h
		db	0FBh, 1Bh, 4Fh,0FFh, 11h, 04h
		db	 0Eh, 01h, 01h, 19h, 00h, 00h
		db	 09h, 80h, 11h, 8Ah,0DEh, 01h
		db	0FBh, 1Bh, 14h,0FFh, 0Fh, 18h
		db	 0Eh, 01h, 01h, 19h, 00h, 00h
		db	 09h, 80h, 11h, 8Ah,0DEh, 01h
		db	0FBh, 1Bh, 12h,0FFh, 4Dh, 23h
		db	 0Eh, 01h, 01h, 19h, 00h, 00h
		db	 09h, 80h, 11h, 8Ah,0DEh, 01h
		db	0FBh, 1Bh, 4Ch,0FFh, 4Eh,0FFh
		db	 13h, 03h, 01h, 0Fh, 00h, 00h
		db	 14h, 00h, 12h, 00h, 00h, 02h
		db	 1Dh, 00h, 00h, 1Dh, 00h, 05h
		db	 00h, 00h, 03h, 19h, 00h, 00h
		db	 08h, 80h, 09h, 8Ah,0DEh, 00h
		db	 4Dh,0FFh, 15h,0FFh, 14h, 03h
		db	 01h, 1Dh, 00h, 00h, 15h, 00h
		db	 06h, 00h, 00h, 02h, 19h, 00h
		db	 00h, 19h, 80h, 07h, 8Ah,0DEh
		db	 03h, 19h, 00h, 00h, 1Ah, 80h
		db	 10h, 8Ah,0DEh, 01h,0F2h, 23h
		db	 49h,0FFh, 4Ah,0FFh, 12h, 02h
		db	 01h, 1Dh, 00h, 00h, 0Fh, 00h
		db	 05h, 00h, 00h, 02h, 19h, 00h
		db	 00h, 08h, 80h, 07h, 8Ah,0DEh
		db	 00h,0FFh,0FFh, 00h,0FFh, 44h
		db	 01h, 01h, 00h, 00h, 00h, 1Bh
		db	 80h, 0Eh, 00h, 00h, 01h, 3Dh
		db	 15h,0FFh,0FFh,0FFh,0FFh, 43h
		db	 01h, 01h, 26h, 00h, 00h, 0Ch
		db	 60h, 10h, 4Bh,0E1h, 02h,0FBh
		db	 1Bh, 3Dh, 15h, 41h,0FFh,0FFh
		db	0FFh, 45h, 01h, 00h, 0Eh, 00h
		db	 00h, 1Eh, 60h, 10h, 74h,0DEh
		db	 01h, 84h, 2Ah,0FFh,0FFh,0FFh
		db	0FFh, 45h, 01h, 03h, 03h, 00h
		db	 00h, 17h, 80h, 0Dh, 00h, 00h
		db	 00h, 02h, 00h, 01h, 03h, 04h
		db	 08h, 2Fh, 03h, 1Ah,0C0h, 00h
		db	 02h, 00h, 02h, 03h, 05h,0F6h
		db	 2Eh, 0Ch, 0Bh,0C0h,0FAh, 02h
		db	 00h, 01h, 02h, 03h,0F6h, 2Eh
		db	 0Ch, 0Ch,0C0h,0FAh, 0Ah, 00h
		db	 00h, 02h, 02h,0CCh, 2Dh, 09h
		db	 14h,0A5h,0DEh, 0Ch, 00h, 01h
		db	 02h, 03h, 00h, 00h, 00h, 00h
		db	 00h,0C4h, 2Eh, 06h, 06h, 0Ah
		db	 00h, 01h, 03h, 04h,0CCh, 2Dh
		db	 10h, 17h,0BEh,0DEh, 11h, 02h
		db	 02h, 05h, 05h, 00h, 00h, 01h
		db	 00h, 01h,0BEh, 2Eh, 0Ch, 08h
		db	 0Ah, 04h, 04h, 00h, 00h,0CCh
		db	 2Dh, 10h, 19h,0D7h,0DEh, 06h
		db	 00h, 03h, 04h, 07h, 00h, 00h
		db	 00h, 00h, 00h,0BEh, 2Eh, 08h
		db	 03h, 0Ah, 00h, 00h, 00h, 00h
		db	0CCh, 2Dh, 02h, 02h,0F0h,0DEh
		db	 2Bh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 01h, 00h, 01h,0D6h, 2Eh
		db	 0Ch, 0Ah, 0Ah, 00h, 00h, 02h
		db	 02h,0CCh, 2Dh, 10h, 0Fh, 09h
		db	0DFh, 2Ah, 01h, 01h, 03h, 03h
		db	 00h, 00h, 00h, 01h, 01h,0BEh
		db	 2Eh, 06h, 03h, 0Ah, 00h, 01h
		db	 03h, 04h,0CCh, 2Dh, 10h, 17h
		db	 22h,0DFh, 28h, 01h, 02h, 04h
		db	 05h, 00h, 00h, 00h, 00h, 00h
		db	0BEh, 2Eh, 03h, 02h, 00h, 00h
		db	 01h, 02h, 03h,0CCh, 2Dh, 10h
		db	 14h, 3Bh,0DFh, 23h, 00h, 01h
		db	 02h, 03h, 00h, 00h, 00h, 00h
		db	 00h,0BEh, 2Eh, 03h, 02h, 01h
		db	 00h, 01h, 02h, 03h,0B8h, 2Fh
		db	 10h, 18h
data_DF4D	db	0
		db	 2Eh, 00h
data_DF50	dw	1D00h
data_DF52	dw	1180h
		db	0, 0
data_DF56	db	26h
		db	 89h, 78h, 86h, 9Eh, 87h, 62h
		db	 88h, 00h, 88h,0C4h, 88h, 3Ch
		db	 87h,0DAh, 86h,0FFh,0FFh, 42h
		db	 01h, 04h, 00h, 00h, 06h, 00h
		db	 07h, 42h, 02h, 04h, 01h, 00h
		db	 0Bh, 00h, 07h, 42h, 03h, 04h
		db	 02h, 00h, 06h, 00h, 0Ah, 42h
		db	 04h, 04h, 03h, 00h, 0Bh, 00h
		db	 0Ah, 42h, 05h, 04h, 04h, 00h
		db	 19h, 00h, 07h, 42h, 06h, 04h
		db	 05h, 00h, 1Eh, 00h, 07h, 42h
		db	 07h, 04h, 06h, 00h, 19h, 00h
		db	 0Ah, 42h, 08h, 04h, 07h, 00h
		db	 1Eh, 00h, 0Ah, 2Ch, 00h, 30h
		db	 01h, 31h, 02h, 32h, 03h, 41h
		db	 04h, 34h, 05h, 35h, 06h, 39h
		db	 07h,0FFh, 2Ch, 01h, 21h, 04h
		db	 03h, 09h, 30h, 01h, 17h, 0Fh
		db	 03h, 04h, 31h, 01h, 16h, 04h
		db	 04h, 08h, 32h, 01h, 1Dh, 03h
		db	 04h, 08h, 41h, 01h, 12h, 0Ch
		db	 04h, 05h, 34h, 01h, 20h, 04h
		db	 04h, 08h, 35h, 01h, 20h, 0Dh
		db	 03h, 05h, 39h, 01h, 00h, 08h
		db	 04h, 04h
data_DFE9	db	19h
		db	 12h, 0Dh, 1Bh, 19h, 06h, 1Eh
		db	 0Eh, 0Ah, 1Fh, 10h, 0Dh, 21h
		db	 11h, 0Dh,0FFh
data_DFF9	db	0Ch
		db	 01h, 01h, 08h, 10h, 0Ch, 01h
		db	 13h, 0Dh, 11h, 01h, 10h, 06h
		db	 17h, 01h, 05h, 0Fh, 1Ah, 01h
		db	 13h, 03h, 2Eh, 01h, 0Dh, 0Ah
		db	 38h, 01h, 06h, 0Eh, 49h, 01h
		db	 07h, 11h, 4Dh, 01h, 03h, 10h
		db	 15h, 01h, 18h, 06h, 0Ah, 01h
		db	 02h, 10h, 38h, 01h
data_E028	db	4
		db	8
data_E02A	db	9
		db	 07h, 01h, 14h, 06h, 50h, 01h
		db	 0Fh, 05h, 02h, 01h, 15h, 08h
		db	 0Bh, 01h, 0Eh, 0Dh, 3Ch, 01h
		db	 0Ch, 07h, 1Ch, 01h, 21h, 0Ah
		db	 17h, 01h, 1Ch, 0Eh, 0Fh, 01h
		db	 11h, 06h, 13h, 01h, 03h, 10h
		db	0FFh
data_E050	db	21h
		db	 2Bh, 40h, 45h, 48h, 0Dh,0FFh
data_E057	db	18h
		db	 22h, 2Ch
data_E05A	db	3Eh
		db	 43h, 46h,0FFh, 00h, 06h, 10h
		db	 1Eh, 01h, 06h, 14h, 16h, 04h
		db	 0Bh, 14h, 16h, 09h, 01h, 11h
		db	 14h, 0Ah, 01h, 14h, 14h, 0Bh
		db	 0Bh, 14h, 14h, 0Eh, 01h, 11h
		db	 16h, 18h, 0Bh, 14h, 16h, 1Ah
		db	 01h, 11h, 0Ch, 1Bh, 0Bh, 14h
		db	 0Ch, 23h, 0Bh, 14h, 16h, 2Fh
		db	 11h, 14h, 16h, 36h, 0Dh, 14h
		db	 1Bh, 37h, 01h, 14h, 1Bh, 38h
		db	 01h, 14h, 1Bh, 39h, 01h, 0Eh
		db	 1Bh, 43h, 01h, 10h, 16h
data_E0A2	db	50h
		db	 04h, 09h, 02h, 10h, 12h, 03h
		db	 10h, 13h, 05h, 10h, 07h, 0Dh
		db	 10h, 18h, 19h, 10h, 05h, 22h
		db	 10h, 0Eh, 2Bh, 10h, 10h, 51h
		db	 10h, 09h,0FFh, 02h, 00h, 02h
		db	 22h, 03h, 00h, 04h, 00h, 04h
		db	 00h, 04h, 22h, 05h, 00h, 04h
		db	 00h, 0Ch, 00h, 04h, 22h, 18h
		db	 00h, 05h, 22h, 1Ch, 00h, 05h
		db	 00h, 21h, 00h, 04h, 00h, 26h
		db	 00h, 05h, 00h, 29h, 00h, 04h
		db	 22h, 2Ah, 00h, 04h, 00h, 0Bh
		db	 00h, 05h, 22h,0FFh, 2Bh,0A0h
		db	 10h, 18h, 26h,0A0h, 10h, 00h
		db	 25h,0A0h, 10h, 23h, 1Bh,0A0h
		db	 0Fh, 23h, 0Ch,0A0h, 0Ch, 00h
		db	 23h,0A0h, 0Ch, 00h,0FFh, 16h
		db	 60h, 04h, 00h, 17h, 60h, 04h
		db	 00h, 22h, 60h, 0Ch, 24h, 24h
		db	 60h, 0Ch, 00h, 14h, 60h, 06h
		db	 00h, 13h, 60h, 06h, 24h, 02h
		db	 60h, 10h, 24h,0FFh, 06h, 60h
		db	 05h, 24h, 07h, 60h, 10h, 24h
		db	 09h, 60h, 10h, 24h, 0Dh, 60h
		db	 10h, 00h,0FFh, 03h, 60h, 10h
		db	 00h, 0Dh, 60h, 10h, 24h, 21h
		db	 60h, 10h, 24h, 23h, 60h, 0Ch
		db	 24h, 2Dh, 60h, 10h, 24h,0FFh
		db	 00h, 01h, 03h, 04h, 00h, 03h
		db	 06h
		db	9
data_E153	db	83h
		db	 85h, 83h, 85h,0ABh, 86h,0ABh
		db	 86h, 82h, 87h, 82h, 87h,0AAh
		db	0AAh,0AAh,0AAh
data_E163	dw	16 dup (0FFFFh)
		db	0F0h
		db	15 dup (0)
		db	3Fh
		db	31 dup (0FFh)
		db	0F0h
		db	26 dup (0)
		db	 03h,0FFh,0FFh,0FFh,0C0h,0F0h
		db	15 dup (0)
		db	 3Ch, 00h
		db	29 dup (0)
		db	 0Fh,0F2h
		db	26 dup (22h)
		db	 23h, 00h, 00h, 00h,0C0h,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 55h, 50h, 00h
		db	 00h, 00h, 00h
		db	3Ch
		db	30 dup (88h)
		db	 8Fh,0F0h, 88h, 88h, 00h, 00h
		db	 08h, 88h, 88h, 88h
		db	18 dup (88h)
		db	 82h, 00h, 00h, 00h, 88h,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 55h
		db	 55h, 50h, 55h, 55h, 55h, 00h
		db	 00h, 00h, 00h, 3Ch, 20h, 00h
		db	27 dup (0)
		db	 02h, 0Fh,0F2h, 22h, 00h,0AAh
		db	0AAh, 02h, 20h, 00h
		db	22h
		db	11 dup (0)
		db	 02h, 22h, 22h, 22h, 22h, 22h
		db	 22h, 23h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 00h, 00h, 05h
		db	 55h, 55h, 55h, 05h, 55h, 55h
		db	 00h, 00h, 00h, 00h, 3Ch, 88h
		db	 55h, 55h
		db	19 dup (55h)
		db	7 dup (5Ah)
		db	 50h, 8Fh,0F0h, 80h, 2Ah,0AAh
		db	0AAh,0A0h, 00h,0AAh, 08h, 8Fh
		db	0FFh,0FFh
		db	8 dup (0FFh)
		db	0F0h, 88h, 88h, 88h, 88h, 88h
		db	 88h, 82h, 00h, 00h, 00h, 88h
		db	0F0h
		db	7 dup (0)
		db	 05h, 55h, 55h, 55h, 00h, 00h
		db	 00h, 00h, 3Ch, 20h, 50h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0A2h, 0Fh,0F2h, 02h
		db	0AAh,0A2h,0AAh, 8Ah, 0Ah,0A2h
		db	 82h
		db	0Dh
		db	10 dup (55h)
		db	 72h, 20h, 00h, 00h, 00h, 00h
		db	 00h, 03h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 00h, 55h, 55h
		db	 50h, 53h,0C0h, 55h, 05h, 50h
		db	 00h, 00h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 8Fh
		db	0F0h, 0Ah,0AAh, 00h, 2Ah,0A0h
		db	 8Ah, 80h,0A0h, 8Dh, 00h
		db	9 dup (0)
		db	 70h, 88h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 82h, 00h, 00h, 00h, 88h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 0Fh,0FCh, 0Ah,0A0h, 55h
		db	 00h, 00h, 00h, 00h, 3Ch, 20h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A2h, 0Fh
		db	0F0h, 2Ah,0A8h,0A2h, 8Ah,0AAh
		db	 2Ah,0A0h,0A2h
		db	0Dh
		db	10 dup (0)
		db	 72h, 20h,0FFh,0FFh,0FFh,0E8h
		db	 20h, 83h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	0F0h,0F0h,0FFh, 00h, 0Ah, 5Ah
		db	0A8h, 00h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 8Fh
		db	0F0h,0AAh,0A8h,0A2h,0AAh,0AAh
		db	 0Ah,0A0h,0A0h, 8Dh
		db	10 dup (0)
		db	 70h, 88h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 82h, 00h, 00h, 00h, 88h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	0F4h,0F4h,0FFh, 00h, 00h, 0Ah
		db	 0Ah, 00h, 00h, 00h, 3Ch, 20h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A2h, 0Fh
		db	0F0h,0A2h,0AAh, 00h, 2Ah,0A8h
		db	0A0h,0A8h, 82h, 0Dh, 00h
		db	9 dup (0)
		db	 72h, 20h,0FFh,0FFh,0FFh,0E8h
		db	 20h, 83h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	0AAh, 00h,0FFh, 00h, 00h,0A0h
		db	0AAh, 00h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 8Fh
		db	0F0h, 88h,0AAh,0A2h, 8Ah,0A2h
		db	0A0h, 0Ah, 08h, 8Dh, 00h, 00h
		db	8 dup (0)
		db	 70h, 88h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 82h, 00h, 00h, 00h, 88h
		db	0F0h, 00h, 00h, 00h, 00h, 0Ah
		db	0AAh,0A0h,0FFh, 00h, 0Ah,0AAh
		db	 0Ah, 00h, 00h, 00h, 3Ch, 20h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A2h, 0Fh
		db	0F0h,0A2h,0A8h,0A2h, 8Ah,0AAh
		db	 82h, 00h
		db	 22h, 0Dh
		db	10 dup (0)
		db	 72h, 20h,0FFh,0FFh,0FFh,0E8h
		db	 20h, 83h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 00h, 00h,0AAh
		db	0AAh,0AAh, 00h, 00h,0F2h,0A0h
		db	 0Ah, 00h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 8Fh
		db	0F0h, 28h,0AAh, 00h, 2Ah, 22h
		db	 00h, 80h, 88h, 8Dh, 00h, 00h
		db	8 dup (0)
		db	 70h, 88h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 82h, 00h, 00h, 00h, 88h
		db	0F0h, 00h, 00h, 00h, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 02h, 0Ah
		db	0A0h, 00h, 00h, 00h, 3Ch, 20h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A2h, 0Fh
		db	0F2h, 0Ah, 2Ah,0A2h,0A8h, 88h
		db	 02h
		db	 22h, 22h, 0Dh
		db	10 dup (0)
		db	 72h, 20h,0FFh,0FFh,0FFh,0E8h
		db	 20h, 83h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 0Fh,0F2h, 00h
		db	0FCh, 00h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_E608	proc	near
		add	[bx+si],al
		push	ax
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 50h, 8Fh,0F0h, 80h,0A2h, 2Ah
		db	 22h, 80h, 88h, 88h, 88h, 8Dh
		db	10 dup (0)
		db	 70h, 88h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 82h, 00h, 00h, 00h, 88h
		db	0F0h, 00h, 00h, 02h,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0F0h,0FAh, 8Fh
		db	0CFh, 00h, 00h, 00h, 3Ch, 20h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A2h, 0Fh
		db	0F2h, 20h, 08h, 88h, 88h, 02h
		db	 22h, 22h, 22h, 0Dh, 00h, 00h
		db	8 dup (0)
		db	 72h, 20h, 00h, 00h, 00h, 00h
		db	 00h, 03h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 0Ah,0A0h,0AAh
		db	0AAh,0AAh, 0Fh,0FFh, 0Ah,0A8h
		db	0FFh,0C0h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 8Fh
		db	0F0h, 88h, 80h, 00h, 00h, 88h
		db	 88h, 88h, 88h, 8Dh
		db	 55h, 55h
		db	8 dup (55h)
		db	 70h, 88h, 88h, 88h, 88h, 88h
		db	 88h, 82h, 00h, 00h, 00h, 88h
		db	0F0h, 00h, 00h, 0Ah,0AAh,0AAh
		db	0AAh, 80h,0F0h,0F0h,0A3h,0AAh
		db	 0Ch,0C0h, 00h, 00h, 3Ch, 20h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A2h, 0Fh
		db	0F2h
		db	8 dup (22h)
		db	0Fh
		db	10 dup (0FFh)
		db	0F2h, 22h, 22h, 22h, 22h, 22h
		db	 22h, 23h, 00h, 00h, 00h,0C0h
		db	0F0h, 00h, 00h, 02h,0AAh,0AAh
		db	0A8h,0AAh,0AAh,0AAh, 03h,0FAh
		db	 0Fh,0C0h, 00h, 00h, 3Ch, 88h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 50h, 8Fh
		db	0F0h, 88h, 08h, 00h, 88h, 88h
		db	 88h, 88h, 88h, 80h, 00h
		db	10 dup (0)
		db	 88h, 88h, 88h, 88h, 88h, 88h
		db	 83h,0FFh,0FFh,0FFh,0C8h,0F0h
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0F0h,0FCh
		db	0C0h, 00h, 00h, 3Ch, 20h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A2h, 0Fh,0F2h
		db	 00h,0F0h,0F0h
		db	23 dup (22h)
		db	 20h, 00h, 00h, 00h, 00h,0F0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh,0CFh
		db	 00h, 00h, 00h, 3Ch, 88h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 8Fh,0F0h
		db	0CFh,0CFh, 3Fh, 08h, 88h, 80h
		db	 00h
		db	23 dup (0)
		db	 88h,0F0h, 00h, 00h, 0Ah,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0FCh, 00h, 00h, 00h
		db	 3Ch, 20h, 55h, 55h
		db	19 dup (55h)
		db	0A4h,0A5h,0A5h,0A5h,0A5h,0A5h
		db	0A5h,0A2h, 0Fh,0F0h, 3Fh, 3Fh
		db	0FFh
		db	 22h, 22h, 22h
		db	23 dup (0AAh)
		db	0A8h, 20h,0F0h, 00h, 00h, 0Ah
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 00h, 00h, 00h
		db	 3Ch, 88h, 00h
		db	28 dup (0)
		db	 8Fh,0F0h,0CFh, 5Fh, 55h, 00h
		db	 08h, 82h,0BFh,0FFh,0FFh,0FFh
		db	19 dup (0FFh)
		db	0E8h, 88h,0F0h, 00h, 00h, 00h
		db	0FAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 50h, 00h, 00h, 00h, 00h
		db	 3Ch, 22h, 20h
		db	27 dup (0FFh)
		db	0F2h, 0Fh,0F0h,0F5h, 0Fh, 05h
		db	 55h, 22h, 22h,0BFh, 00h, 00h
		db	20 dup (0)
		db	0E8h, 20h,0F0h, 00h, 00h, 00h
		db	0F8h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 50h, 00h, 00h, 00h, 00h
		db	 3Ch, 88h, 88h,0F0h, 00h
		db	25 dup (0)
		db	0F0h, 8Fh,0F2h, 34h,0F0h,0F1h
		db	 05h, 08h, 82h,0BFh, 00h, 00h
		db	20 dup (0)
		db	0E8h, 88h,0F0h, 00h, 00h, 00h
		db	0F8h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 50h, 00h, 00h, 00h, 00h
		db	 3Ch, 22h, 20h,0F0h
		db	26 dup (0)
		db	0F2h, 0Fh,0F0h, 04h,0FFh,0F1h
		db	 05h, 22h, 22h,0BFh,0FFh,0FFh
		db	20 dup (0FFh)
		db	0E8h, 20h,0F0h, 00h, 00h, 00h
		db	0F8h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 50h, 00h, 00h, 00h, 00h
		db	 3Ch, 88h, 88h,0F0h, 00h
		db	25 dup (0)
		db	0F0h, 8Fh,0F2h, 04h,0FFh,0F1h
		db	 05h, 08h, 82h
		db	23 dup (0AAh)
		db	0A8h, 88h,0F0h, 00h, 00h, 00h
		db	0F8h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 50h, 00h, 00h, 00h, 00h
		db	 3Ch, 22h, 20h,0F0h
		db	26 dup (0)
		db	0F2h, 0Fh,0F0h, 84h,0BFh,0E1h
		db	 05h
		db	 22h, 20h
		db	24 dup (0)
		db	 20h,0F0h, 00h, 00h, 00h,0F8h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	 50h, 00h, 00h, 00h, 00h, 3Ch
		db	 88h, 88h,0F0h, 00h
		db	25 dup (0)
		db	0F0h, 8Fh,0F2h, 04h,0EAh,0B1h
		db	 04h, 88h, 82h,0AAh,0AAh
		db	21 dup (0AAh)
		db	0A8h, 88h,0F0h, 00h, 00h, 00h
		db	0F8h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 50h, 00h, 00h, 00h, 00h
data_EAA3	db	3Ch			; Data table (indexed access)
		db	 22h, 20h,0F0h
		db	26 dup (0)
		db	0F2h, 0Fh,0F0h, 84h,0ABh,0A1h
		db	 52h, 22h, 22h, 80h, 2Ah,0A8h
		db	 2Ah,0A8h, 02h,0AAh, 80h, 2Ah
		db	0AAh, 0Ah,0AAh, 00h, 0Ah,0A8h
		db	 02h,0A8h, 00h, 2Ah,0A0h, 0Ah
		db	0AAh, 00h,0A8h, 20h,0F0h, 00h
		db	 00h, 00h,0F8h, 00h, 00h, 00h
		db	 00h, 00h, 02h, 50h, 00h, 00h
		db	 00h, 00h, 3Ch, 88h, 88h,0F0h
		db	 00h
		db	25 dup (0)
		db	0F0h, 8Fh,0F2h, 04h,0BAh,0A1h
		db	 08h, 88h, 82h, 0Ah, 0Ah,0A0h
		db	 2Ah,0A2h,0A0h,0AAh, 2Ah, 0Ah
		db	0A8h, 2Ah,0AAh, 0Ah,0AAh,0A0h
		db	0AAh,0A8h,0A8h, 2Ah, 82h, 82h
		db	0A8h, 28h, 28h, 88h,0F0h, 00h
		db	 00h, 00h,0F8h, 00h, 00h, 00h
		db	 00h, 00h, 02h, 50h, 00h, 00h
		db	 00h, 00h, 3Ch, 22h, 20h,0F0h
		db	26 dup (0)
		db	0F2h, 0Fh,0F0h, 84h,0AAh,0E1h
		db	 22h, 22h, 22h, 0Ah, 0Ah,0A8h
		db	 2Ah,0AAh, 02h,0AAh,0A0h, 2Ah
		db	0A0h,0A0h,0AAh,0A0h, 2Ah,0A0h
		db	 02h,0AAh,0A0h,0AAh,0A0h, 0Ah
		db	0AAh, 00h, 28h, 20h,0F0h, 00h
		db	 00h, 00h,0FAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 50h, 00h, 00h
		db	 00h, 00h, 3Ch, 88h, 88h,0F0h
		db	 00h
		db	25 dup (0)
		db	0F0h, 8Fh,0F2h, 05h, 00h, 05h
		db	 08h, 88h, 82h, 0Ah, 0Ah,0A8h
		db	 2Ah,0A8h, 2Ah,0AAh, 2Ah, 0Ah
		db	0A0h, 00h,0AAh, 2Ah, 0Ah,0A0h
		db	0A0h,0AAh, 82h,0AAh, 82h, 82h
		db	0AAh,0A8h, 28h, 88h,0F0h, 00h
		db	 00h, 00h
		db	'UUUUUUUP'
		db	 00h, 00h, 00h, 00h, 3Ch, 22h
		db	 20h
		db	25 dup (0FFh)
data_EBFF	dw	0FFFFh, 0FF2h
		db	0F0h, 81h, 55h, 54h, 22h, 22h
		db	 22h, 80h, 2Ah,0A0h, 0Ah,0A0h
		db	 00h,0AAh, 80h, 2Ah,0AAh,0A0h
		db	0AAh, 80h, 2Ah,0A8h, 02h,0AAh
		db	 82h,0AAh,0A0h, 0Ah,0AAh, 00h
		db	0A8h, 20h,0F0h
		db	15 dup (0)
		db	 3Ch, 88h, 88h, 00h
		db	27 dup (0)
		db	 8Fh,0F2h, 00h, 00h, 00h, 88h
		db	 88h, 82h
		db	23 dup (0AAh)
		db	0A8h, 88h,0F0h
		db	15 dup (0)
		db	 3Ch, 22h
		db	29 dup (22h)
		db	 0Fh,0F0h
		db	 22h, 22h, 22h, 22h, 22h, 20h
		db	24 dup (0)
		db	 20h,0F0h
		db	15 dup (0)
		db	 3Ch, 88h
		db	29 dup (88h)
		db	 8Fh,0F0h
		db	31 dup (0)
		db	0F0h
		db	15 dup (0)
		db	 3Ch, 22h
		db	29 dup (22h)
		db	0Fh
		db	32 dup (0FFh)
		db	0F0h
		db	15 dup (0)
		db	 3Ch, 00h
		db	29 dup (0)
		db	0Fh
		db	48 dup (0)
		db	3Fh
		db	31 dup (0FFh)
data_EDE3	db	0D0h
		db	0D1h,0D1h,0D2h,0D0h,0D1h,0D2h
		db	 00h, 00h,0B2h,0B2h, 00h, 00h
		db	 00h, 00h, 00h,0B2h, 00h, 00h
		db	10 dup (0)
		db	0B2h, 00h, 00h, 00h, 00h, 45h
		db	 16h, 16h, 16h, 16h, 47h,0D5h
		db	0D4h,0D4h,0D3h,0D5h,0D4h,0D3h
		db	 00h, 00h, 00h, 00h, 00h,0B2h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0F3h,0F2h,0F1h,0F2h,0F2h
		db	0F1h,0F0h, 00h,0F3h,0F1h,0F0h
		db	0B2h,0F0h, 00h, 12h, 18h, 18h
		db	 18h, 18h, 17h
		db	7 dup (1)
		db	 93h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FEh, 09h,0FFh,0FFh,0FFh,0FFh
		db	0FEh, 00h, 00h, 00h, 02h, 02h
		db	 00h, 00h, 00h, 04h, 02h, 00h
		db	0FFh,0FEh, 01h, 9Ch, 80h, 80h
		db	 80h, 80h, 82h, 00h, 02h, 02h
		db	 08h, 00h, 02h, 08h,0FFh,0FEh
		db	 09h,0FFh,0FFh,0FEh, 00h
		db	19 dup (0)
		db	0FFh, 30h,0C1h,0C1h,0C1h,0C1h
		db	 30h, 0Ch, 1Eh, 1Eh, 1Eh, 1Eh
		db	 1Eh, 0Eh, 08h, 0Ch, 0Ch, 0Eh
		db	 0Fh,0FEh, 00h
		db	19 dup (0)
		db	0FFh,0C9h,0C7h,0C7h,0C7h,0C7h
		db	0C0h, 02h, 1Eh, 30h, 30h, 30h
		db	 1Eh, 00h, 00h, 02h, 02h
		db	23 dup (0)
		db	0FFh, 9Ch, 80h, 80h, 80h, 80h
		db	 82h, 0Eh, 1Eh, 30h, 30h, 30h
		db	 1Eh, 09h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FEh, 00h
		db	19 dup (0)
		db	0FFh, 30h,0C1h,0C1h,0C1h,0C1h
		db	 30h, 00h, 1Eh, 1Eh, 1Eh, 1Fh
		db	0E0h,0D3h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh
		db	19 dup (0FFh)
		db	 00h, 21h, 2Bh, 2Dh, 2Dh, 2Dh
		db	 34h,0D0h,0D1h,0D1h,0D2h,0D0h
		db	0D1h,0D2h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh
		db	19 dup (0FFh)
		db	 00h, 00h, 00h, 68h, 19h, 19h
		db	 6Ah,0D5h,0D4h,0D4h,0D3h,0D5h
		db	0D4h,0D3h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh
		db	19 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0A4h,0A5h
		db	 00h,0D4h,0D3h,0D5h,0D4h,0D4h
		db	0D3h,0D5h, 00h, 00h, 6Bh, 6Dh
		db	 6Ch, 00h,0FFh
		db	19 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0A4h
data_EF99	db	0A5h
		db	 00h,0D0h,0D1h,0D1h,0D2h,0D0h
		db	0D1h,0D2h, 00h, 00h, 70h, 6Fh
		db	 6Eh, 00h,0FFh
		db	19 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0A4h,0A5h
		db	 00h,0D5h,0D4h,0D4h,0D3h,0D5h
		db	0D4h,0D3h, 00h, 00h, 00h,0DEh
		db	 00h, 00h
		db	20 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0A4h,0A5h
		db	 00h, 00h,0FBh
		db	8 dup (0)
		db	0DDh
		db	26 dup (0)
		db	0A4h,0A5h, 00h, 00h,0FBh
		db	8 dup (0)
		db	0DDh, 00h, 00h, 00h,0B3h,0B3h
		db	0B3h,0B3h,0B3h, 00h
		db	17 dup (0)
		db	0A4h,0A5h, 00h, 00h,0FBh,0DFh
		db	7 dup (0)
		db	0DDh, 00h, 00h, 00h,0B3h,0B3h
		db	0B3h,0B3h,0B3h
		db	18 dup (0)
		db	0A4h,0A5h, 00h, 00h,0FBh
		db	8 dup (0)
		db	0DDh, 00h, 00h, 00h,0B3h,0B3h
		db	0B3h,0B3h,0B3h
		db	18 dup (0)
		db	0A4h,0A5h, 00h, 00h,0FBh
		db	8 dup (0)
		db	0DCh, 00h, 00h, 00h,0B3h,0B3h
		db	0B3h,0B3h,0A4h, 7Fh,0FFh,0FFh
		db	9 dup (0FFh)
data_F0AA	db	0FFh			; Data table (indexed access)
		db	0FFh,0FFh,0FFh,0FFh, 83h,0E2h
		db	 62h, 00h
data_F0B3	db	98h
		db	 60h,0E0h,0E0h, 98h, 7Fh,0FFh
data_F0BA	db	0FFh
		db	0FFh,0FFh, 00h, 7Fh,0FFh,0FFh
		db	 04h, 04h, 04h, 04h, 04h, 7Fh
		db	0FFh
		db	11 dup (0FFh)
data_F0D3	db	0FFh
		db	0FFh, 98h, 60h,0E0h,0E0h,0E0h
data_F0DA	db	98h
		db	 4Ch, 60h,0E0h,0CCh,0CCh, 60h
		db	0E0h,0CCh,0CCh, 60h,0E0h,0CCh
		db	0C6h
		db	 46h, 46h, 46h
		db	16 dup (46h)
		db	 4Ch, 60h,0E0h,0CCh,0CCh
sub_E608	endp


seg_a		ends



		end	start
