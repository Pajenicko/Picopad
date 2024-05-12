
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
;==				CONTAX	                                 ==
;==					                                 ==
;==      Created:   29-Mar-93		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==      Copyright (c) 1987 Borland Intl.                                ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

calls           macro   dummy1, dummy2, slocation
                db      9Ah                     ; forced call far instruction
                dw      offset slocation, seg slocation
endm

jmpn            macro   location
                db      0E9h
                dw      offset location-$-2
endm

callf           macro   location
                push    cs
                call    near ptr location
endm

.186


; The following equates show data references outside the range of the program.

d_0000_0001_e	equ	1
d_0000_002F_e	equ	2Fh
d_0000_0056_e	equ	56h
d_0000_0074_e	equ	74h
d_0000_3D0C_e	equ	3D0Ch			;* data_b_3D0C	dw	17Dh	; exit routine
d_0000_3D10_e	equ	3D10h			;*
PSP_free_seg	equ	2
PSP_envirn_seg	equ	2Ch
d_39F0_0080_e	equ	80h
data_c_FFF2_e	equ	0FFF2h			;*

;------------------------------------------------------------  seg_a   ----

seg_a		segment	para public
		assume cs:seg_a  , ds:seg_b , ss:stack_seg_c


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


CONTAX		proc	far

start:
		sti				; Enable interrupts
		mov	dx,seg seg_b
		mov	cs:data_a_01A3,dx	; data segment
		mov	ah,30h
		int	21h			; DOS Services  ah=function 30h
						;  get DOS version number ax
		; save segments
		mov	bp,ds:PSP_free_seg
		mov	bx,ds:PSP_envirn_seg
		mov	ds,dx
		mov	data_b_0086,ax		; DOS version
		mov	data_b_0084,es		; PSP segment
		mov	word ptr data_b_007E+2,bx
		mov	data_b_009C,bp
		mov	data_b_008A,0FFFFh	; exit code
		call	sub_a_0155		; Install INT 00h (divide by zero)

		; prepare to parse environment ES:DI
		les	di,data_b_007E		; Load seg:offset ptr
		mov	ax,di
		mov	bx,ax
		mov	cx,7FFFh

		; check coprocessor in environment (87=Y)
loc_a_003A:
		cmp	word ptr es:[di],3738h
		jne	loc_a_005A		; Jump if not equal
		mov	dx,es:[di+2]
		cmp	dl,3Dh			; '='
		jne	loc_a_005A		; Jump if not equal
		and	dh,0DFh
		inc	data_b_008A		; exit code
		cmp	dh,59h			; 'Y'
		jne	loc_a_005A		; Jump if not equal
		inc	data_b_008A		; exit code
loc_a_005A:
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_a_00C5		; Jump if cx=0
		inc	bx
		cmp	es:[di],al
		jne	loc_a_003A		; Jump if not equal

		or	ch,80h
		neg	cx
		mov	word ptr data_b_007E,cx
		mov	cx,1
		shl	bx,cl			; Shift w/zeros fill
		add	bx,8
;*		and	bx,0FFF8h
		db	 81h,0E3h,0F8h,0FFh	;  Fixup - byte match
		mov	data_b_0082,bx
		push	cs
		call	word ptr data_b_3D0A
		mov	dx,ds
		sub	bp,dx
		mov	di,data_b_3D08
		cmp	di,100h
		jae	loc_a_0097		; Jump if above or =
		mov	di,100h
		mov	data_b_3D08,di
loc_a_0097:
		add	di,4630h
		jc	loc_a_00C5		; Jump if carry Set
		add	di,data_b_3CA0
		jc	loc_a_00C5		; Jump if carry Set
		mov	cl,4
		shr	di,cl			; Shift w/zeros fill
		inc	di
		cmp	bp,di
		jb	loc_a_00C5		; Jump if below
		cmp	data_b_3D08,0
		je	loc_a_00BA		; Jump if equal
		cmp	data_b_3CA0,0
		jne	loc_a_00C8		; Jump if not equal
loc_a_00BA:
		mov	di,1000h
		cmp	bp,di
		ja	loc_a_00C8		; Jump if above
		mov	di,bp
		jmp	short loc_a_00C8
loc_a_00C5:
		jmp	loc_a_018D		; Error - abnormal termination
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
		call	sub_a_2B76		; Parse command line
		call	sub_a_2C61
		xor	ax,ax			; Zero register
		mov	es,cs:data_a_01A3	; data segment
		mov	di,d_0000_3D10_e
		mov	cx,4630h
		sub	cx,di
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		call	word ptr data_b_3D0E	; function - set videomode
		push	data_b_007C
		push	data_b_007A
		push	data_b_0078
		call	sub_a_267E
		push	ax			; PARAMETER_1
		call	sub_a_288F

CONTAX		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

;      Note: Subroutine does not return	to instruction after call

; Exit program

sub_a_0115	proc	near
		mov	ds,cs:data_a_01A3	; data segment
		call	sub_a_0171		; Uninstall INT 00h service

		push	cs
		call	word ptr ds:data_b_3D0C	; dw	17Dh	; exit routine

		; do checksum
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

		; error - null pointer
		sub	ax,0D36h
		nop
		jz	loc_a_0143		; Jump if zero
		mov	cx,19h
		nop
		mov	dx,d_0000_002F_e	; error text: 'Null pointer assignment', 0Dh, 0Ah
		call	sub_a_0185		; Write to console error output, CX count, DS:DX buffer 
loc_a_0143:
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

; Exit and print error: Divide error

int_00h_entry	proc	far

		mov	cx,0Eh
		nop
		mov	dx,48h			; text - Divide error
		jmp	short loc_a_0194	; exit and print error
int_00h_entry	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 00h (divide by zero)

sub_a_0155	proc	near
		push	ds
		mov	ax,3500h
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	data_b_0074,bx
		mov	data_b_0076,es
		mov	ax,2500h
		mov	dx,cs
		mov	ds,dx
		mov	dx,offset int_00h_entry ; Exit and print error: Divide error
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		retn
sub_a_0155	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Uninstall INT 00h service

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
		mov	data_b_008A,0		; exit code
		retf				; Return far
		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Write to console error output, CX count, DS:DX buffer 

sub_a_0185	proc	near
		mov	ah,40h			; '@'
		mov	bx,2
		int	21h			; DOS Services  ah=function 40h
						;  write file  bx=file handle
						;   cx=bytes from ds:dx buffer
		retn
sub_a_0185	endp

		; Error - abnormal termination
loc_a_018D:
		mov	cx,1Eh
		nop
		mov	dx,d_0000_0056_e	; Error text - abnormal program termination
loc_a_0194:
		mov	ds,cs:data_a_01A3	; data segment
		call	sub_a_0185		; Write to console error output, CX count, DS:DX buffer 
		mov	ax,3
		push	ax
		call	sub_a_0115		; Exit program

data_a_01A3	dw	0			; data segment

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read system timer 0040:006C -> DX:AX

sub_a_01A5	proc	near
		mov	word ptr data_b_3DA2+2,0
		mov	data_b_3DA2,46Ch
		les	bx,dword ptr data_b_3DA2	; Load seg:offset ptr
		mov	dx,es:[bx+2]
		mov	ax,es:[bx]
		retn
sub_a_01A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait ticks of system timer

sub_a_01BD	proc	near

PARAMETER_1	=	4			; bp+4
LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,4
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		push	dx
		push	ax
		mov	ax,[bp+PARAMETER_1]
		cwd				; Word to double word
		pop	bx
		pop	cx
		add	bx,ax
		adc	cx,dx
		mov	[bp+LOCAL_1],cx
		mov	[bp+LOCAL_2],bx
loc_a_01D8:
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		cmp	dx,[bp+LOCAL_1]
		jl	loc_a_01D8		; Jump if <
		jnz	loc_a_01E7		; Jump if not zero
		cmp	ax,[bp+LOCAL_2]
		jb	loc_a_01D8		; Jump if below
loc_a_01E7:
		mov	sp,bp
		pop	bp
		retn
sub_a_01BD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Call INT 10h function

sub_a_01EB	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	data_b_45CE,ax		; INT xx parameters - AX
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,10h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		mov	sp,bp
		pop	bp
		retn
sub_a_01EB	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	word ptr [bp+4]		; PARAMETER_2
		mov	ax,3CEh
		push	ax			; PARAMETER_1
		call	sub_a_2B0D
		mov	sp,bp
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get EGA/VGA palette register

sub_a_0218	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		cmp	data_b_1E7C,0
		jne	loc_a_0227		; Jump if not equal
		mov	ax,1
		jmp	short loc_a_024D
loc_a_0227:
		; get VGA register
		mov	byte ptr data_b_45CE+1,10h ; INT xx parameters - AH
		mov	byte ptr data_b_45CE,7	; INT xx parameters - AL
		mov	al,[bp+PARAMETER_1]
		mov	data_b_45D0,al		; INT xx parameters - BL
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,10h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		mov	sp,bp
		mov	al,byte ptr data_b_3D22+1 ; BH register
		mov	ah,0
loc_a_024D:
		pop	bp
		retn
sub_a_0218	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_024F	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Ah
		mov	word ptr [bp-0Ah],0
		cmp	data_b_1E7C,0
		jne	loc_a_0266		; Jump if not equal
		jmp	loc_a_02E7
loc_a_0266:
		mov	word ptr [bp-6],0
		mov	word ptr [bp-2],100h
		mov	word ptr [bp-4],0
		jmp	short loc_a_02DF
loc_a_0277:
		mov	ax,[bp-2]
		add	ax,2
		push	ax			; PARAMETER_2
		mov	ax,3C4h
		push	ax			; PARAMETER_1
		call	sub_a_2B0D
		pop	cx
		pop	cx
		mov	ax,[bp-2]
		shl	ax,1			; Shift w/zeros fill
		mov	[bp-2],ax
		mov	si,[bp+0Ah]
		jmp	short loc_a_02C8
loc_a_0294:
		mov	ax,si
		mov	dx,50h
		mul	dx			; dx:ax = reg * ax
		mov	[bp-8],ax
		mov	di,[bp+8]
		jmp	short loc_a_02BD
loc_a_02A3:
		mov	bx,[bp+10h]
		add	bx,[bp-0Ah]
		mov	al,[bx]
		mov	dx,[bp-8]
		add	dx,di
		les	bx,data_b_3DAC		; address of video memory
		add	bx,dx
		mov	es:[bx],al
		inc	word ptr [bp-0Ah]
		inc	di
loc_a_02BD:
		mov	ax,[bp+8]
		add	ax,[bp+0Ch]
		cmp	ax,di
		jg	loc_a_02A3		; Jump if >
		inc	si
loc_a_02C8:
		mov	ax,[bp+0Ah]
		add	ax,[bp+0Eh]
		cmp	ax,si
		jg	loc_a_0294		; Jump if >
		mov	ax,data_b_1E7A
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		add	[bp-6],ax
		inc	word ptr [bp-4]
loc_a_02DF:
		cmp	word ptr [bp-4],4
		jl	loc_a_0277		; Jump if <
		jmp	short loc_a_0339
loc_a_02E7:
		mov	si,[bp+0Ah]
		jmp	short loc_a_032F
loc_a_02EC:
		mov	ax,si
		sar	ax,1			; Shift w/sign fill
		mov	dx,50h
		mul	dx			; dx:ax = reg * ax
		mov	dx,si
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
		mov	cx,0Dh
		shl	dx,cl			; Shift w/zeros fill
		add	ax,dx
		mov	[bp-8],ax
		mov	di,[bp+8]
		jmp	short loc_a_0324
loc_a_030A:
		mov	bx,[bp+10h]
		add	bx,[bp-0Ah]
		mov	al,[bx]
		mov	dx,[bp-8]
		add	dx,di
		les	bx,data_b_3DAC		; address of video memory
		add	bx,dx
		mov	es:[bx],al
		inc	word ptr [bp-0Ah]
		inc	di
loc_a_0324:
		mov	ax,[bp+8]
		add	ax,[bp+0Ch]
		cmp	ax,di
		jg	loc_a_030A		; Jump if >
		inc	si
loc_a_032F:
		mov	ax,[bp+0Ah]
		add	ax,[bp+0Eh]
		cmp	ax,si
		jg	loc_a_02EC		; Jump if >
loc_a_0339:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_024F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_033F	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		dec	sp
		dec	sp
		cmp	data_b_1E7C,0
		je	loc_a_03BC		; Jump if equal
		mov	ax,0F02h
		push	ax			; PARAMETER_2
		mov	ax,3C4h
		push	ax			; PARAMETER_1
		call	sub_a_2B0D
		pop	cx
		pop	cx
		mov	ax,[bp+12h]
		and	ax,0FF00h
		push	ax			; PARAMETER_2
		mov	ax,3CEh
		push	ax			; PARAMETER_1
		call	sub_a_2B0D
		pop	cx
		pop	cx
		mov	ax,[bp+12h]
		mov	cx,8
		shl	ax,cl			; Shift w/zeros fill
		or	ax,1
		push	ax			; PARAMETER_2
		mov	ax,3CEh
		push	ax			; PARAMETER_1
		call	sub_a_2B0D
		pop	cx
		pop	cx
		mov	si,[bp+0Ah]
		jmp	short loc_a_03B0
loc_a_0384:
		mov	ax,si
		mov	dx,50h
		mul	dx			; dx:ax = reg * ax
		mov	[bp-2],ax
		mov	di,[bp+8]
		jmp	short loc_a_03A5
loc_a_0393:
		mov	al,[bp+10h]
		mov	dx,[bp-2]
		add	dx,di
		les	bx,data_b_3DAC		; address of video memory
		add	bx,dx
		mov	es:[bx],al
		inc	di
loc_a_03A5:
		mov	ax,[bp+8]
		add	ax,[bp+0Ch]
		cmp	ax,di
		jg	loc_a_0393		; Jump if >
		inc	si
loc_a_03B0:
		mov	ax,[bp+0Ah]
		add	ax,[bp+0Eh]
		cmp	ax,si
		jg	loc_a_0384		; Jump if >
		jmp	short loc_a_0406
loc_a_03BC:
		mov	si,[bp+0Ah]
		jmp	short loc_a_03FC
loc_a_03C1:
		mov	ax,si
		sar	ax,1			; Shift w/sign fill
		mov	dx,50h
		mul	dx			; dx:ax = reg * ax
		mov	dx,si
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
		mov	cx,0Dh
		shl	dx,cl			; Shift w/zeros fill
		add	ax,dx
		mov	[bp-2],ax
		mov	di,[bp+8]
		jmp	short loc_a_03F1
loc_a_03DF:
		mov	al,[bp+10h]
		mov	dx,[bp-2]
		add	dx,di
		les	bx,data_b_3DAC		; address of video memory
		add	bx,dx
		mov	es:[bx],al
		inc	di
loc_a_03F1:
		mov	ax,[bp+8]
		add	ax,[bp+0Ch]
		cmp	ax,di
		jg	loc_a_03DF		; Jump if >
		inc	si
loc_a_03FC:
		mov	ax,[bp+0Ah]
		add	ax,[bp+0Eh]
		cmp	ax,si
		jg	loc_a_03C1		; Jump if >
loc_a_0406:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_033F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check VSYNC support

sub_a_040C	proc	near
		push	si
		push	bp
		mov	bp,sp
		sub	sp,4
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		add	ax,3
		adc	dx,0
		mov	[bp-2],dx
		mov	[bp-4],ax

		; read VSYNC register
		mov	ax,3DAh
		push	ax
		call	sub_a_28BE		; read port -> AX
		pop	cx
		mov	si,ax
;*		and	si,8
		db	 81h,0E6h, 08h, 00h	;  Fixup - byte match
		; SI = 8 if VSYNC

		; wait VSYNC
loc_a_0430:
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		cmp	dx,[bp-2]
		jg	loc_a_0450		; Jump if >
		jl	loc_a_043F		; Jump if <
		cmp	ax,[bp-4]
		jae	loc_a_0450		; Jump if above or =
loc_a_043F:
		; read VSYNC register
		mov	ax,3DAh
		push	ax
		call	sub_a_28BE		; read port -> AX
		pop	cx
		and	ax,8
		; AX = 8 iv VSYNC

		cmp	ax,si
		jne	loc_a_0456		; Jump if not equal
		jmp	short loc_a_0430

loc_a_0450:
		mov	data_b_1E7E,0		; 1=wait for VSYNC supported
loc_a_0456:
		mov	sp,bp
		pop	bp
		pop	si
		retn
sub_a_040C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait for VSYNC

sub_a_045B	proc	near
		cmp	data_b_1E7E,0		; 1=wait for VSYNC supported
		je	loc_ret_a_047C		; Jump if equal
loc_a_0462:
		mov	ax,3DAh
		push	ax
		call	sub_a_28BE		; read port -> AX
		pop	cx
		test	ax,8
		jnz	loc_a_0462		; Jump if not zero
loc_a_046F:
		mov	ax,3DAh
		push	ax
		call	sub_a_28BE		; read port -> AX
		pop	cx
		test	ax,8
		jz	loc_a_046F		; Jump if zero

loc_ret_a_047C:
		retn
sub_a_045B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Enable output to speaker

sub_a_047D	proc	near
		in	al,61h			; port 61h, 8255 port B, read
		mov	ah,0
		mov	data_b_3DDA,ax		; old keyboard port 61h
		mov	al,byte ptr data_b_3DDA ; old keyboard port 61h
;*		or	al,3
		db	 80h,0C8h, 03h		;  Fixup - byte match
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_a_047D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set frequency of tone generator

sub_a_048D	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	ax,[bp+6]
		cwd				; Word to double word
		push	dx
		push	ax
		mov	dx,14h
		mov	ax,4F38h
		push	dx
		push	ax
		calls	far ptr sub_a_29D9	; divide
		mov	si,ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,si
;*		and	al,0FFh
		db	 80h,0E0h,0FFh		;  Fixup - byte match
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	ax,si
		mov	cx,8
		sar	ax,cl			; Shift w/sign fill
		out	42h,al			; port 42h, 8253 timer 2 spkr
		pop	bp
		pop	si
		retn
sub_a_048D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Disable output to speaker

sub_a_04BD	proc	near
		mov	al,byte ptr data_b_3DDA	; old keyboard port 61h
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		retn
sub_a_04BD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_04C3	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_048D		; Set frequency of tone generator
		pop	cx
		call	sub_a_047D		; Enable output to speaker
loc_a_04D0:
;*		cmp	word ptr [bp+PARAMETER_2],0FFFFh
		db	 83h, 7Eh, 06h,0FFh	;  Fixup - byte match
		jle	loc_a_04DE		; Jump if < or =
		call	sub_a_045B		; Wait for VSYNC
		dec	word ptr [bp+PARAMETER_2]
		jmp	short loc_a_04D0
loc_a_04DE:
		call	sub_a_04BD		; Disable output to speaker
		pop	bp
		retn
sub_a_04C3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play tone

sub_a_04E3	proc	near
		push	si
		call	sub_a_047D		; Enable output to speaker
		mov	si,32h
		jmp	short loc_a_04F8
loc_a_04EC:
		push	si
		call	sub_a_048D		; Set frequency of tone generator
		pop	cx
		call	sub_a_045B		; Wait for VSYNC
		add	si,12Ch
loc_a_04F8:
		cmp	si,5DCh
		jl	loc_a_04EC		; Jump if <
		call	sub_a_04BD		; Disable output to speaker
		pop	si
		retn
sub_a_04E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play 3 tones

sub_a_0503	proc	near
		mov	ax,1
		push	ax
		mov	ax,1F4h
		push	ax
		call	sub_a_04C3		; play tone
		pop	cx
		pop	cx
		mov	ax,1
		push	ax
		mov	ax,3E8h
		push	ax
		call	sub_a_04C3		; play tone
		pop	cx
		pop	cx
		mov	ax,1
		push	ax
		mov	ax,2EEh
		push	ax
		call	sub_a_04C3		; play tone
		pop	cx
		pop	cx
		retn
sub_a_0503	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set videomode EGA 10h or CGA 06h

sub_a_052B	proc	near
		cmp	data_b_1E7C,0		; 0=card CGA, 1=card EGA or VGA
		je	loc_a_0556		; Jump if equal
		mov	word ptr data_b_3DAC+2,0A000h ; address of video memory
		mov	word ptr data_b_3DAC,0 ; address of video memory

		; set EGA videomode 10h
		mov	ax,10h
		push	ax			; PARAMETER_1
		call	sub_a_01EB		; Call INT 10h function
		pop	cx

		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx
		mov	data_b_3DB0,0Eh
		jmp	short loc_ret_a_0570
loc_a_0556:
		mov	word ptr data_b_3DAC+2,0B800h ; address of video memory
		mov	word ptr data_b_3DAC,0 ; address of video memory

		; set CGA videomode 6
		mov	ax,6
		push	ax			; PARAMETER_1
		call	sub_a_01EB		; Call INT 10h function
		pop	cx
		mov	data_b_3DB0,8

loc_ret_a_0570:
		retn
sub_a_052B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear video memory

sub_a_0571	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+0Ah]
		mov	word ptr data_b_3DAC+2,0B800h ; address of video memory
		mov	word ptr data_b_3DAC,0 ; address of video memory
		or	di,di			; Zero ?
		jz	loc_a_05B1		; Jump if zero
		mov	ax,di
		mov	dx,0A0h
		mul	dx			; dx:ax = reg * ax
		add	ax,0FF61h
		mov	di,ax
		mov	si,di
		jmp	short loc_a_05A6
loc_a_0599:
		mov	al,[bp+8]
		les	bx,data_b_3DAC		; address of video memory
		mov	es:[bx+si],al
		add	si,2
loc_a_05A6:
		mov	ax,di
		add	ax,0A0h
		cmp	ax,si
		jg	loc_a_0599		; Jump if >
		jmp	short loc_a_05D1
loc_a_05B1:
		; set text videomode 3
		mov	ax,3
		push	ax			; PARAMETER_1
		call	sub_a_01EB		; Call INT 10h function
		pop	cx
		mov	si,d_0000_0001_e
		jmp	short loc_a_05CB

		; clear text video memory
loc_a_05BE:
		mov	al,[bp+8]
		les	bx,data_b_3DAC		; address of video memory
		mov	es:[bx+si],al
		add	si,2
loc_a_05CB:
		cmp	si,0FA0h
		jl	loc_a_05BE		; Jump if <
loc_a_05D1:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0571	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set text position

sub_a_05D5	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	byte ptr data_b_45D1,0	; INT xx parameters - BH
		mov	al,[bp+PARAMETER_1]
