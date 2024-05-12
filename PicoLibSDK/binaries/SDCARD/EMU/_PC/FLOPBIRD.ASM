; Floppy Bird
; Copyright (c) 2014, Mihail Szabolcs
; Modification for Picopad: 2024 Miroslav Nemecek
; Floppy Bird is provided as-is under the MIT license
; https://github.com/icebreaker/floppybird

TGA_HEADER	EQU	18 + 1028	; original TGA header (with color map)
TGA_HEADER2	EQU	312h		; modified TGA header (with color map)
VIDMEW	 	EQU	320		; video memory width
VIDMEH		EQU	200		; video memory height
VIDMES		EQU	64000		; video memory size
VIDMEM		EQU	0A000h 		; video memory
GAMESHIFT	EQU	2		; game shift
BIRDW		EQU	32		; bird image width
BIRDH		EQU	24		; bird image height
BACKW		EQU	80		; background width
SPEEDUP		EQU	7		; bird speed up
SPEEDDN		EQU	2		; bird speed down
BACKCOL		EQU	3		; background color (blue sky)
GNDCOL		EQU	42h		; ground color (brown)
SCOREY		EQU	180		; score Y coordinate

		.186

Code	SEGMENT
	ASSUME	cs:Code,ds:Code
	org	100h

main:
	; initialize - set VGA videomode
	call	set_vga_mode		; Set VGA videomode
	call	randomize		; Initialize random number generator by system timer

	; prepare to play intro
main_start:
	call	new_highscore		; Check high score after end of the game, reset score
	call	center_bird		; Reset bird to demo position

	; reset screen offset
	mov	word ptr [screenoff],0	; reset screen offset
	xor	ax,ax
	call	shift_screen		; shift screen

	; base draw intro screen
	call	draw_background		; Draw background
	call	draw_logo		; Draw logo
	call	draw_highscore		; Draw high score

	; intro loop
main_intro:

	; update bird animation
	call	animate_bird		; Animate bird (shift bird frame)

	; redraw bird
	call	vsync			; Vertical synchronization
	call	clear_bird		; clear bird (draw sky background)
	call	draw_bird		; Draw bird

	; some short delay
	mov	dx,2
	call	sleep			; Sleep DX time ticks (* 55 ms)

	; interrupt intro with keyboard	
	call	kbhit			; Check keyboard -> AX (does not wait)
	test	ax,ax
	jz	main_intro		; no key, loop intro

	; Esc - end of game
	cmp	al,27			; escape
	je	main_reboot		; end of game

	; prepare to start new game - reset pipes and bird
	call	reset_pipes		; Reset pipes - shift out of screen on start of game
	call	randomize_pipes		; Randomize height of all pipes
	call	reset_bird		; Reset bird to game position

	; start sound
	mov	ax,4242
	mov	dx,1
	call	beep			; Play note AX with DX delay

	; redraw whole screen
	call	draw_background		; Draw background
	call	draw_pipes		; Draw all pipes
	call	push_bird		; push bird background
	call	draw_bird		; Draw bird
	call	draw_score		; Draw score

	; game loop
main_loop:

	; shift backghround
	add	word ptr [backoff],GAMESHIFT ; shift background offset
	cmp	word ptr [backoff],BACKW/2 ; check background offset
	jb	main_loop2		; no overflow
	sub	word ptr [backoff],BACKW/2/GAMESHIFT*GAMESHIFT ; shift background offset back
main_loop2:

	; redraw whole screen
	call	vsync			; Vertical synchronization
	call	pop_bird		; pop bird background
	call	clear_score		; clear score

	mov	ax,GAMESHIFT		; game shift
	call	shift_screen		; shift screen
	call	draw_backstrip		; draw strip of background
	call	push_bird		; push bird background
	call	draw_bird		; Draw bird
	call	draw_pipestrips		; Draw pipe strips
	call	draw_score		; Draw score

	; control bird
	call	update_bird		; Update and control bird
	jc	main_end		; bird collision, end of game

	; control pipes
	call	update_pipes		; Shift and update pipes
	call	collide_pipe		; Check collision with pipe, update current pipe
	jnc	main_loop		; continue main loop

	; end of game
main_end:

	; end sound
	mov	ax,6969
	mov	dx,4
	call	beep			; Play note AX with DX delay

	; delay
	mov	dx,15
	call	sleep			; Sleep DX time ticks (* 55 ms)

	; flush keyboard
main_flush:
	call	kbhit			; Check keyboard -> AX (does not wait)
	test	ax,ax
	jnz	main_flush		; flush key

	; restart game
	jmp	main_start

	; end of game
main_reboot:
	call	set_text_mode		; Set text videomode
	int	20h			; exit

; =================================
; Initialize random number generator by system timer
; PROTOTYPE	: void randomize(void)
; INPUT		: n/a
; RETURN	: n/a
; =================================

randomize:
	push	ax
	call	ticks			; Get number of time ticks -> AX (* 55 ms)
	mov	[seed],ax			; tickcount as seed
	pop	ax
	ret

; ================================
; Get random number -> AX
; PROTOTYPE	: void random(void)
; INPUT		: n/a
; RETURN	: random number in AX
; ================================

random:
	push	dx
	
	mov	ax,[seed]
	mov	dx,33333
	mul	dx				; multiply SEED with AX
	inc	ax
	mov	[seed],ax			; use AX as new seed
	xchg	ax,dx           

	pop	dx
	ret

; ==================================================
; Play note AX with DX delay
; PROTOTYPE	: void beep(short note, short delay)
; INPUT		: note in AX, delay in DX
; RETURN	: n/a
; ==================================================

beep:
	push	ax
	push	bx

	xchg	ax,bx		; BX <- note
	mov	al,0B6h
	out	43h,al		; prepare to setup speaker counter
	xchg	ax,bx		; AX <- note

	out	42h,al		; note LOW
	mov	al,ah
	out	42h,al		; note HIGH

	in	al,61h		; speaker port
	or	al,3		; enable output to speaker
	out	61h,al

	call	sleep		; Sleep DX time ticks (* 55 ms)

	in	al,61h		; speaker port
	and	al,0FCh		; disable output to speaker
	out	61h,al

	pop	bx
	pop	ax
	ret

; ==================================================
; Get number of time ticks -> AX (* 55 ms)
; PROTOTYPE	: void ticks(void)
; INPUT		: n/a
; RETURN	: tick count in AX (resolution =~ 55ms)
; ==================================================

