
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
; Passes           = 5
; Xref             = OFF

;==========================================================================
;==					                                 ==
;==				PCMAN	                                 ==
;==					                                 ==
;==      Created:   23-Sep-84		                                 ==
;==      Passes:    5          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

data_0000_e	equ	0
data_0006_e	equ	6
data_0008_e	equ	8
data_000D_e	equ	0Dh
data_00A0_e	equ	0A0h
data_00AF_e	equ	0AFh
data_5F00_e	equ	5F00h			;*
data_8703_e	equ	8703h			;*

seg_a		segment	byte public
		assume	cs:seg_a, ds:seg_a


		org	100h

PCMAN		proc	far

start:
		mov	ax,cs
		add	ax,20h
		mov	word ptr data_010C+2,ax
		jmp	dword ptr data_010C
data_010C	dw	0, 0
		db	144 dup (0)
data_01A0	db	0
		db	79 dup (0)
data_01F0	db	0
		db	15 dup (0)
		db	 33h,0C0h, 8Eh,0D8h,0BFh, 10h
		db	 04h, 8Ah, 05h, 24h,0CFh, 0Ch
		db	 20h, 88h, 05h, 8Ch,0C8h, 05h
		db	0FCh, 00h, 8Eh,0D8h,0B8h, 00h
		db	0B8h, 8Eh,0C0h,0B0h, 4Fh,0E7h
		db	 61h,0B0h,0B6h,0E6h, 43h,0B8h
		db	 04h, 00h,0CDh, 10h,0BAh,0D9h
		db	 03h,0B0h, 10h,0EEh,0B2h, 03h
		db	0E8h,0EEh, 00h,0BFh, 50h, 01h
		db	0BEh, 00h, 00h,0BBh,0F4h,0FFh
loc_023C:
		mov	cx,17h
		mov	dx,1FF7h
		mov	bp,0E047h
		cld				; Clear direction

locloop_0246:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		movsb				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0246		; Loop if cx > 0

		sub	di,2370h
		add	di,word ptr ds:[4E6h][bx]
		add	bx,2
		jnz	loc_023C		; Jump if not zero
		mov	si,4E6h
		mov	bp,112h
loc_0264:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	bx,dx
loc_026A:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	bx,dx
		je	loc_026A		; Jump if equal
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_0284		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	al,13h
		jne	loc_0284		; Jump if not equal
		neg	data_2FA0
loc_0284:
		lodsw				; String [si] to ax
		cmp	byte ptr data_2FA0,0
		jg	loc_0292		; Jump if >
		call	sub_1160
		jmp	short loc_0298
		db	90h
loc_0292:
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
loc_0298:
		sub	bp,2
		jnz	loc_0264		; Jump if not zero
		mov	dl,3
		call	sub_0321
		mov	cx,5
		mov	si,5F8h

locloop_02A8:
		cld				; Clear direction
		lodsw				; String [si] to ax
		mov	dx,ax
		mov	bh,0
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
loc_02B2:
		lodsb				; String [si] to al
		cmp	al,0
		je	loc_02C0		; Jump if equal
		mov	bx,2
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		jmp	short loc_02B2
loc_02C0:
		loop	locloop_02A8		; Loop if cx > 0

loc_02C2:
		mov	byte ptr data_2F8F,1
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		xor	al,30h			; '0'
		test	al,30h			; '0'
		jnz	loc_02EE		; Jump if not zero
		mov	byte ptr data_2F8F,0
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_02C2		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	al,20h			; ' '
		je	loc_02EE		; Jump if equal
		cmp	al,13h
		jne	loc_02C2		; Jump if not equal
		neg	data_2FA0
		jmp	short loc_02C2
loc_02EE:
		mov	data_2D24,0
		mov	byte ptr ds:[6F0h],3
		mov	word ptr ds:[6F1h],0
		push	es
		push	ds
		pop	es
		mov	di,offset data_2F7E
		mov	cx,5
		cld				; Clear direction
		mov	al,0
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		pop	es
		call	sub_032E
		mov	al,2
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xor	al,al			; Zero register
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	si,678h
		mov	cx,2
		jmp	short locloop_02A8

PCMAN		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0321	proc	near
		mov	cx,0

locloop_0324:
		loop	locloop_0324		; Loop if cx > 0

		mov	cx,0
		dec	dl
		jnz	locloop_0324		; Jump if not zero
		retn
sub_0321	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_032E	proc	near
loc_032E:
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ah,0Bh
		mov	bx,100h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	ah,0Bh
		mov	bx,10h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	dh,32h			; '2'
		mov	di,data_000D_e
		mov	bx,0A09h
loc_0349:
		mov	dl,3Eh			; '>'
loc_034B:
		mov	al,[bx]
		inc	bx
		cmp	al,0
		je	loc_0373		; Jump if equal
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,991h
		mov	bp,1FFFh
		mov	cx,4
		cld				; Clear direction

locloop_0365:
		movsb				; Mov [si] to es:[di]
		add	di,bp
		neg	bp
		add	bp,4Eh
		loop	locloop_0365		; Loop if cx > 0

		sub	di,0A0h
loc_0373:
		inc	di
		dec	dl
		jnz	loc_034B		; Jump if not zero
		add	di,62h
		dec	dh
		jnz	loc_0349		; Jump if not zero
		push	es
		push	ds
		pop	es
		mov	byte ptr data_2C99,0E6h
		mov	si,offset data_19EA
		mov	di,offset data_1673
		mov	cx,377h
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		mov	dh,18h
		mov	di,data_00AF_e
		mov	bx,offset data_1692
loc_039C:
		mov	dl,1Dh
loc_039E:
		mov	al,[bx]
		inc	bx
		cmp	al,2
		jb	loc_03CA		; Jump if below
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_1615
		mov	bp,1FFEh
		mov	cx,8
		cld				; Clear direction

locloop_03BC:
		movsw				; Mov [si] to es:[di]
		add	di,bp
		neg	bp
		add	bp,4Ch
		loop	locloop_03BC		; Loop if cx > 0

		sub	di,140h
loc_03CA:
		add	di,2
		dec	dl
		jnz	loc_039E		; Jump if not zero
		inc	bx
		add	di,106h
		dec	dh
		jnz	loc_039C		; Jump if not zero
		mov	ah,2
		mov	dx,101h
		mov	bh,0
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	si,6C3h
		mov	cx,27h
		cld				; Clear direction

locloop_03EA:
		lodsb				; String [si] to al
		mov	bx,3
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		loop	locloop_03EA		; Loop if cx > 0

		push	es
		push	ds
		pop	es
		mov	di,offset data_2F88
		mov	si,offset data_2F83
		mov	cx,5
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		mov	di,0A00h
		call	sub_10C4
		call	sub_1078
		mov	ax,word ptr ds:[6F1h]
		inc	ax
		cmp	ax,0Ch
		jle	loc_0418		; Jump if < or =
		mov	ax,0Ch
loc_0418:
		mov	word ptr ds:[6F1h],ax
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		lea	si,ds:[6EFh][si]	; Load effective addr
		cld				; Clear direction
		lodsb				; String [si] to al
		mov	data_2C9A,al
		lodsb				; String [si] to al
		mov	data_2D26,al
		lodsw				; String [si] to ax
		mov	data_2D27,ax
		mov	bx,word ptr ds:[6F1h]
		cmp	bx,8
		jle	loc_043E		; Jump if < or =
		mov	bx,8
loc_043E:
		mov	di,offset data_1D19
		mov	si,offset data_2D2E
		mov	dx,1FFCh
		mov	bp,0E04Ch
loc_044A:
		mov	cx,0Eh
		add	si,3
		cld				; Clear direction

locloop_0451:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0451		; Loop if cx > 0

		sub	di,4B0h
		dec	bx
		jnz	loc_044A		; Jump if not zero
loc_0460:
		mov	bl,byte ptr ds:[6F0h]
		mov	bh,0
		dec	bx
		jz	loc_049F		; Jump if zero
		mov	di,bx
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		add	di,bx
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		neg	di
		add	di,offset data_1F3B
loc_0485:
		mov	si,offset data_1F59
		mov	dx,1FFCh
		mov	bp,0E04Ch
		mov	cx,0Eh

locloop_0491:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0491		; Loop if cx > 0

		add	di,50h
		dec	bx
		jnz	loc_0485		; Jump if not zero
loc_049F:
		push	es
		push	ds
		pop	es
		cld				; Clear direction
		mov	di,offset data_2F90
		mov	cx,4
		mov	ax,0
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	data_2C9B,0
		mov	byte ptr data_2CC9,0
		mov	byte ptr data_2CBC,0
;*		lea	si,ds:[725h]		; Load effective addr
		db	 8Dh, 36h, 25h, 07h	;  Fixup - byte match
;*		lea	di,data_2A2D		; Load effective addr
		db	 8Dh, 3Eh, 2Dh, 2Ah	;  Fixup - byte match
		mov	cx,26Ch
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		call	sub_0AD9
		mov	bx,offset data_01F0
		cld				; Clear direction
loc_04D3:
		lea	si,data_2A39[bx]	; Load effective addr
		mov	di,data_2A2E[bx]
		mov	cx,0Eh
		mov	dx,0E04Ch
		mov	bp,1FFCh

locloop_04E4:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_04E4		; Loop if cx > 0

		sub	bx,7Ch
		jnz	loc_04D3		; Jump if not zero
		mov	si,offset data_1E09
		mov	di,data_2A2E
		mov	dx,0E04Ch
		mov	cx,0Eh
		cld				; Clear direction

locloop_04FF:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		neg	dx
		add	dx,48h
		loop	locloop_04FF		; Loop if cx > 0

		mov	dx,0
		mov	ah,2
		mov	bh,0
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	di,0C07h
		mov	bp,data_0006_e
loc_0519:
		mov	al,byte ptr ds:[6E9h][bp]
		mov	cx,1
		mov	bx,2
		mov	ah,9
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		push	ds
		push	es
		pop	ds
		mov	si,data_0000_e
		mov	dx,1FFEh
		mov	bx,0E04Eh
		mov	cx,8

locloop_0537:
		movsw				; Mov [si] to es:[di]
		add	di,dx
		add	si,dx
		xchg	dx,bx
		loop	locloop_0537		; Loop if cx > 0

		pop	ds
		dec	bp
		jnz	loc_0519		; Jump if not zero
		mov	di,data_0000_e
		mov	ax,0
		mov	dx,1FFEh
		mov	bp,0E04Eh
		mov	cx,8

locloop_0553:
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0553		; Loop if cx > 0

		mov	dh,5
		mov	cx,0

locloop_055F:
		loop	locloop_055F		; Loop if cx > 0

		mov	cx,0
		dec	dh
		jnz	locloop_055F		; Jump if not zero
		mov	di,0C07h
		mov	ax,0
		mov	cx,30h
		mov	dx,1FFEh
		mov	bp,0E04Eh

locloop_0577:
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0577		; Loop if cx > 0

		call	sub_06DB
		mov	al,2
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xor	al,al			; Zero register
		out	42h,al			; port 42h, 8253 timer 2 spkr
		call	sub_1078
		cmp	byte ptr data_2C99,0
		jne	loc_05AC		; Jump if not equal
		mov	di,data_2A2E
		mov	si,offset data_1DD1
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	cx,0Eh
		cld				; Clear direction

locloop_05A4:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_05A4		; Loop if cx > 0

loc_05AC:
		mov	dl,2
		mov	cx,0

locloop_05B1:
		loop	locloop_05B1		; Loop if cx > 0

		mov	cx,0
		dec	dl
		jnz	locloop_05B1		; Jump if not zero
		mov	bx,26Ch
loc_05BD:
		mov	di,data_2A2E[bx]
		mov	si,offset data_2A71
		add	si,bx
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	cl,data_2A35[bx]
		mov	ch,0
		jcxz	loc_05DD		; Jump if cx=0
		cld				; Clear direction

locloop_05D5:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_05D5		; Loop if cx > 0

loc_05DD:
		sub	bx,7Ch
		jnz	loc_05BD		; Jump if not zero
		cmp	byte ptr data_2C99,0
		je	loc_05EC		; Jump if equal
		jmp	short loc_060D
		db	90h
loc_05EC:
		mov	bh,7
		mov	dx,3D9h
		mov	al,20h			; ' '
		mov	ah,10h
loc_05F5:
		mov	bl,2
		mov	cx,0

locloop_05FA:
		loop	locloop_05FA		; Loop if cx > 0

		mov	cx,8000h
		dec	bl
		jnz	locloop_05FA		; Jump if not zero
		out	dx,al			; port 3D9h, CGA color control
		xchg	al,ah
		dec	bh
		jnz	loc_05F5		; Jump if not zero
		jmp	loc_032E
loc_060D:
		mov	bp,data_2A2E
		mov	si,2675h
		mov	ax,2CD0h
		mov	word ptr ds:[723h],ax
loc_061A:
		mov	di,2
		push	si
		mov	si,word ptr ds:[723h]
loc_0622:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	bx,dx
loc_0628:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,bx
		je	loc_0628		; Jump if equal
		lodsw				; String [si] to ax
		cmp	byte ptr data_2FA0,0
		jl	loc_063E		; Jump if <
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
loc_063E:
		dec	di
		jnz	loc_0622		; Jump if not zero
		mov	word ptr ds:[723h],si
		pop	si
		cld				; Clear direction
		mov	di,bp
		mov	bx,1FFCh
		mov	dx,0E04Ch
		mov	cl,data_2A35
		mov	ch,0
		mov	ax,cx
		neg	ax
		add	ax,0Eh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		jcxz	loc_066A		; Jump if cx=0

locloop_0662:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bx
		loop	locloop_0662		; Loop if cx > 0

loc_066A:
		add	si,ax
		cmp	si,2A2Dh
		jne	loc_061A		; Jump if not equal
		mov	di,bp
		mov	si,offset data_2A71
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	cl,data_2A35
		mov	ch,0
		jcxz	loc_068E		; Jump if cx=0
		cld				; Clear direction

locloop_0686:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0686		; Loop if cx > 0

loc_068E:
		mov	al,byte ptr ds:[6F0h]
		mov	ah,0
		dec	ax
		mov	byte ptr ds:[6F0h],al
		jz	loc_ret_06DA		; Jump if zero
		mov	di,ax
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		add	di,ax
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		neg	di
		add	di,offset data_1F3B
		mov	ax,0
		mov	dx,1FFCh
		mov	bp,0E04Ch
		mov	cx,0Eh
		cld				; Clear direction

locloop_06C2:
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_06C2		; Loop if cx > 0

		mov	byte ptr data_2F44,1
		mov	byte ptr data_2F43,0
		call	sub_0E61
		jmp	loc_0460

loc_ret_06DA:
		retn
sub_032E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_06DB	proc	near
loc_06DB:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	bx,dx
loc_06E1:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	bx,dx
		je	loc_06E1		; Jump if equal
		mov	data_2CCE,0
		inc	byte ptr data_2CCA
		mov	al,byte ptr data_2C9B
		cmp	al,0
		je	loc_070E		; Jump if equal
		dec	al
		mov	byte ptr data_2C9B,al
		jnz	loc_070E		; Jump if not zero
		mov	bx,offset data_01F0
loc_0704:
		and	byte ptr data_2A38[bx],0FEh
		sub	bx,7Ch
		jnz	loc_0704		; Jump if not zero
loc_070E:
		dec	byte ptr data_2CCA+1
		jnz	loc_0719		; Jump if not zero
		mov	byte ptr data_2CCA+1,0Eh
