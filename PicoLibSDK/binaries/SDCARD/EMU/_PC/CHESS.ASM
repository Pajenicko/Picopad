
; =============================================================================
;
;                                    Chess
;
; =============================================================================

Code     SEGMENT
         ASSUME    cs:Code,ds:Code
         ORG       100h

; ------ initialize videomode

Start:   mov       ah,0fh
         call      Int10P		; get videomode
         cmp       al,7
         je        Start1
         mov       byte ptr ds:[SegmVRAM+1],0b8h ; segment videomemory
         cmp       al,2
         je        Start1
         mov       al,3
Start1:  mov       ah,0
         call      Int10P		; initialize videomode

; ------ instal INT 23h

Start103:mov       ax,2523h
         mov       dx,offset INT23
         int       21h

; ------ display intro text

         mov       ds:[Zasobnik],sp	; save stack pointer
Zadej:   mov       sp,ds:[Zasobnik]	; restore stack pointer
         call      Clear		; clear screen
         mov       si,offset Text1
         mov       dx,6*256 + 34
         call      DispB
         mov       dx,9*256 + 35
         call      DispB
         mov       dx,11*256 + 30
         call      DispB
         mov       dx,13*256 + 34
         call      DispB

; ------ prepare player's color

Zadej1:  mov       sp,ds:[Zasobnik]	; restore stack pointer
         mov       al,"A"		; automat
         cmp       byte ptr ds:[Automat],0 ; automat ?
         jne       Zadej2		; automat
         mov       al,"W"		; white
         cmp       byte ptr ds:[Hrac],0 ; is player white ?
         jne       Zadej2		; player has white
         mov       al,"B"		; black
Zadej2:  mov       ds:[ColTxt0],al	; player color
         mov       ds:[ColTxt1],al	; player color

; ------ enter player's color

         mov       si,offset ColTxt	; choose color
         mov       dx,16*256 + 11
         call      DispB
         dec       dx

; ------ input from keyboard

Zadej3:  call      SetKurz
         call      InpChr		; input from keyboard

	cmp	bh,4bh ; left
	jne	Zadej32
	mov	bx,'W'

Zadej32:cmp	bh,4dh ; right
	jne	Zadej33
	mov	bx,'B'

Zadej33:cmp	bh,48h ; up
	jne	Zadej34
	mov	bx,'A'
Zadej34:

         call      JumpBX		; jump to key

         dw        "W",ZadejB		; white
         dw        "B",ZadejC		; black
         dw        "A",ZadejA		; automat
         dw        13,ZadejM		; ENTER
         dw        27,Konec		; ESC

         dw        0,Zadej3

; ------ quit program ESC

Konec:   mov       ah,0fh
         int       10h
         mov       ah,0
         int       10h
         int       20h			; quit program

; ------ select automat

ZadejA:  mov       byte ptr ds:[Automat],1 ; automat flag
         mov       al,0			; player has black
         jmp       short ZadejC3

; ------ select white

ZadejB:  mov       al,80h		; player is white
         jmp       short ZadejC2

; ------ select black

ZadejC:  mov       al,0			; player is black
ZadejC2: mov       byte ptr ds:[Automat],0 ; clear automat flag
ZadejC3: mov       ds:[Hrac],al		; set player's color

; ------ select with ENTER (DX=old cursor position)

ZadejM0: mov       ds:[ColTxt1],bl	; entered character
ZadejM:  mov       si,offset ColTxt1
         call      DispB		; display text

; ------ prepare to select level

;         mov       al,ds:[Uroven]	; current level
;         add       al,"0"
;         mov       ds:[UrovTxt0],al

; ------ display prompt to select level

;         mov       si,offset UrovTxt	; text to select level
;         mov       dx,18*256+10
;         call      DispB
;         dec       dx

; ------ input key from keyboard

;ZadejU1: call      SetKurz		; set cursor position
;         call      InpChr		; input character from keyboard
;         cmp       bl,13		; ENTER?
;         je        ZadejU5
;         cmp       bl,27		; ESC
;         jne       ZadejU2
;         jmp       Zadej		; go to select color
;ZadejU2: sub       bl,"0"
;         jbe       ZadejU1		; invalid character
;         cmp       bl,6
;         ja        ZadejU1
;         mov       ds:[Uroven],bl	; select level

; ------ initialize chessboard

ZadejU5: call      Clear		; clear screen
         call      InitPole		; initialize chessboard
         call      Disp			; display chessboard
         mov       word ptr ds:[CitTah],1 ; turn counter
         mov       byte ptr ds:[Radek],1 ; current row on display
         call      KurzOff		; switch cursor off

; ------ select game type

Hrej:    call      DispTah		; display turn number
         test      byte ptr ds:[Hrac],80h ; is player white?
         jnz       Hrej1		; player is white - begins

				;* computer has white - begins
         call      TahPoc		; computer turn
         call      TahHrac		; select player turn
         jmp       short Hrej2
				;* player has white - begins
Hrej1:   call      TahHrac		; select player turn
         call      TahPoc		; computer turn

				;* increase turn counter
Hrej2:   inc       word ptr ds:[CitTah]	; increase turn counter
         jmp       short Hrej		; next turn

; -----------------------------------------------------------------------------
;        INT 23h service
; -----------------------------------------------------------------------------

INT23:   iret

; -----------------------------------------------------------------------------
;        display ASCIIZ text - BIOS (DX=coordinates, DS:SI=text)
; -----------------------------------------------------------------------------

DispB    PROC      NEAR

; ------ load next character

         mov       ah,7			; text color
DispB2:  cld
         lodsb
         cmp       al,0			; end?
         je        DispB8		; end of text

; ------ control characters

         cmp       al,1
         jne       DispB3
         xor       ah,8
         jmp       short DispB2
DispB3:  cmp       al,2
         jne       DispB4
         xor       ah,77h
         jmp       short DispB2

; ------ display character

DispB4:  call      DispCh
         inc       dl
         jmp       short DispB2

DispB8:  ret

DispB    ENDP

; -----------------------------------------------------------------------------
;        display character AX (coordinates DX)
; -----------------------------------------------------------------------------

DispCh   PROC      NEAR

; ------ push registers

         push      ax
         push      di
         push      es

; ------ get address in videomemory

         push      ax
         mov       al,160
         mul       dh
         mov       di,ax
         mov       al,dl
         mov       ah,0
         add       di,ax
         add       di,ax
         pop       ax

; ------ write character

         mov       es,ds:[SegmVRAM]
         cld
         stosw

; ------ pop registers

         pop       es
         pop       di
         pop       ax
         ret

DispCh   ENDP

; -----------------------------------------------------------------------------
;        display turn
; -----------------------------------------------------------------------------

DispMov  PROC      NEAR

         mov       dh,ds:[Radek]		; row

         mov       dl,5				; position
         mov       al,ds:[OldPoz]
         call      DispMv			; display square

         mov       dl,8				; position
         mov       al,"-"
         call      DispChar

         mov       al,ds:[NewPoz]
         mov       dl,10
         call      DispMv

         mov       dl,12
         mov       al," "
         call      DispChar

         mov       dl,13
         mov       al,"X"
         test      byte ptr ds:[OldFig],7fh
         jnz       DispMov3
         mov       al," "
DispMov3:call      DispChar

         mov       dl,15
         mov       al,ds:[Rosad]
         mov       si,offset MalRosTx
         cmp       al,1
         je        DispMov4
         mov       si,offset VelRosTx
         cmp       al,2
         je        DispMov4
         mov       si,offset PxPepTx
         cmp       al,3
         jne       DispMov6
DispMov4:cld
         lodsb
         cmp       al,0
         je        DispMov6
         call      DispChar
         inc       dx
         jmp       short DispMov4
DispMov6:
         ret

DispMov  ENDP

; -----------------------------------------------------------------------------
;        display square AL
; -----------------------------------------------------------------------------

DispMv   PROC      NEAR

; ------ calculate row and position

         mov       cl,10
         mov       ah,0
         div       cl

; ------ display position

         xchg      al,ah
         add       al,"a"-1
         call      DispChar

; ------ display row

         inc       dx
         xchg      al,ah
         add       al,"1"-2
         call      DispChar
         ret

DispMv   ENDP

; -----------------------------------------------------------------------------
;        display turn number
; -----------------------------------------------------------------------------

DispTah  PROC      NEAR

; ------ push registers

         push      ax
         push      cx
         push      dx

; ------ clear row

         mov       dh,ds:[Radek]		; current row
         call      DispClr			; clear row

; ------ display separating colon

         mov       dl,3
         mov       al,":"
         call      DispChar
         dec       dx

; ------ decode number

         mov       cx,10
         mov       ax,ds:[CitTah]		; turn number
DispTah1:push      dx
         xor       dx,dx
         div       cx
         xchg      bx,ax
         xchg      ax,dx
         pop       dx
         add       al,"0"
         call      DispChar			; display character
         xchg      ax,bx
         dec       dx
         or        ax,ax
         jnz       DispTah1

; ------ pop registers

         pop       dx
         pop       cx
         pop       ax
         ret

DispTah  ENDP

; -----------------------------------------------------------------------------
;        new line
; -----------------------------------------------------------------------------

DispCR   PROC      NEAR

; ------ push registers

         push      cx
         push      dx
         push      si
         push      di
         push      es

; ------ increase row

         inc       byte ptr ds:[Radek]
         cmp       byte ptr ds:[Radek],25
         jb        DispCR9
         dec       byte ptr ds:[Radek]

; ------ scroll screen

         cld
         push      ds
         mov       es,ds:[SegmVRAM]
         push      es
         pop       ds
         mov       di,160-20*2 + 160
         mov       dx,23			; number of rows
DispCR2: mov       cx,20
         mov       si,di
         add       si,160
         rep       movsw
         add       di,160-20*2
         dec       dx
         jnz       DispCR2
         pop       ds

; ------ clear new row

DispCR9: mov       dh,ds:[Radek]
         call      DispClr

; ------ pop registers

         pop       es
         pop       di
         pop       si
         pop       dx
         pop       cx
         ret

DispCR   ENDP

; -----------------------------------------------------------------------------
;        output character AL to output (coordinates DX)
; -----------------------------------------------------------------------------

DispChar PROC      NEAR

; ------ push registers

         push      ax
         push      di
         push      es

; ------ prepare address

         push      ax
         mov       al,160
         mul       dh
         mov       di,ax
         mov       al,dl
         add       al,80-20
         mov       ah,0
         add       di,ax
         add       di,ax
         pop       ax

; ------ store character

         mov       es,ds:[SegmVRAM]
         cld
         mov       ah,7
         cmp       dl,4
         jb        DispChr2
         mov       ah,0fh
DispChr2:stosw

; ------ pop registers

         pop       es
         pop       di
         pop       ax
         ret

DispChar ENDP

; -----------------------------------------------------------------------------
;        clear row DH
; -----------------------------------------------------------------------------

DispClr  PROC      NEAR

         push      ax
         push      dx
         mov       al,32
         mov       dl,0
DispClr1:call      DispChar
         inc       dx
         cmp       dl,20
         jb        DispClr1
         pop       dx
         pop       ax
         ret

DispClr  ENDP

; -----------------------------------------------------------------------------
;        display text DS:SI centered (1st byte = length)
; -----------------------------------------------------------------------------

DispHlas PROC      NEAR

; ------ push registers

         push      ax
         push      cx
         push      si
         push      di
         push      es

; ------ prepare registers

         cld
         mov       es,ds:[SegmVRAM]
         lodsb				; text length
         mov       bl,al
         mov       cx,20		; row
         sub       cl,bl
         shr       cl,1			; borders / 2
         mov       bh,cl		; right border
         adc       bh,0

; ------ display left space

         mov       di,160-2*20
         mov       ax,7020h
         rep       stosw

; ------ display text

         mov       cl,bl
DispHls1:lodsb
         stosw
         loop      DispHls1

; ------ display right space

         mov       cl,bh
         mov       al," "
         rep       stosw

; ------ pop registers

         pop       es
         pop       di
         pop       si
         pop       cx
         pop       ax
         ret

