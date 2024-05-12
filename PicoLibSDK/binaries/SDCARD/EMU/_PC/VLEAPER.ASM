
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
;==				VLEAPER	                                 ==
;==					                                 ==
;==      Created:   27-Feb-93		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_0000_007D_e	equ	7Dh
d_0000_0170_e	equ	170h
d_0000_023A_e	equ	23Ah
d_0000_04A6_e	equ	4A6h
d_0000_04C2_e	equ	4C2h
d_0000_05FC_e	equ	5FCh			;*
d_0000_0614_e	equ	614h			;*
d_0000_2EE0_e	equ	2EE0h			;*
d_0000_450A_e	equ	450Ah			;*
d_0000_5F01_e	equ	5F01h			;*
d_0000_7E00_e	equ	7E00h			;*
d_0000_7F80_e	equ	7F80h			;*
d_0000_9F01_e	equ	9F01h			;*
d_0000_9F0A_e	equ	9F0Ah			;*
d_05AC_1500_e	equ	1500h			;*
d_2CF5_9E07_e	equ	9E07h			;*
PSP_free_seg	equ	2
data_b_2EE3_e	equ	2EE3h			;*
data_b_3736_e	equ	3736h			;*
data_b_44C8_e	equ	44C8h			;*
data_b_4A18_e	equ	4A18h			;*
data_b_4A88_e	equ	4A88h			;*
data_b_9EC8_e	equ	9EC8h			;*
data_c_E002_e	equ	0E002h			;*
data_c_F007_e	equ	0F007h			;*
data_c_FF01_e	equ	0FF01h			;*
d_A000_0A00_e	equ	0A00h
d_A000_0C80_e	equ	0C80h
d_A000_140C_e	equ	140Ch
d_A000_5A00_e	equ	5A00h
d_A000_E680_e	equ	0E680h
d_A000_F388_e	equ	0F388h
d_C0A6_1001_e	equ	1001h
d_C0A6_1101_e	equ	1101h
d_C0A6_4501_e	equ	4501h
d_C0A6_4509_e	equ	4509h
d_C0A6_450A_e	equ	450Ah
d_C0A6_9F01_e	equ	9F01h
d_C0A6_9F09_e	equ	9F09h
d_C0A6_A102_e	equ	0A102h
d_C0A6_A206_e	equ	0A206h
d_C0A6_A407_e	equ	0A407h
d_C0A6_E002_e	equ	0E002h
d_EB44_1006_e	equ	1006h
d_EB44_1007_e	equ	1007h
d_EB44_1107_e	equ	1107h
d_EB44_1206_e	equ	1206h
d_EB44_6406_e	equ	6406h
d_EB44_9E07_e	equ	9E07h
d_EB44_9E09_e	equ	9E09h
d_EB44_9F07_e	equ	9F07h
d_EB44_A102_e	equ	0A102h
d_EB44_A201_e	equ	0A201h
d_EB44_A207_e	equ	0A207h
d_EB44_A20D_e	equ	0A20Dh
d_EB44_A401_e	equ	0A401h
d_EB44_E006_e	equ	0E006h

;------------------------------------------------------  stack_seg_a   ----

stack_seg_a	segment	word stack 'stack'

		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '
		db	'LEAPER L.Chapel LEAPER L.Chapel '

stack_seg_a	ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	para public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_a


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


VLEAPER		proc	far

start:
		mov	bx,ds:PSP_free_seg
		mov	ax,seg_c
		mov	ds,ax
		mov	ax,seg_d
		assume	ds:seg_c
		mov	data_c_04A6,ax
		mov	dx,1Eh
		add	ax,0E70h
		jc	loc_b_0049		; Jump if carry Set
		add	ax,200h
		jc	loc_b_0049		; Jump if carry Set
		cmp	bx,ax
		jb	loc_b_0049		; Jump if below

		; get DOS version
		mov	ah,30h
		int	21h			; DOS Services  ah=function 30h
						;  get DOS version number ax
		mov	dx,0
		cmp	al,2
		jb	loc_b_0049		; Jump if below

		; save current videomode
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		mov	data_c_0381,al		; old videomode

		; set VGA videomode
		mov	ax,13h
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; check videomode
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		cmp	al,13h
		je	loc_b_004F		; Jump if equal

		; return old videomode
		mov	al,data_c_0381		; old videomode
		xor	ah,ah			; Zero register
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; error - VGA card required
		mov	dx,offset data_c_0033	; ('VGA card required.')
loc_b_0049:
		mov	ah,9
		int	21h			; DOS Services  ah=function 09h
						;  display char string at ds:dx
		int	20h			; DOS program terminate
loc_b_004F:
		; read high score file
		call	sub_b_1025		; Read high score file

		; save INT 08h
		mov	ax,3508h
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	cs:data_b_18A7,bx	; old INT 08h
		mov	word ptr cs:data_b_18A7+2,es


		; install INT 08h service
		call	sub_b_10D4		; Install INT 08h

		; save INT 24h
		mov	ax,3524h
		int	21h			; DOS Services  ah=function 35h
						;  get intrpt vector al in es:bx
		mov	data_c_0488,bx		; old INT 24h
		mov	data_c_048A,es

		; install INT 24h
		mov	dx,offset int_24h_entry
		push	ds
		mov	ax,seg_b
		mov	ds,ax
		mov	ax,2524h
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds

		; setup colors
		mov	ax,seg_c
		mov	es,ax
		mov	ax,1012h
		mov	bx,1
		mov	cx,8
		mov	dx,offset data_c_12F0
		int	10h			; Video display   ah=functn 10h
						;  set cx color registers from
						;   ptr es:dx, bx=first reg
		call	sub_b_16EA		; Clear screen

		; display intro image
		mov	ax,seg_d
		mov	ds,ax
		mov	ax,0A000h
		mov	es,ax
		xor	si,si			; Zero register
		xor	di,di			; Zero register
loc_b_00A4:
		lodsw				; String [si] to ax
		cmp	ax,0FFFFh
		je	loc_b_00B2		; Jump if equal
		mov	cl,ah
		xor	ch,ch			; Zero register
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		jmp	short loc_b_00A4

loc_b_00B2:
		mov	ax,seg_c
		mov	ds,ax
		mov	es,ax
		call	sub_b_1013		; Flush keyboard

		; shift palettes (animate intro screen)
loc_b_00BC:
		mov	byte ptr data_c_04AC,64h	; 'd'
		mov	dx,data_c_0478
		sub	dx,3
		cmp	dx,12EAh
		jae	loc_b_00D1		; Jump if above or =
		mov	dx,offset data_c_12F0

loc_b_00D1:	; set palettes
		mov	data_c_0478,dx
		mov	ax,1012h
		mov	bx,1
		mov	cx,3
		int	10h			; Video display   ah=functn 10h
						;  set cx color registers from
						;   ptr es:dx, bx=first reg

		; check key from keyboard
loc_b_00E0:
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jnz	loc_b_00EF		; Jump if not zero

		cmp	byte ptr data_c_04AC,0
		je	loc_b_00BC		; Jump if equal
		jmp	short loc_b_00E0

loc_b_00EF:
		call	sub_b_1013		; Flush keyboard
		call	sub_b_16EA		; Clear screen
loc_b_00F5:
		; set palettes
		mov	ax,seg_c
		mov	es,ax
		mov	ax,1012h
		xor	bx,bx			; Zero register
		mov	cx,100h
		mov	dx,offset data_c_1308
		int	10h			; Video display   ah=functn 10h
						;  set cx color registers from
						;   ptr es:dx, bx=first reg

		call	sub_b_0D91
		call	sub_b_0C8C
		call	sub_b_0E2D
		call	sub_b_1013		; Flush keyboard
		jmp	loc_b_01A6

; Animate intro sreen

loc_b_0116:
		cmp	byte ptr ds:[4ACh],0
		jne	loc_b_014F		; Jump if not equal
		mov	byte ptr ds:[4ACh],10h
		call	sub_b_0CBC
		call	sub_b_0E3E
		dec	byte ptr ds:[389h]
		jnz	loc_b_014F		; Jump if not zero
		mov	al,byte ptr ds:[38Ah]
		not	al
		mov	byte ptr ds:[38Ah],al
		mov	si,9B88h
		or	al,al			; Zero ?
		jz	loc_b_0140		; Jump if zero
		mov	si,data_b_9EC8_e
loc_b_0140:
		mov	di,data_b_4A18_e
		call	sub_b_0E18
		mov	di,data_b_4A88_e
		call	sub_b_0E18
		call	sub_b_0E2D
loc_b_014F:
		call	sub_b_1128

		; text key from keyboard
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_b_0116		; Jump if zero

		; input key from keyboard
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan

		; Esc exit
		cmp	al,1Bh
		jne	loc_b_0163		; Jump if not equal
		jmp	loc_b_0309
loc_b_0163:
		; S display high score
		cmp	al,73h			; 's'
		je	loc_b_016B		; Jump if equal
		cmp	al,53h			; 'S'
		jne	loc_b_0170		; Jump if not equal
loc_b_016B:
		call	sub_b_0F5C
		jmp	short loc_b_00F5

		; H display help
loc_b_0170:
		cmp	al,48h			; 'H'
		je	loc_b_0178		; Jump if equal
		cmp	al,68h			; 'h'
		jne	loc_b_017E		; Jump if not equal
loc_b_0178:
		call	sub_b_0B60
		jmp	loc_b_00F5

		; C change leaper's color
loc_b_017E:
		cmp	al,43h			; 'C'
		je	loc_b_0186		; Jump if equal
		cmp	al,63h			; 'c'
		jne	loc_b_018C		; Jump if not equal
loc_b_0186:
		call	sub_b_0B7D
		jmp	loc_b_00F5

		; K switch to keyboard
loc_b_018C:
		cmp	al,4Bh			; 'K'
		je	loc_b_0194		; Jump if equal
		cmp	al,6Bh			; 'k'
		jne	loc_b_019B		; Jump if not equal
loc_b_0194:
		mov	byte ptr ds:[4B7h],0
		jmp	short loc_b_01A6

		; J switch to joystick
loc_b_019B:
		cmp	al,4Ah			; 'J'
		je	loc_b_01A3		; Jump if equal
		cmp	al,6Ah			; 'j'
		jne	loc_b_01AC		; Jump if not equal
loc_b_01A3:
		call	sub_b_1750
loc_b_01A6:
		call	sub_b_0DDA
		jmp	loc_b_0116

		; Enter start the game
loc_b_01AC:
		cmp	al,0Dh
		je	loc_b_01B3		; Jump if equal
		jmp	loc_b_0116

; Start the game

loc_b_01B3:
		; clear high score file
		mov	ax,seg_c
		mov	es,ax
		mov	di,offset data_c_0BC4	; ('000000000000000000000000') ; high score file
		mov	cx,6
		mov	ax,3030h
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]

		mov	word ptr ds:[48Eh],0EE0h
		mov	byte ptr ds:[382h],4
		mov	byte ptr ds:[383h],32h	; '2'
		mov	byte ptr ds:[384h],1
		mov	byte ptr ds:[4B0h],0C8h

		call	sub_b_16EA		; Clear screen
		call	sub_b_0C62		; Set palettes
loc_b_01E4:
		call	sub_b_13BF
loc_b_01E7:
		call	sub_b_139D
		call	sub_b_126E
		call	sub_b_1158
		call	sub_b_16AE
		call	sub_b_1013		; Flush keyboard
loc_b_01F6:
		mov	byte ptr ds:[4ACh],32h	; '2'
		call	sub_b_11D6
		call	sub_b_0327
		call	sub_b_0492
		call	sub_b_0625
		call	sub_b_067B
		call	sub_b_0778
		call	sub_b_0A62
		mov	ax,seg_c
		mov	es,ax
		mov	al,byte ptr ds:[37Fh]
		or	al,al			; Zero ?
		jnz	loc_b_021F		; Jump if not zero
loc_b_021C:
		jmp	loc_b_02FD
loc_b_021F:
		test	al,80h
		jz	loc_b_022F		; Jump if zero
		mov	byte ptr ds:[382h],1
		mov	dx,word ptr ds:[4C2h]
		jmp	loc_b_0906
loc_b_022F:
		test	al,40h			; '@'
		jz	loc_b_0240		; Jump if zero
		not	byte ptr ds:[380h]
		call	sub_b_1716
		call	sub_b_1013		; Flush keyboard
		jmp	loc_b_02FD
loc_b_0240:
		test	al,20h			; ' '
		jz	loc_b_024E		; Jump if zero
		call	sub_b_1013		; Flush keyboard

		; get key from keyboard
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		jmp	loc_b_02FD
loc_b_024E:
		mov	dx,0FFFCh
		xor	cx,cx			; Zero register
		mov	bx,4848h
		test	al,1
		jnz	loc_b_027A		; Jump if not zero
		mov	dx,4
		mov	bx,4688h
		test	al,2
		jnz	loc_b_027A		; Jump if not zero
		mov	dx,cx
		mov	cx,0FFFFh
		mov	bx,4308h
		test	al,4
		jnz	loc_b_027A		; Jump if not zero
		mov	cx,1
		mov	bx,data_b_44C8_e
		test	al,8
		jz	loc_b_021C		; Jump if zero
loc_b_027A:
		mov	word ptr ds:[4C4h],bx
		push	cx
		push	dx
		call	sub_b_133F
		pop	dx
		pop	cx
		mov	ax,word ptr ds:[4C2h]
		add	ax,dx
		cmp	ax,180h
		jb	loc_b_0299		; Jump if below
		mov	ax,17Ch
;*		cmp	dx,0FFFCh
		db	 83h,0FAh,0FCh		;  Fixup - byte match
		jz	loc_b_0299		; Jump if zero
		xor	ax,ax			; Zero register
loc_b_0299:
		mov	word ptr ds:[4C2h],ax
		or	cl,cl			; Zero ?
		jz	loc_b_02FA		; Jump if zero
		mov	bl,byte ptr ds:[4C1h]
		cmp	bl,0Bh
		jne	loc_b_02AE		; Jump if not equal
		cmp	cl,1
		je	loc_b_02FA		; Jump if equal
loc_b_02AE:
		xor	bh,bh			; Zero register
		push	bx
		add	bl,cl
		mov	byte ptr ds:[4C1h],bl
		cmp	bl,0Bh
		je	loc_b_02CE		; Jump if equal
		cmp	byte ptr ds:[62Ch][bx],0
		jne	loc_b_02CE		; Jump if not equal
		mov	byte ptr ds:[62Ch][bx],0FFh
		mov	ax,1
		call	sub_b_0A9C
loc_b_02CE:
		pop	bx
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[4C2h]
		sub	ax,word ptr ds:[614h][bx]
		mov	bl,byte ptr ds:[4C1h]
		mov	byte ptr ds:[5A6h][bx],1
		shl	bx,1			; Shift w/zeros fill
		add	ax,word ptr ds:[614h][bx]
		cmp	ax,180h
		jb	loc_b_02F7		; Jump if below
		add	ax,180h
		cmp	ax,180h
		jb	loc_b_02F7		; Jump if below
		sub	ax,300h
loc_b_02F7:
		mov	word ptr ds:[4C2h],ax
loc_b_02FA:
		call	sub_b_126E
loc_b_02FD:
		call	sub_b_0778
		call	sub_b_1158
		call	sub_b_0FC1
		jmp	loc_b_01F6

; Exit game

loc_b_0309:
		; restore INT 24h
		push	ds
		mov	dx,word ptr ds:[488h]
		mov	ds,word ptr ds:[48Ah]
		mov	ax,2524h
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		pop	ds
		call	sub_b_10EE		; Restore INT 08h
		mov	al,byte ptr ds:[381h]
		xor	ah,ah			; Zero register
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ax,4C00h
		int	21h			; DOS Services  ah=function 4Ch
						;  terminate with al=return code

VLEAPER		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0327	proc	near
		cmp	byte ptr data_c_0722,0
		je	loc_b_0334		; Jump if equal
		dec	data_c_0722
		jmp	short loc_b_0359
loc_b_0334:
		cmp	byte ptr data_c_0721,0
		je	loc_b_0341		; Jump if equal
		dec	data_c_0721
		jnz	loc_b_0359		; Jump if not zero
loc_b_0341:
		call	sub_b_1128
		cmp	al,14h
		jae	loc_b_0359		; Jump if above or =
		cmp	byte ptr data_c_0720,0
		jne	loc_b_0359		; Jump if not equal
		mov	byte ptr data_c_0720,8
		mov	byte ptr data_c_0721,1
loc_b_0359:
		cmp	byte ptr data_c_072A,0
		je	loc_b_0366		; Jump if equal
		dec	data_c_072A
		jmp	short loc_b_038B
loc_b_0366:
		cmp	byte ptr data_c_0729,0
		je	loc_b_0373		; Jump if equal
		dec	data_c_0729
		jnz	loc_b_038B		; Jump if not zero
loc_b_0373:
		call	sub_b_1128
		cmp	al,0EBh
		jb	loc_b_038B		; Jump if below
		cmp	byte ptr data_c_0728,0
		jne	loc_b_038B		; Jump if not equal
		mov	byte ptr data_c_0728,8
		mov	byte ptr data_c_0729,1
loc_b_038B:
		mov	si,5A8h
		mov	bx,offset data_c_071E
		mov	ah,data_c_04C1
		mov	al,2
		sub	ah,al
		mov	[bx+5],ah
		call	sub_b_03AF
		mov	si,offset data_c_05AB
		mov	bx,offset data_c_0726
		mov	al,data_c_04C1
		sub	al,5
		mov	[bx+5],al
		mov	al,3

;==== External Entry into Subroutine ======================================

sub_b_03AF:
		cmp	byte ptr [bx+2],0
		jne	loc_b_03B8		; Jump if not equal
loc_b_03B5:
		jmp	loc_ret_b_0491
loc_b_03B8:
		dec	byte ptr [bx+3]
		jnz	loc_b_03B5		; Jump if not zero
		mov	[si],al
		cmp	byte ptr [bx+5],0
		jne	loc_b_03CE		; Jump if not equal
		push	ax
		push	bx
		push	si
		call	sub_b_133F
		pop	si
		pop	bx
		pop	ax
loc_b_03CE:
		mov	di,[bx]
		dec	byte ptr [bx+2]
		mov	dl,[bx+2]
		jnz	loc_b_03E9		; Jump if not zero
		push	ax
		call	sub_b_1128
		and	al,3Fh			; '?'
		add	al,19h
		mov	[bx+3],al
		pop	ax
		mov	si,16C8h
		jmp	short loc_b_040F
loc_b_03E9:
		mov	byte ptr [bx+3],0Eh
		mov	si,17A9h
		cmp	dl,1
		je	loc_b_040F		; Jump if equal
		cmp	dl,7
		je	loc_b_040F		; Jump if equal
		mov	si,188Ah
		cmp	dl,2
		je	loc_b_040F		; Jump if equal
		cmp	dl,6
		je	loc_b_040F		; Jump if equal
		mov	si,offset data_c_196B
		cmp	dl,4
		je	loc_b_0461		; Jump if equal
loc_b_040F:
		push	dx
		push	di
		push	si
		call	sub_b_16F7
		pop	si
		push	si
		call	sub_b_16F7
		pop	si
		cmp	al,2
		je	loc_b_0422		; Jump if equal
		call	sub_b_16F7
loc_b_0422:
		pop	di
		pop	dx
		mov	dh,al
		xor	ax,ax			; Zero register
		mov	cx,ax
		cmp	dl,5
		je	loc_b_0446		; Jump if equal
		dec	al
		dec	ch
		cmp	dl,2
		je	loc_b_0446		; Jump if equal
		cmp	dl,6
		je	loc_b_0446		; Jump if equal
		cmp	dl,7
		jne	loc_b_0488		; Jump if not equal
		dec	ah
		dec	cl
loc_b_0446:
		mov	di,[bx+6]
		mov	[di],cx
		mov	[di+2],ax
		mov	[di+4],cx
		mov	[di+6],ax
		cmp	dh,2
		je	loc_b_0488		; Jump if equal
		mov	[di+8],cx
		mov	[di+0Ah],ax
		jmp	short loc_b_0488
loc_b_0461:
		mov	byte ptr [bx+3],1Eh
		mov	dx,10h
		mov	bp,160h
		cmp	al,2
		je	loc_b_0475		; Jump if equal
		mov	dx,18h
		mov	bp,150h
loc_b_0475:
		mov	es,data_c_04A6
		mov	si,0Eh
		mov	ax,5F5Fh
loc_b_047F:
		mov	cx,dx
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		add	di,bp
		dec	si
		jnz	loc_b_047F		; Jump if not zero
loc_b_0488:
		cmp	byte ptr [bx+5],0
		jne	loc_ret_b_0491		; Jump if not equal
		call	sub_b_126E

loc_ret_b_0491:
		retn
sub_b_0327	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0492	proc	near
		cmp	byte ptr data_c_0384,3
		jb	loc_ret_b_0491		; Jump if below
		dec	data_c_073E
		jnz	loc_ret_b_0491		; Jump if not zero
		mov	byte ptr data_c_073E,2
		mov	byte ptr data_c_05AC,0FFh
		cmp	data_c_073A,0
		jne	loc_b_0520		; Jump if not equal
		mov	si,3888h
		mov	di,30h
		xor	dx,dx			; Zero register
;*		cmp	data_c_0738,0FFFCh
		db	 83h, 3Eh, 38h, 07h,0FCh	;  Fixup - byte match
		jz	loc_b_04C8		; Jump if zero
		mov	si,offset data_c_3DC8
		mov	di,10h
		mov	dx,150h
loc_b_04C8:
		mov	byte ptr data_c_073F,0
		mov	data_c_0734,dx
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		add	dx,984h
		mov	data_c_0736,dx
		mov	data_c_073C,si
		mov	data_c_0620,di
		push	di
		call	sub_b_05D6
		mov	ax,seg_c
		mov	es,ax
		mov	di,data_c_0736
		mov	ax,101h
		mov	cx,6
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		pop	di
		cmp	byte ptr data_c_04C1,6
		jne	loc_b_0519		; Jump if not equal
		push	di
		call	sub_b_133F
		pop	ax
		add	ax,data_c_04C2
		cmp	ax,180h
		jb	loc_b_0513		; Jump if below
		sub	ax,180h
loc_b_0513:
		mov	data_c_04C2,ax
		call	sub_b_126E
loc_b_0519:
		mov	data_c_073A,0C0h
		retn
loc_b_0520:
		dec	data_c_073A
		jnz	loc_b_058A		; Jump if not zero
		mov	es,data_c_04A6
		mov	di,data_c_0734
		add	di,d_0000_7F80_e
		mov	dl,0Ch
		mov	ax,3030h
loc_b_0537:
		mov	cx,18h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		add	di,offset data_c_0127+29h	; ('g Q turns the sound on a')
		dec	dl
		jnz	loc_b_0537		; Jump if not zero
		mov	ax,seg_c
		mov	es,ax
		mov	ax,0FFFFh
		mov	di,data_c_0736
		mov	cx,6
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		cmp	byte ptr data_c_04C1,6
		jne	loc_b_0577		; Jump if not equal
		call	sub_b_133F
		mov	ax,data_c_04C2
		sub	ax,data_c_0620
		jnc	loc_b_056B		; Jump if carry=0
		add	ax,180h
loc_b_056B:
		mov	data_c_04C2,ax
		mov	data_c_0620,0
		call	sub_b_126E
loc_b_0577:
		mov	ax,data_c_0738
		neg	ax
		mov	data_c_0738,ax
		call	sub_b_1128
		and	al,7Fh
		add	al,32h			; '2'
		mov	data_c_073E,al
		retn
loc_b_058A:
		mov	si,data_c_073C
		cmp	byte ptr data_c_073F,0
		jne	loc_b_05A2		; Jump if not equal
		inc	data_c_073F
		add	si,2A0h
		call	sub_b_05F3
		jmp	short loc_b_05C8
loc_b_05A2:
		mov	byte ptr data_c_073F,0
		call	sub_b_05F3
		mov	ax,data_c_0620
		add	ax,data_c_0738
		cmp	ax,180h
		jb	loc_b_05C5		; Jump if below
		cmp	data_c_0738,4
		jne	loc_b_05C2		; Jump if not equal
		sub	ax,180h
		jmp	short loc_b_05C5
loc_b_05C2:
		add	ax,180h
loc_b_05C5:
		mov	data_c_0620,ax
loc_b_05C8:
		call	sub_b_05D6
		cmp	byte ptr data_c_04C1,6
		jne	loc_ret_b_05D5		; Jump if not equal
		call	sub_b_126E

loc_ret_b_05D5:
		retn
sub_b_0492	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_05D6	proc	near
		mov	di,data_c_0734
		add	di,d_0000_7E00_e
		mov	es,data_c_04A6
		cld				; Clear direction
		mov	dl,0Eh
loc_b_05E5:
		mov	cx,18h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,150h
		dec	dl
		jnz	loc_b_05E5		; Jump if not zero
		retn
sub_b_05D6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_05F3	proc	near
		cmp	byte ptr ds:[4C1h],6
		jne	loc_ret_b_0624		; Jump if not equal
		push	si
		call	sub_b_133F
		cmp	byte ptr ds:[73Fh],0
		jne	loc_b_0623		; Jump if not equal
		mov	ax,word ptr ds:[4C2h]
		add	ax,word ptr ds:[738h]
		cmp	ax,180h
		jb	loc_b_0620		; Jump if below
		cmp	word ptr ds:[738h],4
		jne	loc_b_061D		; Jump if not equal
		sub	ax,180h
		jmp	short loc_b_0620
loc_b_061D:
		add	ax,180h
loc_b_0620:
		mov	word ptr ds:[4C2h],ax
loc_b_0623:
		pop	si

loc_ret_b_0624:
		retn
sub_b_05F3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0625	proc	near
		cmp	data_c_072E,0
		je	loc_ret_b_067A		; Jump if equal
		dec	data_c_0730
		jnz	loc_ret_b_067A		; Jump if not zero
		cmp	byte ptr data_c_04C1,1
		jne	loc_b_063C		; Jump if not equal
		call	sub_b_133F
loc_b_063C:
		call	sub_b_1128
		and	al,7Fh
		add	al,20h			; ' '
		mov	data_c_0730,al
		mov	al,data_c_0731
		not	al
		mov	data_c_0731,al
		mov	byte ptr data_c_05A7,0FFh
		mov	dx,0FFFFh
		mov	si,2EE3h
		or	al,al			; Zero ?
		jz	loc_b_0663		; Jump if zero
		mov	dx,101h
		mov	si,offset data_c_3219+4Bh	; ('@_______________________')
loc_b_0663:
		mov	bx,data_c_0732
		mov	[bx],dx
		mov	di,data_c_072E
		call	sub_b_16F7
		cmp	byte ptr data_c_04C1,1
		jne	loc_ret_b_067A		; Jump if not equal
		call	sub_b_126E

loc_ret_b_067A:
		retn
sub_b_0625	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_067B	proc	near
		cmp	byte ptr data_c_0743,2
		jae	loc_ret_b_067A		; Jump if above or =
		dec	data_c_0638
		jnz	loc_ret_b_067A		; Jump if not zero
		inc	data_c_0743
		cmp	byte ptr data_c_0743,1
		je	loc_b_0696		; Jump if equal
		jmp	loc_b_0722
loc_b_0696:
		cmp	byte ptr data_c_04C1,4
		je	loc_b_06AF		; Jump if equal
		mov	ax,seg_c
		mov	es,ax
		mov	cx,5Ch
		mov	al,0FFh
		mov	di,offset data_c_08C4
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jz	loc_b_06B3		; Jump if zero
loc_b_06AF:
		call	sub_b_0759
		retn
loc_b_06B3:
		dec	di
		call	sub_b_1128
		and	al,7
		cbw				; Convrt byte to word
		add	di,ax
		mov	data_c_063C,di
		sub	di,8C4h
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		add	di,offset data_c_5400
		mov	data_c_063A,di
		mov	di,data_c_063C
		mov	ax,202h
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	data_c_0638,240h
		mov	di,offset data_c_063E
		mov	si,data_c_063A
		push	ds
		mov	ds,data_c_04A6
		mov	dl,0Eh
loc_b_06ED:
		mov	cx,8
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,170h
		dec	dl
		jnz	loc_b_06ED		; Jump if not zero
		pop	ds
		mov	es,data_c_04A6
		mov	di,data_c_063A
		mov	bx,offset data_c_4A08
		mov	si,offset data_c_4308
		mov	dl,0Eh
loc_b_070B:
		mov	cx,10h

locloop_b_070E:
		lodsb				; String [si] to al
		and	al,es:[di]
		or	al,[bx]
		stosb				; Store al to es:[di]
		inc	bx
		loop	locloop_b_070E		; Loop if cx > 0

		add	di,offset data_c_0170	; (' &P pauses the g')
		dec	dl
		jnz	loc_b_070B		; Jump if not zero
		jmp	short loc_b_0753

;==== External Entry into Subroutine ======================================

sub_b_0722:
loc_b_0722:
		mov	byte ptr data_c_0743,0
		mov	ax,seg_c
		mov	es,ax
		mov	di,data_c_063C
		mov	ax,0FFFFh
		cld				; Clear direction
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	es,data_c_04A6
		mov	di,data_c_063A
		mov	si,offset data_c_063E
		mov	dl,0Eh
loc_b_0743:
		mov	cx,8
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,170h
		dec	dl
		jnz	loc_b_0743		; Jump if not zero
		call	sub_b_0759
loc_b_0753:
		mov	byte ptr data_c_05AA,0FFh
		retn
sub_b_067B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0759	proc	near
		cmp	byte ptr data_c_0743,1
		je	loc_ret_b_0777		; Jump if equal
		mov	byte ptr data_c_0743,0
		call	sub_b_1128
loc_b_0768:
		cmp	al,64h			; 'd'
		jb	loc_b_0770		; Jump if below
		sub	al,64h			; 'd'
		jmp	short loc_b_0768
loc_b_0770:
		add	al,32h			; '2'
		xor	ah,ah			; Zero register
		mov	data_c_0638,ax

loc_ret_b_0777:
		retn
sub_b_0759	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0778	proc	near
		mov	bl,data_c_04C1
		xor	bh,bh			; Zero register
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_c_0614[bx]
		mov	dx,ax
		sub	ax,4
		jnc	loc_b_078E		; Jump if carry=0
		add	ax,180h
loc_b_078E:
		cmp	ax,data_c_04C2
		je	loc_b_07FB		; Jump if equal
		add	ax,134h
		add	dx,130h
		cmp	ax,180h
		jb	loc_b_07A3		; Jump if below
		sub	ax,180h
loc_b_07A3:
		cmp	ax,data_c_04C2
		je	loc_b_07FB		; Jump if equal
		mov	si,data_c_04C2
		mov	dx,si
		shr	si,1			; Shift w/zeros fill
		shr	si,1			; Shift w/zeros fill
		add	si,data_c_05CA[bx]
		xor	al,al			; Zero register
		mov	cx,4

locloop_b_07BC:
		cmp	byte ptr [si],1
		je	loc_b_07FB		; Jump if equal
		or	al,[si]
		cmp	byte ptr [si],2
		jne	loc_b_07EB		; Jump if not equal
		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	es
		call	sub_b_133F
		call	sub_b_0722
		call	sub_b_126E
		mov	byte ptr data_c_0743,2
		mov	data_c_04A4,0ED0h
		call	sub_b_1807
		pop	es
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
loc_b_07EB:
		inc	si
		cmp	si,data_c_05CC[bx]
		jb	loc_b_07F5		; Jump if below
		sub	si,60h
loc_b_07F5:
		loop	locloop_b_07BC		; Loop if cx > 0

		or	al,al			; Zero ?
		jnz	loc_b_07FE		; Jump if not zero
loc_b_07FB:
		jmp	loc_b_0906
loc_b_07FE:
		cmp	byte ptr data_c_04C1,0
		je	loc_b_0806		; Jump if equal
		retn
loc_b_0806:
		add	sp,2
		mov	ax,seg_c
		mov	es,ax
		mov	di,data_c_04C2
		shr	di,1			; Shift w/zeros fill
		shr	di,1			; Shift w/zeros fill
		add	di,offset data_c_0744
		mov	cx,18h
		std				; Set direction flag
		mov	al,1
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		cld				; Clear direction
		add	di,2
		push	di
		mov	ax,101h
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	byte ptr data_c_05A6,1
		mov	es,data_c_04A6
		pop	di
		sub	di,744h
		shl	di,1			; Shift w/zeros fill
		shl	di,1			; Shift w/zeros fill
		mov	si,offset data_c_35E5
		call	sub_b_16F7
		call	sub_b_1158
		mov	cl,byte ptr data_c_04AE+1
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		shr	cl,1			; Shift w/zeros fill
		jz	loc_b_087D		; Jump if zero
		xor	ch,ch			; Zero register

locloop_b_0856:
		push	cx
		mov	al,1
		call	sub_b_0A9C
		cmp	byte ptr ds:[4ACh],0
		jne	loc_b_087A		; Jump if not equal
		mov	byte ptr ds:[4ACh],32h	; '2'
		call	sub_b_11D6
		call	sub_b_0327
		call	sub_b_0492
		call	sub_b_0625
		call	sub_b_067B
		call	sub_b_1158
loc_b_087A:
		pop	cx
		loop	locloop_b_0856		; Loop if cx > 0

loc_b_087D:
		cmp	byte ptr ds:[743h],2
		jb	loc_b_088F		; Jump if below
		mov	al,5
		mov	bx,0BCDh
		call	sub_b_0A9F
		call	sub_b_0759
loc_b_088F:
		inc	byte ptr ds:[742h]
		cmp	byte ptr ds:[742h],6
		je	loc_b_089D		; Jump if equal
		jmp	loc_b_01E7
loc_b_089D:
		mov	al,5
		cmp	byte ptr ds:[741h],0
		jne	loc_b_08A8		; Jump if not equal
		mov	al,2
loc_b_08A8:
		mov	bx,0BCDh
		call	sub_b_0A9F
		cmp	byte ptr ds:[741h],0
		jne	loc_b_08BA		; Jump if not equal
		mov	al,5
		call	sub_b_0A9C
loc_b_08BA:
		call	sub_b_1128
loc_b_08BD:
		cmp	al,5
		jb	loc_b_08C5		; Jump if below
		sub	al,5
		jmp	short loc_b_08BD
loc_b_08C5:
		mov	si,0D14h
		or	al,al			; Zero ?
		jz	loc_b_08E4		; Jump if zero
		mov	si,0D4Ch
		dec	al
		jz	loc_b_08E4		; Jump if zero
		mov	si,0D84h
		dec	al
		jz	loc_b_08E4		; Jump if zero
		mov	si,0DF0h
		dec	al
		jz	loc_b_08E4		; Jump if zero
		mov	si,0E28h
loc_b_08E4:
		mov	data_c_04A4,si
		call	sub_b_1807
loc_b_08EB:
		call	sub_b_110D
		cmp	byte ptr data_c_04B1,0
		jne	loc_b_08EB		; Jump if not equal
		mov	cx,0Ah

locloop_b_08F8:
		push	cx
		call	sub_b_110D
		pop	cx
		loop	locloop_b_08F8		; Loop if cx > 0

		inc	data_c_0384
		jmp	loc_b_01E4
loc_b_0906:
		push	dx
		call	sub_b_133F
		pop	dx
		cmp	dx,180h
		jb	loc_b_0915		; Jump if below
		sub	dx,180h
loc_b_0915:
		mov	data_c_04C2,dx
		mov	data_c_04C4,4AE8h
		call	sub_b_126E
		mov	byte ptr data_c_0740,0FFh
		mov	byte ptr data_c_0741,0FFh
		mov	bx,0EB8h
		mov	data_c_04A4,bx
		call	sub_b_1807
		call	sub_b_1158
		call	sub_b_0FC1
		mov	cx,19h

locloop_b_093F:
		push	cx
		call	sub_b_110D
		pop	cx
		loop	locloop_b_093F		; Loop if cx > 0

loc_b_0946:
		cmp	byte ptr data_c_04B1,0
		je	loc_b_0952		; Jump if equal
		call	sub_b_110D
		jmp	short loc_b_0946
loc_b_0952:
		call	sub_b_133F
		mov	bl,data_c_04C1
		xor	bh,bh			; Zero register
		mov	byte ptr data_c_05A6[bx],1
		call	sub_b_1158
		add	sp,2
		dec	data_c_0382
		pushf				; Push flags
		call	sub_b_0B26
		popf				; Pop flags
		jz	loc_b_0974		; Jump if zero
		jmp	loc_b_01E7
loc_b_0974:
		mov	byte ptr data_c_04C1,0
		mov	data_c_04A4,0E6Ch
		call	sub_b_1807
loc_b_0982:
		call	sub_b_110D
		cmp	byte ptr data_c_04B1,0
		jne	loc_b_0982		; Jump if not equal
		mov	cx,0Ah

locloop_b_098F:
		push	cx
		call	sub_b_110D
		pop	cx
		loop	locloop_b_098F		; Loop if cx > 0

		mov	ax,seg_c
		mov	es,ax
		mov	bx,0BD0h
		mov	dx,0Ah
loc_b_09A1:
		; check high score
		mov	di,bx
		mov	cx,0Ch
		mov	si,offset data_c_0BC4	; ('000000000000000000000000')
		repe	cmpsb			; Rep zf=1+cx >0 Cmp [si] to es:[di]

; !!! Picopad modification - no high score
;		ja	loc_b_09BD		; Jump if above
		nop
		nop

		add	bx,20h
		dec	dx
		jnz	loc_b_09A1		; Jump if not zero
		mov	dh,0Ch
		mov	bl,0FFh
		call	sub_b_0A4F		; Write BIOS text 'Press any key.' and wait for a key
		jmp	loc_b_00F5

; New high score

loc_b_09BD:
		mov	cx,0D0Fh
		sub	cx,bx
		sub	cx,20h
		jbe	loc_b_09D2		; Jump if below or =
		mov	di,offset data_c_0D0F
		mov	si,di
		sub	si,20h
		std				; Set direction flag
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]

loc_b_09D2:
		mov	si,offset data_c_0BC4	; ('000000000000000000000000')
		mov	di,bx
		mov	cx,0Ch
		cld				; Clear direction
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]

		mov	di,bx
		add	di,0Ch
		push	di
		mov	di,offset data_c_0348	; New High Score
		mov	bx,2Fh
		call	sub_b_0AF3
		pop	di
		push	di
		cld				; Clear direction
		mov	cx,0Ah
		mov	ax,2020h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		pop	di
		mov	dx,0C13h
		call	sub_b_0A04
		call	sub_b_1072		; Write score file
		jmp	loc_b_00F5
sub_b_0778	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A04	proc	near
		mov	si,di
		mov	byte ptr [di],5Fh	; '_'
		jmp	short loc_b_0A3D
loc_b_0A0B:
		push	di
		push	si
		push	dx

		; input key from keyboard
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		pop	dx
		pop	si
		pop	di
		cmp	al,8
		jne	loc_b_0A24		; Jump if not equal
		cmp	di,si
		je	loc_b_0A0B		; Jump if equal
		dec	di
		mov	word ptr [di],205Fh
		jmp	short loc_b_0A3D
loc_b_0A24:
		cmp	al,0Dh
		jne	loc_b_0A2C		; Jump if not equal
		mov	byte ptr [di],20h	; ' '
		retn
loc_b_0A2C:
		cmp	al,20h			; ' '
		jb	loc_b_0A0B		; Jump if below
		mov	bp,si
		add	bp,13h
		cmp	di,bp
		je	loc_b_0A0B		; Jump if equal
		stosb				; Store al to es:[di]
		mov	byte ptr [di],5Fh	; '_'
loc_b_0A3D:
		push	di
		push	si
		push	dx
		mov	bp,si
		mov	bl,0FFh
		mov	cx,14h
		call	sub_b_0B19		; Write BIOS text BP
		pop	dx
		pop	si
		pop	di
		jmp	short loc_b_0A0B
sub_b_0A04	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Write BIOS text 'Press any key.' and wait for a key

sub_b_0A4F	proc	near
		mov	bp,371h		; text 'Press any key.'
		mov	cx,0Eh
		mov	dl,0Dh
		call	sub_b_0B19		; Write BIOS text BP
		call	sub_b_1013		; Flush keyboard

		; input key from keyboard
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		retn
sub_b_0A4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A62	proc	near
		dec	byte ptr data_c_04AE
		jnz	loc_ret_b_0A9B		; Jump if not zero
		mov	byte ptr data_c_04AE,2
		mov	ax,0A000h
		mov	es,ax
		mov	bx,data_c_04B2
		mov	es:[bx],al
		inc	bx
		mov	data_c_04B2,bx
		cmp	bx,data_c_04B4
		jne	loc_b_0A8E		; Jump if not equal
		mov	bx,0EC4h
		mov	data_c_04A4,bx
		call	sub_b_1807
loc_b_0A8E:
		mov	dx,data_c_04C2
		dec	byte ptr data_c_04AE+1
		jnz	loc_ret_b_0A9B		; Jump if not zero
		jmp	loc_b_0906

loc_ret_b_0A9B:
		retn
sub_b_0A62	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0A9C	proc	near
		mov	bx,0BCEh

;==== External Entry into Subroutine ======================================

sub_b_0A9F:
loc_b_0A9F:
		add	al,[bx]
		mov	[bx],al
		cmp	al,3Ah			; ':'
		jb	loc_b_0AB4		; Jump if below
		sub	al,0Ah
		mov	[bx],al
		mov	al,1
		dec	bx
		cmp	bx,0BC4h
		jae	loc_b_0A9F		; Jump if above or =
loc_b_0AB4:
		mov	ax,seg_c
		mov	es,ax
		mov	di,offset data_c_0BC4	; ('000000000000000000000000') ; high score file
		mov	cx,0Ch
		mov	al,30h			; '0'
		cld				; Clear direction
		repe	scasb			; Rep zf=1+cx >0 Scan es:[di] for al
		inc	cx
		dec	di
		mov	bp,di
		mov	bl,0Bh
		mov	dx,8
		call	sub_b_0B19		; Write BIOS text BP
		mov	al,byte ptr ds:[383h]
		cmp	al,byte ptr ds:[0BCBh]
		jne	loc_ret_b_0AF2		; Jump if not equal
		add	al,2
		cmp	al,39h			; '9'
		jb	loc_b_0AE1		; Jump if below
		mov	al,30h			; '0'
loc_b_0AE1:
		mov	byte ptr ds:[383h],al
		cmp	byte ptr ds:[382h],0FFh
		je	loc_ret_b_0AF2		; Jump if equal
		inc	byte ptr ds:[382h]
		call	sub_b_0B26

loc_ret_b_0AF2:
		retn
sub_b_0A9C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0AF3	proc	near
		mov	ax,seg_c
		mov	es,ax
loc_b_0AF8:
		mov	dx,[di]
;*		cmp	dx,0FFFFh
		db	 83h,0FAh,0FFh		;  Fixup - byte match
		jz	loc_ret_b_0B18		; Jump if zero
		xor	ch,ch			; Zero register
		mov	cl,[di+2]
		add	di,3
		mov	bp,di
		push	bx
		push	cx
		push	di
		call	sub_b_0B19		; Write BIOS text BP
		pop	di
		pop	cx
		pop	bx
		add	bl,bh
		add	di,cx
		jmp	short loc_b_0AF8

loc_ret_b_0B18:
		retn
sub_b_0AF3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Write BIOS text BP

sub_b_0B19	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	ax,1300h
		mov	bh,al
		int	10h			; Video display   ah=functn 13h
						;  write string, al=mode,bh=page
						;   bl=attrib, cx=string length
						;   dh=row, dl=column, at es:bp
		retn
sub_b_0B19	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0B26	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	al,byte ptr ds:[382h]
		mov	di,offset data_c_0385
		cld				; Clear direction
		mov	cl,64h			; 'd'
		xor	ah,ah			; Zero register
		div	cl			; al, ah rem = ax/reg
		add	al,30h			; '0'
		stosb				; Store al to es:[di]
		mov	cl,0Ah
		mov	al,ah
		xor	ah,ah			; Zero register
		div	cl			; al, ah rem = ax/reg
		add	ax,3030h
		stosw				; Store ax to es:[di]
		mov	di,offset data_c_0385
		mov	cx,3
		mov	al,30h			; '0'
		repe	scasb			; Rep zf=1+cx >0 Scan es:[di] for al
		add	cx,2
		dec	di
		mov	bl,0E4h
		mov	dx,25h
		mov	bp,di
		call	sub_b_0B19		; Write BIOS text BP
		retn
sub_b_0B26	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0B60	proc	near
		call	sub_b_16EA		; Clear screen
		mov	di,offset data_c_0069
		mov	bx,0FF1Fh
		call	sub_b_0AF3
		mov	di,offset data_c_01B4
		mov	bx,0FF1Dh
		call	sub_b_0AF3
		mov	dh,18h
		mov	bl,1Fh
		call	sub_b_0A4F		; Write BIOS text 'Press any key.' and wait for a key
		retn
sub_b_0B60	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0B7D	proc	near
		call	sub_b_16EA		; Clear screen
		mov	ax,seg_c
		mov	es,ax

		; set palettes
		mov	ax,1012h
		mov	bx,45h
		mov	cx,40h
		mov	dx,offset data_c_1608
		int	10h			; Video display   ah=functn 10h
						;  set cx color registers from
						;   ptr es:dx, bx=first reg
		mov	ax,0A000h
		mov	es,ax
		xor	bl,bl			; Zero register
		mov	cx,10h
		mov	di,d_A000_140C_e
		cld				; Clear direction

locloop_b_0BA1:
		push	di
		push	cx
		mov	si,offset data_c_43E8
		mov	cx,0Eh

locloop_b_0BA9:
		mov	bh,10h
loc_b_0BAB:
		lodsb				; String [si] to al
		cmp	al,45h			; 'E'
		jb	loc_b_0BB6		; Jump if below
		cmp	al,48h			; 'H'
		jae	loc_b_0BB6		; Jump if above or =
		add	al,bl
loc_b_0BB6:
		stosb				; Store al to es:[di]
		dec	bh
		jnz	loc_b_0BAB		; Jump if not zero
		add	di,130h
		loop	locloop_b_0BA9		; Loop if cx > 0

		pop	cx
		pop	di
		add	di,28h
		add	bl,4
		cmp	bl,20h			; ' '
		jne	loc_b_0BD1		; Jump if not equal
		mov	di,7D0Ch
loc_b_0BD1:
		loop	locloop_b_0BA1		; Loop if cx > 0

		mov	dx,402h
		mov	ax,4541h
loc_b_0BD9:
		push	dx
		push	ax

		; set cursor
		xor	bh,bh			; Zero register
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx

		; write character
		pop	ax
		push	ax
		mov	bl,ah
		mov	ah,9
		mov	cx,1
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		pop	ax
		pop	dx

		add	ax,401h
		add	dl,5
		cmp	dl,28h			; '('
		jb	loc_b_0BD9		; Jump if below

		cmp	dh,0Fh
		mov	dx,0F02h
		jnz	loc_b_0BD9		; Jump if not zero
		mov	ax,data_c_048C
		sub	ax,1608h
		mov	cl,0Ch
		div	cl			; al, ah rem = ax/reg
		mov	ch,al
		xor	ah,ah			; Zero register
		mov	cl,28h			; '('
		mul	cl			; ax = reg * al
		add	ax,3210h
		cmp	ch,8
		jb	loc_b_0C1E		; Jump if below
		add	ax,6E00h
loc_b_0C1E:
		mov	di,ax
		mov	al,0FFh
		mov	cx,7
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	di,offset data_c_02B3
		mov	bx,130h
		call	sub_b_0AF3
loc_b_0C30:
		; wait for a key
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	al,1Bh			; Esc
		je	loc_b_0C5E		; Jump if equal

		; key A...P
		cmp	al,41h			; 'A'
		jb	loc_b_0C30		; Jump if below
		cmp	al,51h			; 'Q'
		jb	loc_b_0C48		; Jump if below
		cmp	al,61h			; 'a'
		jb	loc_b_0C30		; Jump if below
		cmp	al,71h			; 'q'
		jae	loc_b_0C30		; Jump if above or =

loc_b_0C48:
		and	al,0DFh
		sub	al,41h			; 'A'
		mov	ah,al
		shl	ah,1			; Shift w/zeros fill
		add	al,ah
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		xor	ah,ah			; Zero register
		add	ax,1608h
		mov	data_c_048C,ax
loc_b_0C5E:
		call	sub_b_16EA		; Clear screen
		retn
sub_b_0B7D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set palettes

sub_b_0C62	proc	near

		; set palettes
		mov	ax,seg_c
		mov	es,ax
		mov	ax,1012h
		mov	cx,3
		mov	bx,45h
		mov	dx,data_c_048C
		int	10h			; Video display   ah=functn 10h
						;  set cx color registers from
						;   ptr es:dx, bx=first reg
		mov	ax,1010h
		mov	bx,data_c_048C
		mov	dh,[bx+9]
		mov	ch,[bx+0Ah]
		mov	cl,[bx+0Bh]
		mov	bx,0E0h
		int	10h			; Video display   ah=functn 10h
						;  set color reg bx with colors
						;   dh=red, ch=green, cl=blue
		retn
sub_b_0C62	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0C8C	proc	near
		push	ds
		mov	es,data_c_04A6
		mov	si,d_A000_5A00_e
		mov	di,d_0000_007D_e
		mov	dl,15h
		mov	ax,0A000h
		mov	ds,ax
		cld				; Clear direction
loc_b_0C9F:
		mov	cx,0A0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,0FAh
		dec	dl
		jnz	loc_b_0C9F		; Jump if not zero
		mov	ax,es
		mov	ds,ax
		xor	si,si			; Zero register
		mov	di,d_0000_2EE0_e
		mov	cx,1761h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		retn
sub_b_0C8C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0CBC	proc	near
		push	ds
		mov	es,data_c_04A6
		mov	ds,data_c_04A6
		xor	di,di			; Zero register
		mov	si,d_0000_2EE0_e
		mov	cx,1761h
		cld				; Clear direction
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		mov	di,data_c_038B
		cmp	di,1D6h
		jb	loc_b_0CE3		; Jump if below
		mov	data_c_038B,0
		jmp	short loc_b_0D11
loc_b_0CE3:
		inc	di
		mov	data_c_038B,di
		add	di,d_0000_023A_e
		mov	si,offset data_c_AE08
		mov	dl,14h
		mov	bp,1BDh
loc_b_0CF4:
		mov	cx,7Dh

locloop_b_0CF7:
		lodsb				; String [si] to al
		cmp	byte ptr es:[di],0Bh
		je	loc_b_0D01		; Jump if equal
		inc	di
		jmp	short loc_b_0D09
loc_b_0D01:
		and	al,es:[di]
		or	al,data_c_09C3[si]
		stosb				; Store al to es:[di]
loc_b_0D09:
		loop	locloop_b_0CF7		; Loop if cx > 0

		add	di,bp
		dec	dl
		jnz	loc_b_0CF4		; Jump if not zero
loc_b_0D11:
		mov	al,data_c_038E
		dec	data_c_038D
		jnz	loc_b_0D2F		; Jump if not zero
		call	sub_b_1128
		and	al,3
		inc	al
		mov	data_c_038D,al
		mov	al,data_c_038E
		inc	al
		cmp	al,9
		jb	loc_b_0D2F		; Jump if below
		xor	al,al			; Zero register
loc_b_0D2F:
		mov	data_c_038E,al
		or	al,al			; Zero ?
		jz	loc_b_0D6F		; Jump if zero
		dec	al
		mov	cl,0E0h
		mul	cl			; ax = reg * al
		mov	si,offset data_c_C190
		add	si,ax
		mov	di,data_c_038B
		add	di,63h
		mov	dl,7
		mov	bp,22Ah
loc_b_0D4D:
		mov	cx,10h

locloop_b_0D50:
		lodsb				; String [si] to al
		mov	ah,es:[di]
		cmp	ah,0Bh
		je	loc_b_0D61		; Jump if equal
		cmp	ah,0FFh
		je	loc_b_0D61		; Jump if equal
		inc	di
		jmp	short loc_b_0D67
loc_b_0D61:
		and	al,ah
		or	al,[si+6Fh]
		stosb				; Store al to es:[di]
loc_b_0D67:
		loop	locloop_b_0D50		; Loop if cx > 0

		add	di,bp
		dec	dl
		jnz	loc_b_0D4D		; Jump if not zero
loc_b_0D6F:
		push	ds
		mov	ds,data_c_04A6
		mov	ax,0A000h
		mov	es,ax
		mov	si,d_0000_007D_e
		mov	di,d_A000_5A00_e
		mov	bp,0FAh
		mov	dl,15h
loc_b_0D84:
		mov	cx,0A0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,bp
		dec	dl
		jnz	loc_b_0D84		; Jump if not zero
		pop	ds
		retn
sub_b_0CBC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0D91	proc	near
		xor	ax,ax			; Zero register
		mov	data_c_038B,ax
		mov	data_c_038E,al
		mov	byte ptr data_c_038D,1
		mov	data_c_038F,ax
		mov	data_c_0476,ax
		mov	data_c_0391,140h
		call	sub_b_1128
		and	al,3
		inc	al
		mov	data_c_0475,al
		call	sub_b_16EA		; Clear screen
		mov	ax,0A000h
		mov	es,ax
		mov	si,offset data_c_4CA8	; 2nd intro image
		xor	di,di			; Zero register
		xor	ch,ch			; Zero register
		cld				; Clear direction

		; display image (with RLE compression)
loc_b_0DC4:
		lodsw				; String [si] to ax
		cmp	ax,0FFFFh
		je	loc_ret_b_0DD9		; Jump if equal
		mov	cl,ah
		mov	ah,al
		shr	cl,1			; Shift w/zeros fill
		jnc	loc_b_0DD3		; Jump if carry=0
		stosb				; Store al to es:[di]
loc_b_0DD3:
		jcxz	loc_b_0DC4		; Jump if cx=0
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		jmp	short loc_b_0DC4

loc_ret_b_0DD9:
		retn
sub_b_0D91	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0DDA	proc	near
		mov	si,0A908h
		mov	dx,0A988h
		cmp	byte ptr data_c_04B7,0
		je	loc_b_0DED		; Jump if equal
		mov	si,offset data_c_A948
		mov	dx,0ABC8h
loc_b_0DED:
		push	dx
		mov	di,0E658h
		mov	cx,8
		call	sub_b_0DFE
		pop	si
		mov	di,d_A000_E680_e
		mov	cx,48h

;==== External Entry into Subroutine ======================================

sub_b_0DFE:
		mov	ax,0A000h
		mov	es,ax
		mov	bp,140h
		sub	bp,cx
		shr	cx,1			; Shift w/zeros fill
		mov	dl,8
		cld				; Clear direction
loc_b_0E0D:
		push	cx
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,bp
		pop	cx
		dec	dl
		jnz	loc_b_0E0D		; Jump if not zero
		retn
sub_b_0DDA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0E18	proc	near
		mov	ax,0A000h
		mov	es,ax
		mov	dh,0Dh
loc_b_0E1F:
		mov	cx,10h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,120h
		dec	dh
		jnz	loc_b_0E1F		; Jump if not zero
		retn
sub_b_0E18	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0E2D	proc	near
		call	sub_b_1128
		and	al,7
		add	al,8
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		mov	data_c_0389,al
		retn
sub_b_0E2D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0E3E	proc	near
		dec	data_c_0475
		jnz	loc_ret_b_0E6E		; Jump if not zero
		cmp	data_c_038F,0
		jne	loc_b_0E6F		; Jump if not equal
loc_b_0E4B:
		call	sub_b_1128
		and	al,1
		mov	dh,al
		call	sub_b_1128
		mov	ah,dh
		cmp	ax,130h
		jae	loc_b_0E4B		; Jump if above or =
		mov	data_c_0393,ax
		add	ax,0E880h
		mov	data_c_038F,ax
		mov	data_c_0391,0FEC0h
		call	sub_b_0EC8

loc_ret_b_0E6E:
		retn
loc_b_0E6F:
		call	sub_b_0F3C
		mov	di,word ptr ds:[38Fh]
		add	di,word ptr ds:[391h]
		cmp	di,0E880h
		jb	loc_b_0E9A		; Jump if below
		mov	word ptr ds:[38Fh],0
		mov	byte ptr ds:[477h],0
		call	sub_b_1128
		and	al,3Fh			; '?'
		add	al,14h
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		mov	byte ptr ds:[475h],al
		retn
loc_b_0E9A:
		cmp	di,0ADC0h
		jae	loc_b_0EAA		; Jump if above or =
		mov	word ptr ds:[391h],140h
		dec	byte ptr ds:[477h]
loc_b_0EAA:
		call	sub_b_1128
		and	al,3
		dec	al
		cbw				; Convrt byte to word
		mov	dx,word ptr ds:[393h]
		add	dx,ax
		cmp	dx,130h
		jae	loc_b_0EC4		; Jump if above or =
		add	di,ax
		mov	word ptr ds:[393h],dx
loc_b_0EC4:
		mov	word ptr ds:[38Fh],di
sub_b_0E3E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0EC8	proc	near
		call	sub_b_0F18
		mov	ax,0A000h
		mov	es,ax
		mov	di,word ptr ds:[38Fh]
		mov	si,0A208h
		not	byte ptr ds:[476h]
		cmp	byte ptr ds:[476h],0
		jne	loc_b_0EE5		; Jump if not equal
		mov	si,0A3C8h
loc_b_0EE5:
		cmp	byte ptr ds:[477h],0
		je	loc_b_0EF0		; Jump if equal
		add	si,380h
loc_b_0EF0:
		mov	dl,0Eh
loc_b_0EF2:
		mov	cx,10h

locloop_b_0EF5:
		cmp	byte ptr es:[di],0Ah
		jne	loc_b_0EFF		; Jump if not equal
		inc	di
		inc	si
		jmp	short loc_b_0F08
loc_b_0EFF:
		lodsb				; String [si] to al
		and	al,es:[di]
		or	al,byte ptr ds:[0DFh][si]
		stosb				; Store al to es:[di]
loc_b_0F08:
		loop	locloop_b_0EF5		; Loop if cx > 0

		add	di,130h
		dec	dl
		jnz	loc_b_0EF2		; Jump if not zero
		mov	byte ptr ds:[475h],4
		retn
sub_b_0EC8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0F18	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	si,data_c_038F
		mov	di,offset data_c_0395
		push	ds
		mov	ax,0A000h
		mov	ds,ax
		cld				; Clear direction
		mov	dl,0Eh
loc_b_0F2D:
		mov	cx,8
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,130h
		dec	dl
		jnz	loc_b_0F2D		; Jump if not zero
		pop	ds
		retn
sub_b_0F18	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0F3C	proc	near
		mov	ax,0A000h
		mov	es,ax
		mov	di,word ptr ds:[38Fh]
		mov	si,395h
		cld				; Clear direction
		mov	dl,0Eh
loc_b_0F4B:
		mov	cx,8
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,130h
		dec	dl
		jnz	loc_b_0F4B		; Jump if not zero
		call	sub_b_0DDA
		retn
sub_b_0F3C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0F5C	proc	near
		call	sub_b_16EA		; Clear screen
		mov	ax,seg_c
		mov	es,ax
		mov	dx,20Eh
		mov	cx,0Bh
		mov	bp,offset data_c_031C+6	; ('H')
		mov	bl,4Eh			; 'N'
		call	sub_b_0B19		; Write BIOS text BP
		mov	dh,4
		mov	di,offset data_c_0BDC	; ('                    0000')
		mov	bl,4Dh			; 'M'
		mov	cx,0Ah

locloop_b_0F7C:
		push	cx
		push	di
		mov	cx,0Ch
		sub	di,cx
		mov	al,30h			; '0'
		cld				; Clear direction
		repe	scasb			; Rep zf=1+cx >0 Scan es:[di] for al
		mov	bp,di
		pop	di
		jz	loc_b_0FB5		; Jump if zero
		inc	cx
		dec	bp
		push	di
		push	bx
		push	dx
		mov	dl,26h			; '&'
		sub	dl,cl
		call	sub_b_0B19		; Write BIOS text BP
		pop	dx
		pop	bx
		pop	bp
		push	bp
		push	bx
		push	dx
		mov	cx,14h
		mov	dl,2
		call	sub_b_0B19		; Write BIOS text BP
		pop	dx
		pop	bx
		pop	di
		add	di,20h
		inc	dh
		dec	bl
		pop	cx
		loop	locloop_b_0F7C		; Loop if cx > 0

		push	cx
loc_b_0FB5:
		pop	cx
		mov	bl,4Eh			; 'N'
		mov	dh,18h
		call	sub_b_0A4F		; Write BIOS text 'Press any key.' and wait for a key
		call	sub_b_16EA		; Clear screen
		retn
sub_b_0F5C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0FC1	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	byte ptr data_c_037F,0
loc_b_0FCB:
		cmp	byte ptr data_c_04B7,0
		je	loc_b_0FDC		; Jump if equal
		test	byte ptr data_c_037F,0Fh
		jnz	loc_b_0FDC		; Jump if not zero
		call	sub_b_1793
loc_b_0FDC:
		; check key
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_b_0FFA		; Jump if zero

		; wait key
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		mov	al,ah
		mov	di,offset data_c_0490
		mov	cx,7
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_b_0FFA		; Jump if not zero
		mov	al,[di+6]
		or	data_c_037F,al
loc_b_0FFA:
		cmp	byte ptr data_c_04B1,0
		je	loc_b_100B		; Jump if equal
		cmp	byte ptr data_c_049E,0
		jne	loc_b_100B		; Jump if not equal
		call	sub_b_1818
loc_b_100B:
		cmp	byte ptr data_c_04AC,0
		jne	loc_b_0FCB		; Jump if not equal
		retn
sub_b_0FC1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Flush keyboard

sub_b_1013	proc	near
loc_b_1013:
		; check key
		mov	ah,1
		int	16h			; Keyboard i/o  ah=function 01h
						;  get status, if zf=0  al=char
		jz	loc_b_101F		; Jump if zero

		; get key
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		jmp	short loc_b_1013
loc_b_101F:
		mov	byte ptr data_c_037F,0
		retn
sub_b_1013	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read high score file

sub_b_1025	proc	near

		; open score file
		mov	dx,offset data_c_047C	; ('LEAPER.SCO')
		mov	ax,3D00h
		int	21h			; DOS Services  ah=function 3Dh
						;  open file, al=mode,name@ds:dx
		jc	loc_b_1052		; Jump if carry Set

		mov	data_c_047A,ax

		; read file
		mov	bx,ax
		mov	cx,140h
		mov	dx,offset data_c_0BC4+0Ch	; ('000000000000') ; high score file
		mov	ah,3Fh
		int	21h			; DOS Services  ah=function 3Fh
						;  read file, bx=file handle
						;   cx=bytes to ds:dx buffer
		pushf				; Push flags
		push	ax

		; close file
		mov	bx,data_c_047A
		mov	ah,3Eh
		int	21h			; DOS Services  ah=function 3Eh
						;  close file, bx=file handle
		pop	ax
		popf				; Pop flags
		jc	loc_b_1052		; Jump if carry Set
		cmp	ax,140h
		jne	loc_b_1052		; Jump if not equal
		retn

		; default high score
loc_b_1052:
		mov	ax,seg_c
		mov	es,ax
		mov	di,offset data_c_0BC4+0Ch	; ('000000000000') ; high score file
		cld				; Clear direction
		mov	dl,0Ah
loc_b_105D:
		mov	ax,3030h
		mov	cx,6
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,2020h
		mov	cx,0Ah
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		dec	dl
		jnz	loc_b_105D		; Jump if not zero
		retn
sub_b_1025	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Write score file

sub_b_1072	proc	near

		call	sub_b_10EE		; Restore INT 08h

		; set cursor
		mov	dx,0E00h
		mov	bx,0FFh
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx

		; create file
		mov	ah,3Ch			; '<'
		mov	dx,47Ch
		xor	cx,cx			; Zero register
		int	21h			; DOS Services  ah=function 3Ch
						;  create/truncate file @ ds:dx
		jc	loc_b_10A8		; Jump if carry Set

		; write file
		mov	word ptr ds:[47Ah],ax
		mov	bx,ax
		mov	ah,40h			; '@'
		mov	cx,140h
		mov	dx,0BD0h
		int	21h			; DOS Services  ah=function 40h
						;  write file  bx=file handle
						;   cx=bytes from ds:dx buffer
		pushf				; Push flags
		push	ax

		; close file
		mov	ah,3Eh
		int	21h			; DOS Services  ah=function 3Eh
						;  close file, bx=file handle
		pop	ax
		popf				; Pop flags
		jc	loc_b_10A8		; Jump if carry Set
		cmp	ax,140h
		je	loc_b_10D0		; Jump if equal
loc_b_10A8:
		; set cursor
		mov	ah,3
		int	10h			; Video display   ah=functn 03h
						;  get cursor loc in dx, mode cx
		cmp	dh,18h
		jae	loc_b_10B3		; Jump if above or =
		inc	dh
loc_b_10B3:
		mov	dl,8
		mov	bp,335h
		mov	bl,0FDh
		mov	cx,13h
		push	dx
		call	sub_b_0B19		; Write BIOS text BP
		pop	dx
		cmp	dh,18h
		jae	loc_b_10C9		; Jump if above or =
		inc	dh
loc_b_10C9:
		mov	bl,0FDh
		mov	dl,4
		call	sub_b_0A4F		; Write BIOS text 'Press any key.' and wait for a key
loc_b_10D0:
		call	sub_b_10D4		; Install INT 08h
		retn
sub_b_1072	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 08h

sub_b_10D4	proc	near

		cli				; Disable interrupts
		xor	al,al			; Zero register
		out	40h,al			; port 40h, 8253 timer 0 clock
		nop
		mov	al,8
		out	40h,al			; port 40h, 8253 timer 0 clock
		nop
		mov	byte ptr data_c_04B6,20h	; ' '
		mov	dx,offset loc_b_1859	; INT 08h service
		mov	ax,seg_b
		mov	ds,ax
		jmp	short loc_b_1101

;==== External Entry into Subroutine ======================================

; Restore INT 08h

sub_b_10EE:
		cli				; Disable interrupts
		xor	al,al			; Zero register
		out	40h,al			; port 40h, 8253 timer 0 clock
		nop
		out	40h,al			; port 40h, 8253 timer 0 clock

		nop
		mov	dx,cs:data_b_18A7	; old INT 08h
		mov	ds,word ptr cs:data_b_18A7+2
loc_b_1101:
		mov	ax,2508h
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx
		mov	ax,seg_c
		mov	ds,ax
		sti				; Enable interrupts
		retn
sub_b_10D4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_110D	proc	near
		mov	byte ptr ds:[4ACh],32h	; '2'
		call	sub_b_11D6
		call	sub_b_0327
		call	sub_b_0492
		call	sub_b_0625
		call	sub_b_067B
		call	sub_b_1158
		call	sub_b_0FC1
		retn
sub_b_110D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1128	proc	near
		push	bx
		push	cx
		push	dx
		mov	cx,8
		mov	bx,data_c_0D10
		mov	dx,data_c_0D12

locloop_b_1136:
		mov	al,dh
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		xor	al,dh
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		rcl	bx,1			; Rotate thru carry
		rcl	dx,1			; Rotate thru carry
		loop	locloop_b_1136		; Loop if cx > 0

		mov	data_c_0D10,bx
		mov	data_c_0D12,dx
		mov	al,dl
		pop	dx
		pop	cx
		pop	bx
		retn
sub_b_1128	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1158	proc	near
		mov	ax,0A000h
		mov	es,ax
		mov	si,offset data_c_05A6
		mov	di,d_A000_0C80_e
		mov	dx,0Ch
		xor	bx,bx			; Zero register
		cld				; Clear direction
loc_b_1169:
		cmp	byte ptr [si],0
		je	loc_b_11CA		; Jump if equal
		push	si
		push	di
		push	dx
		push	ds
		mov	dx,0Eh
		mov	si,data_c_05FC[bx]
		add	si,data_c_0614[bx]
		cmp	data_c_0614[bx],40h
		jae	loc_b_1195		; Jump if above or =
		mov	ds,data_c_04A6
loc_b_1188:
		mov	cx,0A0h
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,40h
		dec	dx
		jnz	loc_b_1188		; Jump if not zero
		jmp	short loc_b_11C6
loc_b_1195:
		mov	ax,180h
		mov	bp,ds:d_0000_0614_e[bx]
		sub	ax,bp
		mov	bp,ds:d_0000_05FC_e[bx]
		mov	ds,ds:d_0000_04A6_e
loc_b_11A6:
		push	si
		mov	cx,ax
		shr	cx,1			; Shift w/zeros fill
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,140h
		sub	cx,ax
		jbe	loc_b_11BA		; Jump if below or =
		shr	cx,1			; Shift w/zeros fill
		mov	si,bp
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
loc_b_11BA:
		pop	si
		add	si,180h
		add	bp,180h
		dec	dx
		jnz	loc_b_11A6		; Jump if not zero
loc_b_11C6:
		pop	ds
		pop	dx
		pop	di
		pop	si
loc_b_11CA:
		add	bx,2
		add	di,1180h
		inc	si
		dec	dx
		jnz	loc_b_1169		; Jump if not zero
		retn
sub_b_1158	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_11D6	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	di,offset data_c_05A6
		mov	cx,6
		xor	ax,ax			; Zero register
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xor	bx,bx			; Zero register
		mov	si,bx
		mov	cx,0Ch

locloop_b_11ED:
		cmp	byte ptr data_c_05BE[bx],0
		je	loc_b_122F		; Jump if equal
		dec	data_c_05BE[bx]
		jnz	loc_b_122F		; Jump if not zero
		mov	al,data_c_05B2[bx]
		mov	data_c_05BE[bx],al
		mov	data_c_05A6[bx],al
		mov	dx,data_c_05E4[si]
		mov	ax,data_c_0614[si]
		add	ax,dx
		cmp	dx,4
		jne	loc_b_121E		; Jump if not equal
		cmp	ax,180h
		jb	loc_b_122B		; Jump if below
		xor	ax,ax			; Zero register
		jmp	short loc_b_122B
loc_b_121E:
;*		cmp	dx,0FFFCh
		db	 83h,0FAh,0FCh		;  Fixup - byte match
		jnz	loc_b_122B		; Jump if not zero
		cmp	ax,180h
		jb	loc_b_122B		; Jump if below
		mov	ax,17Ch
loc_b_122B:
		mov	data_c_0614[si],ax
loc_b_122F:
		inc	bx
		inc	di
		add	si,2
		loop	locloop_b_11ED		; Loop if cx > 0

		xor	bh,bh			; Zero register
		mov	bl,data_c_04C1
		cmp	byte ptr data_c_05A6[bx],0
		je	loc_ret_b_126D		; Jump if equal
		cmp	bl,6
		jb	loc_ret_b_126D		; Jump if below
		push	bx
		call	sub_b_133F
		pop	bx
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_c_04C2
		add	ax,data_c_05E4[bx]
		cmp	ax,180h
		jb	loc_b_1267		; Jump if below
		xor	ax,ax			; Zero register
		cmp	data_c_05E4[bx],4
		je	loc_b_1267		; Jump if equal
		mov	ax,17Ch
loc_b_1267:
		mov	data_c_04C2,ax
		call	sub_b_126E

loc_ret_b_126D:
		retn
sub_b_11D6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_126E	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	bl,data_c_04C1
		xor	bh,bh			; Zero register
		mov	byte ptr data_c_05A6[bx],1
		shl	bx,1			; Shift w/zeros fill
		mov	si,data_c_05FC[bx]
		add	si,data_c_04C2
		mov	di,offset data_c_04C6
		mov	dl,0Eh
		push	bx
		push	si
		push	ds
		cld				; Clear direction
		cmp	data_c_04C2,170h
		jae	loc_b_12AC		; Jump if above or =
		mov	ds,data_c_04A6
loc_b_129D:
		mov	cx,8
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	si,d_0000_0170_e
		dec	dl
		jnz	loc_b_129D		; Jump if not zero
		jmp	short loc_b_12D8
loc_b_12AC:
		mov	ax,180h
		sub	ax,ds:d_0000_04C2_e
		mov	bx,ds:d_0000_05FC_e[bx]
		mov	ds,ds:d_0000_04A6_e
loc_b_12BB:
		push	si
		mov	cx,ax
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,10h
		sub	cx,ax
		jbe	loc_b_12CB		; Jump if below or =
		mov	si,bx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
loc_b_12CB:
		add	bx,offset data_c_0180
		pop	si
		add	si,offset data_c_0180
		dec	dl
		jnz	loc_b_12BB		; Jump if not zero
loc_b_12D8:
		pop	ds
		pop	di
		pop	bx
		mov	es,data_c_04A6
		mov	si,data_c_04C4
		mov	dl,0Eh
		cmp	data_c_04C2,170h
		jae	loc_b_1304		; Jump if above or =
loc_b_12ED:
		mov	cx,10h

locloop_b_12F0:
		lodsb				; String [si] to al
		and	al,es:[di]
		or	al,byte ptr data_c_00D4+0Bh[si]	; ('aps at the top of the sc')
		stosb				; Store al to es:[di]
		loop	locloop_b_12F0		; Loop if cx > 0

		add	di,d_0000_0170_e
		dec	dl
		jnz	loc_b_12ED		; Jump if not zero
		retn
loc_b_1304:
		mov	bp,180h
		sub	bp,data_c_04C2
		mov	bx,data_c_05FC[bx]
loc_b_130F:
		push	di
		mov	cx,bp

locloop_b_1312:
		lodsb				; String [si] to al
		and	al,es:[di]
		or	al,byte ptr data_c_00D4+0Bh[si]	; ('aps at the top of the sc')
		stosb				; Store al to es:[di]
		loop	locloop_b_1312		; Loop if cx > 0

		mov	cx,10h
		sub	cx,bp
		jbe	loc_b_1331		; Jump if below or =
		mov	di,bx

locloop_b_1326:
		lodsb				; String [si] to al
		and	al,es:[di]
		or	al,byte ptr data_c_00D4+0Bh[si]	; ('aps at the top of the sc')
		stosb				; Store al to es:[di]
		loop	locloop_b_1326		; Loop if cx > 0

loc_b_1331:
		add	bx,180h
		pop	di
		add	di,180h
		dec	dl
		jnz	loc_b_130F		; Jump if not zero
		retn
sub_b_126E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_133F	proc	near
		mov	es,data_c_04A6
		mov	bl,data_c_04C1
		xor	bh,bh			; Zero register
		mov	byte ptr data_c_05A6[bx],1
		shl	bx,1			; Shift w/zeros fill
		mov	di,data_c_05FC[bx]
		add	di,data_c_04C2
		mov	si,offset data_c_04C6
		mov	dl,0Eh
		cld				; Clear direction
		cmp	data_c_04C2,170h
		jae	loc_b_1374		; Jump if above or =
loc_b_1366:
		mov	cx,8
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		add	di,d_0000_0170_e
		dec	dl
		jnz	loc_b_1366		; Jump if not zero
		retn
loc_b_1374:
		mov	ax,180h
		sub	ax,data_c_04C2
		mov	bx,data_c_05FC[bx]
loc_b_137F:
		push	di
		mov	cx,ax
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,10h
		sub	cx,ax
		jz	loc_b_138F		; Jump if zero
		mov	di,bx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
loc_b_138F:
		add	bx,180h
		pop	di
		add	di,180h
		dec	dl
		jnz	loc_b_137F		; Jump if not zero
		retn
sub_b_133F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_139D	proc	near
		mov	ax,seg_c
		mov	es,ax
		mov	data_c_04C2,98h
		mov	byte ptr data_c_04C1,0Bh
		mov	data_c_04C4,4308h
		mov	di,offset data_c_062C
		xor	ax,ax			; Zero register
		mov	cx,6
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn
sub_b_139D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_13BF	proc	near
		call	sub_b_16EA		; Clear screen
		mov	ax,seg_c
		mov	es,ax
		mov	dx,1Ch
		mov	cx,8
		mov	bp,offset data_c_0326+7	; ('Leapers:Error writing fi')
		mov	bl,0DDh
		call	sub_b_0B19		; Write BIOS text BP
		mov	dx,1823h
		mov	cx,4
		mov	bp,offset data_c_0318
		mov	bl,0FDh
		call	sub_b_0B19		; Write BIOS text BP
		mov	dx,1
		mov	cx,6
		mov	bp,offset data_c_031C	; ('Score:HIGH')
		mov	bl,0Ah
		call	sub_b_0B19		; Write BIOS text BP
		xor	al,al			; Zero register
		call	sub_b_0A9C
		call	sub_b_0B26
		call	sub_b_1716
		mov	ax,0A000h
		mov	es,ax
		mov	ax,1CE4h
		mov	cx,0A0h
		mov	di,d_A000_0A00_e
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xchg	al,ah
		mov	cx,0A0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,seg_c
		mov	es,ax
		xor	ax,ax			; Zero register
		mov	di,offset data_c_0614
		mov	cx,2D8h
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,offset data_c_05A6
		mov	cx,6
		dec	ax
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,offset data_c_04C6
		mov	cx,8
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0EDEDh
		mov	cx,60h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0FFFFh
		mov	cx,8
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,offset data_c_0744
		mov	ax,101h
		stosb				; Store al to es:[di]
		mov	cx,6

locloop_b_144F:
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	ax,0FFFFh
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	ax,101h
		loop	locloop_b_144F		; Loop if cx > 0

		mov	cx,7
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	ax,0FFFFh
		mov	di,offset data_c_0984
		mov	cx,120h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	es,word ptr ds:[4A6h]
		xor	di,di			; Zero register
		mov	ax,1CE4h
		mov	bp,0Eh
loc_b_1479:
		call	sub_b_168C
		dec	bp
		jnz	loc_b_1479		; Jump if not zero
		mov	bp,168h
		mov	di,4
		mov	cx,6

locloop_b_1488:
		push	cx
		mov	si,data_b_3736_e
		call	sub_b_16F7
		add	di,18h
		pop	cx
		loop	locloop_b_1488		; Loop if cx > 0

		mov	si,data_b_3736_e
		call	sub_b_16F7
		mov	di,d_05AC_1500_e
		mov	ax,5F5Fh
		mov	cx,3480h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0FFFFh
		mov	cx,0C0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	dx,0Ch
		mov	ax,3030h
loc_b_14B4:
		mov	cx,0C0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xchg	al,ah
		dec	dx
		jnz	loc_b_14B4		; Jump if not zero
		mov	ax,0FFFFh
		mov	cx,0C0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0C3C3h
		mov	cx,2A00h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0FFFFh
		mov	cx,0C0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0EDEDh
		mov	cx,900h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0FFFFh
		mov	cx,0C0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,7A4h
		mov	word ptr ds:[4A8h],ax
		mov	word ptr ds:[4AAh],ax
		mov	di,1500h
		mov	bx,di
		mov	si,word ptr ds:[48Eh]
loc_b_14F8:
		lodsb				; String [si] to al
		mov	ah,al
		and	ah,0Fh
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		or	ah,ah			; Zero ?
		jnz	loc_b_152E		; Jump if not zero
		or	al,al			; Zero ?
		jz	loc_b_151A		; Jump if zero
		add	word ptr ds:[4A8h],ax
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		add	di,ax
		jmp	short loc_b_14F8
loc_b_151A:
		add	bx,1500h
		mov	di,bx
		mov	ax,word ptr ds:[4AAh]
		add	ax,60h
		mov	word ptr ds:[4A8h],ax
		mov	word ptr ds:[4AAh],ax
		jmp	short loc_b_14F8
loc_b_152E:
		push	si
		mov	dx,101h
		mov	si,276Fh
		cmp	ah,1
		je	loc_b_158C		; Jump if equal
		mov	si,2930h
		cmp	ah,2
		je	loc_b_158C		; Jump if equal
		mov	si,2AF1h
		cmp	ah,3
		je	loc_b_158C		; Jump if equal
		mov	si,2C42h
		cmp	ah,4
		je	loc_b_158C		; Jump if equal
		mov	dx,0FFFFh
		mov	si,1A4Ch
		cmp	ah,6
		je	loc_b_158C		; Jump if equal
		mov	si,1CEDh
		cmp	ah,7
		je	loc_b_158C		; Jump if equal
		mov	si,206Eh
		cmp	ah,8
		je	loc_b_158C		; Jump if equal
		cmp	ah,9
		jne	loc_b_15B2		; Jump if not equal
		mov	word ptr ds:[72Eh],di
		mov	ax,word ptr ds:[4A8h]
		add	ax,0Eh
		mov	word ptr ds:[732h],ax
		call	sub_b_1128
		and	al,7Fh
		add	al,20h			; ' '
		mov	byte ptr ds:[730h],al
		mov	si,data_b_2EE3_e
loc_b_158C:
		push	si
		push	di
		mov	cl,[si]
		xor	ch,ch			; Zero register
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		mov	di,word ptr ds:[4A8h]
		mov	ax,seg_c
		mov	es,ax
		mov	ax,dx
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	word ptr ds:[4A8h],di
		pop	di
		pop	si
		call	sub_b_16F7
		pop	si
		jmp	loc_b_14F8
loc_b_15B2:
		cmp	ah,5
		jne	loc_b_162A		; Jump if not equal
		test	al,8
		jz	loc_b_15E8		; Jump if zero
		push	ax
		call	sub_b_1128
		and	al,0Fh
		inc	al
		mov	dl,al
		pop	ax
		mov	cx,word ptr ds:[4A8h]
		cmp	al,0Ah
		jne	loc_b_15DC		; Jump if not equal
		mov	word ptr ds:[71Eh],di
		mov	byte ptr ds:[722h],dl
		mov	word ptr ds:[724h],cx
		jmp	short loc_b_15E8
loc_b_15DC:
		mov	word ptr ds:[726h],di
		mov	byte ptr ds:[72Ah],dl
		mov	word ptr ds:[72Ch],cx
loc_b_15E8:
		and	al,3
		push	ax
		push	di
		mov	di,cx
		mov	cx,8
		cmp	al,2
		je	loc_b_15F8		; Jump if equal
		mov	cx,0Ch
loc_b_15F8:
		mov	di,word ptr ds:[4A8h]
		add	word ptr ds:[4A8h],cx
		mov	ax,seg_c
		mov	es,ax
		mov	ax,0FFFFh
		shr	cx,1			; Shift w/zeros fill
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		pop	di
		mov	si,16C8h
		call	sub_b_16F7
		mov	si,16C8h
		call	sub_b_16F7
		pop	ax
		and	al,3
		cmp	al,3
		jne	loc_b_1626		; Jump if not equal
		mov	si,16C8h
		call	sub_b_16F7
loc_b_1626:
		pop	si
		jmp	loc_b_14F8
loc_b_162A:
		pop	si
		cmp	ah,0Fh
		jne	loc_b_1689		; Jump if not equal
		or	al,al			; Zero ?
		jz	loc_b_1676		; Jump if zero
		mov	ax,seg_c
		mov	es,ax
		mov	di,offset data_c_05B3
		mov	cx,5
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	word ptr ds:[48Eh],si
		mov	si,5B3h
		mov	di,offset data_c_05BF
		mov	cx,5
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	dx,4
		call	sub_b_1128
		cmp	al,80h
		jb	loc_b_165D		; Jump if below
		mov	dx,0FFFCh
loc_b_165D:
		mov	word ptr ds:[738h],dx
		call	sub_b_1128
		and	al,7Fh
		add	al,14h
		mov	al,2
		mov	byte ptr ds:[73Eh],al
		mov	byte ptr ds:[743h],0
		call	sub_b_0759
		retn
loc_b_1676:
		mov	si,0EE0h
		mov	word ptr ds:[48Eh],si
		mov	al,byte ptr ds:[4B0h]
		cmp	al,64h			; 'd'
		je	loc_b_1689		; Jump if equal
		sub	al,14h
		mov	byte ptr ds:[4B0h],al
loc_b_1689:
		jmp	loc_b_14F8
sub_b_13BF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_168C	proc	near
		stosw				; Store ax to es:[di]
		stosw				; Store ax to es:[di]
		mov	dl,6
loc_b_1690:
		mov	cx,0Ch
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		push	ax
		mov	ax,5F5Fh
		mov	cx,0Ch
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		pop	ax
		dec	dl
		jnz	loc_b_1690		; Jump if not zero
		mov	cx,0Eh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		xchg	al,ah
		add	di,40h
		retn
sub_b_168C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_16AE	proc	near
		mov	di,d_A000_F388_e
		mov	ah,data_c_04B0
		mov	cl,ah
		xor	ch,ch			; Zero register
		sub	di,cx
		mov	al,2
		mov	data_c_04AE,ax
		mov	data_c_04B2,di
		mov	ax,0A000h
		mov	es,ax
		shr	cx,1			; Shift w/zeros fill
		mov	dx,cx
		mov	al,9
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	cx,dx
		shr	cx,1			; Shift w/zeros fill
		add	dx,cx
		mov	al,0FDh
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	data_c_04B4,di
		mov	al,8
		mov	cl,data_c_04B0
		sub	cl,dl
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		retn
sub_b_16AE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear screen

sub_b_16EA	proc	near
		mov	ax,600h
		xor	cx,cx			; Zero register
		mov	dx,184Fh
		mov	bh,ch
		int	10h			; Video display   ah=functn 06h
						;  scroll up, al=lines
						;   bh=attrib, cx+dx=window size
		retn
sub_b_16EA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_16F7	proc	near
		mov	es,data_c_04A6
		push	di
		mov	cl,[si]
		xor	ch,ch			; Zero register
		mov	bp,180h
		sub	bp,cx
		inc	si
		mov	dl,0Eh
loc_b_1708:
		push	cx
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	cx
		add	di,bp
		dec	dl
		jnz	loc_b_1708		; Jump if not zero
		pop	di
		add	di,cx
		retn
sub_b_16F7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1716	proc	near
		xor	dx,dx			; Zero register
		mov	bh,dh
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	al,0Eh
		cmp	byte ptr data_c_0380,0
		je	loc_b_1729		; Jump if equal
		mov	al,20h			; ' '
loc_b_1729:
		mov	ah,9
		mov	bx,0F9h
		mov	cx,1
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		retn
sub_b_1716	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1734	proc	near
		cli				; Disable interrupts
		mov	cx,200h
		xor	si,si			; Zero register
		mov	di,si
		mov	dx,201h
		out	dx,al			; port 201h, start game 1-shots
		nop

locloop_b_1741:
		in	al,dx			; port 201h, start game 1-shots
		shr	al,1			; Shift w/zeros fill
		adc	si,0
		shr	al,1			; Shift w/zeros fill
		adc	di,0
		loop	locloop_b_1741		; Loop if cx > 0

		sti				; Enable interrupts
		retn
sub_b_1734	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1750	proc	near
		call	sub_b_1734
		cmp	si,200h
		je	loc_b_175F		; Jump if equal
		cmp	di,200h
		jne	loc_b_1765		; Jump if not equal
loc_b_175F:
		mov	byte ptr data_c_04B7,0
		retn
loc_b_1765:
		mov	ax,si
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	si,ax
		mov	data_c_04BA,si
		sub	si,ax
		sub	si,ax
		mov	data_c_04B8,si
		mov	ax,di
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	di,ax
		mov	data_c_04BE,di
		sub	di,ax
		sub	di,ax
		mov	data_c_04BC,di
		mov	byte ptr data_c_04B7,0FFh
		retn
sub_b_1750	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1793	proc	near
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		push	ax
		call	sub_b_1734
		pop	dx
		xor	al,al			; Zero register
		cmp	si,data_c_04B8
		jae	loc_b_17A6		; Jump if above or =
		or	al,1
loc_b_17A6:
		cmp	si,data_c_04BA
		jb	loc_b_17AE		; Jump if below
		or	al,2
loc_b_17AE:
		cmp	di,data_c_04BC
		jae	loc_b_17B6		; Jump if above or =
		or	al,4
loc_b_17B6:
		cmp	di,data_c_04BE
		jb	loc_b_17BE		; Jump if below
		or	al,8
loc_b_17BE:
		mov	bl,data_c_037F
		and	bl,0F0h
		or	al,bl
		mov	data_c_037F,al
		retn
sub_b_1793	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_17CB	proc	near
		cmp	byte ptr data_c_0380,0
		jne	loc_b_1805		; Jump if not equal
		cli				; Disable interrupts
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	dx,12h
		mov	ax,34DCh
		or	cx,cx			; Zero ?
		jz	loc_b_17F6		; Jump if zero
		cmp	dx,cx
		jae	loc_b_1805		; Jump if above or =
		div	cx			; ax,dx rem=dx:ax/reg
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		mov	byte ptr data_c_049E+1,al
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_b_17F6:
		mov	data_c_04A0,bx
		mov	data_c_04A2,1
		mov	byte ptr data_c_049E,0FFh
loc_b_1805:
		sti				; Enable interrupts
		retn
sub_b_17CB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1807	proc	near
		cmp	byte ptr data_c_0380,0
		jne	loc_ret_b_1844		; Jump if not equal
		cmp	byte ptr data_c_049E,0
		je	loc_b_1818		; Jump if equal
		call	sub_b_1845

;==== External Entry into Subroutine ======================================

sub_b_1818:
loc_b_1818:
		push	bx
		push	cx
		push	dx
		push	si
		mov	byte ptr data_c_04B1,0FFh
		mov	si,data_c_04A4
;*		cmp	word ptr [si],0FFFFh
		db	 83h, 3Ch,0FFh		;  Fixup - byte match
		jnz	loc_b_1831		; Jump if not zero
		mov	byte ptr data_c_04B1,0
		jmp	short loc_b_1840
loc_b_1831:
		mov	cx,[si]
		mov	bx,[si+2]
		add	si,4
		mov	data_c_04A4,si
		call	sub_b_17CB
loc_b_1840:
		pop	si
		pop	dx
		pop	cx
		pop	bx

loc_ret_b_1844:
		retn
sub_b_1807	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1845	proc	near
		cli				; Disable interrupts
		cmp	byte ptr data_c_049E,0
		je	loc_b_1857		; Jump if equal
		mov	al,byte ptr data_c_049E+1
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		mov	byte ptr data_c_049E,0
loc_b_1857:
		sti				; Enable interrupts
		retn
sub_b_1845	endp

; INT 08h service

loc_b_1859:
		push	ds
		push	ax
		mov	ax,seg_c
		mov	ds,ax
		cmp	byte ptr data_c_049E,0
		je	loc_b_1883		; Jump if equal
		dec	data_c_04A0
		jnz	loc_b_1883		; Jump if not zero
		mov	data_c_04A0,0FFFFh
		dec	data_c_04A2
		jnz	loc_b_1883		; Jump if not zero
		mov	al,byte ptr data_c_049E+1
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		mov	byte ptr data_c_049E,0
loc_b_1883:
		cmp	byte ptr data_c_04AC,0
		je	loc_b_188E		; Jump if equal
		dec	data_c_04AC
loc_b_188E:
		dec	data_c_04AD
		jz	loc_b_189B		; Jump if zero
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	ax
		pop	ds
		iret				; Interrupt return
loc_b_189B:
		mov	byte ptr ds:[4ADh],20h	; ' '
		pop	ax
		pop	ds
		jmp	dword ptr cs:data_b_18A7 ; old INT 08h

data_b_18A7	dw	0, 0		; old INT 08h

;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

int_24h_entry	proc	far
		push	ds
		push	ax
		mov	ax,seg_c
		mov	ds,ax
		pop	ax
		test	ah,80h
		jnz	loc_b_18D7		; Jump if not zero
		mov	dx,offset data_c_0048	; ('Disk error. (R)etry or (')
		mov	ah,9
		int	21h			; DOS Services  ah=function 09h
						;  display char string at ds:dx
loc_b_18BF:
		xor	ah,ah			; Zero register
		int	16h			; Keyboard i/o  ah=function 00h
						;  get keybd char in al, ah=scan
		cmp	al,51h			; 'Q'
		je	loc_b_18D7		; Jump if equal
		cmp	al,71h			; 'q'
		je	loc_b_18D7		; Jump if equal
		cmp	al,52h			; 'R'
		je	loc_b_18D3		; Jump if equal
		cmp	al,72h			; 'r'
		jne	loc_b_18BF		; Jump if not equal
loc_b_18D3:
		mov	al,1
		jmp	short loc_b_18D9
loc_b_18D7:
		xor	al,al			; Zero register
loc_b_18D9:
		pop	ds
		iret				; Interrupt return
int_24h_entry	endp

		db	0, 0, 0, 0, 0

seg_b		ends



;------------------------------------------------------------  seg_c   ----

seg_c		segment	byte public
		assume cs:seg_c  , ds:seg_c , ss:stack_seg_a

data_c_0000	db	'DOS 2.0 or higher required.', 0Dh	; Data table (indexed access)
		db	0Ah, '$'
		db	'Not enough memory.', 0Dh, 0Ah, '$'
data_c_0033	db	'VGA card required.', 0Dh, 0Ah, '$'
data_c_0048	db	'Disk error. (R)etry or (Q)uit?', 0Dh
		db	0Ah, '$'
data_c_0069	db	0Ah, 0
		db	13h
		db	'LEAPER INSTRUCTIONS'
		db	0, 2
		db	'%Move Leaper using the arrow key'
		db	's or a', 0
		db	 03h, 27h
		db	'joystick. You must move him into'
		db	' one of', 0
		db	 04h, 27h
data_c_00D4	db	'the empty gaps at the top of the'
		db	' screen', 0
		db	 05h, 26h, 77h
		db	'ithout getting him run over or h'
		db	'aving', 0
		db	 06h, 1Fh
data_c_0127	db	'him fall off a log or a turtle.', 0
		db	8, '&Pressing Q turns the sound o'
		db	'n and off,', 0
data_c_0170	db	9, '&P pauses the g'
data_c_0180	db	'ame & any key '
		db	'continues,', 0
		db	 0Ah, 17h
		db	'and ESC halts the game.'
		db	0FFh,0FFh
data_c_01B4	db	0
		db	 0Ch, 14h
		db	'At the title screen:'
		db	 02h, 0Dh, 17h
		db	'Enter - starts the game'
		db	 02h, 0Eh, 17h
		db	'H - display this screen'
		db	 02h, 0Fh, 19h
		db	'C - change Leaper', 27h, 's colo'
		db	'r'
		db	 02h, 10h, 1Eh
		db	'J - switch to joystick control'
		db	 06h, 11h
		db	' (Make sure joystick is centered'
		db	')'
		db	 02h, 12h, 1Eh
		db	'K - switch to keyboard control'
		db	 02h, 13h, 17h
		db	'S - display high scores'
		db	 02h, 14h, 14h
		db	'ESC - return to DOS.'
		db	0FFh,0FFh
data_c_02B3	db	0Ah
		db	 00h, 13h
		db	'CHANGE LEAPER COLOR'
		db	 00h, 16h, 25h, 50h
		db	'r'
		db	'ess '
		db	'letter of frog you wish to use.'
		db	 00h, 17h
		db	'"Press'
		db	' Esc to keep frog same color.'
		db	0FFh,0FFh
data_c_0318	db	54h
		db	69h
		db	'me'
data_c_031C	db	'Score:HIGH'
data_c_0326	db	' SCORESLeapers:Error writing f'
		db	 69h, 6Ch, 65h, 2Eh
data_c_0348	db	0Ch
		db	 0Ah, 0Fh
		db	'NEW HIGH SCORE!'
		db	 02h, 0Ch, 12h
		db	'Enter your name: _'
		db	0FFh,0FFh
		db	'Press any key.'
data_c_037F	db	0
data_c_0380	db	0
data_c_0381	db	0		; old videomode
data_c_0382	db	3
data_c_0383	db	32h
data_c_0384	db	1
data_c_0385	db	30h
		db	 30h, 33h, 20h
data_c_0389	db	0
data_c_038A	db	0
data_c_038B	dw	0
data_c_038D	db	1
data_c_038E	db	0
data_c_038F	dw	0
data_c_0391	dw	0
data_c_0393	dw	0
data_c_0395	dw	112 dup (0)
data_c_0475	db	0
data_c_0476	dw	0
data_c_0478	dw	12F0h
data_c_047A	dw	0
data_c_047C	db	'LEAPER.SCO', 0
		db	0
data_c_0488	dw	0			; old INT 24h
data_c_048A	dw	0			; old INT 24h
data_c_048C	dw	1608h
data_c_048E	dw	0EE0h
data_c_0490	db	4Bh
		db	 4Dh, 48h, 50h, 19h, 10h, 01h
		db	 01h, 02h, 04h, 08h, 20h, 40h
		db	 80h
data_c_049E	dw	0
data_c_04A0	dw	0
data_c_04A2	dw	0
data_c_04A4	dw	0
data_c_04A6	dw	0
		db	 44h, 07h, 44h, 07h
data_c_04AC	db	0
data_c_04AD	db	0
data_c_04AE	dw	0C802h
data_c_04B0	db	0C8h
data_c_04B1	db	0
data_c_04B2	dw	0F2C0h
data_c_04B4	dw	0
data_c_04B6	db	20h
data_c_04B7	db	0
data_c_04B8	dw	0
data_c_04BA	dw	0
data_c_04BC	dw	0
data_c_04BE	dw	0
		db	0
data_c_04C1	db	0Ah
data_c_04C2	dw	98h
data_c_04C4	dw	4308h
data_c_04C6	dw	8 dup (0FFFFh)
		db	192 dup (0EDh)
		db	16 dup (0FFh)
data_c_05A6	db	0			; Data table (indexed access)
data_c_05A7	db	0
		db	0, 0
data_c_05AA	db	0
data_c_05AB	db	0
data_c_05AC	db	0
		db	0, 0, 0, 0, 0
data_c_05B2	db	0			; Data table (indexed access)
data_c_05B3	db	0
		db	10 dup (0)
data_c_05BE	db	0			; Data table (indexed access)
data_c_05BF	db	0
		db	10 dup (0)
data_c_05CA	dw	744h			; Data table (indexed access)
data_c_05CC	dw	7A4h			; Data table (indexed access)
		db	 04h, 08h, 64h, 08h,0C4h, 08h
		db	 24h, 09h, 84h, 09h,0E4h, 09h
		db	 44h, 0Ah,0A4h, 0Ah, 04h, 0Bh
		db	 64h, 0Bh,0C4h, 0Bh
data_c_05E4	dw	0			; Data table (indexed access)
		db	0FCh,0FFh, 04h, 00h,0FCh,0FFh
		db	0FCh,0FFh, 04h, 00h, 00h, 00h
		db	 04h, 00h,0FCh,0FFh, 04h, 00h
		db	0FCh,0FFh, 00h, 00h
data_c_05FC	dw	0			; Data table (indexed access)
		db	 00h, 15h, 00h, 2Ah, 00h, 3Fh
		db	 00h, 54h, 00h, 69h, 00h, 7Eh
		db	 00h, 93h, 00h,0A8h, 00h,0BDh
		db	 00h,0D2h, 00h,0E7h
data_c_0614	dw	0			; Data table (indexed access)
		db	10 dup (0)
data_c_0620	dw	0
		db	10 dup (0)
data_c_062C	db	0			; Data table (indexed access)
		db	11 dup (0)
data_c_0638	dw	0
data_c_063A	dw	0
data_c_063C	dw	0
data_c_063E	db	0
		db	0
data_c_0640	db	0
		db	15 dup (0)
data_c_0650	db	0
		db	31 dup (0)
data_c_0670	db	0
		db	15 dup (0)
data_c_0680	db	0
		db	63 dup (0)
data_c_06C0	db	0
		db	47 dup (0)
data_c_06F0	db	0
		db	45 dup (0)
data_c_071E	db	0
		db	0
data_c_0720	db	0
data_c_0721	db	0
data_c_0722	db	0
		db	0, 0, 0
data_c_0726	db	0
		db	0
data_c_0728	db	0
data_c_0729	db	0
data_c_072A	db	0
		db	0, 0, 0
data_c_072E	dw	0
data_c_0730	db	0
data_c_0731	db	0
data_c_0732	dw	0
data_c_0734	dw	0
data_c_0736	dw	0
data_c_0738	dw	0
data_c_073A	dw	0
data_c_073C	dw	0
data_c_073E	db	0
data_c_073F	db	0
data_c_0740	db	0
data_c_0741	db	0
data_c_0742	db	0
data_c_0743	db	0
data_c_0744	db	0
		db	383 dup (0)
data_c_08C4	db	0
		db	191 dup (0)
data_c_0984	db	0
		db	62 dup (0)
data_c_09C3	db	0			; Data table (indexed access)
		db	512 dup (0)

data_c_0BC4	db	'000000000000000000000000'	; high score file
data_c_0BDC	db	'        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'            000000000000        '
		db	'           '
data_c_0D0F	db	' '
data_c_0D10	dw	0F6D3h
data_c_0D12	dw	0C9ADh
		db	 06h, 01h,0DEh, 00h, 00h, 00h
		db	 14h, 00h, 06h, 01h,0DEh, 00h
		db	 00h, 00h, 14h, 00h, 06h, 01h
		db	 96h, 00h, 26h, 01h, 48h, 00h
		db	 4Ah, 01h,0DEh, 00h, 00h, 00h
		db	 14h, 00h, 4Ah, 01h, 96h, 00h
		db	 26h, 01h, 48h, 00h, 4Ah, 01h
		db	 96h, 00h, 5Dh, 01h, 48h, 00h
		db	 88h, 01h,0C2h, 01h,0FFh,0FFh
		db	0FFh,0FFh, 4Ah, 01h, 2Ch, 01h
		db	 26h, 01h, 48h, 00h, 06h, 01h
		db	 48h, 00h, 4Ah, 01h, 48h, 00h
		db	 26h, 01h, 48h, 00h, 06h, 01h
		db	 96h, 00h, 0Ch, 02h, 96h, 00h
		db	0B8h, 01h, 48h, 00h, 0Ch, 02h
		db	0DEh, 00h, 88h, 01h, 2Ch, 01h
		db	 4Ah, 01h, 96h, 00h, 06h, 01h
		db	 96h, 00h, 26h, 01h, 2Ch, 01h
		db	0FFh,0FFh,0FFh,0FFh, 06h, 01h
		db	 96h, 00h, 00h, 00h, 14h, 00h
		db	 06h, 01h, 96h, 00h, 88h, 01h
		db	 96h, 00h, 00h, 00h, 14h, 00h
		db	 88h, 01h, 96h, 00h,0B8h, 01h
		db	 96h, 00h, 00h, 00h, 14h, 00h
		db	0B8h, 01h, 96h, 00h, 88h, 01h
		db	 2Ch, 01h, 5Dh, 01h, 96h, 00h
		db	 00h, 00h, 14h, 00h, 5Dh, 01h
		db	 96h, 00h, 4Ah, 01h, 96h, 00h
		db	 00h, 00h, 14h, 00h, 4Ah, 01h
		db	 96h, 00h, 00h, 00h, 14h, 00h
		db	 26h, 01h, 96h, 00h, 00h, 00h
		db	 14h, 00h, 26h, 01h, 96h, 00h
		db	 06h, 01h, 2Ch, 01h, 26h, 01h
		db	 1Eh, 00h, 4Ah, 01h, 1Eh, 00h
		db	 5Dh, 01h, 1Eh, 00h, 88h, 01h
		db	 1Eh, 00h,0B8h, 01h, 3Ch, 00h
		db	0FFh,0FFh,0FFh,0FFh, 26h, 01h
		db	 96h, 00h, 00h, 00h, 14h, 00h
		db	 26h, 01h, 96h, 00h,0F7h, 00h
		db	 96h, 00h, 26h, 01h, 96h, 00h
		db	 4Ah, 01h, 96h, 00h, 26h, 01h
		db	 96h, 00h,0F7h, 00h, 96h, 00h
		db	 00h, 00h, 32h, 00h,0F7h, 00h
		db	 96h, 00h,0DCh, 00h, 2Ch, 01h
		db	0F7h, 00h, 96h, 00h,0DCh, 00h
		db	 2Ch, 01h,0FFh,0FFh,0FFh,0FFh
		db	 88h, 01h, 48h, 00h, 00h, 00h
		db	 14h, 00h, 88h, 01h, 48h, 00h
		db	0B8h, 01h, 48h, 00h,0EEh, 01h
		db	 48h, 00h, 88h, 01h, 48h, 00h
		db	0EEh, 01h, 48h, 00h,0B8h, 01h
		db	 48h, 00h, 26h, 01h, 48h, 00h
		db	 88h, 01h, 48h, 00h, 00h, 00h
		db	 14h, 00h, 88h, 01h, 48h, 00h
		db	0B8h, 01h, 48h, 00h,0EEh, 01h
		db	 48h, 00h, 88h, 01h, 96h, 00h
		db	 72h, 01h, 48h, 00h,0FFh,0FFh
		db	0FFh,0FFh, 6Eh, 00h, 2Ch, 01h
		db	 00h, 00h, 1Eh, 00h, 6Eh, 00h
		db	 2Ch, 01h, 00h, 00h, 1Eh, 00h
		db	 6Eh, 00h, 96h, 00h, 00h, 00h
		db	 1Eh, 00h, 6Eh, 00h, 2Ch, 01h
		db	 83h, 00h, 2Ch, 01h, 00h, 00h
		db	 1Eh, 00h, 83h, 00h, 2Ch, 01h
		db	 7Bh, 00h, 2Ch, 01h, 00h, 00h
		db	 1Eh, 00h, 7Bh, 00h, 2Ch, 01h
		db	 6Eh, 00h, 2Ch, 01h, 00h, 00h
		db	 1Eh, 00h, 6Eh, 00h, 2Ch, 01h
		db	 68h, 00h, 2Ch, 01h, 6Eh, 00h
		db	 2Ch, 01h,0FFh,0FFh,0FFh,0FFh
		db	 64h, 00h, 1Eh, 00h, 5Ah, 00h
		db	 1Eh, 00h,0FFh,0FFh,0FFh,0FFh
		db	 7Ch, 01h, 1Eh, 00h, 2Ch, 01h
		db	 1Eh, 00h,0FFh,0FFh,0FFh,0FFh
		db	0DCh, 03h, 12h, 00h, 70h, 03h
		db	 12h, 00h, 10h, 03h, 12h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 07h, 30h
		db	 07h, 30h, 07h, 30h, 07h, 30h
		db	 07h, 00h, 25h, 20h, 25h, 30h
		db	 25h, 20h,0A5h
		db	'0%0%0% %0%'
		db	 00h, 08h, 80h, 80h, 08h, 00h
		db	 06h, 40h, 06h, 40h, 06h, 40h
		db	 06h, 40h, 06h, 40h, 06h, 00h
		db	0B5h
		db	'@5@5@5@5@5'
		db	 00h, 00h, 04h,0F0h, 50h, 04h
		db	0F0h, 50h, 04h, 00h, 03h,0F0h
		db	0F0h,0C0h, 03h, 00h, 02h, 80h
		db	 80h, 02h, 80h, 80h, 02h, 80h
		db	 80h, 02h, 00h, 80h, 01h, 80h
		db	 80h, 01h, 80h, 80h, 01h, 80h
		db	 80h, 01h,0FFh, 02h, 02h, 03h
		db	 02h, 01h, 00h, 05h, 01h, 02h
		db	 02h, 07h, 20h, 09h, 30h, 07h
		db	 40h, 07h, 30h, 07h, 00h,0A5h
		db	'%P%%`%0% %%P%'
		db	 00h, 08h, 80h, 80h, 08h, 00h
		db	 06h, 60h, 06h, 20h, 06h, 20h
		db	 06h, 40h, 06h, 60h, 06h, 00h
		db	0B5h, 35h, 80h, 35h, 40h, 35h
		db	 35h, 80h, 35h, 00h, 00h, 04h
		db	0F0h, 20h, 04h,0F0h, 80h, 04h
		db	 00h, 03h,0F0h,0F0h,0C0h, 03h
		db	 00h, 02h, 80h, 40h, 02h, 80h
		db	0C0h, 02h, 80h, 80h, 02h, 00h
		db	 80h, 01h, 80h, 80h, 01h, 80h
		db	0C0h, 01h, 80h, 80h, 01h,0FFh
		db	 02h, 01h, 03h, 01h, 02h, 00h
		db	 05h, 01h, 02h, 02h, 09h, 20h
		db	 07h, 40h, 07h, 20h, 07h, 40h
		db	 07h, 00h, 25h, 40h,0A5h
		db	'@%@%@%@%@%@%'
		db	 00h, 08h,0D0h, 08h, 00h, 06h
		db	 40h, 06h, 40h, 06h, 40h, 06h
		db	 40h, 06h, 40h, 06h, 00h,0B5h
		db	'@5@5@5@5@5@'
		db	 00h, 00h, 04h,0F0h, 70h, 04h
		db	0F0h, 30h, 04h, 00h, 03h,0F0h
		db	0F0h,0C0h, 03h, 00h, 02h,0B0h
		db	 02h,0B0h, 02h,0B0h, 02h,0B0h
		db	 02h, 00h, 40h, 01h, 80h, 80h
		db	 01h, 80h, 80h, 01h, 80h, 80h
		db	 01h,0FFh, 02h, 01h, 02h, 03h
		db	 02h, 00h, 05h, 01h, 02h, 01h
		db	 09h, 80h, 07h, 80h, 07h, 80h
		db	 07h, 00h,0A5h
		db	'P%`%`%P%`%`%'
		db	 00h, 08h, 80h, 08h, 00h, 06h
		db	 30h, 06h, 50h, 06h, 40h, 06h
		db	 30h, 06h, 40h, 06h, 00h
		db	'5 5@5`5@'
		db	0B5h, 20h, 35h, 00h, 00h, 04h
		db	0C0h, 04h,0C0h, 04h,0C0h, 04h
		db	 00h, 03h, 03h,0F0h,0F0h, 60h
		db	 03h, 03h, 00h, 02h, 70h, 02h
		db	0F0h, 02h
loc_c_105B:
;*		jo	loc_c_105F		;*Jump if overflow=1
		db	 70h, 02h		;  Fixup - byte match
                           lock	add	al,[bx+si]
		add	data_c_B001[bx+si],si
		add	data_c_B001[bx+si],si
;*		add	di,di
		db	 01h,0FFh		;  Fixup - byte match
		add	al,[bx+di]
		add	al,3
		add	al,[bx+si]
		add	ax,301h
		add	al,[bx]
		inc	ax
		or	ds:data_c_F007_e[bx+si],ax
		push	es
		add	[di],ah
		and	byte ptr [di],80h
		movsw				; Mov [si] to es:[di]
		and	byte ptr [di],80h
		and	ax,2580h
		add	[bx+si],cl
                           lock	or	[bx+si],al
		push	es
;*		jo	loc_c_1096		;*Jump if overflow=1
		db	 70h, 07h		;  Fixup - byte match
		jo	loc_c_1097		; Jump if overflow=1
		xor	data_c_0670,al
		add	[di],dh
loc_c_1097:
		xor	[di],dh
		xor	[di],dh
		xor	byte ptr [di],20h	; ' '
		xor	ax,0B510h
		add	[bx+si],al
		add	al,30h			; '0'
		add	al,0C0h
		add	al,0F0h
		add	al,0
		xor	[bp+di],al
		add	si,ax
                           lock	pusha				; Save all regs
		add	ax,[bp+di]
		add	[bp+si],al
		add	byte ptr [bp+si],0E0h
		add	al,ds:data_c_E002_e[bx+si]
		add	al,[bx+si]
		pusha				; Save all regs
		add	data_c_C001[bx+si],ax
		add	data_c_C001[bx+si],sp
;*		add	di,di
		db	 01h,0FFh		;  Fixup - byte match
		add	[bp+si],ax
		add	al,[bp+di]
		add	al,[bx+si]
		add	al,1
		add	al,[bp+si]
;*		or	ax,ax			; Zero ?
		db	 09h,0C0h		;  Fixup - byte match
		pop	es
                           lock	xor	[bx],al
		add	[di],ah
		mov	al,25h			; '%'
		mov	al,0A5h
		mov	al,25h			; '%'
		mov	al,25h			; '%'
		add	byte ptr ds:data_c_F007_e+1[bx+si],al
		pop	es
		add	data_c_06C0,al
;*		loopnz	locloop_c_10F4		;*Loop if zf=0, cx>0

		db	0E0h, 06h		;  Fixup - byte match
		rol	byte ptr data_c_3500,20h	; ' ' Rotate
		mov	ch,40h			; '@'
		xor	ax,3560h
		inc	ax
		xor	ax,3520h
		add	[bx+si],al
		add	al,60h			; '`'
		add	al,80h
		add	al,40h			; '@'
		add	al,80h
		add	al,0
		add	ax,[bp+di]
		add	si,ax
                        lock	add	ax,[bp+di]
		add	ax,[bx+si]
		add	dh,[bx+si+2]
		jo	loc_c_1118		; Jump if overflow=1
		jo	loc_c_111A		; Jump if overflow=1
loc_c_1118:
		jo	loc_c_111C		; Jump if overflow=1
loc_c_111A:
		add	al,[bx+si]
loc_c_111C:
		add	[bx+si+1],ax
		rol	byte ptr [bx+di],60h	; '`' Rotate
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
;*		add	di,di
		db	 01h,0FFh		;  Fixup - byte match
		add	al,[bp+di]
		add	al,[bp+di]
		add	al,[bx+si]
		add	ax,101h
		add	cl,[bx+di]
		add	byte ptr [bx],0F0h
		inc	ax
		pop	es
		add	[di],ah
		and	[di],ah
                           lock	push	ax
		and	ax,2520h
                           lock	push	ax
		movsw				; Mov [si] to es:[di]
		add	[bx+si],cl
		add	data_c_0680,al
                           lock	mov	al,byte ptr ds:[6]
		xor	ax,3570h
;*		jo	loc_c_1186		;*Jump if overflow=1
		db	 70h, 35h		;  Fixup - byte match
		xor	byte ptr data_c_3557+19h[di],0	; ('`````````________`')
		add	[si],al
		add	al,0A0h
		add	al,80h
		add	al,80h
		add	al,0
		and	[bp+di],al
		add	ax,[bp+di]

;                           lock	add	ax,[bp+di]
		db	0f0h, 0f0h, 3, 3

		add	ax,[bx+si]
		add	al,[bx+si+2]
		pusha				; Save all regs
		add	ah,ds:data_c_E002_e[bx+si]
		add	al,[bx+si]
		and	[bx+di],al
		mov	al,1
		rol	byte ptr [bx+di],0B0h	; Rotate
		add	ds:data_c_FF01_e[bx+si],si
		add	ax,[bx+di]
		add	al,[bx+di]
		add	al,[bx+si]
		add	ax,201h
		add	al,[bx+si+7]

;                           lock	and	[bx+di],cl
		db	0f0h, 0f0h, 20h, 9

		add	[di],ah
                           lock	adc	[di],ah
                           lock	adc	[di],ah
                           lock	adc	data_c_7000[di],ah
		or	[bx+si],al
		push	es
                           lock	push	ax
		push	es
                           lock	push	ax
		push	es
		add	[di],dh
		push	ax
		xor	ax,3590h
		xor	byte ptr [di],50h	; 'P'
		mov	ch,0
		add	[si],al
;*		jo	loc_c_11B8		;*Jump if overflow=1
		db	 70h, 04h		;  Fixup - byte match
;*		jo	loc_c_11BA		;*Jump if overflow=1
		db	 70h, 04h		;  Fixup - byte match
		add	byte ptr [si],70h	; 'p'
		add	al,0
		add	ax,[bp+di]
		add	ax,[bp+di]
                           lock	nop
		add	ax,[bp+di]
		add	ax,[bp+di]
		add	[bp+si],al
		nop
		add	dl,ds:data_c_E002_e[bx+si]
		add	ah,byte ptr data_c_0000+2[bx+si]	; ('S')
		add	[bx+si],sp
		add	[bx+si],sp
;*		add	ax,dx
		db	 01h,0D0h		;  Fixup - byte match
;*		add	ax,dx
		db	 01h,0D0h		;  Fixup - byte match
		add	ds:data_c_FF01_e[bx+si],dx
		add	[bp+di],ax
		add	al,[bp+di]
		add	[bx+si],ax
		add	ax,201h
		add	cx,[bx+di]
                           lock	rol	byte ptr [bx],0		; Rotate
		and	ax,40F0h
		and	ax,25D0h
                           lock	inc	ax
		movsw				; Mov [si] to es:[di]
		add	[bx+si],cl
		add	data_c_06F0,al

;                           lock	push	es
		db	0f0h, 0f0h, 6

		add	[di],dh
;*		sal	byte ptr [di],0C0h	; Shift w/zeros fill
		db	0C0h, 35h,0C0h		;  Fixup - byte match
		mov	ch,0C0h
		xor	ax,0
		add	al,20h			; ' '
		add	al,80h
		add	al,0A0h
		add	al,80h
		add	al,0
		xor	[bp+di],al
		add	ax,[bp+di]
		add	si,ax
		nop
		add	ax,[bp+di]
		add	ax,[bp+di]
		add	[bp+si],al
		add	dl,al
		add	al,[bp+si]
                           lock	add	al,[bp+si]
		add	[bx+di],al
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		add	[bx+di],ax
                           lock	and	[bx+di],al
;*		add	di,di
		db	 01h,0FFh		;  Fixup - byte match
		add	al,[bp+si]
		add	ax,[bp+si]
		add	[bx+si],ax
		add	al,1
		add	al,[bx+di]
		or	[bx+si],ax
		and	ax,0A560h
		shl	byte ptr [di],80h	; Shift w/zeros fill
		and	ax,0E000h
		or	[bx+si],al
		push	es
;*		jo	loc_c_1250		;*Jump if overflow=1
		db	 70h, 06h		;  Fixup - byte match
                           lock	mov	al,byte ptr ds:[6]
		xor	ax,3590h
                           lock	xor	ax,0B590h
		add	[bx+si],al
		add	al,20h			; ' '
		add	al,60h			; '`'
		add	al,4
		add	byte ptr [si],40h	; '@'
		add	al,0
		add	ax,[bp+di]
		add	ax,[bp+di]
		add	si,ax
		xor	[bp+di],al
		add	ax,[bp+di]
		add	ax,[bp+di]
		add	[bp+si],al
		inc	ax
		add	al,[bx+si+2]
		nop
		add	dl,byte ptr data_c_0000+2[bx+si]	; ('S')
		add	[bx+si+1],dx
                           lock	inc	ax
		add	[bx+si+1],dx
                           lock	inc	ax
;*		add	di,di
		db	 01h,0FFh		;  Fixup - byte match
		add	[bx+di],ax
		add	ax,[bp+si]
		add	al,[bx+si]
		add	al,1
		add	al,[bp+si]
		push	ax
		or	[bx+si],ax
		and	ax,0A0A5h
		and	ax,0F0F0h
		push	ax
		and	ax,800h
		add	data_c_50F0,al
		push	es
                           lock	push	ax
		push	es
		add	[di],dh
		mov	al,data_c_B535
                           lock	inc	ax
		xor	ax,0
		add	al,4
		push	ax
		add	al,70h			; 'p'
		add	al,40h			; '@'
		add	al,40h			; '@'
		add	al,0
		push	ax
		add	ax,[bp+di]
		add	ax,[bp+di]
		add	si,ax
		xor	[bp+di],al
		add	ax,[bp+di]
		add	ax,[bp+di]
		add	[bp+si],al
		pusha				; Save all regs
		add	al,data_c_A002[bx+si]
		add	ah,byte ptr data_c_8001+1[bx+si]
		add	al,[bx+si]
		add	data_c_8001[bx+si],sp
		add	[bx+si+1],sp
		pusha				; Save all regs
		add	ds:data_c_FF01_e[bx+si],ax
		add	al,[bx+di]
		add	ax,[bx+di]
		add	al,[bx+si]
		add	al,1
		add	ax,[bp+si]
		db	 0Fh, 00h, 2Ah, 00h, 2Ah, 00h
		db	 00h
data_c_12F0	db	0
		db	 00h, 2Ah, 00h, 2Ah, 00h, 2Ah
		db	 00h, 00h, 00h, 30h, 00h, 00h
		db	 2Eh, 00h, 00h, 2Ch, 00h, 00h
		db	 2Ah, 00h, 00h, 28h, 00h
data_c_1308	db	0
		db	 00h, 00h, 15h, 00h, 00h, 00h
		db	 15h, 00h, 00h, 00h, 15h, 2Ah
		db	 2Ah, 00h, 2Ah, 00h, 2Ah, 00h
		db	 2Ah, 2Ah, 2Ah, 15h, 00h, 3Fh
		db	 00h, 00h, 00h, 3Fh, 00h, 00h
		db	 00h, 3Fh, 00h, 3Fh, 3Fh, 2Ah
		db	 1Ch, 02h, 2Eh, 1Eh, 02h, 32h
		db	 20h, 02h, 36h, 22h, 02h, 10h
		db	 20h, 00h, 11h, 22h, 04h, 12h
		db	 24h, 08h, 13h, 26h, 0Ch, 14h
		db	 28h, 10h, 15h, 2Ah, 14h, 16h
		db	 2Ch, 18h, 17h, 2Eh, 1Ch, 18h
		db	 30h, 20h, 19h, 32h, 24h, 1Ah
		db	 34h, 28h, 1Bh, 36h, 2Ch, 1Ch
		db	 38h, 30h, 1Dh, 3Ah, 34h, 1Eh
		db	 3Ch, 38h, 1Fh, 3Eh, 3Ch, 20h
		db	 00h, 00h, 21h, 02h, 04h, 22h
		db	 04h, 08h, 23h, 06h, 0Ch, 24h
		db	 08h, 10h, 25h, 0Ah, 14h, 26h
		db	 0Ch, 18h, 27h, 0Eh, 1Ch, 28h
		db	 10h, 20h, 29h, 12h, 24h, 2Ah
		db	 14h, 28h, 2Bh, 16h, 2Ch, 2Ch
		db	 18h, 30h, 2Dh, 1Ah, 34h, 2Eh
		db	 1Ch, 38h, 2Fh, 1Eh, 3Ch, 30h
		db	 20h, 00h, 31h, 22h, 04h
		db	'2$'
		db	8, '3&', 0Ch, '4('
		db	 10h, 35h, 2Ah, 14h, 36h, 2Ch
		db	 18h, 37h, 2Eh, 1Ch
		db	'80 92$'
		db	':4(;6,<80=:4><8?><'
		db	 02h, 04h, 01h, 04h, 08h, 02h
		db	 06h, 0Ch, 03h, 08h, 10h, 04h
		db	 0Ah, 14h, 05h, 0Ch, 18h, 06h
		db	 0Eh, 1Ch, 07h, 10h, 20h, 08h
		db	 12h, 24h, 09h, 14h, 28h, 0Ah
		db	 16h, 2Ch, 0Bh, 18h, 30h, 0Ch
		db	 1Ah, 34h, 0Dh, 1Ch, 38h, 0Eh
		db	 1Eh, 3Ch, 0Fh, 20h, 00h, 10h
		db	 22h, 04h, 11h, 24h, 08h, 12h
		db	 26h, 0Ch, 13h, 28h, 10h, 14h
		db	 2Ah, 14h, 15h, 2Ch, 18h, 16h
		db	 2Eh, 1Ch, 17h, 30h, 20h, 18h
		db	 32h, 24h, 19h, 34h, 28h, 1Ah
		db	 36h, 2Ch, 1Bh, 38h, 30h, 1Ch
		db	 3Ah, 34h, 1Dh, 3Ch, 38h, 1Eh
		db	 3Eh, 3Ch, 1Fh, 00h, 00h, 20h
		db	 02h, 04h, 21h, 04h, 08h, 22h
		db	 06h, 0Ch, 23h, 08h, 10h, 24h
		db	 0Ah, 14h, 25h, 0Ch, 18h, 26h
		db	 0Eh, 1Ch, 27h, 10h, 20h, 28h
		db	 12h, 24h, 29h, 14h, 28h, 2Ah
		db	 16h, 2Ch, 2Bh, 18h, 30h, 2Ch
		db	 1Ah, 34h, 2Dh, 1Ch, 38h, 2Eh
		db	 1Eh, 3Ch, 2Fh, 20h, 00h, 30h
		db	 22h, 04h
		db	'1$'
		db	8, '2&', 0Ch, '3('
		db	 10h, 34h, 2Ah, 14h, 35h, 2Ch
		db	 18h, 36h, 2Eh, 1Ch
		db	'70 82$'
		db	'94(:6,;80<:4=<8>><?'
		db	 04h, 01h, 02h, 08h, 02h, 04h
		db	 0Ch, 03h, 06h, 10h, 04h, 08h
		db	 14h, 05h, 0Ah, 18h, 06h, 0Ch
		db	 1Ch, 07h, 0Eh, 20h, 08h, 10h
		db	 24h, 09h, 12h, 28h, 0Ah, 14h
		db	 2Ch, 0Bh, 16h, 30h, 0Ch, 18h
		db	 34h, 0Dh, 1Ah, 38h, 0Eh, 1Ch
		db	 3Ch, 0Fh, 1Eh, 00h, 10h, 20h
		db	 04h, 11h, 22h, 08h, 12h, 24h
		db	 0Ch, 13h, 26h, 10h, 14h, 28h
		db	 14h, 15h, 2Ah, 18h, 16h, 2Ch
		db	 1Ch, 17h, 2Eh, 20h, 18h, 30h
		db	 24h, 19h, 32h, 28h, 1Ah, 34h
		db	 2Ch, 1Bh, 36h, 30h, 1Ch, 38h
		db	 34h, 1Dh, 3Ah, 38h, 1Eh, 3Ch
		db	 3Ch, 1Fh, 3Eh, 00h, 20h, 00h
		db	 04h, 21h, 02h, 08h, 22h, 04h
		db	 0Ch, 23h, 06h, 10h, 24h, 08h
		db	 14h, 25h, 0Ah, 18h, 26h, 0Ch
		db	 1Ch, 27h, 0Eh, 20h, 28h, 10h
		db	 24h, 29h, 12h, 28h, 2Ah, 14h
		db	 2Ch, 2Bh, 16h, 30h, 2Ch, 18h
		db	 34h, 2Dh, 1Ah, 38h, 2Eh, 1Ch
		db	 3Ch, 2Fh, 1Eh, 00h, 30h, 20h
		db	 04h
		db	'1"', 8, '2$'
		db	0Ch, '3&'
		db	 10h, 34h, 28h, 14h, 35h, 2Ah
		db	 18h, 36h, 2Ch, 1Ch
		db	'7. 80$'
		db	'92(:4,;60<84=:8><<?>'
		db	 02h, 03h, 04h, 04h, 06h, 08h
		db	 06h, 09h, 0Ch, 08h, 0Ch, 10h
		db	 0Ah, 0Fh, 14h, 0Ch, 12h, 18h
		db	 0Eh, 15h, 1Ch, 10h, 18h, 20h
		db	 12h, 1Bh, 24h, 14h, 1Eh, 28h
		db	 16h, 21h, 2Ch, 18h, 24h, 30h
		db	 1Ah, 27h, 34h, 1Ch, 2Ah, 38h
		db	 1Eh, 2Dh, 3Ch, 20h, 30h, 00h
		db	 22h, 33h, 04h
		db	'$'
		db	'6', 8, '&9', 0Ch, '(<'
		db	 10h, 2Ah, 3Fh, 14h, 14h, 14h
		db	 14h, 18h, 18h, 18h, 1Ch, 1Ch
		db	 1Ch
		db	'   $$$'
		db	'&&&***...222666'
		db	 00h, 20h, 02h, 02h, 23h, 04h
		db	 04h, 26h, 08h, 06h, 29h, 0Ch
		db	 08h, 2Ch, 10h, 0Ah, 2Fh, 14h
		db	 0Ch, 32h, 18h, 0Eh, 35h, 1Ch
		db	 10h, 38h, 20h, 12h, 3Bh, 24h
		db	 14h, 3Eh, 28h, 16h, 01h, 2Ch
		db	 18h, 04h, 30h, 1Ah, 07h, 34h
		db	 1Ch, 0Ah, 38h, 1Eh, 0Dh, 3Ch
		db	 20h, 10h, 00h, 22h, 13h, 04h
		db	 24h, 16h, 08h, 26h, 19h, 0Ch
		db	 28h, 1Ch, 10h, 2Ah, 1Fh, 14h
		db	 2Ch, 22h, 18h, 2Eh, 25h, 1Ch
		db	 30h, 28h, 20h, 3Eh, 14h, 07h
		db	 3Eh, 19h, 07h, 3Eh, 1Eh, 07h
		db	 3Eh, 23h, 07h, 39h, 27h, 00h
		db	 3Bh, 2Fh, 00h, 3Dh, 37h, 00h
		db	 3Fh, 3Fh, 00h, 3Fh, 00h
		db	 3Fh, 3Fh, 3Fh, 3Fh
data_c_1608	db	0Ch
		db	 18h, 06h, 0Eh, 1Ch, 07h, 10h
		db	 20h, 08h, 06h, 29h, 0Ch, 06h
		db	 28h, 1Eh
		db	8, '0"', 0Ah, '8&', 0Ch, '?*3'
		db	 06h, 0Ch, 39h, 07h, 0Eh, 3Fh
		db	 08h, 10h, 3Ch, 10h, 0Ah, 22h
		db	 04h, 11h, 24h, 08h, 12h, 26h
		db	 0Ch, 13h, 2Ah, 14h, 15h, 3Ch
		db	 10h, 0Ah, 3Dh, 14h, 0Ch, 3Eh
		db	 18h, 0Eh, 3Fh, 1Eh, 10h, 06h
		db	 1Eh
		db	'(', 8, '"0', 0Ah, '&8', 0Ch, '*?'
		db	 1Ch, 3Ah, 3Bh, 18h, 38h, 3Ch
		db	 13h, 36h, 3Dh, 0Fh, 33h, 3Dh
		db	 06h, 0Ch, 24h, 07h, 0Eh, 28h
		db	 08h, 10h, 2Ch, 10h, 10h, 36h
		db	 31h, 04h, 22h, 35h, 06h, 23h
		db	 39h, 08h, 24h, 3Fh, 10h, 2Ah
		db	 22h, 04h
		db	'1$'
		db	8, '2&', 0Ch, '3,'
		db	 14h, 3Ch, 3Ch, 1Ah, 1Eh, 3Dh
		db	 1Eh
		db	' >""?((#'
		db	 14h, 06h, 2Bh, 18h, 08h, 33h
		db	 1Ch, 0Ah, 3Bh, 21h, 10h, 3Bh
		db	 35h, 1Ch, 3Dh, 37h, 1Ah, 3Eh
		db	 39h, 18h, 3Fh, 3Bh, 16h, 32h
		db	 28h, 06h, 36h, 2Ah, 07h, 3Ah
		db	 2Ch, 08h, 3Eh, 34h, 0Ch, 0Eh
		db	 13h, 19h, 12h, 16h, 1Bh, 16h
		db	 19h, 1Ch, 1Bh, 1Ch, 1Eh
		db	':4*<82><:???'
		db	10h
		db	'_`___`_`````____`_'
		db	0A0h,0A0h
		db	'__`_____`_'
		db	0A0h,0A0h, 60h, 5Fh,0A0h,0A0h
		db	0A3h
		db	'___', 0Ch, 0Ch, 0Ch, '___'
		db	0A3h,0A0h, 60h, 5Fh, 5Fh, 5Fh
		db	0A3h,0A3h, 0Ch, 0Ch, 0Ch, 0Dh
		db	 0Ch, 0Ch, 0Ch,0A3h,0A3h
		db	'______', 0Ch, 0Ch, 0Dh, 0Dh
		db	 0Eh, 0Dh, 0Dh, 0Ch, 0Ch, 5Fh
		db	 60h, 5Fh,0A2h,0A2h, 5Fh, 0Ch
		db	 0Ch, 0Dh, 0Eh, 0Eh, 0Fh, 0Eh
		db	 0Eh, 0Dh, 0Ch, 0Ch, 5Fh,0A2h
		db	0A2h,0A2h,0A2h, 0Ch, 0Dh, 0Eh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Eh
		db	 0Dh, 0Ch, 5Fh,0A2h,0A2h,0A2h
		db	0A2h, 0Ch, 0Dh, 0Eh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Eh, 0Dh, 0Ch
		db	 5Fh, 5Fh,0A2h,0A2h, 5Fh, 0Ch
		db	 0Ch, 0Dh, 0Eh, 0Eh, 0Fh, 0Eh
		db	 0Eh
		db	0Dh, 0Ch, 0Ch, '______', 0Ch, 0Ch
		db	0Dh, 0Dh
		db	0Eh
		db	0Dh, 0Dh, 0Ch, 0Ch, '_``___'
		db	0A3h,0A3h, 0Ch, 0Ch, 0Ch, 0Dh
		db	 0Ch, 0Ch, 0Ch,0A3h,0A3h, 5Fh
		db	 60h, 5Fh,0A0h,0A0h,0A3h
		db	'___', 0Ch, 0Ch, 0Ch, '___'
		db	0A3h,0A0h, 60h, 5Fh,0A0h,0A0h
		db	'__`_____`_'
		db	0A0h,0A0h
		db	'_`___`_`````____'
		db	 10h, 5Fh, 5Fh
		db	'____bbbbb_________bb_____bb_____'
		db	'_b___', 0Ch, 0Ch, 0Ch, '___b____'
		db	'b__', 0Ch, 0Ch, 0Ch, 0Dh, 0Ch, 0Ch
		db	0Ch, '__b__b__', 0Ch, 0Ch, 0Dh, 0Dh
		db	0Eh
		db	0Dh, 0Dh, 0Ch, 0Ch, '__b_b_', 0Ch
		db	0Ch, 0Dh
		db	 0Eh, 0Eh, 0Fh, 0Eh, 0Eh
		db	0Dh, 0Ch, 0Ch, '_b_b_', 0Ch, 0Dh
		db	 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Eh
		db	0Dh, 0Ch, '_b_b_', 0Ch, 0Dh
		db	 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Eh
		db	0Dh, 0Ch, '_b_b_', 0Ch, 0Ch, 0Dh
		db	 0Eh, 0Eh, 0Fh, 0Eh, 0Eh
		db	0Dh, 0Ch, 0Ch, '_b_b__', 0Ch, 0Ch
		db	0Dh, 0Dh
		db	0Eh
		db	0Dh, 0Dh, 0Ch, 0Ch, '__b__b__', 0Ch
		db	0Ch, 0Ch, 0Dh, 0Ch, 0Ch, 0Ch, '__'
		db	'b____b___', 0Ch, 0Ch, 0Ch, '___b'
		db	'______bb_____bb_________bbbbb___'
		db	'__'
		db	 10h, 5Fh, 5Fh
		db	'____bbbbb_________bb_____bb_____'
		db	'_b___bbb___b____b__bb___bb__b__b'
		db	'__b_______b__b_b_b__'
		db	 0Eh, 0Eh, 0Fh, 0Eh, 0Eh
		db	'__b_b_b_b_'
		db	 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Eh
		db	'_b_b_b_b_'
		db	 0Eh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Eh
		db	'_b_b_b_b__'
		db	 0Eh, 0Eh, 0Fh, 0Eh, 0Eh
		db	'__b_b_b__b_______b__b__b__bb___b'
		db	'b__b____b___bbb___b______bb_____'
		db	'bb_________bbbbb_____'
data_c_196B	db	10h
		db	 5Fh, 5Fh
		db	'____bbbbb_________bb_____bb_____'
		db	'_b___bbb___b____b__bb___bb__b__b'
		db	'__b_______b__b_b_b__bbbbb__b_b_b'
		db	'_b_b_____b_b_b_b_b_b_____b_b_b_b'
		db	'_b__bbbbb__b_b_b__b_______b__b__'
		db	'b__bb___bb__b____b___bbb___b____'
		db	'__bb_____bb_________bbbbb_____0_'
		db	'_`````````____________'
		db	0EFh,0EFh
		db	24 dup (5Fh)
		db	 60h,0F1h,0F1h
		db	7 dup (0EDh)
		db	 60h, 60h, 60h, 60h, 60h
		db	8 dup (5Fh)
		db	0EEh,0EEh,0EEh
		db	11 dup (5Fh)
		db	8 dup (60h)
		db	 5Fh, 5Fh, 60h,0F1h,0F3h,0F3h
		db	0F0h,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EFh
		db	9 dup (0EDh)
		db	 5Fh, 5Fh, 5Fh, 5Fh, 5Fh, 5Fh
		db	0EDh,0EDh,0EDh,0EDh,0EDh
		db	 5Fh, 60h, 60h, 60h, 60h, 60h
		db	 60h
		db	8 dup (0EDh)
		db	 60h, 5Fh, 60h,0F1h,0F3h,0F3h
		db	0F0h
		db	7 dup (0EEh)
		db	8 dup (0EFh)
		db	0EDh,0EDh,0EDh,0EDh,0EDh,0EDh
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	7 dup (0EDh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EEh
		db	0EEh,0EEh,0EDh, 60h,0F1h,0F3h
		db	0F3h,0F3h,0F3h,0F0h,0EFh,0EFh
		db	0EFh,0EFh,0EFh,0EFh
		db	7 dup (0EEh)
		db	8 dup (0EFh)
		db	8 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EEh,0EEh
		db	0EEh,0EEh,0EFh,0EFh,0EFh,0EDh
		db	 60h,0F1h,0F3h,0F4h,0F4h,0F3h
		db	0F0h,0EEh,0EEh,0EEh,0EEh,0EEh
		db	8 dup (0EFh)
		db	8 dup (0EEh)
		db	8 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EFh,0EFh
		db	0EFh,0EFh,0EFh,0EEh,0EEh,0EEh
		db	0EDh,0F1h,0F3h,0F4h,0F4h,0F3h
		db	0F0h,0EFh,0EFh,0EFh,0EFh,0EFh
		db	7 dup (0EEh)
		db	10 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EEh,0EEh,0EEh,0EEh,0EFh,0EFh
		db	0EFh,0EDh,0F1h,0F3h,0F3h,0F3h
		db	0F3h,0F0h,0EEh,0EEh,0EEh,0EEh
		db	8 dup (0EFh)
		db	10 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EEh
		db	0EEh,0EDh, 60h,0F1h,0F3h,0F3h
		db	0F0h,0EFh,0EFh,0EFh,0EFh,0EFh
		db	7 dup (0EEh)
		db	12 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh
		db	8 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EFh,0EDh
		db	 60h, 60h,0F1h,0F3h,0F3h,0F0h
		db	0EEh,0EEh,0EEh,0EEh
		db	8 dup (0EFh)
		db	12 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh
		db	8 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EDh
		db	 60h, 5Fh, 60h,0F1h,0F1h,0EDh
		db	8 dup (0EDh)
		db	0EFh,0EEh,0EEh,0EFh,0EFh,0EFh
		db	0EFh,0EFh
		db	7 dup (0EDh)
		db	0EFh,0EFh,0EEh,0EEh,0EFh,0EFh
		db	0EFh,0EFh,0EFh,0EFh
		db	8 dup (0EDh)
		db	 60h, 5Fh, 5Fh, 5Fh
		db	11 dup (60h)
		db	8 dup (0EDh)
		db	7 dup (60h)
		db	10 dup (0EDh)
		db	8 dup (60h)
		db	15 dup (5Fh)
		db	 60h, 60h, 60h, 60h,0EEh,0EEh
		db	'``_______``````````_____________'
		db	'____________`'
		db	0EFh,0EFh
		db	'`_____________________________@_'
		db	'_________`'
		db	0EFh,0EFh
		db	'`_____`````````_________________'
		db	'``___________________``````````'
		db	0EFh,0EFh, 60h, 60h, 60h, 60h
		db	 60h
		db	9 dup (0EDh)
		db	11 dup (60h)
		db	 5Fh, 5Fh, 5Fh, 5Fh, 5Fh, 60h
		db	0EEh,0EEh
		db	60h
		db	8 dup (5Fh)
		db	'``````___`'
		db	0F0h,0F0h
		db	15 dup (0EDh)
		db	9 dup (0EFh)
		db	11 dup (0EDh)
		db	 60h, 60h, 60h, 60h, 60h, 5Fh
		db	 60h,0EEh,0EEh
		db	8 dup (60h)
		db	0EDh,0EDh,0EDh,0EDh,0EDh,0EDh
		db	 60h, 5Fh, 60h,0F0h,0F3h,0F3h
		db	0F0h
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh
		db	7 dup (0EEh)
		db	11 dup (0EFh)
		db	0EDh,0EDh,0EDh,0EDh,0EDh
		db	 60h, 60h, 60h
		db	9 dup (0EDh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EDh, 60h, 60h,0F0h,0F3h,0F3h
		db	0F0h
		db	7 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EEh,0EEh,0EEh
		db	7 dup (0EFh)
		db	10 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EDh,0EDh,0EDh
		db	8 dup (0EFh)
		db	7 dup (0EEh)
		db	0EDh, 60h,0F0h,0F3h,0F4h,0F4h
		db	0F3h,0F0h
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EFh,0EFh
		db	0EFh,0EFh,0EFh,0EEh,0EEh,0EEh
		db	0EEh,0EEh
		db	11 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh
		db	8 dup (0EEh)
		db	8 dup (0EFh)
		db	0EDh,0F0h,0F3h,0F4h,0F4h,0F3h
		db	0F0h
		db	7 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EEh,0EEh
		db	0EEh,0EEh,0EEh,0EFh,0EFh,0EFh
		db	0EFh,0EFh
		db	10 dup (0EEh)
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh
		db	9 dup (0EFh)
		db	7 dup (0EEh)
		db	0EDh,0F0h,0F3h,0F4h,0F4h,0F3h
		db	0F0h
		db	8 dup (0EFh)
		db	0EEh,0EEh
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh
		db	11 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	8 dup (0EEh)
		db	7 dup (0EFh)
		db	0EDh,0F0h,0F3h,0F4h,0F4h,0F3h
		db	0F0h
		db	8 dup (0EEh)
		db	0EFh,0EFh
		db	7 dup (0EEh)
		db	0EFh,0EFh,0EFh
		db	10 dup (0EEh)
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh
		db	9 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EDh, 60h,0F0h,0F3h,0F3h,0F0h
		db	10 dup (0EFh)
		db	0EEh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EDh,0EDh,0EDh,0EDh,0EDh
		db	10 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	9 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EDh
		db	 60h, 60h,0F0h,0F3h,0F3h,0F0h
		db	9 dup (0EEh)
		db	7 dup (0EDh)
		db	 60h, 60h, 60h, 60h, 60h
		db	9 dup (0EDh)
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	10 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EDh, 60h
		db	 5Fh, 60h,0F0h,0F0h
		db	10 dup (0EDh)
		db	 60h, 60h, 60h,0EEh,0EEh,0EEh
		db	 60h, 5Fh, 5Fh, 5Fh, 5Fh, 5Fh
		db	9 dup (60h)
		db	10 dup (0EDh)
		db	0EFh,0EFh,0EFh,0EFh
		db	8 dup (0EEh)
		db	0EDh,0EDh,0EDh,0EDh,0EDh
		db	 60h, 5Fh, 5Fh, 5Fh
		db	13 dup (60h)
		db	0EFh,0EEh,0EEh, 60h, 60h
		db	12 dup (5Fh)
		db	 60h, 60h,0EEh,0EEh
		db	9 dup (60h)
		db	0EDh,0EDh,0EDh,0EDh,0EFh,0EFh
		db	0EFh,0EFh,0EFh,0EDh,0EDh,0EDh
		db	'`````_________________```_______'
		db	'______`'
		db	0EEh,0EEh, 60h, 60h
		db	12 dup (5Fh)
		db	 60h,0EDh,0EDh,0EDh,0EDh,0EDh
		db	 60h, 60h, 60h
		db	7 dup (5Fh)
		db	 80h, 5Fh, 5Fh, 60h
		db	'``````````________````````````__'
		db	'__________``____________________'
		db	'________________________________'
		db	'_________``___________________`'
		db	0F0h,0F0h
		db	9 dup (0EDh)
		db	8 dup (60h)
		db	12 dup (0EDh)
		db	12 dup (60h)
		db	0EEh,0EEh
		db	'``______________________________'
		db	'``__________________________`'
		db	0EEh,0EEh, 60h
		db	8 dup (5Fh)
		db	7 dup (60h)
		db	 5Fh, 5Fh, 60h,0F0h,0F3h,0F3h
		db	0F0h
		db	8 dup (0EFh)
		db	8 dup (0EDh)
		db	8 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh
		db	10 dup (0EDh)
		db	 60h, 60h, 60h,0EEh,0EEh,0EEh
		db	12 dup (60h)
		db	17 dup (5Fh)
		db	 60h,0EEh,0EEh, 60h, 60h
		db	7 dup (5Fh)
		db	10 dup (60h)
		db	8 dup (5Fh)
		db	 60h,0EEh,0EEh
		db	8 dup (60h)
		db	7 dup (0EDh)
		db	 60h, 5Fh, 60h,0F0h,0F3h,0F3h
		db	0F0h,0EFh
		db	7 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	10 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EEh,0EEh
		db	0EEh,0EEh,0EEh,0EEh,0EFh,0EFh
		db	0EFh,0EFh
		db	18 dup (0EDh)
		db	12 dup (60h)
		db	 5Fh, 5Fh, 5Fh, 5Fh, 5Fh, 5Fh
		db	 60h,0EEh,0EEh
		db	8 dup (60h)
		db	10 dup (0EDh)
		db	10 dup (60h)
		db	9 dup (0EDh)
		db	7 dup (0EFh)
		db	0EDh, 60h,0F0h,0F3h,0F4h,0F4h
		db	0F3h,0F0h
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	11 dup (0EFh)
		db	0EEh,0EEh
		db	7 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh
		db	18 dup (0EFh)
		db	12 dup (0EDh)
		db	8 dup (60h)
		db	9 dup (0EDh)
		db	10 dup (0EFh)
		db	10 dup (0EDh)
		db	9 dup (0EFh)
		db	7 dup (0EEh)
		db	0EDh, 60h,0F0h,0F3h,0F4h,0F4h
		db	0F3h,0F0h,0EEh,0EEh,0EEh,0EEh
		db	0EEh,0EEh
		db	8 dup (0EFh)
		db	10 dup (0EEh)
		db	0EFh,0EFh,0EEh,0EEh,0EEh,0EEh
		db	0EEh,0EEh,0EFh,0EFh,0EFh,0EFh
		db	0EFh
		db	19 dup (0EEh)
		db	11 dup (0EFh)
		db	8 dup (0EDh)
		db	11 dup (0EFh)
		db	9 dup (0EEh)
		db	10 dup (0EFh)
		db	8 dup (0EEh)
		db	8 dup (0EFh)
		db	0EDh,0F0h,0F3h,0F4h,0F4h,0F3h
		db	0F0h,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EFh
		db	8 dup (0EEh)
		db	11 dup (0EFh)
		db	0EEh,0EFh,0EFh,0EFh,0EFh,0EFh
		db	0EFh,0EEh,0EEh,0EEh,0EEh
		db	20 dup (0EFh)
		db	10 dup (0EEh)
		db	10 dup (0EFh)
		db	10 dup (0EEh)
		db	9 dup (0EFh)
		db	10 dup (0EEh)
		db	9 dup (0EFh)
		db	7 dup (0EEh)
		db	0EDh,0F0h,0F3h,0F4h,0F4h,0F3h
		db	0F0h,0EEh,0EEh,0EEh,0EEh,0EEh
		db	10 dup (0EFh)
		db	10 dup (0EEh)
		db	0EFh,0EEh,0EEh,0EEh,0EEh,0EEh
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	19 dup (0EEh)
		db	11 dup (0EFh)
		db	10 dup (0EEh)
		db	11 dup (0EFh)
		db	7 dup (0EEh)
		db	12 dup (0EFh)
		db	8 dup (0EEh)
		db	7 dup (0EFh)
		db	0EDh,0F0h,0F3h,0F4h,0F4h,0F3h
		db	0F0h,0EFh,0EFh,0EFh,0EFh,0EFh
		db	10 dup (0EEh)
		db	16 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh
		db	20 dup (0EFh)
		db	10 dup (0EEh)
		db	12 dup (0EFh)
		db	10 dup (0EEh)
		db	7 dup (0EFh)
		db	12 dup (0EEh)
		db	9 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh,0EDh
		db	 60h, 60h,0F0h,0F3h,0F3h,0F0h
		db	0EFh,0EEh,0EEh,0EEh,0EEh
		db	12 dup (0EFh)
		db	8 dup (0EEh)
		db	10 dup (0EDh)
		db	0EFh
		db	19 dup (0EEh)
		db	11 dup (0EFh)
		db	12 dup (0EEh)
		db	11 dup (0EFh)
		db	0EEh,0EEh,0EEh,0EEh,0EEh
		db	13 dup (0EFh)
		db	9 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh,0EDh
		db	 60h, 60h,0F0h,0F3h,0F3h,0F0h
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	8 dup (0EEh)
		db	12 dup (0EDh)
		db	10 dup (60h)
		db	15 dup (0EDh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	10 dup (0EEh)
		db	14 dup (0EFh)
		db	10 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	13 dup (0EEh)
		db	8 dup (0EFh)
		db	0EDh,0EDh,0EDh,0EDh,0EDh,0EDh
		db	 60h, 5Fh, 5Fh, 60h,0F0h,0F0h
		db	14 dup (0EDh)
		db	12 dup (60h)
		db	10 dup (5Fh)
		db	10 dup (60h)
		db	0EEh,0EEh,0EEh, 60h, 60h
		db	11 dup (0EDh)
		db	0EFh,0EFh,0EFh,0EFh
		db	14 dup (0EEh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	16 dup (0EDh)
		db	7 dup (0EFh)
		db	8 dup (0EDh)
		db	'``````____'
		db	12 dup (60h)
		db	0EEh,0EEh, 60h, 60h
		db	29 dup (5Fh)
		db	 60h,0EEh,0EEh,0EEh
		db	 60h, 60h, 5Fh, 5Fh
		db	11 dup (60h)
		db	9 dup (0EDh)
		db	0EFh,0EFh,0EFh,0EFh,0EFh
		db	9 dup (0EDh)
		db	13 dup (60h)
		db	0EEh,0EEh, 60h
		db	7 dup (0EDh)
		db	8 dup (60h)
		db	20 dup (5Fh)
		db	 60h,0EEh,0EEh
		db	'`_______________________________'
		db	'_```_______________`````````'
		db	0EDh,0EDh,0EDh,0EDh,0EDh,0EEh
		db	8 dup (60h)
		db	11 dup (5Fh)
		db	 60h,0EEh,0EEh, 60h, 5Fh
		db	7 dup (60h)
		db	16 dup (5Fh)
		db	 20h,0C3h
		db	33 dup (0C3h)
		db	8 dup (0)
		db	24 dup (0C3h)
		db	8 dup (0)
		db	27 dup (0C3h)
		db	0CDh,0CDh
		db	19 dup (0C3h)
		db	 00h, 00h, 00h,0C3h,0C3h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0A0h,0A0h
		db	0A0h,0A0h,0C3h,0C3h
		db	17 dup (0C3h)
		db	0CDh,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C3h,0C3h,0A0h,0A0h, 9Eh, 9Eh
		db	22 dup (0A0h)
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0A0h
		db	0A0h, 9Eh,0DFh,0DFh
		db	22 dup (9Eh)
		db	0A0h,0C3h,0C3h,0C3h,0C3h,0A0h
		db	0A0h, 9Eh,0DFh,0DFh
		db	22 dup (9Eh)
		db	0A0h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0A0h,0A0h, 9Eh, 9Eh
		db	22 dup (0A0h)
		db	7 dup (0C3h)
		db	0A0h,0A0h,0A0h,0A0h,0C3h,0C3h
		db	17 dup (0C3h)
		db	0CDh,0C3h
		db	8 dup (0C3h)
		db	0CDh,0CDh
		db	19 dup (0C3h)
		db	 00h, 00h, 00h,0C3h,0C3h,0C3h
		db	0C3h,0C3h
		db	8 dup (0)
		db	24 dup (0C3h)
		db	8 dup (0)
		db	54 dup (0C3h)
		db	 20h,0C3h
		db	40 dup (0C3h)
		db	0C8h,0C8h,0C8h,0C8h
		db	11 dup (0C3h)
		db	0C8h,0C8h,0C8h,0C8h
		db	10 dup (0C3h)
		db	23 dup (20h)
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	 20h, 20h, 20h, 21h
		db	21 dup (21h)
		db	 25h, 24h,0C3h,0C3h,0C3h, 20h
		db	 20h, 21h, 21h,0D3h
		db	22h
		db	20 dup (22h)
		db	 25h, 24h, 23h, 22h,0C3h, 20h
		db	 21h, 21h, 22h,0D3h
		db	22h
		db	20 dup (24h)
		db	 25h, 24h, 23h, 22h, 21h,0C3h
		db	 20h, 21h, 22h, 24h,0D3h
		db	 24h, 24h, 25h
		db	18 dup (25h)
		db	 24h, 23h, 22h, 21h, 20h,0C3h
		db	 20h, 21h, 22h, 24h,0D3h
		db	 24h, 24h, 25h
		db	18 dup (25h)
		db	 24h, 23h, 22h, 21h, 20h,0C3h
		db	 20h, 21h, 21h, 22h,0D3h
		db	22h
		db	20 dup (24h)
		db	 25h, 24h, 23h, 22h, 21h,0C3h
		db	0C3h, 20h, 20h, 21h, 21h,0D3h
		db	22h
		db	20 dup (22h)
		db	 25h, 24h, 23h, 22h,0C3h,0C3h
		db	0C3h,0C3h
		db	 20h, 20h, 20h, 21h
		db	21 dup (21h)
		db	 25h, 24h,0C3h
		db	7 dup (0C3h)
		db	23 dup (20h)
		db	12 dup (0C3h)
		db	0C8h,0C8h,0C8h,0C8h
		db	11 dup (0C3h)
		db	0C8h,0C8h,0C8h,0C8h
		db	36 dup (0C3h)
		db	 18h,0C3h
		db	26 dup (0C3h)
		db	0C8h,0C8h,0C8h,0C8h,0C8h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C8h,0C8h,0C8h,0C8h,0C8h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C8h,0C8h,0C8h,0C8h,0C8h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C8h,0C8h,0C8h,0C8h,0C8h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C3h,0C3h
		db	55h
		db	11 dup (0C3h)
		db	 55h,0C3h,0C3h,0C3h,0F6h,0F6h
		db	0C3h,0C3h,0EBh,0EBh
		db	17 dup (0ECh)
		db	0C3h,0F6h,0F7h,0F6h,0C3h,0C3h
		db	0ECh
		db	17 dup (0Ah)
		db	0ECh,0F6h,0F7h,0F6h,0C3h,0EBh
		db	0ECh, 0Ah, 08h,0F6h,0F7h, 08h
		db	0F7h,0F6h,0F7h, 08h,0F7h,0F6h
		db	0F7h, 08h,0F7h,0F6h, 08h, 0Ah
		db	0ECh,0F6h,0F7h,0F6h,0C3h,0EBh
		db	0ECh, 0Ah, 08h,0F6h,0F7h, 08h
		db	0F7h,0F6h,0F7h, 08h,0F7h,0F6h
		db	0F7h, 08h,0F7h,0F6h, 08h, 0Ah
		db	0ECh,0F6h,0F7h,0F6h,0C3h,0C3h
		db	0ECh
		db	17 dup (0Ah)
		db	0ECh,0F6h,0F7h,0F6h,0C3h,0EBh
		db	0EBh,0ECh
		db	16 dup (0ECh)
		db	0C3h,0F6h,0F7h,0F6h,0C3h,0C3h
		db	0C3h,0C3h,0C3h
		db	55h
		db	11 dup (0C3h)
		db	 55h,0C3h,0C3h,0C3h,0F6h,0F6h
		db	0C3h,0C3h,0C3h,0C3h,0C8h,0C8h
		db	0C8h,0C8h,0C8h
		db	7 dup (0C3h)
		db	0C8h,0C8h,0C8h,0C8h,0C8h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C8h,0C8h,0C8h,0C8h,0C8h,0C3h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0C8h,0C8h,0C8h,0C8h,0C8h
		db	28 dup (0C3h)
		db	 30h,0C3h
		db	143 dup (0C3h)
		db	8 dup (0F6h)
		db	0C3h,0C3h
		db	37 dup (0FFh)
		db	0C3h
		db	8 dup (0F6h)
		db	0C3h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 08h,0FFh,0FFh,0FFh
		db	0FFh, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	0FFh,0FFh, 09h, 09h,0FFh,0FFh
		db	0FFh, 09h, 09h,0FFh,0FFh,0FEh
		db	0FEh,0FEh,0FEh,0FEh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0C3h
		db	8 dup (0F6h)
		db	0C3h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 08h,0FFh, 08h,0FFh,0FFh
		db	0FFh, 0Ah,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh, 09h,0FFh
		db	 09h,0FFh, 09h,0FFh,0FFh,0FEh
		db	9 dup (0FFh)
		db	0C3h
		db	8 dup (0F6h)
		db	0C9h,0C9h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 08h,0FFh, 08h,0FFh,0FFh
		db	0FFh, 0Ah,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh,0FFh, 09h
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FEh
		db	0FEh,0FEh
		db	7 dup (0FFh)
		db	0C3h
		db	8 dup (0F6h)
		db	0C9h,0C9h,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h, 08h,0FFh
		db	0FFh, 0Ah,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FEh
		db	9 dup (0FFh)
		db	0C3h
		db	8 dup (0F6h)
		db	0C3h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	 08h,0FFh,0FFh,0FFh, 08h,0FFh
		db	0FFh, 0Ah,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FEh
		db	9 dup (0FFh)
		db	0C3h
		db	8 dup (0F6h)
		db	0C3h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	 08h,0FFh,0FFh,0FFh, 08h,0FFh
		db	0FFh, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 09h,0FFh,0FFh,0FEh
		db	0FEh,0FEh,0FEh,0FEh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0C3h
		db	8 dup (0F6h)
		db	0C3h,0C3h
		db	37 dup (0FFh)
		db	145 dup (0C3h)
		db	'@_______________________________'
		db	'__________________````__________'
		db	'_______________________________`'
		db	'``````````______``'
		db	0A7h,0A7h,0A7h,0A7h
		db	'``______________________________'
		db	'______```'
		db	11 dup (0A6h)
		db	 60h, 60h, 5Fh, 5Fh, 60h, 60h
		db	8 dup (0A7h)
		db	'```````_________________________'
		db	'__``'
		db	0A6h,0A6h,0A6h,0A6h
		db	9 dup (0A5h)
		db	0A6h,0A6h,0A6h, 60h, 60h,0A7h
		db	0A7h,0A7h,0A7h,0A7h,0A7h, 86h
		db	 88h,0A7h,0A7h,0A7h,0A7h,0A6h
		db	0A6h,0A6h,0A6h,0A6h
		db	60h
		db	23 dup (5Fh)
		db	 60h, 60h, 60h,0A6h,0A6h,0A6h
		db	0A5h,0A5h,0A5h,0A5h
		db	8 dup (0A6h)
		db	0A5h,0A5h,0A6h,0A6h
		db	13 dup (0A7h)
		db	0A6h,0A6h,0A6h,0A6h,0A8h,0A6h
		db	 60h
		db	17 dup (5Fh)
		db	 60h, 60h, 60h, 60h, 60h,0A6h
		db	0A6h,0A6h,0A6h,0A5h,0A5h,0A5h
		db	0A6h,0A6h,0A6h
		db	7 dup (0A5h)
		db	0A6h,0A6h,0A6h,0A5h,0A5h,0A5h
		db	0A5h,0A5h,0A6h,0A6h,0A7h,0A7h
		db	0A7h,0A7h
		db	11 dup (0A6h)
		db	13 dup (5Fh)
		db	 60h, 60h, 60h, 60h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A6h,0A6h,0A6h,0A5h
		db	0A5h
		db	7 dup (0A6h)
		db	0A5h,0A5h
		db	9 dup (0A6h)
		db	0A7h,0A7h,0A6h,0A6h
		db	10 dup (0AAh)
		db	8 dup (5Fh)
		db	 60h, 60h, 60h, 60h, 60h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A6h,0A6h
		db	0A6h,0A6h,0A5h,0A5h,0A5h,0A6h
		db	0A5h,0A5h,0A5h,0A5h,0A8h,0A8h
		db	0A8h,0A8h,0A8h,0A8h
		db	19 dup (0A6h)
		db	0FFh
		db	'``___`````'
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A6h
		db	0A5h,0A5h,0A5h,0A5h,0A5h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A5h
		db	0A5h,0A5h,0A5h,0A6h,0A6h,0A6h
		db	0A6h,0A6h
		db	10 dup (0A9h)
		db	11 dup (0A6h)
		db	7 dup (60h)
		db	 5Fh, 5Fh, 60h, 60h, 60h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A5h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A4h
		db	14 dup (0AAh)
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A6h
		db	 60h, 60h, 60h
		db	9 dup (5Fh)
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A6h,0A6h,0A6h
		db	0A6h,0A6h, 60h, 60h, 60h,0A4h
		db	0A4h,0A4h,0A4h
		db	11 dup (60h)
		db	0A8h,0A8h,0A8h,0A4h,0A4h
		db	 60h, 60h, 60h
		db	12 dup (5Fh)
		db	14 dup (0A7h)
		db	0A5h,0A5h,0A6h,0A6h,0A6h,0A6h
		db	0A6h
		db	'`````___`'
		db	0A4h,0A4h,0A4h,0A3h,0A3h,0A3h
		db	 60h
		db	7 dup (5Fh)
		db	 60h,0A8h,0A4h,0A3h,0A4h,0A3h
		db	0A3h,0A3h
		db	60h
		db	'___________`````````````````````'
		db	'_________`'
		db	0A4h,0A3h,0A3h,0A3h,0A3h, 60h
		db	 5Fh
		db	7 dup (5Fh)
		db	 60h, 60h,0A3h,0A3h,0A3h,0A3h
		db	0A3h
		db	60h
data_c_3219	db	'________________________________'
		db	'__________`````___________`````_'
		db	'___________@____________________'
		db	'_____________________________```'
		db	'`__````'
		db	0A6h,0A6h,0A6h
		db	'`_______________________________'
		db	'```````````______``'
		db	0A7h,0A7h,0A7h,0A7h, 60h, 60h
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A6h
		db	0A8h,0A6h
		db	60h
		db	27 dup (5Fh)
		db	 60h, 60h, 60h
		db	11 dup (0A6h)
		db	 60h, 60h, 5Fh, 5Fh, 60h, 60h
		db	8 dup (0A7h)
		db	7 dup (0A6h)
		db	0AAh,0AAh
		db	25 dup (5Fh)
		db	 60h, 60h,0A6h,0A6h,0A6h,0A6h
		db	9 dup (0A5h)
		db	0A6h,0A6h,0A6h, 60h, 60h,0A7h
		db	0A7h,0A7h,0A7h,0A7h,0A7h, 86h
		db	 88h,0A7h,0A6h,0A6h,0A6h,0A6h
		db	0A6h,0AAh,0AAh,0AAh,0FFh
		db	 60h, 5Fh
		db	21 dup (5Fh)
		db	 60h, 60h, 60h,0A6h,0A6h,0A6h
		db	0A5h,0A5h,0A5h,0A5h
		db	8 dup (0A6h)
		db	0A5h,0A5h,0A5h
		db	10 dup (0A7h)
		db	0A6h,0A6h,0A6h,0AAh,0AAh,0AAh
		db	0FFh
		db	 60h, 60h, 60h, 60h
		db	17 dup (5Fh)
		db	 60h, 60h, 60h, 60h, 60h,0A6h
		db	0A6h,0A6h,0A6h,0A5h,0A5h,0A5h
		db	0A6h,0A6h,0A6h
		db	7 dup (0A5h)
		db	0A6h,0A6h,0A6h,0A6h,0A5h
		db	8 dup (0A7h)
		db	0A6h,0A6h,0A6h,0AAh, 60h, 60h
		db	 60h, 60h, 60h,0FFh, 60h,0FFh
		db	13 dup (5Fh)
		db	 60h, 60h, 60h, 60h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A6h,0A6h,0A6h,0A5h
		db	0A5h
		db	7 dup (0A6h)
		db	0A5h,0A5h,0A5h,0A6h,0A6h,0A7h
		db	0A7h,0A7h
		db	9 dup (0A6h)
		db	8 dup (0AAh)
		db	8 dup (5Fh)
		db	 60h, 60h, 60h, 60h, 60h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A6h,0A6h
		db	0A6h,0A6h,0A5h,0A5h,0A5h,0A6h
		db	0A6h,0A6h,0A6h,0A8h,0A8h,0A8h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A6h,0A7h
		db	18 dup (0A6h)
		db	'___`````'
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A5h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A5h
		db	0A5h,0A5h,0A5h,0A6h,0A6h,0A6h
		db	0A6h
		db	7 dup (0A9h)
		db	13 dup (0A6h)
		db	0A5h
		db	9 dup (0A6h)
		db	 60h, 60h, 60h, 60h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A5h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A6h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A5h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A6h,0A6h,0A6h
		db	0A6h,0A6h
		db	11 dup (0AAh)
		db	0A6h,0A6h,0A6h
		db	8 dup (0A5h)
		db	10 dup (60h)
		db	 5Fh,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A6h,0A6h
		db	0A6h,0A6h,0A6h,0A6h,0A5h,0A5h
		db	0A5h,0A5h,0A5h,0A5h,0A6h,0A6h
		db	0A6h,0A6h
		db	 60h, 60h
data_c_3500	db	60h
		db	0A6h,0A4h,0A4h
		db	11 dup (60h)
		db	0A6h,0A4h,0A4h
		db	8 dup (60h)
		db	11 dup (5Fh)
		db	14 dup (0A7h)
		db	0A6h,0A6h,0A6h,0A6h,0A6h,0A6h
		db	'`````__`'
		db	0A4h,0A4h,0A4h,0A3h,0A3h,0A3h
		db	'`______`'
		db	0A4h,0A4h,0A3h,0A3h,0A3h,0A3h
		db	 5Fh, 5Fh
data_c_3557	db	'______________``````````````````'
		db	'``________`'
		db	0A4h,0A3h,0A3h,0A3h,0A3h
		db	'`_______`'
		db	0A4h,0A4h,0A3h,0A3h,0A3h
		db	'________________________________'
		db	'_____________`````_________`````'
		db	'________________'
data_c_35E5	db	18h
		db	 0Bh, 0Bh, 0Bh, 0Bh, 0Bh
		db	 46h, 46h, 46h
		db	8 dup (0Bh)
		db	 46h, 46h, 46h
		db	10 dup (0Bh)
		db	 46h,0AAh,0AAh, 46h, 0Bh, 0Bh
		db	 0Bh, 0Bh, 0Bh, 0Bh, 46h,0AAh
		db	0AAh
		db	46h
		db	11 dup (0Bh)
		db	 47h,0AAh
		db	8 dup (47h)
		db	0AAh, 47h
		db	11 dup (0Bh)
		db	14 dup (47h)
		db	10 dup (0Bh)
		db	14 dup (47h)
		db	10 dup (0Bh)
		db	'GGGGGFGGFGGGGG'
		db	11 dup (0Bh)
		db	'G GGGGGGGG G'
		db	0Bh
		db	10 dup (0Bh)
		db	 46h, 46h, 47h
		db	8 dup (20h)
		db	 47h, 46h, 46h
		db	9 dup (0Bh)

locloop_c_36AA:
		inc	si
		inc	si

locloop_c_36AC:
		inc	si
		inc	si
		inc	di
		inc	di
		inc	di
		inc	di
		inc	di
		inc	di
		inc	di
		inc	di
		inc	si
		inc	si
		inc	si
		inc	si
		or	cx,[bp+di]
		or	cx,[bp+di]
		or	cx,[bp+di]
		or	cx,[bp+di]
		inc	bp

locloop_c_36C3:
		inc	si
		or	ax,[bp+46h]
		inc	si
		loopnz	locloop_c_36AA		; Loop if zf=0, cx>0

		loopnz	locloop_c_36AC		; Loop if zf=0, cx>0

		inc	si
		inc	si
		inc	si
		or	ax,[bp+45h]
		or	cx,[bp+di]
		or	cx,[bp+di]
		or	cx,[bp+di]
		or	cx,[bp+di]
		inc	bp

locloop_c_36DB:
		inc	bp
		or	cx,[bp+di]
		inc	si
;*		loopnz	locloop_c_36C1		;*Loop if zf=0, cx>0

		db	0E0h,0E0h		;  Fixup - byte match
		loopnz	locloop_c_36C3		; Loop if zf=0, cx>0

;*		loopnz	locloop_c_36C5		;*Loop if zf=0, cx>0

		db	0E0h,0E0h		;  Fixup - byte match
		inc	si
		or	cx,[bp+di]
		inc	bp
		inc	bp
		or	cx,[bp+di]
		or	cx,[bp+di]
		pop	di
		pop	di
		pop	di
		pop	di
		or	[di+45h],ax
		or	[bx+di],cx
;*		or	ax,sp
		db	 09h,0E0h		;  Fixup - byte match
		loopnz	locloop_c_36DB		; Loop if zf=0, cx>0

		loopnz	locloop_c_3706		; Loop if zf=0, cx>0

		or	[bx+di],cx
		inc	bp
		inc	bp
		or	[bx+5Fh],bx
		pop	di
		pop	di

locloop_c_3706:
		db	'____', 9, 9, 'EE', 9, 9, 9, 9, 9
		db	9, 9, 9, 'EE', 9, 9, '________', 9
		db	'EE', 9, 'EE', 9, 9, 9, 9, 'EE', 9
		db	'EE', 9, '____'
		db	 18h,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h,0E4h,0A4h,0E4h,0E4h,0A4h
		db	0E4h,0E4h,0A4h,0E4h,0A4h,0E4h
		db	0E4h,0A4h,0E4h,0E4h,0A4h,0E4h
		db	0A4h,0E4h,0E4h,0A4h,0E4h,0E4h
		db	0A4h,0E4h, 1Ch,0A4h,0E4h,0A4h
		db	0E4h,0A4h, 1Ch,0E4h, 1Ch,0A4h
		db	0E4h,0A4h,0E4h,0A4h, 1Ch,0E4h
		db	 1Ch,0A4h,0E4h,0A4h,0E4h,0A4h
		db	 1Ch, 1Ch,0E4h, 1Ch,0A4h,0A4h
		db	0A4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0A4h,0A4h,0A4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0A4h,0A4h,0A4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h,0E4h, 1Ch,0E4h,0E4h,0A4h
		db	0E4h,0E4h,0A4h,0E4h,0E4h,0A4h
		db	0E4h,0A4h,0E4h,0E4h,0A4h,0E4h
		db	0E4h,0A4h,0E4h,0E4h, 1Ch,0E4h
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0A4h,0E4h,0A4h,0E4h,0A4h, 1Ch
		db	0E4h, 1Ch,0A4h,0E4h,0A4h,0E4h
		db	0A4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0A4h,0A4h,0A4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0A4h,0A4h,0A4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0E4h,0E4h,0A4h,0E4h,0E4h,0A4h
		db	0E4h,0E4h,0A4h,0E4h,0A4h,0E4h
		db	0E4h,0A4h,0E4h,0E4h,0A4h,0E4h
		db	0A4h,0E4h,0E4h,0A4h,0E4h,0E4h
		db	0A4h,0E4h, 1Ch,0A4h,0E4h,0A4h
		db	0E4h,0A4h, 1Ch,0E4h, 1Ch,0A4h
		db	0E4h,0A4h,0E4h,0A4h, 1Ch,0E4h
		db	 1Ch,0A4h,0E4h,0A4h,0E4h,0A4h
		db	 1Ch, 1Ch,0E4h, 1Ch,0A4h,0A4h
		db	0A4h, 1Ch,0E4h, 1Ch,0E4h, 1Ch
		db	0A4h,0A4h,0A4h, 1Ch,0E4h, 1Ch
		db	0E4h, 1Ch,0A4h,0A4h,0A4h, 1Ch
		db	0E4h,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch,0E4h, 1Ch,0E4h, 1Ch,0E4h
		db	 1Ch, 00h,0FFh
		db	47 dup (0FFh)
		db	'00000000000000000000000000000000'
		db	'0'
		db	0F6h,0F6h,0F6h,0F6h
		db	'00000000000000000000000000000000'
		db	'00000000000'
		db	0F6h,0F6h,0F7h,0F7h,0F7h,0F6h
		db	0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'00000000'
		db	0F6h,0F7h, 86h, 88h,0F8h,0F7h
		db	0F7h,0F6h
		db	8 dup (30h)
		db	0F6h,0F6h
		db	13 dup (30h)
		db	0F6h,0F6h,0F6h, 30h
		db	12 dup (30h)
		db	0F6h,0F7h,0F7h,0F8h,0F8h,0F8h
		db	0F8h,0F9h,0F9h
		db	8 dup (30h)
		db	0F7h,0F7h,0F6h, 30h
		db	9 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F6h,0F6h
		db	0F6h
		db	30h
		db	9 dup (30h)
		db	0F6h,0F6h,0F7h,0F8h,0F8h,0F8h
		db	0FBh,0FAh,0FAh
		db	10 dup (30h)
		db	0F7h,0F6h
		db	8 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F7h,0F7h
		db	0F7h,0F7h,0F6h,0F6h,0F6h
		db	30h
		db	7 dup (30h)
		db	0F6h,0F7h,0F8h,0F8h,0FCh,0FBh
		db	0FBh
		db	12 dup (30h)
		db	0F7h,0F6h,0F6h, 30h, 30h, 30h
		db	 30h, 30h, 30h, 30h,0F6h,0F7h
		db	0F7h,0F7h,0F8h,0F8h,0F8h,0F7h
		db	0F7h,0F7h,0F6h
		db	7 dup (30h)
		db	0F6h,0F6h,0F7h,0F8h,0FCh,0FCh
		db	14 dup (30h)
		db	0F7h,0F7h,0F6h,0F6h, 30h, 30h
		db	 30h, 30h,0F6h,0F6h,0F6h,0F7h
		db	0F8h,0F8h,0FDh,0FDh,0FDh,0F8h
		db	0F8h,0F7h,0F6h,0F6h,0F6h, 30h
		db	 30h, 30h, 30h, 30h,0F6h,0F7h
		db	0F7h,0F8h,0FCh
		db	15 dup (30h)
		db	0F8h,0F7h,0F7h,0F6h,0F6h,0F6h
		db	0F6h,0F6h,0F6h,0F7h,0F7h,0F8h
		db	0FDh,0FDh, 30h, 30h, 30h,0FDh
		db	0FDh,0F8h,0F7h,0F7h
		db	7 dup (0F6h)
		db	0F7h,0F8h,0FDh,0FDh
		db	16 dup (30h)
		db	0F8h
		db	7 dup (0F7h)
		db	0F8h,0F8h,0FDh
		db	7 dup (30h)
		db	0FDh,0F8h,0F8h
		db	7 dup (0F7h)
		db	0F8h,0F8h,0FDh
		db	17 dup (30h)
		db	8 dup (0F8h)
		db	0FCh,0FDh
		db	9 dup (30h)
		db	0FDh,0FDh
		db	7 dup (0F8h)
		db	0FDh,0FDh
		db	19 dup (30h)
		db	0F9h,0F9h,0FAh,0FAh,0FBh,0FBh
		db	0FCh
		db	13 dup (30h)
		db	7 dup (0FDh)
		db	18 dup (30h)
		db	96 dup (0FFh)
		db	'00000000000000000000000000000000'
		db	'000000000'
		db	0F6h,0F6h,0F6h,0F6h
		db	'00000000000000000000000000000000'
		db	'00000000000'
		db	0F6h,0F6h,0F7h,0F7h,0F7h,0F6h
		db	0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'0000000'
		db	0F6h,0F6h,0F7h, 86h, 88h,0F8h
		db	0F7h,0F7h,0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'00000'
		db	0F6h,0F6h,0F7h,0F8h,0F8h,0F8h
		db	0F8h,0F8h,0F9h,0F9h
		db	'00000000000000000000000000000000'
		db	'0000'
		db	0F6h,0F6h,0F6h,0F7h,0F8h,0F8h
		db	0FBh,0FBh,0FBh,0FAh,0FAh, 30h
		db	0F6h,0F6h
		db	30h
		db	31 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F7h,0FCh
		db	0FCh,0FBh,0FBh, 30h, 30h, 30h
		db	 30h, 30h,0F7h,0F7h,0F6h,0F6h
		db	0F6h
		db	27 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F7h,0FDh
		db	0FDh,0FDh
		db	9 dup (30h)
		db	0F8h,0F7h,0F7h,0F7h,0F6h,0F6h
		db	0F6h,0F6h
		db	30h
		db	18 dup (30h)
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F7h,0FDh,0FDh,0FDh
		db	12 dup (30h)
		db	0F8h,0F8h,0F8h,0F7h,0F7h,0F7h
		db	0F7h
		db	20 dup (0F6h)
		db	0F7h,0F7h,0F7h,0F8h,0F8h,0FDh
		db	0FDh
		db	16 dup (30h)
		db	0F9h,0F9h,0F8h,0F8h,0F8h
		db	21 dup (0F7h)
		db	0F8h,0F8h,0FDh,0FDh,0FDh
		db	19 dup (30h)
		db	0F9h,0F9h,0F9h
		db	22 dup (0F8h)
		db	0FDh,0FDh
		db	23 dup (30h)
		db	0F9h,0F9h,0FAh,0FAh,0FBh,0FBh
		db	0FCh,0FCh
		db	15 dup (0FDh)
		db	17 dup (30h)
		db	48 dup (0FFh)
data_c_3DC8	db	0FFh
		db	47 dup (0FFh)
		db	11 dup (30h)
		db	0F6h,0F6h,0F6h,0F6h
		db	'00000000000000000000000000000000'
		db	'0000000000'
		db	0F6h,0F6h,0F7h,0F7h,0F7h,0F6h
		db	0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'0000000'
		db	0F6h,0F7h,0F7h,0F8h, 88h, 86h
		db	0F7h,0F6h
		db	'00000000000000000000000000000000'
		db	'00000000'
		db	0F9h,0F9h,0F8h,0F8h,0F8h,0F8h
		db	0F7h,0F7h,0F6h
		db	30h
		db	12 dup (30h)
		db	0F6h,0F6h,0F6h, 30h
		db	12 dup (30h)
		db	0F6h,0F6h
		db	9 dup (30h)
		db	0FAh,0FAh,0FBh,0F8h,0F8h,0F8h
		db	0F7h,0F6h,0F6h
		db	30h
		db	9 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F6h,0F6h
		db	0F6h
		db	30h
		db	9 dup (30h)
		db	0F6h,0F7h,0F7h, 30h
		db	10 dup (30h)
		db	0FBh,0FBh,0FCh,0F8h,0F8h,0F7h
		db	0F6h
		db	8 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F7h,0F7h
		db	0F7h,0F7h,0F6h,0F6h,0F6h
		db	30h
		db	7 dup (30h)
		db	0F6h,0F7h
		db	14 dup (30h)
		db	0FCh,0FCh,0F8h,0F7h,0F6h,0F6h
		db	 30h, 30h, 30h, 30h, 30h, 30h
		db	 30h,0F6h,0F7h,0F7h,0F7h,0F8h
		db	0F8h,0F8h,0F7h,0F7h,0F7h,0F6h
		db	7 dup (30h)
		db	0F6h,0F6h,0F7h, 30h
		db	14 dup (30h)
		db	0FCh,0F8h,0F7h,0F7h,0F6h, 30h
		db	 30h, 30h, 30h, 30h,0F6h,0F6h
		db	0F6h,0F7h,0F8h,0F8h,0FDh,0FDh
		db	0FDh,0F8h,0F8h,0F7h,0F6h,0F6h
		db	0F6h, 30h, 30h, 30h, 30h,0F6h
		db	0F6h,0F7h,0F7h
		db	15 dup (30h)
		db	0FDh,0FDh,0F8h,0F7h,0F6h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F6h,0F7h
		db	0F7h,0F8h,0FDh,0FDh, 30h, 30h
		db	 30h,0FDh,0FDh,0F8h,0F7h,0F7h
		db	0F6h,0F6h,0F6h,0F6h,0F6h,0F6h
		db	0F7h,0F7h,0F8h
		db	16 dup (30h)
		db	0FDh,0F8h,0F8h
		db	7 dup (0F7h)
		db	0F8h,0F8h,0FDh
		db	7 dup (30h)
		db	0FDh,0F8h,0F8h
		db	7 dup (0F7h)
		db	0F8h
		db	18 dup (30h)
		db	0FDh,0FDh
		db	7 dup (0F8h)
		db	0FDh,0FDh
		db	9 dup (30h)
		db	0FDh,0FCh
		db	8 dup (0F8h)
		db	20 dup (30h)
		db	7 dup (0FDh)
		db	13 dup (30h)
		db	0FCh,0FBh,0FBh,0FAh,0FAh,0F9h
		db	0F9h, 30h, 30h, 30h,0FFh
		db	95 dup (0FFh)
		db	 30h, 30h, 30h,0F6h,0F6h,0F6h
		db	0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'000000000'
		db	0F6h,0F6h,0F7h,0F7h,0F7h,0F6h
		db	0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'0000000'
		db	0F6h,0F7h,0F7h,0F8h, 88h, 86h
		db	0F7h,0F6h,0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'000000'
		db	0F9h,0F9h,0F8h,0F8h,0F8h,0F8h
		db	0F8h,0F7h,0F6h,0F6h
		db	30h
		db	'00000000000000000000000000000000'
		db	'000000'
		db	0FAh,0FAh,0FBh,0FBh,0FBh,0F8h
		db	0F8h,0F7h,0F6h,0F6h,0F6h
		db	'00000000000000000000000000000000'
		db	'000000000'
		db	0FBh,0FBh,0FCh,0FCh,0F7h,0F7h
		db	0F6h,0F6h,0F6h
		db	30h
		db	31 dup (30h)
		db	0F6h,0F6h
		db	8 dup (30h)
		db	0FDh,0FDh,0FDh,0F7h,0F7h,0F6h
		db	0F6h,0F6h
		db	30h
		db	26 dup (30h)
		db	0F6h,0F6h,0F6h,0F7h,0F7h, 30h
		db	9 dup (30h)
		db	0FDh,0FDh,0FDh,0F7h,0F7h,0F7h
		db	0F6h,0F6h,0F6h,0F6h
		db	30h
		db	18 dup (30h)
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F7h,0F8h
		db	13 dup (30h)
		db	0FDh,0FDh,0F8h,0F8h,0F7h,0F7h
		db	0F7h,0F6h
		db	19 dup (0F6h)
		db	0F7h,0F7h,0F7h,0F7h,0F8h,0F8h
		db	0F8h
		db	15 dup (30h)
		db	0FDh,0FDh,0FDh,0F8h,0F8h
		db	21 dup (0F7h)
		db	0F8h,0F8h,0F8h,0F9h,0F9h
		db	19 dup (30h)
		db	0FDh,0FDh
		db	22 dup (0F8h)
		db	0F9h,0F9h,0F9h
		db	23 dup (30h)
		db	15 dup (0FDh)
		db	0FCh,0FCh,0FBh,0FBh,0FAh,0FAh
		db	0F9h,0F9h
		db	8 dup (30h)
		db	48 dup (0FFh)
data_c_4308	db	0FFh
		db	22 dup (0FFh)
		db	0, 0
		db	8 dup (0FFh)
		db	 00h,0FFh, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	0FFh, 00h,0FFh,0FFh, 00h, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h
		db	7 dup (0)
		db	9 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	7 dup (0FFh)
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh, 00h,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h
		db	8 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	32 dup (0FFh)
data_c_43E8	dw	11 dup (0)
		db	 00h, 45h, 45h
		db	8 dup (0)
		db	 45h, 00h, 45h, 00h, 00h, 45h
		db	 46h, 46h, 45h, 00h, 00h, 45h
		db	 00h, 45h, 00h, 00h, 45h, 46h
		db	 45h, 00h, 45h,0AAh, 46h, 46h
		db	0AAh, 45h, 00h, 45h, 46h, 45h
		db	 00h, 00h, 00h, 45h, 00h, 00h
		db	 45h, 46h, 46h, 46h, 46h, 45h
		db	 00h, 00h, 45h, 00h, 00h, 00h
		db	 00h, 00h, 46h, 00h, 46h, 46h
		db	 47h, 47h, 46h, 46h, 00h, 46h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	'FFGGGGFF'
		db	9 dup (0)
		db	 46h, 47h, 47h, 47h, 47h, 46h
		db	8 dup (0)
		db	'FFFGGGGFFF'
		db	0, 0, 0, 0, 0, 0
		db	'EFFFGGFFFE'
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 45h, 00h, 46h, 46h, 46h, 46h
		db	 46h, 46h, 00h, 45h, 00h, 00h
		db	 00h, 00h
		db	 45h, 45h, 45h
		db	8 dup (0)
		db	 45h, 45h, 45h
		db	33 dup (0)
		db	33 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	7 dup (0FFh)
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0FFh, 00h,0FFh
		db	0FFh,0FFh,0FFh
data_c_4509	db	0FFh			; Data table (indexed access)
data_c_450A	db	0FFh			; Data table (indexed access)
		db	0
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	9 dup (0)
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	8 dup (0FFh)
		db	8 dup (0)
		db	7 dup (0FFh)
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FFh, 00h,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh, 00h
		db	 00h, 00h,0FFh,0FFh, 00h,0FFh
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h,0FFh,0FFh, 00h,0FFh, 00h
		db	8 dup (0FFh)
		db	0, 0
		db	23 dup (0FFh)
		db	33 dup (0)
		db	 45h, 45h, 45h
		db	8 dup (0)
		db	 45h, 45h, 45h, 00h, 00h, 00h
		db	 00h, 45h, 00h, 46h, 46h, 46h
		db	 46h, 46h, 46h, 00h, 45h, 00h
		db	 00h, 00h, 00h, 00h, 00h
		db	'EFFFGGFFFE'
		db	0, 0, 0, 0, 0, 0
		db	'FFFGGGGFFF'
		db	8 dup (0)		; Data table (indexed access)
		db	 46h, 47h, 47h, 47h, 47h, 46h
		db	9 dup (0)
		db	'FFGGGGFF'
		db	7 dup (0)
		db	 46h, 00h, 46h, 46h, 47h, 47h
		db	 46h, 46h, 00h, 46h, 00h, 00h
		db	 00h, 00h, 00h, 45h, 00h, 00h
		db	 45h, 46h, 46h, 46h, 46h, 45h
		db	 00h, 00h, 45h, 00h, 00h, 00h
		db	 45h, 46h, 45h, 00h, 45h,0AAh
		db	 46h, 46h,0AAh, 45h, 00h, 45h
		db	 46h, 45h, 00h, 00h, 45h, 00h
		db	 45h, 00h, 00h, 45h, 46h, 46h
		db	 45h, 00h, 00h, 45h, 00h, 45h
		db	 00h
		db	7 dup (0)
		db	 45h, 45h
		db	23 dup (0)
		db	0FFh,0FFh, 00h
		db	8 dup (0FFh)
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h
		db	7 dup (0FFh)
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h,0FFh, 00h
		db	 00h,0FFh
		db	7 dup (0FFh)
		db	 00h, 00h,0FFh, 00h
		db	11 dup (0FFh)
		db	8 dup (0)
		db	7 dup (0FFh)
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	9 dup (0)
		db	7 dup (0FFh)
		db	8 dup (0)
		db	9 dup (0FFh)
		db	 00h, 00h,0FFh, 00h
		db	9 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0FFh, 00h,0FFh, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h
		db	7 dup (0FFh)
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h
		db	8 dup (0FFh)
		db	 00h, 00h,0FFh,0FFh,0FFh, 00h
		db	 00h, 45h, 00h
		db	7 dup (0)
		db	 45h, 45h, 00h, 00h, 00h, 00h
		db	 00h, 45h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 45h, 46h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 45h
		db	 45h, 45h, 45h, 00h, 00h, 00h
		db	 46h, 00h
		db	 45h, 45h
		db	8 dup (0)
		db	 46h, 46h, 00h, 46h, 00h
		db	10 dup (0)
		db	'FFFFFFEE'
		db	7 dup (0)
		db	'FFFGGGFF'
		db	0AAh, 45h, 00h, 00h, 00h, 00h
		db	 00h, 00h
		db	'FFGGGGGFFFE'
		db	0, 0, 0, 0, 0
		db	'FFGGGGGFFFE'
		db	0, 0, 0, 0, 0
		db	'FFFGGGFF'
		db	0AAh, 45h
		db	7 dup (0)
		db	'FFFFFFEE'
		db	9 dup (0)
		db	 46h, 46h, 00h, 46h, 00h
		db	8 dup (0)
		db	 45h, 45h, 45h, 45h, 00h, 00h
		db	 00h, 46h, 00h, 45h, 45h, 00h
		db	 00h, 00h, 00h, 00h, 45h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 45h, 46h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 45h, 00h
		db	7 dup (0)
		db	 45h, 45h, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh, 00h, 00h,0FFh
		db	7 dup (0FFh)
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh
		db	8 dup (0FFh)
		db	 00h,0FFh, 00h, 00h
		db	9 dup (0FFh)
		db	8 dup (0)
		db	7 dup (0FFh)
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	9 dup (0)
		db	7 dup (0FFh)
		db	8 dup (0)
		db	11 dup (0FFh)
		db	 00h,0FFh, 00h, 00h
		db	8 dup (0FFh)
		db	 00h, 00h,0FFh, 00h,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h,0FFh
		db	7 dup (0FFh)
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 45h, 45h
		db	8 dup (0)
		db	 45h, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	 46h, 45h
		db	7 dup (0)
		db	 45h, 00h, 00h, 00h, 00h, 00h
		db	 45h, 45h, 00h, 46h, 00h, 00h
		db	 00h
		db	 45h, 45h, 45h, 45h
		db	9 dup (0)
		db	 46h, 00h, 46h, 46h
		db	9 dup (0)
		db	'EEFFFFFF'
		db	7 dup (0)
		db	 45h,0AAh
		db	'FFGGGFFF'
		db	0, 0, 0, 0, 0
		db	'EFFFGGGGGFF'
		db	0, 0, 0, 0, 0
		db	'EFFFGGGGGFF'
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 45h,0AAh
		db	'FFGGGFFF'
		db	7 dup (0)
		db	'EEFFFFFF'
		db	11 dup (0)
		db	 46h, 00h, 46h, 46h
		db	8 dup (0)
		db	 45h, 45h, 00h, 46h, 00h, 00h
		db	 00h, 45h, 45h, 45h, 45h, 00h
		db	 00h, 00h, 00h, 00h, 00h
		db	 46h, 45h
		db	7 dup (0)
		db	 45h, 00h, 00h, 00h, 00h, 00h
		db	 45h, 45h
		db	8 dup (0)
		db	45h
		db	0, 0
data_c_4A08	db	0
		db	22 dup (0)
		db	0F0h,0F0h
		db	8 dup (0)
		db	0F0h, 00h,0F0h, 00h, 00h,0F0h
		db	0F1h,0F1h,0F0h, 00h, 00h,0F0h
		db	 00h,0F0h, 00h, 00h,0F0h,0F1h
		db	0F0h, 00h,0F0h,0AAh,0F1h,0F1h
		db	0AAh,0F0h, 00h,0F0h,0F1h,0F0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	0F0h,0F1h,0F1h,0F1h,0F1h,0F0h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h,0F1h, 00h,0F1h,0F1h
		db	0F2h,0F2h,0F1h,0F1h, 00h,0F1h
		db	7 dup (0)
		db	0F1h,0F1h,0F2h,0F2h,0F2h,0F2h
		db	0F1h,0F1h
		db	9 dup (0)
		db	0F1h,0F2h,0F2h,0F2h,0F2h,0F1h
		db	8 dup (0)
		db	0F1h,0F1h,0F1h,0F2h,0F2h,0F2h
		db	0F2h,0F1h,0F1h,0F1h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0F0h,0F1h
		db	0F1h,0F1h,0F2h,0F2h,0F1h,0F1h
		db	0F1h,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h,0F1h,0F1h
		db	0F1h,0F1h,0F1h,0F1h, 00h,0F0h
		db	 00h, 00h, 00h, 00h,0F0h,0F0h
		db	0F0h
		db	8 dup (0)
		db	0F0h,0F0h,0F0h
		db	33 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	8 dup (0FFh)
		db	8 dup (0)
		db	7 dup (0FFh)
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	9 dup (0)
		db	7 dup (0FFh)
		db	8 dup (0)
		db	8 dup (0FFh)
		db	8 dup (0)
		db	8 dup (0FFh)
		db	8 dup (0)
		db	9 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh
		db	7 dup (0FFh)
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h
		db	11 dup (0FFh)
		db	0, 0
		db	11 dup (0FFh)
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h,0FFh
		db	7 dup (0FFh)
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0A4h,0A4h,0A4h
		db	0A4h,0A4h,0A4h
		db	9 dup (0)
		db	0A4h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	0A2h,0A4h
		db	7 dup (0)
		db	0A4h,0A2h, 00h, 00h,0A0h,0A0h
		db	 00h, 00h,0A2h,0A4h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A4h,0A2h
		db	0A0h,0A0h,0A0h,0A0h,0A0h,0A0h
		db	0A2h,0A4h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0A4h,0A2h,0A0h,0A0h
		db	0A0h,0A0h,0A0h,0A0h,0A2h,0A4h
		db	7 dup (0)
		db	0A4h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	0A2h,0A4h
		db	8 dup (0)
		db	0A4h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0A4h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A4h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A4h
		db	 00h
		db	8 dup (0)
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	7 dup (0)
		db	0DFh,0DFh
		db	8 dup (0)
		db	0DFh,0DFh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0DEh,0DEh,0DEh, 00h
		db	 00h,0DEh,0DEh,0DEh
		db	11 dup (0)
		db	0DDh,0DDh, 00h, 00h
		db	9 dup (0)
		db	0DEh,0DEh,0DEh, 00h, 00h,0DEh
		db	0DEh,0DEh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0DFh,0DFh
		db	8 dup (0)
		db	0DFh,0DFh, 00h, 00h

; 2nd intro image
data_c_4CA8	db	0Bh
		db	 0Fh, 9Eh, 01h, 9Fh, 02h, 9Eh
		db	 04h, 0Bh, 19h, 9Eh, 01h, 9Fh
		db	 02h, 9Eh, 01h, 0Bh, 01h, 9Eh
		db	 01h, 0Bh,0D7h, 9Eh, 03h, 9Fh
		db	 02h, 9Eh, 01h, 0Bh, 19h, 9Eh
		db	 04h, 9Fh, 02h, 9Eh, 01h, 0Bh
		db	 1Eh, 9Eh, 01h, 9Fh, 02h, 9Eh
		db	 04h, 0Bh, 18h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 03h, 0Bh, 0Ah, 20h
		db	 10h, 0Bh, 10h, 20h, 1Ch, 0Bh
		db	 0Ch, 20h, 08h, 0Bh, 10h, 20h
		db	 18h, 0Bh, 08h, 20h, 1Ch, 0Bh
		db	 04h, 20h, 18h, 0Bh, 14h, 9Eh
		db	 03h, 9Fh, 02h, 9Eh, 01h, 0Bh
		db	 19h, 9Eh, 04h, 9Fh, 02h, 9Eh
		db	 01h, 0Bh, 1Eh, 9Eh, 01h, 9Fh
		db	 02h, 9Eh, 04h, 0Bh, 19h, 9Eh
		db	 01h, 9Fh, 02h, 9Eh, 03h, 0Bh
		db	 0Ah, 20h, 10h, 0Bh, 10h, 20h
		db	 1Ch, 0Bh, 0Ch, 20h, 08h, 0Bh
		db	 10h, 20h, 18h, 0Bh, 08h, 20h
		db	 1Ch, 0Bh, 04h, 20h, 18h, 0Bh
		db	 13h, 9Eh, 04h, 9Fh, 02h, 9Eh
		db	 01h, 0Bh, 18h, 9Eh, 04h, 9Fh
		db	 03h, 9Eh, 01h, 0Bh, 1Eh, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 04h, 0Bh
		db	 18h, 9Eh, 01h, 9Fh, 02h, 9Eh
		db	 03h, 0Bh, 0Ah, 21h, 10h, 0Bh
		db	 10h, 21h, 1Ch, 0Bh, 0Ch, 21h
		db	 08h, 0Bh, 10h, 21h, 18h, 0Bh
		db	 08h, 21h, 1Ch, 0Bh, 04h, 21h
		db	 18h, 0Bh, 13h, 9Eh, 03h, 9Fh
		db	 03h, 9Eh, 01h, 0Bh, 18h, 9Eh
		db	 04h, 9Fh, 02h, 9Eh, 01h, 0Bh
		db	 20h, 9Eh, 01h, 9Fh, 02h, 9Eh
		db	 04h, 0Bh, 18h, 9Eh, 01h, 9Fh
		db	 02h, 9Eh, 04h, 0Bh, 09h, 21h
		db	 10h, 0Bh, 10h, 21h, 1Ch, 0Bh
		db	 0Ch, 21h, 08h, 0Bh, 10h, 21h
		db	 18h, 0Bh, 08h, 21h, 1Ch, 0Bh
		db	 04h, 21h, 18h, 0Bh, 13h, 9Eh
		db	 03h, 9Fh, 02h, 9Eh, 01h, 0Bh
		db	 18h, 9Eh, 05h, 9Fh, 02h, 9Eh
		db	 01h, 0Bh, 20h, 9Eh, 01h, 9Fh
		db	 02h, 9Eh, 05h, 0Bh, 17h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 03h, 0Bh
		db	 0Dh, 22h, 08h, 0Bh, 18h, 22h
		db	 08h, 0Bh, 0Ch, 22h, 04h, 0Bh
		db	 08h, 22h, 10h, 0Bh, 10h, 22h
		db	 08h, 0Bh, 08h, 22h, 08h, 0Bh
		db	 08h, 22h, 08h, 0Bh, 0Ch, 22h
		db	 04h, 0Bh, 08h, 22h, 08h, 0Bh
		db	 08h, 22h, 08h, 0Bh, 0Eh, 9Eh
		db	 04h, 9Fh, 02h, 9Eh, 01h, 0Bh
		db	 18h, 9Eh, 04h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 20h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 04h, 0Bh, 18h, 9Eh
		db	 01h, 9Fh, 02h, 9Eh, 04h, 0Bh
		db	 0Ch, 22h, 08h, 0Bh, 18h, 22h
		db	 08h, 0Bh, 0Ch, 22h, 04h, 0Bh
		db	 08h, 22h, 10h, 0Bh, 10h, 22h
		db	 08h, 0Bh, 08h, 22h, 08h, 0Bh
		db	 08h, 22h, 08h, 0Bh, 0Ch, 22h
		db	 04h, 0Bh, 08h, 22h, 08h, 0Bh
		db	 08h, 22h, 08h, 0Bh, 0Eh, 9Eh
		db	 03h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 17h, 9Eh, 05h, 9Fh, 02h, 9Eh
		db	 01h, 0Bh, 22h, 9Eh, 01h, 9Fh
		db	 02h, 9Eh, 05h, 0Bh, 17h, 9Eh
		db	 01h, 9Fh, 02h, 9Eh, 04h, 0Bh
		db	 0Ch, 23h, 08h, 0Bh, 18h, 23h
		db	 08h, 0Bh, 0Ch, 23h, 04h, 0Bh
		db	 08h, 23h, 10h, 0Bh, 10h, 23h
		db	 08h, 0Bh, 08h, 23h, 08h, 0Bh
		db	 08h, 23h, 08h, 0Bh, 0Ch, 23h
		db	 04h, 0Bh, 08h, 23h, 08h, 0Bh
		db	 08h, 23h, 08h, 0Bh, 0Dh, 9Eh
		db	 04h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 17h, 9Eh, 04h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 22h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 04h, 0Bh, 17h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 04h, 0Bh
		db	 0Bh, 23h, 08h, 0Bh, 18h, 23h
		db	 08h, 0Bh, 0Ch, 23h, 04h, 0Bh
		db	 08h, 23h, 10h, 0Bh, 10h, 23h
		db	 08h, 0Bh, 08h, 23h, 08h, 0Bh
		db	 08h, 23h, 08h, 0Bh, 0Ch, 23h
		db	 04h, 0Bh, 08h, 23h, 08h, 0Bh
		db	 08h, 23h, 08h, 0Bh, 0Dh, 9Eh
		db	 04h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 16h, 9Eh, 05h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 22h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 05h, 0Bh, 16h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 04h, 0Bh
		db	 0Bh, 24h, 08h, 0Bh, 18h, 24h
		db	 08h, 0Bh, 04h, 24h, 04h, 0Bh
		db	 0Ch, 24h, 08h, 0Bh, 08h, 24h
		db	 08h, 0Bh, 0Ch, 24h, 08h, 0Bh
		db	 08h, 24h, 08h, 0Bh, 08h, 24h
		db	 08h, 0Bh, 04h, 24h, 04h, 0Bh
		db	 10h, 24h, 08h, 0Bh, 08h, 24h
		db	 08h, 0Bh, 0Dh, 9Eh, 04h, 9Fh
		db	 02h, 9Eh, 01h, 0Bh, 17h, 9Eh
		db	 05h, 9Fh, 02h, 9Eh, 01h, 0Bh
		db	 24h, 9Eh, 01h, 9Fh, 02h, 9Eh
		db	 05h, 0Bh, 16h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 04h, 0Bh, 0Bh, 24h
		db	 08h, 0Bh, 18h, 24h, 08h, 0Bh
		db	 04h, 24h, 04h, 0Bh, 0Ch, 24h
		db	 08h, 0Bh, 08h, 24h, 08h, 0Bh
		db	 0Ch, 24h, 08h, 0Bh, 08h, 24h
		db	 08h, 0Bh, 08h, 24h, 08h, 0Bh
		db	 04h, 24h, 04h, 0Bh, 10h, 24h
		db	 08h, 0Bh, 08h, 24h, 08h, 0Bh
		db	 0Ch, 9Eh, 04h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 16h, 9Eh, 05h, 9Fh
		db	 03h, 9Eh, 01h, 0Bh, 24h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 05h, 0Bh
		db	 16h, 9Eh, 01h, 9Fh, 03h, 9Eh
		db	 04h, 0Bh, 0Ah, 25h, 08h, 0Bh
		db	 18h, 25h, 08h, 0Bh, 04h, 25h
		db	 04h, 0Bh, 0Ch, 25h, 08h, 0Bh
		db	 08h, 25h, 08h, 0Bh, 0Ch, 25h
		db	 08h, 0Bh, 08h, 25h, 08h, 0Bh
		db	 08h, 25h, 08h, 0Bh, 04h, 25h
		db	 04h, 0Bh, 10h, 25h, 08h, 0Bh
		db	 08h, 25h, 08h, 0Bh, 0Ch, 9Eh
		db	 04h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 16h, 9Eh, 05h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 24h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 05h, 0Bh, 16h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 04h, 0Bh
		db	 0Ah, 25h, 08h, 0Bh, 18h, 25h
		db	 08h, 0Bh, 04h, 25h, 04h, 0Bh
		db	 0Ch, 25h, 08h, 0Bh, 08h, 25h
		db	 08h, 0Bh, 0Ch, 25h, 08h, 0Bh
		db	 08h, 25h, 08h, 0Bh, 08h, 25h
		db	 08h, 0Bh, 04h, 25h, 04h, 0Bh
		db	 10h, 25h, 08h, 0Bh, 08h, 25h
		db	 08h, 0Bh, 0Bh, 9Eh, 05h, 9Fh
		db	 03h, 9Eh, 01h, 0Bh, 16h, 9Eh
		db	 04h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 26h, 9Eh, 01h, 9Fh, 03h, 9Eh
		db	 04h, 0Bh, 16h, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 05h, 0Bh, 09h, 26h
		db	 08h, 0Bh, 18h, 26h, 10h, 0Bh
		db	 0Ch, 26h, 08h, 0Bh, 08h, 26h
		db	 08h, 0Bh, 0Ch, 26h, 14h, 0Bh
		db	 0Ch, 26h, 10h, 0Bh
data_c_5025	db	10h			; Data table (indexed access)
		db	 26h, 14h, 0Bh, 0Fh, 9Eh, 04h
		db	 9Fh, 03h, 9Eh, 01h, 0Bh, 16h
		db	 9Eh, 05h, 9Fh, 03h, 9Eh, 01h
		db	 0Bh, 26h, 9Eh, 01h, 9Fh, 03h
		db	 9Eh, 05h, 0Bh, 15h, 9Eh, 01h
		db	 9Fh, 04h, 9Eh, 04h, 0Bh, 09h
		db	 26h, 08h, 0Bh, 18h, 26h, 10h
		db	 0Bh, 0Ch, 26h, 08h, 0Bh, 08h
		db	 26h, 08h, 0Bh, 0Ch, 26h, 14h
		db	 0Bh, 0Ch, 26h, 10h, 0Bh, 10h
		db	 26h, 14h, 0Bh, 0Fh, 9Eh, 04h
		db	 9Fh, 03h, 9Eh, 01h, 0Bh, 16h
		db	 9Eh, 04h, 9Fh, 04h, 9Eh, 01h
		db	 0Bh, 26h, 9Eh, 01h, 9Fh, 04h
		db	 9Eh, 04h, 0Bh, 16h, 9Eh, 01h
		db	 9Fh, 03h, 9Eh, 04h, 0Bh, 09h
		db	 27h, 08h, 0Bh, 18h, 27h, 10h
		db	 0Bh, 0Ch, 27h, 08h, 0Bh, 08h
		db	 27h, 08h, 0Bh, 0Ch, 27h, 14h
		db	 0Bh, 0Ch, 27h, 10h, 0Bh, 10h
		db	 27h, 14h, 0Bh, 0Eh, 9Eh, 05h
		db	 9Fh, 03h, 9Eh, 01h, 0Bh, 15h
		db	 9Eh, 05h, 9Fh, 03h, 9Eh, 01h
		db	 0Bh, 28h, 9Eh, 01h, 9Fh, 03h
		db	 9Eh, 05h, 0Bh, 15h, 9Eh, 01h
		db	 9Fh, 03h, 9Eh, 05h, 0Bh, 08h
		db	 27h, 08h, 0Bh, 18h, 27h, 10h
		db	 0Bh, 0Ch, 27h, 08h, 0Bh, 08h
		db	 27h, 08h, 0Bh, 0Ch, 27h, 14h
		db	 0Bh, 0Ch, 27h, 10h, 0Bh, 10h
		db	 27h, 14h, 0Bh, 0Eh, 9Eh, 04h
		db	 9Fh, 04h, 9Eh, 01h, 0Bh, 15h
		db	 9Eh, 05h, 9Fh, 03h, 9Eh, 01h
		db	 0Bh, 28h, 9Eh, 01h
data_c_50F0	db	9Fh
		db	 03h, 9Eh, 05h, 0Bh, 15h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 05h, 0Bh
		db	 08h, 28h, 08h, 0Bh, 0Ch, 28h
		db	 04h, 0Bh, 08h, 28h, 08h, 0Bh
		db	 04h, 28h, 04h, 0Bh, 0Ch, 28h
		db	 18h, 0Bh, 0Ch, 28h, 08h, 0Bh
		db	 18h, 28h, 08h, 0Bh, 04h, 28h
		db	 04h, 0Bh, 10h, 28h, 08h, 0Bh
		db	 04h, 28h, 08h, 0Bh, 0Dh, 9Eh
		db	 05h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 14h, 9Eh, 05h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 28h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 05h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 05h, 0Bh
		db	 07h, 28h, 08h, 0Bh, 0Ch, 28h
		db	 04h, 0Bh, 08h, 28h, 08h, 0Bh
		db	 04h, 28h, 04h, 0Bh, 0Ch, 28h
		db	 18h, 0Bh, 0Ch, 28h, 08h, 0Bh
		db	 18h, 28h, 08h, 0Bh, 04h, 28h
		db	 04h, 0Bh, 10h, 28h, 08h, 0Bh
		db	 04h, 28h, 08h, 0Bh, 0Dh, 9Eh
		db	 05h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 15h, 9Eh, 05h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 2Ah, 9Eh, 01h, 9Fh
		db	 03h, 9Eh, 05h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 05h, 0Bh
		db	 07h, 29h, 08h, 0Bh, 0Ch, 29h
		db	 04h, 0Bh, 08h, 29h, 08h, 0Bh
		db	 04h, 29h, 04h, 0Bh, 0Ch, 29h
		db	 18h, 0Bh, 0Ch, 29h, 08h, 0Bh
		db	 18h, 29h, 08h, 0Bh, 04h, 29h
		db	 04h, 0Bh, 10h, 29h, 08h, 0Bh
		db	 04h, 29h, 08h, 0Bh, 0Ch, 9Eh
		db	 05h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 14h, 9Eh, 05h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 2Ah, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 05h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 03h, 9Eh, 05h, 0Bh
		db	 07h, 29h, 08h, 0Bh, 0Ch, 29h
		db	 04h, 0Bh, 08h, 29h, 08h, 0Bh
		db	 04h, 29h, 04h, 0Bh, 0Ch, 29h
		db	 18h, 0Bh, 0Ch, 29h, 08h, 0Bh
		db	 18h, 29h, 08h, 0Bh, 04h, 29h
		db	 04h, 0Bh, 10h, 29h, 08h, 0Bh
		db	 04h, 29h, 08h, 0Bh, 0Ch, 9Eh
		db	 05h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 14h, 9Eh, 05h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 2Ah, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 05h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 05h, 0Bh
		db	 06h, 2Ah, 08h, 0Bh, 08h, 2Ah
		db	 08h, 0Bh, 08h, 2Ah, 08h, 0Bh
		db	 0Ch, 2Ah, 04h, 0Bh, 04h, 2Ah
		db	 08h, 0Bh, 08h, 2Ah, 08h, 0Bh
		db	 0Ch, 2Ah, 08h, 0Bh, 18h, 2Ah
		db	 08h, 0Bh, 0Ch, 2Ah, 04h, 0Bh
		db	 08h, 2Ah, 08h, 0Bh, 08h, 2Ah
		db	 08h, 0Bh, 08h, 9Eh, 05h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 13h, 9Eh
		db	 06h, 9Fh, 03h, 9Eh, 01h, 0Bh
		db	 2Ch, 9Eh, 01h, 9Fh, 03h, 9Eh
		db	 06h, 0Bh, 13h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 05h, 0Bh, 06h, 2Ah
		db	 08h, 0Bh, 08h, 2Ah, 08h, 0Bh
		db	 08h, 2Ah, 08h, 0Bh, 0Ch, 2Ah
		db	 04h, 0Bh, 04h, 2Ah, 08h, 0Bh
		db	 08h, 2Ah, 08h, 0Bh, 0Ch, 2Ah
		db	 08h, 0Bh, 18h, 2Ah, 08h, 0Bh
		db	 0Ch, 2Ah, 04h, 0Bh, 08h, 2Ah
		db	 08h, 0Bh, 08h, 2Ah, 08h, 0Bh
		db	 07h, 9Eh, 06h, 9Fh, 03h, 9Eh
		db	 01h, 0Bh, 14h, 9Eh, 05h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 2Ch, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 05h, 0Bh
		db	 13h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 06h, 0Bh, 05h, 2Bh, 08h, 0Bh
		db	 08h, 2Bh, 08h, 0Bh, 08h, 2Bh
		db	 08h, 0Bh, 0Ch, 2Bh, 04h, 0Bh
		db	 04h, 2Bh, 08h, 0Bh, 08h, 2Bh
		db	 08h, 0Bh, 0Ch, 2Bh, 08h, 0Bh
		db	 18h, 2Bh, 08h, 0Bh, 0Ch, 2Bh
		db	 04h, 0Bh, 08h, 2Bh, 08h, 0Bh
		db	 08h, 2Bh, 08h, 0Bh, 07h, 9Eh
		db	 05h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 13h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 2Ch, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 06h, 0Bh, 12h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 06h, 0Bh
		db	 05h, 2Bh, 08h, 0Bh, 08h, 2Bh
		db	 08h, 0Bh, 08h, 2Bh, 08h, 0Bh
		db	 0Ch, 2Bh, 04h, 0Bh, 04h, 2Bh
		db	 08h, 0Bh, 08h, 2Bh, 08h, 0Bh
		db	 0Ch, 2Bh, 08h, 0Bh, 18h, 2Bh
		db	 08h, 0Bh, 0Ch, 2Bh, 04h, 0Bh
		db	 08h, 2Bh, 08h, 0Bh, 08h, 2Bh
		db	 08h, 0Bh, 07h, 9Eh, 05h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 13h, 9Eh
		db	 05h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 2Dh, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 06h, 0Bh, 13h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 05h, 0Bh, 01h, 2Ch
		db	 1Ch, 0Bh, 04h, 2Ch, 1Ch, 0Bh
		db	 04h, 2Ch, 08h, 0Bh, 08h, 2Ch
		db	 08h, 0Bh, 08h, 2Ch, 10h, 0Bh
		db	 10h, 2Ch, 1Ch, 0Bh, 04h, 2Ch
		db	 0Ch, 0Bh, 08h, 2Ch, 08h, 0Bh
		db	 06h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 13h, 9Eh, 05h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 2Eh, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 05h, 0Bh
		db	 13h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 05h, 0Bh, 01h, 2Ch, 1Ch, 0Bh
		db	 04h, 2Ch, 1Ch, 0Bh, 04h, 2Ch
		db	 08h, 0Bh, 08h, 2Ch, 08h, 0Bh
		db	 08h, 2Ch, 10h, 0Bh, 10h, 2Ch
		db	 1Ch, 0Bh, 04h, 2Ch, 0Ch, 0Bh
		db	 08h, 2Ch, 08h, 0Bh, 06h, 9Eh
		db	 06h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 12h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 2Eh, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 06h, 0Bh, 12h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 06h, 2Dh
		db	 1Ch, 0Bh, 04h, 2Dh, 1Ch, 0Bh
		db	 04h, 2Dh, 08h, 0Bh, 08h, 2Dh
		db	 08h, 0Bh, 08h, 2Dh, 10h, 0Bh
		db	 10h, 2Dh, 1Ch, 0Bh, 04h, 2Dh
		db	 0Ch, 0Bh, 08h, 2Dh, 08h, 0Bh
		db	 06h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 12h, 9Eh, 06h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 2Eh, 9Eh
		db	 01h, 9Fh, 04h
data_c_5400	db	9Eh
		db	 06h, 0Bh, 12h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 06h, 2Dh, 1Ch, 0Bh
		db	 04h, 2Dh, 1Ch, 0Bh, 04h, 2Dh
		db	 08h, 0Bh, 08h, 2Dh, 08h, 0Bh
		db	 08h, 2Dh, 10h, 0Bh, 10h, 2Dh
		db	 1Ch, 0Bh, 04h, 2Dh, 0Ch, 0Bh
		db	 08h, 2Dh, 08h, 0Bh, 06h, 9Eh
		db	 05h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 13h, 9Eh, 05h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 2Fh, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 06h, 0Bh, 12h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 06h, 0Bh
		db	0C1h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 12h, 9Eh, 06h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 30h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 06h, 0Bh
		db	 11h, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 05h, 0Bh,0C1h, 9Eh, 06h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 12h, 9Eh
		db	 06h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 30h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 06h, 0Bh, 11h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 06h, 0Bh,0C0h, 9Eh
		db	 06h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 12h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 30h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 06h, 0Bh, 12h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 06h, 0Bh
		db	 1Fh, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 04h, 0Ah, 04h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 0Ch, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 1Ch, 0Ah, 02h, 0Bh, 1Eh, 0Ah
		db	 02h, 0Bh, 0Dh, 0Ah, 05h, 0Bh
		db	 2Bh, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 11h, 9Eh, 06h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 30h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 07h, 0Bh
		db	 11h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 06h, 0Bh, 1Fh, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 03h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 04h, 0Bh, 0Bh, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 3Bh, 0Ah, 03h, 0Bh, 0Ch, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 29h, 9Eh, 06h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 11h, 9Eh, 06h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 31h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 06h, 0Bh
		db	 11h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 07h, 0Bh, 1Eh, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 06h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 0Ah, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 04h, 0Bh, 03h, 0Ah
		db	 02h, 0Bh, 01h, 0Ah, 03h, 0Bh
		db	 03h, 0Ah, 05h, 0Bh, 03h, 0Ah
		db	 03h, 0Bh, 05h, 0Ah, 04h, 0Bh
		db	 03h, 0Ah, 05h, 0Bh, 0Dh, 0Ah
		db	 02h, 0Bh, 0Ch, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 03h, 0Bh, 29h, 9Eh
		db	 06h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 11h, 9Eh, 06h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 32h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 06h, 0Bh, 11h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 07h, 0Bh
		db	 1Eh, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 06h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 0Ah, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 03h, 0Bh, 01h, 0Ah
		db	 02h, 0Bh, 01h, 0Ah, 02h, 0Bh
		db	 08h, 0Ah, 02h, 0Bh, 04h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 0Ch, 0Ah, 02h, 0Bh
		db	 0Ch, 0Ah, 02h, 0Bh, 01h, 0Ah
		db	 04h, 0Bh, 29h, 9Eh, 06h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 11h, 9Eh
		db	 07h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 32h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 07h, 0Bh, 10h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 06h, 0Bh, 1Eh, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 03h, 0Bh, 01h, 0Ah, 06h, 0Bh
		db	 0Ah, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 06h, 0Bh
		db	 03h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 04h, 0Bh
		db	 05h, 0Ah, 02h, 0Bh, 04h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 0Ch, 0Ah, 02h, 0Bh
		db	 0Ch, 0Ah, 04h, 0Bh, 01h, 0Ah
		db	 02h, 0Bh, 28h, 9Eh, 07h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 11h, 9Eh
		db	 06h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 18h, 9Eh, 01h, 0Bh, 19h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 07h, 0Bh
		db	 10h, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 06h, 0Bh, 1Fh, 0Ah, 04h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 01h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 0Bh, 0Ah
		db	 04h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 09h, 0Ah
		db	 02h, 0Bh, 04h, 0Ah, 02h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 0Ch, 0Ah
		db	 02h, 0Bh, 06h, 0Ah, 02h, 0Bh
		db	 04h, 0Ah, 03h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 28h, 9Eh, 07h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 11h, 9Eh
		db	 06h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 19h, 9Eh, 02h, 0Bh, 18h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 06h, 0Bh
		db	 11h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 07h, 0Bh, 1Fh, 0Ah, 02h, 0Bh
		db	 06h, 0Ah, 05h, 0Bh, 01h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 0Ch, 0Ah, 02h, 0Bh, 05h, 0Ah
		db	 04h, 0Bh, 03h, 0Ah, 04h, 0Bh
		db	 04h, 0Ah, 05h, 0Bh, 04h, 0Ah
		db	 04h, 0Bh, 04h, 0Ah, 04h, 0Bh
		db	 03h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 0Ah, 0Ah, 06h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 05h, 0Ah
		db	 05h, 0Bh, 29h, 9Eh, 07h, 9Fh
		db	 04h, 9Eh, 01h, 0Bh, 10h, 9Eh
		db	 07h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 19h, 9Eh, 02h, 0Bh, 18h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 07h, 0Bh
		db	 10h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 07h, 0Bh,0BCh, 9Eh, 06h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 10h, 9Eh
		db	 07h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 19h, 9Eh, 03h, 0Bh, 18h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 02h, 0Ah
		db	 04h, 9Eh, 01h, 0Bh, 10h, 9Eh
		db	 01h, 9Fh, 04h, 9Eh, 07h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 0Ch, 0Ah
		db	 03h, 0Bh, 08h, 0Ah, 01h, 0Bh
		db	 0Fh, 0Ah, 05h, 0Bh, 0Ah, 0Ah
		db	 02h, 0Bh, 05h, 0Ah, 04h, 0Bh
		db	 04h, 0Ah, 04h, 0Bh, 04h, 0Ah
		db	 04h, 0Bh, 13h, 0Ah, 03h, 0Bh
		db	 15h, 0Ah, 04h, 0Bh, 1Eh, 0Ah
		db	 04h, 0Bh, 02h, 0Ah, 03h, 0Bh
		db	 0Bh, 9Eh, 07h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 06h, 0Ah, 03h, 0Bh
		db	 07h, 9Eh, 06h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 18h, 9Eh, 04h, 0Bh
		db	 18h, 9Eh, 01h, 9Fh, 04h, 9Eh
		db	 01h, 0Ah, 02h, 9Eh, 02h, 0Ah
		db	 02h, 0Bh, 10h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 06h, 0Bh, 16h, 0Ah
		db	 02h, 0Bh, 07h, 0Ah, 02h, 0Bh
		db	 0Eh, 0Ah, 01h, 0Bh, 05h, 0Ah
		db	 01h, 0Bh, 08h, 0Ah, 03h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 13h, 0Ah, 02h, 0Bh, 16h, 0Ah
		db	 02h, 0Bh, 1Eh, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 0Bh, 9Eh, 07h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 07h, 0Ah
		db	 02h, 0Bh, 06h, 9Eh, 07h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 18h, 9Eh
		db	 04h, 0Bh, 18h, 9Eh, 01h, 9Fh
		db	 04h, 0Ah, 02h, 9Eh, 06h, 0Bh
		db	 01h, 0Ah, 04h, 0Bh, 03h, 0Ah
		db	 02h, 0Bh, 01h, 0Ah, 03h, 0Bh
		db	 01h, 9Eh, 01h, 0Ah, 02h, 9Fh
		db	 02h, 0Ah, 02h, 9Eh, 02h, 0Ah
		db	 02h, 9Eh, 01h, 0Ah, 03h, 0Bh
		db	 03h, 0Ah, 03h, 0Bh, 05h, 0Ah
		db	 03h, 0Bh, 01h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 01h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 05h, 0Bh
		db	 0Ah, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 03h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 04h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 06h, 0Ah, 02h, 0Bh
		db	 13h, 0Ah, 02h, 0Bh, 05h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 0Bh, 0Ah, 02h, 0Bh, 06h, 0Ah
		db	 04h, 0Bh, 04h, 0Ah, 04h, 0Bh
		db	 0Bh, 0Ah, 02h, 0Bh, 07h, 0Ah
		db	 02h, 0Bh, 01h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 04h, 0Bh, 01h, 9Eh
		db	 02h, 0Ah, 02h, 9Eh, 01h, 0Ah
		db	 03h, 9Fh, 03h, 0Ah, 04h, 0Bh
		db	 05h, 0Ah, 02h, 0Bh, 06h, 9Eh
		db	 07h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 18h, 9Eh, 06h, 0Bh, 17h, 9Eh
		db	 01h, 9Fh, 04h, 0Ah, 02h, 9Eh
		db	 06h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 9Eh, 01h, 0Ah
		db	 02h, 9Fh, 02h, 0Ah, 02h, 9Eh
		db	 03h, 0Ah, 03h, 0Bh, 01h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 03h, 0Bh
		db	 01h, 0Ah, 02h, 0Bh, 03h, 0Ah
		db	 02h, 0Bh, 0Ch, 0Ah, 01h, 0Bh
		db	 02h, 0Ah, 01h, 0Bh, 03h, 0Ah
		db	 01h, 0Bh, 02h, 0Ah, 01h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 05h, 0Ah
		db	 05h, 0Bh, 03h, 0Ah, 05h, 0Bh
		db	 04h, 0Ah, 03h, 0Bh, 14h, 0Ah
		db	 05h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 0Bh, 0Ah
		db	 02h, 0Bh, 05h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 0Ah, 0Ah, 02h, 0Bh, 07h, 0Ah
		db	 03h, 0Bh, 01h, 0Ah, 02h, 0Bh
		db	 05h, 0Ah, 02h, 9Eh, 03h, 0Ah
		db	 02h, 9Eh, 02h, 0Ah, 02h, 9Fh
		db	 01h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 04h, 0Ah, 02h, 0Bh
		db	 06h, 9Eh, 07h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 18h, 9Eh, 06h, 0Bh
		db	 17h, 9Eh, 01h, 9Fh, 04h, 0Ah
		db	 02h, 9Eh, 06h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 03h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 9Eh
		db	 01h, 0Ah, 02h, 9Fh, 02h, 0Ah
		db	 02h, 9Eh, 03h, 0Ah, 02h, 9Eh
		db	 01h, 0Bh, 01h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 02h, 0Bh, 04h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 0Ch, 0Ah, 01h, 0Bh, 02h, 0Ah
		db	 01h, 0Bh, 06h, 0Ah, 01h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 08h, 0Ah
		db	 02h, 0Bh, 06h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 02h, 0Bh, 16h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 01h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 0Bh, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 01h, 0Bh, 01h, 0Ah
		db	 06h, 0Bh, 02h, 0Ah, 06h, 0Bh
		db	 0Ah, 0Ah, 02h, 0Bh, 07h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 05h, 9Eh, 03h, 0Ah
		db	 02h, 9Eh, 01h, 9Fh, 01h, 0Ah
		db	 02h, 9Fh, 01h, 0Ah, 06h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 05h, 9Eh
		db	 07h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 17h, 9Eh, 08h, 0Bh, 17h, 9Eh
		db	 01h, 9Fh, 04h, 0Ah, 02h, 9Eh
		db	 02h, 0Ah, 02h, 9Eh, 01h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 03h, 0Ah, 05h, 0Bh, 02h, 9Eh
		db	 01h, 0Ah, 05h, 9Eh, 03h, 0Ah
		db	 02h, 9Eh, 02h, 0Bh, 05h, 0Ah
		db	 02h, 0Bh, 05h, 0Ah, 05h, 0Bh
		db	 03h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 01h, 0Ah, 01h, 0Bh, 0Ah, 0Ah
		db	 01h, 0Bh, 02h, 0Ah, 01h, 0Bh
		db	 03h, 0Ah, 01h, 0Bh, 02h, 0Ah
		db	 01h, 0Bh, 07h, 0Ah, 02h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 06h, 0Ah
		db	 02h, 0Bh, 03h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 13h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 05h, 0Bh, 0Bh, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 01h, 0Ah, 02h, 0Bh, 06h, 0Ah
		db	 02h, 0Bh, 0Fh, 0Ah, 02h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 01h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 02h, 9Eh, 03h, 0Ah, 05h, 9Fh
		db	 02h, 0Ah, 02h, 0Bh, 08h, 0Ah
		db	 02h, 0Bh, 05h, 9Eh, 07h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 17h, 9Eh
		db	 08h, 0Bh, 17h, 9Eh, 01h, 9Fh
		db	 05h, 0Ah, 04h, 9Eh, 03h, 0Ah
		db	 04h, 0Bh, 04h, 0Ah, 02h, 0Bh
		db	 05h, 9Eh, 01h, 9Fh, 03h, 0Ah
		db	 02h, 9Eh, 02h, 0Ah, 04h, 9Eh
		db	 01h, 0Bh, 04h, 0Ah, 04h, 0Bh
		db	 07h, 0Ah, 02h, 0Bh, 02h, 0Ah
		db	 03h, 0Bh, 02h, 0Ah, 02h, 0Bh
		db	 04h, 0Ah, 02h, 0Bh, 0Bh, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 03h, 0Bh
		db	 02h, 0Ah, 02h, 0Bh, 05h, 0Ah
		db	 06h, 0Bh, 03h, 0Ah, 03h, 0Bh
		db	 05h, 0Ah, 03h, 0Bh, 04h, 0Ah
		db	 06h, 0Bh, 12h, 0Ah, 02h, 0Bh
		db	 01h, 0Ah, 03h, 0Bh, 06h, 0Ah
		db	 02h, 0Bh, 0Ah, 0Ah, 07h, 0Bh
		db	 02h, 0Ah, 04h, 0Bh, 04h, 0Ah
		db	 04h, 0Bh, 0Dh, 0Ah, 04h, 0Bh
		db	 02h, 0Ah, 03h, 0Bh, 02h, 0Ah
		db	 02h, 0Bh, 02h, 0Ah, 03h, 0Bh
		db	 01h, 0Ah, 02h, 9Eh, 02h, 0Ah
		db	 02h, 9Eh, 01h, 9Fh, 05h, 0Ah
		db	 04h, 0Bh, 04h, 0Ah, 04h, 0Bh
		db	 04h, 9Eh, 07h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 17h, 9Eh, 09h, 0Bh
		db	 16h, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 07h, 0Bh, 07h, 0Ah, 04h, 0Bh
		db	 04h, 0Ah, 05h, 9Fh, 01h, 9Eh
		db	 07h, 0Bh, 0Bh, 0Ah, 05h, 0Bh
		db	 1Dh, 0Ah, 01h, 0Bh, 05h, 0Ah
		db	 01h, 0Bh, 3Fh, 0Ah, 05h, 0Bh
		db	 3Fh, 9Eh, 04h, 0Ah, 04h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 0Eh, 9Eh
		db	 08h, 9Fh, 04h, 9Eh, 01h, 0Bh
		db	 17h, 9Eh, 0Ah, 0Bh, 16h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	 0Eh, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 07h, 0Bh, 2Eh, 0Ah, 05h, 0Bh
		db	 84h, 9Eh, 08h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 0Fh, 9Eh, 07h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 17h, 9Eh
		db	 0Ah, 0Bh, 17h, 9Eh, 01h, 9Fh
		db	 04h, 9Eh, 08h, 0Bh, 0Eh, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	0B6h, 9Eh, 08h, 9Fh, 04h, 9Eh
		db	 01h, 0Bh, 0Fh, 9Eh, 07h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 16h, 9Eh
		db	 0Ch, 0Bh, 16h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 07h, 0Bh, 0Eh, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	0B6h, 9Eh, 07h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 0Eh, 9Eh, 08h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 16h, 9Eh
		db	 0Ch, 0Bh, 16h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 08h, 0Bh, 0Dh, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	0B5h, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 0Eh, 9Eh, 08h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 15h, 9Eh
		db	 0Eh, 0Bh, 15h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 08h, 0Bh, 0Eh, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 07h, 0Bh
		db	0B5h, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 0Eh, 9Eh, 07h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 16h, 9Eh
		db	 0Eh, 0Bh, 15h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 08h, 0Bh, 0Eh, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	0B4h, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 0Dh, 9Eh, 08h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 15h, 9Eh
		db	 07h, 9Fh, 01h, 9Eh, 08h, 0Bh
		db	 15h, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 08h, 0Bh, 0Dh, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 08h, 0Bh,0B4h, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Dh, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 15h, 9Eh, 07h, 9Fh
		db	 01h, 9Eh, 08h, 0Bh, 15h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	 0Dh, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 08h, 0Bh, 1Dh, 47h, 07h, 0Bh
		db	 6Bh, 47h, 07h, 0Bh, 1Dh, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Eh, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 15h, 9Eh, 07h, 9Fh
		db	 01h, 9Eh, 08h, 0Bh, 15h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	 0Dh, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 08h, 0Bh, 19h, 47h, 0Fh, 0Bh
		db	 63h, 47h, 0Fh, 0Bh, 19h, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Dh, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 15h, 9Eh, 08h, 9Fh
		db	 02h, 9Eh, 08h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	 0Dh, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 08h, 0Bh, 17h, 47h, 13h, 0Bh
		db	 5Fh, 47h, 13h, 0Bh, 17h, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Dh, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 15h, 9Eh, 08h, 9Fh
		db	 02h, 9Eh, 08h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 09h, 0Bh
		db	 0Ch, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 09h, 0Bh, 14h, 47h, 17h, 0Bh
		db	 5Bh, 47h, 17h, 0Bh, 15h, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Dh, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 14h, 9Eh, 09h, 9Fh
		db	 02h, 9Eh, 09h, 0Bh, 13h, 9Eh
		db	 01h, 9Fh, 06h, 9Eh, 08h, 0Bh
		db	 0Ch, 9Eh, 01h, 9Fh, 06h, 9Eh
		db	 08h, 0Bh, 12h, 47h, 0Ah, 46h
		db	 07h, 47h, 0Ch, 0Bh, 53h, 47h
		db	 0Ch, 46h, 07h, 47h, 0Ah, 0Bh
		db	 13h, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 0Dh, 9Eh, 08h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 14h, 9Eh
		db	 08h, 9Fh, 04h, 9Eh, 08h, 0Bh
		db	 14h, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 08h, 0Bh, 0Ch, 9Eh, 01h, 9Fh
		db	 06h, 9Eh, 08h, 0Bh, 11h, 47h
		db	 09h, 46h, 02h,0AAh, 07h, 46h
		db	 02h, 47h, 0Fh, 0Bh, 18h, 47h
		db	 19h, 0Bh, 18h, 47h, 0Fh, 46h
		db	 02h,0AAh, 07h, 46h, 02h, 47h
		db	 09h, 0Bh, 12h, 9Eh, 08h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 0Dh, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 14h, 9Eh, 08h, 9Fh, 04h, 9Eh
		db	 08h, 0Bh, 14h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 08h, 0Bh, 0Ch, 9Eh
		db	 01h, 9Fh, 06h, 9Eh, 08h, 0Bh
		db	 11h, 47h, 07h, 46h, 02h,0AAh
		db	 0Bh, 46h, 02h, 47h, 14h, 0Bh
		db	 07h, 47h, 2Dh, 0Bh, 07h, 47h
		db	 14h, 46h, 02h,0AAh, 0Bh, 46h
		db	 02h, 47h, 07h, 0Bh, 12h, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Ch, 9Eh, 09h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 13h, 9Eh, 09h, 9Fh
		db	 04h, 9Eh, 08h, 0Bh, 14h, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	 0Dh, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 08h, 0Bh, 10h, 47h, 06h, 46h
		db	 02h,0AAh, 05h, 00h, 05h,0AAh
		db	 05h, 46h, 02h, 47h, 5Fh, 46h
		db	 02h,0AAh, 05h, 00h, 05h,0AAh
		db	 05h, 46h, 02h, 47h, 06h, 0Bh
		db	 10h, 9Eh, 09h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 0Ch, 9Eh, 08h, 9Fh
		db	 06h, 9Eh, 01h, 0Bh, 13h, 9Eh
		db	 08h, 9Fh, 05h, 9Eh, 09h, 0Bh
		db	 13h, 9Eh, 01h, 9Fh, 05h, 9Eh
		db	 09h, 0Bh, 0Ch, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 08h, 0Bh, 10h, 47h
		db	 05h, 46h, 01h,0AAh, 05h, 00h
		db	 09h,0AAh, 05h, 46h, 01h, 47h
		db	 5Dh, 46h, 01h,0AAh, 05h, 00h
		db	 09h,0AAh, 05h, 46h, 01h, 47h
		db	 05h, 0Bh, 10h, 9Eh, 09h, 9Fh
		db	 05h, 9Eh, 01h, 0Bh, 0Ch, 9Eh
		db	 08h, 9Fh, 06h, 9Eh, 01h, 0Bh
		db	 13h, 9Eh, 08h, 9Fh, 06h, 9Eh
		db	 08h, 0Bh, 13h, 9Eh, 01h, 9Fh
		db	 05h, 9Eh, 09h, 0Bh, 0Ch, 9Eh
		db	 01h, 9Fh, 05h, 9Eh, 08h, 0Bh
		db	 10h, 47h, 05h, 46h, 01h,0AAh
		db	 04h, 00h, 0Bh,0AAh, 04h, 46h
		db	 01h, 47h, 5Dh, 46h, 01h,0AAh
		db	 04h, 00h, 0Bh,0AAh, 04h, 46h
		db	 01h, 47h, 05h, 0Bh, 10h, 9Eh
		db	 09h, 9Fh, 05h, 9Eh, 01h, 0Bh
		db	 0Ch, 9Eh, 08h, 9Fh, 05h, 9Eh
		db	 01h, 0Bh, 13h, 9Eh, 09h, 9Fh
		db	 06h, 9Eh, 08h, 0Bh, 13h, 9Eh
		db	 01h, 9Fh, 06h, 9Eh, 08h, 0Bh
		db	 0Ch, 9Eh
data_c_5F01	db	1			; Data table (indexed access)
		db	 9Fh, 05h, 9Eh, 08h, 0Bh, 10h
		db	 47h, 05h, 46h, 01h,0AAh, 04h
		db	 00h, 0Bh,0AAh, 04h, 46h, 01h
		db	 47h, 5Dh, 46h, 01h,0AAh, 04h
		db	 00h, 0Bh,0AAh, 04h, 46h, 01h
		db	 47h, 05h, 0Bh, 10h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Ch
		db	 9Eh, 08h, 9Fh, 05h, 9Eh, 01h
		db	 0Bh, 13h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 09h, 0Bh, 12h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 08h, 0Bh, 0Ch
		db	 9Eh, 01h, 9Fh, 05h, 9Eh, 09h
		db	 0Bh, 0Fh, 47h, 05h, 46h, 01h
		db	0AAh, 04h, 00h, 0Bh,0AAh, 04h
		db	 46h, 01h, 47h, 5Dh, 46h, 01h
		db	0AAh, 04h, 00h, 0Bh,0AAh, 04h
		db	 46h, 01h, 47h, 05h, 0Bh, 10h
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 0Bh, 9Eh, 09h, 9Fh, 05h
		db	 9Eh, 01h, 0Bh, 13h, 9Eh, 08h
		db	 9Fh, 07h, 9Eh, 09h, 0Bh, 12h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 08h
		db	 0Bh, 0Ch, 9Eh, 01h, 9Fh, 05h
		db	 9Eh, 09h, 0Bh, 10h, 47h, 05h
		db	 46h, 01h,0AAh, 04h, 00h, 09h
		db	0AAh, 04h, 46h, 01h, 47h, 5Fh
		db	 46h, 01h,0AAh, 04h, 00h, 09h
		db	0AAh, 04h, 46h, 01h, 47h, 05h
		db	 0Bh, 11h, 9Eh, 08h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 0Bh, 9Eh, 09h
		db	 9Fh, 05h, 9Eh, 01h, 0Bh, 12h
		db	 9Eh, 09h, 9Fh, 08h, 9Eh, 08h
		db	 0Bh, 13h, 9Eh, 01h, 9Fh, 05h
		db	 9Eh, 08h, 0Bh, 0Ch, 9Eh, 01h
		db	 9Fh, 05h, 9Eh, 09h, 0Bh, 10h
		db	 47h, 05h, 46h, 01h,0AAh, 06h
		db	 00h, 05h,0AAh, 06h, 46h, 01h
		db	 47h, 5Fh, 46h, 01h,0AAh, 06h
		db	 00h, 05h,0AAh, 06h, 46h, 01h
		db	 47h, 05h, 0Bh, 11h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Bh
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 12h, 9Eh, 09h, 9Fh, 08h
		db	 9Eh, 09h, 0Bh, 12h, 9Eh, 01h
		db	 9Fh, 05h, 9Eh, 09h, 0Bh, 0Bh
		db	 9Eh, 01h, 9Fh, 05h, 9Eh, 09h
		db	 0Bh, 11h, 47h, 05h, 46h, 02h
		db	0AAh, 0Dh, 46h, 02h, 47h, 61h
		db	 46h, 02h,0AAh, 0Dh, 46h, 02h
		db	 47h, 05h, 0Bh, 12h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Bh
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 12h, 9Eh, 08h, 9Fh, 09h
		db	 9Eh, 09h, 0Bh, 12h, 9Eh, 01h
		db	 9Fh, 05h, 9Eh, 09h, 0Bh, 0Bh
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 08h
		db	 0Bh, 12h, 47h, 06h, 46h, 04h
		db	0AAh, 05h, 46h, 04h, 47h, 65h
		db	 46h, 04h,0AAh, 05h, 46h, 04h
		db	 47h, 06h, 0Bh, 13h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Bh
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 12h, 9Eh, 08h, 9Fh, 0Ah
		db	 9Eh, 08h, 0Bh, 12h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 08h, 0Bh, 0Bh
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 08h
		db	 0Bh, 13h, 47h, 09h, 46h, 05h
		db	 47h, 6Dh, 46h, 05h, 47h, 09h
		db	 0Bh, 13h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 0Ah, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 11h
		db	 9Eh, 09h, 9Fh, 0Ah, 9Eh, 09h
		db	 0Bh, 11h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 08h, 0Bh, 0Bh, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 08h, 0Bh, 13h
		db	 47h, 89h, 0Bh, 13h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Ah
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 11h, 9Eh, 09h, 9Fh, 0Ah
		db	 9Eh, 09h, 0Bh, 11h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 08h, 0Bh, 0Bh
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 08h
		db	 0Bh, 13h, 47h, 89h, 0Bh, 13h
		db	 9Eh, 09h, 9Fh, 05h, 9Eh, 01h
		db	 0Bh, 0Bh, 9Eh, 09h, 9Fh, 05h
		db	 9Eh, 01h, 0Bh, 12h, 9Eh, 08h
		db	 9Fh, 0Bh, 9Eh, 09h, 0Bh, 11h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 0Ah, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 08h, 0Bh, 13h, 47h, 89h
		db	 0Bh, 13h, 9Eh, 09h, 9Fh, 05h
		db	 9Eh, 01h, 0Bh, 0Bh, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 11h
		db	 9Eh, 09h, 9Fh, 0Ch, 9Eh, 09h
		db	 0Bh, 10h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 09h, 0Bh, 0Ah, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h, 0Bh, 12h
		db	 47h, 89h, 0Bh, 13h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Bh
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 11h, 9Eh, 09h, 9Fh, 0Ch
		db	 9Eh, 09h, 0Bh, 10h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h, 0Bh, 0Ah
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 12h, 47h, 89h, 0Bh, 13h
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 0Bh, 9Eh, 08h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 11h, 9Eh, 09h
		db	 9Fh, 05h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 09h, 0Bh, 11h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 08h, 0Bh, 0Ah
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 12h, 47h, 89h, 0Bh, 13h
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 0Ah, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 10h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 08h, 0Bh, 11h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 08h, 0Bh, 0Ah
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 0Fh,0E0h, 01h, 0Bh, 01h
		db	 47h, 8Bh, 0Bh, 12h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Ah
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 10h, 9Eh, 09h, 9Fh, 06h
		db	 0Bh, 01h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 09h, 0Bh, 10h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h, 0Bh, 09h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 0Eh,0DDh, 01h,0E0h, 01h
		db	 47h, 8Dh, 0Bh, 11h, 9Eh, 08h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Ah
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 10h, 9Eh, 09h, 9Fh, 06h
		db	 0Bh, 01h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 09h, 0Bh, 10h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h, 0Bh, 09h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 0Bh,0DEh, 01h,0DDh, 01h
		db	0E1h, 01h,0DEh, 01h, 47h, 8Fh
		db	 0Bh, 0Fh, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 0Ah, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Fh
		db	 9Eh, 09h, 9Fh, 07h, 0Bh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 0Eh,0E1h, 01h, 0Bh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 09h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 08h, 0Bh, 07h,0E1h, 01h
		db	 0Bh, 02h,0DFh, 01h,0E0h, 01h
		db	0E2h, 01h,0DFh, 01h,0E2h, 01h
		db	 47h, 8Fh, 0Bh, 0Fh, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Ah
		db	 9Eh, 08h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 10h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h, 0Bh, 09h
		db	0E1h, 01h,0DEh, 01h, 0Bh, 01h
		db	0E1h, 01h,0E2h, 01h,0DFh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 06h,0E1h, 01h,0DFh, 01h
		db	 0Bh, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 08h, 0Bh, 06h,0E1h, 01h
		db	0E0h, 01h,0E2h, 01h,0DEh, 01h
		db	0E2h, 01h,0DDh, 01h,0E1h, 01h
		db	0DFh, 01h, 47h, 91h, 0Bh, 0Eh
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 09h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 10h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 02h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0E2h, 01h,0E0h, 01h, 0Bh, 05h
		db	0DEh, 01h,0E2h, 01h,0DFh, 01h
		db	0E1h, 01h,0E2h, 03h,0DEh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	 0Bh, 05h,0DDh, 01h,0DFh, 01h
		db	0DDh, 01h,0E0h, 01h,0DFh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 08h
		db	 0Bh, 01h,0E0h, 01h, 0Bh, 03h
		db	0E0h, 01h,0E1h, 01h,0DFh, 01h
		db	0E2h, 02h,0DDh, 01h,0DEh, 01h
		db	0E1h, 01h,0DFh, 01h, 47h, 91h
		db	 0Bh, 0Eh, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 09h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Fh
		db	0E0h, 01h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 02h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h,0E2h, 01h
		db	0DEh, 01h,0DDh, 01h,0E1h, 01h
		db	0E0h, 03h,0E1h, 01h,0E2h, 01h
		db	0DFh, 01h,0DDh, 03h,0E0h, 01h
		db	0E1h, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 08h, 0Bh, 03h,0DDh, 01h
		db	0E2h, 01h,0E1h, 01h,0DDh, 01h
		db	0E0h, 01h,0DEh, 01h,0E0h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0E0h, 02h,0DEh, 01h,0DDh, 01h
		db	0E0h, 02h,0E2h, 01h,0E0h, 02h
		db	0E2h, 01h,0E0h, 01h,0E2h, 01h
		db	 47h, 93h, 0Bh, 0Dh, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 09h
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 0Eh,0DDh, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h, 0Bh, 02h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0E2h, 02h,0E1h, 01h,0E2h, 01h
		db	0DEh, 01h,0DFh, 01h,0E1h, 01h
		db	0E0h, 01h,0DEh, 02h,0E1h, 02h
		db	0DDh, 02h,0DFh, 01h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h,0DEh, 01h
		db	0E2h, 01h,0DDh, 01h,0DFh, 01h
		db	0E1h, 01h,0DEh, 01h,0E1h, 01h
		db	0DFh, 01h,0E0h, 01h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h,0E2h, 01h
		db	0E0h, 02h,0E2h, 01h,0DEh, 01h
		db	0DFh, 01h,0E1h, 01h,0DEh, 01h
		db	0E1h, 01h,0DDh, 02h,0E0h, 01h
		db	 47h, 93h,0DEh, 01h,0E1h, 01h
		db	 0Bh, 01h,0E1h, 01h, 0Bh, 02h
		db	0DDh, 01h, 0Bh, 01h,0DEh, 01h
		db	 0Bh, 02h,0E1h, 01h,0E0h, 01h
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	 0Bh, 09h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h, 0Bh, 0Dh,0DDh, 02h
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	0E2h, 01h, 0Bh, 01h,0E1h, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0E2h, 01h,0DEh, 01h,0E2h, 01h
		db	0E1h, 01h,0E2h, 01h,0E0h, 01h
		db	0E2h, 01h,0E0h, 01h,0E2h, 01h
		db	0E0h, 01h,0E1h, 01h,0DFh, 01h
		db	0E2h, 01h,0E0h, 01h,0E2h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0DDh, 01h,0DFh, 01h,0E0h, 01h
		db	0E1h, 01h,0DEh, 01h,0E0h, 01h
		db	0DEh, 01h,0DDh, 01h,0E0h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0DFh, 01h,0DDh, 01h,0E0h, 01h
		db	0DDh, 01h,0E0h, 01h,0DFh, 01h
		db	0DEh, 01h,0E0h, 01h,0E2h, 01h
		db	0DEh, 01h,0E0h, 01h,0DDh, 01h
		db	 47h, 93h,0E0h, 01h,0E2h, 01h
		db	0DDh, 02h,0DFh, 01h,0E0h, 01h
		db	0DEh, 01h,0E1h, 01h,0DFh, 01h
		db	0DEh, 01h,0DDh, 01h,0E0h, 01h
		db	0E2h, 01h, 9Eh, 08h, 9Fh, 07h
		db	 9Eh, 01h, 0Bh, 09h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h, 0Bh, 0Ch
		db	0DEh, 02h,0DFh, 01h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h,0DDh, 01h
		db	0E1h, 01h,0E2h, 01h,0DDh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0E2h, 01h,0DFh, 01h,0E1h, 01h
		db	0DEh, 01h,0E2h, 01h,0DDh, 02h
		db	0E0h, 01h,0E2h, 01h,0DEh, 01h
		db	0E2h, 02h,0E0h, 02h,0E1h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0E2h, 02h,0DFh, 01h,0E2h, 01h
		db	0DDh, 02h,0E0h, 01h,0DFh, 01h
		db	0DEh, 01h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 09h,0E1h, 01h,0E0h, 01h
		db	0E2h, 02h,0DEh, 01h,0DDh, 01h
		db	0E2h, 01h,0DEh, 01h,0DFh, 01h
		db	0E1h, 03h, 47h, 93h,0DFh, 01h
		db	0E0h, 01h,0DEh, 01h,0DDh, 04h
		db	0E1h, 02h,0DDh, 01h,0DEh, 01h
		db	0DDh, 01h,0E1h, 01h, 9Eh, 08h
		db	 9Fh, 07h, 9Eh, 01h, 0Bh, 08h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	 0Bh, 02h,0E1h, 01h, 0Bh, 08h
		db	0DFh, 01h,0E1h, 01h,0E0h, 01h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0E2h, 01h,0E1h, 01h,0E0h, 01h
		db	0E2h, 01h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 0Ah,0DFh, 02h,0E2h, 02h
		db	0DDh, 01h,0E2h, 02h,0DDh, 01h
		db	0E2h, 01h,0E1h, 01h,0E0h, 01h
		db	0DFh, 01h,0DEh, 01h,0DFh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0DFh, 01h,0E1h, 01h,0DFh, 01h
		db	0DEh, 01h,0DFh, 02h,0E0h, 01h
		db	0E2h, 01h,0DFh, 01h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h,0E1h, 01h
		db	0DDh, 01h,0E0h, 02h,0DDh, 01h
		db	0E2h, 01h,0E0h, 01h,0E2h, 02h
		db	0E1h, 02h, 47h, 95h,0E0h, 01h
		db	0DDh, 01h,0DEh, 01h,0DDh, 01h
		db	0DEh, 01h,0DDh, 01h,0DFh, 02h
		db	0DDh, 01h,0E0h, 01h,0E2h, 01h
		db	0E1h, 01h, 9Eh, 08h, 9Fh, 07h
		db	 9Eh, 01h,0E0h, 01h, 0Bh, 07h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0DDh, 01h,0DFh, 01h,0E0h, 01h
		db	0DFh, 01h,0E2h, 01h, 0Bh, 01h
		db	0DDh, 01h,0DEh, 02h,0DFh, 01h
		db	0E0h, 01h,0DFh, 01h,0DEh, 02h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0DEh, 01h,0E1h, 01h,0DFh, 01h
		db	0DEh, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0DEh, 01h,0DFh, 01h
		db	0E1h, 01h,0DEh, 01h,0E2h, 01h
		db	0E0h, 01h,0DDh, 01h,0DFh, 01h
		db	0E1h, 01h,0DEh, 01h,0DDh, 01h
		db	0E2h, 01h,0DFh, 01h,0E0h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0DFh, 01h,0E0h, 01h,0E1h, 01h
		db	0E2h, 01h,0E0h, 01h,0DEh, 01h
		db	0E1h, 01h,0E0h, 01h,0E2h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0DEh, 01h,0DFh, 01h,0E1h, 01h
		db	0E2h, 02h,0DEh, 01h,0E0h, 01h
		db	0DFh, 02h,0E1h, 01h,0E2h, 01h
		db	 47h, 95h,0DFh, 01h,0DDh, 03h
		db	0DFh, 01h,0DEh, 01h,0E1h, 01h
		db	0DFh, 01h,0DEh, 01h,0DDh, 02h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0E0h, 01h,0E2h, 01h, 0Bh, 05h
		db	0E1h, 01h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0E2h, 01h,0E0h, 01h
		db	0E2h, 01h,0DFh, 01h,0DDh, 01h
		db	0DFh, 01h,0E0h, 01h,0DEh, 01h
		db	0DDh, 01h,0DFh, 01h,0E0h, 01h
		db	0E1h, 01h,0E0h, 01h,0DEh, 01h
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	0E1h, 01h,0DFh, 01h,0E2h, 01h
		db	0DFh, 01h,0DDh, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0E0h, 01h
		db	0E1h, 01h,0E2h, 01h,0DFh, 01h
		db	0E0h, 01h,0E2h, 01h,0DDh, 02h
		db	0E2h, 01h,0DEh, 01h,0DDh, 02h
		db	0E2h, 02h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0E1h, 01h,0DEh, 01h
		db	0DDh, 01h,0DFh, 01h,0E2h, 02h
		db	0DEh, 01h,0DDh, 01h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 09h,0DFh, 02h
		db	0E1h, 01h,0E2h, 01h,0DDh, 01h
		db	0DEh, 01h,0DDh, 02h,0E2h, 01h
		db	0E0h, 01h,0DFh, 01h, 47h, 95h
		db	0DDh, 01h,0E0h, 01h,0E2h, 01h
		db	0DFh, 01h,0E0h, 02h,0DDh, 02h
		db	0DEh, 01h,0E2h, 02h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0DEh, 01h
		db	0DDh, 01h,0DFh, 04h,0E1h, 01h
		db	0E2h, 01h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h,0E2h, 02h,0DEh, 01h
		db	0E1h, 01h,0DEh, 01h,0E1h, 01h
		db	0E2h, 01h,0E0h, 01h,0DDh, 01h
		db	0E2h, 01h,0DFh, 01h,0E0h, 01h
		db	0DFh, 01h,0E0h, 01h, 9Eh, 0Ah
		db	 9Fh, 06h, 9Eh, 01h,0E1h, 02h
		db	0DEh, 01h,0E2h, 01h,0DFh, 01h
		db	0E2h, 01h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 09h,0E0h, 03h,0DFh, 01h
		db	0DDh, 01h,0E2h, 01h,0DFh, 01h
		db	0DDh, 01h,0E0h, 01h,0DFh, 01h
		db	0E0h, 01h,0E1h, 01h,0DEh, 01h
		db	0DDh, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0E2h, 01h,0DDh, 01h
		db	0DFh, 01h,0DEh, 01h,0DFh, 01h
		db	0E2h, 01h,0E0h, 01h,0DEh, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 08h
		db	0DDh, 01h,0DEh, 01h,0E2h, 01h
		db	0E0h, 01h,0E2h, 01h,0E0h, 01h
		db	0DDh, 01h,0E1h, 01h,0DFh, 01h
		db	0E2h, 01h,0E0h, 01h, 47h, 95h
		db	0DEh, 03h,0E2h, 02h,0E0h, 01h
		db	0DEh, 01h,0DFh, 01h,0E2h, 01h
		db	0DEh, 01h,0E1h, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0E2h, 01h
		db	0DDh, 01h,0E0h, 01h,0E1h, 01h
		db	0DFh, 02h,0DEh, 01h,0DDh, 01h
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	0E2h, 02h,0E0h, 01h,0E1h, 01h
		db	0DFh, 01h,0E1h, 02h,0E2h, 01h
		db	0E0h, 01h,0DEh, 01h,0DFh, 01h
		db	0DDh, 01h,0E1h, 02h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0DFh, 01h
		db	0E2h, 01h,0E0h, 01h,0DDh, 02h
		db	0E2h, 01h, 9Eh, 01h, 9Fh, 06h
		db	 9Eh, 0Ah,0E0h, 01h,0E2h, 01h
		db	0DFh, 01h,0E2h, 01h,0E0h, 01h
		db	0E2h, 01h,0DDh, 01h,0DEh, 01h
		db	0E0h, 01h,0DFh, 01h,0E2h, 01h
		db	0DFh, 01h,0E1h, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0DDh, 01h
		db	0DEh, 02h,0E1h, 01h,0DFh, 01h
		db	0E0h, 01h,0DFh, 02h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 08h,0DFh, 01h
		db	0E1h, 01h,0DEh, 02h,0E0h, 01h
		db	0E1h, 01h,0DFh, 01h,0E0h, 01h
		db	0E1h, 02h,0E2h, 01h, 47h, 95h
		db	0E1h, 01h,0DDh, 01h,0E0h, 01h
		db	0DEh, 01h,0E1h, 01h,0DFh, 01h
		db	0E2h, 01h,0E1h, 01h,0DDh, 01h
		db	0E2h, 01h,0E1h, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0E0h, 01h
		db	0DEh, 01h,0DDh, 01h,0DEh, 01h
		db	0E2h, 01h,0E0h, 01h,0E1h, 01h
		db	0DFh, 01h, 9Eh, 09h, 9Fh, 06h
		db	 9Eh, 01h,0E0h, 01h,0DFh, 01h
		db	0E2h, 02h,0E0h, 01h,0E1h, 01h
		db	0E0h, 02h,0DEh, 02h,0E0h, 01h
		db	0E2h, 01h,0E0h, 01h,0E2h, 01h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0DEh, 01h,0DDh, 02h,0E1h, 01h
		db	0DDh, 01h,0E1h, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0E0h, 01h
		db	0E1h, 01h,0DEh, 01h,0E1h, 01h
		db	0E0h, 01h,0E2h, 01h,0DFh, 01h
		db	0E1h, 01h,0DFh, 01h,0DDh, 01h
		db	0E0h, 02h,0DDh, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0E1h, 02h
		db	0E0h, 01h,0DEh, 01h,0E2h, 01h
		db	0DDh, 01h,0E2h, 01h,0DEh, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0E0h, 01h,0DEh, 01h,0E2h, 01h
		db	0DFh, 01h,0DEh, 01h,0DFh, 02h
		db	0E1h, 03h, 47h, 95h,0DEh, 01h
		db	0E0h, 02h,0DFh, 02h,0E1h, 03h
		db	0E2h, 01h,0DDh, 01h,0E2h, 01h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0E2h, 01h,0E0h, 01h,0E2h, 02h
		db	0DDh, 01h,0E1h, 01h,0DFh, 01h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0E2h, 01h,0E1h, 02h,0E2h, 02h
		db	0E1h, 02h,0DEh, 01h,0E1h, 01h
		db	0DDh, 01h,0DFh, 01h,0DEh, 01h
		db	0E1h, 01h, 9Eh, 0Ah, 9Fh, 06h
		db	 9Eh, 01h,0DDh, 01h,0DFh, 02h
		db	0DDh, 01h,0E0h, 01h,0DFh, 01h
		db	0E1h, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0DFh, 01h,0E2h, 01h
		db	0DEh, 01h,0E2h, 01h,0DDh, 01h
		db	0DEh, 01h,0E2h, 01h,0DEh, 01h
		db	0DDh, 01h,0E1h, 01h,0DDh, 01h
		db	0E2h, 01h,0E1h, 01h,0DFh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 09h
		db	0E0h, 01h,0DEh, 01h,0E1h, 01h
		db	0E2h, 01h,0DDh, 01h,0DFh, 01h
		db	0DDh, 02h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0E1h, 02h,0E2h, 01h
		db	0DEh, 02h,0E1h, 01h,0E0h, 01h
		db	0DEh, 01h,0E1h, 01h,0DEh, 01h
		db	0DFh, 01h, 47h, 93h,0E2h, 02h
		db	0E1h, 01h,0DDh, 01h,0E1h, 01h
		db	0DFh, 01h,0DEh, 01h,0DDh, 01h
		db	0E0h, 01h,0DEh, 03h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h,0DFh, 01h
		db	0E2h, 02h,0DEh, 01h,0DFh, 01h
		db	0E1h, 03h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0E2h, 03h,0E0h, 01h
		db	0E2h, 03h,0DDh, 01h,0DEh, 01h
		db	0E0h, 01h,0E2h, 01h,0DDh, 01h
		db	0DFh, 01h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0E2h, 01h,0DDh, 01h
		db	0E1h, 01h,0E0h, 01h,0E2h, 01h
		db	0E1h, 01h,0DEh, 01h,0DDh, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 0Ah
		db	0E0h, 01h,0DFh, 01h,0DEh, 01h
		db	0DDh, 01h,0E1h, 01h,0DFh, 01h
		db	0E2h, 01h,0DFh, 01h,0DEh, 01h
		db	0DDh, 01h,0E1h, 02h,0E2h, 01h
		db	 9Eh, 01h, 9Fh, 06h, 9Eh, 0Ah
		db	0E2h, 01h,0E1h, 01h,0DEh, 01h
		db	0E2h, 01h,0DEh, 01h,0E2h, 01h
		db	0DEh, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0DFh, 01h,0E0h, 01h
		db	0E2h, 01h,0DDh, 01h,0E2h, 03h
		db	0E0h, 01h,0E1h, 01h,0DEh, 01h
		db	0E2h, 01h, 47h, 01h, 30h, 03h
		db	 47h, 8Bh, 30h, 03h, 47h, 01h
		db	0E2h, 01h,0E0h, 01h,0E2h, 02h
		db	0DDh, 01h,0DFh, 01h,0DDh, 01h
		db	0E2h, 01h,0E1h, 01h,0DFh, 01h
		db	0DDh, 01h,0DFh, 01h, 9Eh, 09h
		db	 9Fh, 06h, 9Eh, 01h,0E1h, 01h
		db	0DFh, 01h,0E2h, 01h,0DEh, 01h
		db	0E0h, 01h,0DEh, 01h,0E0h, 01h
		db	0DEh, 01h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0E1h, 01h,0DFh, 01h
		db	0E2h, 01h,0DDh, 01h,0DFh, 01h
		db	0E1h, 01h,0DEh, 01h,0E0h, 01h
		db	0DFh, 01h,0DDh, 01h,0E0h, 01h
		db	0DEh, 01h,0E2h, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0E2h, 01h
		db	0E0h, 01h,0DFh, 01h,0DDh, 01h
		db	0DEh, 01h,0E2h, 01h,0DEh, 01h
		db	0E2h, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0DEh, 01h,0E2h, 02h
		db	0E1h, 01h,0E0h, 01h,0DFh, 01h
		db	0DDh, 01h,0E2h, 01h,0DEh, 01h
		db	0DFh, 02h,0E2h, 01h,0E1h, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0DDh, 01h,0DFh, 01h,0E2h, 02h
		db	0DFh, 01h,0E2h, 01h,0DEh, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0DEh, 01h,0E2h, 01h,0DFh, 01h
		db	0E0h, 01h,0DDh, 01h,0E0h, 01h
		db	0DFh, 01h,0E0h, 01h,0E1h, 01h
		db	0E0h, 01h,0E2h, 01h, 47h, 01h
		db	 30h, 01h, 31h, 01h, 30h, 06h
		db	 47h, 81h, 30h, 06h, 31h, 01h
		db	 30h, 01h, 47h, 01h,0E2h, 01h
		db	0E0h, 01h,0E2h, 02h,0E0h, 02h
		db	0DDh, 01h,0E2h, 01h,0DEh, 01h
		db	0E1h, 01h,0E2h, 01h,0DFh, 01h
		db	 9Eh, 09h, 9Fh, 06h, 9Eh, 01h
		db	0E0h, 01h,0DFh, 02h,0E1h, 01h
		db	0E0h, 01h,0DEh, 01h,0E1h, 01h
		db	0DEh, 01h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0E2h, 01h,0E1h, 01h
		db	0DEh, 01h,0E0h, 01h,0E2h, 01h
		db	0DFh, 01h,0E0h, 01h,0E2h, 01h
		db	0DEh, 01h,0DFh, 02h,0DDh, 01h
		db	 9Eh, 0Ah, 9Fh, 07h, 9Eh, 01h
		db	0DEh, 01h,0E2h, 01h,0E0h, 01h
		db	0E2h, 01h,0DEh, 02h,0DDh, 01h
		db	0E1h, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0DFh, 01h,0DDh, 01h
		db	0E0h, 01h,0E1h, 01h,0E0h, 01h
		db	0DDh, 01h,0DEh, 01h,0E1h, 01h
		db	0DEh, 01h,0E2h, 01h,0E0h, 01h
		db	0DFh, 01h,0E2h, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0DEh, 01h
		db	0E2h, 01h,0E0h, 02h,0E1h, 02h
		db	0DEh, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0E1h, 01h,0DFh, 01h
		db	0DEh, 01h,0E2h, 01h,0DDh, 01h
		db	0E2h, 01h,0DDh, 02h,0E2h, 01h
		db	0DDh, 01h,0E0h, 02h, 46h, 01h
		db	 30h, 01h, 31h, 02h, 30h, 0Bh
		db	 47h, 73h, 30h, 0Bh, 31h, 02h
		db	 30h, 01h, 46h, 01h,0DEh, 02h
		db	0E1h, 01h,0E0h, 01h,0DDh, 01h
		db	0E2h, 01h,0E0h, 03h,0DEh, 01h
		db	0DFh, 01h,0DEh, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0DDh, 01h
		db	0DEh, 02h,0E0h, 01h,0E2h, 01h
		db	0DFh, 01h,0DEh, 01h,0E0h, 01h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0DFh, 02h,0E1h, 01h,0E0h, 01h
		db	0DFh, 02h,0E2h, 01h,0DFh, 01h
		db	0E0h, 02h,0E1h, 01h,0DDh, 01h
		db	 9Eh, 0Ah, 9Fh, 06h, 9Eh, 01h
		db	0E1h, 01h,0E0h, 01h,0E1h, 01h
		db	0E0h, 01h,0E2h, 04h,0E0h, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 0Ah
		db	0DEh, 01h,0E2h, 01h,0DEh, 01h
		db	0E2h, 02h,0DDh, 01h,0DEh, 01h
		db	0DDh, 01h,0DFh, 01h,0E2h, 01h
		db	0E1h, 01h,0DDh, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0DEh, 01h
		db	0E2h, 01h,0DEh, 01h,0E0h, 01h
		db	0DEh, 01h,0E0h, 01h,0DDh, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0E0h, 01h,0DFh, 01h,0DEh, 01h
		db	0E2h, 01h,0E0h, 01h,0DFh, 01h
		db	0E1h, 01h,0DEh, 01h,0E0h, 01h
		db	0DDh, 01h,0DEh, 01h,0E1h, 01h
		db	 46h, 01h, 30h, 03h, 31h, 04h
		db	 30h, 11h, 47h, 5Fh, 30h, 11h
		db	 31h, 04h, 30h, 03h, 46h, 01h
		db	0E0h, 01h,0E2h, 01h,0DFh, 01h
		db	0DDh, 01h,0DEh, 01h,0E0h, 01h
		db	0DEh, 02h,0E0h, 01h,0DFh, 01h
		db	0DEh, 01h,0DDh, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0DDh, 01h
		db	0E2h, 03h,0DDh, 01h,0E1h, 01h
		db	0DDh, 01h, 9Eh, 0Ah, 9Fh, 06h
		db	 9Eh, 01h,0E0h, 02h,0E1h, 01h
		db	0DEh, 01h,0E2h, 01h,0DEh, 01h
		db	0DFh, 01h,0DEh, 02h,0E1h, 01h
		db	0DFh, 02h,0E1h, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0E2h, 01h
		db	0E1h, 01h,0DDh, 01h,0DEh, 01h
		db	0E1h, 01h,0E0h, 02h,0E1h, 01h
		db	0DFh, 01h,0DEh, 01h, 9Eh, 01h
		db	 9Fh, 06h, 9Eh, 0Ah,0E2h, 01h
		db	0DFh, 03h,0E1h, 02h,0E2h, 01h
		db	0DFh, 01h,0DDh, 01h,0DEh, 01h
		db	0E0h, 02h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0E2h, 01h,0E0h, 01h
		db	0E2h, 01h,0E0h, 01h,0DEh, 01h
		db	0DFh, 01h,0E2h, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0E2h, 01h
		db	0DFh, 01h,0E0h, 01h,0DDh, 01h
		db	0E0h, 01h,0E2h, 01h,0DDh, 01h
		db	0DFh, 01h,0DEh, 01h,0E1h, 01h
		db	0DFh, 01h,0DEh, 01h,0DDh, 01h
		db	 46h, 02h, 30h, 05h, 31h, 04h
		db	 30h, 1Ah, 47h, 45h, 30h, 1Ah
		db	 31h, 04h, 30h, 05h, 46h, 02h
		db	0E2h, 02h,0E0h, 01h,0E2h, 01h
		db	0E0h, 02h,0E1h, 01h,0DFh, 01h
		db	0DEh, 02h,0E0h, 01h,0DDh, 01h
		db	0E0h, 01h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0E1h, 01h,0E2h, 02h
		db	0DDh, 01h,0E1h, 01h,0DEh, 01h
		db	0E0h, 01h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0DFh, 01h,0E2h, 01h
		db	0DEh, 01h,0DDh, 01h,0DFh, 01h
		db	0E2h, 01h,0DEh, 01h,0DFh, 01h
		db	0E1h, 01h,0DDh, 01h,0DEh, 03h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0DDh, 01h,0DEh, 01h,0E2h, 01h
		db	0DEh, 01h,0DDh, 01h,0E1h, 01h
		db	0DEh, 01h,0E0h, 01h,0E1h, 01h
		db	0E0h, 01h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0DFh, 01h,0DEh, 01h
		db	0E0h, 01h,0DFh, 01h,0E1h, 01h
		db	0E2h, 02h,0DFh, 01h,0DDh, 01h
		db	0DEh, 01h,0DDh, 01h,0E1h, 01h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0E1h, 02h,0DDh, 01h,0DEh, 01h
		db	0E2h, 02h,0E0h, 01h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0DDh, 01h
		db	0E0h, 01h,0DEh, 01h,0DDh, 02h
		db	0E1h, 01h,0DEh, 01h,0E2h, 01h
		db	0E1h, 01h,0DEh, 01h,0E1h, 02h
		db	0E0h, 01h,0E2h, 01h,0DFh, 01h
		db	 46h, 02h, 30h, 07h, 31h, 07h
		db	 30h, 23h, 47h, 25h, 30h, 23h
		db	 31h, 07h, 30h, 07h, 46h, 02h
		db	0DFh, 01h,0DDh, 01h,0E2h, 01h
		db	0E0h, 01h,0DEh, 01h,0E1h, 01h
		db	0DEh, 01h,0E2h, 01h,0E1h, 01h
		db	0DFh, 02h,0E0h, 01h,0DDh, 01h
		db	0DFh, 01h,0DEh, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0DEh, 01h
		db	0DFh, 02h,0E0h, 01h,0E2h, 01h
		db	0DFh, 01h,0E2h, 01h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0E1h, 01h
		db	0DFh, 01h,0DDh, 01h,0DFh, 01h
		db	0E2h, 01h,0DFh, 01h,0E0h, 01h
		db	0DFh, 01h,0DDh, 01h,0DFh, 01h
		db	0E2h, 02h, 9Eh, 0Ah, 9Fh, 07h
		db	 9Eh, 01h,0DFh, 01h,0E0h, 02h
		db	0E1h, 01h,0F0h, 06h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0F0h, 0Ch
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0F0h, 07h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0F0h, 11h, 46h, 05h
		db	'0', 9, '1', 8, '0[1', 8, '0', 9, 'F'
		db	 05h,0F0h, 11h, 9Eh, 09h, 9Fh
		db	 07h, 9Eh, 01h,0F0h, 07h, 9Eh
		db	 09h, 9Fh, 07h, 9Eh, 01h,0F0h
		db	 0Ch, 9Eh, 0Ah, 9Fh, 06h, 9Eh
		db	 01h,0F0h, 05h,0F1h, 06h, 9Eh
		db	 01h, 9Fh, 07h, 9Eh, 0Ah,0F1h
		db	 0Bh, 9Eh, 01h, 9Fh, 07h, 9Eh
		db	 0Ah,0F1h, 06h, 9Eh, 01h, 9Fh
		db	 07h, 9Eh, 09h,0F1h, 11h
		db	'F', 9, '0', 0Dh, '1', 0Dh, '0A1', 0Dh
		db	'0', 0Dh, 'F', 9
		db	0F1h, 11h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0F1h, 07h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0F1h, 0Ch
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0F1h, 05h,0F2h, 06h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 0Ah,0F2h, 0Bh
		db	 9Eh, 01h, 9Fh, 08h, 9Eh, 09h
		db	0F2h, 06h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0F2h, 11h, 46h, 0Dh
		db	 30h, 16h, 31h, 10h, 30h, 21h
		db	 31h, 10h, 30h, 16h, 46h, 0Dh
		db	0F2h, 11h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0F2h, 07h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0F2h, 0Ch
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0F2h, 05h,0F3h, 07h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 09h,0F3h, 0Bh
		db	 9Eh, 01h, 9Fh, 08h, 9Eh, 09h
		db	0F3h, 06h, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 0Ah,0F3h, 10h, 46h, 11h
		db	 30h, 22h, 31h, 21h, 30h, 22h
		db	 46h, 11h,0F3h, 11h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0F3h, 07h
		db	 9Eh, 09h, 9Fh, 07h, 9Eh, 01h
		db	0F3h, 0Bh, 9Eh, 0Ah, 9Fh, 07h
		db	 9Eh, 01h,0F3h, 05h,0F4h, 07h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	0F4h, 0Ch, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h,0F4h, 06h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 0Ah,0F4h, 11h
		db	 46h, 15h, 30h, 5Bh, 46h, 15h
		db	0F4h, 12h, 9Eh, 09h, 9Fh, 07h
		db	 9Eh, 01h,0F4h, 07h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h,0F4h, 0Bh
		db	 9Eh, 0Ah, 9Fh, 07h, 9Eh, 01h
		db	0F4h, 05h, 64h, 07h, 9Eh, 01h
		db	 9Fh, 07h, 9Eh, 0Ah, 64h, 0Bh
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 09h
		db	 64h, 06h, 9Eh, 01h, 9Fh, 08h
		db	 9Eh, 09h, 64h, 0Eh, 45h, 04h
		db	 46h, 1Bh, 30h, 4Dh, 46h, 1Bh
		db	 45h, 02h, 64h, 11h, 9Eh, 09h
		db	 9Fh, 07h, 9Eh, 01h, 64h, 06h
		db	 9Eh, 0Ah, 9Fh, 07h, 9Eh, 01h
		db	 64h, 0Bh, 9Eh, 09h, 9Fh, 08h
		db	 9Eh, 01h, 64h, 05h, 63h, 07h
		db	 9Eh, 01h, 9Fh, 07h, 9Eh, 0Ah
		db	 63h, 0Bh, 9Eh, 01h, 9Fh, 07h
		db	 9Eh, 09h, 63h, 06h, 9Eh, 01h
		db	 9Fh, 08h, 9Eh
		db	9, 'c', 9, 'E', 9, 'F%09F%E'
		db	 07h, 63h, 0Ch, 9Eh, 09h, 9Fh
		db	 07h, 9Eh, 01h, 63h, 06h, 9Eh
		db	 0Ah, 9Fh, 07h, 9Eh, 01h, 63h
		db	 0Bh, 9Eh, 09h, 9Fh, 07h, 9Eh
		db	 01h, 63h, 06h, 62h, 07h, 9Eh
		db	 01h, 9Fh, 07h, 9Eh, 0Ah, 62h
		db	 0Bh, 9Eh, 01h, 9Fh, 07h, 9Eh
		db	 09h, 62h, 06h, 9Eh, 01h, 9Fh
		db	 08h, 9Eh, 09h, 62h, 04h, 45h
		db	 0Eh, 46h, 32h, 30h, 1Fh, 46h
		db	 32h, 45h, 0Ch, 62h, 07h, 9Eh
		db	 09h, 9Fh, 07h, 9Eh, 01h, 62h
		db	 06h, 9Eh, 09h, 9Fh, 08h, 9Eh
		db	 01h, 62h, 0Ah, 9Eh, 0Ah, 9Fh
		db	 07h, 9Eh, 01h, 62h, 06h, 61h
		db	 07h, 9Eh, 01h, 9Fh, 08h, 9Eh
		db	 09h, 61h, 0Bh, 9Eh, 01h, 9Fh
		db	 07h, 9Eh, 09h, 61h, 06h, 9Eh
		db	 01h, 9Fh
		db	8
data_c_7000	db	9Eh			; Data table (indexed access)
		db	 09h, 45h, 13h, 46h, 81h, 45h
		db	 12h, 61h, 02h, 9Eh, 09h, 9Fh
		db	 07h, 9Eh, 01h, 61h, 06h, 9Eh
		db	 09h, 9Fh, 08h, 9Eh, 01h, 61h
		db	 0Ah, 9Eh, 0Ah, 9Fh, 07h, 9Eh
		db	 01h, 61h, 06h, 60h, 08h, 9Eh
		db	 01h, 9Fh, 07h, 9Eh, 09h, 60h
		db	 0Bh, 9Eh, 01h, 9Fh, 07h, 9Eh
		db	 0Ah, 60h, 05h, 9Eh, 01h, 9Fh
		db	 08h, 9Eh, 09h, 45h, 15h, 46h
		db	 7Dh, 45h, 16h, 9Eh, 09h, 9Fh
		db	 07h, 9Eh, 01h, 60h, 06h, 9Eh
		db	 09h, 9Fh, 08h, 9Eh, 01h, 60h
		db	 0Ah, 9Eh, 0Ah, 9Fh, 07h, 9Eh
		db	 01h, 60h, 06h, 5Fh, 08h, 9Eh
		db	 01h, 9Fh, 07h, 9Eh, 0Ah, 5Fh
		db	 0Ah, 9Eh, 01h, 9Fh, 07h, 9Eh
		db	 0Ah, 5Fh, 05h, 9Eh, 01h, 9Fh
		db	 08h, 9Eh, 09h, 45h, 17h, 46h
		db	 79h, 45h, 18h, 9Eh, 09h, 9Fh
		db	 07h, 9Eh, 01h, 5Fh, 06h, 9Eh
		db	 09h, 9Fh, 08h, 9Eh, 01h, 5Fh
		db	 0Ah, 9Eh, 09h, 9Fh, 08h, 9Eh
		db	 01h, 5Fh, 0Eh, 9Eh, 01h, 9Fh
		db	 07h, 9Eh, 0Ah, 5Fh, 0Ah, 9Eh
		db	 01h, 9Fh, 07h, 9Eh, 0Ah, 5Fh
		db	 05h, 9Eh, 01h, 9Fh, 08h, 9Eh
		db	 09h, 45h, 17h, 46h, 79h, 45h
		db	 17h, 9Eh, 0Ah, 9Fh, 07h, 9Eh
		db	 01h, 5Fh, 06h, 9Eh, 09h, 9Fh
		db	 08h, 9Eh, 01h, 5Fh, 0Ah, 9Eh
		db	 09h, 9Fh, 08h, 9Eh, 01h, 5Fh
		db	 0Eh, 9Eh, 01h, 9Fh, 07h, 9Eh
		db	 0Ah, 5Fh, 0Ah, 9Eh, 01h, 9Fh
		db	 08h, 9Eh, 09h, 5Fh, 02h, 45h
		db	 03h, 9Eh, 01h, 9Fh, 08h, 9Eh
		db	 09h, 45h, 18h, 46h, 35h,0E0h
		db	 0Dh, 46h, 36h, 45h, 17h, 9Eh
		db	 0Ah, 9Fh, 07h, 9Eh, 01h, 45h
		db	 01h
		db	5Fh

locloop_c_70ED:
		add	ax,99Eh
		lahf				; Load ah from flags
		pop	es
		sahf				; Store ah into flags
		add	[bx+0Ah],bx
		sahf				; Store ah into flags
		or	bl,byte ptr data_c_9E06+1[bx]
		add	[bx+0Fh],bx
		sahf				; Store ah into flags
		add	data_c_9E08[bx],bx
		or	[bx+0Ah],bx
		sahf				; Store ah into flags
		add	data_c_9E08[bx],bx
		or	[di+5],ax
		sahf				; Store ah into flags
		add	data_c_9E08[bx],bx
		or	[di+18h],ax
		inc	si
		sub	al,0E0h
		pop	ds
		inc	si
		sub	ax,1745h
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[di+5],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[bx+0Ah],bx
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[bx+0Fh],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	bl,[bx+9]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+5],ax
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+18h],ax
		inc	si
		sub	ah,al
		and	ax,[bp+2Ah]
		inc	bp
		sbb	byte ptr ss:[9F0Ah][bp],bl
		pop	es
		sahf				; Store ah into flags
		add	[di+5],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[bx+0Ah],bx
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[bx+0Fh],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	bl,[bx+9]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+5],ax
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+18h],ax
		inc	si
		daa				; Decimal adjust
		loopnz	locloop_c_71B3		; Loop if zf=0, cx>0

		inc	si
		daa				; Decimal adjust
		inc	bp
		sbb	byte ptr ss:[9F0Ah][bp],bl
		pop	es
		sahf				; Store ah into flags
		add	[di+5],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[bx+0Ah],bx
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[bx+10h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E07h][bx],bx
		or	bl,[bx+9]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx

locloop_c_71B3:
		or	[di+5],ax
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+18h],ax
		inc	si
		and	sp,ax
		xor	[bp+23h],ax
		inc	bp
		sbb	byte ptr ss:[9F0Ah][bp],bl
		pop	es
		sahf				; Store ah into flags
		add	[di+5],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E07h][bx]
		add	[bx+9],bx
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[bx+10h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[bx+4],bx
		inc	bp
		add	ax,19Eh
		lahf				; Load ah from flags
		or	byte ptr ss:[450Ah][bp],bl
		add	al,9Eh
		add	word ptr ds:[9E08h][bx],bx
		or	[di+19h],ax
		inc	si
;*		and	ax,sp
		db	 21h,0E0h		;  Fixup - byte match
		xor	ax,[bp+22h]
		inc	bp
		sbb	byte ptr ss:[9F0Ah][bp],bl
		pop	es
		sahf				; Store ah into flags
		add	[di+5],ax
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+3],ax
		pop	di
		push	es
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[bx+10h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+8]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+4]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+19h],ax
		inc	si
		pop	ds
		loopnz	locloop_c_726D		; Loop if zf=0, cx>0

		inc	si
		and	[di+18h],al
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+5],ax
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+8],ax
		pop	di
		add	word ptr ss:[9F0Ah][bp],bx
		or	byte ptr ss:[5F01h][bp],bl
		adc	byte ptr ss:[9F01h][bp],bl
		or	byte ptr ss:[450Ah][bp],bl
		or	byte ptr ss:[9F01h][bp],bl
		or	byte ptr ss:[450Ah][bp],bl
		add	al,9Eh
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+18h]
		inc	si

locloop_c_726D:
		sbb	ax,3BE0h
		inc	si
		sbb	ax,1945h
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+5],ax
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+9],ax
		sahf				; Store ah into flags
		or	bl,ds:d_EB44_9E07_e[bx]
		add	[bx+11h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+9]
		sahf				; Store ah into flags
		add	ds:d_EB44_9E07_e[bx],bx
		or	al,[di+4]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+18h]
		inc	si
		sbb	sp,ax
		aas				; Ascii adjust
		inc	si
		sbb	ax,[di+19h]
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+5],ax
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+9],ax
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[bx+11h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+9]
		sahf				; Store ah into flags
		add	ds:d_EB44_9E07_e[bx],bx
		or	al,[di+4]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+18h]
		inc	si
		sbb	ah,al
		inc	cx
		inc	si
		sbb	al,[di+19h]
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+4],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+8],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[bx+12h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+9],ax
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+4],ax
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+19h]
		inc	si
		pop	ss
		loopnz	locloop_c_735D		; Loop if zf=0, cx>0

		inc	si
		sbb	[di+19h],al
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+4],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+8],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[bx+12h],bx
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+8]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	[di+4],ax
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+19h]
		inc	si
		push	ss
		loopnz	locloop_c_7397		; Loop if zf=0, cx>0

		inc	si
		pop	ss
		inc	bp
		sbb	word ptr ss:[9F09h][bp],bx
		or	byte ptr ss:[4501h][bp],bl
		add	al,9Eh

locloop_c_735D:
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+8],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[bx+11h],bx
		inc	bp
		add	word ptr ss:[9F01h][bp],bx
		or	byte ptr ss:[450Ah][bp],bl
		or	byte ptr ss:[9F01h][bp],bl
		or	byte ptr ss:[4509h][bp],bl
		add	al,9Eh
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+1Ah]
		inc	si
		adc	al,0E0h
		dec	cx
		inc	si
		adc	al,45h			; 'E'
		sbb	bx,word ptr ss:[9F09h][bp]
		or	byte ptr ss:[4501h][bp],bl
		add	al,9Eh

locloop_c_7397:
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+8],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[bx+10h],bx
		inc	bp
		add	bl,byte ptr ss:[9F01h][bp]
		or	byte ptr ss:[450Ah][bp],bl
		or	byte ptr ss:[9F01h][bp],bl
		or	byte ptr ss:[4509h][bp],bl
		add	al,9Eh
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+12h]
		bound	ax,dword ptr [bx]
		inc	si
		adc	al,0E0h
		dec	bx
		inc	si
		adc	al,62h			; 'b'
		add	al,45h			; 'E'
		push	ss
		sahf				; Store ah into flags
		or	word ptr ds:[9E08h][bx],bx
		add	[di+4],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+7],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+2],ax
		pop	di
		push	cs
		inc	bp
		add	bx,word ptr ss:[9F01h][bp]
		or	byte ptr ss:[450Ah][bp],bl
		or	byte ptr ss:[9F01h][bp],bl
		or	byte ptr ss:[450Ah][bp],bl
		add	bx,word ptr ss:[9F01h][bp]
		or	byte ptr ss:[450Ah][bp],bl
		or	al,62h			; 'b'
		or	ax,1346h
		loopnz	$+4Fh			; Loop if zf=0, cx>0

		inc	si
		adc	sp,[bp+si+0Ah]
		inc	bp
		adc	byte ptr ss:[9F09h][bp],bl
		or	byte ptr ss:[4501h][bp],bl
		add	al,9Eh
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+7],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+3],ax
		pop	di
		or	al,45h			; 'E'
		add	al,9Eh
		add	ds:d_EB44_9E09_e[bx],bx
		or	al,[di+7]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+3]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+6]
		bound	dx,dword ptr [si]
		inc	si
;*		adc	ax,sp
		db	 11h,0E0h		;  Fixup - byte match
		dec	di
		inc	si
		adc	ah,[bp+si+10h]
		inc	bp
		or	bl,byte ptr ss:[9F09h][bp]
		or	byte ptr ss:[4501h][bp],bl
		add	al,9Eh
		or	ds:d_EB44_9E09_e[bx],bx
		add	[di+7],ax
		sahf				; Store ah into flags
		or	bl,byte ptr ds:[9E08h][bx]
		add	[di+4],ax
		pop	di
		or	ax,[di+5]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+7]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	al,[di+3]
		sahf				; Store ah into flags
		add	word ptr ds:[9E08h][bx],bx
		or	ah,[bp+si+12h]
		db	 63h, 08h, 46h, 10h,0E0h, 51h
		db	 46h, 11h, 63h, 07h, 62h, 0Fh
		db	 45h, 03h, 9Eh, 0Ah, 9Fh, 08h
		db	 9Eh, 01h, 45h, 04h, 9Eh, 09h
		db	 9Fh, 09h, 9Eh, 01h, 45h, 07h
		db	 9Eh, 0Ah, 9Fh, 08h, 9Eh, 01h
		db	 45h, 04h, 5Fh, 0Bh, 45h, 05h
		db	 9Eh, 01h, 9Fh, 08h, 9Eh, 0Ah
		db	 45h, 07h, 9Eh, 01h, 9Fh, 08h
		db	 9Eh, 0Ah, 45h, 03h, 9Eh, 01h
		db	 9Fh, 08h, 9Eh, 0Ah, 62h, 0Bh
		db	 63h, 0Fh, 46h, 0Fh,0E0h, 53h
		db	 46h, 0Fh, 63h, 0Fh, 62h, 0Bh
		db	 9Eh, 0Ah, 9Fh, 08h, 9Eh, 01h
		db	 45h, 04h, 9Eh, 05h, 12h, 05h
		db	 9Fh, 01h,0A1h, 05h, 9Fh, 01h
		db	 9Eh, 01h, 11h, 06h, 45h, 02h
		db	0A2h, 04h, 9Eh, 05h, 10h, 02h
		db	 9Fh, 01h, 10h, 02h, 9Fh, 02h
		db	0A0h, 02h, 9Eh, 01h, 45h, 03h
		db	 12h, 06h, 5Fh, 06h, 45h, 05h
		db	 9Eh, 01h, 9Fh, 08h, 9Eh, 0Ah
		db	 45h, 07h, 9Eh, 01h, 9Fh, 08h
		db	 9Eh, 0Ah, 45h, 03h, 9Eh, 01h
		db	 9Fh, 09h, 9Eh, 09h, 62h, 06h
		db	 63h, 14h, 46h, 0Fh,0E0h, 53h
		db	 46h, 0Fh, 63h, 14h, 62h, 06h
		db	 9Eh, 0Ah, 9Fh, 08h, 9Eh, 01h
		db	 45h, 03h, 9Eh, 02h, 12h, 07h
		db	0A1h, 07h, 9Fh, 01h, 11h, 07h
		db	0A2h, 07h, 9Eh, 01h, 10h, 07h
		db	0A0h, 07h, 45h, 01h, 12h, 08h
		db	0A2h, 03h, 5Fh, 02h,0A2h, 01h
		db	 45h, 05h, 9Eh, 01h, 9Fh, 08h
		db	 9Eh, 0Ah, 45h, 07h, 9Eh, 01h
		db	 9Fh, 08h, 9Eh, 0Ah, 45h, 03h
		db	 9Eh, 01h, 9Fh, 09h, 9Eh, 09h
		db	 63h, 15h, 64h, 05h, 46h, 0Eh
		db	0E0h, 55h, 46h, 0Eh, 64h, 05h
		db	 63h, 02h, 10h, 02h, 63h, 01h
		db	 10h, 02h, 63h, 04h,0A0h, 03h
		db	 63h, 07h, 9Eh, 0Ah, 9Fh, 06h
		db	 10h, 02h, 9Eh, 01h, 10h, 01h
		db	 45h, 01h, 10h, 03h,0A0h, 02h
		db	 12h, 01h,0A0h, 03h,0A1h, 06h
		db	 9Fh, 02h, 11h, 07h,0A2h, 06h
		db	 9Eh, 02h, 10h, 07h,0A0h, 06h
		db	 9Eh, 01h, 45h, 01h, 12h, 07h
		db	0A1h, 02h,0A2h, 05h, 5Fh, 02h
		db	 45h, 03h,0A2h, 04h, 9Fh, 05h
		db	0A4h, 02h, 9Eh, 01h,0A4h, 03h
		db	 9Eh, 03h,0A4h, 02h,0A3h, 03h
		db	 45h, 02h,0A3h, 01h, 45h, 01h
		db	 9Eh, 01h, 9Fh, 09h, 9Eh, 09h
		db	 62h, 03h, 9Eh, 01h, 9Fh, 09h
		db	 9Eh, 09h, 63h, 0Fh, 64h, 0Ch
		db	 46h, 0Ch,0E0h, 57h, 46h, 07h
		db	 11h, 02h, 46h, 03h, 11h, 01h
		db	 64h, 05h,0A2h, 01h, 10h, 07h
		db	0A0h, 06h, 63h, 07h, 9Eh, 09h
		db	 11h, 02h, 9Fh, 01h, 11h, 02h
		db	 10h, 01h, 11h, 01h,0A2h, 03h
		db	 10h, 02h,0A2h, 01h,0A0h, 06h
		db	 12h, 01h,0A1h, 06h, 9Fh, 02h
		db	 11h, 07h,0A2h, 06h, 9Eh, 01h
		db	 10h, 07h,0A0h, 07h, 9Fh, 01h
		db	 12h, 08h,0A1h, 03h,0A2h, 06h
		db	 5Fh, 02h, 45h, 01h,0A2h, 07h
		db	0A4h, 06h, 9Eh, 01h,0A4h, 07h
		db	0A3h, 06h, 45h, 01h, 9Eh, 01h
		db	0A3h, 01h, 9Fh, 01h,0A3h, 03h
		db	 9Fh, 01h,0A3h, 01h, 9Fh, 01h
		db	0A2h, 01h, 9Eh, 01h,0A2h, 02h
		db	 9Eh, 06h, 62h, 01h,0A2h, 01h
		db	 62h, 01h,0A2h, 03h, 9Fh, 01h
		db	0A2h, 01h, 9Fh, 01h,0A4h, 01h
		db	 9Fh, 01h,0A4h, 01h, 9Fh, 01h
		db	 9Eh, 09h, 63h, 0Bh, 64h, 10h
		db	 46h, 0Ch,0E0h, 44h, 10h, 07h
		db	0A0h, 06h,0E0h, 05h, 12h, 01h
		db	 46h, 02h, 12h, 02h, 46h, 01h
		db	 11h, 02h,0A1h, 01h, 11h, 01h
		db	0A1h, 01h, 11h, 02h,0A2h, 06h
		db	 10h, 06h,0A0h, 07h, 63h, 06h
		db	 12h, 01h, 63h, 01h, 9Eh, 03h
		db	 12h, 02h, 9Eh, 01h,0A1h, 03h
		db	 11h, 05h,0A2h, 07h,0A0h, 05h
		db	 12h, 01h,0A1h, 07h, 9Fh, 01h
		db	 11h, 07h,0A2h, 07h, 9Eh, 01h
		db	 10h, 07h,0A0h, 06h, 9Fh, 02h
		db	 12h, 07h,0A1h, 05h,0A3h, 01h
		db	0A2h, 07h, 5Fh, 01h, 45h, 01h
		db	0A2h, 07h,0A4h, 06h, 9Eh, 01h
		db	0A4h, 07h,0A3h, 0Dh,0A2h, 06h
		db	 9Eh, 06h,0A2h, 07h,0A4h, 06h
		db	 9Eh, 02h,0A4h, 06h,0A3h, 02h
		db	 63h, 02h,0A3h, 01h, 63h, 01h
		db	0A3h, 02h, 64h, 06h,0A3h, 01h
		db	 64h, 09h,0A2h, 01h, 64h, 01h
		db	 65h, 02h, 46h, 0Bh,0E0h, 2Eh
		db	 12h, 02h,0E0h, 01h, 12h, 02h
		db	0E0h, 01h, 12h, 02h,0E0h, 02h
		db	0A1h, 03h,0E0h, 02h, 11h, 04h
		db	0E0h, 03h, 10h, 01h,0A2h, 05h
		db	 10h, 01h,0A0h, 06h,0E0h, 04h
		db	 12h, 07h,0A1h, 07h,0A2h, 06h
		db	 10h, 06h,0A0h, 06h, 64h, 03h
		db	 63h, 03h, 12h, 07h,0A1h, 07h
		db	 11h, 03h,0A2h, 06h,0A0h, 06h
		db	 12h, 01h,0A1h, 06h, 9Fh, 02h
		db	 11h, 07h,0A2h, 06h, 9Eh, 01h
		db	 10h, 07h,0A0h, 07h, 9Fh, 01h
		db	 12h, 08h,0A1h, 06h,0A3h, 02h
		db	0A2h, 07h, 5Fh, 01h, 45h, 01h
		db	0A2h, 07h,0A4h, 0Eh,0A3h, 0Dh
		db	0A2h, 06h, 9Eh, 06h,0A2h, 07h
		db	0A4h, 06h, 9Eh, 01h,0A4h, 07h
		db	0A3h, 06h, 64h, 05h,0A3h, 07h
		db	0A2h, 06h, 65h, 03h, 46h, 01h
		db	0A2h, 04h,0A4h, 02h, 46h, 03h
		db	0A4h, 01h,0E0h, 02h,0A4h, 01h
		db	0E0h, 01h,0A4h, 03h,0E0h, 06h
		db	0A3h, 03h,0E0h, 01h,0A3h, 02h
		db	0E0h, 19h, 10h, 04h,0A0h, 02h
		db	 12h, 01h,0A0h, 03h,0A1h, 04h
		db	 11h, 07h,0A2h, 07h, 10h, 01h
		db	0A0h, 07h,0E0h, 04h, 12h, 07h
		db	0A1h, 06h,0A2h, 06h, 10h, 07h
		db	0A0h, 06h, 64h, 05h, 12h, 07h
		db	0A1h, 07h, 11h, 03h,0A2h, 07h
		db	0A0h, 05h, 12h, 02h,0A1h, 06h
		db	 9Eh, 01h, 9Fh, 01h, 11h, 07h
		db	0A2h, 06h, 45h, 01h, 10h, 07h
		db	0A0h, 06h, 9Fh, 02h, 12h, 07h
		db	0A1h, 06h, 11h, 02h,0A3h, 04h
		db	0A2h, 07h, 45h, 01h, 9Eh, 01h
		db	0A2h, 07h,0A4h, 06h, 9Eh, 01h
		db	0A4h, 07h,0A3h, 0Ch,0A2h, 07h
		db	 9Eh, 04h, 45h, 01h,0A2h, 07h
		db	0A4h, 0Eh,0A3h, 06h, 64h, 05h
		db	0A3h, 07h,0A2h, 06h, 65h, 02h
		db	0A2h, 07h,0A4h, 06h,0E0h, 03h
		db	0A4h, 07h,0A3h, 06h, 12h, 01h
		db	0E0h, 01h,0A3h

locloop_c_77DD:
		add	ah,al
		add	word ptr ss:[0A102h][bp+di],sp
		add	al,0A2h
		add	dl,[bx+di]
;*		add	ax,sp
		db	 01h,0E0h		;  Fixup - byte match
		add	[bx+di],dx
		add	word ptr ss:[1101h][bp+si],sp
		add	word ptr ss:[0E002h][bp+si],sp
		add	[bx+si],dx
		add	word ptr ss:[1001h][bp+si],sp
		add	sp,word ptr ss:[1001h][bp+si]
		add	word ptr ds:d_EB44_A401_e+1[bx+si],sp
		add	ds:d_EB44_A401_e[bx+si],sp
		add	ds:d_EB44_A102_e[bx+si],sp
		add	sp,ax
		add	[bx+di],dx
		pop	es
		mov	ds:d_EB44_1006_e,al
		add	ah,ds:d_EB44_E006_e[bx+si]
		add	al,12h
		pop	es
		mov	ax,ds:d_EB44_A207_e
		push	es
		adc	[bx],al
		mov	al,ds:d_EB44_6406_e
		add	al,12h
		pop	es
		mov	ax,ds:d_EB44_1107_e
		add	al,0A2h
		push	es
		mov	al,ds:d_EB44_1206_e
		add	ds:d_EB44_9E07_e[bx+di],sp
		add	[bx+di],dx
		pop	es
		mov	ds:d_EB44_1007_e,al
		pop	es
		mov	al,ds:d_EB44_9F07_e
		add	[bp+si],dx
		pop	es
		mov	ax,ds:d_EB44_1107_e
		add	sp,word ptr ss:[0A206h][bp+di]
		push	es
		sahf				; Store ah into flags
		add	ds:d_EB44_A201_e[bx],bx
		pop	es
		movsb				; Mov [si] to es:[di]
		push	cs
		mov	ds:d_EB44_A20D_e,ax
		push	es
		sahf				; Store ah into flags
		add	ax,[di+2]
		sahf				; Store ah into flags
		add	word ptr ss:[0A407h][bp+si],sp
		or	ax,7A3h
		db	 64h, 04h,0A3h, 07h,0A2h, 07h
		db	 65h, 01h,0A2h, 07h,0A4h, 06h
		db	0E0h, 03h,0A4h, 07h,0A3h, 06h
		db	 12h, 02h,0A3h, 07h,0A2h, 11h
		db	0A4h, 06h,0A1h, 04h, 11h, 02h
		db	0A4h, 04h, 11h, 01h,0A2h, 03h
		db	0A3h, 03h,0A2h, 01h, 10h, 02h
		db	0A0h, 02h,0A3h, 02h,0A0h, 01h
		db	0A3h, 02h,0E0h, 02h,0A2h, 02h
		db	 12h, 06h,0A1h, 06h, 11h, 01h
		db	0A2h, 06h, 10h, 06h,0A0h, 07h
		db	 64h, 04h, 12h, 07h,0A1h, 06h
		db	 11h, 04h,0A2h, 07h,0A0h, 05h
		db	 12h, 02h,0A1h, 06h, 9Eh, 02h
		db	 11h, 07h,0A2h, 06h, 45h, 01h
		db	 10h, 07h,0A0h, 06h, 9Fh, 02h
		db	 12h, 07h,0A1h, 06h, 11h, 05h
		db	 5Fh, 01h,0A3h, 06h,0A2h, 07h
		db	 9Fh, 02h,0A2h, 07h,0A4h, 06h
		db	 9Eh, 01h,0A4h, 07h,0A3h, 0Ch
		db	0A2h, 07h, 9Eh, 01h, 45h, 02h
		db	0A1h, 02h,0A2h, 07h,0A4h, 0Eh
		db	0A3h, 06h, 64h, 01h,0A0h, 04h
		db	0A3h, 07h,0A2h, 06h,0A1h, 01h
		db	0A2h, 07h,0A4h, 07h,0A2h, 01h
		db	 10h, 01h,0A4h, 07h,0A3h, 07h
		db	0A1h, 01h,0A3h, 07h,0A2h, 09h
		db	 10h, 01h,0A2h, 07h,0A4h, 06h
		db	0A1h, 02h, 11h, 02h,0A4h, 07h
		db	0A3h, 06h, 10h, 01h,0A0h, 02h
		db	0A3h, 07h,0A2h, 06h, 12h, 01h
		db	0A1h, 03h,0A2h, 03h,0A1h, 01h
		db	0A2h, 01h,0A4h, 03h,0A2h, 01h
		db	0A4h, 03h, 10h, 02h,0A4h, 07h
		db	0A0h, 02h,0A4h, 01h, 65h, 01h
		db	0A3h, 02h, 12h, 07h,0A1h, 07h
		db	 11h, 04h,0A2h, 06h,0A0h, 06h
		db	 12h, 02h,0A1h, 06h, 9Eh, 02h
		db	 11h, 07h,0A2h, 06h, 45h, 01h
		db	 10h, 07h,0A0h, 06h, 9Eh, 01h
		db	 9Fh, 01h, 12h, 07h,0A1h, 06h
		db	 11h, 06h, 5Fh, 02h,0A3h, 07h
		db	0A2h, 06h, 9Fh, 02h,0A2h, 07h
		db	0A4h, 0Eh,0A3h, 0Dh,0A2h, 06h
		db	0A1h, 05h, 9Fh, 01h,0A2h, 07h
		db	0A4h, 0Dh,0A3h, 07h,0A0h, 03h
		db	 12h, 01h,0A3h, 07h,0A2h, 07h
		db	 11h, 01h,0A2h, 07h,0A4h, 06h
		db	 10h, 03h,0A4h, 07h,0A3h, 06h
		db	0A1h, 01h,0A3h, 07h,0A2h, 07h
		db	 10h, 03h,0A2h, 07h,0A4h, 07h
		db	 11h, 03h,0A4h, 07h,0A3h, 06h
		db	0A0h, 03h,0A3h, 07h,0A2h, 06h
		db	0A1h, 02h,0A2h, 07h,0A4h, 06h
		db	 10h, 04h,0A4h, 07h,0A3h, 08h
		db	 12h, 01h,0A1h, 01h,0A3h, 04h
		db	0A1h, 02h,0A2h, 01h, 11h, 01h
		db	0A2h, 0Ah,0A0h, 03h,0A2h, 03h
		db	 12h, 01h,0A4h, 02h,0A1h, 01h
		db	0A4h, 03h, 9Eh, 02h, 11h, 07h
		db	0A2h, 06h, 45h, 02h, 10h, 07h
		db	0A0h, 06h, 9Fh, 02h, 12h, 07h
		db	0A1h, 06h, 11h, 06h, 5Fh, 03h
		db	0A3h, 07h,0A2h, 07h, 9Fh, 02h
		db	0A2h, 07h,0A4h, 06h, 11h, 01h
		db	0A4h, 07h,0A3h, 0Ch,0A2h, 07h
		db	0A1h, 01h, 9Fh, 04h,0A2h, 07h
		db	0A4h, 0Eh,0A3h, 06h, 65h, 01h
		db	 12h, 04h,0A3h, 07h,0A2h, 06h
		db	 11h, 01h,0A2h, 07h,0A4h, 07h
		db	 10h, 02h,0A4h, 07h,0A3h, 07h
		db	 11h, 01h,0A3h, 07h,0A2h, 06h
		db	 10h, 02h,0A0h, 02h,0A2h, 07h
		db	0A4h, 06h, 11h, 03h,0A4h, 07h
		db	0A3h, 07h,0A0h, 01h,0E0h, 01h
		db	0A3h, 07h,0A2h, 07h,0A1h, 01h
		db	0A2h, 07h,0A4h, 06h, 10h, 02h
		db	0A0h, 02h,0A4h, 07h,0A3h, 06h
		db	0A1h, 01h,0A3h, 07h,0A2h, 0Ah
		db	0A0h, 02h,0A2h, 07h,0A4h, 06h
		db	0A1h, 01h, 9Eh, 02h, 11h, 03h
		db	0A4h, 02h, 11h, 01h,0A4h, 02h
		db	0A2h, 03h,0A3h, 04h, 10h, 01h
		db	0A3h, 06h,0A0h, 04h,0A2h, 04h
		db	 12h, 07h,0A1h, 06h, 11h, 06h
		db	 5Fh, 05h,0A3h, 07h,0A2h, 06h
		db	 12h, 02h,0A2h, 07h,0A4h, 0Eh
		db	0A3h, 0Dh,0A2h, 06h, 9Fh, 06h
		db	0A2h, 07h,0A4h, 0Dh,0A3h, 07h
		db	 12h, 04h,0A3h, 07h,0A2h, 0Fh
		db	0A4h, 06h,0A0h, 03h,0A4h, 07h
		db	0A3h, 06h, 11h, 01h,0A3h, 07h
		db	0A2h, 07h,0A0h, 03h,0A2h, 07h
		db	0A4h, 07h,0A2h, 03h,0A4h, 07h
		db	0A3h, 06h,0E0h, 02h, 12h, 01h
		db	0A3h, 07h,0A2h, 06h, 11h, 01h
		db	0A2h, 07h,0A4h, 07h,0A0h, 03h
		db	0A4h, 07h,0A3h, 0Eh,0A2h, 08h
		db	 10h, 01h,0A0h, 03h,0A2h, 07h
		db	0A4h, 06h, 9Eh, 02h, 11h, 03h
		db	0A4h, 07h,0A3h, 06h, 10h, 02h
		db	0A3h, 07h,0A2h, 06h, 12h, 06h
		db	0A1h, 06h, 11h, 06h, 5Fh, 05h
		db	0A3h, 07h,0A2h, 06h, 12h, 03h
		db	0A1h, 01h,0A2h, 07h,0A4h, 06h
		db	0A2h, 01h,0A4h, 07h,0A3h, 0Ch
		db	0A2h, 07h, 9Fh, 02h, 11h, 03h
		db	0A2h, 07h,0A4h, 0Eh,0A3h, 06h
		db	 12h, 02h,0A1h, 03h,0A3h, 07h
		db	0A2h, 0Eh,0A4h, 07h,0A0h, 02h
		db	0A4h, 07h,0A3h, 07h,0A2h, 01h
		db	0A3h, 07h,0A2h, 06h,0A0h, 03h
		db	0A1h, 01h,0A2h, 07h,0A4h, 06h
		db	0A2h, 03h,0A4h, 07h,0A3h, 07h
		db	 12h, 02h,0A3h, 07h,0A2h, 0Fh
		db	0A4h, 06h,0A0h, 04h,0A4h, 07h
		db	0A3h, 0Dh,0A2h, 07h, 10h, 01h
		db	0A0h, 04h,0A2h, 07h,0A4h, 07h
		db	 11h, 04h,0A4h, 07h,0A3h, 06h
		db	 10h, 02h,0A3h, 07h,0A2h, 06h
		db	 12h, 05h,0A1h, 06h, 11h, 05h
		db	 5Fh, 06h,0A3h, 07h,0A2h, 06h
		db	 12h, 02h,0A1h, 02h,0A2h, 07h
		db	0A4h, 06h,0A2h, 01h,0A4h, 07h
		db	0A3h, 06h, 12h, 01h,0A3h, 07h
		db	0A2h, 06h, 11h, 06h,0A2h, 07h
		db	0A4h, 0Dh,0A3h, 07h,0A1h, 04h
		db	0A3h, 07h,0A2h, 07h, 10h, 01h
		db	0A2h, 07h,0A4h, 06h, 12h, 01h
		db	0A1h, 02h,0A4h, 07h,0A3h, 06h
		db	0A2h, 01h,0A3h, 07h,0A2h, 07h
		db	0A1h, 03h,0A2h, 07h,0A4h, 07h
		db	 10h, 03h,0A4h, 07h,0A3h, 06h
		db	 12h, 03h,0A3h, 07h,0A2h, 0Eh
		db	0A4h, 07h,0A0h, 02h, 65h, 01h
		db	0A4h, 07h,0A3h, 0Eh,0A2h, 06h
		db	0A0h, 06h,0A2h, 07h,0A4h, 06h
		db	 11h, 04h,0A4h, 07h,0A3h, 07h
		db	 10h, 01h,0A3h, 07h,0A2h, 07h
		db	 12h, 02h,0A1h, 06h, 11h, 06h
		db	 5Fh, 06h,0A3h, 07h,0A2h, 06h
		db	0A1h, 04h,0A2h, 07h,0A4h, 06h
		db	 10h, 01h,0A4h, 07h,0A3h, 06h
		db	0A1h, 01h,0A3h, 07h,0A2h, 06h
		db	 11h, 05h,0A2h, 08h,0A4h, 06h
		db	0A0h, 02h,0A4h, 07h,0A3h, 06h
		db	0A1h, 02h, 11h, 03h,0A3h, 07h
		db	0A2h, 06h, 10h, 01h,0A2h, 07h
		db	0A4h, 07h,0A1h, 02h,0A4h, 07h
		db	0A3h, 07h, 10h, 01h,0A3h, 07h
		db	0A2h, 06h,0A1h, 02h,0E0h, 01h
		db	 11h, 01h,0A2h, 07h,0A4h, 06h
		db	 10h, 03h,0A4h, 07h,0A3h, 07h
		db	 12h, 02h,0A3h, 07h,0A2h, 0Fh
		db	0A4h, 06h,0A0h, 01h, 65h, 02h
		db	 12h, 01h,0A4h, 07h,0A3h, 0Dh
		db	0A2h, 07h,0A0h, 04h, 12h, 01h
		db	0A2h, 07h,0A4h, 07h, 11h, 04h
		db	0A4h, 07h,0A3h, 06h, 10h, 01h
		db	0A0h, 01h,0A3h, 07h,0A2h, 06h
		db	 12h, 01h,0A1h, 06h, 11h, 07h
		db	 5Fh, 06h,0A3h, 07h,0A2h, 06h
		db	0A1h, 03h,0A2h, 07h,0A4h, 06h
		db	 10h, 01h,0A4h, 07h,0A3h, 06h
		db	0A1h, 01h,0A3h, 07h,0A2h, 06h
		db	 11h, 04h,0A2h, 09h,0A4h, 06h
		db	0A0h, 02h,0A4h, 07h,0A3h, 06h
		db	0A1h, 01h, 11h, 04h,0A3h, 07h
		db	0A2h, 06h, 10h, 03h,0A2h, 07h
		db	0A4h, 06h,0A1h, 02h, 11h, 01h
		db	0A4h, 07h,0A3h, 06h, 10h, 01h
		db	0A3h, 07h,0A2h, 07h,0E0h, 01h
		db	 11h, 02h,0A2h, 07h,0A4h, 07h
		db	 10h, 01h,0A0h, 02h,0A4h, 07h
		db	0A3h, 06h, 12h, 02h,0A1h, 01h
		db	0A3h, 07h,0A2h, 06h, 46h, 01h
		db	0A2h, 07h,0A4h, 07h, 65h, 01h
		db	 12h, 02h,0A4h, 07h,0A3h, 0Eh
		db	0A2h, 06h,0A0h, 02h, 12h, 04h
		db	0A2h, 07h,0A4h, 06h, 11h, 03h
		db	0A2h, 01h,0A4h, 07h,0A3h, 07h
		db	0A0h, 01h,0A3h, 07h,0A2h, 07h
		db	0A1h, 05h, 11h, 07h, 5Fh, 06h
		db	0A3h, 07h,0A2h, 06h,0A1h, 03h
		db	 11h, 01h,0A2h, 07h,0A4h, 06h
		db	0A0h, 01h,0A4h, 07h,0A3h, 0Dh
		db	0A2h, 06h, 11h, 02h,0A2h, 0Bh
		db	0A4h, 06h, 64h, 01h, 12h, 01h
		db	0A4h, 07h,0A3h, 06h, 11h, 05h
		db	0A3h, 07h,0A2h, 06h, 10h, 02h
		db	0A0h, 01h,0A2h, 07h,0A4h, 06h
		db	0A1h, 02h, 11h, 01h,0A4h, 07h
		db	0A3h, 06h, 10h, 03h,0A3h, 07h
		db	0A2h, 06h, 11h, 04h,0A2h, 07h
		db	0A4h, 06h,0A0h, 03h,0A4h, 07h
		db	0A3h, 07h,0A1h, 02h,0A3h, 07h
		db	0A2h, 07h, 10h, 01h,0A2h, 07h
		db	0A4h, 06h, 12h, 04h,0A4h, 07h
		db	0A3h, 0Dh,0A2h, 07h, 12h, 05h
		db	0A2h, 07h,0A4h, 07h, 11h, 01h
		db	0A2h, 03h,0A4h, 07h,0A3h, 06h
		db	0A0h, 02h,0A3h, 07h,0A2h, 06h
		db	0A1h, 04h, 11h, 07h, 5Fh, 06h
		db	0A3h, 07h,0A2h, 06h,0A1h, 02h
		db	 11h, 02h,0A2h, 07h,0A4h, 06h
		db	0A0h, 01h,0A4h, 07h,0A3h, 06h
		db	0A1h, 01h,0A3h, 07h,0A2h, 13h
		db	0A4h, 06h, 12h, 01h,0A4h, 07h
		db	0A3h, 06h, 11h, 05h,0A3h, 07h
		db	0A2h, 06h, 10h, 01h,0A0h, 02h
		db	0A2h, 07h,0A4h, 06h,0A1h, 02h
		db	 11h, 01h,0A4h, 07h,0A3h, 06h
		db	 10h, 03h,0A3h, 07h,0A2h, 06h
		db	 11h, 04h,0A2h, 07h,0A4h, 06h
		db	0A0h, 05h,0A4h, 07h,0A3h, 06h
		db	0A1h, 03h,0A3h, 07h,0A2h, 06h
		db	 10h, 01h,0A2h, 07h,0A4h, 07h
		db	 12h, 03h,0A4h, 07h,0A3h, 0Eh
		db	0A2h, 06h, 12h, 04h,0A1h, 02h
		db	0A2h, 07h,0A4h, 06h,0A2h, 04h
		db	0A4h, 07h,0A3h, 07h,0A0h, 01h
		db	0A3h, 07h,0A2h, 07h,0A1h, 02h
		db	 11h, 07h,0A3h, 01h, 5Fh, 05h
		db	0A3h, 07h,0A2h, 06h, 11h, 04h
		db	0A2h, 07h,0A4h, 06h,0A0h, 01h
		db	0A4h, 07h,0A3h, 06h, 9Eh, 01h
		db	0A3h, 07h,0A2h, 0Bh, 10h, 01h
		db	0A2h, 07h,0A4h, 06h, 12h, 02h
		db	0A4h, 07h,0A3h, 06h, 11h, 04h
		db	0A2h, 01h,0A3h, 07h,0A2h, 06h
		db	0A0h, 02h,0A2h, 07h,0A4h, 06h
		db	0A1h, 02h, 11h, 01h,0A4h, 07h
		db	0A3h, 06h, 10h, 03h,0A3h, 07h
		db	0A2h, 06h, 11h, 04h,0A2h, 07h
		db	0A4h, 06h,0A0h, 05h,0A4h, 07h
		db	0A3h, 06h,0A1h, 03h,0A3h, 07h
		db	0A2h, 06h, 10h, 03h,0A2h, 07h
		db	0A4h, 06h, 12h, 03h,0A1h, 01h
		db	0A4h, 07h,0A3h, 0Dh,0A2h, 07h
		db	 12h, 02h,0A1h, 03h,0A2h, 07h
		db	0A4h, 07h,0A2h, 04h,0A4h, 07h
		db	0A3h, 06h,0A0h, 01h, 9Fh, 01h
		db	0A3h, 07h,0A2h, 06h,0A1h, 01h
		db	 11h, 07h, 5Fh, 01h,0A3h, 01h
		db	 5Fh, 05h,0A3h, 07h,0A2h, 06h
		db	 11h, 03h,0A2h, 07h,0A4h, 06h
		db	0A0h, 01h,0A4h, 07h,0A3h, 06h
		db	 9Eh, 01h,0A3h, 07h,0A2h, 0Bh
		db	 10h, 01h,0A2h, 07h,0A4h, 06h
		db	 12h, 02h,0A4h, 07h,0A3h, 06h
		db	 11h, 04h,0A2h, 01h,0A3h, 07h
		db	0A2h, 06h,0A0h, 03h,0A2h, 07h
		db	0A4h, 06h,0A1h, 01h, 11h, 02h
		db	0A4h, 07h,0A3h, 06h, 10h, 02h
		db	0A3h, 07h,0A2h, 06h, 11h, 04h
		db	0A2h, 07h,0A4h, 06h,0A0h, 05h
		db	0A4h, 07h,0A3h, 06h,0A1h, 03h
		db	0A3h, 07h,0A2h, 06h, 10h, 03h
		db	0A2h, 07h,0A4h, 06h, 12h, 03h
		db	0A1h, 01h,0A4h, 07h,0A3h, 06h
		db	0A2h, 02h,0A3h, 07h,0A2h, 06h
		db	0A1h, 06h,0A2h, 07h,0A4h, 06h
		db	0A2h, 02h, 61h, 02h,0A4h, 07h
		db	0A3h, 07h, 9Fh, 01h,0A3h, 07h
		db	0A2h, 07h, 11h, 05h, 5Fh, 02h
		db	0A3h, 01h, 5Fh, 04h, 12h, 01h
		db	0A3h, 07h,0A2h, 06h, 11h, 03h
		db	0A2h, 08h,0A4h, 06h,0A0h, 01h
		db	0A4h, 07h,0A3h, 0Dh,0A2h, 0Bh
		db	 10h, 01h,0A2h, 07h,0A4h, 06h
		db	 12h, 02h,0A4h, 07h,0A3h, 06h
		db	 11h, 04h,0A2h, 01h,0A3h, 07h
		db	0A2h, 06h,0A0h, 03h,0A2h, 07h
		db	0A4h, 06h, 11h, 03h,0A4h, 07h
		db	0A3h, 06h, 10h, 02h,0A0h, 01h
		db	0A3h, 07h,0A2h, 06h, 11h, 04h
		db	0A2h, 07h,0A4h, 06h,0A0h, 04h
		db	0A4h, 07h,0A3h, 06h,0A1h, 03h
		db	0A3h, 07h,0A2h, 06h, 10h, 03h
		db	0A2h, 07h,0A4h, 06h, 12h, 03h
		db	0A1h, 01h,0A4h, 07h,0A3h, 06h
		db	0A2h, 02h,0A3h, 07h,0A2h, 06h
		db	0A1h, 06h,0A2h, 07h,0A4h, 06h
		db	0A2h, 02h, 61h, 01h, 10h, 03h
		db	0A4h, 07h,0A3h, 06h, 12h, 02h
		db	0A3h, 07h,0A2h, 06h, 11h, 04h
		db	0A2h, 01h, 5Fh, 01h,0A3h, 01h
		db	 5Fh, 04h, 12h, 01h,0A3h, 07h
		db	0A2h, 06h, 11h, 03h,0A2h, 08h
		db	0A4h, 06h,0A0h, 01h,0A4h, 07h
		db	0A3h, 06h, 9Eh, 01h,0A3h, 07h
		db	0A2h, 0Ah, 10h, 02h,0A2h, 07h
		db	0A4h, 06h, 12h, 01h,0A4h, 07h
		db	0A3h, 06h, 11h, 03h,0A2h, 02h
		db	0A3h, 07h,0A2h, 06h,0A0h, 03h
		db	0A2h, 07h,0A4h, 06h, 11h, 03h
		db	0A4h, 07h,0A3h, 06h, 10h, 02h
		db	0A0h, 01h,0A3h, 07h,0A2h, 06h
		db	 11h, 04h,0A2h, 07h,0A4h, 06h
		db	0A0h, 04h, 46h, 01h,0A4h, 07h
		db	0A3h, 06h,0A1h, 03h,0A3h, 07h
		db	0A2h, 06h, 10h, 02h,0A2h, 07h
		db	0A4h, 06h, 12h, 03h,0A1h, 01h
		db	0A4h, 07h,0A3h, 06h,0A2h, 02h
		db	0A3h, 07h,0A2h, 06h,0A1h, 06h
		db	0A2h, 07h,0A4h, 06h,0A2h, 02h
		db	 61h, 01h, 10h, 03h,0A4h, 07h
		db	0A3h, 06h, 12h, 02h,0A3h, 07h
		db	0A2h, 06h, 11h, 04h,0A2h, 01h
		db	0A3h, 02h, 5Fh, 04h, 12h, 01h
		db	0A3h, 07h,0A2h, 06h, 11h, 03h
		db	0A2h, 08h,0A4h, 06h,0A0h, 01h
		db	0A4h, 07h,0A3h, 06h, 9Eh, 01h
		db	0A3h, 07h,0A2h, 0Ah, 10h, 02h
		db	0A2h, 07h,0A4h, 06h, 12h, 02h
		db	0A4h, 07h,0A3h, 06h, 11h, 02h
		db	0A2h, 03h,0A3h, 07h,0A2h, 06h
		db	0A0h, 02h,0A2h, 07h,0A4h, 06h
		db	 11h, 03h,0A4h, 07h,0A3h, 06h
		db	 10h, 02h,0A0h, 01h,0A3h, 07h
		db	0A2h, 06h, 11h, 04h,0A2h, 07h
		db	0A4h, 06h,0A0h, 04h, 66h, 01h
		db	0A4h, 07h,0A3h, 06h,0A1h, 03h
		db	0A3h, 07h,0A2h, 06h, 10h, 03h
		db	0A2h, 07h,0A4h, 06h, 12h, 02h
		db	0A1h, 02h,0A4h, 07h,0A3h
data_c_8001	dw	0A206h			; Data table (indexed access)
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 06h,0A2h, 07h,0A4h, 06h,0A2h
		db	 02h, 61h, 01h, 10h, 03h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 07h,0A2h, 06h, 11h, 04h,0A2h
		db	 01h, 5Fh, 01h,0A3h, 02h, 5Fh
		db	 03h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 02h,0A2h, 08h,0A4h
		db	 06h,0A0h, 01h,0A4h, 07h,0A3h
		db	 06h, 9Eh, 01h,0A3h, 07h,0A2h
		db	 09h, 10h, 03h,0A2h, 07h,0A4h
		db	 06h, 12h, 02h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A0h
		db	 01h,0A3h, 07h,0A2h, 06h, 11h
		db	 04h,0A2h, 07h,0A4h, 06h,0A0h
		db	 04h, 66h, 01h,0A4h, 07h,0A3h
		db	 06h,0A1h, 03h,0A3h, 07h,0A2h
		db	 06h, 10h, 02h,0A0h, 01h,0A2h
		db	 07h,0A4h, 06h, 12h, 01h,0A1h
		db	 03h,0A4h, 07h,0A3h, 06h,0A2h
		db	 01h, 10h, 01h,0A3h, 07h,0A2h
		db	 06h,0A1h, 05h, 9Eh, 01h,0A2h
		db	 07h,0A4h, 06h,0A2h, 01h, 61h
		db	 01h, 10h, 03h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 04h,0A2h, 01h, 5Fh
		db	 01h,0A3h, 02h, 5Fh, 03h, 12h
		db	 02h,0A3h, 07h,0A2h, 06h, 11h
		db	 01h,0A2h, 0Ah,0A4h, 06h, 12h
		db	 01h,0A4h, 07h,0A3h, 0Dh,0A2h
		db	 09h, 10h, 03h,0A2h, 07h,0A4h
		db	 06h, 12h, 02h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h, 11h
		db	 04h,0A2h, 07h,0A4h, 06h,0A0h
		db	 03h, 65h, 01h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h, 11h, 01h,0A3h
		db	 07h,0A2h, 06h, 10h, 02h,0A0h
		db	 01h,0A2h, 07h,0A4h, 06h, 12h
		db	 01h,0A1h, 03h,0A4h, 07h,0A3h
		db	 06h,0A2h, 01h, 10h, 01h,0A3h
		db	 07h,0A2h, 06h,0A1h, 05h, 9Eh
		db	 01h,0A2h, 07h,0A4h, 06h,0A2h
		db	 01h, 60h, 01h, 10h, 04h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 07h,0A2h, 06h, 11h, 02h,0A2h
		db	 01h, 5Fh, 02h,0A3h, 02h, 5Fh
		db	 03h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 01h,0A2h, 0Ah,0A4h
		db	 06h, 12h, 01h,0A4h, 07h,0A3h
		db	 06h, 9Eh, 01h,0A3h, 07h,0A2h
		db	 08h, 10h, 04h,0A2h, 07h,0A4h
		db	 06h, 12h, 01h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h, 11h
		db	 03h,0A2h, 08h,0A4h, 06h,0A0h
		db	 02h, 65h, 03h,0A4h, 07h,0A3h
		db	 06h,0A1h, 01h, 11h, 02h,0A3h
		db	 07h,0A2h, 06h, 10h, 01h,0A0h
		db	 01h,0A2h, 07h,0A4h, 06h, 12h
		db	 01h,0A1h, 03h,0A4h, 07h,0A3h
		db	 06h,0A2h, 01h, 10h, 01h,0A3h
		db	 07h,0A2h, 06h,0A1h, 05h, 9Eh
		db	 01h,0A2h, 07h,0A4h, 06h,0A2h
		db	 01h, 10h, 05h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 02h,0A2h, 02h,0A3h
		db	 03h, 5Fh, 03h, 12h, 02h,0A3h
		db	 07h,0A2h, 06h, 11h, 01h,0A2h
		db	 0Ah,0A4h, 06h, 12h, 01h,0A4h
		db	 07h,0A3h, 06h, 9Eh, 01h,0A3h
		db	 07h,0A2h, 08h, 10h, 04h,0A2h
		db	 07h,0A4h, 06h, 12h, 02h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A2h
		db	 04h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h,0A2h, 07h,0A4h, 06h, 11h
		db	 03h,0A4h, 07h,0A3h, 06h,0A0h
		db	 03h,0A3h, 07h,0A2h, 06h, 11h
		db	 03h,0A2h, 08h,0A4h, 06h,0A0h
		db	 02h, 64h, 03h,0A4h, 07h,0A3h
		db	 06h,0A1h, 01h, 11h, 02h,0A3h
		db	 07h,0A2h, 06h, 10h, 01h,0A0h
		db	 02h,0A2h, 07h,0A4h, 06h,0A1h
		db	 04h,0A4h, 07h,0A3h, 06h, 10h
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 05h, 9Eh, 01h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h, 10h, 05h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 07h,0A2h, 06h, 11h, 02h,0A2h
		db	 02h, 5Fh, 01h,0A3h, 03h, 5Fh
		db	 02h, 12h, 03h,0A3h, 07h,0A2h
		db	 10h,0A4h, 06h, 12h, 01h,0A4h
		db	 07h,0A3h, 06h, 9Eh, 01h,0A3h
		db	 07h,0A2h, 08h, 10h, 04h,0A2h
		db	 07h,0A4h, 06h, 12h, 02h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A2h
		db	 04h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h, 12h, 01h,0A2h, 07h,0A4h
		db	 06h, 11h, 02h,0A2h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h,0A3h
		db	 07h,0A2h, 06h, 11h, 03h,0A2h
		db	 08h,0A4h, 06h,0A0h, 02h, 64h
		db	 03h,0A4h, 07h,0A3h, 06h,0A1h
		db	 01h, 11h, 02h,0A3h, 07h,0A2h
		db	 06h, 10h, 01h,0A0h, 02h,0A2h
		db	 07h,0A4h, 06h,0A1h, 04h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A0h
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 04h, 9Eh, 02h,0A2h, 07h,0A4h
		db	 06h, 10h, 05h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 02h,0A2h, 02h, 5Fh
		db	 01h,0A3h, 03h, 5Fh, 02h, 12h
		db	 03h,0A3h, 07h,0A2h, 11h,0A4h
		db	 06h, 12h, 01h,0A4h, 07h,0A3h
		db	 0Dh,0A2h, 08h, 10h, 04h,0A2h
		db	 07h,0A4h, 06h, 12h, 02h,0A4h
		db	 07h,0A3h, 06h,0A2h, 05h,0A3h
		db	 07h,0A2h, 06h,0A0h, 02h, 12h
		db	 01h,0A2h, 07h,0A4h, 06h, 11h
		db	 02h,0A2h, 01h,0A4h, 07h,0A3h
		db	 06h,0A0h, 03h,0A3h, 07h,0A2h
		db	 06h, 11h, 02h,0A2h, 09h,0A4h
		db	 06h,0A0h, 01h, 64h, 03h,0A4h
		db	 07h,0A3h, 06h,0A1h, 01h, 11h
		db	 02h,0A3h, 07h,0A2h, 06h, 10h
		db	 01h,0A0h, 02h,0A2h, 07h,0A4h
		db	 06h,0A1h, 04h,0A4h, 07h,0A3h
		db	 06h, 10h, 01h,0A0h, 01h,0A3h
		db	 07h,0A2h, 06h,0A1h, 03h, 9Eh
		db	 02h, 11h, 01h,0A2h, 07h,0A4h
		db	 06h, 10h, 06h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 01h,0A2h, 02h,0A3h
		db	 04h, 5Fh, 02h, 12h, 03h,0A3h
		db	 07h,0A2h, 11h,0A4h, 06h, 12h
		db	 01h,0A4h, 07h,0A3h, 06h, 9Eh
		db	 01h,0A3h, 07h,0A2h, 07h, 10h
		db	 05h,0A2h, 07h,0A4h, 06h, 12h
		db	 01h,0A4h, 07h,0A3h, 06h,0A2h
		db	 05h,0A3h, 07h,0A2h, 06h,0A0h
		db	 01h, 12h, 02h,0A2h, 07h,0A4h
		db	 06h, 11h, 02h,0A2h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 03h,0A3h
		db	 07h,0A2h, 06h, 11h, 02h,0A2h
		db	 09h,0A4h, 06h,0A0h, 01h, 63h
		db	 03h, 12h, 01h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A2h, 01h,0A3h
		db	 07h,0A2h, 06h,0A0h, 02h,0A2h
		db	 07h,0A4h, 06h,0A1h, 04h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A0h
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 03h, 9Eh, 02h, 11h, 01h,0A2h
		db	 07h,0A4h, 06h, 10h, 06h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 07h,0A2h, 09h, 5Fh, 01h,0A3h
		db	 01h, 5Fh, 01h,0A3h, 02h, 12h
		db	 05h,0A3h, 07h,0A2h, 10h,0A4h
		db	 06h, 12h, 01h,0A4h, 07h,0A3h
		db	 06h, 9Eh, 01h,0A3h, 07h,0A2h
		db	 06h, 10h, 06h,0A2h, 07h,0A4h
		db	 06h, 12h, 01h,0A1h, 01h,0A4h
		db	 07h,0A3h, 06h,0A2h, 05h,0A3h
		db	 07h,0A2h, 06h, 12h, 02h,0A2h
		db	 07h,0A4h, 06h, 11h, 02h,0A2h
		db	 01h,0A4h, 07h,0A3h, 06h,0A0h
		db	 03h,0A3h, 07h,0A2h, 06h, 11h
		db	 01h,0A2h, 0Ah,0A4h, 06h,0A0h
		db	 01h, 63h, 03h, 12h, 01h,0A4h
		db	 07h,0A3h, 06h, 11h, 02h,0A2h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 03h,0A2h, 07h,0A4h, 06h,0A1h
		db	 04h,0A4h, 07h,0A3h, 06h,0A0h
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 03h, 9Eh, 02h, 11h, 01h,0A2h
		db	 07h,0A4h, 06h, 10h, 06h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 07h,0A2h, 09h, 5Fh, 01h,0A3h
		db	 04h, 12h, 05h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 12h, 01h,0A4h
		db	 07h,0A3h, 0Dh,0A2h, 06h, 10h
		db	 06h,0A2h, 07h,0A4h, 06h, 12h
		db	 01h,0A1h, 01h,0A4h, 07h,0A3h
		db	 06h,0A2h, 05h,0A3h, 07h,0A2h
		db	 06h, 12h, 03h,0A2h, 07h,0A4h
		db	 06h, 11h, 01h,0A2h, 02h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h,0A3h
		db	 07h,0A2h, 06h, 11h, 01h,0A2h
		db	 0Ah,0A4h, 06h,0A0h, 01h, 63h
		db	 03h, 12h, 01h,0A4h, 07h,0A3h
		db	 06h, 11h, 01h,0A2h, 02h,0A3h
		db	 07h,0A2h, 06h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h,0A1h, 03h, 11h
		db	 01h,0A4h, 07h,0A3h, 06h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h,0A1h
		db	 02h, 9Eh, 02h, 11h, 02h,0A2h
		db	 07h,0A4h, 06h, 10h, 05h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 07h,0A2h, 09h, 5Fh, 01h,0A3h
		db	 04h, 12h, 05h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 12h, 01h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A3h
		db	 07h,0A2h, 06h, 10h, 05h,0A0h
		db	 01h,0A2h, 07h,0A4h, 06h,0A1h
		db	 01h,0A4h, 07h,0A3h, 06h,0A2h
		db	 04h, 10h, 01h,0A3h, 07h,0A2h
		db	 06h, 12h, 03h,0A2h, 07h,0A4h
		db	 06h,0A2h, 03h,0A4h, 07h,0A3h
		db	 06h,0A0h, 03h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 62h, 03h, 12h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A2h, 02h,0A3h, 07h,0A2h
		db	 06h,0A0h, 03h,0A2h, 07h,0A4h
		db	 06h,0A1h, 03h, 11h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h,0A3h
		db	 07h,0A2h, 06h,0A1h, 02h, 9Eh
		db	 02h, 11h, 02h,0A2h, 07h,0A4h
		db	 06h, 10h, 05h,0A0h, 01h,0A4h
		db	 07h,0A3h, 06h, 12h, 01h,0A1h
		db	 01h,0A3h, 07h,0A2h, 08h,0A3h
		db	 05h, 12h, 05h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 12h, 01h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A3h
		db	 07h,0A2h, 06h, 10h, 05h,0A0h
		db	 01h,0A2h, 07h,0A4h, 06h,0A1h
		db	 02h,0A4h, 07h,0A3h, 06h,0A2h
		db	 03h, 10h, 02h,0A3h, 07h,0A2h
		db	 06h, 12h, 02h,0A2h, 07h,0A4h
		db	 06h,0A2h, 03h,0A4h, 07h,0A3h
		db	 06h,0A0h, 03h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 62h, 03h, 12h
		db	 02h,0A4h, 07h,0A3h, 06h,0A2h
		db	 03h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h,0A2h, 07h,0A4h, 06h,0A1h
		db	 03h, 11h, 01h,0A4h, 07h,0A3h
		db	 06h,0A0h, 02h,0A3h, 07h,0A2h
		db	 06h,0A1h, 02h, 9Eh, 02h, 11h
		db	 02h,0A2h, 07h,0A4h, 06h, 10h
		db	 05h,0A0h, 01h,0A4h, 07h,0A3h
		db	 06h, 12h, 01h,0A1h, 01h,0A3h
		db	 07h,0A2h, 07h, 5Fh, 02h,0A3h
		db	 05h, 12h, 04h,0A1h, 01h,0A3h
		db	 07h,0A2h, 10h,0A4h, 06h, 12h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 04h,0A0h, 02h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h,0A4h, 07h,0A3h
		db	 06h,0A2h, 03h, 10h, 02h,0A3h
		db	 07h,0A2h, 06h, 12h, 03h,0A2h
		db	 07h,0A4h, 06h,0A2h, 03h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h,0A3h
		db	 07h,0A2h, 11h,0A4h, 06h, 62h
		db	 02h, 12h, 03h,0A4h, 07h,0A3h
		db	 06h,0A2h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 03h,0A2h, 07h,0A4h
		db	 06h,0A1h, 01h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h,0A0h, 01h,0A3h
		db	 07h,0A2h, 06h,0A1h, 02h, 9Eh
		db	 02h, 11h, 02h,0A2h, 07h,0A4h
		db	 06h, 10h, 04h,0A0h, 02h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 08h, 5Fh, 01h,0A3h
		db	 05h, 12h, 04h,0A1h, 01h,0A3h
		db	 07h,0A2h, 09h, 10h, 01h,0A2h
		db	 07h,0A4h, 06h, 12h, 01h,0A4h
		db	 07h,0A3h, 0Dh,0A2h, 06h, 10h
		db	 04h,0A0h, 02h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h,0A4h, 07h,0A3h
		db	 06h,0A2h, 03h, 10h, 02h,0A3h
		db	 07h,0A2h, 06h, 12h, 03h,0A2h
		db	 07h,0A4h, 06h,0A2h, 03h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h,0A1h
		db	 01h,0A3h, 07h,0A2h, 11h,0A4h
		db	 06h, 61h, 01h, 12h, 03h,0A4h
		db	 07h,0A3h, 06h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h,0A1h, 01h, 11h
		db	 03h,0A4h, 07h,0A3h, 06h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h, 9Eh
		db	 02h, 11h, 04h,0A2h, 07h,0A4h
		db	 06h, 10h, 03h,0A0h, 02h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 08h,0A3h, 06h, 12h
		db	 04h,0A1h, 01h,0A3h, 07h,0A2h
		db	 09h, 10h, 01h,0A2h, 07h,0A4h
		db	 06h, 12h, 01h,0A4h, 07h,0A3h
		db	 06h, 11h, 01h,0A3h, 07h,0A2h
		db	 06h, 10h, 03h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h,0A1h, 01h,0A4h
		db	 07h,0A3h, 06h,0A2h, 02h, 10h
		db	 03h,0A3h, 07h,0A2h, 06h, 12h
		db	 03h,0A2h, 07h,0A4h, 06h,0A2h
		db	 03h,0A4h, 07h,0A3h, 06h,0A0h
		db	 01h, 12h, 01h,0A1h, 01h,0A3h
		db	 07h,0A2h, 11h,0A4h, 06h, 61h
		db	 01h, 12h, 04h,0A4h, 07h,0A3h
		db	 06h,0A2h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 02h,0A2h, 07h,0A4h
		db	 06h,0A1h, 01h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h,0A3h
		db	 07h,0A2h, 06h, 9Eh, 02h, 11h
		db	 04h,0A2h, 07h,0A4h, 06h, 10h
		db	 03h,0A0h, 03h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 07h,0A3h, 06h, 12h, 04h,0A1h
		db	 01h,0A3h, 07h,0A2h, 09h, 10h
		db	 01h,0A2h, 07h,0A4h, 06h, 12h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 03h,0A0h, 03h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h,0A4h, 07h,0A3h
		db	 06h,0A2h, 01h, 10h, 04h,0A3h
		db	 07h,0A2h, 06h, 12h, 02h,0A2h
		db	 07h,0A4h, 06h,0A2h, 03h,0A4h
		db	 07h,0A3h, 06h,0A0h, 01h, 12h
		db	 01h,0A1h, 01h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 60h, 01h, 12h
		db	 04h,0A4h, 07h,0A3h, 06h,0A2h
		db	 03h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h, 60h, 01h,0A2h, 07h,0A4h
		db	 06h, 11h, 04h,0A4h, 07h,0A3h
		db	 06h,0A0h, 01h,0A3h, 07h,0A2h
		db	 06h, 9Eh, 02h, 11h, 04h,0A2h
		db	 07h,0A4h, 06h, 10h, 03h,0A0h
		db	 03h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h,0A3h, 07h,0A2h, 07h, 5Fh
		db	 01h,0A3h, 06h, 12h, 03h,0A1h
		db	 02h,0A3h, 07h,0A2h, 07h, 10h
		db	 02h,0A2h, 07h,0A4h, 06h, 12h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 03h,0A0h, 03h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h,0A4h, 07h,0A3h
		db	 06h,0A2h, 01h, 10h, 04h,0A3h
		db	 07h,0A2h, 06h, 12h, 02h,0A1h
		db	 01h,0A2h, 07h,0A4h, 06h,0A2h
		db	 03h,0A4h, 07h,0A3h, 06h, 12h
		db	 01h,0A1h, 01h,0A3h, 07h,0A2h
		db	 11h,0A4h, 06h, 12h, 05h,0A4h
		db	 07h,0A3h, 06h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 02h, 12h
		db	 01h,0A2h, 07h,0A4h, 06h, 11h
		db	 04h,0A4h, 07h,0A3h, 06h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h, 9Eh
		db	 01h, 11h, 05h,0A2h, 07h,0A4h
		db	 06h, 10h, 02h,0A0h, 03h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 07h, 5Fh, 01h,0A3h
		db	 06h, 12h, 02h,0A1h, 03h,0A3h
		db	 07h,0A2h, 07h, 10h, 03h,0A2h
		db	 07h,0A4h, 06h,0A1h, 01h,0A4h
		db	 07h,0A3h, 0Dh,0A2h, 06h, 10h
		db	 02h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h,0A4h, 07h,0A3h
		db	 06h, 10h, 05h,0A3h, 07h,0A2h
		db	 06h, 12h, 02h,0A1h, 01h,0A2h
		db	 07h,0A4h, 06h,0A2h, 03h,0A4h
		db	 07h,0A3h, 06h, 12h, 01h,0A1h
		db	 02h,0A3h, 07h,0A2h, 08h, 10h
		db	 02h,0A2h, 07h,0A4h, 06h, 12h
		db	 04h,0A4h, 07h,0A3h, 06h,0A2h
		db	 03h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h, 12h, 01h,0A2h, 07h,0A4h
		db	 06h, 11h, 04h,0A4h, 07h,0A3h
		db	 06h,0A0h, 02h,0A3h, 07h,0A2h
		db	 06h, 9Eh, 01h, 11h, 05h,0A2h
		db	 07h,0A4h, 06h, 10h, 02h,0A0h
		db	 04h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h,0A3h, 07h,0A2h, 06h, 5Fh
		db	 01h,0A3h, 06h, 12h, 02h,0A1h
		db	 03h,0A3h, 07h,0A2h, 07h, 10h
		db	 03h,0A2h, 07h,0A4h, 06h,0A1h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 01h,0A0h, 05h,0A2h, 07h,0A4h
		db	 06h,0A1h, 01h,0A4h, 07h,0A3h
		db	 06h, 10h, 05h,0A3h, 07h,0A2h
		db	 06h, 12h, 02h,0A1h, 01h,0A2h
		db	 07h,0A4h, 06h,0A2h, 03h,0A4h
		db	 07h,0A3h, 06h,0A1h, 03h,0A3h
		db	 07h,0A2h, 08h, 10h, 02h,0A2h
		db	 07h,0A4h, 06h, 12h, 05h,0A4h
		db	 07h,0A3h, 06h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 01h, 12h
		db	 01h,0A2h, 07h,0A4h, 06h, 11h
		db	 04h,0A4h, 07h,0A3h, 06h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h, 9Eh
		db	 01h, 11h, 05h,0A2h, 07h,0A4h
		db	 06h, 10h, 01h,0A0h, 05h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 06h,0A0h, 01h,0A3h
		db	 06h, 12h, 02h,0A1h, 03h,0A3h
		db	 07h,0A2h, 07h, 10h, 03h,0A2h
		db	 07h,0A4h, 06h,0A1h, 01h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A3h
		db	 07h,0A2h, 06h, 10h, 01h,0A0h
		db	 05h,0A2h, 07h,0A4h, 06h,0A1h
		db	 02h,0A4h, 07h,0A3h, 06h, 10h
		db	 05h,0A3h, 07h,0A2h, 06h,0A1h
		db	 02h,0A2h, 07h,0A4h, 06h,0A2h
		db	 02h, 10h, 01h,0A4h, 07h,0A3h
		db	 06h,0A1h, 03h,0A3h, 07h,0A2h
		db	 08h, 10h, 02h,0A2h, 07h,0A4h
		db	 06h, 12h, 05h,0A4h, 07h,0A3h
		db	 06h,0A2h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 01h, 12h, 02h,0A2h
		db	 07h,0A4h, 06h, 11h, 02h,0A2h
		db	 02h,0A4h, 07h,0A3h, 06h, 12h
		db	 01h,0A3h, 07h,0A2h, 06h, 9Eh
		db	 01h, 11h, 05h,0A2h, 07h,0A4h
		db	 06h, 10h, 01h,0A0h, 05h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 06h,0A0h, 01h, 5Fh
		db	 01h,0A3h, 06h, 12h, 01h,0A1h
		db	 04h,0A3h, 07h,0A2h, 06h, 10h
		db	 03h,0A2h, 07h,0A4h, 06h,0A1h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 01h,0A0h, 05h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h,0A4h, 07h,0A3h
		db	 06h, 10h, 05h,0A3h, 07h,0A2h
		db	 06h,0A1h, 03h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h, 10h, 02h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 08h, 10h, 02h,0A2h
		db	 07h,0A4h, 06h, 12h, 05h,0A4h
		db	 07h,0A3h, 06h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 01h, 12h
		db	 02h,0A2h, 07h,0A4h, 06h, 11h
		db	 02h,0A2h, 02h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 06h,0A2h, 07h,0A4h
		db	 06h,0A0h, 05h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 06h, 5Fh, 01h,0A0h, 01h,0A3h
		db	 06h, 12h, 01h,0A1h, 04h,0A3h
		db	 07h,0A2h, 06h, 10h, 04h,0A2h
		db	 07h,0A4h, 06h,0A1h, 01h,0A4h
		db	 07h,0A3h, 0Dh,0A2h, 06h,0A0h
		db	 06h,0A2h, 07h,0A4h, 06h,0A1h
		db	 01h, 11h, 01h,0A4h, 07h,0A3h
		db	 06h, 10h, 05h,0A3h, 07h,0A2h
		db	 06h,0A1h, 03h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h, 10h, 02h,0A4h
		db	 07h,0A3h, 06h,0A1h, 03h,0A3h
		db	 07h,0A2h, 07h, 10h, 03h,0A2h
		db	 07h,0A4h, 06h, 12h, 04h,0A4h
		db	 07h,0A3h, 06h,0A2h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 01h, 12h
		db	 02h,0A2h, 07h,0A4h, 06h, 11h
		db	 02h,0A2h, 02h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 06h,0A2h, 07h,0A4h
		db	 06h,0A0h, 06h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 05h, 5Fh, 01h,0A0h, 01h,0A3h
		db	 06h, 12h, 01h,0A1h, 04h,0A3h
		db	 07h,0A2h, 06h, 10h, 04h,0A2h
		db	 07h,0A4h, 06h,0A1h, 01h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A3h
		db	 07h,0A2h, 06h,0A0h, 05h, 9Eh
		db	 01h,0A2h, 07h,0A4h, 06h, 11h
		db	 01h,0A4h, 07h,0A3h, 06h, 10h
		db	 05h,0A3h, 07h,0A2h, 06h,0A1h
		db	 03h,0A2h, 07h,0A4h, 06h,0A2h
		db	 01h, 10h, 02h,0A4h, 07h,0A3h
		db	 06h,0A1h, 03h,0A3h, 07h,0A2h
		db	 07h, 10h, 03h,0A2h, 07h,0A4h
		db	 06h, 12h, 04h,0A1h, 01h,0A4h
		db	 07h,0A3h, 06h,0A2h, 02h, 10h
		db	 01h,0A3h, 07h,0A2h, 06h, 12h
		db	 02h,0A2h, 07h,0A4h, 06h, 11h
		db	 02h,0A2h, 02h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 06h,0A2h, 07h,0A4h
		db	 06h,0A0h, 06h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 05h,0A0h, 02h,0A3h, 06h, 12h
		db	 01h,0A1h, 04h,0A3h, 03h, 0Ah
		db	 06h,0A2h, 04h, 10h, 03h,0A0h
		db	 01h,0A2h, 07h,0A4h, 06h,0A1h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 05h, 9Eh, 01h,0A2h, 06h, 0Ah
		db	 01h,0A4h, 06h, 11h, 01h,0A4h
		db	 07h,0A3h, 06h, 10h, 05h,0A3h
		db	 03h, 0Ah, 03h,0A3h, 01h,0A2h
		db	 06h,0A1h, 03h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h, 10h, 02h,0A4h
		db	 06h, 0Ah, 01h,0A3h, 06h,0A1h
		db	 03h,0A3h, 07h,0A2h, 07h, 10h
		db	 03h,0A2h, 05h, 0Ah, 01h,0A2h
		db	 01h,0A4h, 06h, 12h, 04h,0A1h
		db	 01h,0A4h, 07h,0A3h, 04h, 0Ah
		db	 01h,0A3h, 01h,0A2h, 01h, 5Fh
		db	 01h, 10h, 01h,0A3h, 07h,0A2h
		db	 06h, 12h, 03h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 01h,0A4h
		db	 06h,0A2h, 04h,0A4h, 01h, 0Ah
		db	 03h,0A4h, 03h,0A3h, 06h, 12h
		db	 01h,0A3h, 07h,0A2h, 06h, 11h
		db	 04h, 0Ah, 03h,0A2h, 06h,0A4h
		db	 06h,0A0h, 02h, 0Ah, 03h,0A0h
		db	 01h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h,0A3h, 07h,0A2h, 05h,0A0h
		db	 02h,0A3h, 06h,0A1h, 05h,0A3h
		db	 04h, 0Ah, 02h,0A3h, 01h,0A2h
		db	 01h, 0Ah, 02h,0A2h, 03h, 10h
		db	 03h,0A0h, 01h,0A2h, 07h,0A4h
		db	 06h,0A1h, 01h,0A4h, 07h,0A3h
		db	 06h, 11h, 01h,0A3h, 07h,0A2h
		db	 06h,0A0h, 05h, 9Eh, 01h,0A2h
		db	 05h, 0Ah, 02h,0A4h, 06h, 11h
		db	 02h,0A4h, 07h,0A3h, 06h, 10h
		db	 04h,0A0h, 01h,0A3h, 03h, 0Ah
		db	 02h,0A3h, 02h,0A2h, 06h,0A1h
		db	 03h,0A2h, 07h,0A4h, 06h, 10h
		db	 03h,0A4h, 04h, 0Ah, 02h,0A4h
		db	 01h,0A3h, 06h,0A1h, 02h,0A3h
		db	 07h,0A2h, 06h, 10h, 04h,0A2h
		db	 04h, 0Ah, 02h,0A2h, 01h,0A4h
		db	 06h, 12h, 04h,0A1h, 01h,0A4h
		db	 07h,0A3h, 03h, 0Ah, 02h,0A3h
		db	 01h,0A2h, 01h, 5Fh, 01h, 10h
		db	 01h,0A3h, 07h,0A2h, 06h, 12h
		db	 03h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 01h,0A4h, 06h,0A2h
		db	 04h, 0Ah, 02h,0A4h, 01h, 0Ah
		db	 02h,0A4h, 02h,0A3h, 06h, 12h
		db	 02h,0A3h, 07h,0A2h, 06h, 11h
		db	 04h, 0Ah, 02h,0A2h, 07h,0A4h
		db	 06h,0A0h, 02h, 0Ah, 02h,0A0h
		db	 01h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h,0A3h, 07h,0A2h, 05h, 5Fh
		db	 01h,0A0h, 02h,0A3h, 06h,0A1h
		db	 05h,0A3h, 03h, 0Ah, 02h,0A3h
		db	 02h, 0Ah, 02h,0A2h, 01h, 0Ah
		db	 02h,0A2h, 01h, 0Ah, 03h,0A0h
		db	 01h,0A2h, 02h, 0Ah, 04h,0A2h
		db	 01h,0A4h, 03h, 0Ah, 05h,0A4h
		db	 03h, 0Ah, 05h,0A3h, 0Bh, 0Ah
		db	 04h,0A2h, 02h,0A0h, 01h, 0Ah
		db	 05h,0A2h, 04h, 0Ah, 05h,0A4h
		db	 03h, 0Ah, 04h,0A4h, 03h, 0Ah
		db	 02h,0A4h, 01h, 0Ah, 03h,0A3h
		db	 03h, 10h, 03h,0A0h, 02h,0A3h
		db	 03h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 04h,0A1h
		db	 01h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A4h, 05h, 10h
		db	 03h,0A4h, 03h, 0Ah, 05h,0A3h
		db	 03h, 0Ah, 04h,0A1h, 01h,0A3h
		db	 07h,0A2h, 04h, 0Ah, 05h, 10h
		db	 01h,0A2h, 02h, 0Ah, 05h,0A4h
		db	 03h, 0Ah, 04h, 12h, 02h,0A1h
		db	 01h, 0Ah, 02h,0A4h, 01h, 0Ah
		db	 03h,0A4h, 01h,0A3h, 02h, 0Ah
		db	 05h, 5Fh, 01h, 10h, 01h,0A3h
		db	 07h,0A2h, 06h, 12h, 03h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 01h,0A4h, 06h,0A2h, 04h, 0Ah
		db	 02h,0A4h, 05h,0A3h, 01h, 0Ah
		db	 04h,0A3h, 01h, 12h, 02h, 0Ah
		db	 02h,0A3h, 01h, 0Ah, 03h,0A3h
		db	 01h,0A2h, 06h, 11h, 04h, 0Ah
		db	 02h,0A2h, 01h, 0Ah, 02h,0A2h
		db	 03h, 0Ah, 04h,0A4h, 03h,0A0h
		db	 02h, 0Ah, 02h, 9Eh, 01h, 9Fh
		db	 01h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 01h, 0Ah, 03h,0A3h, 05h, 5Fh
		db	 01h, 11h, 01h,0A3h, 07h,0A2h
		db	 04h, 5Fh, 01h,0A0h, 02h,0A3h
		db	 06h,0A1h, 05h,0A3h, 03h, 0Ah
		db	 05h,0A2h, 03h, 0Ah, 03h, 10h
		db	 01h, 0Ah, 02h,0A2h, 01h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A4h
		db	 02h, 0Ah, 02h,0A4h, 02h,0A1h
		db	 01h,0A4h, 03h, 0Ah, 02h,0A4h
		db	 02h,0A3h, 06h,0A2h, 01h,0A3h
		db	 05h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A0h
		db	 02h, 0Ah, 02h,0A2h, 04h, 0Ah
		db	 02h,0A2h, 01h,0A4h, 03h, 0Ah
		db	 02h,0A4h, 01h, 11h, 01h, 0Ah
		db	 02h,0A4h, 03h, 0Ah, 03h,0A3h
		db	 01h, 0Ah, 02h,0A3h, 02h, 10h
		db	 03h,0A0h, 02h,0A3h, 03h, 0Ah
		db	 02h,0A3h, 01h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 01h,0A1h
		db	 01h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A4h
		db	 05h, 10h, 03h,0A4h, 04h, 0Ah
		db	 02h,0A4h, 01h,0A3h, 03h, 0Ah
		db	 02h,0A3h, 01h,0A1h, 01h, 0Ah
		db	 02h,0A3h, 07h,0A2h, 03h, 0Ah
		db	 02h,0A2h, 01h, 10h, 04h,0A2h
		db	 03h, 0Ah, 02h,0A2h, 02h,0A4h
		db	 06h, 0Ah, 02h, 12h, 01h,0A1h
		db	 02h, 0Ah, 03h,0A4h, 01h, 0Ah
		db	 02h,0A4h, 01h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 02h, 5Fh, 01h, 10h
		db	 02h,0A3h, 07h,0A2h, 06h, 12h
		db	 02h, 0Ah, 06h,0A2h, 01h,0A4h
		db	 06h,0A2h, 03h, 0Ah, 04h,0A4h
		db	 04h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h, 12h, 02h,0A3h, 01h, 0Ah
		db	 03h,0A3h, 01h, 0Ah, 02h,0A2h
		db	 06h, 11h, 04h, 0Ah, 03h,0A2h
		db	 01h, 0Ah, 02h,0A2h, 01h, 0Ah
		db	 02h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 02h,0A0h, 02h, 0Ah, 02h, 9Eh
		db	 01h, 9Fh, 01h,0A4h, 03h, 0Ah
		db	 02h,0A4h, 02h, 0Ah, 02h,0A3h
		db	 04h, 5Fh, 01h, 11h, 01h,0A3h
		db	 07h,0A2h, 04h, 5Fh, 01h,0A0h
		db	 02h,0A3h, 06h,0A1h, 05h,0A3h
		db	 03h, 0Ah, 02h,0A3h, 02h,0A2h
		db	 04h, 0Ah, 02h, 10h, 02h, 0Ah
		db	 02h,0A2h, 01h, 0Ah, 06h,0A4h
		db	 03h, 0Ah, 04h,0A4h, 04h, 0Ah
		db	 04h,0A3h, 05h,0A2h, 01h,0A3h
		db	 05h, 0Ah, 06h,0A2h, 02h, 0Ah
		db	 02h,0A0h, 02h, 0Ah, 02h,0A2h
		db	 04h, 0Ah, 02h,0A2h, 01h,0A4h
		db	 03h, 0Ah, 06h,0A4h, 03h, 0Ah
		db	 02h,0A3h, 02h, 0Ah, 02h,0A3h
		db	 02h, 10h, 03h,0A0h, 02h,0A3h
		db	 03h, 0Ah, 04h,0A2h, 03h, 0Ah
		db	 06h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A4h, 05h, 10h
		db	 03h,0A4h, 04h, 0Ah, 02h,0A4h
		db	 01h,0A3h, 03h, 0Ah, 02h,0A3h
		db	 01h,0A1h, 01h, 0Ah, 02h,0A3h
		db	 07h,0A2h, 04h, 0Ah, 04h, 10h
		db	 02h,0A2h, 03h, 0Ah, 02h,0A2h
		db	 02h,0A4h, 03h, 0Ah, 05h, 12h
		db	 01h,0A1h, 02h, 0Ah, 02h,0A4h
		db	 02h, 0Ah, 02h,0A4h, 01h,0A3h
		db	 02h, 0Ah, 02h,0A3h, 02h, 5Fh
		db	 01h, 10h, 02h,0A3h, 07h,0A2h
		db	 06h, 12h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 01h,0A4h
		db	 06h,0A2h, 04h, 0Ah, 02h,0A4h
		db	 05h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h, 12h, 02h,0A3h, 01h, 0Ah
		db	 02h,0A3h, 02h, 0Ah, 02h,0A2h
		db	 06h, 11h, 04h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 01h, 0Ah
		db	 06h,0A4h, 02h,0A0h, 02h, 0Ah
		db	 02h, 9Fh, 02h,0A4h, 03h, 0Ah
		db	 02h,0A4h, 02h, 0Ah, 02h,0A3h
		db	 04h, 11h, 02h,0A3h, 07h,0A2h
		db	 04h,0A0h, 03h,0A3h, 06h,0A1h
		db	 05h,0A3h, 03h, 0Ah, 02h,0A3h
		db	 02h,0A2h, 04h, 0Ah, 02h, 10h
		db	 02h,0A0h, 02h,0A2h, 01h, 0Ah
		db	 02h,0A2h, 04h,0A4h, 06h, 0Ah
		db	 02h,0A4h, 06h, 0Ah, 02h,0A3h
		db	 04h,0A2h, 01h,0A3h, 05h, 0Ah
		db	 02h,0A2h, 06h, 0Ah, 02h,0A0h
		db	 02h, 0Ah, 02h,0A2h, 04h, 0Ah
		db	 02h,0A2h, 01h, 0Ah, 01h,0A4h
		db	 02h, 0Ah, 02h,0A4h, 01h, 11h
		db	 02h,0A4h, 04h, 0Ah, 02h,0A4h
		db	 01h,0A3h, 06h, 10h, 02h,0A0h
		db	 03h,0A3h, 02h, 0Ah, 02h,0A3h
		db	 01h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h,0A1h, 02h,0A2h
		db	 03h, 0Ah, 05h,0A4h, 05h, 10h
		db	 03h,0A4h, 04h, 0Ah, 02h,0A4h
		db	 01h, 0Ah, 01h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 01h,0A1h, 01h, 0Ah
		db	 02h,0A3h, 07h,0A2h, 06h, 10h
		db	 01h, 0Ah, 02h, 10h, 01h,0A2h
		db	 03h, 0Ah, 02h,0A2h, 01h, 0Ah
		db	 01h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 02h, 0Ah, 02h,0A1h, 03h, 0Ah
		db	 02h,0A4h, 05h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 01h, 0Ah, 01h, 5Fh
		db	 01h, 10h, 02h,0A3h, 01h, 0Ah
		db	 02h,0A3h, 04h,0A2h, 06h, 12h
		db	 02h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h,0A4h, 06h,0A2h
		db	 03h, 0Ah, 02h,0A4h, 05h, 0Ah
		db	 02h,0A3h, 02h, 0Ah, 02h,0A3h
		db	 01h, 12h, 02h, 0Ah, 02h,0A3h
		db	 05h,0A2h, 06h, 11h, 03h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 01h, 0Ah, 02h,0A2h, 01h,0A4h
		db	 06h,0A0h, 01h, 0Ah, 02h, 9Fh
		db	 02h,0A4h, 03h, 0Ah, 05h,0A3h
		db	 04h, 0Ah, 02h, 11h, 01h,0A3h
		db	 07h,0A2h, 04h,0A0h, 01h, 5Fh
		db	 01h,0A0h, 01h, 12h, 01h,0A3h
		db	 06h,0A1h, 04h, 11h, 01h,0A3h
		db	 01h, 0Ah, 04h,0A3h, 02h,0A2h
		db	 02h, 0Ah, 04h, 10h, 01h,0A0h
		db	 02h,0A2h, 02h, 0Ah, 04h,0A2h
		db	 01h,0A4h, 02h, 0Ah, 05h,0A4h
		db	 03h, 0Ah, 05h,0A3h, 05h,0A2h
		db	 01h,0A3h, 06h, 0Ah, 04h,0A2h
		db	 03h, 0Ah, 02h,0A0h, 01h, 9Eh
		db	 01h, 0Ah, 02h,0A2h, 05h, 0Ah
		db	 02h,0A4h, 04h, 0Ah, 04h,0A4h
		db	 03h, 0Ah, 04h,0A3h, 06h, 10h
		db	 02h,0A0h, 03h,0A3h, 01h, 0Ah
		db	 03h,0A3h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 04h,0A1h, 02h,0A2h
		db	 05h, 0Ah, 02h,0A4h, 06h, 10h
		db	 03h,0A4h, 04h, 0Ah, 02h,0A4h
		db	 01h,0A3h, 03h, 0Ah, 04h,0A1h
		db	 01h,0A3h, 07h,0A2h, 03h, 0Ah
		db	 05h, 10h, 02h,0A2h, 04h, 0Ah
		db	 02h,0A2h, 01h,0A4h, 03h, 0Ah
		db	 03h, 12h, 01h, 0Ah, 02h,0A1h
		db	 01h, 0Ah, 04h,0A4h, 04h,0A3h
		db	 03h, 0Ah, 02h,0A3h, 01h, 5Fh
		db	 01h, 10h, 02h,0A3h, 01h, 0Ah
		db	 02h,0A3h, 04h,0A2h, 06h, 12h
		db	 02h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h,0A4h, 06h,0A2h
		db	 02h, 0Ah, 04h,0A4h, 05h, 0Ah
		db	 04h,0A3h, 02h, 12h, 01h, 0Ah
		db	 04h,0A3h, 04h,0A2h, 06h, 11h
		db	 02h, 0Ah, 03h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 04h,0A4h
		db	 04h, 0Ah, 04h, 9Fh, 01h, 12h
		db	 01h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 03h,0A3h, 04h, 0Ah, 02h, 11h
		db	 02h,0A3h, 07h,0A2h, 03h, 5Fh
		db	 01h,0A0h, 03h,0A3h, 06h,0A1h
		db	 04h, 11h, 01h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 01h,0A4h, 07h,0A3h
		db	 06h,0A2h, 01h,0A3h, 07h,0A2h
		db	 06h,0A0h, 02h, 9Eh, 01h, 12h
		db	 03h,0A2h, 07h,0A4h, 06h, 11h
		db	 01h,0A4h, 07h,0A3h, 06h, 10h
		db	 01h,0A0h, 04h,0A3h, 07h,0A2h
		db	 06h,0A1h, 03h,0A2h, 01h, 0Ah
		db	 05h,0A2h, 01h,0A4h, 06h, 10h
		db	 03h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h, 11h, 01h,0A3h, 07h,0A2h
		db	 06h, 10h, 03h,0A0h, 01h,0A2h
		db	 07h,0A4h, 06h, 12h, 01h,0A1h
		db	 04h,0A4h, 07h,0A3h, 06h, 10h
		db	 02h, 0Ah, 02h,0A3h, 06h,0A2h
		db	 06h, 12h, 02h,0A2h, 07h,0A4h
		db	 06h,0A2h, 04h,0A4h, 07h,0A3h
		db	 06h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 04h,0A2h, 09h,0A4h
		db	 06h,0A0h, 03h, 9Fh, 02h, 12h
		db	 01h,0A4h, 01h, 0Ah, 04h,0A4h
		db	 02h,0A3h, 06h, 11h, 02h,0A3h
		db	 07h,0A2h, 03h, 5Fh, 01h,0A0h
		db	 03h,0A3h, 06h,0A1h, 04h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 04h,0A2h, 07h,0A4h, 01h, 0Ah
		db	 06h,0A4h, 07h,0A3h, 06h,0A2h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h, 9Eh, 01h, 12h, 03h,0A2h
		db	 07h,0A4h, 06h, 11h, 01h,0A4h
		db	 07h,0A3h, 06h, 0Ah, 03h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h,0A1h
		db	 03h,0A2h, 07h,0A4h, 06h, 10h
		db	 03h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h, 11h, 01h,0A3h, 07h,0A2h
		db	 06h, 10h, 03h,0A0h, 01h,0A2h
		db	 07h,0A4h, 06h, 12h, 01h,0A1h
		db	 04h,0A4h, 07h,0A3h, 06h, 10h
		db	 03h,0A3h, 07h,0A2h, 06h, 12h
		db	 02h,0A2h, 07h,0A4h, 03h, 0Ah
		db	 01h,0A4h, 02h,0A2h, 04h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h, 0Ah
		db	 03h,0A3h, 04h,0A2h, 06h, 11h
		db	 04h,0A2h, 09h,0A4h, 06h,0A0h
		db	 02h, 9Eh, 01h, 9Fh, 01h, 12h
		db	 02h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A3h, 07h,0A2h, 03h,0A0h
		db	 04h,0A3h, 06h,0A1h, 04h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 04h,0A2h, 07h,0A4h, 02h, 0Ah
		db	 02h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 06h,0A3h, 06h,0A2h, 01h,0A3h
		db	 07h,0A2h, 06h,0A0h, 02h, 9Eh
		db	 01h, 12h, 03h,0A2h, 07h,0A4h
		db	 06h, 11h, 01h,0A4h, 07h,0A3h
		db	 05h, 0Ah, 02h,0A0h, 01h, 0Ah
		db	 02h,0A0h, 01h,0A3h, 07h,0A2h
		db	 06h,0A1h, 02h, 11h, 01h,0A2h
		db	 07h,0A4h, 06h, 10h, 03h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 03h,0A0h, 01h,0A2h, 07h,0A4h
		db	 06h, 12h, 01h,0A1h, 04h,0A4h
		db	 07h,0A3h, 06h, 10h, 03h,0A3h
		db	 07h,0A2h, 06h, 12h, 02h,0A2h
		db	 07h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 02h,0A2h, 03h, 10h, 01h,0A4h
		db	 07h,0A3h, 06h, 12h, 02h,0A3h
		db	 01h, 0Ah, 02h,0A3h, 04h,0A2h
		db	 06h, 11h, 04h,0A2h, 09h,0A4h
		db	 06h,0A0h, 02h, 9Eh, 01h, 9Fh
		db	 01h, 12h, 02h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A3h, 07h,0A2h
		db	 03h,0A0h, 04h,0A3h, 06h,0A1h
		db	 03h, 11h, 02h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 02h, 0Ah, 02h,0A4h, 02h, 0Ah
		db	 02h,0A4h, 01h, 0Ah, 02h,0A4h
		db	 01h, 0Ah, 03h,0A3h, 03h, 0Ah
		db	 04h,0A3h, 04h, 0Ah, 05h,0A2h
		db	 03h, 0Ah, 05h, 12h, 01h,0A2h
		db	 07h,0A4h, 06h, 11h, 02h,0A4h
		db	 07h,0A3h, 04h, 0Ah, 02h,0A0h
		db	 05h,0A3h, 01h, 0Ah, 04h,0A3h
		db	 02h,0A2h, 01h, 0Ah, 02h,0A2h
		db	 01h, 0Ah, 03h, 11h, 01h,0A2h
		db	 07h,0A4h, 06h, 10h, 03h,0A4h
		db	 07h,0A3h, 06h,0A1h, 02h, 11h
		db	 01h,0A3h, 07h,0A2h, 06h, 10h
		db	 03h,0A0h, 01h,0A2h, 07h,0A4h
		db	 06h,0A1h, 05h,0A4h, 07h,0A3h
		db	 06h, 10h, 02h, 0Ah, 04h,0A3h
		db	 04h, 0Ah, 04h,0A2h, 02h, 12h
		db	 01h, 0Ah, 05h,0A2h, 04h, 0Ah
		db	 05h,0A4h, 01h,0A2h, 01h, 0Ah
		db	 02h, 10h, 01h, 0Ah, 03h,0A4h
		db	 03h, 0Ah, 04h,0A3h, 03h, 12h
		db	 02h, 0Ah, 02h,0A3h, 05h,0A2h
		db	 06h, 11h, 02h,0A2h, 0Bh,0A4h
		db	 06h,0A0h, 01h, 9Fh, 02h, 12h
		db	 02h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A3h, 07h,0A2h, 03h, 5Fh
		db	 01h,0A0h, 04h,0A3h, 06h,0A1h
		db	 02h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 01h, 0Ah, 05h, 9Fh, 01h,0A4h
		db	 02h, 0Ah, 03h,0A4h, 01h, 0Ah
		db	 02h,0A3h, 01h, 0Ah, 02h,0A3h
		db	 02h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 01h,0A2h, 05h, 0Ah
		db	 02h,0A0h, 01h, 12h, 04h,0A2h
		db	 07h,0A4h, 06h, 11h, 02h,0A4h
		db	 07h,0A3h, 03h, 0Ah, 04h,0A0h
		db	 04h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 01h,0A2h, 02h, 0Ah
		db	 03h,0A2h, 01h, 0Ah, 02h, 11h
		db	 01h,0A2h, 07h,0A4h, 06h, 10h
		db	 02h,0A0h, 01h,0A4h, 07h,0A3h
		db	 06h,0A1h, 01h, 11h, 02h,0A3h
		db	 07h,0A2h, 06h, 10h, 02h,0A0h
		db	 02h,0A2h, 07h,0A4h, 06h,0A1h
		db	 04h,0A4h, 07h,0A3h, 06h, 10h
		db	 01h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 01h, 12h
		db	 01h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 03h,0A4h, 01h, 0Ah
		db	 02h,0A4h, 03h,0A2h, 02h, 0Ah
		db	 03h,0A4h, 01h, 0Ah, 02h,0A4h
		db	 01h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 02h, 12h, 02h, 0Ah
		db	 02h,0A3h, 05h,0A2h, 06h, 11h
		db	 02h,0A2h, 0Bh,0A4h, 06h,0A0h
		db	 01h, 9Fh, 02h, 12h, 03h,0A4h
		db	 07h,0A3h, 06h, 11h, 02h,0A3h
		db	 07h,0A2h, 02h, 5Fh, 01h,0A0h
		db	 04h,0A3h, 06h,0A1h, 02h, 11h
		db	 03h,0A3h, 07h,0A2h, 06h,0A0h
		db	 04h,0A2h, 07h,0A4h, 01h, 0Ah
		db	 02h,0A4h, 03h, 9Fh, 01h,0A4h
		db	 02h, 0Ah, 02h,0A4h, 02h, 0Ah
		db	 02h,0A3h, 01h, 0Ah, 06h,0A3h
		db	 03h, 0Ah, 04h,0A2h, 04h, 0Ah
		db	 04h, 12h, 03h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h,0A4h, 07h,0A3h
		db	 04h, 0Ah, 02h,0A0h, 05h, 0Ah
		db	 02h,0A3h, 02h, 0Ah, 02h,0A3h
		db	 01h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h, 11h, 01h,0A2h
		db	 07h,0A4h, 06h, 10h, 02h,0A0h
		db	 01h,0A4h, 07h,0A3h, 06h, 11h
		db	 03h,0A3h, 07h,0A2h, 06h, 10h
		db	 01h,0A0h, 03h,0A2h, 07h,0A4h
		db	 06h,0A1h, 05h,0A4h, 07h,0A3h
		db	 06h, 0Ah, 02h, 10h, 01h,0A3h
		db	 05h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 03h,0A4h
		db	 01h, 0Ah, 02h,0A4h, 03h,0A2h
		db	 02h, 0Ah, 02h,0A4h, 02h, 0Ah
		db	 02h,0A4h, 01h, 0Ah, 02h,0A3h
		db	 02h, 0Ah, 02h,0A3h, 02h, 12h
		db	 02h, 0Ah, 02h,0A3h, 05h,0A2h
		db	 06h, 11h, 02h,0A2h, 0Bh,0A4h
		db	 06h,0A0h, 01h, 9Fh, 02h, 12h
		db	 03h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A3h, 07h,0A2h, 02h, 5Fh
		db	 01h,0A0h, 04h,0A3h, 06h,0A1h
		db	 02h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 01h, 0Ah, 02h,0A4h, 03h, 9Fh
		db	 01h,0A4h, 02h, 0Ah, 02h,0A4h
		db	 03h,0A3h, 02h, 0Ah, 02h,0A3h
		db	 02h,0A2h, 01h,0A3h, 07h, 0Ah
		db	 02h,0A2h, 04h,0A0h, 01h, 12h
		db	 01h, 0Ah, 02h, 12h, 02h,0A2h
		db	 07h,0A4h, 06h,0A2h, 01h,0A4h
		db	 07h,0A3h, 04h, 0Ah, 02h,0A0h
		db	 05h, 0Ah, 02h,0A3h, 02h, 0Ah
		db	 02h,0A3h, 01h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h,0A1h, 01h, 11h
		db	 02h,0A2h, 07h,0A4h, 06h, 10h
		db	 02h,0A0h, 01h,0A4h, 07h,0A3h
		db	 06h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h, 10h, 01h,0A0h, 03h,0A2h
		db	 07h,0A4h, 06h,0A1h, 05h,0A4h
		db	 07h,0A3h, 06h, 0Ah, 02h, 10h
		db	 01h,0A3h, 01h, 0Ah, 02h,0A3h
		db	 02h, 0Ah, 02h,0A2h, 02h, 0Ah
		db	 02h,0A2h, 02h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 03h,0A4h
		db	 01h, 0Ah, 02h,0A4h, 01h, 0Ah
		db	 01h,0A4h, 01h,0A2h, 02h, 0Ah
		db	 02h,0A4h, 05h, 0Ah, 02h,0A3h
		db	 02h, 0Ah, 02h,0A3h, 02h, 12h
		db	 02h, 0Ah, 02h,0A3h, 05h,0A2h
		db	 01h, 0Ah, 02h,0A2h, 03h, 11h
		db	 02h,0A2h, 0Bh,0A4h, 06h,0A0h
		db	 01h, 9Fh, 02h, 12h, 03h,0A4h
		db	 07h,0A3h, 06h, 11h, 02h,0A3h
		db	 07h,0A2h, 02h,0A0h, 05h,0A3h
		db	 06h,0A1h, 02h, 11h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 04h,0A2h
		db	 07h, 0Ah, 04h,0A4h, 02h, 9Fh
		db	 01h,0A4h, 01h, 0Ah, 04h,0A4h
		db	 02h,0A3h, 03h, 0Ah, 04h,0A3h
		db	 03h, 0Ah, 05h,0A2h, 03h, 0Ah
		db	 05h, 12h, 03h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h,0A4h, 07h,0A3h
		db	 03h, 0Ah, 04h,0A0h, 04h,0A3h
		db	 01h, 0Ah, 04h,0A3h, 02h,0A2h
		db	 01h, 0Ah, 04h,0A2h, 01h,0A1h
		db	 01h, 11h, 02h,0A2h, 07h,0A4h
		db	 06h, 10h, 02h,0A0h, 01h,0A4h
		db	 07h,0A3h, 06h, 11h, 03h,0A3h
		db	 07h,0A2h, 06h, 10h, 01h,0A0h
		db	 03h,0A2h, 07h,0A4h, 06h,0A1h
		db	 05h,0A4h, 07h,0A3h, 06h, 10h
		db	 01h, 0Ah, 04h,0A3h, 04h, 0Ah
		db	 04h,0A2h, 03h, 0Ah, 02h,0A2h
		db	 02h, 0Ah, 02h,0A2h, 03h,0A4h
		db	 02h, 0Ah, 02h,0A4h, 02h,0A2h
		db	 01h, 0Ah, 04h,0A4h, 05h, 0Ah
		db	 04h,0A3h, 03h, 12h, 01h, 0Ah
		db	 04h,0A3h, 04h,0A2h, 01h, 0Ah
		db	 02h,0A2h, 03h, 11h, 02h,0A2h
		db	 0Bh,0A4h, 06h,0A0h, 01h, 9Fh
		db	 02h, 12h, 03h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A3h, 07h,0A2h
		db	 02h,0A0h, 01h, 5Fh, 01h,0A0h
		db	 01h, 12h, 01h,0A0h, 01h, 12h
		db	 01h,0A3h, 06h,0A1h, 01h, 11h
		db	 04h,0A3h, 07h,0A2h, 06h,0A0h
		db	 03h,0A2h, 07h,0A4h, 06h, 9Fh
		db	 01h,0A4h, 07h,0A3h, 06h,0A2h
		db	 01h,0A3h, 07h,0A2h, 06h, 9Eh
		db	 01h, 12h, 05h,0A2h, 07h,0A4h
		db	 06h,0A2h, 02h,0A4h, 07h,0A3h
		db	 06h,0A0h, 04h, 12h, 01h,0A3h
		db	 07h,0A2h, 06h, 11h, 03h,0A2h
		db	 07h,0A4h, 06h, 10h, 01h,0A0h
		db	 02h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A3h, 07h,0A2h, 06h, 10h
		db	 01h,0A0h, 03h,0A2h, 07h,0A4h
		db	 06h,0A1h, 05h,0A4h, 07h,0A3h
		db	 06h, 10h, 03h,0A3h, 07h,0A2h
		db	 06h,0A1h, 03h,0A2h, 07h,0A4h
		db	 06h, 10h, 04h,0A4h, 07h,0A3h
		db	 06h, 12h, 01h,0A1h, 01h,0A3h
		db	 07h,0A2h, 06h, 11h, 01h,0A2h
		db	 0Ch,0A4h, 06h, 9Fh, 01h, 12h
		db	 05h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A3h, 07h,0A2h, 01h, 5Fh
		db	 01h,0A0h, 05h,0A3h, 06h,0A1h
		db	 01h, 11h, 04h,0A3h, 07h,0A2h
		db	 06h,0A0h, 03h, 12h, 01h,0A2h
		db	 07h,0A4h, 06h, 9Fh, 01h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A3h
		db	 07h,0A2h, 06h, 12h, 06h,0A2h
		db	 07h,0A4h, 06h,0A2h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 04h, 12h
		db	 01h,0A3h, 07h,0A2h, 06h, 11h
		db	 03h,0A2h, 07h,0A4h, 06h, 10h
		db	 01h,0A0h, 02h,0A4h, 07h,0A3h
		db	 06h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 03h, 11h, 02h,0A4h
		db	 07h,0A3h, 06h, 10h, 03h,0A3h
		db	 07h,0A2h, 06h,0A1h, 02h,0A2h
		db	 07h,0A4h, 06h, 10h, 04h,0A4h
		db	 07h,0A3h, 06h, 12h, 01h,0A1h
		db	 01h,0A3h, 07h,0A2h, 06h, 11h
		db	 01h,0A2h, 0Ch,0A4h, 06h, 9Fh
		db	 01h, 12h, 05h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A3h, 07h,0A2h
		db	 01h, 5Fh, 01h,0A0h, 05h,0A3h
		db	 06h,0A1h, 01h, 11h, 04h,0A3h
		db	 07h,0A2h, 06h,0A0h, 03h, 12h
		db	 01h,0A2h, 07h,0A4h, 06h, 9Fh
		db	 01h,0A4h, 07h,0A3h, 06h, 10h
		db	 01h,0A3h, 07h,0A2h, 06h, 12h
		db	 06h,0A2h, 07h,0A4h, 06h,0A2h
		db	 01h,0A4h, 07h,0A3h, 06h,0A0h
		db	 03h, 5Fh, 01h, 12h, 01h,0A3h
		db	 07h,0A2h, 06h, 11h, 03h,0A2h
		db	 07h,0A4h, 06h,0A0h, 03h,0A4h
		db	 07h,0A3h, 06h, 11h, 03h,0A3h
		db	 07h,0A2h, 06h,0A0h, 04h,0A2h
		db	 07h,0A4h, 06h,0A1h, 03h, 11h
		db	 02h,0A4h, 07h,0A3h, 06h, 10h
		db	 03h,0A3h, 07h,0A2h, 06h,0A1h
		db	 02h,0A2h, 07h,0A4h, 06h, 10h
		db	 03h,0A0h, 01h,0A4h, 07h,0A3h
		db	 06h, 12h, 01h,0A1h, 01h,0A3h
		db	 07h,0A2h, 06h, 11h, 01h,0A2h
		db	 0Ch,0A4h, 06h, 9Fh, 01h, 12h
		db	 05h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A3h, 07h,0A2h, 01h,0A0h
		db	 06h,0A3h, 06h,0A1h, 01h, 11h
		db	 04h,0A3h, 07h,0A2h, 06h,0A0h
		db	 03h, 12h, 01h,0A2h, 07h,0A4h
		db	 06h, 9Fh, 01h,0A4h, 07h,0A3h
		db	 06h, 10h, 01h,0A3h, 07h,0A2h
		db	 06h, 12h, 06h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h,0A4h, 07h,0A3h
		db	 06h,0A0h, 03h, 5Fh, 01h, 12h
		db	 01h,0A3h, 07h,0A2h, 06h, 11h
		db	 03h,0A2h, 07h,0A4h, 06h,0A0h
		db	 03h,0A4h, 07h,0A3h, 06h, 11h
		db	 03h,0A3h, 07h,0A2h, 06h,0A0h
		db	 04h,0A2h, 07h,0A4h, 06h,0A1h
		db	 03h, 11h, 02h,0A4h, 07h,0A3h
		db	 06h, 10h, 03h,0A3h, 07h,0A2h
		db	 06h,0A1h, 02h,0A2h, 07h,0A4h
		db	 06h, 10h, 03h,0A0h, 01h,0A4h
		db	 07h,0A3h, 06h, 12h, 01h,0A1h
		db	 01h,0A3h, 07h,0A2h, 06h, 11h
		db	 01h,0A2h, 0Ch,0A4h, 06h, 9Fh
		db	 01h, 12h, 05h,0A4h, 07h,0A3h
		db	 06h, 11h, 02h,0A3h, 07h,0A2h
		db	 01h,0A0h, 06h,0A3h, 06h,0A1h
		db	 01h, 11h, 04h,0A3h, 07h,0A2h
		db	 06h,0A0h, 03h, 12h, 01h,0A2h
		db	 07h,0A4h, 06h, 9Fh, 01h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A3h
		db	 07h,0A2h, 06h, 12h, 06h,0A2h
		db	 07h,0A4h, 06h,0A2h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 03h, 5Fh
		db	 01h, 12h, 01h,0A3h, 07h,0A2h
		db	 06h, 11h, 03h,0A2h, 07h,0A4h
		db	 06h,0A0h, 03h,0A4h, 07h,0A3h
		db	 06h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 03h, 11h, 02h,0A4h
		db	 07h,0A3h, 06h, 10h, 03h,0A3h
		db	 07h,0A2h, 06h,0A1h, 02h,0A2h
		db	 07h,0A4h, 06h, 10h, 03h,0A0h
		db	 01h,0A4h, 07h,0A3h, 06h, 12h
		db	 01h,0A1h, 01h,0A3h, 07h,0A2h
		db	 06h, 11h, 01h,0A2h, 0Ch,0A4h
		db	 06h, 9Fh, 01h, 12h, 05h,0A4h
		db	 07h,0A3h, 06h, 11h, 02h,0A3h
		db	 07h, 10h, 01h, 5Fh, 01h,0A0h
		db	 06h,0A3h, 06h, 11h, 04h,0A2h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h, 12h, 02h,0A2h, 07h,0A4h
		db	 06h, 11h, 01h,0A4h, 07h,0A3h
		db	 06h, 10h, 01h,0A3h, 07h,0A2h
		db	 06h, 12h, 05h,0A1h, 01h,0A2h
		db	 07h,0A4h, 06h,0A2h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h, 5Fh
		db	 01h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 03h,0A2h, 07h,0A4h
		db	 06h,0A0h, 03h,0A4h, 07h,0A3h
		db	 06h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h, 10h, 02h,0A0h
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 02h,0A2h, 07h,0A4h, 06h, 10h
		db	 02h,0A0h, 02h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 13h,0A4h, 06h, 12h, 06h,0A4h
		db	 07h,0A3h, 06h, 11h, 01h,0A2h
		db	 01h,0A3h, 07h, 5Fh, 01h,0A0h
		db	 06h,0A3h, 06h, 11h, 04h,0A2h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 02h, 12h, 02h,0A2h, 07h,0A4h
		db	 06h, 11h, 01h,0A4h, 07h,0A3h
		db	 06h, 10h, 01h,0A3h, 07h,0A2h
		db	 06h, 12h, 05h,0A1h, 01h,0A2h
		db	 07h,0A4h, 06h,0A2h, 01h,0A4h
		db	 07h,0A3h, 06h,0A0h, 02h, 5Fh
		db	 01h, 12h, 02h,0A3h, 07h,0A2h
		db	 06h, 11h, 03h,0A2h, 07h,0A4h
		db	 06h,0A0h, 03h,0A4h, 07h,0A3h
		db	 06h, 11h, 03h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 02h, 11h, 03h,0A4h
		db	 07h,0A3h, 06h, 10h, 02h,0A0h
		db	 01h,0A3h, 07h,0A2h, 06h,0A1h
		db	 02h,0A2h, 07h,0A4h, 06h, 10h
		db	 02h,0A0h, 02h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 0Bh, 10h, 01h,0A2h, 07h,0A4h
		db	 06h, 12h, 06h,0A4h, 07h,0A3h
		db	 06h, 11h, 01h,0A2h, 01h,0A3h
		db	 07h, 5Fh, 01h,0A0h, 06h,0A3h
		db	 06h, 11h, 03h,0A2h, 02h,0A3h
		db	 07h,0A2h, 06h,0A0h, 01h, 12h
		db	 03h,0A2h, 07h,0A4h, 06h, 11h
		db	 01h,0A4h, 07h,0A3h, 06h, 10h
		db	 01h,0A3h, 07h,0A2h, 06h, 12h
		db	 04h,0A1h, 02h,0A2h, 07h,0A4h
		db	 06h,0A2h, 01h,0A4h, 07h,0A3h
		db	 06h,0A0h, 01h, 5Fh, 01h, 12h
		db	 03h,0A3h, 07h,0A2h, 06h, 11h
		db	 02h,0A2h, 08h,0A4h, 06h,0A0h
		db	 03h,0A4h, 07h,0A3h, 06h, 11h
		db	 02h,0A2h, 01h,0A3h, 07h,0A2h
		db	 06h,0A0h, 04h,0A2h, 07h,0A4h
		db	 06h,0A1h, 01h, 11h, 04h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A0h
		db	 02h,0A3h, 07h,0A2h, 06h,0A1h
		db	 02h,0A2h, 07h,0A4h, 06h, 10h
		db	 01h,0A0h, 03h,0A4h, 07h,0A3h
		db	 06h,0A1h, 02h,0A3h, 07h,0A2h
		db	 0Bh, 10h, 01h,0A2h, 07h,0A4h
		db	 06h, 12h, 06h,0A4h, 07h,0A3h
		db	 06h, 11h, 01h,0A2h, 01h,0A3h
		db	 07h,0A0h, 07h,0A3h, 06h, 11h
		db	 03h,0A2h, 02h,0A3h, 07h,0A2h
		db	 06h,0A0h, 01h, 12h, 03h,0A2h
		db	 07h,0A4h, 06h, 11h, 01h,0A4h
		db	 07h,0A3h, 06h, 10h, 01h,0A3h
		db	 07h,0A2h, 06h, 12h, 04h,0A1h
		db	 02h,0A2h, 07h,0A4h, 06h,0A2h
		db	 01h,0A4h, 07h,0A3h, 06h,0A0h
		db	 01h, 5Fh, 01h, 12h, 03h,0A3h
		db	 07h,0A2h, 06h, 11h, 02h,0A2h
		db	 08h,0A4h, 06h,0A0h, 03h,0A4h
		db	 07h,0A3h, 06h, 11h, 02h,0A2h
		db	 01h,0A3h, 07h,0A2h, 06h,0A0h
		db	 04h,0A2h, 07h,0A4h, 06h,0A1h
		db	 01h, 11h, 04h,0A4h, 07h,0A3h
		db	 06h, 10h, 01h,0A0h, 02h,0A3h
		db	 07h,0A2h, 06h,0A1h, 02h,0A2h
		db	 07h,0A4h, 06h, 10h, 01h,0A0h
		db	 03h,0A4h, 07h,0A3h, 06h,0A1h
		db	 02h,0A3h, 07h,0A2h, 0Bh, 10h
		db	 01h,0A2h, 07h,0A4h, 06h, 12h
		db	 06h,0A4h, 07h,0A3h, 06h, 11h
		db	 01h,0A2h, 01h,0A3h, 07h,0FFh
		db	0FFh, 0Bh, 0Bh
		db	 47h, 47h
		db	27 dup (47h)
		db	 0Bh, 0Bh
		db	31 dup (47h)
		db	 0Bh, 47h, 47h
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGFFFFFFFFFFFFFGGGGGGGGGGGGG'
		db	'GGFFFFGGGGGGGGGGGGGFFFFGGGGGGGGG'
		db	'GGFGGGGGGGGGGGGGGGGGGGFGGGGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	 0Bh, 47h, 47h
		db	29 dup (47h)
		db	 0Bh, 47h, 47h
		db	29 dup (47h)
		db	 0Bh, 0Bh
		db	30 dup (47h)
		db	 0Bh, 0Bh, 0Bh, 47h, 47h
		db	27 dup (47h)
		db	 0Bh, 0Bh, 0Bh, 0Bh
		db	28 dup (47h)
		db	 0Bh, 0Bh
		db	29 dup (47h)
		db	 0Bh, 47h, 47h
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGGGGFFFFFFFFFFFFFGGGGGGGGGG'
		db	'GGGGGFFFFGGGGGGGGGGGGGFFFFGGGGGG'
		db	'GGGGGFGGGGGGGGGGGGGGGGGGGFGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGG'
data_c_9E06	dw	4747h			; Data table (indexed access)
data_c_9E08	dw	4747h			; Data table (indexed access)
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	'GGGGGGGGGGGGGGGGGGGGGGGGGGGGG'
		db	 0Bh, 47h, 47h
		db	28 dup (47h)
		db	 0Bh, 0Bh
		db	29 dup (47h)
		db	 0Bh, 0Bh, 0Bh, 0Bh, 0Bh, 47h
		db	 47h
		db	8 dup (47h)
		db	7 dup (46h)
		db	12 dup (47h)
		db	 0Bh, 0Bh
		db	9 dup (47h)
		db	 46h, 46h
		db	7 dup (0AAh)
		db	 46h, 46h
		db	 47h, 47h, 47h, 47h
data_c_9F01	dw	4747h			; Data table (indexed access)
		db	 47h, 47h, 47h, 47h, 47h, 0Bh
		db	 47h
data_c_9F0A	dw	4747h			; Data table (indexed access)
		db	 47h, 47h, 47h, 47h, 46h, 46h
		db	11 dup (0AAh)
		db	 46h, 46h
		db	15 dup (47h)
		db	 46h, 46h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh,0AAh
		db	 46h, 46h
		db	12 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	9 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 46h
		db	11 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	11 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	11 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	11 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	11 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	11 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h, 47h
		db	 47h, 47h, 47h, 47h, 47h, 0Bh
		db	 47h, 47h, 47h, 47h, 47h, 46h
		db	0AAh,0AAh,0AAh,0AAh
		db	9 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	7 dup (47h)
		db	 0Bh, 47h, 47h, 47h, 47h, 47h
		db	 46h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	46h
		db	47h
data_c_A002	db	47h			; Data table (indexed access)
		db	 47h, 47h, 47h, 47h, 47h, 0Bh
		db	 0Bh
		db	 47h, 47h, 47h, 47h, 47h, 46h
		db	 46h
		db	13 dup (0AAh)
		db	 46h, 46h
		db	8 dup (47h)
		db	 0Bh, 0Bh, 0Bh
		db	'GGGGGGFFFF'
		db	0AAh,0AAh,0AAh,0AAh,0AAh
		db	 46h, 46h, 46h, 46h
		db	10 dup (47h)
		db	 0Bh, 0Bh, 0Bh, 0Bh
		db	9 dup (47h)
		db	 46h, 46h, 46h, 46h, 46h
		db	14 dup (47h)
		db	 0Bh, 0Bh
		db	12 dup (47h)
		db	7 dup (46h)
		db	10 dup (47h)
		db	 0Bh, 47h, 47h
		db	10 dup (47h)
		db	 46h, 46h
		db	7 dup (0AAh)
		db	 46h, 46h
		db	19 dup (47h)
		db	 46h, 46h
		db	11 dup (0AAh)
		db	 46h, 46h
		db	15 dup (47h)
		db	 46h, 46h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh,0AAh
		db	 46h, 46h
		db	12 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	9 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 46h
		db	11 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	11 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	11 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	11 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	11 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	11 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	12 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh
		db	9 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 46h
		db	13 dup (47h)
		db	 46h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	46h
		db	14 dup (47h)
		db	 46h, 46h
		db	13 dup (0AAh)
		db	 46h, 46h, 47h, 47h, 47h, 47h
		db	 47h, 0Bh
		db	 47h, 47h
		db	9 dup (47h)
		db	 46h, 46h, 46h, 46h,0AAh,0AAh
		db	0AAh,0AAh,0AAh
		db	'FFFFGGGGGG'
		db	 0Bh, 0Bh
		db	15 dup (47h)
		db	 46h, 46h, 46h, 46h, 46h
		db	9 dup (47h)
		db	 0Bh, 0Bh, 0Bh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h
		db	7 dup (0FFh)
		db	8 dup (0)
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h
		db	7 dup (0)
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h
		db	11 dup (0)
		db	0FFh,0FFh,0FFh,0FFh, 00h,0FFh
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	0FFh, 00h,0FFh, 00h,0FFh,0FFh
		db	0FFh, 00h,0FFh, 00h, 00h, 00h
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 00h,0FFh, 00h,0FFh,0FFh, 00h
		db	0FFh, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h,0FFh,0FFh, 00h,0FFh
		db	 00h,0FFh, 00h,0FFh, 00h,0FFh
		db	 00h
		db	7 dup (0)
		db	0FFh, 00h,0FFh, 00h, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h,0FFh, 00h,0FFh,0FFh
		db	 00h
		db	7 dup (0)
		db	0FFh,0FFh, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0F0h,0F0h,0F0h,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0EDh,0EDh, 00h, 00h, 00h,0F0h
		db	0FAh,0F0h,0F0h,0FAh,0F0h, 00h
		db	 00h, 00h,0EDh,0EDh, 00h, 00h
		db	0EDh, 00h, 00h, 00h,0F0h,0F0h
		db	0F0h,0F0h, 00h, 00h, 00h,0EDh
		db	 00h, 00h, 00h, 00h, 00h,0EDh
		db	 00h, 00h, 00h,0F2h,0F2h, 00h
		db	 00h, 00h,0EDh
		db	7 dup (0)
		db	0EDh,0BAh,0BAh,0BAh,0BAh,0BAh
		db	0BAh,0EDh, 00h, 00h, 00h, 00h
		db	0EDh,0EDh, 00h, 00h,0BAh,0FAh
		db	0BCh,0BAh,0BAh,0BCh,0FAh,0BAh
		db	 00h, 00h,0EDh,0EDh, 00h, 00h
		db	0EDh,0BAh,0EDh,0BCh,0FDh,0BCh
		db	0BCh,0FDh,0BCh,0EDh,0BAh,0EDh
		db	 00h, 00h, 00h, 00h,0BAh, 00h
		db	0BCh, 00h,0FAh,0BCh,0BCh,0FAh
		db	 00h,0BCh, 00h,0BAh, 00h, 00h
		db	 00h,0BAh, 00h,0BCh,0EDh,0BCh
		db	 00h,0BAh,0BAh, 00h,0BCh,0EDh
		db	0BCh, 00h,0BAh, 00h, 00h,0BAh
		db	 00h,0BCh, 00h, 00h,0BAh,0FAh
		db	0FAh,0BAh, 00h, 00h,0BCh, 00h
		db	0BAh, 00h,0BAh, 00h,0BCh, 00h
		db	0BCh,0FDh,0BAh,0FDh,0FDh,0BAh
		db	0FDh,0BCh, 00h,0BCh, 00h,0BAh
		db	0BAh,0EDh,0BCh, 00h, 00h,0BAh
		db	0FAh,0FAh,0FAh,0FAh,0BAh, 00h
		db	 00h,0BCh,0EDh,0BAh, 00h,0BAh
		db	 00h, 00h,0BAh,0FDh,0FDh,0FDh
		db	0FDh,0FDh,0FDh,0BAh, 00h, 00h
		db	0BAh, 00h, 00h, 00h,0BAh,0BAh
		db	 00h, 00h,0FAh,0FAh,0FAh,0FAh
		db	 00h, 00h,0BAh,0BAh, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 00h,0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h,0FFh,0FFh,0FFh, 00h,0FFh
		db	 00h,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h,0FFh, 00h
		db	0FFh, 00h,0FFh,0FFh,0FFh, 00h
		db	7 dup (0)
		db	0FFh,0FFh,0FFh, 00h,0FFh,0FFh
		db	0FFh,0FFh, 00h
		db	7 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	11 dup (0)
		db	0FFh,0FFh, 00h, 00h, 00h,0FFh
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	0FFh, 00h,0FFh, 00h, 00h, 00h
		db	0FFh, 00h,0FFh, 00h,0FFh, 00h
		db	0FFh, 00h, 00h,0FFh, 00h,0FFh
		db	 00h,0FFh, 00h,0FFh,0FFh, 00h
		db	0FFh, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 00h,0FFh, 00h, 00h,0FFh
		db	 00h,0FFh, 00h,0FFh, 00h
		db	11 dup (0)
		db	0FFh, 00h, 00h,0FFh
		db	12 dup (0)
		db	0FFh, 00h,0FFh, 00h, 00h,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h,0FFh
		db	 00h, 00h, 00h, 00h,0FFh, 00h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0F0h,0F0h
		db	0F0h,0F0h
		db	11 dup (0)
		db	0F0h,0FAh,0F0h,0F0h,0FAh,0F0h
		db	7 dup (0)
		db	0EDh, 00h, 00h, 00h,0F0h,0F0h
		db	0F0h,0F0h, 00h, 00h, 00h,0EDh
		db	 00h, 00h, 00h,0EDh, 00h,0EDh
		db	 00h, 00h, 00h,0F2h,0F2h, 00h
		db	 00h, 00h,0EDh, 00h,0EDh, 00h
		db	0EDh, 00h, 00h, 00h,0EDh,0BAh
		db	0BAh,0BAh,0BAh,0BAh,0BAh,0EDh
		db	 00h, 00h, 00h,0EDh, 00h, 00h
		db	 00h, 00h,0BAh,0FAh,0BCh,0BAh
		db	0BAh,0BCh,0FAh,0BAh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0EDh,0BAh
		db	0EDh,0BCh,0FDh,0BCh,0BCh,0FDh
		db	0BCh,0EDh,0BAh,0EDh, 00h, 00h
		db	0EDh,0EDh,0BAh, 00h,0BCh, 00h
		db	0FAh,0BCh,0BCh,0FAh, 00h,0BCh
		db	 00h,0BAh,0EDh,0EDh, 00h,0BAh
		db	 00h,0BCh, 00h,0BCh, 00h,0BAh
		db	0BAh, 00h,0BCh, 00h,0BCh, 00h
		db	0BAh, 00h, 00h,0BAh, 00h,0BCh
		db	0EDh, 00h,0BAh,0FAh,0FAh,0BAh
		db	 00h,0EDh,0BCh, 00h,0BAh, 00h
		db	0BAh, 00h,0BCh,0EDh,0BCh,0FDh
		db	0BAh,0FDh,0FDh,0BAh,0FDh,0BCh
		db	0EDh,0BCh, 00h,0BAh,0BAh, 00h
		db	0BCh,0EDh,0BCh,0FAh,0BAh,0FAh
		db	0FAh,0BAh,0FAh,0BCh,0EDh,0BCh
		db	 00h,0BAh, 00h,0BAh,0EDh, 00h
		db	 00h,0BAh,0FDh,0FDh,0FDh,0FDh
		db	0BAh, 00h, 00h,0EDh,0BAh, 00h
		db	 00h, 00h,0BAh,0BAh,0BAh, 00h
		db	0FAh,0FAh,0FAh,0FAh, 00h,0BAh
		db	0BAh,0BAh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h,0FFh,0FFh
		db	 00h
		db	7 dup (0)
		db	0FFh,0FFh, 00h,0FFh, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	 00h, 00h, 00h,0FFh, 00h,0FFh
		db	8 dup (0)
		db	0FFh, 00h,0FFh, 00h,0FFh, 00h
		db	0FFh, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h,0FFh,0FFh, 00h,0FFh
		db	 00h,0FFh,0FFh, 00h,0FFh, 00h
		db	 00h, 00h,0FFh, 00h, 00h,0FFh
		db	 00h, 00h, 00h,0FFh, 00h,0FFh
		db	0FFh,0FFh, 00h,0FFh, 00h,0FFh
		db	 00h, 00h, 00h, 00h,0FFh, 00h
		db	0FFh, 00h,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	11 dup (0)
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h
		db	7 dup (0)
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	0FFh,0FFh, 00h
		db	7 dup (0)
		db	7 dup (0FFh)
		db	 00h,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh, 00h,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0BAh,0BAh, 00h
		db	 00h,0FAh,0FAh,0FAh,0FAh, 00h
		db	 00h,0BAh,0BAh, 00h, 00h, 00h
		db	0BAh, 00h, 00h,0BAh,0FDh,0FDh
		db	0FDh,0FDh,0FDh,0FDh,0BAh, 00h
		db	 00h,0BAh, 00h,0BAh,0EDh,0BCh
		db	 00h, 00h,0BAh,0FAh,0FAh,0FAh
		db	0FAh,0BAh, 00h, 00h,0BCh,0EDh
		db	0BAh,0BAh, 00h,0BCh, 00h,0BCh
		db	0FDh,0BAh,0FDh,0FDh,0BAh,0FDh
		db	0BCh, 00h,0BCh, 00h,0BAh, 00h
		db	0BAh, 00h,0BCh, 00h, 00h,0BAh
		db	0FAh,0FAh,0BAh, 00h, 00h,0BCh
		db	 00h,0BAh, 00h, 00h,0BAh, 00h
		db	0BCh,0EDh,0BCh, 00h,0BAh,0BAh
		db	 00h,0BCh,0EDh,0BCh, 00h,0BAh
		db	 00h, 00h, 00h,0BAh, 00h,0BCh
		db	 00h,0FAh,0BCh,0BCh,0FAh, 00h
		db	0BCh, 00h,0BAh, 00h, 00h, 00h
		db	 00h,0EDh,0BAh,0EDh,0BCh,0FDh
		db	0BCh,0BCh,0FDh,0BCh,0EDh,0BAh
		db	0EDh, 00h, 00h,0EDh,0EDh, 00h
		db	 00h,0BAh,0FAh,0BCh,0BAh,0BAh
		db	0BCh,0FAh,0BAh, 00h, 00h,0EDh
		db	0EDh, 00h, 00h, 00h, 00h,0EDh
		db	0BAh,0BAh,0BAh,0BAh,0BAh,0BAh
		db	0EDh
		db	7 dup (0)
		db	0EDh, 00h, 00h, 00h,0F2h,0F2h
		db	 00h, 00h, 00h,0EDh, 00h, 00h
		db	 00h, 00h, 00h,0EDh, 00h, 00h
		db	 00h,0F0h,0F0h,0F0h,0F0h, 00h
		db	 00h, 00h,0EDh, 00h, 00h,0EDh
		db	0EDh, 00h, 00h, 00h,0F0h,0FAh
		db	0F0h,0F0h,0FAh,0F0h, 00h, 00h
		db	 00h,0EDh,0EDh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0F0h,0F0h,0F0h
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	0FFh, 00h, 00h, 00h, 00h,0FFh
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh, 00h,0FFh
		db	12 dup (0)
		db	0FFh, 00h, 00h,0FFh
		db	12 dup (0)
		db	0FFh, 00h,0FFh, 00h,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	0FFh, 00h, 00h,0FFh, 00h,0FFh
		db	0FFh, 00h,0FFh, 00h,0FFh, 00h
		db	0FFh, 00h, 00h,0FFh, 00h,0FFh
		db	 00h,0FFh, 00h,0FFh, 00h, 00h
		db	 00h,0FFh, 00h,0FFh, 00h, 00h
		db	 00h, 00h,0FFh, 00h,0FFh, 00h
		db	 00h, 00h,0FFh,0FFh, 00h
		db	11 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	7 dup (0)
		db	0FFh,0FFh,0FFh,0FFh, 00h,0FFh
		db	0FFh,0FFh, 00h
		db	7 dup (0)
		db	0FFh,0FFh,0FFh, 00h,0FFh, 00h
		db	0FFh, 00h,0FFh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh,0FFh, 00h,0FFh
		db	 00h,0FFh,0FFh,0FFh, 00h,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h
		db	7 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	0BAh,0BAh,0BAh, 00h,0FAh,0FAh
		db	0FAh,0FAh, 00h,0BAh,0BAh,0BAh
		db	 00h, 00h, 00h,0BAh,0EDh, 00h
		db	 00h,0BAh,0FDh,0FDh,0FDh,0FDh
		db	0BAh, 00h, 00h,0EDh,0BAh, 00h
		db	0BAh, 00h,0BCh,0EDh,0BCh,0FAh
		db	0BAh,0FAh,0FAh,0BAh,0FAh,0BCh
		db	0EDh,0BCh, 00h,0BAh,0BAh, 00h
		db	0BCh,0EDh,0BCh,0FDh,0BAh,0FDh
		db	0FDh,0BAh,0FDh,0BCh,0EDh,0BCh
		db	 00h,0BAh, 00h,0BAh, 00h,0BCh
		db	0EDh, 00h,0BAh,0FAh,0FAh,0BAh
		db	 00h,0EDh,0BCh, 00h,0BAh, 00h
		db	 00h,0BAh, 00h,0BCh, 00h,0BCh
		db	 00h,0BAh,0BAh, 00h,0BCh, 00h
		db	0BCh, 00h,0BAh, 00h,0EDh,0EDh
		db	0BAh, 00h,0BCh, 00h,0FAh,0BCh
		db	0BCh,0FAh, 00h,0BCh, 00h,0BAh
		db	0EDh,0EDh, 00h, 00h,0EDh,0BAh
		db	0EDh,0BCh,0FDh,0BCh,0BCh,0FDh
		db	0BCh,0EDh,0BAh,0EDh, 00h, 00h
		db	 00h, 00h, 00h, 00h,0BAh,0FAh
		db	0BCh,0BAh,0BAh,0BCh,0FAh,0BAh
		db	 00h, 00h, 00h, 00h,0EDh, 00h
		db	 00h, 00h,0EDh,0BAh,0BAh,0BAh
		db	0BAh,0BAh,0BAh,0EDh, 00h, 00h
		db	 00h,0EDh, 00h,0EDh, 00h,0EDh
		db	 00h, 00h, 00h,0F2h,0F2h, 00h
		db	 00h, 00h,0EDh, 00h,0EDh, 00h
		db	 00h, 00h,0EDh, 00h, 00h, 00h
		db	0F0h,0F0h,0F0h,0F0h, 00h, 00h
		db	 00h,0EDh
		db	7 dup (0)
		db	0F0h,0FAh,0F0h,0F0h,0FAh,0F0h
		db	11 dup (0)
		db	0F0h,0F0h,0F0h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0A4h,0A4h
		db	0A4h, 0Ah, 0Ah, 0Ah, 0Ah,0A4h
		db	0A4h,0A4h,0A4h,0A4h, 0Ah, 0Ah
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	 0Ah, 0Ah,0A4h,0A4h,0A4h,0A4h
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h,0A4h
		db	 0Ah, 0Ah,0A4h,0A4h, 0Ah, 0Ah
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h,0A4h
		db	 0Ah, 0Ah,0A4h,0A4h,0A4h, 0Ah
		db	 0Ah, 0Ah, 0Ah,0A2h,0A4h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A2h
		db	0A2h,0A4h
data_c_A948	db	0Ah
		db	 0Ah, 0Ah,0A4h, 11h, 0Ah, 0Ah
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h, 11h
		db	 0Ah, 0Ah,0A4h,0A4h, 0Ah, 0Ah
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h,0A4h
		db	 0Ah, 0Ah, 0Ah, 0Ah, 11h,0A4h
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h, 0Ah
		db	 0Ah,0A4h,0A4h,0A4h, 0Ah, 0Ah
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h, 0Ah
		db	 0Ah, 0Ah,0A4h,0A4h, 0Ah, 0Ah
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A2h,0A2h,0A4h,0A2h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A4h,0A4h,0A4h
		db	0A4h,0A4h,0A4h, 0Ah, 0Ah, 10h
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A4h,0A3h,0A3h,0A3h,0A3h,0A3h
		db	0A3h,0A1h,0A1h, 11h
		db	7 dup (0A3h)
		db	0A2h,0A2h,0A2h,0A2h,0A2h, 0Ah
		db	 10h, 10h, 10h,0A0h,0A2h,0A2h
		db	 0Ah, 0Ah,0A2h,0A2h,0A2h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 12h
		db	0A1h,0A1h, 0Ah, 0Ah, 0Ah,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A4h,0A4h
		db	0A4h,0A4h,0A4h,0A4h, 10h, 10h
		db	 10h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A4h,0A4h,0A3h,0A3h,0A3h,0A3h
		db	0A3h,0A3h,0A1h,0A1h, 11h
		db	7 dup (0A3h)
		db	0A2h,0A2h,0A2h,0A2h, 0Ah, 0Ah
		db	 10h, 10h, 10h,0A0h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 12h
		db	0A1h,0A1h,0A1h, 0Ah, 0Ah,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A4h,0A4h
		db	0A4h,0A4h,0A4h,0A4h, 0Ah, 0Ah
		db	 10h,0A4h,0A4h, 0Ah, 0Ah, 0Ah
		db	 0Ah,0A4h,0A3h,0A3h, 0Ah, 0Ah
		db	0A3h,0A3h, 0Ah, 0Ah, 11h,0A3h
		db	0A3h, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	0A2h,0A2h,0A2h, 0Ah, 0Ah, 0Ah
		db	 0Ah, 0Ah, 10h,0A0h,0A2h, 0Ah
		db	 0Ah, 0Ah,0A2h,0A2h,0A2h,0A4h
		db	0A4h, 0Ah, 0Ah, 0Ah, 0Ah,0A1h
		db	0A1h,0A1h,0A1h, 0Ah, 0Ah,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h
		db	7 dup (0A2h)
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 0Ah
		db	 0Ah, 10h,0A0h, 0Ah, 0Ah,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h,0A3h, 0Ah
		db	 0Ah,0A3h,0A3h, 0Ah, 0Ah, 11h
		db	 11h, 0Ah, 0Ah,0A3h,0A3h,0A3h
		db	0A3h,0A3h,0A2h,0A2h,0A2h, 0Ah
		db	 0Ah,0A2h, 10h, 10h,0A0h,0A0h
		db	0A2h, 0Ah, 0Ah,0A2h,0A2h,0A2h
		db	0A2h, 0Ah, 0Ah,0A4h,0A4h, 0Ah
		db	 0Ah,0A1h,0A1h,0A1h, 0Ah, 0Ah
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h
		db	7 dup (0A2h)
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 0Ah
		db	 0Ah, 10h,0A0h, 0Ah, 0Ah,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h,0A3h, 0Ah
		db	 0Ah,0A3h,0A3h, 0Ah, 0Ah, 11h
		db	 11h,0A3h, 0Ah, 0Ah, 0Ah, 0Ah
		db	0A3h,0A3h,0A2h,0A2h,0A2h, 0Ah
		db	 0Ah,0A2h, 10h,0A0h,0A0h,0A0h
		db	0A2h, 0Ah, 0Ah,0A2h,0A2h,0A2h
		db	0A2h, 0Ah, 0Ah,0A4h,0A4h,0A4h
		db	0A4h,0A1h,0A1h,0A1h, 0Ah, 0Ah
		db	 0Ah, 0Ah,0A4h,0A4h,0A4h
		db	7 dup (0A2h)
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h, 0Ah
		db	 0Ah, 10h,0A0h, 0Ah, 0Ah,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h,0A3h,0A3h
		db	 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 11h
		db	 11h,0A3h,0A3h,0A3h,0A3h, 0Ah
		db	 0Ah,0A3h,0A2h,0A2h,0A2h, 0Ah
		db	 0Ah,0A2h, 0Ah,0A0h,0A0h,0A0h
		db	0A2h, 0Ah, 0Ah,0A2h,0A2h,0A2h
		db	0A2h, 0Ah, 0Ah,0A4h,0A4h, 0Ah
		db	 0Ah,0A1h,0A1h,0A1h, 0Ah, 0Ah
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h
		db	7 dup (0A2h)
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h, 0Ah
		db	 0Ah, 10h,0A0h,0A4h, 0Ah, 0Ah
		db	 0Ah, 0Ah,0A4h,0A4h,0A3h,0A3h
		db	0A3h,0A3h,0A3h, 0Ah, 0Ah, 11h
		db	 11h, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	0A3h,0A3h,0A2h,0A2h,0A2h,0A2h
		db	 0Ah, 0Ah, 10h,0A0h,0A0h,0A0h
		db	 0Ah, 0Ah, 0Ah, 0Ah,0A2h,0A2h
		db	0A2h,0A4h, 0Ah, 0Ah, 0Ah, 0Ah
		db	0A4h,0A1h,0A1h, 0Ah, 0Ah, 0Ah
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h, 11h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	0A2h,0A4h, 0Ah, 0Ah, 0Ah, 0Ah
		db	0A4h, 10h,0A0h,0A0h,0A4h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 0Ah
		db	 0Ah, 0Ah, 0Ah, 0Ah,0A3h, 11h
		db	 11h
		db	7 dup (0A3h)
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	 10h,0A0h,0A0h,0A0h
		db	7 dup (0A2h)
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A1h,0A1h,0A1h,0A1h,0A1h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A4h,0A4h
		db	 0Ah, 0Ah, 0Ah,0A4h, 10h, 10h
		db	 10h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A4h,0A4h,0A3h,0A3h,0A3h,0A3h
		db	0A3h,0A3h,0A1h,0A1h, 11h,0A3h
		db	 0Ah, 0Ah, 0Ah,0A3h,0A3h,0A3h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	 10h, 10h, 10h,0A0h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 12h
		db	0A1h,0A1h,0A1h,0A1h,0A4h, 0Ah
		db	 0Ah, 0Ah,0A4h,0A4h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A4h,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h, 10h, 10h
		db	 10h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A4h,0A4h,0A3h,0A3h,0A3h,0A3h
		db	0A3h,0A3h,0A1h,0A1h, 11h,0A3h
		db	0A3h, 0Ah, 0Ah,0A3h,0A3h,0A3h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	 10h, 10h, 10h,0A0h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 12h
		db	0A1h,0A1h,0A1h,0A1h,0A4h,0A4h
		db	 0Ah, 0Ah,0A4h,0A4h,0A2h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A4h,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h, 10h, 0Ah
		db	 0Ah,0A4h,0A4h, 0Ah, 0Ah, 0Ah
		db	 0Ah,0A4h,0A3h,0A3h, 0Ah, 0Ah
		db	0A3h,0A3h, 0Ah, 0Ah, 11h,0A3h
		db	0A3h, 0Ah, 0Ah,0A3h,0A3h,0A3h
		db	0A2h,0A2h,0A2h, 0Ah, 0Ah, 0Ah
		db	 0Ah, 10h, 10h,0A0h,0A2h, 0Ah
		db	 0Ah, 0Ah, 0Ah,0A2h,0A2h,0A4h
		db	 0Ah, 0Ah,0A4h, 0Ah, 0Ah, 0Ah
		db	0A1h,0A1h,0A1h,0A1h,0A4h,0A4h
		db	 0Ah, 0Ah,0A4h,0A4h
		db	7 dup (0A2h)
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h, 0Ah
		db	 0Ah, 10h,0A0h, 0Ah, 0Ah,0A4h
		db	0A4h, 0Ah, 0Ah,0A4h,0A3h, 0Ah
		db	 0Ah,0A3h,0A3h, 0Ah, 0Ah, 11h
		db	 11h,0A3h, 0Ah, 0Ah, 0Ah, 0Ah
		db	 0Ah,0A3h,0A2h, 0Ah, 0Ah,0A2h
		db	0A2h, 0Ah, 0Ah, 10h,0A0h,0A0h
		db	0A2h,0A2h,0A2h, 0Ah, 0Ah,0A2h
		db	0A2h,0A4h, 0Ah, 0Ah, 0Ah,0A4h
		db	 0Ah, 0Ah,0A1h,0A1h, 0Ah, 0Ah
		db	 0Ah, 0Ah, 0Ah,0A4h,0A4h
		db	7 dup (0A2h)
		db	0A4h,0A4h, 0Ah, 0Ah, 0Ah, 0Ah
		db	 10h, 10h,0A0h, 0Ah, 0Ah, 0Ah
		db	 0Ah, 0Ah, 0Ah,0A4h,0A3h, 0Ah
		db	 0Ah,0A3h,0A3h, 0Ah, 0Ah, 11h
		db	 11h,0A3h, 0Ah, 0Ah,0A3h,0A3h
		db	 0Ah, 0Ah,0A2h, 0Ah, 0Ah,0A2h
		db	0A2h, 0Ah, 0Ah,0A0h,0A0h,0A0h
		db	 0Ah, 0Ah, 0Ah, 0Ah, 0Ah,0A2h
		db	0A2h,0A4h, 0Ah, 0Ah,0A4h,0A4h
		db	 0Ah, 0Ah,0A1h, 0Ah, 0Ah,0A1h
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	0A4h,0A4h, 0Ah, 0Ah,0A4h, 0Ah
		db	 0Ah, 10h,0A0h, 0Ah, 0Ah,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A3h,0A3h
		db	 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 11h
		db	 11h,0A3h, 0Ah, 0Ah,0A3h,0A3h
		db	 0Ah, 0Ah,0A2h, 0Ah, 0Ah,0A2h
		db	0A2h, 0Ah, 0Ah,0A0h,0A0h, 0Ah
		db	 0Ah,0A2h,0A2h, 0Ah, 0Ah,0A2h
		db	0A2h,0A4h, 0Ah, 0Ah,0A4h,0A4h
		db	0A4h,0A1h,0A1h, 0Ah, 0Ah,0A1h
		db	0A4h, 0Ah, 0Ah,0A4h,0A4h,0A2h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	0A4h, 0Ah, 0Ah, 0Ah,0A4h,0A4h
		db	 0Ah, 0Ah,0A0h,0A4h, 0Ah, 0Ah
		db	 0Ah, 0Ah,0A4h,0A4h,0A3h,0A3h
		db	0A3h,0A3h,0A3h, 0Ah, 0Ah, 11h
		db	 11h, 0Ah, 0Ah,0A3h, 0Ah, 0Ah
		db	 0Ah,0A3h,0A2h,0A2h, 0Ah, 0Ah
		db	 0Ah, 0Ah, 10h,0A0h,0A0h,0A0h
		db	 0Ah, 0Ah, 0Ah,0A2h, 0Ah, 0Ah
		db	0A2h, 0Ah, 0Ah, 0Ah, 0Ah,0A4h
		db	0A4h,0A1h,0A1h,0A1h, 0Ah, 0Ah
		db	 0Ah,0A4h, 0Ah, 0Ah,0A4h, 11h
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	0A2h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A4h, 10h,0A0h,0A0h,0A4h,0A4h
		db	0A4h,0A4h,0A4h,0A4h,0A4h, 0Ah
		db	 0Ah, 0Ah, 0Ah, 0Ah,0A3h, 11h
		db	 11h
		db	7 dup (0A3h)
		db	0A2h,0A2h,0A2h,0A2h,0A2h,0A2h
		db	 10h,0A0h,0A0h,0A0h
		db	7 dup (0A2h)
		db	0A4h,0A4h,0A4h,0A4h,0A4h,0A4h
		db	0A1h,0A1h,0A1h,0A1h,0A1h,0A4h
		db	0A4h,0A4h,0A4h,0A4h
data_c_AE08	dw	50 dup (0)
		db	0
		db	12 dup (0FFh)
		db	 00h,0FFh
		db	10 dup (0FFh)
		db	101 dup (0)
		db	12 dup (0FFh)
		db	 00h,0FFh
		db	10 dup (0FFh)
		db	101 dup (0)
		db	12 dup (0FFh)
		db	 00h,0FFh
		db	10 dup (0FFh)
		db	101 dup (0)
		db	12 dup (0FFh)
		db	 00h,0FFh, 00h,0FFh
		db	8 dup (0FFh)
		db	0, 0, 0, 0, 0
data_c_B001	dw	0			; Data table (indexed access)
		db	94 dup (0)
		db	12 dup (0FFh)
		db	 00h,0FFh, 00h,0FFh
		db	8 dup (0FFh)
		db	101 dup (0)
		db	12 dup (0FFh)
		db	 00h,0FFh, 00h,0FFh
		db	8 dup (0FFh)
		db	101 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	12 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	100 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	14 dup (0)
		db	0FFh,0FFh,0FFh,0FFh, 00h
		db	100 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	16 dup (0)
		db	0FFh,0FFh, 00h
		db	100 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	17 dup (0)
		db	0FFh, 00h
		db	100 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	119 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	119 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	119 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	105 dup (0)
data_c_B535	db	0
		db	13 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	119 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	119 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	119 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	268 dup (0)
		db	101 dup (0FFh)
		db	12 dup (0)
		db	0C5h, 00h
		db	10 dup (0)
		db	101 dup (0FFh)
		db	12 dup (0)
		db	0C5h, 00h
		db	10 dup (0)
		db	101 dup (0FFh)
		db	12 dup (0)
		db	0C5h, 00h
		db	10 dup (0)
		db	101 dup (0FFh)
		db	12 dup (0)
		db	0C5h, 00h,0C5h, 00h
		db	8 dup (0)
		db	10 dup (0FFh)
		db	8, 8, 8, 8
		db	21 dup (0FFh)
		db	8 dup (0Ah)
		db	13 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	12 dup (0FEh)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	11 dup (0)
		db	0C5h, 00h,0C5h, 00h
		db	8 dup (0)
		db	10 dup (0FFh)
		db	8, 8, 8, 8
		db	21 dup (0FFh)
		db	8 dup (0Ah)
		db	13 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	12 dup (0FEh)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	11 dup (0)
		db	0C5h, 00h,0C5h, 00h
		db	8 dup (0)
		db	8 dup (0FFh)
		db	8 dup (8)
		db	17 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah,0FFh,0FFh
		db	0FFh,0FFh, 0Ah, 0Ah, 0Ah, 0Ah
		db	0FFh
		db	10 dup (0FFh)
		db	 09h, 09h, 09h, 09h, 09h, 09h
		db	0FFh,0FFh, 09h, 09h, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F6h,0F6h
		db	0C5h,0F6h,0C5h,0F6h,0F6h,0F6h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	7 dup (0FFh)
		db	8 dup (8)
		db	17 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah,0FFh,0FFh
		db	0FFh,0FFh, 0Ah, 0Ah, 0Ah, 0Ah
		db	0FFh
		db	10 dup (0FFh)
		db	 09h, 09h, 09h, 09h, 09h, 09h
		db	0FFh,0FFh, 09h, 09h, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F6h,0F6h
		db	0C5h,0F6h,0C5h,0F6h,0F6h,0F6h
		db	0F6h,0F6h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h,0FFh,0FFh
		db	0FFh,0FFh, 08h, 08h, 08h, 08h
		db	0FFh
		db	12 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah
		db	21 dup (0FFh)
		db	14 dup (9)
		db	13 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0C5h,0F7h,0C5h,0F7h,0F6h,0F6h
		db	0C3h,0C3h,0F6h,0F6h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h,0FFh,0FFh
		db	0FFh,0FFh, 08h, 08h, 08h, 08h
		db	0FFh
		db	12 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah
		db	21 dup (0FFh)
		db	14 dup (9)
		db	13 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0C5h,0F7h,0C5h,0F7h,0F6h,0F6h
		db	0C3h,0C1h,0C3h,0C3h,0F6h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h,0FFh,0FFh
		db	0FFh,0FFh, 08h, 08h, 08h, 08h
		db	0FFh
		db	12 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah
		db	21 dup (0FFh)
		db	14 dup (9)
		db	13 dup (0FFh)
		db	8 dup (0FEh)
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F8h,0F7h,0C5h,0F7h,0F6h,0F6h
		db	0C3h,0C1h,0C1h,0C1h,0C3h,0F6h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h,0FFh,0FFh
		db	0FFh,0FFh, 08h, 08h, 08h, 08h
		db	0FFh
		db	12 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah
		db	21 dup (0FFh)
		db	14 dup (9)
		db	13 dup (0FFh)
		db	8 dup (0FEh)
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F8h,0F7h,0F8h,0F7h,0F6h,0F6h
		db	0C3h,0C1h,0C1h,0C1h,0C1h,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	8
		db	11 dup (8)
		db	13 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah
		db	21 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	 09h, 09h,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F8h,0F7h,0F8h,0F7h,0F6h,0F6h
		db	0C3h,0C1h,0C1h,0C1h,0C1h,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	8
		db	11 dup (8)
		db	13 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah
		db	21 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	 09h, 09h,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F8h,0F7h,0F8h,0F7h,0F6h,0F6h
		db	0C3h,0C1h,0C1h,0C1h,0C1h,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h,0FFh,0FFh
		db	0FFh,0FFh, 08h, 08h, 08h, 08h
		db	0FFh
		db	14 dup (0FFh)
		db	 0Ah, 0Ah, 0Ah, 0Ah,0FFh,0FFh
		db	0FFh,0FFh, 0Ah, 0Ah, 0Ah, 0Ah
		db	0FFh
		db	10 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0FFh
		db	12 dup (0FFh)
		db	0FEh,0FEh,0FEh,0FEh
		db	14 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F7h,0F7h,0F7h,0F7h,0F6h,0F6h
		db	0C3h,0C3h,0C3h,0C3h,0C3h,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h, 08h, 08h,0C0h,0C0h
		db	0C0h,0C0h,0C0h, 08h, 08h, 08h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0C0h,0C0h,0C0h,0C0h,0C0h,0FFh
		db	0FFh,0FFh,0FFh, 0Ah, 0Ah, 0Ah
		db	 0Ah,0FFh,0FFh,0FFh,0FFh, 0Ah
		db	 0Ah, 0Ah, 0Ah,0FFh
		db	10 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0FFh,0FFh,0C0h,0C0h
		db	0C0h,0C0h,0C0h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FEh,0FEh,0FEh
		db	0C0h,0C0h,0C0h,0C0h,0C0h,0FFh
		db	0FFh
		db	8 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0F6h
		db	0F6h,0F6h,0F6h,0F6h,0F7h,0F7h
		db	0F7h,0F7h,0F7h,0F7h
		db	8 dup (0F6h)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 08h, 08h,0C0h
		db	8 dup (0C0h)
		db	 08h,0FFh,0FFh,0FFh,0FFh,0C0h
		db	8 dup (0C0h)
		db	0FFh,0FFh,0FFh,0FFh, 0Ah
		db	7 dup (0Ah)
		db	13 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 09h, 09h
		db	 09h, 09h,0C0h
		db	8 dup (0C0h)
		db	0FFh,0FFh,0FFh,0FFh,0FEh,0C0h
		db	8 dup (0C0h)
		db	0FEh,0FEh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh
data_c_C001	dw	0			; Data table (indexed access)
		db	 00h, 00h, 00h,0F6h,0F6h,0F6h
		db	0F6h,0F6h,0F7h,0F7h,0F7h,0F7h
		db	0F7h,0F7h,0F6h,0F6h,0F6h,0F6h
		db	0F8h,0F8h,0F8h,0F8h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh
		db	8
		db	11 dup (0C0h)
		db	0FFh,0FFh,0FFh,0C0h
		db	10 dup (0C0h)
		db	0FFh,0FFh,0FFh, 0Ah
		db	7 dup (0Ah)
		db	13 dup (0FFh)
		db	 09h, 09h, 09h, 09h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh
		db	9, 9, 9
		db	11 dup (0C0h)
		db	0FFh,0FFh,0FFh,0C0h
		db	10 dup (0C0h)
		db	0FEh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	0F6h,0F6h,0F6h,0F6h,0F6h,0F7h
		db	0F7h,0F7h,0F7h,0F7h,0F7h
		db	8 dup (0F6h)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0C0h
		db	12 dup (0C0h)
		db	0FFh,0C0h
		db	12 dup (0C0h)
		db	35 dup (0FFh)
		db	13 dup (0C0h)
		db	0FFh,0C0h
		db	12 dup (0C0h)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0C9h,0C9h,0C9h,0C9h,0C9h
		db	15 dup (0F6h)
		db	0F8h,0F8h,0F8h,0F8h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0C0h,0C0h,0C0h
		db	0C0h,0C0h,0C2h,0C2h,0C2h,0C2h
		db	0C2h
		db	9 dup (0C0h)
		db	0C2h,0C2h,0C2h,0C2h,0C2h,0C0h
		db	0C0h,0C0h,0C0h,0C0h,0FFh,0FFh
		db	31 dup (0FFh)
		db	0C0h,0C0h,0C0h,0C0h,0C0h,0C2h
		db	0C2h,0C2h,0C2h,0C2h,0C0h,0C0h
		db	7 dup (0C0h)
		db	0C2h,0C2h,0C2h,0C2h,0C2h,0C0h
		db	0C0h,0C0h,0C0h,0C0h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0C9h,0C9h,0C9h
		db	0C9h,0C9h
		db	19 dup (0F6h)
data_c_C190	dw	30 dup (0FFFFh)
		db	0, 0
		db	13 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	61 dup (0)
		db	0D5h,0D6h
		db	13 dup (0)
		db	0D5h,0D6h,0D3h,0D6h
		db	11 dup (0)
		db	0D6h,0D4h,0D3h,0D4h,0D4h,0D6h
		db	11 dup (0)
		db	0D5h,0D4h,0D5h, 00h,0D5h,0FFh
		db	24 dup (0FFh)
		db	0DCh
		db	13 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0DCh
		db	9 dup (0FFh)
		db	8 dup (0)
		db	8 dup (0FFh)
		db	9 dup (0)
		db	11 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	 00h
		db	24 dup (0)
		db	0DCh
		db	13 dup (0)
		db	0D9h,0DAh,0D8h,0D9h
		db	11 dup (0)
		db	0D9h,0D8h,0D7h,0D7h,0D8h,0DAh
		db	0DCh
		db	9 dup (0)
		db	0D9h,0D7h,0D8h,0D4h,0D7h,0D8h
		db	0D8h,0DAh
		db	8 dup (0)
		db	0DAh,0D9h,0D9h,0DAh,0D8h,0D4h
		db	0D7h,0D7h,0D9h
		db	11 dup (0)
		db	0D9h,0D9h,0DAh,0D8h, 00h, 00h
		db	22 dup (0FFh)
		db	0, 0
		db	12 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h
		db	9 dup (0)
		db	7 dup (0FFh)
		db	10 dup (0)
		db	8 dup (0FFh)
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	 00h, 00h,0FFh
		db	11 dup (0FFh)
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h
		db	21 dup (0)
		db	0D9h,0DBh
		db	12 dup (0)
		db	0D9h,0D7h,0D8h,0D6h,0D7h,0D9h
		db	 00h,0D9h
		db	7 dup (0)
		db	0D9h,0D8h,0D7h,0D6h,0D4h,0D6h
		db	0D4h,0D7h,0D7h,0D9h
		db	7 dup (0)
		db	0DBh,0D9h,0D7h,0D6h,0D9h,0D9h
		db	0D6h,0D4h,0D7h,0DBh
		db	8 dup (0)
		db	0DBh,0D9h, 00h,0D7h,0D8h,0D9h
		db	0D8h,0D9h
		db	12 dup (0)
		db	0D9h,0DBh,0D7h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0DCh, 00h,0FFh
		db	12 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0DCh
		db	10 dup (0FFh)
		db	7 dup (0)
		db	0FFh, 00h, 00h,0DCh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h
		db	11 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	10 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0DCh, 00h,0FFh,0FFh, 00h, 00h
		db	0FFh, 00h, 00h
		db	20 dup (0FFh)
		db	 00h, 00h, 00h,0DCh,0D9h
		db	13 dup (0)
		db	0D9h,0D9h,0D6h,0D8h,0DCh
		db	10 dup (0)
		db	0DAh,0D9h,0D8h,0D5h,0D6h,0D8h
		db	0D9h, 00h,0DAh,0D9h,0DCh, 00h
		db	 00h, 00h, 00h, 00h,0D9h,0D8h
		db	0D5h,0D8h,0D5h,0D8h,0D6h,0D8h
		db	0D5h,0D6h,0D8h,0D9h, 00h, 00h
		db	 00h, 00h, 00h,0DAh,0D9h,0D8h
		db	0D8h,0D9h,0D8h,0D6h,0D9h,0D8h
		db	0D5h,0DAh, 00h, 00h, 00h, 00h
		db	 00h, 00h,0DCh,0D9h, 00h, 00h
		db	0D9h,0D8h, 00h,0D9h,0DAh
		db	20 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h
		db	9 dup (0FFh)
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h
		db	9 dup (0)
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h
		db	9 dup (0)
		db	7 dup (0FFh)
		db	8 dup (0)
		db	9 dup (0FFh)
		db	 00h, 00h, 00h,0FFh,0FFh, 00h
		db	24 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0D8h
		db	0D7h,0D9h
		db	9 dup (0)
		db	0D8h,0D7h, 00h,0D8h,0D5h,0D5h
		db	0D7h,0D9h
		db	7 dup (0)
		db	0D8h,0D5h,0D5h,0D7h,0D5h,0D4h
		db	0D3h,0D5h,0D7h,0D8h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0D9h,0D4h
		db	0D3h,0D4h,0D5h,0D5h,0D4h,0D3h
		db	0D5h,0D7h
		db	7 dup (0)
		db	0D9h,0D5h,0D3h,0D5h,0D7h,0D5h
		db	0D5h,0D8h
		db	9 dup (0)
		db	0D8h,0D5h,0D9h, 00h, 00h,0D9h
		db	24 dup (0)
		db	0FFh,0FFh, 00h, 00h,0FFh
		db	12 dup (0FFh)
		db	 00h, 00h, 00h, 00h,0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh, 00h
		db	7 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh, 00h, 00h
		db	8 dup (0FFh)
		db	 00h, 00h,0FFh, 00h,0FFh,0FFh
		db	 00h
		db	40 dup (0FFh)
		db	 00h, 00h,0D7h,0D6h
		db	13 dup (0)
		db	0D7h,0D5h,0D4h,0D6h
		db	11 dup (0)
		db	0D7h,0D5h,0D3h,0D3h,0D5h,0D7h
		db	 00h, 00h,0D6h
		db	7 dup (0)
		db	0D6h,0D5h,0D4h,0D5h,0D7h,0D6h
		db	 00h,0D7h,0D7h
		db	8 dup (0)
		db	0D6h,0D7h, 00h,0D6h, 00h, 00h
		db	0D6h
		db	40 dup (0)
		db	0FFh,0FFh, 00h
		db	14 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	11 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	11 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	42 dup (0FFh)
		db	 00h, 00h,0D3h, 00h
		db	13 dup (0)
		db	0D6h,0D5h,0D7h
		db	12 dup (0)
		db	0D6h,0D5h,0D3h,0D5h,0D4h,0D3h
		db	 00h
		db	10 dup (0)
		db	0D4h,0D5h,0D3h,0D5h,0D7h
		db	12 dup (0)
		db	0D3h,0D8h,0D4h, 00h
		db	42 dup (0)
		db	0FFh, 00h
		db	14 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	12 dup (0FFh)
		db	 00h, 00h, 00h,0FFh
		db	13 dup (0FFh)
		db	 00h,0FFh, 00h,0FFh
		db	59 dup (0FFh)
		db	 00h,0DAh
		db	14 dup (0)
		db	0D7h,0D3h,0D7h
		db	13 dup (0)
		db	0DAh,0D4h,0D5h
		db	14 dup (0)
		db	0D7h, 00h,0D6h
		db	60 dup (0)

seg_c		ends



;------------------------------------------------------------  seg_d   ----

seg_d		segment	byte public
		assume cs:seg_d  , ds:seg_d , ss:stack_seg_a

; Compressed intro image

		db	0, 2, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 3
		db	2, 5, 0, 3, 3, 5
		db	0, 3, 1, 5, 0, 2
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 2, 7
		db	0, 1, 3, 7, 0, 1
		db	1, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 2, 7, 0, 1
		db	3, 7, 0, 1, 1, 7
		db	0, 1, 1, 7, 0, 1
		db	2, 7, 0, 1, 3, 7
		db	0, 1, 1, 7, 0, 1
		db	2, 7, 0, 1, 3, 7
		db	0, 1, 1, 7, 0, 1
		db	2, 7
data_d_0200	db	0
		db	1, 3, 7, 0, 1, 1
data_d_0207	db	7			; Data table (indexed access)
data_d_0208	db	0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	1, 2, 7, 0, 1, 3
		db	7, 0, 1, 1, 7, 0
		db	2, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5, 0, 3, 3, 5, 0
		db	3, 1, 5, 0, 3, 2
		db	5
data_d_0300	db	0
		db	 03h, 03h, 05h, 00h, 03h, 01h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 01h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 01h
		db	 05h, 00h,0FFh, 00h, 44h, 03h
		db	 05h, 00h,0FFh, 00h, 34h, 02h
		db	 05h, 00h, 02h, 03h, 07h, 00h
		db	0FFh, 00h, 32h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h,0FFh, 00h
		db	 32h, 02h, 07h, 00h, 01h, 03h
		db	 07h, 00h,0FFh, 00h, 32h, 02h
		db	 07h, 00h, 02h, 03h, 05h, 00h
		db	 51h, 04h, 0Ch, 00h, 0Ch, 04h
		db	 15h, 00h, 09h, 04h, 06h, 00h
		db	 0Ch, 04h, 12h, 00h, 06h, 04h
		db	 15h, 00h, 03h, 04h, 12h, 00h
		db	 58h, 02h, 05h, 00h, 59h, 04h
		db	 0Ch, 00h, 0Ch, 04h, 15h, 00h
		db	 09h, 04h, 06h, 00h, 0Ch, 04h
		db	 12h, 00h, 06h, 04h, 15h, 00h
		db	 03h, 04h, 12h, 00h, 60h, 02h
		db	 05h, 00h, 51h, 04h, 0Ch, 00h
		db	 0Ch, 04h, 15h, 00h, 09h, 04h
		db	 06h, 00h, 0Ch, 04h, 12h, 00h
		db	 06h, 04h, 15h, 00h, 03h, 04h
		db	 12h, 00h, 58h, 03h, 05h, 00h
		db	 02h, 02h, 07h, 00h, 53h, 04h
		db	 06h, 00h, 12h, 04h, 06h, 00h
		db	 09h, 04h, 03h, 00h, 06h, 04h
		db	 0Ch, 00h, 0Ch, 04h, 06h, 00h
		db	 06h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 09h, 04h, 03h, 00h
		db	 06h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 54h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 53h, 04h
		db	 06h, 00h, 12h, 04h, 06h, 00h
		db	 09h, 04h, 03h, 00h, 06h, 04h
		db	 0Ch, 00h, 0Ch, 04h, 06h, 00h
		db	 06h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 09h, 04h, 03h, 00h
		db	 06h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 54h, 03h, 07h, 00h
		db	 01h, 02h
data_d_0405	db	7			; Data table (indexed access)
		db	 00h, 53h, 04h, 06h, 00h, 12h
		db	 04h, 06h, 00h, 09h, 04h, 03h
		db	 00h, 06h, 04h, 0Ch, 00h, 0Ch
		db	 04h, 06h, 00h, 06h, 04h, 06h
		db	 00h, 06h, 04h, 06h, 00h, 09h
		db	 04h, 03h, 00h, 06h, 04h, 06h
		db	 00h, 06h, 04h, 06h, 00h, 54h
		db	 03h, 07h, 00h, 02h, 02h, 05h
		db	 00h, 54h, 04h, 06h, 00h, 12h
		db	 04h, 06h, 00h, 03h, 04h, 03h
		db	 00h, 09h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 09h, 04h, 06h
		db	 00h, 06h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 03h, 04h, 03h
		db	 00h, 0Ch, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 55h, 03h, 05h
		db	 00h, 5Ch, 04h, 06h, 00h, 12h
		db	 04h, 06h, 00h, 03h, 04h, 03h
		db	 00h, 09h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 09h, 04h, 06h
		db	 00h, 06h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 03h, 04h, 03h
		db	 00h, 0Ch, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 5Dh, 01h, 05h
		db	 00h, 54h, 04h, 06h, 00h, 12h
		db	 04h, 06h, 00h, 03h, 04h, 03h
		db	 00h, 09h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 09h, 04h, 06h
		db	 00h, 06h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 03h, 04h, 03h
		db	 00h, 0Ch, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 55h, 01h, 05h
		db	 00h, 02h, 01h, 07h, 00h, 53h
		db	 04h, 06h, 00h, 12h, 04h, 0Ch
		db	 00h, 09h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 09h, 04h, 0Fh
		db	 00h, 09h, 04h, 0Ch, 00h, 0Ch
		db	 04h, 0Fh, 00h, 57h, 01h, 07h
		db	 00h, 01h, 01h, 07h, 00h, 53h
		db	 04h, 06h, 00h, 12h, 04h, 0Ch
		db	 00h, 09h, 04h, 06h, 00h, 06h
		db	 04h, 06h, 00h, 09h, 04h, 0Fh
		db	 00h, 09h, 04h, 0Ch, 00h
		db	0Ch
data_d_0508	db	4			; Data table (indexed access)
		db	 0Fh, 00h, 57h, 01h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 53h, 04h
		db	 06h, 00h, 12h, 04h, 0Ch, 00h
		db	 09h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 09h, 04h, 0Fh, 00h
		db	 09h, 04h, 0Ch, 00h, 0Ch, 04h
		db	 0Fh, 00h, 57h, 01h, 07h, 00h
		db	 02h, 01h, 05h, 00h, 54h, 04h
		db	 06h, 00h, 09h, 04h, 03h, 00h
		db	 06h, 04h, 06h, 00h, 03h, 04h
		db	 03h, 00h, 09h, 04h, 12h, 00h
		db	 09h, 04h, 06h, 00h, 12h, 04h
		db	 06h, 00h, 03h, 04h, 03h, 00h
		db	 0Ch, 04h, 06h, 00h, 03h, 04h
		db	 06h, 00h, 58h, 01h, 05h, 00h
		db	 5Ch, 04h, 06h, 00h, 09h, 04h
		db	 03h, 00h, 06h, 04h, 06h, 00h
		db	 03h, 04h, 03h, 00h, 09h, 04h
		db	 12h, 00h, 09h, 04h, 06h, 00h
		db	 12h, 04h, 06h, 00h, 03h, 04h
		db	 03h, 00h, 0Ch, 04h, 06h, 00h
		db	 03h, 04h, 06h, 00h, 60h, 03h
		db	 05h, 00h, 54h, 04h, 06h, 00h
		db	 09h, 04h, 03h, 00h, 06h, 04h
		db	 06h, 00h, 03h, 04h, 03h, 00h
		db	 09h, 04h, 12h, 00h, 09h, 04h
		db	 06h, 00h, 12h, 04h, 06h, 00h
		db	 03h, 04h, 03h, 00h, 0Ch, 04h
		db	 06h, 00h, 03h, 04h, 06h, 00h
		db	 58h, 02h, 05h, 00h, 02h, 03h
		db	 07h, 00h, 53h, 04h, 06h, 00h
		db	 06h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 09h, 04h, 03h, 00h
		db	 03h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 09h, 04h, 06h, 00h
		db	 12h, 04h, 06h, 00h, 09h, 04h
		db	 03h, 00h, 06h, 04h, 06h, 00h
		db	 06h, 04h, 06h, 00h, 54h, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 53h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 09h, 04h, 03h, 00h, 03h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 09h, 04h, 06h, 00h, 12h, 04h
		db	 06h, 00h, 09h, 04h, 03h, 00h
		db	 06h, 04h, 06h, 00h, 06h, 04h
		db	 06h, 00h, 54h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 53h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 06h, 04h, 06h, 00h, 09h, 04h
		db	 03h, 00h, 03h, 04h, 06h, 00h
		db	 06h, 04h, 06h, 00h, 09h, 04h
		db	 06h, 00h, 12h, 04h, 06h, 00h
		db	 09h, 04h, 03h, 00h, 06h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 54h, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h, 51h, 04h, 15h, 00h
		db	 03h, 04h, 15h, 00h, 03h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 06h, 04h, 0Ch, 00h, 0Ch, 04h
		db	 15h, 00h, 03h, 04h, 09h, 00h
		db	 06h, 04h, 06h, 00h, 55h, 02h
		db	 05h, 00h, 59h, 04h, 15h, 00h
		db	 03h, 04h, 15h, 00h, 03h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 06h, 04h, 0Ch, 00h, 0Ch, 04h
		db	 15h, 00h, 03h, 04h, 09h, 00h
		db	 06h, 04h, 06h, 00h, 5Dh, 02h
		db	 05h, 00h, 51h, 04h, 15h, 00h
		db	 03h, 04h, 15h, 00h, 03h, 04h
		db	 06h, 00h, 06h, 04h, 06h, 00h
		db	 06h, 04h, 0Ch, 00h, 0Ch, 04h
		db	 15h, 00h, 03h, 04h, 09h, 00h
		db	 06h, 04h, 06h, 00h, 55h, 03h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	0FFh, 00h, 32h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h,0FFh, 00h
		db	 32h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h,0FFh, 00h, 32h, 03h
		db	 07h, 00h, 02h, 02h, 05h, 00h
		db	0FFh, 00h, 34h, 03h, 05h, 00h
		db	0FFh, 00h, 44h, 01h, 05h, 00h
		db	0FFh, 00h, 34h, 01h, 05h, 00h
		db	 02h, 01h, 07h, 00h,0FFh, 00h
		db	32h
data_d_0702	db	1			; Data table (indexed access)
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	0FFh, 00h, 32h, 01h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 9Ch, 06h
		db	 05h, 00h, 90h, 01h, 07h, 00h
		db	 02h, 01h, 05h, 00h, 11h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 04h, 06h, 04h, 00h, 04h, 06h
		db	 02h, 00h, 0Ch, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 1Ch, 06h
		db	 02h, 00h, 1Eh, 06h, 02h, 00h
		db	 0Dh, 06h, 05h, 00h, 15h, 06h
		db	 01h, 00h, 05h, 06h, 01h, 00h
		db	 08h, 06h, 04h, 00h, 24h, 06h
		db	 02h, 00h, 0Ch, 06h, 03h, 00h
		db	 08h, 06h, 01h, 00h, 0Eh, 06h
		db	 02h, 00h, 05h, 06h, 04h, 00h
		db	 04h, 06h, 04h, 00h, 04h, 06h
		db	 04h, 00h, 1Dh, 01h, 05h, 00h
		db	 19h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 03h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 04h, 00h, 0Bh, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 3Bh, 06h
		db	 03h, 00h, 0Ch, 06h, 02h, 00h
		db	 03h, 06h, 02h, 00h, 12h, 06h
		db	 02h, 00h, 02h, 06h, 03h, 00h
		db	 02h, 06h, 02h, 00h, 05h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 32h, 06h, 02h, 00h, 07h, 06h
		db	 02h, 00h, 0Dh, 06h, 03h, 00h
		db	 04h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 24h, 03h, 05h, 00h, 11h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 06h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 0Ah, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 03h, 06h, 04h, 00h
		db	 03h, 06h, 02h, 00h, 01h, 06h
		db	 03h, 00h, 03h, 06h, 05h, 00h
		db	 03h, 06h, 03h, 00h, 05h, 06h
		db	 04h, 00h, 03h, 06h, 05h, 00h
		db	 0Dh, 06h, 02h, 00h, 0Ch, 06h
		db	 02h, 00h, 02h, 06h, 03h, 00h
		db	 12h, 06h, 01h, 00h, 02h, 06h
		db	 01h, 00h, 03h, 06h, 01h, 00h
		db	 02h, 06h, 01h, 00h, 04h, 06h
		db	 02h, 00h, 07h, 06h, 04h, 00h
		db	 03h, 06h, 02h, 00h, 01h, 06h
		db	 03h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 01h, 06h, 03h, 00h
		db	 03h, 06h, 03h, 00h, 05h, 06h
		db	 03h, 00h, 01h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 01h, 06h
		db	 02h, 00h, 03h, 06h, 05h, 00h
		db	 0Ch, 06h, 02h, 00h, 04h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 06h, 06h, 02h, 00h
		db	 1Ch, 02h, 05h, 00h, 02h, 03h
		db	 07h, 00h, 10h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 06h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 0Ah, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 03h, 06h, 03h, 00h
		db	 01h, 06h, 02h, 00h, 01h, 06h
		db	 02h, 00h, 08h, 06h, 02h, 00h
		db	 04h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 0Ch, 06h
		db	 02h, 00h, 0Ch, 06h, 02h, 00h
		db	 01h, 06h, 04h, 00h, 12h, 06h
		db	 01h, 00h, 02h, 06h, 01h, 00h
		db	 06h, 06h, 01h, 00h, 04h, 06h
		db	 02h, 00h, 06h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 03h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 01h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 03h, 06h, 03h, 00h
		db	 01h, 06h, 02h, 00h, 03h, 06h
		db	 02h, 00h, 04h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 03h, 06h
		db	 03h, 00h, 01h, 06h, 02h, 00h
		db	 03h, 06h, 02h, 00h, 0Eh, 06h
		db	 02h, 00h, 05h, 06h, 05h, 00h
		db	 03h, 06h, 05h, 00h, 04h, 06h
		db	 03h, 00h, 1Ch, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 10h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 03h, 00h, 01h, 06h, 06h, 00h
		db	 0Ah, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 02h, 06h, 06h, 00h
		db	 03h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 02h, 06h, 04h, 00h
		db	 05h, 06h, 02h, 00h, 04h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 0Ch, 06h, 02h, 00h
		db	 0Ch, 06h, 04h, 00h, 01h, 06h
		db	 02h, 00h, 12h, 06h, 01h, 00h
		db	 02h, 06h, 01h, 00h, 03h, 06h
		db	 01h, 00h, 02h, 06h, 01h, 00h
		db	 04h, 06h, 02h, 00h, 06h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 03h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 01h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 03h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 03h, 06h, 02h, 00h, 04h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 03h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 03h, 06h, 02h, 00h
		db	 0Eh, 06h, 02h, 00h, 08h, 06h
		db	 02h, 00h, 06h, 06h, 02h, 00h
		db	 03h, 06h, 02h, 00h, 1Eh, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 11h, 06h, 04h, 00h, 04h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 01h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 0Bh, 06h, 04h, 00h
		db	 03h, 06h, 02h, 00h, 07h, 06h
		db	 02h, 00h, 09h, 06h, 02h, 00h
		db	 04h, 06h, 02h, 00h, 04h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 0Ch, 06h, 02h, 00h
		db	 06h, 06h, 02h, 00h, 04h, 06h
		db	 03h, 00h, 02h, 06h, 02h, 00h
		db	 12h, 06h, 02h, 00h, 02h, 06h
		db	 03h, 00h, 02h, 06h, 02h, 00h
		db	 05h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 01h, 06h, 02h, 00h
		db	 02h, 06h, 02h, 00h, 03h, 06h
		db	 05h, 00h, 03h, 06h, 05h, 00h
		db	 03h, 06h, 02h, 00h, 07h, 06h
		db	 02h, 00h, 05h, 06h, 05h, 00h
		db	 03h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 03h, 06h, 02h, 00h
		db	 01h, 06h, 01h, 00h, 0Ch, 06h
		db	 02h, 00h, 07h, 06h, 02h, 00h
		db	 06h, 06h, 02h, 00h, 03h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 1Bh, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h, 13h, 06h, 02h, 00h
		db	 06h, 06h, 05h, 00h, 01h, 06h
		db	 02h, 00h, 02h, 06h, 02h, 00h
		db	 0Ch, 06h, 02h, 00h, 05h, 06h
		db	 04h, 00h, 03h, 06h, 04h, 00h
		db	 04h, 06h, 05h, 00h, 04h, 06h
		db	 04h, 00h, 04h, 06h, 04h, 00h
		db	 03h, 06h, 02h, 00h, 02h, 06h
		db	 02h, 00h, 0Ah, 06h, 06h, 00h
		db	 04h, 06h, 02h, 00h, 05h, 06h
		db	 05h, 00h, 15h, 06h, 01h, 00h
		db	 05h, 06h, 01h, 00h, 08h, 06h
		db	 04h, 00h, 03h, 06h, 04h, 00h
		db	 04h, 06h, 02h, 00h, 09h, 06h
		db	 02h, 00h, 02h, 06h, 04h, 00h
		db	 05h, 06h, 04h, 00h, 07h, 06h
		db	 02h, 00h, 02h, 06h, 03h, 00h
		db	 02h, 06h, 02h, 00h, 04h, 06h
		db	 02h, 00h, 0Bh, 06h, 06h, 00h
		db	 03h, 06h, 03h, 00h, 05h, 06h
		db	 03h, 00h, 04h, 06h, 06h, 00h
		db	 1Ch, 02h, 05h, 00h,0A5h, 06h
		db	 05h, 00h, 17h, 06h, 04h, 00h
		db	 04h, 06h, 05h, 00h, 13h, 06h
		db	 05h, 00h, 5Dh, 02h, 05h, 00h
		db	0FFh, 00h, 34h, 03h, 05h, 00h
		db	 02h, 02h, 07h, 00h,0FFh, 00h
		db	 32h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h,0FFh, 00h, 32h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	0FFh, 00h, 32h, 03h, 07h, 00h
		db	 02h, 02h, 05h, 00h,0FFh, 00h
		db	 34h, 03h, 05h, 00h,0FFh, 00h
		db	 44h, 01h, 05h, 00h,0FFh, 00h
		db	 34h, 01h, 05h, 00h, 02h, 01h
		db	 07h, 00h,0FFh, 00h, 32h, 01h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 11h, 07h, 04h, 00h, 05h, 07h
		db	 03h, 00h, 3Fh, 07h, 02h, 00h
		db	 1Dh, 07h, 01h, 00h, 04h, 07h
		db	 03h, 00h, 07h, 07h, 02h, 00h
		db	0A5h, 01h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 12h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 5Ch, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h,0AEh, 01h
		db	 07h, 00h, 02h, 01h, 05h, 00h
		db	 13h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Dh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 04h, 00h, 03h, 07h, 05h, 00h
		db	 07h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 05h, 07h, 05h, 00h
		db	 0Bh, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 13h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 44h, 01h
		db	 05h, 00h, 1Bh, 07h, 02h, 00h
		db	 04h, 07h, 04h, 00h, 0Ch, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 07h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 12h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 4Bh, 03h, 05h, 00h
		db	 13h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Dh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ah, 07h, 06h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 0Bh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 02h, 07h, 07h, 00h, 01h, 07h
		db	 06h, 00h, 12h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 43h, 02h
		db	 05h, 00h, 02h, 03h, 07h, 00h
		db	 12h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Eh, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 0Ch, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 08h, 07h, 02h, 00h
		db	 0Bh, 07h, 05h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 0Dh, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 46h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 11h, 07h
		db	 04h, 00h, 03h, 07h, 04h, 00h
		db	 10h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 0Ah, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 07h, 07h
		db	 02h, 00h, 0Dh, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 0Fh, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 05h, 07h
		db	 02h, 00h, 10h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 04h, 00h, 45h, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 28h, 07h, 05h, 00h, 2Ch, 07h
		db	 04h, 00h, 0Bh, 07h, 05h, 00h
		db	 33h, 07h, 05h, 00h, 1Ch, 07h
		db	 02h, 00h, 0Dh, 07h, 05h, 00h
		db	 5Ch, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h, 2Ch, 07h, 01h, 00h
		db	 0Eh, 07h, 02h, 00h, 04h, 07h
		db	 03h, 00h, 10h, 07h, 01h, 00h
		db	 06h, 07h, 02h, 00h, 35h, 07h
		db	 03h, 00h, 07h, 07h, 03h, 00h
		db	 0Ah, 07h, 03h, 00h, 47h, 07h
		db	 02h, 00h, 0Fh, 07h, 01h, 00h
		db	 0Fh, 07h, 03h, 00h, 1Ch, 02h
		db	 05h, 00h, 33h, 07h, 02h, 00h
		db	 15h, 07h, 02h, 00h, 0Fh, 07h
		db	 02h, 00h, 3Eh, 07h, 02h, 00h
		db	 08h, 07h, 02h, 00h, 0Bh, 07h
		db	 02h, 00h, 57h, 07h, 02h, 00h
		db	 10h, 07h, 02h, 00h, 24h, 02h
		db	 05h, 00h, 12h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 04h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 03h, 07h, 03h, 00h
		db	 05h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 05h, 00h, 03h, 07h
		db	 03h, 00h, 05h, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 0Bh, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 0Bh, 07h, 02h, 00h
		db	 06h, 07h, 04h, 00h, 0Ch, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 03h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 05h, 07h, 04h, 00h
		db	 04h, 07h, 05h, 00h, 03h, 07h
		db	 04h, 00h, 07h, 07h, 02h, 00h
		db	 1Ch, 03h, 05h, 00h, 02h, 02h
		db	 07h, 00h, 10h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 05h, 07h, 05h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ah, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 05h, 07h, 05h, 00h
		db	 0Bh, 07h, 05h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 08h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 1Bh, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 10h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ah, 07h, 07h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 06h, 00h, 0Bh, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 06h, 00h
		db	 02h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 05h, 07h, 05h, 00h
		db	 04h, 07h, 02h, 00h, 04h, 07h
		db	 06h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 1Bh, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 10h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 03h, 07h, 02h, 00h
		db	 07h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 04h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ah, 07h, 07h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Bh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 0Eh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 03h, 07h, 05h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 02h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 15h, 03h
		db	 07h, 00h, 02h, 02h, 05h, 00h
		db	 12h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 05h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 09h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 03h, 07h, 04h, 00h
		db	 0Ch, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 05h, 07h
		db	 04h, 00h, 05h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 16h, 03h, 05h, 00h,0D1h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 66h, 01h, 05h, 00h, 14h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 06h, 00h, 0Ch, 07h, 02h, 00h
		db	 47h, 07h, 01h, 00h, 0Fh, 07h
		db	 03h, 00h, 0Bh, 07h, 02h, 00h
		db	 0Dh, 07h, 07h, 00h, 23h, 07h
		db	 02h, 00h, 06h, 07h, 03h, 00h
		db	 4Dh, 01h, 05h, 00h, 02h, 01h
		db	 07h, 00h, 12h, 07h, 02h, 00h
		db	 05h, 07h, 05h, 00h, 03h, 07h
		db	 03h, 00h, 04h, 07h, 02h, 00h
		db	 58h, 07h, 02h, 00h, 10h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 0Dh, 07h, 02h, 00h, 03h, 07h
		db	 01h, 00h, 2Ah, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 4Bh, 01h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 11h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 08h, 07h, 02h, 00h
		db	 04h, 07h, 05h, 00h, 0Ch, 07h
		db	 03h, 00h, 05h, 07h, 05h, 00h
		db	 0Bh, 07h, 05h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 04h, 00h, 04h, 07h, 05h, 00h
		db	 03h, 07h, 05h, 00h, 03h, 07h
		db	 04h, 00h, 07h, 07h, 02h, 00h
		db	 0Dh, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 0Ch, 07h
		db	 03h, 00h, 05h, 07h, 02h, 00h
		db	 0Dh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 2Bh, 01h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 11h, 07h
		db	 02h, 00h, 06h, 07h, 04h, 00h
		db	 05h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 08h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 0Dh, 07h, 02h, 00h, 0Ch, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 04h, 07h, 04h, 00h, 0Ch, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 2Bh, 01h
		db	 07h, 00h, 02h, 01h, 05h, 00h
		db	 12h, 07h, 02h, 00h, 09h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 08h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 0Ch, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 06h, 00h, 03h, 07h, 04h, 00h
		db	 05h, 07h, 02h, 00h, 04h, 07h
		db	 06h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Dh, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 06h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Dh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 2Ch, 01h, 05h, 00h
		db	 1Bh, 07h, 02h, 00h, 04h, 07h
		db	 05h, 00h, 05h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 08h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 03h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 02h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 0Dh, 07h, 02h, 00h, 03h, 07h
		db	 01h, 00h, 02h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Eh, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 34h, 03h
		db	 05h, 00h, 14h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 04h, 07h
		db	 06h, 00h, 03h, 07h, 04h, 00h
		db	 0Ch, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 0Bh, 07h, 05h, 00h
		db	 04h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 03h, 07h, 05h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 0Dh, 07h, 07h, 00h, 03h, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Bh, 07h, 04h, 00h
		db	 03h, 07h, 04h, 00h, 10h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 04h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 2Bh, 02h, 05h, 00h
		db	 02h, 03h, 07h, 00h, 60h, 07h
		db	 05h, 00h, 03h, 07h, 05h, 00h
		db	 83h, 07h, 05h, 00h, 3Ch, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 13h, 07h, 03h, 00h, 13h, 07h
		db	 02h, 00h, 08h, 07h, 01h, 00h
		db	 1Ch, 07h, 03h, 00h, 40h, 07h
		db	 01h, 00h, 0Eh, 07h, 02h, 00h
		db	 04h, 07h, 03h, 00h, 10h, 07h
		db	 01h, 00h, 06h, 07h, 02h, 00h
		db	 6Dh, 02h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 14h, 07h, 02h, 00h
		db	 13h, 07h, 02h, 00h, 07h, 07h
		db	 02h, 00h, 1Dh, 07h, 02h, 00h
		db	 3Fh, 07h, 02h, 00h, 15h, 07h
		db	 02h, 00h, 0Fh, 07h, 02h, 00h
		db	 75h, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h, 15h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 07h, 07h, 05h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 0Ch, 07h
		db	 04h, 00h, 0Ch, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 04h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 03h, 07h, 03h, 00h
		db	 05h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 05h, 00h, 03h, 07h
		db	 03h, 00h, 05h, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 13h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 34h, 02h, 05h, 00h, 1Ah, 07h
		db	 05h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 0Ch, 07h
		db	 07h, 00h, 05h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 0Ah, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 05h, 07h, 05h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 12h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 3Ch, 02h, 05h, 00h, 11h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 0Ch, 07h, 07h, 00h
		db	 02h, 07h, 05h, 00h, 03h, 07h
		db	 04h, 00h, 03h, 07h, 06h, 00h
		db	 0Bh, 07h, 05h, 00h, 0Ah, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 12h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 34h, 03h, 05h, 00h
		db	 02h, 02h, 07h, 00h, 10h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 0Ah, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Eh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 03h, 07h, 02h, 00h, 07h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 0Dh, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 33h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 11h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Dh, 07h, 02h, 00h
		db	 0Bh, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 0Ch, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 0Ah, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 05h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 10h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 32h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h,0D9h, 07h, 02h, 00h
		db	 0Dh, 07h, 05h, 00h, 44h, 03h
		db	 07h, 00h, 02h, 02h, 05h, 00h
		db	 7Ch, 07h, 03h, 00h, 0Dh, 07h
		db	 01h, 00h, 4Fh, 07h, 03h, 00h
		db	 12h, 07h, 03h, 00h, 3Fh, 03h
		db	 05h, 00h, 85h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 50h, 07h
		db	 02h, 00h, 13h, 07h, 02h, 00h
		db	 47h, 01h, 05h, 00h, 12h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 03h, 07h
		db	 04h, 00h, 0Ch, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 04h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 03h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 04h, 00h, 07h, 07h, 02h, 00h
		db	 0Bh, 07h, 05h, 00h, 03h, 07h
		db	 04h, 00h, 0Ch, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Bh, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 07h, 07h
		db	 02h, 00h, 0Bh, 07h, 05h, 00h
		db	 03h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 03h, 07h, 04h, 00h
		db	 25h, 01h, 05h, 00h, 02h, 01h
		db	 07h, 00h, 14h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 05h, 00h, 0Ch, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 05h, 00h, 0Ah, 07h
		db	 02h, 00h, 07h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 23h, 01h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 11h, 07h, 05h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 06h, 00h
		db	 0Ah, 07h, 06h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 05h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 06h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Bh, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 04h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 06h, 00h, 23h, 01h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 10h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Eh, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 03h, 07h, 05h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 27h, 01h, 07h, 00h
		db	 02h, 01h, 05h, 00h, 12h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 04h, 00h, 05h, 07h
		db	 04h, 00h, 0Ch, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 04h, 00h, 05h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 04h, 07h, 04h, 00h
		db	 0Ch, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 04h, 07h, 02h, 00h
		db	 09h, 07h, 02h, 00h, 0Bh, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 09h, 07h
		db	 05h, 00h, 03h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 04h, 00h, 05h, 07h
		db	 04h, 00h, 25h, 01h, 05h, 00h
		db	 71h, 07h, 05h, 00h, 43h, 07h
		db	 04h, 00h, 04h, 07h, 05h, 00h
		db	 7Dh, 03h, 05h, 00h, 14h, 07h
		db	 01h, 00h, 04h, 07h, 03h, 00h
		db	 07h, 07h, 02h, 00h, 6Fh, 07h
		db	 01h, 00h, 04h, 07h, 03h, 00h
		db	 17h, 07h, 03h, 00h, 0Ch, 07h
		db	 03h, 00h, 05h, 07h, 03h, 00h
		db	 16h, 07h, 02h, 00h, 4Eh, 02h
		db	 05h, 00h, 02h, 03h, 07h, 00h
		db	 12h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 77h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 16h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 65h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 11h, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 05h, 07h, 05h, 00h
		db	 0Ah, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 03h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Bh, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 0Ch, 07h, 05h, 00h
		db	 03h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 0Ch, 07h, 02h, 00h, 06h, 07h
		db	 04h, 00h, 05h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 05h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 03h, 00h, 04h, 07h, 05h, 00h
		db	 04h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 3Ah, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 12h, 07h
		db	 02h, 00h, 05h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 0Fh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 07h, 00h
		db	 09h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ah, 07h, 04h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 3Bh, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h, 13h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 05h, 07h, 04h, 00h, 0Ch, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 05h, 00h
		db	 02h, 07h, 07h, 00h, 09h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 06h, 00h
		db	 0Bh, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 07h, 00h, 03h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 3Ch, 02h
		db	 05h, 00h, 1Bh, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 0Bh, 07h, 05h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 05h, 00h, 03h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 01h, 07h, 02h, 00h, 09h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 0Fh, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 07h, 00h
		db	 03h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 05h, 00h, 44h, 02h
		db	 05h, 00h, 14h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 03h, 07h, 05h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 05h, 07h, 04h, 00h, 07h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 0Ah, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Dh, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 04h, 00h, 0Bh, 07h, 04h, 00h
		db	 05h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 3Ch, 03h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	 38h, 07h, 04h, 00h, 14h, 07h
		db	 05h, 00h, 9Bh, 07h, 05h, 00h
		db	 3Ch, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 2Bh, 07h, 03h, 00h
		db	 04h, 07h, 02h, 00h, 07h, 07h
		db	 01h, 00h, 06h, 07h, 02h, 00h
		db	 2Fh, 07h, 01h, 00h, 04h, 07h
		db	 03h, 00h, 57h, 07h, 02h, 00h
		db	 27h, 07h, 01h, 00h, 35h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 2Ch, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 26h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 7Fh, 07h, 02h, 00h
		db	 35h, 03h, 07h, 00h, 02h, 02h
		db	 05h, 00h, 12h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 07h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 05h, 07h
		db	 05h, 00h, 03h, 07h, 03h, 00h
		db	 05h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 04h, 07h, 05h, 00h
		db	 04h, 07h, 02h, 00h, 0Dh, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 0Bh, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 03h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 03h, 00h, 03h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Bh, 07h, 03h, 00h
		db	 05h, 07h, 05h, 00h, 0Ah, 07h
		db	 05h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 05h, 00h, 34h, 03h
		db	 05h, 00h, 19h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 18h, 07h, 02h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 07h, 00h, 0Bh, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 3Eh, 01h, 05h, 00h
		db	 11h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 15h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 06h, 00h, 0Bh, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 05h, 00h
		db	 02h, 07h, 07h, 00h, 0Bh, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 0Bh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 36h, 01h, 05h, 00h
		db	 02h, 01h, 07h, 00h, 10h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 04h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 0Fh, 07h, 05h, 00h, 03h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 01h, 07h
		db	 02h, 00h, 0Bh, 07h, 02h, 00h
		db	 08h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 33h, 01h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 11h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 05h, 00h, 05h, 07h
		db	 02h, 00h, 0Fh, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 0Ch, 07h, 02h, 00h, 05h, 07h
		db	 04h, 00h, 05h, 07h, 04h, 00h
		db	 07h, 07h, 02h, 00h, 02h, 07h
		db	 04h, 00h, 05h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 0Ah, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 0Bh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 06h, 07h, 02h, 00h
		db	 34h, 01h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 90h, 07h, 04h, 00h
		db	 14h, 07h, 05h, 00h, 84h, 01h
		db	 07h, 00h, 02h, 01h, 05h, 00h
		db	 24h, 07h, 03h, 00h, 04h, 07h
		db	 02h, 00h, 06h, 07h, 03h, 00h
		db	 05h, 07h, 02h, 00h, 0Fh, 07h
		db	 03h, 00h, 2Ch, 07h, 03h, 00h
		db	 2Dh, 07h, 02h, 00h, 07h, 07h
		db	 03h, 00h, 14h, 07h, 03h, 00h
		db	 26h, 07h, 01h, 00h, 04h, 07h
		db	 03h, 00h, 37h, 01h, 05h, 00h
		db	 2Dh, 07h, 02h, 00h, 0Bh, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 16h, 07h, 02h, 00h, 2Bh, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 36h, 07h, 02h, 00h, 13h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 24h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 3Fh, 03h, 05h, 00h
		db	 11h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 07h, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 05h, 07h, 02h, 00h
		db	 06h, 07h, 03h, 00h, 05h, 07h
		db	 04h, 00h, 07h, 07h, 02h, 00h
		db	 12h, 07h, 05h, 00h, 04h, 07h
		db	 04h, 00h, 0Ch, 07h, 02h, 00h
		db	 06h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 0Ch, 07h, 04h, 00h
		db	 04h, 07h, 05h, 00h, 03h, 07h
		db	 03h, 00h, 08h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 01h, 07h, 03h, 00h, 03h, 07h
		db	 04h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Bh, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 2Dh, 02h, 05h, 00h
		db	 02h, 03h, 07h, 00h, 10h, 07h
		db	 07h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 04h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 12h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Ah, 07h, 04h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Eh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 05h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ah, 07h, 04h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 07h, 00h, 0Bh, 07h, 02h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 2Bh, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 10h, 07h, 07h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 07h, 07h
		db	 02h, 00h, 04h, 07h, 06h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 12h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Bh, 07h, 02h, 00h, 05h, 07h
		db	 06h, 00h, 02h, 07h, 06h, 00h
		db	 0Bh, 07h, 05h, 00h, 03h, 07h
		db	 04h, 00h, 05h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 06h, 00h
		db	 0Bh, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 07h, 00h
		db	 0Bh, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 06h, 00h, 2Bh, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 10h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 07h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 0Bh, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Fh, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 01h, 07h
		db	 02h, 00h, 0Bh, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 2Fh, 02h
		db	 07h, 00h, 02h, 03h, 05h, 00h
		db	 11h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 04h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 03h, 07h, 04h, 00h, 05h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 0Bh, 07h, 04h, 00h, 05h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 0Ch, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 05h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 0Bh, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 05h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 2Dh, 02h
		db	 05h, 00h, 5Ah, 07h, 02h, 00h
		db	0E7h, 02h, 05h, 00h, 2Ch, 07h
		db	 01h, 00h, 16h, 07h, 03h, 00h
		db	 1Eh, 07h, 03h, 00h, 04h, 07h
		db	 02h, 00h, 0Ch, 07h, 03h, 00h
		db	 0Fh, 07h, 02h, 00h, 1Ch, 07h
		db	 03h, 00h, 28h, 07h, 03h, 00h
		db	 25h, 07h, 03h, 00h, 34h, 03h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	 2Ah, 07h, 02h, 00h, 15h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 1Eh, 07h, 02h, 00h, 13h, 07h
		db	 02h, 00h, 2Eh, 07h, 02h, 00h
		db	 29h, 07h, 02h, 00h, 26h, 07h
		db	 02h, 00h, 33h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 11h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 05h, 00h, 03h, 07h
		db	 05h, 00h, 0Bh, 07h, 04h, 00h
		db	 04h, 07h, 02h, 00h, 0Eh, 07h
		db	 04h, 00h, 0Fh, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 05h, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 03h, 00h, 05h, 07h, 05h, 00h
		db	 0Bh, 07h, 04h, 00h, 04h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 07h, 07h, 02h, 00h, 13h, 07h
		db	 04h, 00h, 03h, 07h, 05h, 00h
		db	 07h, 07h, 02h, 00h, 33h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 10h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 08h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 10h, 07h, 02h, 00h, 0Bh, 07h
		db	 05h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 07h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 0Ch, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 0Eh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 03h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 05h, 00h, 16h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 33h, 03h, 07h, 00h, 02h, 02h
		db	 05h, 00h, 11h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 05h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 0Eh, 07h
		db	 05h, 00h, 0Ah, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 0Dh, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 0Bh, 07h, 02h, 00h, 07h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 05h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 06h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 13h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 34h, 03h
		db	 05h, 00h, 19h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 0Ah, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 0Dh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ah, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 08h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 08h, 07h, 02h, 00h, 0Ah, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 06h, 07h, 05h, 00h
		db	 02h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 0Ch, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 3Ch, 01h
		db	 05h, 00h, 12h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 06h, 07h, 02h, 00h
		db	 0Ch, 07h, 04h, 00h, 03h, 07h
		db	 04h, 00h, 0Dh, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 0Ah, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 04h, 00h, 03h, 07h
		db	 05h, 00h, 03h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 0Ah, 07h
		db	 04h, 00h, 03h, 07h, 05h, 00h
		db	 0Ch, 07h, 04h, 00h, 03h, 07h
		db	 03h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 04h, 00h
		db	 08h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 0Dh, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 33h, 01h, 05h, 00h
		db	 02h, 01h, 07h, 00h,0C0h, 07h
		db	 05h, 00h, 14h, 07h, 02h, 00h
		db	 56h, 01h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 13h, 07h, 01h, 00h
		db	 04h, 07h, 03h, 00h, 10h, 07h
		db	 01h, 00h, 0Fh, 07h, 01h, 00h
		db	 04h, 07h, 03h, 00h, 07h, 07h
		db	 02h, 00h, 27h, 07h, 01h, 00h
		db	 06h, 07h, 02h, 00h, 1Eh, 07h
		db	 02h, 00h, 27h, 07h, 01h, 00h
		db	 3Fh, 07h, 03h, 00h, 2Bh, 01h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 12h, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 0Fh, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 2Fh, 07h, 02h, 00h
		db	 4Eh, 07h, 02h, 00h, 40h, 07h
		db	 02h, 00h, 2Bh, 01h, 07h, 00h
		db	 02h, 01h, 05h, 00h, 12h, 07h
		db	 05h, 00h, 03h, 07h, 02h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 04h, 00h, 04h, 07h, 05h, 00h
		db	 0Bh, 07h, 05h, 00h, 03h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 03h, 07h, 03h, 00h, 05h, 07h
		db	 05h, 00h, 0Ah, 07h, 05h, 00h
		db	 04h, 07h, 04h, 00h, 04h, 07h
		db	 05h, 00h, 03h, 07h, 03h, 00h
		db	 05h, 07h, 04h, 00h, 04h, 07h
		db	 04h, 00h, 0Ch, 07h, 03h, 00h
		db	 05h, 07h, 05h, 00h, 0Ah, 07h
		db	 05h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 05h, 00h, 0Ah, 07h
		db	 02h, 00h, 01h, 07h, 03h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 07h, 07h
		db	 02h, 00h, 2Ch, 01h, 05h, 00h
		db	 1Bh, 07h, 02h, 00h, 05h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 0Eh, 07h, 02h, 00h
		db	 05h, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 03h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 0Ch, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 0Dh, 07h, 03h, 00h, 01h, 07h
		db	 02h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 07h, 00h, 01h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 05h, 00h
		db	 34h, 03h, 05h, 00h, 13h, 07h
		db	 02h, 00h, 05h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 05h, 00h, 04h, 07h, 02h, 00h
		db	 0Eh, 07h, 02h, 00h, 05h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 05h, 07h
		db	 04h, 00h, 0Bh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 04h, 07h, 02h, 00h
		db	 06h, 07h, 06h, 00h, 0Ch, 07h
		db	 02h, 00h, 05h, 07h, 04h, 00h
		db	 0Bh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 0Dh, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 06h, 00h, 02h, 07h, 07h, 00h
		db	 01h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 06h, 00h, 02h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 2Ch, 02h
		db	 05h, 00h, 02h, 03h, 07h, 00h
		db	 12h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 03h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 0Ch, 07h, 02h, 00h
		db	 01h, 07h, 01h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 0Ah, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 04h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 10h, 07h, 02h, 00h, 08h, 07h
		db	 02h, 00h, 0Ah, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 01h, 07h
		db	 01h, 00h, 0Bh, 07h, 02h, 00h
		db	 05h, 07h, 02h, 00h, 06h, 07h
		db	 02h, 00h, 01h, 07h, 01h, 00h
		db	 01h, 07h, 02h, 00h, 01h, 07h
		db	 02h, 00h, 02h, 07h, 02h, 00h
		db	 03h, 07h, 04h, 00h, 03h, 07h
		db	 02h, 00h, 06h, 07h, 02h, 00h
		db	 02h, 07h, 02h, 00h, 04h, 07h
		db	 02h, 00h, 25h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 13h, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 03h, 00h, 01h, 07h, 02h, 00h
		db	 04h, 07h, 02h, 00h, 0Eh, 07h
		db	 02h, 00h, 03h, 07h, 03h, 00h
		db	 02h, 07h, 02h, 00h, 02h, 07h
		db	 04h, 00h, 03h, 07h, 05h, 00h
		db	 0Bh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 06h, 07h, 02h, 00h, 04h, 07h
		db	 04h, 00h, 04h, 07h, 04h, 00h
		db	 04h, 07h, 04h, 00h, 0Ch, 07h
		db	 04h, 00h, 03h, 07h, 05h, 00h
		db	 0Bh, 07h, 02h, 00h, 02h, 07h
		db	 02h, 00h, 03h, 07h, 04h, 00h
		db	 06h, 07h, 02h, 00h, 0Bh, 07h
		db	 04h, 00h, 05h, 07h, 04h, 00h
		db	 03h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 02h, 07h, 04h, 00h
		db	 05h, 07h, 02h, 00h, 05h, 07h
		db	 04h, 00h, 04h, 07h, 03h, 00h
		db	 01h, 07h, 02h, 00h, 03h, 07h
		db	 02h, 00h, 25h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h,0FFh, 00h
		db	 32h, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h,0FFh, 00h, 34h, 02h
		db	 05h, 00h,0FFh, 00h, 44h, 02h
		db	 05h, 00h,0FFh, 00h, 34h, 03h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	0FFh, 00h, 32h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h,0FFh, 00h
		db	 32h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h,0FFh, 00h, 32h, 03h
		db	 07h, 00h, 02h, 02h, 05h, 00h
		db	0FFh, 00h, 34h, 03h, 05h, 00h
		db	0FFh, 00h, 44h, 01h, 05h, 00h
		db	 71h, 05h, 04h, 00h, 1Eh, 05h
		db	 04h, 00h, 02h, 05h, 03h, 00h
		db	 1Eh, 05h, 03h, 00h, 76h, 01h
		db	 05h, 00h, 02h, 01h, 07h, 00h
		db	 71h, 05h, 02h, 00h, 1Eh, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 1Fh, 05h
		db	 02h, 00h, 75h, 01h, 07h
loc_d_2D78:
		add	[bx+di],al
		add	[bx],ax
		add	[bx+di+5],dh
		add	al,[bx+si]
		push	es
		add	ax,4
		add	al,5
		add	al,0
		or	ax,[di]
		add	al,[bx+si]
		pop	es
		add	ax,2
		add	[di],ax
		add	al,[bx+si]
		add	ax,[di]
		add	al,0
		add	ax,[di]
		add	al,[bx+si]
		add	[di],ax
		add	ax,[bx+si]
		add	ax,[di]
		add	al,0
		add	ax,205h
		add	[di+1],dh
		pop	es
		add	[bx+di],al
		add	[bx],ax
		add	[bx+di+5],dh
		add	al,[bx+si]
		add	ax,205h
		add	[bp+si],al
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		or	al,[di]
		add	al,[bx+si]
		pop	es
		add	ax,3
		add	[di],ax
		add	al,[bx+si]
		add	ax,205h
		add	[bp+di],al
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	[di],ax
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,5
		add	al,[bx+si]
		jnz	$+3			; Jump if not zero
		pop	es
		add	[bp+si],al
		add	[di],ax
		add	[bp+si+5],dh
		add	al,[bx+si]
		add	ax,[di]
		add	[bx+si],ax
		add	[di],ax
		push	es
		add	[bp+si],al
		add	ax,6
		or	al,[di]
		add	al,[bx+si]
		pop	es
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	ax,300h
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	[di],ax
		push	es
		add	[si],al
		add	ax,2
		jbe	$+3			; Jump if below or =
		add	ax,7A00h
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	[di],ax
		add	al,[bx+si]
		push	es
		add	ax,2
		db	 0Fh, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 01h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 03h, 05h, 05h, 00h, 02h, 05h
		db	 02h, 00h, 08h, 05h, 02h, 00h
		db	 7Eh, 03h, 05h, 00h, 71h, 05h
		db	 07h, 00h, 02h, 05h, 04h, 00h
		db	 04h, 05h, 04h, 00h, 0Dh, 05h
		db	 04h, 00h, 02h, 05h, 03h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 03h, 00h, 01h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 06h, 05h
		db	 04h, 00h, 04h, 05h, 04h, 00h
		db	 75h, 02h, 05h, 00h
loc_d_2E8D:
		add	al,[bp+di]
		pop	es
		add	data_d_0405[bx+si],ch
		add	data_d_0702[di],al
		add	[bx+di],al
		add	ax,[bx]
		add	[bx+di+5],bl
		add	al,0
		add	al,5
		add	al,0
		push	es
		add	ax,3
		add	ax,[di]
		add	al,0
		or	ax,[di]
		add	al,[bx+si]
		add	ax,[di]
		add	al,[bx+si]
		add	ax,[di]
		add	al,[bx+si]
		push	ss
		add	ax,2
		push	ds
		add	ax,2
		insw				; Port dx to es:[di]
		add	al,[bx]
		add	[bx+di],al
		add	ax,[bx]
		add	[bx+si+5],bl
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,5
		add	al,0
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		or	al,[di]
		add	al,[bx+si]
		add	ax,[di]
		add	al,[bx+si]
		cmp	al,[di]
		add	al,0
		insb				; Port dx to es:[di]
		add	al,[bx]
		add	[bp+si],al
		add	ax,[di]
		add	[di+5],bl
		add	al,[bx+si]
		push	es
		add	ax,2
		add	ax,[di]
		add	al,[bx+si]
		add	[di],ax
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		or	al,[di]
		add	al,[bx+si]
		add	ax,[di]
		add	al,[bx+si]
		add	al,[di]
		add	ax,[bx+si]
		add	ax,305h
		add	[bx+di],al
		add	ax,2
		add	al,[di]
		add	ax,[bx+si]
		add	[di],ax
		add	al,[bx+si]
		add	al,[di]
		add	ax,[bx+si]
		add	al,5
		add	ax,400h
		add	ax,5
		or	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	ax,[di]
		add	al,0
		pop	bp
		add	al,[di]
		add	[bp+di+5],ah
		add	ax,[bx+si]
		add	ax,305h
		add	[bp+di],al
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	ax,[di]
		add	ax,0A00h
		add	ax,2
		add	[di],ax
		add	[bx+si],ax
		add	[di],ax
		add	al,[bx+si]
		add	ax,[di]
		add	al,[bx+si]
		add	al,5
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,5
		add	al,[bx+si]
		add	al,5
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		push	cs
		add	ax,2
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		add	al,[di]
		add	al,[bx+si]
		db	 64h, 02h, 05h, 00h, 5Ah, 05h
		db	 02h, 00h, 09h, 05h, 02h, 00h
		db	 02h, 05h, 07h, 00h, 05h, 05h
		db	 02h, 00h, 0Ah, 05h, 07h, 00h
		db	 03h, 05h, 02h, 00h, 04h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 04h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 03h, 05h, 04h, 00h
		db	 0Bh, 05h, 06h, 00h, 02h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 06h, 00h, 5Ch, 03h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	 58h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 06h, 05h
		db	 02h, 00h, 05h, 05h, 02h, 00h
		db	 0Bh, 05h, 03h, 00h, 01h, 05h
		db	 03h, 00h, 03h, 05h, 02h, 00h
		db	 05h, 05h, 05h, 00h, 03h, 05h
		db	 05h, 00h, 04h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 06h, 05h, 02h, 00h
		db	 0Ah, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 03h, 05h, 04h, 00h
		db	 03h, 05h, 02h, 00h, 08h, 05h
		db	 02h, 00h, 55h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 58h, 05h
		db	 06h, 00h, 03h, 05h, 04h, 00h
		db	 06h, 05h, 04h, 00h, 02h, 05h
		db	 03h, 00h, 0Ch, 05h, 02h, 00h
		db	 03h, 05h, 02h, 00h, 02h, 05h
		db	 04h, 00h, 07h, 05h, 02h, 00h
		db	 06h, 05h, 02h, 00h, 03h, 05h
		db	 04h, 00h, 03h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 05h, 00h, 0Bh, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 04h, 05h
		db	 02h, 00h, 05h, 05h, 04h, 00h
		db	 05h, 05h, 02h, 00h, 55h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 90h, 05h, 05h, 00h, 03h, 05h
		db	 05h, 00h, 94h, 03h, 07h, 00h
		db	 02h, 02h, 05h, 00h, 4Ah, 05h
		db	 04h, 00h, 15h, 05h, 02h, 00h
		db	 16h, 05h, 03h, 00h, 05h, 05h
		db	 02h, 00h, 0Dh, 05h, 03h, 00h
		db	 07h, 05h, 03h, 00h, 13h, 05h
		db	 04h, 00h, 03h, 05h, 04h, 00h
		db	 0Eh, 05h, 03h, 00h, 04h, 05h
		db	 04h, 00h, 03h, 05h, 06h, 00h
		db	 03h, 05h, 05h, 00h, 05h, 05h
		db	 03h, 00h, 44h, 03h, 05h, 00h
		db	 51h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 2Bh, 05h, 02h, 00h
		db	 01h, 05h, 02h, 00h, 14h, 05h
		db	 02h, 00h, 08h, 05h, 02h, 00h
		db	 14h, 05h, 02h, 00h, 05h, 05h
		db	 02h, 00h, 0Eh, 05h, 02h, 00h
		db	 05h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 03h, 05h, 02h, 00h
		db	 03h, 05h, 04h, 00h, 4Ch, 01h
		db	 05h, 00h, 49h, 05h, 03h, 00h
		db	 05h, 05h, 02h, 00h, 01h, 05h
		db	 03h, 00h, 02h, 05h, 02h, 00h
		db	 01h, 05h, 03h, 00h, 03h, 05h
		db	 03h, 00h, 04h, 05h, 05h, 00h
		db	 04h, 05h, 03h, 00h, 01h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 06h, 05h, 03h, 00h, 05h, 05h
		db	 04h, 00h, 05h, 05h, 02h, 00h
		db	 08h, 05h, 02h, 00h, 14h, 05h
		db	 02h, 00h, 05h, 05h, 02h, 00h
		db	 0Dh, 05h, 02h, 00h, 0Ah, 05h
		db	 02h, 00h, 06h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 03h, 00h, 02h, 05h, 02h, 00h
		db	 01h, 05h, 02h, 00h, 44h, 01h
		db	 05h, 00h, 02h, 01h, 07h, 00h
		db	 49h, 05h, 03h, 00h, 05h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 03h, 00h, 01h, 05h
		db	 02h, 00h, 03h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 04h, 00h, 06h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 04h, 05h, 02h, 00h
		db	 05h, 05h, 05h, 00h, 14h, 05h
		db	 02h, 00h, 05h, 05h, 02h, 00h
		db	 0Dh, 05h, 05h, 00h, 05h, 05h
		db	 03h, 00h, 06h, 05h, 02h, 00h
		db	 03h, 05h, 02h, 00h, 01h, 05h
		db	 04h, 00h, 01h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 43h, 01h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 4Bh, 05h, 03h, 00h, 03h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 03h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 03h, 05h
		db	 02h, 00h, 07h, 05h, 02h, 00h
		db	 04h, 05h, 06h, 00h, 04h, 05h
		db	 02h, 00h, 04h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 14h, 05h
		db	 02h, 00h, 05h, 05h, 02h, 00h
		db	 03h, 05h, 01h, 00h, 09h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 03h, 05h, 02h, 00h, 07h, 05h
		db	 02h, 00h, 04h, 05h, 04h, 00h
		db	 01h, 05h, 02h, 00h, 01h, 05h
		db	 07h, 00h, 42h, 01h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 48h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 03h, 05h, 05h, 00h, 03h, 05h
		db	 02h, 00h, 07h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 03h, 05h, 05h, 00h
		db	 03h, 05h, 02h, 00h, 07h, 05h
		db	 02h, 00h, 04h, 05h, 02h, 00h
		db	 08h, 05h, 02h, 00h, 04h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 04h, 05h, 02h, 00h, 0Eh, 05h
		db	 02h, 00h, 05h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 09h, 05h
		db	 02h, 00h, 02h, 05h, 02h, 00h
		db	 02h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 04h, 05h, 02h, 00h
		db	 04h, 05h, 03h, 00h, 02h, 05h
		db	 02h, 00h, 05h, 05h, 02h, 00h
		db	 43h, 01h, 07h, 00h, 02h, 01h
		db	 05h, 00h, 4Ah, 05h, 04h, 00h
		db	 04h, 05h, 02h, 00h, 05h, 05h
		db	 04h, 00h, 05h, 05h, 04h, 00h
		db	 03h, 05h, 02h, 00h, 02h, 05h
		db	 02h, 00h, 06h, 05h, 02h, 00h
		db	 02h, 05h, 04h, 00h, 05h, 05h
		db	 04h, 00h, 04h, 05h, 04h, 00h
		db	 04h, 05h, 04h, 00h, 04h, 05h
		db	 03h, 00h, 01h, 05h, 02h, 00h
		db	 03h, 05h, 02h, 00h, 0Dh, 05h
		db	 04h, 00h, 03h, 05h, 07h, 00h
		db	 0Ah, 05h, 04h, 00h, 03h, 05h
		db	 06h, 00h, 04h, 05h, 02h, 00h
		db	 05h, 05h, 05h, 00h, 05h, 05h
		db	 04h, 00h, 43h, 01h, 05h, 00h
		db	 59h, 05h, 04h, 00h, 1Ch, 05h
		db	 05h, 00h, 2Ch, 05h, 02h, 00h
		db	 97h, 03h, 05h, 00h,0FFh, 00h
		db	 34h, 02h, 05h, 00h, 02h, 03h
		db	 07h, 00h,0FFh, 00h, 32h, 02h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	0FFh, 00h, 32h, 02h, 07h, 00h
		db	 01h, 03h, 07h, 00h,0FFh, 00h
		db	 32h, 02h, 07h, 00h, 02h, 03h
		db	 05h, 00h,0FFh, 00h, 34h, 02h
		db	 05h, 00h,0FFh, 00h, 44h, 02h
		db	 05h, 00h,0FFh, 00h, 34h, 03h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	0FFh, 00h, 32h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 60h, 08h
		db	 06h, 00h, 4Ah, 08h, 03h, 00h
		db	 7Eh, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 61h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 4Ah, 08h
		db	 02h, 00h, 7Eh, 03h, 07h, 00h
		db	 02h, 02h, 05h, 00h, 62h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 01h, 08h, 02h, 00h, 01h, 08h
		db	 03h, 00h, 03h, 08h, 04h, 00h
		db	 04h, 08h, 05h, 00h, 03h, 08h
		db	 05h, 00h, 0Bh, 08h, 04h, 00h
		db	 03h, 08h, 05h, 00h, 03h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 0Bh, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 04h, 00h
		db	 03h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 6Ch, 03h, 05h, 00h
		db	 6Ah, 08h, 05h, 00h, 03h, 08h
		db	 03h, 00h, 01h, 08h, 02h, 00h
		db	 01h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 06h, 08h, 02h, 00h, 12h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 0Bh, 08h, 02h, 00h, 01h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 74h, 01h, 05h, 00h, 62h, 08h
		db	 02h, 00h, 06h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 01h, 08h
		db	 06h, 00h, 03h, 08h, 04h, 00h
		db	 04h, 08h, 04h, 00h, 0Ch, 08h
		db	 05h, 00h, 02h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 0Bh, 08h, 04h, 00h, 03h, 08h
		db	 06h, 00h, 02h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 6Ch, 01h
		db	 05h, 00h, 02h, 01h, 07h, 00h
		db	 61h, 08h, 02h, 00h, 06h, 08h
		db	 02h, 00h, 05h, 08h, 02h, 00h
		db	 0Ah, 08h, 02h, 00h, 06h, 08h
		db	 02h, 00h, 0Ah, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 02h, 00h
		db	 03h, 08h, 05h, 00h, 0Bh, 08h
		db	 02h, 00h, 01h, 08h, 02h, 00h
		db	 02h, 08h, 02h, 00h, 07h, 08h
		db	 05h, 00h, 04h, 08h, 02h, 00h
		db	 65h, 01h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 60h, 08h, 04h, 00h
		db	 04h, 08h, 04h, 00h, 05h, 08h
		db	 04h, 00h, 03h, 08h, 05h, 00h
		db	 03h, 08h, 05h, 00h, 0Ch, 08h
		db	 03h, 00h, 01h, 08h, 02h, 00h
		db	 01h, 08h, 02h, 00h, 02h, 08h
		db	 02h, 00h, 06h, 08h, 02h, 00h
		db	 0Ah, 08h, 03h, 00h, 02h, 08h
		db	 02h, 00h, 02h, 08h, 04h, 00h
		db	 07h, 08h, 02h, 00h, 04h, 08h
		db	 02h, 00h, 65h, 01h, 07h, 00h
		db	 01h, 01h, 07h, 00h,0A0h, 08h
		db	 05h, 00h, 1Bh, 08h, 05h, 00h
		db	 6Ch, 01h, 07h, 00h, 02h, 01h
		db	 05h, 00h,0FFh, 00h, 34h, 01h
		db	 05h, 00h,0FFh, 00h, 44h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 03h, 01h, 05h, 00h
		db	 03h, 03h, 05h, 00h, 03h, 02h
		db	 05h, 00h, 02h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 01h, 07h, 00h, 01h, 03h
		db	 07h, 00h, 01h, 02h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 01h
		db	 07h, 00h, 01h, 03h, 07h, 00h
		db	 01h, 02h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 01h, 01h, 07h, 00h
		db	 01h, 03h, 07h, 00h, 01h, 02h
		db	 07h, 00h, 02h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 03h, 01h, 05h, 00h, 03h, 03h
		db	 05h, 00h, 03h, 02h, 05h, 00h
		db	 01h,0FFh,0FFh

seg_d		ends



		end	start
