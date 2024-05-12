
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
;==				TAPPER	                                 ==
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

d_0000_0000_e	equ	0
d_0000_0024_e	equ	24h
d_0000_0070_e	equ	70h
d_0000_00C1_e	equ	0C1h
d_0000_0200_e	equ	200h
d_0000_0280_e	equ	280h
d_0000_0410_e	equ	410h
d_0000_0460_e	equ	460h
d_0000_2000_e	equ	2000h			;*
d_0000_20C1_e	equ	20C1h			;*
d_0000_3DD6_e	equ	3DD6h			;*
d_0000_3E32_e	equ	3E32h			;*
d_0000_4000_e	equ	4000h			;*
d_0000_4012_e	equ	4012h			;*
d_0000_407F_e	equ	407Fh			;*
d_0000_4583_e	equ	4583h			;*
d_0000_4683_e	equ	4683h			;*
d_0000_4693_e	equ	4693h			;*
d_0000_46A3_e	equ	46A3h			;*
d_0000_46B3_e	equ	46B3h			;*
d_0040_003E_e	equ	3Eh
d_0040_0040_e	equ	40h
data_0000_e	equ	0
data_0006_e	equ	6
data_0007_e	equ	7
data_0009_e	equ	9
data_000B_e	equ	0Bh
data_000E_e	equ	0Eh
data_003E_e	equ	3Eh
PSP_cmd_size	equ	80h
data_0084_e	equ	84h
data_00B0_e	equ	0B0h
data_4683_e	equ	4683h			;*
data_4685_e	equ	4685h			;*
data_4687_e	equ	4687h			;*
data_4689_e	equ	4689h			;*
data_468B_e	equ	468Bh			;*
data_4691_e	equ	4691h			;*
data_4697_e	equ	4697h			;*
data_46A9_e	equ	46A9h			;*
data_46B9_e	equ	46B9h			;*
data_46CB_e	equ	46CBh			;*
data_47C3_e	equ	47C3h			;*
data_FFFD_e	equ	0FFFDh			;*
d_FFFF_000E_e	equ	0Eh

seg_a		segment	byte public
		assume	cs:seg_a, ds:seg_a


		org	100h

TAPPER		proc	far

start:
		jmp	short real_start
		db	90h

TAPPER		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0103	proc	near

		db	'TAPPER.DAT', 0

;		push	sp
;		inc	cx
;		push	ax
;		push	ax
;		inc	bp
;		push	dx
;		db	 2Eh, 44h, 41h, 54h, 00h

;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

real_start:
		; open file TAPPER.DAT
;*		lea	dx,ds:[103h]		; Load effective addr
		db	 8Dh, 16h, 03h, 01h	;  Fixup - byte match
		mov	ax,3D00h
		int	21h			; DOS Services  ah=function 3Dh
						;  open file, al=mode,name@ds:dx
		jnc	loc_011B		; Jump if carry=0

		; error, data file not found
		int	20h			; DOS program terminate

loc_011B:
		mov	word ptr ds:[100h],ax	; data file identifier

		; save interrupts INT 0 .. INT 19h
		push	ds
;*		sub	ax,ax
		db	 29h,0C0h		;  Fixup - byte match
		mov	ds,ax			; DS <- 0
;*		sub	si,si			; SI <- 0
		db	 29h,0F6h		;  Fixup - byte match
		mov	di,offset data_0200
		mov	cx,40h
		cli				; Disable interrupts
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		sti				; Enable interrupts
		pop	ds
		mov	ax,1
		jmp	loc_0680		; continue

sub_0103	endp

		db	 76h, 03h,0A0h,0A3h, 05h
loc_013B:
		mov	dl,0
		mov	dh,0
		mov	ah,0Eh
		pop	ds
;*		sub	ax,ax
		db	 29h,0C0h		;  Fixup - byte match
		mov	es,ax
;*		sub	di,di
		db	 29h,0FFh		;  Fixup - byte match
		mov	si,d_0000_0200_e
		mov	cx,40h
		cli				; Disable interrupts
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		sti				; Enable interrupts
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		mov	ax,3
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	al,36h			; '6'
		out	43h,al			; port 43h, 8253 timer control
;*		xor	al,al			; Zero register
		db	 30h,0C0h		;  Fixup - byte match
		out	40h,al			; port 40h, 8253 timer 0 clock
		out	40h,al			; port 40h, 8253 timer 0 clock
		int	20h			; DOS program terminate
		db	0A3h, 05h, 74h, 10h
loc_016B:
		add	bh,2
		dec	al
		jnz	loc_016B		; Jump if not zero
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		inc	ah
		mov	al,1
;*		jmpn	loc_012A		;*
		db	0E9h,0AFh,0FFh		;  Fixup - byte match
			                        ;* No entry point to code
		mov	dx,[si+2]
		pop	si
		pop	cx
		pop	bx
		pop	ax
		retn
			                        ;* No entry point to code
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	si,offset data_0598	; ('Disk Error')
		lodsb				; String [si] to al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
loc_018D:
		jz	loc_018D		; Jump if zero
		mov	bx,offset data_023C
;*		jz	loc_0140		;*Jump if zero
		db	 74h,0ACh		;  Fixup - byte match
		mov	cx,0Fh
		retn
			                        ;* No entry point to code
		inc	sp
		imul	si,word ptr [bp+di+6Bh],4520h	; reg = data * value
		jc	loc_0212		; Jump if carry Set
		outsw				; Out [si] to port dx
		jc	$+2			; delay for I/O
		add	[bx+si],al
;*		add	bh,bl
		db	 00h,0DFh		;  Fixup - byte match
		add	ah,[di]
		add	cl,[bx+di]
		sub	bh,bh
		push	ax
		mul	byte ptr [di]		; ax = data * al
		add	al,0
		add	[bp+di],cl
		db	 3Eh, 20h, 00h, 39h, 08h, 25h
		db	 00h,0D7h, 1Bh, 33h, 00h,0A2h
		db	 14h, 3Eh, 00h, 86h, 21h, 4Fh
		db	 00h, 50h, 0Ch, 56h, 00h,0C2h
		db	 10h, 5Fh, 00h,0C4h, 09h, 64h
		db	 00h,0D8h, 18h, 71h, 00h, 13h
		db	 19h, 7Eh, 00h,0C4h, 1Eh, 8Eh
		db	 00h, 90h, 21h, 9Fh, 00h, 90h
		db	 21h,0B0h, 00h, 14h, 17h,0BCh
		db	 00h, 9Eh, 17h,0B8h, 00h, 00h
		db	 8Eh,0D8h, 8Eh,0C0h,0FAh, 8Eh
		db	0D0h,0BCh,0FFh,0FFh,0FBh,0C7h
		db	 06h, 78h, 00h,0A6h

; Saved interrupts INT 00h ... INT 19h
data_0200	db	5
		db	0A3h, 7Ah, 00h,0FCh,0BEh, 00h
		db	 7Ch,0BFh, 00h, 05h,0B9h, 80h
		db	 00h,0F2h,0A5h,0B0h, 00h
loc_0212:
		mov	bx,680h
		call	sub_0103
		mov	al,1
;*		jmp	far ptr l_0000_0680	;*
		db	0EAh
		dw	680h, 0			;  Fixup - byte match
		db	29 dup (0)
data_023C	db	0
		db	565 dup (0)
data_0472	dw	0
		db	140 dup (0)
		db	0E9h,0EAh, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read data file, INPUT: AL = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes

;  AL*4 = offset of table at base 5B1h
;  SI[0] required 512-B sector, SI[2] number of bytes to read

sub_0503	proc	near
		push	ax
		push	bx
		push	cx
		push	si

		mov	ah,0
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill

		add	ax,5B1h
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		push	bx			; BX = data buffer

loc_0513:
		; set file pointer to sector DS:SI -> CX:DX offset
		mov	ax,200h			; AX <- sector size
		mov	bx,[si]			; BX <- required sector
		mul	bx			; dx:ax = reg * ax
;*		mov	cx,dx
		db	 89h,0D1h		;  Fixup - byte match
;*		mov	dx,ax
		db	 89h,0C2h		;  Fixup - byte match
		mov	bx,word ptr ds:[100h]	; data file identifier
		mov	ax,4200h
		int	21h			; DOS Services  ah=function 42h
						;  move file ptr, bx=file handle
						;   al=method, cx,dx=offset
		jc	loc_0513		; Jump if carry Set - repeat operation

		; read data
loc_0529:
		mov	cx,[si+2]		; CX <- number of bytes to read
		mov	bx,word ptr ds:[100h]	; data file identifier
		pop	dx			; DX = buffer address

		push	dx			; push buffer address
		push	ds
		push	es
		pop	ds
		mov	ax,3F00h
		int	21h			; DOS Services  ah=function 3Fh
						;  read file, bx=file handle
						;   cx=bytes to ds:dx buffer
		pop	ds
		jc	loc_0529		; Jump if carry Set - repeat operation

		; check number of bytes
		mov	dx,[si+2]		; DX <- number of bytes to read
;*		cmp	ax,dx			; check number of bytes
		db	 39h,0D0h		;  Fixup - byte match
		jc	loc_0529		; Jump if carry Set - not all data, repeat operation

		; all OK
		pop	bx			; BX = data buffer
		jmp	short loc_057E

		db	0FCh,0A5h, 05h, 04h

loc_054B:
		push	ax
		int	13h			; ??int non-standard interrupt
		pop	ax
		jnc	loc_0565		; Jump if carry=0
		dec	data_05A5
		jnz	loc_054B		; Jump if not zero
		push	ax
		mov	ah,0
		int	13h			; Disk  dl=drive ?  ah=func 00h
						;  reset disk, al=return status
		pop	ax
		dec	data_05A4
;*		jnz	loc_0546		;*Jump if not zero
		db	 75h,0E3h		;  Fixup - byte match
		jmp	short loc_0583		; report disk error
loc_0565:
		sub	data_05A3,al
		jz	loc_057B		; Jump if zero
loc_056B:
		add	bh,2
		dec	al
		jnz	loc_056B		; Jump if not zero
;*		mov	ah,ch
		db	 88h,0ECh		;  Fixup - byte match
		inc	ah
		mov	al,1
;*		jmpn	loc_052A		;*
		db	0E9h,0AFh,0FFh		;  Fixup - byte match
loc_057B:
		mov	dx,[si+2]

loc_057E:
		pop	si
		pop	cx
		pop	bx
		pop	ax
		retn

		; report disk error
loc_0583:
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		mov	si,offset data_0598	; ('Disk Error')
loc_058A:
		lodsb				; String [si] to al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match

		; lock on end of text
loc_058D:
		jz	loc_058D		; Jump if zero

		; display character
		mov	bx,0Fh
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		jmp	short loc_058A
sub_0503	endp

data_0598	db	'Disk Error', 0
data_05A3	db	0
data_05A4	db	3
data_05A5	db	3
		db	0DFh, 02h, 25h, 02h, 09h, 2Ah
		db	0FFh, 50h,0F6h, 25h, 04h


; Data file: SI[0] start 512-B sector, SI[2] number of bytes

data_05B1	dw	0	; offset 0
		dw	3E0Bh	; 20h sectors

		dw	20h	; offset 4000h
		dw	0839h	; 5 sectors

		dw	25h	; offset 4A00h
		dw	1BD7h	; 14 sectors

		dw	33h	; offset 6600h
		dw	14A2h	; 11 sectors

		dw	3Eh	; offset 7C00h
		dw	2186h	; 17 sectors

		dw	4Fh	; offset 9E00h
		dw	0C50h	; 7 sectors

		dw	56h	; offset AC00h
		dw	10C2h	; 9 sectors

		dw	5Fh	; offset BE00h
		dw	9C4h	; 5 sectors

		dw	64h
		dw	18D8h

		dw	71h
		dw	1913h

		dw	7Eh
		dw	1EC4h

		dw	8Eh
		dw	2190h

		dw	9Fh
		dw	2190h

		dw	0B0h
		dw	1714h

		dw	0BCh
		dw	179Eh


		db	 0B8h
		db	 00h, 00h, 8Eh,0D8h, 8Eh,0C0h
		db	0FAh, 8Eh,0D0h,0BCh,0FFh,0FFh
		db	0FBh,0C7h, 06h, 78h, 00h,0A6h
		db	 05h,0A3h, 7Ah, 00h,0FCh,0BEh
		db	 00h, 7Ch,0BFh, 00h, 05h,0B9h
		db	 80h, 00h,0F2h,0A5h,0B0h, 00h
		db	0BBh, 80h, 06h,0E8h,0EBh,0FEh
		db	0B0h, 01h,0EAh, 80h, 06h, 00h
		db	 00h
		db	97 dup (0)

; Start program continue

loc_0680:
		mov	bx,cs
		mov	ds,bx		; DS <- CS

		mov	byte ptr data_44BF,2Dh	; '-'
		mov	data_35AB,0
		mov	data_35AD,0
		mov	byte ptr data_44C1,0
		mov	bx,400h
;*		mov	sp,bx			; SP <- 400h
		db	 89h,0DCh		;  Fixup - byte match
		mov	data_4495,sp		; save SP = 400h

		push	ax
		call	sub_380B
		cli				; Disable interrupts
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		mov	es,ax		; ES <- 0

		lds	dx,dword ptr es:d_0000_0024_e	; Load seg:offset ptr
		mov	cs:data_4452,dx
		mov	word ptr cs:data_4452+2,ds
;*		mov	dx,ax
		db	 89h,0C2h		;  Fixup - byte match
		mov	word ptr es:d_0000_0024_e,33A5h
		mov	word ptr es:d_0000_0024_e+2,cs
		lds	dx,dword ptr es:d_0000_0070_e	; Load seg:offset ptr
		mov	cs:data_4456,dx
		mov	cs:data_4458,ds
		mov	dx,3758h
		mov	es:d_0000_0070_e,dx
		mov	word ptr es:d_0000_0070_e+2,cs
		cld				; Clear direction
		sti				; Enable interrupts
		push	cs
		pop	ds
		mov	ax,0FFFFh
		mov	es,ax
		cmp	byte ptr es:d_FFFF_000E_e,0FDh
		je	loc_06F8		; Jump if equal
		inc	al
loc_06F8:
		mov	data_44C6,al
		mov	data_44B7,3030h
		mov	data_449B,0
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		mov	es,ax
		mov	al,es:d_0000_0410_e
		and	al,0CFh
		or	al,10h
		mov	es:d_0000_0410_e,al
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	cs:data_4493,0B800h
		cmp	byte ptr cs:data_44C6,0
		je	loc_0731		; Jump if equal
		mov	al,7Fh
		mov	dx,3DFh
		out	dx,al			; port 3DFh ??i/o non-standard
loc_0731:
		pop	ax
		cmp	al,0
		jne	loc_0747		; Jump if not equal
		mov	byte ptr cs:data_44BD,0FFh
		mov	dx,3C28h
		mov	si,3C18h
		mov	bx,2F22h
		jmp	short loc_0756
loc_0747:
		mov	byte ptr cs:data_44BD,0
		mov	dx,3C21h
		mov	si,offset data_3C12
		mov	bx,2F0Fh
loc_0756:
		push	cs
		push	cs
		pop	ds
		pop	es
		mov	data_4497,dx
		mov	data_4499,bx
		mov	data_44BB,si
		mov	ax,cs
		add	ax,47Dh
		mov	data_448F,ax
		call	sub_0A36

		mov	si,data_44BB
		inc	si
		cmp	si,offset data_3C13
		jne	loc_07C8		; Jump if not equal

		mov	bx,47C3h
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
		push	si
		push	dx
;*		add	dx,bx
		db	 01h,0DAh		;  Fixup - byte match
		mov	data_449F,dx
		mov	cx,1004h
		call	sub_2EC9
		pop	bx
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44A1,bx
		pop	si
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
		push	si
		push	dx
;*		add	dx,bx
		db	 01h,0DAh		;  Fixup - byte match
		mov	data_44A3,dx
		mov	cx,1008h
		call	sub_2EC9
		pop	bx
		pop	si
		add	bx,data_44A3
		mov	data_44A7,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
		push	si
		push	dx
;*		add	dx,bx
		db	 01h,0DAh		;  Fixup - byte match
		mov	data_44A9,dx
		mov	cx,200Eh
		call	sub_2EC9
		pop	bx
		pop	si
		jmp	short loc_07FB
loc_07C8:
		mov	bx,47C3h
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_449F,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44A1,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44A3,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44A7,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44A9,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
loc_07FB:
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44A5,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match
		mov	data_44AB,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	bx,dx
		db	 01h,0D3h		;  Fixup - byte match

		mov	si,offset data_3C11
		mov	data_44AD,bx
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
;*		add	dx,bx
		db	 01h,0DAh		;  Fixup - byte match
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		add	dx,401h
		mov	ax,cs
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	data_4491,dx
		sub	dh,4
		mov	data_448F,dx
		mov	al,10h
		mov	bx,offset data_40BC
		mov	cx,3

locloop_083E:
		call	sub_2E96
		mov	[bx],bp
		add	bx,2
		inc	al
		loop	locloop_083E		; Loop if cx > 0

		mov	cx,3
		mov	bx,offset data_40C6

locloop_0850:
		call	sub_2E96
		mov	[bx],bp
		add	bx,2
		inc	al
		loop	locloop_0850		; Loop if cx > 0

		mov	al,1
		mov	bx,offset data_40B0
		mov	cx,2

locloop_0864:
		call	sub_2E96
		mov	[bx],bp
		add	bx,2
		inc	al
		loop	locloop_0864		; Loop if cx > 0

		mov	cx,2
		mov	bx,offset data_40B6
		mov	al,3

locloop_0878:
		call	sub_2E96
		mov	[bx],bp
		add	bx,2
		inc	al
		loop	locloop_0878		; Loop if cx > 0

		mov	di,offset data_4590
		mov	cx,10h
		mov	al,0

locloop_088C:
		inc	al
		mov	byte ptr [di-1],2
		stosb				; Store al to es:[di]
		add	di,0Fh
		and	al,3
		loop	locloop_088C		; Loop if cx > 0

		mov	ax,cs
		mov	ds,ax
		mov	byte ptr data_448B,1
		mov	byte ptr data_448C,0
		mov	byte ptr data_448D,0
		push	es
		mov	ax,cs
		mov	es,ax
		call	sub_35BF
		mov	ah,0
		int	13h			; Disk  dl=drive ?  ah=func 00h
						;  reset disk, al=return status
		pop	es
		mov	ax,4DAEh
		out	40h,al			; port 40h, 8253 timer 0 clock
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		out	40h,al			; port 40h, 8253 timer 0 clock
		call	sub_0A9F
		jmp	short loc_0913
loc_08C8:
		push	cs
		pop	ds
		mov	byte ptr data_44BE,0FFh
		cmp	byte ptr data_44C4,1
		je	loc_0913		; Jump if equal
		mov	byte ptr data_44C4,0FFh
		mov	si,offset data_44C8
		call	sub_0A7F
		mov	si,offset data_44D7
		call	sub_0A7F
		mov	si,offset data_44E6
		call	sub_0A7F
		mov	al,0Ah
		call	sub_2F5E
		cmp	al,39h			; '9'
		jne	loc_08F9		; Jump if not equal
		jmp	loc_0AC9
loc_08F9:
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_0913		; Jump if not zero
loc_08FD:
		push	cs
		pop	ds
		mov	byte ptr data_44C4,0FFh
		call	sub_0A36
		mov	al,0Ah
		call	sub_2F5E
		cmp	al,39h			; '9'
		jne	loc_0913		; Jump if not equal
		jmp	loc_0AC9
loc_0913:
		push	cs
		pop	ds
		call	sub_38B0
		mov	byte ptr data_44BE,0FFh
		mov	data_44B9,0
		mov	ax,0B10h
		cmp	byte ptr data_44BD,0
		je	loc_0930		; Jump if equal
		and	ah,0FDh
loc_0930:
		mov	data_44AF,ax
		call	sub_2D6F
		mov	byte ptr data_44C4,0FFh
		mov	es,data_4493
		mov	si,3C97h
		call	sub_2FAE
		call	sub_2F2D
		cmp	byte ptr data_44C6,0
		je	loc_0955		; Jump if equal
		mov	si,offset data_3D91
		call	sub_2F2D
loc_0955:
		mov	si,offset data_3D89
		mov	cx,4
		mov	di,offset data_448B

locloop_095E:
		lodsw				; String [si] to ax
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		mov	al,[di]
		cmp	byte ptr data_44C6,0
		je	loc_0981		; Jump if equal
		cmp	cl,1
		jne	loc_0981		; Jump if not equal
		test	al,1
		jz	loc_0991		; Jump if zero
		add	bx,280h
		test	al,2
		jz	loc_0991		; Jump if zero
		add	bx,280h
		jmp	short loc_0991
loc_0981:
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_0991		; Jump if zero
		add	bx,280h
		dec	al
		jz	loc_0991		; Jump if zero
		add	bx,d_0000_0280_e
loc_0991:
		mov	word ptr es:[bx],0FFFFh
		inc	di
		loop	locloop_095E		; Loop if cx > 0

loc_0999:
		mov	al,1Eh
		call	sub_2F5E
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_09A5		; Jump if not zero
		jmp	loc_0AC1
loc_09A5:
		cmp	al,39h			; '9'
		jne	loc_09AC		; Jump if not equal
		jmp	loc_0AC9
loc_09AC:
		cmp	al,3Bh			; ';'
		jne	loc_09B3		; Jump if not equal
		jmp	loc_08FD
loc_09B3:
		cmp	al,24h			; '$'
		jne	loc_09D0		; Jump if not equal
		push	ax
		call	sub_31A3
		pop	ax
		mov	byte ptr data_448B,0
		cmp	byte ptr data_4489,0FFh
		jne	loc_09CD		; Jump if not equal
		mov	byte ptr data_448B,1
loc_09CD:
		jmp	loc_0913
loc_09D0:
		mov	si,offset data_3D7C
;*		mov	dl,al
		db	 88h,0C2h		;  Fixup - byte match
;*		xor	dh,dh			; Zero register
		db	 30h,0F6h		;  Fixup - byte match
;*		xor	di,di			; Zero register
		db	 31h,0FFh		;  Fixup - byte match
		mov	cx,4

locloop_09DC:
		lodsb				; String [si] to al
		cmp	al,0FFh
		je	loc_09E9		; Jump if equal
;*		cmp	al,dl
		db	 38h,0D0h		;  Fixup - byte match
		jz	loc_09FD		; Jump if zero
		inc	dh
		jmp	short locloop_09DC
loc_09E9:
;*		xor	dh,dh			; Zero register
		db	 30h,0F6h		;  Fixup - byte match
		inc	di
		loop	locloop_09DC		; Loop if cx > 0

		cmp	byte ptr data_44C6,0
		je	loc_0999		; Jump if equal
		cmp	dl,2Dh			; '-'
		jne	loc_0999		; Jump if not equal
		mov	dh,3
		dec	di
loc_09FD:
		cmp	data_448B[di],dh
		je	loc_0999		; Jump if equal
		call	sub_0A1A
		mov	word ptr es:[bx],0FFFFh
		xchg	data_448B[di],dh
		call	sub_0A1A
		mov	word ptr es:[bx],0
		jmpn	loc_0999

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A1A	proc	near
		shl	di,1			; Shift w/zeros fill
		mov	ax,data_3D89[di]
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
;*		or	dh,dh			; Zero ?
		db	 08h,0F6h		;  Fixup - byte match
		jz	loc_0A33		; Jump if zero
		add	bx,280h
		cmp	dh,1
		je	loc_0A33		; Jump if equal
		add	bx,280h
loc_0A33:
		shr	di,1			; Shift w/zeros fill
		retn
sub_0A1A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A36	proc	near
		push	es
		push	ds
		mov	bx,4000h
		mov	es,cs:data_448F
		mov	si,cs:data_44BB
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
		mov	ax,es:d_0000_4000_e
		mov	cs:data_44AF,ax
		call	sub_2D6F
		call	sub_2DB5
		mov	ds,cs:data_448F
		mov	es,cs:data_4493