ticks:
	push	cx
	push	dx

	mov	ah,0
	int	1ah
	xchg	ax,dx

	pop	dx
	pop	cx
	ret

; ============================================================
; Sleep DX time ticks (* 55 ms)
; PROTOTYPE	: void sleep(55 ms ticks)
; INPUT		: amount of ms to sleep in DX (resolution =~ 55ms)
; RETURN	: n/a
; ============================================================

sleep:
	push	ax
	push	dx

	call	ticks			; Get number of time ticks -> AX (* 55 ms)
	add	dx,ax			; end time -> DX

sleep_wait:
	call	ticks			; Get number of time ticks -> AX (* 55 ms)
	cmp	ax,dx
	jne	sleep_wait		; loop until we waited for ms amount

	pop	dx
	pop	ax
	ret

; =====================================
; Set text videomode
; PROTOTYPE	: void set_text_mode(void)
; INPUT		: n/a
; RETURN	: n/a
; =====================================

set_text_mode:
	push	ax

	mov	ax,3			; 80x25 @ 16 color mode
	int	10h			; call BIOS interrupt

	pop	ax
	ret	

; ==================================
; Check keyboard -> AX (does not wait)
; PROTOTYPE	: short kbhit(void)
; INPUT		: n/a
; RETURN	: returns key hit in AX
; ==================================

kbhit:
	mov	ah,1			; but do not block (async)
	int	16h			; call BIOS interrupt
	jz	kbhit_end		; if no keys hit jump to end

	mov	ax,0			; get key hit function
	int	16h			; call BIOS interrupt
	ret		

kbhit_end:
	xor	ax,ax			; set AX to 0 if no keys hit
	ret

; ==========================================
; Set VGA videomode
; PROTOTYPE	: void set_vga_mode(void)
; INPUT		: n/a
; RETURN	: n/a
; ==========================================

set_vga_mode:
	push	ax

	mov	ax,13h			; 320x200 @ 256 color mode
	int	10h			; call BIOS interrupt

	pop	ax
	ret

; ==========================================
; Vertical synchronization
; PROTOTYPE	: void vsync(void)
; INPUT		: n/a
; RETURN	: n/a
; ==========================================

vsync:
	push	ax
	push	dx

	mov	dx,3DAh			; port 0x3DA

vsync_l1:
	in	al,dx			; port
	test	al,8			; test bit 3
	jnz	vsync_l1		; retrace in progress?

vsync_l2:
	in	al,dx			; port
	test	al,8			; test bit 3
	jz	vsync_l2		; new retrace?
	
	pop	dx
	pop	ax
	ret

; =====================================================
; blit image with clipping
; PROTOTYPE	: void blit( unsigned char *pixels,
;				 short  w, short  h,
;				 short sx, short sy,
;				 short sw, short sh, 
;				 short dx, short dy, 
;				 unsigned char color,
;				 unsigned char tint )
; INPUT		: n/a
; RETURN	: n/a
; =====================================================
; [BP+24] ... pixels (pointer to image data)
; [BP+22] ... w (image width)
; [BP+20] ... h (image height)
; [BP+18] ... sx (source X)
; [BP+16] ... sy (source Y)
; [BP+14] ... sw (source width)
; [BP+12] ... sh (source height)
; [BP+10] ... dx (destination X)
; [BP+8] ... dy (destination Y)
; [BP+6] ... color (transparent color)
; [BP+4] ... tint (tint color to recolor image)
; [BP+2] ... return address
; [BP+0] ... old BP

blit:
	push	bp
	mov	bp,sp			; top of the stack
	
	pusha

	cmp	word ptr [bp+14],0	; sw is 0? (source width)
	je	blit_end2

	cmp	word ptr [bp+12], 0	; sh is 0? (source height)
	je	blit_end2

	cmp	word ptr [bp+10],VIDMEW	; dx out of bounds on right (destination X)
	jge	blit_end2		; full clip

	cmp	word ptr [bp+8],VIDMEH	; dy out of bounds on bottom (destination Y)
	jge	blit_end2		; full clip

	mov	ax,[bp+14]		;  sw (source width)
	neg	ax			; -sw

	cmp	word ptr [bp+10],ax	; dx out of bounds on left (check source width with destination X)
	jle	blit_end2		; full clip

	mov	bx,[bp+12]		; sh (source height)
	neg	bx			; -sh

	cmp	word ptr [bp+8],bx	; dy out of bounds on top (check source height with destination Y)
	jle	blit_end2		; full clip

	neg	ax			; revert sw (source width, back to positive)
	add	ax,[bp+10]		; add dx (source width + destination X = destination end X)

	neg	bx			; revert sh (source height, back to positive)
	add	bx,[bp+8]		; add dy (source height + destination Y = destination end Y)

	; check clip right
	cmp	ax,VIDMEW		; dx partially out of bounds on right (check end X if clipped on right)
	jge	blit_clipr		; try partial right clip

	; check clip bottom
	cmp	bx,VIDMEH		; dy partially ouf of bounds on bottom (check end Y if clipped on bottom)
	jge	blit_clipb		; try partial bottom clip

	; check clip left
	cmp	word ptr [bp+10],0	; dx partially out of bounds on left (check destination X)
	jge	blit_clipt		; quick exit if it's not the case ... not clipped left

	; clip left
blit_clipl:
	mov	ax,[bp+10]		; use the dx as an offset
	sub	[bp+18],ax		; offset sx to the right (increase source X by -DX)
	add	[bp+14],ax		; offset sw to the left  (decrease source width by -DX)
	mov	word ptr [bp+10],0	; reset dx
	jmp	blit_clipt		; go and blit the visible part

	; full clip, nothing to draw
blit_end2:
	jmp	blit_end

	; clip right
blit_clipr:
	sub	ax,VIDMEW		; figure out how much is left to display?
	sub	word ptr [bp+14],ax	; and adjust sw (decrease source width)

	; check clip bottom
	cmp	bx,VIDMEH		; dy partially ouf of bounds on bottom?
	jl	blit_noclip		; quick exit if it's not the case

	; clip bottom
blit_clipb:
	sub	bx,VIDMEH		; figure out how much is left to display?
	sub	word ptr [bp+12],bx	; and adjust sh (decrease source height)
	jmp	blit_noclip		; go and blit the visible part

	; check clip top
