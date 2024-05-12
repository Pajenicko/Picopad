
PAGE  59,132

; - can move and shoot diagonal
; Shooting keys: ASDW
; Moving keys: arrows
; Speedup: spacebar

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
;==				SNIPES	                                 ==
;==					                                 ==
;==      Created:   4-Aug-83		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_0000_0024_e	equ	24h
d_0000_0026_e	equ	26h
data_0000_e	equ	0
data_0001_e	equ	1
data_00FE_e	equ	0FEh
data_8DD0_e	equ	8DD0h			;*
d_3C5A_0000_e	equ	0			;*
d_3C5A_0080_e	equ	80h			;*
d_3C5A_01D6_e	equ	1D6h			;*
d_3C5A_01D8_e	equ	1D8h			;*
d_3C5A_02A2_e	equ	2A2h			;*
d_3C5A_02A4_e	equ	2A4h			;*
d_3C5A_02AD_e	equ	2ADh			;*
d_3C5A_02AE_e	equ	2AEh			;*
d_3C5A_02C4_e	equ	2C4h			;*
d_3C5A_0D64_e	equ	0D64h			;*

seg_a		segment	byte public
		assume	cs:seg_a, ds:seg_a


		org	100h

SNIPES		proc	far

start:
		jmp	real_start
		db	 90h, 90h
loc_0105:
		sub	ax,cs:data_012F
		mov	bx,cs
		add	ax,bx
		mov	cs:data_2411,ax
		mov	es,ax
		mov	si,data_0000_e
		mov	di,d_3C5A_0000_e
		nop
		mov	cx,80h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	ds,ax
		mov	ss,ax
		mov	sp,1C8h
		nop
		sti				; Enable interrupts
		call	sub_0AFF

SNIPES		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_012C	proc	near
		jmp	loc_3B93
sub_012C	endp

data_012F	dw	624h
		db	0B4h, 01h,0CDh, 21h,0C3h,0B4h
		db	 02h
loc_0138:
		push	bp
		mov	bp,sp
		mov	dx,[bp+4]
		int	21h			; DOS Services  ah=function 0Ah
						;  get keybd line, put at ds:dx
		pop	bp
		retn	2

; Input DOS key, wait
			                        ;* No entry point to code
		mov	ah,3
		int	21h			; DOS Services  ah=function 03h
						;  get char al from serial port
		retn

; Output DOS character
			                        ;* No entry point to code
		mov	ah,4
		jmp	short loc_0138

; Print DOS character
			                        ;* No entry point to code
		mov	ah,5
		jmp	short loc_0138

; Input/output DOS character
			                        ;* No entry point to code
		mov	ah,6
		jmp	short loc_0138
		db	0B4h, 07h,0CDh, 21h,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input DOS key without echo, wait

sub_015A	proc	near
		mov	ah,8
		int	21h			; DOS Services  ah=function 08h
						;  get keybd char al, no echo
		retn
sub_015A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print DOS text

sub_015F	proc	near
		mov	ah,9
		jmp	short loc_0138
sub_015F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input DOS text

sub_0163	proc	near
		mov	ah,0Ah
		jmp	short loc_0138
sub_0163	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check key input

sub_0167	proc	near
		mov	ah,0Bh
		int	21h			; DOS Services  ah=function 0Bh
						;  if keybd char available,al=FF
		retn
sub_0167	endp

			                        ;* No entry point to code
; Flush key input buffer

		mov	ah,0Ch
		push	bp
		mov	bp,sp
		mov	al,[bp+6]
		mov	dx,[bp+4]
		int	21h			; DOS Services  ah=function 0Ch
						;  clear keybd buffer & input al
		pop	bp
		retn	4
			                        ;* No entry point to code
; Disk reset
		mov	ah,0Dh
		int	21h			; DOS Services  ah=function 0Dh
						;  flush disk buffers to disk
		retn
		db	0B4h, 0Eh,0EBh,0B2h,0B4h, 0Fh
		db	0EBh,0AEh,0B4h, 10h,0EBh,0AAh
		db	0B4h, 11h,0EBh,0A6h,0B4h, 12h
		db	0CDh, 21h,0C3h,0B4h, 13h,0EBh
		db	 9Dh,0B4h, 14h,0EBh, 99h,0B4h
		db	 15h,0EBh, 95h,0B4h, 16h,0EBh
		db	 91h,0B4h, 17h,0EBh, 8Dh,0B4h
		db	 19h,0CDh, 21h,0C3h,0B4h, 1Ah
		db	0EBh, 84h,0B4h, 21h,0EBh, 80h
		db	0B4h, 22h,0E9h, 7Bh,0FFh,0B4h
		db	 23h,0E9h, 76h,0FFh,0B4h, 24h
		db	0E9h, 71h,0FFh,0B4h
		db	27h
loc_01C9:
		push	bp
		mov	bp,sp
		mov	cx,[bp+4]
		mov	dx,[bp+6]
		int	21h			; DOS Services  ah=function 28h
						;  random block write FCB @ds:dx
						;   cx=#records to write,Returns
						;   al=0 ok,cx=actual write recs
		pop	bp
		retn	4
			                        ;* No entry point to code
		mov	ah,28h			; '('
		jmp	short loc_01C9
data_01DC	dw	8B55h
data_01DE	dw	1EECh
data_01E0	dw	8B07h
data_01E2	dw	0A76h
data_01E4	dw	7E8Bh
data_01E6	dw	8A08h
data_01E8	dw	646h
data_01EA	dw	29B4h
data_01EC	dw	21CDh			; Data table (indexed access)
		db	 8Bh, 5Eh, 04h, 89h, 37h, 5Dh
		db	0C2h, 08h, 00h, 8Ch,0D8h,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_01FA	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	ax,word ptr ds:[1D6h]
		shl	ax,1			; Shift w/zeros fill
		mov	word ptr ds:[1D6h],ax
		mov	cx,3ADh
		cmp	ax,cx
		jbe	loc_0210		; Jump if below or =
		sub	word ptr ds:[1D6h],cx
loc_0210:
		mov	ax,word ptr ds:[1D8h]
		shl	ax,1			; Shift w/zeros fill
		mov	word ptr ds:[1D8h],ax
		mov	cx,3B3h
		cmp	ax,cx
		jbe	loc_0223		; Jump if below or =
		sub	word ptr ds:[1D8h],cx
loc_0223:
		mov	ax,word ptr ds:[1D6h]
		add	ax,word ptr ds:[1D8h]
		and	ax,[bp+PARAMETER_1]
		pop	bp
		retn	2
sub_01FA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0231	proc	near
		push	bp
		mov	bp,sp
		mov	data_01DC,730h
		mov	word ptr ds:[1DAh],1
loc_0240:
		cmp	word ptr ds:[1DAh],50h
		ja	loc_0261		; Jump if above
		mov	ax,0F3Eh
		push	ax			; PARAMETER_3
		push	data_01DC		; PARAMETER_2
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_23E0
		add	data_01DC,2
		inc	word ptr ds:[1DAh]
		jnz	loc_0240		; Jump if not zero
loc_0261:
		pop	bp
		retn
sub_0231	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0263	proc	near
		push	bp
		mov	bp,sp
		mov	al,0Fh
		mov	di,350h
		mov	cx,140h
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		mov	byte ptr ds:[350h],0Eh
		mov	byte ptr ds:[351h],0Dh
		mov	data_01EA,13Eh
loc_0283:
		cmp	data_01EA,0
		jne	loc_028D		; Jump if not equal
		jmp	loc_0372
loc_028D:
		mov	ax,1FFh
		push	ax
		call	sub_01FA
		mov	data_01DE,ax
		cmp	ax,140h
		jge	loc_028D		; Jump if > or =
		mov	si,data_01DE
		cmp	byte ptr ds:[350h][si],0Fh
		jne	loc_0283		; Jump if not equal
		mov	ax,3
		push	ax
		call	sub_01FA
		mov	data_01E2,ax
		mov	data_01E4,0
loc_02B7:
		mov	ax,3
		cmp	data_01E4,ax
		jg	loc_0283		; Jump if >
		mov	cx,data_01E2
		and	cx,ax
		mov	byte ptr ds:[2AFh],cl
		mov	ax,data_01DE
		mov	data_01E0,ax
		call	sub_04DE
		mov	si,data_01E0
		cmp	byte ptr ds:[350h][si],0Fh
		jne	loc_02E8		; Jump if not equal
		inc	data_01E2
		inc	data_01E4
		jmp	short loc_02B7
loc_02E8:
		dec	data_01EA
		mov	bl,byte ptr ds:[2AFh]
		mov	bh,0
		mov	al,byte ptr ds:[0EA7h][bx]
		mov	si,data_01E0
		xor	byte ptr ds:[350h][si],al
		mov	al,byte ptr ds:[0EA3h][bx]
		mov	si,data_01DE
		xor	byte ptr ds:[350h][si],al
		mov	data_01E2,si
loc_030E:
		mov	ax,3
		push	ax
		call	sub_01FA
		mov	byte ptr ds:[2AFh],al
		mov	ax,3
		push	ax
		call	sub_01FA
		inc	ax
		mov	byte ptr ds:[2B0h],al
		mov	ax,data_01E2
		mov	data_01E0,ax
loc_0329:
		call	sub_04DE
;*		cmp	byte ptr ds:[2B0h],0
		db	 82h, 3Eh,0B0h, 02h, 00h	;  Fixup - byte match
		jz	loc_0366		; Jump if zero
		mov	si,data_01E0
		cmp	byte ptr ds:[350h][si],0Fh
		jne	loc_0366		; Jump if not equal
		mov	bl,byte ptr ds:[2AFh]
		mov	bh,0
		mov	al,byte ptr ds:[0EA7h][bx]
		xor	byte ptr ds:[350h][si],al
		mov	al,byte ptr ds:[0EA3h][bx]
		mov	di,data_01E2
		xor	byte ptr ds:[350h][di],al
		dec	data_01EA
		dec	byte ptr ds:[2B0h]
		mov	data_01E2,si
		jmp	short loc_0329
loc_0366:
;*		cmp	byte ptr ds:[2B0h],0
		db	 82h, 3Eh,0B0h, 02h, 00h	;  Fixup - byte match
		jz	loc_0370		; Jump if zero
		jmp	loc_0283
loc_0370:
		jmp	short loc_030E
loc_0372:
		mov	data_01DE,1
loc_0378:
		cmp	data_01DE,40h
		jg	loc_03C7		; Jump if >
loc_037F:
		mov	ax,1FFh
		push	ax
		call	sub_01FA
		mov	data_01E0,ax
		cmp	ax,140h
		jge	loc_037F		; Jump if > or =
		mov	ax,3
		push	ax
		call	sub_01FA
		mov	byte ptr ds:[2AFh],al
		mov	ah,0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,byte ptr ds:[0EA3h][bx]
		not	al
		mov	si,data_01E0
		and	byte ptr ds:[350h][si],al
		call	sub_04DE
		mov	bl,byte ptr ds:[2AFh]
		mov	bh,0
		mov	al,byte ptr ds:[0EA7h][bx]
		not	al
		mov	si,data_01E0
		and	byte ptr ds:[350h][si],al
		inc	data_01DE
		jmp	short loc_0378
loc_03C7:
		mov	ax,920h
		mov	di,15D0h
		mov	cx,3C00h
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosw			; Rep zf=0+cx >0 Store ax to es:[di]
		mov	ax,0
		mov	data_01E4,ax
		mov	data_01E2,ax
		mov	data_01DE,ax
loc_03E1:
		cmp	data_01DE,13h
		jle	loc_03EB		; Jump if < or =
		jmp	loc_04DC
loc_03EB:
		mov	data_01E0,0
loc_03F1:
		cmp	data_01E0,0Fh
		jle	loc_03FB		; Jump if < or =
		jmp	loc_04C9
loc_03FB:
		mov	si,data_01E2
		test	byte ptr ds:[350h][si],8
		jz	loc_041B		; Jump if zero
		mov	bx,data_01E4
		shl	bx,1			; Shift w/zeros fill
		lea	di,ds:[15D2h][bx]	; Load effective addr
		mov	ax,9CDh
		mov	cx,7
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosw			; Rep zf=0+cx >0 Store ax to es:[di]
loc_041B:
		mov	si,data_01E2
		test	byte ptr ds:[350h][si],2
		jz	loc_0454		; Jump if zero
		mov	ax,data_01E4
		add	ax,80h
		mov	data_01E6,ax
		mov	data_01E8,1
loc_0435:
		cmp	data_01E8,5
		jg	loc_0454		; Jump if >
		mov	bx,data_01E6
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:[15D0h][bx],9BAh
		add	data_01E6,80h
		inc	data_01E8
		jmp	short loc_0435
loc_0454:
		cmp	data_01DE,0
		jne	loc_0472		; Jump if not equal
		cmp	data_01E0,0
		jne	loc_046A		; Jump if not equal
		mov	data_01E6,13Fh
		jmp	short loc_0488
loc_046A:
		mov	ax,data_01E2
		add	ax,140h
		jmp	short loc_0482
loc_0472:
		cmp	data_01E0,0
		jne	loc_047F		; Jump if not equal
		mov	ax,data_01E2
		dec	ax
		jmp	short loc_0485
loc_047F:
		mov	ax,data_01E2
loc_0482:
;*		sub	ax,11h
		db	 83h,0E8h, 11h		;  Fixup - byte match
loc_0485:
		mov	data_01E6,ax
loc_0488:
		mov	si,data_01E2
		mov	al,byte ptr ds:[350h][si]
		and	al,0Ah
		mov	si,data_01E6
		mov	cl,byte ptr ds:[350h][si]
		and	cl,5
		or	al,cl
		mov	byte ptr ds:[2B1h],al
		mov	ah,0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,byte ptr ds:[0EABh][bx]
		mov	ah,0
		or	ax,900h
		mov	bx,data_01E4
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:[15D0h][bx],ax
		add	data_01E4,8
		inc	data_01E2
		inc	data_01E0
		jmp	loc_03F1
loc_04C9:
		mov	ax,5
		mov	cx,80h
		imul	cx			; dx:ax = reg * ax
		add	data_01E4,ax
		inc	data_01DE
		jmp	loc_03E1
loc_04DC:
		pop	bp
		retn
sub_0263	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_04DE	proc	near
		push	bp
		mov	bp,sp
		mov	bl,byte ptr ds:[2AFh]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_04EE[bx]	;*1 entry
sub_04DE	endp

data_04EE	dw	4F6h			; Data table (indexed access)
		db	 09h, 05h, 1Bh, 05h, 30h, 05h
		db	0A1h,0E0h, 01h, 83h,0E8h, 10h
		db	0A3h,0E0h, 01h, 7Dh, 45h, 81h
		db	 06h,0E0h, 01h, 40h, 01h, 5Dh
		db	0C3h,0A1h,0E0h, 01h, 83h,0C0h
		db	 10h,0A3h,0E0h, 01h,0B9h, 40h
		db	 01h, 3Bh,0C1h, 7Ch, 2Dh,0EBh
		db	 21h,0B8h, 0Fh, 00h, 85h, 06h
		db	0E0h, 01h, 75h, 06h, 01h, 06h
		db	0E0h, 01h, 5Dh,0C3h,0FFh, 0Eh
		db	0E0h, 01h, 5Dh,0C3h,0A1h,0E0h
		db	 01h,0B9h, 0Fh, 00h, 23h,0C1h
		db	 3Bh,0C1h, 75h, 06h, 29h, 0Eh
		db	0E0h, 01h, 5Dh,0C3h
loc_0542:
		inc	data_01E0
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0548	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		mov	word ptr ds:[28Ch],1
loc_0551:
		mov	ax,word ptr ds:[28Ch]
		cmp	ax,[bp+PARAMETER_2]
		ja	loc_0572		; Jump if above
		dec	ax
		mov	bx,[bp+PARAMETER_4]
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	cl,[bx+si]
		mov	ch,0
		or	cx,[bp+PARAMETER_1]
		shl	si,1			; Shift w/zeros fill
		mov	data_01EC[si],cx
		inc	word ptr ds:[28Ch]
		jnz	loc_0551		; Jump if not zero
loc_0572:
		mov	ax,1ECh
		push	ax			; PARAMETER_3
		push	word ptr [bp+PARAMETER_3]	; PARAMETER_2
		push	word ptr [bp+PARAMETER_2]	; PARAMETER_1
		call	sub_23E0
		pop	bp
		retn	8
sub_0548	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0583	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah
PARAMETER_5	=	0Ch			; bp+0Ch

		push	bp
		mov	bp,sp
;*		cmp	byte ptr [bp+PARAMETER_2],0
		db	 82h, 7Eh, 06h, 00h	;  Fixup - byte match
		jnz	loc_059B		; Jump if not zero
		mov	al,20h			; ' '
		mov	di,2B5h
		mov	cx,0Ah
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		jmp	short loc_05AC
loc_059B:
		mov	al,30h			; '0'
		mov	di,2B5h
		mov	cx,0Ah
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		mov	byte ptr [bp+PARAMETER_2],1
loc_05AC:
		mov	al,[bp+PARAMETER_3]
		mov	byte ptr ds:[2BFh],al
loc_05B2:
		mov	ax,[bp+PARAMETER_5]
		mov	cx,0Ah
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
		div	cx			; ax,dx rem=dx:ax/reg
		add	dx,30h
		mov	al,byte ptr ds:[2BFh]
		dec	al
		mov	ah,0
		mov	byte ptr ds:[2BFh],al
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	byte ptr ds:[2B5h][bx],dl
		mov	ax,[bp+PARAMETER_5]
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
		div	cx			; ax,dx rem=dx:ax/reg
		mov	[bp+PARAMETER_5],ax
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		mov	al,0FFh
		jnz	loc_05E0		; Jump if not zero
		inc	ax
loc_05E0:
		push	ax
;*		or	bl,bl			; Zero ?
		db	 08h,0DBh		;  Fixup - byte match
		mov	al,0FFh
		ja	loc_05E8		; Jump if above
		inc	ax
loc_05E8:
		pop	cx
		and	al,cl
		rcr	al,1			; Rotate thru carry
		jc	loc_05B2		; Jump if carry Set
		mov	ax,2B5h
		push	ax			; PARAMETER_4
		push	word ptr [bp+PARAMETER_4]	; PARAMETER_3
		mov	al,[bp+PARAMETER_3]
		add	al,[bp+PARAMETER_2]
		mov	ah,0
		push	ax			; PARAMETER_2
		push	word ptr [bp+PARAMETER_1]	; PARAMETER_1
		call	sub_0548
		pop	bp
		retn	0Ah
