; name		XCMAIN -- initiate execution of C program
;
; description	This is the main module for a C program on the
;		MS-DOS implementation.  It initializes the segment
;		registers, sets up the stack, and calls the C main
;		function _main with a pointer to the remainder of
;		the command line.
;
;		Also defined in this module is the exit entry point
;		XCEXIT.
;

STACK_SIZE	EQU	2048	; stack size in bytes

pgroup	group	prog
dgroup	group	data,stack
	assume	cs:pgroup

; The main program must set up the initial segment registers
; and the stack pointer, and set up a far return to the MS-DOS
; exit point at ES:0.  The command line bytes from the program
; segment prefix are moved onto the stack, and a pointer to
; them supplied to the C main module _main (which calls main).
;
prog	segment	byte public 'prog'
	public	XCMAIN, XCEXIT, XCOVF
	extrn	_main:near
	assume	cs:prog, ds:dgroup, ss:dgroup

XCMAIN	proc	far

	; init stack and DS
	cli
	mov	ax,SEG data
	mov	ds,ax
	mov	ss,ax
	mov	sp,offset dgroup:sbase + STACK_SIZE
	mov	_top,sp		;save top of stack
	sti
	mov	ax,offset dgroup:sbase
	mov	_base,ax	;store ptr to bottom of stack

	; prepare far jump to INT 20h in PSP
	push	es		;push ptr to pgm segment prefix
	xor	ax,ax
	push	ax		;instr ptr for far return

	mov	bp,sp		;save in bp
	mov	ax,ds
	mov	es,ax		;es, ds, and ss are all equal
	mov	ax,sp
	push	ax		;ptr to command line
	call	_main		;call C main
	mov	sp,bp		;restore ptr to far return
	ret			;return to MS-DOS
XCMAIN	endp
;
; name		XCEXIT -- terminate execution of C program
;
; description	This function terminates execution of the current
;		program by returning to MS-DOS.  The error code
;		argument normally supplied to XCEXIT is ignored 
;		in this implementation.
;
XCEXIT	proc	far
XCOVF:
	mov	ax,_top		;load stack ptr with top address
	sub	ax,4
	mov	sp,ax
	ret			;return
XCEXIT	endp
prog	ends
;
; The data segment defines locations which contain the offsets
; of the base and top of the stack.
;
data	segment	public 'data'
	public	_top, _base
_top	dw	0	; stack top
_base	dw	0	; stack base
data	ends
;
; The stack segment defines the base (lowest address) of the
; stack.  Note that in this module it is NOT defined to be
; of the STACK combining type, thus allowing a .COM file to be
; made of the resulting .EXE file.
;
stack	segment	stack 'data'
sbase	db	STACK_SIZE dup (?)
stack	ends

colseg	segment at 0b800h

colseg	ends
;
;---------------------------------
;
dgroup	group	data
data	segment	word public 'data'
	assume 	ds:dgroup

;	include gtitle.asm

rlesize	dw	 2332
rledata	db	254,000,000,254,000,000,254,208
	db	000,254,080,170,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,254,080,170,254
	db	164,000,060,000,240,000,000,063
	db	240,060,063,240,015,254,007,000
	db	255,254,008,000,240,003,252,000
	db	255,254,005,000,255,195,254,005
	db	000,063,192,015,254,032,000,003
	db	000,000,003,000,000,003,192,060
	db	003,192,254,008,000,015,254,010
	db	000,060,000,015,254,004,000,060
	db	000,015,254,004,000,003,192,240
	db	015,254,032,000,012,003,003,000
	db	192,000,000,240,207,015,000,255
	db	000,063,255,240,000,000,063,255
	db	000,063,255,240,015,240,000,015
	db	240,000,060,000,015,254,004,000
	db	015,000,003,000,003,255,000,063
	db	252,000,255,252,015,255,015,015
	db	252,003,255,000,003,255,255,000
	db	015,252,254,017,000,012,012,000
	db	000,192,000,000,240,207,012,000
	db	015,000,003,192,003,192,015,000
	db	015,000,003,240,003,240,003,192
	db	000,240,000,060,000,015,254,005
	db	000,255,192,000,240,000,240,003
	db	192,000,015,000,000,240,051,195
	db	000,015,000,240,000,060,003,192
	db	240,003,192,254,003,000,015,000
	db	063,192,063,192,015,192,254,005
	db	000,012,003,003,000,192,000,000
	db	063,003,240,000,015,000,003,192
	db	003,192,015,000,015,000,003,192
	db	003,192,003,192,000,240,000,060
	db	000,015,254,006,000,063,000,240
	db	000,240,003,192,000,015,000,000
	db	060,051,195,000,000,060,240,000
	db	060,000,000,255,255,192,254,003
	db	000,015,000,254,005,240,254,006
	db	000,003,000,000,003,254,003,000
	db	063,003,240,000,015,000,003,192
	db	003,192,015,000,015,000,003,192
	db	003,192,003,192,000,240,000,060
	db	000,015,254,004,000,012,000,003
	db	192,240,000,240,003,192,000,015
	db	000,000,015,192,252,000,015,000
	db	240,000,060,000,000,240,254,005
	db	000,015,000,000,254,005,240,254
	db	006,000,060,000,240,254,003,000
	db	012,000,192,000,015,000,003,192
	db	003,192,003,192,255,000,003,192
	db	003,192,003,192,000,240,000,060
	db	000,015,254,004,000,015,240,015
	db	000,060,003,192,003,192,000,003
	db	195,000,003,000,048,000,015,003
	db	240,000,060,000,000,060,015,254
	db	004,000,255,240,063,000,063,192
	db	063,192,254,000,000,254,000,000
	db	254,000,000,254,146,000,254,080
	db	170,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	168,254,039,000,170,254,038,000
	db	042,168,254,039,000,170,254,038
	db	000,042,168,254,039,000,170,254
	db	038,000,042,168,254,039,000,170
	db	254,038,000,042,168,254,039,000
	db	170,254,038,000,042,168,254,039
	db	000,170,254,038,000,042,168,254
	db	039,000,170,254,038,000,042,168
	db	254,039,000,170,254,038,000,042
	db	254,080,170,254,164,000,003,255
	db	254,078,000,192,000,012,000,000
	db	003,192,060,003,192,015,254,007
	db	000,015,254,008,000,240,000,060
	db	000,015,254,004,000,015,192,063
	db	254,005,000,192,240,015,254,032
	db	000,003,000,252,003,254,003,000
	db	240,207,003,254,009,000,015,254
	db	010,000,060,000,015,254,004,000
	db	060,000,003,254,004,000,003,192
	db	000,015,254,032,000,012,012,000
	db	000,192,000,000,240,207,012,000
	db	015,000,003,240,015,000,003,192
	db	063,000,003,240,015,240,015,000
	db	000,240,000,060,000,015,254,004
	db	000,003,252,000,000,060,003,192
	db	003,192,000,015,000,000,240,015
	db	000,192,015,000,192,000,063,003
	db	192,060,015,254,017,000,012,012
	db	000,000,192,000,000,063,003,252
	db	000,015,000,003,192,003,192,015
	db	000,015,000,003,192,003,192,003
	db	192,000,240,000,060,000,015,254
	db	005,000,003,252,000,240,000,240
	db	003,192,000,015,000,000,060,051
	db	195,000,000,003,240,000,060,000
	db	000,240,003,192,254,003,000,063
	db	000,254,004,240,060,254,006,000
	db	003,000,252,003,254,003,000,063
	db	003,240,000,015,000,003,192,003
	db	192,015,000,015,000,003,192,003
	db	192,003,192,000,240,000,060,000
	db	015,254,004,000,012,000,003,192
	db	240,000,240,003,192,000,015,000
	db	000,015,192,252,000,003,192,240
	db	000,060,000,000,240,254,005,000
	db	015,000,063,240,063,192,255,192
	db	254,006,000,192,000,012,254,003
	db	000,012,000,192,000,015,000,003
	db	192,003,192,015,000,015,000,003
	db	192,003,192,003,192,000,240,000
	db	060,000,015,254,004,000,015,000
	db	003,192,240,000,240,003,192,000
	db	015,003,000,015,192,252,000,015
	db	000,240,000,060,000,000,240,000
	db	192,254,003,000,015,000,003,192
	db	254,004,240,254,006,000,003,255
	db	254,004,000,012,000,192,000,255
	db	240,063,252,063,252,000,255,015
	db	252,063,252,063,252,063,252,015
	db	255,003,255,192,255,240,254,003
	db	000,012,015,240,000,015,252,000
	db	063,252,000,000,252,000,003,000
	db	048,000,003,252,063,003,255,192
	db	000,015,240,000,000,000,000,000

data	ends
;
;
;
;
;---------------------------------
;
pgroup	group	prog
prog	segment	byte public 'prog'
	public gentitle
	assume cs:pgroup,ds:dgroup,es:colseg


;
; run length decode to screen
;
; rlesize contains number of bytes of encoded data in array
;
; rledata is the address of array[0]
;
;
gentitle proc	near
	push	es
	push	bp
	mov	ax,0b800h	;point to screen start
	mov	es,ax
	mov	di,0		;offset into screen
	mov	si,offset dgroup:rledata ;source of data

loop:	mov	al,[si]		;pickup byte
	cmp	al,0feh		;check for rle key flag
	jz	rle		;is run lenghth coded

notrle:	mov	es:[di],al	;store data to screen
	inc	di
	inc	si
	cmp	di,4000h	;end of screen?
	jnz	loop
	jmp	exit		;done

rle:	inc	si		;point to number of bytes
	mov	bl,[si]	
	inc	si
	mov	al,[si]		;pickup data byte
	inc	si
again:	mov	es:[di],al	;write to screen
	inc	di		;bump screen pointer
	cmp	di,4000h	;end of screen?
	jz	exit
	dec	bl		;count down character counter
	jnz	again
	jmp	loop

exit:	pop	bp
	pop	es
	ret
gentitle endp

prog	ends
	end

;-------------------------------------------------
;
;	<<<<<  Constant Declarations >>>>>
;
; ------------------------------------------------



; -----  Misc  -----

FALSE		equ	0
TRUE		equ	-1

CR		equ	13		; carrige return
LF		equ	10		; line feed

	page

; ------------------------------------------------
;
;	<<<<<  Data Segment Definitions  >>>>>
;
; ------------------------------------------------




; -----  ROM Bios Data Segment  -----

biosdata_seg	segment at 40h

		org	10h

equip_flag	db	?		; equipment flags

biosdata_seg	ends



; -----  Color Card Segment  -----

color_seg	segment at 0b800h

		org	0

color_base	label	byte		; base of color card

color_seg	ends

	page

;------------------------------------------------
;
;	-----  Program Data Segment  -----
;
;------------------------------------------------


dgroup	group	data
data	segment	byte public 'data'


mes_1		db	25 dup (CR,LF)
		db	'                      Please turn on display connected to'
		db	2 dup (CR,LF)
		db	'                      your Color Graphics Display Adapter'
		db	11 dup (CR,LF)
		db	'$'
		

mes_2		db	25 dup (CR,LF)
		db	'          This program requires the Color/Graphics Display Adapter'
		db	14 dup (CR,LF)
		db	'$'

; -----  System Varibles  -----

v_sync		db	TRUE		; TRUE = wait for verticle sync
x_op		db	?		; exclusive-or operation flag
color_byte	db	?		; color select byte
pix_color	db	?		; color of pixels to write

xstart		dw	?		; line x start coordinate
ystart		dw	?		; line y start coordinate
xend		dw	?		; line x end coordinate
yend		dw	?		; line y end coordinate

d1		dw	?		; misc variables for line
d2		dw	?
d3		dw	?
a1		dw	?
a2		dw	?
s1		dw	?
s2		dw	?
n1		dw	?
	
; -----  Sprite Variables and Arrays

col_flag	dw	17 dup(?)	; collision flag table
col_check	dw	17 dup(?)	; collision check table