;*		xor	si,si			; Zero register
		db	 31h,0F6h		;  Fixup - byte match
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,2000h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		mov	byte ptr cs:data_445D,0FFh
		mov	cs:data_445E,0FFFFh
		mov	si,offset data_445A
		call	sub_301D
		pop	ds
		pop	es
		retn
sub_0A36	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A7F	proc	near
;*		mov	bx,si
		db	 89h,0F3h		;  Fixup - byte match
		mov	di,offset data_445A
		mov	cx,3

locloop_0A87:
		lodsb				; String [si] to al
		cmp	[di],al
		jb	loc_0A93		; Jump if below
		jbe	loc_0A8F		; Jump if below or =
		retn
loc_0A8F:
		inc	di
		loop	locloop_0A87		; Loop if cx > 0

		retn
loc_0A93:
		mov	ax,[bx]
		mov	data_445A,ax
		mov	al,[bx+2]
		mov	data_445C,al
		retn
sub_0A7F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0A9F	proc	near
		mov	data_44C8,0
		mov	byte ptr data_44CA,0
		mov	data_44D7,0
		mov	data_44E6,0
		mov	byte ptr data_44D9,0
		mov	byte ptr data_44E8,0
		retn
sub_0A9F	endp

loc_0AC1:
		mov	byte ptr cs:data_44C4,1
		jmp	short loc_0ACE
loc_0AC9:
		mov	byte ptr data_44C4,0
loc_0ACE:
		call	sub_0A9F
		mov	byte ptr data_44C0,0
		cmp	byte ptr data_448C,0
		je	loc_0B28		; Jump if equal
		mov	data_44F1,0
		mov	data_44EF,0
		mov	byte ptr data_44E5,0
		mov	data_44E6,0
		mov	data_44E8,0FF00h
		mov	data_44EA,0FFFFh
		mov	data_44EC,21h
		mov	byte ptr data_44EE,5
		mov	byte ptr data_44F3,1
		cmp	byte ptr data_44C4,0
		je	loc_0B28		; Jump if equal
		mov	data_44F1,0FFFFh
		mov	data_44EF,0FFFFh
		mov	byte ptr data_44E5,0FFh
loc_0B28:
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
;*		or	dx,dx			; Zero ?
		db	 09h,0D2h		;  Fixup - byte match
		jz	loc_0B28		; Jump if zero
		mov	data_449D,dx
		mov	data_44D3,0FFFFh
		mov	data_44D1,0FFFFh
		mov	byte ptr data_44C7,0FFh
		mov	data_44C8,0
		mov	data_44CA,0FF00h
		mov	data_44CC,0FFFFh
		mov	data_44CE,1
		mov	byte ptr data_44D0,4
		mov	byte ptr data_44D5,1
		cmp	byte ptr data_448D,0
		je	loc_0BC1		; Jump if equal
		mov	byte ptr data_44D5,2
		mov	byte ptr data_44F3,2
		mov	byte ptr data_44D0,2
		mov	byte ptr data_44EE,3
		cmp	byte ptr data_448D,1
		je	loc_0BC1		; Jump if equal
		mov	data_44C8,10h
		mov	data_44E6,10h
		mov	data_44D3,0Ch
		mov	data_44F1,0Dh
		mov	data_44D1,10h
		mov	data_44EF,11h
		mov	byte ptr data_44D5,12h
		mov	byte ptr data_44F3,12h
		mov	byte ptr data_44C7,0Ch
		mov	byte ptr data_44E5,0Dh
loc_0BC1:
		test	byte ptr data_448E,1
		jz	loc_0BDE		; Jump if zero
		test	byte ptr data_448E,2
		jnz	loc_0BD4		; Jump if not zero
		call	sub_380B
		jmp	short loc_0BD7
loc_0BD4:
		call	sub_3831
loc_0BD7:
		mov	al,7
		call	sub_38D0
		jmp	short loc_0BE8
loc_0BDE:
		call	sub_3853
		jmp	short loc_0BE8
loc_0BE3:
		push	cs
		pop	ds
		call	sub_38B0
loc_0BE8:
		call	sub_2FAE
		mov	si,offset data_3ED5
		mov	di,cs:data_44D1
		cmp	byte ptr cs:data_40CF[di],0
		je	loc_0BFE		; Jump if equal
		call	sub_2F2D
loc_0BFE:
		mov	si,data_44D1
		cmp	si,1Ah
		jne	loc_0C20		; Jump if not equal
		mov	si,offset data_40CE
		mov	di,0
loc_0C0D:
		lodsb				; String [si] to al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_0C13		; Jump if zero
		inc	di
loc_0C13:
		cmp	si,40D7h
		jne	loc_0C0D		; Jump if not equal
		mov	data_44D3,di
		mov	si,data_0009_e
loc_0C20:
		inc	si
		mov	data_44D1,si
		call	sub_0C2B
		jmp	loc_0D6C

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0C2B	proc	near
		mov	byte ptr data_44C3,1
		mov	byte ptr data_44C2,3Ch	; '<'
		mov	si,data_44D1
		mov	al,data_40CE[si]
		cmp	byte ptr data_44C4,0
		je	loc_0C4C		; Jump if equal
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_0C4C		; Jump if not zero
		pop	ax
;*		jmp	loc_0BFE
		db	0E9h,0B2h,0FFh		;  Fixup - byte match
loc_0C4C:
		cmp	al,data_44BE
		je	loc_0C86		; Jump if equal
		xor	byte ptr data_44BE,80h
		cmp	al,data_44BE
		je	loc_0C8F		; Jump if equal
		mov	data_44BE,al
		and	al,7Fh
loc_0C62:
		cbw				; Convrt byte to word
		mov	si,data_4497
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
		mov	es,data_448F
		mov	bx,4000h
		call	sub_2D66		; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
		mov	ax,es:d_0000_4000_e
		mov	cs:data_44AF,ax
		call	sub_2DB5
		test	byte ptr cs:data_44BE,80h
		jnz	loc_0C8F		; Jump if not zero
loc_0C86:
		cmp	byte ptr cs:data_44C3,0
		jne	loc_0C86		; Jump if not equal
		retn
loc_0C8F:
		cmp	byte ptr data_44BD,0
		je	loc_0CA5		; Jump if equal
		and	al,7Fh
		mov	data_44BE,al
		add	al,6
		cmp	al,0Ah
		jb	loc_0C62		; Jump if below
		sub	al,2
		jmp	short loc_0C62
loc_0CA5:
		push	ds
		mov	ds,cs:data_448F
;*		xor	si,si			; Zero register
		db	 31h,0F6h		;  Fixup - byte match
		mov	di,404Fh
		mov	cx,6450h
		call	sub_0CD2
		mov	si,d_0000_2000_e
		mov	di,604Fh
		mov	cx,6450h
		call	sub_0CD2
		mov	ax,ds
		mov	es,ax
;*		xor	di,di			; Zero register
		db	 31h,0FFh		;  Fixup - byte match
		mov	si,d_0000_4000_e
		mov	cx,2000h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		pop	ds
		retn
sub_0C2B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_0CD2	proc	near
loc_0CD2:
		lodsb				; String [si] to al
		call	word ptr cs:data_4499
		mov	[di],dl
		dec	di
		dec	cl
		jnz	loc_0CD2		; Jump if not zero
		mov	cl,50h			; 'P'
		add	di,0A0h
		dec	ch
		jnz	loc_0CD2		; Jump if not zero
		retn
sub_0CD2	endp

loc_0CEA:
		push	cs
		pop	ds
		call	sub_38B0
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match

locloop_0CF1:
		loop	locloop_0CF1		; Loop if cx > 0


locloop_0CF3:
		loop	locloop_0CF3		; Loop if cx > 0

		cmp	byte ptr data_44D0,0
		je	loc_0D2C		; Jump if equal
		cmp	byte ptr data_448C,1
		jne	loc_0D10		; Jump if not equal
		call	sub_2FC4
		cmp	byte ptr data_44D0,0
		jne	loc_0D10		; Jump if not equal
		call	sub_2FC4
loc_0D10:
		call	sub_2FAE
		mov	si,offset data_3ED5
		call	sub_2F2D
		dec	data_44D0
		cmp	byte ptr data_44C4,0
		je	loc_0D27		; Jump if equal
		jmp	loc_0BFE
loc_0D27:
		call	sub_0C2B
		jmp	short loc_0D84
loc_0D2C:
		cmp	byte ptr data_448C,1
		jne	loc_0D41		; Jump if not equal
		mov	si,offset data_3DAD
		call	sub_2F2D
		mov	al,data_44C0
		add	al,31h			; '1'
		call	sub_2F44
loc_0D41:
		mov	si,offset data_3DB8
		call	sub_2F2D
		mov	byte ptr data_44C3,2
loc_0D4C:
		cmp	byte ptr data_44C3,0
		jne	loc_0D4C		; Jump if not equal
		cmp	byte ptr data_448C,1
		je	loc_0D5D		; Jump if equal
		jmp	loc_08C8
loc_0D5D:
		call	sub_2FC4
		cmp	byte ptr data_44D0,0
		jne	loc_0D6A		; Jump if not equal
		jmp	loc_08C8
loc_0D6A:
		jmp	short loc_0D10
loc_0D6C:
		or	byte ptr cs:data_448C,80h
		cmp	byte ptr cs:data_44BE,0
		je	loc_0D84		; Jump if equal
		inc	cs:data_44D3
		inc	cs:data_44C7
loc_0D84:
		call	sub_2D6F
		mov	ds,cs:data_448F
		mov	cx,2000h
		mov	es,cs:data_4491
;*		xor	si,si			; Zero register
		db	 31h,0F6h		;  Fixup - byte match
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		mov	cx,2000h
		mov	es,cs:data_4493
;*		xor	si,si			; Zero register
		db	 31h,0F6h		;  Fixup - byte match
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		push	cs
		push	cs
		pop	ds
		pop	es
		mov	sp,data_4495		; save SP = 400h
		cmp	byte ptr data_44BE,0
		jne	loc_0DBF		; Jump if not equal
		and	byte ptr data_448C,7Fh
		jmp	loc_240C
loc_0DBF:
		cmp	byte ptr data_448C,1
		jne	loc_0DE5		; Jump if not equal
		mov	si,offset data_3DAD
		call	sub_2F2D
		mov	al,data_44C0
		add	al,31h			; '1'
		call	sub_2F44
		mov	byte ptr data_44C3,1
		mov	byte ptr data_44C2,3Ch	; '<'
loc_0DDE:
		cmp	byte ptr data_44C3,0
		jne	loc_0DDE		; Jump if not equal
loc_0DE5:
		and	byte ptr data_448C,7Fh
		mov	cx,11h
		mov	al,2
		mov	di,offset data_458A

locloop_0DF2:
		stosb				; Store al to es:[di]
		add	di,0Fh
		loop	locloop_0DF2		; Loop if cx > 0

		mov	di,offset data_4589
		mov	cx,10h
;*		xor	al,al			; Zero register
		db	 30h,0C0h		;  Fixup - byte match

locloop_0E00:
		mov	word ptr [di-4],40C4h
		stosb				; Store al to es:[di]
		add	di,0Fh
		loop	locloop_0E00		; Loop if cx > 0

		mov	bx,data_44D3
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
;*		xor	di,di			; Zero register
		db	 31h,0FFh		;  Fixup - byte match
		mov	cx,4
loc_0E1A:
		push	cx
;*		mov	bp,di
		db	 89h,0FDh		;  Fixup - byte match
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		add	bp,offset data_4583
		mov	ax,data_4105[bx]
;*		mov	cl,ah
		db	 88h,0E1h		;  Fixup - byte match
;*		xor	ch,ch			; Zero register
		db	 30h,0EDh		;  Fixup - byte match
		push	di
		push	cx
		cbw				; Convrt byte to word
;*		mov	si,bp
		db	 89h,0EEh		;  Fixup - byte match

locloop_0E38:
		mov	[si+0Eh],al
		add	si,10h
		loop	locloop_0E38		; Loop if cx > 0

		pop	cx
		sar	ax,1			; Shift w/sign fill
		neg	ax
		mov	byte ptr data_455B[di],al
		mov	data_44FC,ax
;*		mov	dx,di
		db	 89h,0FAh		;  Fixup - byte match
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
;*		mov	ax,dx
		db	 89h,0D0h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		add	dx,13h
;*		xor	si,si			; Zero register
		db	 31h,0F6h		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill

locloop_0E63:
		push	dx
		add	dl,data_41AE[bx+si]
		mov	[bp+9],dl
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		mov	ax,dx
		db	 89h,0D0h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	al,data_402A[di]
		cbw				; Convrt byte to word
;*		add	ax,si
		db	 01h,0F0h		;  Fixup - byte match
;*		add	ax,si
		db	 01h,0F0h		;  Fixup - byte match
;*		add	ax,si
		db	 01h,0F0h		;  Fixup - byte match
		cmp	byte ptr data_44FC,0
		je	loc_0E97		; Jump if equal
		shl	si,1			; Shift w/zeros fill
;*		sub	ax,si
		db	 29h,0F0h		;  Fixup - byte match
;*		sub	ax,si
		db	 29h,0F0h		;  Fixup - byte match
;*		sub	ax,si
		db	 29h,0F0h		;  Fixup - byte match
		shr	si,1			; Shift w/zeros fill
loc_0E97:
		mov	[bp+8],al
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	[bp+4],dx
		mov	al,data_41AD[bx+si]
		mov	ah,byte ptr data_44FC
		ror	ah,1			; Rotate
;*		or	al,ah
		db	 08h,0E0h		;  Fixup - byte match
		mov	[bp+0Bh],al
		call	sub_2E53
		mov	byte ptr [bp+6],9
		add	bp,10h
		inc	si
		inc	si
		pop	dx
		loop	locloop_0E63		; Loop if cx > 0

		shr	bx,1			; Shift w/zeros fill
		shr	bx,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		mov	ax,data_404A[di]
		pop	di
		mov	data_457B[di],ax
;*		mov	dx,di
		db	 89h,0FAh		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
;*		mov	ax,dx
		db	 89h,0D0h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		add	dx,16h
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		mov	ax,dx
		db	 89h,0D0h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		push	dx
		mov	si,data_44FC
;*		mov	bp,di
		db	 89h,0FDh		;  Fixup - byte match
		mov	al,ss:data_4032[bp+si]
		mov	byte ptr data_455B+1[di],al
		cbw				; Convrt byte to word
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		shl	bp,1			; Shift w/zeros fill
		mov	ss:data_454B[bp],dx
		add	dx,280h
		mov	ss:data_454D[bp],dx
		shl	si,1			; Shift w/zeros fill
		mov	ax,ss:data_403A[bp+si]
		mov	data_4543[di],ax
		pop	dx
;*		or	si,si			; Zero ?
		db	 09h,0F6h		;  Fixup - byte match
		jnz	loc_0F1C		; Jump if not zero
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
loc_0F1C:
		cbw				; Convrt byte to word
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		sub	dx,0F1h
		mov	al,byte ptr data_44FC
		cbw				; Convrt byte to word
		mov	data_456B[di],dx
		mov	si,data_44D1
		mov	ah,data_40EA[si]
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		ror	al,1			; Rotate
;*		or	al,ah
		db	 08h,0E0h		;  Fixup - byte match
		inc	al
		call	sub_2DF4
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		cmp	byte ptr data_455B[di],0
		jne	loc_0F4D		; Jump if not equal
		mov	al,2
loc_0F4D:
		add	ax,0A0h
		mov	data_4563[di],ax
		inc	di
		inc	di
		inc	bx
		inc	bx
		pop	cx
		dec	cl
		jz	loc_0F60		; Jump if zero
		jmp	loc_0E1A
loc_0F60:
		mov	ax,data_454F
		mov	ds:data_4687_e,ax
		mov	ax,data_4551
		mov	ds:data_4697_e,ax
		mov	al,data_455E
		mov	byte ptr ds:data_4691_e,0
		mov	ds:data_468B_e,al
		mov	bp,data_4683_e
		mov	al,data_455D
		ror	al,1			; Rotate
		mov	byte ptr [bp+6],8
		or	[bp+6],al
		add	al,1
		mov	[bp+0Bh],al
		mov	[bp+0Ah],al
		call	sub_2E1E
		add	al,2
		add	bp,10h
		call	sub_2E1E
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		mov	di,offset data_44F4
		mov	cx,4Fh
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		mov	word ptr data_4530+1,46C3h
		mov	di,data_46CB_e
		mov	cx,20h

locloop_0FAF:
		mov	[di-8],di
		add	di,8
		loop	locloop_0FAF		; Loop if cx > 0

		mov	word ptr [di-10h],0
		mov	si,data_44D1
		mov	al,data_40EA[si]
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		cmp	byte ptr data_44C6,0
		je	loc_0FD1		; Jump if equal
		add	al,10h
loc_0FD1:
		cbw				; Convrt byte to word
		add	ax,408Eh
		mov	data_451A,ax
		mov	byte ptr ds:data_46A9_e,0
		mov	byte ptr ds:data_46B9_e,0
		mov	byte ptr data_4522,1
		mov	byte ptr data_44C3,0Fh
		mov	data_450C,202h
		mov	byte ptr data_4520,4
		mov	byte ptr data_452D,10h
		cmp	byte ptr data_44C6,0
		je	loc_1008		; Jump if equal
		mov	byte ptr data_4520,2
loc_1008:
		mov	dx,1700h
		cmp	byte ptr data_4561,0
		je	loc_1014		; Jump if equal
		mov	dl,26h			; '&'
loc_1014:
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	al,data_44C7
		inc	al
		cmp	al,0Ah
		jb	loc_1034		; Jump if below
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
loc_1025:
		sub	al,0Ah
		inc	ah
		cmp	al,0Ah
		jae	loc_1025		; Jump if above or =
		push	ax
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		call	sub_32DF
		pop	ax
loc_1034:
		call	sub_32DF
		mov	al,data_44C7
		inc	al
		cmp	al,3
		jb	loc_1042		; Jump if below
		mov	al,4
loc_1042:
		mov	data_451F,al
		mov	al,data_44C7
		inc	al
		cmp	al,2
		jae	loc_1050		; Jump if above or =
		mov	al,2
loc_1050:
		cmp	al,7
		jbe	loc_1056		; Jump if below or =
		mov	al,7
loc_1056:
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		mov	data_4510,ax
		mov	si,data_44D1
		mov	al,data_40EA[si]
		inc	al
;*		mov	bl,al
		db	 88h,0C3h		;  Fixup - byte match
		shl	al,1			; Shift w/zeros fill
		cmp	al,4
		ja	loc_1071		; Jump if above
		dec	al
		jmp	short loc_1075
loc_1071:
		or	al,5
		and	al,7
loc_1075:
		mov	data_452B,al
;*		mov	al,bl
		db	 88h,0D8h		;  Fixup - byte match
		call	sub_38D0
		call	sub_2FFB
		mov	ax,1388h
		cmp	byte ptr data_44C6,0
		je	loc_108D		; Jump if equal
		mov	ax,190h
loc_108D:
		cmp	byte ptr data_44C7,6
		jb	loc_1096		; Jump if below
		shr	ax,1			; Shift w/zeros fill
loc_1096:
		mov	data_4516,ax
loc_1099:
		mov	bp,cs:data_44F4
		inc	byte ptr cs:data_44F4
		cmp	bp,3
		jne	loc_10D4		; Jump if not equal
		mov	byte ptr cs:data_44F4,0
		dec	byte ptr cs:data_450C
		jnz	loc_10BD		; Jump if not zero
		mov	al,byte ptr cs:data_450C+1
		mov	byte ptr cs:data_450C,al
loc_10BD:
		cmp	byte ptr cs:data_44C1,0
		je	loc_10D4		; Jump if equal
		push	si
		mov	si,d_0000_407F_e
		call	sub_2F2D
loc_10CC:
		cmp	byte ptr cs:data_44C1,0
		jne	loc_10CC		; Jump if not equal
loc_10D4:
		dec	cs:data_452D
		jz	loc_10DE		; Jump if zero
		jmp	loc_118A
loc_10DE:
		mov	byte ptr cs:data_452D,10h
		cmp	byte ptr cs:data_44C6,0
		je	loc_10F2		; Jump if equal
		sub	byte ptr cs:data_452D,6
loc_10F2:
		cmp	byte ptr cs:data_452C,0
		jne	loc_10FD		; Jump if not equal
		jmp	loc_118A
loc_10FD:
		mov	es,cs:data_4493
		mov	ds,cs:data_4491
		dec	cs:data_452C
		jnz	loc_1139		; Jump if not zero
		call	sub_227F
		mov	byte ptr cs:data_4506,0
		mov	si,cs:data_44D1
		mov	al,cs:data_40EA[si]
		inc	al
		call	sub_38D0
		push	bp
		mov	cx,10h
		mov	bp,d_0000_4583_e

locloop_112D:
		and	byte ptr [bp+6],0FBh
		add	bp,10h
		loop	locloop_112D		; Loop if cx > 0

		pop	bp
		jmp	short loc_116E
loc_1139:
		mov	ax,cs
		mov	ds,ax
		mov	di,0C1h
		mov	si,data_4506
		mov	al,data_4067[si]
		add	al,data_452B
		call	sub_2E7A
		mov	dl,10h
loc_1151:
		mov	cx,0Eh
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		add	di,42h
		dec	dl
		jnz	loc_1151		; Jump if not zero
		mov	di,d_0000_20C1_e
		mov	dl,10h
loc_1162:
		mov	cx,0Eh
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		add	di,42h
		dec	dl
		jnz	loc_1162		; Jump if not zero
loc_116E:
		mov	ax,cs:data_4506
		cmp	byte ptr cs:data_452B,7
		je	loc_1184		; Jump if equal
		inc	ax
		cmp	al,6
		jb	loc_1186		; Jump if below
		mov	ax,0
		jmp	short loc_1186
loc_1184:
		xor	al,3
loc_1186:
		mov	cs:data_4506,ax
loc_118A:
		mov	ds,cs:data_448F
		mov	es,cs:data_4491
		shl	bp,1			; Shift w/zeros fill
		mov	cs:data_44F6,bp
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		shl	bp,1			; Shift w/zeros fill
		add	bp,d_0000_4583_e
		mov	cs:data_44F8,bp
		mov	cx,4
loc_11B1:
		test	byte ptr [bp+6],1
		jnz	loc_11BA		; Jump if not zero
		jmp	loc_124E
loc_11BA:
		mov	di,[bp+4]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	di,[bp+4]
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
loc_124E:
		add	bp,10h
		dec	cl
		jz	loc_1258		; Jump if zero
		jmp	loc_11B1
loc_1258:
		mov	cx,4
		mov	bp,cs:data_44F8
loc_1260:
		mov	dh,[bp+6]
		test	dh,8
		jnz	loc_126B		; Jump if not zero
		jmp	loc_1783
loc_126B:
		test	dh,1
		jnz	loc_1273		; Jump if not zero
		jmp	loc_176A
loc_1273:
		test	dh,20h			; ' '
		jnz	loc_12EB		; Jump if not zero
		dec	byte ptr [bp+0Dh]
		jz	loc_1280		; Jump if zero
		jmp	loc_1783
loc_1280:
		mov	al,cs:data_4520
		mov	[bp+0Dh],al
		test	dh,2
		jz	loc_128F		; Jump if zero
		jmp	loc_1641
loc_128F:
		test	dh,40h			; '@'
		jnz	loc_12D6		; Jump if not zero
		test	dh,4
		jz	loc_12AF		; Jump if zero
		mov	al,[bp+0Bh]
		dec	byte ptr [bp+7]
		jnz	loc_12A7		; Jump if not zero
		xor	al,80h
		mov	byte ptr [bp+7],2
loc_12A7:
		add	al,8
		call	sub_2E53
		jmp	loc_1783
