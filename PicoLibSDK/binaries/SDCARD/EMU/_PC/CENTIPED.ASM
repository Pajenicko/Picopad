
PAGE  59,132

;==========================================================================
;==					                                 ==
;==				CENTIPED                                 ==
;==					                                 ==
;==      Created:   1-Jan-80		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==      (C) Copyright 1983		                                 ==
;==					                                 ==
;==========================================================================

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
 
target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_0000_0000_e	equ	0
d_0000_0002_e	equ	2
d_0000_0003_e	equ	3
d_0000_0006_e	equ	6
d_0000_0008_e	equ	8
d_0000_000A_e	equ	0Ah
d_0000_000B_e	equ	0Bh
d_0000_000E_e	equ	0Eh
d_0000_0010_e	equ	10h
d_0000_0012_e	equ	12h
d_0000_0014_e	equ	14h
d_0000_0016_e	equ	16h
d_0000_0018_e	equ	18h
d_0000_0019_e	equ	19h
d_0000_001E_e	equ	1Eh
d_0000_0020_e	equ	20h
d_0000_0022_e	equ	22h
d_0000_0024_e	equ	24h
d_0000_0025_e	equ	25h
d_0000_0026_e	equ	26h
d_0000_0027_e	equ	27h
d_0000_0028_e	equ	28h
d_0000_002A_e	equ	2Ah
d_0000_0030_e	equ	30h
d_0000_003D_e	equ	3Dh
d_0000_005A_e	equ	5Ah
d_0000_0063_e	equ	63h
d_0000_006C_e	equ	6Ch
d_0000_0072_e	equ	72h
d_0000_0074_e	equ	74h
d_0000_0075_e	equ	75h
d_0000_0076_e	equ	76h
d_0000_0078_e	equ	78h
d_0000_0410_e	equ	410h
d_0000_043A_e	equ	43Ah
d_0000_043B_e	equ	43Bh
d_0000_043C_e	equ	43Ch
d_0000_043D_e	equ	43Dh
d_0000_043E_e	equ	43Eh
d_0000_043F_e	equ	43Fh
d_0000_0440_e	equ	440h
d_0000_0442_e	equ	442h
d_0000_0444_e	equ	444h
d_0000_0446_e	equ	446h
d_0000_0448_e	equ	448h
d_0000_0449_e	equ	449h
d_0000_044A_e	equ	44Ah
d_0000_044B_e	equ	44Bh
d_0000_044C_e	equ	44Ch
d_0000_044D_e	equ	44Dh
d_0000_044E_e	equ	44Eh
d_0000_044F_e	equ	44Fh
d_0000_0450_e	equ	450h
d_0000_0451_e	equ	451h
d_0000_0452_e	equ	452h
d_0000_0453_e	equ	453h
d_0000_0454_e	equ	454h
d_0000_0455_e	equ	455h
d_0000_0458_e	equ	458h
d_0000_045B_e	equ	45Bh
d_0000_045D_e	equ	45Dh
d_0000_045F_e	equ	45Fh
d_0000_0461_e	equ	461h
d_0000_0462_e	equ	462h
d_0000_0463_e	equ	463h
d_0000_0465_e	equ	465h
d_0000_048B_e	equ	48Bh
d_0000_0490_e	equ	490h
d_0000_0491_e	equ	491h
d_0000_0494_e	equ	494h
d_0000_0495_e	equ	495h
d_0000_0496_e	equ	496h
d_0000_1E00_e	equ	1E00h			;*
d_0000_2D54_e	equ	2D54h			;*
d_0040_0010_e	equ	10h
d_0040_0017_e	equ	17h
d_0053_0452_e	equ	452h			;*
data_a_3EF9_e	equ	3EF9h			;*
data_a_74D2_e	equ	74D2h			;*
data_c_1874_e	equ	1874h			;*
data_c_2000_e	equ	2000h			;*
d_5453_0452_e	equ	452h			;*
d_5453_045F_e	equ	45Fh			;*
d_5453_2BFA_e	equ	2BFAh			;*
d_5453_2CC2_e	equ	2CC2h			;*
d_5453_2CCB_e	equ	2CCBh			;*
d_5904_045B_e	equ	45Bh			;*
d_5904_0493_e	equ	493h			;*
d_5904_0494_e	equ	494h			;*
d_8F06_03F8_e	equ	3F8h			;*
d_8F06_28F9_e	equ	28F9h			;*
d_8F06_2E92_e	equ	2E92h			;*
d_8F06_2EC6_e	equ	2EC6h			;*
d_B800_0000_e	equ	0
d_B800_0924_e	equ	924h
d_B800_094B_e	equ	94Bh
d_B800_0F0A_e	equ	0F0Ah
d_B800_0FB4_e	equ	0FB4h
d_B800_1FC4_e	equ	1FC4h
d_B800_2000_e	equ	2000h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	para public
		assume cs:seg_a  , ds:seg_a , ss:stack_seg_e


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


CENTIPED	proc	far

start:
		push	ds
		sub	ax,ax

sub_a_0003:

		; check color monitor on address 0B8000h
		push	ax
		mov	ax,0B800h
		mov	es,ax
		mov	ax,es:d_B800_0000_e
		mov	dx,ax
;*		xor	dx,0FFFFh
		db	 81h,0F2h,0FFh,0FFh	;  Fixup - byte match
		mov	es:d_B800_0000_e,dx
		cmp	es:d_B800_0000_e,dx
		jne	loc_a_002D		; Jump if not equal
;*		xor	word ptr es:d_B800_0000_e,0FFFFh
		db	 26h, 81h, 36h, 00h, 00h,0FFh	;  Fixup - byte match
		db	0FFh			;  Fixup - byte match
		cmp	es:d_B800_0000_e,ax
		je	loc_a_0037		; Jump if equal
loc_a_002D:
		; error - COLOR/GRAPHICS MONITOR ADAPTER REQUIRED.
		push	cs
		pop	ds
		mov	dx,offset data_a_01F6	; ('COLOR/GRAPHICS MONITOR A')
		mov	ah,9
		int	21h			; DOS Services  ah=function 09h
						;  display char string at ds:dx
		retf				; Return far

CENTIPED	endp

loc_a_0037:
		; install INT 23h
		push	ds
		push	cs
		pop	ds
		mov	dx,offset int_23h_entry
		mov	al,23h			; '#'
		mov	ah,25h
		int	21h			; DOS Services  ah=function 25h
						;  set intrpt vector al to ds:dx

		; get old keyboard flags
		mov	ax,40h
		mov	ds,ax
		mov	bl,ds:d_0040_0017_e

		; setup segment registers
		mov	dx,seg seg_d
		mov	ds,dx
		mov	es,dx
		assume	ds:seg_d
		mov	data_d_0347,bl

		; get equipment list
		int	11h			; Put equipment bits in ax
		mov	data_d_0344,ax		; INT 11h equipment list

		; get old videomode
		mov	ah,0Fh
		int	10h			; Video display   ah=functn 0Fh
						;  get state, al=mode, bh=page
						;   ah=columns on screen
		mov	data_d_0346,al

		; check command line
		pop	ds
		mov	si,81h
		mov	cl,byte ptr ds:[80h]

		; skip spaces from command line
loc_a_006B:	test	cl,cl
		jz	loc_a_009D		; Jump if zero
		dec	cl
		lodsb				; String [si] to al
		cmp	al,20h			; ' '
		je	loc_a_006B		; Jump if equal
		cmp	al,2Ch			; ','
		je	loc_a_006B		; Jump if equal
		cmp	al,3Bh			; ';'
		je	loc_a_006B		; Jump if equal
		cmp	al,3Dh			; '='
		je	loc_a_006B		; Jump if equal
		cmp	al,9
		je	loc_a_006B		; Jump if equal

		; get character from command line - TOPTEN index
		cmp	al,30h			; '0'
		jl	loc_a_009D		; Jump if <
		cmp	al,39h			; '9'
		jle	loc_a_0098		; Jump if < or =
		and	al,0DFh
		cmp	al,41h			; 'A'
		jl	loc_a_009D		; Jump if <
		cmp	al,5Ah			; 'Z'
		jg	loc_a_009D		; Jump if >
loc_a_0098:	mov	ds,dx
		mov	data_d_003D,al		; TOPTEN 8th character = digit/character from command line

loc_a_009D:
		; set DTA to TOPTENA.CTP buffer (Amateur)
		mov	ds,dx
		mov	dx,offset data_d_006C	; (' ')
		mov	di,dx			; TOPTENA buffer
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx

		; read TOPTENA.CTP
		mov	byte ptr data_d_003C,41h	; 'A' ; TOPTEN 7th character = 'A' ('TOPTENA')
		call	sub_a_021F		; read TOPTEN to DTA (=DS:DI)

		; set DTA to TOPTENP.CTP buffer (Professional)
		mov	dx,offset data_d_0159	; TOPTENP buffer
		mov	di,dx
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx

		; read TOPTENP.CTP
		mov	byte ptr data_d_003C,50h	; 'P' ; TOPTEN 7th character = 'P' ('TOPTENP')
		call	sub_a_021F		; read TOPTEN to DTA (=DS:DI)

		; set DTA to TOPTENS.CTP buffer (Superstar)
		mov	dx,offset data_d_0246	; TOPTENS buffer
		mov	di,dx
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx

		; read TOPTENS.CTP
		mov	byte ptr data_d_003C,53h	; 'S' ; TOPTEN 7th character = 'S' ('TOPTENS')
		call	sub_a_021F		; read TOPTEN to DTA (=DS:DI)

		; set DTA to JOYSTICK.CTP buffer
		mov	dx,offset data_d_005A	; JOYSTICK.CTP buffer
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx

		; open file JOYSTICK.CTP
		mov	dx,offset data_d_0010	; JOYSTICK.CTP
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh
						;  open file, FCB @ ds:dx
		; error, not found
		test	al,al
		jnz	loc_a_0103		; Jump if not zero

		mov	ax,data_d_0022
		test	ax,ax
		jnz	loc_a_0103		; Jump if not zero
		mov	ax,data_d_0020
		sub	ax,12h
		jnz	loc_a_0103		; Jump if not zero

		; read file JOYSTICK.CTP
		mov	byte ptr data_d_001E,12h
		mov	byte ptr data_d_0030,0
		mov	ah,14h
		int	21h			; DOS Services  ah=function 14h
						;  sequentl file read FCB @ds:dx
						;   returns al=0 ok, not 0=error
		sub	ah,ah
loc_a_0103:
		; clear JOYTICK.CTP buffer on read error
		test	ax,ax
		jz	loc_a_0124		; Jump if zero
		mov	di,offset data_d_005A	; JOYSTICK.CTP buffer
		push	di
		mov	cx,12h
		sub	ax,ax
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	al,80h
		pop	di
		mov	[di+2],al
		mov	[di+6],al
		add	di,9
		mov	[di+2],al
		mov	[di+6],al

loc_a_0124:
		; set new equipment list (videomode 1 40x25, 1 floppy)
		sub	ax,ax
		mov	ds,ax
		mov	al,5Dh			; ']'
		sub	si,si
		mov	ds:d_0000_0410_e[si],al

		; set videomode 0
		sub	ax,ax
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set videomode 4 (320x200/4)
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; initialize segments
		mov	ax,0B800h
		mov	es,ax
		mov	ax,seg_b
		mov	ds,ax
		assume	ds:seg_b

		; save SP
		mov	data_b_0459,sp		; old SP
		mov	ds,data_b_045B		; 2nd data segment
		assume	ds:seg_c
		mov	data_c_0459,sp		; old SP

		; check joystick
		call	sub_a_30AE		; check joystick

		; setup horizontal centering
		mov	dx,3D4h
		mov	al,2
		out	dx,al			; port 3D4h, CGA/EGA reg index
						;  al = 2, horz sync position
		inc	dx
		mov	al,data_c_0494		; setup horizontal centering
		out	dx,al			; port 3D5h, CGA/EGA indxd data

		; initialize speaker timer to mode 2
		mov	al,0BEh
		out	43h,al			; port 43h, 8253 timer control

		; init screen
loc_a_0161:	call	sub_a_0280		; display init screen

loc_a_0164:
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		mov	di,20EBh
		mov	dl,0
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		assume	ds:seg_b
		cmp	byte ptr data_b_0493,0
		jne	loc_a_017B		; Jump if not equal

		; enable sound output
		mov	al,4Fh			; 'O'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Fh, speaker on
loc_a_017B:
		mov	si,data_b_0465
		mov	cx,[si]
loc_a_0181:
		dec	cx
		jnz	loc_a_0181		; Jump if not zero
		call	sub_a_0937
		mov	si,data_b_0465
		mov	cx,[si]
loc_a_018D:
		dec	cx
		jnz	loc_a_018D		; Jump if not zero
		call	sub_a_0F50
		mov	si,data_b_0465
		mov	cx,[si]
loc_a_0199:
		dec	cx
		jnz	loc_a_0199		; Jump if not zero
		call	sub_a_12A9
		mov	si,data_b_0465
		mov	cx,[si]
loc_a_01A5:
		dec	cx
		jnz	loc_a_01A5		; Jump if not zero
		call	sub_a_0C60
		mov	si,data_b_0465
		mov	cx,[si]
loc_a_01B1:
		dec	cx
		jnz	loc_a_01B1		; Jump if not zero
		call	sub_a_0DD0
		mov	si,data_b_0465
		mov	cx,[si]
loc_a_01BD:
		dec	cx
		jnz	loc_a_01BD		; Jump if not zero
		call	sub_a_1170
		call	sub_a_16C0
		jmp	short loc_a_0164

;==== External Entry into Subroutine ======================================

sub_a_01C8:


;==========================================================================
;
;                       External Entry Point
;
;==========================================================================

; INT 23h interrupt service - break program

int_23h_entry	proc	far

		; disable sound output
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		mov	ax,seg_b
		mov	ds,ax
		mov	sp,data_b_0459		; old SP
		mov	ds,data_b_045F
		assume	ds:seg_d
		mov	bx,data_d_0344		; INT 11h equipment list
		mov	ah,data_d_0347
		mov	al,data_d_0346
		mov	cx,40h
		mov	ds,cx
		mov	ds:d_0040_0010_e,bx	; restore equipment list
		mov	ds:d_0040_0017_e,ah
		sub	ah,ah
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		retf				; Return far
int_23h_entry	endp

data_a_01F6	db	'COLOR/GRAPHICS MONITOR ADAPTER R'
		db	'EQUIRED.$'

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; read TOPTEN to DTA (=DS:DI)

sub_a_021F	proc	near

		; open file TOPTEN
		mov	dx,offset data_d_0035	; TOPTEN FCB (DS:DX = FCB)
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh

		; not open			;  open file, FCB @ ds:dx
		test	al,al
		jnz	loc_a_0259		; Jump if not zero - not open

		mov	ax,data_d_0047		; TOPTEN file size HIGH
		test	ax,ax
		jnz	loc_a_0259		; Jump if not zero

		mov	ax,data_d_0045		; TOPTEN file size LOW
		sub	ax,0EDh
		jnz	loc_a_0259		; Jump if not zero

		; read file TOPTEN to DTA (DS:DX = FCB)
		mov	byte ptr data_d_0043,0EDh ; TOPTEN record size = 237
		mov	byte ptr data_d_0055,0	; TOPTEN current record
		mov	ah,14h
		int	21h			; DOS Services  ah=function 14h
						;  sequentl file read FCB @ds:dx
						;   returns al=0 ok, not 0=error

		; error reading
		sub	ah,ah
		test	al,al
		jnz	loc_a_0259		; Jump if not zero (error)

		mov	al,data_d_003C		; TOPTEN 7th character
		sub	al,[di]
		jnz	loc_a_0259		; Jump if not zero
		mov	al,[di+1]
		sub	al,0Ah
loc_a_0259:
		test	ax,ax
		jz	loc_ret_a_027E		; Jump if zero

		; clear buffer
		mov	al,data_d_003C		; TOPTEN 7th character
		mov	[di],al
		inc	di
		mov	cx,6
		mov	al,0Ah
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	ah,0Ah	; 10 entries
loc_a_026C:
		mov	cx,11h
		mov	al,20h			; ' '
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	cx,6
		mov	al,0
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		dec	ah
		jnz	loc_a_026C		; Jump if not zero

loc_ret_a_027E:
		retn
sub_a_021F	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; init screen

sub_a_0280	proc	near

		assume	ds:seg_c
		mov	data_c_048B,6Ch
		mov	data_c_048D,6Ch
		mov	ds,data_c_045B

		assume	ds:seg_b
		mov	data_b_048B,6Ch
		mov	data_b_048D,6Ch
		mov	ds,data_b_045D
		mov	byte ptr data_b_0458,1
		mov	dl,1
loc_a_02A7:
		test	dl,dl
		jz	loc_a_02F6		; Jump if zero
		call	sub_a_07E5		; clear video memory, setup palettes
		call	sub_a_1AB3
		mov	di,d_B800_0924_e
		mov	cx,15h
		mov	al,50h			; 'P'

locloop_a_02B9:
		mov	es:[di],al
		mov	es:d_B800_2000_e[di],al
		add	di,50h
		loop	locloop_a_02B9		; Loop if cx > 0

		mov	di,d_B800_094B_e
		mov	cx,15h
		mov	al,5

locloop_a_02CE:
		mov	es:[di],al
		mov	es:d_B800_2000_e[di],al
		add	di,50h
		loop	locloop_a_02CE		; Loop if cx > 0

		mov	di,d_B800_0924_e
		mov	cx,28h
		mov	al,55h			; 'U'
		rep	stosb			; Rep when cx >0 Store al to es:[di]

		mov	di,d_B800_0FB4_e
		mov	cx,28h
		rep	stosb			; Rep when cx >0 Store al to es:[di]

		call	sub_a_1A87
		mov	si,offset data_b_032E
		call	sub_a_1A25
loc_a_02F6:
		mov	di,213Ch		; jump table of init screen
		sub	dl,dl
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)

;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		test	ah,ah
		jnz	loc_a_02A7		; Jump if not zero
		cmp	al,31h			; '1'
		je	loc_a_0314		; Jump if equal

; !!!! Picopad modification: use Enter

		cmp	al,0Dh			; Enter
		je	loc_a_0314		; Jump if equal
;		cmp	al,21h			; '!'
;		je	loc_a_0314		; Jump if equal

		mov	ah,3
		cmp	al,32h			; '2'
		je	loc_a_0314		; Jump if equal
		cmp	al,40h			; '@'
		jne	loc_a_02A7		; Jump if not equal
loc_a_0314:
;*		call	sub_a_03CA		;*
		db	0E8h,0B3h, 00h		;  Fixup - byte match
		mov	ds,data_b_045B		; 2nd data segment
		assume	ds:seg_c
		mov	data_c_0491,ah
		test	ah,ah
		jz	loc_a_0326		; Jump if zero
;*		call	sub_a_03CA		;*
		db	0E8h,0A4h, 00h		;  Fixup - byte match
loc_a_0326:
		mov	ds,data_c_045B
		call	sub_a_051D
		retn
sub_a_0280	endp

			                        ;* No entry point to code
		adc	[bp+di],cx
		add	ax,4550h
		push	dx
		push	bx
		dec	di
		dec	si
		inc	cx
		dec	sp
		and	[bp+di+4Fh],al
		dec	bp
		push	ax
		push	bp
		push	sp
		inc	bp
		push	dx
		or	al,0Eh
		or	dx,[bp+65h]
		jc	loc_a_03BC		; Jump if carry Set
		imul	bp,word ptr [bx+6Eh],3120h	; reg = data * value
		xor	cs:[bx+si],dh
		adc	cl,[bp+di]
		push	cs
copyright	db	'(C) Copyright 1983'
		db	 17h, 08h, 10h
		db	'Written by: R. J. Grafe"'
		db	 03h, 14h, 50h
		db	'ress F1 Key at any time for Help'
		db	'.!'
		db	 03h, 17h
		db	'Select Number of Pla'
loc_a_03BC:
;*		jns	loc_a_0423		;*Jump if not sign
		db	 79h, 65h		;  Fixup - byte match
;*		jc	loc_a_0433		;*Jump if carry Set
		db	 72h, 73h		;  Fixup - byte match
		and	[bx+si],ch
		xor	[bx+si],sp
		outsw				; Out [si] to port dx
;*		jc	loc_a_03E7		;*Jump if carry Set
		db	 72h, 20h		;  Fixup - byte match
		xor	ch,[bx+di]
		add	[bx+si-4Eh],dl
		add	ds:data_a_74D2_e[si],ax
		and	bp,ax
		adc	[si],ax
		mov	si,offset data_a_046B
		call	sub_a_1A25
		pop	ax
		push	ax
		test	ah,ah
		jz	loc_a_03F1		; Jump if zero
		mov	si,4E4h
		assume	ds:seg_a
		cmp	byte ptr data_a_0492,1
		je	loc_a_03EE		; Jump if equal
;*		add	si,1Ch
		db	 81h,0C6h, 1Ch, 00h	;  Fixup - byte match
loc_a_03EE:
		call	sub_a_1A25
loc_a_03F1:
		call	sub_a_0831
		mov	di,213Ch		; jump table of init screen
		sub	dl,dl
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		test	ah,ah
;*		jnz	loc_a_0466		;*Jump if not zero
		db	 75h, 66h		;  Fixup - byte match
		cmp	al,73h			; 's'
		je	loc_a_0408		; Jump if equal
		cmp	al,53h			; 'S'
		jne	loc_a_0422		; Jump if not equal