blit_clipt:
	cmp	word ptr [bp+8],0	; dy partially out of bounds on the top (check destination Y)
	jge	blit_noclip		; quick exit if it's not the case

	; clip top
	mov	bx,[bp+8]		; use the dy as an offset
	sub	[bp+16],bx		; offset sy to the top (increase source Y by -DY)
	add	[bp+12],bx		; offset sh to the bottom (decrease source height by -DY)
	mov	word ptr [bp+8],0	; reset dy

	; prepare to blit
blit_noclip:
	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; 

	mov	ax,VIDMEW		; screen width
	mov	dx,[bp+8]		; dy (destination Y)
	mul	dx			; dy * screen width

	mov	di,ax			; dy * screen width
	add	di,[bp+10]		; dx (destination X) -> DI destination address
	add	di,[screenoff]		; add screen offset

	mov	dx,VIDMEW		; screen width
	sub	dx,[bp+14]		; sw (source width)

	mov	[dxoffset],dx		; destination offset X ... remaining destination to skip each line

	mov	dx,[bp+22]		; w (image width)
	sub	dx,[bp+14]		; sw (source width)

	mov	[sxoffset],dx		; source offset X ... remaining source to skip each line

	mov	ax,[bp+22]		; w (image width)
	mov	dx,[bp+16]		; sy (source Y)
	mul	dx			; sy * w
	add	ax,[bp+18]		; sx + sy * w (source offset)

	mov	si,[bp+24]		; pointer to pixel buffer
	add	si,ax			; sx + sy * w -> SI source address

	xor	ax,ax			; clear AX
	xor	bx,bx			; clear BX
	xor	cx,cx			; clear CX
	xor	dx,dx			; clear DX

	; do blit
blit_loop:
	lodsb				; load [DS:SI] into AL

	cmp	al, byte ptr [bp+6]	; compare AL to transparent color
	je	blit_transparent	; skip this pixel if transparent

	add	al, byte ptr [bp+4]	; add tint color

	stosb				; store AL into [ES:DI]
	jmp	blit_next		; next pixel

blit_transparent:
	inc	di			; increment destination offset

blit_next:
	inc	bx			; increment width
	cmp	bx,[bp+14]		; sw check source width
	jl	blit_loop		; end of row?

	xor	bx,bx			; reset width
	add	di,[dxoffset]		; increment destination offset
	add	si,[sxoffset]		; increment source offset

	inc	cx			; increment height
	cmp	cx,[bp+12]		; sh check source height
	jl	blit_loop		; next row

blit_end:
	popa
	pop	bp
	ret	22			; 11 params * 2 bytes

; =====================================================
; blit image without clipping
; PROTOTYPE	: void blit_fast( unsigned char *pixels,
;				 short  w, short  h,
;				 short sx, short sy,
;				 short sw, short sh, 
;				 short dx, short dy, 
;				 unsigned char color,
;				 unsigned char tint )
; INPUT		: n/a
; RETURN	: n/a
; =====================================================
; [BP+24] ... pixels (pointer to image data)
; [BP+22] ... w (image width)
; [BP+20] ... h (image height)
; [BP+18] ... sx (source X)
; [BP+16] ... sy (source Y)
; [BP+14] ... sw (source width)
; [BP+12] ... sh (source height)
; [BP+10] ... dx (destination X)
; [BP+8] ... dy (destination Y)
; [BP+6] ... color (transparent color)
; [BP+4] ... tint (tint color to recolor image)
; [BP+2] ... return address
; [BP+0] ... old BP

blit_fast:
	push	bp
	mov	bp,sp			; top of the stack
	
	pusha

	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; ES <- destination segment

	mov	ax,VIDMEW		; screen width
	mov	dx,[bp+8]		; dy (destination Y)
	mul	dx			; dy * screen width

	mov	di,ax			; dy * screen width
	add	di,[bp+10]		; add dx (destination X)
	add	di,[screenoff]		; add screen offset

	mov	dx,VIDMEW		; screen width
	sub	dx,[bp+14]		; width - sw (source width)
	mov	[dxoffset2],dx		; destination offset X ... remaining destination to skip each line

	mov	dx,[bp+22]		; w (image width)
	sub	dx,[bp+14]		; w - sw
	mov	[sxoffset2],dx		; source offset X ... remaining source to skip each line

	mov	ax,[bp+22]		; w (image width)
	mov	dx,[bp+16]		; sy (source Y)
	mul	dx			; w * sy
	add	ax,[bp+18]		; sx + sy * w (source offset)

	mov	si,[bp+24]		; pointer to pixel buffer src
	add	si,ax			; src + sx + sy * w (source address)

	xor	ax, ax			; clear AX
	xor	bx, bx			; clear BX
	xor	cx, cx			; clear CX
	xor	dx, dx			; clear DX

blit_fast_loop:
	lodsb				; load [DS:SI] into AL

	cmp	al,byte ptr [bp+6]	; compare AL to transparent color
	je	blit_fast_transparent	; skip this pixel if transparent

	add	al, byte ptr [bp+4]	; add tint color
	stosb				; store AL into [ES:DI]
	jmp	blit_fast_next		; next pixel

blit_fast_transparent:
	inc	di			; increment destination offset

blit_fast_next:
	inc	bx			; increment width
	cmp	bx,[bp+14]		; sw
	jl	blit_fast_loop		; end of row?

	xor	bx, bx			; reset width
	add	di,[dxoffset2]		; increment destination offset
	add	si,[sxoffset2]		; increment source offset

	inc	cx			; increment height
	cmp	cx,[bp+12]		; sh 
	jl	blit_fast_loop		; next row

blit_fast_end:
	popa

	pop	bp
	ret	22			; 11 params * 2 bytes

; ==========================================
; Draw strip of background
; ==========================================

draw_backstrip:
	pusha
	push	es

	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; ES <- screen buffer

	mov	bx,VIDMEH		; number of lines
	mov	si,offset back + TGA_HEADER2 + BACKW/2 - GAMESHIFT ; background image
	add	si,[backoff]		; shift background

	mov	di,[screenoff]		; screen offset
	add	di,VIDMEW - GAMESHIFT	; destination address