loc_12AF:
		dec	byte ptr [bp+7]
		mov	al,[bp+7]
		cbw				; Convrt byte to word
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	al,cs:data_405A[si]
		dec	al
		add	al,[bp+0Bh]
		call	sub_2E53
		cmp	byte ptr [bp+7],0
		je	loc_12CE		; Jump if equal
		jmp	loc_1783
loc_12CE:
		mov	byte ptr [bp+7],2
		or	byte ptr [bp+6],40h	; '@'
loc_12D6:
		dec	byte ptr [bp+7]
		jnz	loc_12EB		; Jump if not zero
		mov	al,8
		sub	al,byte ptr cs:data_44F6
		inc	al
		mov	[bp+7],al
		and	byte ptr [bp+6],0BFh
loc_12EB:
		mov	al,[bp+0Eh]
		add	[bp+8],al
		cbw				; Convrt byte to word
		add	[bp+4],ax
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		mov	bx,cs:data_44F6
;*		sub	bx,ax
		db	 29h,0C3h		;  Fixup - byte match
		mov	al,byte ptr cs:data_4543[bx]
;*		or	ah,ah			; Zero ?
		db	 08h,0E4h		;  Fixup - byte match
		jnz	loc_131C		; Jump if not zero
		dec	al
		cmp	[bp+8],al
		jg	loc_1323		; Jump if >
loc_1310:
		test	byte ptr [bp+6],20h	; ' '
		jz	loc_1319		; Jump if zero
		jmp	loc_173F
loc_1319:
		jmp	loc_1783
loc_131C:
		inc	al
		cmp	[bp+8],al
		jge	loc_1310		; Jump if > or =
loc_1323:
		test	byte ptr [bp+6],20h	; ' '
		jnz	loc_132C		; Jump if not zero
		jmp	loc_13DA
loc_132C:
		mov	al,[bp+0Eh]
		neg	al
		sar	al,1			; Shift w/sign fill
		mov	[bp+0Eh],al
		and	byte ptr [bp+6],0DEh
		call	sub_2F4C
		mov	bx,cs:data_451A
		mov	si,cs:data_4518
		and	al,0Fh
		mov	ah,cs:[bx+si]
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		cmp	byte ptr cs:data_4520,2
		ja	loc_1360		; Jump if above
		add	ah,10h
		add	ah,cs:data_452E
loc_1360:
;*		add	al,ah
		db	 00h,0E0h		;  Fixup - byte match
		mov	[bp+7],al
		mov	dx,[bp+4]
		mov	al,[bp+8]
		cbw				; Convrt byte to word
;*		sub	dx,ax
		db	 29h,0C2h		;  Fixup - byte match
		mov	di,cs:data_44F6
		mov	al,byte ptr cs:data_455B[di]
		cbw				; Convrt byte to word
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		mov	al,cs:data_402A[di]
		cbw				; Convrt byte to word
		mov	[bp+8],al
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	ax,4
;*		sub	ax,cx
		db	 29h,0C8h		;  Fixup - byte match
		shl	ax,1			; Shift w/zeros fill
;*		mov	di,ax
		db	 89h,0C7h		;  Fixup - byte match
		shl	ax,1			; Shift w/zeros fill
;*		add	ax,di
		db	 01h,0F8h		;  Fixup - byte match
		mov	di,cs:data_44F6
		cmp	byte ptr cs:data_455B[di],0
		je	loc_13A2		; Jump if equal
		neg	ax
loc_13A2:
		add	[bp+8],al
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	[bp+4],dx
		mov	al,[bp+0Bh]
		call	sub_2E53
		push	dx
		mov	dx,50h
		mov	si,cs:data_44D1
		mov	al,cs:data_40EA[si]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_13D3		; Jump if zero
		mov	dx,75h
		dec	al
		jz	loc_13D3		; Jump if zero
		mov	dx,100h
		dec	al
		jz	loc_13D3		; Jump if zero
		mov	dx,150h
loc_13D3:
		call	sub_3150
		pop	dx
		jmp	loc_1783
loc_13DA:
		or	byte ptr cs:data_44C4,80h
		mov	ax,cs:data_44F6
		mov	cs:data_4530,ax
		push	bp
		mov	al,13h
		call	sub_21B3
		call	sub_23FB
		call	sub_23FB
		call	sub_23FB
		call	sub_23FB
		pop	bp
		xor	byte ptr [bp+0Bh],80h
		mov	al,[bp+0Bh]
		call	sub_2E53
		push	bp
		mov	bp,d_0000_4693_e
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		mov	bp,d_0000_4683_e
		mov	di,cs:data_4530
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		shl	si,1			; Shift w/zeros fill
		mov	ax,cs:data_455B[di]
		mov	bx,data_000B_e
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_1433		; Jump if not zero
		neg	bx
loc_1433:
;*		add	ah,bl
		db	 00h,0DCh		;  Fixup - byte match
		mov	[bp+8],ah
		mov	dx,cs:data_454B[si]
;*		add	dx,bx
		db	 01h,0DAh		;  Fixup - byte match
		mov	[bp+4],dx
		mov	dx,cs:data_454D[si]
		xor	bx,8
;*		add	dx,bx
		db	 01h,0DAh		;  Fixup - byte match
		sub	dx,280h
		mov	[bp+14h],dx
		xor	al,1
		cbw				; Convrt byte to word
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		xor	al,1
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		shl	ah,1			; Shift w/zeros fill
		dec	ah
		mov	[bp+0Eh],ah
		ror	al,1			; Rotate
		add	al,3Bh			; ';'
		and	byte ptr [bp+6],0F7h
		push	di
		call	sub_21B3
		pop	di
		pop	bx
		mov	cx,4
		mov	bp,cs:data_44F8

locloop_1479:
		mov	byte ptr [bp+0Eh],0
		add	bp,10h
		loop	locloop_1479		; Loop if cx > 0

		mov	al,cs:data_4691_e
		mov	cs:[bx+0Eh],al
loc_148A:
		push	di
		mov	ds,cs:data_448F
		mov	es,cs:data_4491
		mov	bp,d_0000_4683_e
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		mov	bp,d_0000_4693_e
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		mov	cx,4
		mov	bp,cs:data_44F8
loc_14C3:
		test	byte ptr cs:[bp+6],1
		jnz	loc_14CD		; Jump if not zero
		jmp	loc_1561
loc_14CD:
		mov	di,[bp+4]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	di,[bp+4]
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
loc_1561:
		add	bp,10h
		dec	cl
		jz	loc_156B		; Jump if zero
		jmp	loc_14C3
loc_156B:
		mov	ds,cs:data_4491
		mov	cx,4
		mov	bx,cs:data_44F8

locloop_1578:
		test	byte ptr cs:[bx+6],1
		jz	loc_15A0		; Jump if zero
		push	cx
		mov	al,cs:[bx+0Eh]
		cbw				; Convrt byte to word
		add	cs:[bx+4],ax
;*		mov	bp,cs:[bx+0]
		db	 2Eh, 8Bh, 6Fh, 00h	;  Fixup - byte match
		db	 2Eh, 8Bh, 77h, 04h, 89h,0F7h
		db	0E8h, 84h, 17h, 89h,0F7h, 81h
		db	0F7h, 00h, 20h,0E8h, 7Bh, 17h
		db	59h
loc_15A0:
		add	bx,10h
		loop	locloop_1578		; Loop if cx > 0

		mov	bp,d_0000_4683_e
		mov	al,[bp+0Eh]
		cbw				; Convrt byte to word
		add	[bp+8],al
		add	[bp+18h],al
		add	[bp+4],ax
		add	[bp+14h],ax
		call	sub_2CE0
		add	bp,10h
		call	sub_2CE0
		mov	bx,cs:data_4530
		mov	si,cs:data_456B[bx]
		mov	bp,cs:data_4573[bx]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2D39
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2D39
		mov	es,cs:data_4493
		mov	bx,cs:data_4530
		mov	si,cs:data_3EEB[bx]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	ax,0Bh
loc_15F2:
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		sub	si,50h
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		dec	al
		jnz	loc_15F2		; Jump if not zero
		mov	cx,2000h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_161D		; Jump if equal
		mov	cx,1000h

locloop_161D:
		loop	locloop_161D		; Loop if cx > 0

		mov	bp,d_0000_4683_e
		mov	al,[bp+8]
		add	al,2
		pop	di
		cmp	byte ptr cs:data_4543[di],al
		je	loc_1632		; Jump if equal
		jmp	loc_148A
loc_1632:
		call	sub_21B3
		call	sub_3B1E
		and	byte ptr cs:data_44C4,7Fh
		jmp	loc_0CEA
loc_1641:
		dec	byte ptr [bp+0Ch]
		jz	loc_1649		; Jump if zero
		jmp	loc_1783
loc_1649:
		mov	ah,2
		cmp	byte ptr cs:data_44C6,0
		je	loc_1655		; Jump if equal
		shr	ah,1			; Shift w/zeros fill
loc_1655:
		mov	al,[bp+0Bh]
		and	al,7Fh
		add	al,9
loc_165C:
		sub	al,14h
		jl	loc_1664		; Jump if <
		jnz	loc_165C		; Jump if not zero
		shl	ah,1			; Shift w/zeros fill
loc_1664:
		mov	[bp+0Ch],ah
		cmp	byte ptr [bp+7],0
		je	loc_1670		; Jump if equal
		jmp	loc_1720
loc_1670:
		mov	al,[bp+0Bh]
		call	sub_2E53
		and	byte ptr [bp+6],0FDh
		mov	byte ptr [bp+7],3
		mov	si,word ptr cs:data_4530+1
		mov	ax,cs:[si]
		mov	word ptr cs:data_4530+1,ax
		mov	bx,cs:data_44F6
		add	bx,offset data_453B
		mov	ax,cs:[bx]
		mov	cs:[bx],si
		mov	cs:[si],ax
		mov	al,[bp+0Eh]
		neg	al
		sar	al,1			; Shift w/sign fill
		mov	[bp+0Eh],al
		cmp	byte ptr cs:data_452E,0
		je	loc_16B0		; Jump if equal
		shl	al,1			; Shift w/zeros fill
loc_16B0:
		mov	cs:[si+6],al
		mov	ax,[bp+4]
		add	ax,0F0h
		mov	cs:[si+2],ax
		mov	al,[bp+8]
		mov	cs:[si+7],al
		dec	byte ptr cs:data_4510
		jnz	loc_171E		; Jump if not zero
		mov	al,byte ptr cs:data_4510+1
		mov	byte ptr cs:data_4510,al
		cmp	byte ptr cs:data_452C,0
		jne	loc_171E		; Jump if not equal
		call	sub_2102
		cmp	cs:data_450E,0
		jne	loc_16F4		; Jump if not equal
		cmp	byte ptr cs:data_451F,0
		je	loc_171E		; Jump if equal
		dec	cs:data_451F
loc_16F4:
		mov	dx,[bp+4]
		add	dx,280h
		mov	al,[bp+0Eh]
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	cs:data_450E,dx
		add	al,[bp+8]
		mov	cs:data_451E,al
		mov	al,byte ptr cs:data_44F6
		mov	cs:data_451D,al
		mov	al,0Ah
		call	sub_38D0
loc_171E:
		jmp	short loc_1783
loc_1720:
		mov	bx,4063h
		dec	byte ptr [bp+7]
		add	word ptr [bp+2],2
		mov	al,[bp+7]
		cbw				; Convrt byte to word
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	al,cs:data_4063[si]
		dec	al
		add	al,[bp+0Bh]
		call	sub_2E53
		jmp	short loc_1783
loc_173F:
		dec	byte ptr [bp+7]
		jnz	loc_1783		; Jump if not zero
		mov	al,[bp+6]
		and	al,0DFh
		or	al,2
		mov	[bp+6],al
		mov	byte ptr [bp+7],4
		mov	di,cs:data_44F6
		mov	ax,40BAh
		cmp	byte ptr cs:data_455B[di],0
		je	loc_1765		; Jump if equal
		mov	ax,40C4h
loc_1765:
		mov	[bp+2],ax
		jmp	short loc_1783
loc_176A:
		dec	byte ptr [bp+7]
		jnz	loc_1783		; Jump if not zero
		or	byte ptr [bp+6],41h	; 'A'
		mov	byte ptr [bp+7],2
		mov	al,cs:data_4520
		mov	[bp+0Dh],al
		mov	al,0Ch
		call	sub_38D0
loc_1783:
		add	bp,10h
		dec	cl
		jz	loc_178D		; Jump if zero
		jmp	loc_1260
loc_178D:
		mov	si,cs:data_44F6
		add	si,offset data_4533
loc_1796:
		mov	bx,cs:[si]
;*		or	bx,bx			; Zero ?
		db	 09h,0DBh		;  Fixup - byte match
		jnz	loc_17A0		; Jump if not zero
		jmp	loc_18A5
loc_17A0:
		mov	di,cs:[bx+2]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	di,cs:[bx+2]
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	al,cs:[bx+6]
		add	cs:[bx+7],al
		cbw				; Convrt byte to word
		add	cs:[bx+2],ax
		push	ax
		mov	cx,4
		mov	bp,cs:data_44F8
		add	bp,30h

locloop_182B:
		mov	dl,[bp+6]
		test	dl,1
		jz	loc_1870		; Jump if zero
		test	dl,2
		jnz	loc_1870		; Jump if not zero
		test	dl,4
		jnz	loc_1870		; Jump if not zero
		mov	dl,[bp+8]
		cmp	cs:[bx+7],dl
		jl	loc_1870		; Jump if <
		add	dl,3
		cmp	cs:[bx+7],dl
		jg	loc_1870		; Jump if >
		or	byte ptr [bp+6],20h	; ' '
		call	sub_2EB3
		mov	al,[bp+0Eh]
		neg	al
		shl	al,1			; Shift w/zeros fill
		mov	[bp+0Eh],al
		mov	byte ptr [bp+7],0Ch
		mov	al,[bp+0Bh]
		add	al,4
		call	sub_2E53
		pop	ax
		jmp	loc_1796
loc_1870:
		sub	bp,10h
		loop	locloop_182B		; Loop if cx > 0

		pop	ax
;*		mov	di,ax
		db	 89h,0C7h		;  Fixup - byte match
		sar	di,1			; Shift w/sign fill
		sar	di,1			; Shift w/sign fill
		neg	di
		add	di,cs:data_44F6
		mov	ah,byte ptr cs:data_4543[di]
		cmp	cs:[bx+7],ah
		jl	loc_18A0		; Jump if <
		add	ah,2
		cmp	cs:[bx+7],ah
		jg	loc_18A0		; Jump if >
		call	sub_21A8
		call	sub_2144
		jmp	loc_0CEA
loc_18A0:
;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
		jmp	loc_1796
loc_18A5:
		mov	si,cs:data_44F6
		add	si,offset data_453B
loc_18AE:
		mov	bx,cs:[si]
;*		or	bx,bx			; Zero ?
		db	 09h,0DBh		;  Fixup - byte match
		jnz	loc_18B8		; Jump if not zero
		jmp	loc_19F6
loc_18B8:
		mov	di,cs:[bx+2]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	di,cs:[bx+2]
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	al,cs:[bx+6]
		cbw				; Convrt byte to word
		cmp	byte ptr cs:data_450C,2
		je	loc_193F		; Jump if equal
		add	cs:[bx+7],al
		add	cs:[bx+2],ax
loc_193F:
		mov	dl,cs:data_4522
		shl	dl,1			; Shift w/zeros fill
		cmp	byte ptr cs:data_44F6,dl
		jne	loc_1979		; Jump if not equal
		mov	dl,cs:data_468B_e
		sub	dl,1
		mov	dh,cs:data_4691_e
		shl	dh,1			; Shift w/zeros fill
;*		add	dl,dh
		db	 00h,0F2h		;  Fixup - byte match
		cmp	cs:[bx+7],dl
		jl	loc_1979		; Jump if <
		add	dl,7
		cmp	cs:[bx+7],dl
		jg	loc_1979		; Jump if >
		call	sub_2EB3
		mov	dx,100h
		call	sub_3150
		jmp	loc_18AE
loc_1979:
;*		mov	di,ax
		db	 89h,0C7h		;  Fixup - byte match
		sar	di,1			; Shift w/sign fill
		sar	di,1			; Shift w/sign fill
		neg	di
		add	di,cs:data_44F6
		mov	ah,byte ptr cs:data_4543[di]
		cmp	al,0
		jl	loc_199A		; Jump if <
		add	ah,4
		cmp	cs:[bx+7],ah
		jl	loc_19F1		; Jump if <
		jmp	short loc_19A3
loc_199A:
		sub	ah,4
		cmp	cs:[bx+7],ah
		jg	loc_19F1		; Jump if >
loc_19A3:
		push	cs:data_44F6
		call	sub_21A8
		mov	cx,8
		pop	di
		mov	al,18h
		cmp	byte ptr cs:data_455B[di],0
		je	loc_19BB		; Jump if equal
		inc	al
loc_19BB:
		call	sub_2E96

locloop_19BE:
		push	cx
		push	bp
		add	word ptr cs:[bx+2],50h
		mov	si,cs:[bx+2]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2D1A
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2D1A
		mov	cx,2000h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_19E5		; Jump if equal
		mov	cx,1000h

locloop_19E5:
		loop	locloop_19E5		; Loop if cx > 0

		pop	bp
		pop	cx
		loop	locloop_19BE		; Loop if cx > 0

		call	sub_2144
		jmp	loc_0CEA
loc_19F1:
;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
		jmp	loc_18AE
loc_19F6:
		mov	bp,d_0000_46A3_e
		test	byte ptr [bp+6],8
		jz	loc_1A5A		; Jump if zero
		mov	al,cs:data_4523
		shl	al,1			; Shift w/zeros fill
		cmp	al,byte ptr cs:data_44F6
		jne	loc_1A5A		; Jump if not equal
		test	byte ptr [bp+6],4
		jnz	loc_1A2C		; Jump if not zero
		or	byte ptr [bp+6],4
		add	bp,10h
		push	ds
		push	es
		mov	ds,cs:data_4491
		mov	es,cs:data_4493
		call	sub_2CE0
		pop	es
		pop	ds
		jmp	short loc_1A5A
loc_1A2C:
		xor	byte ptr [bp+6],0Ch
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		push	es
		mov	es,cs:data_4493
		add	bp,10h
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		pop	es
loc_1A5A:
		mov	bp,4683h
		mov	al,cs:data_4522
		shl	al,1			; Shift w/zeros fill
		cmp	al,byte ptr cs:data_44F6
		je	loc_1A6D		; Jump if equal
		jmp	loc_1DE8
loc_1A6D:
		cmp	byte ptr cs:data_448B,0
		jne	loc_1ABC		; Jump if not equal
		call	sub_32C2
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		cmp	byte ptr cs:data_44B1+1,bh
		jb	loc_1A85		; Jump if below
		mov	ah,0FFh
		jmp	short loc_1A8E
loc_1A85:
		cmp	byte ptr cs:data_44B5+1,bh
		ja	loc_1A8E		; Jump if above
		mov	ah,1
loc_1A8E:
		mov	byte ptr cs:data_44B9,ah
		cmp	byte ptr cs:data_44B1,bl
		jb	loc_1A9E		; Jump if below
		mov	al,0FFh
		jmp	short loc_1AA7
loc_1A9E:
		cmp	byte ptr cs:data_44B5,bl
		ja	loc_1AA7		; Jump if above
		mov	al,1
loc_1AA7:
		mov	[bp+0Eh],al
		cmp	byte ptr cs:data_44C4,0
		je	loc_1ABC		; Jump if equal
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jz	loc_1ABC		; Jump if zero
		mov	byte ptr cs:data_4488,0FFh
loc_1ABC:
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		push	es
		mov	es,cs:data_4493
		mov	al,[bp+0Eh]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_1ADC		; Jump if not zero
		jmp	loc_1B6B
loc_1ADC:
		mov	cs:data_450A,40AEh
		mov	byte ptr cs:data_4524,0
		and	byte ptr [bp+6],0EFh
		cbw				; Convrt byte to word
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
		sar	bx,1			; Shift w/sign fill
		neg	bx
		add	bx,cs:data_44F6
		mov	dl,[bp+8]
		cmp	al,0
		jl	loc_1B09		; Jump if <
		cmp	byte ptr cs:data_457B[bx],dl
		jbe	loc_1B3D		; Jump if below or =
		jmp	short loc_1B10
loc_1B09:
		cmp	byte ptr cs:data_457B[bx],dl
		jae	loc_1B3D		; Jump if above or =
loc_1B10:
		mov	si,[bp+14h]
		cmp	al,0FFh
		jne	loc_1B1A		; Jump if not equal
		add	si,6
loc_1B1A:
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		add	[bp+8],al
		add	[bp+4],ax
		add	[bp+14h],ax
		push	ax
		mov	cx,8

locloop_1B29:
		mov	ax,word ptr ds:[2000h][si]
		mov	es:d_0000_2000_e[di],ax
		lodsw				; String [si] to ax
		stosw				; Store ax to es:[di]
		add	si,4Eh
		add	di,4Eh
		loop	locloop_1B29		; Loop if cx > 0

		pop	ax
loc_1B3D:
		sar	al,1			; Shift w/sign fill
		neg	al
		ror	al,1			; Rotate
		test	byte ptr [bp+6],1
		jnz	loc_1B55		; Jump if not zero
		or	byte ptr [bp+6],1
		mov	byte ptr [bp+0Bh],1Fh
		mov	byte ptr [bp+7],1
loc_1B55:
		and	byte ptr [bp+0Bh],7Fh
		or	[bp+0Bh],al
		and	byte ptr [bp+0Ah],7Fh
		or	[bp+0Ah],al
		mov	dl,3
		dec	byte ptr [bp+7]
		jmp	loc_1D4A
loc_1B6B:
		cmp	byte ptr cs:data_448B,0
		jne	loc_1B8E		; Jump if not equal
		cmp	byte ptr cs:data_44B7,30h	; '0'
		jne	loc_1B7E		; Jump if not equal
		jmp	loc_1C4D
loc_1B7E:
		cmp	byte ptr cs:data_44C4,0
		je	loc_1B99		; Jump if equal
		mov	byte ptr cs:data_4488,39h	; '9'
		jmp	short loc_1B99
loc_1B8E:
		mov	al,byte ptr cs:data_449B+1
		test	al,1
		jnz	loc_1B99		; Jump if not zero
		jmp	loc_1C4D
loc_1B99:
		test	byte ptr [bp+6],10h
		jz	loc_1BA2		; Jump if zero
		jmp	loc_1C22
loc_1BA2:
		and	byte ptr [bp+6],0FEh
		mov	di,[bp+14h]
		call	sub_2C6A
		mov	di,[bp+14h]
		xor	di,2000h
		call	sub_2C6A
		mov	bx,cs:data_44F6
		mov	al,[bp+6]
		and	al,80h
		rol	al,1			; Rotate
		cbw				; Convrt byte to word
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		mov	al,cs:data_4032[bx]
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		xchg	[bp+8],al
;*		sub	ah,al
		db	 28h,0C4h		;  Fixup - byte match
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		cbw				; Convrt byte to word
		add	[bp+4],ax
		add	[bp+14h],ax
		mov	byte ptr cs:data_4524,3
		mov	byte ptr cs:data_4525,3
		or	byte ptr [bp+6],10h
		mov	al,[bp+6]
		and	al,80h
		add	bp,10h
		add	al,0Bh
		call	sub_2E1E
		sub	bp,10h
		mov	bx,40ACh
		mov	ah,[bp+6]
		and	ah,80h
		jz	loc_1C08		; Jump if zero
		mov	bx,40B2h
loc_1C08:
		mov	cs:data_450A,bx
		mov	bx,[bp+4]
		mov	al,5
		jz	loc_1C16		; Jump if zero
		mov	al,1
loc_1C16:
		cbw				; Convrt byte to word
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		add	bx,140h
		mov	cs:data_4508,bx