DispHlas ENDP

;==========================================================================
;        store new definition to turn stack
;==========================================================================
  
l_0000   PROC      NEAR

         mov       dx,ds:[d_09CC]		; pointer to turn stack
         mov       bx,offset d_09AA		; end of turn stack
         cmp       dx,bx			; is stack full?
         jae       l_0046			; stack is full

         mov       bx,ds:[d_09CA]
         mov       ds:[d_09CA],dx
         mov       ds:[bx],dx
         test      byte ptr ds:[FigTst1],8
         jnz       l_0022
         or        byte ptr ds:[CilFig1],10h

l_0022:  mov       bx,dx			; pointer to turn stack
         mov       word ptr ds:[bx],0		; points of turn
         mov       al,ds:[d_09B2]
         mov       ds:[bx+2],al
         mov       al,ds:[PozTah]		; turn position
         mov       ds:[bx+3],al
         mov       al,ds:[CilFig1]		; old content of the square
         mov       ds:[bx+4],al
         mov       byte ptr ds:[bx+5],0
         add       bx,6				; increase pointer to the stack
         mov       ds:[d_09CC],bx		; new pointer to turn stack
         ret

l_0046:  mov       word ptr ds:[bx],0		; no points
         ret

l_0000   ENDP
  
;==========================================================================
;        store turn definition
;==========================================================================
  
l_004C   PROC      NEAR

         xor       byte ptr ds:[Protihr],80h
         jns       l_0057
         dec       word ptr ds:[CitTah]		; turn counter
l_0057:  dec       word ptr ds:[d_09C6]
         dec       byte ptr ds:[d_09D6]		; level counter
         mov       bx,ds:[d_09C2]
         sub       bx,4
         mov       ds:[d_09C2],bx
         mov       ax,ds:[bx+2]
         mov       ds:[d_09CC],ax		; pointer to turn stack
         mov       ax,ds:[bx]
         mov       ds:[d_09C4],ax
         call      l_0EC2			; return turn from the stack
         ret

l_004C   ENDP
  
;==========================================================================
;        one move
; -----------------------------------------------------------------------------
; INOUT: DH=flags
;              bit 0 to bit 3: number of steps
;              bit 4:
;              bit 5: 1=nopponent's piece found
;              bit 6: 1=own piece found
;              bit 7: 1=jump to queen
;        CL=direction (increment position)
; -----------------------------------------------------------------------------

l_007A   PROC      NEAR

         push      cx
         push      dx
         push      di

         mov       al,byte ptr ds:[d_09C0]
         cmp       al,0
         je        l_00AE

         mov       bl,cl			; direction (increment)
         mov       dl,0
         mov       cl,al
         mov       ch,0
         mov       al,ds:[PozTah]		; position of the move
         mov       di,offset d_0165		; table of positions of pieces

         cld
l_0094:  repne     scasb			; find piece position
         jnz       l_00AE			; position not found
         cmp       dl,0
         jne       l_00F3

         mov       dl,1
         mov       bh,ds:[di+9]			; move direction
         cmp       bh,bl			; same direction?
         je        l_0094 			; same direction - next
         neg       bh				; reverse direction
         cmp       bh,bl
         je        l_0094			; reverse direction - next
         jmp       short l_00F3			; end

; ------ address of player's piece count table

l_00AE:  mov       di,word ptr ds:[CilFig2]	; destination piece (without color)
         mov       bx,offset PocFigC		; table of black player
         mov       ah,0
         mov       al,ds:[CilFig1]		; old piece on the square
         test      al,80h			; white piece?
         jz        l_00C3			; black piece
         mov       bx,offset PocFigB		; table of white player

; ------ jump to queen

l_00C3:  and       al,7				; piece
         test      dh,80h			; jump to queen?
         jz        l_00CC			; not queen
         mov       al,5				; queen

; ------ increase number of pieces

l_00CC:  inc       byte ptr ds:[bx]

; ------ old points of the piece

         add       bx,ax
         add       bx,ax
         mov       ax,ds:[bx]			; piece state

; ------ check points

         cmp       al,0				; first points
         je        l_00EB
         cmp       ah,0				; second points
         je        l_00E4

; ------ third points

         inc       bx
         inc       bx
         mov       ax,ds:[bx]			; points of next piece
         jmp       short l_00EB

; ------ second points

l_00E4:  mov       ah,ds:[di+TabBod]		; points
         jmp       short l_00F1

; ------ first (and third) points of the piece

l_00EB:  mov       ah,al			; clear
         mov       al,ds:[di+TabBod]		; points
l_00F1:  mov       ds:[bx],ax			; store points

; ------ pop registers

l_00F3:  pop       di
         pop       dx
         pop       cx
         ret       

l_007A   ENDP
  
; -----------------------------------------------------------------------------
;      Test of the piece's neighbourhood (scoring of the piece's position)
; -----------------------------------------------------------------------------
; Tested in the oblique, perpendicular and horse directions (except the knight is stepped to the end)
; -----------------------------------------------------------------------------
; 
TestOkol PROC      NEAR

; ------ prepare registers

         push      cx
         mov       ch,16		; turn counter
         xor       di,di		; direction pointer

; ------ check one direction

TestOk1: mov       cl,ds:[di+TabSmer]	; direction
         mov       dh,0
         mov       al,ds:[PozTst]	; tested position
         mov       ds:[PozTah],al

; ------ check all steps in one direction

TestOk2: inc       dh
         call      PokTah
         cmp       al,1			; opponent
         je        TestOk5
         cmp       al,2			; own
         je        TestOk6
         cmp       al,0			; empty
         jne       TestOk3		; border
         cmp       ch,9			; knight
         jae       TestOk2		; next step

; ------ end of one direction - next direction

TestOk3: inc       di
         dec       ch
         jnz       TestOk1		; next direction
         mov       al,0
TestOk4: pop       cx
         ret       

; ------ opponent found

TestOk5: test      dh,40h
         jnz       TestOk3
         or        dh,20h
         jmp       short TestOk7

; ------ own found

TestOk6: test      dh,20h
         jnz       TestOk3
         or        dh,40h

; ------ knight move

TestOk7: mov       dl,ds:[CilFig2]	; deleted piece
         cmp       ch,9
         jb        TestOkC		; knight

; ------ check jump to queen - any straight direction by any number of steps

         cmp       dl,5			; queen
         jne       TestOk8
         or        dh,80h
         jmp       short TestOkD

; ------ King move check - 1 step in any direction

TestOk8: mov       al,dh
         and       al,0Fh
         cmp       al,1
         jne       TestOk9
         cmp       dl,6
         je        TestOkD

; ------ control of the bishop's turn - oblique direction

TestOk9: cmp       ch,0Dh
         jb        TestOkB
         cmp       dl,3			; bishop
         je        TestOkD

; ------ pawn otherwise

         mov       al,dh
         and       al,0Fh
         cmp       al,1
         jne       TestOk3
         cmp       dl,1
         jne       TestOk3

; ------ check pawn

         test      byte ptr ds:[CilFig1],80h ; white pawn ?
         jz        TestOkA		; black pawn
         cmp       ch,0Fh
         jb        TestOk3
         jmp       short TestOkD

TestOkA: cmp       ch,0Fh
         jae       TestOk3
         jmp       short TestOkD

; ------ check rook move

TestOkB: cmp       dl,4
         jne       TestOk3
         jmp       short TestOkD

; ------ check knight

TestOkC: cmp       dl,2
         jne       TestOk3

; ------ valid turn

TestOkD: cmp       byte ptr ds:[FigTst2],7
         je        TestOkE
         test      dh,20h		; jump to opponent
         jz        TestOkF
         mov       al,1
         jmp       short TestOk4

; ------ check next turn

TestOkE: call      l_007A		; store points
TestOkF: mov       al,ds:[CilFig2]	; old piece
         cmp       al,6
         je        TestOkG
         cmp       al,2
         je        TestOkG
         jmp       TestOk2

TestOkG: jmp       TestOk3

TestOkol ENDP
  
;==========================================================================
;        random table selection to start the game
;==========================================================================
  
l_01C8   PROC      NEAR

         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       al,ds:[46ch]
         pop       ds

         and       al,3
         mov       dl,6                     
         mul       dl
         mov       dx,offset d_000E
         add       ax,dx                    
         mov       ds:[d_09C8],ax		; computer turn
         ret

l_01C8   ENDP

;==========================================================================
;        castling test
;==========================================================================
  
l_01DE   proc    near

         test      byte ptr ds:[FigTst1],8
         jz        l_01E6
         ret       

l_01E6:  cmp       byte ptr ds:[d_09D7],0
         je        l_01EE
         ret       

l_01EE:  mov       cx,0FF03h
l_01F1:  add       cl,ds:[d_09B2]           
         mov       bh,0                     
         mov       bl,cl
         mov       word ptr ds:[PozTst],bx
         mov       al,ds:[bx+Mapa]
         and       al,7Fh
         cmp       al,4			; rook?
         jne       l_026E
         jz        l_0229

l_0209:  mov       bx,word ptr ds:[PozTst]
         cmp       byte ptr ds:[bx+Mapa],0
         jne       l_026E
         cmp       bl,5Ch
         je        l_0229
         cmp       bl,16h
         je        l_0229
         call      TestOkol
         cmp       al,0
         jne       l_026E
         mov       bx,word ptr ds:[PozTst]
l_0229:  add       bl,ch
         mov       word ptr ds:[PozTst],bx
         cmp       bl,ds:[d_09B2]
         jne       l_0209
         sub       bl,ch
         sub       bl,ch
         mov       ds:[PozTah],bl
         mov       byte ptr ds:[CilFig1],40h
         call      l_0000
         mov       al,ds:[d_09B2]
         sub       al,ch
         mov       ds:[PozTah],al
         mov       ds:[d_09B2],cl
         mov       byte ptr ds:[CilFig1],0
         call      l_0000
         mov       bx,ds:[d_09CA]
         sub       bx,6
         mov       ds:[d_09CA],bx
         mov       word ptr ds:[bx],0
         mov       al,ds:[PozTst]
         mov       ds:[d_09B2],al

l_026E:  cmp       ch,1
         je        l_0279
         mov       cx,1FCh
         jmp       l_01F1

l_0279:  ret

l_01DE   ENDP

;==========================================================================
;        Computer turn
;==========================================================================
  
TahPoc   PROC      NEAR

; ------ report computer turn

         mov       byte ptr ds:[Hraje],1	; omputer turn

         mov       si,offset CekTxt
         call      DispHlas

         mov       dh,ds:[Radek]
         mov       dl,4
         mov       al,16
         call      DispChar

l_02CA:  call      l_0606
         mov       ax,ds:[d_09C8]
         mov       ds:[d_09C4],ax
         cmp       byte ptr ds:[d_017F],1
         jne       l_02EA                   
         mov       cl,1                     
         call      l_05B0			; mat

l_02EA:  call      l_09B4
         mov       al,ds:[Hrac]
         mov       ds:[Protihr],al
         call      Rosada			; castling

         mov       byte ptr ds:[Rosad],0

         mov       ds:[NewPoz],dl
         mov       ds:[OldPoz],cl

         cmp       ch,0
         jne       l_0316

         jmp       short l_033E
                                           ;* little castling "O-O"
l_0316:  test      ch,2
         jz        l_0326
         mov       byte ptr ds:[Rosad],1
         jmp       short l_033E
                                           ;* big castling "O-O-O"
l_0326:  test      ch,4
         jz        l_0336
         mov       byte ptr ds:[Rosad],2
         jmp       short l_033E
         nop                                

l_0336:  mov       byte ptr ds:[Rosad],3    ; "PxPep"

l_033E:  cmp       byte ptr ds:[d_017F],0FFh
         jne       l_034D
         mov       cl,0                     
         call      l_05B0		; mat
         jmp       short l_0368
         nop
                                            
l_034D:  lea       bx,ds:[d_09E2]
         mov       al,ds:[Hrac]
         xor       al,80h                   
         call      TestFig
         cmp       al,0                     
         je        l_0368                   