sub_0583	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0609	proc	near
		push	bp
		mov	bp,sp
		mov	al,20h			; ' '
		mov	di,15D0h
		mov	cx,28h
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		mov	ax,15D0h
		push	ax			; PARAMETER_4
		mov	ax,0
		push	ax			; PARAMETER_3
		mov	ax,28h
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,15D0h
		push	ax			; PARAMETER_4
		mov	ax,50h
		push	ax			; PARAMETER_3
		mov	ax,28h
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F40h
		push	ax			; PARAMETER_4
		mov	ax,0
		push	ax			; PARAMETER_3
		mov	ax,2
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0
		push	ax			; PARAMETER_5
		mov	cx,6
		push	cx			; PARAMETER_4
		mov	cl,2
		push	cx			; PARAMETER_3
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	ax,0F42h
		push	ax			; PARAMETER_4
		mov	ax,0Ch
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F43h
		push	ax			; PARAMETER_4
		mov	ax,10h
		push	ax			; PARAMETER_3
		mov	ax,2
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0
		push	ax			; PARAMETER_5
		mov	cx,16h
		push	cx			; PARAMETER_4
		mov	cl,4
		push	cx			; PARAMETER_3
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	ax,0F45h
		push	ax			; PARAMETER_4
		mov	ax,20h
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F46h
		push	ax			; PARAMETER_4
		mov	ax,24h
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0
		push	ax			; PARAMETER_5
		mov	cx,28h
		push	cx			; PARAMETER_4
		mov	cl,4
		push	cx			; PARAMETER_3
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	ax,0F47h
		push	ax			; PARAMETER_4
		mov	ax,32h
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F48h
		push	ax			; PARAMETER_4
		mov	ax,36h
		push	ax			; PARAMETER_3
		mov	ax,5
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	al,byte ptr ds:[2ADh]
		mov	ah,0
		push	ax			; PARAMETER_5
		mov	ax,4Ch
		push	ax			; PARAMETER_4
		mov	al,1
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	al,byte ptr ds:[2AEh]
		add	al,41h			; 'A'
		mov	ah,0
		mov	word ptr ds:[15D0h],ax
		mov	ax,15D0h
		push	ax			; PARAMETER_4
		mov	ax,4Ah
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F4Dh
		push	ax			; PARAMETER_4
		mov	ax,50h
		push	ax			; PARAMETER_3
		mov	ax,2
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F4Fh
		push	ax			; PARAMETER_4
		mov	ax,5Ch
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F50h
		push	ax			; PARAMETER_4
		mov	ax,60h
		push	ax			; PARAMETER_3
		mov	ax,2
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F52h
		push	ax			; PARAMETER_4
		mov	ax,70h
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F53h
		push	ax			; PARAMETER_4
		mov	ax,74h
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F54h
		push	ax			; PARAMETER_4
		mov	ax,82h
		push	ax			; PARAMETER_3
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	ax,0F55h
		push	ax			; PARAMETER_4
		mov	ax,86h
		push	ax			; PARAMETER_3
		mov	ax,4
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	al,20h			; ' '
		mov	di,15D0h
		mov	cx,28h
		push	ds
		pop	es
		cld				; Clear direction
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		mov	si,0F59h
		mov	di,15D0h
		mov	cx,28h
		push	ds
		pop	es
		cld				; Clear direction
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		mov	al,byte ptr ds:[2A9h]
		add	al,30h			; '0'
		mov	ah,0
		mov	word ptr ds:[15D0h],ax
		cmp	byte ptr ds:[2A9h],1
		jne	loc_07E8		; Jump if not equal
		mov	word ptr ds:[15D6h],61h
loc_07E8:
		mov	ax,15D0h
		push	ax			; PARAMETER_4
		mov	ax,0A0h
		push	ax			; PARAMETER_3
		mov	ax,28h
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
		mov	al,0FFh
		mov	byte ptr ds:[2B4h],al
		mov	byte ptr ds:[2B3h],al
		mov	byte ptr ds:[2B2h],al
		mov	cx,0FFFFh
		mov	word ptr ds:[290h],cx
		mov	word ptr ds:[28Eh],cx
		mov	byte ptr ds:[2C0h],al
		mov	word ptr ds:[292h],cx
		pop	bp
		retn
sub_0609	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_081A	proc	near
		push	bp
		mov	bp,sp
		inc	word ptr ds:[1D0h]
		mov	ax,word ptr ds:[346h]
		cmp	ax,word ptr ds:[28Eh]
		je	loc_083F		; Jump if equal
		mov	word ptr ds:[28Eh],ax
		push	ax			; PARAMETER_5
		mov	ax,16h
		push	ax			; PARAMETER_4
		mov	al,4
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0583
loc_083F:
		mov	ax,word ptr ds:[348h]
		cmp	ax,word ptr ds:[290h]
		je	loc_085D		; Jump if equal
		mov	word ptr ds:[290h],ax
		push	ax			; PARAMETER_5
		mov	ax,28h
		push	ax			; PARAMETER_4
		mov	al,4
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0583
loc_085D:
		mov	al,byte ptr ds:[0B65h]
		cmp	al,byte ptr ds:[2B3h]
		je	loc_0898		; Jump if equal
		mov	byte ptr ds:[2B3h],al
		mov	ah,0
		push	ax			; PARAMETER_5
		mov	ax,56h
		push	ax			; PARAMETER_4
		mov	al,2
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	al,byte ptr ds:[2A8h]
		sub	al,byte ptr ds:[0B65h]
		mov	ah,0
		push	ax			; PARAMETER_5
		mov	ax,6
		push	ax			; PARAMETER_4
		mov	al,2
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1300h
		push	ax			; PARAMETER_1
		call	sub_0583
loc_0898:
		mov	al,byte ptr ds:[0B64h]
		cmp	al,byte ptr ds:[2B2h]
		je	loc_08B8		; Jump if equal
		mov	byte ptr ds:[2B2h],al
		mov	ah,0
		push	ax			; PARAMETER_5
		mov	ax,68h
		push	ax			; PARAMETER_4
		mov	al,3
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
loc_08B8:
		mov	al,byte ptr ds:[0B68h]
		cmp	al,byte ptr ds:[2B4h]
		je	loc_08D8		; Jump if equal
		mov	byte ptr ds:[2B4h],al
		mov	ah,0
		push	ax			; PARAMETER_5
		mov	ax,7Ah
		push	ax			; PARAMETER_4
		mov	al,3
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
loc_08D8:
		mov	ax,word ptr ds:[34Eh]
		cmp	ax,word ptr ds:[292h]
		je	loc_090F		; Jump if equal
		mov	word ptr ds:[292h],ax
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jle	loc_08FC		; Jump if < or =
		push	ax			; PARAMETER_5
		mov	ax,0E2h
		push	ax			; PARAMETER_4
		mov	al,5
		push	ax			; PARAMETER_3
		mov	al,1
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
		jmp	short loc_090F
loc_08FC:
		mov	ax,0F81h
		push	ax			; PARAMETER_4
		mov	ax,0E2h
		push	ax			; PARAMETER_3
		mov	ax,6
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0548
loc_090F:
		mov	al,byte ptr ds:[0B66h]
		cmp	al,byte ptr ds:[2C0h]
		je	loc_097F		; Jump if equal
		mov	byte ptr ds:[2C0h],al
		mov	cl,byte ptr ds:[2A9h]
		sub	cl,al
		cmp	cl,1
		jne	loc_0933		; Jump if not equal
		mov	ax,0F87h
		push	ax
		mov	ax,0A0h
		push	ax
		mov	ax,0Ah
		jmp	short loc_0977
loc_0933:
		mov	al,byte ptr ds:[2A9h]
		sub	al,byte ptr ds:[0B66h]
		mov	ah,0
		push	ax			; PARAMETER_5
		mov	ax,0A0h
		push	ax			; PARAMETER_4
		mov	al,1
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	al,byte ptr ds:[2A9h]
		sub	al,byte ptr ds:[0B66h]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_097F		; Jump if not zero
		mov	ax,0
		push	ax			; PARAMETER_5
		mov	cx,0A0h
		push	cx			; PARAMETER_4
		mov	cl,1
		push	cx			; PARAMETER_3
		push	ax			; PARAMETER_2
		mov	ax,1C00h
		push	ax			; PARAMETER_1
		call	sub_0583
		mov	ax,0F91h
		push	ax			; PARAMETER_4
		mov	ax,0A6h
		push	ax			; PARAMETER_3
		mov	ax,1
loc_0977:
		push	ax			; PARAMETER_2
		mov	ax,1C00h
		push	ax			; PARAMETER_1
		call	sub_0548
loc_097F:
		push	word ptr ds:[1D0h]	; PARAMETER_5
		mov	ax,94h
		push	ax			; PARAMETER_4
		mov	al,5
		push	ax			; PARAMETER_3
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,1700h
		push	ax			; PARAMETER_1
		call	sub_0583
;*		cmp	byte ptr ds:[0B64h],0
		db	 82h, 3Eh, 64h, 0Bh, 00h	;  Fixup - byte match
		jnz	loc_09B7		; Jump if not zero
;*		cmp	byte ptr ds:[0B65h],0
		db	 82h, 3Eh, 65h, 0Bh, 00h	;  Fixup - byte match
		jnz	loc_09B7		; Jump if not zero
;*		cmp	byte ptr ds:[0B68h],0
		db	 82h, 3Eh, 68h, 0Bh, 00h	;  Fixup - byte match
		jnz	loc_09B7		; Jump if not zero
		call	sub_0231
		mov	ax,0F92h
		push	ax
		call	sub_015F		; Print DOS text
		mov	al,0FFh
		pop	bp
		retn
loc_09B7:
		mov	al,0
		pop	bp
		retn
sub_081A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_09BB	proc	near
		push	bp
		mov	bp,sp
		mov	word ptr ds:[29Ah],0F0h
		mov	ax,word ptr ds:[1CCh]
;*		sub	ax,0Bh
		db	 83h,0E8h, 0Bh		;  Fixup - byte match
		mov	word ptr ds:[298h],ax
		jge	loc_09D4		; Jump if > or =
		add	word ptr ds:[298h],78h
loc_09D4:
		mov	ax,word ptr ds:[1CAh]
;*		sub	ax,14h
		db	 83h,0E8h, 14h		;  Fixup - byte match
		mov	word ptr ds:[296h],ax
		jge	loc_09E5		; Jump if > or =
		add	word ptr ds:[296h],80h
loc_09E5:
		mov	ax,word ptr ds:[296h]
;*		add	ax,28h
		db	 83h,0C0h, 28h		;  Fixup - byte match
		mov	cx,80h
		cmp	ax,cx
		jl	loc_09FC		; Jump if <
		sub	cx,word ptr ds:[296h]
		mov	word ptr ds:[29Eh],cx
		jmp	short loc_0A02
loc_09FC:
		mov	word ptr ds:[29Eh],28h
loc_0A02:
		mov	byte ptr ds:[2C2h],0
loc_0A07:
		cmp	byte ptr ds:[2C2h],15h
		ja	loc_0A71		; Jump if above
		mov	ax,word ptr ds:[298h]
		mov	cl,7
		shl	ax,cl			; Shift w/zeros fill
		mov	word ptr ds:[29Ch],ax
		mov	bx,word ptr ds:[296h]
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		lea	ax,cs:[15D0h][bx]	; Load effective addr
		push	ax			; PARAMETER_3
		push	word ptr ds:[29Ah]	; PARAMETER_2
		push	word ptr ds:[29Eh]	; PARAMETER_1
		call	sub_23E0
		mov	ax,word ptr ds:[29Eh]
		mov	cx,28h
		cmp	ax,cx
		je	loc_0A54		; Jump if equal
		mov	bx,word ptr ds:[29Ch]
		shl	bx,1			; Shift w/zeros fill
		lea	dx,cs:[15D0h][bx]	; Load effective addr
		push	dx			; PARAMETER_3
		shl	ax,1			; Shift w/zeros fill
		add	ax,word ptr ds:[29Ah]
		push	ax			; PARAMETER_2
		sub	cx,word ptr ds:[29Eh]
		push	cx			; PARAMETER_1
		call	sub_23E0
loc_0A54:
		add	word ptr ds:[29Ah],50h
		mov	ax,word ptr ds:[298h]
		inc	ax
		mov	word ptr ds:[298h],ax
;*		cmp	ax,78h
		db	 83h,0F8h, 78h		;  Fixup - byte match
		jnz	loc_0A6B		; Jump if not zero
		mov	word ptr ds:[298h],0
loc_0A6B:
		inc	byte ptr ds:[2C2h]
		jnz	loc_0A07		; Jump if not zero
loc_0A71:
		pop	bp
		retn
sub_09BB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A73	proc	near
		push	bp
		mov	bp,sp
		mov	word ptr ds:[2A0h],0
		mov	al,byte ptr ds:[344h]
		mov	byte ptr ds:[344h],al
loc_0A82:
		mov	al,byte ptr ds:[2C4h]
		dec	al
		cmp	byte ptr ds:[344h],al
		ja	loc_0AFA		; Jump if above
		cmp	word ptr ds:[2A0h],7Fh
		jbe	loc_0A98		; Jump if below or =
		mov	al,1
		pop	bp
		retn
loc_0A98:
		mov	al,byte ptr ds:[344h]
		mov	ah,0
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	al,byte ptr ds:[2C5h][si]
		and	al,7Fh
		mov	byte ptr ds:[345h],al
		mov	cl,41h			; 'A'
		cmp	al,cl
		jb	loc_0ACF		; Jump if below
		mov	dl,61h			; 'a'
		cmp	al,dl
		jb	loc_0ABB		; Jump if below
		sub	al,dl
		add	al,cl
		mov	byte ptr ds:[345h],al
loc_0ABB:
		mov	al,byte ptr ds:[345h]
		mov	cl,41h			; 'A'
		cmp	al,cl
		jb	loc_0AF4		; Jump if below
		cmp	al,5Ah			; 'Z'
		ja	loc_0AF4		; Jump if above
		sub	al,cl
		mov	byte ptr ds:[2AEh],al
		jmp	short loc_0AF4
loc_0ACF:
		mov	al,byte ptr ds:[345h]
		cmp	al,30h			; '0'
		jb	loc_0ADA		; Jump if below
		cmp	al,39h			; '9'
		jbe	loc_0ADE		; Jump if below or =
loc_0ADA:
		mov	al,0
		pop	bp
		retn
loc_0ADE:
		mov	ax,word ptr ds:[2A0h]
		mov	cx,0Ah
		mul	cx			; dx:ax = reg * ax
		mov	cl,byte ptr ds:[345h]
		sub	cl,30h			; '0'
		mov	ch,0
		add	ax,cx
		mov	word ptr ds:[2A0h],ax
loc_0AF4:
		inc	byte ptr ds:[344h]
		jnz	loc_0A82		; Jump if not zero
loc_0AFA:
		mov	ax,word ptr ds:[2A0h]
		pop	bp
		retn
sub_0A73	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0AFF	proc	near
		push	bp
		mov	bp,sp
		mov	byte ptr ds:d_3C5A_02AE_e,0
		mov	byte ptr ds:d_3C5A_02AD_e,1
		mov	al,ds:d_3C5A_02A4_e
		rcr	al,1			; Rotate thru carry
		jc	loc_0B3A		; Jump if carry Set
		call	sub_23F8		; Get system timer
		mov	ds:d_3C5A_02A2_e,ax
		mov	ah,0
		mov	ds:d_3C5A_01D6_e,ax
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jnz	loc_0B28		; Jump if not zero
		mov	word ptr ds:d_3C5A_01D6_e,1BCh
loc_0B28:
		mov	al,byte ptr ds:d_3C5A_02A2_e+1
		mov	ah,0
		mov	ds:d_3C5A_01D8_e,ax
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jnz	loc_0B3A		; Jump if not zero
		mov	word ptr ds:d_3C5A_01D8_e,22Bh
loc_0B3A:
		mov	si,d_3C5A_0080_e
		mov	di,d_3C5A_02C4_e
		mov	cx,80h
		push	ds
		pop	es
		cld				; Clear direction
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]

; Restart game

loc_0B48:
		; install INT 09h handler
		mov	al,byte ptr ds:[2A4h]
		rcr	al,1			; Rotate thru carry
		jc	loc_0B52		; Jump if carry Set
		call	sub_2560		; Install INT 09h service (cs:2413)
loc_0B52:
		mov	byte ptr ds:[344h],0
loc_0B57:
		mov	al,byte ptr ds:[344h]
		mov	ah,0
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		cmp	byte ptr ds:[2C5h][si],20h	; ' '
		jne	loc_0B71		; Jump if not equal
		cmp	al,byte ptr ds:[2C4h]
		jae	loc_0B71		; Jump if above or =
		inc	byte ptr ds:[344h]
		jmp	short loc_0B57
loc_0B71:
		mov	al,byte ptr ds:[344h]
		cmp	al,byte ptr ds:[2C4h]
		jae	loc_0B8B		; Jump if above or =
		call	sub_0A73
		mov	byte ptr ds:[344h],al
		cmp	al,0Ah
		jae	loc_0B8B		; Jump if above or =
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_0B8B		; Jump if zero
		mov	byte ptr ds:[2ADh],al
loc_0B8B:
		mov	bl,byte ptr ds:[2AEh]
		mov	bh,0
		mov	al,byte ptr ds:[0EBBh][bx]
		mov	byte ptr ds:[2A6h],al
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[0E00h][bx]
		mov	word ptr ds:[1D2h],ax
		push	bx
		mov	bl,byte ptr ds:[2AEh]
		mov	bh,0
		mov	al,byte ptr ds:[0ED5h][bx]
		mov	byte ptr ds:[2A7h],al
		pop	si
		mov	ax,word ptr ds:[0E34h][si]
		mov	word ptr ds:[1D4h],ax
		mov	bl,byte ptr ds:[2ADh]
		dec	bl
		mov	bh,0
		mov	al,byte ptr ds:[0F23h][bx]
		mov	byte ptr ds:[2A5h],al
		mov	al,byte ptr ds:[0F35h][bx]
		mov	byte ptr ds:[2A8h],al
		mov	al,byte ptr ds:[0F2Ch][bx]
		mov	byte ptr ds:[2A9h],al
		mov	bl,byte ptr ds:[2AEh]
		mov	bh,0
		mov	al,byte ptr ds:[0EEFh][bx]
		mov	byte ptr ds:[2ABh],al
		mov	byte ptr ds:[2AAh],2
		mov	al,byte ptr ds:[0F09h][bx]
		mov	byte ptr ds:[2ACh],al

		; set cursor position to be not visible
		mov	al,19h ;16h
		push	ax
		mov	al,0
		push	ax
		call	sub_259A		; Set cursor position (and set cursor visible)
		call	sub_258F		; Set cursor size, to be not visible

		mov	word ptr ds:[1D0h],0
		call	sub_0609
		call	sub_0263
		call	sub_0FBD
		call	sub_25C0
		mov	al,0FFh
		push	ax			; PARAMETER_2
		mov	al,0
		push	ax			; PARAMETER_1
		call	sub_25E2