active		dw	16 dup(FALSE)	; sprite enable flag
image		dw	17 dup(?)	; sprite image address
outline		dw	17 dup(?)	; sprite outline address
backgnd		dw	16 dup(?)	; background buffer address
sp_x		dw	17 dup(?)	; x coordinates of sprites
sp_y		dw	17 dup(?)	; y coordinates of sprites
x_width		dw	17 dup(?)	; x width of sprites
y_width		dw	17 dup(?)	; y width of sprites
x_trim		dw	16 dup(?)	; x coordinate trim
y_trim		dw	16 dup(?)	; y coordinate trim

new_image	dw	16 dup(?)	; new image address
new_outline	dw	16 dup(?)	; new outline address
new_x		dw	?		; new sprite x coordinate
new_y		dw	?		; new sprite y coordinate
new_x_width	dw	16 dup(?)	; new x width
new_y_width	dw	16 dup(?)	; new y width
new_x_trim	dw	16 dup(?)	; new x trim
new_y_trim	dw	16 dup(?)	; new y trim

color_mask	db	?		; color mask for put
even_line	db	?		; even/odd line flag

; ----------  Priority Table

table_addr	dw	offset dgroup:intern_table	; address of table

intern_table	dw	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

data		ends

	page

;-------------------------------------------
;
;	-----  Program Segment  -----
;
;-------------------------------------------


pgroup	group	prog
prog	segment	byte public 'prog'

	public	med_res, clear, palette, backgrnd
	public	pset, xpset, line, xline
	public	sp_init, sp_place, sp_erase, sp_move, sp_chnge, sp_table
	public	sp_blank, sp_check, sp_disp, sp_put, put

	assume	cs:pgroup, ds:dgroup, es:dgroup, ss:dgroup



; ==========  Initialize Color Card to Medium Resolution  ==========
;
; Entry:
;
;	med_res();
;
; Description:
;
;	The color card will be initialzed to display medium resolution
;	graphics in color palette 1 and a message will be displayed on
;	the monochrome saying to turn on the color display. A TRUE will
;	be returned. If there is no color card, a message will be dis-
;	played on the monochrome saying so and a FALSE will be returned.


med_res	proc	near

	push	bp
	mov	bp,sp

	call	_med_res		; call routine

	pop	bp
	ret

med_res	endp



_med_res	proc	near

	mov	si,offset dgroup:mes_1
	call	monomes
	call	chk_disp		; check for color card
	jne	no_card			; jump if no card

card:					; color card present
	call	init_crt		; initialize crt controller
	mov	ax,TRUE			; return TRUE
	ret

no_card:				; color card not present
	mov	si,offset dgroup:mes_2
	call	monomes			; display error message on monochrome
	mov	ax,FALSE		; return FALSE
	ret


chk_disp:				; check for color card
	assume	ds:color_seg

	push	ds
	mov	ax,color_seg
	mov	ds,ax			; set ES to color card segment

	mov	al,55h
	mov	color_base,al		; store a value in color card
	cmp	al,color_base		; compare values
	pop	ds
	ret				; CY = TRUE if no color card

	assume	ds:dgroup


init_crt:				; initialize color card to medium res
	assume	es:biosdata_seg

	push	es
	mov	ax,biosdata_seg				      
	mov	es,ax

	mov	al,equip_flag		; get equipment flag
	and	al,0cfh
	or	al,20h			; show in 80 colum color
	mov	equip_flag,al
	pop	es
	assume	es:dgroup

	mov	ah,0			; set video mode
	mov	al,4			; set to 320x200 color graphics
	int	10h

	mov	ah,11
	mov	bh,1			; palette
	mov	bl,0
	int	10h
	mov	ah,11			; set background color
	mov	bh,0
	mov	bl,1
	int	10h	

	ret


monomes:				; send message *SI to monochrome
	assume	es:biosdata_seg

	push	es
	mov	ax,biosdata_seg				      
	mov	es,ax

	mov	al,equip_flag		; get equipment flag

	pop	es
	assume	es:dgroup

	and	al,30h
	cmp	al,30h			; check monochrome flag bits
	jz	pmes			; jump if monochrome present
	ret				; else return

pmes:
	mov	cx,2000h		; set for no cursor
	mov	ah,1			; set cursor command
	int	10h			; call video I/O
	mov	bx,0
	mov	al,[si]			; get character
	cmp	al,'$'			; check for string end
	je	pmesend			; jump if end
	mov	ah,14			; TTY write routine
	push	si
	int	10h			; video I/O call
	pop	si
	inc	si			; point to next chracter
	jmp	pmes

pmesend:
	ret

_med_res	endp

	page



; ==========  Clear Screen  ==========
;
; Entry:
;
;	clear(color);
;	int	color;
;
; Description:
;
;	The screen will be cleared to `color'.


clear	proc	near

	push	bp
	mov	bp,sp

	mov	al,[bp]+4		; get color to clear screen in al
	call	_clear			; clear screen

	pop	bp
	ret

clear	endp


_clear	proc	near

	and	al,3			; look at 2 lsb only
	mov	cl,2
	mov	dl,al			; set bits
	shl	al,cl			; shift left 2
	or	dl,al			; set bits
	shl	al,cl			; shift left 2
	or	dl,al			; set bits
	shl	al,cl			; shift left 2
	or	dl,al			; set bits
	mov	dh,dl
	
	assume	ds:color_seg

	push	ds
	mov	ax,color_seg
	mov	ds,ax				; set DS to color card segment
	mov	bx,0				; point to beginning of segment
	mov	cx,8192				; loop to clear all words in display

cl1:
	mov	[bx],dx				; clear byte
	inc	bx
	inc	bx				; point to next word
	loop	cl1				; loop until done

	pop	ds
	ret

	assume	ds:dgroup

_clear	endp




; ==========  Set Color Palette  ==========
;
; Entry:
;
;	palette(n);
;	int	n;
;
; Description:
;
;	The color palette specified by n will be selected.


palette		proc	near

	push	bp
	mov	bp,sp

	mov	ah,11				; set color palette
	mov	bh,1
	mov	bl,[bp]+4			; get palette number
	int	10h

	pop	bp
	ret

palette		endp



; ==========  Set Background Color  ==========
;
; Entry:
;
;	backgnd(color);
;	int	color;
;
; Description:
;
;	The background color will be set to `color'


backgrnd	proc	near

	push	bp
	mov	bp,sp

	mov	ah,11			; set background color
	mov	bh,0
	mov	bl,[bp]+4		; get background color
	int	10h

	pop	bp
	ret

backgrnd	endp



; ==========  Set Point  ==========
;
; Entry:
;
;	pset(x,y,color);
;	int	x, y, color;
;
; Description:
;
;	The point x,y will be set to `color'.


pset	proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4		; get x coordinate
	mov	cx,[bp]+6		; get y coordinate
	mov	al,[bp]+8		; get color
	and	al,3
	mov	pix_color,al		; store color
	mov	x_op,FALSE		; not exclusive-or operation
	call	write_point		; call write point routine

	pop	bp
	ret

pset	endp




; ==========  Exclusive-or Point  ==========
;
; Entry:
;
;	xpset(x,y,color);
;	int	x, y, color;
;
; Description:
;
;	The point x,y will be exclusive-or'd with `color'


xpset	proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4		; get x coordinate
	mov	cx,[bp]+6		; get y coordinate
	mov	al,[bp]+8		; get color
	and	al,3
	mov	pix_color,al		; store color
	mov	x_op,TRUE		; not exclusive-or operation
	call	write_point		; call write point routine

	pop	bp
	ret

xpset	endp

	page


; <<<<<<<<<<  Write Point Routine  >>>>>>>>>>
;
; Entry:
;
;	bx        = x coordinate
;	cx        = y coordinate
;	pix_color = color to set/exclusive-or pixel
;	x_op      = TRUE - exclusive-or point, FALSE - set point
;
; Exit:
;
;	ax = TRUE if point is valid, FALSE if not valid
;
;
; Description:
;
;	The coordinates of the point will be verified as valid. If the
;	point is  valid, the pixel will be set or exclusive-or'd with
;	`pix_color' depending of the condition of `x_op'. A TRUE will
;	be returned. If the point is not valid, no screen operation will
;	take place and a FALSE will be returned.


write_point	proc	near

	call	chk_point		; verify point is valid
	jc	w2			; jump if point valid
	mov	ax,FALSE		; signal point is unvalid
	ret

w2:
	call	point_addr		; get address of point in DI
	call	plot_point		; plot point
	mov	ax,TRUE			; signal valid point
	ret


; -----  check x < 320 and y < 200  ///  CY = TRUE if point valid

chk_point:

	cmp	bx,320			; check x coordinate
	jb	chk2			; jump if below 320
	ret
chk2:
	cmp	cx,200			; check y coordinate
	ret


; -----  get address of point BX,CX in DI

point_addr:

	push	cx			; save y
	and	cl,0feh			; reset lsb
	mov	al,40
	mul	cl			; multiply y by 40
	pop	cx			; restore y
	test	cl,1			; check if even or odd scan line
	jz	p2			; jump if even scan line
	add	ax,2000h		; add 8000 to address for odd scan line

p2:
	push	bx
	shr	bx,1
	shr	bx,1			; ignore 2 lsb
	add	ax,bx
	mov	di,ax			; di = address of byte containing pixel
	pop	bx
	ret


; -----  plot point at address pointed to by DI

plot_point:

	push	bx
	push	cx
	and	bl,3			; look at 2 lsb
	xor	bl,3
	shl	bl,1			; double
	mov	cl,bl
	mov	dl,pix_color		; get color of pixel
	shl	dl,cl			; shift color bits into proper position
	mov	dh,3
	shl	dh,cl			; shift mask bits into proper position
	cmp	x_op,0			; check for exclusive-or operation
	jne	xplot			; jump if exclusive_or point

; -----  set point
;
; di = address, dl = color mask, dh = reset mask

	assume	ds:color_seg

	push	ds
	mov	ax,color_seg
	mov	ds,ax			; set DS to color card segment

	mov	al,[di]			; get byte
	not	dh			; complement mask
	and	al,dh			; reset color bits
	or	al,dl			; set new color bits
	mov	[di],al			; write out new byte
	pop	ds
	pop	cx
	pop	bx
	ret

	assume	ds:dgroup


; -----  exclusive-or point
;
; di = address, dl = color mask

xplot:
	assume	ds:color_seg

	push	ds
	mov	ax,color_seg
	mov	ds,ax

	xor	[di],dl
	pop	ds
	pop	cx
	pop	bx
	ret

	assume	ds:dgroup

write_point	endp


	page

; ==========  Draw Line  ==========
;
; Entry:
;
;	line(x1,y1,x2,y2,color);
;	int	x1, y1, x2, y2, color;
;
; Description:
;
;	A line will be drawn from x1,y1, to x2,y2 in `color'


line	proc	near

	push	bp
	mov	bp,sp

	mov	ax,[bp]+4
	mov	xstart,ax		; store x1
	mov	ax,[bp]+6
	mov	ystart,ax		; store y1
	mov	ax,[bp]+8
	mov	xend,ax			; store x2
	mov	ax,[bp]+10
	mov	yend,ax			; store y2
	mov	ax,[bp]+12
	and	al,3
	mov	pix_color,al		; store color
	mov	x_op,FALSE
	call	draw_line		; call routine

	pop	bp
	ret

line	endp




; ==========  Exclusive-Or Line  ==========
;
; Entry:
;
;	xline(x1,y1,x2,y2,color);
;	int	x1, y1, x2, y2, color;
;
; Description:
;
;	A line will be exclusive-or'd from x1,y1, to x2,y2 with `color'


xline	proc	near

	push	bp
	mov	bp,sp

	mov	ax,[bp]+4
	mov	xstart,ax		; store x1
	mov	ax,[bp]+6
	mov	ystart,ax		; store y1
	mov	ax,[bp]+8
	mov	xend,ax			; store x2
	mov	ax,[bp]+10
	mov	yend,ax			; store y2
	mov	ax,[bp]+12
	and	al,3
	mov	pix_color,al		; store color
	mov	x_op,TRUE
	call	draw_line		; call routine

	pop	bp
	ret

xline	endp

	page


; <<<<<<<<<<  Draw Line Routine  >>>>>>>>>>
;
; Entry:
;
;	xstart = x1, ystart = y2, xend = x2, yend = y2,
;
;	pix_color = color
;
;	x_op = TRUE  - exclusive-or line, FALSE - plot line