loc_0719:
		mov	bx,data_0008_e
		mov	si,offset data_1645
		cmp	byte ptr data_2CCA+1,7
		jg	loc_0729		; Jump if >
		add	si,10h
loc_0729:
		mov	di,data_1623[bx]
		mov	al,[di]
		cmp	al,3
		jne	loc_0754		; Jump if not equal
		mov	cx,8
		mov	di,data_162B[bx]
		mov	ax,data_2A2E
		sub	ax,di
		cmp	ax,1F5Fh
		je	loc_0754		; Jump if equal
		mov	dx,1FFEh

locloop_0747:
		movsw				; Mov [si] to es:[di]
		add	di,dx
		neg	dx
		add	dx,4Ch
		loop	locloop_0747		; Loop if cx > 0

		sub	si,10h
loc_0754:
		dec	bx
		dec	bx
		jnz	loc_0729		; Jump if not zero
		mov	bx,offset data_01F0
		mov	cx,5

locloop_075E:
		mov	ax,data_2A2E[bx]
		mov	data_2A33[bx],ax
		mov	al,data_2A35[bx]
		mov	data_2A36[bx],al
		sub	bx,7Ch
		loop	locloop_075E		; Loop if cx > 0

		call	sub_0F6D
		test	byte ptr data_2A30+1,1
		jnz	loc_07BE		; Jump if not zero
		test	byte ptr data_2A30,1
		jnz	loc_07BE		; Jump if not zero
		mov	ah,0
		mov	al,byte ptr data_2A30
		sar	ax,1			; Shift w/sign fill
		mov	dx,1Eh
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		mov	ax,word ptr data_2A30+1
		sar	ax,1			; Shift w/sign fill
		add	bx,ax
		cmp	byte ptr data_1673[bx],1
		jg	loc_07DB		; Jump if >
loc_07A0:
		mov	al,data_2CBC
		mov	ah,0
		mov	si,ax
		mov	al,data_2CBD[si]
		cbw				; Convrt byte to word
		mov	si,ax
		cmp	byte ptr data_1673[bx+si],0
		je	loc_07C1		; Jump if equal
		mov	al,data_2CBC
		mov	data_2A2D,al
loc_07BB:
		jmp	loc_0857
loc_07BE:
		jmp	loc_0846
loc_07C1:
		mov	al,data_2A2D
		mov	ah,0
		mov	si,ax
		mov	al,data_2CBD[si]
		cbw				; Convrt byte to word
		mov	si,ax
		cmp	byte ptr data_1673[bx+si],0
		jne	loc_07BB		; Jump if not equal
		jmp	loc_08AF
loc_07D9:
		jmp	short loc_07A0
loc_07DB:
		mov	ax,401h
		call	sub_103A
		mov	al,1
		xchg	data_1673[bx],al
		cmp	al,3
		jne	loc_0814		; Jump if not equal
		mov	byte ptr data_2F91,19h
		mov	ax,404h
		call	sub_103A
		mov	data_2F8D,0
		mov	al,data_2C9A
		mov	byte ptr data_2C9B,al
		mov	si,offset data_01F0
loc_0805:
		or	byte ptr data_2A38[si],1
		xor	byte ptr data_2A2D[si],1
		sub	si,7Ch
		jnz	loc_0805		; Jump if not zero
loc_0814:
		dec	data_2C99
		jnz	loc_081B		; Jump if not zero
		retn
loc_081B:
		cld				; Clear direction
		push	es
		push	ds
		pop	es
		mov	ax,0
		mov	cx,8
		mov	di,offset data_2A7E

locloop_0828:
		stosw				; Store ax to es:[di]
		inc	di
		inc	di
		loop	locloop_0828		; Loop if cx > 0

		pop	es
		mov	byte ptr data_2F90,2
		neg	data_2CCC
		jg	loc_07D9		; Jump if >
		inc	data_2F90
		mov	data_2CCE,7Ch
		jmp	short loc_08AF
		db	90h
loc_0846:
		mov	al,data_2A2D
		xor	al,data_2CBC
		test	al,2
		jnz	loc_0857		; Jump if not zero
		mov	al,data_2CBC
		mov	data_2A2D,al
loc_0857:
		mov	al,data_2A2D
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		mov	ax,data_2CC1[si]
		add	ax,data_2A2E
		mov	data_2A2E,ax
		mov	ax,si
		test	ax,4
		jnz	loc_087D		; Jump if not zero
		dec	ax
		add	al,byte ptr data_2A30
		mov	byte ptr data_2A30,al
		jmp	short loc_0884
		db	90h
loc_087D:
		sub	ax,5
		add	byte ptr data_2A30+1,al
loc_0884:
		mov	al,data_2CC9
		inc	al
		and	al,3
		mov	data_2CC9,al
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ah,0
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,word ptr data_2C9B+1[bx]
		add	si,offset data_1D61
		mov	di,offset data_2A39
		mov	cx,0Eh
		push	es
		push	ds
		pop	es
		cld				; Clear direction

locloop_08AA:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		loop	locloop_08AA		; Loop if cx > 0

		pop	es
loc_08AF:
		mov	bx,offset data_01F0
loc_08B2:
		cmp	byte ptr data_2A37[bx],2
		jl	loc_08C1		; Jump if <
		mov	byte ptr data_2A37[bx],1
		jmp	loc_0965
loc_08C1:
		test	byte ptr data_2A30+1[bx],1
		jnz	loc_0910		; Jump if not zero
		test	byte ptr data_2A30[bx],1
		jnz	loc_0910		; Jump if not zero
		mov	byte ptr data_2CCD,0
		mov	ah,0
		mov	al,byte ptr data_2A30[bx]
		sar	ax,1			; Shift w/sign fill
		mov	dx,1Eh
		mul	dx			; dx:ax = reg * ax
		mov	bp,ax
		mov	ax,word ptr data_2A30+1[bx]
		sar	ax,1			; Shift w/sign fill
		add	bp,ax
		call	sub_0B5A
		cmp	data_2A2D[bx],al
		je	loc_0919		; Jump if equal
		mov	dl,al
		xchg	data_2A2D[bx],dl
		cmp	byte ptr data_2A37[bx],1
		je	loc_0919		; Jump if equal
		mov	data_2A2D[bx],dl
		mov	byte ptr data_2A37[bx],1
		jmp	short loc_0965
		nop
		jmp	short loc_0919
		db	90h
loc_0910:
		mov	al,data_2A2D[bx]
		mov	byte ptr data_2CCD,1
loc_0919:
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		mov	si,data_2CC1[si]
		add	data_2A2E[bx],si
		mov	ah,al
		sar	ax,1			; Shift w/sign fill
		cbw				; Convrt byte to word
		shl	ah,1			; Shift w/zeros fill
		inc	ah
		neg	ah
		and	al,7Fh
		mov	dl,al
		mov	al,ah
		mov	dh,0
		mov	di,dx
		add	byte ptr data_2A30[bx+di],al
		mov	byte ptr data_2A37[bx],0
		cmp	byte ptr data_2A38[bx],2
		jl	loc_0957		; Jump if <
		cmp	byte ptr data_2A38[bx],6
		jge	loc_0957		; Jump if > or =
		sub	byte ptr data_2A30[bx+di],al
loc_0957:
		cmp	byte ptr data_2CCD,1
		je	loc_0965		; Jump if equal
		cmp	byte ptr data_2A38[bx],6
		jge	loc_0910		; Jump if > or =
loc_0965:
		sub	bx,7Ch
		jz	loc_096D		; Jump if zero
		jmp	loc_08B2
loc_096D:
		call	sub_0AD9
		mov	cx,5
		mov	bx,data_0000_e

locloop_0976:
		mov	al,byte ptr data_2A30[bx]
		cmp	al,0
		mov	ah,3Ah			; ':'
		mov	dx,2440h
		jl	loc_098C		; Jump if <
		cmp	al,39h			; '9'
		mov	ah,0C6h
		mov	dx,0DBC0h
		jle	loc_0996		; Jump if < or =
loc_098C:
		add	al,ah
		mov	byte ptr data_2A30[bx],al
		add	data_2A2E[bx],dx
loc_0996:
		cmp	byte ptr data_2A37[bx],1
		je	loc_09C9		; Jump if equal
		cmp	byte ptr data_2A30+1[bx],20h	; ' '
		jne	loc_09B6		; Jump if not equal
		mov	byte ptr data_2A37[bx],2
		cmp	al,0Ch
		jl	loc_09B6		; Jump if <
		cmp	al,26h			; '&'
		jg	loc_09B6		; Jump if >
		mov	byte ptr data_2A37[bx],0
loc_09B6:
		cmp	byte ptr data_2A38[bx],0
		je	loc_09C9		; Jump if equal
		cmp	byte ptr data_2A38[bx],6
		jge	loc_09C9		; Jump if > or =
		mov	byte ptr data_2A37[bx],2
loc_09C9:
		mov	ah,0
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		neg	ax
		add	ax,0CFh
		cmp	ax,0
		jl	loc_09E4		; Jump if <
		cmp	ax,0Eh
		jle	loc_09E7		; Jump if < or =
		mov	ax,0Eh
		jmp	short loc_09E7
		db	90h
loc_09E4:
		mov	ax,0
loc_09E7:
		mov	data_2A35[bx],al
		add	bx,7Ch
		loop	locloop_0976		; Loop if cx > 0

		call	sub_1121
		call	sub_1078
		call	sub_0D5C
		cld				; Clear direction
		mov	bx,26Ch
loc_09FD:
		sub	bx,7Ch
		mov	si,offset data_2A71
		add	si,bx
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	di,data_2A33[bx]
		mov	cl,data_2A36[bx]
		mov	ch,0
		jcxz	loc_0A1F		; Jump if cx=0

locloop_0A17:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0A17		; Loop if cx > 0

loc_0A1F:
		cmp	bx,data_2CCE
		jne	loc_09FD		; Jump if not equal
		cmp	byte ptr data_2F44,0
		je	loc_0A2F		; Jump if equal
		call	sub_0E61
loc_0A2F:
		mov	bx,data_2CCE
		sub	bx,26Ch
		mov	bp,48h
loc_0A3A:
		add	bx,7Ch
		mov	si,data_2C1E[bx]
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	di,offset data_2C61
		add	di,bx
		mov	cx,0Eh
		push	es
		push	ds
		pop	es
		pop	ds

locloop_0A53:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	si,dx
		xchg	dx,bp
		loop	locloop_0A53		; Loop if cx > 0

		push	es
		push	ds
		pop	es
		pop	ds
		mov	si,offset data_2C29
		add	si,bx
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	di,data_2C1E[bx]
		mov	cl,data_2C25[bx]
		mov	ch,0
		jcxz	loc_0A8F		; Jump if cx=0

locloop_0A76:
		mov	al,es:[di]
		and	al,0C0h
		or	al,[si]
		inc	si
		stosb				; Store al to es:[di]
		movsw				; Mov [si] to es:[di]
		mov	al,es:[di]
		and	al,3
		or	al,[si]
		inc	si
		stosb				; Store al to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0A76		; Loop if cx > 0

loc_0A8F:
		cmp	bx,0
		jne	loc_0A3A		; Jump if not equal
		mov	bx,offset data_01F0
loc_0A97:
		cmp	byte ptr data_2A38[bx],2
		jge	loc_0AC2		; Jump if > or =
		mov	ax,data_2A30[bx]
		sub	al,byte ptr data_2A30
		jge	loc_0AAA		; Jump if > or =
		neg	al
loc_0AAA:
		sub	ah,byte ptr data_2A30+1
		jge	loc_0AB2		; Jump if > or =
		neg	ah
loc_0AB2:
		add	al,ah
		cmp	al,2
		jg	loc_0AC2		; Jump if >
		cmp	byte ptr data_2A38[bx],0
		je	loc_ret_0AD8		; Jump if equal
		call	sub_0EB6
loc_0AC2:
		sub	bx,7Ch
		jnz	loc_0A97		; Jump if not zero
		mov	di,offset data_1F3C
		mov	ax,0
		cld				; Clear direction
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		sub	di,54h
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		jmp	loc_06DB

loc_ret_0AD8:
		retn
sub_06DB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AD9	proc	near
		push	es
		push	ds
		pop	es
		mov	bx,26Ch
		mov	bp,280h
loc_0AE2:
		sub	bx,7Ch
		sub	bp,0A0h
		mov	cx,8
		mov	al,data_2A2D[bx]
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_20E1
		mov	ax,3C0h
		cmp	byte ptr data_2A38[bx],6
		jge	loc_0B29		; Jump if > or =
		mov	ax,bp
		test	byte ptr data_2A38[bx],1
		jz	loc_0B29		; Jump if zero
		mov	ax,280h
		cmp	byte ptr data_2C9B,46h	; 'F'
		ja	loc_0B29		; Jump if above
		cmp	byte ptr data_2CCA+1,8
		jl	loc_0B29		; Jump if <
		add	ax,0A0h
loc_0B29:
		mov	di,offset data_2A39
		add	di,bx
		call	sub_0D10
		mov	si,offset data_2161
		mov	cx,4
		call	sub_0D10
		mov	si,data_2CCA
;*		and	si,2
		db	 81h,0E6h, 02h, 00h	;  Fixup - byte match
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_2171
		mov	cx,2
		call	sub_0D10
		cmp	bp,0
		jne	loc_0AE2		; Jump if not equal
		pop	es
		retn
sub_0AD9	endp

loc_0B57:
		jmp	loc_0C2B

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0B5A	proc	near
		push	es
		push	ds
		pop	es
		mov	di,offset data_2D2A
		mov	al,1
		mov	cx,4
		cld				; Clear direction
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	al,data_2A38[bx]
		sar	al,1			; Shift w/sign fill
		jz	loc_0B57		; Jump if zero
		dec	al
		jnz	loc_0BA9		; Jump if not zero
loc_0B74:
		mov	ax,data_2A2E[bx]
		sub	ax,2E92h
		jnz	loc_0B95		; Jump if not zero
		sub	byte ptr data_2A38[bx],2
		mov	data_2A30[bx],2619h
		call	sub_0D01
		rcl	ax,1			; Rotate thru carry
		mov	ax,0
		rcl	ax,1			; Rotate thru carry
		jmp	loc_0CFF
loc_0B95:
		cmp	ax,0FFE2h
		jbe	loc_0B9F		; Jump if below or =
		mov	al,3
		jmp	loc_0CFF
loc_0B9F:
		rcl	ax,1			; Rotate thru carry
		mov	ax,0
		rcl	ax,1			; Rotate thru carry
		jmp	loc_0CFF
loc_0BA9:
		dec	al
		jnz	loc_0BF2		; Jump if not zero
		mov	al,data_2A2D[bx]
		mov	ah,0
		mov	si,ax
		mov	dx,bx
		mov	cx,0
loc_0BBA:
		inc	cx
		sub	dx,7Ch
		jnz	loc_0BBA		; Jump if not zero
		shl	cx,1			; Shift w/zeros fill
		add	si,cx
		shl	si,1			; Shift w/zeros fill
		mov	dx,data_2A2E[bx]
		cmp	dx,data_2D0C[si]
		jne	loc_0BEF		; Jump if not equal
		xor	al,1
		cmp	al,3
		jne	loc_0BEF		; Jump if not equal
		test	byte ptr data_2A38[bx],1
		jnz	loc_0BEF		; Jump if not zero
		call	sub_0D01
		cmp	ax,data_2D27
		mov	al,3
		jnc	loc_0BEF		; Jump if carry=0
		sub	byte ptr data_2A38[bx],2
		jmp	short loc_0B74