draw_backstrip2:
	mov	cx,GAMESHIFT		; width of shift
	rep	movsb			; copy one line
	add	si,BACKW - GAMESHIFT	; shift source
	add	di,VIDMEW - GAMESHIFT	; shift destination
	dec	bx			; line counter
	jnz	draw_backstrip2		; draw nextline

	pop	es
	popa
	ret

; ==========================================
; Draw background
; ==========================================

draw_background:
	pusha
	push	es

	mov	word ptr [backoff],0	; reset background offset

	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; ES <- screen buffer

	mov	bx,VIDMEH		; number of lines
	mov	si,offset back + TGA_HEADER2
	mov	di,[screenoff]		; screen offset
draw_back2:
	mov	dx,4			; number of segments
draw_back4:
	mov	cx,BACKW/2		; width of one segment
	rep	movsw			; copy one line of one segment
	sub	si,BACKW		; restore source
	dec	dx			; segment counter
	jnz	draw_back4		; draw next segment

	add	si,BACKW		; shift source to next line
	dec	bx			; line counter
	jnz	draw_back2		; draw nextline

	pop	es
	popa
	ret

; ==========================================
; Draw rectangle
; PROTOTYPE	: void blit_rect(short x, short y
;					 short w, short h,
;					 unsigned char color)
; INPUT		: n/a
; RETURN	: n/a
; ==========================================
; [BP+12] ... x (destination X)
; [BP+10] ... y (destination Y)
; [BP+8] ... w (rectangle width)
; [BP+6] ... h (rectangle height)
; [BP+4] ... color
; [BP+2] ... return address
; [BP+0] ... old BP

draw_rect:
	push	bp
	mov	bp,sp			; top of the stack

	pusha

	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; 

	mov	ax,VIDMEW		; screen width
	mov	dx,[bp+10]		; y (destination Y)
	mul	dx

	mov	di,ax			; y * screen width
	add	di,[bp+12]		; x (destination X) -> DI destination address
	add	di,[screenoff]		; add screen offset

	mov	dx,VIDMEW		; screen width
	sub	dx,[bp+8]		; - width -> DX increment of next line

	mov	bx,[bp+6]		; height

	xor	ah,ah
	mov	al, byte ptr [bp+4]	; color

draw_rect_loop:
	mov	cx,[bp+8]		; width
	rep	stosb			; draw one row

	add	di,dx			; next row

	dec	bx			; height
	jnz	draw_rect_loop		; continue to next line

	popa

	pop	bp
	ret	10			; 5 params * 2 bytes

; ==========================================
; Reset bird to game position
; ==========================================

reset_bird:
	mov	word ptr [bird_pos_x],60	; bird position x
	mov	word ptr [bird_pos_y],60	; bird position y
	ret

; ==========================================
; Reset bird to demo position
; ==========================================

center_bird:
	mov	word ptr [bird_pos_x],144	; bird position x
	mov	word ptr [bird_pos_y],60	; bird position y
	ret

; ==========================================
; Update and control bird
; ==========================================

update_bird:
	push	ax

	; check bird collision with sky
	mov	ax, word ptr [bird_pos_y] ; sy (source Y, bird position y)
	cmp	ax,0			; top, check minimal Y coordinate
	jle	bird_collide		; reached sky?

	; check bird collision with ground
	add	ax,BIRDH		; sh (add bird height)
	cmp	ax,156			; bottom (ground), check maximal Y coordinate
	jg	bird_collide		; reached ground?

	; control bird
	call	kbhit			; check keyboard -> AX (does not wait)
	test	ax,ax			; no key was ...
	jz	bird_fall		; pressed then just fall ...

	; press key, raise bird
	call	animate_bird		; animate bird (shift bird frame)
	sub	word ptr [bird_pos_y],SPEEDUP+SPEEDDN ; move some pixels up on the Y axis

	; no key, fall bird
bird_fall:
	add	word ptr [bird_pos_y],SPEEDDN  ; move some pixels down on the Y axis
	pop	ax
	clc
	ret

	; bird collision with sky or ground
bird_collide:
	pop	ax
	stc
	ret

; ==========================================
; Animate bird (shift bird frame)
; ==========================================

animate_bird:
	add	word ptr [bird_frm],BIRDW	; advance fly animation by one frame
	cmp	word ptr [bird_frm],64		; did we reach the last frame yet?
	jle	bird_end			; if not, then we can jump right away
	mov	word ptr [bird_frm],0		; reset animation to the first frame
bird_end:
	ret

; ==========================================
; Draw logo
; ==========================================

draw_logo:
	push	offset logo + TGA_HEADER2	; logo image
	push	162				; pw (image width)
	push	32				; ph (image height)
	push	0				; sx (source X)
	push	0				; sy (source Y)
	push	162				; sw (source width)
	push	32				; sh (source height)
	push	79				; dx (destination X)
	push	10				; dy (destination Y)
	push	0				; transparent color
	push	0				; tint
	call	blit_fast			; blit image without clipping
	ret

; ==========================================
; Push bird background
; ==========================================

push_bird:
	pusha
	push	ds

	push	ds
	pop	es			; ES <- data segment
	mov	di,offset bird_buf	; DI <- destination buffer

	mov	ax,word ptr [bird_pos_y] ; bird position y
	mov	dx,VIDMEW		; width of display -> DX
	mul	dx			; AX <- width*y
	mov	bx,word ptr [bird_pos_x] ; bird position x
	add	ax,bx			; add bird position x
	add	ax,[screenoff]		; add screen offset
	mov	[bird_old],ax		; save old position
	xchg	ax,si			; SI <- address in video memory

	mov	ax,VIDMEM		; pointer to screen buffer
	mov	ds,ax			; DS <- screen buffer

	mov	bx,BIRDH		; BX <- bird height

push_bird2:
	mov	cx,BIRDW/2		; CX <- bird width / 2
	rep	movsw			; copy one line
	add	si,VIDMEW - BIRDW	; shift source address
	dec	bx			; line counter
	jnz	push_bird2		; next line

	pop	ds
	popa
	ret

; ==========================================
; Pop bird background
; ==========================================

pop_bird:
	pusha
	push	es

	mov	si,offset bird_buf	; SI <- source buffer
	mov	di,[bird_old]		; DI <- address in video memory
	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; ES <- screen buffer

	mov	bx,BIRDH		; BX <- bird height