loc_0C14:
		mov	al,byte ptr ds:[0DE6h]
		rcr	al,1			; Rotate thru carry
		jc	loc_0C43		; Jump if carry Set
		call	sub_081A
		rcr	al,1			; Rotate thru carry
		jc	loc_0C46		; Jump if carry Set
		call	sub_2402		; Wait time tick
		call	sub_125C
		call	sub_2124
		call	sub_1EC1
		call	sub_10C9
		call	sub_1AB0
		rcr	al,1			; Rotate thru carry
		jc	loc_0C46		; Jump if carry Set
		call	sub_1D64
		call	sub_260E
		call	sub_09BB
		jmp	short loc_0C14
loc_0C43:
		call	sub_0231
loc_0C46:
		call	sub_25DB
		mov	byte ptr ds:[0DE6h],0
		mov	al,byte ptr ds:[2A4h]
		rcr	al,1			; Rotate thru carry
		jc	loc_0C58		; Jump if carry Set
		call	sub_247D
loc_0C58:
		; set cursor position
		mov	al,16h ;17h
		push	ax
		mov	al,0
		push	ax
		call	sub_259A		; Set cursor position (and set cursor visible)


; !!! Picopad modification - start new game
;		mov	byte ptr ds:[2C5h],0
		mov	byte ptr ds:[2C5h],59h

; Prompt to start new game

loc_0C66:
		mov	al,byte ptr ds:[2C5h]
		cmp	al,59h			; 'Y'
		je	loc_0C95		; Jump if equal
		cmp	al,4Eh			; 'N'
		je	loc_0C95		; Jump if equal
		mov	ax,0FBDh
		push	ax
		call	sub_015F		; Print DOS text
		mov	ax,2C3h
		push	ax
		call	sub_0163		; Input DOS text
		mov	al,byte ptr ds:[2C5h]
		mov	cl,61h			; 'a'
		cmp	al,cl
		jb	loc_0C66		; Jump if below
		cmp	al,7Ah			; 'z'
		ja	loc_0C66		; Jump if above
		sub	al,cl
		add	al,41h			; 'A'
		mov	byte ptr ds:[2C5h],al
		jmp	short loc_0C66
loc_0C95:
		cmp	byte ptr ds:[2C5h],4Eh	; 'N'
		jne	loc_0C9F		; Jump if not equal
		call	sub_012C
loc_0C9F:

; Prompt to enter game level

;		mov	ax,0FDCh
;		push	ax
;		call	sub_015F		; Print DOS text
;		mov	ax,2C3h
;		push	ax
;		call	sub_0163		; Input DOS text

		nop
		nop
		nop
		nop

		mov	byte ptr ds:[2C4h],1
		mov	byte ptr ds:[2C5h],41h


		jmp	loc_0B48
sub_0AFF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0CB0	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[0C6Ch]
		mov	byte ptr ds:[0C76h],al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_0CCA		; Jump if zero
		mov	cl,8
		mul	cl			; ax = reg * al
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,byte ptr ds:[350h][bx]
		mov	byte ptr ds:[0C6Ch],al
loc_0CCA:
		mov	al,byte ptr ds:[0C76h]
		pop	bp
		retn
sub_0CB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0CCF	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	al,[bp+PARAMETER_1]
		mov	cl,8
		mul	cl			; ax = reg * al
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cl,byte ptr ds:[0C6Ch]
		mov	byte ptr ds:[350h][bx],cl
		mov	al,[bp+PARAMETER_1]
		mov	byte ptr ds:[0C6Ch],al
		pop	bp
		retn	2
sub_0CCF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0CED	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx]
		dec	al
		mov	byte ptr ds:[0C79h],al
		mov	al,[bx+1]
		dec	al
		mov	byte ptr ds:[0C7Ah],al
		mov	al,[bp+PARAMETER_1]
		mov	ah,0
		mov	cl,7
		shl	ax,cl			; Shift w/zeros fill
		mov	word ptr ds:[0B50h],ax
		mov	byte ptr ds:[0C7Bh],0
loc_0D14:
		mov	al,byte ptr ds:[0C7Bh]
		cmp	al,byte ptr ds:[0C79h]
		ja	loc_0D7A		; Jump if above
		mov	al,[bp+PARAMETER_2]
		mov	byte ptr ds:[0C7Dh],al
		mov	byte ptr ds:[0C7Ch],0
loc_0D28:
		mov	al,byte ptr ds:[0C7Ch]
		cmp	al,byte ptr ds:[0C7Ah]
		ja	loc_0D60		; Jump if above
		mov	bl,byte ptr ds:[0C7Dh]
		mov	bh,0
		add	bx,word ptr ds:[0B50h]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		cmp	al,20h			; ' '
		je	loc_0D49		; Jump if equal
		mov	al,0FFh
		jmp	short loc_0D7C
loc_0D49:
		mov	al,byte ptr ds:[0C7Dh]
		inc	al
		mov	byte ptr ds:[0C7Dh],al
		cmp	al,7Fh
		jbe	loc_0D5A		; Jump if below or =
		mov	byte ptr ds:[0C7Dh],0
loc_0D5A:
		inc	byte ptr ds:[0C7Ch]
		jnz	loc_0D28		; Jump if not zero
loc_0D60:
		mov	ax,word ptr ds:[0B50h]
		add	ax,80h
		mov	word ptr ds:[0B50h],ax
		mov	cx,3C00h
		cmp	ax,cx
		jb	loc_0D74		; Jump if below
		sub	word ptr ds:[0B50h],cx
loc_0D74:
		inc	byte ptr ds:[0C7Bh]
		jnz	loc_0D14		; Jump if not zero
loc_0D7A:
		mov	al,0
loc_0D7C:
		pop	bp
		retn	4
sub_0CED	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0D80	proc	near
		push	bp
		mov	bp,sp
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx]
		dec	al
		mov	byte ptr ds:[0C7Eh],al
		mov	al,[bx+1]
		dec	al
		mov	byte ptr ds:[0C7Fh],al
		mov	al,0
		mov	byte ptr ds:[0C83h],al
		mov	bx,word ptr ds:[34Ah]
		mov	dl,[bx+3]
		mov	dh,0
		mov	cl,7
		shl	dx,cl			; Shift w/zeros fill
		mov	word ptr ds:[0B52h],dx
		mov	byte ptr ds:[0C81h],al
loc_0DAF:
		mov	al,byte ptr ds:[0C81h]
		cmp	al,byte ptr ds:[0C7Eh]
		ja	loc_0E28		; Jump if above
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+2]
		mov	byte ptr ds:[0C80h],al
		mov	byte ptr ds:[0C82h],0
loc_0DC7:
		mov	al,byte ptr ds:[0C82h]
		cmp	al,byte ptr ds:[0C7Fh]
		ja	loc_0E0E		; Jump if above
		mov	al,byte ptr ds:[0C83h]
		mov	ah,0
		shl	ax,1			; Shift w/zeros fill
		mov	bx,word ptr ds:[0B52h]
		mov	cl,byte ptr ds:[0C80h]
		mov	ch,0
		add	bx,cx
		shl	bx,1			; Shift w/zeros fill
		push	bx
		mov	bx,word ptr ds:[34Ch]
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	ax,[bx+si+2]
		pop	bx
		mov	word ptr ds:[15D0h][bx],ax
		inc	byte ptr ds:[0C83h]
		inc	cl
		mov	byte ptr ds:[0C80h],cl
		cmp	cl,7Fh
		jbe	loc_0E08		; Jump if below or =
		mov	byte ptr ds:[0C80h],0
loc_0E08:
		inc	byte ptr ds:[0C82h]
		jnz	loc_0DC7		; Jump if not zero
loc_0E0E:
		mov	ax,word ptr ds:[0B52h]
		add	ax,80h
		mov	word ptr ds:[0B52h],ax
		mov	cx,3C00h
		cmp	ax,cx
		jb	loc_0E22		; Jump if below
		sub	word ptr ds:[0B52h],cx
loc_0E22:
		inc	byte ptr ds:[0C81h]
		jnz	loc_0DAF		; Jump if not zero
loc_0E28:
		pop	bp
		retn
sub_0D80	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0E2A	proc	near
		push	bp
		mov	bp,sp
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx]
		dec	al
		mov	byte ptr ds:[0C84h],al
		mov	al,[bx+1]
		dec	al
		mov	byte ptr ds:[0C85h],al
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+3]
		mov	ah,0
		mov	cl,7
		shl	ax,cl			; Shift w/zeros fill
		mov	word ptr ds:[0B54h],ax
		mov	byte ptr ds:[0C87h],0
loc_0E55:
		mov	al,byte ptr ds:[0C87h]
		cmp	al,byte ptr ds:[0C84h]
		ja	loc_0EB7		; Jump if above
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+2]
		mov	byte ptr ds:[0C86h],al
		mov	byte ptr ds:[0C88h],0
loc_0E6D:
		mov	al,byte ptr ds:[0C88h]
		cmp	al,byte ptr ds:[0C85h]
		ja	loc_0E9D		; Jump if above
		mov	bx,word ptr ds:[0B54h]
		mov	al,byte ptr ds:[0C86h]
		mov	ah,0
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:[15D0h][bx],920h
		inc	al
		mov	byte ptr ds:[0C86h],al
		cmp	al,7Fh
		jbe	loc_0E97		; Jump if below or =
		mov	byte ptr ds:[0C86h],0
loc_0E97:
		inc	byte ptr ds:[0C88h]
		jnz	loc_0E6D		; Jump if not zero
loc_0E9D:
		mov	ax,word ptr ds:[0B54h]
		add	ax,80h
		mov	word ptr ds:[0B54h],ax
		mov	cx,3C00h
		cmp	ax,cx
		jb	loc_0EB1		; Jump if below
		sub	word ptr ds:[0B54h],cx
loc_0EB1:
		inc	byte ptr ds:[0C87h]
		jnz	loc_0E55		; Jump if not zero
loc_0EB7:
		pop	bp
		retn
sub_0E2A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0EB9	proc	near
		push	bp
		mov	bp,sp
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx]
		dec	al
		mov	byte ptr ds:[0C89h],al
		mov	al,[bx+1]
		dec	al
		mov	byte ptr ds:[0C8Ah],al
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+3]
		mov	ah,0
		mov	cl,7
		shl	ax,cl			; Shift w/zeros fill
		mov	word ptr ds:[0B56h],ax
		mov	byte ptr ds:[0C8Ch],0
loc_0EE4:
		mov	al,byte ptr ds:[0C8Ch]
		cmp	al,byte ptr ds:[0C89h]
		ja	loc_0F4E		; Jump if above
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+2]
		mov	byte ptr ds:[0C8Bh],al
		mov	byte ptr ds:[0C8Dh],0
loc_0EFC:
		mov	al,byte ptr ds:[0C8Dh]
		cmp	al,byte ptr ds:[0C8Ah]
		ja	loc_0F34		; Jump if above
		mov	bl,byte ptr ds:[0C8Bh]
		mov	bh,0
		add	bx,word ptr ds:[0B56h]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		cmp	al,0B2h
		jne	loc_0F1D		; Jump if not equal
		mov	al,0FFh
		pop	bp
		retn
loc_0F1D:
		mov	al,byte ptr ds:[0C8Bh]
		inc	al
		mov	byte ptr ds:[0C8Bh],al
		cmp	al,7Fh
		jbe	loc_0F2E		; Jump if below or =
		mov	byte ptr ds:[0C8Bh],0
loc_0F2E:
		inc	byte ptr ds:[0C8Dh]
		jnz	loc_0EFC		; Jump if not zero
loc_0F34:
		mov	ax,word ptr ds:[0B56h]
		add	ax,80h
		mov	word ptr ds:[0B56h],ax
		mov	cx,3C00h
		cmp	ax,cx
		jb	loc_0F48		; Jump if below
		sub	word ptr ds:[0B56h],cx
loc_0F48:
		inc	byte ptr ds:[0C8Ch]
		jnz	loc_0EE4		; Jump if not zero
loc_0F4E:
		mov	al,0
		pop	bp
		retn
sub_0EB9	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		call	sub_227A
		rcr	al,1			; Rotate thru carry
		jnc	loc_0F60		; Jump if carry=0
		mov	al,0
		pop	bp
		retn
loc_0F60:
		mov	al,byte ptr ds:[0C77h]
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+2],al
		mov	al,byte ptr ds:[0C78h]
		mov	[bx+3],al
		call	sub_0D80
		mov	al,0FFh
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0F77	proc	near
		push	bp			; PARAMETER_2
		mov	bp,sp
loc_0F7A:
		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_01FA
		mov	cx,8
		mul	cx			; dx:ax = reg * ax
;*		add	ax,4
		db	 83h,0C0h, 04h		;  Fixup - byte match
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+2],al
loc_0F90:
		mov	ax,1Fh
		push	ax
		call	sub_01FA
		mov	byte ptr ds:[0C8Eh],al
;*		cmp	ax,13h
		db	 83h,0F8h, 13h		;  Fixup - byte match
		ja	loc_0F90		; Jump if above
		mov	al,byte ptr ds:[0C8Eh]
		mov	cl,6
		mul	cl			; ax = reg * al
;*		add	ax,3
		db	 83h,0C0h, 03h		;  Fixup - byte match
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+3],al
		push	word ptr [bx+2]		; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_0CED
		rcr	al,1			; Rotate thru carry
		jc	loc_0F7A		; Jump if carry Set
		pop	bp
		retn
sub_0F77	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0FBD	proc	near
		push	bp
		mov	bp,sp
		mov	word ptr ds:[0B58h],0
loc_0FC6:
		mov	ax,word ptr ds:[0B58h]
		cmp	ax,0FCh
		ja	loc_0FE7		; Jump if above
;*		add	ax,2
		db	 83h,0C0h, 02h		;  Fixup - byte match
		push	ax
		mov	ax,word ptr ds:[0B58h]
		mov	cx,8
		mul	cx			; dx:ax = reg * ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		pop	cx
		mov	byte ptr ds:[358h][bx],cl
		inc	word ptr ds:[0B58h]
		jnz	loc_0FC6		; Jump if not zero
loc_0FE7:
		mov	al,0
		mov	byte ptr ds:[0B38h],al
		mov	cl,1
		mov	byte ptr ds:[0C6Ch],cl
		mov	byte ptr ds:[0C6Dh],al
		mov	byte ptr ds:[0C6Fh],al
		mov	byte ptr ds:[0C71h],al
		mov	byte ptr ds:[0C6Eh],al
		mov	byte ptr ds:[0C70h],al
		mov	ch,0
		mov	word ptr ds:[0B58h],cx
loc_1007:
		mov	al,byte ptr ds:[2A8h]
		mov	ah,0
		cmp	word ptr ds:[0B58h],ax
		ja	loc_1070		; Jump if above
		call	sub_0CB0
		mov	ah,0
		mov	word ptr ds:[0B5Ah],ax
		mov	cx,8
		mul	cx			; dx:ax = reg * ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cl,byte ptr ds:[0C70h]
		mov	byte ptr ds:[350h][bx],cl
		mov	al,byte ptr ds:[0B5Ah]
		mov	byte ptr ds:[0C70h],al
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		lea	ax,cs:[350h][si]	; Load effective addr
		mov	word ptr ds:[34Ah],ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cx,1002h
		mov	[bx+6],cx
		mov	word ptr ds:[34Ch],cx
		call	sub_0F77
		mov	bx,word ptr ds:[34Ah]
		mov	byte ptr [bx+1],0
		mov	ax,0Fh
		push	ax
		call	sub_01FA
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+5],al
		mov	byte ptr [bx+4],1
		call	sub_0D80
		inc	word ptr ds:[0B58h]
		jnz	loc_1007		; Jump if not zero
loc_1070:
		mov	al,byte ptr ds:[2A8h]
		mov	byte ptr ds:[0B65h],al
		mov	ax,0
		mov	word ptr ds:[348h],ax
		mov	byte ptr ds:[0B68h],al
		mov	byte ptr ds:[0B67h],al
		mov	word ptr ds:[346h],ax
		mov	byte ptr ds:[0B66h],al
		mov	byte ptr ds:[0B64h],al
		mov	word ptr ds:[34Eh],ax
		mov	byte ptr ds:[0C75h],al
		mov	byte ptr ds:[0C74h],al
		mov	byte ptr ds:[0C73h],al
		mov	byte ptr ds:[0C72h],al
		mov	ax,10E2h
		mov	word ptr ds:[356h],ax
		mov	word ptr ds:[34Ch],ax
		mov	word ptr ds:[34Ah],350h
		call	sub_0F77
		call	sub_0D80
		mov	al,byte ptr ds:[352h]
		mov	ah,0
		mov	word ptr ds:[1CAh],ax
		mov	al,byte ptr ds:[353h]
		mov	ah,0
		mov	word ptr ds:[1CCh],ax
		mov	al,1
		mov	byte ptr ds:[355h],al
		mov	byte ptr ds:[351h],al
		pop	bp
		retn
sub_0FBD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_10C9	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[0C70h]
loc_10CF:
		mov	byte ptr ds:[0C8Fh],al
loc_10D2:
		mov	al,byte ptr ds:[0C8Fh]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_10DC		; Jump if not zero
		jmp	loc_125A
loc_10DC:
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		lea	ax,cs:[350h][si]	; Load effective addr
		mov	word ptr ds:[34Ah],ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cl,[bx+5]
		inc	cl
		mov	[bx+5],cl
		cmp	cl,0Fh
		jbe	loc_10FE		; Jump if below or =
		mov	byte ptr [bx+5],0
loc_10FE:
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+5]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[10A2h][bx]
		mov	word ptr ds:[34Ch],ax
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+6],ax
		call	sub_0EB9
		rcr	al,1			; Rotate thru carry
		jnc	loc_113E		; Jump if carry=0
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx]
		mov	byte ptr ds:[0C90h],al
		push	word ptr ds:[0C8Fh]	; PARAMETER_2
		mov	ax,0C70h
		push	ax			; PARAMETER_1
		call	sub_1E8F
		mov	al,byte ptr ds:[0C90h]
		mov	byte ptr ds:[0C8Fh],al
		dec	byte ptr ds:[0B65h]
		jmp	short loc_10D2