draw_line	proc	near

	mov	ax,xend
	sub	ax,xstart
	mov	d1,ax			; d1 = dx
	mov	ax,yend
	sub	ax,ystart
	mov	d2,ax			; d2 = dy
	mov	s1,0			; initialize variables
	mov	s2,1
	mov	a1,1
	mov	a2,0

l1:
	cmp	d1,0
	jge	l2			; jump if dx >= 0
	mov	a1,-1			; a1 = -1
	neg	d1			; d1 = -d1

l2:
	cmp	d2,0
	jge	l3			; jump if dy >= 0
	mov	s2,-1			; s2 = -1
	neg	d2			; d2 = -d2

l3:
	mov	ax,d2
	cmp	d1,ax
	jge	l4			; jump if d1 >= d2
	push	d1
	push	d2
	pop	d1
	pop	d2			; swap d1 with d2
	mov	ax,a1
	mov	s1,ax			; s1 = a1
	mov	a1,0			; a1 = 0
	mov	ax,s2
	mov	a2,ax			; a2 = s2
	mov	s2,0			; s2 = 0

l4:
	mov	ax,d1
	shr	ax,1
	mov	d3,ax			; d3 = d1/2
	mov	n1,1			; n1 = 1
	mov	bx,xstart
	mov	cx,ystart
	call	write_point		; plot point

l5:
	mov	ax,d1
	cmp	n1,ax
	jle	l6			; jump if n1 > d1
	ret

l6:
	add	bx,a1			; xstart = xstart + a1
	add	cx,a2			; ystart = ystart + a2
	mov	ax,d2
	add	d3,ax			; d3 = d3 + d2
	inc	n1
	mov	ax,d1
	cmp	d3,ax
	jle	l7			; jump if d3 <+ d1
	mov	ax,d1
	sub	d3,ax			; d3 = d3 - d1
	add	bx,s1			; xstart = xstart + s1
	add	cx,s2			; ystart = ystart + s2

l7:
	call	write_point		; plot point
	jmp	l5


draw_line	endp


; ==========  Sprite Initialize  ==========
;
; Entry:
;
;	sp_init(n,image,outline,backgnd,x_width,y_width,x_trim,y_trim);
;	int	n, x_width, y_width, x_trim, y_trim;
;	char	*image, *outline, *backgnd;


sp_init	proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4		; get sprite number in bx
	and	bx,15			; maximum 16 sprites
	shl	bx,1			; multiply by 2 for 16 bit array address

	mov	ax,[bp]+6
	mov	new_image[bx],ax
	mov	image[bx],ax		; store image address
	mov	ax,[bp]+8
	mov	new_outline[bx],ax
	mov	outline[bx],ax		; store outline address
	mov	ax,[bp]+10
	mov	backgnd[bx],ax		; store background buffer address
	mov	ax,[bp]+12
	mov	new_x_width[bx],ax
	mov	x_width[bx],ax		; store x width of sprite
	mov	ax,[bp]+14
	mov	new_y_width[bx],ax
	mov	y_width[bx],ax		; store y width of sprite
	mov	ax,[bp]+16
	mov	new_x_trim[bx],ax
	mov	x_trim[bx],ax		; store x trim factor
	mov	ax,[bp]+18
	mov	new_y_trim[bx],ax
	mov	y_trim[bx],ax		; store y trim factor

	mov	active[bx],FALSE	; not active till placed

	pop	bp
	ret

sp_init	endp

	page

; ==========  Place Sprite Entry Point  ==========
;
; Entry:
;
;	sp_place(n,x,y);
;	int	n, x, y;


sp_place	proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4		; get sprite number
	and	bx,15
	shl	bx,1			; get 16 bit array address

	mov	ax,[bp]+6
	and	ax,0fffch		; clear 2 lsb
	mov	sp_x[bx],ax		; store x location
	mov	ax,[bp]+8
	mov	sp_y[bx],ax		; store y loation

	call	_sp_place		; call routine

	pop	bp
	ret

sp_place	endp

	page

; ==========  Erase Sprite Entry Point  ==========
;
; Entry:
;
;	sp_erase(n);
;	int	n;


sp_erase	proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4		; get sprite number
	and	bx,15
	shl	bx,1			; get 16 bit array address
	call	_sp_erase		; call erase sprite routine

	pop	bp
	ret

sp_erase	endp

	page

; ==========  Move Sprite Entry Point  ==========
;
; Entry:
;
;	sp_move(n,x,y);
;	int	n, x, y;


sp_move		proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4	; get sprite number
	and	bx,15
	shl	bx,1		; get point to sprite arrays

	mov	ax,[bp]+6	; get new x coordinate
	and	ax,0fffch	; ignore 2 lsb
	mov	new_x,ax	; store it
	mov	ax,[bp]+8	; get new y coordinate
	mov	new_y,ax	; store it
	call	_sp_move	; call move sprite routine

	pop	bp
	ret

sp_move		endp

	page

; ==========  Change Sprite Image  ==========
;
; Entry:
;
;	sp_change(n,image,outline,x_width,y_width,x_trim,y_trim);
;	int	n, x_width, y_width, x_trim, y_trim;
;	char	*image, *outline;


sp_chnge	proc	near

	push	bp
	mov	bp,sp

	mov	bx,[bp]+4		; get sprite number
	and	bx,15
	shl	bx,1			; get pointer address

	mov	ax,[bp]+6		; get new image address
	mov	new_image[bx],ax	; store it
	mov	ax,[bp]+8		; get new outline address
	mov	new_outline[bx],ax	; store it
	mov	ax,[bp]+10		; get new x width
	mov	new_x_width[bx],ax	; store it
	mov	ax,[bp]+12		; get new y width
	mov	new_y_width[bx],ax	; store it
	mov	ax,[bp]+14		; get new x trim
	mov	new_x_trim[bx],ax	; store it
	mov	ax,[bp]+16		; get new y trim
	mov	new_y_trim[bx],ax	; store it

	pop	bp
	ret

sp_chnge	endp

	page

; ==========  Change Sprite Priority Table  ==========
;
;	sp_table(array);
;	int	*array;


sp_table	proc	near

	push	bp
	mov	bp,sp

	mov	ax,[bp]+4		; get address of new priority table
	cmp	ax,0			; check if internal table wanted
	jne	spt1				; jump if not wanted
	mov	ax,offset dgroup:intern_table	; internal table address

spt1:
	mov	table_addr,ax		; store new table address
	pop	bp
	ret

sp_table	endp

	page

; ==========  Blank Conflicting Sprite  ==========
;
;	sp_blank(x,y,x_width,y_width);
;	int	x, y, x_width, y_width;


sp_blank	proc	near

	push	bp
	mov	bp,sp

	mov	bx,16*2			; point to 17th element

	mov	ax,[bp]+4
	mov	sp_x[bx],ax		; store x coordinate
	mov	ax,[bp]+6
	mov	sp_y[bx],ax		; store y coordinate
	mov	ax,[bp]+8
;	shr	ax,1
;	shr	ax,1			; ignore 2 lsb
;	inc	ax			; round off
	mov	x_width[bx],ax		; store x width
	mov	ax,[bp]+10
	mov	y_width[bx],ax		; store y width

	call	_sp_blank		; call routine

	pop	bp
	ret

sp_blank	endp




; ==========  Display Blanked Sprites  ==========
;
;	sp_disp();

sp_disp	proc	near

	push	bp
	mov	bp,sp

	call	bkgnd_all		; get new background for all flagged sprites
	call	replace_all		; call routine

	pop	bp
	ret

sp_disp	endp

	page


; ==========  Check Conflicting Sprite  ==========
;
;	sp_check(x,y,x_width,y_width);
;	int	x, y, x_width, y_width;


sp_check	proc	near

	push	bp
	mov	bp,sp

	mov	bx,16*2			; point to 17th element

	mov	ax,[bp]+4
	mov	sp_x[bx],ax		; store x coordinate
	mov	ax,[bp]+6
	mov	sp_y[bx],ax		; store y coordinate
	mov	ax,[bp]+8
	shr	ax,1
	shr	ax,1			; ignore 2 lsb
	inc	ax			; round off
	mov	x_width[bx],ax		; store x width
	mov	ax,[bp]+10
	mov	y_width[bx],ax		; store y width

	call	_sp_check		; call routine

	pop	bp
	ret

sp_check	endp




; ==========  Put Sprite Image  ==========
;
;	sp_put(x,y,image,outline,x_width,y_width);
;	int	x, y, x_width, y_width;
;	char	*image, *outline;


sp_put	proc	near

	push	bp
	mov	bp,sp

	mov	bx,16*2			; point to 17th array element

	mov	ax,[bp]+4
	and	ax,0fffch
	mov	sp_x[bx],ax		; store x coordinate
	mov	ax,[bp]+6
	mov	sp_y[bx],ax		; store y coordinate
	mov	ax,[bp]+8
	mov	image[bx],ax		; store image address
	mov	ax,[bp]+10
	mov	outline[bx],ax		; store outline address
	mov	ax,[bp]+12
	mov	x_width[bx],ax		; store x width
	mov	ax,[bp]+14
	mov	y_width[bx],ax		; store y width

	call	put_sp			; call routine

	pop	bp
	ret

sp_put	endp

	page

; ==========  Put Image Routine  ==========
;
;	put(x,y,image,color);
;	int	x, y, color;
;	char	*image;


put	proc	near

	push	bp
	mov	bp,sp

	mov	bx,16*2			; point to 17th element

	mov	ax,[bp]+4
	and	ax,0fffch
	mov	sp_x[bx],ax		; store x coordinate
	mov	ax,[bp]+6
	mov	sp_y[bx],ax		; store y coordinate

	mov	ah,0			; clear ah
	mov	si,[bp]+8		; get address of array
	mov	al,[si]			; get x width
	mov	x_width[bx],ax		; store x width
	mov	al,[si]+1		; get y width
	mov	y_width[bx],ax		; store y width
	add	si,2			; point to first image element
	mov	image[bx],si		; store address

	mov	dl,[bp]+10		; get color mask value
	and	dl,3
	mov	al,0			; clear al
	mov	cl,2			; shift count
	or	al,dl			; get first pixel mask
	shl	dl,cl			; shift left 2 bits
	or	al,dl			; second pixel mask
	shl	dl,cl			; shift
	or	al,dl			; third pixel mask
	shl	dl,cl			; shift
	or	al,dl			; fourth pixel mask
	mov	color_mask,al		; store color mask

	call	put_image		; call put routine

	pop	bp
	ret

put	endp

	page

; <<<<<<<<<<  Place Sprite Routine  >>>>>>>>>>
;
; Description:
;
;	A check will be made to see if the new sprite location to be used will
;	overlap any existing sprites. If so, the confliction sprites are removed.
;	The background area of the sprite to be placed will be dumped to the
;	background buffer. Then the new sprite to be placed as well as the
;	previously removed sprites will be re_placed according to their priority.
;	Collision information from the overlap check is then returned.

_sp_place	proc	near

	mov	ax,new_image[bx]
	mov	image[bx],ax		; get new image address
	mov	ax,new_outline[bx]
	mov	outline[bx],ax		; get new outline address
	mov	ax,new_x_width[bx]
	mov	x_width[bx],ax		; get new x width
	mov	ax,new_y_width[bx]
	mov	y_width[bx],ax		; get new y width
	mov	ax,new_x_trim[bx]
	mov	x_trim[bx],ax		; get new x trim
	mov	ax,new_y_trim[bx]
	mov	y_trim[bx],ax		; get new y trim

	call	clear_table		; clear collision tables
	call	collision		; fill table with colliding sprites
	call	remove_all		; remove all sprites in table
	call	get_backgnd		; fill background buffer
	mov	active[bx],TRUE		; flag sprite as active
	mov	col_flag[bx],TRUE	; flag new sprite in table

	call	replace_all		; re-place new and prevoiusly removed sprites
	call	col_detect		; return collision information
	ret

_sp_place	endp




; <<<<<<<<<<  Sprite Erase Routine  >>>>>>>>>>
;
; Description:
;
;	The background buffer of the specified sprite will be dumped to
;	the screen to erase the sprite. A check will then be made to see
;	if there were any colliding sprites. If so, the sprites will be
;	re-placed on the screen.