loc_0BEF:
		jmp	loc_0CFF
loc_0BF2:
		cmp	data_2A30[bx],261Ah
		jne	loc_0C2B		; Jump if not equal
		sub	byte ptr data_2A38[bx],2
		mov	dx,bx
		mov	cx,0
loc_0C04:
		inc	cx
		sub	dx,7Ch
		jnz	loc_0C04		; Jump if not zero
		shl	cx,1			; Shift w/zeros fill
		shl	cx,1			; Shift w/zeros fill
		mov	si,cx
		mov	ax,data_2D10[si]
		mov	data_2A2E[bx],ax
		cmp	cx,0Ch
		jne	loc_0C22		; Jump if not equal
		sub	byte ptr data_2A38[bx],2
loc_0C22:
		mov	al,3
		mov	data_2A2D[bx],al
		jmp	loc_0CFF
loc_0C2B:
		mov	al,data_2D26
		mov	data_2D29,al
		mov	dl,data_2A38[bx]
		mov	cl,dl
;*		xor	cx,1
		db	 81h,0F1h, 01h, 00h	;  Fixup - byte match
;*		and	cx,1
		db	 81h,0E1h, 01h, 00h	;  Fixup - byte match
		cmp	dl,6
		jl	loc_0C4C		; Jump if <
		mov	byte ptr data_2D29,3Ch	; '<'
		mov	cx,1
loc_0C4C:
		mov	al,byte ptr data_2A30
		cmp	dl,6
		jl	loc_0C56		; Jump if <
		mov	al,1Ah
loc_0C56:
		sub	al,byte ptr data_2A30[bx]
		jcxz	loc_0C5E		; Jump if cx=0
		neg	al
loc_0C5E:
		jz	loc_0C70		; Jump if zero
		rcl	al,1			; Rotate thru carry
		mov	ax,0
		rcl	ax,1			; Rotate thru carry
		mov	di,ax
		mov	al,data_2D29
		mov	data_2D2A[di],al
loc_0C70:
		mov	al,byte ptr data_2A30+1
		cmp	dl,6
		jl	loc_0C7A		; Jump if <
		mov	al,26h			; '&'
loc_0C7A:
		sub	al,byte ptr data_2A30+1[bx]
		jcxz	loc_0C82		; Jump if cx=0
		neg	al
loc_0C82:
		jz	loc_0C94		; Jump if zero
		rcl	al,1			; Rotate thru carry
		mov	ax,1
		rcl	ax,1			; Rotate thru carry
		mov	di,ax
		mov	al,data_2D29
		mov	data_2D2A[di],al
loc_0C94:
		mov	cx,4

locloop_0C97:
		mov	di,cx
		mov	al,data_2CBC[di]
		cbw				; Convrt byte to word
		mov	si,ax
		cmp	byte ptr ds:data_1673[bp+si],0
		jne	loc_0CAD		; Jump if not equal
		mov	byte ptr data_2D29[di],0
loc_0CAD:
		loop	locloop_0C97		; Loop if cx > 0

		mov	al,data_2A2D[bx]
		mov	ah,0
		mov	di,ax
		cmp	byte ptr data_2A37[bx],1
		je	loc_0CD0		; Jump if equal
		mov	ax,di
		mov	ah,byte ptr data_2A30+1[bx]
		xor	ah,20h			; ' '
		test	ax,0FFFEh
		jz	loc_0CD0		; Jump if zero
		shl	data_2D2A[di],1		; Shift w/zeros fill
loc_0CD0:
;*		xor	di,1
		db	 81h,0F7h, 01h, 00h	;  Fixup - byte match
		mov	byte ptr data_2D2A[di],0
		mov	cx,4
		mov	bp,0
		mov	si,offset data_2D2A
		mov	ah,0

locloop_0CE4:
		lodsb				; String [si] to al
		add	bp,ax
		loop	locloop_0CE4		; Loop if cx > 0

		call	sub_0D01
		mul	bp			; dx:ax = reg * ax
		mov	si,offset data_2D2A
		mov	ah,0
loc_0CF3:
		lodsb				; String [si] to al
		sub	dx,ax
		jge	loc_0CF3		; Jump if > or =
		mov	ax,2D2Bh
		neg	ax
		add	ax,si
loc_0CFF:
		pop	es
		retn
sub_0B5A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D01	proc	near
		mov	ax,data_2D24
		mov	dx,98DDh
		mul	dx			; dx:ax = reg * ax
		add	ax,0D5EFh
		mov	data_2D24,ax
		retn
sub_0D01	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D10	proc	near
		add	si,ax
		cld				; Clear direction

locloop_0D13:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		loop	locloop_0D13		; Loop if cx > 0

		retn
sub_0D10	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D18	proc	near
		mov	byte ptr data_2F93,18h
		mov	al,byte ptr ds:[6F0h]
		mov	ah,0
		inc	al
		mov	byte ptr ds:[6F0h],al
		mov	di,ax
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		add	di,ax
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		neg	di
		add	di,offset data_21BB
		mov	si,offset data_1F59
		mov	dx,1FFCh
		mov	bp,0E04Ch
		mov	cx,0Eh
		cld				; Clear direction

locloop_0D50:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0D50		; Loop if cx > 0

		retn
sub_0D18	endp

loc_0D59:
		jmp	loc_0DEA

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D5C	proc	near
		mov	byte ptr data_2F44,0
		cmp	byte ptr data_2F43,2
		jne	loc_0D59		; Jump if not equal
		cmp	data_2A2E,2E86h
		jne	loc_0D59		; Jump if not equal
		mov	byte ptr data_2F92,9
		mov	byte ptr data_2F43,1
		mov	data_2F3E,3Ch
		push	es
		push	ds
		pop	es
		mov	di,offset data_2F45
		mov	bx,data_2F41
		mov	bp,3
		cmp	byte ptr [bx],0
		jne	loc_0DA4		; Jump if not equal
		mov	ax,0
		cld				; Clear direction
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		inc	bx
		dec	bp
		add	di,1Eh
		cld				; Clear direction
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		sub	di,24h
loc_0DA4:
		mov	al,[bx]
		inc	bx
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_2F06
		mov	cx,4
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	ax,0
		stosw				; Store ax to es:[di]
		dec	bp
		jnz	loc_0DA4		; Jump if not zero
		mov	si,offset data_2F06
		mov	cx,4
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	ax,0
		stosw				; Store ax to es:[di]
		pop	es
		sub	bx,3
		mov	dx,3
loc_0DD4:
		mov	ah,dl
		neg	ah
		add	ah,5
		mov	al,[bx]
		call	sub_103A
		inc	bx
		dec	dx
		jnz	loc_0DD4		; Jump if not zero
		mov	byte ptr data_2F44,2
		retn
sub_0D5C	endp

loc_0DEA:
		cmp	byte ptr data_2F43,0
		jne	loc_0E49		; Jump if not equal
		mov	al,data_2C99
		cmp	al,data_2F40
		je	loc_ret_0E02		; Jump if equal
		cmp	al,0AAh
		je	loc_0E03		; Jump if equal
		cmp	al,50h			; 'P'
		je	loc_0E03		; Jump if equal

loc_ret_0E02:
		retn
loc_0E03:
		mov	data_2F40,al
		mov	byte ptr data_2F43,2
		mov	data_2F3E,87h
		mov	byte ptr data_2F44,3
		mov	di,2F45h
		mov	ax,word ptr ds:[6F1h]
		dec	ax
		cmp	ax,8
		jl	loc_0E2F		; Jump if <
		call	sub_0D01
		mov	al,0
		rol	ax,1			; Rotate
		rol	ax,1			; Rotate
		rol	ax,1			; Rotate
		mov	ah,0
loc_0E2F:
		mov	dx,3Bh
		mul	dx			; dx:ax = reg * ax
		add	ax,2D2Eh
		mov	data_2F41,ax
		mov	si,ax
		add	si,3
		mov	cx,1Ch
		push	es
		push	ds
		pop	es
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		retn
loc_0E49:
		dec	data_2F3E
		jz	loc_0E50		; Jump if zero
		retn
loc_0E50:
		mov	byte ptr data_2F43,0
		mov	data_2F3E,10Eh
		mov	byte ptr data_2F44,1
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0E61	proc	near
		cld				; Clear direction
		cmp	byte ptr data_2F44,2
		jg	loc_0E9E		; Jump if >
		jz	loc_0E83		; Jump if zero
		mov	di,0DE6h
		mov	ax,0
		mov	cx,14h
		mov	dx,1FFCh
		mov	bp,0E04Ch

locloop_0E7A:
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0E7A		; Loop if cx > 0

		retn
loc_0E83:
		mov	di,0DE6h
		mov	si,offset data_2F45
		mov	cx,14h
		mov	dx,1FFCh
		mov	bp,0E04Ch
		mov	al,0

locloop_0E94:
		stosb				; Store al to es:[di]
		movsw				; Mov [si] to es:[di]
		stosb				; Store al to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0E94		; Loop if cx > 0

		retn
loc_0E9E:
		mov	di,offset data_2E86
		mov	si,offset data_2F45
		mov	cx,0Eh
		mov	dx,0E04Ch
		mov	bp,1FFCh

locloop_0EAD:
		movsw				; Mov [si] to es:[di]
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0EAD		; Loop if cx > 0

		retn
sub_0E61	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0EB6	proc	near
		cld				; Clear direction
		mov	di,data_2F8D
		mov	al,data_25F1[di]
		mov	ah,3
		call	sub_103A
		mov	byte ptr data_2A38[bx],6
		add	si,bx
		mov	di,data_2A2E[bx]
		mov	cl,data_2A35[bx]
		call	sub_0F54
		mov	di,data_2A2E
		mov	cl,data_2A35
		call	sub_0F54
		call	sub_0F12
		mov	al,2
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xor	al,al			; Zero register
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	si,offset data_2FF6
		mov	bp,18h
		cld				; Clear direction
loc_0EF3:
		lodsw				; String [si] to ax
		cmp	byte ptr data_2FA0,0
		jl	loc_0F01		; Jump if <
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
loc_0F01:
		mov	cx,140Ah

locloop_0F04:
		loop	locloop_0F04		; Loop if cx > 0

		dec	bp
		jnz	loc_0EF3		; Jump if not zero
		call	sub_0F12
		add	data_2F8D,21h
		retn
sub_0EB6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F12	proc	near
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	di,data_2A2E
		add	di,data_2A2E[bx]
		sar	di,1			; Shift w/sign fill
		add	di,data_00A0_e
		mov	si,offset data_25F2
		add	si,data_2F8D
		mov	cl,data_2A35
		add	cl,data_2A35[bx]
		sar	cl,1			; Shift w/sign fill
		mov	ch,0
		jcxz	loc_ret_0F53		; Jump if cx=0
		cmp	cx,8
		jle	locloop_0F43		; Jump if < or =
		mov	cx,8

locloop_0F43:
		lodsw				; String [si] to ax
		xor	ax,es:[di]
		stosw				; Store ax to es:[di]
		lodsw				; String [si] to ax
		xor	ax,es:[di]
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0F43		; Loop if cx > 0


loc_ret_0F53:
		retn
sub_0F12	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F54	proc	near
		mov	ax,0
		mov	dx,0E04Ch
		mov	bp,1FFCh
		mov	ch,0
		jcxz	loc_ret_0F69		; Jump if cx=0

locloop_0F61:
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_0F61		; Loop if cx > 0


loc_ret_0F69:
		retn
sub_0F54	endp

loc_0F6A:
		pop	ax
		pop	ax
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F6D	proc	near
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_0FCF		; Jump if zero
		mov	ah,0
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	ax,0
		je	loc_0F6A		; Jump if equal
		cmp	al,13h
		jne	loc_0F84		; Jump if not equal
		neg	data_2FA0
loc_0F84:
		cmp	byte ptr data_2F8F,1
		je	loc_0FCF		; Jump if equal
		and	al,0DFh
		mov	bl,0
		cmp	ah,48h			; 'H'
		je	loc_0FCA		; Jump if equal
		cmp	al,45h			; 'E'
		je	loc_0FCA		; Jump if equal
		cmp	al,49h			; 'I'
		je	loc_0FCA		; Jump if equal
		inc	bl
		cmp	ah,50h			; 'P'
		je	loc_0FCA		; Jump if equal
		cmp	al,4Ah			; 'J'
		je	loc_0FCA		; Jump if equal
		cmp	al,44h			; 'D'
		je	loc_0FCA		; Jump if equal
		inc	bl
		cmp	ah,4Bh			; 'K'
		je	loc_0FCA		; Jump if equal
		cmp	al,41h			; 'A'
		je	loc_0FCA		; Jump if equal
		cmp	al,4Bh			; 'K'
		je	loc_0FCA		; Jump if equal
		inc	bl
		cmp	ah,4Dh			; 'M'
		je	loc_0FCA		; Jump if equal
		cmp	al,4Ch			; 'L'
		je	loc_0FCA		; Jump if equal
		cmp	al,53h			; 'S'
		je	loc_0FCA		; Jump if equal

loc_ret_0FC9:
		retn
loc_0FCA:
		mov	data_2CBC,bl
		retn
loc_0FCF:
		cmp	byte ptr data_2F8F,1
		jne	loc_ret_0FC9		; Jump if not equal
		mov	al,data_2A2D
		mov	data_2CBC,al
		cli				; Disable interrupts
		mov	dx,201h
		mov	cx,190h
		mov	al,0FFh
		mov	ah,1
		out	dx,al			; port 201h, start game 1-shots

locloop_0FE8:
		in	al,dx			; port 201h, start game 1-shots
		and	al,ah
		loopnz	locloop_0FE8		; Loop if zf=0, cx>0

		mov	bx,cx
		jcxz	loc_0FF6		; Jump if cx=0

locloop_0FF1:
		nop
		nop
		nop
		loop	locloop_0FF1		; Loop if cx > 0

loc_0FF6:
		add	bx,0FECAh
		mov	cx,190h
		mov	al,0FFh
		mov	ah,2
		out	dx,al			; port 201h, start game 1-shots

locloop_1002:
		in	al,dx			; port 201h, start game 1-shots
		and	al,ah
		loopnz	locloop_1002		; Loop if zf=0, cx>0

		sti				; Enable interrupts
		add	cx,0FEBEh
		neg	cx
		mov	dx,cx
		add	cx,bx
		mov	si,cx
		jge	loc_1018		; Jump if > or =
		neg	si
loc_1018:
		sub	dx,bx
		mov	di,dx
		jge	loc_1020		; Jump if > or =
		neg	di
loc_1020:
		add	si,di
		cmp	si,51h
		jl	loc_ret_0FC9		; Jump if <
		mov	ax,0
		rcl	cx,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		rcl	dx,1			; Rotate thru carry
		rcl	ax,1			; Rotate thru carry
		inc	ax
		and	ax,3
		mov	data_2CBC,al
		retn
sub_0F6D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_103A	proc	near
		push	es
		push	ds
		pop	es
		std				; Set direction flag
;*		lea	di,data_2F7E		; Load effective addr
		db	 8Dh, 3Eh, 7Eh, 2Fh	;  Fixup - byte match
		mov	cl,ah
		mov	ch,0
		add	di,cx

locloop_1048:
		add	al,[di]
		mov	ah,0FFh
