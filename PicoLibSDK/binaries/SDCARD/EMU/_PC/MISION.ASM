
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
;==				MISION	                                 ==
;==					                                 ==
;==      Created:   1-Jan-80		                                 ==
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
d_0000_002A_e	equ	2Ah
d_0000_003F_e	equ	3Fh
d_0000_0070_e	equ	70h
d_0000_0201_e	equ	201h
d_0000_0202_e	equ	202h
d_0000_0228_e	equ	228h
d_0000_0A00_e	equ	0A00h			;*
d_0000_8002_e	equ	8002h			;*
d_0000_A808_e	equ	0A808h			;*
d_0000_AAD2_e	equ	0AAD2h			;*
d_0000_B0AF_e	equ	0B0AFh			;*
d_0000_FC93_e	equ	0FC93h			;*
data_0000_e	equ	0
PSP_free_seg	equ	2
data_002A_e	equ	2Ah
data_003F_e	equ	3Fh
data_008E_e	equ	8Eh
data_0093_e	equ	93h
data_00A0_e	equ	0A0h
data_00B0_e	equ	0B0h
data_00D0_e	equ	0D0h
data_F49F_e	equ	0F49Fh			;*
data_F646_e	equ	0F646h			;*
data_FE87_e	equ	0FE87h			;*
data_FE8D_e	equ	0FE8Dh			;*
d_4600_B782_e	equ	0B782h			;*
d_B800_0000_e	equ	0
d_B800_1FFE_e	equ	1FFEh
d_B800_2000_e	equ	2000h
d_BA00_0008_e	equ	8
d_BA00_000F_e	equ	0Fh
d_BA00_2D44_e	equ	2D44h
d_BA00_2D4F_e	equ	2D4Fh
d_BA00_4900_e	equ	4900h
d_BA00_7092_e	equ	7092h
d_BA00_7860_e	equ	7860h
d_BA00_7866_e	equ	7866h
d_BA00_786C_e	equ	786Ch
d_BA00_7978_e	equ	7978h
d_BA00_7982_e	equ	7982h
d_BA00_798F_e	equ	798Fh
d_BA00_7990_e	equ	7990h
d_BA00_7995_e	equ	7995h
d_BA00_7996_e	equ	7996h
d_BA00_799A_e	equ	799Ah
d_BA00_799B_e	equ	799Bh
d_BA00_799E_e	equ	799Eh
d_BA00_AFBE_e	equ	0AFBEh
d_BA00_B3BD_e	equ	0B3BDh
d_BA00_B3DA_e	equ	0B3DAh
d_BA00_B3F7_e	equ	0B3F7h
d_BA00_B40F_e	equ	0B40Fh
d_BA00_B537_e	equ	0B537h
d_BA00_B56A_e	equ	0B56Ah
d_BA00_B585_e	equ	0B585h
d_BA00_B59A_e	equ	0B59Ah
d_BA00_B59B_e	equ	0B59Bh
d_BA00_B843_e	equ	0B843h
d_BA00_BAEB_e	equ	0BAEBh
d_BA00_BAED_e	equ	0BAEDh
d_BA00_BAEF_e	equ	0BAEFh
d_BA00_BAF0_e	equ	0BAF0h
d_BA00_BAF4_e	equ	0BAF4h
d_BA00_BAF5_e	equ	0BAF5h
d_BA00_BAF6_e	equ	0BAF6h

seg_a		segment	byte public
		assume	cs:seg_a, ds:seg_a


		org	100h

MISION		proc	far

start:
		mov	ax,cs
		add	ax,0
		mov	ds,ax
		mov	es,ax
		mov	ss,ax
		mov	si,offset data_B3BD
		mov	word ptr [si],0
		mov	di,offset data_B3BE
		mov	cx,0B3BDh
		mov	bx,0BAFBh
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
;*		mov	cx,bx
		db	 89h,0D9h		;  Fixup - byte match
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		call	sub_2168
		call	sub_0FB0
		mov	cs:data_0BD1,sp
loc_012D:
		mov	sp,cs:data_0BD1
		call	sub_1083
		call	sub_08A4
		call	sub_072E
		call	sub_0776
		call	sub_0873
		call	sub_0BD3
		call	sub_0776
		mov	bl,0A2h
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		xchg	dx,bx
		mov	dx,30h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_B56B,bx
		push	es
		push	ds
		mov	ax,0B800h
		mov	es,ax
		add	ax,200h
		mov	ds,ax
		mov	ah,8
		push	bx
		mov	byte ptr es:[bx],0
		db	 3Eh,0C6h, 07h, 00h, 83h,0C3h
		db	 50h, 26h,0C6h, 07h, 00h, 3Eh
		db	0C6h, 07h, 00h, 5Bh, 43h,0FEh
		db	0CCh, 75h,0E6h, 1Fh, 07h,0B4h
data_018D	db	1
		db	 88h, 26h,0EFh,0BAh,0B4h, 01h
		db	 88h, 26h, 6Fh,0B5h, 88h, 26h
		db	 6Eh,0B5h,0E8h, 95h, 22h,0E8h
		db	 7Eh, 0Eh,0E8h, 23h, 23h,0BBh
		db	 31h, 30h, 89h, 1Eh, 9Ah, 79h
		db	0BBh, 98h, 79h,0E8h,0DDh, 0Fh
		db	0BBh, 00h, 00h, 89h, 1Eh,0F2h
		db	0BAh, 88h, 1Eh, 6Ah,0B5h
loc_01BD:
		call	sub_0C81
		call	sub_2773
		call	sub_2537
		call	sub_0210
		call	sub_08FD
		call	sub_0942
		call	sub_02FD
		test	byte ptr data_48F6,80h	; key Enter
		jnz	loc_01F0		; Jump if not zero
		mov	ah,data_B585
		test	ah,20h			; ' '
		jz	loc_01BD		; Jump if zero
loc_01E2:
		mov	dx,0B576h
		mov	bx,offset data_B572
		mov	ch,4
		call	sub_48C1
		jmp	loc_012D
loc_01F0:
		test	byte ptr data_48F6,80h	; key Enter
		jnz	loc_01F0		; Jump if not zero
loc_01F7:
		mov	ah,cs:data_1683
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	$+2			; delay for I/O
		test	byte ptr data_48F6,80h	; key Enter
		jz	loc_01F7		; Jump if zero
loc_0207:
		test	byte ptr data_48F6,80h	; key Enter
		jnz	loc_0207		; Jump if not zero
		jmp	short loc_01BD

MISION		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0210	proc	near
		call	sub_2C9F
		jc	loc_0218		; Jump if carry Set
		call	sub_0949
loc_0218:
		call	sub_04D0
		call	sub_0FC6
		call	sub_15A1
		call	sub_02B3
		mov	ah,data_B585
		test	ah,8
		jz	loc_0242		; Jump if zero
		call	sub_030E
		call	sub_11F7
		jz	loc_0242		; Jump if zero
		cmp	ah,cs:data_0BD0
		jb	loc_023F		; Jump if below
		jmp	loc_0949
loc_023F:
		call	sub_1342
loc_0242:
		mov	ah,ds:d_BA00_B585_e
		test	ah,4
		jz	loc_0260		; Jump if zero
		call	sub_0376
		call	sub_126D
		jz	loc_0260		; Jump if zero
		cmp	ah,cs:data_0BD0
		jb	loc_025D		; Jump if below
		jmp	loc_0949
loc_025D:
		call	sub_1342
loc_0260:
		mov	ah,ds:d_BA00_B585_e
		test	ah,2
		jz	loc_0283		; Jump if zero
		call	sub_040D
		call	sub_269F
		jz	loc_0283		; Jump if zero
		call	sub_1310
		jz	loc_0283		; Jump if zero
		cmp	ah,cs:data_0BD0
		jb	loc_0280		; Jump if below
		jmp	loc_0949
loc_0280:
		call	sub_135B
loc_0283:
		mov	ah,ds:d_BA00_B585_e
		test	ah,1
		jz	loc_02A6		; Jump if zero
		call	sub_03DF
		call	sub_265A
		jz	loc_02A6		; Jump if zero
		call	sub_12E0
		jz	loc_02A6		; Jump if zero
		cmp	ah,cs:data_0BD0
		jb	loc_02A3		; Jump if below
		jmp	loc_0949
loc_02A3:
		call	sub_135B
loc_02A6:
		mov	ah,ds:d_BA00_B585_e
		test	ah,10h
		jz	loc_ret_02B2		; Jump if zero
		call	sub_042B

loc_ret_02B2:
		retn
sub_0210	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02B3	proc	near
		mov	ah,data_B56F
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_02C2		; Jump if zero
		dec	ah
		mov	data_B56F,ah
		retn
loc_02C2:
		mov	ah,1
		mov	data_B56F,ah
		mov	bx,d_BA00_B585_e
		or	byte ptr [bx],2
		retn
sub_02B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02CF	proc	near
		mov	bx,offset data_B56D
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_02D9		; Jump if not zero
		retn
loc_02D9:
		dec	byte ptr [bx]
		retn
sub_02CF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02DC	proc	near
		mov	ah,0C3h
		mov	byte ptr cs:[949h],ah
		mov	byte ptr cs:[0A25h],ah
		mov	ah,0FFh
		mov	cs:data_0BD0,ah
		retn
sub_02DC	endp

			                        ;* No entry point to code
		mov	ah,0
		mov	byte ptr cs:[949h],ah
		mov	byte ptr cs:[0A25h],ah
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_02FD	proc	near
		mov	bx,d_BA00_B40F_e
		mov	ch,0Bh
		mov	dx,1Dh
loc_0305:
		inc	byte ptr [bx]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_0305		; Jump if not zero
		retn
sub_02FD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_030E	proc	near
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+6]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0366		; Jump if not zero
		mov	ah,[si+18h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_035F		; Jump if not zero
		mov	ah,1
		mov	[si+18h],ah
		mov	ah,[si+1]
		add	ah,1
		mov	[si+7],ah
		test	byte ptr [si],1
		jnz	loc_0344		; Jump if not zero
		call	sub_0805
		jz	loc_033F		; Jump if zero
		mov	ah,[si+1]
		mov	[si+7],ah
		jmp	short loc_035F
loc_033F:
		call	sub_078E
		jnz	loc_035F		; Jump if not zero
loc_0344:
		mov	ah,[si+1Eh]
		add	ah,1
		mov	[si+24h],ah
		mov	ah,[si+23h]
		xor	ah,1
		mov	[si+29h],ah
		mov	bx,733Ch
		call	sub_2292
		call	sub_083F
loc_035F:
		dec	word ptr [si+18h]
		call	sub_25AF
		retn
loc_0366:
		mov	ah,[si+18h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_035F		; Jump if not zero
		dec	word ptr [si+0Ch]
		mov	ah,1
		mov	[si+18h],ah
		retn
sub_030E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0376	proc	near
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+6]
		cmp	ah,6
		jne	loc_03CF		; Jump if not equal
		mov	ah,[si+18h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_03C8		; Jump if not zero
		mov	ah,1
		mov	[si+18h],ah
		mov	ah,[si+1]
		add	ah,0FFh
		mov	[si+7],ah
		test	byte ptr [si],1
		jnz	loc_03AD		; Jump if not zero
		call	sub_0822
		jz	loc_03A8		; Jump if zero
		mov	ah,[si+1]
		mov	[si+7],ah
		jmp	short loc_03C8
loc_03A8:
		call	sub_078E
		jnz	loc_03C8		; Jump if not zero
loc_03AD:
		mov	ah,[si+1Eh]
		add	ah,0FFh
		mov	[si+24h],ah
		mov	ah,[si+23h]
		xor	ah,1
		mov	[si+29h],ah
		mov	bx,733Ch
		call	sub_2292
		call	sub_083F
loc_03C8:
		dec	byte ptr [si+18h]
		call	sub_260D
		retn
loc_03CF:
		mov	ah,[si+18h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_03C8		; Jump if not zero
		inc	byte ptr [si+0Ch]
		mov	ah,1
		mov	[si+18h],ah
		retn
sub_0376	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_03DF	proc	near
		mov	ah,1
		mov	byte ptr ds:[0B56Fh],ah
		mov	byte ptr ds:[0B56Eh],ah
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+2]
		add	ah,0FEh
		mov	[si+8],ah
		test	byte ptr [si],1
		jz	loc_ret_040C		; Jump if zero
		call	sub_0B3F
		jnz	loc_0406		; Jump if not zero
		call	sub_0B39
		and	byte ptr [si],0FEh
		retn
loc_0406:
		mov	ah,[si+2]
		mov	[si+8],ah

loc_ret_040C:
		retn
sub_03DF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_040D	proc	near
		mov	si,d_BA00_B3BD_e
		test	byte ptr [si],1
		jz	loc_0416		; Jump if zero
		retn
loc_0416:
		call	sub_07C0
		jnz	loc_0427		; Jump if not zero
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+2]
		add	ah,2
		mov	[si+8],ah
loc_0427:
		call	sub_078E
		retn
sub_040D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_042B	proc	near
		mov	ah,2
		mov	byte ptr ds:[0B56Dh],ah
		mov	ah,byte ptr ds:[0B568h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_045D		; Jump if not zero
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+6]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0449		; Jump if zero
		cmp	ah,6
		je	loc_0449		; Jump if equal
		retn
loc_0449:
		mov	di,d_BA00_B537_e
		mov	dx,7
		mov	ch,7
loc_0451:
		mov	ah,[di]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_046D		; Jump if zero
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		dec	ch
		jnz	loc_0451		; Jump if not zero
loc_045D:
		mov	bx,d_BA00_B56A_e
		mov	ah,[bx]
		cmp	ah,0E0h
		jne	loc_046A		; Jump if not equal
		jmp	loc_0949
loc_046A:
		inc	byte ptr [bx]
		retn
loc_046D:
		mov	bx,72EEh
		call	sub_2292
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+6]
		cmp	ah,6
		je	loc_048B		; Jump if equal
		mov	ah,[si+7]
		add	ah,8
		mov	[di],ah
		mov	[di+1],ah
		jmp	short loc_049B
loc_048B:
		mov	ah,[si+7]
		cmp	ah,4
		jae	loc_0494		; Jump if above or =
		retn
loc_0494:
		dec	ah
		mov	[di],ah
		mov	[di+1],ah
loc_049B:
		mov	ah,[si+2]
		mov	cl,[si+12h]
		shr	cl,1			; Shift w/zeros fill
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
		mov	[di+6],ah
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		mov	[di+2],dl
		inc	bx
		mov	dl,[bx]
		mov	[di+3],dl
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[di+4],ah
		mov	ah,0Ah
		mov	byte ptr ds:[0B568h],ah
		mov	ah,[si+6]
		mov	[di+5],ah
		retn
sub_042B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_04D0	proc	near
		push	es
		push	ds
		mov	ax,0B800h
		mov	es,ax
		mov	ds,ax
		call	sub_06BD
		pop	ds
		pop	es
		mov	ah,data_B56D
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_04F3		; Jump if not zero
		mov	ah,data_B56A
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_04F3		; Jump if zero
		mov	bx,d_BA00_B56A_e
		dec	byte ptr [bx]
loc_04F3:
		mov	ah,data_B568
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0501		; Jump if zero
		dec	ah
		mov	data_B568,ah
loc_0501:
		call	sub_050A
		call	sub_050A
		call	sub_050A

;==== External Entry into Subroutine ======================================

sub_050A:
		mov	si,d_BA00_B537_e
		mov	dx,7
		mov	ch,7
loc_0512:
		mov	ah,[si]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0521		; Jump if zero
		push	dx
		push	cx
		push	si
		call	sub_0528
		pop	si
		pop	cx
		pop	dx
loc_0521:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_0512		; Jump if not zero
		retn
sub_04D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0528	proc	near
		mov	ah,[si+5]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0532		; Jump if zero
		jmpn	loc_059F
loc_0532:
		mov	ah,[si+4]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_056D		; Jump if not zero
		mov	bl,[si+2]
		mov	bh,[si+3]
		mov	dl,[si]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		call	sub_060C		; Get byte from video memory addr. BX
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0559		; Jump if not zero
		call	sub_0623		; Set byte in video memory addr. BX
		inc	byte ptr [si]
		mov	ah,[si]
		cmp	ah,50h			; 'P'
		je	loc_0559		; Jump if equal
		retn
loc_0559:
		cmp	ah,0FFh
		je	loc_0567		; Jump if equal
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_B57A,ah
		call	sub_2B75
loc_0567:
		mov	ah,1
		mov	[si+4],ah
		retn
loc_056D:
		mov	bl,[si+2]
		mov	bh,[si+3]
		mov	dl,[si+1]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		call	sub_060C		; Get byte from video memory addr. BX
		cmp	ah,0FFh
		jne	loc_0587		; Jump if not equal
		call	sub_0617		; Clear byte in video memory addr. BX
		jmp	short loc_0590
loc_0587:
		mov	ah,1
		mov	data_B57A,ah
		call	sub_2B75
loc_0590:
		mov	ah,[si+1]
		cmp	ah,[si]
		je	loc_059B		; Jump if equal
		inc	word ptr [si+1]
		retn
loc_059B:
		mov	byte ptr [si],0
		retn
loc_059F:
		mov	ah,[si+4]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_05DA		; Jump if not zero
		mov	bl,[si+2]
		mov	bh,[si+3]
		mov	dl,[si]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		call	sub_060C		; Get byte from video memory addr. BX
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_05C6		; Jump if not zero
		call	sub_0623		; Set byte in video memory addr. BX
		dec	byte ptr [si]
		mov	ah,[si]
		cmp	ah,1
		je	loc_05D4		; Jump if equal
		retn
loc_05C6:
		cmp	ah,0FFh
		je	loc_05D4		; Jump if equal
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_B57A,ah
		call	sub_2B75
loc_05D4:
		mov	ah,1
		mov	[si+4],ah
		retn
loc_05DA:
		mov	bl,[si+2]
		mov	bh,[si+3]
		mov	dl,[si+1]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		call	sub_060C		; Get byte from video memory addr. BX
		cmp	ah,0FFh
		jne	loc_05F4		; Jump if not equal
		call	sub_0617		; Clear byte in video memory addr. BX
		jmp	short loc_05FD
loc_05F4:
		mov	ah,1
		mov	data_B57A,ah
		call	sub_2B75
loc_05FD:
		mov	ah,[si+1]
		cmp	ah,[si]
		jne	loc_0608		; Jump if not equal
		mov	byte ptr [si],0
		retn
loc_0608:
		dec	byte ptr [si+1]
		retn
sub_0528	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get byte from video memory addr. BX

sub_060C	proc	near
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	ah,es:[bx]
		pop	es
		retn
sub_060C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear byte in video memory addr. BX

sub_0617	proc	near
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	byte ptr es:[bx],0
		pop	es
		retn
sub_0617	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set byte in video memory addr. BX

sub_0623	proc	near
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	byte ptr es:[bx],0FFh
		pop	es
		retn
sub_0623	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_062F	proc	near
		mov	si,offset data_B537
		mov	dx,7
		mov	ch,7
loc_0637:
		call	sub_0641
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_0637		; Jump if not zero
		retn
sub_062F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0641	proc	near
		mov	ah,[si]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0648		; Jump if not zero
		retn
loc_0648:
		push	bx
		push	dx
		push	cx
		mov	bl,[si+2]
		mov	bh,[si+3]
		mov	dl,[si]
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[si+5]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0691		; Jump if zero
		inc	bx
		push	bx
		dec	bx
		pop	dx
		mov	ah,[si+1]
		sub	ah,[si]
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0
		push	ds
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	ds,ax
		mov	byte ptr [bx],0
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
;*		or	ah,cl
		db	 08h,0CCh		;  Fixup - byte match
		jz	loc_0688		; Jump if zero
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
loc_0688:
		pop	es
		pop	ds
		mov	byte ptr [si],0
		pop	cx
		pop	dx
		pop	bx
		retn
loc_0691:
		dec	bx
		push	bx
		inc	bx
		pop	dx
		mov	ah,[si]
		sub	ah,[si+1]
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0
		push	ds
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	ds,ax
		mov	byte ptr [bx],0
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
;*		or	ah,cl
		db	 08h,0CCh		;  Fixup - byte match
		jz	loc_0688		; Jump if zero
		xchg	si,bx
		xchg	di,dx
		std				; Set direction flag
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		jmp	short loc_0688
sub_0641	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_06BD	proc	near
		mov	bx,cs:data_B56B
		mov	ch,2
loc_06C4:
		push	cx
		push	bx
		call	sub_06DC
		pop	bx
		push	bx
		add	bx,d_B800_2000_e
		call	sub_06DC
		pop	bx
		add	bx,50h
		pop	cx
		dec	ch
		jnz	loc_06C4		; Jump if not zero
		retn
sub_06BD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_06DC	proc	near
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
		mov	ah,cs:data_B56A
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_070B		; Jump if zero
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		mov	ch,0
		mov	word ptr [bx],0AAh
		inc	dx
		dec	cl
		jz	loc_070B		; Jump if zero
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
loc_070B:
		mov	ah,cs:data_B56A
		and	ah,1Fh
		shr	ah,1			; Shift w/zeros fill
		shr	ah,1			; Shift w/zeros fill
		push	bx
		push	dx
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
		mov	dx,0BC8h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,cs:[bx]
		pop	dx
		pop	bx
		xchg	dx,bx
		mov	[bx],ah
		xchg	dx,bx
		retn
sub_06DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_072E	proc	near
		mov	bx,offset data_B3BD
		mov	dx,0B3BEh
		mov	cx,178h
		mov	word ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_072E	endp

			                        ;* No entry point to code
		mov	bx,0B59Bh
		mov	dx,0B59Ch
		mov	cx,2A7h
		mov	byte ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	bx,0B843h
		mov	dx,0B844h
		mov	cx,2A7h
		mov	byte ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0776	proc	near
		mov	bx,0B843h
		mov	dx,0B844h
		mov	cx,2A7h
		mov	byte ptr [bx],0FFh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_0776	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_078E	proc	near
		mov	ah,data_799E
		mov	bx,d_BA00_BAEF_e
		cmp	ah,[bx]
		je	loc_079A		; Jump if equal
		retn
loc_079A:
		mov	di,d_BA00_B3BD_e
		mov	ah,[di+2]
		add	ah,[di+12h]
		cmp	ah,[di+1Fh]
		je	loc_07A9		; Jump if equal
		retn
loc_07A9:
		mov	ah,[di+7]
		dec	ah
		cmp	ah,[di+1Eh]
		je	loc_07B4		; Jump if equal
		retn
loc_07B4:
		test	byte ptr [si],1
		jnz	loc_07BC		; Jump if not zero
		call	sub_0AA4
loc_07BC:
		or	byte ptr [di],1
		retn
sub_078E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_07C0	proc	near
		call	sub_07D0
		jnz	loc_07C6		; Jump if not zero
		retn
loc_07C6:
		mov	ah,[si+7]
		cmp	ah,[si+24h]
		jb	loc_080B		; Jump if below
		jmp	short loc_0828

;==== External Entry into Subroutine ======================================

sub_07D0:
		test	byte ptr [si+1Dh],80h
		jnz	loc_07D7		; Jump if not zero
		retn
loc_07D7:
		mov	ah,[si+8]
		add	ah,[si+12h]
		cmp	ah,[si+25h]
		jb	loc_07E7		; Jump if below
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_07E7:
		mov	ah,0
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn

;==== External Entry into Subroutine ======================================

sub_07EC:
		test	byte ptr [si+1Dh],80h
		jnz	loc_07F3		; Jump if not zero
		retn
loc_07F3:
		mov	ah,[si+8]
		add	ah,[si+12h]
		cmp	ah,[si+25h]
		jb	loc_07E7		; Jump if below
		jz	loc_07E7		; Jump if zero
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn

;==== External Entry into Subroutine ======================================

sub_0805:
		call	sub_07EC
		jnz	loc_080B		; Jump if not zero
		retn
loc_080B:
		mov	ah,[si+24h]
		sub	ah,[si+7]
		cmp	ah,[si+11h]
		jb	loc_081D		; Jump if below
		jz	loc_081D		; Jump if zero
		mov	ah,0
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_081D:
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn

;==== External Entry into Subroutine ======================================

sub_0822:
		call	sub_07EC
		jnz	loc_0828		; Jump if not zero
		retn
loc_0828:
		mov	ah,[si+7]
		sub	ah,[si+24h]
		cmp	ah,[si+2Eh]
		jb	loc_083A		; Jump if below
		jz	loc_083A		; Jump if zero
		mov	ah,0
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_083A:
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_07C0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_083F	proc	near
		push	di
		push	si
		mov	di,d_BA00_799E_e
		mov	ah,data_BAEF
		mov	[di],ah
		mov	ah,[si+22h]
		mov	[di+1],ah
		mov	ah,[si+23h]
		mov	[di+2],ah
		mov	ah,[si+24h]
		mov	[di+3],ah
		mov	ah,[si+25h]
		mov	[di+4],ah
		mov	ah,data_7995
		mov	[di+5],ah
		mov	ah,data_7996
		mov	[di+6],ah
		pop	si
		pop	di
		retn
sub_083F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0873	proc	near
		mov	si,offset data_799E
		mov	byte ptr [si],1
		mov	byte ptr [si+1],1
		mov	byte ptr [si+2],0
		mov	byte ptr [si+3],1Dh
		mov	byte ptr [si+4],68h	; 'h'
		mov	bx,50h
		mov	data_B570,bx
		mov	bx,0B572h
		mov	cx,4
		call	sub_480C
		mov	ah,30h			; '0'
		mov	bx,offset data_7995
		mov	[bx],ah
		inc	bx
		mov	[bx],ah
		retn
sub_0873	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_08A4	proc	near
		mov	si,offset data_B3BD
		mov	dx,1Dh
		mov	ch,0Dh
loc_08AC:
		test	byte ptr [si],80h
		jz	loc_08B9		; Jump if zero
		test	byte ptr [si],40h	; '@'
		jnz	loc_08B9		; Jump if not zero
		call	sub_0F1C
loc_08B9:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_08AC		; Jump if not zero
		call	sub_062F
		retn
sub_08A4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_08C3	proc	near
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		call	sub_0A92
		mov	ah,data_798E
		mov	data_BAF4,ah
		mov	ah,data_798D
		mov	data_BAF5,ah
		mov	bx,0B572h
		mov	ah,4
		call	sub_481F
		retn
sub_08C3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_08E1	proc	near
		mov	cx,0
		mov	ah,data_798F
		mov	data_BAF4,ah
		mov	ah,data_7990
		mov	data_BAF5,ah
		mov	bx,0B576h
		mov	ah,4
		call	sub_481F
		retn
sub_08E1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_08FD	proc	near
		mov	ah,data_B583
		inc	ah
		mov	data_B583,ah
		cmp	ah,0Ah
		je	loc_090D		; Jump if equal
		retn
loc_090D:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_B583,ah
		mov	si,d_BA00_B3BD_e
		test	byte ptr [si],1
		jz	loc_091C		; Jump if zero
		retn
loc_091C:
		mov	cx,9999h
		mov	bx,data_B570
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
;*		or	ah,bl
		db	 08h,0DCh		;  Fixup - byte match
		jz	loc_0949		; Jump if zero
		mov	bx,0B570h
		mov	ah,data_7991
		mov	data_BAF4,ah
		mov	ah,data_7992
		mov	data_BAF5,ah
		mov	ah,2
		call	sub_481F
		retn

;==== External Entry into Subroutine ======================================

sub_0942:
		mov	bx,offset data_7993
		call	sub_118F
		retn

;==== External Entry into Subroutine ======================================

sub_0949:
loc_0949:
		nop
		mov	ah,byte ptr data_799A+1
		cmp	ah,30h			; '0'
		jne	loc_0962		; Jump if not equal
		mov	ah,byte ptr data_799A
		dec	ah
		mov	byte ptr data_799A,ah
		mov	ah,39h			; '9'
		add	ah,1
loc_0962:
		dec	ah
		mov	byte ptr data_799A+1,ah
		mov	bx,offset data_7998
		call	sub_118F
		call	sub_098A
		mov	ah,ds:d_BA00_799A_e
		cmp	ah,30h			; '0'
		jne	loc_0986		; Jump if not equal
		mov	ah,ds:d_BA00_799B_e
		cmp	ah,30h			; '0'
		jne	loc_0986		; Jump if not equal
		jmp	loc_01E2
loc_0986:
		call	sub_09BC
		retn
sub_08FD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_098A	proc	near
		mov	bx,72C6h
		call	sub_2292
		mov	si,0B3BDh
		mov	byte ptr [si+0Bh],17h
		mov	cl,0
loc_0999:
		push	cx
		mov	si,d_BA00_B3BD_e
		mov	[si+0Ch],cl
		call	sub_0C81
		call	sub_09B1
		pop	cx
		inc	cl
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
		cmp	ah,4
		jne	loc_0999		; Jump if not equal
		retn
sub_098A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_09B1	proc	near
		mov	bx,4000h
loc_09B4:
		dec	bx
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
;*		or	ah,bl
		db	 08h,0DCh		;  Fixup - byte match
		jnz	loc_09B4		; Jump if not zero
		retn
sub_09B1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_09BC	proc	near
		call	sub_08A4
		call	sub_26E4
		call	sub_0A74
		mov	ds:d_BA00_BAEF_e,ah
		mov	di,d_BA00_799E_e
		mov	[di],ah
		mov	byte ptr [di+1],1
		mov	byte ptr [di+2],0
		mov	byte ptr [di+3],1Dh
		mov	byte ptr [di+4],68h	; 'h'
		mov	ah,[di+5]
		mov	ds:d_BA00_7995_e,ah
		mov	ah,[di+6]
		mov	ds:d_BA00_7996_e,ah
		mov	si,d_BA00_B3BD_e
		mov	byte ptr [si+7],1Eh
		mov	byte ptr [si+8],28h	; '('
		mov	byte ptr [si+1],1Eh
		mov	byte ptr [si+2],28h	; '('
		mov	byte ptr [si+0Bh],0
		mov	byte ptr [si+0Ch],0
		mov	byte ptr [si+6],0
		mov	byte ptr [si+5],0
		mov	byte ptr [si],0
		or	byte ptr [si],80h
		or	byte ptr [si],40h	; '@'
		call	sub_0776
		call	sub_24C8
		call	sub_2434
		call	sub_1020
		retn
sub_09BC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A25	proc	near
		nop
		call	sub_0A74
		mov	di,offset data_799E
		mov	[di],ah
		mov	byte ptr [di+1],1
		mov	byte ptr [di+2],0
		mov	byte ptr [di+3],1Dh
		mov	byte ptr [di+4],68h	; 'h'
		mov	bx,offset data_B3DA
		or	byte ptr [bx],10h
		mov	bx,offset data_B3BD
		and	byte ptr [bx],0FEh
		call	sub_0A4E
		retn
sub_0A25	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A4E	proc	near
		mov	ah,17h
		call	sub_0E0F
		mov	di,offset data_852F
		call	sub_255A
		mov	ah,data_B3E1
		mov	[si+7],ah
		mov	[si+1],ah
		mov	ah,data_B3E2
		mov	[si+2],ah
		mov	[si+8],ah
		mov	bx,72C6h
		call	sub_2292
		retn
sub_0A4E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A74	proc	near
		mov	ah,45h			; 'E'
		mov	bx,d_BA00_BAEF_e
		cmp	ah,[bx]
		inc	ah
		jnc	loc_0A80		; Jump if carry=0
		retn
loc_0A80:
		mov	ah,ds:d_BA00_799E_e
		mov	bx,796Ch
loc_0A87:
		cmp	ah,[bx]
		jb	loc_0A8E		; Jump if below
		inc	bx
		jmp	short loc_0A87
loc_0A8E:
		dec	bx
		mov	ah,[bx]
		retn
sub_0A74	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A92	proc	near
		and	ah,0FEh
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
		mov	bx,offset data_7934
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	cl,[bx]
		inc	bx
		mov	ch,[bx]
		retn
sub_0A92	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AA4	proc	near
		mov	bx,d_BA00_7978_e
		mov	cl,[bx]
		mov	ch,0
		inc	bx
		mov	ah,data_BAEF
		call	sub_1109
		jnz	loc_0ABD		; Jump if not zero
		call	sub_0AC3
		jz	loc_0ABD		; Jump if zero
		call	sub_0AE9
loc_0ABD:
		mov	bx,7328h
		jmp	loc_2292
sub_0AA4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AC3	proc	near
		push	si
		push	dx
		push	cx
		mov	ch,0Dh
		mov	dx,1Dh
		mov	si,d_BA00_B3BD_e
loc_0ACE:
		test	byte ptr [si],80h
		jz	loc_0ADB		; Jump if zero
		mov	ah,[si+5]
		cmp	ah,2Ch			; ','
		je	loc_0AE5		; Jump if equal
loc_0ADB:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_0ACE		; Jump if not zero
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
loc_0AE5:
		pop	cx
		pop	dx
		pop	si
		retn
sub_0AC3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AE9	proc	near
		push	si
		push	di
		mov	ah,2Ch			; ','
		call	sub_0E0F
		mov	ah,data_BAEF
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
		mov	dx,786Ch
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		xchg	dx,bx
		mov	dx,5
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		push	bx
		pop	di
		call	sub_0B16
		call	sub_255A
		pop	di
		pop	si
		retn
sub_0AE9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B16	proc	near
		mov	bx,0B7F3h
		mov	dl,[di+3]
		shr	dl,1			; Shift w/zeros fill
		mov	dh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
		inc	dx
		mov	cx,4
		mov	byte ptr [bx],0F5h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_0B16	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B39	proc	near
		mov	bx,7332h
		jmp	loc_2292
sub_0B39	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B3F	proc	near
		mov	ah,ds:d_BA00_BAEF_e
		mov	bx,d_BA00_7978_e
		mov	cl,[bx]
		inc	bx
		mov	ch,0
		call	sub_1109
		jnz	loc_0B82		; Jump if not zero
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,786Ch
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		mov	bx,d_BA00_0008_e
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ch,[bx]
		mov	ah,byte ptr ds:[0B3DBh]
		add	ah,0Ah
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_0B82		; Jump if carry Set
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		add	ah,0Ah
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,byte ptr ds:[0B3DBh]
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_0B82		; Jump if carry=0
		retn
loc_0B82:
		mov	ah,ds:d_BA00_BAEF_e
		mov	bx,d_BA00_7982_e
		mov	cl,[bx]
		inc	bx
		mov	ch,0
		call	sub_1109
		jnz	loc_0BC5		; Jump if not zero
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,786Ch
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		mov	bx,d_BA00_000F_e
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ch,[bx]
		mov	ah,byte ptr ds:[0B3DBh]
		add	ah,0Bh
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_0BC5		; Jump if carry Set
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		add	ah,4
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,byte ptr ds:[0B3DBh]
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_0BC5		; Jump if carry=0
		retn
loc_0BC5:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
sub_0B3F	endp

		db	 00h, 00h, 80h, 80h,0A0h,0A0h
		db	0A8h,0A8h
data_0BD0	db	0F6h
data_0BD1	dw	0FEE6h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0BD3	proc	near
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_BAEF,ah
		call	sub_2434
		call	sub_24C8
		call	sub_1020
		call	sub_0C81
		call	sub_2288
		mov	bx,offset data_B161
		call	sub_118F
		mov	bx,offset data_B16D
		call	sub_118F
		mov	bx,offset data_B17E
		call	sub_118F
		mov	bx,offset data_B18E
		call	sub_118F
		mov	bx,offset data_B1A2
		call	sub_118F
		mov	bx,offset data_B1B4	; ('')
		call	sub_118F
		mov	bx,offset data_B1C4	; ('')
		call	sub_118F
		mov	bx,offset data_B1D8	; ('')
		call	sub_118F
		mov	bx,offset data_B1E7	; ('')
		call	sub_118F
loc_0C1E:
		call	sub_1D8A
		mov	ah,cs:data_1683
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0C2C		; Jump if zero
		jmp	short loc_0C36
loc_0C2C:
		test	byte ptr data_48F9,80h	; key S (start)
		jz	loc_0C1E		; Jump if zero
		call	sub_0C6D
loc_0C36:
		call	sub_1083
		call	sub_26E4
		call	sub_2280
		mov	bx,offset data_B034
		call	sub_11A6
		mov	bx,offset data_B05F
		call	sub_11A6
		mov	bx,offset data_B08A
		call	sub_11A6
		mov	bx,offset data_B0B5
		call	sub_11A6
		mov	bx,offset data_B0E0
		call	sub_11A6
		mov	bx,offset data_B10B
		call	sub_11A6
		mov	bx,offset data_B136
		call	sub_11A6
		call	sub_08E1
		retn
sub_0BD3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0C6D	proc	near
		mov	ah,90h
		mov	byte ptr cs:[949h],ah
		mov	byte ptr cs:[0A25h],ah
		mov	ah,0F6h
		mov	cs:data_0BD0,ah
		retn
sub_0C6D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0C81	proc	near
loc_0C81:
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_B3BD
		mov	ch,0Dh
loc_0C8C:
		test	byte ptr [si],80h
		jz	loc_0C98		; Jump if zero
		push	cx
		push	si
		call	sub_0CA3
		pop	si
		pop	cx
loc_0C98:
		mov	dx,1Dh
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_0C8C		; Jump if not zero
		pop	es
		retn
sub_0C81	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0CA3	proc	near
		test	byte ptr [si],10h
		jz	loc_0CAE		; Jump if zero
		mov	byte ptr [si],0
		jmp	loc_0F1C
loc_0CAE:
		test	byte ptr [si],2
		jnz	loc_0CD1		; Jump if not zero
		call	sub_0D2C
		test	byte ptr [si],40h	; '@'
		jz	loc_0CC2		; Jump if zero
		call	sub_0D08
		and	byte ptr [si],0BFh
		retn
loc_0CC2:
		mov	ah,[si+5]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0D08		; Jump if zero
		test	byte ptr [si],20h	; ' '
		jnz	loc_0CCF		; Jump if not zero
		retn
loc_0CCF:
		jmp	short loc_0D08
loc_0CD1:
		test	byte ptr [si],40h	; '@'
		jnz	loc_0CD9		; Jump if not zero
		call	sub_0F1C
loc_0CD9:
		mov	ah,[si+7]
		mov	[si+1],ah
		mov	ah,[si+8]
		mov	[si+2],ah
		mov	ah,[si+0Bh]
		mov	[si+5],ah
		mov	ah,[si+0Ch]
		mov	[si+6],ah
		mov	byte ptr [si+0Ah],0
		call	sub_0DB7
		mov	[si+0Dh],bl
		mov	[si+0Eh],bh
		call	sub_0DC4
		call	sub_0D08
		and	byte ptr [si],0BFh
		retn

;==== External Entry into Subroutine ======================================

sub_0D08:
loc_0D08:
		mov	dl,[si+0Dh]
		mov	dh,[si+0Eh]
		push	dx
		pop	di
		mov	bl,[si+0Fh]
		mov	bh,[si+10h]
		mov	cl,[si+11h]
		mov	ch,[si+12h]
		mov	ah,[si+5]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0D28		; Jump if not zero
		call	sub_104F
		jmp	short loc_0D28
loc_0D28:
		call	sub_0E4F
		retn

;==== External Entry into Subroutine ======================================

sub_0D2C:
		and	byte ptr [si],0DFh
		mov	byte ptr [si+0Ah],0
		call	sub_0DB7
		mov	[si+0Dh],bl
		mov	[si+0Eh],bh
		mov	ah,[si+7]
		cmp	ah,[si+1]
		je	loc_0D59		; Jump if equal
		jc	loc_0D4C		; Jump if carry Set
		or	byte ptr [si+0Ah],80h
		jmp	short loc_0D50
loc_0D4C:
		or	byte ptr [si+0Ah],40h	; '@'
loc_0D50:
		mov	ah,[si+7]
		mov	[si+1],ah
		or	byte ptr [si],20h	; ' '
loc_0D59:
		mov	ah,[si+8]
		cmp	ah,[si+2]
		je	loc_0D88		; Jump if equal
		jc	loc_0D72		; Jump if carry Set
		or	byte ptr [si+0Ah],10h
		mov	ah,[si+8]
		sub	ah,[si+2]
		mov	[si+4],ah
		jmp	short loc_0D7F
loc_0D72:
		or	byte ptr [si+0Ah],20h	; ' '
		mov	ah,[si+2]
		sub	ah,[si+8]
		mov	[si+4],ah
loc_0D7F:
		mov	ah,[si+8]
		mov	[si+2],ah
		or	byte ptr [si],20h	; ' '
loc_0D88:
		mov	ah,[si+0Ch]
		cmp	ah,[si+6]
		je	loc_0D96		; Jump if equal
		mov	[si+6],ah
		or	byte ptr [si],20h	; ' '
loc_0D96:
		mov	ah,[si+0Bh]
		cmp	ah,[si+5]
		je	loc_0DA4		; Jump if equal
		mov	[si+5],ah
		or	byte ptr [si],20h	; ' '
loc_0DA4:
		test	byte ptr [si],20h	; ' '
		jz	loc_0DAC		; Jump if zero
		call	sub_0DC4
loc_0DAC:
		test	byte ptr [si],40h	; '@'
		jnz	loc_0DB2		; Jump if not zero
		retn
loc_0DB2:
		mov	byte ptr [si+0Ah],0
		retn

;==== External Entry into Subroutine ======================================

sub_0DB7:
		mov	bl,[si+8]
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		retn

;==== External Entry into Subroutine ======================================

sub_0DC4:
		mov	ah,[si+5]
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
		mov	dx,714Ah
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		mov	ah,[si+6]
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
		mov	bh,0
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		xchg	dx,bx
		mov	ah,[bx]
		mov	[si+11h],ah
		inc	bx
		mov	ah,[bx]
		mov	[si+12h],ah
		inc	bx
		mov	[si+0Fh],bl
		mov	[si+10h],bh
		retn

;==== External Entry into Subroutine ======================================

sub_0DFC:
loc_0DFC:
		mov	ah,[si+1]
		add	ah,[si+16h]
		mov	[si+7],ah
		mov	ah,[si+2]
		add	ah,[si+17h]
		mov	[si+8],ah
		retn

;==== External Entry into Subroutine ======================================

sub_0E0F:
		push	bx
		push	dx
		push	cx
		mov	si,offset data_B3BD
		mov	ch,0Ah
		mov	dx,1Dh
		cmp	ah,1
		je	loc_0E3A		; Jump if equal
		cmp	ah,0
		je	loc_0E34		; Jump if equal
		cmp	ah,15h
		je	loc_0E3E		; Jump if equal
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
loc_0E2F:
		test	byte ptr [si],80h
		jnz	loc_0E44		; Jump if not zero
loc_0E34:
		pop	cx
		pop	dx
		pop	bx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_0E3A:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		jmp	short loc_0E34
loc_0E3E:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		jmp	short loc_0E34
loc_0E44:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_0E2F		; Jump if not zero
		pop	cx
		pop	dx
		pop	bx
		stc				; Set carry flag
		retn

;==== External Entry into Subroutine ======================================

sub_0E4F:
		mov	ah,1
		mov	data_B536,ah
		mov	ah,[si+5]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_0E66		; Jump if not zero
		mov	ah,data_B536
		inc	ah
		mov	data_B536,ah
loc_0E66:
		test	byte ptr [si+0Ah],10h
		jz	loc_0E6F		; Jump if zero
		call	sub_0EFB
loc_0E6F:
		push	cx
		mov	dl,[di]
		inc	di
		mov	dh,[di]
		inc	di
		push	bx
		mov	bl,[si+1]
		mov	bh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		xchg	dx,bx
		pop	bx
		mov	ch,0
		test	byte ptr [si+0Ah],80h
		jz	loc_0E8C		; Jump if zero
		call	sub_0EAC
loc_0E8C:
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		test	byte ptr [si+0Ah],40h	; '@'
		jz	loc_0EA0		; Jump if zero
		call	sub_0ECD
loc_0EA0:
		pop	cx
		dec	ch
		jnz	loc_0E6F		; Jump if not zero
		test	byte ptr [si+0Ah],20h	; ' '
		jnz	loc_0EEC		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_0EAC:
		test	byte ptr [si+0Ah],20h	; ' '
		jz	loc_0EC1		; Jump if zero
		mov	ah,data_B536
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0EC1		; Jump if zero
		dec	ah
		mov	data_B536,ah
		retn
loc_0EC1:
		dec	dx
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		xchg	dx,bx
		mov	es:[bx],ah
		xchg	dx,bx
		inc	dx
		retn

;==== External Entry into Subroutine ======================================

sub_0ECD:
		test	byte ptr [si+0Ah],20h	; ' '
		jz	loc_0EE2		; Jump if zero
		mov	ah,data_B536
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_0EE2		; Jump if zero
		dec	ah
		mov	data_B536,ah
		retn
loc_0EE2:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		xchg	dx,bx
		mov	es:[bx],ah
		xchg	dx,bx
		retn
loc_0EEC:
		test	byte ptr [si],40h	; '@'
		jz	loc_0EF2		; Jump if zero
		retn
loc_0EF2:
		mov	ch,[si+4]
		mov	cl,[si+11h]
		jmpn	loc_0F71

;==== External Entry into Subroutine ======================================

sub_0EFB:
		test	byte ptr [si],40h	; '@'
		jz	loc_0F01		; Jump if zero
		retn
loc_0F01:
		push	bx
		push	dx
		push	cx
		push	di
		mov	ch,[si+4]
loc_0F08:
		dec	di
		dec	di
		dec	ch
		jnz	loc_0F08		; Jump if not zero
		mov	ch,[si+4]
		mov	cl,[si+11h]
		call	sub_0F71
		pop	di
		pop	cx
		pop	dx
		pop	bx
		retn

;==== External Entry into Subroutine ======================================

sub_0F1C:
loc_0F1C:
		push	es
		mov	ax,0B800h
		mov	es,ax
		push	si
		push	dx
		push	cx
		mov	dl,[si+0Dh]
		mov	dh,[si+0Eh]
		push	dx
		pop	di
		mov	bl,[si+0Fh]
		mov	bh,[si+10h]
		mov	cl,[si+11h]
		dec	cl
		mov	ch,[si+12h]
		call	sub_0F43
		pop	cx
		pop	dx
		pop	si
		pop	es
		retn

;==== External Entry into Subroutine ======================================

sub_0F43:
loc_0F43:
		push	cx
		mov	dl,[di]
		inc	di
		mov	dh,[di]
		inc	di
		mov	bl,[si+1]
		mov	bh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		push	bx
		pop	dx
		inc	dx
		push	ds
		mov	ax,0B800h
		mov	ds,ax
		mov	byte ptr [bx],0
		mov	ch,0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	ds
		pop	cx
		dec	ch
		jnz	loc_0F43		; Jump if not zero
		retn

;==== External Entry into Subroutine ======================================

sub_0F71:
loc_0F71:
		push	cx
		mov	dl,[di]
		inc	di
		mov	dh,[di]
		inc	di
		mov	bl,[si+1]
		mov	bh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		test	byte ptr [si+0Ah],80h
		jz	loc_0F86		; Jump if zero
		dec	bx
loc_0F86:
		test	byte ptr [si+0Ah],40h	; '@'
		jz	loc_0F8D		; Jump if zero
		inc	bx
loc_0F8D:
		push	bx
		pop	dx
		inc	dx
		mov	byte ptr es:[bx],0
		mov	ch,0
		dec	cl
		push	ds
		mov	ax,0B800h
		mov	ds,ax
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	ds
		pop	cx
		dec	ch
		jnz	loc_0F71		; Jump if not zero
		retn
sub_0CA3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FB0	proc	near
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		call	sub_0FB9
		retn
sub_0FB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FB9	proc	near
		mov	bx,101h
		mov	data_48FF,bl
		mov	ax,0B00h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		retn
sub_0FB9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FC6	proc	near
		mov	byte ptr data_B585,0
		test	byte ptr data_48F2,80h	; key Q (up)
		jz	loc_0FD7		; Jump if zero
		or	byte ptr data_B585,1
loc_0FD7:
		test	byte ptr data_48F3,80h	; key A (down)
		jz	loc_0FE3		; Jump if zero
		or	byte ptr data_B585,2
loc_0FE3:
		test	byte ptr data_48F0,80h	; key O (left)
		jz	loc_0FEF		; Jump if zero
		or	byte ptr data_B585,4
loc_0FEF:
		test	byte ptr data_48F1,80h	; key P (right)
		jz	loc_0FFB		; Jump if zero
		or	byte ptr data_B585,8
loc_0FFB:
		test	byte ptr data_48F4,80h	; key Space (shooting)
		jz	loc_1007		; Jump if zero
		or	byte ptr data_B585,10h
loc_1007:
		test	byte ptr data_48F5,80h	; key SCrollLock or Break (exit)
		jz	loc_1013		; Jump if zero
		or	byte ptr data_B585,20h	; ' '
loc_1013:
		test	byte ptr data_48F6,80h	; key Enter
		jz	loc_ret_101F		; Jump if zero
		or	byte ptr data_B585,40h	; '@'

loc_ret_101F:
		retn
sub_0FC6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1020	proc	near
		mov	di,d_BA00_B59B_e
		mov	si,d_BA00_B843_e
		mov	bx,0
loc_1029:
		mov	al,[di]
		cmpsb				; Cmp [si] to es:[di]
		jz	loc_1037		; Jump if zero
		mov	ah,0
		push	si
		push	di
		call	sub_10A7
		pop	di
		pop	si
loc_1037:
		inc	bl
		cmp	bl,28h			; '('
		jne	loc_1029		; Jump if not equal
		mov	bl,0
		inc	bh
		cmp	bh,11h
		jne	loc_1029		; Jump if not equal
		mov	byte ptr ds:d_BA00_4900_e,1
		retn
sub_1020	endp

		db	0C3h,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_104F	proc	near
		push	dx
		push	ax
		mov	dx,700h
loc_1054:
		dec	dx
		jnz	loc_1054		; Jump if not zero
		mov	dx,700h
loc_105A:
		dec	dx
		jnz	loc_105A		; Jump if not zero
		nop
		pop	ax
		pop	dx
		retn
sub_104F	endp

			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		retn
		db	 00h, 00h, 14h, 10h, 15h, 1Ch
		db	 18h, 1Dh, 0Ch, 05h, 0Dh, 16h
		db	 06h, 17h, 1Eh, 00h, 1Fh, 0Eh
		db	 07h, 0Fh, 1Ah, 19h, 13h, 12h
		db	 02h, 09h, 0Ah, 03h, 0Bh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1083	proc	near
		push	es
		push	ds
		mov	ax,0B800h
		mov	es,ax
		mov	ds,ax
		mov	bx,d_B800_0000_e
		mov	dx,1
		mov	cx,3FFFh
		mov	word ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	ds
		pop	es
		retn
sub_1083	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10A7	proc	near
		push	si
		push	di
		push	ax
		push	cx
		push	dx
		push	bx
		push	es
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		add	ax,592Eh
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		jmp	short $+2		; delay for I/O
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

locloop_10D3:
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		loop	locloop_10D3		; Loop if cx > 0

		pop	es
		pop	bx
		pop	dx
		pop	cx
		pop	ax
		pop	di
		pop	si
		retn
sub_10A7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10E7	proc	near
		cmp	ah,5Ah			; 'Z'
		je	loc_10F7		; Jump if equal
		jc	loc_10EF		; Jump if carry Set
		retn
loc_10EF:
		cmp	ah,20h			; ' '
		jne	loc_10F7		; Jump if not equal
		mov	ah,0
		retn
loc_10F7:
		cmp	ah,41h			; 'A'
		jb	loc_1103		; Jump if below
		sub	ah,41h			; 'A'
		add	ah,0Ch
		retn
loc_1103:
		sub	ah,30h			; '0'
		inc	ah
		retn
sub_10E7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1109	proc	near

locloop_1109:
		cmp	ah,[bx]
		je	loc_1114		; Jump if equal
		inc	bx
		loop	locloop_1109		; Loop if cx > 0

		cmp	ah,[bx-1]
		retn
loc_1114:
		pushf				; Push flags
		inc	bx
		dec	cx
		popf				; Pop flags
		retn
sub_1109	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1119	proc	near
loc_1119:
		push	si
		push	di
		push	bx
		push	dx
		push	cx
		push	ax
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		xchg	dx,bx
		pop	ax
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		push	dx
		mov	dx,4901h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		pop	di
		xchg	si,bx
		mov	ax,0B800h
		push	es
		mov	es,ax
		cld				; Clear direction
		mov	cx,4

locloop_1163:
		movsw				; Mov [si] to es:[di]
		add	di,d_B800_1FFE_e
		movsw				; Mov [si] to es:[di]
		sub	di,1FB2h
		loop	locloop_1163		; Loop if cx > 0

		pop	es
		pop	cx
		pop	dx
		pop	bx
		pop	di
		pop	si
		retn
sub_1119	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1176	proc	near
		push	ax
		mov	ah,data_BAF4
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	ah
		mov	data_BAF4,ah
		mov	ah,data_BAF5
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		pop	ax
		call	sub_10E7
		jmp	short loc_1119
sub_1176	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_118F	proc	near
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
loc_1194:
		inc	bx
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_119C		; Jump if not zero
		retn
loc_119C:
		call	sub_10E7
		call	sub_1119
		inc	ch
		jmp	short loc_1194
sub_118F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_11A6	proc	near
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
loc_11AB:
		inc	bx
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_11B3		; Jump if not zero
		retn
loc_11B3:
		call	sub_1119
		inc	ch
		jmp	short loc_11AB
sub_11A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_11BA	proc	near
		call	sub_11DB
;*		mov	bl,ch
		db	 88h,0EBh		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ch,0
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	dx,0B59Bh
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		retn
sub_11BA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_11DB	proc	near
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		and	ah,0F8h
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	data_BAF1,ah
		shr	bl,1			; Shift w/zeros fill
;*		mov	cl,bl
		db	 88h,0D9h		;  Fixup - byte match
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
		mov	data_BAF0,ah
		retn
sub_11DB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_11F7	proc	near
		mov	ah,data_BAEF
		mov	bx,d_BA00_7860_e
		mov	cl,[bx]
		mov	ch,0
		inc	bx
		call	sub_1109
		jnz	loc_121D		; Jump if not zero
		mov	si,d_BA00_B3BD_e
		test	byte ptr [si],1
		jz	loc_121D		; Jump if zero
		mov	ah,[si+7]
		cmp	ah,38h			; '8'
		jne	loc_121D		; Jump if not equal
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_121D:
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+7]
		test	byte ptr [si],1
		jz	loc_122B		; Jump if zero
		add	ah,2
loc_122B:
		add	ah,[si+11h]
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	data_B57A,ah
		cmp	ah,4Fh			; 'O'
		jb	loc_123E		; Jump if below
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_123E:
		mov	bh,[si+8]
		call	sub_11BA
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_124B		; Jump if zero
		retn
loc_124B:
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1257		; Jump if zero
		retn
loc_1257:
		mov	ah,[si+8]
		add	ah,[si+12h]
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		mov	ah,data_B57A
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		call	sub_11BA
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_11F7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_126D	proc	near
		mov	si,0B3BDh
		mov	ah,ds:d_BA00_BAEF_e
		mov	bx,d_BA00_7866_e
		mov	cl,[bx]
		mov	ch,0
		inc	bx
		call	sub_1109
		jnz	loc_1296		; Jump if not zero
		mov	si,d_BA00_B3BD_e
		test	byte ptr [si],1
		jz	loc_1296		; Jump if zero
		mov	ah,[si+7]
		cmp	ah,10h
		jne	loc_1296		; Jump if not equal
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_1296:
		mov	ah,[si+7]
		test	byte ptr [si],1
		jz	loc_12A1		; Jump if zero
		sub	ah,1
loc_12A1:
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	byte ptr ds:[0B57Ah],ah
		cmp	ah,1
		jae	loc_12B1		; Jump if above or =
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_12B1:
		mov	bh,[si+8]
		call	sub_11BA
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_12BE		; Jump if zero
		retn
loc_12BE:
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_12CA		; Jump if zero
		retn
loc_12CA:
		mov	ah,[si+8]
		add	ah,[si+12h]
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		mov	ah,byte ptr ds:[0B57Ah]
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		call	sub_11BA
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_126D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_12E0	proc	near
		mov	si,d_BA00_B3BD_e
		test	byte ptr [si],1
		jz	loc_12EB		; Jump if zero
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
loc_12EB:
		mov	bl,[si+7]
		mov	bh,[si+8]
		call	sub_11BA
loc_12F4:
		mov	ch,[si+11h]
		shr	ch,1			; Shift w/zeros fill
loc_12F9:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1300		; Jump if zero
		retn
loc_1300:
		call	sub_132B
		jnz	loc_1306		; Jump if not zero
		retn
loc_1306:
		inc	bx
		dec	ch
		jnz	loc_12F9		; Jump if not zero
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_12E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1310	proc	near
		mov	si,d_BA00_B3BD_e
		test	byte ptr [si],1
		jz	loc_131B		; Jump if zero
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
loc_131B:
		mov	bl,[si+7]
		mov	ah,[si+8]
		add	ah,[si+12h]
;*		mov	bh,ah
		db	 88h,0E7h		;  Fixup - byte match
		call	sub_11BA
		jmp	short loc_12F4
sub_1310	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_132B	proc	near
		mov	ah,data_BAF0
		inc	ah
		mov	data_BAF0,ah
		cmp	ah,28h			; '('
		jb	loc_133F		; Jump if below
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_133F:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_132B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1342	proc	near
loc_1342:
		mov	si,offset data_B3BD
		mov	ah,[si+1]
		mov	[si+7],ah
		test	byte ptr [si],1
		jnz	loc_1351		; Jump if not zero
		retn
loc_1351:
		mov	ah,[si+1Eh]
		mov	[si+24h],ah
		call	sub_083F
		retn
sub_1342	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_135B	proc	near
loc_135B:
		mov	si,offset data_B3BD
		mov	ah,[si+2]
		mov	[si+8],ah
		test	byte ptr [si],1
		jnz	loc_136A		; Jump if not zero
		retn
loc_136A:
		mov	ah,[si+1Fh]
		mov	[si+25h],ah
		call	sub_083F
		retn
sub_135B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1374	proc	near
		inc	ch
		mov	ah,[si+0Ch]
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jc	loc_1381		; Jump if carry Set
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jc	loc_139D		; Jump if carry Set
loc_1381:
;*		mov	ah,cl
		db	 88h,0CCh		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_138E		; Jump if zero
		mov	ah,[si+0Ch]
;*		add	ah,cl
		db	 00h,0CCh		;  Fixup - byte match
		jmp	short loc_1393
loc_138E:
		mov	ah,[si+0Ch]
;*		sub	ah,ch
		db	 28h,0ECh		;  Fixup - byte match
loc_1393:
		mov	[si+0Ch],ah
		mov	byte ptr [si+18h],0
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
loc_139D:
		mov	ah,[si+18h]
;*		cmp	ah,dl
		db	 38h,0D4h		;  Fixup - byte match
		jnc	loc_13A7		; Jump if carry=0
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		retn
loc_13A7:
		mov	ah,[si+0Ch]
		inc	ah
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_13BA		; Jump if carry=0
		mov	[si+0Ch],ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si+18h],ah
		stc				; Set carry flag
		retn
loc_13BA:
		dec	ch
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		mov	[si+0Ch],cl
		mov	byte ptr [si+18h],0
		stc				; Set carry flag
		retn
sub_1374	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_13C7	proc	near
		push	bx
		push	dx
		mov	dx,data_BAF2
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
		jnc	loc_13E6		; Jump if carry=0
		inc	bx
loc_13E6:
		mov	data_BAF2,bx
;*		mov	ah,bl
		db	 88h,0DCh		;  Fixup - byte match
		pop	dx
		pop	bx
		retn
sub_13C7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_13EF	proc	near
		mov	ah,[si+5]
		cmp	ah,2Ah			; '*'
		jne	loc_13FA		; Jump if not equal
		jmp	loc_2A41
loc_13FA:
		cmp	ah,20h			; ' '
		jne	loc_1405		; Jump if not equal
		call	sub_29AF
		jnc	loc_1405		; Jump if carry=0
		retn
loc_1405:
		mov	bl,[si+19h]
		mov	bh,[si+1Ah]
		push	bx
		mov	dl,[bx]
		test	byte ptr [si+16h],80h
		jz	loc_1416		; Jump if zero
		inc	bx
		inc	bx
loc_1416:
		inc	bx
		mov	cl,[bx]
		inc	bx
		mov	ch,[bx]
		call	sub_1374
		pop	di
		jc	loc_1423		; Jump if carry Set
		retn
loc_1423:
		mov	dx,5
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	bl,[di]
		mov	bh,[di+1]
		jmp	bx			;*Register jump
sub_13EF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_142F	proc	near
		mov	bx,0
		mov	ch,8
loc_1434:
		rcr	ah,1			; Rotate thru carry
		jnc	loc_143A		; Jump if carry=0
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
loc_143A:
		rcl	dl,1			; Rotate thru carry
		rcl	dh,1			; Rotate thru carry
		dec	ch
		jnz	loc_1434		; Jump if not zero
		retn
sub_142F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1443	proc	near
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,cl
		db	 08h,0CCh		;  Fixup - byte match
		jz	loc_1476		; Jump if zero
		mov	ch,10h
		mov	dx,0
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
loc_1450:
		rcl	bl,1			; Rotate thru carry
		rcl	bh,1			; Rotate thru carry
		rcl	dl,1			; Rotate thru carry
		rcl	dh,1			; Rotate thru carry
		push	bx
		push	cx
		mov	ch,0
;*		mov	bh,dh
		db	 88h,0F7h		;  Fixup - byte match
;*		mov	bl,dl
		db	 88h,0D3h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,cx
		db	 19h,0CBh		;  Fixup - byte match
		cmc				; Complement carry
		jnc	loc_146B		; Jump if carry=0
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
loc_146B:
		pop	cx
		pop	bx
		dec	ch
		jnz	loc_1450		; Jump if not zero
		rcl	bl,1			; Rotate thru carry
		rcl	bh,1			; Rotate thru carry
		retn
loc_1476:
		mov	bx,0FFFFh
		retn
sub_1443	endp

			                        ;* No entry point to code
		call	sub_0C81
		call	sub_2288
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	cs:data_158C,ah
		mov	cs:data_158D,ah
		call	sub_1545
		mov	bx,data_00B0_e
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		mov	cs:data_1588,dx
loc_14A3:
		mov	bx,0B1F9h
		mov	cs:data_158A,bx
loc_14AB:
		call	sub_104F
		mov	bx,cs:data_1588
		inc	bx
		mov	ch,4
loc_14B6:
		push	bx
		call	sub_1507
		mov	dx,2000h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		call	sub_1507
		pop	bx
		mov	dx,50h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		dec	ch
		jnz	loc_14B6		; Jump if not zero
		mov	ah,cs:data_158C
		inc	ah
		mov	cs:data_158C,ah
		test	ah,1
		jz	loc_14AB		; Jump if zero
		mov	bx,cs:data_158A
		mov	ah,[bx]
		cmp	ah,2Fh			; '/'
		je	loc_152C		; Jump if equal
loc_14E9:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_14A3		; Jump if zero
		inc	bx
		mov	cs:data_158A,bx
		mov	ch,26h			; '&'
		mov	cl,16h
		call	sub_10E7
		call	sub_1119
		test	byte ptr data_48F5,80h	; key SCrollLock or Break (exit)
		jz	loc_14AB		; Jump if zero
		jmp	loc_012D

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1507	proc	near
		push	ds
		push	es
		push	ax
		mov	ax,0B800h
		mov	ds,ax
		mov	es,ax
		pop	ax
		push	cx
		push	bx
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
		dec	dx
		mov	cx,4Eh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	bx
		pop	cx
		pop	es
		pop	ds
		retn
sub_1507	endp

loc_152C:
		mov	ah,cs:data_158D
		cmp	ah,1
		jne	loc_1539		; Jump if not equal
		jmp	loc_01E2
loc_1539:
		inc	ah
		mov	cs:data_158D,ah
		inc	bx
		mov	ah,[bx]
		jmp	short loc_14E9

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1545	proc	near
		mov	ah,0C7h
loc_1547:
		call	sub_1554
		dec	ah
		cmp	ah,8Fh
		jne	loc_1552		; Jump if not equal
		retn
loc_1552:
		jmp	short loc_1547
sub_1545	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1554	proc	near
		push	ax
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
;*		mov	bl,dl
		db	 88h,0D3h		;  Fixup - byte match
;*		mov	bh,dh
		db	 88h,0F7h		;  Fixup - byte match
		inc	dx
		mov	cx,4Fh
		push	ds
		push	es
		mov	ax,0B800h
		mov	ds,ax
		mov	es,ax
		mov	byte ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	es
		pop	ds
		pop	ax
		retn
sub_1554	endp

data_1588	dw	0
data_158A	dw	0
data_158C	db	0
data_158D	db	0
		db	'AQUI HAY QUE POKEAR'

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_15A1	proc	near
		mov	ah,cs:data_1683
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		nop
		nop
		jz	loc_ret_15D6		; Jump if zero
		test	byte ptr data_48F5,80h	; key SCrollLock or Break (exit)
		jz	loc_15BD		; Jump if zero
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,20h			; ' '
		mov	data_B585,ah
		retn
loc_15BD:
		mov	ah,cs:data_1684
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_15D7		; Jump if zero
		dec	ah
		mov	cs:data_1684,ah
		mov	ah,cs:data_1685
		mov	data_B585,ah

loc_ret_15D6:
		retn
loc_15D7:
		mov	bx,cs:data_1686
		mov	ah,[bx]
		dec	ah
		mov	cs:data_1684,ah
		inc	bx
		mov	ah,[bx]
		mov	cs:data_1685,ah
		inc	bx
		mov	cs:data_1686,bx
		mov	data_B585,ah
		retn
sub_15A1	endp

			                        ;* No entry point to code
		mov	ah,data_B585
		mov	bx,offset data_1685
		cmp	ah,[bx]
		je	loc_166B		; Jump if equal
loc_1603:
		mov	bx,cs:data_1686
		inc	bx
		inc	bx
		mov	cs:data_1686,bx
		mov	dx,1688h
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
		cmp	ah,7
		jne	loc_1655		; Jump if not equal
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		or	ah,20h			; ' '
		mov	bx,cs:data_1686
		mov	byte ptr [bx],1
		inc	bx
		mov	[bx],ah
		mov	data_B585,ah
		mov	ax,cs
		mov	es,ax
		mov	bx,100h
		mov	dl,10h
		mov	ch,0Eh
		mov	cl,1
loc_163E:
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
		jnz	loc_163E		; Jump if not zero
		jmp	start
loc_1655:
		mov	ah,1
		mov	bx,cs:data_1686
		mov	[bx],ah
		mov	ah,data_B585
		inc	bx
		mov	cs:data_1685,ah
		mov	[bx],ah
		retn
loc_166B:
		mov	bx,cs:data_1686
		mov	ah,[bx]
		inc	ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1603		; Jump if zero
		mov	[bx],ah
		inc	bx
		mov	ah,cs:data_1685
		mov	[bx],ah
		retn
data_1683	db	0
data_1684	db	0
data_1685	db	1
data_1686	dw	1D88h
		db	 16h, 00h, 0Eh, 02h, 0Dh, 00h
		db	 05h, 04h, 35h, 00h, 06h, 01h
		db	 07h, 00h, 0Ch, 02h, 2Eh, 08h
		db	 02h, 10h, 16h, 11h, 05h, 10h
		db	 14h, 12h, 01h, 02h, 0Fh, 00h
		db	 43h, 08h, 11h, 00h, 0Bh, 10h
		db	 05h, 00h, 20h, 08h, 01h, 09h
		db	 1Bh, 01h, 01h, 11h, 15h, 10h
		db	 0Fh, 11h, 0Bh, 10h, 09h, 00h
		db	 02h, 10h, 09h, 14h, 0Bh, 10h
		db	 03h, 00h, 04h, 10h, 06h, 14h
		db	 06h, 10h, 13h, 00h, 31h, 08h
		db	 02h, 10h, 0Dh, 11h, 05h, 10h
		db	 13h, 02h, 01h, 00h, 23h, 08h
		db	 03h, 0Ch, 08h, 04h, 02h, 14h
		db	 02h, 10h, 0Eh, 11h, 07h, 10h
		db	 02h, 12h, 0Fh, 02h, 0Fh, 00h
		db	 16h, 04h, 03h, 05h, 02h, 01h
		db	 04h, 09h, 0Bh, 08h, 10h, 0Ah
		db	 03h, 1Ah, 08h, 12h, 03h, 10h
		db	 50h, 00h, 08h, 10h, 20h, 00h
		db	 1Eh, 01h, 05h, 09h, 13h, 01h
		db	 04h, 09h, 18h, 08h, 01h, 09h
		db	 01h, 0Dh, 0Dh, 05h, 01h, 01h
		db	 10h, 11h, 0Ch, 10h, 08h, 00h
		db	 09h, 01h, 03h, 00h, 0Ah, 10h
		db	 09h, 00h, 0Bh, 08h, 0Ch, 09h
		db	 03h, 11h, 05h, 10h, 16h, 12h
		db	 1Dh, 11h, 03h, 10h, 05h, 00h
		db	 26h, 08h, 2Ch, 09h, 0Fh, 08h
		db	 04h, 18h, 08h, 10h, 0Ah, 14h
		db	 0Bh, 10h, 05h, 14h, 06h, 10h
		db	 17h, 00h, 19h, 04h, 01h, 0Dh
		db	 07h, 09h, 03h, 19h, 12h, 11h
		db	 04h, 19h, 10h, 08h, 08h, 00h
		db	 29h, 10h, 05h, 11h, 0Ch, 01h
		db	 03h, 00h, 0Fh, 10h, 01h, 00h
		db	 15h, 08h, 21h, 09h, 31h, 08h
		db	 0Ah, 0Ah, 03h, 02h, 14h, 06h
		db	 07h, 02h, 0Eh, 00h, 0Fh, 10h
		db	 06h, 11h, 0Fh, 10h, 01h, 00h
		db	 1Ch, 04h, 07h, 05h, 16h, 01h
		db	 06h, 11h, 01h, 15h, 07h, 14h
		db	 03h, 10h, 0Ah, 18h, 06h, 19h
		db	 04h, 11h, 10h, 10h, 15h, 00h
		db	 0Dh, 05h, 04h, 01h, 08h, 00h
		db	 0Ch, 01h, 09h, 00h, 11h, 10h
		db	 02h, 00h, 01h, 10h, 09h, 11h
		db	 0Bh, 10h, 16h, 00h, 0Ah, 04h
		db	 0Eh, 05h, 1Ah, 10h, 0Bh, 11h
		db	 0Ah, 10h, 02h, 11h, 0Bh, 10h
		db	 13h, 00h, 17h, 04h, 0Fh, 05h
		db	 34h, 04h, 02h, 00h, 0Ah, 01h
		db	 01h, 11h, 08h, 10h, 02h, 00h
		db	 1Ah, 04h, 0Bh, 05h, 0Ah, 09h
		db	 09h, 11h, 0Bh, 10h, 02h, 18h
		db	 03h, 19h, 04h, 11h, 14h, 10h
		db	 0Ah, 12h, 03h, 10h, 0Ch, 11h
		db	 07h, 10h, 13h, 00h, 06h, 01h
		db	 12h, 00h, 09h, 01h, 05h, 00h
		db	 0Ah, 04h, 06h, 05h, 06h, 04h
		db	 19h, 10h, 07h, 00h, 1Fh, 04h
		db	 15h, 01h, 01h, 00h, 0Ah, 10h
		db	 01h
data_1803	dw	1B00h			; Data table (indexed access)
		db	 04h, 05h, 08h, 0Bh, 18h, 38h
		db	 08h, 01h, 10h, 1Bh, 11h, 0Fh
		db	 10h, 10h, 12h, 0Dh, 02h, 0Ah
		db	 00h, 0Bh, 10h, 05h, 00h, 43h
		db	 08h, 1Ah, 11h, 17h, 10h, 08h
		db	 12h, 12h, 02h, 02h, 0Ah, 41h
		db	 08h, 16h, 11h, 09h, 10h, 0Ch
		db	 12h, 1Ah, 11h, 01h, 10h, 0Bh
		db	 12h, 17h, 02h, 0Ah, 00h, 30h
		db	 08h, 04h, 00h, 06h, 08h, 34h
		db	 00h, 05h, 04h, 27h, 00h, 05h
		db	 04h, 2Ah, 00h, 02h, 04h, 28h
		db	 00h, 03h, 08h, 29h, 00h, 02h
		db	 08h, 5Dh, 00h, 03h, 08h, 1Fh
		db	 00h, 04h, 04h, 20h, 00h, 02h
		db	 08h, 24h, 00h, 08h, 01h, 03h
		db	 00h, 12h, 02h, 09h, 00h, 0Fh
		db	 08h, 01h, 04h, 18h, 00h, 06h
		db	 04h, 08h, 00h, 46h, 04h, 0Eh
		db	 11h, 05h, 10h, 0Bh, 12h, 06h
		db	 02h, 04h, 00h, 09h, 04h, 05h
		db	 00h, 09h, 01h, 16h, 09h, 18h
		db	 08h, 2Fh, 0Ah, 16h, 06h, 05h
		db	 02h, 04h, 00h, 14h, 10h, 0Bh
		db	 11h, 16h, 10h, 0Ch, 04h, 07h
		db	 05h, 0Eh, 01h, 0Ah, 11h, 12h
		db	 10h, 10h, 00h, 0Fh, 01h, 01h
		db	 00h, 0Ah, 10h, 0Bh, 00h, 19h
		db	 04h, 13h, 05h, 01h, 04h, 1Ch
		db	 10h, 0Ch, 11h, 11h, 10h, 05h
		db	 00h, 21h, 04h, 64h, 00h, 06h
		db	 01h, 2Fh, 11h, 1Ah, 01h, 0Dh
		db	 09h, 04h, 01h, 0Ch, 05h, 0Eh
		db	 01h, 0Dh, 09h, 02h, 01h, 10h
		db	 05h, 0Fh, 11h, 07h, 01h, 0Eh
		db	 09h, 19h, 01h, 06h, 11h, 22h
		db	 10h, 1Bh, 11h, 2Ch, 00h, 1Ch
		db	 10h, 01h, 11h, 07h, 01h, 06h
		db	 00h, 04h, 01h, 12h, 00h, 05h
		db	 10h, 01h, 11h, 0Bh, 01h, 03h
		db	 09h, 15h, 08h, 0Dh, 00h, 46h
		db	 04h, 02h, 10h, 21h, 11h, 0Ch
		db	 10h, 06h, 00h, 1Fh, 02h, 01h
		db	 06h, 42h, 04h, 0Bh, 10h, 11h
		db	 11h, 10h, 10h, 09h, 11h, 0Ah
		db	 10h, 03h, 00h, 0Dh, 02h, 03h
		db	 06h, 40h, 04h, 14h, 11h, 18h
		db	 10h, 06h, 11h, 12h, 00h, 08h
		db	 02h, 01h, 06h, 42h, 04h, 02h
		db	 10h, 0Ch, 11h, 0Ah, 10h, 09h
		db	 12h, 0Bh, 02h, 0Dh, 00h, 20h
		db	 04h, 40h, 00h, 07h, 01h, 02h
		db	 11h, 0Ah, 10h, 02h, 00h, 0Eh
		db	 02h, 28h, 00h, 23h, 04h, 17h
		db	 11h, 18h, 10h, 0Bh, 11h, 0Ah
		db	 10h, 0Dh, 00h, 15h, 01h, 03h
		db	 11h, 07h, 10h, 05h, 00h, 21h
		db	 02h, 01h, 06h, 3Dh, 04h, 0Fh
		db	 00h, 05h, 08h, 2Bh, 00h, 09h
		db	 01h, 06h, 00h, 10h, 02h, 47h
		db	 08h, 1Eh, 11h, 05h, 10h, 20h
		db	 12h, 0Bh, 02h, 01h, 0Ah, 42h
		db	 08h, 1Fh, 01h, 01h, 11h, 05h
		db	 10h, 0Ch, 12h, 1Dh, 02h, 10h
		db	 08h, 06h, 00h, 22h, 01h, 15h
		db	 09h, 14h, 01h, 01h, 00h, 05h
		db	 10h, 02h, 18h, 0Fh, 08h, 12h
		db	 09h, 1Ch, 10h, 18h, 11h, 02h
		db	 01h, 03h, 00h, 2Ah, 08h, 06h
		db	 09h, 0Bh, 08h, 05h, 09h, 0Dh
		db	 08h, 07h, 09h, 07h, 08h, 06h
		db	 09h, 03h, 08h, 01h, 00h, 02h
		db	 10h, 2Dh, 11h, 02h, 01h, 04h
		db	 00h, 23h, 08h, 05h, 09h, 03h
		db	 19h, 0Ah, 18h, 16h, 08h, 07h
		db	 09h, 11h, 08h, 08h, 09h, 03h
		db	 08h, 05h, 09h, 09h, 08h, 04h
		db	 09h, 07h, 08h, 08h, 09h, 23h
		db	 08h, 01h, 04h, 0Ah, 06h, 0Ah
		db	 02h, 04h, 06h, 0Ah, 02h, 06h
		db	 00h, 12h, 10h, 06h, 11h, 1Bh
		db	 10h, 07h, 00h, 0Dh, 01h, 04h
		db	 00h, 06h, 10h, 01h, 14h, 06h
		db	 04h, 09h, 05h, 06h, 01h, 01h
		db	 00h, 0Fh, 10h, 07h, 12h, 06h
		db	 00h, 05h, 01h, 06h, 04h, 06h
		db	 05h, 1Dh, 01h, 02h, 11h, 08h
		db	 10h, 17h, 02h, 06h, 00h, 30h
		db	 04h, 04h, 00h, 30h, 04h, 02h
		db	 05h, 03h, 0Dh, 02h, 09h, 04h
		db	 19h, 10h, 10h, 13h, 08h, 01h
		db	 09h, 09h, 19h, 02h, 18h, 0Bh
		db	 10h, 09h, 00h, 0Bh, 08h, 09h
		db	 09h, 01h, 0Dh, 0Bh, 05h, 01h
		db	 15h, 0Ah, 11h, 06h, 10h, 07h
		db	 00h, 08h, 01h, 07h, 11h, 05h
		db	 10h, 14h, 00h, 21h, 04h, 07h
		db	 05h, 0Ah, 04h, 08h, 05h
data_1A50	db	1
		db	 15h, 04h, 11h, 22h, 10h, 0Ah
		db	 00h, 40h, 04h, 02h, 01h, 07h
		db	 11h, 09h, 10h, 09h, 00h, 1Fh
		db	 04h, 01h, 05h, 0Ch, 01h, 02h
		db	 11h, 09h, 10h, 02h, 00h, 05h
		db	 01h, 0Bh, 11h, 04h, 14h, 08h
		db	 04h, 0Bh, 01h, 09h, 00h, 01h
		db	 08h, 03h, 0Ch, 10h, 04h, 0Ah
		db	 08h, 01h, 18h, 03h, 10h, 0Ah
		db	 11h, 04h, 10h, 0Fh, 00h, 0Dh
		db	 08h, 03h, 00h, 06h, 04h, 02h
		db	 05h, 08h, 04h, 10h, 05h, 04h
		db	 01h, 08h, 11h, 11h, 10h, 0Ah
		db	 11h, 36h, 10h, 01h, 00h, 0Ch
		db	 01h, 0Eh, 04h, 05h, 05h, 08h
		db	 04h, 07h, 05h, 07h, 04h, 04h
		db	 05h, 08h, 04h, 08h, 00h, 43h
		db	 08h, 18h, 11h, 15h, 10h, 0Fh
		db	 00h, 16h, 01h, 03h, 00h, 11h
		db	 10h, 10h, 12h, 01h, 02h, 13h
		db	 00h, 43h, 08h, 10h, 11h, 07h
		db	 10h, 14h, 12h, 04h, 02h, 43h
		db	 08h, 11h, 11h, 0Eh, 10h, 0Ah
		db	 12h, 11h, 02h, 07h, 00h, 09h
		db	 10h, 02h, 00h, 2Fh, 08h, 01h
		db	 0Ch, 09h, 04h, 04h, 15h, 11h
		db	 11h, 0Ah, 10h, 0Ah, 00h, 11h
		db	 01h, 01h, 11h, 0Ch, 10h, 05h
		db	 00h, 1Bh, 02h, 07h, 00h, 1Fh
		db	 08h, 02h, 00h, 06h, 10h, 0Bh
		db	 11h, 04h, 10h, 1Bh, 00h, 02h
		db	 08h, 03h, 01h, 13h, 11h, 05h
		db	 10h, 19h, 12h, 05h, 02h, 02h
		db	 0Ah, 2Eh, 08h, 07h, 04h, 06h
		db	 14h, 02h, 1Ch, 01h, 18h, 05h
		db	 08h, 04h, 18h, 0Eh, 08h, 06h
		db	 00h, 4Dh, 04h, 0Bh, 11h, 06h
		db	 10h, 0Eh, 12h, 05h, 02h, 07h
		db	 00h, 5Bh, 04h, 03h, 05h, 02h
		db	 0Dh, 04h, 09h, 11h, 08h, 07h
		db	 09h, 0Bh, 19h, 03h, 18h, 0Eh
		db	 08h, 14h, 00h, 0Ah, 02h, 0Ch
		db	 06h, 22h, 04h, 0Ch, 11h, 05h
		db	 10h, 0Dh, 12h, 05h, 02h, 01h
		db	 00h, 5Bh, 04h, 03h, 0Dh, 05h
		db	 09h, 0Bh, 08h, 09h, 09h, 04h
		db	 19h, 07h, 18h, 1Ah, 08h, 04h
		db	 09h, 11h, 08h, 0Ch, 09h, 01h
		db	 08h, 0Bh, 09h, 0Ah, 08h, 08h
		db	 09h, 20h, 08h, 0Fh, 0Ah, 01h
		db	 02h, 0Eh, 06h, 0Bh, 02h, 06h
		db	 00h, 13h, 10h, 06h, 11h, 0Ch
		db	 10h, 02h, 00h, 10h, 04h, 03h
		db	 05h, 0Ah, 01h, 09h, 11h, 0Ch
		db	 10h, 09h, 12h, 0Dh, 02h, 02h
		db	 00h, 6Eh, 04h, 02h, 0Dh, 02h
		db	 09h, 0Bh, 19h, 01h, 18h, 09h
		db	 10h, 16h, 00h, 23h, 08h, 03h
		db	 09h, 03h, 0Dh, 07h, 05h, 04h
		db	 15h, 05h, 11h, 15h, 10h, 08h
		db	 00h, 21h, 01h, 03h, 11h, 06h
		db	 10h, 20h, 00h, 1Ah, 04h, 0Ch
		db	 05h, 04h, 04h, 02h, 05h, 17h
		db	 10h, 0Bh, 11h, 09h, 10h, 06h
		db	 00h, 13h, 04h, 12h, 00h, 0Ch
		db	 04h, 17h, 00h, 02h, 04h, 1Eh
		db	 00h, 40h, 01h, 0Fh, 09h, 1Ah
		db	 01h, 08h, 11h, 30h, 10h, 01h
		db	 11h, 0Ah, 01h, 01h, 00h, 14h
		db	 08h, 10h, 00h, 10h, 04h, 0Bh
		db	 00h, 0Dh, 10h, 16h, 00h, 0Bh
		db	 10h, 12h, 00h, 0Ah, 10h, 50h
		db	 00h, 08h, 10h, 16h, 00h, 35h
		db	 04h, 0Ah, 11h, 07h, 10h, 11h
		db	 11h, 0Dh, 10h, 10h, 12h, 10h
		db	 00h, 43h, 04h, 01h, 10h, 19h
		db	 11h, 11h, 10h, 0Bh, 11h, 0Ch
		db	 10h, 05h, 12h, 10h, 02h, 01h
		db	 00h, 2Bh, 04h, 04h, 00h, 09h
		db	 01h, 22h, 11h, 14h, 12h, 16h
		db	 02h, 01h, 06h, 17h, 04h, 01h
		db	 01h, 0Fh, 11h, 1Dh, 10h, 14h
		db	 00h, 2Ch, 04h, 03h, 0Ch, 04h
		db	 08h, 02h, 18h, 01h, 10h, 0Fh
		db	 11h, 05h, 10h, 07h, 12h, 11h
		db	 02h, 01h, 00h, 23h, 04h, 02h
		db	 01h, 35h, 11h, 04h, 00h, 15h
		db	 02h, 02h, 06h, 20h, 04h, 07h
		db	 00h, 0Ah, 04h, 15h, 00h, 2Ah
		db	 08h, 0Eh, 04h, 10h, 10h, 0Ch
		db	 00h, 0Dh, 10h, 0Fh, 00h, 2Eh
		db	 04h, 1Fh, 00h, 05h, 08h, 1Eh
		db	 00h, 08h, 01h, 17h, 00h, 4Dh
		db	 08h, 01h, 00h, 06h, 05h, 24h
		db	 04h, 16h, 05h, 14h, 04h, 03h
		db	 0Ch, 06h, 08h, 13h, 00h, 1Dh
		db	 02h, 02h, 12h, 17h, 10h, 08h
		db	 11h, 12h, 10h, 0Ah, 11h, 1Ah
		db	 10h, 08h, 11h, 05h, 10h, 06h
		db	 00h, 0Ah, 08h, 05h, 09h, 09h
		db	 08h, 04h, 09h, 09h, 08h, 02h
		db	 09h, 06h, 08h, 04h, 09h, 0Bh
		db	 08h, 08h, 09h, 01h, 19h, 01h
		db	 11h, 0Fh, 10h, 05h, 11h, 0Bh
		db	 10h, 0Bh, 08h, 06h, 09h, 05h
		db	 08h, 18h, 09h, 0Bh, 19h, 02h
		db	 09h, 04h, 01h, 01h, 09h, 09h
		db	 00h, 09h, 08h, 02h, 18h, 17h
		db	 10h, 09h, 11h, 0Bh, 10h, 16h
		db	 00h, 0Fh, 10h, 06h, 11h, 09h
		db	 01h, 06h, 09h, 24h, 08h, 15h
		db	 09h, 05h, 08h, 1Ah, 10h, 1Eh
		db	 11h, 07h, 01h, 04h, 09h, 0Ch
		db	 08h, 05h, 09h, 07h, 01h, 1Fh
		db	 05h, 16h, 04h, 03h, 05h, 03h
		db	 01h, 18h, 09h, 04h, 08h, 03h
		db	 0Ch, 01h, 04h, 08h, 05h, 01h
		db	 15h, 0Ch, 11h, 1Dh, 10h, 05h
		db	 00h, 0Bh, 04h, 0Bh, 05h, 0Bh
		db	 04h, 03h, 05h, 0Dh, 04h, 0Eh
		db	 05h, 03h, 11h, 0Fh, 10h, 06h
		db	 11h, 21h, 10h, 0Eh, 11h, 0Eh
		db	 10h, 0Ah, 11h, 09h, 10h, 04h
		db	 00h, 0Bh, 01h, 2Eh, 00h, 01h
		db	 10h, 06h, 11h, 03h, 01h, 07h
		db	 00h, 09h, 04h, 08h, 05h, 0Ah
		db	 04h, 05h, 05h, 0Bh, 04h, 05h
		db	 05h, 0Ch, 04h, 0Fh, 00h, 4Ah
		db	 08h, 12h, 11h, 11h, 10h, 05h
		db	 11h, 13h, 10h, 0Dh, 00h, 0Bh
		db	 02h, 01h, 00h, 1Bh, 08h, 2Dh
		db	 00h, 26h, 01h, 05h, 11h, 09h
		db	 01h, 03h, 00h, 1Ah, 02h, 01h
		db	 0Ah, 27h, 08h, 01h, 01h, 16h
		db	 11h, 10h, 10h, 12h, 12h, 0Ch
		db	 02h, 03h, 00h, 10h, 01h, 07h
		db	 00h, 0Bh, 10h, 08h, 00h, 1Bh
		db	 01h, 01h
		db	20h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D8A	proc	near
		mov	ah,1
		mov	ds:d_BA00_B59A_e,ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	cs:data_1FF6,ah
		mov	cs:data_1FF7,ah
loc_1D9C:
		mov	ah,32h			; '2'
		mov	cs:data_1FF3,ah
		mov	ch,19h
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	cs:data_1FF5,ah
loc_1DAC:
		push	cx
		mov	bx,0
		mov	ah,cs:data_1FF6
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1DBD		; Jump if zero
		mov	bh,31h			; '1'
		mov	bl,0
loc_1DBD:
		mov	cs:data_1FED,bx
		mov	bx,offset data_1FF3
		dec	byte ptr [bx]
		dec	byte ptr [bx]
		mov	ah,32h			; '2'
		sub	ah,[bx]
		shr	ah,1			; Shift w/zeros fill
		mov	cs:data_1FEF,ah
		call	sub_1EE9
		call	sub_1EFD
		test	byte ptr data_48F9,80h	; key S (start)
		jz	loc_1DE4		; Jump if zero
		jmp	loc_1ECE
loc_1DE4:
		test	byte ptr data_48FA,80h	; key D (demo)
		jz	loc_1DEE		; Jump if zero
		jmp	loc_1EC9
loc_1DEE:
		call	sub_1FA0
		pop	cx
		dec	ch
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		call	sub_104F
		call	sub_104F
		cmp	ah,1
		jne	loc_1DAC		; Jump if not equal
		mov	ch,19h
		mov	ah,0
		mov	cs:data_1FF3,ah
		mov	ah,1
		mov	cs:data_1FF5,ah
loc_1E11:
		push	cx
		mov	bx,0
		mov	ah,cs:data_1FF6
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1E22		; Jump if zero
		mov	bh,31h			; '1'
		mov	bl,0
loc_1E22:
		mov	cs:data_1FED,bx
		mov	bx,offset data_1FF3
		inc	byte ptr [bx]
		inc	byte ptr [bx]
		mov	ah,[bx]
		shr	ah,1			; Shift w/zeros fill
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,19h
;*		add	ah,ch
		db	 00h,0ECh		;  Fixup - byte match
		mov	cs:data_1FEF,ah
		call	sub_1EE9
		call	sub_1EFD
		test	byte ptr data_48F9,80h	; key S (start)
		jz	loc_1E4D		; Jump if zero
		jmp	loc_1ECE
loc_1E4D:
		test	byte ptr data_48FA,80h	; key D (demo)
		jz	loc_1E57		; Jump if zero
		jmpn	loc_1EC9
loc_1E57:
		call	sub_1FA0
		pop	cx
		dec	ch
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		call	sub_104F
		call	sub_104F
		cmp	ah,1
		jne	loc_1E11		; Jump if not equal
		mov	ah,cs:data_1FF6
		xor	ah,1
		mov	cs:data_1FF6,ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1E7E		; Jump if zero
		jmp	loc_1D9C
loc_1E7E:
		mov	bx,8000h
loc_1E81:
		push	bx
		test	byte ptr data_48F9,80h	; key S (start)
		jnz	loc_1ECE		; Jump if not zero
		test	byte ptr data_48FA,80h	; key D (demo)
		jnz	loc_1EC9		; Jump if not zero
		pop	bx
		dec	bx
;*		mov	ah,bh
		db	 88h,0FCh		;  Fixup - byte match
;*		or	ah,bl
		db	 08h,0DCh		;  Fixup - byte match
		jz	loc_1E9A		; Jump if zero
		jmp	short loc_1E81
loc_1E9A:
		mov	ah,cs:data_1FF7
		inc	ah
		mov	cs:data_1FF7,ah
		cmp	ah,1Eh
		je	loc_1EAE		; Jump if equal
		jmp	loc_1D9C

;==== External Entry into Subroutine ======================================

sub_1EAE:
loc_1EAE:
		mov	ah,1
		mov	cs:data_1683,ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_B59A,ah
		mov	cs:data_1684,ah
		mov	bx,1688h
		mov	cs:data_1686,bx
		retn
loc_1EC9:
		call	sub_1EAE
		pop	bx
		retn
loc_1ECE:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	data_B59A,ah
		mov	cs:data_1683,ah
		mov	bx,1686h
		mov	cs:data_1686,bx
		mov	cs:data_1685,0FFh
		pop	bx
		retn
sub_1D8A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1EE9	proc	near
		mov	bh,32h			; '2'
		mov	bl,0
		mov	ah,cs:data_1FF3
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		call	sub_1443
		mov	cs:data_1FF1,bx
		retn
sub_1EE9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1EFD	proc	near
		mov	ah,cs:data_1FF3
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
loc_1F04:
		push	cx
		call	sub_1F4F
		mov	ah,cs:data_1FF5
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_1F1F		; Jump if not zero
		mov	ah,cs:data_1FEF
		inc	ah
		mov	cs:data_1FEF,ah
		jmp	short loc_1F2B
loc_1F1F:
		mov	ah,cs:data_1FEF
		dec	ah
		mov	cs:data_1FEF,ah
loc_1F2B:
		mov	bx,cs:data_1FED
		mov	dx,cs:data_1FF1
		mov	ah,cs:data_1FF6
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1F42		; Jump if zero
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		jmp	short loc_1F44
loc_1F42:
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
loc_1F44:
		mov	cs:data_1FED,bx
		pop	cx
		dec	ch
		jnz	loc_1F04		; Jump if not zero
		retn
sub_1EFD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1F4F	proc	near
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	ah,byte ptr cs:data_1FED+1
		call	sub_1F79
		push	bx
		mov	ah,cs:data_1FEF
		call	sub_1F85
		xchg	dx,bx
		pop	bx
		mov	cx,21h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	es
		retn
sub_1F4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1F79	proc	near
		mov	dx,21h
		call	sub_142F
		mov	dx,0A7E0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		retn
sub_1F79	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1F85	proc	near
		add	ah,91h
;*		mov	bl,ah
		db	 88h,0E3h		;  Fixup - byte match
		mov	bh,0
;*		add	bx,bx
		db	 01h,0DBh		;  Fixup - byte match
		mov	dx,76D0h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		xchg	dx,bx
		mov	dx,18h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		retn
sub_1F85	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1FA0	proc	near
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	ah,cs:data_1FF5
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	ch,1
		jz	loc_1FB3		; Jump if zero
		mov	ch,0FFh
loc_1FB3:
		mov	ah,cs:data_1FEF
;*		add	ah,ch
		db	 00h,0ECh		;  Fixup - byte match
loc_1FBA:
		cmp	ah,32h			; '2'
		jae	loc_1FEB		; Jump if above or =
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_1FEB		; Jump if zero
		push	ax
		push	cx
		call	sub_1F85
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
;*		mov	dl,bl
		db	 88h,0DAh		;  Fixup - byte match
		inc	dx
		push	ds
		mov	ax,0B800h
		mov	ds,ax
		mov	byte ptr [bx],0
		mov	cx,20h
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	ds
		pop	cx
		pop	ax
;*		add	ah,ch
		db	 00h,0ECh		;  Fixup - byte match
		jmp	short loc_1FBA
loc_1FEB:
		pop	es
		retn
sub_1FA0	endp

data_1FED	dw	31E0h
data_1FEF	db	31h
		db	0
data_1FF1	dw	10Ah
data_1FF3	db	30h
		db	0
data_1FF5	db	0
data_1FF6	db	0
data_1FF7	db	0
		db	 8Ah, 26h,0BDh,0B3h,0F6h,0C4h
		db	 01h
		db	75h
data_2000	db	1			; Data table (indexed access)
		db	0C3h,0BEh,0DAh,0B3h, 8Ah, 64h
		db	 07h, 80h,0FCh, 04h, 74h, 01h
		db	0C3h
loc_200E:
		mov	ah,4
		mov	data_B57C,ah
		jmp	short loc_2032
			                        ;* No entry point to code
		mov	ah,data_B3BD
		test	ah,1
		jnz	loc_2020		; Jump if not zero
		retn
loc_2020:
		mov	si,offset data_B3DA
		mov	ah,[si+7]
		cmp	ah,40h			; '@'
		je	loc_202C		; Jump if equal
		retn
loc_202C:
		mov	ah,40h			; '@'
		mov	data_B57C,ah
loc_2032:
		mov	si,offset data_B3BD
		mov	ah,[si+2]
		mov	data_B57A,ah
		mov	ah,[si+1Fh]
		mov	data_B57B,ah
		call	sub_2156
		call	sub_0C81
		mov	ah,data_B57C
		call	sub_20CB
		mov	bx,7316h
		call	sub_2292
loc_2056:
		call	sub_20E6
		call	sub_2102
		jnz	loc_2056		; Jump if not zero
		call	sub_265A
		call	sub_210C
		mov	ah,data_BAEF
		cmp	ah,45h			; 'E'
		je	loc_2073		; Jump if equal
		mov	bx,730Ch
		call	sub_2292
loc_2073:
		mov	ch,10h
loc_2075:
		push	cx
		call	sub_20E6
		pop	cx
		call	sub_2088
		dec	ch
		jnz	loc_2075		; Jump if not zero
		call	sub_083F
		call	sub_209E
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2088	proc	near
		mov	ah,data_BAEF
		cmp	ah,45h			; 'E'
		jne	loc_2092		; Jump if not equal
		retn
loc_2092:
		mov	ah,11h
;*		sub	ah,ch
		db	 28h,0ECh		;  Fixup - byte match
loc_2096:
		call	sub_104F
		dec	ah
		jnz	loc_2096		; Jump if not zero
		retn
sub_2088	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_209E	proc	near
		mov	ah,byte ptr data_799A+1
		cmp	ah,39h			; '9'
		je	loc_20B4		; Jump if equal
		inc	ah
		mov	byte ptr data_799A+1,ah
		mov	bx,offset data_7998
		call	sub_118F
		retn
loc_20B4:
		mov	ah,30h			; '0'
		mov	ds:d_BA00_799B_e,ah
		mov	ah,ds:d_BA00_799A_e
		inc	ah
		mov	ds:d_BA00_799A_e,ah
		mov	bx,offset data_7998
		call	sub_118F
		retn
sub_209E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_20CB	proc	near
		mov	si,offset data_B3F7
		mov	[si+7],ah
		mov	byte ptr [si+8],78h	; 'x'
		mov	byte ptr [si+0Ch],0
		mov	byte ptr [si+0Bh],15h
		or	byte ptr [si],40h	; '@'
		or	byte ptr [si],80h
		jmp	loc_0C81
sub_20CB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_20E6	proc	near
		mov	si,offset data_B3BD
		mov	ch,3
		mov	dx,1Dh
loc_20EE:
		mov	ah,[si+2]
		dec	ah
		mov	[si+8],ah
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_20EE		; Jump if not zero
		call	sub_104F
		jmp	loc_0C81
sub_20E6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2102	proc	near
		mov	si,offset data_B3BD
		mov	ah,[si+2]
		cmp	ah,0
		retn
sub_2102	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_210C	proc	near
		mov	si,offset data_B3BD
		or	byte ptr [si+1Dh],40h	; '@'
		or	byte ptr [si+1Dh],80h
		mov	ah,data_B57B
		add	ah,10h
		mov	[si+25h],ah
		mov	ah,data_B57A
		add	ah,10h
		mov	[si+8],ah
		mov	ah,15h
		call	sub_0E0F
		mov	ah,data_B57C
		mov	[si+7],ah
		mov	byte ptr [si+8],88h
		mov	byte ptr [si+0Ch],0
		mov	byte ptr [si+0Bh],15h
		mov	bx,83FDh
		mov	[si+19h],bl
		mov	[si+1Ah],bh
		or	byte ptr [si],40h	; '@'
		or	byte ptr [si],80h
		call	sub_0C81
		retn
sub_210C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2156	proc	near
		mov	si,offset data_B414
		mov	dx,1Dh
		mov	ch,0Ah
loc_215E:
		or	byte ptr [si],10h
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_215E		; Jump if not zero
		retn
sub_2156	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2168	proc	near
		cli				; Disable interrupts
		push	ds
		mov	ax,0
		mov	ds,ax
		mov	bx,d_0000_0024_e
		mov	ax,[bx]
		mov	cs:data_21AF,ax
		mov	word ptr [bx],21FCh
		inc	bx
		inc	bx
		mov	ax,[bx]
		mov	cs:data_21B1,ax
		mov	ax,cs
		mov	[bx],ax
		mov	bx,d_0000_0070_e
		mov	ax,[bx]
		mov	cs:data_21B3,ax
		mov	word ptr [bx],21B7h
		inc	bx
		inc	bx
		mov	ax,[bx]
		mov	cs:data_21B5,ax
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
sub_2168	endp

data_21AF	dw	4B6Fh
data_21B1	dw	0EABh
data_21B3	dw	0FF53h
data_21B5	dw	0F000h
		db	0FAh, 1Eh, 06h, 50h, 53h, 51h
		db	 52h, 56h, 57h, 8Ch,0C8h, 05h
		db	 00h, 00h, 8Eh,0D8h,0FEh, 06h
		db	 2Dh, 59h, 80h, 3Eh, 2Dh, 59h
		db	0C8h, 75h, 0Ah,0C6h, 06h, 2Dh
		db	 59h, 00h, 80h, 0Eh, 2Ch, 59h
		db	 40h,0FEh, 06h, 28h, 59h,0FFh
		db	 06h, 29h, 59h,0F7h, 06h, 29h
		db	 59h, 01h, 00h, 75h, 06h,0E8h
		db	0C9h, 00h,0E8h,0DDh,0E0h
loc_21F2:
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
		mov	bx,offset data_48F0	; key O (left)
loc_221B:
		cmp	byte ptr [bx],0
		je	loc_222A		; Jump if equal
		cmp	al,[bx]
		je	loc_2227		; Jump if equal
		inc	bx
		jmp	short loc_221B
loc_2227:
		xor	byte ptr [bx],80h
loc_222A:
		in	al,20h			; port 20h, 8259-1 int IRR/ISR
		or	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt

		; Ctrl+Alt+Del (reset)
		test	byte ptr data_48FB,80h	; key Left Alt
		jz	loc_224A		; Jump if zero
		test	byte ptr data_48FC,80h	; key Left Ctrl
		jz	loc_224A		; Jump if zero
		test	byte ptr data_48FD,80h	; key [. Del]
		jz	loc_224A		; Jump if zero
;*		jmp	far ptr l_FFFF_0000	;*
		db	0EAh
		dw	0, 0FFFFh		;  Fixup - byte match
loc_224A:
		; cheat "OPERA"
		test	byte ptr data_48F0,80h	; key O (left)
		jz	loc_2270		; Jump if zero
		test	byte ptr data_48F1,80h	; key P (right)
		jz	loc_2270		; Jump if zero
		test	byte ptr data_48F7,80h	; key E
		jz	loc_2270		; Jump if zero
		test	byte ptr data_48F8,80h	; key R
		jz	loc_2270		; Jump if zero
		test	byte ptr data_48F3,80h	; key A (down)
		jz	loc_2270		; Jump if zero
		call	sub_02DC
loc_2270:
		test	byte ptr data_48F9,80h	; key S (start)
		jz	loc_227A		; Jump if zero
		call	sub_0C6D
loc_227A:
		pop	cx
		pop	bx
		pop	ax
		pop	ds
		sti				; Enable interrupts
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2280	proc	near
		mov	byte ptr data_592B,0
		jmp	loc_234D

;==== External Entry into Subroutine ======================================

sub_2288:
		mov	byte ptr data_592B,1
		mov	bx,offset data_735A
		jmp	short loc_229A

;==== External Entry into Subroutine ======================================

sub_2292:
loc_2292:
		test	byte ptr data_592B,0FFh
		jz	loc_229A		; Jump if zero
		retn
loc_229A:
		cli				; Disable interrupts
		mov	word ptr ds:[5906h],5910h
		mov	word ptr ds:[5908h],22B7h
		mov	byte ptr ds:[590Ah],1
		mov	word ptr ds:[5902h],bx
		mov	byte ptr ds:[5901h],1
		sti				; Enable interrupts
		retn
		db	81h

;==== External Entry into Subroutine ======================================

sub_22B8:
		mov	al,byte ptr ds:[5901h]
		test	al,1
		jnz	loc_22C0		; Jump if not zero
		retn
loc_22C0:
		test	al,2
		jnz	loc_22E0		; Jump if not zero
loc_22C4:
		mov	bx,word ptr ds:[5902h]
		mov	al,[bx]
		inc	bx
		mov	word ptr ds:[5902h],bx
		mov	ah,0
		mov	bx,offset data_233F
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		call	word ptr [bx]		;*7 entries
		mov	al,byte ptr ds:[5901h]
		test	al,80h
		jnz	loc_22C4		; Jump if not zero
		retn
loc_22E0:
		mov	cx,word ptr ds:[5904h]
		dec	cx
		mov	word ptr ds:[5904h],cx
		jnz	loc_22F5		; Jump if not zero
		mov	al,byte ptr ds:[5901h]
		and	al,7Dh			; '}'
		mov	byte ptr ds:[5901h],al
		jmp	short loc_22C4
loc_22F5:
		test	word ptr ds:[5901h],40h
		jnz	loc_ret_2309		; Jump if not zero
		mov	ah,byte ptr ds:[590Dh]
		dec	ah
		jz	loc_230A		; Jump if zero
		mov	byte ptr ds:[590Dh],ah

loc_ret_2309:
		retn
loc_230A:
		mov	ah,byte ptr ds:[590Ah]
		mov	byte ptr ds:[590Dh],ah
		mov	bx,word ptr ds:[590Bh]
		mov	al,[bx]
		cmp	al,81h
		jne	loc_231D		; Jump if not equal
		retn
loc_231D:
		cmp	al,80h
		jne	loc_2331		; Jump if not equal
		mov	bx,word ptr ds:[5908h]
		mov	word ptr ds:[590Bh],bx
		mov	al,byte ptr ds:[590Ah]
		mov	byte ptr ds:[590Dh],al
		mov	al,[bx]
loc_2331:
		cbw				; Convrt byte to word
		mov	cx,word ptr ds:[590Eh]
;*		add	cx,ax
		db	 01h,0C1h		;  Fixup - byte match
		mov	word ptr ds:[590Eh],cx
		jmp	loc_23FF
data_233F	dw	offset sub_234D
data_2341	dw	offset sub_23D0
data_2343	dw	offset sub_2414
data_2345	dw	offset sub_2379
data_2347	dw	offset sub_2359
data_2349	dw	offset sub_23BD
data_234B	dw	offset sub_2397

;==== External Entry into Subroutine ======================================

sub_234D:
loc_234D:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0Ch, enable parity
		mov	byte ptr ds:[5901h],0
		retn

;==== External Entry into Subroutine ======================================

sub_2359:
		cmp	word ptr ds:[5906h],5910h
		je	loc_234D		; Jump if equal
		or	byte ptr ds:[5901h],80h
		dec	word ptr ds:[5906h]
		dec	word ptr ds:[5906h]
		mov	si,word ptr ds:[5906h]
		mov	bx,[si]
		mov	word ptr ds:[5902h],bx
		retn

;==== External Entry into Subroutine ======================================

sub_2379:
		or	byte ptr ds:[5901h],80h
		mov	bx,word ptr ds:[5902h]
		mov	cx,[bx]
		inc	bx
		inc	bx
		mov	word ptr ds:[5902h],cx
		mov	si,word ptr ds:[5906h]
		mov	[si],bx
		inc	si
		inc	si
		mov	word ptr ds:[5906h],si
		retn

;==== External Entry into Subroutine ======================================

sub_2397:
		mov	al,byte ptr ds:[5901h]
		or	al,80h
		mov	byte ptr ds:[5901h],al
		mov	bx,word ptr ds:[5902h]
		mov	al,[bx]
		mov	byte ptr ds:[590Ah],al
		mov	byte ptr ds:[590Dh],al
		inc	bx
		mov	cx,[bx]
		inc	bx
		inc	bx
		mov	word ptr ds:[5902h],bx
		mov	word ptr ds:[5908h],cx
		mov	word ptr ds:[590Bh],cx
		retn

;==== External Entry into Subroutine ======================================

sub_23BD:
		mov	al,byte ptr ds:[5901h]
		or	al,80h
		mov	byte ptr ds:[5901h],al
		mov	bx,word ptr ds:[5902h]
		mov	cx,[bx]
		mov	word ptr ds:[5902h],cx
		retn

;==== External Entry into Subroutine ======================================

sub_23D0:
		mov	al,byte ptr ds:[5901h]
		and	al,3Fh			; '?'
		or	al,2
		mov	byte ptr ds:[5901h],al
		mov	cx,word ptr ds:[5908h]
		mov	word ptr ds:[590Bh],cx
		mov	al,byte ptr ds:[590Ah]
		mov	byte ptr ds:[590Dh],al
		mov	bx,word ptr ds:[5902h]
		mov	cx,[bx]
		inc	bx
		inc	bx
		mov	ax,[bx]
		inc	bx
		inc	bx
		mov	word ptr ds:[5904h],ax
		mov	word ptr ds:[5902h],bx
		mov	word ptr ds:[590Eh],cx
loc_23FF:
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
sub_2280	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2414	proc	near
		mov	al,byte ptr ds:[5901h]
		and	al,7Fh
		or	al,42h			; 'B'
		mov	byte ptr ds:[5901h],al
		mov	bx,word ptr ds:[5902h]
		mov	ax,[bx]
		inc	bx
		inc	bx
		mov	word ptr ds:[5904h],ax
		mov	word ptr ds:[5902h],bx
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0Ch, enable parity
		retn
sub_2414	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2434	proc	near
		mov	bx,0B59Bh
		mov	dx,0B59Ch
		mov	cx,2A7h
		mov	byte ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	ah,ds:d_BA00_BAEF_e
		shl	ah,1			; Shift w/zeros fill
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
		mov	bx,d_BA00_7092_e
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	dl,[bx]
		inc	bx
		mov	dh,[bx]
		mov	di,d_BA00_2D4F_e
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	ch,[di]
		inc	di
loc_2467:
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
		mov	dx,0B59Bh
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		xchg	dx,bx
		mov	bl,[di+2]
		mov	bh,[di+3]
		mov	cx,692Eh
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		mov	ch,[bx]
		inc	bx
		mov	cl,[bx]
		inc	bx
loc_2499:
		push	cx
		push	dx
loc_249B:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_24A7		; Jump if zero
		xchg	dx,bx
		mov	[bx],ah
		xchg	dx,bx
loc_24A7:
		inc	bx
		inc	dx
		dec	ch
		jnz	loc_249B		; Jump if not zero
		pop	dx
		mov	ah,28h			; '('
;*		add	ah,dl
		db	 00h,0D4h		;  Fixup - byte match
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		jnc	loc_24B8		; Jump if carry=0
		inc	dh
loc_24B8:
		pop	cx
		dec	cl
		jnz	loc_2499		; Jump if not zero
		mov	dx,4
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_2467		; Jump if not zero
		retn
sub_2434	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_24C8	proc	near
		mov	ah,ds:d_BA00_BAEF_e
		mov	di,d_BA00_799E_e
		cmp	ah,[di]
		jne	loc_24D9		; Jump if not equal
		mov	si,offset data_B3DA
		call	sub_255A
loc_24D9:
		mov	ah,ds:d_BA00_BAEF_e
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
		mov	dh,0
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	di,d_BA00_786C_e
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	dl,[di]
		mov	dh,[di+1]
		mov	ds:d_BA00_BAEB_e,dx
		push	dx
		pop	di
		mov	dx,4
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		mov	ah,[di]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	di
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2532		; Jump if zero
loc_2501:
		push	cx
		test	byte ptr [di],80h
		jz	loc_250A		; Jump if zero
		call	sub_26FC
loc_250A:
		jc	loc_2528		; Jump if carry Set
		test	byte ptr [di],40h	; '@'
		jz	loc_251D		; Jump if zero
		mov	ah,data_B3BD
		test	ah,1
		jz	loc_2528		; Jump if zero
		call	sub_0B16
loc_251D:
		mov	ah,[di+1]
		call	sub_0E0F
		jc	loc_2528		; Jump if carry Set
		call	sub_255A
loc_2528:
		mov	dx,7
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		pop	cx
		dec	ch
		jnz	loc_2501		; Jump if not zero
loc_2532:
		mov	data_BAED,di
		retn
sub_24C8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2537	proc	near
		mov	di,data_BAED
		mov	ah,[di]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2542		; Jump if not zero
		retn
loc_2542:
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	di
loc_2545:
		push	cx
		push	di
		call	sub_2553
		pop	di
		inc	di
		inc	di
		pop	cx
		dec	ch
		jnz	loc_2545		; Jump if not zero
		retn
sub_2537	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2553	proc	near
		mov	bl,[di]
		mov	bh,[di+1]
		jmp	bx			;*Register jump

;==== External Entry into Subroutine ======================================

sub_255A:
		push	si
		push	si
		pop	bx
		pop	dx
		inc	dx
		mov	cx,1Ch
		mov	byte ptr [bx],0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		mov	ah,[di+1]
		mov	[si+0Bh],ah
		mov	ah,[di+2]
		mov	[si+0Ch],ah
		mov	ah,[di+3]
		mov	[si+7],ah
		mov	ah,[di+4]
		mov	[si+8],ah
		mov	ah,[di+5]
		mov	[si+19h],ah
		mov	ah,[di+6]
		mov	[si+1Ah],ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		mov	ah,[si+19h]
		adc	ah,7
		mov	[si+1Bh],ah
		mov	ah,[si+1Ah]
		adc	ah,0
		mov	[si+1Ch],ah
		or	byte ptr [si],40h	; '@'
		or	byte ptr [si],80h
		retn
sub_2553	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_25AF	proc	near
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+1]
		test	byte ptr [si],1
		jnz	loc_25BD		; Jump if not zero
		sub	ah,3
loc_25BD:
		cmp	ah,44h			; 'D'
		je	loc_25C3		; Jump if equal
		retn
loc_25C3:
		mov	si,data_BAEB
		mov	ah,[si+1]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_25D1		; Jump if not zero
		jmp	loc_1342
loc_25D1:
		call	sub_274E
		jnz	loc_25D9		; Jump if not zero
		jmp	loc_1342
loc_25D9:
		mov	ah,[si+1]
		mov	data_BAEF,ah
		call	sub_08A4
		mov	si,d_BA00_B3BD_e
		mov	ah,2
		mov	[si+7],ah
		test	byte ptr [si],1
		jz	loc_25FA		; Jump if zero
		mov	ah,1
		mov	[si+24h],ah
		call	sub_083F
		jmp	short loc_25FE
loc_25FA:
		and	byte ptr [si+1Dh],7Fh
loc_25FE:
		call	sub_26E4
		call	sub_2434
		call	sub_24C8
		call	sub_1020
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_25AF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_260D	proc	near
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+1]
		cmp	ah,1
		je	loc_2619		; Jump if equal
		retn
loc_2619:
		mov	si,ds:d_BA00_BAEB_e
		mov	ah,[si+3]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2627		; Jump if not zero
		jmp	loc_1342
loc_2627:
		call	sub_2723
		jnz	loc_262F		; Jump if not zero
		jmp	loc_1342
loc_262F:
		mov	ah,[si+3]
		mov	ds:d_BA00_BAEF_e,ah
		call	sub_08A4
		mov	si,d_BA00_B3BD_e
		mov	ah,43h			; 'C'
		mov	[si+7],ah
		inc	ah
		mov	[si+1],ah
		test	byte ptr [si],1
		jz	loc_25FA		; Jump if zero
		mov	ah,42h			; 'B'
		mov	[si+24h],ah
		inc	ah
		mov	[si+1Eh],ah
		call	sub_083F
		jmp	short loc_25FE
sub_260D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_265A	proc	near
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2665		; Jump if zero
		retn
loc_2665:
		mov	si,ds:d_BA00_BAEB_e
		mov	ah,[si]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2672		; Jump if not zero
		jmp	loc_135B
loc_2672:
		mov	ds:d_BA00_BAEF_e,ah
		call	sub_08A4
		mov	si,d_BA00_B3BD_e
		mov	ah,72h			; 'r'
		mov	[si+8],ah
		inc	ah
		mov	[si+2],ah
		mov	bx,d_BA00_7996_e
		mov	ah,[bx]
		cmp	ah,39h			; '9'
		je	loc_2695		; Jump if equal
		inc	word ptr [bx]
		jmp	loc_25FA
loc_2695:
		mov	ah,30h			; '0'
		mov	[bx],ah
		dec	bx
		inc	word ptr [bx]
		jmp	loc_25FA
sub_265A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_269F	proc	near
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+2]
		cmp	ah,74h			; 't'
		je	loc_26AB		; Jump if equal
		retn
loc_26AB:
		mov	si,ds:d_BA00_BAEB_e
		mov	ah,[si+2]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_26B7		; Jump if not zero
		retn
loc_26B7:
		mov	ds:d_BA00_BAEF_e,ah
		call	sub_08A4
		mov	si,d_BA00_B3BD_e
		mov	ah,2
		mov	[si+8],ah
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si+2],ah
		mov	bx,d_BA00_7996_e
		mov	ah,[bx]
		cmp	ah,30h			; '0'
		je	loc_26DA		; Jump if equal
		dec	word ptr [bx]
		jmp	loc_25FA
loc_26DA:
		mov	ah,39h			; '9'
		mov	[bx],ah
		dec	bx
		dec	byte ptr [bx]
		jmp	loc_25FA
sub_269F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_26E4	proc	near
		mov	bx,0B3F7h
		mov	dx,0B3F8h
		mov	byte ptr [bx],0
		mov	cx,13Eh
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_26E4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_26FC	proc	near
		push	si
		push	dx
		push	cx
		mov	ch,0Dh
		mov	dx,1Dh
		mov	si,d_BA00_B3BD_e
		mov	ah,[di+1]
loc_270A:
		test	byte ptr [si],80h
		jz	loc_2714		; Jump if zero
		cmp	ah,[si+0Bh]
		je	loc_2720		; Jump if equal
loc_2714:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_270A		; Jump if not zero
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
loc_271C:
		pop	cx
		pop	dx
		pop	si
		retn
loc_2720:
		stc				; Set carry flag
		jmp	short loc_271C
sub_26FC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2723	proc	near
		mov	bx,d_BA00_799E_e
		cmp	ah,[bx]
		je	loc_272B		; Jump if equal
		retn
loc_272B:
		push	si
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+2]
		cmp	ah,5Ah			; 'Z'
		jb	loc_2748		; Jump if below
		mov	si,d_BA00_799E_e
		mov	ah,[si+3]
		cmp	ah,38h			; '8'
		jb	loc_2748		; Jump if below
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		pop	si
		retn
loc_2748:
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		pop	si
		retn
sub_2723	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_274E	proc	near
		mov	bx,d_BA00_799E_e
		cmp	ah,[bx]
		je	loc_2756		; Jump if equal
		retn
loc_2756:
		push	si
		mov	si,d_BA00_B3BD_e
		mov	ah,[si+2]
		cmp	ah,5Ah			; 'Z'
		jb	loc_2748		; Jump if below
		mov	si,d_BA00_799E_e
		mov	ah,[si+3]
		cmp	ah,0Fh
		jae	loc_2748		; Jump if above or =
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		pop	si
		retn
sub_274E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2773	proc	near
		mov	si,d_BA00_B3F7_e
		mov	dx,1Dh
		mov	ch,0Bh
loc_277B:
		test	byte ptr [si],80h
		jz	loc_2789		; Jump if zero
		push	si
		push	dx
		push	cx
		call	sub_13EF
		pop	cx
		pop	dx
		pop	si
loc_2789:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_277B		; Jump if not zero
		retn
sub_2773	endp

			                        ;* No entry point to code
		mov	bl,[si+1Bh]
		mov	bh,[si+1Ch]
		mov	ah,[si+14h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_27A6		; Jump if zero
		dec	word ptr [si+14h]
		call	sub_27DD
		jmp	loc_0DFC
loc_27A6:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_27C8		; Jump if zero
		mov	[si+14h],ah
		inc	bx
		mov	ah,[bx]
		mov	[si+16h],ah
		inc	bx
		mov	ah,[bx]
		mov	[si+17h],ah
		inc	bx
		mov	[si+1Bh],bl
		mov	[si+1Ch],bh
		call	sub_27DD
		jmp	loc_0DFC
loc_27C8:
		mov	ah,[si+19h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		adc	ah,7
		mov	[si+1Bh],ah
		mov	ah,[si+1Ah]
		adc	ah,0
		mov	[si+1Ch],ah
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_27DD	proc	near
		push	si
		push	di
		mov	di,offset data_B3DA
		test	byte ptr [di],80h
		jz	loc_27EF		; Jump if zero
		call	sub_2CD5
		jc	loc_27EF		; Jump if carry Set
		call	sub_0A25
loc_27EF:
		pop	di
		pop	si
		retn
sub_27DD	endp

			                        ;* No entry point to code
		mov	ah,[si+14h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2802		; Jump if zero
		dec	byte ptr [si+14h]
		call	sub_2845
		jnz	loc_2802		; Jump if not zero
		retn
loc_2802:
		call	sub_13C7
		and	ah,1Fh
		cmp	ah,0Fh
		jae	loc_280F		; Jump if above or =
		mov	ah,0Fh
loc_280F:
		mov	[si+14h],ah
		call	sub_13C7
		and	ah,3
		cmp	ah,2
		jae	loc_2822		; Jump if above or =
		mov	[si+16h],ah
		jmp	short loc_2827
loc_2822:
		mov	ah,0FFh
		mov	[si+16h],ah
loc_2827:
		call	sub_13C7
		and	ah,3
		cmp	ah,2
		jae	loc_2838		; Jump if above or =
		shl	ah,1			; Shift w/zeros fill
		mov	[si+17h],ah
		retn
loc_2838:
		mov	ah,0FEh
		mov	[si+17h],ah
		call	sub_2845
		jnz	loc_2843		; Jump if not zero
		retn
loc_2843:
		jmp	short loc_2802

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2845	proc	near
		call	sub_0DFC
		call	sub_2856
		jnz	loc_284E		; Jump if not zero
		retn
loc_284E:
		call	sub_28CB
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_2845	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2856	proc	near
		call	sub_2D03
		jnc	loc_2880		; Jump if carry=0
		mov	bl,[si+7]
		mov	bh,[si+8]
		call	sub_11BA
		mov	ah,data_BAF0
		cmp	ah,0
		je	loc_2880		; Jump if equal
		cmp	ah,24h			; '$'
		je	loc_2880		; Jump if equal
		mov	ah,data_BAF1
		cmp	ah,0
		je	loc_2880		; Jump if equal
		cmp	ah,0Dh
		jne	loc_2885		; Jump if not equal
loc_2880:
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
loc_2885:
		mov	dl,[si+11h]
		mov	ah,[si+12h]
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
		and	ah,1Fh
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
		inc	dh
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
		rcr	ah,1			; Rotate thru carry
		and	ah,7Fh
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		inc	dl
loc_28A3:
		push	dx
		push	bx
loc_28A5:
		mov	ah,[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_28C4		; Jump if not zero
		inc	bx
		dec	dl
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_28A5		; Jump if not zero
		pop	bx
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		pop	dx
		dec	dh
;*		mov	ah,dh
		db	 88h,0F4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_28A3		; Jump if not zero
		retn
loc_28C4:
		pop	bx
		pop	dx
		mov	ah,1
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_2856	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_28CB	proc	near
		mov	ah,[si+1]
		mov	[si+7],ah
		mov	ah,[si+2]
		mov	[si+8],ah
		retn
sub_28CB	endp

			                        ;* No entry point to code
		mov	ah,[si+0Ch]
		cmp	ah,0
		je	loc_28E1		; Jump if equal
		retn
loc_28E1:
		or	byte ptr [si],10h
		retn
			                        ;* No entry point to code
		mov	ah,[si+14h]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_28F5		; Jump if zero
		dec	word ptr [si+14h]
		call	sub_2845
		jnz	loc_28F5		; Jump if not zero
		retn
loc_28F5:
		push	di
		and	byte ptr [si+13h],7Fh
		mov	di,offset data_B3BD
		mov	ah,[si+1]
		cmp	ah,[di+1]
		jb	loc_290D		; Jump if below
		jz	loc_292A		; Jump if zero
		mov	byte ptr [si+16h],0FFh
		jmp	short loc_2912
loc_290D:
		mov	word ptr [si+16h],1
loc_2912:
		mov	ah,[si+1]
		add	ah,[si+16h]
		mov	[si+7],ah
		call	sub_2856
		jz	loc_292A		; Jump if zero
		mov	ah,[si+1]
		mov	[si+7],ah
		or	byte ptr [si+13h],80h
loc_292A:
		mov	ah,[si+2]
		cmp	ah,[di+2]
		jb	loc_293A		; Jump if below
		jz	loc_295E		; Jump if zero
		mov	byte ptr [si+17h],0FEh
		jmp	short loc_293E
loc_293A:
		mov	byte ptr [si+17h],2
loc_293E:
		mov	ah,[si+2]
		add	ah,[si+17h]
		mov	[si+8],ah
		call	sub_2856
		pop	di
		jnz	loc_294E		; Jump if not zero
		retn
loc_294E:
		mov	ah,[si+2]
		mov	[si+8],ah
loc_2954:
		test	byte ptr [si+13h],80h
		jnz	loc_295B		; Jump if not zero
		retn
loc_295B:
		jmp	loc_2802
loc_295E:
		pop	di
		jmp	short loc_2954
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		call	sub_29AF
		jnc	loc_2968		; Jump if carry=0
		retn
loc_2968:
		mov	ah,[si+6]
		cmp	ah,5
		je	loc_2971		; Jump if equal
		retn
loc_2971:
		cmp	ah,[si+0Ch]
		jne	loc_2977		; Jump if not equal
		retn
loc_2977:
		push	di
		push	si
		mov	bx,731Eh
		call	sub_2292
		mov	ah,[si+12h]
		add	ah,[si+2]
		mov	cl,[si+1]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		inc	ch
		push	cx
		mov	ah,22h			; '"'
		call	sub_0E0F
		pop	cx
		jc	loc_29AC		; Jump if carry Set
		mov	di,offset data_83D3
		push	cx
		call	sub_255A
		pop	cx
		mov	[si+7],cl
		mov	[si+8],ch
		call	sub_2D03
		jc	loc_29AC		; Jump if carry Set
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		mov	[si],ah
loc_29AC:
		pop	si
		pop	di
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_29AF	proc	near
		push	si
		mov	si,offset data_B3BD
		mov	dx,1Dh
		mov	ch,0Dh
loc_29B8:
		test	byte ptr [si],80h
		jz	loc_29C8		; Jump if zero
		mov	ah,[si+0Bh]
		cmp	ah,22h			; '"'
		jne	loc_29C8		; Jump if not equal
		stc				; Set carry flag
		jmp	short loc_29D0
loc_29C8:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_29B8		; Jump if not zero
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
loc_29D0:
		pop	si
		retn
sub_29AF	endp

			                        ;* No entry point to code
		mov	bl,[si+1Bh]
		mov	bh,[si+1Ch]
		mov	ah,[si+7]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2A07		; Jump if zero
		mov	ah,data_B3C4
		cmp	ah,[si+7]
		jae	loc_29FC		; Jump if above or =
		mov	ah,data_B3C5
		cmp	ah,[si+8]
		jae	loc_29FC		; Jump if above or =
		mov	byte ptr [si+16h],0FFh
		mov	byte ptr [si+17h],0FFh
		jmp	loc_0DFC
loc_29FC:
		mov	byte ptr [si+16h],0FFh
		mov	byte ptr [si+17h],0
		jmp	loc_0DFC
loc_2A07:
		push	bx
		call	sub_0F1C
		mov	ah,data_B3C5
		pop	bx
		and	ah,7Fh
		cmp	ah,[bx]
		jb	loc_2A23		; Jump if below
		call	sub_13C7
		and	ah,7Fh
		cmp	ah,[bx]
		jb	loc_2A23		; Jump if below
		mov	ah,[bx]
loc_2A23:
		mov	[si+8],ah
		mov	byte ptr [si+7],48h	; 'H'
		and	ah,1
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	dh,0
		mov	bx,offset data_2A3F
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	ah,[bx]
		mov	[si+0Bh],ah
		or	byte ptr [si],40h	; '@'
		retn
data_2A3F	db	28h
		db	29h
loc_2A41:
		call	sub_2A48
		call	sub_2A9C
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2A48	proc	near
		mov	ah,data_B3BE
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		mov	ah,[si+1]
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_2A81		; Jump if carry=0
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
;*		sub	ah,dl
		db	 28h,0D4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
		mov	ah,data_B3BF
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	ah,[si+2]
;*		sub	ah,dl
		db	 28h,0D4h		;  Fixup - byte match
;*		cmp	ah,dh
		db	 38h,0F4h		;  Fixup - byte match
		jnc	loc_2A77		; Jump if carry=0
		mov	byte ptr [si+0Ch],2
		retn
loc_2A77:
		mov	byte ptr [si+0Ch],1
		retn
loc_2A7C:
		mov	byte ptr [si+0Ch],0
		retn
loc_2A81:
;*		sub	ah,ch
		db	 28h,0ECh		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		add	ah,ah
		db	 00h,0E4h		;  Fixup - byte match
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
		mov	ah,data_B3BF
;*		mov	dl,ah
		db	 88h,0E2h		;  Fixup - byte match
		mov	ah,[si+2]
;*		sub	ah,dl
		db	 28h,0D4h		;  Fixup - byte match
;*		cmp	ah,dh
		db	 38h,0F4h		;  Fixup - byte match
		jnc	loc_2A77		; Jump if carry=0
		jmp	short loc_2A7C
sub_2A48	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2A9C	proc	near
		call	sub_13C7
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2AA4		; Jump if zero
		retn
loc_2AA4:
		push	si
		mov	ah,2Bh			; '+'
		call	sub_0E0F
		pop	di
		jnc	loc_2AAE		; Jump if carry=0
		retn
loc_2AAE:
		push	di
		mov	di,offset data_83DA
		call	sub_255A
		pop	di
		or	byte ptr [si],2
		mov	ah,[di+6]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2ADF		; Jump if not zero
		mov	ah,[di+7]
		sub	ah,2
		mov	[si+7],ah
		mov	ah,[di+8]
		mov	[si+8],ah
		call	sub_13C7
		and	ah,7
		neg	ah
		mov	[si+16h],ah
		mov	byte ptr [si+17h],0ECh
		retn
loc_2ADF:
		cmp	ah,1
		jne	loc_2AFC		; Jump if not equal
		mov	ah,[di+8]
		mov	[si+8],ah
		mov	ah,[di+7]
		add	ah,1
		mov	[si+7],ah
		mov	byte ptr [si+16h],0
		mov	byte ptr [si+17h],0ECh
		retn
loc_2AFC:
		mov	ah,[di+8]
		mov	[si+8],ah
		mov	ah,[di+7]
		add	ah,4
		mov	[si+7],ah
		call	sub_13C7
		and	ah,7
		mov	[si+16h],ah
		mov	byte ptr [si+17h],0ECh
		retn
sub_2A9C	endp

			                        ;* No entry point to code
		mov	ah,[si+17h]
		inc	ah
		inc	ah
		mov	[si+17h],ah
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2B57		; Jump if zero
		mov	ah,[si+8]
		cmp	ah,0Ah
		jb	loc_2B57		; Jump if below
		cmp	ah,78h			; 'x'
		jae	loc_2B57		; Jump if above or =
		mov	ah,[si+7]
		cmp	ah,5
		jb	loc_2B57		; Jump if below
		cmp	ah,4Bh			; 'K'
		jae	loc_2B57		; Jump if above or =
		call	sub_13C7
		cmp	ah,0FAh
		jae	loc_2B4C		; Jump if above or =
		jmp	loc_0DFC
loc_2B4C:
		mov	ah,[si+2]
		cmp	ah,40h			; '@'
		jb	loc_2B57		; Jump if below
		jmp	loc_0DFC
loc_2B57:
		mov	byte ptr [si+0Bh],2
		mov	byte ptr [si+0Ch],0
		and	byte ptr [si],0FDh
		mov	bx,84EBh
		mov	[si+19h],bl
		mov	[si+1Ah],bh
		mov	byte ptr [si+18h],0
		mov	bx,72C6h
		jmp	loc_2292

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2B75	proc	near
		push	di
		push	si
		pop	di
		push	si
		push	dx
		push	cx
		mov	si,d_BA00_B3DA_e
		mov	dx,1Dh
		mov	ch,0Dh
loc_2B83:
		test	byte ptr [si],80h
		jz	loc_2B93		; Jump if zero
		push	si
		push	dx
		push	cx
		call	sub_2C59
		pop	cx
		pop	dx
		pop	si
		jz	loc_2B9E		; Jump if zero
loc_2B93:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_2B83		; Jump if not zero
loc_2B99:
		pop	cx
		pop	dx
		pop	si
		pop	di
		retn
loc_2B9E:
		mov	ah,[si+5]
		cmp	ah,1
		jne	loc_2BAB		; Jump if not equal
		call	sub_0A25
		jmp	short loc_2BE1
loc_2BAB:
		mov	bx,d_BA00_2D44_e
		mov	cl,[bx]
		mov	ch,0
		inc	bx
		call	sub_1109
		jz	loc_2B99		; Jump if zero
		cmp	ah,6
		je	loc_2BE6		; Jump if equal
		mov	ch,[si+5]
		mov	cl,[si+6]
		mov	byte ptr [si+0Bh],2
		mov	byte ptr [si+0Ch],0
		mov	dx,84EBh
		mov	[si+19h],dl
		mov	[si+1Ah],dh
		mov	byte ptr [si+18h],0
		call	sub_08C3
		mov	bx,72C6h
		call	sub_2292
loc_2BE1:
		pop	cx
		pop	dx
		pop	si
		pop	di
		retn
loc_2BE6:
		mov	ah,[si+6]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_2C21		; Jump if not zero
		mov	ah,[si+1]
		sub	ah,2
		mov	[si+7],ah
		mov	byte ptr [si+0Bh],7
		mov	byte ptr [si+0Ch],0
		mov	byte ptr [si+18h],0
		mov	dx,84EBh
		mov	[si+19h],dl
		mov	[si+1Ah],dh
		mov	bl,[si+7]
		mov	bh,[si+8]
		call	sub_11BA
		mov	byte ptr [bx],0
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	byte ptr [bx],0
		jmp	short loc_2C4E
loc_2C21:
		mov	byte ptr [si+0Bh],7
		mov	byte ptr [si+0Ch],0
		mov	byte ptr [si+18h],0
		mov	dx,84EBh
		mov	[si+19h],dl
		mov	[si+1Ah],dh
		mov	bl,[si+7]
		inc	bl
		inc	bl
		mov	bh,[si+8]
		call	sub_11BA
		mov	byte ptr [bx],0
		mov	dx,28h
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	byte ptr [bx],0
loc_2C4E:
		mov	bx,72C6h
		call	sub_2292
		pop	cx
		pop	dx
		pop	si
		pop	di
		retn
sub_2B75	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C59	proc	near
		mov	ah,data_B57A
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jz	loc_2C66		; Jump if zero
		mov	dl,[di+1]
		jmp	short loc_2C68
loc_2C66:
		mov	dl,[di]
loc_2C68:
		mov	ah,[si+1]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		add	ah,[si+11h]
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		call	sub_2C89
		jz	loc_2C78		; Jump if zero
		retn
loc_2C78:
		mov	dl,[di+6]
		mov	ah,[si+2]
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		add	ah,[si+12h]
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		call	sub_2C89
		retn
sub_2C59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C89	proc	near
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
;*		cmp	ah,ch
		db	 38h,0ECh		;  Fixup - byte match
		jnc	loc_2C90		; Jump if carry=0
		retn
loc_2C90:
		jnz	loc_2C93		; Jump if not zero
		retn
loc_2C93:
;*		mov	ah,dl
		db	 88h,0D4h		;  Fixup - byte match
;*		cmp	ah,cl
		db	 38h,0CCh		;  Fixup - byte match
		jc	loc_2C9A		; Jump if carry Set
		retn
loc_2C9A:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		retn
sub_2C89	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C9F	proc	near
		mov	si,d_BA00_B3F7_e
		mov	ch,0Bh
		mov	dx,1Dh
loc_2CA7:
		test	byte ptr [si],80h
		jz	loc_2CCD		; Jump if zero
		mov	ah,[si+5]
		cmp	ah,2
		je	loc_2CCD		; Jump if equal
		cmp	ah,7
		je	loc_2CCD		; Jump if equal
		cmp	ah,17h
		je	loc_2CCD		; Jump if equal
		push	si
		push	dx
		push	cx
		mov	di,offset data_B3BD
		call	sub_2CD5
		pop	cx
		pop	dx
		pop	si
		jc	loc_2CCD		; Jump if carry Set
		retn
loc_2CCD:
;*		add	si,dx
		db	 01h,0D6h		;  Fixup - byte match
		dec	ch
		jnz	loc_2CA7		; Jump if not zero
		stc				; Set carry flag
		retn
sub_2C9F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CD5	proc	near
		mov	ah,[si+7]
		add	ah,[si+11h]
		cmp	ah,[di+7]
		jae	loc_2CE1		; Jump if above or =
		retn
loc_2CE1:
		mov	ah,[di+7]
		add	ah,[di+11h]
		cmp	ah,[si+7]
		jae	loc_2CED		; Jump if above or =
		retn
loc_2CED:
		mov	ah,[si+8]
		add	ah,[si+12h]
		cmp	ah,[di+8]
		jae	loc_2CF9		; Jump if above or =
		retn
loc_2CF9:
		mov	ah,[di+8]
		add	ah,[di+12h]
		cmp	ah,[si+8]
		retn
sub_2CD5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D03	proc	near
		push	bx
		push	dx
		push	cx
		push	di
		mov	ch,0Ch
		mov	di,offset data_B3DA
		mov	dx,1Dh
loc_2D0F:
		push	si
		push	di
		pop	dx
		pop	bx
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
;*		sbb	bx,dx
		db	 19h,0D3h		;  Fixup - byte match
		jz	loc_2D23		; Jump if zero
		test	byte ptr [di],80h
		jz	loc_2D23		; Jump if zero
		call	sub_2CD5
		jnc	loc_2D32		; Jump if carry=0
loc_2D23:
		mov	dx,1Dh
;*		add	di,dx
		db	 01h,0D7h		;  Fixup - byte match
		dec	ch
		jnz	loc_2D0F		; Jump if not zero
		stc				; Set carry flag
loc_2D2D:
		pop	di
		pop	cx
		pop	dx
		pop	bx
		retn
loc_2D32:
		mov	ah,[di+5]
		cmp	ah,1
		jne	loc_2D40		; Jump if not equal
		call	sub_0A25
		stc				; Set carry flag
		jmp	short loc_2D2D
loc_2D40:
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jmp	short loc_2D2D
sub_2D03	endp

		db	 0Ah, 02h, 07h, 0Bh, 11h, 12h
		db	 17h, 20h, 28h, 29h, 2Ah, 5Ch
		db	 10h, 00h, 00h, 4Eh, 02h, 24h
		db	 00h, 4Eh, 02h, 01h, 03h, 9Fh
		db	 01h, 01h, 09h, 9Fh, 01h, 00h
		db	 0Eh, 4Eh, 02h, 25h, 03h, 9Fh
		db	 01h, 25h, 07h, 9Fh, 01h, 24h
		db	 0Eh, 4Eh, 02h, 04h, 00h, 8Fh
		db	 01h, 0Ch, 00h, 8Fh, 01h, 14h
		db	 00h, 8Fh, 01h, 1Ch, 00h, 8Fh
		db	 01h, 04h, 0Fh, 79h, 03h, 0Ch
		db	 0Fh, 79h, 03h, 14h, 0Fh, 79h
		db	 03h, 1Ch, 0Fh, 79h, 03h, 14h
		db	 00h, 0Fh, 01h, 00h, 08h, 0Fh
		db	 01h, 00h, 10h, 0Fh, 01h, 00h
		db	 18h, 0Fh, 01h, 00h, 20h, 0Fh
		db	 01h, 00h, 00h, 00h, 13h, 00h
		db	 08h, 00h, 13h, 00h, 18h, 00h
		db	 13h, 00h, 20h, 00h, 13h, 00h
		db	 00h, 01h, 45h, 00h, 00h, 08h
		db	 45h, 00h, 05h, 01h, 02h, 01h
		db	 06h, 01h, 9Bh, 00h, 08h, 09h
		db	 9Bh, 00h, 0Dh, 02h, 02h, 01h
		db	 04h, 07h, 59h, 00h, 03h, 08h
		db	0DDh, 00h, 0Ch, 00h, 9Bh, 00h
		db	 10h, 00h, 13h, 00h, 0Dh, 01h
		db	 02h, 01h, 0Eh, 00h, 0Fh, 01h
		db	 00h, 08h, 0Fh, 01h, 00h, 10h
		db	 0Fh, 01h, 00h, 18h, 0Fh, 01h
		db	 00h, 20h, 0Fh, 01h, 00h, 00h
		db	 00h, 13h, 00h, 08h, 00h, 13h
		db	 00h, 10h, 00h, 13h, 00h, 18h
		db	 00h, 13h, 00h, 20h, 00h, 13h
		db	 00h, 26h, 01h, 45h, 00h, 1Ah
		db	 01h,0CBh, 00h, 0Ch, 01h,0AFh
		db	 00h, 07h, 01h,0CBh, 00h, 0Eh
		db	 00h, 0Fh, 01h, 00h, 08h, 0Fh
		db	 01h, 00h, 10h, 0Fh, 01h, 00h
		db	 18h, 0Fh, 01h, 00h, 20h, 0Fh
		db	 01h, 00h, 00h, 00h, 13h, 00h
		db	 08h, 00h, 13h, 00h, 10h, 00h
		db	 13h, 00h, 18h, 00h, 13h, 00h
		db	 20h, 00h, 13h, 00h, 00h, 01h
		db	 45h, 00h, 02h, 01h, 79h, 00h
		db	 09h, 01h, 9Bh, 00h, 13h, 01h
		db	0AFh, 00h, 10h, 00h, 0Fh, 01h
		db	 00h, 08h, 0Fh, 01h, 00h, 10h
		db	 0Fh, 01h, 00h, 18h, 0Fh, 01h
		db	 00h, 20h, 0Fh, 01h, 00h, 00h
		db	 00h, 13h, 00h, 18h, 00h, 13h
		db	 00h, 20h, 00h, 13h, 00h, 08h
		db	 00h, 13h, 00h, 18h, 01h, 25h
		db	 00h, 19h, 02h, 1Dh, 00h, 0Ah
		db	 00h, 13h, 00h, 17h, 00h, 13h
		db	 00h, 0Ch, 01h, 25h, 00h, 0Dh
		db	 02h, 1Dh, 00h, 1Ah, 08h, 71h
		db	 01h, 12h, 00h, 0Fh, 01h, 00h
		db	 08h, 0Fh, 01h, 00h, 10h, 0Fh
		db	 01h, 00h, 18h, 0Fh, 01h, 00h
		db	 20h, 0Fh, 01h, 00h, 00h, 00h
		db	 13h, 00h, 18h, 00h, 13h, 00h
		db	 20h, 00h, 13h, 00h, 08h, 00h
		db	 13h, 00h, 10h, 00h, 13h, 00h
		db	 14h, 01h, 59h, 00h, 11h, 01h
		db	 64h, 00h, 09h, 03h, 6Fh, 00h
		db	 17h, 03h, 6Fh, 00h, 1Ah, 03h
		db	 55h, 00h, 0Ch, 03h, 55h, 00h
		db	 07h, 01h, 59h, 00h, 1Eh, 01h
		db	 64h, 00h, 11h, 00h, 0Fh, 01h
		db	 00h, 08h, 0Fh, 01h, 00h, 10h
		db	 0Fh, 01h, 00h, 18h, 0Fh, 01h
		db	 00h, 20h, 0Fh, 01h, 00h, 00h
		db	 00h, 13h, 00h, 18h, 00h, 13h
		db	 00h, 20h, 00h, 13h, 00h, 08h
		db	 00h, 13h, 00h, 18h, 01h, 25h
		db	 00h, 19h, 02h, 1Dh, 00h, 1Eh
		db	 01h, 64h, 00h, 17h, 00h, 13h
		db	 00h, 0Ah, 00h, 13h, 00h, 0Ch
		db	 01h, 25h, 00h, 08h, 01h, 59h
		db	 00h, 0Dh, 02h, 1Dh, 00h, 13h
		db	 00h, 0Fh, 01h, 00h, 08h, 0Fh
		db	 01h, 00h, 10h, 0Fh, 01h, 00h
		db	 18h, 0Fh, 01h, 00h, 20h, 0Fh
		db	 01h, 00h, 00h, 00h, 13h, 00h
		db	 18h, 00h, 13h, 00h, 08h, 00h
		db	 13h, 00h, 10h, 00h, 13h, 00h
		db	 26h, 07h, 0Fh, 01h, 1Eh, 08h
		db	 0Bh, 01h, 20h, 0Fh, 29h, 01h
		db	 20h, 0Fh, 21h, 01h, 18h, 01h
		db	 4Dh, 01h, 06h, 01h, 37h, 01h
		db	 0Bh, 03h, 67h, 01h, 0Eh, 01h
		db	 9Bh, 00h, 26h, 00h, 0Fh, 01h
		db	 1Eh, 00h, 0Fh, 01h, 0Eh, 00h
		db	 0Fh, 79h, 01h, 0Ah, 0Fh, 79h
		db	 01h, 14h, 0Fh, 79h, 01h, 00h
		db	 00h, 8Fh, 01h, 08h, 00h, 8Fh
		db	 01h, 10h, 00h, 8Fh, 01h, 18h
		db	 00h, 8Fh, 01h, 20h, 00h, 8Fh
		db	 01h, 1Eh, 0Fh, 99h, 01h, 26h
		db	 0Fh, 99h, 01h, 26h, 01h, 9Fh
		db	 01h, 26h, 07h, 9Fh, 01h, 20h
		db	 01h, 4Dh, 01h, 0Ch, 01h,0B8h
		db	 01h, 12h, 00h, 00h, 8Fh, 01h
		db	 08h, 00h, 8Fh, 01h, 18h, 00h
		db	 8Fh, 01h, 20h, 00h, 8Fh, 01h
		db	 1Eh, 0Fh, 79h, 01h, 19h, 0Fh
		db	 79h, 01h, 10h, 00h, 8Fh, 01h
		db	 00h, 01h,0B8h, 01h, 00h, 0Fh
		db	 1Dh, 03h, 11h, 0Fh,0B1h, 01h
		db	 02h, 0Fh, 79h, 01h, 07h, 0Fh
		db	 79h, 01h, 17h, 0Fh, 1Dh, 03h
		db	 17h, 0Fh,0B1h, 01h, 0Fh, 01h
		db	0E3h, 01h, 15h, 01h,0E3h, 01h
		db	 19h, 04h, 71h, 01h, 19h, 08h
		db	 71h, 01h, 0Fh, 00h, 0Fh, 79h
		db	 01h, 0Ah, 0Fh, 79h, 01h, 00h
		db	 00h, 8Fh, 01h
		db	8
data_3000	db	0			; Data table (indexed access)
		db	 8Fh, 01h, 10h, 00h, 8Fh, 01h
		db	 18h, 00h, 8Fh, 01h, 20h, 00h
		db	 8Fh, 01h, 14h, 0Fh, 79h, 01h
		db	 1Eh, 0Fh, 79h, 01h, 0Bh, 01h
		db	0D8h, 01h, 1Ah, 01h,0D8h, 01h
		db	 15h, 01h,0E3h, 01h, 0Fh, 01h
		db	0E3h, 01h, 1Eh, 01h,0B8h, 01h
		db	 00h, 01h,0B8h, 01h, 11h, 08h
		db	 00h, 8Fh, 01h, 18h, 00h, 8Fh
		db	 01h, 20h, 00h, 8Fh, 01h, 1Eh
		db	 0Fh, 79h, 01h, 10h, 00h, 8Fh
		db	 01h, 0Dh, 01h, 59h, 00h, 18h
		db	 01h, 64h, 00h, 10h, 03h, 6Fh
		db	 00h, 00h, 00h, 9Bh, 00h, 00h
		db	 00h, 8Fh, 01h, 17h, 0Fh,0B1h
		db	 01h, 11h, 0Fh,0B1h, 01h, 18h
		db	 0Fh, 79h, 01h, 07h, 0Fh, 79h
		db	 01h, 00h, 0Fh, 79h, 01h, 22h
		db	 01h,0F9h, 03h, 23h, 02h,0E3h
		db	 01h, 10h, 00h, 0Fh, 79h, 01h
		db	 0Ah, 0Fh, 79h, 01h, 00h, 00h
		db	 8Fh, 01h, 08h, 00h, 8Fh, 01h
		db	 10h, 00h, 8Fh, 01h, 18h, 00h
		db	 8Fh, 01h, 20h, 00h, 8Fh, 01h
		db	 14h, 0Fh, 79h, 01h, 1Eh, 0Fh
		db	 79h, 01h, 16h, 01h,0EDh, 01h
		db	 1Eh, 02h, 67h, 01h, 20h, 02h
		db	 67h, 01h, 00h, 01h, 9Fh, 01h
		db	 02h, 01h, 79h, 00h, 09h, 01h
		db	 9Bh, 00h, 00h, 08h, 0Bh, 01h
		db	 14h, 00h, 0Fh, 79h, 01h, 0Ah
		db	 0Fh, 79h, 01h, 08h, 00h, 8Fh
		db	 01h, 10h, 00h, 8Fh, 01h, 20h
		db	 00h, 8Fh, 01h, 14h, 0Fh, 79h
		db	 01h, 1Eh, 0Fh, 79h, 01h, 21h
		db	 01h, 64h, 00h, 1Dh, 00h, 02h
		db	 01h, 1Dh, 05h,0EDh, 01h, 20h
		db	 03h, 67h, 01h, 20h, 07h, 67h
		db	 01h, 20h, 02h,0DDh, 00h, 26h
		db	 01h, 9Fh, 01h, 26h, 08h, 0Bh
		db	 01h, 18h, 00h, 8Fh, 01h, 15h
		db	 01h,0EDh, 01h, 00h, 00h, 9Bh
		db	 00h, 00h, 00h, 8Fh, 01h, 0Ch
		db	 01h,0D8h, 01h, 11h, 0Ah, 0Fh
		db	 79h, 01h, 08h, 00h, 8Fh, 01h
		db	 10h, 00h, 8Fh, 01h, 20h, 00h
		db	 8Fh, 01h, 14h, 0Fh, 79h, 01h
		db	 1Eh, 0Fh, 79h, 01h, 18h, 00h
		db	 8Fh, 01h, 00h, 0Fh, 79h, 01h
		db	 00h, 00h, 0Fh, 01h, 00h, 07h
		db	 0Fh, 01h, 08h, 00h, 0Fh, 01h
		db	 08h, 07h, 0Bh, 01h, 02h, 0Fh
		db	 29h, 01h, 02h, 0Fh, 21h, 01h
		db	 20h, 01h,0EDh, 01h, 0Ah, 01h
		db	 79h, 00h, 16h, 01h,0E3h, 01h
		db	 11h, 00h, 0Fh, 99h, 01h, 08h
		db	 0Fh, 99h, 01h, 0Ah, 0Fh, 22h
		db	 02h, 12h, 0Fh, 22h, 02h, 1Ah
		db	 0Fh, 22h, 02h, 20h, 0Fh, 22h
		db	 02h, 00h, 00h, 34h, 02h, 10h
		db	 00h, 34h, 02h, 18h, 00h, 34h
		db	 02h, 20h, 00h, 34h, 02h, 00h
		db	 01h, 3Eh, 02h, 00h, 08h, 3Eh
		db	 02h, 04h, 01h,0EDh, 01h, 05h
		db	 00h, 9Bh, 00h, 02h, 02h,0FFh
		db	 01h, 08h, 00h, 34h, 02h, 0Dh
		db	 01h, 9Bh, 00h, 11h, 20h, 0Fh
		db	 22h, 02h, 00h, 00h, 34h, 02h
		db	 10h, 00h, 34h, 02h, 18h, 00h
		db	 34h, 02h, 20h, 00h, 34h, 02h
		db	 08h, 00h, 34h, 02h, 00h, 0Fh
		db	 22h, 02h, 08h, 0Fh, 22h, 02h
		db	 10h, 0Fh, 22h, 02h, 18h, 0Fh
		db	 22h, 02h, 07h, 01h, 5Ch, 02h
		db	 1Eh, 01h, 5Ch, 02h, 0Ch, 01h
		db	 59h, 00h, 19h, 01h, 64h, 00h
		db	 0Fh, 03h, 6Fh, 00h, 11h, 03h
		db	 6Fh, 00h, 12h, 02h, 4Eh, 02h
		db	 0Fh
		db	20h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_31D7	proc	near
		db	 0Fh, 22h, 02h, 00h, 00h, 34h
		db	 02h, 18h, 00h, 34h, 02h, 20h
		db	 00h, 34h, 02h, 08h, 00h, 34h
		db	 02h, 00h, 0Fh, 22h, 02h, 08h
		db	 0Fh, 22h, 02h, 10h, 0Fh, 22h
		db	 02h, 18h, 0Fh, 22h, 02h, 20h
		db	 01h,0EDh, 01h, 18h, 01h
data_3200	db	25h
		db	 00h, 07h, 01h, 5Ch, 02h, 0Ah
		db	 00h, 34h, 02h, 17h, 00h, 34h
		db	 02h, 1Ah, 08h, 71h, 01h, 11h
		db	 20h, 0Fh, 22h, 02h, 00h, 00h
		db	 34h, 02h, 18h, 00h, 34h, 02h
		db	 20h, 00h, 34h, 02h
		db	8
data_3224	db	0
		db	 34h, 02h, 00h, 0Fh, 22h, 02h
		db	 08h, 0Fh, 22h, 02h, 10h, 0Fh
		db	 22h, 02h, 18h, 0Fh, 22h, 02h
		db	 10h, 00h, 34h, 02h, 00h, 02h
		db	 67h, 01h, 08h, 01h, 64h, 02h
		db	 0Ch, 02h, 67h, 01h, 14h, 01h
		db	 64h, 02h, 18h, 02h, 67h, 01h
		db	 20h, 02h, 67h, 01h, 20h, 01h
		db	 64h, 02h, 10h, 20h, 0Fh, 22h
		db	 02h, 18h, 00h, 34h, 02h, 20h
		db	 00h, 34h, 02h, 08h, 00h, 34h
		db	 02h, 00h, 0Fh, 22h, 02h, 08h
		db	 0Fh, 22h, 02h, 10h, 0Fh, 22h
		db	 02h, 18h, 0Fh, 22h, 02h, 00h
		db	 00h, 9Bh, 00h, 00h, 00h, 34h
		db	 02h, 18h, 01h, 25h, 00h, 19h
		db	 05h, 64h, 00h, 0Ah, 00h, 34h
		db	 02h, 17h, 00h, 34h, 02h, 0Ch
		db	 01h, 25h, 00h, 0Dh, 05h, 59h
		db	 00h, 0Eh, 20h, 0Fh, 22h, 02h
		db	 00h, 00h, 34h, 02h, 18h, 00h
		db	 34h, 02h, 20h, 00h, 34h, 02h
		db	 08h, 00h, 34h, 02h, 00h, 0Fh
		db	 22h, 02h, 08h, 0Fh, 22h, 02h
		db	 10h, 0Fh, 22h, 02h, 18h, 0Fh
		db	 22h, 02h, 10h, 00h, 34h, 02h
		db	 07h, 01h, 72h, 02h, 19h, 01h
		db	 72h, 02h, 11h, 01h, 5Ch, 02h
		db	 14h, 01h, 5Ch, 02h, 14h, 00h
		db	 00h, 34h, 02h, 10h, 00h, 34h
		db	 02h, 18h, 00h, 34h, 02h, 08h
		db	 00h, 34h, 02h, 00h, 0Fh, 22h
		db	 02h, 08h, 0Fh, 22h, 02h, 10h
		db	 0Fh, 22h, 02h, 18h, 0Fh, 22h
		db	 02h, 26h, 00h, 0Fh, 01h, 26h
		db	 08h, 0Fh, 01h, 20h, 0Fh, 22h
		db	 02h, 20h, 0Fh, 29h, 01h, 20h
		db	 0Fh, 21h, 01h, 1Eh, 00h, 0Fh
		db	 01h, 1Eh, 07h, 0Bh, 01h, 08h
		db	 01h, 4Dh, 01h, 0Eh, 01h, 79h
		db	 00h, 15h, 02h, 67h, 01h, 17h
		db	 01h, 64h, 02h, 1Bh, 01h, 64h
		db	 02h, 11h, 00h, 0Fh, 9Eh, 02h
		db	 09h, 0Fh, 9Eh, 02h, 12h, 0Fh
		db	 9Eh, 02h, 00h, 00h,0B2h, 02h
		db	 08h, 00h,0B2h, 02h, 10h, 00h
		db	0B2h, 02h, 18h, 00h,0B2h, 02h
		db	 20h, 00h,0B2h, 02h, 26h, 01h
		db	0BFh, 02h, 26h, 08h,0BFh, 02h
		db	 26h, 0Fh, 99h, 01h, 15h, 0Fh
		db	 9Eh, 02h, 1Eh, 0Fh, 99h, 01h
		db	 21h, 01h,0CFh, 02h, 0Eh, 01h
		db	 19h, 03h, 00h, 02h, 0Fh, 03h
		db	 06h, 02h, 0Fh, 03h, 13h, 00h
		db	 00h,0B2h, 02h, 08h, 00h,0B2h
		db	 02h, 10h, 00h,0B2h, 02h, 18h
		db	 00h,0B2h, 02h, 20h, 00h,0B2h
		db	 02h, 1Fh, 0Fh, 9Eh, 02h, 16h
		db	 0Fh, 9Eh, 02h, 0Dh, 0Fh, 9Eh
		db	 02h, 04h, 0Fh, 9Eh, 02h, 00h
		db	 0Fh, 05h, 03h, 12h, 00h,0BFh
		db	 02h, 0Dh, 01h,0CFh, 02h, 14h
		db	 01h,0EAh, 02h, 1Ch, 01h, 19h
		db	 03h, 1Dh, 02h, 0Fh, 03h, 20h
		db	 02h, 0Fh, 03h, 09h, 01h, 19h
		db	 03h, 00h, 02h, 0Fh, 03h, 01h
		db	 02h, 0Fh, 03h, 11h, 00h, 0Fh
		db	 9Eh, 02h, 09h, 0Fh, 9Eh, 02h
		db	 17h, 0Fh, 9Eh, 02h, 20h, 0Fh
		db	 23h, 03h, 20h, 00h,0B2h, 02h
		db	 08h, 00h,0B2h, 02h, 00h, 00h
		db	0B2h, 02h, 20h, 02h, 0Fh, 03h
		db	 1Fh, 01h, 19h, 03h, 18h, 01h
		db	0E3h, 01h, 0Ah, 01h, 79h, 00h
		db	 07h, 01h, 4Dh, 01h, 10h, 00h
		db	0B2h, 02h, 18h, 00h,0B2h, 02h
		db	 19h, 06h, 71h, 01h, 19h, 08h
		db	 71h, 01h, 19h, 04h, 71h, 01h
		db	 14h, 00h, 00h,0B2h, 02h, 08h
		db	 00h,0B2h, 02h, 10h, 00h,0B2h
		db	 02h, 18h, 00h,0B2h, 02h, 20h
		db	 00h,0B2h, 02h, 1Fh, 0Fh, 9Eh
		db	 02h, 16h, 0Fh, 9Eh, 02h, 0Dh
		db	 0Fh, 9Eh, 02h, 04h, 0Fh, 9Eh
		db	 02h, 00h, 0Fh, 05h, 03h, 00h
		db	 06h,0B2h, 02h, 1Ch, 01h,0EAh
		db	 02h, 17h, 01h,0CFh, 02h, 12h
		db	 01h,0EAh, 02h, 0Dh, 01h,0CFh
		db	 02h, 10h, 05h,0B2h, 02h, 16h
		db	 05h,0B2h, 02h, 1Dh, 05h, 0Bh
		db	 01h, 0Fh, 05h, 0Bh, 01h, 06h
		db	 06h, 0Bh, 01h, 10h, 00h, 0Fh
		db	 9Eh, 02h, 09h, 0Fh, 9Eh, 02h
		db	 17h, 0Fh, 9Eh, 02h, 20h, 0Fh
		db	 23h, 03h, 20h, 00h,0B2h, 02h
		db	 08h, 00h,0B2h, 02h, 10h, 00h
		db	0B2h, 02h, 20h, 06h,0B2h, 02h
		db	 18h, 06h,0B2h, 02h, 13h, 01h
		db	0CFh, 02h, 0Dh, 01h,0E3h, 01h
		db	 00h, 00h,0B2h, 02h, 00h, 02h
		db	 0Fh, 03h, 08h, 01h, 19h, 03h
		db	 18h, 00h,0BFh, 02h, 1Fh, 00h
		db	0B2h, 02h, 13h, 00h, 00h,0B2h
		db	 02h, 08h, 00h,0B2h, 02h, 10h
		db	 00h,0B2h, 02h, 18h, 00h,0B2h
		db	 02h, 20h, 00h,0B2h, 02h, 1Fh
		db	 0Fh, 9Eh, 02h, 16h, 0Fh, 9Eh
		db	 02h, 0Dh, 0Fh, 9Eh, 02h, 04h
		db	 0Fh, 9Eh, 02h, 00h, 0Fh, 05h
		db	 03h, 20h, 02h, 0Fh, 03h, 1Fh
		db	 01h, 19h, 03h, 07h, 01h,0CFh
		db	 02h, 0Ch, 00h,0BFh, 02h, 0Eh
		db	 03h, 67h, 01h, 11h, 01h,0DDh
		db	 00h, 16h, 03h, 64h, 02h, 02h
		db	 01h,0EAh, 02h, 00h, 03h,0EAh
		db	 02h, 18h, 08h, 00h,0B2h, 02h
		db	 10h, 00h,0B2h, 02h, 18h, 00h
		db	0B2h, 02h, 20h, 00h,0B2h, 02h
		db	 20h, 0Fh, 23h, 03h, 17h, 0Fh
		db	 9Eh, 02h, 0Eh, 0Fh, 9Eh, 02h
		db	 05h, 0Fh, 9Eh, 02h, 02h, 0Fh
		db	 29h, 01h, 00h, 00h, 0Fh, 01h
		db	 00h, 07h, 0Fh, 01h, 08h, 00h
		db	 0Fh, 01h, 00h, 0Fh, 99h, 01h
		db	 02h, 0Fh, 21h, 01h, 0Ah, 01h
		db	0BFh, 02h, 0Ch, 01h,0EAh, 02h
		db	 08h, 07h, 0Bh, 01h, 26h, 01h
		db	0BFh, 02h, 12h, 01h, 19h, 03h
		db	 13h, 02h, 0Fh, 03h, 21h, 03h
		db	0CFh, 02h, 1Fh, 01h,0CFh, 02h
		db	 1Dh, 01h, 19h, 03h, 15h, 02h
		db	 0Fh, 03h, 11h, 08h, 0Fh, 49h
		db	 03h, 10h, 0Fh, 49h, 03h, 18h
		db	 0Fh, 49h, 03h, 20h, 0Fh, 49h
		db	 03h, 00h, 00h,0BFh, 02h, 00h
		db	 07h,0BFh, 02h, 00h, 08h,0BFh
		db	 02h, 00h, 0Fh, 99h, 01h, 08h
		db	 0Fh, 99h, 01h, 0Bh, 00h, 35h
		db	 03h, 14h, 00h, 35h, 03h, 1Dh
		db	 00h, 35h, 03h, 26h, 00h, 5Bh
		db	 03h, 02h, 00h, 49h, 03h, 03h
		db	 00h, 49h, 03h, 02h, 02h,0EAh
		db	 02h, 0Ah, 00h,0B1h, 01h, 14h
		db	 20h, 0Fh, 49h, 03h, 00h, 0Fh
		db	 49h, 03h, 00h, 00h, 35h, 03h
		db	 08h, 0Fh, 9Eh, 02h, 11h, 0Fh
		db	 9Eh, 02h, 17h, 0Fh, 9Eh, 02h
		db	 1Fh, 00h, 35h, 03h, 09h, 00h
		db	0B2h, 02h, 17h, 00h,0B2h, 02h
		db	 11h, 00h,0B2h, 02h, 09h, 01h
		db	0CFh, 02h, 1Ah, 01h,0EAh, 02h
		db	 0Eh, 05h, 35h, 03h, 11h, 05h
		db	 35h, 03h, 0Dh, 01h, 19h, 03h
		db	 1Ah, 01h, 19h, 03h, 0Eh, 02h
		db	 0Fh, 03h, 12h, 02h, 0Fh, 03h
		db	 12h, 01h, 4Eh, 02h, 12h, 08h
		db	 71h, 01h, 16h, 08h, 0Fh, 49h
		db	 03h, 10h, 0Fh, 49h, 03h, 20h
		db	 0Fh, 49h, 03h, 00h, 0Fh, 49h
		db	 03h, 06h, 0Fh, 9Eh, 02h, 00h
		db	 00h, 35h, 03h, 1Fh, 00h, 35h
		db	 03h, 06h, 00h, 49h, 03h, 1Ah
		db	 00h, 49h, 03h, 0Eh, 00h,0B2h
		db	 02h, 12h, 00h,0B2h, 02h, 0Ch
		db	 00h,0BFh, 02h, 07h, 02h,0CFh
		db	 02h, 0Eh, 01h,0EAh, 02h, 15h
		db	 01h,0CFh, 02h, 1Ch, 02h,0EAh
		db	 02h, 13h, 01h, 61h, 03h, 1Ah
		db	 00h,0BFh, 02h, 0Ch, 07h, 6Bh
		db	 03h, 1Ah, 07h, 6Bh, 03h, 1Fh
		db	 0Fh, 49h, 03h, 12h, 0Fh, 49h
		db	 03h, 0Bh, 08h, 0Fh, 49h, 03h
		db	 10h, 0Fh, 49h, 03h, 18h, 0Fh
		db	 49h, 03h, 20h, 0Fh, 49h, 03h
		db	 00h, 0Fh, 49h, 03h, 00h, 00h
		db	 35h, 03h, 1Fh, 00h, 35h, 03h
		db	 09h, 00h, 61h, 03h, 1Dh, 00h
		db	 61h, 03h, 0Bh, 00h, 35h, 03h
		db	 14h, 00h, 35h, 03h, 17h, 00h
		db	 0Fh, 49h, 03h, 08h, 0Fh, 49h
		db	 03h, 10h, 0Fh, 49h, 03h, 18h
		db	 0Fh, 49h, 03h, 00h, 00h, 35h
		db	 03h, 09h, 00h,0B2h, 02h, 17h
		db	 00h,0B2h, 02h, 1Fh, 00h, 35h
		db	 03h, 20h, 0Fh, 49h, 03h, 0Ch
		db	 01h, 25h, 00h, 0Dh, 02h, 1Dh
		db	 00h, 09h, 0Fh, 1Dh, 03h, 1Dh
		db	 0Fh, 1Dh, 03h, 1Ch, 01h, 61h
		db	 03h, 1Eh, 01h, 19h, 03h, 1Eh
		db	 02h, 19h, 03h, 1Fh, 03h, 0Fh
		db	 03h, 20h, 03h, 0Fh, 03h, 09h
		db	 01h, 61h, 03h, 16h, 00h,0B2h
		db	 02h, 16h, 01h, 25h, 00h, 17h
		db	 02h, 1Dh, 00h, 18h, 08h, 71h
		db	 01h, 16h, 00h, 0Fh, 49h, 03h
		db	 08h, 0Fh, 49h, 03h, 10h, 0Fh
		db	 49h, 03h, 18h, 0Fh, 49h, 03h
		db	 00h, 00h, 35h, 03h, 1Fh, 00h
		db	 35h, 03h, 20h, 0Fh, 49h, 03h
		db	 09h, 00h, 49h, 03h, 17h, 00h
		db	 49h, 03h, 0Bh, 02h,0CFh, 02h
		db	 0Fh, 00h,0BFh, 02h, 0Fh, 07h
		db	 6Bh, 03h, 0Ah, 02h, 19h, 03h
		db	 00h, 03h, 0Fh, 03h, 02h, 03h
		db	 0Fh, 03h, 20h, 03h, 0Fh, 03h
		db	 16h, 07h, 6Bh, 03h, 17h, 02h
		db	0EAh, 02h, 16h, 00h,0BFh, 02h
		db	 1Ch, 02h, 19h, 03h, 1Dh, 03h
		db	 0Fh, 03h, 16h, 09h, 71h, 01h
		db	 15h, 00h, 0Fh, 49h, 03h, 08h
		db	 0Fh, 9Eh, 02h, 26h, 0Fh, 99h
		db	 01h, 26h, 00h, 0Fh, 01h, 26h
		db	 07h, 0Fh, 01h, 1Eh, 0Fh, 99h
		db	 01h, 16h, 0Fh, 49h, 03h, 11h
		db	 0Fh, 9Eh, 02h, 1Eh, 00h, 0Fh
		db	 01h, 1Eh, 07h, 0Bh, 01h, 20h
		db	 0Fh, 29h, 01h, 20h, 0Fh, 21h
		db	 01h, 09h, 00h, 35h, 03h, 12h
		db	 00h,0B2h, 02h, 16h, 00h,0B2h
		db	 02h, 13h, 01h,0B8h, 01h, 00h
		db	 00h,0B2h, 02h, 01h, 00h,0B2h
		db	 02h, 07h, 01h, 19h, 03h, 00h
		db	 03h, 0Fh, 03h, 07h, 02h, 19h
		db	 03h, 13h, 00h, 00h, 6Fh, 03h
		db	 08h, 00h, 6Fh, 03h, 10h, 00h
		db	 6Fh, 03h, 18h, 00h, 6Fh, 03h
		db	 20h, 00h, 6Fh, 03h, 26h, 01h
		db	 99h, 03h, 26h, 09h, 99h, 03h
		db	 20h, 01h, 4Dh, 01h, 0Ah, 02h
		db	 6Fh, 00h, 11h, 02h, 6Fh, 00h
		db	 07h, 00h, 59h, 00h, 18h, 00h
		db	 64h, 00h, 22h, 05h,0ABh, 03h
		db	 00h, 0Fh, 8Bh, 03h, 06h, 0Fh
		db	 79h, 03h, 0Eh, 0Fh, 79h, 03h
		db	 16h, 0Fh, 79h, 03h, 1Eh, 0Fh
		db	 99h, 01h, 26h, 0Fh, 99h, 01h
		db	 13h, 00h, 0Fh, 79h, 03h, 08h
		db	 0Fh, 79h, 03h, 10h, 0Fh,0B1h
		db	 01h, 08h, 00h, 6Fh, 03h, 10h
		db	 00h, 6Fh, 03h, 12h, 05h,0E3h
		db	 01h, 0Eh, 01h, 4Dh, 01h, 12h
		db	 01h, 79h, 00h, 07h, 03h, 6Fh
		db	 03h, 07h, 00h,0BDh, 03h, 00h
		db	 00h, 6Fh, 03h, 18h, 00h, 6Fh
		db	 03h, 19h, 03h,0C9h, 03h, 20h
		db	 00h,0C3h, 03h, 20h, 00h, 6Fh
		db	 03h, 16h, 0Fh,0B1h, 01h, 17h
		db	 0Fh, 79h, 03h, 1Fh, 0Fh, 79h
		db	 03h, 27h, 0Fh, 8Dh, 04h, 17h
		db	 00h, 0Fh, 79h, 03h, 08h, 0Fh
		db	 79h, 03h, 10h, 0Fh,0B1h, 01h
		db	 08h, 00h, 6Fh, 03h, 10h, 00h
		db	 6Fh, 03h, 18h, 00h, 6Fh, 03h
		db	 19h, 03h,0C9h, 03h, 20h, 00h
		db	0C3h, 03h, 20h, 00h,0C9h, 03h
		db	 07h, 03h,0C9h, 03h, 07h, 00h
		db	0BDh, 03h, 00h, 00h, 6Fh, 03h
		db	 12h, 01h,0E3h, 01h, 08h, 01h
		db	 0Fh, 03h, 0Fh, 01h, 61h, 03h
		db	 18h, 01h, 0Fh, 03h, 17h, 01h
		db	 61h, 03h, 0Ah, 04h,0E3h, 01h
		db	 1Ah, 04h,0E3h, 01h, 16h, 0Fh
		db	0B1h, 01h, 17h, 0Fh, 79h, 03h
		db	 1Fh, 0Fh, 79h, 03h, 27h, 0Fh
		db	 8Dh, 04h, 10h, 00h, 00h, 6Fh
		db	 03h, 08h, 00h, 6Fh, 03h, 10h
		db	 00h, 6Fh, 03h, 18h, 00h, 6Fh
		db	 03h, 20h, 00h, 6Fh, 03h, 00h
		db	 0Fh, 79h, 03h, 08h, 0Fh, 79h
		db	 03h, 10h, 0Fh, 79h, 03h, 18h
		db	 0Fh, 79h, 03h, 20h, 0Fh, 79h
		db	 03h, 00h, 04h,0C9h, 03h, 07h
		db	 01h,0C3h, 03h, 08h, 01h,0FFh
		db	 01h, 0Ch, 04h,0D8h, 01h, 13h
		db	 02h,0C9h, 03h, 1Bh, 00h, 61h
		db	 03h, 11h, 00h, 00h, 6Fh, 03h
		db	 00h, 0Fh, 79h, 03h, 08h, 0Fh
		db	 79h, 03h, 10h, 0Fh, 79h, 03h
		db	 18h, 0Fh, 79h, 03h, 20h, 0Fh
		db	79h
loc_38B0:
		add	sp,[bx+si]
		add	al,0C9h
loc_38B4:
		add	cx,[si]
;*		add	bp,bx
		db	 01h,0DDh		;  Fixup - byte match
		add	bx,[bp+si]
;*		add	bx,bp
		db	 01h,0EBh		;  Fixup - byte match
		add	bx,[bx]
		add	word ptr ds:[1803h][di],di
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
		add	sp,[bx+si]
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
		add	ax,word ptr ds:[0D301h]
		add	ax,[bx+di]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		add	cx,[bx+di]
		add	[bx+3],ch
		pop	es
;*		add	cl,cl
		db	 00h,0C9h		;  Fixup - byte match
		add	dx,word ptr ds:[0C900h]
		add	bx,[bp+di]
		add	[bx+si],al
		outsw				; Out [si] to port dx
		add	cx,[bx+si]
		add	[bx+3],ch
		add	[bx],cl
;*		jns	loc_38ED		;*Jump if not sign
		db	 79h, 03h		;  Fixup - byte match
		or	[bx],cl
;*		jns	loc_38F1		;*Jump if not sign
		db	 79h, 03h		;  Fixup - byte match
		adc	[bx],cl
;*		jns	loc_38F5		;*Jump if not sign
		db	 79h, 03h		;  Fixup - byte match
		sbb	[bx],cl
;*		jns	loc_38F9		;*Jump if not sign
		db	 79h, 03h		;  Fixup - byte match
		and	[bx],cl
		jns	$+5			; Jump if not sign
		push	es
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		add	ax,[bx+di]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		add	dx,[bx+si]
		add	[bx+3],ch
		sbb	[bx+si],al
		outsw				; Out [si] to port dx
		add	sp,[bx+si]
		add	[bx+3],ch
		and	ax,[bx+di]
		rol	word ptr [bp+di],cl	; Rotate
		push	ds
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		add	dx,[bx+si]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		add	dx,[si]
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		add	dx,[bp+si]
		add	dx,bx
		add	cx,[bp+di]
		add	[bx+di],bx
		add	bx,[si]
		add	[bx+di],bx
		add	cx,word ptr ds:[1901h]
		add	bx,[bx+di]
		add	[bx+di],bx
		add	cx,[bp+si]
		add	di,cx
		add	bx,[bx+si]
		add	di,cx
		add	bx,[bx+di]
		add	al,64h			; 'd'
		add	cl,[bp+di]
		add	al,64h			; 'd'
		add	cl,[bx]
		add	ax,30Fh
		adc	[di],ax
		db	 0Fh, 03h, 17h, 08h, 00h, 6Fh
		db	 03h, 10h, 0Fh, 79h, 03h, 18h
		db	 0Fh, 79h, 03h, 20h, 0Fh, 79h
		db	 03h, 20h, 00h, 6Fh, 03h, 23h
		db	 01h,0D3h, 03h, 1Eh, 01h,0D3h
		db	 03h, 00h, 00h, 0Fh, 01h, 00h
		db	 08h, 0Fh, 01h, 00h, 0Fh, 99h
		db	 01h, 02h, 0Fh, 29h, 01h, 08h
		db	 0Fh, 79h, 03h, 02h, 0Fh, 21h
		db	 01h, 08h, 04h
data_3981	db	0C9h
		db	 03h, 0Fh, 01h,0C3h, 03h, 08h
		db	 00h, 0Fh, 01h, 08h, 07h, 0Bh
		db	 01h, 10h, 02h,0C9h, 03h, 10h
		db	 00h, 6Fh, 03h, 18h, 00h, 01h
		db	 04h, 18h, 00h, 6Fh, 03h, 1Ah
		db	 01h,0D8h, 01h, 09h, 09h, 71h
		db	 01h, 14h, 08h, 00h, 06h, 04h
		db	 10h, 00h, 06h, 04h, 18h, 00h
		db	 06h, 04h, 20h, 00h, 06h, 04h
		db	 08h, 0Fh, 99h, 01h, 00h, 0Fh
		db	 99h, 01h, 00h, 01h, 10h, 04h
		db	 00h, 07h, 10h, 04h, 0Ah, 0Fh
		db	 22h, 04h, 12h, 0Fh, 22h, 04h
		db	 1Ah, 0Fh, 22h, 04h, 20h, 0Fh
		db	 22h, 04h, 02h, 00h,0EBh, 03h
		db	 00h, 00h, 06h, 04h, 14h, 01h
		db	 34h, 04h, 17h, 01h, 34h, 04h
		db	 1Ah, 01h, 34h, 04h, 22h, 01h
		db	 4Dh, 01h, 06h, 01h, 64h, 02h
		db	 0Ah, 01h, 64h, 02h, 19h, 20h
		db	 00h, 06h, 04h, 20h, 0Fh, 22h
		db	 04h, 00h, 00h, 06h, 04h, 00h
		db	 0Fh, 22h, 04h, 08h, 0Fh, 22h
		db	 04h, 10h, 0Fh, 22h, 04h, 18h
		db	 0Fh, 22h, 04h, 00h, 01h, 79h
		db	 00h, 11h, 01h, 5Ch, 02h, 0Bh
		db	 01h,0D3h, 03h, 0Fh, 00h, 45h
		db	 00h, 08h, 00h, 06h, 04h, 0Fh
		db	 07h, 6Bh, 03h, 17h, 01h, 5Ch
		db	 02h, 1Ah, 00h, 45h, 00h, 10h
		db	 00h, 06h, 04h, 18h, 00h, 06h
		db	 04h, 1Ch, 01h,0D3h, 03h, 1Ah
		db	 07h, 6Bh, 03h, 11h, 05h, 6Fh
		db	 00h, 12h, 05h, 6Fh, 00h, 11h
		db	 06h, 6Fh, 00h, 12h, 06h, 6Fh
		db	 00h, 15h, 01h,0DDh, 03h, 14h
		db	 01h,0EBh, 03h, 17h, 00h, 0Fh
		db	 22h, 04h, 18h, 0Fh, 22h, 04h
		db	 20h, 0Fh, 22h, 04h, 00h, 00h
		db	 06h, 04h, 20h, 00h, 06h, 04h
		db	 08h, 00h, 8Fh, 01h, 10h, 00h
		db	 8Fh, 01h, 18h, 00h, 8Fh, 01h
		db	 14h, 04h, 19h, 03h, 06h, 01h
		db	0CFh, 02h, 07h, 02h,0CFh, 02h
		db	 0Ch, 06h, 35h, 03h, 12h, 06h
		db	 35h, 03h, 0Bh, 01h, 34h, 04h
		db	 0Fh, 01h,0B8h, 01h, 1Ah, 01h
		db	 34h, 04h, 1Ch, 01h,0EAh, 02h
		db	 1Bh, 02h,0EAh, 02h, 13h, 04h
		db	 19h, 03h, 08h, 0Fh, 22h, 04h
		db	 10h, 0Fh,0B1h, 01h, 16h, 0Fh
		db	0B1h, 01h, 17h, 0Fh, 22h, 04h
		db	 14h, 20h, 00h, 06h, 04h, 20h
		db	 0Fh, 22h, 04h, 00h, 00h, 06h
		db	 04h, 00h, 0Fh, 22h, 04h, 08h
		db	 0Fh, 22h, 04h, 10h, 0Fh, 22h
		db	 04h, 18h, 0Fh, 22h, 04h, 08h
		db	 00h, 06h, 04h, 10h, 00h, 06h
		db	 04h, 18h, 00h, 06h, 04h, 11h
		db	 01h, 3Fh, 04h, 16h, 01h, 64h
		db	 02h, 0Dh, 01h, 64h, 02h, 17h
		db	 04h, 34h, 04h, 0Dh, 04h, 34h
		db	 04h, 09h, 01h, 34h, 04h, 1Bh
		db	 01h, 34h, 04h, 07h, 01h, 61h
		db	 03h, 1Eh, 01h, 61h, 03h, 0Fh
		db	 0Fh, 9Eh, 02h, 19h, 20h, 00h
		db	 06h, 04h, 20h, 0Fh, 22h, 04h
		db	 00h, 00h, 06h, 04h, 00h, 0Fh
		db	 22h, 04h, 08h, 0Fh, 22h, 04h
		db	 10h, 0Fh, 22h, 04h, 18h, 0Fh
		db	 22h, 04h, 08h, 00h, 06h, 04h
		db	 10h, 00h, 06h, 04h, 18h, 00h
		db	 06h, 04h, 13h, 01h, 10h, 04h
		db	 0Eh, 01h,0CFh, 02h, 15h, 01h
		db	0EAh, 02h, 11h, 08h,0F9h, 03h
		db	 16h, 05h, 4Eh, 02h, 0Eh, 05h
		db	 4Eh, 02h, 11h, 09h, 6Bh, 03h
		db	 13h, 09h, 6Bh, 03h, 15h, 09h
		db	 6Bh, 03h, 0Ch, 01h, 61h, 03h
		db	 1Ah, 01h, 61h, 03h, 09h, 01h
		db	 34h, 04h, 09h, 04h, 34h, 04h
		db	 1Ch, 01h, 34h, 04h, 1Ch, 04h
		db	 34h, 04h, 13h, 20h, 00h, 06h
		db	 04h, 20h, 0Fh, 22h, 04h, 00h
		db	 00h, 06h, 04h, 00h, 0Fh, 22h
		db	 04h, 08h, 0Fh, 22h, 04h, 10h
		db	 0Fh, 22h, 04h, 18h, 0Fh, 22h
		db	 04h, 08h, 00h, 06h, 04h, 10h
		db	 00h, 06h, 04h, 18h, 00h, 06h
		db	 04h, 13h, 01h, 79h, 00h, 1Ah
		db	 01h, 9Bh, 00h, 07h, 01h,0DDh
		db	 00h, 0Ch, 04h, 9Bh, 00h, 0Dh
		db	 01h, 4Dh, 01h, 16h, 05h,0EDh
		db	 01h, 1Eh, 06h, 67h, 01h, 20h
		db	 06h, 67h, 01h, 22h, 01h, 5Ch
		db	 02h, 16h, 00h, 00h, 06h, 04h
		db	 00h, 0Fh, 22h, 04h, 08h, 0Fh
		db	 22h, 04h, 10h, 0Fh, 22h, 04h
		db	 18h, 0Fh, 22h, 04h, 18h, 00h
		db	 06h, 04h, 26h, 00h, 0Fh, 01h
		db	 26h, 08h, 0Fh, 01h, 26h, 0Fh
		db	 99h, 01h, 1Eh, 0Fh, 99h, 01h
		db	 1Eh, 00h, 0Fh, 01h, 1Eh, 07h
		db	 0Bh, 01h, 20h, 0Fh, 29h, 01h
		db	 20h, 0Fh, 21h, 01h, 00h, 04h
		db	 9Bh, 00h, 03h, 01h, 64h, 02h
		db	 07h, 00h, 9Bh, 00h, 08h, 00h
		db	 06h, 04h, 18h, 01h, 4Dh, 01h
		db	 15h, 00h,0ABh, 03h, 10h, 00h
		db	 06h, 04h, 0Fh, 01h,0D8h, 01h
		db	 10h, 00h, 00h, 5Fh, 04h, 10h
		db	 00h, 4Dh, 01h, 16h, 00h, 79h
		db	 00h, 1Eh, 00h, 5Fh, 04h, 08h
		db	 01h, 5Fh, 04h, 0Ch, 02h, 64h
		db	 02h, 26h, 00h, 8Ch, 02h, 26h
		db	 08h, 8Ch, 02h, 00h, 0Fh, 5Fh
		db	 04h, 08h, 0Fh, 71h, 04h, 10h
		db	 0Fh, 5Fh, 04h, 18h, 0Fh, 71h
		db	 04h, 26h, 0Fh, 99h, 01h, 1Eh
		db	 0Fh, 99h, 01h, 08h, 00h, 13h
		db	 00h, 0Eh, 0Fh, 83h, 04h, 13h
		db	 10h, 0Fh, 5Fh, 04h, 18h, 0Fh
		db	 71h, 04h, 20h, 0Fh, 71h, 04h
		db	 08h, 0Fh, 5Fh, 04h, 00h, 0Fh
		db	 71h, 04h, 18h, 0Fh, 83h, 04h
		db	 05h, 0Fh, 83h, 04h, 00h, 00h
		db	 71h, 04h, 13h, 00h, 64h, 02h
		db	 20h, 00h, 71h, 04h, 1Fh, 00h
		db	 01h, 04h, 17h, 00h,0F9h, 03h
		db	 1Dh, 00h, 1Dh, 03h, 0Eh, 01h
		db	0BDh, 03h, 18h, 01h,0C3h, 03h
		db	 10h, 04h, 6Fh, 03h, 0Fh, 04h
		db	0C9h, 03h, 17h, 01h, 5Fh, 04h
		db	 08h, 00h,0FFh, 01h, 14h, 00h
		db	 00h, 79h, 00h, 07h, 02h, 6Fh
		db	 03h, 0Fh, 00h, 01h, 04h, 08h
		db	 00h, 83h, 04h, 0Ch, 00h, 1Dh
		db	 03h, 0Dh, 00h, 1Dh, 03h, 10h
		db	 01h,0E3h, 01h, 14h, 01h,0E3h
		db	 01h, 10h, 00h,0C9h, 03h, 18h
		db	 00h, 37h, 01h, 20h, 00h, 5Fh
		db	 04h, 1Dh, 00h, 71h, 04h, 00h
		db	 0Fh, 5Fh, 04h, 08h, 0Fh, 71h
		db	 04h, 20h, 0Fh, 5Fh, 04h, 10h
		db	 0Fh, 71h, 04h, 18h, 0Fh, 71h
		db	 04h, 10h, 0Fh, 1Dh, 03h, 14h
		db	 0Fh, 83h, 04h, 19h, 04h, 5Ch
		db	 02h, 14h, 08h, 0Fh, 71h, 04h
		db	 22h, 00h, 4Dh, 01h, 1Bh, 02h
		db	0C9h, 03h
data_3D02	db	0Dh
		db	 02h,0C9h, 03h, 1Eh, 00h, 83h
		db	 04h, 14h, 00h, 5Ch, 02h, 1Ah
		db	 00h, 5Ch, 02h, 0Fh, 00h, 83h
		db	 04h, 0Ah, 00h,0DDh, 00h, 0Fh
		db	 05h, 6Fh, 03h, 17h, 03h, 01h
		db	 04h, 13h, 01h,0FFh, 01h, 00h
		db	 00h, 71h, 04h, 08h, 00h, 19h
		db	 03h, 09h, 00h, 19h, 03h, 00h
		db	 0Fh, 71h, 04h, 10h, 0Fh, 5Fh
		db	 04h, 18h, 0Fh, 5Fh, 04h, 20h
		db	 0Fh, 71h, 04h, 05h, 0Fh, 1Dh
		db	 03h, 14h, 08h, 0Fh, 71h, 04h
		db	 20h, 0Fh, 5Fh, 04h, 10h, 0Fh
		db	 71h, 04h, 18h, 0Fh, 71h, 04h
		db	 0Fh, 0Fh, 83h, 04h, 1Dh, 0Fh
		db	 1Dh, 03h, 00h, 00h, 0Fh, 01h
		db	 00h, 07h, 0Fh, 01h, 08h, 00h
		db	 0Fh, 01h, 08h, 07h, 0Bh, 01h
		db	 00h, 0Fh, 99h, 01h, 02h, 0Fh
		db	 29h, 01h, 02h, 0Fh, 21h, 01h
		db	 0Ah, 00h,0DDh, 00h, 0Fh, 00h
		db	 6Fh, 03h, 0Fh, 01h, 9Bh, 00h
		db	 17h, 00h, 5Fh, 04h, 1Fh, 00h
		db	 71h, 04h, 26h, 00h, 1Dh, 03h
		db	 15h, 01h, 61h, 03h, 11h, 08h
		db	 0Fh, 91h, 04h, 10h, 0Fh, 91h
		db	 04h, 18h, 0Fh, 91h, 04h, 20h
		db	 0Fh, 91h, 04h, 08h, 0Fh, 99h
		db	 01h, 00h, 00h,0ABh, 04h, 08h
		db	 00h,0ABh, 04h, 18h, 00h,0ABh
		db	 04h, 20h, 00h,0ABh, 04h, 00h
		db	 02h, 9Fh, 01h, 00h, 08h, 9Fh
		db	 01h, 00h, 0Fh, 99h, 01h, 10h
		db	 00h,0ABh, 04h, 08h, 02h, 34h
		db	 04h, 1Dh, 02h, 34h, 04h, 11h
		db	 02h,0BDh, 04h, 15h, 02h,0BDh
		db	 04h, 0Fh, 08h, 0Fh, 91h, 04h
		db	 18h, 0Fh, 91h, 04h, 20h, 0Fh
		db	 91h, 04h, 00h, 00h,0ABh, 04h
		db	 08h, 00h,0ABh, 04h, 18h, 00h
		db	0ABh, 04h, 20h, 00h,0ABh, 04h
		db	 10h, 00h,0ABh, 04h, 00h, 0Fh
		db	 91h
data_3E00	db	4
		db	 19h, 02h,0BDh, 04h, 0Dh, 02h
		db	0BDh, 04h, 10h, 0Fh,0ABh, 04h
		db	 10h, 02h, 59h, 00h, 15h, 02h
		db	 64h, 00h, 10h, 04h,0ABh, 04h
		db	 11h, 20h, 0Fh, 91h, 04h, 00h
		db	 00h,0ABh, 04h, 08h, 00h,0ABh
		db	 04h, 18h, 00h,0ABh, 04h, 20h
		db	 00h,0ABh, 04h, 10h, 00h,0ABh
		db	 04h, 00h, 0Fh, 91h, 04h, 08h
		db	 0Fh,0ABh, 04h, 18h, 0Fh,0ABh
		db	 04h, 10h, 0Fh, 91h, 04h, 0Dh
		db	 02h, 25h, 00h, 16h, 02h, 25h
		db	 00h, 0Eh, 03h, 1Dh, 00h, 17h
		db	 03h, 1Dh, 00h, 12h, 02h,0E3h
		db	 01h, 08h, 00h, 83h, 04h, 1Ch
		db	 00h, 83h, 04h, 13h, 08h, 0Fh
		db	 91h, 04h, 18h, 0Fh, 91h, 04h
		db	 20h, 0Fh, 91h, 04h, 18h, 00h
		db	0ABh, 04h, 20h, 00h,0ABh, 04h
		db	 00h, 0Fh, 91h, 04h, 10h, 0Fh
		db	0ABh, 04h, 10h, 00h, 06h, 04h
		db	 1Ch, 02h, 34h, 04h, 10h, 05h
		db	 6Fh, 00h, 16h, 08h, 71h, 01h
		db	 11h, 01h, 4Eh, 02h, 0Fh, 06h
		db	 6Fh, 00h, 16h, 01h,0EBh, 03h
		db	 0Eh, 01h,0DDh, 03h, 0Eh, 00h
		db	 06h, 04h, 01h, 00h, 06h, 04h
		db	 01h, 01h, 06h, 04h, 00h, 00h
		db	0ABh, 04h, 12h, 20h, 0Fh, 91h
		db	 04h, 00h, 00h,0ABh, 04h, 20h
		db	 00h,0ABh, 04h, 10h, 00h,0ABh
		db	 04h, 00h, 0Fh, 91h, 04h, 08h
		db	 0Fh,0ABh, 04h, 18h, 0Fh,0ABh
		db	 04h, 10h, 0Fh, 91h, 04h, 08h
		db	 00h,0C5h, 04h, 18h, 00h,0C5h
		db	 04h, 0Dh, 02h, 64h, 00h, 08h
		db	 02h, 59h, 00h, 08h, 04h,0ABh
		db	 04h, 18h, 02h, 59h, 00h, 1Dh
		db	 02h, 64h, 00h, 18h, 04h,0ABh
		db	 04h, 11h, 02h, 61h, 03h, 15h
		db	 02h, 61h, 03h, 16h, 08h, 0Fh
		db	 91h, 04h, 18h, 0Fh, 91h, 04h
		db	 20h, 0Fh, 91h, 04h, 00h, 00h
		db	0ABh, 04h, 20h, 00h,0ABh, 04h
		db	 00h, 0Fh, 91h, 04h, 10h, 0Fh
		db	0ABh, 04h, 10h, 00h,0C5h, 04h
		db	 10h, 02h, 59h, 00h, 15h, 02h
		db	 64h, 00h, 10h, 06h, 59h, 00h
		db	 15h, 06h, 64h, 00h, 10h, 08h
		db	0ABh, 04h, 10h, 04h,0ABh, 04h
		db	 18h, 02h,0EBh, 03h, 0Eh, 02h
		db	0DDh, 03h, 0Ch, 01h,0DDh, 03h
		db	 1Ah, 01h,0EBh, 03h, 1Ch, 00h
		db	0EBh, 03h, 0Ah, 00h,0DDh, 03h
		db	 08h, 00h,0ABh, 04h, 18h, 00h
		db	0ABh, 04h, 1Dh, 00h, 00h,0ABh
		db	 04h, 00h, 0Fh, 91h, 04h, 10h
		db	 0Fh, 91h, 04h, 08h, 00h,0ABh
		db	 04h, 26h, 00h, 0Fh, 01h, 26h
		db	 08h, 0Fh, 01h, 26h, 0Fh, 99h
		db	 01h, 18h, 0Fh, 91h, 04h, 1Eh
		db	 0Fh, 99h, 01h, 08h, 0Fh, 91h
		db	 04h, 20h, 0Fh, 29h, 01h, 20h
		db	 0Fh, 21h, 01h, 0Ch, 00h, 83h
		db	 04h, 0Ch, 02h,0DDh, 03h, 0Eh
		db	 02h,0EBh, 03h, 10h, 06h, 6Fh
		db	 00h, 16h, 06h, 6Fh, 00h, 0Fh
		db	 02h,0DDh, 03h, 1Dh, 02h,0EBh
		db	 03h, 11h, 07h, 6Fh, 00h, 15h
		db	 07h, 6Fh, 00h, 12h, 00h,0DDh
		db	 03h, 1Ah, 00h,0EBh, 03h, 10h
		db	 00h,0ABh, 04h, 18h, 00h,0ABh
		db	 04h, 1Eh, 00h, 0Fh, 01h, 1Eh
		db	 07h, 0Bh, 01h, 14h, 04h,0A3h
		db	 04h, 14h, 05h,0A3h, 04h, 14h
		db	 00h, 0Fh,0D7h, 04h, 09h, 0Fh
		db	0D7h, 04h, 00h, 00h, 01h, 05h
		db	 20h, 00h, 01h, 05h, 18h, 00h
		db	 01h, 05h, 26h, 07h, 8Ch, 02h
		db	 26h, 0Fh, 99h, 01h, 1Eh, 0Fh
		db	 99h, 01h, 12h, 0Fh,0D7h, 04h
		db	 15h, 0Fh,0D7h, 04h, 20h, 03h
		db	 6Fh, 03h, 26h, 02h, 8Ch, 02h
		db	 16h, 03h,0C9h, 03h, 15h, 00h
		db	0BDh, 03h, 10h, 00h, 01h, 05h
		db	 1Dh, 02h, 64h, 02h, 00h, 04h
		db	 6Fh, 03h, 08h, 01h,0C3h, 03h
		db	 08h, 00h, 01h, 05h, 0Bh, 02h
		db	0D8h, 01h, 11h, 00h, 0Fh,0D7h
		db	 04h, 09h, 0Fh,0D7h, 04h, 00h
		db	 00h, 01h, 05h, 18h, 00h, 01h
		db	 05h, 10h, 00h, 01h, 05h, 08h
		db	 00h, 01h, 05h, 1Fh, 0Fh,0D7h
		db	 04h, 16h, 0Fh,0D7h, 04h, 0Fh
		db	 0Fh,0EBh, 04h, 20h, 04h, 6Fh
		db	 03h, 20h, 01h,0BDh, 03h, 20h
		db	 00h, 01h, 05h, 11h, 02h, 19h
		db	 03h, 16h, 02h, 19h, 03h, 0Fh
		db	 03h,0EBh, 04h, 0Bh, 02h, 34h
		db	 04h, 1Ah, 02h, 34h, 04h, 0Dh
		db	 00h, 00h, 01h, 05h, 18h, 00h
		db	 01h, 05h, 10h, 00h, 01h, 05h
		db	 08h, 00h, 01h, 05h, 20h, 00h
		db	 01h, 05h, 00h, 0Fh,0EBh, 04h
		db	 1Eh, 0Fh,0EBh, 04h, 0Ah, 0Fh
		db	0D7h, 04h, 13h, 0Fh, 91h, 04h
		db	 15h, 0Fh,0D7h, 04h, 0Bh, 02h
		db	 13h, 05h, 19h, 02h, 13h, 05h
		db	 13h, 02h, 61h, 03h, 1Bh, 00h
		db	 0Fh,0D7h, 04h, 1Fh, 0Fh,0D7h
		db	 04h, 16h, 0Fh,0D7h, 04h, 20h
		db	 00h, 01h, 05h, 08h, 00h, 01h
		db	 05h, 18h, 00h, 01h, 05h, 10h
		db	 00h, 01h, 05h, 12h, 02h, 13h
		db	 05h, 0Ch, 02h, 19h, 03h, 0Fh
		db	 02h, 19h, 03h, 18h, 02h, 19h
		db	 03h, 1Bh, 02h, 19h, 03h, 17h
		db	 03h, 25h, 05h, 0Bh, 03h, 25h
		db	 05h, 00h, 03h,0C9h, 03h, 07h
		db	 00h,0C3h, 03h, 00h, 00h, 01h
		db	 05h, 09h, 02h,0DDh, 03h, 1Dh
		db	 02h,0EBh, 03h, 0Bh, 06h, 6Fh
		db	 00h, 13h, 06h, 6Fh, 00h, 15h
		db	 06h, 6Fh, 00h, 0Bh, 07h, 6Fh
		db	 00h, 13h, 07h, 6Fh, 00h, 15h
		db	 07h, 6Fh, 00h, 0Eh, 0Fh,0EBh
		db	 04h, 18h, 0Fh, 83h, 04h, 16h
		db	 00h, 00h, 01h, 05h, 20h, 00h
		db	 01h, 05h, 00h, 0Fh,0EBh, 04h
		db	 1Eh, 0Fh,0EBh, 04h, 0Ah, 0Fh
		db	0D7h, 04h, 13h, 0Fh, 91h, 04h
		db	 15h, 0Fh,0D7h, 04h, 00h, 03h
		db	0C9h, 03h, 07h, 03h,0C9h, 03h
		db	 07h, 02h, 64h, 02h, 0Eh, 00h
		db	0C3h, 03h, 08h, 00h, 01h, 05h
		db	 12h, 00h,0DDh, 03h, 14h, 00h
		db	0EBh, 03h, 11h, 01h,0DDh, 03h
		db	 15h, 01h,0EBh, 03h, 19h, 00h
		db	0BDh, 03h, 1Ah, 03h,0C9h, 03h
		db	 20h, 03h, 6Fh, 03h, 1Dh, 02h
		db	 64h, 02h, 18h, 00h, 01h, 05h
		db	 10h, 00h, 71h, 04h, 15h, 00h
		db	 0Fh,0D7h, 04h, 09h, 0Fh,0D7h
		db	 04h, 18h, 00h, 01h, 05h, 08h
		db	 00h, 01h, 05h, 1Fh, 0Fh,0D7h
		db	 04h, 16h, 0Fh,0D7h, 04h, 20h
		db	 03h, 6Fh, 03h, 20h, 00h,0BDh
		db	 03h, 20h, 00h, 01h, 05h, 00h
		db	 03h,0C9h, 03h, 07h, 00h,0C3h
		db	 03h, 00h, 00h, 01h, 05h, 08h
		db	 02h, 34h, 04h, 1Dh, 02h, 34h
		db	 04h, 0Fh, 03h,0EBh, 04h, 0Bh
		db	 04h, 25h, 05h, 17h, 04h, 25h
		db	 05h, 10h, 01h, 19h, 03h, 17h
		db	 01h, 19h, 03h, 10h, 00h, 01h
		db	 05h, 0Fh, 0Fh,0EBh, 04h, 12h
		db	 18h, 00h, 01h, 05h, 10h, 00h
		db	 01h, 05h, 10h, 0Fh,0D7h, 04h
		db	 19h, 0Fh,0D7h, 04h, 1Fh, 0Fh
		db	0D7h, 04h, 11h, 09h, 71h, 01h
		db	 11h, 03h, 71h, 01h, 20h, 03h
		db	 6Fh, 03h, 20h, 00h,0BDh, 03h
		db	 20h, 00h, 01h, 05h, 00h, 00h
		db	 0Fh, 01h, 00h, 08h, 0Fh, 01h
		db	 00h, 0Fh, 99h, 01h, 08h, 00h
		db	 01h, 05h, 02h, 0Fh, 29h, 01h
		db	 0Ah, 0Fh,0D7h, 04h, 08h, 0Fh
		db	 99h, 01h, 02h, 0Fh, 21h, 01h
		db	 12h, 12h, 00h, 33h, 05h, 1Ah
		db	 00h, 33h, 05h, 20h, 00h, 33h
		db	 05h, 12h, 06h, 33h, 05h, 12h
		db	 0Bh, 33h, 05h, 19h, 06h, 33h
		db	 05h, 18h, 0Bh, 33h, 05h, 20h
		db	 0Bh, 33h, 05h, 20h, 06h, 33h
		db	 05h, 00h, 00h, 0Fh, 01h, 00h
		db	 08h, 0Fh, 01h, 00h, 09h, 0Fh
		db	 01h, 08h, 00h, 3Eh, 02h, 08h
		db	 06h, 3Eh, 02h, 08h, 0Ah, 3Eh
		db	 02h, 0Ah, 00h, 33h, 05h, 0Ah
		db	 06h, 33h, 05h, 0Ah, 0Bh, 33h
		db	 05h, 06h, 12h, 0Fh, 65h, 05h
		db	 1Ah, 0Fh, 65h, 05h, 20h, 0Fh
		db	 65h, 05h, 08h, 0Fh, 77h, 05h
		db	 00h, 0Fh, 99h, 01h, 0Ah, 0Fh
		db	 65h, 05h, 0Ah, 00h, 0Fh, 65h
		db	 05h, 08h, 0Fh, 65h, 05h, 18h
		db	 0Bh, 7Dh, 05h, 20h, 09h, 9Dh
		db	 05h, 10h, 0Fh, 65h, 05h, 1Dh
		db	 0Eh,0CFh, 05h, 20h, 0Fh, 65h
		db	 05h, 18h, 0Fh, 65h, 05h, 11h
		db	 0Dh,0E9h, 05h, 0Fh, 0Dh, 99h
		db	 01h, 15h, 08h, 0Fh, 65h, 05h
		db	 20h, 0Fh, 65h, 05h, 18h, 0Fh
		db	 65h, 05h, 00h, 0Fh, 65h, 05h
		db	 11h, 09h, 8Ah, 06h, 1Bh, 0Dh
		db	0D9h, 05h, 22h, 0Bh,0E9h, 05h
		db	 11h, 0Dh,0BBh, 06h, 13h, 0Dh
		db	0BBh, 06h, 22h, 0Dh,0B4h, 06h
		db	 22h, 0Eh,0B4h, 06h, 23h, 0Dh
		db	0B4h, 06h, 23h, 0Eh,0B4h, 06h
		db	 16h, 0Bh,0E4h, 06h, 17h, 0Dh
		db	0E4h, 06h, 12h, 0Eh,0ECh, 06h
		db	 10h, 0Fh, 65h, 05h, 23h, 0Dh
		db	0ECh, 06h, 00h, 09h, 9Dh, 05h
		db	 07h, 0Dh,0D9h, 05h, 0Dh, 0Dh
		db	0CFh, 05h, 1Bh, 10h, 0Fh, 65h
		db	 05h, 20h, 0Fh, 65h, 05h, 18h
		db	 0Fh, 65h, 05h, 0Dh, 0Dh,0CFh
		db	 05h, 07h, 0Eh,0CDh, 06h, 11h
		db	 0Bh, 74h, 06h, 11h, 0Dh,0B4h
		db	 06h, 11h, 0Eh,0B4h, 06h, 15h
		db	 0Dh,0CFh, 05h, 19h, 0Dh,0D9h
		db	 05h, 1Eh, 0Ah, 8Ah, 06h, 20h
		db	 0Eh,0CDh, 06h, 22h, 0Eh,0CDh
		db	 06h, 0Bh, 0Eh,0E4h, 06h, 08h
		db	 0Fh, 65h, 05h, 23h, 0Dh,0E4h
		db	 06h, 12h, 0Dh,0ECh, 06h, 08h
		db	 0Dh,0E8h, 06h, 27h, 0Eh,0F0h
		db	 06h, 00h, 0Ch,0FEh, 06h, 00h
		db	 0Bh, 7Dh, 05h, 00h, 0Eh,0E8h
		db	 06h, 00h, 0Fh, 65h, 05h, 06h
		db	 0Dh,0FEh, 06h, 08h, 0Bh, 7Eh
		db	 06h, 08h, 0Dh,0B4h, 06h, 08h
		db	 0Dh,0E4h, 06h, 18h, 10h, 0Fh
		db	 65h, 05h, 20h, 0Fh, 65h, 05h
		db	 00h, 0Ah, 1Dh, 06h, 07h, 0Dh
		db	0D9h, 05h, 0Ch, 0Ch,0E9h, 05h
		db	 12h, 0Eh,0D5h, 06h, 15h, 0Ch
		db	 66h, 06h, 1Bh, 0Eh,0DCh, 06h
		db	 18h, 0Fh, 65h, 05h, 1Ch, 0Dh
		db	0E9h, 05h, 22h, 0Dh,0E9h, 05h
		db	 0Ch, 0Eh,0CDh, 06h, 15h, 0Eh
		db	0CDh, 06h, 00h, 0Dh,0CDh, 06h
		db	 01h, 0Dh,0CDh, 06h, 00h, 0Eh
		db	0CDh, 06h, 01h, 0Eh,0CDh, 06h
		db	 03h, 0Dh,0E4h, 06h, 04h, 0Eh
		db	0E8h, 06h, 00h, 0Fh, 65h, 05h
		db	 1Ah, 0Eh,0F0h, 06h, 0Eh, 0Eh
		db	0ECh, 06h, 08h, 0Fh, 65h, 05h
		db	 06h, 0Dh,0F0h, 06h, 0Fh, 08h
		db	 0Fh, 65h, 05h, 10h, 0Fh, 65h
		db	 05h, 20h, 0Fh, 65h, 05h, 00h
		db	 0Fh, 65h, 05h, 18h, 0Fh, 65h
		db	 05h, 00h, 0Dh, 7Eh, 06h, 05h
		db	 0Dh,0E9h, 05h, 1Ah, 0Eh,0B2h
		db	 02h, 12h, 0Eh,0B2h, 02h, 14h
		db	 0Dh,0B2h, 02h, 18h, 0Dh,0B2h
		db	 02h, 0Fh, 0Ch,0F3h, 06h, 15h
		db	 0Ah,0F3h, 06h, 19h, 0Ch, 06h
		db	 07h, 25h, 0Dh,0FEh, 06h, 14h
		db	 00h, 0Fh, 65h, 05h, 18h, 0Fh
		db	 65h, 05h, 06h, 0Dh, 74h, 06h
		db	 09h, 0Eh,0CFh, 05h, 0Dh, 0Ah
		db	0F7h, 05h, 15h, 0Dh,0CFh, 05h
		db	 19h, 0Dh,0DCh, 06h, 0Dh, 0Eh
		db	0CDh, 06h, 0Fh, 0Eh,0CDh, 06h
		db	 11h, 0Eh,0E4h, 06h, 08h, 0Fh
		db	 65h, 05h, 10h, 0Fh, 65h, 05h
		db	 12h, 0Bh,0E8h, 06h, 1Ch, 0Dh
		db	 66h, 06h, 22h, 0Eh,0B4h, 06h
		db	 25h, 0Dh,0DCh, 06h, 22h, 0Ch
		db	 74h, 06h, 22h, 0Eh,0E8h, 06h
		db	 20h, 0Fh, 65h, 05h, 00h, 0Dh
		db	0DCh, 06h, 0Ch, 18h, 0Fh, 65h
		db	 05h, 10h, 0Fh, 65h, 05h, 00h
		db	 0Ch, 1Dh, 06h, 08h, 0Bh, 7Dh
		db	 05h, 0Eh, 0Dh,0E9h, 05h, 14h
		db	 0Dh, 7Eh, 06h, 24h, 0Dh, 74h
		db	 06h, 24h, 0Eh,0E8h, 06h, 00h
		db	 0Fh, 65h, 05h, 08h, 0Fh
		db	65h

;==== External Entry into Subroutine ======================================

sub_4455:
		add	ax,0F20h
		db	 65h, 05h, 19h, 0Bh, 8Ah, 06h
		db	 11h, 18h, 0Fh, 65h, 05h, 10h
		db	 0Fh, 65h, 05h, 08h, 0Fh, 65h
		db	 05h, 00h, 0Fh, 65h, 05h, 00h
		db	 0Dh,0FEh, 06h, 03h, 0Dh,0D9h
		db	 05h, 0Ah, 0Dh,0CFh, 05h, 0Eh
		db	 09h,0F7h, 05h, 17h, 0Dh,0D9h
		db	 05h, 1Eh, 0Dh,0DCh, 06h, 20h
		db	 0Fh, 65h, 05h, 0Eh, 0Dh,0BBh
		db	 06h, 0Fh, 0Dh,0BBh, 06h, 0Eh
		db	 0Dh,0E4h, 06h, 13h, 0Dh,0E8h
		db	 06h, 16h, 0Dh,0F0h, 06h, 25h
		db	 0Dh,0FEh, 06h, 16h, 04h, 0Ch
		db	0FEh, 06h, 07h, 0Ch,0D9h, 05h
		db	 0Eh, 0Ch,0DCh, 06h, 11h, 0Ah
		db	0F7h, 05h, 14h, 09h, 74h, 06h
		db	 1Ah, 0Ch,0E9h, 05h, 20h, 0Eh
		db	0DCh, 06h, 04h, 0Eh,0BBh, 06h
		db	 0Ch, 0Eh,0BBh, 06h, 14h, 0Eh
		db	0BBh, 06h, 18h, 0Eh,0BBh, 06h
		db	 20h, 0Fh, 65h, 05h, 21h, 0Dh
		db	0E9h, 05h, 10h, 0Fh, 65h, 05h
		db	 18h, 0Fh, 65h, 05h, 19h, 0Eh
		db	0F0h, 06h, 0Bh, 0Eh,0ECh, 06h
		db	 09h, 0Eh,0E4h, 06h, 08h, 0Fh
		db	 65h, 05h, 00h, 0Dh,0DCh, 06h
		db	 01h, 0Eh,0FEh, 06h, 00h, 0Fh
		db	 65h, 05h, 0Eh, 20h, 0Fh, 65h
		db	 05h, 00h, 0Fh, 65h, 05h, 10h
		db	 0Fh, 65h, 05h, 18h, 0Fh, 65h
		db	 05h, 08h, 0Fh, 65h, 05h, 00h
		db	 0Dh,0FEh, 06h, 03h, 0Dh,0D9h
		db	 05h, 0Ah, 0Dh,0CFh, 05h, 0Eh
		db	 0Dh,0D9h, 05h, 15h, 0Dh,0DCh
		db	 06h, 1Bh, 0Dh,0CFh, 05h, 18h
		db	 0Dh,0FEh, 06h, 1Eh, 0Dh,0D9h
		db	 05h, 25h, 0Dh,0DCh, 06h, 13h
		db	 20h, 0Fh, 65h, 05h, 00h, 0Fh
		db	 65h, 05h, 10h, 0Fh, 65h, 05h
		db	 18h, 0Fh, 65h, 05h, 08h, 0Fh
		db	 65h, 05h, 00h, 0Dh,0E9h, 05h
		db	 23h, 0Dh, 7Eh, 06h, 0Eh, 0Eh
		db	 06h, 04h, 16h, 0Eh, 06h, 04h
		db	 1Bh, 0Eh, 06h, 04h, 11h, 0Dh
		db	 06h, 04h, 14h, 0Ch, 06h, 04h
		db	 19h, 0Dh, 06h, 04h, 1Ah, 0Dh
		db	 06h, 04h, 19h, 0Ch, 06h, 04h
		db	 0Eh, 0Bh,0F3h, 06h, 15h, 09h
		db	0F3h, 06h, 1Bh, 0Bh, 06h, 07h
		db	 1Dh, 09h,0F3h, 06h, 12h, 20h
		db	 0Fh, 65h, 05h, 00h, 0Fh, 65h
		db	 05h, 10h, 0Fh, 65h, 05h, 18h
		db	 0Fh, 65h, 05h, 08h, 0Fh, 65h
		db	 05h, 00h, 0Dh,0FEh, 06h, 25h
		db	 0Dh,0DCh, 06h, 03h, 0Dh,0D9h
		db	 05h, 0Ah, 09h, 34h, 06h, 21h
		db	 0Dh,0CFh, 05h, 16h, 09h, 7Dh
		db	 05h, 1Ch, 0Dh,0D9h, 05h, 0Ah
		db	 0Dh,0BBh, 06h, 12h, 0Dh,0BBh
		db	 06h, 17h, 0Eh,0B4h, 06h, 15h
		db	 0Dh,0F0h, 06h, 0Dh, 0Dh,0E4h
		db	 06h, 10h, 0Ch,0ECh, 06h, 0Fh
		db	 20h, 0Fh, 65h, 05h, 00h, 0Fh
		db	 65h, 05h, 10h, 0Fh, 65h, 05h
		db	 18h, 0Fh, 65h, 05h, 08h, 0Fh
		db	 65h, 05h, 00h, 0Dh, 66h, 06h
		db	 06h, 0Dh,0FEh, 06h, 09h, 0Bh
		db	 74h, 06h, 09h, 0Dh,0B4h, 06h
		db	 09h, 0Eh,0B4h, 06h, 0Dh, 0Dh
		db	0DCh, 06h, 0Ah, 0Dh,0E8h, 06h
		db	 10h, 0Dh,0E9h, 05h, 16h, 0Ch
		db	 1Dh, 06h, 1Eh, 0Bh,0F7h, 05h
		db	 0Ch, 20h, 0Fh, 65h, 05h, 10h
		db	 0Fh, 65h, 05h, 18h, 0Fh, 65h
		db	 05h, 08h, 0Fh, 65h, 05h, 00h
		db	 0Bh, 7Dh, 05h, 00h, 0Fh, 65h
		db	 05h, 04h, 0Dh,0CFh, 05h, 08h
		db	 0Dh,0DCh, 06h, 0Bh, 0Bh, 8Ah
		db	 06h, 15h, 0Dh, 74h, 06h, 1Ah
		db	 09h, 9Dh, 05h, 21h, 0Dh,0D9h
		db	 05h, 14h, 20h, 0Fh, 65h, 05h
		db	 10h, 0Fh, 65h, 05h, 18h, 0Fh
		db	 65h, 05h, 08h, 0Fh, 65h, 05h
		db	 00h, 0Fh, 65h, 05h, 00h, 0Dh
		db	0D9h, 05h, 07h, 0Dh,0CFh, 05h
		db	 0Bh, 09h, 8Ah, 06h, 15h, 09h
		db	0F7h, 05h, 1Eh, 0Dh,0DCh, 06h
		db	 21h, 0Dh,0FEh, 06h, 24h, 0Dh
		db	0CFh, 05h, 0Bh, 0Dh,0BBh, 06h
		db	 13h, 0Dh,0BBh, 06h, 16h, 0Dh
		db	0BBh, 06h, 1Dh, 0Dh,0F0h, 06h
		db	 14h, 0Dh,0F0h, 06h, 10h, 0Dh
		db	0E8h, 06h, 17h, 0Dh,0ECh, 06h
		db	 1Ah, 0Ch,0E8h, 06h, 14h, 20h
		db	 0Fh, 65h, 05h, 10h, 0Fh, 65h
		db	 05h, 18h, 0Fh, 65h, 05h, 08h
		db	 0Fh, 65h, 05h, 00h, 0Fh, 65h
		db	 05h, 00h, 0Dh,0CFh, 05h, 04h
		db	 0Dh,0D9h, 05h, 0Bh, 0Bh,0FEh
		db	 06h, 0Eh, 09h, 74h, 06h, 0Eh
		db	 0Bh,0B4h, 06h, 0Eh, 0Ch,0B4h
		db	 06h, 12h, 0Bh,0DCh, 06h, 0Bh
		db	 0Dh,0BBh, 06h, 0Dh, 0Dh,0BBh
		db	 06h, 10h, 0Bh,0E8h, 06h, 0Fh
		db	 0Dh,0ECh, 06h, 15h, 0Dh,0DCh
		db	 06h, 18h, 0Dh,0E9h, 05h, 1Eh
		db	 0Dh,0E9h, 05h, 25h, 0Dh,0FEh
		db	 06h, 0Fh, 20h, 0Fh, 65h, 05h
		db	 10h, 0Fh, 65h, 05h, 18h, 0Fh
		db	 65h, 05h, 08h, 0Fh, 65h, 05h
		db	 00h, 0Fh, 65h, 05h, 00h, 0Dh
		db	0DCh, 06h, 03h, 0Dh, 7Eh, 06h
		db	 08h, 0Bh, 34h, 06h, 14h, 0Dh
		db	0FEh, 06h, 17h, 0Dh,0CFh, 05h
		db	 1Bh, 0Bh,0E9h, 05h, 21h, 0Dh
		db	0D9h, 05h, 1Bh, 0Dh,0CDh, 06h
		db	 1Bh, 0Eh,0CDh, 06h, 1Dh, 0Dh
		db	0E8h, 06h, 10h, 20h, 0Fh, 65h
		db	 05h, 10h, 0Fh, 65h, 05h, 18h
		db	 0Fh, 65h, 05h, 08h, 0Fh, 65h
		db	 05h, 00h, 0Fh, 65h, 05h, 00h
		db	 0Dh,0CFh, 05h, 04h, 0Dh,0DCh
		db	 06h, 07h, 0Dh,0FEh, 06h, 0Ah
		db	 0Bh, 74h, 06h, 0Ah, 0Dh,0B4h
		db	 06h, 0Ah, 0Eh,0B4h, 06h, 0Eh
		db	 0Dh,0DCh, 06h, 11h, 0Dh, 7Eh
		db	 06h, 16h, 0Dh,0E9h, 05h, 1Ch
		db	 0Dh, 66h, 06h, 22h, 0Dh,0E9h
		db	 05h, 0Eh, 20h, 0Fh, 65h, 05h
		db	 00h, 0Fh, 65h, 05h, 10h, 0Fh
		db	 65h, 05h, 18h, 0Fh, 65h, 05h
		db	 08h, 0Fh, 65h, 05h, 00h, 0Dh
		db	0FEh, 06h, 03h, 0Dh,0D9h, 05h
		db	 0Ah, 0Dh,0CFh, 05h, 0Eh, 0Dh
		db	0D9h, 05h, 15h, 0Dh,0DCh, 06h
		db	 1Bh, 0Dh,0CFh, 05h, 18h, 0Dh
		db	0FEh, 06h, 1Eh, 0Dh,0D9h, 05h
		db	 25h, 0Dh,0DCh, 06h, 0Bh, 00h
		db	 0Fh, 65h, 05h, 08h, 0Fh, 65h
		db	 05h, 00h, 0Dh,0E9h, 05h, 06h
		db	 0Dh, 74h, 06h, 0Ch, 0Ch,0F3h
		db	 06h, 11h, 0Eh, 74h, 06h, 10h
		db	 0Fh, 65h, 05h, 16h, 0Ch,0F3h
		db	 06h, 1Ah, 0Eh, 66h, 06h, 20h
		db	 0Fh, 65h, 05h, 18h, 0Fh, 65h
		db	 05h, 13h, 00h, 0Fh, 65h, 05h
		db	 10h, 0Fh, 65h, 05h, 20h, 0Fh
		db	 65h, 05h, 18h, 0Fh, 65h, 05h
		db	 1Dh, 00h, 0Ah, 07h, 19h, 02h
		db	 18h, 07h, 1Ah, 06h, 01h, 05h
		db	 1Eh, 06h, 01h, 05h, 1Ah, 08h
		db	 01h, 05h, 1Eh, 08h, 01h, 05h
		db	 1Ah, 0Bh, 55h, 07h, 23h, 0Bh
		db	 55h, 07h, 1Ah, 0Ah, 64h, 02h
		db	 22h, 0Ah, 64h, 02h, 1Eh, 0Ah
		db	0D3h, 03h, 18h, 07h, 61h, 03h
		db	 26h, 07h, 61h, 03h, 0Bh, 0Eh
		db	 7Eh, 06h, 08h, 0Fh, 65h, 05h

;==== External Entry into Subroutine ======================================

sub_480C:
		push	bx
		pop	dx
		inc	dx
		mov	byte ptr [bx],0
		dec	cx
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		retn
sub_31D7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_481F	proc	near
		push	bx
		push	bx
		mov	bx,offset data_BAF6
		mov	dx,0BAF7h
		mov	byte ptr [bx],0
		push	cx
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
		dec	cl
		mov	ch,0
		xchg	si,bx
		xchg	di,dx
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xchg	si,bx
		xchg	di,dx
		pop	cx
		mov	[bx],cl
		dec	bx
		mov	[bx],ch
		pop	dx
		mov	bx,d_BA00_BAF6_e
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		push	ax
		call	sub_4854
		pop	ax
;*		mov	ch,ah
		db	 88h,0E5h		;  Fixup - byte match
		pop	bx
		call	sub_4894
		retn
sub_481F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_4854	proc	near
;*		mov	cl,ch
		db	 88h,0E9h		;  Fixup - byte match
		push	cx
		dec	cx
		mov	ch,0
		xchg	dx,bx
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		xchg	dx,bx
;*		add	bx,cx
		db	 01h,0CBh		;  Fixup - byte match
		pop	cx
loc_4863:
		xchg	dx,bx
		mov	al,[bx]
		xchg	dx,bx
		add	al,[bx]
		daa				; Decimal adjust
		xchg	dx,bx
		mov	[bx],al
		xchg	dx,bx
		jc	loc_487B		; Jump if carry Set
		dec	dx
loc_4875:
		dec	bx
		dec	ch
		jnz	loc_4863		; Jump if not zero
		retn
loc_487B:
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		cmp	ah,1
		jne	loc_4883		; Jump if not equal
		retn
loc_4883:
		dec	dx
		xchg	dx,bx
		mov	al,[bx]
		xchg	dx,bx
		inc	al
		xchg	dx,bx
		mov	[bx],al
		xchg	dx,bx
		jmp	short loc_4875
sub_4854	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_4894	proc	near
loc_4894:
		push	cx
		call	sub_489E
		pop	cx
		dec	ch
		jnz	loc_4894		; Jump if not zero
		retn
sub_4894	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_489E	proc	near
		mov	ah,[bx]
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
		rcr	ah,1			; Rotate thru carry
		and	ah,0Fh
		call	sub_48B8
		mov	ah,[bx]
		and	ah,0Fh
		call	sub_48B8
		inc	bx
		retn
sub_489E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_48B8	proc	near
		push	bx
		add	ah,30h			; '0'
		call	sub_1176
		pop	bx
		retn
sub_48B8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_48C1	proc	near
		push	bx
		push	dx
		push	cx
loc_48C4:
		xchg	dx,bx
		mov	ah,[bx]
		xchg	dx,bx
		cmp	ah,[bx]
		jb	loc_48D6		; Jump if below
		jnz	loc_48E9		; Jump if not zero
		inc	bx
		inc	dx
		dec	ch
		jnz	loc_48C4		; Jump if not zero
loc_48D6:
		pop	cx
		pop	dx
		pop	bx
loc_48D9:
		mov	ah,[bx]
		xchg	dx,bx
		mov	[bx],ah
		xchg	dx,bx
		inc	dx
		inc	bx
		dec	ch
		jnz	loc_48D9		; Jump if not zero
		stc				; Set carry flag
		retn
loc_48E9:
		pop	cx
		pop	dx
		pop	bx
		retn
sub_48C1	endp

		db	 31h, 00h, 50h

data_48F0	db	18h		; key O (left)
data_48F1	db	19h		; key P (right)
data_48F2	db	10h		; key Q (up)
data_48F3	db	1Eh		; key A (down)
data_48F4	db	39h		; key Space (shooting)

; !!! Picopad modification: exit -> Esc
data_48F5	db	01h ;46h		; key SCrollLock or Break (exit)

data_48F6	db	1Ch		; key Enter
data_48F7	db	12h		; key E (cheat)
data_48F8	db	13h		; key R (cheat)
data_48F9	db	1Fh		; key S (start)
data_48FA	db	20h		; key D (demo)
data_48FB	db	38h		; key Left Alt (reset)
data_48FC	db	1Dh		; key Left Ctrl (reset)
data_48FD	db	53h		; key [. Del] (reset)
		db	0
data_48FF	db	1
data_4900	dw	1
		db	15 dup (0)
		db	0F0h, 0Dh,0CFh,0F1h,0CFh,0F1h
		db	0FFh,0FDh,0CFh,0F1h,0CFh,0F1h
		db	0F0h, 0Dh, 55h, 55h,0FCh,0FDh
		db	0FCh,0FDh,0FCh,0FDh,0FFh,0FDh
		db	0FCh,0FDh,0FCh,0FDh,0FCh,0FDh
		db	 55h, 55h,0F0h, 0Dh,0FFh,0F1h
		db	0FFh,0F1h,0F0h, 0Dh,0CFh,0FDh
		db	0CFh,0FDh,0F0h, 0Dh, 55h, 55h
		db	0F0h, 0Dh,0FFh,0F1h,0FFh,0F1h
		db	0F0h, 0Dh,0FFh,0F1h,0FFh,0F1h
		db	0F0h, 0Dh, 55h, 55h,0CFh,0F1h
		db	0CFh,0F1h,0CFh,0F1h,0F0h, 0Dh
		db	0FFh,0F1h,0FFh,0F1h,0FFh,0F1h
		db	 55h, 55h,0F0h, 0Dh,0CFh,0FDh
		db	0CFh,0FDh,0F0h, 0Dh,0FFh,0F1h
		db	0FFh,0F1h,0F0h, 0Dh, 55h, 55h
		db	0F0h, 0Dh,0CFh,0FDh,0CFh,0FDh
		db	0F0h, 0Dh,0CFh,0F1h,0CFh,0F1h
		db	0F0h, 0Dh, 55h, 55h,0F0h, 0Dh
		db	0CFh,0F1h,0FFh,0F1h,0FFh,0FDh
		db	0FFh,0F1h,0FFh,0F1h,0FFh,0F1h
		db	 55h, 55h,0F0h, 0Dh,0CFh,0F1h
		db	0CFh,0F1h,0F0h, 0Dh,0CFh,0F1h
		db	0CFh,0F1h,0F0h, 0Dh, 55h, 55h
		db	0F0h, 0Dh,0CFh,0F1h,0CFh,0F1h
		db	0F0h, 0Dh,0FFh,0F1h,0FFh,0F1h
		db	0F0h, 0Dh, 55h, 55h, 00h, 00h
		db	 00h, 00h, 00h,0C0h, 00h,0C0h
		db	 00h, 00h, 00h, 00h, 00h,0C0h
		db	 00h,0C0h, 00h, 00h, 05h, 50h
		db	 10h, 0Ch, 10h, 0Ch, 1Fh,0FCh
		db	 10h, 0Ch, 10h, 0Ch, 10h, 0Ch
		db	 00h, 00h, 15h, 50h, 04h, 0Ch
		db	 04h, 0Ch, 07h,0F0h, 04h, 0Ch
		db	 04h, 0Ch, 1Fh,0F0h, 00h, 00h
		db	 05h, 50h, 10h, 0Ch, 10h, 00h
		db	 10h, 00h, 10h, 00h, 10h, 0Ch
		db	 0Fh,0F0h, 00h, 00h, 15h, 50h
		db	 04h, 0Ch, 04h, 0Ch, 04h, 0Ch
		db	 04h, 0Ch, 04h, 0Ch, 1Fh,0F0h
		db	 00h, 00h, 15h, 54h, 04h, 0Ch
		db	 04h, 00h, 07h,0F0h, 04h, 00h
		db	 04h, 0Ch, 1Fh,0FCh, 00h, 00h
		db	 15h, 54h, 04h, 0Ch, 04h, 00h
		db	 07h,0F0h, 04h, 00h, 04h, 00h
		db	 1Fh, 00h, 00h, 00h, 05h, 50h
		db	 10h, 0Ch, 10h, 00h, 13h,0FCh
		db	 13h, 0Ch, 10h, 0Ch, 0Fh,0F0h
		db	 00h, 00h, 10h, 0Ch, 10h, 0Ch
		db	 10h, 0Ch, 1Fh,0FCh, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 00h, 00h
		db	 01h, 50h, 00h,0C0h, 00h,0C0h
		db	 00h,0C0h, 00h,0C0h, 00h,0C0h
		db	 03h,0F0h, 00h, 00h, 01h, 54h
		db	 01h, 0Ch, 00h, 0Ch, 00h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 0Fh,0F0h
		db	 00h, 00h, 14h, 0Ch, 04h, 0Ch
		db	 04h, 30h, 07h,0C0h, 04h, 30h
		db	 04h, 0Ch, 14h, 0Ch, 00h, 00h
		db	 15h, 00h, 04h, 00h, 04h, 00h
		db	 04h, 00h, 04h, 00h, 04h, 0Ch
		db	 1Fh,0FCh, 00h, 00h, 15h, 17h
		db	 10h,0C3h, 10h,0C3h, 10h,0C3h
		db	 10h,0C3h, 10h,0C3h, 10h,0C3h
		db	 00h, 00h, 05h, 50h, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 00h, 00h
		db	 05h, 50h, 10h, 0Ch, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 10h, 0Ch
		db	 0Fh,0F0h, 00h, 00h, 15h, 50h
		db	 04h, 0Ch, 04h, 0Ch, 07h,0F0h
		db	 04h, 00h, 04h, 00h, 1Fh, 00h
		db	 00h, 00h, 05h, 50h, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 13h, 0Ch
		db	 0Fh,0F0h, 00h,0FCh, 00h, 00h
		db	 15h, 50h, 04h, 0Ch, 04h, 0Ch
		db	 07h,0F0h, 04h, 0Ch, 04h, 0Ch
		db	 1Fh, 0Ch, 00h, 00h, 05h, 50h
		db	 10h, 0Ch, 10h, 00h, 0Fh,0F0h
		db	 00h, 0Ch, 10h, 0Ch, 0Fh,0F0h
		db	 00h, 00h, 05h, 54h, 04h,0CCh
		db	 00h,0C0h, 00h,0C0h, 00h,0C0h
		db	 00h,0C0h, 03h,0F0h, 00h, 00h
		db	 10h, 0Ch, 10h, 0Ch, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 10h, 0Ch
		db	 0Fh,0F0h, 00h, 00h, 10h, 0Ch
		db	 10h, 0Ch, 10h, 0Ch, 10h, 0Ch
		db	 10h, 0Ch, 04h, 30h, 03h,0C0h
		db	 00h, 00h, 10h, 03h, 10h,0C3h
		db	 10h,0C3h, 10h,0C3h, 10h,0C3h
		db	 13h, 33h, 1Ch, 0Fh, 00h, 00h
		db	 10h, 03h, 0Ch, 0Ch, 03h, 30h
		db	 00h,0C0h, 03h, 30h, 0Ch, 0Ch
		db	 10h, 03h, 00h, 00h, 04h, 0Ch
		db	 04h, 0Ch, 04h, 0Ch, 03h, 30h
		db	 00h,0C0h, 00h,0C0h, 03h,0F0h
		db	 00h, 00h, 15h, 54h, 10h, 0Ch
		db	 00h, 30h, 00h,0C0h, 03h, 00h
		db	 0Ch, 0Ch, 1Fh,0FCh, 00h, 03h
		db	 00h, 0Ch, 00h, 3Fh, 00h,0FFh
		db	 03h,0FFh, 0Fh,0FCh, 3Fh,0F1h
		db	0FFh,0C5h,0FFh,0FFh,0FFh,0FFh
		db	 3Fh,0FFh,0C0h, 00h, 15h, 55h
		db	 55h, 15h, 54h, 15h, 55h, 55h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h, 00h, 55h, 55h, 55h, 15h
		db	 54h, 15h, 55h, 55h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FCh, 00h, 03h
		db	 55h, 54h, 55h, 15h, 54h, 15h
		db	 55h, 55h,0C0h, 00h, 30h, 00h
		db	0FCh, 00h,0FFh, 00h,0FFh,0C0h
		db	 3Fh,0F0h, 4Fh,0FCh, 53h,0FFh
		db	 55h, 55h, 40h, 01h
		db	 41h, 41h
		db	8 dup (41h)
		db	 55h, 55h, 54h,0AAh, 54h,0AAh
		db	 54h,0AAh, 44h,0AAh, 04h,0AAh
		db	 54h,0AAh, 54h,0AAh, 54h,0AAh
		db	 52h,0AAh, 4Ah,0A8h, 2Ah,0A0h
		db	0AAh, 80h,0AAh, 00h,0A8h, 00h
		db	 20h, 00h, 80h, 00h, 55h, 55h
		db	 55h, 15h, 54h, 15h, 55h, 54h
		db	 00h, 02h,0AAh,0A8h,0AAh,0AAh
		db	0AAh,0AAh,0FFh, 15h,0FFh, 15h
		db	0FFh, 15h,0FFh, 14h,0FFh, 10h
		db	0FFh, 15h,0FFh, 15h,0FFh, 15h
		db	0AAh, 85h, 2Ah,0A1h, 0Ah,0A8h
		db	 02h,0AAh, 00h,0AAh, 00h, 2Ah
		db	 00h, 08h, 00h, 02h, 55h, 55h
		db	 55h, 15h, 54h, 15h, 15h, 55h
		db	 80h, 00h, 2Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 55h, 55h, 55h, 15h
		db	 54h, 15h, 55h, 55h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FFh, 15h,0FFh, 15h,0FFh, 15h
		db	0FFh, 14h,0FFh, 10h,0FFh, 15h
		db	0FFh, 15h,0FFh, 15h,0FFh, 15h
		db	0FFh, 15h,0FFh, 15h,0FFh, 14h
		db	0FFh, 10h,0FFh, 15h,0FFh, 15h
		db	0FFh, 15h, 54h,0AAh, 54h,0AAh
		db	 54h,0AAh, 44h,0AAh, 04h,0AAh
		db	 54h,0AAh, 54h,0AAh, 54h,0AAh
		db	 54h,0AAh, 54h,0AAh, 54h,0AAh
		db	 44h,0AAh, 04h,0AAh, 54h,0AAh
		db	 54h,0AAh, 54h,0AAh
		db	18 dup (55h)
		db	 40h, 01h, 54h, 15h, 54h, 15h
		db	 54h, 15h, 54h, 15h, 40h, 01h
		db	 55h, 55h, 55h, 55h
		db	8 dup (41h)
		db	 50h, 05h, 54h, 15h, 55h, 55h
		db	 55h, 55h, 40h, 01h, 41h, 55h
		db	 40h, 05h, 41h, 55h, 41h, 55h
		db	 40h, 01h
		db	'UUUUAUAUAUAUAU@'
		db	 01h, 55h, 55h, 55h, 55h, 40h
		db	 01h, 41h, 55h, 40h, 05h
		db	'AUAUAUUUUU'
		db	10 dup (41h)
		db	 40h, 01h, 55h, 55h, 55h, 55h
		db	 40h, 05h, 41h, 41h, 41h, 41h
		db	 40h, 05h
		db	'AAAAUUUU@'
		db	 01h, 45h, 01h, 54h, 05h, 50h
		db	 15h, 40h, 51h, 40h, 01h, 55h
		db	 55h, 55h, 55h, 54h, 15h, 50h
		db	 05h, 41h, 41h, 40h, 01h
		db	'AAAAUUUU@'
		db	 05h, 41h, 41h, 41h, 41h, 40h
		db	 05h
		db	'AUAUUUUU@'
		db	 01h, 54h, 15h, 54h, 15h, 54h
		db	 15h, 54h, 15h, 54h, 15h, 55h
		db	 55h, 55h, 55h, 40h, 01h
		db	'AAAAAAAA@'
		db	 01h, 55h, 55h, 55h, 55h, 40h
		db	 01h, 41h, 55h, 40h, 01h, 40h
		db	 01h, 55h, 41h, 40h, 01h, 55h
		db	 55h, 55h, 55h, 40h, 15h, 41h
		db	 05h, 41h, 41h, 41h, 41h, 41h
		db	 05h, 40h, 15h, 55h, 55h, 55h
		db	 55h, 40h, 01h
		db	'AQAUAUAQ@'
		db	 01h, 55h, 55h,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh, 00h, 00h
		db	 55h, 55h
		db	14 dup (55h)
		db	 00h, 00h,0FFh,0FFh,0AAh,0AAh
		db	0AAh,0AAh,0ACh, 55h,0ACh, 55h
		db	0ACh, 55h,0ACh, 55h,0ACh, 55h
		db	0ACh, 55h,0ACh, 55h,0ACh
		db	'UU:U:'
		db	'U:U:U:U:U:U:UUUUUUUUU', 0
		db	'U?U2U8UUUUUUUU', 0
		db	 55h,0FCh, 55h, 8Ch
		db	'U,UU8U2U?U'
		db	0
		db	'UUUUUUUU,U'
		db	 8Ch, 55h,0FCh, 55h, 00h, 55h
		db	 55h
		db	7 dup (55h)
		db	0FFh,0FDh,0FFh,0FDh,0FFh,0FDh
		db	0FFh,0FDh,0FFh,0FDh,0FFh,0FDh
		db	0FFh,0FDh, 55h, 55h, 54h,0FFh
		db	'U?UOTSPTUUUUUU'
		db	0FFh, 15h,0FCh, 55h,0F1h, 55h
		db	0C5h, 45h, 15h, 05h
		db	 55h, 55h
		db	10 dup (55h)
		db	'TTPRUJU*T'
		db	0AAh, 55h, 55h, 55h, 55h, 55h
		db	 55h, 15h, 45h, 85h, 05h,0A1h
		db	 55h,0A8h, 55h,0AAh, 15h,0AAh
		db	0AAh, 80h, 02h,0AAh,0AAh, 80h
		db	 02h,0AAh,0AAh, 80h, 02h,0AAh
		db	0AAh, 80h, 02h, 55h, 55h, 50h
		db	 05h, 43h,0C1h, 4Fh, 31h, 4Ch
		db	0F1h, 43h,0C1h, 50h, 05h, 55h
		db	 55h, 55h, 55h, 55h, 55h,0AAh
		db	0A9h,0AAh,0A8h,0AAh,0A8h, 00h
		db	 00h
		db	'UUUUUUUU'
		db	0FFh,0FDh,0FFh,0FCh,0FFh,0FCh
		db	 00h, 00h, 55h, 55h, 55h, 55h
		db	0AAh,0AAh,0BFh,0FFh,0BFh,0FFh
		db	0BFh, 1Fh,0BFh, 07h, 2Fh,0DFh
		db	 0Bh,0FFh, 02h,0AAh,0FFh,0FFh
		db	12 dup (55h)
		db	0AAh,0AAh,0FCh, 00h, 57h,0C0h
		db	'UlUlUlUlV'
		db	 80h,0A8h, 00h, 00h, 00h
		db	15 dup (0)
		db	0FFh, 23h, 55h, 99h, 55h, 99h
		db	 55h, 99h, 55h, 99h
loc_4ECC:
		push	bp
;*		and	dl,[di+0]
		db	 22h, 55h, 00h		;  Fixup - byte match
loc_4ED0:
		stosb				; Store al to es:[di]
		ja	loc_4ECC		; Jump if above
;*		ja	loc_4ECE		;*Jump if above
		db	 77h,0F9h		;  Fixup - byte match
		ja	loc_4ED0		; Jump if above
;*		ja	loc_4ED2		;*Jump if above
		db	 77h,0F9h		;  Fixup - byte match
		add	[bx+si],al
		pop	es
		nop
		pop	es
		nop
		pop	es
		nop
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0CCh,0CCh,0CCh,0CCh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Ah,0A0h
		db	0AAh
loc_4EF4:
		sub	[bx+si],al
		mov	byte ptr ds:[0A00h],al
		add	[bp+si],cl
		add	byte ptr ss:[28AAh][bp+si],ah

;		or	ah,ds:data_003F_e[bx+si]
		db	0Ah, 0A0h, 3Fh, 0

;*		add	ax,si
		db	 01h,0F0h		;  Fixup - byte match
		add	[si-34h],bl
		out	0CCh,ax			; port 0CCh, DMA-2 bas&add ch 3
		out	0,al			; port 0, DMA-1 bas&add ch 0
		pop	ax

;		add	ds:data_002A_e[bx+si],sp
		db	1, 0a0h, 2Ah, 0

		shr	byte ptr ss:data_00D0_e[bp+si],cl	; Shift w/zeros fill
;*		aad	55h			; 'U' undocumented inst
		db	0D5h, 55h		;  Fixup - byte match
		rol	byte ptr [bx+si],1	; Rotate
		shr	ss:data_AAD2[bp+si],cl	; Shift w/zeros fill
		sar	data_AAD2[bx],cl	; Shift w/sign fill
		stosb				; Store al to es:[di]
		lea	ax,[bx+si]		; Load effective addr
		or	ax,5555h
		add	[di],cl
		stosb				; Store al to es:[di]
		lea	bp,ss:data_FE8D_e[bp+si]	; Load effective addr
		lea	bp,ss:data_018D[bp+si]	; Load effective addr
		adc	[si],ax
		inc	bp
		add	[bx+di],dx
		add	al,44h			; 'D'
;*		or	ch,ss:data_0000_e[bp+si]
		db	 0Ah,0AAh, 00h, 00h	;  Fixup - byte match
		or	al,[bp+si+3Ch]
		sub	[di+7Dh],dl
		push	bp
		jge	loc_4F9B		; Jump if > or =
;*		jge	loc_4F9D		;*Jump if > or =
		db	 7Dh, 55h		;  Fixup - byte match
		jge	loc_4EF4		; Jump if > or =
		stosb				; Store al to es:[di]
		add	[bx+si],al
		inc	dx
		cmp	al,3Ch			; '<'
		dec	dx
		or	ah,data_8002[bx+si]
		mov	al,data_A808
		test	al,0
		mov	al,byte ptr ds:[228h]
		sub	[bp+si],ch
		and	[bx+si],ch
		cmp	al,3Ch			; '<'
		retn
			                        ;* No entry point to code
		iret				; Interrupt return
			                        ;* No entry point to code
		push	word ptr [bp+di]
		retn
			                        ;* No entry point to code
		or	al,0
		shr	byte ptr [bx+si],2	; Shift w/zeros fill
		sub	[bp+si],ch
		and	[bx+si],cl
		db	0FFh,0FFh, 00h, 00h,0AAh,0AAh
		db	0ABh, 2Ah,0A8h, 2Ah,0AAh,0AAh
		db	 00h, 00h, 55h, 55h,0D1h,0AAh
		db	0D2h, 6Ah,0D1h,0AAh,0D2h, 6Fh
		db	0D1h,0A8h,0D2h, 6Ah,0D1h,0AAh
		db	0D2h, 6Ah,0ABh, 34h,0AEh, 34h
		db	0ABh
		db	 34h, 2Eh, 34h, 2Bh, 34h
loc_4F9B:
		scasb				; Scan es:[di] for al
		xor	al,0ABh
		xor	al,0AEh
		xor	al,0CAh
		test	al,32h			; '2'
		stosb				; Store al to es:[di]
		or	al,0AAh
		add	bp,[bp+si]
;*		add	dl,cl
		db	 00h,0CAh		;  Fixup - byte match
		add	[bp+si],dh
		add	[si],cl
		add	[bp+di],al
		inc	ax
		add	[bx+si],dl
		add	data_A100[si],al
		add	data_AA40[bx+si],ch
		adc	byte ptr ds:[2084h][si],ch
		mov	ax,word ptr ds:[100h]
		add	[si],al
		add	[bp+si],dl
		add	[bp+si+1],cl
		sub	al,[si]
		stosb				; Store al to es:[di]
		adc	cl,dl
		dec	dx
		or	[bp+si],ch
		mov	data_8CAA,ax
		stosb				; Store al to es:[di]
		xor	data_A3C0[bx+si],ch
		add	data_3000[si],cl
;*		add	al,al
		db	 00h,0C0h		;  Fixup - byte match
		db	 00h, 00h, 00h, 00h, 00h, 90h
		db	 90h, 09h, 09h, 00h, 00h, 60h
		db	 60h, 06h, 06h, 00h, 00h, 23h
		db	0C2h, 50h,0A5h, 00h, 00h,0AAh
		db	0AAh, 00h, 00h, 7Dh, 55h, 7Dh
		db	 55h, 7Dh, 55h,0A0h, 50h, 1Ah
		db	 0Ch, 00h, 00h,0AAh,0A0h, 00h
		db	 00h, 51h, 10h, 54h, 40h, 51h
		db	 10h,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0BBh,0BBh,0EEh,0EEh, 00h
		db	 00h,0FFh,0FFh, 55h, 55h,0FFh
		db	0FFh, 55h, 55h, 00h, 00h, 66h
		db	 66h, 99h, 99h,0AAh,0AAh,0AAh
		db	0AAh,0ABh,0CAh,0AAh,0AAh,0F3h
		db	0CFh,0AAh,0AAh, 07h,0FFh, 07h
		db	0FFh, 01h,0FFh, 00h, 5Fh, 00h
		db	 0Ah,0AAh,0AAh,0F3h,0CFh,0AAh
		db	0AAh,0FFh,0D0h,0FFh,0D0h,0FFh
		db	 40h,0F5h, 00h,0A0h, 00h,0AAh
		db	 03h, 82h, 0Fh, 82h,0AFh, 82h
		db	 0Fh,0AAh, 03h, 00h, 0Ah, 00h
		db	0D5h, 03h, 55h,0C0h,0AAh,0F0h
		db	 82h,0FAh, 82h,0F0h, 82h,0C0h
		db	0AAh,0A0h, 00h, 57h, 00h, 55h
		db	0C0h,0A9h, 70h, 09h, 70h,0A9h
		db	 70h, 09h, 70h,0A9h, 70h, 55h
		db	0C0h, 57h, 00h,0AAh,0AAh
loc_5081:
		or	ax,0D6Ah
		pusha				; Save all regs
		or	ax,0D6Ah
		pusha				; Save all regs
		or	ax,36Ah
		push	bp
;*		add	ch,dl
		db	 00h,0D5h		;  Fixup - byte match
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	al,5
		add	al,5
		add	[di],al
		add	[di],al
		add	[bx+si],al
		add	[bx+di],al
		add	[bx+si],al
		add	[bx+di],al
		push	ax
		adc	[bx+si+10h],dl
		push	ax
;*		add	[bx+si+0],dl
		db	 00h, 50h, 00h		;  Fixup - byte match
		db	 00h, 00h, 40h, 00h, 00h, 00h
		db	 40h, 00h, 00h, 00h,0AAh,0AAh
		db	 55h, 55h,0AAh,0AAh,0AAh,0AAh
		db	 88h, 88h, 22h, 22h, 00h, 00h
		db	 02h,0A8h,0A9h, 54h, 56h,0A8h
		db	0AAh,0A8h,0AAh,0A8h, 8Ah,0A8h
		db	 22h, 20h, 00h, 88h
loc_50D1:
		push	bp
		push	bp
		push	0FFAAh
		push	0FFAAh
		push	0FFAAh
		push	0FFA9h
		push	0FFA9h
		push	0FFA9h
		push	0FFA9h
		push	bp
		push	bp
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	bp
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	bp
		push	sp
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_A0AA	; ('        ')
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_A0AA	; ('        ')
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_A0AA	; ('        ')
		stosb				; Store al to es:[di]
		mov	al,data_A96A
		push	0FFA9h
		push	0FFA9h
		push	0FFA9h
		push	0FFAAh
		push	0FFAAh
		bound	sp,dword ptr [bp+si]
		inc	ax
		add	ss:data_AA6A[bp+si],ch
		inc	ax
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bx+si],al
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		and	ah,[bp+si]
		add	[bx+si],al
		stosb				; Store al to es:[di]
		mov	al,data_80AA
		stosb				; Store al to es:[di]
		and	ss:data_AA80[bp+si],ch
		and	byte ptr ds:[2280h][bx+si],cl
		and	[bx+si],al
		add	[di+55h],dl
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	bp
		stosb				; Store al to es:[di]
		test	al,0AAh
		test	al,56h			; 'V'
		test	al,0A2h
		test	al,2
		test	al,0AAh
		test	al,0
		add	byte ptr ss:data_AAA8+2[bp+si],ch
		stosb				; Store al to es:[di]
		and	ah,[bp+si]
		add	[bx+si],al
		or	bl,data_9822[bx+si]
		or	bl,data_9822[bx+si]
		mov	ah,ss:data_A62A[bp]
;*		mov	ah,ss:data_0000_e[bp]
		db	 8Ah,0A6h, 00h, 00h	;  Fixup - byte match
		or	bl,data_A622[bx+si]
		or	ch,data_AA22[bx+di]
		or	byte ptr ss:[2202h][bp+si],ch
;*		add	ds:data_0000_e[bx+si],cl
		db	 00h, 88h, 00h, 00h	;  Fixup - byte match
		mov	al,es:data_889A
		push	0FFA0h
		stosb				; Store al to es:[di]
		mov	ss:data_8820[bp+si],ch
		and	byte ptr [bp+si],0
		add	[bx+si],al
		mov	al,es:data_8826
		mov	al,es:data_8826
;*		call	far ptr s_9AA8_9AA2	;*
		db	9Ah
		dw	9AA2h, 9AA8h		;  Fixup - byte match
		mov	ds:data_0000_e,al
		add	[bx],cl
		add	[bx],cl
		add	cx,di
		add	ax,bp
		add	ax,bp
		db	0F1h, 45h,0F1h
		db	'EQEQEQEQE'
		db	 01h, 45h, 00h, 05h, 01h, 40h
		db	 00h, 05h, 00h, 05h,0F0h, 00h
		db	0F0h, 00h,0F3h,0C0h, 53h,0C0h
		db	 53h,0C0h
		db	'QOQOQEQEQEQEQ@P'
		db	 00h, 01h, 40h, 50h, 00h, 50h
		db	 00h, 00h, 00h, 0Ah,0A0h, 2Ah
		db	 68h, 29h, 58h, 2Ah, 68h, 2Ah
		db	0A8h, 0Ah,0A0h, 00h, 00h, 2Eh
		db	0A0h, 2Eh, 88h, 2Eh,0A0h, 2Eh
		db	 88h, 2Eh,0A0h, 2Eh, 88h, 2Eh
		db	0A0h, 2Eh, 88h, 0Bh, 80h, 0Bh
		db	 20h, 0Bh, 80h, 0Bh, 20h, 0Bh
		db	 80h, 0Bh, 20h, 0Bh, 80h, 0Bh
		db	 20h, 00h, 00h, 00h, 05h, 00h
		db	 55h, 03h, 15h, 0Fh,0C5h, 0Fh
		db	0F1h, 3Ch,0C0h, 3Fh,0CAh, 00h
		db	 00h, 50h, 00h, 55h, 00h, 54h
		db	0C0h, 53h,0F0h, 4Fh,0F0h, 03h
		db	 3Ch,0A3h,0FCh, 3Fh,0C0h, 3Ch
		db	0CAh, 0Fh,0C0h, 0Fh,0C5h, 03h
		db	 15h, 00h, 55h, 00h, 05h, 00h
		db	 00h, 03h,0FCh,0A3h, 3Ch, 03h
		db	0F0h, 53h,0F0h, 54h,0C0h, 55h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	0B4h, 00h,0B4h, 00h,0B4h, 00h
		db	0B4h,0AAh,0F4h,0FFh,0D0h, 55h
		db	 40h, 00h, 00h, 1Eh, 00h, 1Eh
		db	 00h, 1Eh, 00h, 1Eh, 00h, 1Fh
		db	0AAh, 07h,0FFh, 01h, 55h, 00h
		db	 00h,0AAh,0AAh, 00h, 00h, 55h
		db	 55h, 57h, 15h, 54h, 15h,0FFh
		db	0FFh, 00h, 00h,0AAh,0AAh,0D0h
		db	0AAh,0D2h, 2Ah,0D0h,0AAh,0D2h
		db	 2Fh,0D0h,0AFh,0D2h, 28h,0D0h
		db	0AAh,0D2h, 2Ah,0A8h, 34h,0A2h
		db	 34h,0A8h, 34h,0A2h, 34h, 28h
		db	 34h, 22h, 34h,0A8h, 34h,0A2h
		db	 34h, 0Ch, 0Ch, 38h, 38h,0E8h
		db	0E8h,0AAh,0AAh,0F3h,0F3h, 3Fh
		db	 3Fh,0AAh,0AAh, 00h, 00h, 03h
		db	 3Ch, 03h,0C3h, 03h,0FCh, 00h
		db	0FFh, 00h,0CCh, 00h, 30h, 00h
		db	 0Fh, 00h, 00h,0FCh,0F3h,0F0h
		db	 0Fh,0C9h,0A3h, 29h,0A8h, 98h
		db	 26h,0A0h, 0Ah, 28h, 28h,0C6h
		db	 93h,0FCh, 00h,0F3h,0C0h, 0Fh
		db	0C0h,0F3h, 00h, 3Fh, 00h, 0Ch
		db	 00h,0F0h, 00h, 00h, 00h, 00h
		db	 01h, 00h, 05h, 00h, 15h, 00h
		db	 54h, 00h, 43h, 01h, 33h, 00h
		db	0F3h, 03h, 3Ch, 55h, 55h, 45h
		db	 11h, 10h, 05h, 0Fh,0F0h,0F3h
		db	 0Fh,0FCh,0FFh,0F3h,0FFh,0F3h
		db	0FCh, 40h, 00h, 50h, 00h, 54h
		db	 00h, 15h, 00h,0C1h, 00h, 3Ch
		db	 40h, 03h, 00h, 3Fh,0C0h, 40h
		db	 41h, 11h, 11h, 04h, 04h, 05h
		db	 10h, 01h, 50h, 01h, 40h, 04h
		db	 50h, 11h, 54h, 00h, 00h,0A0h
		db	 00h,0AAh, 00h, 6Ah,0A0h, 15h
		db	0A8h, 00h, 5Ah, 15h, 40h, 40h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 00h, 0Ah, 00h,0AAh, 0Ah
		db	0A9h, 2Ah, 54h,0A5h, 00h, 01h
		db	 54h, 00h, 01h, 02h,0AAh, 0Bh
		db	0AAh, 2Ah, 00h,0B8h, 15h,0A0h
		db	 55h,0A1h, 55h,0A1h, 55h,0A1h
		db	 55h,0A5h, 55h,0A5h, 55h,0A5h
		db	 55h,0A5h, 55h,0B9h, 55h, 2Ah
		db	 55h, 0Bh,0AAh, 02h,0AAh
		db	'U(U(U(T(P'
		db	0B8h, 02h,0A0h,0ABh, 80h,0AAh
		db	 00h,0AAh, 00h,0ABh, 80h, 56h
		db	0A0h, 55h,0B8h
		db	'UhUhUhUh*'
		db	0AAh, 8Fh,0FFh,0B3h,0FFh,0BCh
		db	0FFh,0BFh, 00h,0BFh, 22h,0BFh
		db	 08h,0BFh, 22h,0AAh,0AAh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h, 22h, 22h, 88h, 88h, 22h
		db	 22h,0AAh,0A0h,0FFh,0C8h,0FFh
		db	 18h,0FCh, 58h, 01h, 58h, 21h
		db	 58h, 81h, 58h, 21h, 58h,0BFh
		db	 08h,0BFh, 22h,0BFh, 08h,0BFh
		db	 00h,0BCh, 55h,0B1h, 55h, 85h
		db	 55h, 2Ah,0AAh, 88h, 88h, 22h
		db	 22h, 88h, 88h, 00h, 00h, 55h
		db	 55h, 55h, 55h, 55h, 55h,0AAh
		db	0AAh, 81h, 58h, 21h, 58h, 81h
		db	 58h, 01h, 58h, 54h, 58h, 55h
		db	 18h, 55h, 48h,0AAh,0A0h, 2Ah
		db	0AAh, 85h, 55h, 91h, 55h, 94h
		db	 55h, 95h, 00h, 95h, 3Fh, 95h
		db	 3Fh, 95h, 3Fh,0AAh,0AAh, 55h
		db	 55h, 55h, 55h, 55h, 55h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 3Fh,0AAh,0A0h, 55h, 44h, 55h
		db	 14h, 54h, 64h, 01h, 94h,0F2h
		db	 64h,0F1h, 94h,0F2h, 64h, 95h
		db	 3Fh, 95h, 3Fh, 95h, 3Fh, 95h
		db	 00h, 94h, 99h, 92h, 66h, 89h
		db	 99h, 15h, 55h,0F0h, 3Fh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 99h
		db	 99h, 66h, 66h, 99h, 99h, 55h
		db	 55h,0F1h, 94h,0F2h, 64h,0F1h
		db	 94h, 02h, 64h, 98h, 94h, 66h
		db	 24h, 99h, 84h, 55h, 50h,0FFh
		db	0FFh,0D5h, 55h,0D5h, 55h,0D5h
		db	 55h,0D5h, 57h,0D5h, 57h,0D5h
		db	 57h,0D5h, 57h,0FFh,0FFh, 55h
		db	 55h, 55h, 55h, 55h, 55h,0FFh
		db	0FFh, 55h, 55h, 55h, 55h, 55h
		db	0FFh,0FFh,0FFh, 55h, 55h, 55h
		db	 55h, 55h, 55h,0FFh,0FFh, 55h
		db	 54h, 55h, 54h,0FDh, 54h,0FFh
		db	0FCh
		db	'UPUPUPUPUPUPUP'
		db	0D5h, 57h,0D5h, 57h,0D5h, 57h
		db	0D5h, 57h,0D5h, 55h,0D5h, 55h
		db	0D1h, 11h,0C0h, 00h, 55h,0D5h
		db	 55h,0C0h, 55h, 55h, 00h, 00h
		db	 55h, 55h, 55h, 55h, 11h, 11h
		db	 00h, 00h, 51h, 54h, 01h, 54h
		db	 55h, 54h, 00h, 00h, 55h, 55h
		db	 55h, 55h, 11h, 11h, 00h, 00h
		db	 55h, 50h, 55h, 40h, 55h, 10h
		db	 55h, 40h, 55h, 10h, 44h, 40h
		db	 11h, 10h, 00h, 00h, 00h, 05h
		db	 0Ah, 54h, 2Ah,0A5h, 00h,0A9h
		db	 03h, 0Ah, 0Fh,0F2h, 0Fh,0FCh
		db	 00h
		db	'?U/UKURQTUU'
		db	 95h, 55h,0A5h, 55h,0A5h, 15h
		db	0F8h, 55h,0E1h, 55h, 85h, 55h
		db	 15h
		db	'EUUUVUZTZP'
		db	 00h, 15h,0A0h, 5Ah,0A8h, 6Ah
		db	 00h,0A0h,0C0h, 8Fh,0F0h, 3Fh
		db	0F0h,0FCh, 00h,0AAh,0AAh,0FFh
		db	 7Fh,0FDh,0F7h,0F7h,0DFh,0DFh
		db	 7Fh,0FDh,0FFh,0F7h,0FFh,0AAh
		db	0AAh,0A5h, 55h,0E9h, 55h,0E9h
		db	 45h,0E9h, 55h,0E9h, 55h,0E9h
		db	 45h,0E9h, 55h,0A5h
		db	'UUZUkQkUkUkQkUkUZ'
		db	 9Ah,0AAh, 9Ah,0AAh, 03h, 7Fh
		db	 9Ah,0AAh, 9Ah,0AAh, 03h, 7Fh
		db	 9Ah,0AAh, 9Ah,0AAh, 00h, 3Fh
		db	 0Fh,0FCh, 0Fh,0F2h, 03h, 0Ah
		db	 00h,0A9h, 2Ah,0A5h, 0Ah, 05h
		db	 00h, 00h,0A5h, 15h,0A5h, 55h
		db	 95h
		db	'UUUQUUPUJU*TZUZUVUUUE'
		db	 05h, 55h,0A1h, 55h,0A8h, 55h
		db	0FCh, 00h, 3Fh,0F0h, 8Fh,0F0h
		db	0A0h,0C0h, 6Ah, 00h, 5Ah,0A8h
		db	 50h,0A0h, 00h, 00h,0AAh,0A2h
		db	0AAh,0A2h,0FCh,0C0h,0AAh,0A2h
		db	0AAh,0A2h,0FCh,0C0h,0AAh,0A2h
		db	0AAh,0A2h, 3Ch,0F0h,0C3h,0FCh
		db	0FCh, 03h, 00h, 20h, 20h,0A0h
		db	 28h, 00h, 28h,0A8h, 00h,0A0h
		db	 00h, 00h, 00h, 01h, 00h, 05h
		db	 00h, 11h, 00h, 15h, 00h, 45h
		db	 05h, 15h, 51h, 55h, 00h, 01h
		db	 00h, 01h, 00h, 05h, 00h, 15h
		db	 00h, 14h, 00h, 45h, 00h, 51h
		db	 00h, 51h, 00h, 50h, 00h, 55h
		db	 00h, 15h, 00h, 54h, 01h, 11h
		db	 04h, 44h, 11h, 11h, 44h, 54h
		db	 40h, 00h, 50h, 00h, 44h, 00h
		db	 54h, 00h, 51h, 00h, 55h, 40h
		db	 55h, 10h, 55h, 55h, 40h, 00h
		db	 50h, 00h, 50h, 00h, 44h, 00h
		db	 51h, 00h, 51h, 00h, 55h, 00h
		db	 54h, 00h, 51h, 00h, 51h, 00h
		db	 55h, 00h, 45h, 40h, 54h, 50h
		db	 55h, 50h, 55h, 14h, 55h, 51h
		db	 15h
		db	51h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_5603	proc	near
		push	sp
		push	bp
		push	bp
		push	bp
		push	cx
		adc	ax,4555h
		inc	bp
		push	bp
		push	bp
		push	bp
		push	sp
		push	sp
		push	bp
		push	sp
		push	bp
		push	bp
		push	bp
		adc	ax,5551h
		push	bp
		inc	bp
		push	bp
		adc	ax,5555h
		inc	bp
		push	cx
		adc	ax,5515h
		push	bp
		inc	bp
		push	sp
		push	bp
		inc	cx
		push	bp
		adc	ax,1555h
		push	sp
		push	bp
		adc	ax,5055h
;*		add	[bx+si+0],dl
		db	 00h, 50h, 00h		;  Fixup - byte match
		db	 44h, 00h, 55h, 00h, 45h, 00h
		db	 51h, 40h, 51h, 10h, 55h, 55h
		db	 45h, 55h, 50h, 55h, 04h, 15h
		db	 51h, 45h, 05h, 05h, 10h, 51h
		db	 55h, 15h, 50h, 54h, 45h, 55h
		db	 15h, 55h, 11h
		db	 55h, 55h, 55h, 45h
		db	7 dup (55h)
		db	 00h, 00h, 00h, 01h, 00h, 01h
		db	 00h, 04h, 00h, 11h, 01h, 54h
		db	 05h, 11h, 14h, 44h, 55h, 55h
		db	 45h, 55h, 51h, 51h, 10h, 45h
		db	 54h, 50h, 51h, 11h, 05h, 45h
		db	 55h, 55h, 15h, 55h, 54h, 55h
		db	 55h, 41h, 50h, 15h, 55h, 05h
		db	 54h, 55h, 55h, 11h, 55h, 55h
		db	 44h, 44h, 11h, 11h, 54h, 44h
		db	 11h, 11h, 44h, 44h, 11h, 51h
		db	 44h, 44h, 11h, 11h, 55h, 55h
		db	 51h, 55h, 05h, 55h, 54h, 45h
		db	 11h, 05h, 44h, 55h, 15h, 15h
		db	 50h, 54h, 50h, 00h, 45h, 00h
		db	 54h, 51h, 51h, 05h, 15h, 51h
		db	 55h, 55h, 45h, 45h, 55h, 55h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	'PQUUEQPUUU'
		db	 00h, 04h, 05h, 50h, 15h, 45h
		db	 51h, 11h, 44h, 45h, 15h, 50h
		db	 45h, 55h, 55h, 55h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 40h, 00h
		db	 50h, 00h, 55h, 00h, 45h, 50h
		db	 54h, 55h, 50h, 01h, 54h, 05h
		db	 15h, 54h, 50h, 51h, 55h, 15h
		db	 55h, 55h, 51h, 55h, 45h, 55h
		db	9 dup (0)
		db	 05h, 00h, 54h, 05h, 41h, 55h
		db	 11h
		db	'UUUEQUEEQ'
		db	 15h, 14h, 51h, 55h, 55h, 55h
		db	 55h, 00h,0FEh, 0Fh,0BFh, 3Bh
		db	0E0h,0FFh, 80h,0FBh,0F0h, 0Fh
		db	0BBh, 50h, 0Eh, 45h, 50h,0CFh
		db	 0Fh,0BEh,0FBh,0C3h,0E0h, 00h
		db	 00h, 00h, 00h,0BFh, 0Eh,0E0h
		db	0FBh, 05h, 00h,0CFh, 0Fh,0BEh
		db	0FBh,0C3h,0F0h, 00h, 00h, 00h
		db	 00h,0EFh, 0Fh,0F0h,0FBh, 05h
		db	 00h,0EFh, 00h,0BEh,0F0h, 03h
		db	0ECh, 00h,0FBh, 0Fh,0BFh,0BBh
		db	0ECh,0EFh,0C1h, 00h, 15h
		db	8 dup (0)
		db	 40h, 00h, 40h, 00h, 50h, 00h
		db	 54h, 00h, 54h, 00h, 51h, 00h
		db	 55h, 00h, 54h, 50h, 51h, 04h
		db	 54h, 54h, 55h, 45h, 55h, 15h
		db	 00h, 00h
		db	9 dup (0)
		db	 01h, 00h, 05h, 00h, 15h, 00h
		db	 15h, 00h, 11h, 00h, 45h, 00h
		db	 54h, 05h, 11h, 05h, 55h, 15h
		db	'EQUEUUUEUPUT'
		db	 15h, 50h, 45h, 54h, 01h, 50h
		db	 51h, 55h, 05h, 54h, 55h, 11h
		db	 15h, 50h, 55h, 05h, 15h, 44h
		db	 55h, 11h, 05h, 50h, 50h, 55h
		db	 55h, 51h, 45h, 55h, 15h, 55h
		db	 15h, 54h, 15h, 50h, 45h, 50h
		db	 55h, 41h, 15h, 54h, 55h, 55h
		db	 15h, 55h, 51h, 55h, 05h, 54h
		db	 41h, 55h, 05h, 50h, 50h, 45h
		db	 15h, 00h, 88h, 0Ah,0FFh, 2Bh
		db	 00h, 0Ch, 44h, 2Ch, 44h, 2Bh
		db	 00h, 0Ah,0FFh, 00h, 88h, 88h
		db	 88h,0FFh,0FFh, 00h, 00h, 44h
		db	 44h, 44h, 44h, 00h, 00h,0FFh
		db	0FFh, 88h, 88h, 88h, 00h,0FEh
		db	 80h, 03h,0A0h, 44h,0E0h, 44h
		db	0C0h, 03h,0A0h,0FEh, 80h, 88h
		db	 00h, 00h, 00h, 32h,0C8h,0A0h
		db	0B2h, 80h, 32h,0A0h,0B2h, 80h
		db	 32h,0A0h,0B2h, 01h, 04h, 32h
		db	0C8h, 00h,0C8h, 00h,0FAh, 00h
		db	 32h, 00h
		db	32h
		db	32 dup (0)
		db	0C8h, 00h,0FAh, 00h, 32h, 00h
		db	 08h, 08h, 28h, 28h,0AAh,0AAh
		db	 00h, 00h, 10h, 10h, 00h, 00h
		db	0AAh,0AAh, 00h, 00h, 7Dh, 55h
		db	0AAh,0AAh, 11h, 11h
		db	'UUUUUWUW'
		db	0AAh,0AAh, 7Dh, 55h,0AAh,0AAh
		db	 13h, 31h, 17h,0F5h, 05h,0FDh
		db	 01h, 7Fh, 00h, 17h, 00h, 0Ah
		db	0A0h, 00h,0F4h, 00h, 7Dh, 40h
		db	 7Fh, 50h, 5Fh,0D4h, 5Fh,0D4h
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	10 dup (55h)
		db	0AAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 01h, 00h, 11h, 00h, 45h
		db	 01h, 15h, 00h, 45h, 0Ah,0AAh
		db	 00h, 00h, 54h, 40h,0AAh,0A0h
		db	 11h, 00h, 54h, 40h, 51h, 00h
		db	 44h, 00h
		db	40h
		db	7 dup (0)
		db	 30h, 30h,0ECh
loc_58C8:
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		mov	cx,ss:d_0000_0202_e[bp+di]
		db	 00h, 00h, 00h, 00h,0FFh,0C0h
		db	0FFh, 30h, 00h,0FCh
		db	 55h, 3Fh
loc_58D9:
		push	bp
		aas				; Ascii adjust
;*		add	ah,bh
		db	 00h,0FCh		;  Fixup - byte match
		push	word ptr [bx+si]
;*		inc	ax
		db	0FFh,0C0h		;  Fixup - byte match
		add	di,di
		or	al,0FFh
		aas				; Ascii adjust
;*		add	ah,bh
		db	 00h,0FCh		;  Fixup - byte match
		push	bp
		cld				; Clear direction
		push	bp
		aas				; Ascii adjust
		add	[si],cl
		inc	word ptr [bp+di]
		jmp	dword ptr data_802A[bx+si]	;*
sub_5603	endp

			                        ;* No entry point to code
;		add	al,ds:PSP_free_seg[bx+si]
		db	2, 80h, 2, 0

		add	[bx+si],al
		add	data_8002[bx+si],al
		add	ch,byte ptr ds:[12Ah][bx+si]
		pop	dx
		jnc	$+2			; delay for I/O
		add	[bx+si],dl
		pop	cx
		mov	bh,22h			; '"'
		add	[bp+73h],ax
		add	[bp+7],dx
		leave				; Procedure exit
		jc	$+2			; delay for I/O
		db	21 dup (0)
data_5928	db	59h
data_5929	dw	0E659h
data_592B	db	1
		db	 40h,0A9h
		db	18 dup (0)
		db	0FFh,0FFh, 7Fh,0FFh, 50h, 00h
		db	 52h,0AAh, 52h,0AAh, 52h,0AAh
		db	 52h,0ABh, 00h, 00h,0FFh,0FCh
		db	0FFh,0F8h, 00h, 28h,0AAh, 28h
		db	0AAh, 28h,0AAh, 28h, 2Ah, 28h
		db	 52h,0A8h, 52h,0AAh, 52h,0AAh
		db	 52h,0AAh, 52h,0AAh, 50h, 00h
		db	 62h, 22h, 88h, 88h, 2Ah, 28h
		db	0A8h, 28h,0AAh, 28h,0A8h, 28h
		db	 22h, 28h, 00h, 28h, 22h, 28h
		db	 88h, 88h, 0Fh,0FEh, 2Ah,0ABh
		db	 2Ah,0ABh, 29h, 2Bh, 28h, 2Bh
		db	 2Ah,0ABh, 2Ah,0ABh, 00h, 03h
		db	0AAh,0AAh,0AFh,0AAh,0BFh,0ABh
		db	0BFh,0EBh,0BFh,0FFh,0AAh,0FFh
		db	0AAh,0AFh,0AAh,0ABh,0BFh,0FEh
		db	0FFh,0FFh,0C3h,0C3h, 03h,0C0h
		db	 03h,0C0h,0CCh, 33h,0FFh,0FFh
		db	0FCh, 3Fh,0AAh,0A8h,0AAh,0F8h
		db	0EAh,0FCh,0EBh,0FCh,0FFh,0FCh
		db	0FFh,0A8h,0FAh,0A8h,0EAh,0A8h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0ABh,0FFh,0ABh,0FEh,0AAh,0FAh
		db	0AAh,0FAh, 00h, 00h,0F3h,0CFh
		db	0FFh,0FFh,0FAh,0AFh,0EAh,0ABh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h,0AAh,0A8h,0AAh,0A8h
		db	0FAh,0A8h,0FFh,0E8h,0BFh,0E8h
		db	0AFh,0A8h,0AFh,0A8h, 00h, 00h
		db	 1Fh,0FFh, 37h,0FFh
		db	'=U=U=U=U:'
		db	0AAh, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh
		db	'UUUUUUUU'
		db	0AAh,0AAh, 00h, 00h,0FFh,0FFh
		db	0FFh,0FEh
		db	'UZUZUZUZ'
		db	0AAh,0AAh, 00h, 00h, 00h, 37h
		db	 00h, 37h, 00h, 37h, 00h, 37h
		db	 00h, 37h, 00h, 37h, 00h, 37h
		db	 00h
		db	'7UUUUUUW'
		db	 15h, 54h, 15h, 55h, 55h, 55h
		db	 55h, 55h, 55h, 58h, 00h, 58h
		db	 00h, 58h, 00h, 58h, 00h, 58h
		db	 00h, 58h, 00h, 58h, 00h, 58h
		db	 00h, 00h, 37h, 00h, 37h, 00h
		db	 37h, 00h, 37h, 00h, 37h, 00h
		db	 0Dh, 00h, 03h, 00h, 00h, 58h
		db	 00h, 58h, 00h, 58h, 00h, 58h
		db	 00h, 58h, 00h, 60h, 00h, 80h
		db	 00h, 00h, 00h
		db	 55h, 55h
		db	12 dup (55h)
		db	0AAh,0AAh, 0Ah,0A0h,0DFh,0F3h
		db	 0Ah,0A0h, 01h,0C0h, 0Ah,0A0h
		db	0DFh,0F3h, 0Ah,0A0h, 01h,0C0h
		db	 01h, 40h, 15h, 54h, 56h, 95h
		db	 5Bh,0E5h, 6Bh,0D9h, 56h, 95h
		db	 15h, 54h, 01h, 40h, 80h, 02h
		db	0AAh,0A8h, 80h, 02h,0AAh,0A8h
		db	 80h, 02h,0AAh,0A8h, 80h, 02h
		db	0AAh,0A8h,0AAh,0AAh, 55h, 55h
		db	0AAh,0AAh,0FFh,0FFh, 55h, 55h
		db	 55h, 55h,0FFh,0FFh, 00h, 00h
		db	 03h,0C0h, 03h,0C0h, 03h,0C0h
		db	 03h,0C0h, 03h,0FFh, 00h,0FFh
		db	 00h, 00h, 00h, 00h, 9Bh, 5Ch
		db	 9Bh, 5Ch, 9Bh, 5Ch, 9Bh, 5Ch
		db	 9Bh, 5Ch, 9Bh, 5Ch, 9Bh, 5Ch
		db	 9Bh, 5Ch, 03h,0C0h, 03h,0C0h
		db	 03h,0C0h, 03h,0C0h,0FFh,0C0h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 2Ah, 02h,0AAh, 0Ah,0A2h
		db	 28h,0AAh, 2Ah, 80h,0A8h, 3Fh
		db	0A3h,0FFh,0A3h,0F5h,0A8h, 00h
		db	0AAh, 80h, 8Ah,0A0h,0AAh, 28h
		db	 02h,0A8h, 54h, 2Ah, 55h, 4Ah
		db	 55h, 4Ah,0A1h, 55h,0A1h, 55h
		db	0A8h, 15h, 2Ah, 80h, 2Ah,0AAh
		db	 0Ah,0AAh, 02h,0AAh, 00h, 2Ah
		db	 55h, 4Ah, 55h, 4Ah, 54h, 2Ah
		db	 02h,0A8h,0AAh, 88h,0AAh, 20h
		db	 88h, 80h, 20h, 00h, 0Ah, 20h
		db	 0Ah, 20h, 0Ah, 20h, 15h, 54h
		db	 2Ah,0A8h, 00h, 00h, 0Ah, 20h
		db	 0Ah, 20h, 9Bh, 5Ch, 6Dh, 70h
		db	0B5h, 70h,0D5h,0C0h, 57h,0C0h
		db	 7Fh, 00h,0F0h, 00h, 00h, 00h
		db	 14h, 14h, 17h,0D4h, 17h,0D4h
		db	 17h,0D4h, 17h,0D4h, 14h, 14h
		db	 17h,0D4h, 14h, 14h, 37h, 44h
		db	 37h, 44h, 00h, 00h, 0Dh, 10h
		db	 00h, 00h, 37h, 44h, 37h, 44h
		db	 00h, 00h, 5Eh,0FFh, 17h,0AFh
		db	 35h,0FAh, 0Dh, 5Fh, 0Fh, 55h
		db	 03h,0F5h, 00h, 3Fh, 00h, 00h
		db	 33h, 33h, 55h, 5Fh,0AAh, 9Ch
		db	0AAh, 9Ch,0AAh, 70h,0A5h,0C0h
		db	 5Fh, 00h,0F0h, 00h,0CCh,0CCh
		db	0F5h, 55h, 36h,0AAh, 36h,0AAh
		db	 0Dh,0AAh, 03h, 5Ah, 00h,0F5h
		db	 00h, 0Fh, 00h, 00h, 00h, 0Fh
		db	 00h,0FDh, 03h,0D5h, 0Fh, 55h
		db	 0Fh, 55h, 3Dh, 55h, 3Dh, 55h
		db	0F5h, 55h,0F5h, 55h,0F5h, 55h
		db	0F5h, 55h,0F5h, 55h,0F5h, 55h
		db	0F5h, 55h,0F5h, 55h, 00h, 00h
		db	 50h, 00h, 5Ah, 00h, 55h, 80h
		db	'U`U`UXUX=U=U'
		db	 0Fh, 55h, 0Fh, 55h, 03h,0D5h
		db	 00h,0FDh, 00h, 0Fh, 00h, 00h
		db	'UXUXU`U`U'
		db	 80h, 5Ah, 00h,0A0h, 00h, 00h
		db	 00h
		db	'UVUVUVUVUVUVUVUVe'
		db	 00h,0AAh, 50h, 60h,0A5h,0A0h
		db	 5Ah, 65h,0A0h,0AAh, 00h, 60h
		db	 00h,0A0h, 00h, 00h, 56h, 05h
		db	0AAh, 5Ah, 06h,0A5h, 0Ah, 0Ah
		db	 56h, 00h,0AAh, 00h, 06h, 00h
		db	 0Ah,0FFh,0FFh,0EEh,0EAh,0FAh
		db	0AAh,0EAh,0AAh,0FAh,0AAh,0EAh
		db	0BFh,0EAh,0BBh,0EAh,0BEh,0FFh
		db	0FFh
		db	8 dup (0AAh)
		db	0FFh,0FFh,0AAh,0AAh,0AAh,0AAh
		db	0FFh,0FFh,0AAh,0A8h,0AAh,0A8h
		db	0AAh,0A8h,0AAh,0A8h,0FEh,0A8h
		db	0A2h,0A8h,0A2h,0A8h,0EAh,0BAh
		db	0EAh,0BAh,0EAh,0B0h,0EAh,0AAh
		db	0EAh,0AAh,0EAh,0AAh,0EAh,0AAh
		db	0C0h, 00h,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h
		db	8 dup (0AAh)
		db	 00h, 00h, 82h,0A8h, 22h,0A0h
		db	 02h,0A8h,0AAh,0A0h,0AAh, 88h
		db	0AAh, 20h, 88h, 88h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0AAh,0AAh
		db	0ABh, 2Ah,0A8h, 2Ah, 00h, 00h
		db	 55h, 55h, 00h, 00h,0D2h,0A9h
		db	 14h,0AAh,0D4h,0AAh, 15h, 0Ah
		db	0D5h, 50h, 15h, 55h,0D5h, 15h
		db	 14h, 15h, 55h, 57h, 55h, 54h
		db	0A5h, 57h,0AAh, 54h,0AAh, 97h
		db	 0Ah,0A4h, 52h,0ABh, 54h,0A8h
		db	0D5h, 55h, 15h, 55h,0D5h, 5Ah
		db	 15h,0AAh,0D6h,0AAh, 16h,0AAh
		db	0DAh,0AAh, 1Ah,0A9h, 56h,0ABh
		db	 6Ah,0A8h,0AAh,0A7h,0AAh, 94h
		db	0AAh, 57h,0A5h, 54h, 55h, 17h
		db	 54h, 14h,0A0h,0A8h,0A0h, 08h
		db	 02h, 80h, 22h,0A2h,0A0h, 00h
		db	 28h,0A8h, 00h,0A0h, 28h, 02h
		db	0A0h, 0Ah, 82h, 00h, 0Ah, 82h
		db	 2Ah, 02h, 20h, 20h, 00h,0A8h
		db	 88h, 80h, 08h, 0Ah, 00h, 28h
		db	 88h, 0Ah, 8Ah, 80h, 02h,0A0h
		db	 20h,0A0h, 28h, 00h, 28h,0A8h
		db	 00h,0A0h,0F5h, 55h,0F5h, 55h
		db	 3Dh, 55h, 3Dh, 55h, 0Fh, 55h
		db	 03h,0D5h, 00h, 3Fh, 00h, 00h
		db	14 dup (55h)
		db	0AAh,0AAh
		db	'UZUZUhUhU'
		db	0A0h, 56h, 80h,0A8h, 00h, 00h
		db	 00h, 02h, 80h, 02h, 80h, 02h
		db	 80h, 2Ah,0A8h, 24h, 28h, 24h
		db	 28h, 25h, 68h, 2Ah,0A8h,0FFh
		db	0FFh, 55h, 55h, 55h, 55h, 57h
		db	 15h, 54h, 15h, 55h, 55h, 55h
		db	 55h, 55h, 55h, 00h, 51h, 01h
		db	 55h, 05h, 55h, 05h, 55h, 00h
		db	 00h, 00h, 55h, 00h, 01h, 00h
		db	 14h, 50h, 00h, 44h, 00h, 51h
		db	 00h, 55h, 00h, 00h, 00h, 50h
		db	 00h, 40h, 00h, 00h, 00h,0FFh
		db	0FFh, 88h, 88h, 21h, 22h, 88h
		db	 88h,0FFh,0FFh, 00h, 00h, 00h
		db	 15h, 00h, 05h,0FFh,0FFh, 88h
		db	 88h, 21h, 22h, 88h, 88h,0FFh
		db	0FFh, 00h, 00h, 40h, 00h, 00h
		db	 00h, 3Fh,0FFh, 2Fh,0FCh, 1Bh
		db	0F0h, 16h,0C0h, 15h, 80h, 16h
		db	0A0h, 1Ah,0A8h, 2Ah,0AAh, 00h
		db	 00h
		db	7 dup (0)
		db	 02h, 00h, 02h, 00h, 08h, 00h
		db	 28h, 00h, 2Ah, 02h,0ABh, 2Ah
		db	0AAh,0AAh, 00h, 80h, 5Fh, 15h
		db	 7Fh, 55h,0FDh, 80h, 00h,0A8h
		db	 00h,0EAh, 80h,0AAh,0A8h, 00h
		db	0AAh,0D5h, 02h
		db	 55h, 54h, 55h, 55h
		db	10 dup (0)

locloop_5DD6:
		add	byte ptr [bx+si],80h
		add	[bx+si],ah
		add	[bx+si],ch
		add	[bx+si],al
		stosb				; Store al to es:[di]
		add	cx,data_AB03[bx+si]
		add	cx,ss:data_AB03[bp+di]
		add	ss:data_2000[bp+di],cl
		add	[bx+si],al
		xor	ax,0D07Fh
		pop	ds
		rol	byte ptr [bx],0C1h	; Rotate
		add	ax,dx
		add	ax,ax
		or	al,0E0h
		sub	al,0FAh
		mov	al,0FDh
		pop	sp
		hlt				; Halt processor
		pop	es
		rol	byte ptr [bp+di],1	; Rotate
		rol	byte ptr [bp+di-40h],83h	; Rotate
		xor	[bp+di],al
		cmp	[bp+di],cl
		push	cs
		scasw				; Scan es:[di] for ax
		stosb				; Store al to es:[di]
		add	[bp+si],ah
		shr	dl,0C0h			; Shift w/zeros fill
		loop	locloop_5DD6		; Loop if cx > 0

;*		jmp	far ptr l_0800_E2C0	;*
		db	0EAh
		dw	0E2C0h, 800h		;  Fixup - byte match
		db	 00h, 00h, 00h,0D5h, 4Fh,0F5h
		db	 53h,0FDh, 54h, 7Fh, 54h, 5Fh
		db	0D4h, 57h,0F4h, 55h,0F3h, 55h
		db	 4Fh, 3Fh, 33h, 00h,0FFh, 03h
		db	 3Fh, 03h, 0Fh, 03h, 00h, 00h
		db	0C0h, 00h, 3Ch, 00h, 0Fh,0CCh
		db	0FCh,0FFh, 00h,0FCh,0C0h, 30h
		db	0C0h, 00h,0C0h, 03h, 00h, 3Ch
		db	 00h,0F0h, 00h,0F1h, 57h,0C5h
		db	 5Fh, 15h, 7Fh, 15h,0FDh, 17h
		db	0F5h, 1Fh,0D5h,0CFh, 55h,0F1h
		db	 55h,0AAh,0AAh,0FFh,0FEh,0FFh
		db	0FEh,0F4h,0FEh,0D0h,0FEh,0F7h
		db	0F8h,0FFh,0E0h,0AAh, 80h, 00h
		db	 55h, 00h, 55h, 00h, 55h, 00h
		db	 17h, 00h, 15h, 00h, 05h, 00h
		db	 01h, 00h, 00h, 55h, 00h, 55h
		db	 00h, 55h, 00h, 54h, 00h, 54h
		db	 00h, 50h, 00h, 40h, 00h, 00h
		db	 00h, 55h, 55h, 75h, 55h,0F5h
		db	 55h,0F5h, 55h,0FDh, 55h, 7Fh
		db	0F5h, 5Fh,0D5h, 15h, 54h,0AAh
		db	0AAh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 3Fh,0F4h, 1Fh,0FDh, 7Fh,0FFh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0BFh
		db	0FFh,0BFh,0FFh,0BFh, 1Fh,0BFh
		db	 07h, 2Fh,0DFh, 0Bh,0FFh, 02h
		db	0AAh,0FFh,0FFh
		db	12 dup (55h)
		db	0AAh,0AAh,0FCh, 00h, 57h,0C0h
		db	'UlUlUlUlV'
		db	 80h,0A8h, 00h, 00h, 00h
		db	15 dup (0)
		db	0FFh, 23h, 55h, 99h, 55h, 99h
		db	 55h, 99h, 55h, 99h
loc_5EF9:
		push	bp
;*		and	dl,[di+0]
		db	 22h, 55h, 00h		;  Fixup - byte match
loc_5EFD:
		stosb				; Store al to es:[di]
		ja	loc_5EF9		; Jump if above
;*		ja	loc_5EFB		;*Jump if above
		db	 77h,0F9h		;  Fixup - byte match
		ja	loc_5EFD		; Jump if above
;*		ja	loc_5EFF		;*Jump if above
		db	 77h,0F9h		;  Fixup - byte match
		add	[bx+si],al
		pop	es
		nop
		pop	es
		nop
		pop	es
		nop
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0CCh,0CCh,0CCh,0CCh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Ah,0A0h
		db	0AAh
loc_5F21:
		sub	[bx+si],al
		mov	ds:d_0000_0A00_e,al
		add	[bp+si],cl
		add	byte ptr ss:[28AAh][bp+si],ah

;		or	ah,ds:d_0000_003F_e[bx+si]
		db	0Ah, 0A0h, 3Fh, 0

;*		add	ax,si
		db	 01h,0F0h		;  Fixup - byte match
		add	[si-34h],bl
		out	0CCh,ax			; port 0CCh, DMA-2 bas&add ch 3
		out	0,al			; port 0, DMA-1 bas&add ch 0
		pop	ax

;		add	ds:d_0000_002A_e[bx+si],sp
		db	1, 0A0h, 2Ah, 0

		shr	byte ptr ss:data_00D0_e[bp+si],cl	; Shift w/zeros fill
;*		aad	55h			; 'U' undocumented inst
		db	0D5h, 55h		;  Fixup - byte match
		rol	byte ptr [bx+si],1	; Rotate
		shr	ss:data_AAD2[bp+si],cl	; Shift w/zeros fill
		sar	byte ptr ds:d_0000_AAD2_e[bx],cl	; Shift w/sign fill
		stosb				; Store al to es:[di]
		lea	ax,[bx+si]		; Load effective addr
		or	ax,5555h
		add	[di],cl
		stosb				; Store al to es:[di]
		lea	bp,ss:data_FE8D_e[bp+si]	; Load effective addr
		lea	bp,ss:data_018D[bp+si]	; Load effective addr
		adc	[si],ax
		inc	bp
		add	[bx+di],dx
		add	al,44h			; 'D'
;*		or	ch,ss:data_0000_e[bp+si]
		db	 0Ah,0AAh, 00h, 00h	;  Fixup - byte match
		or	al,[bp+si+3Ch]
		sub	[di+7Dh],dl
		push	bp
		jge	loc_5FC8		; Jump if > or =
;*		jge	loc_5FCA		;*Jump if > or =
		db	 7Dh, 55h		;  Fixup - byte match
		jge	loc_5F21		; Jump if > or =
		stosb				; Store al to es:[di]
		add	[bx+si],al
		inc	dx
		cmp	al,3Ch			; '<'
		dec	dx
		or	ah,ds:d_0000_8002_e[bx+si]
		mov	al,ds:d_0000_A808_e
		test	al,0
		mov	al,ds:d_0000_0228_e
		sub	[bp+si],ch
		and	[bx+si],ch
		cmp	al,3Ch			; '<'
		retn
			                        ;* No entry point to code
		iret				; Interrupt return
			                        ;* No entry point to code
		push	word ptr [bp+di]
		retn
			                        ;* No entry point to code
		or	al,0
		shr	byte ptr [bx+si],2	; Shift w/zeros fill
		sub	[bp+si],ch
		and	[bx+si],cl
		db	0FFh,0FFh, 00h, 00h,0AAh,0AAh
		db	0ABh, 2Ah,0A8h, 2Ah,0AAh,0AAh
		db	 00h, 00h, 55h, 55h,0D1h,0AAh
		db	0D2h, 6Ah,0D1h,0AAh,0D2h, 6Fh
		db	0D1h,0A8h,0D2h, 6Ah,0D1h,0AAh
		db	0D2h, 6Ah,0ABh, 34h,0AEh, 34h
		db	0ABh
		db	 34h, 2Eh, 34h, 2Bh, 34h
loc_5FC8:
		scasb				; Scan es:[di] for al
		xor	al,0ABh
		xor	al,0AEh
		xor	al,0CAh
		test	al,32h			; '2'
		stosb				; Store al to es:[di]
		or	al,0AAh
		add	bp,[bp+si]
;*		add	dl,cl
		db	 00h,0CAh		;  Fixup - byte match
		add	[bp+si],dh
		add	[si],cl
		add	[bp+di],al
		inc	ax
		add	[bx+si],dl
		add	data_A100[si],al
		add	data_AA40[bx+si],ch
		adc	byte ptr ds:[2084h][si],ch
		mov	ax,word ptr ds:[100h]
		add	[si],al
		add	[bp+si],dl
		add	[bp+si+1],cl
		sub	al,[si]
		stosb				; Store al to es:[di]
		adc	cl,dl
		dec	dx
		or	[bp+si],ch
		mov	data_8CAA,ax
		stosb				; Store al to es:[di]
		xor	data_A3C0[bx+si],ch
		add	data_3000[si],cl
;*		add	al,al
		db	 00h,0C0h		;  Fixup - byte match
		db	 00h, 00h, 00h, 00h, 00h, 90h
		db	 90h, 09h, 09h, 00h, 00h, 60h
		db	 60h, 06h, 06h, 00h, 00h, 23h
		db	0C2h, 50h,0A5h, 00h, 00h,0AAh
		db	0AAh, 00h, 00h, 7Dh, 55h, 7Dh
		db	 55h, 7Dh, 55h,0A0h, 50h, 1Ah
		db	 0Ch, 00h, 00h,0AAh,0A0h, 00h
		db	 00h, 51h, 10h, 54h, 40h, 51h
		db	 10h,0AAh, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0BBh,0BBh,0EEh,0EEh, 00h
		db	 00h,0FFh,0FFh
loc_604C:
		push	bp
		push	bp
		db	0FFh,0FFh
loc_6050:
		push	bp
		push	bp
		add	[bx+si],al
		db	 66h, 66h, 99h, 99h,0AAh,0AAh
		db	0AAh,0AAh,0ABh,0CAh,0AAh,0AAh
		db	0F3h,0CFh,0AAh,0AAh, 07h,0FFh
		db	 07h,0FFh, 01h,0FFh, 00h, 5Fh
		db	 00h, 0Ah,0AAh,0AAh,0F3h,0CFh
		db	0AAh,0AAh,0FFh,0D0h,0FFh,0D0h
		db	0FFh, 40h,0F5h, 00h,0A0h, 00h
		db	0AAh
loc_607F:
		add	ax,ss:data_820F[bp+si]
loc_6083:
		scasw				; Scan es:[di] for ax
;*		or	byte ptr [bx],0AAh
		db	 82h, 0Fh,0AAh		;  Fixup - byte match
		add	ax,[bx+si]
		or	al,[bx+si]
;*		aad	3			; undocumented inst
		db	0D5h, 03h		;  Fixup - byte match
		push	bp
		shr	byte ptr ss:data_82F0[bp+si],0FAh	; Shift w/zeros fill
;*		xor	al,82h
		db	 82h,0F0h, 82h		;  Fixup - byte match
		shr	byte ptr ss:data_00A0_e[bp+si],57h	; 'W' Shift w/zeros fill
		add	[di-40h],dl
		test	ax,970h
		jo	loc_604C		; Jump if overflow=1
		jo	loc_60AE		; Jump if overflow=1
		jo	loc_6050		; Jump if overflow=1
		jo	loc_60FE		; Jump if overflow=1
;*		rcl	byte ptr [bx+0],0AAh	; Rotate thru carry
		db	0C0h, 57h, 00h,0AAh	;  Fixup - byte match
		db	0AAh
loc_60AE:
		or	ax,0D6Ah
		pusha				; Save all regs
		or	ax,0D6Ah
		pusha				; Save all regs
		or	ax,36Ah
		push	bp
;*		add	ch,dl
		db	 00h,0D5h		;  Fixup - byte match
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	al,5
		add	al,5
		add	[di],al
		add	[di],al
		add	[bx+si],al
		add	[bx+di],al
		add	[bx+si],al
		add	[bx+di],al
		push	ax
		adc	[bx+si+10h],dl
		push	ax
;*		add	[bx+si+0],dl
		db	 00h, 50h, 00h		;  Fixup - byte match
		db	 00h, 00h, 40h, 00h, 00h, 00h
		db	 40h, 00h, 00h, 00h,0AAh,0AAh
		db	 55h, 55h,0AAh,0AAh,0AAh,0AAh
		db	 88h, 88h, 22h, 22h, 00h, 00h
		db	 02h,0A8h,0A9h, 54h, 56h,0A8h
		db	0AAh,0A8h,0AAh,0A8h, 8Ah,0A8h
		db	 22h, 20h, 00h, 88h
loc_60FE:
		push	bp
		push	bp
		push	0FFAAh
		push	0FFAAh
		push	0FFAAh
		push	0FFA9h
		push	0FFA9h
		push	0FFA9h
		push	0FFA9h
		push	bp
		push	bp
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	bp
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	bp
		push	sp
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_A0AA	; ('        ')
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_A0AA	; ('        ')
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_A0AA	; ('        ')
		stosb				; Store al to es:[di]
		mov	al,data_A96A
		push	0FFA9h
		push	0FFA9h
		push	0FFA9h
		push	0FFAAh
		push	0FFAAh
		bound	sp,dword ptr [bp+si]
		inc	ax
		add	ss:data_AA6A[bp+si],ch
		inc	ax
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bx+si],al
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		and	ah,[bp+si]
		add	[bx+si],al
		stosb				; Store al to es:[di]
		mov	al,data_80AA
		stosb				; Store al to es:[di]
		and	ss:data_AA80[bp+si],ch
		and	byte ptr ds:[2280h][bx+si],cl
		and	[bx+si],al
		add	[di+55h],dl
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	bp
		stosb				; Store al to es:[di]
		test	al,0AAh
		test	al,56h			; 'V'
		test	al,0A2h
		test	al,2
		test	al,0AAh
		test	al,0
		add	byte ptr ss:data_AAA8+2[bp+si],ch
		stosb				; Store al to es:[di]
		and	ah,[bp+si]
		add	[bx+si],al
		or	bl,data_9822[bx+si]
		or	bl,data_9822[bx+si]
		mov	ah,ss:data_A62A[bp]
;*		mov	ah,ss:data_0000_e[bp]
		db	 8Ah,0A6h, 00h, 00h	;  Fixup - byte match
		or	bl,data_A622[bx+si]
		or	ch,data_AA22[bx+di]
		or	byte ptr ss:[2202h][bp+si],ch
;*		add	ds:data_0000_e[bx+si],cl
		db	 00h, 88h, 00h, 00h	;  Fixup - byte match
		mov	al,es:data_889A
		push	0FFA0h
		stosb				; Store al to es:[di]
		mov	ss:data_8820[bp+si],ch
		and	byte ptr [bp+si],0
		add	[bx+si],al
		mov	al,es:data_8826
		mov	al,es:data_8826
;*		call	far ptr s_9AA8_9AA2	;*
		db	9Ah
		dw	9AA2h, 9AA8h		;  Fixup - byte match
		mov	ds:data_0000_e,al
		add	[bx],cl
		add	[bx],cl
		add	cx,di
		add	ax,bp
		add	ax,bp
		db	0F1h, 45h,0F1h
		db	'EQEQEQEQE'
		db	 01h, 45h, 00h, 05h, 01h, 40h
		db	 00h, 05h, 00h, 05h,0F0h, 00h
		db	0F0h, 00h,0F3h,0C0h, 53h,0C0h
		db	 53h,0C0h
		db	'QOQOQEQEQEQEQ@P'
		db	 00h, 01h, 40h, 50h, 00h, 50h
		db	 00h, 00h, 00h, 0Ah,0A0h, 2Ah
		db	 68h, 29h, 58h, 2Ah, 68h, 2Ah
		db	0A8h, 0Ah,0A0h, 00h, 00h, 2Eh
		db	0A0h, 2Eh, 88h, 2Eh,0A0h, 2Eh
		db	 88h, 2Eh,0A0h, 2Eh, 88h, 2Eh
		db	0A0h, 2Eh, 88h, 0Bh, 80h, 0Bh
		db	 20h, 0Bh, 80h, 0Bh, 20h, 0Bh
		db	 80h, 0Bh, 20h, 0Bh, 80h, 0Bh
		db	 20h, 00h, 00h, 00h, 05h, 00h
		db	 55h, 03h, 15h, 0Fh,0C5h, 0Fh
		db	0F1h, 3Ch,0C0h, 3Fh,0CAh, 00h
		db	 00h, 50h, 00h, 55h, 00h, 54h
		db	0C0h, 53h,0F0h, 4Fh,0F0h, 03h
		db	 3Ch,0A3h,0FCh, 3Fh,0C0h, 3Ch
		db	0CAh, 0Fh,0C0h, 0Fh,0C5h, 03h
		db	 15h, 00h, 55h, 00h, 05h, 00h
		db	 00h, 03h,0FCh,0A3h, 3Ch, 03h
		db	0F0h, 53h,0F0h, 54h,0C0h, 55h
		db	 00h, 50h, 00h, 00h, 00h, 00h
		db	0B4h, 00h,0B4h, 00h,0B4h, 00h
		db	0B4h,0AAh,0F4h,0FFh,0D0h, 55h
		db	 40h, 00h, 00h, 1Eh, 00h, 1Eh
		db	 00h, 1Eh, 00h, 1Eh, 00h, 1Fh
		db	0AAh, 07h,0FFh, 01h, 55h, 00h
		db	 00h,0AAh,0AAh, 00h, 00h, 55h
		db	 55h, 57h, 15h, 54h, 15h,0FFh
		db	0FFh, 00h, 00h,0AAh,0AAh,0D0h
		db	0AAh,0D2h, 2Ah,0D0h,0AAh,0D2h
		db	 2Fh,0D0h,0AFh,0D2h, 28h,0D0h
		db	0AAh,0D2h, 2Ah,0A8h, 34h,0A2h
		db	 34h,0A8h, 34h,0A2h, 34h, 28h
		db	 34h, 22h, 34h,0A8h, 34h,0A2h
		db	 34h, 0Ch, 0Ch, 38h, 38h,0E8h
		db	0E8h,0AAh,0AAh,0F3h,0F3h, 3Fh
		db	 3Fh,0AAh,0AAh, 00h, 00h, 03h
		db	 3Ch, 03h,0C3h, 03h,0FCh, 00h
		db	0FFh, 00h,0CCh, 00h, 30h, 00h
		db	 0Fh, 00h, 00h,0FCh,0F3h,0F0h
		db	 0Fh,0C9h,0A3h, 29h,0A8h, 98h
		db	 26h,0A0h, 0Ah, 28h, 28h,0C6h
		db	 93h,0FCh, 00h,0F3h,0C0h, 0Fh
		db	0C0h,0F3h, 00h, 3Fh, 00h, 0Ch
		db	 00h,0F0h, 00h, 00h, 00h, 00h
		db	 01h, 00h, 05h, 00h, 15h, 00h
		db	 54h, 00h, 43h, 01h, 33h, 00h
		db	0F3h, 03h, 3Ch, 55h, 55h, 45h
		db	 11h, 10h, 05h, 0Fh,0F0h,0F3h
		db	 0Fh,0FCh,0FFh,0F3h,0FFh,0F3h
		db	0FCh, 40h, 00h, 50h, 00h, 54h
		db	 00h, 15h, 00h,0C1h, 00h, 3Ch
		db	 40h, 03h, 00h, 3Fh,0C0h, 40h
		db	 41h, 11h, 11h, 04h, 04h, 05h
		db	 10h, 01h, 50h, 01h, 40h, 04h
		db	 50h, 11h, 54h, 00h, 00h,0A0h
		db	 00h,0AAh, 00h, 6Ah,0A0h, 15h
		db	0A8h, 00h, 5Ah, 15h, 40h, 40h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 55h, 55h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 00h, 0Ah, 00h,0AAh, 0Ah
		db	0A9h, 2Ah, 54h,0A5h, 00h, 01h
		db	 54h, 00h, 01h, 02h,0AAh, 0Bh
		db	0AAh, 2Ah, 00h,0B8h, 15h,0A0h
		db	 55h,0A1h, 55h,0A1h, 55h,0A1h
		db	 55h,0A5h, 55h,0A5h, 55h,0A5h
		db	 55h,0A5h, 55h,0B9h, 55h, 2Ah
		db	 55h, 0Bh,0AAh, 02h,0AAh
		db	'U(U(U(T(P'
		db	0B8h, 02h,0A0h,0ABh, 80h,0AAh
		db	 00h,0AAh, 00h,0ABh, 80h, 56h
		db	0A0h, 55h,0B8h
		db	'UhUhUhUh*'
		db	0AAh, 8Fh,0FFh,0B3h,0FFh,0BCh
		db	0FFh,0BFh, 00h,0BFh, 22h,0BFh
		db	 08h,0BFh, 22h,0AAh,0AAh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h, 22h, 22h, 88h, 88h, 22h
		db	 22h,0AAh,0A0h,0FFh,0C8h,0FFh
		db	 18h,0FCh, 58h, 01h, 58h, 21h
		db	 58h, 81h, 58h, 21h, 58h,0BFh
		db	 08h,0BFh, 22h,0BFh, 08h,0BFh
		db	 00h,0BCh, 55h,0B1h, 55h, 85h
		db	 55h, 2Ah,0AAh, 88h, 88h, 22h
		db	 22h, 88h, 88h, 00h, 00h, 55h
		db	 55h, 55h, 55h, 55h, 55h,0AAh
		db	0AAh, 81h, 58h, 21h, 58h, 81h
		db	 58h, 01h, 58h, 54h, 58h, 55h
		db	 18h, 55h, 48h,0AAh,0A0h, 2Ah
		db	0AAh, 85h, 55h, 91h, 55h, 94h
		db	 55h, 95h, 00h, 95h, 3Fh, 95h
		db	 3Fh, 95h, 3Fh,0AAh,0AAh, 55h
		db	 55h, 55h, 55h, 55h, 55h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 3Fh,0AAh,0A0h, 55h, 44h, 55h
		db	 14h, 54h, 64h, 01h, 94h,0F2h
		db	 64h,0F1h, 94h,0F2h, 64h, 95h
		db	 3Fh, 95h, 3Fh, 95h, 3Fh, 95h
		db	 00h, 94h, 99h, 92h, 66h, 89h
		db	 99h, 15h, 55h,0F0h, 3Fh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 99h
		db	 99h, 66h, 66h, 99h, 99h, 55h
		db	 55h,0F1h, 94h,0F2h, 64h,0F1h
		db	 94h, 02h, 64h, 98h, 94h, 66h
		db	 24h, 99h, 84h, 55h, 50h,0FFh
		db	0FFh,0D5h, 55h,0D5h, 55h,0D5h
		db	 55h,0D5h, 57h,0D5h, 57h,0D5h
		db	 57h,0D5h, 57h,0FFh,0FFh, 55h
		db	 55h, 55h, 55h, 55h, 55h,0FFh
		db	0FFh, 55h, 55h, 55h, 55h, 55h
		db	0FFh,0FFh,0FFh, 55h, 55h, 55h
		db	 55h, 55h, 55h,0FFh,0FFh, 55h
		db	 54h, 55h, 54h,0FDh, 54h,0FFh
		db	0FCh
		db	'UPUPUPUPUPUPUP'
		db	0D5h, 57h,0D5h, 57h,0D5h, 57h
		db	0D5h, 57h,0D5h, 55h,0D5h, 55h
		db	0D1h, 11h,0C0h, 00h, 55h,0D5h
		db	 55h,0C0h, 55h, 55h, 00h, 00h
		db	 55h, 55h, 55h, 55h, 11h, 11h
		db	 00h, 00h, 51h, 54h, 01h, 54h
		db	 55h, 54h, 00h, 00h, 55h, 55h
		db	 55h, 55h, 11h, 11h, 00h, 00h
		db	 55h, 50h, 55h, 40h, 55h, 10h
		db	 55h, 40h, 55h, 10h, 44h, 40h
		db	 11h, 10h, 00h, 00h, 00h, 05h
		db	 0Ah, 54h, 2Ah,0A5h, 00h,0A9h
		db	 03h, 0Ah, 0Fh,0F2h, 0Fh,0FCh
		db	 00h
		db	'?U/UKURQTUU'
		db	 95h, 55h,0A5h, 55h,0A5h, 15h
		db	0F8h, 55h,0E1h, 55h, 85h, 55h
		db	 15h
		db	'EUUUVUZTZP'
		db	 00h, 15h,0A0h, 5Ah,0A8h, 6Ah
		db	 00h,0A0h,0C0h, 8Fh,0F0h, 3Fh
		db	0F0h,0FCh, 00h,0AAh,0AAh,0FFh
		db	 7Fh,0FDh,0F7h,0F7h,0DFh,0DFh
		db	 7Fh,0FDh,0FFh,0F7h,0FFh,0AAh
		db	0AAh,0A5h, 55h,0E9h, 55h,0E9h
		db	 45h,0E9h, 55h,0E9h, 55h,0E9h
		db	 45h,0E9h, 55h,0A5h
		db	'UUZUkQkUkUkQkUkUZ'
		db	 9Ah,0AAh, 9Ah,0AAh, 03h, 7Fh
		db	 9Ah,0AAh, 9Ah,0AAh, 03h, 7Fh
		db	 9Ah,0AAh, 9Ah,0AAh, 00h, 3Fh
		db	 0Fh,0FCh, 0Fh,0F2h, 03h, 0Ah
		db	 00h,0A9h, 2Ah,0A5h, 0Ah, 05h
		db	 00h, 00h,0A5h, 15h,0A5h, 55h
		db	 95h
		db	'UUUQUUPUJU*TZUZUVUUUE'
		db	 05h, 55h,0A1h, 55h,0A8h, 55h
		db	0FCh, 00h, 3Fh,0F0h, 8Fh,0F0h
		db	0A0h,0C0h, 6Ah, 00h, 5Ah,0A8h
		db	 50h,0A0h, 00h, 00h,0AAh,0A2h
		db	0AAh,0A2h,0FCh,0C0h,0AAh,0A2h
		db	0AAh,0A2h,0FCh,0C0h,0AAh,0A2h
		db	0AAh,0A2h, 3Ch,0F0h,0C3h,0FCh
		db	0FCh, 03h, 00h, 20h, 20h,0A0h
		db	 28h, 00h, 28h,0A8h, 00h,0A0h
		db	 00h, 00h, 00h, 01h, 00h, 05h
		db	 00h, 11h, 00h, 15h, 00h, 45h
		db	 05h, 15h, 51h, 55h, 00h, 01h
		db	 00h, 01h, 00h, 05h, 00h, 15h
		db	 00h, 14h, 00h, 45h, 00h, 51h
		db	 00h, 51h, 00h, 50h, 00h, 55h
		db	 00h, 15h, 00h, 54h, 01h, 11h
		db	 04h, 44h, 11h, 11h, 44h, 54h
		db	 40h, 00h, 50h, 00h, 44h, 00h
		db	 54h, 00h, 51h, 00h, 55h, 40h
		db	 55h, 10h, 55h, 55h, 40h, 00h
		db	 50h, 00h, 50h, 00h, 44h, 00h
		db	 51h, 00h, 51h, 00h, 55h, 00h
		db	 54h, 00h, 51h, 00h, 51h, 00h
		db	 55h, 00h, 45h, 40h, 54h, 50h
		db	 55h, 50h, 55h, 14h, 55h, 51h
		db	 15h, 51h, 54h, 55h, 55h, 55h
		db	 51h, 15h
		db	'UEEUUUTTUTUUU'
		db	 15h, 51h, 55h, 55h, 45h, 55h
		db	 15h, 55h, 55h, 45h, 51h, 15h
		db	 15h, 55h, 55h, 45h, 54h, 55h
		db	 41h, 55h, 15h, 55h, 15h, 54h
		db	 55h, 15h, 55h, 50h, 00h, 50h
		db	 00h, 44h, 00h, 55h, 00h, 45h
		db	 00h, 51h, 40h, 51h, 10h, 55h
		db	 55h, 45h, 55h, 50h, 55h, 04h
		db	 15h, 51h, 45h, 05h, 05h, 10h
		db	 51h, 55h, 15h, 50h, 54h, 45h
		db	 55h, 15h, 55h, 11h
		db	 55h, 55h, 55h, 45h
		db	7 dup (55h)
		db	 00h, 00h, 00h, 01h, 00h, 01h
		db	 00h, 04h, 00h, 11h, 01h, 54h
		db	 05h, 11h, 14h, 44h, 55h, 55h
		db	 45h, 55h, 51h, 51h, 10h, 45h
		db	 54h, 50h, 51h, 11h, 05h, 45h
		db	 55h, 55h, 15h, 55h, 54h, 55h
		db	 55h, 41h, 50h, 15h, 55h, 05h
		db	 54h, 55h, 55h, 11h, 55h, 55h
		db	 44h, 44h, 11h, 11h, 54h, 44h
		db	 11h, 11h, 44h, 44h, 11h, 51h
		db	 44h, 44h, 11h, 11h, 55h, 55h
		db	 51h, 55h, 05h, 55h, 54h, 45h
		db	 11h, 05h, 44h, 55h, 15h, 15h
		db	 50h, 54h, 50h, 00h, 45h, 00h
		db	 54h, 51h, 51h, 05h, 15h, 51h
		db	 55h, 55h, 45h, 45h, 55h, 55h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	'PQUUEQPUUU'
		db	 00h, 04h, 05h, 50h
data_6702	dw	4515h
		db	 51h, 11h, 44h, 45h, 15h, 50h
		db	 45h, 55h, 55h, 55h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 40h, 00h
		db	 50h, 00h, 55h, 00h, 45h, 50h
		db	 54h, 55h, 50h, 01h, 54h, 05h
		db	 15h, 54h, 50h, 51h, 55h, 15h
		db	 55h, 55h, 51h, 55h, 45h, 55h
		db	9 dup (0)
		db	 05h, 00h, 54h, 05h, 41h, 55h
		db	 11h
		db	'UUUEQUEEQ'
		db	 15h, 14h, 51h, 55h, 55h, 55h
		db	 55h, 00h,0FEh, 0Fh,0BFh, 3Bh
		db	0E0h,0FFh, 80h,0FBh,0F0h, 0Fh
		db	0BBh, 50h, 0Eh, 45h, 50h,0CFh
		db	 0Fh,0BEh,0FBh,0C3h,0E0h, 00h
		db	 00h, 00h, 00h,0BFh, 0Eh,0E0h
		db	0FBh, 05h, 00h,0CFh, 0Fh,0BEh
		db	0FBh,0C3h,0F0h, 00h, 00h, 00h
		db	 00h,0EFh, 0Fh,0F0h,0FBh, 05h
		db	 00h,0EFh, 00h,0BEh,0F0h, 03h
		db	0ECh, 00h,0FBh, 0Fh,0BFh,0BBh
		db	0ECh,0EFh,0C1h, 00h, 15h
		db	8 dup (0)
		db	 40h, 00h, 40h, 00h, 50h, 00h
		db	 54h, 00h, 54h, 00h, 51h, 00h
		db	 55h, 00h, 54h, 50h, 51h, 04h
		db	 54h, 54h, 55h, 45h, 55h, 15h
		db	 00h, 00h
		db	9 dup (0)
		db	 01h, 00h, 05h, 00h, 15h, 00h
		db	 15h, 00h, 11h, 00h, 45h, 00h
		db	 54h, 05h, 11h, 05h, 55h, 15h
		db	'EQUEUUUEUPUT'
		db	 15h, 50h, 45h, 54h, 01h, 50h
		db	 51h, 55h, 05h, 54h, 55h, 11h
		db	 15h, 50h, 55h, 05h, 15h, 44h
		db	 55h, 11h, 05h, 50h, 50h, 55h
		db	 55h, 51h, 45h, 55h, 15h, 55h
		db	 15h, 54h, 15h, 50h, 45h, 50h
		db	 55h, 41h, 15h, 54h, 55h, 55h
		db	 15h, 55h, 51h, 55h, 05h, 54h
		db	 41h, 55h, 05h, 50h, 50h, 45h
		db	 15h, 00h, 88h, 0Ah,0FFh, 2Bh
		db	 00h, 0Ch, 44h, 2Ch, 44h, 2Bh
		db	 00h, 0Ah,0FFh, 00h, 88h, 88h
		db	 88h,0FFh,0FFh, 00h, 00h, 44h
		db	 44h, 44h, 44h, 00h, 00h,0FFh
		db	0FFh, 88h, 88h, 88h, 00h,0FEh
		db	 80h, 03h,0A0h, 44h,0E0h, 44h
		db	0C0h, 03h,0A0h,0FEh, 80h, 88h
		db	 00h, 00h, 00h, 32h,0C8h,0A0h
		db	0B2h, 80h, 32h,0A0h,0B2h, 80h
		db	 32h,0A0h,0B2h, 01h, 04h, 32h
		db	0C8h, 00h,0C8h, 00h,0FAh, 00h
		db	 32h, 00h
		db	32h
		db	32 dup (0)
		db	0C8h, 00h,0FAh, 00h, 32h, 00h
		db	 08h, 08h, 28h, 28h,0AAh,0AAh
		db	 00h, 00h, 10h, 10h, 00h, 00h
		db	0AAh,0AAh, 00h, 00h, 7Dh, 55h
		db	0AAh,0AAh, 11h, 11h
		db	'UUUUUWUW'
		db	0AAh,0AAh, 7Dh, 55h,0AAh,0AAh
		db	 13h, 31h, 17h,0F5h, 05h,0FDh
		db	 01h, 7Fh, 00h, 17h, 00h, 0Ah
		db	0A0h, 00h,0F4h, 00h, 7Dh, 40h
		db	 7Fh, 50h, 5Fh,0D4h, 5Fh,0D4h
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	10 dup (55h)
		db	0AAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 01h, 00h, 11h, 00h, 45h
		db	 01h, 15h, 00h, 45h, 0Ah,0AAh
		db	 00h, 00h, 54h, 40h,0AAh,0A0h
		db	 11h, 00h, 54h, 40h, 51h, 00h
		db	 44h, 00h
		db	40h
		db	7 dup (0)
		db	 30h, 30h,0ECh
loc_68F5:
		in	al,dx			; port 0FFFFh ??i/o non-standard
		mov	cx,word ptr ss:[202h][bp+di]
		db	 00h, 00h, 00h, 00h,0FFh,0C0h
		db	0FFh, 30h, 00h,0FCh
		db	 55h, 3Fh
loc_6906:
		push	bp
		aas				; Ascii adjust
;*		add	ah,bh
		db	 00h,0FCh		;  Fixup - byte match
		push	word ptr [bx+si]
;*		inc	ax
		db	0FFh,0C0h		;  Fixup - byte match
		add	di,di
		or	al,0FFh
		aas				; Ascii adjust
;*		add	ah,bh
		db	 00h,0FCh		;  Fixup - byte match
		push	bp
		cld				; Clear direction
		push	bp
		aas				; Ascii adjust
		add	[si],cl
		inc	word ptr [bp+di]
		jmp	dword ptr data_802A[bx+si]	;*
		db	 02h, 80h, 02h, 00h, 00h, 00h
		db	 00h, 80h, 02h, 80h, 02h,0A8h
		db	 2Ah, 79h, 08h, 02h, 01h, 02h
		db	 01h, 02h, 01h, 02h, 01h, 02h
		db	 03h, 04h, 03h, 04h, 03h, 04h
		db	 03h, 04h, 08h, 01h
		db	8 dup (5)
		db	 03h, 02h, 06h, 07h, 08h, 09h
		db	 0Ah, 0Bh, 05h, 06h, 0Ch, 0Dh
		db	 0Dh, 0Dh, 0Eh, 0Fh, 10h, 10h
		db	 10h, 11h, 0Fh, 10h, 10h, 10h
		db	 11h, 12h, 14h, 14h, 14h, 13h
		db	 00h, 00h, 15h, 00h, 00h, 00h
		db	 00h, 16h, 00h, 00h, 02h, 07h
		db	 20h, 20h, 1Ch, 1Dh, 1Eh, 1Fh
		db	 20h, 20h, 1Ch, 1Dh, 1Eh, 1Fh
		db	 05h, 05h, 02h, 01h,0FEh,0FDh
		db	 03h, 03h, 0Ch, 0Dh, 0Eh, 00h
		db	 15h, 00h, 00h, 19h, 16h, 03h
		db	 03h, 0Ch, 0Dh, 0Eh, 00h, 15h
		db	 00h, 16h, 1Bh, 00h, 08h, 01h
		db	8 dup (0FCh)
		db	8, 4
		db	7 dup (0Dh)
		db	 0Eh, 10h, 10h, 17h, 17h, 17h
		db	 10h, 10h, 11h, 10h, 10h, 17h
		db	 17h, 17h, 10h, 10h, 11h, 14h
		db	 14h, 14h, 14h, 14h, 14h, 14h
		db	 13h, 06h, 03h, 00h, 00h, 00h
		db	 00h, 00h, 1Ah, 00h, 00h, 00h
		db	 00h, 00h, 1Ah, 18h, 18h, 18h
		db	 18h, 18h, 21h, 0Dh, 02h, 1Ah
		db	 00h, 23h, 00h, 00h, 00h, 23h
		db	 00h, 00h, 00h, 23h, 00h, 1Ah
		db	 24h, 18h, 22h, 18h, 18h, 18h
		db	 22h, 18h, 18h, 18h, 22h, 18h
		db	 21h, 04h, 04h, 0Ch, 0Dh, 0Dh
		db	 0Eh, 0Fh, 10h, 10h, 11h, 12h
		db	 14h, 14h, 13h, 00h, 26h, 25h
		db	 00h, 05h, 07h, 27h, 10h, 10h
		db	 10h, 29h, 28h, 10h, 10h, 10h
		db	 2Ch, 28h, 17h, 17h, 17h, 2Ch
		db	 28h, 17h, 17h, 17h, 2Ch, 28h
		db	 17h, 17h, 17h, 2Ch, 28h, 10h
		db	 10h, 10h, 2Ch, 2Ah, 14h, 14h
		db	 14h, 2Bh, 01h, 07h
		db	7 dup (1Ah)
		db	2, 1, 5, 5, 2
		db	8, '-.-.-.-.-.-.-.-.'
		db	 06h, 01h,0F5h,0F5h,0F5h,0F5h
		db	0F5h,0F5h, 06h, 02h
		db	'-.-.-.-.-.-.'
		db	 05h, 04h, 28h, 10h, 10h, 10h
		db	 2Ch, 28h, 17h, 17h, 17h, 2Ch
		db	 28h, 10h, 10h, 10h, 2Ch, 2Ah
		db	 14h, 14h, 14h, 2Bh, 06h, 04h
		db	 0Ch, 0Dh, 0Dh, 0Dh, 0Dh, 0Dh
		db	 0Fh, 10h, 10h, 10h, 10h, 10h
		db	 0Fh, 10h, 17h, 17h, 17h, 10h
		db	 12h, 14h, 14h, 14h, 14h, 14h
		db	 08h, 01h, 18h
		db	7 dup (18h)
		db	 01h, 06h, 05h, 05h, 05h, 05h
		db	 05h, 05h, 0Ah, 02h, 2Fh, 30h
		db	 31h, 10h, 10h, 2Fh, 30h, 31h
		db	 10h, 10h, 32h, 33h, 34h, 10h
		db	 10h, 32h, 33h, 34h, 10h, 10h
		db	 08h, 01h
		db	8 dup (35h)
		db	 02h, 02h, 05h, 05h, 2Dh, 2Eh
		db	 02h
		db	8, '6789678967896789'
		db	 01h, 02h, 05h, 05h, 01h, 01h
		db	 00h, 0Ah, 03h
		db	'=>>>>>>>>?'
		db	0
		db	'=>>>>>>?'
		db	 00h, 00h, 00h, 00h, 3Dh, 3Eh
		db	 3Eh, 3Fh, 00h, 00h, 00h, 03h
		db	 03h, 0Ch, 0Dh, 0Eh, 12h, 14h
		db	 13h, 00h, 40h, 00h, 04h, 02h
		db	 3Dh, 3Eh, 3Eh, 3Fh, 00h, 3Dh
		db	 3Fh, 00h, 08h, 02h, 1Ah
		db	7 dup (0)
		db	 24h, 18h, 18h, 18h, 18h, 18h
		db	 18h, 18h, 0Bh, 03h
		db	27h
		db	9 dup (41h)
		db	 29h, 28h, 10h, 17h, 17h, 17h
		db	 17h, 17h, 17h, 17h, 10h, 2Ch
		db	 2Ah, 10h
		db	8 dup (10h)
		db	 2Bh, 08h, 02h
		db	'BCBCBCBCDEDEDEDE', 8
		db	1
		db	8 dup (46h)
		db	 02h, 07h, 0Ch, 0Eh, 0Ch, 0Eh
		db	 0Ch, 0Eh, 0Ch, 0Eh, 0Ch, 0Eh
		db	 0Ch, 0Eh, 0Ch, 0Eh, 04h, 03h
		db	'GHIJKLMN'
		db	 00h, 50h, 51h, 00h, 03h, 02h
		db	 58h, 57h, 53h, 54h, 56h, 55h
		db	 04h, 03h, 27h, 10h, 10h, 29h
		db	 28h, 17h, 17h, 2Ch, 2Ah, 10h
		db	 10h, 2Bh, 08h, 03h, 00h, 00h
		db	 58h, 57h, 53h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 5Dh, 00h, 00h
		db	 00h, 00h
		db	'_\YYYZ^`'
		db	2
		db	8, 'abababababababab', 9
		db	 02h,0FAh,0F9h,0F8h,0FAh,0F9h
		db	0F8h,0FAh,0F9h,0F8h
		db	'cddcddcdd', 8
		db	1
		db	8 dup (67h)
		db	1, 1, 0, 2, 7
		db	'hihihihihihihi'
		db	 05h, 05h, 6Ah, 6Bh, 00h, 00h
		db	 00h, 00h, 6Ah, 6Bh, 00h, 00h
		db	 00h, 00h, 6Ah, 6Bh, 00h, 00h
		db	 00h, 00h, 6Ah, 6Bh, 00h, 00h
		db	 00h, 00h, 6Ah, 05h, 05h, 00h
		db	 00h, 00h, 6Ch, 6Dh, 00h, 00h
		db	 6Ch, 6Dh, 00h, 00h, 6Ch, 6Dh
		db	 00h, 00h, 6Ch, 6Dh, 00h, 00h
		db	 00h, 6Dh, 00h, 00h, 00h, 00h
		db	 04h, 02h,0F8h,0FAh,0F9h,0F8h
		db	 64h, 63h, 64h, 64h, 08h, 01h
		db	8 dup (6Eh)
		db	 01h, 02h, 15h, 15h, 02h, 02h
		db	 10h, 10h, 10h, 10h, 08h, 02h
		db	0FAh,0F9h,0F8h,0FAh,0F9h,0F8h
		db	0FAh,0F9h
		db	'cddcddcd', 9
		db	 02h, 6Fh
loc_6C66:
		outsw				; Out [si] to port dx
		jo	loc_6CD8		; Jump if overflow=1
		outsw				; Out [si] to port dx
		jo	loc_6CDB		; Jump if overflow=1
		outsw				; Out [si] to port dx
		jo	loc_6C66		; Jump if overflow=1
		idiv	bl			; al, ah rem = ax/reg
		div	si			; ax,dx rem=dx:ax/reg
		sti				; Enable interrupts
		div	si			; ax,dx rem=dx:ax/reg
		sti				; Enable interrupts
		or	[bp+si],al
		jc	loc_6CED		; Jump if carry Set
;*		jc	loc_6CEF		;*Jump if carry Set
		db	 72h, 72h		;  Fixup - byte match
		jc	loc_6CF1		; Jump if carry Set
		jc	loc_6CF3		; Jump if carry Set
;*		jno	loc_6CF4		;*Jump if not overflw
		db	 71h, 71h		;  Fixup - byte match
;*		jno	loc_6CF6		;*Jump if not overflw
		db	 71h, 71h		;  Fixup - byte match
;*		jno	loc_6CF8		;*Jump if not overflw
		db	 71h, 71h		;  Fixup - byte match
;*		jno	loc_6CFA		;*Jump if not overflw
		db	 71h, 71h		;  Fixup - byte match
		add	al,[bp+si]
		outsw				; Out [si] to port dx
		outsw				; Out [si] to port dx
		div	si			; ax,dx rem=dx:ax/reg
		add	al,[si]
		jnc	loc_6D07		; Jump if carry=0
		jnz	loc_6D0B		; Jump if not zero
;*		js	loc_6D0E		;*Jump if sign=1
		db	 78h, 77h		;  Fixup - byte match
		jns	loc_6D13		; Jump if not sign
		add	al,[bx+di]
		idiv	bx			; ax,dx rem=dx:ax/reg
		or	[bx+di],al
		jnp	loc_6D1D		; Jump if not parity
;*		jnp	loc_6D1F		;*Jump if not parity
		db	 7Bh, 7Ch		;  Fixup - byte match
		jnp	loc_6D21		; Jump if not parity
;*		jnp	loc_6D23		;*Jump if not parity
		db	 7Bh, 7Ch		;  Fixup - byte match
		or	[bp+si],al
;*		jge	loc_6D29		;*Jump if > or =
		db	 7Dh, 7Eh		;  Fixup - byte match
		cmp	word ptr [bx+7Dh],7Eh
;*		cmp	word ptr [bx-80h],0FF81h
		db	 83h, 7Fh, 80h, 81h	;  Fixup - byte match
		test	al,ss:data_8180[bp+si]
		test	al,byte ptr ss:[206h][bp+si]
		cmp	word ptr [bx+7Dh],7Eh
;*		cmp	word ptr [bx-7Ch],0FF82h
		db	 83h, 7Fh, 84h, 82h	;  Fixup - byte match
		add	byte ptr data_8284[bx+di],2
		or	[di+7Fh],bh
		add	byte ptr ss:data_7F7D[bp+si],80h
;*		cmp	byte ptr [di+7Fh],80h
		db	 82h, 7Dh, 7Fh, 80h	;  Fixup - byte match
;*		cmp	byte ptr [di+7Fh],80h
		db	 82h, 7Dh, 7Fh, 80h	;  Fixup - byte match
loc_6CD8:
;*		add	byte ptr [si],4
		db	 82h, 04h, 04h		;  Fixup - byte match
loc_6CDB:
		sbb	al,[bx+si]
		add	[bx+si],al
		sbb	al,[bx+si]
		add	[bx+si],al
		sbb	al,[bx+si]
		add	[bx+si],al
		and	al,18h
		sbb	[bx+si],bl
		add	[si],ax
loc_6CED:
		test	ax,data_8685[di]
loc_6CF1:
		add	[si],ax
loc_6CF3:
		mov	byte ptr data_8788[bx+si],cl
		or	[bx+di],al
		jl	loc_6D76		; Jump if <
		jl	$+7Dh			; Jump if <
		jl	loc_6D7A		; Jump if <
;*		jl	loc_6D7C		;*Jump if <
		db	 7Ch, 7Bh		;  Fixup - byte match
		add	al,2
		xchg	bp,ax
		nop
		xchg	cx,ax
		xchg	sp,ax
loc_6D07:
		add	ss:data_0093_e[bp+si],dl
loc_6D0B:
		add	al,ds:data_008E_e
		mov	es,[bx+si]
		pop	word ptr [bx+si]
loc_6D13:
		pop	word ptr [bx+si]
		lea	cx,cs:[8A00h][bx+di]	; Load effective addr
		add	al,data_8E00
loc_6D1D:
		add	ss:data_8F00[bp],cl
loc_6D21:
		add	data_8D8B[bx],cl
		mov	[bx+si],es
		push	es
		add	[si],cx
		or	ax,0D0Dh
		or	ax,10Eh
		add	cx,data_8788[bx+si]
		or	[bx+di],al
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		add	cl,[bx+si]
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		xchg	di,ax
		cbw				; Convrt byte to word
		or	[bp+si],al
		cwd				; Word to double word
		cwd				; Word to double word
		cwd				; Word to double word
		cwd				; Word to double word
		cwd				; Word to double word
		cwd				; Word to double word
		cwd				; Word to double word
		cwd				; Word to double word
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		xchg	si,ax
		add	ax,[bp+di]
		add	data_9D00[bx+si],ah
		sahf				; Store ah into flags
		lahf				; Load ah from flags
;*		call	far ptr s_0605_9C9B	;*
		db	9Ah
		dw	9C9Bh, 605h		;  Fixup - byte match
		mov	es,[bx+si]
		mov	es,[bx+si]
		db	 8Eh, 8Eh, 00h
loc_6D76:
		pop	word ptr [bx+si]
		db	 8Eh, 8Fh
loc_6D7A:
		add	data_8F00[bx],cl
		lea	ax,[bx+si]		; Load effective addr
		pop	word ptr [bx+si]
		lea	ax,[bx+si]		; Load effective addr
		lea	cx,cs:[8Dh][bx]		; Load effective addr
		add	ss:data_A1A2[bp+di],ah
		add	[bx+si],cl
		add	al,data_7B7C[di]
;*		jnp	loc_6DA0		;*Jump if not parity
		db	 7Bh, 0Ch		;  Fixup - byte match
		push	cs
		jnp	loc_6E13		; Jump if not parity
		xchg	[bp+di+7Ch],bh
;*		jnp	loc_6D23		;*Jump if not parity
		db	 7Bh, 87h		;  Fixup - byte match
		xchg	[si+7Bh],bh
		or	[bp+si],al
		pop	ss
		pop	ss
;*		jnp	loc_6E21		;*Jump if not parity
		db	 7Bh, 7Ch		;  Fixup - byte match
;*		jnp	loc_6E22		;*Jump if not parity
		db	 7Bh, 7Bh		;  Fixup - byte match
;*		jnp	loc_6E25		;*Jump if not parity
		db	 7Bh, 7Ch		;  Fixup - byte match
		jnp	loc_6E27		; Jump if not parity
		jnp	loc_6DC1		; Jump if not parity
		adc	al,7Bh			; '{'
		jl	loc_6E2C		; Jump if <
		add	al,2
		jge	loc_6E33		; Jump if > or =
;*		cmp	word ptr [bx-80h],0FF81h
		db	 83h, 7Fh, 80h, 81h	;  Fixup - byte match
		test	al,ss:d_0000_0201_e[bp+si]
;*		jge	loc_6D3F		;*Jump if > or =
		db	 7Dh, 80h		;  Fixup - byte match
		or	[bp+si],al
loc_6DC1:
		movsb				; Mov [si] to es:[di]
		cmpsw				; Cmp [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		cmpsw				; Cmp [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		cmpsw				; Cmp [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		cmpsw				; Cmp [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		cmpsb				; Cmp [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		cmpsb				; Cmp [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		cmpsb				; Cmp [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		cmpsb				; Cmp [si] to es:[di]
		push	es
;*		add	sp,di
		db	 01h,0FCh		;  Fixup - byte match
		cld				; Clear direction
		cld				; Clear direction
		cld				; Clear direction
		cld				; Clear direction
		cld				; Clear direction
		or	[bp+si],al
		test	al,0A9h
		test	ax,0A8AAh
		test	ax,0AAA9h
		stosw				; Store ax to es:[di]
		lodsb				; String [si] to al
		lodsb				; String [si] to al
		lodsw				; String [si] to ax
		stosw				; Store ax to es:[di]
		lodsb				; String [si] to al
		lodsb				; String [si] to al
		lodsw				; String [si] to ax
		add	al,[bp+di]
		pop	ax
		push	bx
		js	$+79h			; Jump if sign=1
;*		jns	loc_6E6D		;*Jump if not sign
		db	 79h, 7Ah		;  Fixup - byte match
		or	[bp+si],al
		and	[si],bl
		sbb	ax,2020h
		sbb	al,1Dh
		and	[bx+si],ah
		push	ds
		pop	ds
		and	[bx+si],ah
		push	ds
		pop	ds
		and	[bx+di],cl
		add	ch,ss:d_0000_B0AF_e[bp]
		scasb				; Scan es:[di] for al
		scasw				; Scan es:[di] for ax
		mov	al,0AEh
		scasw				; Scan es:[di] for ax
		mov	al,0B1h
		mov	dl,0B3h
loc_6E13:
		mov	cl,0B2h
		mov	bl,0B1h
		mov	dl,0B3h
		or	al,[bp+si]
		test	al,0A9h
		test	ax,0A9A9h
		test	ax,0A9A9h
		test	ax,0ABAAh
		lodsb				; String [si] to al
loc_6E27:
		lodsb				; String [si] to al
		lodsb				; String [si] to al
		lodsb				; String [si] to al
		lodsb				; String [si] to al
		lodsb				; String [si] to al
loc_6E2C:
		lodsb				; String [si] to al
		lodsb				; String [si] to al
		lodsw				; String [si] to ax
		or	[bp+si],al
		mov	ah,0B5h
loc_6E33:
		mov	dh,0B7h
		mov	ah,0B5h
		mov	dh,0B7h
		mov	ax,0BAB9h
		mov	bx,offset data_B9B8
		mov	dx,4BBh
		add	al,0
		retn
			                        ;* No entry point to code
		enter	0BC00h,0BDh		; Procedure entry
		mov	si,4FBFh
		rol	dx,52h			; 'R' Rotate
		db	0C4h,0C5h,0C6h,0C7h, 06h, 02h
		db	0AEh,0AFh,0AFh,0AFh,0AFh,0B0h
		db	0B1h,0B2h,0B2h,0B2h,0B2h,0B3h
		db	 08h, 06h
		db	':;:;:'
		db	';:;;<'
loc_6E6D:
		db	';<;e<e:;:;:;:;<e<e;e<e:;:;:;:;;e'
		db	'<e;e<e', 8
		db	 02h, 66h,0C9h, 66h,0C9h, 66h
		db	0C9h, 66h,0C9h
		db	':;;<:;<;'
		db	 02h, 02h, 0Ch, 0Eh, 0Ch, 0Eh
		db	 06h, 05h, 00h, 00h,0CAh,0CDh
		db	 00h, 00h, 00h,0CBh,0D5h,0D1h
		db	0CEh, 00h, 00h,0CCh,0D7h,0D0h
		db	0CFh, 00h,0D6h,0D4h,0D8h,0D0h
		db	0D2h,0D3h,0D9h,0D9h,0D0h,0D0h
		db	0D0h,0D2h, 08h, 06h, 00h, 00h
		db	 00h,0CAh,0CDh, 00h, 00h, 00h
		db	 00h, 00h,0CBh,0D5h,0D1h,0CEh
		db	 00h, 00h, 00h, 00h,0CCh,0D0h
		db	0D0h,0CFh, 00h, 00h, 00h,0D6h
		db	0D4h,0D7h,0D0h,0D2h,0D3h, 00h
		db	0CBh,0D4h,0D5h,0D8h,0D0h,0D0h
		db	0D2h,0D3h,0CCh,0D9h,0DAh,0D0h
		db	0D0h,0D8h,0D0h,0D2h, 04h, 02h
		db	0DBh,0DCh,0DCh,0DDh,0D0h,0D0h
		db	0D0h,0D0h, 07h, 02h,0DBh,0DEh
		db	 00h, 00h, 00h,0E0h,0DDh,0D0h
		db	0D0h,0DFh,0DFh,0DFh,0D0h,0D0h
		db	 06h, 02h, 00h, 00h,0CAh,0CDh
		db	 00h, 00h,0E0h,0DDh,0D0h,0D0h
		db	0DBh,0DEh, 09h, 04h, 00h, 00h
		db	 00h,0E0h,0DDh,0DBh,0DEh, 00h
		db	 00h, 00h, 00h,0CBh,0D7h,0D0h
		db	0D0h,0D1h,0CEh, 00h, 00h, 00h
		db	0CCh,0D5h,0E1h,0D0h,0D0h,0CFh
		db	 00h,0E0h,0DDh,0D7h,0D4h,0D0h
		db	0E1h,0D0h,0D1h,0D3h, 07h, 03h
		db	 00h, 00h,0CBh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0CCh,0CDh,0E0h
		db	0DDh,0CEh,0E0h,0DDh,0E1h,0D0h
		db	0D0h,0D2h,0D3h, 0Ch, 04h, 00h
		db	 00h, 00h, 00h, 00h,0E0h,0DDh
		db	0CDh, 00h
		db	7 dup (0)
		db	0CAh,0E1h,0D0h,0D0h,0DBh,0DEh
		db	 00h, 00h, 00h, 00h,0E0h,0DDh
		db	0D7h,0D0h,0D0h,0E1h,0D0h,0D2h
		db	0D3h, 00h,0E0h,0DDh,0DAh,0D0h
		db	0E1h,0D0h,0D0h,0D0h,0D0h,0D0h
		db	0D2h,0D3h, 06h, 02h,0E8h,0E2h
		db	0E3h,0E4h,0E5h,0E6h,0E9h,0DAh
		db	0E1h,0D0h,0D2h,0E7h, 04h, 02h
		db	0E8h,0E2h,0E5h,0E6h,0E9h,0DAh
		db	0D0h,0E7h, 05h, 02h,0E8h,0E2h
		db	0E4h,0E5h,0E6h,0E9h,0DAh,0E1h
		db	0D0h,0E7h, 0Ah, 04h, 00h, 00h
		db	 00h, 00h, 00h,0CAh,0CEh
		db	7 dup (0)
		db	0CAh,0E1h,0CFh, 00h, 00h, 00h
		db	 00h, 00h,0E0h,0DDh,0D7h,0D0h
		db	0D1h,0DBh,0DEh, 00h,0E0h,0DDh
		db	0DAh,0D0h,0E1h,0D0h,0D0h,0D0h
		db	0D2h,0D3h, 05h, 01h,0D0h,0D0h
		db	0D0h,0D0h,0D0h, 08h, 02h
		db	16 dup (0D0h)
		db	 06h, 01h,0D0h,0D0h,0D0h,0D0h
		db	0D0h,0D0h, 05h, 01h,0DFh,0DFh
		db	0DFh,0DFh,0DFh, 03h, 02h,0CDh
		db	 00h, 00h,0D0h,0DBh,0DEh, 01h
		db	 02h,0EAh,0EBh, 01h, 02h,0EAh
		db	0EDh, 01h, 02h,0ECh,0EDh, 01h
		db	 01h,0D2h, 03h, 03h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0EEh,0EFh
		db	0F0h, 03h, 02h, 00h, 00h,0CAh
		db	0E0h,0DDh,0D0h, 02h, 01h,0C3h
		db	0C8h, 06h, 02h, 00h, 00h,0FAh
		db	0F8h, 00h, 00h, 27h, 10h, 10h
		db	 10h, 10h, 29h, 0Eh, 04h, 00h
		db	27h
		db	10 dup (10h)
		db	 29h, 00h,0BCh,0BDh, 10h
		db	9 dup (10h)
		db	0BEh,0BFh, 4Fh,0C1h, 10h,0C0h
		db	7 dup (0C0h)
		db	 10h,0C2h, 52h,0C4h,0C5h, 10h
		db	9 dup (10h)
		db	0C6h,0C7h, 01h, 01h, 00h, 03h
		db	 04h, 00h, 8Eh, 00h, 00h, 8Fh
		db	 00h, 00h, 8Fh, 00h,0A3h,0A2h
		db	0A1h, 03h, 01h, 00h, 42h, 00h
		db	 93h, 00h,0CCh, 00h, 05h, 01h
		db	 46h, 01h, 8Fh, 01h,0D4h, 01h
		db	 21h, 02h, 5Ah, 02h,0A3h, 02h
		db	0E0h, 02h, 25h, 03h, 66h, 03h
		db	0B7h, 03h,0FCh, 03h, 41h, 04h
		db	 86h, 04h,0C3h, 04h, 08h, 05h
		db	 49h, 05h, 82h, 05h,0D3h, 05h
		db	 18h, 06h, 65h, 06h,0AAh, 06h
		db	0FBh, 06h, 3Ch, 07h, 89h, 07h
		db	0EAh, 07h, 2Fh, 08h, 80h, 08h
		db	0D9h, 08h, 06h, 09h, 63h, 09h
		db	0BCh, 09h, 11h, 0Ah, 5Eh, 0Ah
		db	0ABh, 0Ah, 08h, 0Bh, 49h, 0Bh
		db	 8Eh, 0Bh,0FBh, 0Bh, 58h, 0Ch
		db	0A9h, 0Ch, 0Eh, 0Dh, 6Bh, 0Dh
		db	0BCh, 0Dh, 21h, 0Eh, 6Eh, 0Eh
		db	0C7h, 0Eh, 08h, 0Fh, 55h, 0Fh
		db	0A6h, 0Fh,0F7h, 0Fh
		db	48h
loc_7101:
		adc	data_CA10[di],cl
		adc	[bx],cl
loc_7107:
		adc	[si+11h],bx
		movsw				; Mov [si] to es:[di]
;*		adc	si,di
		db	 11h,0FEh		;  Fixup - byte match
loc_710D:
		adc	[bp+di+12h],si
		les	dx,dword ptr [bp+si]	; Load seg:offset ptr
		or	[bp+di],dx
		adc	bp,word ptr ds:[413h][bp+di]
		adc	al,59h			; 'Y'
		adc	al,0A2h
		adc	al,0EBh
loc_711F:
		adc	al,4
loc_7121:
		adc	ax,152Dh
;*		adc	byte ptr [di],0EFh
		db	 82h, 15h,0EFh		;  Fixup - byte match
		adc	ax,1650h
;*		lea	dx,cs:[16DEh]		; Load effective addr
		db	 8Dh, 16h,0DEh, 16h	;  Fixup - byte match
		db	0Fh
loc_712F:
		pop	ss
		push	sp
		pop	ss
		lodsw				; String [si] to ax
		pop	ss
		out	17h,al			; port 17h ??i/o non-standard
		xor	bx,[bx+si]
;*		jl	loc_7152		;*Jump if <
		db	 7Ch, 18h		;  Fixup - byte match
		mov	cx,0EA18h
		sbb	[bp+di],bh
		sbb	data_C919[si],cx
		sbb	[bp+si],cx
loc_7145:
		sbb	al,[bp+di+1Ah]
;*		jo	loc_7164		;*Jump if overflow=1
		db	 70h, 1Ah		;  Fixup - byte match
		cmpsb				; Cmp [si] to es:[di]
loc_714B:
		jno	loc_7101		; Jump if not overflw
		jno	loc_7107		; Jump if not overflw
;*		jno	loc_710F		;*Jump if not overflw
		db	 71h,0BEh		;  Fixup - byte match
loc_7151:
;*		jno	loc_7117		;*Jump if not overflw
		db	 71h,0C4h		;  Fixup - byte match
		jno	loc_711F		; Jump if not overflw
loc_7155:
;*		jno	loc_7129		;*Jump if not overflw
		db	 71h,0D2h		;  Fixup - byte match
loc_7157:
		jno	loc_712F		; Jump if not overflw
;*		jno	loc_7137		;*Jump if not overflw
		db	 71h,0DCh		;  Fixup - byte match
;*		jno	loc_7141		;*Jump if not overflw
		db	 71h,0E4h		;  Fixup - byte match
		jno	loc_714B		; Jump if not overflw
loc_715F:
		jno	loc_7155		; Jump if not overflw
loc_7161:
		jno	loc_715F		; Jump if not overflw
		jno	loc_7165		; Jump if not overflw
loc_7165:
		jc	loc_716D		; Jump if carry Set
		jc	loc_7173		; Jump if carry Set
loc_7169:
		jc	loc_7179		; Jump if carry Set
		jc	loc_717F		; Jump if carry Set
loc_716D:
		jc	loc_7185		; Jump if carry Set
		jc	loc_718B		; Jump if carry Set
		jc	loc_7195		; Jump if carry Set
loc_7173:
		jc	loc_719B		; Jump if carry Set
		jc	loc_719F		; Jump if carry Set
;*		jc	loc_71A9		;*Jump if carry Set
		db	 72h, 30h		;  Fixup - byte match
loc_7179:
;*		jc	loc_71B3		;*Jump if carry Set
		db	 72h, 38h		;  Fixup - byte match
;*		jc	loc_71BD		;*Jump if carry Set
		db	 72h, 40h		;  Fixup - byte match
;*		jc	loc_71CB		;*Jump if carry Set
		db	 72h, 4Ch		;  Fixup - byte match
loc_717F:
;*		jc	loc_7125		;*Jump if carry Set
		db	 72h,0A4h		;  Fixup - byte match
		jc	loc_71D3		; Jump if carry Set
		jc	loc_71DD		; Jump if carry Set
loc_7185:
;*		jc	loc_71E7		;*Jump if carry Set
		db	 72h, 60h		;  Fixup - byte match
		jc	loc_71F5		; Jump if carry Set
		jc	loc_71FF		; Jump if carry Set
loc_718B:
		jc	loc_710D		; Jump if carry Set
;*		jc	loc_7117		;*Jump if carry Set
		db	 72h, 88h		;  Fixup - byte match
		jc	loc_7121		; Jump if carry Set
;*		jc	loc_7123		;*Jump if carry Set
		db	 72h, 90h		;  Fixup - byte match
;*		jc	loc_712D		;*Jump if carry Set
		db	 72h, 98h		;  Fixup - byte match
loc_7195:
;*		jc	loc_713B		;*Jump if carry Set
		db	 72h,0A4h		;  Fixup - byte match
		jc	loc_7145		; Jump if carry Set
		jc	loc_714B		; Jump if carry Set
loc_719B:
		jc	loc_7151		; Jump if carry Set
		jc	loc_7157		; Jump if carry Set
loc_719F:
		jc	loc_7161		; Jump if carry Set
		jc	loc_7165		; Jump if carry Set
		jc	loc_7169		; Jump if carry Set
;*		jc	loc_71B3		;*Jump if carry Set
		db	 72h, 0Ch		;  Fixup - byte match
		mov	[bp-78h],ch
		ror	data_8932[bx+si],1	; Rotate
		xchg	sp,ax
;*		mov	si,si
		db	 89h,0F6h		;  Fixup - byte match
		mov	[bx+si-76h],bx
		mov	dx,5C8Ah
		mov	cx,[bx+si-73h]
		mov	cl,data_8DCC[di]
		add	al,95h
		inc	si
		xchg	bp,ax
		mov	data_922E[di],dl
;*		jo	loc_715A		;*Jump if overflow=1
		db	 70h, 92h		;  Fixup - byte match
		mov	dl,92h
		push	0AA91h
		xchg	cx,ax
		in	al,dx			; port 5C92h ??i/o non-standard
		xchg	cx,ax
		stosb				; Store al to es:[di]
		xchg	cx,ax
		pushf				; Push flags
loc_71D3:
		lahf				; Load ah from flags
		mov	si,data_F49F_e
		xchg	dx,ax
		db	 36h, 93h, 78h, 93h,0CAh
loc_71DD:
		xchg	bp,ax
		or	al,96h
		dec	si
		xchg	si,ax
		nop
		xchg	si,ax
		inc	si
		xchg	data_CA87[bx+si],cx
		xchg	ds:data_FE87_e[bx+si],cx
		mov	ax,[bx+si-74h]
;*		or	byte ptr data_8C40[si],3Eh	; '>'
		db	 82h, 8Ch, 40h, 8Ch, 3Eh	;  Fixup - byte match
loc_71F5:
		xchg	data_C286[bx+si],al
		xchg	[si],al
		xchg	ss:d_0000_FC93_e[bp+si],di
loc_71FF:
		xchg	bx,ax
		retn	4A4h
			                        ;* No entry point to code
		movsw				; Mov [si] to es:[di]
		inc	si
		movsw				; Mov [si] to es:[di]
		les	cx,dword ptr data_8D06[si]	; Load seg:offset ptr
		dec	sp
;*		call	far ptr s_8ED4_9A8E	;*
		db	9Ah
		dw	9A8Eh, 8ED4h		;  Fixup - byte match
		push	ss
		db	 8Fh,0F8h,0A0h, 12h,0A1h, 2Ch
		db	0A1h, 4Ah,0A1h, 0Eh, 8Eh, 50h
		db	 8Eh, 92h, 8Eh, 50h, 8Eh,0E4h
		db	 90h, 26h, 91h,0D2h, 96h, 44h
		db	 99h, 86h, 99h,0C8h, 99h, 0Ah
		db	 9Ah, 88h, 9Ch,0EAh, 9Ch, 4Ch
		db	 9Dh,0AEh, 9Dh,0B8h, 97h,0FAh
		db	 97h, 3Ch, 98h, 7Eh, 98h, 58h
		db	 8Fh, 9Ah, 8Fh,0DCh, 8Fh, 1Eh
		db	 90h, 60h, 90h,0A2h, 90h,0C0h
		db	 98h, 02h, 99h,0E0h, 9Fh, 22h
		db	0A0h, 64h,0A0h, 22h,0A0h, 3Eh
		db	 94h, 80h, 94h,0C2h, 94h, 80h
		db	 94h, 68h,0A1h,0AAh,0A1h,0ECh
		db	0A1h, 2Eh,0A2h, 70h,0A2h,0B2h
		db	0A2h,0BAh,0A3h,0FCh,0A3h, 3Eh
		db	0A4h, 80h,0A4h, 88h,0A5h,0CAh
		db	0A5h, 0Ch,0A6h, 4Eh,0A6h, 90h
		db	0A6h, 88h,0A5h, 36h, 85h, 78h
		db	 85h,0BAh, 85h,0FCh, 85h,0D8h
		db	0A6h, 1Ah,0A7h, 5Ch,0A7h, 9Eh
		db	0A7h, 52h,0AEh, 94h,0AEh,0D6h
		db	0AEh, 18h,0AFh, 10h, 9Eh, 52h
		db	 9Eh, 94h, 9Eh,0D6h, 9Eh, 18h
		db	 9Fh, 5Ah, 9Fh,0D0h, 9Ah, 12h
		db	 9Bh, 54h, 9Bh, 96h, 9Bh, 34h
		db	 97h, 76h, 97h, 30h, 9Ch, 5Ch
		db	 9Ch,0D8h, 9Bh, 04h, 9Ch,0F4h
		db	0A2h, 36h,0A3h, 78h,0A3h, 36h
		db	0A3h,0D2h,0A6h,0A6h,0A0h, 5Ah
		db	0AFh, 06h,0D3h, 72h, 06h,0D3h
		db	 72h, 06h,0D3h, 72h, 06h,0D3h
		db	 72h, 08h, 02h, 90h, 01h, 02h
		db	 00h, 02h, 20h, 03h, 02h, 00h
		db	 02h,0C8h, 00h, 02h, 00h, 02h
		db	 90h, 01h, 02h, 00h, 02h, 40h
		db	 06h, 02h, 00h, 08h, 00h, 0Ch
		db	 01h, 46h, 73h, 02h, 64h, 00h
		db	 0Fh, 00h, 08h, 0Ch, 01h, 42h
		db	 73h, 02h, 90h, 01h, 0Ah, 00h
		db	 02h,0F4h, 01h, 0Ah, 00h, 02h
		db	 58h, 02h, 0Ah, 00h, 08h, 0Ch
		db	 01h, 46h, 73h, 02h, 10h, 27h
		db	 40h, 00h, 08h, 02h, 10h, 27h
		db	0E8h, 03h, 0Ah, 16h, 73h, 0Ch
		db	 01h, 48h, 73h, 02h, 90h, 01h
		db	 14h, 00h, 08h, 0Ch, 01h, 43h
		db	 73h, 02h, 64h, 00h, 05h, 00h
		db	 08h, 0Ch, 01h, 46h, 73h, 02h
		db	0E8h, 03h, 05h, 00h, 08h, 02h
		db	 30h, 75h, 02h, 00h, 08h, 81h
		db	0ECh, 28h, 80h, 7Fh, 80h, 28h
		db	0B0h, 1Eh,0C4h, 28h,0ECh, 1Eh
		db	0CEh, 14h,0CEh, 32h,0ECh, 32h
		db	0ECh, 0Ah,0E2h, 3Ch, 80h
data_735A	db	0Ch
		db	 01h,0CFh, 76h, 06h, 17h, 74h
		db	 06h, 17h, 74h, 04h, 12h, 00h
		db	 06h,0FEh, 74h, 06h,0BDh, 75h
		db	 06h, 3Dh, 76h, 06h, 17h, 74h
		db	 06h, 17h, 74h, 06h,0FEh, 74h
		db	 06h,0FEh, 74h, 06h, 3Dh, 76h
		db	 0Ah, 5Ah, 73h, 02h, 9Fh,0ACh
		db	 04h, 00h, 04h, 02h, 00h, 04h
		db	 0Ch, 00h, 02h, 9Fh,0ACh, 04h
		db	 00h, 04h, 08h, 00h, 04h, 0Ch
		db	 00h, 02h,0BEh, 54h, 04h, 00h
		db	 04h, 02h, 00h, 02h,0BEh, 54h
		db	 04h, 00h, 04h, 02h, 00h, 02h
		db	 9Fh,0ACh, 04h, 00h, 04h, 0Eh
		db	 00h, 02h, 9Fh,0ACh, 04h, 00h
		db	 04h, 02h, 00h, 04h, 06h, 00h
		db	 02h,0BEh, 54h, 04h, 00h, 04h
		db	 02h, 00h, 08h, 04h, 06h, 00h
		db	 02h, 9Fh,0ACh, 04h, 00h, 04h
		db	 0Eh, 00h, 02h, 9Fh,0ACh, 04h
		db	 00h, 04h, 08h, 00h, 04h, 18h
		db	 00h, 08h, 02h,0BEh, 54h, 04h
		db	 00h, 04h, 02h, 00h, 02h, 9Fh
		db	0ACh, 04h, 00h, 04h, 02h, 00h
		db	 04h, 06h, 00h, 02h, 9Fh,0ACh
		db	 04h, 00h, 04h, 02h, 00h, 04h
		db	 06h, 00h, 02h, 9Fh,0ACh, 04h
		db	 00h, 04h, 02h, 00h, 04h, 06h
		db	 00h, 08h, 02h, 89h, 03h, 14h
		db	 00h, 04h, 14h, 00h, 08h, 02h
		db	0C4h, 01h, 04h, 00h, 04h, 02h
		db	 00h, 08h, 04h, 06h, 00h, 02h
		db	 12h, 07h, 0Ah, 00h, 04h, 02h
		db	 00h, 02h, 12h, 07h, 06h, 00h
		db	 02h,0F0h, 07h, 0Ch, 00h, 02h
		db	0E9h, 08h, 0Ch, 00h, 02h,0F0h
		db	 07h, 02h, 00h, 02h, 7Eh, 07h
		db	 02h, 00h, 02h, 12h, 07h, 0Eh
		db	 00h, 02h,0E9h, 08h, 06h, 00h
		db	 04h, 18h, 00h, 04h, 06h, 00h
		db	 02h, 12h, 07h, 0Ah, 00h, 04h
		db	 02h, 00h, 02h, 12h, 07h, 06h
		db	 00h, 02h,0F0h, 07h, 0Ch, 00h
		db	 02h,0E9h, 08h, 0Ch, 00h, 02h
		db	0F0h, 07h, 02h, 00h, 02h, 7Eh
		db	 07h, 02h, 00h, 02h, 12h, 07h
		db	 08h, 00h, 02h, 5Ah, 0Dh, 0Ch
		db	 00h, 02h,0F0h, 07h, 02h, 00h
		db	 02h, 7Eh, 07h, 02h, 00h, 02h
		db	 12h, 07h, 0Eh, 00h, 02h,0E9h
		db	 08h, 06h, 00h, 04h, 06h, 00h
		db	 02h, 12h, 07h, 0Ah, 00h, 04h
		db	 02h, 00h, 02h, 12h, 07h, 06h
		db	 00h, 02h,0F0h, 07h, 0Ch, 00h
		db	 02h,0E9h, 08h, 0Ch, 00h, 02h
		db	0F0h, 07h, 02h, 00h, 02h, 7Eh
		db	 07h, 02h, 00h, 02h, 12h, 07h
		db	 0Eh, 00h, 02h,0E9h, 08h, 06h
		db	 00h, 04h, 18h, 00h, 04h, 06h
		db	 00h, 02h, 12h, 07h, 0Ah, 00h
		db	 04h, 02h, 00h, 02h, 12h, 07h
		db	 06h, 00h, 02h,0F0h, 07h, 0Ch
		db	 00h, 02h,0E9h, 08h, 0Ch, 00h
		db	 02h, 4Bh, 05h, 06h, 00h, 02h
		db	 12h, 07h, 06h, 00h, 02h,0E9h
		db	 08h, 06h, 00h, 02h,0F1h, 05h
		db	 06h, 00h, 02h, 12h, 07h, 06h
		db	 00h, 02h,0E9h, 08h, 06h, 00h
		db	 02h, 74h, 09h, 06h, 00h, 02h
		db	 97h, 0Ah, 06h, 00h, 08h, 02h
		db	 97h, 0Ah, 12h, 00h, 02h, 74h
		db	 09h, 12h, 00h, 02h,0E9h, 08h
		db	 30h, 00h, 02h,0F0h, 07h, 0Ch
		db	 00h, 02h, 74h, 09h, 18h, 00h
		db	 02h,0E3h, 0Bh, 18h, 00h, 02h
		db	 2Ah, 0Eh, 18h, 00h, 02h, 5Ah
		db	 0Dh, 06h, 00h, 02h,0E3h, 0Bh
		db	 0Ch, 00h, 02h, 97h, 0Ah, 2Ah
		db	 00h, 02h,0E3h, 0Bh, 0Ch, 00h
		db	 02h,0E9h, 08h, 10h, 00h, 02h
		db	 97h, 0Ah, 10h, 00h, 02h, 5Ah
		db	 0Dh, 10h, 00h, 02h,0E8h, 0Fh
		db	 1Eh, 00h, 02h,0D3h, 10h, 06h
		db	 00h, 02h,0E8h, 0Fh, 06h, 00h
		db	 02h,0FCh, 0Eh, 06h, 00h, 02h
		db	 2Ah, 0Eh, 30h, 00h, 02h, 97h
		db	 0Ah, 12h, 00h, 02h, 74h, 09h
		db	 12h, 00h, 02h,0E9h, 08h, 30h
		db	 00h, 02h,0F0h, 07h, 0Ch, 00h
		db	 02h, 74h, 09h, 18h, 00h, 02h
		db	0E3h, 0Bh, 18h, 00h, 02h, 2Ah
		db	 0Eh, 18h, 00h, 02h, 5Ah, 0Dh
		db	 06h, 00h, 02h,0E3h, 0Bh, 0Ch
		db	 00h, 02h, 97h, 0Ah, 2Ah, 00h
		db	 02h,0E3h, 0Bh, 0Ch, 00h, 02h
		db	0E9h, 08h, 10h, 00h, 02h, 97h
		db	 0Ah, 10h, 00h, 02h, 5Ah, 0Dh
		db	 10h, 00h, 02h,0E8h, 0Fh, 1Eh
		db	 00h, 02h,0D3h, 10h, 06h, 00h
		db	 02h,0E8h, 0Fh, 06h, 00h, 02h
		db	0FCh, 0Eh, 06h, 00h, 02h, 2Ah
		db	 0Eh, 30h, 00h, 08h, 02h, 97h
		db	 0Ah, 12h, 00h, 02h,0E9h, 08h
		db	 12h, 00h, 02h, 74h, 09h, 0Ah
		db	 00h, 04h, 02h, 00h, 02h, 74h
		db	 09h, 18h, 00h, 02h,0E3h, 0Bh
		db	 18h, 00h, 02h, 97h, 0Ah, 12h
		db	 00h, 02h,0E9h, 08h, 12h, 00h
		db	 02h, 74h, 09h, 0Ah, 00h, 04h
		db	 02h, 00h, 02h, 74h, 09h, 12h
		db	 00h, 02h,0E9h, 08h, 06h, 00h
		db	 02h, 74h, 09h, 18h, 00h, 02h
		db	 97h, 0Ah, 12h, 00h, 02h,0E9h
		db	 08h, 12h, 00h, 02h, 74h, 09h
		db	 0Ah, 00h, 04h, 02h, 00h, 02h
		db	 74h, 09h, 18h, 00h, 02h,0E3h
		db	 0Bh, 18h, 00h, 02h, 97h, 0Ah
		db	 12h, 00h, 02h,0E9h, 08h, 12h
		db	 00h, 02h, 74h, 09h, 0Ah, 00h
		db	 04h, 02h, 00h, 02h, 74h, 09h
		db	 1Eh, 00h, 02h,0E8h, 0Fh, 06h
		db	 00h, 02h,0FCh, 0Eh, 06h, 00h
		db	 02h, 2Ah, 0Eh, 06h, 00h, 08h
		db	 02h, 5Ah, 0Dh, 18h, 00h, 02h
		db	 97h, 0Ah, 18h, 00h, 02h,0E3h
		db	 0Bh, 18h, 00h, 02h, 2Ah, 0Eh
		db	 12h, 00h, 02h,0DBh, 11h, 54h
		db	 00h, 02h,0E8h, 0Fh, 06h, 00h
		db	 02h,0FCh, 0Eh, 06h, 00h, 02h
		db	 2Ah, 0Eh, 06h, 00h, 02h, 5Ah
		db	 0Dh, 18h, 00h, 02h, 97h, 0Ah
		db	 18h, 00h, 02h,0E3h, 0Bh, 18h
		db	 00h, 02h, 2Ah, 0Eh, 12h, 00h
		db	 02h,0DBh, 11h, 54h, 00h, 02h
		db	0E8h, 0Fh, 06h, 00h, 02h,0FCh
		db	 0Eh, 06h, 00h, 02h, 2Ah, 0Eh
		db	 06h, 00h, 02h, 5Ah, 0Dh, 18h
		db	 00h, 02h, 97h, 0Ah, 18h, 00h
		db	 02h,0E3h, 0Bh, 18h, 00h, 02h
		db	 2Ah, 0Eh, 12h, 00h, 02h,0DBh
		db	 11h, 54h, 00h, 02h,0E8h, 0Fh
		db	 06h, 00h, 02h,0FCh, 0Eh, 06h
		db	 00h, 02h, 2Ah, 0Eh, 06h, 00h
		db	 02h, 5Ah, 0Dh, 18h, 00h, 02h
		db	 97h, 0Ah, 18h, 00h, 02h,0E9h
		db	 08h, 12h, 00h, 02h, 74h, 09h
		db	 12h, 00h, 02h, 12h, 07h, 6Ch
		db	 00h, 08h, 81h, 00h, 00h, 00h
		db	 20h, 50h, 00h, 50h, 20h,0A0h
		db	 00h,0A0h, 20h,0F0h, 00h,0F0h
		db	 20h, 40h, 01h, 40h, 21h, 90h
		db	 01h, 90h, 21h,0E0h, 01h,0E0h
		db	 21h, 30h, 02h, 30h, 22h, 80h
		db	 02h, 80h, 22h,0D0h, 02h,0D0h
		db	 22h, 20h, 03h, 20h, 23h, 70h
		db	 03h, 70h, 23h,0C0h, 03h,0C0h
		db	 23h, 10h, 04h, 10h, 24h, 60h
		db	 04h, 60h, 24h,0B0h, 04h,0B0h
		db	 24h, 00h, 05h, 00h, 25h, 50h
		db	 05h, 50h, 25h,0A0h, 05h,0A0h
		db	 25h,0F0h, 05h,0F0h, 25h, 40h
		db	 06h, 40h, 26h, 90h, 06h, 90h
		db	 26h,0E0h, 06h,0E0h, 26h, 30h
		db	 07h, 30h, 27h, 80h, 07h, 80h
		db	 27h,0D0h, 07h,0D0h
		db	27h, ' ', 8, ' (p', 8, 'p('
		db	0C0h, 08h,0C0h, 28h, 10h, 09h
		db	 10h, 29h, 60h, 09h, 60h, 29h
		db	0B0h, 09h,0B0h, 29h, 00h, 0Ah
		db	 00h, 2Ah, 50h, 0Ah, 50h, 2Ah
		db	0A0h, 0Ah,0A0h, 2Ah,0F0h, 0Ah
		db	0F0h, 2Ah, 40h, 0Bh, 40h, 2Bh
		db	 90h, 0Bh, 90h, 2Bh,0E0h, 0Bh
		db	0E0h, 2Bh, 30h, 0Ch, 30h, 2Ch
		db	 80h, 0Ch, 80h, 2Ch,0D0h, 0Ch
		db	0D0h
		db	', ', 0Dh, ' -p', 0Dh, 'p-'
		db	0C0h, 0Dh,0C0h, 2Dh, 10h, 0Eh
		db	 10h, 2Eh, 60h, 0Eh, 60h, 2Eh
		db	0B0h, 0Eh,0B0h, 2Eh, 00h, 0Fh
		db	 00h, 2Fh, 50h, 0Fh, 50h, 2Fh
		db	0A0h, 0Fh,0A0h, 2Fh,0F0h, 0Fh
		db	0F0h, 2Fh, 40h, 10h, 40h, 30h
		db	 90h, 10h, 90h, 30h,0E0h, 10h
		db	0E0h, 30h, 30h, 11h, 30h, 31h
		db	 80h, 11h, 80h, 31h,0D0h, 11h
		db	0D0h, 31h, 20h, 12h, 20h, 32h
		db	 70h, 12h, 70h, 32h,0C0h, 12h
		db	0C0h, 32h, 10h, 13h, 10h, 33h
		db	 60h, 13h, 60h, 33h,0B0h, 13h
		db	0B0h, 33h, 00h, 14h, 00h, 34h
		db	 50h, 14h, 50h, 34h,0A0h, 14h
		db	0A0h, 34h,0F0h, 14h,0F0h, 34h
		db	 40h, 15h, 40h, 35h, 90h, 15h
		db	 90h, 35h,0E0h, 15h,0E0h, 35h
		db	 30h, 16h, 30h, 36h, 80h, 16h
		db	 80h, 36h,0D0h, 16h,0D0h, 36h
		db	 20h, 17h, 20h, 37h, 70h, 17h
		db	 70h, 37h,0C0h, 17h,0C0h
		db	37h
loc_7804:
		adc	[bx+si],bl
		adc	[bx+si],bh
		pusha				; Save all regs
		sbb	[bx+si+38h],ah
		mov	al,18h
		mov	al,38h			; '8'
		add	[bx+di],bl
		add	[bx+di],bh
		push	ax
		sbb	[bx+si+39h],dx
loc_7818:
		mov	al,data_A019
;*		cmp	ax,si
		db	 39h,0F0h		;  Fixup - byte match
;*		sbb	ax,si
		db	 19h,0F0h		;  Fixup - byte match
		cmp	[bx+si+1Ah],ax
		inc	ax
		cmp	dl,data_901A[bx+si]
		cmp	ah,al
		sbb	ah,al
		cmp	dh,[bx+si]
		sbb	si,[bx+si]
		cmp	ax,data_801B[bx+si]
		cmp	dx,ax
		sbb	dx,ax
		cmp	sp,[bx+si]
		sbb	al,20h			; ' '
		cmp	al,70h			; 'p'
		sbb	al,70h			; 'p'
		cmp	al,0C0h
		sbb	al,0C0h
		cmp	al,10h
		sbb	ax,3D10h
		pusha				; Save all regs
		sbb	ax,3D60h
		mov	al,1Dh
loc_784E:
		mov	al,3Dh			; '='
		add	data_3E00,bl
		push	ax
		push	ds
		push	ax
loc_7857:
		db	3Eh
		mov	al,ds:data_A01E
		db	 3Eh,0F0h, 1Eh,0F0h, 3Eh, 05h
loc_7861:
		or	data_3224,dl
		db	 3Eh, 05h, 0Fh, 1Dh, 2Bh
loc_786A:
		aaa				; Ascii adjust
		inc	si
		movsw				; Mov [si] to es:[di]
;*		jns	locloop_7821		;*Jump if not sign
		db	 79h,0B2h		;  Fixup - byte match
;*		jns	loc_7830		;*Jump if not sign
		db	 79h,0BFh		;  Fixup - byte match
;*		jns	loc_784D		;*Jump if not sign
		db	 79h,0DAh		;  Fixup - byte match
		jns	loc_786A		; Jump if not sign
;*		jns	loc_789C		;*Jump if not sign
		db	 79h, 25h		;  Fixup - byte match
		jp	loc_78B9		; Jump if parity=1
;*		jp	loc_78DD		;*Jump if parity=1
		db	 7Ah, 62h		;  Fixup - byte match
loc_787B:
		jp	$+81h			; Jump if parity=1
		jp	loc_7804		; Jump if parity=1
;*		jp	loc_7844		;*Jump if parity=1
		db	 7Ah,0C3h		;  Fixup - byte match
		jp	loc_7861		; Jump if parity=1
		jp	$+2			; delay for I/O
		jnp	loc_78A9		; Jump if not parity
;*		jnp	loc_78C6		;*Jump if not parity
		db	 7Bh, 3Dh		;  Fixup - byte match
loc_7889:
		jnp	loc_78EC		; Jump if not parity
;*		jnp	loc_78F4		;*Jump if not parity
		db	 7Bh, 67h		;  Fixup - byte match
		jnp	loc_7818		; Jump if not parity
;*		jnp	loc_783C		;*Jump if not parity
		db	 7Bh,0ABh		;  Fixup - byte match
loc_7891:
;*		jnp	loc_7859		;*Jump if not parity
		db	 7Bh,0C6h		;  Fixup - byte match
;*		jnp	loc_7876		;*Jump if not parity
		db	 7Bh,0E1h		;  Fixup - byte match
;*		jnp	loc_789A		;*Jump if not parity
		db	 7Bh, 03h		;  Fixup - byte match
;*		jl	loc_78C0		;*Jump if <
		db	 7Ch, 27h		;  Fixup - byte match
loc_7899:
;*		jl	loc_78C8		;*Jump if <
		db	 7Ch, 2Dh		;  Fixup - byte match
		jl	loc_78EC		; Jump if <
;*		jl	loc_7825		;*Jump if <
		db	 7Ch, 86h		;  Fixup - byte match
;*		jl	loc_7842		;*Jump if <
		db	 7Ch,0A1h		;  Fixup - byte match
loc_78A1:
;*		jl	loc_7866		;*Jump if <
		db	 7Ch,0C3h		;  Fixup - byte match
;*		jl	loc_788A		;*Jump if <
		db	 7Ch,0E5h		;  Fixup - byte match
		jl	loc_78A9		; Jump if <
		jge	loc_78B1		; Jump if > or =
loc_78A9:
;*		jge	loc_78E3		;*Jump if > or =
		db	 7Dh, 38h		;  Fixup - byte match
;*		jge	loc_7907		;*Jump if > or =
		db	 7Dh, 5Ah		;  Fixup - byte match
;*		jge	loc_7924		;*Jump if > or =
		db	 7Dh, 75h		;  Fixup - byte match
;*		jge	loc_784F		;*Jump if > or =
		db	 7Dh, 9Eh		;  Fixup - byte match
loc_78B1:
;*		jge	loc_787A		;*Jump if > or =
		db	 7Dh,0C7h		;  Fixup - byte match
		jge	loc_7899		; Jump if > or =
loc_78B5:
		jge	loc_78A1		; Jump if > or =
;*		jge	loc_78CC		;*Jump if > or =
		db	 7Dh, 13h		;  Fixup - byte match
loc_78B9:
;*		jle	loc_78F0		;*Jump if < or =
		db	 7Eh, 35h		;  Fixup - byte match
;*		jle	loc_790D		;*Jump if < or =
		db	 7Eh, 50h		;  Fixup - byte match
		jle	loc_7931		; Jump if < or =
		jle	loc_784E		; Jump if < or =
		jle	loc_7889		; Jump if < or =
		jle	loc_7891		; Jump if < or =
		jle	loc_78B5		; Jump if < or =
		jle	loc_78D9		; Jump if < or =
;*		jg	loc_78E8		;*Jump if >
		db	 7Fh, 1Dh		;  Fixup - byte match
		jg	loc_7905		; Jump if >
;*		jg	loc_7929		;*Jump if >
		db	 7Fh, 5Ah		;  Fixup - byte match
		jg	$+80h			; Jump if >
		jg	loc_7857		; Jump if >
		jg	loc_787B		; Jump if >
;*		jg	loc_7898		;*Jump if >
		db	 7Fh,0C1h		;  Fixup - byte match
;*		jg	loc_78BC		;*Jump if >
		db	 7Fh,0E3h		;  Fixup - byte match
loc_78D9:
		jg	$+9			; Jump if >
		or	byte ptr [di],80h
		sub	data_8043[bx+si],al
		jp	$-7Eh			; Jump if parity=1
		xchg	bp,ax
		xor	byte ptr ds:[0CD80h][bx+si],80h
		db	0DAh, 80h
loc_78EC:
		cld				; Clear direction
		sbb	data_3981,81h
		push	sp
		cmp	word ptr [di-7Fh],81BDh
		lds	ax,dword ptr data_81CB[bx+di]	; Load seg:offset ptr
		db	0DFh, 81h,0F3h, 81h, 0Eh, 82h
		db	 29h, 82h
		db	4Bh
loc_7905:
;*		sub	byte ptr [di-7Eh],88h
		db	 82h, 6Dh, 82h, 88h	;  Fixup - byte match
;*		sbb	byte ptr ds:d_4600_B782_e[si],82h
		db	 82h, 9Ch, 82h,0B7h, 82h	;  Fixup - byte match
		retf
			                        ;* No entry point to code
;*		xor	ah,82h
		db	 82h,0F4h, 82h		;  Fixup - byte match
		or	ss:data_8323[bp+di],al
		adc	word ptr ds:[bp+si-7Dh],6Dh
;*		add	data_9C83[bx+di],0FF83h
		db	 83h, 81h, 83h, 9Ch, 83h	;  Fixup - byte match
		test	ax,0CB83h
;*		add	word ptr [bx+si],0FFC0h
		db	 83h, 00h,0C0h		;  Fixup - byte match
		or	al,0CCh
;*		xor	al,dh
		db	 30h,0F0h		;  Fixup - byte match
		cmp	al,0FCh
		add	ax,bx
		db	 0Fh,0CFh, 33h
loc_7931:
		db	0F3h, 3Fh,0FFh
data_7934	db	0
		db	 01h, 00h, 02h, 00h, 03h, 00h
		db	 04h, 00h, 05h, 00h, 06h, 00h
		db	 07h, 00h, 08h, 00h, 09h, 00h
		db	 10h, 00h, 11h, 00h, 12h, 00h
		db	 13h, 00h, 14h, 00h, 15h, 00h
		db	 16h, 00h, 17h, 00h, 18h, 00h
		db	 19h, 00h, 20h, 00h, 21h, 00h
		db	 22h, 00h, 23h, 00h, 24h, 00h
		db	 25h, 00h, 26h, 00h, 27h, 00h
		db	28h
data_796C	db	1
		db	 08h, 0Fh, 16h, 1Dh, 24h, 2Bh
		db	 32h, 37h, 3Eh, 46h,0FFh, 09h
		db	 09h, 0Bh, 18h, 1Ah, 1Fh, 25h
		db	 26h, 2Dh, 41h, 0Ah, 04h, 09h
		db	 11h, 18h, 1Eh
		db	 21h, 22h, 2Ah, 3Ah, 44h
data_798D	db	16h
data_798E	db	0Ah
data_798F	db	16h
data_7990	db	16h
data_7991	db	0Eh
data_7992	db	15h
data_7993	db	10h
		db	14h
data_7995	db	30h
data_7996	db	30h
		db	0
data_7998	db	1Ch
		db	15h
data_799A	dw	3331h
		db	0, 0
data_799E	db	1
		db	 01h, 00h, 1Dh, 68h, 30h, 34h
		db	 00h, 00h, 00h, 00h, 01h, 00h
		db	 2Dh, 00h, 32h, 6Ch,0FDh, 83h
		db	 00h, 00h, 02h, 00h, 00h, 01h
		db	 80h, 00h, 00h, 1Eh, 28h,0E1h
		db	 83h, 00h, 00h, 03h, 00h, 01h
		db	 03h, 00h, 1Eh, 00h, 28h, 3Ch
		db	0D6h, 84h, 00h, 03h, 00h, 1Eh
		db	 28h,0F6h, 83h, 00h, 04h, 00h
		db	 1Dh, 50h, 04h, 84h, 00h, 00h
		db	 04h, 00h, 02h, 03h, 00h, 04h
		db	 00h, 40h, 38h, 04h, 84h, 00h
		db	 05h, 00h, 1Dh, 50h, 19h, 84h
		db	 00h, 04h, 00h, 14h, 28h, 04h
		db	 84h, 00h, 0Bh, 05h, 00h, 03h
		db	 06h, 00h, 03h, 00h, 01h, 14h
		db	0F6h, 83h, 00h, 06h, 00h, 36h
		db	 40h,0FDh, 83h, 00h, 06h, 00h
		db	 36h, 50h,0FDh, 83h, 00h, 06h
		db	 00h, 36h, 60h,0FDh, 83h, 00h
		db	 0Dh, 00h, 44h, 30h,0F6h, 83h
		db	 00h, 11h, 00h, 1Eh, 30h, 43h
		db	 84h, 00h, 00h, 06h, 00h, 04h
		db	 03h, 00h, 08h, 00h, 12h, 40h
		db	 19h, 84h, 00h, 0Fh, 00h, 36h
		db	 36h,0E1h, 83h, 00h, 19h, 00h
		db	 40h, 36h,0DDh, 84h, 00h, 09h
		db	 07h, 00h, 05h, 04h, 00h, 09h
		db	 00h, 36h, 36h, 19h, 84h, 00h
		db	 18h, 00h, 14h
		db	 28h, 20h

locloop_7A52:
		test	al,[bx+si]
		sbb	al,[bx+si]
		and	al,40h			; '@'
		loopz	$-7Bh			; Loop if zf=1, cx>0

		add	[bx+di],dl
		add	byte ptr ds:[4330h],bl
		test	al,[bx+si]
		or	[bx+si],al
		add	byte ptr ds:[3],al
		or	al,[bx+si]
		adc	byte ptr ds:[8404h],dh
		add	[bx+si],bl
		add	[bx+si],ah
		db	 36h,0F6h, 83h, 00h, 0Ah, 00h
		db	 36h, 36h, 04h

locloop_7A7B:
		test	al,[bx+di]
		push	ss
		and	[bx+si],al
		add	[bx],al
		or	[bx+si],ax
		add	[bx+si],al
		or	byte ptr ds:[80Ah],al
		inc	ax
		sub	al,0
		and	al,78h			; 'x'
		std				; Set direction flag
		add	word ptr [bx+si],6
		add	[bx+si],si
		and	[bp+si],dl
		test	al,[bx+si]
		push	es
		add	[bx+si],si
		xor	[bp+si],dl
		test	al,[bx+si]
		push	es
		add	[bx+si],si
		inc	ax
		adc	al,byte ptr ds:[600h][si]
		add	[bx+si],si
		push	ax
		adc	al,byte ptr ds:[600h][si]
		add	[bx+si],si
		pusha				; Save all regs
		adc	al,byte ptr ds:[0C00h][si]
		add	[si],cl
		inc	si
		or	ax,word ptr ds:[0D00h][si]
		add	ds:data_F646_e,dh
		add	word ptr [bx+si],0
		or	[bx+si],ax
		or	ax,[bp+di]
		add	data_3200,cl
		inc	si
		loopz	locloop_7A52		; Loop if zf=1, cx>0

		add	[bp+di],dl
		add	byte ptr ds:[446h],bl
		test	al,[bx+si]
		and	ax,2800h
		xor	bl,ch
		test	al,[bx+si]
		add	[bp+si],cl
		add	al,0Ch
		add	al,40h			; '@'
		sub	al,0
		and	al,78h			; 'x'
		std				; Set direction flag
		add	word ptr [bx+si],0Fh
		add	[bx+si],cl
		xor	cl,[bp+di]
		test	al,[bx+si]
		or	al,[bx+si]
		and	si,[bx]
		loopz	locloop_7A7B		; Loop if zf=1, cx>0

		add	byte ptr ds:[2D00h],bl
		inc	cx
		db	0DDh, 84h, 00h, 00h, 0Bh, 00h
		db	 0Dh, 04h, 00h, 1Ch, 00h, 36h
		db	 36h, 04h, 84h, 00h, 1Fh, 00h
		db	 22h, 36h,0F6h, 83h, 00h, 1Dh
		db	 00h, 2Ch, 60h, 04h, 84h, 00h
		db	 13h, 00h, 14h, 32h,0F6h, 83h
		db	 00h, 00h, 0Ch, 00h, 0Eh, 03h
		db	 00h, 12h, 00h, 1Ah, 18h, 27h
		db	 84h, 00h, 08h, 00h, 0Ah, 46h
		db	 20h, 84h, 00h, 0Bh, 00h, 28h
		db	 3Ch, 20h, 84h, 00h, 0Fh, 0Dh
		db	 00h, 00h, 04h, 00h, 0Ch, 00h
		db	 0Ah, 46h, 0Bh, 84h, 00h, 0Dh
		db	 00h, 18h, 28h, 04h, 84h, 00h
		db	 0Ah, 00h, 23h, 32h,0F6h, 83h
		db	 00h, 10h, 00h, 32h, 60h,0E1h
		db	 83h, 01h,0F8h, 1Fh, 00h, 10h
		db	 0Eh, 00h, 00h, 00h, 00h, 11h
		db	 00h, 0Fh, 04h, 00h, 20h, 00h
		db	 38h, 08h,0E4h, 84h, 00h, 12h
		db	 00h, 10h, 18h, 27h, 84h, 00h
		db	 12h
data_7B7C	db	0			; Data table (indexed access)
		db	 3Eh, 68h, 35h, 84h, 00h, 21h
		db	 00h, 1Eh, 50h, 04h, 84h, 00h
		db	 1Ah, 12h, 00h, 10h, 04h, 00h
		db	 06h, 00h, 36h, 40h,0FDh, 83h
		db	 00h, 06h, 00h, 36h, 50h,0FDh
		db	 83h, 00h, 06h, 00h, 36h, 60h
		db	0FDh, 83h, 00h, 10h, 00h, 14h
		db	 14h, 0Bh, 84h, 00h, 00h, 13h
		db	 00h, 11h, 03h, 00h, 0Fh, 00h
		db	 1Eh, 28h,0E1h, 83h, 00h, 0Dh
		db	 00h, 3Ch, 28h,0F6h, 83h, 00h
		db	 0Dh, 00h, 1Eh, 60h, 04h, 84h
		db	 00h, 18h, 14h, 00h, 12h, 03h
		db	 00h, 11h, 00h, 20h, 38h, 6Dh
		db	 84h, 00h, 04h, 00h, 1Eh, 46h
		db	 04h, 84h, 00h, 16h, 00h, 32h
		db	 4Bh, 19h, 84h, 00h, 00h, 15h
		db	 00h, 13h, 04h, 00h, 0Eh, 00h
		db	 08h, 10h,0E1h, 83h, 00h, 10h
		db	 00h, 1Ah, 3Ch, 0Bh, 84h, 00h
		db	 1Ah, 00h, 28h, 3Ch,0E1h, 83h
		db	 00h, 05h, 00h, 3Ch, 3Ch, 04h
		db	 84h, 00h, 16h, 00h, 00h, 14h
		db	 04h, 00h, 20h, 00h, 0Ch, 08h
		db	0E4h, 84h, 00h, 19h, 00h, 28h
		db	 3Ch,0DDh, 84h, 00h, 1Ch, 00h
		db	 32h, 3Ch, 19h, 84h, 00h, 13h
		db	 00h, 1Eh, 28h, 04h, 84h, 01h
		db	 16h, 20h, 00h, 00h, 15h, 17h
		db	 00h, 00h, 00h, 16h, 00h, 18h
		db	 04h, 00h, 20h, 00h, 16h, 08h
		db	0E4h, 84h, 00h, 16h, 00h, 0Ah
		db	 60h, 20h, 84h, 00h, 09h, 00h
		db	 28h, 46h, 04h, 84h, 00h, 0Ah
		db	 00h, 46h, 19h,0F6h, 83h, 00h
		db	 00h, 17h, 13h, 19h, 07h, 40h
		db	 2Ch, 00h, 24h, 78h,0FDh, 83h
		db	 00h, 06h, 01h, 30h, 20h, 12h
		db	 84h, 00h, 06h, 01h, 30h, 30h
		db	 12h, 84h, 00h, 06h, 01h, 30h
		db	 40h, 12h, 84h, 00h, 06h, 01h
		db	 30h, 50h, 12h, 84h, 00h, 06h
		db	 01h, 30h, 60h, 12h, 84h, 00h
		db	 0Bh, 00h, 0Ah, 3Ch, 20h, 84h
		db	 00h, 00h, 18h, 00h, 1Ah, 03h
		db	 00h, 04h, 00h, 12h, 48h,0F6h
		db	 83h, 00h, 24h, 00h, 28h, 46h
		db	 04h, 84h, 00h, 04h, 00h, 3Ah
		db	 30h, 04h, 84h, 00h, 1Fh, 19h
		db	 11h, 1Bh, 04h, 40h, 2Ch, 00h
		db	 24h, 78h,0FDh, 83h, 00h, 25h
		db	 00h, 37h, 3Ch,0DDh, 84h, 00h
		db	 05h, 00h, 22h, 20h, 19h, 84h
		db	 00h, 0Dh, 00h, 14h, 32h, 04h
		db	 84h, 00h, 00h, 1Ah, 00h, 1Ch
		db	 04h, 00h, 1Ah, 00h, 0Ah, 28h
		db	 0Bh, 84h, 00h, 24h, 00h, 46h
		db	 1Eh, 20h, 84h, 00h, 13h, 00h
		db	 28h, 50h, 04h, 84h, 00h, 0Ah
		db	 00h, 1Eh, 50h,0F6h, 83h, 00h
		db	 1Dh, 1Bh, 00h, 00h, 03h, 00h
		db	 0Ch, 00h, 28h, 28h, 0Bh, 84h
		db	 00h, 08h, 00h, 28h, 3Ch, 20h
		db	 84h, 00h, 0Bh, 00h, 28h, 50h
		db	 20h, 84h, 01h,0F8h, 1Fh, 00h
		db	 1Eh, 1Ch, 00h, 00h, 00h, 00h
		db	 1Fh, 00h, 1Dh, 06h, 00h, 06h
		db	 00h, 26h, 40h,0FDh, 83h, 00h
		db	 06h, 00h, 26h, 50h,0FDh, 83h
		db	 00h, 06h, 00h, 26h, 60h,0FDh
		db	 83h, 00h, 1Eh, 00h, 14h, 3Ch
		db	0DDh, 84h, 00h, 1Ah, 00h, 0Ah
		db	 28h, 0Bh, 84h, 00h, 1Fh, 00h
		db	 3Ch, 3Ch, 20h, 84h, 00h, 00h
		db	 20h, 1Ah, 1Eh, 04h, 40h, 2Ch
		db	 00h, 34h, 78h,0FDh, 83h, 00h
		db	 05h, 00h, 26h, 28h,0A5h, 84h
		db	 00h, 21h, 00h, 1Ch, 38h, 19h
		db	 84h, 00h, 1Dh, 00h, 30h, 38h
		db	 20h, 84h, 00h, 00h, 21h, 00h
		db	 1Fh, 03h, 00h, 0Fh, 00h, 1Eh
		db	 28h,0E1h, 83h, 00h, 0Dh, 00h
		db	 3Ch, 28h,0F6h, 83h, 00h, 0Dh
		db	 00h, 26h, 60h, 04h, 84h, 00h
		db	 26h, 22h, 00h, 20h, 05h, 00h
		db	 06h, 00h, 32h, 40h,0FDh, 83h
		db	 00h, 06h, 00h, 32h, 50h,0FDh
		db	 83h, 00h, 06h, 00h, 32h, 60h
		db	0FDh, 83h, 00h, 11h, 00h, 1Eh
		db	 30h, 6Dh, 84h, 00h, 0Bh, 00h
		db	 3Ch, 48h, 20h, 84h, 00h, 25h
		db	 23h, 00h, 21h, 05h, 00h, 06h
		db	 00h, 2Eh, 48h,0FDh, 83h, 00h
		db	 06h, 00h, 2Eh, 58h,0FDh, 83h
		db	 00h, 06h, 00h, 2Eh, 68h,0FDh
		db	 83h, 00h, 0Ch, 00h, 3Ch, 32h
		db	 0Bh, 84h, 00h, 0Ah, 00h, 1Eh
		db	 46h,0F6h, 83h, 00h, 24h, 00h
		db	 00h, 22h, 03h, 00h, 24h, 00h
		db	 08h, 38h, 04h, 84h, 00h, 18h
		db	 00h, 20h, 58h,0F6h, 83h, 00h
		db	 0Ah, 00h, 36h, 36h, 04h, 84h
		db	 01h, 16h, 20h, 00h, 00h, 23h
		db	 25h, 00h, 00h, 00h, 24h, 22h
		db	 26h, 05h, 40h, 2Ch, 00h, 22h
		db	 78h,0FDh, 83h, 00h, 20h, 00h
		db	 02h, 08h,0E4h, 84h, 00h, 19h
		db	 00h, 28h, 46h,0DDh, 84h, 00h
		db	 0Eh, 00h, 0Fh, 32h,0E1h, 83h
		db	 00h, 1Ah, 00h, 41h, 32h, 0Bh
		db	 84h, 00h, 00h, 25h, 21h, 27h
		db	 04h, 40h, 2Ch, 00h, 22h, 78h
		db	0FDh, 83h, 00h, 25h, 00h, 28h
		db	 46h,0DDh, 84h, 00h, 05h, 00h
		db	 0Fh, 3Ch, 19h, 84h, 00h, 0Bh
		db	 00h, 41h, 3Ch, 20h, 84h, 00h
		db	 00h, 26h, 00h, 28h, 03h, 00h
		db	 12h, 00h, 1Ah, 38h,0ACh, 84h
		db	 00h, 0Dh, 00h, 28h, 32h, 04h
		db	 84h, 00h, 08h, 00h, 48h, 30h
		db	 19h, 84h, 00h, 2Dh, 27h, 00h
		db	 29h, 04h, 00h, 0Bh, 00h, 1Ch
		db	 28h, 51h, 84h, 00h, 0Ah, 00h
		db	 08h, 3Ch, 04h, 84h, 00h, 1Ch
		db	 00h, 25h, 3Ch, 04h, 84h, 00h
		db	 0Ah, 00h, 40h, 3Ch, 04h, 84h
		db	 00h, 00h, 28h, 00h, 2Ah, 03h
		db	 00h, 1Eh, 00h, 3Ch, 46h,0DDh
		db	 84h, 00h, 0Eh, 00h, 32h, 46h
		db	0E1h, 83h, 00h, 13h, 00h, 1Eh
		db	 46h, 04h, 84h, 00h, 2Bh, 29h
		db	 00h, 00h, 07h, 00h, 06h, 01h
		db	 10h, 48h, 12h, 84h, 00h, 06h
		db	 01h, 10h, 58h, 12h, 84h, 00h
		db	 06h, 01h, 10h, 68h, 12h, 84h
		db	 00h, 12h, 00h, 36h, 20h, 7Bh
		db	 84h, 00h, 1Dh, 00h, 26h, 20h
		db	 20h, 84h, 00h, 21h, 00h, 40h
		db	 28h, 20h, 84h, 00h, 05h, 00h
		db	 16h, 46h, 19h, 84h, 01h,0F8h
		db	 1Fh, 00h, 2Ch, 2Ah, 00h, 00h
		db	 00h, 00h, 2Dh, 00h, 2Bh, 04h
		db	 00h, 20h, 00h, 10h, 08h,0E4h
		db	 84h, 00h, 04h, 00h, 28h, 46h
		db	0F6h, 83h, 00h, 13h, 00h, 40h
		db	 60h, 04h, 84h, 00h, 0Dh, 00h
		db	 04h, 30h, 04h, 84h, 00h, 00h
		db	 2Eh, 28h, 2Ch, 04h, 40h, 2Ch
		db	 00h, 22h, 78h,0FDh, 83h, 00h
		db	 19h, 00h, 28h, 46h,0DDh, 84h
		db	 00h, 05h, 00h, 02h, 08h, 19h
		db	 84h, 00h, 16h, 00h, 46h, 08h
		db	 20h, 84h, 00h, 00h, 2Fh, 00h
		db	 2Dh, 01h, 00h, 0Bh, 00h, 25h
		db	 38h,0BAh, 84h, 00h, 00h, 30h
		db	 00h, 2Eh, 03h, 00h, 25h, 00h
		db	 28h, 50h,0DDh, 84h, 00h, 24h
		db	 00h, 02h, 0Ah, 19h, 84h, 00h
		db	 05h, 00h, 48h, 0Ah, 20h, 84h
		db	 00h, 00h, 31h, 00h, 2Fh, 04h
		db	 00h, 20h, 00h, 26h, 28h,0E4h
		db	 84h, 00h, 1Eh, 00h, 28h, 50h
		db	0DDh, 84h, 00h, 09h, 00h, 40h
		db	 58h, 20h, 84h, 00h, 09h, 00h
		db	 36h, 58h, 19h, 84h, 00h, 32h
		db	 00h, 00h, 30h, 04h, 00h, 20h
		db	 00h, 24h, 08h,0E4h, 84h, 00h
		db	 12h, 00h, 20h, 20h,0C8h, 84h
		db	 00h, 0Ch, 00h, 16h, 20h, 0Bh
		db	 84h, 00h, 1Dh, 00h, 25h, 50h
		db	 20h, 84h, 01h, 16h
data_7F7D	db	20h			; Data table (indexed access)
		db	 00h, 00h, 31h, 33h, 00h, 00h
		db	 00h, 32h, 00h, 34h, 04h, 00h
		db	 1Fh, 00h, 0Ch, 60h, 04h, 84h
		db	 00h, 0Ah, 00h, 24h, 28h,0F6h
		db	 83h, 00h, 1Dh, 00h, 36h, 36h
		db	 04h, 84h, 00h, 13h, 00h, 14h
		db	 32h,0F6h, 83h, 00h, 00h, 33h
		db	 00h, 35h, 03h, 00h, 12h, 00h
		db	 34h, 30h, 97h, 84h, 00h, 16h
		db	 00h, 28h, 28h, 19h, 84h, 00h
		db	 14h, 00h, 14h, 60h,0E1h, 83h
		db	 00h, 00h, 34h, 00h, 36h, 04h
		db	 00h, 0Ch, 00h, 0Ah, 32h, 0Bh
		db	 84h, 00h, 0Dh, 00h, 14h, 3Ch
		db	 04h, 84h, 00h, 0Ah, 00h, 1Eh
		db	 46h,0F6h, 83h, 00h, 10h, 00h
		db	 28h, 3Ch,0E1h, 83h, 00h, 37h
		db	 35h, 00h, 00h, 04h, 00h, 20h
		db	 00h, 3Ah, 10h,0E4h, 84h, 00h
		db	 04h, 00h, 14h, 46h,0F6h, 83h
		db	 00h, 04h, 00h, 28h, 4Bh, 04h
		db	 84h, 00h, 04h, 00h
		db	 3Ch, 50h
data_8002	db	4			; Data table (indexed access)
		db	 84h, 01h,0F8h, 1Fh, 00h, 38h
		db	 36h, 00h, 00h, 00h, 00h, 39h
		db	 00h, 37h, 03h, 00h, 14h, 00h
		db	 28h, 60h,0E1h, 83h, 00h, 1Ah
data_801B	dw	2800h			; Data table (indexed access)
		db	 3Ch,0E1h, 83h, 00h, 0Eh, 00h
		db	 08h, 20h,0E1h, 83h, 00h, 00h
		db	3Ah
data_802A	dw	3800h, 3
data_802E	dw	11h, 3820h
data_8032	dw	8489h, 0B00h
data_8036	dw	1E00h, 2058h
data_803A	dw	84h, 9
data_803E	dw	4646h, 83F6h
		db	0
data_8043	db	41h			; Data table (indexed access)
		db	 3Bh, 00h, 39h, 07h, 00h, 06h
		db	 00h, 2Eh, 40h,0FDh, 83h, 00h
		db	 06h, 00h, 2Eh, 50h,0FDh, 83h
		db	 00h, 06h, 00h, 2Eh, 60h,0FDh
		db	 83h, 00h, 20h, 00h, 32h, 10h
		db	0E4h, 84h, 00h, 14h, 00h, 28h
		db	 3Ch,0E1h, 83h, 00h, 0Fh, 00h
		db	 14h, 3Ch, 0Bh, 84h, 00h, 08h
		db	 00h, 46h, 3Ch, 20h, 84h, 00h
		db	 00h, 3Ch, 00h, 3Ah, 03h, 00h
		db	 09h, 00h, 36h, 36h, 19h, 84h
		db	 00h, 05h, 00h, 14h, 3Ch, 20h
		db	 84h, 00h, 0Ch, 00h, 26h, 60h
		db	0E1h, 83h, 00h, 00h, 3Dh, 00h
		db	 3Bh, 03h, 00h, 19h, 00h, 28h
		db	 50h,0DDh
data_80A0	db	84h			; Data table (indexed access)
		db	 00h, 04h, 00h, 0Ah, 14h, 04h
		db	 84h
data_80A8	db	0			; Data table (indexed access)
		db	0Ah
data_80AA	db	0			; Data table (indexed access)
		db	 46h, 14h, 04h, 84h, 00h, 3Eh
		db	 00h, 00h, 3Ch, 03h, 00h, 21h
		db	 00h, 0Ah, 14h, 20h, 84h, 00h
		db	 16h, 00h, 16h, 60h, 20h, 84h
		db	 00h, 24h, 00h, 26h, 60h, 19h
		db	 84h, 01h, 16h, 20h, 00h, 00h
		db	 3Dh, 3Fh, 01h, 00h, 12h, 00h
		db	 18h, 28h, 5Fh, 84h, 00h, 00h
		db	 3Eh, 00h, 40h, 04h, 00h, 13h
		db	 00h, 28h, 60h, 04h, 84h, 00h
		db	 0Dh, 00h, 14h, 60h, 04h, 84h
		db	 00h, 09h, 00h, 3Ch, 28h,0F6h
		db	 83h, 00h, 20h, 00h, 3Bh, 10h
		db	0E4h, 84h, 00h, 00h, 3Fh, 00h
		db	 41h, 04h, 00h, 20h, 00h, 10h
		db	 10h,0E4h, 84h, 00h, 10h, 00h
		db	 0Ch, 3Ch, 0Bh, 84h, 00h, 14h
		db	 00h, 22h, 3Ch,0E1h, 83h, 00h
		db	 13h, 00h, 3Eh, 3Ch, 04h, 84h
		db	 00h, 00h, 40h, 3Ah, 42h, 03h
		db	 40h, 2Ch, 00h, 12h, 78h,0FDh
		db	 83h, 00h, 0Bh, 00h, 14h, 46h
		db	 20h, 84h, 00h, 0Bh, 00h, 3Ch
		db	 46h, 20h, 84h, 00h, 00h, 41h
		db	 00h, 43h, 03h, 00h, 25h, 00h
		db	 14h, 50h,0DDh, 84h, 00h, 1Fh
		db	 00h, 14h, 3Ch, 19h, 84h, 00h
		db	 16h, 00h, 3Ch, 3Ch, 20h, 84h
		db	 00h, 00h, 42h, 00h, 44h, 05h
		db	 00h, 05h, 00h, 1Eh, 3Ch, 19h
		db	 84h, 00h, 16h, 00h, 14h, 32h
		db	 19h, 84h, 00h, 08h, 00h, 0Ah
		db	 46h, 19h, 84h, 00h, 0Dh, 00h
		db	 02h, 50h,0F6h, 83h, 00h, 09h
		db	 00h, 32h, 46h,0F6h, 83h, 00h
		db	 45h, 43h, 00h
data_8180	db	0			; Data table (indexed access)
		db	 08h, 00h, 06h, 00h, 24h, 18h
		db	0FDh, 83h, 00h, 06h, 00h, 24h
		db	 28h,0FDh, 83h, 00h, 06h, 00h
		db	 24h, 38h,0FDh, 83h, 00h, 06h
		db	 00h, 24h, 48h,0FDh, 83h, 00h
		db	 06h, 00h, 24h, 58h,0FDh, 83h
		db	 00h, 06h, 00h, 24h, 68h,0FDh
		db	 83h, 00h, 0Bh, 00h, 19h, 3Ch
		db	 19h, 84h, 00h, 0Bh, 00h, 28h
		db	 50h, 20h, 84h, 01h,0F8h, 1Fh
		db	 46h, 00h, 44h, 00h, 00h, 01h
		db	0F8h, 1Fh, 00h, 47h, 45h, 00h
		db	 00h, 00h
data_81CB	dw	4800h, 4600h		; Data table (indexed access)
		db	 02h, 00h, 18h, 00h, 28h, 14h
		db	 19h, 84h, 00h, 28h, 00h, 46h
		db	 20h,0F9h, 84h, 00h, 00h, 49h
		db	 00h, 47h, 02h, 00h, 1Dh, 00h
		db	 28h, 14h, 19h, 84h, 00h, 28h
		db	 00h, 46h, 20h,0F9h, 84h, 00h
		db	 00h, 4Ah, 00h, 48h, 03h, 00h
		db	 16h, 00h, 28h, 14h, 19h, 84h
		db	 00h, 28h, 00h, 46h, 20h, 01h
		db	 85h, 00h, 27h, 00h, 24h, 48h
		db	 0Bh, 84h, 00h, 00h
data_820F	dw	4Bh			; Data table (indexed access)
		db	 49h, 03h, 00h, 0Ah, 00h, 28h
		db	 14h, 19h, 84h, 00h, 28h, 00h
		db	 46h, 20h, 01h, 85h, 00h, 27h
		db	 00h, 2Eh, 50h, 0Bh, 84h, 00h
		db	 00h, 4Ch, 00h, 4Ah, 04h, 00h
		db	 13h, 00h, 28h, 14h, 19h, 84h
		db	 00h, 28h, 00h, 46h, 20h, 01h
		db	 85h, 00h, 2Ah, 00h, 2Bh, 50h
		db	 21h, 85h, 00h, 2Ah, 00h, 1Fh
		db	 60h, 21h, 85h, 00h, 00h, 4Dh
		db	 00h, 4Bh, 04h, 00h, 28h, 00h
		db	 46h, 20h, 01h, 85h, 00h, 27h
		db	 00h, 46h, 50h,0E1h, 83h, 00h
		db	 05h, 00h, 14h, 28h, 19h, 84h
		db	 00h, 27h, 00h, 3Ch, 58h, 0Bh
		db	 84h, 00h, 00h, 4Eh, 00h, 4Ch
		db	 03h, 00h, 1Fh, 00h, 28h, 14h
		db	 19h, 84h, 00h, 28h, 00h, 46h
		db	 20h, 09h, 85h, 00h, 27h, 00h
		db	2Bh
data_8284	db	58h			; Data table (indexed access)
		db	 0Bh, 84h, 00h, 00h, 4Fh, 00h
		db	 4Dh, 02h, 00h, 21h, 00h, 28h
		db	 14h, 19h, 84h, 00h, 28h, 00h
		db	 46h, 20h,0F9h, 84h, 00h, 00h
		db	 50h, 00h, 4Eh, 03h, 00h, 24h
		db	 00h, 28h, 14h, 19h, 84h, 00h
		db	 28h, 00h, 46h, 20h,0F9h, 84h
		db	 00h, 27h, 00h, 2Ah, 38h, 0Bh
		db	 84h, 00h, 00h, 51h, 00h, 4Fh
		db	 02h, 00h, 16h, 00h, 28h, 14h
		db	 19h, 84h, 00h, 28h, 00h, 46h
		db	 20h, 19h, 85h, 00h, 00h, 52h
		db	 00h, 50h, 05h, 00h, 28h, 00h
		db	 46h, 20h,0F9h, 84h, 00h, 2Ah
		db	 00h, 1Dh, 58h, 21h, 85h, 00h
		db	 2Ah, 00h, 3Ah, 48h, 21h, 85h
		db	 00h, 2Ah, 00h, 2Bh, 48h, 21h
		db	 85h, 00h, 1Ch, 00h
		db	28h
data_82F0	db	14h			; Data table (indexed access)
		db	 19h, 84h, 00h, 00h, 53h, 00h
		db	 51h, 02h, 00h, 13h, 00h, 28h
		db	 14h, 19h, 84h, 00h, 28h, 00h
		db	 46h, 20h,0F9h, 84h, 00h, 00h
		db	 54h, 00h, 52h, 03h, 00h, 13h
		db	 00h, 28h, 14h, 19h, 84h, 00h
		db	 28h, 00h, 46h, 20h, 09h, 85h
		db	 00h, 27h, 00h, 14h, 48h, 0Bh
		db	 84h, 00h
data_8323	db	0			; Data table (indexed access)
		db	 55h, 00h, 53h, 03h, 00h, 1Dh
		db	 00h, 28h, 14h, 19h, 84h, 00h
		db	 28h, 00h, 46h, 20h,0F9h, 84h
		db	 00h, 27h, 00h, 2Ch, 58h, 0Bh
		db	 84h, 00h, 00h, 56h, 00h, 54h
		db	 02h, 00h, 1Ch, 00h, 28h, 14h
		db	 19h, 84h, 00h, 28h, 00h, 46h
		db	 20h,0F9h, 84h, 00h, 00h, 57h
		db	 00h, 55h, 03h, 00h, 0Ah, 00h
		db	 28h, 14h, 19h, 84h, 00h, 28h
		db	 00h, 46h, 20h,0F9h, 84h, 00h
		db	 27h, 00h, 1Eh, 38h, 0Bh, 84h
		db	 00h, 00h, 58h, 00h, 56h, 02h
		db	 00h, 18h, 00h, 28h, 14h, 19h
		db	 84h, 00h, 28h, 00h, 46h, 20h
		db	 09h, 85h, 00h, 00h, 59h, 00h
		db	 57h, 03h, 00h, 28h, 00h, 46h
		db	 20h, 09h, 85h, 00h, 27h, 00h
		db	 16h, 48h, 0Bh, 84h, 00h, 26h
		db	 00h, 3Ch, 58h, 19h, 84h, 00h
		db	 00h, 5Ah, 00h, 58h, 01h, 00h
		db	 28h, 00h, 46h, 20h, 19h, 85h
		db	 00h, 00h, 5Bh, 00h, 59h, 04h
		db	 00h, 28h, 00h, 46h, 20h, 11h
		db	 85h, 00h, 27h, 00h, 24h, 60h
		db	 0Bh, 84h, 00h, 2Ah, 00h, 19h
		db	 60h, 21h, 85h, 00h, 2Ah, 00h
		db	 2Dh, 60h, 21h, 85h, 00h, 00h
		db	 00h, 00h, 5Ah, 00h, 01h, 7Ah
		db	 14h
data_83D3	db	0
		db	 22h, 00h, 00h, 00h,0F2h, 84h
data_83DA	db	0
		db	 2Bh, 00h, 00h, 00h, 28h, 85h
		db	 04h, 00h, 01h, 00h, 01h,0F2h
		db	 27h, 04h, 00h, 02h, 00h, 02h
		db	 90h, 27h, 14h, 01h, 02h, 14h
		db	0FFh,0FEh, 00h, 04h, 00h, 02h
		db	 00h, 02h,0E5h, 28h, 04h, 00h
		db	 00h, 00h, 00h
		db	 61h, 29h
		db	4
		db	 00h, 02h, 00h, 02h,0F2h, 27h
		db	 04h, 00h, 01h, 00h, 01h,0E5h
		db	 28h, 04h, 01h, 01h, 01h, 01h
		db	 61h, 29h, 04h, 00h, 03h, 00h
		db	 03h,0E5h, 28h, 04h, 00h, 03h
		db	 00h, 03h,0F2h, 27h, 04h, 00h
		db	 01h, 00h, 01h, 90h, 27h, 09h
		db	 00h, 08h, 09h, 00h,0F8h, 00h
		db	 04h, 00h, 01h, 00h, 01h, 90h
		db	 27h, 09h, 00h,0F8h, 09h, 00h
		db	 08h, 00h, 04h, 00h, 01h, 00h
		db	 01h, 90h, 27h, 11h, 01h, 00h
		db	 11h,0FFh, 00h, 00h, 04h, 00h
		db	 03h, 00h, 03h, 90h, 27h, 13h
		db	 01h, 00h, 13h,0FFh, 00h, 00h
		db	 04h, 00h, 01h, 00h, 01h, 90h
		db	 27h, 07h, 00h, 08h, 07h, 00h
		db	0F8h, 00h, 04h, 00h, 01h, 00h
		db	 01h, 90h, 27h, 0Dh, 01h, 00h
		db	 0Dh,0FFh, 00h, 00h, 04h, 00h
		db	 01h, 00h, 01h, 90h, 27h, 08h
		db	 00h, 08h, 08h, 00h,0F8h, 00h
		db	 04h, 00h, 01h, 00h, 01h, 90h
		db	 27h, 0Bh, 01h, 00h, 0Bh,0FFh
		db	 00h, 00h, 04h, 00h, 01h, 00h
		db	 01h, 90h, 27h, 06h, 00h, 08h
		db	 06h, 00h,0F8h, 00h, 04h, 00h
		db	 03h, 00h, 03h, 61h, 29h, 04h
		db	 00h, 01h, 00h, 01h, 90h, 27h
		db	 05h, 00h, 08h, 05h, 00h,0F8h
		db	 00h, 02h, 00h, 03h, 00h, 03h
		db	 90h, 27h, 08h, 00h, 05h, 08h
		db	 00h,0FBh, 00h, 04h, 00h, 01h
		db	 00h, 01h, 90h, 27h, 08h, 00h
		db	 08h, 08h, 00h,0F8h, 00h, 04h
		db	 00h, 05h, 00h, 05h,0E5h, 28h
		db	 04h, 00h, 05h, 00h, 05h,0F2h
		db	 27h, 04h, 00h, 05h, 00h, 05h
		db	 62h, 29h, 04h, 00h, 02h, 00h
		db	 02h,0D8h, 28h, 03h, 00h, 03h
		db	 00h, 03h,0E5h, 28h, 01h, 00h
		db	 01h, 00h, 01h,0D2h, 29h, 38h
		db	 01h, 00h, 01h, 00h, 01h,0D2h
		db	 29h, 40h, 01h, 00h, 01h, 00h
		db	 01h,0D2h, 29h, 48h, 01h, 00h
		db	 01h, 00h, 01h,0D2h, 29h, 50h
		db	 01h, 00h, 01h, 00h, 01h,0D2h
		db	 29h, 58h, 0Ah, 00h, 03h, 00h
		db	 03h, 41h, 2Ah, 0Ah, 00h, 00h
		db	 00h, 00h, 19h
		db	2Bh
data_852F	db	0
		db	 17h, 00h, 00h, 00h,0EBh, 84h
		db	 04h, 10h, 00h, 03h,0C0h, 00h
		db	 00h, 0Ch, 30h, 00h, 00h, 0Ch
		db	 30h, 00h, 00h, 0Ch, 30h, 00h
		db	 00h, 0Ch, 30h, 00h, 00h, 0Ch
		db	 30h, 00h, 2Ah,0A9h, 7Ah,0A8h
		db	 80h, 05h, 30h, 02h, 80h, 05h
		db	 70h, 02h, 2Ah,0AAh,0AAh,0A8h
		db	 00h, 0Ch, 30h, 00h, 00h, 0Ch
		db	 30h, 00h, 00h, 0Ch, 30h, 00h
		db	 00h, 0Ch, 30h, 00h, 00h, 0Ch
		db	 30h, 00h, 00h, 03h,0C0h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 0Fh, 00h, 00h,0A0h, 30h,0C0h
		db	 02h
		db	8, '00', 8, 8, 0Ch, 0Ch, '  '
		db	 03h, 03h, 80h, 80h, 00h,0C1h
		db	0C2h, 00h, 00h, 35h, 38h, 00h
		db	 00h, 25h, 6Ch, 00h, 00h, 81h
		db	 83h, 00h, 02h, 02h,0C0h,0C0h
		db	8, 8, '00  ', 0Ch, 0Ch, ' '
		db	 80h, 03h, 0Ch, 0Ah, 00h, 00h
		db	0F0h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 02h, 80h, 00h, 00h
		db	 08h, 20h, 00h, 00h, 08h, 20h
		db	 00h, 00h, 08h, 20h, 00h, 00h
		db	 08h, 20h, 00h, 00h, 08h, 20h
		db	 00h, 3Fh,0F9h, 6Fh,0FCh,0C0h
		db	 05h, 20h, 03h,0C0h, 05h, 60h
		db	 03h, 3Fh,0FFh,0EFh,0FCh, 00h
		db	 08h, 20h, 00h, 00h, 08h, 20h
		db	 00h, 00h, 08h, 20h, 00h, 00h
		db	 08h, 20h, 00h, 00h, 08h, 20h
		db	 00h, 00h, 02h, 80h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 0Ah
		db	 00h, 00h,0F0h, 20h, 80h, 03h
		db	0Ch, '  ', 0Ch, 0Ch, 8, 8, '00'
		db	 02h, 02h,0C0h,0C0h, 00h, 81h
		db	 43h, 00h, 00h, 25h, 1Ch, 00h
		db	 00h, 35h, 78h, 00h, 00h,0C1h
		db	0C2h, 00h, 03h, 03h, 80h, 80h
		db	0Ch, 0Ch, '  00', 8, 8, '0'
		db	0C0h, 02h, 08h, 0Fh, 00h, 00h
		db	0A0h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 2Bh,0D4h, 00h, 02h,0AFh,0F5h
		db	 40h, 0Ah,0BFh,0FDh, 50h, 2Ah
		db	0BFh,0FDh, 54h, 2Ah,0BFh,0FDh
		db	 54h,0AAh,0FFh,0FFh, 55h,0AAh
		db	0FFh,0FFh, 55h,0AAh,0FFh,0FFh
		db	 55h,0AAh,0FFh,0FFh, 55h, 2Ah
		db	0BFh,0FDh, 54h, 2Ah,0BFh,0FDh
		db	 54h, 0Ah,0BFh,0FDh, 50h, 02h
		db	0AFh,0F5h, 40h, 00h, 2Bh,0D4h
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 00h
data_8685	dw	0			; Data table (indexed access)
		db	 3Dh, 4Ch, 00h, 03h,0F5h, 53h
		db	0C0h, 0Fh,0D5h, 54h, 30h, 3Fh
		db	0D5h, 54h, 0Ch, 3Fh,0D5h, 54h
		db	 0Ch,0FFh, 55h, 55h, 03h,0FFh
		db	 55h, 55h, 03h,0FFh, 55h, 55h
		db	 03h,0FFh, 55h, 55h, 03h, 3Fh
		db	0D5h, 54h, 0Ch, 3Fh,0D5h, 54h
		db	 0Ch, 0Fh,0D5h, 54h, 30h, 03h
		db	0F5h, 53h,0C0h, 00h, 3Dh, 4Ch
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 14h, 28h, 00h, 01h, 50h, 0Ah
		db	 80h, 05h, 40h, 02h,0A0h, 15h
		db	 40h, 02h,0A8h, 15h, 40h, 02h
		db	0A8h, 55h, 00h, 00h,0AAh, 55h
		db	 00h, 00h,0AAh, 55h, 00h, 00h
		db	0AAh, 55h, 00h, 00h,0AAh, 15h
		db	 40h, 02h,0A8h, 15h, 40h, 02h
		db	0A8h, 05h, 40h, 02h,0A0h, 01h
		db	 50h, 0Ah, 80h, 00h, 14h, 28h
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 32h,0BCh, 00h, 03h,0CAh,0AFh
		db	0C0h, 0Ch, 2Ah,0ABh,0F0h, 30h
		db	 2Ah,0ABh,0FCh, 30h, 2Ah,0ABh
		db	0FCh,0C0h,0AAh,0AAh,0FFh,0C0h
		db	0AAh,0AAh,0FFh,0C0h,0AAh,0AAh
		db	0FFh,0C0h,0AAh,0AAh,0FFh, 30h
		db	 2Ah,0ABh,0FCh, 30h, 2Ah,0ABh
		db	0FCh, 0Ch, 2Ah,0ABh,0F0h, 03h
		db	0CAh,0AFh,0C0h, 00h, 32h,0BCh
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 0Dh, 10h, 00h, 00h
		db	 35h, 44h, 00h, 00h,0F5h, 55h
		db	 00h, 00h, 35h, 04h, 00h, 00h
		db	0F5h, 55h, 00h, 00h, 35h, 04h
		db	 00h, 00h,0F5h, 55h, 00h, 00h
		db	 35h, 04h, 00h, 00h, 00h, 00h
		db	 00h,0AAh,0AAh,0AAh,0AAh, 2Ah
		db	0AAh,0A0h, 08h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	 35h, 44h, 00h, 00h, 0Dh, 10h
		db	 00h, 00h, 00h, 00h, 00h
data_8788	dw	1004h			; Data table (indexed access)
		db	 00h, 0Dh, 10h, 00h, 00h, 35h
		db	 44h, 00h, 00h,0F5h, 55h, 00h
		db	 00h, 35h, 04h, 00h, 00h,0F5h
		db	 55h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh, 2Ah, 80h
		db	 02h,0A8h,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h, 00h, 00h, 00h,0F5h
		db	 55h, 00h, 00h, 35h, 04h, 00h
		db	 00h,0F5h, 55h, 00h, 00h, 35h
		db	 44h, 00h, 00h, 0Dh, 10h, 00h
		db	 00h, 00h, 00h, 00h, 04h, 10h
		db	 00h, 0Dh, 10h, 00h, 00h, 35h
		db	 44h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh, 20h, 0Ah
		db	0AAh,0A8h,0AAh,0AAh,0AAh,0AAh
		db	 00h, 00h, 00h, 00h, 00h, 35h
		db	 04h, 00h, 00h,0F5h, 55h, 00h
		db	 00h, 35h, 04h, 00h, 00h,0F5h
		db	 55h, 00h, 00h, 35h, 04h, 00h
		db	 00h,0F5h, 55h, 00h, 00h, 35h
		db	 44h, 00h, 00h, 0Dh, 10h, 00h
		db	 00h, 00h, 00h, 00h, 08h, 0Ch
		db	 00h, 00h, 0Ch, 55h, 4Fh,0F0h
		db	 00h, 00h, 00h, 0Ch,0F1h, 45h
		db	 3Fh, 05h, 55h, 00h, 00h,0FFh
data_8820	db	0C5h			; Data table (indexed access)
		db	 14h,0FCh, 14h, 51h, 40h
data_8826	db	3
		db	0F3h,0C5h, 54h,0F0h, 11h, 50h
		db	 10h, 0Fh,0FFh,0C0h, 00h,0F0h
		db	 51h, 40h, 00h, 0Fh,0F3h,0FFh
		db	0FFh,0F0h, 55h, 40h,0F0h, 03h
		db	0FFh,0CFh, 3Ch,0F0h, 50h, 00h
		db	0F0h, 0Ch,0CFh,0FFh,0FFh,0F0h
		db	 55h, 40h, 00h, 03h, 33h, 33h
		db	 33h, 30h, 15h, 50h, 10h, 00h
		db	0CCh,0CCh,0CCh,0CCh, 11h, 11h
		db	 40h, 00h, 03h, 33h, 33h, 33h
		db	 04h, 45h, 00h, 00h, 00h, 0Ch
		db	0CCh,0CCh,0F0h, 00h, 00h, 08h
		db	 0Ch, 00h, 00h, 01h, 4Fh,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 55h
		db	 3Ch, 05h, 55h, 40h, 00h, 00h
		db	 0Fh, 54h,0F0h, 11h, 54h, 54h
		db	 00h, 00h, 3Ch, 54h,0F0h, 45h
		db	 40h, 05h, 00h, 00h,0FCh, 00h
		db	0C1h, 45h, 00h, 01h, 00h, 00h
		db	0CFh
data_889A	db	0FFh
		db	0C1h, 55h, 0Fh, 3Ch, 40h, 00h
		db	0FCh,0CCh,0C1h, 40h, 0Fh, 3Ch
		db	 40h, 00h,0F3h,0FFh,0C1h, 55h
		db	 00h, 01h, 00h, 00h, 3Ch,0CCh
		db	0F0h, 55h, 40h, 05h, 00h, 00h
		db	 03h, 33h, 30h, 11h, 14h, 54h
		db	 00h, 00h, 00h,0CCh,0CCh, 04h
		db	 45h, 40h, 00h, 00h, 00h, 03h
		db	 33h, 30h, 00h, 00h, 00h, 08h
		db	 0Ch, 00h, 00h, 00h,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 3Fh
		db	 00h, 55h, 50h, 00h, 00h, 00h
		db	 00h,0FCh, 15h, 55h, 15h, 40h
		db	 00h, 00h, 03h,0F0h, 45h, 40h
		db	 00h, 50h, 00h, 00h, 0Fh,0C1h
		db	 44h, 00h, 00h, 14h, 00h, 00h
		db	 0Fh,0C1h, 54h, 0Fh, 3Ch, 14h
		db	 00h, 00h, 0Fh,0C1h, 40h, 0Fh
		db	 3Ch, 04h, 00h, 00h, 0Ch,0C1h
		db	 54h, 00h, 00h, 14h, 00h, 00h
		db	 03h, 30h, 55h, 40h, 00h, 50h
		db	 00h, 00h, 00h,0CCh, 11h, 11h
		db	 15h, 40h, 00h, 00h, 00h, 33h
		db	 00h, 44h, 50h, 00h, 00h, 00h
		db	 00h, 00h,0CFh, 00h, 00h, 00h
		db	 00h
data_8932	db	8			; Data table (indexed access)
		db	 0Ch, 00h
		db	10 dup (0)
		db	 55h, 54h, 00h, 00h, 00h, 00h
		db	 00h, 15h, 54h, 55h, 50h, 00h
		db	 00h, 00h, 00h, 55h, 00h, 01h
		db	 54h, 00h, 00h, 00h, 01h, 50h
		db	 00h, 00h, 15h, 00h, 00h, 00h
		db	 01h, 50h, 3Ch,0F0h, 15h, 00h
		db	 00h, 00h, 01h, 00h, 3Ch,0F0h
		db	 01h, 00h, 00h, 00h, 01h, 50h
		db	 00h, 00h, 15h, 00h, 00h, 00h
		db	 00h, 54h, 00h, 01h, 54h, 00h
		db	 00h, 00h, 00h, 15h, 54h, 55h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 44h, 44h
		db	11 dup (0)
		db	 08h, 0Ch, 00h, 00h, 00h, 00h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 05h, 55h, 00h,0FCh, 00h, 00h
		db	 00h, 01h, 54h, 55h, 54h, 3Fh
		db	 00h, 00h, 00h, 05h, 00h, 01h
		db	 51h, 0Fh,0C0h, 00h, 00h, 14h
		db	 00h, 00h, 11h, 43h,0F0h, 00h
		db	 00h, 14h, 3Ch,0F0h, 15h, 43h
		db	0F0h, 00h, 00h, 10h, 3Ch,0F0h
		db	 01h, 43h,0F0h, 00h, 00h, 14h
		db	 00h, 00h, 15h, 43h, 30h, 00h
		db	 00h, 05h, 00h, 01h, 55h, 0Ch
		db	0C0h, 00h, 00h, 01h, 54h, 44h
		db	 44h, 33h, 00h, 00h, 00h, 00h
		db	 05h, 11h, 00h,0CCh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0F3h, 00h
		db	 00h, 00h, 08h, 0Ch, 00h, 00h
		db	 00h, 0Fh,0F1h, 40h, 00h, 00h
		db	 00h, 01h, 55h, 50h, 3Ch, 55h
		db	 00h, 00h, 00h, 15h, 15h, 44h
		db	 0Fh, 15h,0F0h, 00h, 00h, 50h
		db	 01h, 51h, 0Fh, 15h, 3Ch, 00h
		db	 00h, 40h, 00h, 51h, 43h, 00h
		db	 3Fh, 00h, 01h, 3Ch,0F0h, 55h
		db	 43h,0FFh,0F3h, 00h, 01h, 3Ch
		db	0F0h, 01h, 43h, 33h, 3Fh, 00h
		db	 00h, 40h, 00h, 55h, 43h,0FFh
		db	0CFh, 00h, 00h, 50h, 01h, 55h
		db	 0Fh, 33h, 3Ch, 00h, 00h, 15h
		db	 14h, 44h, 0Ch,0CCh,0C0h, 00h
		db	 00h, 01h, 51h, 10h, 33h, 33h
		db	 00h, 00h, 00h, 00h, 00h, 0Ch
		db	0CCh,0C0h, 00h, 00h, 08h, 0Ch
		db	 00h, 00h, 0Fh,0F1h, 55h, 30h
		db	 00h, 00h, 00h, 55h, 50h,0FCh
		db	 51h, 4Fh, 30h, 00h, 01h, 45h
		db	 14h, 3Fh, 14h, 53h,0FFh, 00h
		db	 04h, 05h, 44h, 0Fh, 15h, 53h
		db	0CFh,0C0h, 00h, 01h, 45h, 0Fh
		db	 00h, 03h,0FFh,0F0h, 0Fh, 01h
		db	 55h, 0Fh,0FFh,0FFh,0CFh,0F0h
		db	 0Fh, 00h, 05h, 0Fh, 3Ch,0F3h
		db	0FFh,0C0h, 00h, 01h, 55h, 0Fh
		db	0FFh,0FFh,0F3h, 30h, 04h, 05h
		db	 54h, 0Ch,0CCh,0CCh,0CCh,0C0h
		db	 01h, 44h, 44h, 33h, 33h, 33h
		db	 33h, 00h, 00h, 51h, 10h,0CCh
		db	0CCh,0CCh,0C0h, 00h, 00h, 00h
		db	 0Fh, 33h, 33h, 30h, 00h, 00h
		db	 0Ah, 10h, 00h, 00h, 00h, 00h
		db	 0Fh, 10h, 00h
		db	17 dup (0)
		db	0F5h, 51h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0C0h
		db	8 dup (0)
		db	 03h,0F0h, 0Fh, 55h, 54h, 10h
		db	 0Fh,0C0h, 00h, 00h
		db	9 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 80h, 08h,0AAh
		db	7 dup (0AAh)
		db	 20h, 2Ah
		db	8 dup (0)
		db	0A8h, 88h, 03h, 0Ch, 30h,0C3h
		db	 0Ch, 30h,0C3h, 0Ch, 22h,0A0h
		db	0C5h
		db	'UUUUUUP', 0Ah
		db	0A0h, 14h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 17h, 0Ah, 00h,0D0h
		db	 28h, 28h, 28h, 28h, 28h, 28h
		db	 04h, 00h, 00h, 14h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 14h, 00h
		db	 00h,0C5h, 55h, 55h, 55h, 55h
		db	 55h, 55h, 50h, 00h, 00h, 03h
		db	 0Ch, 30h,0C3h, 0Ch, 30h,0C3h
		db	 0Ch, 00h, 0Ah, 10h, 00h, 00h
		db	 00h, 00h, 0Fh, 10h, 00h
		db	17 dup (0)
		db	0F5h, 51h
		db	11 dup (0)
		db	 03h, 00h, 00h, 00h, 03h,0F0h
		db	 0Fh, 55h, 54h, 10h, 0Fh,0C0h
		db	 00h, 00h
		db	9 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 80h, 08h,0AAh
		db	7 dup (0AAh)
		db	 20h, 2Ah
		db	8 dup (0)
		db	0A8h, 88h, 30h,0C3h, 0Ch, 30h
		db	0C3h, 0Ch, 30h,0C0h, 22h,0A0h
		db	 05h
		db	'UUUUUUS', 0Ah
		db	0A0h, 14h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 14h, 0Ah, 00h, 10h
		db	 28h, 28h, 28h, 28h, 28h, 28h
		db	 07h, 00h, 00h,0D4h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 14h, 00h
		db	 00h, 05h, 55h, 55h, 55h, 55h
		db	 55h, 55h, 53h, 00h, 00h, 30h
		db	0C3h, 0Ch, 30h,0C3h, 0Ch, 30h
		db	0C0h, 00h, 04h, 10h, 00h, 0Fh
		db	0F0h, 00h, 00h,0FAh,0AFh, 00h
		db	 00h,0A5h, 5Ah, 00h, 00h, 45h
		db	 5Fh, 00h, 00h, 15h, 5Fh, 00h
		db	 00h,0AAh,0AAh, 00h, 0Ah,0AAh
		db	0AAh,0A0h,0AAh, 45h, 5Fh,0AAh
		db	0A0h, 15h, 5Fh, 0Ah,0AAh, 45h
		db	 5Fh,0AAh, 0Ah, 15h, 5Fh,0A0h
		db	 00h, 4Ah,0AFh, 00h, 00h,0AFh
		db	0FAh, 00h, 00h,0FAh,0AFh, 00h
		db	 00h,0AAh,0AAh, 00h, 00h, 0Ah
		db	0A0h, 00h
data_8C40	db	4			; Data table (indexed access)
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h,0AAh,0AAh
		db	 00h, 00h, 45h, 5Fh, 00h, 00h
		db	 15h, 5Fh, 00h, 00h, 45h, 5Fh
		db	 00h, 00h, 15h, 5Fh, 00h
		db	8 dup (0AAh)
		db	 00h, 45h, 5Fh, 00h, 00h, 15h
		db	 5Fh, 00h, 00h, 45h, 5Fh, 00h
		db	 00h, 15h, 5Fh, 00h, 00h,0AAh
		db	0AAh, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 04h, 10h
		db	 00h, 0Ah,0A0h, 00h, 00h,0AAh
		db	0AAh, 00h, 00h,0FAh,0AFh, 00h
		db	 00h,0AFh,0FAh, 00h, 00h, 4Ah
		db	0AFh, 00h, 0Ah, 15h, 5Fh,0A0h
		db	0AAh, 45h, 5Fh,0AAh,0A0h, 15h
		db	 5Fh, 0Ah,0AAh, 45h, 5Fh,0AAh
		db	 0Ah,0AAh
data_8CAA	dw	0A0AAh
		db	 00h,0AAh,0AAh, 00h, 00h, 15h
		db	 5Fh, 00h, 00h, 45h, 5Fh, 00h
		db	 00h,0A5h, 5Ah, 00h, 00h,0FAh
		db	0AFh, 00h, 00h, 0Fh,0F0h, 00h
		db	 04h, 10h, 00h, 2Ah,0A8h, 00h
		db	 02h,0ABh,0EAh, 80h, 0Ah,0A0h
		db	 0Ah,0A0h, 3Ah, 0Ah,0A0h,0ACh
		db	 28h,0A0h, 0Ah, 28h,0A2h, 0Fh
		db	 50h, 8Ah, 88h,0FFh, 55h, 22h
		db	 88h,0F5h, 55h, 22h, 88h, 55h
		db	 55h, 22h, 88h, 55h, 55h, 22h
		db	0A2h, 05h, 50h, 8Ah, 28h,0A0h
		db	 0Ah, 28h, 3Ah, 0Ah,0A0h,0ACh
		db	 0Ah,0A0h, 0Ah,0A0h, 02h,0ABh
		db	0EAh, 80h, 00h, 2Ah,0A8h, 00h
data_8D06	dw	1004h, 2A00h		; Data table (indexed access)
		db	0A8h, 00h, 02h,0BAh,0AEh, 80h
		db	 0Ah,0AAh,0AAh,0A0h, 20h,0ABh
		db	0EAh, 08h, 0Ah, 2Ah,0A8h,0A0h
		db	 50h, 8Ah,0A2h, 0Fh, 55h, 22h
		db	 88h,0FFh, 55h, 22h, 88h,0F5h
		db	 55h, 22h, 88h, 55h, 55h, 22h
		db	 88h, 55h, 50h, 8Ah,0A2h, 05h
		db	 0Ah, 2Ah,0A8h,0A0h, 20h,0ABh
		db	0EAh, 08h, 0Ah,0AAh,0AAh,0A0h
		db	 02h,0BAh,0AEh, 80h, 00h, 2Ah
		db	0A8h, 00h, 04h, 10h, 80h, 00h
		db	 00h, 08h, 22h, 01h, 00h, 28h
		db	 0Ah, 80h, 0Ah,0A0h, 0Ah,0A8h
		db	 2Ah, 80h, 82h, 6Ah,0A6h, 80h
		db	 02h, 96h, 9Ah, 02h, 0Ah, 55h
		db	 5Ah, 00h,0A9h, 5Fh,0D6h,0A0h
		db	 0Ah, 9Fh, 59h, 6Ah, 00h, 97h
		db	 6Ah,0A0h, 30h,0A5h,0A0h, 80h
		db	 02h, 2Ah, 60h, 00h, 0Ah, 82h
		db	0A0h, 80h,0A0h, 02h, 80h, 30h
		db	 00h, 80h, 88h, 00h, 00h, 00h
		db	 80h, 00h, 04h
data_8D8B	db	10h			; Data table (indexed access)
		db	9 dup (0)
		db	 08h, 20h, 30h, 00h, 00h, 28h
		db	 00h, 00h, 80h, 9Ah, 80h, 00h
		db	 2Ah, 55h, 60h, 00h, 29h,0F5h
		db	 80h, 00h, 25h,0D6h, 00h, 0Ch
		db	 09h,0F6h, 00h, 00h, 09h, 76h
		db	 80h, 00h, 26h, 95h,0A0h, 00h
		db	0A8h, 26h, 00h, 02h, 00h, 08h
		db	 00h, 00h, 03h, 00h
		db	0Ch
		db	8 dup (0)
data_8DCC	db	4			; Data table (indexed access)
		db	 10h, 00h
		db	12 dup (0)
		db	 30h, 00h, 00h, 00h, 00h, 02h
		db	 00h, 00h, 00h, 80h, 00h, 00h
		db	 32h, 80h, 00h, 00h, 09h,0A8h
		db	 00h, 00h,0A9h,0A0h, 00h, 00h
		db	 0Ah, 8Ch, 00h, 00h, 02h, 00h
		db	 00h, 00h, 80h, 00h, 00h, 00h
		db	 00h
data_8E00	db	30h
		db	13 dup (0)
		db	 04h, 10h, 00h, 3Ch, 14h, 00h
		db	 03h,0D5h, 51h, 40h, 0Fh, 55h
		db	 54h, 50h, 0Fh, 55h, 54h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 0Eh
		db	 20h, 00h, 00h, 3Ah,0A8h, 00h
		db	 00h, 0Eh, 20h, 00h, 00h, 3Ah
		db	0A8h, 00h, 00h, 0Eh, 20h, 00h
		db	 00h, 3Ah,0A8h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh, 55h, 54h, 50h
		db	 0Fh, 55h, 54h, 50h, 03h,0D5h
		db	 51h, 40h, 00h, 3Ch, 14h, 00h
		db	 04h, 10h
		db	9 dup (0)
		db	 14h, 14h, 00h, 01h, 55h, 15h
		db	 40h, 05h, 55h, 15h, 50h, 05h
		db	 55h, 55h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 0Eh, 20h, 00h, 00h
		db	 3Ah,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 55h, 50h, 05h
		db	 54h, 55h, 50h, 01h, 54h, 55h
		db	 40h, 00h, 14h, 14h, 00h
		db	8 dup (0)
		db	 04h, 10h
		db	17 dup (0)
		db	 14h, 14h, 00h, 03h,0C5h, 55h
		db	 40h, 0Fh, 15h, 55h, 50h, 0Fh
		db	 15h, 55h, 50h, 0Fh, 15h, 55h
		db	 50h, 0Fh, 15h, 55h, 50h, 03h
		db	0C5h, 55h, 40h, 00h, 14h, 14h
		db	 00h
		db	16 dup (0)
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 08h,0B0h, 00h, 00h, 82h
		db	0AEh, 00h, 0Ah, 0Ah,0ABh,0A0h
		db	 00h, 00h, 00h, 00h
		db	'UUUUiiii'
		db	0BEh
		db	7 dup (0BEh)
		db	 69h, 69h, 69h, 69h, 55h, 55h
data_8F00	db	55h			; Data table (indexed access)
		db	 55h, 00h, 00h, 00h, 00h, 0Ah
		db	 0Ah,0ABh,0A0h, 00h, 82h,0AEh
		db	 00h, 00h, 08h,0B0h, 00h, 00h
		db	 00h, 00h, 00h, 04h, 10h, 00h
		db	 00h, 00h, 00h, 00h, 0Eh, 20h
		db	 00h, 00h,0BAh, 82h, 00h, 0Ah
		db	0EAh,0A0h,0A0h, 00h, 00h, 00h
		db	 00h
		db	'UUUUiiii'
		db	0BEh
		db	7 dup (0BEh)
		db	'iiiiUUUU'
		db	 00h, 00h, 00h, 00h, 0Ah,0EAh
		db	0A0h,0A0h, 00h,0BAh, 82h, 00h
		db	 00h, 0Eh, 20h, 00h, 00h, 00h
		db	 00h, 00h, 04h, 10h, 00h, 00h
		db	 00h, 00h, 00h, 05h, 50h, 00h
		db	 00h, 55h, 55h, 00h, 05h, 40h
		db	 01h, 50h, 14h, 0Ah,0B0h, 14h
		db	 50h, 22h,0ACh, 05h, 50h, 8Ah
		db	0BBh, 05h, 50h,0AAh,0AEh, 05h
		db	 50h,0AAh,0ABh, 05h, 50h, 8Ah
		db	0AEh, 05h, 50h, 22h,0B8h, 05h
		db	 14h, 0Ah,0A0h, 14h, 05h, 40h
		db	 01h, 50h, 00h, 55h, 55h, 00h
		db	 00h, 05h, 50h, 00h, 00h, 00h
		db	 00h, 00h, 04h, 10h, 00h
		db	12 dup (0)
		db	 05h, 50h, 00h, 01h, 5Ah,0B5h
		db	 40h, 15h, 22h,0ACh, 54h, 54h
		db	 8Ah,0BBh, 15h, 50h,0AAh,0AEh
		db	 05h, 50h,0AAh,0ABh, 05h, 54h
		db	 2Ah,0ACh, 15h, 15h, 40h, 01h
		db	 54h, 01h, 55h, 55h, 40h, 00h
		db	 05h
		db	50h
		db	13 dup (0)
		db	 04h, 10h
		db	17 dup (0)
		db	 0Ah,0B0h, 00h, 00h, 22h,0ACh
		db	 00h, 04h, 8Ah,0BBh, 10h, 50h
		db	0AAh,0AEh, 05h, 55h, 00h, 00h
		db	 55h, 05h, 55h, 55h, 50h, 00h
		db	 55h, 55h, 00h, 00h, 0Ah,0E0h
		db	13 dup (0)
data_901A	db	0			; Data table (indexed access)
		db	 00h, 00h, 00h, 04h, 10h
		db	17 dup (0)
		db	 0Ah,0B0h, 00h, 00h, 22h,0ACh
		db	 00h, 00h, 00h, 00h, 00h
		db	'UUUUUUUU'
		db	 00h, 00h, 00h, 00h, 00h, 22h
		db	0B8h, 00h, 00h, 0Ah,0A0h, 00h
		db	 00h
		db	15 dup (0)
		db	 04h, 10h
		db	17 dup (0)
		db	 0Ah,0B0h, 00h, 00h, 55h, 55h
		db	 00h, 05h, 55h, 55h, 50h, 55h
		db	 00h, 00h, 55h, 50h,0AAh,0ABh
		db	 05h, 04h, 8Ah,0AEh, 10h, 00h
		db	 22h,0B8h, 00h, 00h, 0Ah,0A0h
		db	 00h, 00h
		db	15 dup (0)
		db	 04h, 10h
		db	13 dup (0)
		db	 05h, 50h, 00h, 01h, 55h, 55h
		db	 40h, 15h, 40h, 01h, 54h, 54h
		db	 0Ah,0A0h, 15h, 50h,0AAh,0AEh
		db	 05h, 50h,0AAh,0ABh, 05h, 54h
		db	 8Ah,0AEh, 15h, 15h, 22h,0B8h
		db	 54h, 01h, 5Ah,0A5h, 40h, 00h
		db	 05h
		db	50h
		db	13 dup (0)
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 22h,0ACh, 00h, 00h, 8Ah
		db	0ABh, 00h, 02h, 2Ah,0AAh,0C0h
		db	 08h, 8Ah,0ABh,0B0h, 22h, 2Ah
		db	0AAh,0ECh, 14h, 55h, 55h,0FCh
		db	 00h, 80h, 20h,0C8h, 0Bh, 0Ch
		db	 82h, 00h, 00h, 08h, 30h,0E0h
		db	 14h, 55h, 55h,0FCh, 22h, 2Ah
		db	0AAh,0ECh, 08h, 8Ah,0ABh,0B0h
		db	 02h, 2Ah,0AAh,0C0h, 00h, 8Ah
		db	0ABh, 00h, 00h, 22h,0ACh, 00h
		db	 04h, 10h, 00h
		db	8 dup (0)
		db	 22h,0ACh, 00h, 00h, 8Ah,0ABh
		db	 00h, 02h, 2Ah,0AAh,0C0h, 08h
		db	 8Ah,0ABh,0B0h, 22h, 2Ah,0AAh
		db	0ECh, 14h, 55h, 55h,0FCh, 08h
		db	 2Ch, 88h, 20h, 14h, 55h, 55h
		db	0FCh, 22h, 2Ah,0AAh,0ECh, 08h
		db	 8Ah,0ABh,0B0h, 02h, 2Ah,0AAh
		db	0C0h, 00h, 8Ah,0ABh, 00h, 00h
		db	 22h,0ACh, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0ABh, 00h, 0Ah
		db	0AAh,0AAh,0E0h, 22h,0AAh,0AAh
		db	0B8h, 2Ah,0AAh,0AAh,0ACh, 8Ah
		db	0AAh,0AAh,0BBh,0AAh,0AAh,0AAh
		db	0AEh, 0Ah,0AAh,0AAh,0A0h,0A0h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AEh, 8Ah,0AAh,0AAh,0BBh, 2Ah
		db	0AAh,0AAh,0ACh, 22h,0AAh,0AAh
		db	0B8h, 0Ah,0AAh,0AAh,0E0h, 00h
		db	0AAh,0ABh, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0ABh, 00h, 0Ah
		db	0AAh,0AAh,0B0h, 22h,0AAh,0AAh
		db	0ACh, 2Ah, 00h, 00h,0A8h, 80h
		db	0F0h, 0Fh, 02h, 3Fh,0C0h, 03h
		db	0FCh, 0Ch, 03h,0C0h,0FEh,0B3h
		db	 03h,0C0h,0FEh, 3Fh,0C0h, 03h
		db	 3Ch, 80h,0F0h, 0Fh, 02h, 2Ah
		db	 00h, 00h,0A8h, 22h,0AAh,0AAh
		db	0ACh, 0Ah,0AAh,0AAh,0B0h, 00h
		db	0AAh,0ABh, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh, 00h, 0Ah
		db	 80h, 02h,0A0h, 28h, 15h, 54h
		db	 28h, 21h, 4Fh,0F1h, 48h, 87h
		db	0F0h, 0Fh,0D2h, 1Fh,0C0h, 03h
		db	0F4h, 8Ch, 03h,0C0h,0F6h, 93h
		db	 03h,0C0h,0F2h, 07h,0C0h, 03h
		db	 04h, 87h,0F0h, 0Fh,0D2h, 21h
		db	0FCh,0F1h, 48h, 28h, 51h, 54h
		db	 28h, 0Ah, 00h, 02h,0A0h, 00h
		db	0AAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h
data_922E	db	4			; Data table (indexed access)
		db	10h
data_9230	dw	0F00h, 50h
data_9234	dw	0FD00h, 45h
data_9238	dw	0F503h, 4051h
		db	 00h, 00h, 00h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 2Eh,0AAh
		db	0A8h, 88h, 2Eh,0AAh,0A8h, 88h
		db	 00h, 00h, 00h, 00h, 03h,0F5h
		db	 51h, 40h, 00h,0FDh, 45h, 00h
		db	 00h, 0Fh
		db	50h
		db	13 dup (0)
		db	 04h, 10h
		db	13 dup (0)
		db	 0Fh, 50h, 00h, 00h,0FDh, 45h
		db	 00h, 03h,0F5h, 51h, 40h, 00h
		db	 00h, 00h, 00h, 2Eh,0AAh,0A8h
		db	 88h, 2Eh,0AAh,0A8h, 88h, 00h
		db	 00h, 00h, 00h, 03h,0F5h, 51h
		db	 40h, 00h,0FDh, 45h, 00h, 00h
		db	 0Fh
		db	50h
		db	13 dup (0)
		db	 04h, 10h
		db	13 dup (0)
		db	 0Fh, 50h, 00h, 00h,0FDh, 45h
		db	 00h, 03h,0F5h, 51h, 40h, 00h
		db	 00h, 00h, 00h, 2Eh,0AAh,0A8h
		db	 88h, 2Eh,0AAh,0A8h, 88h, 00h
		db	 00h, 00h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 03h,0C0h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0F5h, 51h
		db	 40h, 00h,0FDh, 45h, 00h, 00h
		db	 0Fh, 50h, 00h, 04h, 10h, 05h
		db	 00h, 00h, 20h, 15h, 40h, 02h
		db	 88h, 05h, 00h, 0Ah,0A2h, 00h
		db	 0Fh,0FAh,0AAh, 0Fh,0FFh,0FFh
		db	0A8h, 3Fh,0C0h,0FFh,0C0h,0FCh
		db	 3Fh,0FFh,0F0h,0F3h,0FFh,0FFh
		db	 30h,0F3h,0FFh,0FFh, 3Ch, 3Ch
		db	0FFh,0F0h,0FCh, 0Fh,0FFh, 0Fh
		db	0F0h, 00h,0FFh,0F0h, 00h, 0Ah
		db	 00h, 00h, 00h, 28h, 80h, 00h
		db	 00h, 2Ah, 80h, 00h, 00h, 0Ah
		db	 00h, 00h, 00h, 04h, 10h
		db	10 dup (0)
		db	 0Dh, 00h, 00h, 00h, 35h, 40h
		db	 00h, 3Fh, 0Dh, 00h, 03h,0FFh
		db	0C0h, 00h, 0Fh,0EBh,0EAh, 00h
		db	 03h,0AAh,0A8h, 80h, 02h,0A8h
		db	0AAh, 20h, 0Ah, 82h,0AAh,0A0h
		db	 02h,0AAh, 0Ah, 80h, 00h, 28h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 01h, 7Ch, 00h, 00h, 01h, 50h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h
		db	15 dup (0)
		db	 0Ch, 00h, 3Ch, 00h, 3Ch, 00h
		db	0CFh, 00h, 00h, 00h,0FFh, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 55h
		db	 00h, 00h, 01h, 41h, 40h, 00h
		db	 01h, 55h, 50h, 00h, 00h, 55h
		db	 0Ah, 00h, 00h, 00h, 22h,0A0h
		db	 00h, 00h,0AAh, 80h, 00h, 00h
		db	 0Ah, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 0Fh, 50h, 00h
		db	 00h,0FDh, 51h, 00h, 03h,0F5h
		db	 54h, 40h, 0Fh,0D5h, 55h, 10h
		db	 0Fh,0D5h, 54h, 50h, 3Ah,0A8h
		db	 2Ah, 88h,0EAh,0A1h, 4Ah,0A2h
		db	0BAh, 85h, 52h, 88h,0EAh,0A1h
		db	 4Ah,0A2h, 3Ah,0A8h, 2Ah, 88h
		db	 00h, 00h, 00h, 00h, 00h, 29h
		db	 68h, 00h, 00h,0A5h, 5Ah, 00h
		db	 00h,0A9h,0AAh, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h, 02h, 80h, 00h
		db	 04h, 10h, 00h, 0Fh, 50h, 00h
		db	 00h,0FDh, 51h, 00h, 03h,0F5h
		db	 54h, 40h, 0Fh,0D5h, 55h, 10h
		db	 0Fh,0D5h, 54h, 50h, 3Ah,0A8h
		db	 2Ah, 88h,0EAh,0A3h,0CAh,0A2h
		db	0BAh, 8Fh,0F2h, 88h,0EAh,0A3h
		db	0CAh,0A2h, 3Ah,0A8h, 2Ah, 88h
		db	 00h, 00h, 00h, 00h, 00h, 01h
		db	 20h, 00h, 00h, 08h, 00h, 00h
		db	 00h, 00h, 40h, 00h, 00h, 00h
		db	 20h, 00h, 00h, 00h, 00h, 00h
data_943E	db	4			; Data table (indexed access)
		db	 10h, 00h, 0Fh,0F0h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 0Fh,0F0h
		db	 00h, 00h,0A0h, 0Eh, 00h, 00h
		db	 2Ah,0BBh, 00h, 00h, 8Ah,0AEh
		db	 00h, 00h, 2Ah,0BBh, 00h, 05h
		db	 8Ah,0AEh, 70h, 50h, 2Ah,0B8h
		db	 0Fh, 55h, 00h, 00h, 7Fh, 55h
		db	 55h, 55h, 7Fh, 55h, 55h, 55h
		db	 7Fh, 05h, 55h, 55h, 70h, 00h
		db	 55h, 55h, 00h, 00h, 8Ah,0BBh
		db	 00h, 00h, 0Ah,0A0h, 00h, 04h
		db	 10h, 00h, 0Fh,0F0h, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 0Fh,0F0h
		db	 00h, 00h,0A0h, 0Eh, 00h, 05h
		db	 2Ah,0ABh, 70h, 50h, 0Ah,0ACh
		db	 0Fh, 55h, 00h, 00h, 7Fh, 55h
		db	 55h, 55h, 7Fh, 55h, 55h, 55h
		db	 7Fh, 05h, 55h, 55h, 70h, 00h
		db	 55h, 55h, 00h, 00h, 2Ah,0AEh
		db	 00h, 00h, 8Ah,0BBh, 00h, 00h
		db	 2Ah,0AEh, 00h, 00h, 8Ah,0BBh
		db	 00h, 00h, 0Ah,0A0h, 00h
data_94C2	db	4			; Data table (indexed access)
		db	 10h, 00h, 0Fh,0F0h, 00h, 00h
		db	0FFh,0FFh, 00h, 05h, 0Fh,0F0h
		db	 70h, 50h, 20h, 08h, 0Fh, 55h
		db	 00h, 00h, 7Fh, 55h, 55h, 55h
		db	 7Fh, 55h, 55h, 55h, 7Fh, 05h
		db	 55h, 55h, 70h, 00h, 55h, 55h
		db	 00h, 00h, 2Ah,0AEh, 00h, 00h
		db	 8Ah,0BBh, 00h, 00h, 2Ah,0AEh
		db	 00h, 00h, 8Ah,0BBh, 00h, 00h
		db	 2Ah,0AEh, 00h, 00h, 8Ah,0BBh
		db	 00h, 00h, 0Ah,0A0h, 00h, 04h
		db	 10h, 00h, 50h, 50h, 00h, 05h
		db	 10h, 55h, 00h
		db	'QUUPEUUP'
		db	 04h, 00h, 01h, 00h, 00h, 0Fh
		db	0F0h, 00h, 00h,0F0h,0F0h, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 0Fh
		db	0F0h, 00h, 00h,0F0h,0F0h, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 0Fh
		db	0F0h, 00h, 00h,0F0h,0F0h, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 3Fh
		db	0C0h, 00h, 00h, 0Fh, 00h, 00h
		db	 04h, 10h, 00h, 55h, 50h, 00h
		db	 05h, 55h, 55h, 00h
		db	'UUUPUUUP'
		db	 04h, 00h, 01h, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 0Fh,0F0h, 00h
		db	 00h,0F0h,0F0h, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 0Fh,0F0h, 00h
		db	 00h,0F0h,0F0h, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 0Fh,0F0h, 00h
		db	 00h,0F0h,0F0h, 00h, 00h, 3Fh
		db	0C0h, 00h, 00h, 0Fh, 00h, 00h
		db	 04h, 10h, 00h, 50h, 50h, 00h
		db	 05h, 50h, 45h, 00h, 55h, 55h
		db	 54h, 50h, 55h, 55h, 55h, 10h
		db	 04h, 00h, 01h, 00h, 00h,0F0h
		db	0F0h, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h,0F0h
		db	0F0h, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h,0F0h
		db	0F0h, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h, 3Fh
		db	0C0h, 00h, 00h, 0Fh, 00h, 00h
		db	 04h, 10h, 00h, 2Ah,0E8h, 00h
		db	 02h,0ABh,0AAh, 80h, 0Ah,0A2h
		db	0CAh,0A0h, 28h,0AAh,0AAh, 28h
		db	 2Ah, 80h, 02h,0A8h,0A8h, 3Fh
		db	 54h, 2Ah,0A3h,0FFh, 55h, 4Ah
		db	0A3h,0F5h, 55h, 4Ah,0A1h, 55h
		db	 55h, 4Ah,0A1h, 55h, 55h, 4Ah
		db	0A8h, 15h, 54h, 2Ah, 2Ah, 80h
		db	 02h,0A8h, 2Ah,0AAh,0AAh,0A8h
		db	 0Ah,0AAh,0AAh,0A0h, 02h,0AAh
		db	0AAh, 80h, 00h, 2Ah,0A8h, 00h
		db	 04h, 10h, 00h, 2Ah,0A8h, 00h
		db	 02h,0AAh,0ABh, 80h, 0Ah,0AAh
		db	0AAh,0E0h, 2Ah,0AAh,0A8h,0A8h
		db	 2Ah,0AAh,0AAh, 80h,0AAh,0AAh
		db	0A8h, 15h,0AAh,0AAh,0A1h, 55h
		db	0AAh,0AAh,0A1h, 55h,0AAh,0AAh
		db	0A1h, 55h,0AAh,0AAh,0A1h, 55h
		db	0AAh,0AAh,0A8h, 15h, 2Ah,0AAh
		db	0AAh, 80h, 22h,0AAh,0AAh,0A8h
		db	 08h,0AAh,0AAh,0A0h, 02h, 22h
		db	0AAh, 80h, 00h, 08h,0A8h, 00h
		db	 04h, 10h, 00h, 2Ah,0A8h, 00h
		db	 02h,0AAh,0AAh, 80h, 0Ah,0AAh
		db	0AAh,0A0h, 2Ah,0AAh,0AAh,0A8h
		db	 2Ah,0AAh,0AAh,0A8h
		db	24 dup (0AAh)
		db	 2Ah,0AAh,0AAh,0A8h, 2Ah,0A8h
		db	 8Ah,0A8h, 0Ah,0A2h, 2Ah,0A0h
		db	 02h,0A8h, 8Ah, 80h, 00h, 2Ah
		db	 28h, 00h, 04h, 10h, 00h, 2Ah
		db	0A8h, 00h, 02h,0EAh,0AAh, 80h
		db	 0Bh,0AAh,0AAh,0A0h, 2Ah, 2Ah
		db	0AAh,0A8h, 02h,0AAh,0AAh,0A8h
		db	 54h, 2Ah,0AAh,0AAh, 55h, 4Ah
		db	0AAh,0AAh, 55h, 4Ah,0AAh,0AAh
		db	 55h, 4Ah,0AAh,0AAh, 55h, 4Ah
		db	0AAh,0AAh, 54h, 2Ah,0AAh,0AAh
		db	 02h,0AAh,0AAh,0A8h, 2Ah,0AAh
		db	0AAh, 88h, 0Ah,0AAh,0AAh, 20h
		db	 02h,0AAh, 88h, 80h, 00h, 2Ah
		db	 20h, 00h
		db	 0Ch, 08h
		db	12 dup (8)
		db	12 dup (28h)
		db	12 dup (0AAh)
		db	12 dup (0)
		db	12 dup (10h)
		db	12 dup (0)
		db	12 dup (0AAh)
		db	12 dup (0)
		db	 04h, 10h, 00h, 05h, 70h, 00h
		db	 00h, 51h, 4Fh, 00h, 03h, 14h
		db	 55h,0C0h, 04h,0F5h, 14h, 30h
		db	 0Dh,0D0h,0C1h, 70h, 07h, 07h
		db	 55h, 00h, 00h, 55h, 50h, 00h
		db	 00h, 00h, 00h, 00h, 00h
		db	0Ah
		db	7 dup (0)
		db	0A0h, 60h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 09h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 05h, 70h, 00h, 00h
		db	 51h, 4Fh, 00h, 03h, 14h, 55h
		db	0C0h, 04h,0F5h, 14h, 30h, 0Dh
		db	0D0h,0C1h, 70h, 07h, 07h, 55h
		db	 00h, 00h, 55h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 00h, 00h, 0Ah, 80h, 00h, 00h
		db	 29h,0A0h, 00h, 00h, 25h, 60h
		db	 00h, 00h, 09h,0A0h, 00h, 00h
		db	 02h, 80h, 00h, 00h, 02h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 3Dh, 54h, 00h, 00h, 35h, 54h
		db	 00h, 0Ah, 15h, 54h,0A0h, 2Eh
		db	 05h, 50h,0B8h, 2Ah, 81h, 42h
		db	0A8h,0AAh,0E0h, 0Bh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ABh,0EAh
		db	0AAh,0AAh,0AAh

locloop_97E0:
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		sub	ch,ss:data_A8AA[bp+si]
		sub	ch,ss:data_A8AA[bp+si]
		or	ch,byte ptr ss:data_A0AA[bp+si]	; ('        ')
		add	ch,ss:data_80AA[bp+si]
		add	[bx+si],ch
		sub	[bx+si],al
		db	 00h, 00h, 00h, 00h, 04h, 10h
		db	 00h, 00h, 00h, 00h, 00h, 2Bh
		db	0E8h, 00h, 02h,0AAh,0AAh, 80h
		db	 0Ah,0E0h, 0Bh,0A0h, 2Ah, 83h
		db	0C2h,0A8h, 2Ah, 0Fh,0F0h,0A8h
		db	0AEh, 3Fh, 54h,0BAh,0AAh, 3Dh
		db	 54h,0AAh,0AAh, 35h, 54h,0AAh
		db	0AEh, 15h
data_9822	db	54h			; Data table (indexed access)
		db	0BAh, 2Ah, 05h, 50h,0A8h, 2Ah
		db	 81h, 42h,0A8h, 0Ah,0E0h, 0Bh
		db	0A0h, 02h,0AAh,0AAh, 80h, 00h
		db	 2Bh,0E8h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 28h, 28h, 00h, 02h
		db	0AAh,0AAh, 80h, 0Ah,0AAh,0AAh
		db	0A0h, 2Ah,0AAh,0AAh,0A8h, 2Ah
		db	0AAh,0AAh,0A8h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0ABh,0EAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0E0h, 0Bh
		db	0AAh, 2Ah, 83h,0C2h,0A8h, 2Eh
		db	 0Fh,0F0h,0B8h, 0Ah, 3Fh, 54h
		db	0A0h, 02h, 3Dh, 54h, 80h, 00h
		db	 35h, 54h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 2Ah,0A8h, 00h, 02h
		db	0AAh,0AAh, 80h, 0Ah,0AAh,0AAh
		db	0A0h, 2Ah,0AAh,0AAh,0A8h, 2Ah
		db	0AAh,0AAh,0A8h,0AAh,0A8h, 2Ah
		db	0AAh,0AAh,0A3h,0CAh,0AAh,0AAh
		db	0A3h,0CAh,0AAh,0AAh,0A8h, 2Ah
		db	0AAh, 2Ah,0AAh,0AAh,0A8h, 2Ah
		db	0AAh,0AAh,0A8h, 0Ah,0AAh,0AAh
		db	0A0h, 02h,0AAh,0AAh, 80h, 00h
		db	 2Ah,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h
		db	8 dup (0)
		db	0B2h, 0Eh, 00h, 03h,0B0h, 8Eh
		db	0C0h, 0Fh,0B1h, 0Eh,0F0h, 3Fh
		db	0B4h, 4Eh,0FCh,0F5h,0B1h, 2Eh
		db	 5Fh,0D5h,0B8h, 0Eh, 57h, 55h
		db	0B0h, 4Eh, 55h,0D5h,0B1h, 1Eh
		db	 57h,0F5h,0B8h, 4Eh, 5Fh, 3Fh
		db	0B0h, 2Eh,0FCh, 0Fh,0B1h, 0Eh
		db	0F0h, 03h,0B4h, 4Eh,0C0h, 00h
		db	0B1h, 0Eh, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h
		db	8 dup (0)
		db	 0Bh,0E0h, 00h, 00h, 1Bh,0E4h
		db	 00h, 00h, 5Bh,0E5h, 00h, 01h
		db	 5Bh,0E5h, 40h, 05h,0FBh,0EFh
		db	 50h, 07h,0FBh,0EFh,0D0h, 0Fh
		db	0FBh,0EFh,0F0h, 07h,0FBh,0EFh
		db	0D0h, 05h,0FBh,0EFh, 50h, 01h
		db	 5Bh,0E5h, 40h, 00h, 5Bh,0E5h
		db	 00h, 00h, 1Bh,0E4h, 00h, 00h
		db	 0Bh,0E0h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 0Ah,0A0h, 00h, 00h
		db	0BAh,0A2h, 00h, 02h,0EAh,0A8h
		db	 80h, 0Bh,0AAh,0AAh, 20h, 00h
		db	0EAh,0A8h, 80h, 3Fh, 05h, 55h
		db	 44h,0C3h,0C1h, 55h, 11h,0C3h
		db	0C1h, 55h, 45h, 3Fh, 05h, 55h
		db	 14h, 00h,0EAh,0A8h, 80h, 0Bh
		db	0AAh,0AAh, 20h, 02h,0EAh,0A8h
		db	 80h, 00h,0BAh,0A2h, 00h, 00h
		db	 0Ah,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh,0A0h, 00h, 00h
		db	0AAh,0EAh, 00h, 02h,0ABh,0AAh
		db	 80h, 0Ah,0AAh,0EAh,0A0h, 0Ah
		db	 80h, 02h,0A0h, 15h, 0Fh,0F0h
		db	 54h, 54h, 3Ch, 3Ch, 15h, 54h
		db	 3Ch, 3Ch, 15h, 15h, 0Fh,0F0h
		db	 54h, 0Ah, 80h, 02h,0A0h, 0Ah
		db	0AAh,0EAh,0A0h, 02h,0ABh,0AAh
		db	 80h, 00h,0AAh,0EAh, 00h, 00h
		db	 0Bh,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 00h
		db	 00h, 00h, 0Ah,0A0h, 00h, 00h
		db	 8Ah,0AEh, 00h, 02h, 2Ah,0ABh
		db	 80h, 08h,0AAh,0AAh,0E0h, 02h
		db	 2Ah,0ABh, 00h, 11h, 55h, 50h
		db	0FCh, 44h, 55h, 43h,0C3h, 51h
		db	 55h, 43h,0C3h, 14h, 55h, 50h
		db	0FCh, 02h, 2Ah,0ABh, 00h, 08h
		db	0AAh,0AAh,0E0h, 02h, 2Ah,0ABh

locloop_99FD:
		add	byte ptr [bx+si],8Ah
		scasb				; Scan es:[di] for al
		add	[bx+si],al
;*		or	ah,ds:data_0000_e[bx+si]
		db	 0Ah,0A0h, 00h, 00h	;  Fixup - byte match
		add	[bx+si],al
		add	[si],al
		adc	[bx+si],al
		db	 00h, 00h, 00h, 00h, 08h,0A0h
		db	 00h, 00h,0A2h, 2Ah, 00h, 02h
		db	0A8h, 8Ah, 80h, 0Ah,0A2h, 2Ah
		db	0A0h, 0Ah,0A8h, 8Ah,0A0h, 15h
		db	 51h, 15h, 54h, 55h, 54h, 45h
		db	 55h, 55h, 51h, 15h, 55h, 15h
		db	 54h, 45h, 54h, 0Ah,0A2h, 2Ah
		db	0A0h, 0Ah,0A8h, 8Ah,0A0h, 02h
		db	0A2h, 2Ah, 80h, 00h,0A8h, 8Ah
		db	 00h, 00h, 0Ah, 20h, 00h, 00h
		db	 00h, 00h, 00h, 04h, 10h, 00h
		db	 07h,0F0h, 00h, 00h, 51h, 7Fh
		db	 00h, 01h, 45h, 5Fh,0C0h, 05h
		db	 55h, 57h,0F0h, 05h, 95h, 56h
		db	0F0h, 8Ah,0AAh,0AAh,0AAh, 8Ah
		db	0AAh,0AAh,0AAh, 0Eh,0FBh,0EFh
		db	0B0h, 0Ah,0FAh,0AFh,0A0h, 02h
		db	0AAh,0AAh, 80h, 00h, 2Ah,0A8h
		db	 00h
		db	20 dup (0)
		db	 04h, 10h, 00h, 0Fh,0F0h, 00h
		db	 00h,0FDh, 45h, 00h, 03h,0F5h
		db	 51h, 40h, 0Fh,0D5h, 55h, 50h
		db	 0Fh, 95h, 56h, 50h,0AAh,0AAh
		db	0AAh,0A2h,0AAh,0AAh,0AAh,0A2h
		db	 0Eh,0FBh,0EFh,0B0h, 0Ah,0ABh
		db	0EAh,0A0h, 02h,0AAh,0AAh, 80h
		db	 00h, 2Ah,0A8h, 00h, 00h, 00h
		db	0C0h, 00h, 00h, 01h, 30h, 00h
		db	 00h, 00h,0C0h, 00h, 00h, 00h
		db	 10h, 00h, 00h, 03h, 00h, 00h
		db	 04h, 10h, 00h
		db	7 dup (0)
		db	 01h,0FCh, 00h, 00h, 0Ch, 5Fh
		db	0C0h, 00h, 1Fh, 05h,0F0h, 00h
		db	 14h,0F1h, 5Fh, 00h, 57h, 3Ch
		db	0D5h,0C0h, 55h, 73h, 00h, 70h
		db	 5Fh, 57h, 15h, 04h, 13h,0D4h
		db	 55h, 5Ch, 04h,0D4h, 57h, 70h
		db	 04h,0D1h, 7Ch, 30h, 01h, 51h
		db	 43h,0C0h, 00h, 13h,0FCh
		db	9 dup (0)
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 70h, 00h, 00h, 03h
		db	 1Fh, 00h, 00h, 0Dh, 14h,0C0h
		db	 00h, 34h, 5Ch,0C0h, 00h, 34h
		db	 57h, 30h, 00h,0D4h, 57h, 30h
		db	 03h,0DCh, 15h, 70h, 03h, 53h
		db	0C1h, 70h, 0Fh, 4Ch, 54h, 00h
		db	 0Dh, 3Dh, 55h, 50h, 0Dh, 31h
		db	 7Fh, 40h, 04h,0C5h,0F0h, 40h
		db	 03h,0D5h,0C5h, 00h, 00h, 55h
		db	 50h, 00h, 00h, 05h, 40h, 00h
		db	 04h, 10h, 00h, 0Dh, 00h, 00h
		db	 00h,0F4h,0C0h, 00h, 03h, 14h
		db	 70h, 00h, 03h, 35h, 1Ch, 00h
		db	 0Ch,0D5h, 1Ch, 00h, 0Ch,0D5h
		db	 17h, 00h, 0Dh, 54h, 37h,0C0h
		db	 0Dh, 43h,0C5h,0C0h, 00h, 15h
		db	 31h,0F0h, 05h, 55h, 7Ch, 70h
		db	 01h,0FDh, 4Ch, 70h, 01h, 0Fh
		db	 53h, 10h, 00h, 53h, 57h,0C0h
		db	 00h, 05h, 55h, 00h, 00h, 01h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h
		db	9 dup (0)
		db	 3Fh, 40h, 00h, 03h,0F5h, 30h
		db	 00h, 0Fh, 50h,0F4h, 00h,0F5h
		db	 4Fh, 14h, 03h, 57h, 3Ch, 55h
		db	 0Dh, 00h,0C5h, 55h, 10h, 54h
		db	0D5h,0F5h, 35h, 55h, 17h,0C4h
		db	 0Dh,0D5h, 17h, 10h, 0Ch, 3Dh
		db	 47h, 10h, 03h,0C1h, 45h, 40h
		db	 00h, 3Fh,0C4h, 00h
		db	8 dup (0)
		db	 06h, 07h, 00h, 00h, 00h, 00h
		db	 3Fh, 00h, 00h, 00h, 00h, 03h
		db	0F0h, 00h, 2Ah, 3Eh,0FBh,0CFh
		db	0CAh,0A8h, 8Ah, 3Eh,0FBh,0CFh
		db	 29h, 6Ah, 2Ah, 16h, 59h, 47h
		db	0CAh,0A0h, 00h, 00h, 00h, 01h
		db	 70h, 00h, 00h, 00h, 00h, 00h
		db	 15h, 00h, 06h, 07h, 00h, 00h
		db	 00h, 00h, 3Fh, 00h, 00h, 00h
		db	 00h, 03h,0F0h, 00h, 2Ah, 3Eh
		db	0FBh,0CFh,0C2h, 80h, 8Ah, 3Eh
		db	0FBh,0CFh, 09h,0A0h, 2Ah, 16h
		db	 59h, 47h,0C2h, 00h, 00h, 00h
		db	 00h, 01h, 70h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 00h, 06h, 07h
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	 0Ah, 03h, 55h,0C3h,0C0h,0A0h
		db	 2Ah,0BDh, 00h, 7Dh, 4Ah, 68h
		db	0AAh, 95h, 14h, 55h, 69h, 5Ah
		db	 2Ah, 95h, 00h, 55h, 4Ah, 58h
		db	 0Ah, 01h, 14h, 41h, 42h,0A0h
		db	 00h, 00h, 55h, 00h, 00h, 00h
		db	 06h, 07h, 00h, 00h,0FFh, 00h
		db	 00h, 00h, 0Ah, 03h, 55h,0C3h
		db	0C0h, 00h, 2Ah,0BDh, 00h, 7Dh
		db	 42h, 00h,0AAh, 95h, 14h, 55h
		db	 49h,0A0h, 2Ah, 95h, 00h, 55h
		db	 42h, 80h, 0Ah, 01h, 14h, 41h
		db	 40h, 00h, 00h
data_9C83	dw	5500h			; Data table (indexed access)
		db	 00h, 00h, 00h, 08h, 0Ch, 00h
		db	 00h, 02h, 00h, 00h, 00h, 02h
		db	 00h, 00h, 00h, 02h, 00h, 80h
		db	 00h, 28h, 00h, 02h, 03h, 02h
		db	 82h,0A0h,0C2h,0A8h, 00h, 00h
		db	0A8h, 0Ah,0AAh, 6Ah, 0Ah, 60h
		db	 00h, 00h, 0Ah,0A9h, 69h, 56h
		db	0A9h, 60h, 00h, 00h, 02h, 95h
		db	0D5h, 75h, 55h,0CAh, 00h, 02h
		db	0A2h, 5Dh, 5Fh, 57h, 69h, 68h
		db	0A0h, 00h,0A9h,0D6h, 95h, 95h
		db	0AAh,0A0h, 00h, 00h, 29h, 5Ah
		db	0A6h,0AAh, 82h, 80h, 00h, 00h
		db	0AAh,0A8h, 2Ah, 28h, 00h, 28h
		db	 00h, 02h, 82h, 80h, 28h, 00h
		db	 0Ch, 00h, 00h, 08h, 00h, 20h
		db	 20h, 00h, 00h, 00h, 00h, 08h
		db	 0Ch, 00h
		db	11 dup (0)
		db	 20h, 00h, 00h, 00h, 00h, 02h
		db	 02h, 00h
data_9D00	db	20h			; Data table (indexed access)
		db	0C0h, 00h, 00h, 00h, 00h,0A8h
		db	 02h,0AAh, 00h, 80h, 00h, 00h
		db	 02h,0AAh,0AAh, 9Ah, 8Ah, 00h
		db	 00h, 00h, 00h, 2Ah, 55h, 95h
		db	0A8h, 00h, 00h, 00h, 00h, 09h
		db	 5Dh, 5Dh, 68h, 00h, 00h, 00h
		db	 00h,0AAh, 65h,0D6h,0A0h,0C0h
		db	 00h, 00h, 00h, 0Ah,0AAh, 2Ah
		db	0A8h, 00h, 00h, 00h, 00h, 02h
		db	 02h,0A0h,0AAh, 00h, 00h, 00h
		db	 00h, 28h,0C0h, 80h, 28h, 00h
		db	 00h
		db	8 dup (0)
		db	 08h, 0Ch
		db	19 dup (0)
		db	0C2h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 02h, 08h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 09h, 80h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0A5h, 6Ah, 00h, 00h, 00h, 00h
		db	 00h, 00h, 09h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 02h, 02h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 0Ch, 00h
		db	26 dup (0)
		db	 08h, 0Ch
		db	35 dup (0)
		db	 08h,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 30h, 80h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 30h
		db	 00h
		db	42 dup (0)
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h,0AAh
		db	0AAh, 00h, 0Ah,0A0h, 0Ah,0A0h
		db	 2Ah, 00h, 00h,0A8h, 28h, 00h
		db	 00h, 28h,0A8h, 05h, 10h, 2Ah
		db	0A0h, 15h, 44h, 0Ah,0A0h, 15h
		db	 44h, 0Ah,0A8h, 05h, 50h, 2Ah
		db	 28h, 00h, 00h, 28h, 2Ah, 00h
		db	 00h,0A8h, 0Ah,0A0h, 0Ah,0A0h
		db	 00h,0AAh,0AAh, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h,0AAh
		db	0AAh, 00h, 02h,0A8h, 0Ah, 80h
		db	 02h,0A0h, 02h, 80h, 0Ah,0A0h
		db	 02h,0A0h, 0Ah, 85h, 10h,0A0h
		db	 0Ah, 85h, 44h,0A0h, 0Ah, 85h
		db	 44h,0A0h, 0Ah, 85h, 50h,0A0h
		db	 0Ah,0A0h, 02h,0A0h, 02h,0A0h
		db	 02h, 80h, 02h,0A8h, 0Ah, 80h
		db	 00h,0AAh,0AAh, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h, 2Ah,0A8h, 00h
		db	 00h,0AAh, 0Ah, 00h, 00h,0AAh
		db	 0Ah, 00h, 00h,0AAh, 12h, 00h
		db	 00h,0AAh, 04h, 00h, 00h,0AAh
		db	 04h, 00h, 00h,0AAh, 12h, 00h
		db	 00h,0AAh, 0Ah, 00h, 00h,0AAh
		db	 0Ah, 00h, 00h, 2Ah,0A8h, 00h
		db	 00h, 2Ah,0A8h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 0Ah,0A0h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 0Ah,0A0h, 00h
		db	 00h, 1Ah,0A4h, 00h, 00h, 1Ah
		db	0A4h, 00h, 00h, 0Ah,0A0h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 0Ah,0A0h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h, 2Ah,0A8h, 00h
		db	 00h,0A0h,0AAh, 00h, 00h,0A0h
		db	0AAh, 00h, 00h, 84h,0AAh, 00h
		db	 00h, 14h,0AAh, 00h, 00h, 14h
		db	0AAh, 00h, 00h, 84h,0AAh, 00h
		db	 00h,0A0h,0AAh, 00h, 00h,0A0h
		db	0AAh, 00h, 00h, 2Ah,0A8h, 00h
		db	 00h, 2Ah,0A8h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h,0AAh
		db	0AAh, 00h, 02h,0A0h, 2Ah, 80h
		db	 02h, 80h, 0Ah, 80h, 0Ah, 80h
		db	 0Ah,0A0h, 0Ah, 05h, 12h,0A0h
		db	 0Ah, 15h, 42h,0A0h, 0Ah, 15h
		db	 42h,0A0h, 0Ah, 05h, 52h,0A0h
		db	 0Ah, 80h, 0Ah,0A0h, 02h, 80h
		db	 0Ah, 80h, 02h,0A0h, 2Ah, 80h
		db	 00h,0AAh,0AAh, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 10h, 51h, 00h
		db	'E Q(E*Q*E*Q*E*Q*E*Q*E*Q(E Q'
		db	 00h, 00h, 00h, 02h, 10h, 00h
		db	 45h, 08h, 51h, 28h, 45h,0A8h
		db	 51h,0A8h, 45h,0A8h, 51h,0A8h
		db	 45h,0A8h, 51h,0A8h, 45h,0A8h
		db	 51h,0A8h, 45h,0A8h, 51h, 28h
		db	 45h, 08h, 51h, 00h, 45h, 00h
		db	 00h
data_9FE0	db	4			; Data table (indexed access)
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 15h, 28h, 00h, 03h,0FCh, 4Ah
		db	 80h, 0Ch,0F3h, 52h,0A0h, 3Ch
		db	 33h,0D2h,0A8h, 32h, 8Fh,0C4h
		db	0A8h,0C8h, 23h,0C4h,0AAh,0C8h
		db	20h
data_A000	db	14h			; Data table (indexed access)
		db	0AAh,0C8h, 23h,0C0h,0AAh,0C8h
		db	 23h,0D4h,0AAh, 32h, 8Fh,0D4h
		db	0A8h, 3Ch, 30h,0D2h,0A8h, 0Ch
		db	0FFh, 12h,0A0h, 03h,0FDh
		db	4Ah
data_A019	db	80h
		db	 00h, 15h, 28h, 00h
data_A01E	db	0
		db	 00h, 00h, 00h, 04h, 10h, 00h
		db	 00h, 00h, 00h, 00h, 15h, 44h
		db	 00h, 01h, 3Fh,0C5h, 40h, 07h
		db	0CFh, 3Fh, 10h, 1Fh,0CCh, 30h
		db	0D4h, 1Fh,0F2h, 8Fh,0F4h, 43h
		db	0C8h, 23h,0F1h, 7Ch, 08h, 23h
		db	0CDh, 03h,0C8h, 20h, 3Dh, 7Fh
		db	0C8h, 23h,0C1h, 1Fh,0F2h, 8Fh
		db	0F4h, 17h,0CCh, 30h,0D4h, 04h
		db	 3Fh, 3Fh, 10h, 01h, 5Ch,0F5h
		db	 40h, 00h, 14h, 54h, 00h, 00h
		db	 00h, 00h, 00h
data_A064	db	4			; Data table (indexed access)
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 28h, 54h, 00h, 02h,0A1h, 3Fh
		db	0C0h, 0Ah, 85h,0CFh, 30h, 2Ah
		db	 87h,0CCh, 3Ch, 2Ah, 13h,0F2h
		db	 8Ch,0AAh, 13h,0C8h, 23h,0AAh
		db	 14h, 08h, 23h,0AAh, 03h,0C8h
		db	 23h,0AAh, 17h,0C8h, 23h, 2Ah
		db	 17h,0F2h, 8Ch, 2Ah, 87h, 0Ch
		db	 3Ch, 0Ah, 84h,0FFh, 30h, 02h
		db	0A1h, 7Fh,0C0h, 00h, 28h, 54h
		db	 00h, 00h, 00h, 00h, 00h
		db	0Ah
		db	8, 8, 8
data_A0AA	db	8, 8, 8, 8, 8, 8, 8, 8	; Data table (indexed access)
		db	10 dup (28h)
		db	10 dup (0AAh)
		db	10 dup (0)
		db	10 dup (10h)
		db	10 dup (0)
		db	10 dup (0AAh)
		db	10 dup (0)
		db	 04h, 06h, 00h, 00h, 08h, 00h
		db	0A0h, 00h
data_A100	db	2Ah			; Data table (indexed access)
		db	 00h, 2Ah, 00h, 20h,0A8h, 00h
		db	0A0h,0A0h, 0Ah, 00h, 0Ah, 00h
		db	 00h, 00h, 08h, 00h, 00h, 04h
		db	 06h, 00h, 80h, 00h, 00h, 00h
		db	0A8h, 00h, 0Ah, 2Ah, 0Ah, 00h
		db	0A8h,0A0h, 02h, 0Ah, 00h, 00h
		db	 00h,0A0h, 00h, 00h, 00h, 80h
		db	 00h, 02h, 0Eh, 00h, 80h, 02h
		db	 00h, 0Ah, 00h, 2Ah, 00h, 02h
		db	 80h, 00h,0A0h, 00h,0A8h, 00h
		db	 0Ah, 00h, 28h, 02h,0A0h, 0Ah
		db	 00h,0AAh, 00h, 02h, 80h, 00h
		db	 80h, 02h, 0Eh, 02h, 00h, 00h
		db	 80h, 00h,0A8h, 02h, 80h
		db	0Ah
data_A155	dw	0A00h
		db	 00h,0A8h, 00h, 28h, 00h, 08h
		db	 00h, 0Ah, 00h, 02h, 80h, 00h
		db	0A8h, 00h,0A0h, 02h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0F0h, 00h, 00h,0F0h, 0Fh
		db	 00h, 03h, 00h, 00h,0C0h, 0Ch
		db	 80h, 02h, 30h, 0Ch, 20h, 08h
		db	 30h, 30h, 05h, 10h, 0Ch, 30h
		db	 15h, 44h, 0Ch, 30h, 15h, 44h
		db	 0Ch, 30h, 05h, 10h, 0Ch, 0Ch
		db	 20h, 08h, 30h, 0Ch, 80h, 02h
		db	 30h, 03h, 00h, 00h,0C0h, 00h
		db	0F0h, 0Fh, 00h
data_A1A2	db	0			; Data table (indexed access)
		db	 0Fh,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 04h, 10h, 00h
		db	12 dup (0)
		db	 0Fh,0F0h, 00h, 00h,0F0h, 0Fh
		db	 00h, 03h, 00h, 00h,0C0h, 0Ch
		db	 85h, 12h, 30h, 30h, 15h, 44h
		db	 0Ch, 30h, 25h, 48h, 0Ch, 0Ch
		db	 85h, 12h, 30h, 03h, 00h, 00h
		db	0C0h, 00h,0F0h, 0Fh, 00h, 00h
		db	 0Fh,0F0h
		db	13 dup (0)
data_A1EC	dw	1004h
		db	21 dup (0)
		db	0FFh,0FFh, 00h, 0Fh, 85h, 12h
		db	0F0h, 30h, 15h, 44h, 0Ch, 30h
		db	 25h, 48h, 0Ch, 0Fh, 80h, 02h
		db	0F0h, 00h,0FFh,0FFh, 00h
		db	20 dup (0)
		db	 04h, 10h
		db	25 dup (0)
		db	 05h, 10h, 00h
		db	8 dup (0FFh)
		db	 00h, 05h, 10h, 00h
		db	24 dup (0)
data_A270	db	4
		db	 10h, 00h
		db	20 dup (0)
		db	0FFh,0FFh, 00h, 0Fh, 80h, 02h
		db	0F0h, 30h, 25h, 48h, 0Ch, 30h
		db	 15h, 44h, 0Ch, 0Fh, 85h, 12h
		db	0F0h, 00h,0FFh,0FFh, 00h
		db	12 dup (0)
data_A2AA	db	0
		db	7 dup (0)
		db	 04h, 10h
		db	13 dup (0)
		db	 0Fh,0F0h, 00h, 00h,0F0h, 0Fh
		db	 00h, 03h, 00h, 00h,0C0h, 0Ch
		db	 85h, 12h, 30h, 30h, 25h, 48h
		db	 0Ch, 30h, 15h, 44h, 0Ch, 0Ch
		db	 85h, 12h, 30h, 03h, 00h, 00h
		db	0C0h, 00h,0F0h, 0Fh, 00h, 00h
		db	 0Fh,0F0h
		db	13 dup (0)
		db	 04h, 10h
		db	20 dup (0)
		db	 10h, 00h, 00h, 00h, 15h, 00h
		db	 00h, 00h, 55h, 50h, 00h, 00h
		db	 05h, 0Ah,0A0h, 00h, 00h,0A8h
		db	 2Ah, 00h, 00h,0A3h,0CAh, 00h
		db	 00h,0A8h, 2Ah, 00h, 00h, 2Ah
		db	0A8h, 00h, 01h, 00h, 00h, 40h
		db	 05h, 55h, 55h, 50h, 04h, 44h
		db	 11h, 10h, 04h, 10h, 00h
		db	12 dup (0)
		db	 05h, 50h, 00h, 00h, 05h, 50h
		db	 00h, 00h, 05h, 50h, 00h, 00h
		db	 05h, 50h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Ah,0A0h, 00h, 00h
		db	0A8h, 2Ah, 00h, 00h,0A3h,0CAh
		db	 00h, 00h,0A8h, 2Ah, 00h, 00h
		db	 2Ah,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 55h, 50h, 04h
		db	 44h, 11h, 10h, 04h, 10h
		db	23 dup (0)
		db	 04h, 00h, 00h, 00h, 54h, 00h
		db	 00h, 05h, 55h, 00h, 0Ah,0A0h
		db	 50h, 00h,0A8h, 2Ah, 00h, 00h
		db	0A3h,0CAh, 00h, 00h,0A8h, 2Ah
		db	 00h, 00h, 2Ah,0A8h, 00h, 01h
		db	 00h, 00h, 40h, 05h, 55h, 55h
		db	 50h, 04h, 44h, 11h, 10h, 04h
		db	 10h
		db	0, 0, 0, 0
data_A3C0	db	0			; Data table (indexed access)
		db	 00h, 00h, 20h, 00h, 00h, 00h
		db	0A8h, 00h, 0Fh,0F2h,0A0h, 00h
		db	0FFh,0FAh, 80h, 03h,0FFh,0EAh
		db	0C0h, 07h,0FFh,0ABh,0D0h, 07h
		db	0FEh,0AFh,0D0h, 07h,0FAh,0BFh
		db	0D0h, 05h,0EAh,0FFh, 50h, 01h
		db	0ABh,0FDh, 40h, 02h,0A5h, 55h
		db	 00h, 0Ah, 85h, 50h, 00h, 2Ah
		db	 00h, 00h, 00h, 08h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h
data_A3FF	dw	8002h
		db	 00h, 00h, 02h, 80h, 00h, 00h
		db	 02h, 80h, 00h, 00h, 06h, 90h
		db	 00h, 00h,0FEh,0B5h, 00h, 03h
		db	0FEh,0BDh, 40h, 0Fh,0FEh,0BFh
		db	 50h, 0Fh,0FEh,0BFh, 50h, 0Fh
		db	0FEh,0BFh, 50h, 0Fh,0FEh,0BFh
		db	 50h, 03h,0FEh,0BDh, 40h, 00h
		db	0FEh,0B5h, 00h, 00h, 06h, 90h
		db	 00h, 00h, 02h, 80h, 00h, 00h
		db	 02h, 80h, 00h, 00h, 02h, 80h
		db	 00h
data_A43E	dw	1004h
		db	 00h, 00h, 00h, 00h, 08h, 00h
		db	 00h, 00h, 2Ah, 00h, 00h, 00h
		db	 0Ah, 85h, 50h, 00h, 02h,0A5h
		db	 55h, 00h, 01h,0ABh,0FDh, 40h
		db	 05h,0EAh,0FFh, 50h, 07h,0FAh
		db	0BFh,0D0h, 07h,0FEh,0AFh,0D0h
		db	 07h,0FFh,0ABh,0D0h, 03h,0FFh
		db	0EAh,0C0h, 00h,0FFh,0FAh, 80h
		db	 00h, 0Fh,0F2h,0A0h, 00h, 00h
		db	 00h,0A8h, 00h, 00h, 00h, 20h
		db	 00h, 00h, 00h, 00h, 04h, 10h
		db	 00h
		db	12 dup (0)
		db	 05h, 50h, 00h, 00h, 5Fh,0FFh
		db	 00h, 01h, 7Fh,0FFh,0C0h, 05h
		db	0FFh,0FFh,0F0h
		db	8 dup (0AAh)
		db	 05h,0FFh,0FFh,0F0h, 01h, 7Fh
		db	0FFh,0C0h, 00h, 5Fh,0FFh, 00h
		db	 00h, 05h
		db	50h
		db	13 dup (0)
		db	 04h, 10h, 00h, 80h, 02h, 00h
		db	 02h,0C0h, 03h, 80h, 0Bh, 80h
		db	 02h,0E0h, 2Eh,0FFh,0FFh,0B8h
		db	0BBh,0BFh,0FEh,0EEh,0AAh,0BFh
		db	0FEh,0AAh,0AAh, 95h, 56h,0AAh
		db	0AAh, 95h, 56h,0AAh,0AAh, 95h
		db	 56h,0AAh,0AAh, 95h, 56h,0AAh
		db	0AAh, 84h, 46h,0AAh, 88h, 91h
		db	 12h, 22h, 22h, 04h, 44h, 88h
		db	 08h, 80h, 02h, 20h, 02h, 00h
		db	 00h, 80h, 00h, 80h, 02h, 00h
		db	 04h, 10h, 00h, 80h, 02h, 00h
		db	 02h, 80h, 02h, 80h, 0Ah, 80h
		db	 02h,0A0h, 2Ah, 85h, 52h,0A8h
		db	0AAh, 85h, 52h,0AAh,0AAh, 8Fh
		db	0F2h,0AAh,0BBh, 8Fh,0F2h,0EEh
		db	0EEh,0CFh,0F3h,0BBh,0BBh, 8Fh
		db	0F2h,0EEh,0EEh,0CFh,0F3h,0BBh
		db	0AAh, 8Fh,0F2h,0AAh,0AAh, 85h
		db	 52h,0AAh, 2Ah, 85h, 52h,0A8h
		db	 0Ah, 80h, 02h,0A0h, 02h, 80h
		db	 02h, 80h, 00h, 80h, 02h, 00h
		db	 04h, 10h, 00h, 80h, 02h, 00h
		db	 02h, 00h, 00h, 80h, 08h, 80h
		db	 02h, 20h, 22h, 01h, 10h, 88h
		db	 88h, 84h, 42h, 22h,0AAh, 81h
		db	 12h,0AAh,0AAh, 85h, 52h,0AAh
		db	0AAh, 85h, 52h,0AAh,0AAh, 85h
		db	 52h,0AAh,0AAh, 85h, 52h,0AAh
		db	0AAh, 8Fh,0F2h,0AAh,0BBh, 8Fh
		db	0F2h,0EEh, 2Eh,0CFh,0F3h,0B8h
		db	 0Bh, 80h, 02h,0E0h, 02h,0C0h
		db	 03h, 80h, 00h, 80h, 02h, 00h
		db	 04h, 10h, 00h, 0Dh, 50h, 00h
		db	 00h, 3Dh, 54h, 00h, 00h, 35h
		db	 44h, 00h, 00h,0F5h, 51h, 00h
		db	 00h,0F5h, 54h, 00h, 00h,0F5h
		db	 51h, 00h, 00h,0F5h, 54h, 00h
		db	 00h,0F5h, 51h, 00h, 00h,0F5h
		db	 54h, 00h, 00h,0F5h, 51h, 00h
		db	 00h,0F5h, 54h, 00h, 00h,0F1h
		db	 11h, 00h, 00h,0C4h, 44h, 00h
		db	 00h, 3Fh,0FCh, 00h, 00h,0F0h
		db	 0Fh, 00h, 00h, 3Fh,0FCh, 00h
		db	 04h, 10h, 00h,0FDh, 55h, 00h
		db	 3Fh,0D5h, 55h, 54h,0FDh, 55h
		db	 55h, 51h,0F5h, 55h, 55h, 44h
		db	0F5h, 55h, 55h, 51h,0FDh, 55h
		db	 55h, 45h, 3Fh, 55h, 55h, 14h
		db	 03h,0D5h, 51h, 40h, 00h,0F5h
		db	 44h, 00h, 00h,0F5h, 51h, 00h
		db	 00h,0F5h, 44h, 00h, 00h,0F1h
		db	 11h, 00h, 00h,0C4h, 44h, 00h
		db	 00h, 3Fh,0FCh, 00h, 00h,0F0h
		db	 0Fh, 00h, 00h, 3Fh,0FCh, 00h
		db	 04h, 10h, 00h, 35h, 54h, 00h
		db	 00h,0F5h, 51h, 00h, 0Fh,0D5h
		db	 54h, 50h, 3Fh, 55h, 55h, 04h
		db	0FDh
		db	 55h, 55h, 45h
data_A622	db	0FDh			; Data table (indexed access)
		db	 55h, 55h, 11h,0FDh, 55h, 55h
		db	 44h
data_A62A	db	0FDh			; Data table (indexed access)
		db	 55h, 55h, 11h, 3Fh, 55h, 54h
		db	 44h, 0Fh,0D5h, 51h, 10h, 00h
		db	0F5h, 44h, 00h, 00h,0F1h, 11h
		db	 00h, 00h,0C4h, 44h, 00h, 00h
		db	 3Fh,0FCh, 00h, 00h,0F0h, 0Fh
		db	 00h, 00h, 3Fh,0FCh, 00h, 04h
		db	 10h, 00h, 0Dh, 50h, 00h, 00h
		db	 3Dh, 44h, 00h, 00h, 35h, 50h
		db	 00h, 00h,0F5h, 44h, 00h, 00h
		db	0F5h, 51h, 00h, 00h,0F5h, 44h
		db	 00h, 0Fh,0D5h, 51h, 10h, 3Fh
		db	 55h, 54h, 44h,0FDh, 51h, 11h
		db	 11h,0F4h, 44h, 44h, 44h,0F1h
		db	 55h, 51h, 11h, 3Dh, 55h, 55h
		db	 44h, 0Fh, 50h, 05h, 50h, 03h
		db	 0Fh,0F0h, 40h, 00h,0F0h, 0Fh
		db	 00h, 00h, 0Fh,0F0h, 00h, 04h
		db	 10h, 00h, 0Dh, 50h, 00h, 00h
		db	 3Dh, 54h, 00h, 00h, 35h, 44h
		db	 00h, 00h,0F5h, 51h, 00h, 00h
		db	0F5h, 44h, 00h, 00h,0F5h, 51h
		db	 00h, 03h,0D5h, 44h, 40h, 03h
		db	0D1h, 11h, 00h, 0Ch,0C4h, 44h
		db	 10h, 33h,0FFh,0FFh,0C4h,0FFh
		db	0FFh,0FFh,0F5h,0FFh, 00h, 00h
		db	0FDh, 3Ch, 2Ah,0A8h, 3Ch, 0Ch
		db	0AAh,0AAh, 30h, 00h, 2Ah,0A8h
		db	 00h, 00h, 0Ah,0A0h, 00h, 01h
		db	 04h, 20h,0A8h, 20h, 00h, 04h
		db	 10h, 00h
		db	16 dup (0)
		db	 0Ah,0A0h, 00h, 00h,0EAh,0A2h
		db	 00h, 03h,0AAh,0A8h, 80h, 0Eh
		db	0AAh,0AAh, 20h, 0Bh,0AAh,0A8h
		db	 80h, 0Eh,0AAh,0AAh, 20h, 03h
		db	0AAh,0A8h, 80h, 00h,0EAh,0A2h
		db	 00h, 00h, 0Ah,0A0h, 00h, 00h
		db	11 dup (0)
		db	 04h, 10h
		db	17 dup (0)
		db	 08h,0A0h, 00h, 00h,0AAh, 2Ah
		db	 00h, 02h,0A8h,0AAh, 80h, 0Ah
		db	0AAh, 2Ah,0A0h, 0Ah,0A8h,0AAh
		db	0A0h, 0Ah,0AAh, 2Ah,0A0h, 02h
		db	0A8h,0AAh, 80h, 00h,0AAh, 2Ah
		db	 00h, 00h, 08h,0A0h, 00h, 00h
		db	11 dup (0)
		db	 04h, 10h, 00h
		db	16 dup (0)
		db	 0Ah,0A0h, 00h, 00h, 8Ah,0ABh
		db	 00h, 02h, 2Ah,0AAh,0C0h, 08h
		db	0AAh,0AAh,0B0h, 02h, 2Ah,0AAh
		db	0E0h, 08h,0AAh,0AAh,0B0h, 02h
		db	 2Ah,0AAh,0C0h, 00h, 8Ah,0ABh
		db	 00h, 00h, 0Ah,0A0h, 00h, 00h
		db	11 dup (0)
		db	 04h, 10h
		db	0, 0, 0, 0, 0
data_A7A5	dw	0, 0
		db	8 dup (0)
		db	 0Bh,0A0h, 00h, 00h,0AAh,0EAh
		db	 00h, 02h,0ABh,0AAh, 80h, 0Ah
		db	0AAh,0EAh,0A0h, 0Ah,0ABh,0AAh
		db	0A0h, 0Ah,0AAh,0EAh,0A0h, 02h
		db	0ABh,0AAh, 80h, 00h,0AAh,0EAh
		db	 00h, 00h, 0Bh,0A0h
		db	53 dup (0)
data_A808	db	0
		db	26 dup (0)
		db	 55h, 55h, 54h, 15h, 50h, 15h
		db	 50h, 55h, 55h, 55h, 00h, 00h
		db	 55h, 54h, 00h, 00h, 01h, 55h
		db	 55h, 55h, 55h, 01h, 55h, 55h
		db	 55h, 55h, 05h, 55h, 55h, 55h
		db	 55h, 40h, 00h, 61h, 55h, 84h
		db	 16h, 10h, 16h, 10h, 58h, 55h
		db	 61h, 00h, 00h, 5Ah, 54h, 00h
		db	 00h, 01h,0A5h, 55h, 55h,0A5h
		db	 01h,0A5h, 55h, 55h,0A5h, 06h
		db	 95h, 55h, 55h, 69h, 40h, 00h
		db	 41h, 55h, 04h, 14h, 10h, 14h
		db	 10h, 50h, 55h, 41h, 00h, 00h
		db	 5Ah, 14h, 00h, 00h, 01h,0A1h
		db	 55h, 55h,0A1h, 01h,0A1h, 55h
		db	 55h,0A1h, 06h, 85h, 55h, 55h
		db	 68h, 40h, 00h, 50h, 54h, 14h
		db	 05h, 40h, 05h, 40h, 15h, 00h
		db	 05h, 00h, 00h, 54h, 14h, 00h
		db	 00h, 01h, 41h, 55h, 55h, 41h
		db	 01h, 41h, 55h, 55h, 41h, 05h
		db	 05h, 55h, 55h, 50h, 40h, 00h
		db	 00h, 54h, 00h
data_A8AA	db	5			; Data table (indexed access)
		db	 55h, 55h, 40h, 15h, 55h, 00h
		db	 00h, 00h, 15h, 50h, 00h, 00h
		db	 01h, 55h, 00h, 01h, 55h, 01h
		db	 55h, 00h, 01h, 55h, 05h, 54h
		db	 15h, 50h, 55h, 40h, 00h, 00h
		db	 54h, 00h, 05h, 55h, 55h, 40h
		db	 15h, 55h, 00h, 00h, 00h, 15h
		db	 50h, 00h, 00h, 01h, 55h, 00h
		db	 01h, 55h, 01h, 55h, 00h, 00h
		db	 00h, 00h, 00h, 15h, 50h, 00h
		db	 00h, 00h, 00h, 54h, 00h, 05h
		db	 40h, 05h, 40h, 15h, 00h, 05h
		db	 00h, 00h, 15h, 50h, 00h, 00h
		db	 01h, 55h, 00h, 01h, 55h, 01h
		db	 55h, 00h, 00h, 00h, 00h, 00h
		db	 15h, 50h, 00h, 00h, 00h, 01h
		db	 55h, 00h, 15h, 50h, 15h, 50h
		db	 55h, 55h, 55h, 00h, 00h, 15h
		db	 50h, 00h, 00h, 01h, 55h, 00h
		db	 01h, 55h, 01h, 55h, 55h, 55h
		db	 55h, 00h, 00h, 15h, 50h, 00h
		db	 00h, 00h, 01h, 61h, 00h, 16h
		db	 10h, 16h, 10h, 58h, 55h, 61h
		db	 00h, 00h, 15h, 50h, 00h, 00h
		db	 01h, 55h, 55h, 55h, 55h, 01h
		db	 55h, 55h, 55h, 55h, 00h, 00h
		db	 15h, 50h, 00h, 00h, 00h, 01h
		db	 41h, 00h, 14h, 10h, 14h, 10h
		db	 50h, 55h, 41h, 00h, 00h, 15h
		db	 50h, 00h, 00h, 01h, 55h, 55h
		db	 55h, 55h, 01h, 55h, 55h, 55h
		db	 55h, 00h, 00h, 15h
		db	50h
data_A96A	db	0
		db	14 dup (0)
		db	 15h, 50h, 00h, 00h, 01h, 55h
		db	 55h, 55h, 55h, 00h, 00h, 00h
		db	 01h, 55h, 00h, 00h, 15h, 50h
		db	 00h
		db	14 dup (0)
		db	 15h, 50h, 00h, 00h, 01h, 55h
		db	 00h, 01h, 55h, 00h, 00h, 00h
		db	 01h, 55h, 00h, 00h, 15h, 50h
		db	 00h
		db	14 dup (0)
		db	 15h, 50h, 00h, 00h, 01h, 55h
		db	 00h, 01h, 55h, 00h, 00h, 00h
		db	 01h, 55h, 00h, 00h, 15h, 50h
		db	 00h
		db	14 dup (0)
		db	 15h, 50h, 00h, 00h, 01h, 55h
		db	 00h, 01h, 55h, 01h, 55h, 00h
		db	 01h, 55h, 00h, 00h, 15h
		db	50h
		db	15 dup (0)
		db	 55h, 50h, 05h, 55h, 05h
data_AA02	dw	4055h			; Data table (indexed access)
		db	 05h, 55h, 41h, 55h, 55h, 55h
data_AA0A	db	55h			; Data table (indexed access)
		db	 00h, 00h, 55h, 54h, 00h, 00h
		db	 01h, 55h, 50h, 00h, 00h, 00h
		db	 15h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 5Ah, 55h, 55h,0A5h
data_AA22	db	5			; Data table (indexed access)
		db	0A5h, 40h, 05h,0A5h, 41h
data_AA28	db	0A5h			; Data table (indexed access)
		db	55h
data_AA2A	db	55h			; Data table (indexed access)
		db	0A5h, 00h, 00h, 5Ah, 54h, 00h
		db	 00h, 01h, 69h, 54h, 00h, 00h
		db	 00h, 56h, 95h, 00h, 00h, 00h
		db	 00h, 00h
		db	5Ah
data_AA40	db	15h			; Data table (indexed access)
		db	 55h,0A1h, 05h,0A1h, 40h, 05h
		db	0A1h, 41h,0A1h, 55h, 55h,0A1h
		db	 00h, 00h, 5Ah, 14h, 00h, 00h
		db	 01h, 68h, 55h, 00h, 00h, 01h
		db	 56h, 85h, 00h, 00h, 00h, 00h
		db	 00h, 54h, 15h, 55h, 41h, 05h
		db	 41h, 40h, 05h
		db	 41h, 41h
data_AA6A	db	41h			; Data table (indexed access)
		db	 55h, 55h, 41h, 00h, 00h, 54h
		db	 14h, 00h, 00h, 01h, 50h, 55h
		db	 40h, 00h, 05h, 55h, 05h, 00h
		db	 00h
		db	0, 0
data_AA80	db	0			; Data table (indexed access)
		db	20 dup (0)
		db	 01h, 55h, 55h, 50h, 00h, 15h
		db	 55h, 55h
		db	0, 0, 0
data_AAA0	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
		db	0
data_AAA8	dw	0, 0			; Data table (indexed access)
		db	11 dup (0)
		db	 55h, 55h, 54h, 00h, 55h, 55h
		db	 54h
		db	20 dup (0)
data_AAD2	db	0			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 00h, 55h
		db	 55h, 55h, 01h
		db	 55h, 55h, 54h
		db	26 dup (0)
		db	 55h, 55h, 55h, 45h, 55h, 55h
		db	 54h, 00h, 00h
		db	0
data_AB03	dw	0			; Data table (indexed access)
		db	21 dup (0)
		db	 55h, 55h, 55h, 55h, 55h, 55h
		db	 54h, 05h, 55h, 41h, 55h, 55h
		db	 55h, 55h, 05h, 55h, 55h, 55h
		db	 54h, 15h, 55h, 05h, 55h, 55h
		db	 55h, 54h, 15h, 55h, 00h, 05h
		db	 55h, 40h, 00h, 55h, 55h, 55h
		db	 55h, 55h, 55h, 54h, 05h,0A5h
		db	 41h,0A5h, 55h, 55h,0A5h, 06h
		db	 95h, 55h, 56h, 94h, 16h, 95h
		db	 06h, 95h, 55h, 56h, 94h, 16h
		db	 95h, 00h, 05h,0A5h, 40h, 00h
		db	 69h, 55h, 55h,0A5h, 55h, 5Ah
		db	 54h, 05h,0A1h, 41h,0A1h, 55h
		db	 55h,0A1h, 06h, 85h, 55h, 56h
		db	 84h, 16h, 85h, 06h, 85h, 55h
		db	 56h, 84h, 16h, 85h, 00h, 05h
		db	0A1h, 40h, 00h, 68h, 55h, 15h
		db	0A1h, 51h, 5Ah, 14h, 05h, 41h
		db	 41h, 41h, 55h, 55h, 41h, 05h
		db	 05h, 55h, 55h, 04h, 15h, 05h
		db	 05h, 05h, 55h, 55h, 04h, 15h
		db	 05h, 00h, 05h, 41h, 40h, 00h
		db	 50h, 55h, 05h, 41h, 41h, 54h
		db	 14h, 01h, 55h, 01h, 55h, 00h
		db	 01h, 55h, 05h, 54h, 00h, 05h
		db	 54h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 54h, 00h, 01h
		db	 55h, 00h, 00h, 55h, 55h, 01h
		db	 55h, 01h, 55h, 54h, 01h, 55h
		db	 01h, 55h, 00h, 00h, 00h, 05h
		db	 54h, 00h, 00h, 00h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 55h, 00h, 01h, 55h, 00h, 00h
		db	 55h, 55h, 00h, 54h, 01h, 55h
		db	 54h, 01h, 55h, 01h, 55h, 00h
		db	 00h, 00h, 05h, 54h, 00h, 00h
		db	 00h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 55h, 40h, 01h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 01h, 55h, 54h, 01h, 55h
		db	 01h, 55h, 00h, 00h, 00h, 05h
		db	 54h, 00h, 00h, 00h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 55h, 50h, 01h, 55h, 00h, 00h
		db	 55h, 55h, 00h, 00h, 01h, 55h
		db	 54h, 01h, 55h, 01h, 55h, 00h
		db	 00h, 00h, 05h, 54h, 00h, 00h
		db	 00h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 55h, 54h, 01h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 01h, 55h, 54h, 01h, 55h
		db	 01h, 55h, 55h, 55h, 55h, 05h
		db	 55h, 55h, 55h, 54h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 55h, 55h, 01h, 55h, 00h, 00h
		db	 55h, 55h, 00h, 00h, 01h, 55h
		db	 54h, 01h, 55h, 01h, 55h, 55h
		db	 55h, 55h, 05h, 55h, 55h, 55h
		db	 54h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 54h, 55h, 41h
		db	 55h, 00h, 00h, 69h, 55h, 00h
		db	 00h, 01h, 5Ah, 54h, 01h, 55h
		db	 01h, 55h, 55h, 55h, 55h, 05h
		db	 55h, 55h, 55h, 54h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 54h, 15h, 51h, 55h, 00h, 00h
		db	 68h, 55h, 00h, 00h, 01h, 5Ah
		db	 14h, 01h, 55h, 01h, 55h, 55h
		db	 55h, 55h, 05h, 55h, 55h, 55h
		db	 54h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 54h, 05h, 55h
		db	 55h, 00h, 00h, 50h, 55h, 00h
		db	 00h, 01h, 54h, 14h, 01h, 55h
		db	 00h, 00h, 00h, 01h, 55h, 00h
		db	 00h, 00h, 05h, 54h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 54h, 01h, 55h, 55h, 00h, 00h
		db	 55h, 55h, 00h, 00h, 01h, 55h
		db	 54h, 01h, 55h, 00h, 00h, 00h
		db	 01h, 55h, 00h, 00h, 00h, 05h
		db	 54h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 54h, 00h, 55h
		db	 55h, 00h, 00h, 55h, 55h, 00h
		db	 00h, 01h, 55h, 54h, 01h, 55h
		db	 00h, 00h, 00h, 01h, 55h, 00h
		db	 00h, 00h, 05h, 54h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 54h, 00h, 15h, 55h, 00h, 00h
		db	 55h, 55h, 00h, 00h, 01h, 55h
		db	 54h, 01h, 55h, 00h, 00h, 00h
		db	 01h, 55h, 00h, 00h, 00h, 05h
		db	 54h, 05h, 54h, 05h, 54h, 00h
		db	 05h, 54h, 05h, 54h, 00h, 05h
		db	 55h, 00h, 01h, 55h, 55h, 40h
		db	 00h, 05h, 55h, 55h, 01h, 55h
		db	 01h, 55h, 00h, 01h, 55h, 05h
		db	 54h, 00h, 05h, 54h, 05h, 54h
		db	 05h, 54h, 00h, 05h, 54h, 05h
		db	 54h, 00h, 01h, 55h, 00h, 01h
		db	 55h, 55h, 40h, 00h, 05h, 55h
		db	 55h, 05h, 55h, 41h, 55h, 55h
		db	 55h, 55h, 05h, 55h, 55h, 55h
		db	 54h, 15h, 55h, 05h, 55h, 55h
		db	 55h, 54h, 15h, 55h, 00h, 05h
		db	 55h, 40h, 01h, 69h, 55h, 40h
		db	 00h, 05h, 56h, 95h, 05h,0A5h
		db	 41h,0A5h, 55h, 55h,0A5h, 06h
		db	 95h, 55h, 56h, 94h, 16h, 95h
		db	 05h, 55h, 55h, 55h, 54h, 16h
		db	 95h, 00h, 05h,0A5h, 40h, 01h
		db	 68h, 55h, 40h, 00h, 05h, 56h
		db	 85h, 05h,0A1h, 41h,0A1h, 55h
		db	 55h,0A1h, 06h, 85h, 55h, 56h
		db	 84h, 16h, 85h, 05h, 45h, 55h
		db	 55h, 44h, 16h, 85h, 00h, 05h
		db	0A1h, 40h, 01h, 50h, 55h, 40h
		db	 00h, 05h, 55h, 05h, 05h, 41h
		db	 41h, 41h, 55h, 55h, 41h, 05h
		db	 05h, 55h, 55h, 04h, 15h, 05h
		db	 05h, 05h, 55h, 55h, 04h, 15h
		db	 05h, 00h, 05h
		db	 41h, 40h
		db	99 dup (0)
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 05h, 30h, 00h, 00h, 55h
		db	 4Fh, 00h, 02h,0AAh,0A2h, 80h
		db	 05h, 55h, 50h,0F0h, 2Ah,0AAh
		db	0A8h,0A0h, 55h, 55h, 55h, 33h
		db	 01h, 55h, 55h, 33h, 01h,0A5h
		db	 55h, 33h, 55h, 55h, 55h, 33h
		db	 0Ah,0AAh,0A8h,0A0h, 05h, 55h
		db	 50h,0F0h, 02h,0AAh,0A2h, 80h
		db	 00h, 55h, 4Fh, 00h, 00h, 05h
		db	 30h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 05h, 50h, 00h, 00h, 55h
		db	 55h, 00h, 02h,0AAh,0AAh, 80h
		db	 05h, 55h, 55h, 50h, 2Ah,0AAh
		db	0AAh,0A8h, 55h, 55h, 55h, 55h
		db	 55h, 40h, 01h, 55h, 5Ah, 40h
		db	 01h,0A5h, 55h, 55h, 55h, 55h
		db	 2Ah,0AAh,0AAh,0A8h, 05h, 55h
		db	 55h, 50h, 02h,0AAh,0AAh, 80h
		db	 00h, 55h, 55h, 00h, 00h, 05h
		db	 50h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 0Ch, 50h, 00h, 00h,0F1h
		db	 55h, 00h, 02h, 8Ah,0AAh, 80h
		db	 0Fh, 05h, 55h, 50h, 0Ah, 2Ah
		db	0AAh,0A8h,0CCh, 55h, 55h, 55h
		db	0CCh, 55h, 55h, 40h,0CCh, 55h
		db	 5Ah, 40h,0CCh
		db	 55h, 55h, 55h
data_AF00	db	0Ah			; Data table (indexed access)
		db	 2Ah,0AAh,0A0h, 0Fh, 05h, 55h
		db	 50h, 02h, 8Ah,0AAh, 80h, 00h
		db	0F1h, 55h, 00h, 00h, 0Ch, 50h
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 10h, 00h, 00h, 53h,0C5h
		db	 00h, 02h, 8Ah,0A2h, 80h, 05h
		db	 0Fh,0F0h, 50h, 0Ah, 2Ah,0A8h
		db	0A0h, 44h,0FFh,0FFh, 11h, 44h
		db	0FFh,0FFh, 11h, 44h,0FFh,0FFh
		db	 11h, 44h,0FFh,0FFh, 11h, 0Ah
		db	 2Ah,0A8h,0A0h, 05h, 0Fh,0F0h
		db	 50h, 02h, 8Ah,0A2h, 80h, 00h
		db	 53h,0C5h, 00h, 00h, 04h, 10h
		db	 00h, 00h, 00h, 00h, 00h, 12h
		db	 0Ch,0AAh
		db	9 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0ABh,0FFh,0ABh,0FFh
		db	0ABh,0AAh,0EAh,0FFh,0ABh,0FFh
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 20h, 00h,0AFh,0FFh,0EFh,0FFh
		db	0EFh,0EAh,0FBh,0FFh,0EFh,0FFh
loc_AF9C:
;*		call	sub_4FA1		;*
		db	0E8h, 02h,0A0h		;  Fixup - byte match
		sub	al,[bp+si]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		sub	byte ptr data_EFAB[bx],0ABh
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		sti				; Enable interrupts
		sti				; Enable interrupts
		jmp	short loc_AF9C
			                        ;* No entry point to code
		stosw				; Store ax to es:[di]
;*		call	sub_B7B9		;*
		db	0E8h, 08h, 08h		;  Fixup - byte match
		or	data_2000[bx+si],0
		scasw				; Scan es:[di] for ax
		stosw				; Store ax to es:[di]
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		db	0FFh,0EFh,0BFh,0FBh,0FFh
data_AFBE	db	0AFh			; Data table (indexed access)
		db	0ABh,0E8h, 08h, 00h, 80h, 88h
		db	 00h, 20h, 00h,0AFh,0FFh,0AFh
		db	0FFh,0EFh,0BEh,0FBh,0EBh,0EFh
		db	0ABh
loc_AFD2:
		call	sub_31D7
		add	ss:data_80A0[bp+si],cl
		add	ds:d_BA00_AFBE_e[bx],ch
		stosw				; Store ax to es:[di]
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		stosb				; Store al to es:[di]
		sti				; Enable interrupts
		jmp	short loc_AFD2
		db	0ABh,0E8h, 00h, 22h, 02h, 08h
		db	 00h, 80h, 00h,0AFh,0BEh,0AFh
		db	0ABh,0EFh,0AAh,0FBh,0FFh,0EFh
		db	0FFh,0E8h, 20h, 22h, 02h, 20h
		db	 02h, 00h, 00h,0ABh,0AFh,0ABh
		db	0ABh,0ABh,0AAh,0EAh,0FFh,0ABh
		db	0FFh,0A8h, 0Ah, 80h,0A8h, 20h
		db	 02h, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0A8h, 00h
		db	0, 0, 0, 0, 0, 0
data_B034	db	0
		db	 12h, 26h, 27h, 28h
		db	'((((((((((((((()*&', 27h, '((((('
		db	'((((((((((()*'
		db	0
data_B05F	db	0
		db	 13h, 33h
		db	'7V7W7V77KHHHHHHHHLPQKHHHHHHHHL77'
		db	'V7W7V75'
		db	0
data_B08A	db	0
		db	14h
		db	'/7+89:;7UJOOOOOO'
		db	 01h, 01h, 49h, 54h, 54h, 4Ah
		db	8 dup (4Fh)
		db	'IU7;@D:>7,'
		db	0
data_B0B5	db	0
		db	15h
		db	'/7<=:>?@UJOOOO'
		db	1, 1, 1, 1
		db	'ITTJOOOOOO'
		db	1, 1
		db	'IU798E@D7,'
		db	0
data_B0E0	db	0
		db	16h
		db	'/7A=+BCDUJ'
		db	8 dup (1)
		db	 49h, 54h, 54h, 4Ah
		db	8 dup (1)
		db	'IU>:FC>E7,'
		db	0
data_B10B	db	0
		db	17h
		db	'477777777MGGGGGGGGNRSMGGGGGGGGN7'
		db	'77777776'
		db	0
data_B136	db	0
		db	 18h, 30h
		db	'12222222222222222.-0122222222222'
		db	'22222.-', 0
data_B161	db	0Ah
		db	2
		db	'CONTROLES'
		db	0
data_B16D	db	0Ah
		db	 04h, 51h
		db	7 dup (20h)
		db	 41h, 52h, 52h, 49h, 42h, 41h
		db	 00h
data_B17E	db	0Ah
		db	5
		db	'A       ABAJO'
		db	0
data_B18E	db	0Ah
		db	 06h, 4Fh
		db	7 dup (20h)
		db	'IZQUIERDA'
		db	0
data_B1A2	db	0Ah
		db	7
		db	'P       DERECHA', 0
data_B1B4	db	0Ah, 8, 'ESPACIO FUEGO', 0
data_B1C4	db	0Ah, 9, 'BRK     ABANDONAR', 0
data_B1D8	db	0Ah, 0Ah, 'D       DEMO', 0
data_B1E7	db	0Ah, 0Ch, 'S PARA COMENZAR', 0
		db	'ATENCION    ATENCION     TRANSMI'
		db	'SION A LA NAVE EXPLORER         '
		db	'                                '
		db	'HAS CUMPLIDO TU ULTIMA MISION Y '
		db	'DEBES RETORNAR AL PLANETA NOVA D'
		db	'E LA GALAXIA TRAION             '
		db	'                            TU L'
		db	'UCHA NO HA SIDO EN VANO PUES LA '
		db	'LEJANA COLONIA DEL IMPERIO LLAMA'
		db	'DA TIERRA HA SIDO LIBERADA DE LO'
		db	'S INVASORES Y PUEDE SER HABITADA'
		db	' DE NUEVO                       '
		db	'                  /REPITO  MENSA'
		db	'JE                         '
		db	 00h, 07h, 12h
		db	 42h, 2Fh, 1Bh, 22h, 45h, 43h
data_B3BD	db	0
data_B3BE	db	0
data_B3BF	db	0
		db	0, 0, 0, 0
data_B3C4	db	0
data_B3C5	db	0
		db	20 dup (0)
data_B3DA	db	0
data_B3DB	db	0
		db	0, 0, 0, 0, 0
data_B3E1	db	0
data_B3E2	db	0
		db	20 dup (0)
data_B3F7	db	0
		db	28 dup (0)
data_B414	db	0A0h
		db	 32h, 6Ch, 00h, 6Ch, 2Dh, 00h
		db	 32h, 6Ch, 00h, 00h, 2Dh, 00h
		db	0A8h, 77h, 5Ch,0AFh, 12h, 0Ch
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FDh, 83h, 04h, 84h
		db	261 dup (0)
data_B536	db	1
data_B537	dw	24 dup (0)
		db	0
data_B568	db	0
		db	0
data_B56A	db	0
data_B56B	dw	0
data_B56D	db	0
data_B56E	db	0
data_B56F	db	0
data_B570	dw	50h
data_B572	dw	4 dup (0)
data_B57A	db	0
data_B57B	db	0
data_B57C	db	0
		db	0, 0, 0, 0, 0, 0
data_B583	db	0
		db	0
data_B585	db	0
		db	20 dup (0)
data_B59A	db	1
		db	'GHIJ5555555555555555555555555555'
		db	'5555GHIJKLMN'
		db	32 dup (0)
		db	 4Bh, 4Ch, 4Dh, 4Eh, 00h, 50h
		db	 51h
		db	34 dup (0)
		db	 50h, 51h, 00h, 00h, 36h, 37h
		db	34 dup (0)
		db	 36h, 37h, 00h, 00h, 38h, 39h
		db	34 dup (0)
		db	 38h, 39h, 00h, 00h, 36h, 37h
		db	34 dup (0)
		db	 36h, 37h, 00h, 00h, 38h, 39h
		db	34 dup (0)
		db	 38h, 39h, 00h, 00h, 36h, 37h
		db	34 dup (0)
		db	 36h, 37h, 00h, 00h, 38h, 39h
		db	34 dup (0)
		db	 38h, 39h, 00h, 00h, 36h, 37h
		db	34 dup (0)
		db	 36h, 37h, 00h, 00h, 38h, 39h
		db	34 dup (0)
		db	 38h, 39h, 00h, 00h, 36h, 37h
		db	34 dup (0)
		db	 36h, 37h, 00h, 00h, 38h, 39h
		db	0, 0, 0, 0
data_B782	db	0			; Data table (indexed access)
		db	29 dup (0)
		db	 38h, 39h, 00h, 00h, 36h, 37h
		db	34 dup (0)
		db	 36h, 37h, 00h, 47h, 48h, 49h
		db	 4Ah
		db	32 dup (0)
		db	'GHIJKLMN}~'
		db	 83h, 7Fh, 7Dh, 7Eh, 83h, 7Fh
		db	 7Dh, 7Eh, 83h, 7Fh, 7Dh, 7Eh
		db	 83h, 7Fh, 7Dh, 7Eh, 83h, 7Fh
		db	 7Dh, 7Eh, 83h, 7Fh, 7Dh, 7Eh
		db	 83h, 7Fh, 7Dh, 7Eh, 83h, 7Fh
		db	 4Bh, 4Ch, 4Dh, 4Eh, 00h, 50h
		db	 51h, 00h, 80h, 81h, 84h, 82h
		db	 80h, 81h, 84h, 82h, 80h, 81h
		db	 84h, 82h, 80h, 81h, 84h, 82h
		db	 80h, 81h, 84h, 82h, 80h, 81h
		db	 84h, 82h, 80h, 81h, 84h, 82h
		db	 80h, 81h, 84h, 82h, 00h, 50h
		db	 51h, 00h,0FFh
		db	372 dup (0FFh)
data_B9B8	db	0FFh
		db	306 dup (0FFh)
data_BAEB	dw	79A5h
data_BAED	dw	79B1h
data_BAEF	db	0
data_BAF0	db	0
data_BAF1	db	0
data_BAF2	dw	0
data_BAF4	db	0
data_BAF5	db	0
data_BAF6	dw	133 dup (0)
data_BC00	db	0			; Data table (indexed access)
		db	801 dup (0)
data_BF22	db	0			; Data table (indexed access)
		db	365 dup (0)
data_C090	db	0
		db	107 dup (0)
data_C0FC	db	0
		db	393 dup (0)
data_C286	db	0			; Data table (indexed access)
		db	1656 dup (0)
data_C8FF	db	0
data_C900	dw	0
		db	23 dup (0)
data_C919	dw	0			; Data table (indexed access)
		db	245 dup (0)
data_CA10	db	0			; Data table (indexed access)
		db	118 dup (0)
data_CA87	dw	0			; Data table (indexed access)
		db	759 dup (0)
		db	0			; Data table (indexed access)
		db	1126 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

;      Note: Subroutine does not return	to instruction after call

sub_D1E7	proc	near
		db	282 dup (0)
data_D301	dw	0
		db	7336 dup (0)
data_EFAB	db	0			; Data table (indexed access)
		db	84 dup (0)
		db	 8Ch,0C8h, 8Eh,0C0h,0BBh, 00h
		db	 01h,0B2h, 10h,0B5h, 0Eh,0B1h
		db	 01h
loc_F00D:
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
		jnz	loc_F00D		; Jump if not zero
		int	20h			; DOS program terminate
sub_D1E7	endp

		db	221 dup (0)

seg_a		ends



		end	start