loc_a_0408:
		mov	data_a_0465,47Fh
		mov	data_a_048B,246h
		mov	data_a_048D,246h
		mov	byte ptr data_a_048F,53h	; 'S'
		jmp	short loc_a_0469
		db	90h
loc_a_0422:
		cmp	al,61h			; 'a'
		je	loc_a_042A		; Jump if equal

; !!!! Picopad modification: use Enter

		cmp	al,0Dh			; Enter
		jne	loc_a_0444		; Jump if not equal
;		cmp	al,41h			; 'A'
;		jne	loc_a_0444		; Jump if not equal


loc_a_042A:
		mov	data_a_0465,467h
		mov	data_a_048B,6Ch
		mov	data_a_048D,6Ch
		mov	byte ptr data_a_048F,41h	; 'A'
		jmp	short loc_a_0469
		db	90h
loc_a_0444:
		cmp	al,70h			; 'p'
		je	loc_a_044C		; Jump if equal
		cmp	al,50h			; 'P'
;*		jne	loc_a_0466		;*Jump if not equal
		db	 75h, 1Ah		;  Fixup - byte match
loc_a_044C:
		mov	data_a_0465,473h
		mov	data_a_048B,159h
		mov	data_a_048D,159h
		mov	byte ptr data_a_048F,50h	; 'P'
		jmp	short loc_a_0469
data_a_0465	dw	0E990h
		db	 64h,0FFh
loc_a_0469:
		pop	ax
		retn
data_a_046B	db	0Bh
		db	 0Eh, 03h
data_a_046E	db	'SKILL LEVEL'
		db	 11h, 0Ah, 07h
		db	'A - Amateur lev'
data_a_048B	dw	6C65h
data_a_048D	dw	0A16h
data_a_048F	db	9
		db	 50h, 20h
data_a_0492	db	2Dh
data_a_0493	db	20h
data_a_0494	db	'Professiona'
data_a_049F	db	6Ch
		db	 20h, 6Ch, 65h, 76h, 65h, 6Ch
		db	 13h, 0Ah, 0Bh
		db	'S - Superstar level$'
		db	 02h, 14h, 54h
		db	'ype A, P or S to choose'
		db	' skill level'
		db	 00h, 18h, 08h, 16h
		db	'for Player 1 (left side)'
		db	 00h, 19h, 07h, 16h
		db	'for Player 2 (right side)'
		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_051D	proc	near
		call	sub_a_052F
		mov	ds,ds:d_0000_045B_e
		call	sub_a_052F
		mov	ds,ds:d_0000_045B_e
		call	sub_a_0620

loc_ret_a_052E:
		retn
sub_a_051D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_052F	proc	near
		sub	ax,ax
		sub	di,di
		push	es
		push	ds
		pop	es
		mov	cx,459h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		pop	es
		mov	word ptr ds:d_0000_0444_e,0
		mov	word ptr ds:d_0000_0446_e,5
		mov	cx,20h
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	bx,dx

locloop_a_0555:
		mov	ah,1Fh
		and	ah,bh
		cmp	ah,1Ch
		jle	loc_a_0563		; Jump if < or =
		sub	ah,1Bh
		shl	ah,1			; Shift w/zeros fill
loc_a_0563:
		mov	al,1Fh
		and	al,bl
		jnz	loc_a_056B		; Jump if not zero
		add	al,4
loc_a_056B:
		cmp	al,1Fh
		jne	loc_a_0571		; Jump if not equal
		sub	al,6
loc_a_0571:
		ror	bx,1			; Rotate
		xor	bl,bh
		cmp	cx,10h
		jne	loc_a_057E		; Jump if not equal
;*		xor	bx,0FFFFh
		db	 81h,0F3h,0FFh,0FFh	;  Fixup - byte match
loc_a_057E:
		call	sub_a_0820

		; test	byte ptr ds:d_0000_0078_e[di],0Fh
		db	0f6h, 85h
		dw	d_0000_0078_e
		db	0fh

		jnz	loc_a_0596		; Jump if not zero
		cmp	ah,12h
		jl	loc_a_0591		; Jump if <
		inc	word ptr ds:d_0000_0444_e
loc_a_0591:
		; mov	byte ptr ds:d_0000_0078_e[di],1
		db	0c6h, 85h
		dw	d_0000_0078_e
		db	1

loc_a_0596:
		loop	locloop_a_0555		; Loop if cx > 0

		mov	word ptr ds:d_0000_0440_e,1
		mov	word ptr ds:d_0000_0442_e,102h
		mov	al,ds:d_0000_0491_e
		mov	ds:d_0000_044A_e,al
		mov	si,ds:d_0000_0465_e
		mov	al,[si+2]
		mov	ds:d_0000_0450_e,al
		mov	al,[si+3]
		mov	ds:d_0000_044E_e,al
		mov	ds:d_0000_044F_e,al
		mov	ax,[si+6]
		mov	ds:d_0000_0012_e,ax
		mov	al,[si+0Ah]
		mov	ds:d_0000_0019_e,al
		mov	cl,[si+4]
		mov	ds:d_0000_000B_e,cl
		mov	ax,0FFh
		test	cl,cl
		jz	loc_a_05D9		; Jump if zero
		div	cl			; al, ah rem = ax/reg
loc_a_05D9:
		mov	ds:d_0000_0451_e,al
		mov	byte ptr ds:d_0000_0075_e,8
		mov	byte ptr ds:d_0000_001E_e,12h
		mov	byte ptr ds:d_0000_044B_e,2Dh	; '-'
		mov	byte ptr ds:d_0000_044C_e,2Dh	; '-'
		mov	byte ptr ds:d_0000_0448_e,1
		mov	byte ptr ds:d_0000_0449_e,1
		mov	byte ptr ds:d_0000_0026_e,3
		mov	byte ptr ds:d_0000_0027_e,3
		mov	byte ptr ds:d_0000_0024_e,0Fh
		mov	byte ptr ds:d_0000_0025_e,1Bh
		mov	al,3Ch			; '<'
		mov	ah,51h			; 'Q'
		mov	ds:d_0000_0028_e,ax
		mov	byte ptr ds:d_0000_0002_e,1
		mov	byte ptr ds:d_0000_0003_e,1
		retn
sub_a_052F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0620	proc	near
		mov	word ptr ds:d_0000_0010_e,2BCh
		mov	word ptr ds:d_0000_000E_e,0
		mov	byte ptr ds:d_0000_0018_e,78h	; 'x'
		mov	word ptr ds:d_0000_0016_e,0
		mov	word ptr ds:d_0000_0020_e,0
		mov	byte ptr ds:d_0000_000A_e,0FAh
		mov	word ptr ds:d_0000_0008_e,0
		mov	byte ptr ds:d_0000_0074_e,8
		mov	word ptr ds:d_0000_0072_e,0
		mov	bx,d_0000_002A_e
		mov	cx,0Ch

locloop_a_0659:
		mov	word ptr [bx],0
		add	bx,6
		loop	locloop_a_0659		; Loop if cx > 0

		mov	word ptr ds:d_0000_0000_e,0
		dec	byte ptr ds:d_0000_044A_e
		call	sub_a_06D1
		mov	byte ptr ds:d_0000_0453_e,0
		mov	byte ptr ds:d_0000_0454_e,0
		cmp	byte ptr ds:d_0000_0490_e,0
		je	loc_a_068A		; Jump if equal
		mov	dx,201h
loc_a_0683:
		in	al,dx			; port 201h, start game 1-shots
		xor	al,0F0h
		and	al,0F0h
		jnz	loc_a_0683		; Jump if not zero
loc_a_068A:
		mov	bl,ds:d_0000_0452_e
		test	bl,bl
		jnz	loc_a_0694		; Jump if not zero
		mov	bl,0F0h
loc_a_0694:
		sub	al,al
		cmp	byte ptr ds:d_0000_0453_e,0
		jne	loc_a_06C4		; Jump if not equal
		cmp	byte ptr ds:d_0000_0490_e,0
		je	loc_a_06AE		; Jump if equal
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		xor	al,0F0h
		and	al,bl
		jnz	loc_a_06C4		; Jump if not zero
loc_a_06AE:
		mov	di,213Ch		; jump table of init screen
		sub	dl,dl
		push	bx
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		pop	bx

; !!!! Picopad modification: Enter preferred to start game

		cmp	ax,0Dh ;20h

		jne	loc_a_06C2		; Jump if not equal
		mov	byte ptr ds:d_0000_0453_e,1
loc_a_06C2:
		jmp	short loc_a_0694
loc_a_06C4:
		mov	ds:d_0000_0452_e,al
		mov	word ptr ds:d_0000_0455_e,0
		call	sub_a_0890
		retn
sub_a_0620	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_06D1	proc	near
		call	sub_a_07E5		; clear video memory, setup palettes
		mov	dx,3D9h
		mov	al,10h
		cmp	byte ptr ds:d_0000_0449_e,0
		jne	loc_a_06E2		; Jump if not equal
		mov	al,30h			; '0'
loc_a_06E2:
		out	dx,al			; port 3D9h, CGA color control
		mov	di,289h
		mov	cx,5Ch
		mov	al,0F0h

locloop_a_06EB:
		mov	es:[di],al
		mov	byte ptr es:[2000h][di],al
		add	di,50h
		loop	locloop_a_06EB		; Loop if cx > 0

		mov	di,2C6h
		mov	cx,5Ch
		mov	al,0Fh

locloop_a_0700:
		mov	es:[di],al
		mov	byte ptr es:[2000h][di],al
		add	di,50h
		loop	locloop_a_0700		; Loop if cx > 0

		mov	ax,0FFFFh
		mov	di,289h
		mov	cx,1Fh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,data_a_3EF9_e
		mov	cx,1Fh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		push	ds
		mov	ds,ds:d_0000_045D_e
		mov	ds,ds:d_0000_045B_e
		cmp	byte ptr ds:d_0000_0491_e,0
		pop	ds
		jz	loc_a_0740		; Jump if zero
		mov	di,24h
		mov	al,ds:d_0000_0495_e
		call	sub_a_1AD3
		mov	al,ds:d_0000_0496_e
		call	sub_a_1AD3
loc_a_0740:
		call	sub_a_07F5
		mov	ds,ds:d_0000_045B_e
		call	sub_a_07F5
		mov	ds,ds:d_0000_045B_e
		mov	ax,ds:d_0000_0028_e
		call	sub_a_124B
		mov	ax,ds:d_0000_0000_e
		test	ax,ax
		jz	loc_a_0762		; Jump if zero
		mov	si,ds:d_0000_0006_e
		call	sub_a_1920
loc_a_0762:
		cmp	word ptr ds:d_0000_0020_e,0
		je	loc_a_076C		; Jump if equal
		call	sub_a_1151
loc_a_076C:
		mov	ax,ds:d_0000_0016_e
		test	ax,ax
		jz	loc_a_0781		; Jump if zero
		mov	si,410h
		test	ah,1
		jz	loc_a_077E		; Jump if zero
		add	si,20h
loc_a_077E:
		call	sub_a_1979
loc_a_0781:
		mov	ax,ds:d_0000_000E_e
		test	ax,ax
		jz	loc_a_078B		; Jump if zero
		call	sub_a_0ECD
loc_a_078B:
		mov	ax,ds:d_0000_0072_e
		test	ax,ax
		jz	loc_a_0799		; Jump if zero
		mov	si,ds:d_0000_0076_e
		call	sub_a_1979
loc_a_0799:
		mov	ax,ds:d_0000_0008_e
		test	ax,ax
		jz	loc_a_07A6		; Jump if zero
		mov	si,450h
		call	sub_a_1920
loc_a_07A6:
		mov	cx,3C0h
		sub	di,di

locloop_a_07AB:
		; and	byte ptr ds:d_0000_0078_e[di],0DFh
		db	80h, 0a5h
		dw	d_0000_0078_e
		db	0dfh

		; test	byte ptr ds:d_0000_0078_e[di],0Fh
		db	0f6h, 085h
		dw	d_0000_0078_e
		db	0fh

		jz	loc_a_07CE		; Jump if zero
		mov	dx,di
		mov	al,dl
		and	al,1Fh
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		mov	ah,dl
		mov	bp,ax
		call	sub_a_0F18
loc_a_07CE:
		inc	di
		loop	locloop_a_07AB		; Loop if cx > 0

		mov	cx,0Ch
		mov	bx,d_0000_002A_e

locloop_a_07D7:
		cmp	word ptr [bx],0
		je	loc_a_07DF		; Jump if equal
		call	sub_a_0C25
loc_a_07DF:
		add	bx,6
		loop	locloop_a_07D7		; Loop if cx > 0

		retn
sub_a_06D1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; clear video memory, setup palettes

sub_a_07E5	proc	near
		mov	cx,2000h
		sub	ax,ax
		sub	di,di
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	dx,3D9h
		mov	al,30h			; '0'
		out	dx,al			; port 3D9h, CGA color control
		retn
sub_a_07E5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_07F5	proc	near
		cmp	byte ptr ds:d_0000_0491_e,0
		je	loc_ret_a_081F		; Jump if equal
		sub	ax,ax
		sub	dx,dx
		call	sub_a_13D0
		mov	cl,ds:d_0000_044A_e
loc_a_0807:
		test	cl,cl
		jz	loc_ret_a_081F		; Jump if zero
		dec	cl
		mov	ah,cl
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		add	ah,ds:d_0000_0462_e
		mov	al,ds:d_0000_0461_e
		call	sub_a_124B
		jmp	short loc_a_0807

loc_ret_a_081F:
		retn
sub_a_07F5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0820	proc	near
		mov	dx,ax
		sub	al,al
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	al,dl
		mov	di,ax
		mov	ax,dx
		retn
sub_a_0820	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0831	proc	near
		cmp	data_a_0493,0
		jne	loc_a_083C		; Jump if not equal

		; enable sound output
		mov	al,4Fh			; 'O'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Fh, speaker on
loc_a_083C:
		mov	ax,1388h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	ax,32h
loc_a_0848:
		mov	cx,280h

locloop_a_084B:
		loop	locloop_a_084B		; Loop if cx > 0

		dec	ax
		jnz	loc_a_0848		; Jump if not zero

		; disable sound output
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		retn
sub_a_0831	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play melody

sub_a_0855	proc	near
loc_a_0855:
		assume	ds:seg_c
		cmp	byte ptr data_c_0493,0
		jne	loc_a_0860		; Jump if not equal

		; enable sound output
		mov	al,4Fh			; 'O'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Fh, speaker on
loc_a_0860:
		mov	ax,cs:[si]
		test	ax,ax
		jz	loc_a_0887		; Jump if zero
		cmp	ax,1
		jne	loc_a_0870		; Jump if not equal
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
loc_a_0870:
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		inc	si
		inc	si
		mov	ax,cs:[si]
loc_a_087B:
		mov	cx,280h

locloop_a_087E:
		loop	locloop_a_087E		; Loop if cx > 0

		dec	ax
		jnz	loc_a_087B		; Jump if not zero
		inc	si
		inc	si
		jmp	short loc_a_0855
loc_a_0887:
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		retn
sub_a_0855	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0890	proc	near
		mov	byte ptr ds:d_0000_044D_e,0

		; disable sound output
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		mov	bx,2Ah
		mov	cx,0Ch

locloop_a_089F:
		mov	byte ptr [bx+4],0
		mov	byte ptr [bx+2],0
		mov	byte ptr [bx+3],1
		add	bx,6
		loop	locloop_a_089F		; Loop if cx > 0

		call	sub_a_0831
		sub	bx,bx
loc_a_08B5:
		dec	bx
		jnz	loc_a_08B5		; Jump if not zero
		mov	bx,2Ah
		mov	cl,ds:d_0000_0448_e
loc_a_08BF:
		dec	cl
		jz	loc_a_08CC		; Jump if zero
		mov	byte ptr [bx+4],3
		add	bx,6
		jmp	short loc_a_08BF
loc_a_08CC:
		mov	byte ptr [bx+4],1
		mov	bx,d_0000_006C_e
		or	byte ptr [bx+4],2
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	al,1
		and	al,dl
		mov	byte ptr [bx+2],1
		mov	byte ptr [bx],10h
		jnz	loc_a_08F3		; Jump if not zero
		mov	byte ptr [bx+2],0FFh
		mov	byte ptr [bx],0Fh
loc_a_08F3:
		call	sub_a_0C25
		mov	cx,0Bh

locloop_a_08F9:
		sub	bx,6
		mov	al,2
		and	al,[bx+4]
		jz	loc_a_0934		; Jump if zero
		mov	si,1Fh
		and	si,dx
		dec	si
		cmp	si,0
		jg	loc_a_091B		; Jump if >
		add	si,0Eh
loc_a_0911:
		inc	si
		inc	si
		cmp	si,1Eh
		jle	loc_a_091B		; Jump if < or =
		mov	si,d_0000_0000_e+1
loc_a_091B:
		mov	al,20h			; ' '

		; and	al,ds:d_0000_0078_e[si]
		db	22h, 84h
		dw	d_0000_0078_e

		jnz	loc_a_0911		; Jump if not zero
		mov	[bx],si
		mov	byte ptr [bx+2],1
		ror	dx,1			; Rotate
		jnc	loc_a_0931		; Jump if carry=0
		mov	byte ptr [bx+2],0FFh
loc_a_0931:
		call	sub_a_0C25
loc_a_0934:
		loop	locloop_a_08F9		; Loop if cx > 0

		retn
sub_a_0890	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0937	proc	near
		dec	data_c_044E
		jz	loc_a_0940		; Jump if zero
		jmp	loc_ret_a_0A33
loc_a_0940:
		mov	al,data_c_044F
		mov	data_c_044E,al

		; disable sound output
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		mov	ax,data_c_0438
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		cmp	byte ptr data_c_0493,0
		jne	loc_a_095E		; Jump if not equal

		; enable sound output
		mov	al,4Fh			; 'O'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Fh, speaker on
loc_a_095E:
		mov	bx,offset data_c_002A
		mov	cx,0Dh
loc_a_0964:
		dec	cx
		jz	loc_a_0973		; Jump if zero
		mov	al,1
		and	al,[bx+4]
		jnz	loc_a_0973		; Jump if not zero
		add	bx,6
		jmp	short loc_a_0964
loc_a_0973:
		test	cx,cx
		jnz	loc_a_09D5		; Jump if not zero
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
loc_a_097B:
;*		and	cx,0FFFFh
		db	 81h,0E1h,0FFh,0FFh	;  Fixup - byte match
;*		and	cx,0FFFFh
		db	 81h,0E1h,0FFh,0FFh	;  Fixup - byte match
		dec	cx
		jnz	loc_a_097B		; Jump if not zero
		mov	al,data_c_0449
		add	data_c_0448,al
		cmp	byte ptr data_c_0448,0Dh
		jne	loc_a_0999		; Jump if not equal
		mov	byte ptr data_c_0448,1
loc_a_0999:
		xor	byte ptr data_c_0449,1
		mov	ax,data_c_043A
		xchg	ah,al
		cmp	ax,4
		jl	loc_a_09AD		; Jump if <
		or	byte ptr data_c_0449,1
loc_a_09AD:
		mov	si,data_c_0465
		mov	al,[si+3]
		mov	data_c_044F,al
		mov	data_c_044E,al
		mov	dx,3D9h
		mov	al,10h
		cmp	byte ptr data_c_0449,0
		jne	loc_a_09CE		; Jump if not equal
		mov	al,data_c_0450
		mov	data_c_044F,al
		mov	al,30h			; '0'
loc_a_09CE:
		out	dx,al			; port 3D9h, CGA color control
		call	sub_a_0890
		jmp	short loc_ret_a_0A33
		db	90h
loc_a_09D5:
		call	sub_a_0A34
loc_a_09D8:
;*		cmp	bx,offset data_c_006C
		db	 81h,0FBh, 6Ch, 00h	;  Fixup - byte match
		jz	loc_a_09EC		; Jump if zero
		add	bx,6
		test	byte ptr [bx+4],1
		jz	loc_a_09D8		; Jump if zero
		call	sub_a_0A34
		jmp	short loc_a_09D8
loc_a_09EC:
		assume	ds:seg_b
		cmp	byte ptr data_b_044D,0
		jne	loc_a_0A30		; Jump if not equal
		mov	bx,offset data_c_006C
		mov	cx,0Ch

locloop_a_09F9:
		test	byte ptr [bx+4],2
		jz	loc_a_0A28		; Jump if zero
		mov	al,0Ch
		and	al,[bx+4]
		jnz	loc_a_0A28		; Jump if not zero
		cmp	byte ptr [bx+1],1Dh
		jne	loc_a_0A28		; Jump if not equal
loc_a_0A0C:
		test	byte ptr [bx+4],1
		jnz	loc_a_0A17		; Jump if not zero
		sub	bx,6
		jmp	short loc_a_0A0C
loc_a_0A17:
		cmp	byte ptr [bx+1],1Dh
		jne	loc_a_0A28		; Jump if not equal
		assume	ds:seg_c
		mov	byte ptr data_c_044D,1
		mov	al,data_c_044C
		mov	data_c_044B,al
loc_a_0A28:
		sub	bx,6
		loop	locloop_a_09F9		; Loop if cx > 0

		jmp	short loc_ret_a_0A33
		db	90h
loc_a_0A30:
		call	sub_a_0B93