pop_bird2:
	mov	cx,BIRDW/2		; CX <- bird width / 2
	rep	movsw			; copy one line
	add	di,VIDMEW - BIRDW	; shift destination address
	dec	bx			; line counter
	jnz	pop_bird2		; next line

	pop	es
	popa
	ret

; ==========================================
; Clear bird (draw sky background)
; ==========================================

clear_bird:
	push	word ptr [bird_pos_x]		; dx (destination X; bird position x)
	push	word ptr [bird_pos_y]		; dy (destination Y; bird position y)
	push	BIRDW				; sw (source width; bird position: x, y, w, h)
	push	BIRDH				; sh (source height; bird position: x, y, w, h)
	push	BACKCOL				; background color
	call	draw_rect			; draw rectangle
	ret

; ==========================================
; Draw bird
; ==========================================

draw_bird:
	push	offset bird + TGA_HEADER	; bird image
	push	3*BIRDW				; pw (image width)
	push	BIRDH				; ph (image height)
	push	word ptr [bird_frm]		; sx (bird frame; source X)
	push	0				; sy (source Y)
	push	BIRDW				; sw (source width)
	push	BIRDH				; sh (source height)
	push	word ptr [bird_pos_x]		; dx (destination X; bird position x)
	push	word ptr [bird_pos_y]		; dy (destination Y; bird position y)
	push	0				; transparent color
	push	0				; tint
	call	blit_fast			; blit image without clipping
	ret

; ==========================================
; Shift screen by AX
; ==========================================

shift_screen:
	push	ax
	push	bx
	push	dx

	; shift offset
	add	word ptr [screenoff],ax	; shift screen offset

	; set new offset HIGH
	mov	dx,3d4h
	mov	al,12
	out	dx,al			; select register 12 (memory offset HIGH)

	mov	bx,[screenoff]
	inc	dx
	mov	al,bh
	out	dx,al			; setup offset HIGH

	; set new offset LOW
	dec	dx
	mov	al,13
	out	dx,al			; select register 13 (memory offset LOW)

	inc	dx
	xchg	ax,bx			; BX <- required shift
	out	dx,al			; setup offset LOW

	pop	dx
	pop	bx
	pop	ax
	ret

; ==========================================
; Shift and update pipes
; ==========================================

update_pipes:
	push	ax

	; shift X coordinates of the pipes
	sub	word ptr [PIPE_1],GAMESHIFT	; shift X coordinate of pipe 1
	sub	word ptr [PIPE_2],GAMESHIFT	; shift X coordinate of pipe 2
	sub	word ptr [PIPE_3],GAMESHIFT	; shift X coordinate of pipe 3

	; update pipe 1
pipes_n1:
	cmp	word ptr [PIPE_1],-36		; check X coordinate of pipe 1
	jg	pipes_n2			; pipe 1 is not out of display

	call	random_pipe_position		; Randomize X position of pipe 1
	add	ax,word ptr [PIPE_3]		; + X coordinate of pipe 3
	mov	word ptr [PIPE_1],ax		; set X coordinate of pipe 1
	call	randomize_pipe_1		; Randomize height of pipe 1

	; update pipe 2
pipes_n2:
	cmp	word ptr [PIPE_2],-36		; check X coordinate of pipe 2
	jg	pipes_n3			; pipe 2 is not out of display

	call	random_pipe_position		; Randomize X position of pipe 2
	add	ax,word ptr [PIPE_1]		; + X coordinate of pipe 1
	mov	word ptr [PIPE_2],ax		; set X coordinate of pipe 2
	call	randomize_pipe_2		; Randomize height of pipe 2

pipes_n3:
	cmp	word ptr [PIPE_3],-36		; check X coordinate of pipe 3
	jg	pipes_end			; pipe 3 is not out of display

	call	random_pipe_position		; Randomize X position of pipe 3
	add	ax,word ptr [PIPE_2]		; + X coordinate of pipe 2
	mov	word ptr [PIPE_3],ax		; set X coordinate of pipe 3
	call	randomize_pipe_3		; Randomize height of pipe 3

pipes_end:
	pop	ax
	ret

; ==========================================
; Check collision with pipe, update current pipe
; ==========================================

collide_pipe:
	push	ax
	push	si

	; get descriptor of current pipe -> SI
	mov	si,offset pipes		; SI <- descriptors of pipes
	add	si,[pipe_a]		; offset of current pipe

	; check minimal X coordinate of the pipe
	cmp	word ptr [si],92	; check minimal X coordinate
	jg	collide_end		; pipe is whole on the right

	; check maximal X coordinate of the pipe
	cmp	word ptr [si],28	; check maximal X coordinate
	jl	collide_score		; pipe is whole on the left

	; check collision with top pipe
	mov	ax,word ptr [bird_pos_y] ; AX <- bird Y position
	cmp	ax,word ptr [si + 2]	; check with height of top pipe
	jl	collide_hit		; collision with top pipe

	add	ax,BIRDH		; add bird height (bird position: x, y, w, h)
	cmp	ax, word ptr [si + 4]	; check with Y coordinate of bottom pipe
	jle	collide_end		; no collision with bottom pipe

	; collision
collide_hit:
	pop	si
	pop	ax
	stc
	ret

	; no collision, pipe is behind the bird
collide_score:
	call	add_score		; Increase score

	; shift current pipe to next pipe
	cmp	word ptr [pipe_a],16		; offset of current pipe = pipe 3 ?
	je	collide_wrap			; pipe 3, reset to pipe 1
	add	word ptr [pipe_a],8		; shift offset of current pipe
	jmp	short collide_end

	; reset current pipe to pipe 1
collide_wrap:
	mov	word ptr [pipe_a],0		; offset of current pipe - reset to pipe 1

	; OK, no collision
collide_end:
	pop	si
	pop	ax
	clc
	ret

; ==========================================
; Draw pipe strips
; ==========================================