l_0368:

         mov       dh,ds:[Radek]
         mov       dl,4
         mov       al," "
         call      DispChar

         call      DispMov
         call      DispCR
         ret

TahPoc   ENDP
  
;==========================================================================
;        Display chessboard
;==========================================================================
  
Disp     PROC      NEAR

; ------ save registers

         push      ax
         push      bx
         push      cx
         push      dx
         push      di
         push      es

; ------ display chessboard

         xor       bx,bx
         mov       cx,offset(Mapa0-Mapa)
Disp2:   mov       dl,ds:[bx+Mapa]
         cmp       dl,0FFh
         je        Disp3
         mov       al,bl
         call      DispPol
Disp3:   inc       bx
         loop      Disp2

; ------ display digits

         mov       di,160
         mov       es,ds:[SegmVRAM]
         mov       ax,0fh*256 + "8"
         mov       cl,8
         cld
Disp4:   stosw
         add       di,3*160-2
         dec       ax
         loop      Disp4

; ------ display letters

         add       di,5*2-160
         mov       al,"a"
         mov       cl,8
Disp5:   stosw
         add       di,6*2
         inc       ax
         loop      Disp5

; ------ pop registers

         pop       es
         pop       di
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

Disp     ENDP

; -----------------------------------------------------------------------------
;        display square
; -----------------------------------------------------------------------------
; 
                                                 ; INOUT: AL=square
                                                 ;        DL=content
DispPol  PROC      NEAR

; ------ push registers

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di
         push      bp
         push      es

; ------ prepare registers

         mov       es,ds:[SegmVRAM]
         cld

; ------ coordinates

         mov       ah,0
         mov       cl,10
         div       cl
         sub       al,2
         neg       al
         add       al,7
         dec       ah
         mov       bl,ah

; ------ prepare color

         mov       bp,70h*256 + 178
         cmp       dl,80h
         jne       DispPol1
         xor       bp,77h*256
DispPol1:xor       ah,al
         test      ah,1
         jz        DispPol2
         xor       bp,77h*256
         xor       dl,80h
DispPol2:test      dl,80h
         jnz       DispPl22
         add       bp,176-178

; ------ prepare addresss

DispPl22:mov       cl,80*3
         mul       cl
         shl       ax,1
         add       ax,4
         mov       di,ax
         mov       al,7*2
         mul       bl
         add       di,ax

; ------ check empty square

         mov       al,dl
         and       al,7
         jnz       DispPol4

; ------ display empty square

         mov       bh,3
         mov       ax,bp
         mov       al," "
DispPol3:mov       cx,7
         rep       stosw
         add       di,160-7*2
         dec       bh
         jnz       DispPol3
         jmp       short DispPol9

; ------ piece template

DispPol4:mov       cl,3*7
         mul       cl
         mov       si,offset Obrazky-3*7
         add       si,ax

; ------ display piece

         mov       bh,3
         mov       ax,bp
DispPol5:mov       cx,7
DispPol6:lodsb
         cmp       al,178
         jne       DispPol7
         mov       ax,bp
DispPol7:stosw
         loop      DispPol6
         add       di,160-2*7
         dec       bh
         jnz       DispPol5

; ------ pop registers

DispPol9:pop       es
         pop       bp
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

DispPol  ENDP

;==========================================================================
;       nesting in the turn
;==========================================================================
  
l_0492   PROC      NEAR

         mov       al,ds:[d_09B2]
         test      byte ptr ds:[FigTst1],80h
         jz        l_049E
         add       al,0Ah
l_049E:  cmp       al,3Dh
         jb        l_0508
         cmp       al,44h
         ja        l_0508
         mov       bx,ds:[d_09C4]
         test      byte ptr ds:[bx+4],10h
         jz        l_0508
         mov       bl,ds:[bx+3]
         mov       ds:[d_09B8],bl
         mov       bh,0
         mov       al,ds:[bx+Mapa]
         mov       ds:[d_09D2],al           
         and       al,7                     
         cmp       al,1                     ; pawn ?
         jne       l_0508

         sub       bl,ds:[PozTah]
         jns       l_04CE                   
         neg       bl
l_04CE:  cmp       bl,0Ah
         jne       l_0508
         or        byte ptr ds:[CilFig1],40h
         call      l_0000
         mov       al,ds:[d_09B2]
         mov       ds:[PozTst],al
         mov       al,ds:[d_09B8]
         mov       ds:[d_09B2],al
         mov       ds:[PozTah],al
         mov       al,ds:[d_09D2]
         mov       ds:[CilFig1],al
         call      l_0000
         mov       al,ds:[PozTst]
         mov       ds:[d_09B2],al
         mov       bx,ds:[d_09CA]
         sub       bx,6
         mov       ds:[d_09CA],bx
         mov       word ptr ds:[bx],0
l_0508:  ret

l_0492   ENDP
  
;==========================================================================
;       one turn
;==========================================================================
  
l_050A   PROC      NEAR

         call      l_09B4
         mov       al,ds:[Protihr]
         call      TestFig
         cmp       al,0
         je        l_051F
         mov       byte ptr ds:[d_09D9],0
         jmp       short l_0525
         nop
l_051F:  call      l_0B24
         call      l_0CA8                   
l_0525:  call      l_0EC2
         ret

l_050A   ENDP
  
;==========================================================================
;        select turn for castling
;==========================================================================
  
Rosada   PROC      NEAR

         mov       si,ds:[d_09C4]
         mov       al,ds:[Protihr]
         cmp       al,ds:[Hrac]
         jne       l_056C

l_0537:  mov       bh,0
         mov       bl,ds:[si+3]
         cmp       bl,ds:[si+2]
         je        l_055B

         mov       dh,ds:[bx+Mapa]
         test      byte ptr ds:[si+4],20h
         jz        l_0551
         and       dh,0F8h
         or        dh,1
l_0551:  mov       dl,0
         mov       bl,ds:[si+2]
         mov       ch,0Ah
         call      BlikKurz

l_055B:  mov       bh,0
         mov       bl,ds:[si+3]             
         mov       dh,ds:[si+4]             
         mov       dl,ds:[bx+Mapa]
         mov       ch,0Ah                   
         call      BlikKurz

l_056C:  test      byte ptr ds:[si+4],40h
         jz        l_0577
         add       si,6
         jmp       short l_0537

l_0577:  mov       bx,ds:[d_09C4]
         mov       cl,ds:[bx+2]
         mov       dl,ds:[bx+3]
         mov       ch,0
         test      byte ptr ds:[bx+4],40h
         jz        l_05AF
         add       bx,6
         mov       cl,ds:[bx+2]
         mov       dl,ds:[bx+3]
         cmp       cl,dl
         jne       l_059C
         or        ch,1
         jmp       short l_05AF

l_059C:  cmp       dl,1Ah
         je        l_05AC
         cmp       dl,60h
         je        l_05AC
         or        ch,4
         jmp       short l_05AF
l_05AC:  or        ch,2
l_05AF:  ret

Rosada   ENDP

;==========================================================================
;        checkmate (or impending checkmate) report
;==========================================================================
  
l_05B0   PROC      NEAR

         mov       al,ds:[d_09D3]
         sub       al,byte ptr ds:[CitTah]
         jnz       l_05D4

         mov       al,ds:[Hrac]
         cmp       cl,0
         jne       l_05aaa
         xor       al,80h
l_05aaa: mov       si,offset d_0A5A         ; black win
         cmp       al,0                     ; win black ?
         je        l_05aab                  ; win black
         mov       si,offset d_0a3a         ; white win
l_05aab:
         call      DispHlas
         jmp       l_0894		; quit

l_05D4:  cmp       cl,0
         jne       l_05E6
         add       al,30h
         mov       ds:[d_0A52],al         
         mov       si,offset d_0a4a
         call      DispHlas

l_05E6:  ret

l_05B0   ENDP
  
;==========================================================================
;        blinking
;==========================================================================
  
BlikKurz   PROC      NEAR
                                            ; INPUT: CH=number of blinks
                                            ;        BL=square
                                            ;        DL=piece
                                            ;        DH=piece with cursor

         mov       al,dl
         xor       al,dh
         js        BlikKur1
         test      dl,7fh
         jz        BlikKur1
         test      dh,7fh
         jz        BlikKur1
         xor       dh,80h

; ------ keybard

BlikKur1:mov       cl,0
BlikKur2:cmp       byte ptr ds:[Hraje],0
         jne       BlikKur3
         call      Obsluha

; ------ delay

BlikKur3:push      ax
         mov       ah,1
         int       16h
         pop       ax
         jnz       BlikKur4
         call      Cekej

; ------ display square

BlikKur4:xchg      dl,dh
         mov       al,bl
         call      DispPol
         xor       cl,1
         jnz       BlikKur2
         dec       ch
         jnz       BlikKur2
         ret

BlikKurz ENDP
  
;==========================================================================
;        find computer turn
;==========================================================================
  
l_0606   PROC      NEAR

; --- prepare

         mov       al,ds:[Uroven]
         mov       ds:[d_0A6C],al

; ------ first turn

         cmp       word ptr ds:[CitTah],1
         jne       l_062F
         mov       byte ptr ds:[d_017F],0
         test      byte ptr ds:[Hrac],80h
         jnz       l_062F
         call      l_01C8
         ret                                

; ----- for less than turn 4 limiting the level of play to 1 (for starting)

l_062F: 

l_062f2: mov       al,ds:[Uroven]
         mov       ah,0
         cmp       ax,word ptr ds:[CitTah]
         jb        l_063B
         mov       al,byte ptr ds:[CitTah]
         sub       al,1
         mov       ds:[Uroven],al
         ja        l_063b

l_062f3: mov       byte ptr ds:[Uroven],1

l_063B:  xor       ax,ax
         mov       byte ptr ds:[d_09D6],al
         mov       ds:[d_09C8],ax
         lea       ax,ds:[d_01B2]
         mov       ds:[d_09CC],ax
         lea       ax,ds:[d_018A]           
         sub       ax,2                     
         mov       ds:[d_09C2],ax           
         mov       al,ds:[Hrac]
         mov       ds:[Protihr],al
         lea       di,ds:[d_017E]           
         mov       ds:[d_09C6],di           
         mov       ch,0                     
         mov       cl,ds:[Uroven]
         add       cl,2                     
         mov       al,0                     
         cld                                
         rep       stosb                    
         mov       ds:[d_09DF],al           
         mov       ds:[d_09E0],al           
         call      l_0B24                   
         call      l_0CA8
         mov       al,ds:[d_09DA]           
         mov       ds:[d_09DF],al           
         mov       al,ds:[d_09DE]           
         mov       ds:[d_09E0],al           
         jmp       short l_069D             


l_068C: 

         call      DispStav                 ; display state

l_069D:  inc       byte ptr ds:[d_09D6]

         mov       byte ptr ds:[d_09D8],0
         call      l_08A2
         mov       al,byte ptr ds:[d_09D6] 
         cmp       al,ds:[Uroven]
         jae       l_06B5
         call      l_0E88

l_06B5:  mov       ax,ds:[d_09C2]
         mov       ds:[d_09C4],ax
l_06BB:  mov       bx,ds:[d_09C4]
         mov       ax,ds:[bx]
         cmp       ax,0
         je        l_072A
         mov       ds:[d_09C4],ax
         mov       bx,ds:[d_09C2]
         mov       ds:[bx],ax
         mov       al,byte ptr ds:[d_09D6]
         cmp       al,ds:[Uroven]
         jb        l_0701                   
         call      l_09B4
         mov       al,ds:[Protihr]
         call      TestFig
         cmp       al,0                     
         je        l_06EA                   
         call      l_0EC2
         jmp       short l_06BB

l_06EA:  mov       al,byte ptr ds:[d_09D6]  ; èítaè hloubky (úroveò hry)
         cmp       al,ds:[Uroven]           ; úroveò hry
         jne       l_0759                   
         mov       al,ds:[Protihr]
         xor       al,80h                   
         call      TestFig                   ; test okolí aktivní figurky
         cmp       al,0
         je        l_0759
         jnz       l_070E
