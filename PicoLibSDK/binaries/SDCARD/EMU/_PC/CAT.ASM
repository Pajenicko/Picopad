
PAGE  59,132

; Start of code - search start_game

; Game control:
; ------------
; key Left Alt = drinking, special action
; key [8 Up] = jump
; key [6 Right] = move right
; key [2 Down] = move down
; key [4 Left] = move left
; key [9 PgUp] = move up right
; key [3 PgDn] = move down right
; key [1 End] = move down left
; key [7 Home] = move up left
; key Esc = pause
; key Y + Ctrl = exit game
; key S + Ctrl = set sound
; key R + Ctrl = restart
; key M + Ctrl = game menu
; key 9 + Ctrl = cheat to reset counter to 9 lives

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
;==				CAT	                                 ==
;==					                                 ==
;==      Created:   22-Aug-84		                                 ==
;==      Passes:    9          Analysis	Options on: U                    ==
;==					                                 ==
;==========================================================================

target		EQU   'T3'                      ; Target assembler: TASM-3.2

.186


; The following equates show data references outside the range of the program.

d_0000_0000_e	equ	0
d_0000_0024_e	equ	24h
d_0000_0026_e	equ	26h
d_0000_00AA_e	equ	0AAh
d_0000_0120_e	equ	120h
d_0000_0122_e	equ	122h
d_0000_0AA8_e	equ	0AA8h			;*
d_0000_1800_e	equ	1800h			;*
d_0000_A00A_e	equ	0A00Ah			;*
d_0000_A8AA_e	equ	0A8AAh			;*
d_0000_AAAA_e	equ	0AAAAh			;*
d_0040_0010_e	equ	10h
d_0040_0012_e	equ	12h
d_0040_0018_e	equ	18h
d_0040_0072_e	equ	72h
data_b_A00A_e	equ	0A00Ah			;*
data_b_A80A_e	equ	0A80Ah			;*
data_b_AA2A_e	equ	0AA2Ah			;*
data_b_E011_e	equ	0E011h			;*
d_8016_AAAA_e	equ	0AAAAh			;*
d_B800_0000_e	equ	0
d_B800_000E_e	equ	0Eh
d_B800_004E_e	equ	4Eh
d_B800_00F0_e	equ	0F0h
d_B800_0284_e	equ	284h
d_B800_05FA_e	equ	5FAh
d_B800_08E4_e	equ	8E4h
d_B800_08EC_e	equ	8ECh
d_B800_0C94_e	equ	0C94h
d_B800_0DCA_e	equ	0DCAh
d_B800_1180_e	equ	1180h
d_B800_1184_e	equ	1184h
d_B800_1C40_e	equ	1C40h
d_B800_2000_e	equ	2000h
d_B800_2284_e	equ	2284h
d_B800_22CB_e	equ	22CBh
d_B800_3180_e	equ	3180h
d_F000_FFFE_e	equ	0FFFEh
d_FEFA_C016_e	equ	0C016h

;------------------------------------------------------  stack_seg_a   ----

stack_seg_a	segment	word stack 'stack'

data_a_0000	dw	16 dup (0)
data_a_0020	dw	0			; Data table (indexed access)
		db	136 dup (0)
data_a_00AA	db	0			; Data table (indexed access)
		db	85 dup (0)

stack_seg_a	ends



;------------------------------------------------------------  seg_b   ----

seg_b		segment	byte public
		assume cs:seg_b  , ds:seg_b , ss:stack_seg_a

data_b_0000	db	0			; sound enabled
data_b_0001	dw	0			; Data table (indexed access)
data_b_0003	db	0			; Data table (indexed access) ... current scene 1..7
data_b_0004	dw	0			; current scene 1..7, 0=intro
data_b_0006	dw	0
data_b_0008	dw	0
data_b_000A	db	0
		db	0, 0, 0
data_b_000E	db	0
data_b_000F	db	0
		db	0, 0
data_b_0012	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0
data_b_0018	db	0
		db	13 dup (0)
data_b_0026	db	0
		db	39 dup (0)
data_b_004E	db	0
		db	55 dup (0)
data_b_0086	db	0
		db	25 dup (0)
data_b_00A0	db	0
		db	28 dup (0)
data_b_00BD	db	0
		db	53 dup (0)
data_b_00F3	db	0
		db	268 dup (0)
data_b_0200	db	0			; Data table (indexed access)
data_b_0201	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_0205	db	0
		db	12 dup (0)
data_b_0212	db	0			; Data table (indexed access)
		db	77 dup (0)
data_b_0260	db	0
		db	356 dup (0)
data_b_03C5	db	0
		db	73 dup (0)
data_b_040F	db	0
data_b_0410	dw	0
data_b_0412	dw	0			; system timer - start of game
data_b_0414	dw	0
data_b_0416	dw	0
data_b_0418	db	0
data_b_0419	db	0
data_b_041A	db	0			; 1=game menu was selected, skip it
data_b_041B	db	0			; 0ffh = request restart game
data_b_041C	db	0			; 0ffh = request game menu
data_b_041D	dw	0
data_b_041F	dw	0
data_b_0421	db	4			; Data table (indexed access)
		db	4, 1, 1, 3, 3, 5
		db	5, 6, 6, 4, 1
data_b_042D	db	1			; Data table (indexed access)
		db	3, 4, 5, 6
		db	14 dup (0)
		db	0AFh,0FAh, 4Fh,0F4h,0AFh,0FAh
		db	0AFh,0FAh,0AFh,0FAh,0BFh,0FAh
		db	0FFh,0FAh,0FEh,0AAh,0BFh,0EAh
		db	 7Fh,0C4h,0BFh,0EAh,0BFh,0EAh
		db	0BFh,0EAh,0BFh,0FAh,0BFh,0FEh
		db	0AAh,0FEh
data_b_0460	db	0BEh
		db	0AAh,0ABh,0EAh, 7Fh,0C4h, 7Fh
		db	0C4h,0BFh,0EAh,0BFh,0EAh,0BFh
		db	0FAh,0FFh,0EAh,0ABh,0FFh,0FEh
		db	0AAh,0ABh,0FFh,0FEh,0AAh,0AAh
		db	0BFh,0EAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AFh,0AAh,0FFh,0D4h,0FFh
		db	0FEh,0BFh,0FFh,0AFh,0FFh,0AFh
		db	0FEh,0AFh,0FAh,0AFh,0AAh,0AFh
		db	0AAh,0AAh,0FAh,0FFh, 11h, 1Fh
		db	0FFh,0FFh,0EAh,0AFh,0FFh,0FFh
		db	0FAh,0FFh,0FFh,0FAh,0FFh,0FFh
		db	0AFh,0FAh,0F7h,0FFh,0AFh,0AAh
		db	0FFh,0FFh,0AAh,0AAh,0F7h,0FFh
		db	0AAh,0AAh,0FFh,0FFh,0AAh,0AAh
		db	0F7h,0FFh,0AAh,0AAh,0FFh,0FFh
		db	0EAh,0AAh,0F7h,0FFh,0EAh,0ABh
		db	0FFh,0EFh,0FAh,0ABh,0FEh,0AFh
		db	0FAh,0AFh,0EAh,0AAh,0FAh,0AAh
		db	0AAh,0ABh,0EAh
data_b_04D0	dw	480h			; Data table (indexed access)
		db	 40h, 04h, 50h, 04h
data_b_04D6	db	0
data_b_04D7	dw	32 dup (0)
data_b_0517	dw	3BEh			; Data table (indexed access)
		db	 41h, 06h,0BEh, 0Dh
data_b_051D	dw	140h			; Data table (indexed access)
		db	 8Fh, 06h, 40h, 0Bh
data_b_0523	dw	0
data_b_0525	db	0
data_b_0526	db	3			; Data table (indexed access)
		db	0, 3
data_b_0529	db	0FFh			; Data table (indexed access)
		db	 01h,0FFh
data_b_052C	db	80h			; Data table (indexed access)
		db	 30h, 00h
data_b_052F	dw	0
data_b_0531	db	0
data_b_0532	db	'dPF<72(('		; Data table (indexed access)
data_b_053A	db	4Bh			; Data table (indexed access)
		db	 6Bh, 8Bh
data_b_053D	db	2Eh			; Data table (indexed access)
		db	 4Eh, 6Eh
data_b_0540	db	0
data_b_0541	db	0			; Data table (indexed access)
		db	 09h, 0Ah
data_b_0544	db	12 dup (0)
data_b_0550	db	0
data_b_0551	db	0
data_b_0552	db	0
data_b_0553	db	0
data_b_0554	dw	0
data_b_0556	dw	0			; system timer
data_b_0558	db	0
data_b_0559	db	0
data_b_055A	db	0
data_b_055B	db	0
data_b_055C	db	0
data_b_055D	dw	0
data_b_055F	dw	0
data_b_0561	dw	0
data_b_0563	dw	0
data_b_0565	dw	0
data_b_0567	dw	0
data_b_0569	dw	0
data_b_056B	db	0
data_b_056C	db	0
data_b_056D	db	0
data_b_056E	db	0
data_b_056F	db	0
data_b_0570	db	0
data_b_0571	db	0
data_b_0572	dw	0
data_b_0574	dw	0
data_b_0576	db	0
data_b_0577	db	0
data_b_0578	db	0
data_b_0579	dw	0
data_b_057B	db	0
data_b_057C	db	0
data_b_057D	dw	0
data_b_057F	dw	0
data_b_0581	dw	0
data_b_0583	db	0
data_b_0584	db	0
data_b_0585	dw	0
data_b_0587	dw	0
data_b_0589	dw	120h			; Data table (indexed access)
		db	0D8h, 00h,0C0h, 00h,0C0h, 00h
		db	0C0h, 00h,0C0h, 00h,0B8h, 00h
		db	0B0h, 00h
data_b_0599	dw	168h			; Data table (indexed access)
		db	 20h, 01h, 08h, 01h, 08h, 01h
		db	 08h, 01h, 08h, 01h, 00h, 01h
		db	0F8h, 00h
data_b_05A9	dw	48h			; Data table (indexed access)
		db	 36h, 00h, 30h, 00h, 30h, 00h
		db	 30h, 00h, 30h, 00h, 2Eh, 00h
		db	 2Ch, 00h
data_b_05B9	dw	90h			; Data table (indexed access)
		db	 6Ch, 00h, 60h, 00h, 60h, 00h
		db	 60h, 00h, 60h, 00h, 5Ch, 00h
		db	 58h, 00h
data_b_05C9	dw	0D8h			; Data table (indexed access)
		db	0A2h, 00h, 90h, 00h, 90h, 00h
		db	 90h, 00h, 90h, 00h, 8Ah, 00h
		db	 84h, 00h
data_b_05D9	dw	0A0h			; Data table (indexed access)
		db	 90h, 00h, 96h, 00h, 58h, 00h
		db	 00h, 01h,0F0h, 00h, 40h, 00h
		db	 98h, 00h
data_b_05E9	db	14h			; Data table (indexed access)
		db	 60h, 04h, 60h, 60h, 60h, 38h
		db	0AFh
data_b_05F1	dw	0
data_b_05F3	db	0
data_b_05F4	db	0
data_b_05F5	db	0
data_b_05F6	dw	0
data_b_05F8	dw	0
data_b_05FA	db	0
		db	0, 0, 0, 0, 0
data_b_0600	db	0
		db	17 dup (0)
data_b_0612	db	0
		db	45 dup (0)
data_b_0640	db	0
		db	13 dup (0)
data_b_064E	db	0
		db	 3Ch, 3Fh, 0Ch,0C0h, 3Fh, 0Fh
		db	0FCh, 3Fh, 0Ch,0C3h, 3Fh, 0Ch
		db	 0Ch, 3Fh, 0Ch,0C0h, 0Fh, 0Fh
		db	 0Ch, 3Fh, 0Ch,0C3h,0CFh, 00h
		db	0Ch
data_b_0668	db	3
		db	 00h,0C0h, 0Fh
data_b_066C	dw	4			; Data table (indexed access)
		db	 06h, 00h, 08h, 00h, 0Ah, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h
data_b_067C	db	3			; Data table (indexed access)
		db	3
data_b_067E	db	4
		db	4, 4, 4, 4, 4
data_b_0684	dw	0
		db	10 dup (0)
data_b_0690	db	0
data_b_0691	dw	0		; old counter of pressed keys
data_b_0693	dw	0		; counter of pressed keys
		db	0, 0
data_b_0697	db	0		; PC model
data_b_0698	db	0		; horizontal move 1=right, -1=left, 0=none
data_b_0699	db	0		; vertical move 1=down, -1=up, 0=none
data_b_069A	db	0		; key Alt drinking (0=pressed, 10h=released)
data_b_069B	db	0		; control cat with 0=keyboard, 1=joystick
data_b_069C	dw	0
data_b_069E	db	0
data_b_069F	dw	0		; old system timer during key input

		; 22 keys parsed in INT 09h service
data_b_06A1	db	38h	; Left Alt
		db	48h	; [8 Up]
		db	4Dh	; [6 Right]
		db	50h	; [2 Down]
		db	4Bh	; [4 Left]
		db	49h	; [9 PgUp]
		db	51h	; [3 PgDn]
		db	4Fh	; [1 End]
		db	47h	; [7 Home]
		db	01h	; Esc
		db	15h	; Y
		db	31h	; N
		db	25h	; K
		db	23h	; H
		db	14h	; T
		db	1Eh	; A
		db	1Fh	; S
		db	13h	; R
		db	1Dh	; Left Ctrl
		db	53h	; [. Del]
		db	32h	; M
		db	0Ah	; 9 (

		; table of keys, 80h = key was released
data_b_06B7	db	0	; key Left Alt = drinking, special action (0=pressed, 80h=released)
data_b_06B8	db	0	; key [8 Up] = jump (0=pressed, 80h=released)
data_b_06B9	db	0	; key [6 Right] = move right (0=pressed, 80h=released)
data_b_06BA	db	0	; key [2 Down] = move down (0=pressed, 80h=released)
data_b_06BB	db	0	; key [4 Left] = move left (0=pressed, 80h=released)
data_b_06BC	db	0	; key [9 PgUp] (0=pressed, 80h=released)
data_b_06BD	db	0	; key [3 PgDn] (0=pressed, 80h=released)
data_b_06BE	db	0	; key [1 End] (0=pressed, 80h=released)
data_b_06BF	db	0	; key [7 Home] (0=pressed, 80h=released)
data_b_06C0	db	0	; key Esc = pause (0=pressed, 80h=released)
data_b_06C1	db	0	; key Y + Ctrl = exit game (0=pressed, 80h=released)
data_b_06C2	db	0	; key N (0=pressed, 80h=released)
data_b_06C3	db	0	; key K (0=pressed, 80h=released)
data_b_06C4	db	0	; key H (0=pressed, 80h=released)
data_b_06C5	db	0	; key T (0=pressed, 80h=released)
data_b_06C6	db	0	; key A (0=pressed, 80h=released)
data_b_06C7	db	0	; key S + Ctrl = set sound (0=pressed, 80h=released)
data_b_06C8	db	0	; key R + Ctrl = restart (0=pressed, 80h=released)
data_b_06C9	db	0	; key Left Ctrl (0=pressed, 80h=released)
data_b_06CA	db	0	; key [. Del] (0=pressed, 80h=released)
data_b_06CB	db	0	; key M + Ctrl = game menu (0=pressed, 80h=released)
data_b_06CC	db	0	; key 9 + Ctrl = cheat to reset counter to 9 lives ( (0=pressed, 80h=released)

		db	 00h, 00h, 00h,0FCh, 0Fh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0C3h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 0Fh,0FFh
		db	0FFh,0FFh,0FFh, 0Ch, 3Fh,0FFh
		db	0FFh,0FFh,0FFh,0C0h, 3Ch, 03h
		db	0FCh, 3Fh, 3Fh,0FCh, 00h, 00h
		db	 3Ch, 00h, 3Fh,0F0h, 00h, 00h
		db	 00h,0C0h,0CFh,0C0h, 00h, 00h
		db	 00h, 00h, 03h,0C3h,0C0h, 00h
		db	 00h, 00h, 0Fh, 0Fh,0FFh,0C0h
		db	 03h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0C0h,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FCh, 3Fh,0FFh, 0Fh,0FFh
		db	0FFh,0FFh,0FFh,0FCh, 3Fh,0FFh
		db	0FFh,0FFh,0FFh,0FCh,0FFh,0FFh
		db	0F0h,0FFh,0FFh,0FCh, 3Fh,0FFh
		db	0C3h,0FFh,0FFh, 0Fh, 0Ch, 03h
		db	 0Fh, 0Fh,0CFh,0C3h, 00h, 00h
		db	 0Fh, 00h, 0Fh,0F0h, 00h, 00h
		db	 00h, 30h, 33h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 00h, 03h, 3Fh,0FFh,0FFh
		db	 00h, 03h,0FFh,0FFh,0FFh,0FFh
		db	0F0h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FCh, 3Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 0Fh,0FFh,0F0h,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FCh, 3Fh,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 0Fh,0FCh
		db	 3Fh, 0Fh,0CFh,0FFh,0C0h,0FFh
		db	 03h, 00h, 0Fh,0C0h,0C0h, 03h
		db	0C0h, 30h, 33h,0FCh
		db	10 dup (0)
		db	 03h,0F0h,0C0h, 00h, 00h, 03h
		db	0FFh,0FFh,0FFh, 00h,0FCh, 3Fh
		db	0FFh,0FFh,0FFh,0FFh,0C0h,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 30h,0FCh,0FCh, 3Fh,0C0h, 3Ch
		db	 03h,0FCh, 00h, 3Ch, 00h, 00h
		db	 3Fh,0F3h, 03h, 00h, 00h, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	 03h,0F0h, 00h, 00h, 00h, 03h
		db	0C3h,0FFh,0C0h,0C0h, 03h,0FFh
		db	0F0h,0FFh, 03h,0FFh,0FFh,0FFh
		db	0FFh,0FCh
		db	3Fh
		db	8 dup (0FFh)
		db	0F0h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FCh, 3Fh,0FFh,0FFh, 0Fh,0FFh
		db	0FFh, 3Fh,0FFh,0FFh,0C3h,0FFh
data_b_0800	db	0FCh
		db	 3Fh,0F3h,0F0h,0F0h,0C0h, 30h
		db	0F0h,0F0h, 00h,0F0h, 00h, 00h
		db	0C3h,0CCh, 0Ch, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 0Fh
		db	 00h,0FFh,0C0h, 00h,0FFh,0FFh
		db	0FCh,0FFh,0FFh, 0Fh,0FFh,0FFh
		db	0FFh,0FFh,0FCh, 3Fh,0FFh,0FFh
		db	0FFh,0FFh,0F0h
		db	9 dup (0FFh)
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 3Fh,0F3h,0F0h,0FCh, 3Fh,0F0h
		db	0FFh,0F0h, 00h,0C0h,0FFh, 03h
		db	0FFh,0CCh, 0Ch, 03h,0C0h, 03h
		db	 03h, 00h, 00h, 00h, 00h, 00h
		db	 3Fh,0C0h, 00h, 00h, 00h, 00h
		db	 00h,0FFh,0C0h, 00h, 00h, 03h
		db	 0Fh,0FFh,0FCh, 3Fh, 00h,0FFh
		db	0FFh,0FFh,0FFh, 03h
		db	11 dup (0FFh)
		db	0C3h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	0C0h, 00h,0FFh,0FFh,0FFh,0FFh
		db	 0Ch, 0Ch, 3Fh,0FFh,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh,0FFh,0C3h
		db	0C0h, 0Fh,0C3h,0FFh,0FFh,0F0h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh,0F0h, 0Fh
		db	 00h, 0Fh,0FFh,0FFh, 03h,0C0h
		db	 00h, 03h,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0F0h
		db	 00h, 00h,0FFh,0FFh,0FFh,0C0h
		db	0FFh,0F0h, 3Fh,0FFh,0FFh, 0Fh
		db	0FFh
data_b_08C5	db	0FFh
		db	 0Fh,0FFh,0FFh,0FFh,0C3h,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0C0h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 0Ch, 0Ch
		db	 3Fh,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh,0C0h, 0Fh
data_b_08E4	db	0FFh
		db	0FFh,0FFh,0FCh, 00h, 03h,0FFh
		db	0FFh,0FFh,0F0h, 00h, 00h,0FFh
		db	0FFh,0FFh,0C3h, 00h, 0Ch, 3Fh
		db	0FFh,0FFh,0FCh, 00h, 0Fh, 0Fh
		db	0FFh, 0Fh, 00h, 00h, 03h,0FFh
		db	0FFh,0C0h, 30h, 00h, 03h,0FFh
		db	0FFh,0FFh,0FCh, 3Fh,0C3h,0FFh
		db	0FFh,0FFh,0FFh, 0Fh, 0Fh,0FFh
		db	0FFh,0FFh,0FFh,0C3h,0FFh,0FCh
		db	 3Fh, 0Fh,0C3h,0FFh, 0Fh,0C3h
		db	 0Fh,0FFh, 0Fh, 0Fh, 0Fh,0FFh
		db	0C0h, 00h, 0Fh,0FFh,0F0h, 00h
		db	 3Fh,0FFh,0C0h, 00h,0FFh,0FFh
		db	 00h, 00h, 3Fh,0F0h, 00h, 00h
		db	 0Fh,0C3h,0F0h, 0Fh,0C3h,0FFh
		db	 00h, 03h,0FFh,0FCh, 00h, 00h
		db	0FFh,0FCh, 00h, 03h,0FFh,0FFh
		db	 0Fh,0C3h,0FFh,0FFh,0C3h, 30h
		db	0FFh,0FFh, 0Fh, 3Ch, 3Fh,0FFh
		db	 0Ch, 0Fh, 0Fh,0FFh,0C0h, 00h
		db	 3Fh,0F0h,0F0h, 00h,0FFh,0FCh
		db	 00h, 00h,0C3h,0FFh, 00h, 00h
		db	 0Fh,0FFh,0C0h, 00h,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh, 00h, 03h
		db	0FFh,0FCh, 00h, 00h,0FFh,0FCh
		db	 00h, 03h,0FFh,0FFh, 0Fh,0C3h
		db	0FFh,0F0h,0FFh, 0Fh,0FFh,0F0h
		db	 00h, 0Fh,0FFh,0C3h, 00h,0C3h
		db	0FFh,0F0h, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h, 0Fh,0F0h, 00h, 0Fh
		db	 03h,0C0h, 00h, 03h,0F0h, 0Fh
		db	 00h,0F0h, 3Fh, 3Fh,0FFh,0FFh
		db	 0Fh
data_b_09A6	dw	6D0h			; Data table (indexed access)
		db	 18h, 07h, 66h, 07h, 18h, 07h
		db	0A2h, 07h,0EAh, 07h, 38h, 08h
		db	0EAh, 07h
		db	 74h, 08h
data_b_09B8	dw	8C8h
		db	 16h, 09h, 4Eh, 09h, 82h, 09h
data_b_09C0	dw	0C03h			; Data table (indexed access)
		db	 03h, 0Dh, 03h, 0Ah, 03h, 0Dh
		db	 03h, 0Ch, 03h, 0Dh, 03h, 0Ah
		db	 03h, 0Dh, 03h, 0Eh, 03h, 0Dh
		db	 02h, 0Eh, 02h, 0Dh, 02h, 09h
		db	0FFh,0FFh, 0Fh, 0Fh,0FFh,0FFh
		db	0FFh,0FCh, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 03h,0FFh,0FFh
		db	0FFh,0F0h, 00h, 0Fh, 0Fh,0FFh
		db	0FFh,0FFh, 00h,0FCh, 3Fh,0FFh
		db	0FFh, 0Ch, 00h, 00h,0FFh,0FFh
		db	0FFh,0C0h, 00h, 03h,0FFh,0FFh
		db	0FFh,0FFh, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0FCh, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 0Fh,0FFh,0FFh
		db	 03h, 00h, 00h, 0Fh,0FFh,0FFh
		db	0F0h, 30h, 00h, 03h,0FFh,0FFh
		db	0FFh,0FCh, 0Fh,0F0h,0FFh,0FFh
		db	0FFh,0FFh,0C3h,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0C3h,0C3h,0FFh,0FFh
		db	0FFh,0FFh, 00h, 03h,0FFh,0FFh
		db	0FFh,0FCh, 00h, 00h,0FFh,0FFh
		db	0FFh,0FCh, 00h, 03h,0FFh,0FFh
		db	0FFh, 0Fh,0C0h, 3Fh, 0Fh,0FFh
		db	0FFh,0C0h, 00h, 00h, 3Fh,0FFh
		db	0FFh,0FCh, 00h, 03h,0FFh,0FFh
		db	0C0h, 30h, 00h, 3Fh,0FFh,0FFh
		db	 0Fh, 00h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 0Fh,0FFh,0FFh
		db	0FFh, 00h,0FFh, 03h
data_b_0A74	db	0FFh
		db	0FFh,0FCh, 0Fh
data_b_0A78	db	0FFh
		db	0F0h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 3Fh,0FFh,0FFh,0FFh, 0Fh, 0Fh
		db	 0Fh,0FFh,0FFh,0FFh, 00h, 0Ch
		db	 3Fh,0FFh,0FFh,0FCh,0C0h,0C0h
		db	 0Fh,0FFh,0FFh,0F0h, 00h, 00h
		db	 0Fh,0FFh,0FFh,0FCh, 00h, 00h
		db	 03h,0FFh,0FFh,0FFh,0C0h, 00h
		db	0C0h,0FFh,0FFh,0FFh, 00h, 03h
		db	0F0h, 3Fh,0FFh,0FCh, 00h, 00h
		db	0FFh, 0Fh,0FFh,0F0h,0C0h, 30h
		db	 3Fh,0FFh,0FFh,0C3h,0FFh,0FFh
		db	 0Fh,0FFh,0FFh, 0Fh,0FFh,0FFh
		db	0C3h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FCh, 3Fh, 3Fh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	0C0h,0C0h,0CFh,0FFh,0FFh,0FFh
		db	0F0h, 00h, 3Fh,0FFh,0FFh,0FCh
		db	 00h, 03h,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h, 3Fh,0C0h,0FFh, 00h
		db	 00h, 03h, 03h,0C0h, 00h, 00h
		db	 3Fh,0C0h,0FFh,0FFh,0C0h, 00h
		db	 3Fh,0FCh, 3Fh,0FFh, 0Ch, 03h
		db	0FFh,0FFh,0FFh,0FFh,0FCh, 3Fh
		db	0FFh,0FFh,0FFh,0FFh,0F0h,0FFh
		db	0FFh,0FFh,0FFh,0F3h,0F0h,0FFh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 3Fh
		db	0FFh,0FFh,0FFh,0CCh, 0Ch, 0Fh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 3Fh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	 0Fh,0FFh,0FFh, 03h, 00h, 00h
		db	 03h,0FCh, 0Fh,0FCh, 0Fh,0F0h
		db	 00h, 00h,0C3h,0F0h,0FFh,0F0h
		db	 00h, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	 00h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	0F0h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0FCh, 3Fh,0FFh,0FFh,0C0h,0FFh
		db	0FFh,0FFh,0FFh,0FCh, 0Ch, 03h
		db	0FFh,0C3h,0C3h, 00h,0F0h, 00h
		db	 3Ch, 00h, 03h,0FFh,0C0h, 00h
		db	 00h, 0Ch, 0Ch,0FFh,0C0h, 00h
		db	 00h, 00h, 03h,0FCh, 00h, 00h
		db	 00h, 00h,0FFh,0FCh, 00h,0FCh
		db	 00h, 00h, 3Fh,0C0h,0FFh,0FFh
		db	0F0h, 3Fh, 03h,0FFh,0FFh,0FFh
		db	0FCh, 0Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0C3h,0FFh,0FFh,0FFh,0FFh
		db	0FFh, 03h,0FFh,0C3h,0C3h,0FFh
		db	0C0h, 30h, 3Fh,0C0h, 00h, 3Ch
		db	 00h, 0Fh, 00h, 30h, 30h, 00h
		db	 00h, 03h,0FFh,0C0h, 00h, 00h
		db	 00h, 03h,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 3Fh,0FCh, 00h, 00h
		db	 3Fh, 00h, 3Fh,0C0h,0FCh, 0Fh
		db	0FFh,0FFh, 03h,0FFh,0F0h, 3Fh
		db	0FFh,0FFh,0FFh,0FFh,0C3h,0FFh
		db	0FFh,0FFh,0FFh,0C3h,0FFh,0FFh
		db	0FFh,0CFh,0FFh, 3Ch,0FFh,0FFh
		db	0FFh, 00h,0FFh, 0Fh,0FFh,0FFh
		db	0FFh, 03h, 3Fh,0CFh,0FCh, 03h
		db	0FCh, 00h, 0Fh,0C0h,0F0h, 00h
		db	 0Ch, 00h, 3Fh,0F0h, 00h, 00h
		db	 00h, 00h,0FFh,0FCh, 00h, 00h
		db	 00h, 03h,0FFh,0FCh, 30h, 0Ch
		db	 00h,0C3h,0FFh,0F0h,0FCh, 3Fh
		db	0C3h,0F0h,0FFh,0F0h,0FCh, 3Fh
		db	0C3h,0FFh, 3Fh,0FCh,0FFh, 0Fh
		db	0F0h,0FFh,0FFh,0F3h,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 0Fh,0FFh,0FFh
		db	0FFh,0FCh,0FFh, 3Fh,0FFh,0FFh
		db	0FFh,0F0h, 0Fh, 0Fh,0FFh,0F0h
		db	 03h,0C0h, 33h,0C0h,0FCh, 00h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 00h, 00h, 03h,0FFh, 00h, 00h
		db	0C0h, 00h, 0Fh,0FFh,0C0h, 0Fh
		db	0FFh, 00h,0FFh,0FFh, 0Ch, 3Fh
		db	0FFh, 0Ch, 3Fh,0FFh, 0Ch, 3Fh
		db	0FCh, 3Ch, 3Fh,0FFh,0C3h, 0Fh
		db	0FFh,0FFh, 0Fh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FFh, 3Fh,0FFh,0FFh
		db	0FFh,0FCh,0FFh, 03h,0FFh,0FFh
		db	0FFh,0F0h, 0Fh,0F0h,0FFh,0FCh
		db	 03h,0C0h, 33h,0FCh, 3Ch, 00h
		db	 00h, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 00h, 03h,0FFh, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0F0h, 00h
		db	 00h, 03h,0FFh,0FFh,0FCh, 03h
		db	0FCh, 0Fh,0FFh,0FFh,0FCh, 3Fh
		db	0FCh, 3Fh,0FFh,0FFh,0FFh
data_b_0C94	db	0Fh
		db	0FFh, 0Fh
		db	11 dup (0FFh)
		db	0FCh,0FFh,0C3h,0FFh,0FFh,0FFh
data_b_0CA8	db	0F0h
		db	 0Fh, 30h,0FFh,0C0h, 0Fh,0C0h
		db	 33h,0FCh,0F0h, 00h, 00h, 00h
		db	 00h,0FCh, 00h, 00h, 00h, 00h
		db	 03h,0FFh, 00h, 00h, 00h, 00h
		db	 0Fh,0FFh,0F0h, 00h,0F0h, 03h
		db	0FFh,0FFh,0C3h, 03h,0FCh, 03h
		db	0FFh,0FFh,0C3h, 0Fh,0FCh, 33h
		db	0FFh,0FFh,0F3h,0CFh,0FFh, 33h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F3h
		db	0FFh,0C0h,0FFh,0FFh,0FFh,0C0h
		db	 3Fh, 0Ch, 3Fh,0FFh,0FFh, 00h
		db	0CFh,0FFh, 0Fh, 00h, 3Fh, 00h
		db	 03h,0FFh, 00h, 00h, 00h, 00h
		db	 0Fh,0FFh,0C0h, 00h, 00h, 00h
		db	 3Fh,0FFh,0C0h, 00h, 00h, 00h
		db	0FFh,0FFh,0C0h, 00h, 30h, 03h
		db	0FFh,0FFh, 03h, 03h,0FCh, 30h
		db	0FFh,0FFh, 0Fh,0C3h,0FCh, 3Ch
		db	0FFh,0FFh,0CFh,0F3h,0FCh,0FFh
		db	 3Fh, 0Fh,0FFh,0FFh,0FFh, 3Fh
		db	0FFh,0F3h,0FFh,0FFh,0FCh, 03h
		db	0FFh,0C3h,0FFh,0FFh,0F0h, 0Ch
		db	0FFh, 0Fh,0C0h, 03h,0F0h, 00h
		db	 3Fh,0C0h, 00h, 00h, 00h, 00h
		db	0FFh,0F0h, 00h, 00h, 00h, 03h
		db	0FFh,0FFh, 00h, 00h, 00h, 0Fh
		db	0FFh,0FCh, 30h, 0Ch, 00h, 3Fh
		db	0FFh,0F0h, 3Ch, 3Fh, 0Ch, 0Fh
		db	0FFh,0F0h,0FCh, 3Fh, 0Fh, 0Fh
		db	0FFh,0C3h,0FFh, 0Ch, 3Fh,0CFh
		db	0FFh,0FFh, 3Fh,0FFh,0FFh,0FCh
		db	 3Fh,0F0h, 0Fh,0FFh,0FFh,0F3h
		db	0CFh,0CCh, 0Fh,0FFh,0FFh,0FFh
		db	 0Fh, 00h, 03h,0FCh, 03h,0FFh
		db	 3Fh,0C0h, 03h, 00h, 00h,0F0h
		db	 3Fh,0F0h, 00h, 00h, 00h, 00h
		db	0FFh,0FCh, 00h, 00h, 00h, 03h
		db	0FFh,0FCh, 30h, 03h, 00h,0C3h
		db	0FFh,0F0h,0FCh, 3Fh,0C3h,0F0h
		db	0FFh,0CFh,0FCh, 3Fh,0C3h,0F0h
		db	0FFh,0FFh,0F0h,0FFh, 0Fh,0F3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0CFh,0FFh, 3Fh,0FFh,0FFh,0FFh
		db	0F0h,0F0h, 0Fh,0FFh,0FFh,0FFh
		db	0FCh,0CCh, 03h,0C0h, 0Fh,0FFh
		db	0F0h, 00h, 00h, 00h, 00h, 3Fh
		db	 03h,0C0h, 00h, 00h, 00h, 00h
		db	 0Fh,0F0h
data_b_0DC5	db	0
		db	 03h, 00h, 00h,0FFh
data_b_0DCA	db	0FFh
		db	 00h,0FFh,0F0h, 03h,0FFh,0FCh
		db	 30h,0FFh,0FCh, 30h,0FFh
data_b_0DD6	db	0FCh
		db	 3Ch, 3Fh,0FCh, 30h,0FFh,0F0h
		db	0FFh,0FFh,0F0h,0C3h
		db	8 dup (0FFh)
		db	 3Fh,0FFh,0FFh,0FFh,0FCh,0F0h
		db	 0Fh,0FFh,0FFh,0FFh,0C0h,0CCh
		db	 03h,0C0h, 3Fh,0FFh, 0Fh, 00h
		db	 00h, 00h, 00h, 3Ch, 3Fh,0C0h
		db	 00h, 00h, 00h, 00h,0FFh,0F0h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0C0h, 00h, 00h, 0Fh,0FFh,0FFh
		db	0F0h, 3Fh,0C0h, 3Fh,0FFh,0FFh
		db	0FCh, 3Fh,0FCh, 3Fh,0FFh,0FFh
		db	0F0h,0FFh,0F0h
		db	9 dup (0FFh)
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 0Fh,0FFh,0FFh,0FFh,0C3h,0CCh
		db	 03h,0F0h, 03h,0FFh, 0Ch, 00h
		db	 00h, 00h, 00h, 0Fh, 3Fh,0C0h
		db	 00h, 00h, 00h, 00h, 3Fh,0F0h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0C0h, 0Fh, 00h, 0Fh,0FFh,0FFh
		db	0C0h, 3Fh,0C0h,0C3h,0FFh,0FFh
		db	0CCh, 3Fh,0F0h,0C3h,0FFh,0FFh
		db	0CCh,0FFh,0F3h,0CFh,0FFh,0FFh
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 0Fh,0FFh,0FFh,0FCh, 0Fh,0CCh
		db	 03h,0FFh,0FFh,0F0h,0C3h, 00h
		db	 03h,0F0h, 03h,0C3h,0FFh,0C0h
		db	 00h, 00h, 00h, 03h,0FFh,0F0h
		db	 00h, 00h, 00h, 0Fh,0FFh,0FCh
		db	 00h, 00h, 00h, 0Fh,0FFh,0FFh
		db	 00h, 30h, 00h, 0Fh,0FFh,0FCh
		db	 30h,0FFh, 03h, 03h,0FFh,0FCh
		db	0F0h,0FFh, 0Fh,0C3h,0FFh,0F3h
		db	0FCh,0FFh, 3Fh,0CFh,0FFh,0FFh
		db	0CFh,0FFh,0FFh,0FFh, 0Fh,0FCh
		db	 03h,0FFh,0FFh,0FCh,0FFh,0F3h
		db	 00h,0FFh,0FFh,0FCh, 3Fh,0C0h
		db	 00h,0FCh, 00h, 3Fh, 0Fh,0F0h
		db	 00h, 00h, 00h, 00h, 3Fh,0FCh
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h
data_b_0ED0	db	0Fh
		db	0FFh,0FFh,0C0h, 03h, 00h,0C3h
		db	0FFh,0FFh, 03h, 0Fh,0C3h,0C0h
		db	0FFh,0FFh, 0Fh, 0Fh,0C3h,0F0h
		db	0FFh,0FFh, 3Fh,0C3h, 0Fh,0FCh
		db	 3Fh,0FFh,0F0h,0FCh,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C3h, 03h
		db	 3Fh,0FFh, 00h, 00h, 0Fh,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0FCh, 03h
		db	0FFh,0FFh,0F3h,0F0h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0CCh, 0Ch
		db	 3Fh,0FFh, 00h, 00h, 0Fh,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0FCh, 03h
		db	0FFh,0FFh,0F0h,0F0h,0FFh,0FFh
		db	0F0h, 00h,0FFh,0FFh,0C0h, 00h
		db	 3Fh,0FFh, 00h, 00h, 0Fh,0FFh
		db	0C0h, 00h, 3Fh,0FFh,0FCh, 03h
		db	0FFh,0C3h,0F0h, 03h,0FFh, 0Fh
		db	0C0h, 00h,0FFh,0C0h, 00h, 00h
		db	 3Fh,0FCh, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h, 3Fh,0FCh, 0Ch, 03h
		db	 0Fh,0FFh,0F0h, 03h,0FFh, 0Fh
		db	0C0h, 00h,0FFh,0C3h, 00h, 00h
		db	 3Fh,0FCh, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h, 3Fh,0FCh, 0Ch, 03h
		db	 0Fh,0FFh,0F0h, 03h,0FFh,0C0h
		db	0C0h, 00h,0FFh, 0Ch, 00h, 00h
		db	 3Fh,0FCh, 00h, 00h, 3Fh,0FFh
		db	 00h, 00h, 3Fh,0FCh, 0Ch, 03h
		db	 0Fh
data_b_0F7A	dw	0BD2h			; Data table (indexed access)
		db	 14h, 0Ch, 98h, 0Ch, 56h, 0Ch
		db	0DAh, 0Ch, 1Ch, 0Dh, 5Eh, 0Dh
		db	0A0h, 0Dh, 24h, 0Eh,0E2h, 0Dh
		db	 66h, 0Eh,0A8h, 0Eh
data_b_0F92	dw	0EEAh			; Data table (indexed access)
		db	 02h, 0Fh,0EAh, 0Eh, 02h, 0Fh
		db	0EAh, 0Eh, 02h, 0Fh,0EAh, 0Eh
		db	 1Ah, 0Fh
data_b_0FA2	dw	0F32h			; Data table (indexed access)
		db	 4Ah, 0Fh, 62h, 0Fh, 62h, 0Fh
data_b_0FAA	dw	0B12h			; Data table (indexed access)
data_b_0FAC	dw	0A2Eh
		db	0CAh, 0Ah, 96h, 0Bh
data_b_0FB2	dw	0A7Ch
		db	 5Ah, 0Bh
data_b_0FB6	dw	0C03h			; Data table (indexed access)
data_b_0FB8	dw	0D03h
		db	 03h, 0Ch, 03h, 0Ah
data_b_0FBE	dw	0D03h
		db	 03h, 0Ah
data_b_0FC2	dw	0A2Eh			; Data table (indexed access)
		db	0CAh, 0Ah,0D2h, 0Bh, 5Ah, 0Bh
		db	 7Ch, 0Ah, 96h, 0Bh, 5Eh, 0Dh
		db	 12h, 0Bh
data_b_0FD2	dw	0D03h			; Data table (indexed access)
		db	 03h, 0Ch, 03h, 0Bh, 03h, 0Ah
		db	 03h, 0Dh, 03h, 0Ah, 03h, 0Bh
		db	 03h
		db	0Ch
		db	14 dup (0)
data_b_0FF0	db	6			; Data table (indexed access)
		db	 90h, 1Ah, 26h, 3Ch,0C6h, 00h
		db	 86h, 8Eh, 18h, 28h,0C4h, 00h
		db	 06h, 90h
		db	28h
data_b_1000	db	0C2h
		db	 00h, 08h, 96h, 46h, 00h
data_b_1006	db	0			; Data table (indexed access)
		db	 07h, 0Dh, 12h, 0Dh, 12h, 0Dh
		db	 12h
data_b_100E	db	5			; Data table (indexed access)
		db	4, 3, 2, 3, 2, 3
data_b_1015	db	2			; Data table (indexed access)
data_b_1016	db	0			; Data table (indexed access)
		db	14 dup (0)
data_b_1025	db	0			; Data table (indexed access)
		db	 05h, 0Ah
data_b_1028	db	0
data_b_1029	db	78h			; Data table (indexed access)
		db	 98h, 88h, 98h, 78h, 88h
		db	'X`hX`hpx'
		db	 00h, 70h, 78h, 70h, 78h, 78h
		db	 98h, 98h, 78h, 58h, 60h, 68h
		db	 58h, 60h, 68h, 00h, 78h, 98h
		db	 88h
		db	 58h, 60h, 68h, 58h, 60h, 68h
data_b_1050	db	'  (H@Ph`hx'		; Data table (indexed access)
		db	 88h, 80h, 90h, 98h,0A0h,0A0h
		db	 18h, 20h, 28h, 30h, 38h, 40h
		db	 00h, 70h, 78h, 78h, 98h, 60h
		db	 88h, 98h, 78h, 98h, 78h, 58h
		db	 60h, 68h, 58h, 60h, 68h, 00h
		db	0A8h, 98h, 88h
		db	'08@08@PppP0HP'
		db	0
data_b_1089	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0
		db	8 dup (1)
		db	0, 1, 1, 1, 1, 0
		db	0, 0, 0, 1, 1, 1
		db	1, 1, 1, 0, 0, 0
		db	0, 1, 1, 1, 1, 1
		db	1, 0, 0, 0
		db	13 dup (1)
		db	7 dup (0)
		db	1, 1, 0, 0, 1, 0
		db	0, 0, 0, 0, 1, 1
		db	1, 1, 1, 1, 0, 0
		db	0, 0, 1, 1, 1, 1
		db	1, 1, 0, 0, 0, 0
		db	1, 1, 1, 0
data_b_10E9	dw	18h			; Data table (indexed access)
		db	 18h, 00h, 40h, 00h, 88h, 00h
		db	 90h, 00h,0D8h, 00h, 80h, 00h
		db	 80h, 00h, 80h, 00h,0B0h, 00h
		db	0B0h, 00h,0B0h, 00h, 10h, 01h
		db	 10h, 01h, 00h, 00h, 10h, 00h
		db	 10h, 00h, 88h, 00h, 88h, 00h
		db	 30h, 00h, 30h, 00h, 60h, 00h
		db	 68h, 00h, 38h, 00h, 38h, 00h
		db	 38h, 00h, 68h, 00h, 68h, 00h
		db	 68h, 00h, 00h, 00h,0E4h, 00h
		db	0E4h, 00h, 00h, 01h,0E8h, 00h
		db	0E8h, 00h,0E8h, 00h, 18h, 01h
		db	 18h, 01h, 18h, 01h
data_b_1137	dw	50h			; Data table (indexed access)
		db	 68h, 00h, 78h, 00h, 10h, 00h
		db	 40h, 00h, 70h, 00h, 20h, 00h
		db	 48h, 00h,0C0h, 00h, 58h, 00h
		db	 90h, 00h, 80h, 00h, 28h, 00h
		db	 60h, 00h, 18h, 00h,0B8h, 00h
		db	 18h, 00h, 38h, 00h, 58h, 00h
		db	 78h, 00h, 98h, 00h,0B8h, 00h
		db	 00h, 00h, 10h, 00h, 10h, 00h
		db	 38h, 00h, 38h, 00h, 58h, 00h
		db	 80h, 00h,0D0h, 00h,0D8h, 00h
		db	0F8h, 00h, 00h, 01h,0D0h, 00h
		db	0D0h, 00h,0D0h, 00h, 00h, 01h
		db	 00h, 01h, 00h, 01h, 00h
		db	7 dup (0)
		db	 20h, 00h, 20h, 00h, 20h, 00h
		db	 50h, 00h, 50h, 00h, 50h, 00h
		db	 48h, 00h, 48h, 00h,0D8h, 00h
		db	0E0h, 00h,0F8h, 00h, 10h, 01h
		db	 10h, 01h, 00h, 00h
data_b_11A9	dw	8			; Data table (indexed access)
		db	 10h, 00h, 28h, 00h, 10h, 00h
		db	 08h, 00h, 18h, 00h, 04h, 00h
		db	 04h, 00h, 04h, 00h, 04h, 00h
		db	 04h, 00h, 04h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 00h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 08h, 00h, 10h, 00h, 10h, 00h
		db	 08h, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 00h, 00h, 08h, 00h
		db	 10h, 00h, 18h, 00h, 04h, 00h
		db	 04h, 00h, 04h, 00h, 04h, 00h
		db	 04h, 00h, 04h, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 0Ch, 00h, 0Ch, 00h, 0Ch, 00h
		db	 68h, 00h, 58h, 00h, 48h, 00h
		db	 38h, 00h, 28h, 00h, 18h, 00h
		db	 00h, 00h, 0Ch, 00h, 0Ch, 00h
		db	 08h, 00h, 10h, 00h, 08h, 00h
		db	 28h, 00h, 10h, 00h, 08h, 00h
		db	 10h, 00h, 08h, 00h, 08h, 00h
		db	 08h, 00h, 08h, 00h, 08h, 00h
		db	 08h, 00h, 08h, 00h, 00h, 00h
		db	 40h, 01h, 40h, 01h, 40h, 01h
		db	 04h, 00h, 04h, 00h, 04h, 00h
		db	 04h, 00h, 04h, 00h, 04h, 00h
		db	 08h, 00h, 10h, 00h, 10h, 00h
		db	8
data_b_1260	db	0
		db	 08h, 00h, 0Ch, 00h, 0Ch
		db	0, 0, 0
data_b_1269	dw	0			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 0Fh, 00h
		db	 1Eh, 00h, 3Eh, 00h, 4Fh, 00h
		db	0, 0
data_b_1279	dw	0
data_b_127B	db	0
data_b_127C	db	0
		db	 00h, 00h, 00h,0AAh,0AAh,0AAh
		db	 00h, 00h,0AAh,0AFh,0AAh,0AAh
		db	0A0h, 00h, 00h, 00h, 00h,0F0h
		db	0AAh,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0AAh,0AFh, 00h, 00h
		db	 00h,0F0h, 0Fh, 00h, 0Ah,0AAh
		db	0F0h, 0Fh, 00h, 0Fh, 00h,0F0h
		db	 0Ah,0A0h, 00h,0F0h, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h, 00h
		db	0F0h,0F0h, 00h, 00h, 00h, 00h
		db	 0Fh, 00h, 0Fh, 0Fh, 00h,0FFh
		db	 00h,0A0h, 0Fh, 00h,0F0h, 00h
		db	 00h, 00h,0F0h,0A0h, 00h
data_b_12CA	db	0
		db	 00h, 00h, 00h,0F0h, 00h,0AAh
		db	 00h,0F0h, 00h, 00h, 00h,0F0h
		db	 0Ah,0AAh, 0Fh, 00h, 00h,0F0h
		db	 0Fh, 00h, 0Ah,0AAh,0F0h, 00h
		db	0FFh, 00h,0F0h, 00h,0AAh,0AAh
		db	0AAh,0AAh, 00h,0A0h,0AAh,0AAh
		db	9 dup (0AAh)
		db	0A0h,0AAh,0AAh,0FFh, 00h,0AAh
		db	0AAh,0A0h,0A0h,0AAh,0FFh,0FFh
		db	0FFh,0AAh,0FAh,0AAh,0AFh, 0Fh
		db	0F0h, 0Fh,0FFh,0FFh, 0Fh,0FAh
		db	0AFh,0FFh, 0Fh,0FFh, 0Fh,0FFh
		db	0F0h,0FAh,0FFh,0F0h,0FFh,0FFh
		db	0F0h,0FFh,0F0h,0FAh,0FFh,0FFh
		db	0FFh, 0Fh
		db	7 dup (0FFh)
		db	0Fh
		db	10 dup (0FFh)
		db	0F0h,0FAh,0F0h,0FFh,0FFh,0FFh
		db	0F0h,0FFh,0FFh, 0Ah,0AFh, 0Fh
		db	0F0h,0FFh,0F0h,0FFh,0FFh,0A0h
		db	0AFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0F0h,0AAh,0AFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0F0h,0AAh,0AAh, 0Fh
		db	 0Fh, 0Fh,0FFh,0FFh, 0Ah,0AAh
		db	0AAh,0A0h,0AAh,0F0h,0FFh,0A0h
		db	0AAh,0AAh
		db	8 dup (0AAh)
		db	0FAh,0FAh,0AAh, 0Fh,0F0h,0AAh
		db	0AAh,0AAh,0AAh, 0Fh,0AAh,0F0h
		db	 00h, 00h,0F0h,0AAh,0AAh,0F0h
		db	0AAh, 00h, 0Fh, 00h, 0Fh, 0Ah
		db	0A0h,0F0h,0AAh,0FFh, 00h,0F0h
		db	 00h,0FAh,0A0h,0AAh,0F0h, 00h
		db	 00h, 00h, 00h, 0Ah, 0Fh,0AAh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0FAh,0AAh, 00h, 00h, 00h, 00h
		db	 00h,0F0h,0FAh,0A0h, 00h, 00h
		db	 00h, 00h, 00h, 0Fh,0AFh,0A0h
		db	 00h, 00h, 00h,0F0h, 00h, 0Ah
		db	0AAh,0AAh, 00h, 00h, 00h, 0Fh
		db	 0Ah,0AAh,0AAh,0AFh, 00h, 00h
		db	 00h, 00h,0AAh, 0Ah,0AAh,0AAh
		db	0AAh, 00h, 00h,0AAh,0A0h, 0Fh
		db	0AFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 00h,0FAh,0FAh,0AAh,0AFh,0AAh
		db	0FAh
		db	11 dup (0AAh)
		db	 00h, 00h, 00h, 03h,0FFh, 00h
		db	 00h, 00h, 00h, 00h, 00h, 3Fh
		db	0FFh,0F0h, 00h, 00h, 00h, 3Fh
		db	0C0h,0FFh,0FFh,0F0h, 3Ch, 3Ch
		db	 03h,0FFh,0F3h,0FFh,0FFh,0FCh
		db	0FFh, 0Fh, 03h,0FFh,0D7h,0FFh
		db	0FFh,0FFh,0FFh, 03h, 3Fh, 0Fh
		db	0F5h,0FFh,0FFh,0FFh,0FFh,0CFh
		db	0FFh,0FFh,0D7h,0FFh,0FFh,0FFh
		db	0FFh,0FCh,0FFh,0FFh,0F5h,0FFh
		db	0FFh,0FFh,0FFh,0C0h, 0Fh, 3Fh
		db	0D7h,0FFh,0FFh,0FFh,0FFh,0C0h
		db	0CCh,0FFh,0F5h,0FFh, 3Fh,0FFh
		db	0CFh,0F0h,0FFh,0FFh,0F3h,0FCh
data_b_143C	db	0FFh
		db	0FCh, 0Fh,0F0h, 3Ch,0F3h,0C0h
		db	0FCh,0FCh, 00h, 03h,0FCh, 00h
		db	0F0h, 0Fh,0F0h, 00h, 00h, 00h
		db	 3Fh, 00h, 00h,0FFh, 00h, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 3Ch
		db	 00h
		db	7 dup (0)
		db	 03h,0FFh, 00h, 00h, 00h, 00h
		db	 3Fh,0C0h, 3Fh,0FFh,0F0h, 00h
		db	 00h, 00h,0FFh, 50h,0FFh,0FFh
		db	0F0h, 3Ch, 00h, 3Fh,0C3h,0D7h
		db	0FFh,0FFh,0FCh,0FFh, 00h,0FFh
		db	0FFh, 5Fh,0FFh,0FFh,0FFh,0FFh
		db	 00h,0FFh,0FFh,0D7h,0FFh,0FFh
		db	0FFh,0FFh,0C0h, 3Ch,0F3h, 5Fh
		db	0FFh,0FFh,0FFh,0FFh,0FCh, 0Ch
		db	 30h,0D7h,0FFh,0FFh,0FFh,0FFh
		db	 3Ch, 0Ch, 00h, 5Fh,0FFh,0FFh
		db	0F3h,0FFh,0CFh, 00h,0C0h,0D7h
		db	0F3h,0FFh,0F3h,0FFh,0C3h, 00h
		db	0F3h,0CFh,0F3h,0FFh,0FCh,0FFh
		db	 0Fh, 00h,0FFh, 00h,0FCh, 3Fh
		db	0F0h,0FCh, 0Ch, 00h, 3Ch, 00h
		db	 3Fh,0C0h, 03h,0FCh, 00h, 00h
		db	 00h, 00h, 03h,0F0h, 0Fh,0F0h
		db	 00h, 00h, 00h, 00h, 00h,0F0h
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh,0FFh,0FCh, 00h, 00h
		db	 00h, 3Ch, 3Ch, 0Fh,0FFh,0FFh
		db	 03h,0FCh, 00h,0F0h,0FFh, 3Fh
		db	0FFh,0FFh,0CFh,0FFh,0C0h,0C0h
		db	0FFh,0FFh,0FFh,0FFh,0D7h,0FFh
		db	0C0h,0F3h,0FFh,0FFh,0FFh,0FFh
		db	 5Fh,0F0h,0FCh, 3Fh,0FFh,0FFh
		db	0FFh,0FFh,0D7h,0FFh,0FFh, 03h
		db	0FFh,0FFh,0FFh,0FFh, 5Fh,0FFh
		db	0FFh, 03h,0FFh,0FFh,0FFh,0FFh
		db	0D7h,0FCh,0F0h, 0Fh,0F3h,0FFh
		db	0FCh,0FFh, 5Fh,0FFh, 33h, 0Fh
		db	0F0h, 3Fh,0FFh, 3Fh,0CFh,0FFh
		db	0FFh, 3Fh,0C0h, 00h, 3Fh, 3Fh
		db	 03h,0CFh, 3Ch,0FCh, 00h, 00h
		db	 00h, 0Fh,0F0h, 0Fh, 00h,0F0h
		db	 00h, 00h, 00h, 00h,0FFh
		db	7 dup (0)
		db	 3Ch, 00h, 00h, 00h, 00h, 00h
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh,0FFh,0FCh, 03h,0FCh
		db	 00h, 00h, 3Ch, 0Fh,0FFh,0FFh
		db	 05h,0FFh, 00h, 00h,0FFh, 3Fh
		db	0FFh,0FFh,0D7h,0C3h,0FCh, 00h
		db	0FFh,0FFh,0FFh,0FFh,0F5h,0FFh
		db	0FFh, 03h,0FFh,0FFh,0FFh,0FFh
		db	0D7h,0FFh,0FFh, 3Fh,0FFh,0FFh
		db	0FFh,0FFh,0F5h,0CFh, 3Ch, 3Ch
		db	0FFh,0FFh,0FFh,0FFh,0D7h, 0Ch
		db	 30h,0F3h,0FFh,0CFh,0FFh,0FFh
		db	0F5h, 00h, 30h,0C3h,0FFh,0CFh
		db	0FFh,0CFh,0D7h, 03h, 00h,0F0h
		db	0FFh, 3Fh,0FFh,0CFh,0F3h,0CFh
		db	 00h, 30h, 3Fh, 0Fh,0FCh, 3Fh
		db	 00h,0FFh, 00h, 00h, 3Fh,0C0h
		db	 03h,0FCh, 00h, 3Ch, 00h, 00h
		db	 0Fh,0F0h, 0Fh,0C0h, 00h, 00h
		db	 00h, 00h, 00h,0F0h, 0Fh, 00h
		db	 00h, 00h, 00h
data_b_15C8	dw	13E8h			; Data table (indexed access)
		db	 60h, 14h,0D8h, 14h, 50h, 15h
		db	0F8h, 12h, 80h, 12h, 70h, 13h
		db	 80h, 12h, 00h
		db	32 dup (0)
		db	 01h, 50h, 3Ch, 0Ch, 00h, 00h
		db	 00h, 00h, 01h, 00h, 3Fh,0FCh
		db	 00h, 00h, 00h, 14h, 51h, 40h
		db	0F3h,0F3h, 00h, 00h, 00h, 15h
		db	 51h, 03h,0FFh,0FFh,0C0h, 10h
		db	 10h, 11h, 11h, 50h,0FFh,0FFh
		db	 00h, 10h, 10h, 11h, 10h, 00h
		db	 0Fh,0F0h, 15h, 11h, 11h, 10h
		db	 10h, 0Ch, 3Fh,0F0h, 11h, 15h
		db	 51h, 00h, 00h, 30h,0FFh,0FCh
		db	 11h, 14h, 51h, 00h, 00h, 3Fh
		db	0FFh,0FFh, 11h, 00h, 00h
data_b_1640	dw	0
		db	 0Fh,0FFh,0FFh, 15h, 00h, 01h
		db	 00h, 00h, 03h,0FFh,0FCh, 00h
		db	 00h, 00h, 00h, 00h, 0Fh,0CFh
		db	 3Fh, 00h, 00h, 00h
data_b_1658	dw	18h			; Data table (indexed access)
		db	 68h, 00h,0B8h, 00h, 08h, 01h
data_b_1660	db	18h			; Data table (indexed access)
		db	 38h, 58h, 18h
data_b_1664	db	0
data_b_1665	db	0
data_b_1666	dw	0
data_b_1668	db	0
data_b_1669	db	0
data_b_166A	db	0
data_b_166B	db	0
data_b_166C	dw	0
data_b_166E	dw	0
data_b_1670	db	0
data_b_1671	dw	0
data_b_1673	db	0
data_b_1674	db	0
data_b_1675	db	0
data_b_1676	db	0
data_b_1677	db	0
data_b_1678	db	0
data_b_1679	db	0
		db	 00h, 00h, 00h, 0Fh, 03h,0C0h
		db	 03h,0C0h,0F0h, 00h, 00h, 3Ch
		db	 03h,0FFh, 3Fh,0CFh,0F3h,0F0h
		db	0FCh, 00h, 0Ch, 0Fh, 0Fh,0ABh
		db	0FAh,0FEh,0BEh,0B3h,0EBh, 03h
		db	 3Ch, 3Fh,0C3h,0AAh,0BEh,0BEh
		db	0BEh,0BFh,0EBh, 03h,0F0h,0FFh
		db	0FFh,0AFh
		db	0AEh,0BEh,0BAh,0FFh,0ACh, 00h
		db	0FCh,0FAh,0BFh,0EBh,0AFh,0AEh
		db	0ABh,0FFh,0ACh, 03h,0FFh,0EBh
		db	0AFh,0EBh,0EBh,0AEh,0ABh,0FEh
		db	0BCh,0CFh,0FFh,0EBh,0EBh,0FAh
		db	0EAh,0BEh,0BAh,0FEh,0BFh,0FEh
		db	0AFh,0FAh,0FAh,0FAh,0FAh,0FAh
		db	0FAh,0FFh,0F3h,0FAh,0ABh,0FAh
		db	0FAh,0FAh,0FFh,0FAh,0FEh,0BAh
		db	0C0h, 3Ah,0FBh,0FEh,0BEh,0BFh
		db	 3Fh, 3Fh, 3Fh,0FAh,0F0h, 3Ah
		db	0EAh,0BEh,0AEh,0BFh,0FCh, 3Fh
		db	0CFh,0FFh,0C0h,0FEh,0ABh,0AFh
		db	0EAh,0F3h,0F0h, 3Ch, 0Fh,0FFh
		db	 00h,0FFh,0AFh,0AFh,0FFh,0F0h
		db	0C0h, 0Ch, 00h, 3Fh,0C0h,0C3h
		db	0EAh,0AFh, 3Fh,0C0h, 00h, 00h
		db	 00h, 03h,0F0h, 0Fh,0FAh,0BCh
		db	 03h,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh, 3Fh,0C0h, 00h, 00h
		db	 00h, 00h
data_b_1720	db	0
		db	 00h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 3Ch, 00h, 00h, 00h, 0Fh
		db	0C0h, 00h, 00h, 00h,0FCh, 00h
		db	 00h, 03h,0CFh, 00h, 00h, 0Fh
		db	0C3h,0C0h, 00h, 3Dh,0F0h,0C0h
		db	 00h,0FFh, 7Fh,0C0h, 03h,0F7h
		db	0FFh, 00h, 03h, 7Dh,0FCh, 00h
		db	 03h,0DFh,0F0h, 00h, 00h,0F7h
		db	0C0h, 00h, 00h, 3Fh, 00h, 00h
		db	 00h,0FFh,0FFh, 00h, 03h,0CCh
		db	 33h,0C0h, 03h,0CDh, 73h,0C0h
		db	 00h, 0Dh, 70h, 00h, 00h, 34h
		db	 1Ch, 00h, 00h,0D3h,0C7h, 00h
		db	 00h,0D3h,0C7h, 00h, 00h,0D4h
		db	 17h, 00h, 00h,0D5h, 57h, 00h
		db	 0Fh, 00h, 00h, 00h, 00h, 54h
		db	 00h, 00h, 00h, 55h, 50h, 00h
		db	 00h, 05h, 55h, 00h, 00h, 00h
		db	 15h, 00h, 00h, 00h, 00h,0F0h
		db	 00h,0C0h, 00h, 00h, 03h, 30h
		db	 00h, 00h, 0Ch, 1Ch, 00h,0F0h
		db	 30h, 53h, 03h, 1Ch, 31h, 55h
		db	0CDh, 5Ch, 3Dh, 55h, 31h, 5Ch
		db	 0Fh, 55h, 55h, 7Ch, 03h,0D5h
		db	 55h, 70h, 00h,0F5h, 55h,0C0h
		db	 00h, 3Dh, 57h, 00h, 00h, 0Fh
		db	 7Ch, 00h, 00h, 03h,0F0h, 00h
data_b_17C9	dw	175Dh			; Data table (indexed access)
		db	 81h, 17h, 2Dh, 17h, 99h, 17h
data_b_17D1	dw	902h			; Data table (indexed access)
		db	 02h, 06h, 02h, 0Ch, 02h, 0Ch
data_b_17D9	db	61h			; Data table (indexed access)
		db	 64h, 5Eh, 5Eh
data_b_17DD	db	0, 0
data_b_17DF	dw	0
data_b_17E1	dw	0
data_b_17E3	dw	0
data_b_17E5	dw	0
data_b_17E7	dw	0
data_b_17E9	db	0
data_b_17EA	dw	0
data_b_17EC	dw	0
data_b_17EE	db	0
		db	47 dup (0)
data_b_181E	dw	2Dh			; Data table (indexed access)
		db	 24h, 00h, 1Bh, 00h, 12h, 00h
		db	 09h, 00h, 12h, 00h, 01h, 00h
		db	 12h
		db	0, 0, 0
data_b_1830	dw	0
data_b_1832	dw	0
data_b_1834	db	0
data_b_1835	dw	0			; box width
data_b_1837	db	0			; box height
data_b_1838	db	0
data_b_1839	dw	0			; box color pattern

		; PCjr palette 1 of scene 1..7, 0=intro
data_b_183B	db	0Ah			; Data table (indexed access)
		db	 09h, 0Bh, 0Bh, 0Eh, 09h, 06h
		db	 0Ah

		; PCjr palette 2 of scene 1..7, 0=intro
data_b_1843	db	9			; Data table (indexed access)
		db	 0Eh, 04h, 06h, 0Ch, 0Ah, 0Dh
		db	 04h

		; PCjr palette 3 of scene 1..7, 0=intro
data_b_184B	db	0Fh			; Data table (indexed access)
		db	7 dup (0Fh)

		; CGA palette of scene 1..7, 0=intro
data_b_1853	db	1, 01h, 01h, 01h, 00h, 00h, 01h, 00h

		db	00h, 0Fh,0F0h, 00h, 00h
		db	 3Fh,0C0h, 00h, 03h,0FCh, 00h
		db	 0Fh,0F0h, 00h, 03h,0C0h, 00h
		db	0FCh, 3Ch, 00h, 03h,0F0h,0F0h
		db	 00h, 0Fh, 03h, 00h,0FFh,0FCh
		db	 00h, 0Fh,0C0h, 0Fh,0C0h, 0Fh
		db	 00h, 3Fh, 00h, 3Ch, 00h, 3Ch
		db	 00h,0C3h,0FCh, 3Fh, 00h, 3Fh
		db	 00h, 3Fh,0C0h, 0Fh, 00h,0FFh
		db	 00h, 3Ch, 00h, 3Ch, 00h,0C3h
		db	0F0h, 0Fh, 00h, 3Fh, 00h, 3Fh
		db	 00h, 0Fh, 00h,0FCh, 00h, 3Ch
		db	 00h,0FFh, 03h,0C3h,0F0h, 00h
		db	 00h,0FCh, 00h,0FFh, 00h, 0Fh
		db	 03h,0FCh, 00h, 3Ch, 00h,0FFh
		db	0FFh,0C0h,0FCh, 00h, 00h,0FCh
		db	 00h,0FFh, 00h, 3Ch, 03h,0FCh
		db	 00h,0F0h, 03h,0FFh,0FFh, 00h
		db	0FFh, 00h, 03h,0F0h, 00h,0FFh
		db	0C3h,0FCh, 03h,0FFh, 0Fh,0F0h
		db	 03h,0F0h,0FCh, 00h, 3Fh,0C0h
		db	 03h,0C0h, 00h, 3Fh,0FFh,0F0h
		db	 00h,0FFh,0FFh,0C0h, 0Fh,0C0h
		db	 00h, 00h, 3Fh,0C0h, 00h, 00h
		db	 00h, 3Fh,0FFh,0F0h, 00h,0FFh
		db	0FFh,0C0h, 3Fh, 00h, 0Fh,0C0h
		db	0FFh,0C0h, 3Ch, 00h, 00h, 0Fh
		db	0FFh,0C0h, 00h, 3Fh,0FFh, 00h
data_b_1902	db	0FCh
		db	 00h, 03h,0FFh,0FFh, 00h,0FCh
		db	 00h, 00h, 00h,0FCh, 00h, 00h
		db	 03h,0F0h, 0Fh,0C0h, 00h, 00h
		db	 3Fh,0F0h, 00h,0F0h, 00h, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h,0F0h
		db	 00h, 00h, 0Fh,0F0h, 0Fh,0C0h
		db	 0Fh, 00h, 03h,0C0h, 00h,0FCh
		db	 3Ch, 00h, 0Fh,0C0h, 03h, 00h
		db	0FFh, 3Ch, 03h,0F0h, 0Fh, 00h
		db	 0Fh,0C0h, 0Fh,0C0h, 0Fh, 00h
		db	 3Fh, 00h, 0Fh, 03h,0F0h, 0Fh
		db	 00h,0FCh, 0Fh, 00h, 3Fh, 00h
		db	 3Fh,0C0h, 0Fh, 00h,0FFh, 00h
		db	 0Fh, 0Fh,0F0h, 00h, 00h,0FCh
		db	 03h,0C0h, 3Fh, 00h, 3Fh, 00h
		db	 0Fh, 00h,0FCh, 00h, 3Ch, 0Fh
		db	0C0h, 00h, 00h,0FCh, 03h,0C0h
		db	0FCh, 00h,0FFh, 00h, 0Fh, 03h
		db	0FCh, 00h, 3Ch, 3Fh,0C0h, 00h
		db	 00h, 3Fh,0FFh,0C0h,0FCh, 00h
		db	0FFh, 00h, 3Ch, 03h,0FCh, 00h
		db	0F0h, 3Fh,0C0h, 00h, 00h, 3Fh
		db	0FFh,0C3h,0F0h, 00h,0FFh,0C3h
		db	0FCh, 03h,0FFh, 0Fh,0F0h, 3Fh
		db	0F0h, 03h, 00h,0FCh, 0Fh, 03h
		db	0C0h, 00h, 3Fh,0FFh,0F0h, 00h
		db	0FFh,0FFh,0C0h, 0Fh,0FCh, 3Fh
		db	 00h,0FCh, 0Fh, 00h, 00h, 00h
		db	 3Fh,0FFh,0F0h, 00h,0FFh,0FFh
		db	0C0h, 0Fh,0FFh,0FCh, 03h,0F0h
		db	 3Ch, 3Ch, 00h, 00h, 0Fh,0FFh
		db	0C0h, 00h, 3Fh,0FFh, 00h, 03h
		db	0FFh,0F0h, 0Fh,0C0h, 3Ch,0FCh
		db	 00h, 00h, 00h,0FCh, 00h, 00h
		db	 03h,0F0h, 00h, 00h, 3Fh, 00h
		db	0FCh, 00h, 3Ch,0F0h, 00h, 00h
		db	 00h, 03h,0F0h, 00h, 0Fh,0C0h
		db	 00h, 00h, 3Fh, 00h, 00h, 0Fh
		db	0F0h, 00h, 03h,0C0h, 00h, 3Fh
		db	0FFh, 00h, 3Fh, 00h, 00h, 03h
		db	0FFh,0F0h, 00h,0FFh,0FCh, 00h
		db	 0Fh,0C0h, 00h,0FFh, 0Fh, 00h
		db	 3Fh, 00h, 00h, 0Fh,0F0h,0F0h
		db	 03h,0FCh, 3Fh, 00h, 3Fh, 00h
		db	 03h,0FCh, 03h,0C0h,0FCh, 00h
		db	 00h, 3Fh,0C0h, 3Ch, 03h,0F0h
		db	 0Fh, 00h, 3Fh, 00h, 0Fh,0F0h
		db	 03h,0C0h,0FCh, 00h, 00h,0FFh
		db	 00h, 3Ch, 03h,0F0h, 00h, 00h
		db	0FCh, 00h, 0Fh,0FFh,0FFh,0C3h
		db	0F0h, 00h, 00h,0FFh,0FFh,0FCh
		db	 00h,0FCh, 00h, 00h,0FCh, 00h
		db	 3Fh,0FFh,0FFh,0C3h,0F0h, 00h
		db	 03h,0FFh,0FFh,0FCh, 00h,0FFh
		db	 00h, 03h,0F0h, 00h, 3Fh,0C0h
		db	 0Fh,0CFh,0C0h, 00h, 03h,0FCh
		db	 00h,0FCh, 00h, 3Fh,0C0h, 03h
		db	0C0h, 00h, 3Fh,0C0h, 0Fh, 0Fh
		db	0C0h, 00h, 03h,0FCh, 00h,0F0h
		db	 00h, 3Fh,0C0h, 00h, 00h, 00h
		db	0FFh, 00h, 0Fh, 0Fh,0C3h,0FFh
		db	 0Fh,0F0h, 00h,0F3h,0C0h,0FFh
		db	0C0h, 3Ch, 00h, 00h,0FFh, 00h
		db	 3Ch, 3Fh,0FFh,0FFh, 0Fh,0F0h
		db	 03h,0C3h,0FFh,0FFh, 00h,0FCh
		db	 00h, 00h,0FFh, 00h, 3Ch, 3Fh
		db	0FFh, 00h, 0Fh,0F0h, 03h,0C0h
		db	 3Fh,0F0h, 00h,0F0h, 00h, 00h
		db	 00h, 00h, 3Fh,0C0h, 00h, 0Fh
		db	0C0h, 0Fh,0FFh,0FFh,0C3h,0F0h
		db	 00h, 0Fh, 03h,0C0h, 00h, 00h
		db	0F0h, 30h, 00h, 0Fh,0C0h,0FFh
		db	0FFh,0FFh,0F0h, 3Fh, 00h,0FCh
		db	 0Fh,0C0h, 00h, 03h,0C0h, 0Ch
		db	 00h, 3Fh, 03h,0F0h, 0Fh,0C0h
		db	0F0h, 0Fh, 03h,0F0h, 3Fh, 00h
		db	 00h, 03h,0C0h, 0Ch, 00h, 3Fh
		db	 0Fh, 00h, 0Fh,0C3h,0C0h, 03h
		db	0CFh,0C0h, 3Fh, 00h, 00h, 0Fh
		db	0F0h, 3Ch, 00h,0FCh, 00h, 00h
		db	 3Fh, 00h, 00h, 03h,0FFh, 00h
		db	0FCh, 00h, 00h, 0Fh,0FFh,0FCh
		db	 00h,0FCh, 00h, 00h, 3Fh, 00h
		db	 00h, 00h,0FCh, 00h,0FCh, 00h
		db	 00h, 3Fh,0FFh,0F0h, 03h,0F0h
		db	 00h, 00h,0FCh, 00h, 00h, 03h
		db	0F0h, 03h,0F0h, 00h, 00h, 3Fh
		db	 0Fh,0C0h, 03h,0F0h, 00h, 00h
		db	0FCh, 00h, 00h, 03h,0F0h, 03h
		db	0C0h, 00h, 00h,0FCh, 00h, 00h
		db	 0Fh,0C0h, 00h, 03h,0F0h, 00h
		db	 00h, 0Fh,0C0h, 00h, 00h, 00h
		db	 03h,0F0h, 00h, 00h, 3Fh, 00h
		db	 00h, 0Fh,0C0h, 00h, 00h, 3Fh
		db	 00h, 3Ch, 00h, 00h, 0Fh,0C0h
		db	 00h, 00h,0FCh, 00h, 00h, 3Fh
		db	 00h, 00h, 00h,0FCh, 00h,0FCh
		db	 00h, 00h,0FCh, 00h, 00h, 0Fh
		db	0C0h, 00h, 03h,0F0h, 00h, 00h
		db	 0Fh,0C0h, 00h,0F0h, 00h, 00h
		db	 00h, 03h,0F0h, 00h, 00h, 3Fh
		db	0F0h, 00h, 0Fh,0F0h, 0Fh,0C0h
		db	 0Fh, 00h, 03h,0C0h, 00h, 3Fh
		db	0FFh, 00h, 00h,0F0h, 3Ch, 00h
		db	0FFh, 3Ch, 03h,0F0h, 0Fh, 00h
		db	 0Fh,0C0h, 00h,0FFh, 0Fh, 00h
		db	 03h,0C0h, 0Fh, 03h,0F0h, 00h
		db	 00h,0FCh, 0Fh, 00h, 3Fh, 00h
		db	 03h,0FCh, 03h,0C0h, 03h,0C0h
		db	 0Fh, 0Fh,0F0h, 00h, 00h,0F0h
		db	 03h,0C0h, 3Fh, 00h, 0Fh,0F0h
		db	 03h,0C0h, 0Fh,0F0h, 3Fh, 0Fh
		db	0C0h, 00h, 00h,0FCh, 03h,0C0h
		db	0FCh, 00h, 0Fh,0FFh,0FFh,0C0h
		db	 0Fh,0FFh,0FFh, 3Fh,0C3h,0FCh
		db	 00h, 3Fh,0FFh,0C0h,0FCh, 00h
		db	 3Fh,0FFh,0FFh,0C0h, 3Fh,0FFh
		db	0FCh, 3Fh,0C3h,0FFh, 00h, 3Fh
		db	0FFh,0C0h,0F0h, 00h, 3Fh,0C0h
		db	 0Fh,0C0h, 3Fh, 3Fh, 00h, 3Fh
		db	0F0h, 0Fh, 00h,0FCh, 0Fh, 03h
		db	0C0h, 00h, 3Fh,0C0h, 0Fh, 00h
		db	0FCh, 0Fh, 00h, 0Fh,0FCh, 3Fh
		db	 00h,0FCh, 0Fh, 00h, 00h, 00h
		db	0FFh, 00h, 0Fh, 00h,0FCh, 03h
		db	0C0h, 0Fh,0FFh,0FCh, 03h,0F0h
		db	 3Ch, 3Ch, 00h, 00h,0FFh, 00h
		db	 3Ch, 03h,0F0h, 00h,0F0h, 03h
		db	0FFh,0F0h, 0Fh,0C0h, 3Ch,0FCh
		db	 00h, 00h,0FFh, 00h, 3Ch, 03h
		db	0F0h, 00h, 3Ch, 00h, 3Fh, 00h
		db	0FCh, 00h, 3Ch,0F0h, 00h, 00h
data_b_1C1B	dw	0
data_b_1C1D	db	0
data_b_1C1E	dw	0FFFFh			; Data table (indexed access)
		db	0AAh,0AAh,0FFh,0FFh, 55h, 55h
data_b_1C26	dw	191Bh			; Data table (indexed access)
		db	0DBh, 19h, 9Bh, 1Ah, 5Bh, 1Bh
data_b_1C2E	dw	0
data_b_1C30	dw	0
		db	14 dup (0)
data_b_1C40	db	0
		db	119 dup (0)
data_b_1CB8	db	0
data_b_1CB9	dw	0
data_b_1CBB	dw	0
data_b_1CBD	dw	0
data_b_1CBF	db	0
data_b_1CC0	db	0
data_b_1CC1	db	0
data_b_1CC2	dw	0
data_b_1CC4	dw	0
data_b_1CC6	dw	0
data_b_1CC8	db	0
data_b_1CC9	dw	0
		db	0, 0
data_b_1CCD	dw	0
data_b_1CCF	db	0
data_b_1CD0	db	0
data_b_1CD1	db	2			; Data table (indexed access)
		db	 04h, 08h, 0Ch, 10h, 18h, 20h
		db	 40h
data_b_1CD9	db	10h			; Data table (indexed access)
		db	 20h, 30h, 40h, 50h, 60h, 70h
		db	 80h
data_b_1CE1	db	15 dup (0)
data_b_1CF0	db	0
		db	 08h, 02h, 00h, 00h, 2Eh, 0Bh
		db	 80h, 00h, 2Fh,0AFh, 80h, 00h
		db	 2Fh,0FFh, 80h, 00h,0BAh,0FAh
		db	0E0h, 02h,0FFh,0AFh,0F8h, 02h
		db	0BFh,0FFh,0E8h, 02h,0FBh,0AEh
		db	0F8h, 00h,0ABh,0AEh,0A0h, 00h
		db	 2Eh,0FBh, 80h, 00h, 0Ah,0FAh
		db	 00h, 00h, 02h,0F8h, 00h, 00h
		db	 02h,0F8h
		db	0
data_b_1D24	db	0
		db	19 dup (0)
data_b_1D38	db	0
		db	31 dup (0)
data_b_1D58	db	0
data_b_1D59	db	0
data_b_1D5A	dw	0
data_b_1D5C	dw	0
data_b_1D5E	db	0
data_b_1D5F	db	0
data_b_1D60	dw	0
data_b_1D62	dw	0
data_b_1D64	dw	0
data_b_1D66	dw	0
		db	0, 0, 0, 0, 0, 0
data_b_1D6E	db	0
		db	0
data_b_1D70	db	0Ah
		db	 0Bh,0FEh, 02h, 80h, 0Bh,0E0h
		db	0BFh,0AFh, 8Bh,0E0h,0B8h
		db	 2Fh, 8Bh,0EFh, 8Bh,0EAh, 2Fh
		db	 80h,0BBh,0EFh,0AFh, 82h,0F8h
		db	0BEh, 2Fh,0ABh,0EBh,0EFh,0BEh
		db	0A2h,0FAh,0EFh,0BEh, 02h,0F8h
		db	0BEh, 2Fh,0ABh
		db	0EFh,0AFh
		db	0BEh,0FAh,0FEh, 8Bh,0F8h, 02h
		db	0F8h, 2Fh,0AFh
		db	0BBh,0AFh,0BEh,0AFh,0EBh,0EFh
		db	 8Bh,0FEh, 02h,0E0h, 0Bh,0EBh
		db	0FEh, 2Fh,0BEh, 2Fh,0ABh,0EAh
		db	 0Bh,0EFh, 80h, 80h, 2Bh,0E2h
		db	0AFh, 8Bh,0F8h, 2Fh,0BAh,0FAh
		db	 0Bh,0EBh,0EBh,0E0h,0BFh, 80h
		db	 2Bh, 82h,0A0h, 0Bh,0F8h,0BEh
		db	 02h, 82h, 8Bh,0E0h, 03h,0FFh
		db	0FFh,0C0h, 3Eh,0ABh,0EAh,0BCh
		db	 3Eh,0FFh,0EFh,0BCh,0FEh,0ABh
		db	0EFh,0BFh,0FFh,0FBh,0EFh,0BFh
		db	 3Fh,0FBh,0EFh,0BCh, 3Eh,0ABh
		db	0EAh,0BCh
data_b_1DEC	db	3
		db	0FFh,0FFh,0C0h, 03h,0FFh,0FFh
		db	0C0h, 3Eh,0ABh,0EAh,0BCh, 3Fh
		db	0FBh,0EFh,0BCh,0FFh,0FBh,0EFh
		db	0BFh
data_b_1E00	db	0FFh
		db	0EFh,0EFh,0BFh, 3Fh,0EFh,0EFh
		db	0BCh, 3Fh,0EFh,0EAh,0BCh, 03h
		db	0FFh,0FFh,0C0h, 03h,0FFh,0FFh
		db	0C0h, 3Eh,0ABh,0EAh,0BCh, 3Eh
		db	0FBh,0EFh,0BCh,0FEh,0ABh,0EFh
		db	0BFh,0FFh,0FBh,0EFh,0BFh, 3Fh
		db	0FBh,0EFh,0BCh, 3Fh,0FBh,0EAh
		db	0BCh, 03h,0FFh,0FFh,0C0h,0FFh
		db	 03h,0C0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0F0h, 0Fh,0FFh,0FCh
		db	 3Ch, 3Ch, 3Fh,0FFh, 00h, 00h
		db	0FFh,0FFh,0F0h, 0Fh,0FFh,0FFh
		db	 00h, 00h,0FFh,0FCh
		db	 30h, 0Ch, 3Fh
data_b_1E50	db	0FFh
		db	0FFh,0FFh,0FFh,0C3h,0F0h, 3Ch
		db	 3Fh, 3Ch,0C0h, 00h, 0Fh,0FFh
		db	 00h, 00h, 03h,0C3h, 00h, 00h
		db	 0Fh,0F0h, 00h, 00h,0FFh,0FFh
		db	0F0h, 3Ch, 3Fh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0F0h,0FFh,0FFh
		db	0C0h,0C0h, 3Fh,0FCh, 00h, 00h
		db	 0Fh,0F3h, 00h, 00h, 3Fh,0CFh
		db	 00h, 03h,0FFh,0FFh, 00h, 00h
		db	 0Fh,0FCh, 30h, 3Fh,0FFh,0F0h
		db	7 dup (0FFh)
		db	0FCh, 3Ch, 0Fh,0C3h,0F0h, 00h
		db	 03h, 3Ch,0C0h, 00h, 00h,0FFh
		db	0F0h, 00h, 00h,0C3h,0FFh, 00h
		db	 00h, 0Fh,0FCh, 3Ch, 0Fh,0FFh
		db	0F0h,0FFh,0FFh,0FFh,0FFh, 0Fh
		db	0FFh,0FFh,0FCh, 03h, 03h,0FFh
		db	0F0h, 00h, 00h, 3Fh,0FCh, 00h
		db	 00h,0CFh,0FFh,0C0h, 00h,0F3h
		db	0F0h, 00h, 00h,0FFh,0FFh,0FCh
		db	 0Ch, 3Fh,0FFh,0FFh,0FFh, 0Fh
		db	96 dup (0)
data_b_1F30	dw	0			; Data table (indexed access)
data_b_1F32	dw	0
data_b_1F34	dw	0
data_b_1F36	db	0			; Data table (indexed access)
		db	 20h, 40h
data_b_1F39	db	9			; Data table (indexed access)
		db	7, 5
data_b_1F3C	db	0			; Data table (indexed access)
data_b_1F3D	db	0
data_b_1F3E	db	0
data_b_1F3F	db	0			; Data table (indexed access)
		db	0, 0
data_b_1F42	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0
data_b_1F48	db	0			; Data table (indexed access)
data_b_1F49	db	0
data_b_1F4A	db	0
data_b_1F4B	dw	0
data_b_1F4D	db	0			; Data table (indexed access)
		db	0, 0
data_b_1F50	db	0			; Data table (indexed access)
data_b_1F51	db	0
data_b_1F52	db	0
data_b_1F53	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0
data_b_1F59	dw	1ED0h			; Data table (indexed access)
		db	0F0h, 1Eh, 10h, 1Fh
data_b_1F5F	dw	1E10h			; Data table (indexed access)
		db	0F0h, 1Dh,0D0h, 1Dh
data_b_1F65	db	0, 0
data_b_1F67	dw	0
data_b_1F69	dw	0
		db	0
data_b_1F6C	dw	0
data_b_1F6E	db	8			; Data table (indexed access)
		db	 20h, 40h, 80h,0A0h,0C0h,0D0h
		db	0F0h
		db	10 dup (0)
data_b_1F80	db	0			; cat lives (1..9)
data_b_1F81	db	0			; current display cat lives (1..9)
data_b_1F82	db	0, 0, 0, 0, 0, 0, 0	; digits of current score
data_b_1F89	db	0, 0, 0, 0, 0, 0, 0	; digits of max score
data_b_1F90	dw	0
data_b_1F92	db	0			; digit position
data_b_1F93	dw	0			; pointer to score digits
		db	11 dup (0)
data_b_1FA0	db	55h
		db	 55h, 55h, 55h, 40h, 00h, 00h
		db	 01h, 40h, 00h, 00h, 01h, 40h
		db	 0Ah, 80h, 01h, 40h, 2Ah,0A0h
		db	 01h, 40h, 3Fh,0FCh, 01h, 40h
		db	0C3h,0C3h, 01h, 40h,0FFh,0FFh
		db	 01h, 40h,0CCh, 33h, 01h, 40h
		db	 33h,0CCh, 01h, 40h, 0Fh,0F0h
		db	 01h, 40h, 03h,0C0h, 01h, 40h
		db	 0Bh,0E0h, 01h, 40h, 2Ah,0E8h
		db	 01h, 40h, 2Ah,0A8h, 01h
		db	55h
		db	 55h, 55h, 55h
data_b_1FE0	db	55h
		db	 55h, 55h, 55h, 40h, 00h, 00h
		db	 01h, 40h, 01h, 40h, 01h, 40h
		db	 15h,0D4h, 01h, 40h, 5Fh,0FDh
		db	 01h, 41h, 73h,0CDh, 41h, 41h
		db	0C4h, 13h, 41h, 41h,0F3h,0CFh
		db	 41h, 41h, 7Fh,0FFh, 41h, 41h
		db	 7Ch, 3Dh, 41h, 41h, 4Fh,0F1h
		db	 41h, 41h, 43h,0C1h, 01h, 41h
		db	 0Bh,0E0h, 01h
data_b_2014	db	40h
		db	2Bh
data_b_2016	db	0A8h			; Data table (indexed access)
		db	 01h, 40h, 2Ah,0A8h, 01h, 55h
		db	 55h, 55h, 55h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 55h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 55h, 55h
		db	 55h,0AAh,0AAh,0A5h,0AAh, 95h
		db	 59h, 55h, 55h,0A5h,0AAh, 95h
		db	 5Ah, 55h, 55h, 55h, 55h,0AAh
		db	0AAh,0AAh,0AAh,0FFh,0FFh,0EAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AFh
		db	0FFh,0FFh, 55h, 55h, 7Fh,0FFh
		db	0FEh,0AAh,0AAh,0AFh,0F5h, 55h
		db	 55h, 55h, 55h, 55h, 55h, 57h
		db	0FEh,0AAh,0FDh
		db	8 dup (55h)
		db	 5Fh,0EAh,0FFh
		db	'UUUUUUUU'
		db	 7Fh,0EAh,0FFh,0FDh, 55h, 55h
		db	 55h, 55h, 55h, 55h, 5Fh,0FFh
		db	0EAh,0AFh,0FFh,0FFh,0FFh,0D5h
		db	 55h,0FFh,0FFh,0FFh,0FEh,0AAh
		db	0AAh,0AFh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0FFh,0FEh,0AAh,0AAh, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0C0h
		db	 00h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh,0AAh,0ABh,0FFh,0FFh,0FFh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0BFh,0FFh,0FDh, 55h
		db	 55h, 55h, 55h,0FFh,0FFh,0FAh
		db	0AAh,0AAh,0AAh,0FFh,0D5h
		db	8 dup (55h)
		db	 5Fh,0FEh,0AAh,0AFh
		db	11 dup (55h)
		db	 57h,0EAh,0FDh, 55h, 55h, 55h
		db	9 dup (55h)
		db	 7Eh,0FDh
		db	12 dup (55h)
		db	0FEh,0FFh,0D5h
		db	10 dup (55h)
		db	 5Fh,0FEh, 9Fh,0FFh,0F5h
		db	8 dup (55h)
		db	 7Fh,0FFh,0EAh, 16h,0FFh,0FFh
		db	0FFh,0FFh, 55h, 55h, 55h, 57h
		db	0FFh,0FFh,0FFh,0FDh, 00h, 96h
		db	0AAh, 7Fh
		db	8 dup (0FFh)
		db	0F6h,0A5h,0AAh, 96h,0AAh, 5Ah
		db	0AAh,0ABh,0FFh,0FFh,0FFh,0FFh
		db	0AAh,0AAh, 96h,0A5h,0AAh, 96h
		db	0AAh, 5Ah, 96h,0AAh, 5Ah, 96h
		db	0AAh, 5Ah, 96h,0AAh, 5Ah, 96h
		db	0AAh, 5Ah, 96h,0AAh, 5Ah, 96h
		db	0AAh, 5Ah, 96h,0AAh, 5Ah, 96h
		db	0AAh
		db	5Ah
		db	16 dup (96h)
		db	0A5h, 96h,0A5h, 96h,0A5h, 96h
		db	0A5h, 96h,0A5h, 96h,0A5h, 96h
		db	0A5h, 96h,0A5h, 96h,0A5h, 96h
		db	16 dup (0A5h)
		db	 0Eh, 0Bh,0A3h, 20h, 00h, 00h
		db	0FFh,0FFh, 03h, 09h, 3Dh, 21h
		db	 90h, 21h,0FFh,0FFh, 02h, 0Ah
		db	 67h, 21h, 9Bh, 21h,0FFh,0FFh
		db	 01h, 0Fh, 58h, 21h, 20h, 03h
		db	 7Bh, 21h, 2Ch, 23h,0FFh,0FFh
		db	0AAh,0AAh,0FFh,0FAh,0AAh,0AAh
		db	0AAh,0AFh,0D5h,0FFh,0AAh,0AAh
		db	0AAh,0B5h, 55h, 57h,0FAh,0AAh
		db	0AAh,0B5h, 55h, 55h, 7Eh,0AAh
		db	0AAh,0D5h, 55h, 55h, 7Eh,0AAh
		db	0AAh,0D5h, 55h, 55h, 5Fh,0AAh
		db	0ABh, 55h, 55h, 55h, 5Fh,0AAh
		db	0ABh, 55h, 55h, 55h, 57h,0EAh
		db	0ABh, 55h, 55h, 55h, 57h,0EAh
		db	0ADh, 55h, 55h, 55h, 57h,0EAh
		db	0ADh, 55h, 55h, 55h, 55h,0FAh
		db	0ADh, 55h, 55h, 55h, 55h,0FAh
		db	 0Fh, 55h, 55h, 55h, 55h,0F0h
		db	0ABh, 55h, 55h, 55h, 55h,0FAh
		db	0ABh, 55h, 55h, 55h, 55h,0FAh
		db	0ABh, 55h, 55h, 55h, 55h,0FAh
		db	0ABh, 55h, 55h, 55h, 55h,0FAh
		db	0AAh,0D5h, 55h, 55h, 57h,0EAh
		db	0AAh, 80h, 00h, 00h, 02h,0AAh
		db	0AAh,0AAh,0AFh,0D5h, 55h, 55h
		db	 57h,0EAh,0AAh,0AFh,0FDh, 55h
		db	 55h, 55h, 57h,0EAh,0AAh,0FDh
		db	 55h, 55h, 55h, 55h, 57h,0EAh
		db	0AFh,0D5h, 55h, 55h, 55h, 55h
		db	 7Fh,0AAh,0BDh, 55h, 55h, 55h
		db	 55h, 57h,0F5h,0AAh,0F5h, 55h
		db	 55h, 55h, 55h, 7Fh,0A5h,0AAh
		db	0D5h, 55h, 55h, 55h, 57h,0FAh
		db	0A5h,0AAh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0AAh,0A5h,0AAh, 5Ah,0AAh
		db	0A5h,0AAh,0A5h,0AAh,0A5h,0AAh
		db	 5Ah,0AAh,0AAh,0AAh,0A5h,0AAh
		db	0AAh,0AAh, 06h, 0Ah,0AEh, 21h
		db	 02h, 00h,0FFh,0FFh, 06h, 02h
		db	0EAh, 21h, 92h, 01h,0EAh, 21h
		db	0E2h, 01h,0EAh, 21h, 32h, 02h
		db	0EAh, 21h, 82h, 02h,0EAh, 21h
		db	0D2h, 02h,0EAh, 21h, 22h, 03h
		db	0EAh, 21h, 72h, 03h,0FFh,0FFh
		db	 06h, 07h,0F6h, 21h,0C2h, 03h
		db	0FFh,0FFh, 08h, 08h, 20h, 22h
		db	0B0h, 24h,0FFh,0FFh, 08h, 01h
		db	 60h, 22h,0F0h, 25h, 60h, 22h
		db	 40h, 06h, 60h, 22h, 40h, 26h
		db	 60h, 22h, 90h, 06h, 60h, 22h
		db	 90h, 26h, 60h, 22h,0E0h, 06h
		db	 68h, 22h,0E0h, 26h, 68h, 22h
		db	 30h, 07h, 68h, 22h, 30h, 27h
		db	 68h, 22h, 80h, 07h, 68h, 22h
		db	 80h, 27h, 68h, 22h,0D0h, 07h
		db	 68h, 22h,0D0h, 27h,0FFh,0FFh
		db	 55h,0A5h
		db	'UUUUZUUUUUU'
		db	0A5h,0AAh, 5Ah, 04h, 40h,0A1h
		db	 1Ah,0A4h, 4Ah,0A1h, 1Ah,0A4h
		db	 4Ah,0A1h, 1Ah,0A4h, 4Ah,0A1h
		db	 1Ah,0A4h, 4Ah,0A1h, 1Ah, 96h
		db	0AAh, 96h,0AAh, 96h,0AAh, 96h
		db	0AAh, 96h,0AAh,0BEh,0AAh,0FFh
		db	0AAh,0BEh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0A4h,0AAh, 55h,0A9h
		db	 55h,0AAh, 55h,0AAh,0A5h,0AAh
		db	0AAh, 44h, 44h, 11h, 11h, 44h
		db	 44h, 11h, 11h, 54h, 44h, 55h
		db	 55h, 55h, 55h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 4Ah,0AAh, 11h
		db	0AAh, 45h, 6Ah, 55h,0AAh, 5Ah
		db	0AAh,0AAh,0AAh
data_b_2344	db	2
		db	 08h,0E0h, 22h, 00h, 00h,0E0h
		db	 22h, 02h, 00h,0E0h, 22h, 04h
		db	 00h,0E0h, 22h, 40h, 01h,0E0h
		db	 22h, 42h, 01h,0E0h, 22h, 44h
		db	 01h,0F4h, 22h, 82h, 02h, 04h
		db	 23h, 84h, 02h,0F4h, 22h,0C2h
		db	 03h,0F4h, 22h, 02h, 05h,0F0h
		db	 22h, 42h, 06h,0F4h, 22h, 82h
		db	 07h, 14h, 23h,0C0h, 08h, 24h
		db	 23h,0C2h, 08h, 34h, 23h,0C4h
		db	 08h,0FFh,0FFh
data_b_2384	db	0Bh
		db	 09h, 40h, 20h, 00h, 00h,0FFh
		db	0FFh
data_b_238C	db	2
		db	 08h,0F4h, 22h, 44h, 21h,0F4h
		db	 22h, 84h, 22h,0F4h, 22h, 24h
		db	 23h, 14h
		db	'#b$$'
		db	'#d$'
		db	'4#f$'
		db	0FFh,0FFh,0AAh,0AAh,0FFh,0FAh
		db	0AAh,0AAh,0AFh,0F5h, 7Fh,0AAh
		db	0AAh,0FDh, 55h, 55h,0EAh,0ABh
		db	0D5h, 55h, 55h,0EAh,0ABh,0D5h
		db	 55h, 55h, 7Ah,0AFh, 55h, 55h
		db	 55h, 7Ah,0AFh, 55h, 55h, 55h
		db	 5Eh,0BDh, 55h, 55h, 55h, 5Eh
		db	0BDh, 55h, 55h, 55h, 5Eh,0BDh
		db	 55h, 55h, 55h, 57h,0F5h, 55h
		db	 55h, 55h, 57h,0F5h, 55h, 55h
		db	 55h, 5Fh,0F5h, 55h, 55h, 55h
		db	 5Eh,0BDh, 55h, 55h, 55h, 7Ah
		db	 05h, 0Ah,0A8h, 23h, 00h, 00h
		db	0FFh,0FFh, 05h, 01h,0DAh, 23h
		db	 90h, 01h,0DAh, 23h, 90h, 21h
		db	0DAh, 23h,0E0h, 01h,0DAh, 23h
		db	0E0h, 21h,0DAh, 23h, 30h, 02h
		db	0DAh, 23h, 30h, 22h,0DAh, 23h
		db	 80h, 02h,0DAh, 23h, 80h, 22h
		db	0DAh, 23h,0D0h, 02h,0DAh, 23h
		db	0D0h, 22h,0DAh, 23h, 20h, 03h
		db	0DAh, 23h, 20h, 23h,0DAh, 23h
		db	 70h, 03h,0DAh, 23h, 70h, 23h
		db	0DFh, 23h,0C0h, 03h,0E4h, 23h
		db	0C0h, 23h,0E4h, 23h, 10h, 04h
		db	0E4h, 23h, 10h, 24h,0E4h, 23h
		db	 60h, 04h,0E9h, 23h, 60h, 24h
		db	0FFh,0FFh,0BDh, 55h, 55h, 54h
		db	 0Fh,0FFh,0FFh,0FEh,0AAh,0BDh
		db	 55h, 55h, 01h, 55h, 55h, 55h
		db	 57h,0EAh,0BFh, 55h, 40h, 55h
		db	 55h, 55h, 55h, 55h,0FAh,0AFh
		db	 50h, 15h, 55h, 55h, 55h, 55h
		db	 55h,0FAh,0ACh, 05h, 55h, 55h
		db	 55h, 55h, 55h, 57h,0EAh,0ADh
		db	 55h, 55h, 55h, 55h, 55h, 57h
		db	0FEh,0AAh,0AFh, 55h, 55h, 55h
		db	 5Fh,0FFh,0FFh, 82h,0AAh,0AFh
		db	0FFh,0FFh,0FFh,0FFh, 96h,0AAh
		db	 96h,0AAh,0A5h,0AAh,0A5h,0AAh
		db	0AAh, 96h,0AAh, 96h,0A5h,0AAh
		db	0AAh,0AAh,0AAh, 96h,0AAh, 96h
		db	0A5h,0AAh,0AAh,0AAh,0AAh, 96h
		db	7 dup (0AAh)
		db	 96h,0AAh,0AAh, 09h, 08h, 4Ah
		db	 24h,0B0h, 04h,0FFh,0FFh, 08h
		db	 01h, 92h, 24h,0F0h, 05h, 92h
		db	 24h,0F0h, 25h, 92h, 24h, 40h
		db	 06h, 92h, 24h, 40h, 26h, 92h
		db	 24h, 90h, 06h, 92h, 24h, 90h
		db	 26h, 92h, 24h,0E0h, 06h, 92h
		db	 24h,0E0h, 26h, 9Ah, 24h, 30h
		db	 07h,0A2h, 24h, 30h, 27h,0A2h
		db	 24h, 80h, 07h,0A2h, 24h, 80h
		db	 27h,0A2h, 24h,0D0h, 07h,0A2h
		db	 24h,0D0h, 27h,0AAh, 24h, 20h
		db	 08h,0AAh, 24h,0D0h, 27h,0FFh
		db	0FFh, 2Ah,0AAh, 8Ah,0AAh,0A2h
		db	0AAh,0A8h,0AAh,0AAh, 2Ah,0AAh
		db	 8Ah,0AAh,0A2h,0AAh,0A8h,0AAh
		db	0A2h,0AAh, 8Ah,0AAh, 2Ah,0A8h
		db	0AAh,0A2h,0AAh, 8Ah,0AAh, 2Ah
		db	0AAh
data_b_251C	db	2
		db	 08h,0FEh, 24h, 00h, 00h,0FEh
		db	 24h, 42h, 01h,0FEh, 24h,0CCh
		db	 11h,0FEh, 24h, 0Eh, 13h, 0Ch
		db	 25h, 4Eh, 00h, 0Ch, 25h, 8Ch
		db	 01h, 0Ch, 25h,0C0h, 12h, 0Ch
		db	 25h, 82h, 11h,0FFh,0FFh,0AAh
		db	0AAh,0AAh
		db	9 dup (0AAh)
		db	0FFh,0FFh,0AAh,0FAh, 5Ah,0A5h
		db	 55h, 55h, 55h, 55h,0A5h, 5Ah
		db	 5Ah,0A5h, 55h, 55h, 55h, 55h
		db	0A5h
		db	5Ah
		db	16 dup (0)
data_b_2570	db	2
		db	 08h, 40h, 25h, 00h, 00h, 40h
		db	 25h, 02h, 00h, 40h, 25h, 04h
		db	 00h, 40h, 25h, 06h, 00h, 40h
		db	 25h, 08h, 00h, 40h, 25h, 0Ah
		db	 00h, 40h, 25h, 0Ch, 00h, 40h
		db	 25h, 0Eh, 00h, 50h, 25h, 40h
		db	 01h, 50h, 25h, 42h, 01h, 50h
		db	 25h, 80h, 02h, 50h, 25h, 82h
		db	 02h, 50h, 25h,0C0h, 03h, 50h
		db	 25h,0C2h, 03h, 50h, 25h, 4Ch
		db	 01h, 50h, 25h, 4Eh, 01h, 50h
		db	 25h, 8Ch, 02h, 50h, 25h, 8Eh
		db	 02h, 50h, 25h,0CCh, 03h, 50h
		db	 25h,0CEh, 03h, 60h, 25h, 44h
		db	 01h, 60h, 25h, 46h, 01h, 60h
		db	 25h, 48h, 01h, 60h, 25h, 4Ah
		db	 01h, 60h, 25h, 84h, 02h, 60h
		db	 25h, 86h, 02h, 60h, 25h, 88h
		db	 02h, 60h, 25h, 8Ah, 02h,0FFh
		db	0FFh,0AAh,0ADh,0DAh,0AAh,0A7h
		db	0A7h, 7Ah,0DAh,0DDh,0DDh,0A7h
		db	 77h,0A7h, 7Ah,0DDh,0DAh,0DAh
		db	0DDh,0A7h,0A7h, 77h, 7Ah, 6Ah
		db	0DDh,0DAh,0DEh,0DDh,0A7h,0A7h
		db	 7Bh, 67h, 6Ah,0AAh,0A0h, 0Ah
		db	0AAh,0AAh, 00h, 00h,0AAh,0AAh
		db	 00h, 00h,0AAh,0AAh,0A0h, 0Ah
		db	0AAh,0AAh,0A0h, 0Ah,0AAh,0AAh
		db	0A0h, 0Ah,0AAh,0AAh,0A0h, 0Ah
		db	0AAh,0AAh, 00h, 00h,0AAh
data_b_2624	db	4
		db	 10h,0E4h, 25h,0F0h, 03h,0E4h
		db	 25h,0F8h, 03h,0E4h, 25h, 00h
		db	 04h,0FFh,0FFh
data_b_2634	dw	0			; Data table (indexed access)
		db	0EEh, 23h,0F6h, 23h,0B2h, 24h
data_b_263C	dw	24BAh			; Data table (indexed access)
		db	 70h, 22h, 78h, 22h, 98h, 22h
		db	0A0h
		db	22h
data_b_2646	dw	22A8h			; Data table (indexed access)
		db	 8Ah, 21h, 92h, 21h, 9Ah, 21h
		db	0A2h
		db	21h
data_b_2650	dw	0
data_b_2652	db	0
data_b_2653	db	0
data_b_2654	dw	0
data_b_2656	db	0			; Data table (indexed access)
		db	39 dup (0)
data_b_267E	dw	0

; Font 8x8 ... 2720h = start font of digits 30h
data_b_2680	db	0FCh
		db	8 dup (55h)
		db	 3Fh,0ECh
		db	8 dup (55h)
		db	 3Bh,0F8h, 55h, 55h,0F5h, 55h
		db	 55h, 55h, 55h, 55h, 2Fh,0ECh
		db	 55h, 5Fh, 55h,0F5h, 55h, 57h
		db	0D5h, 55h, 3Bh,0F8h, 55h,0F5h
		db	 5Fh, 55h, 55h, 7Dh, 55h, 55h
		db	 2Fh,0ECh, 55h,0F5h, 55h, 55h
		db	 57h,0D5h, 55h, 55h, 3Bh,0F8h
		db	 5Fh, 55h, 55h, 55h, 57h,0D5h
		db	 55h, 55h, 2Fh,0ECh
		db	'UUUU}UUU;'
		db	0F8h
		db	'UU_UUU_U/'
		db	0ECh, 55h, 55h,0F5h, 55h, 55h
		db	 55h, 75h, 55h, 3Bh,0F8h
		db	'UWUUUWUU/'
		db	0ECh
		db	'U]UUU]UU;'
		db	0F8h, 55h, 55h, 55h, 55h, 55h
		db	0F5h, 55h, 55h, 2Fh,0ECh
		db	8 dup (55h)
		db	 3Bh,0F8h
		db	8 dup (55h)
		db	 2Fh,0FCh
		db	8 dup (0)
		db	 3Fh, 40h, 56h, 04h, 16h, 05h
		db	 16h, 05h, 06h, 41h, 42h, 41h
		db	 42h, 50h, 02h, 54h, 06h
		db	'PVPVPVPVP'
		db	 16h, 54h, 16h, 54h, 16h, 54h
		db	 16h, 50h, 16h, 40h, 06h, 55h
		db	 06h, 50h, 16h, 40h, 56h, 41h
		db	 56h, 40h, 16h, 40h, 06h, 50h
		db	 16h, 40h, 06h, 41h, 06h, 55h
		db	 06h, 54h, 02h, 55h, 42h, 50h
		db	 42h, 54h, 06h, 55h, 06h, 05h
		db	 06h, 04h, 02h, 00h, 06h, 41h
		db	 06h, 55h, 06h, 55h, 06h, 55h
		db	 56h, 40h, 06h, 41h, 46h, 41h
		db	 56h, 40h, 16h, 54h, 06h, 55h
		db	 06h, 41h, 06h, 50h, 16h, 50h
		db	 16h, 40h, 56h, 41h, 56h, 00h
		db	 16h, 00h, 06h, 05h, 06h, 00h
		db	 06h, 40h, 56h, 54h, 02h, 40h
		db	 02h, 41h, 42h, 55h, 42h, 55h
		db	 02h, 55h, 06h, 55h, 06h, 55h
		db	 06h, 54h, 06h, 50h, 42h, 50h
		db	 42h, 54h, 06h, 50h, 16h, 41h
		db	 06h, 41h, 06h, 50h, 16h, 40h
		db	 16h, 00h, 06h, 05h, 02h, 00h
		db	 02h, 40h, 42h, 55h, 42h, 54h
		db	 06h, 54h, 16h, 50h, 06h, 00h
		db	 06h, 00h, 56h, 54h, 16h, 54h
		db	 16h, 55h, 02h, 50h, 02h, 50h
		db	 16h, 55h, 06h, 54h, 16h, 54h
		db	 16h
		db	'PVUVAVAVUVU'
		db	6, 5, 6, 5, 6, 4
		db	6, 0, 2
		db	'@BABAVUVUVUVAVP'
		db	16h
		db	'UVUVUV@V'
		db	 04h, 16h, 05h, 56h, 05h, 56h
		db	 01h, 16h, 40h, 16h, 50h, 56h
		db	 55h, 56h, 54h, 16h, 50h, 06h
		db	 41h, 46h, 40h, 06h, 05h, 06h
		db	 04h, 16h, 54h, 16h, 55h, 56h
		db	 50h, 02h, 40h, 16h, 44h, 16h
		db	 54h, 16h, 55h, 06h, 55h, 06h
		db	 55h, 06h, 55h, 56h, 05h, 56h
		db	 05h, 56h, 05h, 56h, 01h, 56h
		db	 41h, 56h, 41h, 42h, 40h, 02h
		db	 40h, 06h, 05h, 42h, 05h, 42h
		db	 41h, 42h, 41h, 06h, 41h, 06h
		db	 41h, 06h, 50h, 16h, 54h, 16h
		db	 40h, 16h, 00h, 56h, 05h, 56h
		db	 05h, 16h, 40h, 56h, 41h, 46h
		db	 40h, 06h, 40h, 16h, 41h, 42h
		db	 40h, 40h, 00h, 00h, 04h, 10h
		db	 04h, 10h, 04h, 10h, 05h, 50h
		db	 05h, 56h, 05h, 56h, 05h, 42h
		db	 05h, 42h, 05h, 42h, 05h, 42h
		db	 41h, 06h, 40h, 06h, 50h, 16h
		db	 40h, 16h, 01h, 56h, 05h, 56h
		db	 00h, 16h, 40h, 06h, 55h, 06h
		db	 04h, 06h, 40h, 16h, 41h, 42h
		db	 41h, 06h, 40h, 16h, 40h, 56h
		db	 04h, 16h, 04h, 16h, 05h, 06h
		db	 55h, 56h
data_b_28A0	db	2
		db	 08h,0E0h, 27h,0C4h, 12h,0C0h
		db	 27h, 26h, 12h,0D0h, 27h, 88h
		db	 11h,0F0h, 27h,0D0h, 12h,0F0h
		db	 27h, 42h, 14h, 00h, 28h,0C4h
		db	 11h, 10h, 28h,0C6h, 11h, 20h
		db	 28h,0C8h, 11h, 30h, 28h, 04h
		db	 19h, 30h, 28h, 1Eh, 14h
		db	20h

locloop_b_28CB:
		daa				; Decimal adjust
		rcl	byte ptr [si],40h	; '@' Rotate thru carry
		sub	[bp+si],al
		push	ss
		push	ax
		sub	data_b_2016[si],ah
		sub	ds:data_b_E011_e[bx+si],ch
		daa				; Decimal adjust
		dec	dx
		adc	dl,[bx+si+28h]
		mov	[bp+di],ss
		pusha				; Save all regs
;*		sub	dh,cl
		db	 28h,0CEh		;  Fixup - byte match
		adc	al,60h			; '`'
;*		sub	ah,dh
		db	 28h,0F4h		;  Fixup - byte match
		pop	ss
		and	[bx],ah
		push	si
		pop	ss
		jo	loc_b_2918		; Jump if overflow=1
		mov	ax,8016h
		sub	ss:d_FEFA_C016_e[bp+si],bh
		daa				; Decimal adjust
		pop	sp
		pop	ss
		push	ax
;*		sub	dh,bh
		db	 28h,0FEh		;  Fixup - byte match
		pop	ss
		sub	byte ptr [bx+si],40h	; '@'
;*		sbb	di,di
		db	 19h,0FFh		;  Fixup - byte match
		jmp	dword ptr ss:d_8016_AAAA_e[bp+si]	;*
		db	7 dup (0AAh)
		db	 5Ah,0AAh, 55h,0AAh, 55h, 6Ah
		db	0AAh,0AAh,0AAh,0AAh
loc_b_2918:
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	si
		pop	dx
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		movsw				; Mov [si] to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		stosb				; Store al to es:[di]
		push	bp
		stosb				; Store al to es:[di]
		push	bp
		pop	dx
		push	bp
		pop	dx
		push	bp
		pop	dx
		push	bp
		push	si
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		movsw				; Mov [si] to es:[di]
		stosb				; Store al to es:[di]
		movsw				; Mov [si] to es:[di]
		push	si
		movsw				; Mov [si] to es:[di]
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		stosb				; Store al to es:[di]
		pop	dx
		stosb				; Store al to es:[di]
		push	bp
		push	si
		push	bp
		stosb				; Store al to es:[di]
		movsw				; Mov [si] to es:[di]
		push	si
		stosb				; Store al to es:[di]
		push	si
		stosb				; Store al to es:[di]
		push	si
		stosb				; Store al to es:[di]
		push	si
		movsw				; Mov [si] to es:[di]
		push	si
		push	bp
		push	si
		stosb				; Store al to es:[di]
		push	si
		movsw				; Mov [si] to es:[di]
		push	si
		push	bp
		push	si
		push	bp
		pop	dx
		pop	dx
		cmpsb				; Cmp [si] to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		cmpsb				; Cmp [si] to es:[di]
		pop	dx
		push	si
		pop	dx
		push	si
		stosb				; Store al to es:[di]
		push	si
		stosb				; Store al to es:[di]
		push	si
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		pop	dx
		movsw				; Mov [si] to es:[di]
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		outsw				; Out [si] to port dx
		stc				; Set carry flag
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		push	si
		push	bp
		scasb				; Scan es:[di] for al
		mov	si,offset data_b_5556
		push	si
		push	bp
		push	si
		push	bp
		add	[bp+si],al
		mov	cx,566Eh
		push	bp
		push	si
		push	bp
		push	sp
		add	[bx],bh
		cli				; Disable interrupts
		loopnz	locloop_b_29DD		; Loop if zf=0, cx>0

		push	si
		push	bp
		push	si
		push	bp
		inc	bx
		cld				; Clear direction
		db	0FFh,0FFh,0EFh,0EEh, 06h, 55h
		db	 56h, 55h, 3Ch, 88h, 03h,0FFh
		db	0FFh,0BEh,0F0h, 55h, 56h, 54h
		db	0F0h, 22h, 20h, 03h,0FFh,0FFh
		db	0FFh, 15h, 56h, 54h,0C0h, 08h
		db	 88h, 88h, 00h, 0Fh,0FFh, 15h
		db	 56h, 54h,0F0h, 00h

locloop_b_29DD:
		and	ah,[bp+si]
		and	ah,[bx+si]
		add	[di+56h],dl
		push	sp
		cmp	al,0
		add	[bx+si],al
		add	[bx],cl
		push	es
		push	bp
		push	si
		push	sp
		retn
			                        ;* No entry point to code
		cld				; Clear direction
		add	[bx+si],al
		db	 0Fh,0F0h,0C6h, 54h,0D8h, 03h
		db	0FFh,0FFh,0F0h, 09h,0C6h, 54h
		db	0E6h, 64h, 00h, 00h, 06h, 66h
		db	0C6h, 54h,0D9h, 99h, 99h, 99h
		db	 99h, 99h,0C6h, 54h,0E6h, 66h
		db	 66h, 66h, 66h, 66h,0C6h, 54h
		db	0C9h, 99h, 99h, 99h, 99h, 98h
		db	0C6h, 54h,0F2h, 66h, 66h, 66h
		db	 66h, 63h,0C6h, 54h, 3Ch, 01h
		db	 99h, 99h, 90h, 0Fh, 06h
data_b_2A2E	db	0A8h
		db	0C3h,0FCh, 00h, 00h, 0Fh,0F0h
		db	0CAh,0A8h,0D8h, 03h,0FFh,0FFh
		db	0F0h, 09h,0CAh,0A8h,0E6h, 64h
		db	 00h, 00h, 06h, 66h,0CAh,0A8h
		db	0D9h, 99h, 99h, 99h, 99h, 99h
		db	0CAh,0A8h,0E6h, 66h, 66h, 66h
		db	 66h, 66h,0CAh,0A8h,0D9h, 99h
		db	 99h, 99h, 99h, 99h,0CAh,0A8h
		db	0F6h, 66h, 66h, 66h, 66h, 67h
		db	0CAh,0A8h, 03h, 99h, 99h, 99h
		db	 99h, 9Fh, 0Ah,0AAh, 83h,0FEh
		db	 66h, 66h, 6Fh,0F0h,0AAh,0AAh
		db	0A8h, 03h,0FFh,0FFh,0F0h, 0Ah
		db	0AAh,0AAh,0AAh,0A8h, 00h, 00h
		db	 0Ah,0AAh,0AAh
data_b_2A86	dw	1726h			; Data table (indexed access)
		db	0F0h, 15h, 3Ah, 17h, 46h, 17h
		db	 5Ch, 17h, 26h, 16h, 00h, 00h
		db	0E6h, 15h,0EEh, 15h, 38h, 17h
		db	 48h, 17h, 24h, 16h, 00h, 00h
		db	 26h, 17h,0F0h, 15h, 48h, 17h
		db	 22h, 16h, 00h, 00h, 28h, 17h
		db	0F6h, 15h, 66h, 17h, 00h, 00h
data_b_2AB2	db	0			; Data table (indexed access)
		db	 0Eh, 1Ah, 24h, 1Ah, 24h, 1Ah
		db	 24h
data_b_2ABA	db	6			; Data table (indexed access)
		db	 14h, 20h, 2Eh, 2Eh, 34h, 3Ah
		db	 40h
data_b_2AC2	db	0, 0
data_b_2AC4	db	0
data_b_2AC5	dw	0
data_b_2AC7	dw	0
data_b_2AC9	db	0
data_b_2ACA	dw	0
data_b_2ACC	dw	0
data_b_2ACE	dw	0
data_b_2AD0	db	0
data_b_2AD1	dw	2890h			; Data table (indexed access)
		db	0E0h, 27h, 20h, 28h, 10h, 28h
		db	7 dup (0)
data_b_2AE0	dw	0			; image width
data_b_2AE2	db	0			; image height
data_b_2AE3	dw	0
data_b_2AE5	dw	0
		db	0, 0
data_b_2AE9	dw	0
data_b_2AEB	db	0
		db	0, 0, 0, 0
data_b_2AF0	db	55h
		db	 5Ah, 95h, 6Ah, 55h, 55h, 55h
		db	 69h,0A5h,0A6h, 95h, 55h, 55h
		db	 69h, 65h,0A2h, 85h, 55h, 55h
		db	 5Ah, 68h,0BAh,0C0h, 55h, 55h
		db	 42h,0AAh,0ABh,0FCh, 01h, 40h
		db	 0Fh,0AAh,0AAh,0FFh,0F0h, 0Fh
		db	0EAh,0BFh,0FEh,0AFh,0C0h, 03h
		db	0AFh,0FFh,0FFh,0E8h, 0Ch, 32h
		db	0BFh,0FFh,0C0h, 2Bh,0FCh, 3Eh
		db	 80h,0C0h, 0Fh,0EBh,0FCh, 3Eh
		db	0BCh, 0Fh,0FFh,0EBh,0C0h, 02h
		db	0BFh, 3Fh,0FFh,0E8h, 05h, 52h
		db	0BFh, 3Fh,0C0h, 25h, 55h, 55h
		db	 83h, 30h, 05h, 55h, 55h, 55h
		db	 54h, 05h
		db	 55h, 55h, 55h
data_b_2B4A	dw	60h			; Data table (indexed access)
		db	0C8h, 00h, 40h, 00h,0E8h, 00h
		db	 20h, 00h, 08h, 01h, 80h, 00h
		db	0A8h
		db	0
data_b_2B5A	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_b_2B6A	db	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
		db	0
data_b_2B72	dw	0			; Data table (indexed access)
data_b_2B74	dw	0
data_b_2B76	dw	0
data_b_2B78	dw	0
data_b_2B7A	db	'UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU'
		db	'UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU'
		db	'UUUUUUUUUUUUUUUUUUUUUUUUUU'
data_b_2BD4	db	0B0h			; Data table (indexed access)
		db	 98h, 80h, 68h, 50h, 38h, 20h
data_b_2BDB	db	0			; Data table (indexed access)
		db	 12h, 24h, 36h, 48h, 5Ah, 6Ch
data_b_2BE2	dw	63 dup (0)		; Data table (indexed access)
		db	 55h, 5Fh,0F5h
		db	7 dup (55h)
		db	0FFh, 55h, 5Ah,0A5h, 55h, 55h
		db	 55h, 5Fh,0FFh,0D5h,0AAh,0AAh
		db	 55h, 55h, 55h, 55h,0FFh,0FDh
		db	0AAh,0AAh, 95h, 55h, 55h,0FFh
		db	0EAh,0BFh,0AAh,0AAh, 55h, 55h
		db	 55h, 5Fh,0AAh,0AAh,0AAh,0A2h
		db	 55h, 55h, 5Fh,0FFh,0A5h,0AAh
		db	0AAh,0AAh, 9Fh, 55h, 55h,0FFh
		db	0AAh, 5Ah,0AAh,0AAh, 55h,0F5h
		db	 55h, 5Fh,0FAh,0AAh,0AAh,0A9h
		db	 55h,0F5h, 5Fh,0FFh,0F5h,0AAh
		db	0AAh, 95h, 55h, 7Dh, 55h,0FFh
		db	 55h, 5Ah, 0Ah,0AAh, 55h, 5Fh
		db	 55h, 55h, 55h,0AAh, 80h,0AAh
		db	0A5h,0AFh, 55h, 55h, 56h,0AAh
		db	0A8h, 05h,0AAh,0AFh, 55h, 55h
		db	 5Ah,0AAh,0AAh, 40h, 55h, 5Fh
		db	 55h, 55h, 5Ah,0AAh,0AAh, 54h
		db	 05h, 5Fh, 55h, 55h, 5Ah,0AAh
		db	0A9h, 55h, 40h, 7Fh, 55h,0A5h
		db	 6Ah,0AAh,0A9h, 55h, 54h,0FDh
		db	 55h,0AAh,0AAh, 6Ah,0A5h, 55h
		db	 5Fh,0F0h, 56h, 9Ah,0A9h, 5Ah
		db	 55h, 55h,0FFh, 55h, 56h, 55h
		db	0A5h, 6Ah, 55h, 5Fh,0D5h
		db	'UUUUiUUUUUUU'
		db	0A9h, 55h, 55h, 55h, 55h, 55h
		db	 55h, 55h,0A5h
		db	7 dup (55h)
		db	'iUUUUUUUUU_'
		db	0F5h, 55h, 55h, 55h, 5Ah,0A5h
		db	 55h,0FFh, 55h, 55h, 55h, 55h
		db	0AAh,0AAh, 57h,0FFh,0F5h, 55h
		db	 55h, 56h,0AAh,0AAh, 7Fh,0FFh
		db	 55h, 55h, 55h, 55h,0AAh,0AAh
		db	0FEh,0ABh,0FFh, 55h, 55h, 55h
		db	 8Ah,0AAh,0AAh,0AAh,0F5h, 55h
		db	 55h,0F6h,0AAh,0AAh,0AAh, 5Ah
		db	0FFh,0F5h, 5Fh, 55h,0AAh,0AAh
		db	0A5h,0AAh,0FFh, 55h, 5Fh, 55h
		db	 6Ah,0AAh,0AAh,0AFh,0F5h, 55h
		db	 7Dh, 55h, 56h,0AAh,0AAh, 5Fh
		db	0FFh,0F5h,0F5h, 55h,0AAh,0A0h
		db	0A5h, 55h,0FFh, 55h,0FAh, 5Ah
		db	0AAh, 02h,0AAh, 55h, 55h, 55h
		db	0FAh,0AAh, 50h, 2Ah,0AAh, 95h
		db	 55h, 55h,0F5h, 55h, 01h,0AAh
		db	0AAh,0A5h, 55h, 55h,0F5h, 50h
		db	 15h,0AAh,0AAh,0A5h, 55h, 55h
		db	0FDh, 01h, 55h, 6Ah,0AAh,0A5h
		db	 55h, 55h, 7Fh, 15h, 55h, 6Ah
		db	0AAh,0A9h, 5Ah, 55h, 0Fh,0F5h
		db	 55h, 5Ah,0A9h,0AAh,0AAh, 55h
		db	 55h,0FFh, 55h, 55h,0A5h, 6Ah
		db	0A6h, 95h, 55h, 57h,0F5h, 55h
		db	0A9h, 5Ah, 55h, 95h
		db	'UUUUiUUUUUUUjUUUUUUUZUUUUUUUiUUU'
		db	'Z'
		db	0A5h, 6Ah, 95h, 6Ah,0A9h,0AAh
		db	0A5h, 6Ah,0AAh,0AAh,0A5h, 6Ah
		db	0AAh,0AAh,0A5h, 5Ah,0AAh,0AAh
		db	 95h, 55h,0AAh,0A9h, 55h, 55h
		db	 5Ah, 95h
		db	'UUVUUUUT'
		db	 05h, 50h, 15h, 40h, 01h, 40h
		db	 01h, 40h, 01h, 40h, 15h, 54h
		db	 01h, 40h, 00h, 14h, 05h, 54h
		db	 00h, 15h, 15h, 55h, 54h, 01h
		db	 55h, 55h, 55h, 55h, 55h
data_b_2E20	dw	2DE0h			; Data table (indexed access)
		db	 00h, 2Eh
data_b_2E24	db	8
		db	 18h, 60h, 2Ch, 40h, 1Ah, 20h
		db	 2Dh, 88h, 1Ah, 60h, 2Ch, 80h
		db	 16h, 20h, 2Dh,0C8h, 16h, 60h
		db	 2Ch,0C0h, 12h, 20h, 2Dh, 08h
		db	 13h, 60h, 2Ch, 00h, 0Fh, 20h
		db	 2Dh, 48h, 0Fh, 60h, 2Ch, 40h
		db	 0Bh, 20h, 2Dh, 88h, 0Bh, 60h
		db	 2Ch, 80h, 07h, 20h, 2Dh,0C8h
		db	 07h, 60h, 2Ch,0C0h, 03h, 20h
		db	 2Dh, 08h, 04h, 60h, 2Ch, 00h
		db	 00h, 20h, 2Dh, 48h, 00h, 60h
		db	 2Ch, 08h, 00h, 20h, 2Dh, 40h
		db	 00h, 60h, 2Ch, 10h, 00h, 20h
		db	 2Dh, 38h, 00h, 60h, 2Ch, 18h
		db	 00h, 20h, 2Dh, 30h, 00h, 60h
		db	 2Ch, 20h, 00h, 20h, 2Dh, 28h
		db	 00h,0FFh,0FFh
data_b_2E88	dw	0
data_b_2E8A	db	0
data_b_2E8B	dw	0
data_b_2E8D	dw	0
data_b_2E8F	dw	0
data_b_2E91	db	0
data_b_2E92	dw	0
data_b_2E94	dw	0
data_b_2E96	dw	0
data_b_2E98	db	0
		db	10 dup (0)
		db	 0Fh, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	 3Ch, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 0Fh, 00h, 00h, 00h, 0Fh
		db	 00h, 00h, 00h, 3Ch, 00h, 00h
		db	 00h, 3Ch, 00h, 00h, 00h,0F0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 03h,0C0h, 00h, 00h, 03h,0C0h
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	0FFh,0C0h, 00h, 0Fh,0FFh,0F0h
		db	 00h, 0Fh,0FFh,0F0h, 00h,0FFh
		db	0FFh,0F0h, 00h,0FFh,0FFh,0F0h
		db	 00h, 0Fh,0FFh,0F0h, 00h, 0Fh
		db	0FFh,0F0h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 0Fh
		db	21 dup (0)
		db	 3Ch, 00h, 00h, 00h, 3Ch, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	0F0h, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 0Fh, 00h, 00h, 00h, 0Fh
		db	 00h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 3Ch, 00h, 00h, 00h, 3Ch
		db	 00h, 00h, 00h, 3Ch, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h,0F0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 03h,0C0h, 00h, 00h, 0Fh,0F0h
		db	 00h, 00h, 0Fh,0F0h, 00h, 00h
		db	0FFh,0FCh, 00h, 00h,0FFh,0FCh
		db	 00h, 0Fh,0FFh,0FFh, 00h, 0Fh
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	 00h, 00h,0FFh,0FFh, 00h, 00h
		db	 0Fh, 0Fh, 00h, 00h, 0Fh
		db	12 dup (0)
		db	 03h,0C0h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 3Ch, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	 3Ch, 00h, 00h, 00h, 3Ch, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	0F0h, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	0F0h, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h, 0Fh
		db	0F0h, 00h, 00h,0FFh,0FCh, 00h
		db	 00h,0FFh,0FCh, 00h, 03h,0FFh
		db	0FCh, 00h, 03h,0FFh,0FFh, 00h
		db	 0Fh,0FFh,0FFh, 00h, 0Fh,0FFh
		db	0FFh, 00h, 00h,0FFh,0C0h, 00h
		db	 00h,0FFh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 03h
		db	0C0h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 3Fh,0FCh, 00h, 00h, 3Fh
		db	0FCh, 00h, 00h,0FFh,0FFh, 00h
		db	 03h,0FFh,0FFh,0C0h, 03h,0FFh
		db	0FFh,0C0h, 03h,0FFh,0FFh,0C0h
		db	 03h,0FFh,0FFh,0C0h, 03h,0FFh
		db	0FFh,0C0h, 00h, 3Fh,0FCh, 00h
		db	 00h, 3Fh,0FCh, 00h,0F0h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 3Ch, 00h, 00h, 00h, 3Ch, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	 3Ch, 00h, 00h, 00h, 3Ch, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 03h,0C0h, 00h, 00h
		db	 03h,0C0h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 03h,0C0h, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h,0F0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 03h,0FCh, 00h, 00h, 03h,0FCh
		db	 00h, 00h, 0Fh,0FFh,0C0h, 00h
		db	 0Fh,0FFh,0C0h, 00h, 0Fh,0FFh
		db	0F0h, 00h, 3Fh,0FFh,0F0h, 00h
		db	 3Fh,0FFh,0FCh, 00h, 3Fh,0FFh
		db	0FCh, 00h, 00h,0FFh,0C0h, 00h
		db	 00h, 3Fh,0C0h, 00h,0F0h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	 3Ch, 00h, 00h, 00h, 3Ch, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	 0Fh, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 03h,0C0h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 03h,0C0h, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h,0F0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 00h, 3Ch, 00h, 00h, 00h, 3Ch
		db	 00h, 00h, 00h, 3Ch, 00h, 00h
		db	 00h, 0Fh, 00h, 00h, 00h, 3Fh
		db	0C0h, 00h, 00h, 3Fh,0C0h, 00h
		db	 00h,0FFh,0FCh, 00h, 00h,0FFh
		db	0FCh, 00h, 03h,0FFh,0FFh,0C0h
		db	 03h,0FFh,0FFh,0C0h, 03h,0FFh
		db	0FCh, 00h, 03h,0FFh,0FCh, 00h
		db	 03h,0C3h,0C0h, 00h, 00h, 03h
		db	0C0h
		db	9 dup (0)
		db	0F0h, 00h, 00h, 00h,0F0h, 00h
		db	 00h, 00h, 3Ch, 00h, 00h, 00h
		db	 3Ch, 00h, 00h, 00h, 0Fh, 00h
		db	 00h, 00h, 0Fh, 00h, 00h, 00h
		db	 03h,0C0h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h, 3Ch
		db	 00h, 00h, 00h, 3Ch, 00h, 00h
		db	 00h, 0Fh, 00h, 00h, 00h, 0Fh
		db	 00h, 00h, 00h, 03h,0C0h, 00h
		db	 00h, 03h,0C0h, 00h, 00h, 00h
		db	0FFh, 00h, 00h, 03h,0FFh, 00h
		db	 00h, 0Fh,0FFh,0F0h, 00h, 0Fh
		db	0FFh,0F0h, 00h, 0Fh,0FFh,0FFh
		db	 00h, 0Fh,0FFh,0FFh, 00h, 0Fh
		db	0FFh,0F0h, 00h, 0Fh,0FFh,0F0h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	0F0h
		db	17 dup (0)
data_b_31E8	db	0
		db	119 dup (0)
data_b_3260	dw	2EA0h			; Data table (indexed access)
		db	 18h, 2Fh, 90h, 2Fh, 08h, 30h
		db	 80h, 30h,0F8h, 30h, 70h, 31h
		db	0F8h, 30h, 80h, 30h, 08h, 30h
		db	 90h, 2Fh, 18h
		db	2Fh
		db	0, 0
data_b_327A	dw	0
		db	0
data_b_327D	dw	0
data_b_327F	db	0
data_b_3280	db	0
data_b_3281	db	0
data_b_3282	dw	0
data_b_3284	dw	0
data_b_3286	db	0
data_b_3287	dw	0
data_b_3289	db	0
data_b_328A	dw	0
data_b_328C	dw	0
data_b_328E	db	0			; Data table (indexed access)
		db	39 dup (0)
data_b_32B6	dw	0
		db	14 dup (0AAh)
		db	 8Ah,0AAh,0AAh, 8Ah,0AAh,0AAh
		db	0AAh,0A8h,0A8h,0AAh, 8Ah,0AAh
		db	0AAh, 8Ah,0AAh,0AAh,0AAh,0A8h
		db	0A0h, 8Ah, 8Ah,0AAh,0AAh, 0Ah
		db	 8Ah,0AAh,0AAh,0A0h,0A0h, 8Ah
		db	 0Ah,0AAh,0AAh, 0Ah, 0Ah,0AAh
data_b_32EA	db	0
data_b_32EB	db	0
data_b_32EC	db	0
data_b_32ED	db	0
data_b_32EE	db	0
data_b_32EF	dw	0
data_b_32F1	db	0
data_b_32F2	dw	1			; Data table (indexed access)
		db	1, 0, 1, 0, 2, 0
		db	1, 0, 1, 0, 1, 0
data_b_3300	db	95h
		db	0A5h, 66h,0A9h, 6Ah,0A6h, 6Ah
		db	0AAh, 66h,0A5h, 95h,0A5h, 96h
		db	 95h, 9Ah,0A5h,0AAh, 99h,0AAh
		db	0A9h, 9Ah,0A9h, 96h,0A5h, 5Ah
		db	 56h, 6Ah, 99h, 9Ah,0A9h,0AAh
		db	0A9h, 5Ah, 99h, 5Ah, 56h, 56h
		db	 96h, 5Ah,0A6h, 66h,0AAh, 6Ah
		db	0AAh, 6Ah,0A6h, 5Ah, 96h
data_b_3330	db	5Fh
		db	0F5h,0F5h, 5Fh,0F5h, 5Fh, 5Fh
		db	0F5h, 50h, 55h, 55h, 00h, 05h
		db	 00h, 00h, 55h,0F5h, 5Fh, 5Fh
		db	0F5h, 5Fh,0F5h,0F5h, 5Fh, 00h
		db	 55h, 55h, 05h, 55h, 00h, 00h
		db	50h
data_b_3350	db	55h
		db	 5Fh,0F5h, 55h,0FFh,0D5h, 55h
		db	 55h, 55h, 55h, 57h,0F0h, 3Fh
		db	 5Fh,0C0h,0FDh, 55h, 5Fh,0D5h
		db	 55h, 7Fh, 00h, 0Fh,0FFh, 00h
		db	 3Fh,0D5h,0F0h, 3Dh, 55h,0F0h
		db	 03h, 0Fh,0FCh, 3Fh, 0Fh,0FFh
		db	0C0h, 0Fh,0D5h, 00h, 3Fh, 0Fh
		db	0FCh, 3Fh, 0Fh,0FFh, 03h,0C3h
		db	0D5h, 03h,0FCh, 3Fh,0FCh, 3Fh
		db	 0Fh,0FFh, 0Fh,0F3h,0F5h,0FFh
		db	0FCh, 3Fh,0F0h, 00h, 03h,0FCh
		db	 0Fh,0F3h,0FDh, 5Fh,0F0h,0FFh
		db	0F0h, 00h, 03h,0FCh, 03h,0C3h
		db	0C3h, 55h,0F0h,0FFh,0F0h,0FFh
		db	0C3h,0F0h,0C0h, 0Fh, 03h, 55h
		db	0C3h,0FFh,0C3h,0FFh,0F0h,0F0h
		db	0FCh, 3Ch, 0Fh, 57h,0C3h,0FFh
		db	0FFh,0FFh,0F0h,0C3h,0FFh,0F0h
		db	 3Dh, 57h, 0Fh,0FCh, 0Fh,0FFh
		db	0FFh,0C3h,0FFh,0C0h,0FDh, 5Fh
		db	 0Fh,0C0h, 0Fh,0D5h,0FFh, 0Fh
		db	0FFh, 03h,0D5h, 5Ch, 3Ch, 00h
		db	0FFh, 55h, 5Fh, 0Fh,0FFh,0CFh
		db	0D5h, 5Ch, 00h, 0Fh,0FDh, 55h
		db	 57h,0FFh,0F0h,0FFh, 55h, 5Fh
		db	 00h,0FFh,0D5h, 55h, 55h, 57h
		db	0F0h,0F5h, 55h, 57h,0FFh,0FFh
		db	 55h, 55h, 55h, 55h, 5Fh,0D5h
		db	 55h, 55h, 5Fh,0D5h
		db	55h
		db	 55h, 55h, 55h, 55h, 55h, 55h
data_b_3404	db	'UUUUUUUUUUUU'
data_b_3410	db	0
data_b_3411	dw	0
data_b_3413	dw	0
data_b_3415	dw	0
data_b_3417	db	0			; Data table (indexed access)
		db	23 dup (0)
data_b_342F	db	0			; Data table (indexed access)
		db	23 dup (0)
data_b_3447	dw	0			; Data table (indexed access)
		db	46 dup (0)
data_b_3477	db	0			; Data table (indexed access)
		db	23 dup (0)
data_b_348F	db	0			; Data table (indexed access)
		db	23 dup (0)
data_b_34A7	db	0			; Data table (indexed access)
		db	23 dup (0)
data_b_34BF	dw	0			; Data table (indexed access)
		db	46 dup (0)
data_b_34EF	dw	0
data_b_34F1	db	8, 8, '((HHhh'		; Data table (indexed access)
		db	 88h, 88h,0A8h,0A8h, 18h, 18h
		db	 38h, 38h, 58h, 58h, 78h, 78h
		db	 98h, 98h,0A8h,0A8h
data_b_3509	db	0, 0
data_b_350B	dw	0
data_b_350D	dw	0
data_b_350F	dw	0
data_b_3511	dw	0
data_b_3513	dw	8			; Data table (indexed access)
		db	 10h, 00h
data_b_3517	dw	6			; Data table (indexed access)
		db	2, 0
data_b_351B	db	0
data_b_351C	db	0Ah			; Data table (indexed access)
		db	8, 6, 4, 3, 2, 2
		db	1, 0
		db	11 dup (0)
		db	0AFh,0FFh,0FFh,0FAh,0AAh,0D5h
		db	 57h,0AAh,0AFh, 55h, 55h,0FAh
		db	0B5h, 55h, 50h, 5Eh,0D7h, 55h
		db	 55h, 57h,0D7h, 55h, 55h, 57h
		db	0D5h,0F5h, 41h, 07h, 7Dh, 5Fh
		db	 55h, 7Dh, 57h,0D5h, 57h,0D5h
		db	 55h, 7Fh,0FDh, 55h,0AFh,0FFh
		db	0FFh,0FAh,0AAh,0D5h, 57h,0AAh
		db	0AFh, 55h, 55h,0FAh,0B5h, 55h
		db	 50h, 5Eh,0D7h, 55h, 55h, 57h
		db	0D7h, 55h, 05h, 57h,0D5h,0F5h
		db	 54h, 17h, 7Dh, 5Fh, 55h, 7Dh
		db	 57h,0D5h, 57h,0D5h, 55h, 7Fh
		db	0FDh, 55h,0AFh,0FFh,0FFh,0FAh
		db	0AAh,0D5h, 57h,0AAh,0AFh, 55h
		db	 55h,0FAh,0B5h, 55h, 54h, 1Eh
		db	0D7h, 55h, 55h, 57h,0D7h, 55h
		db	 05h, 57h,0D5h,0F5h, 50h, 57h
		db	 7Dh, 5Fh, 55h, 7Dh, 57h,0D5h
		db	 57h,0D5h, 55h, 7Fh,0FDh, 55h
		db	0AFh,0FFh,0FFh,0FAh,0AAh,0D5h
		db	 57h,0AAh,0AFh, 55h, 55h,0FAh
		db	0B5h, 55h, 55h, 5Eh,0D7h, 55h
		db	 05h, 07h,0D7h, 55h, 55h, 57h
		db	0D5h,0F5h, 41h, 57h, 7Dh, 5Fh
		db	 55h, 7Dh, 57h,0D5h, 57h,0D5h
loc_b_35CC:
		push	bp
		jg	loc_b_35CC		; Jump if >
		push	bp
		xor	[di],dh
		pop	ax
		xor	ax,3580h
		test	al,35h			; '5'
		db	0, 0
data_b_35DA	dw	0
		db	0, 0, 0, 0
data_b_35E0	db	0Fh
		db	 00h, 00h, 00h,0F0h, 0Fh,0F0h
		db	0FFh, 0Fh,0F0h, 0Fh,0FFh,0FFh
		db	0FFh,0F0h, 0Fh,0FFh,0FFh,0FFh
		db	0F0h, 3Fh, 00h, 3Fh, 00h, 3Ch
		db	0FFh,0CAh,0FFh,0CAh
		db	8 dup (0FFh)
		db	0F0h,0FFh,0FFh, 3Fh,0F0h,0FFh
		db	0F0h,0FCh, 0Fh,0FFh, 00h, 0Fh
		db	0F0h, 00h,0FFh,0FFh,0FFh, 00h
		db	 00h, 00h,0FFh, 00h, 00h
data_b_361C	db	5
		db	 0Ch, 0Eh, 00h
loc_b_3620:
		push	es
		add	data_b_1000,cl
loc_b_3625:
		add	data_b_3B00,cl
		add	data_b_4500,cl
;*		add	bh,bh
		db	 00h,0FFh		;  Fixup - byte match
		inc	word ptr [bx+si]
		db	0, 0, 0, 0, 0, 1
		db	0, 0, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 0
		db	0, 4, 0, 0, 0, 0
		db	0, 0, 8, 0, 0, 0
		db	0, 0, 1, 6, 0, 0
		db	0, 0, 0, 3, 2, 0
		db	0, 0, 0, 0, 6, 4
		db	0, 0, 0, 0, 1, 2
		db	8, 0, 0, 0, 0, 2
		db	5, 6, 0, 0, 0, 0
		db	5, 1, 2, 0, 0, 0
		db	1, 0, 2, 4, 0, 0
		db	0, 2, 0, 4
		db	8
data_b_3684	db	0
		db	0, 0, 4, 0, 9, 6
data_b_368B	db	0, 0
data_b_368D	dw	0			; Data table (indexed access)
data_b_368F	dw	0
data_b_3691	dw	0
data_b_3693	dw	0
data_b_3695	dw	0			; system timer
data_b_3697	dw	0
data_b_3699	db	0
data_b_369A	dw	0
data_b_369C	dw	0
data_b_369E	db	0
data_b_369F	db	0
data_b_36A0	dw	0
		db	0, 0, 0, 3, 0, 0
		db	0, 0, 0, 0, 2, 0
		db	0, 0, 0, 0, 0, 1
		db	5, 0, 0, 0, 0, 0
		db	3, 5, 0, 0, 0, 0
		db	0, 2, 5, 0, 0, 0
		db	0, 0, 4, 0, 0, 0
data_b_36CC	dw	36A2h			; Data table (indexed access)
		db	0A2h, 36h,0A2h, 36h,0A9h, 36h
		db	0B0h, 36h,0B7h, 36h,0BEh, 36h
		db	0C5h
		db	36h
data_b_36DC	dw	1			; table of bonus multipliers
		db	 03h, 00h, 05h, 00h, 07h, 00h
		db	 09h, 00h, 0Bh, 00h, 0Dh, 00h
		db	 0Fh, 00h

data_b_36EC	dw	3130h			; table of bonus multipliers in text form (2 digits)
		db	'030507091113150206101418222630'

data_b_370C	dw	0			; index of bonus multiplier 0..15

data_b_370E	db	'BONUS MULTIPLIER: '	; Data table (indexed access)
data_b_3720	dw	3231h

data_b_3722	db	14 dup (0)		; wait time in system ticks
		db	 55h, 55h, 55h, 5Ah, 55h,0AAh
		db	 5Ah,0AAh, 5Ah,0AAh, 5Ah,0AAh
		db	 55h, 5Ah, 55h, 55h, 55h, 55h
		db	12 dup (0AAh)
		db	 55h, 55h, 55h, 55h,0A5h, 55h
		db	0AAh, 55h,0AAh,0A5h,0AAh,0A5h
		db	0AAh,0A5h,0A5h, 55h, 55h, 55h
		db	 55h, 55h,0AFh,0FFh,0ACh, 03h
		db	0AFh,0FFh,0AFh,0C3h,0AFh,0FFh
		db	0AFh,0FFh, 55h, 55h, 55h, 55h
		db	0AAh, 55h, 02h,0FFh,0FEh, 55h
		db	 02h, 55h, 02h, 55h, 02h, 55h
		db	 55h, 55h, 55h, 55h,0AAh, 84h
		db	0AAh, 12h,0A8h, 4Ah,0A1h, 2Ah
		db	 84h,0AAh, 12h,0AAh, 55h, 55h
		db	 55h, 55h, 00h, 2Fh, 2Ah, 20h
		db	 00h, 2Fh, 00h, 2Fh, 00h, 2Fh
		db	 00h
		db	 2Fh, 55h, 55h
data_b_37A0	dw	0
data_b_37A2	db	0
data_b_37A3	dw	0C0h			; Data table (indexed access)
		db	0E0h, 00h, 00h, 01h
data_b_37A9	dw	3F0h			; Data table (indexed access)
		db	0F8h, 03h, 00h, 04h
data_b_37AF	db	0
data_b_37B0	db	0, 0			; Data table (indexed access)
data_b_37B2	dw	0
data_b_37B4	dw	0
data_b_37B6	dw	0
data_b_37B8	dw	0
		db	0, 0, 0, 0, 0, 0
data_b_37C0	db	0
		db	 00h, 00h, 00h, 00h, 00h, 08h
		db	 00h, 00h, 00h, 28h, 00h, 02h
		db	0A2h,0AAh, 00h, 00h, 00h, 2Ah
		db	 02h,0AAh,0A0h,0AAh, 00h,0A0h
		db	0EAh,0FEh, 80h, 00h, 00h,0AEh
		db	0AAh,0FEh,0ABh,0FEh, 80h, 0Bh
		db	0FFh,0FFh,0A2h,0A0h,0AAh,0BFh
		db	0BFh,0FFh,0AFh,0EEh, 80h, 0Bh
		db	0AAh,0FFh,0EAh,0EAh,0BFh,0FFh
		db	0FFh,0AFh,0FFh,0AEh, 00h, 2Bh
		db	0AFh,0BFh,0FFh,0FFh,0FFh,0EAh
		db	0FEh,0BFh,0FFh,0AEh,0A0h, 2Fh
		db	0AFh,0BFh,0FFh,0FFh,0FEh,0ABh
		db	0FAh,0FFh,0FFh,0AFh,0A0h, 2Fh
		db	0AFh,0BEh,0BFh,0AFh,0EAh,0BFh
		db	0EBh,0FBh,0FFh,0AFh,0A0h,0AFh
		db	0AAh,0FEh,0BFh,0AEh,0AEh,0BFh
		db	0EBh,0EBh,0FFh,0BEh,0A0h,0BFh
		db	0AFh,0BFh,0AEh,0BFh,0FEh,0BFh
		db	0FAh,0AFh,0FFh,0FEh, 80h,0AFh
		db	0AFh,0AFh,0AEh,0BFh,0FEh,0BFh
		db	0FAh,0BFh,0FEh,0BEh, 80h, 2Bh
		db	0AFh,0AFh,0EAh,0FFh,0FFh,0AFh
		db	0FEh,0BEh,0FEh,0BAh, 80h, 0Bh
		db	0AAh,0BFh,0FAh,0FFh,0FFh,0AFh
		db	0FEh,0BAh,0FFh,0FAh, 00h, 2Bh
		db	0FFh,0FFh,0EBh,0FFh,0FFh,0AFh
		db	0FFh,0ABh,0FFh,0EAh, 00h, 2Ah
		db	0EAh,0FFh,0EBh,0FFh,0FFh,0AFh
		db	0FFh,0AFh,0FAh,0AAh, 00h, 0Ah
		db	0AAh,0FFh,0AFh,0FAh,0BFh,0FEh
		db	0AFh,0FEh,0AAh,0A8h, 00h, 00h
		db	0A2h,0BEh,0BFh,0EAh,0ABh,0FAh
		db	0ABh,0FAh,0A8h, 00h, 00h, 00h
		db	 02h,0AFh,0FEh,0A8h,0AAh,0AAh
		db	 2Bh,0FAh, 00h, 00h, 00h, 00h
		db	 00h,0AAh,0FAh,0A0h, 0Ah,0A8h
		db	 2Ah,0EAh, 00h, 00h, 00h, 00h
		db	 00h, 2Ah,0AAh, 80h, 00h, 00h
		db	 0Ah,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 02h,0A8h, 00h, 00h, 00h
		db	 02h,0A0h, 00h, 00h
		db	0
data_b_38BC	db	0
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 3Fh, 00h, 00h,0FCh, 00h, 00h
		db	0D1h,0C3h,0C3h, 47h, 00h, 00h
		db	 00h, 7Dh, 7Dh, 00h, 00h, 00h
		db	 00h, 0Dh, 70h, 00h, 00h, 00h
		db	 00h, 35h, 5Ch, 00h, 00h, 00h
		db	 3Fh,0F5h, 5Fh,0FCh, 00h, 00h
		db	0D4h, 3Dh, 7Ch, 17h, 00h, 03h
		db	 40h,0E9h, 6Bh, 01h,0C0h, 00h
loc_b_38F3:
		add	cx,[di+71h]
		rol	byte ptr [bx+si],0	; Rotate
		or	ax,700Dh
		jo	$+2			; delay for I/O
		add	[di],cl
		add	ax,ax
		jo	$+2			; delay for I/O
		add	[bp+di],al
		inc	ax
;*		add	ax,ax
		db	 01h,0C0h		;  Fixup - byte match
		add	[bx+si],al
;*		add	al,dl
		db	 00h,0D0h		;  Fixup - byte match
		pop	es
		add	[bx+si],al
		add	[bx],cl
		add	[bx+si],al
                           lock	add	[bx+si],al
		xor	ax,3C0h
		pop	sp
		add	[bx+si],al
		xor	[bx+si+0Dh],dh
		or	al,0
		add	[bx+si],al
		jnc	loc_b_38F3		; Jump if carry=0
		db	 00h, 00h, 00h, 00h, 1Dh, 74h
		db	 00h, 00h, 00h,0FCh, 0Dh, 70h
		db	 3Fh, 00h, 03h, 47h, 35h, 5Ch
		db	0D1h,0C0h, 00h, 01h,0F5h, 5Fh
		db	 40h, 00h, 00h, 00h, 3Dh, 7Ch
		db	 00h, 00h, 00h, 0Fh,0E9h, 6Bh
		db	0F0h, 00h, 00h, 34h, 0Dh, 70h
		db	 1Ch, 00h, 00h,0D0h, 0Dh, 70h
		db	 07h, 00h, 00h,0D0h, 03h,0C0h
		db	 07h, 00h
		db	0, 0, 0, 0, 0, 0
data_b_3964	dw	0
data_b_3966	db	0
data_b_3967	db	0
data_b_3968	dw	0
data_b_396A	db	0
data_b_396B	dw	0
data_b_396D	db	0
data_b_396E	db	0
data_b_396F	db	0
		db	60 dup (0)
		db	20 dup (0)
		db	0, 0, 0
data_b_39C3	dw	0
data_b_39C5	db	0
data_b_39C6	dw	0
data_b_39C8	dw	0
data_b_39CA	dw	0
data_b_39CC	dw	2			; Data table (indexed access)
		db	 04h, 00h, 06h, 00h, 08h, 00h
		db	 0Ah, 00h, 0Ch, 00h, 0Eh, 00h
		db	 10h
		db	0, 0, 0, 0, 0
data_b_39E0	db	0
data_b_39E1	db	0
data_b_39E2	dw	0
data_b_39E4	dw	0
data_b_39E6	dw	0
data_b_39E8	dw	0
		db	 55h, 5Fh,0F5h, 55h, 55h,0FFh
		db	 01h, 55h, 57h,0FCh, 00h, 15h
		db	 5Fh,0E8h, 00h, 05h, 5Fh, 0Ah
		db	 80h, 29h, 7Fh, 80h, 00h, 01h
		db	 7Fh,0A8h, 00h, 02h, 40h, 20h
		db	 00h, 2Ah, 0Fh, 00h, 00h, 2Ah
		db	 7Fh, 80h, 00h, 09h, 5Fh,0C0h
		db	 00h, 09h, 5Fh, 00h,0AAh, 01h
		db	 54h, 0Eh,0AAh,0D0h, 55h,0FFh
		db	0FFh, 55h, 55h, 5Fh,0F5h, 55h
		db	 55h, 55h, 55h, 55h, 55h, 5Fh
		db	0F5h, 55h, 55h,0FFh, 00h, 55h
		db	 40h, 3Ch, 00h, 15h, 0Fh, 00h
		db	 00h, 25h, 5Fh,0C0h, 00h, 09h
		db	 7Fh, 80h, 00h, 09h, 7Fh, 00h
		db	0AAh, 02h, 7Ch, 0Ah,0AAh,0A0h
		db	 7Fh,0AAh,0AAh,0AAh, 7Fh,0AAh
		db	0AAh,0A9h, 5Fh,0EAh,0AAh,0A9h
		db	 5Fh,0EAh,0AAh,0A5h, 57h,0FEh
		db	0AAh,0D5h, 55h,0FFh,0FFh, 55h
		db	 55h, 5Fh,0F5h
		db	22 dup (55h)
		db	 7Fh,0FDh, 55h, 5Fh,0FFh,0C3h
		db	0C1h,0FFh,0FAh, 00h, 03h,0FEh
		db	0A8h, 00h, 00h,0EAh,0A8h, 00h
		db	 03h,0AAh, 0Ah, 80h, 2Ah,0AAh
		db	 80h, 00h, 02h,0AAh,0A8h, 00h
		db	 02h, 50h, 20h, 00h, 20h, 55h
		db	 40h, 00h, 15h
		db	25 dup (55h)
		db	 7Fh,0FDh, 55h, 5Fh,0FFh,0FFh
		db	0F5h,0FFh,0FAh,0AFh,0FFh,0FEh
		db	0AAh,0AAh,0BFh,0EAh,0A8h, 28h
		db	 2Bh,0AAh,0A0h, 00h, 2Ah,0AAh
		db	 80h, 00h, 0Ah,0AAh, 80h, 00h
		db	 2Ah, 50h,0A8h, 02h,0A0h, 55h
		db	 40h, 01h
		db	 55h, 55h
		db	23 dup (55h)
		db	 5Fh,0F5h, 5Fh,0FFh, 55h,0F5h
data_b_3B00	db	55h
		db	55h
data_b_3B02	db	'UUUUUU}U'
		db	0F5h, 5Fh,0F5h,0FFh, 55h, 5Fh
		db	 55h, 55h, 55h, 5Fh,0F5h, 55h
		db	 55h,0FFh,0AAh, 55h, 57h,0FEh
		db	0AAh, 95h, 5Fh,0EAh,0AAh,0A5h
		db	 5Fh,0EAh,0AAh,0A9h, 7Fh,0AAh
		db	0AAh,0A9h, 7Fh,0AAh,0AAh,0AAh
		db	 7Fh,0AAh,0AAh,0AAh, 7Fh,0AAh
		db	0AAh,0AAh, 7Fh,0AAh,0AAh,0A9h
		db	 5Fh,0EAh,0AAh,0A9h, 5Fh,0EAh
		db	0AAh,0A5h, 57h,0FEh,0AAh,0D5h
		db	 55h,0FFh,0FFh, 55h, 55h, 5Fh
		db	0F5h, 55h, 55h, 55h, 55h, 55h
		db	0FFh
		db	'UUUUUUUU_'
		db	8 dup (55h)
		db	0FFh
		db	'UUUUUUUU'
		db	0FFh
		db	'UUUUUUUU'
		db	0FFh, 55h, 55h
		db	14 dup (55h)
		db	 57h,0F5h
		db	8 dup (55h)
		db	5Fh
		db	17 dup (55h)
		db	 7Fh,0FDh, 55h, 5Fh,0FFh,0FFh
		db	0F5h,0FFh,0FAh,0AFh,0FFh,0FEh
		db	0AAh,0AAh,0BFh,0EAh,0AAh,0AAh
		db	0ABh
		db	12 dup (0AAh)
		db	 5Ah,0AAh,0AAh,0A5h, 55h, 6Ah
		db	0A9h
		db	9 dup (55h)
		db	 5Eh,0AAh, 57h,0AAh, 55h,0AAh
		db	'UjUzUV}WW'
		db	0F5h, 55h, 55h, 55h, 55h, 55h
		db	 7Fh, 57h,0FEh, 5Fh,0EAh, 5Fh
		db	0EAh, 7Fh,0AAh, 7Fh,0AAh, 7Fh
		db	0AAh, 7Fh,0EAh, 7Fh,0EAh, 5Fh
		db	0FAh, 5Fh,0FFh, 55h,0FFh, 55h
		db	 57h, 55h, 55h, 5Ah,0AAh,0AAh
		db	0AAh, 5Fh,0AAh,0AAh,0AAh, 55h
		db	 5Ah,0AAh,0AAh, 55h, 5Fh,0AAh
		db	0AAh, 55h, 55h, 5Ah,0AAh, 55h
		db	 55h, 55h,0AAh, 55h, 55h, 55h
		db	0FAh
		db	 55h, 55h, 55h, 5Fh
data_b_3C22	db	8
		db	 08h, 52h, 3Bh, 06h, 05h, 52h
		db	 3Bh, 4Eh, 06h, 52h, 3Bh, 96h
		db	 07h, 52h, 3Bh,0DEh
		db	8, 'R;&', 0Ah, 'R;n'
		db	 0Bh,0FFh,0FFh
data_b_3C3E	db	4
		db	 08h, 02h, 3Ch, 20h, 05h, 02h
		db	 3Ch, 64h, 06h, 02h, 3Ch,0A8h
		db	 07h, 02h, 3Ch,0ECh, 08h, 02h
		db	 3Ch, 30h, 0Ah,0FFh,0FFh
data_b_3C56	db	4
		db	 10h, 92h, 3Bh
data_b_3C5A	dw	516h			; Data table (indexed access)
		db	 92h, 3Bh, 1Ch, 05h, 92h, 3Bh
		db	 60h, 06h, 12h, 3Bh, 06h, 0Ah
		db	 12h, 3Bh,0D2h, 08h, 12h, 3Bh
		db	 5Eh, 0Bh, 12h, 3Bh, 0Ah, 0Fh
		db	 12h, 3Bh,0D4h, 0Dh, 12h, 3Bh
		db	 32h, 0Fh, 12h, 3Bh, 98h, 11h
		db	 12h, 3Bh, 26h, 14h, 12h, 3Bh
		db	0E2h, 12h, 12h, 3Bh, 4Ch, 15h
		db	 12h, 3Bh, 9Ah, 16h, 12h, 3Bh
		db	0C8h, 17h, 12h, 3Bh,0F0h, 17h
		db	0FFh,0FFh
data_b_3C9A	db	2
		db	 08h,0D2h, 3Bh, 74h, 0Bh,0F2h
		db	 3Bh,0B6h, 0Ch,0E2h, 3Bh, 36h
		db	 19h,0FFh,0FFh
data_b_3CAA	db	0F0h
		db	0, 0, 0
data_b_3CAE	db	0Ch			; Data table (indexed access)
		db	 0Eh, 11h, 13h, 15h, 17h, 18h
		db	9 dup (19h)
		db	18h
data_b_3CBF	dw	0
data_b_3CC1	dw	0
data_b_3CC3	db	0F6h			; Data table (indexed access)
		db	 9Bh,0ACh, 1Eh,0D2h, 43h, 58h
		db	 70h,0EBh, 6Fh,0CAh, 29h,0D7h
		db	 51h, 48h, 03h, 79h,0CDh,0BFh
		db	0A0h,0E1h, 64h, 23h, 85h, 2Dh
		db	 0Eh,0F6h, 5Bh,0CAh, 97h, 81h
		db	34h
data_b_3CE3	db	0			; Data table (indexed access)
data_b_3CE4	db	0			; Data table (indexed access)
		db	14 dup (0)
data_b_3CF3	db	0			; Data table (indexed access)
data_b_3CF4	db	0			; Data table (indexed access)
		db	14 dup (0)
data_b_3D03	dw	0
data_b_3D05	db	0
data_b_3D06	dw	3B12h			; Data table (indexed access)
		db	0EAh, 39h, 2Ah, 3Ah, 12h, 3Bh
		db	 12h, 3Bh, 2Ah, 3Ah,0EAh, 39h
		db	 12h
		db	3Bh
data_b_3D16	dw	0
data_b_3D18	dw	0
		db	0, 0, 0, 0, 0, 0
data_b_3D20	db	0FFh
		db	0FFh,0FFh,0FFh,0FFh, 03h,0C0h
		db	0FFh,0FFh, 00h, 00h,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FCh, 3Ch, 3Ch
		db	 3Fh,0FFh, 00h, 00h,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh,0F0h, 0Fh
		db	0FFh,0FFh,0C0h, 03h,0FFh,0FFh
		db	 0Fh,0F0h
		db	22 dup (0FFh)
		db	 03h,0C0h,0FFh,0FFh, 00h, 00h
		db	0FFh,0FFh,0F0h, 0Fh,0FFh,0FFh
		db	0FCh, 3Fh,0FFh,0FFh, 00h, 00h
		db	0FFh,0FCh, 30h, 0Ch, 3Fh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh,0C0h, 03h
		db	0FFh,0FFh, 0Fh,0F0h,0FFh,0FFh
		db	0FCh, 3Ch, 3Fh,0FFh, 00h, 00h
		db	0FFh,0FCh, 30h, 0Fh,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FFh,0C0h, 03h
		db	0FFh,0FFh, 0Fh,0F0h
		db	26 dup (0FFh)
		db	0F0h, 0Fh,0FFh,0FFh,0C0h, 03h
		db	0FFh,0FFh, 0Fh,0F0h
		db	37 dup (0FFh)
data_b_3DE0	dw	3D50h			; Data table (indexed access)
		db	 20h, 3Dh
data_b_3DE4	db	194 dup (0)
data_b_3EA6	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_b_3EAE	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_3EB2	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_3EB6	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_3EBA	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_b_3EC2	dw	3DE6h			; Data table (indexed access)
		db	 16h, 3Eh, 46h, 3Eh, 76h, 3Eh
data_b_3ECA	db	0, 0
data_b_3ECC	dw	0			; Data table (indexed access)
		db	0, 0, 0, 0, 0, 0
data_b_3ED4	db	0			; Data table (indexed access)
		db	0, 0, 0
data_b_3ED8	db	0
data_b_3ED9	db	0
data_b_3EDA	dw	0
data_b_3EDC	dw	0
data_b_3EDE	dw	14h			; Data table (indexed access)
		db	 50h, 00h, 64h, 00h, 78h, 00h
		db	 78h, 00h, 8Ch, 00h, 8Ch, 00h
		db	 8Ch, 00h, 00h, 00h, 3Ch, 00h
		db	 0Fh, 30h, 03h,0F0h, 0Fh,0C0h
		db	 0Ch, 00h, 0Fh, 30h, 3Ch,0F0h
		db	 03h,0C0h, 0Ch, 00h, 00h, 00h
		db	 00h, 0Ch, 00h,0FCh, 03h,0F0h
		db	 00h,0C0h, 03h, 00h, 00h, 3Ch
		db	 0Ch,0F0h, 0Fh,0C0h, 03h,0F0h
		db	 00h, 30h, 0Ch,0F0h, 0Fh, 3Ch
		db	 03h,0C0h, 00h, 30h, 00h, 00h
		db	0C0h, 00h,0FCh, 00h, 3Fh, 00h
		db	 0Ch, 00h, 03h
		db	0
data_b_3F2C	db	0
		db	9 dup (0)
data_b_3F36	db	0FFh
		db	 00h, 0Fh, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0FCh, 3Fh, 00h, 0Fh,0C0h
		db	0FFh,0FFh,0FFh,0FCh, 00h,0F0h
		db	0F0h, 00h, 03h,0FFh,0FFh,0FCh
		db	 30h, 00h, 00h,0F0h,0C0h, 3Fh
		db	0FFh,0FFh, 0Fh,0F0h,0FFh,0F0h
		db	0FFh, 03h,0FFh,0FFh, 00h, 00h
		db	0FCh, 00h, 00h, 00h,0FFh,0FFh
		db	0F0h,0F0h, 00h,0F0h, 00h,0F0h
		db	 3Fh,0FFh,0F0h,0FFh, 0Fh,0FFh
		db	 0Fh,0C0h, 3Fh,0FFh,0FCh, 00h
		db	 03h,0C0h, 00h, 00h, 3Fh,0FFh
		db	0FCh, 3Ch, 00h, 0Fh, 00h, 00h
		db	0FFh,0FFh,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 00h,0FFh,0FFh,0FFh, 03h
		db	0FCh, 00h, 00h, 00h, 3Fh,0FFh
		db	0FFh,0F0h, 3Fh, 00h, 00h, 00h
		db	 3Fh,0FFh,0FFh,0FCh, 0Fh, 00h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 00h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 3Fh,0FFh,0FFh
data_b_3FBE	db	0FFh
		db	 00h, 0Fh, 00h, 0Fh,0FFh,0F0h
		db	 3Fh, 00h, 0Fh,0C0h,0FFh,0C0h
		db	 0Fh, 0Fh, 0Fh, 00h, 3Fh,0C3h
		db	 00h, 00h, 00h, 0Ch, 3Fh, 0Fh
		db	0F0h,0FFh,0F0h,0FFh, 0Fh, 00h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 0Fh
		db	 00h, 00h, 00h, 0Fh, 0Fh, 0Fh
		db	0F0h,0FFh,0F0h,0FFh, 0Fh, 00h
		db	 00h,0FFh,0F0h, 00h, 0Fh, 0Fh
		db	 00h, 00h, 00h, 0Fh, 0Fh, 0Fh
		db	0F0h,0FFh,0F0h,0FFh, 0Fh, 0Fh
		db	 00h, 00h, 00h, 0Fh, 0Fh,0C0h
		db	 00h, 00h, 00h, 00h, 3Fh,0C0h
		db	 00h, 00h, 00h, 00h, 3Fh,0F0h
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	 00h, 00h, 00h, 0Fh,0FFh
data_b_401E	db	0
		db	54 dup (0)
data_b_4055	db	0
		db	80 dup (0)
data_b_40A6	dw	0
data_b_40A8	dw	0
data_b_40AA	db	0			; required speaker tone
data_b_40AB	dw	0
data_b_40AD	dw	0
data_b_40AF	db	0
data_b_40B0	db	0
data_b_40B1	db	0
data_b_40B2	dw	0
data_b_40B4	db	0
data_b_40B5	dw	0
data_b_40B7	db	0
data_b_40B8	db	0
data_b_40B9	db	0
data_b_40BA	dw	0
data_b_40BC	dw	0
data_b_40BE	dw	0
data_b_40C0	dw	3EF0h			; Data table (indexed access)
		db	0FAh, 3Eh, 04h, 3Fh,0FAh, 3Eh
data_b_40C8	dw	0
data_b_40CA	db	0
data_b_40CB	db	0
data_b_40CC	dw	0
data_b_40CE	dw	2Eh			; Data table (indexed access)
		db	 5Ch, 00h, 8Ch, 00h, 8Ch, 00h
		db	0A0h, 00h,0AAh, 00h,0B4h, 00h
		db	0B4h, 00h
data_b_40DE	dw	18h			; Data table (indexed access)
		db	0DCh, 00h, 60h, 00h, 40h, 00h
		db	 10h, 01h, 40h, 00h, 04h, 01h
		db	 0Ch, 01h,0F8h, 00h,0F8h, 00h
		db	0E0h, 00h
data_b_40F4	db	6Ah			; Data table (indexed access)
		db	 7Ah, 52h, 7Ah, 50h, 9Ah, 9Eh
		db	 7Ah, 62h, 50h, 50h
data_b_40FF	db	0
data_b_4100	db	0FFh
		db	0FFh,0C0h,0FFh,0C0h,0C0h,0FFh
		db	0FFh, 03h,0FFh, 03h, 03h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0F0h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0C0h
		db	0F0h, 0Fh,0FFh,0F0h,0FFh,0C0h
		db	 00h, 00h, 0Fh, 00h, 3Fh,0F0h
		db	 00h, 00h, 00h, 00h, 0Fh,0C3h
		db	 00h, 00h, 00h, 00h, 0Fh,0C3h
		db	0F0h,0F0h, 00h, 0Fh, 0Fh,0C3h
		db	0F0h,0FFh, 0Fh, 00h,0FFh,0F0h
		db	0FCh, 3Fh,0C3h,0FFh,0FFh,0F0h
		db	0FFh,0FFh,0FFh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FFh, 0Fh
		db	0FFh,0C0h, 3Fh,0F0h,0FFh, 00h
		db	0F0h, 00h, 0Fh, 00h, 3Fh,0C0h
		db	 00h, 00h, 00h, 00h, 0Fh,0F0h
		db	 00h, 00h, 00h, 00h, 0Fh,0C3h
		db	 00h, 0Fh, 00h, 0Fh, 0Fh,0C3h
		db	0F0h,0FFh, 0Fh, 00h,0FFh,0C3h
		db	0F0h,0FFh, 0Fh,0FFh,0FFh,0F0h
		db	0FCh, 3Fh,0C3h
		db	7 dup (0FFh)
		db	0C3h,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 3Fh,0FCh, 3Fh,0FFh,0C0h, 3Ch
		db	 0Fh,0F0h, 03h,0C0h, 00h, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	 3Fh,0C0h, 00h, 00h, 00h, 03h
		db	 0Fh,0C3h,0C0h, 00h, 3Ch, 3Fh
		db	 0Fh,0FCh, 03h,0C3h,0FCh, 3Fh
		db	 0Fh,0FFh,0FFh, 0Fh,0F0h,0FCh
		db	 3Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	0C3h,0FFh, 0Fh,0FCh, 03h,0FFh
		db	0F0h,0FCh, 00h,0F0h, 00h, 0Fh
		db	 00h,0F0h, 00h, 00h, 00h, 00h
		db	 03h,0F0h, 00h, 00h, 00h, 00h
		db	 0Fh,0F0h,0F0h, 00h,0F0h, 00h
		db	0C3h,0FFh, 00h,0F0h,0FFh, 0Fh
		db	0C3h,0FFh,0FFh,0F0h,0FFh, 0Fh
		db	0C3h,0FFh,0FFh,0C3h,0FCh, 3Fh
		db	 0Fh
		db	33 dup (0AAh)
		db	 95h, 55h,0AAh,0A9h, 6Ah,0AAh
		db	 5Ah,0A5h,0AAh,0AAh, 96h, 95h
		db	 6Ah,0AAh, 55h, 95h, 55h, 55h
		db	 55h, 95h, 55h, 55h, 55h,0A5h
		db	 55h, 55h, 56h,0AAh, 55h, 55h
		db	 6Ah,0AAh, 95h, 55h,0AAh,0A9h
		db	 6Ah,0AAh, 5Ah,0A5h,0AAh,0AAh
		db	 96h, 95h, 6Bh,0FAh, 55h, 95h
		db	 55h, 55h, 55h, 95h, 55h, 55h
		db	 55h,0A5h, 55h, 55h, 56h,0AAh
		db	 55h, 55h, 6Ah,0AAh, 95h, 55h
		db	0AAh,0A9h, 6Ah,0AAh, 5Ah,0A5h
		db	0AFh,0FEh, 96h, 95h, 7Fh,0FFh
		db	 55h, 95h, 55h, 55h, 55h, 95h
		db	 55h, 55h, 55h,0A5h, 55h, 55h
		db	 56h,0AAh, 55h, 55h, 6Ah,0AAh
		db	 95h, 55h,0AAh,0A9h, 7Fh,0FFh
		db	 5Ah,0A5h,0FFh,0FFh,0D6h, 95h
		db	 7Fh,0FFh, 55h, 95h, 55h, 55h
		db	 55h, 95h, 55h, 55h, 55h,0A5h
		db	 55h, 55h, 56h,0AAh, 55h, 55h
		db	 6Ah,0AAh,0AAh,0AAh,0AAh,0ABh
		db	0FAh,0AFh
		db	7 dup (0AAh)
		db	0BFh,0FFh,0AFh,0FBh,0FAh,0FEh
		db	0AAh,0AAh,0AFh,0FAh,0FFh,0FFh
		db	0EAh,0FFh,0FFh,0FAh,0AAh,0ABh
		db	0FFh,0FFh,0FFh,0FFh,0C3h,0FFh
		db	0FFh,0AAh,0AAh,0FFh,0FFh,0FFh
		db	0FFh,0FFh, 0Fh,0FFh,0FFh,0FAh
		db	0AFh,0FFh,0FFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FAh,0BEh,0AFh
		db	0FFh,0FFh,0FFh,0FFh,0C0h,0FFh
		db	0FFh,0AAh,0AAh,0FFh,0FBh,0FFh
		db	0FFh,0FFh,0FCh, 0Fh,0FBh,0FAh
		db	0AFh,0FFh,0AAh,0FFh,0FFh,0FAh
		db	0FFh,0C0h, 2Ah,0FFh,0FFh,0AAh
		db	0AAh,0AAh,0FFh,0AAh,0BFh,0FFh
		db	0EAh,0AFh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0FFh,0FAh
		db	9 dup (0AAh)
		db	0FEh
		db	11 dup (0AAh)
		db	0AFh,0AAh,0AAh,0BEh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0ABh,0EFh
		db	0FBh,0FAh,0FFh,0EAh,0AAh,0AAh
		db	0AAh,0AAh,0ABh,0FFh,0FFh,0C3h
		db	0FFh,0FEh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0FFh,0FFh,0F0h,0FFh,0FFh
		db	0AFh,0FAh,0AAh,0AAh,0ABh,0FFh
		db	0FFh,0F0h,0FFh,0FFh,0FFh,0FFh
		db	0AAh,0AAh,0ABh,0FFh,0FFh,0C3h
		db	0FFh,0FFh,0FFh,0FFh,0FAh,0BEh
		db	0ABh,0FFh,0FFh, 0Fh,0FFh,0FFh
		db	0FFh,0FFh,0FFh,0FAh,0BEh,0BFh
		db	0FAh, 3Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0AAh,0FAh,0AAh,0AAh,0FFh
		db	0FFh,0FFh,0FFh,0FFh,0BFh,0FAh
		db	0AAh,0AAh,0AFh,0FFh,0AAh,0FFh
		db	0FFh,0FAh,0FAh,0FFh,0AAh,0AAh
		db	0FFh,0AAh,0AAh,0AAh,0FFh,0AAh
		db	0FFh,0AFh,0AAh,0AAh,0FAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh
		db	9 dup (0AAh)
		db	0BEh,0AAh
data_b_43A0	db	0
		db	59 dup (0)
data_b_43DC	dw	0
data_b_43DE	dw	0
data_b_43E0	db	0
data_b_43E1	dw	2Ch			; Data table (indexed access)
		db	 7Ch, 00h,0C4h, 00h, 20h, 00h
		db	 5Ch, 00h, 9Ch, 00h,0CCh, 00h
		db	 0Ch, 01h, 34h, 00h, 84h, 00h
		db	0BCh, 00h, 24h, 01h
data_b_43F9	dw	88h			; Data table (indexed access)
		db	 88h, 00h, 88h, 00h, 98h, 00h
		db	 98h, 00h, 98h, 00h, 98h, 00h
		db	 98h, 00h,0A8h, 00h,0A8h, 00h
		db	0A8h, 00h,0A8h, 00h
data_b_4411	dw	1546h			; Data table (indexed access)
		db	 5Ah, 15h, 6Ch, 15h,0C0h, 17h
		db	0D2h, 17h,0E2h, 17h,0EEh, 17h
		db	0FEh, 17h, 48h, 1Ah, 5Ch, 1Ah
		db	 6Ah, 1Ah, 84h, 1Ah
data_b_4429	dw	431Eh			; Data table (indexed access)
		db	 9Ch, 42h, 1Eh, 43h, 9Ch, 42h
		db	 1Eh, 43h, 1Eh, 43h, 9Ch, 42h
		db	 9Ch, 42h, 1Eh, 43h, 9Ch, 42h
		db	 9Ch, 42h, 1Eh
		db	43h
data_b_4441	dw	12 dup (0)		; Data table (indexed access)
data_b_4459	dw	0			; Data table (indexed access)
		db	22 dup (0)
data_b_4471	db	6			; Data table (indexed access)
		db	6, 7, 7, 8, 8, 9
		db	9
data_b_4479	db	1			; Data table (indexed access)
		db	2, 3, 4, 4, 4, 4
		db	4
data_b_4481	dw	8			; Data table (indexed access)
		db	 90h, 00h,0A0h, 00h, 28h, 00h
		db	 38h, 00h, 78h, 00h,0E0h, 00h
		db	 20h, 01h, 10h, 00h, 98h, 00h
		db	0D0h, 00h, 00h, 01h
data_b_4499	db	90h			; Data table (indexed access)
		db	 90h, 90h,0A0h,0A0h,0A0h,0A0h
		db	0A0h,0B0h,0B0h,0B0h,0B0h
data_b_44A5	dw	4184h			; Data table (indexed access)
		db	 84h, 41h, 0Ch, 41h, 84h, 41h
		db	 0Ch, 41h, 0Ch, 41h, 84h, 41h
		db	 0Ch, 41h, 84h, 41h, 84h, 41h
		db	 84h
		db	 41h, 0Ch, 41h
data_b_44BD	db	0
data_b_44BE	db	0
data_b_44BF	dw	0
data_b_44C1	dw	0
data_b_44C3	db	0
data_b_44C4	db	0			; Data table (indexed access)
		db	11 dup (0)
data_b_44D0	db	0
data_b_44D1	dw	0
data_b_44D3	dw	0
data_b_44D5	db	0
data_b_44D6	db	0
data_b_44D7	dw	0
data_b_44D9	db	0
data_b_44DA	dw	0
data_b_44DC	dw	12h			; Data table (indexed access)
		db	 10h, 00h, 0Fh, 00h, 0Eh, 00h
		db	 0Dh, 00h, 0Ch, 00h, 0Bh, 00h
		db	 0Ah, 00h
data_b_44EC	dw	28h			; Data table (indexed access)
		db	 32h, 00h, 3Ch, 00h, 46h, 00h
		db	 55h, 00h, 50h, 00h, 55h, 00h
		db	 5Ah, 00h
data_b_44FC	db	0
		db	0, 0, 0
data_b_4500	db	0
		db	 00h, 03h,0C0h,0C0h, 00h, 00h
		db	 00h, 03h,0FFh,0C0h, 00h, 00h
		db	 00h, 0Fh, 3Fh, 30h, 00h, 00h
		db	 00h, 3Fh,0FFh,0FCh, 00h, 00h
		db	 00h, 0Fh,0FFh,0F0h, 00h, 00h
		db	 00h, 00h,0FFh, 00h, 00h, 00h
		db	 0Fh, 03h,0FFh, 00h, 00h, 00h
		db	 3Ch, 0Fh,0FFh,0C0h, 00h, 00h
		db	 0Fh,0FFh,0FFh,0F0h, 00h, 00h
		db	 00h,0FFh,0FFh,0F0h, 00h, 00h
		db	 00h, 3Fh,0FFh,0C0h, 00h, 00h
		db	 00h,0FCh,0F3h,0F0h
		db	0
data_b_4548	dw	0
data_b_454A	db	0
data_b_454B	db	0
data_b_454C	dw	0
data_b_454E	db	0
data_b_454F	dw	0
data_b_4551	dw	0
data_b_4553	db	0
		db	84 dup (0)
data_b_45A8	dw	4554h			; Data table (indexed access)
		db	 60h, 45h, 6Ch, 45h, 78h, 45h
		db	 84h, 45h, 90h, 45h, 9Ch
		db	45h
data_b_45B6	db	0, 0
data_b_45B8	dw	0
data_b_45BA	dw	0
data_b_45BC	dw	0
data_b_45BE	db	0
data_b_45BF	db	10h			; Data table (indexed access)
		db	 20h, 30h, 40h, 60h, 80h,0C0h
		db	0C0h
data_b_45C7	dw	21Ch			; Data table (indexed access)
		db	 68h, 01h, 0Eh, 01h,0B4h, 00h
		db	0AFh, 00h,0AAh, 00h,0A0h, 00h
		db	 8Ch, 00h, 00h
		db	15 dup (0)
		db	 03h,0FCh, 00h, 03h, 00h, 3Ch
		db	 3Fh,0FFh, 00h, 3Fh,0F0h,0CFh
		db	 3Fh,0FFh,0F0h,0FFh, 0Fh, 03h
		db	0FFh,0C3h,0FFh,0FFh,0F0h, 03h
		db	0FCh, 00h,0FFh,0FFh,0F0h, 00h
		db	 3Fh, 00h, 3Fh,0FCh, 3Ch, 00h
		db	0F3h,0C0h,0FFh, 0Fh, 00h, 00h
		db	0F3h,0C0h,0F0h, 03h,0C0h, 03h
		db	0C0h,0F0h,0F0h, 00h,0F0h, 0Fh
		db	 00h,0F0h,0F0h, 00h, 00h, 00h
		db	 00h, 3Ch, 3Ch, 00h, 00h, 0Fh
		db	 00h, 00h, 00h, 00h, 00h, 3Ch
		db	 00h,0FFh, 00h, 00h, 00h,0F0h
		db	 0Fh,0FFh,0F0h, 03h, 00h,0F0h
		db	0FFh,0FFh,0F0h, 3Fh,0F0h, 3Ch
		db	0FFh,0FFh,0FFh,0FFh, 0Fh, 0Fh
		db	0FFh, 00h,0FFh,0FFh,0FFh, 0Fh
		db	0F0h, 00h, 0Fh,0FFh,0F0h, 0Fh
		db	0FFh, 00h, 0Fh,0FCh, 00h, 00h
		db	0F3h,0F0h, 03h,0CFh,0F0h, 00h
		db	0F0h, 3Fh, 03h,0C0h, 3Ch, 00h
		db	0F0h, 00h, 00h,0F0h, 00h, 00h
		db	 3Ch, 00h, 00h
		db	3Ch
		db	8 dup (0)
		db	0C0h, 00h, 3Fh,0C0h, 00h, 0Fh
		db	0FCh, 00h,0FFh,0FCh, 3Ch,0F0h
		db	0FFh, 0Fh,0FFh,0FCh,0F3h, 0Fh
		db	0FFh,0FFh,0C3h,0FFh,0C0h, 0Fh
		db	0FFh,0FFh, 00h, 3Fh,0C0h, 3Ch
		db	 3Fh,0FCh, 00h,0FCh, 00h, 00h
		db	0F0h,0FFh, 03h,0CFh, 00h, 03h
		db	0C0h, 0Fh, 03h,0CFh, 00h, 0Fh
		db	 00h, 0Fh, 0Fh, 03h,0C0h, 00h
		db	 00h, 0Fh, 0Fh, 00h,0F0h, 00h
		db	 00h
		db	 3Ch, 3Ch
		db	7 dup (0)
		db	0F0h, 00h, 00h, 00h,0FFh, 00h
		db	 3Ch, 00h,0C0h, 0Fh,0FFh,0F0h
		db	 0Fh, 0Fh,0FCh, 0Fh,0FFh,0FFh
		db	 0Fh,0F0h,0FFh,0FFh,0FFh,0FFh
		db	 3Ch,0FFh,0FFh,0FFh, 00h,0FFh
		db	0F0h, 0Fh,0FFh,0F0h, 00h, 0Fh
		db	0F0h, 00h, 3Fh,0F0h, 00h,0FFh
		db	0F0h, 0Fh,0F3h,0C0h, 0Fh,0CFh
		db	 00h, 3Ch, 03h,0C0h,0FCh, 0Fh
		db	 00h, 00h, 0Fh, 00h, 00h, 0Fh
		db	 00h, 00h, 3Ch, 00h, 00h
		db	3Ch
		db	7 dup (0)
		db	 3Ch, 00h, 00h, 00h, 30h, 00h
		db	0C3h, 00h, 00h, 00h,0FFh, 00h
		db	0F0h, 00h, 00h, 00h,0FCh,0C0h
		db	 30h, 03h,0FCh, 03h,0FFh,0F0h
		db	 3Fh, 0Fh,0FFh,0F3h,0FFh,0C0h
		db	 0Fh,0FFh,0FFh,0FFh,0FFh, 00h
		db	 03h,0FFh,0FFh,0FFh,0FCh, 00h
		db	 03h,0CFh,0F3h,0FFh, 3Fh,0C0h
		db	 0Fh, 03h,0C0h, 3Ch, 00h,0F0h
		db	 0Fh, 03h,0C0h, 3Ch, 00h, 00h
		db	 03h, 00h,0F0h, 0Fh
		db	8 dup (0)
		db	 0Ch, 00h, 00h, 00h, 00h, 00h
		db	0F0h, 00h, 00h, 00h, 03h, 00h
		db	0C0h, 00h, 00h, 00h, 0Fh,0F0h
		db	0F0h, 00h, 0Fh,0FCh, 3Fh,0CCh
		db	 3Fh, 03h,0FFh,0FFh,0FFh,0FFh
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 00h,0FFh,0FFh, 3Fh,0FFh,0F0h
		db	 00h, 3Fh,0F0h, 00h,0FFh, 00h
		db	 00h,0F3h,0C0h, 00h,0F3h,0C0h
		db	 00h,0F3h,0C0h, 03h,0C3h,0C0h
		db	 00h, 3Ch,0F0h, 00h, 00h,0F0h
		db	12 dup (0)
		db	0C0h, 00h, 00h, 00h, 03h, 00h
		db	0FCh, 00h, 00h, 00h, 0Fh,0F0h
		db	 0Fh, 00h, 03h,0FCh, 3Fh,0CCh
		db	 03h,0C3h,0FFh,0FFh,0FFh,0FFh
		db	 00h,0FFh,0FFh,0FFh,0FFh,0FCh
		db	 00h,0FFh,0FFh,0FFh,0FFh,0F0h
		db	 00h, 0Fh,0FFh,0FFh,0FCh, 00h
		db	 00h, 03h,0FCh, 03h,0F0h, 00h
		db	 00h, 03h,0C0h, 03h,0C0h, 00h
		db	 00h, 00h,0F0h, 00h,0F0h
		db	17 dup (0)
		db	 03h, 00h, 3Ch, 00h, 00h, 00h
		db	 0Fh,0F0h,0CFh, 00h, 3Fh,0F0h
		db	 3Fh,0CCh, 03h, 0Fh,0FFh,0FFh
		db	0FFh,0FFh, 03h,0FFh,0FFh,0FFh
		db	0FFh,0FCh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 0Fh,0FFh, 0Fh
		db	0FCh, 00h, 00h, 3Ch,0FCh, 03h
		db	0FCh, 00h, 00h, 3Ch,0F0h, 03h
		db	0CCh, 00h, 00h, 0Ch, 30h, 00h
		db	0CCh
		db	11 dup (0)
		db	 0Ch, 00h, 3Fh, 00h, 00h, 00h
		db	 3Fh,0C0h,0F3h,0C0h, 00h, 00h
		db	0FFh, 30h, 00h,0F0h,0FFh,0C0h
		db	0FFh,0FCh, 00h,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 3Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 3Fh,0FFh,0FFh
		db	0FFh, 00h, 00h, 3Fh,0FFh,0CFh
		db	0FCh, 00h, 00h,0FCh,0FCh, 03h
		db	0CFh, 00h, 00h,0F0h, 3Ch, 03h
		db	0C3h, 00h, 00h, 30h, 0Ch, 03h
		db	 00h,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 00h
		db	0C0h, 00h, 0Ch, 00h, 00h, 03h
		db	0FCh, 00h, 3Ch, 00h, 00h, 0Fh
		db	0F3h, 00h,0F0h, 3Fh,0FCh, 0Fh
		db	0FFh,0C0h, 3Fh,0FFh,0FFh,0FFh
		db	0FFh, 00h, 0Fh,0FFh,0FFh,0FFh
		db	0FCh, 00h, 00h,0FFh,0FFh,0FFh
		db	0F0h, 00h, 03h,0CFh,0F3h,0FFh
		db	0C0h, 00h, 0Fh,0C3h,0C0h,0F3h
		db	0F0h, 00h, 0Fh, 03h,0C0h,0F0h
		db	0F0h, 00h, 3Ch, 00h,0F3h,0C0h
		db	 30h, 00h
		db	7 dup (0)
		db	 0Ch, 00h, 00h, 00h, 3Ch, 00h
		db	0FFh, 00h, 00h, 00h,0C3h, 03h
		db	 3Fh, 00h, 00h, 00h, 0Fh, 0Fh
		db	0FFh,0C0h, 3Fh,0C0h, 0Ch, 03h
		db	0FFh,0CFh,0FFh,0F0h,0FCh, 00h
		db	0FFh,0FFh,0FFh,0FFh,0F0h, 00h
		db	 3Fh,0FFh,0FFh,0FFh,0C0h, 03h
		db	0FCh,0FFh,0CFh,0F3h,0C0h, 0Fh
		db	 00h, 3Ch, 03h,0C0h,0F0h, 00h
		db	 00h, 3Ch, 03h,0C0h,0F0h, 00h
		db	 00h,0F0h, 0Fh, 00h,0C0h
		db	11 dup (0)
		db	 30h, 00h,0C0h, 00h, 00h, 00h
		db	 0Fh, 0Fh,0F0h, 00h, 00h, 00h
		db	 03h, 33h,0FCh, 3Fh,0F0h, 00h
		db	 0Fh,0FFh,0FFh,0FFh,0FFh,0C0h
		db	0FCh, 3Fh,0FFh,0FFh,0FFh,0FFh
		db	0F0h, 0Fh,0FFh,0FCh,0FFh,0FFh
		db	 00h, 00h,0FFh, 00h, 0Fh,0FCh
		db	 00h, 03h,0CFh, 00h, 03h,0CFh
		db	 00h, 03h,0C3h,0C0h, 03h,0CFh
		db	 00h, 0Fh, 00h, 00h, 0Fh, 3Ch
		db	 00h
		db	13 dup (0)
		db	0C0h, 00h, 00h, 00h, 03h, 0Fh
		db	0F0h, 00h, 00h, 00h, 3Fh, 33h
		db	0FCh, 3Fh,0C0h, 00h,0F0h,0FFh
		db	0FFh,0FFh,0FFh,0C3h,0C0h, 3Fh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 3Fh,0FFh,0FFh,0F0h, 00h, 00h
		db	 0Fh,0C0h, 3Fh,0C0h, 00h, 00h
		db	 03h,0C0h, 03h,0C0h, 00h, 00h
		db	 0Fh, 00h, 0Fh
		db	15 dup (0)
		db	0C0h, 00h, 00h, 00h, 00h, 0Fh
		db	0F0h, 00h, 00h, 00h, 3Ch, 33h
		db	0FCh, 0Fh,0FCh, 00h,0F3h,0FFh
		db	0FFh,0FFh,0FFh,0F0h,0C0h, 3Fh
		db	0FFh,0FFh,0FFh,0FFh,0C0h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 3Fh,0F0h,0FFh,0F0h, 00h, 00h
		db	 3Fh,0C0h, 3Fh, 3Ch, 00h, 00h
		db	 33h,0C0h, 0Fh, 3Ch, 00h, 00h
		db	 33h, 00h, 0Ch, 30h, 00h
		db	7 dup (0)
		db	 30h, 00h, 00h, 00h, 00h, 03h
		db	0FCh, 00h, 00h, 00h,0FCh, 0Ch
		db	0FFh, 00h, 00h, 03h,0CFh, 3Fh
		db	0FFh, 03h,0FFh, 0Fh, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh, 00h, 03h
		db	0FFh,0FFh,0FFh,0FCh, 00h, 00h
		db	0FFh,0FFh,0FFh,0FCh, 00h, 00h
		db	 3Fh,0F3h,0FFh,0FCh, 00h, 00h
		db	0F3h,0C0h, 3Fh, 3Fh, 00h, 00h
		db	0C3h,0C0h, 3Ch, 0Fh, 00h, 03h
		db	 00h,0C0h
		db	 30h, 0Ch
		db	8 dup (0)
		db	 03h, 00h, 00h, 00h, 0Fh, 00h
		db	 3Fh,0C0h, 00h, 00h, 30h, 00h
		db	0CFh,0F0h, 00h, 00h, 3Ch, 03h
		db	0FFh,0F0h, 3Fh,0FCh, 0Fh, 00h
		db	0FFh,0FFh,0FFh,0FFh,0FCh, 00h
		db	 3Fh,0FFh,0FFh,0FFh,0F0h, 00h
		db	 0Fh,0FFh,0FFh,0FFh, 00h, 00h
		db	 03h,0FFh,0CFh,0F3h,0C0h, 00h
		db	 0Fh,0CFh, 03h,0C3h,0F0h, 00h
		db	 0Fh, 0Fh, 03h,0C0h,0F0h, 00h
		db	 0Ch, 03h,0CFh, 00h
		db	3Ch
data_b_4A60	dw	4700h			; Data table (indexed access)
		db	 48h, 47h,0D8h, 47h, 90h, 47h
		db	 20h, 48h, 68h, 48h, 70h, 46h
		db	0B8h, 46h,0B0h, 48h,0F8h, 48h
		db	 88h, 49h, 40h, 49h,0D0h, 49h
		db	 18h, 4Ah,0E0h
		db	 45h, 28h, 46h
data_b_4A80	dw	0
data_b_4A82	db	0AAh
		db	0AAh, 83h,0C2h,0EBh,0EAh,0AAh
		db	0AAh,0AAh,0A8h, 00h, 02h,0FFh
		db	0FEh,0AAh,0AAh,0AAh,0A8h, 00h
		db	 33h,0CFh,0FEh,0AAh,0AAh,0A8h
		db	0AAh, 00h, 00h,0FFh,0FAh,0AEh
		db	0AAh,0A0h,0A8h, 00h, 0Bh,0FFh
		db	0FEh,0AFh,0AAh,0A2h,0A0h, 00h
		db	0AAh,0AFh,0FFh,0ABh,0AAh,0A0h
		db	0A0h, 00h, 2Ah,0BFh,0FFh,0AFh
		db	0AAh,0A8h, 00h, 00h, 2Ah,0BFh
		db	0FFh,0FEh,0AAh,0AAh, 00h, 02h
		db	 0Ah,0FBh,0FFh,0FAh,0AAh,0AAh
		db	 80h, 02h, 8Ah,0EBh,0FFh,0EAh
		db	0AAh,0AAh, 00h, 00h,0AAh,0AFh
		db	0FFh,0FAh,0AAh,0E8h, 00h, 00h
		db	0AAh,0AFh,0FFh,0FEh,0AFh,0FCh
		db	 2Ah,0A0h, 2Ah,0BFh,0AAh,0BEh
		db	0FFh, 0Fh,0F0h, 3Fh,0C0h, 3Fh
		db	0FCh,0FFh,0F0h, 3Fh,0FFh,0FFh
		db	0F0h, 3Fh,0FFh,0FFh,0F0h, 0Fh
		db	0FFh,0FFh,0C0h, 00h,0FFh,0FCh
		db	 00h, 00h, 0Fh,0C0h, 00h, 00h
		db	 03h, 00h, 00h, 00h, 02h,0AAh
		db	 80h, 00h, 2Ah,0A8h, 00h, 00h
		db	 2Ah,0AAh,0A8h, 02h,0AAh,0AAh
		db	 80h, 00h,0ABh,0FFh,0EAh, 0Ah
		db	0BFh,0FEh,0A0h, 00h,0AFh,0FFh
		db	0FAh, 0Ah,0FFh,0FFh,0A0h, 00h
		db	0AFh,0FFh,0FEh,0ABh,0FFh,0FFh
		db	0A0h, 00h,0AFh,0FFh,0FFh,0AFh
		db	0FFh,0FFh,0A0h, 00h, 2Bh,0FFh
		db	0FFh,0FFh,0FFh,0FEh, 80h, 00h
		db	 2Bh,0FFh,0FFh,0FFh,0FFh,0FEh
		db	 80h, 00h, 0Ah,0AFh,0FFh,0FFh
		db	0FFh,0AAh, 00h, 00h, 02h,0AAh
		db	0FFh,0FFh,0FAh,0A8h, 00h, 00h
		db	 00h, 0Ah,0AFh,0FFh,0AAh, 00h
		db	 00h, 00h, 00h, 00h,0ABh,0FEh
		db	0A0h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah,0FAh, 00h, 00h, 00h, 00h
		db	 00h, 00h, 02h,0A8h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h,0A0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 20h, 00h, 00h, 00h
data_b_4B8A	db	0
		db	 00h,0FFh,0FFh,0C0h, 00h, 00h
		db	 00h, 00h, 3Fh,0FFh,0F0h, 00h
		db	 00h, 00h, 3Fh,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0C0h, 00h, 03h,0FFh,0AAh
		db	0AAh,0BFh,0F0h, 00h, 00h,0FFh
		db	0EAh,0AAh,0AFh,0FCh, 00h, 03h
		db	0EAh,0AAh,0AAh,0AAh,0FCh, 00h
		db	 03h,0FAh,0AAh,0AAh,0AAh,0BCh
		db	 00h, 0Fh,0AAh,0AAh,0AAh,0AAh
		db	0AFh, 00h, 0Fh,0AAh,0AAh,0AAh
		db	0AAh,0AFh, 00h, 0Fh,0AAh,0AAh
		db	0AAh,0AAh,0AFh, 00h, 0Fh,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 00h, 3Eh
		db	0AAh,0AAh,0AAh,0AAh,0ABh,0C0h
		db	 3Eh,0AAh,0AAh,0AAh,0AAh,0ABh
		db	0C0h, 3Eh,0AAh,0AAh,0AAh,0AAh
		db	0ABh,0C0h, 3Eh,0AAh,0AAh,0AAh
		db	0AAh,0ABh,0C0h, 3Eh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0F0h,0FAh,0AAh
		db	0AAh,0AAh,0AAh,0ABh,0C0h, 3Eh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0BCh
		db	0FAh,0AAh,0AAh,0AAh,0AAh,0ABh
		db	0C0h, 3Eh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AFh,0EAh,0AAh,0AAh,0AAh
		db	0AAh,0ABh,0C0h, 3Eh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0ABh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AFh, 00h, 0Fh
		db	11 dup (0AAh)
		db	0AFh, 00h, 0Fh
		db	11 dup (0AAh)
		db	0BCh, 00h, 03h,0FAh
		db	10 dup (0AAh)
		db	0BCh, 00h, 00h,0FFh,0EAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0ABh,0F0h, 00h, 00h, 0Fh
		db	0FFh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0BFh,0C0h, 00h
		db	 00h, 00h, 3Fh,0FEh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AFh,0FCh
		db	 00h, 00h, 00h, 00h, 00h,0FFh
		db	0EAh,0AAh,0AAh,0AAh,0AAh,0ABh
		db	0FFh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 03h,0FEh,0AAh,0AAh,0AAh
		db	0AAh,0BFh,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 3Fh,0EAh
		db	0AAh,0AAh,0ABh,0FCh
		db	8 dup (0)
		db	 03h,0FAh,0AAh,0AAh,0AFh,0C0h
		db	 00h, 00h
		db	7 dup (0)
		db	 3Eh,0AAh,0AAh,0BCh, 00h, 00h
		db	8 dup (0)
		db	 0Fh,0AAh,0AAh,0F0h
		db	10 dup (0)
		db	 03h,0EAh,0ABh,0C0h, 00h, 00h
		db	9 dup (0)
		db	0FAh,0AFh
		db	12 dup (0)
		db	 3Eh,0BCh, 00h, 00h
		db	10 dup (0)
		db	 0Fh,0F0h
		db	12 dup (0)
		db	 03h,0F0h
		db	12 dup (0)
		db	 03h,0C0h
		db	13 dup (0)
		db	0C0h, 00h, 00h
		db	11 dup (0)
		db	0C0h, 00h, 00h
		db	0, 0, 0, 0
data_b_4D4A	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_b_4D5A	dw	0			; Data table (indexed access)
		db	14 dup (0)
data_b_4D6A	dw	0
data_b_4D6C	dw	0
data_b_4D6E	db	0
data_b_4D6F	dw	0			; Data table (indexed access)
		db	 01h, 00h, 01h, 00h, 01h, 00h
		db	 00h, 00h,0FFh, 00h,0FFh, 00h
		db	0FFh, 00h
data_b_4D7F	dw	0FFh			; Data table (indexed access)
		db	0FFh, 00h, 00h, 00h, 01h, 00h
		db	 01h, 00h, 01h, 00h, 00h, 00h
		db	0FFh, 00h, 00h, 00h
data_b_4D91	db	0
data_b_4D92	dw	4AEAh			; Data table (indexed access)
		db	 0Ah, 4Bh, 8Ah, 4Bh
data_b_4D98	dw	98h			; Data table (indexed access)
		db	 90h, 00h, 84h, 00h
data_b_4D9E	dw	60h			; Data table (indexed access)
		db	 5Ch, 00h, 54h, 00h
data_b_4DA4	dw	10h			; Data table (indexed access)
		db	 20h, 00h, 38h, 00h
data_b_4DAA	dw	0Ah			; Data table (indexed access)
		db	 14h, 00h, 23h, 00h
data_b_4DB0	dw	12Fh			; Data table (indexed access)
		db	 1Fh, 01h, 07h, 01h
data_b_4DB6	dw	0BFh			; Data table (indexed access)
		db	0B7h, 00h,0A7h, 00h
data_b_4DBC	dw	802h			; Data table (indexed access)
		db	 04h, 10h, 07h, 20h
data_b_4DC2	dw	1			; Data table (indexed access)
		db	2, 0, 3
		db	0
data_b_4DC8	dw	0
data_b_4DCA	dw	0
data_b_4DCC	dw	0
data_b_4DCE	dw	0
data_b_4DD0	dw	0
data_b_4DD2	dw	0
data_b_4DD4	dw	0
data_b_4DD6	dw	0
data_b_4DD8	dw	0
		db	16 dup (0)
		db	0F0h, 00h, 00h, 0Fh, 00h, 00h
		db	 00h, 00h,0FFh, 0Fh,0F0h,0FFh
		db	 00h, 00h, 00h, 00h,0FFh,0FFh
		db	0FFh,0FFh, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 03h,0F0h, 03h,0F0h, 03h
		db	0C0h, 00h, 00h, 0Fh,0FCh,0AFh
		db	0FCh,0AFh,0F0h, 00h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0FFh,0F0h, 00h
		db	 00h, 0Fh,0FFh,0FFh, 0Fh,0FFh
		db	0F0h, 00h, 00h, 03h,0FFh, 0Fh
		db	0FFh, 0Fh,0C0h, 00h, 00h, 00h
		db	0FFh,0F0h, 00h,0FFh, 00h, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 0Fh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 00h,0A0h, 0Ah, 00h, 00h, 00h
		db	 00h, 00h, 0Ah,0A5h, 56h,0A0h
		db	 00h, 00h, 00h, 02h,0AAh, 55h
		db	 55h,0AAh, 80h, 00h, 0Dh,0AAh
		db	0AAh, 5Ah, 69h,0AAh,0AAh, 70h
		db	 3Dh,0AAh,0A8h, 6Ah,0AAh, 2Ah
		db	0AAh, 7Ch, 30h, 0Ah, 00h, 6Ah
		db	0AAh, 00h,0A0h, 0Ch, 00h, 00h
		db	 00h, 5Ah,0A9h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 56h,0A5h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 55h
		db	 95h, 40h, 00h, 00h, 00h, 00h
		db	 01h, 55h, 55h, 40h, 00h, 00h
		db	 00h, 00h, 0Ah, 95h, 56h,0A0h
		db	 00h, 00h, 00h, 00h, 0Ah,0AAh
		db	0AAh,0A0h, 00h, 00h, 00h, 00h
		db	 2Ah,0AAh,0AAh,0A8h, 00h, 00h
		db	 00h, 00h, 2Ah,0AAh,0AAh,0A8h
		db	 00h, 00h, 00h, 00h, 0Ah,0AAh
		db	0AAh,0FCh, 00h, 00h, 00h, 00h
		db	 03h,0EAh,0ABh,0FFh,0C0h, 00h
		db	 00h, 00h, 03h,0F0h, 00h, 3Fh
		db	0C0h, 00h, 00h, 00h, 0Fh,0C0h
		db	 00h, 0Fh,0C0h, 00h, 00h, 00h
		db	 0Fh,0C0h, 00h,0FFh, 00h, 00h
		db	 00h, 00h, 03h,0F0h, 03h,0F0h
		db	 00h, 00h, 00h, 00h, 00h,0FCh
		db	 0Fh, 00h, 00h, 00h, 00h, 00h
		db	 00h,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 00h,0F0h, 00h, 00h, 0Fh
		db	 00h, 00h, 00h, 00h,0FFh, 0Fh
		db	0F0h,0FFh, 00h, 00h, 00h, 00h
		db	0FFh,0FFh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h,0FFh,0FFh,0FFh,0FFh
		db	 00h, 00h, 00h, 03h,0F0h, 03h
		db	0F0h, 03h,0C0h, 00h, 00h, 0Fh
		db	0FEh, 8Fh,0FEh, 8Fh,0F0h, 00h
		db	 00h, 0Fh,0FFh,0FFh, 0Fh,0FFh
		db	0F0h, 00h, 00h, 0Fh,0FFh,0FFh
		db	0FFh,0FFh,0F0h, 00h, 00h, 03h
		db	0FFh, 0Ch, 0Ch, 3Fh,0C0h, 00h
		db	 00h, 00h,0FFh,0C0h, 00h,0FFh
		db	 00h, 00h, 00h, 00h, 0Fh,0FCh
		db	 0Fh,0F0h, 00h, 00h, 00h, 00h
		db	 00h, 0Fh,0F0h, 00h, 00h, 00h
		db	 00h, 02h,0AAh, 55h, 55h,0AAh
		db	 80h, 00h, 0Dh,0AAh,0AAh, 5Ah
		db	 69h,0AAh,0AAh, 70h, 3Dh,0AAh
		db	0A8h, 6Ah,0AAh, 2Ah,0AAh, 7Ch
		db	 30h, 0Ah, 00h, 6Ah,0AAh, 00h
		db	0A0h, 0Ch, 00h, 00h, 00h, 5Ah
		db	0A9h, 00h, 00h, 00h, 00h, 00h
		db	 01h, 56h,0A5h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 55h, 95h, 40h
		db	 00h, 00h, 00h, 00h, 01h, 55h
		db	 55h, 40h, 00h, 00h, 00h, 00h
		db	 0Ah, 95h, 56h,0A0h, 00h, 00h
		db	 00h, 00h, 0Ah,0AAh,0AAh,0A0h
		db	 3Ch, 00h, 00h, 00h, 2Ah,0AAh
		db	0AAh,0A8h,0FCh, 00h, 00h, 00h
		db	 2Ah,0AAh,0AAh,0BFh,0F0h, 00h
		db	 00h, 00h, 0Ah,0AAh,0ABh,0FFh
		db	0C0h, 00h, 00h, 00h, 00h,0EAh
		db	0AFh,0FCh, 00h, 00h, 00h, 00h
		db	 00h,0FCh, 03h,0F0h, 00h, 00h
		db	 00h, 00h, 03h,0FCh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 03h,0F0h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Fh,0C0h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Fh,0C0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Fh
		db	29 dup (0)
data_b_5010	dw	0
data_b_5012	dw	4DE0h			; Data table (indexed access)
		db	0F8h, 4Eh
data_b_5016	dw	0
		db	 38h, 0Dh, 00h, 00h, 40h, 0Dh
		db	 00h, 00h, 48h, 0Dh, 00h, 00h
		db	 50h, 0Dh, 00h, 00h, 00h, 00h
		db	0C0h, 05h, 00h, 00h,0C8h, 05h
		db	 00h, 00h, 38h, 0Dh, 00h, 00h
		db	 40h, 0Dh, 00h, 00h, 48h, 0Dh
		db	 00h, 00h, 50h, 0Dh, 00h, 00h
		db	0C0h, 14h, 00h, 00h,0C8h, 14h
		db	 00h, 00h, 00h, 00h,0B0h, 01h
		db	 00h, 00h,0B8h, 01h, 00h, 00h
		db	 40h, 07h, 00h, 00h, 48h, 07h
		db	 00h, 00h, 60h, 07h, 00h, 00h
		db	 68h, 07h, 00h, 00h,0D8h, 0Ch
		db	 00h, 00h,0E0h, 0Ch, 00h, 00h
		db	 08h, 0Dh, 00h, 00h, 10h, 0Dh
		db	 00h, 00h, 80h, 12h, 00h, 00h
		db	 88h, 12h, 00h, 00h,0A0h, 12h
		db	 00h, 00h,0A8h, 12h, 00h, 00h
		db	 30h, 18h, 00h, 00h, 38h, 18h
		db	 00h, 00h, 00h, 00h,0B0h, 01h
		db	 00h, 00h,0B8h, 01h, 00h, 00h
		db	 40h, 07h, 00h, 00h, 48h, 07h
		db	 00h, 00h, 60h, 07h, 00h, 00h
		db	 68h, 07h, 00h, 00h,0D8h, 0Ch
		db	 00h, 00h,0E0h, 0Ch, 00h, 00h
		db	 08h, 0Dh, 00h, 00h, 10h, 0Dh
		db	 00h, 00h, 80h, 12h, 00h, 00h
		db	 88h, 12h, 00h, 00h,0A0h, 12h
		db	 00h, 00h,0A8h, 12h, 00h, 00h
		db	 30h, 18h, 00h, 00h, 38h, 18h
		db	 00h, 00h, 50h, 07h, 02h, 00h
		db	 58h, 07h, 02h, 00h,0E8h, 0Ch
		db	 02h, 00h,0F0h, 0Ch, 02h, 00h
		db	0F8h, 0Ch, 02h, 00h, 00h, 0Dh
		db	 02h, 00h, 90h, 12h, 02h, 00h
		db	 98h, 12h, 02h, 00h, 00h, 00h
		db	 90h, 01h, 02h, 00h, 98h, 01h
		db	 02h, 00h,0A0h, 01h, 02h, 00h
		db	0A8h, 01h, 02h, 00h,0D8h, 01h
		db	 02h, 00h,0D0h, 01h, 02h, 00h
		db	0C8h, 01h, 02h, 00h,0C0h, 01h
		db	 02h, 00h, 30h, 07h, 02h, 00h
		db	 38h, 07h, 02h, 00h, 78h, 07h
		db	 02h, 00h, 70h, 07h, 02h, 00h
		db	0D0h, 0Ch, 02h, 00h, 18h, 0Dh
		db	 00h, 00h, 70h, 12h, 02h, 00h
		db	 78h, 12h, 02h, 00h,0B8h, 12h
		db	 02h, 00h,0B0h, 12h, 02h, 00h
		db	 10h, 18h, 02h, 00h
loc_b_513C:
		sbb	[bx+si],bl
		add	al,[bx+si]
loc_b_5140:
		and	[bx+si],bl
		add	al,[bx+si]
		sub	[bx+si],bl
		add	al,[bx+si]
		pop	ax
		sbb	[bp+si],al
		add	[bx+si+18h],dl
		add	al,[bx+si]
		dec	ax
		sbb	[bp+si],al
		add	[bx+si+18h],al
		add	al,[bx+si]
		add	[bx+si],al
		nop
		add	[bp+si],ax
		add	data_b_0201[bx+si],bl
		add	data_b_0201[bx+si],ah
		add	data_b_0201[bx+si],ch
;*		add	al,bl
		db	 00h,0D8h		;  Fixup - byte match
		add	[bp+si],ax
;*		add	al,dl
		db	 00h,0D0h		;  Fixup - byte match
		add	[bp+si],ax
;*		add	al,cl
		db	 00h,0C8h		;  Fixup - byte match
		add	[bp+si],ax
;*		add	al,al
		db	 00h,0C0h		;  Fixup - byte match
		add	[bp+si],ax
		add	[bx+si],dh
		pop	es
		add	al,[bx+si]
		cmp	[bx],al
		add	al,[bx+si]
;*		js	loc_b_518B		;*Jump if sign=1
		db	 78h, 07h		;  Fixup - byte match
		add	al,[bx+si]
;*		jo	loc_b_518F		;*Jump if overflow=1
		db	 70h, 07h		;  Fixup - byte match
		add	al,[bx+si]
		ror	byte ptr [si],1		; Rotate
		add	al,[bx+si]
		sbb	[di],cl
		add	[bx+si],al
;*		jo	loc_b_51A6		;*Jump if overflow=1
		db	 70h, 12h		;  Fixup - byte match
		add	al,[bx+si]
;*		js	loc_b_51AA		;*Jump if sign=1
		db	 78h, 12h		;  Fixup - byte match
		add	al,[bx+si]
		mov	ax,212h
		add	data_b_0212[bx+si],dh
		add	[bx+si],dl
		sbb	[bp+si],al
		add	[bx+si],bl
		sbb	[bp+si],al
		add	[bx+si],ah
		sbb	[bp+si],al
		add	[bx+si],ch
		sbb	[bp+si],al
		add	[bx+si+18h],bl
		add	al,[bx+si]
		push	ax
		sbb	[bp+si],al
		add	[bx+si+18h],cl
		add	al,[bx+si]
		inc	ax
		sbb	[bp+si],al
		add	[bx+si+7],dl
		add	al,[bx+si]
		pop	ax
		pop	es
		add	al,[bx+si]
;*		call	sub_b_53D9		;*
		db	0E8h, 0Ch, 02h		;  Fixup - byte match
;*		add	al,dh
		db	 00h,0F0h		;  Fixup - byte match
		or	al,2
;*		add	al,bh
		db	 00h,0F8h		;  Fixup - byte match
		or	al,2
		add	[bx+si],al
		or	ax,2
		nop
		adc	al,[bp+si]
		add	data_b_0212[bx+si],bl
		add	[bx+si],al
		add	data_b_0201[bx+si],dl
		add	data_b_0201[bx+si],bl
		add	data_b_0201[bx+si],ah
		add	data_b_0201[bx+si],ch
;*		add	al,bl
		db	 00h,0D8h		;  Fixup - byte match
		add	[bp+si],ax
;*		add	al,dl
		db	 00h,0D0h		;  Fixup - byte match
		add	[bp+si],ax
;*		add	al,cl
		db	 00h,0C8h		;  Fixup - byte match
		add	[bp+si],ax
;*		add	al,al
		db	 00h,0C0h		;  Fixup - byte match
		add	[bp+si],ax
		add	[bx+si],dh
		pop	es
		add	al,[bx+si]
		cmp	[bx],al
		add	al,[bx+si]
;*		js	loc_b_5215		;*Jump if sign=1
		db	 78h, 07h		;  Fixup - byte match
		add	al,[bx+si]
;*		jo	loc_b_5219		;*Jump if overflow=1
		db	 70h, 07h		;  Fixup - byte match
		add	al,[bx+si]
		ror	byte ptr [si],1		; Rotate
		add	al,[bx+si]
		sbb	[di],cl
		add	[bx+si],al
;*		jo	loc_b_5230		;*Jump if overflow=1
		db	 70h, 12h		;  Fixup - byte match
		add	al,[bx+si]
;*		js	loc_b_5234		;*Jump if sign=1
		db	 78h, 12h		;  Fixup - byte match
		add	al,[bx+si]
		mov	ax,212h
		add	data_b_0212[bx+si],dh
		add	[bx+si],dl
		sbb	[bp+si],al
		add	[bx+si],bl
		sbb	[bp+si],al
		add	[bx+si],ah
		sbb	[bp+si],al
		add	[bx+si],ch
		sbb	[bp+si],al
		add	[bx+si+18h],bl
		add	al,[bx+si]
		push	ax
		sbb	[bp+si],al
		add	[bx+si+18h],cl
		add	al,[bx+si]
		inc	ax
		sbb	[bp+si],al
		add	byte ptr data_b_0001[bx+si],dh
		add	byte ptr data_b_0001[bx+si],bh
		add	[bx+si+7],al
		add	[bx+si],al
		dec	ax
		pop	es
		add	[bx+si],al
		pusha				; Save all regs
		pop	es
		add	[bx+si],al
;*		push	7
		db	 68h, 07h, 00h		;  Fixup - byte match
;*		add	al,bl
		db	 00h,0D8h		;  Fixup - byte match
		or	al,0
;*		add	al,ah
		db	 00h,0E0h		;  Fixup - byte match
		or	al,0
		add	[bx+si],cl
		or	ax,0
		adc	[di],cl
		add	[bx+si],al
		adc	byte ptr [bp+si],0
		add	byte ptr data_b_0012[bx+si],cl
		add	byte ptr data_b_0012[bx+si],ah
		add	byte ptr data_b_0012[bx+si],ch
		add	[bx+si],dh
		sbb	[bx+si],al
		add	[bx+si],bh
		sbb	[bx+si],al
		add	[bx+si+7],dl
		add	al,[bx+si]
		pop	ax
		pop	es
		add	al,[bx+si]
		call	sub_b_54A3
;*		add	al,dh
		db	 00h,0F0h		;  Fixup - byte match
		or	al,2
;*		add	al,bh
		db	 00h,0F8h		;  Fixup - byte match
		or	al,2
		add	[bx+si],al
		or	ax,2
		nop
		adc	al,[bp+si]
		add	data_b_0212[bx+si],bl
		add	[bx+si],al
		add	[bx+si],bl
		push	ax
		sbb	[bx+si+18h],dl
		push	ax
		sub	dl,[bx+si+4Ch]
		push	ax
		mov	ss,[bx+si-10h]
		push	ax
		pop	dx
		push	cx
		in	al,51h			; port 51h ??i/o non-standard
		db	0, 0
data_b_52C2	dw	0
data_b_52C4	dw	0
data_b_52C6	dw	0
data_b_52C8	dw	0			; required speaker tone
data_b_52CA	dw	391h			; Data table (indexed access)
		db	 91h, 03h,0D5h, 02h,0D5h, 02h
		db	 62h, 02h, 62h, 02h, 91h, 03h
		db	 2Eh, 03h, 91h, 03h, 2Eh, 03h
		db	 00h, 03h, 00h, 03h, 62h, 02h
		db	 62h, 02h, 01h, 02h, 01h, 02h
		db	 00h, 03h,0ACh, 02h, 00h, 03h
		db	0ACh, 02h, 62h, 02h, 62h, 02h
		db	0E4h, 01h,0E4h, 01h, 97h, 01h
		db	 97h, 01h,0AFh, 01h, 97h, 01h
		db	0AFh, 01h, 97h, 01h,0E4h, 01h
		db	0E4h, 01h,0C9h, 01h,0C9h, 01h
		db	 62h, 02h,0D5h, 02h, 91h, 03h
		db	 91h, 03h, 91h, 03h, 91h, 03h
		db	 00h
		db	0, 0, 0, 0, 0
data_b_5320	dw	0
data_b_5322	dw	0
data_b_5324	dw	0			; Data table (indexed access)
		db	 80h, 01h, 97h, 01h,0AFh, 01h
		db	0C9h, 01h,0E4h, 01h, 01h, 02h
		db	 1Fh, 02h, 3Fh, 02h, 62h, 02h
		db	 86h, 02h,0ACh, 02h,0D5h, 02h
		db	 00h, 03h, 2Eh, 03h, 5Eh, 03h
		db	 91h, 03h,0C8h, 03h, 01h, 04h
		db	 3Eh, 04h, 7Fh, 04h,0C3h, 04h
		db	 0Ch, 05h, 58h, 05h,0AAh, 05h
		db	 00h, 06h, 5Bh, 06h,0BCh, 06h
		db	 23h, 07h, 8Fh, 07h, 02h, 08h
		db	 7Ch, 08h,0FDh, 08h, 86h, 09h
		db	 17h, 0Ah,0B1h, 0Ah, 54h, 0Bh
		db	 00h, 0Ch,0B7h, 0Ch, 79h, 0Dh
		db	 46h, 0Eh, 1Fh, 0Fh, 05h, 10h
		db	0F9h, 10h,0FBh, 11h, 0Dh, 13h
		db	 2Fh, 14h, 62h, 15h,0A8h, 16h
		db	 01h, 18h, 6Eh, 19h,0F1h, 1Ah
data_b_538C	db	58h			; Data table (indexed access)
		db	 00h, 00h, 00h, 00h, 00h, 58h
		db	 00h, 00h, 00h, 00h, 00h, 5Ah
		db	 00h, 00h, 00h, 00h, 00h, 5Ah
		db	 00h, 00h, 00h, 00h, 00h, 5Eh
		db	 00h, 00h, 00h, 5Ah, 00h, 5Eh
		db	 00h, 00h, 00h, 62h, 00h, 00h
		db	 00h, 00h, 00h, 62h, 00h, 62h
		db	 00h, 5Eh, 00h, 5Ah, 00h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 58h
		db	 00h
		db	10 dup (0)
		db	5Ah
		db	11 dup (0)
		db	 5Eh, 00h, 00h, 00h, 62h, 00h
		db	12 dup (0)
		db	 40h, 00h, 00h, 00h, 00h, 00h
		db	 40h, 00h, 00h, 00h, 42h, 40h
		db	 42h, 00h, 00h, 00h, 00h, 00h
		db	 42h, 00h, 00h, 00h, 46h, 42h
		db	 46h, 00h, 00h, 00h, 42h, 00h
		db	 46h, 00h, 00h, 00h, 4Ah, 00h
		db	 00h, 00h, 00h, 00h, 4Ah, 00h
		db	 4Ah, 00h, 46h, 00h
		db	42h
		db	7 dup (0)
		db	40h
		db	9 dup (0)
		db	 42h, 00h, 42h, 00h
		db	8 dup (0)
		db	 4Ch, 4Ah, 46h, 00h, 00h, 00h
		db	 4Ah, 00h
		db	8 dup (0)
		db	 30h, 2Eh, 2Ch, 2Ah, 28h, 00h
		db	 00h, 00h, 00h, 00h, 28h, 00h
		db	 00h, 00h, 2Ah, 28h, 2Ah, 00h
		db	 00h, 00h, 2Ah, 28h, 2Ah, 00h
		db	 00h, 00h, 2Eh, 2Ah, 2Eh, 00h
		db	 00h, 00h, 2Ah, 00h, 2Eh, 2Ah
		db	 2Eh, 00h, 32h, 00h, 00h, 00h
		db	 00h, 00h, 32h, 00h, 32h, 00h
		db	 2Eh, 00h
		db	2Ah
		db	7 dup (0)
		db	 28h, 2Ah, 28h, 2Ah, 28h, 00h
		db	 00h, 00h, 00h, 00h, 2Ah, 00h
		db	2Ah
		db	9 dup (0)
		db	 34h, 32h, 2Eh, 00h, 00h, 00h
		db	 32h, 00h, 00h, 00h, 00h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_b_54A3	proc	near
		add	[bx+si],al
		xor	dh,[si]
		db	 36h, 38h, 3Ah, 3Ch, 3Eh, 40h
		db	 00h, 00h, 00h, 00h, 00h, 28h
		db	 00h, 00h, 00h, 42h, 40h, 42h
		db	 00h, 00h, 00h, 00h, 00h, 2Ah
		db	 00h, 00h, 00h, 46h, 42h, 46h
		db	 00h, 00h, 00h, 42h, 00h, 00h
		db	 00h, 46h, 42h, 46h, 00h, 4Ah
		db	 00h, 00h, 00h, 00h, 00h, 1Ah
		db	9 dup (0)
		db	 40h, 00h, 40h, 00h
		db	8 dup (0)
		db	 2Ah, 00h
		db	'*(*(*(&$'
		db	'" '
		db	 1Eh, 04h, 16h, 00h, 00h, 00h
		db	 1Ah
		db	13 dup (0)
		db	 40h, 00h, 32h, 00h, 00h, 00h
		db	 40h, 00h, 38h, 00h, 00h, 00h
		db	 42h, 40h, 42h, 00h, 3Ch, 00h
		db	 42h, 00h, 00h, 00h, 00h, 00h
		db	 46h, 40h, 46h, 40h, 42h, 00h
		db	 46h, 00h, 00h, 00h, 4Ah, 42h
		db	 4Ah, 42h, 00h, 00h, 4Ah, 00h
		db	 4Ah, 00h, 46h, 00h, 42h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 40h, 00h, 32h, 00h, 40h, 00h
		db	 32h, 00h, 00h, 00h, 00h, 00h
		db	 2Ah, 42h, 2Ah, 42h, 2Ah, 42h
		db	 28h, 00h
data_b_5556	db	0
		db	 00h, 00h, 00h, 46h, 00h, 00h
		db	 00h
		db	'J*J*J*J*J*J*J*@'
		db	 00h, 1Ah, 00h, 00h, 00h, 40h
		db	 00h, 20h, 00h, 00h, 00h, 42h
		db	 40h, 42h, 00h, 00h, 00h, 24h
		db	 00h, 42h, 00h, 00h, 00h
		db	'F(F(B$'
		db	'B$'
		db	'F(F(J*J*J*JB<BJB<2<B<2@'
		db	 00h, 1Ah, 00h, 00h, 00h, 1Ah
		db	 00h, 1Ah, 12h, 1Ah, 12h, 42h
		db	 00h, 00h, 00h, 00h, 00h, 42h
		db	 00h, 00h, 00h, 00h, 00h, 46h
		db	 00h, 00h, 00h, 00h, 00h, 0Eh
		db	 00h, 46h, 00h
		db	'J', 0Ch, 'J', 0Ch, 'J', 0Ch, 'J', 0Ch
		db	'H', 0Ah, 'F', 8, 'D'
		db	 06h, 58h, 20h, 00h, 00h, 1Ah
		db	 00h, 58h, 20h, 00h, 00h, 1Ah
		db	 00h, 5Ah, 24h, 00h, 00h, 1Ah
		db	 00h, 5Ah, 24h, 00h, 00h, 1Ah
		db	 00h, 5Eh, 28h, 28h, 00h, 5Ah
		db	 1Ah, 5Eh, 28h, 24h, 00h, 62h
		db	 20h, 24h, 00h, 14h, 00h, 12h
		db	 00h, 1Ah, 00h, 14h, 00h
data_b_5600	db	12h
		db	 00h, 1Ah, 00h, 00h, 00h, 02h
		db	 00h, 58h, 08h, 00h, 00h, 1Ah
		db	 00h, 1Ah, 00h, 00h, 00h, 02h
		db	 00h, 5Ah, 0Ch, 00h, 00h, 1Ah
		db	 00h, 02h, 00h, 04h, 00h, 08h
		db	 00h, 5Eh, 04h, 08h, 00h, 62h
		db	 12h, 42h, 00h, 44h, 00h, 42h
		db	 00h, 44h, 00h, 4Ah, 00h, 58h
		db	 14h, 16h, 00h, 1Ah, 00h, 16h
		db	 00h, 14h, 00h, 16h, 00h, 1Ah
		db	 00h, 1Eh, 00h, 24h, 00h, 26h
		db	 00h, 28h, 00h, 2Ch, 00h, 28h
		db	 00h, 5Eh, 24h, 22h, 00h, 5Ah
		db	 20h, 1Ah, 00h, 5Eh, 16h, 12h
		db	 00h, 62h, 00h, 4Ah, 00h, 4Ah
		db	 00h, 4Ah, 00h, 4Ah, 00h, 58h
		db	 0Ah, 08h, 00h, 02h, 00h, 58h
		db	 0Ah, 08h, 00h, 02h, 00h, 5Ah
		db	 0Ch, 02h, 00h, 06h, 00h, 0Ch
		db	 00h, 0Eh, 00h, 1Ah, 00h, 14h
		db	 00h, 16h, 00h, 1Ah, 00h, 5Eh
		db	 1Eh, 26h, 00h, 28h, 00h
		db	'b*bJ\DbJ\DZBX@P8J28 2'
		db	 1Ah, 2Ah, 12h
		db	'ZBT<L4<$'
		db	'4'
		db	 1Ch, 2Eh, 16h
		db	'^FV>P8bZTNJB<62*$'
		db	 1Eh, 1Ah, 12h, 0Ch, 06h, 02h
		db	 04h, 02h, 04h, 02h, 04h, 02h
		db	 04h, 02h, 04h, 02h, 04h, 02h
		db	 00h
		db	11 dup (0)
		db	 62h, 00h, 66h
data_b_56DA	dw	34Eh
		db	 00h, 00h, 00h, 00h,0AAh,0AAh
		db	0AAh,0A8h, 2Ah,0AAh,0AAh,0AAh
		db	0AAh,0A3h,0C0h, 2Ah,0AAh,0AAh
		db	0AAh,0A3h,0FFh,0CAh,0AAh,0AAh
		db	 82h, 83h,0FCh, 2Ah,0AAh,0AAh
		db	 3Ch, 3Ch, 02h,0AAh,0AAh,0A8h
		db	0F0h, 3Ch,0AAh,0AAh,0AAh,0AAh
		db	 3Fh,0C2h, 82h,0AAh,0AAh, 82h
		db	 83h,0FCh, 32h,0AAh,0AAh, 3Ch
		db	 3Ch, 0Fh,0CAh,0AAh,0AAh, 83h
		db	0FFh,0C0h, 2Ah,0AAh,0AAh, 3Fh
		db	0C0h, 3Ch,0AAh,0AAh,0A8h, 03h
		db	0FCh, 82h,0AAh,0AAh, 83h,0FFh
		db	 02h,0AAh,0AAh,0AAh, 3Ch, 3Ch
		db	0AAh,0AAh,0AAh,0AAh, 3Ch,0FCh
		db	0AAh,0AAh,0AAh,0AAh, 3Fh,0FCh
		db	0AAh,0AAh,0AAh,0AAh, 3Fh,0C2h
		db	0AAh,0AAh,0AAh,0AAh, 80h, 2Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h, 2Ah,0AAh, 82h,0AAh
		db	0AAh, 83h,0CAh,0AAh, 3Ch, 00h
		db	 00h, 3Fh,0CAh,0AAh, 3Fh,0FFh
		db	0FFh,0FCh, 2Ah,0AAh, 83h,0FFh
		db	0FFh,0FFh,0CAh,0AAh, 3Fh,0C0h
		db	 00h, 03h,0CAh,0AAh, 3Ch, 2Ah
		db	0AAh,0A8h, 2Ah,0AAh, 82h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A8h,0AAh
		db	0AAh,0AAh,0A1h, 2Ah,0AAh,0AAh
		db	 85h, 0Ah,0AAh,0AAh, 15h, 50h
		db	0AAh,0AAh, 81h, 55h, 0Ah,0AAh
		db	0A1h, 5Dh, 52h,0AAh,0A8h, 7Fh
		db	 54h,0AAh,0A8h, 7Fh,0D5h, 2Ah
		db	0A8h, 6Fh,0E9h, 6Ah,0AAh,0AFh
		db	0AAh,0AAh,0AAh,0ABh,0EAh,0AAh
		db	0AAh,0BDh, 7Eh,0AAh,0AAh,0D4h
		db	 57h,0AAh,0ABh, 51h, 05h,0EAh
		db	0ADh, 44h, 5Fh, 7Ah,0ABh, 55h
		db	0F0h,0FEh, 6Ah,0D7h, 00h, 0Eh
		db	0AAh,0DCh, 00h, 03h,0AAh,0BCh
		db	 00h, 0Eh,0AAh,0AAh,0A5h, 6Ah
		db	0AAh,0A5h,0A9h, 5Ah,0AAh, 56h
		db	 96h,0AAh, 96h,0AAh,0A5h,0AAh
		db	0AAh,0AAh,0AAh,0A6h,0A9h,0AAh
		db	0AAh,0AAh,0AAh,0A8h, 02h,0AAh
		db	 80h, 03h, 54h,0AAh, 3Fh,0FFh
		db	0F5h, 2Ah, 0Fh,0FCh,0FDh, 4Ah
		db	 8Fh,0F3h,0FFh, 52h, 0Fh,0F3h
		db	0F3h, 52h, 3Fh,0F3h,0CFh, 52h
		db	 80h,0FCh,0CFh, 52h,0AAh, 03h
		db	0CFh, 52h,0AAh,0A8h,0F3h, 52h
		db	0AAh,0AAh, 3Dh, 4Ah,0AAh,0AAh
		db	 80h, 2Ah,0A0h, 82h,0AAh,0AAh
		db	 8Ch, 0Ch,0AAh,0AAh, 8Fh,0FCh
		db	0AAh,0AAh, 8Fh,0FCh,0AAh,0AAh
		db	 8Fh,0FFh, 2Ah,0AAh, 8Fh,0FFh
		db	 2Ah,0AAh, 8Fh, 03h, 2Ah,0AAh
		db	 3Ch,0FCh,0CAh,0AAh, 1Fh,0FFh
		db	0F2h,0AAh, 1Fh,0F0h, 3Ch,0AAh
		db	 17h,0CFh,0CCh,0AAh, 85h,0FFh
		db	0F4h,0AAh,0A1h, 55h, 54h,0AAh
		db	0A8h, 55h, 52h,0AAh,0AAh, 00h
		db	 0Ah,0AAh
data_b_584C	dw	56E0h			; Data table (indexed access)
		db	 4Ch, 57h, 7Ch, 57h,0A4h, 57h
		db	0E0h, 57h, 10h
		db	58h
data_b_5858	dw	1203h			; Data table (indexed access)
		db	 03h, 08h, 02h, 0Ah, 02h, 0Fh
		db	 02h, 0Ch, 02h, 0Fh, 4Eh, 1Ch
		db	0A6h, 1Ch,0FFh,0FFh, 0Ch, 1Ch
		db	 40h, 1Ch, 52h, 1Ch,0FFh,0FFh
		db	 3Ah, 1Ch, 90h, 1Ch, 02h, 1Ch
		db	0BAh, 1Ch,0FFh,0FFh,0D0h, 1Bh
		db	 80h, 1Ch, 40h, 1Ch, 98h, 1Ch
		db	 0Eh, 1Ch,0FFh,0FFh
data_b_5888	dw	2			; Data table (indexed access)
		db	 02h, 00h, 02h, 00h, 02h, 00h
		db	 00h, 00h, 00h, 00h, 02h, 00h
		db	 06h, 00h, 00h, 00h, 00h, 00h
		db	 02h, 00h, 02h, 00h, 04h, 00h
		db	 04h, 00h, 06h, 00h, 06h, 00h
		db	 02h, 00h, 02h, 00h, 04h, 00h
		db	 04h, 00h, 08h, 00h, 08h, 00h
		db	 0Ah, 00h, 0Ah, 00h, 00h, 00h
		db	 02h, 00h, 04h, 00h, 06h, 00h
		db	 08h, 00h, 0Ah, 00h, 02h, 00h
		db	 04h, 00h, 00h, 00h, 02h, 00h
		db	 04h, 00h, 06h, 00h, 08h, 00h
		db	 0Ah, 00h, 02h, 00h, 04h, 00h
		db	 00h, 00h, 02h, 00h, 04h, 00h
		db	 06h, 00h, 08h, 00h, 0Ah, 00h
		db	 02h, 00h, 04h, 00h, 00h, 00h
		db	 02h, 00h, 04h, 00h, 06h, 00h
		db	 08h, 00h, 0Ah, 00h, 02h, 00h
		db	 04h, 00h, 00h, 00h, 02h, 00h
		db	 04h, 00h, 06h, 00h, 08h, 00h
		db	 0Ah, 00h, 02h, 00h, 04h, 00h
data_b_5908	dw	5864h			; Data table (indexed access)
		db	'jXrX|XrX|XrX|X'
data_b_5918	db	8 dup (0)
data_b_5920	db	0
data_b_5921	dw	0
data_b_5923	dw	0
data_b_5925	dw	0
data_b_5927	db	0
data_b_5928	db	0
data_b_5929	db	0
data_b_592A	dw	0
data_b_592C	db	0
data_b_592D	db	0
data_b_592E	dw	0
		db	0, 0, 0, 0
data_b_5934	dw	1800h			; Data table (indexed access)
		db	 62h, 15h, 2Eh, 14h,0FAh, 11h
		db	0F8h, 10h, 04h, 10h, 00h, 0Ch
		db	 17h, 0Ah, 00h, 0Ch, 17h, 0Ah
		db	 00h, 0Ch, 00h, 0Ch, 17h, 0Ah
		db	 00h, 0Ch, 00h, 0Ch, 2Eh, 14h
		db	0FAh, 11h,0FAh, 11h,0F8h, 10h
		db	0F8h, 10h, 46h, 0Eh, 46h, 0Eh
		db	 00h, 0Ch, 86h, 09h, 00h
		db	0Ch
loc_b_5966:
		xchg	[bx+di],cl
loc_b_5968:
		add	[si],cl
loc_b_596A:
		add	[si],cl
loc_b_596C:
		xchg	[bx+di],cl
loc_b_596E:
		add	[si],cl
loc_b_5970:
		add	[si],cl
		add	[bx+si],bl
		bound	dx,dword ptr [di]
		bound	dx,dword ptr [di]
		db	 2Eh, 14h, 2Eh, 14h,0FAh, 11h
		db	0FAh, 11h,0F8h, 10h, 00h, 0Ch
		db	 78h, 0Dh, 04h, 10h, 2Eh, 14h
		db	 2Eh, 14h, 62h, 15h, 00h, 18h
		db	 00h, 18h, 04h, 10h,0FAh, 11h
		db	 2Eh, 14h,0FAh, 11h, 2Eh, 14h
		db	 62h, 15h, 2Eh, 14h, 62h, 15h
		db	 00h, 18h, 00h, 0Ch, 00h, 06h
		db	 00h, 18h, 00h, 0Ch, 00h, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
		db	 00h, 06h, 00h, 06h, 00h, 06h
data_b_59BA	dw	0
data_b_59BC	dw	0
data_b_59BE	dw	0
data_b_59C0	dw	0
data_b_59C2	db	0A3h			; Data table (indexed access)
		db	0A2h,0B5h, 5Ah,0D3h,0AAh,0BAh
		db	0EAh,0EEh,0ACh,0FEh,0AAh,0FFh
		db	0AAh,0A3h,0A7h,0A3h,0A2h,0B5h
		db	 5Ah,0A3h,0A2h,0B5h, 5Ah,0A0h
		db	0A2h,0B5h, 5Ah,0A0h,0A3h,0BBh
		db	 5Ah,0A3h,0F2h,0B5h, 5Ah,0A3h
		db	0F2h,0B5h, 5Fh,0A3h, 8Fh, 8Fh
		db	0FFh,0AFh,0F2h,0B5h
		db	5Ah
data_b_59F2	dw	3			; Data table (indexed access)
		db	2, 0, 1, 0, 3, 0
data_b_59FA	db	3			; Data table (indexed access)
		db	7
data_b_59FC	db	0Ch			; Data table (indexed access)
		db	18h
data_b_59FE	dw	0			; Data table (indexed access)
		db	 10h, 00h
data_b_5A02	dw	200h			; Data table (indexed access)
		db	0, 6
data_b_5A06	dw	600h			; Data table (indexed access)
		db	0, 2
data_b_5A0A	db	1			; Data table (indexed access)
		db	4
data_b_5A0C	db	20h			; Data table (indexed access)
		db	10h
data_b_5A0E	db	0, 0
data_b_5A10	dw	0
data_b_5A12	dw	0
data_b_5A14	dw	0
data_b_5A16	dw	0
data_b_5A18	dw	0
data_b_5A1A	dw	80h			; Data table (indexed access)
		db	0C0h, 00h, 90h, 00h,0A0h, 00h
		db	 98h, 00h, 60h, 00h,0E0h, 00h
		db	 40h, 00h,0E0h, 00h,0D0h, 00h
		db	0C0h, 00h,0B0h, 00h,0A0h, 00h
		db	 90h, 00h, 80h, 00h, 70h, 00h
		db	 60h, 00h
data_b_5A3C	db	0, 0
data_b_5A3E	dw	0
data_b_5A40	dw	0
data_b_5A42	dw	0
data_b_5A44	dw	200h			; Data table (indexed access)
		db	 00h, 01h, 00h, 06h, 00h, 0Ch
		db	 00h, 0Ah, 00h, 02h, 00h, 08h
		db	 00h, 01h
data_b_5A54	dw	0
data_b_5A56	dw	0
		db	0, 0
data_b_5A5A	dw	722h			; Data table (indexed access)
		db	 00h, 06h, 0Ch, 05h, 3Eh, 04h
data_b_5A62	dw	0
data_b_5A64	dw	4359h			; Data table (indexed access)
		db	 74h, 32h,0CCh, 25h, 51h, 1Ch
		db	 37h, 15h,0E4h, 0Fh,0E8h, 0Bh
		db	0EBh, 08h,0AFh, 06h, 01h, 05h
		db	0C0h, 03h,0CFh, 02h, 1Bh, 02h
		db	 94h, 01h
data_b_5A80	dw	0
data_b_5A82	db	0
data_b_5A83	dw	0
data_b_5A85	dw	0
data_b_5A87	dw	600h			; Data table (indexed access)
		db	 02h, 08h, 00h, 06h, 7Fh, 04h
		db	 02h, 08h, 58h, 05h, 01h, 04h
		db	 23h, 07h, 58h, 05h, 01h, 04h
		db	 23h, 07h,0C3h, 04h, 91h, 03h
		db	 23h, 07h
data_b_5AA3	dw	201h			; Data table (indexed access)
		db	0ACh, 02h, 3Fh, 02h, 00h, 03h
		db	 86h, 02h, 5Eh, 03h,0ACh, 02h
		db	 91h, 03h, 00h, 03h, 2Eh, 03h
		db	 91h, 03h, 01h, 04h, 01h, 04h
		db	 00h
		db	13 dup (0)
data_b_5ACB	dw	0			; required speaker tone
data_b_5ACD	dw	0
data_b_5ACF	db	0
data_b_5AD0	dw	0
data_b_5AD2	db	2			; Data table (indexed access)
		db	2, 2, 0, 0, 2, 2
		db	0, 0, 0, 2, 0
		db	0, 0, 0, 0
data_b_5AE2	dw	0
data_b_5AE4	dw	0
data_b_5AE6	db	2			; Data table (indexed access)
		db	0, 0, 2, 0, 0, 2
		db	2, 0, 0, 2, 2, 2
		db	0, 0, 0, 2, 0, 2
		db	0, 2, 0, 0, 0, 0
		db	2, 0, 0, 0, 0, 2
		db	2
data_b_5B06	db	0
data_b_5B07	db	0
data_b_5B08	dw	0
data_b_5B0A	dw	0
data_b_5B0C	dw	0
data_b_5B0E	db	0
data_b_5B0F	db	0
data_b_5B10	dw	0
data_b_5B12	dw	0
		db	13 dup (0)
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 03h,0ACh, 00h, 0Fh,0C0h
		db	 00h, 00h, 00h, 00h, 2Bh,0C0h
		db	0FAh,0F0h, 00h, 00h, 00h, 00h
		db	 0Bh,0F3h,0F8h, 30h, 00h, 00h
		db	 00h, 00h, 0Fh,0BFh,0BCh, 00h
		db	 00h, 00h, 00h, 00h, 3Ah,0AEh
		db	0ABh, 00h, 00h, 00h, 00h, 00h
		db	 28h, 2Ah, 0Ah, 00h, 00h, 00h
		db	 00h, 00h, 20h, 08h, 02h, 00h
		db	 00h, 00h, 00h, 00h,0B3h, 3Ch
		db	0CFh, 80h, 00h, 00h, 00h, 00h
		db	0AFh,0EAh,0FEh, 80h, 00h, 00h
		db	 00h, 02h,0BAh,0EAh,0EBh,0A0h
		db	 00h, 00h, 00h, 02h,0FFh, 80h
		db	0BFh,0E0h, 00h, 00h, 00h, 0Ah
		db	0F7h, 00h, 37h,0E8h, 00h, 00h
		db	 00h, 0Bh,0C7h,0FFh,0F4h,0F8h
		db	 00h, 00h, 00h, 0Bh,0C5h, 11h
		db	 14h,0F8h, 00h, 00h, 00h, 0Ah
		db	0F5h, 00h, 17h,0E8h, 00h, 00h
		db	 00h, 02h,0EBh, 44h, 7Ah,0E0h
		db	 00h, 00h, 00h, 03h,0AFh,0FFh
		db	0FEh,0B0h, 00h, 00h, 00h, 02h
		db	0FFh,0AAh,0BFh,0E0h, 00h, 00h
		db	 00h, 00h,0ABh,0EAh,0FAh, 80h
		db	 00h, 00h, 00h, 00h, 0Bh,0FFh
		db	0F8h, 00h, 00h, 00h, 00h, 00h
		db	 07h, 33h, 34h, 00h, 00h, 00h
		db	 00h, 00h, 05h, 11h, 14h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 44h
		db	 40h, 00h, 00h, 00h, 3Ch, 00h
		db	 3Ch,0CCh,0CFh, 00h, 00h, 00h
		db	 0Ch, 00h,0FFh,0FFh,0FFh,0C0h
		db	 00h, 00h, 3Ch, 00h,0FFh,0FFh
		db	0FFh,0C0h, 00h, 00h,0FFh, 03h
		db	0FFh,0FFh,0FFh,0F0h, 00h, 00h
		db	 3Fh, 03h,0FEh,0FFh,0FFh,0FCh
		db	 00h, 0Fh,0FCh, 0Fh,0FAh,0FFh
		db	0EBh,0FFh, 03h,0FFh,0F0h, 0Fh
		db	0EBh,0FFh,0FAh,0FFh,0FFh,0FFh
		db	 00h, 3Fh,0FFh,0FFh,0FFh,0FFh
		db	0FFh,0F0h, 00h, 3Fh, 3Fh,0BFh
		db	0BFh, 3Fh,0FFh,0C0h, 00h,0FCh
		db	 3Fh,0EAh,0FEh, 00h,0FCh, 00h
		db	 00h,0FCh, 2Fh,0FFh,0FEh, 00h
		db	 00h, 00h, 00h,0FCh, 2Fh,0FFh
		db	0FFh, 00h, 00h, 00h, 00h,0FFh
		db	 3Eh,0FFh,0EFh, 00h, 00h, 00h
		db	 00h, 3Fh, 2Fh,0AAh,0BEh, 00h
		db	 00h, 00h, 00h, 03h,0EFh,0FFh
		db	0FEh, 00h, 00h, 00h, 00h, 03h
		db	0EFh,0FFh,0FEh, 00h, 00h, 00h
		db	 00h, 00h,0EFh,0FFh,0FEh, 00h
		db	 00h, 00h, 00h, 00h, 2Eh,0BFh
		db	0AEh, 00h, 00h, 00h, 00h, 00h
		db	0EFh,0AAh,0BEh,0C0h, 00h, 00h
		db	 00h, 03h,0CBh,0FFh,0F8h,0F0h
		db	 00h, 00h, 00h, 03h,0FEh,0FFh
		db	0EFh,0F0h, 00h, 00h, 00h, 03h
		db	0FFh,0AAh,0BFh,0FCh, 00h, 00h
		db	 00h, 03h,0FFh,0FFh,0FEh,0FCh
		db	 00h, 00h, 00h, 03h,0FEh,0FFh
		db	0EBh,0FCh, 00h, 00h, 00h, 03h
		db	0FEh,0BFh,0FEh,0FCh, 00h, 00h
		db	 00h, 03h,0BFh,0BFh,0FBh,0F0h
		db	 00h, 00h, 00h, 00h,0BFh, 00h
		db	 0Fh,0F0h, 00h, 00h, 00h, 00h
		db	0FEh, 80h, 0Bh,0FCh, 00h, 00h
		db	 00h, 00h,0FFh, 80h, 0Bh,0FCh
		db	 00h, 00h, 00h, 00h, 0Fh, 80h
		db	 02h,0F0h, 00h, 00h, 00h, 00h
		db	 0Fh,0C0h, 03h,0F0h, 00h, 00h
		db	 00h, 00h, 0Fh,0F0h, 0Fh,0F0h
		db	 00h, 00h, 00h, 00h, 03h,0F0h
		db	 3Eh,0C0h, 00h, 00h, 00h, 00h
		db	 03h,0F3h,0FBh,0C0h, 00h, 00h
		db	 00h, 00h, 03h,0FBh,0FBh, 00h
		db	 00h, 00h, 00h, 03h,0FBh,0FAh
		db	0C0h, 00h, 00h, 00h, 00h, 0Fh
		db	0FEh,0FCh, 00h, 00h, 00h, 00h
		db	 00h, 0Ch,0FEh,0FCh, 00h, 00h
		db	 00h, 00h, 00h, 03h, 30h,0FCh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	0C0h,0FCh
		db	7 dup (0)
		db	0FCh
		db	7 dup (0)
		db	0FCh
		db	7 dup (0)
		db	0FCh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 03h, 33h, 00h, 00h, 00h
		db	 00h, 00h, 00h,0F0h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 03h,0ACh
		db	 00h, 0Fh,0C0h, 00h, 00h, 00h
		db	 00h, 2Bh,0C0h,0FAh,0F0h, 00h
		db	 00h, 00h, 00h, 0Bh,0F3h,0F8h
		db	 30h, 00h, 00h, 00h, 00h, 0Fh
		db	0BFh,0BCh, 00h, 00h, 00h, 00h
		db	 00h, 3Ah,0AEh,0ABh, 00h, 00h
		db	 00h, 00h, 00h, 28h, 2Ah, 0Ah
		db	 00h, 00h, 00h, 00h, 00h, 20h
		db	 08h, 02h, 00h, 00h, 00h, 00h
		db	 00h,0B3h, 3Ch,0CFh, 80h, 00h
		db	 00h, 00h, 00h,0AFh,0EAh,0FEh
		db	 80h, 00h, 00h, 00h, 02h,0BAh
		db	0EAh,0EBh,0A0h, 00h, 00h, 00h
		db	 02h,0FFh, 80h,0BFh,0E0h, 00h
		db	 00h, 00h, 0Ah,0F7h, 00h, 37h
		db	0E8h, 00h, 00h, 00h, 0Bh,0C7h
		db	0FFh,0F4h,0F8h, 00h, 00h, 00h
		db	 0Bh,0C5h, 11h, 14h,0F8h, 00h
		db	 00h, 00h, 0Ah,0F5h, 00h, 17h
		db	0E8h, 00h, 00h, 00h, 02h,0EBh
		db	 44h, 7Ah,0E0h, 00h, 00h, 00h
		db	 03h,0AFh,0FFh,0FEh,0B0h, 00h
		db	 00h, 00h, 02h,0FFh,0AAh,0BFh
		db	0E0h, 00h, 00h, 00h, 00h,0ABh
		db	0EAh,0FAh, 80h, 00h, 00h, 00h
		db	 00h, 0Bh,0FFh,0F8h, 00h, 00h
		db	 00h, 00h, 00h, 07h, 33h, 34h
		db	 00h, 00h, 00h, 00h, 00h, 05h
		db	 11h, 14h, 00h, 00h, 03h,0C0h
		db	 00h, 00h, 44h, 40h, 00h, 00h
		db	 00h,0C0h, 00h, 3Ch,0CCh,0CFh
		db	 00h, 00h, 00h,0F0h, 00h,0FFh
		db	0FFh,0FFh,0C0h, 00h, 03h,0F0h
		db	 00h,0FFh,0FFh,0FFh,0C0h, 00h
		db	 0Fh,0FCh, 03h,0FFh,0FFh,0FFh
		db	0F0h, 00h, 03h,0FCh, 03h,0FFh
		db	0EFh,0FFh,0FCh, 00h, 0Fh,0F0h
		db	 0Fh,0FBh,0EFh,0FFh,0FFh, 00h
		db	0FFh,0F0h, 0Fh,0EFh,0BFh,0AFh
		db	0FFh,0FFh,0FFh,0C0h, 0Fh,0EFh
		db	0FFh,0FAh,0FFh,0FFh,0FCh, 00h
		db	 3Fh,0BFh,0FFh,0FFh, 3Fh,0FFh
		db	0C0h, 00h, 3Fh, 3Fh,0BFh,0BEh
		db	 00h,0FCh, 00h, 00h, 3Fh, 3Fh
		db	0EAh,0FEh, 00h, 00h, 00h, 00h
		db	 3Fh, 3Fh,0FFh,0FFh, 00h, 00h
		db	 00h, 00h, 3Fh,0EFh,0FFh,0FFh
		db	 00h, 00h, 00h, 00h, 03h,0EEh
		db	0FFh,0EEh, 00h, 00h, 00h, 00h
		db	 03h,0EFh,0AAh,0BEh, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FEh
		db	 00h, 00h, 00h, 00h, 00h, 2Eh
		db	0BFh,0AEh, 00h, 00h, 00h, 00h
		db	 00h, 2Fh,0EAh,0FEh, 00h, 00h
		db	 00h, 00h, 00h,0FFh,0FFh,0FEh
		db	0C0h, 00h, 00h, 00h, 03h,0EFh
		db	0FFh,0FCh,0F0h, 00h, 00h, 00h
		db	 03h,0FEh,0BFh,0FBh,0F0h, 00h
		db	 00h, 00h, 03h,0AFh,0EFh,0EFh
		db	0FCh, 00h, 00h, 00h, 0Fh,0FBh
		db	0FAh,0BAh,0FCh, 00h, 00h, 00h
		db	 0Fh,0FEh,0FFh,0FBh,0FCh, 00h
		db	 00h, 00h, 0Fh,0FFh,0FFh,0EFh
		db	0FFh, 00h, 00h, 00h, 03h,0FCh
		db	0FFh,0EBh,0FFh, 00h, 00h, 00h
		db	 03h,0FCh, 00h, 03h,0FEh, 00h
		db	 00h, 00h, 03h,0FFh, 00h, 03h
		db	0F8h, 00h, 00h, 00h, 00h,0BFh
		db	 00h, 00h,0F8h, 00h, 00h, 00h
		db	 00h, 2Bh, 00h, 02h,0F0h, 00h
		db	 00h, 00h, 00h, 0Bh,0C0h, 2Bh
		db	0F0h, 00h, 00h, 00h, 00h, 0Fh
		db	0F3h,0FFh,0C0h, 00h, 00h, 00h
		db	 00h, 03h,0FBh,0FFh, 00h, 00h
		db	 00h, 00h, 00h,0FBh,0FBh,0C0h
		db	 00h, 00h, 00h, 00h, 0Fh,0FBh
		db	0F0h, 00h, 00h, 00h, 00h, 00h
		db	 0Ch,0FBh,0F0h, 00h, 00h, 00h
		db	 00h, 00h, 03h, 30h,0FCh, 00h
		db	 00h, 00h, 00h, 00h, 00h,0C0h
		db	0FCh
		db	7 dup (0)
		db	0FCh
		db	7 dup (0)
		db	0FCh
		db	7 dup (0)
		db	0FCh
		db	7 dup (0)
		db	0FCh
		db	7 dup (0)
		db	0FCh, 00h, 00h, 00h, 00h, 00h
		db	 00h, 03h, 33h, 00h, 00h, 00h
		db	 00h, 00h
data_b_5F60	dw	0
data_b_5F62	dw	5B20h			; Data table (indexed access)
		db	 40h, 5Dh
data_b_5F66	db	0, 0
data_b_5F68	db	0
		db	 00h, 00h, 00h, 00h, 00h, 15h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 00h, 54h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 40h, 00h, 00h
		db	 00h, 00h, 00h, 00h, 01h, 45h
		db	 00h, 00h, 00h, 00h, 00h, 54h
		db	 01h, 54h, 00h, 00h, 00h, 05h
		db	 41h, 45h, 01h, 40h, 00h, 00h
		db	 00h, 15h, 01h, 45h, 01h, 45h
		db	 00h, 00h, 10h, 50h, 01h, 54h
		db	 01h, 55h, 00h, 10h, 50h, 51h
		db	 41h, 55h, 00h, 50h, 00h, 50h
		db	 50h, 55h, 00h, 51h, 40h, 00h
		db	 00h, 51h, 50h, 50h, 00h, 50h
		db	 50h, 00h, 00h, 55h, 50h, 51h
		db	 40h, 50h, 00h, 00h, 00h, 54h
		db	 50h, 55h, 40h, 00h, 00h, 00h
		db	 00h, 50h, 50h, 14h, 00h, 00h
		db	 00h, 00h, 00h, 50h, 40h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 40h
		db	 00h
		db	0, 0, 0, 0, 0, 0
data_b_5FE8	db	0
		db	9 dup (0)
		db	4, 0
		db	8 dup (0)
		db	 01h, 40h, 14h
		db	10 dup (0)
		db	 50h, 14h, 00h
		db	7 dup (0)
		db	 15h, 40h, 50h, 50h
		db	7 dup (0)
		db	 05h, 54h, 00h, 14h, 50h
		db	7 dup (0)
		db	 54h, 50h, 00h, 15h, 40h
		db	8 dup (0)
		db	 50h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 00h, 05h, 50h, 00h
		db	 50h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 01h, 55h, 00h, 00h
		db	 50h, 00h, 05h, 00h, 00h, 00h
		db	 00h, 00h, 15h, 14h, 00h, 00h
		db	 50h, 00h, 04h, 00h, 00h, 00h
		db	 00h, 04h, 00h, 14h, 00h, 00h
		db	 40h, 00h, 04h, 00h, 00h, 00h
		db	 00h, 14h, 00h, 14h, 00h, 00h
		db	 40h, 00h, 00h, 00h, 00h, 10h
		db	 14h, 14h, 00h, 14h
		db	7 dup (0)
		db	 50h, 50h, 14h, 00h, 14h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 50h, 50h, 14h, 00h, 14h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 51h, 40h, 14h, 00h, 10h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 55h, 00h, 14h, 00h, 10h, 00h
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 51h, 40h, 10h, 00h
		db	8 dup (0)
		db	 50h, 50h
		db	10 dup (0)
		db	 50h, 14h, 00h
		db	9 dup (0)
		db	40h
		db	11 dup (0)
data_b_60E4	dw	8EDh			; Data table (indexed access)
		db	 02h, 0Dh,0D9h, 14h, 00h, 00h
		db	 00h, 00h, 00h, 00h
data_b_60F0	db	50h
		db	6Ch
		db	'ease turn on the color display.', 0
data_b_6112	db	'This program requires a color/gr'
		db	'aphics adapter.'
		db	15 dup (0)
data_b_6150	dw	0
data_b_6152	db	0AAh
		db	0AAh,0AAh,0AAh, 00h, 00h, 00h
		db	0AAh, 00h, 00h, 00h,0AAh,0A0h
		db	 00h,0AAh,0AAh, 80h, 00h,0AAh
		db	29 dup (0AAh)
		db	 00h, 00h, 00h,0AAh, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h, 0Ah,0AAh
		db	 00h, 00h
		db	31 dup (0AAh)
		db	 00h,0AAh,0AAh,0A0h, 0Ah, 80h
		db	 0Ah,0AAh, 00h, 02h,0A8h, 00h
		db	 0Ah,0AAh,0AAh,0AAh
		db	28 dup (0AAh)
		db	 00h,0AAh,0AAh,0A0h, 00h, 00h
		db	0AAh,0AAh, 00h, 00h,0A0h, 00h
		db	0Ah
		db	26 dup (0AAh)
data_b_6202	dw	0AAAAh			; Data table (indexed access)
		db	0AAh,0AAh,0AAh, 00h,0AAh,0AAh
		db	0A0h, 00h, 00h,0AAh,0AAh, 00h
		db	0A0h, 00h,0A0h, 0Ah,0AAh,0AAh
		db	0AAh
		db	28 dup (0AAh)
		db	 00h,0AAh,0AAh,0A0h, 0Ah, 80h
		db	 0Ah,0AAh, 00h,0A8h, 02h,0A0h
		db	 0Ah,0AAh,0AAh,0AAh
		db	27 dup (0AAh)
		db	 00h, 00h, 00h,0AAh, 00h, 00h
		db	 00h, 0Ah,0A0h, 00h,0AAh, 0Ah
		db	0A0h, 00h,0AAh
		db	29 dup (0AAh)
		db	 00h, 00h, 00h,0AAh, 00h, 00h
		db	 00h,0AAh,0A0h, 00h,0AAh,0AAh
		db	0A0h, 00h,0AAh
		db	114 dup (0AAh)
		db	 00h, 02h,0A0h, 00h, 2Ah,0A0h
		db	 00h, 2Ah, 00h, 0Ah, 00h, 02h
		db	0A0h, 0Ah,0A0h, 2Ah, 00h, 00h
		db	0A0h, 00h,0AAh,0AAh, 10h,0A0h
		db	0A1h, 0Ah, 0Ah,0A1h, 0Ah,0AAh
		db	 10h, 8Ah, 10h,0AAh,0A1h, 02h
		db	0A1h, 2Ah, 21h, 08h,0A1h, 08h
		db	0AAh,0AAh, 00h,0A0h,0A0h, 0Ah
		db	 0Ah,0A0h, 0Ah,0AAh, 00h,0AAh
		db	 00h,0AAh,0A0h, 02h,0A0h, 2Ah
		db	0A0h, 0Ah,0A0h, 0Ah,0AAh,0AAh
		db	 10h,0A0h,0A1h, 0Ah, 0Ah,0A1h
		db	 0Ah,0AAh, 10h,0AAh, 10h,0AAh
		db	0A1h, 00h,0A1h, 2Ah,0A1h, 0Ah
		db	0A1h, 0Ah,0AAh,0AAh, 00h, 02h
		db	0A0h, 00h, 2Ah,0A0h, 00h,0AAh
		db	 00h, 0Ah, 00h, 0Ah,0A0h, 00h
		db	0A0h, 2Ah,0A0h, 0Ah,0A0h, 00h
		db	0AAh,0AAh, 10h,0AAh,0A1h, 08h
		db	 2Ah,0A1h, 0Ah,0AAh,0A1h, 0Ah
		db	 10h,0AAh,0A1h, 08h, 21h, 2Ah
		db	0A1h, 0Ah,0AAh, 10h,0AAh,0AAh
		db	 00h,0AAh,0A0h, 08h, 0Ah,0A0h
		db	 0Ah,0AAh,0A0h, 0Ah, 00h,0AAh
		db	0A0h, 08h, 20h, 2Ah,0A0h, 0Ah
		db	0AAh, 00h,0AAh,0AAh, 10h,0AAh
		db	0A1h, 0Ah, 02h,0A1h, 0Ah,0AAh
		db	 21h, 0Ah, 10h,0AAh,0A1h, 0Ah
		db	 00h, 2Ah,0A1h, 0Ah,0A2h, 10h
		db	0AAh,0AAh, 00h,0AAh,0A0h, 0Ah
		db	 82h,0A0h, 00h, 2Ah, 00h, 0Ah
		db	 00h, 02h,0A0h, 0Ah, 00h, 2Ah
		db	0A0h, 0Ah,0A0h, 00h,0AAh
data_b_63D0	db	0AAh
		db	0AAh
		db	21 dup (0AAh)
		db	 80h, 02h, 80h,0A8h, 0Ah
		db	23 dup (0AAh)
		db	0A8h, 2Ah, 80h, 00h, 0Ah
		db	23 dup (0AAh)
		db	0A8h, 2Ah, 82h, 02h, 0Ah,0AAh
		db	0AAh, 00h, 2Ah,0A8h, 0Ah,0AAh
		db	 02h,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh, 80h, 2Ah,0AAh
		db	0AAh,0AAh, 02h,0AAh,0A8h, 2Ah
		db	 82h, 8Ah, 0Ah,0AAh,0A8h,0FFh
		db	0CAh,0A3h,0F2h,0A8h,0FCh
		db	7 dup (0AAh)
		db	0A8h, 3Fh,0CAh,0AAh,0AAh,0A8h
		db	0FCh, 80h,0A8h, 2Ah, 82h,0AAh
		db	 0Ah,0AAh,0A3h,0C0h,0F2h, 8Fh
		db	 3Ch,0A3h,0CFh, 2Ah,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A3h,0FCh
		db	0F2h,0AAh,0AAh,0A3h,0CFh, 3Fh
		db	 2Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 8Fh, 28h,0FCh, 3Ch, 8Fh, 0Fh
		db	 23h,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 8Fh,0C2h, 3Ch,0AAh
		db	0AAh, 8Fh, 0Fh,0F0h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 3Ch,0AAh
		db	 3Ch, 3Ch, 8Fh, 0Fh, 23h,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 8Fh, 2Ah, 82h,0AAh,0AAh, 0Fh
		db	0FFh,0CAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 3Ch,0AAh, 3Ch, 3Ch
		db	 8Fh, 0Fh, 23h,0CAh, 02h,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 3Fh, 2Ah
		db	0AAh,0AAh,0A8h,0FFh, 23h,0CAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A8h
		db	0F2h,0AAh, 3Ch, 3Ch, 8Fh, 0Fh
		db	 23h,0C8h,0FCh,0AAh, 0Ah,0A8h
		db	 2Ah,0AAh, 3Ch,0AAh,0AAh,0A8h
		db	 03h,0CFh, 23h,0CAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0A8h,0F2h,0AAh
		db	 3Ch, 8Fh, 3Ch,0A3h,0CFh, 23h
		db	0CFh, 28h,0F2h,0A3h,0CAh,0AAh
		db	 3Ch,0AAh,0AAh,0A3h,0F0h, 23h
		db	0CFh, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0A8h,0F2h,0AAh, 3Ch, 8Fh
		db	 3Ch,0A3h,0CFh, 23h, 23h, 23h
		db	0FCh,0A3h,0CAh,0AAh, 3Fh, 2Ah
		db	0AAh, 0Fh, 3Ch,0A3h,0CFh, 2Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 3Ch,0AAh, 3Ch,0A3h,0F2h,0A8h
		db	0FCh,0A3h,0CFh, 23h,0CFh, 0Fh
		db	0CAh,0AAh, 8Fh, 2Ah, 82h, 3Ch
		db	 8Ch,0A8h,0FCh,0A2h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh, 3Ch, 28h
		db	0FCh, 8Fh,0F2h,0A3h,0FCh,0A8h
		db	0FCh,0A3h,0CFh, 0Fh,0C0h,0AAh
		db	 8Fh,0C2h, 3Ch, 3Ch, 8Ch,0A3h
		db	0FCh, 8Ch,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 8Fh,0C3h,0FCh, 3Ch
		db	0FCh, 0Fh, 3Fh, 03h,0CFh, 0Fh
		db	0C3h,0FFh,0CFh, 2Ah,0A3h,0FCh
		db	0F2h, 8Fh, 3Fh, 0Fh, 3Fh, 3Ch
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0FFh, 0Fh,0F2h, 0Fh,0FCh
		db	 83h,0FFh, 23h,0FFh, 23h,0F3h
		db	0FCh,0AAh,0A8h, 3Fh,0CAh,0A3h
		db	0F3h,0FCh, 83h,0F2h,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh, 00h
		db	0A0h, 0Ah,0A0h, 02h,0A8h, 00h
		db	0A8h, 00h,0A0h, 3Fh,0C2h,0AAh
		db	0AAh, 80h, 2Ah,0A8h, 08h, 02h
		db	0A8h
		db	0Ah
		db	16 dup (0AAh)
		db	 8Fh,0FFh, 2Ah
		db	25 dup (0AAh)
		db	 3Ch, 0Fh, 2Ah,0AAh,0AAh,0AAh
		db	22 dup (0AAh)
		db	 3Ch, 3Ch
		db	26 dup (0AAh)
		db	 8Fh,0F2h
		db	26 dup (0AAh)
		db	0A0h, 0Ah,0AAh
		db	14 dup (0AAh)
data_b_6638	db	0A8h
		db	 00h,0AAh,0AAh,0AAh,0AAh, 80h
		db	 28h, 2Ah,0AAh,0AAh,0AAh, 08h
		db	 28h, 2Ah,0AAh,0AAh,0AAh,0A8h
		db	 00h,0AAh,0AAh,0AAh,0AAh,0A0h
		db	0A8h, 28h, 2Ah, 0Ah,0AAh,0A0h
		db	0A8h, 20h, 2Ah, 0Ah,0AAh,0A0h
		db	0A0h, 82h, 08h, 08h, 2Ah,0A0h
		db	 02h,0AAh, 00h, 80h,0AAh,0AAh
		db	0AAh,0AAh,0A0h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh, 82h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh, 08h, 2Ah,0AAh,0AAh
		db	0AAh,0AAh, 80h,0AAh,0AAh
data_b_6680	db	0A8h
		db	 00h,0AAh,0AAh,0A0h, 2Ah,0A0h
		db	 2Ah,0A8h, 0Ah,0AAh,0A0h,0AAh
		db	0AAh, 80h,0AAh, 80h,0AAh,0AAh
		db	9 dup (0AAh)
		db	 80h, 28h, 2Ah,0AAh, 82h, 0Ah
		db	 82h, 0Ah, 20h, 82h,0AAh,0A0h
		db	0AAh,0AAh
		db	 08h, 2Ah, 08h, 2Ah
		db	10 dup (0AAh)
		db	 08h, 28h, 2Ah, 0Ah, 82h, 0Ah
		db	 82h, 0Ah, 82h, 82h, 82h, 82h
		db	0A0h,0AAh, 08h, 2Ah, 08h, 2Ah
		db	 0Ah,0AAh,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A8h, 00h
		db	0AAh,0AAh, 08h, 2Ah, 08h, 2Ah
		db	0AAh, 82h, 02h, 82h,0AAh,0A8h
		db	 20h,0A8h, 20h,0AAh,0AAh,0A0h
		db	 0Ah, 80h, 20h, 20h, 2Ah, 80h
		db	 2Ah,0AAh,0A0h,0A8h, 28h, 0Ah
		db	 08h, 2Ah, 08h, 2Ah,0AAh, 0Ah
		db	 02h, 82h, 80h,0A8h, 20h,0A8h
		db	 20h,0A8h, 2Ah, 82h, 0Ah, 82h
		db	 02h, 02h, 0Ah, 82h, 0Ah,0AAh
		db	0A0h,0A8h, 28h, 0Ah, 80h,0AAh
		db	 80h,0AAh,0AAh, 08h, 22h, 0Ah
		db	 80h,0AAh, 02h,0AAh, 02h,0A0h
		db	'*', 0Ah, 0Ah, 0Ah, 0Ah, 0Ah, 0Ah
		db	0Ah
		db	 82h,0AAh,0A0h,0A0h,0A0h, 82h
		db	 00h, 28h, 00h, 20h,0AAh, 00h
		db	0A0h, 0Ah, 08h, 20h, 00h,0A0h
		db	 00h, 82h, 08h, 08h, 02h, 08h
		db	 28h, 28h, 28h, 20h, 82h,0AAh
		db	0A0h, 02h,0A0h,0A0h, 2Ah, 00h
		db	0AAh, 02h,0AAh, 02h,0A0h,0AAh
		db	 0Ah, 00h,0A8h, 02h,0A8h, 0Ah
		db	 80h, 80h, 20h, 28h, 28h, 2Ah
		db	 00h,0A8h, 0Ah,0AAh
data_b_6760	db	0AAh
		db	0A8h, 00h, 2Ah,0AAh,0AAh,0AAh
		db	18 dup (0AAh)
		db	 82h,0AAh, 82h,0AAh,0AAh
		db	19 dup (0AAh)
		db	 8Ah,0AAh,0A2h,0AAh,0AAh,0A0h
		db	 0Ah,0AAh
		db	7 dup (0AAh)
		db	0A0h,0AAh,0AAh,0AAh, 02h,0AAh
		db	0A8h,0AAh,0AAh, 2Ah, 00h,0A8h
		db	0AAh,0AAh, 82h, 82h,0AAh,0AAh
		db	0AAh
		db	9 dup (0AAh)
		db	 82h,0AAh,0A0h,0AAh,0AAh, 28h
		db	 28h, 28h,0AAh,0AAh, 0Ah,0AAh
		db	 80h, 2Ah, 08h, 0Ah, 0Ah, 0Ah
		db	 08h, 0Ah, 80h,0AAh, 80h, 82h
		db	 82h, 0Ah, 80h, 0Ah,0AAh, 28h
		db	 2Ah,0A8h,0AAh,0AAh, 0Ah,0AAh
		db	 0Ah, 0Ah, 82h, 82h, 0Ah, 0Ah
		db	 80h, 82h,0A0h,0AAh, 0Ah, 0Ah
		db	 80h, 82h,0A0h,0AAh,0AAh, 28h
		db	 28h, 28h,0AAh,0AAh, 0Ah,0AAh
		db	 0Ah, 0Ah, 82h, 82h, 0Ah, 0Ah
		db	 82h, 82h,0A0h,0AAh, 0Ah, 0Ah
		db	 82h, 82h,0A0h,0AAh,0AAh, 2Ah
		db	 00h,0A8h,0AAh,0AAh, 82h, 82h
		db	 0Ah, 0Ah, 80h, 0Ah, 80h, 0Ah
		db	 82h,0AAh,0A0h,0AAh, 80h, 0Ah
		db	 82h, 82h,0A0h, 8Ah,0AAh, 8Ah
		db	0AAh,0A2h,0AAh,0AAh,0A0h, 0Ah
		db	 80h, 2Ah, 82h,0AAh,0AAh, 0Ah
		db	 00h,0AAh, 80h, 2Ah,0AAh, 0Ah
		db	 02h, 82h,0A8h, 2Ah,0AAh, 82h
		db	0AAh, 82h,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 00h,0AAh, 00h, 2Ah
		db	0AAh,0AAh,0AAh,0AAh, 00h, 2Ah
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0A8h
		db	 00h, 2Ah,0AAh,0AAh,0AAh
		db	17 dup (0AAh)
data_b_6868	db	0A0h
		db	0AAh, 80h, 2Ah, 80h, 2Ah,0A8h
		db	 0Ah, 80h,0AAh, 0Ah, 0Ah, 0Ah
		db	 0Ah,0A0h, 0Ah,0A0h,0AAh, 0Ah
		db	 0Ah, 0Ah, 0Ah, 82h, 0Ah,0A0h
		db	0AAh, 80h, 0Ah, 80h, 2Ah, 0Ah
		db	 0Ah,0A0h,0AAh,0AAh, 0Ah, 0Ah
		db	 0Ah, 00h, 02h,0A0h,0AAh,0A8h
		db	 2Ah, 0Ah, 0Ah,0AAh, 0Ah, 00h
		db	 0Ah, 80h,0AAh, 80h, 2Ah,0A8h
		db	 02h,0AAh
		db	87 dup (0AAh)
		db	 80h, 2Ah, 00h, 0Ah, 0Ah, 82h
		db	0AAh,0AAh,0A0h
		db	0Ah
		db	10 dup (0AAh)
		db	0A0h,0AAh, 82h, 82h, 02h, 02h
		db	0AAh,0AAh, 82h, 82h,0AAh,0AAh
		db	0AAh
		db	7 dup (0AAh)
		db	0A0h,0AAh, 82h, 82h, 00h, 02h
		db	0AAh,0AAh, 0Ah,0AAh, 80h, 2Ah
		db	 08h, 0Ah, 08h, 0Ah,0AAh,0AAh
		db	0AAh,0AAh,0A0h,0AAh, 80h, 0Ah
		db	 00h, 02h,0AAh,0AAh, 0Ah,0AAh
		db	 0Ah, 0Ah, 80h, 82h, 82h, 82h
		db	0AAh,0AAh,0AAh,0AAh,0A0h,0AAh
		db	 82h, 82h, 08h, 82h,0AAh,0AAh
		db	 0Ah,0AAh, 0Ah, 0Ah, 82h, 82h
		db	 82h, 82h,0AAh,0AAh,0AAh,0AAh
		db	0A0h,0AAh, 82h, 82h, 0Ah, 82h
		db	0AAh,0AAh, 82h, 82h, 0Ah, 0Ah
		db	 82h,0AAh, 80h, 0Ah,0A0h,0AAh
		db	0AAh,0AAh, 80h, 2Ah, 00h, 0Ah
		db	 0Ah, 82h,0AAh,0AAh,0A0h, 0Ah
		db	 80h, 2Ah, 00h,0AAh, 82h,0AAh
		db	0A0h,0AAh,0AAh
		db	15 dup (0AAh)
		db	 00h,0AAh,0AAh,0AAh
		db	16 dup (0AAh)
		db	 00h, 0Ah, 02h,0A0h, 2Ah,0AAh
		db	14 dup (0AAh)
		db	0A0h,0AAh, 00h, 00h, 2Ah
		db	15 dup (0AAh)
		db	0A0h,0AAh, 08h, 08h, 2Ah
		db	15 dup (0AAh)
		db	0A0h,0AAh, 0Ah, 28h, 2Ah,0AAh
		db	 80h, 2Ah,0AAh,0AAh,0AAh,0AAh
		db	 80h, 2Ah,0AAh,0AAh,0A0h, 2Ah
		db	0A8h,0AAh,0A0h,0AAh, 0Ah,0A8h
		db	 2Ah,0AAh, 0Ah, 0Ah,0AAh,0AAh
		db	0AAh,0AAh, 0Ah, 0Ah,0AAh,0AAh
		db	 82h, 0Ah,0A0h
		db	7 dup (0AAh)
		db	 02h,0AAh, 0Ah, 0Ah, 00h, 2Ah
		db	 02h,0AAh, 80h, 2Ah, 82h,0AAh
		db	 80h, 0Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 80h,0AAh, 0Ah, 0Ah
		db	 0Ah, 0Ah, 80h,0AAh, 0Ah, 0Ah
		db	 00h,0AAh,0A0h,0AAh,0AAh,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0A8h, 0Ah
		db	 0Ah, 0Ah, 0Ah, 0Ah,0A8h, 0Ah
		db	 0Ah, 0Ah, 82h,0AAh,0A0h,0AAh
		db	0AAh,0AAh,0AAh,0AAh,0AAh,0AAh
		db	 0Ah, 0Ah, 80h, 0Ah, 0Ah, 0Ah
		db	 0Ah, 0Ah, 0Ah, 0Ah, 82h,0AAh
		db	0A0h, 8Ah,0AAh,0AAh,0AAh,0AAh
		db	0AAh,0AAh, 80h, 2Ah,0AAh, 0Ah
		db	 0Ah, 0Ah, 80h, 2Ah, 80h, 2Ah
		db	 00h,0AAh,0A8h
		db	2Ah
		db	8 dup (0AAh)
		db	 00h, 2Ah
		db	16 dup (0AAh)
data_b_6A88	db	0, 0
data_b_6A8A	db	0
data_b_6A8B	dw	0
data_b_6A8D	dw	0
data_b_6A8F	dw	68A8h			; Data table (indexed access)
		db	 98h, 69h
data_b_6A93	dw	0
		db	0
		db	10 dup (0)

; Texts
data_b_6AA0	db	'Do you want to use a joystick (Y/N)?', 0
data_b_6AC5	db	'Please select your skill level:', 0
data_b_6AE5	db	'   (K)itten', 0
data_b_6AF1	db	'   (H)ouse Cat', 0
data_b_6B00	db	'   (T)omcat', 0
data_b_6B0C	db	'   (A)lley Cat', 0
data_b_6B1B	db	'During play:', 0
data_b_6B28	db	'   Ctrl-S  turns the sound on and off.', 0
data_b_6B4F	db	'   Ctrl-R  restarts the game.', 0
data_b_6B6D	db	'   Ctrl-M  returns you to this menu.', 0
data_b_6B92	db	'   Esc     puts the game into paws mode.', 0
data_b_6BBB	db	'Use the cursor keys to control the cat.', 0
data_b_6BE3	db	'The Alt key performs special actions.', 0
data_b_6C09	db	'Press any key to start.', 0
data_b_6C21	db	'Use the joystick to control the cat.', 0
data_b_6C46	db	'The button performs special actions.', 0
data_b_6C6B	db	'Please center your joystick and', 0
data_b_6C8B	db	'press the joystick button to start.', 0
data_b_6CAF	db	'Either joystick is not attached or', 0
data_b_6CD2	db	'Game Control Adapter is not present.', 0
data_b_6CF7	db	'Please correct or select keyboard.', 0
data_b_6D1A	db	'Press any key to continue...', 0

; Text addresses (indexed table)
data_b_6D37	dw	data_b_6AA0	;  0 (00h): 'Do you want to use a joystick (Y/N)?', 0
		dw	data_b_6AC5	;  2 (02h): 'Please select your skill level:', 0
		dw	data_b_6AE5	;  4 (04h): '   (K)itten', 0
		dw	data_b_6AF1	;  6 (06h): '   (H)ouse Cat', 0
		dw	data_b_6B00	;  8 (08h): '   (T)omcat', 0
		dw	data_b_6B0C	; 10 (0Ah): '   (A)lley Cat', 0
		dw	data_b_6B1B	; 12 (0Ch): 'During play:', 0
		dw	data_b_6B28	; 14 (0Eh): '   Ctrl-S  turns the sound on and off.', 0
		dw	data_b_6B4F	; 16 (10h): '   Ctrl-R  restarts the game.', 0
		dw	data_b_6B6D	; 18 (12h): '   Ctrl-M  returns you to this menu.', 0
		dw	data_b_6B92	; 20 (14h): '   Esc     puts the game into paws mode.', 0
		dw	data_b_6C09	; 22 (16h): 'Press any key to start.', 0
		dw	data_b_6C6B	; 24 (18h): 'Please center your joystick and', 0
		dw	data_b_6C8B	; 26 (1Ah): 'press the joystick button to start.', 0
		dw	data_b_6BBB	; 28 (1Ch): 'Use the cursor keys to control the cat.', 0
		dw	data_b_6BE3	; 30 (1Eh): 'The Alt key performs special actions.', 0
		dw	data_b_6C21	; 32 (20h): 'Use the joystick to control the cat.', 0
		dw	data_b_6C46	; 34 (22h): 'The button performs special actions.', 0
		dw	data_b_6CAF	; 36 (24h): 'Either joystick is not attached or', 0
		dw	data_b_6CD2	; 38 (26h): 'Game Control Adapter is not present.', 0
		dw	data_b_6CF7	; 40 (28h): 'Please correct or select keyboard.', 0
		dw	data_b_6D1A	; 42 (2Ah): 'Press any key to continue...', 0

; Text coordinates - column, row (indexed table)
data_b_6D63	db	00h, 00h	;  0 (00h): 'Do you want to use a joystick (Y/N)?', 0    
		db	00h, 02h	;  2 (02h): 'Please select your skill level:', 0         
		db	00h, 04h	;  4 (04h): '   (K)itten', 0
		db	00h, 05h	;  6 (06h): '   (H)ouse Cat', 0
		db	00h, 06h	;  8 (08h): '   (T)omcat', 0
		db	00h, 07h	; 10 (0Ah): '   (A)lley Cat', 0
		db	00h, 09h	; 12 (0Ch): 'During play:', 0
		db	00h, 0Ah	; 14 (0Eh): '   Ctrl-S  turns the sound on and off.', 0  
		db	00h, 0Bh	; 16 (10h): '   Ctrl-R  restarts the game.', 0           
		db	00h, 0Ch	; 18 (12h): '   Ctrl-M  returns you to this menu.', 0    
		db	00h, 0Dh	; 20 (14h): '   Esc     puts the game into paws mode.', 0
		db	00h, 14h	; 22 (16h): 'Press any key to start.', 0
		db	00h, 13h	; 24 (18h): 'Please center your joystick and', 0         
		db	00h, 14h	; 26 (1Ah): 'press the joystick button to start.', 0     
		db	00h, 0Fh	; 28 (1Ch): 'Use the cursor keys to control the cat.', 0 
		db	00h, 10h	; 30 (1Eh): 'The Alt key performs special actions.', 0   
		db	00h, 0Fh	; 32 (20h): 'Use the joystick to control the cat.', 0    
		db	00h, 10h	; 34 (22h): 'The button performs special actions.', 0    
		db	00h, 02h	; 36 (24h): 'Either joystick is not attached or', 0      
		db	00h, 03h	; 38 (26h): 'Game Control Adapter is not present.', 0    
		db	00h, 04h	; 40 (28h): 'Please correct or select keyboard.', 0      
		db	00h, 06h	; 42 (2Ah): 'Press any key to continue...', 0            

data_b_6D8F	dw	0		; text offset

data_b_6D91	db	'           Paws Game:           '
		db	0
		db	'  Press any key to continue...  '
		db	0
data_b_6DD3	db	' Press the button to continue...'
		db	0
		db	 4Bh, 48h, 54h, 41h
data_b_6DF8	dw	0		; skill level 0=Kitten, 1=House Car, 2=Timcat, 3=Alley Cat
data_b_6DFA	dw	0
data_b_6DFC	dw	0		; timer clock LOW
data_b_6DFE	dw	0		; timer clock HIGH
data_b_6E00	dw	0		; destination counter of pressed keys of "Paws Game"
		db	14 dup (0)
data_b_6E10	db	0Fh
		db	 00h, 00h, 00h,0F0h, 00h, 0Fh
		db	0F0h,0FFh, 0Fh,0F0h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 0Fh
		db	0FFh,0FFh,0FFh,0F0h, 00h, 3Fh
		db	 00h, 3Fh, 00h, 3Ch, 00h,0FFh
		db	0CAh,0FFh,0CAh,0FFh, 00h,0FFh
		db	0FFh,0FFh,0FFh,0FFh, 00h,0FFh
		db	0FFh,0F0h,0FFh,0FFh, 00h, 3Fh
		db	0F0h,0FFh,0F0h,0FCh, 00h, 0Fh
		db	0FFh, 00h, 0Fh,0F0h, 00h, 00h
		db	0FFh,0FFh,0FFh, 00h, 00h, 00h
		db	 00h,0FFh, 00h, 00h, 00h
data_b_6E58	db	0Fh
		db	 00h, 00h, 00h,0F0h
		db	7 dup (0)
		db	 0Fh,0F0h,0FFh, 0Fh,0F0h
		db	7 dup (0)
		db	 0Fh,0FFh,0FFh,0FFh,0F0h
		db	7 dup (0)
		db	 0Fh,0F0h, 3Fh,0C0h,0F0h, 00h
		db	 00h, 00h, 01h, 55h, 55h, 50h
		db	 3Fh,0FFh, 0Fh, 0Fh,0FCh, 00h
		db	 00h, 15h, 55h, 55h, 55h, 54h
		db	0FFh,0FAh, 0Fh, 0Ah,0FFh, 00h
		db	 05h, 55h, 55h, 55h, 55h, 55h
		db	0FFh,0FFh,0F0h,0FFh,0FFh, 00h
		db	 55h, 55h, 55h, 54h, 14h, 15h
		db	0FFh,0FFh, 0Fh, 0Fh,0FFh, 01h
		db	 41h, 41h, 55h, 55h, 50h, 55h
		db	 3Fh,0FFh, 00h, 0Fh,0FCh, 01h
		db	 00h, 00h, 54h, 15h, 41h, 55h
		db	 0Fh,0F0h, 3Fh,0C0h,0F0h, 01h
		db	 41h, 41h, 54h, 15h, 05h, 55h
		db	 00h,0FFh,0FFh,0FFh, 00h, 05h
		db	 41h, 41h, 50h, 54h, 14h, 15h
		db	 00h, 00h,0FFh, 00h, 00h, 05h
		db	 00h, 00h, 50h, 55h, 55h, 54h
		db	 00h, 00h, 00h, 00h, 14h, 15h
		db	 41h, 41h, 55h, 55h, 55h, 50h
		db	 00h, 00h, 00h, 00h, 05h, 55h
		db	 55h, 55h, 41h, 55h, 55h, 40h
		db	 00h, 00h, 00h, 00h, 01h
		db	 55h, 55h, 55h, 41h, 54h
		db	7 dup (0)
		db	 05h, 55h, 55h, 55h, 40h
		db	8 dup (0)
		db	 05h, 55h, 00h
		db	0, 0, 0
data_b_6F24	dw	0
data_b_6F26	dw	0
data_b_6F28	dw	0
		db	9 dup (0)
		db	 0Ah, 00h, 00h, 00h,0A8h, 00h
		db	 00h, 0Ah, 80h, 00h, 00h,0A8h
		db	 00h, 00h, 0Ah, 80h, 00h, 00h
		db	0A8h, 00h, 00h, 0Ah, 80h, 00h
		db	 00h,0A8h, 00h, 00h, 00h, 00h
		db	 00h, 00h, 0Ah, 00h, 00h, 00h
		db	0A8h, 00h, 00h, 0Ah, 80h, 00h
		db	 00h,0A8h, 00h, 02h, 8Ah, 80h
		db	 00h, 0Ah,0A8h, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h,0AAh, 00h, 00h
		db	 00h, 00h, 00h, 00h, 0Ah, 00h
		db	 00h, 00h,0A8h, 00h, 00h, 0Ah
		db	 80h, 00h,0A8h,0A8h, 00h, 0Ah
		db	0AAh,0A0h, 00h, 2Ah,0AAh, 00h
		db	 00h,0AAh,0AAh, 80h, 00h,0AAh
		db	 00h, 00h, 00h, 00h, 00h, 00h
		db	 0Ah, 00h, 00h, 0Ah,0A8h, 0Ah
		db	0A0h,0AAh,0A0h, 2Ah,0AAh,0AAh
		db	 00h, 2Ah,0AAh,0A0h, 00h,0AAh
		db	0AAh,0AAh, 00h,0AAh,0AAh,0A8h
		db	 00h,0AAh,0A8h, 00h, 00h, 0Ah
		db	0A0h, 00h, 00h, 2Ah,0AAh, 0Ah
		db	0A0h, 2Ah,0AAh,0AAh,0A0h, 2Ah
		db	0AAh,0A0h, 00h,0AAh,0AAh,0AAh
		db	0A0h,0AAh,0AAh,0AAh,0A0h,0AAh
		db	0AAh,0AAh, 00h,0AAh,0A8h, 00h
		db	 00h, 0Ah,0A0h, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h, 2Ah,0A8h, 00h
		db	 00h, 2Ah,0A0h, 2Ah,0A0h,0AAh
		db	0AAh,0AAh,0A8h,0AAh,0AAh,0AAh
		db	0A8h,0AAh,0AAh,0AAh, 00h,0AAh
		db	0A8h, 00h, 00h,0A0h, 00h, 00h
		db	 00h, 2Ah, 00h, 00h, 00h, 02h
		db	0A0h, 00h, 00h, 00h, 2Ah, 00h
		db	 00h
data_b_7000	db	0			; Data table (indexed access)
		db	 02h,0A0h, 00h, 00h, 00h, 2Ah
		db	 00h, 00h, 00h, 02h,0A0h, 00h
		db	 00h, 00h, 2Ah,0A0h, 00h, 00h
		db	 00h, 2Ah, 00h, 00h, 00h, 02h
		db	0A0h, 00h, 00h, 00h, 2Ah, 00h
		db	 00h, 00h, 02h,0A2h, 80h, 00h
		db	 00h, 2Ah,0A0h, 00h, 00h, 2Ah
		db	0A8h, 00h, 00h, 00h,0AAh,0A0h
		db	 00h, 00h, 00h, 2Ah, 00h, 00h
		db	 00h, 02h,0A0h, 00h, 00h, 00h
		db	 2Ah, 2Ah, 00h, 00h, 0Ah,0AAh
		db	0A0h, 00h, 00h,0AAh
loc_b_7047:
		test	al,0
		add	ch,ss:d_0000_00AA_e[bp+si]
		add	[bx+si],al
		stosb				; Store al to es:[di]
		mov	al,data_b_0000		; sound enabled
		add	[bp+si],ch
		mov	al,data_b_0000		; sound enabled
		or	ch,ss:d_0000_A00A_e[bp+si]
		add	ss:d_0000_A8AA_e[bp+si],ch
		add	[bp+si],cl
		stosb				; Store al to es:[di]
		test	al,0
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bp+si],ch
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		add	[bx+si],al
;*		sub	ch,ss:d_0000_0000_e[bp+si]
		db	 2Ah,0AAh, 00h, 00h	;  Fixup - byte match
		or	ah,ds:data_b_A00A_e[bx+si]
		stosb				; Store al to es:[di]
		test	al,0Ah
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		test	al,0
		or	ch,ss:d_0000_0AA8_e[bp+si]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		or	ch,ss:d_0000_AAAA_e[bp+si]
		add	ss:d_0000_AAAA_e[bp+si],ch
		add	[bx+si],al
;*		sub	ch,ss:d_0000_0000_e[bp+si]
		db	 2Ah,0AAh, 00h, 00h	;  Fixup - byte match
;*		or	ah,data_b_0000[bx+si]
		db	 0Ah,0A0h, 00h, 00h	;  Fixup - byte match
;*		sub	ch,data_b_0000[bx+si]
		db	 2Ah,0A8h, 00h, 00h	;  Fixup - byte match
		sub	ch,ds:data_b_A80A_e[bx+si]
		or	ch,ds:data_b_AA2A_e[bx+si]
		stosb				; Store al to es:[di]
		stosb				; Store al to es:[di]
		sub	ch,ss:d_0000_AAAA_e[bp+si]
		add	ss:d_0000_AAAA_e[bp+si],ch
		add	[bx+si],al
		sub	ch,ss:d_0000_1800_e[bp+si]
		xor	[bx+si+60h],cl
		js	loc_b_7047		; Jump if sign=1
		test	al,0
		add	[bx+si],ah
;*		add	[bx+si+0],al
		db	 00h, 40h, 00h		;  Fixup - byte match
		db	 60h, 00h, 80h, 00h,0A0h, 00h
		db	0C0h, 00h,0E0h, 00h, 00h, 01h
		db	 20h, 01h
data_b_70CC	db	0
		db	31 dup (0)
data_b_70EC	dw	0
data_b_70EE	dw	0
data_b_70F0	dw	0
data_b_70F2	db	0
data_b_70F3	dw	0
data_b_70F5	db	0
data_b_70F6	db	0
data_b_70F7	db	0
data_b_70F8	dw	0
data_b_70FA	dw	0
data_b_70FC	dw	20h			; Data table (indexed access)
		db	 30h, 00h, 40h, 00h, 50h, 00h
		db	 60h, 00h, 70h, 00h, 80h, 00h
		db	 90h, 00h,0A0h, 00h,0B0h, 00h
		db	0C0h, 00h,0D0h, 00h,0E0h, 00h
		db	0F0h, 00h, 00h, 01h, 10h, 01h
		db	 20h, 01h, 30h, 01h
data_b_7120	db	0BFh			; Data table (indexed access)
		db	0A7h, 8Fh, 77h, 5Fh, 47h, 2Fh
		db	 17h
		db	8 dup (0)
sub_b_54A3	endp


seg_b		ends



;------------------------------------------------------------  seg_c   ----

seg_c		segment	byte public
		assume cs:seg_c  , ds:seg_b , ss:stack_seg_a


;==========================================================================
;
;                       program	entry point
;
;==========================================================================


CAT		proc	far

		; prepare exit address - jump to INT 20h instruction
start_game:	push	ds
		mov	ax,0
		push	ax

		; check color graphics card
		call	sub_c_5C60		; Check color graphics card

		; initialize data segment
		mov	ax,seg_b
		mov	ds,ax

		; get PC model - need to check PCjr computer
		call	sub_c_13AA		; Get PC model

		; install INT 09h keyboard handler
		mov	data_b_0690,4
		mov	word ptr data_b_6DF8,0	; skill level 0=Kitten, 1=House Car, 2=Timcat, 3=Alley Cat
		mov	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		call	sub_c_1419		; Install INT 09h handler
		call	sub_c_13E8		; Initialize keyboard buffer

		; set destination counter of pressed keys - prepare "Paws Game"
		mov	ax,data_b_0693		; counter of pressed keys
		add	ax,240h			; next interval to Paws Game (=576 keys)
		mov	data_b_6E00,ax		; destination counter of pressed keys of "Paws Game"

		; initialize CGA videomode 320x240/4
		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

		; set palette colors
		mov	al,4
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_003F		; Jump if equal
		mov	al,6
loc_c_003F:	mov	data_b_0690,al
		mov	ah,0Bh
		mov	bx,101h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)

		mov	data_b_0416,0

		; set palettes of intro screen
		mov	word ptr data_b_0004,0 ; current scene 1..7, 0=intro
		call	sub_c_1D31		; Set palette color of current scene

		; set CYAN color scheme
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_0065		; Jump if equal
		mov	dx,3D9h
		mov	al,20h			; ' '
		out	dx,al			; port 3D9h, CGA color control

loc_c_0065:	call	sub_c_2E10		; Read 8253 counter

		; clear max and current score
		call	sub_c_26E1		; Clear digits of max score
		call	sub_c_26DA		; Clear digits of current score

; !!! Picopad modification - skip game menu
		mov	data_b_041A,1 ;0		; 1=game menu was selected, skip it


		mov	ax,0FFFFh
		mov	data_b_041D,ax
		mov	data_b_041F,ax
		mov	data_b_0000,0FFh	; sound enabled

; Restart game, update max. score

		; update max score from current score
loc_c_0081:	call	sub_c_2690		; Update max score from current score

		; new game, play instro screen
		mov	data_b_0008,0
		mov	word ptr data_b_0004,0 ; current scene 1..7, 0=intro
		call	sub_c_1D31		; Set palette color of current scene
		call	sub_c_5B21		; Disable sound output
		call	sub_c_5CB0		; Play intro scene
		call	sub_c_5B21		; Disable sound output

; Start game menu

		; check if game menu need to be selected
		cmp	data_b_041A,0		; 1=game menu was selected, skip it
		jne	loc_c_00AE		; Jump if not equal

		; game menu
loc_c_00A3:	call	sub_c_5B21		; Disable sound output
		call	sub_c_5EE5		; Game menu
		mov	data_b_041A,1		; 1=game menu was selected, skip it

; Restart game

loc_c_00AE:	mov	ax,word ptr data_b_6DF8	; skill level 0=Kitten, 1=House Car, 2=Timcat, 3=Alley Cat
		mov	data_b_0008,ax
		mov	data_b_1F80,3		; initial cat lives (1..9)

		; clear current score
		call	sub_c_26DA		; Clear digits of current score

		; prepare palettes of intro screen
		mov	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		call	sub_c_1D31		; Set palette color of current scene
		call	sub_c_5B21		; Disable sound output
		mov	data_b_1C30,0

		; get system timer - start of game
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_0412,dx		; system timer - start of game

		mov	data_b_0414,0
		mov	data_b_0418,0
		mov	data_b_0419,0
		mov	data_b_041C,0		; 0ffh = request game menu
		mov	data_b_041B,0		; 0ffh = request restart game
		call	sub_c_5B21		; Disable sound output

		; jump to dead, no live remains
loc_c_00F3:	cmp	data_b_1F80,0		; cat lives (1..9)
		je	loc_c_0081		; Jump if equal ... dead

		; jump to restart game
		cmp	data_b_041B,0		; 0ffh = request restart game
		jne	loc_c_00AE		; Jump if not equal

		; jump to game menu
		cmp	data_b_041C,0		; 0ffh = request game menu
		jne	loc_c_00A3		; Jump if not equal

		call	sub_c_2A00
		call	sub_c_5400

		mov	data_b_1F81,0FFh	; current display cat lives (1..9)
		call	sub_c_5B21		; Disable sound output

		mov	word ptr data_b_0004,0 ; current scene 1..7, 0=intro
		cmp	data_b_0419,0
		je	loc_c_0137		; Jump if equal
		call	sub_c_07A1		; Load image ??? from screen to bufer
		mov	data_b_0550,2
		mov	data_b_0576,1
		mov	data_b_0578,20h		; ' '
		jmp	short loc_c_0140

loc_c_0137:	mov	data_b_0579,0
		call	sub_c_070D		; Load image ??? from screen to bufer

loc_c_0140:	call	sub_c_1E40
		call	sub_c_1830
		call	sub_c_2210
		call	sub_c_2330
		call	sub_c_26F2		; Print max score
		call	sub_c_26FC		; Print current score
		call	sub_c_58BD

		; check cat lives
loc_c_0155:	cmp	data_b_1F80,0		; cat lives (1..9)
		jne	loc_c_015F		; Jump if not equal
		jmp	loc_c_0081		; dead

		; input special keys
loc_c_015F:	call	sub_c_1338		; Input special keys during game

		; jump to game menu
		cmp	data_b_041C,0		; 0ffh = request game menu
		je	loc_c_016C		; Jump if equal
		jmp	loc_c_00A3		; game menu

		; jump to restart game
loc_c_016C:	cmp	data_b_041B,0		; 0ffh = request restart game
		je	loc_c_0176		; Jump if equal
		jmp	loc_c_00AE		; restart game

loc_c_0176:	call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_08E5
		call	sub_c_1E63
		cmp	data_b_1CB8,0
		jne	loc_c_0191		; Jump if not equal
		inc	data_b_040F
		test	data_b_040F,3
		jnz	loc_c_0155		; Jump if not zero
loc_c_0191:
		call	sub_c_546D
		call	sub_c_04A0
		call	sub_c_1936
		call	sub_c_184B
		call	sub_c_2216
		call	sub_c_237B
		call	sub_c_26B3		; Display cat lives
		cmp	data_b_0551,0
		je	loc_c_0155		; Jump if equal

		; check cat lives
		cmp	data_b_1F80,0		; cat lives (1..9)
		jne	loc_c_01B7		; Jump if not equal
		jmp	loc_c_0081		; dead
loc_c_01B7:
		; get system clock
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_0410,dx
		mov	ax,data_b_0579
		mov	data_b_0001,ax
		mov	al,data_b_057B
		mov	byte ptr data_b_0003,al
		mov	data_b_0419,1
		cmp	data_b_0418,0
		je	loc_c_01E5		; Jump if equal
		mov	data_b_0418,0
		mov	word ptr data_b_0004,7 ; current scene 1..7, 0=intro
		jmp	short loc_c_0238
		db	90h
loc_c_01E5:
		call	sub_c_2DFD
		test	dl,0A0h
		jz	loc_c_020A		; Jump if zero
		mov	bx,data_b_0008
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		cmp	bx,3
		je	loc_c_020A		; Jump if equal
		mov	cl,2
		shl	bx,cl			; Shift w/zeros fill
;*		and	dx,3
		db	 81h,0E2h, 03h, 00h	;  Fixup - byte match
		add	bx,dx
		mov	al,data_b_0421[bx]
		jmp	short loc_c_021C
loc_c_020A:
		call	sub_c_2DFD
;*		and	dx,7
		db	 81h,0E2h, 07h, 00h	;  Fixup - byte match
		cmp	dx,5
		jae	loc_c_020A		; Jump if above or =
		mov	bx,dx
		mov	al,data_b_042D[bx]
loc_c_021C:
		sub	ah,ah
		cmp	ax,data_b_041D
		jne	loc_c_022A		; Jump if not equal
		cmp	ax,data_b_041F
		je	loc_c_01E5		; Jump if equal
loc_c_022A:
		mov	word ptr data_b_0004,ax ; current scene 1..7, 0=intro
		mov	cx,data_b_041D
		mov	data_b_041F,cx
		mov	data_b_041D,ax
loc_c_0238:
		mov	data_b_0006,0
		mov	bx,word ptr data_b_0004 ; current scene 1..7, 0=intro
		cmp	bx,7
		jbe	loc_c_0249		; Jump if below or =
		sub	bx,bx
loc_c_0249:
		shl	bx,1			; Shift w/zeros fill
		jmp	word ptr cs:data_c_0250[bx]	;*8 entries

; Jump to scene
data_c_0250	dw	offset loc_c_03E2	; Data table (indexed access)
data_c_0252	dw	offset loc_c_03E2
data_c_0254	dw	offset loc_c_0459
data_c_0256	dw	offset loc_c_0394
data_c_0258	dw	offset loc_c_0349
data_c_025A	dw	offset loc_c_02FE
data_c_025C	dw	offset loc_c_02AA
data_c_025E	dw	offset loc_c_0260

;===== Indexed Entry Point ================================================

; Scene 7 loop

loc_c_0260:
		mov	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_07A1		; Load image ??? from screen to bufer
		call	sub_c_1E40
		call	sub_c_3405
		call	sub_c_6100
		call	sub_c_4F59
		call	sub_c_58BD
loc_c_027E:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_08E5
		call	sub_c_6106
		call	sub_c_2F66
		call	sub_c_2E60
		call	sub_c_4C10
		mov	al,data_b_0551
		or	al,data_b_0553
		or	al,data_b_041C		; 0ffh = request game menu
		or	al,data_b_041B		; 0ffh = request restart game
		jz	loc_c_027E		; Jump if zero
		jmp	loc_c_0427

;===== Indexed Entry Point ================================================

; Scene 6 loop

loc_c_02AA:
		mov	word ptr data_b_0004,6	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_4C00
		call	sub_c_07A1		; Load image ??? from screen to bufer
		call	sub_c_3405
		call	sub_c_1E40
		call	sub_c_58BD
loc_c_02C5:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_4943
		call	sub_c_47D6
		call	sub_c_08E5
		cmp	data_b_1CB8,0
		je	loc_c_02E3		; Jump if equal
		call	sub_c_1E63
		jmp	short loc_c_02E6
loc_c_02E3:
		call	sub_c_3150
loc_c_02E6:
		mov	al,data_b_0551
		or	al,data_b_0552
		or	al,data_b_0553
		or	al,data_b_041B		; 0ffh = request restart game
		or	al,data_b_041C		; 0ffh = request game menu
		jz	loc_c_02C5		; Jump if zero
		jmp	loc_c_0427

;===== Indexed Entry Point ================================================

; Scene 5 loop

loc_c_02FE:
		mov	word ptr data_b_0004,5	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_457A
		call	sub_c_07A1		; Load image ??? from screen to bufer
		call	sub_c_3405
		call	sub_c_1E40
		call	sub_c_58BD
loc_c_0319:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_45AB
		call	sub_c_4340
		call	sub_c_08E5
		call	sub_c_3150
		call	sub_c_1E63
		mov	al,data_b_0552
		or	al,data_b_0553
		or	al,data_b_0551
		or	al,data_b_041C		; 0ffh = request game menu
		or	al,data_b_041B		; 0ffh = request restart game
		jz	loc_c_0319		; Jump if zero
		jmp	loc_c_0427

;===== Indexed Entry Point ================================================

; Scene 4 loop

loc_c_0349:
		mov	word ptr data_b_0004,4	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_07A1		; Load image ??? from screen to bufer
		call	sub_c_3405
		call	sub_c_1E40
		call	sub_c_4090
		call	sub_c_58BD
loc_c_0364:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_08E5
		call	sub_c_3E90
		call	sub_c_40C2
		call	sub_c_3150
		call	sub_c_1E63
		mov	al,data_b_0552
		or	al,data_b_0553
		or	al,data_b_0551
		or	al,data_b_041C		; 0ffh = request game menu
		or	al,data_b_041B		; 0ffh = request restart game
		jz	loc_c_0364		; Jump if zero
		jmp	loc_c_0427

;===== Indexed Entry Point ================================================

; Scene 3 loop

loc_c_0394:
		mov	word ptr data_b_0004,3	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_07A1		; Load image ??? from screen to bufer
		call	sub_c_3405
		call	sub_c_1E40
		call	sub_c_3B30
		call	sub_c_3C90
		call	sub_c_58BD
loc_c_03B2:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_08E5
		call	sub_c_3CB1
		call	sub_c_3B42
		call	sub_c_3150
		call	sub_c_1E63
		mov	al,data_b_0552
		or	al,data_b_0553
		or	al,data_b_0551
		or	al,data_b_041C		; 0ffh = request game menu
		or	al,data_b_041B		; 0ffh = request restart game
		jz	loc_c_03B2		; Jump if zero
		jmp	short loc_c_0427
		db	90h

;===== Indexed Entry Point ================================================

; Scene 1 loop

loc_c_03E2:
		mov	word ptr data_b_0004,1	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_07A1		; Load image ??? from screen to bufer
		call	sub_c_3405
		call	sub_c_1E40
		call	sub_c_58BD
loc_c_03FA:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_08E5
		call	sub_c_3150
		call	sub_c_1E63
		call	sub_c_3850
		cmp	byte ptr data_b_0554,0
		jne	loc_c_0459		; Jump if not equal
		mov	al,data_b_0552
		or	al,data_b_0551
		or	al,data_b_041B		; 0ffh = request restart game
		or	al,data_b_041C		; 0ffh = request game menu
		jz	loc_c_03FA		; Jump if zero
loc_c_0427:
		cmp	data_b_041B,0		; 0ffh = request restart game
		je	loc_c_0431		; Jump if equal
		jmp	loc_c_00AE
loc_c_0431:
		cmp	data_b_041C,0		; 0ffh = request game menu
		je	loc_c_043B		; Jump if equal
		jmp	loc_c_00A3
loc_c_043B:
		cmp	data_b_0552,0
		je	loc_c_0447		; Jump if equal
		mov	data_b_0419,0
loc_c_0447:
		mov	ax,word ptr data_b_0004	; current scene 1..7, 0=intro
		mov	data_b_0006,ax
		mov	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		jmp	loc_c_00F3

;===== Indexed Entry Point ================================================

; Scene 2 loop

loc_c_0459:
		mov	word ptr data_b_0004,2	; current scene 1..7, 0=intro
		call	sub_c_1BF0
		call	sub_c_2790
		call	sub_c_35C9
		call	sub_c_07A1		; Load image ??? from screen to bufer
		mov	data_b_1CBF,0
		mov	data_b_1CB8,0
		call	sub_c_58BD
loc_c_0478:
		call	sub_c_1338		; Input special keys during game
		call	sub_c_1200		; Input from joystick or keyboard
		call	sub_c_546D
		call	sub_c_08E5
		call	sub_c_3675
		call	sub_c_37E5
		mov	al,data_b_0552
		or	al,data_b_0553
		or	al,data_b_041C		; 0ffh = request game menu
		or	al,data_b_041B		; 0ffh = request restart game
		jz	loc_c_0478		; Jump if zero
		jmp	short loc_c_0427
		db	0, 0, 0

CAT		endp

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_04A0	proc	near
		dec	data_b_0531
		jz	loc_c_04A7		; Jump if zero

loc_ret_c_04A6:
		retn
loc_c_04A7:
		inc	data_b_0531
		call	sub_c_13D8		; Check light pen
		jnz	loc_ret_c_04A6		; Jump if not zero
		cmp	data_b_055A,0
		jne	loc_ret_c_04A6		; Jump if not equal
		cmp	data_b_1673,0
		jne	loc_ret_c_04A6		; Jump if not equal

		; get system timer
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,word ptr data_b_0544
		je	loc_ret_c_04A6		; Jump if equal

		mov	word ptr data_b_0544,dx
		mov	bx,data_b_0008
		mov	al,byte ptr data_b_0532[bx]	; ('dPF<72((')
		cmp	data_b_057B,60h		; '`'
		ja	loc_c_04DF		; Jump if above
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
loc_c_04DF:
		mov	data_b_0531,al
		mov	bx,data_b_052F
		call	sub_c_0658
		jz	loc_c_050C		; Jump if zero
		mov	al,data_b_0525
		add	al,data_b_0529[bx]
		cmp	al,4
		jb	loc_ret_c_04A6		; Jump if below
loc_c_04F6:
		call	sub_c_2DFD
		and	dl,3
		cmp	dl,byte ptr data_b_052F
		je	loc_c_04F6		; Jump if equal
		cmp	dl,3
		je	loc_c_04F6		; Jump if equal
		mov	bl,dl
		jmp	short loc_c_0535
		db	90h
loc_c_050C:
		mov	al,data_b_0529[bx]
		add	data_b_0525,al
		cmp	data_b_0525,4
		jb	loc_c_0583		; Jump if below
		call	sub_c_2DFD
		cmp	dl,40h			; '@'
		ja	loc_c_0539		; Jump if above
loc_c_0523:
		call	sub_c_2DFD
		and	dl,3
		cmp	dl,3
		je	loc_c_0523		; Jump if equal
		mov	bl,dl
		call	sub_c_0658
		jnz	loc_c_0523		; Jump if not zero
loc_c_0535:
		mov	data_b_052F,bx
loc_c_0539:
		mov	al,data_b_0526[bx]
		mov	data_b_0525,al
		mov	ax,seg_b
		mov	es,ax
		mov	di,offset data_b_04D7
		mov	ah,data_b_052C[bx]
		mov	bx,data_b_0008
		mov	bl,data_b_2ABA[bx]
		mov	bh,ah
		call	sub_c_067D
		cmp	data_b_052F,1
		je	loc_c_056E		; Jump if equal
		shr	data_b_0540,1		; Shift w/zeros fill
		call	sub_c_0633
		shr	data_b_0540,1		; Shift w/zeros fill
		jmp	short loc_c_057C
		db	90h
loc_c_056E:
		mov	al,data_b_0540
		shr	al,1			; Shift w/zeros fill
		shr	al,1			; Shift w/zeros fill
		call	sub_c_0633
		shr	data_b_0540,1		; Shift w/zeros fill
loc_c_057C:
		call	sub_c_0633
		mov	bx,data_b_052F
loc_c_0583:
		cmp	data_b_04D6,0
		je	loc_c_05D0		; Jump if equal
		mov	ax,data_b_0579
		cmp	bl,1
		je	loc_c_05BF		; Jump if equal
		inc	data_b_055F
		add	ax,4
		cmp	ax,123h
		jb	loc_c_05CD		; Jump if below
loc_c_059E:
		mov	data_b_055B,11h
		mov	data_b_0571,1
		mov	data_b_0576,1
		mov	data_b_0578,18h
		mov	byte ptr data_b_0572,1
		mov	data_b_055C,0
		jmp	short loc_c_05D0
		db	90h
loc_c_05BF:
		dec	data_b_055F
		sub	ax,4
		jc	loc_c_059E		; Jump if carry Set
		cmp	ax,8
		jb	loc_c_059E		; Jump if below
loc_c_05CD:
		mov	data_b_0579,ax
loc_c_05D0:
		push	ds
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_051D[bx]
		mov	data_b_0523,ax
		mov	si,data_b_0517[bx]
		mov	ax,0B800h
		mov	ds,ax
		mov	es,ax
		mov	di,si
		cmp	bx,2
		jne	loc_c_05F1		; Jump if not equal
		cld				; Clear direction
		dec	di
		jmp	short loc_c_05F3
		db	90h
loc_c_05F1:
		std				; Set direction flag
		inc	di
loc_c_05F3:
		mov	cx,27Fh
		push	di
		push	si
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	si
		pop	di
		add	si,d_B800_2000_e
		add	di,d_B800_2000_e
		mov	cx,280h
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		pop	ds
		mov	di,data_b_0523
		mov	bl,data_b_0525
		sub	bh,bh
		add	bx,offset data_b_04D7
		mov	cx,10h

locloop_c_061B:
		mov	al,[bx]
		mov	es:[di],al
		add	bx,4
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_0630		; Jump if not zero
		add	di,50h
loc_c_0630:
		loop	locloop_c_061B		; Loop if cx > 0

		retn
sub_c_04A0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_0633	proc	near
		lahf				; Load ah from flags
		mov	bx,data_b_052F
		mov	bl,data_b_0541[bx]
		mov	cx,5
		cmp	bl,9
		je	locloop_c_064E		; Jump if equal

locloop_c_0644:
		sahf				; Store ah into flags
		rcr	data_b_1016[bx],1	; Rotate thru carry
		lahf				; Load ah from flags
		inc	bx
		loop	locloop_c_0644		; Loop if cx > 0

		retn

locloop_c_064E:
		sahf				; Store ah into flags
		rcl	data_b_1016[bx],1	; Rotate thru carry
		lahf				; Load ah from flags
		dec	bx
		loop	locloop_c_064E		; Loop if cx > 0

		retn
sub_c_0633	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_0658	proc	near
		mov	data_b_04D6,0
		mov	al,data_b_057C
		cmp	al,data_b_053D[bx]
		jb	loc_c_0679		; Jump if below
		cmp	al,data_b_053A[bx]
		jae	loc_c_0679		; Jump if above or =
		cmp	data_b_055C,1
		jae	loc_c_0674		; Jump if above or =
		retn
loc_c_0674:
		mov	data_b_04D6,1
loc_c_0679:
		cmp	al,al
		retn
sub_c_0658	endp

		db	0C3h

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_067D	proc	near
		mov	data_b_0540,0
		cld				; Clear direction
		mov	cx,20h
		mov	ax,0AAAAh
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		sub	di,40h
		mov	ax,4444h
		mov	es:[di+4],ax
		mov	es:[di+6],ax
		call	sub_c_2DFD
		cmp	dl,bl
		jb	loc_ret_c_06A4		; Jump if below
		cmp	dh,bh
		ja	loc_c_06A5		; Jump if above

loc_ret_c_06A4:
		retn
loc_c_06A5:
		call	sub_c_2DFD
		cmp	dl,18h
		jb	loc_c_06C7		; Jump if below
		cmp	dl,60h			; '`'
		jb	loc_c_06D0		; Jump if below
		push	di
		call	sub_c_06DE
		shl	al,1			; Shift w/zeros fill
		mov	data_b_0540,al
		pop	di
		add	di,2
		call	sub_c_06DE
		or	data_b_0540,al
		retn
loc_c_06C7:
		mov	cx,20h
		mov	si,490h
		jmp	short loc_c_06D6
		db	90h
loc_c_06D0:
		mov	cx,10h
		mov	si,offset data_b_0460
loc_c_06D6:
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	data_b_0540,3
		retn
sub_c_067D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_06DE	proc	near
		call	sub_c_2DFD
;*		and	dx,6
		db	 81h,0E2h, 06h, 00h	;  Fixup - byte match
		cmp	dl,6
		jne	loc_c_06ED		; Jump if not equal
		sub	al,al
		retn
loc_c_06ED:
		mov	bx,dx
		mov	si,data_b_04D0[bx]
		mov	cx,8

locloop_c_06F6:
		lodsw				; String [si] to ax
		stosw				; Store ax to es:[di]
		add	di,2
		loop	locloop_c_06F6		; Loop if cx > 0

		mov	al,1
		retn
sub_c_06DE	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear data_b_057D and data_b_0684

sub_c_0700	proc	near
		mov	data_b_057D,0
		mov	data_b_0684,0
		retn
sub_c_0700	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Load image ??? from screen to bufer

sub_c_070D	proc	near
		mov	cx,0
		mov	ah,1
		cmp	data_b_0579,0A0h
		jb	loc_c_071F		; Jump if below
		mov	cx,128h
		mov	ah,0FFh
loc_c_071F:
		mov	data_b_056E,ah
		mov	data_b_0558,3
		mov	data_b_0559,0Ch
		mov	dl,0B4h
		mov	data_b_0579,cx
		mov	data_b_057B,dl
		mov	data_b_057C,0E6h
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_055F,ax
		mov	data_b_0561,0B03h
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
		mov	data_b_0571,0
		mov	data_b_0572,2
		mov	data_b_0576,1
		mov	data_b_055B,0
		mov	data_b_0550,0
		mov	data_b_055C,0
		mov	data_b_055A,0
		mov	data_b_0583,0
		mov	data_b_0698,0		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		mov	data_b_0551,0
		mov	data_b_0584,0
		mov	data_b_0552,0
		mov	data_b_0554,0
		mov	data_b_0553,0
		mov	data_b_127C,0
		call	sub_c_0700		; Clear data_b_057D and data_b_0684
		retn
sub_c_070D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Load image ??? from screen to bufer

sub_c_07A1	proc	near
		mov	bx,word ptr data_b_0004	; current scene 1..7, 0=intro
		cmp	bx,0
		jne	loc_c_07B5		; Jump if not equal
		mov	cx,data_b_0001
		mov	dl,byte ptr data_b_0003
		jmp	short loc_c_07BF
		db	90h
loc_c_07B5:
		mov	dl,data_b_05E9[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_05D9[bx]
loc_c_07BF:
		mov	data_b_0579,cx
		mov	data_b_057B,dl
		mov	al,dl
		add	al,32h			; '2'
		mov	data_b_057C,al
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_055F,ax
		mov	ax,data_b_0FB2
		mov	data_b_0569,ax
		mov	ax,data_b_0FBE
		mov	data_b_0567,ax
		mov	data_b_0561,ax
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
		mov	data_b_0571,1
		mov	data_b_056E,0
		mov	data_b_0576,1
		mov	data_b_0578,40h		; '@'
		mov	al,0Ah
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_0805		; Jump if not equal
		sub	al,al
loc_c_0805:
		mov	data_b_055B,al
		mov	data_b_0550,0
		mov	data_b_055C,0
		mov	data_b_055A,0
		mov	data_b_0583,0
		mov	data_b_0698,0		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		mov	data_b_0551,0
		mov	data_b_0584,0
		mov	data_b_0552,0
		mov	data_b_0554,0
		mov	data_b_0553,0
		mov	data_b_127C,0
		call	sub_c_0700		; Clear data_b_057D and data_b_0684
		cmp	word ptr data_b_0004,2	; current scene 1..7, 0=intro
		jne	loc_ret_c_0871		; Jump if not equal
		mov	data_b_0576,10h
		mov	data_b_0574,10h
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_05F1,dx
		mov	data_b_05F3,0
		mov	data_b_05F4,5
		mov	data_b_05F5,1

loc_ret_c_0871:
		retn
sub_c_07A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_0872	proc	near
		mov	data_b_592A,400h
		cmp	data_b_0584,0
		je	loc_c_0880		; Jump if equal
		retn
loc_c_0880:
		mov	data_b_0576,8
		mov	dl,0FFh
		mov	al,data_b_057B
		cmp	al,data_b_2652
		jae	loc_c_0892		; Jump if above or =
		mov	dl,1
loc_c_0892:
		mov	data_b_0571,dl
		mov	ax,data_b_0579
		sub	ax,data_b_2650
		mov	dl,0FFh
		ja	loc_c_08A5		; Jump if above
		mov	dl,1
		not	ax
loc_c_08A5:
		mov	data_b_056E,dl
		cmp	ah,0
		je	loc_c_08B1		; Jump if equal
		mov	ax,0FFh
loc_c_08B1:
		not	al
		cmp	al,30h			; '0'
		jae	loc_c_08B9		; Jump if above or =
		mov	al,30h			; '0'
loc_c_08B9:
		mov	bl,al
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		sub	al,bl
		mov	data_b_0578,al
		mov	cl,5
		shr	al,cl			; Shift w/zeros fill
		mov	data_b_0572,ax
		mov	data_b_055C,0
		mov	data_b_39E0,0
		mov	data_b_0577,1
		mov	data_b_055B,10h
		mov	data_b_0584,1
		retn
sub_c_0872	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_08E5	proc	near

		; get system timer
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_057D
		jne	loc_c_08FD		; Jump if not equal
		cmp	data_b_0684,0
		je	loc_ret_c_08FC		; Jump if equal
		dec	data_b_0684
		jz	loc_c_090C		; Jump if zero

loc_ret_c_08FC:
		retn
loc_c_08FD:
		mov	ax,20h
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_0909		; Jump if not equal
		shr	ax,1			; Shift w/zeros fill
loc_c_0909:
		mov	data_b_0684,ax
loc_c_090C:
		cmp	word ptr data_b_0004,2	; current scene 1..7, 0=intro
		je	loc_c_091D		; Jump if equal
		mov	cl,data_b_0571
		or	cl,data_b_056E
		jnz	loc_c_0926		; Jump if not zero
loc_c_091D:
		push	dx
		push	ax
		call	sub_c_13D8		; Check light pen
		pop	ax
		pop	dx
		jz	loc_ret_c_08FC		; Jump if zero
loc_c_0926:
		mov	data_b_057D,dx
		mov	data_b_057F,ax
		cmp	word ptr data_b_0004,4	; current scene 1..7, 0=intro
		jne	loc_c_093B		; Jump if not equal
		cmp	data_b_39E1,0
		jne	loc_ret_c_08FC		; Jump if not equal
loc_c_093B:
		cmp	word ptr data_b_0004,6	; current scene 1..7, 0=intro
		jne	loc_c_0949		; Jump if not equal
		cmp	data_b_44BD,0
		jne	loc_ret_c_08FC		; Jump if not equal
loc_c_0949:
		cmp	word ptr data_b_0004,2	; current scene 1..7, 0=intro
		je	loc_c_0953		; Jump if equal
		jmp	loc_c_0BAC
loc_c_0953:
		mov	si,data_b_0008
		shl	si,1			; Shift w/zeros fill
		mov	ax,data_b_057D
		sub	ax,data_b_05F1
		cmp	ax,data_b_0589[si]
		jb	loc_c_09D6		; Jump if below
		cmp	ax,data_b_0599[si]
		jb	loc_c_0971		; Jump if below
		mov	data_b_0552,1
loc_c_0971:
		dec	data_b_05F5
		jnz	loc_c_09B9		; Jump if not zero
		call	sub_c_597F
		mov	data_b_05F5,6
		mov	al,data_b_05F4
		cmp	data_b_057B,0B3h
		jb	loc_c_0992		; Jump if below
		cmp	al,0C8h
		jae	loc_c_0992		; Jump if above or =
		add	al,1Eh
		mov	data_b_05F4,al
loc_c_0992:
		mov	dl,data_b_057B
		sub	dl,al
		jnc	loc_c_099C		; Jump if carry=0
		sub	dl,dl
loc_c_099C:
		mov	cx,data_b_0579
		and	dl,0F8h
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,offset data_b_064E
		mov	ax,0B800h
		mov	es,ax
		mov	bp,offset data_b_000E
		mov	cx,503h
		call	sub_c_2D35
loc_c_09B9:
		mov	data_b_056E,0
		mov	data_b_0571,1
		mov	data_b_05F3,1
		mov	data_b_0576,20h		; ' '

		; set color palettes
		sub	bx,bx
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		jmp	loc_c_0A86

loc_c_09D6:	mov	si,data_b_0008
		shl	si,1			; Shift w/zeros fill
		sub	bx,bx
		cmp	ax,data_b_05A9[si]
		jb	loc_c_09F6		; Jump if below
		inc	bl
		cmp	ax,data_b_05B9[si]
		jb	loc_c_09F6		; Jump if below
		mov	bl,5
		cmp	ax,data_b_05C9[si]
		jb	loc_c_09F6		; Jump if below
		dec	bl
loc_c_09F6:
		; set color palette
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	al,data_b_056E
		mov	data_b_056F,al
		mov	al,data_b_0571
		mov	data_b_0570,al
		mov	al,data_b_0698		; horizontal move 1=right, -1=left, 0=none
		cmp	al,0
		jne	loc_c_0A1A		; Jump if not equal
		cmp	data_b_0574,10h
		jb	loc_c_0A2E		; Jump if below
		dec	data_b_0574
		jmp	short loc_c_0A37
loc_c_0A1A:
		cmp	al,data_b_056E
		jne	loc_c_0A2E		; Jump if not equal
		cmp	data_b_0574,30h
		jae	loc_c_0A37		; Jump if above or =
		add	data_b_0574,3
		jmp	short loc_c_0A37
loc_c_0A2E:
		mov	data_b_056E,al
		mov	data_b_0574,20h
loc_c_0A37:
		mov	ax,data_b_0574
		mov	cl,3
		shr	ax,cl			; Shift w/zeros fill
		mov	bx,data_b_0008
		shl	bl,1			; Shift w/zeros fill
		cmp	ax,data_b_066C[bx]
		jbe	loc_c_0A4E		; Jump if below or =
		mov	ax,data_b_066C[bx]
loc_c_0A4E:
		mov	data_b_0572,ax
		call	sub_c_0FC9
		mov	al,data_b_0699		; vertical move 1=down, -1=up, 0=none
		cmp	al,0
		jne	loc_c_0A6A		; Jump if not equal
		not	al
		cmp	data_b_0576,10h
		jb	loc_c_0A7E		; Jump if below
		dec	data_b_0576
		jmp	short loc_c_0A86
loc_c_0A6A:
		cmp	al,data_b_0571
		jne	loc_c_0A7E		; Jump if not equal
		cmp	data_b_0576,40h		; '@'
		jae	loc_c_0A86		; Jump if above or =
		add	data_b_0576,4
		jmp	short loc_c_0A86
loc_c_0A7E:
		mov	data_b_0571,al
		mov	data_b_0576,20h		; ' '
loc_c_0A86:
		mov	si,data_b_0008
		mov	dl,data_b_057B
		mov	cl,4
		mov	bl,data_b_0576
		shr	bl,cl			; Shift w/zeros fill
		cmp	bl,data_b_067C[si]
		jbe	loc_c_0AA0		; Jump if below or =
		mov	bl,data_b_067C[si]
loc_c_0AA0:
		mov	al,data_b_0571
		cmp	al,1
		jb	loc_c_0ACE		; Jump if below
		jnz	loc_c_0AB4		; Jump if not zero
		add	dl,bl
		cmp	dl,0B4h
		jb	loc_c_0ACE		; Jump if below
		mov	dl,0B3h
		jmp	short loc_c_0ACE
loc_c_0AB4:
		sub	dl,bl
		jc	loc_c_0ABD		; Jump if carry Set
		cmp	dl,3
		ja	loc_c_0ACE		; Jump if above
loc_c_0ABD:
		mov	ax,data_b_09B8
		cmp	ax,data_b_055D
		jne	loc_c_0ACC		; Jump if not equal
		mov	ax,data_b_057D
		mov	data_b_05F1,ax
loc_c_0ACC:
		mov	dl,2
loc_c_0ACE:
		mov	data_b_057B,dl
		mov	cx,data_b_0579
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_0563,ax
		cmp	data_b_05F3,0
		je	loc_c_0AE9		; Jump if equal
		mov	bx,10h
		jmp	short loc_c_0B64
		db	90h
loc_c_0AE9:
		mov	al,data_b_056E
		cmp	al,data_b_056F
		jne	loc_c_0AFB		; Jump if not equal
		mov	al,data_b_0571
		cmp	al,data_b_0570
		je	loc_c_0B00		; Jump if equal
loc_c_0AFB:
		mov	bx,offset data_b_0018
		jmp	short loc_c_0B64
loc_c_0B00:
		inc	data_b_0587
		mov	bx,data_b_0587
		mov	al,data_b_0698		; horizontal move 1=right, -1=left, 0=none
		or	al,data_b_0699		; vertical move 1=down, -1=up, 0=none
		jnz	loc_c_0B13		; Jump if not zero
		shr	bl,1			; Shift w/zeros fill
loc_c_0B13:
		cmp	data_b_057B,0B3h
		jb	loc_c_0B21		; Jump if below
		cmp	data_b_0571,1
		je	loc_c_0B3C		; Jump if equal
loc_c_0B21:
		cmp	data_b_057B,4
		ja	loc_c_0B2F		; Jump if above
		cmp	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		jne	loc_c_0B53		; Jump if not equal
loc_c_0B2F:
		mov	al,data_b_0576
		sub	ah,ah
		shr	ax,1			; Shift w/zeros fill
		cmp	ax,data_b_0574
		jae	loc_c_0B53		; Jump if above or =
loc_c_0B3C:
		cmp	data_b_056E,0
		je	loc_c_0B53		; Jump if equal
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		cmp	data_b_056E,1
		je	loc_c_0B64		; Jump if equal
		or	bl,8
		jmp	short loc_c_0B64
loc_c_0B53:
;*		and	bx,2
		db	 81h,0E3h, 02h, 00h	;  Fixup - byte match
		or	bl,10h
		cmp	data_b_0571,1
		jne	loc_c_0B64		; Jump if not equal
		add	bl,4
loc_c_0B64:
		mov	ax,data_b_09A6[bx]
		mov	data_b_055D,ax
		mov	ax,data_b_09C0[bx]
		mov	data_b_0565,ax
		mov	al,30h			; '0'
		mov	cx,2BCh
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jb	loc_c_0B97		; Jump if below
		jz	loc_c_0B85		; Jump if zero
		mov	al,8
		mov	cx,3E8h
loc_c_0B85:
		cmp	data_b_057B,al
		ja	loc_c_0B97		; Jump if above
loc_c_0B8B:
		call	sub_c_13D8		; Check light pen
		jnz	loc_c_0B8B		; Jump if not zero
loc_c_0B90:
		call	sub_c_13D8		; Check light pen
		jz	loc_c_0B90		; Jump if zero

locloop_c_0B95:
		loop	locloop_c_0B95		; Loop if cx > 0

loc_c_0B97:
		call	sub_c_11E3
		mov	ax,data_b_0563
		mov	data_b_055F,ax
		call	sub_c_1145
		call	sub_c_34A0
		jnc	loc_ret_c_0BAB		; Jump if carry=0
		call	sub_c_1145

loc_ret_c_0BAB:
		retn
loc_c_0BAC:
		call	sub_c_1B7A
		jnc	loc_c_0BB2		; Jump if carry=0

loc_ret_c_0BB1:
		retn
loc_c_0BB2:
		cmp	data_b_1CB8,0
		jne	loc_ret_c_0BB1		; Jump if not equal
		cmp	data_b_0558,0
		je	loc_c_0C1C		; Jump if equal
		cmp	data_b_0559,0
		je	loc_c_0BD3		; Jump if equal
		cmp	data_b_1CBF,0
		jne	loc_ret_c_0BD2		; Jump if not equal
		dec	data_b_0559

loc_ret_c_0BD2:
		retn
loc_c_0BD3:
		dec	data_b_0558
		jnz	loc_c_0BE5		; Jump if not zero
		mov	data_b_0572,8
		call	sub_c_0FC9
		jmp	short loc_c_0C1C
		db	90h
loc_c_0BE5:
		call	sub_c_1020
		mov	data_b_055D,bx
		mov	al,data_b_0558
		mov	ah,data_b_056E
		call	sub_c_0F87
		cmp	data_b_0558,2
		je	loc_c_0C00		; Jump if equal
		call	sub_c_11E3
loc_c_0C00:
		call	sub_c_1B7A
		jc	loc_ret_c_0C1B		; Jump if carry Set
		call	sub_c_20F5
		jc	loc_ret_c_0C1B		; Jump if carry Set
		mov	dl,data_b_057B
		mov	cx,data_b_0579
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_055F,ax
		call	sub_c_1145

loc_ret_c_0C1B:
		retn
loc_c_0C1C:
		cmp	data_b_055C,1
		jb	loc_c_0C6A		; Jump if below
		jnz	loc_c_0C5F		; Jump if not zero
		inc	data_b_055C
		mov	data_b_0572,6
		mov	dl,data_b_057B
		mov	cx,data_b_0579
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_0563,ax
		call	sub_c_11E3
		call	sub_c_1B7A
		jc	loc_ret_c_0C66		; Jump if carry Set
		call	sub_c_20F5
		jc	loc_ret_c_0C66		; Jump if carry Set
		mov	ax,data_b_0563
		mov	data_b_055F,ax
		mov	data_b_0565,0E03h
		mov	data_b_055D,9DAh
		call	sub_c_1145
loc_c_0C5F:
		cmp	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		jne	loc_c_0C67		; Jump if not equal

loc_ret_c_0C66:
		retn
loc_c_0C67:
		jmp	loc_c_0E78
loc_c_0C6A:
		cmp	data_b_0571,0
		jne	loc_c_0C74		; Jump if not equal
		jmp	loc_c_0E23
loc_c_0C74:
		call	sub_c_0FC9
		jnc	loc_c_0C90		; Jump if carry=0
		mov	data_b_056E,0
		mov	data_b_0576,2
		mov	data_b_0571,1
		mov	data_b_055B,0
		jmp	short loc_c_0CC1
		db	90h
loc_c_0C90:
		mov	al,data_b_0578
		sub	data_b_0577,al
		jnc	loc_c_0CC1		; Jump if carry=0
		cmp	data_b_0571,1
		je	loc_c_0CB6		; Jump if equal
		cmp	data_b_0576,1
		jbe	loc_c_0CAE		; Jump if below or =
		dec	data_b_0576
		jmp	short loc_c_0CC1
		db	90h
loc_c_0CAE:
		mov	data_b_0571,1
		jmp	short loc_c_0CC1
		db	90h
loc_c_0CB6:
		cmp	data_b_0576,4
		jae	loc_c_0CC1		; Jump if above or =
		inc	data_b_0576
loc_c_0CC1:
		cmp	data_b_055A,0
		jne	loc_c_0CE7		; Jump if not equal
		cmp	data_b_055B,0
		je	loc_c_0CD5		; Jump if equal
		dec	data_b_055B
		jnz	loc_c_0CE7		; Jump if not zero
loc_c_0CD5:
		cmp	data_b_0571,1
		jne	loc_c_0CE7		; Jump if not equal
		call	sub_c_1608
		jnc	loc_c_0CE7		; Jump if carry=0
		mov	al,data_b_057C
		jmp	short loc_c_0D29
		db	90h
loc_c_0CE7:
		mov	al,data_b_057C
		cmp	data_b_0571,1
		je	loc_c_0D06		; Jump if equal
		sub	al,data_b_0576
		jnc	loc_c_0D4F		; Jump if carry=0
		sub	al,al
		mov	data_b_0571,1
		mov	data_b_0576,1
		jmp	short loc_c_0D4F
		db	90h
loc_c_0D06:
		add	al,data_b_0576
		cmp	al,0E6h
		jbe	loc_c_0D4F		; Jump if below or =
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_0D22		; Jump if not equal
		cmp	al,0F8h
		jb	loc_c_0D4F		; Jump if below
		mov	al,0F8h
		mov	data_b_0551,1
		jmp	short loc_c_0D4F
loc_c_0D22:
		mov	al,0E6h
		mov	data_b_0550,0
loc_c_0D29:
		mov	data_b_0571,0
		mov	data_b_0584,0
		mov	data_b_0572,2
		mov	data_b_055B,0
		mov	data_b_055A,0
		cmp	data_b_055C,0
		je	loc_c_0D4F		; Jump if equal
		push	ax
		call	sub_c_5AC2
		pop	ax
loc_c_0D4F:
		mov	data_b_057C,al
		sub	al,32h			; '2'
		jnc	loc_c_0D58		; Jump if carry=0
		sub	al,al
loc_c_0D58:
		mov	data_b_057B,al
		mov	dl,data_b_057B
		mov	cx,data_b_0579
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_0563,ax
		cmp	data_b_0583,0
		jne	loc_c_0D73		; Jump if not equal
		call	sub_c_11E3
loc_c_0D73:
		call	sub_c_1B7A
		jc	loc_c_0DC4		; Jump if carry Set
		call	sub_c_20F5
		jc	loc_c_0DC4		; Jump if carry Set
		mov	ax,data_b_0563
		mov	data_b_055F,ax
		cmp	data_b_0584,0
		je	loc_c_0DA1		; Jump if equal
		add	data_b_0585,2
		mov	bx,data_b_0585
;*		and	bx,0Eh
		db	 81h,0E3h, 0Eh, 00h	;  Fixup - byte match
		mov	ax,data_b_0FC2[bx]
		mov	bx,data_b_0FD2[bx]
		jmp	short loc_c_0DA8
loc_c_0DA1:
		mov	ax,data_b_0569
		mov	bx,data_b_0567
loc_c_0DA8:
		mov	data_b_055D,ax
		mov	data_b_0565,bx
		mov	al,32h			; '2'
		sub	al,data_b_057C
		jz	loc_c_0DDE		; Jump if zero
		jc	loc_c_0DDE		; Jump if carry Set
		mov	cx,168h

locloop_c_0DBC:
		loop	locloop_c_0DBC		; Loop if cx > 0

		sub	bh,al
		jz	loc_c_0DC4		; Jump if zero
		jnc	loc_c_0DCA		; Jump if carry=0
loc_c_0DC4:
		mov	data_b_0583,1
		retn
loc_c_0DCA:
		mov	data_b_0565,bx
		mov	ah,bl
		shl	ah,1			; Shift w/zeros fill
		mul	ah			; ax = reg * al
		add	ax,data_b_0569
		mov	data_b_055D,ax
		jmp	short loc_c_0E1F
		db	90h
loc_c_0DDE:
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_0DEE		; Jump if not equal
		mov	al,data_b_057B
		sub	al,0BBh
		jc	loc_c_0E1F		; Jump if carry Set
		jnc	loc_c_0DFC		; Jump if carry=0
loc_c_0DEE:
		cmp	data_b_0550,2
		jne	loc_c_0E1F		; Jump if not equal
		mov	al,data_b_057B
		sub	al,5Eh			; '^'
		jc	loc_c_0E1F		; Jump if carry Set
loc_c_0DFC:
		sub	bh,al
		jz	loc_c_0E02		; Jump if zero
		jnc	loc_c_0E16		; Jump if carry=0
loc_c_0E02:
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_0E0F		; Jump if not equal
		mov	data_b_0551,1
		retn
loc_c_0E0F:
		call	sub_c_070D		; Load image ??? from screen to bufer
		call	sub_c_59CB
		retn
loc_c_0E16:
		mov	data_b_0565,bx
		mov	data_b_0576,2
loc_c_0E1F:
		call	sub_c_1145
		retn
loc_c_0E23:
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		je	loc_c_0E31		; Jump if equal
		cmp	data_b_057B,0B4h
		jae	loc_c_0E78		; Jump if above or =
loc_c_0E31:
		call	sub_c_1608
		jc	loc_c_0E43		; Jump if carry Set
		mov	data_b_056E,0
		mov	data_b_0571,1
		jmp	short loc_c_0EB1
		db	90h
loc_c_0E43:
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		jne	loc_c_0E78		; Jump if not equal
		call	sub_c_22F7
		jc	loc_c_0E56		; Jump if carry Set
		mov	data_b_056C,0
		jmp	short loc_c_0E78
loc_c_0E56:
		cmp	data_b_056C,0
		jne	loc_c_0E60		; Jump if not equal
		call	sub_c_591F
loc_c_0E60:
		mov	data_b_0699,1		; vertical move 1=down, -1=up, 0=none
		mov	data_b_056C,1
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_0E74		; Jump if not zero
		mov	dl,0FFh
loc_c_0E74:
		mov	data_b_0698,dl		; horizontal move 1=right, -1=left, 0=none
loc_c_0E78:
		mov	al,data_b_056E
		mov	data_b_056F,al
		mov	al,data_b_0698		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_056E,al
		mov	al,data_b_0699		; vertical move 1=down, -1=up, 0=none
		mov	data_b_0571,al
		cmp	al,0
		jne	loc_c_0E91		; Jump if not equal
		jmp	loc_c_0F34
loc_c_0E91:
		cmp	data_b_0571,1
		jne	loc_c_0EC9		; Jump if not equal
		cmp	data_b_057B,0B4h
		jb	loc_c_0EB1		; Jump if below
		mov	data_b_0571,0
		mov	data_b_0584,0
		mov	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		jmp	loc_c_0F34
loc_c_0EB1:
		mov	ah,1
		mov	al,20h			; ' '
		mov	data_b_055B,8
		cmp	data_b_0550,1
		jne	loc_c_0EF1		; Jump if not equal
		mov	data_b_0550,0
		jmp	short loc_c_0EF1
		db	90h
loc_c_0EC9:
		mov	data_b_055B,0
		mov	ax,data_b_0572
		mov	bl,al
		cmp	al,2
		jbe	loc_c_0ED9		; Jump if below or =
		sub	al,2
loc_c_0ED9:
		mov	data_b_0572,ax
		mov	ah,8
		mov	al,bl
		xor	al,0Fh
		mov	cl,4
		shl	al,cl			; Shift w/zeros fill
		cmp	data_b_0550,1
		jne	loc_c_0EF1		; Jump if not equal
		inc	data_b_0550
loc_c_0EF1:
		mov	data_b_0578,al
		mov	data_b_0576,ah
		mov	data_b_0577,1
		mov	data_b_055C,0
		mov	bl,data_b_056E
		inc	bl
		shl	bl,1			; Shift w/zeros fill
		cmp	data_b_0571,0FFh
		je	loc_c_0F14		; Jump if equal
		add	bl,6
loc_c_0F14:
		sub	bh,bh
		mov	ax,data_b_0FAA[bx]
		mov	data_b_0569,ax
		mov	ax,data_b_0FB6[bx]
		mov	data_b_0567,ax
		mov	data_b_39E0,0
		cmp	data_b_127C,0
		je	loc_ret_c_0F33		; Jump if equal
		call	sub_c_58F8

loc_ret_c_0F33:
		retn
loc_c_0F34:
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		je	loc_c_0F45		; Jump if equal
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		je	loc_c_0F45		; Jump if equal
		call	sub_c_3445
loc_c_0F45:
		call	sub_c_0FC9
		mov	dl,data_b_057B
		mov	cx,data_b_0579
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_0563,ax
		mov	al,data_b_056E
		or	al,data_b_0571
		jnz	loc_c_0F63		; Jump if not zero
		call	sub_c_1069
		retn
loc_c_0F63:
		call	sub_c_1020
		mov	data_b_055D,bx
		call	sub_c_11E3
		call	sub_c_1B7A
		jc	loc_ret_c_0F86		; Jump if carry Set
		call	sub_c_20F5
		jc	loc_ret_c_0F86		; Jump if carry Set
		mov	ax,data_b_0563
		mov	data_b_055F,ax
		mov	data_b_0565,0B03h
		call	sub_c_1145

loc_ret_c_0F86:
		retn
sub_c_08E5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_0F87	proc	near
		mov	cx,0B03h
		sub	cl,al
		mov	data_b_0565,cx
		cmp	ah,0FFh
		je	loc_c_0FA6		; Jump if equal
		sub	ah,ah
		shl	al,1			; Shift w/zeros fill
		add	data_b_055D,ax
		mov	data_b_0579,0
		jmp	short loc_c_0FB4
		db	90h
loc_c_0FA6:
		sub	ah,ah
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	ax,128h
		mov	data_b_0579,ax
loc_c_0FB4:
		push	ds
		pop	es
		mov	si,data_b_055D
		mov	di,offset data_b_000E
		mov	al,3
		call	sub_c_2D70
		mov	data_b_055D,0Eh
		retn
sub_c_0F87	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_0FC9	proc	near
		mov	data_b_05F6,8
		mov	data_b_05F8,123h
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_0FE8		; Jump if not equal
		mov	data_b_05F6,24h
		mov	data_b_05F8,10Fh
loc_c_0FE8:
		mov	ax,data_b_0579
		cmp	data_b_056E,1
		jb	loc_c_101E		; Jump if below
		jnz	loc_c_1007		; Jump if not zero
		add	ax,data_b_0572
		cmp	ax,data_b_05F8
		jb	loc_c_101B		; Jump if below
		mov	ax,data_b_05F8
		dec	ax
		mov	data_b_0579,ax
		stc				; Set carry flag
		retn
loc_c_1007:
		sub	ax,data_b_0572
		jc	loc_c_1013		; Jump if carry Set
		cmp	ax,data_b_05F6
		jae	loc_c_101B		; Jump if above or =
loc_c_1013:
		mov	ax,data_b_05F6
		mov	data_b_0579,ax
		stc				; Set carry flag
		retn
loc_c_101B:
		mov	data_b_0579,ax
loc_c_101E:
		clc				; Clear carry flag
		retn
sub_c_0FC9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1020	proc	near
		mov	al,data_b_056E
		cmp	al,data_b_056F
		je	loc_c_102F		; Jump if equal
		mov	data_b_0572,2
loc_c_102F:
		cmp	data_b_0572,8
		jae	loc_c_1045		; Jump if above or =
		dec	data_b_0577
		mov	al,data_b_0577
		and	al,3
		jnz	loc_c_1045		; Jump if not zero
		inc	data_b_0572
loc_c_1045:
		mov	bl,data_b_056B
		inc	bl
		cmp	bl,6
		jb	loc_c_1052		; Jump if below
		mov	bl,0
loc_c_1052:
		mov	data_b_056B,bl
		cmp	data_b_056E,0FFh
		jne	loc_c_1060		; Jump if not equal
		add	bl,6
loc_c_1060:
		shl	bl,1			; Shift w/zeros fill
		sub	bh,bh
		mov	bx,data_b_0F7A[bx]
		retn
sub_c_1020	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1069	proc	near
		mov	data_b_0572,2
		mov	data_b_0577,8
		cmp	data_b_0561,0C02h
		jne	loc_c_1087		; Jump if not equal
		inc	data_b_056D
		test	data_b_056D,7
		jnz	loc_ret_c_10DC		; Jump if not zero
loc_c_1087:
		call	sub_c_11E3
		call	sub_c_1B7A
		jc	loc_ret_c_10DC		; Jump if carry Set
		call	sub_c_20F5
		jc	loc_ret_c_10DC		; Jump if carry Set
		call	sub_c_2DFD
		mov	bl,dl
;*		and	bx,0Eh
		db	 81h,0E3h, 0Eh, 00h	;  Fixup - byte match
		mov	si,data_b_0F92[bx]
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_055F
		mov	bp,offset data_b_05FA
		mov	data_b_0561,0C02h
		mov	cx,602h
		call	sub_c_2D35
		call	sub_c_2DFD
		mov	bl,dl
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		mov	si,data_b_0FA2[bx]
		mov	di,data_b_055F
		add	di,d_B800_00F0_e
		mov	bp,offset data_b_0612
		mov	cx,602h
		call	sub_c_2D35
		mov	data_b_0583,0

loc_ret_c_10DC:
		retn
sub_c_1069	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_10DD	proc	near
		mov	data_b_055C,0
		mov	data_b_0571,1
		mov	data_b_0576,2
		mov	data_b_0578,1
		mov	data_b_0577,0FFh
		mov	data_b_056E,0
		mov	data_b_055A,1
		mov	ax,data_b_0FAC
		mov	data_b_0569,ax
		mov	ax,data_b_0FB8
		mov	data_b_0567,ax
		mov	data_b_0550,2
		retn
sub_c_10DD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1112	proc	near
		mov	cx,data_b_0579
		mov	dl,data_b_057B
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_055F,ax
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
		retn
sub_c_1112	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)

sub_c_1124	proc	near
		mov	ax,seg_b
		mov	es,ax
		mov	di,d_B800_05FA_e	; destination address of buffer
		push	ds
		mov	si,data_b_055F		; source address of image
		mov	ax,0B800h
		mov	ds,ax
		mov	cx,es:data_b_0561	; image size
		call	sub_c_2DCA		; Load part of screen into buffer (ES:DI=dst buffer, DS:SI=source screen, CL=width, CH=height)
		pop	ds
		mov	data_b_0583,0
		retn
sub_c_1124	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1145	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_055F
		mov	bp,offset data_b_05FA
		mov	si,data_b_055D
		mov	cx,data_b_0565
		mov	data_b_0561,cx
		mov	data_b_0583,0
		call	sub_c_2D35
		retn
sub_c_1145	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1166	proc	near
		mov	dl,data_b_057B
		mov	cx,data_b_0579
		sub	cx,0Ch
		jnc	loc_c_1175		; Jump if carry=0
		sub	cx,cx
loc_c_1175:
		cmp	cx,10Fh
		jb	loc_c_117E		; Jump if below
		mov	cx,10Eh
loc_c_117E:
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_0581,ax
		mov	di,ax
		mov	ax,0B800h
		mov	es,ax
		mov	bp,offset data_b_000E
		mov	si,offset data_b_1679
		mov	cx,1205h
		call	sub_c_2CCC

		; load system timer
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_057F,dx
		mov	word ptr data_b_5A3C,0
		mov	data_b_5A3E,0

		; wait 10 timer ticks
loc_c_11AB:
		call	sub_c_5A1C
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_057F
		cmp	dx,0Ah
		jb	loc_c_11AB		; Jump if below

		call	sub_c_5B21		; Disable sound output
		mov	di,data_b_0581
		mov	si,offset data_b_000E
		mov	cx,1205h
		mov	data_b_0583,0
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		cmp	data_b_1678,0
		je	loc_ret_c_11E2		; Jump if equal

		; decrease cat lives
		cmp	data_b_1F80,0		; cat lives (1..9)
		je	loc_ret_c_11E2		; Jump if equal
		dec	data_b_1F80		; cat lives (1..9)

loc_ret_c_11E2:	retn

sub_c_1166	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_11E3	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_055F
		mov	si,offset data_b_05FA
		mov	cx,data_b_0561
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_11E3	endp

		db	9 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input from joystick or keyboard

sub_c_1200	proc	near

		; get system timer
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_069F		; old system timer during key input
		cmp	ax,2
		jae	loc_c_1210		; Jump if above or =
		retn

		; control cat with keyboard
loc_c_1210:	mov	data_b_069F,dx		; old system timer during key input
		cmp	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		jne	loc_c_122E		; Jump if not equal - input from joystick
		call	sub_c_12C1		; Control cat with keyboard (move and drinking)
		call	sub_c_13B7		; Get 8253 timer count
		mov	dx,ax

		; wait a while
loc_c_1223:	call	sub_c_13B7		; Get 8253 timer count
		sub	ax,dx
		cmp	ax,0F8EDh
		jb	loc_c_1223		; Jump if below
		retn

		; control cat with joystick
loc_c_122E:	mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		and	al,10h
		mov	data_b_069A,al		; key Alt drinking (0=pressed, 10h=released)

		mov	data_b_069E,3
		call	sub_c_13B7		; Get 8253 timer count
		mov	data_b_069C,ax
		out	dx,al			; port 201h, start game 1-shots
		mov	cx,7D0h

locloop_c_1246:	in	al,dx			; port 201h, start game 1-shots
		test	al,1
		jnz	loc_c_125E		; Jump if not zero
		test	data_b_069E,1
		jz	loc_c_125E		; Jump if zero
		and	data_b_069E,0FEh
		call	sub_c_12A1
		mov	data_b_0698,bl		; horizontal move 1=right, -1=left, 0=none

loc_c_125E:	test	al,2
		jnz	loc_c_1275		; Jump if not zero
		test	data_b_069E,2
		jz	loc_c_1275		; Jump if zero
		and	data_b_069E,0FDh
		call	sub_c_12A1
		mov	data_b_0699,bl		; vertical move 1=down, -1=up, 0=none

loc_c_1275:	test	data_b_069E,3
		jz	loc_ret_c_12A0		; Jump if zero
		call	sub_c_13B7		; Get 8253 timer count
		sub	ax,data_b_069C
		cmp	ax,1964h
		loopnz	locloop_c_1246		; Loop if zf=0, cx>0

		test	data_b_069E,1
		jz	loc_c_1294		; Jump if zero
		mov	data_b_0698,0FFh	; horizontal move 1=right, -1=left, 0=none

loc_c_1294:	test	data_b_069E,2
		jz	loc_ret_c_12A0		; Jump if zero
		mov	data_b_0699,0FFh	; vertical move 1=down, -1=up, 0=none

loc_ret_c_12A0:	retn

sub_c_1200	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_12A1	proc	near
		push	ax
		call	sub_c_13B7		; Get 8253 timer count
		sub	ax,data_b_069C
		mov	bx,ax
		pop	ax
		cmp	bx,0F5E6h
		jae	loc_c_12B5		; Jump if above or =
		mov	bl,1
		retn
loc_c_12B5:
		cmp	bx,0FAFAh
		jae	loc_c_12BE		; Jump if above or =
		sub	bl,bl
		retn
loc_c_12BE:
		mov	bl,0FFh
		retn
sub_c_12A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Control cat with keyboard (moving and drinking)

sub_c_12C1	proc	near

		; key [2 Down]
		mov	al,data_b_06BA		; key [2 Down] = move down (0=pressed, 80h=released)
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_12D3		; Jump if equal
		and	al,data_b_06BD		; key [3 PgDn] (0=pressed, 80h=released)
		and	al,data_b_06BE		; key [1 End] (0=pressed, 80h=released)
loc_c_12D3:	xor	al,80h
		jz	loc_c_12D9		; Jump if zero
		mov	al,1
loc_c_12D9:	mov	data_b_0699,al		; vertical move 1=down, -1=up, 0=none

		; key [8 Up]
		mov	al,data_b_06B8		; key [8 Up] = jump (0=pressed, 80h=released)
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_12EE		; Jump if equal
		and	al,data_b_06BC		; key [9 PgUp] (0=pressed, 80h=released)
		and	al,data_b_06BF		; key [7 Home] (0=pressed, 80h=released)
loc_c_12EE:	xor	al,80h
		jz	loc_c_12F7		; Jump if zero
		mov	data_b_0699,0FFh	; vertical move 1=down, -1=up, 0=none

		; key [6 right]
loc_c_12F7:	mov	al,data_b_06B9		; key [6 Right] = move right (0=pressed, 80h=released)
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_1309		; Jump if equal
		and	al,data_b_06BC		; key [9 PgUp] (0=pressed, 80h=released)
		and	al,data_b_06BD		; key [3 PgDn] (0=pressed, 80h=released)
loc_c_1309:	xor	al,80h
		jz	loc_c_130F		; Jump if zero
		mov	al,1
loc_c_130F:	mov	data_b_0698,al		; horizontal move 1=right, -1=left, 0=none

		; key [4 left]
		mov	al,data_b_06BB		; key [4 Left] = move left (0=pressed, 80h=released)
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_1324		; Jump if equal
		and	al,data_b_06BE		; key [1 End] (0=pressed, 80h=released)
		and	al,data_b_06BF		; key [7 Home] (0=pressed, 80h=released)
loc_c_1324:	xor	al,80h
		jz	loc_c_132D		; Jump if zero
		mov	data_b_0698,0FFh	; horizontal move 1=right, -1=left, 0=none

		; key Left Alt
loc_c_132D:	mov	al,data_b_06B7		; key Left Alt = drinking, special action (0=pressed, 80h=released)
		mov	cl,3
		shr	al,cl			; Shift w/zeros fill
		mov	data_b_069A,al		; key Alt drinking (0=pressed, 10h=released)
		retn
sub_c_12C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Input special keys during game

sub_c_1338	proc	near

		; check if new pressed key
		mov	ax,data_b_0693		; counter of pressed keys
		cmp	ax,data_b_0691		; old counter of pressed keys
		je	loc_ret_c_1357		; Jump if equal
		mov	data_b_0691,ax		; old counter of pressed keys

		; key Esc = pause
		test	data_b_06C0,80h		; key Esc = pause (0=pressed, 80h=released)
		jnz	loc_c_1358		; Jump if not zero

		; start Paws Game
		mov	ax,data_b_0693		; counter of pressed keys
		cmp	ax,data_b_6E00		; destination counter of pressed keys of "Paws Game"
		je	loc_ret_c_1357		; Jump if equal
		call	sub_c_5E70		; Display prompt "Paws Game" and wait for key
loc_ret_c_1357:	retn

		; key Left Ctrl
loc_c_1358:	test	data_b_06C9,80h		; key Left Ctrl (0=pressed, 80h=released)
		jz	loc_c_1360		; Jump if zero
		retn

; Left Cltr pressed

		; key 9 + Ctrl = reset lives
loc_c_1360:	test	data_b_06CC,80h		; key 9 + Ctrl = cheat to reset counter to 9 lives ( (0=pressed, 80h=released)
		jnz	loc_c_136D		; Jump if not zero
		mov	data_b_1F80,9		; cat lives (1..9)
		retn

		; key Y + Ctrl = exit game
loc_c_136D:	test	data_b_06C1,80h		; key Y + Ctrl = exit game (0=pressed, 80h=released)
		jz	loc_c_13A5		; Jump if zero

		; key M + Ctrl = game menu
		test	data_b_06CB,80h		; key M + Ctrl = game menu (0=pressed, 80h=released)
		jnz	loc_c_1381		; Jump if not zero
		mov	data_b_041C,0FFh	; 0ffh = request game menu
		retn

		; key R + Ctrl = restart game
loc_c_1381:	test	data_b_06C8,80h		; key R + Ctrl = restart (0=pressed, 80h=released)
		jnz	loc_c_138E		; Jump if not zero
		mov	data_b_041B,0FFh	; 0ffh = request restart game
		retn

		; key S + Ctrl = enable/disable sound
loc_c_138E:	test	data_b_06C7,80h		; key S + Ctrl = set sound (0=pressed, 80h=released)
		jnz	loc_ret_c_13A4		; Jump if not zero
		not	data_b_0000		; sound enabled
		cmp	data_b_0000,0
		jne	loc_ret_c_13A3		; Jump if not equal
		call	sub_c_5B21		; Disable sound output

loc_ret_c_13A3:	retn

loc_ret_c_13A4:	retn

		; exit game
loc_c_13A5:	call	sub_c_147F		; Return INT 09h handler
		pop	ax
		retf				; Return far

sub_c_1338	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get PC model

sub_c_13AA	proc	near
		mov	ax,0F000h
		mov	es,ax
		mov	al,es:d_F000_FFFE_e
		mov	data_b_0697,al		; PC model
		retn
sub_c_13AA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Get 8253 timer count

sub_c_13B7	proc	near
		mov	al,0
		out	43h,al			; port 43h, 8253 timer control
						;  al = 0, latch timer0 count
		nop
		nop
		in	al,40h			; port 40h, 8253 timer 0 clock
		mov	ah,al
		nop
		in	al,40h			; port 40h, 8253 timer 0 clock
		xchg	al,ah
		retn
sub_c_13B7	endp

			                        ;* No entry point to code
		call	sub_c_13B7		; Get 8253 timer count
		mov	bx,ax
		sub	ax,cx
		mov	cx,bx
		cmp	ax,dx
		jae	loc_c_13D5		; Jump if above or =
		retn
loc_c_13D5:
		cmp	dx,dx
		retn

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check light pen

sub_c_13D8	proc	near
		mov	dx,3DAh
		in	al,dx			; port 3DAh, CGA/EGA vid status
		and	al,8
		retn
sub_c_13D8	endp

data_c_13DF	db	0, 0		; old INT 09h
data_c_13E1	dw	0
data_c_13E3	dw	0
data_c_13E5	dw	0
data_c_13E7	db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Initialize keyboard buffer

sub_c_13E8	proc	near
		push	ax
		push	es
		push	di
		push	cx

		mov	ax,seg_b
		mov	es,ax

		; clear keyboard buffer - set all keys to 80h (= released)
		cld				; Clear direction
		mov	di,offset data_b_06B7	; table of keys, 80h = key was released
		mov	cx,16h
		mov	al,80h
		rep	stosb			; Rep when cx >0 Store al to es:[di]

		mov	ax,es:data_b_0693	; counter of pressed keys
		sub	ax,70h
		mov	es:data_b_0691,ax	; old counter of pressed keys
		mov	ax,40h
		mov	es,ax
		mov	al,es:d_0040_0012_e
		mov	cs:data_c_13E7,al

		pop	cx
		pop	di
		pop	es
		pop	ax
		retn
sub_c_13E8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Install INT 09h handler (and INT 48h on PCjr)

sub_c_1419	proc	near
		sub	ax,ax
		mov	es,ax
		mov	ax,es:d_0000_0024_e
		mov	bx,es:d_0000_0026_e
		mov	cx,es:d_0000_0120_e
		mov	dx,es:d_0000_0122_e
		mov	word ptr cs:data_c_13DF,ax	; old INT 09h
		mov	cs:data_c_13E1,bx
		mov	cs:data_c_13E3,cx
		mov	cs:data_c_13E5,dx
		mov	bx,14B3h
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_1450		; Jump if not equal
		mov	bx,14FBh
loc_c_1450:
		cli				; Disable interrupts
		mov	es:d_0000_0024_e,bx
		mov	es:d_0000_0026_e,cs
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_147D		; Jump if not equal
		mov	word ptr es:d_0000_0120_e,1554h ; INT 48h
		mov	es:d_0000_0122_e,cs
		mov	ax,40h
		mov	es,ax
		mov	al,es:d_0040_0018_e
		or	al,1
		mov	es:d_0040_0018_e,al
loc_c_147D:
		sti				; Enable interrupts
		retn
sub_c_1419	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Return INT 09h handler

sub_c_147F	proc	near
		sub	ax,ax
		mov	es,ax
		mov	ax,word ptr cs:data_c_13DF	; old INT 09h
		mov	bx,cs:data_c_13E1
		mov	cx,cs:data_c_13E3
		mov	dx,cs:data_c_13E5
		cli				; Disable interrupts
		mov	es:d_0000_0024_e,ax
		mov	es:d_0000_0026_e,bx
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_14B1		; Jump if not equal
		mov	es:d_0000_0120_e,cx
		mov	es:d_0000_0122_e,dx
loc_c_14B1:
		sti				; Enable interrupts
		retn
sub_c_147F	endp

; 14B3h: INT 09h handler
			                        ;* No entry point to code
		push	ax
		push	es
		push	di
		push	cx

		mov	di,seg seg_b
		mov	es,di

		; input key
		in	al,60h			; port 60h, keybd scan or sw1
		mov	ah,al
		and	al,7Fh

		; update counter of pressed keys
		test	ah,80h			; release?
		jnz	loc_c_14CC		; Jump if not zero
		inc	es:data_b_0693		; counter of pressed keys

		; scan key
loc_c_14CC:	mov	di,offset data_b_06A1	; ('8HMPKIQOG')
		mov	cx,16h
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_c_14E3		; Jump if not zero

		; key found
		sub	di,6A2h			; DI = key index
		and	ah,80h			; AH <- release flag
		mov	es:data_b_06B7[di],ah	; store release flag

		; reset keyboard
loc_c_14E3:  	in	al,61h			; port 61h, 8255 port B, read
		mov	ah,al
		or	al,80h
		out	61h,al			; port 61h, 8255 B - spkr, etc
		mov	al,ah
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		call	sub_c_1572
		pop	cx
		pop	di
		pop	es

		; enable interrupt
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		pop	ax
		iret				; Interrupt return

; 14FBh: INT 09h handler for PCjr
			                        ;* No entry point to code
		sti				; Enable interrupts
		push	ax
		push	es
		push	di
		push	cx

		mov	di,seg seg_b
		mov	es,di

		mov	ah,al
		and	al,7Fh
		test	ah,80h
		jnz	loc_c_1513		; Jump if not zero
		inc	es:data_b_0693		; counter of pressed keys
loc_c_1513:
		cmp	ah,0FFh
		je	loc_c_1530		; Jump if equal
		cmp	ah,55h			; 'U'
		je	loc_c_1530		; Jump if equal
		push	es
		mov	di,40h
		mov	es,di
		mov	cl,es:d_0040_0012_e
		pop	es
		cmp	cl,cs:data_c_13E7
		je	loc_c_1535		; Jump if equal
loc_c_1530:
		call	sub_c_13E8		; Initialize keyboard buffer
		jmp	short loc_c_154C

		; find scan code in table
loc_c_1535:	mov	di,offset data_b_06A1	; ('8HMPKIQOG')
		mov	cx,16h
		cld				; Clear direction
		repne	scasb			; Rep zf=0+cx >0 Scan es:[di] for al
		jnz	loc_c_154C		; Jump if not zero

		; store key flag
		sub	di,6A2h			; key index
		and	ah,80h			; release flag
		mov	es:data_b_06B7[di],ah	; store release flag

loc_c_154C:	call	sub_c_1572
		pop	cx
		pop	di
		pop	es
		pop	ax
		iret				; Interrupt return

; 1554h INT 48h handler for PCjr

		db	0CDh, 09h,0CFh
loc_c_1557:
		mov	ax,0F000h
		mov	ss,ax
		mov	ax,40h
		mov	ds,ax
		mov	bx,d_0040_0072_e
		mov	word ptr [bx],1234h
		mov	ax,0
		mov	es,ax
;*		jmp	far ptr l_F000_E05B	;*
		db	0EAh
		dw	0E05Bh, 0F000h		;  Fixup - byte match

sub_c_1572	proc	near

		mov	al,es:data_b_06C9	; key Left Ctrl (0=pressed, 80h=released)
		or	al,es:data_b_06B7	; key Left Alt = drinking, special action (0=pressed, 80h=released)
		cmp	al,0
		jne	loc_ret_c_15C9		; Jump if not equal
		test	es:data_b_06CA,80h	; key [. Del] (0=pressed, 80h=released)
		jnz	loc_c_158D		; Jump if not zero

		; release interrupt controller
		mov	al,20h			; ' '
		out	20h,al			; port 20h, 8259-1 int command
						;  al = 20h, end of interrupt
		jmp	short loc_c_1557

; shift screen position

loc_c_158D:	test	es:data_b_06B9,80h	; key [6 Right] = move right (0=pressed, 80h=released)
		jnz	loc_c_15A4		; Jump if not zero
		cmp	es:data_b_0690,1
		jb	loc_ret_c_15C9		; Jump if below
		dec	es:data_b_0690
		jmp	short loc_c_15B9

loc_c_15A4:	test	es:data_b_06BB,80h	; key [4 Left] = move left (0=pressed, 80h=released)
		jnz	loc_ret_c_15C9		; Jump if not zero
		cmp	es:data_b_0690,7
		jae	loc_ret_c_15C9		; Jump if above or =
		inc	es:data_b_0690

loc_c_15B9:	push	dx
		mov	al,2
		mov	dx,3D4h
		out	dx,al			; port 3D4h, CGA/EGA reg index
						;  al = 2, horz sync position
		mov	al,es:data_b_0690
		add	al,27h			; '''
		inc	dx
		out	dx,al			; port 3D5h, CGA/EGA indxd data
		pop	dx

loc_ret_c_15C9:	retn
sub_c_1572	endp

		db	0, 0, 0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_15D0	proc	near

		mov	bx,data_b_0008
		mov	cl,data_b_100E[bx]
loc_c_15D8:
		call	sub_c_2DFD
		and	dl,7
		cmp	dl,cl
		ja	loc_c_15D8		; Jump if above
		add	dl,data_b_1006[bx]
		cmp	dl,data_b_1028
		je	loc_c_15D8		; Jump if equal
		mov	data_b_1028,dl
		mov	bl,dl
		mov	cl,data_b_0FF0[bx]
		mov	dl,88h
		test	cl,80h
		jnz	loc_c_15FF		; Jump if not zero
		mov	dl,90h
loc_c_15FF:

;		and	cx,7Fh
		db	81h, 0e1h, 7Fh, 0

		shl	cx,1			; Shift w/zeros fill
		shl	cx,1			; Shift w/zeros fill
		retn
sub_c_15D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1608	proc	near
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_1613		; Jump if not equal
		call	sub_c_30FA
		retn
loc_c_1613:
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		je	loc_c_161E		; Jump if equal
		call	sub_c_16C6
		retn
loc_c_161E:
		mov	al,data_b_057B
		and	al,0F8h
		cmp	al,60h			; '`'
		je	loc_c_1630		; Jump if equal
		call	sub_c_1657
		jc	loc_ret_c_1656		; Jump if carry Set
		call	sub_c_17AD
		retn
loc_c_1630:
		cmp	data_b_0550,2
		jae	loc_c_1655		; Jump if above or =
		mov	data_b_057B,al
		add	al,32h			; '2'
		mov	data_b_057C,al
		cmp	data_b_0550,1
		je	loc_c_1653		; Jump if equal
		mov	data_b_0550,1

		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_0556,dx		; system timer

loc_c_1653:
		stc				; Set carry flag
		retn
loc_c_1655:
		clc				; Clear carry flag

loc_ret_c_1656:
		retn
sub_c_1608	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1657	proc	near
		mov	cl,data_b_057B
		add	cl,2
		and	cl,0F8h
		mov	bx,data_b_0008
		mov	bl,data_b_1006[bx]
loc_c_1669:
		mov	al,data_b_0FF0[bx]
		cmp	al,0
		jne	loc_c_1678		; Jump if not equal
		mov	data_b_127C,0
		clc				; Clear carry flag
		retn
loc_c_1678:
		inc	bx
		mov	ch,88h
		test	al,80h
		jnz	loc_c_1681		; Jump if not zero
		mov	ch,90h
loc_c_1681:
		cmp	cl,ch
		jne	loc_c_1669		; Jump if not equal
		and	ax,7Fh
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		mov	dx,data_b_0579
;*		and	dx,0FFF8h
		db	 81h,0E2h,0F8h,0FFh	;  Fixup - byte match
		cmp	dx,ax
		jb	loc_c_1669		; Jump if below
		mov	dx,data_b_0579
		sub	dx,0Fh
;*		and	dx,0FFF8h
		db	 81h,0E2h,0F8h,0FFh	;  Fixup - byte match
		cmp	dx,ax
		ja	loc_c_1669		; Jump if above
		sub	ch,2
		mov	data_b_057B,ch
		add	ch,32h			; '2'
		mov	data_b_057C,ch
		cmp	data_b_127C,0
		jne	loc_c_16C4		; Jump if not equal
		mov	data_b_127C,1
		call	sub_c_590E
loc_c_16C4:
		stc				; Set carry flag
		retn
sub_c_1657	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_16C6	proc	near
		mov	data_b_39E0,0
		cmp	data_b_0571,1
		jne	loc_c_16FC		; Jump if not equal
		mov	ax,data_b_2650
		sub	ax,4
		mov	dl,data_b_2652
		sub	dl,8
		mov	si,0Ch
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E10h
		call	sub_c_2E29
		jnc	loc_c_16FC		; Jump if carry=0
		mov	data_b_0551,1
		clc				; Clear carry flag
		retn
loc_c_16FC:
		cmp	word ptr data_b_0004,3	; current scene 1..7, 0=intro
		jne	loc_c_170E		; Jump if not equal
		call	sub_c_3C43
		jnc	loc_c_170E		; Jump if carry=0
		mov	data_b_055C,1
		retn
loc_c_170E:
		mov	cl,data_b_057B
		and	cl,0F8h
		mov	bx,word ptr data_b_0004	; current scene 1..7, 0=intro
		shl	bx,1			; Shift w/zeros fill
		mov	bx,data_b_1269[bx]
loc_c_171F:
		mov	ch,data_b_1029[bx]
		cmp	ch,0
		jne	loc_c_172A		; Jump if not equal
		clc				; Clear carry flag
		retn
loc_c_172A:
		mov	al,data_b_1089[bx]
		mov	data_b_127B,al
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_11A9[bx]
		mov	data_b_1279,ax
		mov	ax,data_b_10E9[bx]
		shr	bl,1			; Shift w/zeros fill
		inc	bx
		cmp	cl,ch
		jne	loc_c_171F		; Jump if not equal
		mov	dx,data_b_0579
;*		and	dx,0FFF8h
		db	 81h,0E2h,0F8h,0FFh	;  Fixup - byte match
		cmp	dx,ax
		jb	loc_c_171F		; Jump if below
		mov	dx,data_b_0579
		sub	dx,data_b_1279
		jnc	loc_c_175D		; Jump if carry=0
		sub	dx,dx
loc_c_175D:
;*		and	dx,0FFFCh
		db	 81h,0E2h,0FCh,0FFh	;  Fixup - byte match
		cmp	dx,ax
		ja	loc_c_171F		; Jump if above
		mov	data_b_057B,ch
		add	ch,32h			; '2'
		mov	data_b_057C,ch
		mov	al,data_b_127B
		mov	data_b_055C,al
		cmp	al,0
		je	loc_c_1780		; Jump if equal
;*		and	data_b_0579,0FFFCh
		db	 81h, 26h, 79h, 05h,0FCh,0FFh	;  Fixup - byte match
loc_c_1780:
		cmp	word ptr data_b_0004,4	; current scene 1..7, 0=intro
		jne	loc_c_1797		; Jump if not equal
		dec	bx
		sub	bx,27h
		jc	loc_c_1797		; Jump if carry Set
		cmp	bx,10h
		jae	loc_c_1797		; Jump if above or =
		inc	bx
		mov	data_b_39E0,bl
loc_c_1797:
		stc				; Set carry flag
		retn
sub_c_16C6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1799	proc	near
		mov	cl,3
		shr	bx,cl			; Shift w/zeros fill
		mov	ch,bl
		mov	cl,3
		shr	bx,cl			; Shift w/zeros fill
		mov	cl,ch
		and	cl,7
		mov	ch,80h
		shr	ch,cl			; Shift w/zeros fill
		retn
sub_c_1799	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_17AD	proc	near
		mov	dl,data_b_057B
		and	dl,0F8h
		sub	bx,bx
		cmp	dl,8
		je	loc_c_17C9		; Jump if equal
		inc	bl
		cmp	dl,28h			; '('
		je	loc_c_17C9		; Jump if equal
		inc	bl
		cmp	dl,48h			; 'H'
		jne	loc_c_1810		; Jump if not equal
loc_c_17C9:
		mov	ax,data_b_0579
		cmp	bx,data_b_052F
		jne	loc_c_17FC		; Jump if not equal
		cmp	data_b_0525,3
		ja	loc_c_17FC		; Jump if above
		cmp	bl,1
		je	loc_c_17EE		; Jump if equal
		mov	cx,4
		sub	cl,data_b_0525
		shl	cl,1			; Shift w/zeros fill
		shl	cl,1			; Shift w/zeros fill
		add	ax,cx
		jmp	short loc_c_17FC
		db	90h
loc_c_17EE:
		sub	ch,ch
		mov	cl,data_b_0525
		inc	cl
		shl	cl,1			; Shift w/zeros fill
		shl	cl,1			; Shift w/zeros fill
		sub	ax,cx
loc_c_17FC:
		mov	bl,data_b_1025[bx]
		mov	si,bx
		mov	bx,ax
		add	bx,0Ah
		call	sub_c_1799
		test	ch,data_b_1016[bx+si]
		jnz	loc_c_1812		; Jump if not zero
loc_c_1810:
		clc				; Clear carry flag
		retn
loc_c_1812:
		mov	data_b_057B,dl
		add	dl,32h			; '2'
		mov	data_b_057C,dl
;*		and	data_b_0579,0FFF8h
		db	 81h, 26h, 79h, 05h,0F8h,0FFh	;  Fixup - byte match
		mov	data_b_055C,1
		stc				; Set carry flag
		retn
sub_c_17AD	endp

		db	0, 0, 0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1830	proc	near
		mov	data_b_1665,0
		mov	data_b_1673,0
		mov	data_b_1677,0
		mov	data_b_1678,0
		mov	data_b_166C,9
		retn
sub_c_1830	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_184B	proc	near
		cmp	data_b_1673,0
		je	loc_ret_c_185C		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_17EC
		jne	loc_c_185D		; Jump if not equal

loc_ret_c_185C:
		retn
loc_c_185D:
		mov	data_b_17EC,dx
		cmp	data_b_1677,0
		je	loc_c_187F		; Jump if equal
		mov	ax,data_b_1671
		and	ax,0FFF8h
		mov	bx,data_b_0579
;*		and	bx,0FFF8h
		db	 81h,0E3h,0F8h,0FFh	;  Fixup - byte match
		cmp	ax,bx
		jne	loc_c_187F		; Jump if not equal
		mov	data_b_1674,0
loc_c_187F:
		inc	data_b_17E9
		cmp	data_b_17EA,1
		ja	loc_c_188E		; Jump if above
		dec	data_b_17EA
loc_c_188E:
		mov	ax,data_b_1671
		mov	dx,data_b_17EA
		mov	cl,3
		shr	dl,cl			; Shift w/zeros fill
		cmp	data_b_1674,1
		jb	loc_c_18B5		; Jump if below
		jnz	loc_c_18AF		; Jump if not zero
		add	ax,dx
		cmp	ax,12Fh
		jb	loc_c_18B5		; Jump if below
		mov	ax,12Eh
		jmp	short loc_c_18B5
		db	90h
loc_c_18AF:
		sub	ax,dx
		jnc	loc_c_18B5		; Jump if carry=0
		sub	ax,ax
loc_c_18B5:
		mov	data_b_1671,ax
		mov	bx,data_b_17DF
		mov	al,data_b_17E9
		shr	al,1			; Shift w/zeros fill
		add	al,data_b_1673
		mov	dl,al
		sub	al,data_b_1676
		jc	loc_c_18E1		; Jump if carry Set
		sub	bh,al
		jz	loc_c_18D3		; Jump if zero
		jnc	loc_c_18E1		; Jump if carry=0
loc_c_18D3:
		mov	data_b_1673,0
		mov	data_b_1678,0
		call	sub_c_1922

loc_ret_c_18E0:
		retn
loc_c_18E1:
		mov	data_b_1673,dl
		mov	cx,data_b_1671
		mov	data_b_17E1,bx
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_17E7,ax
		cmp	data_b_17E9,2
		je	loc_c_18FD		; Jump if equal
		call	sub_c_1922
loc_c_18FD:
		call	sub_c_1B7A
		jc	loc_ret_c_18E0		; Jump if carry Set
		mov	di,data_b_17E7
		mov	data_b_17E5,di
		mov	cx,data_b_17E1
		mov	data_b_17E3,cx
		mov	ax,0B800h
		mov	es,ax
		mov	si,word ptr data_b_17DD
		mov	bp,offset data_b_17EE
		call	sub_c_2CCC
		retn
sub_c_184B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1922	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_17E5
		mov	si,offset data_b_17EE
		mov	cx,data_b_17E3
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_1922	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1936	proc	near
		dec	data_b_166A
		jz	loc_c_193D		; Jump if zero

loc_ret_c_193C:
		retn
loc_c_193D:
		mov	data_b_166A,0Dh
		call	sub_c_13D8		; Check light pen
		jnz	loc_ret_c_193C		; Jump if not zero
		cmp	data_b_1665,0
		je	loc_c_1951		; Jump if equal
		call	sub_c_1B05
loc_c_1951:
		cmp	data_b_1673,0
		jne	loc_ret_c_193C		; Jump if not equal
		cmp	data_b_1665,0
		jne	loc_c_19CD		; Jump if not equal
		cmp	data_b_057B,60h		; '`'
		ja	loc_ret_c_193C		; Jump if above
		mov	data_b_1677,0
		cmp	data_b_0550,1
		jne	loc_c_198A		; Jump if not equal
		cmp	data_b_0418,0
		jne	loc_c_198A		; Jump if not equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_0556		; system timer
		cmp	dx,48h
		jb	loc_c_198A		; Jump if below
		inc	data_b_1677
loc_c_198A:
		call	sub_c_2DFD
		cmp	data_b_1677,0
		je	loc_c_199A		; Jump if equal
		and	dl,3
		jmp	short loc_c_19A2
		db	90h
loc_c_199A:
		and	dl,0Fh
		cmp	dl,0Ch
		jae	loc_ret_c_193C		; Jump if above or =
loc_c_19A2:
		mov	data_b_1669,dl
		call	sub_c_1AEA
		mov	data_b_1666,cx
		mov	data_b_1668,dl
		call	sub_c_1B05
		jc	loc_c_198A		; Jump if carry Set
		mov	data_b_1665,1Dh
		mov	bx,data_b_0008
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_181E[bx]
		mov	data_b_166C,ax
		mov	data_b_1670,1
loc_c_19CD:
		call	sub_c_1B05
		jc	loc_ret_c_19E0		; Jump if carry Set
		mov	data_b_1664,0
		call	sub_c_1B4C
		jnc	loc_c_19E1		; Jump if carry=0
		inc	data_b_1664

loc_ret_c_19E0:
		retn
loc_c_19E1:
		cmp	data_b_1665,10h
		jne	loc_c_19F0		; Jump if not equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_166E,dx
loc_c_19F0:
		cmp	data_b_1665,0Fh
		jne	loc_c_1A76		; Jump if not equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_166E
		cmp	dx,data_b_166C
		jae	loc_c_1A76		; Jump if above or =
		cmp	data_b_1670,0
		je	loc_ret_c_1A75		; Jump if equal
		cmp	data_b_1673,0
		jne	loc_ret_c_1A75		; Jump if not equal
		cmp	data_b_0418,0
		jne	loc_ret_c_1A75		; Jump if not equal
		dec	data_b_1670
		mov	data_b_1678,1
		mov	al,data_b_1668
		mov	data_b_1673,al
		call	sub_c_2DFD
;*		and	dx,0Fh
		db	 81h,0E2h, 0Fh, 00h	;  Fixup - byte match
		add	dx,data_b_1666
		mov	data_b_1671,dx
		mov	al,1
		cmp	dx,data_b_0579
		jb	loc_c_1A42		; Jump if below
		mov	al,0FFh
loc_c_1A42:
		mov	data_b_1674,al
		call	sub_c_2DFD
		mov	bl,dl
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		mov	ax,data_b_17C9[bx]
		mov	word ptr data_b_17DD,ax
		mov	ax,data_b_17D1[bx]
		mov	data_b_17DF,ax
		shr	bl,1			; Shift w/zeros fill
		mov	al,data_b_17D9[bx]
		mov	data_b_1676,al
		mov	data_b_17EA,20h
		mov	data_b_17E9,1
		mov	data_b_1675,0

loc_ret_c_1A75:
		retn
loc_c_1A76:
		dec	data_b_1665
		mov	cx,data_b_1666
		mov	dl,data_b_1668
		cmp	data_b_1665,0Eh
		jbe	loc_c_1A93		; Jump if below or =
		add	dl,data_b_1665
		sub	dl,0Eh
		jmp	short loc_c_1A9A
		db	90h
loc_c_1A93:
		add	dl,0Eh
		sub	dl,data_b_1665
loc_c_1A9A:
		mov	data_b_166B,dl
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		mov	cx,4
		cmp	data_b_1665,0Eh
		jbe	loc_c_1AD7		; Jump if below or =
		cmp	data_b_0418,0
		je	loc_c_1AD2		; Jump if equal
		mov	al,data_b_166B
		sub	al,data_b_1668
		sub	ah,ah
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
		add	ax,15E0h
		mov	si,ax
		mov	cx,4
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		retn
loc_c_1AD2:
		sub	ax,ax
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn
loc_c_1AD7:
		mov	al,data_b_166B
		sub	al,data_b_1668
		mov	ah,0Ah
		mul	ah			; ax = reg * al
		add	ax,2681h
		mov	si,ax
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		retn
sub_c_1936	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1AEA	proc	near
		sub	bh,bh
		mov	bl,dl
		and	bl,3
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_1658[bx]
		mov	bl,dl
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		and	bl,3
		mov	dl,data_b_1660[bx]
		retn
sub_c_1AEA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1B05	proc	near
		mov	ax,data_b_1666
		mov	dl,data_b_1668
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	si,20h
		mov	di,18h
		mov	cx,0E0Fh
		call	sub_c_2E29
		jnc	loc_ret_c_1B4B		; Jump if carry=0
		cmp	data_b_0571,1
		jne	loc_c_1B4A		; Jump if not equal
		cmp	data_b_055A,0
		jne	loc_c_1B4A		; Jump if not equal
		cmp	data_b_057B,60h		; '`'
		jae	loc_c_1B4A		; Jump if above or =
		cmp	data_b_1665,5
		jb	loc_c_1B4A		; Jump if below
		cmp	data_b_1665,19h
		jae	loc_c_1B4A		; Jump if above or =
		mov	data_b_0551,1
loc_c_1B4A:
		stc				; Set carry flag

loc_ret_c_1B4B:
		retn
sub_c_1B05	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1B4C	proc	near
		mov	al,data_b_1669
		cmp	al,8
		jae	loc_c_1B78		; Jump if above or =
		mov	bx,offset data_b_0001+1
		test	al,4
		jz	loc_c_1B5C		; Jump if zero
		shl	bl,1			; Shift w/zeros fill
loc_c_1B5C:
		mov	ax,data_b_1F30[bx]
		add	ax,10h
		cmp	ax,data_b_1666
		jb	loc_c_1B78		; Jump if below
		sub	ax,30h
		jnc	loc_c_1B70		; Jump if carry=0
		sub	ax,ax
loc_c_1B70:
		cmp	ax,data_b_1666
		ja	loc_c_1B78		; Jump if above
		stc				; Set carry flag
		retn
loc_c_1B78:
		clc				; Clear carry flag
		retn
sub_c_1B4C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1B7A	proc	near
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		jne	loc_c_1BE1		; Jump if not equal
		mov	dl,data_b_1673
		cmp	dl,0
		je	loc_c_1BE1		; Jump if equal
		mov	cx,data_b_17DF
		xchg	cl,ch
		mov	si,10h
		mov	ax,data_b_1671
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	ch,0Eh
		call	sub_c_2E29
		jnc	loc_ret_c_1BE2		; Jump if carry=0
		call	sub_c_11E3
		call	sub_c_1922
		call	sub_c_10DD
		cmp	data_b_1675,0
		jne	loc_c_1BDF		; Jump if not equal
		mov	data_b_1675,1
		call	sub_c_1166
		mov	dl,1
		cmp	data_b_1674,0FFh
		je	loc_c_1BCB		; Jump if equal
		mov	dl,0FFh
loc_c_1BCB:
		mov	data_b_1674,dl
		mov	data_b_17EA,60h
		mov	data_b_17E9,1
		mov	data_b_055C,0
loc_c_1BDF:
		stc				; Set carry flag
		retn
loc_c_1BE1:
		clc				; Clear carry flag

loc_ret_c_1BE2:
		retn
sub_c_1B7A	endp

		db	13 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1BF0	proc	near
		sub	bx,bx
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		cmp	data_b_0006,7
		jne	loc_c_1C12		; Jump if not equal
		cmp	data_b_0553,0
		je	loc_c_1C12		; Jump if equal
		call	sub_c_528B
		mov	data_b_0579,98h
		mov	data_b_057B,5Fh		; '_'
loc_c_1C12:
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		mov	data_b_1839,0		; box color pattern
		call	sub_c_1C67
		call	sub_c_5B21		; Disable sound output
		call	sub_c_1D31		; Set palette color of current scene
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		jne	loc_c_1C49		; Jump if not equal
		cmp	data_b_0553,0
		je	loc_c_1C46		; Jump if equal
		cmp	data_b_0006,7
		jne	loc_c_1C41		; Jump if not equal
		call	sub_c_5313
		jmp	short loc_c_1C49
loc_c_1C41:
		call	sub_c_38B0
		jmp	short loc_c_1C49
loc_c_1C46:
		call	sub_c_1D76
loc_c_1C49:
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		je	loc_c_1C5A		; Jump if equal
		mov	ax,0AAAAh
		cmp	word ptr data_b_0004,2	; current scene 1..7, 0=intro
		jne	loc_c_1C5D		; Jump if not equal
loc_c_1C5A:
		mov	ax,5555h
loc_c_1C5D:
		mov	data_b_1839,ax		; box color pattern
		call	sub_c_1C67
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_1BF0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1C67	proc	near
		call	sub_c_5896
		mov	data_b_1835,1		; box width
		mov	data_b_1837,8		; box height
		mov	cx,data_b_0579
		mov	dl,data_b_057B
		add	cx,0Ch
;*		and	cx,0FFF0h
		db	 81h,0E1h,0F0h,0FFh	;  Fixup - byte match
		add	dl,8
		mov	data_b_1838,0
loc_c_1C8C:

		; get coordinates
		call	sub_c_5897
		mov	data_b_1832,cx
		mov	data_b_1834,dl

; clear box

		; calculate address in videomemory
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	bl,data_b_1837		; box height

		; draw one line
loc_c_1CA0:	mov	ax,data_b_1839		; box color pattern
		mov	cx,data_b_1835		; box width
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		rep	stosw			; Rep when cx >0 Store ax to es:[di]

		; shift address
		mov	cx,data_b_1835		; box width
		shr	cx,1			; Shift w/zeros fill
		shr	cx,1			; Shift w/zeros fill
		and	cx,0FEh
		sub	di,cx
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_1CCA		; Jump if not zero
		add	di,50h
loc_c_1CCA:
		dec	bl
		jnz	loc_c_1CA0		; Jump if not zero ... next line

		cmp	data_b_1838,0Fh
		jne	loc_c_1CD6		; Jump if not equal
		retn
loc_c_1CD6:
		add	data_b_1835,20h		; box width
		add	data_b_1837,10h		; box height
		mov	cx,data_b_1832
		mov	dl,data_b_1834
		sub	cx,10h
		jnc	loc_c_1CF4		; Jump if carry=0
		sub	cx,cx
		or	data_b_1838,1
loc_c_1CF4:
		mov	ax,data_b_1835		; box width
		add	ax,cx
		cmp	ax,140h
		jb	loc_c_1D0B		; Jump if below
		mov	ax,140h
		sub	ax,cx
		mov	data_b_1835,ax		; box width
		or	data_b_1838,2
loc_c_1D0B:
		sub	dl,8
		jnc	loc_c_1D17		; Jump if carry=0
		sub	dl,dl
		or	data_b_1838,4
loc_c_1D17:
		mov	al,data_b_1837		; box height
		add	al,dl
		jc	loc_c_1D22		; Jump if carry Set
		cmp	al,0C8h
		jb	loc_c_1D2E		; Jump if below
loc_c_1D22:
		mov	al,0C8h
		sub	al,dl
		mov	data_b_1837,al		; box height
		or	data_b_1838,8
loc_c_1D2E:
		jmp	loc_c_1C8C
sub_c_1C67	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set palette color of current scene

sub_c_1D31	proc	near

		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_1D48		; Jump if equal

		; set CGA palette of current scene
		mov	ah,0Bh
		mov	bh,1
		mov	si,word ptr data_b_0004	; current scene 1..7, 0=intro
		mov	bl,data_b_1853[si]	; palette of scene 1..7, 0=intro
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		jmp	short loc_c_1D67

		; set PCjr palettes
loc_c_1D48:	mov	si,word ptr data_b_0004	; current scene 1..7, 0=intro
		mov	bl,1
		mov	bh,data_b_183B[si]
		call	sub_c_1D6E		; Set PCjr palette
		mov	bl,2
		mov	bh,data_b_1843[si]
		call	sub_c_1D6E		; Set PCjr palette
		mov	bl,3
		mov	bh,data_b_184B[si]
		call	sub_c_1D6E		; Set PCjr palette

		; set background color to black
loc_c_1D67:	mov	ah,0Bh
		sub	bx,bx
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		retn

sub_c_1D31	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set PCjr palette

sub_c_1D6E	proc	near

		mov	ax,1000h
		push	si
		int	10h			; Video display   ah=functn 10h
						;  set palette reg bl, bh=color
		pop	si
		retn
sub_c_1D6E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1D76	proc	near

		cmp	data_b_0006,7
		jne	loc_c_1D81		; Jump if not equal
		call	sub_c_6040		; ??? short animation with sound
		retn

loc_c_1D81:	call	sub_c_57D5
		mov	ax,185Bh
		cmp	data_b_0552,0
		je	loc_c_1DC6		; Jump if equal
		mov	bx,data_b_1C30
		add	data_b_1C30,2
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		mov	ax,data_b_1C26[bx]
		cmp	data_b_1F80,0		; cat lives (1..9)
		je	loc_c_1DAA		; Jump if equal
		dec	data_b_1F80		; cat lives (1..9)
loc_c_1DAA:
		cmp	data_b_0552,0DDh
		jne	loc_c_1DC6		; Jump if not equal
		cmp	data_b_0008,0
		je	loc_c_1DC6		; Jump if equal
		cmp	data_b_1F80,1		; cat lives (1..9)
		jb	loc_c_1DC6		; Jump if below
		call	sub_c_5BE0
		call	sub_c_5B21		; Disable sound output
		retn
loc_c_1DC6:
		mov	data_b_1C2E,ax
		mov	data_b_1C1B,8080h
		mov	data_b_1C1D,1Ch
loc_c_1DD4:
		call	sub_c_1E17
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_1830,dx
loc_c_1DDF:
		call	sub_c_57E4
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_1830
		je	loc_c_1DDF		; Jump if equal
		cmp	data_b_1C1D,14h
		ja	loc_c_1E02		; Jump if above
		sub	bh,bh
		mov	bl,data_b_1C1D
		and	bl,6
		mov	ax,data_b_1C1E[bx]
		jmp	short loc_c_1E0A
loc_c_1E02:
		mov	ax,data_b_1C1B
		stc				; Set carry flag
		rcr	al,1			; Rotate thru carry
		mov	ah,al
loc_c_1E0A:
		mov	data_b_1C1B,ax
		dec	data_b_1C1D
		jnz	loc_c_1DD4		; Jump if not zero
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_1D76	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1E17	proc	near
		cld				; Clear direction
		push	ds
		pop	es
		mov	si,data_b_1C2E
		mov	di,offset data_b_000E
		mov	cx,60h

locloop_c_1E24:
		lodsw				; String [si] to ax
		and	ax,data_b_1C1B
		stosw				; Store ax to es:[di]
		loop	locloop_c_1E24		; Loop if cx > 0

		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_000E
		mov	di,offset data_b_0ED0
		mov	cx,0C08h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_1E17	endp

		db	0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1E40	proc	near
		mov	data_b_1CBF,0
		mov	word ptr data_b_1CE1,0
		mov	data_b_1CC0,0
		mov	data_b_1CC1,0
		mov	data_b_1CB8,0
		mov	data_b_1CC8,0B1h
		call	sub_c_5450
		retn
sub_c_1E40	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_1E63	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	cx,dx
		sub	dx,data_b_1CC9
		mov	ax,word ptr data_b_1CE1
		and	ax,1
		add	ax,1
		cmp	dx,ax
		jae	loc_c_1E7B		; Jump if above or =

loc_ret_c_1E7A:
		retn
loc_c_1E7B:
		call	sub_c_13D8		; Check light pen
		jz	loc_ret_c_1E7A		; Jump if zero
		mov	data_b_1CC9,cx
		inc	word ptr data_b_1CE1
		cmp	data_b_1CC1,0
		je	loc_c_1EE2		; Jump if equal
		dec	data_b_1CC1
		jnz	loc_c_1EC9		; Jump if not zero
		call	sub_c_5B21		; Disable sound output
		cmp	data_b_1CB8,0
		je	loc_c_1EC2		; Jump if equal
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		je	loc_c_1EB7		; Jump if equal
		mov	data_b_0552,0DDh
		mov	data_b_0579,0A0h
		mov	data_b_057B,60h		; '`'
		retn
loc_c_1EB7:
		cmp	data_b_1F80,0		; cat lives (1..9)
		je	loc_c_1EC2		; Jump if equal
		dec	data_b_1F80		; cat lives (1..9)
loc_c_1EC2:
		call	sub_c_20E1
		call	sub_c_1E40
		retn
loc_c_1EC9:
		call	sub_c_2022
		mov	ax,104h
		sub	al,data_b_1CC1
		cmp	data_b_1CD0,0FFh
		je	loc_c_1EDC		; Jump if equal
		mov	ah,0FFh
loc_c_1EDC:
		call	sub_c_2059
		jmp	loc_c_1FFB
loc_c_1EE2:
		cmp	data_b_1CB8,0
		je	loc_c_1F0C		; Jump if equal
		mov	dl,data_b_1CB8
		cmp	data_b_1CB9,0
		je	loc_c_1F02		; Jump if equal
		dec	data_b_1CB9
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_1F02		; Jump if not zero
		mov	dl,0FFh
loc_c_1F02:
		mov	data_b_1CD0,dl
		mov	ax,data_b_1CC6
		jmp	loc_c_1FAB
loc_c_1F0C:
		cmp	data_b_1CBF,0
		jne	loc_c_1F75		; Jump if not equal
		cmp	data_b_1CC0,0
		jne	loc_c_1F57		; Jump if not equal
		cmp	data_b_1D58,0
		jne	loc_c_1F3D		; Jump if not equal
		cmp	data_b_057B,0B4h
		jb	loc_ret_c_1F3C		; Jump if below
		cmp	data_b_0558,0
		jne	loc_ret_c_1F3C		; Jump if not equal
		call	sub_c_2DFD
		mov	bx,data_b_0008
		cmp	dl,data_b_1CD1[bx]
		jb	loc_c_1F3D		; Jump if below

loc_ret_c_1F3C:
		retn
loc_c_1F3D:
		mov	al,1
		mov	data_b_59BA,0
		cmp	data_b_0579,0A0h
		jae	loc_c_1F4F		; Jump if above or =
		mov	al,0FFh
loc_c_1F4F:
		mov	data_b_1CD0,al
		mov	data_b_1CC0,4
loc_c_1F57:
		dec	data_b_1CC0
		jnz	loc_c_1F65		; Jump if not zero
		mov	data_b_1CBF,1
		jmp	short loc_c_1F75
		db	90h
loc_c_1F65:
		call	sub_c_2022
		mov	al,data_b_1CC0
		mov	ah,data_b_1CD0
		call	sub_c_2059
		jmp	loc_c_1FFB
loc_c_1F75:
		mov	data_b_1D58,0
		mov	ax,data_b_1CC6
		cmp	data_b_057B,0B4h
		jb	loc_c_1FAB		; Jump if below
		cmp	data_b_0558,0
		jne	loc_c_1FAB		; Jump if not equal
		call	sub_c_2DFD
		mov	bx,data_b_0008
		cmp	dl,data_b_1CD9[bx]
		ja	loc_c_1FAB		; Jump if above
		cmp	ax,data_b_0579
		ja	loc_c_1FA6		; Jump if above
		mov	data_b_1CD0,1
		jmp	short loc_c_1FAB
		db	90h
loc_c_1FA6:
		mov	data_b_1CD0,0FFh
loc_c_1FAB:
		cmp	data_b_1CD0,1
		jb	loc_c_1FEF		; Jump if below
		jz	loc_c_1FE2		; Jump if zero
		sub	ax,8
		jnc	loc_c_1FEF		; Jump if carry=0
		sub	ax,ax
loc_c_1FBB:
		cmp	data_b_1CB8,0
		je	loc_c_1FCC		; Jump if equal
		cmp	data_b_1CB9,0
		jne	loc_c_1FEF		; Jump if not equal
		jmp	short loc_c_1FDA
		db	90h
loc_c_1FCC:
		cmp	data_b_057B,0B4h
		jb	loc_c_1FDA		; Jump if below
		cmp	data_b_0558,0
		je	loc_c_1FEF		; Jump if equal
loc_c_1FDA:
		mov	data_b_1CC1,4
		jmp	short loc_c_1FEF
		db	90h
loc_c_1FE2:
		add	ax,8
		cmp	ax,11Eh
		jb	loc_c_1FEF		; Jump if below
		mov	ax,11Eh
		jmp	short loc_c_1FBB
loc_c_1FEF:
		mov	data_b_1CC6,ax
		call	sub_c_2022
		mov	data_b_1CC4,0F04h
loc_c_1FFB:
		mov	cx,data_b_1CC6
		mov	dl,data_b_1CC8
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_1CCD,ax
		cmp	data_b_1CC0,3
		je	loc_c_2013		; Jump if equal
		call	sub_c_20E1
loc_c_2013:
		call	sub_c_20F5
		jc	loc_ret_c_2021		; Jump if carry Set
		mov	ax,data_b_1CCD
		mov	data_b_1CBD,ax
		call	sub_c_209B

loc_ret_c_2021:
		retn
sub_c_1E63	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2022	proc	near
		sub	bh,bh
		cmp	data_b_1CB8,0
		je	loc_c_203B		; Jump if equal
		inc	data_b_1CCF
		mov	bl,data_b_1CCF
		and	bl,6
		or	bl,8
		jnz	loc_c_2051		; Jump if not zero
loc_c_203B:
		add	data_b_1CCF,2
		mov	bl,data_b_1CCF
		and	bl,2
		cmp	data_b_1CD0,1
		jne	loc_c_2051		; Jump if not equal
		or	bl,4
loc_c_2051:
		mov	ax,data_b_15C8[bx]
		mov	data_b_1CBB,ax
		retn
sub_c_2022	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2059	proc	near
		mov	cx,0F04h
		sub	cl,al
		mov	data_b_1CC4,cx
		cmp	ah,0FFh
		je	loc_c_2078		; Jump if equal
		sub	ah,ah
		shl	al,1			; Shift w/zeros fill
		add	data_b_1CBB,ax
		mov	data_b_1CC6,0
		jmp	short loc_c_2086
		db	90h
loc_c_2078:
		sub	ah,ah
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		shl	al,1			; Shift w/zeros fill
		add	ax,120h
		mov	data_b_1CC6,ax
loc_c_2086:
		push	ds
		pop	es
		mov	si,data_b_1CBB
		mov	di,offset data_b_000E
		mov	al,4
		call	sub_c_2D70
		mov	data_b_1CBB,0Eh
		retn
sub_c_2059	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_209B	proc	near
		mov	cx,data_b_1CC4
		mov	data_b_1CC2,cx
		mov	ax,0B800h
		cmp	data_b_1CB8,0
		jne	loc_c_20BE		; Jump if not equal
		mov	es,ax
		mov	di,data_b_1CBD
		mov	si,data_b_1CBB
		mov	bp,offset data_b_1C40
		call	sub_c_2CCC
		retn
loc_c_20BE:
		push	ds
		mov	ds,ax
		pop	es
		push	es
		push	ds
		mov	si,es:data_b_1CBD
		mov	di,d_B800_1C40_e
		call	sub_c_2DCA		; Load part of screen into buffer (ES:DI=dst buffer, DS:SI=source screen, CL=width, CH=height)
		pop	es
		pop	ds
		mov	si,data_b_1CBB
		mov	di,data_b_1CBD
		mov	cx,data_b_1CC4
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_209B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_20E1	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_1CBD
		mov	si,offset data_b_1C40
		mov	cx,data_b_1CC2
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_20E1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_20F5	proc	near
		cmp	data_b_1CB8,0
		jne	loc_c_2134		; Jump if not equal
		mov	al,data_b_1CBF
		or	al,data_b_1CC0
		or	al,data_b_1CC1
		jz	loc_c_2134		; Jump if zero
		cmp	data_b_057B,0A3h
		jb	loc_c_2134		; Jump if below
		cmp	data_b_0558,0
		jne	loc_c_2134		; Jump if not equal
		mov	ax,data_b_1CC6
		add	ax,20h
		cmp	ax,data_b_0579
		jb	loc_c_2134		; Jump if below
		sub	ax,38h
		jnc	loc_c_212A		; Jump if carry=0
		sub	ax,ax
loc_c_212A:
		cmp	ax,data_b_0579
		ja	loc_c_2134		; Jump if above
		call	sub_c_2136
		retn
loc_c_2134:
		clc				; Clear carry flag
		retn
sub_c_20F5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2136	proc	near
		cmp	word ptr data_b_0004,6	; current scene 1..7, 0=intro
		jne	loc_c_2149		; Jump if not equal
		mov	al,data_b_057B
		mov	data_b_1CC8,al
		mov	ax,data_b_0579
		mov	data_b_1CC6,ax
loc_c_2149:
		mov	ax,data_b_1CC6
		add	ax,data_b_0579
		shr	ax,1			; Shift w/zeros fill
		cmp	ax,118h
		jb	loc_c_215A		; Jump if below
		mov	ax,117h
loc_c_215A:
		mov	data_b_1CC6,ax
		mov	bl,1
		cmp	ax,0A0h
		ja	loc_c_216E		; Jump if above
		mov	bl,0FFh
		mov	dx,0A1h
		sub	dx,ax
		jmp	short loc_c_2173
		db	90h
loc_c_216E:
		sub	ax,9Fh
		mov	dx,ax
loc_c_2173:
		mov	data_b_1CB8,bl
		mov	data_b_1CBF,1
		mov	data_b_1CC1,0
		mov	cl,3
		shr	dx,cl			; Shift w/zeros fill
		mov	data_b_1CB9,dx
		cmp	word ptr data_b_0004,6	; current scene 1..7, 0=intro
		jne	loc_c_21BD		; Jump if not equal
		call	sub_c_11E3
		mov	al,data_b_1CB8
		push	ax
		mov	data_b_1CB8,0
		mov	data_b_1CC4,0F04h
		mov	ax,data_b_15C8
		mov	data_b_1CBB,ax
		mov	cx,data_b_1CC6
		mov	dl,data_b_1CC8
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_1CBD,ax
		call	sub_c_209B
		pop	ax
		mov	data_b_1CB8,al
loc_c_21BD:
		call	sub_c_20E1
		call	sub_c_11E3
		mov	ax,0
		cmp	data_b_0579,0A0h
		jae	loc_c_21D1		; Jump if above or =
		mov	ax,122h
loc_c_21D1:
		mov	data_b_0579,ax
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		jne	loc_c_21DE		; Jump if not equal
		call	sub_c_070D		; Load image ??? from screen to bufer
loc_c_21DE:
		stc				; Set carry flag
		retn
sub_c_2136	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_21E0	proc	near
		mov	al,data_b_1CBF
		or	al,data_b_1CC0
		or	al,data_b_1CC1
		jz	loc_c_2209		; Jump if zero
		mov	ax,data_b_327D
		mov	dl,data_b_327F
		mov	si,10h
		mov	bx,data_b_1CC6
		mov	dh,data_b_1CC8
		mov	di,20h
		mov	cx,0F1Eh
		call	sub_c_2E29
		retn
loc_c_2209:
		clc				; Clear carry flag
		retn
sub_c_21E0	endp

		db	0, 0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2210	proc	near
		mov	data_b_1D59,0
		retn
sub_c_2210	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2216	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_1D5A
		jne	loc_c_2221		; Jump if not equal

loc_ret_c_2220:
		retn
loc_c_2221:
		mov	cx,dx
		call	sub_c_13D8		; Check light pen
		jz	loc_ret_c_2220		; Jump if zero
		mov	data_b_1D5A,cx
		call	sub_c_22F7
		jc	loc_ret_c_2220		; Jump if carry Set
		cmp	data_b_1D59,0
		jne	loc_c_226D		; Jump if not equal
		cmp	data_b_057B,86h
		je	loc_c_224E		; Jump if equal
		cmp	data_b_057B,8Eh
		je	loc_c_224E		; Jump if equal
		call	sub_c_2DFD
		cmp	dl,5
		ja	loc_ret_c_2220		; Jump if above
loc_c_224E:
		call	sub_c_15D0
		add	dl,3
		mov	data_b_1D5E,dl
		call	sub_c_2DFD
;*		and	dx,7
		db	 81h,0E2h, 07h, 00h	;  Fixup - byte match
		add	cx,dx
		add	cx,6
		mov	data_b_1D5C,cx
		mov	data_b_1D59,1Bh
loc_c_226D:
		dec	data_b_1D59
		mov	cx,data_b_1D5C
		mov	dl,data_b_1D5E
		cmp	data_b_1D59,0Dh
		jbe	loc_c_2291		; Jump if below or =
		add	dl,data_b_1D59
		sub	dl,0Fh
		mov	bx,1B02h
		sub	bh,data_b_1D59
		jmp	short loc_c_229F
		db	90h
loc_c_2291:
		add	dl,0Ch
		sub	dl,data_b_1D59
		mov	bx,2
		add	bh,data_b_1D59
loc_c_229F:
		mov	data_b_1D64,bx
		mov	data_b_1D5F,dl
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_1D62,ax
		call	sub_c_22DC
		call	sub_c_22F7
		jc	loc_ret_c_22BC		; Jump if carry Set
		cmp	data_b_1D59,0
		jne	loc_c_22BD		; Jump if not equal

loc_ret_c_22BC:
		retn
loc_c_22BD:
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_1D62
		mov	si,offset data_b_1CF0
		mov	data_b_1D60,di
		mov	cx,data_b_1D64
		mov	data_b_1D66,cx
		mov	bp,offset data_b_1D24
		call	sub_c_2CCC
		retn
sub_c_2216	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_22DC	proc	near
		cmp	data_b_1D59,1Ah
		je	loc_ret_c_22F6		; Jump if equal
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_1D60
		mov	si,offset data_b_1D24
		mov	cx,data_b_1D66
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_22F6:
		retn
sub_c_22DC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_22F7	proc	near
		cmp	data_b_1D59,0
		jne	loc_c_2300		; Jump if not equal
		clc				; Clear carry flag
		retn
loc_c_2300:
		mov	cx,data_b_1D64
		xchg	ch,cl
		mov	ax,data_b_1D5C
		mov	dl,data_b_1D5F
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	ch,0Eh
		call	sub_c_2E29
		jnc	loc_ret_c_2327		; Jump if carry=0
		mov	data_b_1D58,1

loc_ret_c_2327:
		retn
sub_c_22F7	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2330	proc	near
		mov	data_b_1F6C,0
		sub	ax,ax
		mov	dl,1
		cmp	data_b_0579,0A0h
		ja	loc_c_2347		; Jump if above
		mov	ax,12Ch
		mov	dl,0FFh
loc_c_2347:
		mov	data_b_1F30,ax
		mov	data_b_1F32,ax
		mov	data_b_1F34,ax
		mov	data_b_1F3C,dl
		mov	data_b_1F3D,dl
		mov	data_b_1F3E,dl
		mov	data_b_1F48,1
		mov	data_b_1F49,1
		mov	data_b_1F4A,1
		mov	data_b_1F50,0
		mov	data_b_1F51,0
		mov	data_b_1F52,0
		retn
sub_c_2330	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_237B	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,word ptr data_b_1F65
		jne	loc_c_2386		; Jump if not equal

loc_ret_c_2385:
		retn
loc_c_2386:
		mov	word ptr data_b_1F65,dx
		cmp	data_b_055A,0
		jne	loc_ret_c_2385		; Jump if not equal
		mov	bx,data_b_1F6C
		inc	bx
		cmp	bx,3
		jb	loc_c_239E		; Jump if below
		mov	bx,offset data_b_0000
loc_c_239E:
		mov	data_b_1F6C,bx
		call	sub_c_265E
		jc	loc_ret_c_2385		; Jump if carry Set
		call	sub_c_2567
		jc	loc_ret_c_2385		; Jump if carry Set
		mov	bx,data_b_1F6C
		cmp	data_b_1F50[bx],0
		je	loc_c_23EB		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	bx,data_b_1F6C
		shl	bl,1			; Shift w/zeros fill
		sub	dx,data_b_1F53[bx]
		cmp	dx,36h
		jb	loc_ret_c_2385		; Jump if below
		mov	dl,1
		mov	ax,0
		cmp	data_b_0579,0A0h
		ja	loc_c_23DC		; Jump if above
		mov	ax,12Ch
		mov	dl,0FFh
loc_c_23DC:
		mov	data_b_1F30[bx],ax
		shr	bl,1			; Shift w/zeros fill
		mov	data_b_1F50[bx],0
		mov	data_b_1F3C[bx],dl
loc_c_23EB:
		mov	dl,data_b_1F3C[bx]
		mov	data_b_1F3F[bx],dl
		cmp	data_b_1664,0
		je	loc_c_2403		; Jump if equal
		mov	data_b_1F69,0Ch
		jmp	short loc_c_2418
		db	90h
loc_c_2403:
		mov	ax,8
		cmp	data_b_057B,60h		; '`'
		jbe	loc_c_240F		; Jump if below or =
		shr	al,1			; Shift w/zeros fill
loc_c_240F:
		mov	data_b_1F69,ax
		cmp	bx,data_b_052F
		jne	loc_c_2425		; Jump if not equal
loc_c_2418:
		cmp	data_b_1F3C[bx],0
		jne	loc_c_2425		; Jump if not equal
		call	sub_c_2DFD
		jmp	short loc_c_248A
		db	90h
loc_c_2425:
		cmp	data_b_055C,0
		je	loc_c_2466		; Jump if equal
		mov	al,data_b_1F36[bx]
		cmp	al,data_b_057B
		ja	loc_c_2466		; Jump if above
		add	al,10h
		cmp	al,data_b_057B
		jb	loc_c_2466		; Jump if below
		call	sub_c_2DFD
		mov	si,data_b_0008
		cmp	dl,data_b_1F6E[si]
		ja	loc_c_2466		; Jump if above
		mov	data_b_1F69,0Ch
		mov	al,1
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_1F30[bx]
		shr	bl,1			; Shift w/zeros fill
		cmp	cx,data_b_0579
		jb	loc_c_2463		; Jump if below
		mov	al,0FFh
loc_c_2463:
		jmp	short loc_c_2492
		db	90h
loc_c_2466:
		mov	cl,18h
		cmp	data_b_057B,60h		; '`'
		jbe	loc_c_247A		; Jump if below or =
		mov	cl,28h			; '('
		cmp	data_b_1F3C[bx],0
		jne	loc_c_247A		; Jump if not equal
		mov	cl,10h
loc_c_247A:
		call	sub_c_2DFD
		cmp	dl,cl
		ja	loc_c_2496		; Jump if above
		mov	al,0
		cmp	data_b_1F3C[bx],0
		jne	loc_c_2492		; Jump if not equal
loc_c_248A:
		mov	al,dl
		and	al,1
		jnz	loc_c_2492		; Jump if not zero
		mov	al,0FFh
loc_c_2492:
		mov	data_b_1F3C[bx],al
loc_c_2496:
		mov	dl,data_b_1F3C[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_1F30[bx]
		cmp	dl,1
		jb	loc_c_24C2		; Jump if below
		jnz	loc_c_24B8		; Jump if not zero
		add	ax,data_b_1F69
		cmp	ax,12Fh
		jb	loc_c_24C2		; Jump if below
		mov	ax,12Eh
		mov	dl,0FFh
		jmp	short loc_c_24C2
		db	90h
loc_c_24B8:
		sub	ax,data_b_1F69
		jnc	loc_c_24C2		; Jump if carry=0
		sub	ax,ax
		mov	dl,1
loc_c_24C2:
		mov	data_b_1F30[bx],ax
		shr	bl,1			; Shift w/zeros fill
		mov	data_b_1F3C[bx],dl
		mov	dl,data_b_1F36[bx]
		mov	cx,ax
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_1F4B,ax
		mov	bx,data_b_1F6C
		cmp	data_b_1F48[bx],0
		jne	loc_c_24F0		; Jump if not equal
		mov	al,data_b_1F3C[bx]
		or	al,data_b_1F3F[bx]
		jz	loc_c_24F0		; Jump if zero
		call	sub_c_254D
loc_c_24F0:
		call	sub_c_265E
		jc	loc_ret_c_24FA		; Jump if carry Set
		call	sub_c_2567
		jnc	loc_c_24FB		; Jump if carry=0

loc_ret_c_24FA:
		retn
loc_c_24FB:
		mov	bx,data_b_1F6C
		mov	data_b_1F48[bx],0
		cmp	data_b_1F3C[bx],0
		jne	loc_c_2518		; Jump if not equal
		cmp	data_b_1F3F[bx],0
		je	loc_ret_c_254C		; Jump if equal
		mov	si,1E30h
		jmp	short loc_c_2533
			                        ;* No entry point to code
		nop
loc_c_2518:
		mov	si,offset data_b_1E50
		inc	data_b_1F4D[bx]
		test	data_b_1F4D[bx],1
		jnz	loc_c_2529		; Jump if not zero
		add	si,20h
loc_c_2529:
		cmp	data_b_1F3C[bx],1
		je	loc_c_2533		; Jump if equal
		add	si,40h
loc_c_2533:
		shl	bl,1			; Shift w/zeros fill
		mov	di,data_b_1F4B
		mov	data_b_1F42[bx],di
		mov	ax,0B800h
		mov	es,ax
		mov	bp,data_b_1F59[bx]
		mov	cx,802h
		call	sub_c_2D35

loc_ret_c_254C:
		retn
sub_c_237B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_254D	proc	near
		mov	bx,data_b_1F6C
		shl	bl,1			; Shift w/zeros fill
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_1F42[bx]
		mov	si,data_b_1F59[bx]
		mov	cx,802h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_254D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2567	proc	near
		mov	bx,data_b_1F6C
		mov	dl,data_b_1F36[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_1F30[bx]
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E08h
		call	sub_c_2E29
		jc	loc_c_258E		; Jump if carry Set
		jmp	loc_ret_c_265D
loc_c_258E:
		mov	bx,data_b_1F6C
		cmp	data_b_1F50[bx],0
		jne	loc_c_260C		; Jump if not equal
		cmp	data_b_057C,26h		; '&'
		jb	loc_c_260C		; Jump if below
		cmp	data_b_055C,0
		je	loc_c_260E		; Jump if equal
		mov	data_b_055C,0
		mov	data_b_055B,11h
		mov	data_b_0571,1
		mov	data_b_056E,0
		mov	bx,data_b_1F6C
		shl	bl,1			; Shift w/zeros fill
		mov	di,data_b_1F42[bx]
		cmp	data_b_1F30[bx],10h
		jb	loc_c_25CF		; Jump if below
		sub	di,4
loc_c_25CF:
		mov	data_b_1F67,di
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_1D70
		mov	bp,offset data_b_000E
		mov	cx,806h
		call	sub_c_2CCC
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	word ptr data_b_1F65,dx
loc_c_25EC:
		call	sub_c_5A90
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,word ptr data_b_1F65
		cmp	dx,8
		jb	loc_c_25EC		; Jump if below
		call	sub_c_5B21		; Disable sound output
		mov	di,data_b_1F67
		mov	si,offset data_b_000E
		mov	cx,806h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
loc_c_260C:
		stc				; Set carry flag
		retn
loc_c_260E:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	bx,data_b_1F6C
		mov	data_b_1F50[bx],1
		mov	data_b_1F3C[bx],1
		shl	bl,1			; Shift w/zeros fill
		mov	data_b_1F53[bx],dx
		call	sub_c_11E3
		mov	bx,data_b_1F6C
		shl	bl,1			; Shift w/zeros fill
		mov	si,data_b_1F5F[bx]
		mov	di,data_b_1F42[bx]
		mov	ax,0B800h
		mov	es,ax
		mov	bp,offset data_b_000E
		mov	cx,802h
		call	sub_c_2CCC
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)

		; increase current score
		mov	bx,data_b_1F6C
		mov	al,data_b_1F39[bx]	; points
		call	sub_c_2706		; Increase current score by AL

		mov	ax,3E8h
		mov	bx,2EEh
		call	sub_c_593B		; Start tone AX
		stc				; Set carry flag
loc_ret_c_265D:	retn

sub_c_2567	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_265E	proc	near
		cmp	data_b_1673,0
		jne	loc_c_2667		; Jump if not equal
		clc				; Clear carry flag
		retn
loc_c_2667:
		mov	bx,data_b_1F6C
		mov	dl,data_b_1F36[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_1F30[bx]
		mov	si,10h
		mov	di,si
		mov	bx,data_b_1671
		mov	dh,data_b_1673
		mov	cx,0C08h
		call	sub_c_2E29
		retn
sub_c_265E	endp

		db	7 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Update max score from current score

sub_c_2690	proc	near

		push	ds
		pop	es

		; get flags of scenes
		mov	cx,7
		mov	si,offset data_b_1F82	; digits of current score

		; compare current score and max. score
locloop_c_2698:	lodsb				; String [si] to al
		mov	bx,offset data_b_0006+1
		sub	bx,cx
		cmp	al,data_b_1F89[bx]	; compare with digits of max score
		loopz	locloop_c_2698		; Loop if zf=1, cx>0
		ja	loc_c_26A7		; Jump if above
		retn

		; copy current score to max score
loc_c_26A7:	mov	si,offset data_b_1F82	; digits of current score
		mov	di,offset data_b_1F89	; digits of max score
		mov	cx,7
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		retn

sub_c_2690	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display cat lives

sub_c_26B3	proc	near

		mov	al,data_b_1F80		; cat lives (1..9)
		cmp	al,data_b_1F81		; current display cat lives (1..9)
		jne	loc_c_26BD		; Jump if not equal
		retn

loc_c_26BD:	mov	data_b_1F81,al		; current display cat lives (1..9)
		sub	ah,ah
		mov	cl,4
		shl	ax,cl			; offset of digit
		add	ax,2720h		; font of digits
		mov	si,ax			; SI <- digit image
		mov	ax,0B800h
		mov	es,ax
		mov	di,offset data_b_1260	; address to display cat lives
		mov	cx,801h			; digit size
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn

sub_c_26B3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear digits of current score

sub_c_26DA	proc	near

		mov	di,offset data_b_1F82	; digits of current score
		call	sub_c_26E8		; Clear digits of score
		retn

sub_c_26DA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear digits of max score

sub_c_26E1	proc	near

		mov	di,offset data_b_1F89	; digits of max score
		call	sub_c_26E8		; Clear digits of score
		retn

sub_c_26E1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear digits of score

sub_c_26E8	proc	near

		push	ds
		pop	es
		mov	cx,7			; number of digits
		sub	al,al
		rep	stosb			; Rep when cx >0 Store al to es:[di]
		retn

sub_c_26E8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print max score

sub_c_26F2	proc	near

		mov	bx,offset data_b_1F89	; digits of max score
		mov	di,offset data_b_12CA
		call	sub_c_2739		; Print score DS:BX at screen DI
		retn

sub_c_26F2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print current score

sub_c_26FC	proc	near

		mov	bx,offset data_b_1F82	; digits of current score
		mov	di,offset data_b_143C
		call	sub_c_2739		; Print score DS:BX at screen DI
		retn

sub_c_26FC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Increase current score by AL

sub_c_2706	proc	near

		mov	cx,6
locloop_c_2709:	mov	bx,cx
		mov	ah,0
		add	al,data_b_1F82[bx-1]	; current score
		aaa				; Ascii adjust
		mov	data_b_1F82[bx-1],al	; current score
		mov	al,ah
		loop	locloop_c_2709		; Loop if cx > 0

		call	sub_c_26FC		; Print current score
		retn
sub_c_2706	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_271E	proc	near
		push	cx
		push	ax
		push	bx
		clc				; Clear carry flag
		pushf				; Push flags
		mov	cx,7

locloop_c_2726:
		popf				; Pop flags
		mov	bx,cx
		dec	bx
		mov	al,[bx+di]
		adc	al,[bx+si]
		aaa				; Ascii adjust
		mov	[bx+di],al
		pushf				; Push flags
		loop	locloop_c_2726		; Loop if cx > 0

		popf				; Pop flags
		pop	bx
		pop	ax
		pop	cx
		retn
sub_c_271E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print score DS:BX at screen DI

sub_c_2739	proc	near

		mov	ax,0B800h
		mov	es,ax
		mov	data_b_1F90,di		; destination address in screen
		mov	data_b_1F93,bx		; pointer to score digits
		mov	data_b_1F92,0		; digit position

loc_c_274B:	mov	bx,data_b_1F93		; pointer to score digit
		mov	al,[bx]			; load digit
		sub	ah,ah
		mov	cl,4
		shl	ax,cl			; digit * 16 = digit offset in font
		add	ax,2720h		; font of digits
		mov	si,ax
		mov	di,data_b_1F90		; destination address
		mov	cx,801h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		add	data_b_1F90,2
		inc	data_b_1F93		; pointer to score digits
		inc	data_b_1F92		; digit position
		cmp	data_b_1F92,7		; digit position
		je	loc_ret_c_2788		; end of scrore
		cmp	data_b_1F92,3		; check digit separator
		jne	loc_c_274B		; Jump if not equal
		add	data_b_1F90,2		; skip separator
		jmp	short loc_c_274B

loc_ret_c_2788:
		retn
sub_c_2739	endp

		db	7 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2790	proc	near
		mov	ax,0B800h
		mov	es,ax
		cmp	word ptr data_b_0004,2	; current scene 1..7, 0=intro
		jne	loc_c_27EE		; Jump if not equal
		cld				; Clear direction
		sub	di,di
		mov	ax,0AAAAh
		mov	cx,50h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,d_B800_2000_e
		mov	cx,50h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	data_b_2654,0
loc_c_27B5:
		call	sub_c_2DFD
;*		and	dx,18h
		db	 81h,0E2h, 18h, 00h	;  Fixup - byte match
		cmp	dl,data_b_2653
		je	loc_c_27B5		; Jump if equal
		mov	data_b_2653,dl
		mov	bx,data_b_2654
		mov	data_b_2656[bx],dl
		add	dx,2020h
		mov	si,dx
		mov	di,bx
		shl	di,1			; Shift w/zeros fill
		add	di,offset data_b_00A0
		mov	cx,401h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		inc	data_b_2654
		cmp	data_b_2654,28h
		jb	loc_c_27B5		; Jump if below
		retn
loc_c_27EE:
		cmp	word ptr data_b_0004,7	; current scene 1..7, 0=intro
		jne	loc_c_27F9		; Jump if not equal
		call	sub_c_300F
		retn
loc_c_27F9:
		cmp	word ptr data_b_0004,6	; current scene 1..7, 0=intro
		jne	loc_c_283E		; Jump if not equal
		sub	ax,ax
		call	sub_c_29A0
		mov	bx,offset data_b_2570
		mov	ax,64Ah
		call	sub_c_2B24
		mov	data_b_2650,48h
		mov	data_b_2652,38h		; '8'
		mov	ax,0DD2h
		call	sub_c_2958
		mov	ax,0DF6h
		call	sub_c_2970
		mov	si,offset data_b_1FA0
		mov	di,offset data_b_067E
		mov	cx,1002h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		mov	bx,offset data_b_2344
		mov	ax,0B84h
		call	sub_c_2B24
		call	sub_c_4B47
		retn
loc_c_283E:
		cmp	word ptr data_b_0004,5	; current scene 1..7, 0=intro
		jne	loc_c_288D		; Jump if not equal
		mov	ax,640h
		call	sub_c_29A0
		mov	bx,offset data_b_2570
		mov	ax,0CB6h
		call	sub_c_2B24
		mov	data_b_2650,0F8h
		mov	data_b_2652,60h		; '`'
		mov	ax,140Eh
		call	sub_c_2958
		mov	ax,1434h
		call	sub_c_2970
		mov	ax,143Eh
		call	sub_c_2970
		mov	ax,16A0h
		call	sub_c_2988
		mov	bx,offset data_b_2344
		mov	ax,1184h
		call	sub_c_2B24
		mov	si,offset data_b_1FE0
		mov	di,offset data_b_0DD6
		mov	cx,1002h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
loc_c_288D:
		cmp	word ptr data_b_0004,4	; current scene 1..7, 0=intro
		jne	loc_c_28BE		; Jump if not equal
		mov	ax,640h
		call	sub_c_29A0
		mov	bx,offset data_b_2570
		mov	ax,0CBAh
		call	sub_c_2B24
		mov	data_b_2650,108h
		mov	data_b_2652,60h		; '`'
		mov	ax,1439h
		call	sub_c_2958
		mov	ax,16C0h
		call	sub_c_2945
		call	sub_c_3F9E
		retn
loc_c_28BE:
		cmp	word ptr data_b_0004,3	; current scene 1..7, 0=intro
		jne	loc_c_2909		; Jump if not equal
		mov	ax,640h
		call	sub_c_29A0
		mov	bx,offset data_b_2570
		mov	ax,0C90h
		call	sub_c_2B24
		mov	data_b_2650,60h
		mov	data_b_2652,60h		; '`'
		mov	ax,140Ch
		call	sub_c_2958
		mov	ax,1418h
		call	sub_c_2970
		mov	bx,offset data_b_2344
		mov	ax,1184h
		call	sub_c_2B24
		mov	bx,offset data_b_2344
		mov	ax,11A2h
		call	sub_c_2B24
		mov	bx,offset data_b_2624
		sub	ax,ax
		call	sub_c_2B24
		call	sub_c_3BDB
		retn
loc_c_2909:
		mov	ax,640h
		call	sub_c_29A0
		mov	bx,offset data_b_2570
		mov	ax,0CA0h
		call	sub_c_2B24
		mov	data_b_2650,0A0h
		mov	data_b_2652,60h		; '`'
		mov	ax,1406h
		call	sub_c_2958
		mov	bx,offset data_b_2344
		mov	ax,11C4h
		call	sub_c_2B24
		mov	ax,1422h
		call	sub_c_2970
		mov	ax,1690h
		call	sub_c_2988
		mov	ax,16B6h
		call	sub_c_2945
		retn
sub_c_2790	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2945	proc	near
		mov	data_b_2634,ax
		mov	bx,offset data_b_2384
		call	sub_c_2B24
		mov	ax,data_b_2634
		mov	bx,offset data_b_238C
		call	sub_c_2B24
		retn
sub_c_2945	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2958	proc	near
		mov	data_b_2634,ax
		mov	si,offset data_b_0008
loc_c_295E:
		mov	ax,data_b_2634
		mov	bx,data_b_2634[si]
		push	si
		call	sub_c_2B24
		pop	si
		sub	si,2
		jnz	loc_c_295E		; Jump if not zero
		retn
sub_c_2958	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2970	proc	near
		mov	data_b_2634,ax
		mov	si,offset data_b_000A
loc_c_2976:
		mov	ax,data_b_2634
		mov	bx,data_b_263C[si]
		push	si
		call	sub_c_2B24
		pop	si
		sub	si,2
		jnz	loc_c_2976		; Jump if not zero
		retn
sub_c_2970	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2988	proc	near
		mov	data_b_2634,ax
		mov	si,offset data_b_0008
loc_c_298E:
		mov	ax,data_b_2634
		mov	bx,data_b_2646[si]
		push	si
		call	sub_c_2B24
		pop	si
		sub	si,2
		jnz	loc_c_298E		; Jump if not zero
		retn
sub_c_2988	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_29A0	proc	near
		mov	data_b_267E,ax
		mov	bx,offset data_b_251C
		call	sub_c_2B24
		sub	ax,ax
		cld				; Clear direction
		mov	di,data_b_267E
		add	di,d_B800_0284_e
		mov	cx,24h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,data_b_267E
		add	di,d_B800_1184_e
		mov	cx,24h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,data_b_267E
		add	di,d_B800_2284_e
		mov	al,2Ah			; '*'
		call	sub_c_29E1		; Display vertical line AL (95 lines), ES:DI=dst screen
		mov	di,data_b_267E
		add	di,d_B800_22CB_e
		mov	al,0A8h
		call	sub_c_29E1		; Display vertical line AL (95 lines), ES:DI=dst screen
		retn
sub_c_29A0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display vertical line AL (95 lines, 4 pixels), ES:DI=dst screen

sub_c_29E1	proc	near

		mov	cx,5Fh
locloop_c_29E4:	mov	es:[di],al
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_29F4		; Jump if not zero
		add	di,50h
loc_c_29F4:	loop	locloop_c_29E4		; Loop if cx > 0
		retn
sub_c_29E1	endp

		db	9 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2A00	proc	near

		; clear screen with MAGENTA color
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		sub	di,di
		mov	ax,0AAAAh
		mov	cx,0FA0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,d_B800_2000_e
		mov	cx,0FA0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]

		call	sub_c_2B9E
		mov	bx,offset data_b_28A0
		sub	ax,ax
		call	sub_c_2B24
		call	sub_c_2A68
		call	sub_c_2C84
		call	sub_c_2B8B		; Display 4x3 image ???, ES:DI=dst screen, delta X = 20
		call	sub_c_2A80
		retn
sub_c_2A00	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2A30	proc	near

		; clear screen with MAGENTA color
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		sub	di,di
		mov	ax,0AAAAh
		mov	cx,0FA0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,d_B800_2000_e
		mov	cx,0FA0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]

		call	sub_c_2B9E
		mov	bx,offset data_b_28A0
		sub	ax,ax
		call	sub_c_2B24
		call	sub_c_2A68
		mov	ax,data_b_0008
		push	ax
		mov	data_b_0008,1
		call	sub_c_2C84
		pop	ax
		mov	data_b_0008,ax
		retn
sub_c_2A30	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2A68	proc	near
		mov	bx,word ptr data_b_6DF8	; skill level 0=Kitten, 1=House Car, 2=Timcat, 3=Alley Cat
;*		and	bx,3
		db	 81h,0E3h, 03h, 00h	;  Fixup - byte match
		shl	bl,1			; Shift w/zeros fill
		mov	si,data_b_2AD1[bx]
		mov	di,offset data_b_1902
		mov	cx,801h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_2A68	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2A80	proc	near

		; clear buffer
		mov	bx,offset data_b_000F
loc_c_2A83:	mov	data_b_1015[bx],0
		dec	bx
		jnz	loc_c_2A83		; Jump if not zero

		mov	di,140h
		mov	bh,80h
		mov	data_b_2ACA,0
		call	sub_c_2AC6
		mov	di,640h
		mov	bh,30h			; '0'
		mov	data_b_2ACA,5
		call	sub_c_2AC6
		mov	di,0B40h
		mov	bh,0
		mov	data_b_2ACA,0Ah
		call	sub_c_2AC6
		mov	data_b_0525,10h
		mov	data_b_052F,0
		mov	data_b_0531,1
		retn
sub_c_2A80	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2AC6	proc	near
		mov	data_b_2AC9,bh
		mov	data_b_2AC4,0
loc_c_2ACF:
		push	di
		push	es
		mov	bx,data_b_0008
		mov	bl,data_b_2ABA[bx]
		mov	bh,data_b_2AC9
		mov	ax,seg_b
		mov	es,ax
		mov	di,offset data_b_04D7
		call	sub_c_067D
		pop	es
		pop	di
		push	di
		mov	si,offset data_b_04D7
		mov	cx,1002h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		sub	bh,bh
		mov	bl,data_b_2AC4
		mov	cl,bl
		shr	bl,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		not	cl
		and	cl,3
		shl	cl,1			; Shift w/zeros fill
		mov	al,data_b_0540
		shl	al,cl			; Shift w/zeros fill
		mov	si,data_b_2ACA
		or	data_b_1016[bx+si],al
		pop	di
		add	di,4
		inc	data_b_2AC4
		cmp	data_b_2AC4,14h
		jb	loc_c_2ACF		; Jump if below
		retn
sub_c_2AC6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2B24	proc	near
		mov	cx,[bx]
		mov	data_b_2AC7,cx
		mov	data_b_2ACC,ax
		add	bx,2

loc_c_2B30:	mov	si,[bx]
;*		cmp	si,0FFFFh
		db	 81h,0FEh,0FFh,0FFh	;  Fixup - byte match
		jnz	loc_c_2B39		; Jump if not zero
		retn

loc_c_2B39:	mov	di,[bx+2]
		add	di,data_b_2ACC
		cld				; Clear direction
		mov	data_b_2AD0,ch
		sub	ch,ch
		mov	data_b_2ACE,cx

loc_c_2B4B:	mov	cx,data_b_2ACE
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,data_b_2ACE
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_2B62		; Jump if not zero
		add	di,50h
loc_c_2B62:	dec	data_b_2AD0
		jnz	loc_c_2B4B		; Jump if not zero

		add	bx,4
		mov	cx,data_b_2AC7
		jmp	short loc_c_2B30
sub_c_2B24	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display 4x image ???, ES:DI=dst screen, delta X = 20

sub_c_2B71	proc	near
		mov	data_b_2AC4,4
loc_c_2B76:
		mov	si,offset data_b_2680
		mov	cx,1005h
		push	di
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	di
		add	di,14h
		dec	data_b_2AC4
		jnz	loc_c_2B76		; Jump if not zero
		retn
sub_c_2B71	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display 4x3 image ???, ES:DI=dst screen, delta X = 20

sub_c_2B8B	proc	near
		mov	di,offset data_b_03C5
		call	sub_c_2B71		; Display 4x image ???, ES:DI=dst screen, delta X = 20
		mov	di,offset data_b_08C5
		call	sub_c_2B71		; Display 4x image ???, ES:DI=dst screen, delta X = 20
		mov	di,offset data_b_0DC5
		call	sub_c_2B71		; Display 4x image ???, ES:DI=dst screen, delta X = 20
		retn
sub_c_2B8B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2B9E	proc	near
		mov	word ptr data_b_2AC2,103Eh
loc_c_2BA4:
		add	word ptr data_b_2AC2,2
		mov	di,word ptr data_b_2AC2
		cmp	di,1090h
		jae	loc_c_2BD2		; Jump if above or =
loc_c_2BB3:
		call	sub_c_2DFD
;*		and	dx,30h
		db	 81h,0E2h, 30h, 00h	;  Fixup - byte match
		cmp	dl,data_b_2AC4
		je	loc_c_2BB3		; Jump if equal
		mov	data_b_2AC4,dl
		add	dx,2904h
		mov	si,dx
		mov	cx,801h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		jmp	short loc_c_2BA4

		; clear screen with color
loc_c_2BD2:	mov	di,d_B800_1180_e
		mov	ax,5655h
		mov	cx,500h
		cld				; Clear direction
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,d_B800_3180_e
		mov	cx,500h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	word ptr data_b_2AC2,2944h
loc_c_2BEC:
		mov	data_b_2AC4,9
loc_c_2BF1:
		call	sub_c_2DFD
		and	dx,776h
		add	dx,12C0h
		mov	di,dx
		mov	si,word ptr data_b_2AC2
		mov	cx,501h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		dec	data_b_2AC4
		jnz	loc_c_2BF1		; Jump if not zero
		add	word ptr data_b_2AC2,0Ah
		cmp	word ptr data_b_2AC2,296Ch
		jb	loc_c_2BEC		; Jump if below
		mov	data_b_2AC4,5
loc_c_2C20:
		call	sub_c_2DFD
;*		and	dx,3Eh
		db	 81h,0E2h, 3Eh, 00h	;  Fixup - byte match
		add	dx,3A98h
		mov	di,dx
		mov	si,296Ch
		mov	cx,501h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		dec	data_b_2AC4
		jnz	loc_c_2C20		; Jump if not zero
		retn
sub_c_2B9E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2C3D	proc	near
		mov	word ptr data_b_2AC2,di
		mov	al,3
		cmp	di,offset data_b_1720
		jb	loc_c_2C4B		; Jump if below
		dec	al
loc_c_2C4B:
		mov	data_b_2AC4,al
		add	word ptr data_b_2AC2,1E0h
		mov	si,2976h
		mov	cx,0C05h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
loc_c_2C5D:
		mov	di,word ptr data_b_2AC2
		add	word ptr data_b_2AC2,140h
		mov	si,29EEh
		mov	cx,804h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		dec	data_b_2AC4
		jnz	loc_c_2C5D		; Jump if not zero
		mov	di,word ptr data_b_2AC2
		mov	si,offset data_b_2A2E
		mov	cx,0B04h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_2C3D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2C84	proc	near
		mov	bx,data_b_0008
		mov	bl,data_b_2AB2[bx]
loc_c_2C8C:
		mov	data_b_2AC5,bx
		mov	di,data_b_2A86[bx]
		cmp	di,0
		jne	loc_c_2C9A		; Jump if not equal
		retn
loc_c_2C9A:
		call	sub_c_2C3D
		mov	bx,data_b_2AC5
		add	bx,2
		jmp	short loc_c_2C8C
sub_c_2C84	endp

		db	0C3h
		db	9 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index

sub_c_2CB0	proc	near	
		mov	al,dl
		mov	ah,28h			; '(' = 40
		mul	ah			; ax = reg * al
		test	dl,1
		jz	loc_c_2CBE		; Jump if zero
		add	ax,1FD8h
loc_c_2CBE:
		mov	dx,cx
		shr	dx,1			; Shift w/zeros fill
		shr	dx,1			; Shift w/zeros fill
		add	ax,dx
		and	cl,3
		shl	cl,1			; Shift w/zeros fill
		retn
sub_c_2CB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2CCC	proc	near
		cld				; Clear direction
		mov	byte ptr data_b_2AE0,cl ; image width
		mov	data_b_2AE2,ch		; image height
		sub	ch,ch
		mov	dx,0FF0h
loc_c_2CDA:
		mov	cl,byte ptr data_b_2AE0 ; image width

locloop_c_2CDE:
		mov	dx,30C0h
		mov	bx,es:[di]
		mov	ds:[bp],bx
		lodsw				; String [si] to ax
		mov	data_b_2AE3,ax
loc_c_2CEC:
		test	ah,dl
		jnz	loc_c_2CF2		; Jump if not zero
		or	ah,dl
loc_c_2CF2:
		test	ah,dh
		jnz	loc_c_2CF8		; Jump if not zero
		or	ah,dh
loc_c_2CF8:
		test	al,dl
		jnz	loc_c_2CFE		; Jump if not zero
		or	al,dl
loc_c_2CFE:
		test	al,dh
		jnz	loc_c_2D04		; Jump if not zero
		or	al,dh
loc_c_2D04:
		xor	dx,33CCh
		test	dh,3
		jnz	loc_c_2CEC		; Jump if not zero
		and	ax,bx
		or	ax,data_b_2AE3
		stosw				; Store ax to es:[di]
		add	bp,2
		loop	locloop_c_2CDE		; Loop if cx > 0

		sub	di,data_b_2AE0		; image width
		sub	di,data_b_2AE0		; image width
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_2D2E		; Jump if not zero
		add	di,50h
loc_c_2D2E:
		dec	data_b_2AE2		; image height
		jnz	loc_c_2CDA		; Jump if not zero
		retn
sub_c_2CCC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2D35	proc	near
		cld				; Clear direction
		mov	byte ptr data_b_2AE0,cl	; image width
		mov	data_b_2AE2,ch		; image height
		sub	ch,ch
loc_c_2D40:
		mov	cl,byte ptr data_b_2AE0 ; image width

locloop_c_2D44:
		mov	bx,es:[di]
		mov	ds:[bp],bx
		lodsw				; String [si] to ax
		and	ax,bx
		stosw				; Store ax to es:[di]
		add	bp,2
		loop	locloop_c_2D44		; Loop if cx > 0

		sub	di,data_b_2AE0		; image width
		sub	di,data_b_2AE0		; image width
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_2D69		; Jump if not zero
		add	di,50h
loc_c_2D69:
		dec	data_b_2AE2		; image height
		jnz	loc_c_2D40		; Jump if not zero
		retn
sub_c_2D35	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2D70	proc	near
		cld				; Clear direction
		mov	data_b_2AE9,si
		mov	byte ptr data_b_2AE0,cl	; image width
		mov	data_b_2AE2,ch		; image height
		shl	al,1			; Shift w/zeros fill
		mov	data_b_2AEB,al
		sub	ch,ch
loc_c_2D84:
		mov	cl,byte ptr data_b_2AE0	; image width
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		mov	cl,data_b_2AEB
		add	data_b_2AE9,cx
		mov	si,data_b_2AE9
		dec	data_b_2AE2		; image height
		jnz	loc_c_2D84		; Jump if not zero
		retn
sub_c_2D70	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

sub_c_2D9D	proc	near
		cld				; Clear direction
		mov	byte ptr data_b_2AE0,cl	; image width
		mov	data_b_2AE2,ch		; image height
		sub	ch,ch
loc_c_2DA8:
		mov	cl,byte ptr data_b_2AE0	; image width
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di]
		sub	di,data_b_2AE0		; image width
		sub	di,data_b_2AE0		; image width
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_2DC3		; Jump if not zero
		add	di,50h
loc_c_2DC3:
		dec	data_b_2AE2		; image height
		jnz	loc_c_2DA8		; Jump if not zero
		retn
sub_c_2D9D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Load part of screen into buffer (ES:DI=dst buffer, DS:SI=source screen, CL=width, CH=height)

sub_c_2DCA	proc	near

		cld				; Clear direction
		mov	byte ptr es:data_b_2AE0,cl ; image width
		mov	es:data_b_2AE2,ch	; image height
		sub	ch,ch

loc_c_2DD7: 	mov	cl,byte ptr es:data_b_2AE0 ; image width
		rep	movsw			; Rep when cx >0 Mov [si] to es:[di] .. copy one image line
		sub	si,es:data_b_2AE0	; - image width
		sub	si,es:data_b_2AE0	; - image width
		xor	si,2000h		; change strip
		test	si,2000h
		jnz	loc_c_2DF5		; Jump if not zero
		add	si,50h			; add source
loc_c_2DF5:
		dec	es:data_b_2AE2		; image height
		jnz	loc_c_2DD7		; Jump if not zero
		retn
sub_c_2DCA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2DFD	proc	near
		mov	dx,data_b_2AE5
		xor	dl,dh
		shr	dl,1			; Shift w/zeros fill
		shr	dl,1			; Shift w/zeros fill
		rcr	data_b_2AE5,1		; Rotate thru carry
		mov	dx,data_b_2AE5
		retn
sub_c_2DFD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Read 8253 counter

sub_c_2E10	proc	near
		mov	al,0
		out	43h,al			; port 43h, 8253 timer control
						;  al = 0, latch timer0 count
		nop
		nop
		in	al,40h			; port 40h, 8253 timer 0 clock
		mov	ah,al
		nop
		in	al,40h			; port 40h, 8253 timer 0 clock
		cmp	ax,0
		jne	loc_c_2E25		; Jump if not equal
		mov	ax,0FA59h
loc_c_2E25:
		mov	data_b_2AE5,ax
		retn
sub_c_2E10	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2E29	proc	near
		add	ax,si
		cmp	ax,bx
		jb	loc_c_2E4F		; Jump if below
		sub	ax,si
		sub	ax,di
		jnc	loc_c_2E37		; Jump if carry=0
		sub	ax,ax
loc_c_2E37:
		cmp	ax,bx
		ja	loc_c_2E4F		; Jump if above
		add	dl,cl
		cmp	dl,dh
		jb	loc_c_2E4F		; Jump if below
		sub	dl,cl
		sub	dl,ch
		jnc	loc_c_2E49		; Jump if carry=0
		sub	dl,dl
loc_c_2E49:
		cmp	dl,dh
		ja	loc_c_2E4F		; Jump if above
		stc				; Set carry flag
		retn
loc_c_2E4F:
		clc				; Clear carry flag
		retn
sub_c_2E29	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2E60	proc	near
		cmp	data_b_2E8D,8
		jb	loc_c_2E68		; Jump if below

loc_ret_c_2E67:
		retn
loc_c_2E68:
		cmp	data_b_069A,0		; key Alt drinking (0=pressed, 10h=released)
		jne	loc_ret_c_2E67		; Jump if not equal
		mov	data_b_2E92,0FFFFh
		mov	data_b_2E91,0FFh
		mov	cx,7

locloop_c_2E7D:
		mov	bx,cx
		dec	bx
		mov	al,data_b_057B
		sub	al,data_b_2BD4[bx]
		jnc	loc_c_2E8B		; Jump if carry=0
		not	al
loc_c_2E8B:
		cmp	al,data_b_2E91
		ja	loc_c_2E98		; Jump if above
		mov	data_b_2E91,al
		mov	data_b_2E92,bx
loc_c_2E98:
		loop	locloop_c_2E7D		; Loop if cx > 0

;*		cmp	data_b_2E92,0FFFFh
		db	 81h, 3Eh, 92h, 2Eh,0FFh,0FFh	;  Fixup - byte match
		jnz	loc_c_2EA8		; Jump if not zero
		mov	data_b_2E92,0
loc_c_2EA8:
		mov	bx,data_b_2E8D
		mov	si,data_b_2E92
		mov	al,data_b_2BD4[si]
		mov	data_b_2B6A[bx],al
		mov	data_b_2E98,al
		mov	ax,data_b_0579
		shl	bl,1			; Shift w/zeros fill
		cmp	ax,108h
		jb	loc_c_2EC8		; Jump if below
		mov	ax,107h
loc_c_2EC8:
		and	ax,0FFCh
		mov	data_b_2B5A[bx],ax
		mov	data_b_2E96,ax
		mov	cx,8

locloop_c_2ED5:
		mov	bx,cx
		dec	bx
		cmp	bx,data_b_2E8D
		je	loc_c_2F07		; Jump if equal
		cmp	byte ptr data_b_2B72[bx],0
		je	loc_c_2F07		; Jump if equal
		push	cx
		mov	dl,data_b_2B6A[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_2B5A[bx]
		mov	bx,data_b_2E96
		mov	dh,data_b_2E98
		mov	si,18h
		mov	di,si
		mov	cx,0F0Fh
		call	sub_c_2E29
		pop	cx
		jnc	loc_c_2F07		; Jump if carry=0
		retn
loc_c_2F07:
		loop	locloop_c_2ED5		; Loop if cx > 0

		call	sub_c_11E3
		cmp	data_b_70F2,0
		je	loc_c_2F16		; Jump if equal
		call	sub_c_622B
loc_c_2F16:
		mov	bx,data_b_2E8D
		mov	data_b_2E94,bx
		mov	byte ptr data_b_2B72[bx],1
		mov	dl,data_b_2B6A[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_2B5A[bx]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,offset data_b_2AF0
		mov	ax,0B800h
		mov	es,ax
		mov	cx,0F03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		mov	data_b_2E8D,0FFFFh
		sub	bx,bx
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		call	sub_c_4E3E
		cmp	data_b_70F2,0
		je	loc_c_2F59		; Jump if equal
		call	sub_c_61FA
loc_c_2F59:
		call	sub_c_1145
		mov	ax,3E8h
		mov	bx,4A5h
		call	sub_c_593B		; Start tone AX
		retn
sub_c_2E60	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_2F66	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_2E8F
		jne	loc_c_2F71		; Jump if not equal
		retn
loc_c_2F71:
		mov	data_b_2E8F,dx
		cmp	data_b_2E8D,8
		jb	loc_c_2FAC		; Jump if below
		mov	cx,8

locloop_c_2F7F:
		mov	bx,cx
		dec	bx
		cmp	byte ptr data_b_2B72[bx],0
		je	loc_c_2FAA		; Jump if equal
		push	cx
		mov	dl,data_b_2B6A[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_2B5A[bx]
		mov	si,18h
		mov	di,si
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	cx,0E0Fh
		call	sub_c_2E29
		pop	cx
		jc	loc_c_2FB3		; Jump if carry Set
loc_c_2FAA:
		loop	locloop_c_2F7F		; Loop if cx > 0

loc_c_2FAC:
		mov	data_b_2E94,0FFFFh

loc_ret_c_2FB2:
		retn
loc_c_2FB3:
		mov	bx,cx
		dec	bx
		cmp	bx,data_b_2E94
		je	loc_ret_c_2FB2		; Jump if equal
		push	bx
		call	sub_c_11E3
		cmp	data_b_70F2,0
		je	loc_c_2FCA		; Jump if equal
		call	sub_c_622B
loc_c_2FCA:
		pop	bx
		mov	byte ptr data_b_2B72[bx],0
		mov	dl,data_b_2B6A[bx]
		mov	data_b_2E8D,bx
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_2B5A[bx]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,offset data_b_2B7A	; ('UUUUUUUUUUUUUUUUUUUUUUUU')
		mov	ax,0B800h
		mov	es,ax
		mov	cx,0F03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		cmp	data_b_70F2,0
		je	loc_c_2FFB		; Jump if equal
		call	sub_c_61FA
loc_c_2FFB:
		call	sub_c_1145
		mov	bx,1
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	ax,3E8h
		mov	bx,349h
		call	sub_c_593B		; Start tone AX
		retn
sub_c_2F66	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_300F	proc	near
		sub	ax,ax
		mov	bx,offset data_b_2E24
		call	sub_c_2B24
		mov	data_b_2E8A,0BFh
		mov	data_b_2E8B,0
loc_c_3022:
		mov	data_b_2E88,20h
loc_c_3028:
		sub	bx,bx
		cmp	data_b_2E8A,0BFh
		je	loc_c_3039		; Jump if equal
		call	sub_c_2DFD
		mov	bl,dl
		and	bl,2
loc_c_3039:
		mov	cx,data_b_2E88
		mov	dl,data_b_2E8A
		push	bx
		call	sub_c_30E3
		pop	bx
		mov	si,data_b_2E8B
		mov	ax,data_b_2E88
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		sub	ax,2
		jnc	loc_c_3058		; Jump if carry=0
		sub	ax,ax
loc_c_3058:
		cmp	ax,12h
		jb	loc_c_3060		; Jump if below
		mov	ax,11h
loc_c_3060:
		mov	dl,data_b_2BDB[si]
		sub	dh,dh
		add	ax,dx
		mov	si,ax
		mov	byte ptr data_b_2BE2[si],bl
		add	data_b_2E88,10h
		cmp	data_b_2E88,111h
		jb	loc_c_3028		; Jump if below
		inc	data_b_2E8B
		sub	data_b_2E8A,18h
		cmp	data_b_2E8A,2Fh		; '/'
		jae	loc_c_3022		; Jump if above or =
		mov	ax,0FFFFh
		mov	data_b_2E8D,ax
		mov	data_b_2E94,ax
		sub	ax,ax
		mov	data_b_2B72,ax
		mov	data_b_2B74,ax
		mov	data_b_2B76,ax
		mov	data_b_2B78,ax
		mov	cx,data_b_0414
		cmp	cx,0
		jne	loc_c_30B0		; Jump if not equal
		inc	cx
		mov	data_b_0414,cx
loc_c_30B0:
		cmp	cx,8
		jbe	locloop_c_30B8		; Jump if below or =
		mov	cx,8

locloop_c_30B8:
		mov	bx,cx
		dec	bx
		mov	byte ptr data_b_2B72[bx],1
		mov	dl,0B0h
		mov	data_b_2B6A[bx],dl
		push	cx
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_2B4A[bx]
		mov	data_b_2B5A[bx],cx
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,offset data_b_2AF0
		mov	cx,0F03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	cx
		loop	locloop_c_30B8		; Loop if cx > 0

		retn
sub_c_300F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_30E3	proc	near
		push	bx
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	ax,0B800h
		mov	es,ax
		pop	bx
		mov	si,data_b_2E20[bx]
		mov	cx,802h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_30E3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_30FA	proc	near
		mov	al,data_b_057B
		sub	al,5
		and	al,0F8h
		mov	cx,7

locloop_c_3104:
		mov	bx,cx
		dec	bx
		cmp	al,data_b_2BD4[bx]
		je	loc_c_3111		; Jump if equal
		loop	locloop_c_3104		; Loop if cx > 0

		jmp	short loc_c_314D
loc_c_3111:
		mov	ch,al
		mov	ax,data_b_0579
		add	ax,7
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		sub	ax,2
		jnc	loc_c_3124		; Jump if carry=0
		sub	ax,ax
loc_c_3124:
		cmp	ax,12h
		jb	loc_c_312C		; Jump if below
		mov	ax,11h
loc_c_312C:
		mov	dl,data_b_2BDB[bx]
		sub	dh,dh
		add	ax,dx
		mov	si,ax
		cmp	byte ptr data_b_2BE2[si],0
		jne	loc_c_314D		; Jump if not equal
		add	ch,5
		mov	data_b_057B,ch
		add	ch,32h			; '2'
		mov	data_b_057C,ch
		stc				; Set carry flag
		retn
loc_c_314D:
		clc				; Clear carry flag
		retn
sub_c_30FA	endp

		db	0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3150	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	bx,word ptr data_b_0004	; current scene 1..7, 0=intro
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_32F2[bx]
		mov	ax,dx
		sub	ax,data_b_328C
		cmp	ax,cx
		jae	loc_c_3169		; Jump if above or =

loc_ret_c_3168:
		retn
loc_c_3169:
		mov	data_b_328C,dx
		call	sub_c_33BA
		jc	loc_ret_c_3168		; Jump if carry Set
		call	sub_c_21E0
		jc	loc_ret_c_3168		; Jump if carry Set
		inc	data_b_32EA
		call	sub_c_2DFD
		mov	al,data_b_32EA
		and	al,dl
		xor	data_b_32EB,al
		mov	ax,data_b_327D
		sub	ax,data_b_0579
		mov	dl,0FFh
		jnc	loc_c_3196		; Jump if carry=0
		not	ax
		mov	dl,1
loc_c_3196:
		mov	data_b_32ED,dl
		mov	bl,data_b_327F
		add	bl,14h
		sub	bl,data_b_057B
		mov	dl,0FFh
		jnc	loc_c_31AD		; Jump if carry=0
		not	bl
		mov	dl,1
loc_c_31AD:
		mov	data_b_32EE,dl
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		shr	bl,1			; Shift w/zeros fill
		add	al,bl
		mov	data_b_32EC,al
		mov	bx,data_b_328A
		cmp	bx,27h
		jb	loc_c_31CC		; Jump if below
		mov	bx,offset data_b_0026
		mov	data_b_328A,bx
loc_c_31CC:
		cmp	data_b_328E[bx],0
		jne	loc_c_324B		; Jump if not equal
		dec	data_b_328A
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_0410
		mov	cl,3
		shr	dx,cl			; Shift w/zeros fill
		mov	al,data_b_32EC
		sub	al,dl
		jnc	loc_c_31EC		; Jump if carry=0
		sub	al,al
loc_c_31EC:
		cmp	al,data_b_32EB
		jb	loc_c_3212		; Jump if below
		mov	data_b_3281,1
		call	sub_c_2DFD
		cmp	dl,0
		je	loc_c_320B		; Jump if equal
		cmp	dl,7
		ja	loc_c_320F		; Jump if above
		and	dl,1
		jnz	loc_c_320B		; Jump if not zero
		mov	dl,0FFh
loc_c_320B:
		mov	data_b_3280,dl
loc_c_320F:
		jmp	loc_c_32AC
loc_c_3212:
		mov	al,data_b_32EB
		and	al,2Fh			; '/'
		jnz	loc_c_3238		; Jump if not zero
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_3223		; Jump if not zero
		mov	dl,0FFh
loc_c_3223:
		mov	data_b_3280,dl
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_3231		; Jump if not zero
		mov	dl,0FFh
loc_c_3231:
		mov	data_b_3281,dl
		jmp	short loc_c_32AC
		db	90h
loc_c_3238:
		and	al,7
		jnz	loc_c_32AC		; Jump if not zero
		mov	al,data_b_32ED
		mov	data_b_3280,al
		mov	al,data_b_32EE
		mov	data_b_3281,al
		jmp	short loc_c_32AC
		db	90h
loc_c_324B:
		mov	data_b_3281,1
		mov	ax,bx
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
		cmp	data_b_327D,ax
		je	loc_c_3269		; Jump if equal
		mov	dl,1
		jc	loc_c_3262		; Jump if carry Set
		mov	dl,0FFh
loc_c_3262:
		mov	data_b_3280,dl
		jmp	short loc_c_32AC
		db	90h
loc_c_3269:
		mov	data_b_3280,0
		cmp	data_b_327F,0A5h
		jne	loc_c_32AC		; Jump if not equal
		mov	data_b_3281,0
		cmp	data_b_327A,6
		je	loc_c_3288		; Jump if equal
		cmp	data_b_327A,12h
		jne	loc_c_32AC		; Jump if not equal
loc_c_3288:
		push	bx
		mov	si,offset data_b_31E8
		mov	di,data_b_3282
		mov	cx,1E02h
		mov	ax,0B800h
		mov	es,ax
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	bx
		dec	data_b_328E[bx]
		mov	al,data_b_328E[bx]
		call	sub_c_347F
		mov	data_b_3286,1
loc_c_32AC:
		mov	cx,data_b_327D
		mov	dl,data_b_327F
		mov	data_b_32EF,cx
		mov	data_b_32F1,dl
		cmp	data_b_3280,1
		jb	loc_c_32DA		; Jump if below
		jnz	loc_c_32D3		; Jump if not zero
		add	cx,8
		cmp	cx,131h
		jb	loc_c_32DA		; Jump if below
		mov	cx,130h
		jmp	short loc_c_32DA
loc_c_32D3:
		sub	cx,8
		jnc	loc_c_32DA		; Jump if carry=0
		sub	cx,cx
loc_c_32DA:
;*		and	cx,0FFF8h
		db	 81h,0E1h,0F8h,0FFh	;  Fixup - byte match
		mov	data_b_327D,cx
		cmp	data_b_3281,1
		jb	loc_c_32FE		; Jump if below
		jnz	loc_c_32F7		; Jump if not zero
		add	dl,2
		cmp	dl,0A6h
		jb	loc_c_32FE		; Jump if below
		mov	dl,0A5h
		jmp	short loc_c_32FE
loc_c_32F7:
		sub	dl,2
		jnc	loc_c_32FE		; Jump if carry=0
		sub	dl,dl
loc_c_32FE:
		mov	data_b_327F,dl
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_3284,ax
		call	sub_c_33BA
		jnc	loc_c_3328		; Jump if carry=0
loc_c_330D:
		mov	data_b_3280,0
		mov	data_b_3281,0
		mov	cx,data_b_32EF
		mov	data_b_327D,cx
		mov	dl,data_b_32F1
		mov	data_b_327F,dl
		retn
loc_c_3328:
		call	sub_c_21E0
		jc	loc_c_330D		; Jump if carry Set
		call	sub_c_33A0
		add	data_b_327A,2
		call	sub_c_3339
		retn
sub_c_3150	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3339	proc	near
loc_c_3339:
		mov	bx,data_b_327A
		mov	ax,data_b_3260[bx]
		cmp	ax,0
		jne	loc_c_334B		; Jump if not equal
		mov	data_b_327A,ax
		jmp	short loc_c_3339
loc_c_334B:
		mov	si,ax
		mov	di,data_b_3284
		mov	data_b_3282,di
		mov	bp,offset data_b_31E8
		mov	ax,0B800h
		mov	es,ax
		mov	cx,1E02h
		mov	data_b_3286,0
		cld				; Clear direction
		mov	data_b_3289,ch
		sub	ch,ch
		mov	data_b_3287,cx
loc_c_3370:
		mov	cx,data_b_3287

locloop_c_3374:
		mov	bx,es:[di]
		mov	ds:[bp],bx
		lodsw				; String [si] to ax
		or	ax,bx
		stosw				; Store ax to es:[di]
		add	bp,2
		loop	locloop_c_3374		; Loop if cx > 0

		sub	di,data_b_3287
		sub	di,data_b_3287
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_3399		; Jump if not zero
		add	di,50h
loc_c_3399:
		dec	data_b_3289
		jnz	loc_c_3370		; Jump if not zero
		retn
sub_c_3339	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_33A0	proc	near
		cmp	data_b_3286,0
		jne	loc_ret_c_33B9		; Jump if not equal
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_31E8
		mov	di,data_b_3282
		mov	cx,1E02h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_33B9:
		retn
sub_c_33A0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_33BA	proc	near
		cmp	data_b_1CB8,0
		jne	loc_c_3403		; Jump if not equal
		cmp	word ptr data_b_0004,6	; current scene 1..7, 0=intro
		jne	loc_c_33D3		; Jump if not equal
		cmp	data_b_44BD,0
		je	loc_c_33D3		; Jump if equal
		call	sub_c_47B0
		retn
loc_c_33D3:
		mov	ax,data_b_327D
		mov	dl,data_b_327F
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E1Eh
		call	sub_c_2E29
		jnc	loc_c_3403		; Jump if carry=0
		cmp	word ptr data_b_0004,4	; current scene 1..7, 0=intro
		jne	loc_c_33FE		; Jump if not equal
		cmp	data_b_39E1,0
		jne	loc_c_3401		; Jump if not equal
loc_c_33FE:
		call	sub_c_0872
loc_c_3401:
		stc				; Set carry flag
		retn
loc_c_3403:
		clc				; Clear carry flag
		retn
sub_c_33BA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3405	proc	near
		cld				; Clear direction
		sub	ax,ax
		push	ds
		pop	es
		mov	di,offset data_b_328E
		mov	cx,14h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	data_b_32B6,0FFh
		mov	data_b_327A,0
		mov	data_b_327D,0
		mov	data_b_327F,0A0h
		mov	data_b_3286,1
		mov	data_b_3280,0
		mov	data_b_3281,0
		call	sub_c_2DFD
		mov	data_b_32EB,dl
		mov	data_b_32EA,6Ch		; 'l'
		retn
sub_c_3405	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3445	proc	near
		cmp	data_b_057B,0B4h
		jb	loc_ret_c_347E		; Jump if below
		cmp	data_b_056E,0
		je	loc_ret_c_347E		; Jump if equal
		mov	ax,data_b_0579
		add	ax,0Ch
		mov	cl,3
		shr	ax,cl			; Shift w/zeros fill
		cmp	ax,27h
		ja	loc_ret_c_347E		; Jump if above
		cmp	ax,data_b_32B6
		je	loc_ret_c_347E		; Jump if equal
		mov	data_b_32B6,ax
		mov	bx,ax
		mov	al,data_b_328E[bx]
		cmp	al,4
		jae	loc_ret_c_347E		; Jump if above or =
		inc	al
		mov	data_b_328E[bx],al
		call	sub_c_347F

loc_ret_c_347E:
		retn
sub_c_3445	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_347F	proc	near
		mov	ah,0Ah
		mul	ah			; ax = reg * al
		add	ax,32B8h
		mov	si,ax
		mov	di,bx
		shl	di,1			; Shift w/zeros fill
		add	di,offset data_b_1E00
		mov	ax,0B800h
		mov	es,ax
		mov	cx,501h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_347F	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_34A0	proc	near
		mov	data_b_3511,0
		mov	data_b_351B,0
loc_c_34AB:
		mov	bx,data_b_3511
		cmp	data_b_34A7[bx],0
		je	loc_c_34B9		; Jump if equal
loc_c_34B6:
		jmp	loc_c_35AD
loc_c_34B9:
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		mov	ax,data_b_3447[si]
		mov	dl,data_b_3477[bx]
		mov	di,0
		cmp	bx,0Ch
		jb	loc_c_34D0		; Jump if below
		mov	di,offset data_b_0001+1
loc_c_34D0:
		mov	si,data_b_3513[di]
		mov	cx,data_b_3517[di]
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	ch,0Eh
		call	sub_c_2E29
		jnc	loc_c_34B6		; Jump if carry=0
		mov	bx,data_b_3511
		cmp	bx,0Ch
		jb	loc_c_356F		; Jump if below
		cmp	data_b_0553,0
		jne	loc_c_356F		; Jump if not equal
		cmp	data_b_05F3,0
		jne	loc_c_356F		; Jump if not equal
		mov	data_b_0552,1
		mov	cx,data_b_0579
		sub	cx,8
		jnc	loc_c_3511		; Jump if carry=0
		sub	cx,cx
loc_c_3511:
		cmp	cx,117h
		jb	loc_c_351A		; Jump if below
		mov	cx,116h
loc_c_351A:
		mov	dl,data_b_057B
		cmp	dl,0B5h
		jb	loc_c_3525		; Jump if below
		mov	dl,0B4h
loc_c_3525:
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,offset data_b_3350
		mov	ax,0B800h
		mov	es,ax
		mov	cx,1205h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		call	sub_c_5797
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	word ptr data_b_3509,dx
loc_c_3543:
		push	dx
loc_c_3544:
		call	sub_c_57A6
		call	sub_c_13D8		; Check light pen
		jz	loc_c_3544		; Jump if zero
		call	sub_c_57A6
		pop	dx
		mov	bx,1
		test	dl,1
		jnz	loc_c_355A		; Jump if not zero
		mov	bl,0Fh
loc_c_355A:
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		call	sub_c_57A6
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,word ptr data_b_3509
		cmp	dx,0Dh
		jb	loc_c_3543		; Jump if below
		retn
loc_c_356F:
		inc	data_b_351B
		mov	ax,5DCh
		mov	bx,425h
		call	sub_c_593B		; Start tone AX
		cmp	data_b_351B,1
		jne	loc_c_3586		; Jump if not equal
		call	sub_c_11E3
loc_c_3586:
		mov	bx,data_b_3511
		call	sub_c_37C1
		mov	bx,data_b_3511
		mov	data_b_34A7[bx],1
		cmp	bx,0Ch
		jae	loc_c_35AD		; Jump if above or =
		dec	data_b_3410
		jnz	loc_c_35AD		; Jump if not zero
		cmp	data_b_05F3,0
		jne	loc_c_35AD		; Jump if not equal
		mov	data_b_0553,1
loc_c_35AD:
		inc	data_b_3511
		cmp	data_b_3511,18h
		jae	loc_c_35BB		; Jump if above or =
		jmp	loc_c_34AB
loc_c_35BB:
		cmp	data_b_351B,0
		je	loc_c_35C7		; Jump if equal
		call	sub_c_363D
		stc				; Set carry flag
		retn
loc_c_35C7:
		clc				; Clear carry flag
		retn
sub_c_34A0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_35C9	proc	near
		mov	data_b_3411,0
		mov	data_b_3415,0
		mov	data_b_3410,0Ch
		mov	cx,18h

locloop_c_35DD:
		mov	bx,cx
		dec	bx
		mov	data_b_348F[bx],1
		mov	data_b_34A7[bx],0
		mov	al,byte ptr data_b_34F1[bx]	; ('  ((HHhh')
		mov	data_b_3477[bx],al
		mov	data_b_342F[bx],1
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_3601		; Jump if not zero
		not	dl
loc_c_3601:
		mov	data_b_3417[bx],dl
		shl	bx,1			; Shift w/zeros fill
		call	sub_c_2DFD
		sub	dh,dh
		mov	data_b_3447[bx],dx
		loop	locloop_c_35DD		; Loop if cx > 0

		mov	bx,data_b_0008
		mov	cl,data_b_351C[bx]
		sub	ch,ch

locloop_c_361C:
		call	sub_c_2DFD
		and	dl,0Fh
		cmp	dl,0Ch
		jae	locloop_c_361C		; Jump if above or =
		mov	bl,dl
		add	bl,0Ch
		sub	bh,bh
		cmp	data_b_34A7[bx],0
		jne	locloop_c_361C		; Jump if not equal
		mov	data_b_34A7[bx],1
		loop	locloop_c_361C		; Loop if cx > 0

		retn
sub_c_35C9	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_363D	proc	near
loc_c_363D:
		mov	cx,0Ch

locloop_c_3640:
		mov	bx,cx
		add	bx,0Bh
		cmp	data_b_34A7[bx],0
		je	loc_c_3672		; Jump if equal
		sub	ax,ax
		mov	dl,1
		mov	data_b_34A7[bx],al
		cmp	data_b_0579,0A0h
		ja	loc_c_3661		; Jump if above
		mov	ax,12Eh
		mov	dl,0FFh
loc_c_3661:
		mov	data_b_3417[bx],dl
		shl	bl,1			; Shift w/zeros fill
		mov	data_b_3447[bx],ax
		dec	data_b_351B
		jnz	loc_c_363D		; Jump if not zero
		retn
loc_c_3672:
		loop	locloop_c_3640		; Loop if cx > 0

		retn
sub_c_363D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3675	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,word ptr data_b_3509
		jne	loc_c_3680		; Jump if not equal

loc_ret_c_367F:
		retn
loc_c_3680:
		mov	data_b_350B,dx
		inc	data_b_3415
		mov	bx,data_b_3415
		cmp	bx,18h
		jb	loc_c_36A4		; Jump if below
		sub	bx,bx
		mov	data_b_3415,bx
;*		xor	data_b_3411,0Ch
		db	 81h, 36h, 11h, 34h, 0Ch, 00h	;  Fixup - byte match
		add	data_b_3413,8
		jmp	short loc_c_36B7
loc_c_36A4:
		cmp	bx,0Ch
		jne	loc_c_36BD		; Jump if not equal
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_36B7		; Jump if not equal
		cmp	data_b_057B,30h		; '0'
		jb	loc_c_36BD		; Jump if below
loc_c_36B7:
		mov	ax,data_b_350B
		mov	word ptr data_b_3509,ax
loc_c_36BD:
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		cmp	data_b_34A7[bx],0
		jne	loc_ret_c_367F		; Jump if not equal
		call	sub_c_2DFD
		cmp	dl,10h
		ja	loc_c_36E9		; Jump if above
		and	dl,1
		jnz	loc_c_36D7		; Jump if not zero
		not	dl
loc_c_36D7:
		mov	data_b_3417[bx],dl
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_36E5		; Jump if not zero
		not	dl
loc_c_36E5:
		mov	data_b_342F[bx],dl
loc_c_36E9:
		mov	cx,4
		cmp	bx,0Ch
		jb	loc_c_36F3		; Jump if below
		shr	cl,1			; Shift w/zeros fill
loc_c_36F3:
		mov	ax,data_b_3447[si]
		cmp	data_b_3417[bx],1
		je	loc_c_370B		; Jump if equal
		sub	ax,cx
		jnc	loc_c_371A		; Jump if carry=0
		sub	ax,ax
		mov	data_b_3417[bx],1
		jmp	short loc_c_371A
loc_c_370B:
		add	ax,cx
		cmp	ax,12Fh
		jb	loc_c_371A		; Jump if below
		mov	ax,12Eh
		mov	data_b_3417[bx],0FFh
loc_c_371A:
		mov	data_b_3447[si],ax
		mov	al,data_b_3477[bx]
		cmp	data_b_342F[bx],1
		je	loc_c_373C		; Jump if equal
		dec	al
		cmp	al,byte ptr data_b_34F1[bx]	; ('  ((HHhh')
		jae	loc_c_3750		; Jump if above or =
		mov	al,byte ptr data_b_34F1[bx]	; ('  ((HHhh')
		mov	data_b_342F[bx],1
		jmp	short loc_c_3750
loc_c_373C:
		inc	al
		mov	dl,byte ptr data_b_34F1[bx]	; ('  ((HHhh')
		add	dl,18h
		cmp	al,dl
		jbe	loc_c_3750		; Jump if below or =
		mov	al,dl
		mov	data_b_342F[bx],0FFh
loc_c_3750:
		mov	data_b_3477[bx],al
		mov	dl,al
		mov	cx,data_b_3447[si]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_34EF,ax
		mov	bx,data_b_3415
		call	sub_c_37C1
		mov	bx,data_b_3415
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		mov	di,data_b_34EF
		mov	data_b_34BF[si],di
		mov	data_b_348F[bx],0
		mov	ax,0B800h
		mov	es,ax
		cmp	bx,0Ch
		jb	loc_c_379F		; Jump if below
		mov	si,bx
		mov	cl,3
		shl	si,cl			; Shift w/zeros fill
		add	si,data_b_3413
;*		and	si,18h
		db	 81h,0E6h, 18h, 00h	;  Fixup - byte match
		add	si,offset data_b_3330
		mov	cx,202h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
loc_c_379F:
		mov	si,data_b_3411
		test	bl,1
		jnz	loc_c_37AC		; Jump if not zero
;*		xor	si,0Ch
		db	 81h,0F6h, 0Ch, 00h	;  Fixup - byte match
loc_c_37AC:
		cmp	data_b_3417[bx],1
		je	loc_c_37B6		; Jump if equal
		add	si,18h
loc_c_37B6:
		add	si,offset data_b_3300
		mov	cx,601h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_3675	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_37C1	proc	near
		cmp	data_b_348F[bx],0
		jne	loc_ret_c_37E4		; Jump if not equal
		shl	bx,1			; Shift w/zeros fill
		mov	si,offset data_b_3404	; ('UUUUUUUUUUUU')
		mov	di,data_b_34BF[bx]
		mov	ax,0B800h
		mov	es,ax
		mov	cx,601h
		cmp	bx,18h
		jb	loc_c_37E1		; Jump if below
		mov	cx,202h
loc_c_37E1:
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_37E4:
		retn
sub_c_37C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_37E5	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_350F
		cmp	ax,8
		jb	loc_ret_c_384A		; Jump if below
		inc	data_b_350D
		mov	bx,data_b_350D
		cmp	bx,28h
		jb	loc_c_380B		; Jump if below
		sub	bx,bx
		mov	data_b_350D,bx
		mov	data_b_350F,dx
loc_c_380B:
		mov	di,bx
		shl	di,1			; Shift w/zeros fill
		cmp	data_b_057B,7
		ja	loc_c_3829		; Jump if above
		mov	ax,data_b_0579
		mov	cl,2
		shr	ax,cl			; Shift w/zeros fill
		inc	ax
		sub	ax,di
		jnc	loc_c_3824		; Jump if carry=0
		not	ax
loc_c_3824:
		cmp	ax,4
		jb	loc_ret_c_384A		; Jump if below
loc_c_3829:
		add	di,offset data_b_00A0
		mov	al,data_b_2656[bx]
		add	al,8
		mov	data_b_2656[bx],al
		and	ax,18h
		add	ax,2020h
		mov	si,ax
		mov	ax,0B800h
		mov	es,ax
		mov	cx,401h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_384A:
		retn
sub_c_37E5	endp

		db	0, 0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3850	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_35DA
		cmp	ax,6
		jae	loc_c_3860		; Jump if above or =
		retn
loc_c_3860:
		mov	data_b_35DA,dx
		add	word ptr ds:[35D8h],2
		mov	bx,word ptr ds:[35D8h]
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		mov	si,word ptr ds:[35D0h][bx]
		mov	di,offset data_b_15C8+1
		mov	ax,0B800h
		mov	es,ax
		mov	cx,0A02h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		mov	ax,0E4h
		mov	dl,8Ah
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E0Ah
		call	sub_c_2E29
		jnc	loc_ret_c_38A3		; Jump if carry=0
		mov	byte ptr data_b_0554,1

loc_ret_c_38A3:
		retn
sub_c_3850	endp

		db	12 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_38B0	proc	near
		cmp	data_b_0006,7
		jne	loc_c_38BA		; Jump if not equal
		jmp	short loc_c_38D3
		db	90h
loc_c_38BA:
		inc	data_b_0414
		mov	data_b_0418,1
		mov	dx,0AAAAh
		call	sub_c_3A96
		sub	ax,ax
		mov	data_b_369F,0
		call	sub_c_3AAC
loc_c_38D3:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	data_b_0006,7
		jne	loc_c_38EF		; Jump if not equal
		sub	dx,data_b_0412		; system timer - start of game
		mov	ax,2A30h
		sub	ax,dx
		jnc	loc_c_38EB		; Jump if carry=0
		sub	ax,ax
loc_c_38EB:
		shr	ax,1			; Shift w/zeros fill
		jmp	short loc_c_390E

loc_c_38EF:	sub	dx,data_b_0410
		mov	ax,546h
		cmp	data_b_0006,6
		jne	loc_c_38FF		; Jump if not equal
		shl	ax,1			; Shift w/zeros fill
loc_c_38FF:
		sub	ax,dx
		jnc	loc_c_3905		; Jump if carry=0
		sub	ax,ax
loc_c_3905:
		cmp	data_b_0006,6
		je	loc_c_390E		; Jump if equal
		shl	ax,1			; Shift w/zeros fill
loc_c_390E:
		mov	data_b_3697,ax
		call	sub_c_3AF4
		mov	bx,data_b_0006
		shl	bl,1			; Shift w/zeros fill
		mov	si,data_b_36CC[bx]
		mov	di,offset data_b_368D
		call	sub_c_271E
		cmp	data_b_0006,7
		jne	loc_c_396E		; Jump if not equal

		mov	bx,data_b_0008
		shl	bl,1			; Shift w/zeros fill
		mov	ax,bx
		mov	cx,data_b_36DC[bx]	; table of bonus multipliers
		cmp	data_b_2E8D,8
		jae	loc_c_3943		; Jump if above or =
		shl	cx,1			; Shift w/zeros fill
		add	ax,10h
loc_c_3943:	mov	data_b_370C,ax		; index of bonus multiplier 0..15

locloop_c_3946:
		mov	si,offset data_b_368D
		mov	di,offset data_b_1F82	; digits of current score
		push	cx
		call	sub_c_271E
		pop	cx
		loop	locloop_c_3946		; Loop if cx > 0

		call	sub_c_39FA
		mov	data_b_369E,38h		; '8'
		mov	data_b_3699,1
		mov	word ptr data_b_3722,44h ; wait time in system ticks
		call	sub_c_3A3A		; Print number at buffer data_b_368D (5 digits), column 12h, line data_b_369E

		call	sub_c_3A6C		; Print "BONUS MULTIPLIER"
		jmp	short loc_c_39A7
loc_c_396E:
		mov	si,offset data_b_368D
		mov	di,offset data_b_1F82	; digits of current score
		call	sub_c_271E
		mov	data_b_3699,2
		mov	word ptr data_b_3722,1Eh ; wait time in system ticks
		mov	dx,0FFFFh
		call	sub_c_3A96
		mov	ax,0A8Ch
		sub	ax,data_b_3697
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		and	al,0F0h
		mov	data_b_369E,al
		mov	ah,28h			; '('
		mul	ah			; ax = reg * al
		mov	data_b_369F,1
		call	sub_c_3AAC
		call	sub_c_3A3A		; Print number at buffer data_b_368D (5 digits), column 12h, line data_b_369E

		; get start system timer
loc_c_39A7:	sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_3695,dx		; system timer

loc_c_39AF:	cmp	data_b_0006,7
		jne	loc_c_39BB		; Jump if not equal
		call	sub_c_5B63
		jmp	short loc_c_39BE

loc_c_39BB:	call	sub_c_5835

loc_c_39BE:	call	sub_c_3A1C

		; wait
		sub	dx,data_b_3695		; system timer
		cmp	dx,word ptr data_b_3722 ; wait time in system ticks
		jb	loc_c_39AF		; Jump if below

		; set color palette
		sub	bx,bx
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		cmp	data_b_0006,7
		je	loc_c_39DC		; Jump if equal
		call	sub_c_5B21		; Disable sound output
		retn
loc_c_39DC:
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_000E
		mov	di,offset data_b_08E4
		mov	cx,804h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		mov	si,offset data_b_004E
		mov	di,offset data_b_0C94
		mov	cx,814h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_38B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_39FA	proc	near
		push	ds
		pop	es
		mov	ax,0B800h
		mov	ds,ax
		mov	cx,804h
		mov	di,d_B800_000E_e
		mov	si,d_B800_08E4_e
		call	sub_c_2DCA		; Load part of screen into buffer (ES:DI=dst buffer, DS:SI=source screen, CL=width, CH=height)
		mov	cx,814h
		mov	di,d_B800_004E_e
		mov	si,d_B800_0C94_e
		call	sub_c_2DCA		; Load part of screen into buffer (ES:DI=dst buffer, DS:SI=source screen, CL=width, CH=height)
		push	es
		pop	ds
		retn
sub_c_39FA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3A1C	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		push	dx
loc_c_3A21:
		call	sub_c_13D8		; Check light pen
		jz	loc_c_3A21		; Jump if zero
		pop	dx
		push	dx
		sub	bx,bx
		test	dx,4
		jnz	loc_c_3A34		; Jump if not zero
		mov	bl,data_b_3699
loc_c_3A34:
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		pop	dx
		retn
sub_c_3A1C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print number at buffer data_b_368D (5 digits), column 12h, line data_b_369E

sub_c_3A3A	proc	near

		; set cursor position, column 12h, line data_b_369E
		mov	ah,2
		mov	dh,data_b_369E
		mov	cl,3
		shr	dh,cl			; Shift w/zeros fill
		mov	dl,12h
		sub	bh,bh
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx

		mov	data_b_36A0,3		; index of first digit

		; print character (digit)
loc_c_3A50:	mov	bx,data_b_36A0		; LOW=number, HIGH=page
		mov	al,byte ptr data_b_368D[bx]  ; number
		add	al,30h			; '0' digit
		mov	ah,0Eh
		mov	bl,3			; color = white
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		inc	data_b_36A0
		cmp	data_b_36A0,7
		jb	loc_c_3A50		; Jump if below
		retn
sub_c_3A3A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print "BONUS MULTIPLIER"

sub_c_3A6C	proc	near

		; set cursor position, column 10, row 10
		mov	ah,2
		mov	dl,0Ah
		mov	dh,dl
		sub	bx,bx
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		mov	bx,data_b_370C		; index of bonus multiplier 0..15
		mov	ax,data_b_36EC[bx]	; table of bonus multipliers in text form (2 digits)
		mov	data_b_3720,ax
		sub	bx,bx

		; print character
loc_c_3A83:	mov	ah,0Eh
		mov	al,byte ptr data_b_370E[bx]	; ('BONUS MULTIPLIER: ')
		push	bx
		mov	bl,3		; color white
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		pop	bx
		inc	bx
		cmp	bx,14h
		jb	loc_c_3A83		; Jump if below
		retn
sub_c_3A6C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3A96	proc	near
		cld				; Clear direction
		mov	ax,seg_b
		mov	es,ax
		mov	di,offset data_b_000E
		mov	si,offset data_b_35E0
		mov	cx,1Eh

locloop_c_3AA5:
		lodsw				; String [si] to ax
		and	ax,dx
		stosw				; Store ax to es:[di]
		loop	locloop_c_3AA5		; Loop if cx > 0

		retn
sub_c_3A96	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3AAC	proc	near
		mov	data_b_369A,ax
		mov	ax,0B800h
		mov	es,ax
		call	sub_c_5829
		mov	ax,1B80h
loc_c_3ABA:
		mov	bx,offset data_b_361C
		mov	data_b_369C,ax
		call	sub_c_2B24
		cmp	data_b_369F,0
		je	loc_c_3AE2		; Jump if equal
		call	sub_c_5869

		; get system timer
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_3695,dx		; system timer
loc_c_3AD5:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_3695		; system timer
		cmp	dx,2
		jb	loc_c_3AD5		; Jump if below
loc_c_3AE2:
		mov	ax,data_b_369C
		sub	ax,280h
		jc	loc_c_3AF0		; Jump if carry Set
		cmp	ax,data_b_369A
		jae	loc_c_3ABA		; Jump if above or =
loc_c_3AF0:
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_3AAC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3AF4	proc	near
		mov	word ptr data_b_368B,ax
		sub	ax,ax
		mov	data_b_368D,ax
		mov	data_b_368F,ax
		mov	data_b_3691,ax
		mov	data_b_3693,ax
		mov	bx,offset data_b_3684
		mov	dx,1000h
loc_c_3B0B:
		test	dx,word ptr data_b_368B
		jz	loc_c_3B19		; Jump if zero
		mov	si,bx
		mov	di,offset data_b_368D
		call	sub_c_271E
loc_c_3B19:
		sub	bx,7
		shr	dx,1			; Shift w/zeros fill
		jnc	loc_c_3B0B		; Jump if carry=0
		retn
sub_c_3AF4	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3B30	proc	near
		mov	data_b_37AF,3
		mov	ax,1
		mov	word ptr data_b_37B0,ax
		mov	data_b_37B2,ax
		mov	data_b_37B4,ax
		retn
sub_c_3B30	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3B42	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_37B8
		jne	loc_c_3B4D		; Jump if not equal
		retn
loc_c_3B4D:
		mov	data_b_37B8,dx
		mov	data_b_37B6,4
loc_c_3B57:
		mov	bx,data_b_37B6
		cmp	word ptr data_b_37B0[bx],0
		je	loc_c_3B9B		; Jump if equal
		mov	ax,data_b_37A3[bx]
		mov	dl,18h
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E10h
		call	sub_c_2E29
		jnc	loc_c_3B9B		; Jump if carry=0
		mov	ax,0C00h
		mov	bx,8FDh
		call	sub_c_593B		; Start tone AX
		call	sub_c_11E3
		call	sub_c_3E38
		mov	bx,data_b_37B6
		call	sub_c_3BA3
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
		call	sub_c_3E14
		retn
loc_c_3B9B:
		sub	data_b_37B6,2
		jnc	loc_c_3B57		; Jump if carry=0
		retn
sub_c_3B42	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3BA3	proc	near
		mov	word ptr data_b_37B0[bx],0
		push	ds
		pop	es
		cld				; Clear direction
		mov	ax,0AAAAh
		mov	di,offset data_b_000E
		mov	si,di
		mov	cx,20h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,data_b_37A9[bx]
		mov	ax,0B800h
		mov	es,ax
		mov	cx,1002h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		dec	data_b_37AF
		jnz	loc_ret_c_3BDA		; Jump if not zero
		cmp	data_b_0552,0
		jne	loc_ret_c_3BDA		; Jump if not equal
		mov	data_b_0553,1

loc_ret_c_3BDA:
		retn
sub_c_3BA3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3BDB	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	data_b_37A0,66Ah
		mov	cx,10h

locloop_c_3BE9:
		sub	ax,ax
		mov	bx,ax
loc_c_3BED:
		mov	data_b_37A2,al
		sub	ah,ah
		add	ax,3730h
		mov	si,ax
		mov	di,data_b_37A0
		add	di,bx
		push	cx
		mov	cx,801h
		push	bx
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	bx
		pop	cx
		add	bx,2
		cmp	bx,1Eh
		jb	loc_c_3C1E		; Jump if below
		jnz	loc_c_3C15		; Jump if not zero
		mov	al,20h			; ' '
		jmp	short loc_c_3BED
loc_c_3C15:
		add	data_b_37A0,140h
		loop	locloop_c_3BE9		; Loop if cx > 0

		retn
loc_c_3C1E:
		cmp	data_b_37A2,50h		; 'P'
		je	loc_c_3C36		; Jump if equal
		test	cl,1
		jnz	loc_c_3C36		; Jump if not zero
		call	sub_c_2DFD
		cmp	dl,40h			; '@'
		jb	loc_c_3C36		; Jump if below
		mov	al,10h
		jmp	short loc_c_3BED
loc_c_3C36:
		call	sub_c_2DFD
		mov	al,dl
		sub	al,bl
		and	al,30h			; '0'
		add	al,30h			; '0'
		jmp	short loc_c_3BED
sub_c_3BDB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3C43	proc	near
		mov	ax,data_b_0579
		and	ax,0FFFCh
		cmp	ax,0A4h
		jb	loc_c_3C7F		; Jump if below
		cmp	ax,118h
		ja	loc_c_3C7F		; Jump if above
		mov	dl,data_b_057B
		sub	dl,2
		and	dl,0F8h
		test	dl,8
		jz	loc_c_3C7F		; Jump if zero
		cmp	dl,28h			; '('
		jb	loc_c_3C7F		; Jump if below
		cmp	dl,0A0h
		ja	loc_c_3C7F		; Jump if above
		mov	data_b_0579,ax
		add	dl,2
		mov	data_b_057B,dl
		add	dl,32h			; '2'
		mov	data_b_057C,dl
		stc				; Set carry flag
		retn
loc_c_3C7F:
		clc				; Clear carry flag
		retn
sub_c_3C43	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3C90	proc	near
		mov	data_b_3966,8
		mov	data_b_396A,1
		mov	data_b_3967,0
		mov	data_b_396D,2
		mov	data_b_3964,118h
		mov	data_b_396B,0
		retn
sub_c_3C90	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3CB1	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_39C8
		cmp	ax,2
		jae	loc_c_3CC1		; Jump if above or =

loc_ret_c_3CC0:
		retn
loc_c_3CC1:
		mov	data_b_39C8,dx
		call	sub_c_3E52
		jc	loc_ret_c_3CC0		; Jump if carry Set
		call	sub_c_3E6E
		jnc	loc_c_3CD2		; Jump if carry=0
		jmp	loc_c_3D90
loc_c_3CD2:
		mov	bx,data_b_0008
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_39CC[bx]
		mov	data_b_39C6,ax
		mov	ax,data_b_3964
		mov	data_b_39C3,ax
		mov	dl,data_b_3966
		mov	data_b_39C5,dl
		cmp	dl,8
		jne	loc_c_3D25		; Jump if not equal
		and	ax,0FFF8h
		mov	dx,data_b_0579
;*		and	dx,0FFF8h
		db	 81h,0E2h,0F8h,0FFh	;  Fixup - byte match
		cmp	ax,dx
		jne	loc_c_3D0D		; Jump if not equal
		mov	data_b_3967,1
		mov	data_b_396E,1
		jmp	short loc_c_3D25
loc_c_3D0D:
		mov	ax,data_b_3964
		jc	loc_c_3D1C		; Jump if carry Set
		sub	ax,data_b_39C6
		jnc	loc_c_3D20		; Jump if carry=0
		sub	ax,ax
		jmp	short loc_c_3D20
loc_c_3D1C:
		add	ax,data_b_39C6
loc_c_3D20:
		mov	data_b_3964,ax
		jmp	short loc_c_3D79
loc_c_3D25:
		mov	al,data_b_3966
		inc	data_b_396E
		mov	dl,data_b_396E
		shr	dl,1			; Shift w/zeros fill
		shr	dl,1			; Shift w/zeros fill
		and	dl,3
		add	dl,2
		cmp	data_b_3967,1
		je	loc_c_3D52		; Jump if equal
		sub	al,dl
		jc	loc_c_3D49		; Jump if carry Set
		cmp	al,9
		jae	loc_c_3D76		; Jump if above or =
loc_c_3D49:
		mov	al,8
		mov	data_b_3967,0
		jmp	short loc_c_3D76
loc_c_3D52:
		add	al,dl
		cmp	al,data_b_057B
		ja	loc_c_3D71		; Jump if above
		mov	bx,data_b_3964
		sub	bx,data_b_0579
		jnc	loc_c_3D66		; Jump if carry=0
		not	bx
loc_c_3D66:
		cmp	bx,30h
		ja	loc_c_3D71		; Jump if above
		cmp	al,0A0h
		jb	loc_c_3D76		; Jump if below
		mov	al,9Fh
loc_c_3D71:
		mov	data_b_3967,0FFh
loc_c_3D76:
		mov	data_b_3966,al
loc_c_3D79:
		call	sub_c_3E52
		jnc	loc_c_3D8B		; Jump if carry=0
		mov	ax,data_b_39C3
		mov	data_b_3964,ax
		mov	al,data_b_39C5
		mov	data_b_3966,al
		retn
loc_c_3D8B:
		call	sub_c_3E6E
		jnc	loc_c_3DEE		; Jump if carry=0
loc_c_3D90:
		cmp	data_b_0553,0
		je	loc_c_3D98		; Jump if equal
		retn
loc_c_3D98:
		mov	cx,data_b_0579
		sub	cx,0Ch
		jnc	loc_c_3DA3		; Jump if carry=0
		sub	cx,cx
loc_c_3DA3:
		cmp	cx,10Fh
		jb	loc_c_3DAC		; Jump if below
		mov	cx,10Eh
loc_c_3DAC:
		mov	dl,data_b_057B
		sub	dl,4
		jnc	loc_c_3DB7		; Jump if carry=0
		sub	dl,dl
loc_c_3DB7:
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_37C0
		mov	bp,offset data_b_000E
		mov	cx,1506h
		call	sub_c_2CCC
		call	sub_c_56F4
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_39C8,dx
loc_c_3DD8:
		call	sub_c_5704
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_39C8
		cmp	dx,9
		jb	loc_c_3DD8		; Jump if below
		mov	data_b_0552,1
		retn
loc_c_3DEE:
		mov	cx,data_b_3964
		mov	dl,data_b_3966
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_39CA,ax
		call	sub_c_3E38
		dec	data_b_396D
		jnz	loc_c_3E10		; Jump if not zero
		mov	data_b_396D,2
;*		xor	data_b_396B,54h
		db	 81h, 36h, 6Bh, 39h, 54h, 00h	;  Fixup - byte match
loc_c_3E10:
		call	sub_c_3E14
		retn
sub_c_3CB1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3E14	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_39CA
		mov	data_b_3968,di
		mov	bp,offset data_b_396F
		mov	data_b_396A,0
		mov	si,data_b_396B
		add	si,offset data_b_38BC
		mov	cx,0E03h
		call	sub_c_2CCC
		retn
sub_c_3E14	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3E38	proc	near
		mov	ax,0B800h
		mov	es,ax
		cmp	data_b_396A,0
		jne	loc_ret_c_3E51		; Jump if not equal
		mov	di,data_b_3968
		mov	si,offset data_b_396F
		mov	cx,0E03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_3E51:
		retn
sub_c_3E38	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3E52	proc	near
		mov	ax,data_b_3964
		mov	dl,data_b_3966
		mov	si,18h
		mov	bx,data_b_327D
		mov	dh,data_b_327F
		mov	di,10h
		mov	cx,1E0Eh
		call	sub_c_2E29
		retn
sub_c_3E52	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3E6E	proc	near
		mov	ax,data_b_3964
		mov	dl,data_b_3966
		mov	si,18h
		mov	di,si
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	cx,0E0Eh
		call	sub_c_2E29
		retn
sub_c_3E6E	endp

		db	7 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3E90	proc	near
		cmp	data_b_39E1,0
		je	loc_c_3EA4		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_3D16
		je	loc_ret_c_3EB9		; Jump if equal
		jmp	loc_c_3F35
loc_c_3EA4:
		cmp	data_b_0584,0
		jne	loc_ret_c_3EB9		; Jump if not equal
		cmp	data_b_069A,0		; key Alt drinking (0=pressed, 10h=released)
		jne	loc_ret_c_3EB9		; Jump if not equal
		cmp	data_b_39E0,0
		jne	loc_c_3EBA		; Jump if not equal

loc_ret_c_3EB9:
		retn
loc_c_3EBA:
		call	sub_c_4065
		jc	loc_ret_c_3EB9		; Jump if carry Set
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_3D18
		cmp	ax,0Ch
		jb	loc_ret_c_3EB9		; Jump if below
		mov	data_b_3D18,dx
		mov	data_b_055C,0
		mov	bl,data_b_39E0
		dec	bl
		sub	bh,bh
		mov	si,bx
		mov	cl,2
		shl	si,cl			; Shift w/zeros fill
		mov	ax,data_b_3C5A[si]
		mov	data_b_39E2,ax
		sub	ax,ax
		cmp	bl,3
		jae	loc_c_3EF5		; Jump if above or =
		mov	al,80h
loc_c_3EF5:
		mov	data_b_39E4,ax
		mov	bl,data_b_3CE3[bx]
		mov	si,bx
		mov	cl,2
		shl	si,cl			; Shift w/zeros fill
		mov	ax,data_b_3C5A[si]
		mov	data_b_39E6,ax
		sub	ax,ax
		cmp	bl,3
		jae	loc_c_3F12		; Jump if above or =
		mov	al,80h
loc_c_3F12:
		mov	data_b_39E8,ax
		mov	al,byte ptr data_b_1050[bx]	; ('  (H@Ph`hx')
		mov	data_b_3D05,al
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_1137[bx]
		add	ax,8
		mov	data_b_3D03,ax
		call	sub_c_11E3
		mov	data_b_39E1,0Eh
		mov	data_b_069A,10h		; key Alt drinking (0=pressed, 10h=released)
loc_c_3F35:
		cmp	data_b_1CBF,0
		jne	loc_c_3F3F		; Jump if not equal
		call	sub_c_33A0
loc_c_3F3F:
		sub	data_b_39E1,2
		sub	bh,bh
		mov	bl,data_b_39E1
		cmp	bl,8
		jb	loc_c_3F58		; Jump if below
		mov	di,data_b_39E2
		mov	ax,data_b_39E4
		jmp	short loc_c_3F70
loc_c_3F58:
		mov	di,data_b_39E6
		mov	al,data_b_3D05
		mov	data_b_057B,al
		add	al,32h			; '2'
		mov	data_b_057C,al
		mov	ax,data_b_3D03
		mov	data_b_0579,ax
		mov	ax,data_b_39E8
loc_c_3F70:
		add	ax,data_b_3D06[bx]
		mov	si,ax
		mov	ax,0B800h
		mov	es,ax
		mov	cx,1002h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		cmp	data_b_1CBF,0
		jne	loc_c_3F8B		; Jump if not equal
		call	sub_c_3339
loc_c_3F8B:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_3D16,dx
		cmp	data_b_39E1,0
		jne	loc_ret_c_3F9D		; Jump if not equal
		call	sub_c_1112

loc_ret_c_3F9D:
		retn
sub_c_3E90	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_3F9E	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	data_b_39E0,0
		mov	data_b_39E1,0
		mov	data_b_3CBF,506h
		mov	data_b_3CC1,0
loc_c_3FB9:
		mov	bx,data_b_3CC1
		mov	cl,data_b_3CAE[bx]
		sub	bx,bx
		mov	ch,bl

locloop_c_3FC5:
		mov	si,3AEAh
		call	sub_c_2DFD
		cmp	dl,30h			; '0'
		ja	loc_c_3FDB		; Jump if above
		mov	si,3AF8h
		test	dl,4
		jnz	loc_c_3FDB		; Jump if not zero
		mov	si,offset data_b_3B02	; ('UUUUUU}U')
loc_c_3FDB:
		mov	di,data_b_3CBF
		add	di,bx
		push	cx
		push	bx
		mov	cx,801h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	bx
		pop	cx
		add	bx,2
		loop	locloop_c_3FC5		; Loop if cx > 0

		add	data_b_3CBF,140h
		inc	data_b_3CC1
		cmp	data_b_3CC1,11h
		jb	loc_c_3FB9		; Jump if below
		mov	bx,offset data_b_3C22
		sub	ax,ax
		call	sub_c_2B24
		mov	bx,offset data_b_3C3E
		sub	ax,ax
		call	sub_c_2B24
		mov	bx,offset data_b_3C9A
		sub	ax,ax
		call	sub_c_2B24
		mov	bx,offset data_b_3C56
		sub	ax,ax
		call	sub_c_2B24
		mov	si,offset data_b_3CAA
		mov	di,d_B800_08EC_e
		mov	cx,102h
		mov	bp,offset data_b_000E
		call	sub_c_2D35
		sub	si,si
		mov	bx,data_b_0008
		mov	cl,3
		and	bl,cl
		shl	bl,cl			; Shift w/zeros fill
loc_c_403C:
		mov	al,data_b_3CC3[bx]
		mov	ah,al
		mov	cl,4
		shr	al,cl			; Shift w/zeros fill
		mov	data_b_3CE3[si],al
		mov	data_b_3CF3[si],0
		and	ah,0Fh
		mov	data_b_3CE4[si],ah
		mov	data_b_3CF4[si],0
		add	si,2
		inc	bx
		cmp	si,10h
		jb	loc_c_403C		; Jump if below
		retn
sub_c_3F9E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4065	proc	near
		mov	ax,data_b_327D
		mov	dl,data_b_327F
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E1Eh
		call	sub_c_2E29
		retn
sub_c_4065	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4090	proc	near
		mov	cx,4

locloop_c_4093:
		mov	bx,cx
		dec	bx
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		mov	data_b_3EAE[bx],1
		mov	data_b_3EB2[bx],0
		call	sub_c_4277
		call	sub_c_2DFD
		and	dl,0Fh
		add	dl,14h
		mov	data_b_3EB6[bx],dl
		loop	locloop_c_4093		; Loop if cx > 0

		mov	data_b_3EDA,0
		mov	data_b_3ED8,4
		retn
sub_c_4090	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_40C2	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_3EDC
		jne	loc_c_40CD		; Jump if not equal

loc_ret_c_40CC:
		retn
loc_c_40CD:
		inc	data_b_3EDA
		mov	bx,data_b_3EDA
		cmp	bx,2
		jbe	loc_c_40E5		; Jump if below or =
		cmp	bx,4
		jb	loc_c_40E9		; Jump if below
		sub	bx,bx
		mov	data_b_3EDA,bx
loc_c_40E5:
		mov	data_b_3EDC,dx
loc_c_40E9:
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		cmp	data_b_3EB2[bx],0
		jne	loc_ret_c_40CC		; Jump if not equal
		call	sub_c_42DB
		jnc	loc_c_40FC		; Jump if carry=0
		jmp	short loc_c_4124
		db	90h
loc_c_40FC:
		call	sub_c_42FC
		jc	loc_ret_c_40CC		; Jump if carry Set
		cmp	data_b_3EB6[bx],0
		jne	loc_c_4118		; Jump if not equal
		call	sub_c_4277
		call	sub_c_2DFD
		and	dl,7
		add	dl,14h
		mov	data_b_3EB6[bx],dl
loc_c_4118:
		dec	data_b_3EB6[bx]
		call	sub_c_42DB
		jc	loc_c_4124		; Jump if carry Set
		jmp	short loc_c_4181
		db	90h
loc_c_4124:
		cmp	data_b_3EAE[bx],0
		jne	loc_ret_c_4132		; Jump if not equal
		cmp	data_b_3EB6[bx],14h
		jb	loc_c_4133		; Jump if below

loc_ret_c_4132:
		retn
loc_c_4133:
		call	sub_c_11E3
		call	sub_c_4254
		mov	bx,data_b_3EDA
		mov	data_b_3EB2[bx],1
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
		mov	data_b_055C,0
		dec	data_b_3ED8
		jnz	loc_c_4155		; Jump if not zero
		mov	data_b_0553,1
loc_c_4155:
		mov	al,4
		sub	al,data_b_3ED8
		mov	cl,2
		shl	al,cl			; Shift w/zeros fill
		sub	ah,ah
		add	ax,51h
		mov	di,ax
		mov	bp,offset data_b_000E
		mov	si,offset data_b_3D20
		mov	ax,0B800h
		mov	es,ax
		mov	cx,0C02h
		call	sub_c_2D35
		mov	ax,3E8h
		mov	bx,2EEh
		call	sub_c_593B		; Start tone AX
		retn
loc_c_4181:
		call	sub_c_42B4
		mov	di,data_b_0008
		shl	di,1			; Shift w/zeros fill
		mov	bp,data_b_3EDE[di]
		call	sub_c_431C
		jnc	loc_c_41B0		; Jump if carry=0
		cmp	data_b_3EB6[bx],2
		jb	loc_c_41B0		; Jump if below
		mov	al,1
		cmp	data_b_3EB6[bx],11h
		jbe	loc_c_41AC		; Jump if below or =
		cmp	data_b_3EB6[bx],14h
		jae	loc_c_41B0		; Jump if above or =
		dec	al
loc_c_41AC:
		mov	data_b_3EB6[bx],al
loc_c_41B0:
		mov	al,data_b_3EB6[bx]
		cmp	al,1
		jbe	loc_c_41D8		; Jump if below or =
		cmp	al,12h
		jb	loc_c_41F8		; Jump if below
		mov	al,1
		cmp	data_b_3EBA[si],3
		jae	loc_c_41C7		; Jump if above or =
		mov	al,3
loc_c_41C7:
		add	data_b_3ED4[bx],al
		cmp	data_b_3EB6[bx],13h
		jb	loc_c_41F3		; Jump if below
		jz	loc_c_41EE		; Jump if zero
		sub	ax,ax
		jmp	short loc_c_4204
loc_c_41D8:
		mov	al,1
		cmp	data_b_3EBA[si],3
		jae	loc_c_41E3		; Jump if above or =
		mov	al,3
loc_c_41E3:
		add	data_b_3ED4[bx],al
		cmp	data_b_3EB6[bx],1
		jae	loc_c_41F3		; Jump if above or =
loc_c_41EE:
		mov	ax,3DB0h
		jmp	short loc_c_4204
loc_c_41F3:
		mov	ax,3D80h
		jmp	short loc_c_4204
loc_c_41F8:
		shl	al,1			; Shift w/zeros fill
		mov	di,ax
;*		and	di,2
		db	 81h,0E7h, 02h, 00h	;  Fixup - byte match
		mov	ax,data_b_3DE0[di]
loc_c_4204:
		mov	word ptr data_b_3ECA,ax
		mov	dl,data_b_3ED4[bx]
		mov	cx,data_b_3ECC[si]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	word ptr data_b_3DE4,ax
		call	sub_c_4254
		mov	bx,data_b_3EDA
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		call	sub_c_42FC
		jnc	loc_c_4226		; Jump if carry=0
		retn
loc_c_4226:
		cmp	word ptr data_b_3ECA,0
		jne	loc_c_4233		; Jump if not equal
		mov	data_b_3EAE[bx],1
		retn
loc_c_4233:
		mov	data_b_3EAE[bx],0
		mov	di,word ptr data_b_3DE4
		mov	data_b_3EA6[si],di
		mov	ax,0B800h
		mov	es,ax
		mov	bp,data_b_3EC2[si]
		mov	cx,0C02h
		mov	si,word ptr data_b_3ECA
		call	sub_c_2D35
		retn
sub_c_40C2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4254	proc	near
		mov	bx,data_b_3EDA
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		cmp	data_b_3EAE[bx],0
		jne	loc_ret_c_4276		; Jump if not equal
		mov	di,data_b_3EA6[si]
		mov	cx,0C02h
		mov	si,data_b_3EC2[si]
		mov	ax,0B800h
		mov	es,ax
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_4276:
		retn
sub_c_4254	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4277	proc	near
		mov	data_b_3ED9,20h		; ' '
loc_c_427C:
		call	sub_c_2DFD
;*		and	dx,0Fh
		db	 81h,0E2h, 0Fh, 00h	;  Fixup - byte match
		sub	di,di
loc_c_4285:
		cmp	di,si
		je	loc_c_428F		; Jump if equal
		cmp	dx,data_b_3EBA[di]
		je	loc_c_427C		; Jump if equal
loc_c_428F:
		add	di,2
		cmp	di,8
		jb	loc_c_4285		; Jump if below
		mov	data_b_3EBA[si],dx
		call	sub_c_42B4
		cmp	data_b_3ED9,0
		je	loc_ret_c_42B3		; Jump if equal
		mov	bp,32h
		call	sub_c_431C
		jnc	loc_ret_c_42B3		; Jump if carry=0
		dec	data_b_3ED9
		jmp	short loc_c_427C

loc_ret_c_42B3:
		retn
sub_c_4277	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_42B4	proc	near
		mov	di,data_b_3EBA[si]
		mov	al,byte ptr data_b_1050[di]	; ('  (H@Ph`hx')
		mov	dl,0Ah
		cmp	di,3
		jae	loc_c_42C5		; Jump if above or =
		sub	dl,dl
loc_c_42C5:
		sub	al,dl
		add	al,3
		mov	data_b_3ED4[bx],al
		shl	di,1			; Shift w/zeros fill
		mov	ax,data_b_1137[di]
		add	ax,8
		mov	data_b_3ECC[si],ax
		retn
sub_c_42B4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_42DB	proc	near
		push	si
		push	bx
		mov	ax,data_b_3ECC[si]
		mov	dl,data_b_3ED4[bx]
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E0Ch
		call	sub_c_2E29
		pop	bx
		pop	si
		retn
sub_c_42DB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_42FC	proc	near
		push	si
		push	bx
		mov	ax,data_b_3ECC[si]
		mov	dl,data_b_3ED4[bx]
		mov	si,10h
		mov	bx,data_b_327D
		mov	dh,data_b_327F
		mov	di,si
		mov	cx,1E0Ch
		call	sub_c_2E29
		pop	bx
		pop	si
		retn
sub_c_42FC	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_431C	proc	near
		mov	ax,data_b_3ECC[si]
		sub	ax,data_b_0579
		jnc	loc_c_4328		; Jump if carry=0
		not	ax
loc_c_4328:
		mov	dl,data_b_3ED4[bx]
		sub	dl,data_b_057B
		jnc	loc_c_4334		; Jump if carry=0
		not	dl
loc_c_4334:
		sub	dh,dh
		add	ax,dx
		cmp	ax,bp
		jb	loc_c_433E		; Jump if below
		clc				; Clear carry flag
		retn
loc_c_433E:
		stc				; Set carry flag
		retn
sub_c_431C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4340	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_40B5
		jne	loc_c_434B		; Jump if not equal

loc_ret_c_434A:
		retn
loc_c_434B:
		inc	data_b_40FF
		test	data_b_40FF,3
		jz	loc_c_435A		; Jump if zero
		mov	data_b_40B5,dx
loc_c_435A:
		cmp	data_b_40AA,0A4h	; required speaker tone
		jb	loc_ret_c_434A		; Jump if below
		call	sub_c_452D
		call	sub_c_4557
		jc	loc_ret_c_434A		; Jump if carry Set
		call	sub_c_2DFD
		cmp	dl,30h			; '0'
		ja	loc_c_439C		; Jump if above
		call	sub_c_44FB
		mov	si,data_b_0008
		shl	si,1			; Shift w/zeros fill
		mov	ax,data_b_40CE[si]
		cmp	data_b_40CC,ax
		ja	loc_c_439C		; Jump if above
		call	sub_c_595D
		mov	data_b_40C8,0FFh
		mov	al,data_b_40CA
		mov	data_b_40B7,al
		mov	al,data_b_40CB
		mov	data_b_40B8,al
		jmp	loc_c_442E
loc_c_439C:
		cmp	data_b_40C8,0Ah
		ja	loc_c_43B1		; Jump if above
		call	sub_c_2DFD
		cmp	dl,6
		ja	loc_c_43B4		; Jump if above
		mov	data_b_40C8,0FFh
loc_c_43B1:
		jmp	short loc_c_4402
		db	90h
loc_c_43B4:
		mov	bx,data_b_40C8
		mov	si,bx
		shl	si,1			; Shift w/zeros fill
		sub	dl,dl
		mov	ax,data_b_40B2
		and	ax,0FFCh
		cmp	ax,data_b_40DE[si]
		je	loc_c_43D0		; Jump if equal
		inc	dl
		jc	loc_c_43D0		; Jump if carry Set
		mov	dl,0FFh
loc_c_43D0:
		mov	data_b_40B7,dl
		sub	dl,dl
		mov	al,data_b_40B4
		and	al,0FEh
		cmp	al,data_b_40F4[bx]
		je	loc_c_43E7		; Jump if equal
		inc	dl
		jc	loc_c_43E7		; Jump if carry Set
		mov	dl,0FFh
loc_c_43E7:
		mov	data_b_40B8,dl
		or	dl,data_b_40B7
		jnz	loc_c_442E		; Jump if not zero
		call	sub_c_2DFD
		cmp	dl,10h
		ja	loc_c_442E		; Jump if above
		mov	data_b_40C8,0FFh
		call	sub_c_595D
loc_c_4402:
		call	sub_c_2DFD
		cmp	dl,30h			; '0'
		ja	loc_c_4423		; Jump if above
		and	dl,1
		jnz	loc_c_4411		; Jump if not zero
		mov	dl,0FFh
loc_c_4411:
		mov	data_b_40B7,dl
		call	sub_c_2DFD
		and	dl,1
		jnz	loc_c_441F		; Jump if not zero
		mov	dl,0FFh
loc_c_441F:
		mov	data_b_40B8,dl
loc_c_4423:
		call	sub_c_2DFD
		and	dx,0FFh
		mov	data_b_40C8,dx
loc_c_442E:
		mov	al,data_b_40B4
		cmp	data_b_40B8,1
		jb	loc_c_4459		; Jump if below
		jnz	loc_c_4449		; Jump if not zero
		add	al,2
		cmp	al,0A8h
		jb	loc_c_4456		; Jump if below
		mov	al,0A7h
		mov	data_b_40B8,0FFh
		jmp	short loc_c_4456
loc_c_4449:
		sub	al,2
		cmp	al,30h			; '0'
		jae	loc_c_4456		; Jump if above or =
		mov	al,30h			; '0'
		mov	data_b_40B8,1
loc_c_4456:
		mov	data_b_40B4,al
loc_c_4459:
		mov	ax,data_b_40B2
		cmp	data_b_40B7,1
		jb	loc_c_4486		; Jump if below
		jnz	loc_c_4477		; Jump if not zero
		add	ax,4
		cmp	ax,136h
		jb	loc_c_4483		; Jump if below
		mov	ax,135h
		mov	data_b_40B7,0FFh
		jmp	short loc_c_4483
loc_c_4477:
		sub	ax,4
		jnc	loc_c_4483		; Jump if carry=0
		sub	ax,ax
		mov	data_b_40B7,1
loc_c_4483:
		mov	data_b_40B2,ax
loc_c_4486:
		call	sub_c_452D
		mov	cx,data_b_40B2
		mov	dl,data_b_40B4
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_40BC,ax
		mov	ax,0B800h
		mov	es,ax
		cmp	data_b_40B9,0
		jne	loc_c_44B0		; Jump if not equal
		mov	si,offset data_b_3F2C
		mov	di,data_b_40BA
		mov	cx,501h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
loc_c_44B0:
		call	sub_c_4557
		jc	loc_ret_c_44E6		; Jump if carry Set
		mov	data_b_40B9,0
		add	data_b_40BE,2
		mov	bx,data_b_40BE
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		mov	si,data_b_40C0[bx]
		cmp	data_b_40B7,0FFh
		jne	loc_c_44D5		; Jump if not equal
		add	si,1Eh
loc_c_44D5:
		mov	di,data_b_40BC
		mov	data_b_40BA,di
		mov	bp,offset data_b_3F2C
		mov	cx,501h
		call	sub_c_2CCC

loc_ret_c_44E6:
		retn
sub_c_4340	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_44E7	proc	near
		cmp	data_b_0571,0
		jne	loc_c_44F9		; Jump if not equal
		mov	al,data_b_057B
		and	al,0F8h
		cmp	al,88h
		jne	loc_c_44F9		; Jump if not equal
		stc				; Set carry flag
		retn
loc_c_44F9:
		clc				; Clear carry flag
		retn
sub_c_44E7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_44FB	proc	near
		mov	ax,data_b_40B2
		mov	dl,1
		sub	ax,data_b_0579
		jnc	loc_c_450A		; Jump if carry=0
		not	ax
		mov	dl,0FFh
loc_c_450A:
		mov	data_b_40CA,dl
		mov	data_b_40CC,ax
		mov	al,data_b_40B4
		mov	dl,1
		sub	al,data_b_057B
		jnc	loc_c_4520		; Jump if carry=0
		not	al
		mov	dl,0FFh
loc_c_4520:
		mov	data_b_40CB,dl
		sub	ah,ah
		shl	ax,1			; Shift w/zeros fill
		add	data_b_40CC,ax
		retn
sub_c_44FB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_452D	proc	near
		mov	ax,data_b_40B2
		mov	dl,data_b_40B4
		mov	si,8
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E05h
		call	sub_c_2E29
		jnc	loc_ret_c_4556		; Jump if carry=0
		cmp	data_b_0552,0
		jne	loc_ret_c_4556		; Jump if not equal
		mov	data_b_0553,1

loc_ret_c_4556:
		retn
sub_c_452D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4557	proc	near
		mov	ax,data_b_40B2
		mov	dl,data_b_40B4
		mov	si,8
		mov	bx,data_b_327D
		mov	dh,data_b_327F
		mov	di,10h
		mov	cx,1E05h
		call	sub_c_2E29
		jnc	loc_ret_c_4579		; Jump if carry=0
		mov	data_b_40B8,0FFh

loc_ret_c_4579:
		retn
sub_c_4557	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_457A	proc	near
		mov	cx,90h
		mov	dl,86h
		mov	data_b_40A8,cx
		mov	data_b_40AA,dl		; required speaker tone
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_40AB,ax
		call	sub_c_4759
		mov	data_b_40AF,0
		mov	data_b_40B1,0
		mov	data_b_40B9,1
		mov	data_b_40B8,0
		mov	data_b_40C8,0FFh
		retn
sub_c_457A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_45AB	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_40AD
		jne	loc_c_45B6		; Jump if not equal

loc_ret_c_45B5:
		retn
loc_c_45B6:
		mov	data_b_40AD,dx
		cmp	data_b_40AA,0A4h		; required speaker tone
		jae	loc_ret_c_45B5		; Jump if above or =
		call	sub_c_4786
		jnc	loc_c_45D6		; Jump if carry=0
		call	sub_c_44E7
		jnc	loc_ret_c_45B5		; Jump if carry=0
		mov	data_b_0571,1
		mov	data_b_055B,10h
		retn
loc_c_45D6:
		call	sub_c_473E
		jnc	loc_c_4649		; Jump if carry=0
		cmp	data_b_40AF,0
		jne	loc_c_45FA		; Jump if not equal
		mov	al,data_b_056E
		cmp	al,0
		jne	loc_c_45F7		; Jump if not equal
		inc	al
		mov	bx,data_b_40A8
		cmp	bx,data_b_0579
		ja	loc_c_45F7		; Jump if above
		mov	al,0FFh
loc_c_45F7:
		mov	data_b_40B0,al
loc_c_45FA:
		mov	data_b_40AF,1
		mov	cx,20h

locloop_c_4602:
		mov	ax,data_b_0579
		mov	dl,1
		cmp	data_b_40B0,1
		jne	loc_c_4615		; Jump if not equal
		sub	ax,8
		mov	dl,0FFh
		jmp	short loc_c_4618
loc_c_4615:
		add	ax,8
loc_c_4618:
		mov	data_b_0579,ax
		mov	data_b_056E,dl
		mov	al,data_b_057B
		cmp	data_b_0571,1
		jb	loc_c_4639		; Jump if below
		jnz	loc_c_462F		; Jump if not zero
		sub	al,3
		jmp	short loc_c_4631
loc_c_462F:
		add	al,3
loc_c_4631:
		mov	data_b_057B,al
		add	al,32h			; '2'
		mov	data_b_057C,al
loc_c_4639:
		push	cx
		call	sub_c_473E
		pop	cx
		jnc	loc_c_4642		; Jump if carry=0
		loop	locloop_c_4602		; Loop if cx > 0

loc_c_4642:
		call	sub_c_11E3
		call	sub_c_1112

loc_ret_c_4648:
		retn
loc_c_4649:
		cmp	data_b_40B1,0
		jne	loc_c_46A2		; Jump if not equal
		cmp	data_b_40AF,0
		je	loc_ret_c_4648		; Jump if equal
		mov	ax,data_b_40A8
		cmp	data_b_40B0,1
		jne	loc_c_4666		; Jump if not equal
		add	ax,8
		jmp	short loc_c_4669
loc_c_4666:
		sub	ax,8
loc_c_4669:
		mov	data_b_40A8,ax
		call	sub_c_473E
		jnc	loc_c_4672		; Jump if carry=0
		retn
loc_c_4672:
		mov	ax,0C00h
		mov	bx,0B54h
		call	sub_c_593B		; Start tone AX
		mov	data_b_40AF,0
		mov	cx,data_b_40A8
		mov	dl,data_b_40AA		; required speaker tone
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_40AB,ax
		call	sub_c_4773
		call	sub_c_4759
		mov	ax,data_b_40A8
		cmp	ax,78h
		jb	loc_c_46A2		; Jump if below
		cmp	ax,0A8h
		ja	loc_c_46A2		; Jump if above
		retn
loc_c_46A2:
		mov	data_b_40B1,1
		cmp	data_b_1CBF,0
		je	loc_c_46BE		; Jump if equal
		call	sub_c_44E7
		jnc	loc_ret_c_46BD		; Jump if carry=0
		mov	data_b_0571,1
		mov	data_b_055B,10h

loc_ret_c_46BD:
		retn
loc_c_46BE:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_40AD
		je	loc_c_46A2		; Jump if equal
		mov	data_b_40AD,dx
		cmp	data_b_0000,0
		je	loc_c_46EC		; Jump if equal

		; setup speaker counter
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control

		; set frequency
		mov	al,data_b_40AA		; required speaker tone
		sub	ah,ah
		shl	ax,1			; Shift w/zeros fill
		shl	ax,1			; Shift w/zeros fill
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; enable speaker output
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc

loc_c_46EC:	mov	dl,data_b_40AA		; required speaker tone
		cmp	dl,0A4h
		jae	loc_c_470E		; Jump if above or =
		add	dl,5
		mov	data_b_40AA,dl		; required speaker tone
		mov	cx,data_b_40A8
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_40AB,ax
		call	sub_c_4773
		call	sub_c_4759
		jmp	short loc_c_46BE
loc_c_470E:
		call	sub_c_5B21		; Disable sound output
		call	sub_c_4773
		mov	bp,offset data_b_401E
		dec	data_b_40A6
		mov	di,data_b_40A6
		mov	si,offset data_b_3F36
		mov	cx,1104h
		call	sub_c_2D35
		mov	ax,data_b_40A8
		mov	data_b_40B2,ax
		mov	al,data_b_40AA		; required speaker tone
		mov	data_b_40B4,al
		call	sub_c_44FB
		mov	al,data_b_40CA
		mov	data_b_40B7,al
		retn
sub_c_45AB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_473E	proc	near
		mov	ax,data_b_40A8
		mov	dl,data_b_40AA		; required speaker tone
		mov	si,18h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,si
		mov	cx,0E10h
		call	sub_c_2E29
		retn
sub_c_473E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4759	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	bp,offset data_b_401E
		mov	si,offset data_b_3FBE
		mov	di,data_b_40AB
		mov	data_b_40A6,di
		mov	cx,1003h
		call	sub_c_2D35
		retn
sub_c_4759	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4773	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_401E
		mov	di,data_b_40A6
		mov	cx,1003h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_4773	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4786	proc	near
		cmp	data_b_327F,66h		; 'f'
		jb	loc_c_47A4		; Jump if below
		mov	ax,data_b_40A8
		sub	ax,14h
		cmp	ax,data_b_327D
		ja	loc_c_47A4		; Jump if above
		add	ax,30h
		cmp	ax,data_b_327D
		jb	loc_c_47A4		; Jump if below
		stc				; Set carry flag
		retn
loc_c_47A4:
		clc				; Clear carry flag
		retn
sub_c_4786	endp

		db	10 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_47B0	proc	near
		mov	ax,data_b_327D
		mov	dl,data_b_327F
		mov	si,10h
		mov	bx,data_b_0579
		sub	bx,8
		jnc	loc_c_47C5		; Jump if carry=0
		sub	bx,bx
loc_c_47C5:
		mov	dh,data_b_057B
		add	dh,3
		mov	di,28h
		mov	cx,0E1Eh
		call	sub_c_2E29
		retn
sub_c_47B0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_47D6	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_44D7
		mov	si,data_b_0008
		shl	si,1			; Shift w/zeros fill
		cmp	ax,data_b_44DC[si]
		ja	loc_c_47ED		; Jump if above

loc_ret_c_47EC:
		retn
loc_c_47ED:
		mov	data_b_44D7,dx
		cmp	data_b_1CB8,0
		jne	loc_ret_c_47EC		; Jump if not equal
		mov	data_b_44FC,0
		mov	cx,0Ch
loc_c_4800:
		mov	bx,cx
		dec	bx
		shl	bl,1			; Shift w/zeros fill
		cmp	data_b_4441[bx],0
		je	loc_c_487D		; Jump if equal
		mov	ax,data_b_43F9[bx]
		cmp	al,data_b_057B
		jne	loc_c_485D		; Jump if not equal
		mov	ax,data_b_43E1[bx]
		sub	ax,data_b_0579
		jnc	loc_c_4822		; Jump if carry=0
		not	ax
loc_c_4822:
		mov	si,data_b_0008
		shl	si,1			; Shift w/zeros fill
		cmp	ax,data_b_44EC[si]
		ja	loc_c_485D		; Jump if above
		cmp	data_b_4459[bx],2
		jb	loc_c_484C		; Jump if below
		mov	ax,data_b_4411[bx]
		mov	data_b_44DA,ax
		call	sub_c_488D
		call	sub_c_48A1
		call	sub_c_3339
		call	sub_c_1145
		call	sub_c_2136
		retn
loc_c_484C:
		inc	data_b_4459[bx]
		cmp	data_b_4459[bx],2
		jb	loc_c_4870		; Jump if below
		inc	data_b_44FC
		jmp	short loc_c_4870
loc_c_485D:
		cmp	data_b_4459[bx],0
		je	loc_c_487D		; Jump if equal
		call	sub_c_2DFD
		cmp	dl,38h			; '8'
		ja	loc_c_4870		; Jump if above
		dec	data_b_4459[bx]
loc_c_4870:
		push	cx
		push	bx
		call	sub_c_48D7
		pop	bx
		call	sub_c_4916
		call	sub_c_48C1
		pop	cx
loc_c_487D:
		loop	locloop_c_488A		; Loop if cx > 0

		cmp	data_b_44FC,0
		je	loc_ret_c_4889		; Jump if equal
		call	sub_c_5691

loc_ret_c_4889:
		retn

locloop_c_488A:
		jmp	loc_c_4800
sub_c_47D6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_488D	proc	near
		cmp	data_b_44BD,0
		je	loc_c_489D		; Jump if equal
		call	sub_c_4B03
		mov	data_b_44BD,0
		retn
loc_c_489D:
		call	sub_c_11E3
		retn
sub_c_488D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_48A1	proc	near
		push	ds
		pop	es
		cld				; Clear direction
		mov	di,offset data_b_000E
		mov	si,di
		mov	ax,0AAAAh
		mov	cx,41h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_44DA
		mov	cx,0D05h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_48A1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_48C1	proc	near
		cmp	data_b_44D9,0
		je	loc_ret_c_48D2		; Jump if equal
		cmp	data_b_44BD,0
		je	loc_c_48D3		; Jump if equal
		call	sub_c_4B1D

loc_ret_c_48D2:
		retn
loc_c_48D3:
		call	sub_c_1145
		retn
sub_c_48C1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_48D7	proc	near
		mov	data_b_44D9,0
		mov	ax,data_b_43E1[bx]
		mov	dx,data_b_43F9[bx]
		sub	ax,14h
		mov	si,28h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	cx,0E06h
		mov	di,18h
		call	sub_c_2E29
		jnc	loc_ret_c_4915		; Jump if carry=0
		mov	data_b_44D9,1
loc_c_4902:
		call	sub_c_13D8		; Check light pen
		jz	loc_c_4902		; Jump if zero
		cmp	data_b_44BD,0
		je	loc_c_4912		; Jump if equal
		call	sub_c_4B03
		retn
loc_c_4912:
		call	sub_c_11E3

loc_ret_c_4915:
		retn
sub_c_48D7	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4916	proc	near
		mov	ax,data_b_4411[bx]
		mov	si,data_b_4459[bx]
		shl	si,1			; Shift w/zeros fill
		add	si,offset data_b_4100
		add	ax,0A7h
		cmp	data_b_4429[bx],429Ch
		je	loc_c_4935		; Jump if equal
		sub	ax,6
		add	si,6
loc_c_4935:
		mov	di,ax
		mov	ax,0B800h
		mov	es,ax
		mov	cx,101h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_4916	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4943	proc	near
		cmp	data_b_1CB8,0
		jne	loc_ret_c_4966		; Jump if not equal
		cmp	data_b_44BE,0
		je	loc_c_495C		; Jump if equal
		mov	al,data_b_44BE
		mov	data_b_0698,al		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
loc_c_495C:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_44D3
		jne	loc_c_4967		; Jump if not equal

loc_ret_c_4966:
		retn
loc_c_4967:
		mov	data_b_44D3,dx
		cmp	data_b_0584,0
		je	loc_c_4995		; Jump if equal
		cmp	data_b_44BD,0
		je	loc_ret_c_4994		; Jump if equal
		call	sub_c_4B03
		call	sub_c_33A0
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
		call	sub_c_3339
		mov	data_b_44BD,0
		mov	data_b_43E0,1
		mov	data_b_44BE,0

loc_ret_c_4994:
		retn
loc_c_4995:
		cmp	data_b_069A,0		; key Alt drinking (0=pressed, 10h=released)
		je	loc_c_499F		; Jump if equal
		jmp	short loc_c_49F9
		db	90h
loc_c_499F:
		mov	ax,0FFFFh
		mov	data_b_44C1,ax
		mov	data_b_44BF,ax
		mov	cx,0Ch
		mov	si,data_b_0579
		mov	dl,data_b_057B
		add	dl,8

locloop_c_49B6:
		mov	bx,cx
		dec	bx
		cmp	data_b_44C4[bx],1
		jb	loc_c_49F0		; Jump if below
		cmp	dl,data_b_4499[bx]
		jne	loc_c_49F0		; Jump if not equal
		mov	ax,si
		shl	bl,1			; Shift w/zeros fill
		mov	dh,0FFh
		sub	ax,data_b_4481[bx]
		jnc	loc_c_49D6		; Jump if carry=0
		not	ax
		mov	dh,1
loc_c_49D6:
		cmp	ax,data_b_44BF
		ja	loc_c_49F0		; Jump if above
		mov	data_b_44BF,ax
		mov	ax,data_b_44A5[bx]
		mov	data_b_44D1,ax
		shr	bl,1			; Shift w/zeros fill
		mov	data_b_44C1,bx
		mov	data_b_44C3,dh
loc_c_49F0:
		loop	locloop_c_49B6		; Loop if cx > 0

		cmp	data_b_44C1,0Ch
		jb	loc_c_4A20		; Jump if below
loc_c_49F9:
		cmp	data_b_44BD,0
		je	loc_c_4A0B		; Jump if equal
		call	sub_c_4B03
		call	sub_c_1145
		mov	data_b_069A,10h		; key Alt drinking (0=pressed, 10h=released)
loc_c_4A0B:
		mov	data_b_44BD,0
		mov	data_b_43E0,1
		mov	data_b_44D0,0
		mov	data_b_44BE,0
		retn
loc_c_4A20:
		cmp	data_b_44BF,4
		jb	loc_c_4A4B		; Jump if below
		cmp	data_b_44BF,8
		ja	loc_c_4A33		; Jump if above
		mov	byte ptr data_b_0572,4
loc_c_4A33:
		mov	al,data_b_44C3
		mov	data_b_0698,al		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_056E,al
		mov	data_b_44BE,al
		mov	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		mov	data_b_0571,0
		jmp	short loc_c_49F9
loc_c_4A4B:
		mov	data_b_44BE,0
		cmp	data_b_44BD,0
		jne	loc_c_4A5D		; Jump if not equal
		call	sub_c_11E3
		call	sub_c_1124		; Load image XXX background from screen to buffer (data_b_05FA=destination, data_b_055F=source, data_b_0561=size)
loc_c_4A5D:
		mov	data_b_44BD,1
		sub	al,al
		add	data_b_44D0,30h		; '0'
		jnc	loc_c_4A6D		; Jump if carry=0
		inc	al
loc_c_4A6D:
		mov	data_b_44D5,al
		mov	cx,data_b_0579
		and	cx,0FFCh
		mov	dl,data_b_057B
		add	dl,3
		cmp	data_b_44D1,410Ch
		je	loc_c_4A95		; Jump if equal
		add	cx,8
		cmp	cx,127h
		jb	loc_c_4A9C		; Jump if below
		mov	cx,126h
		jmp	short loc_c_4A9C
loc_c_4A95:
		sub	cx,8
		jnc	loc_c_4A9C		; Jump if carry=0
		sub	cx,cx
loc_c_4A9C:
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_43DC,ax
loc_c_4AA2:
		call	sub_c_13D8		; Check light pen
		jz	loc_c_4AA2		; Jump if zero
		call	sub_c_4B03
		cmp	data_b_44D5,0
		je	loc_c_4AFF		; Jump if equal
		mov	bx,data_b_44C1
		cmp	data_b_44C4[bx],0
		je	loc_c_4AFF		; Jump if equal
		dec	data_b_44C4[bx]
		jnz	loc_c_4AE7		; Jump if not zero
		push	bx
		mov	ax,8FDh
		mov	bx,723h
		call	sub_c_593B		; Start tone AX
		pop	bx
		mov	data_b_0698,0		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_44BE,0
		mov	data_b_069A,10h		; key Alt drinking (0=pressed, 10h=released)
		dec	data_b_44D6
		jnz	loc_c_4AE7		; Jump if not zero
		mov	data_b_0553,1
loc_c_4AE7:
		push	bx
		call	sub_c_47B0
		pop	bx
		jnc	loc_c_4AFC		; Jump if carry=0
		push	bx
		call	sub_c_33A0
		pop	bx
		call	sub_c_4BC8
		call	sub_c_3339
		jmp	short loc_c_4AFF
		db	90h
loc_c_4AFC:
		call	sub_c_4BC8
loc_c_4AFF:
		call	sub_c_4B1D
		retn
sub_c_4943	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4B03	proc	near
		cmp	data_b_43E0,0
		jne	loc_ret_c_4B1C		; Jump if not equal
		mov	di,data_b_43DE
		mov	si,offset data_b_43A0
		mov	ax,0B800h
		mov	es,ax
		mov	cx,0A03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_4B1C:
		retn
sub_c_4B03	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4B1D	proc	near
		mov	data_b_43E0,0
		mov	ax,0B800h
		mov	es,ax
		mov	di,data_b_43DC
		mov	data_b_43DE,di
		mov	bp,offset data_b_43A0
		mov	si,data_b_44D1
		cmp	data_b_44D0,80h
		jb	loc_c_4B40		; Jump if below
		add	si,3Ch
loc_c_4B40:
		mov	cx,0A03h
		call	sub_c_2D35
		retn
sub_c_4B1D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4B47	proc	near
		push	ds
		pop	es
		sub	ax,ax
		mov	di,offset data_b_4441
		mov	cx,0Ch
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	ax,0B800h
		mov	es,ax
		mov	bx,data_b_0008
		mov	cl,data_b_4471[bx]
		sub	ch,ch

locloop_c_4B62:
		call	sub_c_2DFD
		mov	bl,dl
;*		and	bx,1Eh
		db	 81h,0E3h, 1Eh, 00h	;  Fixup - byte match
		cmp	bl,18h
		jae	locloop_c_4B62		; Jump if above or =
		cmp	data_b_4441[bx],0
		jne	locloop_c_4B62		; Jump if not equal
		mov	data_b_4459[bx],0
		mov	data_b_4441[bx],1
		push	cx
		mov	si,data_b_4429[bx]
		mov	di,data_b_4411[bx]
		mov	cx,0D05h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	cx
		loop	locloop_c_4B62		; Loop if cx > 0

		mov	cx,0Ch

locloop_c_4B98:
		mov	bx,cx
		dec	bx
		mov	si,data_b_0008
		mov	dl,data_b_4479[si]
		mov	data_b_44C4[bx],dl
		push	cx
		call	sub_c_4BC8
		pop	cx
		loop	locloop_c_4B98		; Loop if cx > 0

		mov	data_b_44D0,0
		mov	data_b_44BD,0
		mov	data_b_43E0,1
		mov	data_b_44D6,0Ch
		mov	data_b_44BE,0
		retn
sub_c_4B47	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4BC8	proc	near
		call	sub_c_4BE8
		mov	di,ax
		mov	al,data_b_44C4[bx]
		sub	ah,ah
		mov	cl,5
		shl	ax,cl			; Shift w/zeros fill
		add	ax,41FCh
		mov	si,ax
		mov	cx,802h
		mov	ax,0B800h
		mov	es,ax
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_4BC8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4BE8	proc	near
		push	bx
		mov	dl,data_b_4499[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_4481[bx]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		pop	bx
		retn
sub_c_4BE8	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4C00	proc	near
		retn
sub_c_4C00	endp

			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		retn
			                        ;* No entry point to code
		retn
		db	0F8h,0C3h,0F8h,0C3h,0C3h
		db	7 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4C10	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_45B8
		jne	loc_c_4C1B		; Jump if not equal
		retn
loc_c_4C1B:
		inc	word ptr data_b_45B6
		mov	bx,word ptr data_b_45B6
		cmp	bx,1
		je	loc_c_4C38		; Jump if equal
		cmp	bx,4
		je	loc_c_4C38		; Jump if equal
		cmp	bx,7
		jb	loc_c_4C3C		; Jump if below
		sub	bx,bx
		mov	word ptr data_b_45B6,bx
loc_c_4C38:
		mov	data_b_45B8,dx
loc_c_4C3C:
		call	sub_c_4FCD
		call	sub_c_502D
		jnc	loc_c_4C45		; Jump if carry=0

loc_ret_c_4C44:
		retn
loc_c_4C45:
		cmp	data_b_454F,0
		je	loc_c_4C8C		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_454F
		mov	bx,data_b_0008
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_45C7[bx]
		cmp	word ptr data_b_45B6,0
		jne	loc_c_4C67		; Jump if not equal
		shl	ax,1			; Shift w/zeros fill
loc_c_4C67:
		cmp	dx,ax
		jb	loc_ret_c_4C44		; Jump if below
		mov	data_b_454F,0
		mov	data_b_454E,1
		mov	ax,24h
		cmp	data_b_0579,0A0h
		ja	loc_c_4C84		; Jump if above
		mov	ax,108h
loc_c_4C84:
		mov	data_b_4548,ax
		mov	data_b_454A,0
loc_c_4C8C:
		call	sub_c_4DD0
		jnc	loc_c_4C99		; Jump if carry=0
		mov	bx,word ptr data_b_45B6
		call	sub_c_4FBB
		retn
loc_c_4C99:
		cmp	data_b_4553,0
		je	loc_c_4CB8		; Jump if equal
		dec	data_b_4553
		jnz	loc_c_4CB5		; Jump if not zero
		mov	dl,1
		cmp	data_b_454A,0FFh
		je	loc_c_4CB1		; Jump if equal
		mov	dl,0FFh
loc_c_4CB1:
		mov	data_b_454A,dl
loc_c_4CB5:
		jmp	short loc_c_4D14
		db	90h
loc_c_4CB8:
		mov	al,data_b_454B
		cmp	al,data_b_057B
		ja	loc_c_4D14		; Jump if above
		cmp	word ptr data_b_45B6,6
		jne	loc_c_4CCF		; Jump if not equal
		cmp	data_b_057B,28h		; '('
		jb	loc_c_4CDC		; Jump if below
loc_c_4CCF:
		call	sub_c_2DFD
		mov	bx,data_b_0008
		cmp	dl,data_b_45BF[bx]
		ja	loc_c_4D14		; Jump if above
loc_c_4CDC:
		sub	dl,dl
		mov	ax,data_b_4548
		and	ax,0FF8h
		mov	cx,data_b_0579
		and	cx,0FF8h
		cmp	ax,cx
		je	loc_c_4CF6		; Jump if equal
		mov	dl,1
		jc	loc_c_4CF6		; Jump if carry Set
		mov	dl,0FFh
loc_c_4CF6:
		mov	data_b_454A,dl
		cmp	data_b_057B,28h		; '('
		jb	loc_c_4D14		; Jump if below
		cmp	word ptr data_b_45B6,6
		jne	loc_c_4D14		; Jump if not equal
		mov	al,1
		cmp	dl,0FFh
		je	loc_c_4D11		; Jump if equal
		mov	al,0FFh
loc_c_4D11:
		mov	data_b_454A,al
loc_c_4D14:
		mov	data_b_45BC,8
		cmp	data_b_4553,0
		je	loc_c_4D27		; Jump if equal
		mov	data_b_45BC,4
loc_c_4D27:
		mov	ax,data_b_4548
		cmp	data_b_454A,1
		jae	loc_c_4D46		; Jump if above or =
		call	sub_c_2DFD
		cmp	dl,10h
		ja	loc_c_4DA1		; Jump if above
		and	dl,1
		jnz	loc_c_4D40		; Jump if not zero
		mov	dl,0FFh
loc_c_4D40:
		mov	data_b_454A,dl
		jmp	short loc_c_4DA1
loc_c_4D46:
		jnz	loc_c_4D60		; Jump if not zero
		add	ax,data_b_45BC
		cmp	ax,10Bh
		jb	loc_c_4D78		; Jump if below
		mov	ax,10Ah
		mov	data_b_454A,0FFh
		mov	data_b_4553,0
		jmp	short loc_c_4D78
loc_c_4D60:
		sub	ax,data_b_45BC
		jc	loc_c_4D6B		; Jump if carry Set
		cmp	ax,24h
		ja	loc_c_4D78		; Jump if above
loc_c_4D6B:
		mov	ax,25h
		mov	data_b_454A,1
		mov	data_b_4553,0
loc_c_4D78:
		mov	data_b_4548,ax
		add	data_b_4551,2
		cmp	data_b_4551,0Ch
		jb	loc_c_4D8D		; Jump if below
		mov	data_b_4551,0
loc_c_4D8D:
		cmp	data_b_4553,0
		jne	loc_c_4DA1		; Jump if not equal
		call	sub_c_2DFD
		cmp	dl,8
		ja	loc_c_4DA1		; Jump if above
		mov	data_b_454A,0
loc_c_4DA1:
		mov	cx,data_b_4548
		mov	dl,data_b_454B
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_45BA,ax
		call	sub_c_502D
		jnc	loc_c_4DB5		; Jump if carry=0
		retn
loc_c_4DB5:
		call	sub_c_4DD0
		jc	loc_c_4DC8		; Jump if carry Set
		call	sub_c_4F4A
		call	sub_c_4F10
		mov	data_b_45BE,0
		call	sub_c_4E75
loc_c_4DC8:
		mov	bx,word ptr data_b_45B6
		call	sub_c_4FBB
		retn
sub_c_4C10	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4DD0	proc	near
		mov	ax,data_b_0579
		mov	dl,data_b_057B
		mov	si,18h
		mov	di,si
		mov	bx,data_b_4548
		mov	dh,data_b_454B
		mov	cx,0C0Eh
		call	sub_c_2E29
		jnc	loc_ret_c_4E3D		; Jump if carry=0
		cmp	word ptr data_b_45B6,6
		jne	loc_c_4E00		; Jump if not equal
		mov	data_b_0553,1
		call	sub_c_11E3
		call	sub_c_4F4A
		stc				; Set carry flag
		retn
loc_c_4E00:
		call	sub_c_11E3
		call	sub_c_4F4A
		call	sub_c_1145
		mov	data_b_055B,4
		mov	data_b_0571,1
		mov	data_b_0576,4
		mov	data_b_0578,8
		mov	data_b_4553,4
		mov	dl,1
		mov	ax,data_b_4548
		cmp	ax,data_b_0579
		ja	loc_c_4E2F		; Jump if above
		mov	dl,0FFh
loc_c_4E2F:
		mov	data_b_454A,dl
		mov	ax,0CE4h
		mov	bx,123Bh
		call	sub_c_593B		; Start tone AX
		stc				; Set carry flag

loc_ret_c_4E3D:
		retn
sub_c_4DD0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4E3E	proc	near
		mov	data_b_45BE,1
		mov	ax,word ptr data_b_45B6
		push	ax
		mov	word ptr data_b_45B6,0
loc_c_4E4D:
		mov	bx,word ptr data_b_45B6
		call	sub_c_4FCD
		cmp	data_b_454F,0
		jne	loc_c_4E65		; Jump if not equal
		call	sub_c_4E75
		mov	bx,word ptr data_b_45B6
		call	sub_c_4FBB
loc_c_4E65:
		inc	word ptr data_b_45B6
		cmp	word ptr data_b_45B6,7
		jb	loc_c_4E4D		; Jump if below
		pop	ax
		mov	word ptr data_b_45B6,ax
		retn
sub_c_4E3E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4E75	proc	near
		mov	cx,8

locloop_c_4E78:
		mov	bx,cx
		dec	bx
		cmp	byte ptr data_b_2B72[bx],0
		je	loc_c_4EA3		; Jump if equal
		push	cx
		mov	dl,data_b_2B6A[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	ax,data_b_2B5A[bx]
		mov	si,18h
		mov	di,si
		mov	bx,data_b_4548
		mov	dh,data_b_454B
		mov	cx,0C0Fh
		call	sub_c_2E29
		pop	cx
		jc	loc_c_4EA6		; Jump if carry Set
loc_c_4EA3:
		loop	locloop_c_4E78		; Loop if cx > 0

		retn
loc_c_4EA6:
		push	cx
		cmp	data_b_45BE,0
		jne	loc_c_4EBB		; Jump if not equal
		call	sub_c_11E3
		cmp	data_b_70F2,0
		je	loc_c_4EBB		; Jump if equal
		call	sub_c_622B
loc_c_4EBB:
		call	sub_c_4F4A
		pop	cx
		mov	bx,cx
		dec	bx
		mov	byte ptr data_b_2B72[bx],0
		mov	dl,data_b_2B6A[bx]
		shl	bl,1			; Shift w/zeros fill
		mov	cx,data_b_2B5A[bx]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,offset data_b_2B7A	; ('UUUUUUUUUUUUUUUUUUUUUUUU')
		mov	ax,0B800h
		mov	es,ax
		mov	cx,0F03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		cmp	data_b_45BE,0
		jne	loc_c_4EF8		; Jump if not equal
		cmp	data_b_70F2,0
		je	loc_c_4EF5		; Jump if equal
		call	sub_c_61FA
loc_c_4EF5:
		call	sub_c_1145
loc_c_4EF8:
		sub	dx,dx
		cmp	word ptr data_b_45B6,6
		je	loc_c_4F0B		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,0
		jne	loc_c_4F0B		; Jump if not equal
		dec	dx
loc_c_4F0B:
		mov	data_b_454F,dx
		retn
sub_c_4E75	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4F10	proc	near
		mov	data_b_454E,0
		mov	si,offset data_b_4500
		cmp	data_b_454A,0
		je	loc_c_4F3E		; Jump if equal
		mov	bx,data_b_4551
		cmp	data_b_4553,0
		je	loc_c_4F30		; Jump if equal
		and	bl,2
		add	bl,0Ch
loc_c_4F30:
		cmp	data_b_454A,0FFh
		jne	loc_c_4F3A		; Jump if not equal
		add	bx,10h
loc_c_4F3A:
		mov	si,data_b_4A60[bx]
loc_c_4F3E:
		mov	di,data_b_45BA
		mov	data_b_454C,di
		call	sub_c_4FDF
		retn
sub_c_4F10	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4F4A	proc	near
		cmp	data_b_454E,0
		jne	loc_ret_c_4F58		; Jump if not equal
		mov	di,data_b_454C
		call	sub_c_5008

loc_ret_c_4F58:
		retn
sub_c_4F4A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4F59	proc	near
		mov	word ptr data_b_45B6,0
loc_c_4F5F:
		call	sub_c_2DFD

;		and	dx,7Fh
		db	81h, 0e2h, 7Fh, 0

		add	dx,60h
		mov	data_b_4548,dx
		mov	data_b_454A,0
		mov	data_b_454E,1
		mov	data_b_4551,0
		mov	data_b_4553,0
		sub	dx,dx
		cmp	word ptr data_b_45B6,0
		jne	loc_c_4F95		; Jump if not equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,0
		jne	loc_c_4F95		; Jump if not equal
		dec	dx
loc_c_4F95:
		mov	data_b_454F,dx
		mov	bx,word ptr data_b_45B6
		mov	al,data_b_2BD4[bx]
		add	al,3
		mov	data_b_454B,al
		call	sub_c_4FBB
		inc	word ptr data_b_45B6
		cmp	word ptr data_b_45B6,7
		jb	loc_c_4F5F		; Jump if below
		mov	word ptr data_b_45B6,0
		retn
sub_c_4F59	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4FBB	proc	near
		push	ds
		pop	es
		shl	bl,1			; Shift w/zeros fill
		cld				; Clear direction
		mov	di,data_b_45A8[bx]
		mov	si,offset data_b_4548
		mov	cx,0Ch
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		retn
sub_c_4FBB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4FCD	proc	near
		push	ds
		pop	es
		shl	bl,1			; Shift w/zeros fill
		cld				; Clear direction
		mov	si,data_b_45A8[bx]
		mov	di,offset data_b_4548
		mov	cx,0Ch
		rep	movsb			; Rep when cx >0 Mov [si] to es:[di]
		retn
sub_c_4FCD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_4FDF	proc	near
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		mov	dh,0Ch
loc_c_4FE7:
		mov	cx,3

locloop_c_4FEA:
		mov	bx,es:[di]
		lodsw				; String [si] to ax
		or	ax,bx
		stosw				; Store ax to es:[di]
		loop	locloop_c_4FEA		; Loop if cx > 0

		sub	di,6
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_5003		; Jump if not zero
		add	di,50h
loc_c_5003:
		dec	dh
		jnz	loc_c_4FE7		; Jump if not zero
		retn
sub_c_4FDF	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5008	proc	near
		mov	ax,0B800h
		mov	es,ax
		cld				; Clear direction
		mov	dh,0Ch
		mov	ax,5555h
loc_c_5013:
		mov	cx,3
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		sub	di,6
		xor	di,2000h
		test	di,2000h
		jnz	loc_c_5028		; Jump if not zero
		add	di,50h
loc_c_5028:
		dec	dh
		jnz	loc_c_5013		; Jump if not zero
		retn
sub_c_5008	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_502D	proc	near
		cmp	data_b_70F2,0
		jne	loc_c_5036		; Jump if not equal
		clc				; Clear carry flag
		retn
loc_c_5036:
		mov	ax,data_b_70F3
		mov	dl,data_b_70F5
		mov	si,10h
		mov	bx,data_b_4548
		mov	dh,data_b_454B
		mov	di,18h
		mov	cx,0C08h
		call	sub_c_2E29
		retn
sub_c_502D	endp

		db	14 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5060	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	ax,data_b_0579
		cmp	ax,117h
		jb	loc_c_5070		; Jump if below
		mov	ax,116h
loc_c_5070:
		sub	ax,10h
		jnc	loc_c_5077		; Jump if carry=0
		sub	ax,ax
loc_c_5077:
		and	ax,0FF0h
		mov	data_b_0579,ax
		mov	data_b_057B,14h
		sub	ax,80h
		jnc	loc_c_5089		; Jump if carry=0
		not	ax
loc_c_5089:
		mov	cl,3
		shr	ax,cl			; Shift w/zeros fill
		cmp	ax,0Dh
		jbe	loc_c_5095		; Jump if below or =
		mov	ax,0Dh
loc_c_5095:
		add	ax,2
		mov	data_b_4D6A,ax
		mov	data_b_4DD6,0Ah
loc_c_50A1:
		cmp	data_b_4DD6,0Ah
		je	loc_c_50AB		; Jump if equal
		call	sub_c_5B63
loc_c_50AB:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_4A80,dx
		mov	ax,data_b_0579
		mov	cx,ax
		and	cx,0FF0h
		cmp	cx,80h
		jne	loc_c_50C6		; Jump if not equal
		mov	ax,cx
		jmp	short loc_c_50D2
loc_c_50C6:
		jc	loc_c_50CE		; Jump if carry Set
		sub	ax,data_b_4D6A
		jmp	short loc_c_50D2
loc_c_50CE:
		add	ax,data_b_4D6A
loc_c_50D2:
		mov	data_b_0579,ax
		cmp	data_b_057B,54h		; 'T'
		jb	loc_c_50DD		; Jump if below
		retn
loc_c_50DD:
		add	data_b_057B,8
		mov	cx,data_b_0579
		add	cx,4
		mov	dl,data_b_057B
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	data_b_4DD8,di
		mov	si,offset data_b_4B8A
		mov	bp,offset data_b_000E
		mov	cx,2007h
		call	sub_c_2CCC
		mov	di,data_b_4DD8
		add	di,offset data_b_00F3
		mov	si,offset data_b_4A82
		mov	cx,0D04h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		cmp	data_b_4DD6,0Ah
		jne	loc_c_5120		; Jump if not equal
		call	sub_c_572E
		call	sub_c_5B54
loc_c_5120:
		call	sub_c_5B63
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_4A80
		cmp	dx,data_b_4DD6
		jb	loc_c_5120		; Jump if below
		cmp	data_b_4DD6,0Ah
		jne	loc_c_5141		; Jump if not equal
		call	sub_c_38B0
		sub	bx,bx
		mov	ah,0Bh
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
loc_c_5141:
		mov	data_b_4DD6,2
		jmp	loc_c_50A1
sub_c_5060	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_514A	proc	near
		mov	cx,3

locloop_c_514D:
		mov	bx,offset data_b_0003
		sub	bx,cx
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_4DA4[bx]
		mov	data_b_4D6A,ax
		mov	ax,data_b_4DAA[bx]
		mov	data_b_4D6C,ax
		mov	ax,data_b_4D98[bx]
		mov	data_b_4DCC,ax
		mov	ax,data_b_4D9E[bx]
		mov	data_b_4DCE,ax
		mov	ax,data_b_4DB0[bx]
		mov	data_b_4DD0,ax
		mov	ax,data_b_4DB6[bx]
		mov	data_b_4DD2,ax
		mov	ax,data_b_4DBC[bx]
		mov	data_b_4DD4,ax
		mov	ax,data_b_4D92[bx]
		mov	data_b_4DCA,ax
		mov	ax,data_b_4DC2[bx]
		mov	data_b_4DC8,ax
		push	cx
		call	sub_c_519B
		pop	cx
		loop	locloop_c_514D		; Loop if cx > 0

		retn
sub_c_514A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_519B	proc	near
		mov	cx,8
		mov	data_b_4D91,1

locloop_c_51A3:
		push	cx
		call	sub_c_5B63
		pop	cx
		mov	bx,cx
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		mov	ax,data_b_4DCC
		mov	data_b_4D4A[bx],ax
		mov	ax,data_b_4DCE
		mov	data_b_4D5A[bx],ax
		loop	locloop_c_51A3		; Loop if cx > 0

		mov	ax,0B800h
		mov	es,ax
		mov	data_b_4D6E,0
loc_c_51C7:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_4A80,dx
		mov	cx,8

locloop_c_51D2:
		push	cx
		call	sub_c_5B63
		pop	cx
		mov	bx,cx
		dec	bx
		shl	bx,1			; Shift w/zeros fill
		push	cx
		push	bx
		cmp	data_b_4D91,0
		je	loc_c_51EA		; Jump if equal
		cmp	cx,8
		jne	loc_c_5205		; Jump if not equal
loc_c_51EA:
		mov	cx,data_b_4D4A[bx]
		mov	dx,data_b_4D5A[bx]
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	di,ax
		mov	si,data_b_4DCA
		mov	bp,offset data_b_000E
		mov	cx,data_b_4DD4
		call	sub_c_2CCC
loc_c_5205:
		pop	bx
		pop	cx
		call	sub_c_522A
		loop	locloop_c_51D2		; Loop if cx > 0

loc_c_520C:
		call	sub_c_5B63
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_4A80
		cmp	dx,data_b_4DC8
		jb	loc_c_520C		; Jump if below
		mov	data_b_4D91,0
		cmp	data_b_4D6E,0
		je	loc_c_51C7		; Jump if equal
		retn
sub_c_519B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_522A	proc	near
		mov	ax,data_b_4D4A[bx]
		cmp	data_b_4D6F[bx],1
		jb	loc_c_525A		; Jump if below
		jnz	loc_c_524A		; Jump if not zero
		add	ax,data_b_4D6A
		cmp	ax,data_b_4DD0
		jbe	loc_c_5256		; Jump if below or =
		mov	ax,data_b_4DD0
		inc	data_b_4D6E
		jmp	short loc_c_5256
loc_c_524A:
		sub	ax,data_b_4D6A
		jnc	loc_c_5256		; Jump if carry=0
		sub	ax,ax
		inc	data_b_4D6E
loc_c_5256:
		mov	data_b_4D4A[bx],ax
loc_c_525A:
		mov	ax,data_b_4D5A[bx]
		cmp	data_b_4D7F[bx],1
		jb	loc_ret_c_528A		; Jump if below
		jnz	loc_c_527A		; Jump if not zero
		add	ax,data_b_4D6C
		cmp	ax,data_b_4DD2
		jbe	loc_c_5286		; Jump if below or =
		mov	ax,data_b_4DD2
		inc	data_b_4D6E
		jmp	short loc_c_5286
loc_c_527A:
		sub	ax,data_b_4D6C
		jnc	loc_c_5286		; Jump if carry=0
		sub	ax,ax
		inc	data_b_4D6E
loc_c_5286:
		mov	data_b_4D5A[bx],ax

loc_ret_c_528A:
		retn
sub_c_522A	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_528B	proc	near
		call	sub_c_5B54
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_529C		; Jump if equal
		mov	ah,0Bh
		mov	bx,101h
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
loc_c_529C:
		call	sub_c_5060
		call	sub_c_514A
		call	sub_c_5BBF
		cmp	data_b_1F80,9		; cat lives (1..9)
		jae	loc_c_52B0		; Jump if above or =
		inc	data_b_1F80		; cat lives (1..9)
loc_c_52B0:
		cmp	data_b_0008,7
		jae	loc_c_52BB		; Jump if above or =
		inc	data_b_0008
loc_c_52BB:
		mov	data_b_0414,0

		; read system timer
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_0412,dx		; system timer

		call	sub_c_5B21		; Disable sound output
		retn
sub_c_528B	endp

		db	0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_52D0	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5312		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_52C4
		je	loc_ret_c_5312		; Jump if equal
		mov	data_b_52C4,dx
		mov	bx,data_b_52C6
		add	data_b_52C6,2
		mov	ax,data_b_52CA[bx]
		cmp	ax,data_b_52C8		; required speaker tone
		jne	loc_c_52FC		; Jump if not equal
		call	sub_c_5B21		; Disable sound output
		retn

loc_c_52FC:	mov	data_b_52C8,ax		; required speaker tone

		; setup speaker counter
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control

		; set speaker frequency
		mov	ax,data_b_52C8		; required speaker tone
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; enable speaker output
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc

loc_ret_c_5312:	retn
sub_c_52D0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5313	proc	near
		cmp	data_b_0008,2
		jb	loc_ret_c_5367		; Jump if below
		mov	data_b_5016,0
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	word ptr ds:[52C0h],dx
		mov	data_b_52C2,dx
		mov	data_b_52C4,dx
		mov	data_b_52C6,0
		mov	data_b_52C8,0		; required speaker tone
loc_c_533C:
		call	sub_c_5368
;*		xor	data_b_5016,2
		db	 81h, 36h, 16h, 50h, 02h, 00h	;  Fixup - byte match
loc_c_5345:
		call	sub_c_52D0
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,word ptr ds:[52C0h]
		cmp	ax,5
		jb	loc_c_5345		; Jump if below
		mov	word ptr ds:[52C0h],dx
		sub	dx,data_b_52C2
		cmp	dx,28h
		jb	loc_c_533C		; Jump if below
		call	sub_c_5B21		; Disable sound output

loc_ret_c_5367:
		retn
sub_c_5313	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5368	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	bx,data_b_0008
		shl	bx,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[52AEh][bx]
		mov	data_b_5010,ax
loc_c_537A:
		mov	bx,data_b_5010
		mov	di,[bx]
		cmp	di,0
		jne	loc_c_5386		; Jump if not equal
		retn
loc_c_5386:
		mov	bx,[bx+2]
		xor	bx,data_b_5016
;*		and	bx,2
		db	 81h,0E3h, 02h, 00h	;  Fixup - byte match
		mov	si,data_b_5012[bx]
		mov	cx,2304h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		call	sub_c_52D0
		add	data_b_5010,4
		jmp	short loc_c_537A
sub_c_5368	endp

		db	11 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_53B0	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_53F5		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_5322
		je	loc_ret_c_53F5		; Jump if equal
		mov	data_b_5322,dx
		mov	bx,data_b_5320
		mov	bl,data_b_538C[bx]
		cmp	bl,66h			; 'f'
		je	loc_c_53DD		; Jump if equal
		sub	bh,bh
		inc	data_b_5320
		cmp	bx,0
		jne	loc_c_53E1		; Jump if not equal
loc_c_53DD:
		call	sub_c_5B21		; Disable sound output
		retn

		; initialize speaker counter
loc_c_53E1:	mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control

		; set tone freqency
		mov	ax,data_b_5324[bx]
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; enable speaker output
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc

loc_ret_c_53F5:
		retn
sub_c_53B0	endp

		db	10 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5400	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	bx,data_b_0008
;*		and	bx,7
		db	 81h,0E3h, 07h, 00h	;  Fixup - byte match
		shl	bx,1			; Shift w/zeros fill
		mov	ax,bx
		mov	bx,data_b_5908[bx]
		mov	cl,3
		shl	ax,cl			; Shift w/zeros fill
		mov	word ptr data_b_5918,ax
loc_c_541C:
		mov	di,[bx]
;*		cmp	di,0FFFFh
		db	 81h,0FFh,0FFh,0FFh	;  Fixup - byte match
		jz	loc_ret_c_5447		; Jump if zero
		call	sub_c_2DFD
;*		and	dx,0Eh
		db	 81h,0E2h, 0Eh, 00h	;  Fixup - byte match
		add	dx,word ptr data_b_5918
		mov	si,dx
		mov	si,data_b_5888[si]
		mov	cx,data_b_5858[si]
		mov	si,data_b_584C[si]
		push	bx
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		pop	bx
		add	bx,2
		jmp	short loc_c_541C

loc_ret_c_5447:
		retn
sub_c_5400	endp

		db	8 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5450	proc	near
		mov	data_b_5B0F,0Ch
		mov	data_b_5B0C,1
		mov	data_b_5B12,1FFh
		mov	data_b_5B0A,0Fh
		mov	data_b_5B0E,1
		retn
sub_c_5450	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_546D	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_54A5		; Jump if equal
		cmp	data_b_1CB8,0
		je	loc_c_54F8		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	data_b_5B0F,0
		jne	loc_c_54A6		; Jump if not equal
		cmp	dx,data_b_5B10
		je	loc_ret_c_54A5		; Jump if equal
		mov	data_b_5B10,dx
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,data_b_5B12
		and	ax,1FFh
		add	ax,0C8h
		call	sub_c_5889		; Set sound tone AX
		sub	data_b_5B12,4Bh

loc_ret_c_54A5:
		retn
loc_c_54A6:
		cmp	dx,data_b_5B10
		je	loc_c_54B4		; Jump if equal
		mov	data_b_5B10,dx
		dec	data_b_5B0F
loc_c_54B4:
		dec	data_b_5B0E
		jnz	loc_ret_c_54F7		; Jump if not zero
		mov	al,1
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		je	loc_c_54C5		; Jump if equal
		shl	al,1			; Shift w/zeros fill
loc_c_54C5:
		mov	data_b_5B0E,al
		call	sub_c_2DFD
		cmp	dl,4
		ja	loc_c_54D4		; Jump if above
		inc	data_b_5B0C
loc_c_54D4:
		test	data_b_5B0C,1
		jz	loc_c_54E1		; Jump if zero
		add	data_b_5B0A,7
loc_c_54E1:
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		call	sub_c_2DFD
		mov	ax,dx
		and	ax,data_b_5B0A
		and	ax,1FFh
		add	ax,190h
		call	sub_c_5889		; Set sound tone AX

loc_ret_c_54F7:
		retn
loc_c_54F8:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	data_b_5920,0
		je	loc_c_5522		; Jump if equal
		cmp	dx,data_b_5921
		je	loc_ret_c_5562		; Jump if equal
		mov	data_b_5921,dx
		dec	data_b_5920
		jz	loc_c_551E		; Jump if zero
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,data_b_5923
		call	sub_c_5889		; Set sound tone AX
		retn
loc_c_551E:
		call	sub_c_5B21		; Disable sound output
		retn
loc_c_5522:
		cmp	dx,data_b_5925
		je	loc_ret_c_5562		; Jump if equal
		mov	si,3
		mov	al,data_b_1CBF
		or	al,data_b_5B07
		jnz	loc_c_5549		; Jump if not zero
		mov	si,1
		cmp	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		jne	loc_c_5549		; Jump if not equal
		dec	si
		cmp	data_b_1673,0
		je	loc_c_5549		; Jump if equal
		mov	si,2
loc_c_5549:
		mov	di,si
		shl	di,1			; Shift w/zeros fill
		mov	al,data_b_0584
		or	al,data_b_5B07
		jnz	loc_c_5563		; Jump if not zero
		mov	ax,dx
		sub	ax,data_b_5925
		cmp	ax,data_b_59F2[di]
		jae	loc_c_5563		; Jump if above or =

loc_ret_c_5562:
		retn
loc_c_5563:
		mov	data_b_5925,dx
		cmp	data_b_1CBF,0
		jne	loc_c_5579		; Jump if not equal
		cmp	data_b_5B07,0
		je	loc_c_559E		; Jump if equal
		dec	data_b_5B07
loc_c_5579:
		mov	data_b_592E,1200h
		mov	bx,data_b_59BA
		cmp	bx,6
		jb	loc_c_558E		; Jump if below
		sub	bx,bx
		mov	data_b_59BA,bx
loc_c_558E:
		add	data_b_59BA,2
		mov	ax,data_b_5A44[bx]
		mov	data_b_592A,ax
		call	sub_c_5B28
		retn
loc_c_559E:
		cmp	si,2
		jne	loc_c_55BB		; Jump if not equal
		mov	al,data_b_1673
		sub	ah,ah
		mov	cl,4
		shl	ax,cl			; Shift w/zeros fill
		add	ax,200h
		mov	data_b_592A,ax
		mov	data_b_592E,1800h
		jmp	loc_c_568D
loc_c_55BB:
		mov	ax,data_b_5A02[di]
		mov	data_b_592E,ax
		shr	data_b_5927,1		; Shift w/zeros fill
		jnc	loc_c_5623		; Jump if carry=0
		mov	data_b_592E,1000h
		mov	data_b_5927,80h
		inc	data_b_5928
		mov	al,data_b_5928
		and	al,data_b_59FA[si]
		jnz	loc_c_5616		; Jump if not zero
		mov	dl,data_b_5A0A[si]
		add	data_b_5929,dl
		call	sub_c_2DFD
		cmp	dl,data_b_5A0C[si]
		ja	loc_c_55F8		; Jump if above
		and	dl,7
		mov	data_b_592D,dl
loc_c_55F8:
		call	sub_c_2DFD
		and	dx,0FFh
		shl	dx,1			; Shift w/zeros fill
		mov	cl,1
		test	dl,2
		jz	loc_c_560E		; Jump if zero
		mov	cl,0FFh
		add	dx,300h
loc_c_560E:
		mov	data_b_592A,dx
		mov	data_b_592C,cl
loc_c_5616:
		mov	ah,data_b_5929
		and	ah,data_b_59FC[si]
		or	al,ah
		mov	data_b_5928,al
loc_c_5623:
		cmp	data_b_592C,0FFh
		je	loc_c_5640		; Jump if equal
		add	data_b_5A54,2
		mov	bx,data_b_5A54
;*		and	bx,0Eh
		db	 81h,0E3h, 0Eh, 00h	;  Fixup - byte match
		mov	ax,data_b_5A44[bx]
		mov	data_b_592A,ax
		jmp	short loc_c_5653
loc_c_5640:
		cmp	data_b_592A,0C8h
		ja	loc_c_564E		; Jump if above
		mov	data_b_592A,500h
loc_c_564E:
		sub	data_b_592A,19h
loc_c_5653:
		cmp	data_b_0584,0
		je	loc_c_5667		; Jump if equal
		mov	data_b_592E,2000h
		mov	data_b_592C,0FFh
		jnz	loc_c_568D		; Jump if not zero
loc_c_5667:
		mov	bl,data_b_5928
		sub	bh,bh
		add	bx,data_b_59FE[di]
		mov	al,data_b_59C2[bx]
		and	al,data_b_5927
		jnz	loc_c_568D		; Jump if not zero
		cmp	data_b_592D,0
		je	loc_ret_c_5690		; Jump if equal
		dec	data_b_592D
		mov	ax,data_b_5A06[di]
		mov	data_b_592E,ax
loc_c_568D:
		call	sub_c_5B28

loc_ret_c_5690:
		retn
sub_c_546D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5691	proc	near
		call	sub_c_5B21		; Disable sound output
		mov	ah,0Bh
		mov	bx,4
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_5AE2,dx
		mov	data_b_5AE4,0
		mov	al,2
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_56B4		; Jump if not equal
		shr	al,1			; Shift w/zeros fill
loc_c_56B4:
		mov	data_b_5B06,al
loc_c_56B7:
		cmp	data_b_0000,0
		je	loc_c_56D8		; Jump if equal
		inc	data_b_5AE4
		mov	bx,data_b_5AE4
		mov	cl,data_b_5B06
		shr	bx,cl			; Shift w/zeros fill
;*		and	bx,1Fh
		db	 81h,0E3h, 1Fh, 00h	;  Fixup - byte match
		in	al,61h			; port 61h, 8255 port B, read
		xor	al,data_b_5AE6[bx]
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_c_56D8:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_5AE2
		cmp	dx,2
		jb	loc_c_56B7		; Jump if below
		mov	ah,0Bh
		sub	bx,bx
		int	10h			; Video display   ah=functn 0Bh
						;  set color from bx (CGA modes)
		mov	data_b_5B07,0Ch
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_5691	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_56F4	proc	near
		mov	ax,200h
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_5700		; Jump if not equal
		shl	ax,1			; Shift w/zeros fill
loc_c_5700:
		mov	data_b_5AD0,ax
		retn
sub_c_56F4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5704	proc	near
		inc	data_b_5AD0
		mov	bx,data_b_5AD0
		mov	dx,bx
		mov	cl,9
		shr	dx,cl			; Shift w/zeros fill
		mov	cl,dl
		and	cl,0Fh
		shr	bx,cl			; Shift w/zeros fill
;*		and	bx,0Fh
		db	 81h,0E3h, 0Fh, 00h	;  Fixup - byte match
		mov	dl,data_b_5AD2[bx]
		and	dl,data_b_0000
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		or	al,dl
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		retn
sub_c_5704	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_572E	proc	near
		mov	data_b_5ACB,1F4h	; required speaker tone
loc_c_5734:
		call	sub_c_576E
		sub	data_b_5ACB,1Eh		; required speaker tone
		cmp	data_b_5ACB,0C8h	; required speaker tone
		ja	loc_c_5734		; Jump if above
		mov	data_b_5ACB,1F4h	; required speaker tone
loc_c_574A:
		call	sub_c_576E
		sub	data_b_5ACB,14h		; required speaker tone
		cmp	data_b_5ACB,12Ch	; required speaker tone
		ja	loc_c_574A		; Jump if above
loc_c_575A:
		call	sub_c_576E
		add	data_b_5ACB,1Eh		; required speaker tone
		cmp	data_b_5ACB,320h	; required speaker tone
		jb	loc_c_575A		; Jump if below
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_572E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_576E	proc	near
		mov	cx,1000h
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	locloop_c_577A		; Jump if not equal
		shr	cx,1			; Shift w/zeros fill

locloop_c_577A:
		loop	locloop_c_577A		; Loop if cx > 0

		cmp	data_b_0000,0
		je	loc_ret_c_5796		; Jump if equal

		; setup speaker counter
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control

		; set tone frequency
		mov	ax,data_b_5ACB		; required speaker tone
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; enable speaker output
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc

loc_ret_c_5796:
		retn
sub_c_576E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5797	proc	near
		call	sub_c_5B21		; Disable sound output
		mov	data_b_5ACF,0
		mov	data_b_5ACD,8
		retn
sub_c_5797	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_57A6	proc	near
		inc	data_b_5ACF
		sub	dl,dl
		mov	al,data_b_5ACF
		and	al,3Fh			; '?'
		jnz	loc_c_57B7		; Jump if not zero
		inc	data_b_5ACD
loc_c_57B7:
		mov	bx,data_b_5ACD
		mov	cl,2
		shr	bx,cl			; Shift w/zeros fill
		and	bl,1Fh
		cmp	al,bl
		jb	loc_c_57C8		; Jump if below
		mov	dl,2
loc_c_57C8:
		and	dl,data_b_0000
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FDh
		or	al,dl
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		retn
sub_c_57A6	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_57D5	proc	near
		mov	data_b_5A85,0
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_5A83,dx
		retn
sub_c_57D5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_57E4	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5828		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_5A83
		cmp	ax,2
		jb	loc_ret_c_5828		; Jump if below
		mov	data_b_5A83,dx
		mov	bx,data_b_5A85
		add	data_b_5A85,2
		cmp	data_b_0552,0
		je	loc_c_581B		; Jump if equal
		mov	ax,data_b_5AA3[bx]
		cmp	ax,0
		jne	loc_c_581F		; Jump if not equal
		call	sub_c_5B21		; Disable sound output
		retn
loc_c_581B:
		mov	ax,data_b_5A87[bx]
loc_c_581F:
		push	ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		pop	ax
		call	sub_c_5889		; Set sound tone AX

loc_ret_c_5828:
		retn
sub_c_57E4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5829	proc	near
		mov	data_b_5A62,0
		mov	data_b_5A82,0
		retn
sub_c_5829	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5835	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5846		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_5A80
		jne	loc_c_5847		; Jump if not equal

loc_ret_c_5846:
		retn
loc_c_5847:
		mov	data_b_5A80,dx
		inc	data_b_5A82
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	bx,data_b_5A62
		test	data_b_5A82,1
		jnz	loc_c_5861		; Jump if not zero
		add	bx,2
loc_c_5861:
		mov	ax,data_b_5A64[bx]
		call	sub_c_5889		; Set sound tone AX
		retn
sub_c_5835	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5869	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5888		; Jump if equal
		push	bx
		push	ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	bx,data_b_5A62
		add	data_b_5A62,2
		mov	ax,data_b_5A64[bx]
		call	sub_c_5889		; Set sound tone AX
		pop	ax
		pop	bx

loc_ret_c_5888:
		retn
sub_c_5869	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set sound tone AX

sub_c_5889	proc	near

		; set speaker frequency
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; enable speaker output
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_c_5889	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5896	proc	near
		retn
sub_c_5896	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5897	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_58BC		; Jump if equal
		push	ax
		push	cx
		push	dx
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	bx,data_b_5A56
;*		and	bx,6
		db	 81h,0E3h, 06h, 00h	;  Fixup - byte match
		add	data_b_5A56,2
		mov	ax,data_b_5A5A[bx]
		call	sub_c_5889		; Set sound tone AX
		pop	dx
		pop	cx
		pop	ax

loc_ret_c_58BC:
		retn
sub_c_5897	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_58BD	proc	near
		mov	data_b_5927,80h
		mov	data_b_5928,0
		mov	data_b_5929,0
		mov	data_b_592A,500h
		mov	data_b_592C,0FFh
		mov	data_b_592D,0
		mov	data_b_5920,0
		mov	data_b_5B07,0
		mov	data_b_5B08,0
		mov	data_b_5B0C,1
		mov	data_b_5B0E,1
		retn
sub_c_58BD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_58F8	proc	near
		cmp	data_b_1CBF,0
		jne	loc_c_5908		; Jump if not equal
		mov	bx,390h
		mov	cx,1800h
		call	sub_c_59A3		; Play short tone BX
loc_c_5908:
		mov	data_b_127C,0
		retn
sub_c_58F8	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_590E	proc	near
		cmp	data_b_1CBF,0
		jne	loc_ret_c_591E		; Jump if not equal
		mov	bx,400h
		mov	cx,1800h
		call	sub_c_59A3		; Play short tone BX

loc_ret_c_591E:
		retn
sub_c_590E	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_591F	proc	near
		mov	bx,7D0h
		mov	cx,1800h
		call	sub_c_59A3		; Play short tone BX
		mov	bx,0A6Eh
		mov	cx,1800h
		call	sub_c_59A3		; Play short tone BX
		mov	bx,0DECh
		mov	cx,1800h
		call	sub_c_59A3		; Play short tone BX
		retn
sub_c_591F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Start tone AX

sub_c_593B	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_595C		; Jump if equal
		mov	data_b_5923,bx

		; setupt spekaer timer
		push	ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		pop	ax

		; set sound tone
		call	sub_c_5889		; Set sound tone AX

		; initialize sound length
		mov	data_b_5920,2
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_5921,dx

loc_ret_c_595C:
		retn
sub_c_593B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_595D	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_597E		; Jump if equal
		cmp	data_b_5920,0
		jne	loc_ret_c_597E		; Jump if not equal
		call	sub_c_2DFD
		mov	ax,dx
		and	ax,7Fh
		add	ax,0AAh
		mov	bx,ax
		add	ax,1Eh
		call	sub_c_593B		; Start tone AX

loc_ret_c_597E:
		retn
sub_c_595D	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_597F	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_59A2		; Jump if equal
		mov	ax,1200h
		mov	bx,1312h
		add	ax,data_b_5B08
		add	bx,data_b_5B08
		add	data_b_5B08,15Eh
		call	sub_c_593B		; Start tone AX
		mov	data_b_5B07,18h

loc_ret_c_59A2:
		retn
sub_c_597F	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play short tone BX

sub_c_59A3	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_59CA		; Jump if equal

		; setup sepaker counter
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control

		; set tone frequency
		mov	ax,bx
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; enable sound output
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc

		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	locloop_c_59C5		; Jump if not equal
		shr	cx,1			; Shift w/zeros fill

		; short delay
locloop_c_59C5:	loop	locloop_c_59C5		; Loop if cx > 0

		call	sub_c_5B21		; Disable sound output

loc_ret_c_59CA:
		retn
sub_c_59A3	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_59CB	proc	near
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FEh
		out	61h,al			; port 61h, 8255 B - spkr, etc
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_5A40,dx
		mov	data_b_5A42,0
loc_c_59DF:
		mov	ax,data_b_5A42
		mov	cl,6
		shr	ax,cl			; Shift w/zeros fill
		jnz	loc_c_59E9		; Jump if not zero
		inc	ax
loc_c_59E9:
		mov	cx,ax

locloop_c_59EB:
		push	cx
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		pop	cx
		sub	dx,data_b_5A40
		cmp	dx,2
		jb	locloop_c_59EB		; Jump if below
		cmp	dx,7
		jae	loc_c_5A18		; Jump if above or =
		loop	locloop_c_59EB		; Loop if cx > 0

		call	sub_c_2DFD
		and	dl,2
		and	dl,data_b_0000
		in	al,61h			; port 61h, 8255 port B, read
		xor	al,dl
		out	61h,al			; port 61h, 8255 B - spkr, etc
		add	data_b_5A42,7
		jmp	short loc_c_59DF
loc_c_5A18:
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_59CB	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5A1C	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5A34		; Jump if equal
		call	sub_c_13B7		; Get 8253 timer count
		mov	bx,data_b_5A16
		sub	bx,ax
		jc	loc_c_5A35		; Jump if carry Set
		cmp	bx,offset data_b_0260
		ja	loc_c_5A35		; Jump if above

loc_ret_c_5A34:
		retn
loc_c_5A35:
		mov	data_b_5A16,ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		inc	data_b_5A18
		mov	bx,data_b_5A18
;*		and	bx,1Eh
		db	 81h,0E3h, 1Eh, 00h	;  Fixup - byte match
		mov	ax,word ptr data_b_5A3C
		and	ax,3FFh
		cmp	ax,180h
		jb	loc_c_5A59		; Jump if below
		mov	cx,180h
		sub	cx,ax
		xchg	cx,ax
loc_c_5A59:
		shr	ax,1			; Shift w/zeros fill
		shr	ax,1			; Shift w/zeros fill
		add	ax,data_b_5A1A[bx]
		mov	bx,1
		cmp	data_b_0697,0FDh	; PC model, 0FDh = PCjr
		jne	loc_c_5A6D		; Jump if not equal
		shl	bl,1			; Shift w/zeros fill
loc_c_5A6D:
		add	data_b_5A3E,bx
		shl	bx,1			; Shift w/zeros fill
		shl	bx,1			; Shift w/zeros fill
		add	word ptr data_b_5A3C,bx
		mov	dx,data_b_5A3E
		mov	cl,3
		shr	dx,cl			; Shift w/zeros fill
		add	ax,dx
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_c_5A1C	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5A90	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5AA1		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_5A14
		jne	loc_c_5AA2		; Jump if not equal

loc_ret_c_5AA1:
		retn
loc_c_5AA2:
		mov	data_b_5A14,dx
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		call	sub_c_2DFD
		mov	ax,dx
		and	ax,70h
		add	ax,200h
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_c_5A90	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5AC2	proc	near
		mov	data_b_5A12,338h
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_5A10,dx
		call	sub_c_13B7		; Get 8253 timer count
		mov	word ptr data_b_5A0E,ax
loc_c_5AD6:
		call	sub_c_13B7		; Get 8253 timer count
		mov	dx,ax
		sub	ax,word ptr data_b_5A0E
		cmp	ax,9C40h
		jb	loc_c_5B10		; Jump if below
		mov	word ptr data_b_5A0E,dx
		cmp	data_b_0000,0
		je	loc_c_5B10		; Jump if equal
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		call	sub_c_2DFD
		mov	ax,dx
		and	ax,7FFh
		add	ax,data_b_5A12
		sub	data_b_5A12,2
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
loc_c_5B10:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_5A10
		cmp	dx,2
		jb	loc_c_5AD6		; Jump if below
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_5AC2	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Disable sound output

sub_c_5B21	proc	near

		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		retn
sub_c_5B21	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5B28	proc	near
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,data_b_592A
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		call	sub_c_13B7		; Get 8253 timer count
		mov	cx,ax
loc_c_5B40:
		call	sub_c_13B7		; Get 8253 timer count
		mov	dx,cx
		sub	dx,ax
		cmp	dx,data_b_592E
		jb	loc_c_5B40		; Jump if below
		in	al,61h			; port 61h, 8255 port B, read
		and	al,0FCh
		out	61h,al			; port 61h, 8255 B - spkr, etc
						;  al = 0, speaker off
		retn
sub_c_5B28	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5B54	proc	near
		mov	data_b_59BE,0
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_59C0,dx
		retn
sub_c_5B54	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5B63	proc	near
		cmp	data_b_0000,0
		je	loc_ret_c_5B79		; Jump if equal
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_59C0
		cmp	ax,2
		jae	loc_c_5B7A		; Jump if above or =

loc_ret_c_5B79:
		retn
loc_c_5B7A:
		mov	data_b_59C0,dx
		mov	bx,data_b_59BE
		and	bx,0FEh
		cmp	bx,offset data_b_0086
		jb	loc_c_5B92		; Jump if below
		sub	bx,bx
		mov	data_b_59BE,bx
loc_c_5B92:
		add	data_b_59BE,2
		mov	ax,data_b_5934[bx]
		mov	cx,data_b_59BC
		mov	data_b_59BC,ax
		cmp	ax,cx
		jne	loc_c_5BAA		; Jump if not equal
		call	sub_c_5B21		; Disable sound output
		retn
loc_c_5BAA:
		mov	cx,ax
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,cx
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc
		retn
sub_c_5B63	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5BBF	proc	near
loc_c_5BBF:
		cmp	data_b_0000,0
		je	loc_ret_c_5BD0		; Jump if equal
		call	sub_c_5B63
		cmp	data_b_59BE,7Ch
		jb	loc_c_5BBF		; Jump if below

loc_ret_c_5BD0:
		retn
sub_c_5BBF	endp

		db	15 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5BE0	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	word ptr data_b_5F66,dx
		mov	data_b_5F60,0
loc_c_5BEE:
		mov	ax,0B800h
		mov	es,ax
		mov	bx,data_b_5F60
		add	data_b_5F60,2
;*		and	bx,2
		db	 81h,0E3h, 02h, 00h	;  Fixup - byte match
		mov	si,data_b_5F62[bx]
		mov	di,offset data_b_0A74
		mov	cx,4404h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
loc_c_5C0D:
		call	sub_c_57E4
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,word ptr data_b_5F66
		cmp	ax,4
		jb	loc_c_5C0D		; Jump if below
		mov	word ptr data_b_5F66,dx
		cmp	data_b_5F60,4
		jne	loc_c_5C36		; Jump if not equal
		mov	si,offset data_b_5F68
		mov	di,offset data_b_0668
		mov	cx,1004h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
loc_c_5C36:
		mov	bx,data_b_5F60
		sub	bx,8
		jc	loc_c_5C51		; Jump if carry Set
		cmp	bx,6
		jae	loc_c_5C51		; Jump if above or =
		mov	si,offset data_b_5FE8
		mov	di,data_b_60E4[bx]
		mov	cx,1506h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
loc_c_5C51:
		cmp	data_b_5F60,10h
		jb	loc_c_5BEE		; Jump if below
		call	sub_c_5B21		; Disable sound output
		retn
sub_c_5BE0	endp

		db	0, 0, 0, 0

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check color graphics card

sub_c_5C60	proc	near

		; get initial videomode from equipment list
		int	11h			; Put equipment bits in ax
		and	al,30h			; '0'
		cmp	al,30h			; '0' 80x25 mono?
		jne	loc_ret_c_5C95		; Jump if not equal, all is OK

		; check videomemory at CGA address
		mov	ax,0B800h
		mov	ds,ax
		mov	ax,55AAh
		mov	ds:d_B800_0000_e,ax
		mov	ax,ds:d_B800_0000_e
		cmp	ax,55AAh
		jne	loc_c_5C96		; error, CGA is not installed

		; prompt "Please turn on the color display" - print on current MDA display
		mov	si,offset data_b_60F0
		call	sub_c_5C9E		; Print BIOS text seg_b:SI

		; try to set CGA videomode 4
		mov	ax,40h
		mov	ds,ax
		mov	ax,ds:d_0040_0010_e
		and	al,0CFh
		or	al,10h
		mov	ds:d_0040_0010_e,ax

		mov	ax,4
		int	10h			; Video display   ah=functn 00h
						;  set display mode in al

loc_ret_c_5C95:	retn

		; message "This program requires color graphics adapter"
loc_c_5C96:	mov	si,offset data_b_6112	; ('This program requires a ')
		call	sub_c_5C9E		; Print BIOS text seg_b:SI

		; lock
loc_c_5C9C:	jmp	short loc_c_5C9C

sub_c_5C60	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print BIOS text seg_b:SI

sub_c_5C9E	proc	near
		mov	ax,seg_b
		mov	ds,ax
		call	sub_c_5E2B		; Print BIOS text DS:SI
		retn
sub_c_5C9E	endp

		db	9 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Play intro scene

sub_c_5CB0	proc	near
		cld				; Clear direction
		mov	word ptr data_b_0004,0	; current scene 1..7, 0=intro
		call	sub_c_1830
		call	sub_c_2330
		call	sub_c_2A30
		mov	ax,0B800h
		mov	es,ax

		mov	si,offset data_b_6152
		mov	cx,1D0Bh
		mov	di,offset data_b_00BD
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		mov	si,offset data_b_63D0
		mov	cx,160Eh
		mov	di,offset data_b_069E
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		mov	si,offset data_b_6638
		mov	cx,0C03h
		mov	di,offset data_b_0A78
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		mov	si,offset data_b_6680
		mov	cx,80Eh
		mov	di,offset data_b_0CA8
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		mov	si,offset data_b_6760
		mov	cx,0B0Ch
		mov	di,offset data_b_1D6E
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		mov	si,offset data_b_6868
		mov	cx,804h
		mov	di,offset data_b_1DEC
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		mov	data_b_6A8D,0
		call	sub_c_5E3B

		mov	data_b_0579,0
		call	sub_c_070D		; Load image ??? from screen to bufer

		; print score
		mov	data_b_057B,60h		; '`'
		mov	data_b_057C,92h
		call	sub_c_26F2		; Print max score
		call	sub_c_26FC		; Print current score

		; display cat lives
		mov	data_b_1F80,9		; cat lives (1..9)
		mov	data_b_1F81,0FFh	; current display cat lives (1..9)
		call	sub_c_26B3		; Display cat lives

		call	sub_c_1E40
		mov	data_b_0698,0		; horizontal move 1=right, -1=left, 0=none
		mov	data_b_0699,0		; vertical move 1=down, -1=up, 0=none
		mov	data_b_6A8A,0
		mov	ax,data_b_0693		; counter of pressed keys
		mov	data_b_6150,ax

		; prepare timer
loc_c_5D54:	sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_6A8B,dx
		mov	data_b_5322,dx
		mov	data_b_6A93,dx
		sub	dx,30h
		mov	word ptr data_b_6A88,dx
		mov	data_b_5320,0

		; check time-out of timer
loc_c_5D71:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,data_b_6A93
		cmp	ax,24h
		jb	loc_c_5D89		; Jump if below

		mov	data_b_6A93,dx
		push	dx
		call	sub_c_5E3B
		pop	dx

loc_c_5D89:	sub	dx,data_b_6A8B
		mov	ax,data_b_56DA
		cmp	data_b_041A,0		; 1=game menu was selected, skip it
		je	loc_c_5DA0		; Jump if equal
		add	ax,48h
		cmp	dx,ax
		jae	loc_c_5D54		; Jump if above or =
		jmp	short loc_c_5DA7

loc_c_5DA0:	add	ax,6
		cmp	dx,ax
		ja	loc_ret_c_5DD3		; Jump if above

loc_c_5DA7:	call	sub_c_53B0
		call	sub_c_5DD4

		cmp	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		je	loc_c_5DCA		; Jump if equal

		; break by joystick
		mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		and	al,10h
		jz	loc_c_5DC3		; Jump if zero
		mov	data_b_6A8A,1
		jmp	short loc_c_5DCA

loc_c_5DC3:	cmp	data_b_6A8A,0
		jne	loc_ret_c_5DD3		; Jump if not equal

loc_c_5DCA:	mov	ax,data_b_6150
		cmp	ax,data_b_0693		; counter of pressed keys
		je	loc_c_5D71		; Jump if equal

loc_ret_c_5DD3:	retn

sub_c_5CB0	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5DD4	proc	near
		cmp	data_b_0579,20h
		ja	loc_c_5DE2		; Jump if above
		mov	data_b_0698,1		; horizontal move 1=right, -1=left, 0=none
		jmp	short loc_c_5E1C
loc_c_5DE2:
		cmp	data_b_0579,120h
		jb	loc_c_5DF1		; Jump if below
		mov	data_b_0698,0FFh	; horizontal move 1=right, -1=left, 0=none
		jmp	short loc_c_5E1C
loc_c_5DF1:
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	ax,dx
		sub	ax,word ptr data_b_6A88
		cmp	ax,12h
		jb	loc_c_5E1C		; Jump if below
		mov	word ptr data_b_6A88,dx
		call	sub_c_2DFD
		mov	data_b_0698,0		; horizontal move 1=right, -1=left, 0=none
		cmp	dl,0A0h
		ja	loc_c_5E1C		; Jump if above
		and	dl,1
		jnz	loc_c_5E18		; Jump if not zero
		mov	dl,0FFh
loc_c_5E18:
		mov	data_b_0698,dl		; horizontal move 1=right, -1=left, 0=none
loc_c_5E1C:
		call	sub_c_13D8		; Check light pen
		jz	loc_ret_c_5E2A		; Jump if zero
		mov	data_b_0572,4
		call	sub_c_08E5

loc_ret_c_5E2A:
		retn
sub_c_5DD4	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print BIOS text DS:SI

sub_c_5E2B	proc	near

loc_c_5E2B:	lodsb				; String [si] to al
		cmp	al,0
		je	loc_ret_c_5E3A		; Jump if equal
		push	si
		mov	bl,2			; color
		mov	ah,0Eh
		int	10h			; Video display   ah=functn 0Eh
						;  write char al, teletype mode
		pop	si
		jmp	short loc_c_5E2B

loc_ret_c_5E3A:	retn

sub_c_5E2B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_5E3B	proc	near

		mov	ax,0B800h
		mov	es,ax
		add	data_b_6A8D,2
		mov	bx,data_b_6A8D
;*		and	bx,2
		db	 81h,0E3h, 02h, 00h	;  Fixup - byte match
		mov	si,data_b_6A8F[bx]
		mov	cx,0C0Ah
		mov	di,offset data_b_1D38
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		retn
sub_c_5E3B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Set cursor row (position = 0)

sub_c_5E5B	proc	near

		; set cursor
		mov	dl,0
		mov	bh,dl
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx
		retn
sub_c_5E5B	endp

		db	12 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Display prompt "Paws Game" and wait for key

sub_c_5E70	proc	near

		; disable sound
		call	sub_c_5B21		; Disable sound output

		; get time clock
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_6DFC,dx		; timer clock LOW
		mov	data_b_6DFE,cx		; timer clock HIGH

		; load part of screen
		push	ds
		push	ds
		pop	es
		mov	ax,0B800h
		mov	ds,ax
		mov	si,d_B800_0DCA_e
		mov	di,d_B800_000E_e
		mov	cx,1020h
		call	sub_c_2DCA		; Load part of screen into buffer (ES:DI=dst buffer, DS:SI=source screen, CL=width, CH=height)
		pop	ds

		; set cursor position
		mov	dx,0B05h
		mov	bh,0
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx

		; print text "Paws Game:"
		mov	si,offset data_b_6D91	; ('           Paws Game:   ')
		cld				; Clear direction
		call	sub_c_5E2B		; Print BIOS text DS:SI

		; set cursor position
		mov	dx,0C05h
		mov	bh,0
		mov	ah,2
		int	10h			; Video display   ah=functn 02h
						;  set cursor location in dx

		; print text "Press key..."
		mov	si,6DB2h		; text "Press any key to continue..."
		cmp	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		je	loc_c_5EBA		; Jump if equal
		mov	si,offset data_b_6DD3	; text "Press the button to continue..."
loc_c_5EBA:	cld				; Clear direction
		call	sub_c_5E2B		; Print BIOS text DS:SI

		; wait for key or joystick
		call	sub_c_5F97		; Wait for key or joystick

		; restore screen content
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_000E
		mov	di,offset data_b_0DCA
		mov	cx,1020h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		; restore system counter
		mov	ah,1
		mov	cx,data_b_6DFE		; timer clock HIGH
		mov	dx,data_b_6DFC		; timer clock LOW
		int	1Ah			; Real time clock   ah=func 01h
						;  set system timer count cx,dx

		mov	ax,data_b_0693		; counter of pressed keys
		mov	data_b_6E00,ax		; old counter of pressed keys of "Paws Game"
		retn
sub_c_5E70	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Game menu

sub_c_5EE5	proc	near

		call	sub_c_5B21		; Disable sound output
loc_c_5EE8:	call	sub_c_5FCD		; Clear screen

		; print "use joystick?"
		mov	data_b_6D8F,0		; text offset "use joystick?"
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset

		; wait for a key
loc_c_5EF4:	mov	ax,data_b_0693		; counter of pressed keys
loc_c_5EF7:	cmp	ax,data_b_0693		; counter of pressed keys
		je	loc_c_5EF7		; Jump if equal

		; options Y/N
		test	data_b_06C1,80h		; key Y + Ctrl = exit game (0=pressed, 80h=released)
		jz	loc_c_5F12		; Jump if zero
		test	data_b_06C2,80h		; key N (0=pressed, 80h=released)
		jnz	loc_c_5EF4		; Jump if not zero
		mov	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		jmp	short loc_c_5F1C

		; check joystick
loc_c_5F12:	call	sub_c_5FE5		; Check joystick
		jc	loc_c_5EE8		; Jump if carry Set
		mov	data_b_069B,1		; control cat with 0=keyboard, 1=joystick

		; print text "select skill level..." + options
loc_c_5F1C:	mov	cx,5
locloop_c_5F1F:	push	cx
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		pop	cx
		loop	locloop_c_5F1F		; Loop if cx > 0

		; wait for a key
loc_c_5F26:	mov	ax,data_b_0693		; counter of pressed keys
loc_c_5F29:	cmp	ax,data_b_0693		; counter of pressed keys
		je	loc_c_5F29		; Jump if equal

		; key to select skill level
		sub	ax,ax
		test	data_b_06C3,80h		; key K (0=pressed, 80h=released)
		jz	loc_c_5F50		; Jump if zero
		inc	ax
		test	data_b_06C4,80h		; key H (0=pressed, 80h=released)
		jz	loc_c_5F50		; Jump if zero
		inc	ax
		test	data_b_06C5,80h		; key T (0=pressed, 80h=released)
		jz	loc_c_5F50		; Jump if zero
		inc	ax
		test	data_b_06C6,80h		; key A (0=pressed, 80h=released)
		jnz	loc_c_5F26		; Jump if not zero
loc_c_5F50:	mov	word ptr data_b_6DF8,ax	; skill level 0=Kitten, 1=House Car, 2=Timcat, 3=Alley Cat

		; print help "During play..."
		mov	cx,5
locloop_c_5F56:	push	cx
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		pop	cx
		loop	locloop_c_5F56		; Loop if cx > 0

		cmp	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		je	loc_c_5F7E		; Jump if equal ... skip if keyboard

		; Joystick: print help "Use the joystick..." and "Please center.."
		mov	data_b_6D8F,20h		; text offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		mov	data_b_6D8F,18h		; text offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		jmp	short loc_c_5F93

		; Keyboard: print help "Use the cursor..." and "Press any key..."
loc_c_5F7E:	mov	data_b_6D8F,1Ch		; text offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		mov	data_b_6D8F,16h		; text offset
		call	sub_c_5FB1		; Print text data_b_6D8F=table offset

		; wait for a key or joystick
loc_c_5F93:	call	sub_c_5F97		; Wait for key or joystick
		retn

sub_c_5EE5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait for key or joystick

sub_c_5F97	proc	near

		; use joystick?
		cmp	data_b_069B,0		; control cat with 0=keyboard, 1=joystick
		je	loc_c_5FA7		; use keyboard

		; input joystick - wait for press
loc_c_5F9E:	mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		and	al,10h
		jnz	loc_c_5F9E		; Jump if not zero
		retn

		; wait for key
loc_c_5FA7:	mov	ax,data_b_0693		; counter of pressed keys
loc_c_5FAA:	cmp	ax,data_b_0693		; counter of pressed keys
		je	loc_c_5FAA		; Jump if equal

		retn
sub_c_5F97	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Print text with data_b_6D8F=table offset

sub_c_5FB1	proc	near

		mov	bx,data_b_6D8F		; text offset
		mov	dx,word ptr data_b_6D63[bx] ; Text coordinates - column, row (indexed table)
		call	sub_c_5E5B		; Set cursor row (position = 0)

		mov	bx,data_b_6D8F		; text offset
		add	data_b_6D8F,2		; increase text offset
		mov	si,data_b_6D37[bx]	; Text addresses (indexed table)
		call	sub_c_5E2B		; Print BIOS text DS:SI
		retn
sub_c_5FB1	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Clear screen

sub_c_5FCD	proc	near
		cld				; Clear direction
		mov	ax,0B800h
		mov	es,ax
		sub	ax,ax
		mov	di,ax
		mov	cx,0FA0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	di,d_B800_2000_e
		mov	cx,0FA0h
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		retn
sub_c_5FCD	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Check joystick

sub_c_5FE5	proc	near

		; get equipment - check joystick port
		int	11h			; Put equipment bits in ax
		test	ax,1000h
		jz	loc_c_5FF6		; no joystick

		; check joystick
		call	sub_c_600F		; Wait joystick with timeout
		jnc	loc_ret_c_600E		; Jump if carry=0
		call	sub_c_600F		; Wait joystick with timeout
		jnc	loc_ret_c_600E		; Jump if carry=0

		; print text "Either joystick..."
loc_c_5FF6:	mov	data_b_6D8F,24h		; text offset
		mov	cx,4
locloop_c_5FFF:	call	sub_c_5FB1		; Print text data_b_6D8F=table offset
		loop	locloop_c_5FFF		; Loop if cx > 0

		; wait for a key
		mov	ax,data_b_0693		; counter of pressed keys
loc_c_6007:	cmp	ax,data_b_0693		; counter of pressed keys
		je	loc_c_6007		; Jump if equal
		stc				; Set carry flag
loc_ret_c_600E:	retn

sub_c_5FE5	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

; Wait joystick with timeout

sub_c_600F	proc	near

		mov	dx,201h
		out	dx,al			; port 201h, start game 1-shots
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		mov	data_b_6DFA,dx		; system time

		; check button
loc_c_601B:	mov	dx,201h
		in	al,dx			; port 201h, start game 1-shots
		test	al,3
		jnz	loc_c_6025		; Jump if not zero
		clc				; Clear carry flag
		retn

		; check timeout
loc_c_6025:	sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		sub	dx,data_b_6DFA
		cmp	dx,12h
		jb	loc_c_601B		; Jump if below

		stc				; Set carry flag
		retn
sub_c_600F	endp

		db	12 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

; ??? short animation with sound

sub_c_6040	proc	near

		cld				; Clear direction
		push	ds
		pop	es
		mov	di,offset data_b_000E
		mov	cx,24h
		sub	ax,ax
		rep	stosw			; Rep when cx >0 Store ax to es:[di]
		mov	data_b_6F24,25h

		mov	ax,0B800h
		mov	es,ax

		; wait for light pen
loc_c_6058:	call	sub_c_13D8		; Check light pen
		jz	loc_c_6058		; Jump if zero

		mov	si,offset data_b_000E
		mov	di,data_b_6F24
		mov	cx,0C03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)
		add	data_b_6F24,1E0h
		mov	si,offset data_b_6E10
		mov	di,data_b_6F24
		mov	cx,0C03h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		; wait 1 time tick
loc_c_607D:	sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_6F26
		je	loc_c_607D		; Jump if equal
		mov	data_b_6F26,dx

		cmp	data_b_0000,0
		je	loc_c_60A7		; Jump if equal

		; set speaker tone
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,data_b_6F24
		shr	ax,1			; Shift w/zeros fill
		out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr
		in	al,61h			; port 61h, 8255 port B, read
		or	al,3
		out	61h,al			; port 61h, 8255 B - spkr, etc

loc_c_60A7:	cmp	data_b_6F24,1A40h
		jb	loc_c_6058		; Jump if below

		mov	si,offset data_b_6E58
		mov	di,data_b_6F24
		mov	cx,1106h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

		; wait 1 time tick
loc_c_60BC:	sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_6F28
		je	loc_c_60BC		; Jump if equal
		mov	data_b_6F28,dx

		cmp	data_b_0000,0
		je	loc_c_60E6		; Jump if equal

		; set speaker tone
		mov	al,0B6h
		out	43h,al			; port 43h, 8253 timer control
		mov	ax,0C00h
		test	dl,1
		jz	loc_c_60E0		; Jump if zero
		mov	ax,0B54h
loc_c_60E0:	out	42h,al			; port 42h, 8253 timer 2 spkr
		mov	al,ah
		out	42h,al			; port 42h, 8253 timer 2 spkr

		; wait for tone
loc_c_60E6:	sub	dx,data_b_6F26
		cmp	dx,12h
		jb	loc_c_60BC		; Jump if below

		call	sub_c_5B21		; Disable sound output
		retn

sub_c_6040	endp

		db	13 dup (0)

;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_6100	proc	near
		mov	data_b_70F2,0
		retn
sub_c_6100	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_6106	proc	near
		sub	ah,ah
		int	1Ah			; Real time clock   ah=func 00h
						;  get system timer count cx,dx
		cmp	dx,data_b_70EE
		jne	loc_c_6111		; Jump if not equal
		retn
loc_c_6111:
		mov	data_b_70EE,dx
		call	sub_c_62A6
		jnc	loc_c_6129		; Jump if carry=0
		call	sub_c_11E3
		call	sub_c_622B
		call	sub_c_1145
		mov	data_b_70F2,0
		retn
loc_c_6129:
		cmp	data_b_70F2,0
		jne	loc_c_619E		; Jump if not equal
loc_c_6130:
		call	sub_c_2DFD
		mov	bx,dx
;*		and	bx,1Fh
		db	 81h,0E3h, 1Fh, 00h	;  Fixup - byte match
		cmp	bl,10h
		jb	loc_c_6166		; Jump if below
		sub	bl,10h
		cmp	bl,9
		ja	loc_c_6130		; Jump if above
		mov	dl,1
		cmp	bl,5
		jb	loc_c_614F		; Jump if below
		mov	dl,0FFh
loc_c_614F:
		mov	data_b_70F6,dl
		mov	data_b_70F5,6
		shl	bl,1			; Shift w/zeros fill
		mov	ax,word ptr ds:[70B8h][bx]
		add	ax,4
		mov	data_b_70F3,ax
		jmp	short loc_c_6188
loc_c_6166:
		mov	ax,0Ch
		mov	dl,1
		test	bl,8
		jz	loc_c_6175		; Jump if zero
		mov	ax,120h
		mov	dl,0FFh
loc_c_6175:
		mov	data_b_70F3,ax
		mov	data_b_70F6,dl
		and	bl,7
		mov	al,byte ptr ds:[70B0h][bx]
		add	al,8
		mov	data_b_70F5,al
loc_c_6188:
		mov	data_b_70F2,1
		mov	data_b_70F7,1
		mov	data_b_70F0,0
		mov	data_b_70EC,0FFFFh
loc_c_619E:
		cmp	data_b_70F0,0A0h
		jae	loc_c_61AB		; Jump if above or =
		add	data_b_70F0,4
loc_c_61AB:
		add	data_b_70F5,2
		cmp	data_b_70F5,0BFh
		ja	loc_c_61D4		; Jump if above
		cmp	data_b_70F6,1
		je	loc_c_61C7		; Jump if equal
		sub	data_b_70F3,5
		jc	loc_c_61D4		; Jump if carry Set
		jmp	short loc_c_61DD
loc_c_61C7:
		add	data_b_70F3,5
		cmp	data_b_70F3,12Ch
		jb	loc_c_61DD		; Jump if below
loc_c_61D4:
		mov	data_b_70F2,0
		call	sub_c_622B
		retn
loc_c_61DD:
		mov	cx,data_b_70F3
		mov	dl,data_b_70F5
		call	sub_c_2CB0		; Calculate address in videomemory, DL=Y coord, CX=X coord -> AX=offset in VRAM, CL=pixel index
		mov	data_b_70FA,ax
		call	sub_c_62A6
		jc	loc_c_61D4		; Jump if carry Set
		call	sub_c_6245
		call	sub_c_622B
		call	sub_c_61FA
		retn
sub_c_6106	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_61FA	proc	near
		mov	ax,0B800h
		mov	es,ax
		mov	data_b_70F7,0
		mov	ax,data_b_70F0
		and	ax,1E0h
		add	ax,6F30h
		cmp	data_b_70F6,0FFh
		je	loc_c_6217		; Jump if equal
		add	ax,0C0h
loc_c_6217:
		mov	si,ax
		mov	di,data_b_70FA
		mov	data_b_70F8,di
		mov	bp,offset data_b_70CC
		mov	cx,802h
		call	sub_c_2CCC
		retn
sub_c_61FA	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_622B	proc	near
		cmp	data_b_70F7,0
		jne	loc_ret_c_6244		; Jump if not equal
		mov	ax,0B800h
		mov	es,ax
		mov	si,offset data_b_70CC
		mov	di,data_b_70F8
		mov	cx,802h
		call	sub_c_2D9D		; Display image, restore from buffer (DS:SI=src image, ES:DI=dst screen, CL=width, CH=height)

loc_ret_c_6244:
		retn
sub_c_622B	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_6245	proc	near
		mov	al,data_b_70F5
		sub	al,8
		and	al,0F8h
		mov	cx,7

locloop_c_624F:
		mov	bx,cx
		dec	bx
		cmp	al,data_b_2BD4[bx]
		je	loc_c_625B		; Jump if equal
		loop	locloop_c_624F		; Loop if cx > 0


loc_ret_c_625A:
		retn
loc_c_625B:
		mov	ax,data_b_70F3
		mov	cl,4
		shr	ax,cl			; Shift w/zeros fill
		sub	ax,2
		jc	loc_ret_c_625A		; Jump if carry Set
		cmp	ax,10h
		jae	loc_ret_c_625A		; Jump if above or =
		mov	di,ax
		mov	dl,data_b_2BDB[bx]
		sub	dh,dh
		add	ax,dx
		cmp	ax,data_b_70EC
		je	loc_ret_c_625A		; Jump if equal
		mov	data_b_70EC,ax
		mov	si,ax
		xor	byte ptr data_b_2BE2[si],2
		mov	al,byte ptr data_b_2BE2[si]
		sub	ah,ah
		shl	di,1			; Shift w/zeros fill
		mov	cx,data_b_70FC[di]
		mov	dl,data_b_7120[bx]
		push	ax
		push	cx
		push	dx
		call	sub_c_622B
		pop	dx
		pop	cx
		pop	bx
		call	sub_c_30E3
		call	sub_c_61FA
		retn
sub_c_6245	endp


;==========================================================================
;                              SUBROUTINE
;==========================================================================

sub_c_62A6	proc	near
		cmp	data_b_70F2,0
		jne	loc_c_62AF		; Jump if not equal
		clc				; Clear carry flag
		retn
loc_c_62AF:
		mov	ax,data_b_70F3
		mov	dl,data_b_70F5
		mov	si,10h
		mov	bx,data_b_0579
		mov	dh,data_b_057B
		mov	di,18h
		mov	cx,0E08h
		call	sub_c_2E29
		jnc	loc_ret_c_62EA		; Jump if carry=0
		mov	data_b_0571,1
		mov	data_b_0576,2
		mov	data_b_0578,20h		; ' '
		mov	data_b_055B,8
		mov	ax,91Dh
		mov	bx,0CE4h
		call	sub_c_593B		; Start tone AX
		stc				; Set carry flag

loc_ret_c_62EA:
		retn
sub_c_62A6	endp


seg_c		ends



		end	start_game