loc_104C:
		inc	ah
		sub	al,0Ah
		jge	loc_104C		; Jump if > or =
		add	al,0Ah
		stosb				; Store al to es:[di]
		mov	al,ah
		cmp	al,0
		loopnz	locloop_1048		; Loop if zf=0, cx>0

		cld				; Clear direction
		pop	es
		mov	si,di
		mov	ax,2F7Eh
		sub	ax,di
		jnz	loc_ret_1077		; Jump if not zero
		lodsb				; String [si] to al
		cmp	al,0
		jne	loc_ret_1077		; Jump if not equal
		cmp	byte ptr [si],1
		jne	loc_ret_1077		; Jump if not equal
		push	si
		push	dx
		call	sub_0D18
		pop	dx
		pop	si

loc_ret_1077:
		retn
sub_103A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1078	proc	near
		cld				; Clear direction
		push	es
		push	ds
		pop	es
;*		lea	si,data_2F7E		; Load effective addr
		db	 8Dh, 36h, 7Eh, 2Fh	;  Fixup - byte match
;*		lea	di,data_2F88		; Load effective addr
		db	 8Dh, 3Eh, 88h, 2Fh	;  Fixup - byte match
		mov	cx,5
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		mov	di,280h
		call	sub_10C4
		push	es
		push	ds
		pop	es
;*		lea	si,data_2F7E		; Load effective addr
		db	 8Dh, 36h, 7Eh, 2Fh	;  Fixup - byte match
;*		lea	di,data_2F83		; Load effective addr
		db	 8Dh, 3Eh, 83h, 2Fh	;  Fixup - byte match
		mov	cx,5
		repe	cmpsb			; Rep zf=1+cx >0 Cmp [si] to es:[di]
		jz	loc_10C2		; Jump if zero
		dec	di
		dec	si
		mov	al,[di]
		cmp	al,[si]
		jg	loc_10C2		; Jump if >
		inc	cx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
;*		lea	si,data_2F83		; Load effective addr
		db	 8Dh, 36h, 83h, 2Fh	;  Fixup - byte match
;*		lea	di,data_2F88		; Load effective addr
		db	 8Dh, 3Eh, 88h, 2Fh	;  Fixup - byte match
		mov	cx,5
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	es
		mov	di,0A00h
		call	sub_10C4
		retn
loc_10C2:
		pop	es
		retn
sub_1078	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10C4	proc	near
		mov	byte ptr data_2F7D,1
		mov	bx,data_0000_e
loc_10CC:
		mov	al,data_2F88[bx]
		cmp	al,0
		je	loc_10D9		; Jump if equal
		mov	byte ptr data_2F7D,0
loc_10D9:
		cmp	byte ptr data_2F7D,0
		je	loc_10F6		; Jump if equal
		mov	dx,1FFEh
		mov	bp,0E04Eh
		mov	cx,8
		mov	ax,0

locloop_10EC:
		stosw				; Store ax to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_10EC		; Loop if cx > 0

		jmp	short loc_1116
		db	90h
loc_10F6:
		mov	dx,1FFEh
		mov	bp,0E04Eh
		mov	cx,8
		mov	ah,0
		mov	si,ax
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_2541

locloop_110F:
		movsw				; Mov [si] to es:[di]
		add	di,dx
		xchg	dx,bp
		loop	locloop_110F		; Loop if cx > 0

loc_1116:
		add	di,0FEC2h
		inc	bx
		cmp	bx,5
		jl	loc_10CC		; Jump if <
		retn
sub_10C4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1121	proc	near
		push	es
		mov	ax,ds
		mov	es,ax
		mov	cx,8
		mov	di,offset data_2F90
		mov	si,data_0000_e
		mov	ah,0
		cld				; Clear direction
loc_1132:
		mov	al,0
		repe	scasb			; Rep zf=1+cx >0 Scan es:[di] for al
		jz	loc_1148		; Jump if zero
		mov	al,[di-1]
		dec	al
		mov	ah,al
		mov	[di-1],al
		mov	si,di
		jcxz	loc_1148		; Jump if cx=0
		jmp	short loc_1132
loc_1148:
		pop	es
		cmp	si,0
		je	loc_1160		; Jump if equal
		mov	bx,2F90h
		sub	si,bx
		shl	si,1			; Shift w/zeros fill
		cmp	byte ptr data_2FA0,0
		jl	loc_1160		; Jump if <
		jmp	word ptr data_2F96[si]	;*

;==== External Entry into Subroutine ======================================

sub_1160:
loc_1160:
		mov	ax,2
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
sub_1121	endp

			                        ;* No entry point to code
		test	ah,1
		jz	loc_1160		; Jump if zero
		mov	ax,190h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
			                        ;* No entry point to code
		mov	bl,ah
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_2FA2[bx]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
			                        ;* No entry point to code
		mov	bl,ah
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_2FC4[bx]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
			                        ;* No entry point to code
		mov	al,data_2FA1
		inc	al
		cmp	al,8
		jl	loc_11A6		; Jump if <
		mov	al,0
loc_11A6:
		mov	data_2FA1,al
		mov	bl,al
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_2FB4[bx]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		retn
		db	8 dup (0)
		db	 3Fh,0FFh,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 03h,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 3Fh
		db	0FFh,0FFh,0FFh,0C0h, 00h, 00h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FCh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FCh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FCh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FCh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0C0h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0C0h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0C0h
		db	7 dup (0)
		db	 03h,0FFh,0FFh,0F0h, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 00h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FCh, 00h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0C0h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 00h, 03h,0FFh,0FFh,0FFh, 3Fh
		db	0FFh,0FFh,0F0h, 00h, 0Fh,0FFh
		db	0FFh,0FFh, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 0Fh,0FFh,0FFh,0FFh, 3Fh
		db	0FFh,0FFh,0FCh, 00h, 0Fh,0FFh
		db	0FFh,0FFh, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 0Fh,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0FFh
		db	0FFh,0FFh, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 0Fh,0FFh,0FFh,0FFh, 3Fh
		db	0FFh,0FFh,0FCh, 00h, 0Fh,0FFh
		db	0FFh,0FFh, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 03h,0FFh,0FFh,0FFh, 3Fh
		db	0FFh,0FFh,0F0h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0C0h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FCh, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 03h,0FFh,0FFh,0F0h
		db	66 dup (0)
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h
		db	78 dup (0)
		db	 30h, 00h, 00h, 03h, 00h, 00h
		db	 00h, 00h, 00h,0FCh, 00h, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	0FCh, 00h, 00h, 0Fh,0C0h, 00h
		db	 00h, 00h, 00h,0FFh, 00h, 00h
		db	 3Fh,0C0h, 00h, 00h, 00h, 03h
		db	0FFh, 00h, 00h, 3Fh,0F0h, 00h
		db	 00h, 00h, 03h,0FFh,0C0h, 00h
		db	0FFh,0F0h, 00h, 00h, 00h, 03h
		db	0FFh,0C0h, 00h,0FFh,0F0h, 00h
		db	 00h, 00h, 0Fh,0FFh,0F0h, 03h
		db	0FFh,0FCh, 00h, 00h, 00h, 0Fh
		db	0FFh,0FCh, 0Fh,0FFh,0FCh, 00h
		db	 00h, 00h, 0Fh,0FFh,0FCh, 0Fh
		db	0FFh,0FCh, 00h, 00h, 00h, 3Fh
		db	0FFh,0FFh, 3Fh,0FFh,0FFh, 00h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0C0h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 00h, 0Fh,0FFh
		db	0FCh,0FFh,0FFh,0CFh,0FFh,0FCh
		db	 00h, 0Fh,0FFh,0FCh,0FFh,0FFh
		db	0CFh,0FFh,0FCh, 00h, 0Fh,0FFh
		db	0FCh,0FFh,0FFh,0CFh,0FFh,0FCh
		db	 00h, 3Fh,0FFh,0FCh,0FFh,0FFh
		db	0CFh,0FFh,0FFh, 00h, 3Fh,0FFh
		db	0FCh,0FFh,0FFh,0CFh,0FFh,0FFh
		db	 00h,0FFh,0FFh,0FCh,0FFh,0FFh
		db	0CFh,0FFh,0FFh,0C0h,0FFh,0FFh
		db	0FCh,0FFh,0FFh,0CFh,0FFh,0FFh
		db	0C0h, 00h, 00h, 0Fh,0FFh
data_1500	db	0C0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FCh, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0C0h, 00h, 00h, 00h, 00h, 3Fh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FCh, 00h, 00h
		db	 00h, 00h,0FFh,0FFh,0CFh,0FFh
		db	0FCh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FCh
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0C0h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FCh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FFh,0FCh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
data_1615	db	0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 03h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
data_1623	dw	0			; Data table (indexed access)
		db	 03h,0FFh,0FFh,0FFh,0FFh,0FFh
data_162B	dw	0			; Data table (indexed access)
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
		db	0FFh, 00h, 00h, 00h, 03h,0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0CFh,0FFh
data_1645	db	0FFh
		db	 00h, 00h, 00h, 03h,0FFh,0FFh
		db	0CFh,0FFh,0FFh, 00h, 00h, 00h
		db	 03h,0FFh,0FFh,0CFh,0FFh,0FFh
		db	 00h, 00h, 00h, 03h,0FFh,0FFh
		db	0CFh,0FFh,0FFh, 00h, 00h, 00h
		db	 03h,0FFh,0FFh,0CFh,0FFh,0FFh
		db	 00h, 00h, 00h, 03h,0FFh,0FFh
		db	0CFh,0FFh,0FFh
data_1673	db	0			; Data table (indexed access)
		db	 00h, 00h, 03h,0FFh,0FFh,0CFh
		db	0FFh,0FFh, 00h, 00h, 00h, 03h
		db	0FFh,0FFh,0CFh,0FFh,0FFh, 00h
		db	 00h, 00h, 03h,0FFh,0FFh,0CFh
		db	0FFh,0FFh, 00h, 00h, 00h, 03h
data_1692	db	0FFh
		db	0FFh,0CFh,0FFh,0FFh, 00h, 00h
		db	 00h, 07h, 00h, 09h, 00h, 05h
		db	 00h, 0Ah, 00h, 07h, 00h, 07h
		db	 00h, 54h, 03h, 54h, 03h, 02h
		db	 00h, 02h, 00h, 87h, 03h, 87h
		db	 03h, 02h, 00h, 02h, 00h,0BDh
		db	 03h,0BDh, 03h, 87h, 03h, 87h
		db	 03h,0BDh, 03h,0BDh, 03h,0F5h
		db	 03h,0F5h, 03h, 32h, 04h, 32h
		db	 04h, 02h, 00h, 02h, 00h, 72h
		db	 04h, 72h, 04h, 02h, 00h, 02h
		db	 00h,0B5h, 04h,0B5h, 04h,0B5h
		db	 04h,0B5h, 04h, 72h, 04h, 72h
		db	 04h, 72h, 04h
loc_16E4:
;*		jc	loc_16EA		;*Jump if carry Set
		db	 72h, 04h		;  Fixup - byte match
loc_16E6:
		cmc				; Complement carry
		add	si,bp
		add	ax,[bp+si]
		add	[bp+si],al
		add	[bp+si],dh
		add	al,32h			; '2'
		add	al,2
		add	[bp+si],al
		add	[bp+si+4],dh
		jc	loc_16FE		; Jump if carry Set
		xor	al,[si]
		xor	al,[si]
loc_16FE:
		jc	loc_1704		; Jump if carry Set
		jc	loc_1706		; Jump if carry Set
		mov	ch,4
loc_1704:
		mov	ch,4
loc_1706:
		std				; Set direction flag
		add	al,0FDh
		add	al,2
		add	[bp+si],al
		add	[bx+di+5],cl
		dec	cx
		add	ax,2
		add	al,[bx+si]
		cwd				; Word to double word
		add	ax,599h
		cwd				; Word to double word
		add	ax,599h
		dec	cx
		add	ax,549h
		dec	cx
		add	ax,549h
		jc	loc_172C		; Jump if carry Set
		jc	loc_172E		; Jump if carry Set
		add	al,[bx+si]
loc_172C:
		add	al,[bx+si]
loc_172E:
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,2
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,2
		dec	cx
		push	es
		dec	cx
		push	es
		dec	cx
		push	es
		dec	cx
		push	es
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,5EEh
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,5EEh
		jc	loc_174C		; Jump if carry Set
		jc	loc_174E		; Jump if carry Set
		add	al,[bx+si]
loc_174C:
		add	al,[bx+si]
loc_174E:
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,2
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,2
		dec	cx
		push	es
		dec	cx
		push	es
		dec	cx
		push	es
		dec	cx
		push	es
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,5EEh
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,5EEh
		push	cs
		pop	es
		push	cs
		pop	es
		test	al,6
		test	al,6
		dec	cx
		push	es
		dec	cx
		push	es
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		add	ax,5EEh
		cwd				; Word to double word
		add	ax,599h
		dec	cx
		add	ax,549h
		std				; Set direction flag
		add	al,0FDh
		add	al,0B5h
		add	al,0B5h
		add	al,72h			; 'r'
		add	al,72h			; 'r'
		add	al,2
		add	[bp+si],al
		add	[bp+si],dh
		add	al,32h			; '2'
		add	al,2
		add	[bp+si],al
;*		add	ch,dh
		db	 00h,0F5h		;  Fixup - byte match
		add	si,bp
		add	ax,[bp+si]
		add	[bp+si],al
		add	ds:data_8703_e[bx],al
		add	ax,[bp+si]
		add	[bp+si],al
		add	[si+3],dl
		push	sp
		add	dx,[si+3]
		push	sp
		add	dx,[si+3]
		push	sp
		add	dx,[si+3]
		push	sp
		add	ax,[bp+si]
		add	[bp+di],dl
		or	[bp+si+79h],sp
		add	[di],cl
		or	cx,[bp+si+6Fh]
		push	6E6Eh
		jns	loc_17E6		; Jump if not sign
		push	dx
		outsw				; Out [si] to port dx
		jz	$+76h			; Jump if zero
		db	 65h, 6Eh, 20h, 00h, 03h, 10h
		db	'PRESS space bar FOR KE'
loc_17E6:
		pop	cx
		inc	dx
		dec	di
		inc	cx
		push	dx
		inc	sp
		and	[bx+si+4Ch],dl
		inc	cx
		pop	cx
		add	[bp+si],al
		adc	cl,[bx+52h]
		db	' joystick button FOR JOYSTICK PL'
		db	'AY', 0
		db	 06h, 18h
		db	'     COPYWRONG 1984 PIL     '
		db	 00h, 03h, 0Ch
		db	'PRES'
		db	'S space bar FOR KEYBOARD PLAY'
		db	 00h, 02h, 0Eh
		db	'OR joystick button FOR JOYSTICK '
		db	'PLAY', 0
		db	'SCORE', 0Dh, 0Ah, '     0', 0Dh, 0Ah
		db	0Ah, 0Ah, 0Ah, ' HIGH', 0Dh, 0Ah, ' '
		db	'SCORE', 0Dh, 0Ah, '     0!YDAER'
		db	 03h, 00h, 00h,0C8h, 0Ch, 00h
		db	 20h, 78h, 1Ch, 00h, 20h, 96h
		db	 1Ch, 00h, 28h, 5Ah, 1Ch, 00h
		db	 28h, 78h, 3Ch, 00h, 40h, 3Ch
		db	 3Ch, 00h, 40h, 3Ch, 3Ch, 00h
		db	 40h, 1Eh, 3Ch, 00h, 50h, 0Ah
		db	 3Ch, 00h, 80h, 14h, 3Ch, 00h
		db	 80h, 05h, 3Ch, 00h, 80h, 05h
		db	 3Ch,0FFh,0FFh, 00h, 00h, 00h
		db	 7Ah, 2Eh, 19h, 0Eh, 00h, 7Ah
		db	 2Eh, 0Eh, 0Eh
		db	114 dup (0)
		db	 02h, 6Dh, 30h, 1Ah, 26h, 00h
		db	 6Dh, 30h, 0Eh, 0Eh, 00h, 04h
		db	 00h
		db	111 dup (0)
		db	 03h, 8Bh, 2Eh, 1Ah, 26h, 00h
		db	 8Bh, 2Eh, 0Eh, 0Eh, 00h, 04h
		db	0