l_0701:  mov       bx,ds:[d_09C4]           ; ukazatel v bufferu tahù
         cmp       byte ptr ds:[bx+5],0
         je        l_06BB
         call      l_09B4                   ; provedení jednoho tahu
l_070E:  xor       byte ptr ds:[Protihr],80h
         js        l_0719
         inc       word ptr ds:[CitTah]     ; èítaè tahù
l_0719:  mov       bx,ds:[d_09C6]
         mov       al,ds:[bx]
         mov       ds:[bx+2],al
         inc       bx
         mov       ds:[d_09C6],bx
         jmp       l_068C

l_072A:  cmp       byte ptr ds:[d_09D8],0
         jne       l_0745
         mov       al,80h
         cmp       byte ptr ds:[d_09D7],0
         je        l_0765
         mov       al,byte ptr ds:[CitTah]  ; èítaè tahù
         mov       ds:[d_09D3],al           ; zbylý poèet tahù 1
         mov       al,0FFh
         jmp       short l_0765

l_0745:  cmp       byte ptr ds:[d_09D6],1   ; èítaè hloubky (úroveò hry)
         je        l_07A6
         call      l_004C
         mov       bx,ds:[d_09C6]
         mov       al,ds:[bx+2]
         jmp       short l_076E

l_0759:  call      l_0B24                   ; hodnocení jednoho stavu šachovnice
         call      l_0CA8                   
         call      l_0EC2                   ; návrat tahu z bufferu tahù
         mov       al,ds:[d_09D9]
l_0765:  mov       byte ptr ds:[d_09D8],1
         mov       bx,ds:[d_09C6]
l_076E:  cmp       al,ds:[bx]
         ja        l_0778
         call      l_004C
l_0775:  jmp       l_06BB

l_0778:  neg       al
         inc       bx
         cmp       al,ds:[bx]
         jbe       l_0775
         mov       ds:[bx],al

;         call      DispStav

         cmp       byte ptr ds:[d_09D6],1   ; èítaè hloubky (úroveò hry)
         jne       l_0775

         mov       ax,ds:[d_09C4]           ; ukazatel v bufferu tahù
                                            ; - nalezený nejlepší tah
         mov       ds:[d_09C8],ax           ; nalezený tah poèítaèe

         call      DispStav                 ; zobrazení stavu

         mov       ax,word ptr ds:[d_017E]
         cmp       ah,0FFh
         jne       l_0775
         sub       byte ptr ds:[Uroven],2   ; úroveò hry
         test      byte ptr ds:[Hrac],80h ; 80=hráè má bílé, 00=èerné
         jz        l_07A6                   
         dec       byte ptr ds:[d_09D3]     ; zbylý poèet tahù 1
l_07A6:  mov       al,ds:[d_0A6C]           ; úschova úrovnì hry pøi tahu
         mov       ds:[Uroven],al           ; úroveò hry
         ret

l_0606   ENDP


DispStav PROC      NEAR

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di

         mov       ah,1
         int       16h
         jz        l_068c5
         call      InpChr
         cmp       bl,27
         jne       l_068c5

         mov       si,offset PrerTxt        ; dotaz k pøerušení
         call      DispHlas                 ; zobrazení hlášení
l_068c2: call      InpChr                   ; vstup znaku z klávesnice
         cmp       bl,27
         je        l_068c2
         cmp       bl,13
         jne       l_068c4

         mov       al,ds:[d_0A6C]           ; úschova úrovnì hry pøi tahu
         mov       ds:[Uroven],al           ; úroveò hry
         jmp       Zadej

l_068c4: mov       si,offset CekTxt
         call      DispHlas

l_068c5: mov       bx,ds:[d_09c8]
         or        bx,bx
         jz        DispSt18

         mov       al,ds:[OldPoz]
         mov       ah,ds:[NewPoz]
         push      ax
         mov       al,ds:[OldFig]
         mov       ah,ds:[Rosad]
         push      ax

         mov       ax,ds:[bx+2]
         mov       ds:[OldPoz],al
         mov       ds:[NewPoz],ah
         mov       al,ds:[bx+4]
         and       al,7
         mov       ds:[OldFig],al
         mov       byte ptr ds:[Rosad],0
         call      DispMov

         pop       ax
         mov       ds:[Rosad],ah
         mov       ds:[OldFig],al
         pop       ax
         mov       ds:[NewPoz],ah
         mov       ds:[OldPoz],al

DispSt18:

l_068c7:
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

DispStav ENDP

;==========================================================================
;        Tah hráèe - pohyb figurkou
;==========================================================================
  
Obsluha  PROC      NEAR

; ------ test, zda je nìjaká klávesa

         mov       ah,1
         int       16h
         jz        Obsluha9                 ; není klávesa

; ------ úschova registrù

         push      ax
         push      bx
         push      cx                       
         push      dx                       

; ------ výpoèet aktuálního øádku a pozice

         mov       ah,0
         mov       al,ds:[Kurzor]           ; pozice kurzoru
         mov       cl,10                    ; poèet pozic na øádek
         div       cl                       ; výpoèet øádku a pozice
         xchg      ax,dx                    ; DH=pozice, DL=øádek

; ------ vstup znaku z klávesnice

         call      InpChr
         call      Obsluha2                 ; obsluha klávesy

; ------ návrat registrù

         pop       dx
         pop       cx
         pop       bx
         pop       ax
Obsluha9:ret

Obsluha  ENDP

; 
Obsluha2:call      JumpBX                   ; skok na obsluhu klávesy

         dw        4800h,ObslUp             ; nahoru
         dw        4900h,ObslPgUp           ; úplnì nahoru
         dw        4b00h,ObslLeft           ; vlevo
         dw        4d00h,ObslRght           ; vpravo
         dw        5000h,ObslDwn            ; dolù
         dw        5100h,ObslPgDn           ; úplnì dolù
         dw        4f00h,ObslEnd            ; úplnì vpravo
         dw        4700h,ObslHome           ; úplnì vlevo

         dw        0dh,ObslEnt              ; ENTER
         dw        " ",ObslEnt              ; mezera
         dw        5200h,ObslEnt            ; INSERT
         dw        5300h,ObslEnt            ; DELETE
         dw        27,ObslEsc               ; ESC

         dw        0,Obsluha9

; -----------------------------------------------------------------------------
;        pøerušení programu
; -----------------------------------------------------------------------------

ObslEsc  PROC      NEAR

         push      si
         mov       si,offset PrerTxt        ; dotaz k pøerušení
         call      DispHlas                 ; zobrazení hlášení
         pop       si
         call      InpChr                   ; vstup znaku z klávesnice
         cmp       bl,13
         jne       ObslEsc4
         jmp       short l_08942

                                          ;* konec hry - nìkdo win
l_0894:  call      KurzOff
         call      InpChr
l_08942: call      Clear
         jmp       Zadej

ObslEsc4:mov       si,offset TahTxt
         call      DispHlas
         ret

ObslEsc  ENDP

; -----------------------------------------------------------------------------
;        klávesa Home - úplnì vlevo
; -----------------------------------------------------------------------------

ObslHome PROC      NEAR

         cmp       dh,1                     ; je zaèátek øádku ?
         je        ObslHom4                 ; je již zaèátek øádku
         call      ObslLeft                 ; kurzor vlevo
         jmp       short ObslHome           ; další test
ObslHom4:ret

ObslHome ENDP

; -----------------------------------------------------------------------------
;        klávesa Page Up - úplnì nahoru
; -----------------------------------------------------------------------------

ObslPgUp PROC      NEAR

         cmp       dl,9                     ; je horní øádek ?
         je        ObslPgU4                 ; je horní øádek
         call      ObslUp                   ; posun kurzoru nahoru
         jmp       short ObslPgUp
ObslPgU4:ret

ObslPgUp ENDP

; -----------------------------------------------------------------------------
;        klávesa End - úplnì vpravo
; -----------------------------------------------------------------------------

ObslEnd  PROC      NEAR

         cmp       dh,8                     ; je konec øádku ?
         je        ObslEnd4                 ; je konec øádku
         call      ObslRght                 ; posun kurzoru vpravo
         jmp       short ObslEnd
ObslEnd4:ret

ObslEnd  ENDP

; -----------------------------------------------------------------------------
;        Page Down - úplnì dolù
; -----------------------------------------------------------------------------

ObslPgDn PROC      NEAR

         cmp       dl,2                     ; je spodní øádek ?
         je        ObslPgD4                 ; je spodní øádek
         call      ObslDwn                  ; posun kurzoru dolù
         jmp       short ObslPgDn           ; další posun
ObslPgD4:ret

ObslPgDn ENDP

; -----------------------------------------------------------------------------
;        kurzor nahoru
; -----------------------------------------------------------------------------

ObslUp   PROC      NEAR

         mov       al,ds:[Kurzor]           ; pozice kurzoru
         add       al,10                    ; zvýšení øádku o 10 pozic
         add       dl,1                     ; posun èísla øádku
         cmp       al,100                   ; je pøekroèen okraj ?
         jb        ObslUp2                  ; okraj ještì není pøekroèen
         sub       al,80                    ; snížení na spodní okraj
         sub       dl,8
ObslUp2: mov       ds:[Kurzor],al           ; nová pozice kurzoru
         ret

ObslUp   ENDP

; -----------------------------------------------------------------------------
;        kurzor vlevo
; -----------------------------------------------------------------------------

ObslLeft PROC      NEAR

         dec       byte ptr ds:[Kurzor]     ; snížení pozice kurzoru
         dec       dh                       ; snížení pozice
         jnz       ObslLft4                 ; nebyl pøechod pøes okraj
         add       byte ptr ds:[Kurzor],8   ; korekce na konec øádku
         add       dh,8
ObslLft4:ret

ObslLeft ENDP

; -----------------------------------------------------------------------------
;        kurzor vpravo
; -----------------------------------------------------------------------------

ObslRght PROC      NEAR

         inc       byte ptr ds:[Kurzor]     ; zvýšení pozice kurzoru
         inc       dh                       ; zvýšení pozice
         cmp       dh,9                     ; byl pøechod pøes okraj ?
         jne       ObslRgh4                 ; nebyl pøechod pøes okraj
         sub       byte ptr ds:[Kurzor],8   ; korekce na zaèátek øádku
         sub       dh,8
ObslRgh4:ret

ObslRght ENDP

; -----------------------------------------------------------------------------
;        kurzor dolù
; -----------------------------------------------------------------------------

ObslDwn  PROC      NEAR

         mov       al,ds:[Kurzor]           ; pozice kurzoru
         sub       al,10                    ; snížení èísla øádku
         sub       dl,1
         cmp       al,20                    ; je podteèení pod okraj ?
         ja        ObslDwn4                 ; není pod spodním okrajem
         add       al,80                    ; korekce na horní okraj
         add       dl,8
ObslDwn4:mov       ds:[Kurzor],al           ; nová pozice kurzoru
         ret

ObslDwn  ENDP

; -----------------------------------------------------------------------------
;        Enter - položení figurky
; -----------------------------------------------------------------------------

ObslEnt  PROC      NEAR

; ------ položení figurky

         cmp       byte ptr ds:[VolTah],2   ; èeká se na položení ?
         jne       ObslEnt2                 ; neèeká se na položení
         mov       bh,0
         mov       bl,ds:[Kurzor]           ; pozice kurzoru
         mov       al,ds:[bx+Mapa]          ; figurka na nové pozici
         mov       ds:[OldFig],al           ; pùvodní figurka
         test      al,7fh                   ; je nìjaká figurka ?
         jz        ObslEnt0                 ; není figurka - OK
         xor       al,ds:[Figurka]          ; je to figurka správné barvy ?
         jns       ObslEnt1                 ; je to špatná figurka
ObslEnt0:mov       al,ds:[Kurzor]           ; pozice kurzoru
         mov       ds:[NewPoz],al           ; nová pozice figurky
         mov       byte ptr ds:[VolTah],0   ; pøíznak stavu klidu
ObslEnt1:ret

; ------ zvednutí figurky