loc_ret_a_0A33:
		retn
sub_a_0937	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0A34	proc	near
		mov	ax,[bx]
		push	ax
		push	word ptr [bx+2]
loc_a_0A3A:
		test	byte ptr [bx+4],2
		jnz	loc_a_0A50		; Jump if not zero
		mov	ax,[bx+6]
		mov	[bx],ax
		mov	ax,[bx+8]
		mov	[bx+2],ax
		add	bx,6
		jmp	short loc_a_0A3A
loc_a_0A50:
		mov	ax,[bx]
		test	al,al
		jnz	loc_a_0A5C		; Jump if not zero
		mov	al,0Fh
		mov	byte ptr [bx+2],0FFh
loc_a_0A5C:
		mov	bp,ax
		add	al,[bx+2]
		mov	[bx],ax
		call	sub_a_0820
		test	byte ptr data_c_0078[di],10h
		jz	loc_a_0A71		; Jump if zero
		or	byte ptr [bx+4],4
loc_a_0A71:
		cmp	dl,1
		jl	loc_a_0A92		; Jump if <
		cmp	dl,1Eh
		jg	loc_a_0A92		; Jump if >
		mov	al,4
		and	al,[bx+4]
		jnz	loc_a_0A92		; Jump if not zero
		mov	al,0Fh
		and	al,data_c_0078[di]
		jnz	loc_a_0A92		; Jump if not zero
		mov	al,20h			; ' '
		and	al,data_c_0078[di]
		jz	loc_a_0AE0		; Jump if zero
loc_a_0A92:
		mov	ax,bp
		add	ah,[bx+3]
		mov	[bx],ax
		cmp	byte ptr [bx+3],0FFh
		jne	loc_a_0AA3		; Jump if not equal
		and	byte ptr [bx+4],0FBh
loc_a_0AA3:
		and	byte ptr [bx+4],0F7h
		cmp	ah,1Dh
		jne	loc_a_0ABF		; Jump if not equal
		mov	byte ptr [bx+3],0FFh
		mov	dl,4
		and	dl,[bx+4]
		jz	loc_a_0ABF		; Jump if zero
		and	byte ptr [bx+4],0FBh
		or	byte ptr [bx+4],8
loc_a_0ABF:
		cmp	ah,18h
		jne	loc_a_0AC8		; Jump if not equal
		mov	byte ptr [bx+3],1
loc_a_0AC8:
		xor	byte ptr [bx+2],0FFh
		inc	byte ptr [bx+2]
		call	sub_a_0820
		test	byte ptr data_c_0078[di],10h
		jz	loc_a_0AF5		; Jump if zero
		or	byte ptr [bx+4],4
		jmp	short loc_a_0AF5
		db	90h
loc_a_0AE0:
		test	byte ptr [bx+4],8
		jz	loc_a_0AF5		; Jump if zero
		and	byte ptr [bx+4],0F7h
		or	byte ptr [bx+4],4
		xor	byte ptr [bx+2],0FFh
		inc	byte ptr [bx+2]
loc_a_0AF5:
		call	sub_a_0C25
		mov	ax,[bx]
		cmp	ax,data_c_0000
		jne	loc_a_0B03		; Jump if not equal
		call	sub_a_0B27
loc_a_0B03:
		pop	si
		pop	ax
		test	ax,ax
		jz	loc_a_0B1B		; Jump if zero
		push	word ptr [bx]
		push	word ptr [bx+2]
		mov	[bx],ax
		mov	[bx+2],si
		call	sub_a_0C25
		pop	word ptr [bx+2]
		pop	word ptr [bx]
loc_a_0B1B:
		mov	ax,[bx]
		cmp	ax,data_c_0024
		jne	loc_ret_a_0B26		; Jump if not equal
		call	sub_a_1589

loc_ret_a_0B26:
		retn
sub_a_0A34	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0B27	proc	near
		mov	ax,data_c_0000
		push	ax
		mov	bx,offset data_c_0024
loc_a_0B2E:
		add	bx,6
		cmp	ax,[bx]
		jne	loc_a_0B2E		; Jump if not equal
		sub	dx,dx
		mov	ah,1
		test	byte ptr [bx+4],2
		jz	loc_a_0B41		; Jump if zero
		xchg	dl,ah
loc_a_0B41:
		sub	al,al
		call	sub_a_13D0
		test	byte ptr [bx+4],1
		jnz	loc_a_0B50		; Jump if not zero
		or	byte ptr [bx-2],2
loc_a_0B50:
		test	byte ptr [bx+4],2
		jnz	loc_a_0B5A		; Jump if not zero
		or	byte ptr [bx+0Ah],1
loc_a_0B5A:
		mov	byte ptr [bx+4],0
		pop	ax
		mov	si,data_c_0006
		call	sub_a_1920
		mov	data_c_0000,0
		call	sub_a_0C25
		mov	ax,[bx]
		mov	word ptr [bx],0
		call	sub_a_0820
		test	byte ptr data_c_0078[di],0Fh
		jnz	loc_ret_a_0B92		; Jump if not zero
		or	byte ptr data_c_0078[di],1
		cmp	dh,12h
		jl	loc_a_0B8D		; Jump if <
		inc	data_c_0444
loc_a_0B8D:
		mov	bp,dx
		call	sub_a_0F18

loc_ret_a_0B92:
		retn
sub_a_0B27	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0B93	proc	near
		cmp	byte ptr data_c_044B,0
		jle	loc_a_0BAC		; Jump if < or =
		dec	data_c_044B
		cmp	byte ptr data_c_0449,0
		jne	loc_a_0BA9		; Jump if not equal
		dec	data_c_044B
loc_a_0BA9:
		jmp	short loc_ret_a_0C24
		db	90h
loc_a_0BAC:
		mov	al,data_c_044C
		cmp	al,15h
		jl	loc_a_0BB8		; Jump if <
		sub	al,2
		mov	data_c_044C,al
loc_a_0BB8:
		mov	data_c_044B,al
		mov	bx,offset data_c_002A
		mov	cx,0Ch

locloop_a_0BC1:
		cmp	word ptr [bx],0
		je	loc_a_0BCB		; Jump if equal
		add	bx,6
		loop	locloop_a_0BC1		; Loop if cx > 0

loc_a_0BCB:
		test	cx,cx
		jnz	loc_a_0BF0		; Jump if not zero
		mov	cx,0Ch

locloop_a_0BD2:
		sub	bx,6
		mov	al,3
		and	al,[bx+4]
		cmp	al,1
		je	loc_a_0BE0		; Jump if equal
		loop	locloop_a_0BD2		; Loop if cx > 0

loc_a_0BE0:
		test	cx,cx
		jz	loc_a_0BF0		; Jump if zero
		or	byte ptr [bx+0Ah],1
		mov	ax,[bx]
		call	sub_a_0C25
		mov	cx,1
loc_a_0BF0:
		test	cx,cx
		jz	loc_ret_a_0C24		; Jump if zero
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	word ptr [bx+2],101h
		mov	word ptr [bx],1701h
		shr	dx,1			; Shift w/zeros fill
		jnc	loc_a_0C10		; Jump if carry=0
		mov	byte ptr [bx+2],0FFh
		mov	byte ptr [bx],1Eh
loc_a_0C10:
		or	byte ptr [bx+4],3
		mov	ax,[bx]
		call	sub_a_0C25
		mov	ax,[bx]
		cmp	ax,data_c_0000
		jne	loc_ret_a_0C24		; Jump if not equal
		call	sub_a_0B27

loc_ret_a_0C24:
		retn
sub_a_0B93	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0C25	proc	near
		mov	ax,[bx]
		mov	si,348h
		cmp	byte ptr [bx+2],1
		jne	loc_a_0C33		; Jump if not equal
		add	si,0Ch
loc_a_0C33:
		test	ah,1
		jz	loc_a_0C3F		; Jump if zero
		test	al,1
		jnz	loc_a_0C43		; Jump if not zero
		jmp	short loc_a_0C46
		db	90h
loc_a_0C3F:
		test	al,1
		jnz	loc_a_0C46		; Jump if not zero
loc_a_0C43:
		add	si,18h
loc_a_0C46:
		call	sub_a_0820

		; xor	byte ptr ds:d_0000_0078_e[di],20h	; ' '
		db	80h, 0b5h
		dw	d_0000_0078_e
		db	20h

		call	sub_a_1920
		retn
sub_a_0C25	endp

		db	14 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0C60	proc	near
		cmp	byte ptr data_c_0008,0
		jne	loc_a_0C6A		; Jump if not equal
		jmp	loc_a_0D1B
loc_a_0C6A:
		mov	al,0FFh
		mul	byte ptr data_c_0008+1	; ax = data * al
		mov	si,ax
		mov	al,data_c_000B
		inc	al
		sub	al,data_c_000A
		mul	data_c_0451		; ax = data * al
		add	ax,si
		mov	data_c_0438,ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		dec	data_c_000A
		jz	loc_a_0C93		; Jump if zero
		jmp	loc_ret_a_0D24
loc_a_0C93:
		mov	al,data_c_000B
		mov	data_c_000A,al
		mov	ax,data_c_0008
		push	ax
		inc	ah
		cmp	ah,1Dh
		jle	loc_a_0CB8		; Jump if < or =
		mov	byte ptr data_c_000A,0FAh
		mov	data_c_0008,0
		mov	data_c_0438,0
		jmp	short loc_a_0CCA
		db	90h
loc_a_0CB8:
		mov	data_c_0008,ax
		mov	si,450h
		call	sub_a_1920
		cmp	data_c_0000,ax
		jne	loc_a_0CCA		; Jump if not equal
		call	sub_a_0D8E
loc_a_0CCA:
		pop	ax
		mov	si,450h
		mov	bp,ax
		call	sub_a_1920
		call	sub_a_0820
		test	byte ptr data_c_0078[di],0Fh
		jnz	loc_a_0D0C		; Jump if not zero
		cmp	ah,1Dh
		je	loc_a_0D0C		; Jump if equal
		push	dx
		push	cx
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	al,dl
		pop	cx
		pop	dx
		and	al,7
		cmp	al,7
		jne	loc_a_0D0C		; Jump if not equal
		or	byte ptr data_c_0078[di],1
		mov	ax,bp
		cmp	ah,12h
		jl	loc_a_0D06		; Jump if <
		inc	data_c_0444
loc_a_0D06:
		mov	si,45Ch
		call	sub_a_1920
loc_a_0D0C:
		mov	ax,data_c_0008
		cmp	data_c_0024,ax
		jne	loc_ret_a_0D24		; Jump if not equal
		call	sub_a_1589
		jmp	short loc_ret_a_0D24
		db	90h
loc_a_0D1B:
		assume	ds:seg_b
		dec	data_b_000A
		jnz	loc_ret_a_0D24		; Jump if not zero
		call	sub_a_0D25

loc_ret_a_0D24:
		retn
sub_a_0C60	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0D25	proc	near
		assume	ds:seg_c
		cmp	byte ptr data_c_000E,0
		jne	loc_a_0D7C		; Jump if not equal
		cmp	byte ptr data_c_0448,1
		je	loc_a_0D7C		; Jump if equal
		mov	ax,data_c_0446
		cmp	data_c_0444,ax
		jge	loc_a_0D7C		; Jump if > or =
		mov	al,data_c_000B
		mov	data_c_000A,al
		push	dx
		push	cx
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		and	dl,1Fh
		dec	dl
		cmp	dl,0
		jg	loc_a_0D59		; Jump if >
		add	dl,10h
loc_a_0D59:
		mov	al,dl
		pop	cx
		pop	dx
		sub	ah,ah
		mov	data_c_0008,ax
		mov	si,450h
		call	sub_a_1920
		mov	byte ptr data_c_000C,0
		mov	ax,0FFh
		mov	data_c_0438,ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		jmp	short loc_ret_a_0D8D
		db	90h
loc_a_0D7C:
		mov	byte ptr data_c_000A,0FAh
		mov	data_c_0008,0
		mov	data_c_0438,0

loc_ret_a_0D8D:
		retn
sub_a_0D25	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0D8E	proc	near
		cmp	byte ptr data_c_000C,1
		jne	loc_a_0DB0		; Jump if not equal
		call	sub_a_16A1
		sub	dx,dx
		mov	dl,2
		sub	ax,ax
		call	sub_a_13D0
		mov	ax,data_c_0008
		mov	si,450h
		call	sub_a_1920
		call	sub_a_0D25
		jmp	short loc_a_0DB5
		db	90h
loc_a_0DB0:
		mov	byte ptr data_c_000C,1
loc_a_0DB5:
		mov	ax,data_c_0000
		mov	si,data_c_0006
		call	sub_a_1920
		mov	data_c_0000,0
		retn
sub_a_0D8E	endp

		db	10 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0DD0	proc	near
		cmp	byte ptr data_c_000E,0
		jne	loc_a_0DDA		; Jump if not equal
		jmp	loc_a_0E77
loc_a_0DDA:
		mov	al,1
		and	al,byte ptr data_c_000E
		mov	ax,7D0h
		jz	loc_a_0DE7		; Jump if zero
		shl	ax,1			; Shift w/zeros fill
loc_a_0DE7:
		mov	data_c_0438,ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		dec	data_c_0010
		jz	loc_a_0DF9		; Jump if zero
		jmp	loc_ret_a_0E80
loc_a_0DF9:
		mov	ax,data_c_0012
		mov	data_c_0010,ax
		mov	ax,data_c_000E
		mov	si,378h
		cmp	byte ptr data_c_0014,1
		jne	loc_a_0E0F		; Jump if not equal
		add	si,20h
loc_a_0E0F:
		test	ax,1
		jz	loc_a_0E17		; Jump if zero
		add	si,40h
loc_a_0E17:
		push	si
		push	ax
		add	al,data_c_0014
		test	al,al
		jz	loc_a_0E25		; Jump if zero
		cmp	al,1Fh
		jne	loc_a_0E3F		; Jump if not equal
loc_a_0E25:
		mov	data_c_000E,0
		mov	data_c_0010,2BCh
		mov	byte ptr data_c_000A,0FAh
		mov	data_c_0438,0
		jmp	short loc_a_0E6F
		db	90h
loc_a_0E3F:
		call	sub_a_0ECD
		mov	bp,ax
		call	sub_a_0820
		test	byte ptr data_c_0078[di],0Fh
		jz	loc_a_0E63		; Jump if zero
		test	byte ptr data_c_0078[di],10h
		jnz	loc_a_0E6F		; Jump if not zero
		call	sub_a_0F18
		or	byte ptr data_c_0078[di],10h
		call	sub_a_0F18
		jmp	short loc_a_0E6F
		db	90h
loc_a_0E63:
		mov	ax,data_c_000E
		cmp	ax,data_c_0000
		jne	loc_a_0E6F		; Jump if not equal
		call	sub_a_0EE9
loc_a_0E6F:
		pop	ax
		pop	si
		call	sub_a_1979
		jmp	short loc_ret_a_0E80
		db	90h
loc_a_0E77:
		dec	data_c_0010
		jnz	loc_ret_a_0E80		; Jump if not zero
		call	sub_a_0E81

loc_ret_a_0E80:
		retn
sub_a_0DD0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0E81	proc	near
		cmp	byte ptr data_c_0008,0
		jne	loc_a_0EC6		; Jump if not equal
		cmp	byte ptr data_c_0448,2
		jle	loc_a_0EC6		; Jump if < or =
		mov	ax,data_c_0012
		mov	data_c_0010,ax
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	ah,dl
		mov	al,dh
		and	ah,0Fh
		inc	ah
		and	al,1
		mov	dl,al
		jnz	loc_a_0EB0		; Jump if not zero
		dec	dl
		mov	al,1Eh
loc_a_0EB0:
		mov	data_c_0014,dl
		call	sub_a_0ECD
		mov	ax,7D0h
		mov	data_c_0438,ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		jmp	short loc_ret_a_0ECC
		db	90h
loc_a_0EC6:
		mov	data_c_0010,2BCh

loc_ret_a_0ECC:
		retn
sub_a_0E81	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0ECD	proc	near
		mov	ds:d_0000_000E_e,ax
		mov	si,378h
		cmp	byte ptr ds:d_0000_0014_e,1
		jne	loc_a_0EDD		; Jump if not equal
		add	si,20h
loc_a_0EDD:
		test	ax,1
		jz	loc_a_0EE5		; Jump if zero
		add	si,40h
loc_a_0EE5:
		call	sub_a_1979
		retn
sub_a_0ECD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0EE9	proc	near
		call	sub_a_16A1
		mov	data_c_0010,2BCh
		call	sub_a_0ECD
		mov	data_c_000E,0
		mov	si,data_c_0006
		call	sub_a_1920
		mov	data_c_0000,0
		mov	data_c_0438,0
		sub	ax,ax
		mov	dh,1
		sub	dl,dl
		call	sub_a_13D0
		retn
sub_a_0EE9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F18	proc	near
		push	di
		mov	si,45Ch

		; mov	al,ds:d_0000_0078_e[di]
		db	8ah, 85h
		dw	d_0000_0078_e

		and	al,1Fh
		mov	ah,al
		shr	al,1			; Shift w/zeros fill
		jc	loc_a_0F39		; Jump if carry Set
		add	si,0Ch
		shr	al,1			; Shift w/zeros fill
		jc	loc_a_0F39		; Jump if carry Set
		add	si,0Ch
		shr	al,1			; Shift w/zeros fill
		jc	loc_a_0F39		; Jump if carry Set
		add	si,0Ch
loc_a_0F39:
		and	ah,10h
		jz	loc_a_0F41		; Jump if zero
		add	si,30h
loc_a_0F41:
		mov	ax,bp
		call	sub_a_1920
		pop	di
		retn
sub_a_0F18	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0F50	proc	near
		cmp	data_c_0016,0
		je	loc_a_0F9B		; Jump if equal
		mov	ax,78h
		add	al,byte ptr data_c_0016+1
		add	al,byte ptr data_c_0016+1
		mov	data_c_0438,ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		dec	data_c_0018
		jz	loc_a_0F74		; Jump if zero
		jmp	short loc_a_0FEE
		db	90h
loc_a_0F74:
		mov	al,data_c_0019
		mov	data_c_0018,al
		mov	ax,data_c_0016
		push	ax
		add	ah,byte ptr data_c_001C+1
		add	al,byte ptr data_c_001C
		call	sub_a_0FFB
		pop	ax
		mov	si,410h
		test	ah,1
		jz	loc_a_0F95		; Jump if zero
		add	si,20h
loc_a_0F95:
		call	sub_a_1979
		jmp	short loc_a_0FEE
		db	90h
loc_a_0F9B:
		dec	data_c_0018
		jnz	loc_a_0FEE		; Jump if not zero
		cmp	data_c_0020,0
		jne	loc_a_0FE0		; Jump if not equal
		mov	al,data_c_0019
		mov	data_c_0018,al
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	ah,data_c_001E
		mov	data_c_001F,ah
		mov	al,1
		mov	byte ptr data_c_001A,1
		shr	dl,1			; Shift w/zeros fill
		jnc	loc_a_0FD0		; Jump if carry=0
		mov	al,1Eh
		mov	byte ptr data_c_001A,0FFh
loc_a_0FD0:
		mov	dl,data_c_001A
		mov	dh,0FFh
		mov	data_c_001C,dx
		call	sub_a_0FFB
		jmp	short loc_a_0FEE
		db	90h
loc_a_0FE0:
		call	sub_a_1151
		mov	data_c_0020,0
		mov	byte ptr data_c_0018,78h	; 'x'
loc_a_0FEE:
		mov	ax,data_c_0016
		cmp	ax,data_c_0024
		jne	loc_ret_a_0FFA		; Jump if not equal
		call	sub_a_1589

loc_ret_a_0FFA:
		retn
sub_a_0F50	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_0FFB	proc	near
		cmp	al,0
		jle	loc_a_1003		; Jump if < or =
		cmp	al,1Fh
		jl	loc_a_1017		; Jump if <
loc_a_1003:
		mov	data_c_0016,0
		mov	byte ptr data_c_0018,78h	; 'x'
		mov	data_c_0438,0
		jmp	short loc_ret_a_106F
		db	90h
loc_a_1017:
		call	sub_a_0820
		test	byte ptr data_c_0078[di],20h	; ' '
		jz	loc_a_102D		; Jump if zero
		sub	ax,data_c_001C
		add	al,data_c_001A
		mov	data_c_001F,ah
loc_a_102D:
		mov	data_c_0016,ax
		mov	si,410h
		test	ah,1
		jz	loc_a_103B		; Jump if zero
		add	si,20h
loc_a_103B:
		call	sub_a_1979
		cmp	ax,data_c_0000
		jne	loc_a_104A		; Jump if not equal
		call	sub_a_10EC
		jmp	short loc_a_1062
		db	90h
loc_a_104A:
		call	sub_a_0820
		test	byte ptr data_c_0078[di],0Fh
		jz	loc_a_1062		; Jump if zero
		mov	bp,dx
		call	sub_a_0F18
		and	byte ptr data_c_0078[di],0E0h
		dec	data_c_0444
loc_a_1062:
		mov	ah,byte ptr data_c_0016+1
		cmp	ah,data_c_001F
		jne	loc_ret_a_106F		; Jump if not equal
		call	sub_a_1070

loc_ret_a_106F:
		retn