_sp_erase	proc	near

	call	remove_sp		; remove specified sprite
	mov	active[bx],FALSE	; flag as inactive
	call	clear_table		; clear collision tables
	call	collision		; fill table with collided sprites
	call	replace_all		; replace sprites
	ret

_sp_erase	endp




; <<<<<<<<<<  Move Sprite Routine  >>>>>>>>>>
;
; Description:
;
;	The routine will first erase any conflicting sprites at the present
;	sprite location. Then it will erase conflicting sprites at its
;	destination. Then all sprites are re-drawn including the present
;	sprite at its new location according to their priority. Collision
;	information is then returned.


_sp_move	proc	near

	call	clear_table		; clear collision tables
	call	collision		; flag colliding sprites

	push	sp_x[bx]
	push	sp_y[bx]
	push	x_width[bx]
	push	y_width[bx]		; save old parameters

	mov	ax,new_x		; get new x coordinate
	mov	sp_x[bx],ax		; store it
	mov	ax,new_y		; get new y coordinate
	mov	sp_y[bx],ax		; store it

	mov	ax,new_x_width[bx]
	mov	x_width[bx],ax		; get possible new x width
	mov	ax,new_y_width[bx]
	mov	y_width[bx],ax		; get possible new y width

	call	clear_chk		; clear col_check table
	call	collision		; flag sprites at new location to be removed

	pop	y_width[bx]
	pop	x_width[bx]
	pop	sp_y[bx]
	pop	sp_x[bx]		; restore old parameters

	mov	col_flag[bx],TRUE	; flag present sprite to be removed
	call	remove_all		; remove flagged sprites

	mov	ax,new_x		; get new x coordinate
	mov	sp_x[bx],ax		; store it
	mov	ax,new_y		; get new y coordinate
	mov	sp_y[bx],ax		; store it

	mov	ax,new_image[bx]
	mov	image[bx],ax		; get possible new image address
	mov	ax,new_outline[bx]
	mov	outline[bx],ax		; get possible new outline address
	mov	ax,new_x_width[bx]
	mov	x_width[bx],ax		; get possible new x width
	mov	ax,new_y_width[bx]
	mov	y_width[bx],ax		; get possible new y width
	mov	ax,new_x_trim[bx]
	mov	x_trim[bx],ax		; get possible new x trim
	mov	ax,new_y_trim[bx]
	mov	y_trim[bx],ax		; get possible new y trim

	call	get_backgnd		; fill background buffer with new background
	call	replace_all		; replace all flagged sprites
	call	col_detect		; return collision information
	ret

_sp_move	endp




; <<<<<<<<<<  Blank Conflicting Sprites Routine  >>>>>>>>>>
;
; Description:
;
;	This routine will flag all sprites overlapping in the
;	specified area and then erase them.


_sp_blank	proc	near

	call	clear_table		; clear collision tables
	call	collision		; flag conflicting sprites
	call	remove_all		; remove them

	ret

_sp_blank	endp



; <<<<<<<<<<  Check for Conflicting Sprites Routine  >>>>>>>>>>
;
; Description:
;
;	This routine will flag all sprites overlapping in the
;	specified area.


_sp_check	proc	near

	call	clear_table		; clear collision tables
	call	collision		; flag conflicting sprites

	mov	bx,0			; point to first array element
	mov	dx,0			; sprite # 0
	mov	ax,0			; clear colision register
chp1:
	cmp	col_flag[bx],TRUE	; check if sprite flagged
	jne	chloop			; jump if not
	mov	di,1			; set bit 0
	mov	cl,dl			; put sprite number into cl
	shl	di,cl			; shift bit `sprite' number of times
	or	ax,di			; set bit in ax


chloop:
	add	bx,2			; point to next element
	inc	dx			; next sprite number
	cmp	dx,16			; do all sprites
	jne	chp1
	ret

_sp_check	endp



; ----------  Clear Collision Tables  ----------
;
; Description:
;
;	This routine will clear the collision tables.


clear_table	proc	near

	call	clear_chk
	push	bx
	mov	cx,17			; clear all 16 positions
	mov	bx,0			; point to first array element

clr1:
	mov	col_flag[bx],FALSE	; clear entry
	add	bx,2			; point to next element
	loop	clr1			; loop until done

	pop	bx
	ret

clear_table	endp




; ----------  Clear Collision Check Table  ----------

clear_chk	proc	near

	push	bx
	mov	cx,17			; clear all 17 positions
	mov	bx,0			; point to first array element

cler1:
	mov	col_check[bx],FALSE	; clear entry
	add	bx,2			; point to next element
	loop	cler1			; loop until done

	pop	bx
	ret

clear_chk	endp




; ----------  Sprite Collision Check  ----------
;
; Description:
;
;	A check will be made to see if the present sprite location will cause
;	overlapping or a collision with any other active sprites. If so, the
;	affected sprites will be flagged in the col_flag table.
;
; Entry:
;
;	bx = pointer to sprite arrays
;
; Exit:
;
;	bx is preserved


collision	proc	near

	push	bx
	push	si

	cmp	col_check[bx],TRUE	; has this sprite already been checked
	je	col_end			; jump if it has

	mov	col_check[bx],TRUE	; flag sprite as alread checked
	mov	si,bx			; get array pointer for sprite under use
	mov	bx,0			; point to first array element

co1:
	cmp	active[bx],TRUE		; check if sprite is active
	jne	cloop			; ignore if not active
	cmp	si,bx			; check for collision with itself
	je	cloop			; leave check if it is
	call	overlap			; check for sprite overlap
	jnc	cloop1			; jump to second check if no overlap
	mov	col_flag[bx],TRUE	; flag sprite as overlapping
	call	collision		; recursive call

cloop1:	add	sp_x[bx],320		; check alternate position
	sub	sp_y[bx],2
	call	overlap
	jnc	rsm1
	mov	col_flag[bx],TRUE	; flag sprite as overlapping
	call	collision		; recursive call

rsm1:	sub	sp_x[bx],640		; check second alternate position variables
	add	sp_y[bx],4
	call	overlap
	jnc	rsm3
	mov	col_flag[bx],TRUE	; flag sprite as overlapping
	call	collision		; recursive call

rsm3:	add	sp_x[bx],320		; correct values
	sub	sp_y[bx],2

cloop:
	add	bx,2			; point to next array element
	cmp	bx,32			; gone through 16 sprites?
	jne	co1			; jump if not

col_end:
	pop	si
	pop	bx
	ret

collision	endp



; ----------  Sprite Overlap Check  ----------
;
; Description:
;
;	This routine will check to see if a sprite whos number is in dx,
;	is overlapping the present sprite under use.
;
; Entry:
;
;	bx = pointer to test sprite arrays
;	si = pointer to sprite under use arrays
;
; Exit:
;
;	cy = TRUE  - sprite overlap
;	cy = FALSE - no overlap
;
;	bx, dx, si are preserved


overlap	proc	near

; -----  check x coordinates

	mov	ax,sp_x[bx]		; get test sprite x coordinate
	cmp	ax,sp_x[si]		; compare against sprite under use
	jl	ov2			; jump if test sprite left of sprite

; -----  test sprite right of sprite under use

ov1:
	mov	ax,x_width[si]		; get x width to x coordinate
	shl	ax,1
	shl	ax,1			; multiply width by 4 (4 pixels per byte)
	add	ax,sp_x[si]		; add x coordinate of sprite
	dec	ax			; decrement for proper value
	cmp	sp_x[bx],ax		; compare x adjusted coordinates
	jle	ov3			; jump if match so far
	jmp	nomatch

; -----  test sprite left of sprite under use

ov2:
	mov	ax,x_width[bx]		; get x width of test sprite
	shl	ax,1
	shl	ax,1			; multiply width by 4 (4 pixels per byte)
	add	ax,sp_x[bx]		; add x coordinate of test sprite
	dec	ax			; decrement for proper value
	cmp	ax,sp_x[si]		; compare adjusted x coordinates
	jge	ov3			; jump if match
	jmp	nomatch

; -----  compare y coordinate

ov3:
	mov	ax,sp_y[bx]		; get test sprite y coordinate
	cmp	ax,sp_y[si]		; compare against sprite under use
	jl	ov5			; jump if test sprite above sprite

; -----  test sprite below sprite under use

ov4:
	mov	ax,y_width[si]		; get y width of sprite
	add	ax,sp_y[si]		; add y coordinate
	dec	ax			; decrement for proper value
	cmp	sp_y[bx],ax		; compare adjusted coordinates
	jle	match			; jump if matched
	jmp	nomatch

; -----  test sprite above sprite under use

ov5:
	mov	ax,y_width[bx]		; get y width of test sprite
	add	ax,sp_y[bx]		; add y coordinate
	dec	ax			; decrement for proper value
	cmp	ax,sp_y[si]		; compare adjusted y values
	jge	match			; jump if there is a match
	jmp	nomatch

; -----  match not found

nomatch:
	or	al,al			; clear carry
	ret

; -----  match found

match:
	stc				; set carry
	ret

overlap	endp




; ----------  Return Collision Information  ----------
;
; Description:
;
;	This routine will check to see if a sprite pointed to by bx
;	is overlapping the present sprite under use pointed to by si
;	after the trim factors have been taken into account for.
;
; Entry:
;
;	bx = pointer to test sprite arrays
;	si = pointer to sprite under use arrays
;
; Exit:
;
;	cy = TRUE  - sprite overlap
;	cy = FALSE - no overlap
;
;	bx, dx, si are preserved


ret_col	proc	near

; -----  check x coordinates

	mov	ax,sp_x[bx]		; get test sprite x coordinate
	cmp	ax,sp_x[si]		; compare against sprite under use
	jl	rc2			; jump if test sprite left of sprite

; -----  test sprite right of sprite under use

rc1:
	mov	ax,x_width[si]		; get x width to x coordinate
	shl	ax,1
	shl	ax,1			; multiply width by 4 (4 pixels per byte)
	add	ax,sp_x[si]		; add x coordinate of sprite
	sub	ax,x_trim[si]		; subtract x trim factor
	dec	ax			; decrement for proper value
	mov	cx,sp_x[bx]		; get test sprite x coordinate
	add	cx,x_trim[bx]		; add x trim factor
	cmp	cx,ax			; compare adjusted x coordinates
	jle	rc3			; jump if match so far
	jmp	rnomatch

; -----  test sprite left of sprite under use

rc2:
	mov	ax,x_width[bx]		; get x width of test sprite
	shl	ax,1
	shl	ax,1			; multiply width by 4 (4 pixels per byte)
	add	ax,sp_x[bx]		; add x coordinate of test sprite
	sub	ax,x_trim[bx]		; subtract x trim factor
	dec	ax			; decrement for proper value
	mov	cx,sp_x[si]		; get sprite x coordinate
	add	cx,x_trim[si]		; add x trim factor
	cmp	ax,cx			; compare adjusted x coordinates
	jge	rc3			; jump if match
	jmp	rnomatch

; -----  compare y coordinate

rc3:
	mov	ax,sp_y[bx]		; get test sprite y coordinate
	cmp	ax,sp_y[si]		; compare against sprite under use
	jl	rc5			; jump if test sprite above sprite

; -----  test sprite below sprite under use

rc4:
	mov	ax,y_width[si]		; get y width of sprite
	add	ax,sp_y[si]		; add y coordinate
	sub	ax,y_trim[si]		; subtract y trim factor
	dec	ax			; decrement for proper value
	mov	cx,sp_y[bx]		; get test sprite y coordinate
	add	cx,y_trim[bx]		; add y trim factor
	cmp	cx,ax			; compare adjusted y coordinates
	jle	rmatch			; jump if matched
	jmp	rnomatch

; -----  test sprite above sprite under use

rc5:
	mov	ax,y_width[bx]		; get y width of test sprite
	add	ax,sp_y[bx]		; add y coordinate
	sub	ax,y_trim[bx]		; subtract y trim factor
	dec	ax			; decrement for proper value
	mov	cx,sp_y[si]		; get sprite y coordinate
	add	cx,y_trim[si]		; add y trim factor
	cmp	ax,cx			; compare adjusted y values
	jge	rmatch			; jump if there is a match
	jmp	rnomatch

; -----  match not found

rnomatch:
	or	al,al			; clear carry
	ret

; -----  match found

rmatch:
	stc				; set carry
	ret

ret_col	endp




; ----------  Remove Sprite  ----------
;
; Description:
;
;	The sprite specified will be removed by dumping the background
;	buffer for that sprite.
;
; Entry:
;
;	bx = pointer to sprite arrays


remove_sp	proc	near

	push	es
	push	si
	push	cx

	call	xfer_init		; get address of sprite top left corner in di
	mov	si,backgnd[bx]		; get address of background buffer
	mov	cx,y_width[bx]		; get y width as line counter

	assume	es:color_seg

	mov	ax,color_seg
	mov	es,ax			; set es to color card segment

re1:
	call	xfer_line		; dump line of buffer
	call	next_line		; get address of next line
	loop	re1			; loop until all lines are done

	pop	cx
	pop	si
	pop	es
	ret

	assume	es:dgroup

remove_sp	endp



; ----------  Put Image  ----------
;
; Description:
;
;	The image specified by the put command will be placed on the screen
;
; Entry:
;
;	bx = pointer to 17th element


put_image	proc	near

	push	es
	push	si
	push	cx

	call	xfer_init		; get address of sprite top left corner in di
	mov	si,image[bx]		; get address of image buffer
	mov	cx,y_width[bx]		; get y width as line counter

	assume	es:color_seg

	mov	ax,color_seg
	mov	es,ax			; set es to color card segment

put1:
	call	xfer_put_line		; dump line of buffer
	call	next_line		; get address of next line
	loop	put1			; loop until all lines are done

	pop	cx
	pop	si
	pop	es
	ret

	assume	es:dgroup

put_image	endp



; ----------  Sprite Tranfer Initialize Routine  ----------
;
; Description:
;
;	This routine will calculate the address of the top left pixel of
;	the specified sprite. Also it will set a flag signaling if the
;	present line is odd or even.
;
; Entry:
;
;	bx = pointer to sprite arrays
;
; Exit:
;
;	di = screen address of pixel



xfer_init	proc	near

	push	bx
	push	cx

	mov	cx,sp_y[bx]		; get y coordinate
	mov	ax,sp_x[bx]		; get x coordinate
	mov	bx,ax			; put in bx
	call	point_addr		; get address of byte in di
	test	cx,1			; check for odd line
	jz	xf2			; jump if even line
	mov	even_line,FALSE		; signal on odd line

	pop	cx
	pop	bx
	ret

xf2:
	mov	even_line,TRUE		; signal even line
	pop	cx
	pop	bx
	ret

xfer_init	endp




; ----------  Transfer Image Line  ----------
;
; Description:
;
;	This routine will transfer an screen image line from/to an
;	image buffer.
;
; Entry:
;
;	bx = pointer to sprite arrays
;	si = source buffer address
;	di = screen line starting address
;	ds = source segment
;	es = destination segment
;
; Exit:
;	si = address of next image byte
;	di = one address past last address used for transfer


xfer_line	proc	near

	assume	ds:nothing, es:nothing

	push	cx
	cld				; clear direction flag
	mov	cx,x_width[bx]		; get x width of image
	rep	movsb			; transfer byte image string
	pop	cx
	ret

	assume	ds:dgroup, es:dgroup

xfer_line	endp




; ----------  Transfer Sprite Image Line  ----------
;
; Description:
;
;	This routine will transfer an image line from the sprite image
;	array to the screen. It also uses the outline array to see if
;	a pixel location should be black or the background color.
;
; Entry:
;
;	bx = pointer to sprite arrays
;	si = pointer into image arrays
;	di = screen line starting addresss
;	es = screen segment


xfer_sp_line	proc	near

	assume	es:color_seg

	push	cx
	mov	cx,x_width[bx]		; use x width as row counter

xf1:
	mov	bp,outline[bx]		; get address of outline array
	mov	al,[bp+si]		; get outline byte
	and	al,es:[di]		; and outline with screen background
	mov	bp,image[bx]		; get address of image array
	or	al,[bp+si]		; or al with image byte
	mov	es:[di],al		; put byte on screen
	inc	si			; point to next element
	inc	di			; point to next screen address
	loop	xf1			; loop until row is done

	pop	cx
	ret

	assume	es:dgroup

xfer_sp_line	endp




; ----------  Transfer `Put' Image Line  ----------
;
; Description:
;
;	This routine will transfer an image line from the image array,
;	specified by the put command, to the screen.
;
; Entry:
;
;	bx = pointer to sprite array
;	si = pointer into image array
;	di = screen line starting addresss
;	es = screen segment