data_19EA	db	0
		db	111 dup (0)
		db	 92h, 2Eh, 19h, 26h, 00h, 92h
		db	 2Eh, 0Eh, 0Eh
		db	114 dup (0)
		db	 02h,0ADh, 2Ch, 1Ah, 26h, 00h
		db	0ADh, 2Ch, 0Eh, 0Eh, 00h, 04h
		db	116 dup (0)
		db	 55h, 00h, 00h, 00h, 40h, 40h
		db	 40h, 40h, 01h, 01h, 01h, 01h
		db	 00h, 00h, 00h, 55h, 05h, 10h
		db	 40h, 40h, 50h, 04h, 01h, 01h
		db	 40h, 40h, 10h, 05h, 01h, 01h
		db	 04h, 50h, 15h, 00h, 00h, 00h
		db	 40h, 40h, 40h, 00h, 00h, 01h
		db	 01h, 01h, 00h, 00h, 00h, 54h
		db	 54h, 00h, 00h, 00h, 00h, 40h
		db	 40h, 40h, 01h, 01h, 01h, 00h
		db	 00h, 00h, 00h, 15h, 40h, 00h
		db	 00h, 00h, 01h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 40h, 00h, 00h
		db	 00h, 01h, 15h, 40h, 00h, 00h
		db	 54h, 01h, 00h, 00h, 00h, 00h
		db	 40h, 15h, 00h, 00h, 01h, 54h
		db	 00h, 00h, 01h, 01h, 00h, 00h
		db	 40h, 40h, 01h, 01h, 00h, 00h
		db	 40h, 40h, 00h, 00h, 02h, 02h
		db	 02h, 02h, 19h, 15h
		db	8 dup (1)
		db	 16h, 1Ah, 19h, 15h, 01h, 01h
		db	 01h, 01h, 01h, 01h, 01h, 01h
		db	 16h, 1Ah, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 19h, 15h, 01h, 01h
		db	14 dup (1)
		db	 16h, 1Ah, 03h
		db	10 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	18 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	18 dup (0)
		db	2, 3
		db	10 dup (0)
		db	7, 8, 0
		db	9 dup (0)
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	18 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	5, 6
		db	10 dup (0)
		db	5, 6, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	5, 6, 0, 0, 0, 0
		db	5, 1, 1, 6, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0
data_1D19	db	0
		db	0, 0, 0, 3, 0, 0
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 0, 0, 3
		db	0, 0, 0, 0, 2, 3
		db	0, 0, 0, 0, 2, 3
		db	0
		db	9 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2
data_1D61	db	0
		db	0, 0, 0, 0, 0, 3
		db	0, 0, 0, 0, 2, 3
		db	0, 0, 0, 0, 2, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0
		db	8 dup (0)
		db	 14h, 0Ah, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 03h, 00h
		db	 00h, 00h, 00h, 02h, 03h, 00h
		db	 00h, 00h, 00h, 02h, 03h, 00h
		db	 00h, 00h, 00h, 05h, 01h, 01h
		db	 01h, 01h, 0Dh, 00h, 03h, 00h
		db	 00h, 00h, 00h, 02h
data_1DD1	db	0
		db	0, 0, 0, 0, 0, 3
		db	0, 0, 0, 0, 2, 0
		db	0, 0, 0, 0, 0, 3
		db	0, 0, 0, 0, 2, 3
		db	0, 0, 0, 0, 2, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0, 0, 0, 0
		db	7, 4, 4, 4, 4, 4
		db	4
data_1E09	db	8
		db	0, 0, 0, 0, 7, 4
		db	4, 4, 4, 4, 4, 8
		db	0, 0, 0, 0, 7, 4
		db	4, 4, 4, 4, 4, 8
		db	0, 0, 0, 0, 7, 8
		db	0, 0, 0, 0, 7, 4
		db	4, 8, 0, 0, 0, 0
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0
		db	53 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0
		db	53 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0
		db	53 dup (0)
		db	 02h, 03h, 00h, 00h, 00h, 00h
		db	 02h, 0Fh, 13h, 00h
		db	52 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 9, 1, 1, 1
		db	1, 6, 0
data_1F3B	db	0
data_1F3C	db	0
		db	0, 5, 6, 0, 0, 0
		db	0, 5, 1, 1, 1, 1
		db	1, 1, 6, 0, 0, 0
		db	0, 5
		db	8 dup (1)
data_1F59	db	1
		db	 01h, 01h, 01h, 06h, 00h, 00h
		db	 00h, 00h, 05h, 01h, 01h, 06h
		db	 00h, 00h, 00h, 00h, 02h, 03h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 10h, 04h, 04h, 04h, 04h, 08h
		db	 00h, 00h, 00h, 00h, 02h, 03h
		db	 00h, 00h, 00h, 00h, 07h, 04h
		db	 04h, 04h, 04h, 04h, 04h, 08h
		db	 00h, 00h, 00h, 00h, 07h, 04h
		db	 04h, 04h, 04h, 0Ch, 00h, 00h
		db	 10h, 04h, 04h, 04h, 04h, 08h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 00h, 03h, 00h, 00h, 00h, 00h
		db	 02h, 03h, 00h, 00h, 00h, 00h
		db	 02h, 0Bh, 11h
		db	9 dup (0)
		db	2, 3
		db	21 dup (0)
		db	 12h, 0Eh, 0Bh, 11h
		db	9 dup (0)
		db	2, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	2, 3
		db	22 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	2, 3
		db	22 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 7, 8, 0
		db	9 dup (0)
		db	7, 8, 0
		db	21 dup (0)
		db	7, 8, 0
		db	9 dup (0)
		db	7, 4, 4, 8, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	5, 6, 0
		db	9 dup (0)
		db	5, 6, 0, 0, 0, 0
		db	5, 1, 1, 1, 1, 1
		db	1, 6
		db	10 dup (0)
		db	5, 6, 0
		db	11 dup (0)
		db	2, 3
		db	0
data_20E1	db	0
		db	8 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	10 dup (0)
		db	2, 3
		db	12 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	10 dup (0)
		db	2, 3
		db	12 dup (0)
		db	2, 3
		db	0, 0, 0, 0, 0
data_2161	db	0
		db	 00h, 00h, 00h, 14h, 0Ah, 03h
		db	 00h
		db	8 dup (0)
data_2171	db	14h
		db	 0Ah, 03h, 00h, 00h, 00h, 00h
		db	 02h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 1Dh
		db	9 dup (0)
		db	 14h, 0Ah, 03h, 00h
		db	10 dup (0)
		db	 14h, 0Ah, 03h, 00h, 00h, 00h
		db	 00h, 05h, 01h, 01h, 01h, 01h
		db	 0Dh, 00h, 03h, 00h, 00h, 00h
		db	 00h, 05h, 01h, 01h, 01h, 01h
		db	 0Dh, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
data_21BB	db	0
		db	 00h, 1Dh, 00h, 00h, 00h, 00h
		db	 05h, 01h, 01h, 01h, 01h, 0Dh
		db	 00h, 03h, 00h, 00h, 00h, 00h
		db	 05h, 01h, 01h, 01h, 01h, 01h
		db	 01h, 0Dh, 00h, 03h, 00h, 00h
		db	 00h, 00h, 07h, 04h, 04h, 04h
		db	 04h, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 00h, 07h, 04h, 04h, 04h
		db	 04h, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 1Dh, 00h, 00h
		db	 00h, 00h, 07h, 04h, 04h, 04h
		db	 04h, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 00h, 07h, 04h, 04h, 04h
		db	 04h, 04h, 04h, 0Ch, 00h, 03h
		db	 00h
		db	8 dup (0)
		db	 12h, 0Eh, 03h, 00h
		db	8 dup (0)
		db	 12h, 0Eh, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 1Dh
		db	9 dup (0)
		db	 12h, 0Eh, 03h, 00h
		db	10 dup (0)
		db	 12h, 0Eh, 03h, 00h
		db	9 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	10 dup (0)
		db	2, 3
		db	12 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	10 dup (0)
		db	2, 3
		db	12 dup (0)
		db	2, 3
		db	10 dup (0)
		db	7, 8, 0
		db	9 dup (0)
		db	7, 8, 0, 0, 0, 0
		db	7, 4, 4, 4, 4, 4
		db	4, 8, 0
		db	9 dup (0)
		db	7, 8, 0
		db	11 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	5, 6
		db	10 dup (0)
		db	5, 6, 0
		db	21 dup (0)
		db	5, 6, 0
		db	9 dup (0)
		db	5, 1, 1, 6, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	2, 3
		db	22 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	2, 3
		db	22 dup (0)
		db	2, 3
		db	10 dup (0)
		db	 02h, 00h, 00h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 0Fh, 13h, 00h
		db	8 dup (0)
		db	2, 3
		db	21 dup (0)
		db	 14h, 0Ah, 0Fh, 13h, 00h
		db	8 dup (0)
		db	 02h, 00h, 00h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 09h, 01h
		db	 01h, 01h, 01h, 06h, 00h, 00h
		db	 00h, 00h, 02h, 03h, 00h, 00h
		db	 00h, 00h, 05h, 01h, 01h, 01h
		db	 01h, 01h, 01h, 06h, 00h, 00h
		db	 00h, 00h, 05h, 01h, 01h, 01h
		db	 01h, 0Dh, 00h, 00h, 09h, 01h
		db	 01h, 01h, 01h, 06h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 03h
		db	 00h, 00h, 00h, 00h, 02h, 03h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 10h, 04h, 04h, 04h, 04h, 08h
		db	 00h, 00h, 00h, 00h, 07h, 08h
		db	 00h, 00h, 00h, 00h, 07h, 04h
		db	 04h, 04h, 04h, 04h, 04h, 08h
		db	 00h, 00h, 00h, 00h, 07h
		db	12 dup (4)
		db	 08h, 00h, 00h, 00h, 00h, 07h
		db	 04h, 04h, 08h, 00h, 00h, 00h
		db	 00h, 02h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 0Bh, 11h
		db	53 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0
		db	53 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 3, 0
		db	53 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2
data_2541	db	3
		db	0
		db	53 dup (0)
		db	 02h, 03h, 00h, 00h, 00h, 00h
		db	 02h, 03h, 00h, 00h, 00h, 00h
		db	 05h, 01h, 01h, 01h, 01h, 01h
		db	 01h, 06h, 00h, 00h, 00h, 00h
		db	 05h, 01h, 01h, 01h, 01h, 01h
		db	 01h, 06h, 00h, 00h, 00h, 00h
		db	 05h, 01h, 01h, 01h, 01h, 01h
		db	 01h, 06h, 00h, 00h, 00h, 00h
		db	 05h, 06h, 00h, 00h, 00h, 00h
		db	 05h, 01h, 01h, 06h, 00h, 00h
		db	 00h, 00h, 02h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 03h, 00h, 00h
		db	 00h, 00h, 07h, 04h, 04h, 04h
		db	 04h, 0Ch, 00h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 03h, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 03h
		db	 00h
data_25F1	db	0			; Data table (indexed access)
data_25F2	db	0
		db	0, 2, 3, 0, 0, 0
		db	0, 2, 3, 0
		db	8 dup (0)
		db	 12h, 0Eh, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 03h, 00h
		db	 00h, 00h, 00h, 02h, 03h, 00h
		db	 00h, 00h, 00h, 02h, 03h, 00h
		db	9 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 3, 0, 0, 0, 0
		db	2, 0, 0, 3, 0, 0
		db	0, 0, 2, 3, 0, 0
		db	0, 0, 7, 8, 0
		db	9 dup (0)
		db	7, 8, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	7, 8, 0, 0, 0, 0
		db	7, 4, 4, 8, 0, 0
		db	0, 0, 2, 3, 0
		db	9 dup (0)
		db	5, 6, 0
		db	9 dup (0)
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	18 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	18 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 3
		db	10 dup (0)
		db	2, 0, 0, 0, 0, 0
		db	0, 3, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 3
		db	18 dup (0)
		db	 02h, 1Bh, 17h
		db	8 dup (4)
		db	 18h, 1Ch, 1Bh, 17h
		db	8 dup (4)
		db	 18h, 1Ch, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 00h, 00h, 00h
		db	 00h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 1Bh, 17h
		db	16 dup (4)
		db	 18h, 1Ch, 98h, 16h,0ACh, 16h
		db	 4Ah, 19h, 5Eh, 19h,0BBh, 00h
		db	0E3h, 00h, 7Bh, 1Dh,0A3h, 1Dh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 03h,0C0h, 03h,0C0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0F0h
		db	 3Fh,0FCh
		db	8 dup (0FFh)
		db	 3Fh,0FCh, 0Fh,0F0h
		db	16 dup (0)
		db	1, 0
		db	121 dup (0)
data_28A0	db	0			; Data table (indexed access)
		db	396 dup (0)
data_2A2D	db	0			; Data table (indexed access)
data_2A2E	dw	0			; Data table (indexed access)
data_2A30	dw	0			; Data table (indexed access)
		db	0
data_2A33	dw	0			; Data table (indexed access)
data_2A35	db	0			; Data table (indexed access)
data_2A36	db	0			; Data table (indexed access)
data_2A37	db	0			; Data table (indexed access)
data_2A38	db	0			; Data table (indexed access)
data_2A39	db	0
		db	55 dup (0)
data_2A71	db	0
		db	12 dup (0)
data_2A7E	db	0
		db	315 dup (0)
		db	1, 0
		db	13 dup (0)
		db	2, 2, 2, 2, 0, 0
		db	3, 2, 2, 2, 0, 0
		db	0, 0, 0, 1, 0, 0
		db	0, 0, 0, 2, 2, 2
		db	2, 2, 3, 2, 2, 0
		db	2, 0, 0, 2, 0, 0
		db	2, 0, 0, 2, 0, 0
		db	0, 0, 0, 1, 0, 0
		db	0, 0, 0, 2, 0, 0
		db	2, 0, 0, 0, 2, 0
		db	2, 0, 0, 2, 2, 2
		db	2, 0, 0, 2, 0, 0
		db	0, 0, 0, 1, 0, 0
		db	0, 0, 0, 2, 0, 0
		db	2
data_2C1E	dw	0			; Data table (indexed access)
		db	0, 2, 0, 2, 0
data_2C25	db	0			; Data table (indexed access)
		db	2, 0, 0
data_2C29	db	0
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 2, 0, 0, 2
		db	0, 0, 0, 2, 0, 2
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 2, 0, 0, 2
		db	0, 0, 0, 2, 0, 2
		db	0
data_2C61	db	0
		db	2
		db	25 dup (2)
		db	0, 2, 0, 0, 0, 0
		db	0, 2, 0, 0, 2, 0
		db	0, 0, 0, 0, 1
		db	8 dup (0)
		db	2, 0, 0, 0