sub_a_0FFB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1070	proc	near
		push	cx
		mov	ah,2Ch
		int	21h			; DOS Services  ah=function 2Ch
						;  get time, cx=hrs/min, dx=sec
		xor	dl,dh
		pop	cx
		mov	al,data_c_001A
		shr	dx,1			; Shift w/zeros fill
		jnc	loc_a_1081		; Jump if carry=0
		sub	al,al
loc_a_1081:
		mov	byte ptr data_c_001C,al
		shr	dx,1			; Shift w/zeros fill
		jnc	loc_a_10A5		; Jump if carry=0
		mov	al,byte ptr data_c_0016+1
		sub	al,data_c_001E
		cmp	al,2
		jl	loc_a_1099		; Jump if <
		call	sub_a_10C0
		jmp	short loc_ret_a_10BF
		db	90h
loc_a_1099:
		mov	al,1Dh
		sub	al,byte ptr data_c_0016+1
		call	sub_a_10D6
		jmp	short loc_ret_a_10BF
		db	90h
loc_a_10A5:
		mov	al,1Dh
		sub	al,byte ptr data_c_0016+1
		cmp	al,2
		jl	loc_a_10B5		; Jump if <
		call	sub_a_10D6
		jmp	short loc_ret_a_10BF
		db	90h
loc_a_10B5:
		mov	al,byte ptr data_c_0016+1
		sub	al,data_c_001E
		call	sub_a_10C0

loc_ret_a_10BF:
		retn
sub_a_1070	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_10C0	proc	near
		sub	al,2
		mul	dl			; ax = reg * al
		inc	ax
		add	ah,2
		mov	al,byte ptr data_c_0016+1
		sub	al,ah
		mov	data_c_001F,al
		mov	byte ptr data_c_001C+1,0FFh
		retn
sub_a_10C0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_10D6	proc	near
		sub	al,2
		mul	dl			; ax = reg * al
		inc	ax
		add	ah,2
		add	ah,byte ptr data_c_0016+1
		mov	data_c_001F,ah
		mov	byte ptr data_c_001C+1,1
		retn
sub_a_10D6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_10EC	proc	near
		mov	cl,data_c_0004
		sub	cl,byte ptr data_c_0000+1
		sub	ax,ax
		mov	dx,3
		mov	si,4ECh
		cmp	cl,5
		jg	loc_a_1106		; Jump if >
		mov	dl,6
		mov	si,50Ch
loc_a_1106:
		cmp	cl,2
		jg	loc_a_1110		; Jump if >
		mov	dl,9
		mov	si,52Ch
loc_a_1110:
		push	si
		call	sub_a_13D0
		pop	si
		mov	ax,data_c_0016
		mov	data_c_0022,ax
		mov	data_c_0020,si
		push	ax
		call	sub_a_1151
		pop	ax
		mov	si,410h
		test	ah,1
		jz	loc_a_112F		; Jump if zero
		add	si,20h
loc_a_112F:
		call	sub_a_1979
		mov	data_c_0016,0
		mov	byte ptr data_c_0018,78h	; 'x'
		mov	si,data_c_0006
		call	sub_a_1920
		mov	data_c_0000,0
		mov	data_c_0438,0
		retn
sub_a_10EC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1151	proc	near
		mov	si,ds:d_0000_0020_e
		mov	ax,ds:d_0000_0022_e
		call	sub_a_1979
		inc	al
		mov	si,54Ch
		call	sub_a_1979
		retn
sub_a_1151	endp

		db	12 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1170	proc	near
		dec	data_c_0026
		jz	loc_a_1179		; Jump if zero
		jmp	loc_ret_a_124A
loc_a_1179:
		mov	al,data_c_0027
		mov	data_c_0026,al
		call	sub_a_2FB8
		test	cx,cx
		jnz	loc_a_1189		; Jump if not zero
		jmp	loc_ret_a_124A
loc_a_1189:
		push	data_c_0024
		mov	dx,data_c_0028
		push	dx
		add	dl,cl
		add	dh,ch
		mov	bx,dx
		shr	dl,1			; Shift w/zeros fill
		shr	dl,1			; Shift w/zeros fill
		mov	al,dh
		sub	ah,ah
		mov	dh,3
		div	dh			; al, ah rem = ax/reg
		mov	ah,al
		mov	al,dl
		test	al,al
		jnz	loc_a_11B8		; Jump if not zero
		inc	al
		mov	bl,4
		mov	byte ptr data_c_0455,0	; horizontal move speed
		jmp	short loc_a_11C5
		db	90h
loc_a_11B8:
		cmp	al,1Fh
		jne	loc_a_11C5		; Jump if not equal
		mov	al,1Eh
		mov	bl,7Bh			; '{'
		mov	byte ptr data_c_0455,0	; horizontal move speed
loc_a_11C5:
		cmp	ah,17h
		jne	loc_a_11D6		; Jump if not equal
		mov	ah,18h
		mov	bh,48h			; 'H'
		mov	byte ptr data_c_0455+1,0 ; vertical move speed
		jmp	short loc_a_11E4
		db	90h
loc_a_11D6:
		cmp	ah,1Eh
		jne	loc_a_11E4		; Jump if not equal
		mov	ah,1Dh
		mov	bh,59h			; 'Y'
		mov	byte ptr data_c_0455+1,0 ; vertical move speed
loc_a_11E4:
		mov	data_c_0024,ax
		call	sub_a_0820
		test	byte ptr data_c_0078[di],0Fh
		jz	loc_a_121C		; Jump if zero
		pop	bx
		pop	ax
		push	ax
		push	bx
		test	cl,cl
		jz	loc_a_1204		; Jump if zero
		and	bl,0FCh
		cmp	cl,0
		jl	loc_a_1204		; Jump if <
		or	bl,3
loc_a_1204:
		test	ch,ch
		jz	loc_a_1216		; Jump if zero
		mov	bh,ah
		add	bh,ah
		add	bh,ah
		cmp	ch,0
		jl	loc_a_1216		; Jump if <
		add	bh,2
loc_a_1216:
		mov	data_c_0024,ax
		call	sub_a_0820
loc_a_121C:
		mov	data_c_0028,bx
		mov	bp,di
		mov	ax,bx
		call	sub_a_124B
		pop	ax
		pop	cx
		call	sub_a_124B
		mov	di,bp
		test	byte ptr data_c_0078[di],20h	; ' '
		jnz	loc_a_1244		; Jump if not zero
		mov	ax,data_c_0024
		cmp	ax,data_c_0016
		je	loc_a_1244		; Jump if equal
		cmp	ax,data_c_0008
		jne	loc_ret_a_124A		; Jump if not equal
loc_a_1244:
		call	sub_a_1589
		jmp	short loc_ret_a_124A
		db	90h

loc_ret_a_124A:
		retn
sub_a_1170	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_124B	proc	near
		mov	si,d_8F06_03F8_e
		shr	al,1			; Shift w/zeros fill
		jnc	loc_a_1255		; Jump if carry=0
		add	si,0Ch
loc_a_1255:
		dec	al
		mov	dl,al
		xchg	ah,al
		mov	dh,50h			; 'P'
		imul	dh			; ax = reg * al
		sub	dh,dh
		add	ax,dx
		add	ax,2D8h
		mov	di,ax

;==== External Entry into Subroutine ======================================

sub_a_1268:
		push	ds
		mov	ax,word ptr ds:[45Fh]
		mov	ds,ax
		mov	ax,[si]
		xor	es:[di],ax
		mov	al,[si+2]
		xor	es:[di+2],al
		mov	ax,[si+3]
		xor	es:[di+50h],ax
		mov	al,[si+5]
		xor	es:[di+52h],al
		add	di,offset data_a_1FB0
		mov	ax,[si+6]
		xor	es:[di],ax
		mov	al,[si+8]
		xor	es:[di+2],al
		mov	ax,[si+9]
		xor	es:[di+50h],ax
		mov	al,[si+0Bh]
		xor	es:[di+52h],al
		pop	ds
		retn
sub_a_124B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_12A9	proc	near
		mov	ax,data_c_0000
		test	ax,ax
		jz	loc_a_12DB		; Jump if zero
		push	ax
		dec	ah
		mov	byte ptr data_c_0000+1,ah
		call	sub_a_131D
		pop	ax
		mov	si,data_c_0006
		call	sub_a_1920
		mov	ax,32h
		mov	dh,byte ptr data_c_0000+1
		shr	dh,1			; Shift w/zeros fill
		shr	dh,1			; Shift w/zeros fill
		mul	dh			; ax = reg * al
		mov	data_c_0438,ax
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		jmp	short loc_ret_a_131C
		db	90h
loc_a_12DB:
		cmp	byte ptr data_c_0453,0
		je	loc_a_12EC		; Jump if equal
		cmp	byte ptr data_c_0454,0
		jne	loc_a_12F6		; Jump if not equal
		jmp	short loc_ret_a_131C
		db	90h
loc_a_12EC:
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		and	al,data_c_0452
		jnz	loc_ret_a_131C		; Jump if not zero
loc_a_12F6:
		and	byte ptr data_c_0454,2
		mov	ax,0Ch
		mov	dl,byte ptr data_c_0028
		and	dl,3
		mul	dl			; ax = reg * al
		add	ax,4BCh
		mov	data_c_0006,ax
		mov	ax,data_c_0024
		mov	data_c_0004,ah
		dec	ah
		mov	data_c_0000,ax
		call	sub_a_131D

loc_ret_a_131C:
		retn
sub_a_12A9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_131D	proc	near
		cmp	ah,0
		jge	loc_a_132B		; Jump if > or =
		mov	data_c_0000,0
		jmp	short loc_ret_a_1371
		db	90h
loc_a_132B:
		mov	si,data_c_0006
		call	sub_a_1920
		cmp	ax,data_c_0008
		jne	loc_a_133E		; Jump if not equal
		call	sub_a_0D8E
		jmp	short loc_ret_a_1371
		db	90h
loc_a_133E:
		cmp	ax,data_c_000E
		jne	loc_a_134A		; Jump if not equal
		call	sub_a_0EE9
		jmp	short loc_ret_a_1371
		db	90h
loc_a_134A:
		cmp	ax,data_c_0016
		jne	loc_a_1356		; Jump if not equal
		call	sub_a_10EC
		jmp	short loc_ret_a_1371
		db	90h
loc_a_1356:
		call	sub_a_0820
		mov	al,20h			; ' '
		and	al,data_c_0078[di]
		jz	loc_a_1367		; Jump if zero
		call	sub_a_0B27
		jmp	short loc_ret_a_1371
		db	90h
loc_a_1367:
		test	byte ptr data_c_0078[di],0Fh
		jz	loc_ret_a_1371		; Jump if zero
		call	sub_a_1372

loc_ret_a_1371:
		retn
sub_a_131D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1372	proc	near
		mov	ax,data_c_0000
		mov	bp,ax
		call	sub_a_0820
		call	sub_a_0F18
		mov	al,data_c_0078[di]
		mov	ah,al
		and	ah,0F0h
		shl	al,1			; Shift w/zeros fill
		and	al,0Fh
		jz	loc_a_1398		; Jump if zero
		or	ah,al
		mov	data_c_0078[di],ah
		call	sub_a_0F18
		jmp	short loc_a_13B2
		db	90h
loc_a_1398:
		and	ah,0E0h
		mov	data_c_0078[di],ah
		sub	dx,dx
		sub	ax,ax
		inc	ax
		call	sub_a_13D0
		cmp	byte ptr data_c_0000+1,12h
		jl	loc_a_13B2		; Jump if <
		dec	data_c_0444
loc_a_13B2:
		mov	ax,bp
		mov	si,data_c_0006
		call	sub_a_1920
		mov	data_c_0000,0
		retn
sub_a_1372	endp

		db	14 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_13D0	proc	near
		test	ax,ax
		jz	loc_a_13F8		; Jump if zero
		add	ds:d_0000_043F_e,al
		cmp	byte ptr ds:d_0000_043F_e,0Ah
		jl	loc_a_13E6		; Jump if <
		sub	byte ptr ds:d_0000_043F_e,0Ah
		inc	ah
loc_a_13E6:
		add	ds:d_0000_043E_e,ah
		cmp	byte ptr ds:d_0000_043E_e,0Ah
		jl	loc_a_13F8		; Jump if <
		sub	byte ptr ds:d_0000_043E_e,0Ah
		inc	dl
loc_a_13F8:
		test	dx,dx
		jz	loc_a_143E		; Jump if zero
		add	ds:d_0000_043D_e,dl
		cmp	byte ptr ds:d_0000_043D_e,0Ah
		jl	loc_a_140E		; Jump if <
		sub	byte ptr ds:d_0000_043D_e,0Ah
		inc	dh
loc_a_140E:
		add	ds:d_0000_043C_e,dh
		cmp	byte ptr ds:d_0000_043C_e,0Ah
		jl	loc_a_143E		; Jump if <
		sub	byte ptr ds:d_0000_043C_e,0Ah
		inc	byte ptr ds:d_0000_043B_e
		cmp	byte ptr ds:d_0000_043B_e,0Ah
		jl	loc_a_143E		; Jump if <
		sub	byte ptr ds:d_0000_043B_e,0Ah
		inc	byte ptr ds:d_0000_043A_e
		cmp	byte ptr ds:d_0000_043A_e,0Ah
		jl	loc_a_143E		; Jump if <
		sub	byte ptr ds:d_0000_043A_e,0Ah
loc_a_143E:
		mov	di,ds:d_0000_0463_e
		mov	al,ds:d_0000_043A_e
		call	sub_a_1AD3
		mov	al,ds:d_0000_043B_e
		call	sub_a_1AD3
		mov	al,ds:d_0000_043C_e
		call	sub_a_1AD3
		mov	al,ds:d_0000_043D_e
		call	sub_a_1AD3
		mov	al,ds:d_0000_043E_e
		call	sub_a_1AD3
		mov	al,ds:d_0000_043F_e
		call	sub_a_1AD3
		cmp	byte ptr ds:d_0000_043C_e,5
		jne	loc_a_1477		; Jump if not equal
		mov	si,ds:d_0000_0465_e
		mov	al,[si+0Bh]
		mov	ds:d_0000_0019_e,al
loc_a_1477:
		mov	ah,ds:d_0000_043B_e
		mov	al,ds:d_0000_043C_e
		cmp	ax,ds:d_0000_0442_e
		jne	loc_a_14B7		; Jump if not equal
		add	al,2
		cmp	al,0Ah
		jl	loc_a_148E		; Jump if <
		sub	al,al
		inc	ah
loc_a_148E:
		inc	ah
		cmp	ah,0Ah
		jl	loc_a_1497		; Jump if <
		sub	ah,ah
loc_a_1497:
		mov	ds:d_0000_0442_e,ax
		mov	cl,ds:d_0000_044A_e
		cmp	cl,6
		je	loc_a_14B7		; Jump if equal
		mov	ah,cl
		shl	ah,1			; Shift w/zeros fill
		shl	ah,1			; Shift w/zeros fill
		add	ah,ds:d_0000_0462_e
		mov	al,ds:d_0000_0461_e
		call	sub_a_124B
		inc	byte ptr ds:d_0000_044A_e
loc_a_14B7:
		mov	ah,ds:d_0000_043A_e
		mov	al,ds:d_0000_043B_e
		cmp	ax,ds:d_0000_0440_e
		je	loc_a_14C7		; Jump if equal
		jmp	loc_ret_a_1588
loc_a_14C7:
		push	ax
		sub	byte ptr ds:d_0000_044C_e,1
		jg	loc_a_14E3		; Jump if >
		mov	byte ptr ds:d_0000_044C_e,2Dh	; '-'
		cmp	byte ptr ds:d_0000_0450_e,2
		jle	loc_a_14E3		; Jump if < or =
		dec	byte ptr ds:d_0000_0450_e
		dec	byte ptr ds:d_0000_0450_e
loc_a_14E3:
		inc	al
		cmp	al,0Ah
		jne	loc_a_14F4		; Jump if not equal
		sub	al,al
		inc	ah
		cmp	ah,0Ah
		jne	loc_a_14F4		; Jump if not equal
		sub	ah,ah
loc_a_14F4:
		mov	ds:d_0000_0440_e,ax
		pop	ax
		cmp	ax,2
		jne	loc_a_1511		; Jump if not equal
		mov	word ptr ds:d_0000_0446_e,9
		mov	si,ds:d_0000_0465_e
		mov	cx,[si+8]
		mov	ds:d_0000_0012_e,cx
		jmp	short loc_ret_a_1588
		db	90h
loc_a_1511:
		cmp	ax,4
		je	loc_ret_a_1588		; Jump if equal
		cmp	ax,6
		jne	loc_a_1531		; Jump if not equal
		mov	si,ds:d_0000_0465_e
		mov	cl,[si+5]
		mov	ds:d_0000_000B_e,cl
		mov	ax,0FFh
		div	cl			; al, ah rem = ax/reg
		mov	ds:d_0000_0451_e,al
		jmp	short loc_ret_a_1588
		db	90h
loc_a_1531:
		cmp	ax,8
		je	loc_a_153B		; Jump if equal
		cmp	ax,100h
		jne	loc_a_1542		; Jump if not equal
loc_a_153B:
		inc	byte ptr ds:d_0000_001E_e
		jmp	short loc_ret_a_1588
		db	90h
loc_a_1542:
		cmp	ax,102h
		jne	loc_a_1554		; Jump if not equal
		inc	byte ptr ds:d_0000_001E_e
		mov	word ptr ds:d_0000_0446_e,0Fh
		jmp	short loc_ret_a_1588
		db	90h
loc_a_1554:
		cmp	ax,104h
		je	loc_a_155E		; Jump if equal
		cmp	ax,106h
		jne	loc_a_1569		; Jump if not equal
loc_a_155E:
		inc	byte ptr ds:d_0000_001E_e
		inc	word ptr ds:d_0000_0446_e
		jmp	short loc_ret_a_1588
		db	90h
loc_a_1569:
		cmp	ax,806h
		jne	loc_a_157A		; Jump if not equal
		mov	byte ptr ds:d_0000_001E_e,12h
		inc	word ptr ds:d_0000_0446_e
		jmp	short loc_ret_a_1588
		db	90h
loc_a_157A:
		mov	dx,ax
;*		and	dx,1
		db	 81h,0E2h, 01h, 00h	;  Fixup - byte match
;*		xor	dx,1
		db	 81h,0F2h, 01h, 00h	;  Fixup - byte match
		add	ds:d_0000_0446_e,dx

loc_ret_a_1588:
		retn
sub_a_13D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1589	proc	near
		cmp	byte ptr data_c_0493,0
		jne	loc_a_1594		; Jump if not equal
		mov	al,4Fh			; 'O'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Fh, speaker on
loc_a_1594:
		mov	ax,3A98h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		sub	cx,cx
loc_a_159F:
		and	ax,0FFFFh
		and	ax,0FFFFh
		dec	cx
		jnz	loc_a_159F		; Jump if not zero
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		mov	data_c_0438,0
		mov	cx,1
loc_a_15B5:
		mov	ax,cx
		call	sub_a_0820
		test	byte ptr data_c_0078[di],1Eh
		jz	loc_a_1612		; Jump if zero
		sub	dx,dx
		mov	ax,5
		push	cx
		push	di
		call	sub_a_13D0
		pop	di
		pop	cx
		mov	bp,cx
		call	sub_a_0F18
		and	byte ptr data_c_0078[di],0E0h
		or	byte ptr data_c_0078[di],1
		call	sub_a_0F18
		cmp	byte ptr data_c_0493,0
		jne	loc_a_15EA		; Jump if not equal
		mov	al,4Fh			; 'O'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Fh, speaker on
loc_a_15EA:
		mov	ax,1388h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	ax,1770h
loc_a_15F6:
		dec	ax
		jnz	loc_a_15F6		; Jump if not zero
		mov	ax,4E20h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		xchg	ah,al
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	ax,1770h
loc_a_1605:
		dec	ax
		jnz	loc_a_1605		; Jump if not zero
		mov	al,4Ch			; 'L'
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 4Ch, enable keyboard
		mov	ax,2EE0h
loc_a_160F:
		dec	ax
		jnz	loc_a_160F		; Jump if not zero
loc_a_1612:
		inc	cl
		cmp	cl,1Fh
		jne	loc_a_15B5		; Jump if not equal
		inc	ch
		mov	cl,1
		cmp	ch,1Dh
		jne	loc_a_15B5		; Jump if not equal
		cmp	byte ptr data_c_044A,0
		jg	loc_a_1641		; Jump if >
		mov	ds,data_c_045B
		assume	ds:seg_b
		cmp	byte ptr data_b_044A,0
		mov	ds,data_b_045B		; 2nd data segment
		jle	loc_a_1641		; Jump if < or =
		call	sub_a_1A54
		call	sub_a_1A6C
		call	sub_a_16F8
loc_a_1641:
		assume	ds:seg_c
		mov	ds,data_c_045B
		assume	ds:seg_b
		cmp	byte ptr data_b_044A,0
		jle	loc_a_1652		; Jump if < or =
		call	sub_a_0620
		jmp	short loc_ret_a_1666
		db	90h
loc_a_1652:
		mov	ds,data_b_045B		; 2nd data segment
		assume	ds:seg_c
		cmp	byte ptr data_c_044A,0
		jle	loc_a_1663		; Jump if < or =
		call	sub_a_0620
		jmp	short loc_ret_a_1666
		db	90h
loc_a_1663:
		call	sub_a_1667