;*		add	al,0FFh
		db	 80h,0C0h,0FFh		;  Fixup - byte match
		mov	data_b_45D4,al		; INT xx parameters - DL
		mov	al,[bp+PARAMETER_2]
;*		add	al,0FFh
		db	 80h,0C0h,0FFh		;  Fixup - byte match
		mov	data_b_45D5,al		; INT xx parameters - DH
		mov	byte ptr data_b_45CE+1,2 ; INT xx parameters - AH
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,10h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		mov	sp,bp
		pop	bp
		retn
sub_a_05D5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print character (INT 10h, AH=0Eh)

sub_a_0607	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	byte ptr data_b_45CE+1,0Eh ; INT xx parameters - AH
		mov	al,[bp+PARAMETER_1]
		mov	byte ptr data_b_45CE,al ; INT xx parameters - AL
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,10h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		mov	sp,bp
		pop	bp
		retn
sub_a_0607	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print text

sub_a_0628	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+8]
		xor	si,si			; Zero register
		jmp	short loc_a_064B
loc_a_0634:
		mov	bx,si
		push	word ptr [bx+di]	; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		mov	bx,si
		cmp	byte ptr [bx+di],0Ah
		jne	loc_a_064A		; Jump if not equal
		mov	al,0Dh
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
loc_a_064A:
		inc	si
loc_a_064B:
		mov	bx,si
		cmp	byte ptr [bx+di],0
		jne	loc_a_0634		; Jump if not equal
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0628	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print number

sub_a_0656	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	si,[bp+8]
		or	si,si			; Zero ?
		jnz	loc_a_066B		; Jump if not zero
		mov	al,30h			; '0'
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		jmp	short loc_a_06AF
loc_a_066B:
		or	si,si			; Zero ?
		jge	loc_a_067C		; Jump if > or =
		mov	al,2Dh			; '-'
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		mov	ax,si
		neg	ax
		mov	si,ax
loc_a_067C:
		xor	di,di			; Zero register
		jmp	short loc_a_0697
loc_a_0680:
		mov	ax,si
		mov	bx,0Ah
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		add	dl,30h			; '0'
		mov	byte ptr data_b_3D14[di],dl
		mov	ax,si
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	si,ax
		inc	di
loc_a_0697:
		or	si,si			; Zero ?
		jnz	loc_a_0680		; Jump if not zero
		mov	byte ptr data_b_3D14[di],0
loc_a_06A0:
		or	di,di			; Zero ?
		jz	loc_a_06AF		; Jump if zero
		dec	di
		push	data_b_3D14[di]		; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		jmp	short loc_a_06A0
loc_a_06AF:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0656	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print text and number

sub_a_06B3	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_0628		; Print text
		pop	cx
		push	word ptr [bp+PARAMETER_2]
		call	sub_a_0656		; Print number
		pop	cx
		pop	bp
		retn
sub_a_06B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear prompt and print new prompt

sub_a_06C6	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp

		push	word ptr [bp+PARAMETER_2]	; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position

		mov	sp,bp
		mov	ax,1E86h		; text "   "
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		push	word ptr [bp+PARAMETER_2]	; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position

		mov	sp,bp
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_0628		; Print text

		pop	cx
		pop	bp
		retn
sub_a_06C6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print text at given position

sub_a_06F2	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		push	word ptr [bp+PARAMETER_2]	; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		mov	sp,bp
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_0628		; Print text
		pop	cx
		pop	bp
		retn
sub_a_06F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input key from DOS keyboard, does not wait (AL = 0 if no key)

sub_a_070A	proc	near
		mov	byte ptr data_b_45CE+1,6 ; INT xx parameters - AH
		mov	byte ptr data_b_45D4,0FFh ; INT xx parameters - DL
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,21h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		add	sp,6
		mov	al,data_b_3D20		; AL register
		mov	ah,0
		retn
sub_a_070A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_072C	proc	near
		push	si
		push	bp
		mov	bp,sp
		xor	si,si			; Zero register
		jmp	short loc_a_0743
loc_a_0734:
		mov	bx,[bp+6]
		mov	al,[bx+si]
		cmp	al,[bp+8]
		jne	loc_a_0742		; Jump if not equal
		mov	ax,si
		jmp	short loc_a_074E
loc_a_0742:
		inc	si
loc_a_0743:
		mov	bx,[bp+6]
		cmp	byte ptr [bx+si],0
		jne	loc_a_0734		; Jump if not equal
		mov	ax,0FFFFh
loc_a_074E:
		pop	bp
		pop	si
		retn
sub_a_072C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0751	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6
PARAMETER_3	=	8			; bp+8
PARAMETER_4	=	0Ah			; bp+0Ah

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	data_b_45CE,ax		; INT xx parameters - AX
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,33h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		mov	sp,bp
		mov	ax,data_b_3D22		; BX register
		mov	bx,[bp+PARAMETER_2]
		mov	[bx],ax
		mov	ax,data_b_3D24		; CX register
		mov	bx,[bp+PARAMETER_3]
		mov	[bx],ax
		mov	ax,data_b_3D26		; DX register
		mov	bx,[bp+PARAMETER_4]
		mov	[bx],ax
		pop	bp
		retn
sub_a_0751	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0785	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	data_b_45CE,ax		; INT xx parameters - AX
		mov	ax,3D20h		; INT xx returned parameters
		push	ax
		mov	ax,45CEh		; INT xx parameters
		push	ax
		mov	ax,33h
		push	ax
		call	sub_a_28D2		; Call INT xx function
		mov	sp,bp
		pop	bp
		retn
sub_a_0785	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07A1	proc	near
		cmp	data_b_00B0,0
		je	loc_ret_a_07B0		; Jump if equal
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_0785
		pop	cx

loc_ret_a_07B0:
		retn
sub_a_07A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07B1	proc	near
		cmp	data_b_00B0,0
		je	loc_ret_a_07C0		; Jump if equal
		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_0785
		pop	cx

loc_ret_a_07C0:
		retn
sub_a_07B1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07C1	proc	near
		mov	data_b_3D30,0
		cmp	data_b_00B0,0
		je	loc_a_07E4		; Jump if equal
		mov	ax,3D38h
		push	ax			; PARAMETER_4
		mov	ax,45C8h
		push	ax			; PARAMETER_3
		mov	ax,3D30h
		push	ax			; PARAMETER_2
		mov	ax,3
		push	ax			; PARAMETER_1
		call	sub_a_0751
		add	sp,8
loc_a_07E4:
		mov	ax,data_b_3D30
		retn
sub_a_07C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07E8	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+0Ah]
		mov	si,[bp+8]
		mov	ax,data_b_00A8
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		push	ax
		mov	ax,si
		pop	dx
		sub	ax,dx
		mov	bx,data_b_00A2
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		inc	ax
		mov	si,ax
		mov	ax,di
		sub	ax,data_b_00A6
		cwd				; Word to double word
		idiv	data_b_00A4		; ax,dxrem=dx:ax/data
		inc	ax
		mov	di,ax
		cmp	si,1
		jl	loc_a_0836		; Jump if <
		cmp	si,data_b_009E		; Board size
		jg	loc_a_0836		; Jump if >
		cmp	di,1
		jl	loc_a_0836		; Jump if <
		cmp	di,data_b_00A0
		jle	loc_a_083A		; Jump if < or =
loc_a_0836:
		xor	ax,ax			; Zero register
		jmp	short loc_a_0842
loc_a_083A:
		mov	ax,di
		mul	data_b_00AA		; dx:ax = data * ax
		add	ax,si
loc_a_0842:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_07E8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0846	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,28h
		xor	di,di			; Zero register
		mov	si,di
		jmp	short loc_a_0873
loc_a_0854:
		mov	bx,[bp+8]
		mov	al,[bx+si]
		cbw				; Convrt byte to word
		cmp	ax,[bp+0Ah]
		jne	loc_a_0860		; Jump if not equal
		inc	di
loc_a_0860:
		or	di,di			; Zero ?
		jz	loc_a_086A		; Jump if zero
		mov	byte ptr [bp+si-28h],20h	; ' '
		jmp	short loc_a_0872
loc_a_086A:
		mov	bx,[bp+8]
		mov	al,[bx+si]
		mov	[bp+si-28h],al
loc_a_0872:
		inc	si
loc_a_0873:
		cmp	si,[bp+0Ch]
		jl	loc_a_0854		; Jump if <
		mov	byte ptr [bp+si-28h],0
		lea	ax,[bp-28h]		; Load effective addr
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0846	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_088A	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,6
		mov	di,[bp+0Ah]
		mov	si,[bp+8]
		mov	word ptr [bp-2],0
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		push	si
		mov	ax,2Ah
		push	ax
		mov	ax,1E9Ch
		push	ax
		call	sub_a_0846
		add	sp,6
		mov	word ptr [bp-6],1
		jmp	short loc_a_090A
loc_a_08C0:
		mov	ax,[bp-6]
		inc	ax
		push	ax			; PARAMETER_2
		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		mov	al,20h			; ' '
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		mov	ax,si
		dec	ax
		push	ax
		mov	ax,5Bh
		push	ax
		mov	ax,[bp+0Ch]
		add	ax,[bp-2]
		push	ax
		call	sub_a_0846
		add	sp,6
		mov	al,5Dh			; ']'
		push	ax
		mov	ax,[bp+0Ch]
		add	ax,[bp-2]
		push	ax
		call	sub_a_072C
		pop	cx
		pop	cx
		mov	[bp-4],ax
		or	ax,ax			; Zero ?
		jge	loc_a_0903		; Jump if > or =
		jmp	loc_a_09B3
loc_a_0903:
		inc	ax
		add	[bp-2],ax
		inc	word ptr [bp-6]
loc_a_090A:
		mov	ax,[bp-6]
		cmp	ax,di
		jle	loc_a_08C0		; Jump if < or =
		mov	ax,di
		add	ax,2
		push	ax			; PARAMETER_2
		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		push	si
		mov	ax,2Ah
		push	ax
		mov	ax,1E9Eh
		push	ax
		call	sub_a_0846
		add	sp,6
		mov	ax,1
		push	ax
		mov	ax,0C0h
		push	ax
		mov	ax,di
		add	ax,2
		mul	data_b_3DB0		; dx:ax = data * ax
		push	ax
		mov	ax,1
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		call	sub_a_033F
		add	sp,0Ch
		mov	ax,1
		push	ax
		mov	ax,3
		push	ax
		mov	ax,di
		add	ax,2
		mul	data_b_3DB0		; dx:ax = data * ax
		push	ax
		mov	ax,1
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		mov	ax,si
		inc	ax
		push	ax
		call	sub_a_033F
		add	sp,0Ch
		mov	ax,1
		push	ax
		mov	ax,0FFh
		push	ax
		mov	ax,1
		push	ax
		mov	ax,si
		add	ax,2
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		call	sub_a_033F
		add	sp,0Ch
		mov	ax,1
		push	ax
		mov	ax,0FFh
		push	ax
		mov	ax,1
		push	ax
		mov	ax,si
		add	ax,2
		push	ax
		mov	ax,di
		add	ax,2
		mul	data_b_3DB0		; dx:ax = data * ax
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_033F
		add	sp,0Ch
loc_a_09B3:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_088A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_09B9	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,6
		xor	si,si			; Zero register
		mov	ax,0Ah
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx
		call	sub_a_2CB5
		mov	[bp-4],ax
		call	sub_a_2CC4
		mov	[bp-2],ax
		call	sub_a_07B1
		push	word ptr [bp+0Eh]
		push	word ptr [bp+0Ah]
		push	word ptr [bp+8]
		call	sub_a_088A
		add	sp,6
		call	sub_a_07A1
		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx
loc_a_09F4:
		call	sub_a_07C1
		cmp	ax,2
		jne	loc_a_0A6A		; Jump if not equal
		mov	ax,data_b_3D38
		cwd				; Word to double word
		idiv	data_b_3DB0		; ax,dxrem=dx:ax/data
		mov	di,ax
		mov	ax,[bp+8]
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		cmp	ax,data_b_45C8
		jl	loc_a_0A29		; Jump if <
		mov	ax,[bp+0Ah]
		mul	data_b_3DB0		; dx:ax = data * ax
		add	ax,data_b_3DB0
		add	ax,0FFFEh
		cmp	ax,data_b_3D38
		jge	loc_a_0A2B		; Jump if > or =
loc_a_0A29:
		xor	di,di			; Zero register
loc_a_0A2B:
		cmp	di,si
		je	loc_a_09F4		; Jump if equal
		call	sub_a_07B1
		or	si,si			; Zero ?
		jz	loc_a_0A4A		; Jump if zero
		mov	ax,si
		inc	ax
		push	ax			; PARAMETER_2
		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		mov	al,20h			; ' '
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
loc_a_0A4A:
		mov	si,di
		or	si,si			; Zero ?
		jz	loc_a_0A64		; Jump if zero
		mov	ax,si
		inc	ax
		push	ax			; PARAMETER_2
		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		mov	al,2Ah			; '*'
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
loc_a_0A64:
		call	sub_a_07A1
;*		jmp	loc_a_09F4
		db	0E9h, 8Ah,0FFh		;  Fixup - byte match
loc_a_0A6A:
		call	sub_a_07B1
		mov	ax,1
		push	ax			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		mov	al,20h			; ' '
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		or	si,si			; Zero ?
		jz	loc_a_0AB0		; Jump if zero
		mov	word ptr [bp-6],0
		mov	di,1
		jmp	short loc_a_0AA0
loc_a_0A8C:
		mov	al,5Bh			; '['
		push	ax
		mov	ax,[bp+0Eh]
		add	ax,[bp-6]
		push	ax
		call	sub_a_072C
		pop	cx
		pop	cx
		inc	ax
		add	[bp-6],ax
		inc	di
loc_a_0AA0:
		cmp	di,si
		jle	loc_a_0A8C		; Jump if < or =
		mov	bx,[bp+0Eh]
		add	bx,[bp-6]
		mov	al,[bx]
		cbw				; Convrt byte to word
		mov	data_b_45E0,ax		; key from keyboard
loc_a_0AB0:
		push	word ptr [bp-2]		; PARAMETER_2
		push	word ptr [bp-4]		; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		mov	ax,[bp+0Ah]
		add	ax,2
		mul	data_b_3DB0		; dx:ax = data * ax
		inc	ax
		push	ax
		mov	ax,[bp+8]
		add	ax,2
		push	ax
		xor	ax,ax			; Zero register
		push	ax
		push	ax
		call	sub_a_033F
		add	sp,0Ch
		mov	ax,si
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_09B9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0AE4	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+0Ah]
		mov	si,[bp+8]
		mov	ax,si
		mul	data_b_00A2		; dx:ax = data * ax
		sub	ax,data_b_00A2
		add	ax,data_b_00A8
		mov	si,ax
		mov	ax,di
		mul	data_b_00A4		; dx:ax = data * ax
		sub	ax,data_b_00A4
		add	ax,data_b_00A6
		mov	di,ax
		mov	ax,[bp+0Ch]
		mul	data_b_1E7A		; dx:ax = data * ax
		add	ax,data_b_3DEC
		push	ax
		push	data_b_00A4
		push	data_b_00A2
		push	di
		push	si
		call	sub_a_024F
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0AE4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0B2E	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+0Ah]
;*		cmp	si,0FFFFh
		db	 83h,0FEh,0FFh		;  Fixup - byte match
		jnz	loc_a_0B54		; Jump if not zero
		mov	ax,[bp+8]
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,[bp+6]
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
;*		cmp	si,0FFFCh
		db	 83h,0FEh,0FCh		;  Fixup - byte match
		jnz	loc_a_0B54		; Jump if not zero
		mov	si,3
loc_a_0B54:
		push	si
		push	word ptr [bp+8]
		push	word ptr [bp+6]
		call	sub_a_0AE4
		mov	sp,bp
		pop	bp
		pop	si
		retn
sub_a_0B2E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print char, number and space

sub_a_0B63	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	al,[bp+PARAMETER_1]
;*		add	al,40h			; '@'
		db	 80h,0C0h, 40h		;  Fixup - byte match
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		push	word ptr [bp+PARAMETER_2]
		call	sub_a_0656		; Print number
		pop	cx
		mov	al,20h			; ' '
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		pop	bp
		retn
sub_a_0B63	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0B81	proc	near

		; print text "Hmm"
		mov	ax,5
		push	ax			; PARAMETER_2
		mov	ax,1EA0h		; text "Hmm"
		push	ax			; PARAMETER_1
		call	sub_a_06C6		; Clear prompt and print new prompt
		pop	cx
		pop	cx

		push	data_b_3DA8		; PARAMETER_2
		push	data_b_45E4		; PARAMETER_1
		call	sub_a_0B63		; Print char, number and space
		pop	cx
		pop	cx

		; print text "="
		push	data_b_3DE0		; PARAMETER_2
		mov	ax,1EA8h		; text "="
		push	ax			; PARAMETER_1
		call	sub_a_06B3		; Print text and number
		pop	cx
		pop	cx
		retn
sub_a_0B81	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0BA9	proc	near
		mov	ax,0Bh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print title "CONTAX"
		mov	ax,1
		push	ax			; PARAMETER_2
		mov	ax,1EACh		; text "+ CONTAX +"
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx

		mov	ax,5
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print "(C)..."
		mov	ax,3
		push	ax			; PARAMETER_2
		mov	ax,1EBFh		; text "(C)..."
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx

		mov	ax,0Ch
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		cmp	data_b_00B8,0
		je	loc_a_0BF1		; Jump if equal
		mov	ax,0Bh
		push	ax			; PARAMETER_2
		mov	ax,1ED1h		; text "Two players!"
		push	ax			; PARAMETER_1
		call	sub_a_06C6		; Clear prompt and print new prompt
		pop	cx
		pop	cx
		jmp	short loc_a_0BFE
loc_a_0BF1:
		mov	ax,0Bh
		push	ax			; PARAMETER_2
		mov	ax,1EDEh		; text ""
		push	ax			; PARAMETER_1
		call	sub_a_06C6		; Clear prompt and print new prompt
		pop	cx
		pop	cx

loc_a_0BFE:
		mov	ax,0Ah
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print variant "4-line-loses"
		cmp	data_b_00BC,0
		je	loc_a_0C1C		; Jump if equal
		mov	ax,8
		push	ax			; PARAMETER_2
		mov	ax,1EDFh		; text "4-line-loses"
		push	ax			; PARAMETER_1
		call	sub_a_06C6		; Clear prompt and print new prompt
		pop	cx
		pop	cx
		jmp	short loc_a_0C29

loc_a_0C1C:
		; print variant "5-line-wins"
		mov	ax,8
		push	ax			; PARAMETER_2
		mov	ax,1EEDh		; text "5-line-wins"
		push	ax			; PARAMETER_1
		call	sub_a_06C6		; Clear prompt and print new prompt
		pop	cx
		pop	cx

loc_a_0C29:
		mov	ax,0Ch
		push	ax			; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		; print "IQ"
		push	data_b_00AE		; PARAMETER_2
		mov	ax,1EFAh		; text "IQ:"
		push	ax			; PARAMETER_1
		call	sub_a_06B3		; Print text and number
		pop	cx
		pop	cx

		; print text "(F4 key)"
		mov	ax,1EFEh		; text "(F4 key)"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		; print text "F1 for show"
		mov	ax,16h
		push	ax			; PARAMETER_2
		mov	ax,1F0Ah		; text "F1 for SHOW"
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx

		; print text "F10 for HELP"
		mov	ax,17h
		push	ax			; PARAMETER_2
		mov	ax,1F18h		; text "F10 for HELP"
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx

		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		mov	ax,12h
		push	ax			; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		; print "WHITE move"
		cmp	data_b_45E2,1		; 1=WHITE move, 0=BLACK move
		jne	loc_a_0C8B		; Jump if not equal
		mov	ax,1F26h		; text "WHITE move"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
		jmp	short loc_a_0C93
loc_a_0C8B:
		; print "BLACK move"
		mov	ax,1F32h		; text "BLACK move"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

loc_a_0C93:
		mov	ax,0Eh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		mov	ax,0Ah
		push	ax			; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		; print text "Cursor"
		mov	ax,1F3Eh		; text "Cursor:"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		push	data_b_3DDC		; PARAMETER_2
		push	data_b_45DE		; PARAMETER_1
		call	sub_a_0B63		; Print char, number and space
		pop	cx
		pop	cx
		retn
sub_a_0BA9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0CBE	proc	near
		mov	data_b_00B6,0
		mov	data_b_45EA,1
		jmp	short loc_a_0D25
loc_a_0CCC:
		mov	ax,data_b_00AA
		xor	dx,dx			; Zero register
		mul	dx			; dx:ax = reg * ax
		mov	bx,ax
		add	bx,data_b_45EA
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0FFFCh
		mov	ax,data_b_00A0
		inc	ax
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45EA
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0FFFCh
		mov	data_b_3DF6,1
		jmp	short loc_a_0D18
loc_a_0CFF:
		mov	ax,data_b_3DF6
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45EA
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0
		inc	data_b_3DF6
loc_a_0D18:
		mov	ax,data_b_3DF6
		cmp	ax,data_b_00A0
		jle	loc_a_0CFF		; Jump if < or =
		inc	data_b_45EA
loc_a_0D25:
		mov	ax,data_b_45EA
		cmp	ax,data_b_009E		; Board size
		jle	loc_a_0CCC		; Jump if < or =
		mov	data_b_3DF6,0
		jmp	short loc_a_0D61
loc_a_0D36:
		mov	ax,data_b_3DF6
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0FFFCh
		mov	ax,data_b_3DF6
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_009E		; Board size
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0FFFCh
		inc	data_b_3DF6
loc_a_0D61:
		mov	ax,data_b_00A0
		inc	ax
		cmp	ax,data_b_3DF6
		jge	loc_a_0D36		; Jump if > or =
		cmp	data_b_00BA,0
		je	loc_a_0DBF		; Jump if equal
		mov	data_b_45EA,2
		jmp	short loc_a_0DB6
loc_a_0D7A:
		mov	data_b_3DF6,2
		jmp	short loc_a_0DA2
loc_a_0D82:
		mov	ax,data_b_3DF6
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45EA
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0FFFCh
		mov	ax,6
		sub	ax,data_b_00BA
		add	data_b_3DF6,ax
loc_a_0DA2:
		mov	ax,data_b_3DF6
		cmp	ax,data_b_00A0
		jle	loc_a_0D82		; Jump if < or =
		mov	ax,6
		sub	ax,data_b_00BA
		add	data_b_45EA,ax
