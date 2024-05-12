; Lines
; (c) 1993-2024 Miroslav Nemecek

Code     SEGMENT
         ASSUME    cs:Code,ds:Code

; ------ constants

IncSour  EQU       6			; increment of coordinates, interval
IncSour0 EQU       1			; increment of coordinates, minimal
MaxLine  EQU       40			; number of lines
RozmerB  EQU       80			; line length in bytes
DimX     EQU       640			; X width
DimY     EQU       350			; Y height
NColor   EQU       16			; number of colors

; ------ data - offsets in BP register

XBuffUk  EQU       0			; pointer in records
XJMax    EQU       2			; number of lines with the same color

XX1      EQU       4			; X1 coordinate
XX2      EQU       6			; X2 coordinate
XY1      EQU       8			; Y1 coordinate
XY2      EQU       10			; Y2 coordinate

XdX1     EQU       12			; X1 increment
XdX2     EQU       14			; X2 increment
XdY1     EQU       16			; Y1 increment
XdY2     EQU       18			; Y2 increment

XSegVRAM EQU       20			; videomemory segment

XRandNum EQU       22			; random number

XColor   EQU       26			; current color

XOldVMod EQU       27			; old videomode

					; here should be even address
XBufX1   EQU       28			; X1 record
XBufX2   EQU       2*MaxLine+XBufX1	; X2 record
XBufY1   EQU       4*MaxLine+XBufX1	; Y1 record
XBufY2   EQU       6*MaxLine+XBufX1	; Y2 record

         org       100h

; ------ clear line buffer

Start:   mov       di,offset BufX1
         mov       cx,MaxLine*4
         xor       ax,ax
         cld
         rep       stosw

; ------ initialize videomode

         mov       ah,0fh
         int       10h
         mov       ds:[OldVMod],al	; save old videomode
         mov       ax,16
         int       10h

; ------ pointer of data variables

         mov       bp,offset Data
         mov       es,ss:[bp+XSegVRAM]	; segment of videomemory

; ------ initialize random number generator

         push      ds
         xor       ax,ax
         mov       ds,ax
         mov       ax,ds:[46ch]
         mov       dx,ds:[46eh]
         pop       ds
         mov       word ptr ss:[bp+XRandNum],ax
         mov       word ptr ss:[bp+XRandNum+2],dx

; ------ change color

Start4:  dec       word ptr ss:[bp+XJMax]	; color counter
         jnz       Shows1			; no change

; ------ new color

Shows02: mov       bl,NColor
         call      Random0
         test      al,7
         jz        Shows02			; disable black and gray color
         mov       ss:[bp+XColor],al		; new color

; ------ new count of lines with same colors

         mov       bl,80
         call      Random0
         add       ax,20
         mov       ss:[bp+XJMax],ax		; number of lines with same color

; ------ clear old lines

Shows1:  mov       ah,0
         call      DispLine			; clear old line

; ------ shift X1

         mov       ax,ss:[bp+XX1]
         add       ax,ss:[bp+XdX1]
         jns       Shows21			; not < 0

         call      RandDX
         jmp       short Shows23

Shows21: cmp       ax,DimX
         jl        Shows22			; not > max

         call      RandDX
         neg       ax
Shows23: mov       ss:[bp+XdX1],ax
         add       ax,ss:[bp+XX1]

Shows22: mov       ss:[bp+XX1],ax		; new X1 coordinate

; ------ shift Y1

         mov       ax,ss:[bp+XY1]
         add       ax,ss:[bp+XdY1]
         jns       Shows31			; not < 0

         call      RandDX
         jmp       short Shows33

Shows31: cmp       ax,DimY
         jl        Shows32			; not > max

         call      RandDX
         neg       ax
Shows33: mov       ss:[bp+XdY1],ax
         add       ax,ss:[bp+XY1]

Shows32: mov       ss:[bp+XY1],ax		; new Y1 coordinate

; ------ shift X2

         mov       ax,ss:[bp+XX2]
         add       ax,ss:[bp+XdX2]
         jns       Shows41			; not < 0

         call      RandDX
         jmp       short Shows43

Shows41: cmp       ax,DimX
         jl        Shows42			; not > max

         call      RandDX
         neg       ax
Shows43: mov       ss:[bp+XdX2],ax
         add       ax,ss:[bp+XX2]

Shows42: mov       ss:[bp+XX2],ax		; new X2

; ------ shift Y2

         mov       ax,ss:[bp+XY2]
         add       ax,ss:[bp+XdY2]
         jns       Shows51			; not < 0

         call      RandDX
         jmp       short Shows53

Shows51: cmp       ax,DimY
         jl        Shows52			; not > max

         call      RandDX
         neg       ax