loc_113E:
		call	sub_0E2A
		call	sub_0D80
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+4]
		dec	al
		mov	[bx+4],al
		jnz	loc_1193		; Jump if not zero
		call	sub_237D
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+4],al
		cmp	byte ptr ds:[1D1h],0Eh
		jbe	loc_1169		; Jump if below or =
		mov	byte ptr [bx+4],5
		jmp	short loc_117D
loc_1169:
		mov	cl,byte ptr ds:[1D1h]
		inc	cl
		mov	al,byte ptr ds:[0B69h]
		shr	al,cl			; Shift w/zeros fill
		add	al,5
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+4],al
loc_117D:
		mov	cl,byte ptr ds:[2A8h]
		inc	cl
		sub	cl,byte ptr ds:[0B65h]
		mov	al,1Fh
		shr	al,cl			; Shift w/zeros fill
		mov	ah,0
		push	ax
		call	sub_01FA
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
loc_1193:
		jz	loc_1198		; Jump if zero
		jmp	loc_1251
loc_1198:
		mov	word ptr ds:[34Ch],1112h
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+2]
		add	al,2
		mov	byte ptr ds:[0C91h],al
		mov	cl,7Fh
		cmp	al,cl
		jbe	loc_11B4		; Jump if below or =
		sub	byte ptr ds:[0C91h],cl
loc_11B4:
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+3]
		mov	byte ptr ds:[0C92h],al
		push	word ptr ds:[0C91h]	; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_0CED
		rcr	al,1			; Rotate thru carry
		jnc	loc_11CD		; Jump if carry=0
		jmp	loc_1251
loc_11CD:
		mov	al,byte ptr ds:[0B64h]
		add	al,byte ptr ds:[0B68h]
		cmp	al,byte ptr ds:[2A5h]
		jae	loc_1251		; Jump if above or =
		call	sub_0CB0
		mov	byte ptr ds:[0C90h],al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_1251		; Jump if zero
		inc	byte ptr ds:[0B64h]
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx]
		mov	byte ptr ds:[0C8Fh],al
		mov	al,byte ptr ds:[0C90h]
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		lea	ax,cs:[350h][si]	; Load effective addr
		mov	word ptr ds:[34Ah],ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cl,byte ptr ds:[0C6Eh]
		mov	[bx],cl
		mov	al,byte ptr ds:[0C90h]
		mov	byte ptr ds:[0C6Eh],al
		mov	al,byte ptr ds:[0C91h]
		mov	[bx+2],al
		mov	al,byte ptr ds:[0C92h]
		mov	[bx+3],al
		mov	byte ptr [bx+4],2
		mov	word ptr [bx+6],1112h
		call	sub_0D80
		mov	ax,1
		push	ax
		call	sub_01FA
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jnz	loc_123E		; Jump if not zero
		mov	bx,word ptr ds:[34Ah]
		mov	byte ptr [bx+1],0
		jmp	short loc_1246
loc_123E:
		mov	bx,word ptr ds:[34Ah]
		mov	byte ptr [bx+1],1
loc_1246:
		mov	bx,word ptr ds:[34Ah]
		mov	byte ptr [bx+5],4
		jmp	loc_10D2
loc_1251:
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx]
		jmp	loc_10CF
loc_125A:
		pop	bp
		retn
sub_10C9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_125C	proc	near
		push	bp
		mov	bp,sp
		mov	byte ptr ds:[0C94h],0
		mov	al,byte ptr ds:[0C6Dh]
loc_1267:
		mov	byte ptr ds:[0C93h],al
		mov	al,byte ptr ds:[0C93h]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_1274		; Jump if not zero
		jmp	loc_154D
loc_1274:
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		lea	ax,cs:[350h][si]	; Load effective addr
		mov	word ptr ds:[34Ah],ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	dl,[bx+3]
		mov	dh,0
		mov	cl,7
		shl	dx,cl			; Shift w/zeros fill
		mov	cl,[bx+2]
		mov	ch,0
		add	cx,dx
		mov	word ptr ds:[0B5Ch],cx
		shl	cx,1			; Shift w/zeros fill
		xchg	cx,bx
		mov	dx,word ptr ds:[15D0h][bx]
		cmp	dl,0B2h
		jne	loc_12C7		; Jump if not equal
		xchg	bx,ax
		mov	cl,[bx]
		mov	byte ptr ds:[0C95h],cl
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	word ptr ds:[15D0h][bx],920h
		push	word ptr ds:[0C93h]	; PARAMETER_2
		mov	ax,0C6Dh
		push	ax			; PARAMETER_1
		call	sub_1E8F
		dec	byte ptr ds:[0B67h]
		jmp	loc_1547
loc_12C7:
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:[15D0h][bx],920h
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+4]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_12E3[bx]	;*8 entries
data_12E3	dw	offset loc_1390		; Data table (indexed access)
data_12E5	dw	offset loc_12F6
data_12E7	dw	offset loc_133A
data_12E9	dw	offset loc_1315
data_12EB	dw	offset loc_133E
data_12ED	dw	offset loc_1342
data_12EF	dw	offset loc_1367
data_12F1	dw	offset loc_136B
		db	0E9h, 9Ah, 00h

;===== Indexed Entry Point ================================================

loc_12F6:
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
loc_12FE:
		jc	loc_1373		; Jump if carry Set
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1390		; Jump if carry=0
		mov	al,1
		jmp	short loc_1388

;===== Indexed Entry Point ================================================

loc_1315:
		mov	al,2
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
		jc	loc_12FE		; Jump if carry Set
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_133A		; Jump if carry=0
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
		jc	loc_12FE		; Jump if carry Set

;===== Indexed Entry Point ================================================

loc_133A:
		mov	al,1
		jmp	short loc_1392

;===== Indexed Entry Point ================================================

loc_133E:
		mov	al,2
		jmp	short loc_1392

;===== Indexed Entry Point ================================================

loc_1342:
		mov	al,2
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
		jc	loc_12FE		; Jump if carry Set
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1367		; Jump if carry=0
		mov	al,3
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
		jc	loc_12FE		; Jump if carry Set

;===== Indexed Entry Point ================================================

loc_1367:
		mov	al,3
		jmp	short loc_1392

;===== Indexed Entry Point ================================================

loc_136B:
		mov	al,3
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
loc_1373:
		jc	loc_13EF		; Jump if carry Set
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1390		; Jump if carry=0
		mov	al,3
loc_1388:
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
		jc	loc_13EF		; Jump if carry Set

;===== Indexed Entry Point ================================================

loc_1390:
		mov	al,0
loc_1392:
		push	ax			; PARAMETER_1
		call	sub_154F
		rcr	al,1			; Rotate thru carry
		jc	loc_13EF		; Jump if carry Set
loc_139A:
		mov	bx,word ptr ds:[34Ah]
		cmp	byte ptr [bx+1],6
		jae	loc_13C5		; Jump if above or =
		mov	al,[bx+5]
		inc	al
		mov	[bx+5],al
		cmp	al,3
		jbe	loc_13B4		; Jump if below or =
		mov	byte ptr [bx+5],0
loc_13B4:
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+5]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[11D4h][bx]
		jmp	short loc_13CC
loc_13C5:
		mov	bx,word ptr ds:[34Ah]
		mov	ax,[bx+6]
loc_13CC:
		mov	word ptr ds:[34Ch],ax
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	si,word ptr ds:[34Ch]
		mov	ax,[si+2]
		mov	word ptr ds:[15D0h][bx],ax
		mov	al,byte ptr ds:[0C93h]
		mov	byte ptr ds:[0C94h],al
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx]
		jmp	loc_1267
loc_13EF:
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,1281h
		mov	cx,0Bh
		push	ds
		pop	es
		cld				; Clear direction
loc_1402:
		mov	dx,cx
		jcxz	loc_140C		; Jump if cx=0
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_1402		; Jump if not zero
		sub	dx,cx
loc_140C:
		dec	dx
		mov	cx,0FFFFh
		cmp	dx,cx
		je	loc_1417		; Jump if equal
		jmp	loc_14A9
loc_1417:
		mov	si,word ptr ds:[34Ah]
;*		cmp	byte ptr [si+1],0
		db	 82h, 7Ch, 01h, 00h	;  Fixup - byte match
		jnz	loc_146B		; Jump if not zero
		mov	di,128Ch
		mov	cx,6
loc_1427:
		mov	dx,cx
		jcxz	loc_1431		; Jump if cx=0
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_1427		; Jump if not zero
		sub	dx,cx
loc_1431:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jz	loc_143D		; Jump if zero
		inc	word ptr ds:[34Eh]
		jmp	short loc_149B
loc_143D:
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,1004h
		mov	cx,4
		push	ds
		pop	es
		cld				; Clear direction
loc_1450:
		mov	dx,cx
		jcxz	loc_145A		; Jump if cx=0
		repne	scasw			; Rep zf=0+cx >0 Scan es:[di] for ax
		jnz	loc_1450		; Jump if not zero
		sub	dx,cx
loc_145A:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jnz	loc_1464		; Jump if not zero
		cmp	al,0FFh
		jne	loc_149B		; Jump if not equal
loc_1464:
		add	word ptr ds:[34Eh],32h
		jmp	short loc_149B
loc_146B:
		mov	al,byte ptr ds:[2ABh]
		rcr	al,1			; Rotate thru carry
		jc	loc_149B		; Jump if carry Set
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,1004h
		mov	cx,4
		push	ds
		pop	es
		cld				; Clear direction
loc_1485:
		mov	dx,cx
		jcxz	loc_148F		; Jump if cx=0
		repne	scasw			; Rep zf=0+cx >0 Scan es:[di] for ax
		jnz	loc_1485		; Jump if not zero
		sub	dx,cx
loc_148F:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jnz	loc_150E		; Jump if not zero
		cmp	al,0FFh
		jne	loc_149B		; Jump if not equal
		jmp	short loc_150E
loc_149B:
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:[15D0h][bx],0FB2h
		jmp	short loc_150E
loc_14A9:
		mov	al,byte ptr ds:[2ACh]
		rcr	al,1			; Rotate thru carry
		jnc	loc_150E		; Jump if carry=0
		mov	bx,word ptr ds:[34Ah]
;*		cmp	byte ptr [bx+1],0
		db	 82h, 7Fh, 01h, 00h	;  Fixup - byte match
		jnz	loc_150E		; Jump if not zero
		mov	bl,byte ptr ds:[0C93h]
		mov	bh,0
;*		cmp	byte ptr ds:[0B6Ch][bx],0
		db	 82h,0BFh, 6Ch, 0Bh, 00h	;  Fixup - byte match
		jz	loc_150E		; Jump if zero
		mov	bx,word ptr ds:[34Ah]
		test	byte ptr [bx+4],1
		jnz	loc_14D3		; Jump if not zero
		jmp	short loc_150E
loc_14D3:
		mov	bl,byte ptr ds:[0C93h]
		mov	bh,0
		dec	byte ptr ds:[0B6Ch][bx]
		mov	bl,byte ptr ds:[0C96h]
		mov	cl,3
		shl	bl,cl			; Shift w/zeros fill
		mov	si,word ptr ds:[34Ah]
		mov	al,[si+4]
		add	bl,al
		mov	bh,0
		mov	al,byte ptr ds:[1261h][bx]
		mov	[si+4],al
		mov	al,0
		push	ax			; PARAMETER_2
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_25E2
		mov	al,byte ptr ds:[0C96h]
		add	al,2
		and	al,3
		push	ax			; PARAMETER_1
		call	sub_154F
		jmp	loc_139A
loc_150E:
		dec	byte ptr ds:[0B67h]
;*		cmp	byte ptr ds:[0C94h],0
		db	 82h, 3Eh, 94h, 0Ch, 00h	;  Fixup - byte match
		jnz	loc_1524		; Jump if not zero
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx]
		mov	byte ptr ds:[0C6Dh],al
		jmp	short loc_1537
loc_1524:
		mov	al,byte ptr ds:[0C94h]
		mov	cl,8
		mul	cl			; ax = reg * al
		mov	bx,word ptr ds:[34Ah]
		mov	cl,[bx]
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	byte ptr ds:[350h][bx],cl
loc_1537:
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx]
		mov	byte ptr ds:[0C95h],al
		push	word ptr ds:[0C93h]	; PARAMETER_1
		call	sub_0CCF
loc_1547:
		mov	al,byte ptr ds:[0C95h]
		jmp	loc_1267
loc_154D:
		pop	bp
		retn
sub_125C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_154F	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	al,[bp+PARAMETER_1]
		mov	byte ptr ds:[0C96h],al
		mov	ah,0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_1563[bx]	;*4 entries
data_1563	dw	offset loc_156B		; Data table (indexed access)
data_1565	dw	offset loc_1590
data_1567	dw	offset loc_15B5
data_1569	dw	offset loc_15DA

;===== Indexed Entry Point ================================================

loc_156B:
		mov	ax,word ptr ds:[0B5Ch]
		sub	ax,80h
		mov	word ptr ds:[0B5Ch],ax
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+3]
		dec	al
		mov	[bx+3],al
		cmp	al,0FFh
		jne	loc_15FB		; Jump if not equal
		mov	byte ptr [bx+3],77h	; 'w'
		add	word ptr ds:[0B5Ch],3C00h
		jmp	short loc_15FB

;===== Indexed Entry Point ================================================

loc_1590:
		mov	ax,word ptr ds:[0B5Ch]
		inc	ax
		mov	word ptr ds:[0B5Ch],ax
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+2]
		inc	al
		mov	[bx+2],al
		mov	cl,80h
		cmp	al,cl
		jb	loc_15FB		; Jump if below
		mov	byte ptr [bx+2],0
		mov	ch,0
		sub	word ptr ds:[0B5Ch],cx
		jmp	short loc_15FB

;===== Indexed Entry Point ================================================

loc_15B5:
		mov	ax,word ptr ds:[0B5Ch]
		add	ax,80h
		mov	word ptr ds:[0B5Ch],ax
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+3]
		inc	al
		mov	[bx+3],al
		cmp	al,78h			; 'x'
		jb	loc_15FB		; Jump if below
		mov	byte ptr [bx+3],0
		sub	word ptr ds:[0B5Ch],3C00h
		jmp	short loc_15FB

;===== Indexed Entry Point ================================================

loc_15DA:
		mov	ax,word ptr ds:[0B5Ch]
		dec	ax
		mov	word ptr ds:[0B5Ch],ax
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+2]
		dec	al
		mov	[bx+2],al
		cmp	al,0FFh
		jne	loc_15FB		; Jump if not equal
		mov	byte ptr [bx+2],7Fh
		add	word ptr ds:[0B5Ch],80h
loc_15FB:
		mov	bx,word ptr ds:[0B5Ch]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		cmp	al,20h			; ' '
		jne	loc_160D		; Jump if not equal
		mov	al,0
		jmp	short loc_160F
loc_160D:
		mov	al,0FFh
loc_160F:
		pop	bp
		retn	2
sub_154F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1613	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	bx,word ptr ds:[34Ah]
		mov	al,[bx+4]
		mov	byte ptr ds:[0C97h],al
		mov	cl,[bx+2]
		mov	byte ptr ds:[0C98h],cl
		mov	cl,[bx+3]
		mov	byte ptr ds:[0C99h],cl
		mov	ah,0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_1639[bx]	;*8 entries
data_1639	dw	offset loc_16A1		; Data table (indexed access)
data_163B	dw	offset loc_1649
data_163D	dw	offset loc_1656
data_163F	dw	offset loc_1663
data_1641	dw	offset loc_1670
data_1643	dw	offset loc_1687
data_1645	dw	offset loc_1697
data_1647	dw	offset loc_169D

;===== Indexed Entry Point ================================================

loc_1649:
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx+1]
		add	byte ptr ds:[0C98h],al
		jmp	short loc_16A1

;===== Indexed Entry Point ================================================

loc_1656:
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx+1]
		add	byte ptr ds:[0C98h],al
		jmp	short loc_16A5

;===== Indexed Entry Point ================================================

loc_1663:
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx+1]
		add	byte ptr ds:[0C98h],al
		jmp	short loc_168F

;===== Indexed Entry Point ================================================

loc_1670:
		mov	bx,word ptr ds:[34Ch]
		mov	al,[bx]
		add	byte ptr ds:[0C99h],al
		mov	al,byte ptr ds:[0C98h]
		add	al,[bx+1]
		dec	al
		mov	byte ptr ds:[0C98h],al
		jmp	short loc_16A5

;===== Indexed Entry Point ================================================

loc_1687:
		dec	byte ptr ds:[0C98h]
		mov	bx,word ptr ds:[34Ch]
loc_168F:
		mov	al,[bx]
		add	byte ptr ds:[0C99h],al
		jmp	short loc_16A5

;===== Indexed Entry Point ================================================

loc_1697:
		dec	byte ptr ds:[0C98h]
		jmp	short loc_16A5

;===== Indexed Entry Point ================================================

loc_169D:
		dec	byte ptr ds:[0C98h]

;===== Indexed Entry Point ================================================

loc_16A1:
		dec	byte ptr ds:[0C99h]
loc_16A5:
		mov	al,byte ptr ds:[0C98h]
		cmp	al,7Fh
		jbe	loc_16BC		; Jump if below or =
		cmp	al,0F0h
		jbe	loc_16B7		; Jump if below or =
		add	byte ptr ds:[0C98h],80h
		jmp	short loc_16BC
loc_16B7:
		sub	byte ptr ds:[0C98h],80h
loc_16BC:
		mov	al,byte ptr ds:[0C99h]
		cmp	al,77h			; 'w'
		jbe	loc_16D3		; Jump if below or =
		cmp	al,0F0h
		jbe	loc_16CE		; Jump if below or =
		add	byte ptr ds:[0C99h],78h	; 'x'
		jmp	short loc_16D3
loc_16CE:
		sub	byte ptr ds:[0C99h],78h	; 'x'
loc_16D3:
		mov	ax,word ptr ds:[34Ch]
		mov	word ptr ds:[0B60h],ax
		mov	word ptr ds:[34Ch],1150h
		push	word ptr ds:[0C98h]	; PARAMETER_2
		push	word ptr ds:[0C99h]	; PARAMETER_1
		call	sub_0CED
		rcr	al,1			; Rotate thru carry
		jc	loc_16F1		; Jump if carry Set
		jmp	loc_17C3
loc_16F1:
		mov	al,byte ptr ds:[0C99h]
		mov	ah,0
		mov	cl,7
		shl	ax,cl			; Shift w/zeros fill
		mov	cl,byte ptr ds:[0C98h]
		mov	ch,0
		add	ax,cx
		mov	word ptr ds:[0B5Eh],ax
		shl	ax,1			; Shift w/zeros fill
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,1292h
		mov	cx,0Bh
		push	ds
		pop	es
		cld				; Clear direction