loc_a_0DB6:
		mov	ax,data_b_45EA
		cmp	ax,data_b_009E		; Board size
		jle	loc_a_0D7A		; Jump if < or =
loc_a_0DBF:
		mov	ax,data_b_009E		; Board size
		mov	bx,offset data_b_0002
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_3D1E,ax
		mov	ax,data_b_009E		; Board size
		sub	ax,data_b_3D1E
		mov	data_b_3DE2,ax
		mov	ax,data_b_00A0
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_3D3A,ax
		mov	ax,data_b_00A0
		sub	ax,data_b_3D3A
		mov	data_b_3DEE,ax
		mov	ax,data_b_3D3A
		dec	ax
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3D1E
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],2
		mov	ax,data_b_3D3A
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3D1E
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],1
		mov	ax,data_b_3DEE
		inc	ax
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3DE2
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],1
		mov	ax,data_b_3DEE
		add	ax,2
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3DE2
		add	bx,2
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],2
		mov	ax,data_b_3DEE
		add	ax,2
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3D1E
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],1
		mov	ax,data_b_3DEE
		inc	ax
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3D1E
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],2
		mov	ax,data_b_3D3A
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3DE2
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],2
		mov	ax,data_b_3D3A
		dec	ax
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_3DE2
		add	bx,2
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],1
		retn
sub_a_0CBE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0EA5	proc	near
		mov	data_b_45EA,1
		jmp	short loc_a_0ED8
loc_a_0EAD:
		mov	data_b_3DF6,1
		jmp	short loc_a_0ECB
loc_a_0EB5:
		mov	ax,0FFFFh
		push	ax
		push	data_b_3DF6
		push	data_b_45EA
		call	sub_a_0B2E
		add	sp,6
		inc	data_b_3DF6
loc_a_0ECB:
		mov	ax,data_b_3DF6
		cmp	ax,data_b_00A0
		jle	loc_a_0EB5		; Jump if < or =
		inc	data_b_45EA
loc_a_0ED8:
		mov	ax,data_b_45EA
		cmp	ax,data_b_009E		; Board size
		jle	loc_a_0EAD		; Jump if < or =
		retn
sub_a_0EA5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0EE2	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+0Ah]
		mov	si,[bp+8]
		mov	ax,si
		cwd				; Word to double word
		idiv	data_b_00A2		; ax,dxrem=dx:ax/data
		inc	ax
		mov	si,ax
		mov	ax,di
		mul	data_b_3DB0		; dx:ax = data * ax
		cwd				; Word to double word
		idiv	data_b_00A4		; ax,dxrem=dx:ax/data
		inc	ax
		mov	di,ax
		mov	data_b_45EA,1
		jmp	short loc_a_0F35
loc_a_0F0D:
		mov	data_b_3DF6,1
		jmp	short loc_a_0F2A
loc_a_0F15:
		mov	ax,0FFFFh
		push	ax
		push	data_b_3DF6
		push	data_b_45EA
		call	sub_a_0B2E
		mov	sp,bp
		inc	data_b_3DF6
loc_a_0F2A:
		mov	ax,data_b_3DF6
		cmp	ax,di
		jle	loc_a_0F15		; Jump if < or =
		inc	data_b_45EA
loc_a_0F35:
		mov	ax,data_b_45EA
		cmp	ax,si
		jle	loc_a_0F0D		; Jump if < or =
		pop	bp
		pop	di
		pop	si
		retn
sub_a_0EE2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F40	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+6]
		xor	ax,ax			; Zero register
		mov	data_b_3DBC,ax
		mov	data_b_3DBA,ax
		mov	data_b_3DB8,ax
		mov	bx,si
		sub	bx,data_b_00AA
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		sub	bx,data_b_00AA
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		sub	bx,data_b_00AA
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		add	bx,data_b_00AA
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		add	bx,data_b_00AA
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		mov	bx,si
		add	bx,data_b_00AA
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_3DF8[bx]
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		inc	data_b_3DB8[bx]
		pop	bp
		pop	si
		retn
sub_a_0F40	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1003	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		mov	data_b_3DB2,ax
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_0F40
		pop	cx
		mov	bx,data_b_3DB2
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_3DB8[bx],0
		je	loc_a_1031		; Jump if equal
		mov	bx,data_b_45E2		; 1=WHITE move, 0=BLACK move
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_3DB8[bx],0
		jne	loc_a_1035		; Jump if not equal
loc_a_1031:
		xor	ax,ax			; Zero register
		jmp	short loc_a_1038
loc_a_1035:
		mov	ax,1
loc_a_1038:
		pop	bp
		retn
sub_a_1003	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_103A	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		mov	di,[bp+8]
loc_a_1042:
		mov	bx,di
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_3DF8[bx]
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1055		; Jump if not equal
		sub	di,[bp+0Ah]
		jmp	short loc_a_1042
loc_a_1055:
		add	di,[bp+0Ah]
		mov	data_b_3DB6,0
		mov	si,di
loc_a_1060:
		mov	bx,si
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_3DF8[bx]
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1077		; Jump if not equal
		add	si,[bp+0Ah]
		inc	data_b_3DB6
		jmp	short loc_a_1060
loc_a_1077:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jle	loc_a_1089		; Jump if < or =
		xor	ax,ax			; Zero register
		jmp	loc_a_115D
loc_a_1089:
		mov	ax,7
		push	ax			; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		mov	sp,bp
		mov	ax,0Ch
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx
		mov	ax,data_b_00BC
		inc	ax

		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_10B2		; Jump if not equal

		; print text "White wins!"
		mov	ax,1F46h		; text "White wins!"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
		jmp	short loc_a_10BA
loc_a_10B2:
		; print text "Black wins!"
		mov	ax,1F52h		; text "Black wins!"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
loc_a_10BA:
		; print text "Hit SPACE" -> "Hit ENTER"
		mov	ax,8
		push	ax			; PARAMETER_2
		mov	ax,1F5Eh		; text "Hit SPACE"
		push	ax			; PARAMETER_1
		call	sub_a_06C6		; Clear prompt and print new prompt

		mov	sp,bp
		call	sub_a_0503		; Play 3 tones

loc_a_10CA:
		mov	data_b_3DB6,0
		mov	si,di
		jmp	short loc_a_10F3
loc_a_10D4:
		xor	ax,ax			; Zero register
		push	ax
		mov	ax,si
		cwd				; Word to double word
		idiv	data_b_00AA		; ax,dxrem=dx:ax/data
		push	ax
		mov	ax,si
		cwd				; Word to double word
		idiv	data_b_00AA		; ax,dxrem=dx:ax/data
		push	dx
		call	sub_a_0B2E
		mov	sp,bp
		inc	data_b_3DB6
		add	si,[bp+0Ah]
loc_a_10F3:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jg	loc_a_10D4		; Jump if >
		mov	ax,8
		push	ax			; PARAMETER_1
		call	sub_a_01BD		; Wait ticks of system timer
		pop	cx
		mov	data_b_3DB6,0
		mov	si,di
		jmp	short loc_a_1132
loc_a_1112:
		mov	ax,0FFFFh
		push	ax
		mov	ax,si
		cwd				; Word to double word
		idiv	data_b_00AA		; ax,dxrem=dx:ax/data
		push	ax
		mov	ax,si
		cwd				; Word to double word
		idiv	data_b_00AA		; ax,dxrem=dx:ax/data
		push	dx
		call	sub_a_0B2E
		mov	sp,bp
		inc	data_b_3DB6
		add	si,[bp+0Ah]
loc_a_1132:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jg	loc_a_1112		; Jump if >
		mov	ax,8
		push	ax			; PARAMETER_1
		call	sub_a_01BD		; Wait ticks of system timer
		pop	cx
loc_a_1147:
		; input key from keyboard, check 'g' or space
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)
		mov	data_b_45E0,ax		; key from keyboard
		cmp	ax,67h			; 'g'
		je	loc_a_1147		; Jump if equal

; !!! Picopad modification: use Enter key

		cmp	ax,0Dh ;20h			; space
		je	loc_a_115A		; Jump if equal
		jmp	loc_a_10CA
loc_a_115A:
		mov	ax,1
loc_a_115D:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_103A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1161	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	ax,[bp+8]
		mul	data_b_00AA		; dx:ax = data * ax
		mov	si,ax
		add	si,[bp+6]
		mov	ax,1
		push	ax
		push	si
		call	sub_a_103A
		mov	sp,bp
		or	ax,ax			; Zero ?
		jnz	loc_a_11B3		; Jump if not zero
		mov	ax,data_b_00AA
		dec	ax
		push	ax
		push	si
		call	sub_a_103A
		mov	sp,bp
		or	ax,ax			; Zero ?
		jnz	loc_a_11B3		; Jump if not zero
		push	data_b_00AA
		push	si
		call	sub_a_103A
		mov	sp,bp
		or	ax,ax			; Zero ?
		jnz	loc_a_11B3		; Jump if not zero
		mov	ax,data_b_00AA
		inc	ax
		push	ax
		push	si
		call	sub_a_103A
		mov	sp,bp
		or	ax,ax			; Zero ?
		jnz	loc_a_11B3		; Jump if not zero

		; wait for 'x' key
loc_a_11AB:
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)
		cmp	ax,78h			; check 'x'
		jne	loc_a_11AB		; Jump if not equal
loc_a_11B3:
		pop	bp
		pop	si
		retn
sub_a_1161	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_11B6	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		cmp	data_b_00BC,0
		je	loc_a_11CA		; Jump if equal
		mov	data_b_3DD8,1DFAh
		jmp	short loc_a_11D0
loc_a_11CA:
		mov	data_b_3DD8,1DCAh
loc_a_11D0:
		mov	ax,[bp+0Ah]
		mul	data_b_00AA		; dx:ax = data * ax
		mov	di,ax
		add	di,[bp+8]
		mov	data_b_3D10,0
		mov	data_b_3D34,0
		mov	data_b_3DB6,1
		mov	data_b_3DD6,0
		mov	bx,di
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1262		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
		add	bx,2
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_125C		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
		add	bx,3
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1256		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
		add	bx,4
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1250		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_126A
loc_a_1250:
		or	si,si			; Zero ?
		jz	loc_a_126A		; Jump if zero
		jmp	short loc_a_1266
loc_a_1256:
		or	si,si			; Zero ?
		jz	loc_a_126A		; Jump if zero
		jmp	short loc_a_1266
loc_a_125C:
		or	si,si			; Zero ?
		jz	loc_a_126A		; Jump if zero
		jmp	short loc_a_1266
loc_a_1262:
		or	si,si			; Zero ?
		jz	loc_a_126A		; Jump if zero
loc_a_1266:
		inc	data_b_3DD6
loc_a_126A:
		mov	bx,di
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_12D8		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
;*		add	bx,0FFFEh
		db	 83h,0C3h,0FEh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_12D2		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
;*		add	bx,0FFFDh
		db	 83h,0C3h,0FDh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_12CC		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
;*		add	bx,0FFFCh
		db	 83h,0C3h,0FCh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_12C6		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_12E0
loc_a_12C6:
		or	si,si			; Zero ?
		jz	loc_a_12E0		; Jump if zero
		jmp	short loc_a_12DC
loc_a_12CC:
		or	si,si			; Zero ?
		jz	loc_a_12E0		; Jump if zero
		jmp	short loc_a_12DC
loc_a_12D2:
		or	si,si			; Zero ?
		jz	loc_a_12E0		; Jump if zero
		jmp	short loc_a_12DC
loc_a_12D8:
		or	si,si			; Zero ?
		jz	loc_a_12E0		; Jump if zero
loc_a_12DC:
		inc	data_b_3DD6
loc_a_12E0:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jg	loc_a_1301		; Jump if >
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3D34,ax
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3DB6,ax
loc_a_1301:
		mov	bx,data_b_3DD6
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DB6
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DD8
		mov	ax,[bx]
		add	data_b_3D10,ax
		mov	data_b_3DB6,1
		mov	data_b_3DD6,0
		mov	bx,data_b_00AA
		add	bx,di
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_133F		; Jump if equal
		jmp	loc_a_13C0
loc_a_133F:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		add	bx,di
		add	bx,data_b_00AA
;*		add	bx,0FFFEh
		db	 83h,0C3h,0FEh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_13BA		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		add	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
;*		add	bx,0FFFDh
		db	 83h,0C3h,0FDh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_13B4		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		add	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,data_b_00AA
;*		add	bx,0FFFCh
		db	 83h,0C3h,0FCh		;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_13AE		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_13C8
loc_a_13AE:
		or	si,si			; Zero ?
		jz	loc_a_13C8		; Jump if zero
		jmp	short loc_a_13C4
loc_a_13B4:
		or	si,si			; Zero ?
		jz	loc_a_13C8		; Jump if zero
		jmp	short loc_a_13C4
loc_a_13BA:
		or	si,si			; Zero ?
		jz	loc_a_13C8		; Jump if zero
		jmp	short loc_a_13C4
loc_a_13C0:
		or	si,si			; Zero ?
		jz	loc_a_13C8		; Jump if zero
loc_a_13C4:
		inc	data_b_3DD6
loc_a_13C8:
		mov	bx,data_b_00AA
		dec	bx
		neg	bx
		add	bx,di
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_13E2		; Jump if equal
		jmp	loc_a_147E
loc_a_13E2:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		dec	bx
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		dec	ax
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_1408		; Jump if equal
		jmpn	loc_a_1478
loc_a_1408:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		dec	bx
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		dec	ax
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		dec	ax
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1472		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		dec	bx
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		dec	ax
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		dec	ax
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		dec	ax
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_146C		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_1486
loc_a_146C:
		or	si,si			; Zero ?
		jz	loc_a_1486		; Jump if zero
		jmp	short loc_a_1482
loc_a_1472:
		or	si,si			; Zero ?
		jz	loc_a_1486		; Jump if zero
		jmp	short loc_a_1482
loc_a_1478:
		or	si,si			; Zero ?
		jz	loc_a_1486		; Jump if zero
		jmp	short loc_a_1482
loc_a_147E:
		or	si,si			; Zero ?
		jz	loc_a_1486		; Jump if zero
loc_a_1482:
		inc	data_b_3DD6
loc_a_1486:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jg	loc_a_14A7		; Jump if >
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3D34,ax
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3DB6,ax
loc_a_14A7:
		mov	bx,data_b_3DD6
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DB6
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DD8
		mov	ax,[bx]
		add	data_b_3D10,ax
		mov	data_b_3DB6,1
		mov	data_b_3DD6,0
		mov	bx,di
		add	bx,data_b_00AA
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_14E4		; Jump if equal
		jmpn	loc_a_155C
loc_a_14E4:
		inc	data_b_3DB6
		mov	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1556		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1550		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_154A		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_1564
loc_a_154A:
		or	si,si			; Zero ?
		jz	loc_a_1564		; Jump if zero
		jmp	short loc_a_1560
loc_a_1550:
		or	si,si			; Zero ?
		jz	loc_a_1564		; Jump if zero
		jmp	short loc_a_1560
loc_a_1556:
		or	si,si			; Zero ?
		jz	loc_a_1564		; Jump if zero
		jmp	short loc_a_1560
loc_a_155C:
		or	si,si			; Zero ?
		jz	loc_a_1564		; Jump if zero
loc_a_1560:
		inc	data_b_3DD6
loc_a_1564:
		mov	bx,data_b_00AA
		neg	bx
		add	bx,di
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_157D		; Jump if equal
		jmp	loc_a_160D
loc_a_157D:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1607		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_1601		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_15FB		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_1615
loc_a_15FB:
		or	si,si			; Zero ?
		jz	loc_a_1615		; Jump if zero
		jmp	short loc_a_1611
loc_a_1601:
		or	si,si			; Zero ?
		jz	loc_a_1615		; Jump if zero
		jmp	short loc_a_1611
loc_a_1607:
		or	si,si			; Zero ?
		jz	loc_a_1615		; Jump if zero
		jmp	short loc_a_1611
loc_a_160D:
		or	si,si			; Zero ?
		jz	loc_a_1615		; Jump if zero
loc_a_1611:
		inc	data_b_3DD6
loc_a_1615:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jg	loc_a_1636		; Jump if >
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3D34,ax
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3DB6,ax
loc_a_1636:
		mov	bx,data_b_3DD6
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DB6
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DD8
		mov	ax,[bx]
		add	data_b_3D10,ax
		mov	data_b_3DB6,1
		mov	data_b_3DD6,0
		mov	bx,data_b_00AA
		add	bx,di
		inc	bx
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		 ; 1=WHITE move, 0=BLACK move
		je	loc_a_1674		; Jump if equal
		jmp	loc_a_16F5
loc_a_1674:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		add	bx,di
		add	bx,data_b_00AA
		add	bx,2
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_16EF		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		add	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,3
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_16E9		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		add	bx,di
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,data_b_00AA
		add	bx,4
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_16E3		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_16FD
loc_a_16E3:
		or	si,si			; Zero ?
		jz	loc_a_16FD		; Jump if zero
		jmp	short loc_a_16F9
loc_a_16E9:
		or	si,si			; Zero ?
		jz	loc_a_16FD		; Jump if zero
		jmp	short loc_a_16F9
loc_a_16EF:
		or	si,si			; Zero ?
		jz	loc_a_16FD		; Jump if zero
		jmp	short loc_a_16F9
loc_a_16F5:
		or	si,si			; Zero ?
		jz	loc_a_16FD		; Jump if zero
loc_a_16F9:
		inc	data_b_3DD6
loc_a_16FD:
		mov	bx,data_b_00AA
		inc	bx
		neg	bx
		add	bx,di
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_1717		; Jump if equal
		jmp	loc_a_17B3
loc_a_1717:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		inc	bx
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		inc	ax
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		je	loc_a_173D		; Jump if equal
		jmpn	loc_a_17AD
loc_a_173D:
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		inc	bx
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		inc	ax
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		inc	ax
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_17A7		; Jump if not equal
		inc	data_b_3DB6
		mov	bx,data_b_00AA
		inc	bx
		neg	bx
		add	bx,di
		mov	ax,data_b_00AA
		inc	ax
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		inc	ax
		neg	ax
		add	bx,ax
		mov	ax,data_b_00AA
		inc	ax
		neg	ax
		add	bx,ax
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_b_3DF8[bx]
		mov	ax,si
		cmp	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		jne	loc_a_17A1		; Jump if not equal
		inc	data_b_3DB6
		jmp	short loc_a_17BB
loc_a_17A1:
		or	si,si			; Zero ?
		jz	loc_a_17BB		; Jump if zero
		jmp	short loc_a_17B7
loc_a_17A7:
		or	si,si			; Zero ?
		jz	loc_a_17BB		; Jump if zero
		jmp	short loc_a_17B7
loc_a_17AD:
		or	si,si			; Zero ?
		jz	loc_a_17BB		; Jump if zero
		jmp	short loc_a_17B7
loc_a_17B3:
		or	si,si			; Zero ?
		jz	loc_a_17BB		; Jump if zero
loc_a_17B7:
		inc	data_b_3DD6
loc_a_17BB:
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3DB6
		jg	loc_a_17DC		; Jump if >
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3D34,ax
		mov	ax,5
		sub	ax,data_b_00BC
		mov	data_b_3DB6,ax

loc_a_17DC:
		mov	bx,data_b_3DD6
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DB6
		shl	bx,1			; Shift w/zeros fill
		add	bx,data_b_3DD8
		mov	ax,[bx]
		add	data_b_3D10,ax
		cmp	data_b_00BC,0
		je	loc_a_1805		; Jump if equal
		mov	ax,data_b_3D10
		neg	ax
		mov	data_b_3D10,ax
loc_a_1805:
		pop	bp
		pop	di
		pop	si
		retn
sub_a_11B6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1809	proc	near
		push	si
		push	di
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		push	ax
		mov	ax,data_b_3DA8
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45E4
		shl	bx,1			; Shift w/zeros fill
		pop	ax
		mov	data_b_3DF8[bx],ax
		mov	data_b_3D3C,8300h
		mov	di,1
		jmp	short loc_a_1878
loc_a_1832:
		mov	ax,di
		mul	data_b_00AA		; dx:ax = data * ax
		mov	data_b_3D32,ax
		mov	si,1
		jmp	short loc_a_1871
loc_a_1840:
		mov	bx,data_b_3D32
		add	bx,si
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_3DF8[bx],0
		jne	loc_a_1870		; Jump if not equal
		mov	ax,data_b_3D32
		add	ax,si
		push	ax
		call	sub_a_1003
		pop	cx
		or	ax,ax			; Zero ?
		jz	loc_a_1870		; Jump if zero
		push	di
		push	si
		call	sub_a_11B6
		pop	cx
		pop	cx
		mov	ax,data_b_3D10
		cmp	ax,data_b_3D3C
		jle	loc_a_1870		; Jump if < or =
		mov	data_b_3D3C,ax
loc_a_1870:
		inc	si
loc_a_1871:
		cmp	si,data_b_009E		; Board size
		jle	loc_a_1840		; Jump if < or =
		inc	di
loc_a_1878:
		cmp	di,data_b_00A0
		jle	loc_a_1832		; Jump if < or =
		mov	ax,data_b_3DA8
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45E4
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_3DF8[bx],0
		mov	ax,data_b_3D3C
		mov	data_b_3D10,ax
		pop	di
		pop	si
		retn
sub_a_1809	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_189C	proc	near
		mov	data_b_45CC,0
		mov	data_b_45EC,0
		mov	data_b_3DEA,8300h
		mov	data_b_3DA6,0
		mov	data_b_3DA8,1
		jmp	loc_a_19C4
loc_a_18BD:
		mov	ax,data_b_00AA
		add	data_b_3DA6,ax
		mov	data_b_45E4,1
		jmp	loc_a_19B4
loc_a_18CD:
		mov	bx,data_b_3DA6
		add	bx,data_b_45E4
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_3DF8[bx],0
		je	loc_a_18E1		; Jump if equal
		jmp	loc_a_19B0
loc_a_18E1:
		mov	ax,data_b_3DA6
		add	ax,data_b_45E4
		push	ax
		call	sub_a_1003
		pop	cx
		or	ax,ax			; Zero ?
		jnz	loc_a_18F4		; Jump if not zero
		jmp	loc_a_19B0