ObslEnt2:mov       bh,0
         mov       bl,ds:[Kurzor]           ; pozice kurzoru
         mov       al,ds:[bx+Mapa]          ; pøenášená figurka
         cmp       al,0                     ; je nìjaká figurka ?
         je        ObslEnt5                 ; není figurka
         xor       al,ds:[Hrac]             ; je to figurka správné barvy ?
         jns       ObslEnt5                 ; je to špatná figurka
         mov       ds:[OldPoz],bl           ; výchozí pozice figurky
         mov       al,ds:[bx+Mapa]          ; pøenášená figurka
         mov       ds:[Figurka],al          ; pøenášená figurka
         mov       byte ptr ds:[bx+Mapa],0  ; zrušení figurky na šachovnici
         mov       byte ptr ds:[VolTah],2   ; pøíznak èekání na položení
ObslEnt5:ret

ObslEnt  ENDP


;==========================================================================
;        test, zda je nìjaká figurka, s kterou lze táhnout
;==========================================================================
  
l_08A2   PROC      NEAR

         mov       al,ds:[Protihr]           ; barva protihráèe
         call      TestFig                   ; test okolí aktivní figurky
         mov       ds:[d_09D7],al           
         mov       dx,ds:[d_09CC]           ; ukazatel v zásobníku tahù
         mov       bx,ds:[d_09C2]           
         mov       ds:[bx+2],dx             
         add       bx,4                     
         mov       ds:[d_09C2],bx           
         mov       ds:[d_09CA],bx           
         mov       bx,15h                   ; první políèko šachovnice

l_08C4:  mov       word ptr ds:[d_09B2],bx  ; ukazatel v šachovnici
         mov       al,ds:[bx+Mapa]        ; kámen na šachovnici
         cmp       al,0                     ; je prázdné pole ?
         je        l_08E0                   ; prázdné pole - další
         cmp       al,0FFh                  ; mimo šachovnici ?
         je        l_08E0                   ; je mimo - konec
         mov       ds:[FigTst1],al           ; testovaná figurka
         xor       al,ds:[Protihr]           ; je to figurka hráèe ?
         js        l_08E0                   ; není - další
         call      l_0A30                   ; test, zda lze s figurkou táhnout

l_08E0:  mov       bx,word ptr ds:[d_09B2]
         inc       bx
         cmp       bl,63h
         jb        l_08C4
         ret

l_08A2   ENDP
  
         db        0
  
; -----------------------------------------------------------------------------
;             test okolí figurky protihráèe (barva hráèe AL)
; -----------------------------------------------------------------------------
  
TestFig  PROC      NEAR

         rol       al,1                     ; barva -> bit 0
         and       ax,1                     ; barva figurky
         mov       bx,ax                    ; BX <- barva figurky (1=bílá)
         mov       bl,ds:[bx+KurzB]         ; pozice kurzoru protihráèe
         mov       bh,0                     ; BH <- 0
         mov       word ptr ds:[PozTst],bx  ; pracovní pozice hráèe
         mov       al,ds:[bx+Mapa]          ; figurka na pozici
         mov       ds:[FigTst1],al          ; figurka pøi testu
         and       al,7                     
         mov       ds:[FigTst2],al          ; figurka pøi testu
         call      TestOkol                 ; test okolí figurky
         ret

TestFig  ENDP
  
; -----------------------------------------------------------------------------
;                     Inicializace šachovnice
; -----------------------------------------------------------------------------

InitPole PROC      NEAR

; ------ vymazání šachovnice

         cld                                
         mov       di,offset Mapa           ; mapa šachovnice
         mov       si,offset MapaIni        ; inicializaèní rozmístìní
         mov       cx,offset(Mapa0-Mapa)/2  ; délka mapy šachovnice (slov)
         rep       movsw                    ; inicializace mapy šachovnice

; ------ inicializace ukazatelù

         mov       byte ptr ds:[KurzB],25   ; pozice kurzoru bílého
         mov       byte ptr ds:[KurzC],95   ; pozice kurzoru èerného
         mov       byte ptr ds:[DamaB],24   ; bílá queen
         mov       byte ptr ds:[DamaC],94   ; èerná queen

; ------ pozice kurzoru hráèe

         mov       al,25                    ; kurzor bílého
         test      byte ptr ds:[Hrac],80h   ; je hráè white ?
         jnz       InitPol2                 ; je white
         mov       al,95                    ; pozice kurzoru èerného
InitPol2:mov       ds:[HracPoz],al          ; pozice kurzoru hráèe
         ret

InitPole ENDP

;==========================================================================
;        omezení èísla AL na CH (absolutnì)
;==========================================================================
  
l_09A0   PROC      NEAR

                                          ;* kontrola pøekroèení èísla AL
         and       al,al                    ; test AL
         lahf                               ; úschova registru pøíznakù
         jns       l_09A7                   ; je kladné èíslo
         neg       al                       ; absolutní hodnota èísla
l_09A7:  cmp       al,ch                    
         jb        l_09AD                   
         mov       al,ch                    
l_09AD:  sahf                               ; návrat registru pøíznakù
         jns       l_09B2                   ; bylo to kladné èíslo
         neg       al                       ; návrat záporného èísla
l_09B2:  ret

l_09A0   ENDP
  
;==========================================================================
;        provedení jednoho tahu
;==========================================================================
  
l_09B4   PROC      NEAR

         mov       si,ds:[d_09C4]           ; ukazatel v bufferu tahù
l_09B8:  mov       bh,0                     
         mov       dh,ds:[si+4]             ; cílová figurka
         and       byte ptr ds:[OldFig],7
         mov       bl,ds:[si+2]             ; výchozí pozice
         mov       di,bx                    ; výchozí pozice
         mov       bl,ds:[si+3]             ; cílová pozice
         mov       si,bx                    ; cílová pozice

         push      ax
         mov       al,ds:[si+Mapa]
         mov       ds:[OldFig],al          ; pùvodní figurka
         pop       ax

         mov       dl,ds:[di+Mapa]        ; figurka, která táhne
         mov       bl,dl                    ; úschova figurky k táhnutí
         rol       bl,1                     
         and       bx,1                     ; barva figurky
         nop
         test      dh,20h                   ; náhrada pawn dámou ?
         jnz       l_0A07                   ; je náhrada pawn dámou
         mov       al,dl                    ; aktivní figurka
         and       al,7                     ; zrušení barvy
         cmp       al,5                     ; je queen ?
         je        l_0A0F                   ; je queen
         cmp       al,6                     ; je king ?
         je        l_0A17                   ; je king

l_09E4:  or        dl,8
         mov       ds:[si+Mapa],dl        ; aktivní figurka na nové pozici
         mov       byte ptr ds:[di+Mapa],0; zrušení aktivní figurky
         test      dh,40h                   ; bude další tah ?
         jnz       l_0A27                   ; bude další tah (rošáda)
         mov       al,dh                    ; rušená figurka
         and       al,7                     ; zrušení barvy
         cmp       al,5                     ; byla to queen ?
         jne       l_0A06                   ; nebyla to queen
         xor       bx,1
         nop
         mov       byte ptr ds:[bx+DamaB],0; zrušení pozice dámy
l_0A06:  ret

; ------ náhrada pawn dámou

l_0A07:  and       dl,0F8h                  ; zrušení figurky
         or        dl,5                     ; náhrada dámou
         jmp       short l_09E4

; ------ tah dámou - nová pozice

l_0A0F:  mov     ax,si                      ; cílová pozice figurky
         mov     ds:[bx+DamaB],al          ; nová pozice dámy
         jmp     short l_09E4

; ------- tah králem

l_0A17:  test    dh,40h                     ; byla to rošáda ?
         jz      l_0A1F                     ; nebyla rošáda
         or      dl,10h                     ; pøíznak 2. tahu rošády

l_0A1F:  mov     ax,si                      
         mov     ds:[bx+KurzB],al          ; nová pozice kurzoru
         jmp     short l_09E4

l_0A27:  mov     si,ds:[d_09C4]             ; ukazatel v bufferu tahù
         add     si,6
         jmp     l_09B8

l_09B4   ENDP

;==========================================================================
;        test, zda lze s figurkou táhnout
;==========================================================================
  
l_0A30   PROC      NEAR

; ------ pøíprava poètu a adresy možných tahù figurky

         mov       al,ds:[FigTst1]           ; testovaná figurka
         and       al,87h                   ; figurka s barvou
         cmp       al,81h                   ; je black pawn ?
         jne       l_0A3B                   ; není black pawn
         dec       al                       ; náhradný èíslo figurky 0
l_0A3B:  and       al,7                     ; zrušení barvy
         mov       ds:[FigTst2],al           ; figurka
         mov       bh,0                     
         mov       bl,al                    ; figurka
         mov       ch,ds:[bx+NumSmer]        ; poèet možných tahù
         mov       bl,ds:[bx+OfsSmer]        ; adresa možných tahù
         mov       di,bx                    ; adresa možných tahù figurky

; --------- test jednoho tahu figurky

l_0A4E:  mov       cl,ds:[di+TabSmer]        ; možný smìr tahu figurky
         mov       al,ds:[d_09B2]           ; pozice figurky
         mov       ds:[PozTah],al           ; pozice pøi pokusu o tah

; ------- test jednoho kroku

l_0A58:  call      PokTah                   ; pokus o tah daným smìrem

         cmp       al,2                     ; je skok na vlastní nebo ven ?
         jae       l_0A7A                   ; skok na vlastní nebo ven - chyba

         cmp       al,0                     ; je prázdné ?
         lahf                               ; úschova pøíznakù
         mov       al,ds:[FigTst2]           ; figurka
         cmp       al,1                     ; je pawn ?
         jbe       l_0A8A                   ; pawn nebo prázdné políèko
         call      l_0000                   ; uložení definice do zásobníku tahù
         sahf                               ; návrat pøíznakù
         jnz       l_0A7A                   ; není prázdné políèko
         mov       al,ds:[FigTst2]           ; figurka
         cmp       al,6                     ; je king ?
         je        l_0A7A                   ; je king - nelze další krok
         cmp       al,3                     ; je bishop, rook nebo queen ?
         jae       l_0A58                   ; bishop, rook nebo queen-další krok

l_0A7A:  inc       di
         dec       ch
         jnz       l_0A4E
         mov       al,ds:[FigTst2]
         cmp       al,6
         jne       l_0A89
         call      l_01DE                   ; test rošády
l_0A89:  ret

l_0A8A:  cmp       ch,3
         jb        l_0ABB
         jz        l_0AB3
         sahf                               ; jinak je první tah - pøímo
         jnz       l_0A7A                   ; není prázdné pole - chyba
         mov       al,ds:[PozTah]           ; pozice pøi pokusu o tah
         cmp       al,5Bh                                ; '['
         jae       l_0A9F
         cmp       al,1Dh
         jae       l_0AA4
l_0A9F:  or        byte ptr ds:[CilFig1],20h ; pøíznak posl. øady pawnem
l_0AA4:  call      l_0000                   ; uložení definice do zásobníku tahù
         inc       di
         dec       ch
         test      byte ptr ds:[FigTst1],8
         jz        l_0A58                   ; další krok
         jnz       l_0A7A
l_0AB3:  sahf
         jnz       l_0A7A
l_0AB6:  call      l_0000                   ; uložení definice do zásobníku tahù
         jmp       short l_0A7A

l_0ABB:  sahf
         jz        l_0AD0
         mov       al,ds:[PozTah]           ; pozice pøi pokusu o tah
         cmp       al,5Bh                                ; '['
         jae       l_0AC9
         cmp       al,1Dh
         jae       l_0AB6
l_0AC9:  or        byte ptr ds:[CilFig1],20h              ; ' '
         jmp       short l_0AB6

l_0AD0:  call      l_0492
         jmp       short l_0A7A

l_0A30   ENDP
  
  
l_0AD6   PROC      NEAR

         inc       bp
         xchg      ch,cl
         xchg      di,si
         mov       ax,0
         cmp       ch,0
         je        l_0AF5
         dec       ch
         cld       
l_0AE6:  scasw
         jz        l_0AE6
         dec       di
         dec       di
         mov       ax,ds:[di]
         mov       ds:[di],ah
         mov       byte ptr ds:[di+1],0
         add       al,al