draw_pipestrips:

	; draw top pipe 1
	push	word ptr [PIPE_1 + 0]	; pipe_1 X
	push	0			; pipe_1 top Y
	push	word ptr [PIPE_1 + 2]	; pipe_1 top height
	call	draw_pipestrip		; Draw one pipe draw_pipestrip(short x, short y, short h)

	; draw bottom pipe 1
	push	word ptr [PIPE_1 + 0]	; pipe_1 X
	push	word ptr [PIPE_1 + 4]	; pipe_1 bottom Y
	push	word ptr [PIPE_1 + 6]	; pipe_1 bottom height
	call	draw_pipestrip		; Draw one pipe draw_pipestrip(short x, short y, short h)

	; draw top pipe 2
	push	word ptr [PIPE_2 + 0]	; pipe_2 X
	push	0			; pipe_2 top Y
	push	word ptr [PIPE_2 + 2]	; pipe_2 top height
	call	draw_pipestrip		; Draw one pipe draw_pipestrip(short x, short y, short h)

	; draw bottom pipe 2
	push	word ptr [PIPE_2 + 0]	; pipe_2 X
	push	word ptr [PIPE_2 + 4]	; pipe_2 bottom Y
	push	word ptr [PIPE_2 + 6]	; pipe_2 bottom height
	call	draw_pipestrip		; Draw one pipe draw_pipestrip(short x, short y, short h)

	; draw top pipe 3
	push	word ptr [PIPE_3 + 0]	; pipe_3 X
	push	0			; pipe_3 top Y
	push	word ptr [PIPE_3 + 2]	; pipe_3 top height
	call	draw_pipestrip		; Draw one pipe draw_pipestrip(short x, short y, short h)

	; draw bottom pipe 3
	push	word ptr [PIPE_3 + 0]	; pipe_3 X
	push	word ptr [PIPE_3 + 4]	; pipe_3 bottom Y
	push	word ptr [PIPE_3 + 6]	; pipe_3 bottom height
	call	draw_pipestrip		; Draw one pipe draw_pipestrip(short x, short y, short h)

	ret

; ==========================================
; Draw one pipe strip
;   void draw_pipestrip(short x, short y, short h)
; ==========================================
; [BP+8] ... destination X coordinate
; [BP+6] ... destination Y coordinate
; [BP+4] ... height of the pipe
; [BP+2] ... return address
; [BP+0] ... old BP

draw_pipestrip:
	push	bp
	mov	bp, sp
	
	pusha

	; fast check X coordinate
	mov	ax,[bp+8]		; DI <- x, destination X
	cmp	ax,VIDMEW		; check max. X
	jge	pipestrip_body2		; X is on the right
	cmp	ax,VIDMEW - GAMESHIFT - 32 ; check min. X
	jle	pipestrip_body2		; X is on the left

	mov	cx,word ptr [bp+4]	; pipe height
	shr	cx,1			; pipe height / 2

	mov	ax,word ptr [bp+6]	; Y coordinate
	xor	dx,dx

	; draw pipe strip body, CX = height/2, AX = destination Y coordinate, [bp+8] = destination X coordinate
pipestrip_body:
	push	offset pipe + TGA_HEADER ; pipe image
	push	32		; w (image width)
	push	2		; h (image height)
	push	word ptr [bp+8]	; dx (destination X)
	push	ax		; dy (destination Y)
	call	strip		; draw image strip with clipping

	add	ax,2		; shift Y coordinate
	dec	cx		; height counter
	jnz	pipestrip_body	; draw next

pipestrip_body2:

	mov	ax,[bp+6]	; AX <- pipe Y coordinate
	cmp	ax,0		; top pipe?
	jne	pipestrip_top2	; Y coordinate is not 0, it means bottom pipe

	mov	ax,[bp+4]	; top pipe: height of pipe -> AX
	sub	ax,4		;

	; draw pipe strip top, AX = destination Y coordinate, [bp+8] = destination X coordinate
pipestrip_top2:
	mov	dx,[bp+8]	; DX <- destination X
	sub	dx,2		; X correction

	push	offset pipe_top + TGA_HEADER ; pipe top image
	push	36		; w (image width)
	push	4		; h (image height)
	push	dx		; dx (destination X)
	push	ax		; dy (destination Y)
	call	strip		; blit image strip with clipping

	popa

	pop	bp
	ret	6		; 3 param * 2 bytes

; =====================================================
; draw image strip with horizontal clipping
; PROTOTYPE	: void strip( unsigned char *pixels,
;				 short  w, short  h,
;				 short dx, short dy )
; INPUT		: n/a
; RETURN	: n/a
; =====================================================
; [BP+12] ... pixels (pointer to image data)
; [BP+10] ... w (image width)
; [BP+8] ... h (image height)
; [BP+6] ... dx (destination X)
; [BP+4] ... dy (destination Y)
; [BP+2] ... return address
; [BP+0] ... old BP

strip:
	push	bp
	mov	bp,sp			; top of the stack
	
	pusha

	; prepare destination X (-> DI), width W (-> BX), source X (-> SI)
	mov	di,[bp+6]		; DI <- dx, destination X
	mov	bx,[bp+10]		; BX <- w, width
	xor	si,si			; SI <- 0, source X

	; check X on the left
	mov	ax,VIDMEW - GAMESHIFT	; minimal X
	sub	ax,di			; distance to destination X
	jle	strip2			; X is not clipping

	; clip X on the left
	add	di,ax			; DI <- clipped destination X
	sub	bx,ax			; BX <- clipped width W
	xchg	ax,si			; SI <- clipped source X

	; limit width
strip2:	mov	ax,VIDMEW		; maximal X
	sub	ax,di			; distance to destination X
	cmp	ax,bx			; check width W
	jge	strip3			; width is OK
	xchg	ax,bx			; BX <- limit width

	; check width
strip3:	or	bx,bx			; check width
	jle	strip_end		; invalid width

	; destination segment -> ES
	mov	ax,VIDMEM		; pointer to screen buffer
	mov	es,ax			; ES <- screen buffer

	; destination offset -> DI
	mov	ax,VIDMEW		; screen width
	mov	dx,[bp+4]		; DX <- destination Y
	mul	dx			; AX <- dy * screen_width
	add	ax,[screenoff]		; add screen offset
	add	di,ax			; DI <- destination address

	; source offset -> SI	
	add	si,[bp+12]		; SI <- source address

	; increment of source address -> DX
	mov	dx,[bp+10]		; DX <- image width
	sub	dx,bx			; DX <- source skip

	; increment of destination address -> AX
	mov	ax,VIDMEW		; AX <- screen width
	sub	ax,bx			; AX <- destination skip

	; line counter -> BP
	mov	bp,[bp+8]		; BP <- image height
	
	; copy image
strip4:	mov	cx,bx			; CX <- width
	rep	movsb			; copy image
	add	si,dx			; shift source
	add	di,ax			; shift destination
	dec	bp			; line counter
	jnz	strip4			; next line

	; end