loc_ret_a_1666:
		retn
sub_a_1589	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1667	proc	near
		call	sub_a_1A54
		call	sub_a_16F8
loc_a_166D:
		mov	di,24h
		mov	al,1Eh
		call	sub_a_1AD3
		call	sub_a_1AD3
		call	sub_a_1A54
		cmp	byte ptr data_c_0490,0
		je	loc_a_168C		; Jump if equal
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		xor	al,0F0h
		and	al,0F0h
		jnz	loc_a_1699		; Jump if not zero
loc_a_168C:
		mov	di,213Ch		; jump table of init screen
		mov	dl,0
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		cmp	ax,20h
		jne	loc_a_166D		; Jump if not equal
loc_a_1699:
		mov	ds,data_c_045D
		call	sub_a_051D
		retn
sub_a_1667	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_16A1	proc	near
		mov	ax,data_c_0072
		test	ax,ax
		jz	loc_a_16AF		; Jump if zero
		mov	si,data_c_0076
		call	sub_a_1979
loc_a_16AF:
		mov	ax,data_c_0000
		mov	data_c_0072,ax
		mov	si,56Ch
		mov	data_c_0076,si
		call	sub_a_1979
		retn
sub_a_16A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_16C0	proc	near
		mov	ax,data_c_0072
		test	ax,ax
		jz	loc_ret_a_16F7		; Jump if zero
		dec	data_c_0074
		jnz	loc_ret_a_16F7		; Jump if not zero
		mov	cl,data_c_0075
		mov	data_c_0074,cl
		mov	si,data_c_0076
		push	si
		add	si,20h
		cmp	si,5ECh
		je	loc_a_16ED		; Jump if equal
		mov	data_c_0076,si
		call	sub_a_1979
		jmp	short loc_a_16F3
		db	90h
loc_a_16ED:
		mov	data_c_0072,0
loc_a_16F3:
		pop	si
		call	sub_a_1979

loc_ret_a_16F7:
		retn
sub_a_16C0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_16F8	proc	near
		sub	cx,cx

locloop_a_16FA:
		loop	locloop_a_16FA		; Loop if cx > 0

		push	es
		mov	es,data_c_045F
		mov	di,offset data_d_0333
		mov	byte ptr es:[di],5Fh	; '_'
		inc	di
		mov	al,20h			; ' '
		mov	cx,10h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	di,data_c_048B
		add	di,offset data_c_00E7
		call	sub_a_1906
		pop	es
		jg	loc_a_172F		; Jump if >
		mov	si,offset data_a_18E8
		call	sub_a_0855		; Play melody
		sub	cx,cx

locloop_a_1726:
		loop	locloop_a_1726		; Loop if cx > 0


locloop_a_1728:
		loop	locloop_a_1728		; Loop if cx > 0


locloop_a_172A:
		loop	locloop_a_172A		; Loop if cx > 0

		jmp	loc_ret_a_1873
loc_a_172F:
		mov	si,offset data_a_18BA
		call	sub_a_0855		; Play melody
		sub	cx,cx
		mov	di,333h
		mov	dl,1
loc_a_173C:
		push	cx
		push	di
		push	ds
		test	dl,dl
		jz	loc_a_1767		; Jump if zero
		mov	di,d_B800_0F0A_e
		mov	ah,24h			; '$'
		sub	al,al
loc_a_174A:
		mov	cx,3Ch
		push	di
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		add	di,d_B800_1FC4_e
		mov	cx,3Ch
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		pop	di
		add	di,50h
		dec	ah
		jnz	loc_a_174A		; Jump if not zero
		mov	si,data_c_1874_e
		call	sub_a_1A25
loc_a_1767:
		mov	ds,data_c_045F
		mov	si,333h
		mov	dx,130Ch
		mov	cx,10h
		call	sub_a_1A3B
		pop	ds
		mov	di,213Ch		; jump table of init screen
		mov	dl,0
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		pop	di
		pop	cx
		push	ds
		mov	ds,data_c_045F
		test	ah,ah
		jnz	loc_a_17AF		; Jump if not zero
		cmp	al,20h			; ' '
		jl	loc_a_179F		; Jump if <
		cmp	al,7Fh
		jg	loc_a_179F		; Jump if >
		cmp	cx,10h
		je	loc_a_179F		; Jump if equal
		mov	[di],al
		inc	di
		inc	cx
		mov	byte ptr [di],5Fh	; '_'
loc_a_179F:
		cmp	al,8
		jne	loc_a_17AF		; Jump if not equal
		test	cx,cx
		jz	loc_a_17AF		; Jump if zero
		mov	byte ptr [di],20h	; ' '
		dec	di
		dec	cx
		mov	byte ptr [di],5Fh	; '_'
loc_a_17AF:
		pop	ds
		test	dl,dl
		jnz	loc_a_17B9		; Jump if not zero
		cmp	ax,0Dh
		je	loc_a_17BB		; Jump if equal
loc_a_17B9:
		jmp	short loc_a_173C
loc_a_17BB:
		test	cx,cx
		jnz	loc_a_17C2		; Jump if not zero
		jmp	loc_a_1870
loc_a_17C2:
		push	es
		mov	es,data_c_045F
		mov	byte ptr es:[di],20h	; ' '
		mov	di,data_c_048B
		add	di,offset data_c_00E7
loc_a_17D3:
		sub	di,17h
		call	sub_a_1906
		jg	loc_a_17D3		; Jump if >
		mov	cx,data_c_048B
		add	cx,0D0h
		sub	cx,di
		mov	di,data_c_048B
		mov	si,di
		add	di,offset data_d_00EC	; ('           ')
		add	si,offset data_d_00D5	; ('           ')
		push	ds
		push	es
		pop	ds
		std				; Set direction flag
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,16h
		mov	si,offset data_d_0333
		cld				; Clear direction
		mov	cx,11h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		mov	si,offset data_c_043A
		mov	cx,6
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	dx,data_c_048B
		mov	ah,data_c_048F
		push	ds
		mov	ds,data_c_045F
		assume	ds:seg_d
		mov	data_d_003C,ah		; TOPTEN 7th character
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx
		mov	dx,offset data_d_0035	; TOPTEN filename
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh
						;  open file, FCB @ ds:dx
		cmp	al,0FFh
		jne	loc_a_1838		; Jump if not equal
		mov	ah,16h
		int	21h			; DOS Services  ah=function 16h
						;  creat/truncat file FCB @ds:dx
		sub	ah,ah
		push	ax
		jmp	short loc_a_1846
		db	90h
loc_a_1838:
		mov	ax,data_d_0047		; TOPTEN file size HIGH
		test	ax,ax
		jnz	loc_a_1845		; Jump if not zero
		mov	ax,data_d_0045		; TOPTEN file size LOW
		sub	ax,0EDh
loc_a_1845:
		push	ax
loc_a_1846:
		pop	ax
		test	ax,ax
		jnz	loc_a_185E		; Jump if not zero
		mov	data_d_0043,0EDh	; TOPTEN record size = 237
		mov	byte ptr data_d_0055,0	; TOPTEN current record
		mov	ah,15h
		int	21h			; DOS Services  ah=function 15h
						;  sequent file write FCB @ds:dx
						;   returns al=0 ok, not 0=error
		mov	ah,10h
		int	21h			; DOS Services  ah=function 10h
						;  close file, FCB @ ds:dx
loc_a_185E:
		pop	ds
		pop	es
		call	sub_a_2A10
		mov	byte ptr ds:d_0000_0458_e,1
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		mov	byte ptr ds:d_0000_0458_e,0
loc_a_1870:
		call	sub_a_06D1

loc_ret_a_1873:
		retn
sub_a_16F8	endp

			                        ;* No entry point to code
		adc	[bp+di],cx
		or	ax,6F59h
		jnz	loc_a_18ED		; Jump if not zero
		and	[bp+di+63h],dl
		outsw				; Out [si] to port dx
;*		jc	loc_a_18E6		;*Jump if carry Set
		db	 72h, 65h		;  Fixup - byte match
		and	[bx+di+73h],ch
		and	[bx+6Eh],ch
		db	 65h, 0Fh, 0Ch, 0Fh
		db	'of the TOP TEN!'
		db	 1Ch, 06h, 11h
		db	'Type your name, press Enter:'
		db	0
data_a_18BA	db	40h
		db	 1Fh, 32h, 00h, 01h, 00h, 0Ah
		db	 00h, 40h, 1Fh, 32h, 00h, 01h
		db	 00h, 0Ah, 00h, 40h, 1Fh, 32h
		db	 00h, 01h, 00h, 0Ah, 00h,0C4h
		db	 09h, 32h, 00h, 01h, 00h, 4Bh
		db	 00h, 40h, 1Fh, 32h, 00h, 01h
		db	 00h, 0Ah, 00h,0C4h, 09h, 64h
		db	 00h
		db	0, 0
data_a_18E8	db	40h
		db	 1Fh, 32h, 00h, 01h
loc_a_18ED:
		add	[bp+si],cl
		add	[bx+si+1Fh],al
		xor	al,[bx+si]
		add	[bx+si],ax
		or	al,[bx+si]
		inc	ax
		pop	ds
		xor	al,[bx+si]
		add	[bx+si],ax
		or	al,[bx+si]
		clc				; Clear carry flag
;*		sub	ah,[si+0]
		db	 2Ah, 64h, 00h		;  Fixup - byte match
		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1906	proc	near
		push	di
		mov	si,offset data_c_043A
		mov	cx,6
		repe	cmpsb			; Rep zf=1+cx >0 Cmp [si] to es:[di]
		pop	di
		retn
sub_a_1906	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1920	proc	near
		push	ax
		mov	dl,al
		xchg	ah,al
		mov	dh,0F0h
		mul	dh			; ax = reg * al
		shl	dl,1			; Shift w/zeros fill
		sub	dh,dh
		add	ax,dx
		add	ax,2D8h
		mov	di,ax
		pop	ax

;==== External Entry into Subroutine ======================================

sub_a_1935:
		push	ax
		push	ds
		mov	ax,word ptr ds:[45Fh]
		mov	ds,ax
		push	di
		mov	ax,[si]
		xor	es:[di],ax
		inc	si
		inc	si
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		inc	si
		inc	si
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		inc	si
		inc	si
		pop	di
		add	di,2000h
		mov	ax,[si]
		xor	es:[di],ax
		inc	si
		inc	si
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		inc	si
		inc	si
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		pop	ds
		pop	ax
		retn
sub_a_1920	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1979	proc	near
		push	ax
		mov	dl,al
		xchg	ah,al
		mov	dh,0F0h
		mul	dh			; ax = reg * al
		shl	dl,1			; Shift w/zeros fill
		sub	dh,dh
		add	ax,dx
		add	ax,2D7h
		mov	di,ax
		pop	ax

;==== External Entry into Subroutine ======================================

sub_a_198E:
		push	ax
		push	ds
		mov	ax,word ptr ds:[45Fh]
		mov	ds,ax
		push	di
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		pop	di
		add	di,offset data_a_1FB0
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		add	si,4
		add	di,50h
		mov	ax,[si]
		xor	es:[di],ax
		mov	ax,[si+2]
		xor	es:[di+2],ax
		pop	ds
		pop	ax
		retn
sub_a_1979	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A25	proc	near
		push	ds
		push	cs
		pop	ds
loc_a_1A28:
		sub	ch,ch
		lodsb				; String [si] to al
		mov	cl,al
		test	cl,cl
		jz	loc_a_1A39		; Jump if zero
		lodsw				; String [si] to ax
		mov	dx,ax
		call	sub_a_1A3B
		jmp	short loc_a_1A28
loc_a_1A39:
		pop	ds
		retn
sub_a_1A25	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A3B	proc	near

locloop_a_1A3B:
		push	dx
		push	cx
		mov	ah,2
		sub	bh,bh
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		lodsb				; String [si] to al
		mov	cx,1
		mov	bl,3
		mov	ah,9
		int	10h			; Video display   ah=functn 09h
						;  set char al & attrib bl @curs
						;   cx=# of chars to replicate
		pop	cx
		pop	dx
		inc	dl
		loop	locloop_a_1A3B		; Loop if cx > 0

		retn
sub_a_1A3B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A54	proc	near
		mov	di,924h
		mov	si,offset data_a_1A62
		mov	cx,0Ah
		nop
		call	sub_a_1AC6
		retn
sub_a_1A54	endp

data_a_1A62	db	0Fh
		db	 0Ah, 12h, 0Eh, 1Eh, 14h, 18h
		db	 0Eh, 16h, 1Ah

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A6C	proc	near
		mov	di,0BA8h
		mov	si,offset data_a_1A80
		mov	cx,7
		nop
		call	sub_a_1AC6
		assume	ds:seg_c
		mov	al,data_c_0492
		call	sub_a_1AD3
		retn
sub_a_1A6C	endp

data_a_1A80	db	15h
		db	 11h, 0Ah, 19h, 0Eh, 16h, 1Eh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A87	proc	near
		mov	di,0A16h
		mov	si,offset data_a_1A95
		mov	cx,9
		nop
		call	sub_a_1AC6
		retn
sub_a_1A87	endp

data_a_1A95	db	0Ch
		db	 0Eh, 13h, 17h, 10h, 15h, 0Eh
		db	 0Dh, 0Eh

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1A9E	proc	near
		mov	di,19h
		mov	si,offset data_a_1AAC
		mov	cx,7
		nop
		call	sub_a_1AC6
		retn
sub_a_1A9E	endp

data_a_1AAC	db	17h
		db	 14h, 15h, 1Eh, 17h, 0Eh, 13h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1AB3	proc	near
		mov	di,29Eh
		mov	si,offset data_a_1AC1
		mov	cx,5
		nop
		call	sub_a_1AC6
		retn
sub_a_1AB3	endp

data_a_1AC1	db	10h
		db	 1Eh, 0Bh, 1Eh, 12h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1AC6	proc	near
		push	ds
		push	cs
		pop	ds

locloop_a_1AC9:
		lodsb				; String [si] to al
		push	cx
		call	sub_a_1AD3
		pop	cx
		loop	locloop_a_1AC9		; Loop if cx > 0

		pop	ds
		retn
sub_a_1AC6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1AD3	proc	near
		push	ax
		push	si
		push	ds
		push	bp
		mov	bp,0AAAAh
		push	cs
		pop	ds
		mov	si,offset data_a_1B2D
		mov	cl,20h			; ' '
		mul	cl			; ax = reg * al
		add	si,ax
		push	di
		mov	cx,8

locloop_a_1AE9:
		call	sub_a_1B1C
		xchg	ah,al
		mov	es:[di],ax
		call	sub_a_1B1C
		xchg	ah,al
		mov	es:[di+2],ax
		call	sub_a_1B1C
		xchg	ah,al
		mov	word ptr es:[2000h][di],ax
		call	sub_a_1B1C
		xchg	ah,al
		mov	word ptr es:[2002h][di],ax
		add	di,50h
		loop	locloop_a_1AE9		; Loop if cx > 0

		pop	di
		add	di,4
		pop	bp
		pop	ds
		pop	si
		pop	ax
		retn
sub_a_1AD3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_1B1C	proc	near
		lodsb				; String [si] to al
		mov	dx,8000h
loc_a_1B20:
		shr	al,1			; Shift w/zeros fill
		rcr	dx,1			; Rotate thru carry
		sar	dx,1			; Shift w/sign fill
		jnc	loc_a_1B20		; Jump if carry=0
		mov	ax,dx
		and	ax,bp
		retn
sub_a_1B1C	endp

data_a_1B2D	db	1Fh
		db	0E0h, 3Fh,0F0h, 78h, 78h,0F0h
		db	 3Ch,0E0h, 1Ch,0E0h, 1Ch,0E0h
		db	 1Ch,0E0h, 1Ch,0E0h, 1Ch,0E0h
		db	 1Ch,0F0h, 3Ch, 78h, 78h, 3Fh
		db	0F0h, 1Fh,0E0h, 00h, 00h, 00h
		db	 00h, 07h, 00h, 0Fh, 00h, 1Fh
		db	 00h, 3Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h,0FFh,0F0h,0FFh,0F0h, 00h
		db	 00h, 00h, 00h, 3Fh,0C0h, 7Fh
		db	0E0h,0F0h,0F0h,0E0h,0F0h, 00h
		db	0F0h, 01h,0E0h, 07h,0C0h, 0Fh
		db	 80h, 3Eh, 00h, 78h, 00h,0F0h
		db	 70h,0F0h,0F0h,0FFh,0F0h,0FFh
		db	0F0h, 00h, 00h, 00h, 00h, 3Fh
		db	0C0h, 7Fh,0E0h,0F0h,0F0h,0E0h
		db	0F0h, 00h,0F0h, 01h,0E0h, 0Fh
		db	0C0h, 0Fh,0C0h, 01h,0E0h, 00h
		db	0F0h,0E0h,0F0h,0F0h,0F0h, 7Fh
		db	0E0h, 3Fh,0C0h, 00h, 00h, 00h
		db	 00h, 03h,0F0h, 07h,0F0h, 0Fh
		db	0F0h, 1Fh,0F0h, 3Ch,0F0h, 78h
		db	0F0h,0F0h,0F0h,0F0h,0F0h,0FFh
		db	0FCh,0FFh,0FCh, 00h,0F0h, 00h
		db	0F0h, 03h,0FCh, 03h,0FCh, 00h
		db	 00h, 00h, 00h,0FFh,0F0h,0FFh
		db	0F0h,0F0h, 00h,0F0h, 00h,0FFh
		db	0C0h,0FFh,0E0h, 00h,0F0h, 00h
		db	0F0h, 00h,0F0h, 00h,0F0h,0F0h
		db	0F0h,0F0h,0F0h, 7Fh,0E0h
loc_a_1BE7:
		aas				; Ascii adjust
		rol	byte ptr [bx+si],0	; Rotate
		add	[bx+si],al
		pop	ds
		sar	byte ptr [bx],0C0h	; Shift w/sign fill
		js	$+2			; delay for I/O
;*                         lock	add	al,dh
		db	0F0h, 00h,0F0h		;  Fixup - byte match
;*		add	al,dh
		db	 00h,0F0h		;  Fixup - byte match
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		sar	bh,0E0h			; Shift w/sign fill
		stc				; Set carry flag

		;  lock	stc				; Set carry flag
		db	0f0h, 0f0h, 0f0h, 0f0h, 0f0h, 0f9h

 		; lock	jg	loc_a_1BE7		; Jump if >
		db	0f0h, 7fh, 0e0h

		aas				; Ascii adjust
		rol	byte ptr [bx+si],0	; Rotate
		add	[bx+si],al
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*                         lock	add	al,dh
		db	0F0h,0F0h,0F0h,0F0h, 00h,0F0h	;  Fixup - byte match
;*		add	ax,si
		db	 01h,0F0h		;  Fixup - byte match
loc_a_1C19:
		add	sp,ax
		pop	es
		ror	byte ptr [bx],80h	; Rotate
loc_a_1C1F:
		pop	ds
		add	ds:d_0000_1E00_e,bl
		add	ds:d_0000_1E00_e,bl
		db	 00h, 00h, 00h, 00h, 00h, 1Fh
		db	 80h, 3Fh,0C0h, 79h,0E0h,0F0h
		db	0F0h,0F0h,0F0h, 79h,0E0h
loc_a_1C39:
		aas				; Ascii adjust
		sar	byte ptr [bx],0C0h	; Shift w/sign fill
		jns	loc_a_1C1F		; Jump if not sign