loc_1716:
		mov	dx,cx
		jcxz	loc_1720		; Jump if cx=0
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_1716		; Jump if not zero
		sub	dx,cx
loc_1720:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jz	loc_1729		; Jump if zero
		jmp	loc_1899
loc_1729:
;*		cmp	byte ptr [bp+PARAMETER_1],0
		db	 82h, 7Eh, 04h, 00h	;  Fixup - byte match
		jnz	loc_1786		; Jump if not zero
		mov	bx,word ptr ds:[0B5Eh]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,129Dh
		mov	cx,6
		push	ds
		pop	es
		cld				; Clear direction
loc_1742:
		mov	dx,cx
		jcxz	loc_174C		; Jump if cx=0
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_1742		; Jump if not zero
		sub	dx,cx
loc_174C:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jz	loc_1758		; Jump if zero
		inc	word ptr ds:[34Eh]
		jmp	short loc_17B4
loc_1758:
		mov	bx,word ptr ds:[0B5Eh]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,1004h
		mov	cx,4
		push	ds
		pop	es
		cld				; Clear direction
loc_176B:
		mov	dx,cx
		jcxz	loc_1775		; Jump if cx=0
		repne	scasw			; Rep zf=0+cx >0 Scan es:[di] for ax
		jnz	loc_176B		; Jump if not zero
		sub	dx,cx
loc_1775:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jnz	loc_177F		; Jump if not zero
		cmp	al,0FFh
		jne	loc_17B4		; Jump if not equal
loc_177F:
		add	word ptr ds:[34Eh],32h
		jmp	short loc_17B4
loc_1786:
		mov	al,byte ptr ds:[2ABh]
		rcr	al,1			; Rotate thru carry
		jc	loc_17B4		; Jump if carry Set
		mov	bx,word ptr ds:[0B5Eh]
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[15D0h][bx]
		mov	di,1004h
		mov	cx,4
		push	ds
		pop	es
		cld				; Clear direction
loc_17A0:
		mov	dx,cx
		jcxz	loc_17AA		; Jump if cx=0
		repne	scasw			; Rep zf=0+cx >0 Scan es:[di] for ax
		jnz	loc_17A0		; Jump if not zero
		sub	dx,cx
loc_17AA:
		dec	dx
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jnz	loc_17C0		; Jump if not zero
		cmp	al,0FFh
		je	loc_17C0		; Jump if equal
loc_17B4:
		mov	bx,word ptr ds:[0B5Eh]
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr ds:[15D0h][bx],0FB2h
loc_17C0:
		jmp	loc_1899
loc_17C3:
		call	sub_0CB0
		mov	byte ptr ds:[0C9Bh],al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_17C0		; Jump if zero
		cmp	byte ptr ds:[0B67h],32h	; '2'
		ja	loc_17C0		; Jump if above
		inc	byte ptr ds:[0B67h]
		mov	ax,word ptr ds:[34Ah]
		mov	word ptr ds:[0B62h],ax
		mov	al,byte ptr ds:[0C9Bh]
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		lea	ax,cs:[350h][si]	; Load effective addr
		mov	word ptr ds:[34Ah],ax
;*		cmp	byte ptr ds:[0C6Dh],0
		db	 82h, 3Eh, 6Dh, 0Ch, 00h	;  Fixup - byte match
		jnz	loc_17FF		; Jump if not zero
		mov	al,byte ptr ds:[0C9Bh]
		mov	byte ptr ds:[0C6Dh],al
		jmp	short loc_182D
loc_17FF:
		mov	al,byte ptr ds:[0C6Dh]
		mov	byte ptr ds:[0C9Ah],al
loc_1805:
		mov	al,byte ptr ds:[0C9Ah]
		mov	cl,8
		mul	cl			; ax = reg * al
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	dl,byte ptr ds:[350h][bx]
;*		or	dl,dl			; Zero ?
		db	 08h,0D2h		;  Fixup - byte match
		jz	loc_181C		; Jump if zero
		mov	byte ptr ds:[0C9Ah],dl
		jmp	short loc_1805
loc_181C:
		mov	al,byte ptr ds:[0C9Ah]
		mov	cl,8
		mul	cl			; ax = reg * al
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cl,byte ptr ds:[0C9Bh]
		mov	byte ptr ds:[350h][bx],cl
loc_182D:
		mov	bx,word ptr ds:[34Ah]
		mov	byte ptr [bx],0
		cmp	byte ptr [bp+PARAMETER_1],6
		jae	loc_1841		; Jump if above or =
		mov	word ptr [bx+6],1150h
		jmp	short loc_1854
loc_1841:
		mov	bl,byte ptr ds:[0C97h]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[11B4h][bx]
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+6],ax
loc_1854:
		mov	al,byte ptr ds:[0C98h]
		mov	bx,word ptr ds:[34Ah]
		mov	[bx+2],al
		mov	al,byte ptr ds:[0C99h]
		mov	[bx+3],al
		mov	al,byte ptr ds:[0C97h]
		mov	[bx+4],al
		mov	byte ptr [bx+5],0
		mov	al,[bp+PARAMETER_1]
		mov	[bx+1],al
		mov	ax,7
		push	ax
		call	sub_01FA
		inc	ax
		mov	bl,byte ptr ds:[0C9Bh]
		mov	bh,0
		mov	byte ptr ds:[0B6Ch][bx],al
		mov	bx,word ptr ds:[34Ah]
		mov	ax,[bx+6]
		mov	word ptr ds:[34Ch],ax
		call	sub_0D80
		mov	ax,word ptr ds:[0B62h]
		mov	word ptr ds:[34Ah],ax
loc_1899:
		mov	ax,word ptr ds:[0B60h]
		mov	word ptr ds:[34Ch],ax
		pop	bp
		retn	2
sub_1613	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_18A3	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[0B69h]
		mov	cx,word ptr ds:[1D2h]
		shr	al,cl			; Shift w/zeros fill
		mov	byte ptr ds:[0C9Ch],al
		cmp	al,0Ah
		ja	loc_18C9		; Jump if above
		mov	cl,0Fh
		sub	cl,byte ptr ds:[0C9Ch]
		mov	ax,0FFFFh
		shr	ax,cl			; Shift w/zeros fill
		push	ax
		call	sub_01FA
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jz	loc_18CD		; Jump if zero
loc_18C9:
		mov	al,0
		pop	bp
		retn
loc_18CD:
		mov	al,6
		push	ax			; PARAMETER_1
		call	sub_1613
		mov	al,1
		push	ax			; PARAMETER_2
		mov	al,0
		push	ax			; PARAMETER_1
		call	sub_25E2
		mov	al,0FFh
		pop	bp
		retn
sub_18A3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_18E0	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[2A4h]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1967		; Jump if carry=0
		call	sub_0167		; Check key input
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_1963		; Jump if zero
		call	sub_015A		; Input DOS key without echo, wait
		mov	byte ptr ds:[0CADh],al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_1934		; Jump if zero
		cmp	al,61h			; 'a'
		je	loc_1903		; Jump if equal
		cmp	al,41h			; 'A'
		jne	loc_1907		; Jump if not equal
loc_1903:
		mov	al,20h			; ' '
		pop	bp
		retn
loc_1907:
		mov	al,byte ptr ds:[0CADh]
		cmp	al,64h			; 'd'
		je	loc_1912		; Jump if equal
		cmp	al,44h			; 'D'
		jne	loc_1916		; Jump if not equal
loc_1912:
		mov	al,10h
		pop	bp
		retn
loc_1916:
		mov	al,byte ptr ds:[0CADh]
		cmp	al,77h			; 'w'
		je	loc_1921		; Jump if equal
		cmp	al,57h			; 'W'
		jne	loc_1925		; Jump if not equal
loc_1921:
		mov	al,80h
		pop	bp
		retn
loc_1925:
		mov	al,byte ptr ds:[0CADh]
		cmp	al,73h			; 's'
		je	loc_1930		; Jump if equal
		cmp	al,53h			; 'S'
		jne	loc_1963		; Jump if not equal
loc_1930:
		mov	al,40h			; '@'
		pop	bp
		retn
loc_1934:
		call	sub_015A		; Input DOS key without echo, wait
		mov	byte ptr ds:[0CADh],al

		cmp	al,48h			; 'H'
		jne	loc_1942		; Jump if not equal
		mov	al,8
		pop	bp
		retn
loc_1942:
		cmp	byte ptr ds:[0CADh],50h	; 'P'
		jne	loc_194D		; Jump if not equal
		mov	al,4
		pop	bp
		retn
loc_194D:
		cmp	byte ptr ds:[0CADh],4Bh	; 'K'
		jne	loc_1958		; Jump if not equal
		mov	al,2
		pop	bp
		retn
loc_1958:
		cmp	byte ptr ds:[0CADh],4Dh	; 'M'
		jne	loc_1963		; Jump if not equal
		mov	al,1
		pop	bp
		retn
loc_1963:
		mov	al,0
		pop	bp
		retn
loc_1967:
		call	sub_2492
		mov	byte ptr ds:[0CADh],al
		mov	cl,4
		shr	al,cl			; Shift w/zeros fill
		mov	ah,0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,byte ptr ds:[0C9Dh][bx]
		shl	al,cl			; Shift w/zeros fill
		mov	bl,byte ptr ds:[0CADh]
		and	bl,0Fh
		mov	bh,0
		or	al,byte ptr ds:[0C9Dh][bx]
		pop	bp
		retn
sub_18E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_198A	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[354h]
		mov	ah,0
		mov	byte ptr ds:[0CBEh],al
		mov	byte ptr ds:[0CBFh],0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_19A3[bx]	;*8 entries
data_19A3	dw	offset loc_1A5E		; Data table (indexed access)
data_19A5	dw	offset loc_19B6
data_19A7	dw	offset loc_1A5A
data_19A9	dw	offset loc_19E3
data_19AB	dw	offset loc_1A06
data_19AD	dw	offset loc_1A0A
data_19AF	dw	offset loc_1A2B
data_19B1	dw	offset loc_1A2F
loc_19B3:
		jmp	loc_1A5E

;===== Indexed Entry Point ================================================

loc_19B6:
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_1A7B
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_19B3		; Jump if carry=0
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_1A7B
		rcr	al,1			; Rotate thru carry
		jc	loc_19B3		; Jump if carry Set
		mov	al,0
		push	ax			; PARAMETER_1
		call	sub_1A7B
		rcr	al,1			; Rotate thru carry
		jnc	loc_1A58		; Jump if carry=0
		jmp	short loc_1A2B

;===== Indexed Entry Point ================================================

loc_19E3:
		mov	al,2
		push	ax			; PARAMETER_1
		call	sub_1A7B
		rcr	al,1			; Rotate thru carry
		jc	loc_1A5A		; Jump if carry Set
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1A5A		; Jump if carry=0
		mov	al,1
		push	ax			; PARAMETER_1
		call	sub_1A7B
		jmp	short loc_1A5A

;===== Indexed Entry Point ================================================

loc_1A06:
		mov	al,2
		jmp	short loc_1A60

;===== Indexed Entry Point ================================================

loc_1A0A:
		mov	al,2
		push	ax			; PARAMETER_1
		call	sub_1A7B
		rcr	al,1			; Rotate thru carry
		jc	loc_1A2B		; Jump if carry Set
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1A2B		; Jump if carry=0
		mov	al,3
		push	ax			; PARAMETER_1
		call	sub_1A7B

;===== Indexed Entry Point ================================================

loc_1A2B:
		mov	al,3
		jmp	short loc_1A60

;===== Indexed Entry Point ================================================

loc_1A2F:
		mov	al,3
		push	ax			; PARAMETER_1
		call	sub_1A7B
		mov	bx,word ptr ds:[34Ah]
		mov	bl,[bx+3]
		mov	bh,0
		mov	al,byte ptr ds:[11E8h][bx]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1A5E		; Jump if carry=0
		mov	al,3
		push	ax			; PARAMETER_1
		call	sub_1A7B
		rcr	al,1			; Rotate thru carry
		jc	loc_1A5E		; Jump if carry Set
		mov	al,0
		push	ax			; PARAMETER_1
		call	sub_1A7B
		rcr	al,1			; Rotate thru carry
loc_1A58:
		jnc	loc_1A64		; Jump if carry=0

;===== Indexed Entry Point ================================================

loc_1A5A:
		mov	al,1
		jmp	short loc_1A60

;===== Indexed Entry Point ================================================

loc_1A5E:
		mov	al,0
loc_1A60:
		push	ax			; PARAMETER_1
		call	sub_1A7B
loc_1A64:
		mov	al,byte ptr ds:[0CBFh]
		rcr	al,1			; Rotate thru carry
		jc	loc_1A6E		; Jump if carry Set
		call	sub_0D80
loc_1A6E:
		mov	al,byte ptr ds:[0CBEh]
		mov	byte ptr ds:[354h],al
		mov	al,byte ptr ds:[0CBFh]
		not	al
		pop	bp
		retn
sub_198A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1A7B	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	al,[bp+PARAMETER_1]
		shl	al,1			; Shift w/zeros fill
		mov	byte ptr ds:[354h],al
		call	sub_227A
		rcr	al,1			; Rotate thru carry
		jnc	loc_1A94		; Jump if carry=0
		mov	al,0FFh
		mov	byte ptr ds:[0CBFh],al
		jmp	short loc_1AAC
loc_1A94:
		mov	al,byte ptr ds:[0C77h]
		mov	byte ptr ds:[352h],al
		mov	ah,0
		mov	word ptr ds:[1CAh],ax
		mov	al,byte ptr ds:[0C78h]
		mov	byte ptr ds:[353h],al
		mov	ah,0
		mov	word ptr ds:[1CCh],ax
		mov	al,0
loc_1AAC:
		pop	bp
		retn	2
sub_1A7B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1AB0	proc	near
		push	bp
		mov	bp,sp
		mov	word ptr ds:[34Ah],350h
		mov	al,byte ptr ds:[0C74h]
		inc	al
		mov	byte ptr ds:[0C74h],al
		cmp	al,7
		jbe	loc_1ACE		; Jump if below or =
		mov	byte ptr ds:[0C74h],0
		not	byte ptr ds:[0C75h]
loc_1ACE:
		mov	al,byte ptr ds:[0C75h]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1ADD		; Jump if carry=0
		mov	word ptr ds:[34Ch],10E2h
		jmp	short loc_1AE3
loc_1ADD:
		mov	word ptr ds:[34Ch],10ECh
loc_1AE3:
		mov	al,byte ptr ds:[0C73h]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1B13		; Jump if carry=0
		call	sub_18E0
		mov	byte ptr ds:[0CC0h],al
		mov	al,byte ptr ds:[0B66h]
		cmp	al,byte ptr ds:[2A9h]
		jb	loc_1B07		; Jump if below
		call	sub_0231
		mov	ax,12A3h
		push	ax
		call	sub_015F		; Print DOS text
		mov	al,0FFh
		pop	bp
		retn
loc_1B07:
		mov	al,byte ptr ds:[0C72h]
		rcr	al,1			; Rotate thru carry
		jc	loc_1B11		; Jump if carry Set
		jmp	loc_1C03
loc_1B11:
		jmp	short loc_1B39
loc_1B13:
		mov	al,byte ptr ds:[355h]
		dec	al
		mov	byte ptr ds:[355h],al
		jnz	loc_1B32		; Jump if not zero
		call	sub_18E0
		mov	byte ptr ds:[0CC0h],al
		mov	byte ptr ds:[355h],2
		call	sub_0EB9
		rcr	al,1			; Rotate thru carry
		jnc	loc_1B3C		; Jump if carry=0
loc_1B2F:
		jmp	loc_1BEE
loc_1B32:
		call	sub_0EB9
		rcr	al,1			; Rotate thru carry
		jc	loc_1B2F		; Jump if carry Set
loc_1B39:
		jmp	loc_1C24
loc_1B3C:
		call	sub_0E2A
		mov	al,byte ptr ds:[0CC0h]
		mov	cl,0Fh
		and	al,cl
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_1B8C		; Jump if zero
		mov	ah,0
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,byte ptr ds:[0CAEh][bx]
		mov	byte ptr ds:[354h],al
		call	sub_198A
		rcr	al,1			; Rotate thru carry
		jnc	loc_1B85		; Jump if carry=0
		mov	al,byte ptr ds:[0DE7h]
		rcr	al,1			; Rotate thru carry
		jnc	loc_1B8F		; Jump if carry=0
		cmp	byte ptr ds:[355h],1
		jne	loc_1B7E		; Jump if not equal
		call	sub_0E2A
		call	sub_198A
		rcr	al,1			; Rotate thru carry
		jc	loc_1B7E		; Jump if carry Set
		mov	al,byte ptr ds:[2A6h]
		rcr	al,1			; Rotate thru carry
		jc	loc_1BEE		; Jump if carry Set
		call	sub_0D80
loc_1B7E:
		mov	byte ptr ds:[355h],1
		jmp	short loc_1B8F
loc_1B85:
		mov	al,byte ptr ds:[2A6h]
		rcr	al,1			; Rotate thru carry
		jc	loc_1BEE		; Jump if carry Set
loc_1B8C:
		call	sub_0D80
loc_1B8F:
		mov	al,byte ptr ds:[0CC0h]
		test	al,0F0h
		jz	loc_1BE7		; Jump if zero
		mov	al,byte ptr ds:[0DE7h]
		rcr	al,1			; Rotate thru carry
		jc	loc_1BE7		; Jump if carry Set
		mov	al,byte ptr ds:[351h]
		dec	al
		mov	byte ptr ds:[351h],al
		jnz	loc_1C24		; Jump if not zero
		mov	al,byte ptr ds:[354h]
		mov	byte ptr ds:[0CC1h],al
		mov	bl,byte ptr ds:[0CC0h]
		mov	cl,4
		shr	bl,cl			; Shift w/zeros fill
		mov	bh,0
		mov	al,byte ptr ds:[0CAEh][bx]
		mov	byte ptr ds:[354h],al
		mov	al,0
		push	ax			; PARAMETER_1
		call	sub_1613
		mov	al,0
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_25E2
		mov	al,byte ptr ds:[0CC1h]
		mov	byte ptr ds:[354h],al
		cmp	byte ptr ds:[355h],1
		jne	loc_1BDF		; Jump if not equal
		mov	al,byte ptr ds:[2AAh]
		shl	al,1			; Shift w/zeros fill
		jmp	short loc_1BE2
loc_1BDF:
		mov	al,byte ptr ds:[2AAh]
loc_1BE2:
		mov	byte ptr ds:[351h],al
		jmp	short loc_1C24
loc_1BE7:
		mov	byte ptr ds:[351h],1
		jmp	short loc_1C24