l_0AF5:  ret

l_0AD6   ENDP

;==========================================================================
;                  Pokus o tah daným smìrem
;==========================================================================
  
PokTah   PROC      NEAR
                                               ;* pokus o tah daným smìrem
                                                 ; VSTUP: CL=pøírustek skoku
                                                 ; VÝSTUP: AL=0 - prázdné pole
                                                 ;         AL=1 - na soupeøe
                                                 ;         AL=2 - na vlastní
                                                 ;         AL=3 - tah ven

; ------ získání obsahu cílového políèka

         mov       bx,word ptr ds:[PozTah]  ; pozice pøi pokusu o tah
         add       bl,cl                    ; zvýšení pozice o tah
         mov       word ptr ds:[PozTah],bx  ; nová pozice pøi pokusu o tah
         mov       al,ds:[bx+Mapa]          ; obsah nové pozice

; ------ test, zda je skok mimo šachovnici

         cmp       al,0FFh                  ; je zakázaná oblast ?
         je        PokTah2                  ; je tah ven z šachovnice

; ------ úschova obsahu cílového políèka

         mov       ds:[CilFig1],al          ; pùvodní obsah na políèku
         and       al,7                     ; zrušení pøíznaku barvy
         mov       ds:[CilFig2],al          ; rušená figurka
         jz        PokTah3                  ; prázdné políèko

; ------ test, zda je skok na vlastní figurku

         mov       al,ds:[CilFig1]          ; pùvodní obsah políèka
         xor       al,ds:[FigTst1]          ; test barvy figurky
         jns       PokTah1                  ; stejná barva - chyba
         mov       al,1                     ; skok na soupeøe - OK
         ret       

; ------ skok na vlastní

PokTah1: mov       al,2                     ; pøíznak - skok na vlastní
         ret       

; ------ skok ven z šachovnice

PokTah2: mov       al,3                     ; pøíznak - tah je ven
PokTah3: ret

PokTah   ENDP

;==========================================================================
;        hodnocení jednoho stavu šachovnice
;==========================================================================
  
l_0B24   PROC      NEAR

         mov       word ptr ds:[d_09C0],0
         mov       si,0
l_0B2D:  mov       bl,ds:[si+KurzB]        ; pozice kurzoru bílého
         cmp       bl,0
         jne       l_0B39
         jmp       l_0BEE

l_0B39:  cmp       bl,0FFh
         jne       l_0B3F
         ret       

l_0B3F:  mov       bh,0
         mov       word ptr ds:[PozTst],bx  ; testovaná pozice
         mov       al,ds:[bx+Mapa]        ; vektor šachovnice
         mov       ds:[FigTst1],al           ; testovaná figurka
         mov       ch,8                     ; poèet pokusù
         mov       di,0                     
l_0B51:  mov       al,ds:[PozTst]           ; testovaná pozice
         mov       ds:[PozTah],al           ; pozice pøi pokusu o tah
         mov       byte ptr ds:[d_09B8],0
         mov       cl,ds:[di+TabSmer]

l_0B60:  call      PokTah                   ; pokus o tah daným smìrem
         cmp       al,0                     
         je        l_0B60                   ; je prázdné pole - další
         cmp       al,3                     
         je        l_0BE6                   ; tah ven
         cmp       al,2                     ; skok na vlastní
         je        l_0B8E

         cmp       byte ptr ds:[d_09B8],0
         je        l_0BE6
         mov       al,ds:[CilFig2]           ; pùvodní figurka
         cmp       al,5                     ; byla to queen ?
         je        l_0B9D                   ; byla to queen
         cmp       ch,5                     
         jb        l_0B88                   
         cmp       al,3                     ; byl to støelece ?
         jne       l_0BE6                   ; nebyl to bishop
         jz        l_0BD2                   ; byl to bishop - OK

l_0B88:  cmp       al,4                     ; byla to rook ?
         jne       l_0BE6                   ; nebyla to rook
         jz        l_0BD2                   ; byla to rook

l_0B8E:  cmp       byte ptr ds:[d_09B8],0
         jne       l_0BE6
         mov       al,ds:[PozTah]           ; pozice pøi pokusu o tah
         mov       ds:[d_09B8],al
         jmp       short l_0B60

l_0B9D:  mov       al,ds:[FigTst1]           ; testovaná figurka
         and       al,7                     ; zrušení barvy
         cmp       al,5                     ; byla to queen ?
         jne       l_0BD2                   ; nebyla to queen - dobrý tah
         push      cx
         push      di
         mov       al,0
         mov       cx,0Eh
         lea       di,ds:[PocFigC]
         cld       
         rep       stosw
         mov       byte ptr ds:[FigTst2],7
         call      TestOkol                   ; test okolí figurky
         pop       di
         pop       cx
         mov       al,ds:[PocFigC]
         sub       al,ds:[PocFigB]
         test      byte ptr ds:[FigTst1],80h
         jz        l_0BCE
         neg       al
l_0BCE:  dec       al
         jns       l_0BE6
l_0BD2:  mov       bx,ds:[d_09C0]
         inc       bx
         mov       ds:[d_09C0],bx
         mov       ds:[bx+d_016F],cl
         mov       al,ds:[d_09B8]
         mov       ds:[bx+d_0165],al
l_0BE6:  inc       di
         dec       ch
         jz        l_0BEE
         jmp       l_0B51
l_0BEE:  inc       si
         jmp       l_0B2D

l_0B24   ENDP

;==========================================================================
;                       Tah hráèe
;==========================================================================
; 

TahHrac  PROC      NEAR

; ------ automatická hra - náhrada poèítaèem

         cmp       byte ptr ds:[Automat],0  ; je automatická hra ?
         je        TahHrac2                 ; není automatická hra
         xor       byte ptr ds:[Hrac],80h   ; zmìna barvy hráèe
;         xor       byte ptr ds:[Protihr],80h ; zmìna barvy poèítaèe
         call      TahPoc                   ; tah poèítaèe
         xor       byte ptr ds:[Hrac],80h   ; návrat barvy hráèe
;         xor       byte ptr ds:[Protihr],80h ; návrat barvy poèítaèe
         ret

; ------ pøíprava aktuální pozice kurzoru

TahHrac2:mov       byte ptr ds:[Hraje],0    ; pøíznak, že hraje hráè

         mov       al,ds:[HracPoz]          ; pozice hráèe
         mov       ds:[Kurzor],al           ; aktuální pozice kurzoru

; ------ výzva k provedení tahu

         mov       si,offset TahTxt
         call      DispHlas                 ; zobrazení hlášení

; ------ zvednutí figurky

TahHrac4:mov       byte ptr ds:[VolTah],1   ; pøíznak èekání na DEL
         call      KurzOff                  ; vypnutí kurzoru

; ------ èekání na zvednutí figurky

TahHrac5:mov       bh,0                     ; BH <- 0
         mov       bl,ds:[Kurzor]           ; pozice kurzoru
         mov       dl,ds:[bx+Mapa]          ; figurka na pozici kurzoru
         mov       dh,dl                    ; úschova figurky
         xor       dh,80h                   ; inverzní figurka
         mov       ch,1                     ; poèet cyklù = 1
         call      BlikKurz                 ; obsluha kurzoru
         cmp       byte ptr ds:[VolTah],1   ; èeká se na zvednutí ?
         je        TahHrac5                 ; èekání na zvednutí figurky

; ------ èekání na položení figurky

TahHrac6:mov       bh,0                     ; BH <- 0
         mov       bl,ds:[Kurzor]           ; pozice kurzoru
         mov       dl,ds:[bx+Mapa]          ; figurka na pozici kurzoru
         mov       dh,ds:[Figurka]          ; pøenášená figurka
         mov       ch,1                     ; poèet cyklù = 1
         call      BlikKurz                 ; obsluha kurzoru
         cmp       byte ptr ds:[VolTah],2   ; èeká se na položení ?
         je        TahHrac6                 ; èekání na položení figurky

; ------ test navrácení figurky

         mov       bh,0                     ; BH <- 0
         mov       bl,ds:[OldPoz]           ; výchozí pozice figurky
         mov       al,ds:[Figurka]          ; pøenášená figurka
         mov       ds:[bx+Mapa],al          ; navrácení figurky zpìt
         mov       dl,bl                    ; výchozí pozice pøenášení
         mov       dh,ds:[NewPoz]           ; nová pozice figurky
         cmp       dl,dh                    ; je stejná pozice ?
         je        TahHrac4                 ; figurka navrácena - znovu

; ------ test správnosti tahu, návrat tahu

         call      TestTah                  ; test správnosti tahu + provedení
         jnc       TahHrac7                 ; tah je OK - nová pozice
         mov       al,ds:[OldPoz]           ; výchozí pozice figurky
         mov       ds:[Kurzor],al           ; pozice kurzoru
         mov       dl,ds:[Figurka]          ; pøenášená figurka
         call      DispPol                  ; zobrazení políèka
         jmp       TahHrac4                 ; nová volba tahu

; ------ zobrazení nové pozice figurky

TahHrac7:mov       al,ds:[NewPoz]           ; nová pozice figurky
         mov       ds:[HracPoz],al          ; úschova nové pozice kurzoru
         mov       bh,0                     ; BH <- 0
         mov       bl,al                    ; BX <- nová pozice figurky
         mov       dl,ds:[bx+Mapa]          ; vektor šachovnice
         call      DispPol                  ; zobrazení políèka

         mov       byte ptr ds:[Rosad],0
         call      Rosada                   ; volba tahu pro rošádu

; ------ zobrazení provedeného tahu

         call      DispMov                  ; zobrazení provedeného tahu
         call      DispCR                   ; odøádkování textu
         ret

TahHrac   ENDP

;==========================================================================
;       nalezení dalšího tahu
;==========================================================================
  
l_0CA8   PROC      NEAR

         mov       al,0
         mov       ds:[d_09DE],al
         mov       ds:[d_09DA],al
         mov       ds:[d_09DB],al
         mov       ds:[d_09DC],al
         mov       ds:[d_09DD],al
         mov       ds:[d_09E1],al
         mov       byte ptr ds:[FigTst2],7
         mov       bx,15h
l_0CC4:  mov       word ptr ds:[PozTst],bx
         mov       al,ds:[bx+Mapa]        ; vektor šachovnice
         cmp       al,0FFh
         jne       l_0CD3
         jmp       l_0D90
l_0CD3:  mov       cl,al
         mov       ds:[FigTst1],al
         and       al,7
         mov       ds:[d_09BE],al
         cmp       al,1
         jbe       l_0D1C
         cmp       al,4
         jb        l_0D0A
         cmp       al,6
         je        l_0CF2
         cmp       word ptr ds:[CitTah],7   ; èítaè tahù
         jb        l_0D03
         jnc       l_0D03
l_0CF2:  test      cl,10h
         jz        l_0D03
         mov       al,6
         test      cl,80h
         jz        l_0D18
         neg       al
         jmp       short l_0D18
         nop
l_0D03:  test      cl,8
         jz        l_0D1C
         jnz       l_0D0F
l_0D0A:  test      cl,8
         jnz       l_0D1C
l_0D0F:  mov       al,2
         test      cl,80h
         jnz       l_0D18
         neg       al
l_0D18:  add       ds:[d_09DA],al
l_0D1C:  mov       al,0
         mov       cx,0Eh
         lea       di,ds:[PocFigC]
         cld       
         rep       stosw
         call      TestOkol                   ; test okolí figurky
         mov       al,ds:[PocFigC]
         sub       al,ds:[PocFigB]
         add       ds:[d_09DA],al
         cmp       byte ptr ds:[FigTst1],0
         je        l_0D90
         call      l_0F9E
         cmp       dl,0
         je        l_0D81
         dec       dh
         mov       al,ds:[FigTst1]
         xor       al,ds:[Protihr]
         js        l_0D6C
         cmp       dl,ds:[d_09DB]
         jb        l_0D81
         mov       ds:[d_09DB],dl
         mov       bx,ds:[d_09C4]           ; ukazatel v bufferu tahù
         mov       al,ds:[PozTst]
         cmp       al,ds:[bx+3]
         jne       l_0D81
         mov       ds:[d_09E1],al
         jmp       short l_0D81