;*                         lock	jns	loc_a_1C25		;*Jump if not sign
		db	0F0h,0F0h,0F0h,0F0h, 79h,0E0h	;  Fixup - byte match
		aas				; Ascii adjust
		rcr	byte ptr [bx],80h	; Rotate thru carry
		db	 00h, 00h, 00h, 00h, 1Fh, 80h
		db	 3Fh,0C0h, 79h,0E0h,0F0h,0F0h
		db	0F0h,0F0h, 79h,0E0h, 3Fh,0F0h
		db	 1Fh,0F0h, 00h,0F0h, 00h,0F0h
		db	 01h,0E0h, 03h,0C0h, 3Fh, 80h
		db	 3Fh, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 00h, 1Fh, 80h, 3Fh,0C0h
		db	 79h,0E0h
		db	8 dup (0F0h)
		db	0FFh,0F0h,0FFh,0F0h
		db	8 dup (0F0h)
		db	 00h, 00h, 00h, 00h,0FFh,0E0h
		db	0FFh,0F0h
		db	'<x<<<<<x?'
		db	0F0h, 3Fh,0F0h
		db	'<x<<<<<x'
		db	0FFh,0F0h,0FFh,0E0h, 00h, 00h
		db	 00h, 00h, 0Fh,0E0h, 1Eh,0F0h
		db	 3Ch, 78h, 78h, 3Ch,0F0h, 00h
		db	0F0h, 00h,0F0h, 00h,0F0h, 00h
		db	0F0h, 00h,0F0h, 00h, 78h, 3Ch
		db	 3Ch, 78h, 1Eh,0F0h, 0Fh,0E0h
		db	 00h, 00h, 00h, 00h,0FFh,0C0h
		db	0FFh,0E0h, 3Ch,0F0h
		db	 3Ch, 78h
		db	13 dup (3Ch)
		db	 78h, 3Ch,0F0h,0FFh,0E0h,0FFh
		db	0C0h, 00h, 00h, 00h, 00h,0FFh
		db	0FCh,0FFh,0FCh, 3Ch, 0Ch, 3Ch
		db	 00h, 3Ch, 00h, 3Ch,0C0h, 3Fh
		db	0C0h, 3Fh,0C0h, 3Ch,0C0h, 3Ch
		db	 00h, 3Ch, 00h, 3Ch, 0Ch,0FFh
		db	0FCh,0FFh,0FCh, 00h, 00h, 00h
		db	 00h, 0Fh,0E0h, 1Eh,0F0h, 3Ch
		db	 78h, 78h, 3Ch,0F0h, 00h,0F0h
		db	 00h,0F0h, 00h,0F0h, 00h,0F0h
		db	0FCh,0F0h,0FCh, 78h, 3Ch, 3Ch
		db	 3Ch, 1Eh,0FCh, 0Fh,0FCh, 00h
		db	 00h, 00h, 00h, 3Fh,0C0h, 3Fh
		db	0C0h, 0Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 3Fh,0C0h, 3Fh
		db	0C0h, 00h, 00h, 00h, 00h,0FFh
		db	 00h,0FFh, 00h, 3Ch, 00h, 3Ch
		db	 00h, 3Ch, 00h, 3Ch, 00h, 3Ch
		db	 00h, 3Ch, 00h, 3Ch, 00h, 3Ch
		db	 0Ch, 3Ch, 1Ch, 3Ch, 3Ch,0FFh
		db	0FCh,0FFh,0FCh, 00h, 00h, 00h
		db	 00h,0E0h, 1Ch,0F0h, 3Ch,0F8h
		db	 7Ch,0FCh,0FCh,0FCh,0FCh,0FFh
		db	0FCh,0FFh,0FCh,0F7h,0BCh,0F3h
		db	 3Ch,0F3h, 3Ch,0F0h, 3Ch,0F0h
		db	 3Ch,0F0h, 3Ch,0F0h, 3Ch, 00h
		db	 00h, 00h, 00h,0F0h, 3Ch,0F0h
		db	 3Ch,0F8h, 3Ch,0FCh, 3Ch,0FEh
		db	 3Ch,0FFh, 3Ch,0F7h,0BCh,0F3h
		db	0FCh,0F1h,0FCh,0F0h,0FCh,0F0h
		db	 7Ch,0F0h, 3Ch,0F0h, 3Ch,0F0h
		db	 3Ch, 00h, 00h, 00h, 00h, 0Fh
		db	0C0h, 1Fh,0E0h, 3Ch,0F0h, 78h
		db	 78h,0F0h, 3Ch,0F0h, 3Ch,0F0h
		db	 3Ch,0F0h, 3Ch,0F0h, 3Ch,0F0h
		db	 3Ch, 78h, 78h, 3Ch,0F0h, 1Fh
		db	0E0h, 0Fh,0C0h, 00h, 00h, 00h
		db	 00h,0FFh,0E0h,0FFh,0F0h
		db	'<x<<<<<x?'
		db	0F0h, 3Fh,0E0h, 3Ch, 00h, 3Ch
		db	 00h, 3Ch, 00h, 3Ch, 00h,0FFh
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h,0FFh,0E0h,0FFh,0F0h
		db	'<x<<<<<x?'
		db	0F0h, 3Fh,0E0h, 3Dh,0E0h, 3Ch
		db	0F0h, 3Ch, 78h, 3Ch, 3Ch,0FCh
		db	 3Ch,0FCh, 3Ch, 00h, 00h, 00h
		db	 00h,0FFh,0F0h,0FFh,0F0h,0CFh
		db	 30h,0CFh, 30h, 0Fh
data_a_1E16	dw	0F00h
		db	 00h, 0Fh

locloop_a_1E1A:
		add	[bx],cl
		add	[bx],cl
		add	[bx],cl
		add	[bx],cl
		add	[bx],cl
		add	[bx],bh
		sar	byte ptr [bx],0C0h	; Shift w/sign fill
		db	 00h, 00h, 00h, 00h,0F0h
		db	17 dup (0F0h)
		db	 79h,0E0h, 3Fh,0C0h, 1Fh, 80h
		db	 0Fh, 00h, 0Fh, 00h, 00h, 00h
		db	 00h, 00h,0F0h
		db	9 dup (0F0h)
		db	 79h,0E0h, 3Fh,0C0h, 1Fh, 80h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 3Fh,0C0h, 3Fh,0C0h
		db	 00h, 00h, 00h, 00h, 03h, 00h
		db	 03h, 00h, 03h, 00h, 03h, 00h
		db	 03h, 00h, 03h, 00h, 03h, 00h
		db	 03h, 00h, 03h, 00h, 03h, 00h
		db	 00h, 00h, 00h, 00h, 03h, 00h
		db	 03h, 00h, 00h, 00h, 00h, 00h
		db	 03h,0C0h, 07h,0C0h, 0Fh,0C0h
		db	 1Fh,0C0h, 3Fh,0C0h, 7Fh,0C0h
		db	0FFh,0FFh,0FFh,0FFh, 7Fh,0C0h
		db	 3Fh,0C0h, 1Fh,0C0h, 0Fh,0C0h
		db	 07h,0C0h, 03h,0C0h, 00h, 00h
		db	 00h, 00h, 03h,0C0h, 03h,0E0h
		db	 03h,0F0h, 03h,0F8h, 03h,0FCh
		db	 03h,0FEh,0FFh,0FFh,0FFh,0FFh
		db	 03h,0FEh, 03h,0FCh, 03h,0F8h
		db	 03h,0F0h, 03h,0E0h, 03h,0C0h
		db	16 dup (0)
		db	0FFh,0FFh,0FFh,0FFh, 00h
		db	50 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

sub_a_1F10	proc	near

		push	di
loc_a_1F11:
		; set numlock ON
		push	ds
		mov	ax,40h
		mov	ds,ax
		or	byte ptr ds:d_0040_0017_e,20h	; ' ' set numlock ON
		pop	ds

		; check keyboard
		mov	ah,0Bh
		int	21h			; DOS Services  ah=function 0Bh
						;  if keybd char available,al=FF
		sub	ah,ah
		push	ax
		test	al,al
		jz	loc_a_1F68		; Jump if zero ... character not ready

		; input from keyboard
		mov	ah,8
		int	21h			; DOS Services  ah=function 08h
						;  get keybd char al, no echo
		sub	ah,ah

		push	di
		push	es
		push	cs
		pop	es

		mov	bx,es:[di]		; pointer to jump table
		inc	di
		inc	di
		mov	cx,es:[di]		; number of entries
		inc	di
		inc	di

		; control key?
		test	al,al
		jnz	loc_a_1F52		; Jump if not zero

		; read second byte
		mov	ah,8
		int	21h			; DOS Services  ah=function 08h
						;  get keybd char al, no echo
		mov	ah,1
		add	di,cx
		mov	bx,es:[di]		; DI+0: pointer to jump table
		inc	di
		inc	di
		mov	cx,es:[di]		; DI+2: number of keys
		inc	di
		inc	di			; DI+4: key codes

loc_a_1F52:
		; search key in jump table
		add	bx,cx
		add	bx,cx
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_a_1F5B		; Jump if not zero
		inc	cx
loc_a_1F5B:
		; go to jump table
		pop	es
		pop	di
		add	sp,2
		push	ax
		shl	cx,1			; Shift w/zeros fill
		sub	bx,cx
		call	word ptr cs:[bx]	;*4 entries

; character from keyboard not ready

loc_a_1F68:
		pop	ax
		mov	dh,dl
		and	dh,2
		jnz	loc_a_1F11		; Jump if not zero, wait for key
		mov	dh,dl
		and	dh,1
		jz	loc_a_1F87		; Jump if zero
		mov	bl,data_c_0458
		and	bl,1
		jnz	loc_a_1F87		; Jump if not zero
		push	ax
		push	dx
		call	sub_a_06D1
		pop	dx
		pop	ax
loc_a_1F87:
		pop	di
		retn
sub_a_1F10	endp

; 1F89h: key 2 down
			                        ;* No entry point to code
		cmp	byte ptr ds:[456h],3	; vertical move speed
		jge	loc_ret_a_1F94		; Jump if > or =
		inc	byte ptr ds:[456h]	; vertical move speed

loc_ret_a_1F94:
		retn

; 1F95h: key 8 up
			                        ;* No entry point to code
		cmp	byte ptr ds:[456h],0FDh	; vertical move speed
		jle	loc_ret_a_1FA0		; Jump if < or =
		dec	byte ptr ds:[456h]	; vertical move speed

loc_ret_a_1FA0:
		retn

; 1FA1h: key 6 right
			                        ;* No entry point to code
		cmp	byte ptr ds:[455h],4	; horizontal move speed
		jge	loc_ret_a_1FAC		; Jump if > or =
		inc	byte ptr ds:[455h]	; horizontal move speed

loc_ret_a_1FAC:
		retn

; 1FADh: Key 4 left

		db	 80h, 3Eh, 55h
data_a_1FB0	db	4
		db	0FCh, 7Eh, 04h,0FEh, 0Eh, 55h
		db	 04h

loc_ret_a_1FB8:
		retn
			                        ;* No entry point to code
		mov	word ptr ds:[455h],0	; horizontal move speed
		retn
			                        ;* No entry point to code
		assume	ds:seg_a
		xor	data_a_0493,1
		mov	ds,word ptr ds:[45Bh]
		xor	byte ptr ds:d_5904_0493_e,1
		mov	ds,ds:d_5904_045B_e
		retn
			                        ;* No entry point to code
		or	byte ptr ds:[454h],2
		retn
			                        ;* No entry point to code
		shr	byte ptr ds:[454h],1	; Shift w/zeros fill
		xor	byte ptr ds:[454h],1
		retn

; 1FE3h: Jump table: Tab (select level)
			                        ;* No entry point to code
		mov	ah,byte ptr data_a_0494	; ('Professiona')
		dec	ah
		cmp	ah,29h			; ')'
		jge	loc_a_2000		; Jump if > or =
		mov	ah,2Eh			; '.'
		jmp	short loc_a_2000
			                        ;* No entry point to code
		nop
		mov	ah,byte ptr data_a_0494	; ('Professiona')
		inc	ah
		cmp	ah,2Eh			; '.'
		jle	loc_a_2000		; Jump if < or =
		mov	ah,29h			; ')'
loc_a_2000:
		mov	byte ptr data_a_0494,ah	; ('Professiona')
		mov	ds,word ptr ds:[45Bh]
		mov	ds:d_5904_0494_e,ah
		mov	ds,ds:d_5904_045B_e
		push	dx
		mov	dx,3D4h
		mov	al,2
		out	dx,al			; port 3D4h, CGA/EGA reg index
						;  al = 2, horz sync position
		inc	dx
		mov	al,ds:d_0000_0494_e
		out	dx,al			; port 3D5h, CGA/EGA indxd data
		pop	dx
		retn
loc_a_201E:
		mov	di,213Ch		; jump table of init screen
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		test	ax,ax
		jz	loc_a_201E		; Jump if zero
		retn
			                        ;* No entry point to code

; 2029h: Jump table: Enter

		mov	ax,data_a_048D
		mov	data_a_048B,ax
		mov	al,byte ptr ds:[458h]
		and	al,2
		jz	loc_a_203C		; Jump if zero
		call	sub_a_291A
		jmp	short loc_ret_a_203F
		db	90h
loc_a_203C:
		and	dl,0FDh

loc_ret_a_203F:
		retn

; 2040h: Jump table: Esc (exit)
			                        ;* No entry point to code
		mov	sp,word ptr ds:[459h]
		jmp	loc_a_0161

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2047	proc	near
		retn
sub_a_2047	endp

			                        ;* No entry point to code
		assume	ds:seg_c
		inc	data_c_0457
		cmp	byte ptr data_c_0457,65h	; 'e'
		jle	loc_a_2058		; Jump if < or =
		mov	byte ptr data_c_0457,61h	; 'a'
loc_a_2058:
		jmp	short loc_a_206B
			                        ;* No entry point to code
		nop
		dec	data_c_0457
		cmp	byte ptr data_c_0457,61h	; 'a'
		jge	loc_a_206B		; Jump if > or =
		mov	byte ptr data_c_0457,65h	; 'e'
loc_a_206B:
		mov	bl,data_c_0457
		sub	bh,bh
		mov	ax,bx
		sub	bl,61h			; 'a'
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	bx,offset data_a_2190
		call	word ptr cs:[bx]	;*
		retn
		db	0BEh,0D5h, 21h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2085	proc	near
		or	al,20h			; ' '
		mov	byte ptr ds:[457h],al
		push	di
		push	dx
		call	sub_a_07E5		; clear video memory, setup palettes
		call	sub_a_1A25
		pop	dx
		pop	di
		or	byte ptr ds:[458h],2
		retn
sub_a_2085	endp

			                        ;* No entry point to code
		mov	si,2365h
		call	sub_a_2085
		push	di
		mov	si,398h
		mov	di,8C4h
		call	sub_a_198E
		mov	si,410h
		mov	di,0B44h
		call	sub_a_198E
		mov	si,450h
		mov	di,0DC5h
		call	sub_a_1935
		mov	si,354h
		mov	di,1045h
		call	sub_a_1935
		mov	si,45Ch
		mov	di,1545h
		call	sub_a_1935
		pop	di
		retn
			                        ;* No entry point to code
		mov	si,24A8h
		call	sub_a_2085
		push	di
		push	dx
		mov	si,3F8h
		mov	di,offset data_a_0465
		call	sub_a_1268
		pop	dx
		pop	di
		retn
			                        ;* No entry point to code
		mov	si,260Dh
		call	sub_a_2085
		retn

;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

; 20EBh: Init screen jump table
;    210ah ... pointer to ASCII jump table
;    11 ... number of keys
;    34h (4 left)
;    36h (6 right)
;    38h (8 up)
;    32h (2 down)
;    35h (5 stop)
;    20h (space)
;    63h (c)
;    43h (C)
;    0Dh (Enter)
;    09h (Tab)
;    1Bh (Esc)

; 20FAh: extended jump table
;    2122h ... pointer to extended keys jump table
;    12 ... number of keys
;    4Bh (4 left)
;    4Dh (6 right)
;    48h (8 up)
;    50h (2 down)
;    0Fh (Tab)
;    3Bh (F1)
;    3Ch (F2)
;    3Dh (F3)
;    3Eh (F4)
;    3Fh (F5)
;    40h (F6)
;    75h

; 210Ah ASCII jump table:
;   1FADh (4 left)
;   1FA1h (6 right)
;   1F95h (8 up)
;   1F89h (2 down)
;   1FB9h (5 stop)
;   1FD9h (space)
;   1FD3h (c)
;   1FD3h (C)
;   2029h (Enter)
;   1FE3h (Tab)
;   2040h (Esc)
;   2047h 

; 2122h Extended jump table:
;   1FADh (4 left)
;   1FA1h (6 right)
;   1F95h (8 up)
;   1F89h (2 down)
;   1FF3h (Tab)
;   27BCh (F1)
;   201Eh (F2)
;   2A10h (F3)
;   291Ah (F4)
;   1FC0h (F5)
;   2B50h (F6)


			                        ;* No entry point to code
		or	ah,[bx+di]
		or	ax,[bx+si]
		xor	al,36h			; '6'
		cmp	[bp+si],dh

; !!!! Picopad modification: Enter preferred to start game

		db	35h
		db	0Dh ;20h
		db	63h
		db	43h
		db	20h ;0Dh
		db	9
		db	1Bh

;		xor	ax,6320h
;		inc	bx
;		or	ax,1B09h

		and	ah,[bx+di]
		or	al,0
		dec	bx
		dec	bp
		dec	ax
		push	ax
		db	 0Fh, 3Bh, 3Ch, 3Dh, 3Eh, 3Fh
		db	 40h, 75h,0ADh, 1Fh,0A1h, 1Fh
		db	 95h, 1Fh, 89h, 1Fh,0B9h, 1Fh
		db	0D9h, 1Fh,0D3h, 1Fh,0D3h, 1Fh
		db	 29h, 20h,0E3h, 1Fh, 40h, 20h
		db	 47h, 20h,0ADh, 1Fh,0A1h, 1Fh
		db	 95h, 1Fh, 89h, 1Fh,0F3h, 1Fh
		db	0BCh, 27h, 1Eh, 20h, 10h, 2Ah
		db	 1Ah, 29h,0C0h, 1Fh
		db	 50h, 2Bh
data_a_2138	dw	offset sub_a_01C8
data_a_213A	dw	offset sub_a_2047

		; jump table of init screen
data_a_213C	dw	offset sub_a_214E	; 214Eh pointer to jump table
data_a_213E	dw	offset sub_a_0003	; 3 keys in this table
data_a_2140	dw	90Dh			; ASCII codes: 0Dh (Enter), 9 (Tab), 1Bh (Esc)
		db	1Bh
; extended codes:
;  2156h pointer to jump table
;  7 number of keys
;  0Fh Tab
;  3Bh F1
;  3Dh F3
;  3Eh F4
;  3Fh F5
;  40h F6
;  75h
		db	 56h, 21h, 07h, 00h, 0Fh
		db	 3Bh, 3Dh, 3Eh, 3Fh, 40h, 75h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_214E	proc	near

; 214Eh: ASCII jump table:
;  2029h Enter
;  1FE3h Tab
;  2040h Esc


		sub	[bx+si],sp
		jcxz	$+21h			; Jump if cx=0
		inc	ax
		and	[bx+20h],al
		db	0F3h, 1Fh,0BCh, 27h, 10h, 2Ah
		db	 1Ah, 29h,0C0h, 1Fh, 50h, 2Bh
		db	0C8h, 01h
		db	 47h, 20h
data_a_2166	db	86h
		db	 21h, 0Fh, 00h
		db	0Dh, 9, 1Bh, '82AaBbCcDd'
		db	 00h, 00h,0A6h, 21h, 09h, 00h
		db	 0Fh
		db	'HP;=>?@u) '
		db	0E3h, 1Fh
		db	 40h, 20h, 5Bh, 20h, 48h, 20h
data_a_2190	db	82h
		db	 20h, 82h, 20h, 9Ah, 20h, 9Ah
		db	 20h,0D0h, 20h,0D0h, 20h,0E4h
		db	 20h,0E4h, 20h, 1Ah, 29h, 1Ah
		db	 29h, 47h, 20h,0F3h, 1Fh, 5Bh
		db	 20h, 48h, 20h,0BCh, 27h, 10h
		db	 2Ah, 1Ah, 29h,0C0h, 1Fh, 50h
		db	 2Bh,0C8h, 01h, 47h, 20h,0C7h
		db	 21h, 02h, 00h, 0Dh, 09h,0CDh
		db	 21h, 03h, 00h, 0Fh, 3Fh, 75h
		db	 29h, 20h,0E3h, 1Fh, 47h, 20h
		db	0F3h, 1Fh,0C0h, 1Fh,0C8h, 01h
		db	 47h, 20h, 11h, 0Bh, 00h
		db	'STARTING THE GAME$'
		db	 02h, 03h, 41h, 20h
		db	'pla'
		db	'yer starts his turn by pressing '
		db	2, 5
		db	'the Fire button.  When a game is'
		db	'"'
		db	2, 7
		db	'over, the Fire button is also us'
		db	'ed'
		db	 14h, 02h
		db	9, 'to start a new game.#'
		db	 02h, 0Bh, 54h, 68h
		db	'e joystick t'
		db	'o be used by a player"'
		db	 02h, 0Dh
		db	'is determined by which Fire butt'
		db	 6Fh, 6Eh, 1Dh, 02h, 0Fh
		db	'is pressed to start his turn.$'
		db	 02h, 11h, 45h, 69h
		db	'ther player may use ei'
		db	'ther (or the '
		db	 02h, 13h
		db	'same) joystick.  A player cannot'
		db	 1Fh, 02h, 15h
		db	'switch joysticks during a game.', 1Bh
		db	 06h, 18h, 50h, 72h, 65h, 73h
		db	 73h, 20h, 18h, 2Ch, 20h, 19h
		db	', A - D, or Enter'
		db	 00h, 0Eh, 0Ch, 00h
		db	'SCORING POINTS'
		db	 1Dh, 05h, 02h
		db	'Shoot advancing creatures and'
		db	 15h, 0Ah, 04h
		db	'mushrooms for points.'
		db	 0Bh, 06h, 07h
		db	'1000 points'
		db	 14h, 06h
		db	9, '300, 600, 900 points'
		db	 1Dh, 06h, 0Bh
		db	'200 points - must shoot twice'
		db	 16h, 06h
		db	0Dh, '100 points - Head Link'