Shows53: mov       ss:[bp+XdY2],ax
         add       ax,ss:[bp+XY2]

Shows52: mov       ss:[bp+XY2],ax		; new Y2

; ------ display new lines + save coordinates

         mov       bx,ss:[bp+XX1]		; start X
         mov       dx,ss:[bp+XY1]		; start Y
         mov       cx,ss:[bp+XX2]		; end X
         mov       si,ss:[bp+XY2]		; end Y
         mov       ds:[di+BufX1],bx
         mov       ds:[di+BufY1],dx
         mov       ds:[di+BufX2],cx
         mov       ds:[di+BufY2],si

         mov       ah,ss:[bp+XColor]		; color
         call      DispLine

; ------ increase pointer in coordinate buffer

         inc       di
         inc       di
         cmp       di,MaxLine*2
         jb        Shows6
         xor       di,di
Shows6:  mov       ss:[bp+XBuffUk],di		; new pointer in buffer

; ------ check program interrupt

         mov       ah,1
         int       16h				; check keyboard
         jnz       Start6			; quit
         jmp       Start4

; ------ quit

Start6:  mov       ah,0
         int       16h

         mov       al,ss:[bp+XOldVMod]		; return old videomode
         mov       ah,0
         int       10h
         int       20h

; -----------------------------------------------------------------------------
;        display lines in buffer - color AH
; -----------------------------------------------------------------------------

DispLine PROC      NEAR

         mov       di,ss:[bp+XBuffUk]		; pointer in buffer
         mov       bx,ds:[di+BufX1]		; start X
         mov       dx,ds:[di+BufY1]		; start Y
         mov       cx,ds:[di+BufX2]		; end X
         mov       si,ds:[di+BufY2]		; end Y
         call      Line				; clear first line

         sub       dx,DimY-1
         neg       dx
         sub       si,DimY-1
         neg       si
         call      Line				; clear 2nd line
         ret

DispLine ENDP

; *****************************************************************************
;                                   RandDX
;                         generate random increment
; -----------------------------------------------------------------------------
; *****************************************************************************

RandDX   PROC      NEAR

         mov       bl,IncSour
         call      Random0
         add       ax,IncSour0
         ret

RandDX   ENDP

; *****************************************************************************
;                                 Random
;                        random number generator
; -----------------------------------------------------------------------------
; INPUT: BX=interval (number of values)
; OUTPUT: AX=random number
; *****************************************************************************

Random0: mov       bh,0

Random   PROC      NEAR

         push      dx
         push      di

         mov       ax,word ptr ss:[bp+XRandNum]
         mov       di,word ptr ss:[bp+XRandNum+2]
         rol       ax,1
         rol       di,1
         xor       al,ss:[di]
         xor       ah,ss:[di+1]
         xor       di,ax
         mov       word ptr ss:[bp+XRandNum],ax
         mov       word ptr ss:[bp+XRandNum+2],di

         xor       dx,dx
         div       bx
         mov       ax,dx

Random9: pop       di
         pop       dx
         ret

Random   ENDP


; *****************************************************************************
;        Display line
; -----------------------------------------------------------------------------
; INPUT: AH=color
;        BX=start X
;        CX=end X
;        DX=start Y
;        SI=end Y
;        ES=videomemory segment
; *****************************************************************************

Line     PROC      NEAR

; ------ save registers

         push      ax
         push      bx
         push      cx
         push      dx
         push      si
         push      di
         push      bp

; ------ correct coordinate order (must be Y2 >= Y1)

         cmp       si,dx
         jge       Line1
         xchg      si,dx
         xchg      bx,cx
Line1:   sub       si,dx

; ------ setup color register

         push      dx
         mov       dx,3ceh
         mov       al,0
         out       dx,al
         inc       dx
         mov       al,ah		; required color
         out       dx,al
         dec       dx

         mov       al,1
         out       dx,al
         inc       dx
         mov       al,0ffh
         out       dx,al
         pop       dx

; ------ calculate address in videomemory

         push      bx
         push      cx
         mov       ax,RozmerB		; line in bytes
         mul       dx
         mov       di,ax
         mov       cl,bl
         shr       bx,1
         shr       bx,1
         shr       bx,1
         add       di,bx

; ------ mask but of start

         mov       dx,03ceh
         and       cl,7
         mov       al,8
         out       dx,al
         inc       dx
         mov       al,80h
         shr       al,cl
         pop       bx
         pop       cx

; ------ check X coordinate, to get slope

         sub       bx,cx		; check X2 - X1
         jns       lin1ega0
         jmp       Lin3EGA		; direction to left

; ------ line goes from top-right


; ------ right steepness sensing

lin1ega0:cmp       bx,si		; compare X increment with Y increment
         jb        Lin2EGA		; the line goes steeply down to the right