loc_1C22:
		mov	al,[bp+6]
		and	al,80h
		add	al,0Dh
		call	sub_2E1E
		add	bp,10h
		cmp	byte ptr cs:data_4524,0
		je	loc_1C4A		; Jump if equal
		add	cs:data_450A,2
		dec	cs:data_4524
		jz	loc_1C4A		; Jump if zero
		mov	byte ptr cs:data_4525,3
loc_1C4A:
		jmp	loc_1D6C
loc_1C4D:
		test	byte ptr [bp+6],10h
		jnz	loc_1C56		; Jump if not zero
		jmp	loc_1D1E
loc_1C56:
		cmp	byte ptr cs:data_4524,0
		je	loc_1C6B		; Jump if equal
		mov	al,[bp+6]
		and	al,80h
		add	al,9
		call	sub_2E1E
		jmp	loc_1D6F
loc_1C6B:
		mov	cs:data_450A,40AEh
		mov	al,[bp+6]
		and	al,80h
		add	al,0Fh
		call	sub_2E1E
		add	bp,10h
		add	al,2
		call	sub_2E1E
		sub	bp,10h
		and	al,80h
		add	al,1
		mov	[bp+0Ah],al
		mov	[bp+0Bh],al
		mov	byte ptr [bp+7],2
		and	byte ptr [bp+6],0EFh
		push	ds
		mov	ax,cs
		mov	ds,ax
		mov	bx,word ptr data_4530+1
		mov	ax,[bx]
		mov	word ptr data_4530+1,ax
		mov	si,data_44F6
		add	si,offset data_4533
		mov	ax,[si]
		mov	[si],bx
		mov	[bx],ax
		push	bp
		mov	al,5
		mov	ah,[bp+6]
		and	ah,80h
		jnz	loc_1CC2		; Jump if not zero
		inc	al
loc_1CC2:
		call	sub_2E96
		mov	[bx+4],bp
		pop	bp
		rol	ah,1			; Rotate
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		sub	ah,2
		mov	[bx+6],ah
		cbw				; Convrt byte to word
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		neg	al
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	si,data_44F6
		add	al,byte ptr data_4543[si]
		add	al,3

		;mov	ds:data_0007_e[bx],al
		db	88h, 87h, 7, 0

		mov	dx,data_44F6
		shl	dx,1			; Shift w/zeros fill
;*		mov	cx,dx
		db	 89h,0D1h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		add	dx,cx
		db	 01h,0CAh		;  Fixup - byte match
		add	dx,18h
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		mov	cx,dx
		db	 89h,0D1h		;  Fixup - byte match
		shl	dx,1			; Shift w/zeros fill
		shl	dx,1			; Shift w/zeros fill
;*		add	dx,cx
		db	 01h,0CAh		;  Fixup - byte match
		cbw				; Convrt byte to word
;*		add	dx,ax
		db	 01h,0C2h		;  Fixup - byte match
		mov	[bx+2],dx
		pop	ds
		call	sub_2CE0
		add	bp,10h
		jmp	short loc_1D6C
loc_1D1E:
		test	byte ptr [bp+6],1
		jz	loc_1D36		; Jump if zero
		mov	al,[bp+6]
		and	al,80h
		add	al,1
		mov	[bp+0Bh],al
		mov	byte ptr [bp+7],1
		and	byte ptr [bp+6],0FEh
loc_1D36:
		mov	dl,8
		dec	byte ptr [bp+7]
		test	byte ptr [bp+7],3
		jz	loc_1D46		; Jump if zero
		add	bp,10h
		jmp	short loc_1D6C
loc_1D46:
		cmp	byte ptr [bp+7],0
loc_1D4A:
		je	loc_1D55		; Jump if equal
		add	byte ptr [bp+0Ah],4
		mov	al,[bp+0Ah]
		jmp	short loc_1D5E
loc_1D55:
		mov	[bp+7],dl
		mov	al,[bp+0Bh]
		mov	[bp+0Ah],al
loc_1D5E:
		call	sub_2E1E
		mov	al,[bp+0Ah]
		add	al,2
		add	bp,10h
		call	sub_2E1E
loc_1D6C:
		call	sub_2CE0
loc_1D6F:
		pop	es
		mov	ax,cs:data_450E
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		jz	loc_1DE5		; Jump if zero
		mov	al,byte ptr cs:data_44F6
		cmp	cs:data_451D,al
		jne	loc_1DE5		; Jump if not equal
		mov	al,cs:data_468B_e
		sub	al,3
		cmp	cs:data_451E,al
		jb	loc_1DE5		; Jump if below
		add	al,9
		cmp	cs:data_451E,al
		ja	loc_1DE5		; Jump if above
		call	sub_2102
		mov	cs:data_450E,0
		mov	dx,1500h
		call	sub_3150
		mov	byte ptr cs:data_452C,40h	; '@'
		mov	al,5
		call	sub_38D0
		mov	cx,10h
		mov	bp,d_0000_4583_e

locloop_1DBA:
		mov	dl,[bp+6]
		test	dl,1
		jz	loc_1DE0		; Jump if zero
		and	dl,22h			; '"'
		jnz	loc_1DE0		; Jump if not zero
		call	sub_2F4C
;*		xor	al,ah
		db	 30h,0E0h		;  Fixup - byte match
		test	al,1
		jz	loc_1DE0		; Jump if zero
		mov	al,[bp+0Bh]
		add	al,8
		call	sub_2E53
		or	byte ptr [bp+6],4
		and	byte ptr [bp+6],0BFh
loc_1DE0:
		add	bp,10h
		loop	locloop_1DBA		; Loop if cx > 0

loc_1DE5:
		call	sub_3055
loc_1DE8:
		mov	bx,cs:data_44F8
		mov	ds,cs:data_4491
		mov	cx,4

locloop_1DF5:
		test	byte ptr cs:[bx+6],1
		jz	loc_1E42		; Jump if zero
		push	cx
;*		mov	bp,cs:[bx+0]
		db	 2Eh, 8Bh, 6Fh, 00h	;  Fixup - byte match
		db	 2Eh, 8Bh, 7Fh, 04h,0E8h, 12h
		db	 0Fh, 2Eh, 8Bh, 7Fh, 04h, 81h
		db	0F7h, 00h, 20h,0E8h, 07h, 0Fh
		db	 2Eh,0F6h, 47h, 06h, 02h, 74h
		db	 27h, 2Eh, 8Bh, 6Fh, 02h, 8Bh
		db	 6Eh, 00h, 09h,0EDh, 74h, 1Ch
		db	 2Eh, 8Bh, 36h,0F6h, 44h, 2Eh
		db	 8Bh,0B4h, 63h, 45h, 2Eh, 03h
		db	 77h, 04h, 89h,0F7h,0E8h, 90h
		db	 05h, 89h,0F7h, 81h,0F7h, 00h
		db	 20h,0E8h, 87h, 05h
		db	59h
loc_1E42:
		add	bx,10h
		loop	locloop_1DF5		; Loop if cx > 0

		mov	si,cs:data_450E
;*		or	si,si			; Zero ?
		db	 09h,0F6h		;  Fixup - byte match
		jz	loc_1E63		; Jump if zero
		mov	al,0Fh
		call	sub_2E96
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_23DC
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_23DC
loc_1E63:
		call	sub_22EB
		mov	bx,cs:data_44F6
		mov	di,cs:data_456B[bx]
		mov	bp,cs:data_4573[bx]
		call	sub_2D39
		mov	di,cs:data_456B[bx]
		xor	di,2000h
		call	sub_2D39
		mov	bp,d_0000_46A3_e
		test	byte ptr [bp+6],8
		jz	loc_1E90		; Jump if zero
		call	sub_2CE0
loc_1E90:
		mov	bp,data_4683_e
		call	sub_2CE0
		mov	bp,cs:data_450A
		mov	bp,[bp]
;*		or	bp,bp			; Zero ?
		db	 09h,0EDh		;  Fixup - byte match
		jz	loc_1EB5		; Jump if zero
		mov	si,cs:data_4508
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_23C8
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_23C8
loc_1EB5:
		mov	es,cs:data_4493
		mov	bx,cs:data_44F6
		mov	si,cs:data_3EEB[bx]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	dx,3DAh
		in	al,dx			; port 3DAh, CGA/EGA vid status
		test	al,8
		in	al,dx			; port 3DAh, CGA/EGA vid status
		test	al,8
		mov	ax,0Bh
loc_1ED2:
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		sub	si,50h
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		dec	al
		jnz	loc_1ED2		; Jump if not zero
		cmp	byte ptr cs:data_44C6,0
		je	loc_1F11		; Jump if equal
		cmp	byte ptr cs:data_4525,0
		je	loc_1F11		; Jump if equal
		dec	cs:data_4525
		jnz	loc_1F11		; Jump if not zero
		dec	cs:data_4524
		add	cs:data_450A,2
loc_1F11:
		cmp	byte ptr cs:data_44C3,0
		jne	loc_1F69		; Jump if not equal
		mov	byte ptr cs:data_44C3,0Fh
		inc	byte ptr cs:data_4518
		and	byte ptr cs:data_4518,3
		mov	al,cs:data_452F
		cmp	al,10h
		je	loc_1F69		; Jump if equal
		inc	cs:data_452F
		cmp	al,3
		je	loc_1F5B		; Jump if equal
		cmp	al,5
		je	loc_1F4D		; Jump if equal
		cmp	al,7
		je	loc_1F63		; Jump if equal
		cmp	al,9
		jne	loc_1F69		; Jump if not equal
		mov	byte ptr cs:data_452F,10h
loc_1F4D:
		mov	al,cs:data_4520
		shr	al,1			; Shift w/zeros fill
		jz	loc_1F69		; Jump if zero
		mov	cs:data_4520,al
		jmp	short loc_1F69
loc_1F5B:
		mov	byte ptr cs:data_450C+1,1
		jmp	short loc_1F69
loc_1F63:
		mov	byte ptr cs:data_452E,10h
loc_1F69:
		cmp	byte ptr cs:data_4488,0
		jne	loc_1FBC		; Jump if not equal
		cmp	byte ptr cs:data_4487,0
		jne	loc_1F8A		; Jump if not equal
		mov	cx,10h
		mov	bp,d_0000_4583_e

locloop_1F7F:
		test	byte ptr [bp+6],1
		jnz	loc_1FE6		; Jump if not zero
		add	bp,10h
		loop	locloop_1F7F		; Loop if cx > 0

loc_1F8A:
		mov	byte ptr cs:data_4487,0
		mov	dx,1000h
		call	sub_3150
		call	sub_3055
		call	sub_38B0
		mov	al,7
		call	sub_38D0
		mov	cx,4
		mov	al,17h

locloop_1FA6:
		push	ax
		push	cx
		call	sub_21B3
		call	sub_23FB
		pop	cx
		pop	ax
		xor	al,80h
		loop	locloop_1FA6		; Loop if cx > 0

		mov	cx,8000h

locloop_1FB7:
		loop	locloop_1FB7		; Loop if cx > 0

		jmp	loc_0BE3
loc_1FBC:
		mov	bx,913h
		cmp	byte ptr cs:data_4488,3Bh	; ';'
		jne	loc_1FCA		; Jump if not equal
		mov	bx,8FDh
loc_1FCA:
		cmp	byte ptr cs:data_44C4,0
		jne	loc_1FD5		; Jump if not equal
		mov	bx,913h
loc_1FD5:
		mov	byte ptr cs:data_4488,0
		mov	byte ptr cs:data_44BE,0FFh
		call	sub_38B0
		jmp	bx			;*Register jump
loc_1FE6:
		cmp	byte ptr cs:data_448B,0
		jne	loc_2004		; Jump if not equal
		mov	ax,cs:data_44B9
		mov	byte ptr cs:data_44B9+1,al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_200E		; Jump if zero
;*		sub	al,ah
		db	 28h,0E0h		;  Fixup - byte match
		cmp	al,1
		je	loc_200E		; Jump if equal
		sar	al,1			; Shift w/sign fill
		jmp	short loc_200E
loc_2004:
		mov	al,cs:data_4521
		mov	byte ptr cs:data_4521,0
loc_200E:
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_2015		; Jump if not zero
		jmp	loc_1099
loc_2015:
		mov	cs:data_450A,40AEh
		mov	byte ptr cs:data_4524,0
		mov	ds,cs:data_448F
		mov	es,cs:data_4491
		mov	ah,cs:data_4522
;*		add	al,ah
		db	 00h,0E0h		;  Fixup - byte match
		and	al,3
		mov	cs:data_4522,al
		mov	cs:data_4523,ah
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		push	ax
		mov	bp,d_0000_4683_e
		test	byte ptr [bp+26h],8
		jz	loc_207D		; Jump if zero
		add	bp,20h
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		push	es
		mov	es,cs:data_4493
		add	bp,10h
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		pop	es
		sub	bp,30h
loc_207D:
		mov	byte ptr [bp+6],8
		or	byte ptr [bp+26h],8
		and	byte ptr [bp+26h],0FBh
		mov	di,[bp+4]
		mov	[bp+24h],di
		mov	di,[bp+14h]
		mov	[bp+34h],di
		mov	al,[bp+6]
		mov	bp,d_0000_46A3_e
		and	al,80h
		add	al,3Fh			; '?'
		call	sub_2E1E
		add	al,2
		add	bp,10h
		call	sub_2E1E
		pop	bp
		mov	dx,ss:data_454B[bp]
		mov	cs:data_4687_e,dx
		mov	dx,ss:data_454D[bp]
		mov	cs:data_4697_e,dx
		shr	bp,1			; Shift w/zeros fill
		mov	ax,ss:data_455B[bp]
		mov	cs:data_468B_e,ah
		ror	al,1			; Rotate
		and	byte ptr cs:data_4689_e,7Fh
		or	cs:data_4689_e,al
		add	al,1
		mov	bp,d_0000_4683_e
		mov	[bp+0Bh],al
		mov	byte ptr [bp+7],2
		call	sub_2E1E
		add	al,2
		add	bp,10h
		call	sub_2E1E
		mov	bp,d_0000_46A3_e
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
		jmp	loc_1099

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2102	proc	near
		mov	si,cs:data_450E
;*		or	si,si			; Zero ?
		db	 09h,0F6h		;  Fixup - byte match
		jz	loc_ret_2143		; Jump if zero
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]

loc_ret_2143:
		retn
sub_2102	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2144	proc	near
		call	sub_38B0
		mov	al,16h
		call	sub_2E96
		call	sub_2190
		call	sub_23FB
		inc	al
		call	sub_2190
		push	bx
		push	ds
		push	es
		call	sub_3B1E
		pop	es
		pop	ds
		pop	bx
		mov	al,16h
		call	sub_2190
		call	sub_2169
		retn
sub_2144	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2169	proc	near
		mov	si,cs:[bx+2]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,8

locloop_2172:
		mov	ax,word ptr ds:[2000h][di]
		mov	es:d_0000_2000_e[di],ax
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,word ptr ds:[2000h][di]
		mov	es:d_0000_2000_e[di],ax
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		loop	locloop_2172		; Loop if cx > 0

		retn
sub_2169	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2190	proc	near
		call	sub_2E96
		push	ax
		mov	si,cs:[bx+2]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2D1A
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2D1A
		pop	ax
		retn
sub_2190	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_21A8	proc	near
		push	bx
		call	sub_2EB3
		mov	al,13h
		call	sub_21B3
		pop	bx
		retn
sub_21A8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_21B3	proc	near
		push	ax
		mov	bp,d_0000_4683_e
		call	sub_2E1E
		add	bp,10h
		add	al,2
		call	sub_2E1E
		mov	ds,cs:data_448F
		mov	es,cs:data_4491
		call	sub_22AA
		mov	ds,cs:data_4491
		pop	ax
		and	al,7Fh
		cmp	al,17h
		je	loc_2205		; Jump if equal
		mov	bx,offset data_4583
		mov	cx,10h

locloop_21E1:
		test	byte ptr cs:[bx+6],1
		jz	loc_2200		; Jump if zero
		push	cx
;*		mov	bp,cs:[bx+0]
		db	 2Eh, 8Bh, 6Fh, 00h	;  Fixup - byte match
		db	 2Eh, 8Bh, 7Fh, 04h,0E8h, 26h
		db	 0Bh, 2Eh, 8Bh, 7Fh, 04h, 81h
		db	0F7h, 00h, 20h,0E8h, 1Bh, 0Bh
		db	59h
loc_2200:
		add	bx,10h
		loop	locloop_21E1		; Loop if cx > 0

loc_2205:
		mov	cs:data_44F6,0
		mov	cx,4

locloop_220F:
		push	cx
		call	sub_22EB
		mov	bx,cs:data_44F6
		mov	di,cs:data_456B[bx]
		mov	bp,cs:data_4573[bx]
		call	sub_2D39
		mov	di,cs:data_456B[bx]
		xor	di,2000h
		call	sub_2D39
		add	cs:data_44F6,2
		pop	cx
		loop	locloop_220F		; Loop if cx > 0

		mov	bp,d_0000_4683_e
		test	byte ptr [bp+6],8
		jz	loc_2246		; Jump if zero
		call	sub_2CE0
loc_2246:
		mov	es,cs:data_4493
		call	sub_22AA
		mov	bp,d_0000_46B3_e
		test	byte ptr [bp-0Ah],8
		jz	loc_2267		; Jump if zero
		mov	di,[bp+4]
		call	sub_2C6A
		mov	di,[bp+4]
		xor	di,2000h
		call	sub_2C6A
loc_2267:
		mov	bp,d_0000_4693_e
		test	byte ptr [bp-0Ah],8
		jz	loc_2273		; Jump if zero
		call	sub_2CE0
loc_2273:
		cmp	byte ptr cs:data_452C,0
		je	loc_ret_227E		; Jump if equal
		call	sub_227F

loc_ret_227E:
		retn
sub_21B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_227F	proc	near
		mov	di,d_0000_00C1_e
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		mov	dl,10h
loc_2286:
		mov	cx,0Eh
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		add	di,42h
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		dec	dl
		jnz	loc_2286		; Jump if not zero
		mov	di,d_0000_20C1_e
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		mov	dl,10h
loc_229B:
		mov	cx,0Eh
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		add	di,42h
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		dec	dl
		jnz	loc_229B		; Jump if not zero
		retn
sub_227F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_22AA	proc	near
		mov	cs:data_44F6,0
		mov	cx,4

locloop_22B4:
		push	cx
		mov	bx,cs:data_44F6
		mov	si,cs:data_3EEB[bx]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	ax,0Bh
loc_22C4:
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		sub	si,50h
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		dec	al
		jnz	loc_22C4		; Jump if not zero
		pop	cx
		add	cs:data_44F6,2
		loop	locloop_22B4		; Loop if cx > 0

		retn
sub_22AA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_22EB	proc	near
		mov	si,cs:data_44F6
		add	si,offset data_453B
loc_22F4:
		mov	bx,cs:[si]
;*		or	bx,bx			; Zero ?
		db	 09h,0DBh		;  Fixup - byte match
		jnz	loc_22FE		; Jump if not zero
		jmpn	loc_2363
loc_22FE:
		mov	al,7
		cmp	byte ptr cs:[bx+6],0
		jg	loc_2309		; Jump if >
		inc	al
loc_2309:
		cmp	byte ptr cs:data_450C,2
		jne	loc_2313		; Jump if not equal
		add	al,2
loc_2313:
		call	sub_2E96
		mov	di,cs:[bx+2]
		mov	cx,6

locloop_231D:
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ch
		loop	locloop_231D		; Loop if cx > 0

		mov	di,cs:[bx+2]
		xor	di,2000h
		mov	cx,6

locloop_2343:
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ch
		loop	locloop_2343		; Loop if cx > 0

;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
;*		jmp	loc_22F4
		db	0E9h, 91h,0FFh		;  Fixup - byte match
loc_2363:
		mov	si,cs:data_44F6
		add	si,offset data_4533
loc_236C:
		mov	bx,cs:[si]
;*		or	bx,bx			; Zero ?
		db	 09h,0DBh		;  Fixup - byte match
		jnz	loc_2376		; Jump if not zero
		jmpn	loc_ret_23C7
loc_2376:
		mov	bp,cs:[bx+4]
		mov	di,cs:[bx+2]
		mov	cx,6

locloop_2381:
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ch
		loop	locloop_2381		; Loop if cx > 0

		mov	di,cs:[bx+2]
		xor	di,2000h
		mov	cx,6

locloop_23A7:
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ch
		loop	locloop_23A7		; Loop if cx > 0

;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
;*		jmp	loc_236C
		db	0E9h,0A5h,0FFh		;  Fixup - byte match

loc_ret_23C7:
		retn
sub_22EB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_23C8	proc	near
		mov	cx,4