loc_a_18F4:
		push	data_b_3DA8
		push	data_b_45E4
		call	sub_a_11B6
		pop	cx
		pop	cx
		mov	ax,data_b_3D10
		mov	data_b_3DE0,ax
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		mov	data_b_45E2,ax		; 1=WHITE move, 0=BLACK move
		cmp	data_b_00AE,1
		jne	loc_a_1946		; Jump if not equal
		push	data_b_3DA8
		push	data_b_45E4
		call	sub_a_11B6
		pop	cx
		pop	cx
		cmp	data_b_00BC,0
		je	loc_a_193B		; Jump if equal
		mov	ax,data_b_3D10
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		add	data_b_3DE0,ax
		jmp	short loc_a_1952
loc_a_193B:
		mov	ax,data_b_3D10
		sar	ax,1			; Shift w/sign fill
		add	data_b_3DE0,ax
		jmp	short loc_a_1952
loc_a_1946:
		call	sub_a_1809
		mov	ax,data_b_3D10
		sar	ax,1			; Shift w/sign fill
		sub	data_b_3DE0,ax
loc_a_1952:
		cmp	data_b_45E4,5
		jle	loc_a_197C		; Jump if < or =
		mov	ax,data_b_009E		; Board size
		add	ax,0FFFBh
		cmp	ax,data_b_45E4
		jle	loc_a_197C		; Jump if < or =
		cmp	data_b_3DA8,5
		jle	loc_a_197C		; Jump if < or =
		mov	ax,data_b_00A0
		add	ax,0FFFBh
		cmp	ax,data_b_3DA8
		jle	loc_a_197C		; Jump if < or =
		inc	data_b_3DE0
loc_a_197C:
		call	sub_a_2B36
		mov	bx,3
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		add	data_b_3DE0,dx
		mov	ax,bx
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		mov	data_b_45E2,ax		; 1=WHITE move, 0=BLACK move
		mov	ax,data_b_3DE0
		cmp	ax,data_b_3DEA
		jle	loc_a_19B0		; Jump if < or =
		mov	ax,data_b_45E4
		mov	data_b_45CC,ax
		mov	ax,data_b_3DA8
		mov	data_b_45EC,ax
		mov	ax,data_b_3DE0
		mov	data_b_3DEA,ax
		call	sub_a_0B81
loc_a_19B0:
		inc	data_b_45E4
loc_a_19B4:
		mov	ax,data_b_45E4
		cmp	ax,data_b_009E		; Board size
		jg	loc_a_19C0		; Jump if >
		jmp	loc_a_18CD
loc_a_19C0:
		inc	data_b_3DA8
loc_a_19C4:
		mov	ax,data_b_3DA8
		cmp	ax,data_b_00A0
		jg	loc_ret_a_19D0		; Jump if >
		jmp	loc_a_18BD

loc_ret_a_19D0:
		retn
sub_a_189C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_19D1	proc	near
		call	sub_a_189C
		cmp	data_b_45CC,0
		jg	loc_a_19DE		; Jump if >
		jmp	loc_a_1AC7
loc_a_19DE:
		cmp	data_b_45EC,0
		jg	loc_a_19E8		; Jump if >
		jmp	loc_a_1AC7
loc_a_19E8:
		mov	ax,data_b_45CC
		mov	data_b_45E4,ax
		mov	ax,data_b_45EC
		mov	data_b_3DA8,ax
		push	ax
		push	data_b_45CC
		call	sub_a_11B6
		pop	cx
		pop	cx
		mov	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		push	ax
		mov	ax,data_b_45EC
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45CC
		shl	bx,1			; Shift w/zeros fill
		pop	ax
		mov	data_b_3DF8[bx],ax
		mov	ax,0FFFFh
		push	ax
		push	data_b_45EC
		push	data_b_45CC
		call	sub_a_0B2E
		add	sp,6
		mov	data_b_3D36,1
		jmp	short loc_a_1A88
loc_a_1A30:
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_01BD		; Wait ticks of system timer
		pop	cx
		cmp	data_b_00B6,0
		jne	loc_a_1A4E		; Jump if not equal
		mov	ax,1
		push	ax
		mov	ax,12Ch
		push	ax
		call	sub_a_04C3		; play tone
		pop	cx
		pop	cx
		jmp	short loc_a_1A51
loc_a_1A4E:
		call	sub_a_045B		; Wait for VSYNC
loc_a_1A51:
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		push	ax
		push	data_b_45EC
		push	data_b_45CC
		call	sub_a_0B2E
		add	sp,6
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_01BD		; Wait ticks of system timer
		pop	cx
		call	sub_a_045B		; Wait for VSYNC
		mov	ax,0FFFFh
		push	ax
		push	data_b_45EC
		push	data_b_45CC
		call	sub_a_0B2E
		add	sp,6
		inc	data_b_3D36
loc_a_1A88:
		cmp	data_b_3D36,4
		jl	loc_a_1A30		; Jump if <
		mov	ax,5
		push	ax			; PARAMETER_2
		mov	ax,1F6Ah
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx
		mov	ax,data_b_45CC
		mov	data_b_45DE,ax
		mov	ax,data_b_45EC
		mov	data_b_3DDC,ax
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3D34
		jg	loc_ret_a_1AE2		; Jump if >
		call	sub_a_0503		; Play 3 tones
		push	data_b_45EC
		push	data_b_45CC
		call	sub_a_1161
		pop	cx
		pop	cx
		jmp	short loc_ret_a_1AE2
loc_a_1AC7:
		mov	ax,7
		push	ax			; PARAMETER_2
		mov	ax,3Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
		mov	ax,1F72h
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
		mov	data_b_00B6,0

loc_ret_a_1AE2:
		retn
sub_a_19D1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1AE3	proc	near
		mov	data_b_3DA8,1
		jmp	short loc_a_1B44
loc_a_1AEB:
		mov	data_b_45E4,1
		jmp	short loc_a_1B37
loc_a_1AF3:
		mov	ax,data_b_3DA8
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45E4
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_3DF8[bx],0
		jne	loc_a_1B33		; Jump if not equal
		mov	ax,data_b_3DA8
		mul	data_b_00AA		; dx:ax = data * ax
		add	ax,data_b_45E4
		push	ax
		call	sub_a_1003
		pop	cx
		or	ax,ax			; Zero ?
		jz	loc_a_1B33		; Jump if zero
		inc	data_b_1E80
		mov	ax,4
		push	ax
		push	data_b_3DA8
		push	data_b_45E4
		call	sub_a_0B2E
		add	sp,6
loc_a_1B33:
		inc	data_b_45E4
loc_a_1B37:
		mov	ax,data_b_45E4
		cmp	ax,data_b_009E		; Board size
		jle	loc_a_1AF3		; Jump if < or =
		inc	data_b_3DA8
loc_a_1B44:
		mov	ax,data_b_3DA8
		cmp	ax,data_b_00A0
		jle	loc_a_1AEB		; Jump if < or =
		cmp	data_b_1E80,0
		je	loc_ret_a_1B84		; Jump if equal
		call	sub_a_04E3		; Play tone
		mov	ax,0Ch
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print text "Try THESE! Hit SPACE."
		mov	ax,5
		push	ax			; PARAMETER_2
		mov	ax,1F84h		; text "Try THESE! Hit SPACE."
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx

		; wait for space key
loc_a_1B6C:
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)

; !!! Picopad modification: use Enter key

		cmp	ax,0Dh ;20h			; space key
		jne	loc_a_1B6C		; Jump if not equal

		mov	ax,5
		push	ax			; PARAMETER_2
		mov	ax,1F9Ah		; text "    "
		push	ax			; PARAMETER_1
		call	sub_a_06F2		; Print text at given position
		pop	cx
		pop	cx
		call	sub_a_0EA5

loc_ret_a_1B84:
		retn
sub_a_1AE3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1B85	proc	near
		call	sub_a_0CBE
		mov	ax,data_b_009E		; Board size
		mov	bx,2
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_45DE,ax
		mov	ax,data_b_00A0
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_3DDC,ax
		mov	data_b_45E2,1		; 1=WHITE move, 0=BLACK move
		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h
		call	sub_a_0EA5
		cmp	data_b_00B0,0
		je	loc_a_1BB7		; Jump if equal
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		call	sub_a_0785
		pop	cx
loc_a_1BB7:
		mov	data_b_00B8,0
		mov	ax,0Eh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx
loc_a_1BC5:
		mov	data_b_45CA,0		; keyboard scan code
		cmp	data_b_00B2,0
		je	loc_a_1BE4		; Jump if equal
		mov	ax,4
		push	ax
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_0B2E
		add	sp,6
loc_a_1BE4:
		call	sub_a_0BA9
		call	sub_a_07A1

		; Esc key
loc_a_1BEA:
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)
		mov	data_b_45CA,ax		; keyboard scan code
		cmp	ax,1Bh			; Esc key
		jne	loc_a_1BF8		; Jump if not equal
		jmp	loc_ret_a_1FC9

		; Ctrl+Break or Ctrl+C key
loc_a_1BF8:
		cmp	ax,3
		jne	loc_a_1C00		; Jump if not equal
		jmp	loc_ret_a_1FC9

loc_a_1C00:
		cmp	data_b_00B6,0
		je	loc_a_1C11		; Jump if equal
		or	ax,ax			; Zero ?
		jz	loc_a_1C11		; Jump if zero
		mov	data_b_00B6,0
loc_a_1C11:
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		and	ax,4
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		cmp	dx,data_b_1E84
		jne	loc_a_1C27		; Jump if not equal
		cmp	ax,data_b_1E82
		je	loc_a_1C7C		; Jump if equal
loc_a_1C27:
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		and	ax,4
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		mov	data_b_1E84,dx
		mov	data_b_1E82,ax
		call	sub_a_045B		; Wait for VSYNC
		cmp	data_b_00B2,0
		je	loc_a_1C7C		; Jump if equal
		call	sub_a_07B1
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		and	ax,4
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		or	dx,ax
		jz	loc_a_1C67		; Jump if zero
		mov	ax,0FFFFh
		push	ax
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_0B2E
		add	sp,6
		jmp	short loc_a_1C79
loc_a_1C67:
		mov	ax,4
		push	ax
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_0B2E
		add	sp,6
loc_a_1C79:
		call	sub_a_07A1
loc_a_1C7C:
		cmp	data_b_00B2,0
		jne	loc_a_1CA5		; Jump if not equal
		push	data_b_45CA		; keyboard scan code
		mov	ax,1FB0h
		push	ax
		call	sub_a_072C
		pop	cx
		pop	cx
		or	ax,ax			; Zero ?
		jl	loc_a_1CA5		; Jump if <
		xor	ax,ax			; Zero register
		mov	data_b_45E0,ax		; key from keyboard
		mov	data_b_45CA,ax		; keyboard scan code
		mov	data_b_00B2,1
		call	sub_a_0503		; Play 3 tones
loc_a_1CA5:
		push	data_b_45CA		; keyboard scan code
		mov	ax,1FB8h
		push	ax
		call	sub_a_072C
		pop	cx
		pop	cx
		mov	data_b_3DB4,ax
		cmp	data_b_00B0,0
		jne	loc_a_1CBF		; Jump if not equal
		jmp	loc_a_1D68
loc_a_1CBF:
		call	sub_a_07C1
		cmp	data_b_3D30,1
		jne	loc_a_1D1D		; Jump if not equal
		push	data_b_3D38
		push	data_b_45C8
		call	sub_a_07E8
		pop	cx
		pop	cx
		mov	data_b_3D36,ax
		or	ax,ax			; Zero ?
		jnz	loc_a_1CE0		; Jump if not zero
		jmp	loc_a_1D68
loc_a_1CE0:
		call	sub_a_07B1
		mov	ax,0FFFFh
		push	ax
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_0B2E
		add	sp,6
		call	sub_a_07A1
		mov	ax,data_b_3D36
		cwd				; Word to double word
		idiv	data_b_00AA		; ax,dxrem=dx:ax/data
		mov	data_b_45DE,dx
		mov	ax,data_b_3D36
		cwd				; Word to double word
		idiv	data_b_00AA		; ax,dxrem=dx:ax/data
		mov	data_b_3DDC,ax
		mov	data_b_3DB4,64h
		mov	data_b_45CA,0Dh		; keyboard scan code
		jmp	short loc_a_1D68
loc_a_1D1D:
		cmp	data_b_3D30,2
		jne	loc_a_1D68		; Jump if not equal
		mov	ax,1FDBh
		push	ax
		mov	ax,3D3Eh
		push	ax
		mov	ax,6
		push	ax
		mov	ax,14h
		push	ax
		call	sub_a_09B9
		add	sp,8
		mov	data_b_3D36,ax
		mov	ax,0Ch
		push	ax
		mov	ax,14h
		push	ax
		call	sub_a_0EE2
		pop	cx
		pop	cx
		cmp	data_b_3D36,0
		je	loc_a_1D65		; Jump if equal
		mov	data_b_3DB4,64h
		mov	ax,data_b_45E0		; key from keyboard
		mov	data_b_45CA,ax		; keyboard scan code
		cmp	ax,71h
		jne	loc_a_1D65		; Jump if not equal
		jmp	loc_ret_a_1FC9
loc_a_1D65:
		call	sub_a_07A1
loc_a_1D68:
		cmp	data_b_3DB4,0
		jge	loc_a_1D79		; Jump if > or =
		cmp	data_b_00B6,0
		jne	loc_a_1D79		; Jump if not equal
		jmp	loc_a_1BEA
loc_a_1D79:
		call	sub_a_07B1
		cmp	data_b_3DB4,7
		jle	loc_a_1D88		; Jump if < or =
		sub	data_b_3DB4,8
loc_a_1D88:
		mov	ax,0FFFFh
		push	ax
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_0B2E
		add	sp,6
		cmp	data_b_3DB4,8
		jge	loc_a_1E04		; Jump if > or =
		cmp	data_b_00B6,0
		jne	loc_a_1E04		; Jump if not equal
		mov	bx,data_b_3DB4
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_1E2A[bx]
		mov	data_b_3D12,ax
		mov	bx,data_b_3DB4
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_1E52[bx]
		mov	data_b_3DE8,ax
		mov	ax,data_b_3D12
		add	data_b_45DE,ax
		mov	ax,data_b_3DE8
		add	data_b_3DDC,ax
		cmp	data_b_45DE,1
		jl	loc_a_1DF3		; Jump if <
		cmp	data_b_3DDC,1
		jl	loc_a_1DF3		; Jump if <
		mov	ax,data_b_45DE
		cmp	ax,data_b_009E		; Board size
		jg	loc_a_1DF3		; Jump if >
		mov	ax,data_b_3DDC
		cmp	ax,data_b_00A0
		jg	loc_a_1DF3		; Jump if >
		jmp	loc_a_1BC5
loc_a_1DF3:
		mov	ax,data_b_3D12
		sub	data_b_45DE,ax
		mov	ax,data_b_3DE8
		sub	data_b_3DDC,ax
		jmp	loc_a_1BC5
loc_a_1E04:
		cmp	data_b_45CA,0Dh		; keyboard scan code
		je	loc_a_1E0E		; Jump if equal
		jmp	loc_a_1ECF
loc_a_1E0E:
		mov	ax,data_b_3DDC
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45DE
		shl	bx,1			; Shift w/zeros fill
		cmp	data_b_3DF8[bx],0
		je	loc_a_1E27		; Jump if equal
		jmp	loc_a_1ECF
loc_a_1E27:
		mov	ax,data_b_3DDC
		mul	data_b_00AA		; dx:ax = data * ax
		add	ax,data_b_45DE
		push	ax
		call	sub_a_1003
		pop	cx
		or	ax,ax			; Zero ?
		jnz	loc_a_1E3E		; Jump if not zero
		jmp	loc_a_1ECF
loc_a_1E3E:
		mov	ax,data_b_45DE
		mov	data_b_45E4,ax
		mov	ax,data_b_3DDC
		mov	data_b_3DA8,ax
		push	ax
		push	data_b_45DE
		call	sub_a_11B6
		pop	cx
		pop	cx
		mov	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		push	ax
		mov	ax,data_b_3DDC
		mul	data_b_00AA		; dx:ax = data * ax
		mov	bx,ax
		add	bx,data_b_45DE
		shl	bx,1			; Shift w/zeros fill
		pop	ax
		mov	data_b_3DF8[bx],ax
		call	sub_a_045B		; Wait for VSYNC
		mov	ax,0FFFFh
		push	ax
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_0B2E
		add	sp,6
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3D34
		jg	loc_a_1EA1		; Jump if >
		call	sub_a_0503		; Play 3 tones
		push	data_b_3DDC
		push	data_b_45DE
		call	sub_a_1161
		pop	cx
		pop	cx
		jmp	loc_ret_a_1FC9
loc_a_1EA1:
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		mov	data_b_45E2,ax		; 1=WHITE move, 0=BLACK move
		cmp	data_b_00B8,0
		jne	loc_a_1ECF		; Jump if not equal
		call	sub_a_19D1
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3D34
		jg	loc_a_1EC5		; Jump if >
		jmp	loc_ret_a_1FC9
loc_a_1EC5:
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		mov	data_b_45E2,ax		; 1=WHITE move, 0=BLACK move
loc_a_1ECF:
		cmp	data_b_45CA,3Fh		; keyboard scan code
		jne	loc_a_1EE0		; Jump if not equal
		mov	ax,1
		sub	ax,data_b_00B8
		mov	data_b_00B8,ax
loc_a_1EE0:
		cmp	data_b_45CA,61h		; keyboard scan code
		je	loc_a_1EEE		; Jump if equal
		cmp	data_b_45CA,3Dh		; keyboard scan code
		jne	loc_a_1EF4		; Jump if not equal
loc_a_1EEE:
		mov	data_b_00B6,1
loc_a_1EF4:
		cmp	data_b_00B6,0
		je	loc_a_1F01		; Jump if equal
		mov	data_b_45CA,67h		; keyboard scan code
loc_a_1F01:
		cmp	data_b_45CA,67h		; keyboard scan code
		je	loc_a_1F0F		; Jump if equal
		cmp	data_b_45CA,3Ch		; keyboard scan code
		jne	loc_a_1F2C		; Jump if not equal
loc_a_1F0F:
		call	sub_a_19D1
		mov	ax,5
		sub	ax,data_b_00BC
		cmp	ax,data_b_3D34
		jg	loc_a_1F22		; Jump if >
		jmp	loc_ret_a_1FC9
loc_a_1F22:
		mov	ax,3
		sub	ax,data_b_45E2		; 1=WHITE move, 0=BLACK move
		mov	data_b_45E2,ax		; 1=WHITE move, 0=BLACK move
loc_a_1F2C:
		cmp	data_b_45CA,6Eh		; keyboard scan code
		jne	loc_a_1F57		; Jump if not equal
		call	sub_a_0CBE
		mov	ax,data_b_009E		; Board size
		mov	bx,2
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_45DE,ax
		mov	ax,data_b_00A0
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_3DDC,ax
		mov	data_b_45E2,1		; 1=WHITE move, 0=BLACK move
		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h
		call	sub_a_0EA5
loc_a_1F57:
		cmp	data_b_45CA,3Bh		; keyboard scan code
		jne	loc_a_1F61		; Jump if not equal
		call	sub_a_1AE3
loc_a_1F61:
		cmp	data_b_45CA,3Eh		; keyboard scan code
		je	loc_a_1F6F		; Jump if equal
		cmp	data_b_45CA,69h		; keyboard scan code
		jne	loc_a_1F79		; Jump if not equal
loc_a_1F6F:
		mov	ax,3
		sub	ax,data_b_00AE
		mov	data_b_00AE,ax
loc_a_1F79:
		; F9 toggle cursor
		cmp	data_b_45CA,43h		; keyboard scan code
		jne	loc_a_1F8A		; Jump if not equal
		mov	ax,1
		sub	ax,data_b_00B2
		mov	data_b_00B2,ax
loc_a_1F8A:
		; F10 help
		cmp	data_b_45CA,44h		; F10	; keyboard scan code
		jne	loc_a_1F9A		; Jump if not equal
		call	sub_a_2613		; Print help
		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h
		call	sub_a_0EA5
loc_a_1F9A:
		cmp	data_b_45CA,2Ah		; keyboard scan code
		je	loc_a_1FA4		; Jump if equal
		jmp	loc_a_1BC5
loc_a_1FA4:
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		call	sub_a_215F		; Intro screen, select graphics card
		pop	cx
loc_a_1FAB:

; !!! Picopad modification - skip shareware info
		jmp	short skip_share

		; Print shareware screen "If you like..."
;		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		call	sub_a_1FDE		; Print shareware screen "If you like..."
		pop	cx

		; Print shareware text "NEW RELEASE..."
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		call	sub_a_2075		; Print shareware text "NEW RELEASE..."
		pop	cx

		; Print registration form
		call	sub_a_20F2		; Print registration form
		or	ax,ax			; Zero ?
		jnz	loc_a_1FAB		; Jump if not zero

skip_share:
		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h
		call	sub_a_0EA5
		jmp	loc_a_1BC5

loc_ret_a_1FC9:
		retn
sub_a_1B85	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play tones and wait for space key

sub_a_1FCA	proc	near

		call	sub_a_0503		; Play 3 tones

		; print text "Hit SPACE.."
		mov	ax,205Ah		; text "Hit space"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		; wait for a space
loc_a_1FD5:
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)

; !!! Picopad modification: use Enter key

		cmp	ax,0Dh ;20h
		jne	loc_a_1FD5		; Jump if not equal
		retn
sub_a_1FCA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print shareware screen "If you like..."

sub_a_1FDE	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		xor	ax,ax			; Zero register

		push	ax
		mov	ax,2
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,1
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,2
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,8
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,9
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,0Dh
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,0Eh
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,15h
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		mov	ax,19h
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		; print text "If you like..."
		mov	ax,2085h		; test "If you like this program...
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		cmp	word ptr [bp+PARAMETER_1],0
		jne	loc_a_2073		; Jump if not equal

		mov	ax,19h
		push	ax			; PARAMETER_2
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		mov	sp,bp
		call	sub_a_1FCA		; Play tones and wait for space key
loc_a_2073:
		pop	bp
		retn
sub_a_1FDE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print shareware text "NEW RELEASE..."

sub_a_2075	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		xor	ax,ax			; Zero register
		push	ax
		mov	ax,2
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,1
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,8
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,9
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,0Dh
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,0Eh
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,16h
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,19h
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		; Print text "NEW RELEASE..."
		mov	ax,2681h		; text "NEW RELEASE..."
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		cmp	word ptr [bp+PARAMETER_1],0
		jne	loc_a_20F0		; Jump if not equal
		call	sub_a_1FCA		; Play tones and wait for space key
loc_a_20F0:
		pop	bp
		retn
sub_a_2075	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print registration form