; ------ the line goes slightly down to the right

         mov       cx,bx		; the determining factor is the increment X
         inc       cx			; number of line steps
         shl       si,1			; coordinate difference dY*2
         mov       bp,si		; save dY*2
         sub       bp,bx		; dY*2 - dX
         shl       bx,1			; dX*2
         sub       si,bx		; dY*2 - dX*2
         add       bx,si		; dX*2 + dY*2 - dX*2 = dY*2
         mov       ah,al		; mask of the initial bit
Lin1EGA1:or        al,ah
         or        bp,bp
         jns       Lin1EGA2
         add       bp,bx
         jmp       short Lin1EGA3
Lin1EGA2:out       dx,al
         xchg      al,es:[di]
         xor       al,al
         add       di,RozmerB
         add       bp,si
         ror       ah,1
         adc       di,0
         jmp       short Lin1EGA4
Lin1EGA3:ror       ah,1
         jnc       Lin1EGA4
         out       dx,al
         xchg      al,es:[di]
         inc       di
         xor       al,al
Lin1EGA4:loop      Lin1EGA1
         out       dx,al
         xchg      al,es:[di]
         jmp       LinEGA9

; ------ the line goes steeply down to the right

Lin2EGA: mov       cx,si
         inc       cx
         shl       bx,1
         mov       bp,bx
         sub       bp,si
         shl       si,1
         sub       bx,si
         add       si,bx
Lin2EGA1:push      ax
         out       dx,al
         pop       ax
         xchg      ah,es:[di]
         or        bp,bp
         jns       Lin2EGA3
         add       bp,si
         jmp       short Lin2EGA4
Lin2EGA3:ror       al,1
         adc       di,0
;         out       dx,al
         add       bp,bx
Lin2EGA4:add       di,RozmerB
         loop      Lin2EGA1
         jmp       LinEGA9

; ------ the line goes from top left

Lin3EGA: neg       bx
         cmp       bx,si
         jb        Lin4EGA

; ------ the line goes slightly to the right

         mov       cx,bx
         inc       cx
         shl       si,1
         mov       bp,si
         sub       bp,bx
         shl       bx,1
         sub       si,bx
         add       bx,si
         mov       ah,al
Lin3EGA1:or        al,ah
         or        bp,bp
         jns       Lin3EGA3
         add       bp,bx
         jmp       short Lin3EGA4
Lin3EGA3:out       dx,al
         xchg      al,es:[di]
         xor       al,al
         add       di,RozmerB
         add       bp,si
         rol       ah,1
         sbb       di,0
         jmp       short Lin3EGA5
Lin3EGA4:rol       ah,1
         jnb       Lin3EGA5
         out       dx,al
         xchg      al,es:[di]
         dec       di
         xor       al,al
Lin3EGA5:loop      Lin3EGA1
         out       dx,al
         xchg      al,es:[di]
         jmp       LinEGA9

; ------ the line goes steeply to the left

Lin4EGA: mov       cx,si
         inc       cx
         shl       bx,1
         mov       bp,bx
         sub       bp,si
         shl       si,1
         sub       bx,si
         add       si,bx
Lin4EGA1:push      ax
         out       dx,al
         pop       ax
         xchg      ah,es:[di]
         or        bp,bp
         jns       Lin4EGA2
         add       bp,si
         jmp       short Lin4EGA3
Lin4EGA2:rol       al,1
         sbb       di,0
;         out       dx,al
         add       bp,bx
Lin4EGA3:add       di,RozmerB
         loop      Lin4EGA1

; ------ pop registers

LinEGA9: pop       bp
         pop       di
         pop       si
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

Line     ENDP

; *****************************************************************************
;
;                            Data
;
; *****************************************************************************

Data     label     byte

BuffUkaz dw        0			; pointer in records

JMax     dw        1			; number of lines with the same color

X1       dw        320			; X1 coordinate
X2       dw        20			; X2 coordinate
Y1       dw        20			; Y1 coordinate
Y2       dw        200			; Y2 coordinate

dX1      dw        6			; X1 coordinate increment
dX2      dw        6			; X2 coordinate increment
dY1      dw        6			; Y1 coordinate increment
dY2      dw        6			; Y2 coordinate increment

SegVRAM  dw        0a000h		; videomemory segment

RandNum  dd        ?			; random number

Color    db        ?			; current color

OldVMod  db        ?			; old videomode

BufX1    dw        MaxLine dup (?)	; X1 records
BufX2    dw        MaxLine dup (?)	; X2 records
BufY1    dw        MaxLine dup (?)	; Y1 records
BufY2    dw        MaxLine dup (?)	; Y2 records

Code     ENDS

         END       Start