data_2C99	db	2
data_2C9A	db	0
data_2C9B	dw	2
		db	0, 0, 0, 0, 2, 0
		db	0, 2, 0, 0, 0, 0
		db	0, 1
		db	8 dup (0)
		db	2, 0, 0, 0, 2, 0
		db	2, 0, 0
data_2CBC	db	2			; Data table (indexed access)
data_2CBD	db	2			; Data table (indexed access)
		db	2, 2, 0
data_2CC1	dw	200h			; Data table (indexed access)
		db	1
		db	1, 1, 1, 1, 1
data_2CC9	db	1
data_2CCA	dw	101h
data_2CCC	db	0
data_2CCD	db	0
data_2CCE	dw	202h
		db	2, 2, 0, 0, 0, 2
		db	0, 2, 0, 0, 2, 0
		db	0, 2, 0, 0, 2, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 0, 0, 2, 0
		db	0, 2, 0, 0, 0, 2
		db	0, 2, 2, 2, 2, 0
		db	0, 2, 2, 2, 2, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 1, 1, 2, 0
data_2D0C	dw	200h			; Data table (indexed access)
		db	2, 2
data_2D10	dw	202h			; Data table (indexed access)
		db	0, 2, 0, 0, 0, 0
		db	0, 1, 0, 0, 0, 0
		db	0, 1, 0, 0, 0, 0
data_2D24	dw	100h
data_2D26	db	0
data_2D27	dw	0
data_2D29	db	0			; Data table (indexed access)
data_2D2A	db	0			; Data table (indexed access)
		db	2, 0, 0
data_2D2E	db	0
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 2, 2, 2, 2
		db	0, 0, 2, 2, 2, 2
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 1, 1, 1, 2
		db	0, 0, 2, 2, 2, 2
		db	2, 0, 2, 0, 0, 2
		db	0, 0, 2, 0, 0, 2
		db	0, 0, 1, 0, 0, 0
		db	0, 0, 1, 0, 0, 2
		db	0, 0, 2, 0, 0, 0
		db	2, 0, 2, 0, 0, 2
		db	2, 2, 2, 0, 0, 2
		db	1
		db	8 dup (1)
		db	0, 0, 2, 2, 2, 2
		db	0, 0, 0, 2, 0, 2
		db	0, 0, 0, 0, 0, 2
		db	0, 0, 2, 0, 0, 0
		db	0, 0, 1
		db	8 dup (0)
		db	2, 0, 0, 0, 2, 0
		db	2, 0, 0, 0, 0, 0
		db	2, 0, 0, 2, 0, 0
		db	0, 0, 0, 1
		db	8 dup (0)
		db	2, 0, 0, 0, 2, 0
		db	2, 0, 0, 2
		db	25 dup (2)
		db	0, 2, 0, 0, 2, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 0, 0, 0, 1, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 2, 0, 0, 0, 2
		db	0, 2, 0, 0, 2, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 0, 0, 0, 1, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 2, 0, 0, 0, 2
		db	0, 2, 0, 0, 2, 2
		db	2, 2, 0, 0, 2, 0
		db	0, 0, 0, 0, 1, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 2, 0, 0, 0, 2
		db	0, 2, 0, 0, 2, 0
		db	0, 2, 0, 0, 2, 0
		db	0, 0, 0, 0, 1, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 2, 0, 0, 0, 2
		db	0, 2, 2, 2, 2, 0
		db	0, 3, 2, 2, 2, 0
data_2E86	db	0
		db	0, 0, 0, 1, 0, 0
		db	0, 0, 0, 2, 2, 2
		db	2, 2, 3, 2, 2, 0
		db	15 dup (0)
		db	1, 0
		db	28 dup (0)
		db	1, 0
		db	28 dup (0)
		db	1, 0
		db	28 dup (0)
		db	1, 0
		db	0, 0
data_2F06	db	0
		db	25 dup (0)
		db	1, 0
		db	15 dup (0)
		db	 0Fh, 00h, 00h, 3Ch, 0Fh,0C0h
		db	 00h,0FCh, 0Fh,0F0h, 03h,0FCh
		db	 0Fh
data_2F3E	dw	0FFCh
data_2F40	db	0FCh
data_2F41	dw	0FF0Fh
data_2F43	db	3Fh
data_2F44	db	0FCh
data_2F45	db	3
		db	0FFh,0FFh,0F0h, 03h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0FCh
		db	10 dup (0)
		db	0C0h, 00h,0C0h, 03h,0C0h, 00h
		db	0F0h, 03h,0F0h, 03h,0F0h, 0Fh
		db	0F0h, 03h,0FCh, 0Fh,0FCh, 0Fh
		db	0FCh, 0Fh,0FCh, 0Fh,0FCh, 0Fh
		db	0FFh, 3Fh,0FCh, 0Fh,0FFh, 3Fh
		db	0FCh
data_2F7D	db	3
data_2F7E	db	0FFh
		db	0FFh,0F0h, 03h,0FFh
data_2F83	db	0FFh
		db	0F0h, 00h,0FFh,0FFh
data_2F88	db	0C0h			; Data table (indexed access)
		db	 00h, 0Fh,0FCh, 00h
data_2F8D	dw	0
data_2F8F	db	0
data_2F90	db	0
data_2F91	db	0
data_2F92	db	0Fh
data_2F93	db	0FCh
		db	0, 0
data_2F96	dw	0FFFFh			; Data table (indexed access)
		db	0C0h, 03h,0FFh,0FFh,0F0h, 03h
		db	0FFh,0FFh
data_2FA0	db	0F0h
data_2FA1	db	0Fh
data_2FA2	dw	0FFFFh			; Data table (indexed access)
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 0Fh
		db	0FFh,0FFh,0FCh, 0Fh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh
data_2FB4	dw	3FCh			; Data table (indexed access)
		db	0FFh,0FFh,0F0h, 03h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0FCh
data_2FC4	dw	0			; Data table (indexed access)
		db	8 dup (0)
		db	0C0h, 00h,0C0h, 03h,0C0h, 00h
		db	0F0h, 03h,0F0h, 03h,0F0h, 0Fh
		db	0F0h, 03h,0FCh, 0Fh,0FCh, 0Fh
		db	0FCh, 0Fh,0FCh, 0Fh,0FCh, 0Fh
		db	0FFh, 3Fh,0FCh, 0Fh,0FFh, 3Fh
		db	0FCh, 03h,0FFh,0FFh,0F0h, 03h
		db	0FFh,0FFh,0F0h, 00h
data_2FF6	db	0FFh
		db	0FFh,0C0h, 00h, 0Fh,0FCh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	0FCh, 00h, 00h,0FFh,0FFh,0C0h
		db	 03h,0FFh,0FFh,0F0h, 03h,0FFh
		db	0FFh,0F0h, 0Fh,0FFh, 3Fh,0FCh
		db	 0Fh,0FCh, 0Fh,0FCh, 0Fh,0F0h
		db	 03h,0FCh, 0Fh,0C0h, 00h,0FCh
		db	 0Fh, 00h, 00h, 3Ch, 00h
		db	20 dup (0)
		db	 0Fh,0FCh, 00h, 00h,0FFh,0FFh
		db	0C0h, 03h,0FFh,0FFh,0F0h, 03h
		db	0FFh,0FFh,0F0h, 0Fh,0FFh, 3Fh
		db	0FCh, 0Fh,0FFh, 3Fh,0FCh, 0Fh
		db	0FCh, 0Fh,0FCh, 0Fh,0FCh, 0Fh
		db	0FCh, 0Fh,0F0h, 03h,0FCh, 03h
		db	0F0h, 03h,0F0h, 03h,0C0h, 00h
		db	0F0h, 00h,0C0h, 00h,0C0h
		db	9 dup (0)
		db	 0Fh,0FCh, 00h, 00h,0FFh,0FFh
		db	0C0h, 03h,0FFh,0FFh,0F0h, 03h
		db	0FFh,0FFh,0F0h, 0Fh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 0Fh
		db	0FFh,0FFh,0FCh, 0Fh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 03h
		db	0FFh,0FFh,0F0h, 03h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FCh, 00h, 00h
		db	0FFh,0FFh,0C0h, 03h,0FFh,0FFh
		db	0F0h, 03h,0FFh,0FFh,0F0h, 0Fh
		db	0FFh, 3Fh,0FCh, 0Fh,0FFh, 3Fh
		db	0FCh, 0Fh,0FCh, 0Fh,0FCh, 0Fh
		db	0FCh, 0Fh,0FCh, 0Fh,0F0h, 03h
		db	0FCh, 03h,0F0h, 03h,0F0h, 03h
		db	0C0h, 00h,0F0h, 00h,0C0h, 00h
		db	0C0h
		db	9 dup (0)
		db	 0Fh,0FCh, 00h, 00h, 0Fh,0FFh
		db	0C0h, 00h, 03h,0FFh,0F0h, 00h
		db	 00h,0FFh,0F0h, 00h, 00h, 3Fh
		db	0FCh, 00h, 00h, 0Fh,0FCh, 00h
		db	 00h, 03h,0FCh, 00h, 00h, 0Fh
		db	0FCh, 00h, 00h, 3Fh,0FCh, 00h
		db	 00h,0FFh,0F0h, 00h, 03h,0FFh
		db	0F0h, 00h, 0Fh,0FFh,0C0h, 00h
		db	 0Fh,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FCh, 00h, 00h
		db	0FFh,0FFh,0C0h, 03h,0FFh,0FFh
		db	0F0h, 00h, 3Fh,0FFh,0F0h, 00h
		db	 03h,0FFh,0FCh, 00h, 00h, 3Fh
		db	0FCh, 00h, 00h, 03h,0FCh, 00h
		db	 00h, 3Fh,0FCh, 00h, 03h,0FFh
		db	0FCh, 00h, 3Fh,0FFh,0F0h, 03h
		db	0FFh,0FFh,0F0h, 00h,0FFh,0FFh
		db	0C0h, 00h, 0Fh,0FCh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0FCh
		db	 00h, 00h,0FFh,0FFh,0C0h, 03h
		db	0FFh,0FFh,0F0h, 03h,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh,0FCh, 0Fh
		db	0FFh,0FFh,0FCh, 0Fh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 0Fh
		db	0FFh,0FFh,0FCh, 03h,0FFh,0FFh
		db	0F0h, 03h,0FFh,0FFh,0F0h, 00h
		db	0FFh,0FFh,0C0h, 00h, 0Fh,0FCh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0FCh, 00h, 00h,0FFh,0FFh
		db	0C0h, 03h,0FFh,0FFh,0F0h, 00h
		db	 3Fh,0FFh,0F0h, 00h, 03h,0FFh
		db	0FCh, 00h, 00h, 3Fh,0FCh, 00h
		db	 00h, 03h,0FCh, 00h, 00h, 3Fh
		db	0FCh, 00h, 03h,0FFh,0FCh, 00h
		db	 3Fh,0FFh,0F0h, 03h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FCh, 00h, 00h
		db	0FFh,0FCh, 00h, 03h,0FFh,0F0h
		db	 00h, 03h,0FFh,0C0h, 00h, 0Fh
		db	0FFh, 00h, 00h, 0Fh,0FCh, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h, 0Fh
		db	0FCh, 00h, 00h, 0Fh,0FFh, 00h
		db	 00h, 03h,0FFh,0C0h, 00h, 03h
		db	0FFh,0F0h, 00h, 00h,0FFh,0FCh
		db	 00h, 00h, 0Fh,0FCh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0FCh
		db	 00h, 00h,0FFh,0FFh,0C0h, 03h
		db	0FFh,0FFh,0F0h, 03h,0FFh,0FFh
		db	 00h, 0Fh,0FFh,0F0h, 00h, 0Fh
		db	0FFh, 00h, 00h, 0Fh,0F0h, 00h
		db	 00h, 0Fh,0FFh, 00h, 00h, 0Fh
		db	0FFh,0F0h, 00h, 03h,0FFh,0FFh
		db	 00h, 03h,0FFh,0FFh,0F0h, 00h
		db	0FFh,0FFh,0C0h, 00h, 0Fh,0FCh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0FCh, 00h, 00h,0FFh,0FFh
		db	0C0h, 03h,0FFh,0FFh,0F0h, 03h
		db	0FFh,0FFh,0F0h, 0Fh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 0Fh
		db	0FFh,0FFh,0FCh, 0Fh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 03h
		db	0FFh,0FFh,0F0h, 03h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FCh, 00h, 00h
		db	0FFh,0FFh,0C0h, 03h,0FFh,0FFh
		db	0F0h, 03h,0FFh,0FFh, 00h, 0Fh
		db	0FFh,0F0h, 00h, 0Fh,0FFh, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h
loc_3285:
		db	 0Fh,0FFh, 00h, 00h, 0Fh,0FFh
		db	0F0h, 00h
loc_328D:
		add	di,di
		inc	word ptr [bx+si]
		add	di,di
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
;*		inc	ax
		db	0FFh,0C0h		;  Fixup - byte match
		add	[bx],cl
		cld				; Clear direction
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 05h, 50h, 00h
loc_32A5:
		add	[di+55h],dl
		add	[bx+di],al
		add	ax,4050h
loc_32AD:
		pop	es
		or	ax,0D070h
		pop	es
		std				; Set direction flag
		jg	loc_3285		; Jump if >
		pop	ss
		std				; Set direction flag
		jg	loc_328D		; Jump if >
		adc	ax,5FF5h
		push	sp
		adc	ax,5555h
		push	sp
loc_32C1:
		add	[di],al
		push	ax
		add	[bx+si],al
		push	bp
		push	bp
		add	[bx+di],al
		push	bp
		push	bp
		inc	ax
		add	ax,5FF5h
		push	ax
		pop	es
		std				; Set direction flag
		jg	loc_32A5		; Jump if >
		pop	ss
		std				; Set direction flag
		jg	loc_32AD		; Jump if >
		pop	ss
		or	ax,0D470h
		adc	ax,5005h
		push	sp
loc_32E1:
		add	[di],al
		push	ax
		add	[bx+si],al
		push	bp
		push	bp
		add	[bx+di],al
		cmc				; Complement carry
		pop	di
		inc	ax
		pop	es
		std				; Set direction flag
		jg	loc_32C1		; Jump if >
		add	al,3Dh			; '='
		inc	bx
		rcl	byte ptr [si],1		; Rotate thru carry
		cmp	ax,0D443h
		adc	ax,5FF5h
		push	sp
		adc	ax,5555h
		push	sp
		add	[di],al
		push	ax
		add	[bx+si],al
		push	bp
		push	bp
		add	[bx+di],al
		cmc				; Complement carry
		pop	di
		inc	ax
		pop	es
		std				; Set direction flag
		jg	loc_32E1		; Jump if >
		pop	es
		sar	word ptr [si+10h],17h	; Shift w/sign fill
		sar	word ptr [si+14h],15h	; Shift w/sign fill
		cmc				; Complement carry
		pop	di
		push	sp
		adc	ax,5555h
		push	sp
		adc	ax,5555h
		push	sp
		adc	ax,5555h
		push	sp
		adc	ax,5555h
		push	sp
		adc	ax,5555h
		push	sp
		adc	ax,5145h
		push	sp
		add	ax,4001h
		push	ax
		adc	al,54h			; 'T'
		adc	ax,1014h
		adc	al,14h
		add	al,0
		pop	es
		jo	$+2			; delay for I/O