sub_a_20F2	proc	near
		xor	ax,ax			; Zero register
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		pop	cx
		pop	cx

		; print text "If you have a printer..."
		mov	ax,2CEDh		; text "If you have a printer..."
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,0Ah
		push	ax			; PARAMETER_2
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx
loc_a_2113:
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)
		mov	data_b_45E0,ax		; key from keyboard
		cmp	ax,21h			; "!" key
		jne	loc_a_2123		; Jump if not equal
		mov	ax,1
		jmp	short loc_ret_a_215E
loc_a_2123:
		cmp	data_b_45E0,0Dh		; key from keyboard
		jne	loc_a_2131		; Jump if not equal
		mov	al,0Ah
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
loc_a_2131:
		cmp	data_b_45E0,8		; key from keyboard
		jne	loc_a_2146		; Jump if not equal
		mov	al,8
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
		mov	al,20h			; ' '
		push	ax			; PARAMETER_1
		call	sub_a_0607		; Print character
		pop	cx
loc_a_2146:
		cmp	data_b_45E0,0		; key from keyboard
		je	loc_a_2155		; Jump if equal
		push	data_b_45E0		; PARAMETER_1 ; key from keyboard
		call	sub_a_0607		; Print character
		pop	cx
loc_a_2155:
		cmp	data_b_45E0,1Bh		; key from keyboard
		jne	loc_a_2113		; Jump if not equal
		xor	ax,ax			; Zero register

loc_ret_a_215E:
		retn
sub_a_20F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Intro screen, select graphics card

sub_a_215F	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		xor	ax,ax			; Zero register
		push	ax
		mov	ax,0Eh
		push	ax
		call	sub_a_0571
		mov	sp,bp
		mov	ax,19h
		push	ax
		mov	ax,0Fh
		push	ax
		call	sub_a_0571
		mov	sp,bp

		; print intro screen
		mov	ax,302Ch		; intro screen "This version... data_b_302C
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		cmp	word ptr [bp+PARAMETER_1],0
		jne	loc_a_218E		; Jump if not equal
		call	sub_a_1FCA		; Play tones and wait for space key
		jmp	short loc_a_21CA
loc_a_218E:
		mov	ax,19h
		push	ax			; PARAMETER_2
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		mov	sp,bp

		; print text "Do you want CGA,...
		mov	ax,33C7h		; text "Do you want CGA,... data_b_33C7
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
		call	sub_a_0503		; Play 3 tones

loc_a_21A6:

; !!! Picopad modification - select CGA graphics card
		mov	ax,63h
;		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)

		mov	data_b_45E0,ax		; key from keyboard
		cmp	ax,60h
		jge	loc_a_21B6		; Jump if > or =
		add	data_b_45E0,20h		; key from keyboard - convert to lower case
loc_a_21B6:
		push	data_b_45E0		; key from keyboard
		mov	ax,3402h
		push	ax
		call	sub_a_072C
		mov	sp,bp
		mov	data_b_1E7C,ax
		or	ax,ax			; Zero ?
		jl	loc_a_21A6		; Jump if <
loc_a_21CA:
		pop	bp
		retn
sub_a_215F	endp

			                        ;* No entry point to code
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+6]
		mov	ax,si
		and	ax,4
		sar	ax,1			; Shift w/sign fill
		mov	dx,si
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
		add	ax,dx
		mov	dx,si
;*		and	dx,10h
		db	 81h,0E2h, 10h, 00h	;  Fixup - byte match
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
		add	ax,dx
		mov	dx,si
;*		and	dx,40h
		db	 81h,0E2h, 40h, 00h	;  Fixup - byte match
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
		add	ax,dx
		pop	bp
		pop	si
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_21FF	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		cmp	word ptr [bp+PARAMETER_1],0
		je	loc_a_2245		; Jump if equal
		cmp	data_b_1E7C,0
		je	loc_a_222A		; Jump if equal
		mov	data_b_00A2,3
		mov	data_b_00A4,12h
		mov	data_b_1E7A,0D8h
		mov	data_b_3DEC,19F1h
		jmp	loc_a_22C0
loc_a_222A:
		mov	data_b_00A2,3
		mov	data_b_00A4,0Ah
		mov	data_b_1E7A,1Eh
		mov	data_b_3DEC,1D51h
		jmpn	loc_a_22C0
loc_a_2245:
		cmp	data_b_1E7C,0
		je	loc_a_2287		; Jump if equal
		cmp	data_b_009E,0Ah		; Board size
		jge	loc_a_226D		; Jump if > or =
		mov	data_b_00A2,6
		mov	data_b_00A4,26h
		mov	data_b_1E7A,390h
		mov	data_b_3DEC,0BEh
		jmp	short loc_a_22C0
loc_a_226D:
		mov	data_b_00A2,3
		mov	data_b_00A4,12h
		mov	data_b_1E7A,0D8h
		mov	data_b_3DEC,128Eh
		jmp	short loc_a_22C0
loc_a_2287:
		cmp	data_b_009E,0Ah		; Board size
		jge	loc_a_22A8		; Jump if > or =
		mov	data_b_00A2,6
		mov	data_b_00A4,16h
		mov	data_b_1E7A,84h
		mov	data_b_3DEC,16C6h
		jmp	short loc_a_22C0
loc_a_22A8:
		mov	data_b_00A2,3
		mov	data_b_00A4,0Ah
		mov	data_b_1E7A,1Eh
		mov	data_b_3DEC,195Ah
loc_a_22C0:
		pop	bp
		retn
sub_a_21FF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print game setup

sub_a_22C2	proc	near
		mov	ax,data_b_009E		; Board size
		mov	data_b_00A0,ax
		add	ax,2
		mov	data_b_00AA,ax

		mov	ax,16h
		push	ax			; PARAMETER_2
		mov	ax,7
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		; print grid mode
		push	data_b_00BA		; PARAMETER_2
		mov	ax,3406h		; text "Grid-mode:"
		push	ax			; PARAMETER_1
		call	sub_a_06B3		; Print text and number
		pop	cx
		pop	cx

		; print board size
		push	data_b_009E		; PARAMETER_2	; Board size
		mov	ax,3412h		; text "F1 Board size:"
		push	ax			; PARAMETER_1
		call	sub_a_06B3		; Print text and number
		pop	cx
		pop	cx

		; print +/-
		mov	ax,3428h		; text "(+/-)"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		; print variant "4 in a line loses"
		cmp	data_b_00BC,0
		je	loc_a_230E		; Jump if equal
		mov	ax,3433h		; text "4 in a line loses"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
		jmp	short loc_ret_a_2316
loc_a_230E:
		; print variant "5 in a line wins"
		mov	ax,344Ch		; text "5 in a line wins"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

loc_ret_a_2316:
		retn
sub_a_22C2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2317	proc	near
		mov	data_b_45EA,1
		jmp	short loc_a_2353
loc_a_231F:
		call	sub_a_2B36
		mov	bx,3
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		push	dx
		mov	ax,1
		push	ax
		push	data_b_45EA
		call	sub_a_0AE4
		add	sp,6
		call	sub_a_2B36
		mov	bx,3
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		push	dx
		mov	ax,13h
		push	ax
		push	data_b_45EA
		call	sub_a_0AE4
		add	sp,6
		inc	data_b_45EA
loc_a_2353:
		cmp	data_b_45EA,1Ah
		jle	loc_a_231F		; Jump if < or =
		mov	data_b_3DF6,1
		jmp	short loc_a_2396
loc_a_2362:
		call	sub_a_2B36
		mov	bx,3
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		push	dx
		push	data_b_3DF6
		mov	ax,1
		push	ax
		call	sub_a_0AE4
		add	sp,6
		call	sub_a_2B36
		mov	bx,3
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		push	dx
		push	data_b_3DF6
		mov	ax,1Ah
		push	ax
		call	sub_a_0AE4
		add	sp,6
		inc	data_b_3DF6
loc_a_2396:
		cmp	data_b_3DF6,13h
		jle	loc_a_2362		; Jump if < or =
		mov	ax,3
		push	ax
		mov	ax,1
		push	ax
		push	ax
		call	sub_a_0AE4
		add	sp,6
		mov	ax,3
		push	ax
		mov	ax,13h
		push	ax
		mov	ax,1
		push	ax
		call	sub_a_0AE4
		add	sp,6
		mov	ax,3
		push	ax
		mov	ax,1
		push	ax
		mov	ax,1Ah
		push	ax
		call	sub_a_0AE4
		add	sp,6
		mov	ax,3
		push	ax
		mov	ax,13h
		push	ax
		mov	ax,1Ah
		push	ax
		call	sub_a_0AE4
		add	sp,6
		retn
sub_a_2317	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_23E3	proc	near
		mov	data_b_45EA,1
		jmp	short loc_a_241A
loc_a_23EB:
		mov	data_b_3DF6,1
		jmp	short loc_a_240F
loc_a_23F3:
		call	sub_a_2B36
		mov	bx,4
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		push	dx
		push	data_b_3DF6
		push	data_b_45EA
		call	sub_a_0AE4
		add	sp,6
		inc	data_b_3DF6
loc_a_240F:
		cmp	data_b_3DF6,13h
		jle	loc_a_23F3		; Jump if < or =
		inc	data_b_45EA
loc_a_241A:
		cmp	data_b_45EA,1Ah
		jle	loc_a_23EB		; Jump if < or =
		retn
sub_a_23E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2422	proc	near
		call	sub_a_2B36
		mov	bx,18h
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		add	dx,2
		mov	data_b_45EA,dx
		call	sub_a_2B36
		mov	bx,11h
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		add	dx,2
		mov	data_b_3DF6,dx
		call	sub_a_2B36
		mov	bx,3
		cwd				; Word to double word
		idiv	bx			; ax,dx rem=dx:ax/reg
		mov	data_b_3D36,dx
		call	sub_a_045B		; Wait for VSYNC
		call	sub_a_2B36
		test	ax,1
		jz	loc_a_2480		; Jump if zero
		push	data_b_3D36
		mov	ax,1
		push	ax
		push	data_b_45EA
		call	sub_a_0AE4
		add	sp,6
		push	data_b_3D36
		mov	ax,13h
		push	ax
		push	data_b_45EA
		call	sub_a_0AE4
		add	sp,6
		jmp	short loc_ret_a_24A4
loc_a_2480:
		push	data_b_3D36
		push	data_b_3DF6
		mov	ax,1
		push	ax
		call	sub_a_0AE4
		add	sp,6
		push	data_b_3D36
		push	data_b_3DF6
		mov	ax,1Ah
		push	ax
		call	sub_a_0AE4
		add	sp,6

loc_ret_a_24A4:
		retn
sub_a_2422	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_24A5	proc	near

LOCAL_2		=	-4			; bp+0FFFCh
LOCAL_1		=	-2			; bp+0FFFEh

		push	bp
		mov	bp,sp
		sub	sp,4
		mov	word ptr [bp+LOCAL_1],0
		mov	word ptr [bp+LOCAL_2],63h
loc_a_24B5:
		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h
		cmp	data_b_1E7C,0
		je	loc_a_24C7		; Jump if equal

		; set EGA videomode 10h
		mov	ax,10h
		push	ax			; PARAMETER_1
		call	sub_a_01EB		; Call INT 10h function
		pop	cx
loc_a_24C7:
		mov	ax,1
		push	ax
		call	sub_a_21FF
		pop	cx

		mov	ax,3
		push	ax			; PARAMETER_2
		mov	ax,1Ch
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print title "CONTAX"
		mov	ax,3465h		; text "CONTAX"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,0Eh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print text "Copyright"
		mov	ax,347Fh		; text "Copyright"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,0Ah
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print help "CONTAX is..."
		mov	ax,34C4h		; text "CONTAX is..."
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print text "Hit SPACE..."
		mov	ax,37B5h		; text "Hit SPACE...
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,0Bh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		call	sub_a_04E3		; Play tone
		call	sub_a_22C2		; Print game setup
		call	sub_a_2317
loc_a_252D:
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		and	ax,2
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		cmp	dx,[bp+LOCAL_1]
		jne	loc_a_2541		; Jump if not equal
		cmp	ax,[bp+LOCAL_2]
		je	loc_a_2558		; Jump if equal
loc_a_2541:
		call	sub_a_01A5		; Read system timer 0040:006C -> DX:AX
		and	ax,2
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		mov	[bp+LOCAL_1],dx
		mov	[bp+LOCAL_2],ax
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_2422
		pop	cx
loc_a_2558:
		call	sub_a_070A		; Input key from DOS keyboard, does not wait (AL = 0 if no key)
		mov	data_b_45E0,ax		; key from keyboard
		cmp	ax,3
		jne	loc_a_2566		; Jump if not equal
		jmp	loc_a_260F
loc_a_2566:
		cmp	ax,21h
		jne	loc_a_2580		; Jump if not equal

		mov	ax,4
		push	ax			; PARAMETER_2
		mov	ax,16h
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		; print text "CONTAX is Copyright..."
		mov	ax,37EDh		; text "CONTAX is Copyright..."
		push	ax
		call	sub_a_0628		; Print text
		pop	cx
loc_a_2580:
		cmp	data_b_45E0,3Ch		; key from keyboard
		jne	loc_a_2597		; Jump if not equal
		mov	ax,1
		sub	ax,data_b_00BC
		mov	data_b_00BC,ax
		call	sub_a_0503		; Play 3 tones
		call	sub_a_22C2		; Print game setup
loc_a_2597:
		cmp	data_b_45E0,3Bh		; key from keyboard
		jne	loc_a_25B5		; Jump if not equal
		call	sub_a_0503		; Play 3 tones
		inc	data_b_00BA
		cmp	data_b_00BA,3
		jle	loc_a_25B2		; Jump if < or =
		mov	data_b_00BA,0
loc_a_25B2:
		call	sub_a_22C2		; Print game setup
loc_a_25B5:
		cmp	data_b_45E0,2Dh		; key from keyboard
		jne	loc_a_25CA		; Jump if not equal
		cmp	data_b_009E,7		; Board size
		jle	loc_a_25CA		; Jump if < or =
		dec	data_b_009E		; Board size
		call	sub_a_22C2		; Print game setup
loc_a_25CA:
		cmp	data_b_45E0,2Bh		; key from keyboard
		jne	loc_a_25DF		; Jump if not equal
		cmp	data_b_009E,13h		; Board size
		jge	loc_a_25DF		; Jump if > or =
		inc	data_b_009E		; Board size
		call	sub_a_22C2		; Print game setup
loc_a_25DF:
		cmp	data_b_45E0,44h		; key from keyboard
		jne	loc_a_25EC		; Jump if not equal
		call	sub_a_2613		; Print help
		jmp	loc_a_24B5
loc_a_25EC:

; !!! Picopad modification: use Enter key

;		cmp	data_b_45E0,20h		; key from keyboard
		cmp	data_b_45E0,0Dh		; key from keyboard

		je	loc_a_25FD		; Jump if equal
		cmp	data_b_45E0,1Bh		; key from keyboard
		je	loc_a_25FD		; Jump if equal
		jmp	loc_a_252D
loc_a_25FD:
		call	sub_a_23E3
		mov	ax,0Ah
		push	ax			; PARAMETER_1
		call	sub_a_01BD		; Wait ticks of system timer
		pop	cx
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_21FF
		pop	cx
loc_a_260F:
		mov	sp,bp
		pop	bp
		retn
sub_a_24A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print help

sub_a_2613	proc	near

		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h

		mov	ax,1
		push	ax
		call	sub_a_21FF
		pop	cx

		mov	ax,3
		push	ax			; PARAMETER_2
		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		mov	ax,0Ah
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print title "CONTAX"
		mov	ax,381Bh		; text "CONTAX"
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,2
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print text "adds a new twist...
		mov	ax,382Bh		; text "adds a new twist...
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		mov	ax,7
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		; print text "Command Summary...
		mov	ax,3AC0h		; text "Command Summary...
		push	ax
		call	sub_a_0628		; Print text
		pop	cx

		call	sub_a_2317

		mov	ax,0Fh
		push	ax			; PARAMETER_1
		call	sub_a_0218		; Get EGA/VGA palette register
		pop	cx

		mov	ax,16h
		push	ax			; PARAMETER_2
		mov	ax,6
		push	ax			; PARAMETER_1
		call	sub_a_05D5		; Set text position
		pop	cx
		pop	cx

		call	sub_a_1FCA		; Play tones and wait for space key

		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_21FF
		pop	cx

		retn
sub_a_2613	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_267E	proc	near

		; check VSYNC
		call	sub_a_040C		; Check VSYNC support

		mov	data_b_3DEC,0BEh

		; set text videomode 3
		mov	ax,3
		push	ax			; PARAMETER_1
		call	sub_a_01EB		; Call INT 10h function
		pop	cx

		mov	ax,1
		push	ax			; PARAMETER_1
		call	sub_a_215F		; Intro screen, select graphics card
		pop	cx
		xor	ax,ax			; Zero register
		push	ax
		call	sub_a_21FF
		pop	cx
		call	sub_a_052B		; Set videomode EGA 10h or CGA 06h
loc_a_26A1:
		mov	data_b_00B4,0
		call	sub_a_24A5
		cmp	data_b_45E0,3		; key from keyboard
		je	loc_a_26E4		; Jump if equal
		cmp	data_b_45E0,1Bh		; key from keyboard
		je	loc_a_26CF		; Jump if equal
		mov	data_b_00B4,1
		call	sub_a_1B85
		cmp	data_b_45CA,3		; keyboard scan code
		je	loc_a_26E4		; Jump if equal
		cmp	data_b_45CA,3		; keyboard scan code
		jne	loc_a_26A1		; Jump if not equal
loc_a_26CF:

; !!! Picopad modification - skip shareware info
		jmp	short loc_a_26E4


		; Print shareware screen "If you like..."
;		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		call	sub_a_1FDE
		pop	cx

		; Print shareware text "NEW RELEASE..."
		xor	ax,ax			; Zero register
		push	ax			; PARAMETER_1
		call	sub_a_2075
		pop	cx

		; Print registration form
		call	sub_a_20F2		; Print registration form
		or	ax,ax			; Zero ?
		jnz	loc_a_26CF		; Jump if not zero
loc_a_26E4:

		; set text videomode 3
		mov	ax,3
		push	ax			; PARAMETER_1
		call	sub_a_01EB		; Call INT 10h function
		pop	cx
		retn
sub_a_267E	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		cmp	data_b_3C80,20h
		jne	loc_a_26FC		; Jump if not equal
		mov	ax,1
		jmp	short loc_a_270F
loc_a_26FC:
		mov	ax,[bp+4]
		mov	bx,data_b_3C80
		shl	bx,1			; Shift w/zeros fill
		mov	data_b_45EE[bx],ax
		inc	data_b_3C80
		xor	ax,ax			; Zero register
loc_a_270F:
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2711	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	ax,[bp+PARAMETER_1]
		mov	dx,sp
		sub	dx,100h
		cmp	ax,dx
		jae	loc_a_2726		; Jump if above or =
		mov	data_b_008E,ax
		jmp	short loc_a_272F
loc_a_2726:
		mov	data_b_0088,8
		mov	ax,0FFFFh
loc_a_272F:
		pop	bp
		retn
sub_a_2711	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2731	proc	near

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
		jnz	loc_a_2758		; Jump if not zero
		cmp	cx,sp
		jae	loc_a_2758		; Jump if above or =
		xchg	data_b_008E,ax
		jmp	short loc_a_2761
loc_a_2758:
		mov	data_b_0088,8
		mov	ax,0FFFFh
loc_a_2761:
		pop	bp
		retn
sub_a_2731	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		push	word ptr [bp+4]		; PARAMETER_1
		call	sub_a_2711
		pop	cx
		pop	bp
		retn
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	ax,[bp+4]
		cwd				; Word to double word
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_2731
		mov	sp,bp
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_277F	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
loc_a_2782:
		mov	bx,[bp+PARAMETER_1]
		cmp	byte ptr [bx],0
		je	loc_a_279E		; Jump if equal
		inc	word ptr [bp+PARAMETER_1]
		mov	al,[bx]
		les	bx,dword ptr [bp+PARAMETER_2]	; Load seg:offset ptr
		inc	word ptr [bp+PARAMETER_2]
		cmp	al,es:[bx]
		je	loc_a_2782		; Jump if equal
		xor	ax,ax			; Zero register
		jmp	short loc_a_27A1
loc_a_279E:
		mov	ax,1
loc_a_27A1:
		pop	bp
		retn	6
sub_a_277F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get pointer to font ES:BP (INT 1Fh), CX=char height, DL=number of rows

sub_a_27A5	proc	near
		mov	ax,1130h
		mov	bh,0
		mov	dl,0FFh
		call	sub_a_27B6	; call INT 10h
		mov	al,dl
		inc	al
		mov	ah,0
		retn
sub_a_27A5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; call INT 10h

sub_a_27B6	proc	near
		push	si
		push	di
		mov	data_b_462E,bp
		int	10h			; Video display   ah=functn 11h
						;  get font type bh info into
						;   cx=points,dl=rows, es:bp=ptr
		mov	bp,data_b_462E
		pop	di
		pop	si
		retn
sub_a_27B6	endp

; 27C5h - set videomode

			                        ;* No entry point to code
		; get current videomode
		mov	ah,0Fh
		call	sub_a_27B6		; call INT 10h
		push	ax			; PARAMETER_1
		call	sub_a_27E2		; Set videomode
		pop	cx

		; get character color
		mov	ah,8
		mov	bh,0
		call	sub_a_27B6		; call INT 10h
		and	ah,7Fh
		mov	data_b_3C87,ah
		mov	data_b_3C86,ah
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set videomode

sub_a_27E2	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
		mov	al,[bp+PARAMETER_1]
		cmp	al,3
		jbe	loc_a_27F2		; Jump if below or =
		cmp	al,7
		je	loc_a_27F2		; Jump if equal
		mov	al,3
loc_a_27F2:
		mov	data_b_3C88,al		; selected videomode

		; get current videomode
		mov	ah,0Fh
		call	sub_a_27B6		; call INT 10h
		mov	al,al
		cmp	al,data_b_3C88		; selected videomode
		je	loc_a_2812		; Jump if equal

		; set videomode
		mov	al,data_b_3C88		; selected videomode
		mov	ah,0
		call	sub_a_27B6		; call INT 10h
		mov	ah,0Fh
		call	sub_a_27B6		; call INT 10h
		mov	data_b_3C88,al		; selected videomode