l_0D6C:  mov       al,dl
         cmp       al,ds:[d_09DC]
         jb        l_0D78
         xchg      al,ds:[d_09DC]
l_0D78:  cmp       al,ds:[d_09DD]
         jb        l_0D81
         mov       ds:[d_09DD],al
l_0D81:  mov       al,dh
         test      byte ptr ds:[FigTst1],80h
         jz        l_0D8C
         neg       al
l_0D8C:  add       ds:[d_09DE],al
l_0D90:  mov       bx,word ptr ds:[PozTst]
         inc       bx
         cmp       bx,63h
         jae       l_0D9D
         jmp       l_0CC4
l_0D9D:  cmp       byte ptr ds:[d_09E1],0
         je        l_0DAF
         mov       al,ds:[d_09DD]
         mov       ds:[d_09DC],al
         mov       byte ptr ds:[d_09DD],0
l_0DAF:  mov       al,ds:[d_09DB]
         cmp       al,0
         je        l_0DB8
         dec       al
l_0DB8:  mov       ch,al
         mov       al,ds:[d_09DC]
         cmp       al,0
         je        l_0DCC
         mov       al,ds:[d_09DD]
         cmp       al,0
         je        l_0DCC
         dec       al
         shr       al,1
l_0DCC:  sub       al,ch
         test      byte ptr ds:[Protihr],80h
         jz        l_0DD7
         neg       al
l_0DD7:  add       al,ds:[d_09DE]
         sub       al,ds:[d_09E0]
         mov       ch,1Eh                   ; max. hodnota = 30
         call      l_09A0                   ; omezení èísla AL na CH
         mov       dl,al
         mov       al,ds:[d_09DA]
         sub       al,ds:[d_09DF]
         cmp       byte ptr ds:[d_09E1],0
         je        l_0DF6
         mov       al,0
l_0DF6:  mov       ch,6                     ; max. hodnota = 6
         call      l_09A0                   ; omezení èísla AL na CH
         shl       dl,1
         shl       dl,1
         add       al,dl
         test      byte ptr ds:[Protihr],80h
         jnz       l_0E0A
         neg       al
l_0E0A:  add       al,80h
         mov       ds:[d_09D9],al
         mov       bx,ds:[d_09C4]           ; ukazatel v bufferu tahù
         mov       [bx+5],al
         ret

l_0CA8   ENDP

;==========================================================================
;       posun tahu
;==========================================================================
  
l_0E88   PROC      NEAR

         mov       cx,ds:[d_09C2]
         mov       di,0
l_0E8F:  mov       bx,cx
         mov       cx,[bx]
         mov       [bx],di
         cmp       cx,0
         jne       l_0E9B
         ret       

l_0E9B:  mov       ds:[d_09C4],cx           ; ukazatel v bufferu tahù
         call      l_050A
         mov       bx,ds:[d_09C2]
         mov       cx,ds:[d_09C4]           ; ukazatel v bufferu tahù
l_0EAA:  mov       di,ds:[bx]
         cmp       di,0
         je        l_0EB9
         mov       al,ds:[d_09D9]
         cmp       al,ds:[di+5]
         jae       l_0EBD
l_0EB9:  mov       ds:[bx],cx
         jmp       short l_0E8F
l_0EBD:  mov       bx,di
         jmp       short l_0EAA

l_0E88   ENDP
  
         db        0
  
;==========================================================================
;        návrat tahu z bufferu tahù
;==========================================================================
  
l_0EC2   PROC      NEAR

         mov       si,ds:[d_09C4]           ; ukazatel v bufferu tahù

l_0EC6:  mov       bh,0                     
         mov       dh,ds:[si+4]             ; pùvodní obsah nového pole
         mov       bl,ds:[si+2]             ; výchozí pozice tahu
         mov       di,bx                    ; výchozí pozice tahu
         mov       bl,ds:[si+3]             ; cílová pozice tahu
         mov       si,bx                    ; cílová pozice tahu
         mov       dl,ds:[si+Mapa]        ; figurka, s kterou se táhlo
         mov       bl,dl                    ; figurka k táhnutí
         rol       bl,1                     ; figurka * 2
         and       bx,1                     ; barva figurky
         test      dh,20h                   ; byla náhrada pawna dámou ?
         jnz       l_0F1E                   ; byla náhrada pawna dámou
         mov       al,dl                    ; figurka, která táhla
         and       al,7                     ; zrušení barvy
         cmp       al,5                     ; byla to queen ?
         je        l_0F26                   ; táhla queen
         cmp       al,6                     ; táhl king ?
         je        l_0F2E                   ; táhl king
                                            
l_0EF2:  test      dh,10h
         jz        l_0EFA                   
         and       dl,0F7h                  
l_0EFA:  mov       ds:[di+Mapa],dl        ; uložení pùvodní figurky
         mov       al,dh                    ; pùvodní figurka
         and       al,8Fh                   ; zrušení pøíznakù
         mov       ds:[si+Mapa],al        ; návrat rušené figurky
         test      dh,40h                   ; bude další tah ?
         jnz       l_0F3E                   ; návrat dalšího tahu
         mov       al,dh                    ; rušená figurka
         and       al,7                     ; zrušení barvy
         cmp       al,5                     ; je to queen ?
         jne       l_0F1D                   ; není to queen
         mov       ax,si                    ; pozice dámy
         xor       bx,1                     
         mov       ds:[bx+DamaB],al        ; pùvodní pozice dámy
l_0F1D:  ret

; ------ byla náhrada pawna dámou - návrat pawna

l_0F1E:  and       dl,0F8h                  ; zrušení figurky
         or        dl,1                     ; náhrada pawnem
         jmp       short l_0EF2

; ----- táhla queen

l_0F26:  mov       ax,di                    ; pùvodní pozice dámy
         mov       ds:[bx+DamaB],al        ; návrat pozice dámy
         jmp       short l_0EF2

; ----- táhne king

l_0F2E:  test      dh,40h
         jz        l_0F36
         and       dl,0EFh
l_0F36:  mov       ax,di
         mov       ds:[bx+KurzB],al        ; pozice kurzoru bílého
         jmp       short l_0EF2

; ------ další tah

l_0F3E:  mov       si,ds:[d_09C4]           ; ukazatel v bufferu tahù
         add       si,6                     ; zvýšení pozice v bufferu
         jmp       l_0EC6

l_0EC2   ENDP

;==========================================================================
;     Test správnosti tahu a provedení tahu (DL=výchozí/DH=cílová pozice)
;==========================================================================
; 
TestTah  PROC      NEAR

; ------ prepare registers

         push      word ptr ds:[d_09C4]     ; ukazatel v bufferu tahù
         mov       al,ds:[Hrac]             ; 80=hráè má bílé, 00=èerné
         xor       al,80h                   ; zmìna pøíznaku barvy
         mov       ds:[Protihr],al          ; požadovaná barva protihráèe
         mov       word ptr ds:[d_09C2],offset d_018A-2 ; ukazatel v bufferu
         mov       word ptr ds:[d_09CC],offset d_05b2 ; ukazatel v zásobníku

; ------ test, zda má hráè další tah

         push      dx
         call      l_08A2                   ; test, zda má hráè další tah
         pop       dx                       


         lea       bx,ds:[d_05B2]
l_0F6E:  cmp       dl,ds:[bx+2]             
         jne       l_0F78                   
         cmp       dh,ds:[bx+3]             
         je        l_0F81                   
l_0F78:  mov       bx,ds:[bx]               
         cmp       bx,0                     
         jne       l_0F6E                   
         jz        l_0F98                   
l_0F81:  mov       ds:[d_09C4],bx           ; ukazatel v bufferu tahù
         call      l_09B4                   ; provedení jednoho tahu

         mov       al,ds:[Protihr]           ; barva poèítaèe
         call      TestFig                   ; test okolí aktivní figurky
         cmp       al,0                     
         jne       l_0F95                   

         pop       ax                       
         clc                                
         ret                                

l_0F95:  call      l_0EC2                   ; návrat tahu z bufferu tahù
l_0F98:  pop       word ptr ds:[d_09C4]     ; ukazatel v bufferu tahù
         stc                                ; pøíznak chyby - nepovolený tah
         ret

TestTah   ENDP

;==========================================================================
;       obodování jednoho tahu
;==========================================================================
  
l_0F9E   PROC      NEAR

         lea       di,ds:[BodFigC]
         lea       si,ds:[BodFigB]
         mov       ch,ds:[PocFigC]
         mov       cl,ds:[PocFigB]
         test      byte ptr ds:[FigTst1],80h
         jz        l_0FB9
         xchg      di,si
         xchg      ch,cl
l_0FB9:  mov       bp,0
         mov       dl,0
         mov       bx,word ptr ds:[d_09BE]
         mov       dh,ds:[bx+TabBod]
         shl       dh,1
         mov       bh,dh
         call      l_0AD6
         jz        l_0FFC
l_0FCF:  mov       bl,al
         call      l_0AD6
         jz        l_0FEA
         cmp       bh,bl
         jae       l_0FEA
l_0FDA:  cmp       al,bl
         jb        l_0FFC                            ;*
         call      l_0AD6
         jz        l_0FFC                            ;*
         mov       bl,al
         call      l_0AD6
         jnz       l_0FDA
l_0FEA:  test      bp,1
         jz        l_0FF2                            ;*
         neg       bh
l_0FF2:  add       dl,bh
         cmp       al,0
         je        l_0FFC
         mov       bh,bl
         jmp       short l_0FCF
l_0FFC:  ret

l_0F9E   ENDP

; -----------------------------------------------------------------------------
;        vymazání obrazovky
; -----------------------------------------------------------------------------

Clear    PROC      NEAR

; ------ úschova registrù

         push      ax
         push      bx
         push      cx
         push      dx
         push      di
         push      es

; ------ vymazání obrazovky

         mov       cx,25*80                 ; poèet znakù celkem
         mov       es,ds:[SegmVRAM]         ; segment videopamìti
         xor       di,di
         cld
         mov       ax,720h                  ; znak mezery k vymazání
         rep       stosw                    ; vymazání obrazovky

; ------ nastavení kurzoru

         mov       bh,0
         mov       ah,2
         xor       dx,dx
         call      Int10P                   ; nastavení pozice kurzoru

; ------ návrat registrù

         pop       es
         pop       di
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

Clear    ENDP

; -----------------------------------------------------------------------------
;        èekání na hodinový impuls
; -----------------------------------------------------------------------------

Cekej    PROC      NEAR

         push      ax
         push      ds

         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46ch]             ; èasovaè
Cekej2:  sti
         cmp       ax,ds:[46ch]
         je        Cekej2                   ; èekání na zmìnu hodin

         pop       ds
         pop       ax
         ret

Cekej    ENDP

; *****************************************************************************
;                    skok na obsluhu podle BX
; -----------------------------------------------------------------------------
; Procedura se volá instrukcí CALL JumpBX, za kterou následuje tabulka
; skokù. Procedura zmìní svou návratovou adresu na adresu podle nalezené
; položky v tabulce (nebo podle položky pro nenalezenou hodnotu).
; -----------------------------------------------------------------------------
; VSTUP: v zásobníku slovo (návratová adresa NEAR) = zaèátek tabulky skokù
;             stuktura tabulky: 1 slovo testovaná hodnota BX
;                               1 slovo adresa NEAR obsluhy
;             konec tabulky: 1 slovo = 0 (pøíznak konce tabulky)
;                            1 slovo adresa NEAR obsluhy pøi nenalezení kódu
; *****************************************************************************

JumpBX   PROC      NEAR

; ------ úschova registrù

                                            ; SS:[BP+6] = IP
         push      si                       ; SS:[BP+4] = SI
         push      bp                       ; SS:[BP+2] = BP
         push      ds                       ; SS:[BP+0] = DS
         mov       bp,sp

; ------ nalezení hodnoty v tabulce

         push      cs
         pop       ds
         mov       si,ss:[bp+6]             ; offset adresy tabulky