locloop_23CB:
		mov	ax,[di]
		and	ax,[bp+10h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Eh
		loop	locloop_23CB		; Loop if cx > 0

		retn
sub_23C8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_23DC	proc	near
		mov	cx,3

locloop_23DF:
		mov	ax,[di]
		and	ax,[bp+18h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,[bp+18h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ch
		loop	locloop_23DF		; Loop if cx > 0

		retn
sub_23DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_23FB	proc	near
		mov	cx,8000h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_2409		; Jump if equal
		mov	cx,4000h

locloop_2409:
		loop	locloop_2409		; Loop if cx > 0

		retn
sub_23FB	endp

loc_240C:
		mov	al,6
		call	sub_38D0
		call	sub_2FFB
		mov	si,offset data_3DC5
		call	sub_2F2D
		mov	ds,cs:data_4491
		mov	es,cs:data_4491
		mov	al,0Ch
		call	sub_2E96
		mov	cs:data_4583,bp
		mov	bp,d_0000_4583_e
		mov	word ptr [bp+4],910h
		mov	bp,d_0000_4683_e
		mov	word ptr [bp+4],49Ch
		mov	al,2Bh			; '+'
		call	sub_2E1E
		call	sub_2B96
		mov	es,cs:data_4493
;*		mov	bp,bx
		db	 89h,0DDh		;  Fixup - byte match
		call	sub_2BC4
		call	sub_2A64
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match

locloop_2455:
		loop	locloop_2455		; Loop if cx > 0

		mov	byte ptr cs:data_4528,0C0h
		mov	cx,5
loc_2460:
		push	cx
		mov	dl,cs:data_4528
loc_2466:
		call	sub_2F4C
		and	al,7
;*		mov	cl,al
		db	 88h,0C1h		;  Fixup - byte match
		mov	dh,1
		shl	dh,cl			; Shift w/zeros fill
		test	dh,dl
		jnz	loc_2466		; Jump if not zero
;*		or	dl,dh
		db	 08h,0F2h		;  Fixup - byte match
		mov	cs:data_4528,dl
		mov	cs:data_4527,al
		mov	cs:data_4500,0
		mov	bx,4583h
		mov	si,cs:data_4587
		add	si,0Bh
		mov	al,cs:data_4527
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		cbw				; Convrt byte to word
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
loc_249F:
		inc	cs:data_4500
		mov	bp,cs:data_4583
		mov	cx,cs:data_4500
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2D1D
		mov	bp,cs:data_4583
		add	bp,20h
		mov	cx,cs:data_4500
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2D1D
		sub	si,50h
		mov	cx,4448h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_24DA		; Jump if equal
		mov	cx,2224h

locloop_24DA:
		loop	locloop_24DA		; Loop if cx > 0

		call	sub_2A85
		cmp	cs:data_4500,8
		jb	loc_249F		; Jump if below
		add	si,50h
		push	si
;*		mov	bp,si
		db	 89h,0F5h		;  Fixup - byte match
		add	si,144h
		call	sub_2B03
;*		mov	si,bp
		db	 89h,0EEh		;  Fixup - byte match
		sub	si,0F0h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	al,0Dh
		call	sub_2E96
		call	sub_2BE8
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2BE8
		mov	cx,4448h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_251B		; Jump if equal
		mov	cx,2224h

locloop_251B:
		loop	locloop_251B		; Loop if cx > 0

;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	al,0Eh
		call	sub_2E96
		call	sub_2BE8
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2BE8
		mov	cx,4448h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_253E		; Jump if equal
		mov	cx,2224h

locloop_253E:
		loop	locloop_253E		; Loop if cx > 0

;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	al,0Dh
		call	sub_2E96
		call	sub_2BE8
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2BE8
		mov	cx,4448h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_2561		; Jump if equal
		mov	cx,2224h

locloop_2561:
		loop	locloop_2561		; Loop if cx > 0

		add	si,0F4h
		call	sub_2B03
		add	si,141h
		mov	al,0Bh
		call	sub_2E96
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2AB0
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2AB0
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match
		mov	si,d_0000_3DD6_e
		call	sub_2F2D
		call	sub_2A85
		pop	si
		pop	cx
		dec	cx
		jcxz	loc_2603		; Jump if cx=0
		push	cx
		dec	cs:data_4500
loc_2597:
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	bp,cs:data_4583
		mov	cx,cs:data_4500
		call	sub_2D1D
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		mov	bp,cs:data_4583
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		add	bp,20h
		mov	cx,cs:data_4500
		call	sub_2D1D
		add	si,50h
		mov	cx,4448h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_25DF		; Jump if equal
		mov	cx,2224h

locloop_25DF:
		loop	locloop_25DF		; Loop if cx > 0

		call	sub_2A85
		dec	cs:data_4500
		jnz	loc_2597		; Jump if not zero
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		pop	cx
		jmp	loc_2460
loc_2603:
		mov	al,cs:data_4528
;*		xor	ah,ah			; Zero register
		db	 30h,0E4h		;  Fixup - byte match
loc_2609:
		inc	ah
		ror	al,1			; Rotate
		test	al,1
		jnz	loc_2609		; Jump if not zero
		and	ah,7
		mov	cs:data_4528,ah
		mov	es,cs:data_4491
;*		mov	cx,si
		db	 89h,0F1h		;  Fixup - byte match
		sub	cx,6E0h
		sub	cl,9
loc_2627:
		push	cx
		dec	si
		mov	bp,cs:data_4583
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2D1A
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2D1A
		push	si
		call	sub_2A64
		mov	es,cs:data_4493
		call	sub_2ACE
		pop	si
		pop	cx
		dec	cx
		jcxz	loc_2676		; Jump if cx=0
		push	cx
		mov	es,cs:data_4491
		mov	ds,cs:data_448F
		call	sub_2B03
		mov	ds,cs:data_4491
		mov	cx,2224h
		cmp	byte ptr cs:data_44C6,0
		je	locloop_266E		; Jump if equal
		mov	cx,1112h

locloop_266E:
		loop	locloop_266E		; Loop if cx > 0

		call	sub_2A85
		pop	cx
		jmp	short loc_2627
loc_2676:
		mov	cx,10h
loc_2679:
		push	cx
		mov	dl,0C0h
		mov	bx,0FFFFh
loc_267F:
		call	sub_2F4C
		and	al,7
;*		mov	cl,al
		db	 88h,0C1h		;  Fixup - byte match
		mov	dh,1
		shl	dh,cl			; Shift w/zeros fill
		test	dh,dl
		jnz	loc_267F		; Jump if not zero
		shl	dh,1			; Shift w/zeros fill
		test	dh,dl
		jnz	loc_267F		; Jump if not zero
		shr	dh,1			; Shift w/zeros fill
		shr	dh,1			; Shift w/zeros fill
		test	dh,dl
		jnz	loc_267F		; Jump if not zero
		mov	dh,1
		shl	dh,cl			; Shift w/zeros fill
;*		or	dl,dh
		db	 08h,0F2h		;  Fixup - byte match
;*		mov	bh,bl
		db	 88h,0DFh		;  Fixup - byte match
;*		mov	bl,al
		db	 88h,0C3h		;  Fixup - byte match
		cmp	bh,0FFh
		je	loc_267F		; Jump if equal
		mov	ax,cs
		mov	es,ax
;*		mov	al,bl
		db	 88h,0D8h		;  Fixup - byte match
		mov	di,offset data_4502
		mov	cx,2
		mov	dl,cs:data_4528

locloop_26BC:
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		inc	ah
		mov	cs:[di+2],ah
		stosb				; Store al to es:[di]
;*		cmp	dl,al
		db	 38h,0C2h		;  Fixup - byte match
		jnz	loc_26CE		; Jump if not zero
		inc	cs:data_4528
loc_26CE:
;*		cmp	dl,ah
		db	 38h,0E2h		;  Fixup - byte match
		jnz	loc_26D7		; Jump if not zero
		dec	cs:data_4528
loc_26D7:
;*		mov	al,bh
		db	 88h,0F8h		;  Fixup - byte match
		loop	locloop_26BC		; Loop if cx > 0

		mov	cs:data_44FE,1
loc_26E2:
		mov	si,offset data_4502
		mov	cx,2
		mov	es,cs:data_4491

locloop_26ED:
		push	cx
		mov	ds,cs:data_448F
		lods	byte ptr cs:[si]	; String [si] to al
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		push	si
		mov	si,cs:data_44FE
		dec	si
		add	si,830h
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
;*		mov	bp,ax
		db	 89h,0C5h		;  Fixup - byte match
		call	sub_2B03
		pop	si
		mov	al,cs:[si+1]
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		push	si
		mov	bx,cs:data_44FE
		dec	bx
;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
		neg	si
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		add	si,cs:data_406F[bx]
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
		add	si,830h
		call	sub_2B03
		mov	ds,cs:data_4491
		mov	si,830h
		add	si,cs:data_44FE
;*		add	si,bp
		db	 01h,0EEh		;  Fixup - byte match
		mov	ax,ds
		mov	es,ax
		mov	al,0Bh
		call	sub_2E96
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2AB0
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2AB0
		pop	si
		pop	cx
		loop	locloop_26ED		; Loop if cx > 0

		mov	cx,2

locloop_2763:
		push	cx
		lods	byte ptr cs:[si]	; String [si] to al
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		push	si
		mov	si,830h
		mov	bx,cs:data_44FE
;*		sub	si,bx
		db	 29h,0DEh		;  Fixup - byte match
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		add	si,cs:data_406F[bx]
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
		mov	al,0Bh
		call	sub_2E96
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2AB0
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2AB0
		pop	si
		pop	cx
		loop	locloop_2763		; Loop if cx > 0

		mov	es,cs:data_4493
		call	sub_2ACE
		mov	cx,cs:data_4516

locloop_27A6:
		loop	locloop_27A6		; Loop if cx > 0

		inc	byte ptr cs:data_44FE
		cmp	byte ptr cs:data_44FE,8
		ja	loc_27B8		; Jump if above
		jmp	loc_26E2
loc_27B8:
		pop	cx
		dec	cx
		jz	loc_27BF		; Jump if zero
		jmp	loc_2679
loc_27BF:
		mov	si,3DE6h
		cmp	byte ptr cs:data_448B,0
		je	loc_27CD		; Jump if equal
		mov	si,d_0000_3E32_e
loc_27CD:
		call	sub_2F2D
		call	sub_38B0
		mov	byte ptr cs:data_44C3,10h
		mov	byte ptr cs:data_452A,10h
		mov	byte ptr cs:data_44C2,3Ch	; '<'
		mov	al,8
		call	sub_38D0
		mov	bp,d_0000_4683_e
		mov	al,2Fh			; '/'
		call	sub_2E1E
		mov	si,496h
		mov	al,5
loc_27F7:
		push	si
		mov	cs:data_4529,al
		mov	ds,cs:data_448F
		mov	es,cs:data_4491
		mov	bp,d_0000_4683_e
		call	sub_2BC4
		mov	ds,cs:data_4491
		pop	si
		mov	[bp+4],si
		call	sub_2B96
		call	sub_2A64
		mov	es,cs:data_4493
		call	sub_2ACE
		mov	es,cs:data_4491
loc_2828:
		mov	cx,4000h

locloop_282B:
		loop	locloop_282B		; Loop if cx > 0

		call	sub_23FB
		mov	al,cs:data_44C3
		cmp	cs:data_452A,al
		je	loc_2843		; Jump if equal
		mov	cs:data_452A,al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_2864		; Jump if zero
loc_2843:
		call	sub_2A85
		cmp	byte ptr cs:data_448B,0
		jne	loc_2859		; Jump if not equal
		cmp	byte ptr cs:data_44B7,30h	; '0'
		jne	loc_2864		; Jump if not equal
		jmp	loc_2A0C
loc_2859:
		test	byte ptr cs:data_449B+1,1
		jnz	loc_2864		; Jump if not zero
		jmp	loc_2A0C
loc_2864:
		mov	si,offset data_3E84
		call	sub_2F2D
		mov	al,cs:data_4529
		cmp	cs:data_4528,al
		jne	loc_2878		; Jump if not equal
		jmp	loc_29AF
loc_2878:
		mov	ax,cs
		mov	ds,ax
		mov	es,ax
		mov	di,data_448F
		mov	bp,data_4683_e
;*		sub	di,ax
		db	 29h,0C7h		;  Fixup - byte match
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		push	di
		mov	si,ds:data_4683_e
		mov	data_4512,si
		mov	cx,80h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		mov	al,37h			; '7'
		call	sub_2E1E
		pop	di
		mov	si,ds:data_4683_e
		mov	ds:data_4685_e,di
		add	di,100h
		mov	data_4514,si
		add	si,100h
		mov	cx,80h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		mov	si,data_4514
		mov	di,ds:data_4685_e
		mov	ds:data_4683_e,di
		mov	bx,data_003E_e
		mov	bp,4683h
		mov	ds,cs:data_4491
		mov	es,cs:data_4493
		mov	cx,8

locloop_28DB:
		mov	ch,4
loc_28DD:
		mov	ax,cs:[bx+si]
		mov	cs:[bx+di],ax
		mov	ax,cs:[bx+si+40h]
		mov	cs:[bx+di+40h],ax
		sub	bx,2
		dec	ch
		jnz	loc_28DD		; Jump if not zero
		push	bx
		push	cx
		push	bp
		push	di
		push	si
		call	sub_2B96
		pop	si
		pop	di
		pop	bp
		pop	cx
		pop	bx
		loop	locloop_28DB		; Loop if cx > 0

		call	sub_23FB
		mov	si,cs:data_4512
		mov	di,cs:data_4685_e
		mov	bx,data_0000_e
		mov	cx,8

locloop_2914:
		mov	ch,4
loc_2916:
		mov	ax,cs:[bx+si]
		mov	cs:[bx+di],ax
		mov	ax,cs:[bx+si+40h]
		mov	cs:[bx+di+40h],ax
		add	bx,2
		dec	ch
		jnz	loc_2916		; Jump if not zero
		push	bx
		push	cx
		push	bp
		push	di
		push	si
		call	sub_2B96
		pop	si
		pop	di
		pop	bp
		pop	cx
		pop	bx
		loop	locloop_2914		; Loop if cx > 0

		mov	si,cs:data_4512
		mov	[bp],si
		call	sub_2B96
		call	sub_2A64
		mov	si,3C91h
		mov	dx,1212h
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		call	sub_2C3E
		mov	si,830h
		mov	al,cs:data_4528
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
		mov	ds,cs:data_448F
		mov	es,cs:data_4491
		call	sub_2B03
		mov	ds,cs:data_4491
		mov	es,cs:data_4493
		mov	al,9
		call	sub_38D0
		mov	cx,4

locloop_2986:
		push	cx
		push	si
		call	sub_2B03
		call	sub_23FB
		pop	si
		push	si
		mov	al,0Bh
		call	sub_2E96
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2AB0
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2AB0
		call	sub_23FB
		pop	si
		pop	cx
		loop	locloop_2986		; Loop if cx > 0

		call	sub_38B0
		jmp	short loc_29FD
loc_29AF:
		call	sub_38B0
		mov	dx,3000h
		call	sub_3150
		call	sub_3055
		mov	al,33h			; '3'
		mov	bp,d_0000_4683_e
		call	sub_2E1E
		mov	si,[bp+4]
		add	si,3C2h
		mov	ds,cs:data_448F
		call	sub_2B03
		mov	ds,cs:data_4491
		call	sub_2B96
		mov	es,cs:data_4493
		call	sub_2ACE
		mov	dx,110Ch
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	si,offset data_3C73
		call	sub_2C3E
		mov	dx,120Dh
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		call	sub_2C3E
loc_29FD:
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match

locloop_29FF:
		loop	locloop_29FF		; Loop if cx > 0


locloop_2A01:
		loop	locloop_2A01		; Loop if cx > 0


locloop_2A03:
		loop	locloop_2A03		; Loop if cx > 0


locloop_2A05:
		loop	locloop_2A05		; Loop if cx > 0

		push	cs
		pop	ds
		jmp	loc_0BE3
loc_2A0C:
		cmp	byte ptr cs:data_448B,0
		jne	loc_2A2E		; Jump if not equal
		call	sub_32C2
		cmp	byte ptr cs:data_44B1,bl
		jb	loc_2A22		; Jump if below
		mov	al,0FFh
		jmp	short loc_2A32
loc_2A22:
		mov	al,1
		cmp	byte ptr cs:data_44B5,bl
		jb	loc_2A32		; Jump if below
		jmp	loc_2828
loc_2A2E:
		mov	al,cs:data_4691_e
loc_2A32:
		cmp	al,0
		jne	loc_2A39		; Jump if not equal
		jmp	loc_2828
loc_2A39:
		mov	al,cs:data_4529
		mov	si,cs:data_4687_e
		jg	loc_2A53		; Jump if >
		dec	al
		jge	loc_2A4D		; Jump if > or =
		add	si,30h
		mov	al,5
loc_2A4D:
		sub	si,8
		jmp	loc_27F7
loc_2A53:
		cmp	al,5
		jb	loc_2A5C		; Jump if below
		sub	si,30h
		mov	al,0FFh
loc_2A5C:
		add	si,8
		inc	al
		jmp	loc_27F7

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2A64	proc	near
		mov	cx,6
		mov	si,828h

locloop_2A6A:
		push	cx
		mov	al,0Bh
		call	sub_2E96
		add	si,8
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2AB0
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2AB0
		pop	cx
		loop	locloop_2A6A		; Loop if cx > 0

		retn
sub_2A64	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2A85	proc	near
loc_2A85:
		cmp	byte ptr cs:data_44C1,0
		jne	loc_2A85		; Jump if not equal
		cmp	byte ptr cs:data_4488,0
		je	loc_2A9E		; Jump if equal
		mov	byte ptr cs:data_4488,0
		jmp	loc_0913
loc_2A9E:
		cmp	byte ptr cs:data_4487,0
		je	loc_ret_2AAF		; Jump if equal
		mov	byte ptr cs:data_4487,0
		jmp	loc_0BE3

loc_ret_2AAF:
		retn
sub_2A85	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2AB0	proc	near
		mov	cx,8

locloop_2AB3:
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	al,[di]
		and	al,[bp+30h]
		or	al,[bp]
		stosb				; Store al to es:[di]
		inc	bp
		add	di,4Dh
		loop	locloop_2AB3		; Loop if cx > 0

		retn
sub_2AB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2ACE	proc	near
		mov	si,d_0000_0460_e
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	al,18h
loc_2AD5:
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		sub	si,50h
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	cx,28h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]
		xor	si,2000h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		dec	al
		jnz	loc_2AD5		; Jump if not zero
		retn
sub_2ACE	endp

			                        ;* No entry point to code
		add	si,830h
		mov	cx,6

locloop_2AFA:
		call	sub_2B03
		add	si,8
		loop	locloop_2AFA		; Loop if cx > 0

		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2B03	proc	near
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,4Ch
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		retn
sub_2B03	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2B96	proc	near
		mov	si,[bp+4]
;*		mov	bx,bp
		db	 89h,0EBh		;  Fixup - byte match
;*		mov	bp,cs:[bx+0]
		db	 2Eh, 8Bh, 6Fh, 00h	;  Fixup - byte match
		db	 89h,0F7h,0E8h, 5Bh, 01h, 89h
		db	0F7h, 81h,0F7h, 00h, 20h,0E8h
		db	 52h, 01h, 81h,0C6h, 80h, 02h
		db	 81h,0C5h, 80h, 00h, 89h,0F7h
		db	0E8h, 45h, 01h, 89h,0F7h, 81h
		db	0F7h, 00h, 20h,0E8h, 3Ch, 01h
		db	0C3h

;==== External Entry into Subroutine ======================================

sub_2BC4:
		mov	si,[bp+4]
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2C6A
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2C6A
		add	si,280h
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_2C6A
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_2C6A
		retn
sub_2B96	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2BE8	proc	near
		mov	cx,0Bh

locloop_2BEB:
		mov	ax,[di]
		and	ax,ss:data_00B0_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,ss:data_00B0_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,ss:data_00B0_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,ss:data_00B0_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,48h
		loop	locloop_2BEB		; Loop if cx > 0

		retn
sub_2BE8	endp

loc_2C21:
		push	cs
		pop	ds
		call	sub_38B0
		cli				; Disable interrupts
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		mov	es,ax
		mov	data_0472,1234h
;*		jmp	far ptr l_FFFF_0000	;*
		db	0EAh
		dw	0, 0FFFFh		;  Fixup - byte match
			                        ;* No entry point to code
		mov	si,offset data_3BF8	; ('')
		call	sub_2C3E
		jmp	short loc_2C21

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C3E	proc	near
loc_2C3E:
		lods	byte ptr cs:[si]	; String [si] to al
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_ret_2C69		; Jump if zero
		cmp	al,7
		ja	loc_2C4E		; Jump if above
		mov	cs:data_44C5,al
		jmp	short loc_2C3E
loc_2C4E:
		cmp	al,0FFh
		jne	loc_2C5E		; Jump if not equal
		lods	word ptr cs:[si]	; String [si] to ax
;*		mov	dx,ax
		db	 89h,0C2h		;  Fixup - byte match
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		jmp	short loc_2C3E
loc_2C5E:
		mov	ah,0Eh
		mov	bl,cs:data_44C5
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		jmp	short loc_2C3E

loc_ret_2C69:
		retn
sub_2C3E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2C6A	proc	near
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		add	di,48h
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		mov	ax,[di]
		stosw				; Store ax to es:[di]
		retn
sub_2C6A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2CE0	proc	near
		push	bp
		push	bx
		push	cx
;*		mov	bx,bp
		db	 89h,0EBh		;  Fixup - byte match
;*		mov	bp,cs:[bx+0]
		db	 2Eh, 8Bh, 6Fh, 00h	;  Fixup - byte match
		db	 2Eh, 8Bh, 7Fh, 04h, 89h,0FEh
		db	0E8h, 0Dh, 00h, 89h,0F7h, 81h
		db	0F7h, 00h, 20h,0E8h, 04h, 00h
		db	 59h, 5Bh, 5Dh,0C3h,0B9h, 08h
		db	 00h

locloop_2D02:
		mov	dl,4
loc_2D04:
		mov	ax,[di]
		and	ax,ss:PSP_cmd_size[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		dec	dl
		jnz	loc_2D04		; Jump if not zero
		add	di,48h
		loop	locloop_2D02		; Loop if cx > 0

		retn
sub_2CE0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D1A	proc	near
		mov	cx,8

;==== External Entry into Subroutine ======================================

sub_2D1D:

locloop_2D1D:
		mov	ax,[di]
		and	ax,[bp+40h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,[bp+40h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ch
		loop	locloop_2D1D		; Loop if cx > 0

		retn
sub_2D1A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D39	proc	near
		mov	cx,0Bh

locloop_2D3C:
		mov	ax,[di]
		and	ax,ss:data_0084_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,ss:data_0084_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		mov	ax,[di]
		and	ax,ss:data_0084_e[bp]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		add	di,4Ah
		loop	locloop_2D3C		; Loop if cx > 0

		retn
sub_2D39	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read data file, INPUT: CS:SI[0] = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes

sub_2D66	proc	near
		push	ds
		push	cs
		pop	ds
		lodsb				; String [si] to al
		call	sub_0503		; Read data file, INPUT: AL = section of data, ES:BX = buffer address, OUTPUT: DX = number of bytes
		pop	ds
		retn
sub_2D66	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2D6F	proc	near
		mov	ax,cs:data_44AF
;*		mov	bx,ax
		db	 89h,0C3h		;  Fixup - byte match
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
;*		mov	bl,bh
		db	 88h,0FBh		;  Fixup - byte match
		and	bh,1
		ror	bh,1			; Rotate
		ror	bh,1			; Rotate
		ror	bh,1			; Rotate
;*		or	ah,bh
		db	 08h,0FCh		;  Fixup - byte match
		mov	al,2Ah			; '*'
		test	bl,2
		jz	loc_2D8D		; Jump if zero
		or	al,4
loc_2D8D:
		test	bl,4
		jz	loc_2D94		; Jump if zero
		or	al,10h
loc_2D94:
		mov	dx,3D8h
		out	dx,al			; port 3D8h, CGA video control
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		inc	dx
		out	dx,al			; port 3D9h, CGA color control
		cmp	byte ptr cs:data_44C6,0
		jne	loc_2DA5		; Jump if not equal
		retn
loc_2DA5:
		mov	ax,1000h
		mov	bl,0
		mov	bh,byte ptr cs:data_44AF
		and	bh,7
		int	10h			; Video display   ah=functn 10h
						;  set palette reg bl, bh=color
		retn
sub_2D6F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2DB5	proc	near
		mov	si,d_0000_4012_e
;*		xor	di,di			; Zero register
		db	 31h,0FFh		;  Fixup - byte match
		mov	es,cs:data_448F
		mov	ds,cs:data_448F
		mov	al,[si-11h]
		test	al,8
		jz	loc_2DEE		; Jump if zero
		jmp	short loc_2DD0
loc_2DCD:
		mov	di,d_0000_2000_e
loc_2DD0:
		lodsw				; String [si] to ax
		cmp	ax,0
		je	loc_ret_2DF3		; Jump if equal
		cmp	ax,0FFFFh
		je	loc_2DCD		; Jump if equal
;*		mov	cx,ax
		db	 89h,0C1h		;  Fixup - byte match
		test	ah,80h
		jnz	loc_2DE6		; Jump if not zero
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		jmp	short loc_2DD0
loc_2DE6:
		sub	ch,80h
		lodsw				; String [si] to ax
		repne	stosb			; Rep zf=0+cx >0 Store al to es:[di]
		jmp	short loc_2DD0
loc_2DEE:
		mov	cx,2000h
		repne	movsw			; Rep zf=0+cx >0 Mov [si] to es:[di]

loc_ret_2DF3:
		retn
sub_2DB5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2DF4	proc	near
		push	ax
		push	bx
;*		cmp	di,data_0006_e
		db	 81h,0FFh, 06h, 00h	;  Fixup - byte match
		jnz	loc_2DFE		; Jump if not zero
		add	al,2
loc_2DFE:
		mov	bx,data_44A5
		test	al,80h
		jz	loc_2E0A		; Jump if zero
		add	al,4
		and	al,7Fh
loc_2E0A:
		cbw				; Convrt byte to word
		cmp	[bx],ax
		jb	loc_2E1B		; Jump if below
		shl	ax,1			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	ax,[bx+si]
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
		mov	data_4573[di],ax
loc_2E1B:
		pop	bx
		pop	ax
		retn
sub_2DF4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2E1E	proc	near
		push	ax
		push	bx
		push	si
		mov	[bp+0Ah],al
		mov	bx,cs:data_44A1
		test	al,80h
		jz	loc_2E34		; Jump if zero
		mov	bx,cs:data_44A3
		and	al,7Fh
loc_2E34:
		cbw				; Convrt byte to word
		cmp	cs:[bx],ax
		jb	loc_2E4F		; Jump if below
		shl	ax,1			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	ax,cs:[bx+si]
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
		mov	[bp],ax
		mov	ax,cs:[bx+si+2]
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
		mov	[bp+2],ax
loc_2E4F:
		pop	si
		pop	bx
		pop	ax
		retn
sub_2E1E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2E53	proc	near
		push	ax
		push	bx
		push	si
		mov	bx,data_47C3_e
		test	al,80h
		jz	loc_2E64		; Jump if zero
		mov	bx,cs:data_449F
		and	al,7Fh
loc_2E64:
		cbw				; Convrt byte to word
		cmp	cs:[bx],ax
		jb	loc_2E76		; Jump if below
		shl	ax,1			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	ax,cs:[bx+si]
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
		mov	[bp],ax
loc_2E76:
		pop	si
		pop	bx
		pop	ax
		retn
sub_2E53	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2E7A	proc	near
		mov	bx,data_44A7
		test	al,80h
		jz	loc_2E88		; Jump if zero
		mov	bx,data_44A9
		and	al,7Fh
loc_2E88:
		cbw				; Convrt byte to word
		cmp	[bx],ax
		jb	loc_ret_2E95		; Jump if below
		shl	ax,1			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	si,[bx+si]
;*		add	si,bx
		db	 01h,0DEh		;  Fixup - byte match

loc_ret_2E95:
		retn
sub_2E7A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2E96	proc	near
		push	ax
		push	bx
		push	si
		mov	bx,cs:data_44AB
		cbw				; Convrt byte to word
		cmp	cs:[bx],ax
		jb	loc_2EAF		; Jump if below
		shl	ax,1			; Shift w/zeros fill
;*		mov	si,ax
		db	 89h,0C6h		;  Fixup - byte match
		mov	ax,cs:[bx+si]
;*		add	ax,bx
		db	 01h,0D8h		;  Fixup - byte match
;*		mov	bp,ax
		db	 89h,0C5h		;  Fixup - byte match
loc_2EAF:
		pop	si
		pop	bx
		pop	ax
		retn
sub_2E96	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2EB3	proc	near
		push	di
		mov	di,cs:[bx]
		mov	cs:[si],di
		mov	di,word ptr cs:data_4530+1
		mov	word ptr cs:data_4530+1,bx
		mov	cs:[bx],di
		pop	di
		retn
sub_2EB3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2EC9	proc	near
		push	cx
;*		mov	bp,sp
		db	 89h,0E5h		;  Fixup - byte match
;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
;*		mov	di,dx
		db	 89h,0D7h		;  Fixup - byte match
		lodsw				; String [si] to ax
		stosw				; Store ax to es:[di]
;*		mov	cx,ax
		db	 89h,0C1h		;  Fixup - byte match

locloop_2ED4:
		lodsw				; String [si] to ax
		stosw				; Store ax to es:[di]
		push	cx
		push	dx
		push	di
		push	si
;*		mov	si,bx
		db	 89h,0DEh		;  Fixup - byte match
;*		mov	di,dx
		db	 89h,0D7h		;  Fixup - byte match
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		mov	al,[bp]
		dec	al
		cbw				; Convrt byte to word
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		mov	cx,[bp]
loc_2EED:
		lodsb				; String [si] to al
		call	word ptr data_4499
		mov	[di],dl
		dec	di
		dec	cl
		jnz	loc_2EED		; Jump if not zero
		mov	cl,[bp]
;*		mov	al,cl
		db	 88h,0C8h		;  Fixup - byte match
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
;*		add	di,ax
		db	 01h,0C7h		;  Fixup - byte match
		dec	ch
		jnz	loc_2EED		; Jump if not zero
		pop	si
		pop	di
		pop	dx
		pop	cx
		loop	locloop_2ED4		; Loop if cx > 0

		pop	cx
		retn
sub_2EC9	endp

		db	 50h,0D0h,0C0h,0D0h,0C0h, 24h
		db	 33h, 88h,0C2h, 58h,0D0h,0C8h
		db	0D0h,0C8h, 24h,0CCh, 08h,0C2h
		db	0C3h,0D0h,0C0h,0D0h,0C0h,0D0h
		db	0C0h,0D0h,0C0h, 88h,0C2h,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2F2D	proc	near
		push	ax
		push	bx
		push	dx
		push	ds
		push	cs
		pop	ds
		lodsw				; String [si] to ax
;*		mov	dx,ax
		db	 89h,0C2h		;  Fixup - byte match
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		call	sub_2C3E
		pop	ds
		pop	dx
		pop	bx
		pop	ax
		retn
sub_2F2D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2F44	proc	near
		mov	bx,7
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		retn
sub_2F44	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2F4C	proc	near
		mov	ax,cs:data_449D
		push	ax
		and	ax,0D598h
		jnp	loc_2F57		; Jump if not parity
		stc				; Set carry flag
loc_2F57:
		rcl	cs:data_449D,1		; Rotate thru carry
		pop	ax
		retn
sub_2F4C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2F5E	proc	near
		cmp	cs:data_4450,32EAh
		je	loc_2FAB		; Jump if equal
		push	di
		mov	cs:data_44C3,al
		mov	di,cs:data_35AB
loc_2F71:
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_2F81		; Jump if zero
		cmp	byte ptr cs:data_44C3,0
		jne	loc_2F81		; Jump if not equal
;*		xor	al,al			; Zero register
		db	 30h,0C0h		;  Fixup - byte match
		jmp	short loc_2FA9
loc_2F81:
		cmp	byte ptr cs:data_448B,0
		jne	loc_2F95		; Jump if not equal
		cmp	byte ptr cs:data_44B7,30h	; '0'
		je	loc_2F95		; Jump if equal
		mov	al,39h			; '9'
		jmp	short loc_2FA9
loc_2F95:
		cmp	di,cs:data_35AD
		je	loc_2F71		; Jump if equal
		mov	al,data_35AF[di]
		inc	di
		and	di,0Fh
		mov	cs:data_35AB,di
loc_2FA9:
		pop	di
		retn
loc_2FAB:
		mov	al,13h
		retn
sub_2F5E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2FAE	proc	near
		mov	ah,6
;*		xor	al,al			; Zero register
		db	 30h,0C0h		;  Fixup - byte match
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match
		mov	dx,1850h
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		int	10h			; Video display   ah=functn 06h
						;  scroll up, al=lines
						;   bh=attrib, cx+dx=window size
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		retn
sub_2FAE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2FC4	proc	near
		push	ds
		push	es
		push	cs
		push	cs
		pop	ds
		pop	es
		call	sub_3055
		mov	al,data_44C0
		mov	di,offset data_44D6
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_2FDA		; Jump if zero
		add	di,0Fh
loc_2FDA:
		mov	si,offset data_44C7
		mov	cx,0Fh
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jz	loc_2FE9		; Jump if zero
		mov	di,44D6h
loc_2FE9:
;*		mov	si,di
		db	 89h,0FEh		;  Fixup - byte match
		mov	di,offset data_44C7
		mov	cx,0Fh
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		xor	byte ptr data_44C0,1
		pop	es
		pop	ds
		retn
sub_2FC4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_2FFB	proc	near
		cmp	byte ptr cs:data_448C,1
		jne	loc_3017		; Jump if not equal
		mov	si,44D7h
		cmp	byte ptr cs:data_44C0,0
		jne	loc_3011		; Jump if not equal
		mov	si,offset data_44E6
loc_3011:
		call	sub_30D7
		call	sub_301D
loc_3017:
		mov	si,offset data_44C8
		call	sub_30D7

;==== External Entry into Subroutine ======================================

sub_301D:
		mov	byte ptr cs:data_451C,0
		mov	dx,cs:[si+6]
		mov	dh,6
		mov	cx,4
loc_302C:
		mov	al,cs:[si]
		shr	al,cl			; Shift w/zeros fill
		and	al,0Fh
		call	sub_30AE
		add	cl,4
		and	cl,4
		jcxz	loc_303F		; Jump if cx=0
		inc	si
loc_303F:
		inc	dl
		dec	dh
		jnz	loc_302C		; Jump if not zero
		cmp	byte ptr cs:data_451C,0
		jne	loc_ret_3054		; Jump if not equal
		dec	dl
		mov	al,0
		call	sub_30BB

loc_ret_3054:
		retn
sub_2FFB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3055	proc	near
		mov	byte ptr cs:data_451C,0
		mov	dx,cs:data_44CE
		mov	si,offset data_44C8
		mov	dh,6
		mov	cx,4
loc_3068:
		mov	al,cs:[si]
		mov	ah,cs:[si+3]
		shr	al,cl			; Shift w/zeros fill
		shr	ah,cl			; Shift w/zeros fill
		and	al,0Fh
		and	ah,0Fh
;*		cmp	al,ah
		db	 38h,0E0h		;  Fixup - byte match
		jz	loc_307F		; Jump if zero
		call	sub_30AE
loc_307F:
		add	cl,4
		and	cl,4
		jcxz	loc_3088		; Jump if cx=0
		inc	si
loc_3088:
		inc	dl
		dec	dh
		jnz	loc_3068		; Jump if not zero
		cmp	byte ptr cs:data_451C,0
		jne	loc_309D		; Jump if not equal
		dec	dl
		mov	al,0
		call	sub_30BB
loc_309D:
		mov	ax,cs:data_44C8
		mov	word ptr cs:data_44CA+1,ax
		mov	al,byte ptr cs:data_44CA
		mov	byte ptr cs:data_44CC+1,al
		retn
sub_3055	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_30AE	proc	near
;*		or	al,al			; Zero ?
		db	 08h,0C0h		;  Fixup - byte match
		jnz	loc_30BB		; Jump if not zero
		cmp	byte ptr cs:data_451C,0
		jne	loc_30BB		; Jump if not equal
		retn

;==== External Entry into Subroutine ======================================

sub_30BB:
loc_30BB:
		mov	byte ptr cs:data_451C,0FFh
		push	dx
		push	ax
;*		xor	dh,dh			; Zero register
		db	 30h,0F6h		;  Fixup - byte match
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		pop	ax
		add	al,30h			; '0'
		mov	bx,7
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		pop	dx
		retn
sub_30AE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_30D7	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	di
		push	si
		push	ds
		push	es
		mov	ds,cs:data_4493
		mov	es,cs:data_4493
		mov	al,cs:[si+8]
		cbw				; Convrt byte to word
;*		mov	cx,ax
		db	 89h,0C1h		;  Fixup - byte match
		jcxz	loc_312D		; Jump if cx=0
		cmp	cx,5
		jbe	loc_30FA		; Jump if below or =
		mov	cx,5
loc_30FA:
		mov	al,cs:[si+6]
		mov	bx,3
		shl	al,1			; Shift w/zeros fill
		dec	al
		cmp	al,1
		jne	loc_310E		; Jump if not equal
		mov	al,0Ch
		mov	bx,data_FFFD_e
loc_310E:
		cbw				; Convrt byte to word
		mov	si,140h
;*		add	si,ax
		db	 01h,0C6h		;  Fixup - byte match

locloop_3114:
		push	cx
		mov	al,5
		call	sub_2E96
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		call	sub_3136
;*		mov	di,si
		db	 89h,0F7h		;  Fixup - byte match
		xor	di,2000h
		call	sub_3136
;*		add	si,bx
		db	 01h,0DEh		;  Fixup - byte match
		pop	cx
		loop	locloop_3114		; Loop if cx > 0

loc_312D:
		pop	es
		pop	ds
		pop	si
		pop	di
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_30D7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3136	proc	near
		mov	cx,6

locloop_3139:
		mov	dl,2
loc_313B:
		mov	ax,[di]
		and	ax,[bp+30h]
		or	ax,[bp]
		stosw				; Store ax to es:[di]
		inc	bp
		inc	bp
		dec	dl
		jnz	loc_313B		; Jump if not zero
		add	di,4Ch
		loop	locloop_3139		; Loop if cx > 0

		retn
sub_3136	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3150	proc	near
		mov	al,byte ptr cs:data_44CA
;*		add	al,dl
		db	 00h,0D0h		;  Fixup - byte match
		daa				; Decimal adjust
		mov	byte ptr cs:data_44CA,al
		mov	al,byte ptr cs:data_44C8+1
;*		adc	al,dh
		db	 10h,0F0h		;  Fixup - byte match
		daa				; Decimal adjust
		mov	byte ptr cs:data_44C8+1,al
		mov	al,byte ptr cs:data_44C8
		adc	al,0
		daa				; Decimal adjust
		mov	byte ptr cs:data_44C8,al
		cmp	cs:data_44D5,al
		ja	loc_ret_31A2		; Jump if above
		mov	al,1
		cmp	byte ptr cs:data_448D,0
		je	loc_3184		; Jump if equal
		mov	al,6
loc_3184:
		add	al,cs:data_44D5
		daa				; Decimal adjust
		mov	cs:data_44D5,al
		cmp	byte ptr cs:data_44D0,9
		jae	loc_319B		; Jump if above or =
		inc	cs:data_44D0
loc_319B:
		push	cx
		push	si
		call	sub_2FFB
		pop	si
		pop	cx

loc_ret_31A2:
		retn
sub_3150	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_31A3	proc	near
		mov	byte ptr data_4489,0FFh
		call	sub_32C2
		cmp	bl,0FFh
		jb	loc_31C6		; Jump if below
		call	sub_2FAE
		mov	si,offset data_4014
		call	sub_2F2D
		mov	byte ptr data_44C3,3
loc_31BE:
		cmp	byte ptr data_44C3,0
		jne	loc_31BE		; Jump if not equal
		retn
loc_31C6:
		call	sub_2FAE
		mov	di,offset data_3EF3
		call	sub_327F
		call	sub_2F2D
		call	sub_329E
		call	sub_32C2
		mov	data_44B1,bx
		call	sub_327F
		call	sub_329E
		call	sub_32C2
		mov	data_44B3,bx
		call	sub_327F
		call	sub_329E
		call	sub_32C2
		mov	data_44B5,bx
		sub	bl,8
		jc	loc_3267		; Jump if carry Set
		sub	bh,8
		jc	loc_3267		; Jump if carry Set
		cmp	byte ptr data_44B3,bl
		ja	loc_3267		; Jump if above
		cmp	byte ptr data_44B3+1,bh
		ja	loc_3267		; Jump if above
		add	bl,8
		add	bh,8
		sub	bx,data_44B3
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	bh,1			; Shift w/zeros fill
		shr	bh,1			; Shift w/zeros fill
		sub	data_44B5,bx
		mov	bx,data_44B3
		sub	bl,8
		jc	loc_3267		; Jump if carry Set
		sub	bh,8
		jc	loc_3267		; Jump if carry Set
		cmp	byte ptr data_44B1,bl
		ja	loc_3267		; Jump if above
		cmp	byte ptr data_44B1,bh
		ja	loc_3267		; Jump if above
		add	bl,8
		add	bh,8
		sub	bx,data_44B1
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		shr	bh,1			; Shift w/zeros fill
		shr	bh,1			; Shift w/zeros fill
		add	data_44B1,bx
;*		cmp	bl,bh
		db	 38h,0FBh		;  Fixup - byte match
		ja	loc_3258		; Jump if above
;*		mov	bl,bh
		db	 88h,0FBh		;  Fixup - byte match
loc_3258:
		mov	ax,data_44B5
;*		cmp	al,ah
		db	 38h,0E0h		;  Fixup - byte match
		ja	loc_3261		; Jump if above
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
loc_3261:
;*		add	al,bl
		db	 00h,0D8h		;  Fixup - byte match
		mov	byte ptr data_4489,al
		retn
loc_3267:
		call	sub_2FAE
		mov	si,offset data_3FDE
		call	sub_2F2D
		mov	byte ptr data_44C3,3
loc_3275:
		cmp	byte ptr data_44C3,0
		jne	loc_3275		; Jump if not equal
		jmp	loc_31C6
sub_31A3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_327F	proc	near
		mov	al,[di]
		inc	di
		mov	data_44C5,al
		mov	si,offset data_3EFC
		call	sub_2F2D
		mov	al,[di]
		inc	di
		mov	data_44C5,al
		call	sub_2F2D
		mov	al,[di]
		inc	di
		mov	data_44C5,al
		call	sub_2F2D
		retn
sub_327F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_329E	proc	near
loc_329E:
		cmp	byte ptr data_4488,0
		jne	loc_32BB		; Jump if not equal
		mov	al,byte ptr data_44B7
		cmp	al,30h			; '0'
		jne	loc_329E		; Jump if not equal
loc_32AC:
		cmp	byte ptr data_4488,0
		jne	loc_32BB		; Jump if not equal
		mov	al,byte ptr data_44B7
		cmp	al,30h			; '0'
		je	loc_32AC		; Jump if equal
		retn
loc_32BB:
		mov	byte ptr data_4488,0
		pop	ax
		retn
sub_329E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_32C2	proc	near
		mov	dx,201h
		mov	bx,0
		mov	cx,cs:data_4489
		cli				; Disable interrupts
		out	dx,al			; port 201h, start game 1-shots

locloop_32CF:
		in	al,dx			; port 201h, start game 1-shots
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		shr	ah,1			; Shift w/zeros fill
		and	ah,1
		and	al,1
;*		add	bx,ax
		db	 01h,0C3h		;  Fixup - byte match
		loop	locloop_32CF		; Loop if cx > 0

		sti				; Enable interrupts
		retn
sub_32C2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_32DF	proc	near
		and	al,0Fh
		mov	ah,0Eh
		mov	bl,3
		add	al,30h			; '0'
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		retn
sub_32DF	endp

			                        ;* No entry point to code
		push	ax
		push	bx
		push	cx
		push	dx
		push	di
		push	ds
		push	es
		push	cs
		push	cs
		pop	es
		pop	ds
		cmp	byte ptr data_444F,0
		je	loc_32FF		; Jump if equal
		jmp	loc_3465
loc_32FF:
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
		in	al,60h			; port 60h, keybd scan or sw1
		test	al,80h
		jnz	loc_336C		; Jump if not zero
		cmp	al,53h			; 'S'
		jne	loc_3311		; Jump if not equal
		mov	bx,2C21h
		jmp	loc_352B
loc_3311:
		cmp	al,46h			; 'F'
		jne	loc_331B		; Jump if not equal
		mov	bx,913h
		jmp	loc_352B
loc_331B:
		cmp	al,3Ch			; '<'
		jne	loc_3325		; Jump if not equal
		mov	bx,0BE3h
		jmp	loc_352B
loc_3325:
		cmp	al,0Fh
		jne	loc_3342		; Jump if not equal
		mov	dx,3D4h
		mov	al,2
		out	dx,al			; port 3D4h, CGA/EGA reg index
						;  al = 2, horz sync position
		inc	dx
		mov	al,data_44BF
		dec	al
		cmp	al,2Ah			; '*'
		jae	loc_333B		; Jump if above or =
		mov	al,2Eh			; '.'
loc_333B:
		mov	data_44BF,al
		out	dx,al			; port 3D5h, CGA/EGA indxd data
		jmp	loc_3465
loc_3342:
		mov	di,offset data_3557
		mov	cx,0Fh
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_3369		; Jump if cx=0
		mov	bx,data_000E_e
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		stc				; Set carry flag
		rcl	dx,cl			; Rotate thru carry
		test	dx,data_449B
		jz	loc_3361		; Jump if zero
		jmp	loc_3465
loc_3361:
		or	data_449B,dx
		jmp	word ptr data_3573[bx]	;*28 entries
loc_3369:
		jmp	loc_347D
loc_336C:
		and	al,7Fh
		cmp	al,46h			; 'F'
		jne	loc_3375		; Jump if not equal
		jmp	loc_3465
loc_3375:
		cmp	al,3Ch			; '<'
		jne	loc_337C		; Jump if not equal
		jmp	loc_3465
loc_337C:
		cmp	al,0Fh
		jne	loc_3383		; Jump if not equal
		jmp	loc_3465
loc_3383:
		mov	di,offset data_3557
		mov	cx,0Fh
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_3369		; Jump if cx=0
		mov	bx,data_000E_e
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		stc				; Set carry flag
		rcl	dx,cl			; Rotate thru carry
;*		xor	dx,0FFFFh
		db	 83h,0F2h,0FFh		;  Fixup - byte match
		and	data_449B,dx
		jmp	word ptr data_3573[bx]	;*28 entries
			                        ;* No entry point to code
		push	ax
		push	bx
		push	cx
		push	dx
		push	di
		push	ds
		push	es
		push	cs
		push	cs
		pop	es
		pop	ds
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
		in	al,60h			; port 60h, keybd scan or sw1
		test	al,80h
		jnz	loc_341F		; Jump if not zero
		cmp	byte ptr data_44C1,0
		je	loc_33C7		; Jump if equal
		mov	byte ptr data_44C1,0
		jmp	loc_3465
loc_33C7:
		cmp	byte ptr data_44C4,1
		je	loc_33D9		; Jump if equal
		cmp	al,46h			; 'F'
		jne	loc_33DF		; Jump if not equal
		test	byte ptr data_449B+1,10h
		jz	loc_33DC		; Jump if zero
loc_33D9:
		mov	data_4488,al
loc_33DC:
		jmp	loc_3465
loc_33DF:
		cmp	al,0Fh
		jne	loc_33FB		; Jump if not equal
		mov	dx,3D4h
		mov	al,2
		out	dx,al			; port 3D4h, CGA/EGA reg index
						;  al = 2, horz sync position
		inc	dx
		mov	al,data_44BF
		dec	al
		cmp	al,2Ah			; '*'
		jae	loc_33F5		; Jump if above or =
		mov	al,2Eh			; '.'
loc_33F5:
		mov	data_44BF,al
		out	dx,al			; port 3D5h, CGA/EGA indxd data
		jmp	short loc_3465
loc_33FB:
		mov	di,3565h
;*		call	sub_0190		;*
		db	0E8h, 8Fh,0CDh		;  Fixup - byte match
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_344F		; Jump if cx=0
		mov	bx,data_000E_e
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		stc				; Set carry flag
		rcl	dx,cl			; Rotate thru carry
		test	dx,data_449B
		jnz	loc_3465		; Jump if not zero
		or	data_449B,dx
		jmp	word ptr data_3573[bx]	;*28 entries
loc_341F:
		and	al,7Fh
		cmp	al,46h			; 'F'
		je	loc_3465		; Jump if equal
		cmp	al,3Ch			; '<'
		je	loc_3465		; Jump if equal
		cmp	al,0Fh
		je	loc_3465		; Jump if equal
		mov	di,offset data_3565
		mov	cx,0Fh
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_3465		; Jump if cx=0
		mov	bx,data_000E_e
;*		sub	bx,cx
		db	 29h,0CBh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		stc				; Set carry flag
		rcl	dx,cl			; Rotate thru carry
;*		xor	dx,0FFFFh
		db	 83h,0F2h,0FFh		;  Fixup - byte match
		and	data_449B,dx
		jmp	word ptr data_3573[bx]	;*28 entries
loc_344F:
		mov	di,data_35AD
		mov	data_35AF[di],al
		inc	di
		and	di,0Fh
		cmp	data_35AB,di
		je	loc_3465		; Jump if equal
		mov	data_35AD,di

;===== Indexed Entry Point ================================================

loc_3465:
		in	al,61h			; port 61h, 8255 port B, read
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	es
		pop	ds
		pop	di
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		iret				; Interrupt return
loc_347D:
		pop	es
		pop	ds
		pop	di
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		pushf				; Push flags
		call	dword ptr cs:data_4452
		iret				; Interrupt return

;===== Indexed Entry Point ================================================

loc_348B:
		cmp	byte ptr data_448B,0
		je	loc_3465		; Jump if equal
		mov	byte ptr data_4521,1
		jmp	short loc_3465

;===== Indexed Entry Point ================================================

loc_3499:
		cmp	byte ptr data_448B,0
		je	loc_3465		; Jump if equal
		mov	byte ptr ds:data_4691_e,1
		jmp	short loc_3465

;===== Indexed Entry Point ================================================

loc_34A7:
		cmp	byte ptr data_448B,0
		je	loc_3465		; Jump if equal
		cmp	byte ptr ds:data_4691_e,1
		jne	loc_3465		; Jump if not equal
		test	byte ptr data_44C4,80h
		jnz	loc_3465		; Jump if not zero
		mov	byte ptr ds:data_4691_e,0
		jmp	short loc_3465

;===== Indexed Entry Point ================================================

loc_34C3:
		cmp	byte ptr data_448B,0
		je	loc_34CF		; Jump if equal
		mov	byte ptr ds:data_4691_e,0FFh
loc_34CF:
;*		jmp	loc_3465
		db	0E9h, 93h,0FFh		;  Fixup - byte match

;===== Indexed Entry Point ================================================

loc_34D2:
		cmp	byte ptr data_448B,0
		je	loc_34EC		; Jump if equal
		cmp	byte ptr ds:data_4691_e,0FFh
		jne	loc_34EC		; Jump if not equal
		test	byte ptr data_44C4,80h
		jnz	loc_34EC		; Jump if not zero
		mov	byte ptr ds:data_4691_e,0
loc_34EC:
		jmp	loc_3465

;===== Indexed Entry Point ================================================

loc_34EF:
		cmp	al,1Eh
		jne	loc_34FD		; Jump if not equal
		cmp	byte ptr data_44C4,0FFh
		jne	loc_34FD		; Jump if not equal
		jmp	loc_344F
loc_34FD:
		cmp	byte ptr data_448B,0
		je	loc_3509		; Jump if equal
		mov	byte ptr data_4521,0FFh
loc_3509:
		jmp	loc_3465

;===== Indexed Entry Point ================================================

loc_350C:
		call	sub_386C
		jmp	loc_3465

;===== Indexed Entry Point ================================================

loc_3512:
		mov	al,byte ptr data_449B+1
		and	al,18h
		cmp	al,18h
		je	loc_351E		; Jump if equal
		jmp	loc_3465
loc_351E:
		cmp	byte ptr data_444F,0
		je	loc_3528		; Jump if equal
		jmp	loc_3465
loc_3528:
		mov	bx,offset loc_2C21
loc_352B:
		mov	sp,data_4495		; save SP = 400h
		in	al,61h			; port 61h, 8255 port B, read
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		sti				; Enable interrupts
		jmp	bx			;*Register jump

;===== Indexed Entry Point ================================================

loc_3542:
		mov	byte ptr data_44C1,0FFh
		jmp	loc_3465

;===== Indexed Entry Point ================================================

loc_354A:
		cmp	byte ptr data_44C4,0FFh
		jne	loc_3554		; Jump if not equal
		jmp	loc_344F
loc_3554:
		jmp	loc_3465
data_3557	db	53h
		db	1Dh
		db	'8BCDPMKHPMKH'
data_3565	db	53h
		db	 1Dh, 38h, 01h, 45h, 39h, 2Ch
		db	 27h, 26h, 1Eh
		db	 50h, 4Dh, 4Bh, 48h
data_3573	dw	offset loc_3512		; Data table (indexed access)
data_3575	dw	offset loc_3465
data_3577	dw	offset loc_3465
data_3579	dw	offset loc_3465
data_357B	dw	offset loc_3465
data_357D	dw	offset loc_3465
data_357F	dw	offset loc_350C
data_3581	dw	offset loc_3465
data_3583	dw	offset loc_3542
data_3585	dw	offset loc_3465
data_3587	dw	offset loc_354A
data_3589	dw	offset loc_3465
data_358B	dw	offset loc_348B
data_358D	dw	offset loc_3465
data_358F	dw	offset loc_3499
data_3591	dw	offset loc_34A7
data_3593	dw	offset loc_34C3
data_3595	dw	offset loc_34D2
data_3597	dw	offset loc_34EF
data_3599	dw	offset loc_3465
data_359B	dw	offset loc_348B
data_359D	dw	offset loc_3465
data_359F	dw	offset loc_3499
data_35A1	dw	offset loc_34A7
data_35A3	dw	offset loc_34C3
data_35A5	dw	offset loc_34D2
data_35A7	dw	offset loc_34EF
data_35A9	dw	offset loc_3465
data_35AB	dw	0
data_35AD	dw	0
data_35AF	db	0			; Data table (indexed access)
		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_35BF	proc	near
		retn
sub_35BF	endp

			                        ;* No entry point to code
		or	[bx+si],ax
		call	sub_35CB
		call	sub_35CB
loc_35C8:
;*		jmp	loc_35C8
		db	0E9h,0FDh,0FFh		;  Fixup - byte match

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_35CB	proc	near
		push	es
		mov	ah,0
		int	13h			; Disk  dl=drive ?  ah=func 00h
						;  reset disk, al=return status
		mov	ax,201h
		mov	bx,d_0000_0000_e
		mov	es,data_4491
		mov	cx,100h
		mov	dx,0
		int	13h			; Disk  dl=drive a  ah=func 02h
						;  read sectors to memory es:bx
						;   al=#,ch=cyl,cl=sectr,dh=head
		pop	es
		mov	di,371Ah
		call	sub_3621
		jnc	loc_35EC		; Jump if carry=0
		retn
loc_35EC:
		call	sub_3621
		jnc	loc_35F2		; Jump if carry=0
		retn
loc_35F2:
		call	sub_3621
		jnc	loc_35F8		; Jump if carry=0
		retn
loc_35F8:
		mov	ax,data_371A
		cmp	ax,data_371E
		jne	loc_360B		; Jump if not equal
		mov	ax,data_371C
		cmp	ax,data_3720
		jne	loc_360B		; Jump if not equal
		retn
loc_360B:
		mov	ax,data_371A
		cmp	ax,data_3722
		je	loc_3615		; Jump if equal
		retn
loc_3615:
		mov	ax,data_371C
		cmp	ax,data_3724
		je	loc_361F		; Jump if equal
		retn
loc_361F:
		pop	ax
		retn
sub_35CB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3621	proc	near
		mov	si,offset data_372E
		call	sub_368B
		call	sub_3646
		jnc	loc_362D		; Jump if carry=0
		retn
loc_362D:
		call	sub_36CC
		jnc	loc_3633		; Jump if carry=0
		retn
loc_3633:
		cmp	byte ptr data_3726,7
		stc				; Set carry flag
		jz	loc_363C		; Jump if zero
		retn
loc_363C:
		mov	si,offset data_372A
		mov	cx,4
		repne	movsb			; Rep zf=0+cx >0 Mov [si] to es:[di]
		clc				; Clear carry flag
		retn
sub_3621	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3646	proc	near
		clc				; Clear carry flag
		cmp	byte ptr data_44C6,0
		je	loc_364F		; Jump if equal
		retn
loc_364F:
		push	ax
		push	bx
		push	cx
		push	dx
		push	ds
		sti				; Enable interrupts
		mov	bl,2
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match
		mov	ax,40h
		mov	ds,ax

locloop_365E:
		test	byte ptr ds:d_0040_003E_e,80h
		jnz	loc_366E		; Jump if not zero
		loop	locloop_365E		; Loop if cx > 0

		dec	bl
		jnz	locloop_365E		; Jump if not zero
		stc				; Set carry flag
		jmp	short loc_366F
loc_366E:
		clc				; Clear carry flag
loc_366F:
		pushf				; Push flags
		and	byte ptr ds:d_0040_003E_e,7Fh
		popf				; Pop flags
		pop	ds
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_3646	endp

			                        ;* No entry point to code
		push	ax
		push	ds
		mov	ax,40h
		mov	ds,ax
		mov	byte ptr ds:d_0040_0040_e,25h	; '%'
		pop	ds
		pop	ax
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_368B	proc	near
		push	ax
		push	cx
		push	dx
		push	si
		cld				; Clear direction
		lodsb				; String [si] to al
;*		mov	cl,al
		db	 88h,0C1h		;  Fixup - byte match
		mov	ch,0
		mov	dx,3F4h
		cmp	byte ptr data_44C6,0
		je	locloop_36A2		; Jump if equal
		mov	dx,0F4h

locloop_36A2:
		push	cx
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match

locloop_36A5:
		in	al,dx			; port 0F4h ??i/o non-standard
		test	al,40h			; '@'
		jz	loc_36B0		; Jump if zero
		loop	locloop_36A5		; Loop if cx > 0

		pop	cx
		jmpn	loc_36C6
loc_36B0:
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match

locloop_36B2:
		in	al,dx			; port 0F4h ??i/o non-standard
		test	al,80h
		jnz	loc_36BC		; Jump if not zero
		loop	locloop_36B2		; Loop if cx > 0

		pop	cx
		jmp	short loc_36C6
loc_36BC:
		lodsb				; String [si] to al
		inc	dx
		out	dx,al			; port 0F5h ??i/o non-standard
		dec	dx
		pop	cx
		loop	locloop_36A2		; Loop if cx > 0

		clc				; Clear carry flag
		jmp	short loc_36C7
loc_36C6:
		stc				; Set carry flag
loc_36C7:
		pop	si
		pop	dx
		pop	cx
		pop	ax
		retn
sub_368B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_36CC	proc	near
		push	ax
		push	bx
		push	cx
		push	dx
		push	di
		cld				; Clear direction
		mov	byte ptr data_3726,0
		mov	di,offset data_3727
		mov	bl,7
loc_36DC:
;*		xor	cx,cx			; Zero register
		db	 31h,0C9h		;  Fixup - byte match
		mov	dx,3F4h
		cmp	byte ptr data_44C6,0
		je	locloop_36EB		; Jump if equal
		mov	dx,0F4h

locloop_36EB:
		in	al,dx			; port 0F4h ??i/o non-standard
		test	al,80h
		jnz	loc_36F5		; Jump if not zero
		loop	locloop_36EB		; Loop if cx > 0

		jmpn	loc_3710
loc_36F5:
		in	al,dx			; port 0F4h ??i/o non-standard
		test	al,40h			; '@'
		jz	loc_3710		; Jump if zero
		inc	dx
		in	al,dx			; port 0F5h ??i/o non-standard
		stosb				; Store al to es:[di]
		inc	data_3726
		mov	cx,0Ah

locloop_3704:
		loop	locloop_3704		; Loop if cx > 0

		dec	dx
		in	al,dx			; port 0F4h ??i/o non-standard
		test	al,10h
		jz	loc_3713		; Jump if zero
		dec	bl
		jnz	loc_36DC		; Jump if not zero
loc_3710:
		stc				; Set carry flag
		jmp	short loc_3714
loc_3713:
		clc				; Clear carry flag
loc_3714:
		pop	di
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		retn
sub_36CC	endp

data_371A	dw	0
data_371C	dw	0
data_371E	dw	0
data_3720	dw	0
data_3722	dw	0
data_3724	dw	0
data_3726	db	0
data_3727	dw	0
		db	0
data_372A	db	0
		db	0, 0, 0
data_372E	db	2
		db	 4Ah, 00h
data_3731	dw	6 dup (0)
		db	0
data_373E	db	0
		db	12 dup (0)
data_374B	db	0
		db	12 dup (0)
		db	 50h, 53h, 51h, 52h, 56h, 57h
		db	 1Eh, 06h, 0Eh, 0Eh, 2Eh, 80h
		db	 3Eh,0C6h, 44h, 00h, 74h, 17h
		db	0B8h, 40h, 00h, 8Eh,0D8h,0F6h
		db	 06h, 18h, 00h, 08h, 74h, 0Bh
		db	 80h, 26h, 18h, 00h,0F7h, 2Eh
		db	0C6h, 06h,0C1h, 44h,0FFh, 1Fh
		db	 07h,0FAh, 80h, 3Eh, 8Ah, 44h
		db	 00h, 75h, 77h,0C6h, 06h, 8Ah
		db	 44h, 01h,0FBh,0E8h,0B8h,0F7h
		db	0BAh, 01h, 02h,0ECh, 88h,0C4h
		db	 2Eh, 86h, 26h,0B8h, 44h, 89h
		db	0C2h, 81h,0E2h, 20h, 20h, 38h
		db	0D6h, 74h, 05h, 88h,0E2h, 80h
		db	0E2h
		db	20h
loc_37AE:
;*		mov	dh,ah
		db	 88h,0E6h		;  Fixup - byte match
		and	ax,1010h
;*		cmp	al,ah
		db	 38h,0E0h		;  Fixup - byte match
		jz	loc_37BB		; Jump if zero
;*		mov	al,dh
		db	 88h,0F0h		;  Fixup - byte match
		and	al,10h
loc_37BB:
;*		or	al,dl
		db	 08h,0D0h		;  Fixup - byte match
		mov	byte ptr cs:data_44B7,al
		dec	cs:data_44C2
		jnz	loc_37DB		; Jump if not zero
		mov	byte ptr cs:data_44C2,3Ch	; '<'
		cmp	byte ptr cs:data_44C3,0
		je	loc_37DB		; Jump if equal
		dec	cs:data_44C3
loc_37DB:
		cmp	byte ptr cs:data_44C1,0
		jnz	$+2			; delay for I/O
		mov	dl,0
		mov	dh,0C0h
		mov	si,offset data_374B
		call	sub_397C
		mov	dh,0A0h
		mov	si,offset data_373E
		call	sub_397C
		mov	dh,80h
		mov	si,offset data_3731
		call	sub_397C
		mov	byte ptr data_4489+1,0
loc_3802:
		pop	es
		pop	ds
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

sub_380B	proc	near
loc_380B:
		push	ax
		cli				; Disable interrupts
		mov	byte ptr cs:data_448E,1
		call	sub_388D		; Initialize DMA-2 controller cascade cahnnel 4
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		or	al,2
		cmp	byte ptr cs:data_44C6,0
		je	loc_382C		; Jump if equal
		or	al,60h			; '`'
		and	al,0EFh
loc_382C:
		out	61h,al			; port 61h, 8255 B - spkr, etc
		sti				; Enable interrupts
		pop	ax
		retn
sub_380B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3831	proc	near
		cmp	byte ptr cs:data_44C6,0
		je	loc_380B		; Jump if equal
		push	ax
		cli				; Disable interrupts
		mov	byte ptr cs:data_448E,3
		call	sub_388D		; Initialize DMA-2 controller cascade cahnnel 4
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		or	al,2
		or	al,10h
		or	al,60h			; '`'
		out	61h,al			; port 61h, 8255 B - spkr, etc
		sti				; Enable interrupts
		pop	ax
		retn
sub_3831	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3853	proc	near
loc_3853:
		push	ax
		and	byte ptr cs:data_448E,0FEh
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FDh
		cmp	byte ptr cs:data_44C6,0
		je	loc_3868		; Jump if equal
		and	al,9Fh
loc_3868:
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		retn
sub_3853	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_386C	proc	near
		test	byte ptr cs:data_448E,1
		jnz	loc_3853		; Jump if not zero
		push	ax
		or	byte ptr cs:data_448E,1
		in	al,61h			; port 61h, 8255 port B, read
		or	al,2
		cmp	byte ptr cs:data_44C6,0
		je	loc_3889		; Jump if equal
		or	al,60h			; '`'
loc_3889:
		out	61h,al			; port 61h, 8255 B - spkr, etc
		pop	ax
		retn
sub_386C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Initialize DMA-2 controller cascade cahnnel 4

sub_388D	proc	near
		cmp	byte ptr cs:data_44C6,0
		jne	loc_3896		; Jump if not equal
		retn
loc_3896:
		push	ax
		push	cx
		mov	al,9Fh
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0
		mov	al,0BFh
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0
		mov	al,0DFh
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0
		mov	al,0FFh
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0
		mov	cx,7D00h

locloop_38AB:
		loop	locloop_38AB		; Loop if cx > 0

		pop	cx
		pop	ax
		retn
sub_388D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_38B0	proc	near
		push	ax
		cli				; Disable interrupts
		mov	byte ptr cs:data_3731,0
		mov	cs:data_373E,0
		mov	cs:data_374B,0

		call	sub_388D		; Initialize DMA-2 controller cascade cahnnel 4

		; disable sound output
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		sti				; Enable interrupts
		pop	ax
		retn
sub_38B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_38D0	proc	near
		push	ax
		push	bx
		push	di
		push	si
		push	ds
		push	cs
		pop	ds
		cli				; Disable interrupts
		dec	al
		mov	si,data_44AD
		cmp	al,[si]
		jae	loc_390B		; Jump if above or =
;*		mov	bl,al
		db	 88h,0C3h		;  Fixup - byte match
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	bx,[bx+si+1]
;*		add	bx,si
		db	 01h,0F3h		;  Fixup - byte match
		cmp	byte ptr [bx],0
		je	loc_390B		; Jump if equal
		call	sub_3912
		add	bx,8
		cmp	byte ptr [bx],0
		je	loc_390B		; Jump if equal
		call	sub_3912
		add	bx,8
		cmp	byte ptr [bx],0
		je	loc_390B		; Jump if equal
		call	sub_3912
loc_390B:
		sti				; Enable interrupts
		pop	ds
		pop	si
		pop	di
		pop	bx
		pop	ax
		retn
sub_38D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3912	proc	near
		cmp	byte ptr [bx+1],0
		je	loc_3920		; Jump if equal
		test	byte ptr data_448E,2
		jnz	loc_3920		; Jump if not zero
		retn
loc_3920:
		mov	al,[bx]
		cmp	al,1
		je	loc_392F		; Jump if equal
		cmp	al,2
		je	loc_3934		; Jump if equal
		mov	di,374Bh
		jmp	short loc_3937
loc_392F:
		mov	di,3731h
		jmp	short loc_3937
loc_3934:
		mov	di,373Eh
loc_3937:
;*		mov	byte ptr [di+0],1
		db	0C6h, 45h, 00h, 01h	;  Fixup - byte match
		db	 8Ah, 47h, 01h, 88h, 45h, 07h
		db	 8Ah, 47h, 02h, 88h, 45h, 08h
		db	 8Ah, 47h, 03h, 88h, 45h, 09h
		db	 8Ah, 47h, 04h, 88h, 45h, 0Ah
		db	 8Ah, 47h, 05h, 88h, 45h, 0Bh
		db	 8Bh, 47h, 06h, 01h,0F0h, 89h
		db	 45h, 01h,0C6h, 45h, 0Ch, 00h
		db	0C3h
loc_3966:
		cmp	byte ptr data_3731,0
		jne	loc_3966		; Jump if not equal
		cmp	data_373E,0
		jne	loc_3966		; Jump if not equal
		cmp	data_374B,0
		jne	loc_3966		; Jump if not equal
		retn
sub_3912	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_397C	proc	near
;*		mov	bl,[si+0]
		db	 8Ah, 5Ch, 00h		;  Fixup - byte match
		db	 80h,0FBh, 00h, 75h, 01h,0C3h
		db	 8Bh, 7Ch, 01h,0B7h, 00h,0D1h
		db	0E3h,0FFh,0A7h, 90h
		db	39h
data_3990	dw	0			; Data table (indexed access)
		db	 62h, 3Ah,0CCh, 3Ah,0F1h, 3Ah
		db	 9Ch, 39h,0EDh, 39h, 80h, 7Ch
		db	 03h, 00h, 74h, 05h,0FEh, 4Ch
		db	 03h
		db	 75h, 0Dh
loc_39A7:
;*		mov	byte ptr [si+0],5
		db	0C6h, 44h, 00h, 05h	;  Fixup - byte match
		db	 8Ah, 45h, 01h, 88h, 44h, 03h
		db	0E9h, 70h, 00h,0F6h, 06h, 8Eh
		db	 44h, 02h, 75h, 1Ah, 80h,0FAh
		db	 00h, 75h, 15h,0FEh,0C2h, 8Bh
		db	 44h, 04h, 80h, 74h, 06h, 01h
		db	 74h, 02h,0D1h,0E8h
loc_39CD:
		cli				; Disable interrupts
		out	42h,al			; port 42h, 8253 timer 2 spkr
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		out	42h,al			; port 42h, 8253 timer 2 spkr
		sti				; Enable interrupts

loc_ret_39D5:
		retn
sub_397C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_39D6	proc	near
		cli				; Disable interrupts
		push	ax
		and	al,0Fh
;*		add	al,dh
		db	 00h,0F0h		;  Fixup - byte match
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0
		pop	ax
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		and	al,7Fh
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0
		sti				; Enable interrupts
		retn
sub_39D6	endp

			                        ;* No entry point to code
		cmp	byte ptr [si+3],0
		je	loc_39F8		; Jump if equal
		dec	byte ptr [si+3]
		jnz	loc_3A24		; Jump if not zero
loc_39F8:
		mov	ax,0FF00h
		test	byte ptr data_448E,2
		jz	loc_3A05		; Jump if zero
		call	sub_3A45
loc_3A05:
		add	di,4
		cmp	byte ptr [di],0FFh
		jne	loc_3A14		; Jump if not equal
		mov	di,[di+1]
		add	di,data_44AD
loc_3A14:
		mov	[si+1],di
		cmp	byte ptr [di],0
		je	loc_3A1F		; Jump if equal
		jmpn	loc_3A62
loc_3A1F:
;*		mov	byte ptr [si+0],0
		db	0C6h, 44h, 00h, 00h	;  Fixup - byte match
		db	0C3h
loc_3A24:
		test	byte ptr data_448E,2
		jnz	loc_3A39		; Jump if not zero
		cmp	dl,0
		jne	loc_ret_3A61		; Jump if not equal
		cli				; Disable interrupts
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		sti				; Enable interrupts
		retn
loc_3A39:
		mov	al,[si+0Ch]
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		sub	al,[si+0Bh]
		jnc	loc_3A45		; Jump if carry=0
		mov	al,0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3A45	proc	near
loc_3A45:
		mov	[si+0Ch],al
		and	al,0F0h
		and	ah,0F0h
;*		cmp	al,ah
		db	 38h,0E0h		;  Fixup - byte match
		jz	loc_ret_3A61		; Jump if zero
		not	al
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
;*		add	al,dh
		db	 00h,0F0h		;  Fixup - byte match
		add	al,10h
		out	0C0h,al			; port 0C0h, DMA-2 bas&add ch 0

loc_ret_3A61:
		retn
sub_3A45	endp

loc_3A62:
		mov	byte ptr [si+6],0
		mov	al,[di]
		mov	[si+3],al
		mov	cl,[di+3]
		mov	bl,[di+2]
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		test	byte ptr data_448E,2
		jnz	loc_3A9F		; Jump if not zero
		mov	ax,data_3BC0[bx]
		shr	ax,cl			; Shift w/zeros fill
		mov	[si+4],ax
		cmp	dl,0
		jne	loc_3A9A		; Jump if not equal
		inc	dl
		cli				; Disable interrupts
		out	42h,al			; port 42h, 8253 timer 2 spkr
;*		mov	al,ah
		db	 88h,0E0h		;  Fixup - byte match
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,1
		out	61h,al			; port 61h, 8255 B - spkr, etc
		sti				; Enable interrupts
loc_3A9A:
;*		mov	byte ptr [si+0],4
		db	0C6h, 44h, 00h, 04h	;  Fixup - byte match
		db	0C3h
loc_3A9F:
		mov	ax,data_3BDC[bx]
		shr	ax,cl			; Shift w/zeros fill
		mov	cl,[si+7]
		cmp	cl,0
		je	loc_3AC0		; Jump if equal
		cmp	cl,1
		je	loc_3ABE		; Jump if equal
		push	dx
;*		xor	dx,dx			; Zero register
		db	 31h,0D2h		;  Fixup - byte match
		inc	cl
		mov	ch,0
		div	cx			; ax,dx rem=dx:ax/reg
		pop	dx
		jmp	short loc_3AC0
loc_3ABE:
		shr	ax,1			; Shift w/zeros fill
loc_3AC0:
		mov	[si+4],ax
		call	sub_39D6
;*		mov	byte ptr [si+0],2
		db	0C6h, 44h, 00h, 02h	;  Fixup - byte match
		db	0EBh, 0Eh, 80h, 7Ch, 03h, 00h
		db	 74h, 05h,0FEh, 4Ch, 03h, 75h
		db	 03h,0E9h,0CDh,0FEh, 8Ah, 44h
		db	 0Ch, 88h,0C4h, 02h, 44h, 08h
		db	 73h, 02h,0B0h,0FFh
loc_3AE6:
		cmp	al,0FFh
		jne	loc_3AEE		; Jump if not equal
;*		mov	byte ptr [si+0],3
		db	0C6h, 44h, 00h, 03h	;  Fixup - byte match
loc_3AEE:
		jmp	loc_3A45
			                        ;* No entry point to code
		cmp	byte ptr [si+3],0
		je	loc_3AFC		; Jump if equal
		dec	byte ptr [si+3]
		jnz	loc_3AFF		; Jump if not zero
loc_3AFC:
		jmp	loc_39A7
loc_3AFF:
		mov	al,[si+0Ch]
;*		mov	ah,al
		db	 88h,0C4h		;  Fixup - byte match
		sub	al,[si+9]
		jnc	loc_3B0B		; Jump if carry=0
		mov	al,0
loc_3B0B:
		cmp	al,[si+0Ah]
		jbe	loc_3B13		; Jump if below or =
		jmp	loc_3A45
loc_3B13:
		mov	al,[si+0Ah]
		call	sub_3A45
;*		mov	byte ptr [si+0],4
		db	0C6h, 44h, 00h, 04h	;  Fixup - byte match
		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_3B1E	proc	near
		cli				; Disable interrupts
		push	cs
		pop	ds
		test	byte ptr data_448E,1
		jnz	loc_3B2B		; Jump if not zero
		jmpn	loc_3B96
loc_3B2B:
		test	byte ptr data_448E,2
		jz	loc_3B38		; Jump if zero
		in	al,61h			; port 61h, 8255 port B, read
		and	al,9Fh
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_3B38:
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	ax,0F000h
		mov	es,ax
		mov	si,offset data_3BAC
;*		xor	bx,bx			; Zero register
		db	 31h,0DBh		;  Fixup - byte match
loc_3B48:
		lodsb				; String [si] to al
;*		mov	dh,al
		db	 88h,0C6h		;  Fixup - byte match
		lodsb				; String [si] to al
		shl	al,1			; Shift w/zeros fill
;*		mov	dl,al
		db	 88h,0C2h		;  Fixup - byte match
		cmp	dx,0
		jne	loc_3B58		; Jump if not equal
		jmpn	loc_3B81
loc_3B58:
		call	sub_3B5D
		jmp	short loc_3B48

;==== External Entry into Subroutine ======================================

sub_3B5D:
		or	bx,0E000h
		mov	ch,0
loc_3B63:
;*		mov	cl,dl
		db	 88h,0D1h		;  Fixup - byte match

locloop_3B65:
		loop	locloop_3B65		; Loop if cx > 0

		in	al,61h			; port 61h, 8255 port B, read
		inc	bx
		and	bx,1FFFh
		test	byte ptr es:[bx],1
		jz	loc_3B78		; Jump if zero
		or	al,2
		jmp	short loc_3B7A
loc_3B78:
		and	al,0FDh
loc_3B7A:
		out	61h,al			; port 61h, 8255 B - spkr, etc
		dec	dh
		jnz	loc_3B63		; Jump if not zero
		retn
loc_3B81:
		in	al,61h			; port 61h, 8255 port B, read
		or	al,2
		out	61h,al			; port 61h, 8255 B - spkr, etc
		test	byte ptr data_448E,2
		jz	loc_3B94		; Jump if zero
		in	al,61h			; port 61h, 8255 port B, read
		or	al,60h			; '`'
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_3B94:
		sti				; Enable interrupts
		retn
loc_3B96:
		sti				; Enable interrupts
		mov	byte ptr cs:data_44C3,1
		mov	byte ptr cs:data_44C2,0Fh
loc_3BA3:
		cmp	byte ptr cs:data_44C3,0
		jne	loc_3BA3		; Jump if not equal
		retn
sub_3B1E	endp

data_3BAC	db	0FFh
		db	 10h, 64h, 30h, 64h, 2Ch,0FFh
		db	 18h, 64h, 26h, 64h, 2Ah,0FFh
		db	 18h,0FFh, 10h, 40h, 7Fh, 00h
		db	 00h
data_3BC0	dw	2A5Dh			; Data table (indexed access)
		db	 00h, 28h,0BCh
		db	'%BGBG?C}?'
		db	0E6h, 3Bh, 8Eh, 38h, 62h, 35h
		db	 62h, 35h, 61h, 32h, 8Dh, 2Fh
		db	0E5h
		db	2Ch
data_3BDC	dw	3FEh			; Data table (indexed access)
		db	0C5h, 03h, 8Fh, 03h,0B8h, 06h
		db	0B8h, 06h, 57h, 06h,0FCh, 05h
		db	0A6h, 05h, 55h, 05h, 08h, 05h
		db	 08h, 05h,0C0h, 04h, 7Ch, 04h
		db	 3Bh, 04h
data_3BF8	db	0Dh, 0Ah, 'file does not exist.', 0Dh
		db	0Ah, 0
data_3C11	db	1
data_3C12	db	2
data_3C13	db	3
		db	 04h, 05h, 06h, 07h, 02h, 03h
		db	 04h, 05h, 06h, 07h, 08h, 09h
		db	 0Ah, 08h, 09h, 0Ah, 0Bh, 0Dh
		db	 0Eh, 0Ch, 0Bh, 0Ch, 0Eh, 0Fh
		db	 11h, 13h, 10h, 0Dh, 12h, 14h
		db	 0Dh, 0Ah, 0Ah, 0Ah, 07h
		db	'PRESS "R" FOR RGB DISPLAY', 0Dh, 0Ah
		db	6
		db	'PRESS "C" FOR COMPOSITE DISPLAY'
		db	0
data_3C73	db	3
		db	'Congratulations!'
		db	0
		db	'3000 Points'
		db	 00h, 03h, 4Fh, 4Fh, 50h, 53h
		db	 00h, 02h, 01h, 02h, 53h, 45h
		db	 4Ch, 45h, 43h, 54h, 3Ah,0FFh
		db	 05h, 03h, 03h
loc_3CA5:
		dec	dx
		add	[bx+si],sp
		and	[bp+4Fh],al
		push	dx
		and	[bx+si],ah
		add	cx,[bp+si+4Fh]
		pop	cx
		push	bx
		push	sp
		dec	cx
		inc	bx
		dec	bx
		inc	word ptr [di]
		add	ax,14Bh
		and	[bx+si],ah
		inc	si
		dec	di
		push	dx
		and	[bx+si],ah
		add	cx,[bp+di+45h]
		pop	cx
		inc	dx
		dec	di
		inc	cx
		push	dx
		inc	sp
		inc	word ptr [di]
		pop	es
		xor	[bx+di],ax
		and	[bx+si],ah
		inc	si
		dec	di
		push	dx
		and	[bx+si],ah
		add	cx,[bx+4Eh]
		inc	bp
		and	[bx+si+4Ch],dl
		inc	cx
		pop	cx
		inc	bp
		push	dx
		inc	word ptr [di]
		or	[bp+si],si
		add	[bx+si],sp
		and	[bp+4Fh],al
		push	dx
		and	[bx+si],ah
		add	dx,[si+57h]
		dec	di
		and	[bx+si+4Ch],dl
		inc	cx
		pop	cx
		inc	bp
		push	dx
		inc	word ptr [di]
		or	ax,[bp+si+1]
		and	[bx+si],ah
		inc	si
		dec	di
		push	dx
		and	[bx+si],ah
		add	ax,[bp+si+45h]
		inc	di
		dec	cx
		dec	si
		dec	si
		inc	bp
		push	dx
		inc	word ptr [di]
		or	ax,141h
		and	[bx+si],ah
		inc	si
		dec	di
		push	dx
		and	[bx+si],ah
		add	ax,[bx+di+52h]
		inc	bx
		inc	cx
		inc	sp
		inc	bp
		inc	word ptr [di]
		db	 0Fh, 45h, 01h, 20h, 20h, 46h
		db	 4Fh, 52h, 20h, 20h, 03h, 45h
		db	 58h, 50h, 45h, 52h, 54h,0FFh
		db	 05h, 11h, 4Eh, 01h, 20h, 20h
		db	 46h, 4Fh, 52h, 20h, 20h, 03h
		db	'NO SOUND'
		db	0FFh, 05h, 13h, 53h, 01h, 20h
		db	 20h, 46h, 4Fh, 52h, 20h, 20h
		db	 03h, 53h, 4Fh, 55h, 4Eh, 44h
		db	0FFh, 06h, 18h, 02h
		db	'BUTTON OR SPACE TO PLAY ...'
		db	0
data_3D7C	db	24h
		db	 25h,0FFh, 02h, 03h,0FFh, 30h
		db	 1Eh, 12h,0FFh, 31h, 1Fh,0FFh
data_3D89	dw	50Ah			; Data table (indexed access)
		db	 0Ah, 0Ah, 0Ah, 0Fh, 8Ah, 16h
data_3D91	db	5
		db	 15h, 03h, 58h, 01h, 20h, 20h
		db	 46h, 4Fh, 52h, 20h, 20h, 03h
		db	'EXTERNAL SOUND'
		db	0
data_3DAD	db	60h
		db	 05h, 02h, 50h, 4Ch, 41h, 59h
		db	 45h, 52h, 20h, 00h
data_3DB8	db	10h
		db	 0Ah, 01h
		db	'GAME OVER'
		db	0
data_3DC5	db	0Eh
		db	 10h, 03h
		db	'WATCH CLOSELY'
		db	 00h, 0Eh, 10h, 20h
		db	12 dup (20h)
		db	 00h, 08h, 10h, 02h
		db	'USE THE JOYSTICK TO MOVE'
		db	0FFh, 0Dh, 11h
		db	'THE BAR TENDER'
		db	0FFh, 0Bh, 13h
		db	'USE THE BUTTON TO'
		db	0FFh, 10h, 14h
		db	'OPEN CAN'
		db	 00h, 06h, 10h, 02h
		db	'USE THE MOTION KEYS TO MOVE'
		db	0FFh, 0Dh, 11h
		db	'THE BAR TENDER'
		db	0FFh, 0Ah, 13h
		db	'USE THE SPACE BAR TO'
		db	0FFh, 10h, 14h
		db	'OPEN CAN'
		db	0
data_3E84	db	6
		db	 10h, 20h
		db	26 dup (20h)
		db	0FFh, 0Dh, 11h, 20h
		db	13 dup (20h)
		db	0FFh, 0Ah, 13h, 20h
		db	19 dup (20h)
		db	0FFh, 10h, 14h, 20h
		db	7 dup (20h)
		db	0
data_3ED5	db	0Bh
		db	 14h, 03h
		db	'GET READY TO SERVE'
		db	0
data_3EEB	dw	5F0h			; Data table (indexed access)
		db	 30h, 0Ch, 70h, 12h,0B0h, 18h
data_3EF3	db	3
		db	2, 2, 2, 3, 2, 2
		db	2, 3
data_3EFC	db	3
		db	8, 'MOVE '
		db	'THE JOYSTICK TO THE TOP LEFT'
		db	0FFh, 04h
		db	9, 'HAND CORNER AND PUSH THE BUTT'
		db	'ON', 0
		db	 04h, 0Bh
		db	'MOVE THE JOYSTICK TO THE MIDDLE'
		db	0FFh
		db	0Ah, 0Ch, 'AND PUSH THE BUTTON'
		db	 00h, 05h, 0Eh
		db	'MOVE THE JOYSTICK TO THE LOWER'
		db	0FFh, 01h, 0Fh
		db	'RIGHT HAND CORNER AND PUSH THE B'
		db	'UTTON', 0
		db	 08h, 18h, 01h
		db	'USE Ctrl Break TO ABORT'
		db	0
data_3FDE	db	3
		db	 0Ch, 03h
		db	'ERROR IN SETUP.  RECHECK JOYSTIC'
		db	'K'
		db	0FFh
		db	0Dh, 0Dh, 'AND TRY AGAIN.'
		db	0
data_4014	db	0Ah
		db	 0Ch, 03h
		db	'JOYSTICK NOT FOUND'
		db	0
data_402A	db	15h			; Data table (indexed access)
		db	 37h, 0Eh, 3Eh, 08h, 44h, 02h
		db	 4Ah
data_4032	db	34h			; Data table (indexed access)
		db	 14h, 3Ah, 0Eh, 40h, 08h, 46h
		db	 02h
data_403A	dw	1133h			; Data table (indexed access)
		db	 3Bh, 19h, 39h, 0Ah, 42h, 13h
		db	 3Fh, 04h, 48h, 0Dh, 45h,0FEh
		db	 4Eh, 07h
data_404A	dw	1636h			; Data table (indexed access)
		db	 32h, 11h, 3Ch, 0Fh, 39h, 0Bh
		db	 42h, 09h, 3Fh, 05h, 48h, 03h
		db	 45h, 00h
data_405A	db	1			; Data table (indexed access)
		db	1, 3, 1, 3, 1, 3
		db	1, 3
data_4063	db	7			; Data table (indexed access)
		db	7, 7, 7
data_4067	db	0			; Data table (indexed access)
		db	 01h, 00h, 80h, 81h, 80h, 00h
		db	 00h
data_406F	dw	0A0h			; Data table (indexed access)
		db	0F0h, 00h, 40h, 01h, 40h, 01h
		db	 40h, 01h,0F0h, 00h,0A0h, 00h
		db	 00h, 00h, 0Eh, 0Ah, 03h
		db	'GAME PAUSED'
		db	0
		db	'$$$$$$'
		db	'(( '
		db	 1Ch, 0Ch, 2Ah, 18h, 18h, 18h
		db	'0((((((++ '
		db	 1Eh, 0Ah, 2Eh, 18h, 18h, 18h
		db	 30h
		db	0, 0
data_40B0	db	0
		db	0, 0, 0, 0, 0
data_40B6	db	0
		db	0, 0, 0, 0, 0
data_40BC	db	0
		db	9 dup (0)
data_40C6	db	0
		db	0, 0, 0, 0, 0, 0
		db	0
data_40CE	db	1			; Data table (indexed access)
data_40CF	db	1			; Data table (indexed access)
		db	 00h, 02h, 02h, 02h, 00h, 03h
		db	 06h, 03h, 06h, 00h, 04h, 84h
		db	 05h, 85h, 00h, 01h, 81h, 00h
		db	 02h, 02h, 02h, 00h, 03h, 06h
		db	 03h,0FFh
data_40EA	db	0			; Data table (indexed access)
		db	0, 0, 1, 1, 1, 0
		db	2, 2, 2, 2, 0, 3
		db	3, 3, 3, 0, 0, 0
		db	0, 1, 1, 1, 0, 2
		db	2, 2
data_4105	dw	101h			; Data table (indexed access)
		db	7 dup (1)
		db	 02h, 01h, 02h, 01h, 02h, 01h
		db	 02h,0FFh, 02h,0FFh, 03h,0FFh
		db	 03h,0FFh, 03h,0FFh, 02h,0FFh
		db	 03h,0FFh, 03h,0FFh, 04h,0FFh
		db	 03h,0FFh, 03h,0FFh, 04h,0FFh
		db	 04h,0FFh, 02h,0FFh, 03h, 01h
		db	 03h, 01h, 04h, 01h, 03h, 01h
		db	 03h,0FFh, 04h,0FFh, 04h,0FFh
		db	 03h,0FFh, 04h, 01h, 04h, 01h
		db	 04h, 01h, 04h, 01h, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h, 01h
		db	 04h, 01h, 04h,0FFh, 04h, 01h
		db	 04h,0FFh, 04h,0FFh, 04h, 01h
		db	 04h,0FFh, 04h, 01h, 04h,0FFh
		db	 04h, 01h, 04h, 01h, 04h,0FFh
		db	 04h, 01h, 04h,0FFh, 04h, 01h
		db	 04h, 01h, 04h, 01h, 04h, 01h
		db	 04h,0FFh, 04h,0FFh, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h,0FFh
		db	 04h, 01h, 04h, 01h, 04h, 01h
		db	 04h, 01h, 04h,0FFh, 04h,0FFh
		db	 04h,0FFh, 04h,0FFh, 04h, 01h
		db	 04h, 01h, 04h
data_41AD	db	1			; Data table (indexed access)
data_41AE	db	0			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Bh
		db	7 dup (0)
		db	 01h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Bh
		db	7 dup (0)
		db	 01h, 00h, 0Bh, 00h, 00h, 00h
		db	 00h, 00h, 0Bh, 00h, 01h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 00h
		db	 0Bh, 00h, 00h, 00h, 00h, 00h
		db	 0Bh, 00h, 01h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 00h, 1Fh, 00h
		db	 00h, 00h, 00h, 00h, 15h, 00h
		db	 1Fh, 00h, 15h, 00h, 00h, 00h
		db	 15h, 00h, 1Fh, 00h, 1Fh, 00h
		db	 00h, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 00h, 00h, 15h, 00h
		db	 1Fh, 00h, 00h, 00h, 00h, 00h
		db	 15h, 00h, 1Fh, 00h, 15h, 00h
		db	 00h, 00h, 15h, 00h, 1Fh, 00h
		db	 1Fh, 00h, 00h, 00h, 15h, 00h
		db	 1Fh, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 1Fh, 00h, 15h, 00h
		db	 00h, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 00h, 00h, 15h, 00h
		db	 1Fh, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 1Fh, 00h, 15h, 00h
		db	 1Fh, 00h, 29h, 00h, 33h, 00h
		db	 00h, 00h, 00h, 00h, 29h, 00h
		db	 29h, 00h, 33h, 00h, 00h, 00h
		db	 29h, 00h, 33h, 00h, 29h, 00h
		db	 00h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 29h, 00h
		db	 29h, 00h, 33h, 00h, 00h, 00h
		db	 29h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 29h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 29h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 29h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 29h, 00h, 33h, 00h, 33h, 00h
		db	 29h, 00h, 29h, 00h, 29h, 00h
		db	 33h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 29h, 00h, 33h, 00h, 33h, 00h
		db	 29h, 00h, 29h, 00h, 29h, 00h
		db	 33h, 00h, 33h, 00h, 47h, 00h
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'=', 0
		db	'G', 0
		db	'G', 0
		db	'=', 0
		db	'G', 0
		db	'=', 0
		db	 0Bh, 00h, 01h, 00h, 01h, 00h
		db	 0Bh, 00h, 01h, 00h, 0Bh, 00h
		db	 01h, 00h, 0Bh, 00h, 0Bh, 00h
		db	 01h, 00h, 01h, 00h, 0Bh, 00h
		db	 01h, 00h, 0Bh, 00h, 0Bh, 00h
		db	 01h, 00h, 0Bh, 00h, 01h, 00h
		db	 01h, 00h, 0Bh, 00h, 01h, 00h
		db	 0Bh, 00h, 01h, 00h, 0Bh, 00h
		db	 0Bh, 00h, 01h, 00h, 01h, 00h
		db	 0Bh, 00h, 01h, 00h, 0Bh, 00h
		db	 0Bh, 00h, 01h, 00h, 15h, 00h
		db	 1Fh, 00h, 1Fh, 00h, 15h, 00h
		db	 15h, 00h, 1Fh, 00h, 15h, 00h
		db	 1Fh, 00h, 1Fh, 00h, 15h, 00h
		db	 1Fh, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 15h, 00h, 1Fh, 00h
		db	 1Fh, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 15h, 00h, 15h, 00h
		db	 1Fh, 00h, 1Fh, 00h, 15h, 00h
		db	 15h, 00h, 1Fh, 00h, 1Fh, 00h
		db	 15h, 00h, 15h, 00h, 1Fh, 00h
		db	 1Fh, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 15h, 00h, 1Fh, 00h
		db	 15h, 00h, 1Fh, 00h, 15h, 00h
		db	 15h, 00h, 15h, 00h, 15h, 00h
		db	 1Fh, 00h, 1Fh, 00h, 1Fh, 00h
		db	 15h, 00h, 15h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 29h, 00h
		db	 29h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 29h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 33h, 00h, 29h, 00h
		db	 29h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 29h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 33h, 00h, 29h, 00h
		db	 29h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 29h, 00h, 29h, 00h
		db	 33h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 33h, 00h, 29h, 00h
		db	 29h, 00h, 33h, 00h, 29h, 00h
		db	 33h, 00h, 29h, 00h, 33h, 00h
		db	 33h, 00h
		db	29h
		db	0, 0, 0
data_444F	db	0
data_4450	dw	0
data_4452	dw	0, 0
data_4456	dw	0
data_4458	dw	0			; segment storage
data_445A	dw	0
data_445C	db	0
data_445D	db	0
data_445E	dw	0
		db	17h
		db	38 dup (0)
data_4487	db	0
data_4488	db	0
data_4489	dw	0FFh
data_448B	db	0			; Data table (indexed access)
data_448C	db	0
data_448D	db	0
data_448E	db	0
data_448F	dw	0
data_4491	dw	0
data_4493	dw	0
data_4495	dw	0		; save SP = 400h
data_4497	dw	0
data_4499	dw	0
data_449B	dw	0
data_449D	dw	0
data_449F	dw	0
data_44A1	dw	0
data_44A3	dw	0
data_44A5	dw	0
data_44A7	dw	0
data_44A9	dw	0
data_44AB	dw	0
data_44AD	dw	0
data_44AF	dw	0
data_44B1	dw	0
data_44B3	dw	0
data_44B5	dw	0
data_44B7	dw	0
data_44B9	dw	0
data_44BB	dw	0
data_44BD	db	0
data_44BE	db	0
data_44BF	db	0
data_44C0	db	0
data_44C1	db	0
data_44C2	db	0
data_44C3	db	0
data_44C4	db	0
data_44C5	db	0
data_44C6	db	0
data_44C7	db	0
data_44C8	dw	0
data_44CA	dw	0
data_44CC	dw	0
data_44CE	dw	0
data_44D0	db	0
data_44D1	dw	0
data_44D3	dw	0
data_44D5	db	0
data_44D6	db	0
data_44D7	dw	0
data_44D9	db	0
		db	11 dup (0)
data_44E5	db	0
data_44E6	dw	0
data_44E8	dw	0
data_44EA	dw	0
data_44EC	dw	0
data_44EE	db	0
data_44EF	dw	0
data_44F1	dw	0
data_44F3	db	0
data_44F4	dw	0
data_44F6	dw	0
data_44F8	dw	0
		db	0, 0
data_44FC	dw	0
data_44FE	dw	0
data_4500	dw	0
data_4502	db	0
		db	0, 0, 0
data_4506	dw	0
data_4508	dw	0
data_450A	dw	0
data_450C	dw	0
data_450E	dw	0
data_4510	dw	0
data_4512	dw	0
data_4514	dw	0
data_4516	dw	0
data_4518	dw	0
data_451A	dw	0
data_451C	db	0
data_451D	db	0
data_451E	db	0
data_451F	db	0
data_4520	db	0
data_4521	db	0
data_4522	db	0
data_4523	db	0
data_4524	db	0
data_4525	db	0
		db	0
data_4527	db	0
data_4528	db	0
data_4529	db	0
data_452A	db	0
data_452B	db	0
data_452C	db	0
data_452D	db	0
data_452E	db	0
data_452F	db	0
data_4530	dw	0
		db	0
data_4533	db	0
		db	0, 0, 0, 0, 0, 0
		db	0
data_453B	db	0
		db	0, 0, 0, 0, 0, 0
		db	0
data_4543	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_454B	dw	0			; Data table (indexed access)
data_454D	dw	0			; Data table (indexed access)
data_454F	dw	0
data_4551	dw	0
		db	8 dup (0)
data_455B	dw	0			; Data table (indexed access)
data_455D	db	0
data_455E	db	0
		db	0, 0
data_4561	db	0
		db	0
data_4563	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_456B	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_4573	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_457B	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_4583	dw	0
		db	0, 0
data_4587	dw	0
data_4589	db	0
data_458A	db	0
		db	0, 0, 0, 0, 0
data_4590	db	0
		db	239 dup (0)

seg_a		ends



		end	start