strip_end:
	popa
	pop	bp
	ret	10			; 5 params * 2 bytes

; ==========================================
; Draw all pipes
; ==========================================

draw_pipes:
	; draw top pipe 1
	push	word ptr [PIPE_1 + 0]	; pipe_1 X
	push	0			; pipe_1 top Y
	push	word ptr [PIPE_1 + 2]	; pipe_1 top height
	call	draw_pipe		; Draw one pipe draw_pipe(short x, short y, short h)

	; draw bottom pipe 1
	push	word ptr [PIPE_1 + 0]	; pipe_1 X
	push	word ptr [PIPE_1 + 4]	; pipe_1 bottom Y
	push	word ptr [PIPE_1 + 6]	; pipe_1 bottom height
	call	draw_pipe		; Draw one pipe draw_pipe(short x, short y, short h)

	; draw top pipe 2
	push	word ptr [PIPE_2 + 0]	; pipe_2 X
	push	0			; pipe_2 top Y
	push	word ptr [PIPE_2 + 2]	; pipe_2 top height
	call	draw_pipe		; Draw one pipe draw_pipe(short x, short y, short h)

	; draw bottom pipe 2
	push	word ptr [PIPE_2 + 0]	; pipe_2 X
	push	word ptr [PIPE_2 + 4]	; pipe_2 bottom Y
	push	word ptr [PIPE_2 + 6]	; pipe_2 bottom height
	call	draw_pipe		; Draw one pipe draw_pipe(short x, short y, short h)

	; draw top pipe 3
	push	word ptr [PIPE_3 + 0]	; pipe_3 X
	push	0			; pipe_3 top Y
	push	word ptr [PIPE_3 + 2]	; pipe_3 top height
	call	draw_pipe		; Draw one pipe draw_pipe(short x, short y, short h)

	; draw bottom pipe 3
	push	word ptr [PIPE_3 + 0]	; pipe_3 X
	push	word ptr [PIPE_3 + 4]	; pipe_3 bottom Y
	push	word ptr [PIPE_3 + 6]	; pipe_3 bottom height
	call	draw_pipe		; Draw one pipe draw_pipe(short x, short y, short h)

	ret

; ==========================================
; Draw one pipe
;   void draw_pipe(short x, short y, short h)
; ==========================================
; [BP+8] ... destination X coordinate
; [BP+6] ... destination Y coordinate
; [BP+4] ... height of the pipe
; [BP+2] ... return address
; [BP+0] ... old BP

draw_pipe:
	push	bp
	mov	bp, sp
	
	pusha

	mov	cx,word ptr [bp+4]	; pipe height
	shr	cx,1			; CX <- pipe height / 2

	mov	ax,word ptr [bp+6]	; Y coordinate
	xor	dx,dx

	; draw pipe body, CX = height/2, AX = destination Y coordinate, [bp+8] = destination X coordinate
pipe_body:
	push	offset pipe + TGA_HEADER ; pipe image
	push	32		; w (image width)
	push	2		; h (image height)
	push	0		; sx (source X)
	push	0		; sy (source Y)
	push	32		; sw (source width)
	push	2		; sh (source height)
	push	word ptr [bp+8]	; dx (destination X)
	push	ax		; dy (destination Y)
	push	0		; trasnsparent color
	push	0		; tint
	call	blit		; blit image with clipping

	add	ax,2		; shift Y coordinate
	dec	cx		; height counter
	jnz	pipe_body	; draw next

	mov	ax,[bp+6]	; AX <- pipe Y coordinate
	cmp	ax,0		; top pipe?
	jne	pipe_top2	; Y coordinate is not 0, it means bottom pipe

	mov	ax,[bp+4]	; top pipe: height of pipe -> AX
	sub	ax,4		;

	; draw pipe top, AX = destination Y coordinate, [bp+8] = destination X coordinate
pipe_top2:
	mov	dx,[bp+8]	; DX <- destination X
	sub	dx,2		; X correction

	push	offset pipe_top + TGA_HEADER ; pipe top image
	push	36		; w (image width)
	push	4		; h (image height)
	push	0		; sx (source X)
	push	0		; sy (source Y)
	push	36		; sw (source width)
	push	4		; sh (source height)
	push	dx		; dx (destination X)
	push	ax		; dy (destination Y)
	push	0		; transparent color
	push	0		; tint
	call	blit		; blit image with clipping

	popa

	pop	bp
	ret	6		; 3 param * 2 bytes

; ==========================================
; Randomize height of all pipes
; ==========================================

randomize_pipes:
	push	si
	mov	si, offset pipes

pipe_loop:
	push	si
	call	randomize_pipe		; Randomize one pipe

	add	si,8
	cmp	si, offset pipes + 24
	jl	pipe_loop

	pop	si
	ret

; ==========================================
; Randomize height of pipe 1
; ==========================================

randomize_pipe_1:
	push	offset PIPE_1
	call	randomize_pipe		; Randomize one pipe
	ret

; ==========================================
; Randomize height of pipe 2
; ==========================================

randomize_pipe_2:
	push	offset PIPE_2
	call	randomize_pipe		; Randomize one pipe
	ret

; ==========================================
; Randomize height of pipe 3
; ==========================================

randomize_pipe_3:
	push	offset PIPE_3
	call	randomize_pipe		; Randomize one pipe
	ret

; ==========================================
; Randomize height of one pipe -> AX (even number 20..40)
; ==========================================

randomize_pipe_height:
	push	bx
	push	cx
	push	dx

randomize_pipe_height2:
	call	random		; get random number -> AX
	and	ax,3fh		; limit random number to range 0..63
	
	cmp	ax,42		; check max. height
	jge	randomize_pipe_height2 ; invalid, new randomize

	cmp	ax,18		; check min. height
	jle	randomize_pipe_height2 ; invalid, new randomize

	mov	cx,ax		; CX <- save random height
	mov	bx,2		; BX <- 2
	xor	dx,dx		; DX:AX <- random height
	div	bx		; random height / 2

	cmp	dx,0		; check if height is even number
	jne	randomize_pipe_height2 ; height is odd, new randomize

	xchg	ax,cx		; AX <- generated height

	pop	dx
	pop	cx
	pop	bx
	ret

; ==========================================
; Randomize height of one pipe
;  void randomize_pipe(short* pipe)
; ==========================================
; [BP+4] ... pointer to pipe descriptor
; [BP+2] ... return address
; [BP+0] ... old BP