JumpBX1: cmp       word ptr ds:[si],0       ; je konec tabulky ?
         je        JumpBX2                  ; konec tabulky - nenalezeno
         cmp       word ptr ds:[si],bx      ; je to hledaná hodnota ?
         je        JumpBX2                  ; hodnota nalezena
         add       si,4                     ; adresa další položky
         jmp       short JumpBX1            ; test další položky

; ------ nastavení návratové adresy podle tabulky

JumpBX2: mov       si,ds:[si+2]             ; adresa skoku
         mov       ss:[bp+6],si             ; nová návratová adresa

; ------ návrat registrù

         pop       ds
         pop       bp
         pop       si
         ret

JumpBX   ENDP

; -----------------------------------------------------------------------------
;        vstup znaku z klávesnice
; -----------------------------------------------------------------------------

InpChr   PROC      NEAR

; ------ vstup znaku z klávesnice

         sti
         push      ax
         mov       ah,0
         int       16h                      ; vstup znaku z klávesnice
         mov       bx,ax                    ; znak z klávesnice
         pop       ax

; ------ náhrada Ctrl-Break klávesou ESC

         or        bx,bx                    ; je Ctrl-Break ?
         jnz       InpChr2                  ; není Ctrl-Break
         mov       bx,11bh                  ; náhrada klávesou Esc

; ------ konverze na velké písmeno

InpChr2: cmp       bl,"a"
         jb        InpChr3
         cmp       bl,"z"
         ja        InpChr3
         sub       bl,32                    ; konverze na velké písmeno

; ------ úprava ASCII znakù

InpChr3: cmp       bl,0
         je        InpChr4                  ; není ASCII znak
         mov       bh,0

InpChr4: ret

InpChr   ENDP

; -----------------------------------------------------------------------------
;        nastavení kurzoru
; -----------------------------------------------------------------------------

SetKurz  PROC      NEAR

         push      ax
         push      bx
         push      dx

         mov       bh,0
         mov       ah,2
         call      Int10P

         pop       dx
         pop       bx
         pop       ax
         ret

SetKurz  ENDP

; -----------------------------------------------------------------------------
;        vypnutí kurzoru
; -----------------------------------------------------------------------------

KurzOff  PROC      NEAR

         push      ax
         push      bx
         push      dx

         mov       bh,0
         mov       ah,2
         mov       dx,25*256
         call      Int10P

         pop       dx
         pop       bx
         pop       ax
         ret

KurzOff  ENDP

; -----------------------------------------------------------------------------
;        obsluha INT 10h
; -----------------------------------------------------------------------------

Int10P   PROC      NEAR

         push      si
         push      di
         push      bp
         push      ds
         push      es

         int       10h

         pop       es
         pop       ds
         pop       bp
         pop       di
         pop       si
         ret

Int10P   ENDP

;                                                                              
;
;                              Data
;
;                                                                              

; 

SegmVRAM dw        0b000h                   ; videomemory
Zasobnik dw        0                        ; stack pointer

Automat  db        0                        ; automat: 0=no, 1=yes

Hraje    db        0                        ; playing: 0=player, 1=computer

Hrac     db        80h                      ; player color: 80h=white, 0=black
Protihr  db        0                        ; opponent color: 80h=white, 0=black

Uroven   db        1                        ; level

CitTah   dw        1                        ; turn counter

Radek    db        1                        ; current row to print

Kurzor   db        0                        ; current cursor

Rosad    db        0                        ; castling
                                            ;   0=normal
                                            ;   1=small
                                            ;   2=big
                                            ;   3=PxPep

VolTah   db        0                        ; piece selection
                                            ;   0=put
                                            ;   1=waiting
                                            ;   2=holding
Figurka  db        0                        ; current piece
OldPoz   db        0                        ; start position
NewPoz   db        0,0                      ; new position
OldFig   db        0                        ; old piece
HracPoz  db        0                        ; cursor

d_000E   label     byte                     ; start turns
         db        0,0,35,55,10h,0
         db        0,0,34,54,10h,0
         db        0,0,22,43,10h,0
         db        0,0,27,46,10h,0

d_0026   db        39 dup (20h),'$'         ; clear text

MalRosTx db        'O-O',0
VelRosTx db        'O-O-O',0
PxPepTx  db        'PxP',0  ;'PxPep',0

                                          ;* directions
TabSmer  db        9,11,-11,-9              ; 0: angled directions
         db        10,-10,1,-1              ; 4: perpendicular directions
         db        -21,-12,8,19             ; 8: knight left
         db        21,12,-8,-19             ; 12: knight right
         db        10,10,11,9               ; 16: white pawn
         db        -10,-10,-11,-9           ; 20: black pawn

OfsSmer  label     byte                   ;* offsets of directions
         db        20                       ; 0: white pawn
         db        16                       ; 1: black pawn
         db        8                        ; 2: knight
         db        0                        ; 3: bishop
         db        4                        ; 4: rook
         db        0                        ; 5: queen
         db        0                        ; 6: king

NumSmer  label     byte                   ;* number of directions
         db        4                        ; 0: white pawn
         db        4                        ; 1: black pawn
         db        8                        ; 2: knight
         db        4                        ; 3: bishop
         db        4                        ; 4: rook
         db        8                        ; 5: queen
         db        8                        ; 6: king

TabBod   db        0,1,3,3,5,9,10           ; points

                                          ;* chessboard map
Mapa     db        21 dup (0)               ; bottom border
d_00E6   db        10 dup (0)               ; row 1
d_00F0   db        10 dup (0)               ; row 2
d_00FA   db        10 dup (0)               ; row 3
d_0104   db        10 dup (0)               ; row 4
d_010E   db        10 dup (0)               ; row 5
d_0118   db        10 dup (0)               ; row 6
d_0122   db        10 dup (0)               ; row 7
d_012C   db        10 dup (0)               ; row 8
d_0136   db        19 dup (0)               ; top border
Mapa0    label     byte

                                          ;* chessboard map template
MapaIni  db        20 dup(-1)               ; bottom border
         db        -1,4,2,3,5,6,3,2,4,-1    ; row 1 (white)
         db        -1,1,1,1,1,1,1,1,1,-1    ; row 2
         db        -1,0,0,0,0,0,0,0,0,-1    ; row 3
         db        -1,0,0,0,0,0,0,0,0,-1    ; row 4
         db        -1,0,0,0,0,0,0,0,0,-1    ; row 5
         db        -1,0,0,0,0,0,0,0,0,-1    ; row 6
         db        -1,81h,81h,81h,81h,81h,81h,81h,81h,-1 ; row 7
         db        -1,84h,82h,83h,85h,86h,83h,82h,84h,-1 ; row 8 (black)
         db        20 dup(-1)               ; top border

                                                 ;    0=empty square
                                                 ;    1=pawn
                                                 ;    2=knight
                                                 ;    3=bishop
                                                 ;    4=rook
                                                 ;    5=queen
                                                 ;    6=king
                                                 ;    0ffh=invalid square
                                                 ; bit 7: 1=bílá barva,0=èerná

PocFigC  db        0,0                      ; total count of black pieces
BodFigC  dw        6 dup (0)                ; black pointing

PocFigB  db        0,0                      ; total count of white pieces
BodFigB  dw        6 dup (0)                ; white pointing

d_0165   db        10 dup (0)               ; piece positions
d_016F   db        10 dup (0)

KurzB    db        19h                      ; white cursor
KurzC    db        5Fh                      ; black cursor

DamaB    db        18h                      ; white queen position
DamaC    db        5Eh                      ; black queen position

         db        0FFh
d_017E   db        0
d_017F   db        0
         db        10 dup(0)


                                                 ; 0: (2) pointing
                                                 ; 2: (1) old position
                                                 ; 3: (1) destination position
                                                 ; 4: (1) old content of new square
                                                 ; 5: (1)

d_018A   db        40 dup(0)                ; turn table

d_01B2   db        1024 dup(0)

d_05B2   db        1016 dup (0)             ; tabulka tahù

d_09AA   db        8 dup(0)

d_09B2   db        0,0
PozTah   db        0,0                      ; position in turn
PozTst   db        0,0                      ; test position of player
d_09B8   db        0,0
FigTst2  db        0,0                      ; piece

CilFig2  db        0,0                      ; deleted destination piece

d_09BE   db        0,0
d_09C0   dw        0
d_09C2   dw        18Ah                     ; pointer to turn stack
                                            ;  <- 188h
d_09C4   dw        0                        ; pointer to turn stack
d_09C6   dw        0
d_09C8   dw        0                        ; found turn of computer
d_09CA   dw        0
d_09CC   dw        1B2h                     ; pointer of turn stack
                                            ;  <- 5b2h

FigTst1  db        0                        ; figurka pøi pracovním testu
CilFig1  db        0                        ; old content on new square
                                                 ;  0 až 6 - piece
                                                 ;  10h - 2nd turn of castling
                                                 ;  20h - substitute pawn by queen
                                                 ;  40h - 1st turn of castling
                                                 ;  80h - piece color

d_09D2   db        0
d_09D3   db        0                        ; remaining turns
d_09D6   db        0
d_09D7   db        0
d_09D8   db        0
d_09D9   db        0
d_09DA   db        0
d_09DB   db        0
d_09DC   db        0
d_09DD   db        0
d_09DE   db        0
d_09DF   db        0
d_09E0   db        0
d_09E1   db        0
d_09E2   dw        0
d_09E4   dw        0

d_09EC   dw        0
;d_09EE   dw        0                        ; segment PSP


d_0A3A   db        19,'MAT - WHITE WINS !' ; white win

d_0A4A   db        14,'MAT in '
d_0A52   db        'X turns'               ; mat in X turns

d_0A5A   db        20,'MAT - BLACK WINS !'  ; black win
         db        0

d_0A6C   db        0,0                      ; save level

Obrazky  label     byte                     ; pieces

                                            ; 1: pawn
         db        '   o   '
         db        '   ',0B2h,'   '
         db        ' ',0B2h,0B2h,0B2h,0B2h,0B2h,' '
                                            ; 2: knight
         db        ' /^',0B2h,'   '
         db        ' ',0C4h,0C4h,0B2h,0B2h,'  '
         db        ' ',0B2h,0B2h,0B2h,0B2h,0B2h,' '
                                            ; 3: bishop
         db        '  ',0DCh,0B2h,0DCh,'  '
         db        '   ',0B2h,'   '
         db        ' ',0B2h,0B2h,0B2h,0B2h,0B2h,' '
                                            ; 4: rook
         db        ' ',0B2h,' ',0B2h,' ',0B2h,' '
         db        '  ',0B2h,0B2h,0B2h,'  '
         db        ' ',0B2h,0B2h,0B2h,0B2h,0B2h,' '
                                            ; 5: queen
         db        ' . . . '
         db        ' ',0B2h,' ',0B2h,' ',0B2h,' '
         db        '  ',0B2h,0B2h,0B2h,'  '
                                            ; 6: king
         db        '  _+_  '
         db        ' ',0B2h,' ',0B2h,' ',0B2h,' '
         db        ' ',0B2h,0B2h,0B2h,0B2h,0B2h,' '

Text1    db        2,' C H E S S ',0
Text2    db        'version ',1,'1.2',0
Text3    db        '(c) Miroslav Nemecek',0
Text4    db        '- FREEWARE -',0

ColTxt   db        'Choose color (',1,'W',1,'hite/',1,'B',1,'lack/'
         db        1,'A',1,'utomat/',1,'ENTER',1,', ',1,'ESC',1,'=quit): ',1
ColTxt0  db        'W',0
ColTxt1  db        'W',0
CRTxt    db        13,10,0

;UrovTxt  db        'Choose difficulty level (',1,'1',1,' to ',1,'6',1
;         db        ', ',1,'ENTER',1,', ',1,'ESC',1,'=return): ',1
;UrovTxt0 db        '1',0

TahTxt   db        10,'Your turn:'
CekTxt   db        15,'WAIT - My turn:'

PrerTxt  db        14,'Quit (Enter) ?'

         db        13 dup (0)

Code     ENDS

         END       Start