data_a_240C	dw	617h
		db	0Fh
		db	'10 points - Other Links'
		db	 1Ch, 06h, 11h
		db	'1 point - must shoot 4 times'
		db	 1Fh, 06h, 13h
		db	'(Damaged or Poisoned - 5 points'
		db	 1Fh, 07h, 15h
		db	'when your shooter is destroyed)', 1Bh
		db	 06h, 18h, 50h, 72h, 65h, 73h
		db	 73h, 20h, 18h, 2Ch, 20h, 19h
		db	', A - D, or Enter'
		db	 00h, 12h, 0Bh, 00h
		db	'NUMBER OF SHOOTERS'
		db	 15h, 05h, 03h
		db	'This is your shooter.#'
		db	 02h, 05h, 45h, 61h
		db	'ch pl'
		db	'ayer starts with 3 shooters."'
		db	2, 7
		db	'Bonus'
		db	' shooter every 12,000 points.%'
		db	2, 9
		db	'Maximum 6'
		db	' extra shooters at one time. '
		db	 02h, 0Bh
		db	'Collision with any creature will'
		db	 15h, 04h
		db	0Dh, 'destroy your shooter.!'
		db	 02h, 0Fh
		db	'Game'
		db	' over when all shooters gone.#'
		db	 02h, 11h, 49h, 6Eh
		db	' 2'
		db	' player game, players alternate'
		db	 1Eh, 04h, 13h
		db	'until their shooters are gone.', 1Bh
		db	 06h, 18h, 50h, 72h, 65h, 73h
		db	 73h, 20h, 18h, 2Ch, 20h, 19h
		db	2Ch
		db	' A - D, '
		db	'or Enter'
		db	 00h, 0Dh, 0Dh, 00h
		db	'KEYBOARD PLAY"'
		db	 02h, 02h, 54h, 68h
		db	'e Sp'
		db	'ace Bar is used for the Fire"'
		db	 02h, 04h, 62h
		db	'u'
		db	'tton.  '
		db	'Pressing the C key causes$'
		db	 02h, 06h, 63h, 6Fh
		db	'ntin'
		db	'uous fire, stopped by pressing'
		db	 0Eh, 02h
		db	8, 'the Space Bar.$'
		db	2
		db	0Ah, 'Th'
		db	'e c'
		db	'ursor keys are used to move the#'
		db	2
		db	0Ch, 'shoo'
		db	'ter.  Each time a cursor key is"'
		db	 02h, 0Eh
		db	'p'
		db	'r'
		db	'essed, it inc'
		db	'reases the speed of#'
		db	 02h, 10h, 6Dh, 6Fh
		db	'veme'
		db	'nt in the indicated direction#'
		db	 02h, 12h, 28h
		db	'or'
		db	' decreases speed in the opposite'
		db	 1Fh, 02h, 14h
		db	'direction).  The center key (5)', 1Bh
		db	 02h, 16h
		db	'stops the shooter movement.', 1Bh
		db	 06h, 18h, 50h, 72h, 65h, 73h
		db	 73h, 20h, 18h, 2Ch, 20h, 19h
		db	', A - D, or Enter'
		db	 00h,0E8h, 26h,0E0h,0BEh,0D0h
		db	 27h,0E8h, 60h,0F2h,0B2h, 03h
		db	 80h, 26h, 58h, 04h,0FDh,0BFh
		db	 3Ch, 21h,0C3h, 0Dh, 0Dh, 00h
		db	'FUNCTION KEYS'
		db	 1Ch, 06h, 02h
		db	'(May be pressed at any time)', 9
		db	2, 5
		db	'F1 - Help'
		db	 1Fh, 02h, 07h
		db	'F2 - Pause, '
loc_a_281A:
		popa				; Restore all regs
		outsb				; Out [si] to port dx
		jns	$+22h			; Jump if not sign
		imul	sp,word ptr [di+79h],20h	; reg = data * value
;*		jz	loc_a_2893		;*Jump if zero
		db	 74h, 6Fh		;  Fixup - byte match
		and	[bp+di+6Fh],ah
		outsb				; Out [si] to port dx
;*		jz	loc_a_2893		;*Jump if zero
		db	 74h, 69h		;  Fixup - byte match
		outsb				; Out [si] to port dx
		jnz	$+67h			; Jump if not zero
		sbb	ax,[bp+si]
		or	[bp+33h],ax
		and	[di],ch
		and	[si+69h],al
		jnc	$+72h			; Jump if carry=0
		insb				; Port dx to es:[di]
		popa				; Restore all regs
		jns	$+22h			; Jump if not sign
		push	sp
		outsw				; Out [si] to port dx
		jo	$+22h			; Jump if overflow=1
		push	sp
		db	'en Scores'
		db	 19h, 02h, 0Bh
		db	'F4 - Playing Instructions'
		db	 11h, 02h
		db	0Dh, 'F5 - Sound On/Off'
		db	 18h, 02h, 0Fh
		db	'F6 - Calibrate Joysti'
loc_a_2893:
		db	 63h, 6Bh, 73h, 14h, 02h, 11h
		db	'Tabs - Center Screen"'
		db	 02h, 14h, 45h
		db	'sc - End Game, g'
		db	'o to Title Screen$'
		db	 02h, 16h
		db	'C'
		db	'trl+Break o'
		db	'r Ctrl+End - Exit to DOS'
		db	 1Dh, 05h, 18h
		db	'Press Enter to Return to Game'
		db	0

;==== External Entry into Subroutine ======================================

sub_a_291A:
		call	sub_a_07E5		; clear video memory, setup palettes
		mov	si,offset data_a_2933
		call	sub_a_1A25
		mov	dl,3
		mov	di,offset data_a_2166
loc_a_2928:
		and	byte ptr ds:[458h],0FDh
		mov	byte ptr ds:[457h],65h	; 'e'
		retn
sub_a_214E	endp

data_a_2933	db	14h
		db	 0Ah, 01h
		db	'PLAYING INSTRUCTIONS'
		db	 15h, 08h, 05h
		db	'A - Starting the Game'
		db	 12h, 08h, 07h
		db	'B - Scoring Points'
		db	16h
		db	8, 9, 'C - Number of Shooters'
		db	 11h, 08h, 0Bh
		db	'D - Keyboard Play#'
		db	 03h, 14h, 50h, 72h, 65h, 73h
		db	 73h, 20h, 18h, 20h, 6Fh, 72h
		db	 20h, 19h
		db	' to cycle through items"'
		db	 03h, 16h
		db	'Press A - D to select desired it'
		db	'em'
		db	 1Dh, 03h, 18h
		db	'Press Enter to Return to Game'
		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2A10	proc	near
		call	sub_a_07E5		; clear video memory, setup palettes
		mov	di,offset data_a_046E	; ('SKILL LEVEL')
		mov	cx,50h
		mov	al,0F0h

locloop_a_2A1B:
		mov	es:[di],al
		mov	es:data_c_2000_e[di],al
		add	di,50h
		loop	locloop_a_2A1B		; Loop if cx > 0

		mov	di,offset data_a_049F
		mov	cx,50h
		mov	al,0Fh

locloop_a_2A30:
		mov	es:[di],al
		mov	es:data_c_2000_e[di],al
		add	di,50h
		loop	locloop_a_2A30		; Loop if cx > 0

		mov	al,0FFh
		mov	di,offset data_a_046E	; ('SKILL LEVEL')
		mov	ah,0Bh
loc_a_2A44:
		mov	cx,32h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		add	di,24Eh
		dec	ah
		jnz	loc_a_2A44		; Jump if not zero
		call	sub_a_1A9E
		mov	si,2B0Fh
;*		cmp	word ptr ds:d_0000_048B_e,6Ch
		db	 81h, 3Eh, 8Bh, 04h, 6Ch, 00h	;  Fixup - byte match
		jz	loc_a_2A6D		; Jump if zero
		mov	si,2B20h
		cmp	word ptr ds:d_0000_048B_e,159h
		je	loc_a_2A6D		; Jump if equal
		mov	si,offset data_a_2B36
loc_a_2A6D:
		call	sub_a_1A25
		push	ds
		mov	ds,ds:d_0000_045F_e
		mov	al,ds:d_0000_003D_e
		pop	ds
		cmp	al,20h			; ' '
		je	loc_a_2A87		; Jump if equal
		mov	cs:data_a_2B4D,al
		mov	si,offset data_a_2B49
		call	sub_a_1A25
loc_a_2A87:
		push	ds
		mov	di,ds:d_0000_048B_e
		mov	si,di
		add	di,18h
		push	di
		add	si,7
		mov	ds,ds:d_0000_045F_e
		mov	ah,0Ah
		mov	al,30h			; '0'
loc_a_2A9D:
		mov	cx,6

locloop_a_2AA0:
		or	[di],al
		inc	di
		loop	locloop_a_2AA0		; Loop if cx > 0

		add	di,11h
		dec	ah
		jnz	loc_a_2A9D		; Jump if not zero
		mov	dh,4
		mov	dl,8
		mov	cx,0Ah

locloop_a_2AB3:
		push	cx
		mov	cx,11h
		call	sub_a_1A3B
		mov	cx,6
loc_a_2ABD:
		lodsb				; String [si] to al
		cmp	al,30h			; '0'
		jne	loc_a_2AC7		; Jump if not equal
		inc	dl
		dec	cx
		jnz	loc_a_2ABD		; Jump if not zero
loc_a_2AC7:
		jz	loc_a_2ACD		; Jump if zero
		dec	si
		call	sub_a_1A3B
loc_a_2ACD:
		add	dh,2
		mov	dl,8
		pop	cx
		loop	locloop_a_2AB3		; Loop if cx > 0

		pop	di
		mov	ah,0Ah
		mov	al,0Fh
loc_a_2ADA:
		mov	cx,6

locloop_a_2ADD:
		and	[di],al
		inc	di
		loop	locloop_a_2ADD		; Loop if cx > 0

		add	di,11h
		dec	ah
		jnz	loc_a_2ADA		; Jump if not zero
		mov	si,d_8F06_28F9_e
		call	sub_a_1A25
		pop	ds
		add	word ptr ds:d_0000_048B_e,0EDh
		cmp	word ptr ds:d_0000_048B_e,246h
		jle	loc_a_2B04		; Jump if < or =
		mov	word ptr ds:d_0000_048B_e,6Ch
loc_a_2B04:
		mov	dl,3
		and	byte ptr ds:d_0000_0458_e,0FDh
		mov	di,213Ch		; jump table of init screen
		retn
sub_a_2A10	endp

			                        ;* No entry point to code
		or	ax,20Dh
		inc	cx
		insw				; Port dx to es:[di]
		popa				; Restore all regs
		jz	loc_a_2B7C		; Jump if zero
		jnz	loc_a_2B8B		; Jump if not zero
		and	[si+65h],cl
;*		jbe	loc_a_2B83		;*Jump if below or =
		db	 76h, 65h		;  Fixup - byte match
		insb				; Port dx to es:[di]
		add	[bp+si],dl
		or	ax,[bp+si]
		push	ax
;*		jc	loc_a_2B95		;*Jump if carry Set
		db	 72h, 6Fh		;  Fixup - byte match
		db	'fessional Level'
		db	0
data_a_2B36	db	0Fh
		db	 0Ch, 02h
		db	'Superstar Level'
		db	0
data_a_2B49	db	3
		db	 1Eh, 02h, 28h
data_a_2B4D	db	20h
		db	 29h, 00h,0E8h, 92h,0DCh,0A0h
		db	 52h, 04h, 50h, 80h, 26h, 58h
		db	 04h,0FDh, 1Eh,0E8h, 4Eh, 05h
		db	 80h, 3Eh, 90h, 04h, 00h, 75h
		db	 09h,0BEh, 10h, 2Dh,0E8h,0B8h
		db	0EEh,0EBh, 7Ah, 90h
loc_a_2B70:
		mov	byte ptr ds:[452h],30h	; '0'
		mov	si,offset data_a_2BFA
		call	sub_a_1A25
		pop	ds
loc_a_2B7C:
		mov	si,5Ah
		call	sub_a_2D99
		mov	si,d_5453_2BFA_e
		call	sub_a_1A25
		mov	si,d_5453_2CC2_e
loc_a_2B8B:
		call	sub_a_1A25
		mov	byte ptr ds:d_5453_0452_e,0C0h
		mov	si,63h
		call	sub_a_2D99
		call	sub_a_07E5		; clear video memory, setup palettes
		mov	si,d_5453_2CCB_e
		call	sub_a_1A25
		push	ds
		mov	ds,ds:d_5453_045F_e
		mov	dx,d_0000_005A_e
		mov	ah,1Ah
		int	21h			; DOS Services  ah=function 1Ah
						;  set DTA(disk xfer area) ds:dx
		mov	dx,d_0000_0010_e
		mov	ah,0Fh
		int	21h			; DOS Services  ah=function 0Fh
						;  open file, FCB @ ds:dx
		cmp	al,0FFh
		jne	loc_a_2BC3		; Jump if not equal
		mov	ah,16h
		int	21h			; DOS Services  ah=function 16h
						;  creat/truncat file FCB @ds:dx
		sub	ah,ah
		push	ax
		jmp	short loc_a_2BD1
		db	90h
loc_a_2BC3:
		mov	ax,ds:d_0000_0022_e
		test	ax,ax
		jnz	loc_a_2BD0		; Jump if not zero
		mov	ax,ds:d_0000_0020_e
		sub	ax,12h
loc_a_2BD0:
		push	ax
loc_a_2BD1:
		pop	ax
		test	ax,ax
		jnz	loc_a_2BE9		; Jump if not zero
		mov	word ptr ds:d_0000_001E_e,12h
		mov	byte ptr ds:d_0000_0030_e,0
		mov	ah,15h
		int	21h			; DOS Services  ah=function 15h
						;  sequent file write FCB @ds:dx
						;   returns al=0 ok, not 0=error
		mov	ah,10h
		int	21h			; DOS Services  ah=function 10h
						;  close file, FCB @ ds:dx
loc_a_2BE9:
		mov	si,d_0000_2D54_e
		call	sub_a_1A25
		pop	ds
		pop	ax
		mov	ds:d_0053_0452_e,al
		mov	di,offset data_a_213C
		mov	dl,3
		retn
data_a_2BFA	db	13h
		db	 0Ah, 01h
		db	'CALIBRATE JOYSTICKS '
		db	2, 4
		db	'Hold Joystick 1 the way you want'
		db	 19h, 07h, 06h
		db	'to hold it while playing.#'
		db	2
		db	9, 'Put Joystick  1  all the way '
		db	'to the', 0Ah
		db	 0Fh, 0Ch, 20h, 54h, 4Fh, 50h
		db	 20h, 28h, 18h, 29h, 20h, 20h
		db	 16h, 09h, 0Fh
		db	'and press FIRE button.#'
		db	 02h, 17h
		db	'(Press En'
		db	'ter to skip this joystick)'
		db	 00h, 01h, 10h, 04h, 32h, 01h
		db	 10h, 09h, 32h, 00h, 1Dh, 05h
		db	0Ah, 'Joystick Calibration Finish'
		db	'ed!'
		db	 03h, 0Eh
		db	'Results are being w'
		db	'ritten to disk'
		db	 00h, 1Dh, 05h
		db	0Ah, 'Game Adaptor or Joysticks n'
		db	'ot '
		db	 04h, 0Ch
		db	'present or'
		db	 20h, 6Eh, 6Fh
loc_a_2D40:
		jz	loc_a_2D62		; Jump if zero
		ja	loc_a_2DB3		; Jump if above
		jc	loc_a_2DB1		; Jump if carry Set
		imul	bp,word ptr [bp+67h],7020h	; reg = data * value
;*		jc	loc_a_2DBC		;*Jump if carry Set
		db	 72h, 6Fh		;  Fixup - byte match
;*		jo	loc_a_2DB4		;*Jump if overflow=1
		db	 70h, 65h		;  Fixup - byte match
;*		jc	loc_a_2DBD		;*Jump if carry Set
		db	 72h, 6Ch		;  Fixup - byte match
		jns	$+30h			; Jump if not sign
		add	[bx+di],ah
		add	cx,word ptr ds:[2020h]
		db	'         '
loc_a_2D62:
		db	'                      '
		db	 1Dh, 05h, 14h
		db	'Press Enter to Ret'
loc_a_2D8D:
		jnz	$+74h			; Jump if not zero
		outsb				; Out [si] to port dx
		and	[si+6Fh],dh
		and	[bx+61h],al
		insw				; Port dx to es:[di]
		db	 65h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2D99	proc	near
		push	ds
		mov	ds,word ptr ds:[45Fh]
		mov	al,[si+8]
		mov	byte ptr [si+8],0
		pop	ds
		push	si
loc_a_2DA7:
		push	ax
		call	sub_a_2EE2
		cmp	ax,0Dh
		pop	ax
		jnz	loc_a_2DBE		; Jump if not zero
loc_a_2DB1:
		pop	si
		push	ds
loc_a_2DB3:
		mov	ds,word ptr ds:[45Fh]
		mov	[si+8],al
		pop	ds
		jmp	loc_ret_a_2E91
loc_a_2DBE:
		push	cx
		push	ds
		mov	ds,word ptr ds:[45Fh]
		mov	byte ptr [si+3],0
		mov	byte ptr [si+7],0
		mov	si,d_8F06_2E92_e
		call	sub_a_1A25
		pop	ds
loc_a_2DD3:
		call	sub_a_2EE2
		test	ax,ax
		jnz	loc_a_2DD3		; Jump if not zero
		pop	dx
		pop	si
		push	si
		push	ds
		mov	ds,word ptr ds:[45Fh]
		sub	ah,ah
		mov	al,cl
		sub	bh,bh
		mov	bl,dl
loc_a_2DEA:
		sub	ax,bx
		jge	loc_a_2DF2		; Jump if > or =
		xor	ax,0FFFFh
		inc	ax
loc_a_2DF2:
		push	ax
loc_a_2DF3:
		sub	ah,ah
		mov	al,ch
		sub	bh,bh
		mov	bl,dh
		sub	ax,bx
		jge	loc_a_2E03		; Jump if > or =
		xor	ax,0FFFFh
		inc	ax
loc_a_2E03:
		pop	bx
		sub	bx,ax
		jle	loc_a_2E0F		; Jump if < or =
		mov	byte ptr [si+8],1
		jmp	short loc_a_2E13
		db	90h
loc_a_2E0F:
		xchg	cl,ch
		xchg	dl,dh
loc_a_2E13:
		sub	dh,dh
		sub	ch,ch
		mov	[si+4],dx
		sub	dx,cx
		jle	loc_a_2E28		; Jump if < or =
		mov	byte ptr [si+7],1
		mov	[si+4],cx
		jmp	short loc_a_2E2D
		db	90h
loc_a_2E28:
;*		xor	dx,0FFFFh
		db	 81h,0F2h,0FFh,0FFh	;  Fixup - byte match
		inc	dx
loc_a_2E2D:
		cmp	dx,8Dh
		jle	loc_a_2E36		; Jump if < or =
		mov	dx,8Dh
loc_a_2E36:
		sub	al,al
		mov	ah,dl
		shr	ax,1			; Shift w/zeros fill
		mov	dl,47h			; 'G'
		div	dl			; al, ah rem = ax/reg
		mov	[si+6],al
		mov	si,d_8F06_2EC6_e
		call	sub_a_1A25
		pop	ds
loc_a_2E4A:
		call	sub_a_2EE2
		test	ax,ax
		jnz	loc_a_2E4A		; Jump if not zero
		push	cx
		mov	si,offset data_a_2ED4
		call	sub_a_1A25
loc_a_2E58:
		call	sub_a_2EE2
		test	ax,ax
		jnz	loc_a_2E58		; Jump if not zero
		pop	ax
		pop	si
		push	ds
		mov	ds,word ptr ds:[45Fh]
		sub	ah,ah
		sub	ch,ch
		mov	[si],ax
		sub	ax,cx
		jle	loc_a_2E79		; Jump if < or =
		mov	byte ptr [si+3],1
		mov	[si],cx
		jmp	short loc_a_2E7D
		db	90h
loc_a_2E79:
		xor	ax,0FFFFh
		inc	ax
loc_a_2E7D:
		cmp	ax,8Dh
		jle	loc_a_2E85		; Jump if < or =
		mov	ax,8Dh
loc_a_2E85:
		xchg	ah,al
		shr	ax,1			; Shift w/zeros fill
		mov	dl,47h			; 'G'
		div	dl			; al, ah rem = ax/reg
		mov	[si+2],al
		pop	ds

loc_ret_a_2E91:
		retn
sub_a_2D99	endp

			                        ;* No entry point to code
		or	cl,[bx]
		or	al,42h			; 'B'
		dec	di
		push	sp
		push	sp
		dec	di
		dec	bp
		and	[bx+si],ch
		sbb	[bx+di],bp
		and	ax,[bp+si]
		pop	ss
		db	'                                '
		db	'   ', 0
		db	 0Ah, 0Fh
		db	0Ch, ' LEFT (', 1Bh, ') '
		db	0
data_a_2ED4	db	0Ah
		db	0Fh
		db	0Ch, 'RIGHT ('
		db	 1Ah, 29h, 20h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2EE2	proc	near
		call	sub_a_0831
		mov	dx,201h
loc_a_2EE8:
		in	al,dx			; port 201h, start game 1-shots
		xor	al,0F0h
		and	al,0F0h
		jnz	loc_a_2EE8		; Jump if not zero
loc_a_2EEF:
		cmp	ax,0Dh
		je	loc_ret_a_2F13		; Jump if equal
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		xor	al,0F0h
		and	al,ds:d_0000_0452_e
		jnz	loc_a_2F0A		; Jump if not zero
		mov	di,21BAh
		mov	dl,0
		call	sub_a_1F10		; input from keyboard and jump by table DI (DL bit 1: 1=wait for key)
;  DI+0: pointer to jump table
;  DI+2: number of keys
;  DI+4: ASCII key codes
;  ... follow table for extended keys

		jmp	short loc_a_2EEF
loc_a_2F0A:
		call	sub_a_2F14
		mov	ax,3A98h
loc_a_2F10:
		dec	ax
		jnz	loc_a_2F10		; Jump if not zero