loc_a_2812:
		mov	data_b_3C8A,ah
		cmp	byte ptr data_b_3C88,3	; selected videomode
		jbe	loc_a_2829		; Jump if below or =
		cmp	byte ptr data_b_3C88,7	; selected videomode
		je	loc_a_2829		; Jump if equal
		mov	ax,1
		jmp	short loc_a_282B
loc_a_2829:
		xor	ax,ax			; Zero register
loc_a_282B:
		mov	data_b_3C8B,al
		mov	byte ptr data_b_3C89,19h
		cmp	byte ptr data_b_3C88,7	; selected videomode
		je	loc_a_2859		; Jump if equal
		mov	dx,0F000h
		mov	ax,0FFEAh
		push	dx
		push	ax			; PARAMETER_2
		mov	ax,3C93h
		push	ax			; PARAMETER_1
		call	sub_a_277F
		or	ax,ax			; Zero ?
		jnz	loc_a_2859		; Jump if not zero
		call	sub_a_27A5		; Get pointer to font ES:BP (INT 1Fh), CX=char height, DL=number of rows
		or	ax,ax			; Zero ?
		jnz	loc_a_2859		; Jump if not zero
		mov	ax,1
		jmp	short loc_a_285B
loc_a_2859:
		xor	ax,ax			; Zero register
loc_a_285B:
		mov	data_b_3C8C,al
		cmp	byte ptr data_b_3C88,7	; selected videomode
		jne	loc_a_286A		; Jump if not equal
		mov	ax,0B000h
		jmp	short loc_a_286D
loc_a_286A:
		mov	ax,0B800h
loc_a_286D:
		mov	data_b_3C8F,ax
		mov	data_b_3C8D,0
		mov	al,0
		mov	data_b_3C83,al
		mov	data_b_3C82,al
		mov	al,data_b_3C8A
		add	al,0FFh
		mov	data_b_3C84,al
		mov	byte ptr data_b_3C85,18h
		pop	bp
		retn
sub_a_27E2	endp

		db	0C3h,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_288F	proc	near

PARAMETER_1	=	4			; bp+4

		push	bp
		mov	bp,sp
loc_a_2892:
		mov	ax,data_b_3C80
		dec	data_b_3C80
		or	ax,ax			; Zero ?
		jz	loc_a_28A9		; Jump if zero
		mov	bx,data_b_3C80
		shl	bx,1			; Shift w/zeros fill
		call	word ptr data_b_45EE[bx]	;*
		jmp	short loc_a_2892
loc_a_28A9:
		call	word ptr data_b_3C9A
		call	word ptr data_b_3C9C
		call	word ptr data_b_3C9E
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_0115		; Sub does not return here
sub_a_288F	endp

		db	 59h, 5Dh,0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; read port -> AX

sub_a_28BE	proc	near
		push	bp
		mov	bp,sp
		mov	dx,[bp+4]
		in	ax,dx			; port 0, DMA-1 bas&add ch 0
		pop	bp
		retn
sub_a_28BE	endp

; 28C7h:
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	dx,[bp+4]
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		xor	ah,ah			; Zero register
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Call INT xx function

sub_a_28D2	proc	near

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
		lea	ax,[bp+LOCAL_4]		; Load effective addr ... buffer to save segment registers
		push	ax
		call	sub_a_2B5B		; Save segment registers to buffer
		pop	cx
		lea	ax,[bp+LOCAL_4]		; Load effective addr
		push	ax
		push	word ptr [bp+PARAMETER_3]
		push	word ptr [bp+PARAMETER_2]
		push	word ptr [bp+PARAMETER_1]
		call	sub_a_28F7		; Call INT xx function
		add	sp,8
		mov	sp,bp
		pop	bp
		retn
sub_a_28D2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Call INT xx function

sub_a_28F7	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,0Eh
		push	ds

		; prepare address of program
		lea	cx,[bp-0Ah]		; Load effective addr
		mov	[bp-0Eh],cx		; address to call program in [BP-0Ah]
		mov	[bp-0Ch],ss

		; prepare instructino PUSH AX, INT xx, POP BP, RETF
		mov	byte ptr [bp-0Ah],55h	; 'U' instruction PUSH AX
		mov	byte ptr [bp-9],0CDh	; instruction INT
		mov	ax,[bp+8]		; interrupt number
		mov	[bp-8],al		; interrupt number
		mov	word ptr [bp-7],0CB5Dh	; instructions POP BP, RETF

		; INT 25h (disk read) and INT 26h (disk write) leaves flags in the stack
		cmp	al,25h			; '%'
		jb	loc_a_2935		; Jump if below
		cmp	al,26h			; '&'
		ja	loc_a_2935		; Jump if above

		mov	byte ptr [bp-7],36h	; '6' instruction SS:
		mov	word ptr [bp-6],68Fh	; instruction POP [addr]
		mov	[bp-4],cx		; address to POP
		mov	word ptr [bp-2],0CB5Dh	; instructions POP BP, RETF
loc_a_2935:
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
		jz	loc_a_298E		; Jump if zero
		push	ax
		push	ax
		call	sub_a_2994
		pop	ax
loc_a_298E:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_28F7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2994	proc	near
		push	si
		push	bp
		mov	bp,sp
		mov	si,[bp+6]
		or	si,si			; Zero ?
		jl	loc_a_29B3		; Jump if <
		cmp	si,58h
		jbe	loc_a_29A7		; Jump if below or =
loc_a_29A4:
		mov	si,offset data_b_0057	; ('bnormal program terminat')
loc_a_29A7:
		mov	data_b_3CA2,si
		mov	al,data_b_3CA4[si]
		cbw				; Convrt byte to word
		xchg	si,ax
		jmp	short loc_a_29C0
loc_a_29B3:
		neg	si
		cmp	si,22h
		ja	loc_a_29A4		; Jump if above
		mov	data_b_3CA2,0FFFFh
loc_a_29C0:
		mov	ax,si
		mov	data_b_0088,ax
		mov	ax,0FFFFh
		pop	bp
		pop	si
		retn	2
sub_a_2994	endp

			                        ;* No entry point to code
		mov	cl,3
		jmp	short loc_a_29DB
			                        ;* No entry point to code
		mov	cl,2
		jmp	short loc_a_29DB
		db	0B1h, 01h,0EBh, 02h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Divide

sub_a_29D9	proc	far
		xor	cx,cx			; Zero register
loc_a_29DB:
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
		jnz	loc_a_2A12		; Jump if not zero
		or	dx,dx			; Zero ?
		jns	loc_a_2A00		; Jump if not sign
		neg	dx
		neg	ax
		sbb	dx,si
		or	cl,4
loc_a_2A00:
		or	bp,bp			; Zero ?
		jns	loc_a_2A12		; Jump if not sign
		neg	bp
		neg	bx
		sbb	bp,si
		test	cl,2
		jnz	loc_a_2A12		; Jump if not zero
		xor	cl,4
loc_a_2A12:
		mov	di,bp
		or	di,dx
		jnz	loc_a_2A1E		; Jump if not zero
		div	bx			; ax,dx rem=dx:ax/reg
		xchg	si,dx
		jmp	short loc_a_2A3E
loc_a_2A1E:
		push	cx
		mov	cx,20h
		mov	di,si

locloop_a_2A24:
		shl	ax,1			; Shift w/zeros fill
		rcl	dx,1			; Rotate thru carry
		rcl	si,1			; Rotate thru carry
		rcl	di,1			; Rotate thru carry
		cmp	di,bp
		jb	loc_a_2A3B		; Jump if below
		ja	loc_a_2A36		; Jump if above
		cmp	si,bx
		jb	loc_a_2A3B		; Jump if below
loc_a_2A36:
		sub	si,bx
		sbb	di,bp
		inc	ax
loc_a_2A3B:
		loop	locloop_a_2A24		; Loop if cx > 0

		pop	cx
loc_a_2A3E:
		test	cl,2
		jz	loc_a_2A46		; Jump if zero
		xchg	si,ax
		mov	dx,di
loc_a_2A46:
		test	cl,4
		jz	loc_a_2A52		; Jump if zero
		neg	dx
		neg	ax
		sbb	dx,0
loc_a_2A52:
		pop	di
		pop	si
		pop	bp
		retf	8			; Return far
sub_a_29D9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A58	proc	near
		push	si
		xchg	si,ax
		xchg	dx,ax
		test	ax,ax
		jz	loc_a_2A61		; Jump if zero
		mul	bx			; dx:ax = reg * ax
loc_a_2A61:
		xchg	cx,ax
		test	ax,ax
		jz	loc_a_2A6A		; Jump if zero
		mul	si			; dx:ax = reg * ax
		add	cx,ax
loc_a_2A6A:
		xchg	si,ax
		mul	bx			; dx:ax = reg * ax
		add	dx,cx
		pop	si
		retf				; Return far
sub_a_2A58	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A71	proc	near
		push	si
		push	di
		push	bp
		mov	bp,sp
		sub	sp,4
		mov	di,[bp+8]
		or	di,di			; Zero ?
		jnz	loc_a_2A85		; Jump if not zero
		xor	ax,ax			; Zero register
		jmp	loc_a_2B07
loc_a_2A85:
		mov	ax,di
		add	ax,5
		and	ax,0FFFEh
		mov	di,ax
		mov	ax,data_b_3D02
		mov	[bp-4],ax
		mov	bx,[bp-4]
		mov	si,[bx+2]
loc_a_2A9B:
		mov	ax,[si]
		cmp	ax,di
		jb	loc_a_2ACE		; Jump if below
		mov	ax,[si]
		mov	dx,di
		add	dx,4
		cmp	ax,dx
		ja	loc_a_2AB7		; Jump if above
		mov	ax,[si+2]
		mov	bx,[bp-4]
		mov	[bx+2],ax
		jmp	short loc_a_2AC1
loc_a_2AB7:
		sub	[si],di
		mov	ax,[si]
		add	ax,si
		mov	si,ax
		mov	[si],di
loc_a_2AC1:
		mov	ax,[bp-4]
		mov	data_b_3D02,ax
		mov	ax,si
		add	ax,2
		jmp	short loc_a_2B07
loc_a_2ACE:
		cmp	si,data_b_3D02
		jne	loc_a_2AD6		; Jump if not equal
		jmp	short loc_a_2ADE
loc_a_2AD6:
		mov	[bp-4],si
		mov	si,[si+2]
		jmp	short loc_a_2A9B
loc_a_2ADE:
		mov	ax,di
		xor	dx,dx			; Zero register
		and	ax,0FFFFh
;*		and	dx,0
		db	 81h,0E2h, 00h, 00h	;  Fixup - byte match
		push	dx			; PARAMETER_2
		push	ax			; PARAMETER_1
		call	sub_a_2731
		pop	cx
		pop	cx
		mov	[bp-2],ax
;*		cmp	word ptr [bp-2],0FFFFh
		db	 83h, 7Eh,0FEh,0FFh	;  Fixup - byte match
		jnz	loc_a_2AFD		; Jump if not zero
		xor	ax,ax			; Zero register
		jmp	short loc_a_2B07
loc_a_2AFD:
		mov	si,[bp-2]
		mov	[si],di
		mov	ax,si
		add	ax,2
loc_a_2B07:
		mov	sp,bp
		pop	bp
		pop	di
		pop	si
		retn
sub_a_2A71	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B0D	proc	near

PARAMETER_1	=	4			; bp+4
PARAMETER_2	=	6			; bp+6

		push	bp
		mov	bp,sp
		mov	dx,[bp+PARAMETER_1]
		mov	ax,[bp+PARAMETER_2]
		out	dx,ax			; port 0, DMA-1 bas&add ch 0
		pop	bp
		retn
sub_a_2B0D	endp

			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	dx,[bp+4]
		mov	al,[bp+6]
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		pop	bp
		retn
			                        ;* No entry point to code
		push	bp
		mov	bp,sp
		mov	ax,[bp+4]
		xor	dx,dx			; Zero register
		mov	data_b_3D06,dx
		mov	data_b_3D04,ax
		pop	bp
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2B36	proc	near
		mov	dx,data_b_3D06
		mov	ax,data_b_3D04
		mov	cx,15Ah
		mov	bx,4E35h
		callf	sub_a_2A58
		add	ax,1
		adc	dx,0
		mov	data_b_3D06,dx
		mov	data_b_3D04,ax
		mov	ax,data_b_3D06
		and	ax,7FFFh
		retn
sub_a_2B36	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Save segment registers to buffer

sub_a_2B5B	proc	near
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
sub_a_2B5B	endp

data_a_2B70	dw	0
data_a_2B72	dw	0			; segment storage
		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Parse command line

sub_a_2B76	proc	near
		pop	word ptr cs:data_a_2B70
		mov	cs:data_a_2B72,ds
		cld				; Clear direction
		mov	es,data_b_0084		; PSP segment
		mov	si,d_39F0_0080_e
		xor	ax,ax			; Zero register
		lods	byte ptr es:[si]	; String [si] to al
		inc	ax
		mov	bp,es
		xchg	dx,si
		xchg	bx,ax
		mov	si,word ptr data_b_007E
		add	si,2
		mov	cx,1
		cmp	byte ptr data_b_0086,3	; DOS version
		jb	loc_a_2BB4		; Jump if below
		mov	es,word ptr data_b_007E+2
		mov	di,si
		mov	cl,7Fh
		xor	al,al			; Zero register
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jcxz	loc_a_2C27		; Jump if cx=0
		xor	cl,7Fh
loc_a_2BB4:
		sub	sp,2
		mov	ax,1
		add	ax,bx
		add	ax,cx
		and	ax,0FFFEh
		mov	di,sp
		sub	di,ax
		jc	loc_a_2C27		; Jump if carry Set
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
loc_a_2BE3:
		call	sub_a_2BFF
		ja	loc_a_2BEF		; Jump if above
loc_a_2BE8:
		jc	loc_a_2C2A		; Jump if carry Set
		call	sub_a_2BFF
		ja	loc_a_2BE8		; Jump if above
loc_a_2BEF:
		cmp	al,20h			; ' '
		je	loc_a_2BFB		; Jump if equal
		cmp	al,0Dh
		je	loc_a_2BFB		; Jump if equal
		cmp	al,9
		jne	loc_a_2BE3		; Jump if not equal
loc_a_2BFB:
		xor	al,al			; Zero register
		jmp	short loc_a_2BE3

;==== External Entry into Subroutine ======================================

sub_a_2BFF:
		or	ax,ax			; Zero ?
		jz	loc_a_2C0A		; Jump if zero
		inc	dx
		stosb				; Store al to es:[di]
		or	al,al			; Zero ?
		jnz	loc_a_2C0A		; Jump if not zero
		inc	bx
loc_a_2C0A:
		xchg	ah,al
		xor	al,al			; Zero register
		stc				; Set carry flag
		jcxz	loc_ret_a_2C26		; Jump if cx=0
		lodsb				; String [si] to al
		dec	cx
		sub	al,22h			; '"'
		jz	loc_ret_a_2C26		; Jump if zero
		add	al,22h			; '"'
		cmp	al,5Ch			; '\'
		jne	loc_a_2C24		; Jump if not equal
		cmp	byte ptr [si],22h	; '"'
		jne	loc_a_2C24		; Jump if not equal
		lodsb				; String [si] to al
		dec	cx
loc_a_2C24:
		or	si,si			; Zero ?

loc_ret_a_2C26:
		retn
loc_a_2C27:
		jmp	loc_a_018D		; Error - abnormal termination
loc_a_2C2A:
		pop	cx
		add	cx,dx
		mov	ds,cs:data_a_2B72
		mov	data_b_0078,bx
		inc	bx
		add	bx,bx
		mov	si,sp
		mov	bp,sp
		sub	bp,bx
		jc	loc_a_2C27		; Jump if carry Set
		mov	sp,bp
		mov	data_b_007A,bp
loc_a_2C47:
		jcxz	loc_a_2C57		; Jump if cx=0
		mov	[bp],si
		add	bp,2

locloop_a_2C4F:
		lods	byte ptr ss:[si]	; String [si] to al
		or	al,al			; Zero ?
		loopnz	locloop_a_2C4F		; Loop if zf=0, cx>0

		jz	loc_a_2C47		; Jump if zero
loc_a_2C57:
		xor	ax,ax			; Zero register
		mov	[bp],ax
		jmp	word ptr cs:data_a_2B70
sub_a_2B76	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2C61	proc	near
		mov	cx,word ptr data_b_007E
		push	cx
		call	sub_a_2A71
		pop	cx
		mov	di,ax
		or	ax,ax			; Zero ?
		jz	loc_a_2C94		; Jump if zero
		push	ds
		push	ds
		pop	es
		mov	ds,word ptr data_b_007E+2
		xor	si,si			; Zero register
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		mov	di,ax
		push	es
		push	data_b_0082
		call	sub_a_2A71
		add	sp,2
		mov	bx,ax
		pop	es
		mov	data_b_007C,ax
		or	ax,ax			; Zero ?
		jnz	loc_a_2C97		; Jump if not zero
loc_a_2C94:
		jmp	loc_a_018D		; Error - abnormal termination
loc_a_2C97:
		xor	ax,ax			; Zero register
		mov	cx,0FFFFh
loc_a_2C9C:
		mov	[bx],di
		add	bx,2
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		cmp	es:[di],al
		jne	loc_a_2C9C		; Jump if not equal
		mov	[bx],ax
		retn
sub_a_2C61	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get cursor position

sub_a_2CAB	proc	near
		mov	ah,3
		mov	bh,0
		call	sub_a_27B6		; call INT 10h
		mov	ax,dx
		retn
sub_a_2CAB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2CB5	proc	near
		call	sub_a_2CAB		; Get cursor position
		mov	ah,0
		mov	dl,data_b_3C82
		mov	dh,0
		sub	ax,dx
		inc	ax
		retn
sub_a_2CB5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2CC4	proc	near
		call	sub_a_2CAB		; Get cursor position
		mov	cx,8
		shr	ax,cl			; Shift w/zeros fill
		mov	ah,0
		mov	dl,data_b_3C83
		mov	dh,0
		sub	ax,dx
		inc	ax
		retn
sub_a_2CC4	endp

		db	8 dup (0)

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_c

data_b_0000	db	0			; Data table (indexed access)
		db	0
data_b_0002	db	0
		db	 00h, 54h, 75h
		db	'rbo-C - '
copyright	db	'Copyright (c) 1987 Borland Intl.'
		db	0
data_b_002F	db	'Null pointer assignment', 0Dh, 0Ah
		db	'Divide error', 0Dh, 0Ah, 'A'
data_b_0057	db	'bnormal program termination', 0Dh
		db	0Ah
data_b_0074	dw	0
data_b_0076	dw	0			; segment storage
data_b_0078	dw	0
data_b_007A	dw	0
data_b_007C	dw	0
data_b_007E	dd	00000h
data_b_0082	dw	0
data_b_0084	dw	0			; PSP segment
data_b_0086	dw	0			; DOS version
data_b_0088	dw	0
data_b_008A	dw	0			; exit code
		db	 30h, 46h
data_b_008E	dw	4630h
		db	 30h, 46h, 00h
		db	0
data_b_0094	dw	0
		db	0, 0
data_b_0098	dw	0
		db	0, 0
data_b_009C	dw	0
data_b_009E	dw	9			; Board size
data_b_00A0	dw	9
data_b_00A2	dw	6
data_b_00A4	dw	26h
data_b_00A6	dw	2
data_b_00A8	dw	1
data_b_00AA	dw	15h
		db	0, 0
data_b_00AE	dw	2
data_b_00B0	dw	1
data_b_00B2	dw	1
data_b_00B4	dw	0
data_b_00B6	dw	0
data_b_00B8	dw	0
data_b_00BA	dw	0
data_b_00BC	dw	0
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_017D	proc	near
;*		add	data_b_0000[bx+si],al
		db	 00h, 80h, 00h, 00h	;  Fixup - byte match
		add	[bx+si],al
;*		add	data_b_0000[bx+si],al
		db	 00h, 80h, 00h, 00h	;  Fixup - byte match
		add	[bx+si],al
;*		add	data_b_0000[bx+si],al
		db	 00h, 80h, 00h, 00h	;  Fixup - byte match
		add	[bx+si],al
;*		add	data_b_0000[bx+si],al
		db	 00h, 80h, 00h, 00h	;  Fixup - byte match
		add	[bx+si],al
