
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
;==				PATROL	                                 ==
;==					                                 ==
;==      Created:   3-Mar-24		                                 ==
;==      Passes:    5          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

jmpn            macro   location
                db      0E9h
                dw      offset location-$-2
endm

.186


; The following equates show data references outside the range of the program.

d_0000_0003_e	equ	3
d_0000_0100_e	equ	100h
d_0000_0410_e	equ	410h
d_0000_0488_e	equ	488h
d_0000_87BE_e	equ	87BEh			;*
d_0000_8816_e	equ	8816h			;*
d_0000_8818_e	equ	8818h			;*
d_0000_8819_e	equ	8819h			;*
d_0000_881A_e	equ	881Ah			;*
d_0000_881E_e	equ	881Eh			;*
d_0000_8820_e	equ	8820h			;*
d_0000_8853_e	equ	8853h			;*
d_0000_8855_e	equ	8855h			;*
d_0000_8920_e	equ	8920h			;*
d_0000_8922_e	equ	8922h			;*
d_0000_FCA1_e	equ	0FCA1h			;*
data_a_0140_e	equ	140h			;*
data_b_7F00_e	equ	7F00h			;*
data_b_81E0_e	equ	81E0h			;*
data_b_82B1_e	equ	82B1h			;*
data_b_84B7_e	equ	84B7h			;*
data_b_84D9_e	equ	84D9h			;*
data_b_85A5_e	equ	85A5h			;*
data_b_8712_e	equ	8712h			;*
data_b_872B_e	equ	872Bh			;*
data_b_8742_e	equ	8742h			;*
data_b_876A_e	equ	876Ah			;*
data_b_8812_e	equ	8812h			;*
data_b_8817_e	equ	8817h			;*
data_b_8818_e	equ	8818h			;*
data_b_8819_e	equ	8819h			;*
data_b_881A_e	equ	881Ah			;*
data_b_881C_e	equ	881Ch			;*
data_b_881E_e	equ	881Eh			;*
data_b_8820_e	equ	8820h			;*
data_b_8822_e	equ	8822h			;*
data_b_882A_e	equ	882Ah			;*
data_b_8832_e	equ	8832h			;*
data_b_8836_e	equ	8836h			;*
data_b_883A_e	equ	883Ah			;*
data_b_883E_e	equ	883Eh			;*
data_b_8844_e	equ	8844h			;*
data_b_884A_e	equ	884Ah			;*
data_b_8850_e	equ	8850h			;*
data_b_8851_e	equ	8851h			;*
data_b_8852_e	equ	8852h			;*
data_b_8853_e	equ	8853h			;*
data_b_8854_e	equ	8854h			;*
data_b_8855_e	equ	8855h			;*
data_b_8856_e	equ	8856h			;*
data_b_88A9_e	equ	88A9h			;*
data_b_88BB_e	equ	88BBh			;*
data_b_8923_e	equ	8923h			;*
data_b_896D_e	equ	896Dh			;*
data_b_896E_e	equ	896Eh			;*
data_b_896F_e	equ	896Fh			;*
data_b_89B5_e	equ	89B5h			;*
data_b_89FB_e	equ	89FBh			;*
data_b_8A87_e	equ	8A87h			;*
data_b_8A8F_e	equ	8A8Fh			;*
data_b_8A93_e	equ	8A93h			;*
data_b_8AD1_e	equ	8AD1h			;*
data_b_8BF1_e	equ	8BF1h			;*
data_b_B140_e	equ	0B140h			;*
data_d_53C9_e	equ	53C9h			;*
data_d_A2A0_e	equ	0A2A0h			;*
data_d_AAAA_e	equ	0AAAAh			;*
data_d_AABA_e	equ	0AABAh			;*
d_B800_0410_e	equ	410h

;------------------------------------------------------------  seg_a   ----

seg_a		segment	byte public
		assume cs:seg_a  , ds:seg_a , ss:stack_seg_d

			                        ;* No entry point to code
		mov	ax,cs
		add	ax,20h
		mov	word ptr ds:data_a_0140_e+2,ax
;*		xor	ax,ax			; Zero register
		db	 31h,0C0h		;  Fixup - byte match
		mov	ds:data_a_0140_e,ax
		jmp	dword ptr ds:data_a_0140_e
		db	239 dup (0)

seg_a		ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_d


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


PATROL		proc	far

start:
		jmp	loc_b_01EE
data_b_0003	db	0

; Interrupt handlers
data_b_0004	dw	8			; Data table (indexed access) ... INT 02h
data_b_0006	dw	22Bh			; Data table (indexed access) ... INT 02h offset
data_b_0008	dw	0			; Data table (indexed access) ... INT 02h sgment

		db	 20h, 00h		; INT 08h 
data_b_000C	dw	221h, 0			; INT 08h offset, INT 08h segment

data_b_0010	db	24h			; INT 09h index
data_b_0011	db	0
		db	4			; INT 09h offset (0304h)
data_b_0013	db	3
data_b_0014	db	0			; INT 09h segment
data_b_0015	db	0

data_b_0016	db	20h			; INT 48h
data_b_0017	db	1
data_b_0018	db	0D4h			; INT 48h offset (2D4h)
		db	2
data_b_001A	db	0
data_b_001B	db	0

data_b_001C	db	0FFh
		db	0FFh,0CBh, 03h
data_b_0020	db	21h
data_b_0021	db	4Eh
data_b_0022	db	36h
data_b_0023	db	4Eh
		db	 25h, 04h,0A3h, 04h
data_b_0028	db	0C3h
data_b_0029	db	4Dh
data_b_002A	db	0CFh			; Data table (indexed access)
		db	 03h,0D6h, 03h
data_b_002E	db	0E4h
		db	 03h,0EBh
data_b_0031	db	3
		db	0F2h
data_b_0033	db	3
		db	5, 4
data_b_0036	dw	0FFFEh
data_b_0038	dw	0
data_b_003A	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
data_b_0041	db	0
data_b_0042	db	0
data_b_0043	db	0
data_b_0044	dw	0
data_b_0046	db	0
data_b_0047	db	0
data_b_0048	db	0
data_b_0049	db	0
data_b_004A	db	0
		db	0
data_b_004C	db	0
data_b_004D	db	0
data_b_004E	db	0
data_b_004F	db	0
data_b_0050	db	0
data_b_0051	db	0
data_b_0052	db	0
data_b_0053	db	0
data_b_0054	db	0
data_b_0055	db	0
data_b_0056	db	0
data_b_0057	db	0
data_b_0058	db	0
data_b_0059	db	0
data_b_005A	dw	0
data_b_005C	dw	0			; data segment
data_b_005E	db	0
data_b_005F	db	0
data_b_0060	db	0
data_b_0061	db	0
data_b_0062	db	0
data_b_0063	db	0
data_b_0064	db	0
data_b_0065	db	0
data_b_0066	db	0
data_b_0067	db	0
data_b_0068	db	0
		db	0, 0, 0
data_b_006C	db	0
data_b_006D	db	0
data_b_006E	db	0
data_b_006F	db	0
data_b_0070	db	0
data_b_0071	db	0
data_b_0072	db	0
data_b_0073	dw	0
data_b_0075	dw	0
		db	0
data_b_0078	db	0
		db	0
data_b_007A	db	0
data_b_007B	db	0
data_b_007C	db	0
data_b_007D	db	0
data_b_007E	db	0			; Data table (indexed access)
data_b_007F	db	0
data_b_0080	db	0
		db	0, 0
data_b_0083	db	0
data_b_0084	db	0
data_b_0085	db	0
data_b_0086	db	0			; Data table (indexed access)
		db	10 dup (0)
data_b_0091	db	0			; Data table (indexed access)
data_b_0092	db	0
data_b_0093	db	0			; Data table (indexed access)
data_b_0094	db	0
		db	0
data_b_0096	db	0
data_b_0097	db	0
data_b_0098	db	0
data_b_0099	db	0
data_b_009A	db	0
		db	0
data_b_009C	db	0
data_b_009D	db	0
data_b_009E	db	0
		db	0
data_b_00A0	db	0
data_b_00A1	db	0
data_b_00A2	db	0
data_b_00A3	db	0
data_b_00A4	db	0
data_b_00A5	db	0
data_b_00A6	db	0
data_b_00A7	db	0
		db	0, 0, 0, 0, 0, 0
		db	0
data_b_00AF	db	0
data_b_00B0	db	0
data_b_00B1	db	0
data_b_00B2	db	0
data_b_00B3	db	0
		db	0
data_b_00B5	db	0
data_b_00B6	db	0
data_b_00B7	db	0
data_b_00B8	db	0
data_b_00B9	db	0
data_b_00BA	db	0
data_b_00BB	db	0
data_b_00BC	db	0
data_b_00BD	db	0
data_b_00BE	db	0
data_b_00BF	db	0
data_b_00C0	db	0
data_b_00C1	db	0
data_b_00C2	db	0
data_b_00C3	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_00C7	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_00CB	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
data_b_00D1	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_00D5	db	0
		db	0
data_b_00D7	db	0
data_b_00D8	db	0
data_b_00D9	db	0
data_b_00DA	db	0
data_b_00DB	db	0
		db	0
data_b_00DD	db	0
data_b_00DE	db	0
data_b_00DF	db	0
data_b_00E0	db	0
data_b_00E1	db	0
data_b_00E2	db	0			; Data table (indexed access)
		db	0, 0
data_b_00E5	db	0			; Data table (indexed access)
		db	0, 0
data_b_00E8	db	0			; Data table (indexed access)
		db	0, 0
data_b_00EB	db	0			; Data table (indexed access)
		db	0, 0
data_b_00EE	db	0
data_b_00EF	db	0
data_b_00F0	db	0
data_b_00F1	db	0
data_b_00F2	db	0
data_b_00F3	db	0
		db	12 dup (0)
data_b_0100	dw	0
		db	236 dup (0)	; stack
loc_b_01EE:
		cld				; Clear direction
		cli				; Disable interrupts
		mov	al,0
		out	0A0h,al			; port 0A0h  al = 0, Non-Maskable int
		mov	bx,cs
		mov	ss,bx
		sub	bx,100h
		nop
		mov	bx,seg seg_c
		mov	ds,bx
		assume	ss:seg_b
		mov	ss:data_b_005C,ds	; data segment
		assume	ds:seg_c
		mov	data_c_8814,es
		mov	sp,1EEh			; stack

		call	sub_b_072E		; Install/restore interrupt handlers
		in	al,0A0h			; port 0A0h ??i/o non-standard
		mov	al,80h
		out	0A0h,al			; port 0A0h  al = 80h, enable NMI
		sti				; Enable interrupts
		in	al,61h			; port 61h, 8255 port B, read
;		and	al,0FEh
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		jmp	loc_b_4DCB

; 0221h: INT 08h handler
			                        ;* No entry point to code
		inc	ss:data_b_005A
		jmp	dword ptr ss:data_b_000C

; 022Bh: INT 02h handler
			                        ;* No entry point to code
		push	ax
		mov	al,0
		out	43h,al			; port 43h, 8253 timer control
						;  al = 0, latch timer0 count
		push	bx
		in	al,40h			; port 40h, 8253 timer 0 clock
		xchg	ah,al
		in	al,40h			; port 40h, 8253 timer 0 clock
		xchg	ah,al
		mov	bx,ss:data_b_0036
		mov	ss:data_b_003A[bx],ax
		inc	bx
		inc	bx
		mov	ss:data_b_0036,bx
		jz	loc_b_0267		; Jump if zero
		sub	ax,ss:data_b_0038
		cmp	ax,0E0D8h
		ja	loc_b_0267		; Jump if above
		cmp	ax,0D90Eh
		ja	loc_b_026C		; Jump if above
		add	ss:data_b_0038,ax
		mov	ss:data_b_0036,0
loc_b_0267:
		in	al,0A0h			; port 0A0h ??i/o non-standard
		pop	bx
		pop	ax
		iret				; Interrupt return
loc_b_026C:
		sti				; Enable interrupts
		assume	ss:stack_seg_d
		mov	ss:data_d_0036,0FFFEh
		push	cx
		xor	bx,bx			; Zero register
		mov	cl,8
loc_b_0279:
		mov	ax,ss:data_d_0038[bx]
		sub	ax,ss:data_d_003A[bx]
		sub	ax,3A6h
		jc	loc_b_02CD		; Jump if carry Set
		cmp	ax,0E6h
		jb	loc_b_02BC		; Jump if below
		sub	ax,1D3h
		jc	loc_b_02CD		; Jump if carry Set
		cmp	ax,159h
		jb	loc_b_02AE		; Jump if below
		sub	ax,1D3h
		jc	loc_b_02CD		; Jump if carry Set
		cmp	ax,1CCh
		jb	loc_b_02B9		; Jump if below
		sub	ax,1D3h
		jc	loc_b_02CD		; Jump if carry Set
		cmp	ax,23Eh
		ja	loc_b_02CD		; Jump if above
		rcr	ch,1			; Rotate thru carry
		dec	cx
loc_b_02AE:
		add	ss:data_d_003A[bx],20Ch
		mov	al,0
		jmp	short loc_b_02BE
loc_b_02B9:
		rcr	ch,1			; Rotate thru carry
		dec	cx
loc_b_02BC:
		mov	al,1
loc_b_02BE:
		cmp	cl,0
		je	loc_b_02CD		; Jump if equal
		rcr	al,1			; Rotate thru carry
		rcr	ch,1			; Rotate thru carry
		inc	bx
		inc	bx
		dec	cl
		jnz	loc_b_0279		; Jump if not zero
loc_b_02CD:
		mov	al,ch
		pop	cx
		jnz	loc_b_0267		; Jump if not zero
		jmp	short loc_b_02D6

; 02D4h: INT 48h handler (PCjr keyboard)

		db	 50h, 53h
loc_b_02D6:
		push	ds
		mov	ds,ss:data_d_005C
		cbw				; Convrt byte to word
		and	ax,807Fh
		cmp	al,54h			; 'T'
		jne	loc_b_02EC		; Jump if not equal
		mov	byte ptr ds:d_0000_8816_e,0
		jmp	loc_b_0267
loc_b_02EC:
		test	byte ptr ds:d_0000_8816_e,80h
		jnz	loc_b_02FC		; Jump if not zero
		mov	bx,d_0000_87BE_e
		xlat				; al=[al+[bx]] table
		mov	byte ptr ds:d_0000_8816_e,80h
loc_b_02FC:
		or	al,ah
		out	60h,al			; port 60h, keybd data write
		in	al,0A0h			; port 0A0h ??i/o non-standard
		jmp	short loc_b_030C

; 0304h: INT 09h handler
			                        ;* No entry point to code
		push	ax
		push	bx
		push	ds
		mov	ds,ss:data_d_005C
loc_b_030C:
		in	al,60h			; port 60h, keybd scan or sw1
		mov	ah,al
		in	al,61h			; port 61h, 8255 port B, read
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
		and	al,7Fh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		sti				; Enable interrupts
		test	ah,ah
		jns	loc_b_0340		; Jump if not sign
		cmp	byte ptr ds:d_0000_8853_e,1
		je	loc_b_0362		; Jump if equal
		and	ah,7Fh
		mov	bx,d_0000_0003_e	; 3 keys
loc_b_0330:
		cmp	ds:d_0000_881A_e[bx],ah
		jne	loc_b_033B		; Jump if not equal
		mov	byte ptr ds:d_0000_881A_e[bx],0FFh
loc_b_033B:
		dec	bx
		jns	loc_b_0330		; Jump if not sign
		jmp	short loc_b_0362
loc_b_0340:
		mov	ss:data_d_005A,0
		cmp	byte ptr ds:d_0000_0100_e,7Fh
		jne	loc_b_0365		; Jump if not equal
		mov	byte ptr ds:d_0000_0100_e,0FFh
		test	byte ptr ds:d_0000_8818_e,0FFh
		jz	loc_b_0362		; Jump if zero
		mov	byte ptr ds:d_0000_8818_e,0
		call	sub_b_4E4F
loc_b_0362:
		jmp	short loc_b_03CB
		db	90h
loc_b_0365:
		mov	al,ah
		mov	bx,d_0000_8855_e
		xlat				; al=[al+[bx]] table
		test	al,al
		js	loc_b_0376		; Jump if sign=1
		cbw				; Convrt byte to word
		xchg	bx,ax
		jmp	word ptr ss:data_d_001E[bx]	;*
loc_b_0376:
		cmp	byte ptr ds:d_0000_8922_e,0FFh
		je	loc_b_03C8		; Jump if equal
		cmp	byte ptr ds:d_0000_8853_e,1
		je	loc_b_03C8		; Jump if equal
		test	byte ptr ds:d_0000_8819_e,0FFh
		jz	loc_b_03C8		; Jump if zero
		xor	bx,bx			; Zero register
loc_b_038D:
		cmp	byte ptr ds:d_0000_8922_e[bx],0FFh
		je	loc_b_03C5		; Jump if equal
		cmp	al,ds:d_0000_8922_e[bx]
		lea	bx,[bx+3]		; Load effective addr
		jnz	loc_b_038D		; Jump if not zero
		mov	bx,ds:d_0000_8920_e[bx]
		test	bl,bl
		js	loc_b_03C8		; Jump if sign=1
		mov	al,bh
		mov	bh,0
		test	al,1
		jz	loc_b_03B9		; Jump if zero
		add	ds:d_0000_881A_e[bx],al
		jno	loc_b_03CB		; Jump if not overflw
		shl	al,1			; Shift w/zeros fill
		mov	al,7Fh
		adc	al,0
loc_b_03B9:
		cmp	al,2
		jne	loc_b_03BF		; Jump if not equal
		mov	al,ah
loc_b_03BF:
		mov	ds:d_0000_881A_e[bx],al
		jmp	short loc_b_03CB
loc_b_03C5:
		call	sub_b_0632
loc_b_03C8:
		mov	ds:d_0000_0100_e,ax
loc_b_03CB:
		pop	ds
		pop	bx
		pop	ax
		iret				; Interrupt return
			                        ;* No entry point to code
		xor	byte ptr ds:data_b_8852_e,2
		jmp	short loc_b_03CB
			                        ;* No entry point to code
		cmp	byte ptr ds:data_b_82B1_e,0Fh
		jne	loc_b_03CB		; Jump if not equal
		xor	byte ptr ds:data_b_8853_e,1
		jmp	short loc_b_03CB
			                        ;* No entry point to code
		xor	byte ptr ds:data_b_8854_e,4
		jmp	short loc_b_0400
			                        ;* No entry point to code
		mov	al,ds:data_b_8817_e
		inc	al
		jmp	short loc_b_03F7
		db	0A0h, 17h, 88h,0FEh,0C8h
loc_b_03F7:
		jz	loc_b_03CB		; Jump if zero
		cmp	al,2Eh			; '.'
		ja	loc_b_03CB		; Jump if above
		mov	ds:data_b_8817_e,al
loc_b_0400:
		call	sub_b_075D
		jmp	short loc_b_03CB
			                        ;* No entry point to code
		assume	ds:seg_b
		cmp	byte ptr data_b_0100+1,1Dh
		je	loc_b_0413		; Jump if equal
		cmp	byte ptr data_b_0100+1,38h	; '8'
		jne	loc_b_03CB		; Jump if not equal
loc_b_0413:
		call	sub_b_072E		; Install/restore interrupt handlers
		or	byte ptr es:d_B800_0410_e,30h	; '0'
		mov	ax,3
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		jmp	dword ptr ds:data_b_8812_e
			                        ;* No entry point to code
		test	byte ptr ds:data_b_8819_e,0FFh
		jz	loc_b_03CB		; Jump if zero
		push	data_b_0100
		mov	byte ptr data_b_0100,7Fh
		mov	ss:data_d_005A,0
loc_b_043C:
		call	sub_b_0462
		js	loc_b_045B		; Jump if sign=1
		cmp	ss:data_d_005A,0CCCh
		jb	loc_b_043C		; Jump if below
		xor	byte ptr ds:data_b_8818_e,1
		call	sub_b_4E4F
		mov	ss:data_d_005A,0C16h
		jmp	short loc_b_043C
loc_b_045B:
		pop	data_b_0100
		jmp	loc_b_03CB

PATROL		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0462	proc	near
		mov	ax,data_b_0100
		test	al,al
		retn
sub_b_0462	endp

loc_b_0468:
		call	sub_b_0462
		jns	loc_b_0468		; Jump if not sign

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_046D	proc	near
		and	byte ptr data_b_0100,7Fh
		retn
sub_b_046D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0473	proc	near
		push	ax
		push	ax
		xor	ax,ax			; Zero register
		mov	ds:data_b_8818_e,al
		mov	es,ax
		and	byte ptr es:d_0000_0410_e,0CFh
		or	byte ptr es:d_0000_0410_e,20h	; ' '
		mov	ax,4
		mov	ds:data_b_8819_e,al
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		mov	ah,0Bh
		pop	bx
		mov	bl,bh
		mov	bh,1
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	ah,0Bh
		pop	bx
		mov	bh,0
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		jmp	loc_b_075D
loc_b_04A3:
		mov	sp,1EEh
		xor	ax,ax			; Zero register
		mov	ds:data_b_8818_e,al
		mov	ss:data_d_005A,ax
		mov	ds:data_b_8819_e,al
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al
		call	sub_b_075D
loc_b_04B7:
		mov	si,data_b_81E0_e
		call	sub_b_078D
		call	sub_b_046D
loc_b_04C0:
		mov	si,data_b_84B7_e
		cmp	ss:data_d_005A,1F4h
		jb	loc_b_04CF		; Jump if below
		jmp	loc_b_4DFD
loc_b_04CF:
		lodsw				; String [si] to ax
		mov	bx,ax
		inc	ax
		jz	loc_b_04E7		; Jump if zero
		lodsw				; String [si] to ax
		cmp	al,[bx]
		lodsw				; String [si] to ax
		xchg	bx,ax
		lodsw				; String [si] to ax
		jz	loc_b_04DE		; Jump if zero
		xchg	bx,ax
loc_b_04DE:
		xchg	si,bx
		call	sub_b_078D
		xchg	si,bx
		jmp	short loc_b_04CF
loc_b_04E7:
		mov	bl,ds:data_b_8851_e
		mov	bh,0
		shl	bx,1			; Shift w/zeros fill
		mov	si,ds:data_b_8923_e[bx]
		call	sub_b_078D
		call	sub_b_0462
		jns	loc_b_04C0		; Jump if not sign
		call	sub_b_046D
		cmp	ah,2Dh			; '-'
		je	loc_b_050A		; Jump if equal
		cmp	ah,2Eh			; '.'
		je	loc_b_054B		; Jump if equal
		jmp	short loc_b_04C0
loc_b_050A:
		mov	si,data_b_84D9_e
		call	sub_b_078D
		mov	si,851Ch
		call	sub_b_0545
		mov	al,1
		xor	al,1
		mov	ds:data_b_8853_e,al
		mov	ax,53Dh
		mov	bx,542h
		call	sub_b_05BF
		jc	loc_b_0535		; Jump if carry Set
		mov	byte ptr ds:data_b_8853_e,1
		mov	si,85EBh
		call	sub_b_0545
		jmp	short loc_b_04B7
loc_b_0535:
		mov	si,8612h
		call	sub_b_0545
		jmp	short loc_b_050A
			                        ;* No entry point to code
		mov	si,data_b_85A5_e
		jmp	short loc_b_0545
		db	0BEh,0C8h, 85h

;==== External Entry into Subroutine ======================================

sub_b_0545:
loc_b_0545:
		call	sub_b_078D
		jmp	loc_b_0468
loc_b_054B:
		mov	si,data_b_88A9_e
loc_b_054E:
		lodsw				; String [si] to ax
		xchg	bx,ax
		inc	bx
		jz	loc_b_056D		; Jump if zero
		lodsw				; String [si] to ax
		dec	bx
		jz	loc_b_054E		; Jump if zero
		mov	cx,53h
		mov	di,data_b_8856_e
		push	ds
		pop	es
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		sub	di,8856h
		mov	al,ds:data_b_876A_e[di]
		mov	[bx],al
		jmp	short loc_b_054E
loc_b_056D:
		mov	si,data_b_84D9_e
		call	sub_b_078D
		mov	si,data_b_88BB_e
		call	sub_b_078D
		mov	si,8679h
		call	sub_b_0545
		mov	al,ah
		cbw				; Convrt byte to word
		xchg	si,ax
		mov	al,ds:data_b_876A_e[si]
		mov	ds:data_b_8712_e,al
		push	si
		mov	si,86E0h
		call	sub_b_0545
		mov	al,ah
		cbw				; Convrt byte to word
		pop	si
		xchg	di,ax
		mov	al,ds:data_b_8855_e[si]
		xchg	ds:data_b_8855_e[di],al
		mov	ds:data_b_8855_e[si],al
		mov	al,ds:data_b_876A_e[si]
		mov	ds:data_b_872B_e,al
		mov	al,ds:data_b_876A_e[di]
		mov	ds:data_b_8742_e,al
		mov	al,1
		xor	al,1
		mov	ds:data_b_8853_e,al
		mov	si,8725h
		call	sub_b_0545
		jmp	short loc_b_054B

;==== External Entry into Subroutine ======================================

sub_b_05BF:
		push	bx
		push	ax
		mov	byte ptr ds:data_b_82B1_e,0F0h
		mov	bx,8832h
		call	sub_b_06AB
		pop	ax
		pop	bx
		jc	loc_b_0624		; Jump if carry Set
		push	bx
		call	ax			;*
		mov	bx,8836h
		call	sub_b_06AB
		pop	bx
		jc	loc_b_0624		; Jump if carry Set
		call	bx			;*
		mov	bx,883Ah
		call	sub_b_06AB
		jc	loc_b_0624		; Jump if carry Set
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	si,si			; Zero register
loc_b_05EC:
		mov	ax,8000h
		xor	dx,dx			; Zero register
		mov	cl,ds:data_b_8836_e[bx]
		sub	cl,ds:data_b_8832_e[bx]
		jbe	loc_b_0624		; Jump if below or =
		div	cx			; ax,dx rem=dx:ax/reg
		mov	ds:data_b_8822_e[si],ax
		mov	ax,8000h
		xor	dx,dx			; Zero register
		mov	cl,ds:data_b_883A_e[bx]
		sub	cl,ds:data_b_8836_e[bx]
		jbe	loc_b_0624		; Jump if below or =
		div	cx			; ax,dx rem=dx:ax/reg
		mov	ds:data_b_882A_e[si],ax
		inc	bx
		inc	si
		inc	si
		cmp	bl,2
		jne	loc_b_05EC		; Jump if not equal
		mov	byte ptr ds:data_b_82B1_e,0Fh
		retn
loc_b_0624:
		stc				; Set carry flag
		retn
			                        ;* No entry point to code
		mov	word ptr ds:data_b_881A_e,0FFFFh
		mov	word ptr ds:data_b_881C_e,0FFFFh

;==== External Entry into Subroutine ======================================

sub_b_0632:
		mov	word ptr ds:d_0000_881E_e,0
		mov	word ptr ds:d_0000_8820_e,0
		retn

;==== External Entry into Subroutine ======================================

sub_b_063F:
		cmp	byte ptr ds:data_b_8853_e,1
		jne	loc_b_0681		; Jump if not equal
		mov	bx,881Eh
		call	sub_b_06AB
		jc	loc_b_0681		; Jump if carry Set
		xor	bx,bx			; Zero register
		xor	si,si			; Zero register
loc_b_0652:
		mov	al,ds:data_b_881E_e[bx]
		mov	ah,0
		cmp	al,ds:data_b_8836_e[bx]
		je	loc_b_0675		; Jump if equal
		ja	loc_b_066D		; Jump if above
		sub	al,ds:data_b_8832_e[bx]
		mul	word ptr ds:data_b_8822_e[si]	; dx:ax = data * ax
		sub	ah,80h
		jmp	short loc_b_0675
loc_b_066D:
		sub	al,ds:data_b_8836_e[bx]
		mul	word ptr ds:data_b_882A_e[si]	; dx:ax = data * ax
loc_b_0675:
		mov	ds:data_b_881E_e[bx],ah
		inc	bx
		inc	si
		inc	si
		cmp	bl,2
		jne	loc_b_0652		; Jump if not equal
loc_b_0681:
		mov	ax,ds:data_b_881E_e
		mov	bx,ds:data_b_8820_e
		retn

;==== External Entry into Subroutine ======================================

sub_b_0689:
		cmp	byte ptr ds:data_b_8853_e,1
		je	loc_b_0698		; Jump if equal
		mov	ax,ds:data_b_881A_e
		mov	bx,ds:data_b_881C_e
		retn
loc_b_0698:
		push	dx
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		mov	bh,al
		shl	al,1			; Shift w/zeros fill
		mov	bl,al
		shl	al,1			; Shift w/zeros fill
		mov	ah,al
		shl	al,1			; Shift w/zeros fill
		pop	dx
		retn

;==== External Entry into Subroutine ======================================

sub_b_06AB:
		push	bx
		cli				; Disable interrupts
		mov	byte ptr ds:data_b_883E_e,0FFh
		mov	ax,0FC00h
		mov	bx,data_b_7F00_e
		mov	cx,100h
		mov	dx,201h
		xor	si,si			; Zero register
		xor	di,di			; Zero register
		out	dx,al			; port 201h, start game 1-shots

locloop_b_06C3:
		out	43h,al			; port 43h, 8253 timer control
						;  al = 0, latch timer0 count
		in	al,dx			; port 201h, start game 1-shots
		and	al,bh
		or	al,ah
		cmp	al,ds:data_b_883E_e[di]
		adc	di,si
		mov	ds:data_b_883E_e[di],al
		in	al,40h			; port 40h, 8253 timer 0 clock
		mov	ds:data_b_8844_e[di],al
		in	al,40h			; port 40h, 8253 timer 0 clock
		mov	ds:data_b_884A_e[di],al
		and	ax,bx
		test	byte ptr ds:data_b_883E_e[di],3
		loopnz	locloop_b_06C3		; Loop if zf=0, cx>0

		sti				; Enable interrupts
		pop	bx
		stc				; Set carry flag
		jnz	loc_ret_b_072D		; Jump if not zero
		mov	al,ds:data_b_8844_e
		mov	ah,ds:data_b_884A_e
		xchg	bp,ax
		mov	ch,0
		mov	dl,0
loc_b_06FA:
		mov	cl,ds:data_b_883E_e[di]
		and	cl,3
		xor	cl,dl
		xor	dl,cl
		mov	si,0FFFFh
loc_b_0708:
		jcxz	loc_b_0729		; Jump if cx=0
		inc	si
		shr	cl,1			; Shift w/zeros fill
		jnc	loc_b_0708		; Jump if carry=0
		mov	al,ds:data_b_8844_e[di]
		mov	ah,ds:data_b_884A_e[di]
		sub	ax,bp
		neg	ax
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		mov	[bx+si],al
		jmp	short loc_b_0708
loc_b_0729:
		dec	di
		jns	loc_b_06FA		; Jump if not sign
		clc				; Clear carry flag

loc_ret_b_072D:
		retn

;==== External Entry into Subroutine ======================================

; Install/restore interrupt handlers

sub_b_072E:
		xor	bp,bp			; Zero register
		mov	es,bp
loc_b_0732:
		assume	ss:seg_b
		mov	bx,data_b_0004[bp]
		test	bx,bx
		js	loc_ret_b_075C		; Jump if sign=1
		mov	cx,data_b_0006[bp]
		mov	dx,data_b_0008[bp]
		test	dx,dx
		jnz	loc_b_0748		; Jump if not zero
		mov	dx,cs
loc_b_0748:
		xchg	es:[bx],cx
		xchg	es:[bx+2],dx
		mov	data_b_0006[bp],cx
		mov	data_b_0008[bp],dx
		add	bp,6
		jmp	short loc_b_0732

loc_ret_b_075C:
		retn

;==== External Entry into Subroutine ======================================

sub_b_075D:
loc_b_075D:
		push	dx
		mov	dx,3D4h
		mov	ax,0FF0Eh
		out	dx,ax			; port 3D4h, CGA/EGA reg index
						;  al = 0Eh, cursor position hi
		mov	ax,0A03h
		out	dx,ax			; port 3D4h, CGA/EGA reg index
						;  al = 3, horiz sync width
		dec	ax
		mov	ah,ds:data_b_8817_e
		out	dx,ax			; port 3D4h, CGA/EGA reg index
						;  al = 2, horz sync position
		mov	dx,3DAh
		in	al,dx			; port 3DAh, CGA/EGA vid status
		mov	al,0
		out	dx,al			; port 3DAh, VGA feature contrl
		test	byte ptr ds:data_b_8819_e,0FFh
		mov	al,28h			; '('
		jz	loc_b_0781		; Jump if zero
		or	al,2
loc_b_0781:
		xor	al,ds:data_b_8854_e
		and	al,7Fh
		out	dx,al			; port 3DAh, VGA feature contrl
		dec	dx
		dec	dx
		out	dx,al			; port 3D8h, CGA video control
		pop	dx
		retn
sub_b_0473	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_078D	proc	near
loc_b_078D:
		mov	ax,0B800h
		mov	es,ax
		lodsb				; String [si] to al
		cmp	al,0FFh
		jne	loc_b_0798		; Jump if not equal
		retn
loc_b_0798:
		mov	ah,50h			; 'P'
		mul	ah			; ax = reg * al
		add	ax,4
		xchg	di,ax
		lodsb				; String [si] to al
		and	al,44h			; 'D'
		mov	ah,al
		mov	cx,20h

locloop_b_07A8:
		jz	loc_b_07B3		; Jump if zero
		lodsb				; String [si] to al
		cmp	al,7Eh			; '~'
		jne	loc_b_07B3		; Jump if not equal
		inc	ax
		mov	al,es:[di]
loc_b_07B3:
		stosw				; Store ax to es:[di]
		loop	locloop_b_07A8		; Loop if cx > 0

		jmp	short loc_b_078D
sub_b_078D	endp

		db	8 dup (0)
		db	0B0h, 00h,0FEh,0C0h,0FEh,0C8h
		db	0E8h,0A8h, 46h,0E8h,0F7h, 00h
		db	0E9h,0D1h
		db	2Ah
loc_b_07CF:
		mov	cl,8
		mov	bl,4Eh			; 'N'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'                        @'
loc_b_07F3:
		mov	cl,0
		inc	cl
		dec	cl
		mov	sp,1EEh
		call	sub_b_0BA0
		mov	al,data_b_0049
		rcl	ah,1			; Rotate thru carry
		and	al,7
		rcr	ah,1			; Rotate thru carry
		jz	loc_b_080D		; Jump if zero
		jmp	short loc_b_0810
		db	90h
loc_b_080D:
		call	sub_b_3FE3
loc_b_0810:
		inc	data_b_0049
		mov	al,data_b_0049
		rcl	ah,1			; Rotate thru carry
		and	al,1
		rcr	ah,1			; Rotate thru carry
		jz	loc_b_0822		; Jump if zero
		jmp	short loc_b_0825
		db	90h
loc_b_0822:
		call	sub_b_1FDB
loc_b_0825:
		dec	data_b_00F3
		js	loc_b_082E		; Jump if sign=1
		jmp	short loc_b_083A
		db	90h
loc_b_082E:
		mov	al,16h
		inc	al
		dec	al
		mov	data_b_00F3,al
		call	sub_b_20E8
loc_b_083A:
		mov	al,data_b_00DD
		inc	al
		dec	al
		jz	loc_b_0846		; Jump if zero
		jmp	short loc_b_0855
		db	90h
loc_b_0846:
		mov	al,data_b_0096
		inc	al
		dec	al
		jz	loc_b_0852		; Jump if zero
		jmp	short loc_b_0855
		nop
loc_b_0852:
		jmp	short loc_b_085B
			                        ;* No entry point to code
		nop
loc_b_0855:
		call	sub_b_3EB2
		call	sub_b_10B1
loc_b_085B:
		call	sub_b_16A4
		call	sub_b_0EF3
		call	sub_b_19E8
		call	sub_b_26EE
		call	sub_b_3DC1
		call	sub_b_44FB
		call	sub_b_45DE
		call	sub_b_10E0
		call	sub_b_440A
		call	sub_b_1567
		call	sub_b_2DC1
		call	sub_b_2B97
		call	sub_b_2A54
		mov	al,data_b_0070
		inc	al
		dec	al
		jnz	loc_b_088E		; Jump if not zero
		jmp	short loc_b_0891
		db	90h
loc_b_088E:
		jmp	loc_b_3A05
loc_b_0891:
		call	sub_b_0982
		call	sub_b_13AB
		call	sub_b_1E17
		call	sub_b_2993
		call	sub_b_4BAE
		call	sub_b_1C08
		call	sub_b_140D
		jnz	loc_b_08AB		; Jump if not zero
		jmp	short loc_b_08C0
		db	90h
loc_b_08AB:
		call	sub_b_4064
		call	sub_b_1503
		call	sub_b_4869
		call	sub_b_4714
		call	sub_b_46D1
		call	sub_b_140D
		call	sub_b_47CC
loc_b_08C0:
		jmp	loc_b_07F3

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_08C3	proc	near
		mov	al,0
		mov	byte ptr ds:[222h],al
		mov	al,0
		mov	byte ptr ds:[22Ah],al

;==== External Entry into Subroutine ======================================

sub_b_08CD:
		mov	al,22h			; '"'
		mov	data_b_006E,al
		mov	al,15h
		mov	data_b_0041,al
		mov	data_b_0043,al
		mov	al,0
		mov	data_b_0028,al
		mov	data_b_0029,al
		mov	data_b_00C0,al
		mov	data_b_00BB,al
		mov	data_b_00BD,al
		mov	al,0Eh
		mov	data_b_0046,al
		mov	al,10h
		mov	data_b_006D,al
		mov	al,1
		mov	data_b_006F,al
		mov	data_b_0067,al
		mov	data_b_0054,al
		mov	data_b_0097,al
		mov	al,4
		mov	data_b_00AF,al
		mov	al,0FFh
		mov	data_b_0078,al
		mov	al,0FFh
		mov	data_b_004A,al
		mov	al,0
		mov	data_b_0098,al
		mov	data_b_00DD,al
		mov	data_b_0096,al
		mov	data_b_0070,al
		mov	data_b_0049,al
		mov	byte ptr ds:[39h],al
		mov	data_b_0031,al
		mov	data_b_0023,al
		mov	data_b_0048,al
		mov	al,70h			; 'p'
		mov	byte ptr data_b_005A+1,al
		sub	al,4
		cmc				; Complement carry
		mov	data_b_0057,al
		mov	al,7Ah			; 'z'
		mov	byte ptr data_b_005C+1,al
		mov	al,8Ah
		mov	data_b_005F,al
		mov	al,85h
		mov	data_b_0058,al
		mov	al,8Eh
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al
		mov	al,70h			; 'p'
		mov	byte ptr data_b_000C+3,al
		mov	al,2
		mov	byte ptr data_b_0006+1,al
		mov	al,0
		mov	data_b_0010,al
		mov	data_b_0013,al
		mov	data_b_001A,al
		call	sub_b_096D
		retn
sub_b_08C3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_096D	proc	near
		mov	cl,2
		mov	al,0
loc_b_0971:
		mov	si,cx
		mov	data_b_00E8[si],al
		mov	data_b_00EB[si],al
		dec	cl
		js	loc_ret_b_0981		; Jump if sign=1
		jmp	short loc_b_0971

loc_ret_b_0981:
		retn
sub_b_096D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0982	proc	near
		mov	al,data_b_0059
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,1
		mov	bl,byte ptr data_b_005A
		call	sub_b_5034
		mov	al,data_b_0061
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_0062
		call	sub_b_5034
		mov	al,data_b_0063
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_0064
		call	sub_b_5034
		mov	al,data_b_0065
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_0066
		call	sub_b_5034

;==== External Entry into Subroutine ======================================

sub_b_09CA:
		mov	al,data_b_0057
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	bl,data_b_0058
		mov	al,1
		call	sub_b_5015
		mov	al,byte ptr data_b_005A+1
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,byte ptr data_b_005C
		call	sub_b_5015
		mov	al,byte ptr data_b_005C+1
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_005E
		call	sub_b_5015
		mov	al,data_b_005F
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_0060
		call	sub_b_5015
		mov	al,data_b_0067
		inc	al
		dec	al
		jz	loc_b_0A1E		; Jump if zero
		jmp	short loc_b_0A91
		db	90h
loc_b_0A1E:
		mov	al,byte ptr data_b_000C+3
		add	al,data_b_0010
		cmp	al,2Ch			; ','
		cmc				; Complement carry
		jnc	loc_b_0A2D		; Jump if carry=0
		jmp	short loc_b_0A43
		db	90h
loc_b_0A2D:
		mov	al,2Ch			; ','
		mov	byte ptr data_b_000C+3,al
		mov	al,0
		mov	data_b_0010,al
		mov	al,2
		inc	al
		dec	al
		mov	byte ptr data_b_0006+1,al
		jmp	short loc_b_0A91
		db	90h
loc_b_0A43:
		cmp	al,6Dh			; 'm'
		cmc				; Complement carry
		jc	loc_b_0A4B		; Jump if carry Set
		jmp	short loc_b_0A61
		db	90h
loc_b_0A4B:
		mov	al,6Ch			; 'l'
		mov	byte ptr data_b_000C+3,al
		mov	al,2
		mov	byte ptr data_b_0006+1,al
		mov	al,0
		inc	al
		dec	al
		mov	data_b_0010,al
		jmp	short loc_b_0A91
		db	90h
loc_b_0A61:
		mov	byte ptr data_b_000C+3,al
		cmp	al,37h			; '7'
		cmc				; Complement carry
		jnc	loc_b_0A6C		; Jump if carry=0
		jmp	short loc_b_0A78
		db	90h
loc_b_0A6C:
		mov	al,4
		inc	al
		dec	al
		mov	data_b_00AF,al
		jmp	short loc_b_0A91
		db	90h
loc_b_0A78:
		cmp	al,56h			; 'V'
		cmc				; Complement carry
		jnc	loc_b_0A80		; Jump if carry=0
		jmp	short loc_b_0A8C
		db	90h
loc_b_0A80:
		mov	al,6
		inc	al
		dec	al
		mov	data_b_00AF,al
		jmp	short loc_b_0A91
		db	90h
loc_b_0A8C:
		mov	al,6
		mov	data_b_00AF,al
loc_b_0A91:
		mov	al,data_b_0057
		mov	data_b_0059,al
		mov	al,data_b_0058
		mov	byte ptr data_b_005A,al
		mov	al,byte ptr data_b_005A+1
		mov	data_b_0061,al
		mov	al,byte ptr data_b_005C+1
		mov	data_b_0063,al
		mov	al,data_b_005F
		mov	data_b_0065,al
		mov	al,byte ptr data_b_005C
		mov	data_b_0062,al
		mov	al,data_b_005E
		mov	data_b_0064,al
		mov	al,data_b_0060
		mov	data_b_0066,al
		mov	al,byte ptr data_b_000C+3
		mov	byte ptr data_b_005A+1,al
		sub	al,4
		mov	data_b_0057,al
		add	al,0Eh
		mov	byte ptr data_b_005C+1,al
		add	al,10h
		mov	data_b_005F,al
		mov	al,data_b_006D
		inc	al
		dec	al
		jns	loc_b_0AE2		; Jump if not sign
		jmp	short loc_b_0AE5
		db	90h
loc_b_0AE2:
		jmp	loc_b_2CD7
loc_b_0AE5:
		mov	al,data_b_0013
		inc	al
		dec	al
		jnz	loc_b_0AF1		; Jump if not zero
		jmp	short loc_b_0AF4
		db	90h
loc_b_0AF1:
		jmp	loc_b_1064
loc_b_0AF4:
		mov	al,2
		inc	al
		dec	al
		call	sub_b_31E0
		sub	al,1
		cmc				; Complement carry
		adc	al,byte ptr data_b_005C
		mov	byte ptr data_b_005C,al
		mov	al,2
		inc	al
		dec	al
		call	sub_b_31E0
		sub	al,1
		cmc				; Complement carry
		adc	al,data_b_0060
		mov	data_b_0060,al
		mov	al,2
		inc	al
		dec	al
		call	sub_b_31E0
		sub	al,1
		cmc				; Complement carry
		adc	al,data_b_005E
		mov	data_b_005E,al
		mov	al,byte ptr data_b_005C
		cmp	al,8Dh
		cmc				; Complement carry
		jz	loc_b_0B38		; Jump if zero
		jmp	short loc_b_0B3D
		db	90h
loc_b_0B38:
		mov	al,8Fh
		mov	byte ptr data_b_005C,al
loc_b_0B3D:
		mov	al,byte ptr data_b_005C
		cmp	al,92h
		cmc				; Complement carry
		jz	loc_b_0B48		; Jump if zero
		jmp	short loc_b_0B4D
		db	90h
loc_b_0B48:
		mov	al,8Fh
		mov	byte ptr data_b_005C,al
loc_b_0B4D:
		mov	al,data_b_005E
		cmp	al,8Dh
		cmc				; Complement carry
		jz	loc_b_0B58		; Jump if zero
		jmp	short loc_b_0B5D
		db	90h
loc_b_0B58:
		mov	al,8Fh
		mov	data_b_005E,al
loc_b_0B5D:
		mov	al,data_b_005E
		cmp	al,92h
		cmc				; Complement carry
		jz	loc_b_0B68		; Jump if zero
		jmp	short loc_b_0B6D
		db	90h
loc_b_0B68:
		mov	al,8Fh
		mov	data_b_005E,al
loc_b_0B6D:
		mov	al,data_b_0060
		cmp	al,8Dh
		cmc				; Complement carry
		jz	loc_b_0B78		; Jump if zero
		jmp	short loc_b_0B7D
		db	90h
loc_b_0B78:
		mov	al,8Fh
		mov	data_b_0060,al
loc_b_0B7D:
		mov	al,data_b_0060
		cmp	al,92h
		cmc				; Complement carry
		jz	loc_b_0B88		; Jump if zero
		jmp	short loc_b_0B8D
		db	90h
loc_b_0B88:
		mov	al,8Fh
		mov	data_b_0060,al
loc_b_0B8D:
		mov	al,data_b_005E
		sub	al,byte ptr data_b_005C
		add	al,86h
		mov	data_b_0058,al
		retn
sub_b_0982	endp

loc_b_0B9A:
		jmp	loc_b_4DDA
		jmp	loc_b_32DE

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0BA0	proc	near
		mov	al,byte ptr ds:[225h]
		inc	al
		dec	al
		jnz	loc_b_0BAC		; Jump if not zero
		jmp	short loc_b_0C11
		db	90h
loc_b_0BAC:
		mov	al,byte ptr data_b_0100
		inc	al
		dec	al
		js	loc_b_0BB8		; Jump if sign=1
		jmp	short loc_b_0BD6
		db	90h
loc_b_0BB8:
		cmp	al,0A0h
		cmc				; Complement carry
		jz	loc_b_0BC0		; Jump if zero
		jmp	short loc_b_0BD6
		db	90h
loc_b_0BC0:
		mov	al,data_b_00EF
		mov	al,data_b_00F0
		mov	byte ptr ds:[216h],al
		mov	al,data_b_00F1
		inc	al
		dec	al
		mov	byte ptr ds:[217h],al
		jmp	loc_b_32DE
loc_b_0BD6:
		dec	byte ptr ds:[224h]
		jz	loc_b_0BDF		; Jump if zero
		jmp	short loc_ret_b_0C10
		db	90h
loc_b_0BDF:
		inc	byte ptr ds:[223h]
		mov	cl,byte ptr ds:[223h]
		mov	si,cx
		mov	al,byte ptr ds:[0D63h][si]
		cmp	al,0FFh
		cmc				; Complement carry
		jnz	loc_b_0BF4		; Jump if not zero
		jmp	short loc_b_0B9A
loc_b_0BF4:
		push	ax
		inc	byte ptr ds:[223h]
		mov	cl,byte ptr ds:[223h]
		mov	si,cx
		mov	al,byte ptr ds:[0D63h][si]
		add	al,1
		mov	byte ptr ds:[224h],al
		pop	ax
		inc	al
		dec	al
		jmp	short loc_b_0C36
		db	90h

loc_ret_b_0C10:
		retn
loc_b_0C11:
		mov	al,byte ptr data_b_0100
		inc	al
		dec	al
		jns	loc_b_0C1D		; Jump if not sign
		jmp	short loc_b_0C36
		db	90h
loc_b_0C1D:
		mov	al,byte ptr ds:[222h]
		inc	al
		dec	al
		jnz	loc_b_0C29		; Jump if not zero
		jmp	short loc_b_0C2D
		db	90h
loc_b_0C29:
		inc	byte ptr ds:[223h]
loc_b_0C2D:
		mov	al,0FFh
		inc	al
		dec	al
		jmp	loc_b_0CB8
loc_b_0C36:
		call	sub_b_4E83
		mov	byte ptr ds:[0],al
		mov	al,byte ptr ds:[222h]
		inc	al
		dec	al
		jnz	loc_b_0C48		; Jump if not zero
		jmp	short loc_b_0C6F
		db	90h
loc_b_0C48:
		mov	al,byte ptr ds:[223h]
		mov	cl,byte ptr ds:[224h]
		mov	si,cx
		mov	byte ptr ds:[300h][si],al
		inc	byte ptr ds:[224h]
		mov	cl,byte ptr ds:[224h]
		mov	al,byte ptr ds:[0]
		mov	si,cx
		mov	byte ptr ds:[300h][si],al
		inc	byte ptr ds:[224h]
		mov	al,0
		mov	byte ptr ds:[223h],al
loc_b_0C6F:
		mov	al,byte ptr ds:[0]
		cmp	al,9Bh
		cmc				; Complement carry
		jz	loc_b_0C7A		; Jump if zero
		jmp	short loc_b_0C80
		db	90h
loc_b_0C7A:
		call	sub_b_4E70
		jmp	short loc_b_0CB8
		db	90h
loc_b_0C80:
		cmp	al,0D2h
		cmc				; Complement carry
		jz	loc_b_0C88		; Jump if zero
		jmp	short loc_b_0C9C
		db	90h
loc_b_0C88:
		mov	al,1
		mov	byte ptr ds:[222h],al
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[223h],al
		mov	byte ptr ds:[224h],al
		jmp	short loc_b_0CB8
		db	90h
loc_b_0C9C:
		cmp	al,8Fh
		cmc				; Complement carry
		jz	loc_b_0CA4		; Jump if zero
		jmp	short loc_b_0CAD
		db	90h
loc_b_0CA4:
		call	sub_b_44DD
		call	sub_b_4E72
		jmp	loc_b_32DE
loc_b_0CAD:
		cmp	al,91h
		cmc				; Complement carry
		jz	loc_b_0CB5		; Jump if zero
		jmp	short loc_b_0CB8
		db	90h
loc_b_0CB5:
		jmp	loc_b_0413
loc_b_0CB8:
		push	ax
		mov	al,ds:data_b_8853_e
		inc	al
		dec	al
		jnz	loc_b_0CC5		; Jump if not zero
		jmp	short loc_b_0CD8
		db	90h
loc_b_0CC5:
		rcl	ah,1			; Rotate thru carry
		test	byte ptr ds:[225h],0FFh
		rcr	ah,1			; Rotate thru carry
		jnz	loc_b_0CD8		; Jump if not zero
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_0D93
loc_b_0CD8:
		pop	ax
		cmp	al,0A0h
		cmc				; Complement carry
		jz	loc_b_0CE1		; Jump if zero
		jmp	short loc_b_0CE4
		db	90h
loc_b_0CE1:
		jmp	loc_b_0E3F
loc_b_0CE4:
		cmp	al,0C1h
		cmc				; Complement carry
		jz	loc_b_0CEC		; Jump if zero
		jmp	short loc_b_0CEF
		nop
loc_b_0CEC:
		jmp	short loc_b_0D6B
		db	90h
loc_b_0CEF:
		cmp	al,88h
		cmc				; Complement carry
		jz	loc_b_0CF7		; Jump if zero
		jmp	short loc_b_0CFA
		nop
loc_b_0CF7:
		jmp	short loc_b_0D2B
		db	90h
loc_b_0CFA:
		cmp	al,95h
		cmc				; Complement carry
		jz	loc_b_0D02		; Jump if zero
		jmp	short loc_b_0D05
		nop
loc_b_0D02:
		jmp	short loc_b_0D4B
		db	90h
loc_b_0D05:
		cmp	al,0FFh
		cmc				; Complement carry
		jnz	loc_b_0D0D		; Jump if not zero
		jmp	short loc_ret_b_0D16
		db	90h
loc_b_0D0D:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_0010,al

loc_ret_b_0D16:
		retn
			                        ;* No entry point to code
		mov	al,0
		inc	al
		dec	al
		mov	ds:data_b_8853_e,al
		retn
		db	0B0h
data_b_0D22	db	1			; Data table (indexed access)
		db	0FEh,0C0h,0FEh,0C8h,0A2h, 53h
		db	 88h,0C3h

;==== External Entry into Subroutine ======================================

sub_b_0D2B:
loc_b_0D2B:
		mov	al,data_b_0013
		inc	al
		dec	al
		jz	loc_b_0D37		; Jump if zero
		jmp	short loc_ret_b_0D4A
		db	90h
loc_b_0D37:
		mov	al,0FCh
		mov	data_b_0010,al
		mov	al,0
		mov	data_b_009C,al
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr data_b_0006+1,al

loc_ret_b_0D4A:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0D4B:
loc_b_0D4B:
		mov	al,data_b_0013
		inc	al
		dec	al
		jz	loc_b_0D57		; Jump if zero
		jmp	short loc_ret_b_0D6A
		db	90h
loc_b_0D57:
		mov	al,4
		mov	data_b_0010,al
		mov	al,0
		mov	data_b_009C,al
		mov	al,3
		inc	al
		dec	al
		mov	byte ptr data_b_0006+1,al

loc_ret_b_0D6A:
		retn

;==== External Entry into Subroutine ======================================

sub_b_0D6B:
loc_b_0D6B:
		mov	al,data_b_0013
		inc	al
		dec	al
		jz	loc_b_0D77		; Jump if zero
		jmp	short loc_ret_b_0D92
		db	90h
loc_b_0D77:
		mov	al,0
		mov	data_b_0010,al
		mov	data_b_0015,al
		mov	al,4
		mov	data_b_0014,al
		mov	al,2
		mov	byte ptr data_b_0006+1,al
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0013,al

loc_ret_b_0D92:
		retn
loc_b_0D93:
		mov	cl,1
		call	sub_b_4E9A
		mov	al,bl
		cmp	al,76h			; 'v'
		cmc				; Complement carry
		jnc	loc_b_0DA2		; Jump if carry=0
		jmp	short loc_b_0DA5
		db	90h
loc_b_0DA2:
		call	sub_b_0D6B
loc_b_0DA5:
		call	sub_b_4EB4
		mov	byte ptr ds:[0],al
		rcl	ah,1			; Rotate thru carry
		xor	al,data_b_009E
		rcr	ah,1			; Rotate thru carry
		js	loc_b_0DB8		; Jump if sign=1
		jmp	short loc_b_0DCD
		db	90h
loc_b_0DB8:
		mov	al,byte ptr ds:[0]
		inc	al
		dec	al
		js	loc_b_0DC4		; Jump if sign=1
		jmp	short loc_b_0DCD
		db	90h
loc_b_0DC4:
		mov	data_b_009E,al
		call	sub_b_0E3F
		jmp	short loc_b_0DD3
		db	90h
loc_b_0DCD:
		mov	al,byte ptr ds:[0]
		mov	data_b_009E,al
loc_b_0DD3:
		mov	cl,0
		call	sub_b_4E9A
		mov	al,bl
		cmp	al,76h			; 'v'
		cmc				; Complement carry
		jnc	loc_b_0DE2		; Jump if carry=0
		jmp	short loc_b_0DE6
		db	90h
loc_b_0DE2:
		call	sub_b_0D2B
		retn
loc_b_0DE6:
		mov	cl,0
		call	sub_b_4E9A
		mov	al,bl
		cmp	al,8Ah
		cmc				; Complement carry
		jc	loc_b_0DF5		; Jump if carry Set
		jmp	short loc_b_0DF9
		db	90h
loc_b_0DF5:
		call	sub_b_0D4B
		retn
loc_b_0DF9:
		mov	al,byte ptr data_b_000C+3
		cmp	al,4Ah			; 'J'
		cmc				; Complement carry
		jnz	loc_b_0E04		; Jump if not zero
		jmp	short loc_b_0E35
			                        ;* No entry point to code
		nop
loc_b_0E04:
		jc	loc_b_0E09		; Jump if carry Set
		jmp	short loc_b_0E1F
		db	90h
loc_b_0E09:
		mov	al,data_b_0013
		inc	al
		dec	al
		jz	loc_b_0E15		; Jump if zero
		jmp	short loc_b_0E35
		db	90h
loc_b_0E15:
		mov	al,0FEh
		inc	al
		dec	al
		mov	data_b_0010,al
		retn
loc_b_0E1F:
		mov	al,data_b_0013
		inc	al
		dec	al
		jz	loc_b_0E2B		; Jump if zero
		jmp	short loc_b_0E35
		db	90h
loc_b_0E2B:
		mov	al,2
		inc	al
		dec	al
		mov	data_b_0010,al
		retn
loc_b_0E35:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_0010,al
		retn

;==== External Entry into Subroutine ======================================

sub_b_0E3F:
loc_b_0E3F:
		mov	al,data_b_001A
		inc	al
		dec	al
		jz	loc_b_0E4B		; Jump if zero
		jmp	short loc_b_0E77
		db	90h
loc_b_0E4B:
		mov	al,0
		mov	data_b_009D,al
		mov	al,data_b_0057
		add	al,2Eh			; '.'
		jnc	loc_b_0E5A		; Jump if carry=0
		jmp	short loc_b_0E77
		db	90h
loc_b_0E5A:
		mov	data_b_001A,al
		mov	al,data_b_0058
		add	al,9
		mov	data_b_001B,al
		mov	al,4
		mov	data_b_001C,al
		mov	al,3
		mov	cl,data_b_001A
		mov	bl,data_b_001B
		call	sub_b_5015
loc_b_0E77:
		mov	cl,0
loc_b_0E79:
		mov	si,cx
		mov	al,byte ptr ds:[0DEAh][si]
		inc	al
		dec	al
		jnz	loc_b_0E88		; Jump if not zero
		jmp	short loc_b_0E93
		db	90h
loc_b_0E88:
		inc	cl
		cmp	cl,4
		cmc				; Complement carry
		jz	loc_ret_b_0E92		; Jump if zero
		jmp	short loc_b_0E79

loc_ret_b_0E92:
		retn
loc_b_0E93:
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[0DFAh][si],al
		mov	al,data_b_0057
		add	al,5
		mov	byte ptr ds:[0DEAh][si],al
		mov	byte ptr ds:[0DF2h][si],al
		mov	al,data_b_0058
		sub	al,0Bh
		mov	byte ptr ds:[0DEEh][si],al
		mov	byte ptr ds:[0DF6h][si],al
		mov	bl,al
		mov	al,byte ptr ds:[0DEAh][si]
		mov	cl,al
		mov	al,2
		call	sub_b_5015
		mov	bl,0
		mov	al,1Ah
		mov	byte ptr ds:[0],al
loc_b_0EC9:
		call	sub_b_4E8B
loc_b_0ECC:
		dec	bl
		jz	loc_b_0ED3		; Jump if zero
		jmp	short loc_b_0EE2
		db	90h
loc_b_0ED3:
		dec	byte ptr ds:[0]
		mov	al,byte ptr ds:[0]
		cmp	al,10h
		cmc				; Complement carry
		jnz	loc_b_0EE2		; Jump if not zero
		jmp	short loc_ret_b_0EF2
		db	90h
loc_b_0EE2:
		dec	cl
		jz	loc_b_0EE8		; Jump if zero
		jmp	short loc_b_0ECC
loc_b_0EE8:
		mov	cl,byte ptr ds:[0]
		inc	cl
		dec	cl
		jmp	short loc_b_0EC9

loc_ret_b_0EF2:
		retn
sub_b_0BA0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_0EF3	proc	near
		mov	al,data_b_001A
		inc	al
		dec	al
		jnz	loc_b_0EFF		; Jump if not zero
		jmp	loc_b_0FBC
loc_b_0EFF:
		mov	al,data_b_001C
		inc	al
		dec	al
		js	loc_b_0F0B		; Jump if sign=1
		jmp	short loc_b_0F88
data_b_0F0A	db	90h			; Data table (indexed access)
loc_b_0F0B:
		cmp	al,0FFh
		cmc				; Complement carry
		jz	loc_b_0F13		; Jump if zero
		jmp	short loc_b_0F4A
		db	90h
loc_b_0F13:
		mov	al,3
		mov	cl,data_b_001A
		mov	bl,data_b_001B
		call	sub_b_5034
		mov	al,4
		mov	data_b_0011,al
		mov	al,data_b_001B
		sub	al,5
		mov	data_b_001B,al
		mov	al,data_b_001A
		sub	al,4
		mov	data_b_001A,al
		mov	al,data_b_0011
		mov	cl,data_b_001A
		mov	bl,data_b_001B
		call	sub_b_5015
		dec	data_b_001C
		jmp	short loc_b_0FBC
		db	90h
loc_b_0F4A:
		mov	cl,data_b_001A
		mov	bl,data_b_001B
		mov	al,data_b_0011
		call	sub_b_5034
		mov	al,data_b_0011
		cmp	al,7
		cmc				; Complement carry
		jz	loc_b_0F63		; Jump if zero
		jmp	short loc_b_0F6F
		db	90h
loc_b_0F63:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_001A,al
		jmp	short loc_b_0FBC
		db	90h
loc_b_0F6F:
		mov	data_b_0011,al
		inc	data_b_0011
		mov	cl,data_b_001A
		mov	bl,data_b_001B
		call	sub_b_5015
		dec	data_b_001C
		jmp	short loc_b_0FBC
		db	90h
loc_b_0F88:
		mov	al,3
		mov	cl,data_b_001A
		mov	bl,data_b_001B
		call	sub_b_5034
		mov	al,data_b_001A
		add	al,0Ch
		mov	data_b_001A,al
		mov	cl,al
		mov	bl,data_b_001B
		mov	al,3
		call	sub_b_5015
		mov	al,data_b_001A
		cmp	al,0F5h
		cmc				; Complement carry
		jc	loc_b_0FB3		; Jump if carry Set
		jmp	short loc_b_0FB8
		db	90h
loc_b_0FB3:
		mov	al,0
		mov	data_b_001C,al
loc_b_0FB8:
		dec	data_b_001C
loc_b_0FBC:
		mov	cl,0
loc_b_0FBE:
		mov	si,cx
		mov	al,byte ptr ds:[0DF2h][si]
		inc	al
		dec	al
		jz	loc_b_0FCD		; Jump if zero
		jmp	short loc_b_0FDA
		db	90h
loc_b_0FCD:
		inc	cl
		cmp	cl,4
		cmc				; Complement carry
		jz	loc_b_0FD7		; Jump if zero
		jmp	short loc_b_0FBE
loc_b_0FD7:
		jmp	short loc_b_102F
		db	90h
loc_b_0FDA:
		mov	data_b_0016,cl
		push	ax
		mov	si,cx
		mov	al,byte ptr ds:[0DF6h][si]
		mov	bl,al
		pop	ax
		mov	cl,al
		mov	al,2
		call	sub_b_5034
		mov	cl,data_b_0016
		mov	si,cx
		mov	al,byte ptr ds:[0DFAh][si]
		inc	al
		dec	al
		jz	loc_b_1002		; Jump if zero
		jmp	short loc_b_101D
		db	90h
loc_b_1002:
		mov	al,byte ptr ds:[0DEEh][si]
		mov	bl,al
		mov	al,byte ptr ds:[0DEAh][si]
		mov	cl,al
		mov	al,2
		call	sub_b_5015
		mov	cl,data_b_0016
		inc	cl
		dec	cl
		jmp	short loc_b_0FCD
loc_b_101D:
		mov	al,0
		inc	al
		dec	al
		mov	si,cx
		mov	byte ptr ds:[0DEAh][si],al
		mov	byte ptr ds:[0DF2h][si],al
		jmp	short loc_b_0FCD
loc_b_102F:
		mov	cl,0
loc_b_1031:
		mov	si,cx
		mov	al,byte ptr ds:[0DEAh][si]
		mov	byte ptr ds:[0DF2h][si],al
		mov	al,byte ptr ds:[0DEEh][si]
		mov	byte ptr ds:[0DF6h][si],al
		sub	al,9
		cmp	al,25h			; '%'
		cmc				; Complement carry
		jnc	loc_b_104D		; Jump if carry=0
		jmp	short loc_b_1053
		db	90h
loc_b_104D:
		mov	al,1
		mov	byte ptr ds:[0DFAh][si],al
loc_b_1053:
		mov	si,cx
		mov	byte ptr ds:[0DEEh][si],al
		inc	cl
		cmp	cl,4
		cmc				; Complement carry
		jz	loc_ret_b_1063		; Jump if zero
		jmp	short loc_b_1031

loc_ret_b_1063:
		retn
sub_b_0EF3	endp

loc_b_1064:
		mov	al,data_b_0058
		sub	al,data_b_0014
		mov	data_b_0058,al
		add	al,8
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al
		mov	al,data_b_0015
		sub	al,4
		js	loc_b_1083		; Jump if sign=1
		jmp	short loc_b_1089
		db	90h
loc_b_1083:
		dec	data_b_0014
		add	al,0Ah
loc_b_1089:
		mov	data_b_0015,al
		mov	al,data_b_0058
		cmp	al,86h
		cmc				; Complement carry
		jc	loc_b_1097		; Jump if carry Set
		jmp	short loc_ret_b_10B0
		db	90h
loc_b_1097:
		mov	al,0
		mov	data_b_0013,al
		mov	al,86h
		mov	data_b_0058,al
		mov	al,8Fh
		inc	al
		dec	al
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al

loc_ret_b_10B0:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_10B1	proc	near
		mov	al,data_b_0096
		sub	al,data_b_00AF
		cmc				; Complement carry
		mov	data_b_0096,al
		jnc	loc_b_10C1		; Jump if carry=0
		jmp	short loc_ret_b_10D1
		db	90h
loc_b_10C1:
		mov	al,data_b_00DD
		inc	al
		dec	al
		jnz	loc_b_10CD		; Jump if not zero
		jmp	short loc_b_10D2
		db	90h
loc_b_10CD:
		dec	data_b_00DD

loc_ret_b_10D1:
		retn
loc_b_10D2:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_0096,al
		mov	data_b_00DD,al
		retn
sub_b_10B1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_10DF	proc	near
		retn
sub_b_10DF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_10E0	proc	near
		mov	cl,2
loc_b_10E2:
		mov	si,cx
		mov	al,data_b_00E8[si]
		inc	al
		dec	al
		jz	loc_b_10F1		; Jump if zero
		jmp	short loc_b_10F8
		db	90h
loc_b_10F1:
		dec	cl
		js	loc_ret_b_10F7		; Jump if sign=1
		jmp	short loc_b_10E2

loc_ret_b_10F7:
		retn
loc_b_10F8:
		mov	data_b_00DE,cl
		mov	si,cx
		mov	bl,data_b_00E5[si]
		mov	al,data_b_00E8[si]
		push	ax
		mov	al,data_b_00E2[si]
		mov	cl,al
		pop	ax
		call	sub_b_4FF6
		mov	cl,data_b_00DE
		mov	si,cx
		dec	data_b_00EB[si]
		jnz	loc_b_1120		; Jump if not zero
		jmp	short loc_b_113D
		db	90h
loc_b_1120:
		mov	bl,data_b_00E5[si]
		mov	al,data_b_00E8[si]
		push	ax
		mov	al,data_b_00E2[si]
		mov	cl,al
		pop	ax
		call	sub_b_4FD7
		mov	cl,data_b_00DE
		inc	cl
		dec	cl
		jmp	short loc_b_10F1
loc_b_113D:
		mov	al,0
		inc	al
		dec	al
		mov	si,cx
		mov	data_b_00E8[si],al
		jmp	short loc_b_10F1
sub_b_10E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_114B	proc	near
loc_b_114B:
		mov	data_b_0050,cl
		sub	al,0Fh
		cmc				; Complement carry
		mov	cl,al
		mov	si,cx
		mov	al,byte ptr ds:[0DFEh][si]
		push	ax
		mov	al,byte ptr ds:[0E02h][si]
		push	ax
		mov	al,byte ptr ds:[0E06h][si]
		mov	bl,al
		pop	ax
		mov	cl,al
		pop	ax
		inc	al
		dec	al
		call	sub_b_2149
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		retn
sub_b_114B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_117A	proc	near
		cmp	al,0Ch
		cmc				; Complement carry
		jc	loc_b_1182		; Jump if carry Set
		jmp	short loc_b_11EA
		db	90h
loc_b_1182:
		mov	al,data_b_00E0
		inc	al
		dec	al
		jnz	loc_b_118E		; Jump if not zero
		jmp	short loc_b_11B2
		db	90h
loc_b_118E:
		dec	data_b_00E0
		jz	loc_b_1197		; Jump if zero
		jmp	short loc_b_11B2
		db	90h
loc_b_1197:
		mov	data_b_0050,cl
		mov	cl,2
loc_b_119D:
		mov	si,cx
		mov	al,data_b_00E8[si]
		inc	al
		dec	al
		jnz	loc_b_11AC		; Jump if not zero
		jmp	short loc_b_11BB
		db	90h
loc_b_11AC:
		dec	bl
		js	loc_b_11B2		; Jump if sign=1
		jmp	short loc_b_119D
loc_b_11B2:
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		retn
loc_b_11BB:
		mov	al,byte ptr ds:[823h][bx]
		mov	si,cx
		mov	data_b_00E2[si],al
		mov	al,byte ptr ds:[827h][bx]
		mov	data_b_00E5[si],al
		mov	al,10h
		sub	al,3
		add	al,data_b_00E1
		mov	data_b_00E8[si],al
		call	sub_b_114B
		mov	al,0Dh
		inc	al
		dec	al
		mov	si,cx
		mov	data_b_00EB[si],al
		jmp	short loc_b_11B2
loc_b_11EA:
		mov	al,data_b_00DF
		inc	al
		dec	al
		jnz	loc_b_11F5		; Jump if not zero
		jmp	short loc_b_11B2
loc_b_11F5:
		dec	data_b_00DF
		jz	loc_b_11FD		; Jump if zero
		jmp	short loc_b_11B2
loc_b_11FD:
		mov	cl,2
loc_b_11FF:
		mov	si,cx
		mov	al,data_b_00E8[si]
		inc	al
		dec	al
		jnz	loc_b_120E		; Jump if not zero
		jmp	short loc_b_1216
		db	90h
loc_b_120E:
		dec	cl
		js	loc_b_1214		; Jump if sign=1
		jmp	short loc_b_11FF
loc_b_1214:
		jmp	short loc_b_11B2
loc_b_1216:
		jmp	short loc_b_11BB
sub_b_117A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1218	proc	near
		mov	cl,7
		mov	bl,35h			; '5'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'                   @'
		db	0B1h, 07h,0B3h, 3Ch,0FEh,0C3h
		db	0FEh,0CBh,0E8h,0ACh, 0Fh
data_b_1242	dw	4320h			; Data table (indexed access)
		db	'ONGRATULATIONS ! @'
		db	0B1h, 07h,0B3h, 43h,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 8Dh, 0Fh
		db	7 dup (20h)
data_b_1268	dw	2020h			; Data table (indexed access)
		db	'          @'
		db	 9Ch, 51h,0B4h, 0Ch

locloop_b_1279:
		loop	locloop_b_1279		; Loop if cx > 0

		dec	ah
		jnz	locloop_b_1279		; Jump if not zero
		pop	cx
		popf				; Pop flags
		retn
sub_b_1218	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1282	proc	near
loc_b_1282:
		mov	cl,0
		mov	si,data_b_0075
		mov	al,[si]
		mov	data_b_0054,al
		mov	al,0E0h
		mov	data_b_0055,al
		mov	al,0Bh
		mov	data_b_0056,al
		mov	al,0
		mov	data_b_0051,al
		mov	data_b_0052,al
		mov	si,data_b_0073
		mov	al,[si]
		inc	al
		dec	al
		jz	loc_b_12AE		; Jump if zero
		jmp	short loc_b_12B1
		db	90h
loc_b_12AE:
		jmp	loc_ret_b_1373
loc_b_12B1:
		mov	data_b_0053,al
		mov	byte ptr ds:[0],al
		mov	cl,10h
loc_b_12B9:
		shl	data_b_0055,1		; Shift w/zeros fill
		mov	dh,data_b_0056
		rcl	dh,1			; Rotate thru carry
		mov	data_b_0056,dh
		mov	dh,data_b_0051
		rcl	dh,1			; Rotate thru carry
		mov	data_b_0051,dh
		mov	dh,data_b_0052
		rcl	dh,1			; Rotate thru carry
		mov	data_b_0052,dh
		mov	al,data_b_0051
		sub	al,byte ptr ds:[0]
		mov	bl,al
		mov	al,data_b_0052
		sbb	al,0
		cmc				; Complement carry
		jc	loc_b_12EF		; Jump if carry Set
		jmp	short loc_b_12FA
		db	90h
loc_b_12EF:
		mov	data_b_0051,bl
		mov	data_b_0052,al
		inc	data_b_0055
loc_b_12FA:
		dec	cl
		jz	loc_b_1300		; Jump if zero
		jmp	short loc_b_12B9
loc_b_1300:
		mov	al,data_b_0055
		mov	data_b_004C,al
		mov	al,data_b_0056
		mov	data_b_004D,al
loc_b_130C:
		mov	cl,data_b_004C
		mov	bl,data_b_004D
		inc	bl
loc_b_1316:
		mov	al,byte ptr ds:[0]
loc_b_1319:
		mov	data_b_0050,cl
		mov	cl,3
loc_b_131F:
		dec	cl
		jz	loc_b_1325		; Jump if zero
		jmp	short loc_b_131F
loc_b_1325:
		mov	cl,data_b_0050
		sub	al,1
		cmc				; Complement carry
		jnc	loc_b_1330		; Jump if carry=0
		jmp	short loc_b_1319
loc_b_1330:
		call	sub_b_4E8B
		dec	cl
		jz	loc_b_133A		; Jump if zero
		jmp	short loc_b_133C
		db	90h
loc_b_133A:
		dec	bl
loc_b_133C:
		jz	loc_b_1340		; Jump if zero
		jmp	short loc_b_1316
loc_b_1340:
		mov	al,0Ah
		mov	byte ptr data_b_0006,al
		mov	cl,0
		inc	cl
		dec	cl
		call	sub_b_3D27
		dec	data_b_0054
		jz	loc_b_1356		; Jump if zero
		jmp	short loc_b_130C
loc_b_1356:
		inc	byte ptr data_b_0075
		jz	loc_b_135F		; Jump if zero
		jmp	short loc_b_1363
		db	90h
loc_b_135F:
		inc	byte ptr data_b_0075+1
loc_b_1363:
		inc	byte ptr data_b_0073
		jz	loc_b_136C		; Jump if zero
		jmp	short loc_b_1370
		db	90h
loc_b_136C:
		inc	byte ptr data_b_0073+1
loc_b_1370:
		jmp	loc_b_1282

loc_ret_b_1373:
		retn
sub_b_1282	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1374	proc	near
loc_b_1374:
		mov	al,byte ptr data_b_0044
		mov	data_b_0099,al
		mov	al,byte ptr data_b_0044+1
		mov	data_b_009A,al
		mov	al,0
		mov	data_b_0097,al
		mov	al,18h
		mov	data_b_0096,al
		mov	al,2
		mov	data_b_00DD,al
		mov	al,0
		mov	byte ptr ds:[1],al
		mov	al,data_b_0078
		add	al,1
		mov	data_b_00D5,al
		mov	al,28h			; '('
		mov	data_b_00D7,al
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00D8,al
		retn
sub_b_1374	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_13AB	proc	near
		mov	al,data_b_0097
		inc	al
		dec	al
		jnz	loc_b_13B7		; Jump if not zero
		jmp	short loc_b_13BA
		nop
loc_b_13B7:
		jmp	short loc_ret_b_140C
		db	90h
loc_b_13BA:
		mov	al,data_b_00DD
		cmp	al,1
		cmc				; Complement carry
		jnz	loc_b_13C5		; Jump if not zero
		jmp	short loc_b_13C8
		nop
loc_b_13C5:
		jmp	short loc_ret_b_140C
		db	90h
loc_b_13C8:
		mov	al,data_b_0057
		cmp	al,data_b_0096
		cmc				; Complement carry
		jc	loc_b_13D5		; Jump if carry Set
		jmp	short loc_ret_b_140C
		db	90h
loc_b_13D5:
		mov	al,data_b_0099
		mov	data_b_0083,al
		mov	al,data_b_009A
		mov	data_b_0084,al
		mov	cl,7Fh
loc_b_13E3:
		call	sub_b_4E8B
		mov	al,6
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_13F5		; Jump if sign=1
		jmp	short loc_b_13E3
loc_b_13F5:
		mov	al,1
		mov	data_b_0097,al
		inc	data_b_0078
		mov	al,0D5h
		mov	byte ptr data_b_0004,al
		call	sub_b_50B3
		call	sub_b_2A49
		call	sub_b_22B5

loc_ret_b_140C:
		retn
sub_b_13AB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_140D	proc	near
		mov	cl,3
loc_b_140F:
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		inc	al
		dec	al
		jz	loc_b_141E		; Jump if zero
		jmp	short loc_b_1427
		db	90h
loc_b_141E:
		dec	cl
		js	loc_b_1424		; Jump if sign=1
		jmp	short loc_b_140F
loc_b_1424:
		jmp	short loc_b_1499
		db	90h
loc_b_1427:
		mov	data_b_0050,cl
		mov	al,data_b_001B
		cmp	al,88h
		cmc				; Complement carry
		jc	loc_b_1435		; Jump if carry Set
		jmp	short loc_b_141E
loc_b_1435:
		cmp	al,98h
		cmc				; Complement carry
		jnc	loc_b_143C		; Jump if carry=0
		jmp	short loc_b_141E
loc_b_143C:
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		sub	al,4
		cmp	al,data_b_001A
		cmc				; Complement carry
		jnc	loc_b_144D		; Jump if carry=0
		jmp	short loc_b_141E
loc_b_144D:
		mov	al,byte ptr ds:[90Ah][si]
		add	al,19h
		cmp	al,data_b_001A
		cmc				; Complement carry
		jc	loc_b_145C		; Jump if carry Set
		jmp	short loc_b_141E
loc_b_145C:
		mov	al,data_b_009D
		inc	al
		dec	al
		jz	loc_b_1467		; Jump if zero
		jmp	short loc_b_141E
loc_b_1467:
		mov	al,1
		mov	data_b_009D,al
		mov	al,byte ptr ds:[90Ah][si]
		mov	cl,al
		mov	al,0Bh
		mov	bl,8Fh
		call	sub_b_4FF6
		call	sub_b_3DB2
		mov	cl,data_b_0050
		mov	al,data_b_001C
		inc	al
		dec	al
		jns	loc_b_148C		; Jump if not sign
		jmp	short loc_b_148E
		db	90h
loc_b_148C:
		mov	al,0FFh
loc_b_148E:
		mov	data_b_001C,al
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[90Ah][si],al
loc_b_1499:
		mov	cl,3
loc_b_149B:
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		inc	al
		dec	al
		jz	loc_b_14AA		; Jump if zero
		jmp	short loc_b_14B1
		db	90h
loc_b_14AA:
		dec	cl
		js	loc_ret_b_14B0		; Jump if sign=1
		jmp	short loc_b_149B

loc_ret_b_14B0:
		retn
loc_b_14B1:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		add	al,8
		cmp	al,data_b_0057
		cmc				; Complement carry
		jc	loc_b_14C6		; Jump if carry Set
		jmp	short loc_b_14AA
loc_b_14C6:
		mov	al,data_b_0057
		add	al,24h			; '$'
		cmp	al,byte ptr ds:[90Ah][si]
		cmc				; Complement carry
		jc	loc_b_14D4		; Jump if carry Set
		jmp	short loc_b_14AA
loc_b_14D4:
		mov	al,data_b_0058
		add	al,12h
		cmp	al,90h
		cmc				; Complement carry
		jc	loc_b_14E0		; Jump if carry Set
		jmp	short loc_b_14AA
loc_b_14E0:
		mov	al,1
		mov	data_b_0070,al
		mov	al,byte ptr ds:[90Ah][si]
		mov	cl,al
		mov	al,0Bh
		mov	bl,8Fh
		call	sub_b_4FF6
		mov	cl,data_b_0050
		mov	al,0
		inc	al
		dec	al
		mov	si,cx
		mov	byte ptr ds:[90Ah][si],al
		retn
sub_b_140D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1503	proc	near
		mov	cl,3
loc_b_1505:
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		inc	al
		dec	al
		jz	loc_b_1514		; Jump if zero
		jmp	short loc_b_151B
		db	90h
loc_b_1514:
		dec	cl
		js	loc_ret_b_151A		; Jump if sign=1
		jmp	short loc_b_1505

loc_ret_b_151A:
		retn
loc_b_151B:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		mov	cl,al
		mov	al,0Bh
		mov	bl,8Fh
		call	sub_b_4FF6
		mov	cl,data_b_0050
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		sub	al,8
		cmp	al,0Ah
		cmc				; Complement carry
		jc	loc_b_1542		; Jump if carry Set
		jmp	short loc_b_1559
		db	90h
loc_b_1542:
		mov	byte ptr ds:[90Ah][si],al
		mov	cl,al
		mov	al,0Bh
		mov	bl,8Fh
		call	sub_b_4FD7
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		jmp	short loc_b_1514
loc_b_1559:
		mov	al,0
		inc	al
		dec	al
		mov	si,cx
		mov	byte ptr ds:[90Ah][si],al
		jmp	short loc_b_1514
sub_b_1503	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1567	proc	near
		mov	cl,3
loc_b_1569:
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		inc	al
		dec	al
		jnz	loc_b_1578		; Jump if not zero
		jmp	short loc_b_15AC
		db	90h
loc_b_1578:
		jns	loc_b_157D		; Jump if not sign
		jmp	short loc_b_15AC
		db	90h
loc_b_157D:
		cmp	al,0Eh
		cmc				; Complement carry
		jnc	loc_b_1585		; Jump if carry=0
		jmp	short loc_b_15AC
		db	90h
loc_b_1585:
		sub	al,8
		cmc				; Complement carry
		mov	bl,al
		mov	al,byte ptr ds:[873h][bx]
		mov	si,cx
		mov	byte ptr ds:[893h][si],al
		mov	al,byte ptr ds:[87Bh][bx]
		mov	byte ptr ds:[897h][si],al
		mov	al,byte ptr ds:[883h][bx]
		mov	byte ptr ds:[89Bh][si],al
		mov	al,byte ptr ds:[88Bh][bx]
		mov	byte ptr ds:[89Fh][si],al
loc_b_15AC:
		dec	cl
		js	loc_b_15B2		; Jump if sign=1
		jmp	short loc_b_1569
loc_b_15B2:
		mov	cl,3
loc_b_15B4:
		mov	si,cx
		mov	al,byte ptr ds:[0DF2h][si]
		inc	al
		dec	al
		jz	loc_b_15C3		; Jump if zero
		jmp	short loc_b_15CA
		db	90h
loc_b_15C3:
		dec	cl
		js	loc_ret_b_15C9		; Jump if sign=1
		jmp	short loc_b_15B4

loc_ret_b_15C9:
		retn
loc_b_15CA:
		mov	bl,3
loc_b_15CC:
		mov	al,byte ptr ds:[82Bh][bx]
		inc	al
		dec	al
		jnz	loc_b_15D9		; Jump if not zero
		jmp	short loc_b_15E9
		db	90h
loc_b_15D9:
		jns	loc_b_15DE		; Jump if not sign
		jmp	short loc_b_15E9
		db	90h
loc_b_15DE:
		cmp	al,0Eh
		cmc				; Complement carry
		jnc	loc_b_15E6		; Jump if carry=0
		jmp	short loc_b_15E9
		nop
loc_b_15E6:
		jmp	short loc_b_15F1
		db	90h
loc_b_15E9:
		dec	bl
		js	loc_b_15EF		; Jump if sign=1
		jmp	short loc_b_15CC
loc_b_15EF:
		jmp	short loc_b_15C3
loc_b_15F1:
		mov	al,byte ptr ds:[823h][bx]
		add	al,byte ptr ds:[89Fh][bx]
		mov	si,cx
		cmp	al,byte ptr ds:[0DEAh][si]
		cmc				; Complement carry
		jc	loc_b_1605		; Jump if carry Set
		jmp	loc_b_16A1
loc_b_1605:
		mov	al,byte ptr ds:[0DEAh][si]
		add	al,1
		adc	al,byte ptr ds:[89Bh][bx]
		cmp	al,byte ptr ds:[823h][bx]
		cmc				; Complement carry
		jc	loc_b_1619		; Jump if carry Set
		jmp	loc_b_16A1
loc_b_1619:
		mov	al,byte ptr ds:[827h][bx]
		add	al,byte ptr ds:[897h][bx]
		sub	al,4
		cmp	al,byte ptr ds:[0DEEh][si]
		cmc				; Complement carry
		jc	loc_b_162D		; Jump if carry Set
		jmp	short loc_b_16A1
		db	90h
loc_b_162D:
		mov	al,byte ptr ds:[0DEEh][si]
		add	al,6
		adc	al,byte ptr ds:[893h][bx]
		cmp	al,byte ptr ds:[827h][bx]
		cmc				; Complement carry
		jc	loc_b_1641		; Jump if carry Set
		jmp	short loc_b_16A1
		db	90h
loc_b_1641:
		mov	al,1
		mov	byte ptr ds:[85Fh][bx],al
		mov	byte ptr ds:[0DFAh][si],al
		mov	al,byte ptr ds:[82Bh][bx]
		inc	al
		dec	al
		push	ax
		call	sub_b_117A
		pop	ax
		cmp	al,0Ch
		cmc				; Complement carry
		jc	loc_b_1660		; Jump if carry Set
		jmp	short loc_b_166D
		db	90h
loc_b_1660:
		mov	al,0
		mov	cl,1
		mov	bl,0
		inc	bl
		dec	bl
		jmp	short loc_b_1677
		db	90h
loc_b_166D:
		mov	al,0
		mov	cl,2
		mov	bl,0
		inc	bl
		dec	bl
loc_b_1677:
		call	sub_b_2149
		mov	al,7
		inc	al
		dec	al
		call	sub_b_3D99
		mov	al,6
		inc	al
		dec	al
		call	sub_b_3D99
		mov	al,5
		inc	al
		dec	al
		call	sub_b_3D99
		mov	al,8
		inc	al
		dec	al
		call	sub_b_3D99
		jmp	loc_b_15C3
loc_b_16A1:
		jmp	loc_b_15E9
sub_b_1567	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_16A4	proc	near
		mov	al,data_b_00AF
		shr	al,1			; Shift w/zeros fill
		sub	al,1
		mov	byte ptr ds:[0],al
		mov	al,data_b_0046
		sub	al,byte ptr ds:[0]
		cmc				; Complement carry
		jc	loc_b_16BB		; Jump if carry Set
		jmp	short loc_b_16BF
		db	90h
loc_b_16BB:
		mov	data_b_0046,al
		retn
loc_b_16BF:
		inc	byte ptr data_b_0044
		jz	loc_b_16C8		; Jump if zero
		jmp	short loc_b_16CC
		db	90h
loc_b_16C8:
		inc	byte ptr data_b_0044+1
loc_b_16CC:
		mov	cl,0
		mov	si,data_b_0044
		mov	al,[si]
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		mov	bl,al
		mov	si,data_b_0044
		mov	al,[si]
		and	al,0F8h
		cmp	al,0
		cmc				; Complement carry
		jz	loc_b_16EC		; Jump if zero
		jmp	short loc_b_170D
		db	90h
loc_b_16EC:
		mov	si,data_b_0044
		mov	al,[si]
		rcl	ah,1			; Rotate thru carry
		and	al,7
		rcr	ah,1			; Rotate thru carry
		mov	cl,0Bh
		inc	cl
		dec	cl
		call	sub_b_3D3B
		mov	al,cl
		mov	cl,0
		inc	cl
		dec	cl
		mov	data_b_0046,al
		retn
loc_b_170D:
		mov	si,data_b_0044
		mov	al,[si]
		rcl	ah,1			; Rotate thru carry
		and	al,7
		rcr	ah,1			; Rotate thru carry
		mov	cl,0Bh
		inc	cl
		dec	cl
		call	sub_b_3D3B
		mov	al,cl
		mov	cl,0
		mov	data_b_0046,al
		cmp	al,0Bh
		cmc				; Complement carry
		jz	loc_b_1731		; Jump if zero
		jmp	short loc_b_1746
		db	90h
loc_b_1731:
		mov	si,data_b_0044
		mov	al,[si]
		and	al,0F8h
		cmp	al,88h
		cmc				; Complement carry
		jz	loc_b_1741		; Jump if zero
		jmp	short loc_b_1746
		db	90h
loc_b_1741:
		mov	al,5
		mov	data_b_0046,al
loc_b_1746:
		mov	si,data_b_0044
		mov	al,[si]
		and	al,0F8h
		cmp	al,10h
		cmc				; Complement carry
		jz	loc_b_1756		; Jump if zero
		jmp	short loc_b_1759
		db	90h
loc_b_1756:
		jmp	loc_b_1910
loc_b_1759:
		cmp	al,18h
		cmc				; Complement carry
		jz	loc_b_1761		; Jump if zero
		jmp	short loc_b_1764
		db	90h
loc_b_1761:
		jmp	loc_b_1910
loc_b_1764:
		cmp	al,20h			; ' '
		cmc				; Complement carry
		jz	loc_b_176C		; Jump if zero
		jmp	short loc_b_176F
		db	90h
loc_b_176C:
		jmp	loc_b_1910
loc_b_176F:
		cmp	al,58h			; 'X'
		cmc				; Complement carry
		jz	loc_b_1777		; Jump if zero
		jmp	short loc_b_1788
		db	90h
loc_b_1777:
		push	ax
		mov	al,3
		mov	data_b_00DF,al
		mov	data_b_00E1,al
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_1910
loc_b_1788:
		cmp	al,60h			; '`'
		cmc				; Complement carry
		jz	loc_b_1790		; Jump if zero
		jmp	short loc_b_17A1
		db	90h
loc_b_1790:
		push	ax
		mov	al,4
		mov	data_b_00DF,al
		mov	data_b_00E1,al
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_1910
loc_b_17A1:
		cmp	al,68h			; 'h'
		cmc				; Complement carry
		jz	loc_b_17A9		; Jump if zero
		jmp	short loc_b_17BA
		db	90h
loc_b_17A9:
		push	ax
		mov	al,5
		mov	data_b_00DF,al
		mov	data_b_00E1,al
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_1910
loc_b_17BA:
		cmp	al,70h			; 'p'
		cmc				; Complement carry
		jz	loc_b_17C2		; Jump if zero
		jmp	short loc_b_17D3
		db	90h
loc_b_17C2:
		push	ax
		mov	al,3
		mov	data_b_00E0,al
		mov	data_b_00E1,al
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_1910
loc_b_17D3:
		cmp	al,78h			; 'x'
		cmc				; Complement carry
		jz	loc_b_17DB		; Jump if zero
		jmp	short loc_b_17EC
		db	90h
loc_b_17DB:
		push	ax
		mov	al,4
		mov	data_b_00E0,al
		mov	data_b_00E1,al
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_1910
loc_b_17EC:
		cmp	al,80h
		cmc				; Complement carry
		jz	loc_b_17F4		; Jump if zero
		jmp	short loc_b_1805
		db	90h
loc_b_17F4:
		push	ax
		mov	al,5
		mov	data_b_00E0,al
		mov	data_b_00E1,al
		pop	ax
		inc	al
		dec	al
		jmp	loc_b_1910
loc_b_1805:
		cmp	al,38h			; '8'
		cmc				; Complement carry
		jz	loc_b_180D		; Jump if zero
		jmp	short loc_b_1816
		db	90h
loc_b_180D:
		mov	al,15h
		inc	al
		dec	al
		jmp	loc_b_1B6F
loc_b_1816:
		cmp	al,30h			; '0'
		cmc				; Complement carry
		jz	loc_b_181E		; Jump if zero
		jmp	short loc_b_1827
		db	90h
loc_b_181E:
		mov	al,14h
		inc	al
		dec	al
		jmp	loc_b_1B6F
loc_b_1827:
		cmp	al,28h			; '('
		cmc				; Complement carry
		jz	loc_b_182F		; Jump if zero
		jmp	short loc_b_1838
		db	90h
loc_b_182F:
		mov	al,13h
		inc	al
		dec	al
		jmp	loc_b_1B6F
loc_b_1838:
		cmp	al,48h			; 'H'
		cmc				; Complement carry
		jz	loc_b_1840		; Jump if zero
		jmp	short loc_b_1843
		db	90h
loc_b_1840:
		jmp	loc_b_1D27
loc_b_1843:
		cmp	al,40h			; '@'
		cmc				; Complement carry
		jz	loc_b_184B		; Jump if zero
		jmp	short loc_b_184E
		db	90h
loc_b_184B:
		jmp	loc_b_1D27
loc_b_184E:
		cmp	al,0C0h
		cmc				; Complement carry
		jz	loc_b_1856		; Jump if zero
		jmp	short loc_b_1859
		db	90h
loc_b_1856:
		jmp	loc_b_1D27
loc_b_1859:
		cmp	al,88h
		cmc				; Complement carry
		jz	loc_b_1861		; Jump if zero
		jmp	short loc_b_1864
		db	90h
loc_b_1861:
		jmp	loc_b_1D27
loc_b_1864:
		cmp	al,50h			; 'P'
		cmc				; Complement carry
		jz	loc_b_186C		; Jump if zero
		jmp	short loc_b_1870
		db	90h
loc_b_186C:
		call	sub_b_1374
		retn
loc_b_1870:
		cmp	al,0E8h
		cmc				; Complement carry
		jz	loc_b_1878		; Jump if zero
		jmp	short loc_b_1889
		db	90h
loc_b_1878:
		mov	al,0
		mov	data_b_0080,al
		mov	al,80h
		inc	al
		dec	al
		mov	data_b_007F,al
		jmp	loc_b_1374
loc_b_1889:
		cmp	al,98h
		cmc				; Complement carry
		jz	loc_b_1891		; Jump if zero
		jmp	short loc_b_18A2
		db	90h
loc_b_1891:
		mov	al,1
		mov	data_b_0080,al
		mov	al,0
		inc	al
		dec	al
		mov	data_b_007F,al
		jmp	loc_b_1374
loc_b_18A2:
		cmp	al,90h
		cmc				; Complement carry
		jz	loc_b_18AA		; Jump if zero
		jmp	short loc_b_18BB
		db	90h
loc_b_18AA:
		mov	al,1
		mov	data_b_0080,al
		mov	al,20h			; ' '
		inc	al
		dec	al
		mov	data_b_007F,al
		jmp	loc_b_1374
loc_b_18BB:
		cmp	al,0D8h
		cmc				; Complement carry
		jz	loc_b_18C3		; Jump if zero
		jmp	short loc_b_18D4
		db	90h
loc_b_18C3:
		mov	al,1
		mov	data_b_0080,al
		mov	al,20h			; ' '
		inc	al
		dec	al
		mov	data_b_007F,al
		jmp	loc_b_1374
loc_b_18D4:
		cmp	al,0D0h
		cmc				; Complement carry
		jz	loc_b_18DC		; Jump if zero
		jmp	short loc_b_18E5
		db	90h
loc_b_18DC:
		mov	al,16h
		inc	al
		dec	al
		jmp	loc_b_1B6F
loc_b_18E5:
		cmp	al,0C8h
		cmc				; Complement carry
		jz	loc_b_18ED		; Jump if zero
		jmp	short loc_b_18F0
		db	90h
loc_b_18ED:
		jmp	loc_b_479F
loc_b_18F0:
		cmp	al,0E0h
		cmc				; Complement carry
		jz	loc_b_18F8		; Jump if zero
		jmp	short loc_ret_b_190F
		db	90h
loc_b_18F8:
		mov	ax,695h
		mov	byte ptr data_b_0044,al
		mov	byte ptr data_b_0044+1,ah
		mov	data_b_0083,al
		mov	data_b_0084,ah
		mov	al,ah
		inc	al
		dec	al

loc_ret_b_190F:
		retn
loc_b_1910:
		mov	data_b_0047,al
		mov	cl,3
loc_b_1915:
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		inc	al
		dec	al
		jnz	loc_b_1924		; Jump if not zero
		jmp	short loc_b_1934
		db	90h
loc_b_1924:
		dec	cl
		js	loc_b_192A		; Jump if sign=1
		jmp	short loc_b_1915
loc_b_192A:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0048,al
		retn
loc_b_1934:
		mov	data_b_0050,cl
		mov	al,data_b_0047
		cmp	al,10h
		cmc				; Complement carry
		jnz	loc_b_1943		; Jump if not zero
		jmp	short loc_b_196F
		db	90h
loc_b_1943:
		cmp	al,70h			; 'p'
		cmc				; Complement carry
		jnz	loc_b_194B		; Jump if not zero
		jmp	short loc_b_196F
		db	90h
loc_b_194B:
		cmp	al,78h			; 'x'
		cmc				; Complement carry
		jnz	loc_b_1953		; Jump if not zero
		jmp	short loc_b_196F
		db	90h
loc_b_1953:
		cmp	al,80h
		cmc				; Complement carry
		jnz	loc_b_195B		; Jump if not zero
		jmp	short loc_b_196F
		db	90h
loc_b_195B:
		cmp	al,18h
		cmc				; Complement carry
		jnz	loc_b_1963		; Jump if not zero
		jmp	short loc_b_197B
		db	90h
loc_b_1963:
		mov	al,8
		inc	al
		dec	al
		mov	data_b_0047,al
		jmp	short loc_b_1987
		db	90h
loc_b_196F:
		mov	al,0Dh
		inc	al
		dec	al
		mov	data_b_0047,al
		jmp	short loc_b_1987
		db	90h
loc_b_197B:
		mov	al,0Ch
		inc	al
		dec	al
		mov	data_b_0047,al
		jmp	short loc_b_1987
		db	90h
loc_b_1987:
		mov	al,data_b_0047
		mov	si,cx
		mov	byte ptr ds:[82Bh][si],al
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[84Fh][si],al
		mov	byte ptr ds:[853h][si],al
		call	sub_b_2EBC
		call	sub_b_2F1B
		mov	si,cx
		mov	al,byte ptr ds:[827h][si]
		mov	bl,al
		mov	al,byte ptr ds:[823h][si]
		mov	cl,al
		mov	al,data_b_0047
		call	sub_b_5015
		mov	al,0Ah
		inc	al
		dec	al
		call	sub_b_31E0
		mov	cl,data_b_0050
		add	al,82h
		mov	si,cx
		mov	byte ptr ds:[857h][si],al
		mov	al,28h			; '('
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,0Ah
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		mov	si,cx
		mov	byte ptr ds:[85Bh][si],al
		clc				; Clear carry flag
		retn

;==== External Entry into Subroutine ======================================

sub_b_19E8:
		mov	cl,3
loc_b_19EA:
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		inc	al
		dec	al
		jz	loc_b_19F9		; Jump if zero
		jmp	short loc_b_1A00
		db	90h
loc_b_19F9:
		dec	cl
		js	loc_ret_b_19FF		; Jump if sign=1
		jmp	short loc_b_19EA

loc_ret_b_19FF:
		retn
loc_b_1A00:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		mov	data_b_00B0,al
		mov	al,byte ptr ds:[823h][si]
		mov	data_b_00B1,al
		mov	al,byte ptr ds:[827h][si]
		mov	data_b_00B2,al
		mov	al,byte ptr ds:[853h][si]
		inc	al
		dec	al
		mov	data_b_00B3,al
		call	sub_b_2F1B
		mov	si,cx
		dec	byte ptr ds:[857h][si]
		jz	loc_b_1A34		; Jump if zero
		jmp	short loc_b_1A3A
		db	90h
loc_b_1A34:
		mov	al,1
		mov	byte ptr ds:[84Fh][si],al
loc_b_1A3A:
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		cmp	al,0Ch
		cmc				; Complement carry
		jnc	loc_b_1A48		; Jump if carry=0
		jmp	short loc_b_1A5E
		db	90h
loc_b_1A48:
		inc	byte ptr ds:[82Bh][si]
		mov	al,byte ptr ds:[82Bh][si]
		cmp	al,0Ch
		cmc				; Complement carry
		jz	loc_b_1A58		; Jump if zero
		jmp	short loc_b_1A5E
		db	90h
loc_b_1A58:
		mov	al,8
		mov	byte ptr ds:[82Bh][si],al
loc_b_1A5E:
		cmp	al,0Fh
		cmc				; Complement carry
		jz	loc_b_1A66		; Jump if zero
		jmp	short loc_b_1A75
		db	90h
loc_b_1A66:
		mov	al,0FFh
		inc	al
		dec	al
		mov	si,cx
		mov	byte ptr ds:[82Bh][si],al
		jmp	short loc_b_1AAD
		db	90h
loc_b_1A75:
		cmp	al,0Eh
		cmc				; Complement carry
		jz	loc_b_1A7D		; Jump if zero
		jmp	short loc_b_1A85
		db	90h
loc_b_1A7D:
		mov	al,0Fh
		mov	si,cx
		mov	byte ptr ds:[82Bh][si],al
loc_b_1A85:
		cmp	al,10h
		cmc				; Complement carry
		jc	loc_b_1A8D		; Jump if carry Set
		jmp	short loc_b_1AAD
		db	90h
loc_b_1A8D:
		cmp	al,14h
		cmc				; Complement carry
		jnc	loc_b_1A95		; Jump if carry=0
		jmp	short loc_b_1AAD
		db	90h
loc_b_1A95:
		mov	si,cx
		inc	byte ptr ds:[82Bh][si]
		mov	al,byte ptr ds:[82Bh][si]
		cmp	al,14h
		cmc				; Complement carry
		jz	loc_b_1AA7		; Jump if zero
		jmp	short loc_b_1AAD
		db	90h
loc_b_1AA7:
		mov	al,0FFh
		mov	byte ptr ds:[82Bh][si],al
loc_b_1AAD:
		mov	si,cx
		mov	al,byte ptr ds:[85Fh][si]
		inc	al
		dec	al
		jnz	loc_b_1ABC		; Jump if not zero
		jmp	short loc_b_1AC8
		db	90h
loc_b_1ABC:
		mov	al,0Eh
		mov	byte ptr ds:[82Bh][si],al
		mov	al,0
		mov	byte ptr ds:[85Fh][si],al
loc_b_1AC8:
		mov	si,cx
		mov	al,byte ptr ds:[863h][si]
		inc	al
		dec	al
		jnz	loc_b_1AD7		; Jump if not zero
		jmp	short loc_b_1AED
		db	90h
loc_b_1AD7:
		mov	al,10h
		mov	byte ptr ds:[82Bh][si],al
		mov	al,byte ptr ds:[827h][si]
		sub	al,5
		mov	byte ptr ds:[827h][si],al
		mov	al,0
		mov	byte ptr ds:[863h][si],al
loc_b_1AED:
		mov	al,data_b_00B3
		mov	byte ptr ds:[39h],al
		mov	bl,data_b_00B2
		mov	cl,data_b_00B1
		mov	al,data_b_00B0
		cmp	al,0Eh
		cmc				; Complement carry
		jc	loc_b_1B06		; Jump if carry Set
		jmp	short loc_b_1B0E
		db	90h
loc_b_1B06:
		sub	al,0Eh
		call	sub_b_4FF6
		jmp	short loc_b_1B11
		db	90h
loc_b_1B0E:
		call	sub_b_5034
loc_b_1B11:
		mov	cl,data_b_0050
		mov	si,cx
		mov	al,byte ptr ds:[853h][si]
		mov	byte ptr ds:[39h],al
		mov	al,byte ptr ds:[82Bh][si]
		mov	data_b_00B0,al
		mov	al,byte ptr ds:[827h][si]
		mov	bl,al
		mov	al,byte ptr ds:[823h][si]
		mov	cl,al
		mov	al,data_b_00B0
		inc	al
		dec	al
		jns	loc_b_1B3D		; Jump if not sign
		jmp	short loc_b_1B53
		db	90h
loc_b_1B3D:
		cmp	al,0Eh
		cmc				; Complement carry
		jc	loc_b_1B45		; Jump if carry Set
		jmp	short loc_b_1B4D
		db	90h
loc_b_1B45:
		sub	al,0Eh
		call	sub_b_4FD7
		jmp	short loc_b_1B5F
		db	90h
loc_b_1B4D:
		call	sub_b_5015
		jmp	short loc_b_1B5F
		db	90h
loc_b_1B53:
		mov	cl,data_b_0050
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[82Bh][si],al
loc_b_1B5F:
		mov	cl,data_b_0050
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[39h],al
		jmp	loc_b_19F9

;==== External Entry into Subroutine ======================================

sub_b_1B6F:
loc_b_1B6F:
		mov	data_b_00B0,al
		mov	cl,3
loc_b_1B74:
		mov	si,cx
		mov	al,byte ptr ds:[8BEh][si]
		inc	al
		dec	al
		jnz	loc_b_1B83		; Jump if not zero
		jmp	short loc_b_1B8A
		db	90h
loc_b_1B83:
		dec	cl
		js	loc_ret_b_1B89		; Jump if sign=1
		jmp	short loc_b_1B74

loc_ret_b_1B89:
		retn
loc_b_1B8A:
		mov	data_b_0050,cl
		mov	al,data_b_0085
		inc	al
		dec	al
		jz	loc_b_1B9A		; Jump if zero
		jmp	short loc_b_1BAE
		db	90h
loc_b_1B9A:
		mov	bl,3
loc_b_1B9C:
		mov	al,byte ptr ds:[867h][bx]
		cmp	al,0Ah
		cmc				; Complement carry
		jnz	loc_b_1BA8		; Jump if not zero
		jmp	short loc_ret_b_1C07
		db	90h
loc_b_1BA8:
		dec	bl
		js	loc_b_1BAE		; Jump if sign=1
		jmp	short loc_b_1B9C
loc_b_1BAE:
		mov	al,data_b_00B0
		sub	al,13h
		cmc				; Complement carry
		mov	cl,al
		mov	bl,data_b_0050
		mov	si,cx
		mov	al,byte ptr ds:[8A3h][si]
		mov	byte ptr ds:[8B2h][bx],al
		mov	al,byte ptr ds:[8A8h][si]
		mov	byte ptr ds:[8B6h][bx],al
		mov	al,byte ptr ds:[8ADh][si]
		mov	byte ptr ds:[8BAh][bx],al
		mov	al,data_b_00B0
		mov	cl,data_b_0050
		mov	si,cx
		mov	byte ptr ds:[8BEh][si],al
		mov	byte ptr ds:[8D3h][si],al
		mov	data_b_00C3[si],al
		mov	al,0FCh
		mov	byte ptr ds:[8C2h][si],al
		mov	data_b_00C7[si],al
		mov	al,4
		mov	byte ptr ds:[8CFh][si],al
		mov	data_b_00D1[si],al
		mov	al,0
		inc	al
		dec	al
		mov	data_b_002A[si],al

loc_ret_b_1C07:
		retn
sub_b_16A4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1C08	proc	near
		mov	cl,3
loc_b_1C0A:
		mov	si,cx
		mov	al,byte ptr ds:[8BEh][si]
		inc	al
		dec	al
		jz	loc_b_1C19		; Jump if zero
		jmp	short loc_b_1C20
		db	90h
loc_b_1C19:
		dec	cl
		js	loc_ret_b_1C1F		; Jump if sign=1
		jmp	short loc_b_1C0A

loc_ret_b_1C1F:
		retn
loc_b_1C20:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[8CFh][si]
		mov	data_b_0033,al
		mov	al,byte ptr ds:[8D3h][si]
		mov	data_b_00B1,al
		mov	al,byte ptr ds:[8C2h][si]
		mov	cl,al
		mov	al,data_b_00B1
		cmp	al,16h
		cmc				; Complement carry
		jnz	loc_b_1C45		; Jump if not zero
		jmp	short loc_b_1C56
		db	90h
loc_b_1C45:
		cmp	al,17h
		cmc				; Complement carry
		jnz	loc_b_1C4D		; Jump if not zero
		jmp	short loc_b_1C56
		db	90h
loc_b_1C4D:
		mov	bl,9Bh
		inc	bl
		dec	bl
		jmp	short loc_b_1C58
		db	90h
loc_b_1C56:
		mov	bl,87h
loc_b_1C58:
		mov	data_b_00B0,bl
		call	sub_b_5053
		mov	cl,data_b_0050
		mov	si,cx
		mov	al,byte ptr ds:[8C2h][si]
		mov	data_b_00C7[si],al
		mov	al,byte ptr ds:[8D3h][si]
		mov	data_b_00C3[si],al
		mov	al,byte ptr ds:[8CFh][si]
		mov	data_b_00D1[si],al
		mov	al,data_b_00B0
		mov	data_b_00CB[si],al
		mov	al,byte ptr ds:[8D3h][si]
		cmp	al,16h
		cmc				; Complement carry
		jc	loc_b_1C90		; Jump if carry Set
		jmp	short loc_b_1CBB
		db	90h
loc_b_1C90:
		mov	al,data_b_0049
		and	al,0Fh
		jz	loc_b_1C9A		; Jump if zero
		jmp	short loc_b_1CBB
		db	90h
loc_b_1C9A:
		mov	al,byte ptr ds:[8D3h][si]
		cmp	al,16h
		cmc				; Complement carry
		jz	loc_b_1CA6		; Jump if zero
		jmp	short loc_b_1CB3
		db	90h
loc_b_1CA6:
		mov	al,17h
		inc	al
		dec	al
		mov	byte ptr ds:[8D3h][si],al
		jmp	short loc_b_1CBB
		db	90h
loc_b_1CB3:
		mov	al,16h
		mov	si,cx
		mov	byte ptr ds:[8D3h][si],al
loc_b_1CBB:
		mov	al,0
		mov	byte ptr ds:[0],al
		mov	si,cx
		mov	al,byte ptr ds:[8C2h][si]
		inc	al
		dec	al
		js	loc_b_1CCF		; Jump if sign=1
		jmp	short loc_b_1CD8
		db	90h
loc_b_1CCF:
		mov	al,1
		mov	byte ptr ds:[0],al
		mov	al,byte ptr ds:[8C2h][si]
loc_b_1CD8:
		sub	al,data_b_00AF
		cmc				; Complement carry
		mov	si,cx
		mov	byte ptr ds:[8C2h][si],al
		js	loc_b_1CE8		; Jump if sign=1
		jmp	short loc_b_1D24
		db	90h
loc_b_1CE8:
		mov	al,byte ptr ds:[0]
		inc	al
		dec	al
		jz	loc_b_1CF4		; Jump if zero
		jmp	short loc_b_1D24
		db	90h
loc_b_1CF4:
		mov	al,byte ptr ds:[8CFh][si]
		inc	al
		dec	al
		jns	loc_b_1D01		; Jump if not sign
		jmp	short loc_b_1D18
		db	90h
loc_b_1D01:
		mov	al,byte ptr ds:[8C2h][si]
		add	al,69h			; 'i'
		mov	byte ptr ds:[8C2h][si],al
		mov	al,0F5h
		inc	al
		dec	al
		mov	byte ptr ds:[8CFh][si],al
		jmp	short loc_b_1D24
		db	90h
loc_b_1D18:
		mov	al,0
		inc	al
		dec	al
		mov	si,cx
		mov	byte ptr ds:[8BEh][si],al
loc_b_1D24:
		jmp	loc_b_1C19
sub_b_1C08	endp

loc_b_1D27:
		push	ax
		mov	cl,3
loc_b_1D2A:
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		inc	al
		dec	al
		jz	loc_b_1D39		; Jump if zero
		jmp	short loc_b_1D42
		db	90h
loc_b_1D39:
		dec	cl
		jz	loc_b_1D3F		; Jump if zero
		jmp	short loc_b_1D2A
loc_b_1D3F:
		jmp	short loc_b_1D48
		db	90h
loc_b_1D42:
		pop	ax
		inc	al
		dec	al
		retn
loc_b_1D48:
		pop	ax
		inc	al
		dec	al
		cmp	al,88h
		cmc				; Complement carry
		jz	loc_b_1D55		; Jump if zero
		jmp	short loc_b_1D5A
		db	90h
loc_b_1D55:
		mov	al,3
		mov	byte ptr ds:[0],al
loc_b_1D5A:
		cmp	al,0C0h
		cmc				; Complement carry
		jz	loc_b_1D62		; Jump if zero
		jmp	short loc_b_1D67
		db	90h
loc_b_1D62:
		mov	al,2
		mov	byte ptr ds:[0],al
loc_b_1D67:
		cmp	al,48h			; 'H'
		cmc				; Complement carry
		jz	loc_b_1D6F		; Jump if zero
		jmp	short loc_b_1D74
		db	90h
loc_b_1D6F:
		mov	al,1
		mov	byte ptr ds:[0],al
loc_b_1D74:
		cmp	al,40h			; '@'
		cmc				; Complement carry
		jz	loc_b_1D7C		; Jump if zero
		jmp	short loc_b_1D81
		db	90h
loc_b_1D7C:
		mov	al,0
		mov	byte ptr ds:[0],al
loc_b_1D81:
		mov	cl,0
loc_b_1D83:
		mov	si,cx
		mov	al,byte ptr ds:[8F3h][si]
		inc	al
		dec	al
		jnz	loc_b_1D92		; Jump if not zero
		jmp	short loc_b_1DA6
		db	90h
loc_b_1D92:
		inc	cl
		cmp	cl,4
		cmc				; Complement carry
		jz	loc_b_1D9C		; Jump if zero
		jmp	short loc_b_1D83
loc_b_1D9C:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0048,al
		retn
loc_b_1DA6:
		mov	data_b_0050,cl
		mov	al,byte ptr ds:[0]
		cmp	al,2
		cmc				; Complement carry
		jz	loc_b_1DB5		; Jump if zero
		jmp	short loc_b_1DD6
		db	90h
loc_b_1DB5:
		mov	al,byte ptr ds:[0]
		mov	data_b_00B0,al
		mov	al,0Ah
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,0Ah
		mov	cl,data_b_0050
		mov	si,cx
		mov	byte ptr ds:[906h][si],al
		mov	al,data_b_00B0
		mov	byte ptr ds:[0],al
loc_b_1DD6:
		mov	al,1
		mov	si,cx
		mov	byte ptr ds:[8F3h][si],al
		mov	al,0Eh
		add	al,byte ptr ds:[0]
		mov	byte ptr ds:[8E7h][si],al
		mov	al,0FCh
		mov	byte ptr ds:[8D7h][si],al
		mov	byte ptr ds:[8DFh][si],al
		mov	bl,byte ptr ds:[0]
		mov	al,4
		mov	byte ptr ds:[8EBh][si],al
		mov	byte ptr ds:[8EFh][si],al
		mov	al,byte ptr ds:[8F7h][bx]
		mov	byte ptr ds:[8DBh][si],al
		mov	byte ptr ds:[8E3h][si],al
		mov	al,0
		inc	al
		dec	al
		mov	data_b_0086[si],al
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1E17	proc	near
		mov	cl,0
loc_b_1E19:
		mov	si,cx
		mov	al,byte ptr ds:[8F3h][si]
		inc	al
		dec	al
		jz	loc_b_1E28		; Jump if zero
		jmp	short loc_b_1E3C
		db	90h
loc_b_1E28:
		inc	cl
		cmp	cl,4
		cmc				; Complement carry
		jz	loc_b_1E32		; Jump if zero
		jmp	short loc_b_1E19
loc_b_1E32:
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[39h],al
		retn
loc_b_1E3C:
		mov	data_b_0016,cl
		mov	si,cx
		mov	al,byte ptr ds:[8EFh][si]
		mov	byte ptr ds:[39h],al
		mov	al,byte ptr ds:[8E7h][si]
		push	ax
		mov	al,byte ptr ds:[8E3h][si]
		mov	bl,al
		mov	al,byte ptr ds:[8DFh][si]
		mov	cl,al
		pop	ax
		and	al,7Fh
		call	sub_b_5034
		mov	cl,data_b_0016
		mov	al,data_b_0049
		and	al,3
		cmp	al,3
		cmc				; Complement carry
		jz	loc_b_1E71		; Jump if zero
		jmp	short loc_b_1E9C
		db	90h
loc_b_1E71:
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		cmp	al,11h
		cmc				; Complement carry
		jnz	loc_b_1E7F		; Jump if not zero
		jmp	short loc_b_1E94
		db	90h
loc_b_1E7F:
		cmp	al,12h
		cmc				; Complement carry
		jz	loc_b_1E87		; Jump if zero
		jmp	short loc_b_1E9C
		db	90h
loc_b_1E87:
		mov	al,11h
		inc	al
		dec	al
		mov	byte ptr ds:[8E7h][si],al
		jmp	short loc_b_1E9C
		db	90h
loc_b_1E94:
		mov	al,12h
		mov	si,cx
		mov	byte ptr ds:[8E7h][si],al
loc_b_1E9C:
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		mov	al,byte ptr ds:[8EBh][si]
		mov	byte ptr ds:[8EFh][si],al
		mov	byte ptr ds:[39h],al
		mov	al,byte ptr ds:[8E7h][si]
		mov	data_b_00B0,al
		mov	al,byte ptr ds:[8DBh][si]
		mov	byte ptr ds:[8E3h][si],al
		mov	bl,al
		mov	al,byte ptr ds:[8D7h][si]
		mov	byte ptr ds:[8DFh][si],al
		mov	cl,al
		mov	al,data_b_00B0
		inc	al
		dec	al
		js	loc_b_1ED4		; Jump if sign=1
		jmp	short loc_b_1ED7
		db	90h
loc_b_1ED4:
		jmp	loc_b_1FC8
loc_b_1ED7:
		call	sub_b_5015
		mov	cl,data_b_0016
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		cmp	al,10h
		cmc				; Complement carry
		jz	loc_b_1EEC		; Jump if zero
		jmp	short loc_b_1F5C
		db	90h
loc_b_1EEC:
		mov	al,byte ptr ds:[90Ah][si]
		inc	al
		dec	al
		jz	loc_b_1EF9		; Jump if zero
		jmp	short loc_b_1F5C
		db	90h
loc_b_1EF9:
		dec	byte ptr ds:[906h][si]
		jz	loc_b_1F02		; Jump if zero
		jmp	short loc_b_1F5C
		db	90h
loc_b_1F02:
		mov	bl,3
loc_b_1F04:
		mov	al,byte ptr ds:[8F3h][bx]
		inc	al
		dec	al
		jz	loc_b_1F11		; Jump if zero
		jmp	short loc_b_1F1A
		db	90h
loc_b_1F11:
		dec	bl
		js	loc_b_1F17		; Jump if sign=1
		jmp	short loc_b_1F04
loc_b_1F17:
		jmp	short loc_b_1F3E
		db	90h
loc_b_1F1A:
		mov	al,byte ptr ds:[8EFh][bx]
		inc	al
		dec	al
		jns	loc_b_1F26		; Jump if not sign
		jmp	short loc_b_1F11
loc_b_1F26:
		mov	al,byte ptr ds:[8DFh][bx]
		add	al,1Ch
		jnc	loc_b_1F30		; Jump if carry=0
		jmp	short loc_b_1F11
loc_b_1F30:
		mov	si,cx
		cmp	al,byte ptr ds:[8DFh][si]
		cmc				; Complement carry
		jnc	loc_b_1F3B		; Jump if carry=0
		jmp	short loc_b_1F11
loc_b_1F3B:
		jmp	short loc_b_1F5C
		db	90h
loc_b_1F3E:
		mov	si,cx
		mov	al,byte ptr ds:[8DFh][si]
		add	al,0Ah
		mov	byte ptr ds:[90Ah][si],al
		mov	cl,al
		mov	al,0
		mov	byte ptr ds:[39h],al
		mov	bl,8Fh
		mov	al,0Bh
		call	sub_b_4FD7
		mov	cl,data_b_0016
loc_b_1F5C:
		mov	al,0
		mov	byte ptr ds:[0],al
		mov	si,cx
		mov	al,byte ptr ds:[8D7h][si]
		inc	al
		dec	al
		js	loc_b_1F70		; Jump if sign=1
		jmp	short loc_b_1F79
		db	90h
loc_b_1F70:
		mov	al,1
		mov	byte ptr ds:[0],al
		mov	al,byte ptr ds:[8D7h][si]
loc_b_1F79:
		sub	al,data_b_00AF
		cmc				; Complement carry
		mov	si,cx
		mov	byte ptr ds:[8D7h][si],al
		js	loc_b_1F89		; Jump if sign=1
		jmp	short loc_b_1FAC
		db	90h
loc_b_1F89:
		mov	al,byte ptr ds:[0]
		inc	al
		dec	al
		jz	loc_b_1F95		; Jump if zero
		jmp	short loc_b_1FAC
		db	90h
loc_b_1F95:
		mov	al,byte ptr ds:[8EBh][si]
		inc	al
		dec	al
		js	loc_b_1FA2		; Jump if sign=1
		jmp	short loc_b_1FAF
		db	90h
loc_b_1FA2:
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[8F3h][si],al
loc_b_1FAC:
		jmp	loc_b_1E28
loc_b_1FAF:
		mov	si,cx
		mov	al,byte ptr ds:[8D7h][si]
		add	al,69h			; 'i'
		mov	byte ptr ds:[8D7h][si],al
		mov	al,0F5h
		inc	al
		dec	al
		mov	byte ptr ds:[8EBh][si],al
		jmp	loc_b_1E28
loc_b_1FC8:
		mov	al,0
		mov	cl,data_b_0016
		inc	cl
		dec	cl
		mov	si,cx
		mov	byte ptr ds:[8F3h][si],al
		jmp	loc_b_1E28
sub_b_1E17	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_1FDB	proc	near
		call	sub_b_5072
		mov	al,data_b_0043
		mov	data_b_0041,al
		inc	data_b_0043
		mov	al,data_b_0043
		cmp	al,8Dh
		cmc				; Complement carry
		jz	loc_b_1FF3		; Jump if zero
		jmp	short loc_ret_b_1FFC
		db	90h
loc_b_1FF3:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_0043,al

loc_ret_b_1FFC:
		retn
sub_b_1FDB	endp

		db	0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2000	proc	near
		mov	al,0Fh
		mov	byte ptr ds:[0],al
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jnz	loc_b_2011		; Jump if not zero
		jmp	short loc_b_2016
		db	90h
loc_b_2011:
		mov	al,18h
		mov	byte ptr ds:[0],al
loc_b_2016:
		mov	al,byte ptr ds:[0]
		mov	data_b_00A7,al
		mov	al,6
		mov	data_b_00A6,al
		mov	al,data_b_007C
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,data_b_007B
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,data_b_007A
		inc	al
		dec	al
		call	sub_b_2132
		retn
sub_b_2000	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2040	proc	near
		mov	al,6
		mov	data_b_00A7,al
		mov	al,6
		mov	data_b_00A6,al
		mov	al,byte ptr ds:[22Fh]
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,byte ptr ds:[230h]
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,byte ptr ds:[231h]
		inc	al
		dec	al
		call	sub_b_2132
		retn
sub_b_2040	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2069	proc	near
		mov	al,byte ptr ds:[22Fh]
		cmp	al,data_b_007C
		cmc				; Complement carry
		jnz	loc_b_2076		; Jump if not zero
		jmp	short loc_b_207E
		db	90h
loc_b_2076:
		jnc	loc_b_207B		; Jump if carry=0
		jmp	short loc_ret_b_20BE
		nop
loc_b_207B:
		jmp	short loc_b_20A5
		db	90h
loc_b_207E:
		mov	al,byte ptr ds:[230h]
		cmp	al,data_b_007B
		cmc				; Complement carry
		jnz	loc_b_208B		; Jump if not zero
		jmp	short loc_b_2093
		db	90h
loc_b_208B:
		jnc	loc_b_2090		; Jump if carry=0
		jmp	short loc_ret_b_20BE
		nop
loc_b_2090:
		jmp	short loc_b_20A5
		db	90h
loc_b_2093:
		mov	al,byte ptr ds:[231h]
		cmp	al,data_b_007A
		cmc				; Complement carry
		jnz	loc_b_20A0		; Jump if not zero
		jmp	short loc_ret_b_20BE
		db	90h
loc_b_20A0:
		jnc	loc_b_20A5		; Jump if carry=0
		jmp	short loc_ret_b_20BE
		db	90h
loc_b_20A5:
		mov	al,data_b_007C
		mov	byte ptr ds:[22Fh],al
		mov	al,data_b_007B
		mov	byte ptr ds:[230h],al
		mov	al,data_b_007A
		inc	al
		dec	al
		mov	byte ptr ds:[231h],al
		call	sub_b_2040

loc_ret_b_20BE:
		retn
sub_b_2069	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_20BF	proc	near
		mov	al,1Ah
		mov	data_b_00A6,al
		mov	al,73h			; 's'
		mov	data_b_00A7,al
		mov	al,byte ptr ds:[21Ah]
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,byte ptr ds:[21Bh]
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,byte ptr ds:[21Ch]
		inc	al
		dec	al
		call	sub_b_2132
		retn
sub_b_20BF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_20E8	proc	near
		mov	al,18h
		mov	data_b_00A6,al
		mov	al,0Fh
		mov	data_b_00A7,al
		mov	al,data_b_007E
		inc	al
		dec	al
		call	sub_b_22A3
		mov	al,data_b_007D
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,1
		add	al,data_b_007D
		daa				; Decimal adjust
		mov	data_b_007D,al
		mov	al,0
		adc	al,data_b_007E
		daa				; Decimal adjust
		mov	data_b_007E,al
		mov	al,data_b_007E
		cmp	al,0Ah
		cmc				; Complement carry
		jc	loc_b_2125		; Jump if carry Set
		jmp	short loc_ret_b_2131
		db	90h
loc_b_2125:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_007E,al
		mov	data_b_007D,al

loc_ret_b_2131:
		retn
sub_b_20E8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2132	proc	near
		push	ax
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		call	sub_b_22A3
		pop	ax
		rcl	ah,1			; Rotate thru carry
		and	al,0Fh
		rcr	ah,1			; Rotate thru carry
		call	sub_b_22A3
		retn
sub_b_2132	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2149	proc	near
		push	ax
		mov	al,data_b_007C
		mov	data_b_00B0,al
		pop	ax
		push	ax
		mov	al,cl
		push	ax
		mov	al,bl
		add	al,data_b_007A
		daa				; Decimal adjust
		mov	data_b_007A,al
		pop	ax
		adc	al,data_b_007B
		daa				; Decimal adjust
		mov	data_b_007B,al
		pop	ax
		adc	al,data_b_007C
		daa				; Decimal adjust
		mov	data_b_007C,al
		mov	al,data_b_00B0
		cmp	al,0
		cmc				; Complement carry
		jz	loc_b_217C		; Jump if zero
		jmp	short loc_b_218B
		db	90h
loc_b_217C:
		mov	al,data_b_007C
		inc	al
		dec	al
		jnz	loc_b_2188		; Jump if not zero
		jmp	short loc_b_218B
		nop
loc_b_2188:
		jmp	short loc_b_21C4
		db	90h
loc_b_218B:
		mov	al,data_b_00B0
		cmp	al,3
		cmc				; Complement carry
		jnc	loc_b_2196		; Jump if carry=0
		jmp	short loc_b_21A4
		db	90h
loc_b_2196:
		mov	al,data_b_007C
		cmp	al,3
		cmc				; Complement carry
		jc	loc_b_21A1		; Jump if carry Set
		jmp	short loc_b_21A4
		nop
loc_b_21A1:
		jmp	short loc_b_21C4
		db	90h
loc_b_21A4:
		mov	al,data_b_00B0
		cmp	al,5
		cmc				; Complement carry
		jnc	loc_b_21AF		; Jump if carry=0
		jmp	short loc_b_21BD
		db	90h
loc_b_21AF:
		mov	al,data_b_007C
		cmp	al,5
		cmc				; Complement carry
		jc	loc_b_21BA		; Jump if carry Set
		jmp	short loc_b_21BD
		nop
loc_b_21BA:
		jmp	short loc_b_21C4
		db	90h
loc_b_21BD:
		call	sub_b_2000
		call	sub_b_2069
		retn
loc_b_21C4:
		inc	byte ptr ds:[218h]
		call	sub_b_44E1
		jmp	short loc_b_21BD
sub_b_2149	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_21CD	proc	near
		push	ax
		mov	al,cl
		push	ax
		mov	al,bl
		add	al,byte ptr ds:[21Ch]
		daa				; Decimal adjust
		mov	byte ptr ds:[21Ch],al
		pop	ax
		adc	al,byte ptr ds:[21Bh]
		daa				; Decimal adjust
		mov	byte ptr ds:[21Bh],al
		pop	ax
		adc	al,byte ptr ds:[21Ah]
		daa				; Decimal adjust
		mov	byte ptr ds:[21Ah],al
		retn
sub_b_21CD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_21EE	proc	near
		pop	word ptr data_b_0004+1
		dec	word ptr data_b_0004+1
		mov	data_b_0003,cl
		mov	byte ptr data_b_0004,bl
loc_b_21FE:
		inc	byte ptr data_b_0004+1
		jz	loc_b_2207		; Jump if zero
		jmp	short loc_b_220B
		db	90h
loc_b_2207:
		inc	byte ptr data_b_0006
loc_b_220B:
		mov	cl,0
		mov	si,word ptr data_b_0004+1
		mov	al,cs:[si]
		or	al,80h
		cmp	al,0C0h
		cmc				; Complement carry
		jnz	loc_b_221E		; Jump if not zero
		jmp	short loc_b_2259
		db	90h
loc_b_221E:
		cmp	al,0A0h
		cmc				; Complement carry
		jnz	loc_b_2226		; Jump if not zero
		jmp	short loc_b_2232
		db	90h
loc_b_2226:
		push	ax
		mov	al,byte ptr ds:[21Dh]
		inc	al
		dec	al
		call	sub_b_4E76
		pop	ax
loc_b_2232:
		mov	cl,data_b_0003
		mov	bl,byte ptr data_b_0004
		and	al,7Fh
		cmp	al,41h			; 'A'
		cmc				; Complement carry
		jnc	loc_b_2244		; Jump if carry=0
		jmp	short loc_b_2246
		db	90h
loc_b_2244:
		sub	al,1
loc_b_2246:
		cmp	al,40h			; '@'
		cmc				; Complement carry
		jc	loc_b_224E		; Jump if carry Set
		jmp	short loc_b_2250
		db	90h
loc_b_224E:
		sub	al,41h			; 'A'
loc_b_2250:
		call	sub_b_4FBA
		inc	data_b_0003
		jmp	short loc_b_21FE
loc_b_2259:
		inc	word ptr data_b_0004+1
		jmp	word ptr data_b_0004+1
sub_b_21EE	endp

loc_b_2261:
		mov	al,byte ptr ds:[21Ah]
		mov	cl,byte ptr ds:[21Bh]
		mov	bl,byte ptr ds:[21Ch]
		inc	bl
		dec	bl
		call	sub_b_2149
loc_b_2273:
		mov	cl,1Bh
loc_b_2275:
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_2284		; Jump if sign=1
		jmp	short loc_b_2275
loc_b_2284:
		mov	al,0
		mov	data_b_007D,al
		mov	data_b_007E,al
		mov	al,data_b_0078
		mov	data_b_0098,al
		cmp	al,19h
		cmc				; Complement carry
		jz	loc_b_229A		; Jump if zero
		jmp	short loc_b_229D
		db	90h
loc_b_229A:
		jmp	loc_b_3E73
loc_b_229D:
		call	sub_b_3266
		jmp	loc_b_3CA7

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_22A3	proc	near
		mov	cl,data_b_00A6
		mov	bl,data_b_00A7
		add	al,2Fh			; '/'
		call	sub_b_4FBA
		inc	data_b_00A6
		retn
sub_b_22A3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_22B5	proc	near
		mov	al,data_b_0078
		cmp	al,4
		cmc				; Complement carry
		jz	loc_b_22C0		; Jump if zero
		jmp	short loc_b_22C9
		db	90h
loc_b_22C0:
		mov	al,0
		inc	al
		dec	al
		jmp	short loc_b_230E
		db	90h
loc_b_22C9:
		cmp	al,9
		cmc				; Complement carry
		jz	loc_b_22D1		; Jump if zero
		jmp	short loc_b_22DA
		db	90h
loc_b_22D1:
		mov	al,2
		inc	al
		dec	al
		jmp	short loc_b_230E
		db	90h
loc_b_22DA:
		cmp	al,0Eh
		cmc				; Complement carry
		jz	loc_b_22E2		; Jump if zero
		jmp	short loc_b_22EB
		db	90h
loc_b_22E2:
		mov	al,4
		inc	al
		dec	al
		jmp	short loc_b_230E
		db	90h
loc_b_22EB:
		cmp	al,13h
		cmc				; Complement carry
		jz	loc_b_22F3		; Jump if zero
		jmp	short loc_b_22FC
		db	90h
loc_b_22F3:
		mov	al,6
		inc	al
		dec	al
		jmp	short loc_b_230E
		db	90h
loc_b_22FC:
		cmp	al,19h
		cmc				; Complement carry
		jz	loc_b_2304		; Jump if zero
		jmp	short loc_ret_b_230D
		db	90h
loc_b_2304:
		mov	al,8
		inc	al
		dec	al
		jmp	short loc_b_230E
		db	90h

loc_ret_b_230D:
		retn
loc_b_230E:
		push	ax
		mov	al,data_b_0098
		cmp	al,data_b_0078
		cmc				; Complement carry
		jz	loc_b_231C		; Jump if zero
		jmp	short loc_b_2322
		db	90h
loc_b_231C:
		pop	ax
		inc	al
		dec	al
		retn
loc_b_2322:
		call	sub_b_3FB6
		pop	ax
		mov	byte ptr ds:[21Eh],al
		cmp	al,8
		cmc				; Complement carry
		jz	loc_b_2331		; Jump if zero
		jmp	short loc_b_233A
		db	90h
loc_b_2331:
		call	sub_b_1218
		call	sub_b_4C75
		jmp	short loc_b_233D
		db	90h
loc_b_233A:
		call	sub_b_4C70
loc_b_233D:
		call	sub_b_3266
		mov	al,data_b_007D
		sub	al,1
		das				; Decimal adjust
		mov	data_b_007D,al
		mov	al,data_b_007E
		sbb	al,0
		das				; Decimal adjust
		cmc				; Complement carry
		mov	data_b_007E,al
		mov	al,0
		mov	data_b_009D,al
		mov	al,0D0h
		mov	byte ptr ds:[21Dh],al
		mov	al,0
		mov	data_b_00F2,al
		mov	cl,8
		mov	bl,2Dh			; '-'
		inc	bl
		dec	bl
		call	sub_b_21EE
		push	sp
		dec	cx
		dec	bp
		inc	bp
		and	[si+4Fh],dl
		and	[bp+si+45h],dl
		inc	cx
		inc	bx
		dec	ax
		and	[bx+si+4Fh],dl
		dec	cx
		dec	si
		push	sp
		and	ss:data_d_A2A0_e[bp+si],ah
		inc	ax
		mov	al,data_b_0078
		mov	cl,1Dh
		mov	bl,2Dh			; '-'
		call	sub_b_4FBA
		mov	cl,1Eh
		mov	bl,2Dh			; '-'
		inc	bl
		dec	bl
		call	sub_b_21EE
		mov	ds:data_b_B140_e,al
		pop	es
		mov	bl,41h			; 'A'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	cx
		dec	di
		push	bp
		push	dx
		and	[si+49h],dl
		dec	bp
		inc	bp
		db	'          :@'
		db	0B0h, 1Ch,0A2h,0A6h, 00h,0B0h
		db	 41h,0A2h,0A7h, 00h,0A0h, 7Eh
		db	 00h,0FEh,0C0h,0FEh,0C8h,0E8h
		db	0D3h,0FEh,0A0h, 7Dh, 00h,0FEh
		db	0C0h,0FEh,0C8h,0E8h, 58h,0FDh
		db	0B1h, 07h,0B3h, 50h,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 09h,0FEh
		db	'THE AVERAGE TIME   :@'
		db	0B0h, 1Ch,0A2h,0A6h, 00h,0B0h
		db	 50h,0A2h,0A7h, 00h,0A0h, 80h
		db	 00h,0FEh,0C0h,0FEh,0C8h,0E8h
		db	 95h,0FEh,0A0h, 7Fh, 00h,0FEh
		db	0C0h,0FEh,0C8h,0E8h, 1Ah,0FDh
		db	0B1h, 07h,0B3h, 5Fh,0FEh,0C3h
		db	0FEh,0CBh,0E8h,0CBh,0FDh
		db	'TOP RECORD'
		db	9 dup (20h)
		db	 3Ah, 40h,0B0h, 1Ch,0A2h,0A6h
		db	 00h,0B0h, 5Fh,0A2h,0A7h, 00h
		db	 8Ah, 0Eh, 1Eh, 02h, 8Bh,0F1h
		db	 8Ah, 84h, 0Eh, 09h,0A2h, 32h
		db	 02h, 8Ah, 84h, 0Fh, 09h,0A2h
		db	 33h, 02h,0A0h, 16h, 02h,0FEh
		db	0C0h,0FEh,0C8h, 75h, 03h,0EBh
		db	 0Fh, 90h, 8Ah, 84h, 18h, 09h
		db	0A2h, 32h, 02h, 8Ah, 84h, 19h
		db	 09h,0A2h, 33h, 02h,0A0h, 32h
		db	 02h,0FEh,0C0h,0FEh,0C8h,0E8h
		db	 29h,0FEh,0A0h, 33h, 02h,0FEh
		db	0C0h,0FEh,0C8h,0E8h,0AEh,0FCh
		db	0A0h, 7Eh, 00h, 3Ah, 06h, 32h
		db	 02h,0F5h, 75h, 03h,0EBh, 09h
		db	 90h
loc_b_2491:
		jnc	loc_b_2496		; Jump if carry=0
		jmp	short loc_b_24A9
		nop
loc_b_2496:
		jmp	short loc_b_24B5
		db	90h
loc_b_2499:
		mov	al,data_b_007D
		cmp	al,byte ptr ds:[233h]
		cmc				; Complement carry
		jnc	loc_b_24A6		; Jump if carry=0
		jmp	short loc_b_24A9
		nop
loc_b_24A6:
		jmp	short loc_b_24B5
		db	90h
loc_b_24A9:
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[220h],al
		jmp	short loc_b_24BA
		db	90h
loc_b_24B5:
		mov	al,1
		mov	byte ptr ds:[220h],al
loc_b_24BA:
		mov	al,data_b_007E
		cmp	al,data_b_0080
		cmc				; Complement carry
		jc	loc_b_24C7		; Jump if carry Set
		jmp	short loc_b_24E4
		db	90h
loc_b_24C7:
		jnz	loc_b_24CC		; Jump if not zero
		jmp	short loc_b_24CF
		nop
loc_b_24CC:
		jmp	short loc_b_24F0
		db	90h
loc_b_24CF:
		mov	al,data_b_007D
		cmp	al,data_b_007F
		cmc				; Complement carry
		jc	loc_b_24DC		; Jump if carry Set
		jmp	short loc_b_24E4
		db	90h
loc_b_24DC:
		jnz	loc_b_24E1		; Jump if not zero
		jmp	short loc_b_24E4
		nop
loc_b_24E1:
		jmp	short loc_b_24F0
		db	90h
loc_b_24E4:
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[21Fh],al
		jmp	short loc_b_24F5
		db	90h
loc_b_24F0:
		mov	al,1
		mov	byte ptr ds:[21Fh],al
loc_b_24F5:
		mov	al,1
		mov	byte ptr ds:[21Dh],al
		mov	al,byte ptr ds:[21Fh]
		inc	al
		dec	al
		jnz	loc_b_2506		; Jump if not zero
		jmp	short loc_b_2535
		db	90h
loc_b_2506:
		mov	al,byte ptr ds:[21Eh]
		cmp	al,8
		cmc				; Complement carry
		jnz	loc_b_2511		; Jump if not zero
		jmp	short loc_b_2530
		db	90h
loc_b_2511:
		mov	cl,0Bh
		mov	bl,73h			; 's'
		inc	bl
		dec	bl
		call	sub_b_21EE
		push	bx
		dec	di
		push	dx
		push	dx
		pop	cx
		and	[bp+4Fh],cl
		and	[bp+si+4Fh],al
		dec	si
		push	bp
		push	bx
		and	[bx+di],ah
		inc	ax
		jmp	loc_b_2273
loc_b_2530:
		mov	al,1
		mov	data_b_00F2,al
loc_b_2535:
		mov	al,byte ptr ds:[220h]
		inc	al
		dec	al
		jnz	loc_b_2541		; Jump if not zero
		jmp	short loc_b_25AA
		db	90h
loc_b_2541:
		mov	al,data_b_007E
		mov	byte ptr ds:[232h],al
		mov	al,data_b_007D
		mov	byte ptr ds:[233h],al
		mov	cl,7
		mov	bl,82h
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	cx
		dec	di
		push	bp
		and	[bx+si+41h],cl
		push	si
		inc	bp
		and	[bp+si+52h],al
		dec	di
		dec	bx
		inc	bp
		dec	si
		and	[bx+di+20h],al
		push	dx
		inc	bp
		inc	bx
		dec	di
		push	dx
		inc	sp
		and	[bx+di],ah
		inc	ax
		mov	cl,byte ptr ds:[21Eh]
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		jnz	loc_b_2583		; Jump if not zero
		jmp	short loc_b_259A
		db	90h
loc_b_2583:
		mov	al,byte ptr ds:[232h]
		mov	si,cx
		mov	byte ptr ds:[918h][si],al
		mov	al,byte ptr ds:[233h]
		inc	al
		dec	al
		mov	byte ptr ds:[919h][si],al
		jmp	short loc_b_25AA
		db	90h
loc_b_259A:
		mov	al,byte ptr ds:[232h]
		mov	si,cx
		mov	byte ptr ds:[90Eh][si],al
		mov	al,byte ptr ds:[233h]
		mov	byte ptr ds:[90Fh][si],al
loc_b_25AA:
		mov	al,data_b_00F2
		inc	al
		dec	al
		jnz	loc_b_25B6		; Jump if not zero
		jmp	short loc_b_25DB
		db	90h
loc_b_25B6:
		mov	cl,4
		mov	bl,73h			; 's'
		inc	bl
		dec	bl
		call	sub_b_21EE
		push	bx
		push	ax
		inc	bp
		inc	bx
		dec	cx
		inc	cx
		dec	sp
		and	[bp+si+4Fh],al
		dec	si
		push	bp
		push	bx
		and	[bx+si+4Fh],dl
		dec	cx
		dec	si
		push	sp
		push	bx
		and	[bx+si],ah
		inc	ax
		jmp	short loc_b_25FA
		db	90h
loc_b_25DB:
		mov	cl,7
		mov	bl,73h			; 's'
		inc	bl
		dec	bl
		call	sub_b_21EE
		inc	di
		dec	di
		dec	di
		inc	sp
		and	[bp+si+4Fh],al
		dec	si
		push	bp
		push	bx
		and	[bx+si+4Fh],dl
		dec	cx
		dec	si
		push	sp
		push	bx
		and	[bx+si],ah
		inc	ax
loc_b_25FA:
		mov	al,byte ptr ds:[21Eh]
		cmp	al,8
		cmc				; Complement carry
		jz	loc_b_2605		; Jump if zero
		jmp	short loc_b_2639
		db	90h
loc_b_2605:
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		jnz	loc_b_2611		; Jump if not zero
		jmp	short loc_b_2625
		db	90h
loc_b_2611:
		mov	al,1
		mov	byte ptr ds:[21Ah],al
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[21Bh],al
		mov	byte ptr ds:[21Ch],al
		jmp	short loc_b_265B
		db	90h
loc_b_2625:
		mov	al,0
		mov	byte ptr ds:[21Ah],al
		mov	byte ptr ds:[21Ch],al
		mov	al,50h			; 'P'
		inc	al
		dec	al
		mov	byte ptr ds:[21Bh],al
		jmp	short loc_b_265B
		db	90h
loc_b_2639:
		mov	al,0
		mov	byte ptr ds:[21Ah],al
		mov	byte ptr ds:[21Ch],al
		mov	al,10h
		mov	byte ptr ds:[21Bh],al
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		jnz	loc_b_2652		; Jump if not zero
		jmp	short loc_b_265B
		db	90h
loc_b_2652:
		mov	al,20h			; ' '
		inc	al
		dec	al
		mov	byte ptr ds:[21Bh],al
loc_b_265B:
		call	sub_b_20BF
		mov	al,1Ch
		mov	data_b_00A6,al
		mov	al,41h			; 'A'
		mov	data_b_00A7,al
		mov	al,data_b_007E
		inc	al
		dec	al
		call	sub_b_22A3
		mov	al,data_b_007D
		inc	al
		dec	al
		call	sub_b_2132
		mov	al,data_b_00F2
		inc	al
		dec	al
		jz	loc_b_2688		; Jump if zero
		jmp	short loc_b_26A2
		db	90h
loc_b_2688:
		mov	al,data_b_007E
		cmp	al,data_b_0080
		cmc				; Complement carry
		jz	loc_b_2695		; Jump if zero
		jmp	short loc_b_26A5
		db	90h
loc_b_2695:
		mov	al,data_b_007D
		cmp	al,data_b_007F
		cmc				; Complement carry
		jz	loc_b_26A2		; Jump if zero
		jmp	short loc_b_26A5
		db	90h
loc_b_26A2:
		jmp	loc_b_2261
loc_b_26A5:
		mov	al,1
		add	al,data_b_007D
		daa				; Decimal adjust
		mov	data_b_007D,al
		mov	al,0
		adc	al,data_b_007E
		daa				; Decimal adjust
		mov	data_b_007E,al
		mov	al,0
		mov	cl,1
		mov	bl,0
		inc	bl
		dec	bl
		call	sub_b_21CD
		mov	cl,2
loc_b_26C8:
		mov	al,0A0h
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_26D7		; Jump if sign=1
		jmp	short loc_b_26C8
loc_b_26D7:
		mov	bl,50h			; 'P'
loc_b_26D9:
		call	sub_b_4E8B
		mov	al,11h
		inc	al
		dec	al
		call	sub_b_4E76
		dec	bl
		js	loc_b_26EB		; Jump if sign=1
		jmp	short loc_b_26D9
loc_b_26EB:
		jmp	loc_b_265B
sub_b_22B5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_26EE	proc	near
		mov	cl,3
loc_b_26F0:
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		inc	al
		dec	al
		jnz	loc_b_26FF		; Jump if not zero
		jmp	short loc_b_2707
		db	90h
loc_b_26FF:
		cmp	al,0Eh
		cmc				; Complement carry
		jc	loc_b_2707		; Jump if carry Set
		jmp	short loc_b_2710
		db	90h
loc_b_2707:
		dec	cl
		js	loc_b_270D		; Jump if sign=1
		jmp	short loc_b_26F0
loc_b_270D:
		jmp	loc_b_2815
loc_b_2710:
		mov	data_b_0050,cl
		mov	si,cx
		dec	byte ptr ds:[85Bh][si]
		jz	loc_b_271E		; Jump if zero
		jmp	short loc_b_2707
loc_b_271E:
		mov	al,28h			; '('
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,0Fh
		mov	cl,data_b_0050
		mov	si,cx
		mov	byte ptr ds:[85Bh][si],al
		mov	al,byte ptr ds:[867h][si]
		inc	al
		dec	al
		jz	loc_b_273F		; Jump if zero
		jmp	short loc_b_2707
loc_b_273F:
		mov	al,1
		mov	byte ptr data_b_0006,al
		mov	al,byte ptr ds:[82Bh][si]
		cmp	al,0Ch
		cmc				; Complement carry
		jnc	loc_b_2750		; Jump if carry=0
		jmp	short loc_b_27B7
		db	90h
loc_b_2750:
		mov	al,78h			; 'x'
		mov	byte ptr data_b_0006,al
		mov	bl,3
loc_b_2757:
		mov	al,byte ptr ds:[8F3h][bx]
		inc	al
		dec	al
		jz	loc_b_2764		; Jump if zero
		jmp	short loc_b_276D
		db	90h
loc_b_2764:
		dec	bl
		js	loc_b_276A		; Jump if sign=1
		jmp	short loc_b_2757
loc_b_276A:
		jmp	short loc_b_278E
		db	90h
loc_b_276D:
		mov	al,byte ptr ds:[8EFh][bx]
		inc	al
		dec	al
		jns	loc_b_2779		; Jump if not sign
		jmp	short loc_b_2764
loc_b_2779:
		mov	al,byte ptr ds:[8DFh][bx]
		add	al,1Ch
		jnc	loc_b_2784		; Jump if carry=0
		jmp	short loc_b_278B
		db	90h
loc_b_2784:
		cmp	al,6Eh			; 'n'
		cmc				; Complement carry
		jc	loc_b_278B		; Jump if carry Set
		jmp	short loc_b_2764
loc_b_278B:
		jmp	loc_b_2707
loc_b_278E:
		mov	bl,3
loc_b_2790:
		mov	al,byte ptr ds:[8BEh][bx]
		inc	al
		dec	al
		jz	loc_b_279D		; Jump if zero
		jmp	loc_b_2707
loc_b_279D:
		dec	bl
		js	loc_b_27A3		; Jump if sign=1
		jmp	short loc_b_2790
loc_b_27A3:
		mov	bl,3
loc_b_27A5:
		mov	al,byte ptr ds:[867h][bx]
		cmp	al,0Ah
		cmc				; Complement carry
		jnz	loc_b_27B1		; Jump if not zero
		jmp	loc_b_2707
loc_b_27B1:
		dec	bl
		js	loc_b_27B7		; Jump if sign=1
		jmp	short loc_b_27A5
loc_b_27B7:
		mov	si,cx
		mov	al,byte ptr ds:[823h][si]
		cmp	al,byte ptr data_b_0006
		cmc				; Complement carry
		jc	loc_b_27C7		; Jump if carry Set
		jmp	loc_b_2707
loc_b_27C7:
		add	al,0Ah
		cmp	al,0DCh
		cmc				; Complement carry
		jnc	loc_b_27D1		; Jump if carry=0
		jmp	loc_b_2707
loc_b_27D1:
		mov	byte ptr ds:[86Bh][si],al
		mov	al,byte ptr ds:[827h][si]
		add	al,8
		mov	byte ptr ds:[86Fh][si],al
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		cmp	al,0Eh
		cmc				; Complement carry
		jnc	loc_b_27ED		; Jump if carry=0
		jmp	loc_b_2707
loc_b_27ED:
		cmp	al,0Ch
		cmc				; Complement carry
		jnz	loc_b_27F5		; Jump if not zero
		jmp	short loc_b_2806
		db	90h
loc_b_27F5:
		cmp	al,0Dh
		cmc				; Complement carry
		jnz	loc_b_27FD		; Jump if not zero
		jmp	short loc_b_2806
		db	90h
loc_b_27FD:
		mov	al,0Ah
		inc	al
		dec	al
		jmp	short loc_b_280C
		db	90h
loc_b_2806:
		mov	al,9
		inc	al
		dec	al
loc_b_280C:
		mov	si,cx
		mov	byte ptr ds:[867h][si],al
		jmp	loc_b_2707
loc_b_2815:
		mov	cl,3
loc_b_2817:
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		inc	al
		dec	al
		jz	loc_b_2826		; Jump if zero
		jmp	short loc_b_282D
		db	90h
loc_b_2826:
		dec	cl
		js	loc_ret_b_282C		; Jump if sign=1
		jmp	short loc_b_2817

loc_ret_b_282C:
		retn
loc_b_282D:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		push	ax
		mov	bl,byte ptr ds:[86Fh][si]
		mov	al,byte ptr ds:[86Bh][si]
		mov	cl,al
		pop	ax
		call	sub_b_4FF6
		mov	cl,data_b_0050
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		cmp	al,9
		cmc				; Complement carry
		jnz	loc_b_2858		; Jump if not zero
		jmp	short loc_b_2868
		db	90h
loc_b_2858:
		cmp	al,0Ah
		cmc				; Complement carry
		jnz	loc_b_2860		; Jump if not zero
		jmp	short loc_b_2868
		db	90h
loc_b_2860:
		cmp	al,2
		cmc				; Complement carry
		jnc	loc_b_2868		; Jump if carry=0
		jmpn	loc_b_28E7
loc_b_2868:
		mov	si,cx
		inc	byte ptr ds:[86Bh][si]
		inc	byte ptr ds:[86Bh][si]
		mov	al,byte ptr ds:[86Bh][si]
		and	al,0FEh
		mov	byte ptr ds:[86Bh][si],al
		mov	al,byte ptr ds:[86Fh][si]
		add	al,4
		mov	byte ptr ds:[86Fh][si],al
		cmp	al,8Ch
		cmc				; Complement carry
		jc	loc_b_288E		; Jump if carry Set
		jmp	loc_b_2919
loc_b_288E:
		mov	al,byte ptr ds:[867h][si]
		cmp	al,0Ah
		cmc				; Complement carry
		jz	loc_b_289A		; Jump if zero
		jmp	short loc_b_28D3
		db	90h
loc_b_289A:
		mov	al,cl
		push	ax
		mov	al,1
		mov	data_b_0085,al
		mov	al,14h
		inc	al
		dec	al
		call	sub_b_1B6F
		mov	al,3Ch			; '<'
		mov	data_b_0046,al
		mov	al,0
		mov	data_b_0085,al
		mov	al,cl
		mov	bl,al
		pop	ax
		mov	cl,al
		mov	si,cx
		mov	al,byte ptr ds:[86Bh][si]
		sub	al,22h			; '"'
		and	al,0FCh
		mov	byte ptr ds:[8C2h][bx],al
		mov	al,0Bh
		mov	byte ptr ds:[867h][si],al
		jmp	short loc_b_28DB
		db	90h
loc_b_28D3:
		mov	al,1
		mov	si,cx
		mov	byte ptr ds:[867h][si],al
loc_b_28DB:
		mov	si,cx
		mov	al,byte ptr ds:[86Bh][si]
		sub	al,0Eh
		mov	byte ptr ds:[86Bh][si],al
loc_b_28E7:
		mov	si,cx
		inc	byte ptr ds:[867h][si]
		mov	al,89h
		mov	byte ptr ds:[86Fh][si],al
		mov	al,byte ptr ds:[867h][si]
		cmp	al,6
		cmc				; Complement carry
		jnz	loc_b_28FF		; Jump if not zero
		jmp	short loc_b_290A
		db	90h
loc_b_28FF:
		cmp	al,0Eh
		cmc				; Complement carry
		jnz	loc_b_2907		; Jump if not zero
		jmp	short loc_b_290A
		nop
loc_b_2907:
		jmp	short loc_b_2919
		db	90h
loc_b_290A:
		mov	al,0
		inc	al
		dec	al
		mov	si,cx
		mov	byte ptr ds:[867h][si],al
		jmp	loc_b_2826
loc_b_2919:
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		cmp	al,0Ah
		cmc				; Complement carry
		jnz	loc_b_2927		; Jump if not zero
		jmp	short loc_b_2932
		db	90h
loc_b_2927:
		cmp	al,9
		cmc				; Complement carry
		jnz	loc_b_292F		; Jump if not zero
		jmp	short loc_b_2932
		nop
loc_b_292F:
		jmp	short loc_b_2973
		db	90h
loc_b_2932:
		mov	si,cx
		mov	al,byte ptr ds:[86Fh][si]
		add	al,5
		cmp	al,data_b_0058
		cmc				; Complement carry
		jc	loc_b_2944		; Jump if carry Set
		jmp	short loc_b_2973
		db	90h
loc_b_2944:
		mov	al,byte ptr ds:[86Bh][si]
		add	al,2
		cmp	al,data_b_0057
		cmc				; Complement carry
		jc	loc_b_2954		; Jump if carry Set
		jmp	short loc_b_2973
		db	90h
loc_b_2954:
		mov	al,data_b_0057
		add	al,24h			; '$'
		cmp	al,byte ptr ds:[86Bh][si]
		cmc				; Complement carry
		jc	loc_b_2963		; Jump if carry Set
		jmp	short loc_b_2973
		db	90h
loc_b_2963:
		mov	al,1
		mov	data_b_0070,al
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[867h][si],al
		retn
loc_b_2973:
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		push	ax
		mov	bl,byte ptr ds:[86Fh][si]
		mov	al,byte ptr ds:[86Bh][si]
		mov	cl,al
		pop	ax
		call	sub_b_4FD7
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		jmp	loc_b_2826
sub_b_26EE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2993	proc	near
		mov	cl,3
loc_b_2995:
		mov	si,cx
		mov	al,byte ptr ds:[82Bh][si]
		inc	al
		dec	al
		jnz	loc_b_29A4		; Jump if not zero
		jmp	short loc_b_29D8
		db	90h
loc_b_29A4:
		jns	loc_b_29A9		; Jump if not sign
		jmp	short loc_b_29D8
		db	90h
loc_b_29A9:
		cmp	al,0Eh
		cmc				; Complement carry
		jnc	loc_b_29B1		; Jump if carry=0
		jmp	short loc_b_29D8
		db	90h
loc_b_29B1:
		sub	al,8
		cmc				; Complement carry
		mov	bl,al
		mov	al,byte ptr ds:[873h][bx]
		mov	si,cx
		mov	byte ptr ds:[893h][si],al
		mov	al,byte ptr ds:[87Bh][bx]
		mov	byte ptr ds:[897h][si],al
		mov	al,byte ptr ds:[883h][bx]
		mov	byte ptr ds:[89Bh][si],al
		mov	al,byte ptr ds:[88Bh][bx]
		mov	byte ptr ds:[89Fh][si],al
loc_b_29D8:
		dec	cl
		js	loc_b_29DE		; Jump if sign=1
		jmp	short loc_b_2995
loc_b_29DE:
		mov	bl,3
loc_b_29E0:
		mov	al,byte ptr ds:[82Bh][bx]
		inc	al
		dec	al
		jnz	loc_b_29ED		; Jump if not zero
		jmp	short loc_b_29FD
		db	90h
loc_b_29ED:
		jns	loc_b_29F2		; Jump if not sign
		jmp	short loc_b_29FD
		db	90h
loc_b_29F2:
		cmp	al,0Eh
		cmc				; Complement carry
		jnc	loc_b_29FA		; Jump if carry=0
		jmp	short loc_b_29FD
		nop
loc_b_29FA:
		jmp	short loc_b_2A04
		db	90h
loc_b_29FD:
		dec	bl
		js	loc_ret_b_2A03		; Jump if sign=1
		jmp	short loc_b_29E0

loc_ret_b_2A03:
		retn
loc_b_2A04:
		mov	al,byte ptr ds:[823h][bx]
		add	al,byte ptr ds:[89Fh][bx]
		cmp	al,data_b_0057
		cmc				; Complement carry
		jc	loc_b_2A16		; Jump if carry Set
		jmp	short loc_b_2A47
		db	90h
loc_b_2A16:
		mov	al,data_b_0057
		add	al,26h			; '&'
		adc	al,byte ptr ds:[89Bh][bx]
		cmp	al,byte ptr ds:[823h][bx]
		cmc				; Complement carry
		jc	loc_b_2A29		; Jump if carry Set
		jmp	short loc_b_2A47
		db	90h
loc_b_2A29:
		mov	al,byte ptr ds:[827h][bx]
		add	al,byte ptr ds:[897h][bx]
		sub	al,3
		cmp	al,data_b_0058
		cmc				; Complement carry
		jc	loc_b_2A3D		; Jump if carry Set
		jmp	short loc_b_2A47
		db	90h
loc_b_2A3D:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0070,al
		retn
loc_b_2A47:
		jmp	short loc_b_29FD
sub_b_2993	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2A49	proc	near
		mov	al,data_b_0078
		mov	cl,19h
		mov	bl,6
		call	sub_b_4FBA
		retn
sub_b_2A49	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2A54	proc	near
		mov	cl,3
loc_b_2A56:
		mov	si,cx
		mov	al,byte ptr ds:[8BEh][si]
		inc	al
		dec	al
		jz	loc_b_2A65		; Jump if zero
		jmp	short loc_b_2A6C
		db	90h
loc_b_2A65:
		dec	cl
		js	loc_ret_b_2A6B		; Jump if sign=1
		jmp	short loc_b_2A56

loc_ret_b_2A6B:
		retn
loc_b_2A6C:
		mov	data_b_0050,cl
		mov	al,85h
		mov	byte ptr data_b_0004+1,al
		mov	si,cx
		mov	al,data_b_00C3[si]
		cmp	al,16h
		cmc				; Complement carry
		jnz	loc_b_2A83		; Jump if not zero
		jmp	short loc_b_2A97
		db	90h
loc_b_2A83:
		cmp	al,17h
		cmc				; Complement carry
		jz	loc_b_2A8B		; Jump if zero
		jmp	short loc_b_2A9C
		db	90h
loc_b_2A8B:
		mov	al,85h
		inc	al
		dec	al
		mov	byte ptr data_b_0004+1,al
		jmp	short loc_b_2A9C
		db	90h
loc_b_2A97:
		mov	al,7Bh			; '{'
		mov	byte ptr data_b_0004+1,al
loc_b_2A9C:
		mov	si,cx
		mov	al,data_b_00D1[si]
		inc	al
		dec	al
		jns	loc_b_2AAB		; Jump if not sign
		jmp	short loc_b_2B15
		db	90h
loc_b_2AAB:
		mov	al,data_b_00C7[si]
		add	al,1Ch
		jnc	loc_b_2AB5		; Jump if carry=0
		jmp	short loc_b_2A65
loc_b_2AB5:
		add	al,byte ptr ds:[8B2h][si]
		jnc	loc_b_2ABD		; Jump if carry=0
		jmp	short loc_b_2A65
loc_b_2ABD:
		cmp	al,96h
		cmc				; Complement carry
		jnc	loc_b_2AC4		; Jump if carry=0
		jmp	short loc_b_2A65
loc_b_2AC4:
		mov	byte ptr ds:[0],al
		mov	bl,byte ptr ds:[8B6h][si]
		add	al,byte ptr ds:[93Ah][bx]
		jnc	loc_b_2AD3		; Jump if carry=0
		jmp	short loc_b_2A65
loc_b_2AD3:
		add	al,byte ptr ds:[8BAh][si]
		jnc	loc_b_2ADB		; Jump if carry=0
		jmp	short loc_b_2A65
loc_b_2ADB:
		sub	al,7
		mov	byte ptr ds:[1],al
		mov	al,data_b_0057
		add	al,24h			; '$'
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jc	loc_b_2AEF		; Jump if carry Set
		jmp	loc_b_2A65
loc_b_2AEF:
		mov	al,data_b_0057
		add	al,3
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jnc	loc_b_2AFE		; Jump if carry=0
		jmp	loc_b_2A65
loc_b_2AFE:
		mov	al,data_b_0058
		cmp	al,byte ptr data_b_0004+1
		cmc				; Complement carry
		jc	loc_b_2B0B		; Jump if carry Set
		jmp	loc_b_2A65
loc_b_2B0B:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0070,al
		retn
loc_b_2B15:
		mov	al,0
		mov	data_b_0003,al
		mov	si,cx
		mov	al,data_b_00C7[si]
		sub	al,4Dh			; 'M'
		cmc				; Complement carry
		jnc	loc_b_2B28		; Jump if carry=0
		jmp	short loc_b_2B2F
		db	90h
loc_b_2B28:
		push	ax
		mov	al,1
		mov	data_b_0003,al
		pop	ax
loc_b_2B2F:
		mov	si,cx
		add	al,byte ptr ds:[8B2h][si]
		mov	byte ptr ds:[0],al
		mov	bl,byte ptr ds:[8B6h][si]
		add	al,byte ptr ds:[93Ah][bx]
		add	al,byte ptr ds:[8BAh][si]
		js	loc_b_2B49		; Jump if sign=1
		jmp	short loc_b_2B4C
		db	90h
loc_b_2B49:
		jmp	loc_b_2A65
loc_b_2B4C:
		mov	byte ptr ds:[1],al
		mov	al,data_b_0003
		inc	al
		dec	al
		jz	loc_b_2B5B		; Jump if zero
		jmp	short loc_b_2B6D
		db	90h
loc_b_2B5B:
		mov	al,data_b_0057
		add	al,24h			; '$'
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jnc	loc_b_2B6A		; Jump if carry=0
		jmp	short loc_b_2B6D
		db	90h
loc_b_2B6A:
		jmp	loc_b_2A65
loc_b_2B6D:
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jc	loc_b_2B7A		; Jump if carry Set
		jmp	short loc_b_2B7D
		db	90h
loc_b_2B7A:
		jmp	loc_b_2A65
loc_b_2B7D:
		mov	al,data_b_0058
		cmp	al,byte ptr data_b_0004+1
		cmc				; Complement carry
		jnc	loc_b_2B8A		; Jump if carry=0
		jmp	short loc_b_2B8D
		db	90h
loc_b_2B8A:
		jmp	loc_b_2A65
loc_b_2B8D:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0070,al
		retn
sub_b_2A54	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2B97	proc	near
		mov	cl,3
loc_b_2B99:
		mov	si,cx
		mov	al,byte ptr ds:[8F3h][si]
		inc	al
		dec	al
		jz	loc_b_2BA8		; Jump if zero
		jmp	short loc_b_2BAF
		db	90h
loc_b_2BA8:
		dec	cl
		js	loc_ret_b_2BAE		; Jump if sign=1
		jmp	short loc_b_2B99

loc_ret_b_2BAE:
		retn
loc_b_2BAF:
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		sub	al,0Eh
		cmc				; Complement carry
		mov	bl,al
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[8EFh][si]
		inc	al
		dec	al
		jns	loc_b_2BCD		; Jump if not sign
		jmp	short loc_b_2C30
		db	90h
loc_b_2BCD:
		mov	al,byte ptr ds:[8DFh][si]
		add	al,1Ch
		jnc	loc_b_2BD7		; Jump if carry=0
		jmp	short loc_b_2BA8
loc_b_2BD7:
		add	al,1
		jnc	loc_b_2BDD		; Jump if carry=0
		jmp	short loc_b_2BA8
loc_b_2BDD:
		cmp	al,96h
		cmc				; Complement carry
		jnc	loc_b_2BE4		; Jump if carry=0
		jmp	short loc_b_2BA8
loc_b_2BE4:
		mov	byte ptr ds:[0],al
		add	al,byte ptr ds:[901h][bx]
		jnc	loc_b_2BEF		; Jump if carry=0
		jmp	short loc_b_2BA8
loc_b_2BEF:
		sub	al,2
		mov	byte ptr ds:[1],al
		mov	al,data_b_0057
		add	al,2Ah			; '*'
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jc	loc_b_2C02		; Jump if carry Set
		jmp	short loc_b_2BA8
loc_b_2C02:
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jnc	loc_b_2C0E		; Jump if carry=0
		jmp	short loc_b_2BA8
loc_b_2C0E:
		mov	al,data_b_0058
		add	al,10h
		add	al,byte ptr ds:[8CAh][bx]
		cmp	al,byte ptr ds:[8E3h][si]
		cmc				; Complement carry
		jnz	loc_b_2C20		; Jump if not zero
		jmp	short loc_b_2BA8
loc_b_2C20:
		jc	loc_b_2C24		; Jump if carry Set
		jmp	short loc_b_2BA8
loc_b_2C24:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0070,al
		jmp	short loc_b_2CA3
		db	90h
loc_b_2C30:
		mov	al,0
		mov	data_b_0003,al
		mov	si,cx
		mov	al,byte ptr ds:[8DFh][si]
		sub	al,4Dh			; 'M'
		cmc				; Complement carry
		jnc	loc_b_2C43		; Jump if carry=0
		jmp	short loc_b_2C48
		db	90h
loc_b_2C43:
		mov	al,1
		mov	data_b_0003,al
loc_b_2C48:
		add	al,1
		mov	byte ptr ds:[0],al
		add	al,byte ptr ds:[901h][bx]
		sub	al,2
		cmc				; Complement carry
		jns	loc_b_2C59		; Jump if not sign
		jmp	loc_b_2BA8
loc_b_2C59:
		mov	byte ptr ds:[1],al
		mov	al,data_b_0003
		inc	al
		dec	al
		jz	loc_b_2C68		; Jump if zero
		jmp	short loc_b_2C7A
		db	90h
loc_b_2C68:
		mov	al,data_b_0057
		add	al,26h			; '&'
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jnc	loc_b_2C77		; Jump if carry=0
		jmp	short loc_b_2C7A
		db	90h
loc_b_2C77:
		jmp	loc_b_2BA8
loc_b_2C7A:
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jc	loc_b_2C87		; Jump if carry Set
		jmp	short loc_b_2C8A
		db	90h
loc_b_2C87:
		jmp	loc_b_2BA8
loc_b_2C8A:
		mov	al,data_b_0058
		add	al,10h
		mov	si,cx
		cmp	al,byte ptr ds:[8E3h][si]
		cmc				; Complement carry
		jnc	loc_b_2C9B		; Jump if carry=0
		jmp	short loc_b_2C9E
		db	90h
loc_b_2C9B:
		jmp	loc_b_2BA8
loc_b_2C9E:
		mov	al,1
		mov	data_b_0070,al
loc_b_2CA3:
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[8F3h][si],al
		mov	al,byte ptr ds:[8EFh][si]
		mov	byte ptr ds:[39h],al
		mov	al,byte ptr ds:[8E7h][si]
		mov	data_b_00B0,al
		mov	al,byte ptr ds:[8E3h][si]
		mov	bl,al
		mov	al,byte ptr ds:[8DFh][si]
		mov	cl,al
		mov	al,data_b_00B0
		and	al,7Fh
		call	sub_b_5034
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[39h],al
		retn
sub_b_2B97	endp

loc_b_2CD7:
		mov	al,2
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,84h
		mov	data_b_0058,al
		mov	al,data_b_006D
		inc	al
		dec	al
		jns	loc_b_2CF1		; Jump if not sign
		jmp	short loc_ret_b_2CF5
		db	90h
loc_b_2CF1:
		dec	data_b_006D

loc_ret_b_2CF5:
		retn
loc_b_2CF6:
		call	sub_b_1FDB
		mov	al,1
		mov	data_b_0048,al
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		mov	data_b_0075,96Ah
		mov	data_b_0073,956h
		call	sub_b_1282
		mov	data_b_0073,0C46h
		mov	data_b_0075,0C93h
		mov	al,0
		mov	data_b_00A0,al
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		mov	al,22h			; '"'
		mov	data_b_006D,al
		mov	al,46h			; 'F'
		mov	data_b_0067,al
loc_b_2D3A:
		mov	al,79h			; 'y'
		inc	al
		dec	al
		mov	data_b_0068,al
		call	sub_b_4BAE
		mov	al,data_b_0067
		and	al,1
		mov	data_b_0017,al
		mov	al,data_b_006E
		sub	al,data_b_0017
		mov	data_b_006E,al
		inc	data_b_0049
		mov	al,data_b_0049
		and	al,1
		jz	loc_b_2D66		; Jump if zero
		jmp	short loc_b_2D69
		db	90h
loc_b_2D66:
		call	sub_b_1FDB
loc_b_2D69:
		mov	al,0Dh
		mov	data_b_006C,al
		mov	al,data_b_0068
		cmp	al,99h
		cmc				; Complement carry
		jnc	loc_b_2D79		; Jump if carry=0
		jmp	short loc_b_2D85
		db	90h
loc_b_2D79:
		mov	al,0Dh
		inc	al
		dec	al
		mov	data_b_006C,al
		jmp	short loc_b_2D8A
		db	90h
loc_b_2D85:
		mov	al,0FFh
		mov	data_b_006C,al
loc_b_2D8A:
		call	sub_b_52A6
		inc	data_b_0068
		mov	al,data_b_0068
		cmp	al,0A5h
		cmc				; Complement carry
		jnz	loc_b_2D9C		; Jump if not zero
		jmp	short loc_b_2D9E
		nop
loc_b_2D9C:
		jmp	short loc_b_2D69
loc_b_2D9E:
		call	sub_b_0982
		dec	data_b_0067
		jnz	loc_b_2DAA		; Jump if not zero
		jmp	short loc_b_2DAC
		nop
loc_b_2DAA:
		jmp	short loc_b_2D3A
loc_b_2DAC:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_006F,al
		mov	data_b_0048,al
		call	sub_b_4BAE
		call	sub_b_096D
		jmp	loc_b_07CF

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2DC1	proc	near
		mov	cl,3
loc_b_2DC3:
		mov	si,cx
		mov	al,byte ptr ds:[8F3h][si]
		inc	al
		dec	al
		jz	loc_b_2DD2		; Jump if zero
		jmp	short loc_b_2DD9
		db	90h
loc_b_2DD2:
		dec	cl
		js	loc_ret_b_2DD8		; Jump if sign=1
		jmp	short loc_b_2DC3

loc_ret_b_2DD8:
		retn
loc_b_2DD9:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		cmp	al,11h
		cmc				; Complement carry
		jnz	loc_b_2DEA		; Jump if not zero
		jmp	short loc_b_2DD2
loc_b_2DEA:
		cmp	al,12h
		cmc				; Complement carry
		jnz	loc_b_2DF1		; Jump if not zero
		jmp	short loc_b_2DD2
loc_b_2DF1:
		mov	al,byte ptr ds:[8EFh][si]
		inc	al
		dec	al
		jns	loc_b_2DFD		; Jump if not sign
		jmp	short loc_b_2DD2
loc_b_2DFD:
		mov	al,data_b_001A
		inc	al
		dec	al
		jnz	loc_b_2E08		; Jump if not zero
		jmp	short loc_ret_b_2DD8
loc_b_2E08:
		mov	al,byte ptr ds:[8E7h][si]
		sub	al,0Eh
		mov	bl,al
		mov	al,byte ptr ds:[8DFh][si]
		add	al,1Ch
		jnc	loc_b_2E1A		; Jump if carry=0
		jmp	short loc_b_2DD2
loc_b_2E1A:
		mov	byte ptr ds:[0],al
		add	al,19h
		jnc	loc_b_2E23		; Jump if carry=0
		jmp	short loc_b_2DD2
loc_b_2E23:
		mov	byte ptr ds:[1],al
		mov	al,byte ptr ds:[8FCh][bx]
		mov	byte ptr data_b_0006,al
		mov	al,data_b_001B
		test	data_b_001C,80h
		js	loc_b_2E3A		; Jump if sign=1
		jmp	short loc_b_2E3C
		db	90h
loc_b_2E3A:
		add	al,5
loc_b_2E3C:
		add	al,byte ptr data_b_0006
		mov	si,cx
		cmp	al,byte ptr ds:[8E3h][si]
		cmc				; Complement carry
		jc	loc_b_2E4B		; Jump if carry Set
		jmp	short loc_b_2DD2
loc_b_2E4B:
		mov	al,data_b_001A
		add	al,5
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jc	loc_b_2E5A		; Jump if carry Set
		jmp	loc_b_2DD2
loc_b_2E5A:
		sub	al,0Ch
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jnc	loc_b_2E66		; Jump if carry=0
		jmp	loc_b_2DD2
loc_b_2E66:
		mov	al,data_b_009D
		inc	al
		dec	al
		jz	loc_b_2E72		; Jump if zero
		jmp	loc_b_2DD2
loc_b_2E72:
		mov	al,1
		mov	data_b_009D,al
		mov	al,data_b_001C
		inc	al
		dec	al
		jns	loc_b_2E83		; Jump if not sign
		jmp	short loc_b_2E88
		db	90h
loc_b_2E83:
		mov	al,0FFh
		mov	data_b_001C,al
loc_b_2E88:
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		or	al,80h
		mov	byte ptr ds:[8E7h][si],al
		cmp	al,90h
		cmc				; Complement carry
		jnz	loc_b_2E9C		; Jump if not zero
		jmp	short loc_b_2EAC
		db	90h
loc_b_2E9C:
		mov	al,0
		mov	cl,1
		mov	bl,0
		inc	bl
		dec	bl
		call	sub_b_2149
		jmp	short loc_b_2EB9
		db	90h
loc_b_2EAC:
		mov	al,0
		mov	cl,2
		mov	bl,0
		inc	bl
		dec	bl
		call	sub_b_2149
loc_b_2EB9:
		jmp	loc_b_3DB2
sub_b_2DC1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2EBC	proc	near
		mov	al,1Eh
		mov	si,cx
		mov	byte ptr ds:[84Bh][si],al
		mov	al,14h
		mov	byte ptr ds:[83Bh][si],al
		mov	al,14h
		mov	byte ptr ds:[847h][si],al
		mov	al,14h
		mov	byte ptr ds:[837h][si],al
		mov	al,23h			; '#'
		mov	byte ptr ds:[827h][si],al
		mov	al,73h			; 's'
		inc	al
		dec	al
		mov	data_b_0016,cl
		call	sub_b_31E0
		mov	cl,data_b_0016
		add	al,8Ch
		mov	si,cx
		mov	byte ptr ds:[823h][si],al
		mov	al,0
		mov	byte ptr ds:[82Fh][si],al
		mov	byte ptr ds:[833h][si],al
		mov	al,data_b_004E
		rcl	ah,1			; Rotate thru carry
		or	al,1
		mov	data_b_0020,al
		mov	al,data_b_004F
		or	al,1
		mov	data_b_0021,al
		xor	al,data_b_0020
		rcr	ah,1			; Rotate thru carry
		mov	data_b_0022,al
		retn
sub_b_2EBC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_2F1B	proc	near
		mov	si,cx
		mov	al,byte ptr ds:[84Fh][si]
		inc	al
		dec	al
		jnz	loc_b_2F2A		; Jump if not zero
		jmp	short loc_b_2F7D
		db	90h
loc_b_2F2A:
		mov	al,byte ptr ds:[823h][si]
		cmp	al,8Ch
		cmc				; Complement carry
		jnc	loc_b_2F36		; Jump if carry=0
		jmp	short loc_b_2F7D
		db	90h
loc_b_2F36:
		mov	byte ptr ds:[0],al
		mov	al,byte ptr ds:[83Bh][si]
		inc	al
		dec	al
		js	loc_b_2F46		; Jump if sign=1
		jmp	short loc_b_2F7D
		db	90h
loc_b_2F46:
		mov	al,0
		mov	byte ptr ds:[843h][si],al
		mov	al,byte ptr ds:[0]
		sub	al,4
		cmc				; Complement carry
		jnc	loc_b_2F57		; Jump if carry=0
		jmp	short loc_b_2FAD
		db	90h
loc_b_2F57:
		mov	al,byte ptr ds:[853h][si]
		inc	al
		dec	al
		jnz	loc_b_2F64		; Jump if not zero
		jmp	short loc_b_2F6F
		db	90h
loc_b_2F64:
		mov	al,0FFh
		inc	al
		dec	al
		mov	byte ptr ds:[82Bh][si],al
		retn
loc_b_2F6F:
		add	al,2Ah			; '*'
		mov	si,cx
		mov	byte ptr ds:[823h][si],al
		mov	al,0FAh
		mov	byte ptr ds:[853h][si],al
loc_b_2F7D:
		mov	si,cx
		mov	al,byte ptr ds:[83Bh][si]
		inc	al
		dec	al
		pushf				; Push flags
		js	loc_b_2F8D		; Jump if sign=1
		jmp	short loc_b_2F91
		db	90h
loc_b_2F8D:
		xor	al,0FFh
		add	al,1
loc_b_2F91:
		mov	bl,al
		mov	al,data_b_0D22[bx]
		popf				; Pop flags
		js	loc_b_2F9D		; Jump if sign=1
		jmp	short loc_b_2FA1
		db	90h
loc_b_2F9D:
		xor	al,0FFh
		add	al,1
loc_b_2FA1:
		mov	si,cx
		add	al,byte ptr ds:[823h][si]
		rcl	ah,1			; Rotate thru carry
		and	al,0FEh
		rcr	ah,1			; Rotate thru carry
loc_b_2FAD:
		mov	si,cx
		mov	byte ptr ds:[823h][si],al
		mov	si,cx
		mov	al,byte ptr ds:[84Fh][si]
		inc	al
		dec	al
		jnz	loc_b_2FC2		; Jump if not zero
		jmp	short loc_b_3010
		db	90h
loc_b_2FC2:
		mov	al,byte ptr ds:[82Bh][si]
		cmp	al,0Dh
		cmc				; Complement carry
		jnz	loc_b_2FCE		; Jump if not zero
		jmp	short loc_b_2FE9
		db	90h
loc_b_2FCE:
		cmp	al,0Ch
		cmc				; Complement carry
		jnz	loc_b_2FD6		; Jump if not zero
		jmp	short loc_b_2FE9
		db	90h
loc_b_2FD6:
		cmp	al,10h
		cmc				; Complement carry
		jc	loc_b_2FDE		; Jump if carry Set
		jmp	short loc_b_3010
		db	90h
loc_b_2FDE:
		cmp	al,14h
		cmc				; Complement carry
		jnc	loc_b_2FE6		; Jump if carry=0
		jmp	short loc_b_3010
		nop
loc_b_2FE6:
		jmp	short loc_b_300D
		db	90h
loc_b_2FE9:
		mov	si,cx
		mov	al,byte ptr ds:[827h][si]
		add	al,2
		mov	byte ptr ds:[827h][si],al
		cmp	al,86h
		cmc				; Complement carry
		jc	loc_b_2FFD		; Jump if carry Set
		jmp	short loc_b_300D
		db	90h
loc_b_2FFD:
		mov	al,89h
		mov	byte ptr ds:[827h][si],al
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[863h][si],al
loc_b_300D:
		jmp	short loc_b_303E
		db	90h
loc_b_3010:
		mov	si,cx
		mov	al,byte ptr ds:[837h][si]
		inc	al
		dec	al
		pushf				; Push flags
		js	loc_b_3020		; Jump if sign=1
		jmp	short loc_b_3024
		db	90h
loc_b_3020:
		xor	al,0FFh
		add	al,1
loc_b_3024:
		mov	bl,al
		mov	al,byte ptr ds:[0CE1h][bx]
		popf				; Pop flags
		js	loc_b_3030		; Jump if sign=1
		jmp	short loc_b_3034
		db	90h
loc_b_3030:
		xor	al,0FFh
		add	al,1
loc_b_3034:
		mov	si,cx
		add	al,byte ptr ds:[827h][si]
		mov	byte ptr ds:[827h][si],al
loc_b_303E:
		mov	si,cx
		mov	al,byte ptr ds:[83Bh][si]
		sub	al,byte ptr ds:[843h][si]
		mov	byte ptr ds:[83Bh][si],al
		mov	al,byte ptr ds:[837h][si]
		sub	al,byte ptr ds:[83Fh][si]
		mov	byte ptr ds:[837h][si],al
		mov	al,byte ptr ds:[84Bh][si]
		xor	al,0FFh
		add	al,1
		mov	data_b_0017,al
		mov	al,byte ptr ds:[83Bh][si]
		sub	al,data_b_0017
		cmc				; Complement carry
		jnz	loc_b_3071		; Jump if not zero
		jmp	short loc_b_3082
		db	90h
loc_b_3071:
		jno	loc_b_3076		; Jump if not overflw
		jmp	short loc_b_307E
		db	90h
loc_b_3076:
		jns	loc_b_307B		; Jump if not sign
		jmp	short loc_b_3082
		nop
loc_b_307B:
		jmp	short loc_b_3091
		db	90h
loc_b_307E:
		jns	loc_b_3082		; Jump if not sign
		jmp	short loc_b_307B
loc_b_3082:
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[843h][si],al
		mov	al,data_b_0017
		mov	byte ptr ds:[83Bh][si],al
loc_b_3091:
		mov	si,cx
		mov	al,byte ptr ds:[83Bh][si]
		sub	al,byte ptr ds:[84Bh][si]
		cmc				; Complement carry
		jnz	loc_b_30A1		; Jump if not zero
		jmp	short loc_b_30AB
		db	90h
loc_b_30A1:
		jno	loc_b_30A6		; Jump if not overflw
		jmp	short loc_b_30AE
		db	90h
loc_b_30A6:
		js	loc_b_30AB		; Jump if sign=1
		jmp	short loc_b_30B2
		nop
loc_b_30AB:
		jmp	short loc_b_30C2
		db	90h
loc_b_30AE:
		js	loc_b_30B2		; Jump if sign=1
		jmp	short loc_b_30AB
loc_b_30B2:
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[843h][si],al
		mov	al,byte ptr ds:[84Bh][si]
		mov	byte ptr ds:[83Bh][si],al
loc_b_30C2:
		mov	si,cx
		mov	al,byte ptr ds:[847h][si]
		xor	al,0FFh
		add	al,1
		mov	data_b_0017,al
		mov	al,byte ptr ds:[837h][si]
		sub	al,data_b_0017
		cmc				; Complement carry
		jno	loc_b_30DD		; Jump if not overflw
		jmp	short loc_b_30E5
		db	90h
loc_b_30DD:
		jns	loc_b_30E2		; Jump if not sign
		jmp	short loc_b_30E9
		nop
loc_b_30E2:
		jmp	short loc_b_3117
		db	90h
loc_b_30E5:
		jns	loc_b_30E9		; Jump if not sign
		jmp	short loc_b_30E2
loc_b_30E9:
		mov	al,0Ah
		inc	al
		dec	al
		call	sub_b_31E0
		mov	cl,data_b_0050
		add	al,1
		xor	al,0FFh
		add	al,1
		mov	si,cx
		mov	byte ptr ds:[83Fh][si],al
		mov	al,28h			; '('
		inc	al
		dec	al
		call	sub_b_31E0
		mov	cl,data_b_0050
		add	al,1
		mov	si,cx
		mov	byte ptr ds:[847h][si],al
loc_b_3117:
		mov	si,cx
		mov	al,byte ptr ds:[837h][si]
		sub	al,byte ptr ds:[847h][si]
		cmc				; Complement carry
		jnz	loc_b_3127		; Jump if not zero
		jmp	short loc_b_3131
		db	90h
loc_b_3127:
		jno	loc_b_312C		; Jump if not overflw
		jmp	short loc_b_3134
		db	90h
loc_b_312C:
		js	loc_b_3131		; Jump if sign=1
		jmp	short loc_b_3138
		nop
loc_b_3131:
		jmp	short loc_b_3162
		db	90h
loc_b_3134:
		js	loc_b_3138		; Jump if sign=1
		jmp	short loc_b_3131
loc_b_3138:
		mov	al,0Ah
		inc	al
		dec	al
		call	sub_b_31E0
		mov	cl,data_b_0050
		add	al,1
		mov	si,cx
		mov	byte ptr ds:[83Fh][si],al
		mov	al,28h			; '('
		inc	al
		dec	al
		call	sub_b_31E0
		mov	cl,data_b_0050
		add	al,1
		mov	si,cx
		mov	byte ptr ds:[847h][si],al
loc_b_3162:
		mov	si,cx
		mov	al,byte ptr ds:[827h][si]
		cmp	al,41h			; 'A'
		cmc				; Complement carry
		jnc	loc_b_3170		; Jump if carry=0
		jmp	short loc_b_3183
		db	90h
loc_b_3170:
		mov	al,byte ptr ds:[837h][si]
		inc	al
		dec	al
		js	loc_b_317D		; Jump if sign=1
		jmp	short loc_b_3183
		db	90h
loc_b_317D:
		mov	al,0FBh
		mov	byte ptr ds:[83Fh][si],al
loc_b_3183:
		mov	si,cx
		mov	al,byte ptr ds:[827h][si]
		cmp	al,43h			; 'C'
		cmc				; Complement carry
		jc	loc_b_3191		; Jump if carry Set
		jmp	short loc_b_31AE
		db	90h
loc_b_3191:
		jnz	loc_b_3196		; Jump if not zero
		jmp	short loc_b_31AE
		db	90h
loc_b_3196:
		mov	al,byte ptr ds:[837h][si]
		inc	al
		dec	al
		jns	loc_b_31A3		; Jump if not sign
		jmp	short loc_b_31AE
		db	90h
loc_b_31A3:
		jnz	loc_b_31A8		; Jump if not zero
		jmp	short loc_b_31AE
		db	90h
loc_b_31A8:
		mov	al,5
		mov	byte ptr ds:[83Fh][si],al
loc_b_31AE:
		mov	si,cx
		mov	al,byte ptr ds:[823h][si]
		cmp	al,28h			; '('
		cmc				; Complement carry
		jnc	loc_b_31BC		; Jump if carry=0
		jmp	short loc_b_31C2
		db	90h
loc_b_31BC:
		mov	al,0F0h
		mov	byte ptr ds:[843h][si],al
loc_b_31C2:
		mov	si,cx
		mov	al,byte ptr ds:[823h][si]
		cmp	al,0BEh
		cmc				; Complement carry
		jc	loc_b_31D0		; Jump if carry Set
		jmp	short loc_ret_b_31DF
		db	90h
loc_b_31D0:
		jnz	loc_b_31D5		; Jump if not zero
		jmp	short loc_ret_b_31DF
		db	90h
loc_b_31D5:
		mov	al,18h
		inc	al
		dec	al
		mov	byte ptr ds:[843h][si],al

loc_ret_b_31DF:
		retn
sub_b_2F1B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_31E0	proc	near
		clc				; Clear carry flag
		mov	cl,al
		mov	bl,18h
loc_b_31E5:
		mov	al,data_b_0020
		rcl	al,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		rcl	ah,1			; Rotate thru carry
		xor	al,data_b_0020
		rcr	ah,1			; Rotate thru carry
		rcl	al,1			; Rotate thru carry
		mov	dh,data_b_0022
		rcl	dh,1			; Rotate thru carry
		mov	data_b_0022,dh
		mov	dh,data_b_0021
		rcl	dh,1			; Rotate thru carry
		mov	data_b_0021,dh
		mov	dh,data_b_0020
		rcl	dh,1			; Rotate thru carry
		mov	data_b_0020,dh
		dec	bl
		jz	loc_b_3220		; Jump if zero
		jmp	short loc_b_31E5
loc_b_3220:
		mov	al,data_b_0020
		add	al,data_b_0021
		adc	al,data_b_0022
		mov	byte ptr ds:[0],al
		mov	byte ptr ds:[1],cl
		mov	al,0
		mov	cl,8
loc_b_3236:
		shl	al,1			; Shift w/zeros fill
		mov	dh,byte ptr ds:[2]
		rcl	dh,1			; Rotate thru carry
		mov	byte ptr ds:[2],dh
		shl	byte ptr ds:[0],1	; Shift w/zeros fill
		jc	loc_b_324B		; Jump if carry Set
		jmp	short loc_b_3258
		db	90h
loc_b_324B:
		add	al,byte ptr ds:[1]
		jc	loc_b_3254		; Jump if carry Set
		jmp	short loc_b_3258
		db	90h
loc_b_3254:
		inc	byte ptr ds:[2]
loc_b_3258:
		dec	cl
		jz	loc_b_325E		; Jump if zero
		jmp	short loc_b_3236
loc_b_325E:
		mov	al,byte ptr ds:[2]
		inc	al
		dec	al
		retn
sub_b_31E0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3266	proc	near
		mov	al,0
		mov	data_b_006E,al
		call	sub_b_5113
		call	sub_b_4F0D
		mov	al,0
		mov	data_b_001A,al
		mov	cl,3
loc_b_3278:
		mov	si,cx
		mov	byte ptr ds:[82Bh][si],al
		mov	byte ptr ds:[8BEh][si],al
		mov	byte ptr ds:[8F3h][si],al
		mov	byte ptr ds:[0DEAh][si],al
		mov	byte ptr ds:[0DF2h][si],al
		mov	byte ptr ds:[90Ah][si],al
		mov	byte ptr ds:[867h][si],al
		dec	cl
		js	loc_ret_b_329C		; Jump if sign=1
		jmp	short loc_b_3278

loc_ret_b_329C:
		retn
sub_b_3266	endp

		db	 00h, 00h, 00h,0E8h,0CFh, 1Bh
		db	0E8h,0DDh, 1Bh,0B1h
		db	41h
loc_b_32A8:
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		mov	al,byte ptr data_b_0100
		inc	al
		dec	al
		jns	loc_b_32BD		; Jump if not sign
		jmp	short loc_b_32C3
		db	90h
loc_b_32BD:
		dec	cl
		jz	loc_b_32C3		; Jump if zero
		jmp	short loc_b_32A8
loc_b_32C3:
		call	sub_b_4E83
		call	sub_b_4EC6
		mov	al,0
		mov	byte ptr ds:[216h],al
		mov	byte ptr ds:[200h],al
		mov	byte ptr ds:[201h],al
		mov	byte ptr ds:[217h],al
		mov	al,2
		mov	al,0FFh
		mov	ds:data_b_896E_e,al
loc_b_32DE:
		mov	al,1
		mov	byte ptr ds:[225h],al
		call	sub_b_4E73
		call	sub_b_3490
		jc	loc_b_32EE		; Jump if carry Set
		jmp	short loc_b_32F1
		nop
loc_b_32EE:
		jmp	short loc_b_32F4
		db	90h
loc_b_32F1:
		jmp	loc_b_3721
loc_b_32F4:
		call	sub_b_4E83
		call	sub_b_3266
		call	sub_b_08C3
		mov	al,0
		mov	byte ptr ds:[235h],al
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		jz	loc_b_330E		; Jump if zero
		jmp	short loc_b_3314
		db	90h
loc_b_330E:
		mov	ax,549h
		jmp	short loc_b_3317
		db	90h
loc_b_3314:
		mov	ax,695h
loc_b_3317:
		mov	byte ptr ds:[226h],al
		mov	byte ptr ds:[227h],ah
		mov	byte ptr ds:[228h],al
		mov	byte ptr ds:[229h],ah
		mov	byte ptr ds:[20Ah],al
		mov	byte ptr ds:[20Ch],ah
		mov	byte ptr ds:[20Bh],al
		mov	byte ptr ds:[20Dh],ah
		call	sub_b_4EC6
		mov	al,0
		mov	data_b_002E,al
		mov	byte ptr ds:[225h],al
		mov	byte ptr ds:[22Ah],al
		mov	al,4
		mov	byte ptr ds:[214h],al
		mov	byte ptr ds:[215h],al
		mov	al,0
		mov	byte ptr ds:[20Eh],al
		mov	byte ptr ds:[20Fh],al
		mov	byte ptr ds:[208h],al
		mov	byte ptr ds:[209h],al
		mov	byte ptr ds:[206h],al
		mov	byte ptr ds:[207h],al
		mov	byte ptr ds:[204h],al
		mov	byte ptr ds:[205h],al
		mov	byte ptr ds:[22Dh],al
		mov	byte ptr ds:[22Eh],al
		mov	byte ptr ds:[22Bh],al
		mov	byte ptr ds:[22Ch],al
		mov	al,0FFh
		mov	byte ptr ds:[202h],al
		mov	byte ptr ds:[203h],al
		mov	al,byte ptr ds:[217h]
		inc	al
		dec	al
		jnz	loc_b_3383		; Jump if not zero
		jmp	short loc_b_3388
		db	90h
loc_b_3383:
		mov	al,1
		mov	data_b_00EE,al
loc_b_3388:
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		mov	byte ptr ds:[200h],al
		mov	byte ptr ds:[201h],al
		call	sub_b_41DC
		call	sub_b_44E1
		mov	al,ds:data_b_8852_e
		inc	al
		dec	al
		jnz	loc_b_33A7		; Jump if not zero
		jmp	short loc_b_33B3
		db	90h
loc_b_33A7:
		mov	al,0FFh
		inc	al
		dec	al
		mov	ds:data_b_896E_e,al
		jmp	short loc_b_33BC
		db	90h
loc_b_33B3:
		mov	al,0FFh
		inc	al
		dec	al
		mov	ds:data_b_896E_e,al
loc_b_33BC:
		call	sub_b_09CA
		call	sub_b_1FDB
		call	sub_b_4E72
		call	sub_b_3ECC
		mov	al,16h
		inc	al
		dec	al
		mov	data_b_00F3,al
		jmp	loc_b_2CF6

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_33D4	proc	near
		mov	al,1
		mov	byte ptr ds:[21Dh],al
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		jnz	loc_b_33E5		; Jump if not zero
		jmp	short loc_b_33F5
		db	90h
loc_b_33E5:
		mov	cl,0Dh
		mov	bl,96h
		inc	bl
		dec	bl
		call	sub_b_21EE
		inc	bx
		inc	ax
		jmp	short loc_b_3402
		db	90h
loc_b_33F5:
		mov	cl,0Dh
		mov	bl,96h
		inc	bl
		dec	bl
		call	sub_b_21EE
		inc	dx
		inc	ax
loc_b_3402:
		mov	al,ds:data_b_8853_e
		inc	al
		dec	al
		jnz	loc_b_340E		; Jump if not zero
		jmp	short loc_b_3425
		db	90h
loc_b_340E:
		mov	cl,0Bh
		mov	bl,0A0h
		inc	bl
		dec	bl
		call	sub_b_21EE
		dec	dx
		dec	di
		pop	cx
		push	bx
		push	sp
		dec	cx
		inc	bx
		dec	bx
		inc	ax
		jmp	short loc_b_3439
		db	90h
loc_b_3425:
		mov	cl,0Bh
		mov	bl,0A0h
		inc	bl
		dec	bl
		call	sub_b_21EE
		dec	bx
		inc	bp
		pop	cx
		inc	dx
		dec	di
		inc	cx
		push	dx
		inc	sp
		inc	ax
loc_b_3439:
		mov	al,byte ptr ds:[217h]
		inc	al
		dec	al
		jnz	loc_b_3445		; Jump if not zero
		jmp	short loc_b_3455
		db	90h
loc_b_3445:
		mov	cl,22h			; '"'
		mov	bl,96h
		inc	bl
		dec	bl
		call	sub_b_21EE
		xor	al,[bx+si-15h]
		push	cs
		nop
loc_b_3455:
		mov	cl,22h			; '"'
		mov	bl,96h
		inc	bl
		dec	bl
		call	sub_b_21EE
		xor	[bx+si-60h],ax
		push	dx
;*		mov	dh,bh
		db	 88h,0FEh		;  Fixup - byte match
		sar	dh,0C8h			; Shift w/sign fill
		jz	loc_b_346E		; Jump if zero
		jmp	short loc_b_3480
		db	90h
loc_b_346E:
		mov	cl,20h			; ' '
		mov	bl,0A0h
		inc	bl
		dec	bl
		call	sub_b_21EE
		dec	di
		inc	si
		inc	si
		inc	ax
;*		jmp	short loc_b_348F	;*
		db	0EBh, 10h		;  Fixup - byte match
		db	90h
loc_b_3480:
		mov	cl,20h			; ' '
		mov	bl,0A0h
		inc	bl
		dec	bl
		call	sub_b_21EE
		dec	di
		dec	si
		and	[bx+si-3Dh],al

;==== External Entry into Subroutine ======================================

sub_b_3490:
		call	sub_b_4E83
		call	sub_b_3266
		call	sub_b_4F44
		mov	al,1
		mov	byte ptr ds:[21Dh],al
		mov	cl,0Ah
		mov	bl,2Dh			; '-'
		inc	bl
		dec	bl
		call	sub_b_21EE
		dec	bp
		dec	di
		dec	di
		dec	si
		and	[bx+si+41h],dl
		push	sp
		push	dx
		dec	di
		dec	sp
		and	[bx+50h],cl
		push	sp
		dec	cx
		dec	di
		dec	si
		push	bx
		inc	ax
		mov	cl,0Bh
		mov	bl,41h			; 'A'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		dec	bx
		pop	bp
		and	[bp+di+45h],cl
		pop	cx
		inc	dx
		dec	di
		inc	cx
		push	dx
		inc	sp
		and	[di+4Fh],cl
		inc	sp
		inc	bp
		inc	ax
		mov	cl,0Bh
		mov	bl,4Bh			; 'K'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		dec	dx
		pop	bp
		and	[bp+si+4Fh],cl
		pop	cx
		push	bx
		push	sp
		dec	cx
		inc	bx
		dec	bx
		and	[di+4Fh],cl
		inc	sp
		inc	bp
		inc	ax
		mov	cl,0Bh
		mov	bl,55h			; 'U'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		xor	[di+20h],bx
		dec	di
		dec	si
		inc	bp
		and	[bx+si+4Ch],dl
		inc	cx
		pop	cx
		inc	bp
		push	dx
		and	[bx+50h],cl
		push	sp
		dec	cx
		dec	di
		dec	si
		inc	ax
		mov	cl,0Bh
		mov	bl,5Fh			; '_'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		xor	bl,[di+20h]
		push	sp
		push	di
		dec	di
		and	[bx+si+4Ch],dl
		inc	cx
		pop	cx
		inc	bp
		push	dx
		and	[bx+50h],cl
		push	sp
		dec	cx
		dec	di
		dec	si
		inc	ax
		mov	cl,0Bh
		mov	bl,69h			; 'i'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		inc	dx
		pop	bp
		and	[bp+si+45h],al
		inc	di
		dec	cx
		dec	si
		dec	si
		inc	bp
		push	dx
		and	[bp+di+4Fh],al
		push	bp
		push	dx
		push	bx
		inc	bp
		inc	ax
		mov	cl,0Bh
		mov	bl,73h			; 's'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		inc	bx
		pop	bp
		and	[bp+di+48h],al
		inc	cx
		dec	bp
		push	ax
		dec	cx
		dec	di
		dec	si
		and	[bp+di+4Fh],al
		push	bp
		push	dx
		push	bx
		inc	bp
		inc	ax
		mov	cl,0Bh
		mov	bl,7Dh			; '}'
		inc	bl
		dec	bl
		call	sub_b_21EE
		pop	bx
		push	bx
		pop	bp
		and	[bp+di+4Fh],dl
		push	bp
		dec	si
		inc	sp
		and	[bx+4Eh],cl
		and	[bx+52h],cl
		and	[bx+46h],cl
		inc	si
		inc	ax
		mov	cl,5
		mov	bl,96h
		inc	bl
		dec	bl
		call	sub_b_21EE
		inc	bx
		dec	di
		push	bp
		push	dx
		push	bx
		inc	bp
		and	[bx+si],ch
		and	[bx+di],ch
		inc	ax
		mov	cl,19h
		mov	bl,96h
		inc	bl
		dec	bl
		call	sub_b_21EE
		push	ax
		dec	sp
		inc	cx
		pop	cx
		inc	bp
		push	dx
		push	bx
		and	[bx+si],ch
		and	[bx+di],ch
		inc	ax
		mov	cl,5
		mov	bl,0A0h
		inc	bl
		dec	bl
		call	sub_b_21EE
		dec	bp
		dec	di
		inc	sp
		inc	bp
		and	[bx+si],ch
		db	'        )@'
		db	0B1h, 19h,0B3h,0A0h,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 05h,0ECh
		db	'SOUND (   )@'
		db	0B1h, 0Ah,0B3h,0B1h,0FEh,0C3h
		db	0FEh,0CBh,0E8h,0EEh,0EBh
		db	'SPACE BAR STARTS GAME@'
		db	0E8h, 6Ah, 18h,0E8h,0B8h,0FDh
		db	0E8h, 53h, 18h
loc_b_361F:
		mov	al,0
		mov	data_b_00B5,al
		mov	al,0Ah
		mov	data_b_00B6,al
loc_b_3629:
		mov	al,byte ptr data_b_0100
		inc	al
		dec	al
		jns	loc_b_3635		; Jump if not sign
		jmp	short loc_b_3676
		db	90h
loc_b_3635:
		call	sub_b_4EB4
		mov	byte ptr ds:[0],al
		xor	al,data_b_009E
		js	loc_b_3644		; Jump if sign=1
		jmp	short loc_b_3655
		db	90h
loc_b_3644:
		mov	al,byte ptr ds:[0]
		inc	al
		dec	al
		js	loc_b_3650		; Jump if sign=1
		jmp	short loc_b_3655
		db	90h
loc_b_3650:
		mov	data_b_009E,al
		stc				; Set carry flag
		retn
loc_b_3655:
		mov	al,byte ptr ds:[0]
		mov	data_b_009E,al
		mov	al,60h			; '`'
		inc	al
		dec	al
		call	sub_b_4E76
		dec	data_b_00B5
		jz	loc_b_366C		; Jump if zero
		jmp	short loc_b_3629
loc_b_366C:
		dec	data_b_00B6
		jz	loc_b_3674		; Jump if zero
		jmp	short loc_b_3629
loc_b_3674:
		clc				; Clear carry flag
		retn
loc_b_3676:
		call	sub_b_4E83
		cmp	al,0CBh
		cmc				; Complement carry
		jz	loc_b_3681		; Jump if zero
		jmp	short loc_b_368D
		db	90h
loc_b_3681:
		mov	al,0
		inc	al
		dec	al
		mov	ds:data_b_8853_e,al
		jmp	loc_b_371B
loc_b_368D:
		cmp	al,0CAh
		cmc				; Complement carry
		jz	loc_b_3695		; Jump if zero
		jmp	short loc_b_36A1
		db	90h
loc_b_3695:
		mov	al,1
		inc	al
		dec	al
		mov	ds:data_b_8853_e,al
		jmp	short loc_b_371B
		db	90h
loc_b_36A1:
		cmp	al,0B1h
		cmc				; Complement carry
		jz	loc_b_36A9		; Jump if zero
		jmp	short loc_b_36B5
		db	90h
loc_b_36A9:
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[217h],al
		jmp	short loc_b_371B
		db	90h
loc_b_36B5:
		cmp	al,0B2h
		cmc				; Complement carry
		jz	loc_b_36BD		; Jump if zero
		jmp	short loc_b_36C9
		db	90h
loc_b_36BD:
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[217h],al
		jmp	short loc_b_371B
		db	90h
loc_b_36C9:
		cmp	al,0C2h
		cmc				; Complement carry
		jz	loc_b_36D1		; Jump if zero
		jmp	short loc_b_36E0
		db	90h
loc_b_36D1:
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[216h],al
		mov	byte ptr ds:[234h],al
		jmp	short loc_b_371B
		db	90h
loc_b_36E0:
		cmp	al,0C3h
		cmc				; Complement carry
		jz	loc_b_36E8		; Jump if zero
		jmp	short loc_b_36F7
		db	90h
loc_b_36E8:
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[216h],al
		mov	byte ptr ds:[234h],al
		jmp	short loc_b_371B
		db	90h
loc_b_36F7:
		cmp	al,0D3h
		cmc				; Complement carry
		jz	loc_b_36FF		; Jump if zero
		jmp	short loc_b_370E
		db	90h
loc_b_36FF:
		mov	al,ds:data_b_8852_e
		rcl	ah,1			; Rotate thru carry
		xor	al,2
		rcr	ah,1			; Rotate thru carry
		mov	ds:data_b_8852_e,al
		jmp	short loc_b_371B
		db	90h
loc_b_370E:
		cmp	al,0A0h
		cmc				; Complement carry
		jnz	loc_b_3716		; Jump if not zero
		jmp	short loc_b_3719
		db	90h
loc_b_3716:
		jmp	loc_b_3629
loc_b_3719:
		stc				; Set carry flag
		retn
loc_b_371B:
		call	sub_b_33D4
		jmp	loc_b_361F
sub_b_33D4	endp

loc_b_3721:
		call	sub_b_4E83
		call	sub_b_3266
		mov	al,ds:data_b_8853_e
		mov	data_b_00EF,al
		mov	al,byte ptr ds:[216h]
		mov	data_b_00F0,al
		mov	al,byte ptr ds:[217h]
		mov	data_b_00F1,al
		mov	al,0
		mov	byte ptr ds:[235h],al
		mov	byte ptr ds:[208h],al
		mov	byte ptr ds:[206h],al
		mov	byte ptr ds:[204h],al
		mov	byte ptr ds:[217h],al
		mov	byte ptr ds:[22Ah],al
		mov	byte ptr ds:[22Bh],al
		mov	byte ptr ds:[22Dh],al
		mov	byte ptr ds:[20Eh],al
		mov	al,0FFh
		mov	byte ptr ds:[202h],al
		mov	al,4
		inc	al
		dec	al
		mov	byte ptr ds:[214h],al
		call	sub_b_41DC
		call	sub_b_379F
		mov	al,1
		mov	byte ptr ds:[225h],al
		mov	ax,52Ah
		mov	data_b_0083,al
		mov	data_b_0084,ah
		mov	byte ptr data_b_0044,al
		mov	byte ptr data_b_0044+1,ah
		mov	al,0FDh
		mov	ds:data_b_896E_e,al
		call	sub_b_4E72
		mov	al,0
		mov	byte ptr ds:[223h],al
		mov	cl,al
		mov	si,cx
		mov	al,byte ptr ds:[0D63h][si]
		inc	al
		dec	al
		mov	byte ptr ds:[224h],al
		jmp	loc_b_07F3

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_379F	proc	near
		mov	al,0FFh
		mov	data_b_006D,al
		mov	al,0
		mov	data_b_006F,al
		mov	data_b_0067,al
		mov	data_b_00C0,al
		mov	data_b_00BD,al
		mov	data_b_00BB,al
		mov	al,0FFh
		mov	data_b_004A,al
		mov	al,0
		mov	data_b_0096,al
		mov	data_b_00DD,al
		mov	data_b_0070,al
		mov	al,1
		mov	data_b_0097,al
		mov	al,4Ah			; 'J'
		mov	byte ptr data_b_005A+1,al
		mov	al,46h			; 'F'
		mov	data_b_0057,al
		mov	al,54h			; 'T'
		mov	byte ptr data_b_005C+1,al
		mov	al,64h			; 'd'
		mov	data_b_005F,al
		mov	al,85h
		mov	data_b_0058,al
		mov	al,8Eh
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al
		mov	al,4Ah			; 'J'
		mov	byte ptr data_b_000C+3,al
		mov	al,2
		mov	byte ptr data_b_0006+1,al
		mov	al,0
		mov	data_b_0010,al
		mov	data_b_0013,al
		mov	al,data_b_0083
		mov	byte ptr data_b_0044,al
		mov	al,data_b_0084
		inc	al
		dec	al
		mov	byte ptr data_b_0044+1,al
		call	sub_b_096D
		call	sub_b_44E1
		call	sub_b_09CA
		call	sub_b_1FDB
		call	sub_b_20E8
		call	sub_b_2000
		call	sub_b_2040
		mov	al,data_b_0078
		inc	al
		dec	al
		jns	loc_b_3831		; Jump if not sign
		jmp	short loc_b_3852
		db	90h
loc_b_3831:
		mov	al,data_b_0078
		push	ax
		mov	al,19h
		mov	data_b_0078,al
		mov	al,0
		mov	byte ptr data_b_0004,al
		call	sub_b_50B3
		pop	ax
		mov	data_b_0078,al
		mov	al,0D5h
		mov	byte ptr data_b_0004,al
		call	sub_b_50B3
		call	sub_b_2A49
		retn
loc_b_3852:
		mov	al,19h
		mov	data_b_0078,al
		mov	al,0
		mov	byte ptr data_b_0004,al
		call	sub_b_50B3
		mov	al,1Fh
		inc	al
		dec	al
		mov	data_b_0078,al
		call	sub_b_2A49
		mov	al,0FFh
		inc	al
		dec	al
		mov	data_b_0078,al
		retn
sub_b_379F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3875	proc	near
		mov	al,byte ptr data_b_005C
		sub	al,data_b_00A3
		cmp	al,8Eh
		cmc				; Complement carry
		jc	loc_b_3884		; Jump if carry Set
		jmp	short loc_b_3896
		db	90h
loc_b_3884:
		mov	al,8Eh
		inc	al
		dec	al
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al
		jmp	short loc_b_38AF
		db	90h
loc_b_3896:
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al
		dec	data_b_005F
		dec	data_b_005F
		dec	byte ptr data_b_005C+1
		inc	byte ptr data_b_005A+1
loc_b_38AF:
		mov	al,byte ptr data_b_005C
		sub	al,data_b_00A3
		cmp	al,8Eh
		cmc				; Complement carry
		jc	loc_b_38BE		; Jump if carry Set
		jmp	short loc_b_38C0
		db	90h
loc_b_38BE:
		mov	al,8Eh
loc_b_38C0:
		mov	byte ptr data_b_005C,al
		mov	data_b_005E,al
		mov	data_b_0060,al
		mov	al,data_b_00A4
		sub	al,2
		cmc				; Complement carry
		jnc	loc_b_38D4		; Jump if carry=0
		jmp	short loc_b_38DA
		db	90h
loc_b_38D4:
		add	al,0Ah
		dec	data_b_00A3
loc_b_38DA:
		mov	data_b_00A4,al
		mov	al,byte ptr data_b_005C
		cmp	al,89h
		cmc				; Complement carry
		jc	loc_b_38E8		; Jump if carry Set
		jmp	short loc_b_3908
		db	90h
loc_b_38E8:
		mov	al,data_b_00A2
		sub	al,7
		cmc				; Complement carry
		jnc	loc_b_38F3		; Jump if carry=0
		jmp	short loc_b_38F9
		db	90h
loc_b_38F3:
		dec	data_b_00A1
		add	al,0Ah
loc_b_38F9:
		mov	data_b_00A2,al
		mov	al,data_b_00A2
		mov	data_b_00A4,al
		mov	al,data_b_00A1
		mov	data_b_00A3,al
loc_b_3908:
		mov	al,data_b_00A5
		inc	al
		dec	al
		jz	loc_b_3914		; Jump if zero
		jmp	short loc_b_3921
		db	90h
loc_b_3914:
		mov	cl,data_b_0065
		mov	bl,data_b_0066
		mov	al,0
		call	sub_b_5034
loc_b_3921:
		mov	al,data_b_00A5
		cmp	al,2
		cmc				; Complement carry
		jnz	loc_b_392C		; Jump if not zero
		jmp	short loc_b_3939
		db	90h
loc_b_392C:
		mov	al,0
		mov	cl,data_b_0063
		mov	bl,data_b_0064
		call	sub_b_5034
loc_b_3939:
		mov	al,0
		mov	cl,data_b_0061
		mov	bl,data_b_0062
		call	sub_b_5034
		mov	al,data_b_005F
		inc	al
		dec	al
		jnz	loc_b_3952		; Jump if not zero
		jmp	short loc_b_395D
		db	90h
loc_b_3952:
		cmp	al,0FFh
		cmc				; Complement carry
		jnz	loc_b_395A		; Jump if not zero
		jmp	short loc_b_395D
		nop
loc_b_395A:
		jmp	short loc_b_3962
		db	90h
loc_b_395D:
		mov	al,1
		mov	data_b_00A5,al
loc_b_3962:
		mov	al,byte ptr data_b_005C+1
		inc	al
		dec	al
		jz	loc_b_396E		; Jump if zero
		jmp	short loc_b_3973
		db	90h
loc_b_396E:
		mov	al,2
		mov	data_b_00A5,al
loc_b_3973:
		mov	al,data_b_00A5
		inc	al
		dec	al
		jz	loc_b_397F		; Jump if zero
		jmp	short loc_b_398C
		db	90h
loc_b_397F:
		mov	al,0
		mov	cl,data_b_005F
		mov	bl,data_b_0060
		call	sub_b_5015
loc_b_398C:
		mov	al,data_b_00A5
		cmp	al,2
		cmc				; Complement carry
		jnz	loc_b_3997		; Jump if not zero
		jmp	short loc_b_39A4
		db	90h
loc_b_3997:
		mov	al,0
		mov	cl,byte ptr data_b_005C+1
		mov	bl,data_b_005E
		call	sub_b_5015
loc_b_39A4:
		mov	al,0
		mov	cl,byte ptr data_b_005A+1
		mov	bl,byte ptr data_b_005C
		call	sub_b_5015
		mov	al,byte ptr data_b_005A+1
		mov	data_b_0061,al
		mov	al,byte ptr data_b_005C+1
		mov	data_b_0063,al
		mov	al,data_b_005F
		mov	data_b_0065,al
		mov	al,byte ptr data_b_005C
		mov	data_b_0062,al
		mov	al,data_b_005E
		mov	data_b_0064,al
		mov	al,data_b_0060
		mov	data_b_0066,al
		dec	data_b_0043
		mov	al,data_b_0043
		cmp	al,0FFh
		cmc				; Complement carry
		jz	loc_b_39E4		; Jump if zero
		jmp	short loc_b_39E9
		db	90h
loc_b_39E4:
		mov	al,8Ch
		mov	data_b_0043,al
loc_b_39E9:
		dec	data_b_0041
		mov	al,data_b_0041
		cmp	al,0FFh
		cmc				; Complement carry
		jz	loc_b_39F8		; Jump if zero
		jmp	short loc_b_3A01
		db	90h
loc_b_39F8:
		mov	al,8Ch
		inc	al
		dec	al
		mov	data_b_0041,al
loc_b_3A01:
		call	sub_b_1FDB
		retn
sub_b_3875	endp

loc_b_3A05:
		mov	al,data_b_0070
		inc	al
		dec	al
		jz	loc_ret_b_3A11		; Jump if zero
		jmp	short loc_b_3A12
		db	90h

loc_ret_b_3A11:
		retn
loc_b_3A12:
		dec	byte ptr ds:[218h]
		call	sub_b_4370
		mov	cl,3
loc_b_3A1B:
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		inc	al
		dec	al
		jns	loc_b_3A2A		; Jump if not sign
		jmp	short loc_b_3A42
		db	90h
loc_b_3A2A:
		mov	al,byte ptr ds:[8EFh][si]
		mov	byte ptr ds:[8EBh][si],al
		mov	al,byte ptr ds:[8E3h][si]
		mov	byte ptr ds:[8DBh][si],al
		mov	al,byte ptr ds:[8DFh][si]
		mov	byte ptr ds:[8D7h][si],al
loc_b_3A42:
		mov	si,cx
		mov	al,data_b_00C7[si]
		mov	byte ptr ds:[8C2h][si],al
		mov	al,data_b_00CB[si]
		mov	byte ptr ds:[8C6h][si],al
		mov	al,data_b_00C3[si]
		mov	byte ptr ds:[8D3h][si],al
		mov	al,data_b_00D1[si]
		mov	byte ptr ds:[8CFh][si],al
		dec	cl
		js	loc_b_3A6A		; Jump if sign=1
		jmp	short loc_b_3A1B
loc_b_3A6A:
		mov	al,0
		mov	data_b_00AF,al
		mov	al,data_b_0065
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_0066
		call	sub_b_5034
		mov	al,data_b_0063
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,0
		mov	bl,data_b_0064
		call	sub_b_5034
		mov	al,data_b_0061
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	bl,data_b_0062
		mov	al,0
		call	sub_b_5034
		mov	al,data_b_0059
		or	al,byte ptr ds:[216h]
		mov	cl,al
		mov	al,1
		mov	bl,byte ptr data_b_005A
		call	sub_b_5034
		mov	al,3
		mov	data_b_00A1,al
		mov	data_b_00A3,al
		mov	al,0
		mov	data_b_00A5,al
		mov	al,2
		inc	al
		dec	al
		mov	data_b_00A2,al
		mov	data_b_00A4,al
		call	sub_b_3875
		mov	al,6
		mov	data_b_0071,al
		mov	al,4
		mov	data_b_00B6,al
loc_b_3ADD:
		mov	al,data_b_0071
		mov	cl,data_b_0059
		inc	cl
		inc	cl
		mov	bl,byte ptr data_b_005A
		inc	bl
		call	sub_b_4FD7
		mov	al,7
		mov	byte ptr data_b_0006,al
		mov	cl,32h			; '2'
		mov	bl,1
		inc	bl
		dec	bl
		call	sub_b_3D78
		call	sub_b_3875
		call	sub_b_3875
		call	sub_b_3875
		call	sub_b_3875
		call	sub_b_3875
		mov	al,0Ah
		inc	al
		dec	al
		call	sub_b_4E76
		call	sub_b_3CB3
		mov	al,data_b_00B6
		inc	al
		dec	al
		jnz	loc_b_3B28		; Jump if not zero
		jmp	short loc_b_3B5F
		db	90h
loc_b_3B28:
		mov	al,data_b_0071
		mov	cl,data_b_0059
		inc	cl
		inc	cl
		mov	bl,byte ptr data_b_005A
		inc	bl
		call	sub_b_4FF6
		mov	al,data_b_0071
		cmp	al,6
		cmc				; Complement carry
		jnz	loc_b_3B47		; Jump if not zero
		jmp	short loc_b_3B53
		db	90h
loc_b_3B47:
		mov	al,6
		inc	al
		dec	al
		mov	data_b_0071,al
		jmp	short loc_b_3B58
		db	90h
loc_b_3B53:
		mov	al,7
		mov	data_b_0071,al
loc_b_3B58:
		dec	data_b_00B6
		jmpn	loc_b_3ADD
loc_b_3B5F:
		mov	al,7
		mov	byte ptr data_b_0006,al
		mov	cl,0
		mov	bl,7
		inc	bl
		dec	bl
		call	sub_b_3D78
		call	sub_b_3875
		mov	al,6
		mov	data_b_0071,al
loc_b_3B77:
		mov	al,data_b_0071
		mov	cl,data_b_0059
		inc	cl
		inc	cl
		mov	bl,byte ptr data_b_005A
		inc	bl
		call	sub_b_4FD7
		mov	al,data_b_0071
		cmp	al,8
		cmc				; Complement carry
		jnz	loc_b_3B96		; Jump if not zero
		jmp	short loc_b_3BCA
		db	90h
loc_b_3B96:
		mov	al,3
		inc	al
		dec	al
		mov	data_b_0072,al
loc_b_3B9F:
		call	sub_b_3CB3
		call	sub_b_3875
		call	sub_b_3875
		dec	data_b_0072
		js	loc_b_3BB0		; Jump if sign=1
		jmp	short loc_b_3B9F
loc_b_3BB0:
		mov	al,data_b_0071
		mov	cl,data_b_0059
		inc	cl
		inc	cl
		mov	bl,byte ptr data_b_005A
		inc	bl
		call	sub_b_4FF6
		inc	data_b_0071
		jmp	short loc_b_3B77
loc_b_3BCA:
		call	sub_b_3CB3
		mov	al,data_b_0071
		mov	cl,data_b_0059
		inc	cl
		inc	cl
		mov	bl,byte ptr data_b_005A
		inc	bl
		call	sub_b_4FF6
		mov	al,0
		mov	data_b_0070,al
		mov	al,1Eh
		inc	al
		dec	al
loc_b_3BEC:
		push	ax
		call	sub_b_3CB3
		call	sub_b_3875
		call	sub_b_3875
		mov	al,14h
		inc	al
		dec	al
		call	sub_b_4E76
		pop	ax
		sub	al,1
		cmc				; Complement carry
		jnc	loc_b_3C07		; Jump if carry=0
		jmp	short loc_b_3BEC
loc_b_3C07:
		call	sub_b_096D
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00E0,al
		mov	data_b_00DF,al
		mov	data_b_009D,al
		call	sub_b_3FB6
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		mov	al,byte ptr ds:[225h]
		inc	al
		dec	al
		jnz	loc_b_3C3A		; Jump if not zero
		jmp	short loc_b_3C53
		db	90h
loc_b_3C3A:
		mov	al,data_b_00EF
		mov	al,data_b_00F0
		mov	byte ptr ds:[216h],al
		mov	al,data_b_00F1
		inc	al
		dec	al
		mov	byte ptr ds:[217h],al
		jmp	loc_b_4DDA
		jmp	loc_b_32DE
loc_b_3C53:
		call	sub_b_42A6
		mov	al,byte ptr ds:[218h]
		inc	al
		dec	al
		jz	loc_b_3C62		; Jump if zero
		jmp	short loc_b_3C65
		db	90h
loc_b_3C62:
		jmp	loc_b_4934
loc_b_3C65:
		mov	al,byte ptr ds:[217h]
		inc	al
		dec	al
		jnz	loc_b_3C71		; Jump if not zero
		jmp	short loc_b_3C89
		db	90h
loc_b_3C71:
		mov	al,data_b_002E
		inc	al
		dec	al
		jz	loc_b_3C7D		; Jump if zero
		jmp	short loc_b_3C89
		db	90h
loc_b_3C7D:
		mov	al,byte ptr ds:[22Ah]
		rcl	ah,1			; Rotate thru carry
		xor	al,1
		rcr	ah,1			; Rotate thru carry
		mov	byte ptr ds:[22Ah],al
loc_b_3C89:
		mov	data_b_0073,0C46h
		mov	data_b_0075,0C93h
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00A0,al
		call	sub_b_3266
		call	sub_b_3F30
		call	sub_b_41DC
loc_b_3CA7:
		call	sub_b_379F
		call	sub_b_4E72
		call	sub_b_414E
		jmp	loc_b_07F3

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3CB3	proc	near
		inc	data_b_0049
		mov	al,data_b_0049
		rcl	ah,1			; Rotate thru carry
		and	al,1
		rcr	ah,1			; Rotate thru carry
		jz	loc_b_3CC5		; Jump if zero
		jmp	short loc_b_3CD0
		db	90h
loc_b_3CC5:
		dec	data_b_0041
		dec	data_b_0043
		call	sub_b_1FDB
loc_b_3CD0:
		mov	al,data_b_0049
		rcl	ah,1			; Rotate thru carry
		and	al,0Fh
		rcr	ah,1			; Rotate thru carry
		jz	loc_b_3CDE		; Jump if zero
		jmp	short loc_b_3CE1
		db	90h
loc_b_3CDE:
		call	sub_b_3FE3
loc_b_3CE1:
		call	sub_b_0EF3
		dec	data_b_00F3
		js	loc_b_3CED		; Jump if sign=1
		jmp	short loc_b_3CF9
		db	90h
loc_b_3CED:
		mov	al,16h
		inc	al
		dec	al
		mov	data_b_00F3,al
		call	sub_b_20E8
loc_b_3CF9:
		call	sub_b_19E8
		call	sub_b_1567
		call	sub_b_26EE
		call	sub_b_1C08
		call	sub_b_1E17
		call	sub_b_10E0
		call	sub_b_4714
		call	sub_b_46D1
		call	sub_b_4869
		call	sub_b_1503
		call	sub_b_2DC1
		call	sub_b_10DF
		mov	al,50h			; 'P'
		inc	al
		dec	al
		call	sub_b_4E76
		retn
sub_b_3CB3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3D27	proc	near
loc_b_3D27:
		mov	si,cx
		mov	al,data_b_0F0A[si]
loc_b_3D2D:
		add	al,byte ptr data_b_0006
		jnc	loc_b_3D2D		; Jump if carry=0
		call	sub_b_4E8B
		inc	cl
		jnz	loc_b_3D27		; Jump if not zero
		retn
sub_b_3D27	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3D3B	proc	near
		mov	byte ptr ds:[0],al
		mov	byte ptr ds:[1],cl
		mov	al,0
		mov	cl,8
loc_b_3D46:
		shl	al,1			; Shift w/zeros fill
		mov	dh,byte ptr ds:[2]
		rcl	dh,1			; Rotate thru carry
		mov	byte ptr ds:[2],dh
		shl	byte ptr ds:[0],1	; Shift w/zeros fill
		jc	loc_b_3D5B		; Jump if carry Set
		jmp	short loc_b_3D68
		db	90h
loc_b_3D5B:
		add	al,byte ptr ds:[1]
		jc	loc_b_3D64		; Jump if carry Set
		jmp	short loc_b_3D68
		db	90h
loc_b_3D64:
		inc	byte ptr ds:[2]
loc_b_3D68:
		dec	cl
		jz	loc_b_3D6E		; Jump if zero
		jmp	short loc_b_3D46
loc_b_3D6E:
		mov	cl,al
		mov	al,byte ptr ds:[2]
		inc	al
		dec	al
		retn
sub_b_3D3B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3D78	proc	near
		inc	bl
		inc	cl
loc_b_3D7C:
		mov	si,cx
		mov	al,data_b_0F0A[si]
loc_b_3D82:
		add	al,byte ptr data_b_0006
		jnc	loc_b_3D82		; Jump if carry=0
		call	sub_b_4E8B
		dec	cl
		jz	loc_b_3D94		; Jump if zero
		mov	al,byte ptr ds:[0]
		jmp	short loc_b_3D7C
loc_b_3D94:
		dec	bl
		jnz	loc_b_3D7C		; Jump if not zero
		retn
sub_b_3D78	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3D99	proc	near
		mov	data_b_0003,al
		mov	cl,1Eh
loc_b_3D9E:
		mov	al,data_b_0003
		inc	al
		dec	al
		call	sub_b_4E76
		call	sub_b_4E8B
		dec	cl
		js	loc_ret_b_3DB1		; Jump if sign=1
		jmp	short loc_b_3D9E

loc_ret_b_3DB1:
		retn
sub_b_3D99	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3DB2	proc	near
loc_b_3DB2:
		mov	al,1
		mov	byte ptr data_b_0006,al
		mov	cl,0D2h
		inc	cl
		dec	cl
		call	sub_b_3D27
		retn
sub_b_3DB2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3DC1	proc	near
		mov	al,data_b_00A0
		inc	al
		dec	al
		jz	loc_b_3DCD		; Jump if zero
		jmp	short loc_b_3E02
		db	90h
loc_b_3DCD:
		mov	cl,0
		mov	si,data_b_0075
		mov	al,[si]
		shl	al,1			; Shift w/zeros fill
		mov	data_b_0054,al
		mov	si,data_b_0073
		mov	al,[si]
		inc	al
		dec	al
		jz	loc_b_3DE9		; Jump if zero
		jmp	short loc_b_3DFF
		db	90h
loc_b_3DE9:
		mov	data_b_0073,0C46h
		mov	data_b_0075,0C93h
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00A0,al
		retn
loc_b_3DFF:
		mov	data_b_0053,al
loc_b_3E02:
		mov	cl,0FFh
		mov	bl,3
loc_b_3E06:
		mov	al,data_b_0053
loc_b_3E09:
		nop
		dec	cl
		jnz	loc_b_3E11		; Jump if not zero
		jmp	short loc_b_3E15
		db	90h
loc_b_3E11:
		nop
		jmp	short loc_b_3E1C
		db	90h
loc_b_3E15:
		dec	bl
		jnz	loc_b_3E1C		; Jump if not zero
		jmp	short loc_b_3E3A
		db	90h
loc_b_3E1C:
		sub	al,1
		cmc				; Complement carry
		jnc	loc_b_3E23		; Jump if carry=0
		jmp	short loc_b_3E09
loc_b_3E23:
		call	sub_b_4E8B
		dec	cl
		jnz	loc_b_3E2D		; Jump if not zero
		jmp	short loc_b_3E31
		db	90h
loc_b_3E2D:
		nop
		jmp	short loc_b_3E38
		db	90h
loc_b_3E31:
		dec	bl
		jnz	loc_b_3E38		; Jump if not zero
		jmp	short loc_b_3E3A
		nop
loc_b_3E38:
		jmp	short loc_b_3E06
loc_b_3E3A:
		dec	data_b_0054
		jnz	loc_b_3E43		; Jump if not zero
		jmp	short loc_b_3E4F
		db	90h
loc_b_3E43:
		mov	al,1
		inc	al
		dec	al
		mov	data_b_00A0,al
		jmp	short loc_ret_b_3E72
		db	90h
loc_b_3E4F:
		inc	byte ptr data_b_0075
		jz	loc_b_3E58		; Jump if zero
		jmp	short loc_b_3E5C
		db	90h
loc_b_3E58:
		inc	byte ptr data_b_0075+1
loc_b_3E5C:
		inc	byte ptr data_b_0073
		jz	loc_b_3E65		; Jump if zero
		jmp	short loc_b_3E69
		db	90h
loc_b_3E65:
		inc	byte ptr data_b_0073+1
loc_b_3E69:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00A0,al

loc_ret_b_3E72:
		retn
sub_b_3DC1	endp

loc_b_3E73:
		call	sub_b_3266
		mov	al,data_b_0083
		mov	byte ptr data_b_0044,al
		mov	al,data_b_0084
		mov	byte ptr data_b_0044+1,al
		call	sub_b_4EC6
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[216h],al
		call	sub_b_08CD
		call	sub_b_09CA
		call	sub_b_1FDB
		call	sub_b_3ECC
		mov	al,0
		inc	al
		dec	al
		mov	data_b_007E,al
		mov	data_b_007D,al
		call	sub_b_42A6
		call	sub_b_3F82
		call	sub_b_4E72
		jmp	loc_b_2CF6

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3EB2	proc	near
		call	sub_b_50E1
		mov	al,data_b_00D8
		sub	al,data_b_00AF
		cmc				; Complement carry
		jnc	loc_b_3EC2		; Jump if carry=0
		jmp	short loc_b_3EC8
		db	90h
loc_b_3EC2:
		add	al,7
		dec	data_b_00D7
loc_b_3EC8:
		mov	data_b_00D8,al
		retn
sub_b_3EB2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3ECC	proc	near
		mov	al,byte ptr ds:[216h]
		inc	al
		dec	al
		jz	loc_b_3ED8		; Jump if zero
		jmp	short loc_b_3F02
		db	90h
loc_b_3ED8:
		mov	cl,8
		mov	bl,4Eh			; 'N'
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[21Dh],al
		call	sub_b_21EE
		and	[bx+si],ah
		inc	dx
		inc	bp
		inc	di
		dec	cx
		dec	si
		dec	si
		inc	bp
		push	dx
		and	[bp+di+4Fh],al
		push	bp
		push	dx
		push	bx
		inc	bp
		and	[bx+4Fh],al
		and	[bx+di],ah
		and	[bx+si],ah
		inc	ax
		retn
loc_b_3F02:
		mov	cl,8
		mov	bl,4Eh			; 'N'
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[21Dh],al
		call	sub_b_21EE
		and	[bx+si],ah
		inc	bx
		dec	ax
		inc	cx
		dec	bp
		push	ax
		dec	cx
		dec	di
		dec	si
		and	[bp+di+4Fh],al
		push	bp
		push	dx
		push	bx
		inc	bp
		and	[bx+4Fh],al
		and	[bx+di],ah
		and	[bx+si],ah
		inc	ax
		retn
sub_b_3ECC	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3F30	proc	near
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jz	loc_ret_b_3F3C		; Jump if zero
		jmp	short loc_b_3F3D
		db	90h

loc_ret_b_3F3C:
		retn
loc_b_3F3D:
		mov	al,data_b_00EE
		inc	al
		dec	al
		jnz	loc_b_3F48		; Jump if not zero
		jmp	short loc_ret_b_3F3C
loc_b_3F48:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00EE,al
		call	sub_b_08CD
		call	sub_b_4EC6
		call	sub_b_2040
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_2000
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_41DC
		call	sub_b_09CA
		call	sub_b_3ECC
		call	sub_b_4E72
		pop	bp
		call	sub_b_44E1
		jmp	loc_b_2CF6
sub_b_3F30	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3F82	proc	near
		mov	al,byte ptr ds:[22Ah]
		push	ax
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_41DC
		call	sub_b_2000
		call	sub_b_2040
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_41DC
		call	sub_b_2000
		pop	ax
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_41DC
		call	sub_b_44E1
		retn
sub_b_3F82	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3FB6	proc	near
		mov	al,byte ptr ds:[22Ah]
		push	ax
		mov	al,1
		mov	byte ptr ds:[235h],al
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_3FE3
		mov	al,1
		inc	al
		dec	al
		mov	byte ptr ds:[235h],al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_3FE3
		pop	ax
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		retn
sub_b_3FB6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_3FE3	proc	near
		mov	al,1
		mov	byte ptr ds:[21Dh],al
		mov	al,byte ptr ds:[235h]
		inc	al
		dec	al
		jnz	loc_b_3FF4		; Jump if not zero
		jmp	short loc_b_402C
		db	90h
loc_b_3FF4:
		mov	al,byte ptr ds:[235h]
		rcl	ah,1			; Rotate thru carry
		xor	al,1
		rcr	ah,1			; Rotate thru carry
		mov	byte ptr ds:[235h],al
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jnz	loc_b_400C		; Jump if not zero
		jmp	short loc_b_401C
		db	90h
loc_b_400C:
		mov	bl,18h
		mov	cl,2
		inc	cl
		dec	cl
		call	sub_b_21EE
		xor	dl,[di+50h]
		inc	ax
		retn
loc_b_401C:
		mov	bl,0Fh
		mov	cl,2
		inc	cl
		dec	cl
		call	sub_b_21EE
		xor	[di+50h],dx
		inc	ax
		retn
loc_b_402C:
		mov	al,byte ptr ds:[235h]
		rcl	ah,1			; Rotate thru carry
		xor	al,1
		rcr	ah,1			; Rotate thru carry
		mov	byte ptr ds:[235h],al
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jnz	loc_b_4044		; Jump if not zero
		jmp	short loc_b_4054
		db	90h
loc_b_4044:
		mov	bl,18h
		mov	cl,2
		inc	cl
		dec	cl
		call	sub_b_21EE
		and	[bx+si],ah
		and	[bx+si-3Dh],al
loc_b_4054:
		mov	bl,0Fh
		mov	cl,2
		inc	cl
		dec	cl
		call	sub_b_21EE
		and	[bx+si],ah
		and	[bx+si-3Dh],al
sub_b_3FE3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4064	proc	near
		mov	cl,3
loc_b_4066:
		mov	si,cx
		mov	al,byte ptr ds:[8BEh][si]
		inc	al
		dec	al
		jz	loc_b_4075		; Jump if zero
		jmp	short loc_b_407C
		db	90h
loc_b_4075:
		dec	cl
		js	loc_ret_b_407B		; Jump if sign=1
		jmp	short loc_b_4066

loc_ret_b_407B:
		retn
loc_b_407C:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,data_b_00C3[si]
		cmp	al,16h
		cmc				; Complement carry
		jz	loc_b_408D		; Jump if zero
		jmp	short loc_b_4075
loc_b_408D:
		mov	al,data_b_00D1[si]
		inc	al
		dec	al
		jns	loc_b_4099		; Jump if not sign
		jmp	short loc_b_4075
loc_b_4099:
		mov	al,data_b_001A
		inc	al
		dec	al
		jnz	loc_b_40A4		; Jump if not zero
		jmp	short loc_ret_b_407B
loc_b_40A4:
		mov	al,data_b_00C7[si]
		add	al,1Ch
		jnc	loc_b_40AE		; Jump if carry=0
		jmp	short loc_b_4075
loc_b_40AE:
		add	al,4
		mov	byte ptr ds:[0],al
		add	al,1Eh
		mov	byte ptr ds:[1],al
		mov	al,data_b_001B
		sub	al,2
		cmp	al,7Ah			; 'z'
		cmc				; Complement carry
		jc	loc_b_40C4		; Jump if carry Set
		jmp	short loc_b_4075
loc_b_40C4:
		mov	al,data_b_001A
		add	al,5
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jc	loc_b_40D2		; Jump if carry Set
		jmp	short loc_b_4075
loc_b_40D2:
		sub	al,0Ch
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jnc	loc_b_40DD		; Jump if carry=0
		jmp	short loc_b_4075
loc_b_40DD:
		mov	al,data_b_009D
		inc	al
		dec	al
		jz	loc_b_40E8		; Jump if zero
		jmp	short loc_b_4075
loc_b_40E8:
		mov	al,1
		mov	data_b_009D,al
		mov	al,data_b_001C
		inc	al
		dec	al
		jns	loc_b_40F9		; Jump if not sign
		jmp	short loc_b_40FE
		db	90h
loc_b_40F9:
		mov	al,0FFh
		mov	data_b_001C,al
loc_b_40FE:
		mov	al,15h
		mov	si,cx
		mov	byte ptr ds:[8D3h][si],al
		mov	data_b_00C3[si],al
		mov	bl,data_b_00C7[si]
		mov	al,byte ptr ds:[0E0Ah][bx]
		add	al,data_b_00D1[si]
		mov	data_b_00B0,al
		add	al,9
		mov	data_b_00B1,al
		call	sub_b_4F63
		mov	cl,data_b_0050
		mov	al,0Ah
		mov	data_b_00BD,al
		mov	si,cx
		mov	al,data_b_00C7[si]
		add	al,20h			; ' '
		mov	data_b_00BE,al
		mov	al,91h
		mov	data_b_00BF,al
		mov	al,2
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,10h
		mov	data_b_00D9,al
		call	sub_b_114B
		jmp	loc_b_3DB2
sub_b_4064	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_414E	proc	near
		mov	al,byte ptr ds:[217h]
		inc	al
		dec	al
		jz	loc_ret_b_415A		; Jump if zero
		jmp	short loc_b_415B
		db	90h

loc_ret_b_415A:
		retn
loc_b_415B:
		mov	al,5
		mov	data_b_00B0,al
loc_b_4160:
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jnz	loc_b_416C		; Jump if not zero
		jmp	short loc_b_4185
		db	90h
loc_b_416C:
		mov	cl,0Fh
		mov	bl,41h			; 'A'
		inc	bl
		dec	bl
		call	sub_b_21EE
		push	ax
		dec	sp
		inc	cx
		pop	cx
		inc	bp
		push	dx
		and	[si+57h],dl
		dec	di
		inc	ax
		jmp	short loc_b_419B
		db	90h
loc_b_4185:
		mov	cl,0Fh
		mov	bl,41h			; 'A'
		inc	bl
		dec	bl
		call	sub_b_21EE
		push	ax
		dec	sp
		inc	cx
		pop	cx
		inc	bp
		push	dx
		and	[bx+4Eh],cl
		inc	bp
		inc	ax
loc_b_419B:
		mov	cl,1
loc_b_419D:
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_41AC		; Jump if sign=1
		jmp	short loc_b_419D
loc_b_41AC:
		mov	cl,0Fh
		mov	bl,41h			; 'A'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'          @'
		db	0B1h, 01h
loc_b_41C4:
		mov	al,0FFh
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_41D3		; Jump if sign=1
		jmp	short loc_b_41C4
loc_b_41D3:
		dec	data_b_00B0
		jz	loc_ret_b_41DB		; Jump if zero
		jmp	short loc_b_4160

loc_ret_b_41DB:
		retn
sub_b_414E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_41DC	proc	near
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jz	loc_b_41E8		; Jump if zero
		jmp	short loc_b_4247
		db	90h
loc_b_41E8:
		mov	al,byte ptr ds:[200h]
		mov	byte ptr ds:[216h],al
		mov	al,byte ptr ds:[202h]
		mov	data_b_0078,al
		mov	al,byte ptr ds:[204h]
		mov	data_b_007A,al
		mov	al,byte ptr ds:[206h]
		mov	data_b_007B,al
		mov	al,byte ptr ds:[208h]
		mov	data_b_007C,al
		mov	al,byte ptr ds:[22Dh]
		mov	data_b_007E,al
		mov	al,byte ptr ds:[22Bh]
		mov	data_b_007D,al
		mov	al,byte ptr ds:[214h]
		mov	byte ptr ds:[218h],al
		mov	al,byte ptr ds:[20Eh]
		mov	data_b_0098,al
		mov	al,byte ptr ds:[210h]
		mov	data_b_0099,al
		mov	al,byte ptr ds:[212h]
		mov	data_b_009A,al
		mov	al,byte ptr ds:[226h]
		mov	byte ptr data_b_0044,al
		mov	al,byte ptr ds:[227h]
		mov	byte ptr data_b_0044+1,al
		mov	al,byte ptr ds:[20Ah]
		mov	data_b_0083,al
		mov	al,byte ptr ds:[20Ch]
		inc	al
		dec	al
		mov	data_b_0084,al
		retn
loc_b_4247:
		mov	al,byte ptr ds:[201h]
		mov	byte ptr ds:[216h],al
		mov	al,byte ptr ds:[203h]
		mov	data_b_0078,al
		mov	al,byte ptr ds:[205h]
		mov	data_b_007A,al
		mov	al,byte ptr ds:[207h]
		mov	data_b_007B,al
		mov	al,byte ptr ds:[209h]
		mov	data_b_007C,al
		mov	al,byte ptr ds:[22Eh]
		mov	data_b_007E,al
		mov	al,byte ptr ds:[22Ch]
		mov	data_b_007D,al
		mov	al,byte ptr ds:[215h]
		mov	byte ptr ds:[218h],al
		mov	al,byte ptr ds:[20Fh]
		mov	data_b_0098,al
		mov	al,byte ptr ds:[211h]
		mov	data_b_0099,al
		mov	al,byte ptr ds:[213h]
		mov	data_b_009A,al
		mov	al,byte ptr ds:[228h]
		mov	byte ptr data_b_0044,al
		mov	al,byte ptr ds:[229h]
		mov	byte ptr data_b_0044+1,al
		mov	al,byte ptr ds:[20Bh]
		mov	data_b_0083,al
		mov	al,byte ptr ds:[20Dh]
		inc	al
		dec	al
		mov	data_b_0084,al
		retn
sub_b_41DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_42A6	proc	near
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jnz	loc_b_42B2		; Jump if not zero
		jmp	short loc_b_4311
		db	90h
loc_b_42B2:
		mov	al,data_b_0078
		mov	byte ptr ds:[203h],al
		mov	al,data_b_007A
		mov	byte ptr ds:[205h],al
		mov	al,data_b_007B
		mov	byte ptr ds:[207h],al
		mov	al,data_b_007C
		mov	byte ptr ds:[209h],al
		mov	al,data_b_007E
		mov	byte ptr ds:[22Eh],al
		mov	al,data_b_007D
		mov	byte ptr ds:[22Ch],al
		mov	al,byte ptr ds:[218h]
		mov	byte ptr ds:[215h],al
		mov	al,data_b_0098
		mov	byte ptr ds:[20Fh],al
		mov	al,byte ptr ds:[216h]
		mov	byte ptr ds:[201h],al
		mov	al,data_b_0099
		mov	byte ptr ds:[211h],al
		mov	al,data_b_009A
		mov	byte ptr ds:[213h],al
		mov	al,byte ptr data_b_0044
		mov	byte ptr ds:[228h],al
		mov	al,byte ptr data_b_0044+1
		mov	byte ptr ds:[229h],al
		mov	al,data_b_0083
		mov	byte ptr ds:[20Bh],al
		mov	al,data_b_0084
		inc	al
		dec	al
		mov	byte ptr ds:[20Dh],al
		retn
loc_b_4311:
		mov	al,data_b_0078
		mov	byte ptr ds:[202h],al
		mov	al,data_b_007A
		mov	byte ptr ds:[204h],al
		mov	al,data_b_007B
		mov	byte ptr ds:[206h],al
		mov	al,data_b_007C
		mov	byte ptr ds:[208h],al
		mov	al,data_b_007E
		mov	byte ptr ds:[22Dh],al
		mov	al,data_b_007D
		mov	byte ptr ds:[22Bh],al
		mov	al,byte ptr ds:[218h]
		mov	byte ptr ds:[214h],al
		mov	al,data_b_0098
		mov	byte ptr ds:[20Eh],al
		mov	al,byte ptr ds:[216h]
		mov	byte ptr ds:[200h],al
		mov	al,data_b_0099
		mov	byte ptr ds:[210h],al
		mov	al,data_b_009A
		mov	byte ptr ds:[212h],al
		mov	al,byte ptr data_b_0044
		mov	byte ptr ds:[226h],al
		mov	al,byte ptr data_b_0044+1
		mov	byte ptr ds:[227h],al
		mov	al,data_b_0083
		mov	byte ptr ds:[20Ah],al
		mov	al,data_b_0084
		inc	al
		dec	al
		mov	byte ptr ds:[20Ch],al
		retn
sub_b_42A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4370	proc	near
		mov	cl,3
loc_b_4372:
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		inc	al
		dec	al
		jz	loc_b_4381		; Jump if zero
		jmp	short loc_b_438A
		db	90h
loc_b_4381:
		dec	cl
		js	loc_b_4387		; Jump if sign=1
		jmp	short loc_b_4372
loc_b_4387:
		jmp	short loc_b_43A7
		db	90h
loc_b_438A:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[90Ah][si]
		mov	cl,al
		mov	al,0Bh
		mov	bl,8Fh
		call	sub_b_4FF6
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		jmp	short loc_b_4381
loc_b_43A7:
		mov	cl,3
loc_b_43A9:
		mov	al,0FFh
		mov	si,cx
		mov	byte ptr ds:[85Bh][si],al
		mov	byte ptr ds:[906h][si],al
		dec	cl
		js	loc_b_43BB		; Jump if sign=1
		jmp	short loc_b_43A9
loc_b_43BB:
		mov	cl,3
loc_b_43BD:
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		inc	al
		dec	al
		jz	loc_b_43CC		; Jump if zero
		jmp	short loc_b_43E7
		db	90h
loc_b_43CC:
		dec	cl
		js	loc_b_43D2		; Jump if sign=1
		jmp	short loc_b_43BD
loc_b_43D2:
		mov	cl,3
loc_b_43D4:
		mov	al,0
		mov	si,cx
		mov	byte ptr ds:[90Ah][si],al
		mov	byte ptr ds:[867h][si],al
		dec	cl
		js	loc_ret_b_43E6		; Jump if sign=1
		jmp	short loc_b_43D4

loc_ret_b_43E6:
		retn
loc_b_43E7:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[867h][si]
		push	ax
		mov	bl,byte ptr ds:[86Fh][si]
		mov	al,byte ptr ds:[86Bh][si]
		mov	cl,al
		pop	ax
		call	sub_b_4FF6
		mov	cl,data_b_0050
		inc	cl
		dec	cl
		jmp	short loc_b_43CC
sub_b_4370	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_440A	proc	near
		mov	bl,3
loc_b_440C:
		mov	al,byte ptr ds:[867h][bx]
		inc	al
		dec	al
		jz	loc_b_4419		; Jump if zero
		jmp	short loc_b_4420
		db	90h
loc_b_4419:
		dec	bl
		js	loc_ret_b_441F		; Jump if sign=1
		jmp	short loc_b_440C

loc_ret_b_441F:
		retn
loc_b_4420:
		mov	cl,3
loc_b_4422:
		mov	si,cx
		mov	al,byte ptr ds:[0DF2h][si]
		inc	al
		dec	al
		jz	loc_b_4431		; Jump if zero
		jmp	short loc_b_4439
		db	90h
loc_b_4431:
		dec	cl
		js	loc_b_4437		; Jump if sign=1
		jmp	short loc_b_4422
loc_b_4437:
		jmp	short loc_b_4419
loc_b_4439:
		mov	data_b_0018,bl
		mov	data_b_0016,cl
		mov	al,byte ptr ds:[86Bh][bx]
		add	al,3
		mov	si,cx
		cmp	al,byte ptr ds:[0DEAh][si]
		cmc				; Complement carry
		jc	loc_b_4452		; Jump if carry Set
		jmp	short loc_b_4431
loc_b_4452:
		mov	al,byte ptr ds:[0DEAh][si]
		add	al,2
		cmp	al,byte ptr ds:[86Bh][bx]
		cmc				; Complement carry
		jc	loc_b_4461		; Jump if carry Set
		jmp	short loc_b_4431
loc_b_4461:
		mov	al,byte ptr ds:[86Fh][bx]
		add	al,4
		cmp	al,byte ptr ds:[0DEEh][si]
		cmc				; Complement carry
		jc	loc_b_4470		; Jump if carry Set
		jmp	short loc_b_4431
loc_b_4470:
		mov	al,byte ptr ds:[0DEEh][si]
		add	al,6
		cmp	al,byte ptr ds:[86Fh][bx]
		cmc				; Complement carry
		jc	loc_b_447F		; Jump if carry Set
		jmp	short loc_b_4431
loc_b_447F:
		mov	al,1
		mov	byte ptr ds:[0DFAh][si],al
		mov	al,byte ptr ds:[867h][bx]
		mov	data_b_00B0,al
		mov	al,0
		mov	byte ptr ds:[867h][bx],al
		mov	al,byte ptr ds:[86Bh][bx]
		mov	cl,al
		mov	al,byte ptr ds:[86Fh][bx]
		mov	bl,al
		mov	al,data_b_00B0
		call	sub_b_4FF6
		mov	bl,data_b_0018
		mov	al,byte ptr ds:[86Bh][bx]
		mov	cl,al
		mov	al,byte ptr ds:[86Fh][bx]
		mov	bl,al
		mov	al,0Eh
		call	sub_b_4FD7
		mov	bl,data_b_0018
		mov	al,byte ptr ds:[86Bh][bx]
		mov	cl,al
		mov	al,byte ptr ds:[86Fh][bx]
		mov	bl,al
		mov	al,0Eh
		call	sub_b_4FF6
		mov	cl,data_b_0016
		mov	bl,data_b_0018
		inc	bl
		dec	bl
		jmp	loc_b_4419
sub_b_440A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_44DD	proc	near
		call	sub_b_4EC6
		retn
sub_b_44DD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_44E1	proc	near
		mov	al,byte ptr ds:[218h]
		sub	al,1
		cmc				; Complement carry
		push	ax
		mov	al,25h			; '%'
		mov	data_b_00A6,al
		mov	al,0Fh
		mov	data_b_00A7,al
		pop	ax
		inc	al
		dec	al
		call	sub_b_2132
		retn
sub_b_44E1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_44FB	proc	near
		mov	cl,3
loc_b_44FD:
		mov	si,cx
		mov	al,byte ptr ds:[8F3h][si]
		inc	al
		dec	al
		jz	loc_b_450C		; Jump if zero
		jmp	short loc_b_4513
		db	90h
loc_b_450C:
		dec	cl
		js	loc_ret_b_4512		; Jump if sign=1
		jmp	short loc_b_44FD

loc_ret_b_4512:
		retn
loc_b_4513:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[8E7h][si]
		sub	al,0Eh
		cmc				; Complement carry
		mov	bl,al
		mov	al,byte ptr ds:[8EBh][si]
		inc	al
		dec	al
		jns	loc_b_452F		; Jump if not sign
		jmp	short loc_b_4553
		db	90h
loc_b_452F:
		mov	al,byte ptr ds:[8D7h][si]
		add	al,1Ch
		jnc	loc_b_4539		; Jump if carry=0
		jmp	short loc_b_450C
loc_b_4539:
		add	al,byte ptr ds:[901h][bx]
		jnc	loc_b_4541		; Jump if carry=0
		jmp	short loc_b_450C
loc_b_4541:
		mov	byte ptr ds:[1],al
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jc	loc_b_4550		; Jump if carry Set
		jmp	short loc_b_450C
loc_b_4550:
		jmp	short loc_b_457B
		db	90h
loc_b_4553:
		mov	al,0
		mov	data_b_0003,al
		mov	si,cx
		mov	al,byte ptr ds:[8D7h][si]
		sub	al,4Dh			; 'M'
		add	al,byte ptr ds:[901h][bx]
		jns	loc_b_4569		; Jump if not sign
		jmp	short loc_b_457B
		db	90h
loc_b_4569:
		mov	byte ptr ds:[0],al
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jnc	loc_b_4579		; Jump if carry=0
		jmp	short loc_b_457B
		nop
loc_b_4579:
		jmp	short loc_b_450C
loc_b_457B:
		mov	si,cx
		mov	al,data_b_0086[si]
		inc	al
		dec	al
		jz	loc_b_458A		; Jump if zero
		jmp	short loc_b_45AB
		db	90h
loc_b_458A:
		mov	al,byte ptr ds:[8E7h][si]
		cmp	al,0Eh
		cmc				; Complement carry
		jnz	loc_b_4596		; Jump if not zero
		jmp	short loc_b_45BE
		db	90h
loc_b_4596:
		cmp	al,11h
		cmc				; Complement carry
		jnc	loc_b_459E		; Jump if carry=0
		jmp	short loc_b_45BE
		db	90h
loc_b_459E:
		mov	al,0
		mov	cl,1
		mov	bl,0
		inc	bl
		dec	bl
		call	sub_b_2149
loc_b_45AB:
		mov	cl,data_b_0050
		mov	al,1
		inc	al
		dec	al
		mov	si,cx
		mov	data_b_0086[si],al
		jmp	loc_b_450C
loc_b_45BE:
		mov	al,0
		mov	cl,0
		mov	bl,50h			; 'P'
		inc	bl
		dec	bl
		call	sub_b_2149
		mov	cl,data_b_0050
		mov	al,1
		inc	al
		dec	al
		mov	si,cx
		mov	data_b_0086[si],al
		jmp	loc_b_450C
sub_b_44FB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_45DE	proc	near
		mov	cl,3
loc_b_45E0:
		mov	si,cx
		mov	al,byte ptr ds:[8BEh][si]
		inc	al
		dec	al
		jz	loc_b_45EF		; Jump if zero
		jmp	short loc_b_45F6
		db	90h
loc_b_45EF:
		dec	cl
		js	loc_ret_b_45F5		; Jump if sign=1
		jmp	short loc_b_45E0

loc_ret_b_45F5:
		retn
loc_b_45F6:
		mov	data_b_0050,cl
		mov	si,cx
		mov	al,byte ptr ds:[8CFh][si]
		inc	al
		dec	al
		jns	loc_b_4609		; Jump if not sign
		jmp	short loc_b_4641
		db	90h
loc_b_4609:
		mov	al,byte ptr ds:[8C2h][si]
		add	al,1Ch
		jnc	loc_b_4613		; Jump if carry=0
		jmp	short loc_b_45EF
loc_b_4613:
		add	al,byte ptr ds:[8B2h][si]
		jnc	loc_b_461B		; Jump if carry=0
		jmp	short loc_b_45EF
loc_b_461B:
		mov	bl,byte ptr ds:[8B6h][si]
		add	al,byte ptr ds:[93Ah][bx]
		jnc	loc_b_4627		; Jump if carry=0
		jmp	short loc_b_45EF
loc_b_4627:
		add	al,byte ptr ds:[8BAh][si]
		jnc	loc_b_462F		; Jump if carry=0
		jmp	short loc_b_45EF
loc_b_462F:
		mov	byte ptr ds:[1],al
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jc	loc_b_463E		; Jump if carry Set
		jmp	short loc_b_45EF
loc_b_463E:
		jmp	short loc_b_4676
		db	90h
loc_b_4641:
		mov	al,0
		mov	data_b_0003,al
		mov	si,cx
		mov	al,byte ptr ds:[8C2h][si]
		sub	al,4Dh			; 'M'
		add	al,byte ptr ds:[8B2h][si]
		mov	bl,byte ptr ds:[8B6h][si]
		add	al,byte ptr ds:[93Ah][bx]
		add	al,byte ptr ds:[8BAh][si]
		jns	loc_b_4663		; Jump if not sign
		jmp	short loc_b_4676
		db	90h
loc_b_4663:
		mov	byte ptr ds:[0],al
		mov	al,data_b_0057
		cmp	al,byte ptr ds:[0]
		cmc				; Complement carry
		jnc	loc_b_4673		; Jump if carry=0
		jmp	short loc_b_4676
		db	90h
loc_b_4673:
		jmp	loc_b_45EF
loc_b_4676:
		mov	si,cx
		mov	al,data_b_002A[si]
		inc	al
		dec	al
		jz	loc_b_4685		; Jump if zero
		jmp	short loc_b_469E
		db	90h
loc_b_4685:
		mov	al,byte ptr ds:[8D3h][si]
		cmp	al,15h
		cmc				; Complement carry
		jnc	loc_b_4691		; Jump if carry=0
		jmp	short loc_b_46B1
		db	90h
loc_b_4691:
		mov	al,0
		mov	cl,0
		mov	bl,50h			; 'P'
		inc	bl
		dec	bl
		call	sub_b_2149
loc_b_469E:
		mov	cl,data_b_0050
		mov	al,1
		inc	al
		dec	al
		mov	si,cx
		mov	data_b_002A[si],al
		jmp	loc_b_45EF
loc_b_46B1:
		mov	al,0
		mov	cl,1
		mov	bl,0
		inc	bl
		dec	bl
		call	sub_b_2149
		mov	cl,data_b_0050
		mov	al,1
		inc	al
		dec	al
		mov	si,cx
		mov	data_b_002A[si],al
		jmp	loc_b_45EF
sub_b_45DE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_46D1	proc	near
		mov	al,data_b_00BD
		inc	al
		dec	al
		jz	loc_ret_b_46DD		; Jump if zero
		jmp	short loc_b_46DE
		db	90h

loc_ret_b_46DD:
		retn
loc_b_46DE:
		mov	al,data_b_00D9
		mov	cl,data_b_00BE
		mov	bl,data_b_00BF
		call	sub_b_4FF6
		mov	al,data_b_00BD
		cmp	al,1
		cmc				; Complement carry
		jnz	loc_b_46F7		; Jump if not zero
		jmp	short loc_b_470A
		db	90h
loc_b_46F7:
		mov	al,data_b_00D9
		mov	cl,data_b_00BE
		mov	bl,data_b_00BF
		call	sub_b_4FD7
		dec	data_b_00BD
		retn
loc_b_470A:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00BD,al
		retn
sub_b_46D1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4714	proc	near
		mov	al,data_b_00C0
		inc	al
		dec	al
		jz	loc_ret_b_4720		; Jump if zero
		jmp	short loc_b_4721
		db	90h

loc_ret_b_4720:
		retn
loc_b_4721:
		mov	al,data_b_00DA
		mov	cl,data_b_00C1
		mov	bl,data_b_00C2
		call	sub_b_4FF6
		mov	al,data_b_00C0
		cmp	al,1
		cmc				; Complement carry
		jnz	loc_b_473A		; Jump if not zero
		jmp	short loc_b_474D
		db	90h
loc_b_473A:
		mov	al,data_b_00DA
		mov	cl,data_b_00C1
		mov	bl,data_b_00C2
		call	sub_b_4FD7
		dec	data_b_00C0
		retn
loc_b_474D:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00C0,al
		retn
sub_b_4714	endp

loc_b_4757:
		mov	al,5
		mov	data_b_00BB,al
		mov	al,data_b_001C
		inc	al
		dec	al
		jns	loc_b_4768		; Jump if not sign
		jmp	short loc_b_4771
		db	90h
loc_b_4768:
		mov	al,0FFh
		inc	al
		dec	al
		mov	data_b_001C,al
loc_b_4771:
		call	sub_b_3DB2
		mov	al,3
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,10h
		mov	data_b_00DA,al
		mov	al,0Ah
		mov	data_b_00C0,al
		mov	al,data_b_00B8
		add	al,6
		mov	data_b_00C1,al
		mov	al,data_b_00BA
		mov	data_b_00C2,al
		mov	al,data_b_00DA
		inc	al
		dec	al
		jmp	loc_b_114B
loc_b_479F:
		mov	al,1
		mov	data_b_00BB,al
		mov	al,0
		mov	data_b_00DB,al
		mov	al,3Ch			; '<'
		mov	data_b_00BC,al
		mov	al,2
		mov	data_b_00B7,al
		mov	data_b_00B8,al
		mov	al,8Ah
		mov	data_b_00B9,al
		mov	data_b_00BA,al
		mov	al,18h
		mov	cl,data_b_00B7
		mov	bl,data_b_00B9
		call	sub_b_5015

loc_ret_b_47CB:
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_47CC	proc	near
		mov	al,data_b_00BB
		inc	al
		dec	al
		jnz	loc_b_47D7		; Jump if not zero
		jmp	short loc_ret_b_47CB
loc_b_47D7:
		cmp	al,2
		cmc				; Complement carry
		jnz	loc_b_47DF		; Jump if not zero
		jmp	short loc_b_47E2
		nop
loc_b_47DF:
		jmp	short loc_b_4820
		db	90h
loc_b_47E2:
		mov	al,data_b_00B8
		add	al,2Dh			; '-'
		mov	byte ptr ds:[1],al
		mov	al,data_b_001A
		inc	al
		dec	al
		jnz	loc_b_47F6		; Jump if not zero
		jmp	short loc_b_4820
		db	90h
loc_b_47F6:
		add	al,5
		cmp	al,data_b_00B8
		cmc				; Complement carry
		jc	loc_b_4802		; Jump if carry Set
		jmp	short loc_b_4820
		db	90h
loc_b_4802:
		sub	al,0Ch
		cmp	al,byte ptr ds:[1]
		cmc				; Complement carry
		jnc	loc_b_480E		; Jump if carry=0
		jmp	short loc_b_4820
		db	90h
loc_b_480E:
		mov	al,data_b_001B
		add	al,5
		cmp	al,data_b_00BA
		cmc				; Complement carry
		jc	loc_b_481D		; Jump if carry Set
		jmp	short loc_b_4820
		db	90h
loc_b_481D:
		jmp	loc_b_4757
loc_b_4820:
		mov	al,data_b_0059
		add	al,1Eh
		cmp	al,data_b_00B8
		cmc				; Complement carry
		jc	loc_b_482F		; Jump if carry Set
		jmp	short loc_ret_b_4868
		db	90h
loc_b_482F:
		mov	al,data_b_00B8
		add	al,0Fh
		cmp	al,data_b_0059
		cmc				; Complement carry
		jc	loc_b_483E		; Jump if carry Set
		jmp	short loc_ret_b_4868
		db	90h
loc_b_483E:
		mov	al,byte ptr data_b_005A
		add	al,0Eh
		cmp	al,data_b_00BA
		cmc				; Complement carry
		jc	loc_b_484D		; Jump if carry Set
		jmp	short loc_ret_b_4868
		db	90h
loc_b_484D:
		mov	al,18h
		mov	cl,data_b_00B8
		mov	bl,data_b_00BA
		call	sub_b_5034
		mov	al,0
		mov	data_b_00BB,al
		mov	al,1
		inc	al
		dec	al
		mov	data_b_0070,al

loc_ret_b_4868:
		retn
sub_b_47CC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4869	proc	near
		mov	al,data_b_00BB
		inc	al
		dec	al
		jz	loc_ret_b_4875		; Jump if zero
		jmp	short loc_b_4876
		db	90h

loc_ret_b_4875:
		retn
loc_b_4876:
		mov	al,18h
		mov	cl,data_b_00B8
		mov	bl,data_b_00BA
		call	sub_b_5034
		mov	al,data_b_00BB
		cmp	al,5
		cmc				; Complement carry
		jnz	loc_b_488E		; Jump if not zero
		jmp	short loc_b_489E
		db	90h
loc_b_488E:
		mov	al,18h
		mov	cl,data_b_00B7
		mov	bl,data_b_00B9
		call	sub_b_5015
		jmp	short loc_b_48A8
		db	90h
loc_b_489E:
		mov	al,0
		inc	al
		dec	al
		mov	data_b_00BB,al
		retn
loc_b_48A8:
		mov	al,data_b_00BB
		cmp	al,1
		cmc				; Complement carry
		jnz	loc_b_48B3		; Jump if not zero
		jmp	short loc_b_4905
		db	90h
loc_b_48B3:
		mov	al,data_b_00B7
		mov	data_b_00B8,al
		mov	al,data_b_00B9
		mov	data_b_00BA,al
		mov	al,data_b_00B7
		add	al,4
		jc	loc_b_48C9		; Jump if carry Set
		jmp	short loc_b_48D3
		db	90h
loc_b_48C9:
		mov	al,5
		inc	al
		dec	al
		mov	data_b_00BB,al
		retn
loc_b_48D3:
		mov	data_b_00B7,al
		mov	al,data_b_0057
		add	al,2Ch			; ','
		cmp	al,data_b_00B7
		cmc				; Complement carry
		jnc	loc_b_48E5		; Jump if carry=0
		jmp	short loc_ret_b_4904
		db	90h
loc_b_48E5:
		mov	al,data_b_00DB
		inc	al
		dec	al
		jz	loc_b_48F1		; Jump if zero
		jmp	short loc_ret_b_4904
		db	90h
loc_b_48F1:
		mov	al,1
		mov	data_b_00DB,al
		mov	al,1
		mov	data_b_00BB,al
		mov	al,7
		inc	al
		dec	al
		mov	data_b_00BC,al

loc_ret_b_4904:
		retn
loc_b_4905:
		mov	al,data_b_00B7
		mov	data_b_00B8,al
		mov	al,data_b_00B9
		mov	data_b_00BA,al
		mov	al,4
		inc	al
		dec	al
		call	sub_b_31E0
		add	al,8Dh
		add	al,1
		mov	data_b_00B9,al
		dec	data_b_00BC
		jz	loc_b_492A		; Jump if zero
		jmp	short loc_ret_b_4933
		db	90h
loc_b_492A:
		mov	al,2
		inc	al
		dec	al
		mov	data_b_00BB,al

loc_ret_b_4933:
		retn
sub_b_4869	endp

loc_b_4934:
		mov	al,1
		mov	byte ptr ds:[21Dh],al
		mov	al,byte ptr ds:[217h]
		inc	al
		dec	al
		jz	loc_b_4945		; Jump if zero
		jmp	short loc_b_4948
		db	90h
loc_b_4945:
		jmp	loc_b_4A32
loc_b_4948:
		mov	al,byte ptr ds:[22Ah]
		inc	al
		dec	al
		jnz	loc_b_4954		; Jump if not zero
		jmp	short loc_b_49C3
		db	90h
loc_b_4954:
		mov	cl,7
		mov	bl,4Eh			; 'N'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'                        @'
		db	0B1h, 07h,0B3h, 55h,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 6Bh,0D8h
		db	' END OF GAME PLAYER TWO @'
		db	0B1h, 07h,0B3h, 5Ch,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 47h,0D8h
		db	24 dup (20h)
		db	 40h,0E9h,0BAh, 00h
loc_b_49C3:
		mov	cl,7
		mov	bl,4Eh			; 'N'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'                        @'
		db	0B1h, 07h,0B3h, 55h,0FEh,0C3h
		db	0FEh,0CBh,0E8h,0FCh,0D7h
		db	' END OF GAME PLAYER ONE @'
		db	0B1h, 07h,0B3h, 5Ch,0FEh,0C3h
		db	0FEh,0CBh,0E8h,0D8h,0D7h
		db	24 dup (20h)
		db	 40h,0EBh, 4Ch, 90h
loc_b_4A32:
		mov	cl,0Dh
		mov	bl,4Eh			; 'N'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'             @'
		db	0B1h, 0Dh,0B3h, 55h,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 98h,0D7h
		db	' END OF GAME @'
		db	0B1h, 0Dh,0B3h, 5Ch,0FEh,0C3h
		db	0FEh,0CBh,0E8h, 7Fh,0D7h
		db	13 dup (20h)
		db	 40h,0E8h,0FAh, 01h,0B1h, 32h
loc_b_4A82:
		mov	al,0A0h
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_4A91		; Jump if sign=1
		jmp	short loc_b_4A82
loc_b_4A91:
		mov	al,byte ptr ds:[217h]
		inc	al
		dec	al
		jnz	loc_b_4A9D		; Jump if not zero
		jmp	short loc_b_4ABD
		db	90h
loc_b_4A9D:
		mov	al,byte ptr ds:[214h]
		add	al,byte ptr ds:[215h]
		jnz	loc_b_4AA9		; Jump if not zero
		jmp	short loc_b_4ABD
		db	90h
loc_b_4AA9:
		mov	al,1
		mov	data_b_002E,al
		mov	al,byte ptr ds:[22Ah]
		rcl	ah,1			; Rotate thru carry
		xor	al,1
		rcr	ah,1			; Rotate thru carry
		mov	byte ptr ds:[22Ah],al
		jmp	loc_b_3C89
loc_b_4ABD:
		call	sub_b_4F9B
		mov	al,1
		mov	byte ptr ds:[21Dh],al
		mov	cl,2
		mov	bl,55h			; 'U'
		inc	bl
		dec	bl
		call	sub_b_21EE
		db	'PRESS SPACE BAR TO CONTINUE GAME'
		db	' @'
		db	0E8h, 8Eh, 03h,0B0h, 10h
loc_b_4AF7:
		mov	data_b_00B0,al
		mov	al,23h			; '#'
		mov	data_b_00A6,al
		mov	al,55h			; 'U'
		mov	data_b_00A7,al
		mov	al,data_b_00B0
		inc	al
		dec	al
		call	sub_b_2132
		mov	cl,0Fh
loc_b_4B10:
		mov	al,0A0h
		inc	al
		dec	al
		call	sub_b_4E76
		dec	cl
		js	loc_b_4B1F		; Jump if sign=1
		jmp	short loc_b_4B10
loc_b_4B1F:
		mov	al,byte ptr data_b_0100
		cmp	al,0A0h
		cmc				; Complement carry
		jnz	loc_b_4B2A		; Jump if not zero
		jmp	short loc_b_4B66
		db	90h
loc_b_4B2A:
		call	sub_b_4EB4
		mov	byte ptr ds:[0],al
		rcl	ah,1			; Rotate thru carry
		xor	al,data_b_009E
		rcr	ah,1			; Rotate thru carry
		js	loc_b_4B3D		; Jump if sign=1
		jmp	short loc_b_4B4F
		db	90h
loc_b_4B3D:
		mov	al,byte ptr ds:[0]
		inc	al
		dec	al
		js	loc_b_4B49		; Jump if sign=1
		jmp	short loc_b_4B4F
		db	90h
loc_b_4B49:
		mov	data_b_009E,al
		jmp	short loc_b_4B66
		db	90h
loc_b_4B4F:
		mov	al,byte ptr ds:[0]
		mov	data_b_009E,al
		mov	al,data_b_00B0
		sub	al,1
		das				; Decimal adjust
		cmc				; Complement carry
		jz	loc_b_4B60		; Jump if zero
		jmp	short loc_b_4AF7
loc_b_4B60:
		call	sub_b_44DD
		jmp	loc_b_3721
loc_b_4B66:
		mov	al,4
		inc	al
		dec	al
		mov	byte ptr ds:[214h],al
		mov	byte ptr ds:[215h],al
		call	sub_b_44E1
		mov	al,0
		mov	data_b_002E,al
		mov	al,1
		mov	byte ptr ds:[22Ah],al
		mov	al,0
		mov	byte ptr ds:[204h],al
		mov	byte ptr ds:[206h],al
		mov	byte ptr ds:[208h],al
		mov	byte ptr ds:[205h],al
		mov	byte ptr ds:[207h],al
		mov	byte ptr ds:[209h],al
		mov	data_b_007C,al
		mov	data_b_007B,al
		mov	data_b_007A,al
		call	sub_b_2000
		mov	al,0
		inc	al
		dec	al
		mov	byte ptr ds:[22Ah],al
		call	sub_b_2000
		jmp	loc_b_3C89

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4BAE	proc	near
		call	sub_b_516A
		mov	al,data_b_0028
		sub	al,data_b_00AF
		cmc				; Complement carry
		jnc	loc_b_4BBE		; Jump if carry=0
		jmp	short loc_b_4BD0
		db	90h
loc_b_4BBE:
		add	al,7
		dec	data_b_0029
		js	loc_b_4BC9		; Jump if sign=1
		jmp	short loc_b_4BD0
		db	90h
loc_b_4BC9:
		push	ax
		mov	al,27h			; '''
		mov	data_b_0029,al
		pop	ax
loc_b_4BD0:
		mov	data_b_0028,al
		mov	al,data_b_006F
		inc	al
		dec	al
		jnz	loc_b_4BDF		; Jump if not zero
		jmp	short loc_b_4BE2
		db	90h
loc_b_4BDF:
		jmp	loc_b_5113
loc_b_4BE2:
		call	sub_b_51DB
		mov	cl,3
loc_b_4BE7:
		mov	si,cx
		mov	al,byte ptr ds:[8BEh][si]
		inc	al
		dec	al
		jz	loc_b_4BF6		; Jump if zero
		jmp	short loc_b_4C00
		db	90h
loc_b_4BF6:
		dec	cl
		js	loc_b_4BFC		; Jump if sign=1
		jmp	short loc_b_4BE7
loc_b_4BFC:
		call	sub_b_521F
		retn
loc_b_4C00:
		mov	data_b_0016,cl
		mov	si,cx
		mov	al,byte ptr ds:[8CFh][si]
		mov	bl,byte ptr ds:[8C2h][si]
		add	al,byte ptr ds:[0E0Ah][bx]
		mov	byte ptr ds:[0],al
		mov	al,byte ptr ds:[110Ah][bx]
		shr	al,1			; Shift w/zeros fill
		sub	al,1
		add	al,byte ptr ds:[8B2h][si]
		cmp	al,7
		cmc				; Complement carry
		jc	loc_b_4C29		; Jump if carry Set
		jmp	short loc_b_4C2F
		db	90h
loc_b_4C29:
		inc	byte ptr ds:[0]
		sub	al,7
loc_b_4C2F:
		mov	byte ptr ds:[1],al
		mov	al,byte ptr ds:[0]
		mov	si,cx
		add	al,byte ptr ds:[8B6h][si]
		mov	byte ptr ds:[2],al
		mov	al,byte ptr ds:[1]
		add	al,byte ptr ds:[8BAh][si]
		cmp	al,7
		cmc				; Complement carry
		jc	loc_b_4C4D		; Jump if carry Set
		jmp	short loc_b_4C53
		db	90h
loc_b_4C4D:
		inc	byte ptr ds:[2]
		sub	al,7
loc_b_4C53:
		mov	data_b_0003,al
		mov	al,byte ptr ds:[0]
		mov	byte ptr data_b_0008+1,al
		mov	al,byte ptr ds:[1]
		mov	byte ptr data_b_0008,al
		call	sub_b_524D
		mov	cl,data_b_0016
		inc	cl
		dec	cl
		jmp	short loc_b_4BF6
sub_b_4BAE	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4C70	proc	near
		mov	si,0B75h
		jmp	short loc_b_4C7D

;==== External Entry into Subroutine ======================================

sub_b_4C75:
		mov	si,0BBCh
		jmp	short loc_b_4C7D

;==== External Entry into Subroutine ======================================

sub_b_4C7A:
		mov	si,0DA7h
loc_b_4C7D:
		mov	al,0
		mov	data_b_0093,al
		mov	data_b_0094,al
		cmp	byte ptr ds:data_b_8852_e,2
		jne	loc_b_4C96		; Jump if not equal
		mov	dx,61h
loc_b_4C8F:
		lodsb				; String [si] to al
		test	al,al
		jnz	loc_b_4CA5		; Jump if not zero
		jmp	short loc_b_4C9E
loc_b_4C96:
		mov	ah,0Ch

locloop_b_4C98:
		loop	locloop_b_4C98		; Loop if cx > 0

		dec	ah
		jnz	locloop_b_4C98		; Jump if not zero
loc_b_4C9E:
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
loc_b_4CA5:
		mov	ah,al
		mov	al,0
		xchg	bp,ax
		mov	cl,0
		call	sub_b_4D66
		mov	byte ptr cs:[4D01h],al
		mov	byte ptr cs:[4D15h],al
		mov	byte ptr cs:[4D05h],cl
		mov	byte ptr cs:[4D19h],cl
		mov	cl,1
		call	sub_b_4D66
		mov	byte ptr cs:[4D35h],al
		mov	byte ptr cs:[4D49h],al
		mov	byte ptr cs:[4D39h],cl
		mov	byte ptr cs:[4D4Dh],cl
		cmp	data_b_0092,0
		jne	loc_b_4CEB		; Jump if not equal
		shl	data_b_0093,1		; Shift w/zeros fill
		shl	data_b_0093,1		; Shift w/zeros fill
		shl	data_b_0093,1		; Shift w/zeros fill
loc_b_4CEB:
		mov	ax,0
		mov	cl,8Ah
		mov	bl,40h			; '@'
loc_b_4CF2:
		dec	bl
		jnz	loc_b_4D08		; Jump if not zero
		mov	bl,data_b_0091
		test	ah,80h
		js	loc_b_4D1C		; Jump if sign=1
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		xor	al,2
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		xor	ah,80h
		jmp	short loc_b_4D22
loc_b_4D08:
		cmp	bl,data_b_0093
		jne	loc_b_4D1E		; Jump if not equal
		test	ah,80h
		jns	loc_b_4D20		; Jump if not sign
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		xor	al,2
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		xor	ah,80h
		jmp	short loc_b_4D26
loc_b_4D1C:
		nop
		nop
loc_b_4D1E:
		nop
		nop
loc_b_4D20:
		nop
		nop
loc_b_4D22:
		nop
		nop
		nop
		nop
loc_b_4D26:
		dec	cl
		jnz	loc_b_4D3C		; Jump if not zero
		mov	cl,data_b_0092
		test	ah,80h
		js	loc_b_4D50		; Jump if sign=1
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		xor	al,2
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		xor	ah,80h
		jmp	short loc_b_4D56
loc_b_4D3C:
		cmp	cl,data_b_0094
		jne	loc_b_4D52		; Jump if not equal
		test	ah,80h
		jns	loc_b_4D54		; Jump if not sign
		in	al,dx			; port 0, DMA-1 bas&add ch 0
		xor	al,2
		out	dx,al			; port 0, DMA-1 bas&add ch 0
		xor	ah,80h
		jmp	short loc_b_4D5A
loc_b_4D50:
		nop
		nop
loc_b_4D52:
		nop
		nop
loc_b_4D54:
		nop
		nop
loc_b_4D56:
		nop
		nop
		nop
		nop
loc_b_4D5A:
		mov	di,4
loc_b_4D5D:
		dec	di
		jnz	loc_b_4D5D		; Jump if not zero
		dec	bp
		jnz	loc_b_4CF2		; Jump if not zero
		jmp	loc_b_4C8F
sub_b_4C70	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4D66	proc	near
		lodsb				; String [si] to al
		test	al,al
		xchg	di,cx
		mov	data_b_0091[di],al
		mov	ah,0
		ror	ax,1			; Rotate
		ror	ax,1			; Rotate
		ror	ax,1			; Rotate
		ror	ax,1			; Rotate
		mov	data_b_0093[di],al
		xchg	cx,di
		jz	loc_ret_b_4D85		; Jump if zero
		mov	al,2
		mov	cl,0A0h

loc_ret_b_4D85:
		retn
sub_b_4D66	endp

		db	10 dup (0)
		db	 02h,0BBh, 5Ah, 30h, 5Fh,0EEh
		db	 3Dh,0A8h
		db	4Dh
		db	'oon Patrol Copyright (C) 1984 At'
		db	'ari, Inc.', 0
		db	 80h, 36h, 51h, 88h, 01h,0E9h
		db	 00h,0B6h
loc_b_4DCB:
		mov	byte ptr ds:[231h],0
		mov	byte ptr ds:[230h],0
		mov	byte ptr ds:[22Fh],0
loc_b_4DDA:
		xor	ax,ax			; Zero register
		call	sub_b_0473
		mov	si,word ptr ds:[2F84h]
		call	sub_b_53B2
		mov	cx,15h
		mov	dx,0B9h
		mov	si,word ptr ds:[2F86h]
		call	sub_b_52F9
		mov	byte ptr ds:data_b_896D_e,0FFh
		mov	bp,7C0h
		jmp	short loc_b_4E3E
loc_b_4DFD:
		xor	ax,ax			; Zero register
		call	sub_b_0473
		mov	byte ptr ds:data_b_896D_e,0FEh
		call	sub_b_4EC6
		mov	cx,15h
		mov	dx,0C1h
		mov	si,word ptr ds:[2F86h]
		call	sub_b_52F9
		mov	byte ptr ds:data_b_896D_e,0
		mov	bp,3721h
		jmp	short loc_b_4E3E
			                        ;* No entry point to code
		xor	ax,ax			; Zero register
		call	sub_b_0473
		mov	byte ptr ds:data_b_896D_e,0
		mov	al,ds:data_b_8850_e
		mov	byte ptr ds:[217h],al
		mov	bp,32F4h
		jmp	short loc_b_4E3E
			                        ;* No entry point to code
		xor	byte ptr ds:data_b_8850_e,1
		jmp	loc_b_03CB
loc_b_4E3E:
		mov	sp,1EEh
		push	bp
		mov	al,ds:data_b_8851_e
		mov	byte ptr ds:[216h],al
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E4F	proc	near
		push	cx
		push	bp
		push	ds
		mov	al,0FFh
		xor	bp,bp			; Zero register
loc_b_4E56:
		xor	bx,bx			; Zero register
		mov	cx,46h
		mov	ds,ss:data_d_53C9_e[bp]

locloop_b_4E5F:
		xor	[bx],al
		inc	bx
		loop	locloop_b_4E5F		; Loop if cx > 0

		inc	bp
		inc	bp
		cmp	bp,180h
		jne	loc_b_4E56		; Jump if not equal
		pop	ds
		pop	bp
		pop	cx
		retn
sub_b_4E4F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E70	proc	near
		retn
sub_b_4E70	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E72	proc	near
		retn
sub_b_4E72	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E73	proc	near
		jmp	loc_b_04A3
sub_b_4E73	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E76	proc	near
loc_b_4E76:
		push	ax
loc_b_4E77:
		dec	al
		nop
		jnz	loc_b_4E77		; Jump if not zero
		pop	ax
		dec	al
		nop
		jnz	loc_b_4E76		; Jump if not zero
		retn
sub_b_4E76	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E83	proc	near
		lahf				; Load ah from flags
		and	byte ptr data_b_0100,7Fh
		sahf				; Store ah into flags
		retn
sub_b_4E83	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E8B	proc	near
		lahf				; Load ah from flags
		in	al,61h			; port 61h, 8255 port B, read
		xor	al,ds:data_b_8852_e
		and	al,ds:data_b_896E_e
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		sahf				; Store ah into flags
		retn
sub_b_4E8B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4E9A	proc	near
		rcr	ch,1			; Rotate thru carry
		push	cx
		call	sub_b_063F
		xor	dx,dx			; Zero register
		pop	cx
		mov	bl,al
		test	cl,1
		jz	loc_b_4EAC		; Jump if zero
		mov	bl,ah
loc_b_4EAC:
		add	bl,80h
		xor	bh,bh			; Zero register
		rcl	ch,1			; Rotate thru carry
		retn
sub_b_4E9A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4EB4	proc	near
		rcr	ch,1			; Rotate thru carry
		push	bx
		push	cx
		call	sub_b_0689
		xor	dx,dx			; Zero register
		pop	cx
		pop	bx
		and	al,ah
		xor	al,80h
		rcl	ch,1			; Rotate thru carry
		retn
sub_b_4EB4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4EC6	proc	near
		inc	byte ptr ds:data_b_896D_e
		jz	loc_ret_b_4F0C		; Jump if zero
		dec	byte ptr ds:data_b_896D_e
		mov	ax,0B800h
		mov	es,ax
		xor	di,di			; Zero register
		mov	cx,4000h
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		mov	cx,0
		mov	dx,0
		mov	si,word ptr ds:[2F80h]
		call	sub_b_52F9
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		call	sub_b_2040
		test	byte ptr ds:data_b_896D_e,80h
		js	loc_ret_b_4F0C		; Jump if sign=1
		mov	cx,0
		mov	dx,80h
		mov	si,word ptr ds:[2F82h]
		call	sub_b_52F9
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register

loc_ret_b_4F0C:
		retn
sub_b_4EC6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4F0D	proc	near
		mov	bp,48h
loc_b_4F10:
		mov	es,ss:data_d_53C9_e[bp]
		xor	al,al			; Zero register
		mov	cx,46h
		xor	di,di			; Zero register
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		inc	bp
		inc	bp
		cmp	bp,132h
		jne	loc_b_4F10		; Jump if not equal
		mov	bp,138h
loc_b_4F28:
		mov	es,ss:data_d_53C9_e[bp]
		mov	al,0AAh
		mov	cx,46h
		xor	di,di			; Zero register
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		inc	bp
		inc	bp
		cmp	bp,180h
		jne	loc_b_4F28		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4F0D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4F44	proc	near
		mov	bp,48h
loc_b_4F47:
		mov	es,ss:data_d_53C9_e[bp]
		xor	al,al			; Zero register
		mov	cx,46h
		xor	di,di			; Zero register
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		inc	bp
		inc	bp
		cmp	bp,180h
		jne	loc_b_4F47		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4F44	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4F63	proc	near
		mov	al,7
		mul	data_b_00B0		; ax = data * al
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		xchg	bx,ax
		mov	al,7
		mul	data_b_00B1		; ax = data * al
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		xchg	dx,ax
		mov	bp,10Eh
loc_b_4F7C:
		mov	es,ss:data_d_53C9_e[bp]
		xor	al,al			; Zero register
		mov	di,bx
		mov	cx,dx
		sub	cx,bx
		jbe	loc_b_4F8C		; Jump if below or =
		rep	stosb			; Rep when cx >0 Store al to es:[di]
loc_b_4F8C:
		inc	bp
		inc	bp
		cmp	bp,132h
		jne	loc_b_4F7C		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4F63	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4F9B	proc	near
		mov	bp,48h
loc_b_4F9E:
		mov	es,ss:data_d_53C9_e[bp]
		xor	al,al			; Zero register
		mov	cx,46h
		xor	di,di			; Zero register
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		inc	bp
		inc	bp
		cmp	bp,180h
		jne	loc_b_4F9E		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4F9B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4FBA	proc	near
		and	ax,3Fh
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,data_b_1268[si]
		mov	al,7
		mul	cl			; ax = reg * al
		xchg	cx,ax
		mov	dl,bl
		mov	dh,0
		call	sub_b_536D
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4FBA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4FD7	proc	near
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,data_b_1242[si]
		mov	al,7
		imul	byte ptr ds:[39h]	; ax = data * al
		add	cx,ax
		mov	dl,bl
		mov	dh,0
		inc	dx
		call	sub_b_52F9
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4FD7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_4FF6	proc	near
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,data_b_1242[si]
		mov	al,7
		imul	byte ptr ds:[39h]	; ax = data * al
		add	cx,ax
		mov	dl,bl
		mov	dh,0
		inc	dx
		call	sub_b_5332
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_4FF6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_5015	proc	near
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,word ptr ds:[1210h][si]
		mov	al,7
		imul	byte ptr ds:[39h]	; ax = data * al
		add	cx,ax
		mov	dl,bl
		mov	dh,0
		inc	dx
		call	sub_b_52F9
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_5015	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_5034	proc	near
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,word ptr ds:[1210h][si]
		mov	al,7
		imul	byte ptr ds:[39h]	; ax = data * al
		add	cx,ax
		mov	dl,bl
		mov	dh,0
		inc	dx
		call	sub_b_5332
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_5034	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_5053	proc	near
		cbw				; Convrt byte to word
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,word ptr ds:[1210h][si]
		mov	al,7
		imul	data_b_0033		; ax = data * al
		add	cx,ax
		mov	dl,bl
		mov	dh,0
		inc	dx
		call	sub_b_536D
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_5053	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_5072	proc	near
		mov	bl,data_b_0041
		mov	cl,8Dh
		mov	dx,0CF3h
		mov	di,0FFFFh

locloop_b_507E:
		mov	al,byte ptr ds:[100Ah][bx]
		mov	ah,0
		shl	ax,1			; Shift w/zeros fill
		xchg	bp,ax
		mov	es,ss:data_d_53C9_e[bp]
		test	di,di
		js	loc_b_5092		; Jump if sign=1
		or	es:[di],dh
loc_b_5092:
		xor	dx,0CCCCh
		jns	loc_b_5099		; Jump if not sign
		inc	di
loc_b_5099:
		and	es:[di],dl
		inc	bl
		cmp	bl,8Dh
		jne	loc_b_50A5		; Jump if not equal
		xor	bl,bl			; Zero register
loc_b_50A5:
		loop	locloop_b_507E		; Loop if cx > 0

		mov	data_b_0042,8Dh
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_5072	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_50B3	proc	near
		push	cx
		mov	cx,86h
		mov	si,8A8Bh
		cmp	byte ptr data_b_0004,0
		je	loc_b_50C4		; Jump if equal
		mov	si,data_b_8A8F_e
loc_b_50C4:
		mov	dx,1Fh
		push	cx
		push	si
		call	sub_b_536D
		pop	si
		pop	cx
		inc	cx
		mov	bl,data_b_0078
		mov	bh,0
		cmp	cl,byte ptr ds:[0DD0h][bx]
		jb	loc_b_50C4		; Jump if below
		xor	bx,bx			; Zero register
		pop	cx
		xor	dx,dx			; Zero register
		retn
sub_b_50B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_50E1	proc	near
		mov	al,7
		imul	data_b_00D7		; ax = data * al
		add	al,data_b_00D8
		adc	ah,bh
		xchg	cx,ax
		mov	dx,0B4h
		mov	al,data_b_00D5
		and	ax,3Fh
		shl	ax,1			; Shift w/zeros fill
		xchg	si,ax
		mov	si,data_b_1268[si]
		push	cx
		call	sub_b_52F9
		pop	cx
		mov	dx,0B4h
		mov	si,data_b_8A93_e
		call	sub_b_5332
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_50E1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_5113	proc	near
loc_b_5113:
		mov	al,7
		mul	data_b_0029		; ax = data * al
		add	al,data_b_0028
		adc	ah,bh
		mov	bx,ax
		mov	dx,ax
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,word ptr ds:[2F88h][bx]
		mov	al,7
		mul	data_b_006E		; ax = data * al
		xchg	bx,ax
		sar	bx,1			; Shift w/sign fill
		sar	bx,1			; Shift w/sign fill
		lodsw				; String [si] to ax
		mov	bp,132h
loc_b_5140:
		mov	cx,46h
		mov	di,dx
		mov	es,ss:data_d_53C9_e[bp]

locloop_b_5149:
		lodsb				; String [si] to al
		cmp	di,bx
		jb	loc_b_5151		; Jump if below
		mov	es:[di],al
loc_b_5151:
		inc	di
		cmp	di,46h
		jb	loc_b_5159		; Jump if below
		xor	di,di			; Zero register
loc_b_5159:
		loop	locloop_b_5149		; Loop if cx > 0

		inc	bp
		inc	bp
		cmp	bp,138h
		jne	loc_b_5140		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_5113	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_516A	proc	near
		push	ds
		pop	es
		mov	cx,46h
		xor	si,si			; Zero register
		mov	di,data_b_896F_e
		mov	ds,cs:data_b_54FB
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,46h
		xor	si,si			; Zero register
		mov	ds,cs:data_b_54FD
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,46h
		xor	si,si			; Zero register
		mov	ds,cs:data_b_54FF
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		push	es
		pop	ds
		mov	al,7
		mul	data_b_0029		; ax = data * al
		add	al,data_b_0028
		adc	ah,bh
		mov	bx,ax
		mov	dx,ax
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,word ptr ds:[2F88h][bx]
		lodsw				; String [si] to ax
		mov	bx,data_b_896F_e
loc_b_51B7:
		mov	cx,46h
		mov	di,dx

locloop_b_51BC:
		lodsb				; String [si] to al
		not	al
		and	[bx+di],al
		inc	di
		cmp	di,46h
		jb	loc_b_51C9		; Jump if below
		xor	di,di			; Zero register
loc_b_51C9:
		loop	locloop_b_51BC		; Loop if cx > 0

		add	bx,46h
		cmp	bx,8A41h
		jne	loc_b_51B7		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_516A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_51DB	proc	near
		mov	al,7
		mul	data_b_0029		; ax = data * al
		add	al,data_b_0028
		adc	ah,bh
		mov	bx,ax
		mov	dx,ax
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	si,word ptr ds:[2F88h][bx]
		lodsw				; String [si] to ax
		mov	bx,data_b_896F_e
loc_b_51FD:
		mov	cx,46h
		mov	di,dx

locloop_b_5202:
		lodsb				; String [si] to al
		or	[bx+di],al
		inc	di
		cmp	di,46h
		jb	loc_b_520D		; Jump if below
		xor	di,di			; Zero register
loc_b_520D:
		loop	locloop_b_5202		; Loop if cx > 0

		add	bx,46h
		cmp	bx,8A41h
		jne	loc_b_51FD		; Jump if not equal
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_51DB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_521F	proc	near
		mov	cx,46h
		mov	si,data_b_896F_e
		xor	di,di			; Zero register
		mov	es,cs:data_b_54FB
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,46h
		xor	di,di			; Zero register
		mov	es,cs:data_b_54FD
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		mov	cx,46h
		xor	di,di			; Zero register
		mov	es,cs:data_b_54FF
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_521F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_524D	proc	near
		mov	al,7
		imul	byte ptr ds:[0]		; ax = data * al
		add	al,byte ptr ds:[1]
		adc	ah,bh
		mov	si,ax
		sar	si,1			; Shift w/sign fill
		sar	si,1			; Shift w/sign fill
		mov	bl,al
		and	bl,3
		mov	al,7
		imul	byte ptr ds:[2]		; ax = data * al
		add	al,data_b_0003
		adc	ah,bh
		mov	dx,ax
		sar	dx,1			; Shift w/sign fill
		sar	dx,1			; Shift w/sign fill
		mov	cl,al
		and	cl,3
loc_b_527B:
		cmp	si,46h
		jae	loc_b_5290		; Jump if above or =
		mov	al,ds:data_b_8A87_e[bx]
		and	ds:data_b_896F_e[si],al
		and	ds:data_b_89B5_e[si],al
		and	ds:data_b_89FB_e[si],al
loc_b_5290:
		inc	bx
		and	bl,3
		jnz	loc_b_5297		; Jump if not zero
		inc	si
loc_b_5297:
		cmp	bl,cl
		jne	loc_b_527B		; Jump if not equal
		cmp	si,dx
		jl	loc_b_527B		; Jump if <
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_524D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_52A6	proc	near
		mov	al,7
		mul	data_b_006C		; ax = data * al
		mov	si,ax
		shr	si,1			; Shift w/zeros fill
		shr	si,1			; Shift w/zeros fill
		and	al,3
		mov	cl,al
		add	cl,cl
		mov	dx,0FF00h
		ror	dx,cl			; Rotate
		mov	cx,45h
		mov	al,data_b_0068
		mov	ah,0
		shl	ax,1			; Shift w/zeros fill
		xchg	bp,ax
		xor	di,di			; Zero register
		mov	es,ss:data_d_53C9_e[bp]
loc_b_52CE:
		mov	al,es:[di+1]
loc_b_52D2:
		cmp	di,si
		ja	loc_b_52F2		; Jump if above
		jc	loc_b_52DF		; Jump if carry Set
		mov	ah,es:[di]
		and	ax,dx
		or	al,ah
loc_b_52DF:
		stosb				; Store al to es:[di]
		dec	cx
		js	loc_b_52F2		; Jump if sign=1
		jnz	loc_b_52CE		; Jump if not zero
		mov	al,0
		cmp	data_b_0068,9Ch
		jb	loc_b_52D2		; Jump if below
		mov	al,0AAh
		jmp	short loc_b_52D2
loc_b_52F2:
		xor	bx,bx			; Zero register
		xor	cx,cx			; Zero register
		xor	dx,dx			; Zero register
		retn
sub_b_52A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_52F9	proc	near
		mov	bp,53C9h
		add	bp,dx
		add	bp,dx
		mov	bx,cx
		sar	bx,1			; Shift w/sign fill
		sar	bx,1			; Shift w/sign fill
		js	loc_b_530C		; Jump if sign=1

		;and	bx,7Fh
		db	81h, 0e3h, 7Fh, 0

loc_b_530C:
		and	cl,3
		add	cl,cl
		lodsw				; String [si] to ax
		xchg	dx,ax
loc_b_5313:
		mov	ch,dl
		mov	di,bx
		mov	es,[bp]
loc_b_531A:
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		ror	ax,cl			; Rotate
		and	ax,ds:data_b_8AD1_e[di]
		or	es:[di],ax
		inc	di
		dec	ch
		jnz	loc_b_531A		; Jump if not zero
		inc	bp
		inc	bp
		dec	dh
		jnz	loc_b_5313		; Jump if not zero
		retn
sub_b_52F9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_5332	proc	near
		mov	bp,53C9h
		add	bp,dx
		add	bp,dx
		mov	bx,cx
		sar	bx,1			; Shift w/sign fill
		sar	bx,1			; Shift w/sign fill
		js	loc_b_5345		; Jump if sign=1
		;and	bx,7Fh
		db	81h, 0e3h, 7Fh, 0

loc_b_5345:
		and	cl,3
		add	cl,cl
		lodsw				; String [si] to ax
		xchg	dx,ax
loc_b_534C:
		mov	ch,dl
		mov	di,bx
		mov	es,[bp]
loc_b_5353:
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		ror	ax,cl			; Rotate
		and	ax,ds:data_b_8AD1_e[di]
		not	ax
		and	es:[di],ax
		inc	di
		dec	ch
		jnz	loc_b_5353		; Jump if not zero
		inc	bp
		inc	bp
		dec	dh
		jnz	loc_b_534C		; Jump if not zero
		retn
sub_b_5332	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_536D	proc	near
		mov	bp,53C9h
		add	bp,dx
		add	bp,dx
		mov	bx,cx
		sar	bx,1			; Shift w/sign fill
		sar	bx,1			; Shift w/sign fill
		js	loc_b_5380		; Jump if sign=1
		;and	bx,7Fh
		db	81h, 0e3h, 7Fh, 0

loc_b_5380:
		and	cl,3
		add	cl,cl
		lodsw				; String [si] to ax
		xchg	dx,ax
loc_b_5387:
		mov	ch,dl
		mov	di,bx
		mov	es,[bp]
loc_b_538E:
		mov	ax,0FF00h
		ror	ax,cl			; Rotate
		or	ax,ds:data_b_8BF1_e[di]
		and	es:[di],ax
		lodsb				; String [si] to al
		xor	ah,ah			; Zero register
		ror	ax,cl			; Rotate
		and	ax,ds:data_b_8AD1_e[di]
		or	es:[di],ax
		inc	di
		dec	ch
		jnz	loc_b_538E		; Jump if not zero
		inc	bp
		inc	bp
		dec	dh
		jnz	loc_b_5387		; Jump if not zero
		retn
sub_b_536D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_53B2	proc	near
		mov	ch,0
		lodsw				; String [si] to ax
		xchg	dx,ax
		mov	bp,53C9h
loc_b_53B9:
		mov	cl,dl
		xor	di,di			; Zero register
		mov	es,[bp]
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		inc	bp
		inc	bp
		dec	dh
		jnz	loc_b_53B9		; Jump if not zero
		retn
sub_b_53B2	endp

		db	 00h,0B8h, 00h,0BAh, 05h,0B8h
		db	 05h,0BAh, 0Ah,0B8h, 0Ah,0BAh
		db	 0Fh,0B8h, 0Fh,0BAh, 14h,0B8h
		db	 14h,0BAh, 19h,0B8h, 19h,0BAh
		db	 1Eh,0B8h, 1Eh,0BAh, 23h,0B8h
		db	 23h,0BAh, 28h,0B8h, 28h,0BAh
		db	 2Dh,0B8h, 2Dh,0BAh, 32h,0B8h
		db	 32h,0BAh, 37h,0B8h, 37h,0BAh
		db	 3Ch,0B8h, 3Ch,0BAh, 41h,0B8h
		db	 41h,0BAh, 46h,0B8h, 46h,0BAh
		db	 4Bh,0B8h, 4Bh,0BAh, 50h,0B8h
		db	 50h,0BAh, 55h,0B8h, 55h,0BAh
		db	 5Ah,0B8h, 5Ah,0BAh, 5Fh,0B8h
		db	 5Fh,0BAh, 64h,0B8h, 64h,0BAh
		db	 69h,0B8h, 69h,0BAh, 6Eh,0B8h
		db	 6Eh,0BAh, 73h,0B8h, 73h,0BAh
		db	 78h,0B8h, 78h,0BAh, 7Dh,0B8h
		db	 7Dh,0BAh, 82h,0B8h, 82h,0BAh
		db	 87h,0B8h, 87h,0BAh, 8Ch,0B8h
		db	 8Ch,0BAh, 91h,0B8h, 91h,0BAh
		db	 96h,0B8h, 96h,0BAh, 9Bh,0B8h
		db	 9Bh,0BAh,0A0h,0B8h,0A0h,0BAh
		db	0A5h,0B8h,0A5h,0BAh,0AAh,0B8h
		db	0AAh,0BAh,0AFh,0B8h,0AFh,0BAh
		db	0B4h,0B8h,0B4h,0BAh,0B9h,0B8h
		db	0B9h,0BAh,0BEh,0B8h,0BEh,0BAh
		db	0C3h,0B8h,0C3h,0BAh,0C8h,0B8h
		db	0C8h,0BAh,0CDh,0B8h,0CDh,0BAh
		db	0D2h,0B8h,0D2h,0BAh,0D7h,0B8h
		db	0D7h,0BAh,0DCh,0B8h,0DCh,0BAh
		db	0E1h,0B8h,0E1h,0BAh,0E6h,0B8h
		db	0E6h,0BAh,0EBh,0B8h,0EBh,0BAh
		db	0F0h,0B8h,0F0h,0BAh,0F5h,0B8h
		db	0F5h,0BAh,0FAh,0B8h,0FAh,0BAh
		db	0FFh,0B8h,0FFh,0BAh, 04h,0B9h
		db	 04h,0BBh, 09h,0B9h, 09h,0BBh
		db	 0Eh,0B9h, 0Eh,0BBh, 13h,0B9h
		db	 13h,0BBh, 18h,0B9h, 18h,0BBh
		db	 1Dh,0B9h, 1Dh,0BBh, 22h,0B9h
		db	 22h,0BBh, 27h,0B9h, 27h,0BBh
		db	 2Ch,0B9h, 2Ch,0BBh, 31h,0B9h
		db	 31h,0BBh, 36h,0B9h, 36h,0BBh
		db	 3Bh,0B9h, 3Bh,0BBh, 40h,0B9h
		db	 40h,0BBh, 45h,0B9h, 45h,0BBh
		db	 4Ah,0B9h, 4Ah,0BBh, 4Fh,0B9h
		db	 4Fh,0BBh, 54h,0B9h, 54h,0BBh
		db	 59h,0B9h, 59h,0BBh, 5Eh,0B9h
		db	 5Eh,0BBh, 63h,0B9h, 63h,0BBh
		db	 68h,0B9h, 68h,0BBh, 6Dh,0B9h
		db	 6Dh,0BBh, 72h,0B9h, 72h,0BBh
		db	 77h,0B9h, 77h,0BBh, 7Ch,0B9h
data_b_54FB	dw	0BB7Ch
data_b_54FD	dw	0B981h
data_b_54FF	dw	0BB81h
		db	 86h,0B9h, 86h,0BBh, 8Bh,0B9h
		db	 8Bh,0BBh, 90h,0B9h, 90h,0BBh
		db	 95h,0B9h, 95h,0BBh, 9Ah,0B9h
		db	 9Ah,0BBh, 9Fh,0B9h, 9Fh,0BBh
		db	0A4h,0B9h,0A4h,0BBh,0A9h,0B9h
		db	0A9h,0BBh,0AEh,0B9h,0AEh,0BBh
		db	0B3h,0B9h,0B3h,0BBh,0B8h,0B9h
		db	0B8h,0BBh,0BDh,0B9h,0BDh,0BBh
		db	0C2h,0B9h,0C2h,0BBh,0C7h,0B9h
		db	0C7h,0BBh,0CCh,0B9h,0CCh,0BBh
		db	0D1h,0B9h,0D1h,0BBh,0D6h,0B9h
		db	0D6h,0BBh,0DBh,0B9h,0DBh,0BBh
		db	0E0h,0B9h,0E0h,0BBh,0E5h,0B9h
		db	0E5h,0BBh,0EAh,0B9h,0EAh,0BBh
		db	0EFh,0B9h,0EFh,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh,0F4h,0B9h,0F4h,0BBh
		db	0F4h,0B9h,0F4h,0BBh,0F4h,0B9h
		db	0F4h,0BBh
		db	7 dup (0)

seg_b		ends



;------------------------------------------------------------  seg_c   ----

seg_c		segment	byte public
		assume cs:seg_c  , ds:seg_c , ss:stack_seg_d

		db	196 dup (0)
data_c_00C4	db	0			; Data table (indexed access)
		db	58 dup (0)
data_c_00FF	db	0			; Data table (indexed access)
		db	850 dup (0)
data_c_0452	dw	0			; Data table (indexed access)
		db	172 dup (0)
		db	0D0h, 58h,0E0h, 68h,0F0h, 78h
		db	 00h,0BEh,0BEh,0BDh,0BDh,0BCh
		db	0BCh,0BCh,0F8h, 80h, 08h, 90h
		db	 18h,0A0h, 28h,0BEh,0BEh,0BEh
		db	0BDh,0BDh,0BCh,0BCh, 20h,0A8h
		db	 30h,0B8h, 40h,0C8h, 50h,0BFh
		db	0BEh,0BEh,0BDh,0BDh,0BCh,0BCh
		db	'4JBBMIKB;JJ'
		db	2
		db	'+;CRJKIK4'
		db	 89h, 8Bh, 8Bh, 89h, 8Ch, 8Ah
		db	 32h,0C3h, 3Ch,0C2h, 07h, 37h
		db	 03h, 4Fh, 07h, 3Dh, 07h, 57h
		db	 06h, 1Ch, 19h, 16h, 17h, 4Ch
		db	 07h, 57h, 04h
		db	'!%N?IOES'
		db	 03h, 36h, 3Ch, 1Ch, 1Ah, 1Dh
		db	 07h, 4Dh, 07h, 52h, 03h, 59h
		db	 21h, 24h, 14h, 12h, 07h, 49h
		db	 36h, 07h, 36h,0EEh, 03h, 59h
		db	 21h, 23h, 19h, 19h
		db	'4JBBMIKB;JJR'
		db	2
		db	'+;CJKIK4:K'
		db	 07h, 34h, 53h, 03h
		db	'<:JLY!!Kr'
		db	 12h, 12h, 4Ch, 07h, 43h, 56h
		db	 03h, 21h, 25h, 14h, 11h, 5Bh
		db	 22h, 27h, 07h, 56h, 02h
		db	';I2BAJI<64<*'
		db	 03h,0EAh, 03h, 8Bh, 8Bh, 8Ch
		db	 8Bh, 8Bh, 8Bh, 8Bh, 8Ch, 8Ch
		db	 8Ah, 53h, 02h, 89h, 8Bh, 8Bh
		db	 89h, 8Ch, 8Ch, 8Ch, 8Bh, 8Bh
		db	 8Ch, 8Ch, 8Bh, 8Ch, 52h, 04h
		db	 8Ch, 8Bh, 89h, 8Ch, 8Bh, 8Ch
		db	 8Bh, 89h, 8Ch, 8Ch, 8Ch, 8Ch
		db	 52h, 04h, 7Dh, 11h, 11h, 11h
		db	 5Fh, 21h, 27h, 07h, 55h, 03h
		db	 5Eh, 21h, 25h, 1Dh, 1Ah, 1Dh
		db	 07h, 05h, 9Eh, 02h, 5Ah, 21h
		db	 21h, 1Dh, 1Bh, 19h, 07h, 05h
		db	 56h, 02h, 07h, 19h, 19h, 19h
		db	 19h, 4Bh, 4Bh, 41h, 49h, 32h
		db	 4Bh, 41h, 07h, 07h, 52h, 05h
		db	 07h, 19h, 19h, 19h, 19h, 4Bh
		db	 4Bh, 41h, 49h, 32h, 4Bh, 41h
		db	 07h, 07h, 56h, 04h, 19h, 19h
		db	 14h, 11h,0A9h, 07h, 07h, 12h
		db	 11h, 07h, 07h, 52h, 04h, 7Ch
		db	 12h, 5Ah, 22h, 22h, 14h, 11h
		db	 07h, 07h, 9Ch, 03h
		db	'BI4B2KI>4>'
		db	 07h, 34h, 35h, 9Ch, 03h, 4Ah
		db	 4Bh, 2Bh,0C4h,0C5h,0C5h, 34h
		db	0C3h, 3Ch,0C3h,0C4h, 07h, 9Bh
		db	 02h, 3Ch, 34h, 2Bh, 34h, 3Ch
		db	 35h,0C6h,0C2h,0C4h, 07h, 33h
		db	 3Ch,0C2h, 9Ch, 07h, 07h, 07h
		db	 07h, 7Dh, 71h, 11h, 11h, 1Ch
		db	 1Ah, 1Ah, 07h, 07h, 9Fh, 04h
		db	 7Ch, 11h, 11h, 12h, 5Ch, 21h
		db	 21h, 1Eh, 19h, 19h, 4Ah, 06h
		db	 07h, 9Fh, 04h, 59h, 21h, 23h
		db	 3Ch, 33h, 07h, 4Bh, 49h, 07h
		db	 03h, 9Ah, 04h, 03h, 72h, 11h
		db	 14h, 05h, 1Ah, 19h, 1Fh, 07h
		db	 07h, 07h,0DBh, 05h,0CFh, 07h
		db	 07h, 07h, 07h, 52h, 05h,0C4h
		db	 4Ah, 4Bh, 42h,0C3h, 33h, 3Ch
		db	 3Dh, 03h, 52h, 02h,0C4h,0C3h
		db	0C3h,0C4h,0C5h, 3Dh,0C5h,0C3h
		db	 3Eh,0C3h,0C2h,0C5h, 3Bh, 2Ah
		db	 54h, 04h, 7Bh, 12h, 11h, 11h
		db	 2Ch, 3Ch, 3Bh, 4Ah, 04h, 4Ah
		db	 3Ah, 43h, 07h, 9Ch, 04h, 6Bh
		db	 21h, 21h, 06h, 21h, 21h, 07h
		db	 07h, 33h, 52h, 03h
		db	'II;J<J3;J,*C+*'
		db	 06h, 52h, 03h, 62h, 21h, 21h
		db	 21h, 06h, 73h, 11h, 11h, 3Fh
		db	0D5h, 4Ah,0D5h, 05h,0D4h, 54h
		db	 04h, 1Bh, 19h, 19h, 04h, 73h
		db	 11h, 11h
data_c_0707	dw	323Bh			; Data table (indexed access)
		db	 46h, 3Bh, 3Ah, 04h, 52h, 03h
		db	 62h, 22h, 22h, 22h, 05h, 3Bh
		db	 4Ah, 3Ah, 4Ah, 49h,0D5h,0D6h
		db	0D5h,0D4h, 4Ah, 9Ch, 05h, 7Bh
		db	 12h, 11h, 11h, 2Ch, 3Ch, 3Bh
		db	 4Ah, 04h, 4Ah, 3Ah, 43h, 07h
		db	 51h, 04h, 81h, 11h, 13h, 11h
		db	 13h, 07h, 19h, 19h, 1Bh, 19h
		db	 07h, 07h, 52h, 8Ch, 89h, 8Bh
		db	 8Ch, 8Bh, 8Bh, 89h, 8Bh, 8Ch
		db	 8Bh, 89h, 8Ch, 8Ch, 8Bh, 89h
		db	 8Ch, 54h, 04h, 89h, 8Bh, 8Ch
		db	 8Bh, 8Bh, 8Ch, 8Bh, 8Ch, 8Bh
		db	 8Ch, 8Bh, 8Bh, 89h, 8Bh, 8Ch
		db	 8Ch, 52h, 04h, 6Ah, 21h, 21h
		db	 21h, 23h, 06h, 1Ah, 19h, 19h
		db	 1Bh, 04h, 3Bh, 2Bh, 49h, 4Bh
		db	 07h, 91h, 03h, 1Ah, 19h, 19h
		db	 1Ch, 7Bh, 11h, 11h, 14h, 04h
		db	 49h, 49h, 3Ah, 4Ah, 41h, 3Bh
		db	 04h, 54h, 49h, 3Ah, 4Bh, 3Ah
		db	0C9h, 33h, 3Fh, 07h, 3Dh, 07h
		db	 07h, 54h, 04h
		db	'ILJ:KIL='
		db	 8Bh, 89h, 8Ch, 8Bh, 89h, 8Ch
		db	 8Ch, 04h, 53h,0C2h, 3Bh, 49h
		db	 4Bh, 32h, 4Ah, 4Ch,0C2h, 3Ah
		db	 4Ah,0D5h,0D4h, 4Ch,0D5h,0D2h
		db	 02h
		db	'RKIK:IJi!!!$'
		db	 05h, 19h, 19h, 1Fh, 4Bh, 4Eh
		db	 4Ah, 91h, 49h, 4Bh, 3Ah,0C9h
		db	 2Fh, 05h, 06h, 07h, 06h, 54h
		db	 8Bh, 89h, 8Ch, 89h, 8Bh, 89h
		db	 8Ch, 49h, 4Bh, 8Ch, 8Ch, 4Bh
		db	 8Ch, 8Bh, 89h, 8Bh, 89h, 04h
		db	 52h, 6Ch, 21h, 21h, 21h, 27h
		db	 71h, 11h, 16h, 49h, 4Bh, 3Ah
		db	 4Fh, 54h,0D2h, 4Dh,0D4h,0D6h
		db	 4Bh, 4Ah, 49h, 4Ah, 4Ah, 4Bh
		db	0D2h
loc_c_07FA:
		dec	si
		ror	word ptr [bp+si+3Ch],cl	; Rotate
		dec	dx
		dec	sp
		push	bx
		imul	sp,word ptr [bx+di],21h	; reg = data * value
		and	[bx],sp
		jns	$+13h			; Jump if not sign
		adc	[bx],dx
		dec	dx
		dec	bp
		dec	dx
		dec	cx
		dec	bp
		push	dx
		dec	bx
		dec	dx
		dec	bx
		cmp	cx,[bp+di-3Eh]
		cmp	cl,[bp+di+3Ch]
		db	0D6h, 4Ah,0C2h,0C2h, 3Ch,0C2h
		db	 4Bh,0D5h,0DCh,0E7h, 00h
		db	28 dup (0)
data_c_0840	db	0			; Data table (indexed access)
		db	15 dup (0)
data_c_0850	db	0
		db	34 dup (0)
		db	8 dup (1)
		db	 06h, 08h, 0Ch, 0Dh, 0Dh, 0Dh
		db	 07h, 02h, 01h, 00h, 00h, 01h
		db	 00h, 00h, 03h, 00h, 0Eh, 0Fh
		db	 0Dh, 0Dh, 0Dh, 0Dh, 04h, 05h
		db	16 dup (0)
		db	2, 2, 2, 2, 2, 3
		db	4, 6, 6, 6, 5, 6
		db	6, 6, 6, 1, 0, 0
		db	0, 7, 0, 0, 0, 5
		db	17 dup (0)
		db	1, 3, 3, 0
		db	39 dup (0)
		db	 8Eh, 8Bh, 8Bh, 96h, 96h, 03h
		db	 00h, 00h, 06h, 06h, 07h, 11h
		db	 16h, 0Fh, 0Fh
		db	9 dup (0)
		db	 80h, 00h, 80h, 01h, 00h, 01h
		db	 00h, 01h, 00h, 01h, 00h, 01h
		db	 00h, 01h, 20h, 01h, 20h, 01h
		db	 20h, 80h, 88h, 90h, 98h,0A0h
		db	0A8h,0B0h,0B8h,0C0h,0C8h,0D0h
		db	0D8h,0E0h,0E8h,0F0h,0F8h,0FEh
		db	0FDh,0FBh,0F7h,0EFh,0DFh,0BFh
		db	 00h, 00h, 07h, 0Eh, 15h, 1Ch
		db	'#*18?FMT[bipw~'
		db	 85h, 8Ch, 01h, 02h, 04h, 08h
		db	 10h
		db	' @H)0P)M&J#H)0P)M&J#H'
		db	0, 4, 3, 3, 1, 1
		db	1, 1, 1, 1, 4, 3
		db	3
		db	7 dup (1)
		db	0B3h,0B3h,0BFh,0B3h,0B3h, 9Eh
		db	 8Ch, 00h, 9Fh,0B3h,0B3h, 9Fh
		db	0B3h,0B3h, 9Fh, 00h, 9Eh,0BFh
		db	0B3h, 83h,0B3h,0BFh, 9Eh, 00h
		db	 9Fh,0BFh,0B3h,0B3h,0B3h,0BFh
		db	 9Fh, 00h,0BFh,0BFh, 83h, 9Fh
		db	 83h,0BFh,0BFh, 00h, 83h, 83h
		db	 9Fh, 9Fh, 83h,0BFh,0BFh, 00h
		db	 9Eh,0BFh,0B3h,0BBh, 83h,0BFh
		db	 9Eh, 00h,0B3h,0B3h,0BFh,0BFh
		db	0B3h,0B3h,0B3h, 00h,0BFh,0BFh
		db	 8Ch, 8Ch, 8Ch,0BFh,0BFh, 00h
		db	 8Eh, 9Fh, 9Bh, 98h, 98h, 98h
		db	 98h, 00h,0B3h,0BBh, 9Fh, 8Fh
		db	 9Fh,0BBh,0B3h, 00h,0BFh,0BFh
		db	 83h, 83h, 83h, 83h, 83h, 00h
		db	0B3h,0B3h,0B3h,0BFh,0BFh,0B3h
		db	0A1h, 00h,0B3h,0BBh,0BFh,0BFh
		db	0BFh,0B7h,0B3h, 00h, 9Eh,0BFh
		db	0B3h,0B3h,0B3h,0BFh, 9Eh, 00h
		db	 83h, 83h, 9Fh,0BFh,0B3h,0BFh
		db	 9Fh, 00h,0AEh, 9Fh,0BBh,0B7h
		db	0B3h,0BFh, 9Eh, 00h,0B3h,0BBh
		db	 9Fh,0BFh,0B3h,0BFh, 9Fh, 00h
		db	 9Eh,0BFh,0B8h, 9Eh, 87h,0BFh
		db	 9Eh, 00h, 8Ch, 8Ch, 8Ch, 8Ch
		db	 8Ch,0BFh,0BFh, 00h, 9Eh,0BFh
		db	0B3h,0B3h,0B3h,0B3h,0B3h, 00h
		db	 8Ch, 9Eh, 9Eh,0B3h,0B3h,0B3h
		db	0B3h, 00h,0A1h,0B3h,0BFh,0BFh
		db	0B3h,0B3h,0B3h, 00h,0B3h,0B3h
		db	 9Eh, 8Ch, 9Eh,0B3h,0B3h, 00h
		db	 8Ch, 8Ch, 8Ch, 8Ch, 9Eh,0B3h
		db	0B3h, 00h,0BFh,0BFh, 8Eh, 9Ch
		db	0B8h,0BFh,0BFh, 00h,0BCh,0BCh
		db	 8Ch, 8Ch, 8Ch,0BCh,0BCh, 00h
		db	0A0h,0B0h, 98h, 8Ch, 86h, 83h
		db	 81h, 00h, 8Fh, 8Fh, 8Ch, 8Ch
		db	 8Ch, 8Fh, 8Fh, 00h, 80h,0A1h
		db	0B3h, 9Eh, 8Ch, 80h, 80h, 00h
		db	0BFh,0BFh, 80h, 80h, 80h, 80h
		db	 80h, 00h
		db	7 dup (80h)
		db	 00h, 83h, 83h, 88h, 9Ch,0B8h
		db	0F0h,0E0h, 00h, 80h, 80h, 80h
		db	 80h,0B6h,0B6h,0B6h, 00h, 9Bh
		db	0BFh,0BFh, 9Bh,0BFh,0BFh, 9Bh
		db	 00h, 8Ch, 9Fh,0ACh, 9Eh, 8Dh
		db	0BEh, 8Ch, 00h,0B1h,0B3h, 86h
		db	 8Ch, 98h,0B3h,0A3h, 00h,0AEh
		db	 9Bh,0ABh, 8Eh, 9Bh, 9Bh, 8Eh
		db	 00h, 80h, 80h, 80h, 84h, 88h
		db	 8Ch, 8Ch, 00h, 98h, 9Ch, 8Eh
		db	 86h, 8Eh, 9Ch, 98h, 00h, 86h
		db	 8Eh, 9Ch, 98h, 9Ch, 8Eh, 86h
		db	 00h, 8Ch,0BFh, 9Eh, 8Ch, 9Eh
		db	0BFh, 8Ch, 00h, 80h, 8Ch, 8Ch
		db	0BFh,0BFh, 8Ch, 8Ch, 00h, 84h
		db	 88h, 8Ch, 8Ch, 80h, 80h, 80h
		db	 00h, 80h, 80h, 80h,0BFh,0BFh
		db	 80h, 80h, 00h, 8Ch, 8Ch, 80h
		db	 80h, 80h, 80h, 80h, 00h, 81h
		db	 83h, 86h, 8Ch, 98h,0B0h,0A0h
		db	 00h,0BFh,0B3h,0B3h,0B3h,0B3h
		db	0B3h,0BFh, 00h, 8Ch, 8Ch, 8Ch
		db	 8Ch, 8Ch, 8Ch, 8Ch, 00h,0BFh
		db	 83h, 83h,0BFh,0B0h,0B0h,0BFh
		db	 00h,0BFh,0B0h,0B0h,0BFh,0B0h
		db	0B0h,0BFh, 00h, 98h, 98h, 98h
		db	0BFh, 9Bh, 9Bh, 9Bh, 00h,0BFh
		db	0B0h,0B0h,0BFh, 83h, 83h,0BFh
		db	 00h,0BFh,0B3h,0B3h,0BFh, 83h
		db	 83h, 83h, 00h,0B0h,0B0h,0B0h
		db	0B0h,0B3h,0B3h,0BFh, 00h,0BFh
		db	0B3h,0B3h,0BFh,0B3h,0B3h,0BFh
		db	 00h,0BFh,0B0h,0B0h,0BFh,0B3h
		db	0B3h,0BFh, 00h, 80h, 8Ch, 8Ch
		db	 80h, 8Ch, 8Ch, 80h, 00h, 84h
		db	 88h, 8Ch, 8Ch, 80h, 8Ch, 8Ch
		db	 00h, 98h, 8Ch, 86h, 83h, 86h
		db	 8Ch, 98h, 00h, 80h,0BFh,0BFh
		db	 80h,0BFh,0BFh, 80h, 00h, 86h
		db	 8Ch, 98h,0B0h, 98h, 8Ch, 86h
		db	 00h, 8Ch, 80h, 8Ch, 98h,0BBh
		db	0BFh, 9Eh, 00h
		db	8, 'P<', 8, '`0', 8, 'x(', 8, '<-'
		db	8, 'H$'
		db	8, 'Z'
		db	1Eh
		db	8, '6(', 8, '@ ', 8, 'P', 1Bh, 8, '@'
		db	1Eh
		db	8, '6 ', 8, 'Z(', 8, 'P<', 8, '`0'
		db	8, 'x(', 8, '<-', 8, 'H$'
		db	8, 'Z'
		db	1Eh
		db	8, '6(', 8, '@ ', 8, 'P', 1Bh, 8, 'x'
		db	'<'
		db	 00h, 85h, 6Fh, 00h, 00h
		db	8, 'x<', 8, 'P(', 8, 'x'
		db	 1Eh, 08h, 50h, 18h, 08h, 3Ch
		db	 1Eh, 08h, 30h, 28h, 08h, 50h
		db	 16h, 08h, 3Ch, 1Eh, 08h, 2Dh
		db	 28h, 08h, 50h, 14h
		db	8, '6', 1Bh, 8, '0(', 8, 'x<', 8, 'P'
		db	'(', 8, 'x'
		db	 1Eh, 08h, 50h, 18h, 08h, 3Ch
		db	 1Eh
		db	 08h, 30h, 28h, 08h
loc_c_0BF3:
		dec	ax
		push	ds
		or	[bx+si+20h],al
		or	[si],bh
		and	al,10h
		xor	[bx+si],ch
		or	[bx+si],al
		add	[bx+si],cl
;*		js	loc_c_0C40		;*Jump if sign=1
		db	 78h, 3Ch		;  Fixup - byte match
		or	[bx+si+28h],dl
		or	[bx+si+1Eh],bh
		or	[bx+si+18h],dl
		or	[si],bh
		push	ds
		or	[bx+si],dh
		sub	[bx+si],cl
		push	ax
		push	ss
		or	[si],bh
		push	ds
		or	[di],ch
		sub	[bx+si],cl
		push	ax
		adc	al,8
		sbb	cx,ss:[bx+si]
		xor	[bx+si],ch
		or	[bx+si+3Ch],bh
		or	[bx+si+28h],dl
		or	[bx+si+1Eh],bh
		or	[bx+si+18h],dl
		or	[si],bh
		push	ds
		or	[bx+si],dh
		sub	[bx+si],cl
		mov	al,data_c_0850
		nop
		dec	ax
		or	data_c_0840[bx+si],al
                           lock	cmp	al,0
		add	[bx+si],al
		xlat				; al=[al+[bx]] table
		push	75h
		mov	si,[di+6Ah]
		xlat				; al=[al+[bx]] table
		push	75h
		mov	bx,data_c_8B95[si]
		xlat				; al=[al+[bx]] table
		push	75h
		mov	si,[di+6Ah]
		xlat				; al=[al+[bx]] table
		push	75h
		mov	bx,data_c_8B95[si]
		pushf				; Push flags
		dec	si
		pop	ax
		push	58h
		dec	si
		pushf				; Push flags
		dec	si
		pop	ax
		push	75h
;*		jo	loc_c_0CD7		;*Jump if overflow=1
		db	 70h, 6Ah		;  Fixup - byte match
		xlat				; al=[al+[bx]] table
		push	75h
		mov	si,[di+6Ah]
		xlat				; al=[al+[bx]] table
		push	75h
		mov	bx,data_c_8B95[si]
		mov	ax,[di+4Dh]
		pop	bx
		dec	bp
		inc	bp
		pushf				; Push flags
		dec	si
		pop	ax
		push	75h
;*		jo	loc_c_0CF1		;*Jump if overflow=1
		db	 70h, 6Ah		;  Fixup - byte match
		xlat				; al=[al+[bx]] table
		push	75h
		mov	si,[di+6Ah]
		xlat				; al=[al+[bx]] table
		stosb				; Store al to es:[di]
		mov	al,byte ptr data_c_8B95
		add	[si],al
		add	ax,[bp+di]
		add	al,[bp+si]
		add	al,[si]
		add	ax,[bp+di]
		add	al,[bx+di]
		add	[bp+si],ax
		add	al,3
		add	ax,[bp+si]
		add	al,[bp+si]
		add	al,3
		add	ax,[bp+si]
		add	[bx+di],ax
		add	al,[si]
		add	ax,[bp+di]
		add	al,[bp+si]
		add	al,[si]
		add	ax,[bp+di]
		add	al,[bx+di]
		add	[bp+si],ax
		add	al,3
		add	ax,[bp+si]
		add	al,[bp+si]
		add	al,3
		add	ax,[bp+si]
		add	[bx+di],ax
		add	al,[si]
		add	ax,[bp+di]
		add	al,[bp+si]
		add	al,[si]
		add	ax,[bp+di]
		add	al,[bx+di]
		add	[bp+si],ax
		add	al,3
		add	ax,[bp+si]
		add	al,[bp+si]
		add	al,4
		add	ax,[bp+di]
		add	al,[bx+di]
		add	al,[bx+si]
		db	0, 0, 0, 0, 1
		db	9 dup (1)
		db	10 dup (2)
		db	10 dup (3)
		db	10 dup (4)
		db	10 dup (5)
		db	10 dup (6)
		db	0, 0, 0, 0, 0, 3
		db	9 dup (3)
		db	10 dup (6)
		db	10 dup (9)
		db	10 dup (0Ch)
		db	10 dup (0Fh)
		db	10 dup (12h)
		db	 18h,0A0h, 06h,0A0h, 06h,0A0h
		db	 06h,0A0h, 06h,0A0h, 06h,0A0h
		db	 07h,0C1h, 10h,0A0h, 06h,0A0h
		db	 06h,0A0h, 06h,0A0h, 06h,0A0h
		db	 14h,0C1h, 13h,0A0h, 02h,0A0h
		db	 02h,0A0h, 14h,0C1h, 16h,0C1h
		db	 11h,0A0h, 1Bh,0A0h, 0Ch,0A0h
		db	 10h,0A0h, 06h,0A0h, 0Eh,0C1h
		db	 13h,0C1h, 13h,0C1h, 13h,0C1h
		db	 15h,0C1h, 11h,0A0h, 01h,0C1h
		db	 1Ah,0A0h, 01h,0C1h, 13h,0A0h
		db	 1Ah,0FFh
		db	0Ah, 'H6', 0Ah, '6+', 0Ah, '0$'
		db	0Ah, '$'
		db	 1Eh, 0Ah, 00h, 00h, 0Ah, 24h
		db	 1Eh
		db	0Ah, '( ', 0Ah, '0$'
		db	0Ah, 'H<', 0Ah, '$'
		db	 1Eh, 0Ah, 44h, 39h, 0Ah, 22h
		db	 1Ch, 0Ah, 48h, 36h, 00h, 00h
		db	 89h, 8Dh, 91h, 95h, 9Dh,0A1h
		db	0A5h,0A9h,0AFh,0B5h,0B9h,0BDh
		db	0C1h,0C5h,0CDh,0D1h,0D5h,0D9h
		db	0DFh,0E5h,0E9h,0EDh,0F1h,0F5h
		db	0F7h,0F9h
		db	24 dup (0)
		db	 01h, 05h, 08h, 10h
		db	11 dup (0)
		db	7 dup (1)
		db	7 dup (2)
		db	7 dup (3)
		db	7 dup (4)
		db	7 dup (5)
		db	7 dup (6)
		db	7 dup (7)
		db	7 dup (8)
		db	7 dup (9)
		db	7 dup (0Ah)
		db	7 dup (0Bh)
		db	7 dup (0Ch)
		db	7 dup (0Dh)
		db	7 dup (0Eh)
		db	7 dup (0Fh)
		db	7 dup (10h)
		db	7 dup (11h)
		db	7 dup (12h)
		db	7 dup (13h)
		db	7 dup (14h)
		db	7 dup (15h)
		db	7 dup (16h)
		db	7 dup (17h)
		db	7 dup (18h)
		db	7 dup (19h)
		db	7 dup (1Ah)
		db	7 dup (1Bh)
		db	7 dup (1Ch)
		db	7 dup (1Dh)
		db	7 dup (1Eh)
		db	7 dup (1Fh)
		db	'       !!!!!!!"""""""#'
data_c_0F00	dw	2323h, 2323h		; Data table (indexed access)
		db	 23h, 23h, 24h, 24h, 24h, 24h
		db	 67h,0B3h,0C9h, 09h,0F0h, 08h
		db	0C9h, 0Ah,0F0h, 04h,0C9h, 02h
		db	0B0h, 5Ah,0FEh, 6Bh,0B3h,0FEh
		db	 6Bh,0B3h,0BDh, 6Bh,0B3h, 29h
		db	0FEh, 9Dh, 6Bh,0B3h,0BDh, 6Fh
		db	0B3h, 18h, 69h, 04h, 9Dh, 6Fh
		db	0B3h,0C9h, 8Ch, 90h, 5Dh,0BDh
		db	 67h,0B3h,0C9h, 0Ah,0D0h, 2Ah
		db	 8Ah, 48h,0A9h, 01h, 85h, 85h
		db	0A9h, 14h, 20h,0EBh, 16h,0A9h
		db	 3Ch, 85h, 46h,0A9h, 00h, 85h
		db	 85h, 8Ah,0A8h, 68h,0AAh,0BDh
		db	 6Bh,0B3h, 38h,0E9h, 22h, 29h
		db	0FCh, 99h,0C2h,0B3h,0A9h, 0Bh
		db	 9Dh, 67h,0B3h, 4Ch, 5Fh, 20h
		db	0A9h, 01h, 9Dh, 67h,0B3h,0BDh
		db	 6Bh,0B3h, 38h,0E9h, 0Eh, 9Dh
		db	 6Bh,0B3h,0FEh, 67h,0B3h,0A9h
		db	 89h, 9Dh, 6Fh,0B3h,0BDh, 67h
		db	0B3h,0C9h, 06h,0F0h, 07h,0C9h
		db	 0Eh,0F0h, 03h, 4Ch, 86h, 20h
		db	0A9h, 00h, 9Dh, 67h,0B3h, 4Ch
		db	0E8h, 1Fh,0BDh, 67h,0B3h,0C9h
		db	 0Ah,0F0h, 07h,0C9h, 09h,0F0h
		db	 03h, 4Ch,0BCh, 20h,0BDh, 6Fh
		db	0B3h, 18h, 69h, 05h,0C5h, 58h
		db	 90h, 1Eh,0BDh, 6Bh,0B3h, 18h
		db	 69h, 04h,0C5h, 57h, 90h, 14h
		db	0A5h, 57h, 18h, 69h, 24h,0DDh
		db	 6Bh,0B3h, 90h, 0Ah,0A9h, 01h
		db	 85h, 70h,0A9h, 00h, 9Dh, 67h
		db	0B3h, 60h,0BDh, 67h,0B3h, 48h
		db	0BCh, 6Fh,0B3h,0BDh, 6Bh,0B3h
		db	0AAh, 68h, 20h, 7Eh, 3Dh,0A6h
		db	 50h, 4Ch,0E8h, 1Fh,0A2h, 03h
		db	0BDh, 2Bh,0B3h,0F0h, 22h, 30h
		db	 20h,0C9h, 0Eh,0B0h, 1Ch, 38h
		db	0E9h, 08h,0A8h,0B9h, 73h,0B3h
		db	 9Dh, 93h,0B3h,0B9h, 7Bh,0B3h
		db	 9Dh, 97h,0B3h,0B9h, 83h,0B3h
		db	 9Dh, 9Bh,0B3h,0B9h, 8Bh,0B3h
		db	 9Dh, 9Fh,0B3h,0CAh, 10h,0D6h
		db	0A0h, 03h,0B9h
		db	'+qponmlkjklmnopqrsrqponmlklmlkji'
		db	'hgfedefedcdefghijklmlmnopqrqponm'
		db	'lmnmlkjihgfedcdefghihgfefghijklm'
		db	'nopqrstutsrqponmlklmnopqrstuvwxy'
		db	'z{||{zyxwvutsrqpoo   '
		db	 0Fh, 00h
		db	'DIRC    '
		db	 10h, 00h
		db	'BUFAD   '
		db	 11h, 00h
		db	'B1FLAG  '
		db	 12h, 00h
		db	'JUMPFL  '
		db	 13h, 00h
		db	'GRAVH   '
		db	 14h, 00h
		db	'GRAVL   '
		db	 15h, 00h
		db	'XNODRAW '
		db	 16h, 00h
		db	'ANODRAW '
		db	 17h, 00h
		db	'YNODRAW '
		db	 18h, 00h
		db	'BUL2ESN '
		db	 19h, 00h, 42h, 55h, 4Ch, 32h
		db	 58h, 20h, 02h, 04h, 06h, 08h
		db	 0Ah, 0Ch, 0Eh, 02h, 04h, 06h
		db	 08h, 0Ah, 0Ch, 0Eh, 02h, 04h
		db	 06h, 08h, 0Ah, 0Ch, 0Eh, 02h
		db	 04h, 06h, 08h, 0Ah, 0Ch, 0Eh
		db	 02h, 04h, 06h, 08h, 0Ah, 0Ch
		db	 0Eh, 02h, 04h, 06h, 08h, 0Ah
		db	 0Ch, 0Eh, 02h, 04h, 06h, 08h
		db	 0Ah, 0Ch, 0Eh, 02h, 04h, 06h
		db	 08h, 0Ah, 0Ch, 0Eh, 02h, 04h
		db	 06h, 08h, 0Ah, 0Ch, 0Eh, 02h
		db	 04h, 06h, 08h, 0Ah, 0Ch, 0Eh
		db	 02h, 04h, 06h, 08h, 0Ah, 0Ch
		db	 0Eh, 02h, 04h, 06h, 08h, 0Ah
		db	 0Ch, 0Eh, 02h, 04h, 06h, 08h
		db	 0Ah, 0Ch, 0Eh, 02h, 04h, 06h
		db	 08h, 0Ah, 0Ch, 0Eh, 02h, 04h
		db	 06h, 08h, 0Ah, 0Ch, 0Eh, 02h
		db	 04h, 06h, 08h, 0Ah, 0Ch, 0Eh
		db	 02h, 04h, 06h, 08h, 0Ah, 0Ch
		db	 0Eh, 02h, 04h, 06h, 08h, 0Ah
		db	 0Ch, 0Eh, 02h, 04h, 06h, 08h
		db	 0Ah, 0Ch, 0Eh, 02h, 04h, 06h
		db	 08h, 0Ah, 0Ch, 0Eh, 02h, 04h
		db	 06h, 08h, 0Ah, 0Ch, 0Eh, 02h
		db	 04h, 06h, 08h, 0Ah, 0Ch, 0Eh
		db	 02h, 04h, 06h, 08h, 0Ah, 0Ch
		db	 0Eh, 02h, 04h, 06h, 08h, 0Ah
		db	 0Ch, 0Eh, 02h, 04h, 06h, 08h
		db	 0Ah, 0Ch, 0Eh, 02h, 04h, 06h
		db	 08h, 0Ah, 0Ch, 0Eh, 02h, 04h
		db	 06h, 08h, 0Ah, 0Ch, 0Eh, 02h
		db	 04h, 06h, 08h, 0Ah, 0Ch, 0Eh
		db	 02h, 04h, 06h, 08h, 0Ah, 0Ch
		db	 0Eh, 02h, 04h, 06h, 08h, 0Ah
		db	 0Ch, 0Eh, 02h, 04h, 06h, 08h
		db	 0Ah, 0Ch, 0Eh, 02h, 04h, 06h
		db	 08h, 0Ah, 0Ch, 0Eh, 02h, 04h
		db	 06h, 08h, 0Ah, 0Ch, 0Eh, 02h
		db	 04h, 06h, 08h, 0Ah, 0Ch, 0Eh
		db	 02h, 04h, 06h, 08h, 0Ah, 0Ch
		db	 0Eh, 02h, 04h, 06h, 08h, 0Ah
		db	 0Ch, 0Eh, 02h, 04h, 06h, 08h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0E6h, 12h, 24h, 13h,0F8h, 13h
		db	 1Eh, 14h, 2Ch, 14h,0ACh, 14h
		db	 2Ch, 15h,0ACh, 15h, 2Ch, 16h
		db	0ACh, 16h, 2Ch, 17h,0ACh, 17h
		db	 2Ch, 18h, 88h, 18h,0DBh, 18h
		db	 31h, 19h,0BAh, 19h, 72h, 1Ah
		db	 88h, 1Ah, 9Eh, 1Ah,0F8h, 1Ah
		db	0B0h, 1Bh, 08h, 1Dh, 92h, 1Fh
		db	 1Ch, 22h, 6Fh, 22h,0EFh, 22h
		db	 6Fh, 23h, 41h, 24h, 13h, 25h
		db	0E5h, 25h,0B7h, 26h, 89h, 27h
		db	 5Bh, 28h, 2Dh, 29h, 5Fh, 29h
		db	 91h, 29h, 9Fh, 29h, 23h, 2Ah
		db	0A7h, 2Ah,0D3h, 2Ah,0FFh, 2Ah
		db	 2Bh, 2Bh, 57h, 2Bh, 8Ah, 2Bh
		db	 9Ah, 2Bh,0AAh, 2Bh,0BAh, 2Bh
		db	0CAh, 2Bh,0DAh, 2Bh,0EAh, 2Bh
		db	0FAh, 2Bh, 0Ah, 2Ch, 1Ah
		db	',*,:,J,Z,j,z,'
		db	 8Ah, 2Ch, 9Ah, 2Ch,0AAh, 2Ch
		db	0BAh, 2Ch,0CAh, 2Ch,0DAh, 2Ch
		db	0EAh, 2Ch,0FAh, 2Ch, 0Ah, 2Dh
		db	 1Ah
		db	'-*-:-J-Z-j-z-'
		db	 8Ah, 2Dh, 9Ah, 2Dh,0AAh, 2Dh
		db	0BAh, 2Dh,0CAh, 2Dh,0DAh, 2Dh
		db	0EAh, 2Dh,0FAh, 2Dh, 0Ah, 2Eh
		db	 1Ah
		db	'.*.:.J.Z.j.z.'
		db	 8Ah, 2Eh, 9Ah, 2Eh,0AAh, 2Eh
		db	0BAh, 2Eh,0CAh, 2Eh,0DAh, 2Eh
		db	0EAh, 2Eh,0FAh, 2Eh, 0Ah, 2Fh
		db	 1Ah
		db	'/*/:/J/Z/j/'
		db	 06h, 0Ah, 03h,0FCh, 00h, 00h
		db	 00h, 00h, 3Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 3Fh, 0Fh,0C0h, 00h
		db	 00h, 00h,0FCh, 03h,0F0h, 00h
		db	 00h, 00h,0F0h,0F0h,0F0h, 00h
		db	 00h, 00h,0F0h,0F0h,0F0h, 00h
		db	 00h, 00h,0FCh, 03h,0F0h, 00h
		db	 00h, 00h, 3Fh, 0Fh,0C0h, 00h
		db	 00h, 00h, 3Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 03h,0FCh, 00h, 00h
		db	 00h, 00h, 0Eh, 0Fh, 00h, 00h
		db	 0Ch, 00h, 00h, 00h, 7Fh,0FFh
		db	0FFh,0F6h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AEh, 80h, 00h, 01h
		db	0FFh,0FFh,0FFh,0AAh, 80h, 00h
		db	 00h, 00h, 00h, 00h,0AEh, 80h
		db	 1Fh,0FFh,0FFh,0FFh,0FFh,0D5h
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 0Ch, 00h, 3Dh, 7Fh,0F0h, 00h
		db	 00h,0FFh,0E8h, 00h, 00h, 00h
		db	 00h, 00h, 08h, 00h, 75h, 7Ah
		db	0E0h, 00h

locloop_c_1366:
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		jp	$+2			; delay for I/O
		db	 00h, 00h, 00h, 00h,0FBh,0C7h
		db	0F5h, 75h, 40h, 00h, 03h, 80h
		db	 1Ah, 00h, 00h, 00h, 01h,0FEh
		db	0FBh,0C7h, 75h,0FAh,0C0h, 00h
		db	 07h, 00h, 1Bh, 80h, 00h, 00h
		db	 03h,0FEh,0AEh, 87h, 77h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FBh, 80h
		db	 00h, 00h, 07h,0FEh,0AEh,0FFh
		db	 77h,0FFh,0FFh,0FEh,0AAh,0AAh
		db	0ABh, 00h, 00h, 00h, 0Fh, 57h
		db	0C0h,0FFh,0F7h,0FFh,0FFh,0F5h
		db	 5Ah,0AAh,0B6h, 00h, 00h, 00h
		db	 3Dh, 55h, 55h, 55h, 55h, 57h
		db	0FFh,0FFh, 57h,0FDh, 5Ch, 00h
		db	 00h, 00h,0DDh, 55h, 55h, 55h
		db	 55h, 5Fh,0FFh,0FFh, 7Fh,0FFh
		db	0FFh, 00h, 00h, 00h,0DDh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FDh, 55h
		db	 7Fh,0FFh,0FFh, 00h, 00h, 00h
		db	0DDh
		db	8 dup (55h)
		db	 5Eh, 00h, 00h, 00h, 00h, 1Fh
		db	8 dup (0FFh)
		db	0F8h, 00h, 00h, 00h, 00h, 06h
		db	 06h, 01h, 80h, 00h, 00h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 00h
		db	 00h, 07h,0E0h, 00h, 00h, 00h
		db	 00h, 07h,0E0h, 00h, 00h, 00h
		db	 00h, 0Bh,0D0h, 00h, 00h, 00h
		db	 00h, 0Bh,0D0h, 00h, 00h, 00h
		db	 00h, 04h, 03h, 3Fh,0C0h, 00h
		db	 00h,0FFh,0F0h, 00h, 00h, 3Fh
		db	0C0h, 00h, 00h, 09h, 0Eh, 00h
		db	 00h
		db	36 dup (0)
		db	 02h,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 2Bh,0FAh
		db	7 dup (0)
		db	 3Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 2Bh,0FAh
		db	7 dup (0)
		db	 02h,0A0h, 00h, 00h
		db	39 dup (0)
		db	 09h, 0Eh, 00h, 00h
		db	27 dup (0)
		db	 0Ah,0A0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 2Ah,0AAh
		db	7 dup (0)
		db	0ABh,0FAh, 80h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BFh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0BFh,0FFh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0ABh,0FAh, 80h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 2Ah,0AAh
		db	7 dup (0)
		db	 02h,0A0h, 00h, 00h
		db	30 dup (0)
		db	 09h, 0Eh, 00h, 00h
		db	9 dup (0)
		db	 2Ah,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0AAh,0AAh, 80h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0AAh,0AAh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0ABh,0FAh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0BFh,0FFh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BFh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0BFh,0FFh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BFh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0ABh,0FAh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0AAh,0AAh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh, 80h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 2Ah,0AAh
		db	14 dup (0)
		db	 09h, 0Eh, 00h, 00h
		db	9 dup (0)
		db	 2Ah,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0AAh,0AAh, 80h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0ABh,0FAh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0AFh,0FEh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0BFh,0FFh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BFh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0BFh,0FFh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BFh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0AFh,0FEh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0ABh,0FAh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh, 80h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 2Ah,0AAh
		db	14 dup (0)
		db	 09h, 0Eh, 03h,0FCh, 03h,0FCh
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	0FFh, 0Fh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 0Fh, 0Fh, 0Fh, 0Fh
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	 3Fh,0FFh, 3Fh, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh, 0Fh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 03h
		db	0FCh, 03h,0FCh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Eh, 0Ch, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 03h,0FCh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 0Fh
		db	7 dup (0)
		db	 0Fh, 3Fh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0FCh
		db	15 dup (0)
		db	 09h, 0Eh, 03h,0FCh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 0Fh
		db	7 dup (0)
		db	 0Fh, 3Fh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0FFh,0C3h
		db	0FCh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 30h, 3Fh,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 34h, 03h
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	 03h,0FCh, 3Fh, 3Fh, 00h, 00h
		db	 00h, 00h, 00h, 0Fh,0FFh,0C3h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 0Fh, 03h,0FCh, 00h, 00h
		db	 00h, 00h, 00h, 0Fh
		db	3Fh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0FCh
		db	7 dup (0)
		db	 09h, 0Eh, 00h, 03h,0FCh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 0Fh
		db	7 dup (0)
		db	 0Fh, 3Fh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0FCh
		db	7 dup (0)
		db	 0Ch, 0Ch, 00h, 00h, 00h, 00h
		db	 00h, 00h, 03h,0FCh, 03h,0FCh
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	0FFh, 0Fh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 0Fh, 0Fh,0FFh, 0Fh
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	 3Fh, 0Fh, 3Fh, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh, 0Fh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 03h
		db	0FCh, 03h,0FCh
		db	14 dup (0)
		db	 09h, 0Eh, 00h, 00h, 0Fh,0F0h
		db	7 dup (0)
		db	 3Fh,0FCh
		db	7 dup (0)
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	 3Ch,0FCh
		db	7 dup (0)
		db	 3Fh,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 03h,0FCh, 3Fh,0F0h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0FFh
		db	0C0h,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh, 0Fh, 00h,0F0h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh, 3Fh
		db	0C3h,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 0Fh,0FCh, 3Fh,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 03h,0FCh
		db	 0Fh, 0Fh
		db	7 dup (0)
		db	 0Fh, 3Fh
		db	7 dup (0)
		db	 0Fh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0FCh, 00h
		db	 00h, 00h, 00h, 00h, 09h, 0Ah
		db	 00h
		db	28 dup (0)
		db	0FFh,0FFh,0C0h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	0FEh,0AFh,0FFh,0C0h, 00h, 00h
		db	 00h, 02h,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 00h,0FFh
		db	0FAh,0ABh,0FFh,0C0h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0C0h, 00h, 00h, 00h
		db	 00h, 09h, 09h, 00h, 00h, 05h
		db	54h
		db	7 dup (0)
		db	 55h, 55h, 40h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 54h, 05h, 40h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 3Fh, 3Fh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FCh
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	0FAh,0ABh,0FFh,0C0h, 00h, 00h
		db	 00h, 0Fh,0FFh,0FEh,0AFh,0FFh
		db	0FCh, 00h, 00h, 00h, 0Ah,0AAh
		db	0A0h, 02h,0AAh,0A8h, 00h, 00h
		db	 00h, 00h,0A8h, 00h, 00h, 0Ah
		db	 80h, 00h, 00h, 00h, 07h, 0Ch
		db	 00h, 00h, 30h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BAh, 80h, 00h
		db	 00h, 00h, 00h, 02h,0A8h, 00h
		db	 00h, 00h, 00h, 00h, 0Bh, 82h
		db	0A0h, 00h, 00h, 00h, 00h, 2Eh
		db	0AAh,0A8h, 00h, 00h, 00h, 00h
		db	 0Eh,0E8h, 02h, 00h, 00h, 00h
		db	 00h, 0Ah,0A2h, 80h, 00h, 00h
		db	 00h, 00h,0ABh,0AAh,0A2h, 00h
		db	 00h, 00h, 00h,0AEh,0BAh, 02h
		db	 80h, 00h, 00h, 02h,0FFh, 82h
		db	0A0h, 80h, 00h, 00h, 00h,0EAh
		db	0A0h, 28h, 00h, 00h, 00h, 03h
		db	0AAh,0A8h, 2Ah, 80h, 00h, 00h
		db	 09h, 0Fh
		db	11 dup (0)
		db	 28h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0BAh, 80h, 80h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0EAh, 82h,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 03h,0AAh,0A0h,0AAh
		db	 00h, 00h, 00h, 00h, 00h, 2Eh
		db	0AEh,0A8h,0AAh, 00h, 00h, 00h
		db	 00h, 00h, 0Ah,0AAh, 2Ah,0E8h
		db	 00h, 00h, 00h, 00h, 00h, 2Eh
		db	0AAh, 82h,0B2h,0A0h, 00h, 00h
		db	 00h, 00h, 2Ah,0AAh,0A0h,0A8h
		db	0A8h, 00h, 00h, 00h, 00h,0FEh
		db	0AEh,0A8h,0A8h, 08h, 00h, 00h
		db	 00h, 02h,0AAh,0FEh,0EAh,0A8h
		db	 28h, 00h, 00h, 00h, 00h,0EAh
		db	0EAh,0A2h,0AAh, 20h, 00h, 00h
		db	 00h, 02h,0EBh,0AAh,0E8h, 2Ah
		db	 82h, 00h, 00h, 00h, 00h,0EAh
		db	0ABh,0AAh, 82h,0AAh, 00h, 00h
		db	 00h, 03h,0AAh,0AEh,0AAh,0A0h
		db	0A8h, 00h, 00h, 00h, 0Dh, 0Eh
		db	 00h, 00h, 00h, 00h, 2Ah,0AAh
		db	0AAh,0AAh
		db	8 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0BFh,0FFh,0EAh,0FFh
		db	0A8h, 00h, 00h, 00h, 00h, 3Fh
		db	 2Ah,0AAh,0AAh,0AAh,0AAh,0FFh
		db	0AFh,0FAh, 00h, 00h, 00h, 00h
		db	 3Fh, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0FFh,0AFh,0FAh, 00h, 00h, 00h
		db	 00h, 3Fh, 00h, 00h, 0Ah,0BFh
		db	0FFh,0FFh,0FFh,0FAh
		db	7 dup (0)
		db	 02h,0AFh,0EAh,0AAh,0BFh,0A8h
		db	 00h
		db	7 dup (0)
		db	0AAh,0A0h, 00h,0AAh, 80h, 00h
		db	 00h
		db	17 dup (0)
		db	 02h,0AAh, 0Ah,0A8h, 2Ah, 82h
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 2Ah,0C3h,0ABh, 0Eh
		db	0B0h,0EBh, 0Eh,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 2Ah,0C3h,0ABh
		db	 0Eh,0B0h,0EBh, 0Eh,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 02h,0AAh
		db	 0Ah,0A8h, 2Ah, 82h,0AAh, 00h
		db	 00h, 00h, 00h, 05h, 04h, 0Fh
		db	0FFh,0FFh,0FCh, 00h, 0Fh, 55h
		db	 55h, 7Ch, 00h, 0Fh, 55h, 55h
		db	 7Ch, 00h, 0Fh,0FFh,0FFh,0FCh
		db	 00h, 05h, 04h, 0Fh,0FFh,0FFh
		db	0FCh, 00h, 0Fh,0AAh,0AAh,0BCh
		db	 00h, 0Fh,0AAh,0AAh,0BCh, 00h
		db	 0Fh,0FFh,0FFh,0FCh, 00h, 0Bh
		db	 08h,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 03h,0FEh,0BAh,0AAh,0AAh
		db	0AAh, 00h, 0Fh,0E5h, 1Fh,0C0h
		db	 0Eh,0EAh
loc_c_1AB3:
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bx],cl
		lds	cx,dword ptr [bx]	; Load seg:offset ptr
		sar	byte ptr [bp+si],0AAh	; Shift w/sign fill
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		sub	[bx+si],al
		add	ax,0
		jmp	short loc_c_1AB3
			                        ;* No entry point to code
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bx+si],dl
		inc	ax
		add	bp,ss:data_d_AABA_e[bp+si]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		test	al,80h
;*		call	sub_c_2699		;*
		db	0E8h,0BCh, 0Bh		;  Fixup - byte match
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		test	al,7
		add	[bp+si],bh
;*		jmp	far ptr l_AAAA_AAAA	;*
		db	0EAh
		dw	0AAAAh, 0AAAAh		;  Fixup - byte match
		db	0AAh,0AAh,0AAh,0A0h, 03h,0EAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 0Eh
		db	 0Dh,0A8h, 00h, 00h, 00h, 07h
		db	 00h, 0Fh, 80h, 00h, 3Fh,0ABh
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	 00h, 08h, 80h, 0Ch, 80h, 00h
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0A8h
		db	 00h, 00h, 00h, 12h, 5Fh,0FCh
		db	 80h, 02h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h,0A0h, 00h, 00h, 3Fh
		db	0EFh,0FCh,0E0h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A8h, 00h
		db	 00h, 20h, 20h, 0Ch,0A0h, 3Bh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 00h, 4Dh, 90h, 1Ch
		db	0A0h, 3Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 8Ah, 00h, 00h,0CDh
		db	 98h, 1Fh,0A0h,0EAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 80h
		db	 03h,0CDh, 9Eh, 0Ch,0A3h
		db	8 dup (0AAh)
		db	 80h, 07h, 80h, 0Fh, 0Ch,0A2h
		db	0AEh
		db	7 dup (0AAh)
		db	0A8h, 00h, 3Ch,0E0h, 1Fh,0ABh
		db	9 dup (0AAh)
		db	 1Fh, 3Ah, 67h,0CCh,0BAh,0FAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A0h, 3Ah, 60h, 1Fh,0EEh,0AEh
		db	9 dup (0AAh)
		db	 02h, 03h,0FEh
		db	7 dup (0AAh)
		db	 12h, 13h,0AAh,0A0h, 00h, 00h
		db	 00h,0FFh,0E0h, 00h, 1Fh,0E0h
		db	 00h

locloop_c_1BBD:
		add	ss:data_d_AAAA_e[bp+si],ch
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		test	al,7Ch			; '|'
		add	[bp+di],al
		cmp	byte ptr [bx+si],0
;*		cmp	[bx+si+0],bh
		db	 38h, 78h, 00h		;  Fixup - byte match
		db	 02h,0EEh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A8h, 65h,0F0h, 04h
		db	 00h, 04h, 00h, 60h, 0Ch, 00h
		db	 02h,0AEh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 65h, 80h, 08h
		db	0F1h,0E2h, 00h, 40h,0E6h, 00h
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 7Dh,0E0h, 08h
		db	0F5h,0E2h, 00h

locloop_c_1C02:
		add	sp,si
		add	[bp+di],cl
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	ds:d_0000_0488_e[bx],ax
		add	al,[bx+si]
		pop	es
		mov	byte ptr [bx+si],3Ah	; ':'
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		mov	ds:d_0000_FCA1_e,al
		retf	0CA6Ah			; Return far
		db	 00h, 0Fh,0E6h, 00h, 3Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 0Ch,0CDh,0BFh,0B6h
		db	 00h, 0Ch, 7Ch, 00h,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	 8Fh,0C0h, 33h, 00h, 00h, 00h
		db	 3Ch, 00h
		db	10 dup (0AAh)
		db	 8Ch,0FEh, 2Ch, 80h, 00h, 0Fh
		db	0EEh, 02h,0EAh
		db	8 dup (0AAh)
		db	0A2h,0A0h, 33h, 3Fh, 80h, 00h
		db	 0Eh, 07h, 0Ah,0AEh,0AAh,0AAh
		db	7 dup (0AAh)
		db	0BEh, 33h, 20h, 80h, 00h, 0Eh
		db	 03h, 0Eh,0AAh,0AAh
		db	8 dup (0AAh)
		db	0ABh, 33h, 1Fh, 00h, 00h, 0Eh
		db	 00h
		db	2Ah
		db	11 dup (0AAh)
		db	 33h, 00h, 00h, 00h, 00h, 00h
		db	 3Ah
		db	11 dup (0AAh)
		db	 3Eh, 44h, 44h, 44h, 44h, 40h
		db	12 dup (0AAh)
		db	 81h,0EEh,0EEh,0EEh,0EEh,0E3h
		db	0AAh
		db	11 dup (0AAh)
		db	0ABh,0FFh,0FFh,0FFh,0FFh,0EAh
		db	0AAh,0AAh,0AAh,0AAh
		db	40 dup (0AAh)
		db	 12h, 24h, 00h, 00h, 00h, 00h
		db	 0Ah, 02h, 00h, 80h, 82h, 00h
		db	 00h, 00h
		db	9 dup (0)
		db	 20h, 00h, 02h, 00h, 80h, 88h
		db	 00h,0A0h, 00h
		db	9 dup (0)
		db	 0Ah, 80h, 80h, 82h, 00h, 80h
		db	 0Ah, 00h
		db	10 dup (0)
		db	 20h,0A0h, 80h,0A8h, 80h, 80h
		db	 08h, 00h, 00h
		db	9 dup (0)
		db	 02h,0A2h, 80h,0A0h, 08h, 00h
		db	 08h, 00h
		db	11 dup (0)
		db	 22h, 82h, 80h, 08h, 00h,0A0h
		db	 00h, 00h
		db	9 dup (0)
		db	 0Ah, 37h, 8Ah, 80h, 28h, 2Ah
		db	 1Fh
		db	11 dup (0)
		db	0ABh,0F7h, 5Ah,0AAh,0AAh,0A5h
		db	 77h,0F0h
		db	9 dup (0)
		db	 0Ah,0AAh, 3Fh, 55h, 55h, 55h
		db	 5Fh, 7Fh
		db	2Ah
		db	9 dup (0)
		db	 2Ah,0A2h,0A7h,0F5h, 55h, 55h
		db	 57h,0F2h, 2Ah, 80h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 2Ah, 00h,0AAh, 7Fh, 7Fh, 7Fh
		db	 7Fh, 20h, 02h,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h, 02h,0AAh,0AAh, 97h,0D6h
		db	0A2h,0A8h, 00h, 20h, 00h
		db	8 dup (0)
		db	 0Ah, 22h,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 80h, 00h, 00h
		db	8 dup (0)
		db	0AAh, 00h, 2Ah,0AAh,0AAh,0A0h
		db	 02h,0A8h
		db	9 dup (0)
		db	 02h,0A0h, 02h,0AAh,0AAh,0AAh
		db	0AAh, 00h
		db	2Ah
		db	9 dup (0)
		db	 02h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	 2Ah, 80h, 02h, 00h
		db	10 dup (0)
		db	 2Ah, 2Ah,0AAh,0AAh, 02h,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AAh, 80h, 00h, 00h
		db	 20h, 22h,0A8h,0AAh, 80h,0A0h
		db	 00h, 00h, 02h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	 20h, 02h,0A0h, 2Ah,0A0h, 20h
		db	 00h, 00h, 0Eh,0EAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	 00h, 2Ah,0A0h, 2Ah,0A0h, 00h
		db	 00h, 00h, 0Ah,0EAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A8h, 00h, 00h
		db	 00h, 22h, 00h, 22h, 00h, 00h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A8h, 00h, 00h
		db	 00h, 00h, 55h, 52h, 00h, 00h
		db	 00h, 00h, 2Eh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A8h, 00h, 00h
		db	 00h, 05h, 45h, 04h, 00h, 00h
		db	 00h, 00h
		db	3Ah
		db	7 dup (0AAh)
		db	 00h, 00h, 00h, 05h, 05h, 41h
		db	 40h, 00h, 00h, 00h
		db	3Ah
		db	7 dup (0AAh)
		db	 80h, 00h, 00h, 01h, 50h, 45h
		db	 40h, 00h, 00h, 00h
		db	2Ah
		db	7 dup (0AAh)
		db	 80h, 00h, 00h, 00h, 54h, 05h
		db	 40h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 54h, 05h
		db	 00h, 00h, 00h, 00h,0EAh
		db	7 dup (0AAh)
		db	0A0h, 00h, 00h, 00h, 44h, 55h
		db	 40h, 00h, 00h, 02h,0AEh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 40h, 15h
		db	 40h, 00h, 00h, 03h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h, 00h, 00h, 54h, 55h
		db	 40h, 00h, 00h, 02h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 05h, 54h, 55h
		db	 04h, 00h, 00h, 0Eh,0AAh,0AAh
		db	7 dup (0AAh)
		db	 00h, 00h, 05h, 40h, 14h, 44h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 80h, 00h, 55h, 40h, 44h, 45h
		db	 40h, 00h
		db	3Ah
		db	9 dup (0AAh)
		db	0A0h, 05h, 54h, 04h, 14h, 05h
		db	 54h, 00h
		db	10 dup (0AAh)
		db	0A8h, 55h, 54h, 04h, 14h, 05h
		db	 55h, 5Ah
		db	25 dup (0AAh)
		db	 12h, 24h
		db	167 dup (0)
		db	 80h, 08h, 20h, 80h, 80h, 00h
		db	 00h, 00h
		db	8 dup (0)
		db	 08h, 00h, 80h, 08h, 20h, 82h
		db	 80h, 80h, 00h, 00h
		db	8 dup (0)
		db	 02h, 80h, 80h, 0Ah, 20h,0AAh
		db	 00h,0A8h
		db	11 dup (0)
		db	 08h, 80h, 82h, 80h, 80h, 02h
		db	 80h
		db	11 dup (0)
		db	 20h, 80h, 82h, 80h,0A0h, 28h
		db	 00h
		db	11 dup (0)
		db	 20h, 80h, 82h, 80h,0A2h,0A8h
		db	 00h
		db	12 dup (0)
		db	0A0h, 80h, 88h,0A2h,0A0h, 00h
		db	11 dup (0)
		db	 35h,0AAh,0A8h,0A2h,0AAh, 15h
		db	8 dup (0)
		db	0AAh, 80h, 00h, 2Bh,0F5h, 5Ah
		db	0A2h,0AAh,0A1h, 77h,0F0h, 00h
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 02h,0AAh, 3Fh, 55h
		db	 55h, 55h, 5Fh, 7Fh,0AAh, 00h
		db	 0Eh,0EAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 0Ah,0AAh, 23h,0F7h
		db	0F7h,0F7h,0F7h,0F2h,0AAh, 80h
		db	 0Ah,0EAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 2Ah, 00h, 2Ah,0BFh
		db	0FFh,0FFh,0FFh, 20h, 02h,0A0h
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 20h, 02h,0AAh,0A2h
		db	0ABh,0FAh,0A2h,0A0h, 00h, 20h
		db	 2Eh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 00h, 0Ah,0A2h, 2Ah
		db	0AAh,0AAh,0A2h,0AAh, 00h, 00h
		db	3Ah
		db	7 dup (0AAh)
		db	 00h,0AAh, 00h, 2Ah,0AAh,0AAh
		db	0A0h, 0Ah,0A0h, 00h
		db	3Ah
		db	7 dup (0AAh)
		db	 82h,0A0h, 02h,0AAh,0AAh,0AAh
		db	0AAh, 00h,0AAh, 00h
		db	2Ah
		db	7 dup (0AAh)
		db	 82h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh, 00h, 0Ah, 00h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 2Ah,0AAh, 22h, 02h
		db	 02h,0A0h, 00h, 00h,0EAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 28h, 02h, 05h, 40h
		db	 40h,0A0h, 00h, 02h,0AEh
		db	7 dup (0AAh)
		db	0A0h, 00h, 20h, 02h, 05h, 05h
		db	 40h, 28h, 00h, 03h
		db	8 dup (0AAh)
		db	0A8h, 00h, 00h, 00h, 15h, 55h
		db	 40h, 00h, 00h, 02h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh, 00h, 00h, 00h, 15h, 55h
		db	 40h, 00h, 00h, 0Eh
		db	9 dup (0AAh)
		db	 00h, 00h, 00h, 54h, 55h, 40h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 80h, 00h, 01h, 50h, 14h, 50h
		db	 00h, 00h, 3Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h, 15h, 40h, 54h, 55h
		db	 00h, 00h
		db	10 dup (0AAh)
		db	0A8h, 15h, 54h, 04h, 04h, 15h
		db	 55h,0AAh
		db	25 dup (0AAh)
		db	 09h, 09h, 0Ah,0A8h, 00h, 03h
		db	0FFh,0C0h, 00h, 00h, 00h, 02h
		db	0AAh,0A0h, 3Ch, 00h, 30h, 00h
		db	 00h, 00h, 00h,0AAh,0A3h,0F0h
		db	 00h, 0Eh, 00h, 00h, 00h, 00h
		db	 2Ah,0BFh,0FFh,0FFh,0FFh,0AAh
		db	 00h, 00h, 00h, 8Fh,0C0h, 00h
		db	 00h,0AAh, 80h, 00h, 00h, 0Ah
		db	0BFh,0FFh,0FFh,0FFh,0ABh,0C0h
		db	 00h, 00h, 2Ah,0B0h, 03h,0FFh
		db	 00h, 0Fh, 00h, 00h, 00h, 00h
		db	 02h,0AAh, 00h, 2Ah,0A0h, 00h
		db	 00h, 00h, 00h, 00h,0A8h, 00h
		db	 0Ah, 80h, 00h, 00h, 00h, 09h
		db	 0Eh, 00h, 00h, 00h, 00h, 40h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 00h, 40h, 00h, 00h, 00h
		db	 00h, 04h, 00h, 04h, 05h, 40h
		db	 00h, 00h, 00h, 00h, 05h, 54h
		db	 04h, 05h, 00h, 00h, 00h, 00h
		db	 00h, 05h, 55h, 44h, 05h, 00h
		db	 14h, 00h, 00h, 00h, 00h, 55h
		db	 60h, 40h, 05h, 50h, 00h, 00h
		db	 00h, 00h, 00h, 6Ah,0A8h, 55h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 2Ah,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 05h, 6Ah,0A8h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 15h
		db	 6Ah, 05h, 40h, 00h, 00h, 00h
		db	 00h, 00h, 54h, 0Fh, 01h, 54h
		db	 00h, 00h, 00h, 00h, 00h, 40h
		db	 04h, 00h, 55h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 04h, 00h, 01h
		db	 40h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 09h, 0Eh
		db	11 dup (0)
		db	4, 0
		db	7 dup (0)
		db	 04h, 04h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 04h, 05h, 04h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 05h
		db	 40h, 55h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h
		db	 40h, 41h
		db	7 dup (0)
		db	 42h,0A1h, 54h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 02h,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 05h
		db	 42h,0BCh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 04h, 02h,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0E1h, 40h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 54h, 51h, 40h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 40h, 40h, 40h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 40h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Dh, 10h
		db	 00h, 00h, 00h, 3Fh, 0Fh,0F0h
		db	0F0h
		db	9 dup (0)
		db	 3Fh,0F3h,0F3h,0FFh, 00h
		db	8 dup (0)
		db	0FFh,0ABh,0CBh,0F7h,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0FBh,0EAh,0AAh,0A7h,0C0h
		db	 00h
		db	7 dup (0)
		db	0FAh,0AAh, 3Fh,0AFh,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh,0EAh,0AAh,0BFh, 00h
		db	 00h
		db	7 dup (0)
		db	 23h,0FAh,0AAh,0F8h
		db	9 dup (0)
		db	 02h, 3Fh,0A3h,0F0h, 00h
		db	9 dup (0)
		db	0FBh,0AEh,0E0h, 00h
		db	9 dup (0)
		db	 3Ah,0AFh, 00h, 00h
		db	9 dup (0)
		db	 0Fh,0A3h,0F0h, 00h
		db	8 dup (0)
		db	 02h,0AAh,0AFh,0BCh
		db	9 dup (0)
		db	 03h,0AAh,0AAh,0BFh
		db	9 dup (0)
		db	 23h,0FAh,0BFh,0AAh, 80h
		db	7 dup (0)
		db	 03h,0FAh,0ABh,0FAh,0BFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh,0AAh,0ABh,0FAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	 0Dh, 10h, 00h, 00h, 03h,0F0h
		db	 0Fh,0FCh, 3Ah,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 3Fh
		db	 7Fh, 37h,0F7h,0FFh, 3Ch, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 3Fh, 7Bh, 2Ah,0B7h,0FBh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 23h, 6Bh,0EAh,0A6h,0AFh
		db	0F2h
		db	7 dup (0)
		db	 23h,0E6h,0AAh,0AAh,0BFh, 3Fh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh,0FBh,0FAh,0AAh,0AFh
		db	0FFh
		db	7 dup (0)
		db	 03h,0D7h,0F6h,0AFh,0BFh, 3Ch
		db	8 dup (0)
		db	 3Fh,0BEh,0A2h,0FAh,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 07h,0E2h,0AFh,0FAh
		db	9 dup (0)
		db	 03h,0FAh,0ABh, 30h, 00h
		db	9 dup (0)
		db	0FEh,0A3h,0F0h, 00h
		db	8 dup (0)
		db	 0Ah,0BAh,0ABh, 28h
		db	9 dup (0)
		db	 3Fh,0AAh,0AAh,0AFh
		db	9 dup (0)
		db	 23h,0FAh, 3Fh, 3Fh
		db	8 dup (0)
		db	 03h,0FAh,0ABh,0FAh,0BFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh,0AAh,0ABh,0FAh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	 0Dh, 10h, 00h, 00h, 00h, 02h
		db	 3Ch, 3Ch,0F0h
		db	8 dup (0)
		db	 0Fh, 0Fh,0F0h,0F0h,0CCh
		db	8 dup (0)
		db	 0Fh, 0Ch, 00h,0F0h,0F0h
		db	8 dup (0)
		db	 03h, 0Fh, 3Ch, 22h
		db	9 dup (0)
		db	 3Fh, 00h,0F0h, 00h, 0Fh,0C0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ch, 00h, 03h,0F0h, 3Ch
		db	0F0h
		db	7 dup (0)
		db	 30h,0F0h, 23h,0FCh, 03h, 0Ch
		db	7 dup (0)
		db	 3Ch, 3Fh, 3Ch,0C0h, 3Ch, 3Ch
		db	8 dup (0)
		db	0FFh, 3Fh, 3Ch, 23h, 3Ch, 00h
		db	7 dup (0)
		db	0F2h, 02h, 3Ch, 00h,0F0h
		db	8 dup (0)
		db	 3Fh, 00h, 00h, 03h,0C0h
		db	70 dup (0)
		db	 0Dh, 10h, 00h, 00h, 00h, 00h
		db	 00h, 04h
		db	40h
		db	11 dup (0)
		db	 20h, 00h
		db	9 dup (0)
		db	 04h,0F0h, 00h, 40h, 00h
		db	8 dup (0)
		db	 20h, 00h
		db	26 dup (0)
		db	 40h, 03h,0C0h
		db	9 dup (0)
		db	 20h, 40h, 04h
		db	9 dup (0)
		db	 3Ch, 00h, 20h, 00h, 04h, 00h
		db	7 dup (0)
		db	 02h, 0Fh, 00h, 03h,0C4h, 00h
		db	7 dup (0)
		db	 40h, 00h, 00h, 00h, 40h, 00h
		db	7 dup (0)
		db	 3Ch, 00h
		db	73 dup (0)
		db	 0Dh, 10h, 00h, 00h, 00h, 02h
		db	0AFh,0FCh, 2Ah, 80h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h,0AAh
		db	 0Fh,0AEh,0AAh, 0Fh,0FFh, 80h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0ABh,0FFh,0F3h,0FFh,0CFh,0FFh
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	0FCh,0ABh,0EAh,0FFh,0EFh,0FEh
		db	0AFh,0AAh, 00h, 00h, 00h, 00h
		db	 00h,0FFh,0AAh, 2Eh,0FFh,0FAh
		db	0AEh,0AFh, 3Fh, 00h, 00h, 00h
		db	 00h, 02h, 3Fh, 2Bh,0FFh, 28h
		db	 00h, 03h,0A2h, 3Fh,0C0h, 00h
		db	 00h, 00h, 00h, 23h,0CEh,0BFh
		db	0AAh,0AAh,0BFh,0ACh,0F2h,0C0h
		db	 00h, 00h, 00h, 00h, 28h, 4Eh
		db	0BEh,0AAh,0AAh,0AFh,0ECh, 42h
		db	0F0h, 00h, 00h, 00h, 03h,0F8h
		db	0FEh, 3Eh,0EAh,0BFh,0E2h, 2Bh
		db	0C2h,0B0h, 00h, 00h, 00h, 03h
		db	0F8h,0FEh,0BBh,0EAh,0BFh,0AAh
		db	0BBh,0C2h,0B0h, 00h, 00h, 00h
		db	 03h,0FAh, 8Eh,0B3h,0FFh,0FFh
		db	0FFh,0F2h,0F2h,0B0h, 00h, 00h
		db	 00h, 02h, 3Fh,0CEh,0AFh,0FAh
		db	0AAh,0FFh, 2Fh, 0Fh,0C0h, 00h
		db	 00h, 00h, 00h, 3Fh,0F8h,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 3Fh, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0CBh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 20h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 03h,0FFh,0FFh,0FFh,0FFh,0FCh
		db	8 dup (0)
		db	 3Fh, 2Eh, 3Fh, 22h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Dh, 10h
		db	 00h
		db	40 dup (0)
		db	 3Fh,0F0h, 0Fh,0FBh,0FFh, 80h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Eh,0AFh,0F8h,0AAh,0AAh,0EAh
		db	0AAh, 80h, 00h, 00h, 00h, 00h
		db	 00h, 3Ah,0A0h, 46h, 24h, 44h
		db	0FAh, 82h,0A8h, 00h, 00h, 00h
		db	 00h, 00h, 3Ah, 0Fh,0FAh,0FFh
		db	0FFh,0FEh,0BCh, 28h, 00h, 00h
		db	 00h, 00h, 00h, 3Bh,0CFh,0AFh
		db	0FEh,0AAh,0BEh,0A8h,0F8h, 00h
		db	 00h, 00h, 00h, 00h, 3Bh,0FFh
		db	0AFh,0AAh,0AAh,0AAh, 3Fh, 38h
		db	 00h, 00h, 00h, 00h, 00h, 2Bh
		db	0FFh,0ABh,0FAh,0AAh,0AAh, 3Fh
		db	0FAh, 00h, 00h, 00h, 00h, 00h
		db	 2Bh,0CFh,0EAh,0FFh,0FFh,0FAh
		db	0FCh, 2Ah, 00h, 00h, 00h, 00h
		db	 00h, 2Ah, 3Fh,0FEh,0AFh,0FFh
		db	0EFh,0FFh, 2Ah, 00h, 00h, 00h
		db	 00h, 00h, 2Ah,0A3h, 6Ah,0AAh
		db	0AAh,0A8h, 42h,0A8h, 00h, 00h
		db	 00h, 00h, 00h, 02h, 2Ah,0FAh
		db	0AAh,0FFh,0FAh,0AAh, 80h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	0AFh,0FFh,0FAh,0AAh,0A0h, 00h
		db	 00h
		db	16 dup (0)
		db	 0Dh, 10h, 00h
		db	94 dup (0)
		db	 2Fh,0FEh, 00h
		db	9 dup (0)
		db	0AAh,0ABh,0F2h,0AFh,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 3Fh,0FEh,0AFh,0FFh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0FAh,0ABh,0F2h,0BFh
		db	0C0h, 00h
		db	8 dup (0)
		db	 0Bh,0FAh
		db	59 dup (0)
		db	 06h, 08h, 3Fh, 00h, 00h, 00h
		db	 00h, 00h,0FFh,0C0h, 00h, 00h
		db	 00h, 00h,0E3h,0C0h, 00h, 00h
		db	 00h, 00h, 3Fh, 00h, 00h, 00h
		db	 00h, 00h, 3Fh, 00h, 00h, 00h
		db	 00h, 00h, 04h
		db	17 dup (0)
		db	6, 8, 0
		db	11 dup (0)
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 04h, 00h, 00h, 00h, 00h, 00h
		db	 04h
		db	11 dup (0)
		db	 06h, 02h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 0Fh,0FFh,0C0h, 00h
		db	 00h, 00h, 0Dh, 0Ah, 00h, 00h
		db	 00h, 2Ah,0AAh,0AAh,0A0h
		db	8 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh
		db	8 dup (0)
		db	 2Ah,0BFh,0FFh,0FFh,0FAh,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 02h,0ABh,0FFh,0FFh,0FFh,0FFh
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0BFh,0FCh, 44h, 44h
		db	0FFh,0FAh, 80h, 00h, 00h, 00h
		db	 00h, 00h, 2Bh,0FFh,0C4h, 00h
		db	 00h, 4Fh,0FFh,0A0h, 00h, 00h
		db	 00h, 00h, 00h,0ABh,0FCh, 40h
		db	 00h, 00h, 04h,0FFh,0E8h, 00h
		db	 00h, 00h, 00h, 02h,0BFh,0C4h
		db	 00h
data_c_2A00	db	0			; Data table (indexed access)
		db	 00h, 00h, 4Fh,0FAh, 00h, 00h
		db	 00h, 00h, 02h,0BFh,0C0h, 00h
		db	 00h, 00h, 00h, 0Fh,0FAh, 00h
		db	 00h, 00h, 00h, 03h,0FCh, 40h
		db	 00h, 00h, 00h, 00h, 04h,0FFh
		db	 00h, 00h, 00h, 00h, 0Dh, 0Ah
		db	 00h, 00h, 0Fh, 00h, 3Fh, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 3Fh,0F3h,0FFh
		db	0F2h, 3Fh,0C0h, 00h, 00h, 00h
		db	 00h, 00h, 03h,0C0h, 3Fh,0FCh
		db	0FCh,0FCh,0FFh, 20h,0FCh, 00h
		db	 00h, 00h, 00h, 03h,0F2h, 3Fh
		db	0C4h, 44h, 44h, 44h, 23h,0FCh
		db	 00h, 00h, 00h, 00h, 03h,0FFh
		db	 3Ch, 4Fh, 2Ah,0AAh,0BCh, 4Fh
		db	0FCh, 00h, 00h, 00h, 00h, 03h
		db	0FFh,0C4h,0F2h,0AAh,0AAh,0A3h
		db	0CFh,0F0h, 00h, 00h, 00h, 00h
		db	 03h,0FCh, 4Fh, 2Ah, 00h, 00h
		db	 2Ah, 3Ch, 20h, 00h, 00h, 00h
		db	 00h, 03h,0FCh,0F2h, 80h, 00h
		db	 00h, 02h,0BCh,0FFh, 00h, 00h
		db	 00h, 00h, 02h, 0Fh,0A8h, 00h
		db	 00h, 00h, 00h,0A0h, 4Fh,0C0h
		db	 00h, 00h, 00h, 03h,0CFh,0A0h
		db	 00h, 00h, 00h, 00h, 23h,0CFh
		db	 00h, 00h, 00h, 00h, 06h, 07h
		db	 00h, 10h, 00h, 00h, 00h, 00h
		db	 00h, 88h, 00h, 00h, 00h, 00h
		db	 02h,0AAh, 00h, 00h, 00h, 00h
		db	 06h, 9Ah, 40h, 00h, 00h, 00h
		db	 02h,0AAh, 00h, 00h, 00h, 00h
		db	 02h,0AAh, 00h, 00h, 00h, 00h
		db	 00h, 98h, 00h, 00h, 00h, 00h
		db	 06h, 07h, 04h, 54h, 54h, 00h
		db	 00h, 00h, 04h, 44h, 44h, 00h
		db	 00h, 00h, 04h, 44h, 44h, 00h
		db	 00h, 00h, 04h, 44h, 44h, 00h
		db	 00h, 00h, 04h, 44h, 44h, 00h
		db	 00h, 00h, 04h, 44h, 44h, 00h
		db	 00h, 00h, 04h, 54h, 54h, 00h
		db	 00h, 00h, 06h, 07h, 05h, 45h
		db	 45h, 40h, 00h, 00h, 04h, 04h
		db	 44h, 40h, 00h, 00h, 04h, 04h
		db	 44h, 40h, 00h, 00h, 05h, 44h
		db	 44h, 40h, 00h, 00h, 00h, 44h
		db	 44h, 40h, 00h, 00h, 00h, 44h
		db	 44h, 40h, 00h, 00h, 05h, 45h
		db	 45h, 40h, 00h, 00h, 06h, 07h
		db	 05h, 45h, 45h, 40h, 00h, 00h
		db	 04h, 44h, 44h, 40h, 00h, 00h
		db	 04h, 44h, 44h, 40h, 00h, 00h
		db	 05h, 44h, 44h, 40h, 00h, 00h
		db	 04h, 44h, 44h, 40h, 00h, 00h
		db	 04h, 44h, 44h, 40h, 00h, 00h
		db	 05h, 45h, 45h, 40h, 00h, 00h
		db	 07h, 07h, 04h, 54h, 54h, 54h
		db	 00h, 00h, 00h, 04h, 44h, 44h
		db	 44h, 00h, 00h, 00h, 04h, 44h
		db	 44h, 44h, 00h, 00h, 00h, 04h
		db	 44h, 44h, 44h, 00h, 00h, 00h
		db	 04h, 44h, 44h, 44h, 00h, 00h
		db	 00h, 04h
		db	44h
loc_c_2B7E:
		inc	sp
		inc	sp
loc_c_2B80:
		add	[bx+si],al
		add	[si],al
		push	sp
		push	sp
		push	sp
		add	[bx+si],al
		add	[bp+si],al
		pop	es
		jg	loc_c_2B7E		; Jump if >
		jg	loc_c_2B80		; Jump if >
;*                         lock	push	ax
		db	0F0h,0F0h,0F0h,0F0h,0FFh,0F0h	;  Fixup - byte match
;                           lock	add	al,[bx]
		db	0f0h, 0f0h, 0f0h, 0f0h, 2, 7

;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
loc_c_2B9E:
;*                         lock	inc	ax
		db	0F0h,0F0h,0F0h,0F0h,0FFh,0C0h	;  Fixup - byte match
;*                         lock	push	ax
		db	0F0h,0F0h,0F0h,0F0h,0FFh,0F0h	;  Fixup - byte match
loc_c_2BAA:
		add	al,[bx]
		jg	loc_c_2B9E		; Jump if >
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*                         lock	add	al,dh
		db	0F0h,0F0h,0F0h, 00h,0F0h	;  Fixup - byte match
;*                         lock	push	ax
		db	0F0h,0FFh,0F0h		;  Fixup - byte match
		jg	loc_c_2BAA		; Jump if >
		add	al,[bx]
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
		cld				; Clear direction
;*		xor	ah,bh
		db	 30h,0FCh		;  Fixup - byte match
;*		xor	ah,bh
		db	 30h,0FCh		;  Fixup - byte match
;*		xor	bh,bh			; Zero register
		db	 30h,0FFh		;  Fixup - byte match
;*                         lock	push	ax
		db	0F0h,0FFh,0F0h		;  Fixup - byte match
		add	al,[bx]
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
		clc				; Clear carry flag
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		sar	al,0			; Shift w/sign fill
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
		add	al,[bx]
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*                         lock	add	bh,bh
		db	0F0h, 00h,0FFh		;  Fixup - byte match
		sar	bh,0C0h			; Shift w/sign fill
;*                         lock	add	al,dh
		db	0F0h, 00h,0F0h		;  Fixup - byte match
		add	[bp+si],al
		pop	es
		jg	$-0Eh			; Jump if >
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*                         lock	add	bl,dh
		db	0F0h, 00h,0F3h		;  Fixup - byte match
;*                         lock	push	ax
		db	0F0h,0F0h,0F0h,0FFh,0F0h	;  Fixup - byte match
		jg	$-0Eh			; Jump if >
		add	al,[bx]
;*                         lock	push	ax
		db	0F0h,0F0h,0F0h,0F0h,0F0h,0F0h	;  Fixup - byte match
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
                          ; lock	add	al,[bx]
		db	0f0h, 0f0h, 0f0h, 0f0h, 2, 7

;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	0FFh,0F0h,0FFh,0F0h, 02h, 07h
		db	 03h,0C0h, 03h,0C0h, 03h,0C0h
		db	 03h,0C0h,0F3h,0C0h,0FFh,0C0h
		db	 7Fh,0C0h, 02h, 07h,0F0h,0F0h
		db	0F3h,0F0h,0FFh,0C0h,0FFh, 00h
		db	0FFh,0C0h,0F3h,0F0h,0F0h,0F0h
		db	 02h, 07h,0F0h, 00h,0F0h, 00h
		db	0F0h, 00h,0F0h, 00h,0F0h,0F0h
		db	0FFh,0F0h,0FFh,0F0h, 02h, 07h
		db	0F0h,0F0h,0F0h,0F0h,0F9h,0F0h
		db	0FFh,0F0h,0F6h,0F0h,0F0h,0F0h
		db	0F0h,0F0h, 02h, 07h,0F0h,0F0h
		db	0FCh,0F0h,0FFh,0F0h,0FFh,0F0h
		db	0FFh,0F0h,0F3h,0F0h,0F0h,0F0h
		db	 02h, 07h, 7Fh,0F0h,0FFh,0F0h
		db	0F0h,0F0h,0F0h,0F0h,0F0h,0F0h
		db	0FFh,0F0h, 7Fh,0F0h, 02h, 07h
		db	0FFh,0F0h
loc_c_2C7E:
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
		clc				; Clear carry flag
;*                         lock	push	ax
		db	0F0h,0FFh,0F0h		;  Fixup - byte match
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
		clc				; Clear carry flag
;*		add	al,bh
		db	 00h,0F8h		;  Fixup - byte match
		add	[bp+si],al
		pop	es
		jg	loc_c_2C7E		; Jump if >
;*		push	ax
		db	0FFh,0F0h		;  Fixup - byte match
               ;            lock	cld				; Clear direction
		db	0f0h, 0f0h, 0fch

		db	0F0h,0F3h,0F0h,0FFh,0C0h, 7Fh
		db	 30h, 02h, 07h,0FFh,0F0h,0FFh
		db	0F0h,0F0h,0F0h,0FFh,0F0h,0FFh
		db	0C0h,0F3h,0F0h,0F0h,0F0h, 02h
		db	 07h, 7Fh,0F0h,0FFh,0F0h,0FCh
		db	 00h, 7Fh,0F0h, 03h,0F0h,0FFh
		db	0F0h, 7Fh,0F0h, 02h, 07h,0FFh
		db	0F0h,0FFh,0F0h, 0Fh, 00h, 0Fh
		db	 00h, 0Fh, 00h, 0Fh, 00h, 0Fh
		db	 00h, 02h, 07h
		db	10 dup (0F0h)
		db	0FFh,0F0h, 7Fh,0F0h, 02h, 07h
		db	8 dup (0F0h)
		db	 70h,0E0h, 3Fh,0C0h, 1Fh, 80h
		db	 02h, 07h,0F0h,0F0h,0F0h,0F0h
		db	0F6h,0F0h,0FFh,0F0h,0FFh,0F0h
		db	0F0h,0F0h,0E0h, 70h, 02h, 07h
		db	0F0h,0F0h,0F0h,0F0h, 7Fh,0E0h
		db	 0Fh, 00h, 7Fh,0E0h,0F0h,0F0h
		db	0F0h,0F0h, 02h, 07h,0F0h,0F0h
		db	0F0h,0F0h, 7Fh,0E0h, 0Fh, 00h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	 02h, 07h,0FFh,0F0h,0FFh,0F0h
		db	 03h,0F0h, 0Fh,0C0h, 3Fh, 00h
		db	0FFh,0F0h,0FFh,0F0h, 02h, 07h
		db	 0Fh,0F0h, 0Fh,0F0h, 0Fh, 00h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh,0F0h
		db	 0Fh,0F0h, 02h, 07h,0C0h, 00h
		db	0F0h, 00h, 3Ch, 00h, 0Fh, 00h
		db	 03h,0C0h, 00h,0F0h, 00h, 30h
		db	 02h, 07h,0FFh, 00h,0FFh, 00h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	0FFh, 00h,0FFh, 00h, 02h, 07h
		db	 00h, 00h, 00h, 00h, 0Fh, 00h
		db	 3Fh,0C0h,0F0h,0F0h, 40h, 30h
		db	 00h, 00h, 02h, 07h
		db	10 dup (0)
		db	0FFh,0F0h,0FFh,0F0h, 02h, 07h
		db	14 dup (0)
		db	 02h, 07h, 00h, 3Ch, 00h,0FCh
		db	 03h,0F0h, 0Fh,0C0h, 03h, 00h
		db	0F0h, 00h,0F0h, 00h, 02h, 07h
		db	 3Ch,0F0h, 3Ch,0F0h, 3Ch,0F0h
		db	8 dup (0)
		db	 02h, 07h,0F3h,0C0h,0FFh,0F0h
		db	0FFh,0F0h,0F3h,0C0h,0FFh,0F0h
		db	0FFh,0F0h,0F3h,0C0h, 02h, 07h
		db	 0Fh, 00h, 3Fh,0F0h,0CFh, 00h
		db	 3Fh,0C0h, 0Fh, 30h,0FFh,0F0h
		db	 0Fh, 00h, 02h, 07h,0F0h, 30h
		db	0F0h,0F0h, 03h,0C0h, 0Fh, 00h
		db	 3Ch, 00h,0F0h,0F0h,0C0h,0F0h
		db	 02h, 07h, 3Fh, 00h,0F3h,0C0h
		db	0F3h,0C0h, 3Fh, 00h,0F3h, 30h
		db	0F3h,0C0h, 3Fh, 30h, 02h, 07h
		db	 0Fh, 00h, 0Fh, 00h, 03h, 00h
		db	0Ch
		db	7 dup (0)
		db	 02h, 07h, 03h,0C0h, 0Fh,0C0h
		db	 3Fh, 00h, 3Ch, 00h, 3Fh, 00h
		db	 0Fh,0C0h, 03h,0C0h, 02h, 07h
		db	 3Ch, 00h, 3Fh, 00h, 0Fh,0C0h
		db	 03h,0C0h, 0Fh,0C0h, 3Fh, 00h
		db	 3Ch, 00h, 02h, 07h, 0Fh, 00h
		db	0FFh,0F0h, 3Fh,0C0h, 0Fh, 00h
		db	 3Fh,0C0h,0FFh,0F0h, 0Fh, 00h
		db	 02h, 07h, 0Fh, 00h, 0Fh, 00h
		db	0FFh,0F0h,0FFh,0F0h, 0Fh, 00h
		db	 0Fh, 00h, 00h, 00h, 02h, 07h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 00h, 0Fh, 00h, 03h, 00h
		db	 0Ch, 00h, 02h, 07h, 00h, 00h
		db	 00h, 00h,0FFh,0F0h,0FFh,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 07h
		db	10 dup (0)
		db	 0Fh, 00h, 0Fh, 00h, 02h, 07h
		db	 00h, 30h, 00h,0F0h, 03h,0C0h
		db	 0Fh, 00h, 3Ch, 00h,0F0h, 00h
		db	0C0h, 00h, 02h, 07h,0FFh,0F0h
		db	10 dup (0F0h)
		db	0FFh,0F0h, 02h, 07h, 0Fh, 00h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	 0Fh, 00h, 0Fh, 00h, 0Fh, 00h
		db	 02h, 07h,0FFh,0F0h, 00h,0F0h
		db	 00h,0F0h,0FFh,0F0h,0F0h, 00h
		db	0F0h, 00h,0FFh,0F0h, 02h, 07h
		db	0FFh,0F0h, 00h,0F0h, 00h,0F0h
		db	0FFh,0F0h, 00h,0F0h, 00h,0F0h
		db	0FFh,0F0h, 02h, 07h,0F3h,0C0h
		db	0F3h,0C0h,0F3h,0C0h,0FFh,0F0h
		db	 03h,0C0h, 03h,0C0h, 03h,0C0h
		db	 02h, 07h,0FFh,0F0h,0F0h, 00h
		db	0F0h, 00h,0FFh,0F0h, 00h,0F0h
		db	 00h,0F0h,0FFh,0F0h, 02h, 07h
		db	0F0h, 00h,0F0h, 00h,0F0h, 00h
		db	0FFh,0F0h,0F0h,0F0h,0F0h,0F0h
		db	0FFh,0F0h, 02h, 07h,0FFh,0F0h
		db	0F0h,0F0h,0F0h,0F0h, 00h,0F0h
		db	 00h,0F0h, 00h,0F0h, 00h,0F0h
		db	 02h, 07h,0FFh,0F0h,0F0h,0F0h
		db	0F0h,0F0h,0FFh,0F0h,0F0h,0F0h
		db	0F0h,0F0h,0FFh,0F0h, 02h, 07h
		db	0FFh,0F0h,0F0h,0F0h,0F0h,0F0h
		db	0FFh,0F0h, 00h,0F0h, 00h,0F0h
		db	0FFh,0F0h, 02h, 07h, 00h, 00h
		db	 0Fh, 00h, 0Fh, 00h, 00h, 00h
		db	 0Fh, 00h, 0Fh, 00h, 00h, 00h
		db	 02h, 07h, 0Fh, 00h, 0Fh, 00h
		db	 00h, 00h, 0Fh, 00h, 0Fh, 00h
		db	 03h, 00h, 0Ch, 00h, 02h, 07h
		db	 03h,0C0h, 0Fh, 00h, 3Ch, 00h
		db	0F0h, 00h, 3Ch, 00h, 0Fh, 00h
		db	 03h,0C0h, 02h, 07h, 00h, 00h
		db	0FFh,0F0h,0FFh,0F0h, 00h, 00h
		db	0FFh,0F0h,0FFh,0F0h, 00h, 00h
		db	 02h, 07h, 3Ch, 00h, 0Fh, 00h
		db	 03h,0C0h, 00h,0F0h, 03h,0C0h
		db	 0Fh, 00h, 3Ch, 00h, 02h, 07h
		db	 3Fh,0C0h,0FFh,0F0h,0F3h,0F0h
		db	 03h,0C0h, 0Fh, 00h, 00h, 00h
		db	 0Fh
		db	7 dup (0)
		db	 84h, 66h, 5Eh, 70h, 90h, 2Fh
		db	 9Ch, 61h, 34h, 63h, 08h, 64h
		db	0DCh, 64h,0B0h, 65h, 46h,0B7h
		db	0FFh
		db	68 dup (0FFh)
		db	0F0h
		db	69 dup (0F3h)
		db	0F0h,0FFh
		db	'????????????????????????????????'
		db	'????????????????????????????????'
		db	'????'
		db	0F0h
		db	69 dup (0F3h)
		db	0F0h,0FFh
		db	'????????????????????????????????'
		db	'????????????????????????????????'
		db	'????'
		db	0F0h
		db	69 dup (0F3h)
		db	0F0h,0FFh
		db	'????????????????????????????????'
		db	'????????????????????????????????'
		db	'????'
		db	0F0h
		db	69 dup (0F3h)
		db	0F0h,0FFh, 3Fh, 3Fh
		db	64 dup (0FFh)
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 00h, 00h, 00h, 00h
		db	0Ch
		db	15 dup (0)
		db	 2Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AFh
		db	35 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	20 dup (0)
		db	7 dup (0AAh)
		db	0F0h
		db	34 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	21 dup (0)
		db	7 dup (0AAh)
		db	0F0h
		db	34 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	11 dup (0)
		db	3, 0, 0, 0, 0, 0
		db	0, 0, 2
		db	7 dup (0AAh)
		db	0F0h
		db	26 dup (0)
		db	 0Ch, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh
		db	 3Fh, 3Fh
		db	20 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0F0h
		db	34 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	17 dup (0)
		db	 03h, 00h, 02h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh,0F0h
		db	16 dup (0)
		db	3, 0
		db	16 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	 0Ah,0AAh,0AFh, 2Ah,0AAh,0F2h
		db	0AAh,0AFh, 02h,0AAh,0AAh,0AFh
		db	 00h, 0Ah,0AAh,0AAh,0F0h, 00h
		db	0AAh,0AAh,0AAh,0AFh
		db	21 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	19 dup (0)
		db	 0Ah,0AAh,0AFh, 2Ah,0AAh,0F2h
		db	0AAh,0AFh, 0Ah,0AAh,0AAh,0AFh
		db	0F0h,0AAh,0AAh,0AAh,0FFh, 02h
		db	0AAh,0AAh,0AAh,0AFh,0F0h
		db	20 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	 0Ah,0AAh,0FFh, 2Ah,0AFh,0F2h
		db	0AAh,0AFh, 0Ah,0AAh,0AAh,0AAh
		db	0F0h,0AAh,0AAh,0AAh,0AFh, 02h
		db	0AAh,0AAh,0AAh,0AAh,0F0h
		db	20 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h,0C0h, 00h
		db	 00h
		db	14 dup (0)
		db	 2Ah,0AAh,0F0h, 2Ah,0AFh, 02h
		db	0AAh,0AFh, 2Ah,0AAh,0AAh,0AAh
		db	0F2h,0AAh,0AAh,0AAh,0AFh, 0Ah
		db	0AAh,0AAh,0AAh,0AFh,0F0h
		db	20 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	 2Ah,0AAh,0F0h,0AAh,0AFh, 0Ah
		db	0AAh,0FFh, 2Ah,0AFh, 2Ah,0AAh
		db	0F2h,0AAh,0F2h,0AAh,0AFh, 0Ah
		db	0AAh,0AAh,0AAh,0AFh
		db	21 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	19 dup (0)
		db	 2Ah,0AFh,0F2h,0AAh,0FFh, 2Ah
		db	0AAh,0F0h,0AAh,0F0h, 0Ah,0AFh
		db	0FAh,0AFh, 02h,0AAh,0FFh, 0Ah
		db	0AAh,0F2h,0AAh,0AFh, 00h, 00h
		db	 00h, 00h, 00h
		db	30h
		db	15 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	0AAh,0AFh, 02h,0AAh,0F0h, 2Ah
		db	0AAh,0F0h,0AAh,0F0h, 0Ah,0AFh
		db	 0Ah,0AFh, 02h,0AAh,0F0h, 0Ah
		db	0AAh,0F2h,0AAh,0AFh
		db	21 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	19 dup (0)
		db	0AAh,0AFh, 0Ah,0AAh,0F0h,0AAh
		db	0AAh,0F0h,0AAh,0F0h,0AAh,0AFh
		db	 0Ah,0AFh, 0Ah,0AAh,0F0h, 2Ah
		db	0AFh,0F2h,0AAh,0FFh, 00h
		db	20 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	0AAh,0AFh, 0Ah,0AAh,0F0h,0AAh
		db	0AAh,0F0h,0AAh,0AAh,0AAh,0AFh
		db	 0Ah,0AAh,0AAh,0AAh,0F0h,0AAh
		db	0AFh, 02h,0AAh,0F0h, 00h
		db	20 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	7 dup (0)
		db	 03h, 00h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 00h, 0Ch, 00h, 00h
		db	0AAh,0AFh, 0Ah,0AAh,0F0h,0AAh
		db	0AFh,0F0h,0AAh,0AAh,0AAh,0FFh
		db	 0Ah,0AAh,0AAh,0AFh,0F0h,0AAh
		db	0AFh, 0Ah,0AAh,0F0h, 00h
		db	8 dup (0)
		db	 30h, 00h
		db	10 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	0AAh,0AFh, 0Ah,0AAh,0F0h,0AAh
		db	0AFh, 00h,0AAh,0AAh,0AAh,0F0h
		db	 0Ah,0AAh,0AAh,0AFh, 00h,0AAh
		db	0AFh, 0Ah,0AAh,0F0h
		db	19 dup (0)
		db	 03h, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 00h
		db	19 dup (0)
		db	0AAh,0AFh, 0Ah,0AAh,0F0h,0AAh
		db	0AFh, 00h,0AAh,0AAh,0AFh,0F0h
		db	 0Ah,0AAh,0AAh,0FFh, 00h,0AAh
		db	0AFh, 0Ah,0AFh,0F0h
		db	21 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	20 dup (0)
		db	0FFh,0FFh, 0Fh,0FFh,0F0h,0FFh
		db	0FFh, 00h, 0Fh,0FFh,0FFh, 00h
		db	 00h,0FFh,0FFh,0F0h, 00h,0FFh
		db	0FFh, 0Fh,0FFh, 00h
		db	21 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h
		db	0Ch
		db	12 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0ABh,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0F0h
		db	9 dup (0)
		db	0AAh,0F0h
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	18 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h,0AAh,0AAh,0FFh
		db	9 dup (0)
		db	0AAh,0FFh, 00h
		db	17 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	17 dup (0)
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AFh, 00h, 00h, 00h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh,0F0h
		db	7 dup (0)
		db	 02h,0AAh,0AFh, 00h
		db	17 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	18 dup (0)
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AFh, 00h, 00h, 00h, 00h, 02h
		db	0AAh,0AAh,0AAh,0ABh,0F0h, 00h
		db	 00h,0C0h, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh,0AFh, 00h
		db	17 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	10 dup (0)
		db	 30h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh,0AAh,0AAh,0ABh,0C0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ah,0AAh,0AFh
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	18 dup (0)
		db	 2Ah,0AAh,0AFh, 0Ah,0AAh,0AAh
		db	0F0h, 00h, 00h, 00h, 00h, 0Ah
		db	0AAh,0AAh,0AFh,0FFh, 00h
		db	7 dup (0)
		db	 0Ah,0AAh,0FFh, 00h
		db	17 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	17 dup (0)
		db	 2Ah,0AAh,0FFh, 00h,0AAh,0AAh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 2Ah,0AAh,0AFh
		db	9 dup (0)
		db	 2Ah,0AAh,0F0h, 00h
		db	9 dup (0)
		db	 0Ch, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh
		db	 3Fh, 3Fh
		db	18 dup (0)
		db	0AAh,0AAh,0F0h, 00h,0AAh,0AAh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 2Ah,0AAh,0FFh, 00h
		db	8 dup (0)
		db	 2Ah,0AAh,0F0h, 00h
		db	17 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	17 dup (0)
		db	0AAh,0AAh,0F0h, 0Ah,0AAh,0AFh
		db	0F0h, 0Ah,0AAh,0AAh,0AFh, 00h
		db	 2Ah,0AAh,0F0h,0AAh, 80h,0AAh
		db	0F0h, 00h,0AAh,0AAh,0AFh, 00h
		db	0AAh,0AAh,0F0h
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	18 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	 00h,0AAh,0AAh,0AAh,0AFh,0F0h
		db	 2Ah,0AAh,0F0h,0AAh,0AAh,0AAh
		db	0AFh, 0Ah,0AAh,0AAh,0AFh,0F0h
		db	0AAh,0AAh,0F0h
		db	18 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	16 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AFh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0F0h,0AAh,0AAh,0F0h,0AAh,0AAh
		db	0AAh,0FFh, 0Ah,0AAh,0AAh,0AAh
		db	0F0h,0AAh,0AFh,0F0h
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	17 dup (0)
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0FFh, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0F0h,0AAh,0AFh,0F0h,0AAh,0AAh
		db	0FFh,0F0h,0AAh,0AAh,0AAh,0AFh
		db	0F0h,0AAh,0AFh
		db	19 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	16 dup (0)
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0ABh
		db	0F0h, 2Ah,0AAh,0AFh, 2Ah,0AAh
		db	0F0h,0AAh,0AFh, 02h,0AAh,0AFh
		db	0F0h, 00h,0AAh,0AAh,0AAh,0AFh
		db	 02h,0AAh,0AFh, 00h
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	17 dup (0)
		db	 0Ah,0AAh,0AAh,0FFh,0FFh,0FFh
		db	 00h,0AAh,0AAh,0F0h, 0Ah,0AAh
		db	0F0h,0AAh,0AFh, 0Ah,0AAh,0AFh
		db	 00h, 02h,0AAh,0AFh, 2Ah,0AFh
		db	 0Ah,0AAh,0AFh, 00h
		db	18 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 30h, 00h
		db	14 dup (0)
		db	 0Ah,0AAh,0AAh,0F0h, 00h, 00h
		db	 00h,0AAh,0AAh,0F0h, 0Ah,0AFh
		db	0F2h,0AAh,0AFh, 0Ah,0AAh,0AFh
		db	 00h, 0Ah,0AAh,0F0h, 2Ah,0AFh
		db	 0Ah,0AAh,0FFh, 00h
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	12 dup (0)
		db	 03h, 00h, 00h, 00h, 00h, 2Ah
		db	0AAh,0AFh,0F0h, 00h, 00h, 00h
		db	0AAh,0AAh,0F0h, 2Ah,0AFh, 0Ah
		db	0AAh,0AFh, 0Ah,0AAh,0FFh, 00h
		db	 0Ah,0AAh,0F0h, 2Ah,0FFh, 0Ah
		db	0AAh,0F0h
		db	19 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	16 dup (0)
		db	 2Ah,0AAh,0AFh, 00h, 00h, 00h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	 0Ah,0AAh,0AFh, 0Ah,0AAh,0F0h
		db	 00h, 0Ah,0AAh,0F0h,0AAh,0F0h
		db	 0Ah,0AAh,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0C0h
		db	12 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	17 dup (0)
		db	0AAh,0AAh,0AFh, 00h, 00h, 00h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	 0Ah,0AAh,0FFh, 0Ah,0AAh,0F0h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0F0h
		db	 2Ah,0AAh,0AAh,0AFh
		db	18 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	16 dup (0)
		db	0AAh,0AAh,0AFh, 00h, 00h, 00h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0AFh
		db	 0Ah,0AAh,0F0h,0AAh,0AAh,0F0h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0F0h
		db	0AAh,0AAh,0AAh,0AFh
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	17 dup (0)
		db	0AAh,0AAh,0AFh, 00h, 00h, 00h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0FFh
		db	 0Ah,0AAh,0F0h,0AAh,0AAh,0F0h
		db	 00h, 0Ah,0AAh,0AAh,0AFh,0F0h
		db	0AAh,0AAh,0AAh,0FFh, 00h
		db	17 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	16 dup (0)
		db	0AAh,0AAh,0FFh, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh,0AEh,0CAh,0F0h
		db	 0Ah,0AAh,0F0h,0AAh,0AAh,0F0h
		db	 00h, 02h,0AAh,0AAh,0AFh, 00h
		db	0AAh,0AAh,0AAh,0F0h
		db	18 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	17 dup (0)
		db	0FFh,0FFh,0F0h, 00h, 00h, 00h
		db	 00h, 0Fh,0FFh,0FFh, 0Fh,0F0h
		db	 0Fh,0FFh,0F0h,0FFh,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh,0FFh, 00h
		db	0FFh,0FFh,0FFh,0F0h
		db	18 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	7 dup (0)
		db	3, 0
		db	11 dup (0)
		db	3, 0
		db	30 dup (0)
		db	 03h, 00h, 00h, 00h, 00h, 03h
		db	 00h, 00h, 00h, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh
		db	 3Fh, 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	34 dup (0)
		db	0C0h, 00h, 00h
		db	25 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	23 dup (0)
		db	 55h, 50h, 00h, 00h, 00h, 00h
		db	 54h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h
		db	 55h, 54h
		db	24 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 05h, 00h
		db	 00h
		db	17 dup (0)
		db	 14h, 14h, 00h, 00h, 00h, 00h
		db	 14h
		db	7 dup (0)
		db	 54h, 00h, 00h, 00h, 01h, 40h
		db	20 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 00h, 00h, 05h, 00h
		db	 00h, 00h, 80h, 00h, 00h
		db	13 dup (0)
		db	 14h, 14h, 51h, 50h, 15h, 40h
		db	 14h, 14h, 15h, 40h, 55h, 40h
		db	 00h, 00h, 54h, 00h, 15h, 01h
		db	 51h, 40h
		db	20 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 05h, 00h
		db	 00h
		db	17 dup (0)
		db	 15h, 50h, 15h, 14h, 50h, 50h
		db	 14h, 50h, 50h, 50h, 50h, 50h
		db	 00h, 00h, 55h, 50h, 15h
		db	 45h, 40h
		db	21 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	23 dup (0)
		db	 14h, 14h, 14h, 14h, 50h, 50h
		db	 15h, 40h, 55h, 50h, 50h, 50h
		db	 00h, 00h, 54h, 05h, 05h
		db	55h
		db	22 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	22 dup (0)
		db	 14h, 14h, 14h, 00h, 50h, 50h
		db	 14h, 50h, 50h, 00h, 50h, 50h
		db	 00h, 00h, 54h, 05h, 00h, 54h
		db	 01h, 40h, 00h
		db	19 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	7 dup (0)
		db	 80h, 00h, 00h
		db	13 dup (0)
		db	 55h, 50h, 55h, 00h, 15h, 40h
		db	 54h, 14h, 15h, 40h, 50h, 50h
		db	 00h, 00h, 55h, 54h, 15h, 50h
		db	 01h
		db	40h
		db	20 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	35 dup (0)
		db	 01h, 40h, 00h, 55h, 40h
		db	22 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	13 dup (0)
		db	 15h, 54h, 05h, 55h, 05h, 05h
		db	 05h, 50h, 05h, 54h, 05h, 55h
		db	 01h, 55h, 00h, 15h, 55h, 50h
		db	 55h, 55h, 50h, 05h, 40h, 05h
		db	 40h,0AAh,0AAh, 81h, 55h, 50h
		db	 15h, 54h, 71h,0FCh, 7Fh, 00h
		db	 00h, 00h, 00h, 00h, 88h, 00h
		db	 00h
		db	7 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 50h, 05h
		db	 00h, 00h, 00h, 00h, 00h, 70h
		db	 00h, 00h, 15h, 05h, 05h, 05h
		db	 05h, 55h, 05h, 14h, 15h, 05h
		db	 05h, 40h, 05h, 41h, 40h, 15h
		db	 55h, 50h, 55h, 55h, 50h, 05h
		db	 40h, 05h, 40h,0A8h, 0Ah, 81h
		db	 55h, 50h, 15h, 00h, 11h, 8Ch
		db	 63h, 00h, 00h, 00h, 00h, 00h
		db	0A8h, 00h, 00h
		db	7 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 00h, 00h, 50h, 05h
		db	 00h, 00h, 00h, 00h, 00h, 30h
		db	 00h, 00h, 15h, 05h, 05h, 05h
		db	 05h, 55h, 05h, 14h, 15h, 05h
		db	 05h, 40h, 05h, 41h, 40h, 15h
		db	 05h, 00h, 01h, 50h, 00h, 05h
		db	 40h, 05h, 40h,0A8h, 0Ah, 81h
		db	 50h, 50h, 15h, 00h, 01h, 8Ch
		db	 63h, 00h, 00h, 00h, 00h, 00h
		db	20h
		db	9 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 50h, 05h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 54h, 05h, 55h
		db	 05h, 05h, 05h, 50h, 15h, 05h
		db	 05h, 55h, 05h, 41h, 40h, 15h
		db	 55h, 40h, 01h, 50h, 00h, 05h
		db	 40h, 05h, 40h,0AAh,0AAh, 81h
		db	 50h, 50h, 15h, 50h, 01h,0FCh
		db	63h
		db	15 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 00h, 00h, 50h, 05h
		db	8 dup (0)
		db	 15h, 28h, 05h, 05h, 05h, 05h
		db	 05h, 14h, 15h, 05h, 00h, 15h
		db	 05h, 41h, 40h, 15h, 55h, 40h
		db	 01h, 50h, 00h, 05h, 45h, 45h
		db	 40h,0A8h, 0Ah, 81h, 55h, 40h
		db	 15h, 00h, 01h, 8Ch, 7Fh, 00h
		db	14 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 50h, 05h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 14h, 05h, 05h
		db	 05h, 05h, 05h, 14h, 15h, 05h
		db	 00h, 15h, 05h, 41h, 40h, 15h
		db	 00h, 00h, 01h, 50h, 00h, 05h
		db	 55h, 55h, 40h,0A8h, 0Ah, 81h
		db	 51h, 50h, 15h, 00h, 01h, 8Ch
		db	 03h, 00h
		db	14 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 00h, 00h, 50h, 05h
		db	8 dup (0)
		db	 15h, 0Ah, 05h, 05h, 05h, 05h
		db	 05h, 50h, 05h, 54h, 05h, 55h
		db	 01h, 55h, 00h, 15h, 00h, 00h
		db	 01h, 50h, 00h, 05h, 50h, 15h
		db	 40h,0A8h, 0Ah, 81h, 50h, 54h
		db	 15h, 54h, 01h,0FCh,0FFh, 00h
		db	14 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	52 dup (0)
		db	 0Ch, 00h
		db	9 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h
		db	0Ch
		db	55 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	60 dup (0)
		db	 0Ch, 00h, 00h, 0Fh, 3Fh, 3Fh
		db	0F0h,0F3h,0F3h,0FFh, 00h
		db	62 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	63 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 03h, 00h
		db	19 dup (0)
		db	2, 0
		db	37 dup (0)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh
		db	24 dup (0)
		db	 02h, 80h, 00h, 00h
		db	16 dup (0)
		db	2, 0
		db	15 dup (0)
		db	 20h, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 00h
		db	24 dup (0)
		db	0A0h, 00h, 00h
		db	16 dup (0)
		db	 02h,0A0h, 00h, 00h
		db	13 dup (0)
		db	 08h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh
		db	 3Fh, 3Fh
		db	24 dup (0)
		db	 0Ah,0A0h, 00h, 00h
		db	17 dup (0)
		db	0A0h, 00h, 00h
		db	13 dup (0)
		db	 0Ah, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 00h
		db	7 dup (0)
		db	 0Ch, 00h, 00h, 05h, 55h,0F5h
		db	 40h, 00h, 00h, 0Ch, 00h, 00h
		db	 00h, 00h, 08h, 00h
		db	 20h, 08h, 20h
		db	13 dup (0)
		db	0C0h, 00h, 00h, 02h, 00h, 08h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 0Ch, 00h, 00h, 00h, 00h
		db	 00h, 00h, 20h, 02h, 80h, 0Fh
		db	0F3h,0F3h,0F0h,0FFh
		db	 3Fh, 3Fh
		db	11 dup (0)
		db	 55h, 55h,0FFh,0D4h
		db	7 dup (0)
		db	 2Ah, 00h, 00h, 00h, 28h, 00h
		db	15 dup (0)
		db	 02h, 80h, 0Ah, 80h
		db	11 dup (0)
		db	 02h, 00h,0A0h, 02h, 80h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	 00h
		db	9 dup (0)
		db	 05h,0FFh, 3Fh,0C4h,0FDh, 40h
		db	 00h, 00h, 00h, 00h, 00h, 02h
		db	 0Ah, 80h, 00h, 00h, 0Ah, 00h
		db	 00h, 00h, 00h, 00h
		db	0Ch
		db	12 dup (0)
		db	 0Ah, 80h, 00h, 00h
		db	10 dup (0)
		db	 80h, 00h, 02h, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh
		db	 3Fh, 3Fh
		db	10 dup (0)
		db	 1Fh,0F2h, 3Ch, 3Fh,0FFh,0D4h
		db	 00h, 00h, 00h, 00h, 00h, 08h
		db	 0Ah,0A0h, 08h, 00h, 02h, 80h
		db	 00h, 00h
		db	10 dup (0)
		db	 08h, 00h, 00h, 00h, 02h, 02h
		db	0A0h, 00h, 00h
		db	10 dup (0)
		db	 20h, 00h, 00h, 00h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	 00h, 00h, 00h, 00h,0C0h, 00h
		db	 00h, 00h, 00h,0FCh, 00h, 00h
		db	 00h, 03h,0D5h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 28h, 0Ah
		db	 00h, 80h, 80h, 00h, 00h, 00h
		db	9 dup (0)
		db	 02h, 00h, 00h, 00h, 02h, 02h
		db	0AAh
		db	11 dup (0)
		db	 20h, 28h, 00h, 00h, 00h, 0Fh
		db	0F3h,0F3h,0F0h,0FFh
		db	 3Fh, 3Fh
		db	10 dup (0)
		db	 50h,0FFh, 03h,0F0h, 3Ch,0FDh
		db	 00h, 00h, 08h, 00h, 00h, 00h
		db	 00h, 88h, 0Ah, 80h, 20h, 28h
		db	 80h, 00h, 00h
		db	10 dup (0)
		db	0A0h, 00h, 20h, 02h, 82h, 22h
		db	 80h
		db	10 dup (0)
		db	 20h, 20h, 00h, 00h, 00h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	 00h
		db	9 dup (0)
		db	 53h,0F2h, 0Fh, 20h,0F3h,0DFh
		db	0C0h, 00h, 02h, 00h, 00h, 00h
		db	 00h, 20h, 2Ah, 00h, 02h,0A8h
		db	 80h, 00h
		db	7 dup (0)
		db	 20h, 00h, 00h, 80h, 20h, 00h
		db	0A0h, 00h, 80h, 20h, 20h, 03h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 30h, 20h, 08h, 00h, 20h
		db	 00h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh
		db	 3Fh, 3Fh
		db	10 dup (0)
		db	 55h, 42h, 20h, 22h, 3Fh,0D5h
		db	 00h, 02h, 02h, 80h, 08h, 00h
		db	 00h, 0Ah,0AAh, 80h, 00h, 82h
		db	0A8h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 08h, 00h,0A8h, 20h, 00h
		db	0A0h, 00h, 00h, 08h, 00h, 00h
		db	 20h, 08h, 00h, 00h, 00h, 28h
		db	 00h, 00h, 00h, 00h, 00h, 28h
		db	 2Ah, 0Ah, 28h,0A0h, 00h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	 00h
		db	9 dup (0)
		db	 55h, 50h, 3Ch, 3Fh,0CFh,0FCh
		db	 00h, 00h, 80h, 80h, 08h, 00h
		db	 00h, 02h, 0Ah, 28h, 00h, 00h
		db	 0Ah, 00h, 00h, 00h, 00h, 00h
		db	 00h,0A0h, 00h, 28h, 28h, 00h
		db	 00h, 00h, 00h, 02h, 00h, 00h
		db	 08h, 0Ah, 08h, 02h, 02h, 82h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 20h, 00h, 00h, 08h, 00h, 0Fh
		db	0F3h,0F3h,0F0h,0FFh
		db	 3Fh, 3Fh
		db	10 dup (0)
		db	 05h, 5Fh, 04h, 5Fh,0FDh, 40h
		db	 02h, 00h, 00h,0A0h, 02h, 80h
		db	 20h, 00h, 00h, 0Ah, 00h, 00h
		db	 02h,0A0h, 00h, 00h, 02h, 80h
		db	 00h, 08h, 08h,0A2h, 80h, 00h
		db	 00h, 02h, 00h, 02h, 80h, 80h
		db	 02h, 08h, 02h, 08h, 02h, 80h
		db	0A0h, 00h, 00h, 00h, 28h, 00h
		db	 00h, 00h, 00h, 02h, 00h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	 00h, 08h, 00h, 00h, 00h, 00h
		db	 00h, 80h, 00h, 00h, 00h, 5Fh
		db	0FCh, 55h, 54h, 00h, 00h,0A0h
		db	 00h, 00h, 0Ah,0A0h, 28h, 00h
		db	 00h, 00h, 00h, 00h, 02h,0A2h
		db	 82h, 00h,0A8h, 88h, 00h, 00h
		db	0AAh, 80h, 80h, 80h, 00h, 00h
		db	 80h, 00h, 20h, 08h, 00h,0A0h
		db	 02h,0A8h, 0Ah, 80h,0AAh, 00h
		db	 00h, 0Ah,0A0h, 0Ah, 00h, 00h
		db	 00h, 00h, 00h, 0Fh,0F3h,0F3h
		db	0F0h,0FFh, 3Fh, 3Fh, 00h, 28h
		db	 00h, 00h, 00h, 00h, 02h,0A0h
		db	 00h, 00h, 00h, 00h,0F0h, 54h
		db	 00h, 00h, 00h,0A0h, 02h, 80h
		db	 0Ah, 8Ah, 00h, 20h, 00h, 00h
		db	 08h, 00h, 00h,0AAh, 0Ah, 80h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 00h, 20h, 2Ah, 00h, 20h, 00h
		db	 00h, 02h, 02h, 80h, 0Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 3Bh,0FEh
		db	0BCh, 02h, 80h,0AAh,0BEh,0AAh
		db	0AFh,0CFh, 3Fh, 3Fh,0F0h,0F3h
		db	0F3h,0FFh, 00h, 0Ah, 00h, 08h
		db	 00h, 20h, 02h,0A8h, 00h, 00h
		db	 00h, 4Ch, 00h, 00h, 00h, 40h
		db	 00h, 28h, 00h,0A0h, 0Ah, 02h
		db	0A0h, 08h, 00h, 00h, 0Ah, 80h
		db	 00h,0A0h, 8Ah, 82h, 80h, 00h
		db	 00h, 00h, 00h, 02h,0A0h, 08h
		db	 0Ah, 8Ah, 82h,0A8h, 02h,0AAh
		db	0AAh,0AAh,0AAh,0A0h
		db	 20h, 0Ah
		db	10 dup (0AAh)
		db	0A8h, 0Fh,0F3h,0F3h,0F0h,0FFh
		db	 3Fh, 3Fh, 00h, 02h, 00h, 0Ah
		db	 02h, 80h, 20h, 2Ah, 20h, 00h
		db	 00h, 4Fh,0F0h, 57h, 03h,0C0h
		db	 80h, 0Ah, 00h, 08h, 02h, 80h
		db	0A8h, 0Ah, 00h, 00h, 08h,0A8h
		db	 00h,0A0h, 00h,0A2h, 00h, 00h
		db	0FFh,0FFh,0F0h, 00h,0A8h, 22h
		db	 00h,0A0h, 00h, 2Ah,0AAh,0AAh
		db	0A8h, 00h, 00h, 20h, 00h, 00h
		db	 02h,0A8h,0A0h, 00h, 2Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	 00h, 02h, 88h, 02h, 00h, 80h
		db	 20h, 00h,0AAh, 00h, 00h, 4Fh
		db	0F0h, 57h, 03h,0C0h,0A2h, 00h
		db	 80h, 00h, 00h,0A0h, 2Ah, 20h
		db	 80h, 00h, 00h, 00h, 02h, 88h
		db	 00h, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 02h, 0Ah, 80h, 2Ah
		db	0AAh,0AAh,0AAh,0A0h, 00h, 00h
		db	 02h, 0Ah, 00h, 02h, 80h,0A0h
		db	 80h, 02h,0A0h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh,0F3h,0F3h
		db	0F0h,0FFh, 3Fh, 3Fh, 02h, 00h
		db	 88h, 00h, 00h, 00h, 00h, 08h
		db	 00h, 02h, 00h, 4Fh,0F0h, 57h
		db	 03h,0C0h, 20h, 80h, 00h, 00h
		db	 28h, 80h, 02h, 00h, 28h, 00h
		db	 00h, 00h, 00h, 02h, 00h, 00h
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h, 00h,0AAh, 00h, 00h, 08h
		db	 00h, 0Ah, 80h, 00h, 00h, 00h
		db	 80h, 00h,0A0h,0A2h, 02h,0AAh
		db	7 dup (0)
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 0Ah, 00h, 0Ah, 00h, 00h
		db	 00h, 00h, 0Ah, 02h, 0Ah, 00h
		db	 4Fh,0F0h, 57h, 03h,0C0h, 00h
		db	 20h, 00h, 00h, 00h, 28h, 02h
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	0AAh,0A0h, 02h, 00h, 00h,0A0h
		db	 00h, 00h, 00h,0A0h, 00h, 00h
		db	 28h, 2Ah, 80h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh, 22h
		db	 00h, 0Ah, 02h, 28h, 00h, 08h
		db	 02h, 00h,0AAh, 20h, 4Fh,0F0h
		db	 57h, 03h,0C0h, 00h, 00h, 00h
		db	 00h, 00h, 0Ah, 80h, 00h, 00h
		db	 03h,0FFh,0FFh,0F0h, 00h, 01h
		db	5Fh
		db	7 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h,0A0h
		db	 00h, 2Ah, 2Fh,0FFh,0AAh,0ABh
		db	0F0h, 00h, 2Ah,0AFh,0FFh,0FEh
		db	0ABh,0FEh,0AFh,0FEh,0BFh,0BAh
		db	 8Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 2Ah, 00h, 02h, 80h, 20h
		db	 00h, 8Ah, 00h, 00h,0A8h, 00h
		db	 4Fh,0F0h, 57h, 03h,0C0h
		db	8 dup (0)
		db	 0Fh,0FFh,0FFh,0FFh,0D5h, 40h
		db	 15h,0FFh,0FFh,0FFh,0FFh, 55h
		db	 55h, 55h, 7Fh,0F0h, 00h, 00h
		db	 00h, 00h, 2Ah, 0Ah,0AAh,0AAh
		db	0AAh
		db	14 dup (0AAh)
		db	 8Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 0Ah, 08h, 00h, 20h, 00h
		db	 02h, 2Ah, 80h, 20h, 28h, 00h
		db	 4Fh,0F0h, 57h, 00h, 41h, 5Fh
		db	0FFh, 00h, 00h, 00h, 00h, 00h
		db	 00h,0FFh, 55h, 55h, 55h, 54h
		db	 01h, 5Fh,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h, 00h, 55h,0FFh, 00h
		db	 00h, 2Ah,0AAh,0AAh,0A8h, 00h
		db	 02h,0AAh,0AAh,0A2h, 0Ah,0A8h
		db	 00h, 00h, 00h, 2Ah, 00h, 00h
		db	 8Ah,0A8h, 00h, 00h, 8Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 02h
		db	 0Ah, 02h, 08h, 00h, 0Ah, 00h
		db	0ACh, 88h, 00h, 00h, 4Fh,0F0h
		db	 57h, 00h, 41h, 5Fh,0FFh,0FDh
		db	 55h, 40h, 00h, 55h, 55h,0F5h
		db	 55h, 55h, 54h, 00h, 05h,0FFh
		db	0FFh,0FFh,0FFh, 03h,0FFh,0FFh
		db	0F0h, 01h, 5Fh,0C0h,0AAh,0AAh
		db	0AAh,0AAh, 80h, 00h, 00h, 2Ah
		db	 80h, 00h, 02h,0AAh,0AAh, 80h
		db	 00h, 00h, 00h, 00h, 20h, 02h
		db	0A0h, 80h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 00h, 02h, 02h
		db	 82h,0A0h, 0Ah, 00h, 0Ah, 80h
		db	 01h, 50h, 4Fh,0F0h, 5Fh, 00h
		db	 41h, 55h, 5Fh,0FFh,0D4h, 00h
		db	 55h, 55h, 55h, 00h, 01h, 55h
		db	 50h, 00h, 4Fh,0FFh,0FFh,0CFh
		db	0F0h, 3Fh,0FFh,0FFh, 3Fh,0C0h
		db	 15h,0F0h, 00h, 00h, 0Ah,0AAh
		db	0AAh, 00h, 00h, 0Ah, 00h, 00h
		db	 00h, 00h, 0Ah,0AAh,0AAh, 2Ah
		db	 00h, 00h, 20h, 00h, 00h, 2Ah
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 80h, 80h,0AAh
		db	 28h, 02h, 00h, 01h, 55h, 50h
		db	 4Fh,0F0h, 5Fh, 00h, 4Fh,0D5h
		db	 40h, 05h, 40h, 05h, 55h,0FDh
		db	 55h, 40h, 00h, 15h, 40h, 04h
		db	0FFh,0FFh,0FCh,0FFh,0C3h,0FFh
		db	0F5h, 7Fh,0CFh,0FCh, 05h, 7Ch
		db	 00h, 2Ah,0AAh, 80h, 00h,0A0h
		db	 00h, 02h, 80h, 00h, 00h, 00h
		db	 00h, 02h,0A0h, 00h,0A0h, 00h
		db	 02h, 00h, 00h, 0Ah, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh, 00h
		db	 00h, 00h, 20h,0AAh,0E8h, 2Ah
		db	 00h, 55h,0FFh,0D0h, 4Fh,0F0h
		db	 5Fh, 00h, 4Fh, 00h, 00h, 01h
		db	 00h, 1Fh,0CFh,0CFh,0FFh,0FCh
		db	 00h, 00h, 00h, 4Fh,0FFh,0FFh
		db	0CFh,0CCh, 0Fh,0FFh,0FFh, 5Fh
		db	0F3h,0FFh, 01h, 5Fh, 02h,0A8h
		db	 00h, 00h, 00h, 28h, 00h, 00h
		db	 80h, 05h, 00h, 00h, 00h, 00h
		db	0A2h, 00h, 2Ah, 80h, 00h, 80h
		db	 00h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4F00	proc	near
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 0Ah, 00h,0A0h, 20h, 02h
		db	 00h, 00h, 05h, 55h,0FFh,0C0h
		db	 4Fh,0F0h, 5Fh, 00h, 00h, 00h
		db	 00h, 00h, 05h,0FCh,0FDh,0FCh
		db	0FFh,0FFh, 00h, 00h, 04h,0FCh
		db	0FCh,0FCh,0FCh,0F0h,0FFh,0FFh
		db	0FFh,0D7h,0FCh,0FFh,0C0h, 57h
		db	0C0h, 2Ah,0AAh, 00h, 00h, 02h
		db	 00h, 00h, 00h, 54h, 00h, 00h
		db	 00h, 00h, 00h, 80h, 2Ah,0AAh
		db	0AAh, 00h, 00h, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh, 2Ah
		db	0AAh,0AAh,0AAh, 8Ah,0A8h, 00h
		db	 55h, 5Fh,0FFh, 00h, 4Fh,0F0h
		db	 5Fh, 00h, 00h,0DFh,0FFh, 00h
		db	 0Fh,0D5h, 55h, 5Fh,0CFh,0FFh
		db	0C0h, 00h, 0Fh,0CFh,0CFh,0CFh
		db	0CFh,0C3h,0F0h,0FFh,0FFh,0F5h
		db	0FFh, 0Fh,0F0h, 15h,0F0h, 00h
		db	0AAh,0AAh,0A8h, 00h, 80h, 00h
		db	 05h, 54h, 02h, 80h, 00h, 00h
		db	 00h, 20h, 00h,0AAh,0AAh,0AAh
		db	 20h, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 28h, 00h, 2Ah
		db	0ABh,0FFh, 00h, 15h, 55h,0FFh
		db	0F0h, 00h, 4Fh,0F0h, 5Fh, 00h
		db	 0Fh, 7Ch,0FCh, 00h,0FCh, 04h
		db	 04h, 05h, 44h,0FFh,0FCh, 00h
		db	 44h,0FCh,0FCh,0FCh,0FFh, 0Fh
		db	0FFh,0FFh,0FFh,0FDh, 7Fh,0F3h
		db	0FCh, 05h, 7Ch, 00h, 00h, 2Ah
		db	0AAh,0AAh, 80h, 00h, 15h, 50h
		db	 00h, 28h, 00h, 00h, 00h, 20h
		db	 00h, 02h,0AAh, 00h, 0Ah, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 2Ah,0AAh, 00h, 0Fh,0A8h
		db	 01h, 55h, 5Fh,0FFh,0C0h, 05h
		db	 4Fh,0F0h, 50h, 00h, 34h, 4Fh
		db	0C0h, 0Fh,0C0h, 40h, 40h, 40h
		db	 5Fh,0CFh,0FCh, 00h, 4Fh,0CFh
		db	0CFh,0CFh,0CCh, 3Fh, 3Fh,0FFh
		db	0FFh,0FFh, 5Fh,0FCh,0FFh, 01h
		db	 5Fh, 00h, 00h, 00h, 2Ah,0AAh
		db	0A8h, 01h, 55h, 40h, 00h, 00h
		db	 04h, 00h, 00h, 08h, 00h, 00h
		db	 00h,0A0h, 02h, 20h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 2Fh
		db	0EAh,0AAh,0AAh, 80h, 15h, 5Fh
		db	0FFh,0FCh,0F0h, 15h, 4Fh,0F0h
		db	 40h, 03h,0C0h,0FCh,0F0h, 04h
		db	 04h, 04h, 04h, 04h, 15h,0FFh
		db	0F0h, 04h,0FDh,0FCh,0FDh,0FCh
		db	0F0h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0F5h,0FFh, 3Fh,0C0h, 57h,0C0h
		db	 2Ah,0AAh,0AAh,0AAh, 00h, 05h
		db	 55h, 00h, 00h, 00h, 54h, 00h
		db	 2Ah,0AAh, 00h, 00h, 00h, 0Ah
		db	0AAh,0AAh, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 2Ah,0A0h, 00h
		db	0A0h, 01h, 55h, 5Fh,0FFh,0CFh
		db	 00h, 55h, 4Fh,0F0h, 00h, 3Ch
		db	 41h, 54h, 00h, 04h, 40h, 40h
		db	 40h, 41h, 45h, 5Fh,0C0h, 0Fh
		db	0D5h, 55h, 55h, 54h,0C3h,0FFh
		db	 3Fh,0FFh,0FFh,0FFh,0FDh, 7Fh
		db	0CFh,0F0h, 15h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 25h, 54h, 02h
		db	0A0h, 01h, 50h, 2Ah,0A8h, 2Ah
		db	0AAh, 00h, 00h, 02h,0A0h, 08h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 00h, 00h, 00h, 15h
		db	0FCh,0FFh,0FCh,0FCh, 00h, 55h
		db	 4Fh,0F0h, 00h,0C4h, 05h, 40h
		db	 00h, 44h, 04h, 00h, 00h, 04h
		db	 15h, 54h, 00h,0FDh, 55h, 55h
		db	 55h,0FFh, 0Fh,0F3h,0F3h,0FCh
		db	0FCh,0FFh,0FFh, 5Fh,0F3h,0FCh
		db	 05h, 7Ch, 00h, 00h, 00h, 00h
		db	 00h,0A9h, 50h, 00h, 20h, 15h
		db	 50h, 02h, 00h, 02h,0AAh, 80h
		db	 00h, 00h, 88h, 28h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh, 0Fh
		db	0E0h, 00h, 01h, 5Fh,0CFh,0FFh
		db	0CFh,0CFh, 00h, 55h, 47h,0C0h
		db	 0Fh, 40h, 45h, 40h, 00h, 40h
		db	 40h, 00h, 00h, 00h, 45h, 54h
		db	 01h, 55h, 55h, 55h,0FFh,0FFh
		db	 3Fh, 3Fh, 3Fh,0FFh,0FFh,0FFh
		db	0FFh,0D7h,0FCh, 3Fh, 01h, 5Fh
		db	 00h, 00h, 00h, 00h, 30h,0AAh
		db	 80h, 00h, 00h, 55h, 40h, 00h
		db	 20h, 00h, 00h, 2Ah,0A8h, 00h
		db	 2Ah,0A0h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 00h, 0Ah,0A0h
		db	 05h,0FCh,0FFh,0F5h,0FCh, 44h
		db	 40h, 15h, 47h, 00h, 3Ch, 04h
		db	 04h, 00h, 04h, 04h, 00h, 00h
		db	 00h, 00h, 15h, 54h, 05h, 55h
		db	 55h,0FFh,0F5h, 44h, 3Fh,0CFh
		db	0F0h,0F3h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0C0h, 57h,0C0h, 00h
		db	 00h, 00h,0F0h, 2Ah, 00h, 00h
		db	 02h, 55h, 40h, 00h, 20h, 00h
		db	 00h, 0Ah, 0Ah, 00h, 0Ah, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 03h,0F0h, 55h, 4Fh
		db	0DFh,0D5h, 40h, 4Fh,0C0h, 00h
		db	 00h, 00h,0D0h, 40h, 54h, 00h
		db	 14h, 40h, 00h, 15h, 55h, 55h
		db	 55h, 40h, 05h, 55h,0FFh,0F5h
		db	 55h, 4Ch,0FCh,0F0h,0FFh,0FFh
		db	0CFh,0FFh,0FFh,0FFh,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 03h
		db	0F0h, 00h, 00h, 00h, 0Ah, 55h
		db	 00h, 00h, 0Ah, 00h, 00h, 00h
		db	0AAh,0A0h, 08h, 00h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	0AAh, 01h, 55h,0FDh, 55h, 54h
		db	 04h, 04h,0F0h, 00h, 00h, 0Fh
		db	 44h, 04h, 14h, 00h, 14h, 00h
		db	 05h,0FCh,0FCh,0FFh,0FFh,0C0h
		db	 15h,0FFh,0F0h, 55h, 55h, 4Ch
		db	0FCh, 3Fh,0CCh, 3Fh,0FCh,0FFh
		db	0FFh,0F0h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 0Fh,0FCh, 00h
		db	 00h, 00h, 0Ah, 94h, 02h, 00h
		db	 00h, 80h, 00h, 00h, 20h,0AAh
		db	0A2h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 00h, 00h, 05h
		db	 5Fh,0C5h, 55h, 40h, 40h, 44h
		db	 4Fh,0FFh,0FFh,0FCh, 40h, 40h
		db	 54h, 00h, 50h, 00h, 5Fh,0CFh
		db	0CFh,0CFh,0FFh,0F0h, 1Fh,0F0h
		db	 55h, 55h, 45h, 4Ch,0F3h, 0Ch
		db	0F3h,0FCh, 3Fh,0F0h,0FFh, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0C0h, 3Fh,0FDh, 40h,0FFh, 03h
		db	 02h,0A8h, 00h, 80h, 00h, 00h
		db	 00h, 00h, 00h,0A0h, 0Ah, 80h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 3Fh,0C0h, 15h,0FCh,0FDh
		db	 54h, 04h, 04h, 04h,0FCh,0FCh
		db	0FCh, 04h, 04h, 00h, 54h, 00h
		db	 40h, 05h,0FCh,0FCh,0FCh,0FCh
		db	0FFh,0F0h, 50h, 45h, 55h, 54h
		db	 05h, 0Ch,0F0h,0C0h, 3Ch, 3Fh
		db	0CFh,0FFh,0F0h,0FFh,0FFh,0C0h
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	0D5h, 00h, 00h, 0Fh,0C0h,0A0h
		db	 00h,0A8h, 00h, 00h, 00h, 00h
		db	 00h
		db	28h
data_c_528C	dw	0A002h			; Data table (indexed access)
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 3Ch, 00h, 5Fh,0CFh, 55h
		db	 40h, 40h, 40h, 40h, 44h, 4Fh
		db	0C0h, 40h, 40h, 41h, 40h, 00h
		db	 40h, 5Fh,0CFh,0C0h, 44h, 4Fh
		db	0DFh,0F0h, 05h, 55h, 55h, 40h
		db	 40h, 4Ch,0F0h, 00h,0C3h, 0Ch
		db	0F0h,0FFh, 0Fh,0FFh,0FCh, 00h
		db	 00h, 00h, 00h, 00h, 03h,0FDh
		db	 54h, 00h, 00h, 3Fh,0D0h, 00h
		db	 20h,0AAh, 08h,0AAh, 88h,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	 01h,0FCh,0FDh, 54h, 04h, 04h
		db	 04h, 04h, 04h, 04h, 44h, 00h
		db	 04h, 05h, 40h, 01h, 04h,0FCh
		db	 44h, 04h, 04h, 04h, 54h,0F0h
		db	 55h, 55h, 04h, 04h, 04h, 0Ch
		db	0F0h, 0Ch, 33h,0CFh, 0Fh,0F0h
		db	0FFh,0FFh,0F0h, 00h,0FFh,0FFh
		db	0FFh,0F0h, 0Fh,0FDh, 50h, 05h
		db	 50h,0FFh,0D5h, 00h,0A8h,0AAh
		db	 00h, 2Ah,0A0h, 80h, 00h, 00h
		db	 00h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 00h, 05h, 4Fh
		db	0D5h, 55h, 55h, 55h, 55h, 54h
		db	 40h, 44h, 00h, 00h, 40h, 05h
		db	 40h, 01h, 1Fh,0C0h
		db	'@@@@E@U@@@'
		db	0FFh,0CCh,0F0h, 03h, 00h, 30h
		db	0FFh, 0Fh,0FFh,0FFh, 00h,0FFh
		db	0FFh,0FFh,0FFh,0C0h, 3Fh,0D5h
		db	 40h, 00h, 03h,0FDh, 54h, 00h
		db	 02h, 02h,0AAh, 0Ah,0A0h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	 14h,0FDh
		db	7 dup (55h)
		db	 44h, 04h, 00h, 00h, 05h, 00h
		db	 05h, 14h,0FCh, 04h, 04h, 04h
		db	 04h, 15h, 00h, 04h, 04h, 04h
		db	 04h,0FCh,0FCh,0FCh, 00h, 33h
		db	 00h
data_c_538A	dw	0FFFCh			; Data table (indexed access)
		db	0FFh,0FCh, 03h,0FDh, 55h, 55h
		db	 55h, 00h,0DDh, 55h, 00h, 00h
		db	 0Fh,0FDh, 50h, 00h, 08h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0FFh
		db	0FFh,0FFh, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 00h, 5Fh,0D5h
		db	 55h, 55h, 5Fh,0CFh,0CFh,0CFh
		db	0C5h, 50h, 00h, 00h, 00h, 05h
		db	 00h, 05h, 5Fh,0C0h, 40h, 40h
		db	 40h, 40h, 55h, 00h,0FFh,0F0h
		db	 40h, 4Fh,0DFh,0CCh,0FFh,0C0h
		db	 00h, 3Fh,0C3h,0FFh,0FFh,0D0h
		db	 0Fh,0D5h, 51h, 50h, 00h, 01h
		db	 55h, 54h, 00h, 00h, 3Fh,0D5h
		db	 00h, 00h, 02h, 00h, 00h, 00h
		db	 00h, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0CFh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 01h, 55h, 55h,0FCh,0FCh
		db	0FCh, 44h, 44h, 44h, 45h, 55h
		db	 00h, 04h, 04h, 04h, 00h, 05h
		db	 54h, 04h, 04h, 04h, 04h, 04h
		db	 54h, 00h,0FCh,0FCh, 05h,0FCh
		db	 55h,0FFh, 0Fh,0FCh, 03h,0FCh
		db	 3Dh,0FFh,0FDh, 40h, 15h, 55h
		db	 05h, 40h, 00h, 05h, 55h, 50h
		db	 00h, 00h,0FDh, 54h, 03h, 00h
		db	0AAh,0AAh, 00h, 00h, 00h,0FFh
		db	0D5h, 55h, 55h, 55h, 4Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh, 01h
		db	 55h, 5Fh,0CFh,0C4h, 44h, 00h
		db	 00h,0FFh,0F0h, 00h, 00h, 00h
		db	 40h, 04h, 00h, 05h, 50h, 40h
		db	 40h, 00h, 00h, 00h, 54h, 00h
		db	0FFh,0C0h, 50h, 5Fh,0D5h, 5Fh
		db	0F0h,0FFh,0FFh,0F3h,0D5h, 5Fh
		db	0D5h, 00h, 55h, 50h, 41h, 40h
		db	 00h, 05h, 55h, 40h, 00h, 00h
		db	 55h, 50h, 0Fh,0C0h,0A8h, 00h
		db	 00h, 00h,0FFh,0FDh, 40h, 00h
		db	 00h, 55h, 4Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 05h, 55h,0FCh
		db	0FCh, 00h, 00h, 00h,0FFh,0F0h
		db	 00h,0FFh,0FFh,0FFh, 04h, 04h
		db	 00h, 05h, 54h, 04h, 04h, 00h
		db	 00h, 00h, 54h, 00h, 44h, 05h
		db	 00h, 55h, 40h, 15h,0FFh, 0Fh
		db	0FFh, 0Dh, 55h, 55h, 54h, 01h
		db	 55h, 04h, 05h, 40h, 00h, 01h
		db	 54h, 00h, 00h, 00h, 15h, 00h
		db	 0Fh,0F0h, 00h, 00h, 00h,0FFh
		db	0FDh, 55h, 00h, 00h, 00h, 55h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 15h, 5Fh,0C4h, 00h, 00h
		db	 40h, 0Fh,0FFh, 00h, 0Fh,0FFh
		db	0FFh,0FFh,0FFh,0C4h, 00h, 05h
		db	 40h, 40h, 40h, 00h, 15h, 40h
		db	 04h, 00h, 40h, 00h, 00h, 00h
		db	 00h, 05h, 57h,0F0h, 00h,0FDh
		db	 55h, 55h, 50h, 05h
		db	 54h, 40h, 41h, 50h
		db	8 dup (0)
		db	 15h,0FCh, 00h, 00h, 0Fh,0FFh
		db	0D5h, 54h, 00h, 00h, 01h, 54h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 15h,0FCh, 00h, 04h, 04h
		db	 00h,0FFh,0F0h, 0Fh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h, 05h
		db	 04h, 00h, 00h, 05h,0FFh,0D4h
		db	 00h, 00h, 00h, 00h, 04h, 00h
		db	 00h, 00h, 55h, 5Fh,0FFh,0D5h
		db	 55h, 54h, 00h, 15h, 54h, 04h
		db	 04h, 0Fh,0C0h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh, 54h, 00h
		db	 00h, 0Fh,0FFh,0D5h, 55h, 50h
		db	 00h, 00h, 05h, 50h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh,0DFh
		db	0C0h, 00h, 40h, 40h, 0Fh,0FFh
		db	 00h, 0Fh,0FFh,0F0h, 00h, 00h
		db	 00h, 00h, 00h,0F0h, 00h, 40h
		db	 00h, 55h, 55h,0FDh, 40h, 00h
		db	 00h, 40h, 40h, 00h, 00h, 00h
		db	 45h, 55h, 55h, 55h, 55h, 00h
		db	 00h
		db	 55h, 54h, 44h, 40h, 57h
		db	7 dup (0FFh)
		db	0FDh, 00h, 00h, 0Fh,0FFh,0D5h
		db	 55h, 55h, 40h, 00h, 00h, 15h
		db	 40h, 0Fh, 3Fh, 3Fh,0F0h,0F3h
		db	0F3h,0FFh,0C4h,0FCh, 04h, 04h
		db	 00h, 0Fh,0FFh, 00h,0FFh,0F0h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	 0Fh, 00h, 00h, 04h, 04h, 04h
		db	0FFh,0F0h, 00h, 04h, 04h, 04h
		db	 00h, 04h, 00h, 04h, 04h, 04h
		db	 05h, 00h, 00h,0FFh,0FFh,0FFh
		db	 00h, 05h
		db	'UUUUUUUUP'
		db	 00h, 00h,0FFh,0FDh, 55h, 55h
		db	 55h, 00h, 00h, 00h, 55h, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh,0CFh,0C0h, 40h, 40h, 00h
		db	0FFh,0F0h, 0Fh,0FFh,0F0h, 00h
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	0F0h, 00h, 40h, 40h, 40h, 4Fh
		db	0F0h, 00h, 40h, 40h, 44h, 00h
		db	 40h, 40h, 40h, 40h, 40h, 40h
		db	0FFh,0FFh,0F0h, 00h, 00h, 00h
		db	 05h
		db	 55h, 54h
		db	8 dup (0)
		db	0FFh,0FDh, 55h, 55h, 55h, 55h
		db	 00h, 00h, 01h, 54h, 0Ah, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	0C0h, 04h, 04h, 00h,0F0h,0FFh
		db	0F0h, 0Fh,0FFh, 00h, 0Fh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h, 04h, 04h, 04h, 0Fh,0F0h
		db	 00h, 04h, 04h, 00h, 00h, 00h
		db	 00h, 04h, 04h, 04h,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 01h
		db	50h
		db	7 dup (0)
		db	0FFh,0FFh,0D5h, 55h, 55h, 55h
		db	 55h, 7Fh,0FFh,0F5h, 50h, 2Ah
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh,0C4h, 00h, 40h, 4Fh,0F0h
		db	0FFh,0F0h, 0Fh,0F0h, 00h,0FFh
		db	0FFh,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 40h, 40h, 40h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 00h, 40h, 40h,0FFh
		db	0FFh,0F0h, 00h,0FFh,0FFh,0FFh
		db	0FFh, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 00h, 0Fh,0FFh,0D5h
		db	8 dup (55h)
		db	 40h, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 04h, 40h, 04h
		db	 0Fh,0F0h, 0Fh,0F0h, 0Fh,0F0h
		db	 00h,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h, 04h, 04h, 04h
		db	 00h, 00h, 00h, 00h, 0Fh,0FFh
		db	0F0h, 0Fh,0FFh,0F0h, 00h, 00h
		db	 0Fh,0FFh, 00h, 00h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 0Ah
		db	0AAh,0AAh, 80h, 00h, 0Fh,0FFh
		db	0D5h, 55h, 55h, 55h, 55h, 54h
		db	 00h, 00h, 00h, 44h, 00h, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h, 44h, 00h, 00h,0F0h
		db	 0Fh,0F0h, 0Fh,0F0h, 0Fh,0FFh
		db	 00h, 00h, 00h, 0Fh,0FFh,0FFh
		db	0F0h, 00h, 40h, 00h, 00h, 00h
		db	 00h, 0Fh,0F0h, 00h, 0Fh,0F0h
		db	0F0h,0F0h, 00h, 00h,0FFh,0FFh
		db	 00h, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 00h,0AAh,0A8h
		db	 00h, 0Fh,0FFh,0F5h, 55h, 55h
		db	 55h, 55h, 54h, 00h, 00h, 00h
		db	 44h, 40h, 00h, 00h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	 04h, 40h, 00h,0FFh, 0Fh,0FFh
		db	 0Fh,0F0h,0FFh,0FFh, 00h,0F0h
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	 00h,0FFh,0FFh, 0Fh, 0Fh, 00h
		db	0F0h, 00h,0FFh,0F0h, 00h,0FFh
		db	7 dup (0FFh)
		db	 00h, 2Ah, 00h, 0Fh,0FFh,0FDh
		db	 55h, 55h, 55h, 55h, 54h, 00h
		db	 00h, 00h, 44h, 40h, 00h, 00h
		db	 00h, 0Fh,0F3h,0F3h,0F0h,0FFh
		db	 3Fh, 3Fh,0C0h, 00h, 00h,0F0h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h,0F0h, 00h, 00h, 00h
		db	 00h,0FFh,0F0h, 0Fh,0FFh,0FFh
		db	0F0h, 00h,0FFh, 0Fh, 0Fh,0FFh
		db	0F0h, 0Fh
		db	8 dup (0FFh)
		db	0F0h, 00h, 00h,0FFh,0FDh, 55h
		db	 55h, 55h, 55h, 55h, 00h, 00h
		db	 00h, 44h, 40h, 00h, 00h, 00h
		db	 00h, 0Fh, 3Fh, 3Fh,0F0h,0F3h
		db	0F3h,0FFh,0A8h, 00h, 0Fh,0F0h
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 0Fh, 00h, 04h, 00h
		db	 00h,0F0h, 00h,0FFh,0FFh,0FFh
		db	 00h, 0Fh,0F0h,0FFh, 0Fh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	0DFh,0F5h, 55h, 55h, 55h, 55h
		db	 55h, 40h, 00h, 00h, 04h, 40h
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	0F3h,0F3h,0F0h,0FFh, 3Fh, 3Fh
		db	0AAh, 80h, 0Fh,0F0h, 0Fh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0F0h,0FFh
		db	0FFh,0F0h, 00h, 00h, 00h, 00h
		db	 0Fh, 00h, 40h, 00h, 0Fh, 00h
		db	 0Fh,0FFh,0FFh,0F0h, 00h,0FFh
		db	 00h,0FFh, 0Fh,0FFh,0F0h, 0Fh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h
		db	0Dh, 'UUUUUU@'
		db	 00h, 00h, 04h, 44h, 00h, 04h
		db	 00h, 00h, 2Ah,0AAh, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh,0BFh
		db	0A0h, 0Fh,0F0h, 0Fh,0FFh,0FFh
		db	0FFh,0FFh, 0Fh,0FFh, 0Fh,0FFh
		db	 00h
		db	8 dup (0)
		db	0FFh, 00h,0FFh,0FFh,0FFh, 00h
		db	 0Fh,0FFh, 0Fh,0F0h, 0Fh,0FFh
		db	0FFh, 0Fh,0FFh,0FFh,0F0h, 00h
		db	 00h, 0Fh,0FFh,0FFh,0F0h, 05h
		db	 55h, 55h, 55h, 55h, 55h, 40h
		db	 00h, 00h, 04h, 44h, 00h, 04h
		db	 44h, 00h, 2Ah,0AAh,0A0h, 0Fh
		db	0F3h,0F3h,0F0h,0FFh, 3Fh, 3Fh
		db	0BFh, 00h, 0Fh,0FFh, 0Fh,0FFh
		db	0FFh,0FFh,0F0h,0FFh,0F0h,0FFh
		db	0F0h
		db	9 dup (0)
		db	0F0h, 00h,0FFh,0FFh,0F0h, 00h
		db	0FFh,0F0h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	0D5h, 55h, 55h, 55h, 40h, 00h
		db	 00h, 04h, 44h, 00h, 04h, 44h
		db	 00h, 00h, 00h, 2Ah, 80h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	0A8h, 00h, 0Fh
		db	9 dup (0FFh)
		db	 00h, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h,0FFh,0F0h, 0Fh
		db	0FFh,0F0h, 00h, 0Fh,0FFh, 0Fh
		db	 0Fh,0FFh,0FFh,0FFh, 0Fh,0FFh
		db	0FFh,0F0h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 05h, 55h
		db	 55h, 54h, 00h, 00h, 00h, 44h
		db	 00h, 00h, 04h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh,0F3h,0F3h
		db	0F0h,0FFh, 3Fh, 3Fh,0A8h, 0Fh
		db	 00h,0FFh
		db	8 dup (0FFh)
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0F0h,0F0h, 0Fh,0FFh,0F0h, 0Fh
		db	0FFh,0F0h, 00h,0FFh,0F0h,0F0h
		db	 0Fh,0FFh,0FFh,0F0h,0FFh,0FFh
		db	0FFh,0F0h, 0Fh
		db	7 dup (0FFh)
		db	 01h, 55h, 54h, 00h, 00h, 00h
		db	 44h, 40h, 00h, 40h, 00h, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	0A8h, 0Fh, 00h
		db	9 dup (0FFh)
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 0Fh, 0Fh, 0Fh,0F0h, 0Fh
		db	0FFh, 00h, 0Fh,0FFh,0FFh, 0Fh
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h
		db	8 dup (0FFh)
		db	0C0h, 15h, 00h, 00h, 00h, 44h
		db	 40h, 00h, 44h, 40h, 00h, 00h
		db	0FFh,0FFh,0F0h, 00h, 00h, 0Fh
		db	0F3h,0F3h,0F0h,0FFh, 3Fh, 3Fh
		db	0F8h, 0Fh,0F0h, 0Fh,0FFh,0FFh
		db	0F0h,0F0h,0F0h
		db	9 dup (0FFh)
		db	0F0h,0F0h,0FFh,0FFh,0F0h, 0Fh
		db	0FFh, 00h, 0Fh,0FFh,0F0h,0F0h
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h
		db	8 dup (0FFh)
		db	0F0h, 00h, 00h, 00h, 44h, 40h
		db	 00h, 44h, 44h, 44h, 00h,0FFh
		db	0FFh,0FFh,0F0h, 00h, 00h, 0Fh
		db	 3Fh, 3Fh,0F0h,0F3h,0F3h,0FFh
		db	0C0h, 0Fh,0F0h, 0Fh,0FFh,0FFh
		db	 0Fh, 0Fh,0FFh, 0Fh
		db	8 dup (0FFh)
		db	 0Fh, 0Fh,0F0h, 0Fh,0FFh,0FFh
		db	0FFh, 00h,0FFh,0FFh,0FFh, 0Fh
		db	 00h,0FFh
		db	11 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 44h, 00h
		db	 44h, 40h, 00h, 00h, 44h, 44h
		db	 00h, 00h,0FFh,0FFh,0F0h, 00h
		db	 00h, 0Ah, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 00h, 0Fh,0FFh
		db	0FFh,0FFh,0F0h,0F0h,0FFh,0F0h
		db	0F0h,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h, 00h,0F0h, 00h,0F0h
		db	 0Fh,0FFh,0FFh,0FFh, 00h,0FFh
		db	0FFh,0F0h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0F0h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 00h, 00h, 00h
		db	 00h, 00h,0FCh, 04h, 40h, 00h
		db	 00h, 00h, 44h, 00h, 00h,0FFh
		db	0FFh,0F0h, 00h, 00h, 00h,0AAh
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 00h, 0Fh,0FFh,0FFh,0FFh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 00h, 00h, 00h,0F0h, 0Fh,0FFh
		db	0FFh,0FFh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 0Fh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 44h, 00h, 04h, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh, 00h
		db	 00h,0FFh, 00h, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh, 0Fh
		db	 00h,0FFh,0FFh,0FFh,0F0h,0F0h
		db	0F0h,0F0h,0F0h,0FFh,0FFh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0F0h, 00h,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0F0h, 00h, 0Fh,0FFh
		db	0FFh,0F0h,0F0h,0F0h,0F0h,0F0h
		db	0FFh,0FFh,0FFh,0F0h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 04h, 44h, 00h, 40h, 00h, 00h
		db	0F0h,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 0Fh, 00h, 0Fh
		db	0FFh,0FFh, 0Fh, 0Fh,0FFh, 0Fh
		db	0FFh, 0Fh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0FFh
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0FFh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 0Fh,0FFh
		db	0FFh, 00h, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 00h, 44h, 44h
		db	 00h, 40h, 00h, 0Fh, 0Fh, 00h
		db	 00h,0FFh,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 0Fh,0F0h, 0Fh,0FFh,0F0h
		db	0F0h,0F0h,0F0h,0F0h,0F0h,0F0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	0FFh,0FFh, 0Fh
		db	7 dup (0FFh)
		db	 00h, 0Fh, 00h,0FFh,0FFh,0F0h
		db	0F0h,0F0h,0F0h,0F0h,0FFh,0FFh
		db	0FFh, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 44h, 44h
		db	 44h, 40h, 00h,0F0h,0F0h,0F0h
		db	 0Fh,0FFh,0FFh,0FFh,0C0h, 00h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh, 0Fh,0FFh,0FFh,0FFh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh,0FFh, 0Fh,0FFh,0FFh,0FFh
		db	0FFh, 0Fh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 0Fh
		db	 00h,0FFh,0FFh,0FFh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh,0FFh,0FFh, 00h
		db	7 dup (0FFh)
		db	0C0h, 00h, 44h, 44h, 00h, 00h
		db	 0Fh, 0Fh, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 0Fh,0F3h,0F3h
		db	0F0h,0FFh, 3Fh, 3Fh, 0Fh,0FFh
		db	0FFh,0FFh,0F0h,0F0h,0F0h,0F0h
		db	0F0h,0F0h,0F0h,0FFh,0FFh,0FFh
		db	0F0h,0FFh,0FFh,0F0h,0F0h, 00h
		db	0FFh,0FFh,0FFh,0F0h,0F0h,0FFh
		db	0FFh, 00h,0FFh, 00h,0FFh,0FFh
		db	0F0h,0F0h,0F0h,0F0h,0F0h,0F0h
		db	10 dup (0FFh)
		db	0F0h, 00h, 44h, 00h, 00h, 00h
		db	 00h,0F0h,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h, 00h, 0Fh, 3Fh, 3Fh
		db	0F0h,0F3h,0F3h,0FFh, 00h,0FFh
		db	0FFh,0FFh, 0Fh
		db	7 dup (0Fh)
		db	0FFh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 00h, 00h, 0Fh,0FFh,0FFh, 0Fh
		db	 0Fh, 0Fh,0FFh, 00h,0F0h, 00h
		db	0FFh,0FFh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh
		db	9 dup (0FFh)
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 0Fh, 0Fh,0FFh,0FFh, 00h
		db	 00h, 00h, 00h, 0Fh,0F3h,0F3h
		db	0F0h,0FFh, 3Fh, 3Fh, 00h, 00h
		db	0FFh,0F0h
		db	7 dup (0F0h)
		db	0FFh,0FFh,0F0h,0F0h,0F0h,0F0h
		db	0F0h, 00h,0F0h, 00h,0FFh,0F0h
		db	0F0h,0F0h,0F0h,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0F0h
		db	7 dup (0F0h)
		db	9 dup (0FFh)
		db	0FCh, 00h, 00h, 00h, 00h, 00h
		db	 00h,0F0h,0FFh, 00h, 00h, 00h
		db	 0Fh,0F0h, 00h, 0Fh, 3Fh, 3Fh
		db	0F0h,0F3h,0F3h,0FFh,0F0h, 0Fh
		db	0FFh,0FFh, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh, 0Fh, 0Fh, 0Fh,0FFh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 00h,0FFh
		db	 00h,0FFh,0FFh, 0Fh, 0Fh, 0Fh
		db	 0Fh,0FFh, 0Fh,0FFh,0FFh,0FFh
		db	 0Fh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	 0Fh
		db	9 dup (0FFh)
		db	0FCh, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 0Fh,0FFh, 00h, 00h, 00h
		db	0FFh,0FCh, 00h, 0Fh,0F3h,0F3h
		db	0F0h,0FFh, 3Fh, 3Fh,0FFh,0FFh
		db	0FFh,0F0h,0F0h,0F0h,0F0h,0F0h
		db	 00h,0F0h,0F0h,0FFh,0F0h,0F0h
		db	0FFh, 00h, 00h, 00h, 0Fh,0FFh
		db	0FFh,0FFh,0F0h,0F0h,0F0h,0F0h
		db	0F0h,0FFh, 0Fh,0FFh,0FFh,0F0h
		db	7 dup (0F0h)
		db	10 dup (0FFh)
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh, 0Fh,0FFh,0FFh
		db	0FCh, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 0Fh, 0Fh, 0Fh, 02h,0A8h
		db	 0Fh, 0Fh, 0Fh,0FFh, 0Fh, 00h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0FFh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh, 0Fh,0FFh,0FFh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Fh,0FFh, 0Fh
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FFh, 15h, 55h
		db	 55h, 55h, 40h, 0Fh, 0Fh, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 0Fh,0FFh,0FFh,0F0h,0F0h
		db	0F0h,0F0h, 2Bh,0FAh, 80h,0F0h
		db	0F0h,0F0h,0FFh, 00h, 00h, 00h
		db	 00h, 00h,0FFh,0FFh,0F0h,0F0h
		db	0F0h,0F0h,0F0h,0FFh,0FFh, 0Fh
		db	0FFh,0FFh,0F0h,0F0h,0F0h, 00h
		db	 00h, 30h,0F0h,0F0h,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 55h, 55h, 50h
		db	 00h, 00h,0F0h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	0FFh,0FFh, 0Fh, 0Fh, 0Fh, 00h
		db	0AFh,0FEh,0A3h, 0Fh, 0Fh, 0Fh
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0FFh, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh, 0Fh, 0Fh, 0Fh,0FFh,0FFh
		db	 0Fh, 0Fh, 0Fh, 0Ah,0AAh, 03h
		db	 0Fh, 0Fh,0F0h,0FFh,0F0h
		db	8 dup (0)
		db	 55h, 55h, 00h, 00h, 0Fh, 0Fh
		db	 0Fh, 0Fh,0FFh,0FFh,0FFh, 00h
		db	 00h, 0Fh,0F3h,0F3h,0F0h,0FFh
		db	 3Fh, 3Fh, 00h, 0Fh,0F0h,0F0h
		db	0F0h,0F0h, 02h,0BEh,0BFh,0A0h
		db	0F0h,0F0h,0F0h,0F0h, 00h,0FFh
		db	0FFh,0F0h, 00h, 0Fh
		db	7 dup (0F0h)
		db	0FFh, 00h, 0Fh,0FFh,0F0h,0F0h
		db	0F0h, 2Bh,0FEh,0A0h,0F0h,0F0h
		db	0FFh,0FFh,0F0h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0F0h,0F0h,0FFh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh,0F0h, 00h,0FFh,0FFh, 0Fh
		db	 0Fh, 0Ah,0EAh,0ABh,0A8h, 0Fh
		db	 0Fh, 0Fh, 0Fh,0FFh,0FFh, 0Fh
		db	0F0h,0FFh, 00h, 0Fh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh,0FFh, 00h, 00h
		db	 0Fh,0F0h, 0Fh, 0Fh, 02h,0AFh
		db	0FFh,0E8h, 0Fh, 0Fh, 0Fh, 0Fh
		db	0F0h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0C0h, 00h, 00h, 00h
		db	 00h, 0Fh, 0Fh, 0Fh, 00h, 00h
		db	 00h, 00h,0FFh, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh,0FFh
		db	0FFh,0F0h,0F0h,0F0h,0F0h, 2Ah
		db	0AAh,0AAh,0E8h
		db	17 dup (0F0h)
		db	0FFh, 00h, 0Fh,0F0h,0F0h,0F0h
		db	0F2h,0BAh,0AAh,0FAh, 00h,0F0h
		db	0FFh,0FFh,0F0h,0F0h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0C0h, 00h
		db	 00h, 00h, 0Fh,0F0h,0F0h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh,0FFh,0FFh,0FFh, 0Fh,0FFh
		db	 00h, 2Ah,0AAh,0AAh,0AAh, 0Fh
		db	 0Fh, 0Fh,0FFh, 0Fh, 0Fh, 0Fh
		db	 00h,0FFh, 0Fh,0FFh, 0Fh, 0Fh
		db	 0Fh, 0Fh, 0Fh, 0Fh,0F0h, 0Fh
		db	 0Fh,0FFh, 0Fh, 0Fh, 0Ah,0AAh
		db	0AAh,0AEh, 83h, 0Fh, 0Fh
		db	9 dup (0FFh)
		db	0F0h, 00h, 00h, 00h, 0Fh, 0Fh
		db	 0Fh, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh, 0Fh,0FFh,0FFh
		db	0F0h, 00h,0F0h,0AAh,0AAh,0AAh
		db	0AAh, 30h,0F0h,0F0h,0F0h,0F0h
		db	0FFh,0FFh, 00h, 00h,0F0h,0F0h
		db	0F0h,0F0h,0F2h,0A8h,0F0h,0F0h
		db	 00h, 00h,0FFh,0F0h,0F0h,0F0h
		db	 2Ah,0AAh,0AAh,0ABh,0A0h,0F0h
		db	0F0h
		db	9 dup (0FFh)
		db	0F0h, 00h, 0Fh, 00h, 0Fh,0F0h
		db	0F0h,0F0h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh, 0Fh,0FFh,0FFh
		db	 0Fh, 0Fh, 00h,0AAh,0AAh,0AAh
		db	0AAh, 3Fh, 0Fh, 0Fh, 00h,0FFh
		db	0FFh,0F0h, 00h, 0Fh, 0Fh, 0Fh
		db	 0Fh,0FFh, 2Ah,0AAh,0BFh, 0Fh
		db	0FFh, 0Fh,0FFh,0FFh, 0Fh, 0Fh
		db	 2Ah,0AAh,0AAh,0AAh,0A8h, 0Fh
		db	 0Fh,0FFh, 0Fh, 0Fh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 03h
		db	0F3h,0F2h, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FCh, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh, 3Fh
		db	 3Fh, 00h,0FFh,0F0h,0F0h,0F0h
		db	 00h,0AAh,0AAh,0AAh,0AAh, 30h
		db	0F0h,0F0h,0FFh,0FFh,0F0h, 00h
		db	 0Fh, 00h,0F0h,0F0h,0F0h,0F0h
		db	 2Bh,0FAh,0A0h,0F0h,0F0h,0FFh
		db	0FFh,0F0h,0F0h,0F0h, 2Ah,0AAh
		db	0AAh,0AAh,0A8h, 3Fh,0F0h,0F0h
		db	0F0h,0F0h,0FFh,0FFh,0FFh,0F0h
		db	0F0h,0F0h,0F0h,0FFh, 3Fh, 3Fh
		db	 0Fh,0F0h,0F0h,0F0h,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 0Fh, 3Fh
		db	 3Fh,0F0h,0F3h,0F3h,0FFh, 00h
		db	 0Fh,0FFh, 0Fh, 0Fh,0F0h,0AAh
		db	0A8h,0AAh,0AAh, 0Fh, 0Fh, 0Fh
		db	 0Fh, 00h, 00h, 00h, 0Fh, 00h
		db	 0Fh, 0Fh, 0Fh, 00h,0AFh,0FFh
		db	0ABh, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	 0Fh, 0Fh, 2Ah,0AAh, 00h,0AAh
		db	0AAh, 0Fh, 0Fh, 0Fh, 0Fh, 0Fh
		db	0FFh,0FFh,0FFh, 0Fh, 0Fh,0FFh
		db	 03h,0F3h,0F3h,0F2h, 0Fh, 0Fh
		db	 0Fh, 0Fh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0F3h,0F3h,0F0h
		db	0FFh, 3Fh, 3Fh,0F0h, 00h,0F0h
		db	0F0h,0F0h, 00h, 8Ah, 80h, 2Ah
		db	0A2h, 30h,0F0h,0F0h,0FFh, 00h
		db	 00h, 00h, 0Fh, 00h, 0Fh,0F0h
		db	0F0h, 02h,0BFh,0FFh,0E8h,0F0h
		db	0F0h, 0Fh,0FFh,0FFh,0F0h,0F0h
		db	 20h,0A8h, 00h, 22h,0AAh, 00h
		db	0FFh,0F0h,0F0h,0F0h,0FFh,0FFh
		db	0F0h,0F0h,0F0h,0F0h, 00h, 20h
		db	 0Fh, 3Fh, 00h, 3Fh, 20h,0F0h
		db	0F0h, 00h, 0Fh,0FFh,0FFh, 00h
		db	 0Fh, 3Fh, 3Fh,0F0h,0F3h,0F3h
		db	0FFh,0FFh,0FFh,0FFh, 0Fh, 0Fh
		db	 00h, 80h, 00h, 0Ah, 82h, 0Fh
		db	 0Fh, 0Fh, 0Fh, 00h, 00h, 00h
		db	0F0h,0FFh,0FFh,0FFh, 0Fh, 02h
		db	0BAh,0AAh,0BAh, 0Fh, 0Fh, 00h
		db	 0Fh,0FFh, 0Fh, 0Fh, 20h, 20h
		db	 00h, 20h,0AAh, 3Fh, 0Fh, 0Fh
		db	 0Fh, 0Fh,0F0h, 00h, 0Fh, 0Fh
		db	 0Fh,0FFh,0F2h, 00h,0F2h, 00h
		db	0F0h,0FFh,0F3h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 00h, 0Fh,0F3h
		db	0F3h,0F0h,0FFh, 3Fh, 3Fh,0FFh
		db	0FFh,0F0h,0F0h,0F0h,0F0h,0A0h
		db	 00h, 0Ah, 02h, 30h,0F0h,0F0h
		db	0FFh, 00h, 0Fh,0FFh, 00h,0FFh
		db	0FFh,0F0h,0F0h, 0Ah,0AAh,0AAh
		db	0AAh,0BFh, 0Fh, 00h, 0Fh,0F0h
		db	0F0h,0F0h, 20h, 00h, 00h, 20h
		db	 2Ah, 00h,0FFh,0F0h,0FFh,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 20h, 3Fh, 3Fh, 3Fh, 3Fh, 00h
		db	0FFh, 3Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 0Fh, 3Fh, 3Fh,0F0h
		db	0F3h,0F3h,0FFh,0FFh,0FFh, 0Fh
		db	 0Fh, 0Fh, 00h, 20h, 00h, 00h
		db	 0Ah, 0Fh, 0Fh, 0Fh, 00h,0FFh
		db	0FFh, 0Fh, 00h, 0Fh,0FFh, 0Fh
		db	 0Fh, 0Ah,0AAh, 02h,0AAh,0B0h
		db	0F0h,0FFh,0FFh,0FFh, 0Fh, 0Fh
		db	 08h, 00h, 00h, 20h,0ABh,0FFh
		db	 0Fh, 0Fh,0F0h,0FFh,0FFh,0F0h
		db	 00h, 00h, 00h, 00h,0F0h,0F2h
		db	 03h,0F0h,0F3h,0F3h,0F0h, 03h
		db	0F0h,0F3h,0F3h,0FFh,0FCh, 00h
		db	 0Fh,0F3h,0F3h,0F0h,0FFh,0FFh
		db	0FFh,0FFh,0F0h,0F0h,0F0h,0F0h
		db	0F0h, 08h, 00h, 00h,0A8h,0F0h
		db	0F0h,0F0h,0FFh, 0Fh, 0Fh, 0Fh
		db	 00h, 00h,0F0h,0F0h,0F0h, 0Ah
		db	 80h, 00h, 2Ah, 8Fh, 0Fh, 0Fh
		db	0FFh,0F0h,0F0h,0F0h,0FAh, 00h
		db	 00h, 80h, 2Fh,0F0h,0F0h,0F0h
		db	0FFh,0F0h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 0Fh, 0Fh, 3Fh, 3Fh
		db	 3Fh, 3Fh, 0Fh, 3Fh, 3Fh, 3Fh
		db	 3Fh,0FFh,0C0h, 00h, 0Fh,0FFh
		db	0FFh,0F0h, 3Ah, 07h,0FFh,0F0h
		db	 3Ch, 00h, 00h, 00h, 00h, 3Fh
		db	0C3h,0FFh,0C0h,0F0h, 3Fh,0F0h
		db	0FFh,0F0h, 00h, 03h,0FCh, 03h
		db	0C0h,0C0h, 33h,0FFh,0C0h, 00h
		db	 00h, 00h,0FFh,0F3h,0FFh,0C0h
		db	 00h, 00h, 00h, 3Fh,0C3h,0FFh
		db	 0Fh,0FFh, 3Fh,0FCh, 3Fh,0C3h
		db	0C3h,0C0h, 00h, 0Fh,0F0h, 3Fh
		db	0C3h,0FFh, 0Fh,0FFh, 3Fh,0FCh
		db	0F0h,0F0h,0FFh,0F0h, 3Ch, 00h
		db	 3Ch, 00h, 00h,0FFh,0F3h,0FFh
		db	0C3h,0FCh, 3Fh,0FCh,0FFh,0F0h
		db	 00h, 0Fh,0FFh, 0Fh,0F0h,0F0h
		db	0F3h,0FFh,0C0h, 00h, 00h, 00h
		db	0FFh,0F0h, 03h,0C0h, 3Ch, 00h
		db	 00h,0FFh,0F3h,0FFh,0CFh,0FFh
		db	 3Fh,0FCh,0FFh,0F3h,0F3h,0C0h
		db	 00h, 3Fh,0FCh,0FFh,0F3h,0FFh
		db	0CFh,0FFh, 3Fh,0FCh,0FCh,0F0h
		db	0F0h, 00h, 3Ch, 00h, 3Ch, 00h
		db	 00h,0FCh, 00h, 3Ch, 0Fh, 0Fh
		db	 3Ch, 3Ch, 0Fh, 00h, 00h, 0Fh
		db	 00h, 3Ch, 3Ch,0FFh,0F3h,0C0h
		db	 00h, 00h, 00h, 00h,0F0h, 00h
		db	 03h,0C0h, 3Ch, 00h, 00h,0F0h
		db	0F3h,0C3h,0C0h,0F0h, 03h,0C0h
		db	0F0h,0F3h,0FFh,0C0h, 00h, 3Fh
		db	 00h,0F0h,0F3h,0C3h,0CFh, 00h
		db	 3Ch, 00h,0FFh,0F0h,0FFh,0C0h
		db	 3Ch, 00h, 00h, 00h, 00h, 3Fh
		db	0C0h, 3Ch, 0Fh, 0Fh, 3Fh,0FCh
		db	 0Fh, 00h, 00h, 0Fh, 3Fh, 3Ch
		db	 3Ch,0FFh,0F3h,0FFh, 00h, 00h
		db	 00h, 00h,0FFh,0C3h,0FFh,0C0h
		db	 00h, 00h, 00h,0F0h,0F3h,0FFh
		db	0C0h,0F0h, 03h,0C0h,0F0h,0F3h
		db	0FFh,0C0h, 00h, 0Fh,0F0h,0F0h
		db	 03h,0FFh,0CFh,0FCh, 3Fh,0F0h
		db	0FFh,0F0h,0FFh,0C0h, 3Ch, 00h
		db	 3Ch, 00h, 00h, 03h,0F0h, 3Ch
		db	 0Fh,0FFh, 3Fh,0F0h, 0Fh, 00h
		db	 00h, 0Fh, 0Fh, 3Fh,0FCh,0F0h
		db	0F3h,0C0h, 00h, 00h, 00h, 00h
		db	0FFh,0C3h,0C0h, 00h, 3Ch, 00h
		db	 00h,0F0h,0F3h,0FFh, 00h,0F0h
		db	 03h,0C0h,0F0h,0F3h,0FFh,0C0h
		db	 00h, 00h,0FCh,0F0h,0F3h,0FFh
		db	 0Fh, 00h, 3Ch, 00h,0FFh,0F0h
		db	0F0h, 00h, 3Ch, 00h, 3Ch, 00h
		db	 00h,0FFh,0F0h, 3Ch, 0Fh, 0Fh
		db	 3Ch,0FCh, 0Fh, 00h, 00h, 0Fh
		db	0FFh, 3Ch, 3Ch,0F0h,0F3h,0FFh
		db	0C0h, 00h, 00h, 00h,0F0h, 03h
		db	0C0h, 00h, 3Ch, 00h, 00h,0FFh
		db	0F3h,0C0h, 00h,0F0h, 3Fh,0FCh
		db	0FFh,0F3h,0CFh,0C0h, 00h, 3Fh
		db	0FCh,0FFh,0F3h,0CFh,0CFh,0FFh
		db	 3Fh,0FCh,0F3h,0F0h,0F0h, 00h
		db	 3Ch, 00h, 00h, 00h, 00h, 3Fh
		db	0C0h, 3Ch, 0Fh, 0Fh, 3Ch, 3Ch
		db	 0Fh, 00h, 00h, 03h,0FCh, 3Ch
		db	 3Ch,0F0h,0F3h,0FFh,0C0h, 00h
		db	 00h, 00h,0F0h, 03h,0FFh,0C0h
		db	 00h, 00h, 00h, 3Fh,0C3h,0C0h
		db	 00h,0F0h, 3Fh,0FCh, 3Fh,0C3h
		db	0C3h,0C0h, 00h, 0Fh,0F0h, 3Fh
		db	0C3h,0C3h,0CFh,0FFh, 3Fh,0FCh
		db	0F0h,0F0h, 46h, 03h,0AAh, 00h
		db	 00h, 02h,0AAh, 00h, 00h, 00h
		db	 2Ah,0AAh, 00h, 00h, 02h,0A0h
		db	 00h, 00h, 00h, 00h, 20h, 00h
		db	 00h, 02h,0AAh, 00h, 00h, 00h
		db	 00h, 2Ah,0A0h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh, 00h, 00h
		db	 00h, 02h,0A0h, 02h,0A0h, 00h
		db	 00h, 00h, 02h,0AAh,0A0h, 02h
		db	0A0h, 00h, 00h, 00h, 00h, 02h
		db	0AAh,0AAh, 00h, 2Ah, 00h, 00h
		db	 00h, 02h, 80h, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh,0A8h, 00h,0AAh
		db	0AAh,0AAh, 00h, 2Ah,0AAh,0AAh
		db	0A0h, 00h, 2Ah,0AAh,0A0h, 00h
		db	 00h, 02h,0AAh, 00h, 02h,0AAh
		db	0AAh,0AAh,0A0h, 00h, 02h,0AAh
		db	0AAh,0AAh, 00h, 00h, 00h, 02h
		db	0AAh,0AAh,0AAh, 00h, 00h, 2Ah
		db	0AAh,0AAh,0AAh,0A0h, 00h, 02h
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A0h
		db	 00h, 00h, 02h,0AAh,0AAh,0AAh
		db	0A2h,0AAh,0AAh, 00h, 00h, 2Ah
		db	0AAh, 00h, 00h, 00h, 2Ah,0AAh
		db	0AAh,0AAh, 02h,0AAh,0AAh,0AAh
		db	0A0h, 2Ah,0AAh,0AAh,0AAh, 02h
		db	0AAh,0AAh,0AAh,0A0h, 02h,0AAh
		db	0AAh,0A0h, 2Ah,0AAh,0AAh,0AAh
		db	0AAh, 00h, 2Ah,0AAh,0AAh,0AAh
		db	0A0h, 00h, 02h,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 02h,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 00h, 2Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A0h, 00h
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A0h, 02h,0AAh,0AAh,0A0h
		db	 00h, 2Ah,0AAh,0AAh, 46h, 03h
		db	0AAh, 80h, 00h, 00h,0AAh, 80h
		db	 00h, 00h, 0Ah,0AAh, 80h, 00h
		db	 00h,0A8h, 00h, 00h, 00h, 00h
		db	 08h, 00h, 00h, 00h,0AAh, 80h
		db	 00h, 00h, 00h, 0Ah,0A8h, 00h
		db	 00h, 00h, 00h, 00h, 2Ah,0AAh
		db	 80h, 00h, 00h, 00h,0A8h, 00h
		db	0A8h, 00h, 00h, 00h, 00h,0AAh
		db	0A8h, 00h,0A8h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh, 80h, 0Ah
		db	 80h, 00h, 00h, 00h,0A0h, 00h
		db	 00h, 00h, 00h, 0Ah,0AAh,0AAh
		db	 00h, 2Ah,0AAh,0AAh, 80h, 0Ah
		db	0AAh,0AAh,0A8h, 00h, 0Ah,0AAh
		db	0A8h, 00h, 00h, 00h,0AAh, 80h
		db	 00h,0AAh,0AAh,0AAh,0A8h, 00h
		db	 00h,0AAh,0AAh,0AAh, 80h, 00h
		db	 00h, 00h,0AAh,0AAh,0AAh, 80h
		db	 00h, 0Ah,0AAh,0AAh,0AAh,0A8h
		db	 00h, 00h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 00h, 00h, 00h,0AAh
		db	0AAh,0AAh,0A8h,0AAh,0AAh, 80h
		db	 00h, 0Ah,0AAh, 80h, 00h, 00h
		db	 0Ah,0AAh,0AAh,0AAh, 80h,0AAh
		db	0AAh,0AAh,0A8h, 0Ah,0AAh,0AAh
		db	0AAh, 80h,0AAh,0AAh,0AAh,0A8h
		db	 00h,0AAh,0AAh,0A8h, 0Ah,0AAh
		db	0AAh,0AAh,0AAh, 80h, 0Ah,0AAh
		db	0AAh,0AAh,0A8h, 00h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0A8h, 00h,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 80h, 0Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h, 00h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A8h, 00h,0AAh
		db	0AAh,0A8h, 00h, 0Ah,0AAh,0AAh
		db	 46h, 03h,0AAh,0A0h, 00h, 00h
		db	 2Ah,0A0h, 00h, 00h, 02h,0AAh
		db	0A0h, 00h, 00h, 2Ah, 00h, 00h
		db	 00h, 00h, 02h, 00h, 00h, 00h
		db	 2Ah,0A0h, 00h, 00h, 00h, 02h
		db	0AAh, 00h, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh,0A0h, 00h, 00h, 00h
		db	 2Ah, 00h, 2Ah, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh, 00h, 2Ah, 00h
		db	 00h, 00h, 00h, 00h, 2Ah,0AAh
		db	0A0h, 02h,0A0h, 00h, 00h, 00h
		db	 28h, 00h, 00h, 00h, 00h, 02h
		db	0AAh,0AAh, 80h, 0Ah,0AAh,0AAh
		db	0A0h, 02h,0AAh,0AAh,0AAh, 00h
		db	 02h,0AAh,0AAh, 00h, 00h, 00h
		db	 2Ah,0A0h, 00h, 2Ah,0AAh,0AAh
		db	0AAh, 00h, 00h, 2Ah,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 2Ah,0AAh
		db	0AAh,0A0h, 00h, 02h,0AAh,0AAh
		db	0AAh,0AAh, 00h, 00h, 2Ah,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 00h, 00h
		db	 00h, 2Ah,0AAh,0AAh,0AAh, 2Ah
		db	0AAh,0A0h, 00h, 02h,0AAh,0A0h
		db	 00h, 00h, 02h,0AAh,0AAh,0AAh
		db	0A0h, 2Ah,0AAh,0AAh,0AAh, 02h
		db	0AAh,0AAh,0AAh,0A0h, 2Ah,0AAh
		db	0AAh,0AAh, 00h, 2Ah,0AAh,0AAh
		db	 02h,0AAh,0AAh,0AAh,0AAh,0A0h
		db	 02h,0AAh,0AAh,0AAh,0AAh, 00h
		db	 00h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	 00h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 02h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h, 2Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 00h, 2Ah,0AAh,0AAh, 00h, 02h
		db	0AAh,0AAh, 46h, 03h,0AAh,0A8h
		db	 00h, 00h, 0Ah,0A8h, 00h, 00h
		db	 00h,0AAh,0A8h, 00h, 00h, 0Ah
		db	 80h, 00h, 00h, 00h, 00h, 80h
		db	 00h, 00h, 0Ah,0A8h, 00h, 00h
		db	 00h, 00h,0AAh, 80h, 00h, 00h
		db	 00h, 00h, 02h,0AAh,0A8h, 00h
		db	 00h, 00h, 0Ah, 80h, 0Ah, 80h
		db	 00h, 00h, 00h, 0Ah,0AAh, 80h
		db	 0Ah, 80h, 00h, 00h, 00h, 00h
		db	 0Ah,0AAh,0A8h, 00h,0A8h, 00h
		db	 00h, 00h, 0Ah, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh,0A0h, 02h
		db	0AAh,0AAh,0A8h, 00h,0AAh,0AAh
		db	0AAh, 80h, 00h,0AAh,0AAh, 80h
		db	 00h, 00h, 0Ah,0A8h, 00h, 0Ah
		db	0AAh,0AAh,0AAh, 80h, 00h, 0Ah
		db	0AAh,0AAh,0A8h, 00h, 00h, 00h
		db	 0Ah,0AAh,0AAh,0A8h, 00h, 00h
		db	0AAh,0AAh,0AAh,0AAh, 80h, 00h
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 80h, 00h, 00h, 0Ah,0AAh,0AAh
		db	0AAh, 8Ah,0AAh,0A8h, 00h, 00h
		db	0AAh,0A8h, 00h, 00h, 00h,0AAh
		db	0AAh,0AAh,0A8h, 0Ah,0AAh,0AAh
		db	0AAh, 80h,0AAh,0AAh,0AAh,0A8h
		db	 0Ah,0AAh,0AAh,0AAh, 80h, 0Ah
		db	0AAh,0AAh, 80h,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 00h,0AAh,0AAh,0AAh
		db	0AAh, 80h, 00h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh, 80h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0A8h, 00h
		db	7 dup (0AAh)
		db	 80h, 00h, 0Ah,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 80h, 0Ah,0AAh
		db	0AAh, 80h, 00h,0AAh,0AAh, 46h
		db	 24h,0AAh
		db	349 dup (0AAh)
		db	0A8h, 00h
		db	26 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 00h
		db	 00h
		db	28 dup (0)
		db	 80h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah,0A8h, 03h,0C3h,0CFh,0FFh
		db	 0Fh,0F0h,0F0h,0F0h, 00h, 0Fh
		db	0FFh, 3Fh,0FCh,0FFh,0F3h,0FFh
		db	0CFh,0FFh, 3Fh,0FCh
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Fh
		db	0F0h, 3Fh,0C3h,0FFh,0CFh, 0Fh
		db	 3Fh,0FCh
		db	21 dup (0)
		db	 80h, 0Fh, 00h, 00h, 00h, 00h
		db	 0Ah,0A8h, 03h,0C3h,0CFh,0FFh
		db	 3Fh,0FCh,0F0h,0F0h, 00h, 0Fh
		db	 0Fh, 3Ch, 3Ch,0F0h,0F3h,0C3h
		db	0CFh, 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Fh
		db	0FCh,0FFh,0F3h,0FFh,0CFh,0CFh
		db	 3Fh,0FCh
		db	21 dup (0)
		db	 80h, 0Fh, 00h, 0Ah,0AAh, 80h
		db	 0Ah,0A8h, 03h,0C3h,0C0h,0F0h
		db	 3Ch, 00h,0F0h,0F0h, 00h, 0Fh
		db	 0Fh, 3Ch, 3Ch,0F0h,0F3h,0C3h
		db	0CFh, 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Ch
		db	 3Ch,0F0h,0F0h, 3Ch, 0Fh,0FFh
		db	 03h,0C0h, 00h, 00h
		db	19 dup (0)
		db	 80h,0FFh,0F0h, 8Fh,0FFh,0F0h
		db	 0Ah,0A8h, 03h,0FFh,0C0h,0F0h
		db	 3Ch,0FCh,0FFh,0F0h, 00h, 0Fh
		db	 0Fh, 3Ch, 3Ch,0F0h,0F3h,0C3h
		db	0CFh, 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Fh
		db	0FCh,0F0h,0F0h, 3Ch, 0Fh,0FFh
		db	 03h,0C0h, 00h, 00h
		db	19 dup (0)
		db	 80h,0AAh,0AAh,0FFh,0FFh,0FFh
		db	 0Ah,0A8h, 03h,0FFh,0C0h,0F0h
		db	 3Ch, 3Ch,0FFh,0F0h, 00h, 0Fh
		db	 0Fh, 3Ch, 3Ch,0F0h,0F3h,0C3h
		db	0CFh, 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Fh
		db	0F0h,0F0h,0F0h, 3Ch, 0Fh,0FFh
		db	 03h,0C0h, 00h, 00h
		db	19 dup (0)
		db	 80h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 8Ah,0A8h, 03h,0C3h,0CFh,0FFh
		db	 3Fh,0FCh,0F0h,0F0h, 00h, 0Fh
		db	 0Fh, 3Ch, 3Ch,0F0h,0F3h,0C3h
		db	0CFh, 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Ch
		db	 00h,0FFh,0F3h,0FFh,0CFh, 3Fh
		db	 03h,0C0h
		db	21 dup (0)
		db	 80h,0FFh,0CFh,0FEh, 8Fh,0FCh
		db	 0Ah,0A8h, 03h,0C3h,0CFh,0FFh
		db	 0Fh,0F0h,0F0h,0F0h, 00h, 0Fh
		db	0FFh, 3Fh,0FCh,0FFh,0F3h,0FFh
		db	0CFh,0FFh, 3Fh,0FCh
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Ch
		db	 00h, 3Fh,0C3h,0FFh,0CFh, 0Fh
		db	 03h,0C0h
		db	21 dup (0)
		db	 80h,0FFh, 0Fh,0F0h, 0Fh,0F0h
		db	 0Ah,0A8h, 00h, 00h
		db	25 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 00h
		db	 00h
		db	28 dup (0)
		db	 80h,0FFh, 0Fh,0F0h, 0Fh,0F0h
		db	 0Ah,0A8h, 00h, 00h
		db	25 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 00h
		db	 00h
		db	28 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 3Ch
		db	 3Ch,0FFh,0C0h, 00h, 0Fh,0FFh
		db	 3Fh,0FCh,0FFh,0F3h,0FFh,0CFh
		db	0FFh, 3Fh,0FCh
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Fh
		db	0FCh,0FFh,0F3h, 00h,0CFh,0FFh
		db	 00h, 00h,0FFh,0F3h,0FFh,0CFh
		db	0FFh, 00h
		db	15 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 3Ch
		db	 3Ch,0FFh,0F0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 3Fh
		db	0FCh,0FFh,0F3h,0C3h,0CFh,0FFh
		db	 00h, 00h,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	16 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 3Ch
		db	 3Ch,0F0h,0F0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 03h
		db	0C0h, 0Fh, 03h,0FFh,0CFh, 00h
		db	 00h, 00h,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	16 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 3Ch
		db	 3Ch,0FFh,0F0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 03h
		db	0C0h, 0Fh, 03h,0FFh,0CFh,0FCh
		db	 00h, 00h,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	16 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 3Ch
		db	 3Ch,0FFh,0C0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 03h
		db	0C0h, 0Fh, 03h,0C3h,0CFh, 00h
		db	 00h, 00h,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	16 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 3Fh
		db	0FCh,0F0h, 00h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 03h
		db	0C0h,0FFh,0F3h,0C3h,0CFh,0FFh
		db	 00h, 00h,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	16 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 00h,0F0h, 0Fh
		db	0F0h,0F0h, 00h, 00h, 0Fh,0FFh
		db	 3Fh,0FCh,0FFh,0F3h,0FFh,0CFh
		db	0FFh, 3Fh,0FCh
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 03h
		db	0C0h,0FFh,0F3h,0C3h,0CFh,0FFh
		db	 00h, 00h,0FFh,0F3h,0FFh,0CFh
		db	0FFh, 00h
		db	15 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h
		db	26 dup (0)
		db	0AAh,0AAh,0AAh,0AAh, 80h, 00h
		db	 00h
		db	28 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h
		db	26 dup (0)
		db	42 dup (0AAh)
		db	0A8h, 00h, 00h, 0Fh,0FFh, 3Ch
		db	 3Ch,0FFh,0C0h, 00h, 0Fh,0FFh
		db	 3Fh,0FCh,0FFh,0F3h,0FFh,0CFh
		db	0FFh, 3Fh,0FCh
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0FFh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h, 00h, 00h, 0Fh, 3Ch
		db	 3Ch,0FFh,0F0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FEh,0AAh,0AAh,0AAh,0AFh,0EAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0EFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h, 00h, 00h, 0Fh, 3Ch
		db	 3Ch,0F0h,0F0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0FFh,0FFh
		db	0FFh,0EAh,0AAh,0AAh,0AFh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0EFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0FEh
		db	0AAh,0AAh,0AAh,0AAh, 8Fh,0EAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h, 00h, 0Fh,0FFh, 3Ch
		db	 3Ch,0FFh,0F0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FEh,0AAh,0AAh,0AAh,0AFh,0EAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0EFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0EFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0FCh
		db	7 dup (0AAh)
		db	0A8h, 00h, 00h, 0Fh, 00h, 3Ch
		db	 3Ch,0FFh,0C0h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0EAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0FFh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A8h, 00h, 00h, 0Fh, 00h, 3Fh
		db	0FCh,0F0h, 00h, 00h, 0Fh, 0Fh
		db	 3Ch, 3Ch,0F0h,0F3h,0C3h,0CFh
		db	 0Fh
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	42 dup (0AAh)
		db	0A8h, 00h, 00h, 0Fh,0FFh, 0Fh
		db	0F0h,0F0h, 00h, 00h, 0Fh,0FFh
		db	 3Fh,0FCh,0FFh,0F3h,0FFh,0CFh
		db	0FFh, 3Fh,0FCh
		db	7 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 80h
		db	 00h, 00h
		db	27 dup (0)
		db	7 dup (0AAh)
		db	0A8h, 00h
		db	26 dup (0)
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 80h
		db	 00h, 00h
		db	27 dup (0)
		db	40 dup (0AAh)
		db	 80h, 00h, 00h
		db	27 dup (0)
		db	40 dup (0AAh)
		db	 80h, 00h, 00h
		db	27 dup (0)
		db	147 dup (0AAh)
		db	 46h, 40h, 00h, 00h, 00h, 00h
		db	 07h
		db	40h
		db	68 dup (0)
		db	 07h, 40h
		db	68 dup (0)
		db	 07h, 40h
		db	68 dup (0)
		db	 07h, 40h
		db	68 dup (0)
		db	 05h, 40h, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0F0h
		db	59 dup (0)
		db	 04h, 2Eh, 00h, 00h, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	58 dup (0)
		db	 04h, 2Eh, 00h, 00h, 3Fh,0FFh
		db	0FCh, 3Ch, 3Ch, 3Ch, 3Fh,0FFh
		db	0F0h
		db	57 dup (0)
		db	 04h, 2Eh, 00h, 0Fh
		db	9 dup (0FFh)
		db	57 dup (0)
		db	 04h, 2Eh, 03h,0FFh
		db	9 dup (0FFh)
		db	0F0h
		db	56 dup (0)
		db	 04h, 2Eh, 3Fh
		db	11 dup (0FFh)
		db	56 dup (0)
		db	 04h, 2Bh,0FFh,0FFh,0FFh,0FAh
		db	0AAh,0ABh, 55h, 55h,0EAh,0AAh
		db	0AFh,0FFh,0F0h
		db	55 dup (0)
		db	 04h, 3Fh,0FFh,0FFh,0FEh,0A0h
		db	 00h, 0Bh, 00h, 00h,0E0h, 00h
		db	 0Ah,0BFh,0FFh, 00h
		db	54 dup (0)
		db	 04h, 3Fh,0FFh,0FFh,0E8h, 00h
		db	 00h, 0Bh, 00h, 00h,0E0h, 00h
		db	 00h, 2Bh,0FFh,0F0h
		db	54 dup (0)
		db	 04h,0FFh,0FFh,0FFh, 80h, 00h
		db	 00h, 0Bh, 00h, 00h,0E0h, 00h
		db	 00h, 02h,0FFh,0FCh
		db	54 dup (0)
		db	 0Fh,0FFh,0FFh,0FEh, 00h, 00h
		db	 00h, 0Bh, 00h, 00h,0E0h, 00h
		db	 00h, 00h,0BFh,0FFh,0C0h
		db	53 dup (0)
		db	 3Fh,0FFh,0FFh,0F8h, 00h, 00h
		db	 00h, 0Bh, 00h, 00h,0E0h, 00h
		db	 00h, 00h, 2Fh,0FFh,0F0h
		db	53 dup (0)
		db	16 dup (0FFh)
		db	0FCh
		db	52 dup (0)
		db	 03h,0F3h,0FFh,0FFh,0FDh
		db	10 dup (55h)
		db	 5Fh,0FFh,0FFh, 00h
		db	51 dup (0)
		db	 0Fh,0C0h,0FFh, 03h,0FFh,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ABh,0FFh,0FFh, 03h,0F3h
		db	0C0h, 00h, 00h
		db	49 dup (0)
		db	 0Fh, 00h,0FCh, 00h,0FFh
		db	10 dup (0FFh)
		db	0FCh, 00h,0F0h,0F0h
		db	51 dup (0)
		db	 3Fh, 00h,0FCh, 00h,0FFh
		db	10 dup (0FFh)
		db	0FCh, 00h,0F0h, 3Ch, 00h
		db	50 dup (0)
		db	0FFh, 03h,0FCh, 00h,0FFh
		db	10 dup (0FFh)
		db	0FCh, 00h,0FCh, 3Fh
		db	51 dup (0)
		db	0FFh,0CFh,0FBh, 2Bh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FAh,0ABh,0FFh
		db	0FFh,0FAh,0FFh,0FFh, 03h,0FFh
		db	0CFh
		db	50 dup (0)
		db	 03h,0FFh,0FEh,0AAh,0AAh,0BFh
		db	0FEh,0ABh,0FFh,0FEh,0AAh,0AAh
		db	0BFh,0FFh,0AAh,0BFh,0FFh,0FFh
		db	0FFh,0FFh,0C0h
		db	47 dup (0)
		db	 08h, 0Ah,0A3h,0FFh,0FAh,0AAh
		db	0AAh,0ABh,0FAh,0AAh,0FFh,0FAh
		db	0AAh,0AAh,0ABh,0FAh,0AAh,0ABh
		db	0FFh,0FFh,0FFh,0FFh,0F0h
		db	47 dup (0)
		db	10 dup (0AAh)
		db	0BFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0BFh,0FFh,0FFh,0FFh
		db	0F0h
		db	19 dup (0AAh)
		db	0A9h, 55h, 55h
		db	15 dup (55h)
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AAh,0AAh
		db	17 dup (0AAh)
		db	0ABh,0EBh,0FFh,0FFh,0F0h
		db	19 dup (0FFh)
		db	0FDh, 5Fh
		db	14 dup (0FFh)
		db	0F2h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h, 00h
		db	0Ah
		db	23 dup (0AAh)
		db	0BFh,0FFh,0FCh, 3Fh,0FFh, 55h
		db	0FFh, 55h,0FFh, 55h,0FFh, 55h
		db	0FFh, 55h,0FFh, 55h,0FFh, 55h
		db	0FFh, 55h,0FFh, 55h,0FFh,0DFh
		db	0FFh,0FEh,0BFh,0FFh,0AAh,0BFh
		db	0FFh,0FFh,0ABh,0BFh,0FFh,0BAh
		db	0BFh,0FFh,0AAh
		db	31 dup (0AAh)
		db	0ABh,0FFh,0FCh, 3Fh,0FFh, 00h
		db	0EBh, 00h,0EBh, 00h,0EBh, 00h
		db	0EBh, 00h,0EBh, 00h,0EBh, 00h
		db	0EBh, 00h,0EBh, 00h,0FFh,0D5h
		db	0FFh,0FAh,0ABh,0FAh,0AAh,0ABh
		db	0FFh,0FAh,0AAh,0ABh,0FAh,0AAh
		db	0ABh,0FEh
		db	33 dup (0AAh)
		db	0BFh,0FFh, 0Fh,0FFh, 00h,0C3h
		db	 00h,0C3h, 00h,0C3h, 00h,0C3h
		db	 00h,0C3h, 00h,0C3h, 00h,0C3h
		db	 00h,0C3h, 00h,0FFh,0FDh,0FEh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0BFh
		db	0AAh,0AAh
		db	38 dup (0AAh)
		db	0ABh,0FFh, 0Bh,0FFh,0AAh,0C3h
		db	0AAh,0C3h,0AAh,0C3h,0AAh,0C3h
		db	0AAh,0C3h,0AAh,0C3h,0AAh,0C3h
		db	0AAh,0C3h,0AAh,0FFh,0FDh, 6Ah
		db	0AAh
		db	46 dup (0AAh)
		db	0BFh,0AAh,0BFh
		db	19 dup (0FFh)
		db	 6Ah,0AAh
		db	48 dup (0AAh)
		db	0ABh
		db	17 dup (0FFh)
		db	0FEh
		db	52 dup (0AAh)
		db	0BFh,0FEh,0BFh,0FFh,0FFh,0FFh
		db	0FFh,0BFh,0FFh,0FFh,0FFh,0FFh
		db	0ABh,0FFh,0FFh,0FFh,0FFh,0AAh
		db	0AAh,0AAh
		db	50 dup (0AAh)
		db	0ABh,0FAh,0ABh,0FFh,0FFh,0FFh
		db	0FAh,0ABh,0FFh,0FFh,0FFh,0FAh
		db	0AAh,0ABh,0FFh,0FFh,0FAh
		db	61 dup (0AAh)
		db	0BFh,0BFh,0FFh,0AAh,0AAh,0AAh
		db	0BFh,0AFh,0AAh
		db	62 dup (0AAh)
		db	0ABh,0FAh
		db	1924 dup (0AAh)
		db	 0Bh, 00h, 0Eh, 00h, 01h, 0Fh
		db	10 dup (20h)
		db	'Game Options '
		db	9 dup (20h)
		db	 04h, 0Fh
		db	'Key  Action or Effect '
		db	10 dup (20h)
		db	 07h, 0Fh
		db	'F 2  Return to this screen      '
		db	8
		db	0Fh
		db	'F 3  Select number of '
		db	'players   ', 9
		db	0Fh
		db	'F 5  Select level or difficulty '
		db	 0Bh, 0Fh
		db	'P    Pause'
		db	' or Resume a game     ', 0Ch
		db	0Fh
		db	'X    Joystick Calibration '
		db	 20h, 20h, 20h, 20h, 20h, 20h
		db	 0Dh, 0Fh
		db	'C    Keyboard Assignments'
		db	7 dup (20h)
		db	 0Eh, 0Fh
		db	'S    Select sound or no sound   '
		db	 10h, 0Fh
		db	'F 7  Select joystick or keyboard'
		db	 11h, 0Fh
		db	'F 8  Select color or monochrome '
		db	 12h, 0Fh
		db	'F 9  Roll the whole screen left '
		db	 13h, 0Fh
		db	'F10  Roll the whole screen right'
		db	0FFh, 16h, 0Fh
		db	15 dup (7Eh)
		db	'  Sound: Enabled!'
		db	0FFh, 16h, 0Fh
		db	15 dup (7Eh)
		db	'  Sound: Disabled'
		db	0FFh, 17h, 0Fh
		db	'Input: Joystick  '
		db	15 dup (7Eh)
		db	0FFh, 17h, 0Fh
		db	'Input: Keyboard  '
		db	15 dup (7Eh)
		db	0FFh, 17h, 0Fh
		db	15 dup (7Eh)
		db	'  Video: Color   '
		db	0FFh, 17h, 0Fh
		db	15 dup (7Eh)
		db	'  Video: Monochr.'
		db	0FFh, 06h, 0Fh
		db	'F 1  Start a game with 1 player '
		db	0FFh, 06h, 0Fh
		db	'F 1  Start a game with 2 players'
		db	0FFh, 52h, 88h, 02h, 00h, 9Fh
		db	 83h,0C2h, 83h, 53h, 88h, 01h
		db	 00h,0E5h, 83h, 08h, 84h, 50h
		db	 88h, 01h, 00h, 94h, 84h, 71h
		db	 84h, 54h, 88h, 00h, 00h, 2Bh
		db	 84h, 4Eh, 84h,0FFh,0FFh, 04h
		db	 00h, 06h, 00h, 07h, 00h, 08h
		db	 00h, 09h, 00h, 0Ah, 00h, 0Bh
		db	 00h, 0Ch, 00h, 0Dh, 00h, 0Eh
		db	 00h, 0Fh, 00h, 10h, 00h, 11h
		db	 00h, 12h, 00h, 13h, 00h, 16h
		db	 00h, 17h, 0Fh
		db	'  F2 to return to Game Options  '
		db	0FFh, 01h, 0Fh
		db	'      Joyst'
		db	'ick Calibration  '
loc_c_853A:
		db	 20h, 20h, 20h, 20h, 0Ah, 0Fh
		db	'  Please hold the stick in the  '
		db	0Ch
		db	0F0h
		db	7 dup (20h)
		db	'upper left corner '
		db	7 dup (20h)
		db	 0Eh, 0Fh
		db	'  and then press the space bar  '
		db	0FFh, 0Ch,0F0h
		db	13 dup (20h)
		db	 63h, 65h, 6Eh, 74h, 65h, 72h
		db	 20h
		db	12 dup (20h)
		db	0FFh, 0Ch,0F0h
		db	7 dup (20h)
		db	'lower right corner       '
		db	0FFh, 0Ah, 00h, 0Eh, 00h, 0Ch
		db	0F0h
		db	' <<  Joystick now calibrated >> '
		db	0FFh, 0Ah, 0Fh
		db	'! Joystick'
		db	' can', 27h, 't be calibrated !', 0Ch
		db	0F0h
		db	'Check its cable and orientation!'
		db	 0Eh, 0Fh
		db	'Press the space bar to try again'
		db	0FFh, 01h, 0Fh
		db	'      Keyboard Assignments      '
		db	 0Bh, 0Fh
		db	'Please press the acti'
		db	'on key that', 0Dh
		db	0Fh
		db	7 dup (20h)
		db	'you want to change'
		db	7 dup (20h)
		db	0FFh, 0Bh, 0Fh
		db	'  Ple'
		db	'ase press the new key for  ', 0Dh
		db	0Fh
		db	9 dup (20h)
		db	'the "x" action'
		db	9 dup (20h)
		db	0FFh, 0Bh,0F0h
		db	'   "x"'
		db	' will be changed to "x"   ', 0Dh
		db	0Fh
		db	'Press the space bar for another '
		db	0FFh
		db	' e1234567890-='
		db	 11h, 1Dh
		db	'QWERTYUIOP[]'
		db	0D9h
		db	'cASDFGHJKL;', 27h, '`'
		db	7Fh
		db	'\ZXCVBNM,./'
		db	 7Fh, 2Ah, 61h, 20h, 63h, 20h
		db	9 dup (20h)
		db	 6Eh, 73h, 68h, 18h, 75h, 2Dh
		db	 1Bh, 35h, 1Ah, 2Bh, 65h, 19h
		db	 64h, 69h, 64h, 00h, 01h
		db	';<=>?@ABCD', 0Ch, 0Dh
		db	 0Eh, 0Fh, 45h, 11h, 12h, 13h
		db	 14h, 15h, 16h, 17h, 18h, 37h
		db	 1Ah, 1Bh, 1Ch, 1Dh, 1Eh
		db	'F !"#$'
		db	'%&', 27h, '()*+,-./F123'
loc_c_87F2:
		xor	al,35h			; '5'
		db	'6789:;<=>?@ABCDEFGGIJILQNOOQRS'
		db	0, 0
data_c_8814	dw	0			; segment storage
		db	 80h, 2Ch, 00h, 04h,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	 8Eh, 03h, 8Eh, 03h, 8Eh, 03h
		db	 8Eh, 03h,0E9h, 01h,0E9h, 01h
		db	0E9h, 01h,0E9h, 01h, 00h, 00h
		db	 00h, 00h
		db	'$$$$'
		db	'gggg'
		db	20 dup (0)
		db	 02h, 00h, 00h, 00h, 06h,0B1h
		db	0B2h,0B3h,0B4h,0B5h,0B6h,0B7h
		db	0B8h,0B9h,0B0h,0ADh,0BDh, 80h
		db	 89h,0D1h,0D7h,0C5h,0D2h,0D4h
		db	0D9h,0D5h,0C9h,0CFh, 06h,0DBh
		db	0DDh, 8Dh, 93h, 80h, 0Ch,0C4h
		db	0C6h,0C7h,0C8h,0CAh,0CBh,0CCh
		db	0BBh,0A7h,0A7h, 00h,0DCh,0DAh
		db	0D8h,0C3h,0D6h,0C2h,0CEh,0CDh
		db	0ACh,0AEh,0AFh, 00h,0AAh, 93h
		db	0A0h, 00h, 02h, 08h, 04h, 00h
		db	 0Ah, 00h, 0Eh, 10h, 12h, 14h
		db	 06h, 92h, 80h,0C1h, 80h,0ADh
		db	 88h,0B5h, 95h,0ABh, 80h,0DAh
		db	 80h,0B0h, 16h,0D0h, 88h,0C1h
		db	 00h, 14h, 89h,0A0h, 00h,0E7h
		db	 88h, 88h, 00h,0FDh, 88h, 95h
		db	 00h,0FFh,0FFh, 05h, 0Fh
		db	11 dup (20h)
		db	'Jump = "x"'
		db	11 dup (20h)
		db	 06h, 0Fh
		db	'Left = "x"'
		db	12 dup (20h)
		db	'Right= "x"'
		db	 07h, 0Fh
		db	11 dup (20h)
		db	'Fire = "x"'
		db	11 dup (20h)
		db	0FFh,0FFh, 27h, 89h, 4Ah, 89h
		db	 16h, 0Fh
		db	'Level: Beginner  '
		db	15 dup (7Eh)
		db	0FFh, 16h, 0Fh
		db	'Level: Champion  '
		db	15 dup (7Eh)
		db	0FFh, 00h
		db	29 dup (0)
data_c_898B	dw	0			; Data table (indexed access)
		db	45 dup (0)
		db	0, 0
		db	0, 0
		db	0, 0
		db	199 dup (0)
		db	 3Fh,0CFh,0F3h,0FCh, 01h, 02h
		db	 00h, 00h, 01h, 02h, 80h, 80h
		db	 04h, 07h, 00h, 05h, 55h, 55h
		db	 00h, 05h, 55h, 55h, 00h, 05h
		db	 55h, 55h, 00h, 05h, 55h, 55h
		db	 00h, 05h, 55h, 55h, 00h, 05h
		db	 55h, 55h, 00h, 05h
		db	 55h, 55h
		db	32 dup (0)
		db	70 dup (0FFh)
		db	116 dup (0)
data_c_8B8B	dw	0			; Data table (indexed access)
		db	8 dup (0)
data_c_8B95	dw	0			; Data table (indexed access)
		db	58 dup (00h)
		db	32 dup (0FFh)
		db	70 dup (00h)
		db	78 dup (0ffh)
data_c_8C8B	dw	0ffffh			; Data table (indexed access)
		db	106 dup (0FFh)
		db	 00h,0FFh
		db	61 dup (0FFh)

sub_c_4F00	endp


seg_c		ends



;------------------------------------------------------  stack_seg_d   ----

stack_seg_d	segment	word stack 'stack'

		db	30 dup (?)
data_d_001E	dw	?			; Data table (indexed access)
		db	22 dup (?)
data_d_0036	dw	?
data_d_0038	dw	?			; Data table (indexed access)
data_d_003A	dw	?			; Data table (indexed access)
		db	30 dup (?)
data_d_005A	dw	?
data_d_005C	dw	?
		db	4002 dup (?)

stack_seg_d	ends



		end	start