loc_1BEE:
		mov	al,0
		push	ax			; PARAMETER_2
		mov	ax,350h
		push	ax			; PARAMETER_1
		call	sub_1E8F
		mov	byte ptr ds:[0C73h],0FFh
		inc	byte ptr ds:[0B66h]
		jmp	short loc_1C24
loc_1C03:
		call	sub_18E0
		mov	byte ptr ds:[0CC0h],al
		mov	byte ptr ds:[0C73h],0
		call	sub_0F77
		mov	al,byte ptr ds:[352h]
		mov	ah,0
		mov	word ptr ds:[1CAh],ax
		mov	al,byte ptr ds:[353h]
		mov	ah,0
		mov	word ptr ds:[1CCh],ax
		call	sub_0D80
loc_1C24:
		mov	al,0
		pop	bp
		retn
sub_1AB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1C28	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
;*		cmp	byte ptr [bp+PARAMETER_1],0
		db	 82h, 7Eh, 04h, 00h	;  Fixup - byte match
		jnz	loc_1C51		; Jump if not zero
		mov	byte ptr [bp+PARAMETER_1],0FEh
		mov	al,byte ptr ds:[352h]
		mov	byte ptr ds:[0B42h],al
		mov	al,byte ptr ds:[353h]
		mov	byte ptr ds:[0B43h],al
		mov	byte ptr ds:[0B44h],16h
		mov	word ptr ds:[0B46h],12C2h
		mov	byte ptr ds:[0C72h],1
loc_1C51:
		mov	bl,[bp+PARAMETER_1]
		mov	bh,0
		mov	cl,3
		shl	bx,cl			; Shift w/zeros fill
		lea	ax,cs:[350h][bx]	; Load effective addr
		mov	word ptr ds:[34Ah],ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cl,byte ptr ds:[0C6Fh]
		mov	[bx],cl
		mov	al,[bp+PARAMETER_1]
		mov	byte ptr ds:[0C6Fh],al
		mov	ax,[bx+6]
		mov	word ptr ds:[0CC4h],ax
		xchg	bx,ax
		mov	cl,[bx]
		mov	byte ptr ds:[0CC8h],cl
		mov	dl,[bx+1]
		mov	byte ptr ds:[0CC9h],dl
		mov	word ptr ds:[0CC2h],ax
		mov	bl,2
		cmp	cl,bl
		jne	loc_1CAB		; Jump if not equal
		cmp	dl,bl
		jne	loc_1CAB		; Jump if not equal
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	cx,12C2h
		mov	[bx+6],cx
		mov	word ptr ds:[34Ch],cx
		mov	byte ptr [bx+4],16h
		mov	cl,0
		mov	[bx+5],cl
		mov	al,4
		push	ax
		push	cx
		jmp	short loc_1CFA
loc_1CAB:
		cmp	byte ptr ds:[0CC8h],1
		jne	loc_1CD4		; Jump if not equal
		cmp	byte ptr ds:[0CC9h],2
		jne	loc_1CD4		; Jump if not equal
		mov	ax,1316h
		mov	bx,word ptr ds:[0CC2h]
		mov	[bx+6],ax
		mov	word ptr ds:[34Ch],ax
		mov	byte ptr [bx+4],0Ch
		mov	al,0
		mov	[bx+5],al
		mov	cl,3
		push	cx
		jmp	short loc_1CF9
loc_1CD4:
		mov	al,1
		cmp	byte ptr ds:[0CC8h],al
		jne	loc_1CFD		; Jump if not equal
		cmp	byte ptr ds:[0CC9h],al
		jne	loc_1CFD		; Jump if not equal
		mov	ax,136Ah
		mov	bx,word ptr ds:[0CC2h]
		mov	[bx+6],ax
		mov	word ptr ds:[34Ch],ax
		mov	byte ptr [bx+4],0Bh
		mov	al,2
		mov	[bx+5],al
		push	ax			; PARAMETER_2
loc_1CF9:
		push	ax			; PARAMETER_1
loc_1CFA:
		call	sub_25E2
loc_1CFD:
		call	sub_0D80
		pop	bp
		retn	2
sub_1C28	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D04	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	bx,[bp+PARAMETER_1]
		mov	al,[bx]
		mov	byte ptr ds:[0CCAh],al
		mov	cl,[bp+PARAMETER_2]
		cmp	cl,al
		jne	loc_1D27		; Jump if not equal
;*		mov	ax,cx
		db	 89h,0C8h		;  Fixup - byte match
		mov	dl,8
		mul	dl			; ax = reg * al
		xchg	bx,ax
		mov	cl,byte ptr ds:[350h][bx]
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	[bx],cl
		jmp	short loc_1D60
loc_1D27:
		mov	al,byte ptr ds:[0CCAh]
		mov	cl,8
		mul	cl			; ax = reg * al
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,byte ptr ds:[350h][bx]
		mov	byte ptr ds:[0CCBh],al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_1D60		; Jump if zero
		cmp	[bp+PARAMETER_2],al
		je	loc_1D48		; Jump if equal
		mov	al,byte ptr ds:[0CCBh]
		mov	byte ptr ds:[0CCAh],al
		jmp	short loc_1D27
loc_1D48:
		mov	al,[bp+PARAMETER_2]
		mov	cl,8
		mul	cl			; ax = reg * al
		push	ax
		mov	al,byte ptr ds:[0CCAh]
		mul	cl			; ax = reg * al
		pop	bx
		mov	cl,byte ptr ds:[350h][bx]
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	byte ptr ds:[350h][bx],cl
loc_1D60:
		pop	bp
		retn	4
sub_1D04	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1D64	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[0C6Fh]
loc_1D6A:
		mov	byte ptr ds:[0CCCh],al
		mov	al,byte ptr ds:[0CCCh]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_1D77		; Jump if not zero
		jmp	loc_1E8D
loc_1D77:
		mov	ah,0
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		lea	ax,cs:[350h][bx]	; Load effective addr
		mov	word ptr ds:[0CC6h],ax
		mov	word ptr ds:[34Ah],ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	ax,[bx+6]
		mov	word ptr ds:[34Ch],ax
		call	sub_0E2A
		mov	bx,word ptr ds:[0CC6h]
		mov	al,[bx+5]
		inc	al
		mov	ah,0
		mov	cx,6
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
		div	cx			; ax,dx rem=dx:ax/reg
		mov	byte ptr ds:[0CCEh],dl
		mov	al,[bx]
		mov	byte ptr ds:[0CCDh],al
		cmp	byte ptr ds:[0CCCh],0FEh
		jne	loc_1DBD		; Jump if not equal
		mov	byte ptr ds:[0CCFh],0Bh
		jmp	short loc_1DC2
loc_1DBD:
		mov	byte ptr ds:[0CCFh],5
loc_1DC2:
		mov	bx,word ptr ds:[0CC6h]
		mov	al,[bx+5]
		inc	al
		mov	[bx+5],al
		cmp	al,byte ptr ds:[0CCFh]
		jbe	loc_1DF4		; Jump if below or =
		push	word ptr ds:[0CCCh]	; PARAMETER_2
		mov	ax,0C6Fh
		push	ax			; PARAMETER_1
		call	sub_1D04
		mov	al,byte ptr ds:[0CCCh]
		cmp	al,0FEh
		je	loc_1DEC		; Jump if equal
		push	ax			; PARAMETER_1
		call	sub_0CCF
		jmp	short loc_1DF1
loc_1DEC:
		mov	byte ptr ds:[0C72h],0
loc_1DF1:
		jmp	loc_1E87
loc_1DF4:
		mov	bx,word ptr ds:[0CC6h]
		cmp	byte ptr [bx+4],16h
		jne	loc_1E36		; Jump if not equal
		mov	bl,byte ptr ds:[0CCEh]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[12FEh][bx]
		mov	bx,word ptr ds:[0CC6h]
		mov	[bx+6],ax
		mov	word ptr ds:[34Ch],ax
		cmp	byte ptr ds:[0CCCh],0FEh
		jne	loc_1E32		; Jump if not equal
		mov	bx,word ptr ds:[0CC6h]
		mov	al,[bx+5]
		mov	cl,5
		cmp	al,cl
		jbe	loc_1E32		; Jump if below or =
		mov	dl,4
		push	dx
		sub	al,6
		sub	cl,al
		push	cx
		jmp	short loc_1E81
loc_1E32:
		mov	al,4
		jmp	short loc_1E7C
loc_1E36:
		mov	bx,word ptr ds:[0CC6h]
		cmp	byte ptr [bx+4],0Ch
		jne	loc_1E5A		; Jump if not equal
		mov	bl,byte ptr ds:[0CCEh]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[1352h][bx]
		mov	bx,word ptr ds:[0CC6h]
		mov	[bx+6],ax
		mov	word ptr ds:[34Ch],ax
		mov	al,3
		jmp	short loc_1E7C
loc_1E5A:
		mov	bx,word ptr ds:[0CC6h]
		cmp	byte ptr [bx+4],0Bh
		jne	loc_1E84		; Jump if not equal
		mov	bl,byte ptr ds:[0CCEh]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[1392h][bx]
		mov	bx,word ptr ds:[0CC6h]
		mov	[bx+6],ax
		mov	word ptr ds:[34Ch],ax
		mov	al,2
loc_1E7C:
		push	ax			; PARAMETER_2
		push	word ptr ds:[0CCEh]	; PARAMETER_1
loc_1E81:
		call	sub_25E2
loc_1E84:
		call	sub_0D80
loc_1E87:
		mov	al,byte ptr ds:[0CCDh]
		jmp	loc_1D6A
loc_1E8D:
		pop	bp
		retn
sub_1D64	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1E8F	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
;*		cmp	byte ptr [bp+PARAMETER_2],0
		db	 82h, 7Eh, 06h, 00h	;  Fixup - byte match
		jnz	loc_1E9D		; Jump if not zero
		mov	al,0
		push	ax
		jmp	short loc_1EB0
loc_1E9D:
		push	word ptr [bp+PARAMETER_2]	; PARAMETER_2
		push	word ptr [bp+PARAMETER_1]	; PARAMETER_1
		call	sub_1D04
		cmp	word ptr [bp+PARAMETER_1],0C6Dh
		je	loc_1EB5		; Jump if equal
		push	word ptr [bp+PARAMETER_2]	; PARAMETER_1
loc_1EB0:
		call	sub_1C28
		jmp	short loc_1EBB
loc_1EB5:
		push	word ptr [bp+PARAMETER_2]	; PARAMETER_1
		call	sub_0CCF
loc_1EBB:
		pop	bp
		retn	4
sub_1E8F	endp

		db	0

loc_ret_1EC0:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_1EC1	proc	near
		mov	dl,byte ptr ds:[0C6Eh]
loc_1EC5:
		or	dl,dl			; Zero ?
		jz	loc_ret_1EC0		; Jump if zero
		xor	bx,bx			; Zero register
		mov	bl,dl
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		lea	di,ds:[350h][bx]	; Load effective addr
		xor	bx,bx			; Zero register
		mov	bh,[di+3]
		lea	si,ds:[15D0h][bx]	; Load effective addr
		xor	bx,bx			; Zero register
		mov	bl,[di+2]
		shl	bx,1			; Shift w/zeros fill
		mov	al,0B2h
		cmp	al,[bx+si]
		je	loc_1F15		; Jump if equal
		cmp	bx,data_00FE_e
		jae	loc_1F06		; Jump if above or =
		add	bx,2
		cmp	al,[bx+si]
		je	loc_1F27		; Jump if equal
		dec	byte ptr [di+5]
		jz	loc_1F03		; Jump if zero
		mov	dl,[di]
		jmp	short loc_1EC5
loc_1F03:
		jmp	short loc_1F84
		db	90h
loc_1F06:
		xor	bx,bx			; Zero register
		cmp	al,[bx+si]
		je	loc_1F27		; Jump if equal
		dec	byte ptr [di+5]
		jz	loc_1F8F		; Jump if zero
		mov	dl,[di]
		jmp	short loc_1EC5
loc_1F15:
		mov	word ptr [bx+si],920h
		add	bl,2
		cmp	bx,100h
		jb	loc_1F33		; Jump if below
		xor	bx,bx			; Zero register
		jmp	short loc_1F33
		db	90h
loc_1F27:
		mov	word ptr [bx+si],920h
		sub	bx,2
		jnc	loc_1F33		; Jump if carry=0
		mov	bx,data_00FE_e
loc_1F33:
		test	byte ptr ds:[2A7h],1
		jz	loc_1FB9		; Jump if zero
		cmp	byte ptr [bx+si],1
		jne	loc_1FB9		; Jump if not equal
		mov	word ptr [bx+si],502h
		shr	bx,1			; Shift w/zeros fill
		mov	[di+2],bl
;*		lea	bx,ds:[0C6Eh]		; Load effective addr
		db	 8Dh, 1Eh, 6Eh, 0Ch	;  Fixup - byte match
loc_1F4C:
		mov	si,bx
		xor	bx,bx			; Zero register
		mov	bl,[si]
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		lea	bx,ds:[350h][bx]	; Load effective addr
		cmp	bx,di
		jne	loc_1F4C		; Jump if not equal
		mov	al,[di]
		mov	[si],al
		xchg	byte ptr ds:[0C71h],dl
		mov	[di],dl
		mov	dl,al
		mov	byte ptr [di+5],2
		mov	word ptr [di+6],10FEh
		dec	byte ptr ds:[0B64h]
		inc	word ptr ds:[346h]
		inc	byte ptr ds:[0B68h]
		jmp	loc_1EC5
loc_1F84:
		mov	ax,920h
		mov	[bx+si],ax
		sub	bx,2
		jmp	short loc_1F97
		db	90h
loc_1F8F:
		mov	ax,920h
		mov	[bx+si],ax
		mov	bx,data_00FE_e
loc_1F97:
		mov	[bx+si],ax
		mov	ax,3
		push	ax
		call	sub_01FA
		or	ax,ax			; Zero ?
		jz	loc_1FCF		; Jump if zero
		call	sub_227E
		jnz	loc_1FCF		; Jump if not zero
		mov	[di+2],cx
		test	byte ptr [di+4],1
		jz	loc_2021		; Jump if zero
		mov	byte ptr [di+5],8
		jmp	short loc_2025
		db	90h
loc_1FB9:
		push	word ptr [di]
		push	dx			; PARAMETER_2
		mov	ax,0C6Eh
		push	ax			; PARAMETER_1
		call	sub_1E8F
		pop	dx
		dec	byte ptr ds:[0B64h]
		inc	word ptr ds:[346h]
		jmp	loc_1EC5
loc_1FCF:
		mov	ax,3
		push	ax
		call	sub_01FA
		or	ax,ax			; Zero ?
		jz	loc_1FE0		; Jump if zero
		call	sub_2381
		jmp	short loc_1FE7
		db	90h
loc_1FE0:
		mov	ax,7
		push	ax
		call	sub_01FA
loc_1FE7:
		mov	[di+4],al
		mov	cx,8

locloop_1FED:
		push	cx
		call	sub_227E
		pop	cx
		jz	loc_2013		; Jump if zero
		mov	al,[di+4]
		test	byte ptr [di+1],1
		jz	loc_2006		; Jump if zero
		sub	al,1
		jnc	loc_200E		; Jump if carry=0
		mov	al,7
		jmp	short loc_200E
		db	90h
loc_2006:
		inc	al
		cmp	al,8
		jb	loc_200E		; Jump if below
		xor	al,al			; Zero register
loc_200E:
		mov	[di+4],al
		loop	locloop_1FED		; Loop if cx > 0

loc_2013:
		mov	bl,[di+4]
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[1130h][bx]
		mov	[di+6],ax
loc_2021:
		mov	byte ptr [di+5],6
loc_2025:
		xor	bx,bx			; Zero register
		mov	bh,[di+3]
		lea	si,ds:[15D0h][bx]	; Load effective addr
		mov	bx,[di+6]
		mov	ax,[bx+2]
		push	word ptr [bx+4]
		xor	bx,bx			; Zero register
		mov	bl,[di+2]
		shl	bx,1			; Shift w/zeros fill
		mov	[bx+si],ax
		add	bx,2
		cmp	bx,100h
		jb	loc_204B		; Jump if below
		xor	bx,bx			; Zero register
loc_204B:
		pop	word ptr [bx+si]
		call	sub_2381
		mov	ah,[di+4]
		cmp	al,ah
		jne	loc_209E		; Jump if not equal
		or	ch,ch			; Zero ?
		jz	loc_2083		; Jump if zero
		or	cl,cl			; Zero ?
		jz	loc_2083		; Jump if zero
		xor	ax,ax			; Zero register
		mov	al,cl
		shl	ax,1			; Shift w/zeros fill
		mov	si,ax
		shl	ax,1			; Shift w/zeros fill
		add	si,ax
		xor	ax,ax			; Zero register
		mov	al,ch
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		sub	si,ax
		jge	loc_207B		; Jump if > or =
		neg	si
loc_207B:
		cmp	si,8
		jge	loc_20F4		; Jump if > or =
		mov	al,[di+4]
loc_2083:
		push	word ptr [di+4]
		mov	[di+4],al
		mov	word ptr ds:[34Ah],di
		mov	ax,[di+6]
		mov	word ptr ds:[34Ch],ax
		push	di
		call	sub_18A3
		pop	di
		pop	word ptr [di+4]
		jmp	short loc_20F9
		db	90h
loc_209E:
		cmp	ch,2
		ja	loc_20C3		; Jump if above
		or	al,al			; Zero ?
		jz	loc_20C3		; Jump if zero
		cmp	al,4
		je	loc_20C3		; Jump if equal
		ja	loc_20BA		; Jump if above
		or	ah,ah			; Zero ?
		jz	loc_20C3		; Jump if zero
		cmp	ah,3
		ja	loc_20C3		; Jump if above
		mov	al,2
		jmp	short loc_2083
loc_20BA:
		cmp	ah,5
		jb	loc_20C3		; Jump if below
		mov	al,6
		jmp	short loc_2083
loc_20C3:
		cmp	cl,2
		ja	loc_20F4		; Jump if above
		add	al,1
		and	al,7
		cmp	al,7
		je	loc_20F4		; Jump if equal
		cmp	al,3
		je	loc_20F4		; Jump if equal
		ja	loc_20E5		; Jump if above
		add	ah,1
		and	ah,7
		cmp	ah,2
		ja	loc_20F4		; Jump if above
		mov	al,0
		jmp	short loc_2083
loc_20E5:
		add	ah,2
		and	ah,7
		cmp	ah,5
		jb	loc_20F4		; Jump if below
		mov	al,4
		jmp	short loc_2083
loc_20F4:
		mov	dl,[di]
		jmp	loc_1EC5
