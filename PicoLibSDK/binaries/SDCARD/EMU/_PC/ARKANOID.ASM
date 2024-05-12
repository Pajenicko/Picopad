
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
;==				ARKANOID                                 ==
;==					                                 ==
;==      Created:   13-Apr-89		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_0000_0024_e	equ	24h
d_0000_0070_e	equ	70h
d_0038_0000_e	equ	0			;*
d_0038_0015_e	equ	15h			;*
d_0038_0280_e	equ	280h			;*
d_0038_0F02_e	equ	0F02h			;*
d_0038_1100_e	equ	1100h			;*
d_0038_1138_e	equ	1138h			;*
d_0038_4000_e	equ	4000h			;*
d_0038_4055_e	equ	4055h			;*
d_0038_4E0E_e	equ	4E0Eh			;*
d_0038_5001_e	equ	5001h			;*
d_0038_5405_e	equ	5405h			;*
d_0038_5D03_e	equ	5D03h			;*
d_0038_5E09_e	equ	5E09h			;*
d_0038_6001_e	equ	6001h			;*
d_0038_601D_e	equ	601Dh			;*
d_0038_6C0D_e	equ	6C0Dh			;*
d_0038_7002_e	equ	7002h			;*
d_0038_8003_e	equ	8003h			;*
d_0038_8158_e	equ	8158h			;*
d_0038_8448_e	equ	8448h			;*
d_0038_9880_e	equ	9880h			;*
d_0038_A00B_e	equ	0A00Bh			;*
d_0038_D880_e	equ	0D880h			;*
d_0038_D881_e	equ	0D881h			;*
d_0038_E883_e	equ	0E883h			;*
d_0038_F001_e	equ	0F001h			;*
data_0000_e	equ	0
data_00BB_e	equ	0BBh
data_FB7D_e	equ	0FB7Dh			;*
data_FFFE_e	equ	0FFFEh			;*(=0)
d_52C0_01E0_e	equ	1E0h			;*
d_52C0_4E0E_e	equ	4E0Eh			;*
d_52C0_5405_e	equ	5405h			;*
d_52C0_560D_e	equ	560Dh			;*
d_52C0_5E09_e	equ	5E09h			;*
d_52C0_7C1F_e	equ	7C1Fh			;*
d_52C0_7E08_e	equ	7E08h			;*
d_52C0_D635_e	equ	0D635h			;*
d_52C0_D728_e	equ	0D728h			;*
d_52C0_FC1F_e	equ	0FC1Fh			;*
d_5445_0700_e	equ	700h			;*
d_5445_0D00_e	equ	0D00h			;*
d_5445_1300_e	equ	1300h			;*
d_5445_1C00_e	equ	1C00h			;*
d_5445_2B00_e	equ	2B00h			;*
d_5445_2E00_e	equ	2E00h			;*
d_5445_C004_e	equ	0C004h			;*
d_5445_F800_e	equ	0F800h			;*
d_7EC0_A08A_e	equ	0A08Ah			;*
d_7EC0_A08B_e	equ	0A08Bh			;*
d_B800_0000_e	equ	0
d_B800_0658_e	equ	658h
d_FE05_0580_e	equ	580h
d_FFFF_0000_e	equ	0

seg_a		segment	byte public
		assume	cs:seg_a, ds:seg_a


		org	100h

ARKANOID	proc	far

start:
		jmp	short real_start
		db	9Fh	; LAHF

;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

real_start:
;*		fmul	dword ptr ss:data_8EC0[bp]	; st = st * memory
		db	0D8h, 8Eh,0C0h, 8Eh	;  Fixup - byte match

;		sar	byte ptr ds:data_FFFE_e[si],1	; (=0) Shift w/sign fill
		db	0d0h, 0bch, 0feh, 0ffh

		cld				; Clear direction
		call	sub_0A93
		mov	data_0250,sp		; (=0)
		call	sub_07E3
loc_0116:
		call	sub_110E
		call	sub_0FF9
		mov	si,465Bh
		mov	bx,offset data_275F	; ('PPPPxhhhhPLAYER     ROUN')
		mov	di,14h
		mov	cx,8

locloop_0128:
		push	cx
		mov	al,[bx]
		inc	bx
		mov	cl,8
		mov	ch,14h
		call	sub_08BD
		pop	cx
		loop	locloop_0128		; Loop if cx > 0

		mov	di,0C8Eh
		mov	word ptr ds:[243h],di
		mov	byte ptr ds:[2D5h],47h	; 'G'
		mov	bx,offset data_275F+9	; ('PLAYER     ROUND    SCOR')
		call	sub_0AD5
		mov	byte ptr ds:[2D5h],45h	; 'E'
		mov	di,0F0Eh
		mov	data_0278,0
		mov	bx,offset data_2782
		mov	cx,6

locloop_015C:
		push	cx
		mov	word ptr ds:[243h],di
		push	di
		cmp	cl,data_02A5
		jne	loc_016C		; Jump if not equal
		mov	data_0278,di
loc_016C:
		call	sub_0AD5
		mov	al,[bx]
		or	al,al			; Zero ?
		jnz	loc_0177		; Jump if not zero
		mov	al,20h			; ' '
loc_0177:
		call	sub_0AE2
		mov	cx,5

locloop_017D:
		inc	bx
		mov	al,[bx]
		call	sub_0AE2
		loop	locloop_017D		; Loop if cx > 0

		inc	bx
		pop	di
		add	di,280h
		pop	cx
		loop	locloop_015C		; Loop if cx > 0

		mov	byte ptr ds:[2D5h],42h	; 'B'
		mov	bx,data_0278
		mov	dx,1019h
		test	byte ptr data_02A5,0FFh
		jz	loc_01A4		; Jump if zero
		mov	dx,12C2h
loc_01A4:
		mov	word ptr ds:[243h],bx
		mov	data_06E4,dx
		mov	byte ptr data_027C,6
		mov	byte ptr data_0FF6,4
loc_01B6:
		mov	al,3
		call	sub_06E2
		dec	data_0FF6
		jnz	loc_01B6		; Jump if not zero
		mov	byte ptr data_0280,0
		mov	data_0245,sp
		mov	data_0C63,0CDEh
		mov	al,data_0263
		and	al,1Fh
		call	sub_1184
		jmp	short loc_01DD
loc_01DA:
		call	sub_1182
loc_01DD:
		call	sub_0C65
		dec	data_0262
		jz	loc_01F1		; Jump if zero
		mov	al,data_0262
		call	sub_10C4
		call	sub_0B60
		jmp	short loc_01DD
loc_01F1:
		mov	di,1786h
		mov	word ptr ds:[243h],di
		mov	byte ptr ds:[2D5h],7
		mov	bx,296h
		call	sub_0AD5
		mov	data_06E4,6DFh
		mov	al,2
		call	sub_06E2
		jmp	loc_0116

ARKANOID	endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0211	proc	near
		mov	di,8
		mov	ch,50h			; 'P'
		mov	cl,0C8h
		call	sub_0981
		retn
sub_0211	endp

		db	0B9h,0FFh,0FFh

locloop_021F:
		push	ax
		pop	ax
		loop	locloop_021F		; Loop if cx > 0

		retn
			                        ;* No entry point to code
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		mov	al,0FFh
		jz	loc_ret_0232		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		mov	al,0

loc_ret_0232:
		retn
loc_0233:
		mov	ah,0
		mov	al,3
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ax,4C00h
		int	21h			; DOS Services  ah=function 4Ch
						;  terminate with al=return code
data_023E	db	0
data_023F	dw	0
data_0241	dw	0
		dw	0
data_0245	dw	0
data_0247	dw	0
data_0249	db	48h
data_024A	db	20h
data_024B	db	0FDh
data_024C	db	10h
data_024D	dw	0
data_024F	db	2
data_0250	dw	0
		db	0, 0, 0, 0
data_0256	dw	0
data_0258	db	3
data_0259	db	8
data_025A	db	80h
data_025B	db	1
data_025C	dw	26E7h
data_025E	dw	0
data_0260	dw	0AC50h
data_0262	db	5
data_0263	db	1
data_0264	db	0
		db	0, 0
data_0267	db	0
		db	 06h, 00h, 0Bh
data_026B	dw	0
data_026D	dw	0
data_026F	dw	0
		db	0Bh
data_0272	db	0
		db	5
		db	0, 0, 0
data_0277	db	0
data_0278	dw	0
data_027A	db	0
data_027B	db	1
data_027C	db	0
data_027D	db	0
data_027E	dw	0			; Data table (indexed access)
data_0280	dw	5000h			; Data table (indexed access)
		db	 42h, 52h, 41h, 49h, 4Eh
data_0287	db	'SPACE TO CHEAT'
		db	0FFh
		db	'GAME  OVER'
		db	0FFh
data_02A1	dw	536Eh
		db	0
data_02A4	db	0
data_02A5	db	0
data_02A6	dw	0
		db	0
data_02A9	db	0
		db	1, 1, 1, 1, 1, 1
		db	2, 2, 2, 2, 2, 2
		db	3, 3, 3, 3, 3, 4
		db	4, 4, 4, 4, 4, 3
		db	3
data_02C3	db	0
data_02C4	db	52h
		db	 4Fh, 55h, 4Eh, 44h, 20h,0FFh
data_02CB	db	0
		db	 07h, 08h, 09h, 11h, 12h, 13h
		db	 10h
data_02D3	db	0, 0, 0
data_02D6	db	0
		db	31 dup (0)
data_02F6	db	0
		db	64 dup (0)
data_0337	db	0
		db	71 dup (0)
data_037F	db	0
		db	64 dup (0)
data_03C0	db	0
		db	447 dup (0)
data_0580	db	0
		db	85 dup (0)
data_05D6	db	0
		db	41 dup (0)
data_0600	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
data_0607	dw	0
		db	34 dup (0)
data_062B	db	0
		db	41 dup (0)
data_0655	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0
data_065B	db	0
		db	116 dup (0)

; Check key from keyboard

loc_06D0:	mov	ah,1
		int	16h
		mov	al,0ffh
		je	loc_06EE
		mov	ah,0
		int	16h
		mov	al,0
loc_06EE:	retn

loc_06EF:	mov	al,0ffh
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_06E2	proc	near
		jmp	short loc_06E6
data_06E4	dw	6D0h

loc_06E6:
		dec	al
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		mov	bx,offset data_572A
		add	bx,ax
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		mov	dx,[bx]
		dec	dx
		mov	data_0721,dx
		mov	dx,[bx+2]
		dec	dx
		mov	data_0723,dx
		mov	dx,[bx+4]
		mov	data_0725,dl
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_0710:
		call	sub_074E
		mov	bx,data_06E4
		call	bx			;*
		inc	al
		jz	loc_0710		; Jump if zero
		jmp	short loc_0743
data_071F	db	9
data_0720	db	10h
data_0721	dw	0
data_0723	dw	0
data_0725	db	16h

;==== External Entry into Subroutine ======================================

sub_0726:
		mov	si,[bx]
		inc	si
		mov	al,[si]
		cmp	al,40h			; '@'
		je	loc_073F		; Jump if equal
		mov	[bx],si
		retn

;==== External Entry into Subroutine ======================================

sub_0732:
		mov	al,[bx]
		add	al,0Ch
		mov	bx,offset data_0887
		xlat				; al=[al+[bx]] table
		mov	bh,al
		mov	bl,1
		retn
loc_073F:
		pop	bx
		pop	bx
		xor	al,al			; Zero register
loc_0743:
		pushf				; Push flags
		push	ax
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		pop	ax
		popf				; Pop flags
		retn
sub_06E2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_074E	proc	near
		mov	bx,721h
		call	sub_0726
		mov	data_071F,al
		mov	bx,723h
		call	sub_0726
		mov	data_0720,al
		mov	bx,offset data_071F
		call	sub_0732
		push	bx
		mov	bx,offset data_0720
		call	sub_0732
		pop	dx
		xor	di,di			; Zero register
		cmp	bh,1
		jne	loc_077C		; Jump if not equal
		cmp	dh,1
		je	loc_0786		; Jump if equal
		mov	bx,dx
loc_077C:
		cmp	dh,1
		jne	loc_0783		; Jump if not equal
		mov	dx,bx
loc_0783:
		mov	di,2
loc_0786:
		xchg	dx,di
		mov	ch,data_0725
		shl	ch,1			; Shift w/zeros fill
		mov	cl,0FFh

;==== External Entry into Subroutine ======================================

sub_0790:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		mov	ah,al
		clc				; Clear carry flag
		jmp	short loc_07D3
			                        ;* No entry point to code
		jnc	loc_079F		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_079F:
		jnc	loc_07A5		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07A5:
		jnc	loc_07AB		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07AB:
		jnc	loc_07B1		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07B1:
		jnc	loc_07B7		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07B7:
		jnc	loc_07BD		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07BD:
		jnc	loc_07C3		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07C3:
		jnc	loc_07C9		; Jump if carry=0
		mov	al,al
		mov	al,al
loc_07C9:
		jnc	locloop_07CF		; Jump if carry=0
		mov	al,al
		mov	al,al

locloop_07CF:
		xchg	al,ah
		xchg	bx,di
loc_07D3:
		out	61h,al			; port 61h, 8255 B - spkr, etc
		dec	bl
		jnz	loc_07E0		; Jump if not zero
		mov	bl,bh
		xor	al,dl
		xchg	al,al
		nop
loc_07E0:
		loop	locloop_07CF		; Loop if cx > 0

		retn
sub_074E	endp

sub_07E3	proc	near
		mov	al,1Bh
loc_07E5:
		push	ax
		call	sub_07FD
		pop	ax
		dec	al
		jz	loc_ret_07FC		; Jump if zero
		cmp	cx,0D00h
		jb	loc_ret_07FC		; Jump if below
		sub	byte ptr cs:[7E1h],2
		jmp	short loc_07E5

loc_ret_07FC:
		retn
sub_07E3	endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_07FD	proc	near
		call	sub_0840
		mov	cx,0
		mov	bx,101h
		mov	di,bx
		mov	dl,0
		mov	cs:data_0880,0
loc_0811:
		test	byte ptr cs:data_0880,0FFh
		jz	loc_0811		; Jump if zero
		mov	byte ptr cs:data_0882,0C3h
		call	sub_0790
		push	cx
		call	sub_0867
		mov	byte ptr cs:[7E0h],0E2h
		pop	cx
		neg	cx
		retn
sub_07FD	endp

			                        ;* No entry point to code
		push	ax
		inc	cs:data_0880
		mov	al,cs:data_0882
		mov	byte ptr cs:[7E0h],al
		pop	ax
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0840	proc	near
		mov	byte ptr cs:data_0882,0E2h
		push	ds
		xor	ax,ax			; Zero register
		mov	ds,ax
		mov	si,d_0000_0070_e
		mov	ax,[si]
		mov	cs:data_0883,ax
		mov	ax,[si+2]
		mov	cs:data_0885,ax
		cli				; Disable interrupts
		mov	ax,830h
		mov	[si],ax
		mov	[si+2],cs
		sti				; Enable interrupts
		pop	ds
		retn
sub_0840	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0867	proc	near
		push	ds
		xor	ax,ax			; Zero register
		mov	ds,ax
		mov	si,d_0000_0070_e
		cli				; Disable interrupts
		mov	ax,cs:data_0883
		mov	[si],ax
		mov	ax,cs:data_0885
		mov	[si+2],ax
		sti				; Enable interrupts
		pop	ds
		retn
sub_0867	endp

data_0880	dw	0
data_0882	db	0
data_0883	dw	0
data_0885	dw	0
data_0887	db	0FFh
		db	0F0h,0E3h,0D7h,0CBh,0C0h,0B4h
		db	0ABh,0A1h, 97h, 90h, 88h, 80h
		db	'yrlf`[VQLHD@=9630-+(&$'
		db	'" '
		db	 1Eh, 1Ch, 1Bh, 19h, 18h, 17h
		db	 15h, 14h, 13h, 12h, 11h, 10h
		db	 0Fh, 0Eh, 0Dh, 0Ch, 01h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_08BD	proc	near
		push	bx
		push	cx
		push	bp
		push	es
		mov	bx,9C2h
		jmp	short loc_08CD

;==== External Entry into Subroutine ======================================

sub_08C6:
		push	bx
		push	cx
		push	bp
		push	es
		mov	bx,offset data_09BA
loc_08CD:
		mov	dl,al
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		and	al,7
		xlat				; al=[al+[bx]] table
		mov	ah,al
		mov	word ptr ds:[935h],ax
		ror	ax,1			; Rotate
		ror	ax,1			; Rotate
		mov	word ptr ds:[963h],ax
		mov	al,dl
		and	al,7
		xlat				; al=[al+[bx]] table
		mov	ah,al
		mov	word ptr ds:[93Bh],ax
		ror	ax,1			; Rotate
		ror	ax,1			; Rotate
		mov	word ptr ds:[969h],ax
		mov	ax,0B800h
		mov	es,ax
		mov	byte ptr ds:[926h],ch
		mov	byte ptr ds:[954h],ch
		shl	ch,1			; Shift w/zeros fill
		neg	ch
		add	ch,50h			; 'P'
		mov	byte ptr ds:[949h],ch
		mov	byte ptr ds:[977h],ch
		mov	dx,di
		xor	dx,2000h
		test	dh,20h			; ' '
		jnz	loc_091F		; Jump if not zero
		add	dx,50h
loc_091F:
		mov	bx,si
		mov	bp,offset data_6BBA
		cld				; Clear direction

locloop_0925:
		mov	ch,2
loc_0927:
		mov	al,[bx]
		inc	bx
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		mov	si,ax
		mov	ax,[bp+si]
		not	ax
		and	ax,0FFFFh
		push	ax
		mov	ax,[bp+si]
		and	ax,0FFFFh
		pop	si
		or	ax,si
		stosw				; Store ax to es:[di]
		dec	ch
		jnz	loc_0927		; Jump if not zero
		xchg	di,dx
		add	dx,0
		loop	locloop_0953		; Loop if cx > 0

		mov	si,bx
		pop	es
		pop	bp
		pop	cx
		pop	bx
		retn

locloop_0953:
		mov	ch,2
loc_0955:
		mov	al,[bx]
		inc	bx
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		mov	si,ax
		mov	ax,[bp+si]
		not	ax
		and	ax,0FFFFh
		push	ax
		mov	ax,[bp+si]
		and	ax,0FFFFh
		pop	si
		or	ax,si
		stosw				; Store ax to es:[di]
		dec	ch
		jnz	loc_0955		; Jump if not zero
		xchg	di,dx
		add	dx,0
		loop	locloop_0925		; Loop if cx > 0

		mov	si,bx
		pop	es
		pop	bp
		pop	cx
		pop	bx
		retn
sub_08BD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0981	proc	near
		mov	al,0

;==== External Entry into Subroutine ======================================

sub_0983:
		push	bx
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		and	al,7
		mov	bx,offset data_09C2
		xlat				; al=[al+[bx]] table
		mov	ah,al
		push	es
		mov	dx,0B800h
		mov	es,dx
		mov	dx,di
		mov	byte ptr ds:[9A3h],ch
		xor	ch,ch			; Zero register
		cld				; Clear direction

locloop_09A1:
		push	cx
		mov	cl,2
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xor	dx,2000h
		test	dh,20h			; ' '
		jnz	loc_09B2		; Jump if not zero
		add	dx,50h
loc_09B2:
		mov	di,dx
		pop	cx
		loop	locloop_09A1		; Loop if cx > 0

		pop	es
		pop	bx
		retn
sub_0981	endp

data_09BA	db	0
		db	 44h,0BBh,0AAh, 66h, 55h,0DDh
		db	0FFh
data_09C2	db	0
		db	 55h,0AAh,0AAh, 55h, 55h,0FFh
		db	0FFh
data_09CA	dw	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_09CC	proc	near
		push	bx
		mov	al,byte ptr data_09CA
		test	al,0FFh
		jz	loc_09FB		; Jump if zero
		mov	ah,0FFh
		mov	bx,offset data_0A0D
		mov	cx,0Ch

locloop_09DC:
		cmp	al,[bx]
		je	loc_09F6		; Jump if equal
		inc	bx
		inc	bx
		loop	locloop_09DC		; Loop if cx > 0

		cmp	al,1
		jne	loc_09F2		; Jump if not equal
		push	ax
		call	sub_10AC
		pop	ax
		mov	byte ptr data_09CA,0
loc_09F2:
		mov	al,0
		jmp	short loc_09FD
loc_09F6:
		mov	al,[bx+1]
		jmp	short loc_09FD
loc_09FB:
		xor	ax,ax			; Zero register
loc_09FD:
		test	byte ptr data_09CA+1,0FFh
		jz	loc_0A08		; Jump if zero
		or	al,10h
		mov	ah,0FFh
loc_0A08:
		mov	data_02A4,al
		pop	bx
		retn
sub_09CC	endp

data_0A0D	db	4Bh
		db	 02h, 7Ah, 02h, 4Dh, 01h, 79h
		db	 01h, 2Ch, 02h, 2Dh, 02h, 2Eh
		db	 02h, 2Fh, 02h, 32h, 01h, 33h
		db	 01h, 34h, 01h, 35h, 01h, 50h
		db	0E4h, 60h, 8Ah,0E0h,0E4h, 61h
		db	 0Ch, 80h,0E6h, 61h, 34h, 80h
		db	0E6h, 61h, 8Ah,0C4h, 3Ch,0FFh
		db	 74h, 4Ch, 24h, 7Fh,0A8h, 40h
		db	 74h, 12h, 3Ch, 77h, 74h, 1Ah
		db	 3Ch, 78h, 74h, 16h, 3Ch, 7Eh
		db	 74h, 12h, 3Ch, 7Dh, 74h, 0Eh
		db	0EBh
		db	20h
loc_0A52:
		cmp	al,39h			; '9'
		je	loc_0A5E		; Jump if equal
		cmp	al,2Ah			; '*'
		je	loc_0A5E		; Jump if equal
		cmp	al,36h			; '6'
		jne	loc_0A72		; Jump if not equal
loc_0A5E:
		test	ah,80h
		jz	loc_0A6C		; Jump if zero
		cmp	al,byte ptr cs:data_09CA+1
		jne	loc_0A8D		; Jump if not equal
		xor	al,al			; Zero register
loc_0A6C:
		mov	byte ptr cs:data_09CA+1,al
		jmp	short loc_0A8D
loc_0A72:
		test	ah,80h
		jz	loc_0A80		; Jump if zero
		cmp	al,byte ptr cs:data_09CA
		jne	loc_0A8D		; Jump if not equal
		xor	al,al			; Zero register
loc_0A80:
		mov	byte ptr cs:data_09CA,al
		jmp	short loc_0A8D
loc_0A86:
		mov	cs:data_09CA,0
loc_0A8D:
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	ax
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A93	proc	near
		push	es
		xor	ax,ax			; Zero register
		mov	es,ax
		mov	bx,d_0000_0024_e
		cli				; Disable interrupts
		mov	ax,es:[bx]
		mov	data_0AD1,ax
		mov	ax,es:[bx+2]
		mov	data_0AD3,ax
		mov	ax,0A25h
		mov	es:[bx],ax
		mov	ax,cs
		mov	es:[bx+2],ax
		sti				; Enable interrupts
		pop	es
		retn
sub_0A93	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AB8	proc	near
		push	es
		xor	ax,ax			; Zero register
		mov	es,ax
		mov	bx,d_0000_0024_e
		cli				; Disable interrupts
		mov	ax,data_0AD1
		mov	es:[bx],ax
		mov	ax,data_0AD3
		mov	es:[bx+2],ax
		sti				; Enable interrupts
		pop	es
		retn
sub_0AB8	endp

data_0AD1	dw	0
data_0AD3	dw	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AD5	proc	near
loc_0AD5:
		mov	al,[bx]
		inc	bx
		cmp	al,0FFh
		je	loc_ret_0AE1		; Jump if equal
		call	sub_0AE2
		jmp	short loc_0AD5

loc_ret_0AE1:
		retn
sub_0AD5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AE2	proc	near
		push	cx
		cmp	al,20h			; ' '
		jne	loc_0AED		; Jump if not equal
		push	si
		mov	si,5B32h
		jmp	short loc_0B09
loc_0AED:
		cmp	al,0Ah
		jb	loc_0AFB		; Jump if below
		cmp	al,5Dh			; ']'
		jae	loc_0AF9		; Jump if above or =
		sub	al,34h			; '4'
		jmp	short loc_0AFB
loc_0AF9:
		sub	al,38h			; '8'
loc_0AFB:
		cbw				; Convrt byte to word
		push	si
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,58E2h
loc_0B09:
		mov	di,word ptr ds:[243h]
		push	di
		mov	al,byte ptr ds:[2D5h]
		mov	cx,108h
		call	sub_08BD
		pop	di
		inc	di
		inc	di
		mov	word ptr ds:[243h],di
		pop	si
		pop	cx
		retn
sub_0AE2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B21	proc	near
		push	cx
		cmp	al,20h			; ' '
		jne	loc_0B2C		; Jump if not equal
		push	si
		mov	si,5B32h
		jmp	short loc_0B48
loc_0B2C:
		cmp	al,0Ah
		jb	loc_0B3A		; Jump if below
		cmp	al,5Dh			; ']'
		jae	loc_0B38		; Jump if above or =
		sub	al,34h			; '4'
		jmp	short loc_0B3A
loc_0B38:
		sub	al,38h			; '8'
loc_0B3A:
		cbw				; Convrt byte to word
		push	si
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_58E2
loc_0B48:
		mov	di,word ptr ds:[243h]
		push	di
		mov	al,byte ptr ds:[2D5h]
		mov	cx,108h
		call	sub_08C6
		pop	di
		inc	di
		inc	di
		mov	word ptr ds:[243h],di
		pop	si
		pop	cx
		retn
sub_0B21	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B60	proc	near
loc_0B60:
		call	sub_0BB5
		call	sub_0BFA
		call	sub_1761
		mov	di,1558h
		mov	word ptr ds:[243h],di
		mov	bx,offset data_02C4
		mov	byte ptr ds:[2D5h],7
		call	sub_0AD5
		mov	al,data_0263
		mov	cl,0FFh
loc_0B80:
		inc	cl
		sub	al,0Ah
		jnc	loc_0B80		; Jump if carry=0
		add	al,0Ah
		mov	ch,al
		mov	al,cl
		or	al,al			; Zero ?
		jz	loc_0B93		; Jump if zero
		call	sub_0AE2
loc_0B93:
		mov	al,ch
		call	sub_0AE2
		mov	data_06E4,6DFh
		mov	al,1
		call	sub_06E2
		mov	di,1558h
		mov	word ptr ds:[243h],di
		mov	cx,8

locloop_0BAD:
		mov	al,20h			; ' '
		call	sub_0AE2
		loop	locloop_0BAD		; Loop if cx > 0

		retn
sub_0B60	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0BB5	proc	near
		call	sub_157F
		call	sub_1820
		mov	byte ptr data_23CA,0FFh
		mov	byte ptr data_205C,0
		mov	byte ptr data_205B,0
		mov	data_023E,0
		mov	data_02A4,0
		mov	data_025A,80h
		mov	data_025B,1
		mov	data_0259,8
		mov	data_0258,3
		mov	data_023F,733h
		mov	data_02A1,536Eh
		mov	byte ptr ds:[2D5h],5
		retn
sub_0BB5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0BFA	proc	near
		mov	bx,offset data_2838
		mov	di,8
		mov	word ptr ds:[243h],di
		mov	cx,18h

locloop_0C07:
		mov	al,[bx]
		call	sub_0AE2
		inc	bx
		loop	locloop_0C07		; Loop if cx > 0

		mov	byte ptr ds:[2D5h],45h	; 'E'
		mov	cx,17h
		mov	bx,offset data_283A+16h	; ('abacdeabacdeabacdeabacde')
		mov	di,148h
		mov	data_0241,di

locloop_0C21:
		mov	word ptr ds:[243h],di
		mov	al,[bx]
		call	sub_0AE2
		add	word ptr ds:[243h],2Ch
		mov	al,[bx]
		call	sub_0AE2
		mov	di,data_0241
		add	di,140h
		mov	data_0241,di
		inc	bx
		loop	locloop_0C21		; Loop if cx > 0

		mov	di,offset data_02D6
		mov	al,45h			; 'E'
		mov	cx,18h

locloop_0C4B:
		mov	[di],al
		inc	di
		loop	locloop_0C4B		; Loop if cx > 0

		mov	di,offset data_02F6
		mov	cx,17h

locloop_0C56:
		mov	[di],al
		add	di,17h
		mov	[di],al
		add	di,9
		loop	locloop_0C56		; Loop if cx > 0

		retn
sub_0BFA	endp

data_0C63	dw	1599h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0C65	proc	near
		mov	data_0247,sp
		test	data_02C3,0FFh
		jz	loc_0C73		; Jump if zero
		jmp	loc_0D4D
loc_0C73:
		call	sub_22FF
		call	sub_1AE4
		test	byte ptr data_023F,1
		jnz	loc_0C86		; Jump if not zero
		call	sub_1E75
		call	sub_1BD3
loc_0C86:
		test	data_0259,1
		jz	loc_0C93		; Jump if zero
		call	sub_22BF
		call	sub_22CA
loc_0C93:
		call	sub_205E
		call	sub_2371
		call	sub_1761
		test	data_0259,1
		jz	loc_0CA6		; Jump if zero
		call	sub_21A6
loc_0CA6:
		call	sub_09CC
		mov	bx,data_0C63
		call	bx			;*
		call	sub_184E
		test	data_0259,60h		; '`'
		jz	loc_0CBC		; Jump if zero
		call	sub_16E3
loc_0CBC:
		test	data_0259,80h
		jz	loc_0CC6		; Jump if zero
		call	sub_2434
loc_0CC6:
		dec	data_023F
		jnz	loc_0CDC		; Jump if not zero
		mov	data_023F,733h
		cmp	data_0258,5
		adc	data_0258,0
loc_0CDC:
		jmp	short loc_0C73
			                        ;* No entry point to code
		call	sub_09CC
		or	ah,ah			; Zero ?
		jnz	loc_0CF5		; Jump if not zero
		mov	al,byte ptr data_1B70+1
		sub	al,6
		sub	al,data_1817
		test	byte ptr data_023F+1,0FFh
		jnz	loc_0D0A		; Jump if not zero
loc_0CF5:
		mov	sp,data_0250
		mov	data_026B,0
		mov	al,data_0263
		dec	al
		mov	data_0263,al
		jmp	loc_0116
loc_0D0A:
		jmp	loc_15D7
loc_0D0D:
		mov	data_02C3,0FFh
		mov	byte ptr data_1B81,1Eh
		mov	byte ptr data_0FF8,0
		mov	byte ptr data_0FF5,42h	; 'B'
		call	sub_0DBA
		push	ds
		pop	es
		cld				; Clear direction
		mov	di,offset data_02D6
		mov	ax,0
		mov	cx,180h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	al,data_0FF5
		mov	ah,0Ah
		mov	di,offset data_037F
loc_0D3A:
		mov	cx,7
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		add	di,19h
		dec	ah
		jnz	loc_0D3A		; Jump if not zero
		call	sub_124C
		mov	sp,data_0247
loc_0D4D:
		call	sub_1AE4
		call	sub_0DBA
		call	sub_0E50
		call	sub_1E75
		call	sub_09CC
		call	sub_0D6D
		call	sub_1761
		call	sub_184E
		call	sub_0DDA
		call	sub_22FF
		jmp	short loc_0D4D
sub_0C65	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D6D	proc	near
		mov	byte ptr data_1818,0
		test	data_02A4,2
		jz	loc_0D91		; Jump if zero
		mov	al,data_1817
		mov	cl,0FCh
		mov	ch,al
		add	al,cl
		cmp	al,8
		jae	loc_0DAD		; Jump if above or =
		mov	al,ch
		sub	al,8
		mov	cl,al
		mov	al,8
		jmp	short loc_0DAD
		db	90h
loc_0D91:
		test	data_02A4,1
		jz	loc_ret_0DB9		; Jump if zero
		mov	al,data_1817
		mov	cl,4
		mov	ch,al
		add	al,cl
		cmp	al,0A0h
		jb	loc_0DAD		; Jump if below
		mov	al,ch
		sub	al,9Fh
		mov	cl,al
		mov	al,9Fh
loc_0DAD:
		mov	data_1817,al
		mov	byte ptr data_1818,cl
		or	byte ptr data_181F,2

loc_ret_0DB9:
		retn
sub_0D6D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0DBA	proc	near
		mov	al,data_0FF5
		cmp	al,data_0FF8
		je	loc_ret_0DD9		; Jump if equal
		mov	data_0FF8,al
		call	sub_1F0B
		mov	di,658h
		mov	si,442Bh
		mov	ch,7
		mov	cl,50h			; 'P'
		mov	al,data_0FF5
		call	sub_08BD

loc_ret_0DD9:
		retn
sub_0DBA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0DDA	proc	near
		mov	cl,0
		dec	data_205D
		jnz	loc_0DF5		; Jump if not zero
		dec	cl
		mov	byte ptr data_205D,4
		mov	al,data_0FF5
		cmp	al,43h			; 'C'
		jb	loc_0DF5		; Jump if below
		dec	al
		mov	data_0FF5,al
loc_0DF5:
		mov	bx,offset data_2028
		mov	ch,3
loc_0DFA:
		test	byte ptr [bx+5],0FFh
		jz	loc_0E48		; Jump if zero
		mov	al,[bx+3]
		mov	[bx+2],al
		add	al,2
		mov	[bx+3],al
		cmp	al,0B1h
		jb	loc_0E1B		; Jump if below
		push	cx
		call	sub_1F22
		pop	cx
		mov	byte ptr [bx+5],0
		jmp	short loc_0E48
		db	90h
loc_0E1B:
		mov	dh,[bx+1]
		mov	[bx],dh
		mov	dl,[bx+0Bh]
		mov	al,[bx+0Ch]
		add	al,al
		mov	ah,al
		sbb	ah,ah
		add	ax,ax
		add	ax,dx
		mov	[bx+1],ah
		mov	[bx+0Bh],al
		ror	cl,1			; Rotate
		jnc	loc_0E48		; Jump if carry=0
		mov	al,[bx+4]
		add	al,2
		cmp	al,11h
		jb	loc_0E45		; Jump if below
		xor	al,al			; Zero register
loc_0E45:
		mov	[bx+4],al
loc_0E48:
		add	bx,10h
		dec	ch
		jnz	loc_0DFA		; Jump if not zero
		retn
sub_0DDA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0E50	proc	near
		mov	al,data_0FF7
		inc	al
		cmp	al,1
		jne	loc_0EA4		; Jump if not equal
		dec	data_0FF6
		jnz	loc_ret_0E7B		; Jump if not zero
		mov	ch,3
		mov	si,offset data_2028
loc_0E64:
		test	byte ptr [si+5],0FFh
		jz	loc_0E7C		; Jump if zero
		add	si,10h
		dec	ch
		jnz	loc_0E64		; Jump if not zero
		mov	byte ptr data_0FF6,1
		mov	byte ptr data_0FF7,1

loc_ret_0E7B:
		retn
loc_0E7C:
		mov	byte ptr [si+4],10h
		mov	byte ptr [si+1],5Ch	; '\'
		mov	byte ptr [si+3],52h	; 'R'
		mov	byte ptr [si+5],0F7h
		mov	byte ptr data_0FF6,0Fh
		mov	al,data_1817
		sub	al,58h			; 'X'
		mov	ch,al
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		add	al,ch
		mov	[si+0Ch],al
		retn
loc_0EA4:
		cmp	al,18h
		jne	loc_0EAA		; Jump if not equal
		mov	al,0E8h
loc_0EAA:
		mov	data_0FF7,al
		test	al,80h
		jz	loc_0EB3		; Jump if zero
		neg	al
loc_0EB3:
		cmp	al,15h
		jae	loc_ret_0EDC		; Jump if above or =
		mov	ch,al
		and	al,3
		jz	loc_ret_0EDC		; Jump if zero
		shr	ch,1			; Shift w/zeros fill
		shr	ch,1			; Shift w/zeros fill
		inc	ch
		mov	si,4281h
		mov	dx,48h
loc_0EC9:
		add	si,dx
		dec	ch
		jnz	loc_0EC9		; Jump if not zero
		mov	di,0CECh
		mov	ch,3
		mov	cl,14h
		mov	al,data_0FF5
		call	sub_08BD

loc_ret_0EDC:
		retn
sub_0E50	endp

loc_0EDD:
		mov	data_02A1,53DCh
		mov	byte ptr data_0FF5,47h	; 'G'
		dec	data_1B81
		jz	loc_0EEF		; Jump if zero
		retn
loc_0EEF:
		call	sub_234B
		call	sub_1B3A
		call	sub_0F08
		call	sub_0F08
		mov	bx,5296h
		call	sub_139B
		mov	sp,data_0250
		jmp	loc_0116

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F08	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_0F73
		mov	cx,8

locloop_0F13:
		push	cx
		mov	data_0FF3,si
		mov	di,d_B800_0658_e
		mov	cx,0Ah

locloop_0F1E:
		push	cx
		push	di
		mov	cx,7

locloop_0F23:
		push	cx
		mov	cx,8
		mov	dx,di
		xor	dh,20h			; ' '
		mov	si,data_0FF3

locloop_0F30:
		lodsw				; String [si] to ax
		and	es:[di],ax
		xchg	di,dx
		add	dx,50h
		loop	locloop_0F30		; Loop if cx > 0

		sub	di,140h
		inc	di
		inc	di
		pop	cx
		loop	locloop_0F23		; Loop if cx > 0

		pop	di
		add	di,140h
		pop	cx
		loop	locloop_0F1E		; Loop if cx > 0

		mov	data_02A1,53F7h
		mov	cx,5

locloop_0F55:
		push	cx
		call	sub_22FF
		pop	cx
		loop	locloop_0F55		; Loop if cx > 0

		call	sub_22FF
		call	sub_22FF
		call	sub_22FF
		call	sub_22FF
		mov	si,data_0FF3
		add	si,10h
		pop	cx
		loop	locloop_0F13		; Loop if cx > 0

		retn
sub_0F08	endp

data_0F73	db	0FCh
		db	0FFh,0FCh,0FFh,0FCh,0FFh,0FCh
		db	0FFh,0FCh,0FFh,0FCh,0FFh,0FCh
		db	0FFh, 00h, 00h, 00h, 00h,0FFh
		db	 3Fh,0FFh, 3Fh,0FFh, 3Fh,0FFh
		db	 3Fh,0FFh, 3Fh,0FFh, 3Fh, 00h
		db	 00h, 00h, 00h, 00h, 00h,0F0h
		db	0FFh,0F0h,0FFh,0F0h,0FFh,0F0h
		db	0FFh,0F0h,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0FFh, 0Fh,0FFh
		db	 0Fh,0FFh, 0Fh,0FFh, 0Fh
		db	10 dup (0)
		db	0C0h,0FFh,0C0h,0FFh,0C0h,0FFh
		db	 00h
		db	9 dup (0)
		db	0FFh, 03h,0FFh, 03h
		db	13 dup (0)
		db	0FFh, 00h,0FFh, 00h
		db	21 dup (0)
data_0FF3	dw	0
data_0FF5	db	42h
data_0FF6	db	1
data_0FF7	db	0
data_0FF8	db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FF9	proc	near
		push	es
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ah,0Bh
		mov	bh,1
		mov	bl,1
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	ax,0B800h
		mov	es,ax
		mov	di,d_B800_0000_e
		mov	ax,0
		mov	cx,2000h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		pop	es
		retn
sub_0FF9	endp

			                        ;* No entry point to code
data_1019:	push	cx
		call	sub_09CC
		inc	ah
		jz	loc_1027		; Jump if zero
		mov	data_06E4,102Bh
loc_1027:
		pop	cx
		mov	al,0FFh
		retn
			                        ;* No entry point to code
		push	cx
		call	sub_09CC
		inc	ah
		jnz	loc_1027		; Jump if not zero
		mov	data_0C63,1599h
		mov	bx,data_1B70
		inc	bx
		mov	si,offset data_0280+1
		mov	cx,6

locloop_1044:
		mov	al,[si]
		cmp	al,[bx]
		jne	loc_1051		; Jump if not equal
		inc	bx
		inc	si
		loop	locloop_1044		; Loop if cx > 0

		mov	byte ptr data_0280,al
loc_1051:
		mov	sp,data_0245
		mov	al,byte ptr data_0280
		or	al,al			; Zero ?
		jz	loc_1098		; Jump if zero
		mov	al,data_0263
		dec	al
		and	al,1Fh
		jz	loc_1098		; Jump if zero
		call	sub_0211
		mov	di,8
		mov	ch,50h			; 'P'
		mov	cl,0C0h
		call	sub_0981
		mov	byte ptr ds:[2D5h],47h	; 'G'
		mov	di,0DDAh
		mov	word ptr ds:[243h],di
		mov	bx,offset data_0287	; ('SPACE TO CHEAT')
		call	sub_0AD5
		mov	cx,100h

locloop_1087:
		push	cx
		call	sub_22FF
		pop	cx
		call	sub_09CC
		cmp	byte ptr data_09CA+1,39h	; '9'
		je	loc_10A1		; Jump if equal
		loop	locloop_1087		; Loop if cx > 0

loc_1098:
		mov	bx,51E3h
		nop
		nop
		nop
		jmp	loc_01DA
loc_10A1:
		mov	al,data_0263
		dec	al
		call	sub_1184
		jmp	loc_01DD

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10AC	proc	near
		call	sub_0AB8
loc_10AF:
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	ah,10h
		jne	loc_10BB		; Jump if not equal
		jmp	loc_0233
loc_10BB:
		cmp	ah,2Eh			; '.'
		jne	loc_10AF		; Jump if not equal
		call	sub_0A93
		retn
sub_10AC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10C4	proc	near
		mov	ah,1
		jmp	short loc_10CA

;==== External Entry into Subroutine ======================================

sub_10C8:
		mov	ah,0
loc_10CA:
		cmp	al,5
		jae	loc_ret_10E7		; Jump if above or =
		push	ax
		shl	al,1			; Shift w/zeros fill
		cbw				; Convrt byte to word
		mov	di,offset data_10EE
		add	di,ax
		mov	di,[di]
		mov	cl,8
		mov	ch,4
		pop	ax
		dec	ah
		jz	loc_10E8		; Jump if zero
		mov	al,7
		call	sub_08BD

loc_ret_10E7:
		retn
loc_10E8:
		mov	al,0
		call	sub_0981
		retn
sub_10C4	endp

data_10EE	db	0
		db	 00h, 7Ah, 10h, 82h, 10h,0FAh
		db	 12h, 02h, 13h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10F8	proc	near
		push	ax
		mov	data_02A1,539Ah
		mov	si,5BBAh
		mov	al,data_0262
		inc	data_0262
		call	sub_10C8
		pop	ax
		retn
sub_10F8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_110E	proc	near
		push	ds
		pop	es
		mov	cx,6
		mov	di,offset data_2796

locloop_1116:
		push	di
		push	cx
		mov	si,offset data_026B
		mov	cx,5

locloop_111E:
		mov	al,[si]
		cmp	al,[di]
		jne	loc_1129		; Jump if not equal
		inc	di
		inc	si
		loop	locloop_111E		; Loop if cx > 0

		stc				; Set carry flag
loc_1129:
		jnc	loc_113A		; Jump if carry=0
		pop	cx
		pop	di
		add	di,1Ah
		loop	locloop_1116		; Loop if cx > 0

		mov	data_02A5,0
		jmp	short loc_ret_1181
		db	90h
loc_113A:
		pop	cx
		mov	data_02A5,cl
		pop	di
		mov	cx,2832h
		sub	cx,di
		mov	si,offset data_281D
		mov	di,offset data_2837
		std				; Set direction flag
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,0Dh
		mov	data_02A6,si
		mov	data_1B70,si

locloop_1159:
		inc	si
		mov	byte ptr [si],20h	; ' '
		loop	locloop_1159		; Loop if cx > 0

		mov	al,data_0263
		mov	ch,0FFh
loc_1164:
		sub	al,0Ah
		inc	ch
		jnc	loc_1164		; Jump if carry=0
		jz	loc_116E		; Jump if zero
		mov	[si],ch
loc_116E:
		add	al,0Ah
		inc	si
		mov	[si],al
		mov	cx,5
		add	si,7
		mov	di,si
		mov	si,offset data_026B
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]

loc_ret_1181:
		retn
sub_110E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1182	proc	near
		xor	al,al			; Zero register

;==== External Entry into Subroutine ======================================

sub_1184:
		mov	data_0263,al
		call	sub_1363
		mov	data_0262,5
		mov	ax,0
		mov	data_026B,ax
		mov	data_026D,ax
		mov	data_026F,ax
		mov	data_02C3,al

;==== External Entry into Subroutine ======================================

sub_119E:
		call	sub_234B
		mov	di,14Ah
		mov	ch,16h
		mov	cl,0B8h
		call	sub_0981
		mov	byte ptr data_181F,2
		inc	data_0263
		mov	cl,data_0263
		xor	ch,ch			; Zero register
		cld				; Clear direction
		mov	si,2871h

locloop_11BE:
		add	si,data_00BB_e
		loop	locloop_11BE		; Loop if cx > 0

		push	es
		push	ds
		pop	es
		mov	di,offset data_0249
		mov	cx,7
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		mov	word ptr data_02D3,si
		mov	al,data_0249
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		test	al,2
		jnz	loc_11EB		; Jump if not zero
		test	al,4
		jz	loc_11F3		; Jump if zero
		and	al,0FBh
		or	al,2
		jmp	short loc_11F3
loc_11EB:
		test	al,4
		jnz	loc_11F3		; Jump if not zero
		and	al,0FDh
		or	al,4
loc_11F3:
		and	al,0E7h
		or	al,20h			; ' '
		mov	dx,3D9h
		out	dx,al			; port 3D9h, CGA color control
		mov	data_0264,0
		mov	al,data_0263
		cmp	al,21h			; '!'
		jne	loc_120A		; Jump if not equal
		jmp	loc_0D0D
loc_120A:
		mov	si,word ptr data_02D3
		mov	cx,0Fh
		mov	di,3CAh
		mov	data_0241,di
		mov	bx,337h

locloop_121B:
		mov	word ptr ds:[243h],di
		push	cx
		mov	cx,0Bh

locloop_1223:
		mov	al,[si]
		and	al,0Fh
		call	sub_2400
		mov	al,byte ptr ds:[2D5h]
		mov	[bx],al
		inc	bx
		mov	[bx],al
		inc	bx
		inc	si
		loop	locloop_1223		; Loop if cx > 0

		inc	si
		pop	cx
		mov	di,data_0241
		add	di,140h
		mov	data_0241,di
		add	bx,0Ah
		loop	locloop_121B		; Loop if cx > 0

		call	sub_128A

;==== External Entry into Subroutine ======================================

sub_124C:
		call	sub_12C1
		mov	di,546h
		mov	word ptr ds:[243h],di
		mov	bx,offset data_026F+1
		call	sub_14A5
		mov	di,1942h
		mov	word ptr ds:[243h],di
		mov	al,data_0263
		mov	cl,0FFh
loc_1268:
		inc	cl
		sub	al,0Ah
		jnc	loc_1268		; Jump if carry=0
		add	al,0Ah
		push	cx
		call	sub_14B2
		pop	ax
		or	al,al			; Zero ?
		jz	loc_127C		; Jump if zero
		call	sub_14B2
loc_127C:
		mov	data_2059,0
		mov	data_0267,14h
		jmp	loc_0B60
sub_1182	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_128A	proc	near
		mov	si,offset data_0337
		mov	di,offset data_05D6
		mov	cx,0Fh

locloop_1293:
		push	cx
		mov	cx,0Bh

locloop_1297:
		mov	byte ptr [di],0
		mov	al,[si]
		and	al,47h			; 'G'
		cmp	al,7
		jne	loc_12AB		; Jump if not equal
		mov	al,data_024F
		or	al,80h
		mov	[di],al
		jmp	short loc_12B2
loc_12AB:
		cmp	al,6
		jne	loc_12B2		; Jump if not equal
		mov	byte ptr [di],80h
loc_12B2:
		inc	si
		inc	si
		inc	di
		loop	locloop_1297		; Loop if cx > 0

		add	si,0Ah
		add	di,5
		pop	cx
		loop	locloop_1293		; Loop if cx > 0

		retn
sub_128A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_12C1	proc	near
		retn
sub_12C1	endp

			                        ;* No entry point to code
		push	ax
		push	cx
		call	sub_09CC
		or	ah,ah			; Zero ?
		jnz	loc_12D3		; Jump if not zero
		mov	data_027A,0
		jmp	loc_135E
loc_12D3:
		mov	dl,data_027B
		test	al,2
		jz	loc_12E8		; Jump if zero
		dec	dl
		mov	al,dl
		cmp	al,0FFh
		jne	loc_12F8		; Jump if not equal
		mov	al,1Ah
		jmp	short loc_12F8
		db	90h
loc_12E8:
		test	al,1
		jz	loc_130D		; Jump if zero
		inc	dl
		mov	al,dl
		cmp	al,1Bh
		jb	loc_12F8		; Jump if below
		mov	dl,0
		xor	al,al			; Zero register
loc_12F8:
		mov	data_027B,al
		or	al,al			; Zero ?
		jnz	loc_1301		; Jump if not zero
		sub	al,20h			; ' '
loc_1301:
		add	al,40h			; '@'
		call	sub_0AE2
		sub	word ptr ds:[243h],2
		jmp	short loc_135E
loc_130D:
		cmp	byte ptr data_09CA,1Ch
		je	loc_134A		; Jump if equal
		test	al,10h
		jz	loc_135E		; Jump if zero
		test	data_027A,0FFh
		jnz	loc_135E		; Jump if not zero
		mov	al,dl
		or	al,al			; Zero ?
		jnz	loc_1327		; Jump if not zero
		sub	al,20h			; ' '
loc_1327:
		add	al,40h			; '@'
		mov	data_027A,al
		call	sub_0AE2
		push	bx
		mov	bx,data_02A6
		inc	bx
		mov	al,data_027A
		mov	[bx],al
		mov	data_02A6,bx
		pop	bx
		mov	data_027B,0
		dec	data_027C
		jnz	loc_135E		; Jump if not zero
loc_134A:
		push	ds
		pop	es
		cld				; Clear direction
		mov	di,offset data_0272
		mov	si,offset data_2796
		mov	cx,5
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	data_06E4,1019h
loc_135E:
		pop	cx
		pop	ax
		mov	al,0FFh
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1363	proc	near
		call	sub_0211
		mov	al,4
loc_1368:
		push	ax
		mov	si,5BBAh
		call	sub_10C8
		pop	ax
		dec	al
		jnz	loc_1368		; Jump if not zero
		mov	si,offset data_4093
loc_1377:
		mov	di,[si]
		inc	di
		jz	loc_138D		; Jump if zero
		dec	di
		inc	si
		inc	si
		mov	al,[si]
		inc	si
		mov	ch,[si]
		inc	si
		mov	cl,[si]
		inc	si
		call	sub_08BD
		jmp	short loc_1377
loc_138D:
		mov	di,0CC6h
		mov	word ptr ds:[243h],di
		mov	bx,offset data_0277
		call	sub_14A5
		retn
sub_1363	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_139B	proc	near
		mov	data_027E,bx
		call	sub_0211
		mov	data_0245,sp
		push	es
		mov	ax,0B800h
		mov	es,ax
		mov	bl,50h			; 'P'
		mov	cx,28h
		mov	dx,1

locloop_13B4:
		call	sub_1481
		mul	bl			; ax = reg * al
		mov	di,ax
		and	di,3FFFh
		call	sub_1481
		xor	ah,ah			; Zero register
		xor	di,ax
		mov	es:[di],dx
		ror	dx,1			; Rotate
		ror	dx,1			; Rotate
		loop	locloop_13B4		; Loop if cx > 0

		pop	es
		mov	si,4B5Bh
		mov	di,0F14h
		mov	al,68h			; 'h'
		mov	cl,58h			; 'X'
		mov	ch,13h
		call	sub_08BD
		mov	byte ptr ds:[2D5h],47h	; 'G'
		mov	di,148h
		mov	word ptr ds:[243h],di
		mov	data_0241,di
		mov	data_06E4,13FCh
loc_13F5:
		mov	al,4
		call	sub_06E2
		jmp	short loc_13F5
sub_139B	endp

			                        ;* No entry point to code
		push	bx
		push	ax
		mov	bx,data_027E
		mov	al,[bx]
		inc	bx
		or	al,al			; Zero ?
		jz	loc_141D		; Jump if zero
		call	sub_0AE2
		mov	al,[bx]
		inc	bx
		mov	data_027E,bx
		or	al,al			; Zero ?
		jz	loc_141D		; Jump if zero
		call	sub_0AE2
		jmp	short loc_1477
		db	90h
loc_141D:
		mov	al,[bx]
		inc	bx
		mov	data_027E,bx
		or	al,al			; Zero ?
		jnz	loc_143A		; Jump if not zero
		mov	bx,data_0241
		add	bx,280h
		mov	data_0241,bx
		mov	word ptr ds:[243h],bx
		jmp	short loc_1477
loc_143A:
		mov	data_06E4,1447h
		mov	data_027D,18h
		jmp	short loc_1477
			                        ;* No entry point to code
		push	bx
		push	ax
		dec	data_027D
		jnz	loc_1477		; Jump if not zero
		push	cx
		mov	di,8
		mov	ch,50h			; 'P'
		mov	cl,40h			; '@'
		call	sub_0981
		pop	cx
		mov	data_06E4,13FCh
		mov	di,148h
		mov	word ptr ds:[243h],di
		mov	data_0241,di
		mov	bx,data_027E
		dec	bx
		mov	al,[bx]
		inc	al
		jnz	loc_147C		; Jump if not zero
loc_1477:
		pop	ax
		pop	bx
		mov	al,0FFh
		retn
loc_147C:
		mov	sp,data_0245
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1481	proc	near
		push	dx
		push	bx
		mov	bh,data_14A4
		mov	bl,0
		mov	dh,bl
		mov	dl,bh
		sub	bx,dx
		sub	bx,dx
		add	bx,0FEh
		sub	bl,bh
		jc	loc_149B		; Jump if carry Set
		dec	bl
loc_149B:
		mov	data_14A4,bl
		mov	al,bl
		pop	bx
		pop	dx
		retn
sub_1481	endp

data_14A4	db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_14A5	proc	near
loc_14A5:
		mov	al,[bx]
		cmp	al,0Bh
		jae	loc_ret_14B1		; Jump if above or =
		call	sub_14B2
		dec	bx
		jmp	short loc_14A5

loc_ret_14B1:
		retn
sub_14A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_14B2	proc	near
loc_14B2:
		push	cx
		push	si
		push	di
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		mov	si,14DFh
		add	si,ax
		mov	di,word ptr ds:[243h]
		dec	di
		dec	di
		mov	word ptr ds:[243h],di
		mov	al,43h			; 'C'
		mov	cx,108h
		call	sub_08BD
		mov	al,42h			; 'B'
		call	sub_08BD
		pop	di
		pop	si
		pop	cx
		retn
sub_14B2	endp

		db	 00h, 3Ch, 7Eh, 7Eh
		db	8 dup (66h)
		db	 7Eh, 7Eh, 3Ch, 00h, 00h
		db	 3Ch, 7Ch, 7Ch
		db	8 dup (1Ch)
		db	 7Eh, 7Eh, 7Eh, 00h, 00h, 3Ch
		db	 7Eh, 7Eh, 4Eh, 0Eh, 0Eh, 1Ch
		db	 38h, 38h, 70h, 70h, 7Eh, 7Eh
		db	 7Eh, 00h, 00h, 3Ch, 7Eh, 7Eh
		db	 4Eh, 0Eh, 0Eh, 3Ch, 3Ch, 0Eh
		db	 0Eh, 4Eh, 7Eh, 7Eh, 3Ch, 00h
		db	 00h, 1Eh, 1Eh
		db	'>>6ff~~~'
		db	 0Eh, 0Eh, 0Eh, 0Eh, 00h, 00h
		db	 7Eh, 7Eh, 7Eh, 72h, 70h, 7Eh
		db	 7Eh, 0Eh, 0Eh, 4Eh, 4Eh, 7Eh
		db	 7Eh, 3Ch, 00h, 00h
		db	'<~~rp|~~fff~~<'
		db	 00h, 00h, 7Eh, 7Eh, 7Eh, 0Eh
		db	 0Eh, 0Eh, 1Ch, 1Ch, 1Ch, 1Ch
		db	 38h, 38h, 38h, 38h, 00h, 00h
		db	'<~~fff<<fff~~<'
		db	0, 0
		db	'<~~fff~>'
		db	 0Eh, 4Eh, 4Eh, 7Eh, 7Eh, 3Ch
		db	 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_157F	proc	near
		mov	byte ptr data_181D,0
		mov	byte ptr data_1817,40h	; '@'
		mov	byte ptr data_181E,0
		mov	byte ptr data_1818,0
		mov	byte ptr data_181F,2
		retn
sub_157F	endp

			                        ;* No entry point to code
		mov	al,data_02A4
		and	al,3
		jz	loc_1611		; Jump if zero
		ror	al,1			; Rotate
		jc	loc_15BF		; Jump if carry Set
		call	sub_16AA
		mov	al,0FEh
		jc	loc_15D7		; Jump if carry Set
		mov	bl,byte ptr data_1818
		test	bl,80h
		mov	al,0FCh
		jz	loc_15D7		; Jump if zero
		mov	al,bl
		cmp	al,0F4h
		cmc				; Complement carry
loc_15BB:
		sbb	al,0
		jmp	short loc_15D7
loc_15BF:
		call	sub_16AA
		mov	al,2
		jnc	loc_15D7		; Jump if carry=0
		mov	bl,byte ptr data_1818
		test	bl,80h
		mov	al,4
		jnz	loc_15D7		; Jump if not zero
		mov	al,bl
		cmp	al,0Ch
		adc	al,0
loc_15D7:
		mov	bl,data_1817
		add	al,bl
		js	loc_15E7		; Jump if sign=1
		cmp	al,8
		jae	loc_15EB		; Jump if above or =
loc_15E3:
		mov	al,8
		jmp	short loc_160C
loc_15E7:
		test	al,40h			; '@'
		jnz	loc_15E3		; Jump if not zero
loc_15EB:
		mov	bh,data_181E
		shl	bh,1			; Shift w/zeros fill
		shl	bh,1			; Shift w/zeros fill
		add	bh,al
		sub	bh,0A0h
		jc	loc_160C		; Jump if carry Set
		test	data_0259,80h
		jnz	loc_161E		; Jump if not zero
		mov	al,data_181E
		neg	al
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	al,9Fh
loc_160C:
		mov	data_1817,al
		sub	al,bl
loc_1611:
		mov	byte ptr data_1818,al
		or	al,al			; Zero ?
		jz	loc_ret_161D		; Jump if zero
		or	byte ptr data_181F,2

loc_ret_161D:
		retn
loc_161E:
		call	sub_1B3A
		call	sub_234B
		xor	al,al			; Zero register
		mov	di,offset data_1BB6
		mov	ch,1
		mov	cl,10h
		call	sub_0983
		mov	byte ptr data_181D,0
		mov	al,0A0h
loc_1637:
		push	ax
		mov	data_1817,al
		mov	bx,data_02A1
		inc	bx
		mov	al,[bx]
		or	al,al			; Zero ?
		jnz	loc_164C		; Jump if not zero
		mov	data_02A1,53D1h
loc_164C:
		or	byte ptr data_181F,2
		call	sub_1761
		mov	di,offset data_1BB8
		xor	al,al			; Zero register
		mov	ch,4
		mov	cl,0Ch
		call	sub_0983
		call	sub_22FF
		call	sub_22FF
		pop	ax
		inc	al
		cmp	al,0C1h
		jne	loc_1637		; Jump if not equal
		mov	bx,offset data_0337
		mov	cx,0Fh

locloop_1673:
		push	cx
		mov	cx,0Bh

locloop_1677:
		mov	al,[bx]
		and	al,7
		jz	loc_168C		; Jump if zero
		push	bx
		push	cx
		mov	bx,offset data_02CB
		cbw				; Convrt byte to word
		add	bx,ax
		mov	dl,[bx]
		call	sub_244E
		pop	cx
		pop	bx
loc_168C:
		inc	bx
		inc	bx
		loop	locloop_1677		; Loop if cx > 0

		add	bx,0Ah
		pop	cx
		loop	locloop_1673		; Loop if cx > 0

		mov	cx,14h

locloop_1699:
		push	cx
		call	sub_22FF
		pop	cx
		loop	locloop_1699		; Loop if cx > 0

		mov	sp,data_0247
		call	sub_119E
		jmp	loc_0C73

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_16AA	proc	near
		mov	bh,data_1B73
		mov	bl,byte ptr data_1B70+1
		test	byte ptr data_1B86,0FFh
		jz	loc_16C8		; Jump if zero
loc_16B9:
		test	byte ptr data_1B97,0FFh
		jz	loc_16D7		; Jump if zero
loc_16C0:
		mov	al,data_1817
		add	al,0Ah
		sub	al,bl
		retn
loc_16C8:
		mov	al,data_1B84
		cmp	al,bh
		jb	loc_16B9		; Jump if below
		mov	bh,al
		mov	bl,data_1B82
		jmp	short loc_16B9
loc_16D7:
		cmp	data_1B95,bh
		jb	loc_16C0		; Jump if below
		mov	bl,data_1B93
		jmp	short loc_16C0
sub_16AA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_16E3	proc	near
		test	data_0259,20h		; ' '
		mov	al,data_023E
		jnz	loc_16F7		; Jump if not zero
		dec	al
		mov	data_023E,al
		jnz	loc_1707		; Jump if not zero
		jmp	short loc_1702
		db	90h
loc_16F7:
		inc	al
		mov	data_023E,al
		cmp	al,19h
		jb	loc_1707		; Jump if below
		mov	al,19h
loc_1702:
		and	data_0259,9Fh
loc_1707:
		mov	bx,offset data_02A9
		cbw				; Convrt byte to word
		add	bx,ax
		mov	al,data_181E
		mov	cl,[bx]
		sub	al,cl
		mov	ch,al
		mov	al,data_1817
		add	al,ch
		add	al,ch
		cmp	al,8
		jae	loc_1723		; Jump if above or =
		mov	al,8
loc_1723:
		mov	ch,al
		add	al,cl
		add	al,cl
		add	al,cl
		add	al,cl
		sub	al,0A0h
		jc	loc_1737		; Jump if carry Set
		neg	al
		add	al,0A0h
		mov	ch,al
loc_1737:
		mov	data_1817,ch
		mov	data_181E,cl
		or	byte ptr data_181F,2
		retn
sub_16E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1745	proc	near
		mov	al,data_181F
		test	al,4
		jz	loc_ret_1760		; Jump if zero
		mov	di,word ptr data_1818+1
		mov	si,data_181B
		and	al,0FBh
		mov	data_181F,al
		test	al,1
		jnz	loc_17C3		; Jump if not zero
		jmp	loc_180A

loc_ret_1760:
		retn

;==== External Entry into Subroutine ======================================

sub_1761:
		test	byte ptr data_181F,2
		jz	loc_ret_17CF		; Jump if zero
		test	byte ptr data_181F,4
		jz	loc_1772		; Jump if zero
		call	sub_1745
loc_1772:
		or	byte ptr data_181F,4
		and	byte ptr data_181F,0FDh
		mov	cl,data_181E
		mov	ah,cl
		or	cl,cl			; Zero ?
		jz	loc_17D0		; Jump if zero
		or	byte ptr data_181F,1
		mov	si,6B32h
		xor	ch,ch			; Zero register

locloop_1790:
		add	si,240h
		loop	locloop_1790		; Loop if cx > 0

		mov	al,data_1817
		add	al,ah
		add	al,ah
		sub	al,8
		mov	cl,al
		and	cl,7
		inc	cl
		xor	ch,ch			; Zero register

locloop_17A8:
		add	si,48h
		loop	locloop_17A8		; Loop if cx > 0

		mov	data_181B,si
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		cbw				; Convrt byte to word
		mov	di,1B88h
		shl	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	word ptr data_1818+1,di
loc_17C3:
		mov	al,7
		mov	cl,0Ch
		mov	ch,6
		call	sub_2536
		call	sub_255C

loc_ret_17CF:
		retn
loc_17D0:
		and	byte ptr data_181F,0FEh
		mov	bx,offset data_5BAA
		mov	al,data_181D
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		add	bx,ax
		mov	si,[bx]
		mov	ah,data_1817
		mov	bl,ah
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		xor	bh,bh			; Zero register
		xor	al,al			; Zero register
		and	ah,7
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	si,ax
		mov	di,1B88h
		shl	bx,1			; Shift w/zeros fill
		add	di,bx
		mov	word ptr data_1818+1,di
		mov	data_181B,si
loc_180A:
		mov	al,7
		mov	cl,0Ch
		mov	ch,4
		call	sub_2536
		call	sub_255C
		retn
sub_1745	endp

data_1817	db	0
data_1818	dw	0			; Data table (indexed access)
		db	0
data_181B	dw	0
data_181D	db	0
data_181E	db	0
data_181F	db	2

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1820	proc	near
		mov	bx,1B70h
		mov	byte ptr [bx+1],4Eh	; 'N'
		mov	byte ptr [bx+3],0ABh
		mov	byte ptr [bx+4],5
		mov	byte ptr [bx+5],0
		mov	byte ptr [bx+6],0
		add	bx,11h
		mov	byte ptr [bx+5],0FFh
		mov	byte ptr [bx+6],0
		add	bx,11h
		mov	byte ptr [bx+5],0FFh
		mov	byte ptr [bx+6],0
		retn
sub_1820	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_184E	proc	near
		mov	si,offset data_1B70
		mov	cx,3

locloop_1854:
		test	byte ptr [si+5],0FFh
		jnz	loc_185F		; Jump if not zero
		push	cx
		call	sub_1865
		pop	cx
loc_185F:
		add	si,11h
		loop	locloop_1854		; Loop if cx > 0

		retn
sub_184E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1865	proc	near
		test	data_0259,8
		jnz	loc_18DB		; Jump if not zero
loc_186C:
		mov	bl,[si+4]
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bx,offset data_1BA3
		mov	bp,[bx]
		mov	ch,6
		rol	bp,1			; Rotate
		sbb	ch,0
		ror	bp,1			; Rotate
		mov	di,[bx+2]
		mov	cl,6
		rol	di,1			; Rotate
		sbb	cl,0
		ror	di,1			; Rotate
		mov	bx,[si]
		mov	[si+0Fh],bh
		mov	ax,[si+2]
		mov	[si+10h],ah
		mov	dh,data_0258
loc_189F:
		add	ax,bp
		cmp	ah,0ACh
		je	loc_1912		; Jump if equal
		cmp	ah,0BCh
		je	loc_18D8		; Jump if equal
		cmp	ah,7
		je	loc_18E6		; Jump if equal
		mov	dl,ah
		and	dl,7
		cmp	dl,ch
		je	loc_18DE		; Jump if equal
loc_18B9:
		add	bx,di
		cmp	bh,7
		je	loc_1901		; Jump if equal
		cmp	bh,0B4h
		je	loc_1901		; Jump if equal
		mov	dl,bh
		and	dl,7
		cmp	dl,cl
		je	loc_18FC		; Jump if equal
loc_18CE:
		dec	dh
		jnz	loc_189F		; Jump if not zero
		mov	[si+2],ax
		mov	[si],bx
		retn
loc_18D8:
		jmp	loc_19C2
loc_18DB:
		jmp	loc_197C
loc_18DE:
		call	sub_1AAB
		jz	loc_18B9		; Jump if zero
		call	sub_1A6A
loc_18E6:
		xor	ch,3
		neg	bp
		add	ax,bp
		mov	dl,5
		sub	dl,[si+4]
		jnc	loc_18F7		; Jump if carry=0
		add	dl,0Ch
loc_18F7:
		mov	[si+4],dl
		jmp	short loc_18B9
loc_18FC:
		call	sub_1AAB
		jz	loc_18CE		; Jump if zero
loc_1901:
		xor	cl,3
		neg	di
		add	bx,di
		mov	dl,0Bh
		sub	dl,[si+4]
		mov	[si+4],dl
		jmp	short loc_18CE
loc_1912:
		mov	[si+2],ax
		mov	[si],bx
		mov	cl,data_181E
		shl	cl,1			; Shift w/zeros fill
		shl	cl,1			; Shift w/zeros fill
		mov	ch,cl
		add	ch,18h
		mov	al,data_1817
		sub	al,2
		sub	al,bh
		neg	al
		cmp	al,ch
		jae	loc_ret_197B		; Jump if above or =
		mov	ch,al
		mov	al,data_0258
		cmp	al,6
		cmc				; Complement carry
		sbb	al,0
		mov	data_0258,al
		mov	al,cl
		sub	al,3
		cmc				; Complement carry
		mov	al,4
		adc	al,0
		mov	cl,al
		mov	al,ch
		mov	ch,9
loc_194D:
		dec	ch
		sub	al,cl
		jnc	loc_194D		; Jump if carry=0
		mov	al,ch
		cmp	al,3
		adc	al,0
		cmp	al,3
		adc	al,0
		mov	[si+4],al
		mov	data_02A1,53C2h
		mov	data_0267,14h
		mov	byte ptr [si+3],0ABh
		test	data_0259,8
		jz	loc_ret_197B		; Jump if zero
		mov	data_025A,80h

loc_ret_197B:
		retn
loc_197C:
		mov	al,data_025A
		dec	al
		jz	loc_19BF		; Jump if zero
		mov	data_025A,al
		push	ax
		mov	ah,byte ptr data_1818
		mov	al,byte ptr data_1B70+1
		mov	data_1B7F,al
		add	al,ah
		cmp	al,8
		jae	loc_1999		; Jump if above or =
		mov	al,8
loc_1999:
		cmp	al,0B4h
		jb	loc_199F		; Jump if below
		mov	al,0B3h
loc_199F:
		mov	byte ptr data_1B70+1,al
		pop	ax
		cmp	al,2
		je	loc_19AF		; Jump if equal
		test	data_02A4,10h
		jnz	loc_19AF		; Jump if not zero
		retn
loc_19AF:
		mov	data_025A,1
		dec	data_025B
		jnz	loc_19BF		; Jump if not zero
		and	data_0259,0F7h
loc_19BF:
		jmp	loc_186C
loc_19C2:
		mov	[si+2],ax
		mov	[si],bx
		call	sub_1B3A
		mov	byte ptr [si+5],0FFh
		mov	cl,byte ptr data_1B86
		mov	al,byte ptr data_1B97
		and	al,cl
		jz	loc_19DE		; Jump if zero
		and	data_0259,0EFh
loc_19DE:
		pop	bx
		pop	ax
		push	ax
		push	bx
		cmp	al,3
		je	loc_19E7		; Jump if equal
		retn
loc_19E7:
		push	si
		mov	si,offset data_1B81
		test	byte ptr [si+5],0FFh
		jz	loc_19FE		; Jump if zero
		mov	si,offset data_1B92
		test	byte ptr [si+5],0FFh
		jz	loc_19FE		; Jump if zero
		pop	si
		jmp	short loc_1A11
		db	90h
loc_19FE:
		push	ds
		pop	es
		cld				; Clear direction
		mov	di,offset data_1B70
		mov	bx,si
		mov	cx,0Dh
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	byte ptr [bx+5],0FFh
		pop	si
		retn
loc_1A11:
		call	sub_1B3A
		call	sub_1745
		mov	sp,data_0247
		call	sub_234B
		mov	data_0FF5,42h		; 'B'
		test	data_02C3,0FFh
		jz	loc_1A2D		; Jump if zero
		call	sub_0DBA
loc_1A2D:
		mov	data_181D,0
		mov	data_181E,0
loc_1A37:
		mov	data_181F,2
		call	sub_1761
		test	data_181D,1
		jnz	loc_1A4C		; Jump if not zero
		mov	data_02A1,53C8h
loc_1A4C:
		call	sub_22FF
		call	sub_22FF
		call	sub_22FF
		call	sub_22FF
		call	sub_22FF
		call	sub_1745
		inc	data_181D
		cmp	data_181D,7
		jne	loc_1A37		; Jump if not equal
		retn
sub_1865	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1A6A	proc	near
		rol	bp,1			; Rotate
		cmc				; Complement carry
		sbb	data_0267,0
		ror	bp,1			; Rotate
		jz	loc_1A77		; Jump if zero
		retn
loc_1A77:
		cmp	data_0258,7
		adc	data_0258,0
		sub	byte ptr data_1B74,1
		jnc	loc_1A8D		; Jump if carry=0
		mov	byte ptr data_1B74,0Bh
loc_1A8D:
		sub	byte ptr data_1B85,1
		jnc	loc_1A99		; Jump if carry=0
		mov	byte ptr data_1B85,0Bh
loc_1A99:
		sub	byte ptr data_1B96,1
		jnc	loc_1AA5		; Jump if carry=0
		mov	byte ptr data_1B96,0Bh
loc_1AA5:
		mov	data_0267,14h
		retn
sub_1A6A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1AAB	proc	near
		push	ax
		push	bx
		mov	al,ah
		add	al,2
		and	al,0F8h
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		mov	bl,bh
		add	bl,2
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		or	al,bl
		mov	bx,ax
		add	bx,offset data_02D6
		mov	al,[bx]
		and	al,7
		jz	loc_1AE1		; Jump if zero
		pushf				; Push flags
		push	si
		push	bp
		push	di
		push	cx
		push	dx
		call	sub_25C7
		pop	dx
		pop	cx
		pop	di
		pop	bp
		pop	si
		popf				; Pop flags
loc_1AE1:
		pop	bx
		pop	ax
		retn
sub_1AAB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1AE4	proc	near
		push	si
		push	di
		mov	al,7
		mov	ch,2
		mov	cl,5
		call	sub_2536
		mov	cx,3
		mov	bx,offset data_1B70

locloop_1AF5:
		test	byte ptr [bx+5],0FFh
		jnz	loc_1B32		; Jump if not zero
		push	cx
		test	byte ptr [bx+6],0FFh
		jz	loc_1B0B		; Jump if zero
		mov	di,[bx+9]
		mov	si,[bx+0Bh]
		call	sub_255C
loc_1B0B:
		mov	dh,[bx+3]
		mov	dl,[bx+1]
		call	sub_2594
		mov	[bx+9],di
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		mov	cx,ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	cx,ax
		mov	si,76BAh
		add	si,cx
		mov	[bx+0Bh],si
		call	sub_255C
		pop	cx
		mov	byte ptr [bx+6],1
loc_1B32:
		add	bx,11h
		loop	locloop_1AF5		; Loop if cx > 0

		pop	di
		pop	si
		retn
sub_1AE4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1B3A	proc	near
		mov	cx,3
		mov	bx,1B70h
		push	si
		push	di
		push	cx
		mov	al,7
		mov	ch,2
		mov	cl,5
		call	sub_2536
		pop	cx

locloop_1B4D:
		test	byte ptr [bx+5],0FFh
		jnz	loc_1B68		; Jump if not zero
		test	byte ptr [bx+6],0FFh
		jz	loc_1B68		; Jump if zero
		push	cx
		mov	di,[bx+9]
		mov	si,[bx+0Bh]
		call	sub_255C
		pop	cx
		mov	byte ptr [bx+6],0
loc_1B68:
		add	bx,11h
		loop	locloop_1B4D		; Loop if cx > 0

		pop	di
		pop	si
		retn
sub_1B3A	endp

data_1B70	dw	4F66h
		db	0A9h
data_1B73	db	0ABh
data_1B74	db	4
		db	10 dup (0)
data_1B7F	db	0
		db	0
data_1B81	db	0
data_1B82	db	10h
		db	0
data_1B84	db	0B0h
data_1B85	db	9
data_1B86	dw	0FFFFh
		db	0
		db	9 dup (0)
data_1B92	db	0
data_1B93	db	20h
		db	0
data_1B95	db	0B0h
data_1B96	db	9
data_1B97	dw	0FFFFh
		db	0
		db	9 dup (0)
data_1BA3	db	0D4h
		db	 00h, 37h, 00h, 96h, 00h, 96h
		db	 00h, 42h, 00h,0CDh, 00h,0BEh
		db	0FFh,0CDh, 00h, 6Ah,0FFh, 96h
data_1BB6	db	0
		db	2Ch
data_1BB8	db	0FFh
		db	 37h, 00h, 2Ch,0FFh,0C9h,0FFh
		db	 6Ah,0FFh, 6Ah,0FFh,0BEh,0FFh
		db	 33h,0FFh, 42h, 00h, 33h,0FFh
		db	 96h, 00h, 6Ah,0FFh,0D4h, 00h
		db	0C9h,0FFh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1BD3	proc	near
		mov	bx,offset data_2028
		mov	cx,3FFh
		mov	al,data_205D
		dec	al
		jnz	loc_1BE4		; Jump if not zero
		mov	cl,al
		mov	al,6
loc_1BE4:
		mov	data_205D,al
loc_1BE7:
		push	cx
		test	byte ptr [bx+5],0FFh
		jz	loc_1C5C		; Jump if zero
		test	cl,0FFh
		jnz	loc_1C0B		; Jump if not zero
		mov	dh,data_024A
		mov	al,[bx+4]
		add	al,2
		cmp	al,dh
		jne	loc_1C08		; Jump if not equal
		test	byte ptr [bx+5],4
		jz	loc_1C08		; Jump if zero
		xor	al,al			; Zero register
loc_1C08:
		mov	[bx+4],al
loc_1C0B:
		mov	al,[bx+1]
		mov	[bx],al
		mov	al,[bx+3]
		mov	[bx+2],al
		test	byte ptr [bx+5],2
		jnz	loc_1C62		; Jump if not zero
		mov	dh,[bx+3]
		inc	dh
		cmp	dh,9
		mov	dl,[bx+1]
		jz	loc_1C2C		; Jump if zero
		jmp	loc_1D5D
loc_1C2C:
		or	byte ptr [bx+5],2
		mov	al,data_2058
		shl	al,1			; Shift w/zeros fill
		cbw				; Convrt byte to word
		mov	di,8
		add	di,ax
		mov	word ptr ds:[243h],di
		mov	byte ptr ds:[2D5h],45h	; 'E'
		mov	al,69h			; 'i'
		call	sub_0AE2
		mov	al,6Ah			; 'j'
		call	sub_0AE2
		mov	al,6Bh			; 'k'
		call	sub_0AE2
		mov	byte ptr data_205B,0
		mov	byte ptr [bx+0Ch],0
loc_1C5C:
		jmp	loc_1DC1
loc_1C5F:
		jmp	loc_1E59
loc_1C62:
		test	byte ptr [bx+5],4
		jz	loc_1C5F		; Jump if zero
		mov	al,[bx+1]
		and	al,0Eh
		cmp	al,0Ah
		jne	loc_1CA1		; Jump if not equal
		cmp	byte ptr [bx+0Fh],0Fh
		jb	loc_1CA1		; Jump if below
		test	byte ptr [bx+4],0FFh
		jz	loc_1CA1		; Jump if zero
		mov	di,[bx+0Dh]
		add	di,40h
		mov	al,[di]
		and	al,7
		jnz	loc_1CA1		; Jump if not zero
		dec	di
		mov	al,[di]
		and	al,7
		jnz	loc_1C99		; Jump if not zero
		add	di,3
		mov	al,[di]
		and	al,7
		jz	loc_1CA1		; Jump if zero
loc_1C99:
		mov	byte ptr [bx+0Ch],0
		mov	byte ptr [bx+0Fh],0
loc_1CA1:
		cmp	byte ptr [bx+0Fh],0Eh
		jb	loc_1CC4		; Jump if below
		cmp	byte ptr [bx+3],48h	; 'H'
		jb	loc_1CC4		; Jump if below
		mov	byte ptr [bx+0Fh],0
		mov	al,[bx+0Ch]
		inc	al
		and	al,7
		mov	cl,al
		call	sub_1481
		test	al,1
		jnz	loc_1CC4		; Jump if not zero
		mov	[bx+0Ch],cl
loc_1CC4:
		mov	al,[bx+0Ch]
		cbw				; Convrt byte to word
		shl	al,1			; Shift w/zeros fill
		mov	di,offset data_2868
		add	di,ax
		mov	dx,[di]
		add	dl,[bx+1]
		add	dh,[bx+3]
		mov	cl,dh
		and	cl,0F8h
		mov	ch,0
		shl	cx,1			; Shift w/zeros fill
		shl	cx,1			; Shift w/zeros fill
		mov	al,dl
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		or	cl,al
		mov	si,cx
		add	si,offset data_02D6
		mov	[bx+0Dh],si
		test	dh,80h
		jz	loc_1D04		; Jump if zero
		mov	al,dh
		add	al,data_024C
		cmp	al,0C0h
		jae	loc_1D4F		; Jump if above or =
loc_1D04:
		xor	ax,ax			; Zero register
		mov	cl,dh
		and	cl,7
		add	cl,data_024C
		cmp	cl,11h
		jb	loc_1D17		; Jump if below
		or	ax,[si+40h]
loc_1D17:
		or	ax,[si]
		or	ax,[si+20h]
		mov	cl,dl
		and	cl,6
		cmp	cl,6
		jne	loc_1D29		; Jump if not equal
		or	al,[si+42h]
loc_1D29:
		or	al,[si+2]
		or	al,[si+22h]
		or	al,ah
		test	al,7
		jz	loc_1D5D		; Jump if zero
		test	byte ptr data_2059+1,1
		mov	al,2
		jnz	loc_1D40		; Jump if not zero
		neg	al
loc_1D40:
		add	al,[bx+0Ch]
		and	al,6
		mov	[bx+0Ch],al
		mov	byte ptr [bx+0Fh],0
		jmp	loc_1CA1
loc_1D4F:
		call	sub_1F22
		mov	byte ptr [bx+5],0
		dec	data_205C
		jmp	short loc_1DC1
		db	90h
loc_1D5D:
		push	dx
		and	byte ptr [bx+5],7Fh
		push	bx
		mov	si,offset data_2028
		mov	cx,3
		mov	bh,ch
		mov	bl,dh
		mov	dh,ch
		mov	ah,ch
		mov	al,data_024C
		mov	bp,ax

locloop_1D76:
		test	byte ptr [si+5],80h
		jnz	loc_1D92		; Jump if not zero
loc_1D7C:
		add	si,10h
		loop	locloop_1D76		; Loop if cx > 0

		pop	bx
		pop	dx
		or	byte ptr [bx+5],80h
		mov	[bx+1],dl
		mov	[bx+3],dh
		inc	byte ptr [bx+0Fh]
		jmp	short loc_1DC1
loc_1D92:
		mov	al,[si+1]
		sub	ax,dx
		jns	loc_1D9B		; Jump if not sign
		neg	ax
loc_1D9B:
		cmp	ax,0Dh
		jae	loc_1D7C		; Jump if above or =
		mov	al,[si+3]
		sub	ax,bx
		jns	loc_1DA9		; Jump if not sign
		neg	ax
loc_1DA9:
		cmp	ax,bp
		jae	loc_1D7C		; Jump if above or =
		pop	bx
		pop	dx
		mov	al,[bx+0Ch]
		and	al,6
		xor	al,4
		mov	[bx+0Ch],al
		mov	byte ptr [bx+0Fh],0
		or	byte ptr [bx+5],80h
loc_1DC1:
		pop	cx
		add	bx,10h
		dec	ch
		jz	loc_1DCC		; Jump if zero
		jmp	loc_1BE7
loc_1DCC:
		mov	bx,data_2059
		inc	bx
		mov	data_2059,bx
		test	byte ptr data_205B,0FFh
		jnz	loc_ret_1DF3		; Jump if not zero
		mov	al,bh
		shr	al,1			; Shift w/zeros fill
		sub	al,3
		jc	loc_ret_1DF3		; Jump if carry Set
		cmp	al,4
		mov	dl,al
		jc	loc_1DEC		; Jump if carry Set
		mov	dl,3
loc_1DEC:
		mov	al,data_205C
		cmp	al,dl
		jb	loc_1DF4		; Jump if below

loc_ret_1DF3:
		retn
loc_1DF4:
		test	byte ptr data_202D,0FFh
		jnz	loc_1E00		; Jump if not zero
		mov	bx,2028h
		jmp	short loc_1E0F
loc_1E00:
		test	byte ptr data_203D,0FFh
		jnz	loc_1E0C		; Jump if not zero
		mov	bx,2038h
		jmp	short loc_1E0F
loc_1E0C:
		mov	bx,offset data_2048
loc_1E0F:
		mov	al,data_2058
		xor	al,9
		mov	data_2058,al
		shl	al,1			; Shift w/zeros fill
		cbw				; Convrt byte to word
		mov	di,8
		add	di,ax
		mov	word ptr ds:[243h],di
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	al,6
		mov	[bx+1],al
		mov	byte ptr [bx+5],0F5h
		mov	byte ptr [bx+3],0
		mov	byte ptr ds:[2D5h],7
		mov	al,20h			; ' '
		call	sub_0AE2
		mov	al,20h			; ' '
		call	sub_0AE2
		mov	al,20h			; ' '
		call	sub_0AE2
		mov	byte ptr data_205B,0FFh
		mov	byte ptr [bx+4],0
		inc	data_205C
		call	sub_1E8C
		retn
loc_1E59:
		mov	al,[bx+4]
		cmp	al,0Eh
		jne	loc_1E72		; Jump if not equal
		call	sub_1F22
		mov	byte ptr [bx+5],0
		dec	data_205C
		mov	dl,10h
		push	bx
		call	sub_244E
		pop	bx
loc_1E72:
		jmp	loc_1DC1
sub_1BD3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1E75	proc	near
		mov	bx,offset data_2028
		mov	cx,3

locloop_1E7B:
		test	byte ptr [bx+5],0FFh
		jz	loc_1E86		; Jump if zero
		push	cx
		call	sub_1E8C
		pop	cx
loc_1E86:
		add	bx,10h
		loop	locloop_1E7B		; Loop if cx > 0

		retn
sub_1E75	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1E8C	proc	near
		test	byte ptr [bx+5],8
		jz	loc_1E95		; Jump if zero
		call	sub_1F22
loc_1E95:
		or	byte ptr [bx+5],8
		mov	dl,[bx+1]
		test	byte ptr [bx+5],4
		jz	loc_1EB0		; Jump if zero
		mov	cl,data_024C
		mov	ch,data_024A
		mov	si,data_024D
		jmp	short loc_1EB7
loc_1EB0:
		mov	cl,0Bh
		mov	ch,0Eh
		mov	si,offset data_53FE	; ('6TNTfT T')
loc_1EB7:
		xor	ax,ax			; Zero register
		test	dl,2
		jz	loc_1EC0		; Jump if zero
		add	al,ch
loc_1EC0:
		test	dl,4
		jz	loc_1EC9		; Jump if zero
		add	al,ch
		add	al,ch
loc_1EC9:
		add	al,[bx+4]
		add	si,ax
		mov	si,[si]
		mov	dl,[bx+1]
		mov	dh,[bx+3]
		push	cx
		call	sub_2594
		pop	cx
		mov	ch,3
		and	byte ptr [bx+5],0FEh
		mov	al,[bx+1]
		and	al,6
		cmp	al,6
		je	loc_1EF0		; Jump if equal
		or	byte ptr [bx+5],1
		dec	ch
loc_1EF0:
		mov	al,data_024B
		test	byte ptr [bx+5],4
		jnz	loc_1EFB		; Jump if not zero
		mov	al,0FEh
loc_1EFB:
		mov	[bx+0Ah],al
		mov	[bx+6],di
		mov	[bx+8],si
		call	sub_2536
		call	sub_255C
		retn
sub_1E8C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1F0B	proc	near
		mov	bx,offset data_2028
		mov	cx,3

locloop_1F11:
		test	byte ptr [bx+5],0FFh
		jz	loc_1F1C		; Jump if zero
		push	cx
		call	sub_1F22
		pop	cx
loc_1F1C:
		add	bx,10h
		loop	locloop_1F11		; Loop if cx > 0

		retn
sub_1F0B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1F22	proc	near
		test	byte ptr [bx+5],8
		jz	loc_ret_1F59		; Jump if zero
		and	byte ptr [bx+5],0F7h
		mov	di,[bx+6]
		mov	si,[bx+8]
		mov	ch,3
		test	byte ptr [bx+5],1
		jz	loc_1F3C		; Jump if zero
		dec	ch
loc_1F3C:
		mov	cl,data_024C
		test	byte ptr [bx+5],4
		jnz	loc_1F48		; Jump if not zero
		mov	cl,0Bh
loc_1F48:
		mov	al,[bx+0Ah]
		call	sub_24D1
		jz	loc_ret_1F59		; Jump if zero
		mov	al,[bx+5]
		or	al,0F9h
		inc	al
		jz	loc_1F5A		; Jump if zero

loc_ret_1F59:
		retn
loc_1F5A:
		mov	al,data_024C
		add	al,[bx+2]
		cmp	al,0B0h
		jb	loc_1F8F		; Jump if below
		mov	al,data_181E
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		mov	cl,al
		add	al,27h			; '''
		mov	ch,al
		mov	al,data_1817
		sub	al,0Ch
		sub	al,[bx]
		neg	al
		cmp	al,ch
		jae	loc_1F8F		; Jump if above or =
		test	data_02C3,0FFh
		jnz	loc_1F88		; Jump if not zero
		jmp	short loc_1FC6
		db	90h
loc_1F88:
		mov	byte ptr [bx+5],0
		jmp	loc_1A11
loc_1F8F:
		test	data_02C3,0FFh
		jnz	loc_ret_1FDF		; Jump if not zero
		mov	si,offset data_1B70
		mov	ch,3
		mov	cl,data_024C
		add	cl,6
		mov	dh,[bx+2]
		sub	dh,5
		mov	dl,[bx]
		sub	dl,5
loc_1FAD:
		test	byte ptr [si+5],0FFh
		jz	loc_1FE0		; Jump if zero
loc_1FB3:
		add	si,11h
		dec	ch
		jnz	loc_1FAD		; Jump if not zero
		test	data_0259,4
		jz	loc_1FC6		; Jump if zero
		push	bx
		call	sub_210E
		pop	bx
loc_1FC6:
		and	byte ptr [bx+5],0FBh
		mov	byte ptr [bx+4],0
		mov	al,[bx]
		mov	[bx+1],al
		mov	al,[bx+2]
		mov	[bx+3],al
		mov	data_02A1,53B5h

loc_ret_1FDF:
		retn
loc_1FE0:
		mov	al,[si+10h]
		sub	al,dh
		cmp	al,cl
		jae	loc_1FB3		; Jump if above or =
		mov	al,[si+0Fh]
		sub	al,dl
		cmp	al,12h
		jae	loc_1FB3		; Jump if above or =
		mov	al,[si+4]
		cmp	dh,60h			; '`'
		jb	loc_2002		; Jump if below
		cmp	al,3
		jb	loc_2019		; Jump if below
		cmp	al,9
		jae	loc_2019		; Jump if above or =
loc_2002:
		sub	al,0Ch
		not	al
		mov	cl,al
		call	sub_1481
		and	al,1
		add	al,cl
		cmp	al,0Ch
		jb	loc_2023		; Jump if below
		mov	byte ptr [si+4],0
		jmp	short loc_1FC6
loc_2019:
		mov	cl,al
		mov	al,5
		sub	al,cl
		jnc	loc_2023		; Jump if carry=0
		add	al,0Ch
loc_2023:
		mov	[si+4],al
		jmp	short loc_1FC6
sub_1F22	endp

data_2028	db	0
		db	 3Fh, 00h, 88h, 00h
data_202D	db	0F3h
		db	11 dup (0)
		db	 27h, 00h, 88h, 08h
data_203D	db	0
		db	10 dup (0)
data_2048	db	0
		db	 14h, 00h, 98h, 08h
data_204D	db	0
		db	10 dup (0)
data_2058	db	0Fh
data_2059	dw	0
data_205B	db	0
data_205C	db	0
data_205D	db	1

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_205E	proc	near
		mov	al,data_0259
		test	al,6
		jnz	loc_2066		; Jump if not zero

loc_ret_2065:
		retn
loc_2066:
		test	al,4
		jnz	loc_20B7		; Jump if not zero
		test	data_02A4,10h
		jz	loc_ret_2065		; Jump if zero
		mov	data_02A1,537Ah
		mov	al,data_1817
		add	al,4
		mov	byte ptr data_0260,al
		and	al,6
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		mov	ah,al
		shl	al,1			; Shift w/zeros fill
		add	al,ah
		cbw				; Convrt byte to word
		mov	si,26E7h
		add	si,ax
		mov	data_025C,si
		mov	al,byte ptr data_0260
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		cbw				; Convrt byte to word
		mov	byte ptr data_0260+1,0B0h
		mov	di,1B88h
		shl	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	data_025E,di
		or	data_0259,6
		jmp	short loc_20BA
		db	90h
loc_20B7:
		call	sub_2113
loc_20BA:
		sub	data_025E,140h
		sub	byte ptr data_0260+1,8
		mov	bx,data_0260
		or	bh,bh			; Zero ?
		jz	loc_2108		; Jump if zero
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		inc	bl
		mov	al,bl
		mov	bl,bh
		xor	bh,bh			; Zero register
		and	bl,0F8h
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bl,al
		add	bx,offset data_02D6
		mov	al,[bx]
		and	al,7
		jnz	loc_2105		; Jump if not zero
		inc	bx
		test	byte ptr data_0260,0
		mov	al,byte ptr data_0260
		and	al,6
		cmp	al,6
		je	loc_20FF		; Jump if equal
		dec	bx
		dec	bx
loc_20FF:
		mov	al,[bx]
		and	al,7
		jz	loc_2113		; Jump if zero
loc_2105:
		call	sub_25C7
loc_2108:
		and	data_0259,0FBh
		retn

;==== External Entry into Subroutine ======================================

sub_210E:
		and	data_0259,0FBh

;==== External Entry into Subroutine ======================================

sub_2113:
loc_2113:
		mov	di,data_025E
		mov	si,data_025C
		mov	ch,3
		mov	cl,8
		mov	al,3
		call	sub_2536
		call	sub_255C
		retn
sub_205E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2128	proc	near
		call	sub_1481
		test	al,1
		jnz	loc_ret_21A5		; Jump if not zero
		test	data_0259,91h
		jnz	loc_ret_21A5		; Jump if not zero
		push	bx
		sub	bx,61h
		shr	bx,1			; Shift w/zeros fill
		mov	al,bl
		and	al,0Fh
		mov	bh,al
		mov	al,bl
		and	al,0F0h
		mov	bl,al
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		sub	al,bl
		neg	al
		add	al,bh
		mov	dx,bx
		mov	bx,word ptr data_02D3
		xor	ah,ah			; Zero register
		add	bx,ax
		mov	al,[bx]
		pop	bx
		and	al,0F0h
		jz	loc_ret_21A5		; Jump if zero
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		dec	al
		mov	data_22F9,al
		shr	al,1			; Shift w/zeros fill
		add	al,4
		mov	data_22FA,al
		mov	data_22F7,di
		or	data_0259,1
		mov	al,dh
		shl	al,1			; Shift w/zeros fill
		inc	al
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		mov	data_22FD,al
		mov	al,dl
		shr	al,1			; Shift w/zeros fill
		add	al,18h
		mov	data_22FE,al
		mov	data_22F5,5B3Ah
		push	bx
		push	di
		call	sub_22CA
		pop	di
		pop	bx

loc_ret_21A5:
		retn
sub_2128	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_21A6	proc	near
		mov	bx,data_22F7
		xor	bx,2000h
		test	bh,20h			; ' '
		jnz	loc_21B6		; Jump if not zero
		add	bx,50h
loc_21B6:
		mov	data_22F7,bx
		mov	al,data_22FE
		inc	al
		mov	data_22FE,al
		xor	ah,ah			; Zero register
		sub	ax,0A8h
		jc	loc_ret_21D8		; Jump if carry Set
		cmp	al,14h
		jb	loc_21D9		; Jump if below
		mov	al,data_0259
		and	al,0FEh
		mov	data_0259,al
		jmp	loc_22BF

loc_ret_21D8:
		retn
loc_21D9:
		mov	al,data_22FD
		add	al,0Eh
		sub	al,data_1817
		js	loc_ret_21D8		; Jump if sign=1
		mov	cl,data_181E
		shl	cl,1			; Shift w/zeros fill
		shl	cl,1			; Shift w/zeros fill
		add	cl,24h			; '$'
		sub	al,cl
		jc	loc_21F4		; Jump if carry Set
		retn
loc_21F4:
		mov	data_181D,0
		or	data_181F,2
		mov	al,data_181E
		or	al,al			; Zero ?
		jz	loc_2207		; Jump if zero
		mov	al,40h			; '@'
loc_2207:
		mov	ch,al
		mov	al,data_0259
		and	al,4
		or	al,ch
		mov	data_0259,al
		mov	ch,al
		mov	al,data_22F9
		or	al,al			; Zero ?
		jnz	loc_2229		; Jump if not zero
		mov	al,data_0258
		shr	al,1			; Shift w/zeros fill
		inc	al
		mov	data_0258,al
		jmp	loc_22B2
loc_2229:
		dec	al
		jnz	loc_2240		; Jump if not zero
		mov	data_025A,1
		mov	data_025B,23h		; '#'
		mov	al,ch
		or	al,8
		mov	data_0259,al
		jmp	short loc_22B2
loc_2240:
		dec	al
		jnz	loc_2256		; Jump if not zero
		mov	al,data_0259
		and	al,4
		or	al,20h			; ' '
		mov	data_0259,al
		mov	data_02A1,5385h
		jmp	short loc_22B2
loc_2256:
		dec	al
		jnz	loc_2290		; Jump if not zero
		mov	al,ch
		or	al,10h
		mov	data_0259,al
		push	ds
		pop	es
		cld				; Clear direction
		mov	si,offset data_1B70
		mov	di,offset data_1B81
		mov	cx,22h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	al,data_1B74
		inc	al
		cmp	al,0Ch
		jne	loc_227A		; Jump if not equal
		xor	al,al			; Zero register
loc_227A:
		mov	data_1B85,al
		sub	al,2
		jnc	loc_2283		; Jump if carry=0
		add	al,0Ch
loc_2283:
		mov	data_1B96,al
		xor	ax,ax			; Zero register
		mov	data_1B86,ax
		mov	data_1B97,ax
		jmp	short loc_22B2
loc_2290:
		dec	al
		jnz	loc_229D		; Jump if not zero
		mov	al,ch
		or	al,80h
		mov	data_0259,al
		jmp	short loc_22B2
loc_229D:
		dec	al
		jnz	loc_22AF		; Jump if not zero
		mov	al,2
		or	al,ch
		mov	data_0259,al
		mov	data_181D,1
		jmp	short loc_22B2
loc_22AF:
		call	sub_10F8
loc_22B2:
		call	sub_22BF
		mov	di,540h
		mov	word ptr ds:[243h],di
		jmp	loc_248B

;==== External Entry into Subroutine ======================================

sub_22BF:
loc_22BF:
		mov	di,data_22FB
		mov	si,data_22F5
		jmp	short loc_22E7
		db	90h

;==== External Entry into Subroutine ======================================

sub_22CA:
		mov	di,data_22F7
		mov	data_22FB,di
		mov	al,data_22F9
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		mov	si,5B3Ah
		add	si,ax
		mov	data_22F5,si
loc_22E7:
		mov	ch,2
		mov	cl,8
		mov	al,data_22FA
		call	sub_2536
		call	sub_255C
		retn
data_22F5	dw	0
data_22F7	dw	498Fh
data_22F9	db	0
data_22FA	db	4Eh
data_22FB	dw	0
data_22FD	db	0
data_22FE	db	0

;==== External Entry into Subroutine ======================================

sub_22FF:
		mov	dx,3DAh
loc_2302:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		test	al,8
		jz	loc_2302		; Jump if zero
		cli				; Disable interrupts
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		mov	ah,al
		mov	bx,data_02A1
		inc	bx
		mov	cl,[bx]
		or	cl,cl			; Zero ?
		jz	loc_231F		; Jump if zero
		mov	data_02A1,bx
		jmp	short loc_2342
loc_231F:
		mov	cl,[bx]
loc_2321:
		mov	ch,4
loc_2323:
		in	al,dx			; port 3DAh, CGA/EGA vid status
		test	al,8
		jnz	loc_232E		; Jump if not zero
		dec	ch
		jnz	loc_2323		; Jump if not zero
		sti				; Enable interrupts
		retn
loc_232E:
		dec	ch
		jz	loc_233E		; Jump if zero
		jnc	$+2			; delay for I/O
		jnc	$+2			; delay for I/O
		jnc	$+2			; delay for I/O
		jnc	$+2			; delay for I/O
		xor	al,0
		jmp	short loc_232E
loc_233E:
		dec	cl
		jnz	loc_2321		; Jump if not zero
loc_2342:
		xor	ah,2
		mov	al,ah
		out	61h,al			; port 61h, 8255 B - spkr, etc
		jmp	short loc_231F

;==== External Entry into Subroutine ======================================

sub_234B:
		test	data_0259,1
		jz	loc_2355		; Jump if zero
		call	sub_22BF
loc_2355:
		test	data_0259,4
		jz	loc_235F		; Jump if zero
		call	sub_210E
loc_235F:
		call	sub_1F0B
		xor	al,al			; Zero register
		mov	data_202D,al
		mov	data_203D,al
		mov	data_204D,al
		mov	data_205C,al
		retn

;==== External Entry into Subroutine ======================================

sub_2371:
		test	byte ptr data_23CA,0FFh
		jz	loc_ret_239C		; Jump if zero
		mov	byte ptr data_23CA,0
		mov	cl,7
		mov	ch,2
		mov	al,7
		call	sub_2536
		mov	bx,offset data_05D6
		mov	cl,0Eh

locloop_238B:
		mov	ch,0Bh
loc_238D:
		test	byte ptr [bx],80h
		jnz	loc_239D		; Jump if not zero
loc_2392:
		inc	bx
		dec	ch
		jnz	loc_238D		; Jump if not zero
		add	bx,5
		loop	locloop_238B		; Loop if cx > 0


loc_ret_239C:
		retn
loc_239D:
		mov	byte ptr data_23CA,0FFh
		push	bx
		sub	bx,5D6h
		call	sub_23C4
		xor	di,2000h
		pop	bx
		mov	al,[bx]
		and	al,70h			; 'p'
		cbw				; Convrt byte to word
		mov	si,ax
		add	si,offset data_28AE
		push	cx
		call	sub_255C
		pop	cx
		add	byte ptr [bx],10h
		jmp	short loc_2392

;==== External Entry into Subroutine ======================================

sub_23C4:
		push	bx
		shl	bx,1			; Shift w/zeros fill
		inc	bx
		jmp	short loc_23D6
data_23CA	db	0
		db	 53h, 81h,0EBh, 01h, 03h,0F6h
		db	0C3h, 01h, 75h, 01h
		db	43h
loc_23D6:
		push	ax
		push	dx
		mov	al,bl
		and	al,1Fh
		cbw				; Convrt byte to word
		add	ax,4
		shl	ax,1			; Shift w/zeros fill
		mov	di,bx
;*		and	di,0FFE0h
		db	 81h,0E7h,0E0h,0FFh	;  Fixup - byte match
		mov	dx,di
		shr	di,1			; Shift w/zeros fill
		shr	di,1			; Shift w/zeros fill
		add	di,dx
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		add	di,ax
		add	di,offset data_03C0
		pop	dx
		pop	ax
		pop	bx
		retn

;==== External Entry into Subroutine ======================================

sub_2400:
		push	ax
		push	cx
		push	bx
		push	si
		cmp	al,6
		je	loc_2410		; Jump if equal
		or	al,al			; Zero ?
		jz	loc_2410		; Jump if zero
		inc	data_0264
loc_2410:
		test	al,8
		jz	loc_2416		; Jump if zero
		or	al,40h			; '@'
loc_2416:
		and	al,47h			; 'G'
		mov	byte ptr ds:[2D5h],al
		mov	cx,2020h
		and	al,7
		jz	loc_2425		; Jump if zero
		mov	cx,5B5Ch
loc_2425:
		mov	al,ch
		call	sub_0B21
		mov	al,cl
		call	sub_0B21
		pop	si
		pop	bx
		pop	cx
		pop	ax
		retn

;==== External Entry into Subroutine ======================================

sub_2434:
		mov	di,1BB6h
		mov	si,5BEAh
		test	byte ptr data_023F,2
		jnz	loc_2444		; Jump if not zero
		mov	si,5C6Ah
loc_2444:
		mov	ch,1
		mov	cl,10h
		mov	al,5
		call	sub_08BD
		retn

;==== External Entry into Subroutine ======================================

sub_244E:
		mov	di,544h
		mov	word ptr ds:[243h],di
		mov	bx,word ptr data_026D+1
		mov	al,bl
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		or	al,bh
		add	al,dl
		daa				; Decimal adjust
		pushf				; Push flags
		push	ax
		mov	cl,al
		and	al,0Fh
		mov	byte ptr data_026F,al
		call	sub_14B2
		mov	al,cl
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		and	al,0Fh
		mov	byte ptr data_026D+1,al
		call	sub_14B2
		pop	ax
		popf				; Pop flags
		jc	loc_248B		; Jump if carry Set
		retn
loc_248B:
		mov	al,byte ptr data_026D
		inc	al
		sub	al,0Ah
		jnc	loc_249C		; Jump if carry=0
		add	al,0Ah
		mov	byte ptr data_026D,al
		jmp	loc_14B2
loc_249C:
		mov	byte ptr data_026D,al
		call	sub_14B2
		mov	al,byte ptr data_026B+1
		inc	al
		sub	al,0Ah
		jnc	loc_24BA		; Jump if carry=0
		add	al,0Ah
		cmp	al,2
		jne	loc_24B4		; Jump if not equal
		call	sub_10F8
loc_24B4:
		mov	byte ptr data_026B+1,al
		jmp	loc_14B2
loc_24BA:
		mov	byte ptr data_026B+1,al
		call	sub_14B2
		mov	al,byte ptr data_026B
		inc	al
		sub	al,0Ah
		jnc	loc_24CB		; Jump if carry=0
		add	al,0Ah
loc_24CB:
		mov	byte ptr data_026B,al
		jmp	loc_14B2
sub_21A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_24D1	proc	near
		push	bp
		push	bx
		push	cx
		push	es
		mov	bx,offset data_09C2
		and	al,7
		xlat				; al=[al+[bx]] table
		mov	ah,al
		mov	word ptr ds:[2517h],ax
		mov	ax,0B800h
		mov	es,ax
		mov	byte ptr ds:[2507h],ch
		shl	ch,1			; Shift w/zeros fill
		neg	ch
		add	ch,50h			; 'P'
		mov	byte ptr ds:[2529h],ch
		mov	dx,di
		xor	dx,2000h
		test	dh,20h			; ' '
		jnz	loc_2502		; Jump if not zero
		add	dx,50h
loc_2502:
		xor	bp,bp			; Zero register
		cld				; Clear direction
		cli				; Disable interrupts

locloop_2506:
		mov	ch,2
loc_2508:
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		mov	bx,offset data_6BBA
		add	bx,ax
		mov	ax,[bx]
		mov	bx,ax
		and	ax,0FFFFh
		xor	ax,es:[di]
		stosw				; Store ax to es:[di]
		and	ax,bx
		or	bp,ax
		dec	ch
		jnz	loc_2508		; Jump if not zero
		xchg	di,dx
		add	dx,0
		loop	locloop_2506		; Loop if cx > 0

		sti				; Enable interrupts
		mov	ax,bp
		or	al,ah
		pop	es
		pop	cx
		pop	bx
		pop	bp
		retn
sub_24D1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2536	proc	near
		push	bx
		mov	bx,offset data_09C2
		and	al,7
		xlat				; al=[al+[bx]] table
		mov	ah,al
		mov	word ptr ds:[257Fh],ax
		mov	ax,0B800h
		mov	es,ax
		mov	byte ptr ds:[255Eh],cl
		mov	byte ptr ds:[2572h],ch
		shl	ch,1			; Shift w/zeros fill
		neg	ch
		add	ch,50h			; 'P'
		mov	byte ptr ds:[258Eh],ch
		pop	bx
		retn
sub_2536	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_255C	proc	near
		push	bx
		mov	cl,1
		mov	dx,di
		xor	dh,20h			; ' '
		test	dh,20h			; ' '
		jnz	loc_256C		; Jump if not zero
		add	dx,50h
loc_256C:
		mov	bp,6BBAh
		cld				; Clear direction
		cli				; Disable interrupts

locloop_2571:
		mov	ch,2
loc_2573:
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		mov	bx,bp
		add	bx,ax
		mov	ax,[bx]
		and	ax,0FFFFh
		xor	es:[di],ax
		inc	di
		inc	di
		dec	ch
		jnz	loc_2573		; Jump if not zero
		xchg	di,dx
		add	dx,0
		loop	locloop_2571		; Loop if cx > 0

		sti				; Enable interrupts
		pop	bx
		retn
sub_255C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2594	proc	near
		mov	al,dh
		xor	di,di			; Zero register
		test	al,1
		jz	loc_25A1		; Jump if zero
		mov	di,2000h
		and	al,0FEh
loc_25A1:
		xor	ah,ah			; Zero register
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	di,ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	al,dl
		xor	ah,ah			; Zero register
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	ax,4
		shl	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	al,dl
		and	al,7
		retn
sub_2594	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_25C7	proc	near
		test	data_02C3,0FFh
		jz	loc_25D1		; Jump if zero
		jmp	loc_0EDD
loc_25D1:
		mov	data_02A1,5370h
		mov	data_0256,bx
		mov	al,[bx]
		and	al,47h			; 'G'
		cmp	al,6
		jne	loc_25F6		; Jump if not equal
		sub	bx,337h
		shr	bx,1			; Shift w/zeros fill
		add	bx,offset data_05D6
		or	byte ptr [bx],80h
		mov	data_23CA,0FFh
		retn
loc_25F6:
		cmp	al,7
		jne	loc_2622		; Jump if not equal
		sub	bx,337h
		shr	bx,1			; Shift w/zeros fill
		add	bx,offset data_05D6
		mov	al,[bx]
		test	al,80h
		jz	loc_260B		; Jump if zero
		retn
loc_260B:
		dec	al
		or	al,80h
		mov	[bx],al
		and	al,7
		jz	loc_261B		; Jump if zero
		mov	data_23CA,0FFh
		retn
loc_261B:
		and	byte ptr [bx],7Fh
		mov	bx,data_0256
loc_2622:
		mov	data_02A1,5375h
		mov	al,[bx]
		and	al,7
		mov	bx,offset data_02CB
		cbw				; Convrt byte to word
		add	bx,ax
		mov	dl,[bx]
		call	sub_244E
		mov	bx,data_0256
		sub	bx,2D6h
		test	bl,1
		jnz	loc_2649		; Jump if not zero
		dec	bx
		dec	data_0256
loc_2649:
		mov	al,bl
		and	al,1Fh
		cbw				; Convrt byte to word
		add	ax,4
		shl	ax,1			; Shift w/zeros fill
		mov	di,bx
;*		and	di,0FFE0h
		db	 81h,0E7h,0E0h,0FFh	;  Fixup - byte match
		mov	dx,di
		shr	di,1			; Shift w/zeros fill
		shr	di,1			; Shift w/zeros fill
		add	di,dx
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		add	di,ax
		push	bx
		push	di
		test	data_0259,1
		jz	loc_2675		; Jump if zero
		call	sub_22BF
loc_2675:
		call	sub_1B3A
		pop	di
		push	di
		mov	ch,2
		mov	cl,8
		call	sub_0981
		test	data_0259,1
		jz	loc_268B		; Jump if zero
		call	sub_22BF
loc_268B:
		call	sub_1AE4
		pop	di
		pop	bx
		call	sub_2128
		mov	bx,data_0256
		mov	si,bx
		sub	si,21h
		test	byte ptr [si],7
		mov	al,data_0249
		jz	loc_26A6		; Jump if zero
		and	al,3Fh			; '?'
loc_26A6:
		mov	[bx],al
		inc	bx
		inc	si
		test	byte ptr [si],7
		mov	al,data_0249
		jz	loc_26B4		; Jump if zero
		and	al,3Fh			; '?'
loc_26B4:
		mov	[bx],al
		add	bx,20h
		mov	al,[bx]
		and	al,7
		jnz	loc_26C2		; Jump if not zero
		or	byte ptr [bx],40h	; '@'
loc_26C2:
		inc	bx
		mov	al,[bx]
		and	al,7
		jnz	loc_26CC		; Jump if not zero
		or	byte ptr [bx],40h	; '@'
loc_26CC:
		dec	data_0264
		jz	loc_26D3		; Jump if zero
		retn
loc_26D3:
		mov	cx,0Ah

locloop_26D6:
		push	cx
		call	sub_22FF
		pop	cx
		loop	locloop_26D6		; Loop if cx > 0

		mov	sp,data_0247
		call	sub_119E
		jmp	loc_0C73
sub_25C7	endp

			                        ;* No entry point to code
		inc	ax
		add	byte ptr ds:[1E0h][bx+si],al
;*		shl	al,1			; Shift w/zeros fill
		db	0C0h,0E0h, 01h		;  Fixup - byte match
;*		shl	al,1			; Shift w/zeros fill
		db	0C0h,0E0h, 01h		;  Fixup - byte match
;*		shl	al,1			; Shift w/zeros fill
		db	0C0h,0E0h, 01h		;  Fixup - byte match
;*		shl	al,1			; Shift w/zeros fill
		db	0C0h,0E0h, 01h		;  Fixup - byte match
;*		rol	byte ptr [bx+si+0],80h	; Rotate
		db	0C0h, 40h, 00h, 80h	;  Fixup - byte match
		db	0A0h, 01h, 40h, 40h, 00h, 80h
		db	0E0h, 01h,0C0h,0E0h, 01h,0C0h
		db	0E0h, 01h,0C0h,0E0h, 01h,0C0h
		db	0E0h, 01h,0C0h, 40h, 00h, 80h
		db	0A0h, 01h, 40h, 10h, 00h, 20h
		db	 38h, 00h, 70h, 38h, 00h, 70h
		db	 38h, 00h, 70h, 38h, 00h, 70h
		db	 38h, 00h, 70h, 10h, 00h, 20h
		db	 28h, 00h, 50h, 04h, 00h, 08h
		db	 0Eh, 00h, 1Ch, 0Eh, 00h, 1Ch
		db	 0Eh, 00h, 1Ch, 0Eh, 00h, 1Ch
		db	 0Eh, 00h, 1Ch, 04h, 00h, 08h
		db	 0Ah, 00h, 14h
		db	24 dup (0)
data_275F	db	'PPPPxhhhhPLAYER     ROUND    SCO'
		db	'RE'
		db	0FFh
data_2782	db	4Dh
		db	 49h, 4Bh, 45h
		db	9 dup (20h)
		db	 06h, 20h, 20h, 20h, 20h, 20h
		db	0FFh
data_2796	db	0
		db	0, 0, 0, 0, 0
		db	 52h, 4Fh, 4Eh
		db	10 dup (20h)
		db	 05h, 20h, 20h, 20h, 20h, 20h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	 4Ah, 4Fh, 48h, 4Eh
		db	9 dup (20h)
		db	 04h, 20h, 20h, 20h, 20h, 20h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	 53h, 54h, 45h, 56h, 45h
		db	8 dup (20h)
		db	 03h, 20h, 20h, 20h, 20h, 20h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	 4Dh, 41h, 52h, 4Bh
		db	9 dup (20h)
		db	 02h, 20h, 20h, 20h, 20h, 20h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	 43h, 4Fh, 4Ch, 49h, 4Eh
		db	8 dup (20h)
		db	 01h, 20h, 20h, 20h, 20h, 20h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
data_281D	db	0
		db	 47h, 41h, 52h, 59h
		db	9 dup (20h)
		db	 01h, 20h, 20h, 20h, 20h, 20h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
data_2837	db	0
data_2838	db	66h
		db	67h
data_283A	db	'ggghijklgggggijklggggmabacdeabac'
		db	'deabacdeabacde'
data_2868	db	0
		db	 01h, 01h, 01h, 01h, 00h, 01h
		db	0FFh, 00h,0FFh,0FFh,0FFh,0FFh
		db	 00h,0FFh, 01h, 00h, 00h, 7Fh
		db	0FFh, 7Fh,0FFh, 7Fh,0FFh, 7Fh
		db	0FFh, 7Fh,0FFh, 7Fh,0FFh, 7Fh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 40h, 00h, 00h
		db	0A0h, 00h, 00h, 50h, 00h, 00h
		db	0A0h, 00h, 00h, 50h, 00h, 00h
		db	0A0h, 55h, 55h, 50h, 2Ah,0AAh
		db	0A0h, 15h
		db	 55h, 50h, 0Ah
data_28AA	db	0AAh
		db	0A0h, 00h
		db	0
data_28AE	db	0
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 00h, 03h, 00h, 07h, 00h
		db	 0Fh, 00h, 00h, 00h, 01h, 00h
		db	 03h, 00h, 07h, 00h, 0Eh, 00h
		db	 1Ch, 00h, 38h, 00h, 70h, 00h
		db	 00h, 00h, 0Eh, 00h, 1Ch, 00h
		db	 38h, 00h, 71h, 00h,0E3h, 01h
		db	0C7h, 03h, 8Fh, 00h, 00h, 00h
		db	0F1h, 01h,0E3h, 03h,0C7h, 07h
		db	 8Eh, 0Fh, 1Ch, 1Eh, 38h, 3Ch
		db	 70h, 00h, 00h, 07h, 0Eh, 0Eh
		db	 1Ch, 1Ch, 38h, 38h, 70h, 70h
		db	0E0h, 61h,0C0h, 43h, 80h, 00h
		db	 00h, 78h,0F0h, 71h,0E0h, 63h
		db	0C0h, 47h, 80h, 0Fh, 00h, 1Eh
		db	 00h, 3Ch, 00h, 00h, 00h, 0Fh
		db	 00h, 1Eh, 00h, 3Ch, 00h, 78h
		db	 00h, 70h, 00h, 60h, 00h, 40h
		db	 00h, 00h, 00h, 70h, 00h, 60h
		db	 00h, 40h, 00h
		db	8 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 02h
		db	12 dup (0)
		db	11 dup (7)
		db	0
		db	0Ah, 'j', 0Ah, '*', 0Ah, 0Ah, 0Ah
		db	'*', 0Ah, 0Ah, '*', 0Ah
		db	 0Eh, 0Eh, 0Eh, 0Eh, 0Eh, 4Eh
		db	 0Eh, 0Eh, 4Eh, 0Eh, 4Eh, 00h
		db	0Dh, 0Dh, 0Dh, ']', 0Dh, 0Dh, 0Dh
		db	']=', 0Dh
		db	 1Dh, 00h, 0Bh, 7Bh, 0Bh, 6Bh
		db	 0Bh, 4Bh, 7Bh, 0Bh, 0Bh, 0Bh
		db	 1Bh, 0Bh
		db	 3Ch, 0Ch
loc_297D:
		cmp	al,3Ch			; '<'
		cmp	al,0Ch
		or	al,6Ch			; 'l'
		insb				; Port dx to es:[di]
		insb				; Port dx to es:[di]
		sbb	al,0
		db	96 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 02h
		db	5Fh
		db	11 dup (0)
		db	 0Fh, 1Eh
		db	10 dup (0)
		db	 0Fh, 0Eh, 2Dh, 00h, 00h
		db	7 dup (0)
		db	 0Fh, 0Eh, 0Dh, 3Ch, 00h
		db	7 dup (0)
		db	 0Fh, 0Eh, 0Dh, 0Ch, 6Bh
		db	7 dup (0)
		db	 0Fh, 0Eh, 0Dh, 0Ch, 0Bh, 69h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 6Fh, 0Eh, 0Dh, 0Ch, 7Bh, 09h
		db	 1Fh, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 0Eh, 0Dh, 0Ch, 7Bh, 09h
		db	 0Fh, 2Eh, 00h, 00h, 00h, 00h
		db	 0Fh, 0Eh, 0Dh, 0Ch, 0Bh, 09h
		db	 0Fh, 4Eh, 3Dh, 00h, 00h, 00h
		db	 2Fh, 3Eh, 4Dh, 3Ch, 7Bh, 09h
		db	 0Fh, 0Eh, 0Dh, 4Ch, 00h, 00h
		db	 07h
		db	9 dup (7)
		db	 6Bh, 00h, 00h
		db	47 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 02h
		db	24 dup (0)
		db	 0Ch, 7Ch
		db	8 dup (0Ch)
		db	 7Ch, 0Ch
		db	12 dup (0)
		db	 0Fh, 0Fh, 0Fh, 06h, 06h, 06h
		db	 06h
		db	 46h, 46h, 46h, 46h
		db	13 dup (0)
		db	11 dup (0Ah)
		db	0, 0, 0, 0
data_2B00	db	0
		db	8 dup (0)
		db	 06h, 76h, 06h, 06h, 06h, 06h
		db	 06h, 06h, 0Fh, 0Fh, 0Fh
		db	13 dup (0)
		db	 2Bh, 0Bh, 0Bh, 0Bh, 0Bh, 6Bh
		db	 6Bh, 0Bh, 0Bh, 7Bh, 0Bh
		db	13 dup (0)
		db	 3Dh, 2Dh, 1Dh, 06h, 76h, 06h
		db	 06h, 06h, 06h, 06h, 06h
		db	25 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 02h
		db	13 dup (0)
		db	 0Dh, 0Eh, 6Fh, 07h, 00h, 09h
		db	 0Bh, 0Ch, 6Dh, 00h, 00h, 00h
		db	 0Eh, 0Fh, 07h, 09h, 00h, 0Bh
		db	 0Ch, 0Dh, 6Eh, 00h, 00h, 00h
		db	 0Fh, 07h, 09h, 0Bh, 00h, 0Ch
		db	 0Dh, 0Eh, 6Fh, 00h, 00h, 00h
		db	 07h, 09h, 0Bh, 0Ch, 00h, 0Dh
		db	 0Eh, 0Fh, 67h, 00h, 00h, 00h
		db	 09h, 0Bh, 0Ch, 0Dh, 00h, 0Eh
		db	 0Fh, 07h, 49h, 00h, 00h, 00h
		db	 4Bh, 0Ch, 0Dh, 0Eh, 00h, 0Fh
		db	 07h, 09h, 4Bh, 00h, 00h, 00h
		db	 4Ch, 0Dh, 5Eh, 0Fh, 00h, 07h
		db	 09h, 0Bh, 1Ch, 00h, 00h, 00h
		db	 3Dh, 0Eh, 2Fh, 07h, 00h, 09h
		db	 0Bh, 0Ch, 2Dh, 00h, 00h, 00h
		db	 2Eh, 0Fh, 27h, 09h, 00h, 0Bh
		db	 0Ch, 0Dh, 1Eh, 00h, 00h, 00h
		db	 7Fh, 07h, 39h, 0Bh, 00h, 0Ch
		db	 0Dh, 0Eh, 2Fh, 00h, 00h, 00h
		db	 07h, 09h, 0Bh, 0Ch, 00h, 0Dh
		db	 1Eh, 0Fh, 07h, 00h, 00h, 00h
		db	 09h, 0Bh, 0Ch, 0Dh, 00h, 0Eh
		db	 1Fh, 07h, 39h, 00h, 00h, 00h
		db	 1Bh, 1Ch, 1Dh, 1Eh, 00h, 1Fh
		db	 07h, 19h
		db	3Bh
		db	14 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 02h
		db	14 dup (0)
		db	 3Eh, 00h, 00h, 00h, 00h, 00h
		db	 6Eh, 00h, 00h, 00h, 00h, 00h
		db	 4Eh, 00h, 00h, 00h, 00h, 00h
		db	 6Eh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 2Eh, 00h, 00h, 00h, 2Eh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 07h, 07h, 07h, 07h, 07h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 07h, 07h, 07h, 07h, 07h
		db	 07h, 00h, 00h, 00h, 00h, 07h
		db	 07h, 6Ah, 07h, 07h, 07h, 3Ah
		db	 07h, 07h, 00h, 00h, 00h, 07h
		db	 07h, 3Ah, 07h, 07h, 07h, 6Ah
		db	 07h, 07h, 00h, 00h, 00h, 07h
		db	8 dup (7)
		db	0, 0, 0, 7
		db	8 dup (7)
		db	0, 0, 0, 7
		db	8 dup (7)
		db	0, 0, 0, 0, 7, 0
		db	0, 0, 0, 0, 7, 0
		db	0, 0, 0, 0, 7, 7
		db	7, 0, 7, 7, 7
		db	27 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 02h
		db	12 dup (0)
		db	 19h, 00h, 2Bh, 00h, 7Fh, 00h
		db	 7Fh, 00h, 3Bh, 00h, 39h, 00h
		db	 09h, 00h, 2Bh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 09h, 00h
		db	 09h, 00h, 0Bh, 00h, 4Fh, 00h
		db	 0Fh, 00h, 2Bh, 00h, 09h, 00h
		db	 09h, 00h, 0Bh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 09h, 00h
		db	 09h, 00h, 4Bh, 00h, 2Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 09h, 00h
		db	 09h, 00h, 06h, 0Eh, 06h, 0Eh
		db	 06h, 0Eh, 06h, 00h, 09h, 00h
		db	 09h, 00h, 0Bh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 09h, 00h
		db	 09h, 00h, 5Bh, 00h, 3Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 69h, 00h
		db	 09h, 00h, 4Bh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 69h, 00h
		db	 09h, 00h, 0Bh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Bh, 00h, 69h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 69h, 00h, 3Bh, 00h, 2Fh, 00h
		db	 7Fh, 00h, 5Bh, 00h, 19h
		db	25 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 02h
		db	16 dup (0)
		db	 3Eh, 3Eh, 3Bh, 00h
		db	7 dup (0)
		db	 7Eh, 0Eh, 0Bh, 0Bh, 0Dh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 7Eh
		db	 0Eh, 0Bh, 0Bh, 0Dh, 0Dh, 4Ah
		db	 00h, 00h, 00h, 00h, 00h, 7Eh
		db	 0Bh, 0Bh, 0Dh, 0Dh, 0Ah, 0Ah
		db	 00h, 00h, 00h, 00h, 7Eh, 0Bh
		db	 0Bh, 0Dh, 0Dh, 0Ah, 0Ah, 0Ch
		db	 0Ch, 00h, 00h, 00h
		db	'{{}', 0Dh, 0Ah, 0Ah, 0Ch, 0Ch
		db	 0Fh, 00h, 00h, 00h, 0Bh, 0Dh
		db	 5Dh, 0Ah, 0Ah, 0Ch, 0Ch, 0Fh
		db	 0Fh, 00h, 00h, 00h, 0Dh, 0Dh
		db	 0Ah, 0Ah, 6Ch, 6Ch, 6Fh, 0Fh
		db	 0Eh, 00h
data_2E00	db	0			; Data table (indexed access)
		db	 00h, 0Dh, 0Ah, 0Ah, 0Ch, 0Ch
		db	 0Fh, 0Fh, 0Eh, 0Eh, 00h, 00h
		db	 00h, 00h, 0Ah, 0Ch, 0Ch, 0Fh
		db	 0Fh, 0Eh, 0Eh, 00h, 00h, 00h
		db	 00h, 00h, 0Ch, 0Ch, 0Fh, 4Fh
		db	 0Eh, 0Eh, 0Bh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 4Fh, 4Eh
		db	 1Eh, 0Bh, 00h
		db	7 dup (0)
		db	 0Eh, 1Eh, 1Bh, 00h
		db	16 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 02h
		db	14 dup (0)
		db	6, 0, 6, 0, 6, 0
		db	6, 0, 0
		db	14 dup (0)
		db	 06h, 00h, 00h, 06h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 06h, 00h, 00h, 09h, 00h
		db	 00h, 06h, 06h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 06h, 1Dh, 06h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 00h, 2Fh, 00h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 00h, 00h, 06h, 00h, 3Eh, 00h
		db	 06h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 00h, 5Fh, 00h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 06h, 6Dh, 06h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 06h, 00h, 00h, 79h, 00h
		db	 00h, 06h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 06h, 00h, 06h
		db	 00h, 00h, 06h
		db	16 dup (0)
		db	6, 0, 6, 0, 6, 0
		db	6, 0, 0
		db	13 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 03h, 00h, 06h, 00h, 06h, 00h
		db	 00h, 00h, 06h, 00h, 06h, 00h
		db	 00h, 00h, 06h, 0Ch, 06h, 00h
		db	 00h, 00h, 06h, 0Ch, 06h, 00h
		db	 00h, 00h, 06h, 0Dh, 06h, 00h
		db	 00h, 00h, 06h, 0Dh, 06h, 00h
		db	 00h, 00h, 06h, 06h, 06h, 00h
		db	 00h, 00h, 06h, 06h, 06h
		db	17 dup (0)
		db	 2Bh, 2Fh, 2Fh, 2Fh, 2Bh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Bh, 0Ch, 7Ch, 0Ch, 0Bh
		db	7 dup (0)
		db	 0Bh, 0Fh, 5Fh, 0Fh, 0Bh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 1Bh, 1Eh, 1Eh, 0Eh, 0Bh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Bh, 0Fh, 4Fh, 3Fh, 3Bh, 00h
		db	63 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 03h, 00h, 06h, 00h, 00h
		db	9 dup (0)
		db	6
		db	11 dup (0)
		db	6
		db	11 dup (0)
		db	 06h, 00h, 00h, 00h, 00h, 49h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 00h, 49h, 1Dh
		db	 09h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 49h, 0Dh, 1Fh
		db	 1Dh, 39h, 00h, 00h, 00h, 00h
		db	 06h
data_3010	dw	4900h			; Data table (indexed access)
		db	 0Dh, 0Fh, 07h, 3Fh, 3Dh, 09h
		db	 00h, 00h, 00h, 06h, 00h, 00h
		db	 09h, 5Dh, 0Fh, 0Dh, 79h, 00h
		db	 00h, 00h, 00h, 06h, 00h, 00h
		db	 00h, 09h, 0Dh, 79h, 00h, 00h
		db	 00h, 00h, 00h, 06h, 00h, 00h
		db	 00h, 00h, 79h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 06h, 00h, 00h
		db	9 dup (0)
		db	6
		db	11 dup (0)
		db	10 dup (6)
		db	25 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 03h
		db	25 dup (0)
		db	9 dup (7)
		db	0, 0, 0, 7
		db	7 dup (0)
		db	7, 0, 0, 0, 7, 0
		db	7, 7, 7, 7, 7, 0
		db	7, 0, 0, 0, 7, 0
		db	7, 0, 0, 0, 7, 0
		db	7, 0, 0, 0, 7, 0
		db	7, 0, 7, 0, 7, 0
		db	7, 0, 0, 0, 7, 0
		db	7, 0, 0, 0, 7, 0
		db	7, 0, 0, 0, 7, 0
		db	7, 7, 7, 7, 7, 0
		db	7, 0, 0, 0, 7
		db	7 dup (0)
		db	7, 0, 0, 0, 7
		db	8 dup (7)
		db	50 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 03h
		db	24 dup (0)
		db	11 dup (6)
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 2Fh, 00h, 06h
		db	 00h, 7Bh, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 4Bh, 06h
		db	 00h, 00h, 06h, 4Dh, 00h, 06h
		db	 3Ch, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 00h, 00h, 06h, 00h, 00h, 06h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 00h, 00h, 06h, 00h, 5Eh, 06h
		db	 00h, 00h
		db	10 dup (6)
		db	25 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 03h
		db	24 dup (0)
		db	 1Eh, 1Eh, 1Eh, 00h, 0Ch, 2Ch
		db	 0Ch, 00h, 1Eh, 1Eh, 1Eh, 00h
		db	 0Bh, 0Bh, 0Bh, 00h, 0Fh, 3Fh
		db	 0Fh, 00h, 0Bh, 0Bh, 0Bh, 00h
		db	 0Ah, 4Ah, 4Ah, 00h, 0Dh, 4Dh
		db	 0Dh, 00h, 0Ah, 0Ah, 0Ah, 00h
		db	 0Dh, 0Dh, 0Dh, 00h, 0Ah, 5Ah
		db	 0Ah, 00h, 0Dh, 0Dh, 0Dh, 00h
		db	 0Fh, 0Fh, 0Fh, 00h, 0Bh, 0Bh
		db	 0Bh, 00h, 0Fh, 0Fh, 0Fh, 00h
		db	 6Ch, 6Ch, 6Ch, 00h, 6Eh, 6Eh
		db	 6Eh, 00h
		db	 6Ch, 6Ch, 6Ch
		db	85 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 03h
		db	12 dup (0)
		db	9, 'III', 9, 9, 9, 9, 'III'
		db	0, 6, 0, 0
		db	7 dup (0)
		db	6, 0
		db	9, 9, ')))))))', 9, 9
		db	 00h, 0Eh, 07h, 07h
		db	7 dup (7)
		db	 0Eh, 00h, 06h, 00h, 00h
		db	7 dup (0)
		db	 06h, 00h, 7Fh, 0Fh, 1Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 7Fh, 7Fh, 5Fh
		db	 7Fh, 00h, 0Dh, 07h, 07h
		db	7 dup (7)
		db	 7Dh, 00h, 06h
		db	9 dup (0)
		db	 06h, 00h, 0Bh, 5Bh, 0Bh, 0Bh
		db	 7Bh, 0Bh, 0Bh, 0Bh, 5Bh, 0Bh
		db	 0Bh
		db	13 dup (0)
		db	 0Bh, 6Bh, 6Bh
		db	7 dup (6Bh)
		db	 0Bh, 00h, 06h
		db	9 dup (0)
		db	6
		db	25 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 03h
		db	24 dup (0)
		db	 4Fh, 06h
		db	7 dup (4Dh)
		db	 06h, 3Fh, 00h, 6Fh, 0Eh, 06h
		db	 0Dh, 0Dh, 0Dh, 0Dh, 0Dh, 06h
		db	 0Ch, 2Fh, 00h, 6Fh, 0Eh, 0Eh
		db	 06h, 0Dh, 0Dh, 6Dh, 06h, 0Ch
		db	 0Ch, 2Fh, 00h, 6Fh, 0Eh, 0Eh
		db	 0Eh, 06h, 0Fh, 06h, 0Ch, 0Ch
		db	 0Ch, 0Fh, 00h, 3Fh, 3Eh, 3Eh
		db	 0Eh, 0Eh, 0Fh, 0Ch, 0Ch, 0Ch
		db	 0Ch, 0Fh, 00h, 0Fh, 0Eh, 0Eh
		db	 0Eh, 0Eh, 0Fh, 0Ch, 0Ch, 0Ch
		db	 0Ch, 0Fh, 00h, 0Fh, 0Eh, 6Eh
		db	 6Eh, 6Eh, 0Fh, 0Ch, 0Ch, 0Ch
		db	 0Ch, 0Fh, 00h, 07h, 0Eh, 7Eh
		db	 7Eh, 7Eh, 0Fh, 0Ch, 0Ch, 0Ch
		db	 0Ch, 07h, 00h, 0Dh, 07h, 5Eh
		db	 0Eh, 0Eh, 0Fh, 0Ch, 0Ch, 0Ch
		db	 07h, 0Dh, 00h, 0Dh, 0Dh, 07h
		db	 0Eh, 0Eh, 0Fh, 0Ch, 0Ch, 07h
		db	 0Dh, 0Dh, 00h, 0Dh, 0Dh, 0Dh
		db	 07h, 0Eh, 0Fh, 0Ch, 07h, 0Dh
		db	 0Dh, 0Dh, 00h, 3Dh, 0Dh, 0Dh
		db	 0Dh, 07h, 0Fh, 07h, 0Dh, 0Dh
		db	 0Dh, 3Dh, 00h, 00h
		db	11 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 03h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 00h, 00h
		db	7 dup (0)
		db	 4Fh, 0Fh, 00h, 0Fh, 3Fh, 00h
		db	 00h, 00h, 00h, 00h, 0Fh, 2Fh
		db	 00h, 00h, 06h, 00h, 00h, 0Fh
		db	 1Fh, 00h, 00h, 0Fh, 00h, 00h
		db	 5Eh, 0Eh, 00h, 0Eh, 0Eh, 00h
		db	 00h, 7Fh, 00h, 00h, 0Eh, 4Eh
		db	 00h, 00h, 06h, 00h, 00h, 0Eh
		db	 2Eh, 00h, 00h, 0Eh, 00h, 00h
		db	 0Dh, 3Dh, 00h, 0Dh, 0Dh, 00h
		db	 00h, 1Eh, 00h, 00h, 0Dh, 7Dh
		db	 00h, 00h, 06h, 00h, 00h, 0Dh
		db	 6Dh, 00h, 00h, 0Dh, 00h, 00h
		db	 0Ch, 0Ch, 00h, 0Ch, 0Ch, 00h
		db	 00h, 0Dh, 00h, 00h, 0Ch, 7Ch
		db	 00h, 00h, 06h, 00h, 00h, 0Ch
		db	 6Ch, 00h, 00h, 0Ch, 00h, 00h
		db	 1Bh, 0Bh, 00h, 0Bh, 3Bh, 00h
		db	 00h, 00h, 00h, 00h, 0Bh, 0Bh
		db	 00h, 00h, 06h, 00h, 00h, 2Bh
		db	 3Bh, 00h, 00h, 0Bh, 00h, 00h
		db	 09h, 09h, 00h, 09h, 69h, 00h
		db	 00h, 0Bh, 00h, 00h, 09h, 19h
		db	 00h, 00h, 00h, 00h, 00h, 19h
		db	 69h, 00h, 00h, 19h
		db	9 dup (0)
		db	 69h, 00h, 00h, 00h
		db	10 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 04h
		db	17 dup (0)
		db	7
		db	9 dup (0)
		db	 1Dh, 2Dh, 07h, 4Ch, 3Ch, 00h
		db	 00h, 00h, 00h, 00h, 00h, 7Dh
		db	 0Dh, 7Dh, 2Fh, 0Ch, 2Ch, 2Ch
		db	 00h, 00h, 00h, 00h, 00h, 4Dh
		db	 0Dh, 4Fh, 0Fh, 0Fh, 4Ch, 0Ch
		db	 00h, 00h, 00h, 00h, 0Dh, 3Dh
		db	 0Dh, 0Fh, 5Fh, 0Fh, 0Ch, 0Ch
		db	 3Ch, 00h, 00h, 00h, 0Dh, 1Dh
		db	 0Dh, 0Fh, 1Fh, 0Fh, 0Ch, 4Ch
		db	 3Ch, 00h, 00h, 00h
		db	0Dh, 'mmooo', 0Ch, 'll'
		db	0, 0, 0, 7, 0, 7
		db	0, 7, 0, 7, 0, 7
		db	7 dup (0)
		db	7
		db	11 dup (0)
		db	7
		db	11 dup (0)
		db	7
		db	9 dup (0)
		db	6, 0, 6, 0, 0
		db	7 dup (0)
		db	6, 6, 6
		db	18 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 04h
		db	24 dup (0)
		db	 4Fh, 00h, 06h, 1Eh, 1Eh, 1Eh
		db	 0Eh, 0Eh, 06h, 00h, 0Fh, 00h
		db	 0Fh, 00h, 06h, 06h, 2Eh, 2Eh
		db	 2Eh, 06h, 06h, 00h, 4Fh, 00h
		db	 0Fh, 00h, 06h, 00h, 06h, 2Eh
		db	 06h, 00h, 06h, 00h, 0Fh, 00h
		db	 0Fh, 00h, 06h, 00h, 0Bh, 07h
		db	 0Dh, 00h, 06h, 00h, 0Fh, 00h
		db	 0Fh, 00h, 06h, 00h, 7Bh, 7Ch
		db	 7Dh, 00h, 06h, 00h, 0Fh, 00h
		db	 0Fh, 00h, 06h, 00h, 0Bh, 0Ch
		db	 0Dh, 00h, 06h, 00h, 0Fh, 00h
		db	 0Fh, 00h, 06h, 00h, 0Bh, 2Ch
		db	 0Dh, 00h, 06h, 00h, 3Fh, 00h
		db	 0Fh, 00h, 06h, 00h, 0Bh, 0Ch
		db	 0Dh, 00h, 06h, 00h, 3Fh, 00h
		db	 1Fh, 00h, 06h, 00h, 0Bh, 0Ch
		db	 0Dh, 00h, 06h, 00h, 2Fh, 00h
		db	 6Fh, 06h, 06h, 06h, 3Bh, 3Ch
		db	 3Dh, 06h, 06h, 06h
		db	6Fh
		db	37 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 04h
		db	25 dup (0)
		db	9 dup (6)
		db	 00h, 00h, 00h, 3Ch, 0Dh, 0Bh
		db	 0Ah, 06h, 0Ah, 0Bh, 1Dh, 3Ch
		db	 00h, 00h, 00h, 0Ch, 1Dh, 0Bh
		db	 0Ah, 06h, 0Ah, 6Bh, 1Dh, 6Ch
		db	 00h, 00h, 00h, 6Ch, 1Dh, 0Bh
		db	 0Ah, 06h, 0Ah, 7Bh, 1Dh, 6Ch
		db	 00h, 00h, 00h, 3Ch, 1Dh, 0Bh
		db	 0Ah, 5Eh, 0Ah, 4Bh, 1Dh, 3Ch
		db	 00h, 00h, 00h, 0Ch, 2Dh, 0Bh
		db	 7Ah, 76h, 7Ah, 7Bh, 2Dh, 6Ch
		db	 00h, 00h, 00h, 0Ch, 2Dh, 5Bh
		db	 0Ah, 06h, 0Ah, 6Bh, 2Dh, 6Ch
		db	 00h, 00h, 00h, 0Ch, 2Dh, 7Bh
		db	 0Ah, 06h, 0Ah, 0Bh, 2Dh, 5Ch
		db	 00h, 00h, 00h
		db	9 dup (6)
		db	50 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 04h
		db	24 dup (0)
		db	 06h, 3Fh, 06h, 4Bh, 06h, 3Dh
		db	 06h, 4Ch, 06h, 39h, 06h, 00h
		db	 06h, 2Bh, 06h, 07h, 06h, 07h
		db	 06h, 07h, 06h, 2Eh, 06h
		db	14 dup (0)
		db	 06h, 1Bh, 06h, 06h, 00h, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
		db	 00h, 06h, 7Bh, 06h, 00h, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
		db	 00h, 06h, 00h, 06h, 5Bh, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
		db	 3Bh, 06h, 00h, 06h, 00h, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
		db	 00h, 06h, 2Bh, 06h
		db	14 dup (0)
		db	 5Bh, 06h, 7Bh, 06h, 00h, 06h
		db	 3Bh, 06h, 7Bh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 06h, 2Bh, 06h
		db	29 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 04h
		db	25 dup (0)
		db	 06h, 3Fh, 2Fh, 2Fh, 0Fh, 1Fh
		db	 4Fh, 3Fh, 06h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 06h, 06h, 06h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 5Ah, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 4Fh, 4Fh, 4Fh
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 06h, 06h, 06h, 06h, 06h
		db	 06h, 06h, 06h
		db	50 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 04h
		db	36 dup (0)
		db	 0Eh, 4Eh, 0Eh, 4Eh, 4Eh, 0Eh
		db	 0Eh, 0Eh, 0Eh, 0Eh, 4Eh, 00h
		db	 0Eh, 0Eh, 0Eh, 3Eh, 0Eh, 0Eh
		db	 0Eh, 0Eh, 0Eh, 0Eh, 2Eh, 00h
		db	 6Ch, 6Ch, 00h, 06h, 0Ch, 0Ch
		db	 0Ch, 06h, 00h, 0Ch, 0Ch, 00h
		db	 3Ch, 3Ch, 00h, 06h, 0Ch, 2Ch
		db	 3Ch, 06h, 00h, 0Ch, 0Ch, 00h
		db	 6Ch, 6Ch, 00h, 06h, 6Ch, 6Ch
		db	 6Ch, 06h, 00h
		db	 6Ch, 6Ch
		db	13 dup (0)
		db	 0Fh, 2Fh, 2Fh, 0Fh, 4Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 1Fh, 1Fh, 00h
		db	 0Fh, 0Fh, 0Fh, 5Fh, 5Fh, 5Fh
		db	 0Fh, 7Fh, 7Fh, 7Fh, 0Fh
		db	49 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 04h
		db	24 dup (0)
		db	 07h, 07h, 07h, 00h, 07h, 07h
		db	 07h, 00h, 07h, 07h, 07h, 00h
		db	 07h, 4Ch, 07h, 00h, 07h, 4Ch
		db	 07h, 00h, 07h, 4Ch, 07h, 00h
		db	 07h, 07h, 07h, 00h, 07h, 07h
		db	 07h, 00h, 07h, 07h, 07h
		db	13 dup (0)
		db	 07h, 07h, 07h, 00h, 07h, 07h
		db	 07h, 00h, 07h, 07h, 07h, 00h
		db	 07h, 6Ah, 07h, 00h, 07h, 6Ah
		db	 07h, 00h, 07h, 6Ah, 07h, 00h
		db	 07h, 07h, 07h, 00h, 07h, 07h
		db	 07h, 00h, 07h, 07h, 07h
		db	13 dup (0)
		db	 07h, 07h, 07h, 00h, 07h, 07h
		db	 07h, 00h, 07h, 07h, 07h, 00h
		db	 07h, 6Dh, 07h, 00h, 07h, 6Dh
		db	 07h, 00h, 07h, 6Dh, 07h, 00h
		db	 07h, 07h, 07h, 00h, 07h, 07h
		db	 07h, 00h, 07h, 07h, 07h
		db	25 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 04h
data_3A00	db	40 dup (0)		; Data table (indexed access)
		db	 4Fh, 4Fh, 4Fh
		db	9 dup (0)
		db	 7Fh, 7Fh, 7Fh, 00h
		db	8 dup (0)
		db	 7Fh, 7Fh, 7Fh, 00h
		dw	0, 0, 0
		db	 00h, 5Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	7 dup (0)
		db	 0Fh, 09h, 1Fh, 09h, 0Fh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	 09h, 39h, 3Fh, 09h, 09h, 3Fh
		db	 00h, 00h, 00h, 00h, 00h, 19h
		db	 09h, 69h, 69h, 09h, 09h, 29h
		db	 00h, 00h, 00h, 00h, 19h
		db	9, 9, 9, 'i', 9, 9, 9, ')'
		db	0, 0, 0
		db	9 dup (9)
		db	 00h, 00h, 39h, 09h
		db	9 dup (39h)
		db	25 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 05h
		db	12 dup (0)
		db	0Ah, 0Ah, 'JJJJZzJJJ'
		db	0
		db	0Ch, 0Ch, '<<<<', 0Ch, '<<<', 0Ch
		db	 00h, 1Dh, 1Dh, 0Dh, 1Dh, 1Dh
		db	 0Dh, 0Dh, 0Dh, 7Dh, 7Dh, 7Dh
		db	 00h, 06h, 06h, 06h, 06h, 07h
		db	 07h, 07h, 06h, 06h, 06h, 06h
		db	 00h, 0Ah, 0Ah, 0Ah, 06h, 00h
		db	 00h, 00h, 06h, 0Dh, 0Dh, 0Dh
		db	 00h, 0Ah, 0Ah, 0Ah, 06h, 00h
		db	 00h, 00h, 06h, 0Dh, 0Dh, 0Dh
		db	 00h, 00h
		db	26 dup (0)
		db	 06h, 0Ch, 0Ch, 0Ch, 06h
		db	7 dup (0)
		db	 06h, 0Ch, 0Ch, 0Ch, 06h, 00h
		db	 00h, 00h, 00h, 07h, 07h, 07h
		db	 06h, 06h, 06h, 06h, 06h, 07h
		db	 07h, 07h
		db	37 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 05h
		db	26 dup (0)
		db	 06h, 07h, 07h, 07h, 06h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 06h, 00h
		db	 00h, 4Dh, 4Dh, 4Dh, 00h, 00h
		db	 06h, 00h, 00h, 00h, 06h, 00h
		db	 3Ch, 3Ch, 5Ch, 0Ch, 0Ch, 00h
		db	 06h, 00h, 00h, 00h, 06h, 00h
		db	 79h, 79h, 79h, 79h, 79h, 00h
		db	 06h, 00h, 00h, 00h, 06h, 00h
		db	 00h, 5Bh, 5Bh, 5Bh, 00h, 00h
		db	 06h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 06h, 06h, 06h, 06h, 06h
		db	65 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 05h
		db	48 dup (0)
		db	11 dup (7)
		db	0
		db	'N>N>N>N>N>N'
		db	0, 7
		db	10 dup (7)
		db	13 dup (0)
		db	11 dup (7)
		db	 00h, 6Ah, 6Ah, 6Ah, 6Ah, 2Ah
		db	 1Ah, 1Ah, 1Ah, 6Ah, 2Ah, 2Ah
		db	 00h
		db	11 dup (7)
		db	49 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 05h
		db	12 dup (0)
		db	'9', 9, 'I', 9, '9', 9, 'I', 9, '9'
		db	9, 'I'
		db	 00h, 19h, 06h, 06h, 06h, 2Bh
		db	 06h, 0Bh, 06h, 06h, 06h, 19h
		db	 00h, 09h, 06h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 06h, 09h
		db	 00h, 09h, 06h, 3Bh, 00h, 00h
		db	 00h, 00h, 00h, 4Bh, 06h, 09h
		db	 00h, 09h, 06h, 0Bh, 3Bh, 00h
		db	 00h, 00h, 0Bh, 4Bh, 06h, 09h
		db	 00h, 00h, 09h, 06h, 7Bh, 7Bh
		db	 00h, 5Bh, 0Bh, 06h, 06h, 00h
		db	 00h, 00h, 00h, 09h, 06h, 0Bh
		db	 0Bh, 0Bh, 06h, 09h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 19h, 06h
		db	 2Bh, 06h, 09h, 00h
		db	7 dup (0)
		db	 49h, 0Bh, 29h
		db	10 dup (0)
		db	 69h, 00h, 00h, 00h
		db	51 dup (0)
		db	 48h, 10h,0FDh, 0Fh, 0Ah, 77h
		db	 05h
		db	24 dup (0)
		db	 6Eh, 0Eh, 0Eh, 6Eh, 06h, 00h
		db	 06h, 0Eh, 6Eh, 6Eh, 0Eh, 00h
		db	 0Bh, 2Bh, 0Bh, 0Bh, 06h, 00h
		db	 06h, 0Bh, 0Bh, 1Bh, 3Bh, 00h
		db	 06h, 06h, 5Fh, 06h, 06h, 00h
		db	 06h, 06h, 0Fh, 06h, 06h, 00h
		db	 0Ch, 0Ch, 0Ch, 4Ch, 06h, 00h
		db	 06h, 0Ch, 0Ch, 3Ch, 0Ch, 00h
		db	 0Ah, 2Ah, 0Ah, 1Ah, 06h, 00h
		db	 06h, 0Ah, 0Ah, 3Ah, 4Ah, 00h
		db	 0Dh, 5Dh, 0Dh, 7Dh, 06h, 00h
		db	 06h, 0Dh, 7Dh, 2Dh, 0Dh, 00h
		db	 07h, 0Fh, 4Fh, 07h, 06h, 00h
		db	 06h, 07h, 0Fh, 4Fh, 07h, 00h
		db	 0Eh, 2Eh, 0Eh, 6Eh, 06h, 00h
		db	 06h, 0Eh, 0Eh, 4Eh, 6Eh, 00h
		db	60 dup (0)
		db	 50h, 1Ah,0FCh, 0Bh,0F8h, 85h
		db	 05h
		db	12 dup (0)
		db	 6Eh, 6Bh, 00h, 00h
		db	8 dup (0)
		db	 0Eh, 4Bh, 69h, 4Ch, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Eh, 0Bh, 09h, 0Ch, 2Dh, 3Fh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Eh, 0Bh, 09h, 0Ch, 0Dh, 0Fh
		db	 3Eh, 5Bh, 00h, 00h, 00h, 00h
		db	 0Eh, 0Bh, 79h, 7Ch, 7Dh, 7Fh
		db	 0Eh, 5Bh, 69h, 3Ch, 00h, 00h
		db	 3Eh, 0Bh, 09h, 0Ch, 0Dh, 0Fh
		db	 0Eh, 0Bh, 09h, 0Ch, 0Dh, 00h
		db	 07h, 3Bh, 79h, 0Ch, 0Dh, 0Fh
		db	 0Eh, 0Bh, 09h, 0Ch, 0Dh, 00h
		db	 00h, 06h, 07h, 0Ch, 0Dh, 2Fh
		db	 0Eh, 0Bh, 39h, 0Ch, 2Dh, 00h
		db	 00h, 00h, 00h, 06h, 07h, 0Fh
		db	 0Eh, 0Bh, 09h, 0Ch, 0Dh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 07h, 4Bh, 39h, 1Ch, 1Dh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 06h, 07h
		db	 2Ch, 6Dh
		db	10 dup (0)
		db	6, 7
		db	25 dup (0)
		db	 48h, 0Ch,0FDh, 0Ch,0CAh, 7Bh
		db	 05h
		db	12 dup (0)
		db	 1Ch, 00h, 0Bh, 00h, 0Eh, 00h
		db	 0Fh, 00h, 2Ah, 00h, 0Dh, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 00h, 0Ch, 00h, 3Bh, 00h, 0Eh
		db	 00h, 4Fh, 00h, 0Ah, 00h, 0Dh
		db	 00h, 07h, 00h, 07h, 00h, 07h
		db	 00h, 07h, 00h, 07h, 00h, 07h
		db	 0Dh, 00h, 6Ch, 00h, 0Bh, 00h
		db	 0Eh, 00h, 0Fh, 00h, 0Ah, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 00h, 5Dh, 00h, 0Ch, 00h, 0Bh
		db	 00h, 0Eh, 00h, 0Fh, 00h, 6Ah
		db	 00h, 07h, 00h, 07h, 00h, 07h
		db	 00h, 07h, 00h, 07h, 00h, 07h
		db	 0Ah, 00h, 7Dh, 00h, 0Ch, 00h
		db	 0Bh, 00h, 0Eh, 00h, 1Fh, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 07h, 00h, 07h, 00h, 07h, 00h
		db	 00h, 0Ah, 00h, 2Dh, 00h, 0Ch
		db	 00h, 0Bh, 00h, 0Eh, 00h, 2Fh
		db	 00h, 07h, 00h, 07h, 00h, 07h
		db	 00h, 07h, 00h, 07h, 00h, 07h
		db	24 dup (0)
		db	 50h, 20h,0FEh, 10h,0B8h, 7Eh
		db	 05h
		db	25 dup (0)
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 0Ch, 7Ch, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 0Fh, 0Fh
		db	 1Fh, 0Fh, 2Fh, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 79h, 09h, 09h
		db	 09h, 59h, 09h, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 06h, 0Bh, 0Bh, 3Bh, 0Bh, 0Bh
		db	 2Bh, 0Bh, 0Bh, 00h, 00h, 00h
		db	 06h, 00h, 06h, 00h, 06h, 00h
		db	 06h, 00h, 06h, 00h, 00h, 00h
		db	 0Eh, 1Eh, 0Eh, 1Eh, 0Eh, 0Eh
		db	 4Eh, 0Eh, 0Eh, 00h, 00h, 00h
		db	 07h
		db	8 dup (7)
		db	26 dup (0)
		db	 40h, 12h,0FCh, 10h, 78h, 89h
		db	 80h
data_4093	db	3Ah
		db	 20h, 47h, 06h, 07h
		db	36 dup (0)
		db	 03h,0E3h,0E3h,0C7h,0C3h,0E0h
		db	 7Ah, 01h, 45h, 06h, 08h, 04h
		db	 14h, 14h, 28h, 24h, 10h, 0Bh
		db	0EBh,0EBh,0D7h,0DBh,0E8h, 17h
		db	0E7h,0E7h,0E7h,0E7h,0E8h, 17h
		db	 17h,0E7h,0E7h,0E7h,0E8h, 17h
		db	 67h,0E7h,0E7h,0E7h,0E8h, 17h
		db	 47h, 06h, 66h, 67h, 10h, 17h
		db	 07h, 66h, 66h, 67h, 10h, 17h
		db	0E7h, 46h, 66h, 67h,0E8h,0BAh
		db	 02h, 44h, 06h, 08h, 17h,0E7h
		db	 46h, 67h,0D7h,0E8h, 08h,0E7h
		db	 66h, 67h,0D7h, 10h, 06h,0E7h
		db	 06h, 67h,0D7h, 10h, 06h,0E7h
		db	0E7h,0E6h, 67h,0E8h, 08h,0E7h
		db	0E7h,0E6h, 67h,0E8h, 17h,0E7h
		db	0E7h,0E6h, 67h,0E8h, 17h,0DBh
		db	0EBh,0D6h, 6Bh,0E8h, 08h, 24h
		db	 14h, 29h, 94h, 10h,0FAh, 03h
		db	 04h, 06h, 01h, 07h,0C3h,0E3h
		db	0C6h, 63h,0E0h,0BAh, 27h, 47h
		db	 06h, 07h
		db	37 dup (0)
		db	 01h,0FFh,0FFh, 80h, 00h,0FAh
		db	 08h, 45h, 06h, 08h, 00h, 01h
		db	 00h, 00h, 80h, 00h, 00h, 01h
		db	 77h, 7Eh, 80h, 00h, 00h, 01h
		db	 77h, 7Eh, 80h, 00h, 00h, 01h
		db	 77h, 7Eh, 80h, 00h, 00h, 01h
		db	 77h, 3Ch, 80h, 00h, 00h, 01h
		db	 77h, 3Dh, 00h, 00h, 00h, 01h
		db	 7Fh, 3Dh, 00h, 00h, 00h, 01h
		db	 7Fh, 3Dh, 00h, 00h, 3Ah, 0Ah
		db	 44h, 06h, 08h, 00h, 01h, 7Fh
		db	 3Dh, 00h, 00h, 00h, 01h, 7Fh
		db	 3Dh, 00h, 00h, 00h, 01h, 77h
		db	 3Dh, 00h, 00h, 00h, 01h, 77h
		db	 3Ch, 80h, 00h, 00h, 01h, 77h
		db	 7Eh, 80h, 00h, 00h, 01h, 77h
		db	 7Eh, 80h, 00h, 00h, 01h, 77h
		db	 7Eh, 80h, 00h, 00h, 01h, 00h
		db	 00h, 80h, 00h, 7Ah, 0Bh, 44h
		db	 06h, 01h, 00h, 01h,0FFh,0FFh
		db	 80h, 00h
		db	 3Ah, 34h
loc_41DD:
		inc	di
		push	es
		pop	es
		db	36 dup (0)
		db	 03h,0C3h,0C6h, 63h,0C7h,0C0h
		db	 7Ah, 15h, 45h, 06h, 08h, 04h
		db	 24h, 29h, 9Ch, 38h, 20h, 0Bh
		db	0DBh,0D6h, 63h,0C7h,0D0h, 17h
		db	0E7h,0E6h, 67h,0E7h,0E8h, 17h
		db	0E7h,0E6h, 67h,0E7h,0E8h, 17h
		db	0E7h,0E6h, 67h,0E7h,0E8h, 16h
		db	 66h, 66h, 67h,0E6h, 68h, 16h
		db	 66h, 66h, 67h,0E6h, 68h, 16h
		db	 66h, 66h, 67h,0E6h, 68h,0BAh
		db	 16h, 44h, 06h, 08h, 17h,0D6h
		db	 66h, 67h,0E6h, 68h, 17h,0D6h
		db	 66h, 66h, 66h, 68h, 17h,0D6h
		db	 66h, 66h, 66h, 68h, 16h, 67h
		db	0E7h,0E6h, 67h,0E8h, 16h, 67h
		db	0E7h,0E6h, 67h,0E8h, 16h, 67h
		db	0E7h,0E6h, 67h,0E8h, 16h, 6Bh
		db	0DBh,0C6h, 67h,0D0h, 09h, 94h
		db	 24h, 39h, 98h, 20h,0FAh, 17h
		db	 44h, 06h, 01h, 06h, 63h,0C3h
		db	0C6h, 67h,0C0h,0FFh,0FFh, 00h
		db	 0Eh, 00h, 00h, 04h, 00h
		db	22 dup (0)
		db	0C0h, 00h, 00h,0E0h, 00h, 00h
		db	0E0h, 00h, 00h, 70h, 00h, 00h
		db	 70h, 00h, 00h, 38h, 00h, 00h
		db	 38h, 00h, 00h, 1Ch, 00h, 00h
		db	 1Ch, 00h, 00h
		db	0Ch
		db	10 dup (0)
		db	0FDh, 54h,0BFh,0FEh,0FFh, 7Fh
		db	0FFh,0FFh,0FFh,0FFh, 81h,0FFh
		db	0FCh, 00h, 3Fh,0F8h, 00h, 1Fh
		db	0F8h, 00h, 1Fh,0F0h, 00h, 0Fh
		db	0F0h, 00h, 0Fh,0F0h, 00h, 0Fh
		db	0F8h, 00h, 1Fh,0F8h, 00h, 1Fh
		db	0F4h, 00h, 2Fh,0FCh, 00h, 3Fh
		db	0F6h, 00h, 6Fh,0FBh, 00h,0DFh
		db	0F9h,0C3h, 9Fh,0FCh,0FFh, 3Fh
		db	0FEh, 3Ch, 7Fh,0FFh, 00h,0FFh
		db	0FFh,0C3h,0FFh,0FFh,0FFh,0FFh
		db	0F7h,0FFh,0FFh,0FAh,0AAh,0AFh
		db	0FDh, 54h,0BFh,0FEh,0FFh, 7Fh
		db	0FFh
		db	9 dup (0FFh)
		db	 81h,0FFh,0FCh, 00h, 3Fh,0F8h
		db	 00h, 1Fh,0F0h, 00h, 0Fh,0F0h
		db	 00h, 0Fh,0F8h, 00h, 1Fh,0F8h
		db	 00h, 1Fh,0F4h, 00h, 2Fh,0FAh
		db	 00h, 5Fh,0F9h,0C3h, 9Fh,0FCh
		db	0FFh, 3Fh,0FEh, 3Ch, 7Fh,0FFh
		db	 00h,0FFh,0FFh,0C3h
		db	10 dup (0FFh)
		db	0F7h,0FFh,0FFh,0FAh,0AAh,0AFh
		db	0FDh, 54h,0BFh,0FEh,0FFh, 7Fh
		db	0FFh
		db	12 dup (0FFh)
		db	 81h,0FFh,0FCh, 00h, 3Fh,0F0h
		db	 00h, 0Fh,0F0h, 00h, 0Fh,0F8h
		db	 00h, 1Fh,0F6h, 00h, 6Fh,0F1h
		db	0C3h, 8Fh,0F8h,0FFh, 3Fh,0FEh
		db	 3Ch, 7Fh,0FFh, 00h,0FFh,0FFh
		db	0C3h
		db	16 dup (0FFh)
		db	0F7h,0FFh,0FFh,0FAh,0AAh,0AFh
		db	0FDh, 54h,0BFh,0FEh,0FFh, 7Fh
		db	0FFh
		db	18 dup (0FFh)
		db	 81h,0FFh
loc_43B6:
                           lock	add	[bx],cl
		inc	byte ptr [bx+si]
		jg	loc_43B6		; Jump if >
		retn
			                        ;* No entry point to code
		lahf				; Load ah from flags
		cld				; Clear direction
		db	0FFh, 3Fh,0FEh, 00h, 7Fh,0FFh
		db	 00h,0FFh
		db	21 dup (0FFh)
		db	0F7h,0FFh,0FFh,0FAh,0AAh,0AFh
		db	0FDh, 54h,0BFh,0FEh,0FFh, 7Fh
		db	0FFh
		db	20 dup (0FFh)
		db	0F0h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FCh, 00h, 3Fh,0FEh, 00h, 7Fh
		db	0FEh,0AAh
		db	25 dup (0FFh)
		db	0F7h,0FFh,0FFh,0FAh,0AAh,0AFh
		db	8 dup (0)
		db	 1Fh,0FFh,0FFh,0FFh,0F8h, 00h
		db	 00h, 7Fh,0FFh,0FFh,0FFh,0FEh
		db	 00h, 00h,0FBh,0FFh,0FFh,0FFh
		db	0D7h, 00h, 01h,0D7h,0FFh,0FFh
		db	0FFh,0EBh, 80h, 01h,0ABh,0FFh
		db	0FFh,0FFh,0D5h, 80h, 03h,0D7h
		db	0FFh,0FFh,0FFh,0EAh,0C0h, 03h
		db	0ABh,0FFh,0FFh,0FFh,0D5h,0C0h
		db	 03h, 57h,0FFh,0FFh,0FFh,0EAh
		db	0C0h, 07h, 8Bh,0FFh,0FFh,0FFh
		db	0D1h, 60h, 07h, 55h,0FFh,0FFh
		db	0FFh,0AAh,0E0h, 06h, 8Bh,0FFh
		db	0FFh,0FFh,0D1h, 60h, 07h, 45h
		db	0FFh,0FFh,0FFh,0A2h,0E0h, 06h
		db	 8Ah,0FFh,0FFh,0FFh, 51h, 60h
		db	 0Dh, 05h, 7Ch, 00h, 3Eh,0A0h
		db	0B0h, 0Eh, 8Ah, 80h, 00h, 01h
		db	 51h, 70h, 0Dh, 05h, 00h, 00h
		db	 00h,0A0h,0B0h, 0Eh, 88h, 00h
		db	 00h, 00h, 11h, 70h, 0Dh, 10h
		db	 00h, 00h, 00h, 08h,0B0h, 0Eh
		db	 20h, 00h, 3Ch, 00h, 04h, 70h
		db	 0Dh, 40h, 00h, 7Eh, 00h, 02h
		db	0B0h, 0Eh, 80h, 00h, 3Ch, 00h
		db	 01h, 70h, 0Dh, 15h, 54h, 7Eh
		db	 2Ah,0A8h,0B0h, 0Eh,0AAh,0AAh
		db	0BDh, 55h, 55h, 70h, 0Dh, 15h
		db	0FDh, 7Eh,0BFh,0A8h,0B0h, 0Eh
		db	0AFh,0FEh,0BDh, 7Fh,0F5h, 70h
		db	 0Dh, 1Fh,0FFh, 7Eh,0FFh,0F8h
		db	0B0h, 0Eh, 2Fh,0FEh,0BDh, 7Fh
		db	0F4h, 70h, 0Dh, 5Fh,0FFh, 7Eh
		db	0FFh,0FAh,0B0h, 0Eh,0BFh,0FBh
		db	0BDh,0DFh,0FDh, 70h, 0Dh, 5Fh
		db	0F7h, 7Eh,0EFh,0FAh,0B0h, 1Ah
		db	0BFh,0F6h,0BDh, 6Fh,0FDh, 58h
		db	 1Dh, 7Fh,0EDh, 7Eh,0B7h,0FEh
		db	0B8h, 1Ah,0BFh,0EEh,0D5h, 77h
		db	0FDh, 58h, 1Dh, 7Fh,0E8h,0AAh
		db	 17h,0FEh,0B8h, 1Ah,0FFh,0F0h
		db	 00h, 0Fh,0FFh, 58h, 1Dh, 7Fh
		db	0F0h, 00h, 0Fh,0FEh,0B8h, 1Ah
		db	0FFh,0F0h, 00h, 0Fh,0FFh, 58h
		db	 0Dh, 7Fh,0F0h, 00h, 0Fh,0FEh
		db	0B0h, 0Ch,0FFh,0F8h, 2Ah, 1Fh
		db	0FFh, 30h, 0Ch, 7Fh,0FDh, 54h
		db	0BFh,0FEh, 30h, 0Ch, 7Fh,0FEh
		db	0FFh, 7Fh,0FEh, 30h, 0Ch, 3Fh
		db	0FFh,0FFh,0FFh,0FCh, 70h, 06h
		db	0BFh,0FFh, 81h,0FFh,0FDh, 60h
		db	 07h, 5Fh,0FCh, 00h, 3Fh,0FAh
		db	0E0h, 06h,0AFh,0F8h, 00h, 1Fh
		db	0F5h
		db	60h

locloop_456D:
		pop	es
		pop	ss
		clc				; Clear carry flag
		add	[bx],bl
;*		call	sub_4C55		;*
		db	0E8h,0E0h, 06h		;  Fixup - byte match
		stosb				; Store al to es:[di]
		mov	al,0
		or	ax,6055h
		pop	es
		add	ax,70h
		push	cs
;*		and	al,6
		db	 80h,0E0h, 06h		;  Fixup - byte match
		xor	byte ptr ds:[0D00h][bx+si],41h	; 'A'
		pusha				; Save all regs
		push	cs
;*		add	[bx+si+0],di
		db	 01h, 78h, 00h		;  Fixup - byte match
		db	 1Eh, 80h, 70h, 0Ch, 0Ah,0F8h
		db	 00h, 1Fh, 50h, 30h, 0Eh, 15h
		db	0F4h, 00h, 2Fh,0A8h, 70h, 0Ch
		db	 2Bh,0FCh, 00h, 3Fh,0D4h, 30h
		db	 1Ch, 55h,0F6h, 00h, 6Fh,0AAh
		db	 38h, 1Ah, 2Bh,0FBh, 00h,0DFh
		db	0D4h, 58h, 1Ch, 55h,0F9h,0C3h
		db	 9Fh,0AAh, 38h, 1Ah,0AAh,0FCh
		db	0FFh, 3Fh, 55h, 58h, 1Ch, 55h
		db	0FEh, 3Ch, 7Fh,0AAh, 38h, 1Ah
		db	0AAh,0FFh, 00h,0FFh, 55h, 58h
		db	 1Ch, 55h, 7Fh,0C3h,0FEh,0AAh
		db	 38h, 0Eh,0AAh,0BFh,0FFh,0FDh
		db	 55h, 70h, 0Dh, 55h, 57h,0FFh
		db	0FAh,0AAh,0B0h, 0Eh,0AAh,0AAh
		db	0AAh,0AAh, 95h, 70h, 19h,0FDh
		db	 55h, 55h, 55h, 7Fh, 98h, 18h
		db	 0Bh,0FFh,0FFh,0FFh,0A0h, 18h
		db	 18h, 55h, 55h, 55h, 55h, 55h
		db	 18h, 18h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 18h
		db	'1UUUUU', 0Ch, '0'
		db	0ABh,0FFh,0FFh,0FFh,0AAh, 8Ch
		db	 31h, 5Fh,0FFh,0FFh,0FFh,0F5h
		db	 0Ch, 30h,0AFh,0FFh,0FFh,0FFh
		db	0FAh, 8Ch, 61h, 5Fh,0FFh,0FFh
		db	0FFh,0F5h, 06h, 62h,0AFh,0FFh
		db	0FFh,0FFh,0FAh, 86h, 61h, 5Fh
		db	0FFh,0FFh,0FFh,0F5h, 46h, 7Ah
		db	0AFh,0FFh,0FFh,0FFh,0FAh, 9Eh
		db	 0Fh, 5Fh,0FFh,0FFh,0FFh,0F5h
		db	 70h, 01h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 80h, 00h, 01h,0FFh,0FFh
		db	0FFh, 80h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh
		db	97 dup (0FFh)
		db	0FBh
		db	19 dup (0FFh)
		db	0FBh
		db	19 dup (0FFh)
		db	0F5h
		db	19 dup (0FFh)
		db	0F5h,0FFh,0FFh,0FFh,0FDh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0BFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0EAh,0FFh,0FFh,0FFh
		db	0FDh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0BFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0EAh,0FFh
		db	0FFh,0FFh,0F9h,0FFh,0BFh,0FFh
		db	0FFh,0FFh,0FFh, 1Fh
		db	8 dup (0FFh)
		db	0D1h, 7Fh,0FFh,0FFh,0F9h,0FFh
		db	0BFh,0FFh,0FFh,0FFh,0FFh, 1Fh
		db	8 dup (0FFh)
		db	0D1h, 7Fh,0FFh,0FFh,0F4h, 03h
		db	 5Eh, 01h,0FFh,0FFh,0FEh,0AFh
		db	0FFh, 80h, 7Fh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 20h,0BFh,0FFh,0FFh
		db	0F5h,0FBh, 5Eh,0FDh,0FFh,0FFh
		db	0FEh,0AFh,0FFh,0BFh, 7Fh,0FFh
		db	0FFh,0FFh,0F7h,0EFh,0E0h,0BFh
		db	0FFh,0FFh,0EDh, 0Ah,0AEh, 85h
		db	0FFh,0FFh,0FDh,0B7h,0FFh,0A1h
		db	 7Fh,0FFh,0FFh,0FFh,0F4h, 28h
		db	 50h, 5Fh,0FFh,0FFh,0EDh, 0Ah
		db	0AEh, 85h,0FFh,0FFh,0FDh,0B7h
		db	0FFh,0A1h, 7Fh,0FEh, 03h,0FFh
		db	0F4h, 28h, 50h, 5Fh,0FFh,0FFh
		db	0D5h, 09h, 16h, 85h,0FBh,0FFh
		db	0FAh,0ABh,0FFh,0A1h, 7Fh,0F1h
		db	0FCh, 7Fh,0F4h, 28h, 48h, 2Fh
		db	0FFh,0FFh,0D5h, 09h, 16h, 85h
		db	0FBh,0FFh,0FAh,0ABh,0FFh,0A1h
		db	 7Fh,0CEh, 03h, 9Fh,0F4h, 28h
		db	 48h, 2Fh,0FFh,0FFh,0A5h, 0Ah
		db	 0Ah, 85h,0F5h,0FFh,0F4h,0A5h
		db	0FFh,0A1h, 7Fh, 30h, 00h, 67h
		db	0F4h, 28h, 54h, 17h,0FFh,0FFh
		db	0A5h, 0Ah, 0Ah, 85h,0F5h,0FFh
		db	0F4h,0A5h,0FFh,0A1h, 7Eh,0C0h
		db	 00h, 1Bh,0F4h, 28h, 54h, 17h
		db	0FFh,0FFh, 45h, 09h, 04h, 85h
		db	0EAh,0FFh,0E8h,0A2h,0FFh,0A1h
		db	 7Dh, 00h, 00h, 05h,0F4h, 28h
		db	 5Ah, 0Bh,0FFh,0FFh, 45h, 09h
		db	 04h, 85h,0EAh,0FFh,0E8h,0A2h
		db	0FFh,0A1h, 7Ah, 00h, 00h, 02h
		db	0F4h, 28h, 5Ah, 0Bh,0FFh,0FEh
		db	 85h, 0Ah, 82h, 85h,0D1h, 7Fh
		db	0D0h,0A1h, 7Fh,0A1h, 74h, 00h
		db	 00h, 01h, 74h, 28h, 54h, 17h
		db	0FFh,0FEh, 85h, 0Ah, 82h, 85h
		db	0D1h, 7Fh,0D0h,0A1h, 7Fh,0A1h
		db	 68h, 00h, 00h, 00h,0B4h, 28h
		db	 54h, 17h,0FFh,0FDh, 05h, 0Bh
		db	 42h, 85h,0A0h,0BFh,0A0h,0A0h
		db	0BFh,0A1h, 68h, 00h, 00h, 00h
		db	0B4h, 28h, 48h, 2Fh,0FFh,0FDh
		db	 05h, 0Bh, 42h, 85h,0A0h,0BFh
		db	0A0h,0A0h,0BFh,0A1h, 50h, 00h
		db	 00h, 00h, 54h, 28h, 48h, 2Fh
		db	0FFh,0FAh, 05h, 0Ah, 82h, 85h
		db	 41h, 7Fh, 40h,0A0h, 5Fh,0A1h
		db	 50h, 01h,0FCh, 00h, 54h, 28h
		db	 50h, 5Fh,0FFh,0FAh, 05h, 0Ah
		db	 82h, 85h, 41h, 7Fh, 40h,0A0h
		db	 5Fh,0A1h, 20h, 06h, 03h, 00h
		db	 24h, 28h, 50h, 5Fh,0FFh,0F4h
		db	 05h, 09h, 04h, 86h, 82h,0FEh
		db	 80h,0A0h, 2Fh,0A1h, 20h, 08h
		db	0D8h, 80h, 24h, 28h, 60h,0BFh
		db	0FFh,0F4h, 05h, 09h, 04h, 86h
		db	 82h,0FEh, 80h,0A0h, 2Fh,0A1h
		db	 20h, 16h,0DBh, 40h, 24h, 28h
		db	 60h,0BFh,0FFh,0E8h, 05h, 0Ah
		db	 0Ah, 85h, 05h,0FDh, 00h,0A0h
		db	 17h,0A1h, 40h, 20h, 00h, 20h
		db	 14h, 28h, 01h, 7Fh,0FFh,0E8h
		db	 05h, 0Ah, 0Ah, 85h, 05h,0FDh
		db	 00h,0A0h, 17h,0A1h, 40h, 56h
		db	0DBh, 50h, 14h, 28h, 01h, 7Fh
		db	0FFh,0D0h, 05h, 0Eh, 16h, 82h
		db	 0Bh,0FAh, 00h,0A0h, 0Bh,0A1h
		db	 40h, 56h,0DBh, 50h, 14h, 28h
		db	 02h,0FFh,0FFh,0D0h, 05h, 00h
		db	 16h, 82h, 0Bh,0FAh, 00h,0A0h
		db	 0Bh,0A1h, 40h, 40h, 00h, 10h
		db	 14h, 28h, 02h,0FFh,0FFh,0A0h
		db	 05h, 00h, 2Eh, 80h, 17h,0F4h
		db	 00h,0A0h, 05h,0A1h, 40h,0B6h
		db	0DBh, 68h, 14h, 28h, 05h,0FFh
		db	0FFh,0A0h, 05h, 00h, 2Eh, 80h
		db	 17h,0F4h, 00h,0A0h, 05h,0A1h
		db	 40h,0B6h,0DBh, 68h, 14h, 28h
		db	 05h,0FFh,0FFh, 40h, 05h, 00h
		db	 5Eh, 80h, 2Fh,0E8h, 00h,0A0h
		db	 02h,0A1h, 40h, 80h, 00h, 08h
		db	 14h, 28h, 0Bh,0FFh,0FFh, 41h
		db	 05h, 00h, 5Eh, 80h, 2Fh,0E8h
		db	 20h,0A0h, 82h,0A1h, 40h,0B6h
		db	0DBh, 68h, 14h, 28h, 0Bh,0FFh
		db	0FEh, 82h, 85h, 00h,0BEh, 80h
		db	 5Fh,0D0h, 50h,0A1h, 41h, 21h
		db	 40h,0B6h,0DBh, 68h, 14h, 28h
		db	 17h,0FFh,0FEh, 82h, 85h, 00h
		db	0BEh, 80h, 5Fh,0D0h, 50h,0A1h
		db	 41h, 21h, 40h, 40h, 00h, 10h
		db	 14h, 28h, 17h,0FFh,0FDh, 04h
		db	 85h, 00h, 5Eh, 80h, 2Fh,0A0h
		db	 90h,0A1h, 20h,0A1h, 40h, 56h
		db	0DBh, 50h, 14h, 28h, 2Fh,0FFh
		db	0FDh, 04h, 85h, 00h, 5Eh, 80h
		db	 2Fh,0A0h, 90h,0A1h, 20h,0A1h
		db	 40h, 56h,0DBh, 50h, 14h, 28h
		db	 2Fh,0FFh,0FAh, 0Ah, 85h, 00h
		db	 2Eh, 80h, 17h, 41h, 50h,0A1h
		db	 50h, 41h, 40h, 20h, 00h, 20h
		db	 14h, 28h, 5Fh,0FFh,0FAh, 0Ah
		db	 85h, 00h, 2Eh, 80h, 17h, 41h
		db	 50h,0A1h, 50h, 01h, 20h, 16h
		db	0DBh, 40h, 24h, 28h, 5Fh,0FFh
		db	0F4h, 16h, 85h, 00h, 16h, 82h
		db	 0Ah, 82h,0D0h,0A1h, 68h, 01h
		db	 20h, 08h,0D8h, 80h, 24h, 48h
		db	0BFh,0FFh,0F4h, 16h, 85h, 00h
		db	 16h, 82h, 0Ah, 82h,0D0h,0A1h
		db	 68h, 01h, 20h, 06h, 03h, 00h
		db	 24h, 48h,0BFh,0FFh,0E8h, 2Eh
		db	 85h, 04h, 0Ah, 85h, 05h, 05h
		db	0D0h,0A1h, 74h, 01h, 50h, 01h
		db	0FCh, 00h, 54h,0A9h, 7Fh,0FFh
		db	0E8h, 2Eh, 85h, 0Ah, 0Ah, 85h
		db	 05h, 05h,0D0h,0A1h, 74h, 01h
		db	 50h, 00h, 00h, 00h, 54h,0A9h
		db	 7Fh,0FFh,0F4h, 16h, 85h, 15h
		db	 04h, 8Ah, 82h, 82h,0D0h,0A1h
		db	 7Ah, 02h,0E8h, 00h, 00h, 00h
		db	0B5h, 6Ah,0FFh,0FFh,0F4h, 16h
		db	 85h, 15h, 04h, 8Ah, 82h, 82h
		db	0D0h,0A1h, 7Ah, 02h,0E8h, 00h
		db	 00h, 00h,0B5h, 6Ah,0FFh,0FFh
		db	0FAh, 0Ah, 85h, 2Eh, 82h, 97h
		db	 41h, 41h, 50h,0A1h, 7Dh, 05h
		db	0F4h, 00h, 00h, 01h, 76h,0EDh
		db	0FFh,0FFh,0FAh, 0Ah, 85h, 2Eh
		db	 82h, 97h, 41h, 41h, 50h,0A1h
		db	 7Dh, 05h,0FAh, 00h, 00h, 02h
		db	0F6h,0EDh,0FFh,0FFh,0FDh, 04h
		db	 85h, 5Fh, 44h,0AFh,0A2h,0A0h
		db	 90h,0A1h, 7Eh, 8Bh,0FDh, 00h
		db	 00h, 05h,0F5h,0EBh,0FFh,0FFh
		db	0FDh, 04h, 85h, 5Fh, 44h,0AFh
		db	0A2h,0A0h, 90h,0A1h, 7Eh, 8Bh
		db	0FEh,0C0h, 00h, 1Bh,0F5h,0EBh
		db	0FFh,0FFh,0FEh, 82h,0FDh,0BFh
		db	0AAh,0DFh,0D5h,0D0h, 5Fh,0BFh
		db	 7Fh, 57h,0FFh, 30h, 00h, 67h
		db	0F3h,0E7h,0FFh,0FFh,0FEh, 82h
		db	 01h,0BFh,0AAh,0DFh,0D5h,0D0h
		db	 40h, 00h, 7Fh, 57h,0FFh,0CEh
		db	 03h, 9Fh,0F3h,0E7h,0FFh,0FFh
		db	0FFh, 45h,0FDh, 7Fh,0D6h,0BFh
		db	0EBh,0E8h,0BFh,0FFh,0FFh,0AFh
		db	0FFh,0F1h,0FCh, 7Fh,0F7h,0EFh
		db	0FFh,0FFh,0FFh, 45h,0FDh, 7Fh
		db	0D6h,0BFh,0EBh,0E8h,0BFh,0FFh
		db	0FFh,0AFh,0FFh,0FEh, 03h,0FFh
		db	0F7h,0EFh,0FFh,0FFh,0FFh,0ABh
		db	0FCh,0FFh,0EEh, 7Fh,0F7h,0F5h
		db	 7Fh,0FFh,0FFh,0DFh
		db	9 dup (0FFh)
		db	0ABh,0FCh,0FFh,0EEh, 7Fh,0F7h
		db	0F5h, 7Fh,0FFh,0FFh,0DFh
		db	9 dup (0FFh)
		db	0D7h,0FDh,0FFh,0FEh,0FFh,0FFh
		db	0FAh
		db	13 dup (0FFh)
		db	0D7h,0FDh,0FFh,0FEh,0FFh,0FFh
		db	0FAh
		db	13 dup (0FFh)
		db	0EFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FDh
		db	13 dup (0FFh)
		db	0EFh
		db	52 dup (0FFh)
		db	0BFh,0FFh,0FFh
		db	87 dup (0FFh)
		db	0F8h, 1Fh,0FFh,0FFh,0C0h
		db	10 dup (0FFh)
		db	 7Fh,0FFh, 9Fh,0FFh, 87h,0EFh
		db	0FFh,0FEh, 3Fh, 1Fh
		db	10 dup (0FFh)
		db	0FEh, 67h,0FCh, 78h, 37h,0FFh
		db	0F9h,0C0h,0E7h,0FFh
		db	9 dup (0FFh)
		db	0F9h, 99h,0F3h, 86h,0F7h,0FFh
		db	0F6h, 05h, 1Bh,0FFh
		db	9 dup (0FFh)
		db	0E6h, 06h, 4Ch, 0Bh, 77h, 80h
		db	 08h, 00h,0E5h,0FFh
		db	9 dup (0FFh)
		db	0D8h, 13h,0B0h, 57h,0B0h, 7Fh
		db	0FFh,0C1h, 7Ah,0FFh,0FFh
		db	8 dup (0FFh)
		db	0DCh, 05h, 42h,0BFh,0B7h, 80h
		db	 00h, 3Eh,0BAh,0FFh
		db	9 dup (0FFh)
		db	0B7h, 2Ah,0B9h,0FCh,0F8h, 00h
		db	 00h, 01h,0FDh, 7Fh,0FFh
		db	8 dup (0FFh)
		db	0AAh,0D5h, 7Eh, 73h, 0Fh, 00h
		db	 00h, 5Eh, 3Dh, 7Fh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0F8h, 7Fh
		db	0FFh, 55h, 7Bh,0FFh, 8Ch, 00h
		db	0E0h, 00h, 2Bh,0DDh, 7Fh,0FFh
		db	0FFh,0FFh,0FFh,0FEh,0FFh,0E7h
		db	 87h,0FFh, 6Ah,0AFh,0FFh,0F0h
		db	 00h,0C0h, 00h, 55h,0E5h, 7Fh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 98h, 7Bh,0FEh,0D5h, 57h,0FFh
		db	0C0h, 03h, 80h, 00h,0AAh,0FBh
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FEh, 60h, 85h,0FEh,0AAh,0AAh
		db	0FFh, 00h, 0Dh, 00h, 01h, 55h
		db	0FCh,0DFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F9h, 82h, 02h,0FDh, 55h
		db	 55h, 7Ch, 00h, 0Eh, 80h, 0Ah
		db	0ABh,0FFh, 2Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0E6h, 08h, 01h, 73h
		db	0AAh,0AAh,0B0h, 00h, 03h,0C4h
		db	 55h, 55h,0FFh,0D7h,0FCh, 0Fh
		db	0FFh,0FFh,0FFh, 98h, 20h, 02h
		db	 8Fh,0F5h, 55h,0C0h, 00h, 00h
		db	 3Eh,0AAh,0AFh,0FFh,0EBh, 03h
		db	0F7h,0FFh,0FFh,0FEh, 60h, 80h
		db	 05h, 7Fh,0FEh,0FBh, 00h, 1Fh
		db	0F0h, 03h,0D5h, 5Fh,0FFh,0E8h
		db	0FCh, 0Bh,0FFh,0FFh,0F9h, 82h
		db	 00h, 2Ah,0EAh,0FFh, 0Fh, 00h
		db	0FFh,0FCh, 00h, 3Eh,0FFh,0F0h
		db	0F7h, 03h, 7Bh,0FFh,0FFh,0E6h
		db	 08h, 00h, 55h,0D5h, 5Ch, 00h
		db	0F3h,0EAh,0ABh, 00h, 03h,0FFh
		db	0C0h, 0Eh, 0Bh,0BBh,0FFh,0FFh
		db	 98h, 20h, 02h,0AAh,0C0h,0B0h
		db	 00h, 0Ch,0D5h, 06h, 80h, 00h
		db	 3Fh, 00h, 03h, 5Fh,0DBh,0FFh
		db	0FFh, 7Fh, 80h, 15h, 57h,0C0h
		db	0C0h, 00h, 08h, 68h, 1Fh, 40h
		db	 00h, 00h, 00h, 0Fh,0BFh,0DBh
		db	0FFh,0FEh,0AAh, 80h,0AAh,0ABh
		db	0C3h, 00h, 00h, 10h, 1Fh,0EFh
		db	0A0h, 00h, 00h, 00h, 3Fh,0CEh
		db	 5Bh,0FFh,0FDh, 55h, 41h, 55h
		db	 5Fh, 8Ch, 00h, 00h, 20h, 00h
		db	 07h,0D0h, 00h, 00h, 00h,0F8h
		db	 39h,0D7h,0FFh,0FAh,0AAh,0AAh
		db	0AAh,0BFh,0B0h, 00h, 00h, 20h
		db	 43h,0CBh,0D0h, 00h, 00h, 03h
		db	 01h,0E6h, 6Fh,0FFh,0F5h, 55h
		db	 5Dh, 55h,0FFh,0C0h, 00h, 00h
		db	 20h, 83h,0C5h,0E8h, 00h, 00h
		db	 0Ch, 3Fh, 68h,0EFh,0FFh,0F6h
		db	0EAh,0AFh,0BBh,0FFh, 00h, 00h
		db	 00h, 11h, 03h, 4Bh,0EFh, 00h
		db	 00h, 3Fh,0EAh,0EBh, 2Fh,0FFh
		db	0EFh, 1Fh, 57h,0FFh,0FCh, 00h
		db	 00h, 00h, 08h, 03h, 45h,0FFh
		db	0F0h, 00h,0FDh, 55h, 7Ch,0EFh
		db	0FFh,0ECh, 01h,0EFh,0FFh,0F0h
		db	0E0h, 00h, 00h, 06h, 03h,0CBh
		db	0FFh,0DFh, 03h,0AAh,0AAh,0B3h
		db	 2Fh,0FFh,0D0h, 03h,0D7h,0FFh
		db	0C3h, 10h, 00h, 00h, 01h,0E0h
		db	 0Fh,0FFh,0A8h,0FDh, 55h, 55h
		db	 74h, 77h,0FFh,0A0h, 0Fh,0EBh
		db	0FFh, 0Eh, 18h, 00h, 00h, 00h
		db	 1Fh,0FFh,0FDh, 54h, 0Fh,0AAh
		db	0AAh,0B5h, 77h,0FFh, 5Eh, 3Fh
		db	0D7h,0FCh, 11h, 38h, 00h, 00h
		db	 00h
loc_4E11:
		add	di,di
loc_4E13:
		cli				; Disable interrupts
		test	al,0
;*		aad	55h			; 'U' undocumented inst
		db	0D5h, 55h		;  Fixup - byte match
		jnz	loc_4E11		; Jump if not zero
		inc	word ptr [bx+di-7]
		jmp	short loc_4E13
			                        ;* No entry point to code
;*		inc	word ptr cs:data_0000_e[bx+si]
		db	 2Eh,0FFh, 80h, 00h, 00h	;  Fixup - byte match
		add	[bx+55h],bh
		inc	ax
;*		add	dl,bh
		db	 00h,0FAh		;  Fixup - byte match
		stosb				; Store al to es:[di]
		mov	bh,0F7h
		inc	word ptr [bx+si-1Fh]
		xlat				; al=[al+[bx]] table
;*		jmp	far ptr l_00F8_FEAE	;*
		db	0EAh
		dw	0FEAEh, 0F8h		;  Fixup - byte match
		db	 00h, 00h, 02h,0AAh, 00h, 03h
		db	 0Fh, 55h, 5Fh,0F7h,0FEh, 78h
		db	 87h,0AFh,0F5h, 6Ah,0FFh, 57h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 0Ch, 10h,0AAh,0BFh,0F7h,0F9h
		db	 84h, 9Bh,0D7h,0EAh,0AAh,0FEh
		db	0AAh,0F8h, 00h, 00h, 00h, 00h
		db	 00h, 30h, 40h, 55h, 5Fh,0FBh
		db	0E6h, 14h,0EBh,0AFh,0D5h, 6Eh
		db	0FDh, 55h, 57h, 80h, 00h, 00h
		db	 00h, 00h,0C1h, 00h, 2Ah,0BFh
		db	0FBh,0D8h, 2Ch,0AFh,0D7h,0EAh
		db	0B1h,0FEh,0AAh,0AAh,0F8h, 00h
		db	 00h, 00h, 03h, 04h, 00h, 3Fh
		db	0FFh,0FBh,0BDh, 5Dh,0BFh,0AFh
		db	0D5h, 5Fh,0FDh, 55h, 55h, 57h
		db	 81h,0C0h, 00h, 0Ch, 10h, 01h
		db	 5Fh,0FFh,0FBh, 7Ah,0FDh,0FCh
		db	0DFh,0EAh,0BFh,0FAh,0AAh,0AAh
		db	0AAh,0FEh, 20h, 00h, 30h, 40h
		db	 02h,0AFh,0FFh,0CBh, 73h,0F9h
		db	0F3h,0AFh,0D5h, 5Fh,0FDh, 55h
		db	 55h, 55h, 5Ch, 30h, 00h,0C1h
		db	 00h, 15h, 5Fh,0FFh, 3Dh, 73h
		db	0E1h,0CFh, 5Fh,0AAh,0BFh,0FAh
		db	0AAh,0AAh,0AAh,0A2h, 70h, 03h
		db	 04h, 00h, 2Ah,0BFh,0FCh,0CDh
		db	 7Bh, 99h, 3Fh,0AFh,0D5h, 5Fh
		db	0FDh, 55h, 55h, 55h, 5Dh,0F0h
		db	 0Fh,0F8h, 01h, 55h, 7Fh,0F3h
		db	 1Dh,0B7h, 06h,0FFh, 5Fh,0AAh
		db	0AFh,0FAh,0AEh,0EAh,0AAh,0DDh
		db	0F0h, 35h, 54h, 02h,0ABh,0FFh
		db	0F4h, 5Dh,0D9h, 73h,0F3h,0AFh
		db	 55h, 55h,0F5h, 50h, 1Fh, 55h
		db	 55h,0F0h, 6Ah,0AAh, 15h, 57h
		db	0FFh, 35h, 7Dh,0E1h, 8Bh,0C3h
		db	 5Fh,0AAh,0ABh,0FAh,0E0h, 01h
		db	0FAh,0D5h,0EAh,0D5h, 55h,0AAh
		db	0AFh,0FCh,0F5h,0E6h,0E6h, 1Bh
		db	 0Eh,0BFh, 55h, 55h,0F5h,0BCh
		db	 03h, 15h, 5Dh,0F5h,0AAh,0AAh
		db	0D5h, 7Fh,0FFh, 37h, 8Eh,0D8h
		db	 2Bh, 37h, 5Fh,0AAh,0ABh,0EFh
		db	 83h,0CCh, 7Ah,0E3h,0EBh, 5Fh
		db	 55h,0EBh,0FFh,0FCh, 7Ah, 2Eh
		db	0BDh, 5Bh,0D6h,0BFh, 55h, 57h
		db	0FEh,0F8h, 31h,0FDh, 7Fh,0D6h
		db	0B1h,0FAh,0FFh,0FFh,0FDh, 7Ah
		db	0BEh, 7Ah,0FBh, 5Dh, 5Eh,0AAh
		db	0ABh,0E5h, 57h, 87h,0F7h,0FFh
		db	0AFh,0C0h, 1Dh, 7Fh,0FFh,0FDh
		db	 7Ah,0FEh, 73h,0F7h, 7Eh,0BFh
		db	 55h, 57h, 86h,0AAh,0FFh,0F0h
		db	 7Fh, 57h, 00h, 3Eh,0FFh,0FCh
		db	0FDh,0FBh,0FFh, 73h,0C7h,0F1h
		db	 7Eh,0AAh,0AFh, 07h,0D5h, 5Fh
		db	0E1h,0FFh,0AEh, 00h,0FDh, 7Fh
		db	0F3h,0FBh,0FBh,0FEh, 7Bh, 07h
		db	0CEh,0BDh, 55h, 57h, 80h, 7Ah
		db	0AFh, 87h,0FFh, 55h,0E3h,0FEh
		db	0FFh,0CFh,0FBh,0FFh,0F9h,0B6h
		db	0C7h, 3Dh, 7Eh,0AAh,0AFh,0F8h
		db	 07h,0DEh, 1Fh,0FEh,0A8h, 1Fh
		db	 9Dh, 7Fh, 3Fh,0FBh,0FFh,0E7h
		db	0D9h, 34h,0FAh,0FDh, 55h, 57h
		db	 57h, 80h, 78h, 79h,0DDh, 58h
		db	 0Eh, 1Eh,0FCh,0FFh,0FBh,0FFh
		db	 9Fh,0E7h,0DBh,0FDh, 7Fh,0AAh
		db	0AFh, 02h,0F8h, 01h,0E7h,0EAh
		db	0AFh, 88h, 7Dh, 73h,0CFh,0FBh
		db	0FEh, 7Fh,0FFh,0DFh,0FAh,0F0h
		db	 7Dh, 5Fh, 51h,0D7h, 87h, 9Fh
		db	0D5h, 58h, 49h,0BAh,0F7h, 1Fh
		db	0FFh,0F9h,0FFh,0FFh,0EFh,0FDh
		db	0CFh, 87h,0AEh,0AAh, 82h,0FEh
		db	 7Fh,0AAh,0E1h, 4Eh,0BDh,0F4h
		db	 5Fh,0FFh,0E7h,0FFh,0FFh,0F7h
		db	0FBh,0BFh,0F8h, 7Bh, 57h,0D0h
		db	 5Eh,0FFh,0D5h, 8Ah,0CAh,0FAh
		db	0F5h, 5Fh,0FFh, 9Fh,0FFh,0FFh
		db	0FBh,0F6h, 7Fh,0FFh, 82h,0AFh
		db	0AAh,0FEh,0FFh,0ABh,0D7h,0DBh
		db	0FDh,0F5h, 7Fh,0FEh, 7Fh,0FFh
		db	0FFh,0FCh,0F9h,0FFh,0FFh,0F5h
		db	 57h, 55h,0DEh,0FFh,0D7h,0AFh
		db	0DFh,0CAh,0F5h,0F8h,0F9h,0FFh
		db	0FFh,0FFh,0FFh, 07h,0FFh,0FFh
		db	0F6h,0AFh,0AAh,0FDh,0FFh,0AFh
		db	 3Fh, 9Fh, 3Dh,0EFh,0E3h,0A7h
		db	7 dup (0FFh)
		db	0F5h, 57h, 55h,0DDh,0FDh, 57h
		db	 3Eh, 1Ch,0FAh,0EFh, 8Fh, 9Fh
		db	7 dup (0FFh)
		db	0FBh,0AFh,0ABh,0BDh,0F1h,0AFh
		db	0B9h, 93h,0F5h,0EEh, 3Ch,0BFh
		db	7 dup (0FFh)
		db	0FCh,0F5h, 55h,0FDh,0CDh, 57h
		db	 78h, 6Fh,0FBh,0E8h,0F3h,0BFh
		db	8 dup (0FFh)
		db	 0Fh,0ABh,0BFh, 3Ah,0ABh,0AFh
		db	 3Fh, 35h,0EFh,0CFh,0BFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h,0F5h, 7Ch,0FBh, 55h
		db	 58h,0BCh, 3Bh,0EFh,0FFh, 7Fh
		db	0FFh
		db	8 dup (0FFh)
		db	 0Fh,0B3h,0FBh,0EAh,0E1h,0B0h
		db	0F5h,0DFh,0FFh, 7Fh,0FFh
		db	8 dup (0FFh)
		db	0F0h,0CFh,0FCh, 3Dh, 8Ah,0B3h
		db	 6Bh,0DFh,0FCh
		db	11 dup (0FFh)
		db	 3Fh,0FFh,0C3h,0D5h,0BDh, 77h
		db	0DFh,0F3h
		db	13 dup (0FFh)
		db	0F7h,0AFh,0B5h,0EBh,0DFh,0CFh
		db	0FFh,0FFh, 7Fh,0FFh
		db	9 dup (0FFh)
		db	0F7h, 3Fh, 37h,0D7h,0DFh, 3Fh
		db	13 dup (0FFh)
		db	0F7h, 3Ch, 7Fh,0EBh,0DCh
		db	14 dup (0FFh)
		db	0F7h,0B8h, 7Fh, 57h,0F3h
		db	14 dup (0FFh)
		db	0FBh, 6Ch, 7Ch,0ABh,0CFh
		db	14 dup (0FFh)
		db	0FDh, 97h, 73h,0D7h,0BFh,0FFh
		db	0FFh
		db	12 dup (0FFh)
		db	0FEh, 74h,0CFh,0AEh, 7Fh,0FFh
		db	14 dup (0FFh)
		db	0F7h, 3Fh,0DDh
		db	16 dup (0FFh)
		db	0FBh,0FFh,0BBh,0FFh,0FFh
		db	14 dup (0FFh)
		db	0FDh,0FFh, 77h,0FFh
		db	15 dup (0FFh)
		db	0FEh,0FFh,0CFh
		db	17 dup (0FFh)
		db	 3Fh, 3Fh
		db	17 dup (0FFh)
		db	0C0h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh
		db	'This program was modifyed by  '
		db	0, 0
		db	'S.A.Lihonin NOT to display This '
		db	0, 0
		db	'DUMB text!!! '
		db	9 dup (20h)
		db	 3Eh, 20h, 41h
loc_523E:
		and	[bp+di+52h],al
		inc	cx
		inc	si
		push	sp
		add	[bx+si],al
		push	si
		inc	cx
		push	bp
		push	bx
		and	[bp+di+43h],dl
		push	dx
		inc	cx
		dec	bp
		inc	dx
		dec	sp
		inc	bp
		inc	sp
		and	[bx+di+57h],al
		inc	cx
		pop	cx
		and	[bp+52h],al
		dec	di
		dec	bp
		and	[bx+di+54h],cl
		aas				; Ascii adjust
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		inc	dx
		push	bp
		push	sp
		and	[bx+4Eh],cl
		dec	sp
		pop	cx
		and	[si+4Fh],dl
		and	[bp+si+45h],al
		and	[si+52h],dl
		inc	cx
		push	ax
		push	ax
		inc	bp
		inc	sp
		and	[bx+di+4Eh],cl
		and	[bp+di+50h],dl
		inc	cx
		inc	bx
		inc	bp
		add	[bx+si],al
		inc	dx
		pop	cx
		and	[bp+di+4Fh],dl
loc_528A:
		dec	bp
		inc	bp
		dec	di
		dec	si
		inc	bp
		and	[bx],bh
		aas				; Ascii adjust
		aas				; Ascii adjust
		aas				; Ascii adjust
;*		add	dh,bh
		db	 00h,0FEh		;  Fixup - byte match
		push	sp
		dec	ax
		inc	bp
		and	[si+49h],al
		dec	bp
		inc	bp
		dec	si
		push	bx
		dec	cx
		dec	di
loc_52A2:
		dec	si
		and	[bp+di+4Fh],al
		dec	si
		push	sp
		push	dx
		dec	di
		dec	sp
		dec	sp
		dec	cx
		dec	si
		inc	di
		and	[bp+4Fh],al
		push	dx
		push	sp
		add	[bx+si],al
		inc	ax
		inc	sp
		dec	di
		dec	ax
		inc	ax
		and	[bx+si+41h],cl
		push	bx
		and	[bp+4Fh],cl
		push	di
		and	[bp+si+45h],al
		inc	bp
		dec	si
		and	[si+45h],al
		push	bx
		push	sp
		push	dx
		dec	di
		pop	cx
		inc	bp
		inc	sp
		and	[bx+di+4Eh],al
		inc	sp
		add	[bx+si],al
		push	sp
		dec	cx
		dec	bp
		inc	bp
		and	[bp+di+54h],dl
		inc	cx
		push	dx
		push	sp
		inc	bp
		inc	sp
		and	[bp+4Ch],al
		dec	di
		push	di
		dec	cx
		dec	si
		inc	di
		and	[bp+si+41h],al
		inc	bx
		dec	bx
		push	di
		inc	cx
		push	dx
		inc	sp
		push	bx
		aas				; Ascii adjust
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		inc	ax
		push	si
		inc	cx
		push	bp
		push	bx
		inc	ax
		and	[di+41h],cl
		dec	si
		inc	cx
		inc	di
		inc	bp
		inc	sp
		and	[si+4Fh],dl
		and	[di+53h],al
		inc	bx
		inc	cx
		push	ax
		inc	bp
		and	[bp+52h],al
		dec	di
		dec	bp
		add	[bx+si],al
		inc	sp
		dec	cx
		push	bx
		push	sp
		dec	di
		push	dx
		push	sp
		inc	bp
		inc	sp
		and	[bp+di+50h],dl
		inc	cx
		inc	bx
		inc	bp
		aas				; Ascii adjust
		add	[bx+si],al
		and	[bp+si+55h],al
		push	sp
		and	[si+48h],dl
		inc	bp
		and	[bp+4Fh],dl
		pop	cx
		inc	cx
		inc	di
		inc	bp
		and	[bx+46h],cl
		and	[bx+si+41h],al
		push	dx
		dec	bx
		inc	cx
		dec	si
		dec	di
		dec	cx
		inc	sp
		inc	ax
		and	[bx+di+4Eh],cl
		add	[bx+si],al
		db	'THE GALAXY HAS ONLY NOW STARTED?'
		db	0
		db	0FEh, 00h, 00h, 06h, 06h,0FFh
		db	 08h, 00h, 0Ah, 0Ah,0FFh, 0Ah
		db	 00h, 01h, 01h, 02h, 02h, 03h
		db	 03h, 04h, 04h, 05h, 05h, 00h
		db	 0Fh, 0Fh, 0Eh, 0Eh, 0Dh, 0Dh
		db	 0Ch, 0Ch, 0Bh, 0Bh, 0Ah, 0Ah
		db	 09h, 09h, 08h, 08h, 07h, 07h
		db	 06h, 06h, 00h, 14h, 14h, 14h
		db	 14h, 14h, 14h,0FFh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Fh,0FFh, 14h
		db	 14h, 14h, 14h, 14h, 14h,0FFh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 00h
		db	 0Fh, 0Eh, 0Dh, 0Ch, 0Bh, 09h
		db	 08h, 07h, 06h, 05h, 04h, 03h
		db	 00h, 03h, 03h,0FFh,0FFh, 03h
		db	 00h, 0Fh, 0Fh, 0Dh, 0Dh, 0Bh
		db	 0Bh, 09h, 09h, 00h, 05h, 06h
		db	 07h, 08h, 09h, 0Ah, 0Ah, 0Ah
		db	 0Ah, 0Ah, 00h, 04h, 03h, 02h
		db	 04h, 03h, 02h, 04h, 03h, 02h
		db	 04h, 03h, 02h, 04h, 03h, 02h
		db	 04h, 03h, 02h, 04h, 03h, 02h
		db	 04h, 03h, 02h, 04h, 03h, 00h
		db	 08h, 07h, 06h, 05h, 04h, 03h
		db	 00h
data_53FE	db	'6TNTfT~T'
		db	 96h, 54h,0AEh, 54h,0C6h, 54h
		db	0DEh, 54h,0F6h, 54h, 0Eh
		db	'U&U>UVUnU'
		db	 86h, 55h, 9Eh, 55h,0B6h, 55h
		db	0CEh, 55h,0E6h, 55h,0FEh, 55h
		db	 16h, 56h, 2Eh, 56h, 52h, 56h
		db	 76h, 56h, 9Ah, 56h,0BEh, 56h
		db	0E2h, 56h, 06h
		db	57h
		db	8 dup (0)
		db	 06h, 00h, 04h, 00h, 00h,0A0h
		db	 0Bh, 50h, 15h, 68h, 0Bh, 80h
		db	 01h, 40h, 01h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 04h, 00h
		db	 08h, 00h, 00h, 90h, 01h,0A8h
		db	 10h, 30h, 2Eh,0C8h, 1Bh, 20h
		db	 06h,0C0h, 01h, 20h, 00h, 00h
		db	 00h, 00h, 08h, 00h, 00h, 00h
		db	 00h, 88h, 16h, 94h, 0Ah, 18h
		db	 2Fh,0A0h, 32h, 84h, 0Dh, 60h
		db	 14h,0A0h
		db	 0Ch, 40h
		db	7 dup (0)
		db	 80h, 2Ch, 0Ch, 14h, 0Ch, 09h
		db	0C0h, 02h, 50h, 0Ch, 80h, 14h
		db	 40h, 0Bh,0B0h, 30h, 70h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 08h
		db	 04h, 18h, 00h, 00h, 00h, 01h
		db	 80h, 02h, 48h, 1Ah, 40h, 29h
		db	0C0h, 10h, 00h, 00h, 08h, 00h
		db	 00h, 00h, 00h, 10h
		db	9 dup (0)
		db	 01h, 84h, 20h, 80h, 20h, 00h
		db	19 dup (0)
		db	 80h, 00h, 00h
		db	14 dup (0)
		db	 01h, 80h, 01h, 00h, 00h, 28h
		db	 02h,0D4h, 05h, 5Ah, 02h,0E0h
		db	 00h, 50h, 00h, 40h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 00h
		db	 02h, 00h, 00h, 26h, 00h, 6Ah
		db	 04h, 0Ch, 0Bh,0B2h, 06h,0C8h
		db	 01h,0B0h, 00h, 48h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 00h
		db	 00h, 22h, 05h,0A5h, 02h, 86h
		db	 0Bh,0E8h, 0Ch,0A1h, 03h, 58h
		db	 05h, 28h, 03h, 10h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 20h
		db	 0Bh, 03h, 05h, 03h, 02h, 70h
		db	 00h, 94h, 03h, 20h, 05h, 10h
		db	 02h,0ECh, 0Ch, 1Ch, 00h, 00h
		db	 00h, 00h, 00h, 00h, 02h, 01h
		db	 06h, 00h, 00h, 00h, 00h, 60h
		db	 00h, 92h, 06h, 90h, 0Ah, 70h
		db	 04h, 00h, 00h, 02h, 00h, 00h
		db	 00h, 00h, 04h
		db	10 dup (0)
		db	 61h, 08h, 20h, 08h, 00h
		db	19 dup (0)
		db	 20h, 00h
		db	16 dup (0)
		db	 60h, 00h, 40h, 00h, 0Ah, 00h
		db	0B5h, 01h, 56h, 00h,0B8h, 00h
		db	 14h, 00h, 10h
		db	7 dup (0)
		db	 40h, 00h, 80h, 00h, 09h, 00h
		db	 1Ah, 01h, 03h, 02h,0ECh, 01h
		db	0B2h, 00h, 6Ch, 00h, 12h, 00h
		db	 00h, 00h, 00h, 00h, 80h, 00h
		db	 00h, 00h, 08h, 01h, 69h, 00h
		db	0A1h, 02h,0FAh, 03h, 28h, 00h
		db	0D6h, 01h, 4Ah, 00h,0C4h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 08h, 02h,0C0h, 01h, 40h, 00h
		db	 9Ch, 00h, 25h, 00h,0C8h, 01h
		db	 44h, 00h,0BBh, 03h, 07h
		db	7 dup (0)
		db	 80h, 01h, 80h, 00h, 00h, 00h
		db	 18h, 00h, 24h, 01h,0A4h, 02h
		db	 9Ch, 01h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 01h
		db	10 dup (0)
		db	 18h, 02h, 08h, 02h
		db	20 dup (0)
		db	8, 0
		db	20 dup (0)
		db	 18h, 00h, 00h, 10h, 00h, 00h
		db	 02h, 80h, 00h, 2Dh, 40h, 00h
		db	 55h,0A0h, 00h, 2Eh, 00h, 00h
		db	 05h, 00h, 00h, 04h, 00h
		db	10 dup (0)
		db	 10h, 00h, 00h, 20h, 00h, 00h
		db	 02h, 40h, 00h, 06h,0A0h, 00h
		db	 40h,0C0h, 00h,0BBh, 20h, 00h
		db	 6Ch, 80h, 00h, 1Bh, 00h, 00h
		db	 04h, 80h
		db	7 dup (0)
		db	 20h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 20h, 00h, 5Ah, 50h, 00h
		db	 28h, 60h, 00h,0BEh, 80h, 00h
		db	0CAh, 10h, 00h, 35h, 80h, 00h
		db	 52h, 80h, 00h
		db	31h
		db	11 dup (0)
		db	 02h, 00h, 00h,0B0h, 30h, 00h
		db	 50h, 30h, 00h, 27h, 00h, 00h
		db	 09h, 40h, 00h, 32h, 00h, 00h
		db	 51h, 00h, 00h, 2Eh,0C0h, 00h
		db	0C1h,0C0h, 00h
		db	9 dup (0)
		db	 20h, 10h, 00h, 60h, 00h, 00h
		db	 00h, 00h, 00h, 06h, 00h, 00h
		db	 09h, 20h, 00h, 69h, 00h, 00h
		db	0A7h, 00h, 00h, 40h, 00h, 00h
		db	 00h
		db	20h
		db	7 dup (0)
		db	40h
		db	14 dup (0)
		db	 06h, 10h, 00h, 82h, 00h, 00h
		db	 80h, 00h, 00h
		db	27 dup (0)
		db	2, 0
		db	12 dup (0)
data_572A	db	42h
		db	 57h, 50h, 57h, 14h, 00h, 5Eh
		db	 57h, 6Eh, 57h, 10h, 00h, 7Eh
		db	 57h,0FFh, 57h, 16h, 00h, 80h
		db	 58h,0B1h, 58h, 12h, 00h, 29h
		db	 29h, 03h, 29h, 29h, 29h, 05h
		db	 05h, 09h, 09h, 0Ch, 0Ch, 0Ch
		db	 40h, 18h, 18h, 1Bh, 29h, 29h
		db	 29h, 1Ah, 18h, 16h, 1Ah, 18h
		db	 18h, 18h
		db	40h
		db	8 dup (0FCh)
		db	0F9h,0F9h,0F9h,0F9h, 29h, 29h
		db	 29h, 40h, 14h, 0Fh, 11h, 0Ch
		db	 0Fh, 0Ah, 0Ch, 07h, 05h, 05h
		db	 05h, 05h, 29h, 29h, 29h, 40h
		db	 07h, 07h, 0Eh, 0Eh, 07h, 07h
		db	 0Eh, 0Eh, 05h, 05h, 0Ch, 0Ch
		db	 05h, 05h, 0Ch, 0Ch, 03h, 03h
		db	 0Ah, 0Ah, 03h, 03h, 0Ah, 0Ah
		db	 02h, 02h, 09h, 09h, 02h, 02h
		db	 09h, 09h, 07h, 07h, 0Eh, 0Eh
		db	 07h, 07h, 0Eh, 0Eh, 05h, 05h
		db	 0Ch, 0Ch, 05h, 05h, 0Ch, 0Ch
		db	 03h, 03h, 0Ah, 0Ah, 03h, 03h
		db	 0Ah, 0Ah, 02h, 02h, 09h, 09h
		db	 02h, 02h, 09h, 09h, 07h, 07h
		db	 0Eh, 0Eh, 07h, 07h, 0Eh, 0Eh
		db	 05h, 05h, 0Ch, 0Ch, 05h, 05h
		db	 0Ch, 0Ch, 02h, 02h, 09h, 09h
		db	 02h, 02h, 09h, 09h, 02h, 02h
		db	 09h, 09h, 02h, 02h, 09h, 09h
		db	 07h, 07h, 0Eh, 0Eh, 07h, 07h
		db	 0Eh, 0Eh, 05h, 05h, 0Ch, 0Ch
		db	 05h, 05h, 0Ch, 0Ch, 02h, 02h
		db	 09h, 09h, 02h, 02h, 09h, 09h
		db	 02h, 02h, 09h, 09h, 02h, 02h
		db	 09h, 09h, 40h, 13h, 13h, 15h
		db	 16h, 15h, 15h, 13h, 13h, 15h
		db	 15h, 1Ah, 1Ah, 15h, 15h, 15h
		db	 15h, 13h, 13h, 15h, 16h, 15h
		db	 15h, 13h, 13h, 13h, 13h, 12h
		db	 12h, 13h, 13h, 15h, 15h, 13h
		db	 13h, 15h, 16h, 15h, 15h, 13h
		db	 13h, 15h, 15h, 1Ah, 1Ah, 15h
		db	 15h, 15h, 15h, 16h, 16h, 18h
		db	 1Ah, 18h, 18h, 16h, 16h, 18h
		db	 18h, 1Dh, 1Dh, 18h, 18h, 18h
		db	 18h
		db	'!!))!!))!!))!'
		db	 1Fh, 1Dh, 18h, 1Ah
		db	15 dup (1Ah)
		db	'!!))!!))!!))!'
		db	 1Fh, 1Dh, 18h, 1Ah
		db	7 dup (1Ah)
		db	 0Eh, 0Eh, 0Dh, 0Dh, 0Eh, 0Eh
		db	 10h, 10h, 40h, 05h, 29h, 29h
		db	 00h, 29h, 29h, 05h, 29h, 29h
		db	 00h, 29h, 29h, 05h, 29h, 29h
		db	 00h, 29h, 29h, 05h, 29h, 29h
		db	 00h, 02h, 04h, 05h, 29h, 29h
		db	 00h, 29h, 29h, 05h, 29h, 29h
		db	 00h, 29h, 29h, 05h, 29h, 29h
		db	 00h, 29h, 29h, 05h, 29h, 29h
		db	 00h, 02h, 04h, 40h, 11h, 29h
		db	 11h, 18h, 29h, 29h, 29h, 29h
		db	 29h, 18h, 16h, 1Ah, 18h
		db	11 dup (29h)
		db	 11h, 29h, 11h, 18h, 29h, 29h
		db	 29h, 29h, 18h, 18h, 16h, 1Ah
		db	 18h, 29h, 29h, 29h, 29h, 29h
		db	 11h, 29h, 29h, 0Ch, 0Eh, 10h
		db	40h
data_58E2	db	0
		db	 3Ch, 66h, 66h, 66h, 66h, 3Ch
		db	 00h, 00h, 18h, 38h, 18h, 18h
		db	 3Ch, 3Ch, 00h, 00h, 3Ch, 66h
		db	 06h, 3Ch, 60h, 7Eh, 00h, 00h
		db	 3Ch, 66h, 0Ch, 06h, 66h, 3Ch
		db	 00h, 00h, 0Ch, 1Ch, 2Ch, 4Ch
		db	 7Eh, 0Ch, 00h, 00h, 7Eh, 60h
		db	 7Ch, 06h, 66h, 3Ch, 00h, 00h
		db	 3Ch, 60h, 7Ch, 66h, 66h, 3Ch
		db	 00h, 00h, 7Eh, 06h, 0Ch, 0Ch
		db	 18h, 18h, 00h, 00h, 3Ch, 66h
		db	 3Ch, 66h, 66h, 3Ch, 00h, 00h
		db	 3Ch, 66h, 66h, 3Eh, 06h, 3Ch
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 08h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 18h, 18h, 00h, 00h
		db	 14h, 14h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 3Ch, 66h, 66h, 7Eh
		db	 66h, 66h, 00h, 00h, 7Ch, 66h
		db	 7Ch, 66h, 66h, 7Ch, 00h, 00h
		db	 3Ch, 66h, 60h, 60h, 66h, 3Ch
		db	 00h, 00h, 78h, 6Ch, 66h, 66h
		db	 6Ch, 78h, 00h, 00h, 7Eh, 60h
		db	 78h, 60h, 60h, 7Eh, 00h, 00h
		db	 7Eh, 60h, 78h, 60h, 60h, 60h
		db	 00h, 00h, 3Ch, 66h, 60h, 6Eh
		db	 66h, 3Ch, 00h, 00h, 66h, 66h
		db	 7Eh, 66h, 66h, 66h, 00h, 00h
		db	 3Ch, 18h, 18h, 18h, 18h, 3Ch
		db	 00h, 00h, 06h, 06h, 06h, 66h
		db	 66h, 3Ch, 00h, 00h, 66h, 6Ch
		db	 78h, 78h, 6Ch, 66h, 00h, 00h
		db	 60h, 60h, 60h, 60h, 60h, 7Eh
		db	 00h, 00h, 42h, 66h, 7Eh, 66h
		db	 66h, 66h, 00h, 00h, 66h, 76h
		db	 7Eh, 6Eh, 66h, 66h, 00h, 00h
		db	 3Ch, 66h, 66h, 66h, 66h, 3Ch
		db	 00h, 00h, 7Ch, 66h, 66h, 7Ch
		db	 60h, 60h, 00h, 00h, 3Ch, 66h
		db	 66h, 66h, 6Eh, 3Ch, 02h, 00h
		db	 7Ch, 66h, 66h, 7Ch, 6Ch, 66h
		db	 00h, 00h, 3Ch, 60h, 3Ch, 06h
		db	 66h, 3Ch, 00h, 00h, 7Eh, 18h
		db	 18h, 18h, 18h, 18h, 00h, 00h
		db	 66h, 66h, 66h, 66h, 66h, 3Ch
		db	 00h, 00h, 66h, 66h, 66h, 66h
		db	 3Ch, 18h, 00h, 00h, 66h, 66h
		db	 66h, 7Eh, 7Eh, 24h, 00h, 00h
		db	0C6h, 6Ch, 38h, 38h, 6Ch,0C6h
		db	 00h, 00h, 42h, 66h, 3Ch, 18h
		db	 18h, 18h, 00h, 00h, 7Eh, 0Ch
		db	 18h, 30h, 60h, 7Eh, 00h, 00h
		db	 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
		db	 7Fh, 00h
		db	7 dup (0FFh)
		db	'z|z|z|z|'
		db	 00h, 74h, 00h, 74h, 00h, 74h
		db	 00h, 7Ch, 00h, 00h
		db	'8t8t8t8t8t8t8t8t8t8t8'
		db	 00h, 00h, 15h, 7Fh, 3Fh, 75h
		db	 3Ah, 74h, 00h, 00h, 55h,0FFh
		db	0FFh, 55h,0AAh, 00h, 00h, 00h
		db	 54h,0FEh,0FEh, 54h,0AAh, 00h
		db	 00h, 00h,0FEh,0FEh,0FEh,0FEh
		db	0AAh, 54h, 00h, 00h, 66h, 66h
		db	 66h, 66h, 22h, 00h, 00h, 00h
		db	 7Fh, 7Fh, 7Fh, 7Fh
		db	 2Ah, 55h
		db	 00h, 00h, 15h, 3Fh, 3Fh, 15h
		db	 2Ah, 00h, 00h, 00h, 54h,0FAh
		db	0FCh, 7Ah,0BCh, 3Ah, 00h, 00h
		db	 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
		db	 7Fh, 00h
		db	7 dup (0FFh)
		db	 00h, 7Ch, 42h, 42h, 7Ch, 40h
		db	 40h, 00h, 00h, 66h, 66h, 66h
		db	 66h, 22h, 00h, 00h, 00h, 7Fh
		db	 7Fh, 7Fh, 7Fh, 2Ah, 55h, 00h
		db	 00h, 15h, 3Fh, 3Fh, 15h, 2Ah
		db	 00h, 00h, 00h, 54h,0FAh,0FCh
		db	 7Ah,0BCh, 3Ah, 00h, 00h, 7Fh
		db	 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
		db	 00h
		db	7 dup (0FFh)
		db	 00h, 7Ch, 42h, 42h, 7Ch, 40h
		db	 40h, 00h, 00h, 55h,0FFh,0FFh
		db	 55h,0AAh, 00h, 00h, 00h, 54h
		db	0FEh,0FEh, 54h,0AAh, 00h, 00h
		db	 00h,0FEh,0FEh,0FEh,0FEh,0AAh
		db	 54h, 00h, 00h, 66h, 66h, 66h
		db	 66h, 22h, 00h, 00h, 00h, 7Fh
		db	 7Fh, 7Fh, 7Fh, 2Ah, 55h, 00h
		db	 00h, 15h, 3Fh, 3Fh, 15h, 2Ah
		db	 00h, 00h, 00h, 54h,0FAh,0FCh
		db	 7Ah,0BCh, 3Ah, 00h, 00h, 7Fh
		db	 7Fh, 7Fh, 7Fh, 7Fh, 7Fh, 7Fh
		db	 00h
		db	7 dup (0FFh)
		db	 00h, 7Ch, 42h, 42h, 7Ch, 40h
		db	 40h
		db	9 dup (0)
		db	 3Fh,0FCh, 40h, 06h, 88h, 1Fh
		db	 98h,0FFh, 98h, 1Fh, 9Fh, 1Fh
		db	 58h, 16h, 3Fh,0FCh, 3Fh,0FCh
		db	 40h, 06h, 88h, 1Fh, 98h,0FFh
		db	 98h,0FFh, 98h,0FFh, 58h, 16h
		db	 3Fh,0FCh, 3Fh,0FCh, 40h, 06h
		db	 88h, 1Fh, 98h,0FFh, 98h, 3Fh
		db	 98h,0FFh, 58h, 16h, 3Fh,0FCh
		db	 3Fh,0FCh, 40h, 06h, 88h, 3Fh
		db	 98h,0DFh, 98h,0DFh, 98h,0DFh
		db	 58h, 36h, 3Fh,0FCh, 3Fh,0FCh
		db	 40h, 06h, 88h, 1Fh, 98h,0DFh
		db	 98h, 1Fh, 98h,0DFh, 58h, 16h
		db	 3Fh,0FCh, 3Fh,0FCh, 40h, 06h
		db	 88h,0FFh, 98h,0FFh, 98h,0FFh
		db	 98h,0FFh, 58h, 16h, 3Fh,0FCh
		db	 3Fh,0FCh, 40h, 06h, 88h, 1Fh
		db	 98h,0DFh, 98h, 1Fh, 98h,0FFh
		db	 58h,0D6h, 3Fh,0FCh
data_5BAA	db	0BAh
		db	 5Bh,0BAh, 5Dh,0BAh, 5Fh,0BAh
		db	 61h,0BAh, 63h,0BAh, 65h,0BAh
		db	 67h,0BAh, 69h, 7Fh,0FFh,0FEh
		db	 00h,0C3h,0FFh,0C3h, 00h,0FFh
		db	0FFh,0FFh, 00h,0C3h,0FFh,0C3h
		db	 00h,0C1h, 55h, 43h, 00h,0C2h
		db	0AAh, 83h, 00h, 80h, 00h, 01h
		db	 00h, 7Fh,0FFh,0FFh, 00h, 3Fh
		db	0FFh,0FFh, 80h, 3Fh,0FFh,0FFh
		db	 80h, 15h, 55h, 55h, 00h, 2Ah
		db	0AAh,0AAh, 80h, 19h, 33h, 66h
		db	0CCh, 66h, 33h, 19h, 33h, 66h
		db	0CCh, 66h, 33h, 19h, 33h, 66h
		db	0CCh, 3Fh,0FFh,0FFh, 00h, 61h
		db	0FFh,0E1h, 80h, 7Fh,0FFh,0FFh
		db	 80h, 61h,0FFh,0E1h, 80h, 60h
		db	0AAh,0A1h, 80h, 61h, 55h, 41h
		db	 80h, 40h, 00h, 00h, 80h, 3Fh
		db	0FFh,0FFh, 80h, 1Fh,0FFh,0FFh
		db	0C0h, 1Fh,0FFh,0FFh,0C0h, 0Ah
		db	0AAh,0AAh, 80h, 15h
		db	 55h, 55h, 40h
		db	16 dup (0)
		db	 1Fh,0FFh,0FFh, 80h, 30h,0FFh
		db	0F0h,0C0h, 3Fh,0FFh,0FFh,0C0h
		db	 30h,0FFh,0F0h,0C0h, 30h, 55h
		db	 50h,0C0h, 30h,0AAh,0A0h,0C0h
		db	 20h, 00h, 00h, 40h, 1Fh,0FFh
		db	0FFh,0C0h, 0Fh,0FFh,0FFh,0E0h
		db	 0Fh,0FFh,0FFh,0E0h, 05h, 55h
		db	 55h, 40h, 0Ah,0AAh,0AAh,0A0h
		db	 66h,0CCh, 99h, 33h, 99h,0CCh
		db	 66h,0CCh, 99h, 33h, 99h,0CCh
		db	 66h,0CCh, 99h, 33h, 0Fh,0FFh
		db	0FFh,0C0h, 18h, 7Fh,0F8h, 60h
		db	 1Fh,0FFh,0FFh,0E0h, 18h, 7Fh
		db	0F8h, 60h, 18h, 2Ah,0A8h, 60h
		db	 18h, 55h, 50h, 60h, 10h, 00h
		db	 00h, 20h, 0Fh,0FFh,0FFh,0E0h
		db	 07h,0FFh,0FFh,0F0h, 07h,0FFh
		db	0FFh,0F0h, 02h,0AAh,0AAh,0A0h
		db	 05h
		db	 55h, 55h, 50h
		db	16 dup (0)
		db	 07h,0FFh,0FFh,0E0h, 0Ch, 3Fh
		db	0FCh, 30h, 0Fh,0FFh,0FFh,0F0h
		db	 0Ch, 3Fh,0FCh, 30h, 0Ch, 15h
		db	 54h, 30h, 0Ch, 2Ah,0A8h, 30h
		db	 08h, 00h, 00h, 10h, 07h,0FFh
		db	0FFh,0F0h, 03h,0FFh,0FFh,0F8h
		db	 03h,0FFh,0FFh,0F8h, 01h, 55h
		db	 55h, 50h, 02h,0AAh,0AAh,0A8h
		db	16 dup (0)
		db	 03h,0FFh,0FFh,0F0h, 06h, 1Fh
		db	0FEh, 18h, 07h,0FFh,0FFh,0F8h
		db	 06h, 1Fh,0FEh, 18h, 06h, 0Ah
		db	0AAh, 18h, 06h, 15h, 54h, 18h
		db	 04h, 00h, 00h, 08h, 03h,0FFh
		db	0FFh,0F8h, 01h,0FFh,0FFh,0FCh
		db	 01h,0FFh,0FFh,0FCh, 00h,0AAh
		db	0AAh,0A8h, 01h
		db	 55h, 55h, 54h
		db	16 dup (0)
		db	 01h,0FFh,0FFh,0F8h, 03h, 0Fh
		db	0FFh, 0Ch, 03h,0FFh,0FFh,0FCh
		db	 03h, 0Fh,0FFh, 0Ch, 03h, 05h
		db	 55h, 0Ch, 03h, 0Ah,0AAh, 0Ch
		db	 02h, 00h, 00h, 04h, 01h,0FFh
		db	0FFh,0FCh, 00h,0FFh,0FFh,0FEh
		db	 00h,0FFh,0FFh,0FEh, 00h, 55h
		db	 55h, 54h, 00h,0AAh,0AAh,0AAh
		db	17 dup (0)
		db	0FFh,0FFh,0FCh, 01h, 87h,0FFh
		db	 86h, 01h,0FFh,0FFh,0FEh, 01h
		db	 87h,0FFh, 86h, 01h, 82h,0AAh
		db	 86h, 01h, 85h, 55h, 06h, 01h
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	0FEh, 00h, 7Fh,0FFh,0FFh, 00h
		db	 7Fh,0FFh,0FFh, 00h, 2Ah,0AAh
		db	0AAh, 00h
		db	 55h, 55h, 55h
		db	16 dup (0)
		db	 08h, 00h, 10h, 00h, 37h,0FFh
		db	0ECh, 00h, 77h,0FFh,0EEh, 00h
		db	0C0h, 7Eh, 03h, 00h,0B7h, 2Ah
		db	0EDh, 00h,0B7h, 54h,0EDh, 00h
		db	 80h, 00h, 01h, 00h, 7Fh,0FFh
		db	0FEh, 00h, 3Fh,0FFh,0FFh, 80h
		db	 3Fh,0FFh,0FFh, 80h, 15h, 55h
		db	 55h, 00h, 2Ah,0AAh,0AAh, 80h
		db	 00h, 00h
		db	14 dup (0)
		db	 04h, 00h, 08h, 00h, 1Bh,0FFh
		db	0F6h, 00h, 3Bh,0FFh,0F7h, 00h
		db	 60h, 3Fh, 01h, 80h, 5Bh, 95h
		db	 76h, 80h, 5Bh,0AAh, 76h, 80h
		db	 40h, 00h, 00h, 80h, 3Fh,0FFh
		db	0FFh, 00h, 1Fh,0FFh,0FFh,0C0h
		db	 1Fh,0FFh,0FFh,0C0h, 0Ah,0AAh
		db	0AAh, 80h, 15h
		db	 55h, 55h, 40h
		db	16 dup (0)
		db	 02h, 00h, 04h, 00h, 0Dh,0FFh
		db	0FBh, 00h, 1Dh,0FFh,0FBh, 80h
		db	 30h, 1Fh, 80h,0C0h, 2Dh,0CAh
		db	0BBh, 40h, 2Dh,0D5h, 3Bh, 40h
		db	 20h, 00h, 00h, 40h, 1Fh,0FFh
		db	0FFh, 80h, 0Fh,0FFh,0FFh,0E0h
		db	 0Fh,0FFh,0FFh,0E0h, 05h, 55h
		db	 55h, 40h, 0Ah,0AAh,0AAh,0A0h
		db	16 dup (0)
		db	 01h, 00h, 02h, 00h, 06h,0FFh
		db	0FDh, 80h, 0Eh,0FFh,0FDh,0C0h
		db	 18h, 0Fh,0C0h, 60h, 16h,0E5h
		db	 5Dh,0A0h, 16h,0EAh, 9Dh,0A0h
		db	 10h, 00h, 00h, 20h, 0Fh,0FFh
		db	0FFh,0C0h, 07h,0FFh,0FFh,0F0h
		db	 07h,0FFh,0FFh,0F0h, 02h,0AAh
		db	0AAh,0A0h, 05h
		db	 55h, 55h, 50h
		db	17 dup (0)
		db	 80h, 01h, 00h, 03h, 7Fh,0FEh
		db	0C0h, 07h, 7Fh,0FEh,0E0h, 0Ch
		db	 07h,0E0h, 30h, 0Bh, 72h,0AEh
		db	0D0h, 0Bh, 75h, 4Eh,0D0h, 08h
		db	 00h, 00h, 10h, 07h,0FFh,0FFh
		db	0E0h, 03h,0FFh,0FFh,0F8h, 03h
		db	0FFh,0FFh,0F8h, 01h, 55h, 55h
		db	 50h, 02h,0AAh,0AAh,0A8h
		db	17 dup (0)
		db	 40h, 00h, 80h, 01h,0BFh,0FFh
		db	 60h, 03h,0BFh,0FFh, 70h, 06h
		db	 03h,0F0h, 18h, 05h,0B9h, 57h
		db	 68h, 05h,0BAh,0A7h, 68h, 04h
		db	 00h, 00h, 08h, 03h,0FFh,0FFh
		db	0F0h, 01h,0FFh,0FFh,0FCh, 01h
		db	0FFh,0FFh,0FCh, 00h,0AAh,0AAh
		db	0A8h, 01h
		db	 55h, 55h, 54h
		db	17 dup (0)
		db	 20h, 00h, 40h, 00h,0DFh,0FFh
		db	0B0h, 01h,0DFh,0FFh,0B8h, 03h
		db	 01h,0F8h, 0Ch, 02h,0DCh,0ABh
		db	0B4h, 02h,0DDh, 53h,0B4h, 02h
		db	 00h, 00h, 04h, 01h,0FFh,0FFh
		db	0F8h, 00h,0FFh,0FFh,0FEh, 00h
		db	0FFh,0FFh,0FEh, 00h, 55h, 55h
		db	 54h, 00h,0AAh,0AAh,0AAh
		db	17 dup (0)
		db	 10h, 00h, 20h, 00h, 6Fh,0FFh
		db	0D8h, 00h,0EFh,0FFh,0DCh, 01h
		db	 80h,0FCh, 06h, 01h, 6Eh, 55h
		db	0DAh, 01h, 6Eh,0A9h,0DAh, 01h
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	0FCh, 00h, 7Fh,0FFh,0FFh, 00h
		db	 7Fh,0FFh,0FFh, 00h, 2Ah,0AAh
		db	0AAh, 00h
		db	 55h, 55h, 55h
		db	16 dup (0)
		db	 7Eh,0BFh, 7Eh, 00h,0C3h, 7Fh
		db	 43h, 00h, 7Fh, 78h,0BFh, 00h
		db	 42h,0F7h,0C1h, 00h, 80h, 55h
		db	 42h, 00h,0C0h, 00h, 03h, 00h
		db	 80h, 00h, 01h, 00h, 7Fh,0FFh
		db	0FEh, 00h, 3Fh,0FFh,0FFh, 80h
		db	 3Fh,0FFh,0FFh, 80h, 15h, 55h
		db	 55h, 00h, 2Ah,0AAh,0AAh, 80h
		db	 00h, 00h
		db	14 dup (0)
		db	 3Fh, 5Fh,0BFh, 00h, 61h,0BFh
data_6000	db	0A1h			; Data table (indexed access)
data_6001	dw	3F80h			; Data table (indexed access)
		db	0BCh, 5Fh, 80h, 21h, 7Bh,0E0h
		db	 80h, 40h, 2Ah,0A1h, 00h, 60h
		db	 00h, 01h, 80h, 40h, 00h, 00h
		db	 80h, 3Fh,0FFh,0FFh, 00h, 1Fh
		db	0FFh,0FFh,0C0h, 1Fh,0FFh,0FFh
		db	0C0h, 0Ah,0AAh,0AAh, 80h, 15h
		db	 55h, 55h, 40h
		db	16 dup (0)
		db	 1Fh,0AFh,0DFh, 80h, 30h,0DFh
		db	0D0h,0C0h, 1Fh,0DEh, 2Fh,0C0h
		db	 10h,0BDh,0F0h, 40h, 20h, 15h
		db	 50h, 80h, 30h, 00h, 00h,0C0h
		db	 20h, 00h, 00h, 40h, 1Fh,0FFh
		db	0FFh, 80h, 0Fh,0FFh,0FFh,0E0h
		db	 0Fh,0FFh,0FFh,0E0h, 05h, 55h
		db	 55h, 40h, 0Ah,0AAh,0AAh,0A0h
		db	16 dup (0)
		db	 0Fh,0D7h,0EFh,0C0h, 18h, 6Fh
		db	0E8h, 60h, 0Fh,0EFh, 17h,0E0h
		db	 08h, 5Eh,0F8h, 20h, 10h, 0Ah
		db	0A8h, 40h, 18h, 00h, 00h, 60h
		db	 10h, 00h, 00h, 20h, 0Fh,0FFh
		db	0FFh,0C0h, 07h,0FFh,0FFh,0F0h
		db	 07h,0FFh,0FFh,0F0h, 02h,0AAh
		db	0AAh,0A0h, 05h
		db	 55h, 55h, 50h
		db	16 dup (0)
		db	 07h,0EBh,0F7h,0E0h, 0Ch, 37h
		db	0F4h, 30h, 07h,0F7h, 8Bh,0F0h
		db	 04h, 2Fh, 7Ch, 10h, 08h, 05h
		db	 54h, 20h, 0Ch, 00h, 00h, 30h
		db	 08h, 00h, 00h, 10h, 07h,0FFh
		db	0FFh,0E0h, 03h,0FFh,0FFh,0F8h
		db	 03h,0FFh,0FFh,0F8h, 01h, 55h
		db	 55h, 50h, 02h,0AAh,0AAh,0A8h
		db	16 dup (0)
		db	 03h,0F5h,0FBh,0F0h, 06h, 1Bh
		db	0FAh, 18h, 03h,0FBh,0C5h,0F8h
		db	 02h, 17h,0BEh, 08h, 04h, 02h
		db	0AAh, 10h, 06h, 00h, 00h, 18h
		db	 04h, 00h, 00h, 08h, 03h,0FFh
		db	0FFh,0F0h, 01h,0FFh,0FFh,0FCh
		db	 01h,0FFh,0FFh,0FCh, 00h,0AAh
		db	0AAh,0A8h, 01h
		db	 55h, 55h, 54h
		db	16 dup (0)
		db	 01h,0FAh,0FDh,0F8h, 03h, 0Dh
		db	0FDh, 0Ch, 01h,0FDh,0E2h,0FCh
		db	 01h, 0Bh,0DFh, 04h, 02h, 01h
		db	 55h, 08h, 03h, 00h, 00h, 0Ch
		db	 02h, 00h, 00h, 04h, 01h,0FFh
		db	0FFh,0F8h, 00h,0FFh,0FFh,0FEh
		db	 00h,0FFh,0FFh,0FEh, 00h, 55h
		db	 55h, 54h, 00h,0AAh,0AAh,0AAh
		db	17 dup (0)
		db	0FDh, 7Eh,0FCh, 01h, 86h,0FEh
		db	 86h, 00h,0FEh,0F1h, 7Eh, 00h
		db	 85h,0EFh, 82h, 01h, 00h,0AAh
		db	 84h, 01h, 80h, 00h, 06h, 01h
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	0FCh, 00h, 7Fh,0FFh,0FFh, 00h
		db	 7Fh,0FFh,0FFh, 00h, 2Ah,0AAh
		db	0AAh, 00h
		db	 55h, 55h, 55h
		db	16 dup (0)
		db	 6Ch,0BCh, 7Ah, 00h,0C3h, 77h
		db	 43h, 00h, 6Fh, 78h,0BCh, 00h
		db	 42h,0F7h,0C1h, 00h, 80h, 55h
		db	 42h, 00h,0C0h, 00h, 03h, 00h
		db	 80h, 00h, 01h, 00h, 73h,0EFh
		db	0DEh, 00h, 3Eh, 7Bh,0F7h, 80h
		db	 3Eh, 7Bh,0F7h, 80h, 14h, 51h
		db	 55h, 00h, 2Ah, 2Ah,0A2h
loc_61E9:
		add	byte ptr [bx+si],0
		db	14 dup (0)
		db	 36h, 5Eh, 3Dh, 00h, 61h,0BBh
		db	0A1h, 80h, 37h,0BCh, 5Eh, 00h
		db	 21h, 7Bh,0E0h, 80h, 40h, 2Ah
		db	0A1h, 00h, 60h, 00h, 01h, 80h
		db	 40h, 00h, 00h, 80h, 39h,0F7h
		db	0EFh, 00h, 1Fh, 3Dh,0FBh,0C0h
		db	 1Fh, 3Dh,0FBh,0C0h, 0Ah, 28h
		db	0AAh, 80h, 15h, 15h
		db	 51h, 40h
		db	16 dup (0)
		db	 1Bh, 2Fh, 1Eh, 80h, 30h,0DDh
		db	0D0h,0C0h, 1Bh,0DEh, 2Fh, 00h
		db	 10h,0BDh,0F0h, 40h, 20h, 15h
		db	 50h, 80h, 30h, 00h, 00h,0C0h
		db	 20h, 00h, 00h, 40h, 1Ch,0FBh
		db	0F7h, 80h, 0Fh, 9Eh,0FDh,0E0h
		db	 0Fh, 9Eh,0FDh,0E0h, 05h, 14h
		db	 55h, 40h, 0Ah, 8Ah,0A8h,0A0h
		db	16 dup (0)
		db	 0Dh, 97h, 8Fh, 40h, 18h, 6Eh
		db	0E8h, 60h, 0Dh,0EFh, 17h, 80h
		db	 08h, 5Eh,0F8h, 20h, 10h, 0Ah
		db	0A8h
		db	40h
loc_628E:
		sbb	[bx+si],al
		add	[bx+si+10h],ah
		add	[bx+si],al
		and	ds:data_FB7D_e,cl
		rol	byte ptr [bx],0CFh	; Rotate
		jle	loc_628E		; Jump if < or =
		pop	es
		iret				; Interrupt return
			                        ;* No entry point to code
;*		jle	loc_6292		;*Jump if < or =
		db	 7Eh,0F0h		;  Fixup - byte match
		add	cl,ss:data_A02A[bp+si]
		add	ax,5445h
		push	ax
		db	16 dup (0)
		db	 06h,0CBh,0C7h,0A0h, 0Ch, 37h
		db	 74h, 30h, 06h,0F7h, 8Bh,0C0h
		db	 04h, 2Fh, 7Ch, 10h, 08h, 05h
		db	 54h, 20h, 0Ch, 00h, 00h, 30h
		db	 08h, 00h, 00h, 10h, 07h, 3Eh
		db	0FDh,0E0h, 03h,0E7h,0BFh, 78h
		db	 03h,0E7h,0BFh, 78h, 01h
		db	45h
loc_62E4:
		adc	ax,250h
		mov	data_28AA,al
		db	16 dup (0)
		db	 03h, 65h,0E3h,0D0h, 06h, 1Bh
		db	0BAh, 18h, 03h, 7Bh,0C5h,0E0h
		db	 02h, 17h,0BEh, 08h, 04h, 02h
		db	0AAh, 10h, 06h, 00h, 00h, 18h
		db	 04h, 00h, 00h, 08h, 03h, 9Fh
		db	 7Eh,0F0h, 01h,0F3h,0DFh,0BCh
		db	 01h,0F3h,0DFh,0BCh, 00h,0A2h
		db	 8Ah,0A8h, 01h, 51h, 55h, 14h
		db	 00h
		db	15 dup (0)
		db	 01h,0B2h,0F1h,0E8h, 03h, 0Dh
		db	0DDh, 0Ch, 01h,0BDh,0E2h,0F0h
		db	 01h, 0Bh,0DFh, 04h, 02h, 01h
		db	 55h, 08h, 03h, 00h, 00h, 0Ch
		db	 02h, 00h, 00h, 04h, 01h,0CFh
		db	0BFh, 78h, 00h,0F9h,0EFh,0DEh
		db	 00h,0F9h,0EFh,0DEh, 00h, 51h
		db	 45h, 54h, 00h,0A8h,0AAh, 8Ah
		db	17 dup (0)
		db	0D9h, 78h,0F4h, 01h, 86h,0EEh
		db	 86h, 00h,0DEh,0F1h, 78h, 00h
		db	 85h,0EFh, 82h, 01h, 00h,0AAh
		db	 84h, 01h, 80h, 00h, 06h, 01h
		db	 00h, 00h, 02h, 00h,0E7h,0DFh
		db	0BCh, 00h, 7Ch,0F7h,0EFh, 00h
		db	 7Ch,0F7h,0EFh, 00h, 28h,0A2h
		db	0AAh, 00h
		db	 54h, 55h, 45h
		db	16 dup (0)
		db	 6Ch,0BCh, 6Ah, 00h,0C3h, 17h
		db	 43h, 00h, 6Ch, 48h,0BCh, 00h
		db	 42h,0D6h,0C1h, 00h, 80h, 55h
		db	 42h, 00h,0C0h, 00h, 03h, 00h
		db	 80h, 00h, 01h, 00h, 53h, 6Fh
		db	0DAh, 00h, 3Eh, 5Bh,0F6h, 80h
		db	 3Eh, 5Bh,0F6h, 80h, 14h, 51h
		db	 54h, 00h, 2Ah, 0Ah,0A2h, 00h
		db	 00h
		db	15 dup (0)
		db	 36h, 5Eh, 35h, 00h, 61h, 8Bh
		db	0A1h, 80h, 36h, 24h, 5Eh, 00h
		db	 21h, 6Bh, 60h, 80h, 40h, 2Ah
		db	0A1h, 00h, 60h, 00h, 01h, 80h
		db	 40h, 00h, 00h, 80h, 29h,0B7h
		db	0EDh, 00h, 1Fh, 2Dh,0FBh, 40h
		db	 1Fh, 2Dh,0FBh, 40h, 0Ah, 28h
		db	0AAh, 00h, 15h, 05h, 51h, 00h
		db	16 dup (0)
		db	 1Bh, 2Fh, 1Ah, 80h, 30h,0C5h
		db	0D0h,0C0h, 1Bh, 12h, 2Fh, 00h
		db	 10h,0B5h,0B0h, 40h, 20h, 15h
		db	 50h, 80h, 30h, 00h, 00h,0C0h
		db	 20h, 00h, 00h, 40h, 14h,0DBh
		db	0F6h, 80h, 0Fh, 96h,0FDh,0A0h
		db	 0Fh, 96h,0FDh,0A0h, 05h, 14h
		db	 55h, 00h, 0Ah, 82h,0A8h, 80h
		db	 00h, 00h
		db	14 dup (0)
		db	 0Dh, 97h, 8Dh, 40h, 18h, 62h
		db	0E8h, 60h, 0Dh, 89h, 17h, 80h
		db	 08h, 5Ah,0D8h, 20h, 10h, 0Ah
		db	0A8h, 40h, 18h, 00h, 00h, 60h
		db	 10h, 00h, 00h, 20h, 0Ah, 6Dh
		db	0FBh, 40h, 07h,0CBh, 7Eh,0D0h
		db	 07h,0CBh, 7Eh,0D0h, 02h, 8Ah
		db	 2Ah, 80h, 05h
		db	 41h, 54h, 40h
		db	16 dup (0)
		db	 06h,0CBh,0C6h,0A0h, 0Ch, 31h
		db	 74h, 30h, 06h,0C4h, 8Bh,0C0h
		db	 04h, 2Dh, 6Ch, 10h, 08h, 05h
		db	 54h, 20h, 0Ch, 00h, 00h, 30h
		db	 08h, 00h, 00h, 10h, 05h, 36h
		db	0FDh,0A0h, 03h,0E5h,0BFh, 68h
		db	 03h,0E5h,0BFh, 68h, 01h, 45h
		db	 15h, 40h, 02h,0A0h,0AAh
		db	20h
		db	16 dup (0)
		db	 03h, 65h,0E3h, 50h, 06h, 18h
		db	0BAh, 18h, 03h, 62h, 45h,0E0h
		db	 02h, 16h,0B6h, 08h, 04h, 02h
		db	0AAh, 10h, 06h, 00h, 00h, 18h
		db	 04h, 00h, 00h, 08h, 02h, 9Bh
		db	 7Eh,0D0h, 01h,0F2h,0DFh,0B4h
		db	 01h,0F2h,0DFh,0B4h, 00h,0A2h
		db	 8Ah,0A0h, 01h, 50h, 55h, 10h
		db	 00h
		db	15 dup (0)
		db	 01h,0B2h,0F1h,0A8h, 03h, 0Ch
		db	 5Dh, 0Ch, 01h,0B1h, 22h,0F0h
		db	 01h, 0Bh, 5Bh, 04h, 02h, 01h
		db	 55h, 08h, 03h, 00h, 00h, 0Ch
		db	 02h, 00h, 00h, 04h, 01h, 4Dh
		db	0BFh, 68h, 00h,0F9h, 6Fh,0DAh
		db	 00h,0F9h, 6Fh,0DAh, 00h, 51h
		db	 45h, 50h, 00h,0A8h, 2Ah, 88h
		db	17 dup (0)
		db	0D9h, 78h,0D4h, 01h, 86h, 2Eh
		db	 86h, 00h,0D8h, 91h, 78h, 00h
		db	 85h,0ADh, 82h, 01h, 00h,0AAh
		db	 84h, 01h, 80h, 00h, 06h, 01h
		db	 00h, 00h, 02h, 00h,0A6h,0DFh
		db	0B4h, 00h, 7Ch,0B7h,0EDh, 00h
		db	 7Ch,0B7h,0EDh, 00h, 28h,0A2h
		db	0A8h, 00h, 54h, 15h, 44h, 00h
		db	15 dup (0)
		db	 24h,0B8h, 2Ah, 00h, 83h, 13h
		db	 41h, 00h, 08h, 48h, 2Ch, 00h
		db	 02h,0D6h, 41h, 00h, 80h, 40h
		db	 40h, 00h, 00h, 00h, 01h, 00h
		db	 80h, 00h, 00h, 00h, 50h, 69h
		db	0DAh, 00h, 3Eh, 5Bh, 76h, 80h
		db	 36h, 5Bh, 76h, 80h, 14h, 51h
		db	 40h, 00h, 00h, 00h
		db	22h
		db	17 dup (0)
		db	 12h, 5Ch, 15h, 00h, 41h, 89h
		db	0A0h, 80h, 04h, 24h, 16h, 00h
		db	 01h, 6Bh, 20h, 80h, 40h, 20h
		db	 20h, 00h, 00h, 00h, 00h, 80h
		db	 40h, 00h, 00h, 00h, 28h, 34h
		db	0EDh, 00h, 1Fh, 2Dh,0BBh, 40h
		db	 1Bh, 2Dh,0BBh, 40h, 0Ah, 28h
		db	0A0h, 00h, 00h, 00h, 11h
		db	17 dup (0)
		db	 09h, 2Eh, 0Ah, 80h, 20h,0C4h
		db	0D0h, 40h, 02h, 12h, 0Bh, 00h
		db	 00h,0B5h, 90h, 40h, 20h, 10h
		db	 10h, 00h, 00h, 00h, 00h, 40h
		db	 20h, 00h, 00h, 00h, 14h, 1Ah
		db	 76h, 80h, 0Fh, 96h,0DDh,0A0h
		db	 0Dh, 96h,0DDh,0A0h, 05h, 14h
		db	 50h, 00h, 00h, 00h, 08h, 80h
		db	 00h, 00h
		db	14 dup (0)
		db	 04h, 97h, 05h, 40h, 10h, 62h
		db	 68h, 20h, 01h, 09h, 05h, 80h
		db	 00h, 5Ah,0C8h, 20h, 10h, 08h
		db	 08h, 00h, 00h, 00h, 00h, 20h
		db	 10h, 00h, 00h, 00h, 0Ah, 0Dh
		db	 3Bh, 40h, 07h,0CBh, 6Eh,0D0h
		db	 06h,0CBh, 6Eh,0D0h, 02h, 8Ah
		db	 28h, 00h, 00h, 00h, 04h
		db	40h
		db	16 dup (0)
		db	 02h, 4Bh, 82h,0A0h, 08h, 31h
		db	 34h, 10h, 00h, 84h, 82h,0C0h
		db	 00h, 2Dh, 64h, 10h, 08h, 04h
		db	 04h, 00h, 00h, 00h, 00h, 10h
		db	 08h, 00h, 00h, 00h, 05h, 06h
		db	 9Dh,0A0h, 03h,0E5h,0B7h, 68h
		db	 03h, 65h,0B7h, 68h, 01h, 45h
		db	 14h, 00h, 00h, 00h, 02h
		db	20h
		db	16 dup (0)
		db	 01h, 25h,0C1h, 50h, 04h, 18h
		db	 9Ah, 08h, 00h, 42h, 41h, 60h
		db	 00h, 16h,0B2h, 08h, 04h, 02h
		db	 02h, 00h, 00h, 00h, 00h, 08h
		db	 04h, 00h, 00h, 00h, 02h, 83h
		db	 4Eh,0D0h, 01h,0F2h,0DBh,0B4h
		db	 01h,0B2h,0DBh,0B4h, 00h,0A2h
		db	 8Ah, 00h, 00h, 00h, 01h, 10h
		db	17 dup (0)
		db	 92h,0E0h,0A8h, 02h, 0Ch, 4Dh
		db	 04h, 00h, 21h, 20h,0B0h, 00h
		db	 0Bh, 59h, 04h, 02h, 01h, 01h
		db	 00h, 00h, 00h, 00h, 04h, 02h
		db	 00h, 00h, 00h, 01h, 41h,0A7h
		db	 68h, 00h,0F9h, 6Dh,0DAh, 00h
		db	0D9h, 6Dh,0DAh, 00h, 51h, 45h
		db	 00h, 00h, 00h, 00h, 88h, 00h
		db	 00h
		db	15 dup (0)
		db	 49h, 70h, 54h, 01h, 06h, 26h
		db	 82h, 00h, 10h, 90h, 58h, 00h
		db	 05h,0ACh, 82h, 01h, 00h, 80h
		db	 80h, 00h, 00h, 00h, 02h, 01h
		db	 00h, 00h, 00h, 00h,0A0h,0D3h
		db	0B4h, 00h, 7Ch,0B6h,0EDh, 00h
		db	 6Ch,0B6h,0EDh, 00h, 28h,0A2h
		db	 80h, 00h, 00h, 00h
		db	44h
		db	16 dup (0)
		db	 24h, 08h, 0Ah, 00h, 82h, 11h
		db	 41h, 00h, 08h, 00h, 2Ch, 00h
		db	 00h, 14h, 40h, 00h, 00h, 00h
		db	 40h, 00h, 00h, 00h, 01h, 00h
		db	 00h, 00h, 00h, 00h, 10h, 28h
		db	 52h, 00h, 2Eh, 5Bh, 66h, 80h
		db	 32h, 02h, 60h, 80h, 00h, 01h
		db	22 dup (0)
		db	 12h, 04h, 05h, 00h, 41h, 08h
		db	0A0h, 80h, 04h, 00h, 16h, 00h
		db	 00h, 0Ah, 20h, 00h, 00h, 00h
		db	 20h, 00h, 00h, 00h, 00h, 80h
		db	 00h, 00h, 00h, 00h, 08h, 14h
		db	 29h, 00h, 17h, 2Dh,0B3h, 40h
		db	 19h, 01h, 30h, 40h, 00h, 00h
		db	 80h, 00h, 00h
		db	19 dup (0)
		db	 09h, 02h, 02h, 80h, 20h, 84h
		db	 50h, 40h, 02h, 00h, 0Bh, 00h
		db	 00h, 05h, 10h, 00h, 00h, 00h
		db	 10h, 00h, 00h, 00h, 00h, 40h
		db	 00h, 00h, 00h, 00h, 04h, 0Ah
		db	 14h, 80h, 0Bh, 96h,0D9h,0A0h
		db	 0Ch, 80h, 98h, 20h, 00h, 00h
		db	 40h, 00h
		db	20 dup (0)
		db	 04h, 81h, 01h, 40h, 10h, 42h
		db	 28h, 20h, 01h, 00h, 05h, 80h
		db	 00h, 02h, 88h, 00h, 00h, 00h
		db	 08h, 00h, 00h, 00h, 00h, 20h
		db	 00h, 00h, 00h, 00h, 02h, 05h
		db	 0Ah, 40h, 05h,0CBh, 6Ch,0D0h
		db	 06h, 40h, 4Ch, 10h, 00h, 00h
		db	20h
		db	21 dup (0)
		db	 02h, 40h, 80h,0A0h, 08h, 21h
		db	 14h, 10h, 00h, 80h, 02h,0C0h
		db	 00h, 01h, 44h, 00h, 00h, 00h
		db	 04h, 00h, 00h, 00h, 00h, 10h
		db	 00h, 00h, 00h, 00h, 01h, 02h
		db	 85h, 20h, 02h,0E5h,0B6h, 68h
		db	 03h, 20h, 26h, 08h, 00h, 00h
		db	 10h
		db	21 dup (0)
		db	 01h, 20h, 40h, 50h, 04h, 10h
		db	 8Ah, 08h, 00h, 40h, 01h, 60h
		db	 00h, 00h,0A2h, 00h, 00h, 00h
		db	 02h, 00h, 00h, 00h, 00h, 08h
		db	 00h, 00h, 00h, 00h, 00h, 81h
		db	 42h, 90h, 01h, 72h,0DBh, 34h
		db	 01h, 90h, 13h, 04h, 00h, 00h
		db	 08h, 00h
		db	21 dup (0)
		db	 90h, 20h, 28h, 02h, 08h, 45h
		db	 04h, 00h, 20h, 00h,0B0h, 00h
		db	 00h, 51h, 00h, 00h, 00h, 01h
		db	 00h, 00h, 00h, 00h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 40h,0A1h
		db	 48h, 00h,0B9h, 6Dh, 9Ah, 00h
		db	0C8h, 09h, 82h, 00h, 00h, 04h
		db	 00h
		db	34 dup (0)
		db	 28h, 80h, 00h, 00h, 00h, 80h
		db	 00h, 00h, 00h, 02h, 00h, 00h
		db	 00h, 00h, 00h, 20h, 50h,0A4h
		db	 00h, 5Ch,0B6h,0CDh, 00h, 64h
		db	 04h,0C1h, 00h, 00h, 02h, 00h
		db	21 dup (0)
		db	 24h, 08h, 0Ah, 00h, 82h, 11h
		db	 41h, 00h, 08h, 00h, 2Ch, 00h
		db	 00h, 14h, 40h, 00h, 00h, 00h
		db	 40h, 00h, 00h, 00h, 01h, 00h
		db	 00h, 00h, 00h, 00h, 10h, 28h
		db	 52h, 00h, 2Eh, 5Bh, 66h, 00h
		db	 32h, 02h, 60h, 00h, 00h, 01h
		db	469 dup (0)
data_6BBA	db	0
		db	 00h, 00h, 03h, 00h, 0Ch, 00h
		db	 0Fh, 00h, 30h, 00h, 33h, 00h
		db	 3Ch, 00h, 3Fh, 00h,0C0h, 00h
		db	0C3h, 00h,0CCh, 00h,0CFh, 00h
		db	0F0h, 00h,0F3h, 00h,0FCh, 00h
		db	0FFh, 03h, 00h, 03h, 03h, 03h
		db	 0Ch, 03h, 0Fh, 03h, 30h, 03h
		db	 33h, 03h, 3Ch, 03h, 3Fh, 03h
		db	0C0h, 03h,0C3h, 03h,0CCh, 03h
		db	0CFh, 03h,0F0h, 03h,0F3h, 03h
		db	0FCh, 03h,0FFh, 0Ch, 00h, 0Ch
		db	 03h, 0Ch, 0Ch, 0Ch, 0Fh
		db	0Ch, '0', 0Ch, '3', 0Ch, '<', 0Ch
		db	'?', 0Ch
		db	0C0h, 0Ch,0C3h, 0Ch,0CCh, 0Ch
		db	0CFh, 0Ch,0F0h, 0Ch,0F3h, 0Ch
		db	0FCh, 0Ch,0FFh, 0Fh, 00h, 0Fh
		db	 03h, 0Fh, 0Ch, 0Fh, 0Fh, 0Fh
		db	 30h, 0Fh, 33h, 0Fh, 3Ch, 0Fh
		db	 3Fh, 0Fh,0C0h, 0Fh,0C3h, 0Fh
		db	0CCh, 0Fh,0CFh, 0Fh,0F0h, 0Fh
		db	0F3h, 0Fh,0FCh, 0Fh,0FFh, 30h
		db	 00h, 30h, 03h, 30h, 0Ch, 30h
		db	 0Fh
		db	'00030<0?0'
		db	0C0h, 30h,0C3h, 30h,0CCh, 30h
		db	0CFh, 30h,0F0h, 30h,0F3h, 30h
		db	0FCh, 30h,0FFh, 33h, 00h, 33h
		db	 03h, 33h, 0Ch, 33h, 0Fh
		db	'30333<3?3'
		db	0C0h, 33h,0C3h, 33h,0CCh, 33h
		db	0CFh, 33h,0F0h, 33h,0F3h, 33h
		db	0FCh, 33h,0FFh, 3Ch, 00h, 3Ch
		db	 03h, 3Ch, 0Ch, 3Ch, 0Fh
		db	'<0<3<<<?<'
		db	0C0h, 3Ch,0C3h, 3Ch,0CCh, 3Ch
		db	0CFh, 3Ch,0F0h, 3Ch,0F3h, 3Ch
		db	0FCh, 3Ch,0FFh, 3Fh, 00h, 3Fh
		db	 03h, 3Fh, 0Ch, 3Fh, 0Fh
		db	'?0?3?<???'
		db	0C0h, 3Fh,0C3h, 3Fh,0CCh, 3Fh
		db	0CFh, 3Fh,0F0h, 3Fh,0F3h, 3Fh
		db	0FCh, 3Fh,0FFh,0C0h, 00h,0C0h
		db	 03h,0C0h, 0Ch,0C0h, 0Fh,0C0h
		db	 30h,0C0h, 33h,0C0h, 3Ch,0C0h
		db	 3Fh,0C0h,0C0h,0C0h,0C3h,0C0h
		db	0CCh,0C0h,0CFh,0C0h,0F0h,0C0h
		db	0F3h,0C0h,0FCh,0C0h,0FFh,0C3h
		db	 00h,0C3h, 03h,0C3h, 0Ch,0C3h
		db	 0Fh,0C3h, 30h,0C3h, 33h,0C3h
		db	 3Ch,0C3h, 3Fh,0C3h,0C0h,0C3h
		db	0C3h,0C3h,0CCh,0C3h,0CFh,0C3h
		db	0F0h,0C3h,0F3h,0C3h,0FCh,0C3h
		db	0FFh,0CCh, 00h,0CCh, 03h,0CCh
		db	 0Ch,0CCh, 0Fh,0CCh, 30h,0CCh
		db	 33h,0CCh, 3Ch,0CCh, 3Fh,0CCh
		db	0C0h,0CCh,0C3h,0CCh,0CCh,0CCh
		db	0CFh,0CCh,0F0h,0CCh,0F3h,0CCh
		db	0FCh,0CCh,0FFh,0CFh, 00h,0CFh
		db	 03h,0CFh, 0Ch,0CFh, 0Fh,0CFh
		db	 30h,0CFh, 33h,0CFh, 3Ch,0CFh
		db	 3Fh,0CFh,0C0h,0CFh,0C3h,0CFh
		db	0CCh,0CFh,0CFh,0CFh,0F0h,0CFh
		db	0F3h,0CFh,0FCh,0CFh,0FFh,0F0h
		db	 00h,0F0h, 03h,0F0h, 0Ch,0F0h
		db	 0Fh,0F0h, 30h,0F0h, 33h,0F0h
		db	 3Ch,0F0h, 3Fh,0F0h,0C0h,0F0h
		db	0C3h,0F0h,0CCh,0F0h,0CFh,0F0h
		db	0F0h,0F0h,0F3h,0F0h,0FCh,0F0h
		db	0FFh,0F3h, 00h,0F3h, 03h,0F3h
		db	 0Ch,0F3h, 0Fh,0F3h, 30h,0F3h
		db	 33h,0F3h, 3Ch,0F3h, 3Fh,0F3h
		db	0C0h,0F3h,0C3h,0F3h,0CCh,0F3h
		db	0CFh,0F3h,0F0h,0F3h,0F3h,0F3h
		db	0FCh,0F3h,0FFh,0FCh, 00h,0FCh
		db	 03h,0FCh, 0Ch,0FCh, 0Fh,0FCh
		db	 30h,0FCh, 33h,0FCh, 3Ch,0FCh
		db	 3Fh,0FCh,0C0h,0FCh,0C3h,0FCh
		db	0CCh,0FCh,0CFh,0FCh,0F0h,0FCh
		db	0F3h,0FCh,0FCh,0FCh,0FFh,0FFh
		db	 00h,0FFh, 03h,0FFh, 0Ch,0FFh
		db	 0Fh,0FFh, 30h,0FFh, 33h,0FFh
		db	 3Ch,0FFh, 3Fh,0FFh,0C0h,0FFh
		db	0C3h,0FFh,0CCh,0FFh,0CFh,0FFh
		db	0F0h,0FFh,0F3h,0FFh,0FCh,0FFh
		db	0FFh, 01h,0FFh,0FFh,0FFh, 80h
		db	 00h, 03h, 0Fh,0FFh,0F0h,0C0h
		db	 00h, 03h,0FFh,0FFh,0FFh,0C0h
		db	 00h, 03h, 0Fh,0FFh,0F0h,0C0h
		db	 00h, 03h, 05h, 55h, 50h,0C0h
		db	 00h, 03h, 00h, 00h, 00h,0C0h
		db	 00h, 02h, 00h, 00h, 00h, 40h
		db	 00h, 01h,0FFh,0FFh,0FFh, 80h
		db	 00h, 00h,0FFh,0FFh,0FFh,0E0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0E0h
		db	 00h, 00h, 55h, 55h, 55h, 40h
		db	 00h, 00h,0AAh,0AAh,0AAh,0A0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0C0h
		db	 00h, 01h, 87h,0FFh,0F8h, 60h
		db	 00h, 01h,0FFh,0FFh,0FFh,0E0h
		db	 00h, 01h, 87h,0FFh,0F8h, 60h
		db	 00h, 01h, 82h,0AAh,0A8h, 60h
		db	 00h, 01h, 80h, 00h, 00h, 60h
		db	 00h, 01h, 00h, 00h, 00h, 20h
		db	 00h, 00h,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h, 7Fh,0FFh,0FFh,0F0h
		db	 00h, 00h, 7Fh,0FFh,0FFh,0F0h
		db	 00h, 00h, 2Ah,0AAh,0AAh,0A0h
		db	 00h, 00h, 55h, 55h, 55h, 50h
		db	 00h, 00h, 7Fh,0FFh,0FFh,0E0h
		db	 00h, 00h,0C3h,0FFh,0FCh, 30h
		db	 00h, 00h,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h,0C3h,0FFh,0FCh, 30h
		db	 00h, 00h,0C1h, 55h, 54h, 30h
		db	 00h, 00h,0C0h, 00h, 00h, 30h
		db	 00h, 00h, 80h, 00h, 00h, 10h
		db	 00h, 00h, 7Fh,0FFh,0FFh,0E0h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0F8h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0F8h
		db	 00h, 00h, 15h, 55h, 55h, 50h
		db	 00h, 00h, 2Ah,0AAh,0AAh,0A8h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0F0h
		db	 00h, 00h, 61h,0FFh,0FEh, 18h
		db	 00h, 00h, 7Fh,0FFh,0FFh,0F8h
		db	 00h, 00h, 61h,0FFh,0FEh, 18h
		db	 00h, 00h, 60h,0AAh,0AAh, 18h
		db	 00h, 00h, 60h, 00h, 00h, 18h
		db	 00h, 00h, 40h, 00h, 00h, 08h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0F0h
		db	 00h, 00h, 1Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 1Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 0Ah,0AAh,0AAh,0A8h
		db	 00h, 00h, 15h, 55h, 55h, 54h
		db	 00h, 00h, 1Fh,0FFh,0FFh,0F8h
		db	 00h, 00h, 30h,0FFh,0FFh, 0Ch
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 30h,0FFh,0FFh, 0Ch
		db	 00h, 00h, 30h, 55h, 55h, 0Ch
		db	 00h, 00h, 30h, 00h, 00h, 0Ch
		db	 00h, 00h, 20h, 00h, 00h, 04h
		db	 00h, 00h, 1Fh,0FFh,0FFh,0F8h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FEh
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FEh
		db	 00h, 00h, 05h, 55h, 55h, 54h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 18h, 7Fh,0FFh, 86h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_6F2D	proc	near
		add	[bx+si],al
		pop	ds
		db	0FFh,0FFh,0FEh, 00h, 00h, 18h
		db	 7Fh,0FFh, 86h, 00h, 00h, 18h
		db	 2Ah,0AAh, 86h, 00h, 00h, 18h
		db	 00h, 00h, 06h, 00h, 00h, 10h
		db	 00h, 00h, 02h, 00h, 00h, 0Fh
		db	0FFh,0FFh,0FCh, 00h, 00h, 07h
		db	0FFh,0FFh,0FFh, 00h, 00h, 07h
		db	0FFh,0FFh,0FFh, 00h, 00h, 02h
		db	0AAh,0AAh,0AAh, 00h, 00h, 05h
		db	 55h, 55h, 55h, 00h, 00h, 07h
		db	0FFh,0FFh,0FEh, 00h, 00h, 0Ch
		db	 3Fh,0FFh,0C3h, 00h, 00h, 0Fh
		db	0FFh,0FFh,0FFh, 00h, 00h, 0Ch
		db	 3Fh,0FFh,0C3h, 00h, 00h, 0Ch
		db	 15h, 55h, 43h, 00h, 00h, 0Ch
		db	 00h, 00h, 03h, 00h, 00h, 08h
		db	 00h, 00h, 01h, 00h, 00h, 07h
		db	0FFh,0FFh,0FEh, 00h, 00h, 03h
		db	0FFh,0FFh,0FFh, 80h, 00h, 03h
		db	0FFh,0FFh,0FFh, 80h, 00h, 01h
		db	 55h, 55h, 55h, 00h, 00h, 02h
		db	0AAh,0AAh,0AAh, 80h, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h, 00h, 06h
		db	 1Fh,0FFh,0E1h, 80h, 00h, 07h
		db	0FFh,0FFh,0FFh, 80h, 00h, 06h
		db	 1Fh,0FFh,0E1h, 80h, 00h, 06h
		db	 0Ah,0AAh,0A1h, 80h, 00h, 06h
		db	 00h, 00h, 01h, 80h, 00h, 04h
		db	 00h, 00h, 00h, 80h, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h, 00h, 01h
		db	0FFh,0FFh,0FFh,0C0h, 00h, 01h
		db	0FFh,0FFh,0FFh,0C0h, 00h, 00h
		db	0AAh,0AAh,0AAh, 80h, 00h, 01h
		db	 55h, 55h, 55h, 40h, 07h,0FFh
		db	0FFh,0FFh,0E0h, 00h
		db	 0Ch, 3Fh
data_7002	db	0FFh			; Data table (indexed access)
		db	0FCh, 30h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 0Ch, 3Fh,0FFh
		db	0FCh, 30h, 00h, 0Ch, 15h, 55h
		db	 54h, 30h, 00h, 0Ch, 00h, 00h
		db	 00h, 30h, 00h, 08h, 00h, 00h
		db	 00h, 10h, 00h, 07h,0FFh,0FFh
		db	0FFh,0E0h, 00h, 03h,0FFh,0FFh
		db	0FFh,0F8h, 00h, 03h,0FFh,0FFh
		db	0FFh,0F8h, 00h, 01h, 55h, 55h
		db	 55h, 50h, 00h, 02h,0AAh,0AAh
		db	0AAh,0A8h, 00h, 03h,0FFh,0FFh
		db	0FFh,0F0h, 00h, 06h, 1Fh,0FFh
		db	0FEh, 18h, 00h, 07h,0FFh,0FFh
		db	0FFh,0F8h, 00h, 06h, 1Fh,0FFh
		db	0FEh, 18h, 00h, 06h, 0Ah,0AAh
		db	0AAh, 18h, 00h, 06h, 00h, 00h
		db	 00h, 18h, 00h, 04h
		db	21 dup (0)
		db	0FCh, 00h, 00h,0AAh,0AAh,0AAh
		db	0A8h, 00h, 01h, 55h, 55h, 55h
		db	 54h, 00h, 01h,0FFh,0FFh,0FFh
		db	0F8h, 00h, 03h, 0Fh,0FFh,0FFh
		db	 0Ch, 00h, 03h,0FFh,0FFh,0FFh
		db	0FCh, 00h, 03h, 0Fh,0FFh,0FFh
		db	 0Ch, 00h, 03h, 05h, 55h, 55h
		db	 0Ch, 00h, 03h, 00h, 00h, 00h
		db	 0Ch, 00h, 02h, 00h, 00h, 00h
		db	 04h, 00h, 01h,0FFh,0FFh,0FFh
		db	0F8h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FEh, 00h, 00h,0FFh,0FFh,0FFh
		db	0FEh, 00h, 00h, 55h, 55h, 55h
		db	 54h, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h,0FFh,0FFh,0FFh
		db	0FCh, 00h, 01h, 87h,0FFh,0FFh
		db	 86h, 00h, 01h,0FFh,0FFh,0FFh
		db	0FEh, 00h, 01h, 87h,0FFh,0FFh
		db	 86h, 00h, 01h, 82h,0AAh,0AAh
		db	 86h, 00h, 01h, 80h, 00h, 00h
		db	 06h, 00h, 01h, 00h, 00h, 00h
		db	 02h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FCh, 00h, 00h, 7Fh,0FFh,0FFh
		db	0FFh, 00h, 00h, 7Fh,0FFh,0FFh
		db	0FFh, 00h, 00h, 2Ah,0AAh,0AAh
		db	0AAh, 00h, 00h, 55h, 55h, 55h
		db	 55h, 00h, 00h, 7Fh,0FFh,0FFh
		db	0FEh, 00h, 00h,0C3h,0FFh,0FFh
		db	0C3h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0C3h,0FFh,0FFh
		db	0C3h, 00h, 00h,0C1h, 55h, 55h
		db	 43h, 00h, 00h,0C0h, 00h, 00h
		db	 03h, 00h, 00h, 80h, 00h, 00h
		db	 01h, 00h, 00h, 7Fh,0FFh,0FFh
		db	0FEh, 00h, 00h, 3Fh,0FFh,0FFh
		db	0FFh, 80h, 00h, 3Fh,0FFh,0FFh
		db	0FFh, 80h, 00h, 15h, 55h, 55h
		db	 55h, 00h, 00h, 2Ah,0AAh,0AAh
		db	0AAh, 80h, 00h, 3Fh,0FFh,0FFh
		db	0FFh, 00h, 00h, 61h,0FFh,0FFh
		db	0E1h, 80h, 00h, 7Fh,0FFh,0FFh
		db	0FFh, 80h, 00h, 61h,0FFh,0FFh
		db	0E1h, 80h, 00h, 60h,0AAh,0AAh
		db	0A1h, 80h, 00h, 60h, 00h, 00h
		db	 01h, 80h, 00h, 40h, 00h, 00h
		db	 00h, 80h, 00h, 3Fh,0FFh,0FFh
		db	0FFh, 00h, 00h, 1Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 1Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 0Ah,0AAh,0AAh
		db	0AAh, 80h, 00h, 15h, 55h, 55h
		db	 55h, 40h, 00h, 1Fh,0FFh,0FFh
		db	0FFh, 80h, 00h, 30h,0FFh,0FFh
		db	0F0h,0C0h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 30h,0FFh,0FFh
		db	0F0h,0C0h, 00h, 30h, 55h, 55h
		db	 50h,0C0h, 00h, 30h, 00h, 00h
		db	 00h,0C0h, 00h, 20h, 00h, 00h
		db	 00h, 40h, 00h, 1Fh,0FFh,0FFh
		db	0FFh, 80h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0E0h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0E0h, 00h, 05h, 55h, 55h
		db	 55h, 40h, 00h, 0Ah,0AAh,0AAh
		db	0AAh,0A0h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 18h, 7Fh,0FFh
		db	0F8h, 60h, 00h, 1Fh,0FFh,0FFh
		db	0FFh,0E0h, 00h, 18h, 7Fh,0FFh
		db	0F8h, 60h, 00h, 18h, 2Ah,0AAh
		db	0A8h, 60h, 00h, 18h, 00h, 00h
		db	 00h, 60h, 00h, 10h, 00h, 00h
		db	 00h, 20h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 07h,0FFh,0FFh
		db	0FFh,0F0h, 00h, 07h,0FFh,0FFh
		db	0FFh,0F0h, 00h, 02h,0AAh,0AAh
		db	0AAh,0A0h, 00h, 05h, 55h, 55h
		db	 55h, 50h, 1Fh,0FFh,0FFh,0FFh
		db	0F8h, 00h, 30h,0FFh,0FFh,0FFh
		db	 0Ch, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FCh, 00h, 30h,0FFh,0FFh,0FFh
		db	 0Ch, 00h, 30h, 55h, 55h, 55h
		db	 0Ch, 00h, 30h, 00h, 00h, 00h
		db	 0Ch, 00h, 20h, 00h, 00h, 00h
		db	 04h, 00h, 1Fh,0FFh,0FFh,0FFh
		db	0F8h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FEh, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FEh, 00h, 05h, 55h, 55h, 55h
		db	 54h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FCh, 00h, 18h, 7Fh,0FFh,0FFh
		db	 86h, 00h, 1Fh,0FFh,0FFh,0FFh
		db	0FEh, 00h, 18h, 7Fh,0FFh,0FFh
		db	 86h, 00h, 18h, 2Ah,0AAh,0AAh
		db	 86h, 00h, 18h, 00h, 00h, 00h
		db	 06h, 00h, 10h, 00h, 00h, 00h
		db	 02h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FCh, 00h, 07h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 07h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 02h,0AAh,0AAh,0AAh
		db	0AAh, 00h, 05h, 55h, 55h, 55h
		db	 55h, 00h, 07h,0FFh,0FFh,0FFh
		db	0FEh, 00h, 0Ch, 3Fh,0FFh,0FFh
		db	0C3h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 0Ch, 3Fh,0FFh,0FFh
		db	0C3h, 00h, 0Ch, 15h, 55h, 55h
		db	 43h, 00h, 0Ch, 00h, 00h, 00h
		db	 03h, 00h, 08h, 00h, 00h, 00h
		db	 01h, 00h, 07h,0FFh,0FFh,0FFh
		db	0FEh, 00h, 03h,0FFh,0FFh,0FFh
		db	0FFh, 80h, 03h,0FFh,0FFh,0FFh
		db	0FFh, 80h, 01h, 55h, 55h, 55h
		db	 55h, 00h, 02h,0AAh,0AAh,0AAh
		db	0AAh, 80h, 03h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 06h, 1Fh,0FFh,0FFh
		db	0E1h, 80h, 07h,0FFh,0FFh,0FFh
		db	0FFh, 80h, 06h, 1Fh,0FFh,0FFh
		db	0E1h, 80h, 06h, 0Ah,0AAh,0AAh
		db	0A1h, 80h, 06h, 00h, 00h, 00h
		db	 01h, 80h, 04h, 00h, 00h, 00h
		db	 00h, 80h, 03h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 00h,0AAh,0AAh,0AAh
		db	0AAh, 80h, 01h, 55h, 55h, 55h
		db	 55h, 40h, 01h,0FFh,0FFh,0FFh
		db	0FFh, 80h, 03h, 0Fh,0FFh,0FFh
		db	0F0h,0C0h, 03h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 03h, 0Fh,0FFh,0FFh
		db	0F0h,0C0h, 03h, 05h, 55h, 55h
		db	 50h,0C0h, 03h, 00h, 00h, 00h
		db	 00h,0C0h, 02h, 00h, 00h, 00h
		db	 00h, 40h, 01h,0FFh,0FFh,0FFh
		db	0FFh, 80h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 00h, 55h, 55h, 55h
		db	 55h, 40h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 01h, 87h,0FFh,0FFh
		db	0F8h, 60h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 01h, 87h,0FFh,0FFh
		db	0F8h, 60h, 01h, 82h,0AAh,0AAh
		db	0A8h, 60h, 01h, 80h, 00h, 00h
		db	 00h, 60h, 01h, 00h, 00h, 00h
		db	 00h, 20h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 7Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 7Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 2Ah,0AAh,0AAh
		db	0AAh,0A0h, 00h, 55h, 55h, 55h
		db	 55h, 50h, 00h, 7Fh,0FFh,0FFh
		db	0FFh,0E0h, 00h,0C3h,0FFh,0FFh
		db	0FCh, 30h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h,0C3h,0FFh,0FFh
		db	0FCh, 30h, 00h,0C1h, 55h, 55h
		db	 54h, 30h, 00h,0C0h, 00h, 00h
		db	 00h, 30h, 00h, 80h, 00h, 00h
		db	 00h, 10h, 00h, 7Fh,0FFh,0FFh
		db	0FFh,0E0h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0F8h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0F8h, 00h, 15h, 55h, 55h
		db	 55h, 50h, 00h, 2Ah,0AAh,0AAh
		db	0AAh,0A8h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 61h,0FFh,0FFh
		db	0FEh, 18h, 00h, 7Fh,0FFh,0FFh
		db	0FFh,0F8h, 00h, 61h,0FFh,0FFh
		db	0FEh, 18h, 00h, 60h,0AAh,0AAh
		db	0AAh, 18h, 00h, 60h, 00h, 00h
		db	 00h, 18h, 00h, 40h, 00h, 00h
		db	 00h, 08h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 1Fh,0FFh,0FFh
		db	0FFh,0FCh, 00h, 1Fh,0FFh,0FFh
		db	0FFh,0FCh, 00h, 0Ah,0AAh,0AAh
		db	0AAh,0A8h, 00h, 15h, 55h, 55h
		db	 55h, 54h, 7Fh,0FFh,0FFh,0FFh
		db	0FEh, 00h,0C3h,0FFh,0FFh,0FFh
		db	0C3h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h,0C3h,0FFh,0FFh,0FFh
		db	0C3h, 00h,0C1h, 55h, 55h, 55h
		db	 43h, 00h,0C0h, 00h, 00h, 00h
		db	 03h, 00h, 80h, 00h, 00h, 00h
		db	 01h, 00h, 7Fh,0FFh,0FFh,0FFh
		db	0FEh, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 15h, 55h, 55h, 55h
		db	 55h, 00h, 2Ah,0AAh,0AAh,0AAh
		db	0AAh, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 61h,0FFh,0FFh,0FFh
		db	0E1h, 80h, 7Fh,0FFh,0FFh,0FFh
		db	0FFh, 80h, 61h,0FFh,0FFh,0FFh
		db	0E1h, 80h, 60h,0AAh,0AAh,0AAh
		db	0A1h, 80h, 60h, 00h, 00h, 00h
		db	 01h, 80h, 40h, 00h, 00h, 00h
		db	 00h, 80h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 1Fh,0FFh,0FFh,0FFh
		db	0FFh, 80h, 1Fh,0FFh,0FFh,0FFh
		db	0FFh, 80h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh, 80h, 15h, 55h, 55h, 55h
		db	 55h, 00h, 1Fh,0FFh,0FFh,0FFh
		db	0FFh, 80h, 30h,0FFh,0FFh,0FFh
		db	0F0h,0C0h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 30h,0FFh,0FFh,0FFh
		db	0F0h,0C0h, 30h, 55h, 55h, 55h
		db	 50h,0C0h, 30h, 00h, 00h, 00h
		db	 00h,0C0h, 20h, 00h, 00h, 00h
		db	 00h, 40h, 1Fh,0FFh,0FFh,0FFh
		db	0FFh, 80h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 05h, 55h, 55h, 55h
		db	 55h, 40h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh, 80h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 18h, 7Fh,0FFh,0FFh
		db	0F8h, 60h, 1Fh,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 18h, 7Fh,0FFh,0FFh
		db	0F8h, 60h, 18h, 2Ah,0AAh,0AAh
		db	0A8h, 60h, 18h, 00h, 00h, 00h
		db	 00h, 60h, 10h, 00h, 00h, 00h
		db	 00h, 20h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 07h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 07h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 02h,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 05h, 55h, 55h, 55h
		db	 55h, 40h, 07h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 0Ch, 3Fh,0FFh,0FFh
		db	0FCh, 30h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 0Ch, 3Fh,0FFh,0FFh
		db	0FCh, 30h, 0Ch, 15h, 55h, 55h
		db	 54h, 30h, 0Ch, 00h, 00h, 00h
		db	 00h, 30h, 08h, 00h, 00h, 00h
		db	 00h, 10h, 07h,0FFh,0FFh,0FFh
		db	0FFh,0E0h, 03h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 03h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 01h, 55h, 55h, 55h
		db	 55h, 50h, 02h,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 03h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 06h, 1Fh,0FFh,0FFh
		db	0FEh, 18h, 07h,0FFh,0FFh,0FFh
		db	0FFh,0F8h, 06h, 1Fh,0FFh,0FFh
		db	0FEh, 18h, 06h, 0Ah,0AAh,0AAh
		db	0AAh, 18h, 06h, 00h, 00h, 00h
		db	 00h, 18h, 04h, 00h, 00h, 00h
		db	 00h, 08h, 03h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0F8h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0F8h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 01h, 55h, 55h, 55h
		db	 55h, 50h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0F8h, 03h, 0Fh,0FFh,0FFh
		db	0FFh, 0Ch, 03h,0FFh,0FFh,0FFh
		db	0FFh,0FCh, 03h, 0Fh,0FFh,0FFh
		db	0FFh, 0Ch, 03h, 05h, 55h, 55h
		db	 55h, 0Ch, 03h, 00h, 00h, 00h
		db	 00h, 0Ch, 02h, 00h, 00h, 00h
		db	 00h, 04h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0F8h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FCh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FCh, 00h, 55h, 55h, 55h
		db	 55h, 54h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FCh, 01h, 87h,0FFh,0FFh
		db	0FFh, 86h, 01h,0FFh,0FFh,0FFh
		db	0FFh,0FEh, 01h, 87h,0FFh,0FFh
		db	0FFh, 86h, 01h, 82h,0AAh,0AAh
		db	0AAh, 86h, 01h, 80h, 00h, 00h
		db	 00h, 06h, 01h, 00h, 00h
		db	 00h, 00h, 02h, 00h,0FFh,0FFh
		db	0FFh,0FFh,0FCh, 00h, 7Fh,0FFh
		db	0FFh,0FFh,0FEh, 00h
loc_76A9:
		db	 7Fh,0FFh,0FFh,0FFh,0FEh, 00h
		db	 2Ah,0AAh,0AAh,0AAh,0AAh, 00h
		db	 55h, 55h, 55h, 55h
loc_76B9:
		push	sp
		jo	$+2			; delay for I/O
		cbw				; Convrt byte to word
		add	ds:d_5445_F800_e[bx+si],bh
;*		add	[bx+si+0],dh
		db	 00h, 70h, 00h		;  Fixup - byte match
		db	 38h, 00h, 4Ch, 00h, 5Ch, 00h
		db	 7Ch
loc_76CB:
		add	[bx+si],bh
		add	[si],bl
		add	ds:d_5445_2E00_e,ah
		add	ds:d_5445_1C00_e,bh
		add	ds:d_5445_1300_e,cl
loc_76DB:
		add	[bx],dl
loc_76DD:
		add	[bx],bl
		add	ds:d_5445_0700_e,cl
loc_76E3:
		add	[bx+di],cl
		or	byte ptr [bp+di],80h
		db	0Fh
loc_76E9:
		add	byte ptr [bx],0
		add	ax,ds:d_5445_C004_e[bx+si]
		add	ax,7C0h
		rol	byte ptr [bp+di],80h	; Rotate
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		add	ah,[bx+si+2]
;*		loopnz	locloop_7700		;*Loop if zf=0, cx>0

		db	0E0h, 03h		;  Fixup - byte match
loc_76FD:
;*		loopnz	locloop_7700		;*Loop if zf=0, cx>0

		db	0E0h, 01h		;  Fixup - byte match
loc_76FF:
		rol	byte ptr [bx+si],0E0h	; Rotate
		add	[bx+si],si
		add	[bx+si+1],si
;*                         lock	add	al,ah
		db	0F0h, 00h,0E0h		;  Fixup - byte match
		dec	dx
;*		ja	loc_7777		;*Jump if above
		db	 77h, 6Ah		;  Fixup - byte match
;*		ja	loc_7699		;*Jump if above
		db	 77h, 8Ah		;  Fixup - byte match
loc_770F:
;*		ja	loc_76BB		;*Jump if above
		db	 77h,0AAh		;  Fixup - byte match
		ja	loc_76DD		; Jump if above
		ja	loc_76FF		; Jump if above
		ja	loc_7721		; Jump if above
		js	loc_7743		; Jump if sign=1
		js	loc_7765		; Jump if sign=1
loc_771B:
		js	$+6Ch			; Jump if sign=1
		js	loc_76A9		; Jump if sign=1
loc_771F:
		js	loc_76CB		; Jump if sign=1
loc_7721:
;*		js	loc_76ED		;*Jump if sign=1
		db	 78h,0CAh		;  Fixup - byte match
		js	loc_770F		; Jump if sign=1
		js	loc_7731		; Jump if sign=1
		jns	$+2Ch			; Jump if not sign
;*		jns	loc_7775		;*Jump if not sign
		db	 79h, 4Ah		;  Fixup - byte match
;*		jns	loc_7797		;*Jump if not sign
		db	 79h, 6Ah		;  Fixup - byte match
		jns	loc_76B9		; Jump if not sign
		jns	loc_76DB		; Jump if not sign
loc_7731:
		jns	loc_76FD		; Jump if not sign
		jns	loc_771F		; Jump if not sign
		jns	loc_7741		; Jump if not sign
		jp	$+2Ch			; Jump if parity=1
		jp	loc_7785		; Jump if parity=1
;*		jp	loc_77B7		;*Jump if parity=1
		db	 7Ah, 7Ah		;  Fixup - byte match
		jp	loc_76E9		; Jump if parity=1
		jp	loc_771B		; Jump if parity=1
loc_7741:
		jp	loc_774D		; Jump if parity=1
loc_7743:
		jnp	$+3Ch			; Jump if not parity
;*		jnp	loc_77B1		;*Jump if not parity
		db	 7Bh, 6Ah		;  Fixup - byte match
		jnp	loc_76E3		; Jump if not parity
;*		jnp	loc_7757		;*Jump if not parity
		db	 7Bh, 0Ch		;  Fixup - byte match
		add	[si],cl
loc_774D:
		add	[bp+si],bl
		add	ds:d_5445_2B00_e,dl
		add	[bx],ah
		add	[bp+di-80h],cl
		db	 67h,0C0h, 5Fh, 20h,0E0h, 70h
		db	 9Fh,0F0h, 83h,0F0h, 85h,0F0h
		db	63h
loc_7765:
;*		loopnz	locloop_7786		;*Loop if zf=0, cx>0

		db	0E0h, 1Fh		;  Fixup - byte match
		add	byte ptr [bx+si],0
		push	es
		add	ds:d_5445_0D00_e,al
		add	[bp+di],cl
		add	[di],dl
		adc	byte ptr [bp+di],80h
		and	ax,23C0h
		rcr	byte ptr [bx-60h],0E0h	; Rotate thru carry
;*		jo	loc_771E		;*Jump if overflow=1
		db	 70h, 9Fh		;  Fixup - byte match
;*                         lock	xor	ax,0FF85h
		db	0F0h, 83h,0F0h, 85h	;  Fixup - byte match
		db	0F0h, 63h
loc_7785:
		loopnz	locloop_77A6		; Loop if zf=0, cx>0

		add	byte ptr [bx+si],0
		add	ax,[bx+si]
		add	ax,[bx+si]
		push	es
		add	byte ptr [di],80h
		or	al,al			; Zero ?
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		adc	ah,al
;*		xor	ax,sp
		db	 31h,0E0h		;  Fixup - byte match
		dec	di
		mov	al,byte ptr ds:[70E0h]
		lahf				; Load ah from flags
;*                         lock	xor	ax,0FF85h
		db	0F0h, 83h,0F0h, 85h	;  Fixup - byte match
		db	0F0h, 63h,0E0h

locloop_77A6:
		pop	ds
		add	byte ptr [bx+si],0
		add	ax,[bx+si]
		add	ax,[bx+si]
		push	es
		add	byte ptr [di],80h
		or	al,al			; Zero ?
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		adc	ah,al
		pop	ds
		loopnz	locloop_77BB		; Loop if zf=0, cx>0


locloop_77BB:
		add	[bx-20h],bh
;*		xor	ax,0FF85h
		db	 83h,0F0h, 85h		;  Fixup - byte match
;*                         lock	xor	ax,7Fh
		db	0F0h, 83h,0F0h, 7Fh	;  Fixup - byte match
		loopnz	$+2			; Loop if zf=0, cx>0

		add	[bx+si],al
		add	[bp+di],al
		add	[bp+di],al
		add	data_0580,al
		or	byte ptr [bp+si],0C0h
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		pop	ds
		loopnz	$+12h			; Loop if zf=0, cx>0

		pusha				; Save all regs
		pop	ds
		and	byte ptr [bp+di-20h],85h
;*                         lock	xor	ax,0FF9Fh
		db	0F0h, 83h,0F0h, 9Fh	;  Fixup - byte match
                           lock	pusha				; Save all regs
		pusha				; Save all regs
		pop	ds
		add	byte ptr [bx+si],0
		push	es
		add	byte ptr ds:[0D00h],al
		add	[bp+di],cl
		add	[di],dl
		adc	byte ptr [bp+di],80h
		aas				; Ascii adjust
		shl	byte ptr [bx+si],40h	; '@' Shift w/zeros fill
		pop	ds
		and	byte ptr [bp+di-20h],85h
;*                         lock	xor	ax,0FF9Fh
		db	0F0h, 83h,0F0h, 9Fh	;  Fixup - byte match
                           lock	pusha				; Save all regs
		pusha				; Save all regs
		pop	ds
		add	byte ptr [bx+si],0
		or	al,0
		or	al,0
		sbb	al,[bx+si]
		push	ss
		add	[bp+di],ch
		add	[bx],ah
		add	[bx-80h],bh
		pusha				; Save all regs
		sbb	byte ptr [bx],80h
		db	 63h,0E0h
loc_781E:
		test	si,ax
;*		xor	ax,0FF9Fh
		db	 83h,0F0h, 9Fh		;  Fixup - byte match
                           lock	pusha				; Save all regs
		pusha				; Save all regs
		pop	ds
		add	byte ptr [bx+si],0
		or	al,0
		or	al,0
		sbb	al,[bx+si]
		push	ss
		add	[bp+di],ch
		add	[bx],ah
		add	[bp+di-80h],cl
;*		jg	loc_77BA		;*Jump if >
		db	 7Fh, 80h		;  Fixup - byte match
		add	[bx+si],al
		jg	loc_781E		; Jump if >
;*		xor	ax,0FF85h
		db	 83h,0F0h, 85h		;  Fixup - byte match
;*                         lock	xor	ax,7Fh
		db	0F0h, 83h,0F0h, 7Fh	;  Fixup - byte match
		loopnz	locloop_7847		; Loop if zf=0, cx>0


locloop_7847:
		add	[bx+si],al
		add	[bp+di],al
		add	[bp+di],al
		add	data_0580,al
		or	byte ptr [bp+si],0C0h
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		adc	ah,al
;*		sbb	ax,si
		db	 19h,0F0h		;  Fixup - byte match
		pop	ss
		enter	1C38h,27h		; ''' Procedure entry
		cld				; Clear direction
;*		and	ah,bh
		db	 20h,0FCh		;  Fixup - byte match
		and	[si+18h],di
		clc				; Clear carry flag
		pop	es
		loopnz	locloop_7869		; Loop if zf=0, cx>0


locloop_7869:
		add	[bx+di],al
		add	byte ptr [bx+di],80h
		add	ax,[bx+si+2]
		rol	byte ptr [di],60h	; '`' Rotate
		add	al,0E0h
		or	[bx+si+8],si
                           lock	pop	ss
;*		call	sub_94B6		;*
		db	0E8h, 38h, 1Ch		;  Fixup - byte match
		daa				; Decimal adjust
		cld				; Clear direction
;*		and	ah,bh
		db	 20h,0FCh		;  Fixup - byte match
		and	[si+18h],di
		clc				; Clear carry flag
		pop	es
		loopnz	locloop_7889		; Loop if zf=0, cx>0


locloop_7889:
		add	[bx+si],al
		rol	byte ptr [bx+si],0C0h	; Rotate
		add	data_6001[bx+si],sp
		add	dh,data_7002[bx+si]
		add	al,0B8h
		or	al,78h			; 'x'
		adc	bp,ax
		cmp	[si],bl
		daa				; Decimal adjust
		cld				; Clear direction
;*		and	ah,bh
		db	 20h,0FCh		;  Fixup - byte match
		and	[si+18h],di
		clc				; Clear carry flag
		pop	es
		loopnz	locloop_78A9		; Loop if zf=0, cx>0


locloop_78A9:
		add	[bx+si],al
		rol	byte ptr [bx+si],0C0h	; Rotate
		add	data_6001[bx+si],sp
		add	dh,data_7002[bx+si]
		add	al,0B8h
		pop	es
		clc				; Clear carry flag
		add	[bx+si],al
		pop	ds
		clc				; Clear carry flag
;*		and	ah,bh
		db	 20h,0FCh		;  Fixup - byte match
		and	[si+20h],di
		cld				; Clear direction
		pop	ds
		clc				; Clear carry flag
		db	 00h, 00h, 00h, 00h, 00h,0C0h
		db	 00h,0C0h, 01h,0A0h, 01h, 60h
		db	 02h,0B0h, 02h, 70h, 07h,0F8h
		db	 04h, 18h, 07h,0E0h, 18h,0F8h
		db	 21h, 7Ch, 20h,0FCh, 27h,0FCh
		db	 18h, 18h, 07h,0E0h, 00h, 00h
		db	 01h, 80h, 01h, 80h, 03h, 40h
		db	 02h,0C0h, 05h, 60h, 04h,0E0h
		db	 0Fh,0F0h, 08h, 10h, 07h,0E0h
		db	 18h,0F8h, 21h, 7Ch, 20h,0FCh
		db	 27h,0FCh, 18h, 18h, 07h,0E0h
		db	 00h, 00h, 03h, 00h, 03h, 00h
		db	 06h, 80h, 05h, 80h, 0Ah,0C0h
		db	 09h,0C0h, 1Fh,0E0h, 18h, 20h
		db	 07h,0E0h, 18h,0F8h, 21h, 7Ch
		db	 20h,0FCh, 27h,0FCh, 18h, 18h
		db	 07h,0E0h, 00h

locloop_7929:
		add	[bp+di],al
		add	[bp+di],al
		add	ds:d_FE05_0580_e,al

locloop_7931:
		or	byte ptr [bp+si],0C0h
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		adc	ah,al
		pop	ds
		loopnz	locloop_793B		; Loop if zf=0, cx>0


locloop_793B:
		add	[bx],bl
		clc				; Clear carry flag
;*		and	ah,bh
		db	 20h,0FCh		;  Fixup - byte match
		and	[si+20h],di
		cld				; Clear direction
		pop	ds
		clc				; Clear carry flag
		db	 00h, 00h, 00h, 00h, 00h,0C0h
		db	 00h,0C0h, 01h,0A0h, 01h, 60h
		db	 02h,0B0h, 02h, 70h, 04h,0B8h
		db	 06h, 7Ch, 05h,0F2h, 0Eh, 07h
		db	 09h,0FFh, 08h, 3Fh, 08h, 5Fh
		db	 06h, 3Eh, 01h,0F8h, 00h, 00h
		db	 00h, 60h, 00h, 60h, 00h,0D0h
		db	 00h,0B0h, 01h, 58h, 01h, 38h
		db	 02h, 5Ch, 02h, 3Ch, 05h,0FAh
		db	 0Eh, 07h, 09h,0FFh, 08h, 3Fh
		db	 08h, 5Fh, 06h, 3Eh, 01h,0F8h
		db	 00h, 00h, 00h, 30h, 00h, 30h
		db	 00h, 68h, 00h, 58h, 00h,0ACh
		db	 00h, 9Ch, 01h, 2Eh, 03h, 1Eh
		db	 04h,0FAh, 0Eh, 07h, 09h,0FFh
		db	 08h, 3Fh, 08h, 5Fh, 06h, 3Eh
		db	 01h,0F8h, 00h, 00h, 00h, 30h
		db	 00h, 30h, 00h, 68h, 00h, 58h
		db	 00h,0ACh, 00h, 9Ch, 01h, 2Eh
		db	 01h,0FEh, 00h, 00h, 07h,0FEh
		db	 08h, 3Fh, 08h, 5Fh, 08h, 3Fh
		db	 07h,0FEh, 00h, 00h, 00h, 00h
		db	 00h, 30h, 00h, 30h, 00h, 68h
		db	 00h, 58h, 00h,0ACh, 00h, 9Ch
		db	 01h,0FEh, 01h, 06h, 01h,0F8h
		db	 06h, 3Eh, 08h, 5Fh, 08h, 3Fh
		db	 09h,0FFh, 06h
loc_79E5:
		push	es
;*		add	ax,di
		db	 01h,0F8h		;  Fixup - byte match
		add	[bx+si],al
;*		add	[bx+si+0],ah
		db	 00h, 60h, 00h		;  Fixup - byte match
		db	 60h, 00h,0D0h, 00h,0B0h, 01h
		db	 58h, 01h, 38h, 03h,0FCh, 02h
		db	 04h, 01h,0F8h, 06h, 3Eh, 08h
		db	 5Fh, 08h, 3Fh, 09h,0FFh, 06h
		db	 06h, 01h,0F8h, 00h, 00h, 00h
		db	0C0h, 00h,0C0h, 01h,0A0h, 01h
		db	 60h, 02h,0B0h, 02h, 70h, 07h
		db	0F8h, 06h, 08h, 01h,0F8h, 06h
		db	 3Eh, 08h, 5Fh, 08h, 3Fh, 09h
		db	0FFh, 06h, 06h, 01h,0F8h, 00h
		db	 00h, 00h
loc_7A2B:
		rol	byte ptr [bx+si],0C0h	; Rotate
		add	ds:d_0038_6001_e[bx+si],sp
		add	dh,ds:d_0038_7002_e[bx+si]
		add	al,0B8h
		pop	es
		clc				; Clear carry flag
		add	[bx+si],al
		pop	es
		dec	byte ptr [bx+si]
		aas				; Ascii adjust
		or	[bx+8],bl
		aas				; Ascii adjust
		pop	es
		inc	byte ptr [bx+si]
		db	 00h, 00h, 00h, 00h, 30h, 00h
		db	 00h, 30h, 00h, 00h, 68h, 00h
		db	 00h, 58h, 00h, 00h,0ACh, 00h
		db	 00h, 9Ch, 00h, 01h, 2Eh, 00h
		db	 01h, 9Fh, 00h, 01h, 7Ch, 80h
		db	 03h, 81h,0C0h, 02h, 7Fh,0C0h
		db	 02h, 0Fh,0C0h, 02h, 17h,0C0h
		db	 01h, 8Fh, 80h, 00h, 7Eh, 00h
		db	 00h, 00h, 00h, 00h, 18h, 00h
		db	 00h, 18h, 00h, 00h, 34h, 00h
		db	 00h, 2Ch, 00h, 00h, 56h, 00h
		db	 00h, 4Eh, 00h, 00h, 97h, 00h
		db	 00h, 8Fh, 00h, 01h, 7Eh, 80h
		db	 03h, 81h,0C0h, 02h, 7Fh,0C0h
		db	 02h, 0Fh,0C0h, 02h, 17h,0C0h
		db	 01h, 8Fh, 80h, 00h, 7Eh, 00h
		db	 00h, 00h, 00h, 00h, 0Ch, 00h
		db	 00h, 0Ch, 00h, 00h, 1Ah, 00h
		db	 00h, 16h, 00h, 00h, 2Bh, 00h
		db	 00h, 27h, 00h, 00h, 4Bh, 80h
		db	 00h,0C7h, 80h, 01h, 3Eh, 80h
		db	 03h, 81h,0C0h, 02h, 7Fh,0C0h
		db	 02h, 0Fh,0C0h, 02h, 17h,0C0h
		db	 01h, 8Fh, 80h, 00h, 7Eh, 00h
		db	 00h, 00h, 00h, 00h, 0Ch, 00h
		db	 00h, 0Ch, 00h, 00h, 1Ah, 00h
		db	 00h, 16h, 00h, 00h, 2Bh, 00h
		db	 00h, 27h, 00h, 00h, 4Bh, 80h
		db	 00h, 7Fh, 80h, 00h, 00h, 00h
		db	 01h,0FFh, 80h, 02h, 0Fh,0C0h
		db	 02h, 17h,0C0h, 02h, 0Fh,0C0h
		db	 01h,0FFh, 80h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Ch, 00h
		db	 00h, 0Ch, 00h, 00h, 1Ah, 00h
		db	 00h, 16h, 00h, 00h, 2Bh, 00h
		db	 00h, 27h, 00h, 00h, 7Fh, 80h
		db	 00h, 41h, 80h, 00h, 7Eh, 00h
		db	 01h, 8Fh, 80h, 02h, 17h,0C0h
		db	 02h, 0Fh,0C0h, 02h, 7Fh,0C0h
		db	 01h, 81h, 80h, 00h, 7Eh, 00h
		db	 00h, 00h, 00h, 00h, 18h, 00h
		db	 00h, 18h, 00h, 00h, 34h, 00h
		db	 00h, 2Ch, 00h, 00h, 56h, 00h
		db	 00h, 4Eh, 00h, 00h,0FFh, 00h
		db	 00h, 81h, 00h, 00h, 7Eh, 00h
		db	 01h, 8Fh, 80h, 02h, 17h,0C0h
		db	 02h, 0Fh,0C0h, 02h, 7Fh,0C0h
		db	 01h, 81h, 80h, 00h, 7Eh, 00h
		db	 00h, 00h
		db	 00h, 00h, 30h, 00h, 00h, 30h
		db	 00h, 00h, 68h, 00h, 00h, 58h
		db	 00h, 00h,0ACh, 00h, 00h, 9Ch
		db	 00h, 01h,0FEh, 00h, 01h, 82h
		db	 00h, 00h, 7Eh, 00h
loc_7B85:
		add	ds:d_0038_0280_e[bx],cx
		pop	ss
loc_7B8A:
		rol	byte ptr [bp+si],0Fh	; Rotate
		rol	byte ptr [bp+si],7Fh	; Rotate
		rol	byte ptr [bx+di],81h	; Rotate
		add	byte ptr [bx+si],7Eh	; '~'
		db	 00h, 00h, 00h, 00h, 00h, 30h
		db	 00h, 00h, 30h, 00h, 00h
loc_7BA1:
;*		push	0
		db	 68h, 00h, 00h		;  Fixup - byte match
		pop	ax
		add	[bx+si],al
		lodsb				; String [si] to al
		add	[bx+si],al
		pushf				; Push flags
		add	[bx+di],al
		add	cs:[bx+di],al
		inc	byte ptr [bx+si]
		add	[bx+si],al
		add	[bx+di],al
		inc	word ptr ds:d_0038_0F02_e[bx+si]
		rol	byte ptr [bp+si],17h	; Rotate
loc_7BBD:
		rol	byte ptr [bp+si],0Fh	; Rotate
		rol	byte ptr [bx+di],0FFh	; Rotate
		add	byte ptr [bx+si],0
		db	 00h, 00h, 00h, 00h,0FAh, 7Bh
		db	 14h
		db	'|.|H|b|||'
		db	 96h, 7Ch,0B0h, 7Ch,0CAh, 7Ch
		db	0E4h
loc_7BDD:
		jl	loc_7BDD		; Jump if <
		jl	$+1Ah			; Jump if <
		jge	loc_7C15		; Jump if > or =
		jge	loc_7C31		; Jump if > or =
;*		jge	loc_7C4D		;*Jump if > or =
		db	 7Dh, 66h		;  Fixup - byte match
;*		jge	loc_7B69		;*Jump if > or =
		db	 7Dh, 80h		;  Fixup - byte match
		jge	loc_7B85		; Jump if > or =
		jge	loc_7BA1		; Jump if > or =
		jge	loc_7BBD		; Jump if > or =
;*		jge	loc_7BE6		;*Jump if > or =
		db	 7Dh,0F5h		;  Fixup - byte match
;*		jge	loc_7C0F		;*Jump if > or =
		db	 7Dh, 1Ch		;  Fixup - byte match
		jle	loc_7C38		; Jump if < or =
;*		jle	loc_7C61		;*Jump if < or =
		db	 7Eh, 6Ah		;  Fixup - byte match
		jle	loc_7B8A		; Jump if < or =
		jle	$+2			; delay for I/O
		add	[bx+si],bh
		loopnz	$+47h			; Loop if zf=0, cx>0

		adc	ss:d_52C0_D728_e[bp+si],cl
		pop	ax
		scasb				; Scan es:[di] for al
		mov	ax,0F07Fh
;*		cmp	al,ah
		db	 38h,0E0h		;  Fixup - byte match
		adc	[bx+si+1Ah],ax
		rcl	byte ptr [di],0C0h	; Rotate thru carry
		db	 0Fh, 80h, 07h, 00h, 00h
loc_7C15:
		add	[bx+si],bh
;*		add	[bx+0],al
		db	 00h, 47h, 00h		;  Fixup - byte match
		db	 8Ah, 80h,0D7h, 40h,0AEh,0C0h
		db	 7Fh,0C0h, 38h, 80h, 11h, 40h
		db	 1Ah,0C0h, 15h,0C0h, 0Fh, 80h
		db	 07h, 00h, 00h, 00h, 1Ch
loc_7C31:
		add	[bp+si],ah
;*		add	[di+0],al
		db	 00h, 45h, 00h		;  Fixup - byte match
		db	 6Bh, 00h
loc_7C38:
		push	di
		add	[bx-80h],bh
		pop	sp
		inc	ax
		sub	ds:d_0038_601D_e[bx+si],ah
		or	ah,al
		pop	es
		rol	byte ptr [bp+di],80h	; Rotate
		pop	es
		add	[bx+si],cl
		adc	byte ptr [bx+di],40h	; '@'
		sbb	al,al
		adc	ax,3FC0h
		loopnz	locloop_7C9C		; Loop if zf=0, cx>0

		adc	ss:d_52C0_D728_e[bp+si],cl
		pop	ax
		scasb				; Scan es:[di] for al
		mov	ax,0F07Dh
;*		cmp	al,ah
		db	 38h,0E0h		;  Fixup - byte match
		add	[bx+si],al
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		add	ah,[bx+si]
		add	al,50h			; 'P'
		push	es
		mov	al,5
		jo	loc_7C7C		; Jump if overflow=1
;*                         lock	adc	ax,si
		db	0F0h, 11h,0F0h		;  Fixup - byte match
		and	dl,al
		xor	ax,2BB0h
;*		loopnz	locloop_7C96		;*Loop if zf=0, cx>0

		db	0E0h, 1Fh		;  Fixup - byte match
		ror	byte ptr ds:d_0038_0000_e,0	; Rotate
loc_7C7C:
		add	[bx+si],al
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		add	ah,[bx+si]
		add	al,50h			; 'P'
		push	cs
		mov	al,15h
;*		jo	loc_7CC8		;*Jump if overflow=1
		db	 70h, 3Fh		;  Fixup - byte match
;*		loopnz	locloop_7CBC		;*Loop if zf=0, cx>0

		db	0E0h, 31h		;  Fixup - byte match
		shl	byte ptr [bp+si],80h	; Shift w/zeros fill
		xor	ax,2B80h
		sbb	byte ptr [bx],0
		push	cs
		add	[bx+si],al
		add	ds:d_0038_1138_e,cl
		inc	sp

locloop_7C9C:
		and	cl,ss:d_52C0_D635_e[bp+si]
		sub	bp,ss:d_52C0_FC1F_e[bp]
		push	cs
		cmp	[si],al
		push	ax
		push	es
		mov	al,5
;*		jo	locloop_7CB0		;*Jump if overflow=1
		db	 70h, 03h		;  Fixup - byte match
;*		loopnz	locloop_7CB0		;*Loop if zf=0, cx>0

		db	0E0h, 01h		;  Fixup - byte match
		rol	byte ptr [bx+si],0	; Rotate
		push	cs
		add	[bx+di],dl
		shl	byte ptr [bp+si],0A0h	; Shift w/zeros fill
		xor	ax,2BD0h
		mov	al,1Fh
                           lock	push	cs
		and	[si],al
		push	ax
		push	es
		mov	al,5
;*		jo	locloop_7CCA		;*Jump if overflow=1
		db	 70h, 03h		;  Fixup - byte match
;*		loopnz	locloop_7CCA		;*Loop if zf=0, cx>0

		db	0E0h, 01h		;  Fixup - byte match
		rol	byte ptr [bx+si],0	; Rotate
		pop	es
		add	[bx+si],cl
		adc	byte ptr [bx+di],40h	; '@'
		sbb	al,al
		adc	ax,1FC0h
		loopnz	locloop_7CF0		; Loop if zf=0, cx>0

		adc	[bp+si],cl
		sub	[bx],al
		pop	ax
		add	bh,ds:d_0038_F001_e[bx+si]
;*		add	al,ah
		db	 00h,0E0h		;  Fixup - byte match
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		add	ah,[bx+si]
		add	al,50h			; 'P'
		push	es
		mov	al,5
;*		jo	loc_7CFE		;*Jump if overflow=1
		db	 70h, 0Fh		;  Fixup - byte match
		clc				; Clear carry flag

locloop_7CF0:
;*		adc	sp,ax
		db	 11h,0C4h		;  Fixup - byte match
		and	cl,ss:d_52C0_D635_e[bp+si]
		sub	bp,ss:d_52C0_7C1F_e[bp]
		push	cs
		cmp	[bx+si],al
		add	[bx+si],al
		jo	$+2			; delay for I/O
		mov	[bx+di],al
		adc	al,1
		lodsb				; String [si] to al
		add	[si+3],bx
		cld				; Clear direction
		add	al,7Ch			; '|'
		or	ds:d_0038_6C0D_e[si],dh
		or	bh,al
		pop	es
;*                         lock	add	ax,ds:d_0038_0000_e[bx+si]
		db	0F0h, 03h, 80h, 00h, 00h	;  Fixup - byte match
		add	[bx+si],al
;*		add	[bx+si+0],dh
		db	 00h, 70h, 00h		;  Fixup - byte match
		db	 88h, 01h, 14h, 03h,0ACh, 05h
		db	 5Ch, 0Fh,0F8h, 0Ch, 70h, 08h
		db	0A0h, 0Dh, 60h, 0Ah,0E0h, 07h
		db	0C0h, 03h, 80h, 00h, 00h, 03h
		db	 8Eh, 04h, 51h, 08h,0A2h, 0Dh
		db	 75h, 0Ah,0EBh, 07h,0FFh, 03h
		db	 8Eh, 01h, 14h, 01h,0ACh, 01h
		db	 5Ch, 00h,0F8h, 00h, 70h, 00h
		db	 00h, 03h, 80h, 04h, 70h, 08h
		db	0A8h, 0Dh, 74h, 0Ah,0ECh, 07h
		db	0FCh, 03h, 88h, 01h, 14h, 01h
		db	0ACh, 01h, 5Ch, 00h,0F8h, 00h
		db	 70h, 00h, 00h, 01h,0C0h, 02h
		db	 20h, 04h, 50h, 06h,0B0h, 05h
		db	 70h, 07h,0F8h, 05h,0C4h, 02h
		db	 8Ah, 01h,0D6h, 00h,0AEh, 00h
		db	 7Ch, 00h, 38h, 00h, 70h, 00h
		db	 88h, 01h, 14h, 01h,0ACh, 01h
		db	 5Ch, 03h,0FEh, 04h, 71h, 08h
		db	0A2h, 0Dh, 75h, 0Ah,0EBh, 07h
		db	0DFh, 03h, 8Eh, 00h, 00h, 00h
		db	 1Ch, 00h, 22h, 00h, 45h, 00h
		db	 6Bh, 00h, 57h, 00h,0FFh, 01h
		db	 1Fh, 02h, 2Dh, 03h, 5Bh, 02h
		db	0BEh, 01h,0FCh, 00h,0E0h, 00h
		db	 00h, 00h, 00h, 00h, 1Ch, 00h
		db	 22h, 00h, 45h, 00h,0EBh, 01h
		db	 57h, 03h,0FEh, 03h, 1Ch, 02h
		db	 28h, 03h, 58h, 02h,0B8h, 01h
		db	0F0h, 00h,0E0h, 00h, 00h, 00h
		db	 00h,0E3h, 80h, 01h, 14h, 40h
		db	 02h, 28h,0A0h, 03h, 5Dh, 60h
		db	 02h,0BAh,0E0h, 01h,0FFh,0C0h
		db	 00h,0E3h, 80h, 00h, 45h, 00h
		db	 00h, 6Bh, 00h, 00h, 57h, 00h
		db	 00h, 3Eh, 00h, 00h, 1Ch, 00h
		db	 00h, 00h, 00h, 00h,0E0h, 00h
		db	 01h, 1Ch, 00h, 02h, 2Ah, 00h
		db	 03h, 5Dh, 00h, 02h,0BBh, 00h
		db	 01h,0FFh, 00h, 00h,0E2h, 00h
		db	 00h, 45h, 00h, 00h, 6Bh, 00h
		db	 00h, 57h, 00h, 00h, 3Eh, 00h
		db	 00h, 1Ch, 00h, 00h, 00h, 00h
		db	 00h, 70h, 00h, 00h, 88h, 00h
		db	 01h, 14h, 00h, 01h,0ACh, 00h
		db	 01h, 5Ch, 00h, 01h,0FEh, 00h
		db	 01h, 71h, 00h, 00h,0A2h, 80h
		db	 00h, 75h, 80h, 00h, 2Bh, 80h
		db	 00h, 1Fh, 00h, 00h, 0Eh, 00h
		db	 00h, 1Ch, 00h, 00h, 22h, 00h
		db	 00h, 45h, 00h, 00h, 6Bh, 00h
		db	 00h, 57h, 00h, 00h,0FFh, 80h
		db	 01h
loc_7E56:
		sbb	al,40h			; '@'
		add	ch,[bx+si]
		mov	al,ds:d_0038_5D03_e
		pusha				; Save all regs
		add	bh,ss:d_52C0_01E0_e[bp+si]
;*		test	ax,0E300h
		db	0F7h,0C0h, 00h,0E3h	;  Fixup - byte match
		add	byte ptr [bx+si],0
		add	[bx+si],al
		pop	es
		add	[bx+si],al
		or	ds:d_0038_1100_e[bx+si],al
		inc	ax
		add	[bp+si],bl
		rol	byte ptr [bx+si],15h	; Rotate
		rol	byte ptr [bx+si],3Fh	; '?' Rotate
		rol	byte ptr [bx+si],47h	; 'G' Rotate
		rol	byte ptr [bx+si],8Bh	; Rotate
		inc	ax
;*		add	dh,dl
		db	 00h,0D6h		;  Fixup - byte match
		rol	byte ptr [bx+si],0AFh	; Rotate
		add	byte ptr [bx+si],7Fh
		add	[bx+si],al
		cmp	[bx+si],al
		db	7 dup (0)
		db	 07h, 00h, 00h, 08h, 80h, 00h
loc_7E9B:
;*		adc	[bx+si+0],ax
		db	 11h, 40h, 00h		;  Fixup - byte match
		db	 3Ah,0C0h, 00h, 55h,0C0h, 00h
		db	0FFh, 80h, 00h,0C7h, 00h, 00h
		db	 8Ah, 00h, 00h,0D6h, 00h, 00h
		db	0AEh, 00h, 00h, 7Ch, 00h, 00h
		db	 38h, 00h, 38h, 7Fh, 58h, 7Fh
		db	78h
loc_7EBD:
;*		jg	loc_7E57		;*Jump if >
		db	 7Fh, 98h		;  Fixup - byte match
;*		jg	loc_7E79		;*Jump if >
		db	 7Fh,0B8h		;  Fixup - byte match
		jg	loc_7E9B		; Jump if >
		jg	loc_7EBD		; Jump if >
;*		jg	loc_7EDF		;*Jump if >
		db	 7Fh, 18h		;  Fixup - byte match
		cmp	byte ptr [bx+si],80h
		pop	ax
		cmp	byte ptr [bx+si-80h],98h
		sbb	byte ptr ds:d_0038_9880_e[bx+si],80h
		js	loc_7E56		; Jump if sign=1
		pop	ax
		cmp	byte ptr ds:d_0038_D880_e[bx+si],80h

locloop_7EDC:
		clc				; Clear carry flag
		sbb	byte ptr [bx+si],81h
		cmp	ds:d_0038_8158_e[bx+di],al
;*		js	loc_7E67		;*Jump if sign=1
		db	 78h, 81h		;  Fixup - byte match
		cbw				; Convrt byte to word
		cmp	word ptr ds:d_0038_D881_e[bx+si],0F881h
		sbb	word ptr [bx+si],1882h
;*		sbb	byte ptr [bx+si],82h
		db	 82h, 18h, 82h		;  Fixup - byte match

locloop_7EF4:
		clc				; Clear carry flag
;*		sbb	ax,3881h
		db	 81h,0D8h, 81h, 38h	;  Fixup - byte match
;*		sbb	byte ptr [bx+si-7Eh],78h	; 'x'
		db	 82h, 58h, 82h, 78h	;  Fixup - byte match
;*		sbb	byte ptr ds:[0B882h][bx+si],82h
		db	 82h, 98h, 82h,0B8h, 82h	;  Fixup - byte match
		db	0D8h, 82h,0F8h, 82h, 18h, 83h
		db	 38h, 83h, 58h, 83h, 78h, 83h
		db	 98h, 83h, 98h, 83h, 98h
loc_7F13:
		cmp	word ptr [bx+si-7Dh],58h
;*		cmp	word ptr ds:d_0038_E883_e[bx+si],0FF83h
		db	 83h,0B8h, 83h,0E8h, 83h	;  Fixup - byte match
		sbb	ds:d_0038_8448_e[si],al

locloop_7F20:
		js	$-7Ah			; Jump if sign=1
		test	al,84h
		db	0D8h, 84h, 08h, 85h, 38h, 85h
		db	 68h, 85h, 98h, 85h,0C8h, 85h
		db	0C8h, 85h,0C8h, 85h, 98h
loc_7F35:
		test	bp,[bx+si-7Bh]
		add	al,0
		push	cs
		add	[bx],dl
		add	[bx],ah
		add	byte ptr [bx-40h],87h
;*		loopnz	locloop_7ED0		;*Loop if zf=0, cx>0

		db	0E0h, 8Bh		;  Fixup - byte match
		loopnz	locloop_7EDC		; Loop if zf=0, cx>0

;*		loopnz	locloop_7EF3		;*Loop if zf=0, cx>0

		db	0E0h,0AAh		;  Fixup - byte match
		loopnz	locloop_7F20		; Loop if zf=0, cx>0

		pusha				; Save all regs
		stosb				; Store al to es:[di]
		mov	al,ds:d_0038_4055_e

;		sub	al,ds:d_0038_0015_e[bx+si]
		db	2Ah, 80h, 15h, 0

		or	al,[bx+si]
		add	al,0
		add	al,0
		push	cs
		add	[bx],dh
		add	byte ptr [bx-40h],87h
;*		loopnz	locloop_7EEA		;*Loop if zf=0, cx>0

		db	0E0h, 87h		;  Fixup - byte match
;*		loopnz	locloop_7EEC		;*Loop if zf=0, cx>0

		db	0E0h, 87h		;  Fixup - byte match
;*		loopnz	locloop_7EEE		;*Loop if zf=0, cx>0

		db	0E0h, 87h		;  Fixup - byte match
		loopnz	locloop_7EF4		; Loop if zf=0, cx>0

		loopnz	locloop_7F20		; Loop if zf=0, cx>0

;*		loopnz	locloop_7F37		;*Loop if zf=0, cx>0

		db	0E0h,0CAh		;  Fixup - byte match
		pusha				; Save all regs
		mov	ch,0A0h
		dec	dx
		inc	ax
		xor	ax,0A80h
		add	[si],al
		db	 00h, 00h, 00h, 00h, 00h, 04h
		db	 00h, 1Fh, 00h, 67h,0C0h, 87h
		db	0E0h, 87h,0E0h, 87h,0E0h, 87h
		db	0E0h, 87h,0E0h, 9Bh,0E0h,0E4h
		db	0E0h, 9Bh, 20h, 64h,0C0h, 1Bh
		db	 00h, 04h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 04h, 00h, 1Fh
		db	 00h,0E7h,0E0h, 87h,0E0h, 87h
		db	0E0h, 87h,0E0h, 87h,0E0h, 87h
		db	0E0h, 9Bh,0E0h,0E4h,0E0h, 1Bh
		db	 00h, 04h
		db	13 dup (0)
		db	0FFh,0E0h, 87h,0E0h, 87h,0E0h
		db	 87h,0E0h, 87h,0E0h, 87h,0E0h
		db	 87h,0E0h,0FFh,0E0h
		db	12 dup (0)

locloop_7FDE:
		add	al,0
		sbb	ax,[bx+si]
		in	al,0E0h			; port 0E0h, Memory encode reg2
		db	 9Bh,0E0h, 87h,0E0h, 87h,0E0h
		db	 87h,0E0h, 87h,0E0h, 87h,0E0h
		db	0E7h,0E0h, 1Fh, 00h, 04h
		db	7 dup (0)
		db	 04h, 00h, 1Bh, 00h, 64h,0C0h
		db	 9Bh, 20h,0E4h,0E0h, 9Bh,0E0h
		db	 87h,0E0h, 87h,0E0h, 87h,0E0h
		db	 87h,0E0h, 87h,0E0h, 67h,0C0h
		db	 1Fh, 00h, 04h, 00h, 00h, 00h
		db	 04h, 00h, 0Ah, 00h, 35h, 80h
		db	 4Ah, 40h,0B5h,0A0h,0CAh, 60h
		db	0B5h,0E0h, 8Bh,0E0h, 87h,0E0h
		db	 87h,0E0h, 87h,0E0h, 87h,0E0h
		db	 47h,0C0h, 37h, 80h, 0Eh, 00h
		db	 04h, 00h, 0Ah, 00h, 15h, 00h
		db	 2Ah, 80h, 55h, 40h,0AAh,0A0h
		db	0D5h, 60h,0AAh,0E0h, 95h,0E0h
		db	 8Bh,0E0h, 87h,0E0h, 47h,0C0h
		db	 27h, 80h, 17h, 00h, 0Eh, 00h
		db	 04h, 00h, 00h, 00h, 04h, 00h
		db	 0Ah, 00h, 15h, 00h, 2Ah, 80h
		db	 55h, 40h,0AAh,0A0h, 55h, 50h
		db	 55h, 50h,0AAh,0A0h, 55h, 40h
		db	 2Ah, 80h, 15h, 00h, 0Ah, 00h
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Eh, 00h, 11h, 00h
		db	 22h, 80h, 45h, 40h, 8Ah,0A0h
		db	 95h, 60h,0AAh,0A0h,0D5h, 60h
		db	 6Ah,0C0h, 35h, 80h, 1Bh, 00h
		db	 0Eh, 00h, 00h
		db	9 dup (0)
		db	 1Fh, 00h, 21h, 80h, 42h,0C0h
		db	 41h, 40h, 8Ah,0E0h, 95h, 60h
		db	 8Ah,0E0h, 55h,0C0h, 6Bh,0C0h
		db	 3Fh, 80h, 1Fh, 00h, 00h, 00h
		db	 00h, 00h, 01h, 00h, 03h, 80h
		db	 05h,0C0h, 09h,0E0h, 11h,0F0h
		db	 21h,0F8h, 22h,0F8h, 25h, 78h
		db	 2Ah,0B8h, 35h, 58h, 2Ah,0A8h
		db	 15h, 50h, 0Ah,0A0h, 05h, 40h
		db	 02h, 80h, 01h, 00h, 01h, 00h
		db	 03h, 80h, 0Dh,0E0h, 11h,0F0h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 22h,0F8h, 2Dh, 78h
		db	 32h, 98h, 2Dh, 68h, 12h, 90h
		db	 0Dh, 60h, 02h, 80h, 01h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 00h
		db	 07h,0C0h, 19h,0F0h, 21h,0F8h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 26h,0F8h, 39h, 38h
		db	 26h,0C8h, 19h, 30h, 06h,0C0h
		db	 01h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 00h, 07h,0C0h
		db	 39h,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 26h,0F8h, 39h, 38h, 06h,0C0h
		db	 01h, 00h
		db	12 dup (0)
		db	 3Fh,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 3Fh,0F8h
		db	12 dup (0)
		db	 01h, 00h, 06h,0C0h, 39h, 38h
		db	 26h,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 39h,0F8h, 07h,0C0h, 01h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 00h, 06h,0C0h, 19h, 30h
		db	 26h,0C8h, 39h, 38h, 26h,0F8h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 21h,0F8h, 21h,0F8h, 19h,0F0h
		db	 07h,0C0h, 01h, 00h, 00h, 00h
		db	 01h, 00h, 02h, 80h, 0Dh, 60h
		db	 12h, 90h, 2Dh, 68h, 32h, 98h
		db	 2Dh, 78h, 22h,0F8h, 21h,0F8h
		db	 21h,0F8h, 21h,0F8h, 21h,0F8h
		db	 11h,0F0h, 0Dh,0E0h, 03h, 80h
		db	 01h, 00h, 02h, 80h, 05h, 40h
		db	 0Ah,0A0h, 15h, 50h, 2Ah,0A8h
		db	 35h, 58h, 2Ah,0B8h, 25h, 78h
		db	 22h,0F8h, 21h,0F8h, 11h,0F0h
		db	 09h,0E0h, 05h,0C0h, 03h, 80h
		db	 01h, 00h, 00h, 00h, 01h, 00h
		db	 02h, 80h, 05h, 40h, 0Ah,0A0h
		db	 15h, 50h, 2Ah,0A8h, 15h, 54h
		db	 15h, 54h, 2Ah,0A8h, 15h, 50h
		db	 0Ah,0A0h, 05h, 40h, 02h, 80h
		db	 01h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 80h, 04h, 40h
		db	 08h,0A0h, 11h, 50h, 22h,0A8h
		db	 25h, 58h, 2Ah,0A8h, 35h, 58h
		db	 1Ah,0B0h, 0Dh, 60h, 06h,0C0h
		db	 03h, 80h
		db	10 dup (0)
		db	 07h,0C0h, 08h, 60h, 10h,0B0h
		db	 10h, 50h, 22h,0B8h, 25h, 58h
		db	 22h,0B8h, 15h, 70h, 1Ah,0F0h
		db	 0Fh,0E0h, 07h,0C0h, 00h, 00h
		db	 00h, 00h, 00h, 40h, 00h,0E0h
		db	 01h, 70h, 02h, 78h, 04h
		db	 7Ch, 08h, 7Eh, 08h
loc_8245:
		mov	si,d_0038_5E09_e
		or	ch,ss:d_52C0_560D_e[bp]
		or	ch,ss:d_52C0_5405_e[bp+si]
		add	ch,ds:d_0038_5001_e[bx+si]
		add	ds:d_0038_4000_e[bx+si],ah
;*		add	[bx+si+0],al
		db	 00h, 40h, 00h		;  Fixup - byte match
		db	0E0h, 03h, 78h, 04h
		db	'|', 8, '~', 8, '~', 8, '~', 8, '~'
		db	8
		db	0BEh, 0Bh, 5Eh, 0Ch
loc_826D:
		cmpsb				; Cmp [si] to es:[di]
		or	bx,[bp+si+4]
loc_8271:
		movsb				; Mov [si] to es:[di]
;*		add	bx,[bx+si+0]
		db	 03h, 58h, 00h		;  Fixup - byte match
		db	0A0h, 00h, 40h, 00h, 00h, 00h
		db	 00h, 00h, 40h, 01h,0F0h, 06h
		db	'|', 8, '~', 8, '~', 8, '~', 8, '~'
		db	8, '~', 9
		db	0BEh, 0Eh, 4Eh, 09h,0B2h, 06h
		db	 4Ch, 01h,0B0h
loc_8296:
;*		add	[bx+si+0],al
		db	 00h, 40h, 00h		;  Fixup - byte match
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 40h, 01h,0F0h, 0Eh
		db	 7Eh, 08h, 7Eh, 08h, 7Eh, 08h
		db	 7Eh
data_82AA	dw	7E08h			; Data table (indexed access)
		db	 08h, 7Eh, 09h,0BEh, 0Eh, 4Eh
		db	 01h,0B0h, 00h
		db	40h
		db	12 dup (0)
		db	 0Fh,0FEh
		db	8, '~', 8, '~', 8, '~', 8, '~', 8
		db	'~', 8, '~'
		db	 0Fh,0FEh, 00h
		db	12 dup (0)
		db	40h
loc_82E0:
		add	ds:d_0038_4E0E_e[bx+si],si
		or	ss:d_52C0_7E08_e[bp],di
		or	[bp+8],bh
;*		jle	loc_82F5		;*Jump if < or =
		db	 7Eh, 08h		;  Fixup - byte match
;*		jle	loc_82F7		;*Jump if < or =
		db	 7Eh, 08h		;  Fixup - byte match
		jle	loc_82FF		; Jump if < or =
;*		jle	loc_82F4		;*Jump if < or =
		db	 7Eh, 01h		;  Fixup - byte match
;*                         lock	add	[bx+si+0],al
		db	0F0h, 00h, 40h, 00h	;  Fixup - byte match
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 40h, 01h
loc_82FF:
		mov	al,6
		dec	sp
		or	ss:d_52C0_4E0E_e[bp+si],si
		or	ss:d_52C0_7E08_e[bp],di
		or	[bp+8],bh
;*		jle	loc_8317		;*Jump if < or =
		db	 7Eh, 08h		;  Fixup - byte match
;*		jle	loc_8319		;*Jump if < or =
		db	 7Eh, 08h		;  Fixup - byte match
;*		jle	loc_8319		;*Jump if < or =
		db	 7Eh, 06h		;  Fixup - byte match
;*		jl	loc_8316		;*Jump if <
		db	 7Ch, 01h		;  Fixup - byte match
;*                         lock	add	[bx+si+0],al
		db	0F0h, 00h, 40h, 00h	;  Fixup - byte match
		db	 00h, 00h, 40h, 00h,0A0h, 03h
		db	 58h, 04h,0A4h, 0Bh, 5Ah, 0Ch
		db	0A6h, 0Bh, 5Eh, 08h,0BEh
		db	8, '~', 8, '~', 8, '~', 8, '~'
		db	 04h, 7Ch, 03h, 78h, 00h,0E0h
		db	 00h

locloop_8339:
		inc	ax
		add	ds:d_0038_5001_e[bx+si],ah
		add	ch,ds:d_0038_5405_e[bx+si]
		or	ch,ss:d_52C0_560D_e[bp+si]
		or	ch,ss:d_52C0_5E09_e[bp]
		or	ss:d_52C0_7E08_e[bp],bh
		add	al,7Ch			; '|'
		add	bh,[bx+si+1]
		jo	$+2			; delay for I/O
		loopnz	locloop_8357		; Loop if zf=0, cx>0


locloop_8357:
		inc	ax
		add	[bx+si],al
;*		add	[bx+si+0],al
		db	 00h, 40h, 00h		;  Fixup - byte match
		db	0A0h, 01h, 50h, 02h,0A8h, 05h
		db	 54h, 0Ah,0AAh, 05h, 55h, 05h
		db	 55h, 0Ah,0AAh, 05h, 54h, 02h
		db	0A8h, 01h, 50h, 00h,0A0h, 00h
		db	40h
		db	7 dup (0)
		db	0E0h, 01h, 10h, 02h, 28h, 04h
		db	 54h, 08h,0AAh, 09h, 56h, 0Ah
		db	0AAh, 0Dh, 56h, 06h,0ACh, 03h
		db	 58h, 01h,0B0h, 00h,0E0h, 00h
		db	9 dup (0)
		db	 01h,0F0h, 02h, 18h, 04h, 2Ch
		db	 04h, 14h, 08h,0AEh, 09h, 56h
		db	 08h,0AEh, 05h, 5Ch, 06h,0BCh
		db	 03h,0F8h, 01h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 10h, 00h, 00h
		db	 38h, 00h, 00h, 5Ch, 00h, 00h
		db	 9Eh, 00h, 01h, 1Fh, 00h, 02h
		db	 1Fh, 80h, 02h, 2Fh, 80h, 02h
		db	 57h, 80h, 02h,0ABh, 80h, 03h
		db	 55h, 80h, 02h,0AAh, 80h, 01h
		db	 55h, 00h, 00h,0AAh, 00h, 00h
		db	 54h, 00h, 00h, 28h, 00h, 00h
		db	 10h, 00h, 00h, 10h, 00h, 00h
		db	 38h, 00h, 00h,0DEh, 00h, 01h
		db	 1Fh, 00h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 2Fh, 80h, 02h
		db	0D7h, 80h, 03h, 29h, 80h, 02h
		db	0D6h, 80h, 01h, 29h, 00h, 00h
		db	0D6h, 00h, 00h, 28h, 00h, 00h
		db	 10h
		db	8 dup (0)
		db	 10h, 00h, 00h, 7Ch, 00h, 01h
		db	 9Fh, 00h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 6Fh, 80h, 03h, 93h, 80h, 02h
		db	 6Ch, 80h, 01h, 93h, 00h, 00h
		db	 6Ch, 00h, 00h, 10h, 00h, 00h
		db	9 dup (0)
		db	 10h, 00h, 00h, 7Ch, 00h, 03h
		db	 9Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 6Fh, 80h, 03h, 93h, 80h, 00h
		db	 6Ch, 00h, 00h, 10h, 00h
		db	18 dup (0)
		db	 03h,0FFh, 80h, 02h, 1Fh, 80h
		db	 02h, 1Fh, 80h, 02h, 1Fh, 80h
		db	 02h, 1Fh, 80h, 02h, 1Fh, 80h
		db	 02h, 1Fh, 80h, 03h,0FFh, 80h
		db	 00h, 00h
		db	17 dup (0)
		db	 10h, 00h, 00h, 6Ch, 00h, 03h
		db	 93h, 80h, 02h, 6Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 03h, 9Fh, 80h, 00h
		db	 7Ch, 00h, 00h, 10h, 00h
		db	10 dup (0)
		db	 10h, 00h, 00h, 6Ch, 00h, 01h
		db	 93h, 00h, 02h, 6Ch, 80h, 03h
		db	 93h, 80h, 02h, 6Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 01h, 9Fh, 00h, 00h
		db	 7Ch, 00h, 00h, 10h, 00h, 00h
		db	 00h, 00h, 00h, 10h, 00h, 00h
		db	 28h, 00h, 00h,0D6h, 00h, 01h
		db	 29h, 00h, 02h,0D6h, 80h, 03h
		db	 29h, 80h, 02h,0D7h, 80h, 02h
		db	 2Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 02h, 1Fh, 80h, 02h
		db	 1Fh, 80h, 01h, 1Fh, 00h, 00h
		db	0DEh, 00h, 00h, 38h, 00h, 00h
		db	 10h, 00h, 00h, 28h, 00h, 00h
		db	 54h, 00h, 00h,0AAh, 00h, 01h
		db	 55h, 00h, 02h,0AAh, 80h, 03h
		db	 55h, 80h, 02h,0ABh, 80h, 02h
		db	 57h, 80h, 02h, 2Fh, 80h, 02h
		db	 1Fh, 80h, 01h, 1Fh, 00h, 00h
		db	 9Eh, 00h, 00h, 5Ch, 00h, 00h
		db	 38h, 00h, 00h, 10h, 00h, 00h
		db	 00h, 00h, 00h, 10h, 00h, 00h
		db	 28h, 00h, 00h, 54h, 00h, 00h
		db	0AAh, 00h, 01h, 55h, 00h, 02h
		db	0AAh, 80h, 01h, 55h, 40h, 01h
		db	 55h, 40h, 02h,0AAh, 80h, 01h
		db	 55h, 00h, 00h,0AAh, 00h, 00h
		db	 54h, 00h, 00h, 28h, 00h, 00h
		db	 10h
		db	11 dup (0)
		db	 38h, 00h, 00h, 44h, 00h, 00h
		db	 8Ah, 00h, 01h, 15h, 00h, 02h
		db	 2Ah, 80h, 02h, 55h, 80h, 02h
		db	0AAh, 80h, 03h, 55h, 80h, 01h
		db	0ABh, 00h, 00h,0D6h, 00h, 00h
		db	 6Ch, 00h, 00h, 38h, 00h
		db	16 dup (0)
		db	 7Ch, 00h, 00h, 86h, 00h, 01h
		db	 0Bh, 00h, 01h, 05h, 00h, 02h
		db	 2Bh, 80h, 02h, 55h, 80h, 02h
		db	 2Bh, 80h, 01h, 57h, 00h, 01h
		db	0AFh, 00h, 00h,0FEh, 00h, 00h
		db	 7Ch, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 60h, 86h, 76h, 86h
		db	 8Ch, 86h,0A2h, 86h, 8Ch, 86h
		db	 76h, 86h, 60h, 86h,0B8h, 86h
		db	0CEh, 86h,0E4h, 86h,0FAh, 86h
		db	0E4h, 86h,0CEh, 86h, 10h, 87h
		db	 26h, 87h, 3Ch, 87h, 52h, 87h
		db	 3Ch, 87h, 26h, 87h, 10h, 87h
		db	 68h, 87h, 7Eh, 87h, 94h, 87h
		db	0AAh, 87h, 94h, 87h, 7Eh, 87h
		db	0C0h, 87h,0D6h, 87h,0ECh, 87h
		db	 02h, 88h,0ECh, 87h,0D6h, 87h
		db	0C0h, 87h, 18h, 88h, 2Eh, 88h
		db	 44h, 88h, 5Ah, 88h, 44h, 88h
		db	 2Eh, 88h, 70h, 88h, 91h, 88h
		db	0B2h, 88h,0D3h, 88h,0B2h, 88h
		db	 91h, 88h, 91h, 88h,0F4h, 88h
		db	 15h, 89h, 36h, 89h, 57h, 89h
		db	 36h, 89h, 15h, 89h, 02h, 00h
		db	 05h, 00h, 05h, 00h, 0Ah, 80h
		db	 0Ah, 80h, 17h, 40h, 17h, 40h
		db	 2Fh,0A0h, 2Fh,0A0h, 40h, 10h
		db	 7Fh,0F0h, 00h, 30h, 00h,0D0h
		db	 03h, 10h, 0Ch,0D0h, 33h,0D0h
		db	 4Fh,0D0h, 73h,0D0h, 3Ch,0D0h
		db	 1Fh, 10h, 0Fh,0D0h, 07h,0F0h
		db	 30h, 00h, 3Ch, 00h, 33h, 00h
		db	 38h, 80h, 2Bh, 60h, 35h, 90h
		db	 2Dh,0D0h, 36h,0A0h, 3Ah, 40h
		db	 0Dh, 80h, 03h, 00h, 01h, 00h
		db	 03h, 80h, 03h, 80h, 05h,0C0h
		db	 05h,0C0h, 09h,0E0h, 09h,0E0h
		db	 11h,0F0h, 19h,0F0h, 07h,0C0h
		db	 01h, 00h, 04h, 00h, 0Ah, 00h
		db	 0Ah, 00h, 15h, 00h, 15h, 00h
		db	 2Eh, 80h, 2Eh, 80h, 5Fh, 40h
		db	 5Fh, 40h, 80h, 20h,0FFh,0E0h
		db	0C0h, 00h,0B0h, 00h, 8Ch, 00h
		db	0B3h, 00h,0BCh,0C0h,0BFh, 30h
		db	0BCh,0E0h,0B3h,0C0h, 8Fh, 80h
		db	0BFh, 00h,0FEh, 00h, 00h, 60h
		db	 01h,0E0h, 06h, 60h, 18h,0E0h
		db	 66h,0E0h, 9Dh,0E0h, 5Dh,0E0h
		db	 2Bh,0E0h, 13h,0E0h, 0Fh, 80h
		db	 06h, 00h, 04h, 00h, 0Eh, 00h
		db	 0Eh, 00h, 17h, 00h, 17h, 00h
		db	 27h, 80h, 27h, 80h, 47h,0C0h
		db	 67h,0C0h, 1Fh, 00h, 04h, 00h
		db	 00h, 80h, 01h, 40h, 01h, 40h
		db	 02h,0A0h, 02h,0A0h, 05h,0D0h
		db	 05h,0D0h, 0Bh,0E8h, 0Bh,0E8h
		db	 10h, 04h, 1Fh,0FCh, 00h, 0Ch
		db	 00h, 34h, 00h,0C4h, 03h, 34h
		db	 0Ch,0F4h, 13h,0F4h, 1Ch,0F4h
		db	 0Fh, 34h, 07h,0C4h, 03h,0F4h
		db	 01h,0FCh, 0Ch, 00h, 0Fh, 00h
		db	 0Ch,0C0h, 0Eh, 20h, 0Ah,0D8h
		db	 0Dh, 64h, 0Bh, 74h, 0Dh,0A8h
		db	 0Eh, 90h, 03h, 60h, 00h,0C0h
		db	 00h, 40h, 00h,0E0h, 00h,0E0h
		db	 01h, 70h, 01h, 70h, 02h, 78h
		db	 02h
loc_875F:
		js	loc_8765		; Jump if sign=1
loc_8761:
		jl	loc_8769		; Jump if <
;*		jl	loc_8766		;*Jump if <
		db	 7Ch, 01h		;  Fixup - byte match
loc_8765:
                           lock	add	[bx+si+1],al
loc_8769:
		add	[bp+si],al
		add	byte ptr [bp+si],80h
		add	ax,540h
		inc	ax
		or	sp,ds:d_0038_A00B_e[bx+si]
		pop	ss
		rcl	byte ptr [bx],1		; Rotate thru carry
		shl	byte ptr [bx+si],1	; Shift w/zeros fill
		or	[bx],bh
		clc				; Clear carry flag
		xor	[bx+si],al
		sub	al,0
		and	ax,[bx+si]
		sub	al,0C0h
		das				; Decimal adjust
		xor	[bx],ch
		int	3			; Debug breakpoint
		das				; Decimal adjust
		cmp	[si],ch
                           lock	and	sp,ax
		das				; Decimal adjust
		sar	byte ptr [bx],80h	; Shift w/sign fill
		add	[bx+si],bl
		add	[bx+si+1],bh
		cbw				; Convrt byte to word
		push	es
		cmp	[bx+di],bl
		mov	ax,7827h
		pop	ss
;*		js	loc_87AD		;*Jump if sign=1
		db	 78h, 0Ah		;  Fixup - byte match
		clc				; Clear carry flag
		add	al,0F8h
		add	sp,ax

;		add	word ptr ds:d_0038_0000_e+1[bx+si],ax
		db	1, 80h, 1, 0

		add	ax,ds:d_0038_8003_e[bx+si]
		add	ax,5C0h
		ror	byte ptr [bx+di],0E0h	; Rotate
;*		or	ax,sp
		db	 09h,0E0h		;  Fixup - byte match
;*		adc	ax,si
		db	 11h,0F0h		;  Fixup - byte match
;*		sbb	ax,si
		db	 19h,0F0h		;  Fixup - byte match
		pop	es
		rol	byte ptr [bx+di],0	; Rotate
		add	[bx+si],ah
;*		add	[bx+si+0],dl
		db	 00h, 50h, 00h		;  Fixup - byte match
		db	 50h, 00h,0A8h, 00h,0A8h, 01h
		db	 74h, 01h, 74h, 02h,0FAh, 02h
		db	0FAh, 04h, 01h, 07h,0FFh, 00h
		db	 03h, 00h, 0Dh, 00h, 31h, 00h
		db	0CDh, 03h, 3Dh, 04h,0FDh, 07h
		db	 3Dh, 03h,0CDh, 01h,0F1h, 00h
		db	0FDh, 00h, 7Fh, 03h, 00h, 03h
		db	0C0h, 03h, 30h, 03h, 88h, 02h
		db	0B6h, 03h, 59h, 02h,0DDh, 03h
		db	 6Ah, 03h,0A4h, 00h
data_87FF	dw	0D8h, 30h
data_8803	dw	10h, 38h
data_8807	dw	38h, 5Ch
data_880B	dw	5Ch, 9Eh
data_880F	dw	19Eh, 11Fh
data_8813	dw	9Fh, 7Ch
data_8817	dw	10h, 40h
data_881B	dw	0A0h, 1A0h
data_881F	dw	150h, 250h
data_8823	dw	2E8h, 5E8h
		db	0F4h, 05h,0F4h, 08h, 02h, 0Fh
		db	0FEh, 0Ch, 00h, 0Bh, 00h, 08h
		db	0C0h, 0Bh, 30h, 0Bh,0CCh, 0Bh
		db	0F3h, 0Bh,0CEh, 0Bh, 3Ch, 08h
		db	0F8h, 0Bh,0F0h, 0Fh,0E0h, 00h
		db	 06h, 00h, 1Eh, 00h, 66h, 01h
		db	 8Eh, 06h, 6Eh, 09h,0DEh, 05h
		db	0DEh, 02h,0BEh, 01h, 3Eh, 00h
		db	0F8h, 00h, 60h, 00h, 40h, 00h
		db	0E0h, 00h,0E0h, 01h, 70h, 01h
		db	 70h, 02h, 78h, 02h, 78h, 04h
		db	 7Ch, 06h, 7Ch, 01h
loc_886D:
;*                         lock	add	[bx+si+0],al
		db	0F0h, 00h, 40h, 00h	;  Fixup - byte match
loc_8871:
		or	[bx+si],al
		add	[si],dl
		add	[bx+si],al
		adc	al,0
		add	[bp+si],ch
		add	[bx+si],al
		sub	al,[bx+si]
;*		add	[di+0],bl
		db	 00h, 5Dh, 00h		;  Fixup - byte match
		db	 00h, 5Dh, 00h, 00h,0BEh, 80h
		db	 00h,0BEh, 80h, 01h, 00h, 40h
		db	 01h,0FFh,0C0h, 00h, 00h,0C0h
		db	 00h, 03h, 40h, 00h, 0Ch, 40h
		db	 00h, 33h, 40h, 00h,0CFh, 40h
		db	 01h, 3Fh, 40h, 01h,0CFh, 40h
		db	 00h,0F3h, 40h, 00h, 7Ch, 40h
		db	 00h, 3Fh, 40h, 00h, 1Fh,0C0h
		db	 00h,0C0h, 00h, 00h,0F0h, 00h
		db	 00h,0CCh, 00h, 00h,0E2h, 00h
		db	 00h,0ADh, 80h, 00h,0D6h, 40h
		db	 00h,0B7h, 40h, 00h,0DAh, 80h
		db	 00h,0E9h, 00h, 00h, 36h, 00h
		db	 00h, 0Ch, 00h, 00h, 04h, 00h
		db	 00h, 0Eh, 00h, 00h, 0Eh, 00h
		db	 00h, 17h, 00h, 00h, 17h, 00h
		db	 00h, 27h, 80h, 00h, 27h, 80h
		db	 00h, 47h,0C0h, 00h, 67h,0C0h
		db	 00h, 1Fh, 00h, 00h, 04h, 00h
		db	 00h, 10h, 00h, 00h, 28h, 00h
		db	 00h, 28h, 00h, 00h, 54h, 00h
		db	 00h, 54h, 00h, 00h,0BAh, 00h
		db	 00h,0BAh, 00h, 01h, 7Dh, 00h
		db	 01h, 7Dh, 00h, 02h, 00h, 80h
		db	 03h,0FFh, 80h, 03h, 00h, 00h
		db	 02h,0C0h, 00h, 02h, 30h, 00h
		db	 02h,0CCh, 00h, 02h,0F3h, 00h
		db	 02h,0FCh,0C0h, 02h,0F3h, 80h
		db	 02h,0CFh, 00h, 02h, 3Eh, 00h
		db	 02h,0FCh, 00h, 03h,0F8h, 00h
		db	 00h, 01h

locloop_8938:
		add	byte ptr [bx+si],7
		add	byte ptr [bx+si],19h
		add	byte ptr [bx+si],63h	; 'c'
		add	byte ptr [bx+di],9Bh
		add	byte ptr [bp+si],77h	; 'w'
		add	byte ptr [bx+di],77h	; 'w'
		add	byte ptr [bx+si],0AFh
		add	byte ptr [bx+si],4Fh	; 'O'
		add	byte ptr [bx+si],3Eh	; '>'
		add	[bx+si],al
		sbb	[bx+si],al
		add	[bx+si],dl
		add	[bx+si],al
		cmp	[bx+si],al
		add	[bx+si],bh
		add	[bx+si],al
		pop	sp
		add	[bx+si],al
		pop	sp
		add	[bx+si],al
		sahf				; Store ah into flags
		add	[bx+si],al
		sahf				; Store ah into flags
		add	[bx+di],al
		pop	ds
		add	[bx+di],al
		lahf				; Load ah from flags
		add	[bx+si],al
		jl	$+2			; delay for I/O
		add	[bx+si],dl
;*		add	al,al
		db	 00h,0C0h		;  Fixup - byte match
;*		mov	ax,sp
		db	 89h,0E0h		;  Fixup - byte match
		mov	[bx+si],ax
		mov	ah,[bx+si]
		mov	al,[bx+si-76h]
		pusha				; Save all regs
		mov	al,ds:d_7EC0_A08A_e[bx+si]
		mov	al,al
		mov	ah,al
		mov	al,[bx+si]
		mov	sp,[bx+si]
		mov	ax,[bx+si-75h]
		pusha				; Save all regs
		mov	ax,ds:d_7EC0_A08B_e[bx+si]
		mov	ax,ax
		mov	sp,ax
		mov	ax,[bx+si]
		db	 8Ch, 20h, 8Ch, 40h, 8Ch, 60h
		db	 8Ch, 80h, 8Ch,0A0h, 8Ch,0C0h
		db	 8Ch,0E0h, 8Ch, 00h, 8Dh, 20h
		db	 8Dh, 50h, 8Dh, 80h, 8Dh,0B0h
		db	 8Dh,0E0h, 8Dh, 10h, 8Eh, 40h
		db	 8Eh, 70h, 8Eh,0A0h, 8Eh, 00h
		db	 00h, 00h, 00h, 0Ch, 00h, 1Eh
		db	 00h, 1Eh, 00h, 1Eh, 00h, 1Eh
		db	 00h, 1Eh, 00h, 1Eh, 00h, 1Eh
		db	 00h, 1Eh, 00h, 1Eh, 00h, 1Eh
		db	 00h
		db	0Ch
		db	7 dup (0)
		db	 10h, 00h, 1Ch, 00h, 1Eh, 00h
		db	 1Eh, 00h, 1Eh, 00h, 1Eh, 00h
		db	 1Eh, 00h, 1Eh, 00h, 1Eh, 00h
		db	 1Eh, 00h, 1Eh, 00h, 1Eh, 00h
		db	 0Eh, 00h, 02h, 00h, 00h, 00h
		db	 00h, 00h, 30h, 00h, 3Ch, 00h
		db	 3Fh, 00h, 3Fh, 00h, 3Fh, 00h
		db	 3Fh, 00h, 3Fh, 00h, 3Fh, 00h
		db	 3Fh, 00h, 3Fh, 00h, 3Fh, 00h
		db	 3Fh, 00h, 0Fh, 00h, 03h, 00h
		db	 00h, 00h, 40h, 00h, 70h, 00h
		db	 7Ch, 00h, 7Fh, 00h, 7Fh, 80h
		db	 7Fh, 80h, 7Fh, 80h, 7Fh, 80h
		db	 7Fh, 80h, 7Fh, 80h, 7Fh, 80h
		db	 7Fh, 80h, 3Fh, 80h, 0Fh, 80h
		db	 03h, 80h, 00h, 80h, 00h, 00h
		db	 00h, 00h, 30h, 00h, 3Ch, 00h
		db	 3Fh, 00h, 3Fh, 80h, 3Fh, 80h
		db	 7Fh, 80h, 7Fh, 80h, 7Fh, 80h
		db	 7Fh, 00h, 3Fh, 00h, 0Fh, 00h
		db	 03h
		db	11 dup (0)
		db	 10h, 00h, 3Ch, 00h, 3Fh, 00h
		db	 3Fh, 80h, 7Fh,0C0h, 7Fh, 80h
		db	 7Fh, 80h, 3Fh, 00h, 0Fh, 00h
		db	 02h
		db	15 dup (0)
		db	 30h, 00h, 7Ch, 00h, 7Fh, 00h
		db	0FFh, 80h, 7Fh,0C0h, 3Fh, 80h
		db	 0Fh, 80h, 03h, 00h
		db	18 dup (0)
		db	 70h, 00h, 7Ch, 00h, 7Fh, 00h
		db	 3Fh, 80h, 0Fh, 80h, 03h, 80h
		db	 01h, 00h
		db	14 dup (0)
		db	 30h, 00h, 38h, 00h, 38h, 00h
		db	 1Ch, 00h, 1Ch, 00h, 0Eh, 00h
		db	 0Eh, 00h, 07h, 00h, 07h, 00h
		db	 03h
		db	11 dup (0)
		db	 03h, 00h, 07h, 80h, 07h, 80h
		db	 07h, 80h, 07h, 80h, 07h, 80h
		db	 07h, 80h, 07h, 80h, 07h, 80h
		db	 07h, 80h, 07h, 80h, 03h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 00h, 07h, 00h, 07h, 80h
		db	 07h, 80h, 07h, 80h, 07h, 80h
		db	 07h, 80h, 07h, 80h, 07h, 80h
		db	 07h, 80h, 07h, 80h, 07h, 80h
		db	 03h, 80h, 00h, 80h, 00h, 00h
		db	 00h, 00h, 0Ch, 00h, 0Fh, 00h
		db	 0Fh,0C0h, 0Fh,0C0h, 0Fh,0C0h
		db	 0Fh,0C0h, 0Fh,0C0h, 0Fh,0C0h
		db	 0Fh,0C0h, 0Fh,0C0h, 0Fh,0C0h
		db	 0Fh,0C0h, 03h,0C0h, 00h,0C0h
		db	 00h, 00h, 10h, 00h, 1Ch, 00h
		db	 1Fh, 00h, 1Fh,0C0h, 1Fh,0E0h
		db	 1Fh,0E0h, 1Fh,0E0h, 1Fh,0E0h
		db	 1Fh,0E0h, 1Fh,0E0h, 1Fh,0E0h
		db	 1Fh,0E0h, 0Fh,0E0h, 03h,0E0h
		db	 00h,0E0h, 00h, 20h, 00h, 00h
		db	 00h, 00h, 0Ch, 00h, 0Fh, 00h
		db	 0Fh,0C0h, 0Fh,0E0h, 0Fh,0E0h
		db	 1Fh,0E0h, 1Fh,0E0h, 1Fh,0E0h
		db	 1Fh,0C0h, 0Fh,0C0h, 03h,0C0h
		db	 00h,0C0h
		db	10 dup (0)
		db	 04h, 00h, 0Fh, 00h, 0Fh,0C0h
		db	 0Fh,0E0h, 1Fh,0F0h

locloop_8B90:
		pop	ds
		loopnz	$+21h			; Loop if zf=0, cx>0

;*		loopnz	locloop_8BA4		;*Loop if zf=0, cx>0

		db	0E0h, 0Fh		;  Fixup - byte match
		rol	byte ptr [bp+di],0C0h	; Rotate
;*		add	ds:d_FFFF_0000_e[bx+si],al
		db	 00h, 80h, 00h, 00h	;  Fixup - byte match
		db	8 dup (0)
		db	 00h, 00h, 00h, 00h, 0Ch, 00h
		db	 1Fh, 00h, 1Fh,0C0h, 3Fh,0E0h
		db	 1Fh,0F0h, 0Fh,0E0h, 03h,0E0h
		db	 00h,0C0h, 00h, 00h
		db	16 dup (0)
		db	 1Ch, 00h, 1Fh, 00h, 1Fh,0C0h
		db	 0Fh,0E0h, 03h,0E0h, 00h,0E0h
		db	 00h, 40h, 00h
		db	13 dup (0)
		db	 0Ch, 00h, 0Eh, 00h, 0Eh, 00h
		db	 07h, 00h, 07h, 00h, 03h, 80h
		db	 03h, 80h, 01h,0C0h, 01h,0C0h
		db	 00h,0C0h
		db	11 dup (0)
		db	0C0h, 01h,0E0h, 01h,0E0h, 01h
		db	0E0h, 01h,0E0h, 01h,0E0h, 01h
		db	0E0h, 01h,0E0h, 01h,0E0h, 01h
		db	0E0h, 01h,0E0h, 00h,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 01h
		db	 00h, 01h,0C0h, 01h,0E0h, 01h
		db	0E0h, 01h,0E0h, 01h,0E0h, 01h
		db	0E0h, 01h,0E0h, 01h,0E0h, 01h
		db	0E0h, 01h,0E0h, 01h,0E0h, 00h
		db	0E0h, 00h, 20h, 00h, 00h, 00h
		db	 00h, 03h, 00h, 03h,0C0h, 03h
		db	0F0h, 03h,0F0h, 03h,0F0h, 03h
		db	0F0h, 03h,0F0h, 03h,0F0h, 03h
		db	0F0h, 03h,0F0h, 03h,0F0h, 03h
		db	0F0h, 00h,0F0h, 00h, 30h, 00h
		db	 00h, 04h, 00h, 07h, 00h, 07h
		db	0C0h, 07h,0F0h, 07h,0F8h, 07h
		db	0F8h, 07h,0F8h, 07h,0F8h, 07h
		db	0F8h, 07h,0F8h, 07h,0F8h, 07h
		db	0F8h, 03h,0F8h, 00h,0F8h, 00h
		db	 38h, 00h, 08h, 00h, 00h, 00h
		db	 00h, 03h, 00h, 03h,0C0h, 03h
		db	0F0h, 03h,0F8h, 03h,0F8h, 07h
		db	0F8h, 07h,0F8h, 07h,0F8h, 07h
		db	0F0h, 03h,0F0h, 00h,0F0h, 00h
		db	30h
		db	10 dup (0)
		db	 01h, 00h, 03h,0C0h, 03h,0F0h
		db	 03h,0F8h, 07h,0FCh, 07h,0F8h
		db	 07h,0F8h, 03h,0F0h, 00h,0F0h
		db	 00h
		db	20h
		db	14 dup (0)
		db	 03h, 00h, 07h,0C0h, 07h,0F0h
		db	 0Fh,0F8h, 07h,0FCh, 03h,0F8h
		db	 00h,0F8h, 00h
		db	30h
		db	18 dup (0)
		db	 07h, 00h, 07h,0C0h, 07h,0F0h
		db	 03h,0F8h, 00h,0F8h, 00h, 38h
		db	 00h, 10h
		db	14 dup (0)
		db	 03h, 00h, 03h, 80h, 03h, 80h
		db	 01h,0C0h, 01h,0C0h, 00h,0E0h
		db	 00h,0E0h, 00h, 70h, 00h, 70h
		db	 00h, 30h, 00h
		db	12 dup (0)
		db	 30h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h
		db	30h
		db	11 dup (0)
		db	 40h, 00h, 00h, 70h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 78h, 00h, 00h, 78h, 00h, 00h
		db	 38h, 00h, 00h, 08h, 00h
		db	7 dup (0)
		db	0C0h, 00h, 00h,0F0h, 00h, 00h
		db	0FCh, 00h, 00h,0FCh, 00h, 00h
		db	0FCh, 00h, 00h,0FCh, 00h, 00h
		db	0FCh, 00h, 00h,0FCh, 00h, 00h
		db	0FCh, 00h, 00h,0FCh, 00h, 00h
		db	0FCh, 00h, 00h,0FCh, 00h, 00h
		db	 3Ch, 00h, 00h, 0Ch, 00h, 00h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	0C0h, 00h, 01h,0F0h, 00h, 01h
		db	0FCh, 00h, 01h,0FEh, 00h, 01h
		db	0FEh, 00h, 01h,0FEh, 00h, 01h
		db	0FEh, 00h, 01h,0FEh, 00h, 01h
		db	0FEh, 00h, 01h,0FEh, 00h, 01h
		db	0FEh, 00h, 00h,0FEh, 00h, 00h
		db	 3Eh, 00h, 00h, 0Eh, 00h, 00h
		db	 02h, 00h
		db	7 dup (0)
		db	0C0h, 00h, 00h,0F0h, 00h, 00h
		db	0FCh, 00h, 00h,0FEh, 00h, 00h
		db	0FEh, 00h, 01h,0FEh, 00h, 01h
		db	0FEh, 00h, 01h,0FEh, 00h, 01h
		db	0FCh, 00h, 00h,0FCh, 00h, 00h
		db	 3Ch, 00h, 00h
		db	0Ch
		db	17 dup (0)
		db	 40h, 00h, 00h,0F0h, 00h, 00h
		db	0FCh, 00h, 00h,0FEh, 00h, 01h
		db	0FFh, 00h, 01h,0FEh, 00h, 01h
		db	0FEh, 00h, 00h,0FCh, 00h, 00h
		db	 3Ch, 00h, 00h
		db	8
		db	23 dup (0)
		db	0C0h, 00h, 01h,0F0h, 00h, 01h
		db	0FCh, 00h, 03h,0FEh, 00h, 01h
		db	0FFh, 00h, 00h,0FEh, 00h, 00h
		db	 3Eh, 00h, 00h, 0Ch, 00h
		db	27 dup (0)
		db	 01h,0C0h, 00h, 01h,0F0h, 00h
		db	 01h,0FCh, 00h, 00h,0FEh, 00h
		db	 00h, 3Eh, 00h, 00h, 0Eh, 00h
		db	 00h, 04h, 00h
		db	22 dup (0)
		db	0C0h, 00h, 00h,0E0h, 00h, 00h
		db	0E0h, 00h, 00h, 70h, 00h, 00h
		db	 70h, 00h, 00h, 38h, 00h, 00h
		db	 38h, 00h, 00h, 1Ch, 00h, 00h
		db	 1Ch, 00h, 00h
		db	0Ch
		db	12 dup (0)
		db	0FCh, 00h, 00h, 3Ch, 00h, 00h
		db	 08h
		db	23 dup (0)
		db	0C0h, 00h, 01h,0F0h, 00h, 01h
		db	0FCh, 00h, 03h,0FEh, 00h, 01h
		db	0FFh, 00h, 00h,0FEh, 00h, 00h
		db	 3Eh, 00h, 00h, 0Ch, 00h
		db	27 dup (0)
		db	 01h,0C0h, 00h, 01h,0F0h, 00h
		db	 01h,0FCh, 00h, 00h,0FEh, 00h
		db	 00h, 3Eh, 00h, 00h, 0Eh, 00h
		db	 00h, 04h, 00h
		db	22 dup (0)
		db	0C0h, 00h, 00h,0E0h, 00h, 00h
		db	0E0h, 00h, 00h, 70h, 00h, 00h
		db	 70h, 00h, 00h, 38h, 00h, 00h
		db	 38h, 00h, 00h, 1Ch, 00h, 00h
		db	 1Ch, 00h, 00h
		db	0Ch
		db	261 dup (0)
		db	 32h, 14h,0D0h, 00h, 06h, 00h
		db	0D0h, 00h,0B0h, 3Eh,0D3h, 3Bh
		db	 80h, 3Fh, 32h, 14h, 14h, 00h
		db	 06h, 00h, 14h, 00h,0B0h, 3Eh
		db	 82h, 09h,0C4h, 3Eh,0F8h, 3Ch
		db	 2Ah, 15h, 2Ah, 15h, 9Bh, 00h
		db	 1Ch, 15h, 02h,0F2h, 2Ah, 15h
		db	 32h, 14h, 05h, 3Eh, 06h, 00h
		db	 14h, 00h,0B0h, 3Eh, 82h, 09h
		db	0C4h, 3Eh, 14h, 3Dh, 2Ah, 15h
		db	 2Ah, 15h, 10h, 00h, 1Ch, 15h
		db	 02h,0F2h, 6Bh, 00h, 1Eh, 3Dh
		db	 35h, 03h,0DAh, 14h, 06h, 00h
		db	 14h, 00h, 26h, 3Dh,0D4h, 00h
		db	 11h, 11h, 5Eh, 0Fh, 6Ch, 3Eh
		db	 6Ch, 3Eh, 11h, 07h, 00h, 00h
		db	 01h, 01h, 01h, 00h, 00h, 02h
		db	0EDh, 08h, 00h, 00h, 0Eh
		db	'D:ARKANOID.EXE='
		db	0DEh, 00h, 6Fh, 00h, 2Ah, 15h
		db	0DEh, 00h, 5Ch, 3Eh, 25h, 01h
		db	 37h, 12h,0F1h, 05h, 5Ch, 3Dh
		db	0C4h, 8Ch, 04h
		db	'CODEpicICSEEENKNKN'
		db	35 dup (0)
		db	0Ch, 'ARKANOI2'
		db	 14h, 00h, 04h, 06h, 00h, 00h
		db	 04h,0B0h, 3Eh, 08h, 3Eh, 32h
		db	 14h, 00h, 04h, 06h, 00h, 00h
		db	 04h,0B0h, 3Eh, 1Ch, 3Eh, 1Eh
		db	 3Eh,0C2h, 3Dh, 2Ah, 15h, 2Ah
		db	 15h, 9Bh, 00h, 1Ch, 15h, 02h
		db	0F2h, 2Ah, 15h,0D4h, 3Dh, 95h
		db	 03h,0DAh, 14h, 06h, 00h, 2Ah
		db	 15h,0B0h, 3Eh, 00h, 04h, 00h
		db	 00h, 00h, 00h,0EEh, 3Dh, 86h
		db	 05h, 11h, 11h, 00h, 04h,0B0h
		db	 3Eh, 2Ah, 15h, 5Eh, 0Fh, 2Ah
		db	 15h, 87h, 01h, 05h,0FFh, 0Dh
		db	 00h,0F8h, 3Dh,0CDh, 00h,0FFh
		db	 00h, 05h, 00h, 04h, 00h, 00h
		db	0FFh, 0Dh, 00h, 06h, 3Eh, 4Bh
		db	 02h, 47h,0FFh, 67h, 00h, 24h
		db	 3Eh, 2Ah, 15h,0DAh, 06h, 2Dh
		db	 14h,0A0h, 96h, 2Ah, 16h, 02h
		db	 00h,0D0h, 3Fh, 00h, 00h, 2Ah
		db	 15h, 87h, 01h, 11h, 11h, 2Ah
		db	 15h, 87h, 01h, 11h, 11h, 2Ah
		db	 15h, 3Ah, 3Eh, 05h, 01h, 11h
		db	 11h, 29h,0EDh, 00h,0F0h, 82h
		db	0F2h, 2Ah, 15h,0B0h, 3Eh, 06h
		db	 00h, 32h, 14h, 32h, 14h,0E9h
		db	 01h, 05h, 00h,0E9h, 01h,0ECh
		db	 0Bh, 82h, 09h,0BCh, 03h, 50h
		db	 3Eh, 2Ah, 15h, 2Ah, 15h, 9Bh
		db	 00h, 1Ch, 15h, 02h,0F2h, 2Ah
		db	 15h, 32h, 14h, 05h, 3Eh, 05h
		db	 00h,0E9h, 01h,0ECh, 0Bh, 82h
		db	 09h,0BCh, 03h, 6Ch, 3Eh, 2Ah
		db	 15h, 2Ah, 15h, 10h, 00h, 1Ch
		db	 15h, 06h,0F2h, 6Bh, 00h, 76h
		db	 3Eh, 35h, 03h,0DAh, 14h, 0Ch
		db	 3Eh, 2Fh, 01h, 12h, 01h, 00h
		db	 00h, 82h, 09h,0BCh, 03h, 8Ah
		db	 3Eh, 2Ah, 15h,0D3h, 0Bh, 10h
		db	 00h, 69h, 0Eh, 02h,0F2h, 92h
		db	 3Eh, 17h, 00h, 6Fh, 11h, 00h
		db	 00h,0A4h, 3Eh,0D6h, 06h,0D4h
		db	 0Fh, 4Ch, 0Eh,0A6h, 3Eh,0BEh
		db	 00h,0C9h, 11h,0FFh, 05h, 00h
		db	 00h,0AAh, 3Eh,0A5h, 02h,0C9h
		db	 11h,0B0h, 3Eh, 44h, 00h, 27h
		db	 14h, 4Dh, 5Ah,0D0h, 00h, 49h
		db	 00h, 00h, 00h, 20h, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 32h, 50h, 00h, 01h, 00h
		db	 00h, 20h, 00h, 00h, 00h, 2Dh
		db	 14h, 00h
		db	737 dup (0)
		db	 8Ch,0C8h, 8Eh,0D8h, 8Eh,0C0h
		db	 8Eh,0D0h,0BCh,0FEh,0FFh,0FCh
		db	0E8h, 84h, 09h, 89h, 26h, 50h
		db	 02h,0E8h,0CDh, 06h,0E8h,0F5h
		db	 0Fh,0E8h,0DDh, 0Eh,0BEh, 5Bh
		db	 46h,0BBh, 5Fh, 27h,0BFh, 14h
		db	 00h,0B9h, 08h, 00h

locloop_9578:
		push	cx
		mov	al,[bx]
		inc	bx
		mov	cl,8
		mov	ch,14h
		call	sub_9D0D
		pop	cx
		loop	locloop_9578		; Loop if cx > 0

		mov	di,0C8Eh
		mov	word ptr ds:[243h],di
		mov	byte ptr ds:[2D5h],47h	; 'G'
		mov	bx,2768h
;*		call	sub_9F25		;*
		db	0E8h, 8Dh, 09h		;  Fixup - byte match
		mov	byte ptr ds:[2D5h],45h	; 'E'
		mov	di,0F0Eh
		mov	data_0278,0
		mov	bx,2782h
		mov	cx,6

locloop_95AC:
		push	cx
		mov	word ptr ds:[243h],di
		push	di
		cmp	cl,data_02A5
		jne	loc_95BC		; Jump if not equal
		mov	data_0278,di
loc_95BC:
;*		call	sub_9F25		;*
		db	0E8h, 66h, 09h		;  Fixup - byte match
		mov	al,[bx]
		or	al,al			; Zero ?
		jnz	loc_95C7		; Jump if not zero
		mov	al,20h			; ' '
loc_95C7:
;*		call	sub_9F32		;*
		db	0E8h, 68h, 09h		;  Fixup - byte match
		mov	cx,5

locloop_95CD:
		inc	bx
		mov	al,[bx]
;*		call	sub_9F32		;*
		db	0E8h, 5Fh, 09h		;  Fixup - byte match
		loop	locloop_95CD		; Loop if cx > 0

		inc	bx
		pop	di
		add	di,280h
		pop	cx
		loop	locloop_95AC		; Loop if cx > 0

		mov	byte ptr ds:[2D5h],42h	; 'B'
		mov	bx,data_0278
		mov	dx,1019h
		test	data_02A5,0FFh
		jz	loc_95F4		; Jump if zero
		mov	dx,12C2h
loc_95F4:
		mov	word ptr ds:[243h],bx
		mov	data_06E4,dx
		mov	data_027C,6
		mov	data_0FF6,4
loc_9606:
		mov	al,3
		call	sub_9B32
		dec	data_0FF6
		jnz	loc_9606		; Jump if not zero
		mov	byte ptr data_0280,0
		mov	data_0245,sp
		mov	data_0C63,0CDEh
		mov	al,data_0263
		and	al,1Fh
		call	$+0FAFh
		jmp	short loc_962D
		db	0E8h,0A5h, 0Fh
loc_962D:
;*		call	sub_A0B5		;*
		db	0E8h, 85h, 0Ah		;  Fixup - byte match
		dec	data_0262
		jz	$+0Dh			; Jump if zero
		mov	al,data_0262
		call	$+0EDBh
		call	sub_9FB0
		jmp	short $-12h
sub_6F2D	endp

			                        ;* No entry point to code
		mov	di,1786h
		mov	word ptr ds:[243h],di
		mov	byte ptr ds:[2D5h],7
		mov	bx,296h			; ('GAME  OVER')
		add	[bx+si],al
		or	dh,[bx-36h]
		jnp	$-46h			; Jump if not parity
		jle	$-6			; Jump if < or =
		test	di,[bx+si-77h]
		sub	[bx+di],ah
		jnz	$+55h			; Jump if not zero
		db	0DDh, 0Eh,0C3h, 02h, 59h, 02h
		db	 70h, 53h, 73h, 0Ch,0D6h, 02h
		db	 9Eh, 11h, 64h, 02h,0A1h, 02h
		db	 81h, 14h, 4Eh, 24h, 81h, 09h
		db	0CBh, 02h,0D3h, 02h, 47h, 02h
		db	0CAh, 23h,0D6h, 05h,0FFh, 22h
		db	 47h, 02h,0FFh, 22h, 5Ch, 25h
		db	 47h, 02h,0FFh, 22h, 81h, 42h
		db	 2Bh, 44h, 82h, 27h, 81h, 09h
		db	0BDh, 08h, 45h, 02h,0E2h, 06h
		db	0E3h, 07h,0DFh, 06h, 19h, 10h
		db	 26h, 00h, 0Fh, 00h, 3Fh, 00h
		db	 63h, 00h, 25h, 00h, 16h, 00h
		db	 2Ch, 00h, 8Dh, 00h, 95h, 00h
		db	 1Ah, 00h, 09h, 00h, 07h, 00h
		db	 14h, 00h, 01h, 00h, 98h, 03h
		db	2Ah
		db	382 dup (0)
data_983F	dw	0, 0
		db	188 dup (0)
data_98FF	dw	0, 0
		db	559 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_9B32	proc	near
		db	475 dup (0)

;==== External Entry into Subroutine ======================================

sub_9D0D:
		db	325 dup (0)
		db	 78h, 89h
		db	235 dup (0)
data_9F3F	dw	0, 0
		db	109 dup (0)

;==== External Entry into Subroutine ======================================

sub_9FB0:
		db	122 dup (0)
data_A02A	db	0			; Data table (indexed access)
		db	37 dup (0)
		db	0E8h, 00h, 00h
		db	173 dup (0)
sub_9B32	endp


seg_a		ends



		end	start
