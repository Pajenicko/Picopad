; Alphabet
; (c) 1993-2024 Miroslav Nemecek

; The image on end of this file was created by screen capture with
; GDemo program (to *.SCR file) and then exported to ASM format with BinS.

Code     SEGMENT
         ASSUME    cs:Code,ds:Code
         ORG       100h

; ------ check EGA/VGA graphics card

Start:   mov       ah,12h
         mov       bx,9a10h
         call      Int10
         cmp       bh,1
         ja        Start1
         cmp       bl,4
         jbe       Start2

; ------ error - not EGA/VGA card

Start1:  mov       dx,offset CardTxt
         mov       ah,9
         int       21h
         int       20h

; ------ initialize videomode 0x10 (640*350/16 colors)

Start2:  mov       ax,10h
         call      Int10
         mov       ah,0fh
         call      Int10			; get current videomode
         cmp       al,10h
         jne       Start1			; error - videomode not set

; ------ prepare to display image

         cld
         mov       si,offset Obrazek+16		; start of data to display
         mov       ax,0a000h
         mov       es,ax			; ES <- videomemory segment
         mov       bh,1				; write plane

; ------ setup color plane

Start3:  mov       dx,3c4h
         mov       al,2				; register to select write plane
         out       dx,al
         inc       dx
         mov       al,bh
         out       dx,al			; select write plane

; ------ display one plane

         mov       cx,80*350/2			; number of words to display
         xor       di,di
Start4:  call      ReadByte			; read 1st byte
         mov       ah,al
         call      ReadByte			; read 2nd byte
         xchg      ah,al
         stosw					; write 2 bytes
         loop      Start4			; another pair of bytes

; ------ preapre for next write plane

         shl       bh,1				; increase index of plane
         cmp       bh,10h
         jne       Start3			; write next plane

; ------ display cursor character

Start5:  mov       ax,0fh*256 + "_"
         call      DispChr

; ------ intput from keyboard

         mov       ah,0
         int       16h
         or        ax,ax
         jz        Start6
         cmp       al,27
         jne       Start7

; ------ end of program ESC - return videomode, quit the program

Start6:  mov       ax,3
         int       10h				; return text videomode
         int       20h

; ------ switch off cursor

Start7:  push      ax
         mov       ax,720h
         call      DispChr			; clear cursor
         pop       ax

; ------ return 1 position back

Start71: cmp       ax,4b00h
         je        Start72			; left arrow
         cmp       al,8
         je        Start72			; BackSpace
         cmp       ax,5300h			; Delete
         jne       Start74
Start72: cmp       byte ptr ds:[Pozice],0	; begin of row?
         je        Start5
         dec       byte ptr ds:[Pozice]		; decrease position
Start55: jmp       short Start5			; next character

; ------ position right

Start74: cmp       ax,4d00h			; right arrow
         jne       Start75
         mov       al," "

; ------ row up

Start75: cmp       ax,4800h			; up arrow
         jne       Start8
         cmp       byte ptr ds:[Radek],19	; check minimal row
         je        Start55
         dec       byte ptr ds:[Radek]		; decrease row
         jmp       short Start55

; ------ row down

Start8:  cmp       ax,5000h			; down arrow
         je        Start93

; ------ new row ENTER

         cmp       al,0dh
         je        Start92			; increase row number

; ------ display valid character

         cmp       al,0
         je        Start55			; ignore control character
         mov       ah,12			; character color
         call      DispChr			; display character

; ------ increase position on row

         inc       byte ptr ds:[Pozice]		; increase position
         cmp       byte ptr ds:[Pozice],80	; end of row?
         jne       Start55

; ------ increase row number

Start92: mov       byte ptr ds:[Pozice],0	; position = 0
Start93: inc       byte ptr ds:[Radek]		; increase row
         cmp       byte ptr ds:[Radek],25	; last row reached?
         jne       Start55

; ------ overflow end - scroll screen

         mov       byte ptr ds:[Radek],24	; limit row number
         mov       ax,601h			; number of rows = 1
         mov       bh,0				; color attribute
         mov       cx,19*256			; left top edge
         mov       dx,24*256+79			; right bottom edge
         call      Int10			; scroll screen up
         jmp       short Start55		; new key

; -----------------------------------------------------------------------------
;             Display character AL with color AH (without control)
; -----------------------------------------------------------------------------

DispChr  PROC      NEAR

; ------ push registers

         push      ax
         push      bx
         push      cx
         push      dx

; ------ set cursor position

         push      ax
         mov       dx,ds:[PozRad]		; row and column
         mov       ah,2
         mov       bh,0				; page number
         call      Int10			; set cursor position
         pop       ax

; ------ display character on cursor position

         mov       bl,ah			; character color
         mov       bh,0				; page
         mov       ah,9
         mov       cx,1				; number of characters to write
         call      Int10			; display character

; ------ pop registers

         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

DispChr  ENDP

; -----------------------------------------------------------------------------
;                  INT 10h service, with save registers
; -----------------------------------------------------------------------------

Int10    PROC      NEAR

         pushf
         push      si
         push      di
         push      bp
         push      es
         push      ds

         int       10h

         pop       ds
         pop       es
         pop       bp
         pop       di
         pop       si
         popf
         ret

Int10    ENDP

; -----------------------------------------------------------------------------
;                 read byte from image in compress mode
; -----------------------------------------------------------------------------

ReadByte PROC      NEAR

; ------ read byte with number of compressed bytes

         cmp       byte ptr ds:[KompCit],0	; is counter valid?
         jne       ReadByt4
ReadByt1:lodsb 					; load next counter byte
         mov       byte ptr ds:[KompCit],al	; number of following bytes

; ------ switch of compression mode

         or        al,al			; switch?
         jnz       ReadByt2			; not switch
         xor       byte ptr ds:[KompPar],1	; flip compression flag
         jmp       short ReadByt1		; next byte

; ------ get byte to repeat

ReadByt2:and       byte ptr ds:[KompPar],not 2	; clear compression flag
         test      byte ptr ds:[KompPar],1	; compression mode?
         jz        ReadByt3			; not compression
         or        byte ptr ds:[KompPar],2	; compression flag
         lodsb 					; get byte to repeat
         mov       ds:[KompChar],al		; byte to repeat

; ------ switch compression flag

ReadByt3:cmp       byte ptr ds:[KompCit],255	; change compression mode?
         je        ReadByt4			; not change
         xor       byte ptr ds:[KompPar],1	; flip compression flag

; ------ get next byte

ReadByt4:mov       al,ds:[KompChar]		; repeated byte
         test      byte ptr ds:[KompPar],2	; repeated data?
         jnz       ReadByt5			; repeated data
         lodsb					; load not-repeated byte

; ------ decrease byte counter

ReadByt5:dec       byte ptr ds:[KompCit]	; decrease byte counter
         ret

ReadByte ENDP

; -----------------------------------------------------------------------------
;        data
; -----------------------------------------------------------------------------

PozRad   label     word				; row and position
Pozice   db        0				; current position
Radek    db        19				; current row

KompCit  db        0				; counter of equal bytes [BP-2]
KompChar db        0				; byte to repeat [BP-3]
KompPar  db        1				; compression flag [BP-4]

CardTxt  db        'Sorry, program requires EGA or VGA graphics card !',13,10,'$'

; The image was created by screen capture with GDemo program (to *.SCR file)
; and then exported to ASM format with BinS.

Obrazek  label     byte				; image to display
	include	ALPHABET.INC

Code     ENDS
         END       Start