;*		add	ch,bl
		db	 00h,0DDh		;  Fixup - byte match
		db	0DDh, 00h, 03h, 07h, 70h, 40h
		db	 0Fh, 0Dh,0F0h,0D0h, 07h,0FFh
		db	 7Fh,0F0h, 1Fh,0FDh,0FFh,0DCh
		db	 37h,0F7h, 7Fh, 74h, 1Dh,0DDh
		db	0DDh,0DCh, 00h, 07h, 70h, 00h
		db	 00h,0DDh,0DDh, 00h, 03h, 77h
		db	 77h, 40h, 0Dh,0FDh,0DFh,0D0h
		db	 07h,0FFh, 7Fh,0F0h, 1Fh,0FDh
		db	0FFh,0DCh, 37h, 0Fh, 70h,0F4h
		db	 1Dh, 0Dh,0D0h,0DCh, 00h, 07h
		db	 70h, 00h, 00h,0DDh,0DDh, 00h
		db	 03h,0F7h, 7Fh, 40h, 0Fh,0FDh
		db	0FFh,0D0h, 04h, 3Fh, 43h,0F0h
		db	 1Ch, 3Dh,0C3h,0DCh, 37h,0F7h
		db	 7Fh, 74h, 1Dh,0DDh,0DDh,0DCh
		db	 00h, 07h, 70h, 00h, 00h,0DDh
		db	0DDh, 00h, 03h,0F7h, 7Fh, 40h
		db	 0Fh,0FDh,0FFh,0D0h, 07h,0C3h
		db	 7Ch, 30h, 1Fh,0C1h,0FCh, 1Ch
		db	 37h,0F7h, 7Fh, 74h, 1Dh,0DDh
		db	0DDh,0DCh, 37h, 77h, 77h, 74h
		db	 1Dh,0DDh,0DDh,0DCh, 37h, 77h
		db	 77h, 74h, 1Dh,0DDh,0DDh,0DCh
		db	 37h, 47h, 73h, 74h, 0Dh, 01h
		db	0C0h,0D0h, 34h, 74h, 37h, 34h
		db	 10h, 1Ch, 1Ch, 0Ch, 00h, 0Ah
		db	0A0h, 00h, 00h,0AAh,0AAh, 00h
		db	 02h, 0Ah,0A0h, 80h, 0Bh, 0Eh
		db	0B0h,0E0h, 0Bh,0FEh,0BFh,0E0h
		db	 2Bh,0FEh,0BFh,0E8h, 2Ah,0FAh
		db	0AFh,0A8h, 2Ah,0AAh,0AAh,0A8h
		db	 00h, 0Ah,0A0h, 00h, 00h,0AAh
		db	0AAh, 00h, 02h,0AAh,0AAh, 80h
		db	 0Ah,0FAh,0AFh,0A0h, 0Bh,0FEh
		db	0BFh,0E0h, 2Bh,0FEh,0BFh,0E8h
		db	 2Bh, 0Eh,0B0h,0E8h, 2Ah, 0Ah
		db	0A0h,0A8h, 00h, 0Ah,0A0h, 00h
		db	 00h,0AAh,0AAh, 00h, 02h,0FAh
		db	0AFh, 80h, 0Bh,0FEh,0BFh,0E0h
		db	 08h, 3Eh, 83h,0E0h, 28h, 3Eh
		db	 83h,0E8h, 2Ah,0FAh,0AFh,0A8h
		db	 2Ah,0AAh,0AAh,0A8h, 00h, 0Ah
		db	0A0h, 00h, 00h,0AAh,0AAh, 00h
		db	 02h,0FAh,0AFh, 80h, 0Bh,0FEh
		db	0BFh,0E0h, 0Bh,0C2h,0BCh, 20h
		db	 2Bh,0C2h,0BCh, 28h, 2Ah,0FAh
		db	0AFh,0A8h, 2Ah,0AAh,0AAh,0A8h
		db	 2Ah,0AAh,0AAh,0A8h, 2Ah,0AAh
		db	0AAh,0A8h, 2Ah,0AAh,0AAh,0A8h
		db	 2Ah,0AAh,0AAh,0A8h, 2Ah, 8Ah
		db	0A2h,0A8h, 0Ah, 02h, 80h,0A0h
		db	 28h,0A8h, 2Ah, 28h, 20h, 28h
		db	 28h, 08h, 00h, 0Bh,0B0h, 00h
		db	 00h,0EEh,0EEh, 00h, 03h, 0Bh
		db	0B0h, 80h, 0Fh, 0Eh,0F0h,0E0h
		db	 0Bh,0FFh,0BFh,0F0h, 2Fh,0FEh
		db	0FFh,0ECh, 3Bh,0FBh,0BFh,0B8h

locloop_349D:
		db	 2Eh,0EEh,0EEh,0ECh, 00h, 0Bh
		db	0B0h, 00h, 00h,0EEh,0EEh, 00h
		db	 03h,0BBh,0BBh, 80h, 0Eh,0FEh
		db	0EFh,0E0h, 0Bh,0FFh,0BFh,0F0h
		db	 2Fh,0FEh,0FFh,0ECh, 3Bh, 0Fh
		db	0B0h,0F8h, 2Eh, 0Eh,0E0h,0ECh
		db	 00h, 0Bh,0B0h, 00h, 00h,0EEh
		db	0EEh, 00h, 03h,0FBh,0BFh, 80h
		db	 0Fh,0FEh,0FFh,0E0h, 08h, 3Fh
		db	 83h,0F0h, 2Ch, 3Eh,0C3h,0ECh
		db	 3Bh,0FBh,0BFh,0B8h, 2Eh,0EEh
		db	0EEh,0ECh, 00h, 0Bh,0B0h, 00h
		db	 00h,0EEh,0EEh, 00h, 03h,0FBh
		db	0BFh, 80h, 0Fh,0FEh,0FFh,0E0h
		db	 0Bh,0C3h,0BCh, 30h, 2Fh,0C2h
		db	0FCh, 2Ch, 3Bh,0FBh,0BFh,0B8h
		db	 2Eh,0EEh,0EEh,0ECh, 3Bh,0BBh
		db	0BBh,0B8h, 2Eh,0EEh,0EEh,0ECh
		db	 3Bh,0BBh,0BBh,0B8h, 2Eh,0EEh
		db	0EEh,0ECh, 3Bh, 8Bh,0B3h,0B8h
		db	 0Eh, 02h,0C0h,0E0h, 38h,0B8h
		db	 3Bh, 38h, 20h, 2Ch, 2Ch, 0Ch
		db	 00h, 05h, 50h, 00h, 00h, 50h
		db	 05h, 00h, 01h, 00h, 00h, 40h
		db	 04h, 3Ch, 3Ch, 10h, 04h, 3Ch
		db	 3Ch, 10h, 10h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 04h, 10h, 00h
		db	 00h, 04h, 00h, 05h, 50h, 00h
		db	 00h, 50h, 05h, 00h, 01h, 00h
		db	 00h, 40h, 04h, 3Ch, 3Ch, 10h
		db	 04h, 3Ch, 3Ch, 10h, 10h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 04h, 00h, 05h
		db	 50h, 00h, 00h, 50h, 05h, 00h
		db	 01h, 00h, 00h, 40h, 04h, 3Ch
		db	 3Ch, 10h, 04h, 3Ch, 3Ch, 10h
		db	 10h, 00h, 00h, 04h, 10h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 04h
		db	 00h, 05h, 50h, 00h, 00h, 50h
		db	 05h, 00h, 01h, 00h, 00h, 40h
		db	 04h, 3Ch, 3Ch, 10h, 04h, 3Ch
		db	 3Ch, 10h, 10h, 00h, 00h, 04h
		db	 10h, 00h, 00h, 04h, 10h, 00h
		db	 00h, 04h, 13h,0C3h,0C3h,0C4h
		db	 1Ch, 3Ch, 3Ch, 34h, 10h, 00h
		db	 00h, 04h, 10h, 00h, 00h, 04h
		db	 10h, 44h, 11h, 04h, 05h, 01h
		db	 40h, 50h, 14h, 44h, 11h, 14h
		db	 10h, 14h, 14h, 04h, 00h, 0Fh
		db	0F0h, 00h, 00h,0FFh,0FFh, 00h
		db	 03h,0FFh,0FFh,0C0h, 0Fh,0EBh
		db	0EBh,0F0h, 0Fh,0EBh,0EBh,0F0h
		db	 3Fh,0FFh,0FFh,0FCh, 3Fh,0FFh
		db	0FFh,0FCh, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 0Fh,0F0h, 00h, 00h,0FFh
		db	0FFh, 00h, 03h,0FFh,0FFh,0C0h
		db	 0Fh,0EBh,0EBh,0F0h, 0Fh,0EBh
		db	0EBh,0F0h, 3Fh,0FFh,0FFh,0FCh
		db	 3Fh,0FFh,0FFh,0FCh, 3Fh,0FFh
		db	0FFh,0FCh, 00h, 0Fh,0F0h, 00h
		db	 00h,0FFh,0FFh, 00h, 03h,0FFh
		db	0FFh,0C0h, 0Fh,0EBh,0EBh,0F0h
		db	 0Fh,0EBh,0EBh,0F0h, 3Fh,0FFh
		db	0FFh,0FCh, 3Fh,0FFh,0FFh,0FCh
		db	 3Fh,0FFh,0FFh,0FCh, 00h, 0Fh
		db	0F0h, 00h, 00h,0FFh,0FFh, 00h
		db	 03h,0FFh,0FFh,0C0h, 0Fh,0EBh
		db	0EBh,0F0h, 0Fh,0EBh,0EBh,0F0h
		db	 3Fh,0FFh,0FFh,0FCh, 3Fh,0FFh
		db	0FFh,0FCh, 3Fh,0FFh,0FFh,0FCh
		db	 3Eh,0BEh,0BEh,0BCh, 3Bh,0EBh
		db	0EBh,0ECh, 3Fh,0FFh,0FFh,0FCh
		db	 3Fh,0FFh,0FFh,0FCh, 3Fh,0CFh
		db	0F3h,0FCh, 0Fh, 03h,0C0h,0F0h
		db	 3Ch,0FCh, 3Fh, 3Ch, 30h, 3Ch
		db	 3Ch, 0Ch, 00h, 00h, 00h, 00h
		db	 00h,0A0h, 0Ah, 00h, 03h,0ACh
		db	 3Ah,0C0h, 03h,0FCh, 3Fh,0C0h
		db	 03h,0FCh, 3Fh,0C0h, 00h,0F0h
		db	 0Fh
		db	22 dup (0)
		db	0F0h, 0Fh, 00h, 03h,0FCh, 3Fh
		db	0C0h, 03h,0FCh, 3Fh,0C0h, 03h
		db	0ACh, 3Ah,0C0h, 00h,0A0h, 0Ah
		db	 00h
		db	9 dup (0)
		db	0F0h, 0Fh, 00h, 03h,0FCh, 3Fh
		db	0C0h, 02h,0BCh, 2Bh,0C0h, 02h
		db	0BCh, 2Bh,0C0h, 00h,0F0h, 0Fh
		db	14 dup (0)
		db	0F0h, 0Fh, 00h, 03h,0FCh, 3Fh
		db	0C0h, 03h,0E8h, 3Eh, 80h, 03h
		db	0E8h, 3Eh, 80h, 00h,0F0h, 0Fh
		db	37 dup (0)
		db	 3Fh,0F0h,0F0h, 3Ch,0F0h,0FCh
		db	0F3h,0FCh,0FFh, 3Ch,0FCh, 3Ch
		db	 3Fh,0F0h, 00h, 00h, 0Fh, 00h
		db	 3Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Fh, 00h,0FFh,0F0h
		db	 00h, 00h, 3Fh,0C0h,0F0h,0F0h
		db	 00h,0F0h, 0Fh,0C0h, 3Ch, 00h
		db	0F0h,0F0h,0FFh,0F0h, 00h, 00h
		db	 3Fh,0C0h,0F0h,0F0h, 00h,0F0h
		db	 0Fh,0C0h, 00h,0F0h,0F0h,0F0h
		db	 3Fh,0C0h, 00h, 00h, 03h,0F0h
		db	 0Fh,0F0h, 3Ch,0F0h,0F0h,0F0h
		db	0FFh,0FCh, 00h,0F0h, 03h,0FCh
		db	 00h, 00h,0FFh,0F0h,0F0h, 00h
		db	0FFh,0C0h, 00h,0F0h, 00h,0F0h
		db	0F0h,0F0h, 3Fh,0C0h, 00h, 00h
		db	 0Fh,0C0h, 3Ch, 00h,0F0h, 00h
		db	0FFh,0C0h,0F0h,0F0h,0F0h,0F0h
		db	 3Fh,0C0h, 00h, 00h,0FFh,0F0h
		db	0F0h,0F0h, 00h,0F0h, 03h,0C0h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	 00h, 00h, 3Fh,0C0h,0F0h,0F0h
		db	0F0h,0F0h, 3Fh,0C0h,0F0h,0F0h
		db	0F0h,0F0h, 3Fh,0C0h, 00h, 00h
		db	 3Fh,0C0h,0F0h,0F0h,0F0h,0F0h
		db	 3Fh,0F0h, 00h,0F0h, 03h,0C0h
		db	3Fh
		db	19 dup (0)
		db	 02h, 0Fh, 03h,0C0h,0F0h, 30h
		db	0CCh, 33h, 0Ch, 00h,0CCh, 33h
		db	 0Ch, 03h
		db	0Ch, '3', 0Ch, 0Ch, 0Ch, '3', 0Ch
		db	'0', 0Ch, '3', 0Ch, '?'
		db	0C3h,0C0h,0F0h, 00h, 00h, 00h
		db	 00h, 04h, 30h,0C3h,0C0h,0F0h
		db	 30h,0CCh, 33h, 0Ch, 30h,0CCh
		db	 33h, 0Ch, 3Fh,0CCh, 33h, 0Ch
		db	 00h,0CCh, 33h, 0Ch, 00h,0CCh
		db	 33h, 0Ch, 00h,0C3h,0C0h,0F0h
		db	 00h, 00h, 00h, 00h, 08h, 0Fh
		db	 03h,0C0h,0F0h, 30h,0CCh, 33h
		db	 0Ch, 30h,0CCh, 33h, 0Ch, 0Fh
		db	 0Ch, 33h, 0Ch, 30h,0CCh, 33h
		db	 0Ch, 30h,0CCh, 33h, 0Ch, 0Fh
		db	 03h,0C0h,0F0h, 00h, 00h, 00h
		db	 00h, 10h,0C3h,0C0h,0F0h, 3Ch
		db	0CCh, 33h, 0Ch,0C3h,0CCh, 03h
		db	 0Ch,0C3h,0CFh,0C3h, 0Ch,0C3h
		db	0CCh, 33h, 0Ch,0C3h,0CCh, 33h
		db	 0Ch,0C3h,0C3h,0C0h,0F0h
		db	3Ch
		db	12 dup (0)
		db	 3Ch, 00h, 00h,0F0h, 3Fh, 00h
		db	 03h,0F0h, 3Fh,0C0h, 0Fh,0F0h
		db	 3Fh,0F0h, 3Fh,0F0h, 3Fh,0FCh
		db	0FFh,0F0h, 0Fh,0FFh,0FFh,0C0h
		db	 0Fh,0FFh,0FFh,0C0h, 03h,0FFh
		db	0FFh, 00h, 00h, 3Fh,0F0h
		db	25 dup (0)
		db	 3Ch, 00h, 00h,0F0h, 3Fh, 00h
		db	 03h,0F0h, 3Fh,0C0h, 0Fh,0F0h
		db	 3Fh,0FCh,0FFh,0F0h, 3Fh,0FFh
		db	0FFh,0F0h, 0Fh,0FFh,0FFh,0C0h
		db	 03h,0FFh,0FFh, 00h, 00h, 3Fh
		db	0F0h
		db	29 dup (0)
		db	0F0h, 00h, 00h, 3Ch,0FFh,0C0h
		db	 0Fh,0FCh, 3Fh,0FCh,0FFh,0F0h
		db	 3Fh,0FFh,0FFh,0F0h, 0Fh,0FFh
		db	0FFh,0C0h, 03h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FCh
		db	33 dup (0)
		db	0F0h, 00h, 00h, 3Ch,0FFh,0F0h
		db	 3Fh,0FCh, 3Fh,0FFh,0FFh,0F0h
		db	 3Fh,0FFh,0FFh,0F0h, 0Fh,0FFh
		db	0FFh,0C0h, 00h,0FFh,0FCh
		db	37 dup (0)
		db	0FCh, 00h, 00h,0FCh,0FFh,0FFh
		db	0FFh,0FCh, 3Fh,0FFh,0FFh,0F0h
		db	 0Fh,0FFh,0FFh,0C0h, 00h,0FFh
		db	0FCh
		db	41 dup (0)
		db	0FFh,0FFh,0FFh,0FCh,0FFh,0FFh
		db	0FFh,0FCh, 3Fh,0FFh,0FFh,0F0h
		db	 03h,0FFh,0FFh, 00h
		db	41 dup (0)
		db	 3Fh,0F0h, 00h, 3Fh,0FFh,0FFh
		db	0F0h,0FFh,0FFh,0FFh,0FCh, 0Fh
		db	0FFh,0FFh,0C0h
		db	41 dup (0)
		db	 0Fh,0C0h, 00h, 00h,0FFh,0FCh
		db	 00h, 3Fh,0FFh,0FFh,0F0h, 3Fh
		db	0FFh,0FFh,0F0h
		db	41 dup (0)
		db	 03h, 00h, 00h, 00h, 3Fh,0F0h
		db	 00h, 03h,0FFh,0FFh, 00h, 0Fh
		db	0FFh,0FFh,0C0h, 3Fh,0C0h, 0Fh
		db	0F0h
		db	37 dup (0)
		db	 03h, 00h, 00h, 00h, 0Fh,0C0h
		db	 00h, 00h, 3Fh,0F0h, 00h, 03h
		db	0FFh,0FFh, 00h, 0Fh,0F0h, 3Fh
		db	0C0h, 00h, 00h
		db	35 dup (0)
		db	 03h, 00h, 00h, 00h, 0Fh,0C0h
		db	 00h, 00h, 3Fh,0F0h, 00h, 00h
		db	 3Fh,0F0h, 00h, 00h,0F0h, 3Ch
		db	 00h, 03h,0C0h, 0Fh
		db	34 dup (0)
		db	 03h, 00h, 00h, 00h, 03h, 00h
		db	 00h, 00h, 0Fh,0C0h, 00h, 00h
		db	 3Fh,0F0h, 00h, 00h, 3Ch,0F0h
		db	 00h, 00h,0F0h, 3Ch, 00h, 00h
		db	0C0h, 0Ch, 00h
		db	33 dup (0)
		db	 03h, 00h, 00h, 00h, 03h, 00h
		db	 00h, 00h, 0Fh,0C0h, 00h, 00h
		db	 0Ch,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 30h, 30h, 00h
		db	33 dup (0)
		db	3, 0, 0, 0, 3, 0
		db	0, 0, 3, 0, 0, 0
		db	3, 0
		db	11 dup (0)
		db	0C0h, 00h, 00h, 00h,0C0h, 00h
		db	 00h,0C0h,0C0h,0C0h, 00h, 30h
		db	0C3h, 00h, 00h, 0Ch, 0Ch, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0F0h
		db	 03h,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 0Ch, 0Ch, 00h, 00h, 30h
		db	0C3h, 00h, 00h,0C0h,0C0h,0C0h
		db	 00h, 00h,0C0h, 00h, 00h, 00h
		db	0C0h
		db	7 dup (0)
		db	0C0h, 00h, 00h, 00h,0C0h, 00h
		db	 00h,0C0h,0C0h,0C0h, 00h, 30h
		db	0C3h, 00h, 00h, 0Ch, 0Ch, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0F0h
		db	 03h,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 0Ch, 0Ch, 00h, 00h, 30h
		db	0C3h, 00h, 00h,0C0h,0C0h,0C0h
		db	 00h, 00h,0C0h, 00h, 00h, 00h
		db	0C0h
		db	62 dup (0)
		db	 7Ah, 2Eh, 19h, 0Eh, 00h, 76h
		db	 2Eh, 0Eh, 0Eh
		db	114 dup (0)
		db	 02h, 6Dh, 30h, 1Ah, 26h, 00h
		db	 6Dh, 30h, 0Eh, 0Eh, 00h, 04h
		db	 00h
		db	111 dup (0)
		db	 03h, 8Bh, 2Eh, 1Ah, 26h, 00h
		db	 8Bh, 2Eh, 0Eh, 0Eh, 00h, 04h
		db	113 dup (0)
		db	 92h, 2Eh, 19h, 26h, 00h, 92h
		db	 2Eh, 0Eh, 0Eh
		db	114 dup (0)
		db	 02h,0ADh, 2Ch, 1Ah, 26h, 00h
		db	0ADh, 2Ch, 0Eh, 0Eh, 00h, 04h
		db	112 dup (0)
		db	0E6h,0C8h, 00h, 00h, 00h, 38h
		db	 00h, 70h, 00h,0A8h, 00h,0E0h
		db	 00h, 18h, 01h, 50h, 01h, 88h
		db	 01h,0C0h, 01h,0F8h, 01h, 30h
		db	 02h, 68h, 02h,0A0h, 02h,0D8h
		db	 02h, 10h, 03h, 48h, 03h, 00h
		db	0E2h, 1Eh,0FFh, 01h, 60h,0FFh
		db	0A0h, 00h,0FFh,0FFh, 01h, 00h
		db	 00h, 00h, 0Eh, 01h, 00h, 00h
		db	 00h, 02h, 00h, 02h, 00h,0E3h
		db	 08h, 28h, 0Ah,0D9h, 0Bh, 55h
		db	 0Dh,0C6h, 11h,0D9h, 0Bh, 55h
		db	 0Dh, 3Ch, 0Fh,0C6h, 11h,0FFh
		db	 13h,0A9h, 1Ah,0C6h, 11h,0FFh
		db	 13h,0DAh, 16h,0A9h, 1Ah,0FEh
		db	 1Dh,0FEh, 27h,0A9h, 1Ah,0FEh
		db	 1Dh, 47h, 22h,0FEh, 27h,0FDh
		db	 2Ch,0FCh, 3Bh,0FEh, 27h, 02h
		db	 00h,0F0h, 05h,0F6h, 03h, 02h
		db	 00h,0F0h, 05h,0F6h, 03h, 02h
		db	 00h, 02h, 00h, 6Ah, 30h, 6Eh
		db	 30h, 8Ah, 2Eh, 8Eh, 2Eh, 8Ah
		db	 2Eh, 8Eh, 2Eh,0AAh, 2Ch,0AEh
		db	 2Ch, 00h, 00h, 3Ch, 00h, 20h
		db	 3Ch, 00h, 00h, 00h, 00h, 00h
		db	 01h, 05h, 00h, 09h, 60h, 00h
		db	 00h, 25h,0A8h, 00h, 00h, 68h
		db	 15h, 00h