loc_ret_a_2F13:
		retn
sub_a_2EE2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2F14	proc	near
		mov	bh,ds:d_0000_0452_e
		push	ds
		mov	ds,ds:d_0000_045F_e
		mov	cx,10h
		sub	ax,ax
		mov	di,ax

locloop_a_2F24:
		mov	[di],al
		inc	di
		loop	locloop_a_2F24		; Loop if cx > 0

		mov	cx,0FFh
		mov	bl,0Fh
		mov	dx,201h
		cli				; Disable interrupts
		out	dx,al			; port 201h, start game 1-shots

locloop_a_2F33:
		mov	si,ax
		inc	byte ptr [si]
		in	al,dx			; port 201h, start game 1-shots
		and	al,bl
		loop	locloop_a_2F33		; Loop if cx > 0

		sti				; Enable interrupts
		sub	dx,dx
		sub	si,si
		add	dl,[si+1]
		add	dh,[si+2]
		add	dl,[si+3]
		add	dh,[si+3]
		add	cl,[si+4]
		add	dl,[si+5]
		add	cl,[si+5]
		add	dh,[si+6]
		add	cl,[si+6]
		add	dl,[si+7]
		add	dh,[si+7]
		add	cl,[si+7]
		add	ch,[si+8]
		add	dl,[si+9]
		add	ch,[si+9]
		add	dh,[si+0Ah]
		add	ch,[si+0Ah]
		add	dl,[si+0Bh]
		add	dh,[si+0Bh]
		add	ch,[si+0Bh]
		add	cl,[si+0Ch]
		add	ch,[si+0Ch]
		add	dl,[si+0Dh]
		add	cl,[si+0Dh]
		add	ch,[si+0Dh]
		add	dh,[si+0Eh]
		add	cl,[si+0Eh]
		add	ch,[si+0Eh]
		add	dl,[si+0Fh]
		add	dh,[si+0Fh]
		add	cl,[si+0Fh]
		add	ch,[si+0Fh]
		mov	si,d_0000_0063_e
		and	bh,30h			; '0'
		jz	loc_a_2FAE		; Jump if zero
		xchg	cx,dx
		sub	si,9
loc_a_2FAE:
		cmp	byte ptr [si+8],0
		je	loc_a_2FB6		; Jump if equal
		xchg	ch,cl
loc_a_2FB6:
		pop	ds
		retn
sub_a_2F14	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_a_2FB8	proc	near
		call	sub_a_2F14
		push	ds
		mov	ds,data_c_045F
		sub	ax,ax
		mov	al,cl
		sub	ax,[si]
		cmp	ax,0
		jge	loc_a_2FCD		; Jump if > or =
		sub	ax,ax
loc_a_2FCD:
		xchg	ah,al
		shr	ax,1			; Shift w/zeros fill
		mov	bl,[si+2]
		sub	dx,dx
		mov	dl,ah
		sub	bh,bh
		cmp	bx,dx
		jg	loc_a_2FE2		; Jump if >
		mov	bl,ah
		inc	bl
loc_a_2FE2:
		div	bl			; al, ah rem = ax/reg
		sub	ah,ah
		cmp	ax,47h
		jle	loc_a_2FED		; Jump if < or =
		mov	al,47h			; 'G'
loc_a_2FED:
		cmp	byte ptr [si+3],0
		je	loc_a_2FFA		; Jump if equal
		mov	cl,47h			; 'G'
		sub	cl,al
		jmp	short loc_a_2FFC
		db	90h
loc_a_2FFA:
		mov	cl,al
loc_a_2FFC:
		sub	ax,ax
		mov	al,ch
		sub	ax,[si+4]
		cmp	ax,0
		jge	loc_a_300A		; Jump if > or =
		sub	ax,ax
loc_a_300A:
		xchg	ah,al
		shr	ax,1			; Shift w/zeros fill
		mov	bl,[si+6]
		mov	dl,ah
		cmp	bx,dx
		jg	loc_a_301B		; Jump if >
		mov	bl,ah
		inc	bl
loc_a_301B:
		div	bl			; al, ah rem = ax/reg
		sub	ah,ah
		cmp	ax,47h
		jle	loc_a_3026		; Jump if < or =
		mov	al,47h			; 'G'
loc_a_3026:
		cmp	byte ptr [si+7],0
		je	loc_a_3033		; Jump if equal
		mov	ch,47h			; 'G'
		sub	ch,al
		jmp	short loc_a_3035
		db	90h
loc_a_3033:
		mov	ch,al
loc_a_3035:
		nop
		pop	ds
		sub	ah,ah
		mov	al,cl
		sub	ax,3
		shl	ax,1			; Shift w/zeros fill
		sub	dx,dx
		mov	dl,byte ptr data_c_0028
		sub	ax,dx
		jge	loc_a_3050		; Jump if > or =
		sub	ax,4
		jmp	short loc_a_3053
		db	90h
loc_a_3050:
		add	ax,3
loc_a_3053:
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		cmp	ax,4
		jle	loc_a_3061		; Jump if < or =
		mov	ax,4
loc_a_3061:
		cmp	ax,0FFFCh
		jge	loc_a_3069		; Jump if > or =
		mov	ax,0FFFCh
loc_a_3069:
		mov	cl,al
		sub	ah,ah
		mov	al,ch
		sub	ax,14h
		sar	ax,1			; Shift w/sign fill
		sub	dx,dx
		mov	dl,byte ptr data_c_0028+1
		sub	dx,48h
		sub	ax,dx
		jge	loc_a_3087		; Jump if > or =
		sub	ax,4
		jmp	short loc_a_308A
		db	90h
loc_a_3087:
		add	ax,3
loc_a_308A:
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		sar	ax,1			; Shift w/sign fill
		cmp	ax,4
		jle	loc_a_3098		; Jump if < or =
		mov	ax,4
loc_a_3098:
		cmp	ax,0FFFCh
		jge	loc_a_30A0		; Jump if > or =
		mov	ax,0FFFCh
loc_a_30A0:
		mov	ch,al
		cmp	byte ptr data_c_0453,0
		je	loc_ret_a_30AD		; Jump if equal
		mov	cx,data_c_0455		; horizontal move speed

loc_ret_a_30AD:
		retn
sub_a_2FB8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; check joystick

sub_a_30AE	proc	near
		mov	byte ptr data_c_0490,0
		mov	ds,data_c_045B
		assume	ds:seg_b
		mov	byte ptr data_b_0490,0
		mov	ds,data_b_045B		; 2nd data segment
		mov	cx,0C8h
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		and	al,0Fh
		xor	al,0Fh
		jz	loc_ret_a_30F1		; Jump if zero
		mov	ah,al

locloop_a_30CF:
		in	al,dx			; port 201h, start game 1-shots
		and	al,ah
		jnz	loc_ret_a_30F1		; Jump if not zero
		loop	locloop_a_30CF		; Loop if cx > 0

		sub	al,al
		out	dx,al			; port 201h, start game 1-shots
		nop
		in	al,dx			; port 201h, start game 1-shots
		and	al,ah
		jz	loc_ret_a_30F1		; Jump if zero
		assume	ds:seg_c
		mov	byte ptr data_c_0490,1
		mov	ds,data_c_045B
		assume	ds:seg_b
		mov	byte ptr data_b_0490,1
		mov	ds,data_b_045B		; 2nd data segment

loc_ret_a_30F1:
		retn
sub_a_30AE	endp

		db	14 dup (0)

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	para public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_e

		db	10 dup (0)
data_b_000A	db	0
		db	803 dup (0)
data_b_032E	db	0
		db	283 dup (0)
data_b_044A	db	0
		db	0, 0
data_b_044D	db	0
		db	10 dup (0)
data_b_0458	db	0
data_b_0459	dw	0		; old SP
data_b_045B	dw	seg_c		; 2nd data segment
data_b_045D	dw	seg_b
data_b_045F	dw	seg_d
		db	 98h, 23h, 0Ah, 00h
data_b_0465	dw	473h
		db	 4Ah, 01h, 0Eh, 08h, 08h, 04h
		db	 14h, 00h, 0Ah, 00h, 0Ch, 06h
		db	 36h, 01h, 09h, 04h, 05h, 02h
		db	 0Fh, 00h, 08h, 00h, 08h, 04h
		db	 96h, 00h, 07h, 04h, 04h, 02h
		db	 0Ah, 00h, 05h, 00h, 06h, 03h
data_b_048B	dw	6Ch
data_b_048D	dw	6Ch
		db	0
data_b_0490	db	0
		db	3, 1
data_b_0493	db	0
		db	 2Dh, 1Bh, 1Dh
		db	9 dup (0)

seg_b		ends



;------------------------------------------------------------  seg_c   ----

seg_c		segment	byte public
		assume cs:seg_c  , ds:seg_c , ss:stack_seg_e

data_c_0000	dw	0
		db	0, 0
data_c_0004	db	0
		db	0
data_c_0006	dw	0
data_c_0008	dw	0
data_c_000A	db	0
data_c_000B	db	0
data_c_000C	db	0
		db	0
data_c_000E	dw	0
data_c_0010	dw	0
data_c_0012	dw	0
data_c_0014	db	0
		db	0
data_c_0016	dw	0
data_c_0018	db	0
data_c_0019	db	0
data_c_001A	db	0
		db	0
data_c_001C	dw	0
data_c_001E	db	0
data_c_001F	db	0
data_c_0020	dw	0
data_c_0022	dw	0
data_c_0024	dw	0
data_c_0026	db	0
data_c_0027	db	0
data_c_0028	dw	0
data_c_002A	db	0
		db	65 dup (0)
data_c_006C	db	0
		db	0, 0, 0, 0, 0
data_c_0072	dw	0
data_c_0074	db	0
data_c_0075	db	0
data_c_0076	dw	0
data_c_0078	db	0			; Data table (indexed access)
		db	110 dup (0)
data_c_00E7	db	0
		db	848 dup (0)
data_c_0438	dw	0
data_c_043A	dw	0
		db	8 dup (0)
data_c_0444	dw	0
data_c_0446	dw	0
data_c_0448	db	0
data_c_0449	db	0
data_c_044A	db	0
data_c_044B	db	0
data_c_044C	db	0
data_c_044D	db	0
data_c_044E	db	0
data_c_044F	db	0
data_c_0450	db	0
data_c_0451	db	0
data_c_0452	db	0
data_c_0453	db	0
data_c_0454	db	0
data_c_0455	dw	0		; horizontal move speed, +1 vertical move speed
data_c_0457	db	0
data_c_0458	db	0
data_c_0459	dw	0		; old SP
data_c_045B	dw	seg_b
data_c_045D	dw	seg_b
data_c_045F	dw	seg_d
		db	 84h, 24h, 2Eh, 00h
data_c_0465	dw	473h
		db	 4Ah, 01h, 0Eh, 08h, 08h, 04h
		db	 14h, 00h, 0Ah, 00h, 0Ch, 06h
		db	 36h, 01h, 09h, 04h, 05h, 02h
		db	 0Fh, 00h, 08h, 00h, 08h, 04h
		db	 96h, 00h, 07h, 04h, 04h, 02h
		db	 0Ah, 00h, 05h, 00h, 06h, 03h
data_c_048B	dw	6Ch
data_c_048D	dw	6Ch
data_c_048F	db	0
data_c_0490	db	0
data_c_0491	db	0
data_c_0492	db	2
data_c_0493	db	0
data_c_0494	db	2Dh		; setup horizontal centering
		db	 1Dh, 1Ch, 00h
		db	8 dup (0)

seg_c		ends



;------------------------------------------------------------  seg_d   ----

seg_d		segment	byte public
		assume cs:seg_d  , ds:seg_d , ss:stack_seg_e

		dw	8 dup (0)		; Data table (indexed access)
data_d_0010	db	0
		db	'JOYSTICKCTP'
		db	0, 0
data_d_001E	db	0
		db	0
data_d_0020	dw	0			; Data table (indexed access)
data_d_0022	dw	0
		db	12 dup (0)
data_d_0030	db	0
		db	0, 0, 0, 0

		; TOPTEN FCB
data_d_0035	db	0	; TOPTEN disk
		db	 54h, 4Fh, 50h, 54h, 45h, 4Eh ; TOPTEN
data_d_003C	db	20h	; TOPTEN 7th character
data_d_003D	db	20h	; TOPTEN 8th character = digit/character from command line
		db	 43h, 54h, 50h ; TOPTEN filename extension 'CTP'
		db	0, 0	; TOPTEN current cluster
data_d_0043	dw	0	; TOPTEN record size
data_d_0045	dw	0	; TOPTEN file size LOW
data_d_0047	dw	0	; TOPTEN file size HIGH
		db	12 dup (0) ; (2) date, (2) time, (8) reserved
data_d_0055	db	0	; TOPTEN current record
		db	0, 0, 0, 0 ; TOPTEN relative record

		; JOYSTICK.CTP buffer
data_d_005A	db	0
		db	 00h, 80h, 00h, 00h, 00h, 80h
		db	 00h, 00h, 00h, 00h, 80h, 00h
		db	 00h, 00h, 80h, 00h, 00h

		; TOPTENA.CTP buffer
data_d_006C	db	' ', 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	' '
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	 20h, 20h, 20h, 20h, 20h
data_d_00D5	db	'           ', 0
		db	 00h, 00h, 00h, 00h, 00h, 20h
		db	 20h, 20h, 20h, 20h, 20h
data_d_00EC	db	'           ', 0
		db	 00h, 00h, 00h, 00h, 00h, 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	0, 0, 0, 0, 0, 0

		; TOPTENP.CTP buffer
data_d_0159	db	20h
		db	 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	17 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	0, 0, 0, 0, 0, 0

		; TOPTENS.CTP buffer
data_d_0246	db	20h
		db	 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	17 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h
		db	16 dup (20h)
		db	0, 0, 0, 0, 0, 0
data_d_0333	db	20h
		db	16 dup (20h)
data_d_0344	dw	0		; INT 11h equipment list
data_d_0346	db	0
data_d_0347	db	0
		db	 05h, 14h, 65h, 50h, 15h, 40h
		db	 15h, 40h, 65h, 50h, 05h, 14h
		db	 14h, 50h, 05h, 59h, 01h, 54h
		db	 01h, 54h, 05h, 59h, 14h, 50h
		db	 05h, 14h, 65h, 50h, 15h, 40h
		db	 15h, 40h, 65h, 50h, 05h, 14h
		db	 14h, 50h, 05h, 59h, 01h, 54h
		db	 01h, 54h, 05h, 59h, 14h, 50h
		db	 00h, 00h,0AAh,0A0h, 0Ah,0AAh
		db	 00h,0A0h, 00h,0A0h, 02h,0A0h
		db	 00h,0AAh,0AAh, 00h, 00h, 00h
		db	 00h, 00h, 0Ah, 0Ah, 00h,0A0h
		db	 00h,0A0h, 00h,0A0h, 00h,0AAh
		db	0AAh, 80h, 0Ah,0AAh, 00h, 00h
		db	 0Ah, 00h,0AAh,0A0h, 0Ah, 80h
		db	0AAh, 00h, 00h,0AAh,0AAh, 00h
		db	 00h, 00h, 00h, 00h, 0Ah, 00h
		db	0A0h,0A0h, 0Ah, 00h, 0Ah, 00h
		db	 02h,0AAh,0AAh, 00h, 00h, 00h
		db	 00h, 0Ah, 0Ah,0AAh, 00h, 0Ah
		db	 00h,0A0h, 00h,0AAh, 00h,0AAh
		db	0AAh, 00h, 00h, 00h, 00h,0AAh
		db	 0Ah, 0Ah, 00h, 0Ah, 00h,0A0h
		db	 00h, 0Ah, 00h,0AAh,0AAh,0A0h
		db	0A0h, 00h, 00h, 00h,0A0h, 00h
		db	0AAh,0A0h,0AAh, 00h,0AAh, 00h
		db	 00h,0AAh,0AAh, 00h,0AAh, 00h
		db	 00h, 00h,0A0h, 00h,0A0h,0A0h
		db	0A0h, 00h, 0Ah, 00h, 0Ah,0AAh
		db	0AAh, 00h, 00h,0A0h, 00h, 0Ah
		db	0AAh, 00h, 00h,0A0h, 00h, 0Ah
		db	0AAh, 00h, 00h, 0Ah, 00h, 00h
		db	0AAh,0A0h, 00h, 0Ah, 00h, 00h
		db	0AAh,0A0h, 28h, 28h, 28h, 28h
		db	 00h, 02h, 80h, 00h, 02h,0AAh
		db	0AAh, 80h, 28h, 02h, 80h, 28h
		db	 0Ah,0A0h, 0Ah,0A0h,0A0h, 0Ah
		db	0A0h, 0Ah, 00h, 02h, 80h, 00h
		db	 0Ah, 0Ah,0A0h,0A0h,0A0h, 28h
		db	 28h, 0Ah, 00h, 02h, 80h, 00h
		db	 28h, 0Ah,0A0h, 28h, 00h, 02h
		db	 80h, 00h,0AAh,0A0h, 0Ah,0AAh
		db	 00h, 0Ah,0A0h, 00h, 0Ah,0AAh
		db	0AAh,0A0h,0A0h, 0Ah,0A0h, 0Ah
		db	 0Ah,0A0h,0A0h, 02h, 22h, 08h
		db	 28h, 08h,0AAh,0AAh,0A2h, 0Ah
		db	 03h,0C0h, 3Fh,0FCh, 03h,0C0h
		db	 0Fh,0F0h, 3Fh,0FCh, 03h,0C0h
		db	 03h,0C0h, 3Fh,0F0h, 03h, 00h
		db	 0Fh,0F0h, 3Fh,0C0h, 03h, 00h
		db	 03h,0C0h, 3Fh,0C0h, 00h, 00h
		db	 0Fh,0C0h, 3Fh,0C0h, 00h, 00h
		db	 03h,0C0h, 3Fh, 00h, 00h, 00h
		db	 0Fh,0C0h, 30h, 00h, 00h, 00h
		db	 02h, 80h, 2Ah,0A8h, 02h, 80h
		db	 0Ah,0A0h, 2Ah,0A8h, 02h, 80h
		db	 02h, 80h, 2Ah,0A0h, 02h, 00h
		db	 0Ah,0A0h, 2Ah, 80h, 02h, 00h
		db	 02h, 80h, 2Ah, 80h, 00h, 00h
		db	 0Ah, 80h, 2Ah, 80h, 00h, 00h
		db	 02h, 80h, 2Ah, 00h, 00h, 00h
		db	 0Ah, 80h, 20h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h,0F0h, 00h
		db	0F0h, 00h,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Fh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0F0h, 00h,0F0h
		db	 00h,0F0h, 00h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 0Fh, 00h, 00h
		db	0A0h,0A0h, 00h, 00h, 02h, 80h
		db	 00h, 00h,0A0h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 2Ah, 80h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 00h,0A0h, 00h, 00h, 2Ah, 80h
		db	 00h, 00h, 28h, 00h, 00h, 00h
		db	0AAh, 80h, 00h, 00h,0A0h,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah, 80h, 00h, 00h,0A0h, 00h
		db	 00h, 00h,0A0h,0A0h, 00h, 00h
		db	 2Ah, 80h, 00h, 00h,0A0h,0A0h
		db	 00h, 00h, 2Ah,0A0h, 00h, 00h
		db	 02h, 80h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 2Ah, 80h, 00h, 00h
		db	0A0h,0A0h, 00h, 00h, 00h,0A0h
		db	 00h, 00h, 2Ah, 00h, 00h, 00h
		db	0A0h, 28h,0A0h, 28h,0A0h, 28h
		db	0A0h, 28h,0A0h, 28h,0A0h, 28h
		db	 00h, 00h, 00h, 00h, 2Ah,0A0h
		db	 2Ah,0A0h,0A0h, 28h,0A0h, 28h
		db	0A0h, 28h,0A0h, 28h, 2Ah,0A0h
		db	 2Ah,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 2Ah,0A8h, 00h
		db	17 dup (0)
		db	 2Ah,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 02h, 80h, 00h, 00h
		db	 0Ah,0A0h, 00h, 00h,0A0h, 0Ah
		db	 00h
		db	9 dup (0)
		db	0A0h, 0Ah, 00h, 00h, 0Ah,0A0h
		db	 00h, 00h, 02h, 80h, 00h, 0Ah
		db	 00h, 00h,0A0h, 00h,0A0h, 0Ah
		db	 00h, 00h,0AAh,0AAh, 00h,0A0h
		db	 02h, 80h, 0Ah,0A0h, 02h, 80h
		db	 0Ah, 00h,0AAh,0AAh, 00h, 28h
		db	0A0h, 0Ah, 28h, 0Ah, 00h, 00h
		db	0A0h,0A0h, 00h, 00h, 0Ah, 00h
		db	 00h, 00h, 00h, 02h, 80h, 02h
		db	 80h, 00h, 28h, 28h, 00h, 00h
		db	 28h, 28h, 00h, 02h, 80h, 02h
		db	 80h, 00h, 00h, 00h, 00h,0A0h
		db	 00h, 00h, 0Ah, 00h, 00h, 00h
		db	 00h

seg_d		ends



;------------------------------------------------------  stack_seg_e   ----

stack_seg_e	segment	word stack 'stack'

		db	53h
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   S'
		db	'TACK   STACK   STACK   STACK   '

stack_seg_e	ends



		end	start