randomize_pipe:
	push	bp
	mov	bp, sp

	pusha

	call	randomize_pipe_height	; Randomize height of one pipe -> AX (even number 20..40)

	mov	bx,78			; BX <- max. pipe height
	sub	bx,ax			; BX <- random height 38..58
	mov	si,[bp + 4]		; SI <- pipe descriptor
	mov	word ptr [si + 2],bx	; top height 38..58

	call	randomize_pipe_height	; Randomize height of one pipe -> AX (even number 20..40)

; pipe area is in range Y = 0..155

	mov	bx,78			; BX <- max. pipe height
	sub	bx,ax			; BX <- random height 38..58
	mov	word ptr [si + 6],bx	; bottom height 38..58
	add	ax,78			; AX <- bottom pipe Y coordinate
	mov	word ptr [si + 4],ax	; bottom Y is 98..118

	popa

	pop	bp
	ret	2		; 1 params * 2 bytes

; ==========================================
; Randomize X position of one pipe -> AX (101..219)
; ==========================================

random_pipe_position:
	call	random		; get random number -> AX
	mov	ah,0		; limit number to range 0..255
	
	cmp	ax,100		; minimal position
	jle	random_pipe_position ; invalid, repeat randomize

	cmp	ax,220		; maximal position
	jge	random_pipe_position ; invalid, repeat randomize
	
	ret

; ==========================================
; Reset pipes - shift out of screen on start of game
; ==========================================

reset_pipes:
	mov	word ptr [PIPE_1],120	; X of pipe_1 = 120
	mov	word ptr [PIPE_2],260	; X of pipe_2 = 260
	mov	word ptr [PIPE_3],400	; X of pipe_3 = 120
	mov	word ptr [pipe_a],0	; reset offset of current pipe
	ret

; ==========================================
; Increase score
; ==========================================

add_score:
	add	word ptr [score],50
	ret

; ==========================================
; Check high score after end of the game, reset score
; ==========================================

new_highscore:
	push	ax

	mov	ax, word ptr [score]	; current score
	cmp	ax, word ptr [highscore] ; high score
	jle	score_reset		; not higher
	mov	word ptr [highscore],ax ; new high score
score_reset:
	mov	word ptr [score],0	; reset current score

	pop	ax
	ret

; ==========================================
; Clear score
; ==========================================

clear_score:
	push	word ptr [numx]		; score start X position
	push	SCOREY			; score Y coordinate
	push	word ptr [numw]		; score width
	push	8			; score height
	push	GNDCOL			; rectangle color
	call	draw_rect		; clear score
	ret

; ==========================================
; Draw score
; ==========================================

draw_score:
	push	word ptr [score]	; current score
	call	draw_number		; Draw number
	ret

; ==========================================
; Draw high score
; ==========================================

draw_highscore:
	push	word ptr [highscore]	; high score
	call	draw_number		; Draw number
	ret

; ==========================================
; Draw number
;   void draw_number(short num);
; ==========================================
; [BP+4] ... number to display
; [BP+2] ... return address
; [BP+0] ... old BP

draw_number:
	push	bp
	mov	bp, sp

	pusha

	mov	ax,[bp+4]	; AX <- number to display
	mov	bx,10		; BX <- 10, divider
	xor	cx,cx		; CX <- 0, digit counter

	; prepare digits
score_loop:
	xor	dx,dx		; DX <- 0 (AX = number to decode)
	div	bx		; AX / 10 -> AX, AX % 10 -> DX
	inc	cx		; increase digit counter CX

	push	dx		; push digits in DX
	test	ax,ax		; check zero result
	jnz	score_loop	; decode next digit

	; prepare start X position
	mov	ax,8		; number of pixels per digit
	mul	cx		; number of digits CX * 8 -> number width
	mov	[numw],ax	; score width

	mov	bx,VIDMEW	; width of display -> BX
	sub	bx,ax		; BX <- rest of width

	mov	ax,bx		; AX <- rest of width
	xor	dx,dx		; DX <- 0
	mov	bx,2
	div	bx		; AX <- rest of width / 2 (to center number)

	mov	bx,ax		; BX <- start X position
	mov	[numx],ax	; score start X position

	; display digits
score_blit:
	pop	dx		; pop out the next digit (in reverse order)
	mov	ax,8		; AX <- number of pixels per digit
	mul	dx		; DX:AX <- offset of the digit in the image

	push	offset font + TGA_HEADER ; font image
	push	80		; pw (image width)
	push	8		; ph (image height)
	push	ax		; sx (source X)
	push	0		; sy (source Y)
	push	8		; sw (source width)
	push	8		; sh (source height)
	push	bx		; dx (destination X)
	push	SCOREY		; dy (destination Y)
	push	0		; transparent color
	push	0		; tint color
	call	blit_fast	; blit image without clipping

	add	bx,8		; shift X position (8 pixels)
	dec	cx		; digit counter
	jnz	score_blit	; display next digit

	popa
	pop	bp
	ret	2		; 1 params * 2 bytes

	include FLOPBIRD.INC

	EVEN
score		dw	0		; current score
highscore	dw	0		; high score
seed		dw	13666		; default random seed
sxoffset	dw	0		; source X offset
dxoffset	dw	0		; destination X offset
sxoffset2	dw	0		; source X offset
dxoffset2	dw	0		; destination X offset
bird_pos_x	dw	60		; bird position X
bird_pos_y	dw	60		; bird position Y
bird_frm	dw	0		; current animation frame (source X in pixels, one image is 32 pixels width)
screenoff	dw	0		; screen offset
backoff		dw	0		; background offset
numx		dw	0		; score start X position
numw		dw	0		; score width

pipes label word			; pipes X
PIPE_1		dw	120, 32, 64, 32	; pipe 1 (X, top height, bottom Y, bottom height)
PIPE_2		dw	260, 78, 78, 78	; pipe 2 (X, top height, bottom Y, bottom height)
PIPE_3		dw	400, 78, 78, 78	; pipe 3 (X, top height, bottom Y, bottom height)
pipe_a		dw	0 		; active pipe offset [0, 8, 16]

bird_old	dw	0		; bird old position
bird_buf	db	BIRDW*BIRDH dup(?)	; bird back buffer

Code     ENDS

         END       main