loc_3EFD:
		add	[bx+si+9],dl
		add	[bx+si],al
		nop
		or	al,[bx+si]
;		add	ds:data_0006_e[bx+si],ah
		db	0, 0a0h, 6, 0
;*		add	[bx+si+0],ah
		db	 00h, 60h, 00h		;  Fixup - byte match
		db	 00h, 00h, 50h, 00h, 00h, 00h
		db	 90h, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 60h, 00h, 00h, 00h
		db	 50h, 00h, 00h, 00h, 90h, 00h
		db	 00h, 00h,0A0h, 00h, 00h, 00h
		db	 03h, 00h, 00h, 00h, 00h, 00h
		db	 07h,0AAh,0AAh,0A0h, 07h,0A2h
		db	0AAh,0A0h, 07h,0AAh,0AAh, 20h
		db	 07h,0AAh, 8Ah,0A0h, 07h,0EAh
		db	0AAh,0A0h, 05h,0E2h,0AAh,0A0h
		db	 01h,0EAh,0AAh,0A0h
loc_3F4C:
;*		add	dx,di
		db	 01h,0FAh		;  Fixup - byte match
		mov	data_01A0,al
		jle	loc_3EFD		; Jump if < or =
		mov	al,ds:data_5F00_e
		cli				; Disable interrupts
		mov	al,data_1500
		jg	loc_3F4C		; Jump if >
		add	[bx+si],al
		push	bp
		push	ax
		db	 00h, 00h, 00h, 00h, 00h, 06h
		db	 00h, 00h, 00h, 00h, 40h, 00h
		db	 00h, 00h, 40h, 00h, 00h, 01h
		db	 40h, 00h, 00h, 03h, 40h, 00h
		db	 00h, 0Fh,0C0h, 00h, 00h, 3Fh
		db	0C0h, 00h, 00h,0FFh, 00h, 00h
		db	 03h,0DFh, 00h, 00h, 0Fh, 7Ch
		db	 00h, 00h, 3Dh,0F0h, 00h, 00h
		db	0F7h,0C0h, 00h, 0Fh,0FFh, 00h
		db	 00h, 17h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 01h, 00h, 00h
		db	 00h, 00h, 20h, 00h, 00h, 40h
		db	0A0h, 00h, 01h, 42h,0AAh, 80h
		db	 05h, 4Ah,0AAh, 80h, 05h, 4Ah
		db	0AAh, 80h, 05h, 4Ah,0AAh,0A8h
		db	 15h, 0Ah,0AAh,0A0h, 15h, 06h
		db	0AAh, 80h, 15h, 05h,0AAh, 00h
		db	 14h, 10h, 00h, 00h, 15h, 40h
		db	 00h, 00h, 15h, 55h, 55h, 40h
		db	 15h, 55h, 50h, 00h, 15h, 54h
		db	 00h, 00h, 01h, 05h, 00h, 00h
		db	 00h, 00h, 00h, 02h,0A0h, 0Ah
		db	 80h, 0Ah,0A8h, 2Ah,0A0h, 2Bh
		db	0EAh,0AAh,0A8h, 2Fh,0AAh,0AAh
		db	0A8h, 2Fh,0AAh,0AAh,0A8h, 2Bh
		db	0AAh,0AAh,0A8h, 0Ah,0EAh,0AAh
		db	0A0h, 0Ah,0AAh,0AAh,0A0h, 02h
		db	0AAh,0AAh, 80h, 00h,0AAh,0AAh
		db	 00h, 00h, 2Ah,0A8h, 00h, 00h
		db	 02h, 80h, 00h, 00h, 00h, 00h
		db	 00h, 02h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 02h, 00h, 00h
		db	 00h, 02h, 80h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 05h
		db	 51h, 50h, 04h, 01h, 41h, 10h
		db	 05h, 55h, 55h, 50h, 01h, 55h
		db	 54h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 00h, 00h, 00h, 2Ah,0A8h
		db	 00h, 02h, 83h,0C2h, 80h, 08h
		db	 03h,0C0h, 20h, 08h, 0Fh,0F0h
		db	 20h, 23h,0FFh,0FFh,0C8h, 2Fh
		db	0FFh,0FFh,0F8h, 23h,0FFh,0FFh
		db	0C8h, 20h,0FFh,0FFh, 08h, 20h
		db	 3Fh,0FCh, 08h, 20h, 3Fh,0FCh
		db	 08h, 08h,0FFh,0FFh, 20h, 08h
		db	0FCh, 3Fh, 20h, 02h, 80h, 02h
		db	 80h, 00h, 2Ah,0A8h, 00h, 06h
		db	 00h, 00h, 00h, 3Fh,0F0h, 00h
		db	 00h,0FFh,0FCh, 00h, 03h,0FFh
		db	0FFh, 00h, 0Fh,0F0h, 3Fh,0C0h
		db	 0Fh,0CFh,0CFh,0C0h, 0Fh,0CFh
		db	0CFh,0C0h, 0Fh,0CFh,0CFh,0C0h
		db	 03h,0F3h, 3Fh, 00h, 00h,0F3h
		db	 3Ch, 00h, 00h, 33h, 30h, 00h
		db	 00h, 20h, 20h, 00h, 00h, 2Ah
		db	0A0h, 00h, 00h, 20h, 20h, 00h
		db	 00h, 0Ah, 80h, 00h, 3Fh,0F0h
		db	0C0h, 0Ch,0C0h, 0Ch, 3Fh,0F0h
		db	 00h, 00h,0C0h, 30h,0FFh,0FCh
		db	0C0h, 00h,0F0h, 30h,0CCh, 0Ch
		db	0C3h, 0Ch,0C0h,0F0h, 30h, 30h
		db	0C0h, 0Ch,0C3h, 0Ch, 3Ch,0F0h
		db	 03h,0FCh, 03h, 00h, 03h, 00h
		db	0FFh,0FCh, 33h,0FCh,0C3h, 0Ch
		db	0C3h, 0Ch, 3Ch, 0Ch, 3Fh,0F0h
		db	0C3h, 0Ch,0C3h, 0Ch, 3Ch, 30h
		db	 0Eh, 01h, 00h
		db	78 dup (0)
		db	1, 0
		db	7 dup (0)
		db	 9Bh, 0Fh, 8Ah, 0Fh, 79h, 0Fh
		db	 6Ah, 0Fh, 01h, 00h, 90h, 01h
		db	0B4h, 01h,0E0h, 01h, 15h, 02h
		db	 58h, 02h, 15h, 02h,0E0h, 01h
		db	0B4h, 01h, 90h, 01h, 88h, 13h
		db	 02h, 00h, 70h, 17h, 02h, 00h
		db	 4Ch, 1Dh, 02h, 00h, 10h, 27h
		db	 02h, 00h,0A3h, 02h,0E0h, 02h
		db	 23h, 03h, 6Bh, 03h,0BBh, 03h
		db	 11h, 04h, 6Fh, 04h,0D6h, 04h
		db	 46h, 05h,0C0h, 05h, 45h, 06h
		db	0D7h, 06h, 75h, 07h, 22h, 08h
		db	0DEh, 08h,0ACh, 09h, 8Ch, 0Ah
		db	 80h, 0Bh, 8Bh, 0Ch,0ADh, 0Dh
		db	0EAh, 0Eh, 44h, 10h,0BDh, 11h
		db	 58h, 13h, 18h, 15h,0EAh, 06h
		db	0D4h, 0Dh, 1Eh, 06h, 3Dh, 0Ch
		db	 6Ah, 05h,0D4h, 0Ah,0CBh, 04h
		db	 95h, 09h, 3Eh, 04h, 7Bh, 08h
		db	0C1h, 03h, 81h, 07h, 52h, 03h
		db	0A4h, 06h,0F0h, 02h,0E1h, 05h
		db	 9Ah, 02h, 34h, 05h, 4Dh, 02h
		db	 9Ah, 04h, 09h, 02h, 13h, 04h
		db	0CDh, 01h, 9Bh, 03h, 00h
		db	9 dup (0)
		db	'stakstakstakstak'

seg_a		ends



		end	start