;*		add	data_b_0000[bx+si],al
		db	 00h, 80h, 00h, 00h	;  Fixup - byte match
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	15 dup (0)
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FDh,0BFh,0FFh,0FEh
		db	 7Fh,0FFh,0FDh,0BFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	15 dup (0)
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0E0h, 00h,0FFh,0FEh
		db	 7Fh,0FFh, 00h, 00h, 1Fh,0FEh
		db	 7Fh,0FCh, 00h, 00h, 07h,0FEh
		db	 7Fh,0F0h, 00h, 00h, 01h,0FEh
		db	 7Fh,0E0h, 00h, 00h, 00h,0FEh
		db	 7Fh,0C0h, 00h, 00h, 00h, 7Eh
		db	 7Fh, 80h, 00h, 00h, 00h, 3Eh
		db	 7Fh, 80h, 00h, 00h, 00h, 3Eh
		db	 7Fh, 00h, 00h, 00h, 00h, 1Eh
		db	 7Fh, 00h, 00h, 00h, 00h, 1Eh
		db	 7Eh, 01h, 00h, 00h, 00h, 0Eh
		db	 7Eh, 00h, 00h, 00h, 00h, 0Eh
		db	 7Eh, 02h, 00h, 00h, 00h, 0Eh
		db	 7Eh, 02h, 00h, 00h, 00h, 0Eh
		db	 7Eh, 00h, 00h, 00h, 00h, 0Eh
		db	 7Eh, 01h, 00h, 00h, 00h, 0Eh
		db	 7Fh, 00h, 00h, 00h, 00h, 1Eh
		db	 7Fh, 00h, 00h, 00h, 00h, 1Eh
		db	 7Fh, 80h, 00h, 00h, 00h, 3Eh
		db	 7Fh, 80h, 00h, 00h, 00h, 3Eh
		db	 7Fh,0C0h, 00h, 00h, 00h, 7Eh
		db	 7Fh,0E0h, 00h, 00h, 00h,0FEh
		db	 7Fh,0F0h, 00h, 00h, 01h,0FEh
		db	 7Fh,0FCh, 00h, 00h, 07h,0FEh
		db	 7Fh,0FFh, 00h, 00h, 1Fh,0FEh
		db	 7Fh,0FFh,0E0h, 00h,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 81h,0FFh,0FFh,0FFh,0FFh, 80h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h,0FFh,0FFh,0FFh,0FFh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 7Fh,0FFh,0FFh,0FEh, 00h
		db	 80h, 3Fh,0FFh,0FFh,0FCh, 00h
		db	 80h, 1Fh,0FFh,0FFh,0F8h, 00h
		db	 80h, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 80h, 03h,0FFh,0FFh,0C0h, 00h
		db	 80h, 00h,0FFh,0FFh, 00h, 00h
		db	 80h, 00h, 1Fh,0F8h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 01h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 02h, 00h, 00h, 00h, 00h
		db	 80h, 02h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 01h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 01h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 02h, 00h, 00h, 00h, 00h
		db	 80h, 02h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 01h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h
		db	15 dup (0)
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0F8h,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh, 1Fh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0C7h,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0F1h,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0F8h,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FCh, 7Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FEh, 3Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FEh, 3Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 1Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 1Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 8Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 8Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 8Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 8Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 8Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 8Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 1Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh, 1Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FEh, 3Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FEh, 3Eh
		db	 7Fh,0FFh,0FFh,0FFh,0FCh, 7Eh
		db	 7Fh,0FFh,0FFh,0FFh,0F8h,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0F1h,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0C7h,0FEh
		db	 7Fh,0FFh,0FFh,0FFh, 1Fh,0FEh
		db	 7Fh,0FFh,0FFh,0F8h,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 00h
		db	689 dup (0)
		db	228 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 40h, 00h, 00h, 00h, 00h, 02h
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Ch, 00h, 00h, 00h, 00h, 3Ah
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0C0h, 00h, 00h, 03h,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DCh, 00h, 00h, 3Bh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0C0h, 03h,0BBh,0BAh
		db	 5Dh,0DDh,0C0h, 03h,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DCh, 00h, 00h, 3Bh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0C0h, 00h, 00h, 03h,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Ch, 00h, 00h, 00h, 00h, 3Ah
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 40h, 00h, 00h, 00h, 00h, 02h
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 00h
		db	11 dup (0)
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 40h, 00h, 00h, 00h, 00h, 02h
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Ch, 00h, 00h, 00h, 00h, 3Ah
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0C0h, 00h, 00h, 03h,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DCh, 00h, 00h, 3Bh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0C0h, 03h,0BBh,0BAh
		db	 5Dh,0DDh,0C0h, 03h,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DCh, 00h, 00h, 3Bh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0C0h, 00h, 00h, 03h,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Ch, 00h, 00h, 00h, 00h, 3Ah
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 40h, 00h, 00h, 00h, 00h, 02h
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 00h
		db	11 dup (0)
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 40h, 00h, 00h, 00h, 00h, 02h
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Ch, 00h, 00h, 00h, 00h, 3Ah
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0C0h, 00h, 00h, 03h,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DCh, 00h, 00h, 3Bh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0C0h, 03h,0BBh,0BAh
		db	 5Dh,0DDh,0C0h, 03h,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DDh,0FFh,0FFh,0BBh,0BAh
		db	 5Dh,0DCh, 00h, 00h, 3Bh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0DFh,0FFh,0FFh,0FBh,0BAh
		db	 5Dh,0C0h, 00h, 00h, 03h,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Dh,0FFh,0FFh,0FFh,0FFh,0BAh
		db	 5Ch, 00h, 00h, 00h, 00h, 3Ah
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 5Fh,0FFh,0FFh,0FFh,0FFh,0FAh
		db	 40h, 00h, 00h, 00h, 00h, 02h
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 00h
		db	17 dup (0)
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 20h, 00h, 00h, 00h, 00h, 04h
		db	 2Fh,0FFh,0FFh,0FFh,0FFh,0F4h
		db	 28h, 00h, 00h, 00h, 00h, 14h
		db	 2Bh,0FFh,0FFh,0FFh,0FFh,0D4h
		db	 2Ah, 00h, 00h, 00h, 00h, 54h
		db	 2Ah,0FFh,0FFh,0FFh,0FFh, 54h
		db	 2Ah, 80h, 00h, 00h, 01h, 54h
		db	 2Ah,0BFh,0FFh,0FFh,0FDh, 54h
		db	 2Ah,0A0h, 00h, 00h, 05h, 54h
		db	 2Ah,0AFh,0FFh,0FFh,0F5h, 54h
		db	 2Ah,0A8h, 00h, 00h, 15h, 54h
		db	 2Ah,0ABh,0FFh,0FFh,0D5h, 54h
		db	 2Ah,0AAh, 00h, 00h, 55h, 54h
		db	 2Ah,0AAh,0FFh,0FFh, 55h, 54h
		db	 2Ah,0AAh, 80h, 01h, 55h, 54h
		db	 2Ah,0AAh,0BFh,0FDh, 55h, 54h
		db	 2Ah,0AAh,0BFh,0FDh, 55h, 54h
		db	 2Ah,0AAh, 80h, 01h, 55h, 54h
		db	 2Ah,0AAh,0FFh,0FFh, 55h, 54h
		db	 2Ah,0AAh, 00h, 00h, 55h, 54h
		db	 2Ah,0ABh,0FFh,0FFh,0D5h, 54h
		db	 2Ah,0A8h, 00h, 00h, 15h, 54h
		db	 2Ah,0AFh,0FFh,0FFh,0F5h, 54h
		db	 2Ah,0A0h, 00h, 00h, 05h, 54h
		db	 2Ah,0BFh,0FFh,0FFh,0FDh, 54h
		db	 2Ah, 80h, 00h, 00h, 01h, 54h
		db	 2Ah,0FFh,0FFh,0FFh,0FFh, 54h
		db	 2Ah, 00h, 00h, 00h, 00h, 54h
		db	 2Bh,0FFh,0FFh,0FFh,0FFh,0D4h
		db	 28h, 00h, 00h, 00h, 00h, 14h
		db	 2Fh,0FFh,0FFh,0FFh,0FFh,0F4h
		db	 20h, 00h, 00h, 00h, 00h, 04h
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	12 dup (0)
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 55h, 54h,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0E7h,0FEh
		db	 7Fh,0E7h,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 7Eh, 00h
		db	 81h,0FFh, 80h, 03h,0FFh,0C0h
		db	 87h,0FFh,0E0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 07h,0FFh,0E0h
		db	 83h,0FFh,0C0h, 01h,0FFh, 80h
		db	 80h, 7Eh, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 7Eh, 00h
		db	 81h,0FFh, 80h, 03h,0FFh,0C0h
		db	 87h,0FFh,0E0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 07h,0FFh,0E0h
		db	 83h,0FFh,0C0h, 01h,0FFh, 80h
		db	 80h, 7Eh, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 7Eh, 00h
		db	 81h,0FFh, 80h, 03h,0FFh,0C0h
		db	 87h,0FFh,0E0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 07h,0FFh,0E0h
		db	 83h,0FFh,0C0h, 01h,0FFh, 80h
		db	 80h, 7Eh, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 55h, 54h,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh, 80h, 7Eh
		db	 7Eh, 00h, 1Eh,0FCh, 00h, 0Eh
		db	 78h, 40h, 06h,0F0h, 00h, 02h
		db	 70h, 80h, 02h,0F0h, 80h, 02h
		db	 70h, 00h, 02h,0F8h, 40h, 06h
		db	 7Ch, 00h, 0Eh,0FEh, 00h, 1Eh
		db	 7Fh, 80h, 7Eh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 7Eh, 00h
		db	 81h,0FFh, 80h, 03h,0FFh,0C0h
		db	 87h,0FFh,0E0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 0Fh,0FFh,0F0h
		db	 8Fh,0FFh,0F0h, 07h,0FFh,0E0h
		db	 83h,0FFh,0C0h, 01h,0FFh, 80h
		db	 80h, 7Eh, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 40h, 00h, 00h, 00h, 00h
		db	 80h, 80h, 00h, 00h, 80h, 00h
		db	 80h, 00h, 00h, 00h, 40h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 55h, 54h,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FEh, 7Eh
		db	 7Fh,0FFh, 9Eh,0FFh,0FFh,0CEh
		db	 7Fh,0FFh,0E6h,0FFh,0FFh,0F2h
		db	 7Fh,0FFh,0F2h,0FFh,0FFh,0F2h
		db	 7Fh,0FFh,0F2h,0FFh,0FFh,0E6h
		db	 7Fh,0FFh,0CEh,0FFh,0FFh, 9Eh
		db	 7Fh,0FEh, 7Eh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 55h, 54h,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh,0FFh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 70h, 00h, 0Eh, 77h,0FFh,0EEh
		db	 77h,0FFh,0EEh, 77h,0FFh,0EEh
		db	 77h, 00h,0EEh, 77h, 00h,0EEh
		db	 77h,0FFh,0EEh, 77h,0FFh,0EEh
		db	 77h,0FFh,0EEh, 70h, 00h, 0Eh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 70h, 00h, 0Eh, 77h,0FFh,0EEh
		db	 77h,0FFh,0EEh, 77h,0FFh,0EEh
		db	 77h, 00h,0EEh, 77h, 00h,0EEh
		db	 77h,0FFh,0EEh, 77h,0FFh,0EEh
		db	 77h,0FFh,0EEh, 70h, 00h, 0Eh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 70h, 00h, 0Eh, 77h,0FFh,0EEh
		db	 77h,0FFh,0EEh, 77h,0FFh,0EEh
		db	 77h, 00h,0EEh, 77h, 00h,0EEh
		db	 77h,0FFh,0EEh, 77h,0FFh,0EEh
		db	 77h,0FFh,0EEh, 70h, 00h, 0Eh
		db	 7Fh,0FFh,0FEh, 7Fh,0FFh,0FEh
		db	 7Fh,0FFh,0FEh, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 80h, 00h, 01h
		db	0BFh,0FFh,0FDh,0A0h, 00h, 05h
		db	0AFh,0FFh,0F5h,0A8h, 00h, 15h
		db	0ABh,0FFh,0D5h,0AAh, 00h, 55h
		db	0AAh,0FFh, 55h,0AAh,0FFh, 55h
		db	0AAh, 00h, 55h,0ABh,0FFh,0D5h
		db	0A8h, 00h, 15h,0AFh,0FFh,0F5h
		db	0A0h, 00h, 05h,0BFh,0FFh,0FDh
		db	 80h, 00h, 01h,0FFh,0FFh,0FFh
		db	0AAh,0AAh,0AAh
		db	53 dup (0AAh)
		db	0AFh, 8Ah,0AAh,0AAh,0AAh,0AAh
		db	0AFh, 8Ah,0AAh,0AAh,0AAh,0AAh
		db	0AFh, 8Ah,0AAh,0AAh,0AAh
		db	85 dup (0AAh)
		db	0BFh,0FEh, 2Ah,0AAh,0AAh,0ABh
		db	0FFh,0FFh,0E2h,0AAh,0AAh,0AFh
		db	0FFh,0FFh,0F8h,0AAh,0AAh,0BFh
		db	0FFh,0FFh,0FEh, 2Ah,0AAh,0BFh
		db	0FFh,0FFh,0FEh, 2Ah,0AAh,0FFh
		db	0FFh,0FFh,0FFh, 8Ah,0AAh,0FFh
		db	0FFh,0FFh,0FFh, 8Ah,0AAh,0FFh
		db	0FFh,0FFh,0FFh, 8Ah,0AAh,0FFh
		db	0FFh,0FFh,0FFh, 8Ah,0AAh,0BFh
		db	0FFh,0FFh,0FEh, 2Ah,0AAh,0BFh
		db	0FFh,0FFh,0FEh, 2Ah,0AAh,0AFh
		db	0FFh,0FFh,0F8h,0AAh,0AAh,0ABh
		db	0FFh,0FFh,0E2h,0AAh,0AAh,0AAh
		db	0BFh,0FEh
		db	2Ah
		db	51 dup (0AAh)
		db	0BFh,0FEh, 2Ah,0AAh,0AAh,0ABh
		db	0FFh,0FFh,0E2h,0AAh,0AAh,0AFh
		db	0F0h, 07h,0F8h,0AAh,0AAh,0BFh
		db	 80h, 00h,0FEh, 2Ah,0AAh,0BEh
		db	 00h, 00h, 3Eh, 2Ah,0AAh,0F8h
		db	 00h, 00h, 0Fh, 8Ah,0AAh,0F8h
		db	 00h, 00h, 0Fh, 8Ah,0AAh,0F8h
		db	 00h, 00h, 0Fh, 8Ah,0AAh,0F8h
		db	 00h, 00h, 0Fh, 8Ah,0AAh,0BEh
		db	 00h, 00h, 3Eh, 2Ah,0AAh,0BFh
		db	 80h, 00h,0FEh, 2Ah,0AAh,0AFh
		db	0F0h, 07h,0F8h,0AAh,0AAh,0ABh
		db	0FFh,0FFh,0E2h,0AAh,0AAh,0AAh
		db	0BFh,0FEh
		db	2Ah
		db	157 dup (0AAh)
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	0BFh,0FFh,0FFh,0FFh,0FFh,0FDh
		db	0C0h, 00h, 00h, 00h, 00h, 03h
		db	0E0h, 00h, 00h, 00h, 00h, 07h
		db	0E1h,0FFh,0FFh,0FFh,0FFh, 87h
		db	0E2h,0FFh,0FFh,0FFh,0FFh, 47h
		db	0E3h, 7Fh,0FFh,0FFh,0FEh,0C7h
		db	0E3h,0BFh,0FFh,0FFh,0FDh,0C7h
		db	0E3h,0C0h, 00h, 00h, 03h,0C7h
		db	0E3h,0C7h,0FFh,0FFh,0E3h,0C7h
		db	0E3h,0C8h, 00h, 00h, 13h,0C7h
		db	0E3h,0C8h, 00h, 00h, 13h,0C7h
		db	0E3h,0C7h,0FFh,0FFh,0E3h,0C7h
		db	0E3h,0C0h, 00h, 00h, 03h,0C7h
		db	0E3h,0BFh,0FFh,0FFh,0FDh,0C7h
		db	0E3h, 7Fh,0FFh,0FFh,0FEh,0C7h
		db	0E2h,0FFh,0FFh,0FFh,0FFh, 47h
		db	0E1h,0FFh,0FFh,0FFh,0FFh, 87h
		db	0E0h, 00h, 00h, 00h, 00h, 07h
		db	0C0h, 00h, 00h, 00h, 00h, 03h
		db	0BFh,0FFh,0FFh,0FFh,0FFh,0FDh
		db	 7Fh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	13 dup (0AAh)
		db	0B8h,0AAh,0AAh
		db	21 dup (0AAh)
		db	0FEh, 2Ah,0ABh,0FFh, 8Ah,0ABh
		db	0FFh, 8Ah,0ABh,0FFh, 8Ah,0ABh
		db	0FFh, 8Ah,0AAh,0FEh, 2Ah,0AAh
		db	0AAh,0AAh
		db	10 dup (0AAh)
		db	0FEh, 2Ah,0ABh, 83h, 8Ah,0ABh
		db	 01h, 8Ah,0ABh, 01h, 8Ah,0ABh
		db	 83h, 8Ah,0AAh,0FEh, 2Ah,0AAh
		db	0AAh,0AAh
		db	33 dup (0AAh)
		db	 7Fh,0FFh,0FEh,0BFh,0FFh,0FDh
		db	0DFh,0FFh,0FBh,0E0h, 00h, 07h
		db	0E5h, 55h, 57h,0EAh,0AAh,0A7h
		db	0E0h, 00h, 07h,0DFh,0FFh,0FBh
		db	0BFh,0FFh,0FDh, 7Fh,0FFh,0FEh
		db	 00h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h,0E7h, 3Ch
		db	0E7h,0E7h, 3Ch,0E7h,0E7h, 3Ch
		db	0E7h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h,0E7h, 3Ch,0E7h,0E7h, 3Ch
		db	0E7h,0E7h, 3Ch,0E7h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h,0E7h, 3Ch
		db	0E7h,0E7h, 3Ch,0E7h,0E7h, 3Ch
		db	0E7h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h,0E7h, 3Ch,0E7h,0E7h, 3Ch
		db	0E7h,0E7h, 3Ch,0E7h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h,0E7h, 3Ch
		db	0E7h,0E7h, 3Ch,0E7h,0E7h, 3Ch
		db	0E7h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h,0E7h, 3Ch,0E7h,0E7h, 3Ch
		db	0E7h,0E7h, 3Ch,0E7h, 07h, 00h
		db	0E0h, 07h, 00h,0E0h, 07h, 00h
		db	0E0h,0EAh,0BDh, 57h, 0Ah, 81h
		db	 50h,0EAh,0BDh, 57h, 0Ah, 81h
		db	 50h,0EAh,0BDh, 57h, 0Ah, 81h
		db	 50h,0EAh,0BDh, 57h, 0Ah, 81h
		db	 50h,0EAh,0BDh, 57h,0EAh,0BDh
		db	 57h, 0Ah, 81h, 50h,0EAh,0BDh
		db	 57h, 0Ah, 81h, 50h,0EAh,0BDh
		db	 57h, 0Ah, 81h, 50h,0EAh,0BDh
		db	 57h, 0Ah, 81h, 50h,0EAh,0BDh
		db	 57h, 07h, 00h,0E0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 00h,0E0h,0EAh,0BDh, 57h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h,0EAh,0BDh, 57h
		db	0EAh,0BDh, 57h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	0EAh,0BDh, 57h, 07h, 00h,0E0h
		db	 07h, 00h, 00h, 07h, 00h, 00h
		db	0E7h, 3Fh,0FFh,0E7h, 3Fh,0FFh
		db	0E7h, 3Fh,0FFh, 07h, 00h, 00h
		db	 07h, 00h, 00h, 07h, 00h,0E0h
		db	 07h, 00h,0E0h, 00h, 00h,0E0h
		db	 00h, 00h,0E0h,0FFh,0FCh,0E7h
		db	0FFh,0FCh,0E7h,0FFh,0FCh,0E7h
		db	 00h, 00h,0E0h, 00h, 00h,0E0h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 07h, 00h, 00h, 07h, 00h, 00h
		db	0E7h, 3Fh,0FFh,0E7h, 3Fh,0FFh
		db	0E7h, 3Fh,0FFh, 07h, 00h, 00h
		db	 07h, 00h, 00h, 07h, 00h,0E0h
		db	 07h, 00h,0E0h, 00h, 00h,0E0h
		db	 00h, 00h,0E0h,0FFh,0FCh,0E7h
		db	0FFh,0FCh,0E7h,0FFh,0FCh,0E7h
		db	 00h, 00h,0E0h, 00h, 00h,0E0h
		db	 07h, 00h,0E0h, 07h, 00h,0E0h
		db	 07h, 00h, 00h, 07h, 00h, 00h
		db	0E7h, 3Fh,0FFh,0E7h, 3Fh,0FFh
		db	0E7h, 3Fh,0FFh, 07h, 00h, 00h
		db	 07h, 00h, 00h, 07h, 00h,0E0h
		db	 07h, 00h,0E0h, 00h, 00h,0E0h
		db	 00h, 00h,0E0h,0FFh,0FCh,0E7h
		db	0FFh,0FCh,0E7h,0FFh,0FCh,0E7h
		db	 00h, 00h,0E0h, 00h, 00h,0E0h
		db	 07h, 00h,0E0h,0EAh,0BDh, 57h
		db	 0Ah, 80h, 00h,0EAh,0BFh,0FFh
		db	 0Ah, 80h, 00h,0EAh,0BFh,0FFh
		db	 0Ah, 80h, 00h,0EAh,0BFh,0FFh
		db	 0Ah, 80h, 00h,0EAh,0BDh, 57h
		db	0EAh,0BDh, 57h, 00h, 01h, 50h
		db	0FFh,0FDh, 57h, 00h, 01h, 50h
		db	0FFh,0FDh, 57h, 00h, 01h, 50h
		db	0FFh,0FDh, 57h, 00h, 01h, 50h
		db	0EAh,0BDh, 57h, 00h, 00h, 00h
		db	 7Fh,0FFh,0FEh, 40h, 00h, 02h
		db	 5Fh,0FFh,0FAh, 5Fh,0FFh,0FAh
		db	 5Fh,0FFh,0FAh, 5Ch, 00h, 3Ah
		db	 5Dh,0FFh,0BAh, 5Dh,0FFh,0BAh
		db	 5Dh,0FFh,0BAh, 5Dh,0FFh,0BAh
		db	 5Ch, 00h, 3Ah, 5Fh,0FFh,0FAh
		db	 5Fh,0FFh,0FAh, 5Fh,0FFh,0FAh
		db	 40h, 00h, 02h, 7Fh,0FFh,0FEh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 7Fh,0FFh,0FEh, 40h, 00h, 02h
		db	 5Fh,0FFh,0FAh, 5Fh,0FFh,0FAh
		db	 5Fh,0FFh,0FAh, 5Ch, 00h, 3Ah
		db	 5Dh,0FFh,0BAh, 5Dh,0FFh,0BAh
		db	 5Dh,0FFh,0BAh, 5Dh,0FFh,0BAh
		db	 5Ch, 00h, 3Ah, 5Fh,0FFh,0FAh
		db	 5Fh,0FFh,0FAh, 5Fh,0FFh,0FAh
		db	 40h, 00h, 02h, 7Fh,0FFh,0FEh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 7Fh,0FFh,0FEh, 40h, 00h, 02h
		db	 5Fh,0FFh,0FAh, 5Fh,0FFh,0FAh
		db	 5Fh,0FFh,0FAh, 5Ch, 00h, 3Ah
		db	 5Dh,0FFh,0BAh, 5Dh,0FFh,0BAh
		db	 5Dh,0FFh,0BAh, 5Dh,0FFh,0BAh
		db	 5Ch, 00h, 3Ah, 5Fh,0FFh,0FAh
		db	 5Fh,0FFh,0FAh, 5Fh,0FFh,0FAh
		db	 40h, 00h, 02h, 7Fh,0FFh,0FEh
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 80h, 00h, 01h,0BFh,0FFh,0FDh
		db	0A0h, 00h, 05h,0AFh,0FFh,0F5h
		db	0A8h, 00h, 15h,0ABh,0FFh,0D5h
		db	0AAh, 00h, 55h,0AAh,0FFh, 55h
		db	0AAh,0FFh, 55h,0AAh, 00h, 55h
		db	0ABh,0FFh,0D5h,0A8h, 00h, 15h
		db	0AFh,0FFh,0F5h,0A0h, 00h, 05h
		db	0BFh,0FFh,0FDh, 80h, 00h, 01h
		db	0FFh,0FFh,0FFh,0AAh, 38h,0AAh
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	 00h, 38h, 00h,0FEh, 38h,0FFh
		db	0FEh, 38h,0FFh, 00h, 38h, 00h
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	 00h, 00h, 00h,0FFh,0F9h,0FFh
		db	0FFh,0F9h,0FFh, 00h, 38h, 00h
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	0AAh, 38h,0AAh,0AAh, 38h,0AAh
		db	0AAh, 38h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ABh,0FFh,0AAh
		db	0ABh, 01h, 8Ah,0ABh, 01h, 8Ah
		db	0ABh, 01h, 8Ah,0ABh, 01h, 8Ah
		db	0ABh,0FFh, 8Ah,0AAh, 00h, 0Ah
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 01h, 00h, 0Fh, 00h, 3Ch, 00h
		db	 90h, 01h,0D0h, 07h
		db	8 dup (0)
		db	 03h, 00h, 06h, 00h, 1Eh, 00h
		db	0D0h, 07h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0D0h, 07h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah, 00h, 3Ch, 00h, 90h, 01h
		db	0D0h, 07h,0D0h, 07h
		db	8 dup (0)
		db	 06h, 00h, 1Eh, 00h,0D0h, 07h
		db	0D0h, 07h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h,0D0h, 07h,0D0h, 07h
		db	 00h, 00h, 00h, 00h
