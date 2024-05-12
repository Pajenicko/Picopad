; Spots
; (c) 1993-2024 Miroslav Nemecek

code     segment
         assume    cs:code,ds:code
         org       100h

MAPASIZE EQU       1000

; ------ initialize videomode

start:   mov       ah,0fh
         int       10h				; get current mode
         cmp       al,7
         je        Start1			; MDA mode
         mov       al,3				; CGA mode 80x25
         mov       byte ptr ds:[SegmVRAM+1],0b8h ; address of CGA videomemory
Start1:  mov       byte ptr ds:[VMod],al 	; save old videomode
         mov       ah,0
         int       10h				; initialize videomode

; ------ switch off cursor

         mov       dx,2000h			; row and column
         mov       ah,2
         mov       bh,0				; page number
         int       10h				; set cursor position

; ------ run demo

         call      Tst

; ------ quit

         mov       ax,ds:[VMod]			; old videomode
         int       10h
         int       20h

; -----------------------------------------------------------------------------
;        demo
; -----------------------------------------------------------------------------

Tst      PROC      NEAR

         mov       word ptr ds:[RandomR],0a534h
         mov       word ptr ds:[RandomR+2],2151h
         mov       byte ptr ds:[Col],9
         mov       byte ptr ds:[CitCol],10
         mov       word ptr ds:[MapaUk],0

         push      ds
         pop       es
         mov       di,offset Mapa
         mov       cx,MAPASIZE
         xor       ax,ax
         cld
         rep       stosw

         call      CekInit			; initialize clock

; ------ clear screen

         mov       es,ds:[SegmVRAM]
         mov       ax,720h
         mov       cx,25*80
         xor       di,di
         cld
         rep       stosw

; ------ prepare address

         mov       di,12*160+80
         mov       bp,80
Tst1:    mov       es,ds:[SegmVRAM]
         mov       ax,5				; range (number of positions)
         call      Random			; generate
         shl       ax,1
         sub       ax,2*2
         add       di,ax
         add       bp,ax
         js        Tst11
         cmp       bp,160
         jb        Tst12

Tst11:   neg       ax
         add       bp,ax
         add       bp,ax
         add       di,ax
         add       di,ax
Tst12:

Tst2:    mov       ax,3
         call      Random
         mov       bx,160
         mul       bx
         sub       ax,160
         add       di,ax
         jns       Tst3
         add       di,160
Tst3:    cmp       di,25*160
         jb        Tst4
         sub       di,160

; ------ generate character

Tst4:
         mov       ax,4
         call      Random
         mov       bx,ax
         mov       bl,ds:[bx+TabCh]

Tst5:    mov       bh,ds:[Col]
         dec       byte ptr ds:[CitCol]
         jnz       Tst62
         mov       ax,3
         call      Random			; generate color
         mov       si,ax
         mov       bh,ds:[si+TabCol]
         mov       ax,120
         call      Random
         add       al,60
         mov       byte ptr ds:[CitCol],al
Tst62:   mov       ds:[Col],bh

         mov       si,ds:[MapaUk]
         mov       si,ds:[Mapa+si]
         mov       word ptr es:[si],720h
         mov       si,ds:[MapaUk]
         mov       ds:[Mapa+si],di
         inc       si
         inc       si
         cmp       si,MAPASIZE*2
         jb        Tst63
         xor       si,si
Tst63:   mov       ds:[MapaUk],si

         mov       es:[di],bx			; write character

; ------ wait - delay

         mov       cx,1
         call      Cekej			; delay

; ------ break

         mov       ah,1
         int       16h
         jnz       Tst7
         jmp       Tst1

Tst7:
         mov       ah,0
         int       16h

; ------ clear screen

         mov       es,ds:[SegmVRAM]
         mov       ax,720h
         mov       cx,25*80
         xor       di,di
         cld
         rep       stosw
         ret

Tst      ENDP

; -----------------------------------------------------------------------------
;                   Random number generator in range 0..AX
; -----------------------------------------------------------------------------

Random   PROC      NEAR

         push      bx
         push      dx
         or        ax,ax
         jz        Random1
         mov       bx,ax			; range
         call      Random0			; generate random number
         xchg      ax,dx
         xor       dx,dx
         div       bx
         xchg      ax,dx
Random1: pop       dx
         pop       bx
         ret

Random   ENDP

; -----------------------------------------------------------------------------

Random0  PROC      NEAR

         push      bx
         push      cx
         mov       ax,word ptr ds:[RandomR]
         mov       bx,word ptr ds:[RandomR+2]
         mov       cx,ax
         mul       word ptr ds:[RandomD]
         shl       cx,1
         shl       cx,1
         shl       cx,1
         add       ch,cl
         add       dx,cx
         add       dx,bx
         shl       bx,1
         shl       bx,1
         add       dx,bx
         add       dh,bl
         mov       cl,5
         shl       bx,cl
         add       dh,bl
         add       ax,1
         adc       dx,0
         mov       word ptr ds:[RandomR],ax
         mov       word ptr ds:[RandomR+2],dx
         pop       cx
         pop       bx
         ret

Random0  ENDP

; -----------------------------------------------------------------------------
;        clock calibration
; -----------------------------------------------------------------------------

CekInit  PROC      NEAR

; ------ save registers

         push      ax
         push      bx
         push      dx
         push      di

         push      ds

; ------ prepare registers

         sti
         xor       ax,ax			; AX <- 0
         mov       ds,ax
         xor       dx,dx			; DX <- 0
         mov       di,46ch

; ------ wait for start

         mov       bx,ds:[di]
CekInit1:cmp       bx,ds:[di]
         je        CekInit1

; ------ measure

         mov       bx,ds:[di]
         EVEN 
CekInit2:add       ax,1
         adc       dx,0
         cmp       bx,ds:[di]
         je        CekInit2

; ------ calculate

         mov       bx,55			; number of milliseconds per tick
         cmp       dx,bx
         jb        CekInit3
         mov       dx,54
CekInit3:div       bx
         or        ax,ax
         jnz       CekInit4
         inc       ax
CekInit4:
         pop       ds
         mov       ds:[Cit1ms],ax		; clock value

; ------ pop registers

         pop       di
         pop       dx
         pop       bx
         pop       ax
         ret

CekInit  ENDP

; -----------------------------------------------------------------------------
;                 wait for CX milliseconds
; -----------------------------------------------------------------------------

Cekej    PROC      NEAR

; ------ save registers

         push      ax
         push      bx
         push      cx
         push      dx
         push      di

; ------ wait

         sti
         jcxz      Cekej9
         mov       di,offset Cit1ms
Cekej1:  xor       ax,ax
         xor       dx,dx

; ------ wait 1 ms

         EVEN
Cekej2:  add       ax,1
         adc       dx,0
         cmp       ax,ds:[di]
         jb        Cekej2

         loop      Cekej1

; ------ pop registers

Cekej9:  pop       di
         pop       dx
         pop       cx
         pop       bx
         pop       ax
         ret

Cekej    ENDP

; -----------------------------------------------------------------------------
;        data
; -----------------------------------------------------------------------------

VMod     dw        3			; save videomode
SegmVRAM dw        0b000h		; segment of videomemory

RandomR  dd        21510d31h		; seed of random number generator
RandomD  dw        8405h

         EVEN
Cit1ms   dw        ?			; loop for 1 ms

Col      db        9
CitCol   db        10

TabCh    db        32,219,220,223
TabCol   db        9,10,12

MapaUk   dw        0			; map pointer
Mapa     dw        MAPASIZE dup(0)	; map table

code     ends
         end       start