xfer_put_line	proc	near

	assume	es:color_seg

	push	cx
	mov	cx,x_width[bx]		; get x width of image

xpu1:
	mov	al,[si]			; get image byte
	and	al,color_mask		; and with color mask
	mov	es:[di],al		; transfer to screen
	inc	si			; point to next image byte
	inc	di			; point to next screen address
	loop	xpu1			; loop til done

	pop	cx
	ret

	assume	es:dgroup

xfer_put_line	endp




; ----------  Calculate Next Line Address  ----------
;
; Description:
;
;	This routine will calculate the address of the next line for another
;	image line transfer without using a multiply instruction.
;
; Entry:
;
;	bx = pointer to sprite arrays
;	di = one address past last address used for transfer
;	even_line = TRUE/FALSE
;
; Exit:
;
;	di = new line destination address


next_line	proc	near

	assume	ds:nothing, es:nothing

	sub	di,x_width[bx]		; subtract x width of image
	not	even_line		; switch status of even_line
	cmp	even_line,TRUE		; is new line even
	je	ne2			; jump if it is

; ----- new line is odd

	add	di,2000h		; add 8k offset to address
	ret

; ----- new line is even

ne2:
	sub	di,2000h-80		; subtract 8k offset from address
	ret

	assume	ds:dgroup, es:dgroup

next_line	endp




; ----------  Get New Background for Flagged Sprites  ----------
;
; Description:
;
;	This routine will update the background buffer for all flagged
;	sprites (flagged by the sp_blank command).


bkgnd_all	proc	near

	push	bx
	mov	bx,0		; point to first element

bka1:
	cmp	col_flag[bx],TRUE	; check if sprite flagged
	jne	bkaloop			; jump if not flagged
	call	get_backgnd		; get background

bkaloop:
	add	bx,2			; point to next element
	cmp	bx,32			; done all sprites
	jne	bka1			; jump if not

	pop	bx
	ret

bkgnd_all	endp




; ----------  Fill Background Buffer  ----------
;
; Description:
;
;	The specified sprite's background buffer will be filled with the
;	background that the sprite will be occupying.
;
; Entry:
;
;	bx = pointer to sprite arrays


get_backgnd	proc	near

	call	xfer_init		; get address of top left corner in di
	mov	si,di			; move address into si
	mov	di,backgnd[bx]		; get address of background buffer
	mov	cx,y_width[bx]		; get y width as line counter

	assume	ds:color_seg

	push	ds
	mov	ax,color_seg
	mov	ds,ax			; set ds to color card segment

ge1:
	call	xfer_line		; transfer line of image
	xchg	si,di			; exchange si with di
	call	next_line		; get address of next line
	xchg	si,di			; transfer new address back to si
	loop	ge1			; loop until all lines transfered

	pop	ds
	ret

	assume	ds:dgroup

get_backgnd	endp




; ----------  Put Sprite Routine  ----------
;
; Description:
;
;	This routine will transfer a sprite image onto the screen from
;	the image array with complete background prioritization using
;	the outline array
;
; Entry:
;
;	bx = pointer to sprite arrays


put_sp	proc	near

	push	es
	push	bx
	push	cx
	push	si

	call	xfer_init		; get address of top left corner in di
	mov	si,0			; point to first array element
	mov	cx,y_width[bx]		; get y width as line counter

	assume	es:color_seg

	mov	ax,color_seg
	mov	es,ax			; set es to color card segment

pu1:
	call	xfer_sp_line		; transfer sprite line
	call	next_line		; get address of next line
	loop	pu1			; loop until all line transfered

	pop	si
	pop	cx
	pop	bx
	pop	es
	ret

	assume	es:dgroup

put_sp	endp




; ----------  Replace Erased Sprites  ----------
;
; Description:
;
;	The col_flag table will be scanned to see which sprites are to
;	be placed on the screen.


replace_all	proc	near

	push	bx
	mov	cx,16			; check all 16 entries
	mov	si,table_addr		; address of priority table

repl1:
	mov	bx,[si]			; get sprite number
	shl	bx,1			; convert to pointer
	cmp	col_flag[bx],TRUE	; check if sprite flagged
	jne	reploop			; jump if not
	call	put_sp			; call put sprite routine

reploop:
	add	si,2			; point to next sprite number
	loop	repl1			; loop through all sprites

	pop	bx
	ret

replace_all	endp




; ----------  Removed Flagged Sprites  ----------
;
; Description:
;
;	The col_flag table will be scanned to see which sprites are to
;	be erased.


remove_all	proc	near

	push	bx
	mov	cx,16			; check all 16 entries
	mov	bx,0			; point to first array element

rep1:
	cmp	col_flag[bx],TRUE	; check if sprite flagged
	jne	reloop			; jump if not
	call	remove_sp		; remove sprite

reloop:
	add	bx,2			; point to next element
	loop	rep1			; loop through all sprites

	pop	bx
	ret

remove_all	endp



; ----------  Return Collision Information  ----------
;
; Description:
;
;	This routine will set bits 0 through 15 to one if a collision
;	has taken place with any sprite(s) 0 through 15.
;
; Entry:
;
;	bx = pointer to sprite array


col_detect	proc	near

	mov	si,bx			; get sprite under use in si
	mov	dx,0			; sprite number 0
	mov	bx,0			; point to first array element
	mov	ax,0			; clear collision register

ret1:
	cmp	active[bx],TRUE		; is sprite active
	jne	retl1			; jump if not active
	cmp	si,bx			; is sprite checking itself
	je	retl1			; jump if it is
	push	ax
	call	ret_col			; check for collision
	pop	ax
	jnc	retloop			; jump if not
	mov	di,1			; set bit 0
	mov	cl,dl			; put sprite number in cl
	shl	di,cl			; shift bit `sprite' number of times
	or	ax,di			; set bit in ax

retloop:
	add	sp_x[bx],320		; check alternate locations
	sub	sp_y[bx],2
	push	ax
	call	ret_col
	pop	ax
	jnc	rsm2
	mov	di,1			; set bit 0
	mov	cl,dl			; put sprite number in cl
	shl	di,cl			; shift bit `sprite' number of times
	or	ax,di			; set bit in ax