data_b_1E2A	dw	0FFFFh			; Data table (indexed access)
		db	 00h, 00h, 01h, 00h,0FFh,0FFh
		db	 01h, 00h,0FFh,0FFh, 00h, 00h
		db	 01h
		db	25 dup (0)
data_b_1E52	dw	1			; Data table (indexed access)
		db	 01h, 00h, 01h, 00h, 00h, 00h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h
		db	23 dup (0)
data_b_1E7A	dw	390h
data_b_1E7C	dw	0
data_b_1E7E	dw	1		; 1=wait for VSYNC supported
data_b_1E80	dw	0
data_b_1E82	dw	0
data_b_1E84	dw	0
		db	'                     ', 0
		db	'*', 0
		db	'*', 0
		db	'Hmm... ', 0
		db	'=  ', 0
		db	'+  C O N T A X   +', 0
		db	'(C) PC Solutions.', 0
		db	'Two Players!'
		db	0, 0
		db	'4-line-loses!', 0
		db	'5-line-wins!', 0
		db	'IQ:', 0
		db	'  (F4 key) ', 0
		db	'F1  for SHOW.', 0
		db	'F10 for HELP.', 0
		db	'WHITE move.', 0
		db	'BLACK move.', 0
		db	'Cursor:', 0
		db	'White wins!', 0
		db	'Black wins!', 0

; !!! Picopad modification: use Enter key

;		db	'Hit SPACE..', 0
		db	'Hit ENTER..', 0

		db	'I Move ', 0
		db	'Drawn ! Hit ESC..', 0

; !!! Picopad modification: use Enter key
;		db	'Try THESE! Hit SPACE.', 0
		db	'Try THESE! Hit ENTER.', 0

		db	'                     ', 0
		db	'wbWBek', 0Dh, 0
		db	'12346789OPQKMGHIkewbxdgaip;<=>?C'
		db	'D', 0Dh, 0
		db	' Help Screen (F10)[D] Show Moves'
		db	'   (F1)[;] Computer Go  (F2)[g] '
		db	'Auto Play    (F3)[=] About..    '
		db	'   (*)[*] Q U I T     (ESC)[q]', 0

; !!! Picopad modification: use Enter key
;		db	'                    Hit SPACE to'
		db	'                    Hit ENTER to'

		db	' Continue.', 0

data_b_2085	db	'If you like this program, GET th'
		db	'ese packs from PC SOLUTIONS.. (E'
		db	'st 1983)', 0Ah, '               '
		db	'      +   PCS Games-Pack 1   +', 0Ah
		db	'> CHESS-MATE-2500 - A top-rate c'
		db	'hess program, CGA/VGA graphics, '
		db	'mouse & more..', 0Ah, '> SAGE-DR'
		db	'AUGHTS-2500 - Probably the stron'
		db	'gest available draughts program,'
		db	0Ah, '   CGA/VGA graphics, mouse '
		db	'& many features.   ADDIX-II - Gr'
		db	'eat strategy game.', 0Ah, '> BLI'
		db	'TZ - Innovative Checkers game on'
		db	' Vari-size board! (CGA/VGA)', 0Ah
		db	'> DROP-IT, FALLZONE-II, RANGER +'
		db	' other great strategy games..', 0Ah
		db	'>>>   GAMES-PACK-1 (5.25 or 3.5 '
		db	'disk) costs only '
		db	9Ch
		db	' 7.95 !! (USA $'
		db	'15)', 0Ah, '                    '
		db	' +   PCS Games-Pack 2   +', 0Ah, '>'
		db	' FLIPIT - Strong REVERSI game, C'
		db	'GA/VGA +more. JAX - Brain teaser'
		db	'.', 0Ah, '> RENJU - Fiendish jap'
		db	'anese game, CGA/VGA. MINEZONE-II'
		db	' - Neat deduction game.', 0Ah, '>'
		db	' CASCADE-II, Stellar-Combat, Dec'
		db	'ode, + More great games.', 0Ah, '>'
		db	'>>   GAMES-PACK-2 (5.25 or 3.5 d'
		db	'isk) costs only '
		db	9Ch
		db	' 7.95 !! (USA $'
		db	'15)', 0Ah, '                    '
		db	' +   PCS Games-Pack 3   +', 0Ah, '>'
		db	' CAPTAIN ERIC-II - Update with m'
		db	'ore levels, many new puzzles to '
		db	'solve', 0Ah, '   and new monster'
		db	's to beat. Can you face the chal'
		db	'lenge? (CGA/VGA)', 0Ah, '> FALL-'
		db	'ZONE-II - Another fine action/st'
		db	'rategy game. (CGA/VGA)', 0Ah, '>'
		db	' BOMB-RUN - Bomb strategic targe'
		db	'ts in this super arcade game. (C'
		db	'GA/VGA)', 0Ah, '> WALL-RUN - Try'
		db	' to out-wall your computer oppon'
		db	'ent - addictive action!', 0Ah, '>'
		db	' RACER - Fast Car-racing game...'
		db	' + many more great games..', 0Ah
		db	'>>>   GAMES-PACK-3 (5.25 or 3.5 '
		db	'disk) costs only '
		db	9Ch
		db	' 7.95 !! (USA $'
		db	'15)', 0Ah, 'Add '
		db	9Ch
		db	'1.20 UK P&P, or '
		db	9Ch
		db	'4 overseas airmail (USA $'
		db	'9). Send Cheques/P.O.', 27h, 's '
		db	'to:-', 0Ah, '    PC SOLUTIONS, D'
		db	'ept CT, P.O. Box 954, Bournemout'
		db	'h BH7 6YJ, ENGLAND.', 0Ah, 0
		db	'>> NEW RELEASE:-     +   Strateg'
		db	'y Games-Pack 4   +', 0Ah, '> DYN'
		db	'AMO DRAUGHTS - Play the EUROPEAN'
		db	' 10x10 game, with sweeping KINGS'
		db	' & MEN', 0Ah, '   jumping backwa'
		db	'rds! Very Strong player, Game ed'
		db	'it/replay, CGA/VGA + more..', 0Ah
		db	'> ALSO plays the RUSSIAN, SPANIS'
		db	'H and POOL 8x8 variaties of drau'
		db	'ghts..', 0Ah, '> BLOCKADE - An e'
		db	'xciting new OTHELLO-ish board ga'
		db	'me (CGA/VGA).', 0Ah, '> CONTAX -'
		db	' Another PC Solutions invention!'
		db	' A fine strategy game (CGA/VGA)', 0Ah
		db	'> SOLO - New twists to SOLITAIRE'
		db	' game... + all our new releases!'
		db	0Ah, '>>>   GAMES-PACK-4 (5.25 or'
		db	' 3.5 disk) costs only '
		db	9Ch
		db	' 7.95 !! (USA $'
		db	'15)', 0Ah, '                    '
		db	'      +   X - WORD   +', 0Ah, '>'
		db	'  For Crossword & Scrabble enthu'
		db	'siasts! Solve anagrams, search f'
		db	'or letter', 0Ah, '   patterns, w'
		db	'ith a dictionary of over 100,000'
		db	' words and phrases.', 0Ah, '>  A'
		db	'lso CASCADE-II (word puzzle game'
		db	') & other puzzles..', 0Ah, '>>> '
		db	'  X-WORD (5.25 or 3.5 disk) cost'
		db	's only '
		db	9Ch
		db	' 7.95 !! (USA $'
		db	'15)', 0Ah, '                    '
		db	'   +   PCS Util-Pack 1   +', 0Ah
		db	'> Sprites', 27h, 'n', 27h, 'Font'
		db	's - Mouse driven sprite/font/gra'
		db	'phics designer, with built-', 0Ah
		db	'   in screen designer.  XCELCOPY'
		db	'  - Fast Disk-Copy utility, many'
		db	' features!', 0Ah, '> C-Tools - S'
		db	'prites/Fonts library,+ other I/O'
		db	' - make small EXE. (C source)', 0Ah
		db	'> LIFEPIX - Fractalish generator'
		db	'. (C source) BATFX - Menus for B'
		db	'ATCH files.', 0Ah, '> MACLAN - S'
		db	'tructured Assembly language for '
		db	'the A86 assembler. (with source)'
		db	0Ah, '> CGA Enhancer, PC-XT Speed'
		db	'up, DMOUSE screen designer, CBM6'
		db	'4-IBM Converter.', 0Ah, '> Easy-'
		db	'Ed, Phonetic Word-Finder, Flexi-'
		db	'Label (Mail list & labels..) + m'
		db	'ore..', 0Ah, '>>>   UTIL-PACK 1 '
		db	'(5.25 or 3.5 disk) costs only '
		db	9Ch
		db	' 7.95 !! (USA $'
		db	'15)', 0Ah, 'Add '
		db	9Ch
		db	'1.20 UK P&P, or '
		db	9Ch
		db	'4 overseas airmail (USA $'
		db	'9). Send Cheques/P.O.', 27h, 's '
		db	'to:-', 0Ah, '    PC SOLUTIONS, D'
		db	'ept CT, P.O. Box 954, Bournemout'
		db	'h BH7 6YJ, ENGLAND.', 0Ah, 0
		db	'If you have a printer, you can r'
		db	'egister & order your PC Solution'
		db	's pack(s)', 0Ah, 'using this for'
		db	'm. Type your name and address, t'
		db	'hen hit SHIFT-PRTSC to print', 0Ah
		db	'it. Hit ESC if you don', 27h, 't'
		db	' want to do this, or hit ', 27h, '!'
		db	27h, ' to see the ad again', 0Ah, 'o'
		db	'r if you want to restart. REMEMB'
		db	'ER to add P & P to the total, an'
		db	'd specify', 0Ah, 'your disk size'
		db	' & the pack(s) you require. USA '
		db	'customers can now pay with', 0Ah
		db	'dollar cheques, but don', 27h, 't'
		db	' forget the overseas airmail - t'
		db	'his includes', 0Ah, 'our dollar/'
		db	'pound conversion charge! NEW SPE'
		db	'CIAL OFFER - BUY TWO OR MORE PAC'
		db	'KS', 0Ah, 'and P & P is FREE!!', 0Ah
		db	'      Name & Address:', 0Ah, 0Ah
		db	0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	'Signed:                         '
		db	'       Disk size: 3.5     5.25', 0Ah
		db	'Packs Required:                 '
		db	'       Total Amount (inc P & P) '
		db	':', 0Ah, 0Ah, 0Ah, '   PC Soluti'
		db	'ons (Dept CT)', 0Ah, '   PO Box '
		db	'954                      <--  Cu'
		db	't this out for your envelope.', 0Ah
		db	'   Bournemouth BH7 6YJ', 0Ah, ' '
		db	'  ENGLAND', 0

data_b_302C	db	'  This version of CONTAX is rele'
		db	'ased as shareware. You may distr'
		db	'ibute', 0Ah, 'it as long as you '
		db	'don', 27h, 't charge more than a'
		db	' small disk-copying fee for it,', 0Ah
		db	'or alter it in any way.', 0Ah, ' '
		db	' PC SOLUTIONS holds all rights t'
		db	'o this program, and we reserve t'
		db	'he right', 0Ah, 'to withdraw per'
		db	'mission to use or distribute CON'
		db	'TAX from any individual', 0Ah, 'o'
		db	'r organisation, if we feel they '
		db	'are abusing this privilege.', 0Ah
		db	'  Please remember that shareware'
		db	' is NOT free, but ', 27h, 'try b'
		db	'efore you buy', 27h, ',', 0Ah, 's'
		db	'o please become a registered use'
		db	'r by purchasing one of our progr'
		db	'am packs -', 0Ah, 'you will see '
		db	'the advert when you exit this pr'
		db	'ogram. An update to this program'
		db	',', 0Ah, 'with added position-ed'
		db	'it features, is on Games-Pack-4.'
		db	'.', 0Ah, '  People often ask how'
		db	' we generate such small, fast pr'
		db	'ograms - well special', 0Ah, 'th'
		db	'anks must go to Borland and thie'
		db	'r excellent Turbo-C compiler - f'
		db	'orget the', 0Ah, 'rest, Turbo-C '
		db	'is the best! Programmers will fi'
		db	'nd some of our own special', 0Ah
		db	'C-Tools for Turbo-C on our Util-'
		db	'Pack..', 0Ah, 0Ah, 0

data_b_33C7	db	'  Do you want CGA, EGA or VGA Gr'
		db	'aphics (Type:- c,e or v) ?', 0

		db	'cev', 0

		db	'Grid-Mode: ', 0
		db	'  (F1)   Board Size: ', 0
		db	'  (+/-)   ', 0
		db	'4 in a line loses! (F2) ', 0
		db	'5 in a line wins.  (F2) ', 0
		db	'+     C O N T A X     +', 0Ah, 0Ah
		db	0
		db	'            Copyright PC SOLUTIO'
		db	'NS 1990-1992, All rights reserve'
		db	'd.', 0Ah, 0Ah, 0
		db	'        CONTAX is a variant on G'
		db	'O, and is played on a 9 by 9 GO '
		db	'board.', 0Ah, '      Each player'
		db	' takes turns to place his stones'
		db	' on the board, and the', 0Ah, ' '
		db	'     first player to get 5 in-a-'
		db	'row wins the game. In CONTAX you'
		db	' MAY', 0Ah, '      ONLY MOVE TO '
		db	'EMPTY SQUARES ADJACENT TO BOTH W'
		db	'HITE AND BLACK PIECES!', 0Ah, ' '
		db	'     For more details and HELP, '
		db	'hit the F10 key now, or during p'
		db	'lay.', 0Ah, '        Hit the F1 '
		db	'key NOW to select various grid-p'
		db	'atterns on board, or', 0Ah, '   '
		db	'   hit ', 27h, '+', 27h, ' and ', 27h
		db	'-', 27h, ' to change board size,'
		db	' or try F2 for play to lose!', 0Ah
		db	'        When playing, move your '
		db	'cursor by using the numbers arou'
		db	'nd the', 0Ah, '      ', 27h, '5', 27h
		db	' on the numeric keypad and hit R'
		db	'ETURN to place your stone. If', 0Ah
		db	'      you have a MOUSE, you can '
		db	'hit left button to select moves,'
		db	' or', 0Ah, '      right button f'
		db	'or pull-down menus.', 0Ah, 0Ah, 0

		db	'                        Hit ENTER'
;		db	'                        Hit SPACE'
		db	' to play, ESC to Exit.', 0

		db	'CONTAX is Copyright and Written '
		db	'by A.Millett.', 0
		db	'        CONTAX ', 0
		db	'adds a new twist to the famous R'
		db	'ENJU/GOMOKU game theme.', 0Ah, ' '
		db	'     The underlying principle is'
		db	' the same - both white and black'
		db	' take', 0Ah, '      turns to pla'
		db	'ce pieces on the board, and the '
		db	'first to get a line of', 0Ah, ' '
		db	'     five wins. However in CONTA'
		db	'X you MAY ONLY MOVE TO EMPTY SQU'
		db	'ARES NEXT', 0Ah, '      TO BOTH '
		db	'WHITE AND BLACK PIECES! This rul'
		db	'e shapens up the tactical', 0Ah, ' '
		db	'     play considerably - every t'
		db	'ime you move, you give your oppo'
		db	'nent new', 0Ah, '      squares t'
		db	'o play to!', 0Ah, '        When '
		db	'playing, move your cursor by usi'
		db	'ng the numbers around the', 0Ah, ' '
		db	'     ', 27h, '5', 27h, ' on the '
		db	'numeric keypad and hit RETURN to'
		db	' place your stone.', 0Ah, '     '
		db	' MOUSE users can hit left button'
		db	' to move, or right button for me'
		db	'nus.', 0Ah, 0
		db	'        Command Summary:-', 0Ah, ' '
		db	'         F1  - Show all legal mo'
		db	'ves.    F2 - Make computer take '
		db	'your go.', 0Ah, '          F3  -'

; !!! Picopad modification: use Enter key
;		db	' Auto-play. (SPACE ends)  F4 - C'
		db	' Auto-play. (ENTER ends)  F4 - C'

		db	'hange IQ play-level.', 0Ah, '   '
		db	'       F5  - Toggle Two-player/S'
		db	'etup mode - disable computer rep'
		db	'ly.', 0Ah, '          F9  - Togg'
		db	'le Cursor off/on.', 0Ah, '      '
		db	'    ESC - Abort back to main men'
		db	'u.', 0Ah, '        Please suppor'
		db	't quality shareware and REGISTER'
		db	' - the version on', 0Ah, '      '
		db	'Games-Pack-4 has extra play leve'
		db	'ls and functions..', 0Ah
		db	0, 0
data_b_3C80	dw	0
data_b_3C82	db	0
data_b_3C83	db	0
data_b_3C84	db	0
data_b_3C85	db	0
data_b_3C86	db	0
data_b_3C87	db	0
data_b_3C88	db	0		; selected videomode
data_b_3C89	db	0
data_b_3C8A	db	0
data_b_3C8B	db	0
data_b_3C8C	db	0
data_b_3C8D	dw	0
data_b_3C8F	dw	0
		db	 01h, 00h, 43h, 4Fh, 4Dh, 50h
		db	 41h, 51h, 00h
data_b_3C9A	dw	288Eh
data_b_3C9C	dw	288Eh
data_b_3C9E	dw	288Eh
data_b_3CA0	dw	0
data_b_3CA2	dw	0
data_b_3CA4	db	0			; Data table (indexed access)
		db	 13h, 02h, 02h, 04h, 05h, 06h
		db	 08h, 08h, 08h, 14h, 15h, 05h
		db	 13h,0FFh, 16h, 05h, 11h, 02h
		db	13 dup (0FFh)
		db	 05h, 05h,0FFh
		db	15 dup (0FFh)
		db	 0Fh,0FFh,0FFh, 02h,0FFh, 0Fh
		db	0FFh,0FFh,0FFh,0FFh, 13h,0FFh
		db	0FFh, 02h, 02h, 05h, 0Fh, 02h
		db	0FFh,0FFh,0FFh, 13h
		db	15 dup (0FFh)
		db	 13h,0FFh, 00h, 00h, 00h,0FEh
		db	 3Ch
data_b_3D02	dw	3CFEh
data_b_3D04	dw	1
data_b_3D06	dw	0
data_b_3D08	dw	1000h
data_b_3D0A	dw	offset sub_b_017D
data_b_3D0C	dw	17Dh			; exit routine
data_b_3D0E	dw	27C5h			; function - set videomode
data_b_3D10	dw	0
data_b_3D12	dw	0
data_b_3D14	dw	0			; Data table (indexed access)
		db	8 dup (0)
data_b_3D1E	dw	0
data_b_3D20	db	0			; INT xx returned parameters - AX
		db	0
data_b_3D22	dw	0			; INT xx returned parameters - BX
data_b_3D24	dw	0			; INT xx returned parameters - CX
data_b_3D26	dw	0			; INT xx returned parameters - DX
		db	8 dup (0)		; INT xx returned parameters - SI, DI,
data_b_3D30	dw	0
data_b_3D32	dw	0
data_b_3D34	dw	0
data_b_3D36	dw	0
data_b_3D38	dw	0
data_b_3D3A	dw	0
data_b_3D3C	dw	0
		db	100 dup (0)
data_b_3DA2	dw	0, 0
data_b_3DA6	dw	0
data_b_3DA8	dw	0
		db	0, 0
data_b_3DAC	dd	00000h			; address of video memory
data_b_3DB0	dw	0
data_b_3DB2	dw	0
data_b_3DB4	dw	0
data_b_3DB6	dw	0
data_b_3DB8	dw	0			; Data table (indexed access)
data_b_3DBA	dw	0
data_b_3DBC	dw	0
		db	24 dup (0)
data_b_3DD6	dw	0
data_b_3DD8	dw	0
data_b_3DDA	dw	0			; old keyboard port 61h
data_b_3DDC	dw	0
		db	0, 0
data_b_3DE0	dw	0
data_b_3DE2	dw	0
		db	0, 0, 0, 0
data_b_3DE8	dw	0
data_b_3DEA	dw	0
data_b_3DEC	dw	0
data_b_3DEE	dw	0
		db	0, 0, 0, 0, 0, 0
data_b_3DF6	dw	0
data_b_3DF8	dw	0			; Data table (indexed access)
		db	1998 dup (0)
data_b_45C8	dw	0
data_b_45CA	dw	0			; keyboard scan code
data_b_45CC	dw	0

data_b_45CE	dw	0			; INT xx parameters - AX
data_b_45D0	db	0			; INT xx parameters - BX
data_b_45D1	db	0
		db	0, 0			; INT xx parameters - CX
data_b_45D4	db	0			; INT xx parameters - DX
data_b_45D5	db	0
		db	8 dup (0)		; INT xx parameters - SI, DI
data_b_45DE	dw	0
data_b_45E0	dw	0			; key from keyboard
data_b_45E2	dw	0			; 1=WHITE move, 0=BLACK move
data_b_45E4	dw	0
		db	0, 0, 0, 0
data_b_45EA	dw	0
data_b_45EC	dw	0
data_b_45EE	dw	0			; Data table (indexed access)
		db	62 dup (0)
data_b_462E	dw	0
sub_b_017D	endp


seg_b		ends



;------------------------------------------------------  stack_seg_c   ----

stack_seg_c	segment	word stack 'stack'

		db	128 dup (?)

stack_seg_c	ends



		end	start