loc_20F9:
		shr	al,1			; Shift w/zeros fill
		jnc	loc_20F4		; Jump if carry=0
		xor	bx,bx			; Zero register
		mov	bh,[di+3]
		lea	si,ds:[15D0h][bx]	; Load effective addr
		xor	bx,bx			; Zero register
		mov	bl,[di+2]
		shl	bx,1			; Shift w/zeros fill
		cmp	byte ptr [bx+si],1
		jne	loc_211D		; Jump if not equal
		add	bx,2
		cmp	bx,100h
		jb	loc_211D		; Jump if below
		xor	bx,bx			; Zero register
loc_211D:
		mov	word ptr [bx+si],9FFh
		jmp	short loc_20F4
sub_1EC1	endp


loc_ret_2123:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2124	proc	near
		mov	dl,byte ptr ds:[0C71h]
loc_2128:
		or	dl,dl			; Zero ?
		jz	loc_ret_2123		; Jump if zero
		xor	bx,bx			; Zero register
		mov	bl,dl
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		lea	di,ds:[350h][bx]	; Load effective addr
		xor	bx,bx			; Zero register
		mov	bh,[di+3]
		lea	si,ds:[15D0h][bx]	; Load effective addr
		xor	bx,bx			; Zero register
		mov	bl,[di+2]
		shl	bx,1			; Shift w/zeros fill
		cmp	byte ptr [bx+si],0B2h
		je	loc_2158		; Jump if equal
		dec	byte ptr [di+5]
		jz	loc_216D		; Jump if zero
		mov	dl,[di]
		jmp	short loc_2128
loc_2158:
		push	word ptr [di]
		push	dx			; PARAMETER_2
		mov	ax,0C71h
		push	ax			; PARAMETER_1
		call	sub_1E8F
		pop	dx
		dec	byte ptr ds:[0B68h]
		inc	word ptr ds:[348h]
		jmp	short loc_2128
loc_216D:
		mov	word ptr [bx+si],920h
		mov	byte ptr ds:[0CD0h],dl
		test	byte ptr [di+1],2
		jnz	loc_21D5		; Jump if not zero
		call	sub_2381
		cmp	byte ptr ds:[0B69h],4
		ja	loc_21C5		; Jump if above
		mov	[di+4],al
		push	cx
		call	sub_227E
		pop	cx
		mov	al,[di+4]
		jz	loc_21C5		; Jump if zero
		test	al,1
		jz	loc_21C5		; Jump if zero
		cmp	ah,byte ptr ds:[11E4h]
		je	loc_21AE		; Jump if equal
		cmp	ah,byte ptr ds:[11E5h]
		je	loc_21AE		; Jump if equal
		cmp	ah,byte ptr ds:[11E6h]
		je	loc_21AE		; Jump if equal
		cmp	ah,byte ptr ds:[11E7h]
		jne	loc_21C5		; Jump if not equal
loc_21AE:
		push	word ptr ds:[1D4h]
		call	sub_01FA
		or	ax,ax			; Zero ?
		mov	al,[di+4]
		jnz	loc_21C5		; Jump if not zero
		mov	dl,byte ptr ds:[0CD0h]
		mov	byte ptr [bx+si],0B2h
		jmp	short loc_2158
loc_21C5:
		cmp	ch,1
		jne	loc_21D8		; Jump if not equal
		cmp	al,4
		mov	al,2
		jc	loc_220B		; Jump if carry Set
		mov	al,6
		jmp	short loc_220B
		nop
loc_21D5:
		jmp	short loc_2228
		db	90h
loc_21D8:
		jnc	loc_21EC		; Jump if carry=0
		inc	al
		mov	[di+4],al
		call	sub_227E
		mov	al,[di+4]
		jz	loc_225A		; Jump if zero
		sub	al,2
		jmp	short loc_220B
		db	90h
loc_21EC:
		cmp	cl,1
		jne	loc_21F8		; Jump if not equal
		inc	al
		and	al,4
		jmp	short loc_220B
		db	90h
loc_21F8:
		jnc	loc_220B		; Jump if carry=0
		add	al,2
		mov	[di+4],al
		call	sub_227E
		mov	al,[di+4]
		jz	loc_225A		; Jump if zero
		sub	al,4
		and	al,7
loc_220B:
		mov	[di+4],al
		call	sub_227E
		jz	loc_225A		; Jump if zero
		cmp	byte ptr ds:[0B69h],14h
		jb	loc_221E		; Jump if below
		or	byte ptr [di+1],2
loc_221E:
		mov	ax,7
		push	ax
		call	sub_01FA
		mov	[di+4],al
loc_2228:
		mov	cx,8

locloop_222B:
		push	cx
		call	sub_227E
		pop	dx
		jz	loc_225A		; Jump if zero
		and	byte ptr [di+1],0FDh
		mov	cx,dx
		mov	al,[di+4]
		test	byte ptr [di+1],1
		jz	loc_224A		; Jump if zero
		sub	al,1
		jnc	loc_2252		; Jump if carry=0
		mov	al,7
		jmp	short loc_2252
		db	90h
loc_224A:
		inc	al
		cmp	al,8
		jb	loc_2252		; Jump if below
		xor	al,al			; Zero register
loc_2252:
		mov	[di+4],al
		loop	locloop_222B		; Loop if cx > 0

		jmp	short loc_225D
		db	90h
loc_225A:
		mov	[di+2],cx
loc_225D:
		xor	bx,bx			; Zero register
		mov	bh,[di+3]
		lea	si,ds:[15D0h][bx]	; Load effective addr
		xor	bx,bx			; Zero register
		mov	bl,[di+2]
		shl	bx,1			; Shift w/zeros fill
		mov	word ptr [bx+si],502h
		mov	byte ptr [di+5],3
		mov	dl,[di]
		jmp	loc_2128
sub_2124	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_227A	proc	near
		mov	di,word ptr ds:[34Ah]

;==== External Entry into Subroutine ======================================

sub_227E:
		mov	cx,[di+2]
		mov	ax,cx
		xor	dx,dx			; Zero register
		xor	bx,bx			; Zero register
		mov	bl,[di+4]
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr ds:[0CD5h][bx]	;*
sub_227A	endp

			                        ;* No entry point to code
		mov	bl,ch
		mov	dl,byte ptr ds:[0CE5h][bx]
		add	cl,dl
		cmp	cl,7Fh
		jbe	loc_22A0		; Jump if below or =
		sub	cl,80h
loc_22A0:
		inc	dh
		sub	ch,1
		jnc	loc_22A9		; Jump if carry=0
		mov	ch,77h			; 'w'
loc_22A9:
		jmp	short loc_2329
			                        ;* No entry point to code
		nop
		inc	cl
		inc	dl
		cmp	cl,7Fh
		jbe	loc_232B		; Jump if below or =
		xor	cl,cl			; Zero register
		jmp	short loc_232B
			                        ;* No entry point to code
		nop
		inc	ch
		inc	dh
		cmp	ch,77h			; 'w'
		jbe	loc_22C5		; Jump if below or =
		xor	ch,ch			; Zero register
loc_22C5:
		mov	bl,ch
		mov	dl,byte ptr ds:[0CE5h][bx]
		add	cl,dl
		cmp	cl,7Fh
		jbe	loc_232B		; Jump if below or =
		sub	cl,80h
		jmp	short loc_232B
			                        ;* No entry point to code
		nop
		inc	ch
		inc	dh
		cmp	ch,77h			; 'w'
		jbe	loc_232B		; Jump if below or =
		xor	ch,ch			; Zero register
		jmp	short loc_232B
			                        ;* No entry point to code
		nop
		inc	ch
		inc	dh
		cmp	ch,77h			; 'w'
		jbe	loc_22F1		; Jump if below or =
		xor	ch,ch			; Zero register
loc_22F1:
		mov	bl,ch
		mov	dl,byte ptr ds:[0CE5h][bx]
		sub	cl,dl
		jnc	loc_22FE		; Jump if carry=0
		add	cl,80h
loc_22FE:
		mov	al,cl
		jmp	short loc_232B
			                        ;* No entry point to code
		nop
		inc	dl
		sub	cl,1
		jnc	loc_230C		; Jump if carry=0
		mov	cl,7Fh
loc_230C:
		mov	al,cl
		jmp	short loc_232B
			                        ;* No entry point to code
		nop
		mov	bl,ch
		mov	dl,byte ptr ds:[0CE5h][bx]
		sub	cl,dl
		jnc	loc_231E		; Jump if carry=0
		add	cl,80h
loc_231E:
		inc	dh
		sub	ch,1
		jnc	loc_2327		; Jump if carry=0
		mov	ch,77h			; 'w'
loc_2327:
		mov	al,cl
loc_2329:
		mov	ah,ch
loc_232B:
		mov	si,[di+6]
		add	dl,[si+1]
		add	dh,[si]
		xor	bx,bx			; Zero register
		mov	bh,ah
		lea	si,ds:[15D0h][bx]	; Load effective addr
loc_233B:
		xor	bx,bx			; Zero register
		mov	bl,al
		shl	bx,1			; Shift w/zeros fill
		mov	ah,dl
loc_2343:
		cmp	byte ptr [bx+si],20h	; ' '
		jne	loc_2378		; Jump if not equal
		dec	ah
		jle	loc_2359		; Jump if < or =
		add	bx,2
		cmp	bx,100h
		jb	loc_2343		; Jump if below
		xor	bx,bx			; Zero register
		jmp	short loc_2343
loc_2359:
		dec	dh
		jle	loc_236D		; Jump if < or =
		add	si,100h
		cmp	si,data_8DD0_e
		jb	loc_233B		; Jump if below
		sub	si,7800h
		jmp	short loc_233B
loc_236D:
		xor	ax,ax			; Zero register
		mov	byte ptr ds:[0C77h],cl
		mov	byte ptr ds:[0C78h],ch
		retn
loc_2378:
		mov	ah,[bx+si]
		or	al,0FFh
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_237D	proc	near
		mov	di,word ptr ds:[34Ah]

;==== External Entry into Subroutine ======================================

sub_2381:
		mov	bx,data_0001_e
		xor	ax,ax			; Zero register
		mov	al,[di+2]
		sub	ax,word ptr ds:[1CAh]
		jg	loc_2393		; Jump if >
		xor	bl,bl			; Zero register
		neg	ax
loc_2393:
		cmp	ax,3Fh
		jbe	loc_23A0		; Jump if below or =
		xor	bl,1
		neg	ax
		add	ax,80h
loc_23A0:
		mov	cl,al
		mov	al,[di+3]
		sub	ax,word ptr ds:[1CCh]
		jge	loc_23B0		; Jump if > or =
		or	bl,2
		neg	ax
loc_23B0:
		cmp	ax,3Bh
		jbe	loc_23BD		; Jump if below or =
		xor	bl,2
		neg	ax
		add	ax,78h
loc_23BD:
		mov	ch,al
		add	al,cl
		mov	byte ptr ds:[0B69h],al
		or	cl,cl			; Zero ?
		jnz	loc_23CD		; Jump if not zero
		mov	al,bl
		shl	al,1			; Shift w/zeros fill
		retn
loc_23CD:
		or	ch,ch			; Zero ?
		jnz	loc_23DA		; Jump if not zero
		mov	al,bl
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	al,2
		retn
loc_23DA:
		mov	al,byte ptr ds:[0CD1h][bx]
		retn
sub_237D	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_23E0	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8

		push	bp
		mov	bp,sp
		mov	ax,0B800h
		mov	es,ax
		mov	si,[bp+PARAMETER_3]
		mov	di,[bp+PARAMETER_2]
		mov	cx,[bp+PARAMETER_1]
		cld				; Clear direction
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	bp
		retn	6
sub_23E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get system timer

sub_23F8	proc	near
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		mov	ds:d_3C5A_0D64_e,ax
		retn
sub_23F8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait time tick

sub_2402	proc	near
loc_2402:
		mov	ah,0
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	word ptr ds:[0D64h],dx
		je	loc_2402		; Jump if equal
		mov	word ptr ds:[0D64h],dx
		retn
sub_2402	endp

data_2411	dw	88Eh

INT09_handler:
		db	 50h, 53h, 1Eh, 2Eh,0A1h, 11h
		db	 24h, 8Eh,0D8h,0E4h, 60h, 50h
		db	0E4h, 61h, 8Ah,0E0h, 0Ch, 80h
		db	0E6h, 61h, 86h,0C4h,0E6h, 61h
		db	 58h, 3Ch,0FFh, 74h, 1Bh,0A8h
		db	 80h, 74h, 0Eh, 24h, 7Fh, 8Ah
		db	0D8h,0B7h, 00h, 80h,0A7h, 66h
		db	 0Dh,0FEh,0EBh, 0Ah, 90h, 8Ah
		db	0D8h,0B7h, 00h,0C6h, 87h, 66h
		db	 0Dh, 03h,0F6h, 06h, 83h, 0Dh
		db	 01h, 74h, 23h,0F6h, 06h, 9Eh
		db	 0Dh, 01h, 74h, 1Ch,0F6h, 06h
		db	0B9h, 0Dh, 01h, 74h, 15h,0B8h
		db	 40h, 00h, 8Eh,0C0h, 26h,0C7h
		db	 06h, 72h, 00h, 34h, 12h, 2Eh
		db	0FFh
		db	 2Eh, 71h, 24h
data_2471	dw	0, 0FFFFh
loc_2475:
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	ds
		pop	bx
		pop	ax
		iret				; Interrupt return

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_247D	proc	near
		xor	ax,ax			; Zero register
		mov	es,ax
		mov	ax,word ptr ds:[0D60h]
		cli				; Disable interrupts
		mov	es:d_0000_0024_e,ax
		mov	ax,word ptr ds:[0D62h]
		mov	es:d_0000_0026_e,ax
		sti				; Enable interrupts
		retn
sub_247D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2492	proc	near
		test	byte ptr ds:[0D83h],1
		jz	loc_24A5		; Jump if zero
		test	byte ptr ds:[0DACh],1
		jz	loc_24A5		; Jump if zero
		mov	byte ptr ds:[0DE6h],1
loc_24A5:
		xor	al,al			; Zero register
		mov	ah,0FDh
		test	byte ptr ds:[0DB3h],3
		jz	loc_24B6		; Jump if zero
		or	al,1
		and	byte ptr ds:[0DB3h],ah
loc_24B6:
		test	byte ptr ds:[0DB1h],3
		jz	loc_24C3		; Jump if zero
		or	al,2
		and	byte ptr ds:[0DB1h],ah
loc_24C3:
		test	byte ptr ds:[0DB6h],3
		jz	loc_24D0		; Jump if zero
		or	al,4
		and	byte ptr ds:[0DB6h],ah
loc_24D0:
		test	byte ptr ds:[0DB2h],3
		jz	loc_24DD		; Jump if zero
		or	al,4
		and	byte ptr ds:[0DB2h],ah
loc_24DD:
		test	byte ptr ds:[0DAEh],3
		jz	loc_24EA		; Jump if zero
		or	al,8
		and	byte ptr ds:[0DAEh],ah
loc_24EA:
		test	byte ptr ds:[0D84h],3
		jz	loc_24F7		; Jump if zero
		or	al,20h			; ' '
		and	byte ptr ds:[0D84h],ah
loc_24F7:
		test	byte ptr ds:[0D77h],3
		jz	loc_2504		; Jump if zero
		or	al,80h
		and	byte ptr ds:[0D77h],ah
loc_2504:
		test	byte ptr ds:[0D85h],3
		jz	loc_2511		; Jump if zero
		or	al,40h			; '@'
		and	byte ptr ds:[0D85h],ah
loc_2511:
		test	byte ptr ds:[0D93h],3
		jz	loc_251E		; Jump if zero
		or	al,40h			; '@'
		and	byte ptr ds:[0D93h],ah
loc_251E:
		test	byte ptr ds:[0D86h],3
		jz	loc_252B		; Jump if zero
		or	al,10h
		and	byte ptr ds:[0D86h],ah
loc_252B:
		test	byte ptr ds:[0DA1h],2
		jz	loc_253A		; Jump if zero
		not	byte ptr ds:[0DE8h]
		and	byte ptr ds:[0DA1h],ah
loc_253A:
		test	byte ptr ds:[0DA2h],2
		jz	loc_2549		; Jump if zero
		not	byte ptr ds:[0DE9h]
		and	byte ptr ds:[0DA2h],ah
loc_2549:
		test	byte ptr ds:[0D9Fh],3
		jz	loc_255A		; Jump if zero
		mov	byte ptr ds:[0DE7h],0FFh
		and	byte ptr ds:[0D9Fh],ah
		retn
loc_255A:
		mov	byte ptr ds:[0DE7h],0
		retn
sub_2492	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 09h service (cs:2413)

sub_2560	proc	near
		xor	ax,ax			; Zero register
		mov	es,ax
		mov	ax,es:d_0000_0024_e
		mov	word ptr ds:[0D60h],ax
		mov	ax,es:d_0000_0026_e
		mov	word ptr ds:[0D62h],ax
		cli				; Disable interrupts
		mov	word ptr es:d_0000_0024_e,2413h ; INT09_handler
		mov	es:d_0000_0026_e,cs
		sti				; Enable interrupts
;*		lea	di,ds:[0D66h]		; Load effective addr
		db	 8Dh, 3Eh, 66h, 0Dh	;  Fixup - byte match
		push	ds
		pop	es
		cld				; Clear direction
		mov	cx,40h
		xor	ax,ax			; Zero register
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn
sub_2560	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set cursor size, to be not visible

sub_258F	proc	near
		push	bp
		mov	ax,100h
		mov	cx,2607h
		int	10h			; Video display   ah=functn 01h
						;  set cursor mode in cx
		pop	bp
		retn
sub_258F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set cursor position (and set cursor visible)

sub_259A	proc	near
		push	bp

		; set cursor size
		mov	ax,100h
		mov	cx,607h
		int	10h			; Video display   ah=functn 01h
						;  set cursor mode in cx
		pop	bp

		; set cursor position
		push	bp
		mov	bp,sp
		mov	ax,200h
		mov	bh,0
		mov	dl,[bp+4]
		mov	dh,[bp+6]
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		pop	bp
		retn	4
sub_259A	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_25C0	proc	near
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		retn
sub_25C0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_25C5	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	bp
		retn	2
sub_25C5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_25DB	proc	near
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_25DB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_25E2	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[0DF0h]
		cmp	al,0FFh
		je	loc_25F1		; Jump if equal
		cmp	[bp+PARAMETER_2],al
		jb	loc_260A		; Jump if below
loc_25F1:
		mov	al,byte ptr ds:[0DE9h]
		rcr	al,1			; Rotate thru carry
		jc	loc_25FE		; Jump if carry Set