rsm2:	sub	sp_x[bx],640
	add	sp_y[bx],4
	push	ax
	call	ret_col
	pop	ax
	jnc	rsm4
	mov	di,1			; set bit 0
	mov	cl,dl			; put sprite number in cl
	shl	di,cl			; shift bit `sprite' number of times
	or	ax,di			; set bit in ax

rsm4:	add	sp_x[bx],320		; restore values
	sub	sp_y[bx],2

retl1:	add	bx,2			; point to next element
	inc	dx			; next sprite number
	cmp	dx,16			; done looping?
	jne	ret1			; jump if not

	ret

col_detect	endp


prog		ends
		end



	PAGE


; Computer type selection

IBM	EQU	1	; set up for IBM PC if equal to 1
HYP	EQU	0	; set up for Hyperion if equal to 1


; -----------------------------------------------
;
;	<<<<<  Constant Declarations  >>>>>
;
; -----------------------------------------------


CRTADD	EQU	3D4H		; address port of 6845 CRT controller
CRTDAT	EQU	3D5H		; data port of 6845

	if HYP
KB_DATA	EQU	0E0H		; keyboard data port
KB_CNTL	EQU	0E0H		; keyboard control port
	endif
	if IBM
KB_DATA	EQU	60H		; keyboard data port
KB_CNTL	EQU	61H		; keyboard control port
	endif

FALSE		EQU	0
TRUE		EQU	-1
STOP		EQU	0			; stopped movement
LEFT		EQU	1			; left movement
RIGHT		EQU	2			; right movement

DIRR		EQU	0			; Right movement
DIRUR		EQU	1			; Up and right movement
DIRU		EQU	2			; Up
DIRUL		EQU	3			; Up and left
DIRL		EQU	4			; Left
DIRDL		EQU	5			; Down and left
DIRD		EQU	6			; Down
DIRDR		EQU	7			; Down and right
DIRNONE		EQU	-1			; Nothing pressed


	if IBM
L_ARROW_DOWN	EQU	75			; left arrow down
L_ARROW_UP	EQU	L_ARROW_DOWN OR 128     ; left arrow up
R_ARROW_DOWN	EQU	77			; right arrow down
R_ARROW_UP	EQU	R_ARROW_DOWN OR 128	; right arrow key up
U_ARROW_DOWN	EQU	72			; up arrow
U_ARROW_UP	EQU	U_ARROW_DOWN OR 128
D_ARROW_DOWN	EQU	80			; down arrow
D_ARROW_UP	EQU	D_ARROW_DOWN OR 128
;UR_ARROW_DOWN	EQU	73			; up & right (9)
;UR_ARROW_UP	EQU	UR_ARROW_DOWN OR 128
;UL_ARROW_DOWN	EQU	71			; up & left (7)
;UL_ARROW_UP	EQU	UL_ARROW_DOWN OR 128
;DR_ARROW_DOWN	EQU	81			; down & right (3)
;DR_ARROW_UP	EQU	DR_ARROW_DOWN OR 128
;DL_ARROW_DOWN	EQU	79			; down & left (1)
;DL_ARROW_UP	EQU	DL_ARROW_DOWN OR 128

F1_DOWN		EQU	1Ch ;59			; F1 key down -> Enter
F1_UP		EQU	F1_DOWN OR 128		; F1 key up
CNTL_DOWN	EQU	29			; control key down
CNTL_UP		EQU	CNTL_DOWN OR 128	; control key up
;ALT_DOWN	EQU	56			; alternate key down
;ALT_UP		EQU	ALT_DOWN OR 128		; alternate key up
;DEL_DOWN	EQU	83			; delete key down
;DEL_UP		EQU	DEL_DOWN OR 128		; delete key up
F9_DOWN		EQU	67			; F9 down
F9_UP		EQU	F9_DOWN OR 128		; F9 up
F7_DOWN		EQU	65			; F7 down
F7_UP		EQU	F7_DOWN OR 128		; F7 up

ESC_DOWN	EQU	1			; Esc key down
	endif

	if HYP
L_ARROW_DOWN	EQU	82			; left arrow down
L_ARROW_UP	EQU	L_ARROW_DOWN OR 128     ; left arrow up
R_ARROW_DOWN	EQU	84			; right arrow down
R_ARROW_UP	EQU	R_ARROW_DOWN OR 128	; right arrow key up
U_ARROW_DOWN	EQU	79			; up arrow
U_ARROW_UP	EQU	U_ARROW_DOWN OR 128
D_ARROW_DOWN	EQU	87			; down arrow
D_ARROW_UP	EQU	D_ARROW_DOWN OR 128
;UR_ARROW_DOWN	EQU	80			; up & right (9)
;UR_ARROW_UP	EQU	UR_ARROW_DOWN OR 128
;UL_ARROW_DOWN	EQU	78			; up & left (7)
;UL_ARROW_UP	EQU	UL_ARROW_DOWN OR 128
;DR_ARROW_DOWN	EQU	88			; down & right (3)
;DR_ARROW_UP	EQU	DR_ARROW_DOWN OR 128
;DL_ARROW_DOWN	EQU	86			; down & left (1)
;DL_ARROW_UP	EQU	DL_ARROW_DOWN OR 128

F1_DOWN		EQU	01			; F1 key down
F1_UP		EQU	F1_DOWN OR 128		; F1 key up
CNTL_DOWN	EQU	44			; control key down
CNTL_UP		EQU	CNTL_DOWN OR 128	; control key up
;ALT_DOWN	EQU	59			; alternate key down
;ALT_UP		EQU	ALT_DOWN OR 128		; alternate key up
;DEL_DOWN	EQU	92			; delete key down
;DEL_UP		EQU	DEL_DOWN OR 128		; delete key up
F9_DOWN		EQU	10			; F9 down
F9_UP		EQU	F9_DOWN OR 128		; F9 up
F7_DOWN		EQU	08			; F7 down
F7_UP		EQU	F7_DOWN OR 128		; F7 up

ESC_DOWN	EQU	13			; Esc key down
	endif

SYNC_NORM	EQU	2CH			; normal sync position

	PAGE

; ==========  Alternate Segment Definitions  ==========

; -----  ROMSEG - rom bios segment

ROMSEG		SEGMENT AT 0F000H

		ASSUME	CS:ROMSEG

		ORG 0FFF0H

REBOOT		PROC	FAR		; Re-boot jump vector in ROM BIOS
REBOOT		ENDP

		ASSUME	CS:NOTHING

ROMSEG		ENDS


; ----- ROMDATA - rom bios data area

ROMDATA		SEGMENT	AT 40H

       		ORG	72H

RESET_FLAG	DW	?		; keyboard reset flag

	if HYP
		org	0e0h

SCREEN		db	?		; screen active flag for Hyperion
	endif


ROMDATA		ENDS

	PAGE

;--------------------------------------------
;
;	<<<<<  Data Storage Area  >>>>>
;
;--------------------------------------------


DGROUP	GROUP	DATA
DATA	SEGMENT	BYTE PUBLIC 'DATA'

	PUBLIC	KEYCHR, KEYDIR, LKDIR, PDIR, LDIR, FIRE, FIRES
	PUBLIC	ENDGAME, SOUND, MUSIC, JOYX, JOYY, BUTT1, BUTT2, DEFSEG


KB_ADR		DW	?		; keyboard routine address
KB_SEG		DW	?		; keyboard routine segment

L_KEY		DB	FALSE		; key press flags
R_KEY		DB	FALSE
U_KEY		DB	FALSE
D_KEY		DB	FALSE
UR_KEY		DB	FALSE
UL_KEY		DB	FALSE
DR_KEY		DB	FALSE
DL_KEY		DB	FALSE
RST1		DB	FALSE
RST2		DB	FALSE
RST3		DB	FALSE
SND_UP		DB	TRUE
MSC_UP		DB	TRUE

KEYCHR		DB	0		; scan code of key pressed
KEYDIR		DW	DIRNONE		; 8 direction variable
LKDIR		DW	DIRNONE		; last of 8 directions pressed
PDIR		DW	STOP		; 2 direction variable
LDIR		DW	STOP		; last of 2 directions pressed
FIRE		DW	FALSE		; fire key (F1)
FIRES		DW	FALSE		; fire key flag (TRUE = was pressed)
ENDGAME		DW	FALSE		; TRUE = escape key pressed
SOUND		DW	TRUE		; sound toggle
MUSIC		DW	FALSE ;TRUE		; music toggle

JOYX		DW	?		; joystick x coordinate
JOYY		DW	?		; joystick y coordinate
BUTT1		DW	FALSE		; button 1 flag
BUTT2		DW	FALSE		; button 2 flag

SYNC_POS	DB	SYNC_NORM	; current sync position
DEFSEG		DW	?		; data segment value for peek/poke


; ----- Keyboard Decode Table

KB_TABLE	LABEL	BYTE


	DB	L_ARROW_DOWN
	DW	OFFSET PGROUP:LEFT_DOWN
	DB	L_ARROW_UP
	DW	OFFSET PGROUP:LEFT_UP

	DB	R_ARROW_DOWN
	DW	OFFSET PGROUP:RIGHT_DOWN
	DB	R_ARROW_UP
	DW	OFFSET PGROUP:RIGHT_UP

	DB	U_ARROW_DOWN
	DW	OFFSET PGROUP:UP_DOWN
	DB	U_ARROW_UP
	DW	OFFSET PGROUP:UP_UP

	DB	D_ARROW_DOWN
	DW	OFFSET PGROUP:DOWN_DOWN
	DB	D_ARROW_UP
	DW	OFFSET PGROUP:DOWN_UP

; -----  blank out all 45 degree keys
;	DB	UR_ARROW_DOWN
;	DW	OFFSET PGROUP:UPR_DOWN
;	DB	UR_ARROW_UP
;	DW	OFFSET PGROUP:UPR_UP

;	DB	UL_ARROW_DOWN
;	DW	OFFSET PGROUP:UPL_DOWN
;	DB	UL_ARROW_UP
;	DW	OFFSET PGROUP:UPL_UP

;	DB	DR_ARROW_DOWN
;	DW	OFFSET PGROUP:DOWNR_DOWN
;	DB	DR_ARROW_UP
;	DW	OFFSET PGROUP:DOWNR_UP

;	DB	DL_ARROW_DOWN
;	DW	OFFSET PGROUP:DOWNL_DOWN
;	DB	DL_ARROW_UP
;	DW	OFFSET PGROUP:DOWNL_UP


	DB	F1_DOWN
	DW	OFFSET PGROUP:FIRE_DOWN
	DB	F1_UP
	DW	OFFSET PGROUP:FIRE_UP

;	DB	CNTL_DOWN
;	DW	OFFSET PGROUP:RESET1_DOWN
;	DB	CNTL_UP
;	DW	OFFSET PGROUP:RESET1_UP

;	DB	ALT_DOWN
;	DW	OFFSET PGROUP:RESET2_DOWN
;	DB	ALT_UP
;	DW	OFFSET PGROUP:RESET2_UP

;	DB	DEL_DOWN
;	DW	OFFSET PGROUP:RESET3_DOWN
;	DB	DEL_UP
;	DW	OFFSET PGROUP:RESET3_UP

	DB	F7_DOWN
	DW	OFFSET PGROUP:MUSIC_DOWN
	DB	F7_UP
	DW	OFFSET PGROUP:MUSIC_UP

	DB	F9_DOWN
	DW	OFFSET PGROUP:SOUND_DOWN
	DB	F9_UP
	DW	OFFSET PGROUP:SOUND_UP

	DB	ESC_DOWN
	DW	OFFSET PGROUP:EXIT_DOWN


NUM_CHR	EQU	($-KB_TABLE)/3			; calculate number of entries

DATA	ENDS

	PAGE

;---------------------------------------
;
;	<<<<<  Program Area  >>>>>
;
;---------------------------------------


PGROUP	GROUP	PROG
PROG	SEGMENT	BYTE PUBLIC 'PROG'

	;PUBLIC	CHKJOY,
	PUBLIC KB_INIT, KB_RST, PEEK, POKE

	ASSUME	CS:PGROUP, DS:DGROUP, ES:DGROUP, SS:DGROUP


; -----  Variable used to store value of DS so interrupt handler can retrieve

CSDATA	PROC	NEAR

DATASEG	DW	?		; location to store value of data segment

CSDATA	ENDP

	
; ========== Joystick Read Routine ==========
;
; Calling format:
;
;       chkjoy()
;
; Description:
;
;       This module will read new values from the joystick adapter
;		JOYX = X value
;		JOYY = Y value
;		BUTT1 - Set to TRUE when button 1 is depressed
;		BUTT2 - Set to TRUE when button 2 is depressed
;


;CHKJOY	PROC	NEAR

;	PUSH	BP
;	MOV	BP,SP		; point to passed parameters

;	MOV	DX,201H		; Game adapter port number

; -----  read button status

;	MOV	BUTT1,FALSE	; Reset button status to false
;	MOV	BUTT2,FALSE
;	IN	AL,DX		; Read buttons
;	TEST	AL,10H		; Check button #1
;	JNZ	NBUT1
;	MOV	BUTT1,TRUE	; Button 1 is depressed
;NBUT1:	TEST	AL,20H		; Check button #2
;	JNZ	NBUT2
;	MOV	BUTT2,TRUE	; Button 2 is depressed

; -----  read joystick values

;NBUT2:	MOV	BX,0		; Reset X value
;	MOV	CX,0		; Reset Y value
;	MOV	AH,0		; Set AH for null addition

;	OUT	DX,AL		; Start timer pulse
;JOY1:	IN	AL,DX		; Get new status

;	RCR	AL,1		; Get X status into carry
;	ADC	BL,AH	
;	RCR	AL,1		; Get Y status into carry
;	ADC	CL,AH
;	RCR	AL,1
;	INC	CH		; Check for time out
;	JNZ	JOY1
	
;JOYDON:	MOV	CH,0		; Reset CH after use as a timer
;	MOV	JOYX,BX		; Save X value
;	MOV	JOYY,CX		; Save Y value

;	POP	BP		; restore BP
;	RET

;CHKJOY	ENDP

;	PAGE

; <<<<<<<<<<  Keyboard Interrupt Initialization  >>>>>>>>>>
;
; Command Format:
;
;       kb_init();
;
; Description:
;
;       This routine will change the keyboard interrupt vector to point to
;       a machine language routine located in this graphics library which
;       contains its own keyboard handeller.


KB_INIT	PROC	NEAR

	MOV	AX,DS
	MOV	DATASEG,AX		; store DS value in location DATASEG

	PUSH	DS

	MOV	AX,0
	MOV	DS,AX			; set DS to dos seg
	MOV	DI,24H			; location of keybrd interrupt
	MOV	AX,[DI]			; get old interrupt address
	MOV	BX,[DI]+2		; get old interrupt segment
	MOV	CX,OFFSET PGROUP:KEYINT	; get address of routine
	MOV	DX,CS			; get code segment

	CLI				; disable interrupts

	MOV	[DI],CX			; store address
	MOV	[DI+2],DX		; store code seg
                                        
	STI				; enable interrupts

	POP	DS

	MOV	KB_ADR,AX		; store interrupt address
	MOV	KB_SEG,BX		; store interrupt segment

	if HYP
	assume	ds:romdata
	push	ds
	mov	ax,40h
	mov	ds,ax
	mov	screen,0
	pop	ds
	assume	ds:dgroup
	endif

	RET

KB_INIT	ENDP



; <<<<<<<<<<  Keyboard Restore Routine  >>>>>>>>>>
;
; Calling Format:
;
;       kb_rst();
;
; Description:
;
;       This routine will restore the original keyboard interrupt address.


KB_RST	PROC	NEAR

	MOV	AX,KB_ADR		; get old interrupt address
	MOV	BX,KB_SEG		; get old interrupt segment
	MOV	DI,24H			; location of keyboard interrupt

	PUSH	DS			; save data segment
	MOV	CX,0
	MOV	DS,CX			; set DS to DOS segment

	CLI				; disable interrupts

	MOV	[DI],AX			; store address
	MOV	[DI+2],BX		; store segment

	STI				; enable interrupts

	POP	DS
	RET

KB_RST	ENDP

	


; <<<<<<<<<<  Keyboard Interrupt Handler  >>>>>>>>>>
;
; Description:
;
;       When a key is pressed on the keyboard, an interrupt will be
;       generated to this routine. This routine will then handle
;       the generation of an interrupt acknowledge and store the
;       character typed in KEYCHR.


KEYINT	PROC	FAR

;	STI				; allow further interrupts

	PUSH	AX
	PUSH	CX
	PUSH	SI
	PUSH	DS			; save registers

	CLD				; forward direction

	MOV	AX,DATASEG
	MOV	DS,AX			; set DS to data seg

	if IBM
	IN	AL,KB_DATA		; read in the character
	PUSH	AX			; save character
	IN	AL,KB_CNTL		; read control port
	MOV	AH,AL			; save value
	OR	AL,80H			; reset bit for keyboard
	OUT	KB_CNTL,AL
	XCHG	AH,AL			; get back original control
	OUT	KB_CNTL,AL		; keyboard has been reset
	POP	AX			; get back character pressed
	endif
	if HYP
	IN	AL,KB_DATA		; read in the character
	NOT	AL
	PUSH	AX			; save character
	MOV	AL,80H			; reset bit for keyboard
	OUT	KB_CNTL,AL
	POP	AX			; get back character pressed
	endif

	MOV	KEYCHR,AL		; store character

	CALL	KB_DCD			; keyboard decode routine

	CLI				; turn off interrupts
	MOV	AL,20H
	OUT	20H,AL			; send end of interrupt to 8259

	POP	DS
	POP	SI
	POP	CX
	POP	AX			; restore registers

	IRET				; return from interrupt

KEYINT	ENDP




; ==========  Keyboard Decode Routine  ==========
;
; On Entry:
;
;       KEYCHR = key that has been pressed
;
; Description:
;
;       This routine will decode the key pressed and if valid, will call
;	the proper keyboard handeller routine.


KB_DCD	PROC	NEAR

	MOV	SI,OFFSET DGROUP:KB_TABLE	; point to table
	MOV	AL,KEYCHR			; get key pressed
	MOV	CX,NUM_CHR			; load number of characters

; ----- loop until character found in table or end of table

KD1:	CMP	AL,[SI]			; compare character to table
	JE	KD2			; jump if the same
	ADD	SI,3			; point to next character
	LOOP	KD1			; loop if not all characters checked

	RET				; character doesn't match table entrys

; ----- jump to the address stored in the table

KD2:	INC	SI			; point to address
	JMP	WORD PTR [SI]		; jump to address pointed to by SI

KB_DCD	ENDP

	PAGE

; ==========  Key Press Handler  ==========
;
; Description:
;
;       The routines in this procedure are called when a valid key has been
;       pressed and the appropiate action will take place. Also, when
;       control-left arrow or control-right arrow has been pressed, the
;       screen will shift left or right if the display is the color card.
;
;       The following PUBLIC variables are used:
;
;	PDIR	-     0	= stop
;		      1	= left   ( left arrow )
;		      2 = right  ( right arrow )
;
;	LDIR	-     1	= left   ( left arrow has been pressed )
;		      2 = right  ( right arrow has been pressed )
;
;	KEYDIR	- player direction -  0 - right
;				      1 - right-up
;				      2 - up
;				      3 - left-up
;				      4 - left
;				      5 - left-down
;				      6 - down
;				      7 - right-down
;				     -1 - none pressed
;
;	LKDIR	- last direction pressed
;
;	FIRE	- TRUE	= key is down  ( F1 )
;		  FALSE	= key is up
;
;	FIRES	- TRUE  = key has been pressed  ( F1 ) - program must reset variable
;
;	SOUND	- TRUE	= enable sound  ( F10 )
;		  FALSE = disable sound
;
;	ENDGAME	- TRUE	= Esc has been pressed



KEY_PRS	PROC	NEAR

; ----- left arrow key down

LEFT_DOWN:

	MOV	L_KEY,TRUE		; set left key flag
	MOV	KEYDIR,DIRL		; Show present key is left
	MOV	LKDIR,DIRL		; Show that the last key pressed was left
	MOV	PDIR,LEFT		; set direction variable to left
	MOV	LDIR,LEFT		; set last direction variable to left
	CALL	SCREEN_ADJ		; call screen adjust program
	RET

; ----- left arrow key up

LEFT_UP:

	MOV	L_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRL
	JNZ	KSP1
	CALL	KEYCHK
KSP1:	CMP	PDIR,LEFT
	JE	KP1			; jump if left arrow key is down
	RET				; return in it is not

KP1:	CMP	R_KEY,TRUE
	JNE	KP2			; jump if right key not down
	MOV	PDIR,RIGHT		; else set PDIR to right
	RET

KP2:	MOV	PDIR,STOP		; indicate key has been released
	RET				; by setting PDIR to stop

; ----- right arrow key down

RIGHT_DOWN:

	MOV	R_KEY,TRUE		; set left key flag
	MOV	KEYDIR,DIRR		; Show present key is right
	MOV	LKDIR,DIRR		; Show that the last key pressed was right
	MOV	PDIR,RIGHT		; set direction variable to right
	MOV	LDIR,RIGHT		; set last direction variable to right
	CALL	SCREEN_ADJ		; call screen adjust routine
	RET

; ----- right arrow key up

RIGHT_UP:

	MOV	R_KEY,FALSE		; set right key flag
	CMP	KEYDIR,DIRR
	JNZ	KSP2
	CALL	KEYCHK
KSP2:	CMP	PDIR,RIGHT
	JE	KP3			; jump if right arrow key is down
	RET

KP3:	CMP	L_KEY,TRUE
	JNE	KP4			; jump if left key not down
	MOV	PDIR,LEFT		; else set PDIR to left
	RET

KP4:	MOV	PDIR,STOP		; set direction to stop
	RET

; ----- up arrow key down

UP_DOWN:

	MOV	U_KEY,TRUE		; set left key flag
	MOV	KEYDIR,DIRU		; Show present key is left
	MOV	LKDIR,DIRU		; Show that the last key pressed was left
	RET

; ----- up arrow key up

UP_UP:

	MOV	U_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRU
	JNZ	KSP3
	CALL	KEYCHK
KSP3:	RET				; return in it is not

; ----- down arrow key down

DOWN_DOWN:

	MOV	D_KEY,TRUE		; set key flag
	MOV	KEYDIR,DIRD		; Show present key
	MOV	LKDIR,DIRD		; Show that the last key pressed 
	RET

; ----- down arrow key up

DOWN_UP:

	MOV	D_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRD
	JNZ	KSP4
	CALL	KEYCHK
KSP4:	RET				; return in it is not

; ----- up-right arrow key down

UPR_DOWN:

	MOV	UR_KEY,TRUE		; set key flag
	MOV	KEYDIR,DIRUR		; Show present key
	MOV	LKDIR,DIRUR		; Show that the last key pressed 
	RET

; ----- up-right arrow key up

UPR_UP:

	MOV	UR_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRUR
	JNZ	KSP5
	CALL	KEYCHK
KSP5:	RET				; return in it is not

; ----- up-left arrow key down

UPL_DOWN:

	MOV	UL_KEY,TRUE		; set key flag
	MOV	KEYDIR,DIRUL		; Show present key
	MOV	LKDIR,DIRUL		; Show that the last key pressed 
	RET

; ----- up-left arrow key up

UPL_UP:

	MOV	UL_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRUL
	JNZ	KSP6
	CALL	KEYCHK
KSP6:	RET				; return in it is not

; ----- down-right arrow key down

DOWNR_DOWN:

	MOV	DR_KEY,TRUE		; set key flag
	MOV	KEYDIR,DIRDR		; Show present key
	MOV	LKDIR,DIRDR		; Show that the last key pressed 
	RET

; ----- down-right arrow key up

DOWNR_UP:

	MOV	DR_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRDR
	JNZ	KSP7
	CALL	KEYCHK
KSP7:	RET				; return in it is not


; ----- down-left arrow key down

DOWNL_DOWN:

	MOV	DL_KEY,TRUE		; set key flag
	MOV	KEYDIR,DIRDL		; Show present key
	MOV	LKDIR,DIRDL		; Show that the last key pressed 
	RET

; ----- down-left arrow key up

DOWNL_UP:

	MOV	DL_KEY,FALSE		; set left key flag
	CMP	KEYDIR,DIRDL
	JNZ	KSP8
	CALL	KEYCHK
KSP8:	RET				; return in it is not

; ----- fire key down

FIRE_DOWN:

	MOV	FIRES,TRUE		; set fire key flag
	MOV	FIRE,TRUE		; set fire variable to true
	RET

; ----- fire key up

FIRE_UP:

	MOV	FIRE,FALSE		; set fire variable to false
	RET

; ----- control key down

;RESET1_DOWN:

;	MOV	RST1,TRUE		; indicate control key is down
;	RET

; ----- control key up

;RESET1_UP:

;	MOV	RST1,FALSE		; indicate control key up
;	RET

; ----- alternale key down

;RESET2_DOWN:

;	MOV	RST2,TRUE		; indicate alternate key down
;	RET

; ----- alternate key up

;RESET2_UP:

;	MOV	RST2,FALSE		; indicate alternate key up
;	RET

; ----- delete key down

;RESET3_DOWN:

;	MOV	RST3,TRUE		; indicate delete key down
;	JMP	CHECK_END		; check for end of game

; ----- delete key up

;RESET3_UP:

;	MOV	RST3,FALSE		; indicate delete key up
;	RET

; ----- F7 down

MUSIC_DOWN:

	CMP	MSC_UP,TRUE
	JE	MS1			; jump if F7 was not down before
	RET				; else return

MS1:	NOT	MUSIC			; change the state of MUSIC
	MOV	MSC_UP,FALSE		; indicate F7 was down
	RET

; ----- F7 up

MUSIC_UP:

	MOV	MSC_UP,TRUE		; indicate F7 was up
	RET

; ----- F9 down

SOUND_DOWN:

	CMP	SND_UP,TRUE
	JE	SD1			; jump if F9 was not down before
	RET				; else return

SD1:	NOT	SOUND			; change the state of SOUND
	MOV	SND_UP,FALSE		; indicate F9 was down
	RET

; ----- F9 up

SOUND_UP:

	MOV	SND_UP,TRUE		; indicate F9 was up
	RET
	
; ----- Esc down

EXIT_DOWN:

	MOV	ENDGAME,TRUE		; indicate Esc was down
	RET

KEY_PRS	ENDP




; ==========  Key Down Check  =========
;
; Description:
;
;	This routine checks if any of the 8 direction keys are still down
;	if a match is found, it is treated as a new key press
;

KEYCHK	PROC	NEAR

	MOV	KEYDIR,DIRNONE
	CMP	U_KEY,0
	JZ	CHK1		; Key is not pressed
	MOV	KEYDIR,DIRU
	MOV	LKDIR,DIRU
CHK1:	CMP	D_KEY,0
	JZ	CHK2		; Key is not pressed
	MOV	KEYDIR,DIRD
	MOV	LKDIR,DIRD
CHK2:	CMP	L_KEY,0
	JZ	CHK3		; Key is not pressed
	MOV	KEYDIR,DIRL
	MOV	LKDIR,DIRL
CHK3:	CMP	R_KEY,0
	JZ	CHK4		; Key is not pressed
	MOV	KEYDIR,DIRR
	MOV	LKDIR,DIRR
CHK4:	CMP	UR_KEY,0
	JZ	CHK5		; Key is not pressed
	MOV	KEYDIR,DIRUR
	MOV	LKDIR,DIRUR
CHK5:	CMP	UL_KEY,0
	JZ	CHK6		; Key is not pressed
	MOV	KEYDIR,DIRUL
	MOV	LKDIR,DIRUL
CHK6:	CMP	DR_KEY,0
	JZ	CHK7		; Key is not pressed
	MOV	KEYDIR,DIRDR
	MOV	LKDIR,DIRDR
CHK7:	CMP	DL_KEY,0
	JZ	CHK8		; Key is not pressed
	MOV	KEYDIR,DIRDL
	MOV	LKDIR,DIRDL
CHK8:	RET

KEYCHK	ENDP




; ==========  Game End Check  ==========
;
; Description:
;
;       This routine will check to see if the control-alternate-delete
;       keys are down. If they are, a reboot will occour.


CHECK_END	PROC	NEAR

	CMP	RST1,TRUE
	JE	BC1			; jump if control key is down
	RET				; else return

BC1:	CMP	RST2,TRUE
	JE	BC2			; jump if alternate key is down
	RET				; else return

BC2:	CMP	RST3,TRUE
	JE	BC3			; jump if delete key is down
	RET				; else return

	ASSUME	DS:ROMDATA

BC3:	MOV	AX,ROMDATA
	MOV	DS,AX			; set data seg to rom data segment

	MOV	RESET_FLAG,1234H	; signal keyboard reset
	JMP	FAR PTR REBOOT		; jump to warm boot routine

	ASSUME	DS:DGROUP

CHECK_END	ENDP



; ==========  Screen Adjust Routine  ==========
;
; Description:
;
;       This routine will determine if a control-left arrow or
;       control-right arrow is pressed. If they are and the display
;       is the color card, then the horizontal sync position will be
;       altered to cause the screen to move left or right.


SCREEN_ADJ	PROC	NEAR

;	CMP	RST1,TRUE
;	JE	SA2			; jump if control key is down
	RET				; else return

;SA2:	CMP	L_KEY,TRUE
;	JNE	SA3			; jump if left arrow key is not down
;	INC	SYNC_POS		; increment the sync position
;	CMP	SYNC_POS,SYNC_NORM+3	; check for limit
;	JNZ	SBB1
;	MOV	SYNC_POS,SYNC_NORM+2	; reset sync position
;SBB1:	PUSH	DX
;	MOV	DX,3D4H			; address of register select port
;	MOV	AL,2			; horizontal sync position register
;	OUT	DX,AL			; send to CRT controller ( 6845 )
;	MOV	AL,SYNC_POS		; get sync position
;	INC	DX			; point to data register of 6845
;	OUT	DX,AL			; send to 6845
;	POP	DX
;	RET

;SA3:	CMP	R_KEY,TRUE
;	JNE	SA4			; jump if right arrow key is not down
;	DEC	SYNC_POS		; decrement the sync position
;	CMP	SYNC_POS,SYNC_NORM-3	; check for limit
;	JNZ	SBB2
;	MOV	SYNC_POS,SYNC_NORM-2	; reset sync position
;SBB2:	PUSH	DX
;	MOV	DX,3D4H			; address of register select port
;	MOV	AL,2			; horizontal sync position register
;	OUT	DX,AL			; send to CRT controller ( 6845 )
;	MOV	AL,SYNC_POS		; get sync position
;	INC	DX			; point to data register of 6845
;	OUT	DX,AL			; send to 6845
;	POP	DX
;	RET

;SA4:	RET

SCREEN_ADJ	ENDP




; ==========  Peek Routine  ==========
;
; Command Format:
;
;       n=peek(addr);
;	int  addr;
;
; Description:
;
;       The value at location addr and segment defined
;       by defseg will returned.


PEEK	PROC	NEAR

	PUSH	BP
	MOV	BP,SP

	PUSH	DS

	MOV	SI,[BP]+4		; put address in BX
	MOV	CX,DEFSEG		; get data segment
	MOV	DS,CX			; and put in DS

	MOV	AL,[SI]			; get value into AX
	MOV	AH,0			; clear high byte

	POP	DS
	POP	BP
	RET

PEEK	ENDP



; ==========  Poke Routine  ==========
;
; Commamd format:
;
;       poke(addr,byte);
;       int	addr;
;	char	byte;
;
; Description:
;
;       The value byte will be placed in location addr
;       and segment defseg.


POKE	PROC	NEAR

	PUSH	BP
	MOV	BP,SP

	PUSH	DS

	MOV	DI,[BP]+4		; get address
	MOV	BX,[BP]+6		; get data byte
	MOV	CX,DEFSEG
	MOV	DS,CX			; set DS to proper segment

	MOV	[DI],BL			; write byte

	POP	DS
	POP	BP
	RET

POKE	ENDP

PROG	ENDS


TIMER	EQU	40H	; Interupt timer port
SPKRON	EQU	2	; Speaker enable bit
SPKROF	EQU	0FDh	; 
PORTB	EQU	61H	; Speaker control port



DGROUP	GROUP	DATA
DATA	SEGMENT	BYTE	PUBLIC	'DATA'
	ASSUME	DS:DGROUP

	PUBLIC	SN2ON, SOUND2, TICK, PER2

SN2ON	DW	0
SOUND2	DW	2000		; Duration of low part of cycle passed by C
LTICK	DW	0		; Internal 16 bit tick counter
TICK	DB	0		; Counter of ticks
PER2	DW	1
SN_ADR	DW	0		; Storage for old interrupt address
SN_SEG	DW	0		; Storage for old interrupt segment


DATA	ENDS




PGROUP	GROUP	PROG
PROG	SEGMENT	BYTE	PUBLIC	'PROG'
	ASSUME	CS:PGROUP, DS:DGROUP, ES:DGROUP

	PUBLIC	SN2_INIT, SN2_RST

	EXTRN	TIME:NEAR	; 'C' function to handle timer interupt 
	EXTRN	TDELAY:NEAR	; 'C' function to handle time delay 

ALTDAT	PROC	NEAR

DSEG2	DW	?		; location to store value of data segment

ALTDAT	ENDP

; ========================== Setup interupt vectors ====================
;
;
; Initialize interupt to go to this sound routine
; Disk motors must be turned off first as normal operation is terminated	
;

SN2_INIT	PROC	NEAR

	MOV	AX,DS
	MOV	CS:DSEG2,AX		; Save DS value 

	PUSH	DS

	MOV	AX,0
	MOV	DS,AX
	MOV	DI,20H			; location of timer interupt
	MOV	AX,[DI]			; get old interupt address
	MOV	BX,[DI]+2		; ger ols segment
	MOV	CX,OFFSET PGROUP:SNDINT	; get address of new sound timer routine
	MOV	DX,CS			; get segment
	
	CLI				; Disable interrups

	MOV	[DI],CX			; Store new address
	MOV	[DI+2],DX		; Store new segment
	MOV	DI,180H
	MOV	[DI],AX			; Store old timer interupt at INT 60H
	MOV	[DI+2],BX
	STI				; Enable interrupS

	POP	DS

	MOV	SN_ADR,AX		; Store old interrupt address
	MOV	SN_SEG,BX		; Store old segment

	RET

SN2_INIT	ENDP


; ========================== Reset interupt vectors ====================
;
;	To restore the bios tick routine the old interupt vectors are reinstalled
;

SN2_RST	PROC	NEAR

	MOV	AX,0FFFFH		; Normal interrupt frequency
	MOV	DX,TIMER
	OUT	DX,AL
	MOV	AL,AH			; Get high byte
	OUT	DX,AL

	MOV	AX,SN_ADR		; Get old interrupt address
	MOV	BX,SN_SEG		; Get old segment
	MOV	DI,20H			; location of timer interrupt

	PUSH	DS
	MOV	CX,0
	MOV	DS,CX			; Set DS to DOS segment

	CLI				; Disable interups

	MOV	[DI],AX			; Store address
	MOV	[DI+2],BX		; Store segment

	STI				; Enable interrups

	POP 	DS

	RET

SN2_RST	ENDP

; ======================== Timer Interupt Handler =======================
;
;	This interupt will do pulse & square wave speaker updating if SN2ON = TRUE
;
;	The tick counter will be updated as necessary
;


SNDINT	PROC	FAR

;	STI				; Allow further interrups

	PUSH	AX
	PUSH	CX
	PUSH	DX
	PUSH	DS			; Save registers
	PUSH	ES

	CLD				; Forward direction

	MOV	AX,CS:DSEG2		; Set DS to data segment
	MOV	DS,AX
	MOV	ES,AX

	CMP	SN2ON,0			; Check the flag for sound on
	JZ	CHECKT			; Skip sound updating

	CMP	SN2ON,1			; Check if using pulse mode 
	JZ	PULSE


; Do speaker maintenence for square wave
;

	MOV	DX,PORTB		; Speaker control port
	IN	AL,DX
	XOR	AL,SPKRON		; Toggle speaker
	OUT	DX,AL
	JMP	CHECKT			; Update tick counter




; Do speaker maintenence for pulse mode
;

PULSE:	MOV	CX,PER2

	MOV	DX,PORTB		; Speaker control port
	IN	AL,DX
	OR	AL,SPKRON		; Turn on speaker
	OUT	DX,AL
ENT1:	LOOP	ENT1
	AND	AL,SPKROF		; Turn off speaker
	OUT	DX,AL


CHECKT:	MOV	AX,SOUND2		; add counter increment for tick
	ADD	LTICK,AX
	JNC	NOTICK			; No tick cycle
	INC	TICK

	PUSH	DI			; Set up for call to 'C' routine
	PUSH	SI
	PUSH	DX
	PUSH	CX
	PUSH	BX
	PUSH	AX
	CALL	TIME
	INT	60H			; Do normal tick function & EOI signal
	CALL	TDELAY
	POP	AX
	POP	BX
	POP	CX
	POP	DX
	POP	SI
	POP	DI

	POP	ES
	POP	DS
	POP	DX
	POP	CX
	POP	AX

	IRET				; EOI issued by tick routine



NOTICK:	MOV	AL,20H
	OUT	20H,AL			; Send end of interrupt to 8259

	POP	ES
	POP	DS
	POP	DX
	POP	CX
	POP	AX

	IRET

SNDINT	ENDP


PROG	ENDS


	end	XCMAIN