;*		cmp	byte ptr [bp+PARAMETER_2],0
		db	 82h, 7Eh, 06h, 00h	;  Fixup - byte match
		jz	loc_260A		; Jump if zero
loc_25FE:
		mov	al,[bp+PARAMETER_1]
		mov	byte ptr ds:[0DF1h],al
		mov	al,[bp+PARAMETER_2]
		mov	byte ptr ds:[0DF0h],al
loc_260A:
		pop	bp
		retn	4
sub_25E2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_260E	proc	near
		push	bp
		mov	bp,sp
		mov	al,byte ptr ds:[0DE8h]
		rcr	al,1			; Rotate thru carry
		jnc	loc_261F		; Jump if carry=0
		cmp	byte ptr ds:[0DF0h],0FFh
		jne	loc_2624		; Jump if not equal
loc_261F:
		call	sub_25DB
		pop	bp
		retn
loc_2624:
		mov	bl,byte ptr ds:[0DF0h]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_2631[bx]	;*5 entries
data_2631	dw	offset loc_263B		; Data table (indexed access)
data_2633	dw	offset loc_2652
data_2635	dw	offset loc_265A
data_2637	dw	offset loc_2668
data_2639	dw	offset loc_2676

;===== Indexed Entry Point ================================================

loc_263B:
;*		cmp	byte ptr ds:[0DF1h],0
		db	 82h, 3Eh,0F1h, 0Dh, 00h	;  Fixup - byte match
		jnz	loc_264A		; Jump if not zero
		mov	word ptr ds:[0DEEh],76Ch
		jmp	short loc_2685
loc_264A:
		mov	word ptr ds:[0DEEh],578h
		jmp	short loc_2685

;===== Indexed Entry Point ================================================

loc_2652:
		mov	word ptr ds:[0DEEh],640h
		jmp	short loc_2685

;===== Indexed Entry Point ================================================

loc_265A:
		mov	bl,byte ptr ds:[0DF1h]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[13AAh][bx]
		jmp	short loc_2682

;===== Indexed Entry Point ================================================

loc_2668:
		mov	bl,byte ptr ds:[0DF1h]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[13B6h][bx]
		jmp	short loc_2682

;===== Indexed Entry Point ================================================

loc_2676:
		mov	bl,byte ptr ds:[0DF1h]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[13C2h][bx]
loc_2682:
		mov	word ptr ds:[0DEEh],ax
loc_2685:
		push	word ptr ds:[0DEEh]	; PARAMETER_1
		call	sub_25C5
		mov	byte ptr ds:[0DF0h],0FFh
		pop	bp
		retn
sub_260E	endp

		db	483 dup (0)
		db	 21h, 00h,0D3h, 01h
		db	233 dup (0)
		db	 80h, 00h, 00h
		db	2520 dup (0)
		db	 01h, 02h, 00h, 04h, 05h, 06h
		db	 00h, 08h, 09h, 0Ah, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	 06h, 00h, 04h, 03h, 05h, 00h
		db	 00h, 01h, 07h
		db	24 dup (0)
		db	 01h, 07h, 03h, 05h,0A0h, 22h
		db	 90h, 22h,0ACh, 22h,0BAh, 22h
		db	0D8h, 22h,0E6h, 22h, 03h, 23h
		db	 11h, 23h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h, 02h, 01h, 01h
		db	 02h, 01h, 01h
		db	138 dup (0)
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh
		db	15 dup (0)
		db	 02h, 00h, 03h, 00h, 04h, 00h
		db	 03h, 00h, 04h, 00h, 04h, 00h
		db	 03h, 00h, 04h, 00h, 03h, 00h
		db	 04h, 00h, 04h, 00h, 05h, 00h
		db	 03h, 00h, 04h, 00h, 03h, 00h
		db	 04h, 00h, 03h, 00h, 04h, 00h
		db	 03h, 00h, 04h, 00h, 04h, 00h
		db	 05h, 00h, 04h, 00h, 04h, 00h
		db	 05h, 00h, 05h, 00h, 7Fh, 00h
		db	 7Fh, 00h, 7Fh, 00h, 3Fh, 00h
		db	 3Fh, 00h, 1Fh, 00h, 7Fh, 00h
		db	 7Fh, 00h, 3Fh, 00h, 3Fh, 00h
		db	 1Fh, 00h, 1Fh, 00h, 7Fh, 00h
		db	 7Fh, 00h, 3Fh, 00h, 3Fh, 00h
		db	 7Fh, 00h, 7Fh, 00h, 3Fh, 00h
		db	 3Fh, 00h, 1Fh, 00h, 1Fh, 00h
		db	 3Fh, 00h, 1Fh, 00h, 1Fh, 00h
		db	 0Fh, 00h
		db	 53h, 6Eh
		db	'ipes (C)Copyright SuperSet Softw'
		db	'are Corp. Orem, Utah 1982', 8
		db	 04h, 02h, 01h, 04h, 08h, 01h
		db	 02h, 20h,0BAh,0BAh,0BAh,0CDh
		db	0BCh,0BBh,0B9h,0CDh,0C8h,0C9h
		db	0CCh,0CDh,0CAh,0CBh,0CEh
		db	12 dup (0)
		db	14 dup (1)
		db	0, 0, 0, 1, 1, 1
		db	0, 0, 1, 1, 1, 1
		db	0, 0, 1, 1, 0, 0
		db	30 dup (1)
		db	10 dup (0)
		db	1, 1, 1, 1, 1, 1
		db	0, 0, 0, 0, 1
		db	9 dup (1)
		db	 0Ah, 14h, 1Eh, 28h, 3Ch, 50h
		db	 64h, 78h, 96h, 05h, 05h, 05h
		db	 05h, 05h, 04h, 04h, 03h, 02h
		db	 03h, 03h, 04h, 04h, 05h, 05h
		db	 06h, 08h, 0Ah, 20h, 07h,0DAh
		db	0BFh,0B3h, 01h, 1Ah,0B3h, 02h
		db	0B3h, 53h, 6Bh, 69h, 6Ch, 6Ch
		db	0C0h,0D9h,0B3h, 01h, 1Ah,0B3h
		db	 02h,0B3h
		db	54h
		db	'ime  Men Left                 Sc'
		db	'ore     0  0000001 Man Lefte', 0Ah
		db	0Dh, 0Dh, 'Congratulations --- YO'
		db	'U ACTUALLY WON!!!$'
		db	0Ah, 0Dh, 'Play another game? (Y '
		db	'or N) $'
		db	0Ah, 0Dh, 'Enter new skill level '
		db	'(A-Z)(1-9): $'
		db	0
		db	 02h, 02h,0DAh, 0Fh,0BFh, 0Eh
		db	0C0h, 0Dh,0D9h, 0Ch, 02h, 02h
		db	0FFh, 0Eh,0FFh, 0Eh,0FFh, 0Eh
		db	0FFh, 0Eh, 02h, 02h,0DAh, 0Eh
		db	0BFh, 0Eh,0C0h, 0Eh,0D9h, 0Eh
		db	 02h, 02h,0FFh, 0Eh,0FFh, 0Eh
		db	0FFh, 0Eh,0FFh, 0Eh, 02h, 02h
		db	0DAh, 0Dh,0BFh, 0Dh,0C0h, 0Dh
		db	0D9h, 0Dh, 02h, 02h,0FFh, 0Eh
		db	0FFh, 0Eh,0FFh, 0Eh,0FFh, 0Eh
		db	 02h, 02h,0DAh, 0Ch,0BFh, 0Ch
		db	0C0h, 0Ch,0D9h, 0Ch, 02h, 02h
		db	0FFh, 0Eh,0FFh, 0Eh,0FFh, 0Eh
		db	0FFh, 0Eh, 02h, 02h,0DAh, 0Bh
		db	0BFh, 0Bh,0C0h, 0Bh,0D9h, 0Bh
		db	 02h, 02h,0FFh, 0Eh,0FFh, 0Eh
		db	0FFh, 0Eh,0FFh, 0Eh, 02h, 02h
		db	0DAh, 0Ah,0BFh, 0Ah,0C0h, 0Ah
		db	0D9h, 0Ah, 02h, 02h,0FFh, 0Eh
		db	0FFh, 0Eh,0FFh, 0Eh,0FFh, 0Eh
		db	 02h, 02h,0DAh, 09h,0BFh, 09h
		db	0C0h, 09h,0D9h, 09h, 02h, 02h
		db	0FFh, 0Eh,0FFh, 0Eh,0FFh, 0Eh
		db	0FFh, 0Eh, 02h, 02h,0DAh, 04h
		db	0BFh, 04h,0C0h, 04h,0D9h, 04h
		db	 02h, 02h,0FFh, 0Eh,0FFh, 0Eh
		db	0FFh, 0Eh,0FFh, 0Eh, 02h, 10h
		db	 0Ch, 10h, 16h, 10h, 20h, 10h
		db	 2Ah, 10h, 34h, 10h, 3Eh, 10h
		db	 48h, 10h, 52h, 10h, 5Ch, 10h
		db	 66h, 10h, 70h, 10h, 7Ah, 10h
		db	 84h, 10h, 8Eh, 10h, 98h, 10h
		db	 00h
		db	31 dup (0)
		db	 02h, 02h, 93h, 0Fh, 93h, 0Fh
		db	 11h, 0Fh, 10h, 0Fh, 02h, 02h
		db	 4Fh, 0Fh, 4Fh, 0Fh, 11h, 0Fh
		db	 10h, 0Fh,0E2h, 10h,0ECh, 10h
		db	 00h, 00h, 00h, 00h, 01h, 01h
		db	 02h, 02h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 02h, 01h, 02h
		db	 18h, 02h, 00h, 00h, 00h, 00h
		db	 01h, 02h, 01h, 02h, 1Ah, 02h
		db	 00h, 00h, 00h, 00h, 01h, 02h
		db	 01h, 02h, 19h, 02h, 00h, 00h
		db	 00h, 00h, 01h, 02h, 1Bh, 02h
		db	 01h, 02h, 00h, 00h, 00h, 00h
		db	 08h, 11h, 12h, 11h, 12h, 11h
		db	 12h, 11h, 1Ch, 11h, 26h, 11h
		db	 26h, 11h, 26h, 11h, 00h
		db	15 dup (0)
		db	 01h, 01h, 09h, 0Eh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 01h
		db	 0Fh, 0Bh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 01h, 18h, 0Ah
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 01h, 2Fh, 0Ah, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 01h
		db	 1Ah, 0Ah, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 01h, 5Ch, 0Ah
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 01h, 19h, 0Ah, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 01h
		db	 2Fh, 0Ah, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 01h, 1Bh, 0Ah
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 01h, 5Ch, 0Ah, 00h, 00h
		db	 00h, 00h, 00h, 00h, 64h, 11h
		db	 6Eh, 11h, 78h, 11h, 82h, 11h
		db	 8Ch, 11h, 96h, 11h,0A0h, 11h
		db	0AAh, 11h, 00h
		db	15 dup (0)
		db	 50h, 11h, 5Ah, 11h, 50h, 11h
		db	 5Ah, 11h
		db	8 dup (0)
		db	 93h, 4Fh, 11h, 10h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 01h, 00h, 00h, 04h
		db	 03h, 04h, 04h, 04h, 04h, 04h
		db	 05h, 06h, 07h, 06h, 05h, 06h
		db	 06h, 06h, 06h, 00h, 00h, 00h
		db	 01h, 00h, 07h, 00h, 00h, 02h
		db	 02h, 02h, 02h, 02h, 03h, 02h
		db	 01h,0B9h,0BAh,0BBh,0BCh,0C8h
		db	0C9h,0CAh,0CBh,0CCh,0CDh,0CEh
		db	 01h, 02h, 18h, 1Ah, 19h, 1Bh
		db	0B9h,0BAh,0BBh,0BCh,0C8h,0C9h
		db	0CAh,0CBh,0CCh,0CDh,0CEh, 01h
		db	 02h, 18h, 1Ah, 19h
		db	1Bh, 0Ah, 0Dh, 'The SNIPES have t'
		db	'riumphed!!!$'
		db	 02h, 02h,0B0h, 0Fh,0B2h, 0Fh
		db	0B2h, 0Fh,0B0h, 0Fh, 02h, 02h
		db	0B2h, 0Bh,0B0h, 0Bh,0B0h, 0Bh
		db	0B2h, 0Bh, 02h, 02h,0B0h, 0Ch
		db	0B2h, 0Ch,0B2h, 0Ch,0B0h, 0Ch
		db	 02h, 02h,0B2h, 04h,0B0h, 04h
		db	0B0h, 04h,0B2h, 04h, 02h, 02h
		db	 2Ah, 06h, 0Fh, 06h, 2Ah, 06h
		db	 0Fh, 06h, 02h, 02h, 07h, 08h
		db	 20h, 08h, 07h, 08h, 20h, 08h
		db	0C2h, 12h,0CCh, 12h,0D6h, 12h
		db	0E0h, 12h,0EAh, 12h,0F4h, 12h
		db	 00h
		db	11 dup (0)
		db	 01h, 02h,0B0h, 0Fh,0B2h, 0Fh
		db	 00h, 00h, 00h, 00h, 01h, 02h
		db	0B2h, 0Bh,0B0h, 0Bh, 00h, 00h
		db	 00h, 00h, 01h, 02h,0B0h, 0Ch
		db	0B2h, 0Ch, 00h, 00h, 00h, 00h
		db	 01h, 02h,0B2h, 04h,0B0h, 04h
		db	 00h, 00h, 00h, 00h, 01h, 02h
		db	 2Ah, 06h, 0Fh, 06h, 00h, 00h
		db	 00h, 00h, 01h, 02h, 07h, 08h
		db	 20h, 08h, 00h, 00h, 00h, 00h
		db	 16h, 13h, 20h, 13h, 2Ah, 13h
		db	 34h, 13h, 3Eh, 13h, 48h, 13h
		db	 00h
		db	11 dup (0)
		db	 01h, 01h,0B2h, 0Fh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 01h
		db	 0Fh, 0Bh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 01h, 09h, 0Ch
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 01h, 07h, 04h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 6Ah, 13h
		db	 6Ah, 13h, 6Ah, 13h, 74h, 13h
		db	 7Eh, 13h, 88h, 13h
		db	12 dup (0)
		db	 64h, 00h, 64h, 00h, 78h, 05h
		db	 08h, 07h, 40h, 06h,0B0h, 04h
		db	 98h, 08h,0C8h, 19h, 08h, 07h
		db	 30h, 11h,0D0h, 20h, 4Ch, 04h
		db	0D0h, 07h, 40h, 1Fh, 64h, 19h
		db	0A0h, 0Fh,0C4h, 09h,0E8h, 03h
		db	 46h,0FEh, 89h,0ECh, 5Dh,0CAh
		db	 02h, 00h, 55h, 8Bh,0ECh, 83h
		db	 7Eh, 0Ah, 00h, 74h, 3Bh, 83h
		db	 7Eh, 0Ah,0FFh, 74h, 35h, 8Bh
		db	 5Eh, 0Ah, 8Bh, 47h, 2Eh,0B1h
		db	 09h,0D3h,0E8h,0C4h, 5Eh, 06h
		db	 26h, 89h, 47h, 02h, 8Bh, 5Eh
		db	 0Ah, 8Bh, 47h, 2Eh,0B1h, 07h
		db	0D3h,0E0h,0C4h, 5Eh, 06h, 26h
		db	 89h, 07h, 8Bh, 5Eh, 0Ah, 8Bh
		db	 47h, 30h,0C4h, 5Eh, 06h, 26h
		db	 01h, 07h,0C4h, 5Eh, 06h, 26h
		db	 83h, 57h, 02h, 00h,0B8h, 00h
		db	 00h, 5Dh,0CAh, 06h, 00h, 55h
		db	 8Bh,0ECh, 83h,0ECh, 08h, 83h
		db	 7Eh, 10h,0FFh, 74h, 06h, 83h
		db	 7Eh, 10h, 00h, 75h, 06h
loc_3AD3:
		mov	ax,1
;*		jmp	loc_3BA1		;*
		db	0E9h,0C8h, 00h		;  Fixup - byte match
loc_3AD9:
		mov	ax,[bp+6]
		and	ax,7Fh
		mov	bx,[bp+10h]
		mov	[bx+30h],ax
		mov	ax,[bp+6]
		mov	cl,7
		shr	ax,cl			; Shift w/zeros fill
		mov	dx,[bp+8]
		mov	cl,9
		shl	dx,cl			; Shift w/zeros fill
		add	ax,dx
		mov	[bp-6],ax
		mov	bx,[bp+10h]
		mov	[bx+2Eh],ax
		mov	ax,[bp+8]
		mov	cl,7
		shr	ax,cl			; Shift w/zeros fill
		mov	bx,[bp+10h]
		mov	[bx+23h],ax
		mov	ax,[bp+0Ah]
		shr	ax,cl			; Shift w/zeros fill
		mov	[bp-4],ax
		mov	ax,[bp+0Ch]
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		add	[bp+0Eh],ax
;*		and	word ptr [bp+0Ch],0Fh
		db	 81h, 66h, 0Ch, 0Fh, 00h	;  Fixup - byte match
		cmp	word ptr [bp-4],0
		jbe	loc_3B9E		; Jump if below or =
		les	ax,dword ptr [bp+0Ch]	; Load seg:offset ptr
		push	es
		push	ax
;*		call	far ptr s_0A31_00D6	;*
		db	9Ah
		dw	0D6h, 0A31h		;  Fixup - byte match
		mov	ax,[bp-6]
		mov	bx,[bp+10h]
		mov	[bx+21h],ax
		mov	word ptr [bp-8],1FFh
		mov	ax,1FFh
		cmp	ax,[bp-4]
		jbe	loc_3B4E		; Jump if below or =
		mov	ax,[bp-4]
		mov	[bp-8],ax
loc_3B4E:
		mov	bx,[bp+10h]
		lea	ax,[bx]			; Load effective addr
		push	ds
		push	ax
		push	word ptr [bp-8]
;*		call	far ptr s_0A31_0121	;*
		db	9Ah
		dw	121h, 0A31h		;  Fixup - byte match
		mov	ah,0
		mov	[bp-2],ax
		cmp	word ptr ds:[209Ah],0
		je	loc_3B9E		; Jump if equal
		cmp	word ptr [bp-2],1
		jnz	$+2			; delay for I/O
		db	16 dup (0)
data_3B7F	db	0

;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

real_start:
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		mov	data_3B7F,al
		mov	ax,1
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ax,cs:data_2411
		jmp	loc_0105
loc_3B93:
		mov	ah,0
		mov	al,cs:data_3B7F
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		jmp	$-3B9Bh
loc_3B9E:
		nop
		nop

seg_a		ends



		end	start
